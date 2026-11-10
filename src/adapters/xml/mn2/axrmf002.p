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
{include/i-prgvrs.i AXRMF002 2.00.00.003 } /*** 010003 ***/

{cdp/cdcfgmnt.i}


/*------------------------------------------------------------------------
    File        : axrmf002.p
    Purpose     : Recebimento da Quilometragem do Implemento
    Syntax      :
    Description :
    Author(s)   : Carlos Alberto Valentini
    Created     : 14/02/2005
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

   
/* DEFINE PRE-PROCESSADORES */
&GLOBAL-DEFINE XmlProdName EMS2
&GLOBAL-DEFINE XmlProdVersion 2.04
&GLOBAL-DEFINE XmlApp MN2
&GLOBAL-DEFINE XmlTranName ImplementKilometrage
&GLOBAL-DEFINE XmlMinTranVersion 100.000
&GLOBAL-DEFINE XmlMaxTranVersion 100.999
&GLOBAL-DEFINE XmlListOfAction add,del,upd 

/* DEFINE AS VARAIVEIS PARA USO DO xmlloadmessagehandlerrec */
{xmlinc/xmlloadmessagehandlerrecdef.i}

/* DEFINE AS VARAIVEIS PARA USO DO xmlLoadGenXmlRec */
{xmlinc/xmlloadgenxmlrecdef.i}


{utp/ut-glob.i}        /* Vari†veis Globais                            */

{abp/abapi007.i} /** Temp-Table ttKM da mab-movto-km-eqpto (auxiliar) **/
{abp/ab9000.i}    /** Convers∆o de Horas **/

def buffer bfKM for ttKMImport.

DEFINE VARIABLE h-abapi007 AS HANDLE     NO-UNDO. /**** Eliminaá∆o / Geraá∆o / Atualizaá∆o Percurso Rodado por
                                                  ***********  equipamentos n∆o Motorizados        ***********/ 

{abp/ab9004.i} /** Temp-table RowErrors **/
/** Erros de Importaá∆o **/
define temp-table RowErrorsAux no-undo like RowErrors
    field i-linha as integer.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 5.13
         WIDTH              = 35.43.
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
    DEF VAR cListRootSon     AS CHAR   NO-UNDO.
    DEF VAR iContRootSon     AS INT    NO-UNDO.
    DEF VAR hGenXml          AS HANDLE NO-UNDO. 
    DEF VAR hMessageHandler  AS HANDLE NO-UNDO.
    DEF VAR cReturnValue     AS CHAR   NO-UNDO. 
    DEF VAR cTranAction      AS CHAR   NO-UNDO.
    DEF VAR cReturnAux       AS CHAR   NO-UNDO. 
    def var rGoto            AS ROWID  NO-UNDO.
    DEFINE VARIABLE cTexto AS CHARACTER  NO-UNDO.
          /* Definiá∆o de vari†veis*/
    DEFINE VARIABLE iImplementKilometrageId         AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iId                             AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iListOfMovementsId              AS INTEGER    NO-UNDO. /**** Lista de Movimentos ***/
    DEFINE VARIABLE iMovementsId                    AS INTEGER    NO-UNDO. /**** Lista de Movimentos ***/
    DEFINE VARIABLE dReferenceDate                  AS DATE       NO-UNDO.
    DEFINE VARIABLE dMovtoDate                      AS DATE       NO-UNDO.
    DEFINE VARIABLE iLinha                          AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iValuesId                       AS INTEGER    NO-UNDO.
&IF "{&mguni_version}" >= "2.071" &THEN
    DEFINE VARIABLE iEmpresa                        LIKE empresa.ep-codigo    NO-UNDO.
&ELSE
    DEFINE VARIABLE iEmpresa                        AS INTEGER    NO-UNDO.
&ENDIF
    DEFINE VARIABLE cEquipamento                    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iOrigem                        AS INTEGER    NO-UNDO.
    DEFINE VARIABLE deValKM                         AS DECIMAL    NO-UNDO.

   /*** LImpa a Temp-Table ***/
   EMPTY TEMP-TABLE tt-param.
   EMPTY TEMP-TABLE ttKmImport.
   assign dReferenceDate = ?
          iLinha         = 1
          &IF "{&mguni_version}" >= "2.071" &THEN
          iEmpresa       = ""
          &ELSE
          iEmpresa       = 0
          &ENDIF
          cEquipamento   = "":U.
    /* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
    {xmlinc/xmlloadmessagehandlerrec.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue" &MHReturnError="hOutputXML"}

    /* VERIFICA SE O MessageHandler FOI EXECUTADO CORRETAMENTE */
    /* Verifica se o MessageHandler foi executado corretamente */
    IF  cReturnValue <> "OK":U THEN 
     IF cReturnValue <> ? AND cReturnValue <> "" THEN 
        RUN setError IN hMessageHandler (INPUT 0,
                                         INPUT "enviroment_error":U,
                                         INPUT cReturnValue).



    /* FAZ A INTERPRETA∞ÄO E ALGUNS PROCESSOS NA MENSAGEM QUE RECEBE */
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

    /* SE NÄO PROCESSOU CORRETAMENTE RETORNA ERRO */
    IF NOT lSuccessProcess OR
       RETURN-VALUE <> "OK" THEN DO:
       IF cReturnValue <> ? AND cReturnValue <> " " THEN DO:
          RUN setError IN hMessageHandler (INPUT 0,
                                           INPUT "enviroment_error":U,
                                           INPUT cReturnValue).
       END.
    END.
    ELSE DO:

        /* OBTEM A PARTE DA MENSAGEM QUE ESTë ABAIXO DO ELEMENTO BusinessContent */
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
        /* ELIMINA A MENSAGEM OBTIDA NO M‘TODO getBusinessContent */
        DELETE OBJECT hBusinessContent NO-ERROR.
       /* Cria um registro para receber os valores dos filhos do elemento raiz (Upsert ou Delete) */
       /* Informaá‰es existentes na tag ImplementKilometrage */
       /*** C¢digo da empresa ***/
       RUN getSonDec  IN hGenXml (input 1, INPUT "CompanyCode":U, OUTPUT iEmpresa ).
       /**** C¢digo do Implemento ***/
       RUN getSonVal IN hGenXml (INPUT 1, INPUT "ImplementCode":U, OUTPUT cEquipamento).
       /*** Data de Referencia ***/
       RUN getSonDate IN hGenXml (INPUT 1, INPUT "ReferenceDate":U, OUTPUT dReferenceDate).
       RUN getSonDec  IN hGenXml (input 1, INPUT "IdOrigem":U, OUTPUT iOrigem ).
       /*** Busca a lista de Movimentos ***/
       RUN searchTag IN hGenXml (input "ListOfMovements":U, input 1, OUTPUT iListOfMovementsId).
       IF iListOfMovementsId  <> ? THEN DO:
          RUN getFirstSonId IN hGenXml (iListOfMovementsId, OUTPUT iValuesId).
          DO WHILE iValuesId <> ?:
             /*** Data de Referencia ***/
             RUN getSonDate IN hGenXml (INPUT iValuesId, INPUT "MovementDate":U, OUTPUT dMovtoDate).
             /**** valor da kilometragem **/
             RUN getSonDec IN hGenXml (INPUT iValuesId, INPUT "ImplementKilometrage":U, OUTPUT  deValKM ).
             /** J† existe registro nesta data, ent∆o soma KM do anterior 
                   com o atual e elimina um dos registros **/
             IF iOrigem = ? THEN
                 ASSIGN iOrigem = 0.
             if can-find(first bfKM
                     where bfKM.ep-codigo = iEmpresa    
                     and   bfKM.cod-eqpto = cEquipamento
                     and   bfKM.dat-movto = dMovtoDate   no-lock) then do:
                    /** Busca Registro **/
                    for first bfKM
                        where bfKM.ep-codigo = iEmpresa    
                        and   bfKM.cod-eqpto = cEquipamento
                        and   bfKM.dat-movto = dMovtoDate   exclusive-lock:
                        /** Acumula percurso **/
                        assign bfKM.val-km-real = bfKM.val-km-real + deValKM.

                    end.
             end.
             else do:
                /** Este campo Ç criado nesta parte, por cauda da chave da tabela
                    (ep-codigo + cod-eqpto + val-dat-hora-invrtda) **/
                CREATE ttKmImport.
                run converteParaHoraInvertida (input  string(dMovtoDate,"99/99/9999"),
                                               input  "000000":U,
                                               output ttKMImport.val-dat-hora-invrtda).
                 ASSIGN ttKmImport.ep-codigo    = iEmpresa
                        ttKmImport.cod-eqpto    = cEquipamento
                        ttKmImport.val-km-real  = deValKM
                        ttKMImport.dat-movto    = dMovtoDate
                        ttKMImport.idi-origem   = iOrigem
                        ttKMImport.i-linha      = iLinha.       
             end.
             assign iId        = iValuesId
                    iLinha     = iLinha + 1
                    deValKM    = 0.00
                    dMovtoDate = ?.

             RUN GetNextSonId IN hGenXml (iListOfMovementsId, iId, OUTPUT iValuesId).
          END.
       END. /** IF iListOfMovementsId  <> ? **/
      /**** Cria a temp-table de parÉmetros ***/
      CREATE tt-param.
      ASSIGN tt-param.todos           = 1
             tt-param.data-exec       = today
             tt-param.hora-exec       = time
             tt-param.i-origem        = 1 /** Importaá∆o **/
             tt-param.dtInicial       = dReferenceDate        /*Data de referància recebida via xml*/
             tt-param.empIni          = iEmpresa  /*C¢digo da empresa recebida via xml*/
             tt-param.empFim          = iEmpresa  /*C¢digo da empresa recebida via xml*/
             tt-param.eqptoIni        = cEquipamento  /*C¢digo do implemento recebido via xml*/
             tt-param.eqptoFim        = cEquipamento  /*C¢digo do implemento recebido via xml*/
             tt-param.estabIni        = "":U
&IF "{&mguni_version}" >= "2.071" &THEN
             tt-param.estabFim        = "ZZZZZ":U
&ELSE
             tt-param.estabFim        = "ZZZ":U
&ENDIF
             tt-param.grupoIni        = "":U
             tt-param.grupoFim        = "ZZZZZZZZ":U
             tt-param.modeloIni       = "":U
             tt-param.modeloFim       = "ZZZZZZZZ":U.
            

     if search("abp/abapi007.p") <> ? OR           
           search("abp/abapi007.r") <> ?   THEN DO: 
           empty temp-table RowErrors. 
           empty temp-table RowErrorsAux. 
           run abp/abapi007.p persistent set h-abapi007 (input table tt-param).  
           if return-value = "NOK":U then do:
               run getRowErrorsAux in h-abapi007 (output table RowErrorsAux).
               /** Erros gerais cancelam a importaá∆o **/
               empty temp-table ttKMImport.
           end.
           else do:
               /** Importaá∆o de Dados **/
               run iniciaImportacao in h-abapi007 (input table ttKMImport,
                                                   input ?).
               if return-value = "NOK":U then do:
                   run getRowErrorsAux in h-abapi007 (output table RowErrorsAux).
               end.
           end.
           if valid-handle(h-abapi007) then do:
               delete procedure h-abapi007.
           end.
           for each RowErrorsAux:
               create RowErrors. 
               buffer-copy RowErrorsAux except RowErrorsAux.i-linha to RowErrors .
           end.
           FOR EACH RowErrors  
               WHERE RowErrors.ErrorType <> "INTERNAL":U NO-LOCK:
               {utp/ut-liter.i Erro_de_integraá∆o._Erro_ao_executar_a_API_de_Percurso_Rodado_por_Equipamentos_n∆o_motorizados_abp/abapi007.p_pelo_programa_adapters/xml/mn2/axrmf002.p._Durante_sua_execuá∆o_ocorreu_o(s)_seguinte(s)_erro(s)_de_Progress: * }
               RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                                INPUT "business_error":U,  /* Erro de neg¢cio */
                                                INPUT trim(RETURN-VALUE) + RowErrors.ErrorDescription).
           END.
      END.
      ELSE DO: /* Programa de efetivaá∆o n∆o localizado */
         {utp/ut-liter.i "Erro de integraá∆o. N∆o foi poss°vel localizar o programa abp/abapi007.p a ser executado pelo programa adapters/xml/ma2/axrmf002.p."}
          RUN setError IN hMessageHandler (INPUT 17006,
                                           INPUT "enviroment_error":U,
                                           INPUT return-value ).
      END.
  END.

  /* Obtem mensagem de retorno (erro ou confirmacao) */
  RUN getReturnMessage IN hMessageHandler (OUTPUT hOutputXML). 


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

