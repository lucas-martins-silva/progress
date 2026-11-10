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
{include/i-prgvrs.i ABAPI011 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i abapi011 MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: ABAPI011.p
**
**       DATA....: Agosto de 2005
**
**       AUTOR...: Marcio da Silva.
**
**       OBJETIVO: Fazer a integra‡Æo entre o Frotas e o Patrim“nio do EMS2 ou 5,
**                 fazendo a atualiza‡Æo do campo ËSitua‡Æo (c¢d-sit-eqpto)Ì e 
**                 ËData da Situa‡Æo(dat-situacao)Ì da tabela MAB-EQPTO.
**                 recebendo os seguintes parƒmetros:
**                 run abp/abapi011.p (input  pi-ep-codigo,
**                                     input  pc-cod_cta_pat,
**                                     input  pi-bm-codigo,
**                                     input  pi-bm-indice,
**                                     input  pd-data,
**                                     input  pc-situacao,
**                                     output table RowErrors).
**
*****************************************************************************/


/* ***************************  Definitions  ************************** */
/*Variaveis*/
DEFINE VARIABLE iRowidSit AS INTEGER    NO-UNDO.

/*HANDLES*/
DEFINE VARIABLE h-bofr007 AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-bofr024 AS HANDLE     NO-UNDO.

/*TEMP-TABLES*/
{abp/abapi011.i}
{frbo/bofr007.i tt-mab-eqpto}
{frbo/bofr024.i tt-mab-sit-eqpto}


/*PARAMETROS*/
DEFINE INPUT  PARAMETER TABLE FOR tt_trans_bem.
DEFINE OUTPUT PARAMETER TABLE FOR tt_row_errors.

/*GLOBAIS*/
DEFINE NEW GLOBAL SHARED VARIABLE v_log_eai_habilit AS LOGICAL NO-UNDO.

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
         HEIGHT             = 8.21
         WIDTH              = 35.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

FIND FIRST tt_trans_bem EXCLUSIVE-LOCK NO-ERROR.
RUN pi-inicializa IN THIS-PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-atualiza-eqpto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-eqpto Procedure 
PROCEDURE pi-atualiza-eqpto :
/*------------------------------------------------------------------------------
  Purpose:     atualiza estabelecimento do eqpto
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-cod-situacao AS CHARACTER FORMAT "x(8)" NO-UNDO.
DEFINE VARIABLE c-hra-situacao AS CHARACTER FORMAT "x(6)" NO-UNDO.

IF  AVAIL mab-eqpto THEN DO:
    ASSIGN c-cod-situacao = ""
           c-hra-situacao = "".
    RUN pi-inicializa-handle-situacao IN THIS-PROCEDURE. /*inicializacao handles BO situa‡Æo equipamento*/

    IF  RETURN-VALUE = "NOK" THEN DO:
        EMPTY TEMP-TABLE tt-mab-sit-eqpto.
        RUN emptyRowErrors IN h-bofr024.
        RUN openQueryStatic IN h-bofr024 (INPUT "Main":U) NO-ERROR.

        /** Busca TT da BO **/
        RUN getBatchRecords IN h-bofr024 (INPUT ?,
                                          INPUT no,
                                          INPUT 9999,
                                          OUTPUT iRowidSit,
                                          OUTPUT TABLE tt-mab-sit-eqpto).

        /*--- Verifica ocorr¼ncia de erros durante a transa»’o ---*/
        IF  RETURN-VALUE = "NOK":U THEN DO:
            /*--- Retorna temp-table tt_row_errors do DBO ---*/
            RUN getRowErrors IN h-bofr024 (OUTPUT TABLE tt_row_errors). 
            RETURN "NOK":U.
        END.
        IF  tt_trans_bem.ttv_dat_trans = ? THEN DO:
            FOR FIRST tt-mab-sit-eqpto
                WHERE tt-mab-sit-eqpto.idi-tip = 1 NO-LOCK:
                ASSIGN c-cod-situacao = tt-mab-sit-eqpto.cod-sit-eqpto
                       c-hra-situacao = "":U.
            END.
        END.
        IF  tt_trans_bem.ttv_dat_trans <> ? THEN DO:
            FOR FIRST tt-mab-sit-eqpto
                WHERE tt-mab-sit-eqpto.idi-tip = 2 NO-LOCK:
                ASSIGN c-cod-situacao = tt-mab-sit-eqpto.cod-sit-eqpto.
                ASSIGN c-hra-situacao = REPLACE(STRING(TIME,"HH:MM:SS"),":","").
            END.
        END.
    END.
    ELSE DO:
        FIND FIRST tt-mab-sit-eqpto NO-LOCK NO-ERROR.
        IF  AVAIL tt-mab-sit-eqpto THEN
            ASSIGN c-cod-situacao = tt-mab-sit-eqpto.cod-sit-eqpto.
    END.
    IF  c-cod-situacao <> "" THEN DO:
        RUN pi-inicializa-handle-eqpto IN THIS-PROCEDURE. /*inicializacao handles BO eqpto*/

        /*:T Posiciona query, do DBO, atrav‚s dos valores do ­ndice œnico */
        RUN goToKey   IN h-bofr007 (INPUT mab-eqpto.ep-codigo,
                                    INPUT mab-eqpto.cod-eqpto).
    
        /** Busca TT da BO **/
        run getRecord in h-bofr007 (output table tt-mab-eqpto).
        IF  RETURN-VALUE = "OK":U THEN DO:
            FIND FIRST tt-mab-eqpto EXCLUSIVE-LOCK.
            IF  AVAIL tt-mab-eqpto THEN DO:
                ASSIGN tt-mab-eqpto.cod-sit-eqpto             = c-cod-situacao
                       tt-mab-eqpto.dat-situacao              = tt_trans_bem.ttv_dat_trans
                       OVERLAY(tt-mab-eqpto.cod-livre-1,19,6) = c-hra-situacao.
            END.

            /*--- Transfere temp-table tt-mab-eqpto para o DBO ---*/
            RUN setRecord IN h-bofr007 (INPUT TABLE tt-mab-eqpto).
            /*--- Altera registro corrente do DBO ---*/
            RUN updateRecord IN h-bofr007.
        END.
        /*--- Verifica ocorr¼ncia de erros durante a transa»’o ---*/
        IF  RETURN-VALUE = "NOK":U THEN DO:
            /*--- Retorna temp-table tt_row_errors do DBO ---*/
            RUN getRowErrors IN h-bofr007 (OUTPUT TABLE tt_row_errors). 
            RETURN "NOK":U.
        END.
        ELSE DO:
            /** Retorna os erros de Integra‡Æo EAI **/
            IF v_log_eai_habilit THEN DO:
                /*--- Retorna temp-table tt_row_errors do DBO ---*/
                RUN getRowErrors IN h-bofr007 (OUTPUT TABLE tt_row_errors). 
                FOR EACH tt_row_errors EXCLUSIVE-LOCK:
                    IF tt_row_errors.ttv_des_sub_type <> "Error":U THEN
                        DELETE tt_row_errors.
                    IF tt_row_errors.ttv_des_type = "INTERNAL":U THEN
                        DELETE tt_row_errors.
                END.
            END.
        END.
    END.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-finaliza-handle-eqpto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-finaliza-handle-eqpto Procedure 
PROCEDURE pi-finaliza-handle-eqpto :
/*------------------------------------------------------------------------------
  Purpose: Elimina handles da memoria    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/** Tabela Equipamento **/
/** Elimina Handle se tudo executou corretamente **/
IF valid-handle(h-bofr007) then                                                       
   run destroy in h-bofr007. 

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-finaliza-handle-situacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-finaliza-handle-situacao Procedure 
PROCEDURE pi-finaliza-handle-situacao :
/*------------------------------------------------------------------------------
  Purpose: Elimina handles da memoria    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/** Tabela Situacao do Equipamento **/
/** Elimina Handle se tudo executou corretamente **/
IF valid-handle(h-bofr024) then                                                       
   run destroy in h-bofr024.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-inicializa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa Procedure 
PROCEDURE pi-inicializa :
/*------------------------------------------------------------------------------
  Purpose:     inicializa a api, conforme o bem passado por parametro.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST mab-eqpto WHERE mab-eqpto.ep-codigo                   = tt_trans_bem.ttv_num_empresa 
                       AND substring(mab-eqpto.cod-livre-1,1,18) = tt_trans_bem.ttv_cod_cta_pat
                       AND mab-eqpto.bm-codigo                   = tt_trans_bem.ttv_num_bem_pat
                       AND mab-eqpto.bm-indice                   = tt_trans_bem.ttv_num_seq_bem_pat NO-LOCK NO-ERROR.
IF  AVAIL mab-eqpto THEN
    /*encontrou equipamento para o bem e ¡ndice informado.*/
    RUN pi-atualiza-eqpto IN THIS-PROCEDURE.

RUN pi-finaliza-handle-eqpto IN THIS-PROCEDURE.
RUN pi-finaliza-handle-situacao IN THIS-PROCEDURE.

IF  RETURN-VALUE = "NOK":U THEN
    RETURN "NOK":U.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-inicializa-handle-eqpto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-handle-eqpto Procedure 
PROCEDURE pi-inicializa-handle-eqpto :
/*------------------------------------------------------------------------------
  Purpose: Inicializa‡Æo das BOs     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*--- BO Tabela Equipamentos ---*/
IF NOT VALID-HANDLE(h-bofr007) OR
   h-bofr007:TYPE <> "PROCEDURE":U OR
   h-bofr007:FILE-NAME <> "frbo/bofr007.p":U THEN DO:
   run frbo/bofr007.p persistent set h-bofr007.
END.
/** Executa o adapter axsmf009.p para ems5**/
RUN setIntegracaoEMS5 IN h-bofr007 (INPUT YES).

RUN emptyRowErrors IN h-bofr007.

RUN openQueryStatic IN h-bofr007 (INPUT "Main":U) NO-ERROR.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-inicializa-handle-situacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-handle-situacao Procedure 
PROCEDURE pi-inicializa-handle-situacao :
/*------------------------------------------------------------------------------
  Purpose: Inicializa‡Æo das BOs     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*--- BO Tabela MAB-SIT-EQPTO ---*/
IF NOT VALID-HANDLE(h-bofr024) OR
   h-bofr024:TYPE <> "PROCEDURE":U OR
   h-bofr024:FILE-NAME <> "frbo/bofr024.p":U THEN DO:
   run frbo/bofr024.p persistent set h-bofr024.
END.

/*--- Limpa temp-table RowErrors no DBO ---*/
EMPTY TEMP-TABLE tt-mab-sit-eqpto.
RUN emptyRowErrors IN h-bofr024.

RUN setConstraintDescricao IN h-bofr024 (INPUT tt_trans_bem.ttv_situacao,
                                         INPUT tt_trans_bem.ttv_situacao).
RUN openQueryStatic IN h-bofr024 (INPUT "Descricao":U) NO-ERROR.
IF  RETURN-VALUE = "OK":U THEN DO:
    /** Busca TT da BO **/
    RUN getRecord IN h-bofr024 (OUTPUT TABLE tt-mab-sit-eqpto).
END.

/*--- Verifica ocorr¼ncia de erros durante a transa»’o ---*/
IF  RETURN-VALUE = "NOK":U THEN DO:
    RETURN "NOK":U.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

