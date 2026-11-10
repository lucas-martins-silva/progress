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
{include/i-prgvrs.i AXRMF001 2.00.00.001}  /*** 010001 ***/


/*------------------------------------------------------------------------
    File        : axrmf001.p
    Purpose     : Recebimento de Atividade
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
&GLOBAL-DEFINE XmlTranName Activity
&GLOBAL-DEFINE XmlMinTranVersion 100.000
&GLOBAL-DEFINE XmlMaxTranVersion 100.999
&GLOBAL-DEFINE XmlListOfAction add,del,upd 

/* DEFINE AS VARAIVEIS PARA USO DO xmlloadmessagehandlerrec */
{xmlinc/xmlloadmessagehandlerrecdef.i}

/* DEFINE AS VARAIVEIS PARA USO DO xmlLoadGenXmlRec */
{xmlinc/xmlloadgenxmlrecdef.i}


{utp/ut-glob.i}        /* Vari veis Globais                            */

{frbo/bofr001.i tt-mab-ativid-eai } 

DEFINE TEMP-TABLE ttStack NO-UNDO
     FIELD ttID AS INTEGER
     FIELD ttPos AS INTEGER
     INDEX tt_id IS PRIMARY UNIQUE
           ttID  ASCENDING.

DEFINE VARIABLE hDBOActivity    AS HANDLE NO-UNDO. /*** Atividade ***/

/*** Temp-table de erros ***/
DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addStack) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addStack Procedure 
FUNCTION addStack RETURNS INTEGER
  ( INPUT val AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-delStack) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD delStack Procedure 
FUNCTION delStack RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getStack) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getStack Procedure 
FUNCTION getStack RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 9.38
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
    DEF VAR iCount           AS INT    NO-UNDO.
    DEF VAR cListRootSon     AS CHAR   NO-UNDO.
    DEF VAR iContRootSon     AS INT    NO-UNDO.
    DEF VAR hGenXml          AS HANDLE NO-UNDO. 
    DEF VAR hMessageHandler  AS HANDLE NO-UNDO.
    DEF VAR cReturnValue     AS CHAR   NO-UNDO. 
    DEF VAR cTranAction      AS CHAR   NO-UNDO.
    DEF VAR cReturnAux       AS CHAR   NO-UNDO. 
    def var rGoto            AS ROWID  NO-UNDO.
          /* Defini‡Æo de vari veis*/
    DEFINE VARIABLE iActivityId                     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iId                             AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iActivityCode                   AS INTEGER    NO-UNDO. /**** C¢dido do Atividade ***/
    DEFINE VARIABLE iTranAction                     AS INTEGER    NO-UNDO. /*** Tipo da transa‡Æo ***/
    DEFINE VARIABLE iActivityDescription            AS INTEGER    NO-UNDO. /*** Descri‡Æo da Atividade***/
   /*** LImpa a Temp-Table ***/
   EMPTY TEMP-TABLE tt-mab-ativid-eai.
   
 
    /* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
    {xmlinc/xmlloadmessagehandlerrec.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue" &MHReturnError="hOutputXML"}

    /* VERIFICA SE O MessageHandler FOI EXECUTADO CORRETAMENTE */
    /* Verifica se o MessageHandler foi executado corretamente */
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
        /* Cria um registro para receber os valores dos filhos do elemento raiz (Upsert ou Delete) */
         /*addStack(1).
              RUN searchTag IN hGenXml (INPUT "Activity":U, INPUT getStack(), OUTPUT iActivityId).
              addStack(iActivityId).
              RUN getFirstSonId IN hGenXml (INPUT getStack(), OUTPUT iId).
              DO WHILE iId <> ?:*/
                 CREATE tt-mab-ativid-eai.
                 /* Informa‡äes existentes na tag Activity */
                 /*** C¢digo da Atividade ***/
                 RUN getSonVal  IN hGenXml (INPUT 1, INPUT "ActivityCode":U, OUTPUT tt-mab-ativid-eai.cod-ativid).
                 /**** Descri‡Æo da Atividade ***/
                 RUN getSonVal IN hGenXml (INPUT 1, INPUT "ActivityDescription":U, OUTPUT tt-mab-ativid-eai.des-ativid).
                 assign tt-mab-ativid-eai.log-area-agro = yes.
/*                  ASSIGN iActivityId = getStack().                                       */
/*                  delStack().                                                            */
/*                  RUN getNextSonId IN hGenXml (INPUT getStack(), INPUT iId, OUTPUT iId). */
          /*    end. */
          /*delStack(). */
      
      if search("frbo/bofr001.p") <> ? OR           
           search("frbo/bofr001.r") <> ?   THEN DO:   
            /*--- Limpa temp-table RowErrors no DBO ---*/
            IF NOT VALID-HANDLE(hDBOActivity) OR
               hDBOActivity:TYPE <> "PROCEDURE":U OR
               hDBOActivity:FILE-NAME <> "frbo/bofr001.p":U THEN DO:
               run frbo/bofr001.p persistent set hDBOActivity.
            END.
            RUN openQueryStatic IN hDBOActivity (INPUT "Main":U) NO-ERROR.
            CASE cTranAction  :
                /*--- Verifica se est  sendo feita uma altera‡Æo ---*/
                WHEN "upd":U OR WHEN "add":U then do:
                     for first tt-mab-ativid-eai exclusive-lock:
                        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
                        RUN goToKey   IN hDBOActivity     (INPUT tt-mab-ativid-eai.cod-ativid).
                        if return-value = "NOK":U then do:
                           /*--- Transfere temp-table tt-mab-ativid-eai para o DBO ---*/
                           RUN setRecord IN hDBOActivity (INPUT TABLE tt-mab-ativid-eai).
                           /*--- Limpa Temp-Table de Erros ---*/
                           RUN emptyRowErrors IN hDBOActivity.
                           /*--- Cria um novo registro ---*/
                           RUN createRecord IN hDBOActivity.
                        end.
                        else do:
                             /*--- Transfere temp-table tt-mab-ativid-eai para o DBO ---*/
                           RUN setRecord IN hDBOActivity (INPUT TABLE tt-mab-ativid-eai).
                           /*--- Limpa Temp-Table de Erros ---*/
                           RUN emptyRowErrors IN hDBOActivity.
                           /*--- Altera o registro corrente do DBO ---*/
                            RUN updateRecord IN hDBOActivity.
                        end.
                     end.
                end.
                WHEN "del":U then do:
                     for first tt-mab-ativid-eai exclusive-lock:
                        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
                        RUN goToKey   IN hDBOActivity     (INPUT tt-mab-ativid-eai.cod-ativid).  
                        if return-value <> "NOK":U then do:
                            /*--- Limpa Temp-Table de Erros ---*/
                            RUN emptyRowErrors IN hDBOActivity.
                            /*--- Elimina o registro corrente do DBO ---*/
                            RUN deleteRecord IN hDBOActivity.
                        end.
                    end.
                end.
            END CASE.
            /*--- Atualiza vari vel cReturnAux com o conte£do do RETURN-VALUE ---*/
            ASSIGN cReturnAux = RETURN-VALUE.
            /*--- Verifica ocorrˆncia de erros durante a grava‡Æo ---*/
            IF cReturnAux = "NOK":U THEN DO:
              /*--- Retorna temp-table RowErrors do DBO ---*/
              RUN getRowErrors IN hDBOActivity (OUTPUT TABLE RowErrors).
              FOR EACH RowErrors  
                    WHERE RowErrors.ErrorType <> "INTERNAL":U NO-LOCK:
                   {utp~/ut-liter.i Erro_de_integra‡Æo._Erro_ao_executar_a_BO_de_Atividade_frbo/bofr001.p_pelo_programa_adapters/xml/mn2/axrmf001.p._Durante_sua_execu‡Æo_ocorreu_o(s)_seguinte(s)_erro(s)_de_Progress: * }
                   RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                                    INPUT "business_error":U,  /* Erro de neg¢cio */
                                                    INPUT trim(RETURN-VALUE) + RowErrors.ErrorDescription).
               END.
            END.
            /** Elimina da men¢ria a bo de Atividade **/
           if valid-handle(hDBOActivity) THEN   
              run Destroy in hDBOActivity.
      END.
      ELSE DO: /* Programa de efetiva‡Æo nÆo localizado */
         {utp~/ut-liter.i "Erro de integra‡Æo. NÆo foi poss¡vel localizar o programa frbo/bofr001.p a ser executado pelo programa adapters/xml/ma2/axrmf001.p."}
          RUN setError IN hMessageHandler (INPUT 17006,
                                           INPUT "enviroment_error":U,
                                           INPUT "return-value").
      END.
  END.

  /* Obtem mensagem de retorno (erro ou confirmacao) */
  RUN getReturnMessage IN hMessageHandler (OUTPUT hOutputXML). 


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addStack) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addStack Procedure 
FUNCTION addStack RETURNS INTEGER
  ( INPUT val AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

   DEFINE VAR id AS INTEGER INITIAL 1 NO-UNDO.
     FIND LAST ttStack NO-ERROR.
     IF AVAIL(ttStack) then do:
          id = ttStack.ttID + 1.
     end.
     CREATE ttStack.
     ASSIGN ttStack.ttID = id.
     ASSIGN ttStack.ttPos = val.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-delStack) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION delStack Procedure 
FUNCTION delStack RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

 FIND LAST ttStack NO-ERROR.
     IF AVAIL(ttStack) THEN
          DELETE ttStack.

     FIND LAST ttStack NO-ERROR.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getStack) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getStack Procedure 
FUNCTION getStack RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF AVAIL(ttStack) then do:
     RETURN ttStack.ttPos.
  end.
  else do:
      RETURN 0.
  end.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

