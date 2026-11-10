/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0100ARP 2.00.00.057 } /*** "010057" 23/10/2026 10:31:03 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0100arp MIM}
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
*  IM0100ARP.P - Relatorio de conferencia do embarque importacao
*
*  Objetivo: Conferencia do embarque importacao por DI
*
******************************************************************************/

{cdp/cdcfgmat.i}   /* pre-processadores */
{cdp/cdcfgdis.i}   /* pre-processadores */

/*{cxbo/bocx220a.i}  /* definicoes temp-table tt-parametros*/*/
{imp/im0100x.i tt-parametros}
{utp/ut-glob.i}    /* variaveis globais */
{imp/im0100.i}     /*tt-recebe e tt-param*/
{cxbo/bocx225e.i1} /* vari veis atributo livre ordens-embarque */
{include/i-epc200.i IM0100ARP}

         
DEFINE VARIABLE c-desc-moeda             LIKE moeda.descricao                 NO-UNDO.
DEFINE VARIABLE c-desc-emitente          LIKE emitente.nome-emit              NO-UNDO.
DEFINE VARIABLE c-nome-abrev-desp        LIKE emitente.nome-abrev             NO-UNDO.
DEFINE VARIABLE c-descricao-desp         LIKE desp-imp.descricao              NO-UNDO.
DEFINE VARIABLE de-cotacao-dia           AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE c-desc-natur             LIKE natur-oper.denominacao          NO-UNDO.
DEFINE VARIABLE i-seq-item               LIKE item-doc-est.sequencia          NO-UNDO.
DEFINE VARIABLE c-desc-item              LIKE ITEM.desc-item                  NO-UNDO.
DEFINE VARIABLE de-preco-total-me        LIKE item-doc-est.preco-total[1]     NO-UNDO.
DEFINE VARIABLE de-taxa-siscomex         AS DEC  FORMAT ">>>>>,>>>,>>9.99999" NO-UNDO.
DEFINE VARIABLE v-qtd-adic               AS DEC  FORMAT ">>>>>>,>>>,>>9.99"   NO-UNDO.
DEFINE VARIABLE v-val-vucv               AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.  
DEFINE VARIABLE v-val-vmcv-me            AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.  
DEFINE VARIABLE v-val-vmcv               AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.  
DEFINE VARIABLE v-val-peso-brut-merc     AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.  
DEFINE VARIABLE v-val-peso-liq           AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.  
DEFINE VARIABLE v-val-peso-tot           AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.  .
DEFINE VARIABLE v-val-peso-liq-item      AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.  
DEFINE VARIABLE v-val-unit-ii            AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.  
DEFINE VARIABLE v-val-unit-ipi           AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.  
DEFINE VARIABLE v-val-unit-icms          AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.  
DEFINE VARIABLE v-val-unit-pis           AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.  
DEFINE VARIABLE v-val-unit-cofins        AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.  
DEFINE VARIABLE v-de-taxa-siscomex       AS DEC  FORMAT ">>>>>>,>>9.99999"    NO-UNDO.  
DEFINE VARIABLE c-tipo-tributacao-ii     AS CHAR FORMAT "x(09)"               NO-UNDO.
DEFINE VARIABLE v-val-ii                 AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.  
DEFINE VARIABLE c-tipo-tributacao-ipi    AS CHAR FORMAT "x(09)"               NO-UNDO.
DEFINE VARIABLE v-val-ipi                AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.  
DEFINE VARIABLE c-tipo-tributacao-icms   AS CHAR FORMAT "x(09)"               NO-UNDO.
DEFINE VARIABLE v-val-icms               AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.  
DEFINE VARIABLE c-tipo-tributacao-pis    AS CHAR FORMAT "x(09)"               NO-UNDO.
DEFINE VARIABLE v-val-pis                AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.  
DEFINE VARIABLE c-tipo-tributacao-cofins AS CHAR FORMAT "x(09)"               NO-UNDO.
DEFINE VARIABLE v-val-cofins             AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.  
DEFINE VARIABLE v-qtd-adic-di            AS DEC  FORMAT ">>>>>>,>>>,>>9.99"   NO-UNDO.
DEFINE VARIABLE v-val-vucv-di            AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.  
DEFINE VARIABLE v-val-vmcv-me-di         AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE v-val-vmcv-di            AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE v-val-peso-brut-merc-di  AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE v-val-peso-liq-di        AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE v-val-peso-tot-di        AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE v-val-unit-ii-di         AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE v-val-unit-ipi-di        AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE v-val-unit-icms-di       AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE v-val-unit-pis-di        AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE v-val-unit-cofins-di     AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE v-de-taxa-siscomex-di    AS DEC  FORMAT ">>>>>,>>>,>>9.99999" NO-UNDO.
DEFINE VARIABLE v-val-aliq-icm           LIKE decla-import-adic-itens.val-aliq-icms NO-UNDO.
DEFINE VARIABLE v-total-val-desp         LIKE item-doc-est-cex.val-desp NO-UNDO.

DEFINE VARIABLE de-val-ibsuf             AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE de-val-ibsmun            AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE de-val-cbs               AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE de-val-is                AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE de-tot-ibsuf             AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE de-tot-ibsmun            AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE de-tot-cbs               AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE de-tot-is                AS DEC  FORMAT ">>>>>>,>>9.99"       NO-UNDO.
DEFINE VARIABLE de-tot-ibsuf-di          AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE de-tot-ibsmun-di         AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE de-tot-cbs-di            AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE de-tot-is-di             AS DEC  FORMAT ">>>>>>,>>9.99"       NO-UNDO.
DEFINE VARIABLE de-aliq-ibsuf            AS DEC  FORMAT ">>9.99"              NO-UNDO.
DEFINE VARIABLE de-aliq-ibsmun           AS DEC  FORMAT ">>9.99"              NO-UNDO.
DEFINE VARIABLE de-aliq-cbs              AS DEC  FORMAT ">>9.99"              NO-UNDO.
DEFINE VARIABLE de-aliq-is               AS DEC  FORMAT ">>9.99"              NO-UNDO.
DEFINE VARIABLE de-aliq-espec-is         AS DEC  FORMAT ">>9.99"              NO-UNDO.
DEFINE VARIABLE de-qtde-tribut-is        AS DEC  FORMAT ">>>,>>>,>>9.9999"    NO-UNDO.
DEFINE VARIABLE de-aliq-red-ibsuf        AS DEC  FORMAT ">>9.99"              NO-UNDO.
DEFINE VARIABLE de-aliq-red-ibsmun       AS DEC  FORMAT ">>9.99"              NO-UNDO.
DEFINE VARIABLE de-aliq-red-cbs          AS DEC  FORMAT ">>9.99"              NO-UNDO.
DEFINE VARIABLE c-trib-ibsuf             AS CHAR FORMAT "x(09)"               NO-UNDO.
DEFINE VARIABLE c-trib-ibsmun            AS CHAR FORMAT "x(09)"               NO-UNDO.
DEFINE VARIABLE c-trib-cbs               AS CHAR FORMAT "x(09)"               NO-UNDO.
DEFINE VARIABLE c-trib-is                AS CHAR FORMAT "x(09)"               NO-UNDO.
DEFINE VARIABLE c-class-trib-ibsuf       AS CHAR FORMAT "x(09)"               NO-UNDO.
DEFINE VARIABLE c-class-trib-ibsmun      AS CHAR FORMAT "x(09)"               NO-UNDO.
DEFINE VARIABLE c-class-trib-cbs         AS CHAR FORMAT "x(09)"               NO-UNDO.
DEFINE VARIABLE c-class-trib-is          AS CHAR FORMAT "x(09)"               NO-UNDO.
DEFINE VARIABLE c-cst-ibsuf              AS CHAR FORMAT "x(05)"               NO-UNDO.
DEFINE VARIABLE c-cst-ibsmun             AS CHAR FORMAT "x(05)"               NO-UNDO.
DEFINE VARIABLE c-cst-cbs                AS CHAR FORMAT "x(05)"               NO-UNDO.
DEFINE VARIABLE c-cst-is                 AS CHAR FORMAT "x(05)"               NO-UNDO.
DEFINE VARIABLE de-aliq-ibsuf-reg        AS DEC  FORMAT ">>9.99"              NO-UNDO.
DEFINE VARIABLE de-aliq-ibsmun-reg       AS DEC  FORMAT ">>9.99"              NO-UNDO.
DEFINE VARIABLE de-aliq-cbs-reg          AS DEC  FORMAT ">>9.99"              NO-UNDO.
DEFINE VARIABLE de-val-ibsuf-reg         AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE de-val-ibsmun-reg        AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE de-val-cbs-reg           AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE c-class-trib-ibsuf-reg   AS CHAR FORMAT "x(09)"               NO-UNDO.
DEFINE VARIABLE c-class-trib-ibsmun-reg  AS CHAR FORMAT "x(09)"               NO-UNDO.
DEFINE VARIABLE c-class-trib-cbs-reg     AS CHAR FORMAT "x(09)"               NO-UNDO.
DEFINE VARIABLE c-cst-ibsuf-reg          AS CHAR FORMAT "x(05)"               NO-UNDO.
DEFINE VARIABLE c-cst-ibsmun-reg         AS CHAR FORMAT "x(05)"               NO-UNDO.
DEFINE VARIABLE c-cst-cbs-reg            AS CHAR FORMAT "x(05)"               NO-UNDO.
DEFINE VARIABLE de-tot-ibsuf-reg         AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE de-tot-ibsmun-reg        AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE de-tot-cbs-reg           AS DEC  FORMAT ">>>>>>,>>9.99999999" NO-UNDO.

DEFINE VARIABLE de-base-gov-ibsuf          AS DECIMAL FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE de-aliq-gov-ibsuf          AS DECIMAL FORMAT ">>9.99"              NO-UNDO.
DEFINE VARIABLE de-perc-red-gov-ibsuf      AS DECIMAL FORMAT ">>9.99"              NO-UNDO.
DEFINE VARIABLE de-aliq-efetiva-gov-ibsuf  AS DECIMAL FORMAT ">>9.99"              NO-UNDO.
DEFINE VARIABLE de-val-gov-ibsuf           AS DECIMAL FORMAT ">>>>>>,>>9.99999999" NO-UNDO.

DEFINE VARIABLE de-base-gov-ibsmun         AS DECIMAL FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE de-aliq-gov-ibsmun         AS DECIMAL FORMAT ">>9.99"              NO-UNDO.
DEFINE VARIABLE de-perc-red-gov-ibsmun     AS DECIMAL FORMAT ">>9.99"              NO-UNDO.
DEFINE VARIABLE de-aliq-efetiva-gov-ibsmun AS DECIMAL FORMAT ">>9.99"              NO-UNDO.
DEFINE VARIABLE de-val-gov-ibsmun          AS DECIMAL FORMAT ">>>>>>,>>9.99999999" NO-UNDO.

DEFINE VARIABLE de-base-gov-cbs            AS DECIMAL FORMAT ">>>>>>,>>9.99999999" NO-UNDO.
DEFINE VARIABLE de-aliq-gov-cbs            AS DECIMAL FORMAT ">>9.99"              NO-UNDO.
DEFINE VARIABLE de-perc-red-gov-cbs        AS DECIMAL FORMAT ">>9.99"              NO-UNDO.
DEFINE VARIABLE de-aliq-efetiva-gov-cbs    AS DECIMAL FORMAT ">>9.99"              NO-UNDO.
DEFINE VARIABLE de-val-gov-cbs             AS DECIMAL FORMAT ">>>>>>,>>9.99999999" NO-UNDO.

DEFINE VARIABLE l-nt2024002 AS LOGICAL NO-UNDO.
ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002":U AND funcao.ativo).

DEFINE VARIABLE c-lbl-liter-di AS CHARACTER FORMAT "X(10)" NO-UNDO.
{utp/ut-liter.i "D.I./DUIMP" *}
ASSIGN c-lbl-liter-di = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-moeda AS CHARACTER FORMAT "X(9)" NO-UNDO.
{utp/ut-liter.i "MOEDA" *}
ASSIGN c-lbl-liter-moeda = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-taxa-cambio AS CHARACTER FORMAT "X(15)" NO-UNDO.
{utp/ut-liter.i "TAXA_CAMBIO" *}
ASSIGN c-lbl-liter-taxa-cambio = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-incoterm AS CHARACTER FORMAT "X(12)" NO-UNDO.
{utp/ut-liter.i "INCOTERM" *}
ASSIGN c-lbl-liter-incoterm = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-embarque AS CHARACTER FORMAT "X(16)" NO-UNDO.
{utp/ut-liter.i "EMBARQUE" *}
ASSIGN c-lbl-liter-embarque = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-fornecedor AS CHARACTER FORMAT "X(14)" NO-UNDO.
{utp/ut-liter.i "FORNECEDOR" *}
ASSIGN c-lbl-liter-fornecedor = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-nat-operacao AS CHARACTER FORMAT "X(17)" NO-UNDO.
{utp/ut-liter.i "NAT._OPERACAO" *}
ASSIGN c-lbl-liter-nat-operacao = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-seq AS CHARACTER FORMAT "X(3)" NO-UNDO.
{utp/ut-liter.i "SEQ" *}
ASSIGN c-lbl-liter-seq = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-item AS CHARACTER FORMAT "X(6)" NO-UNDO.
{utp/ut-liter.i "ITEM" *}
ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-descricao AS CHARACTER FORMAT "X(11)" NO-UNDO.
{utp/ut-liter.i "DESCRICAO" *}
ASSIGN c-lbl-liter-descricao = TRIM(RETURN-VALUE).
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
DEFINE VARIABLE c-lbl-liter-valor-ii AS CHARACTER FORMAT "X(10)" NO-UNDO.
{utp/ut-liter.i "VALOR_II" *}
ASSIGN c-lbl-liter-valor-ii = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-ipi AS CHARACTER FORMAT "X(5)" NO-UNDO.
{utp/ut-liter.i "IPI" *}
ASSIGN c-lbl-liter-ipi = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-valor-ipi AS CHARACTER FORMAT "X(11)" NO-UNDO.
{utp/ut-liter.i "VALOR_IPI" *}
ASSIGN c-lbl-liter-valor-ipi = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-icms AS CHARACTER FORMAT "X(6)" NO-UNDO.
{utp/ut-liter.i "ICMS" *}
ASSIGN c-lbl-liter-icms = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-valor-icms AS CHARACTER FORMAT "X(12)" NO-UNDO.
{utp/ut-liter.i "VALOR_ICMS" *}
ASSIGN c-lbl-liter-valor-icms = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-pis AS CHARACTER FORMAT "X(5)" NO-UNDO.
{utp/ut-liter.i "PIS" *}
ASSIGN c-lbl-liter-pis = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-valor-pis AS CHARACTER FORMAT "X(11)" NO-UNDO.
{utp/ut-liter.i "VALOR_PIS" *}
ASSIGN c-lbl-liter-valor-pis = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cofins AS CHARACTER FORMAT "X(8)" NO-UNDO.
{utp/ut-liter.i "COFINS" *}
ASSIGN c-lbl-liter-cofins = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-valor-cofins AS CHARACTER FORMAT "X(14)" NO-UNDO.
{utp/ut-liter.i "VALOR_COFINS" *}
ASSIGN c-lbl-liter-valor-cofins = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-processo-imp AS CHARACTER FORMAT "X(14)" NO-UNDO.
{utp/ut-liter.i "PROCESSO_IMP" *}
ASSIGN c-lbl-liter-processo-imp = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-pedido AS CHARACTER FORMAT "X(8)" NO-UNDO.
{utp/ut-liter.i "PEDIDO" *}
ASSIGN c-lbl-liter-pedido = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-ordem-compra AS CHARACTER FORMAT "X(14)" NO-UNDO.
{utp/ut-liter.i "ORDEM_COMPRA" *}
ASSIGN c-lbl-liter-ordem-compra = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-nr-adicao AS CHARACTER FORMAT "X(11)" NO-UNDO.
{utp/ut-liter.i "NR_ADICAO" *}
ASSIGN c-lbl-liter-nr-adicao = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-taxa-siscomex AS CHARACTER FORMAT "X(15)" NO-UNDO.
{utp/ut-liter.i "TAXA_SISCOMEX" *}
ASSIGN c-lbl-liter-taxa-siscomex = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-total-embarque AS CHARACTER FORMAT "X(16)" NO-UNDO.
{utp/ut-liter.i "TOTAL_EMBARQUE" *}
ASSIGN c-lbl-liter-total-embarque = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-total-di AS CHARACTER FORMAT "X(14)" NO-UNDO.
{utp/ut-liter.i "TOTAL_DI/DUIMP" *}
ASSIGN c-lbl-liter-total-di = TRIM(RETURN-VALUE).
/* Variaveis despesas da DI */
DEFINE VARIABLE c-lbl-liter-titulo-desp AS CHARACTER FORMAT "X(40)" NO-UNDO.
{utp/ut-liter.i "DESPESAS/IMPOSTOS_AT_NACIONALIZA€ÇO" *}
ASSIGN c-lbl-liter-titulo-desp = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-forn-desp AS CHARACTER FORMAT "X(09)" NO-UNDO.
{utp/ut-liter.i "Forn_Desp" *}
ASSIGN c-lbl-liter-forn-desp = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-nome-abrev AS CHARACTER FORMAT "X(12)" NO-UNDO.
{utp/ut-liter.i "Nome_Abrev" *}
ASSIGN c-lbl-liter-nome-abrev = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-despesa AS CHARACTER FORMAT "X(07)" NO-UNDO.
{utp/ut-liter.i "Despesa" *}
ASSIGN c-lbl-liter-despesa = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-despesa-desc AS CHARACTER FORMAT "X(30)" NO-UNDO.
{utp/ut-liter.i "Descri‡Æo" *}
ASSIGN c-lbl-liter-despesa-desc = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-valor-despesa AS CHARACTER FORMAT "X(19)" NO-UNDO.
{utp/ut-liter.i "Valor_Despesa_MN" *}
ASSIGN c-lbl-liter-valor-despesa = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-total-desp AS CHARACTER FORMAT "X(15)" NO-UNDO.
{utp/ut-liter.i "Total_Despesas:" *}
ASSIGN c-lbl-liter-total-desp = TRIM(RETURN-VALUE).
/* Vari veis Configurador Tributos*/
DEFINE VARIABLE c-lbl-liter-config-trib AS CHARACTER FORMAT "x(25)" NO-UNDO.
{utp/ut-liter.i "CONFIGURADOR_TRIBUTOS" *}
ASSIGN c-lbl-liter-config-trib = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-emit AS CHARACTER FORMAT "x(08)" NO-UNDO.
{utp/ut-liter.i "Emitente" *}
ASSIGN c-lbl-liter-cf-emit = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-serie AS CHARACTER FORMAT "x(05)" NO-UNDO.
{utp/ut-liter.i "S‚rie" *}
ASSIGN c-lbl-liter-cf-serie = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-embarque AS CHARACTER FORMAT "x(08)" NO-UNDO.
{utp/ut-liter.i "Embarque" *}
ASSIGN c-lbl-liter-cf-embarque = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-nat-oper AS CHARACTER FORMAT "x(08)" NO-UNDO.
{utp/ut-liter.i "Nat_Oper" *}
ASSIGN c-lbl-liter-cf-nat-oper = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-seq AS CHARACTER FORMAT "x(03)" NO-UNDO.
{utp/ut-liter.i "Seq" *}
ASSIGN c-lbl-liter-cf-seq = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-item AS CHARACTER FORMAT "x(04)" NO-UNDO.
{utp/ut-liter.i "Item" *}
ASSIGN c-lbl-liter-cf-item = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-tp-trib AS CHARACTER FORMAT "x(12)" NO-UNDO.
{utp/ut-liter.i "Tipo_Tributo" *}
ASSIGN c-lbl-liter-cf-tp-trib = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-conf-trib AS CHARACTER FORMAT "x(20)" NO-UNDO.
{utp/ut-liter.i "Configura‡Æo_Tributo" *}
ASSIGN c-lbl-liter-cf-conf-trib = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-aliq AS CHARACTER FORMAT "x(04)" NO-UNDO.
{utp/ut-liter.i "Aliq" *}
ASSIGN c-lbl-liter-cf-aliq = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-base-calc-trib AS CHARACTER FORMAT "x(17)" NO-UNDO.
{utp/ut-liter.i "Base_Calc_Tributo" *}
ASSIGN c-lbl-liter-cf-base-calc-trib = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-val-trib AS CHARACTER FORMAT "x(11)" NO-UNDO.
{utp/ut-liter.i "Val_Tributo" *}
ASSIGN c-lbl-liter-cf-val-trib = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-cod-trib AS CHARACTER FORMAT "x(14)" NO-UNDO.
{utp/ut-liter.i "Cod_Tributa‡Æo" *}
ASSIGN c-lbl-liter-cf-cod-trib = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-perc-red AS CHARACTER FORMAT "x(12)" NO-UNDO.
{utp/ut-liter.i "Perc_Redu‡Æo" *}
ASSIGN c-lbl-liter-cf-perc-red = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-qtd-vlr-fixo AS CHARACTER FORMAT "x(19)" NO-UNDO.
{utp/ut-liter.i "Quant_de_Valor_Fixo" *}
ASSIGN c-lbl-liter-cf-qtd-vlr-fixo = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-vlr-fixo AS CHARACTER FORMAT "x(10)" NO-UNDO.
{utp/ut-liter.i "Valor_Fixo" *}
ASSIGN c-lbl-liter-cf-vlr-fixo = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-sit-trib AS CHARACTER FORMAT "x(16)" NO-UNDO.
{utp/ut-liter.i "Situa‡Æo_Tributo" *}
ASSIGN c-lbl-liter-cf-sit-trib = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-cod-form-bc AS CHARACTER FORMAT "x(21)" NO-UNDO.
{utp/ut-liter.i "Cod_F¢rmula_Base_Calc" *}
ASSIGN c-lbl-liter-cf-cod-form-bc = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-chave-cenar AS CHARACTER FORMAT "x(13)" NO-UNDO.
{utp/ut-liter.i "Chave_Cen rio" *}
ASSIGN c-lbl-liter-cf-chave-cenar = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-form-calc-trib AS CHARACTER FORMAT "x(20)" NO-UNDO.
{utp/ut-liter.i "F¢rmula_Calc_Tributo" *}
ASSIGN c-lbl-liter-cf-form-calc-trib = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-mem-calc-form-trib AS CHARACTER FORMAT "x(31)" NO-UNDO.
{utp/ut-liter.i "Mem¢ria_C lculo_F¢rmula_Tributo" *}
ASSIGN c-lbl-liter-cf-mem-calc-form-trib = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-form-bc-trib AS CHARACTER FORMAT "x(25)" NO-UNDO.
{utp/ut-liter.i "F¢rmula_Base_Calc_Tributo" *}
ASSIGN c-lbl-liter-cf-form-bc-trib = TRIM(RETURN-VALUE).
DEFINE VARIABLE c-lbl-liter-cf-mem-bc-trib AS CHARACTER FORMAT "x(33)" NO-UNDO.
{utp/ut-liter.i "Mem¢ria_F¢rmula_Base_Calc_Tributo" *}
ASSIGN c-lbl-liter-cf-mem-bc-trib = TRIM(RETURN-VALUE).

DEFINE TEMP-TABLE tt-embarqueDI NO-UNDO 
    FIELD num-di-ems       LIKE decla-import.num-di-ems
    FIELD cod-estab        LIKE decla-import.cod-estab
    FIELD cod-embarq       LIKE decla-import-embarq.cod-embarq
    FIELD nro-docto        LIKE docum-est.nro-docto
    FIELD serie-docto      LIKE docum-est.serie-docto
    FIELD nat-operacao     LIKE docum-est.nat-operacao
    FIELD cod-emitente     LIKE docum-est.cod-emitente
    FIELD cod-estab-fiscal LIKE docum-est.cod-estabel
    FIELD dt-emissao       LIKE docum-est.dt-emissao
    FIELD dt-trans         LIKE docum-est.dt-trans
    FIELD dt-venc-icm      LIKE docum-est.dt-venc-icm
    FIELD dt-venc-ipi      LIKE docum-est.dt-venc-ipi
    FIELD ct-transit       AS   CHARACTER FORMAT "X(17)":U 
    FIELD sc-transit       AS   CHARACTER FORMAT "X(20)":U
    FIELD tot-desconto     AS   DECIMAL FORMAT ">>>>>9,99":U
    FIELD aliquota-icm     AS   LOGICAL
    FIELD observacao       AS   CHARACTER FORMAT "x(2000)":U
    FIELD log-marcado      AS   LOGICAL
    FIELD log-nf-gerada    AS   LOGICAL.

DEFINE TEMP-TABLE tt-ct-trib-item-doc-est NO-UNDO LIKE ct-trib-item-doc-est
    FIELD cod-tributac AS CHAR.

def input param TABLE FOR tt-parametros.
def input param TABLE FOR tt-param.
def input param TABLE FOR tt-embarqueDI.

{include/i-rpvar.i}

assign c-programa     = "im0100"
       c-versao       = "2.00"
       c-revisao      = "000"
       c-titulo-relat = "RELATORIO DE CONFERENCIA DO EMBARQUE IMPORTACAO"
       c-sistema      = "Com‚rcio Exterior".

FIND FIRST tt-parametros NO-LOCK NO-ERROR.
FIND FIRST tt-param      NO-LOCK NO-ERROR.


{include/i-rpcab.i}
{cdp/cd-rpout.i}   /* include customizada Comex */

view frame f-cabec.
view frame f-rodape.

FIND FIRST decla-import NO-LOCK
     WHERE decla-import.cod-di-siscomex = tt-parametros.declaracao-import
     OR    decla-import.num-di-ems      = INT(tt-parametros.declaracao-import) NO-ERROR.

IF NOT AVAIL decla-import THEN 
    RETURN NO-APPLY.

FIND FIRST decla-import-adic NO-LOCK
     WHERE decla-import-adic.num-di-ems = decla-import.num-di-ems NO-ERROR.

IF NOT AVAIL decla-import-adic THEN 
    RETURN NO-APPLY.

FOR FIRST moeda NO-LOCK
    WHERE moeda.mo-codigo = decla-import-adic.cdn-moeda: END.
ASSIGN c-desc-moeda = IF AVAIL moeda THEN moeda.descricao ELSE "".

FIND FIRST decla-import-cotac NO-LOCK
     WHERE decla-import-cotac.num-di-ems = decla-import-adic.num-di-ems
       AND decla-import-cotac.cdn-moeda  = decla-import-adic.cdn-moeda NO-ERROR.

IF AVAIL decla-import-cotac AND decla-import-cotac.val-cotac > 0 THEN
    ASSIGN de-cotacao-dia = decla-import-cotac.val-cotac.
ELSE DO:
    FIND cotacao WHERE
         cotacao.mo-codigo   = decla-import-adic.cdn-moeda AND
         cotacao.ano-periodo = STRING(YEAR(tt-parametros.da-cotacao)) + STRING(MONTH(tt-parametros.da-cotacao),"99") AND
         cotacao.cotacao[INT(DAY(tt-parametros.da-cotacao))] <> 0 NO-LOCK NO-ERROR.
    
    ASSIGN de-cotacao-dia = if AVAIL cotacao then cotacao.cotacao[int(day(tt-parametros.da-cotacao))] 
                            ELSE 1.
END.

FOR FIRST natur-oper NO-LOCK
    WHERE natur-oper.nat-operacao = tt-parametros.nat-operacao: END.

ASSIGN c-desc-natur = IF AVAIL natur-oper THEN natur-oper.denominacao
                      ELSE "".

FIND FIRST param-imp NO-LOCK
    WHERE param-imp.cod-estabel = tt-parametros.cod-estabel NO-ERROR.

EMPTY TEMP-TABLE tt-ct-trib-item-doc-est.
    
/* Inicio -- Projeto Internacional */
DO:
PUT SKIP (1) 
    c-lbl-liter-di FORMAT "x(10)" + ": "          AT 10 decla-import.num-di-ems AT 24
    c-lbl-liter-moeda + ": "                      AT 42 c-desc-moeda            
    c-lbl-liter-taxa-cambio FORMAT "x(11)" + ": " AT 62 de-cotacao-dia          
    c-lbl-liter-incoterm FORMAT "x(8)" + ": "     AT 98 decla-import-adic.cod-incoterm AT 108.

END. 

FOR EACH  tt-embarqueDI NO-LOCK
    WHERE tt-embarqueDI.log-marcado,
    FIRST decla-import-embarq NO-LOCK
    WHERE decla-import-embarq.num-di-ems      = decla-import.num-di-ems
      AND decla-import-embarq.cod-estab       = tt-embarqueDI.cod-estab
      AND decla-import-embarq.cod-embarq      = tt-embarqueDI.cod-embarq,
    EACH decla-import-ord NO-LOCK
   WHERE decla-import-ord.num-di-ems         = decla-import-embarq.num-di-ems
     AND decla-import-ord.cod-embarq         = decla-import-embarq.cod-embarq
     AND decla-import-ord.cod-estab          = decla-import-embarq.cod-estab,
    EACH decla-import-adic-itens NO-LOCK
   WHERE decla-import-adic-itens.num-di-ems  = decla-import-ord.num-di-ems
     AND decla-import-adic-itens.num-adic    = decla-import-ord.num-adic  
     AND decla-import-adic-itens.num-ordem   = decla-import-ord.num-ordem
     AND decla-import-adic-itens.num-parcela = decla-import-ord.num-parcela
BREAK BY decla-import-embarq.cod-embarq:

    FOR FIRST emitente WHERE
          emitente.cod-emitente = decla-import-ord.cdn-fornec NO-LOCK:
    END.
    ASSIGN c-desc-emitente = IF AVAIL emitente THEN emitente.nome-emit
                             ELSE "".

    IF FIRST-OF(decla-import-embarq.cod-embarq) THEN DO:
        /* Inicio -- Projeto Internacional */
        PUT SKIP (2) 
            c-lbl-liter-embarque + ": " FORMAT "X(09)" AT 01 decla-import-embarq.cod-embarq   AT 16      
            c-lbl-liter-fornecedor + ": " FORMAT "X(11)" AT 01 c-desc-emitente             
            c-lbl-liter-nat-operacao + ": " FORMAT "X(15)" AT 01 tt-parametros.nat-operacao SPACE(3) c-desc-natur.

        /* Inicio -- Projeto Internacional */
        PUT SKIP (2) 
            c-lbl-liter-seq            FORMAT "X(03)" AT 003
            c-lbl-liter-item           FORMAT "X(04)" AT 007
            c-lbl-liter-descricao      FORMAT "X(09)" AT 024
            c-lbl-liter-qtde           FORMAT "X(04)" AT 098
            c-lbl-liter-valor-unit     FORMAT "X(10)" AT 117
            c-lbl-liter-total-me       FORMAT "X(08)" AT 142
            c-lbl-liter-total-mn       FORMAT "X(08)" AT 168
            c-lbl-liter-peso-bruto-tot FORMAT "X(14)" AT 180
            c-lbl-liter-peso-liq-unit  FORMAT "X(13)" AT 201
            c-lbl-liter-peso-liq-tot   FORMAT "X(12)" AT 220
            c-lbl-liter-ii             FORMAT "X(02)" AT 233
            "%" + c-lbl-liter-ii       FORMAT "X(03)" AT 249
            c-lbl-liter-valor-ii       FORMAT "X(08)" AT 264
            c-lbl-liter-ipi            FORMAT "X(03)" AT 273
            "%" + c-lbl-liter-ipi      FORMAT "X(04)" AT 287
            c-lbl-liter-valor-ipi      FORMAT "X(09)" AT 302
            c-lbl-liter-icms           FORMAT "X(04)" AT 312
            "%" + c-lbl-liter-icms     FORMAT "X(05)" AT 325
            c-lbl-liter-valor-icms     FORMAT "X(10)" AT 340
            c-lbl-liter-pis            FORMAT "X(03)" AT 351
            "%" + c-lbl-liter-pis      FORMAT "X(04)" AT 363
            c-lbl-liter-valor-pis      FORMAT "X(09)" AT 380
            c-lbl-liter-cofins         FORMAT "X(06)" AT 390
            "%" + c-lbl-liter-cofins   FORMAT "X(07)" AT 400
            c-lbl-liter-valor-cofins   FORMAT "X(12)" AT 415.
            
        IF l-nt2024002 THEN
            PUT "TRIBUTA€ÇO IBS UF":U                     AT 430
                "%IBS UF":U                               AT 449
                "%RED IBS UF":U                           AT 457
                "VALOR IBS UF":U                          AT 476
                "CLASS TRIB IBS UF":U                     AT 489
                "CST IBS UF":U                            AT 507
                "%REG IBS UF":U                           AT 519
                "VALOR REG IBS UF":U                      AT 534
                "CLASS TRIB REG IBS UF":U                 AT 551
                "CST REG IBS UF":U                        AT 573

                "TRIBUTA€ÇO IBS MUN":U                    AT 588
                "%IBS MUN":U                              AT 607
                "%RED IBS MUN":U                          AT 616
                "VALOR IBS MUN":U                         AT 635
                "CLASS TRIB IBS MUN":U                    AT 649
                "CST IBS MUN":U                           AT 668
                "%REG IBS MUN":U                          AT 680
                "VALOR REG IBS MUN":U                     AT 695
                "CLASS TRIB REG IBS MUN":U                AT 713
                "CST REG IBS MUN":U                       AT 736
                
                "TRIBUTA€ÇO CBS":U                        AT 752
                "%CBS":U                                  AT 769
                "%RED CBS":U                              AT 774
                "VALOR CBS":U                             AT 793
                "CLASS TRIB CBS":U                        AT 803
                "CST CBS":U                               AT 818
                "%REG CBS":U                              AT 826
                "VALOR REG CBS":U                         AT 841
                "CLASS TRIB REG CBS":U                    AT 855
                "CST REG CBS":U                           AT 875
                
                "TRIBUT IS":U                             AT 887
                "%IS":U                                   AT 900
                "ALIQ ESP IS":U                           AT 904
                "QTDE TRIB IS":U                          AT 916
                "VALOR IS":U                              AT 933
                "CLAS TRIB":U                             AT 942
                "CST IS":U                                AT 952
                
                c-lbl-liter-processo-imp   FORMAT "X(12)" AT 959 
                c-lbl-liter-pedido         FORMAT "X(06)" AT 972 
                c-lbl-liter-ordem-compra   FORMAT "X(12)" AT 982 
                c-lbl-liter-nr-adicao      FORMAT "X(09)" AT 995 
                c-lbl-liter-taxa-siscomex  FORMAT "X(13)" AT 1010 SKIP.
        ELSE 
            PUT c-lbl-liter-processo-imp   FORMAT "X(12)" AT 426
                c-lbl-liter-pedido         FORMAT "X(06)" AT 439
                c-lbl-liter-ordem-compra   FORMAT "X(12)" AT 449
                c-lbl-liter-nr-adicao      FORMAT "X(09)" AT 462
                c-lbl-liter-taxa-siscomex  FORMAT "X(13)" AT 478 SKIP.
                
        IF l-nt2024002 THEN DO:
            PUT SKIP
                "Base Compra Gov IBS UF":U       AT 430
                "% Compra gov IBS UF":U          AT 454 
                "% Red Compra Gov IBS UF":U      AT 475 
                "% Efetiva Compra Gov IBS UF":U  AT 500 
                "Valor Compra Gov IBS UF":U      AT 529 

                "Base Compra Gov IBS Mun":U      AT 588 
                "% Compra gov IBS Mun":U         AT 613
                "% Red Compra Gov IBS Mun":U     AT 635 
                "% Efetiva Compra Gov IBS Mun":U AT 661 
                "Valor Compra Gov IBS Mun":U     AT 691 

                "Base Compra Gov CBS":U          AT 752 
                "% Compra gov CBS":U             AT 773 
                "% Red Compra Gov CBS":U         AT 791 
                "% Efetiva Compra Gov CBS":U     AT 813 
                "Valor Compra Gov CBS":U         AT 839
                SKIP.
        END.
        IF l-nt2024002 THEN DO:
            PUT "----------------------" AT 430
                "-------------------" AT 454
                "-----------------------" AT 475
                "---------------------------" AT 500
                "-----------------------"         AT 529

                "-----------------------" AT 588
                "--------------------" AT 613
                "------------------------" AT 635
                "----------------------------" AT 661
                "------------------------"         AT 691

                "-------------------"         AT 752
                "----------------"            AT 773
                "--------------------"         AT 791
                "------------------------"    AT 813
                "--------------------"         AT 839
                SKIP.
        END.
    
        PUT "-----"                    AT 001
            "----------------"         AT 007
            "------------------------------------------------------------" AT 24
            "-----------------"        AT 085
            "------------------------" AT 103
            "-----------------------"  AT 128
            "------------------------" AT 152
            "-----------------"        AT 177
            "-------------------"      AT 195
            "-----------------"        AT 215
            "---------"                AT 233
            "---------"                AT 243
            "-------------------"      AT 253
            "---------"                AT 273 
            "--------"                 AT 283
            "-------------------"      AT 292
            "---------"                AT 312
            "--------"                 AT 322
            "-------------------"      AT 331
            "---------"                AT 351
            "--------"                 AT 361
            "-------------------"      AT 370
            "---------"                AT 390
            "---------"                AT 400
            "-------------------"      AT 410.
            
        IF l-nt2024002 THEN
            PUT "-----------------"        AT 430
                "--------"                 AT 448
                "-----------":U            AT 457
                "-------------------"      AT 469
                "-----------------"        AT 489
                "----------"               AT 507                
                "------------"             AT 518
                "-------------------"      AT 531
                "---------------------"    AT 551
                "--------------"           AT 573 

                "------------------"       AT 588
                "--------"                 AT 607
                "------------":U           AT 616
                "-------------------"      AT 629
                "------------------"       AT 649
                "-----------"              AT 668                
                "------------"             AT 680
                "-------------------"      AT 693
                "----------------------"   AT 713
                "---------------"          AT 736
                
                "--------------"           AT 752
                "------"                   AT 767
                "--------":U               AT 774
                "-------------------"      AT 783
                "--------------"           AT 803
                "-------"                  AT 818
                "--------"                 AT 826
                "------------------- "     AT 835                
                "-------------------"      AT 855
                "-----------"              AT 875
                
                "---------":U              AT 887
                "------":U                 AT 897
                "-----------":U            AT 904
                "------------":U           AT 916
                "------------":U           AT 929
                "---------":U              AT 942
                "------":U                 AT 952
                
                "------------"             AT 959
                "---------"                AT 972
                "------------"             AT 982
                "---------"                AT 995
                "------------------"       AT 1005.
        ELSE
            PUT "------------"             AT 426
                "---------"                AT 439
                "------------"             AT 449
                "---------"                AT 462
                "-------------------"      AT 472.

        ASSIGN i-seq-item              = 1
               v-qtd-adic              = 0
               v-val-vucv              = 0
               v-val-vmcv-me           = 0
               v-val-vmcv              = 0
               v-val-peso-brut-merc    = 0
               v-val-peso-liq          = 0
               v-val-peso-tot          = 0
               v-val-unit-ii           = 0
               v-val-unit-ipi          = 0
               v-val-unit-icms         = 0
               v-val-unit-pis          = 0
               v-val-unit-cofins       = 0
               v-de-taxa-siscomex      = 0
               de-tot-ibsuf            = 0
               de-tot-ibsmun           = 0
               de-tot-cbs              = 0
               de-tot-is               = 0
               de-tot-ibsuf-reg        = 0
               de-tot-ibsmun-reg       = 0
               de-tot-cbs-reg          = 0.

        /**** Config Tributos ****/
        RUN piDadosConfigTributos.
    END.

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = decla-import-adic-itens.cod-item: END.
    ASSIGN c-desc-item = IF AVAIL ITEM THEN ITEM.desc-item ELSE "".

    FIND FIRST ordem-compra NO-LOCK
         WHERE ordem-compra.numero-ordem = decla-import-ord.num-ordem NO-ERROR.

    FOR FIRST processo-imp FIELDS (nr-proc-imp num-pedido) NO-LOCK
        WHERE processo-imp.num-pedido = ordem-compra.num-pedido: END.

    FIND FIRST despes-adic-itens NO-LOCK
        WHERE despes-adic-itens.num-di-ems      = decla-import-adic-itens.num-di-ems
        AND   despes-adic-itens.num-adic        = decla-import-adic-itens.num-adic
        AND   despes-adic-itens.num-seq         = decla-import-adic-itens.num-seq
        AND   despes-adic-itens.cdn-emit-despes = param-imp.cdn-emit-siscomex
        &if "{&bf_mat_versao_ems}" >= "2.07" &then
            AND despes-adic-itens.cdn-despes    = param-imp.cdn-despes-siscomex
        &else
            AND despes-adic-itens.cdn-despes    = INT(SUBSTR(param-imp.char-1, 91,5))
        &ENDIF NO-ERROR.
    IF  AVAIL despes-adic-itens THEN DO:
        ASSIGN de-taxa-siscomex = despes-adic-itens.val-despes.

        IF  despes-adic-itens.cdn-moeda <> 0 THEN
            RUN converteValorMoeda (INPUT decla-import.num-di-ems,
                                    INPUT despes-adic-itens.cdn-moeda,
                                    INPUT 0,
                                    INPUT despes-adic-itens.val-despes,
                                    INPUT decla-import.dat-di,
                                    OUTPUT de-taxa-siscomex).
    END. /* FOR EACH  despes-adic-itens */  

    ASSIGN v-val-peso-liq = decla-import-adic-itens.val-peso-liq / decla-import-adic-itens.qtd-adic[2].

    /* Valor II */
    ASSIGN c-tipo-tributacao-ii = {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-impto-import}.
    
    IF decla-import-adic-itens.idi-tributac-impto-import = 1 OR /* Tributado*/
       decla-import-adic-itens.idi-tributac-impto-import = 4 THEN /* Reduzido */
        ASSIGN v-val-ii = decla-import-adic-itens.val-ii-db-cr.
    ELSE
        IF decla-import-adic-itens.idi-tributac-impto-import = 2 THEN /* Isento */
            ASSIGN v-val-ii = decla-import-adic-itens.val-ii-nao-tribut.
        ELSE
            IF decla-import-adic-itens.idi-tributac-impto-import = 3 THEN /* Outros */
                ASSIGN v-val-ii = decla-import-adic-itens.val-ii-outras.
    /* Fim valor II */

    /* Valor IPI */
    ASSIGN c-tipo-tributacao-ipi = {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-ipi}.
    
    IF decla-import-adic-itens.idi-tributac-ipi = 1 OR /* Tributado*/
       decla-import-adic-itens.idi-tributac-ipi = 4 THEN /* Reduzido */
        ASSIGN v-val-ipi = decla-import-adic-itens.val-ipi-db-cr.
    ELSE
        IF decla-import-adic-itens.idi-tributac-ipi = 2 THEN /* Isento */
            ASSIGN v-val-ipi = decla-import-adic-itens.val-ipi-nao-tribut.
        ELSE
            IF decla-import-adic-itens.idi-tributac-ipi = 3 THEN /* Outros */
                ASSIGN v-val-ipi = decla-import-adic-itens.val-ipi-outras.
    /* Fim valor IPI */

    /* Valor ICMS */
    ASSIGN c-tipo-tributacao-icms = {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-icms}.
    
    IF decla-import-adic-itens.idi-tributac-icms = 1 OR /* Tributado*/
       decla-import-adic-itens.idi-tributac-icms = 4 THEN /* Reduzido */
        ASSIGN v-val-icms = decla-import-adic-itens.val-icms-db-cr.
    ELSE
        IF decla-import-adic-itens.idi-tributac-icms = 2 THEN /* Isento */
            ASSIGN v-val-icms = decla-import-adic-itens.val-icms-nao-tribut.
        ELSE
            IF decla-import-adic-itens.idi-tributac-icms = 3 THEN /* Outros */
                ASSIGN v-val-icms = decla-import-adic-itens.val-icms-outras.
    /* Fim valor ICMS */

    /* Valor PIS */
    ASSIGN c-tipo-tributacao-pis = {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-pis}.
    
    IF decla-import-adic-itens.idi-tributac-pis = 1 OR /* Tributado*/
       decla-import-adic-itens.idi-tributac-pis = 4 THEN /* Reduzido */
        ASSIGN v-val-pis = decla-import-adic-itens.val-pis-db-cr.
    ELSE
        IF decla-import-adic-itens.idi-tributac-pis = 2 THEN /* Isento */
            ASSIGN v-val-pis = decla-import-adic-itens.val-pis-nao-tribut.
        ELSE
            IF decla-import-adic-itens.idi-tributac-pis = 3 THEN /* Outros */
                ASSIGN v-val-pis = decla-import-adic-itens.val-pis-outras.
    /* Fim valor PIS */

    /* Valor COFINS */
    ASSIGN c-tipo-tributacao-cofins = {cxinc/i01cx402.i 04 decla-import-adic-itens.idi-tributac-cofins}.
    
    IF decla-import-adic-itens.idi-tributac-cofins = 1 OR /* Tributado*/
       decla-import-adic-itens.idi-tributac-cofins = 4 THEN /* Reduzido */
        ASSIGN v-val-cofins = decla-import-adic-itens.val-cofins-db-cr.
    ELSE
        IF decla-import-adic-itens.idi-tributac-cofins = 2 THEN /* Isento */
            ASSIGN v-val-cofins = decla-import-adic-itens.val-cofins-nao-tribut.
        ELSE
            IF decla-import-adic-itens.idi-tributac-cofins = 3 THEN /* Outros */
                ASSIGN v-val-cofins = decla-import-adic-itens.val-cofins-outras.
    /* Fim valor COFIS */

    /* IBS UF  e CBS */
    IF l-nt2024002 THEN DO:
        ASSIGN c-trib-ibsuf            = ""
               de-aliq-ibsuf           = 0
               de-aliq-red-ibsuf       = 0
               de-val-ibsuf            = 0
               c-class-trib-ibsuf      = ""
               c-cst-ibsuf             = ""
               c-trib-ibsmun           = ""
               de-aliq-ibsmun          = 0
               de-aliq-red-ibsmun      = 0
               de-val-ibsmun           = 0
               c-class-trib-ibsmun     = ""
               c-cst-ibsmun            = ""               
               c-trib-cbs              = ""
               de-aliq-cbs             = 0
               de-aliq-red-cbs         = 0
               de-val-cbs              = 0
               c-class-trib-cbs        = ""
               c-cst-cbs               = ""
               c-trib-is               = ""
               de-aliq-is              = 0
               de-aliq-espec-is        = 0
               de-qtde-tribut-is       = 0
               de-val-is               = 0
               c-class-trib-is         = ""
               c-cst-is                = ""
               de-aliq-ibsuf-reg       = 0
               de-aliq-ibsmun-reg      = 0
               de-aliq-cbs-reg         = 0
               de-val-ibsuf-reg        = 0
               de-val-ibsmun-reg       = 0
               de-val-cbs-reg          = 0
               c-class-trib-ibsuf-reg  = ""
               c-class-trib-ibsmun-reg = ""
               c-class-trib-cbs-reg    = ""
               c-cst-ibsuf-reg         = ""
               c-cst-ibsmun-reg        = ""
               c-cst-cbs-reg           = ""
               de-base-gov-ibsuf          = 0
               de-aliq-gov-ibsuf          = 0
               de-perc-red-gov-ibsuf      = 0
               de-aliq-efetiva-gov-ibsuf  = 0
               de-val-gov-ibsuf           = 0
               de-base-gov-ibsmun          = 0
               de-aliq-gov-ibsmun          = 0
               de-perc-red-gov-ibsmun      = 0
               de-aliq-efetiva-gov-ibsmun  = 0
               de-val-gov-ibsmun           = 0
               de-base-gov-cbs          = 0
               de-aliq-gov-cbs          = 0
               de-perc-red-gov-cbs      = 0
               de-aliq-efetiva-gov-cbs  = 0
               de-val-gov-cbs           = 0.
               
        FOR EACH decla-imp-adic-it-trib NO-LOCK
           WHERE decla-imp-adic-it-trib.num-di-ems       = decla-import-adic-itens.num-di-ems
             AND decla-imp-adic-it-trib.num-adic         = decla-import-adic-itens.num-adic
             AND decla-imp-adic-it-trib.num-seq          = decla-import-adic-itens.num-seq
             AND decla-imp-adic-it-trib.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts:
            
            CASE decla-imp-adic-it-trib.nom-trib:
                WHEN "IBSUF":U THEN DO:
                    CASE decla-imp-adic-it-trib.cod-campo:
                        WHEN "COD-TRIB":U THEN
                            ASSIGN c-trib-ibsuf = {diinc/i01di628.i 04 INT(decla-imp-adic-it-trib.cod-conteudo)}.
                        WHEN "ALIQUOTA":U THEN
                            ASSIGN de-aliq-ibsuf = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "VALOR":U THEN
                            ASSIGN de-val-ibsuf = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "C-CLASS-TRIB":U THEN
                            ASSIGN c-class-trib-ibsuf = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "CST":U THEN
                            ASSIGN c-cst-ibsuf = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "ALIQ-EFETIVA-REG":U THEN
                            ASSIGN de-aliq-ibsuf-reg = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "VALOR-REG":U THEN
                            ASSIGN de-val-ibsuf-reg = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "C-CLASS-TRIB-REG":U THEN
                            ASSIGN c-class-trib-ibsuf-reg = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "CST-REG":U THEN
                            ASSIGN c-cst-ibsuf-reg = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "ALIQ-RED":U THEN
                            ASSIGN de-aliq-red-ibsuf = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "OUTROS":U THEN
                            ASSIGN de-val-ibsuf = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "BASE-GOV":U THEN
                            ASSIGN de-base-gov-ibsuf = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "ALIQ-GOV":U THEN
                            ASSIGN de-aliq-gov-ibsuf = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "PERC-RED-GOV":U THEN
                            ASSIGN de-perc-red-gov-ibsuf = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "ALIQ-EFETIVA-GOV":U THEN
                            ASSIGN de-aliq-efetiva-gov-ibsuf = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "VALOR-GOV":U THEN
                            ASSIGN de-val-gov-ibsuf = DEC(decla-imp-adic-it-trib.cod-conteudo).
                    END CASE.
                END.
                WHEN "IBSMUN":U THEN DO:
                    CASE decla-imp-adic-it-trib.cod-campo:
                        WHEN "COD-TRIB":U THEN
                            ASSIGN c-trib-ibsmun = {diinc/i01di628.i 04 INT(decla-imp-adic-it-trib.cod-conteudo)}.
                        WHEN "ALIQUOTA":U THEN
                            ASSIGN de-aliq-ibsmun = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "VALOR":U THEN
                            ASSIGN de-val-ibsmun = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "C-CLASS-TRIB":U THEN
                            ASSIGN c-class-trib-ibsmun = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "CST":U THEN
                            ASSIGN c-cst-ibsmun = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "ALIQ-EFETIVA-REG":U THEN
                            ASSIGN de-aliq-ibsmun-reg = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "VALOR-REG":U THEN
                            ASSIGN de-val-ibsmun-reg = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "C-CLASS-TRIB-REG":U THEN
                            ASSIGN c-class-trib-ibsmun-reg = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "CST-REG":U THEN
                            ASSIGN c-cst-ibsmun-reg = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "ALIQ-RED":U THEN
                            ASSIGN de-aliq-red-ibsmun = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "OUTROS":U THEN
                            ASSIGN de-val-ibsmun = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "BASE-GOV":U THEN
                            ASSIGN de-base-gov-ibsmun = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "ALIQ-GOV":U THEN
                            ASSIGN de-aliq-gov-ibsmun = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "PERC-RED-GOV":U THEN
                            ASSIGN de-perc-red-gov-ibsmun = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "ALIQ-EFETIVA-GOV":U THEN
                            ASSIGN de-aliq-efetiva-gov-ibsmun = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "VALOR-GOV":U THEN
                            ASSIGN de-val-gov-ibsmun = DEC(decla-imp-adic-it-trib.cod-conteudo).
                    END CASE.
                END.
                WHEN "CBS":U THEN DO:
                    CASE decla-imp-adic-it-trib.cod-campo:
                        WHEN "COD-TRIB":U THEN
                            ASSIGN c-trib-cbs = {diinc/i01di628.i 04 INT(decla-imp-adic-it-trib.cod-conteudo)}.
                        WHEN "ALIQUOTA":U THEN
                            ASSIGN de-aliq-cbs = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "VALOR":U THEN
                            ASSIGN de-val-cbs = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "C-CLASS-TRIB":U THEN
                            ASSIGN c-class-trib-cbs = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "CST":U THEN
                            ASSIGN c-cst-cbs = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "ALIQ-EFETIVA-REG":U THEN
                            ASSIGN de-aliq-cbs-reg = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "VALOR-REG":U THEN
                            ASSIGN de-val-cbs-reg = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "C-CLASS-TRIB-REG":U THEN
                            ASSIGN c-class-trib-cbs-reg = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "CST-REG":U THEN
                            ASSIGN c-cst-cbs-reg = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "ALIQ-RED":U THEN
                            ASSIGN de-aliq-red-cbs = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "OUTROS":U THEN
                            ASSIGN de-val-cbs = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "BASE-GOV":U THEN
                            ASSIGN de-base-gov-cbs = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "ALIQ-GOV":U THEN
                            ASSIGN de-aliq-gov-cbs = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "PERC-RED-GOV":U THEN
                            ASSIGN de-perc-red-gov-cbs = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "ALIQ-EFETIVA-GOV":U THEN
                            ASSIGN de-aliq-efetiva-gov-cbs = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "VALOR-GOV":U THEN
                            ASSIGN de-val-gov-cbs = DEC(decla-imp-adic-it-trib.cod-conteudo).
                    END CASE.
                END.
                WHEN "IS":U THEN DO:
                    CASE decla-imp-adic-it-trib.cod-campo:
                        WHEN "COD-TRIB":U THEN
                            ASSIGN c-trib-is = {diinc/i01di628.i 04 INT(decla-imp-adic-it-trib.cod-conteudo)}.
                        WHEN "ALIQUOTA":U THEN
                            ASSIGN de-aliq-is = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "VALOR":U THEN
                            ASSIGN de-val-is = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "C-CLASS-TRIB":U THEN
                            ASSIGN c-class-trib-is = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "CST":U THEN
                            ASSIGN c-cst-is = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "ALIQ-ESPEC-UN":U THEN
                            ASSIGN de-aliq-espec-is = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "QTDE-TRIBUT":U THEN
                            ASSIGN de-qtde-tribut-is = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "OUTROS":U THEN
                            ASSIGN de-val-is = DEC(decla-imp-adic-it-trib.cod-conteudo).
                    END CASE.
                END.
            END CASE.
        END.
    END.
    
    ASSIGN v-val-aliq-icm = decla-import-adic-itens.val-aliq-icms.

    IF tt-parametros.l-icms-diferido THEN
        ASSIGN v-val-aliq-icm = 0
               v-val-icms     = 0.

    PUT i-seq-item                                 AT 001
        decla-import-adic-itens.cod-item           AT 007
        c-desc-item                                AT 024
        decla-import-adic-itens.qtd-adic[2]        AT 090 FORMAT ">>>>>>>>9.99"
        decla-import-adic-itens.val-vucv           AT 103
        decla-import-adic-itens.val-vmcv-me[1]     AT 127
        decla-import-adic-itens.val-vmcv           AT 152
        decla-import-adic-itens.val-peso-brut-merc AT 177
        v-val-peso-liq-item                        AT 197 FORMAT ">>>>>>,>>9.99999"
        decla-import-adic-itens.val-peso-liq       AT 215
        c-tipo-tributacao-ii                       AT 233
        decla-import-adic-itens.val-aliq-ii        AT 244 FORMAT ">>9.9999"
        v-val-ii                                   AT 253
        c-tipo-tributacao-ipi                      AT 273
        decla-import-adic-itens.val-aliq-ipi       AT 285 FORMAT ">>9.99"
        v-val-ipi                                  AT 292
        c-tipo-tributacao-icms                     AT 312
        v-val-aliq-icm                             AT 324 FORMAT ">>9.99"
        v-val-icms                                 AT 331
        c-tipo-tributacao-pis                      AT 351
        decla-import-adic-itens.val-aliq-pis       AT 361 FORMAT ">>9.9999"
        v-val-pis                                  AT 370
        c-tipo-tributacao-cofins                   AT 390
        decla-import-adic-itens.val-aliq-cofins    AT 401 FORMAT ">>9.9999"
        v-val-cofins                               AT 410.
        
    IF l-nt2024002 THEN
        PUT c-trib-ibsuf                      AT 430
            de-aliq-ibsuf                     AT 450
            de-aliq-red-ibsuf                 AT 462
            de-val-ibsuf                      AT 469
            c-class-trib-ibsuf                AT 489
            c-cst-ibsuf                       AT 507            
            de-aliq-ibsuf-reg                 AT 524
            de-val-ibsuf-reg                  AT 531
            c-class-trib-ibsuf-reg            AT 551
            c-cst-ibsuf-reg                   AT 573

            c-trib-ibsmun                     AT 588
            de-aliq-ibsmun                    AT 609
            de-aliq-red-ibsmun                AT 622
            de-val-ibsmun                     AT 629
            c-class-trib-ibsmun               AT 649
            c-cst-ibsmun                      AT 668            
            de-aliq-ibsmun-reg                AT 686
            de-val-ibsmun-reg                 AT 693
            c-class-trib-ibsmun-reg           AT 713
            c-cst-ibsmun-reg                  AT 736
            
            c-trib-cbs                        AT 752
            de-aliq-cbs                       AT 767
            de-aliq-red-cbs                   AT 776            
            de-val-cbs                        AT 783
            c-class-trib-cbs                  AT 803
            c-cst-cbs                         AT 818            
            de-aliq-cbs-reg                   AT 828
            de-val-cbs-reg                    AT 835
            c-class-trib-cbs-reg              AT 855
            c-cst-cbs-reg                     AT 875
            
            c-trib-is                         AT 887
            de-aliq-is                        AT 897
            de-aliq-espec-is                  AT 905
            de-qtde-tribut-is                 AT 912
            de-val-is FORMAT ">>>>>>,>>9.99"  AT 928
            c-class-trib-is                   AT 942
            c-cst-is                          AT 952
            
            processo-imp.nr-proc-imp          AT 959
            processo-imp.num-pedido           AT 971
            ordem-compra.numero-ordem         AT 984
            decla-import-adic-itens.num-adic  AT 994 FORMAT ">>>>>>>>9"
            de-taxa-siscomex                  AT 1004.
    ELSE
        PUT processo-imp.nr-proc-imp          AT 430
            processo-imp.num-pedido           AT 443
            ordem-compra.numero-ordem         AT 453
            decla-import-adic-itens.num-adic  AT 466 FORMAT ">>>>>>>>9"
            de-taxa-siscomex                  AT 476.

    IF l-nt2024002 THEN DO:
        PUT SKIP
            de-base-gov-ibsuf                 AT 430
            de-aliq-gov-ibsuf                 AT 454
            de-perc-red-gov-ibsuf             AT 475
            de-aliq-efetiva-gov-ibsuf         AT 500
            de-val-gov-ibsuf                  AT 529

            de-base-gov-ibsmun                AT 588 
            de-aliq-gov-ibsmun                AT 613 
            de-perc-red-gov-ibsmun            AT 635 
            de-aliq-efetiva-gov-ibsmun        AT 661 
            de-val-gov-ibsmun                 AT 691 

            de-base-gov-cbs                   AT 752 
            de-aliq-gov-cbs                   AT 773 
            de-perc-red-gov-cbs               AT 791 
            de-aliq-efetiva-gov-cbs           AT 813 
            de-val-gov-cbs                    AT 839
            SKIP.
    END.
    
    IF CAN-FIND(FIRST despes-adic-itens
                WHERE despes-adic-itens.num-di-ems      = decla-import-adic-itens.num-di-ems
                AND   despes-adic-itens.num-adic        = decla-import-adic-itens.num-adic
                AND   despes-adic-itens.num-seq         = decla-import-adic-itens.num-seq) THEN DO:
		/* Busca despesas da DI conforme gera‡ao da item-doc-est-cex (IM1001B) */
        FOR EACH item-doc-est NO-LOCK
            WHERE item-doc-est.serie-docto = tt-embarqueDI.serie-docto  
             AND item-doc-est.nro-docto    = tt-embarqueDI.nro-docto    
             AND item-doc-est.cod-emitente = tt-embarqueDI.cod-emitente 
             AND item-doc-est.nat-operacao = tt-embarqueDI.nat-operacao
             AND item-doc-est.it-codigo    = decla-import-adic-itens.cod-item
             AND item-doc-est.numero-ordem = decla-import-adic-itens.num-ordem,
            EACH item-doc-est-cex NO-LOCK
            WHERE item-doc-est-cex.serie-docto  = item-doc-est.serie-docto  AND 
                  item-doc-est-cex.nro-docto    = item-doc-est.nro-docto    AND
                  item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente AND  
                  item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao AND
                  item-doc-est-cex.sequencia    = item-doc-est.sequencia
            BREAK BY item-doc-est-cex.sequencia:

            ASSIGN c-nome-abrev-desp = ""
                   c-descricao-desp  = "". 

            FOR FIRST emitente
                WHERE emitente.cod-emitente = item-doc-est-cex.cod-emitente-desp NO-LOCK:
                ASSIGN c-nome-abrev-desp = emitente.nome-abrev.
            END.
            FOR FIRST desp-imp
                WHERE desp-imp.cod-desp = item-doc-est-cex.cod-desp NO-LOCK:
                ASSIGN c-descricao-desp = desp-imp.descricao.
            END.
			
            IF FIRST-OF(item-doc-est-cex.sequencia) THEN DO:

                PUT SKIP(2)
                    c-lbl-liter-titulo-desp                 AT 024 FORMAT "X(40)"
                    SKIP                                              
                    c-lbl-liter-forn-desp                   AT 024 FORMAT "X(09)"
                    c-lbl-liter-nome-abrev                  AT 034 FORMAT "X(12)"
                    c-lbl-liter-despesa                     AT 047 FORMAT "X(07)"
                    c-lbl-liter-despesa-desc                AT 055 FORMAT "X(30)"
                    c-lbl-liter-valor-despesa               AT 086 FORMAT "X(20)"
                    SKIP
                    "---------"                             AT 024
                    "------------"                          AT 034
                    "-------"                               AT 047
                    "------------------------------"        AT 055
                    "-------------------"                   AT 086
                    SKIP.

                ASSIGN v-total-val-desp = 0.
            END.
			
            ASSIGN v-total-val-desp = item-doc-est-cex.val-desp + v-total-val-desp.
            
            PUT SKIP
                item-doc-est-cex.cod-emitente-desp      AT 024
                c-nome-abrev-desp                       AT 034
                item-doc-est-cex.cod-desp               AT 048
                c-descricao-desp                        AT 055
                item-doc-est-cex.val-desp               AT 086 FORMAT ">>>>>,>>>,>>9.99999"
                SKIP.

            IF LAST-OF(item-doc-est-cex.sequencia) THEN DO:

                PUT SKIP
                    "-------------------"               AT 086
                    SKIP
                    c-lbl-liter-total-desp              AT 070 FORMAT "X(15)" 
                    v-total-val-desp                    AT 086 FORMAT ">>>>>,>>>,>>9.99999"
                    SKIP(2).
            END.
        END.
    END.

    ASSIGN i-seq-item           = i-seq-item           + 1
           v-qtd-adic           = v-qtd-adic           + decla-import-adic-itens.qtd-adic[2]
           v-val-vucv           = v-val-vucv           + decla-import-adic-itens.val-vucv
           v-val-vmcv-me        = v-val-vmcv-me        + decla-import-adic-itens.val-vmcv-me[1]
           v-val-vmcv           = v-val-vmcv           + decla-import-adic-itens.val-vmcv
           v-val-peso-brut-merc = v-val-peso-brut-merc + decla-import-adic-itens.val-peso-brut-merc
           v-val-peso-liq       = v-val-peso-liq       + v-val-peso-liq-item
           v-val-peso-tot       = v-val-peso-tot       + decla-import-adic-itens.val-peso-liq
           v-val-unit-ii        = v-val-unit-ii        + v-val-ii
           v-val-unit-ipi       = v-val-unit-ipi       + v-val-ipi
           v-val-unit-icms      = v-val-unit-icms      + v-val-icms
           v-val-unit-pis       = v-val-unit-pis       + v-val-pis
           v-val-unit-cofins    = v-val-unit-cofins    + v-val-cofins
           v-de-taxa-siscomex   = v-de-taxa-siscomex   + de-taxa-siscomex
           de-tot-ibsuf         = de-tot-ibsuf         + de-val-ibsuf
           de-tot-ibsmun        = de-tot-ibsmun        + de-val-ibsmun
           de-tot-cbs           = de-tot-cbs           + de-val-cbs
           de-tot-is            = de-tot-is            + de-val-is
           de-tot-ibsuf-reg     = de-tot-ibsuf-reg     + de-val-ibsuf-reg
           de-tot-ibsmun-reg    = de-tot-ibsmun-reg    + de-val-ibsmun-reg
           de-tot-cbs-reg       = de-tot-cbs-reg       + de-val-cbs-reg.

    IF LAST-OF(decla-import-embarq.cod-embarq) THEN DO:

        PUT SKIP(2)
            "-----------------"        AT 085
            "------------------------" AT 103
            "-----------------------"  AT 128
            "------------------------" AT 152
            "-----------------"        AT 177
            "-------------------"      AT 195
            "-----------------"        AT 215
            "-------------------"      AT 253
            "-------------------"      AT 292
            "-------------------"      AT 331
            "-------------------"      AT 368
            "-------------------"      AT 406.
            
        IF l-nt2024002 THEN
            PUT "-------------------"  AT 469
                "-------------------"  AT 531
                "-------------------"  AT 629
                "-------------------"  AT 693
                "-------------------"  AT 783
                "-------------------"  AT 835
                "-------------"        AT 928
                "-------------------"  AT 1004 SKIP.
        ELSE
            PUT "-------------------"  AT 472 SKIP.

        /* Inicio -- Projeto Internacional */
        PUT c-lbl-liter-total-embarque FORMAT "X(14)" AT 068
            v-qtd-adic           AT 085
            v-val-vucv           AT 108
            v-val-vmcv-me        AT 132
            v-val-vmcv           AT 157
            v-val-peso-brut-merc AT 179 FORMAT ">>>>>>>>9.99999"
            v-val-peso-liq       AT 199 FORMAT ">>>>>>>>9.99999"
            v-val-peso-tot       AT 217 FORMAT ">>>>>>>>9.99999"
            v-val-unit-ii        AT 253
            v-val-unit-ipi       AT 292
            v-val-unit-icms      AT 331
            v-val-unit-pis       AT 368
            v-val-unit-cofins    AT 406.
        
        IF l-nt2024002 THEN
            PUT de-tot-ibsuf         AT 469
                de-tot-ibsuf-reg     AT 531
                de-tot-ibsmun        AT 629
                de-tot-ibsmun-reg    AT 693
                de-tot-cbs           AT 783
                de-tot-cbs-reg       AT 835
                de-tot-is            AT 928
                v-de-taxa-siscomex   AT 1007.
        ELSE
            PUT v-de-taxa-siscomex   AT 475.

        ASSIGN v-qtd-adic-di           = v-qtd-adic-di           + v-qtd-adic
               v-val-vucv-di           = v-val-vucv-di           + v-val-vucv
               v-val-vmcv-me-di        = v-val-vmcv-me-di        + v-val-vmcv-me
               v-val-vmcv-di           = v-val-vmcv-di           + v-val-vmcv
               v-val-peso-brut-merc-di = v-val-peso-brut-merc-di + v-val-peso-brut-merc
               v-val-peso-liq-di       = v-val-peso-liq-di       + v-val-peso-liq
               v-val-peso-tot-di       = v-val-peso-tot-di       + v-val-peso-tot
               v-val-unit-ii-di        = v-val-unit-ii-di        + v-val-unit-ii
               v-val-unit-ipi-di       = v-val-unit-ipi-di       + v-val-unit-ipi
               v-val-unit-icms-di      = v-val-unit-icms-di      + v-val-unit-icms
               v-val-unit-pis-di       = v-val-unit-pis-di       + v-val-unit-pis
               v-val-unit-cofins-di    = v-val-unit-cofins-di    + v-val-unit-cofins
               v-de-taxa-siscomex-di   = v-de-taxa-siscomex-di   + v-de-taxa-siscomex
               de-tot-ibsuf-di         = de-tot-ibsuf-di         + de-tot-ibsuf
               de-tot-ibsmun-di        = de-tot-ibsmun-di        + de-tot-ibsmun
               de-tot-cbs-di           = de-tot-cbs-di           + de-tot-cbs
               de-tot-is-di            = de-tot-is-di            + de-tot-is.

    END.
END.

PUT SKIP(3)
    "-----------------"        AT 085
    "------------------------" AT 103
    "-----------------------"  AT 128
    "------------------------" AT 152
    "-----------------"        AT 177 
    "-------------------"      AT 195 
    "-----------------"        AT 215 
    "-------------------"      AT 253
    "-------------------"      AT 292
    "-------------------"      AT 331
    "-------------------"      AT 368
    "-------------------"      AT 406.
    
IF l-nt2024002 THEN
    PUT "-------------------"  AT 469
        "-------------------"  AT 531
        "-------------------"  AT 629
        "-------------------"  AT 693
        "-------------------"  AT 783
        "-------------------"  AT 835
        "-------------"        AT 928
        "-------------------"  AT 1004 SKIP.
ELSE
    PUT "-------------------"  AT 472 SKIP.

/* Inicio -- Projeto Internacional */
PUT c-lbl-liter-total-di FORMAT "X(14)" AT 068
    v-qtd-adic-di           AT 085
    v-val-vucv-di           AT 108
    v-val-vmcv-me-di        AT 132    
    v-val-vmcv-di           AT 157
    v-val-peso-brut-merc-di AT 179 FORMAT ">>>>>>>>9.99999"
    v-val-peso-liq-di       AT 199 FORMAT ">>>>>>>>9.99999"
    v-val-peso-tot-di       AT 217 FORMAT ">>>>>>>>9.99999"
    v-val-unit-ii-di        AT 253
    v-val-unit-ipi-di       AT 292
    v-val-unit-icms-di      AT 331
    v-val-unit-pis-di       AT 368
    v-val-unit-cofins-di    AT 406.

IF l-nt2024002 THEN
    PUT de-tot-ibsuf-di        AT 469
        de-tot-ibsuf-reg       AT 531
        de-tot-ibsmun-di       AT 629
        de-tot-ibsmun-reg      AT 693
        de-tot-cbs-di          AT 783
        de-tot-cbs-reg         AT 835
        de-tot-is-di           AT 928
        v-de-taxa-siscomex-di  AT 1004.
ELSE
    PUT v-de-taxa-siscomex-di  AT 472.

/**** Config Tributos ****/
RUN piListaConfigTributos.

PAGE.

{include/i-rpclo.i}

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

PROCEDURE piDadosConfigTributos:
    DEFINE VARIABLE c-cod-formul-trib      AS CHAR NO-UNDO.
    DEFINE VARIABLE c-cod-formul-base-calc AS CHAR NO-UNDO.

    FOR EACH ct-trib-item-doc-est NO-LOCK
        WHERE ct-trib-item-doc-est.cod-embarq  = decla-import-embarq.cod-embarq
        AND   ct-trib-item-doc-est.cod-docto   = decla-import-embarq.cod-embarq
        AND   ct-trib-item-doc-est.cod-estab   = decla-import-embarq.cod-estab:

        IF NOT CAN-FIND(FIRST tt-ct-trib-item-doc-est
                        WHERE tt-ct-trib-item-doc-est.cdn-emitente      = ct-trib-item-doc-est.cdn-emitente     
                        AND   tt-ct-trib-item-doc-est.cod-ser-docto     = ct-trib-item-doc-est.cod-ser-docto    
                        AND   tt-ct-trib-item-doc-est.cod-docto         = ct-trib-item-doc-est.cod-docto        
                        AND   tt-ct-trib-item-doc-est.cod-natur-operac  = ct-trib-item-doc-est.cod-natur-operac 
                        AND   tt-ct-trib-item-doc-est.num-seq           = ct-trib-item-doc-est.num-seq          
                        AND   tt-ct-trib-item-doc-est.cod-item          = ct-trib-item-doc-est.cod-item         
                        AND   tt-ct-trib-item-doc-est.num-ct-trib       = ct-trib-item-doc-est.num-ct-trib      
                        AND   tt-ct-trib-item-doc-est.cod-tip-trib      = ct-trib-item-doc-est.cod-tip-trib     
                        AND   tt-ct-trib-item-doc-est.cod-configur-trib = ct-trib-item-doc-est.cod-configur-trib) THEN DO:
            
            CREATE tt-ct-trib-item-doc-est.
            BUFFER-COPY ct-trib-item-doc-est TO tt-ct-trib-item-doc-est.

            ASSIGN c-cod-formul-trib = ""
                   c-cod-formul-base-calc = "".
            FOR FIRST ct-configur-trib NO-LOCK
                WHERE ct-configur-trib.cod-configur-trib = ct-trib-item-doc-est.cod-configur-trib:

                FOR FIRST ct-formul NO-LOCK
                    WHERE ct-formul.cod-formul = ct-configur-trib.cod-formul-base-calc:
                    ASSIGN c-cod-formul-base-calc = ct-formul.des-compos-formul.
                END.

                FOR FIRST ct-formul NO-LOCK
                    WHERE ct-formul.cod-formul = ct-configur-trib.cod-formul-trib:
                    ASSIGN c-cod-formul-trib = ct-formul.des-compos-formul.
                END.
            END.
            
            ASSIGN tt-ct-trib-item-doc-est.cod-formul-trib      = c-cod-formul-trib
                   tt-ct-trib-item-doc-est.cod-formul-base-calc = c-cod-formul-base-calc
                   tt-ct-trib-item-doc-est.cod-tributac         = SUBSTRING({diinc/i01di628.i 04 INT(ct-trib-item-doc-est.idi-cod-tributac)},1,1).
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piListaConfigTributos:
    DEFINE VARIABLE c-cod-formul-trib      AS CHAR NO-UNDO.
    DEFINE VARIABLE c-cod-formul-base-calc AS CHAR NO-UNDO.

    IF  CAN-FIND(FIRST tt-ct-trib-item-doc-est) THEN DO:
        PUT SKIP (2) 
            c-lbl-liter-config-trib FORMAT "X(25)" AT 01.

        /* Inicio -- Projeto Internacional */
        PUT SKIP (1)             
            c-lbl-liter-cf-emit               FORMAT "X(08)" AT 2
            c-lbl-liter-cf-serie              FORMAT "X(05)" AT 11
            c-lbl-liter-cf-embarque           FORMAT "X(08)" AT 17
            c-lbl-liter-cf-nat-oper           FORMAT "X(08)" AT 34
            c-lbl-liter-cf-seq                FORMAT "X(03)" AT 48
            c-lbl-liter-cf-item               FORMAT "X(04)" AT 52
            c-lbl-liter-cf-tp-trib            FORMAT "X(12)" AT 69
            c-lbl-liter-cf-conf-trib          FORMAT "X(20)" AT 85
            c-lbl-liter-cf-aliq               FORMAT "X(04)" AT 151
            c-lbl-liter-cf-base-calc-trib     FORMAT "X(17)" AT 159
            c-lbl-liter-cf-val-trib           FORMAT "X(11)" AT 186
            c-lbl-liter-cf-cod-trib           FORMAT "X(14)" AT 198
            c-lbl-liter-cf-perc-red           FORMAT "X(12)" AT 215
            c-lbl-liter-cf-qtd-vlr-fixo       FORMAT "X(19)" AT 232
            c-lbl-liter-cf-vlr-fixo           FORMAT "X(10)" AT 262
            c-lbl-liter-cf-sit-trib           FORMAT "X(16)" AT 273
            c-lbl-liter-cf-cod-form-bc        FORMAT "X(21)" AT 297
            c-lbl-liter-cf-chave-cenar        FORMAT "X(13)" AT 358
            c-lbl-liter-cf-form-calc-trib     FORMAT "X(20)" AT 439
            c-lbl-liter-cf-mem-calc-form-trib FORMAT "X(31)" AT 510
            c-lbl-liter-cf-form-bc-trib       FORMAT "X(25)" AT 581
            c-lbl-liter-cf-mem-bc-trib        FORMAT "X(33)" AT 662
            SKIP.

        PUT "---------" AT 1
            "-----" AT 11
            "----------------" AT 17
            "--------" AT 34
            "--------" AT 43
            "----------------" AT 52
            "---------------" AT 69
            "------------------------------------------------------------" AT 85
            "---------" AT 146
            "--------------------" AT 156
            "--------------------" AT 177
            "---------------" AT 198
            "-------------" AT 214
            "-----------------------" AT 228
            "--------------------" AT 252
            "-----------------------" AT 273
            "------------------------------------------------------------" AT 297
            "--------------------------------------------------------------------------------" AT 358
            "----------------------------------------------------------------------" AT 439
            "----------------------------------------------------------------------" AT 510
            "--------------------------------------------------------------------------------" AT 581
            "----------------------------------------------------------------------" AT 662
            SKIP.
    END.
    
    FOR EACH tt-ct-trib-item-doc-est NO-LOCK:
        PUT tt-ct-trib-item-doc-est.cdn-emitente          AT 1   /* Emitente */
            tt-ct-trib-item-doc-est.cod-ser-docto         AT 11  /* S‚rie */
            tt-ct-trib-item-doc-est.cod-docto             AT 17  /* Nota Fiscal */
            tt-ct-trib-item-doc-est.cod-natur-operac      AT 34  /* Nat Oper */
            tt-ct-trib-item-doc-est.num-seq               AT 46  /* Seq */
            tt-ct-trib-item-doc-est.cod-item              AT 52  /* Item */
            tt-ct-trib-item-doc-est.cod-tip-trib          AT 69  /* Tipo Tributo */
            tt-ct-trib-item-doc-est.cod-configur-trib     AT 85  FORMAT "x(60)" /* Configura‡Æo Tributo */
            tt-ct-trib-item-doc-est.val-aliq              AT 146 /* Aliq */
            tt-ct-trib-item-doc-est.val-base              AT 158 /* Base Calc. Tributo */
            tt-ct-trib-item-doc-est.val-trib              AT 179 /* Val Tributo */
            tt-ct-trib-item-doc-est.cod-tributac          AT 198 /* Cod Tributa‡Æo */
            tt-ct-trib-item-doc-est.val-perc-reduc        AT 217 /* Perc Redu‡Æo */
            tt-ct-trib-item-doc-est.val-quant-fix         AT 234 /* Quant de Valor Fixo */
            tt-ct-trib-item-doc-est.val-fix-trib          AT 252 /* Valor Fixo */
            tt-ct-trib-item-doc-est.cod-sit-tributar      AT 273 FORMAT "x(23)" /* Situa‡Æo Tributo */
            tt-ct-trib-item-doc-est.cod-formul-base-calc  AT 297 FORMAT "x(60)" /* Cod Formula Base Calc */
            tt-ct-trib-item-doc-est.cod-chave-cenar       AT 358 FORMAT "x(80)" /* Chave Cen rio */
            tt-ct-trib-item-doc-est.cod-formul-trib       AT 439 FORMAT "x(70)" /* F¢rmula Calc Tributo */
            tt-ct-trib-item-doc-est.cod-memo-calc-trib    AT 510 FORMAT "x(70)" /* Mem¢ria C lculo F¢rmula Tributo */
            tt-ct-trib-item-doc-est.cod-formul-base-calc  AT 581 FORMAT "x(80)" /* F¢rmula Calc Base Calc Tributo */
            tt-ct-trib-item-doc-est.cod-memo-calc-base    AT 662 FORMAT "x(70)" /* Mem¢ria C lculo F¢rmula Base Calc Tributo */
            SKIP.
    END.

    RETURN "OK":U.
END PROCEDURE.


