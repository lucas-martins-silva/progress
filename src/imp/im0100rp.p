 /******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0100RP 2.00.00.054 } /*** "010054" 11/12/2025 08:58:33 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0100rp MIM}
&ENDIF
 
/*****************************************************************************
* Copyright DATASUL S.A. (1997)
* Todos os Direitos Reservados.
*
* Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
* parcial ou total por qualquer meio, so podera ser feita mediante
* autorizacao expressa.
*****************************************************************************/
{include/i_fnctrad.i}
/*****************************************************************************
*
*  IM0305RP.P - Integracao Importacao Compras
*
*  Objetivo: Emissao de Pedido de Compras
*
******************************************************************************/

{cdp/cdcfgmat.i}   /* pre-processadores */
{cdp/cdcfgdis.i}   /* pre-processadores */

/*{cxbo/bocx220a.i}*/  /* definicoes temp-table tt-parametros*/
{imp/im0100x.i tt-parametros}
{utp/ut-glob.i}    /* variaveis globais */
{imp/im0100.i}     /*tt-recebe e tt-param*/
{cxbo/bocx225e.i1} /* vari†veis atributo livre ordens-embarque */
{cxbo/bocx310.i tt-desp-embarque}
{include/i-epc200.i IM0100RP}

&if defined (bf_dis_versao_ems) &then
    &if "{&BF_DIS_VERSAO_EMS}" >= "2.04" &then
        DEF VAR i-numero-ordem    LIKE ordem-compra.numero-ordem NO-UNDO.
        DEF VAR i-parcela         LIKE ordens-embarque.parcela   NO-UNDO.

        DEF VAR i-mo-codigo             LIKE moeda.mo-codigo                NO-UNDO.
        DEF VAR c-desc-moeda            LIKE moeda.descricao                NO-UNDO.
        DEF VAR c-desc-emitente         LIKE emitente.nome-emit             NO-UNDO.
        DEF VAR de-cotacao-dia          AS DECIMAL FORMAT ">>>,>9.99999999" NO-UNDO.
        DEF VAR c-desc-natur            LIKE natur-oper.denominacao         NO-UNDO.
        DEF VAR c-desc-class-fisc       LIKE classif-fisc.descricao         NO-UNDO.
        DEF VAR i-seq-item              LIKE item-doc-est.sequencia         NO-UNDO.
        DEF VAR c-desc-item             LIKE ITEM.desc-item                 NO-UNDO.
        DEF VAR i-desp-ii               LIKE desp-imp.cod-desp              NO-UNDO.
        DEF VAR de-preco-total-me       LIKE item-doc-est.preco-total[1]    NO-UNDO.
        DEF VAR de-peso-bruto           AS DECIMAL FORMAT ">>>>>,>>9.99999" NO-UNDO.
        DEF VAR de-peso-liq-unit        AS DEC FORMAT ">>>>,>>9.9999999999" NO-UNDO.
        DEF VAR l-gravado               AS LOGICAL INITIAL NO               NO-UNDO.
        DEF VAR c-trib-ii               AS CHAR FORMAT "x(01)"              NO-UNDO.
        DEF VAR c-trib-icm              AS CHAR FORMAT "x(01)"              NO-UNDO.
        DEF VAR c-trib-ipi              AS CHAR FORMAT "x(01)"              NO-UNDO.
        DEF VAR c-trib-pis              AS CHAR FORMAT "x(01)"              NO-UNDO.
        DEF VAR c-trib-cofins           AS CHAR FORMAT "x(01)"              NO-UNDO.
        DEF VAR de-val-desp-ii          LIKE item-doc-est-cex.val-desp      NO-UNDO.
        DEF VAR de-aliq-pis             LIKE item-doc-est.aliquota-ipi      NO-UNDO.
        DEF VAR de-val-pis              LIKE item-doc-est.valor-ipi[1]      NO-UNDO.
        DEF VAR de-aliq-cofins          LIKE item-doc-est.aliquota-ipi      NO-UNDO.
        DEF VAR de-val-cofins           LIKE item-doc-est.valor-ipi[1]      NO-UNDO.
        DEF VAR de-quant-sub-tot        LIKE item-doc-est.qt-do-forn        NO-UNDO.
        DEF VAR de-quant-tot-geral      LIKE item-doc-est.qt-do-forn        NO-UNDO.
        DEF VAR de-preco-sub-tot-me     LIKE item-doc-est.preco-total[1]    NO-UNDO.
        DEF VAR de-preco-tot-geral-me   LIKE item-doc-est.preco-total[1]    NO-UNDO.
        DEF VAR de-preco-sub-tot-mn     LIKE item-doc-est.preco-total[1]    NO-UNDO.
        DEF VAR de-preco-tot-geral-mn   LIKE item-doc-est.preco-total[1]    NO-UNDO.
        DEF VAR de-peso-bruto-sub-tot   AS DECIMAL FORMAT ">>>>>,>>9.99999"      NO-UNDO.
        DEF VAR de-peso-bruto-tot-geral AS DECIMAL FORMAT ">>>>>,>>9.99999"      NO-UNDO.
        DEF VAR de-peso-liq-tot-sub     AS DECIMAL FORMAT ">>>>>,>>9.99999"      NO-UNDO.
        DEF VAR de-peso-liq-tot-geral   AS DECIMAL FORMAT ">>>>>,>>9.99999"      NO-UNDO.
                
        DEF VAR de-val-desp-ii-sub-tot   LIKE desp-embarque.val-desp    NO-UNDO.
        DEF VAR de-val-desp-ii-tot-geral LIKE desp-embarque.val-desp    NO-UNDO.
        DEF VAR de-val-ipi-sub-tot       LIKE item-doc-est.valor-ipi[1] NO-UNDO.
        DEF VAR de-val-ipi-tot-geral     LIKE item-doc-est.valor-ipi[1] NO-UNDO.
        DEF VAR de-val-icm-sub-tot       LIKE item-doc-est.valor-icm[1] NO-UNDO.
        DEF VAR de-val-icm-tot-geral     LIKE item-doc-est.valor-icm[1] NO-UNDO.
        DEF VAR de-val-pis-sub-tot       LIKE item-doc-est.valor-ipi[1] NO-UNDO.
        DEF VAR de-val-pis-tot-geral     LIKE item-doc-est.valor-ipi[1] NO-UNDO.
        DEF VAR de-val-cofins-sub-tot    LIKE item-doc-est.valor-ipi[1] NO-UNDO.
        DEF VAR de-val-cofins-tot-geral  LIKE item-doc-est.valor-ipi[1] NO-UNDO.
        DEF VAR de-preco-unit-sem-ipi    LIKE ordem-compra.preco-unit   NO-UNDO.
        def var de-preco-unit-mo         like cotacao-item.preco-unit   no-undo.
        
        DEF VAR i-cod-itiner         LIKE itinerario.cod-itiner NO-UNDO.
        DEF VAR i-seq-nacionalizacao LIKE historico-embarque.sequencia NO-UNDO.
        DEF VAR l-inc-ii             AS LOGICAL FORMAT "Sim/Nao" NO-UNDO.
        DEF VAR l-inc-ipi            AS LOGICAL FORMAT "Sim/Nao" NO-UNDO.
        DEF VAR l-inc-icms           AS LOGICAL FORMAT "Sim/Nao" NO-UNDO.
        DEF VAR l-val-duplic         AS LOGICAL FORMAT "Sim/Nao" NO-UNDO.
        DEF VAR l-pis-valor          AS LOGICAL FORMAT "Sim/Nao" NO-UNDO.
        DEF VAR l-pis-despesa        AS LOGICAL FORMAT "Sim/Nao" NO-UNDO.
        DEF VAR l-cofins-valor       AS LOGICAL FORMAT "Sim/Nao" NO-UNDO.
        DEF VAR l-cofins-despesa     AS LOGICAL FORMAT "Sim/Nao" NO-UNDO.
        
        DEF VAR c-tipo               AS CHAR FORMAT "x(20)" NO-UNDO.
        DEF VAR i-cod-desp-ii        AS INT INITIAL 23 NO-UNDO.
        DEF VAR i-num-adicao         AS INT  FORMAT ">>>9" NO-UNDO.
        DEF VAR de-taxa-siscomex     AS DEC  FORMAT ">>>>>,>>>,>>9.99999" NO-UNDO.
        DEF VAR de-sub-tx-siscomex   AS DEC  FORMAT ">>>>>,>>>,>>9.99999" NO-UNDO.
        DEF VAR de-tot-tx-siscomex   AS DEC  FORMAT ">>>>>,>>>,>>9.99999" NO-UNDO.
        DEF VAR de-val-tot-desp      LIKE desp-embarque.val-desp NO-UNDO.
        DEF VAR l-gera-prim-remessa  AS LOGICAL     NO-UNDO.

        DEF BUFFER b-ordens-embarque FOR ordens-embarque.
        
        DEF TEMP-TABLE tt-desp-nacion NO-UNDO
            FIELD cod-desp       LIKE desp-embarque.cod-desp
            FIELD cod-emit-desp  LIKE desp-embarque.cod-emitente-desp
            FIELD sequencia      LIKE historico-embarque.sequencia
            FIELD descricao      LIKE desp-imp.descricao
            FIELD cod-cond-pag   LIKE desp-embarque.cod-cond-pag
            FIELD mo-codigo      LIKE desp-embarque.mo-codigo
            FIELD val-desp-orig  LIKE item-doc-est-cex.val-desp
            FIELD de-cotacao     AS DECIMAL FORMAT ">>>,>9.99999999" 
            FIELD val-desp       LIKE item-doc-est-cex.val-desp 
            FIELD tipo           AS CHAR    FORMAT "x(20)" 
            FIELD inc-ii         AS LOGICAL FORMAT "Sim/Nao" 
            FIELD inc-ipi        AS LOGICAL FORMAT "Sim/Nao" 
            FIELD inc-icms       AS LOGICAL FORMAT "Sim/Nao" 
            FIELD val-duplic     AS LOGICAL FORMAT "Sim/Nao"
            FIELD pis-valor      AS LOGICAL FORMAT "Sim/Nao"
            FIELD pis-despesa    AS LOGICAL FORMAT "Sim/Nao"
            FIELD cofins-valor   AS LOGICAL FORMAT "Sim/Nao"
            FIELD cofins-despesa AS LOGICAL FORMAT "Sim/Nao".

        DEF TEMP-TABLE tt-docum-est NO-UNDO LIKE docum-est.
        DEF INPUT PARAM TABLE FOR tt-parametros.
        DEF INPUT PARAM TABLE FOR tt-param.
        DEF INPUT PARAM TABLE FOR tt-embarque-pai.
        DEF INPUT PARAM TABLE FOR tt-embarque-filho.
        
        {include/i-rpvar.i}

        {utp/ut-liter.i "RELAT‡RIO_DE_CONFER“NCIA_DO_EMBARQUE_IMPORTAÄ«O" *}

        assign c-programa     = "im0100"
               c-versao       = "2.00"
               c-revisao      = "000"
               c-titulo-relat = TRIM(RETURN-VALUE).
        {utp/ut-liter.i     "ComÇrcio_Exterior" *}
        ASSIGN c-sistema      = TRIM(RETURN-VALUE).

        DEFINE VARIABLE c-lbl-liter-embarque AS CHARACTER FORMAT "X(8)" NO-UNDO.
        {utp/ut-liter.i "EMBARQUE" *}
        ASSIGN c-lbl-liter-embarque = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-di AS CHARACTER FORMAT "X(3)" NO-UNDO.
        {utp/ut-liter.i "D.I" *}
        ASSIGN c-lbl-liter-di = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-moeda AS CHARACTER FORMAT "X(5)" NO-UNDO.
        {utp/ut-liter.i "MOEDA" *}
        ASSIGN c-lbl-liter-moeda = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-fornecedor AS CHARACTER FORMAT "X(10)" NO-UNDO.
        {utp/ut-liter.i "FORNECEDOR" *}
        ASSIGN c-lbl-liter-fornecedor = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-taxa-cambio AS CHARACTER FORMAT "X(11)" NO-UNDO.
        {utp/ut-liter.i "TAXA_C∂MBIO" *}
        ASSIGN c-lbl-liter-taxa-cambio = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-nat-operacao AS CHARACTER FORMAT "X(13)" NO-UNDO.
        {utp/ut-liter.i "NAT._OPERAÄ«O" *}
        ASSIGN c-lbl-liter-nat-operacao = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-incoterm AS CHARACTER FORMAT "X(8)" NO-UNDO.
        {utp/ut-liter.i "INCOTERM" *}
        ASSIGN c-lbl-liter-incoterm = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-seq AS CHARACTER FORMAT "X(3)" NO-UNDO.
        {utp/ut-liter.i "SEQ" *}
        ASSIGN c-lbl-liter-seq = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-item AS CHARACTER FORMAT "X(16)" NO-UNDO.
        {utp/ut-liter.i "ITEM" *}
        ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-descricao-2 AS CHARACTER FORMAT "X(11)" NO-UNDO.
        {utp/ut-liter.i "DESCRIÄ«O" *}
        ASSIGN c-lbl-liter-descricao-2 = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-qtde AS CHARACTER FORMAT "X(6)" NO-UNDO.
        {utp/ut-liter.i "QTDE" *}
        ASSIGN c-lbl-liter-qtde = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-valor-unit AS CHARACTER FORMAT "X(12)" NO-UNDO.
        {utp/ut-liter.i "VALOR_UNIT" *}
        ASSIGN c-lbl-liter-valor-unit = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-total-me AS CHARACTER FORMAT "X(10)" NO-UNDO.
        {utp/ut-liter.i "TOTAL_ME" *}
        ASSIGN c-lbl-liter-total-me = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-total-mn AS CHARACTER FORMAT "X(10)" NO-UNDO.
        {utp/ut-liter.i "TOTAL_MN" *}
        ASSIGN c-lbl-liter-total-mn = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-peso-bruto-tot AS CHARACTER FORMAT "X(16)" NO-UNDO.
        {utp/ut-liter.i "PESO_BRUTO_TOT" *}
        ASSIGN c-lbl-liter-peso-bruto-tot = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-peso-liq-unit AS CHARACTER FORMAT "X(15)" NO-UNDO.
        {utp/ut-liter.i "PESO_LIQ_UNIT" *}
        ASSIGN c-lbl-liter-peso-liq-unit = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-peso-liq-tot AS CHARACTER FORMAT "X(14)" NO-UNDO.
        {utp/ut-liter.i "PESO_LIQ_TOT" *}
        ASSIGN c-lbl-liter-peso-liq-tot = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-ii AS CHARACTER FORMAT "X(4)" NO-UNDO.
        {utp/ut-liter.i "II" *}
        ASSIGN c-lbl-liter-ii = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-valor-ii AS CHARACTER FORMAT "X(19)" NO-UNDO.
        {utp/ut-liter.i "VALOR_II" *}
        ASSIGN c-lbl-liter-valor-ii = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-ipi AS CHARACTER FORMAT "X(5)" NO-UNDO.
        {utp/ut-liter.i "IPI" *}
        ASSIGN c-lbl-liter-ipi = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-valor-ipi AS CHARACTER FORMAT "X(15)" NO-UNDO.
        {utp/ut-liter.i "VALOR_IPI" *}
        ASSIGN c-lbl-liter-valor-ipi = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-icms AS CHARACTER FORMAT "X(6)" NO-UNDO.
        {utp/ut-liter.i "ICMS" *}
        ASSIGN c-lbl-liter-icms = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-valor-icms AS CHARACTER FORMAT "X(14)" NO-UNDO.
        {utp/ut-liter.i "VALOR_ICMS" *}
        ASSIGN c-lbl-liter-valor-icms = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-pis AS CHARACTER FORMAT "X(5)" NO-UNDO.
        {utp/ut-liter.i "PIS" *}
        ASSIGN c-lbl-liter-pis = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-valor-pis AS CHARACTER FORMAT "X(14)" NO-UNDO.
        {utp/ut-liter.i "VALOR_PIS" *}
        ASSIGN c-lbl-liter-valor-pis = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-cofins AS CHARACTER FORMAT "X(8)" NO-UNDO.
        {utp/ut-liter.i "COFINS" *}
        ASSIGN c-lbl-liter-cofins = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-valor-cofins AS CHARACTER FORMAT "X(14)" NO-UNDO.
        {utp/ut-liter.i "VALOR_COFINS" *}
        ASSIGN c-lbl-liter-valor-cofins = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-processo-imp AS CHARACTER FORMAT "X(12)" NO-UNDO.
        {utp/ut-liter.i "PROCESSO_IMP" *}
        ASSIGN c-lbl-liter-processo-imp = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-pedido AS CHARACTER FORMAT "X(9)" NO-UNDO.
        {utp/ut-liter.i "PEDIDO" *}
        ASSIGN c-lbl-liter-pedido = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-ordem-compra AS CHARACTER FORMAT "X(12)" NO-UNDO.
        {utp/ut-liter.i "ORDEM_COMPRA" *}
        ASSIGN c-lbl-liter-ordem-compra = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-nr-adicao AS CHARACTER FORMAT "X(11)" NO-UNDO.
        {utp/ut-liter.i "NR_ADIÄ«O" *}
        ASSIGN c-lbl-liter-nr-adicao = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-taxa-siscomex AS CHARACTER FORMAT "X(15)" NO-UNDO.
        {utp/ut-liter.i "TAXA_SISCOMEX" *}
        ASSIGN c-lbl-liter-taxa-siscomex = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-class-fiscal AS CHARACTER FORMAT "X(12)" NO-UNDO.
        {utp/ut-liter.i "Class_Fiscal" *}
        ASSIGN c-lbl-liter-class-fiscal = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-descricao AS CHARACTER FORMAT "X(11)" NO-UNDO.
        {utp/ut-liter.i "Descriá∆o" *}
        ASSIGN c-lbl-liter-descricao = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-total-quant AS CHARACTER FORMAT "X(11)" NO-UNDO.
        {utp/ut-liter.i "TOTAL_QUANT" *}
        ASSIGN c-lbl-liter-total-quant = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-sub-total AS CHARACTER FORMAT "X(12)" NO-UNDO.
        {utp/ut-liter.i "SUB_TOTAL" *}
        ASSIGN c-lbl-liter-sub-total = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-total-do-embarque AS CHARACTER FORMAT "X(20)" NO-UNDO.
        {utp/ut-liter.i "TOTAL_DO_EMBARQUE" *}
        ASSIGN c-lbl-liter-total-do-embarque = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-despesasimpostos-ate-o-ponto-d AS CHARACTER FORMAT "X(49)" NO-UNDO.
        {utp/ut-liter.i "DESPESAS/IMPOSTOS_ATê_O_PONTO_DE_NACIONALIZAÄ«O" *}
        ASSIGN c-lbl-liter-despesasimpostos-ate-o-ponto-d = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-forn-desp-nome-abrev-despesa-d AS CHARACTER FORMAT "X(203)" NO-UNDO.
        {utp/ut-liter.i "Forn_Desp_Nome_Abrev___Despesa_Descriá∆o______________________Cond_Pgto_______Valor_Despesa_Mo_Desp__________Valor_Orig_____Taxa_CÉmbio_Dupl_II___IPI__ICMS_PIS_VL_ADU_PIS_DESP_COFINS_ADU_COFINS_DESP_TIPO" *}
        ASSIGN c-lbl-liter-forn-desp-nome-abrev-despesa-d = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-total-despesas AS CHARACTER FORMAT "X(17)" NO-UNDO.
        {utp/ut-liter.i "Total_Despesas" *}
        ASSIGN c-lbl-liter-total-despesas = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-despesasimpostos-apos-o-ponto AS CHARACTER FORMAT "X(50)" NO-UNDO.
        {utp/ut-liter.i "DESPESAS/IMPOSTOS_AP‡S_O_PONTO_DE_NACIONALIZAÄ«O" *}
        ASSIGN c-lbl-liter-despesasimpostos-apos-o-ponto = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-forn-desp-nome-abrev-despesa-d-2 AS CHARACTER FORMAT "X(203)" NO-UNDO.
        {utp/ut-liter.i "Forn_Desp_Nome_Abrev___Despesa_Descriá∆o______________________Cond_Pgto_______Valor_Despesa_Mo_Desp__________Valor_Orig_____Taxa_CÉmbio_Dupl_II___IPI__ICMS_PIS_VL_ADU_PIS_DESP_COFINS_ADU_COFINS_DESP_TIPO" *}
        ASSIGN c-lbl-liter-forn-desp-nome-abrev-despesa-d-2 = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-total-despesas-2 AS CHARACTER FORMAT "X(17)" NO-UNDO.
        {utp/ut-liter.i "Total_Despesas" *}
        ASSIGN c-lbl-liter-total-despesas-2 = TRIM(RETURN-VALUE).
        
        FIND FIRST tt-parametros NO-LOCK NO-ERROR.
        FIND FIRST tt-param      NO-LOCK NO-ERROR.        
        
        {include/i-rpcab.i}
        {cdp/cd-rpout.i}   /* include customizada Comex */
        
        view frame f-cabec.
        view frame f-rodape.
        
        FIND embarque-imp WHERE
         embarque-imp.cod-estabel = tt-parametros.cod-estabel AND
         embarque-imp.embarque    = tt-parametros.embarque NO-LOCK NO-ERROR.
    
        IF NOT AVAIL embarque-imp THEN 
            RETURN NO-APPLY.
        
        FOR FIRST ordens-embarque WHERE
                  ordens-embarque.cod-estabel = embarque-imp.cod-estabel AND
                  ordens-embarque.embarque    = embarque-imp.embarque NO-LOCK:
        END.
    
        IF NOT AVAIL ordens-embarque THEN
            RETURN NO-APPLY.
        
        FOR FIRST ordem-compra WHERE
                  ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK:
        END.
        
        ASSIGN i-mo-codigo = IF AVAIL ordem-compra THEN ordem-compra.mo-codigo 
                             ELSE 0.
        
        FOR FIRST moeda WHERE
                  moeda.mo-codigo = i-mo-codigo NO-LOCK:
        END.
        ASSIGN c-desc-moeda = IF AVAIL moeda THEN moeda.descricao 
                              ELSE "".
        
        FOR FIRST emitente WHERE
                  emitente.cod-emitente = tt-parametros.cod-emitente NO-LOCK:
        END.
        ASSIGN c-desc-emitente = IF AVAIL emitente THEN emitente.nome-emit
                                 ELSE "".
    
        
        FIND cotacao WHERE
             cotacao.mo-codigo   = i-mo-codigo AND
             cotacao.ano-periodo = STRING(YEAR(tt-parametros.da-cotacao)) + STRING(MONTH(tt-parametros.da-cotacao),"99") AND
             cotacao.cotacao[INT(DAY(tt-parametros.da-cotacao))] <> 0 NO-LOCK NO-ERROR.
        
        ASSIGN de-cotacao-dia = if AVAIL cotacao then cotacao.cotacao[int(day(tt-parametros.da-cotacao))] 
                                ELSE 1.
    
        /* chamada UPC */
        FOR EACH tt-epc  
            WHERE tt-epc.cod-event = "CalculoPrecoUnitario":U:
            DELETE tt-epc.
        END.
    
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "CalculoPrecoUnitario":U
               tt-epc.cod-parameter = "RowidOrdemCompra":U
               tt-epc.val-parameter = STRING(ROWID(ordem-compra)).
    
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "CalculoPrecoUnitario":U
               tt-epc.cod-parameter = "de-cotacao-dia":U
               tt-epc.val-parameter = STRING(de-cotacao-dia).
    
        {include/i-epc201.i "CalculoPrecoUnitario"} 
    
        FIND FIRST tt-epc
             WHERE tt-epc.cod-event     = "CalculoPrecoUnitario":U
               AND tt-epc.cod-parameter = "AlteraCotacao":U NO-ERROR.
    
        IF  AVAIL tt-epc THEN
            ASSIGN de-cotacao-dia    = DEC(tt-epc.val-parameter).
    
        FIND natur-oper WHERE
             natur-oper.nat-operacao = tt-parametros.nat-operacao NO-LOCK NO-ERROR.
        
        ASSIGN c-desc-natur = IF AVAIL natur-oper THEN natur-oper.denominacao
                              ELSE "".
               
        FIND param-imp WHERE
             param-imp.cod-estabel = tt-parametros.cod-estabel NO-LOCK NO-ERROR.
        
        IF NOT AVAIL param-imp THEN
            RETURN NO-APPLY.
        
        {cdp/cd4300.i3}
        {cxbo/bocx250.i50}
        {cdp/cd4300.i4 "yes" param-imp.char-1}
        {cxbo/bocx250.i51 "yes"}
        
        assign i-desp-ii = i-desp-ii-i50.
        
        
        PUT SKIP (2) 
            c-lbl-liter-embarque        FORMAT "x(8)"  + ": "  AT 01 embarque-imp.embarque   AT 12      
            c-lbl-liter-di              FORMAT "x(3)"  + ".: " AT 30 embarque-imp.declaracao-import AT 37
            c-lbl-liter-moeda           FORMAT "x(5)"  + ": "  AT 59 c-desc-moeda            
            c-lbl-liter-fornecedor      FORMAT "x(10)" + ": "  AT 01 c-desc-emitente             
            c-lbl-liter-taxa-cambio     FORMAT "x(11)" + ": "  AT 01 de-cotacao-dia              
            c-lbl-liter-nat-operacao    FORMAT "x(13)" + ": "  AT 01 tt-parametros.nat-operacao SPACE(3) c-desc-natur             
            c-lbl-liter-incoterm        FORMAT "x(8)"  + ": "  AT 01 embarque-imp.cod-incoterm.

        FOR EACH tt-docum-est:
            DELETE tt-docum-est.
        END.
        
        FIND docum-est WHERE
             docum-est.serie-docto  = tt-parametros.serie AND
             docum-est.nro-docto    = tt-parametros.nro-docto AND
             docum-est.cod-emitente = tt-parametros.cod-emitente AND
             docum-est.nat-operacao = tt-parametros.nat-operacao NO-LOCK NO-ERROR.
        IF NOT AVAIL docum-est THEN DO:
              RETURN NO-APPLY.
        END.
        
        CREATE tt-docum-est.
        BUFFER-COPY docum-est TO tt-docum-est.
    
        IF  c-nom-prog-dpc-mg97  <> "" OR 
            c-nom-prog-appc-mg97 <> "" OR
            c-nom-prog-upc-mg97  <> "" THEN DO:
    
            for each tt-epc where tt-epc.cod-event = "altera-tt-docum-est":
                delete tt-epc.
            end.
            
            create tt-epc.
            assign tt-epc.cod-event     = "altera-tt-docum-est"
                   tt-epc.cod-parameter = "handle-tt-docum-est"
                   tt-epc.val-parameter = string(TEMP-TABLE tt-docum-est:HANDLE).
            
            {include/i-epc201.i "altera-tt-docum-est"}
    
        END.
        FOR EACH tt-docum-est:
            ASSIGN i-seq-item = 1.
            
            FOR EACH item-doc-est WHERE
                     item-doc-est.serie-docto  = tt-docum-est.serie-docto AND
                     item-doc-est.nro-docto    = tt-docum-est.nro-docto   AND
                     item-doc-est.cod-emitente = tt-docum-est.cod-emitente AND
                     item-doc-est.nat-operacao = tt-docum-est.nat-operacao NO-LOCK
                     BREAK BY class-fisc
                           BY un:
            
                     FIND classif-fisc WHERE
                          classif-fisc.class-fisc = item-doc-est.class-fisc NO-LOCK NO-ERROR.
                     
                     ASSIGN c-desc-class-fisc = IF AVAIL classif-fisc THEN classif-fisc.descricao
                                                ELSE "".
                     ASSIGN i-seq-item = i-seq-item + 1.
                     IF FIRST-OF(item-doc-est.class-fisc) THEN DO:
                         PUT skip(2) 
                             c-lbl-liter-class-fiscal AT 01
                             c-lbl-liter-descricao    AT 14
                             "------------" AT 01
                             "-----------------------------------" AT 14
                             item-doc-est.class-fisc AT 01
                             c-desc-class-fisc       AT 14 SKIP(1).
                     END.
            
                 IF FIRST-OF(item-doc-est.un) THEN DO:
                     PUT c-lbl-liter-seq            AT 03
                         c-lbl-liter-item           AT 07
                         c-lbl-liter-descricao-2      AT 24
                         c-lbl-liter-qtde           AT 98
                         c-lbl-liter-valor-unit     AT 110
                         c-lbl-liter-total-me       AT 128
                         c-lbl-liter-total-mn       AT 144
                         c-lbl-liter-peso-bruto-tot AT 154
                         c-lbl-liter-peso-liq-unit  AT 176
                         c-lbl-liter-peso-liq-tot   TO 205
                         c-lbl-liter-ii             AT 206
                         "%"              AT 216
                         c-lbl-liter-valor-ii       TO 236
                         c-lbl-liter-ipi            AT 238
                         "%"              AT 248
                         c-lbl-liter-valor-ipi      TO 264
                         c-lbl-liter-icms           AT 266
                         "%"              AT 276
                         c-lbl-liter-valor-icms     TO 291
                         c-lbl-liter-pis            AT 293
                         "%"              AT 303
                         c-lbl-liter-valor-pis      TO 318
                         c-lbl-liter-cofins         AT 320
                         "%"              AT 332
                         c-lbl-liter-valor-cofins   TO 347
                         c-lbl-liter-processo-imp   AT 349
                         c-lbl-liter-pedido         TO 370
                         c-lbl-liter-ordem-compra   AT 372 
                         c-lbl-liter-nr-adicao      AT 385
                         c-lbl-liter-taxa-siscomex  AT 401 SKIP.
            
                     PUT "-----"                AT 01
                         "----------------"     AT 07
                         "------------------------------------------------------------" AT 24
                         "-----------------"    AT 85
                         "-----------------"    AT 103
                         "---------------"      AT 121
                         "---------------"      AT 137
                         "---------------"      AT 153
                         "--------------------" AT 169
                         "---------------"      AT 190
                         "----"                 AT 206
                         "------"               AT 211
                         "-------------------"  AT 218
                         "----"                 AT 238
                         "------"               AT 243
                         "---------------"      AT 250
                         "----"                 AT 266
                         "------"               AT 271
                         "--------------"       AT 278
                         "----"                 AT 293
                         "------"               AT 298
                         "--------------"       AT 305
                         "------"               AT 320
                         "------"               AT 327
                         "--------------"       AT 334
                         "------------"         AT 349
                         "---------"            AT 362 
                         "------------"         AT 372
                         "---------"            AT 385
                         "-------------------"  AT 395.
    
                         ASSIGN i-seq-item = 1.
                     END.
    
                     FOR FIRST ITEM WHERE
                               ITEM.it-codigo = item-doc-est.it-codigo NO-LOCK:
                     END.
                     ASSIGN c-desc-item = IF AVAIL ITEM THEN ITEM.desc-item 
                                          ELSE "".
    
                     IF  tt-parametros.l-nf-simples-remessa     AND
                         tt-parametros.idi-nf-simples-remes = 1 THEN DO:

                         ASSIGN l-gera-prim-remessa = YES.
    
                         IF TRIM(substring(item-doc-est.char-2,940,1)) <> "S":U THEN DO: /*Gera primeira remessa com NF M∆e*/
                             &IF "{&bf_mat_versao_ems}":U >= "2.06":U &THEN
                                 ASSIGN i-numero-ordem = item-doc-est.num-ord-import
                                        i-parcela      = item-doc-est.num-parc-import.
                             &ELSE
                                 ASSIGN i-numero-ordem = INTEGER(SUBSTRING(item-doc-est.char-2,145,8))
                                        i-parcela      = INTEGER(SUBSTRING(item-doc-est.char-2,154,5)).
                             &ENDIF
                        END.
                        ELSE
                            ASSIGN i-numero-ordem = item-doc-est.numero-ordem
                                   i-parcela      = item-doc-est.parcela.
                     END.
                     ELSE
                         ASSIGN i-numero-ordem = item-doc-est.numero-ordem
                                i-parcela      = item-doc-est.parcela.
    
                     FIND FIRST ordem-compra
                          WHERE ordem-compra.numero-ordem = i-numero-ordem NO-LOCK NO-ERROR.

                     FIND FIRST b-ordens-embarque
                          WHERE b-ordens-embarque.numero-ordem = i-numero-ordem
                            AND b-ordens-embarque.parcela      = i-parcela NO-LOCK NO-ERROR.
    
    /*                  ASSIGN de-preco-unit-sem-ipi = (ordem-compra.pre-unit-for * 100) / (100 + ordem-compra.aliquota-ipi) */
    /*                         de-preco-total-me     = de-preco-unit-sem-ipi     * item-doc-est.qt-do-forn                   */
    /*                         de-peso-bruto         = item.peso-bruto           * item-doc-est.qt-do-forn                   */
    /*                         de-peso-liq-unit      = item-doc-est.peso-liquido / item-doc-est.qt-do-forn                   */
    /*                         de-preco-unit-sem-ipi = 0.                                                                    */
                     /*Dranka*/
                     FOR FIRST cotacao-item WHERE
                               cotacao-item.numero-ordem = ordem-compra.numero-ordem AND
                               cotacao-item.cod-emitente = item-doc-est.cod-emitente AND
                               cotacao-item.it-codigo    = item-doc-est.it-codigo    AND
                               cotacao-item.cot-aprovada NO-LOCK:
                     END.
    
                     FIND FIRST tt-epc
                          WHERE tt-epc.cod-event     = "CalculoPrecoUnitario":U
                            AND tt-epc.cod-parameter = "AlteraCotacao":U NO-ERROR.
    
                     IF  AVAIL tt-epc THEN
                        ASSIGN de-preco-total-me = item-doc-est.preco-total[1] / de-cotacao-dia.
                     ELSE DO:
                         IF AVAIL cotacao-item THEN DO:
                             assign de-preco-unit-mo = cotacao-item.pre-unit-for.
                             ASSIGN de-preco-unit-mo = (de-preco-unit-mo * 100) / (100 + cotacao-item.aliquota-ipi).
                             assign de-preco-total-me  = de-preco-unit-mo * item-doc-est.qt-do-forn.
                         END.
                     END.
                     
                     ASSIGN /*de-preco-total-me     = de-preco-total-me     * item-doc-est.qt-do-forn*/
                            de-peso-bruto         = item.peso-bruto       * item-doc-est.quantidade
                            de-peso-liq-unit      = item-doc-est.peso-liquido / item-doc-est.quantidade
                            de-preco-unit-sem-ipi = 0.
                     /*Dranka*/

                     FIND FIRST ordens-embarque
                          WHERE ordens-embarque.cod-estabel  = embarque-imp.cod-estabel  AND
                                ordens-embarque.embarque     = embarque-imp.embarque     AND
                                ordens-embarque.numero-ordem = ordem-compra.numero-ordem AND
                                ordens-embarque.parcela      = i-parcela                 NO-LOCK NO-ERROR.

                     ASSIGN i-num-adicao = 0.
                     &if "{&bf_mat_versao_ems}" >= "2.07" &then
                         ASSIGN i-num-adicao = IF (l-gera-prim-remessa AND AVAIL b-ordens-embarque) THEN b-ordens-embarque.num-adic 
                                               ELSE IF AVAIL ordens-embarque THEN ordens-embarque.num-adic ELSE 0.
                     &else
                         ASSIGN i-num-adicao = IF (l-gera-prim-remessa AND AVAIL b-ordens-embarque) THEN INT(SUBSTR(b-ordens-embarque.char-1,60,4)) 
                                               ELSE IF AVAIL ordens-embarque THEN INT(SUBSTR(ordens-embarque.char-1,60,4)) ELSE 0.
                     &endif

                     IF  AVAIL ordens-embarque THEN DO:
                         {cxbo/bocx225e.i2 no ordens-embarque} /* busca valores atributos livres */
                         
                         ASSIGN de-taxa-siscomex = 0.
                         FOR FIRST item-doc-est-cex NO-LOCK
                             WHERE item-doc-est-cex.serie-docto  = item-doc-est.serie-docto
                               AND item-doc-est-cex.nro-docto    = item-doc-est.nro-docto
                               AND item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente
                               AND item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao
                               AND item-doc-est-cex.sequencia    = item-doc-est.sequencia
                              &if "{&bf_mat_versao_ems}" >= "2.07" &then
                               AND item-doc-est-cex.cod-desp     = param-imp.cdn-despes-siscomex:
                              &else
                               AND item-doc-est-cex.cod-desp     = INT(SUBSTR(param-imp.char-1, 91,5)):
                              &endif
                             ASSIGN de-taxa-siscomex = item-doc-est-cex.val-desp.
                         END.
                         
                         ASSIGN de-sub-tx-siscomex = de-sub-tx-siscomex + de-taxa-siscomex.
                     END.
                     ELSE
                         ASSIGN de-taxa-siscomex = 0.
    
                     IF  AVAIL ordens-embarque THEN DO:
                         {cxbo/bocx225e.i4 no ordens-embarque} /* busca valores atributos livres */
                         assign l-gravado = l-ja-gravado.

                         ASSIGN de-peso-bruto = de-peso-bruto-i1.
                     END.

                     IF  tt-parametros.l-gera-prim-nf-remes-mae THEN DO:
                         FOR EACH tt-embarque-filho:

                             FIND FIRST b-ordens-embarque NO-LOCK
                                  WHERE b-ordens-embarque.cod-estabel  = tt-embarque-filho.cod-estabel
                                  AND   b-ordens-embarque.embarque     = tt-embarque-filho.embarque
                                  AND   b-ordens-embarque.numero-ordem = ordem-compra.numero-ordem 
                                  AND   b-ordens-embarque.parcela      = i-parcela NO-ERROR.
                             IF  AVAIL b-ordens-embarque THEN DO:
                                 ASSIGN de-peso-bruto = b-ordens-embarque.peso-bruto.
                             END.
                         END.
                     END.

                     IF NOT l-gravado THEN DO:
                          FOR FIRST cotacao-item WHERE
                                    cotacao-item.numero-ordem = ordem-compra.numero-ordem AND
                                    cotacao-item.cod-emitente = item-doc-est.cod-emitente AND
                                    cotacao-item.it-codigo    = item-doc-est.it-codigo    AND
                                    cotacao-item.cot-aprovada NO-LOCK:
                          END.
                          IF AVAIL cotacao-item THEN DO:
                              {ccp/cc9019.i50} /* include tratamento atributo livre cotacao-item.char-1 */
                              {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                              {ccp/cc9019.i51 "yes"}
                          END.
                          ASSIGN i-trib-ii-i1 = integer(substring(item.char-2,20,2))
                                 de-aliq-ii-i1 = de-aliq-ii-i50.
                     END.
    
                 /* TTKBDA
                 IF  AVAIL ITEM
                 AND ITEM.tipo-con-est = 2 THEN
                     ASSIGN de-peso-bruto = de-peso-bruto / ordens-embarque.quantidade.*/
    
                     CASE i-trib-ii-i1:
                         WHEN 1 THEN
                             ASSIGN c-trib-ii = "T".
                         WHEN 2 THEN
                             ASSIGN c-trib-ii = "I".
                         WHEN 3 THEN
                             ASSIGN c-trib-ii = "O".
                         WHEN 4 THEN
                             ASSIGN c-trib-ii = "R".
                     END CASE.
                     CASE item-doc-est.cd-trib-icm:
                         WHEN 1 THEN
                             ASSIGN c-trib-icm = "T".
                         WHEN 2 THEN
                             ASSIGN c-trib-icm = "I".
                         WHEN 3 THEN
                             ASSIGN c-trib-icm = "O".
                         WHEN 4 THEN
                             ASSIGN c-trib-icm = "R".
                         WHEN 5 THEN
                             ASSIGN c-trib-icm = "D".
                     END CASE.
                     CASE item-doc-est.cd-trib-ipi:
                         WHEN 1 THEN
                             ASSIGN c-trib-ipi = "T".
                         WHEN 2 THEN
                             ASSIGN c-trib-ipi = "I".
                         WHEN 3 THEN
                             ASSIGN c-trib-ipi = "O".
                         WHEN 4 THEN
                             ASSIGN c-trib-ipi = "R".
                     END CASE.
            
                     CASE item-doc-est.cd-trib-ipi:
                         WHEN 1 THEN
                             ASSIGN c-trib-ipi = "T".
                         WHEN 2 THEN
                             ASSIGN c-trib-ipi = "I".
                         WHEN 3 THEN
                             ASSIGN c-trib-ipi = "O".
                         WHEN 4 THEN
                             ASSIGN c-trib-ipi = "R".
                     END CASE.
                     CASE &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN item-doc-est.idi-tributac-pis
                          &ELSE INT(TRIM(substring(item-doc-est.char-2,21,1)))
                          &ENDIF :
                         WHEN 1 THEN
                             ASSIGN c-trib-pis = "T".
                         WHEN 2 THEN
                             ASSIGN c-trib-pis = "I".
                         WHEN 3 THEN
                             ASSIGN c-trib-pis = "O".
                         WHEN 4 THEN
                             ASSIGN c-trib-pis = "R".
                     END CASE.
            
                     CASE &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN item-doc-est.idi-tributac-cofins
                         &ELSE INT(TRIM(substring(item-doc-est.char-2,83,1)))
                         &ENDIF :
                         WHEN 1 THEN
                             ASSIGN c-trib-cofins = "T".
                         WHEN 2 THEN
                             ASSIGN c-trib-cofins = "I".
                         WHEN 3 THEN
                             ASSIGN c-trib-cofins = "O".
                         WHEN 4 THEN
                             ASSIGN c-trib-cofins = "R".
                     END CASE.
            
                     FOR FIRST item-doc-est-cex WHERE
                               item-doc-est-cex.serie-docto  = item-doc-est.serie-docto AND
                               item-doc-est-cex.nro-docto    = item-doc-est.nro-docto   AND
                               item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente AND
                               item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao AND
                               item-doc-est-cex.sequencia    = item-doc-est.sequencia    AND
                               item-doc-est-cex.cod-desp     = i-desp-ii NO-LOCK:
                     END.
    
                     ASSIGN de-val-desp-ii = 0
                            de-val-desp-ii = IF AVAIL item-doc-est-cex THEN item-doc-est-cex.val-desp
                                             ELSE 0.
    
                     FOR FIRST  processo-imp
                         FIELDS (nr-proc-imp)
                         WHERE  processo-imp.num-pedido = ordem-compra.num-pedido NO-LOCK: END.
    
                     &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN 
                         ASSIGN de-aliq-pis        = item-doc-est.val-aliq-pis
                                de-val-pis         = item-doc-est.valor-pis
                                de-aliq-cofins     = item-doc-est.val-aliq-cofins
                                de-val-cofins      = item-doc-est.val-cofins.
                     
                     &ELSE
                         ASSIGN de-aliq-pis    = dec(trim(substring(item-doc-est.char-2,22,5)))
                                de-val-pis     = dec(trim(substring(item-doc-est.char-2,41,14)))
                                de-aliq-cofins = dec(trim(substring(item-doc-est.char-2,84,5)))
                                de-val-cofins  = dec(trim(substring(item-doc-est.char-2,103,14))).
                     &ENDIF
                                   
                     PUT i-seq-item                   AT 01
                         item-doc-est.it-codigo       AT 07
                         c-desc-item                  AT 24
                         item-doc-est.qt-do-forn      AT 85
                         item-doc-est.preco-unit[1]   AT 103
                         de-preco-total-me            AT 121
                         item-doc-est.preco-total[1]  AT 137
                         de-peso-bruto                AT 154
                         de-peso-liq-unit             AT 170 FORMAT ">>>>,>>9.9999999999"
                         item-doc-est.peso-liquido    AT 191 FORMAT ">>>>>,>>9.99999"
                         c-trib-ii                    AT 206
                         de-aliq-ii-i1                AT 211 FORMAT ">>9.99"
                         de-val-desp-ii               AT 218
                         c-trib-ipi                   AT 238
                         item-doc-est.aliquota-ipi    AT 243
                         item-doc-est.valor-ipi[1]    AT 250
                         c-trib-icm                   AT 266 
                         item-doc-est.aliquota-icm    AT 271
                         item-doc-est.valor-icm[1]    AT 277
                         c-trib-pis                   AT 293
                         de-aliq-pis                  AT 298 FORMAT ">>9.99"
                         de-val-pis                   AT 304 FORMAT ">>>>,>>>,>>9.99"
                         c-trib-cofins                AT 320
                         de-aliq-cofins               AT 327 FORMAT ">>9.99"
                         de-val-cofins                AT 333 FORMAT ">>>>,>>>,>>9.99"
                         processo-imp.nr-proc-imp     AT 349
                         item-doc-est.num-pedido      AT 362
                         item-doc-est.numero-ordem    AT 375
                         i-num-adicao                 AT 390 FORMAT ">>>9"
                         de-taxa-siscomex             AT 395 FORMAT ">>>>>,>>>,>>9.99999".
    
                     ASSIGN de-quant-sub-tot       = de-quant-sub-tot       + item-doc-est.qt-do-forn
                            de-preco-sub-tot-me    = de-preco-sub-tot-me    + de-preco-total-me
                            de-preco-sub-tot-mn    = de-preco-sub-tot-mn    + item-doc-est.preco-total[1]
                            de-peso-bruto-sub-tot  = de-peso-bruto-sub-tot  + de-peso-bruto
                            de-peso-liq-tot-sub    = de-peso-liq-tot-sub    + item-doc-est.peso-liquido
                            de-val-desp-ii-sub-tot = de-val-desp-ii-sub-tot + de-val-desp-ii
                            de-val-ipi-sub-tot     = de-val-ipi-sub-tot     + item-doc-est.valor-ipi[1]
                            de-val-icm-sub-tot     = de-val-icm-sub-tot     + item-doc-est.valor-icm[1]
                            de-val-pis-sub-tot     = de-val-pis-sub-tot     + de-val-pis
                            de-val-cofins-sub-tot  = de-val-cofins-sub-tot  + de-val-cofins
                            de-preco-total-me      = 0
                            de-peso-bruto          = 0
                            de-peso-liq-unit       = 0
                            de-val-desp-ii         = 0
                            de-val-pis             = 0
                            de-val-cofins          = 0.
    
                     IF LAST-OF(item-doc-est.un) THEN DO:
            
                         PUT SKIP(1)
                             "-----------------"   AT 85
                             c-lbl-liter-total-quant         AT 73 
                             de-quant-sub-tot      AT 85 SKIP(1). 
                         
                         ASSIGN de-quant-sub-tot    = 0.
            
                     END.
            
                 IF LAST-OF(item-doc-est.class-fisc) THEN DO:
                         
                         PUT SKIP(1)
                             "---------------"       AT 121
                             "---------------"       AT 137
                             "---------------"       AT 153
                             "---------------"       AT 190
                             "-------------------"   AT 218
                             "---------------"       AT 250
                             "--------------"        AT 278
                             "--------------"        AT 305
                             "--------------"        AT 334
                             "-------------------"   AT 395
                             c-lbl-liter-sub-total + " "            AT 74 
                             de-preco-sub-tot-me     AT 121
                             de-preco-sub-tot-mn     AT 137
                             de-peso-bruto-sub-tot   AT 154
                             de-peso-liq-tot-sub     AT 191
                             de-val-desp-ii-sub-tot  AT 218
                             de-val-ipi-sub-tot      AT 250
                             de-val-icm-sub-tot      AT 277
                             de-val-pis-sub-tot      AT 304
                             de-val-cofins-sub-tot   AT 333
                             de-sub-tx-siscomex      AT 395 FORMAT ">>>>>,>>>,>>9.99999".
            
                         ASSIGN de-preco-tot-geral-me     = de-preco-tot-geral-me + de-preco-sub-tot-me
                                de-preco-tot-geral-mn     = de-preco-tot-geral-mn + de-preco-sub-tot-mn
                                de-peso-bruto-tot-geral   = de-peso-bruto-tot-geral + de-peso-bruto-sub-tot
                                
                                de-peso-liq-tot-geral     = de-peso-liq-tot-geral + de-peso-liq-tot-sub 
                                de-val-desp-ii-tot-geral  = de-val-desp-ii-tot-geral + de-val-desp-ii-sub-tot
                                de-val-ipi-tot-geral      = de-val-ipi-tot-geral + de-val-ipi-sub-tot
                                de-val-icm-tot-geral      = de-val-icm-tot-geral + de-val-icm-sub-tot
                                de-val-pis-tot-geral      = de-val-pis-tot-geral + de-val-pis-sub-tot
                                de-val-cofins-tot-geral   = de-val-cofins-tot-geral + de-val-cofins-sub-tot
                                de-tot-tx-siscomex        = de-tot-tx-siscomex + de-sub-tx-siscomex
        
                                de-preco-sub-tot-me       = 0
                                de-preco-sub-tot-mn       = 0
                                de-peso-bruto-sub-tot     = 0
                                de-peso-liq-tot-sub       = 0
                                de-val-desp-ii-sub-tot    = 0
                                de-val-ipi-sub-tot        = 0
                                de-val-icm-sub-tot        = 0
                                de-val-pis-sub-tot        = 0
                                de-val-cofins-sub-tot     = 0
                                de-sub-tx-siscomex        = 0.
                 END.
            
            END. 
    
        END.

        PUT skip(3)
            "---------------"         AT 121
            "---------------"         AT 137
            "---------------"         AT 153
            "---------------"         AT 190
            "-------------------"     AT 218
            "---------------"         AT 250
            "--------------"          AT 278
            "--------------"          AT 305
            "--------------"          AT 334
            "-------------------"     AT 395
            c-lbl-liter-total-do-embarque + " "      AT 66
            de-preco-tot-geral-me     AT 121
            de-preco-tot-geral-mn     AT 137
            de-peso-bruto-tot-geral   AT 154
            de-peso-liq-tot-geral     AT 191
            de-val-desp-ii-tot-geral  AT 218
            de-val-ipi-tot-geral      AT 250
            de-val-icm-tot-geral      AT 277
            de-val-pis-tot-geral      AT 304
            de-val-cofins-tot-geral   AT 333
            de-tot-tx-siscomex        AT 395 FORMAT ">>>>>,>>>,>>9.99999".
    
        FOR FIRST historico-embarque WHERE
                  historico-embarque.cod-estabel = embarque-imp.cod-estabel AND
                  historico-embarque.embarque    = embarque-imp.embarque NO-LOCK:
        END.
        
        ASSIGN i-cod-itiner = historico-embarque.cod-itiner.
        
        FIND itinerario WHERE 
             itinerario.cod-itiner = i-cod-itiner NO-LOCK NO-ERROR.
        
        FIND historico-embarque
            WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
              AND historico-embarque.embarque      = embarque-imp.embarque 
              AND historico-embarque.cod-itiner    = i-cod-itiner 
              AND historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar NO-LOCK NO-ERROR.
        IF AVAIL historico-embarque THEN DO:
               ASSIGN i-seq-nacionalizacao = historico-embarque.sequencia.
        END.

        RUN piTotalizaDespEmbarque IN THIS-PROCEDURE (INPUT embarque-imp.cod-estabel,
                                                      INPUT embarque-imp.embarque,
                                                      INPUT embarque-imp.cod-estabel,
                                                      INPUT embarque-imp.embarque,
                                                      OUTPUT TABLE tt-desp-embarque).

        IF tt-parametros.l-gera-prim-nf-remes-mae THEN DO:
            FOR EACH tt-embarque-filho:
                RUN piTotalizaDespEmbarque IN THIS-PROCEDURE (INPUT embarque-imp.cod-estabel,
                                                              INPUT embarque-imp.embarque,
                                                              INPUT tt-embarque-filho.cod-estabel,
                                                              INPUT tt-embarque-filho.embarque,
                                                              OUTPUT TABLE tt-desp-embarque).
    
            END.
        END.

        IF  NOT tt-parametros.l-nf-ajuste THEN DO:
    
            FOR EACH tt-docum-est:
            
                /*Imposto de Importaá∆o*/
                FOR EACH  docum-est-cex WHERE
                          docum-est-cex.serie-docto       = tt-docum-est.serie-docto  AND
                          docum-est-cex.nro-docto         = tt-docum-est.nro-docto    AND
                          docum-est-cex.cod-emitente      = tt-docum-est.cod-emitente AND
                          docum-est-cex.nat-operacao      = tt-docum-est.nat-operacao and
                          docum-est-cex.cod-desp          = i-cod-desp-ii NO-LOCK :
        
                          FIND FIRST desp-imp
                               WHERE desp-imp.cod-desp = docum-est-cex.cod-desp NO-LOCK NO-ERROR.
    
                          FOR FIRST desp-embarque FIELDS(descricao)  NO-LOCK
                              WHERE desp-embarque.cod-estabel = tt-docum-est.cod-estabel
                                AND desp-embarque.embarque    = tt-docum-est.embarque
                                AND desp-embarque.cod-desp    = docum-est-cex.cod-desp:
                          END.
        
                          IF NOT AVAIL desp-imp THEN NEXT.
        
                          RUN pi-retornarDescricao IN THIS-PROCEDURE (INPUT  "desp-imp.tipo":U,
                                                                      INPUT  desp-imp.tipo,
                                                                      OUTPUT c-tipo).
        
                          ASSIGN l-inc-ii         = desp-imp.log-2
                                 l-inc-ipi        = desp-imp.inc-base-ipi
                                 l-inc-icms       = desp-imp.inc-base-icms
                                 l-val-duplic     = desp-imp.inc-val-duplic.
    
                        
                          &if "{&bf_mat_versao_ems}" >= "2.06" &then
                              ASSIGN l-pis-valor      = desp-imp.log-incid-base-pis-val
                                     l-pis-despesa    = desp-imp.log-incid-base-pis-despes
                                     l-cofins-valor   = desp-imp.log-incid-base-cofins-val
                                     l-cofins-despesa = desp-imp.log-incid-base-cofins-despes.
                          &else
                              ASSIGN l-pis-valor      = IF SUBSTR(desp-imp.char-1,10,1) = '1' THEN YES ELSE NO
                                     l-pis-despesa    = IF SUBSTR(desp-imp.char-1,11,1) = '1' THEN YES ELSE NO
                                     l-cofins-valor   = IF SUBSTR(desp-imp.char-1,12,1) = '1' THEN YES ELSE NO
                                     l-cofins-despesa = IF SUBSTR(desp-imp.char-1,13,1) = '1' THEN YES ELSE NO.
                          &endif
                          
                          CREATE tt-desp-nacion.                                                                          
                          ASSIGN tt-desp-nacion.cod-desp      = docum-est-cex.cod-desp                                    
                                 tt-desp-nacion.cod-emit-desp = docum-est-cex.cod-emitente-desp     
                                 tt-desp-nacion.descricao     = IF AVAIL desp-embarque AND desp-embarque.descricao <> "":U THEN desp-embarque.descricao ELSE desp-imp.descricao
                                 tt-desp-nacion.sequencia     = 0                              
                                 tt-desp-nacion.cod-cond-pag  = docum-est-cex.cod-cond-pag                                
                                 tt-desp-nacion.mo-codigo     = docum-est-cex.mo-codigo                                   
                                 tt-desp-nacion.val-desp-orig = docum-est-cex.val-desp                                    
                                 tt-desp-nacion.de-cotacao    = IF docum-est-cex.mo-codigo = 0 THEN 1 ELSE de-cotacao-dia 
                                 tt-desp-nacion.val-desp      = IF docum-est-cex.mo-codigo = 0 THEN docum-est-cex.val-desp
                                                                ELSE (docum-est-cex.val-desp * de-cotacao-dia)  
                                 tt-desp-nacion.tipo          = c-tipo
                                 tt-desp-nacion.inc-ii        = l-inc-ii
                                 tt-desp-nacion.inc-ipi       = l-inc-ipi
                                 tt-desp-nacion.inc-icms      = l-inc-icms
                                 tt-desp-nacion.val-duplic    = l-val-duplic
                                 tt-desp-nacion.pis-valor      = l-pis-valor       
                                 tt-desp-nacion.pis-despesa    = l-pis-despesa   
                                 tt-desp-nacion.cofins-valor   = l-cofins-valor  
                                 tt-desp-nacion.cofins-despesa = l-cofins-despesa
                                 c-tipo        = ""
                                 l-inc-ii          = NO
                                 l-inc-ipi         = NO
                                 l-inc-icms        = NO
                                 l-val-duplic      = NO
                                 l-pis-valor       = NO
                                 l-pis-despesa     = NO
                                 l-cofins-valor    = NO
                                 l-cofins-despesa  = NO.
                END.
    
            END.
            ASSIGN de-cotacao-dia = 0.
            
            FOR EACH historico-embarque WHERE
                     historico-embarque.cod-estabel = embarque-imp.cod-estabel AND
                     historico-embarque.embarque    = embarque-imp.embarque    AND
                     historico-embarque.cod-itiner  = i-cod-itiner             NO-LOCK:
                     
                     FOR EACH tt-desp-embarque WHERE
                              tt-desp-embarque.cod-estabel   = historico-embarque.cod-estabel AND
                              tt-desp-embarque.embarque      = historico-embarque.embarque    AND
                              tt-desp-embarque.cod-itiner    = historico-embarque.cod-itiner  AND
                              tt-desp-embarque.cod-pto-contr = historico-embarque.cod-pto-contr NO-LOCK:
                
                              IF tt-desp-embarque.cod-desp = i-cod-desp-ii THEN NEXT.
                             
                              FIND desp-imp WHERE
                                   desp-imp.cod-desp = tt-desp-embarque.cod-desp NO-LOCK NO-ERROR.
                    
                              IF NOT AVAIL desp-imp THEN NEXT.
                             
                              if NOT desp-imp.inc-val-frete AND
                                 NOT desp-imp.inc-val-seguro AND 
                                 NOT desp-imp.inc-val-embal AND
                                 NOT desp-imp.inc-val-outras-desp THEN NEXT.
    
                              RUN pi-retornarDescricao IN THIS-PROCEDURE (INPUT  "desp-imp.tipo":U,
                                                                          INPUT  desp-imp.tipo,
                                                                          OUTPUT c-tipo).
    
                              ASSIGN l-inc-ii         = desp-imp.log-2
                                     l-inc-ipi        = desp-imp.inc-base-ipi
                                     l-inc-icms       = desp-imp.inc-base-icms
                                     l-val-duplic     = desp-imp.inc-val-duplic.
    
                              &if "{&bf_mat_versao_ems}" >= "2.06" &then
                                  ASSIGN l-pis-valor      = desp-imp.log-incid-base-pis-val
                                         l-pis-despesa    = desp-imp.log-incid-base-pis-despes
                                         l-cofins-valor   = desp-imp.log-incid-base-cofins-val
                                         l-cofins-despesa = desp-imp.log-incid-base-cofins-despes.
                              &else
                                  ASSIGN l-pis-valor      = IF SUBSTR(desp-imp.char-1,10,1) = '1' THEN YES ELSE NO
                                         l-pis-despesa    = IF SUBSTR(desp-imp.char-1,11,1) = '1' THEN YES ELSE NO
                                         l-cofins-valor   = IF SUBSTR(desp-imp.char-1,12,1) = '1' THEN YES ELSE NO
                                         l-cofins-despesa = IF SUBSTR(desp-imp.char-1,13,1) = '1' THEN YES ELSE NO.
                              &endif
    
                              find cotacao where 
                                   cotacao.mo-codigo   = tt-desp-embarque.mo-codigo and 
                                   cotacao.ano-periodo = string(year(tt-parametros.da-cotacao)) + string(month(tt-parametros.da-cotacao),"99") and 
                                   cotacao.cotacao[int(day(tt-parametros.da-cotacao))] <> 0 no-lock no-error.
    
                              ASSIGN de-cotacao-dia = if AVAIL cotacao then cotacao.cotacao[int(day(tt-parametros.da-cotacao))] 
                                                      ELSE 1.
    
                              FIND FIRST tt-epc
                                   WHERE tt-epc.cod-event     = "CalculoPrecoUnitario":U
                                     AND tt-epc.cod-parameter = "AlteraCotacao":U NO-ERROR.
                        
                              IF  AVAIL tt-epc THEN
                                   ASSIGN de-cotacao-dia    = DEC(tt-epc.val-parameter).
    
                              CREATE tt-desp-nacion.
                              ASSIGN tt-desp-nacion.cod-desp       = tt-desp-embarque.cod-desp
                                     tt-desp-nacion.descricao      = IF tt-desp-embarque.descricao <> "":U THEN tt-desp-embarque.descricao ELSE desp-imp.descricao
                                     tt-desp-nacion.cod-emit-desp  = tt-desp-embarque.cod-emitente-desp 
                                     tt-desp-nacion.sequencia      = historico-embarque.sequencia
                                     tt-desp-nacion.cod-cond-pag   = tt-desp-embarque.cod-cond-pag
                                     tt-desp-nacion.mo-codigo      = tt-desp-embarque.mo-codigo
                                     tt-desp-nacion.val-desp-orig  = tt-desp-embarque.val-desp
                                     tt-desp-nacion.de-cotacao     = IF tt-desp-embarque.mo-codigo = 0 THEN 1 ELSE de-cotacao-dia
                                     tt-desp-nacion.val-desp       = IF tt-desp-embarque.mo-codigo = 0 THEN tt-desp-embarque.val-desp
                                                                     ELSE (tt-desp-embarque.val-desp * de-cotacao-dia)
                                     tt-desp-nacion.tipo           = c-tipo
                                     tt-desp-nacion.inc-ii         = l-inc-ii
                                     tt-desp-nacion.inc-ipi        = l-inc-ipi
                                     tt-desp-nacion.inc-icms       = l-inc-icms
                                     tt-desp-nacion.val-duplic     = l-val-duplic
                                     tt-desp-nacion.pis-valor      = l-pis-valor     
                                     tt-desp-nacion.pis-despesa    = l-pis-despesa   
                                     tt-desp-nacion.cofins-valor   = l-cofins-valor  
                                     tt-desp-nacion.cofins-despesa = l-cofins-despesa
                                     c-tipo                        = ""
                                     l-inc-ii                      = NO
                                     l-inc-ipi                     = NO
                                     l-inc-icms                    = NO
                                     l-val-duplic                  = NO
                                     l-pis-valor                   = NO
                                     l-pis-despesa                 = NO
                                     l-cofins-valor                = NO
                                     l-cofins-despesa              = NO
                                     de-cotacao-dia                = 0.
                  
                     END.
            END.
        END.
        
        IF CAN-FIND(FIRST tt-desp-nacion WHERE
                          tt-desp-nacion.sequencia <= i-seq-nacionalizacao) THEN DO:
        
            PUT SKIP(3) c-lbl-liter-despesasimpostos-ate-o-ponto-d FORMAT "x(49)" SKIP(2).
            
            PUT c-lbl-liter-forn-desp-nome-abrev-despesa-d FORMAT "x(203)" SKIP
                "--------- ------------ ------- ------------------------------ --------- ------------------- ------- ------------------- --------------- ---- ---- ---- ---- ---------- -------- ---------- ----------- ---------------" SKIP.
            
            FOR EACH tt-desp-nacion where
                     tt-desp-nacion.sequencia <= i-seq-nacionalizacao NO-LOCK
                     BREAK BY tt-desp-nacion.cod-emit-desp
                           BY tt-desp-nacion.sequencia:
                    
                     FIND emitente WHERE
                          emitente.cod-emitente = tt-desp-nacion.cod-emit-desp NO-LOCK NO-ERROR.
            
                     PUT  tt-desp-nacion.cod-emit-desp  AT 01
                          emitente.nome-abrev           AT 11
                          tt-desp-nacion.cod-desp       AT 25
                          tt-desp-nacion.descricao      AT 32 
                          tt-desp-nacion.cod-cond-pag   AT 68
                          tt-desp-nacion.val-desp       AT 73 
                          tt-desp-nacion.mo-codigo      AT 98 
                          tt-desp-nacion.val-desp-orig  AT 101 
                          tt-desp-nacion.de-cotacao     AT 121 
                          tt-desp-nacion.val-duplic     AT 137 
                          tt-desp-nacion.inc-ii         AT 142 
                          tt-desp-nacion.inc-ipi        AT 147 
                          tt-desp-nacion.inc-icms       AT 152 
                          tt-desp-nacion.pis-valor      AT 157
                          tt-desp-nacion.pis-despesa    AT 168
                          tt-desp-nacion.cofins-valor   AT 177
                          tt-desp-nacion.cofins-despesa AT 188
                          tt-desp-nacion.tipo           AT 200.
            
                     ASSIGN de-val-tot-desp = de-val-tot-desp + tt-desp-nacion.val-desp.
            END.
            
            PUT SKIP "------------------" AT 71
                     c-lbl-liter-total-despesas + ":" AT 55
                     de-val-tot-desp.
            
        END.
    
        ASSIGN de-val-tot-desp = 0.
    
        IF CAN-FIND(FIRST tt-desp-nacion WHERE
                          tt-desp-nacion.sequencia > i-seq-nacionalizacao) THEN DO:
        
            PUT SKIP(3) c-lbl-liter-despesasimpostos-apos-o-ponto FORMAT "x(50)" SKIP(2).
            
            PUT c-lbl-liter-forn-desp-nome-abrev-despesa-d-2 FORMAT "x(203)" SKIP
                "--------- ------------ ------- ------------------------------ --------- ------------------- ------- ------------------- --------------- ---- ---- ---- ---- ---------- -------- ---------- ----------- ---------------" SKIP.
            
            FOR EACH tt-desp-nacion where
                     tt-desp-nacion.sequencia > i-seq-nacionalizacao NO-LOCK
                     BREAK BY tt-desp-nacion.cod-emit-desp
                           BY tt-desp-nacion.sequencia:
                    
                     FIND emitente WHERE
                          emitente.cod-emitente = tt-desp-nacion.cod-emit-desp NO-LOCK NO-ERROR.
            
                     PUT  tt-desp-nacion.cod-emit-desp  AT 01
                          emitente.nome-abrev           AT 11
                          tt-desp-nacion.cod-desp       AT 25
                          tt-desp-nacion.descricao      AT 32 
                          tt-desp-nacion.cod-cond-pag   AT 68
                          tt-desp-nacion.val-desp       AT 73 
                          tt-desp-nacion.mo-codigo      AT 98 
                          tt-desp-nacion.val-desp-orig  AT 101 
                          tt-desp-nacion.de-cotacao     AT 121 
                          tt-desp-nacion.val-duplic     AT 137 
                          tt-desp-nacion.inc-ii         AT 142 
                          tt-desp-nacion.inc-ipi        AT 147 
                          tt-desp-nacion.inc-icms       AT 152
                          tt-desp-nacion.pis-valor      AT 157
                          tt-desp-nacion.pis-despesa    AT 168
                          tt-desp-nacion.cofins-valor   AT 177
                          tt-desp-nacion.cofins-despesa AT 188
                          tt-desp-nacion.tipo           AT 200.
                     
                     ASSIGN de-val-tot-desp = de-val-tot-desp + tt-desp-nacion.val-desp.
            END.
            
            PUT SKIP "------------------" AT 71
                     c-lbl-liter-total-despesas-2 + ":" AT 55
                     de-val-tot-desp.
        END.

        ASSIGN de-val-tot-desp = 0.
    
    PAGE.

    {include/i-rpclo.i}
    &endif
&endif

return 'OK':U.


/* Procedures Internas */

PROCEDURE pi-retornarDescricao:

    /* Objetivo: Retornar a descricao dos campos conforme a include padrao.
       Isto e necessario, pois alguns valores foram retirados das includes
       a partir da versao 2.06B */

    /* Definicao de Parametros */
    DEFINE INPUT  PARAMETER p-campo     AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-valor     AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-descricao AS CHARACTER NO-UNDO.

    /* Definicao de Variaveis */
    DEFINE VARIABLE c-lista   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-indice  AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE i-entrada AS INTEGER   NO-UNDO.

    /* Carregar lista com os valores para a propriedade Radio-Buttons de um Radio-Set */
    CASE p-campo:
        WHEN "desp-imp.tipo":U THEN ASSIGN c-lista = {cxinc/i01cx010.i 07}.
    END CASE.

    ASSIGN l-indice = NO.

    DO  i-entrada = 1 TO NUM-ENTRIES(c-lista):
        /* Os indices (numeros) somente estao nas entradas pares, por isto este controle */
        IF  l-indice THEN DO:
            ASSIGN l-indice = NO.

            /* Se entrada atual for igual ao valor do parametro, carregar descricao */
            IF  INTEGER(ENTRY(i-entrada, c-lista)) = p-valor THEN DO:
                ASSIGN p-descricao = ENTRY(i-entrada - 1, c-lista).
                LEAVE.
            END.
        END.
        ELSE
            ASSIGN l-indice = YES.
    END.

    /* Tratamento para ambiente Multi-Idioma */
    &IF "{&FNC_MULTI_IDIOMA}":U = "Yes":U &THEN
        RUN utp/ut-liter.p (input replace(trim(p-descricao)," ","_"),
                            INPUT "",
                            INPUT "").

        ASSIGN p-descricao = RETURN-VALUE.
    &ENDIF
    
END PROCEDURE.

PROCEDURE piTotalizaDespEmbarque:
    /*
    ** Procedure respons†vel por totalizar os valores das Despesas quando 
    ** a primeira remessa est† sendo gerado com a nota M∆e
    */

    DEFINE INPUT PARAMETER pc-cod-estabel-orig LIKE embarque-imp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pc-embarque-orig    LIKE embarque-imp.embarque    NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel      LIKE embarque-imp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pc-embarque         LIKE embarque-imp.embarque    NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-desp-embarque.

    FOR EACH desp-embarque
       WHERE desp-embarque.cod-estabel = pc-cod-estabel
         AND desp-embarque.embarque    = pc-embarque    NO-LOCK:

        FIND FIRST tt-desp-embarque
             WHERE tt-desp-embarque.cod-estabel       = pc-cod-estabel-orig
               AND tt-desp-embarque.embarque          = pc-embarque-orig
               AND tt-desp-embarque.cod-itiner        = desp-embarque.cod-itiner       
               AND tt-desp-embarque.cod-pto-contr     = desp-embarque.cod-pto-contr    
               AND tt-desp-embarque.cod-desp          = desp-embarque.cod-desp         
               AND tt-desp-embarque.cod-emitente-desp = desp-embarque.cod-emitente-desp NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-desp-embarque THEN DO:
           CREATE tt-desp-embarque.
           BUFFER-COPY desp-embarque EXCEPT val-desp TO tt-desp-embarque.
           ASSIGN tt-desp-embarque.cod-estabel = pc-cod-estabel-orig
                  tt-desp-embarque.embarque    = pc-embarque-orig.
        END.
        ASSIGN tt-desp-embarque.val-desp = tt-desp-embarque.val-desp + desp-embarque.val-desp.
    END.

    RETURN "OK":U.
END PROCEDURE.
