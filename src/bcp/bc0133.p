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
{include/i-prgvrs.i BC0133 2.00.00.002}  /*** "010002" ***/
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
&GLOBAL-DEFINE DBOName    BC0133
&GLOBAL-DEFINE DBOVersion 1.00.00.000

{bcp/bc0706.i}

/* TEMP-TABLE Erros de Login EMS2/HR */
DEF TEMP-TABLE ttLoginErrorsEMS2HR NO-UNDO
    FIELD cod-erro  AS INTEGER
    FIELD desc-erro AS CHARACTER
    FIELD desc-arq  AS CHARACTER.

DEFINE VARIABLE cUserName       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cUserPasswd     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDominioUsuario AS CHARACTER  NO-UNDO.

{include/i_framevers.i}

&IF "{&FRAME_VERSION}" = "1" &THEN /* Novo Frame */
DEFINE NEW GLOBAL SHARED VARIABLE oSessionParams AS CLASS   com.totvs.framework.utp.SessionParams NO-UNDO.
ASSIGN
    cUserName       = oSessionParams:codUsuar
    cDominioUsuario = oSessionParams:userDomain.
&ELSE /* Jboss */
ASSIGN
    cUserName       = ENTRY(4,SESSION:PARAMETER) 
    cUserPasswd     = ENTRY(5, SESSION:PARAMETER) NO-ERROR.
&ENDIF


/* Local Variable Definitions ---                                       */
DEFINE BUFFER bfBCServid FOR bc-servid.

DEFINE STREAM stErrorLog.

DEFINE VARIABLE cServerName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cStatus     AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hManager AS HANDLE     NO-UNDO.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOFunction ASSIGN
         HEIGHT             = 9.04
         WIDTH              = 39.43.
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
RUN doLogin IN THIS-PROCEDURE.

IF RETURN-VALUE = "OK":U THEN DO:

    RUN getParameters IN THIS-PROCEDURE (OUTPUT cServerName,
                                         OUTPUT cStatus).
    IF RETURN-VALUE = "OK":U THEN
        IF cStatus = "ON":U THEN DO:
            RUN bcp/bc0706.p PERSISTENT SET hManager (INPUT        cServerName, /* ipcCodServer */
                                                      INPUT        TRUE, /* iplStatus */
                                                      INPUT-OUTPUT TABLE tt-server-error).

            /* Sempre desliga o gerenciador antes de liga-lo, para garantir que o servico funcione corretamente,
             * pois se o gerenciador nao foi desligado corretamente podem acontecer alguns problemas quando
             * liga-lo.
             */
            RUN shutdownManager IN hManager.
            RUN addListener     IN hManager (INPUT THIS-PROCEDURE,
                                             INPUT "":U,
                                             INPUT "shutdownManager":U).
            RUN startManager    IN hManager.

            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN getErrors IN hManager (OUTPUT TABLE tt-server-error).

                RUN saveErrors IN THIS-PROCEDURE.

                IF VALID-HANDLE(hManager) THEN
                    DELETE OBJECT hManager.

                QUIT.
            END.
        END.
        ELSE DO:
            FIND bfBCServid NO-LOCK WHERE
                 bfBCServid.cod-servid = cServerName NO-ERROR.

            IF NOT AVAIL bfBCServid THEN DO:
                RUN insertError IN THIS-PROCEDURE (INPUT "":U, /* Codigo do Servidor */
                                                   INPUT "":U, /* Codigo da Transacao */
                                                   INPUT "":U, /* Codigo do Equipamento */
                                                   INPUT "":U, /* Codigo da Variavel Datasul */
                                                   INPUT "":U, /* Codigo da Variavel Equipamento */
                                                   INPUT 0, /* Numero do Erro */
                                                   INPUT "Servidor nao informado nos parametros.":U, /* Mensagem de Erro */
                                                   INPUT "":U). /* Detalhe da Mensagem */
                RUN saveErrors IN THIS-PROCEDURE.
            END.
            ELSE DO TRANS:
                FIND CURRENT bfBCServid EXCLUSIVE-LOCK NO-ERROR.

                ASSIGN bfBCServid.log-servid-ativ = NO.

                FIND CURRENT bfBCServid NO-LOCK NO-ERROR.
            END.

            QUIT.
        END.
END.

WAIT-FOR "close":U OF THIS-PROCEDURE.

RUN saveErrors IN THIS-PROCEDURE.

QUIT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doLogin DBOFunction 
PROCEDURE doLogin :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    /* FAZ LOGIN AUTOMATICO */
    RUN btb/btapi910za.p (INPUT  cUserName,
                          INPUT  cUserPasswd,
                          OUTPUT TABLE ttLoginErrorsEMS2HR).

    IF CAN-FIND(FIRST ttLoginErrorsEMS2HR NO-LOCK) THEN DO:
        RUN insertError IN THIS-PROCEDURE (INPUT "":U, /* Codigo do Servidor */
                                           INPUT "":U, /* Codigo da Transacao */
                                           INPUT "":U, /* Codigo do Equipamento */
                                           INPUT "":U, /* Codigo da Variavel Datasul */
                                           INPUT "":U, /* Codigo da Variavel Equipamento */
                                           INPUT 0, /* Numero do Erro */
                                           INPUT "Erro no processo de login automatico.":U, /* Mensagem de Erro */
                                           INPUT "":U). /* Detalhe da Mensagem */

        FOR EACH ttLoginErrorsEMS2HR NO-LOCK:
            RUN insertError IN THIS-PROCEDURE (INPUT "":U, /* Codigo do Servidor */
                                               INPUT "":U, /* Codigo da Transacao */
                                               INPUT "":U, /* Codigo do Equipamento */
                                               INPUT "":U, /* Codigo da Variavel Datasul */
                                               INPUT "":U, /* Codigo da Variavel Equipamento */
                                               INPUT ttLoginErrorsEMS2HR.cod-erro, /* Numero do Erro */
                                               INPUT ttLoginErrorsEMS2HR.desc-erro, /* Mensagem de Erro */
                                               INPUT "":U). /* Detalhe da Mensagem */
        END.

        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getParameters DBOFunction 
PROCEDURE getParameters :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER opcServerName AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER opcStatus     AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE cServerParam AS CHARACTER  NO-UNDO.

    &IF "{&FRAME_VERSION}" = "0" &THEN /* 0 = Legado; 1 = Novo Frame */
    
        ASSIGN cServerParam  = ENTRY(6, SESSION:PARAMETER)
               opcServerName = ENTRY(1, cServerParam, "|":U)
               opcStatus     = ENTRY(2, cServerParam, "|":U).
    &ENDIF



    IF opcServerName = "":U THEN DO:
        RUN insertError IN THIS-PROCEDURE (INPUT "":U, /* Codigo do Servidor */
                                           INPUT "":U, /* Codigo da Transacao */
                                           INPUT "":U, /* Codigo do Equipamento */
                                           INPUT "":U, /* Codigo da Variavel Datasul */
                                           INPUT "":U, /* Codigo da Variavel Equipamento */
                                           INPUT 0, /* Numero do Erro */
                                           INPUT "Servidor nao informado nos parametros.":U, /* Mensagem de Erro */
                                           INPUT "":U). /* Detalhe da Mensagem */
        RETURN "NOK":U.
    END.

    RETURN "OK":U.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveErrors DBOFunction 
PROCEDURE saveErrors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cHost    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cLogFile AS CHARACTER  NO-UNDO.

    ASSIGN cHost = OS-GETENV("COMPUTERNAME":U).

    IF cHost = ? THEN
        ASSIGN cHost = "":U.

    OUTPUT STREAM stErrorLog TO VALUE(SESSION:TEMP-DIRECTORY + "bc0133.log":U) APPEND /*CONVERT TARGET "iso8859-1":U*/ .

    FOR EACH tt-server-error NO-LOCK:
        PUT STREAM stErrorLog
            UNFORMATTED SKIP(1)
            TODAY " ":U

            STRING(TIME,"HH:MM:SS":U) FORMAT "x(9)":U

            cHost FORMAT "x(20)":U

            " ":U tt-server-error.cod-servid
            " ":U tt-server-error.cd-trans
            " ":U tt-server-error.cod-eqpto
            " ":U tt-server-error.cod-var-dtsul
            " ":U tt-server-error.cod-var-eqpto
            " ":U STRING(tt-server-error.num-erro)
            " ":U tt-server-error.dsl-msg-erro
            " ":U tt-server-error.dsl-det-msg

            SKIP.
    END.

    OUTPUT STREAM stErrorLog CLOSE.

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

    RUN getErrors IN hManager (OUTPUT TABLE tt-server-error).

    IF VALID-HANDLE(hManager) THEN
        DELETE OBJECT hManager.

    APPLY "close":U TO THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

