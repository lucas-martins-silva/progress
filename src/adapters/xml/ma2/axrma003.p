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
{include/i-prgvrs.i AXRMA003 2.00.00.004}  /*** 010004 ***/



/*------------------------------------------------------------------------
    File        : axrma003.p
    Purpose     : Recebimento de Retorno de Transa‡Æo de Centro de Custo
    Syntax      :
    Description :
    Author(s)   : Carlos Valentini(its0045)
    Created     : 20/08/2005
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* DEFINE PRE-PROCESSADORES */
&GLOBAL-DEFINE XmlApp            MA2
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlTranName       CostCenterExtension
&GLOBAL-DEFINE XmlMinTranVersion 204.000
&GLOBAL-DEFINE XmlMaxTranVersion 204.999
&GLOBAL-DEFINE XmlListOfAction   upd




/* DEFINE AS VARAIVEIS PARA USO DO xmlloadmessagehandlerrec */
{xmlinc/xmlloadmessagehandlerrecdef.i}

/* DEFINE AS VARAIVEIS PARA USO DO xmlLoadGenXmlRec */
{xmlinc/xmlloadgenxmlrecdef.i}
{utp/ut-glob.i}        /* Variÿveis Globais                            */
{cdp/cd0666.i}   /* Temp-table de erros padrÆo */
{csp/csapi004.i} /* Temp-table tt-imp-ext-per-custo */


    DEFINE TEMP-TABLE tt-config-aux NO-UNDO
        FIELD cod-versao-integ  AS  INTEGER
        FIELD dat-cotacao       AS  DATE    INITIAL TODAY
        FIELD zerar-custo       AS  LOGICAL INITIAL YES
        field mo-codigo         as  INTEGER initial 0
        FIELD periodo           AS DATE
        FIELD especie           AS  INTEGER 
        FIELD cc-codigo         AS  CHARACTER 
        FIELD cod-estabel-ini   AS  CHARACTER
        FIELD cod-estabel-fim   AS  CHARACTER
        field acomp             as  HANDLE
        INDEX id IS PRIMARY UNIQUE cc-codigo
                                   periodo
                                   mo-codigo
                                   especie.

    DEFINE TEMP-TABLE tt-imp-ext-per-custo-aux NO-UNDO
        FIELD   cc-codigo   AS  CHARACTER 
        FIELD   periodo     AS DATE
        FIELD   especie     AS  INTEGER 
        FIELD   mo-codigo   as  INTEGER initial 0
        FIELD   custo-total AS  DECIMAL DECIMALS 4 
        FIELD   custo-prev  AS  DECIMAL DECIMALS 4 
        FIELD   linha       AS  INTEGER
        field   erro        as  LOGICAL
        INDEX id IS PRIMARY UNIQUE cc-codigo
                                   periodo
                                   mo-codigo
                                   especie.
DEF TEMP-TABLE tt-erro-aux NO-UNDO LIKE tt-erro.


DEFINE VARIABLE iId                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE iIdListOfPeriodCostExtension  AS INTEGER    NO-UNDO.
DEFINE VARIABLE iIdSite                       AS INTEGER    NO-UNDO.
DEFINE VARIABLE iIdPeriodCostExtension        AS INTEGER    NO-UNDO.
DEFINE VARIABLE iIdCurr                       AS INTEGER    NO-UNDO.
DEFINE VARIABLE iIdCostCenterTotal            AS INTEGER    NO-UNDO.
DEFINE VARIABLE iIdListOfCostCenterTotal      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iValuesId                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iValuesId2                    AS INTEGER    NO-UNDO.
DEFINE VARIABLE iValuesId3                    AS INTEGER    NO-UNDO.
DEFINE VARIABLE iValuesId4                    AS INTEGER    NO-UNDO.
DEFINE VARIABLE iIdPeriodo                    AS INTEGER    NO-UNDO.
DEFINE VARIABLE iIdCurrCode                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE lValor                        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE deValor1                      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE deValor2                      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE deValor3                      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE deValor4                      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE deValor5                      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE deValor6                      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cod-ctro-cuto                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cod-estabelec                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE moeda                         AS INT NO-UNDO.
DEFINE VARIABLE periodo                       AS CHAR  NO-UNDO.
DEFINE VARIABLE data-refer                    AS DATE       NO-UNDO.
DEFINE VARIABLE i-sequencia-aux               AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-desc-centro                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-desc-estab                  AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fnCalculaData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCalculaData Procedure 
FUNCTION fnCalculaData RETURNS DATE
      ( p-periodo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 7.92
         WIDTH              = 39.14.
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

&IF DEFINED(EXCLUDE-pi-cria-temp-table) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-temp-table Procedure 
PROCEDURE pi-cria-temp-table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM  p-cod-ctro-cuto  AS CHAR NO-UNDO.
DEF INPUT PARAM  p-moeda          AS INT NO-UNDO.
DEF INPUT PARAM  p-periodo        AS DATE NO-UNDO.
DEF INPUT PARAM  p-deValor        AS DEC NO-UNDO.
DEF INPUT PARAM  p-seq            AS INT NO-UNDO.
DEF INPUT PARAM  p-opcao          AS LOG NO-UNDO.
DEF INPUT PARAM  p-cod-estabel    AS CHAR NO-UNDO.




  FOR FIRST tt-imp-ext-per-custo-aux 
      WHERE tt-imp-ext-per-custo-aux.cc-codigo = p-cod-ctro-cuto
      AND   tt-imp-ext-per-custo-aux.periodo   = p-periodo
      AND   tt-imp-ext-per-custo-aux.mo-codigo = p-moeda
      AND   tt-imp-ext-per-custo-aux.especie   = p-seq EXCLUSIVE-LOCK:
  END.
  IF AVAIL tt-imp-ext-per-custo-aux THEN DO:
     ASSIGN tt-imp-ext-per-custo-aux.custo-total = tt-imp-ext-per-custo-aux.custo-total + p-deValor.
  END.
  ELSE DO:
      CREATE tt-imp-ext-per-custo-aux.
      ASSIGN tt-imp-ext-per-custo-aux.cc-codigo   = p-cod-ctro-cuto
             tt-imp-ext-per-custo-aux.especie     = p-seq
             tt-imp-ext-per-custo-aux.custo-total = p-deValor
             tt-imp-ext-per-custo-aux.custo-prev  = 0
             tt-imp-ext-per-custo-aux.periodo     = p-periodo
             tt-imp-ext-per-custo-aux.mo-codigo   = p-moeda
             tt-imp-ext-per-custo-aux.linha       = 0
             tt-imp-ext-per-custo-aux.erro        = NO.

  END.


  FOR FIRST tt-config-aux 
      WHERE tt-config-aux.cc-codigo   = p-cod-ctro-cuto
      AND   tt-config-aux.periodo     = p-periodo
      AND   tt-config-aux.mo-codigo   = p-moeda 
      AND   tt-config-aux.especie     = p-seq EXCLUSIVE-LOCK:
  END.
  IF NOT AVAIL tt-config-aux THEN DO:
      CREATE tt-config-aux.
      ASSIGN tt-config-aux.cod-versao-integ   = 204
              tt-config-aux.cc-codigo         = p-cod-ctro-cuto
             tt-config-aux.dat-cotacao        = p-periodo
             tt-config-aux.periodo            = p-periodo  
             tt-config-aux.zerar-custo        = p-opcao
             tt-config-aux.mo-codigo          = p-moeda
             tt-config-aux.cod-estabel-ini    = p-cod-estabel
             tt-config-aux.cod-estabel-fim    = p-cod-estabel
             tt-config-aux.acomp              = ?
             tt-config-aux.especie            = p-seq.
  END.



 RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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


    /* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
    {xmlinc/xmlloadmessagehandlerrec.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue" &MHReturnError="hOutputXML"}

   /* VERIFICA SE O MessageHandler FOI EXECUTADO CORRETAMENTE */
    /* Verifica se o MessageHandler foi executado corretamente */
    IF  cReturnValue <> "OK":U THEN 
     IF cReturnValue <> ? AND cReturnValue <> "" THEN 
        RUN setError IN hMessageHandler (INPUT 0,
                                         INPUT "enviroment_error":U,
                                         INPUT cReturnValue).
    /* FAZ A INTERPRETAø°O E ALGUNS PROCESSOS NA MENSAGEM QUE RECEBE */
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
    /* SE N°O PROCESSOU CORRETAMENTE RETORNA ERRO */
    IF NOT lSuccessProcess OR
       RETURN-VALUE <> "OK" THEN DO:
       IF cReturnValue <> ? AND cReturnValue <> " " THEN DO:
          RUN setError IN hMessageHandler (INPUT 0,
                                           INPUT "enviroment_error":U,
                                           INPUT cReturnValue).
       END.
    END.
    ELSE DO:
       /* OBTEM A PARTE DA MENSAGEM QUE ESTÉ ABAIXO DO ELEMENTO BusinessContent */
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

       /* ELIMINA A MENSAGEM OBTIDA NO MâTODO getBusinessContent */
       DELETE OBJECT hBusinessContent NO-ERROR.
           /* Cria um registro para receber os valores dos filhos do elemento raiz (Upsert ou Delete) */
         EMPTY TEMP-TABLE tt-erro.
         ASSIGN cod-ctro-cuto = "":U
                moeda         = 0
                periodo       = "":U.
        /* Informa‡äes existentes na tag CustCenterExtension */
        RUN getSonVal  IN hGenXml (INPUT 1, INPUT "CostCenterCode":U, OUTPUT cod-ctro-cuto).
        RUN getSonVal  IN hGenXml (INPUT 1, INPUT "CostCenterDescription":U, OUTPUT c-desc-centro).
       /* Informa‡äes referente a Estabelecimento */
        RUN searchTag IN hGenXml ("Site":U, 1, OUTPUT iId).
        IF iId <> ? THEN
           RUN getSonVal IN hGenXml (INPUT iId, INPUT "SiteCode":U, OUTPUT cod-estabelec).
           RUN getSonVal IN hGenXml (INPUT iId, INPUT "SiteName":U, OUTPUT c-desc-estab).
        RUN searchTag IN hGenXml ("ListOfPeriodCostExtension":U, 1, OUTPUT iIdListOfPeriodCostExtension).
        IF iIdListOfPeriodCostExtension <> ? THEN DO:
           RUN getFirstSonId IN hGenXml (INPUT iIdListOfPeriodCostExtension, OUTPUT iIdPeriodCostExtension).
           DO WHILE iIdPeriodCostExtension <> ?:
               RUN searchTag IN hGenXml ("Curr":U, iIdPeriodCostExtension, OUTPUT iIdCurr).
               IF iIdCurr <> ? THEN
                  RUN getSonDec IN hGenXml (INPUT iIdCurr, INPUT "CurrCode":U, OUTPUT  moeda).
               RUN getSonVal IN hGenXml (INPUT iIdPeriodCostExtension, INPUT "Period":U , OUTPUT periodo).
               ASSIGN  data-refer = fnCalculaData(periodo).
               RUN searchTag IN hGenXml ("ListOfCostCenterTotal":U, iIdPeriodCostExtension, OUTPUT iIdListOfCostCenterTotal).
               IF iIdListOfCostCenterTotal <> ? THEN DO:
                  /* RUN getFirstSonId IN hGenXml (INPUT iIdListOfCostCenterTotal, OUTPUT iValuesId4).
                   DO WHILE iValuesId4 <> ?:*/
                      RUN getSonLog  IN hGenXml (INPUT iIdListOfCostCenterTotal, INPUT "IsUpdValue":U, OUTPUT lValor).
                      RUN getSonDec  IN hGenXml (INPUT iIdListOfCostCenterTotal, INPUT "CostCenterTotalValue1":U, OUTPUT deValor1 ).
                      RUN pi-cria-temp-table (INPUT cod-ctro-cuto,
                                              INPUT moeda,
                                              INPUT data-refer,
                                              INPUT deValor1,
                                              INPUT 1,
                                              INPUT lValor,
                                              INPUT cod-estabelec).
                      RUN getSonDec  IN hGenXml (INPUT iIdListOfCostCenterTotal, INPUT "CostCenterTotalValue2":U, OUTPUT deValor2 ).
                      RUN pi-cria-temp-table (INPUT cod-ctro-cuto,
                                              INPUT moeda,
                                              INPUT data-refer,
                                              INPUT deValor2,
                                              INPUT 2,
                                              INPUT lValor,
                                              INPUT cod-estabelec).
                      RUN getSonDec  IN hGenXml (INPUT iIdListOfCostCenterTotal, INPUT "CostCenterTotalValue3":U, OUTPUT deValor3 ).
                      RUN pi-cria-temp-table (INPUT cod-ctro-cuto,
                                              INPUT moeda,
                                              INPUT data-refer,
                                              INPUT deValor3,
                                              INPUT 3,
                                              INPUT lValor,
                                              INPUT cod-estabelec).
                      RUN getSonDec  IN hGenXml (INPUT iIdListOfCostCenterTotal, INPUT "CostCenterTotalValue4":U, OUTPUT deValor4 ).
                      RUN pi-cria-temp-table (INPUT cod-ctro-cuto,
                                              INPUT moeda,
                                              INPUT data-refer,
                                              INPUT deValor4,
                                              INPUT 4,
                                              INPUT lValor,
                                              INPUT cod-estabelec).
                      RUN getSonDec  IN hGenXml (INPUT iIdListOfCostCenterTotal, INPUT "CostCenterTotalValue5":U, OUTPUT deValor5 ).
                      RUN pi-cria-temp-table (INPUT cod-ctro-cuto,
                                              INPUT moeda,
                                              INPUT data-refer,
                                              INPUT deValor5,
                                              INPUT 5,
                                              INPUT lValor,
                                              INPUT cod-estabelec).
                      RUN getSonDec  IN hGenXml (INPUT iIdListOfCostCenterTotal, INPUT "CostCenterTotalValue6":U, OUTPUT deValor6 ).
                      RUN pi-cria-temp-table (INPUT cod-ctro-cuto,
                                              INPUT moeda,
                                              INPUT data-refer,
                                              INPUT deValor6,
                                              INPUT 6,
                                              INPUT lValor,
                                              INPUT cod-estabelec).
                    /*  ASSIGN iValuesId2 = iIdListOfCostCenterTotal.
                      RUN GetNextSonId IN hGenXml (iIdListOfCostCenterTotal, iValuesId2, OUTPUT iIdListOfCostCenterTotal).
                    END.*/
               END.
               ASSIGN iValuesId3 = iIdPeriodCostExtension.
               RUN GetNextSonId IN hGenXml (iIdListOfPeriodCostExtension, iValuesId3, OUTPUT iIdPeriodCostExtension).
           END. /*** end do do while ***/
        END. /** IF iIdListOfPeriodCostExtension <> ? **/ 
    END.

    IF SEARCH("csp/csapi004.r":U) <> ? 
        OR SEARCH("csp/csapi004.p":U) <> ? THEN DO:

         EMPTY TEMP-TABLE tt-config.
         EMPTY TEMP-TABLE tt-imp-ext-per-custo.

         /* Custo por Centro de Custo */
         FOR EACH tt-config-aux:
             
             CREATE tt-config.
             ASSIGN tt-config.cod-versao-integ  = 204
                    tt-config.dat-cotacao       = tt-config-aux.periodo   
                    tt-config.zerar-custo       = tt-config-aux.zerar-custo    
                    tt-config.mo-codigo         = tt-config-aux.mo-codigo   
                    tt-config.cod-estabel-ini   = tt-config-aux.cod-estabel-ini
                    tt-config.cod-estabel-fim   = tt-config-aux.cod-estabel-fim
                    tt-config.acomp             = ?.
             FOR EACH tt-imp-ext-per-custo-aux
                 WHERE tt-imp-ext-per-custo-aux.cc-codigo   = tt-config-aux.cc-codigo
                 AND   tt-imp-ext-per-custo-aux.mo-codigo   = tt-config-aux.mo-codigo
                 AND   tt-imp-ext-per-custo-aux.periodo     = tt-config-aux.periodo
                 AND   tt-imp-ext-per-custo-aux.especie     = tt-config-aux.especie :  
                 CREATE tt-imp-ext-per-custo.
                 ASSIGN tt-imp-ext-per-custo.cc-codigo   = tt-imp-ext-per-custo-aux.cc-codigo  
                        tt-imp-ext-per-custo.especie     = tt-imp-ext-per-custo-aux.especie    
                        tt-imp-ext-per-custo.custo-total = tt-imp-ext-per-custo-aux.custo-total
                        tt-imp-ext-per-custo.custo-prev  = tt-imp-ext-per-custo-aux.custo-prev 
                        tt-imp-ext-per-custo.linha       = tt-imp-ext-per-custo-aux.linha      
                        tt-imp-ext-per-custo.erro        = tt-imp-ext-per-custo-aux.erro.       
             END.
         END.
         
         EMPTY TEMP-TABLE tt-erro-aux.
         run csp/csapi004.p (input  table tt-config,
                     input  table tt-imp-ext-per-custo,
                     output table tt-erro-aux).
         ASSIGN i-sequencia-aux = 0.
         FOR LAST tt-erro EXCLUSIVE-LOCK:
             ASSIGN i-sequencia-aux = tt-erro.i-sequen.
         END.
         FOR EACH tt-erro-aux EXCLUSIVE-LOCK:
             IF NOT CAN-FIND(FIRST tt-erro
                             WHERE tt-erro.cd-erro = tt-erro-aux.cd-erro ) THEN DO:
                CREATE tt-erro.
                ASSIGN   tt-erro.i-sequen  = i-sequencia-aux + 1
                         tt-erro.cd-erro   = tt-erro-aux.cd-erro 
                         tt-erro.mensagem  = tt-erro-aux.mensagem.
             END.
         END.
         FOR EACH tt-erro NO-LOCK:
             {utp/ut-liter.i "Erro de integra‡Æo. Erro ao executar a API de Implanta‡Æo do Item csapi004 pelo programa adapters/xml/ma2/axrma003.p. Durante sua execu‡Æo ocorreu o(s) seguinte(s) erro(s) de Progress:"}
             RUN setError IN hMessageHandler (INPUT tt-erro.cd-erro,
                                              INPUT "business_error":U,  /* Erro de neg¢cio */
                                              INPUT RETURN-VALUE + tt-erro.mensagem).
         END.
    END.
    ELSE DO: /* Programa de efetiva‡Æo nÆo localizado */
         {utp/ut-liter.i "Erro de integra‡Æo. NÆo foi poss¡vel localizar o programa csp/csapi004 a ser executado pelo programa adapters/xml/ma2/axrma003.p."}
         RUN setError IN hMessageHandler (INPUT 0,
                                          INPUT "enviroment_error":U,
                                          INPUT "return-value").
    END.

  /* Obtem mensagem de retorno (erro ou confirmacao) */
  RUN getReturnMessage IN hMessageHandler (OUTPUT hOutputXML). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fnCalculaData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCalculaData Procedure 
FUNCTION fnCalculaData RETURNS DATE
      ( p-periodo AS CHAR ) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/
    DEF VAR data AS DATE NO-UNDO.

    ASSIGN data = DATE(INT(SUBSTRING(p-periodo,1,2)),01,INT(SUBSTRING(p-periodo,4,4))).
    ASSIGN data = data + 35 - DAY(data + 35).

      RETURN data.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

