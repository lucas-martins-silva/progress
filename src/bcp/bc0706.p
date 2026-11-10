&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOFunction 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0706 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc0706 MBC}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : dbofun.p
    Purpose    : O DBO Function (Datasul Business Objects) ‚ um programa 
                 PROGRESS que cont‚m a l¢gica de neg¢cio.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName    BC0706
&GLOBAL-DEFINE DBOVersion 1.00.00.000

{bcp/bc0706.i}

DEFINE TEMP-TABLE ttListeners NO-UNDO
    FIELD hListener            AS HANDLE
    FIELD cInitializeProcedure AS CHARACTER
    FIELD cFinalizeProcedure   AS CHARACTER.

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER ipcCodServer AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER iplStatus AS LOGICAL    NO-UNDO.

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-server-error.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hTimer AS HANDLE     NO-UNDO.

DEFINE VARIABLE lIsTurnedOn AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOFunction
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOFunction
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOFunction ASSIGN
         HEIGHT             = 12.54
         WIDTH              = 39.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOFunction 
/* ************************* Included-Libraries *********************** */

{method/dbofun.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOFunction 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addListener DBOFunction 
PROCEDURE addListener :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER iphProgram   AS HANDLE     NO-UNDO.
    DEFINE INPUT  PARAMETER ipcInitProc  AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER ipcFinalProc AS CHARACTER  NO-UNDO.

    CREATE ttListeners.
    ASSIGN ttListeners.hListener = iphProgram
           ttListeners.cInitializeProcedure = ipcInitProc
           ttListeners.cFinalizeProcedure   = ipcFinalProc.

    IF ipcInitProc <> "":U AND VALID-HANDLE(iphProgram) THEN
        RUN VALUE(ipcInitProc) IN iphProgram NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkShutdown DBOFunction 
PROCEDURE checkShutdown :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUFFER bfBCServidor FOR bc-servid.

    FIND bfBCServidor NO-LOCK WHERE
         bfBCServidor.cod-servid = ipcCodServer NO-ERROR.

    IF NOT AVAIL bfBCServidor THEN DO:
        RUN insertError IN THIS-PROCEDURE (INPUT ipcCodServer, /* Codigo do Servidor */
                                           INPUT "":U, /* Codigo da Transacao */
                                           INPUT "":U, /* Codigo do Equipamento */
                                           INPUT "":U, /* Codigo da Variavel Datasul */
                                           INPUT "":U, /* Codigo da Variavel Equipamento */
                                           INPUT 0, /* Numero do Erro */
                                           INPUT "Servidor nao encontrado.":U, /* Mensagem de Erro */
                                           INPUT "":U). /* Detalhe da Mensagem */
        RETURN "NOK":U.
    END.

    IF lIsTurnedOn AND NOT bfBCServidor.log-servid-ativ THEN DO:
        RUN shutdownManager IN THIS-PROCEDURE.

        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doTransactions DBOFunction 
PROCEDURE doTransactions :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUFFER bfBCEquip          FOR bc-eqpto.
    DEFINE BUFFER bfBCServidor       FOR bc-servid.
    DEFINE BUFFER bfBCTipoTransEquip FOR bc-tip-trans-eqpto.

    IF NOT lIsTurnedOn THEN DO:
        RUN insertError IN THIS-PROCEDURE (INPUT ipcCodServer, /* Codigo do Servidor */
                                           INPUT "":U, /* Codigo da Transacao */
                                           INPUT "":U, /* Codigo do Equipamento */
                                           INPUT "":U, /* Codigo da Variavel Datasul */
                                           INPUT "":U, /* Codigo da Variavel Equipamento */
                                           INPUT 0, /* Numero do Erro */
                                           INPUT "Servidor esta desligado.":U, /* Mensagem de Erro */
                                           INPUT "":U). /* Detalhe da Mensagem */
        RETURN "NOK":U.
    END.

    RUN checkShutdown IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    FIND FIRST bfBCServidor NO-LOCK
         WHERE bfBCServidor.cod-servid = ipcCodServer NO-ERROR.
    IF AVAIL bfBCServidor THEN DO:

        /* some server code */

        start_trans_block:
        FOR EACH  bfBCEquip NO-LOCK
            WHERE bfBCEquip.cod-servid = bfBCServidor.cod-servid

            BY bfBCEquip.num-seq-eqpto:

            /* some machine code */

            FOR EACH  bfBCTipoTransEquip NO-LOCK
                WHERE bfBCTipoTransEquip.cod-eqpto = bfBCEquip.cod-eqpto

                BY bfBCTipoTransEquip.num-seq:

                /* some transaction code */

                IF bfBCServidor.idi-sentido-trans <> 3 AND
                   bfBCServidor.idi-sentido-trans <> bfBCTipoTransEquip.idi-sentido-trans THEN
                    NEXT.

                /* Executa o programa que ir  executar a transacao */
                RUN VALUE(bfBCTipoTransEquip.cod-prog-exec) (INPUT ROWID(bfBCTipoTransEquip),
                                                             INPUT-OUTPUT TABLE tt-server-error).
                RUN saveErrors IN THIS-PROCEDURE.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getErrors DBOFunction 
PROCEDURE getErrors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER TABLE FOR tt-server-error.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertError DBOFunction 
PROCEDURE insertError :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER ipcCodServid   AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER ipcCdTrans     AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER ipcCodEqpto    AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER ipcCodVarDtsul AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER ipcCodVarEqpto AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER ipiNumErro     AS INTEGER    NO-UNDO.
    DEFINE INPUT  PARAMETER ipcDslMsgErro  AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER ipcDslDetMsg   AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE iErrorSeq AS INTEGER    NO-UNDO
        INITIAL 0.

    FOR LAST tt-server-error NO-LOCK
        BY tt-server-error.num-seq-erro:

        ASSIGN iErrorSeq = tt-server-error.num-seq-erro.
    END.

    ASSIGN iErrorSeq = iErrorSeq + 1.

    CREATE tt-server-error.
    ASSIGN tt-server-error.num-seq-erro  = iErrorSeq
           tt-server-error.cod-servid    = ipcCodServid
           tt-server-error.cd-trans      = ipcCdTrans
           tt-server-error.cod-eqpto     = ipcCodEqpto
           tt-server-error.cod-var-dtsul = ipcCodVarDtsul
           tt-server-error.cod-var-eqpto = ipcCodVarEqpto
           tt-server-error.num-erro      = ipiNumErro
           tt-server-error.dsl-msg-erro  = ipcDslMsgErro
           tt-server-error.dsl-det-msg   = ipcDslDetMsg.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeListener DBOFunction 
PROCEDURE removeListener :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER iphProgram   AS HANDLE     NO-UNDO.

    FIND FIRST ttListeners EXCLUSIVE-LOCK
         WHERE ttListeners.hListener = iphProgram NO-ERROR.

    IF AVAIL ttListeners THEN DO:
        IF ttListeners.cFinalizeProcedure <> "":U AND VALID-HANDLE(ttListeners.hListener) THEN
            RUN VALUE(ttListeners.cFinalizeProcedure) IN ttListeners.hListener NO-ERROR.

        DELETE ttListeners.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveErrors DBOFunction 
PROCEDURE saveErrors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUFFER bfBCServidErro FOR bc-servid-erro.

    DEFINE VARIABLE iErrorSeq AS INTEGER    NO-UNDO.

    FOR LAST bfBCServidErro EXCLUSIVE-LOCK
        BY bfBCServidErro.num-seq-erro:

        ASSIGN iErrorSeq = bfBCServidErro.num-seq-erro.
    END.

    ASSIGN iErrorSeq = iErrorSeq + 1.

    FOR EACH tt-server-error NO-LOCK:
        CREATE bfBCServidErro.
        BUFFER-COPY tt-server-error TO bfBCServidErro
            ASSIGN bfBCServidErro.num-seq-erro = iErrorSeq.

        ASSIGN iErrorSeq = iErrorSeq + 1.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE shutdownManager DBOFunction 
PROCEDURE shutdownManager :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUFFER bfBCServidor FOR bc-servid.

    FIND bfBCServidor NO-LOCK WHERE
         bfBCServidor.cod-servid = ipcCodServer NO-ERROR.

    IF NOT AVAIL bfBCServidor THEN DO:
        RUN insertError IN THIS-PROCEDURE (INPUT ipcCodServer, /* Codigo do Servidor */
                                           INPUT "":U, /* Codigo da Transacao */
                                           INPUT "":U, /* Codigo do Equipamento */
                                           INPUT "":U, /* Codigo da Variavel Datasul */
                                           INPUT "":U, /* Codigo da Variavel Equipamento */
                                           INPUT 0, /* Numero do Erro */
                                           INPUT "Servidor nao encontrado.":U, /* Mensagem de Erro */
                                           INPUT "":U). /* Detalhe da Mensagem */
        RUN saveErrors IN THIS-PROCEDURE.

        RETURN "NOK":U.
    END.

    RUN saveErrors IN THIS-PROCEDURE.

    ASSIGN lIsTurnedOn = NO.

    IF VALID-HANDLE(hTimer) THEN DO:
        RUN removeListener IN hTimer (INPUT THIS-PROCEDURE,
                                      INPUT "doTransactions":U).
        RUN shutdownTimer  IN hTimer.

        DELETE OBJECT hTimer.
    END.

    FOR EACH ttListeners NO-LOCK:
        RUN removeListener IN THIS-PROCEDURE (INPUT ttListeners.hListener).
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startManager DBOFunction 
PROCEDURE startManager :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUFFER bfBCServidor FOR bc-servid.

    FIND bfBCServidor NO-LOCK WHERE
         bfBCServidor.cod-servid = ipcCodServer NO-ERROR.

    IF AVAIL bfBCServidor THEN DO:

        IF NOT bfBCServidor.log-servid-ativ THEN DO TRANS:

            FIND CURRENT bfBCServidor EXCLUSIVE-LOCK NO-ERROR.

            ASSIGN lIsTurnedOn = YES
                   bfBCServidor.log-servid-ativ = YES.

            FIND CURRENT bfBCServidor NO-LOCK NO-ERROR.

            RUN bcp/bc0706t.w PERSISTENT SET hTimer.

            RUN addListener IN hTimer (INPUT THIS-PROCEDURE,
                                       INPUT "doTransactions":U).
            RUN setInterval IN hTimer (INPUT (bfBCServidor.num-interv-monit * 1000)). /* Multiplica por 1000 porque o interval do Timer esta em milisegundos */
            RUN startTimer  IN hTimer.

        /*    RUN doTransactions IN THIS-PROCEDURE.*/

            RETURN "OK":U.
        END.
        ELSE
            RUN insertError IN THIS-PROCEDURE (INPUT ipcCodServer, /* Codigo do Servidor */
                                               INPUT "":U, /* Codigo da Transacao */
                                               INPUT "":U, /* Codigo do Equipamento */
                                               INPUT "":U, /* Codigo da Variavel Datasul */
                                               INPUT "":U, /* Codigo da Variavel Equipamento */
                                               INPUT 0, /* Numero do Erro */
                                               INPUT "Servidor ja esta ativado.":U, /* Mensagem de Erro */
                                               INPUT "":U). /* Detalhe da Mensagem */
    END.
    ELSE
        RUN insertError IN THIS-PROCEDURE (INPUT ipcCodServer, /* Codigo do Servidor */
                                           INPUT "":U, /* Codigo da Transacao */
                                           INPUT "":U, /* Codigo do Equipamento */
                                           INPUT "":U, /* Codigo da Variavel Datasul */
                                           INPUT "":U, /* Codigo da Variavel Equipamento */
                                           INPUT 0, /* Numero do Erro */
                                           INPUT "Servidor nao encontrado.":U, /* Mensagem de Erro */
                                           INPUT "":U). /* Detalhe da Mensagem */
    RUN saveErrors IN THIS-PROCEDURE.

    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

