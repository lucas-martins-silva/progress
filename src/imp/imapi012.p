/* *****************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IMAPI012 2.00.00.002 } /*** "010002" 21/03/2025 09:24:36 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i imapi012 mim}
&ENDIF

/*------------------------------------------------------------------------
    Programa    : IMAPI012    
    Data        : 05/05/2017         
    Objetivo    : API para Gera‡Æo de Titulos no Contas a Pagar
                  Antecipa‡Æo para APB
------------------------------------------------------------------------*/

{include/i_fncrowid.i}

/******************* DEFINICAO TEMP-TABLE'S **********************************/
{imp/imapi012.i}  /* Temp-tables API APB EMS5 */
{imp/imapi012.i1} /* Defini‡äes de temp-tables */
{imp/imapi012.i2 NEW SHARED}  /*ttErrosIntegracao*/
{imp/imapi012.i3} /* Temp-tables API ACR EMS5 */
              
/******************* DEFINICAO PARAMETROS ***********************************/
DEF INPUT-OUTPUT  PARAM TABLE FOR ttTitulos.
DEF INPUT-OUTPUT  PARAM TABLE FOR ttImptoTitulos.
DEF OUTPUT        PARAM TABLE FOR ttErrosIntegracao.

/******************* DEFINICAO VARIAVEIS ************************************/
DEF NEW GLOBAL SHARED VAR c-seg-usuario   AS CHAR      NO-UNDO FORMAT 'x(12)'.
DEFINE VARIABLE h-apb905zd                AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-acr933zb                AS HANDLE    NO-UNDO.
DEFINE VARIABLE lErro                     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE dDatVctoINSS              AS DATE      NO-UNDO.
DEFINE VARIABLE cUnidFeder                AS CHARACTER NO-UNDO.
DEFINE VARIABLE cClassImpto               AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPais                     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMatriz                   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-seq-titulo-aux          AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-desSigla                AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-codMoedaExt             AS CHARACTER NO-UNDO.
DEFINE VARIABLE deAliquot                 AS DEC       NO-UNDO.

FIND FIRST param-imp NO-LOCK NO-ERROR.

RUN prgfin/acr/acr933zb.py   PERSISTENT SET h-acr933zb.

FOR EACH  ttTitulos
    WHERE ttTitulos.logGerado   = NO
      AND ttTitulos.codModulo   = "APB":U
      AND ttTitulos.codTipoReg <> "AVA":U :

    FIND FIRST espec-ap NO-LOCK
         WHERE espec-ap.cod-esp = ttTitulos.codEspecie NO-ERROR.
    IF  espec-ap.tipo <> 2 THEN
        NEXT.

    ASSIGN ttTitulos.logGerado = YES.

    EMPTY TEMP-TABLE tt_integr_apb_antecip_pef_p1   NO-ERROR.
    EMPTY TEMP-TABLE tt_integr_apb_aprop_ctbl_pend  NO-ERROR.
    EMPTY TEMP-TABLE tt_integr_apb_impto_impl_pend  NO-ERROR.
    EMPTY TEMP-TABLE tt_integr_apb_abat_prev_provis NO-ERROR.
    EMPTY TEMP-TABLE tt_log_erros_atualiz           NO-ERROR.
    EMPTY TEMP-TABLE tt_1099                        NO-ERROR.
    EMPTY TEMP-TABLE tt_ord_compra_tit_ap_pend_1    NO-ERROR.
    EMPTY TEMP-TABLE tt_params_generic_api          NO-ERROR.


    CREATE tt_integr_apb_antecip_pef_p1.
    ASSIGN ttTitulos.nroDocto = TRIM(ttTitulos.nroDocto)
           tt_integr_apb_antecip_pef_p1.ttv_cod_empresa_ext       = ttTitulos.codEmpresa
           tt_integr_apb_antecip_pef_p1.tta_cod_estab_ext         = ttTitulos.codEstabel
           tt_integr_apb_antecip_pef_p1.tta_cod_refer             = ttTitulos.codRefer
           tt_integr_apb_antecip_pef_p1.tta_cod_espec_docto       = ttTitulos.codEspecie
           tt_integr_apb_antecip_pef_p1.tta_cod_ser_docto         = ttTitulos.codSerie
           tt_integr_apb_antecip_pef_p1.tta_cdn_fornecedor        = ttTitulos.cdnFornecedor
           tt_integr_apb_antecip_pef_p1.tta_cod_tit_ap            = IF TRIM(ttTitulos.codDoctoWarrant) <> '' THEN 'W' + ttTitulos.nroDocto ELSE ttTitulos.nroDocto
           tt_integr_apb_antecip_pef_p1.tta_cod_parcela           = ttTitulos.Parcela
           tt_integr_apb_antecip_pef_p1.tta_cod_cart_bcia         = 'APB'
           tt_integr_apb_antecip_pef_p1.tta_cod_indic_econ        = STRING(ttTitulos.numMoeda)
           tt_integr_apb_antecip_pef_p1.tta_val_cotac_indic_econ  = IF ttTitulos.numMoeda <> 0 THEN (1 / ttTitulos.valCotacao) ELSE 1
           tt_integr_apb_antecip_pef_p1.tta_dat_emis_docto        = ttTitulos.datEmissao
           tt_integr_apb_antecip_pef_p1.tta_dat_vencto_tit_ap     = ttTitulos.datVencto
           tt_integr_apb_antecip_pef_p1.tta_ind_tip_refer         = 'Antecipa‡Æo'
           tt_integr_apb_antecip_pef_p1.tta_ind_natur_cta_ctbl    = 'DB'
           tt_integr_apb_antecip_pef_p1.tta_cod_usuar_gerac_movto = c-seg-usuario
           tt_integr_apb_antecip_pef_p1.ttv_rec_antecip_pef_pend  = &IF {&ROWID_READY} = YES &THEN 
                                                                        ROWID(tt_integr_apb_antecip_pef_p1)
                                                                    &ELSE 
                                                                        RECID(tt_integr_apb_antecip_pef_p1)
                                                                    &ENDIF 
           
           tt_integr_apb_antecip_pef_p1.tta_cod_usuar_gerac_movto = c-seg-usuario
           tt_integr_apb_antecip_pef_p1.tta_des_text_histor       = ttTitulos.desHistorico
           tt_integr_apb_antecip_pef_p1.tta_cod_portad_ext        = ttTitulos.codPortador
           tt_integr_apb_antecip_pef_p1.tta_cod_modalid_ext       = ttTitulos.codModalidade
           tt_integr_apb_antecip_pef_p1.tta_ind_origin_tit_ap     = "IMP".

    IF  tt_integr_apb_antecip_pef_p1.tta_dat_vencto_tit_ap < tt_integr_apb_antecip_pef_p1.tta_dat_emis_docto THEN
        ASSIGN tt_integr_apb_antecip_pef_p1.tta_dat_emis_docto = tt_integr_apb_antecip_pef_p1.tta_dat_vencto_tit_ap.

    /* *** CRIA TABELA DE APROPRIA€ÇO CONTABIL *** */
    CREATE tt_integr_apb_aprop_ctbl_pend.
    ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend     = tt_integr_apb_antecip_pef_p1.ttv_rec_antecip_pef_pend
           tt_integr_apb_aprop_ctbl_pend.ttv_cod_tip_fluxo_financ_ext = STRING(ttTitulos.cdnTpDespRec)
           tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc           = ttTitulos.codUnidNegoc
           tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl       = ttTitulos.codPlanoCta
           tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl             = ttTitulos.codCtaCtbl
           tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto         = ttTitulos.codPlanoCCusto
           tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto               = ttTitulos.codCentroCusto
           tt_integr_apb_antecip_pef_p1.tta_val_tit_ap                = ttTitulos.valTitulo
           tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc           = ttTitulos.codUnidNegoc 
           tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl           = ttTitulos.valTitulo.

    IF  ttTitulos.cdnTpPagto = 2 /* Cheque */ THEN DO:
        ASSIGN tt_integr_apb_antecip_pef_p1.tta_num_talon_cheq   = ttTitulos.numTalonario
               tt_integr_apb_antecip_pef_p1.tta_num_cheque       = ttTitulos.numCheque
               tt_integr_apb_antecip_pef_p1.tta_nom_favorec_cheq = ttTitulos.nomFavorecido
               tt_integr_apb_antecip_pef_p1.tta_ind_favorec_cheq = IF ttTitulos.cdnFavorecido > 0 AND ttTitulos.cdnFavorecido < 4 THEN ENTRY(ttTitulos.cdnFavorecido,"Portador;Fornecedor;Outros",";") ELSE "".
    END.

    RUN calculateDtVenctoINSS(INPUT  ttTitulos.codEmpresa,
                              INPUT  ttTitulos.codEstabel,
                              INPUT  ttTitulos.datEmissao,
                              OUTPUT lErro,
                              OUTPUT dDatVctoINSS).  

    /* *** IMPOSTOS DO TITULO *** */
    FOR EACH  ttImptoTitulos
        WHERE ttImptoTitulos.numSeqTitulo = ttTitulos.numSeqTitulo:

        RUN pi_ggp_retornar_imposto IN h-acr933zb(INPUT  ttTitulos.codEstabel,
                                                  INPUT  ttImptoTitulos.cdnImposto,
                                                  OUTPUT cUnidFeder,
                                                  OUTPUT cClassImpto,
                                                  OUTPUT cPais).
        IF  cClassImpto = "" THEN NEXT.

        CREATE tt_integr_apb_impto_impl_pend.
        assign tt_integr_apb_impto_impl_pend.ttv_rec_antecip_pef_pend       = tt_integr_apb_antecip_pef_p1.ttv_rec_antecip_pef_pend
               tt_integr_apb_impto_impl_pend.tta_cod_pais                   = cPais
               tt_integr_apb_impto_impl_pend.tta_cod_unid_federac           = cUnidFeder
               tt_integr_apb_impto_impl_pend.tta_cod_imposto                = STRING(ttImptoTitulos.cdnImposto)
               tt_integr_apb_impto_impl_pend.tta_cod_classif_impto          = cClassImpto
               tt_integr_apb_impto_impl_pend.tta_cod_ser_docto              = ttTitulos.codSerie
               tt_integr_apb_impto_impl_pend.tta_cod_tit_ap                 = ttTitulos.nroDocto
               tt_integr_apb_impto_impl_pend.tta_cod_parcela                = ttTitulos.Parcela
               tt_integr_apb_impto_impl_pend.tta_ind_clas_impto             = 'Retido'
               tt_integr_apb_impto_impl_pend.tta_cod_plano_cta_ctbl         = ttImptoTitulos.codPlanoCta
               tt_integr_apb_impto_impl_pend.tta_cod_cta_ctbl               = ttImptoTitulos.codCtaCtbl
               tt_integr_apb_impto_impl_pend.tta_val_rendto_tribut          = ttImptoTitulos.valBaseImposto
               tt_integr_apb_impto_impl_pend.tta_val_deduc_inss             = 0
               tt_integr_apb_impto_impl_pend.tta_val_deduc_depend           = 0
               tt_integr_apb_impto_impl_pend.tta_val_deduc_pensao           = 0
               tt_integr_apb_impto_impl_pend.tta_val_outras_deduc_impto     = 0
               tt_integr_apb_impto_impl_pend.tta_val_base_liq_impto         = ttImptoTitulos.valBaseImposto
               tt_integr_apb_impto_impl_pend.tta_val_impto_ja_recolhid      = 0
               tt_integr_apb_impto_impl_pend.tta_val_deduc_faixa_impto      = 0
               tt_integr_apb_impto_impl_pend.tta_cod_indic_econ             = STRING(ttTitulos.numMoeda)
               tt_integr_apb_impto_impl_pend.tta_val_impto_indic_econ_impto = 0
               tt_integr_apb_impto_impl_pend.tta_des_text_histor            = ''
               tt_integr_apb_impto_impl_pend.tta_val_aliq_impto             = ttImptoTitulos.valAliqImposto
               tt_integr_apb_impto_impl_pend.tta_val_imposto                = ttImptoTitulos.valImposto
               tt_integr_apb_impto_impl_pend.tta_dat_vencto_tit_ap          = dDatVctoINSS.
    END.
    
    RUN prgfin/apb/apb905zd.py PERSISTENT SET h-apb905zd.
    RUN pi_main_block_antecip_pef_pend_4 IN h-apb905zd (INPUT 3,
                                                        INPUT cMatriz,
                                                        INPUT-OUTPUT TABLE tt_integr_apb_antecip_pef_p1,
                                                        INPUT        TABLE tt_integr_apb_aprop_ctbl_pend,
                                                        INPUT        TABLE tt_integr_apb_impto_impl_pend,
                                                        INPUT        TABLE tt_integr_apb_abat_prev_provis,
                                                        OUTPUT       TABLE tt_log_erros_atualiz,
                                                        INPUT        TABLE tt_1099,
                                                        INPUT        TABLE tt_ord_compra_tit_ap_pend_1,
                                                        INPUT-OUTPUT TABLE tt_params_generic_api).
    DELETE PROCEDURE h-apb905zd.

    /*** Verificacao e gravacao de erros ***/
    IF  CAN-FIND(FIRST tt_log_erros_atualiz) THEN DO:
        RUN piCriarErroGeral (INPUT "":U).
    END.
    ELSE DO:
        /* *** Caso API nÆo tenha criado a antecipa‡Æo por algum motivo ou erro no financeiro *** */
        /* *** ou o processo foi abortado sem que os erros tenham sido criados *** */

        EMPTY TEMP-TABLE tt_consult_antecip_pef_pend NO-ERROR.
        CREATE tt_consult_antecip_pef_pend.
        ASSIGN tt_consult_antecip_pef_pend.ttv_num_tip_leitura = 1
               tt_consult_antecip_pef_pend.tta_cod_estab       = ttTitulos.codEstabel
               tt_consult_antecip_pef_pend.tta_cod_refer       = ttTitulos.codRefer.

        RUN pi_consult_antecip_pef_pend IN h-acr933zb(INPUT  TABLE tt_consult_antecip_pef_pend,
                                                      OUTPUT TABLE tt_retorno_antecip_pef_pend,
                                                      OUTPUT TABLE tt_log_erro).
        FIND FIRST tt_retorno_antecip_pef_pend NO-LOCK NO-ERROR.

        EMPTY TEMP-TABLE tt_consult_tit_ap NO-ERROR.
        CREATE tt_consult_tit_ap.
        ASSIGN tt_consult_tit_ap.ttv_num_tip_leitura = 4
               tt_consult_tit_ap.tta_cod_estab       = ttTitulos.codEstabel
               tt_consult_tit_ap.tta_cod_refer       = ttTitulos.codRefer.

        RUN pi_consult_tit_ap IN h-acr933zb(INPUT  TABLE tt_consult_tit_ap,
                                            OUTPUT TABLE tt_retorno_tit_ap,
                                            OUTPUT TABLE tt_retorno_val_tit_ap,
                                            OUTPUT TABLE tt_retorno_movto_tit_ap,
                                            OUTPUT TABLE tt_retorno_val_movto_tit_ap,
                                            OUTPUT TABLE tt_log_erro).
         
        FIND FIRST tt_retorno_tit_ap NO-LOCK NO-ERROR.

        IF  NOT AVAIL tt_retorno_antecip_pef_pend 
        AND NOT AVAIL tt_retorno_tit_ap
        AND ttTitulos.codPortador <> "":U THEN DO:   

            IF ttTitulos.numIdAdiant <> 0 THEN DO:
                
                RUN piCriarErroIndiv(INPUT 'Adiant ' + STRING(ttTitulos.numIdAdiant),
                                     INPUT 17006, 
                                     INPUT 'NÆo foi poss¡vel criar Antecipa‡Æo Pendente '
                                         + STRING(ttTitulos.codEstabel)    + '/'
                                         + ttTitulos.codRefer              + '/'
                                         + ttTitulos.codEspecie            + '/'
                                         + ttTitulos.codSerie              + '/'
                                         + STRING(ttTitulos.cdnFornecedor) + '/'
                                         + (IF TRIM(ttTitulos.codDoctoWarrant) <> '' THEN 'W' + ttTitulos.nroDocto ELSE ttTitulos.nroDocto) + '/'
                                         + STRING(ttTitulos.codPortador)   + '/'
                                         + ttTitulos.codModalidade         + '/'
                                         + ttTitulos.codCtaCtbl            + '/'
                                         + ttTitulos.codCentroCusto).

            END.
            ELSE DO:
                RUN piCriarErroIndiv(INPUT "":U,
                                     INPUT 17006, 
                                     INPUT 'NÆo foi poss¡vel criar Antecipa‡Æo Pendente '
                                         + STRING(ttTitulos.codEstabel)    + '/':U
                                         + ttTitulos.codRefer              + '/':U
                                         + ttTitulos.codEspecie            + '/':U
                                         + ttTitulos.codSerie              + '/':U
                                         + STRING(ttTitulos.cdnFornecedor) + '/':U
                                         + (IF TRIM(ttTitulos.codDoctoWarrant) <> '':U THEN 'W':U + ttTitulos.nroDocto ELSE ttTitulos.nroDocto) + '/':U
                                         + STRING(ttTitulos.codPortador)   + '/':U
                                         + ttTitulos.codModalidade         + '/':U
                                         + ttTitulos.codCtaCtbl            + '/':U
                                         + ttTitulos.codCentroCusto).
            END.

        END.
        ELSE DO:
        
            EMPTY TEMP-TABLE tt_consult_tit_ap NO-ERROR.
            CREATE tt_consult_tit_ap.
            ASSIGN tt_consult_tit_ap.ttv_num_tip_leitura = 4
                   tt_consult_tit_ap.tta_cod_estab       = ttTitulos.codEstabel
                   tt_consult_tit_ap.tta_cod_refer       = ttTitulos.codRefer.

            RUN pi_consult_tit_ap IN h-acr933zb(INPUT  TABLE tt_consult_tit_ap,
                                                OUTPUT TABLE tt_retorno_tit_ap,
                                                OUTPUT TABLE tt_retorno_val_tit_ap,
                                                OUTPUT TABLE tt_retorno_movto_tit_ap,
                                                OUTPUT TABLE tt_retorno_val_movto_tit_ap,
                                                OUTPUT TABLE tt_log_erro).
            FOR EACH tt_retorno_tit_ap NO-LOCK:

                /* Retornar o num Id do titulo principal gerado, pois podeÿ existir outros titulo (Explo. Imposto )*/
                IF  ttTitulos.codEspecie =  tt_retorno_tit_ap.cod_espec_docto THEN
                    ASSIGN ttTitulos.numIdTitGerado = tt_retorno_tit_ap.num_id_tit_ap.
               
            END.            
        END.
    END.
END.

IF VALID-HANDLE(h-acr933zb) THEN
    DELETE PROCEDURE h-acr933zb.


/* ********************************************************************************* */
PROCEDURE calculateDtVenctoINSS :
    DEF INPUT  PARAM  p-ep-codigo     LIKE dupli-apagar.ep-codigo    NO-UNDO.
    DEF INPUT  PARAM  p-cod-estabel   LIKE dupli-apagar.cod-estabel  NO-UNDO.
    DEF INPUT  PARAM  p-dt-emiss      LIKE dupli-apagar.dt-emiss     NO-UNDO.
    DEF OUTPUT PARAM  p-l-erro          AS LOG                       NO-UNDO.
    DEF OUTPUT PARAM  piDtINSS          AS DATE                      NO-UNDO.

    DEF VAR da-aux             AS date  NO-UNDO.

    ASSIGN da-aux = p-dt-emiss.

    ASSIGN da-aux = IF  MONTH(da-aux) < 12                               
                        THEN DATE(MONTH(da-aux) + 1,20, YEAR(da-aux))    
                        ELSE DATE(1, 20, YEAR(da-aux) + 1).              
                                                                                                                                                                                 
    ASSIGN piDtINSS = da-aux.

    FIND FIRST calen-coml NO-LOCK
         WHERE calen-coml.ep-codigo   = p-ep-codigo
           AND calen-coml.cod-estabel = p-cod-estabel
           AND calen-coml.data        = da-aux NO-ERROR.
    IF  AVAIL calen-coml THEN DO:
        IF  calen-coml.tipo-dia <> 1 THEN DO:
            ASSIGN piDtINSS = da-aux + 1.

            REPEAT:
                FIND NEXT calen-coml NO-LOCK
                    WHERE calen-coml.ep-codigo   = p-ep-codigo
                      AND calen-coml.cod-estabel = p-cod-estabel
                      AND calen-coml.data        = piDtINSS NO-ERROR.
                IF  AVAIL calen-coml THEN DO:
                    IF  calen-coml.tipo-dia = 1 THEN DO:
                        ASSIGN da-aux = piDtINSS.
                        LEAVE.
                    END.
                    ASSIGN piDtINSS = piDtINSS - 1.
                END.
                ELSE
                    LEAVE.
            END.
        END.
    END.
    ELSE
        ASSIGN p-l-erro = YES.

    RETURN "OK":U.
END PROCEDURE.
