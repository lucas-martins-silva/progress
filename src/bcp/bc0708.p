/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0708 2.00.00.003}  /*** 010003 ***/
&IF INTEGER(ENTRY(1, PROVERSION, ".")) >= 10 
    OR (INTEGER(ENTRY(1, PROVERSION, ".")) = 9 AND 
    ENTRY(2, PROVERSION, ".") > "1C":U) &THEN
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOFunction 

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc0708 MBC}
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
&GLOBAL-DEFINE DBOName    BC0708
&GLOBAL-DEFINE DBOVersion 1.00.00.000

{utp/ut-glob.i}

{cdp/cd0666.i}      /* Definicao da temp-table de erros         */
{bcp/bcapi001.i}    /* Definicao da temp-table de transacoes    */

{bcp/bc0706.i}

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER iprBCTipoTransEquip AS ROWID      NO-UNDO.

/*DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-server-error.*/
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE hTTServerError.

{bcp/bc0706.i1}

/* Local Variable Definitions ---                                       */
DEFINE BUFFER bfBCEqpto             FOR bc-eqpto.
DEFINE BUFFER bfBCTipoTransEquip    FOR bc-tip-trans-eqpto.
DEFINE BUFFER bfBCTipoTransEquipVar FOR bc-tip-trans-eqpto-var.
DEFINE BUFFER bfBCTrans             FOR bc-trans.
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
         HEIGHT             = 10.5
         WIDTH              = 42.57.
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

EMPTY TEMP-TABLE tt-var-equip.

FOR EACH  bfBCTipoTransEquipVar NO-LOCK
    WHERE bfBCTipoTransEquipVar.cd-trans  = bfBCTipoTransEquip.cd-trans
    AND   bfBCTipoTransEquipVar.cod-eqpto = bfBCTipoTransEquip.cod-eqpto:

    /* Cria tt-var-equip para as variaveis do equipamento */
    CREATE tt-var-equip.
    ASSIGN tt-var-equip.cod-servidor  = bfBCEqpto.cod-servid
           tt-var-equip.cd-trans      = bfBCTipoTransEquipVar.cd-trans
           tt-var-equip.cod-eqpto     = bfBCTipoTransEquipVar.cod-eqpto
           tt-var-equip.dt-geracao    = TODAY
           tt-var-equip.hr-geracao    = STRING(TIME, "HH:MM:SS":U)
           tt-var-equip.cod-var-dtsul = bfBCTipoTransEquipVar.cod-var-dtsul
           tt-var-equip.cod-var-eqpto = bfBCTipoTransEquipVar.cod-var-eqpto.
END.

/* Buscando os valores das variaveis do Equipamento */
RUN getOPCValues IN THIS-PROCEDURE.

/* Faz a traducao das variaveis conforme transacao */
RUN bcp/bc0706f.p (INPUT        bfBCTipoTransEquip.idi-sentido-trans,
                   INPUT-OUTPUT TABLE tt-var-equip,
                   INPUT-OUTPUT TABLE-HANDLE hTTServerError).

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

/* Verifica se a procedure de verificacao retorna um valor valido */
IF bfBCTipoTransEquip.cod-prog-validac <> "":U THEN DO:
    RUN VALUE(bfBCTipoTransEquip.cod-prog-validac) (INPUT-OUTPUT TABLE tt-var-equip,
                                                    INPUT-OUTPUT TABLE-HANDLE hTTServerError).
    IF RETURN-VALUE <> "OK":U THEN DO:
        RETURN "NOK":U.
    END.
END.

/* Verifica se existem condicoes para gerar a transacao */
RUN bcp/bc0706e.p (INPUT  iprBCTipoTransEquip,
                   INPUT-OUTPUT TABLE tt-var-equip,
                   INPUT-OUTPUT TABLE-HANDLE hTTServerError).

IF RETURN-VALUE = "OK":U THEN DO:
    /* Cria a transacao */
    RUN createTransactions IN THIS-PROCEDURE.
END.
ELSE DO:

        
        FOR EACH tt-var-equip NO-LOCK:
            FIND bfBCTipoTransEquipVar EXCLUSIVE-LOCK WHERE
                 bfBCTipoTransEquipVar.cd-trans      = tt-var-equip.cd-trans      AND
                 bfBCTipoTransEquipVar.cod-var-dtsul = tt-var-equip.cod-var-dtsul AND
                 bfBCTipoTransEquipVar.cod-eqpto     = tt-var-equip.cod-eqpto     
                 NO-ERROR.
    
            IF AVAIL bfBCTipoTransEquipVar THEN
                ASSIGN bfBCTipoTransEquipVar.ind-val-leitura = tt-var-equip.valor.
        END.

END.

RETURN "OK":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTransactions DBOFunction 
PROCEDURE createTransactions :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUFFER bfBCTipoTransEquipVar FOR bc-tip-trans-eqpto-var.

    DEFINE VARIABLE hBCApi001 AS HANDLE     NO-UNDO.

    DEFINE VARIABLE iSeq    AS INTEGER    NO-UNDO
        INITIAL 1.
    DEFINE VARIABLE iSeqVar AS INTEGER    NO-UNDO
        INITIAL 1.

    EMPTY TEMP-TABLE tt-trans.
    EMPTY TEMP-TABLE tt-trans-ext.
    EMPTY TEMP-TABLE tt-trans-filho.
    EMPTY TEMP-TABLE tt-erro.

    FOR EACH tt-var-equip NO-LOCK
        BREAK BY tt-var-equip.cd-trans:

        FIND bfBCTipoTransEquipVar EXCLUSIVE-LOCK WHERE
             bfBCTipoTransEquipVar.cd-trans      = tt-var-equip.cd-trans      AND
             bfBCTipoTransEquipVar.cod-var-dtsul = tt-var-equip.cod-var-dtsul AND
             bfBCTipoTransEquipVar.cod-eqpto     = tt-var-equip.cod-eqpto     NO-ERROR.

        IF AVAIL bfBCTipoTransEquipVar THEN
/*            ASSIGN bfBCTipoTransEquipVar.ind-val-leitura = "":U*/
            ASSIGN bfBCTipoTransEquipVar.ind-val-leitura         = tt-var-equip.valor
                   bfBCTipoTransEquipVar.ind-val-gerac-trans-ant = bfBCTipoTransEquipVar.ind-val-gerac-trans
                   bfBCTipoTransEquipVar.ind-val-gerac-trans     = tt-var-equip.valor.

        CREATE tt-trans-filho.
        ASSIGN tt-trans-filho.i-sequen-pai          = iSeq
               tt-trans-filho.i-sequen              = iSeqVar
               tt-trans-filho.num-versao            = 1
               tt-trans-filho.cod-versao-integracao = 1
               tt-trans-filho.conteudo-xml          = tt-var-equip.cod-eqpto + CHR(30) + tt-var-equip.cod-var-dtsul + CHR(30) + tt-var-equip.valor

               iSeqVar = iSeqVar + 1.

/*        IF LAST-OF(tt-var-equip.cd-trans) THEN DO TRANS:*/
        IF LAST-OF(tt-var-equip.cd-trans) THEN DO:
            CREATE tt-trans.
            ASSIGN tt-trans.cod-versao-integracao = 1
                   tt-trans.i-sequen              = iSeq
                   tt-trans.cd-trans              = tt-var-equip.cd-trans
                   tt-trans.nr-trans              = 0
                   tt-trans.detalhe               = "EQUIPAMENTO:":U + tt-var-equip.cod-eqpto
                                                  + " CD TRANS:":U + tt-var-equip.cd-trans
                                                  + " DATA:":U + STRING(TODAY, "99/99/9999":U)
                                                  + " HORA:":U + STRING(TIME, "HH:MM:SS":U)
                   tt-trans.usuario               = c-seg-usuario
                   tt-trans.atualizada            = NO
                   tt-trans.etiqueta              = NO

                   iSeq    = iSeq + 1
                   iSeqVar = 1.
        END.
    END.

    RUN bcp/bcapi001.p PERSISTENT SET hBCApi001 (INPUT-OUTPUT TABLE tt-trans,
                                                 INPUT-OUTPUT TABLE tt-erro).

    RUN atualizaTransacao IN hBCApi001 (INPUT-OUTPUT TABLE tt-trans,
                                        INPUT-OUTPUT TABLE tt-trans-ext,
                                        INPUT-OUTPUT TABLE tt-trans-filho,
                                        INPUT-OUTPUT TABLE tt-erro).
    DELETE OBJECT hBCApi001.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getOPCValues DBOFunction 
PROCEDURE getOPCValues :
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

/* colocar OPCServerName na mÆo */

    FIND FIRST bfBCTipEqpto NO-LOCK
         WHERE bfBCTipEqpto.cod-tip-eqpto = bfBCEqpto.cod-tip-eqpto NO-ERROR.

    IF NOT AVAIL bfBCTipEqpto THEN DO:
        RUN insServError IN THIS-PROCEDURE (INPUT "":U, /* Codigo do Servidor */
                                            INPUT "":U, /* Codigo da Transacao */
                                            INPUT "":U, /* Codigo do Equipamento */
                                            INPUT "":U, /* Codigo da Variavel Datasul */
                                            INPUT "":U, /* Codigo da Variavel Equipamento */
                                            INPUT 0, /* Numero do Erro */
                                            INPUT "Tipo de Equipamento nao encontrado.":U, /* Mensagem de Erro */
                                            INPUT "":U). /* Detalhe da Mensagem */
        RETURN "NOK":U.
    END.

    RUN VALUE(TRIM(bfBCTipEqpto.cod-livre-1)) PERSISTENT SET hCommApi (INPUT TABLE tt-server-param).
    
    RUN connectOPCServer    IN hCommApi (INPUT-OUTPUT TABLE tt-server-error).

    RUN getOPCValues        IN hCommApi (INPUT-OUTPUT TABLE tt-var-equip,
                                         INPUT-OUTPUT TABLE tt-server-error).

    RUN disconnectOPCServer IN hCommApi.

    DELETE OBJECT hCommApi.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&endif
