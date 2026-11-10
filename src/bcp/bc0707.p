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
{include/i-prgvrs.i BC0707 2.00.00.003}  /*** 010003 ***/
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
&GLOBAL-DEFINE DBOName    BC0707
&GLOBAL-DEFINE DBOVersion 1.00.00.000

&GLOBAL-DEFINE Processada 2
&GLOBAL-DEFINE Erro       3

{bcp/bc0706.i}

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER iprBCTipoTransEquip AS ROWID NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-server-error.

/* Local Variable Definitions ---                                       */
DEFINE BUFFER bfBCEqpto             FOR bc-eqpto.
DEFINE BUFFER bfBCTipoTransEquip    FOR bc-tip-trans-eqpto.
DEFINE BUFFER bfBCTipoTransEquipVar FOR bc-tip-trans-eqpto-var.
DEFINE BUFFER bfBCTrans             FOR bc-trans.
DEFINE BUFFER bfBCTransAux          FOR bc-trans.
DEFINE BUFFER bfBCTransFilho        FOR bc-trans-filho.

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
         HEIGHT             = 10.08
         WIDTH              = 40.14.
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
FIND bfBCTipoTransEquip NO-LOCK WHERE
     ROWID(bfBCTipoTransEquip) = iprBCTipoTransEquip NO-ERROR.

IF NOT AVAIL bfBCTipoTransEquip THEN DO:
    RUN insServError IN THIS-PROCEDURE (INPUT "":U, /* Codigo do Servidor */
                                        INPUT "":U, /* Codigo da Transacao */
                                        INPUT "":U, /* Codigo do Equipamento */
                                        INPUT "":U, /* Codigo da Variavel Datasul */
                                        INPUT "":U, /* Codigo da Variavel Equipamento */
                                        INPUT 0, /* Numero do Erro */
                                        INPUT "Transacao do Equipamento nao encontrada.":U, /* Mensagem de Erro */
                                        INPUT "":U). /* Detalhe da Mensagem */
    RETURN "NOK":U.
END.

FIND bfBCEqpto NO-LOCK WHERE
     bfBCEqpto.cod-eqpto = bfBCTipoTransEquip.cod-eqpto NO-ERROR.

IF NOT AVAIL bfBCEqpto THEN DO:
    RUN insServError IN THIS-PROCEDURE (INPUT "":U, /* Codigo do Servidor */
                                        INPUT bfBCTipoTransEquip.cd-trans, /* Codigo da Transacao */
                                        INPUT bfBCTipoTransEquip.cod-eqpto, /* Codigo do Equipamento */
                                        INPUT "":U, /* Codigo da Variavel Datasul */
                                        INPUT "":U, /* Codigo da Variavel Equipamento */
                                        INPUT 0, /* Numero do Erro */
                                        INPUT "Equipamento nao foi encontrado.":U, /* Mensagem de Erro */
                                        INPUT "":U). /* Detalhe da Mensagem */
    RETURN "NOK":U.
END.

/* Verifica todas as transacoes que estao com o status diferente de 2 (processada) */
FOR EACH  bfBCTrans NO-LOCK
    WHERE bfBCTrans.cd-trans      = bfBCTipoTransEquip.cd-trans
    AND   bfBCTrans.estado-trans <> {&Processada}:

    /* Validar (bfBCTrans.estado-trans = 3 - ERRO) */
    IF bfBCTrans.estado-trans = {&Erro} THEN DO:
        IF NOT bfBCTipoTransEquip.log-reproces-erro THEN
            NEXT.

        RUN validateErrorTransaction IN THIS-PROCEDURE (INPUT ROWID(bfBCTipoTransEquip),
                                                        INPUT ROWID(bfBCTrans)).
        IF RETURN-VALUE = "NOK":U THEN
            NEXT.
    END.

    EMPTY TEMP-TABLE tt-var-equip.

    /* Busca as variaveis na bc-trans-filho */
    FOR EACH  bfBCTransFilho NO-LOCK
        WHERE bfBCTransFilho.nr-trans = bfBCTrans.nr-trans:

        /* Cria tt-var-equip para as variaveis filhas da transacao */
        CREATE tt-var-equip.
        ASSIGN tt-var-equip.cod-servidor  = bfBCEqpto.cod-servid
               tt-var-equip.cd-trans      = bfBCTrans.cd-trans
               tt-var-equip.cod-eqpto     = bfBCTipoTransEquip.cod-eqpto
               tt-var-equip.dt-geracao    = TODAY
               tt-var-equip.hr-geracao    = STRING(TIME, "HH:MM:SS":U)
               tt-var-equip.cod-var-dtsul = ENTRY(2,bfBCTransFilho.conteudo-trans,CHR(30))
               tt-var-equip.valor         = ENTRY(3,bfBCTransFilho.conteudo-trans,CHR(30)).

        FIND bfBCTipoTransEquipVar EXCLUSIVE-LOCK WHERE
             bfBCTipoTransEquipVar.cd-trans      = tt-var-equip.cd-trans      AND
             bfBCTipoTransEquipVar.cod-var-dtsul = tt-var-equip.cod-var-dtsul AND
             bfBCTipoTransEquipVar.cod-eqpto     = tt-var-equip.cod-eqpto     NO-ERROR.

        IF AVAIL bfBCTipoTransEquipVar THEN
            ASSIGN bfBCTipoTransEquipVar.ind-val-leitura = "":U
                   bfBCTipoTransEquipVar.ind-val-gerac-trans-ant = bfBCTipoTransEquipVar.ind-val-gerac-trans
                   bfBCTipoTransEquipVar.ind-val-gerac-trans     = tt-var-equip.valor.
    END.

    /* Verifica se a procedure de verificacao retorna um valor valido */
    IF bfBCTipoTransEquip.cod-prog-validac <> "":U THEN DO:
        RUN VALUE(bfBCTipoTransEquip.cod-prog-validac) (INPUT-OUTPUT TABLE tt-var-equip,
                                                        INPUT-OUTPUT TABLE tt-server-error).
        IF RETURN-VALUE <> "OK":U THEN DO:
            RUN insServError IN THIS-PROCEDURE (INPUT bfBCEqpto.cod-servid, /* Codigo do Servidor */
                                                INPUT bfBCTipoTransEquip.cd-trans, /* Codigo da Transacao */
                                                INPUT bfBCTipoTransEquip.cod-eqpto, /* Codigo do Equipamento */
                                                INPUT "":U, /* Codigo da Variavel Datasul */
                                                INPUT "":U, /* Codigo da Variavel Equipamento */
                                                INPUT 0, /* Numero do Erro */
                                                INPUT "Programa de validacao retornou erro.":U, /* Mensagem de Erro */
                                                INPUT "":U). /* Detalhe da Mensagem */
            RETURN "NOK":U.
        END.
    END.
/**/
    /* Verifica se existem condicoes para gerar a transacao */
    RUN bcp/bc0706e.p (INPUT  iprBCTipoTransEquip,
                       INPUT-OUTPUT TABLE tt-var-equip,
                       INPUT-OUTPUT TABLE tt-server-error).

    IF RETURN-VALUE <> "OK":U THEN DO:
        RETURN "NOK":U.
    END.
/**/
    /* Faz a traducao das variaveis conforme */
    RUN bcp/bc0706f.p (INPUT        bfBCTipoTransEquip.idi-sentido-trans,
                       INPUT-OUTPUT TABLE tt-var-equip,
                       INPUT-OUTPUT TABLE tt-server-error).

    IF RETURN-VALUE <> "OK":U THEN RETURN "NOK":U.

    /* Efetiva a transacao. Aqui vai ter a api para enviar ao equipamento */
    RUN setOPCValue IN THIS-PROCEDURE.

    IF RETURN-VALUE <> "OK":U THEN RETURN "NOK":U.

    FIND bfBCTransAux EXCLUSIVE-LOCK WHERE
         ROWID(bfBCTransAux) = ROWID(bfBCTrans) NO-ERROR.

    IF RETURN-VALUE <> "OK":U THEN DO:
        ASSIGN bfBCTransAux.estado-trans = {&Erro}.

        /* erro - popular bc-trans-erros */
    END.
    ELSE DO:
        ASSIGN bfBCTransAux.estado-trans = {&Processada}.
    END.

    FIND CURRENT bfBCTransAux NO-LOCK NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setOPCValue DBOFunction 
PROCEDURE setOPCValue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUFFER bfBCParamEqpto FOR bc-param-eqpto.
    DEFINE BUFFER bfBCTipEqpto   FOR bc-tip-eqpto.

    DEFINE VARIABLE hCommApi AS HANDLE     NO-UNDO.

    CREATE tt-server-param.
    ASSIGN tt-server-param.paramName  = "OPCServerName":U
           tt-server-param.paramValue = TRIM(bfBCEqpto.cod-servid).

    FOR EACH  bfBCParamEqpto NO-LOCK
        WHERE bfBCParamEqpto.cod-eqpto = bfBCEqpto.cod-eqpto:

        CREATE tt-server-param.
        ASSIGN tt-server-param.paramName  = bfBCParamEqpto.cod-param
               tt-server-param.paramValue = TRIM(bfBCParamEqpto.dsl-val-param).
    END.

    FIND FIRST bfBCTipEqpto NO-LOCK
         WHERE bfBCTipEqpto.cod-tip-eqpto = bfBCEqpto.cod-tip-eqpto NO-ERROR.

    IF NOT AVAIL bfBCTipEqpto THEN DO:
        RUN insServError IN THIS-PROCEDURE (INPUT bfBCEqpto.cod-servid,         /* Codigo do Servidor */
                                            INPUT bfBCTipoTransEquip.cd-trans,  /* Codigo da Transacao */
                                            INPUT bfBCTipoTransEquip.cod-eqpto, /* Codigo do Equipamento */
                                            INPUT "":U,                         /* Codigo da Variavel Datasul */
                                            INPUT "":U,                         /* Codigo da Variavel Equipamento */
                                            INPUT 0,                            /* Numero do Erro */
                                            INPUT "Tipo de Equipamento nao encontrado.":U, /* Mensagem de Erro */
                                            INPUT "":U). /* Detalhe da Mensagem */
        RETURN "NOK":U.
    END.

    RUN VALUE(TRIM(bfBCTipEqpto.cod-livre-1)) PERSISTENT SET hCommApi (INPUT TABLE tt-server-param).
    
    RUN connectOPCServer    IN hCommApi (INPUT-OUTPUT TABLE tt-server-error).
    IF RETURN-VALUE <> "OK":U THEN RETURN "NOK":U.

    RUN setOPCValues        IN hCommApi (INPUT-OUTPUT TABLE tt-var-equip,
                                         INPUT-OUTPUT TABLE tt-server-error).
    IF RETURN-VALUE <> "OK":U THEN RETURN "NOK":U.

    RUN disconnectOPCServer IN hCommApi.
    IF RETURN-VALUE <> "OK":U THEN RETURN "NOK":U.

    DELETE OBJECT hCommApi.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateErrorTransaction DBOFunction 
PROCEDURE validateErrorTransaction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER iprBCTipTransEqpto AS ROWID      NO-UNDO.
    DEFINE INPUT  PARAMETER ipcTransChar-1     AS CHARACTER  NO-UNDO.

    DEFINE BUFFER bfBCTipTransEqpto FOR bc-tip-trans-eqpto.

    DEFINE VARIABLE deTimeInterval AS DECIMAL    NO-UNDO.

    DEFINE VARIABLE iExecNumber AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iHourLog    AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iMinLog     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iNewHour    AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iNewMin     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iNewSec     AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iSecLog     AS INTEGER    NO-UNDO.

    FIND bfBCTipTransEqpto NO-LOCK WHERE
         ROWID(bfBCTipTransEqpto) = iprBCTipTransEqpto NO-ERROR.

    IF NOT AVAIL bfBCTipTransEqpto THEN
        RETURN "NOK":U.

    ASSIGN iExecNumber = INTEGER(ENTRY(3,ipcTransChar-1,"|":U)).

    IF bfBCTipTransEqpto.num-exec-erro < iExecNumber THEN
        RETURN "NOK":U. /* Ou OK nao sei ainda */

    ASSIGN deTimeInterval = ((TODAY - DATE(ENTRY(1,ipcTransChar-1,"|":U))) * 86400) /* Multiplica por 86400, porque um dia tem 86400 segundos */

           iHourLog = INTEGER(ENTRY(1,ENTRY(2,ipcTransChar-1,"|":U),":":U))
           iMinLog  = INTEGER(ENTRY(2,ENTRY(2,ipcTransChar-1,"|":U),":":U))
           iSecLog  = INTEGER(ENTRY(3,ENTRY(2,ipcTransChar-1,"|":U),":":U))

           iNewHour = INTEGER(ENTRY(1,STRING(TIME, "HH:MM:SS":U),":":U))
           iNewMin  = INTEGER(ENTRY(2,STRING(TIME, "HH:MM:SS":U),":":U))
           iNewSec  = INTEGER(ENTRY(3,STRING(TIME, "HH:MM:SS":U),":":U))

           deTimeInterval = deTimeInterval
                          + iNewHour - iHourLog  * 3600
                          + ((iNewMin - iMinLog) * 60)
                          + ((iNewSec - iSecLog)).

    IF NOT deTimeInterval > DECIMAL(bfBCTipTransEqpto.num-interv-exec-erro) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

