
/******************************************************************************
**
**  Programa : af0045eh.i 
**  Objetivo.: Defini?’o Temp-Tables - Atualiza Temp-Tables para Mostrar HTML
**
******************************************************************************/

DEFINE TEMP-TABLE tt_antecip_pef_pend NO-UNDO /* Tipo Docto 25 e 26 */
   FIELD cod_empresa            AS CHARACTER  FORMAT "x(3)"                 INITIAL ""
   FIELD cod_estab              AS CHARACTER  FORMAT "x(3)"                 INITIAL ""
   FIELD cod_refer              AS CHARACTER  FORMAT "x(10)"                INITIAL ""
   FIELD cod_espec_docto        AS CHARACTER  FORMAT "x(3)"                 INITIAL ""
   FIELD cod_ser_docto          AS CHARACTER  FORMAT "x(3)"                 INITIAL ""
   FIELD cdn_fornecedor         AS INTEGER    FORMAT ">>>,>>>,>>9"          INITIAL 0
   FIELD cod_tit_ap             AS CHARACTER  FORMAT "x(16)"                INITIAL ""
   FIELD cod_parcela            AS CHARACTER  FORMAT "x(02)"                INITIAL ""
   FIELD cod_portador           AS CHARACTER  FORMAT "x(5)"                 INITIAL ""
   FIELD cod_indic_econ         AS CHARACTER  FORMAT "x(8)"                 INITIAL ""
   FIELD cod_finalid_econ       AS CHARACTER  FORMAT "x(10)"                INITIAL ""
   FIELD num_talon_cheq         AS INTEGER    FORMAT ">>>,>>>,>>9"          INITIAL 0
   FIELD num_cheque             AS INTEGER    FORMAT ">>>>,>>>,>>9"         INITIAL 0
   FIELD ind_favorec_cheq       AS CHARACTER  FORMAT "X(15)"                INITIAL ""
   FIELD nom_favorec_cheq       AS CHARACTER  FORMAT "x(40)"                INITIAL ""
   FIELD val_tit_ap             AS DECIMAL    FORMAT "->>>,>>>,>>9.99"      INITIAL "0"
   FIELD val_cotac_indic_econ   AS DECIMAL    FORMAT ">>>>,>>9.9999999999"  INITIAL "0"
   FIELD dat_emis_docto         AS DATE       FORMAT "99/99/9999"           INITIAL TODAY
   FIELD dat_vencto_tit_ap      AS DATE       FORMAT "99/99/9999"           INITIAL TODAY
   FIELD ind_tip_refer          AS CHARACTER  FORMAT "X(22)"                INITIAL ""
   FIELD cod_seguradora         AS CHARACTER  FORMAT "x(8)"                 INITIAL ""
   FIELD cod_apol_seguro        AS CHARACTER  FORMAT "x(12)"                INITIAL ""
   FIELD cod_arrendador         AS CHARACTER  FORMAT "x(6)"                 INITIAL ""
   FIELD cod_contrat_leas       AS CHARACTER  FORMAT "x(12)"                INITIAL ""
   FIELD cod_histor_padr        AS CHARACTER  FORMAT "x(8)"                 INITIAL ""
   FIELD des_text_histor        AS CHARACTER  FORMAT "x(2000)"              INITIAL ""
   FIELD ind_natur_cta_ctbl     AS CHARACTER  FORMAT "X(08)"                INITIAL ""
   FIELD ind_sit_pef_antecip    AS CHARACTER  FORMAT "X(15)"                INITIAL ""
   FIELD num_pessoa             AS INTEGER    FORMAT ">>>,>>>,>>9"          INITIAL 0
   FIELD cod_usuar_gerac_movto  AS CHARACTER  FORMAT "x(12)"                INITIAL ""
   FIELD dat_prev_pagto         AS DATE       FORMAT "99/99/9999"           INITIAL ?
   FIELD dat_desconto           AS DATE       FORMAT "99/99/9999"           INITIAL ?
   FIELD cod_cart_bcia          AS CHARACTER  FORMAT "x(3)"                 INITIAL ""
   FIELD cod_forma_pagto        AS CHARACTER  FORMAT "x(3)"                 INITIAL ""
   FIELD cod_estab_portad_mutuo AS CHARACTER  FORMAT "x(3)"                 INITIAL ""
   FIELD cod_portad_mutuo       AS CHARACTER  FORMAT "x(5)"                 INITIAL ""
   FIELD log_incid_despes_bcia  as logical    FORMAT "Sim/NÆo"              INITIAL "no"
   FIELD cod_livre_1            AS CHARACTER  FORMAT "x(100)"               INITIAL ""
   FIELD dsl_obs_tit_ap         AS CHARACTER  FORMAT "x(2000)"              INITIAL ""
   FIELD ind_origin_tit_ap      AS CHARACTER  FORMAT "X(03)"                INITIAL "APB"
   FIELD cod_usuar_pagto        AS CHARACTER  FORMAT "x(12)"                INITIAL ""
   FIELD dat_transacao          AS DATE       FORMAT "99/99/9999"           INITIAL TODAY
    /* Descricoes Chave Estrangeira */
   FIELD des_cod_estab          AS CHARACTER FORMAT "x(40)"                 INITIAL ""
   FIELD des_cdn_fornecedor     AS CHARACTER FORMAT "x(15)"                 INITIAL ""
   FIELD cod_pais               AS CHARACTER FORMAT "x(03)"                 INITIAL ""
   FIELD des_cod_pais           AS CHARACTER FORMAT "x(32)"                 INITIAL ""
   FIELD des_cod_forma_pagto    AS CHARACTER FORMAT "x(40)"                 INITIAL ""
   FIELD ind_modo_pagto         AS CHARACTER FORMAT "x(10)"                 INITIAL ""
   FIELD val_cotac_indic_invers AS DECIMAL   FORMAT ">>>>,>>9.9999999999"   INITIAL "0"
   FIELD des_historico          AS CHARACTER FORMAT "x(2000)"               INITIAL "".

DEFINE TEMP-TABLE tt_item_lote_impl_ap NO-UNDO /* Tipo Docto 24 */
   FIELD cod_empresa                AS CHARACTER  FORMAT "x(3)"             INITIAL ""
   FIELD cod_estab                  AS CHARACTER  FORMAT "x(3)"             INITIAL ""
   FIELD cod_refer                  AS CHARACTER  FORMAT "x(10)"            INITIAL ""
   FIELD num_seq_refer              AS INTEGER    FORMAT ">>>9"             INITIAL 0
   FIELD cdn_fornecedor             AS INTEGER    FORMAT ">>>,>>>,>>9"      INITIAL 0
   FIELD cod_espec_docto            AS CHARACTER  FORMAT "x(3)"             INITIAL ""
   FIELD cod_ser_docto              AS CHARACTER  FORMAT "x(3)"             INITIAL ""
   FIELD cod_tit_ap                 AS CHARACTER  FORMAT "x(16)"            INITIAL ""
   FIELD cod_parcela                AS CHARACTER  FORMAT "x(02)"            INITIAL ""
   FIELD cod_forma_pagto            AS CHARACTER  FORMAT "x(3)"             INITIAL ""
   FIELD dat_emis_docto             AS DATE       FORMAT "99/99/9999"       INITIAL TODAY
   FIELD dat_vencto_tit_ap          AS DATE       FORMAT "99/99/9999"       INITIAL TODAY
   FIELD dat_prev_pagto             AS DATE       FORMAT "99/99/9999"       INITIAL TODAY
   FIELD dat_desconto               AS DATE       FORMAT "99/99/9999"       INITIAL ?
   FIELD cod_indic_econ             AS CHARACTER  FORMAT "x(8)"             INITIAL ""
   FIELD val_tit_ap                 AS DECIMAL    FORMAT "->>>,>>>,>>9.99"  INITIAL "0"
   FIELD val_desconto               AS DECIMAL    FORMAT "->>>,>>>,>>9.99"  INITIAL "0"
   FIELD val_perc_desc              AS DECIMAL    FORMAT ">9.9999"          INITIAL "0"
   FIELD num_dias_atraso            AS INTEGER    FORMAT ">9"               INITIAL 0
   FIELD val_juros_dia_atraso       AS DECIMAL    FORMAT "->>>,>>>,>>9.99"  INITIAL "0"
   FIELD val_perc_juros_dia_atraso  AS DECIMAL    FORMAT ">9.999999"        INITIAL "00.00"
   FIELD val_perc_multa_atraso      AS DECIMAL    FORMAT ">9.99"            INITIAL "00.00"
   FIELD cod_portador               AS CHARACTER  FORMAT "x(5)"             INITIAL ""
   FIELD cod_apol_seguro            AS CHARACTER  FORMAT "x(12)"            INITIAL ""
   FIELD cod_seguradora             AS CHARACTER  FORMAT "x(8)"             INITIAL ""
   FIELD cod_arrendador             AS CHARACTER  FORMAT "x(6)"             INITIAL ""
   FIELD cod_contrat_leas           AS CHARACTER  FORMAT "x(12)"            INITIAL ""
   FIELD cod_histor_padr            AS CHARACTER  FORMAT "x(8)"             INITIAL ""
   FIELD des_text_histor            AS CHARACTER  FORMAT "x(2000)"          INITIAL ""
   FIELD num_pessoa                 AS INTEGER    FORMAT ">>>,>>>,>>9"      INITIAL 0
   FIELD cod_pagto_padr             AS CHARACTER  FORMAT "x(5)"             INITIAL ""
   FIELD cod_pagto_provis_repet     AS CHARACTER  FORMAT "x(3)"             INITIAL ""
   FIELD cb4_tit_ap_bco_cobdor      AS CHARACTER  FORMAT "x(50)"            INITIAL ""
   FIELD cod_livre_1                AS CHARACTER  FORMAT "x(100)"           INITIAL ""
   FIELD dsl_obs_tit_ap             AS CHARACTER  FORMAT "x(2000)"          INITIAL ""
   FIELD ind_origin_tit_ap          AS CHARACTER  FORMAT "X(03)"            INITIAL "APB"
   FIELD cod_estab_tit_ap           AS CHARACTER  FORMAT "x(3)"             INITIAL ""
   FIELD dat_transacao              AS DATE       FORMAT "99/99/9999"       INITIAL TODAY
   /* Descricoes Chave Estrangeira */
   FIELD des_cod_estab              AS CHARACTER FORMAT "x(40)"             INITIAL ""
   FIELD des_cdn_fornecedor         AS CHARACTER FORMAT "x(15)"             INITIAL ""
   FIELD cod_pais                   AS CHARACTER FORMAT "x(03)"             INITIAL ""
   FIELD des_cod_pais               AS CHARACTER FORMAT "x(32)"             INITIAL ""
   FIELD des_cod_forma_pagto        AS CHARACTER FORMAT "x(40)"             INITIAL ""
   FIELD des_historico              AS CHARACTER FORMAT "x(2000)"            INITIAL ""
   FIELD des_razao_social           AS CHARACTER FORMAT "x(60)"             INITIAL "".

DEFINE TEMP-TABLE tt_aprop_ctbl_pend_ap NO-UNDO /* Apropriacao Contabil Tipo Docto 24,25 e 26 */
   FIELD cod_empresa              AS CHARACTER  FORMAT "x(3)"             INITIAL ""
   FIELD cod_estab                AS CHARACTER  FORMAT "x(3)"             INITIAL ""
   FIELD cod_refer                AS CHARACTER  FORMAT "x(10)"            INITIAL ""
   FIELD cod_plano_cta_ctbl       AS CHARACTER  FORMAT "x(8)"             INITIAL ""
   FIELD cod_cta_ctbl             AS CHARACTER  FORMAT "x(20)"            INITIAL ""
   FIELD cod_unid_negoc           AS CHARACTER  FORMAT "x(3)"             INITIAL ""
   FIELD cod_plano_ccusto         AS CHARACTER  FORMAT "x(8)"             INITIAL ""
   FIELD cod_ccusto               AS CHARACTER  FORMAT "x(11)"            INITIAL ""
   FIELD cod_tip_fluxo_financ     AS CHARACTER  FORMAT "x(12)"            INITIAL ""
   FIELD cod_pais                 AS CHARACTER  FORMAT "x(3)"             INITIAL ""
   FIELD cod_classif_impto        AS CHARACTER  FORMAT "x(05)"            INITIAL "000"
   FIELD cod_unid_federac         AS CHARACTER  FORMAT "x(3)"             INITIAL ""
   FIELD cod_imposto              AS CHARACTER  FORMAT "x(5)"             INITIAL ""
   FIELD num_seq_refer            AS INTEGER    FORMAT ">>>9"             INITIAL 0
   FIELD val_aprop_ctbl           AS DECIMAL    FORMAT "->>>,>>>,>>9.99"  INITIAL "0"
   FIELD log_impto_val_agreg      as logical    FORMAT "Sim/NÆo"          INITIAL "no"
   FIELD log_mutuo_pagto          as logical    FORMAT "Sim/NÆo"          INITIAL "no"
   FIELD cod_livre_1              AS CHARACTER  FORMAT "x(100)"           INITIAL ""
   FIELD cod_estab_aprop_ctbl     AS CHARACTER  FORMAT "x(3)"             INITIAL ""
   /* Descricoes Chave Estrangeira */
   FIELD des_cod_tip_fluxo_financ AS CHARACTER FORMAT "x(40)"             INITIAL ""
   FIELD des_cod_plano_cta_ctbl   AS CHARACTER FORMAT "x(40)"             INITIAL ""
   FIELD des_cod_cta_ctbl         AS CHARACTER FORMAT "x(40)"             INITIAL ""
   FIELD des_cod_plano_ccusto     AS CHARACTER FORMAT "x(40)"             INITIAL ""
   FIELD des_cod_ccusto           AS CHARACTER FORMAT "x(40)"             INITIAL ""
   FIELD des_cod_unid_negoc       AS CHARACTER FORMAT "x(40)"             INITIAL "".

/**************************** Documento 28 - Pagamento ************************************/

DEF TEMP-TABLE tt_tit_ap NO-UNDO
    FIELD cdn_fornecedor            AS INTEGER    FORMAT ">>>,>>>,>>9"      INITIAL 0
    FIELD cod_empresa               AS CHARACTER  FORMAT "x(3)"                 INITIAL ""
    FIELD cod_espec_docto           AS CHARACTER  FORMAT "x(3)"                 INITIAL ""
    FIELD cod_estab                 AS CHARACTER  FORMAT "x(3)"             INITIAL ""
    FIELD cod_forma_pagto           AS CHARACTER  FORMAT "x(3)"             INITIAL ""
    FIELD cod_indic_econ            AS CHARACTER  FORMAT "x(8)"                 INITIAL ""
    FIELD cod_parcela               AS CHARACTER  FORMAT "x(02)"            INITIAL ""
    FIELD cod_portador              AS CHARACTER  FORMAT "x(5)"             INITIAL ""
    FIELD cod_refer                 AS CHARACTER  FORMAT "x(10)"            INITIAL ""
    FIELD cod_ser_docto             AS CHARACTER  FORMAT "x(3)"             INITIAL ""
    FIELD cod_tit_ap                AS CHARACTER  FORMAT "x(16)"            INITIAL ""
    FIELD cod_tit_ap_bco            AS CHAR
    FIELD dat_desconto              AS DATE       FORMAT "99/99/9999"       INITIAL ?
    FIELD dat_emis_docto            AS DATE       FORMAT "99/99/9999"           INITIAL TODAY
    FIELD dat_liquidac_tit_ap       AS DATE FORMAT "99/99/9999"
    FIELD dat_prev_pagto            AS DATE       FORMAT "99/99/9999"       INITIAL TODAY
    FIELD dat_transacao             AS DATE       FORMAT "99/99/9999"           INITIAL TODAY
    FIELD dat_ult_pagto             AS DATE FORMAT "99/99/9999"
    FIELD dat_vencto_tit_ap         AS DATE       FORMAT "99/99/9999"           INITIAL TODAY
    FIELD ind_origin_tit_ap         AS CHARACTER  FORMAT "X(03)"                INITIAL "APB"
    FIELD ind_sit_tit_ap            AS CHAR
    FIELD ind_tip_espec_docto       AS CHAR
    FIELD log_sdo_tit_ap            AS LOGICAL
    FIELD log_tit_ap_estordo        AS LOGICAL
    FIELD num_dias_atraso           AS INTEGER    FORMAT ">9"               INITIAL 0
    FIELD num_fatur_ap              AS INT
    FIELD num_id_movto_cta_corren   AS INT
    FIELD num_id_movto_tit_ap_ult   AS INT
    FIELD num_id_tit_ap             AS INT
    FIELD num_pessoa                AS INTEGER    FORMAT ">>>,>>>,>>9"      INITIAL 0
    FIELD num_seq_refer             AS INTEGER    FORMAT ">>>9"             INITIAL 0
    FIELD val_abat_tit_ap           AS DEC DECIMALS 2
    FIELD val_desconto              AS DECIMAL    FORMAT "->>>,>>>,>>9.99"  INITIAL "0"
    FIELD val_desc_tit_ap           AS DEC DECIMALS 2
    FIELD val_juros                 AS DEC DECIMALS 2
    FIELD val_juros_dia_atraso      AS DECIMAL    FORMAT "->>>,>>>,>>9.99"  INITIAL "0"
    FIELD val_multa_tit_ap          AS DEC DECIMALS 2
    FIELD val_origin_tit_ap         AS DEC DECIMALS 2
    FIELD val_pagto_tit_ap          AS DEC DECIMALS 2
    FIELD val_perc_desc             AS DECIMAL    FORMAT ">9.9999"          INITIAL "0"
    FIELD val_perc_juros_dia_atraso AS DECIMAL    FORMAT ">9.999999"        INITIAL "00.00"
    FIELD val_perc_multa_atraso     AS DECIMAL    FORMAT ">9.99"            INITIAL "00.00"
    FIELD val_sdo_tit_ap            AS DEC DECIMALS 2
    FIELD des_razao_social          AS CHARACTER FORMAT "x(60)"   INITIAL ""
    FIELD des_historico             AS CHARACTER FORMAT "x(2000)" INITIAL ""
    FIELD des_cod_estab             AS CHARACTER FORMAT "x(40)"   INITIAL ""
    FIELD des_cdn_fornecedor        AS CHARACTER FORMAT "x(15)"   INITIAL ""
    FIELD cod_pais                  AS CHARACTER FORMAT "x(03)"   INITIAL ""
    FIELD des_cod_pais              AS CHARACTER FORMAT "x(32)"   INITIAL ""
    FIELD des_cod_forma_pagto       AS CHARACTER FORMAT "x(40)"   INITIAL ""
    FIELD dat_base                  AS DATE FORMAT "99/99/9999"   INITIAL ?
    FIELD val_pagamento             AS DEC DECIMALS 2 FORMAT "->>>,>>>,>>9.99"  INITIAL "0"
    FIELD val_tot_pagamento         AS DEC DECIMALS 2 FORMAT "->>>,>>>,>>9.99"  INITIAL "0"
    FIELD val_abat_antecip          AS DEC DECIMALS 2 FORMAT "->>>,>>>,>>9.99"  INITIAL "0"
    FIELD cod_indic_econ_tit        AS CHARACTER  FORMAT "x(8)"                 INITIAL ""
    /* (Inclusão do campo des_histor_alter) IPP - Mostrar Motivo de Alteração na Aprovação Financeira
       Enviar um histórico na solicitação de aprovação de pagamento, ou seja, liberação do valor do AVMA */
    FIELD des_histor_alter          AS CHARACTER FORMAT "x(2000)".

DEF TEMP-TABLE tt_aprop_ctbl_ap NO-UNDO
    FIELD cod_ccusto                 AS CHARACTER  FORMAT "x(11)"            INITIAL ""
    FIELD cod_cta_ctbl               AS CHARACTER  FORMAT "x(20)"            INITIAL ""
    FIELD cod_empresa                AS CHARACTER  FORMAT "x(3)"             INITIAL ""
    FIELD cod_estab                  AS CHARACTER  FORMAT "x(3)"             INITIAL ""
    FIELD cod_estab_aprop_ctbl       AS CHARACTER  FORMAT "x(3)"             INITIAL ""
    FIELD cod_indic_econ             AS CHARACTER  FORMAT "x(8)"             INITIAL ""
    FIELD cod_livre_1                AS CHARACTER  FORMAT "x(100)"           INITIAL ""
    FIELD cod_plano_ccusto           AS CHARACTER  FORMAT "x(8)"             INITIAL ""
    FIELD cod_plano_cta_ctbl         AS CHARACTER FORMAT "x(40)"             INITIAL ""
    FIELD cod_unid_negoc             AS CHARACTER  FORMAT "x(3)"             INITIAL ""
    FIELD dat_transacao              AS DATE       FORMAT "99/99/9999"           INITIAL TODAY
    FIELD ind_gera_val_aprop_ctbl_ap AS CHAR 
    FIELD ind_natur_lancto_ctbl      AS CHAR
    FIELD ind_tip_aprop_ctbl         AS CHAR
    FIELD log_ctbz_aprop_ctbl        AS LOGICAL
    FIELD log_impto_val_agreg        as logical    FORMAT "Sim/NÆo"          INITIAL "no"
    FIELD num_id_aprop_ctbl_ap       AS INT
    FIELD num_id_movto_tit_ap        AS INT
    FIELD num_livro_fisc             AS INT
    FIELD num_pag_livro_fisc         AS INT
    FIELD val_aprop_ctbl             AS DECIMAL    FORMAT "->>>,>>>,>>9.99"  INITIAL "0"
    FIELD des_cod_tip_fluxo_financ   AS CHARACTER FORMAT "x(40)"             INITIAL ""
    FIELD des_cod_plano_cta_ctbl     AS CHARACTER FORMAT "x(40)"             INITIAL ""
    FIELD des_cod_cta_ctbl           AS CHARACTER FORMAT "x(40)"             INITIAL ""
    FIELD des_cod_plano_ccusto       AS CHARACTER FORMAT "x(40)"             INITIAL ""
    FIELD des_cod_ccusto             AS CHARACTER FORMAT "x(40)"             INITIAL ""
    FIELD des_cod_unid_negoc         AS CHARACTER FORMAT "x(40)"             INITIAL "".

/**************************** Documento 28 - Pagamento ************************************/
