&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXRMF003 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axrmf003 MAX}
&ENDIF


/*------------------------------------------------------------------------
    File        : axrmf003.p
    Purpose     : Recebimento da transa‡Æo Funcion rios
    Author(s)   : Sandro Kellermann de Carvalho (its0121)
    Created     : Fevereiro/2005
  ----------------------------------------------------------------------*/
/*          This .P file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* DEFINE PRE-PROCESSADORES */
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    204 
&GLOBAL-DEFINE XmlApp            MN2
&GLOBAL-DEFINE XmlTranName       EmployeeAux
&GLOBAL-DEFINE XmlMinTranVersion 000.000
&GLOBAL-DEFINE XmlMaxTranVersion 999.999
&GLOBAL-DEFINE XmlListOfAction   upd,add

/* DEFINE AS VARAIVEIS PARA USO DO xmlloadmessagehandlerrec */
{xmlinc/xmlloadmessagehandlerrecdef.i}         

/* DEFINE AS VARAIVEIS PARA USO DO xmlLoadGenXmlRec */
{xmlinc/xmlloadgenxmlrecdef.i}

{cdp/cd0666.i}         /* Defini‡Æo Temp-Table de Erros                */
{utp/ut-glob.i}        /* Vari veis Globais                            */
 
    DEFINE TEMP-TABLE tt-integr-funcionario-eai no-undo
        field ep-codigo             like mmv-func-ofici.ep-codigo
        field cod-matr              like mmv-func-ofici.cod-matr
        field nom-func              like mmv-func-ofici.nom-func
        field cd-mob-dir            like mmv-func-ofici.cd-mob-dir
        field cod-setor-ofici       like mmv-func-ofici.cod-setor-ofici
        field cc-codigo             like mmv-func-ofici.cc-codigo
        field dat-inicial           like mmv-func-ofici.dat-inicial
        field dat-desativ           like mmv-func-ofici.dat-desativ
        field idi-situacao          like mmv-func-ofici.idi-situacao
        field log-control-hora      like mmv-func-ofici.log-control-hora
        field log-permite-cria-tar  like mmv-func-ofici.log-permite-cria-tar
        field cod-habilit           like mab-motoris.cod-habilit
        FIELD cod-cargo             LIKE mab-integr-cargo.cod-cargo
        FIELD des-cargo             LIKE mab-integr-cargo.des-cargo
        FIELD idi-tip-cargo         LIKE mab-integr-cargo.idi-tip-cargo  /*usado para saber onde efetivar as informa‡äes (tab motoristas ou funcionarios)*/
        FIELD cod-estabel           LIKE mab-eqpto.cod-estabel
        index IntFuncionar is primary unique ep-codigo
                                         cod-matr.

    {frbo/bofr017.i tt-mab-motoris}
    {frbo/bofr032.i tt-mmv-func-ofici}
    {frbo/bofr107.i tt-mab-integr-cargo}

    DEFINE TEMP-TABLE RowErrors NO-UNDO
        FIELD ErrorSequence    AS INTEGER
        FIELD ErrorNumber      AS INTEGER
        FIELD ErrorDescription AS CHARACTER
        FIELD ErrorParameters  AS CHARACTER
        FIELD ErrorType        AS CHARACTER
        FIELD ErrorHelp        AS CHARACTER
        FIELD ErrorSubType     AS CHARACTER
        index seq ErrorSequence. 
        
    DEFINE TEMP-TABLE RowErrorsAux NO-UNDO LIKE RowErrors.


    /* Vari vel de controle do parametro 3 (AB0116) */
    DEFINE VARIABLE cValor LIKE mab-param-integr.des-valor NO-UNDO.

    /* LOG */
    DEFINE VARIABLE cCaminho AS CHARACTER NO-UNDO.
    /* LOG */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 9.38
         WIDTH              = 35.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 

/* ***************************  Main Block  *************************** */

/* DEFINE A PROCEDURE getTransSubsInfo  */
{xmlinc/xmlgettranssubsinfo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-receiveMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveMessage Procedure 
PROCEDURE receiveMessage :
/*------------------------------------------------------------------------------
  Purpose: RECEBE A MENSAGEM DO CONTROL BROKER E PROCESSA A MESMA PARA ENTREGAR AO DESTINO
  Parameters: pInputXml, pOutputXml
  Notes:       
------------------------------------------------------------------------------*/

    /* PARAMENTROS DE ENTRADA E SAIDA */
    DEF INPUT  PARAM hInputXML  AS HANDLE NO-UNDO.
    DEF OUTPUT PARAM hOutputXML AS HANDLE NO-UNDO.

    /* VARIAVEIS LOCAIS */
    DEF VAR hBusinessContent AS HANDLE NO-UNDO.
    DEF VAR lSuccessProcess  AS LOG    NO-UNDO.
    DEF VAR cValue           AS CHAR   NO-UNDO.
    DEF VAR cNodeName        AS CHAR   NO-UNDO.
    DEF VAR iIdList          AS INT    NO-UNDO.
    DEF VAR iIdLine          AS INT    NO-UNDO.
    DEF VAR iIdNext          AS INT    NO-UNDO.
    DEF VAR cTranEvent       AS CHAR   NO-UNDO.
    DEF VAR cTranVersion     AS CHAR   NO-UNDO.
    DEF VAR cErrorText       AS CHAR   NO-UNDO.
    DEF VAR iCount           AS INT    NO-UNDO.
    DEF VAR cListRootSon     AS CHAR   NO-UNDO.
    DEF VAR iContRootSon     AS INT    NO-UNDO.
    DEF VAR hGenXml          AS HANDLE NO-UNDO. 
    DEF VAR hMessageHandler  AS HANDLE NO-UNDO.
    DEF VAR cReturnValue     AS CHAR   NO-UNDO.
    DEF VAR cTranAction      AS CHAR   NO-UNDO.
    DEF VAR cCCCodigo        AS CHAR   NO-UNDO.
    DEF VAR cBusinessUnit    AS CHAR   NO-UNDO.

     /* Defini‡Æo de vari veis*/                                           
    DEFINE VARIABLE h-boMotoris AS HANDLE     NO-UNDO.
    DEFINE VARIABLE h-boFunc    AS HANDLE     NO-UNDO.
    DEFINE VARIABLE h-boCargo   AS HANDLE     NO-UNDO.

    DEFINE VARIABLE iEmployeeId              AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iEmployeeSonId           AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iEmployeeKeyId           AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iEmployeeSiteCod         AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iEmployeeDocumentId      AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iEmpl-PrivateCitizenId   AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iAllocationInformationId AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iId                      AS INTEGER    NO-UNDO.

    DEFINE VARIABLE l-cargo AS LOGICAL    NO-UNDO.

    DEFINE VARIABLE iErro      AS INTEGER    NO-UNDO.
    DEFINE VARIABLE c-liter    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dec-aux    AS DECIMAL    NO-UNDO. 

     /** Limpa TT de cargos **/
     FOR EACH tt-mab-integr-cargo EXCLUSIVE-LOCK:
         DELETE tt-mab-integr-cargo.
     END.

     FOR FIRST mab-param-integr
         WHERE mab-param-integr.cdn-param = 3 NO-LOCK:
         ASSIGN cValor = mab-param-integr.des-valor.
     END.

     /* LOG */
     ASSIGN cCaminho = trim(SESSION:TEMP-DIRECTORY + "log-xml.txt").

    /* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
    {xmlinc/xmlloadmessagehandlerrec.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue" &MHReturnError="hOutputXML"}

    /* VERIFICA SE O MessageHandler FOI EXECUTADO CORRETAMENTE */

    IF  cReturnValue <> "OK":U THEN 
     IF cReturnValue <> ? AND cReturnValue <> "" THEN 
        RUN setError IN hMessageHandler (INPUT 0,
                                         INPUT "enviroment_error":U,
                                         INPUT cReturnValue).

    /* FAZ A INTERPRETA°€O E ALGUNS PROCESSOS NA MENSAGEM QUE RECEBE */
    RUN parseMessage IN hMessageHandler (INPUT  hInputXml,
                                         INPUT "{&XmlTranName}",
                                         INPUT "{&XmlMaxTranVersion}",
                                         INPUT "{&XmlMinTranVersion}",
                                         INPUT 
                                         &IF DEFINED(XmlListOfEvents) <> 0
                                         &THEN "{&XmlListOfEvents}",
                                         &ELSE "",
                                         &ENDIF
                                         OUTPUT lSuccessProcess,
                                         OUTPUT cTranAction,
                                         OUTPUT cTranEvent,
                                         OUTPUT cTranVersion,
                                         OUTPUT hOutputXML ).

    /* SE N€O PROCESSOU CORRETAMENTE RETORNA ERRO */
    IF NOT lSuccessProcess OR
       RETURN-VALUE <> "OK" THEN DO:
       IF cReturnValue <> ? AND cReturnValue <> " " THEN DO:
          RUN setError IN hMessageHandler (INPUT 0,
                                           INPUT "enviroment_error":U,
                                           INPUT cReturnValue).
       END.
    END.
    ELSE DO:
        /* OBTEM A PARTE DA MENSAGEM QUE EST‘ ABAIXO DO ELEMENTO BusinessContent */
        RUN getBusinessContent IN hMessageHandler (OUTPUT hBusinessContent).
        /* VERIFICA SE APIXML ESTA NA MEMORIA */
        {xmlinc/xmlloadgenxmlrec.i &GenXml="hGenXml" &GXReturnValue="cReturnValue" &GXReturnError="hOutputXML"}
        /* VERIFICA SE O ut-genxml FOI INICIADO CORRETAMENTE */
        IF  cReturnValue <> "OK":U THEN 
            IF cReturnValue <> ? AND cReturnValue <> "" THEN DO:
               DELETE OBJECT hBusinessContent NO-ERROR.
               RUN setError IN hMessageHandler (INPUT 0,
                                                INPUT "enviroment_error":U,
                                                INPUT cReturnValue).
            END.
        /* ****************** OBTEM OS VALORES DOS ELEMENTOS ABAIXO DO BusinessContent ****************** */
        /* LIMPA AS TEMP-TABLES INTERNAS DA API XML */
        RUN reset IN hGenXml.

        /* CARREGA A ESTRUTURA FILHA DE BusinessContent */
        RUN loadXml IN hGenXml (hBusinessContent).

        /* ELIMINA A MENSAGEM OBTIDA NO MÔTODO getBusinessContent */
        DELETE OBJECT hBusinessContent NO-ERROR.

        /*tag ListOfEmployee*/
        RUN searchTag IN hGenXml ("ListOfEmployee":U, 1, OUTPUT iEmployeeId).
        IF iEmployeeId <> ? THEN DO:
              RUN getFirstSonId IN hGenXml (iEmployeeId, OUTPUT iEmployeeSonId).
              DO WHILE iEmployeeSonId <> ?:  /*este bloco ir  repetir enquanto houverem funcion rios dispon¡veis na mensagem xml*/

                  /*cria um registro na temp-table*/
                  CREATE tt-integr-funcionario-eai.

                  /* Busca dentro da TAG EmployeeKey pela Empresa e Estabelecimento do funcion rio */
                  RUN searchTag IN hGenXml ("EmployeeKey":U, iEmployeeSonId, OUTPUT iEmployeeKeyId).
                  IF iEmployeeKeyId <> ? THEN DO:
                      RUN getSonDec  IN hGenXml (INPUT iEmployeeKeyId, INPUT "CompanyCode":U, OUTPUT tt-integr-funcionario-eai.ep-codigo).
                      RUN getSonDec  IN hGenXml (INPUT iEmployeeKeyId, INPUT "SiteCode":U, OUTPUT tt-integr-funcionario-eai.cod-estabel).
                  END.

                  IF cValor = "2" THEN DO:
                      /*tag Empl-PrivateCitizen*/
                      RUN searchTag IN hGenXml ("Empl-PrivateCitizen":U, iEmployeeSonId, OUTPUT iEmployeeKeyId).
                      IF iEmployeeKeyId <> ? THEN DO:
                          /* Conforme FO 1339.307 (Usina Colombo) = Se o Parƒmetro 3 da tabela de Parƒmetros de Integra‡Æo estiver com valor = 1 (Matr¡cula), o adapter busca o c½digo da matricula do funcionario. */
                          RUN getSonDec  IN hGenXml (INPUT iEmployeeKeyId, INPUT "PrivateCitizen":U, OUTPUT dec-aux).
                      END. /*IF iEmployeeKeyId <> ?*/
                  END.
                  ELSE DO:
                      IF iEmployeeKeyId <> ? THEN DO:
                          /* Conforme FO 1339.307 (Usina Colombo) = Se o Parƒmetro 3 da tabela de Parƒmetros de Integra‡Æo estiver com valor = 1 (Matr¡cula), o adapter busca o c½digo da matricula do funcionario. */
                          RUN getSonDec  IN hGenXml (INPUT iEmployeeKeyId, INPUT "EmployeeCode":U, OUTPUT dec-aux).
                      END.
                  END. /*IF iEmployeeKeyId <> ?*/

                  ASSIGN tt-integr-funcionario-eai.cod-matr = string(dec-aux).

                  /*tag EmployeeDocument*/
                  RUN searchTag IN hGenXml ("EmployeeDocument":U, iEmployeeSonId, OUTPUT iEmployeeDocumentId).
                  IF iEmployeeDocumentId <> ? THEN DO:
                     RUN getSonDec  IN hGenXml (INPUT iEmployeeDocumentId, INPUT "DriverLicense":U, OUTPUT dec-aux).
                     ASSIGN tt-integr-funcionario-eai.cod-habilit = string(dec-aux).
                  END.
                  /*tag Empl-PrivateCitizen*/
                  RUN searchTag IN hGenXml ("Empl-PrivateCitizen":U, iEmployeeSonId, OUTPUT iEmpl-PrivateCitizenId).
                  IF iEmpl-PrivateCitizenId <> ? THEN
                     RUN getSonVal IN hGenXml (INPUT iEmpl-PrivateCitizenId, INPUT "Name":U, OUTPUT tt-integr-funcionario-eai.nom-func).


                  RUN getSonVal IN hGenXml (INPUT iEmployeeSonId, INPUT "PositionDescription":U, OUTPUT tt-integr-funcionario-eai.des-cargo).

                  /*tag AllocationInformation*/
                  RUN searchTag IN hGenXml ("AllocationInformation":U, iEmployeeSonId, OUTPUT iAllocationInformationId).
                  IF iAllocationInformationId <> ? THEN DO:
                     RUN getSonVal IN hGenXml (INPUT iAllocationInformationId, INPUT "CostCenter":U, OUTPUT cCCCodigo).
                     RUN getSonVal IN hGenXml (INPUT iAllocationInformationId, INPUT "BusinessUnit":U, OUTPUT cBusinessUnit).
                     ASSIGN tt-integr-funcionario-eai.cc-codigo = cCCCodigo.
                     FOR FIRST mab-param-integr 
                         WHERE mab-param-integr.cdn-param = 13 NO-LOCK:
                         IF  ENTRY(1,mab-param-integr.des-valor) = "1":U THEN DO:
                             IF ENTRY(2,mab-param-integr.des-valor) = "1":U THEN
                                 ASSIGN tt-integr-funcionario-eai.cc-codigo = cCCCodigo + cBusinessUnit.
                              ELSE
                                  ASSIGN tt-integr-funcionario-eai.cc-codigo = cBusinessUnit + cCCCodigo.

                         END.
                     END.
                     
                     /*buscando cod-setor-ofici conforme cc-codigo, atrav‚s da tabela mmv-setor-ofici*/
                     FIND FIRST mmv-setor-ofici WHERE mmv-setor-ofici.cc-codigo = tt-integr-funcionario-eai.cc-codigo NO-LOCK NO-ERROR.
                     IF AVAIL mmv-setor-ofici THEN
                         ASSIGN tt-integr-funcionario-eai.cod-setor-ofici = mmv-setor-ofici.cod-setor-ofici.
                     ELSE
                         FIND FIRST mmv-setor-ofici NO-LOCK NO-ERROR.
                         IF AVAIL mmv-setor-ofici THEN
                             ASSIGN tt-integr-funcionario-eai.cod-setor-ofici = mmv-setor-ofici.cod-setor-ofici.
                     RUN getSonDec IN hGenXml (INPUT iAllocationInformationId, INPUT "BasicPosition":U, OUTPUT dec-aux).
                     ASSIGN tt-integr-funcionario-eai.cod-cargo = STRING(dec-aux).
                     /*FAZER AS VALIDA€åES PARA CARGO.*/
                     FIND FIRST mab-integr-cargo WHERE mab-integr-cargo.cod-cargo = trim(tt-integr-funcionario-eai.cod-cargo) NO-LOCK NO-ERROR.
                     IF AVAIL mab-integr-cargo THEN DO:
                         ASSIGN tt-integr-funcionario-eai.idi-tip-cargo        = mab-integr-cargo.idi-tip-cargo 
                                tt-integr-funcionario-eai.cd-mob-dir           = mab-integr-cargo.cod-mob-dir
                                tt-integr-funcionario-eai.log-permite-cria-tar = mab-integr-cargo.log-permite-cria-tar
                                tt-integr-funcionario-eai.log-control-hora     = mab-integr-cargo.log-control-hora.
                         /** Cria altera‡Æo da descri‡Æo do cargo **/
                         CREATE tt-mab-integr-cargo.
                         {utp/ut-liter.i "Cargo Pendente de Atualiza‡Æo" * }
                         BUFFER-COPY mab-integr-cargo EXCEPT des-cargo TO tt-mab-integr-cargo
                             ASSIGN tt-mab-integr-cargo.r-rowid   = ROWID(mab-integr-cargo)
                                    tt-mab-integr-cargo.des-cargo = IF tt-integr-funcionario-eai.des-cargo = "" 
                                                                    THEN RETURN-VALUE 
                                                                    ELSE tt-integr-funcionario-eai.des-cargo.
                     END. /*IF AVAIL mab-integr-cargo*/
                     ELSE DO: /* NÇO EXISTE AINDA ESSE CARGO CADASTRADO. GRAVANDO DADOS DO CARGO NA TEMP-TABLE DE CARGOS */ 
                         CREATE tt-mab-integr-cargo.
                         {utp/ut-liter.i "Cargo Pendente de Atualiza‡Æo" * }
                         ASSIGN tt-mab-integr-cargo.cod-cargo            = tt-integr-funcionario-eai.cod-cargo
                                tt-mab-integr-cargo.des-cargo            = IF tt-integr-funcionario-eai.des-cargo = "" 
                                                                           THEN RETURN-VALUE 
                                                                           ELSE tt-integr-funcionario-eai.des-cargo
                                tt-mab-integr-cargo.r-rowid              = ?
                                tt-mab-integr-cargo.idi-tip-cargo        = 1
                                tt-mab-integr-cargo.log-control-hora     = YES
                                tt-mab-integr-cargo.log-permite-cria-tar = NO
                                tt-integr-funcionario-eai.idi-tip-cargo  = 1. /*essa informa‡Æo me possibilita sair da grava‡Æo deste funcionario*/
                     END.
                  END. /*IF iAllocationInformationId <> ?*/

                  RUN getSonDate IN hGenXml (INPUT iEmployeeSonId, INPUT "AdmissionDate":U, OUTPUT tt-integr-funcionario-eai.dat-inicial).
                  RUN getSonDate IN hGenXml (INPUT iEmployeeSonId, INPUT "SeveranceDate":U, OUTPUT tt-integr-funcionario-eai.dat-desat).
                  IF  tt-integr-funcionario-eai.dat-desat <> ? THEN
                      ASSIGN tt-integr-funcionario-eai.idi-situacao = 2.
                  ELSE
                      ASSIGN tt-integr-funcionario-eai.idi-situacao = 1.

                  /*incrementando */
                  ASSIGN iId = iEmployeeSonId.   
                  RUN GetNextSonId IN hGenXml (iEmployeeId, iId, OUTPUT iEmployeeSonId).
              END. /* DO WHILE iEmployeeSonId */
        END. /*IF iEmployeeId <> ?*/


        /*** EFETIVA€ÇO DOS DADOS - CHAMADA DAS BO'S ***/

        /******************************/
        /*rodando as bo's persistentes*/
        /******************************/
        IF CAN-FIND (FIRST tt-integr-funcionario-eai WHERE tt-integr-funcionario-eai.idi-tip-cargo = 2
                                                        OR tt-integr-funcionario-eai.idi-tip-cargo = 4 NO-LOCK) THEN DO:
            IF search("frbo/bofr017.p") <> ? OR           
               search("frbo/bofr017.r") <> ?   THEN
                IF NOT VALID-HANDLE(h-boMotoris) OR
                   h-boMotoris:TYPE <> "PROCEDURE":U OR
                   h-boMotoris:FILE-NAME <> "frbo/bofr017.p":U THEN DO:
                       run frbo/bofr017.p persistent set h-boMotoris.
                       RUN openQueryStatic IN h-boMotoris (INPUT "Main":U) NO-ERROR.
                       RUN emptyRowErrors IN h-boMotoris.
                END. /*IF NOT VALID-HANDLE*/
            ELSE DO: /* Programa de efetiva‡Æo nÆo localizado */
                {utp/ut-liter.i Erro_de_integra‡Æo._NÆo_foi_poss¡vel_localizar_o_programa_frbo/bofr017.p_a_ser_executado_pelo_programa_adapters/xml/ma2/axrmf003.p. *}
                RUN setError IN hMessageHandler (INPUT 17006,
                                                 INPUT "enviroment_error":U,
                                                 INPUT RETURN-VALUE).
            END. /*else*/
        END. /*if can-find*/

        IF CAN-FIND (FIRST tt-integr-funcionario-eai WHERE tt-integr-funcionario-eai.idi-tip-cargo = 3 
                                                        OR tt-integr-funcionario-eai.idi-tip-cargo = 4 NO-LOCK) THEN DO:
            IF search("frbo/bofr032.p") <> ? OR           
               search("frbo/bofr032.r") <> ?   THEN
                IF NOT VALID-HANDLE(h-boFunc) OR
                   h-boFunc:TYPE <> "PROCEDURE":U OR
                   h-boFunc:FILE-NAME <> "frbo/bofr032.p":U THEN DO:
                       run frbo/bofr032.p persistent set h-boFunc.
                       RUN openQueryStatic IN h-boFunc (INPUT "Main":U) NO-ERROR.
                       RUN emptyRowErrors IN h-boFunc.
                END. /*IF NOT VALID-HANDLE*/
            ELSE DO: /* Programa de efetiva‡Æo nÆo localizado */
                {utp/ut-liter.i Erro_de_integra‡Æo._NÆo_foi_poss¡vel_localizar_o_programa_frbo/bofr032.p_a_ser_executado_pelo_programa_adapters/xml/ma2/axrmf003.p. *}
                RUN setError IN hMessageHandler (INPUT 17006,
                                                 INPUT "enviroment_error":U,
                                                 INPUT RETURN-VALUE).
            END. /*else*/
        END. /*if can-find*/

        IF CAN-FIND (FIRST tt-mab-integr-cargo NO-LOCK) THEN DO:
            IF search("frbo/bofr107.p") <> ? OR           
               search("frbo/bofr107.r") <> ?   THEN
                IF NOT VALID-HANDLE(h-boCargo) OR
                   h-boCargo:TYPE <> "PROCEDURE":U OR
                   h-boCargo:FILE-NAME <> "frbo/bofr107.p":U THEN DO:
                       run frbo/bofr107.p persistent set h-boCargo.
                       RUN openQueryStatic IN h-boCargo (INPUT "Main":U) NO-ERROR.
                       RUN emptyRowErrors IN h-boCargo.
                END. /*IF NOT VALID-HANDLE*/
            ELSE DO: /* Programa de efetiva‡Æo nÆo localizado */
                {utp/ut-liter.i Erro_de_integra‡Æo._NÆo_foi_poss¡vel_localizar_o_programa_frbo/bofr0107.p_a_ser_executado_pelo_programa_adapters/xml/ma2/axrmf003.p. *}
                RUN setError IN hMessageHandler (INPUT 17006,
                                                 INPUT "enviroment_error":U,
                                                 INPUT RETURN-VALUE).
            END. /*else*/                             
        END. /*if can-find*/

        FOR EACH tt-integr-funcionario-eai NO-LOCK:
            CASE tt-integr-funcionario-eai.idi-tip-cargo:
                /*indica onde serÆo efetivados os dados da mensagem.
                1 = nÆo efetiva a mensagem
                2 = efetiva na tabela de motoristas
                3 = efetiva na tabela de funcionarios da oficina
                4 = efetiva em ambas as tabelas */

                WHEN 2 THEN DO:
                    /*efetiva na tabela de motorista*/
                    CREATE tt-mab-motoris.
                    ASSIGN tt-mab-motoris.cod-estado  = ""
                           tt-mab-motoris.cod-habilit = tt-integr-funcionario-eai.cod-habilit
                           tt-mab-motoris.ep-codigo   = tt-integr-funcionario-eai.ep-codigo
                           tt-mab-motoris.cod-estabel = tt-integr-funcionario-eai.cod-estabel
                           tt-mab-motoris.cod-matr    = tt-integr-funcionario-eai.cod-matr
                           tt-mab-motoris.cod-pais    = ""
                           tt-mab-motoris.nom-motoris = tt-integr-funcionario-eai.nom-func.
                    
                    /*--- executa o afterUpdateRecord no registro cocorrente do DBO ---*/
                    IF CAN-FIND (FIRST mab-motoris WHERE mab-motoris.ep-codigo   = tt-mab-motoris.ep-codigo
                                                     AND mab-motoris.cod-estabel = tt-mab-motoris.cod-estabel 
                                                     AND mab-motoris.cod-matr    = tt-mab-motoris.cod-matr NO-LOCK) THEN DO:
                        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
                        RUN goToKey   IN h-boMotoris (INPUT tt-mab-motoris.ep-codigo, 
                                                      INPUT tt-mab-motoris.cod-estabel, 
                                                      INPUT tt-mab-motoris.cod-matr).
                        RUN getRowid  IN h-boMotoris (OUTPUT tt-mab-motoris.r-rowid).
                        /*--- Transfere temp-table tt-mab-eqpto para o DBO ---*/
                        RUN setRecord IN h-boMotoris (INPUT TABLE tt-mab-motoris).
                        RUN updateRecord IN h-boMotoris.
                    END.
                    ELSE DO:
                        /*--- Transfere temp-table tt-mab-eqpto para o DBO ---*/
                        RUN setRecord IN h-boMotoris (INPUT TABLE tt-mab-motoris).
                        RUN createRecord IN h-boMotoris.
                    END.

                    /*--- Verifica ocorrˆncia de erros durante a transa‡Æo ---*/
                    IF return-value = "NOK":U THEN DO:
                        /*--- Retorna temp-table RowErrors do DBO ---*/
                        RUN getRowErrors IN h-boMotoris (OUTPUT TABLE RowErrorsAux). 
                        assign iErro = 0.
                        /** Busca £ltimo erro criado na BO **/
                        for last RowErrors no-lock:
                            assign iErro = RowErrors.ErrorSequence.
                        end.
                        /** Percorre os erros da BO **/
                        for each RowErrorsAux no-lock:
                            /** Cria eros na BO **/
                            create RowErrors.
                            buffer-copy RowErrorsAux except ErrorSequence to RowErrors
                                /** Coloca sequˆncia **/
                                assign RowErrors.ErrorSequence = iErro + 1.
                            assign iErro = RowErrors.ErrorSequence.
                        end.
                    end.

                END. /*when 2*/
                WHEN 3 THEN DO:
                    /*efetiva na tabela de funcionarios da oficina*/
                    CREATE tt-mmv-func-ofici.
                    ASSIGN tt-mmv-func-ofici.cc-codigo            = tt-integr-funcionario-eai.cc-codigo            
                           tt-mmv-func-ofici.cd-mob-dir           = tt-integr-funcionario-eai.cd-mob-dir           
                           tt-mmv-func-ofici.cod-estabel          = tt-integr-funcionario-eai.cod-estabel
                           tt-mmv-func-ofici.cod-matr             = tt-integr-funcionario-eai.cod-matr             
                           tt-mmv-func-ofici.cod-setor-ofici      = tt-integr-funcionario-eai.cod-setor-ofici      
                           tt-mmv-func-ofici.dat-desativ          = tt-integr-funcionario-eai.dat-desativ          
                           tt-mmv-func-ofici.dat-inicial          = tt-integr-funcionario-eai.dat-inicial          
                           tt-mmv-func-ofici.ep-codigo            = tt-integr-funcionario-eai.ep-codigo            
                           tt-mmv-func-ofici.idi-situacao         = tt-integr-funcionario-eai.idi-situacao         
                           tt-mmv-func-ofici.log-control-hora     = tt-integr-funcionario-eai.log-control-hora     
                           tt-mmv-func-ofici.log-permite-cria-tar = tt-integr-funcionario-eai.log-permite-cria-tar 
                           tt-mmv-func-ofici.nom-func             = tt-integr-funcionario-eai.nom-func.            
                                                                                                                    
                    /*--- executa o afterUpdateRecord no registro cocorrente do DBO ---*/
                    IF CAN-FIND (FIRST mmv-func-ofici WHERE mmv-func-ofici.ep-codigo   = tt-mmv-func-ofici.ep-codigo
                                                        AND mmv-func-ofici.cod-estabel = tt-mmv-func-ofici.cod-estabel
                                                        AND mmv-func-ofici.cod-matr    = tt-mmv-func-ofici.cod-matr  NO-LOCK) THEN DO:
                        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
                        RUN goToKey   IN h-boFunc (INPUT tt-mmv-func-ofici.ep-codigo,
                                                   INPUT tt-mmv-func-ofici.cod-estabel,
                                                   INPUT tt-mmv-func-ofici.cod-matr).

                        RUN getrowid IN h-boFunc (OUTPUT tt-mmv-func-ofici.r-rowid).
                                                 
                        /*--- Transfere temp-table tt-mab-eqpto para o DBO ---*/
                        RUN setRecord IN h-boFunc (INPUT TABLE tt-mmv-func-ofici).
                        RUN updateRecord IN h-boFunc.
                    END.
                    ELSE DO:
                        /*--- Transfere temp-table tt-mab-eqpto para o DBO ---*/
                        RUN setRecord IN h-boFunc (INPUT TABLE tt-mmv-func-ofici).
                        RUN createRecord IN h-boFunc.
                    END.

                    /*--- Verifica ocorrˆncia de erros durante a transa‡Æo ---*/
                    IF return-value = "NOK":U THEN DO:

                        /*--- Retorna temp-table RowErrors do DBO ---*/
                        RUN getRowErrors IN h-boFunc (OUTPUT TABLE RowErrorsAux). 
                        assign iErro = 0.
                        /** Busca £ltimo erro criado na BO **/
                        for last RowErrors no-lock:
                            assign iErro = RowErrors.ErrorSequence.
                        end.
                        /** Percorre os erros da BO **/
                        for each RowErrorsAux no-lock:
                            /** Cria eros na BO **/
                            create RowErrors.
                            buffer-copy RowErrorsAux except ErrorSequence to RowErrors
                                /** Coloca sequˆncia **/
                                assign RowErrors.ErrorSequence = iErro + 1.
                            assign iErro = RowErrors.ErrorSequence.
                        end.
                    end.
                END. /*when 3*/
                WHEN 4 THEN DO:
                    /*efetiva em ambas as tabelas*/
                    /*efetiva na tabela de motorista*/
                    CREATE tt-mab-motoris.
                    ASSIGN tt-mab-motoris.cod-estado  = ""
                           tt-mab-motoris.cod-habilit = tt-integr-funcionario-eai.cod-habilit
                           tt-mab-motoris.ep-codigo   = tt-integr-funcionario-eai.ep-codigo
                           tt-mab-motoris.cod-estabel = tt-integr-funcionario-eai.cod-estabel
                           tt-mab-motoris.cod-matr    = tt-integr-funcionario-eai.cod-matr
                           tt-mab-motoris.cod-pais    = ""
                           tt-mab-motoris.nom-motoris = tt-integr-funcionario-eai.nom-func.
                    IF CAN-FIND (FIRST mab-motoris WHERE mab-motoris.ep-codigo   = tt-mab-motoris.ep-codigo
                                                     AND mab-motoris.cod-estabel = tt-mab-motoris.cod-estabel 
                                                     AND mab-motoris.cod-matr    = tt-mab-motoris.cod-matr NO-LOCK) THEN DO:
                        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
                        RUN goToKey   IN h-boMotoris (INPUT tt-mab-motoris.ep-codigo, 
                                                      INPUT tt-mab-motoris.cod-estabel, 
                                                      INPUT tt-mab-motoris.cod-matr).
                        RUN getRowid  IN h-boMotoris (OUTPUT tt-mab-motoris.r-rowid).
                        /*--- Transfere temp-table tt-mab-eqpto para o DBO ---*/
                        RUN setRecord IN h-boMotoris (INPUT TABLE tt-mab-motoris).
                        RUN updateRecord IN h-boMotoris.
                    END.
                    ELSE DO:
                        /*--- Transfere temp-table tt-mab-eqpto para o DBO ---*/
                        RUN setRecord IN h-boMotoris (INPUT TABLE tt-mab-motoris).
                        RUN createRecord IN h-boMotoris.
                    END.

                    
                    /*--- Verifica ocorrˆncia de erros durante a transa‡Æo ---*/
                    IF return-value = "NOK":U THEN DO:
                        /*--- Retorna temp-table RowErrors do DBO ---*/
                        RUN getRowErrors IN h-boMotoris (OUTPUT TABLE RowErrorsAux). 
                        assign iErro = 0.
                        /** Busca £ltimo erro criado na BO **/
                        for last RowErrors no-lock:
                            assign iErro = RowErrors.ErrorSequence.
                        end.
                        /** Percorre os erros da BO **/
                        for each RowErrorsAux no-lock:
                            /** Cria eros na BO **/
                            create RowErrors.
                            buffer-copy RowErrorsAux except ErrorSequence to RowErrors
                                /** Coloca sequˆncia **/
                                assign RowErrors.ErrorSequence = iErro + 1.
                            assign iErro = RowErrors.ErrorSequence.
                        end.
                    end.
                    /*efetiva na tabela de funcionarios da oficina*/
                    CREATE tt-mmv-func-ofici.
                    ASSIGN tt-mmv-func-ofici.cc-codigo            = tt-integr-funcionario-eai.cc-codigo
                           tt-mmv-func-ofici.cd-mob-dir           = tt-integr-funcionario-eai.cd-mob-dir
                           tt-mmv-func-ofici.cod-estabel          = tt-integr-funcionario-eai.cod-estabel
                           tt-mmv-func-ofici.cod-matr             = tt-integr-funcionario-eai.cod-matr 
                           tt-mmv-func-ofici.cod-setor-ofici      = tt-integr-funcionario-eai.cod-setor-ofici
                           tt-mmv-func-ofici.dat-desativ          = tt-integr-funcionario-eai.dat-desativ
                           tt-mmv-func-ofici.dat-inicial          = tt-integr-funcionario-eai.dat-inicial
                           tt-mmv-func-ofici.ep-codigo            = tt-integr-funcionario-eai.ep-codigo  
                           tt-mmv-func-ofici.idi-situacao         = tt-integr-funcionario-eai.idi-situacao 
                           tt-mmv-func-ofici.log-control-hora     = tt-integr-funcionario-eai.log-control-hora 
                           tt-mmv-func-ofici.log-permite-cria-tar = tt-integr-funcionario-eai.log-permite-cria-tar
                           tt-mmv-func-ofici.nom-func             = tt-integr-funcionario-eai.nom-func.

                    /*--- executa o afterUpdateRecord no registro cocorrente do DBO ---*/
                    IF CAN-FIND (FIRST mmv-func-ofici WHERE mmv-func-ofici.ep-codigo   = tt-mmv-func-ofici.ep-codigo
                                                        AND mmv-func-ofici.cod-estabel = tt-mmv-func-ofici.cod-estabel
                                                        AND mmv-func-ofici.cod-matr    = tt-mmv-func-ofici.cod-matr  NO-LOCK) THEN DO:
                        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
                        RUN goToKey   IN h-boFunc (INPUT tt-mmv-func-ofici.ep-codigo,
                                                   INPUT tt-mmv-func-ofici.cod-estabel,
                                                   INPUT tt-mmv-func-ofici.cod-matr).

                        RUN getrowid IN h-boFunc (OUTPUT tt-mmv-func-ofici.r-rowid).
                                                 
                        /*--- Transfere temp-table tt-mab-eqpto para o DBO ---*/
                        RUN setRecord IN h-boFunc (INPUT TABLE tt-mmv-func-ofici).
                        RUN updateRecord IN h-boFunc.
                    END.
                    ELSE DO:
                        /*--- Transfere temp-table tt-mab-eqpto para o DBO ---*/
                        RUN setRecord IN h-boFunc (INPUT TABLE tt-mmv-func-ofici).
                        RUN createRecord IN h-boFunc.
                    END.

                    /*--- Verifica ocorrˆncia de erros durante a transa‡Æo ---*/
                    IF return-value = "NOK":U THEN DO:
                        /*--- Retorna temp-table RowErrors do DBO ---*/
                        RUN getRowErrors IN h-boFunc (OUTPUT TABLE RowErrorsAux). 
                        assign iErro = 0.
                        /** Busca £ltimo erro criado na BO **/
                        for last RowErrors no-lock:
                            assign iErro = RowErrors.ErrorSequence.
                        end.
                        /** Percorre os erros da BO **/
                        for each RowErrorsAux no-lock:
                            /** Cria eros na BO **/
                            create RowErrors.
                            buffer-copy RowErrorsAux except ErrorSequence to RowErrors
                                /** Coloca sequˆncia **/
                                assign RowErrors.ErrorSequence = iErro + 1.
                            assign iErro = RowErrors.ErrorSequence.
                        end.
                    end.
                END. /*when 4*/
            END CASE.
        END. /*FOR EACH tt-integr-funcionario-eai*/
        /*criando o cargo para os funcion rios ou motoristas que nÆo tiverem cargo cadastrado. 
          Nesse caso, apenas o cargo ser  cadastrado e o funcionario ou motorista nÆo ser  efetivado na tabela
          caso o cargo exista e tenha altera‡äes ser  alterado */
        FOR FIRST tt-mab-integr-cargo NO-LOCK:
            ASSIGN l-cargo = NO.
            /*--- seta na bo que o programa que est  chamando ‚ esse adapter. Dessa forma, ele nÆo ir  consistir o campo descri‡Æo do cargo*/
            RUN setaPrograma IN h-boCargo (INPUT "AXRMF003":U).
            IF tt-mab-integr-cargo.r-rowid <> ? THEN DO:
                ASSIGN l-cargo = YES.
                RUN goToKey IN h-boCargo (INPUT tt-mab-integr-cargo.cod-cargo).
                /*--- Transfere temp-table tt-mab-eqpto para o DBO ---*/
                RUN setRecord IN h-boCargo (INPUT TABLE tt-mab-integr-cargo).
                /*--- executa o afterUpdateRecord no registro cocorrente do DBO ---*/
                RUN updateRecord IN h-boCargo.
            END.
            ELSE DO:
                /*--- Transfere temp-table tt-mab-eqpto para o DBO ---*/
                RUN setRecord IN h-boCargo (INPUT TABLE tt-mab-integr-cargo).
                /** Cria o registro **/
                RUN createRecord IN h-boCargo.
            END.
                /*--- Verifica ocorrˆncia de erros durante a transa‡Æo ---*/                                                                      
                IF return-value = "NOK":U THEN DO:
                    /*--- Retorna temp-table RowErrors do DBO ---*/
                    RUN getRowErrors IN h-boCargo (OUTPUT TABLE RowErrorsAux). 
                    assign iErro = 0.
                    /** Busca £ltimo erro criado na BO **/
                    for last RowErrors no-lock:
                        assign iErro = RowErrors.ErrorSequence.
                    END.
                    /** Percorre os erros da BO **/
                    for each RowErrorsAux no-lock:
                        /** Cria eros na BO **/
                        create RowErrors.
                        buffer-copy RowErrorsAux except ErrorSequence to RowErrors
                            /** Coloca sequˆncia **/
                            assign RowErrors.ErrorSequence = iErro + 1.
                        assign iErro = RowErrors.ErrorSequence.
                    END.
                END.
                IF not(l-cargo) THEN DO:
                    {utp/ut-liter.i Durante_a_efetiva‡Æo_da_mensagem_de_funcion rios_no_Datasul_Frotas,_foi_criado_um_novo_cargo_para_integra‡Æo_-_c¢digo *}
                    ASSIGN c-liter = trim(RETURN-VALUE).
                    {utp/ut-liter.i Acesse_o_m¢dulo_de_Abastecimentos_e_Lubrifica‡äes_do_Datasul_Frotas_-_programa_AB0114_-_e_parametrize_corretamente_as_informa‡äes_necess rias_para_a_correta_integra‡Æo. *}
                    RUN setError IN hMessageHandler (INPUT 17006,
                                                     INPUT "warning":U,
                                                     INPUT c-liter + " " + tt-mab-integr-cargo.cod-cargo + ". " + RETURN-VALUE).
                END.
                FOR EACH RowErrors  
                    WHERE RowErrors.ErrorType <> "INTERNAL":U NO-LOCK:
                    {utp/ut-liter.i Erro_de_integra‡Æo._Durante_a_execu‡Æo_do_adapter,_ocorreu_o(s)_seguinte(s)_erro(s)_de_Progress:_ * }
                    RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber /*17006*/,
                                                     INPUT "business_error":U,  /* Erro de neg¢cio */
                                                     INPUT RETURN-VALUE + RowErrors.ErrorDescription).
                END.
        END.
        /*deletando instƒncias das bo's **/
        IF valid-handle(h-boMotoris) then                                                       
           run destroy in h-boMotoris.
        IF valid-handle(h-boFunc) then                                                       
           run destroy in h-boFunc.
        IF valid-handle(h-boCargo) then                                                       
           run destroy in h-boCargo.
    END. /*else da verifica‡Æo de assinatura*/
  /* Obtem mensagem de retorno (erro ou confirmacao) */
  RUN getReturnMessage IN hMessageHandler (OUTPUT hOutputXML).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

