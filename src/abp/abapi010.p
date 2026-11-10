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
{include/i-prgvrs.i ABAPI010 2.00.00.024 } /*** 010024 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i abapi010 MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: ABAPI010.p
**
**       DATA....: Março de 2005
**
**       AUTOR...: Sandro Kellermann de Carvalho - its0121.
**
**       OBJETIVO: Transferência do Bem pelo Patrimônio
**
*****************************************************************************/


/* ***************************  Definitions  ************************** */
{cdp/cdcfgmnt.i}

/*HANDLES*/
DEFINE VARIABLE hDBOEqpto AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDBOCompon AS HANDLE     NO-UNDO.

/*TEMP-TABLES*/
{abp/abapi010.i}
{frbo/bofr066.i tt-mco-movto-compon} 
{frbo/bofr013.i tt-mab-histor-ativid}

/*PARAMETROS*/
DEF INPUT PARAM TABLE FOR tt_trans_bem.
define output parameter table for tt_row_errors.

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
         HEIGHT             = 15
         WIDTH              = 60.
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

&IF DEFINED(EXCLUDE-pi-atualiza-compon) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-compon Procedure 
PROCEDURE pi-atualiza-compon :
/*------------------------------------------------------------------------------
  Purpose:     atualiza o estabelecimento do componente
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN pi-inicializa-handle-compon IN THIS-PROCEDURE. /*inicializacao handles BO compon = mco-movto-compon*/

IF AVAIL mco-compon AND mco-compon.cod-estabel-atual <> tt_trans_bem.ttv_cod_estab THEN DO:
    /*Caso o estabelecimento passado na transferencia seja diferente do atual do componente, entao continua:*/

    /*cria novo movimento para o componente, transferindo o componente de estabelecimento*/
    EMPTY TEMP-TABLE tt-mco-movto-compon.
    CREATE tt-mco-movto-compon.

    /* busca o £ltimo n£mero sequencial de documento e incrementa 1 */
    RUN buscaDocumento IN hDBOCompon (OUTPUT tt-mco-movto-compon.num-docto).

    /** Atualiza o campo hora invertida. Ser  gravado no 
        formato "AAAAMMDDHHMM" (Ano+Mˆs+Dia+Hora+Minuto) **/
    run converteParaHoraInvertida IN hDBOCompon (input  string(tt_trans_bem.ttv_dat_trans,"99/99/9999":U),
                                                 input  trim(substr(tt_trans_bem.ttv_hra_trans,1,2) + 
                                                             substr(tt_trans_bem.ttv_hra_trans,4,2) + 
                                                             substr(tt_trans_bem.ttv_hra_trans,7,2)),
                                                 output tt-mco-movto-compon.val-dat-hora-invrtda).

    /*busca e grava o c¢digo do evento padrão de transferˆncia*/
    FOR FIRST mab-param WHERE mab-param.cdn-param = 41 NO-LOCK:
    END.
    IF AVAIL mab-param THEN
        ASSIGN tt-mco-movto-compon.cod-evento = mab-param.des-valor.
    
    ASSIGN tt-mco-movto-compon.num-seqcial              = mco-compon.num-seqcial  
           tt-mco-movto-compon.hra-movto                = trim(replace(tt_trans_bem.ttv_hra_trans,":",""))
           tt-mco-movto-compon.dat-movto                = tt_trans_bem.ttv_dat_trans
           tt-mco-movto-compon.idi-tip-movto            = 3                        /*tipo 3 = transferˆncia*/
           tt-mco-movto-compon.ep-codigo                = mco-compon.ep-codigo-atual 
           tt-mco-movto-compon.cod-sub-sist             = mco-compon.cod-sub-sist 
           tt-mco-movto-compon.cod-sit-eqpto            = mco-compon.cod-sit-compon-atual
           tt-mco-movto-compon.cod-localiz-compon       = mco-compon.cod-localiz-compon 
           tt-mco-movto-compon.cod-estabel              = tt_trans_bem.ttv_cod_estab /*atualizando codigo estabel*/
           tt-mco-movto-compon.cod-eqpto                = mco-compon.cod-eqpto-atual 
           tt-mco-movto-compon.cod-compon               = mco-compon.cod-compon
           tt-mco-movto-compon.cc-codigo                = tt_trans_bem.ttv_cod_ccusto.  /*atualizando ccusto*/

    /*--- Transfere temp-table tt-mab-eqpto para o DBO ---*/
    RUN setRecord IN hDBOCompon (INPUT TABLE tt-mco-movto-compon).

    /*** Cria o registro ***/
    RUN createRecord IN hDBOCompon.

    /*--- Verifica ocorrˆncia de erros durante a transa»’o ---*/
    IF return-value = "NOK":U THEN DO:
        /*--- Retorna temp-table tt_row_errors do DBO ---*/
        RUN getRowErrors IN hDBOCompon (OUTPUT TABLE RowErrors). 
        RUN pi-finaliza-handle-compon IN THIS-PROCEDURE.

        FOR EACH RowErrors:
            CREATE  tt_row_errors.
            ASSIGN  tt_row_errors.ttv_num_seq_erro  = RowErrors.ErrorSequence
                    tt_row_errors.ttv_num_erro      = RowErrors.ErrorNumber
                    tt_row_errors.ttv_des_erro      = RowErrors.ErrorDescription
                    tt_row_errors.ttv_des_param     = RowErrors.ErrorParameters
                    tt_row_errors.ttv_des_type      = RowErrors.ErrorType
                    tt_row_errors.ttv_des_help      = RowErrors.ErrorHelp
                    tt_row_errors.ttv_des_sub_type  = RowErrors.ErrorSubType.
        END.

        RETURN "NOK":U.
    end.

END.

RUN pi-finaliza-handle-compon IN THIS-PROCEDURE.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-atualiza-eqpto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-eqpto Procedure 
PROCEDURE pi-atualiza-eqpto :
/*------------------------------------------------------------------------------
  Purpose:     atualiza estabelecimento do eqpto
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN pi-inicializa-handle-eqpto IN THIS-PROCEDURE. /*inicializacao handles BO eqpto = mab-histor-ativid*/

IF AVAIL mab-eqpto THEN DO:
    FOR LAST mab-histor-ativid WHERE mab-histor-ativid.ep-codigo = mab-eqpto.ep-codigo AND
                                     mab-histor-ativid.cod-eqpto = mab-eqpto.cod-eqpto NO-LOCK:
    END.
    IF AVAIL mab-histor-ativid AND mab-histor-ativid.cod-estabel <> tt_trans_bem.ttv_cod_estab THEN DO:
        /*cria novo hist¢rico do equipamento, transferindo o equipamento de estabelecimento*/
        EMPTY TEMP-TABLE tt-mab-histor-ativid.
        CREATE tt-mab-histor-ativid.
        ASSIGN tt-mab-histor-ativid.ep-codigo              =     mab-histor-ativid.ep-codigo 
               tt-mab-histor-ativid.dat-cadastro           =     tt_trans_bem.ttv_dat_trans /*data do movimento do patrim“nio*/
               tt-mab-histor-ativid.ct-codigo              =     mab-histor-ativid.ct-codigo 
           &IF DEFINED(bf_mnt_ems206b) &THEN              
               tt-mab-histor-ativid.cod-unid-negoc         =     tt_trans_bem.tta_cod_unid_negoc
           &ELSE                                          
               tt-mab-histor-ativid.cod_unid_negoc         =     tt_trans_bem.tta_cod_unid_negoc
           &ENDIF                                         
               tt-mab-histor-ativid.cod-pais               =     mab-histor-ativid.cod-pais 
               tt-mab-histor-ativid.cod-grp-eqpto          =     mab-histor-ativid.cod-grp-eqpto 
               tt-mab-histor-ativid.cod-estado             =     mab-histor-ativid.cod-estado 
               tt-mab-histor-ativid.cod-estabel            =     tt_trans_bem.ttv_cod_estab /*codigo do novo estabelecimento*/
               tt-mab-histor-ativid.cod-eqpto              =     mab-histor-ativid.cod-eqpto 
               tt-mab-histor-ativid.cod-cidade             =     mab-histor-ativid.cod-cidade 
               tt-mab-histor-ativid.cod-ccusto-alter       =     mab-histor-ativid.cod-ccusto-alter 
               tt-mab-histor-ativid.cod-ativid             =     mab-histor-ativid.cod-ativid 
               tt-mab-histor-ativid.cd-tag                 =     mab-histor-ativid.cd-tag 
               tt-mab-histor-ativid.cc-codigo              =     tt_trans_bem.ttv_cod_ccusto. /*centro de custo do novo estabelecimento*/

        FOR FIRST mab-param
            WHERE mab-param.cdn-param = 55 no-lock:
            IF  mab-param.des-valor = "1":U then do:
                ASSIGN tt-mab-histor-ativid.cod-cta-ctbl-lubrific  =     mab-histor-ativid.cod-cta-ctbl-lubrific
                       tt-mab-histor-ativid.cod-ccusto-lubrific    =     mab-histor-ativid.cod-ccusto-lubrific.
            END.
        END.


        RUN goToKey IN hDBOEqpto (INPUT tt-mab-histor-ativid.ep-codigo,
                                  INPUT tt-mab-histor-ativid.cod-eqpto,
                                  INPUT tt-mab-histor-ativid.dat-cadastro).

        IF RETURN-VALUE = "OK":U THEN DO:
            /*--- Transfere temp-table tt-mab-eqpto para o DBO ---*/
            RUN setRecord IN hDBOEqpto (INPUT TABLE tt-mab-histor-ativid).
            /*** Atualiza o registro ***/
            RUN updateRecord IN hDBOEqpto. 
        END.
        ELSE DO:
            /*--- Transfere temp-table tt-mab-eqpto para o DBO ---*/
            RUN setRecord IN hDBOEqpto (INPUT TABLE tt-mab-histor-ativid).
            /*** Cria o registro ***/
            RUN createRecord IN hDBOEqpto.
        END.

        /*--- Verifica ocorr¼ncia de erros durante a transa»’o ---*/
        IF return-value = "NOK":U THEN DO:
            /*--- Retorna temp-table tt_row_errors do DBO ---*/
            RUN getRowErrors IN hDBOEqpto (OUTPUT TABLE RowErrors). 
            RUN pi-finaliza-handle-eqpto IN THIS-PROCEDURE.

            FOR EACH RowErrors:
                CREATE  tt_row_errors.
                ASSIGN  tt_row_errors.ttv_num_seq_erro  = RowErrors.ErrorSequence
                        tt_row_errors.ttv_num_erro      = RowErrors.ErrorNumber
                        tt_row_errors.ttv_des_erro      = RowErrors.ErrorDescription
                        tt_row_errors.ttv_des_param     = RowErrors.ErrorParameters
                        tt_row_errors.ttv_des_type      = RowErrors.ErrorType
                        tt_row_errors.ttv_des_help      = RowErrors.ErrorHelp
                        tt_row_errors.ttv_des_sub_type  = RowErrors.ErrorSubType.
            END.

            RETURN "NOK":U.
        end.
    END.
END.

RUN pi-finaliza-handle-eqpto IN THIS-PROCEDURE.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-finaliza-handle-compon) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-finaliza-handle-compon Procedure 
PROCEDURE pi-finaliza-handle-compon :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/** Movto Compon **/
if valid-handle(hDBOCompon) then
    run destroy in hDBOCompon.

return "OK":U.

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

/** Historico Eqpto **/
if valid-handle(hDBOEqpto) then
    run destroy in hDBOEqpto.

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
&IF "{&mguni_version}" >= "2.071" &THEN
FIND FIRST mab-eqpto WHERE mab-eqpto.ep-codigo                   = tt_trans_bem.ttv_cod_empresa
&ELSE
FIND FIRST mab-eqpto WHERE mab-eqpto.ep-codigo                   = int(tt_trans_bem.ttv_cod_empresa)
&ENDIF
       AND substring(mab-eqpto.cod-livre-1,1,18) = tt_trans_bem.ttv_cod_cta_pat
       AND mab-eqpto.bm-codigo                   = tt_trans_bem.ttv_num_bem_pat
       AND mab-eqpto.bm-indice                   = tt_trans_bem.ttv_num_seq_bem_pat NO-LOCK NO-ERROR.
IF AVAIL mab-eqpto THEN
    /*encontrou equipamento para o bem e ¡ndice informado.*/
    RUN pi-atualiza-eqpto IN THIS-PROCEDURE.

ELSE DO: /*nao encontrou equipamento, então procurar componente*/

    &IF "{&mguni_version}" >= "2.071" &THEN
        FIND FIRST mco-compon WHERE mco-compon.ep-codigo                   = tt_trans_bem.ttv_cod_empresa
    &ELSE
        FIND FIRST mco-compon WHERE mco-compon.num-livre-1                 = int(tt_trans_bem.ttv_cod_empresa)
    &ENDIF
        AND SUBSTRING(mco-compon.cod-livre-1,1,18) = tt_trans_bem.ttv_cod_cta_pat
                        AND mco-compon.bm-codigo   = tt_trans_bem.ttv_num_bem_pat    
                        AND mco-compon.bm-indice   = tt_trans_bem.ttv_num_seq_bem_pat NO-LOCK NO-ERROR.
    IF AVAIL mco-compon THEN
        /*encontrou componente para o bem e ¡ndice informado*/
        RUN pi-atualiza-compon IN THIS-PROCEDURE.

END. /*else do*/

IF RETURN-VALUE = "NOK":U THEN
    RETURN "NOK":U.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-inicializa-handle-compon) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-handle-compon Procedure 
PROCEDURE pi-inicializa-handle-compon :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*--- BO Movto Componentes ---*/
IF NOT VALID-HANDLE(hDBOCompon) OR
   hDBOCompon:TYPE <> "PROCEDURE":U OR
   hDBOCompon:FILE-NAME <> "frbo/bofr066.p":U THEN DO:
    RUN frbo/bofr066.p PERSISTENT SET hDBOCompon.
END.

RUN openQueryStatic IN hDBOCompon (INPUT "Main":U) NO-ERROR.
RUN emptyRowErrors IN hDBOCompon.

RUN setaPrograma IN hDBOCompon (INPUT "abapi010.p":U).

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-inicializa-handle-eqpto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-handle-eqpto Procedure 
PROCEDURE pi-inicializa-handle-eqpto :
/*------------------------------------------------------------------------------
  Purpose: Inicialização das BOs     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*--- BO Hist¢rico do Eqpto ---*/
IF NOT VALID-HANDLE(hDBOEqpto) OR
   hDBOEqpto:TYPE <> "PROCEDURE":U OR
   hDBOEqpto:FILE-NAME <> "frbo/bofr013.p":U THEN DO:
    RUN frbo/bofr013.p PERSISTENT SET hDBOEqpto.
END.

RUN openQueryStatic IN hDBOEqpto (INPUT "Main":U) NO-ERROR.
RUN emptyRowErrors IN hDBOEqpto.

RUN setaPrograma IN hDBOEqpto (INPUT "abapi010.p":U).

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

