/********************************************************************************
** Copyright TOTVS S.A.
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
USING rep.imp.*.

{include/i-prgvrs.i IM0100BRP 2.00.00.024 } /*** "010024" 13/08/2026 11:34:42 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0100brp MIM}
&ENDIF
 
{imp/im0100x.i tt-parametros}
/*****************************************************************************
*
*  IM0100BRP.P - Relat¢rio de conferància do embarque importaá∆o (planilha)
*
*  Objetivo: Conferància do embarque importaá∆o em planilha
*
******************************************************************************/
DEFINE INPUT PARAMETER TABLE FOR tt-parametros.
DEFINE INPUT PARAMETER TABLE FOR tt-embarque-filho.

{utp/utapi013.i}
{include/i-epc200.i IM0100BRP}
{cxbo/bocx225e.i1} /* vari†veis atributo livre ordens-embarque */
{cxbo/bocx310.i tt-desp-embarque}
DEFINE TEMP-TABLE tt-docum-est NO-UNDO LIKE docum-est.
DEFINE TEMP-TABLE tt-desp-nacion NO-UNDO
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

DEFINE VARIABLE c-arquivo-planilha       AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-hora-arquivo           AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-embarque-arquivo       AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE i-num-arquivo            AS INTEGER   INIT 1                      NO-UNDO.
DEFINE VARIABLE i-planilha-nota          AS INTEGER   INIT 1                      NO-UNDO.
DEFINE VARIABLE i-planilha-despesa       AS INTEGER   INIT 2                      NO-UNDO.
DEFINE VARIABLE i-planilha-itens         AS INTEGER   INIT 3                      NO-UNDO.
DEFINE VARIABLE i-planilha-desp-itens    AS INTEGER   INIT 4                      NO-UNDO.
DEFINE VARIABLE i-planilha-config        AS INTEGER   INIT 5                      NO-UNDO.
DEFINE VARIABLE i-linha-cabecalho        AS INTEGER   INIT 1                      NO-UNDO.
DEFINE VARIABLE i-linha-despesa          AS INTEGER   INIT 1                      NO-UNDO.
DEFINE VARIABLE i-linha-item             AS INTEGER   INIT 1                      NO-UNDO.
DEFINE VARIABLE i-linha-desp-item        AS INTEGER   INIT 1                      NO-UNDO.
DEFINE VARIABLE i-linha-config           AS INTEGER   INIT 1                      NO-UNDO.
DEFINE VARIABLE i-coluna-nota            AS INTEGER   INIT 0                      NO-UNDO.
DEFINE VARIABLE i-coluna-despesa         AS INTEGER   INIT 0                      NO-UNDO.
DEFINE VARIABLE i-coluna-item            AS INTEGER   INIT 0                      NO-UNDO.
DEFINE VARIABLE i-coluna-desp-item       AS INTEGER   INIT 0                      NO-UNDO.
DEFINE VARIABLE i-coluna-config          AS INTEGER   INIT 0                      NO-UNDO.
DEFINE VARIABLE c-formato-char           AS CHARACTER INIT "@"                    NO-UNDO.
DEFINE VARIABLE i-mo-codigo              LIKE moeda.mo-codigo                     NO-UNDO.
DEFINE VARIABLE c-desc-moeda             LIKE moeda.descricao                     NO-UNDO.
DEFINE VARIABLE c-desc-emitente          LIKE emitente.nome-emit                  NO-UNDO.
DEFINE VARIABLE c-desc-class-fisc        LIKE classif-fisc.descricao              NO-UNDO.
DEFINE VARIABLE c-desc-item              LIKE ITEM.desc-item                      NO-UNDO.
DEFINE VARIABLE de-cotacao-dia-nota      AS DECIMAL FORMAT ">>>,>9.99999999"      NO-UNDO.
DEFINE VARIABLE de-cotacao-despesa       AS DECIMAL FORMAT ">>>,>9.99999999"      NO-UNDO.
DEFINE VARIABLE c-desc-natur             LIKE natur-oper.denominacao              NO-UNDO.
DEFINE VARIABLE i-desp-ii                LIKE desp-imp.cod-desp                   NO-UNDO.
DEFINE VARIABLE l-gera-prim-remessa      AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE i-numero-ordem           LIKE ordem-compra.numero-ordem           NO-UNDO.
DEFINE VARIABLE i-parcela                LIKE ordens-embarque.parcela             NO-UNDO.
DEFINE VARIABLE de-preco-total-me        AS DECIMAL FORMAT ">>>,>>>,>>9.9999"     NO-UNDO.
DEFINE VARIABLE de-preco-unit-mo         LIKE cotacao-item.preco-unit             NO-UNDO.
DEFINE VARIABLE de-peso-bruto            AS DECIMAL FORMAT ">>>>>,>>9.99999"      NO-UNDO.
DEFINE VARIABLE de-peso-liq-unit         AS DEC FORMAT ">>>>,>>9.9999999999"      NO-UNDO.
DEFINE VARIABLE de-preco-unit-sem-ipi    LIKE ordem-compra.preco-unit             NO-UNDO.
DEFINE VARIABLE i-num-adicao             AS INTEGER  FORMAT ">>>9"                NO-UNDO.
DEFINE VARIABLE de-taxa-siscomex         AS DECIMAL  FORMAT ">>>>>,>>>,>>9.99999" NO-UNDO.
DEFINE VARIABLE l-gravado                AS LOGICAL INITIAL NO                    NO-UNDO.
DEFINE VARIABLE c-trib-ii                AS CHARACTER FORMAT "x(01)"              NO-UNDO.
DEFINE VARIABLE c-trib-icm               AS CHARACTER FORMAT "x(01)"              NO-UNDO.
DEFINE VARIABLE c-trib-ipi               AS CHARACTER FORMAT "x(01)"              NO-UNDO.
DEFINE VARIABLE c-trib-pis               AS CHARACTER FORMAT "x(01)"              NO-UNDO.
DEFINE VARIABLE c-trib-cofins            AS CHARACTER FORMAT "x(01)"              NO-UNDO.
DEFINE VARIABLE de-val-desp-ii           LIKE item-doc-est-cex.val-desp           NO-UNDO.
DEFINE VARIABLE de-aliq-pis              AS DECIMAL FORMAT ">>9.9999"             NO-UNDO.
DEFINE VARIABLE de-val-pis               LIKE item-doc-est.valor-ipi[1]           NO-UNDO.
DEFINE VARIABLE de-aliq-cofins           AS DECIMAL FORMAT ">>9.9999"             NO-UNDO.
DEFINE VARIABLE de-val-cofins            LIKE item-doc-est.valor-ipi[1]           NO-UNDO.
DEFINE VARIABLE de-preco-tot-geral-me    AS DECIMAL FORMAT ">>>,>>>,>>9.9999"     NO-UNDO.
DEFINE VARIABLE de-preco-tot-geral-mn    LIKE item-doc-est.preco-total[1]         NO-UNDO.
DEFINE VARIABLE de-peso-bruto-tot-geral  AS DECIMAL FORMAT ">>>>>,>>9.99999"      NO-UNDO.
DEFINE VARIABLE de-peso-liq-tot-geral    AS DECIMAL FORMAT ">>>>>,>>9.99999"      NO-UNDO.
DEFINE VARIABLE de-base-ii               LIKE item-docto-estoq-nfe-imp.val-base   NO-UNDO.
DEFINE VARIABLE de-base-ii-tot-geral     LIKE item-docto-estoq-nfe-imp.val-base   NO-UNDO.
DEFINE VARIABLE de-base-ipi-trib-geral   LIKE item-doc-est.base-ipi[1]            NO-UNDO.
DEFINE VARIABLE de-base-ipi-out-geral    LIKE item-doc-est.ipi-outras[1]          NO-UNDO.
DEFINE VARIABLE de-base-ipi-isen-geral   LIKE item-doc-est.ipi-ntrib[1]           NO-UNDO.
DEFINE VARIABLE de-base-icm-trib-geral   LIKE item-doc-est.base-icm[1]            NO-UNDO.
DEFINE VARIABLE de-base-icm-out-geral    LIKE item-doc-est.icm-outras[1]          NO-UNDO.
DEFINE VARIABLE de-base-icm-isen-geral   LIKE item-doc-est.icm-ntrib[1]           NO-UNDO.
DEFINE VARIABLE de-base-pis-tot-geral    LIKE item-doc-est.base-ipi[1]            NO-UNDO.
DEFINE VARIABLE de-base-cofins-tot-geral LIKE item-doc-est.base-ipi[1]            NO-UNDO.
DEFINE VARIABLE de-val-desp-ii-tot-geral LIKE desp-embarque.val-desp              NO-UNDO.
DEFINE VARIABLE de-val-ipi-tot-geral     LIKE item-doc-est.valor-ipi[1]           NO-UNDO.
DEFINE VARIABLE de-val-icm-tot-geral     LIKE item-doc-est.valor-icm[1]           NO-UNDO.
DEFINE VARIABLE de-val-pis-tot-geral     LIKE item-doc-est.valor-ipi[1]           NO-UNDO.
DEFINE VARIABLE de-val-cofins-tot-geral  LIKE item-doc-est.valor-ipi[1]           NO-UNDO.
DEFINE VARIABLE de-tot-tx-siscomex       AS DECIMAL  FORMAT ">>>>>,>>>,>>9.99999" NO-UNDO.
DEFINE VARIABLE i-cod-itiner             LIKE itinerario.cod-itiner               NO-UNDO.
DEFINE VARIABLE i-seq-nacionalizacao     LIKE historico-embarque.sequencia        NO-UNDO.
DEFINE VARIABLE i-cod-desp-ii            AS INTEGER INITIAL 23                    NO-UNDO.
DEFINE VARIABLE c-tipo                   AS CHARACTER FORMAT "x(20)"              NO-UNDO.
DEFINE VARIABLE l-inc-ii                 AS LOGICAL FORMAT "Sim/Nao"              NO-UNDO.
DEFINE VARIABLE l-inc-ipi                AS LOGICAL FORMAT "Sim/Nao"              NO-UNDO.
DEFINE VARIABLE l-inc-icms               AS LOGICAL FORMAT "Sim/Nao"              NO-UNDO.
DEFINE VARIABLE l-val-duplic             AS LOGICAL FORMAT "Sim/Nao"              NO-UNDO.
DEFINE VARIABLE l-pis-valor              AS LOGICAL FORMAT "Sim/Nao"              NO-UNDO.
DEFINE VARIABLE l-pis-despesa            AS LOGICAL FORMAT "Sim/Nao"              NO-UNDO.
DEFINE VARIABLE l-cofins-valor           AS LOGICAL FORMAT "Sim/Nao"              NO-UNDO.
DEFINE VARIABLE l-cofins-despesa         AS LOGICAL FORMAT "Sim/Nao"              NO-UNDO.
DEFINE VARIABLE de-val-tot-desp          LIKE desp-embarque.val-desp              NO-UNDO.
DEFINE VARIABLE de-val-tot-desp-item     LIKE desp-embarque.val-desp              NO-UNDO.
DEFINE VARIABLE c-sim                    AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-nao                    AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-cod-formul-trib        LIKE ct-configur-trib.cod-formul-trib    NO-UNDO.
DEFINE VARIABLE c-cod-formul-base-calc   LIKE ct-configur-trib.cod-formul-base-calc NO-UNDO.
DEFINE VARIABLE h-cdapi995               AS HANDLE                                  NO-UNDO.

DEFINE VARIABLE c-trib-ibsuf             AS CHARACTER FORMAT "x(01)"              NO-UNDO.
DEFINE VARIABLE c-trib-ibsmun            AS CHARACTER FORMAT "x(01)"              NO-UNDO.
DEFINE VARIABLE c-trib-cbs               AS CHARACTER FORMAT "x(01)"              NO-UNDO.
DEFINE VARIABLE c-trib-is                AS CHARACTER FORMAT "x(01)"              NO-UNDO.
DEFINE VARIABLE c-un-tribut-is           AS CHARACTER FORMAT "x(02)"              NO-UNDO.
DEFINE VARIABLE de-aliq-ibsuf            LIKE item-doc-est.aliquota-ipi           NO-UNDO.
DEFINE VARIABLE de-aliq-ibsmun           LIKE item-doc-est.aliquota-ipi           NO-UNDO.
DEFINE VARIABLE de-aliq-cbs              LIKE item-doc-est.aliquota-ipi           NO-UNDO.
DEFINE VARIABLE de-aliq-is               LIKE item-doc-est.aliquota-ipi           NO-UNDO.
DEFINE VARIABLE de-aliq-espec-is         LIKE item-doc-est.aliquota-ipi           NO-UNDO.
DEFINE VARIABLE de-qtde-tribut-is        LIKE item-doc-est.quantidade             NO-UNDO.
DEFINE VARIABLE de-aliq-red-ibsuf        LIKE item-doc-est.aliquota-ipi           NO-UNDO.
DEFINE VARIABLE de-aliq-red-ibsmun       LIKE item-doc-est.aliquota-ipi           NO-UNDO.
DEFINE VARIABLE de-aliq-red-cbs          LIKE item-doc-est.aliquota-ipi           NO-UNDO.
DEFINE VARIABLE de-aliq-reg-ibsuf        LIKE item-doc-est.aliquota-ipi           NO-UNDO.
DEFINE VARIABLE de-aliq-reg-ibsmun       LIKE item-doc-est.aliquota-ipi           NO-UNDO.
DEFINE VARIABLE de-aliq-reg-cbs          LIKE item-doc-est.aliquota-ipi           NO-UNDO.
DEFINE VARIABLE de-base-ibsuf            LIKE item-doc-est.base-ipi[1]            NO-UNDO.
DEFINE VARIABLE de-base-ibsmun           LIKE item-doc-est.base-ipi[1]            NO-UNDO.
DEFINE VARIABLE de-base-cbs              LIKE item-doc-est.base-ipi[1]            NO-UNDO.
DEFINE VARIABLE de-base-is               LIKE item-doc-est.base-ipi[1]            NO-UNDO.
DEFINE VARIABLE de-base-reg-ibsuf        LIKE item-doc-est.base-ipi[1]            NO-UNDO.
DEFINE VARIABLE de-base-reg-ibsmun       LIKE item-doc-est.base-ipi[1]            NO-UNDO.
DEFINE VARIABLE de-base-reg-cbs          LIKE item-doc-est.base-ipi[1]            NO-UNDO.
DEFINE VARIABLE de-val-ibsuf             LIKE item-doc-est.valor-ipi[1]           NO-UNDO.
DEFINE VARIABLE de-val-ibsmun            LIKE item-doc-est.valor-ipi[1]           NO-UNDO.
DEFINE VARIABLE de-val-cbs               LIKE item-doc-est.valor-ipi[1]           NO-UNDO.
DEFINE VARIABLE de-val-is                LIKE item-doc-est.valor-ipi[1]           NO-UNDO.
DEFINE VARIABLE de-val-reg-ibsuf         LIKE item-doc-est.valor-ipi[1]           NO-UNDO.
DEFINE VARIABLE de-val-reg-ibsmun        LIKE item-doc-est.valor-ipi[1]           NO-UNDO.
DEFINE VARIABLE de-val-reg-cbs           LIKE item-doc-est.valor-ipi[1]           NO-UNDO.
DEFINE VARIABLE de-base-ibsuf-tot-geral  LIKE item-doc-est.base-ipi[1]            NO-UNDO.
DEFINE VARIABLE de-base-ibsmun-tot-geral LIKE item-doc-est.base-ipi[1]            NO-UNDO.
DEFINE VARIABLE de-base-cbs-tot-geral    LIKE item-doc-est.base-ipi[1]            NO-UNDO.
DEFINE VARIABLE de-base-is-tot-geral     LIKE item-doc-est.base-ipi[1]            NO-UNDO.
DEFINE VARIABLE de-val-ibsuf-tot-geral   LIKE item-doc-est.valor-ipi[1]           NO-UNDO.
DEFINE VARIABLE de-val-ibsmun-tot-geral  LIKE item-doc-est.valor-ipi[1]           NO-UNDO.
DEFINE VARIABLE de-val-cbs-tot-geral     LIKE item-doc-est.valor-ipi[1]           NO-UNDO.
DEFINE VARIABLE de-val-is-tot-geral      LIKE item-doc-est.valor-ipi[1]           NO-UNDO.
DEFINE VARIABLE c-cclasstrib-cbs         AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-cclasstrib-is          AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-cclasstrib-ibsuf       AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-cclasstrib-ibsmun      AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-cst-cbs                AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-cst-is                 AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-cst-ibsuf              AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-cst-ibsmun             AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-cclasstrib-reg-cbs     AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-cclasstrib-reg-ibsuf   AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-cclasstrib-reg-ibsmun  AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-cst-reg-cbs            AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-cst-reg-ibsuf          AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-cst-reg-ibsmun         AS CHARACTER                             NO-UNDO.

DEFINE VARIABLE l-nt2024002              AS LOGICAL                               NO-UNDO.
ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002":U AND funcao.ativo).

DEFINE BUFFER b-ordens-embarque FOR ordens-embarque.

{utp/ut-liter.i Sim}
ASSIGN c-sim = RETURN-VALUE.

{utp/ut-liter.i N∆o}
ASSIGN c-nao = RETURN-VALUE.

FIND FIRST tt-parametros NO-LOCK NO-ERROR.

ASSIGN c-hora-arquivo     = STRING(TODAY, "99999999") + "_" + REPLACE(STRING(TIME,"HH:MM:SS"), ":", "")
       c-embarque-arquivo = REPLACE(REPLACE(REPLACE(tt-parametros.embarque,".",""),"/",""),"\","")
       c-arquivo-planilha = SESSION:TEMP-DIRECTORY + "IM0100_":U + tt-parametros.cod-estabel + "_":U
       c-arquivo-planilha = c-arquivo-planilha + c-embarque-arquivo + "_":U
       c-arquivo-planilha = c-arquivo-planilha + c-hora-arquivo + ".xlsx".

/* Configuraá‰es gerais da planilha */
RUN piConfigPlanilha.

/* Configuraá∆o de abas da planilha */
RUN piConfigAbas.

/* Geraá∆o de dados para planilha */
RUN piGeraDadosPlanilha.

IF RETURN-VALUE <> "NOK":U THEN DO:
    RUN utp/utapi013.p PERSISTENT SET h-utapi013.
    
    RUN pi-execute3 IN h-utapi013 (INPUT-OUTPUT TABLE tt-configuracao2,
                                   INPUT-OUTPUT TABLE tt-planilha2,
                                   INPUT-OUTPUT TABLE tt-dados,
                                   INPUT-OUTPUT TABLE tt-formatar,
                                   INPUT-OUTPUT TABLE tt-grafico2,
                                   INPUT-OUTPUT TABLE tt-erros).
    DELETE PROCEDURE h-utapi013.
END.

PROCEDURE piConfigAbas:
/********************************************************************************
    Procedure responsavel por criar as abas da planilha e setar suas propriedades
********************************************************************************/

    DEFINE VARIABLE i-cont-colun AS INTEGER     NO-UNDO.

    /* Aba Nota */
    {utp/ut-liter.i Nota}
    CREATE tt-planilha2.
    ASSIGN tt-planilha2.arquivo-num       = i-num-arquivo
           tt-planilha2.planilha-num      = i-planilha-nota
           tt-planilha2.planilha-nome     = RETURN-VALUE
           tt-planilha2.linhas-grade      = NO
           tt-planilha2.formatar-planilha = YES
           tt-planilha2.formatar-faixa    = YES.
    
    /* Largura das colunas da aba Nota */
    /* Embarque */
    ASSIGN tt-planilha2.largura-coluna[1] = 16.
    /* DI */
    ASSIGN tt-planilha2.largura-coluna[2] = 20.
    /* Moeda */
    ASSIGN tt-planilha2.largura-coluna[3] = 12.
    /* Fornecedor */
    ASSIGN tt-planilha2.largura-coluna[4] = 40.
    /* Taxa CÉmbio */
    ASSIGN tt-planilha2.largura-coluna[5] = 15.
    /* Nat Operaá∆o */
    ASSIGN tt-planilha2.largura-coluna[6] = 12.
    /* Desc Nat Operaá∆o */
    ASSIGN tt-planilha2.largura-coluna[7] = 35.
    /* Incoterm */
    ASSIGN tt-planilha2.largura-coluna[8] = 9.
    /* Total ME */
    ASSIGN tt-planilha2.largura-coluna[9] = 15.
    /* Total MN */
    ASSIGN tt-planilha2.largura-coluna[10] = 15.
    /* Peso Bruto Totl */
    ASSIGN tt-planilha2.largura-coluna[11] = 15.
    /* Peso Liq Tot */
    ASSIGN tt-planilha2.largura-coluna[12] = 15.
    /* Base II */
    ASSIGN tt-planilha2.largura-coluna[13] = 15.
    /* Valor II */
    ASSIGN tt-planilha2.largura-coluna[14] = 15.
    /* Base IPI Isento */
    ASSIGN tt-planilha2.largura-coluna[15] = 14.
    /* Base IPI Outros */
    ASSIGN tt-planilha2.largura-coluna[16] = 14.
    /* Base IPI Trib */
    ASSIGN tt-planilha2.largura-coluna[17] = 14.
    /* Valor IPI */
    ASSIGN tt-planilha2.largura-coluna[18] = 14.
    /* Base ICMS Isento */
    ASSIGN tt-planilha2.largura-coluna[19] = 16.
    /* Base ICMS Outros */
    ASSIGN tt-planilha2.largura-coluna[20] = 16.
    /* Base ICMS Trib */
    ASSIGN tt-planilha2.largura-coluna[21] = 16.
    /* Valor ICMS */
    ASSIGN tt-planilha2.largura-coluna[22] = 15.
    /* Base PIS */
    ASSIGN tt-planilha2.largura-coluna[23] = 15.
    /* Valor PIS */
    ASSIGN tt-planilha2.largura-coluna[24] = 15.
    /* Base COFINS */
    ASSIGN tt-planilha2.largura-coluna[25] = 15.
    /* Valor COFINS */
    ASSIGN tt-planilha2.largura-coluna[26] = 15.
    /* Total Despesas */
    ASSIGN tt-planilha2.largura-coluna[27] = 18.
    IF l-nt2024002 THEN DO:
        /* Base IBS UF */
        ASSIGN tt-planilha2.largura-coluna[27] = 15.
        /* Valor IBS UF */
        ASSIGN tt-planilha2.largura-coluna[28] = 15.
        /* Base IBS Mun */
        ASSIGN tt-planilha2.largura-coluna[29] = 15.
        /* Valor IBS Mun */
        ASSIGN tt-planilha2.largura-coluna[30] = 15.
        /* Base CBS */
        ASSIGN tt-planilha2.largura-coluna[31] = 15.
        /* Valor CBS */
        ASSIGN tt-planilha2.largura-coluna[32] = 15.
        /* Base IS */
        ASSIGN tt-planilha2.largura-coluna[33] = 15.
        /* Valor IS */
        ASSIGN tt-planilha2.largura-coluna[34] = 15.
        /* Total Despesas */
        ASSIGN tt-planilha2.largura-coluna[35] = 18.
    END.

    /* Aba Despesas*/
    {utp/ut-liter.i Despesas}
    CREATE tt-planilha2.
    ASSIGN tt-planilha2.arquivo-num       = i-num-arquivo
           tt-planilha2.planilha-num      = i-planilha-despesa
           tt-planilha2.planilha-nome     = RETURN-VALUE
           tt-planilha2.linhas-grade      = NO
           tt-planilha2.formatar-planilha = YES
           tt-planilha2.formatar-faixa    = YES.

    /* Largura das colunas da aba Despesas */
    /* Forn Desp */
    ASSIGN tt-planilha2.largura-coluna[1] = 9.
    /* Nome Abrev */
    ASSIGN tt-planilha2.largura-coluna[2] = 12.
    /* Despesa */
    ASSIGN tt-planilha2.largura-coluna[3] = 8.
    /* Descriá∆o */
    ASSIGN tt-planilha2.largura-coluna[4] = 30.
    /* Cond Pgto */
    ASSIGN tt-planilha2.largura-coluna[5] = 10.
    /* Valor Despesa */
    ASSIGN tt-planilha2.largura-coluna[6] = 15.
    /* Mo Desp */
    ASSIGN tt-planilha2.largura-coluna[7] = 12.
    /* Valor Orig */
    ASSIGN tt-planilha2.largura-coluna[8] = 16.
    /* Taxa CÉmbio */
    ASSIGN tt-planilha2.largura-coluna[9] = 15.
    /* Dupl */
    ASSIGN tt-planilha2.largura-coluna[10] = 5.
    /* II */
    ASSIGN tt-planilha2.largura-coluna[11] = 5.
    /* IPI */
    ASSIGN tt-planilha2.largura-coluna[12] = 5.
    /* ICMS */
    ASSIGN tt-planilha2.largura-coluna[13] = 5.
    /* PIS VL ADU */
    ASSIGN tt-planilha2.largura-coluna[14] = 10.
    /* PIS DESP */
    ASSIGN tt-planilha2.largura-coluna[15] = 8.
    /* COFINS ADU */
    ASSIGN tt-planilha2.largura-coluna[16] = 12.
    /* COFINS DESP */
    ASSIGN tt-planilha2.largura-coluna[17] = 12.
    /* TIPO */
    ASSIGN tt-planilha2.largura-coluna[18] = 20.
    IF l-nt2024002 THEN DO:
        /* IBS UF */
        ASSIGN tt-planilha2.largura-coluna[18] = 6.
        /* IBS Mun */
        ASSIGN tt-planilha2.largura-coluna[19] = 7.
        /* CBS VL ADU */
        ASSIGN tt-planilha2.largura-coluna[20] = 11.
        /* IS */
        ASSIGN tt-planilha2.largura-coluna[21] = 5.
        /* TIPO */
        ASSIGN tt-planilha2.largura-coluna[22] = 20.
    END.

    /* Aba Itens */
    {utp/ut-liter.i Itens}
    CREATE tt-planilha2.
    ASSIGN tt-planilha2.arquivo-num       = i-num-arquivo
           tt-planilha2.planilha-num      = i-planilha-itens
           tt-planilha2.planilha-nome     = RETURN-VALUE
           tt-planilha2.linhas-grade      = NO
           tt-planilha2.formatar-planilha = YES
           tt-planilha2.formatar-faixa    = YES.

    /* Largura das colunas da aba Itens */
    /* Seq */
    ASSIGN tt-planilha2.largura-coluna[1] = 5.
    /* Item */
    ASSIGN tt-planilha2.largura-coluna[2] = 16.
    /* Descriá∆o */
    ASSIGN tt-planilha2.largura-coluna[3] = 60.
    /* Class Fiscal */
    ASSIGN tt-planilha2.largura-coluna[4] = 11.
    /* Descriá∆o Class Fiscal */
    ASSIGN tt-planilha2.largura-coluna[5] = 35.
    /* Qtde */
    ASSIGN tt-planilha2.largura-coluna[6] = 17.
    /* Valor Unit */
    ASSIGN tt-planilha2.largura-coluna[7] = 17.
    /* Total ME */
    ASSIGN tt-planilha2.largura-coluna[8] = 15.
    /* Total MN */
    ASSIGN tt-planilha2.largura-coluna[9] = 15.
    /* Peso Bruto Tot */
    ASSIGN tt-planilha2.largura-coluna[10] = 20.
    /* Peso Liq Unit */
    ASSIGN tt-planilha2.largura-coluna[11] = 20.
    /* Peso Liq Tot */
    ASSIGN tt-planilha2.largura-coluna[12] = 20.
    /* II */
    ASSIGN tt-planilha2.largura-coluna[13] = 4.
    /* Base II */
    ASSIGN tt-planilha2.largura-coluna[14] = 19.
    /* %II */
    ASSIGN tt-planilha2.largura-coluna[15] = 6.
    /* Valor II */
    ASSIGN tt-planilha2.largura-coluna[16] = 19.
    /* IPI */
    ASSIGN tt-planilha2.largura-coluna[17] = 4.
    /* Base IPI */
    ASSIGN tt-planilha2.largura-coluna[18] = 15.
    /* %IPI */
    ASSIGN tt-planilha2.largura-coluna[19] = 9.
    /* Valor IPI */
    ASSIGN tt-planilha2.largura-coluna[20] = 15.
    /* ICMS */
    ASSIGN tt-planilha2.largura-coluna[21] = 5.
    /* Base ICMS */
    ASSIGN tt-planilha2.largura-coluna[22] = 15.
    /* %ICMS */
    ASSIGN tt-planilha2.largura-coluna[23] = 7.
    /* Valor ICMS */
    ASSIGN tt-planilha2.largura-coluna[24] = 15.
    /* PIS */
    ASSIGN tt-planilha2.largura-coluna[25] = 4.
    /* Base PIS */
    ASSIGN tt-planilha2.largura-coluna[26] = 15.
    /* %PIS */
    ASSIGN tt-planilha2.largura-coluna[27] = 6.
    /* Valor PIS */
    ASSIGN tt-planilha2.largura-coluna[28] = 15.
    /* COFINS */
    ASSIGN tt-planilha2.largura-coluna[29] = 8.
    /* Base COFINS */
    ASSIGN tt-planilha2.largura-coluna[30] = 15.
    /* %COFINS */
    ASSIGN tt-planilha2.largura-coluna[31] = 9.
    /* Valor COFINS */
    ASSIGN tt-planilha2.largura-coluna[32] = 15.
    /* Processo Imp */
    ASSIGN tt-planilha2.largura-coluna[33] = 13.
    /* Pedido */
    ASSIGN tt-planilha2.largura-coluna[34] = 10.
    /* Ordem Compra */
    ASSIGN tt-planilha2.largura-coluna[35] = 14.
    /* Nr Adiá∆o */
    ASSIGN tt-planilha2.largura-coluna[36] = 9.
    /* Taxa Siscomex */
    ASSIGN tt-planilha2.largura-coluna[37] = 15.
    /* Total Despesas */
    ASSIGN tt-planilha2.largura-coluna[38] = 18.
    IF l-nt2024002 THEN DO:
        /* Class Trib IBS UF */ 
        ASSIGN tt-planilha2.largura-coluna[33] = 15.
        /* CST IBS UF */
        ASSIGN tt-planilha2.largura-coluna[34] = 10.
        /* IBS UF */
        ASSIGN tt-planilha2.largura-coluna[35] = 6.
        /* Base IBS UF */
        ASSIGN tt-planilha2.largura-coluna[36] = 15.
        /* %IBS UF */
        ASSIGN tt-planilha2.largura-coluna[37] = 8.
        /* %RED IBS UF */
        ASSIGN tt-planilha2.largura-coluna[38] = 12.
        /* Valor IBS UF */
        ASSIGN tt-planilha2.largura-coluna[39] = 15.        
        /* Class Trib Reg IBS UF */ 
        ASSIGN tt-planilha2.largura-coluna[40] = 20.
        /* CST Reg IBS UF */        
        ASSIGN tt-planilha2.largura-coluna[41] = 14.
        /* Base Trib Reg IBS UF */
        ASSIGN tt-planilha2.largura-coluna[42] = 20.
        /* %Trib Reg IBS UF */
        ASSIGN tt-planilha2.largura-coluna[43] = 16.
        /* Valor Trib Reg IBS UF */
        ASSIGN tt-planilha2.largura-coluna[44] = 21.

        /* Class Trib IBS Mun */
        ASSIGN tt-planilha2.largura-coluna[45] = 18.
        /* CST IBS Mun */
        ASSIGN tt-planilha2.largura-coluna[46] = 12.
        /* IBS Mun */
        ASSIGN tt-planilha2.largura-coluna[47] = 7.
        /* Base IBS Mun */
        ASSIGN tt-planilha2.largura-coluna[48] = 15.
        /* %IBS Mun */
        ASSIGN tt-planilha2.largura-coluna[49] = 9.
        /* %RED IBS Mun */
        ASSIGN tt-planilha2.largura-coluna[50] = 13.
        /* Valor IBS Mun */
        ASSIGN tt-planilha2.largura-coluna[51] = 15.
        /* Class Trib Reg IBS Mun */ 
        ASSIGN tt-planilha2.largura-coluna[52] = 20.
        /* CST Reg IBS Mun */
        ASSIGN tt-planilha2.largura-coluna[53] = 16.
        /* Base Trib Reg IBS Mun */
        ASSIGN tt-planilha2.largura-coluna[54] = 20.
        /* %Trib Reg IBS Mun */
        ASSIGN tt-planilha2.largura-coluna[55] = 16.
        /* Valor Trib Reg IBS Mun */
        ASSIGN tt-planilha2.largura-coluna[56] = 21.
        
        /* Class Trib CBS */ 
        ASSIGN tt-planilha2.largura-coluna[57] = 13.
        /* CST CBS */
        ASSIGN tt-planilha2.largura-coluna[58] = 8.
        /* CBS */
        ASSIGN tt-planilha2.largura-coluna[59] = 5.
        /* Base CBS */
        ASSIGN tt-planilha2.largura-coluna[60] = 15.
        /* %CBS */
        ASSIGN tt-planilha2.largura-coluna[61] = 8.
        /* %RED CBS */
        ASSIGN tt-planilha2.largura-coluna[62] = 11.
        /* Valor CBS */
        ASSIGN tt-planilha2.largura-coluna[63] = 15.
        /* Class Trib Reg CBS */ 
        ASSIGN tt-planilha2.largura-coluna[64] = 17.
        /* CST Reg CBS */
        ASSIGN tt-planilha2.largura-coluna[65] = 12.
        /* Base Trib Reg CBS */
        ASSIGN tt-planilha2.largura-coluna[66] = 17.
        /* %Trib Reg CBS */
        ASSIGN tt-planilha2.largura-coluna[67] = 13.
        /* Valor Trib Reg CBS */
        ASSIGN tt-planilha2.largura-coluna[68] = 18.
        
        /* Class Trib IS */ 
        ASSIGN tt-planilha2.largura-coluna[69] = 13.
        /* CST IS */
        ASSIGN tt-planilha2.largura-coluna[70] = 8.
        /* IS */
        ASSIGN tt-planilha2.largura-coluna[71] = 5.
        /* Base IS */
        ASSIGN tt-planilha2.largura-coluna[72] = 15.
        /* %IS */
        ASSIGN tt-planilha2.largura-coluna[73] = 8.
        /* Aliq Espec UN */
        ASSIGN tt-planilha2.largura-coluna[74] = 12.
        /* Qtde Trib IS */
        ASSIGN tt-planilha2.largura-coluna[75] = 12.
        /* UN Trib IS */
        ASSIGN tt-planilha2.largura-coluna[76] = 10.
        /* Valor IS */
        ASSIGN tt-planilha2.largura-coluna[77] = 15.
        
        /* Processo Imp */
        ASSIGN tt-planilha2.largura-coluna[78] = 13.
        /* Pedido */
        ASSIGN tt-planilha2.largura-coluna[79] = 10.
        /* Ordem Compra */
        ASSIGN tt-planilha2.largura-coluna[80] = 14.
        /* Nr Adiá∆o */
        ASSIGN tt-planilha2.largura-coluna[81] = 9.
        /* Taxa Siscomex */
        ASSIGN tt-planilha2.largura-coluna[82] = 15.
        /* Total Despesas */
        ASSIGN tt-planilha2.largura-coluna[83] = 18.
    END.

    /* Aba Despesas Itens */
    {utp/ut-liter.i Despesas_Itens}
    CREATE tt-planilha2.
    ASSIGN tt-planilha2.arquivo-num       = i-num-arquivo
           tt-planilha2.planilha-num      = i-planilha-desp-itens
           tt-planilha2.planilha-nome     = RETURN-VALUE
           tt-planilha2.linhas-grade      = NO
           tt-planilha2.formatar-planilha = YES
           tt-planilha2.formatar-faixa    = YES.

    /* Largura das colunas da aba Despesas Itens */
    /* Seq */
    ASSIGN tt-planilha2.largura-coluna[1] = 5.
    /* Item */
    ASSIGN tt-planilha2.largura-coluna[2] = 16.
    /* Descriá∆o */
    ASSIGN tt-planilha2.largura-coluna[3] = 60.
    /* Class Fiscal */
    ASSIGN tt-planilha2.largura-coluna[4] = 11.
    /* Descriá∆o Class Fiscal */
    ASSIGN tt-planilha2.largura-coluna[5] = 35.
    /* Forn Desp */
    ASSIGN tt-planilha2.largura-coluna[6] = 9.
    /* Nome Abrev */
    ASSIGN tt-planilha2.largura-coluna[7] = 12.
    /* Despesa */
    ASSIGN tt-planilha2.largura-coluna[8] = 8.
    /* Descriá∆o */
    ASSIGN tt-planilha2.largura-coluna[9] = 30.
    /* Valor Despesa */
    ASSIGN tt-planilha2.largura-coluna[10] = 15.

    /* Aba Config Tributos */
    {utp/ut-liter.i Config_Tributos}
    CREATE tt-planilha2.
    ASSIGN tt-planilha2.arquivo-num       = i-num-arquivo
           tt-planilha2.planilha-num      = i-planilha-config
           tt-planilha2.planilha-nome     = RETURN-VALUE
           tt-planilha2.linhas-grade      = NO
           tt-planilha2.formatar-planilha = YES
           tt-planilha2.formatar-faixa    = YES.
    
    /* Largura das colunas da aba Config Tributos */
    /* Emitente */
    ASSIGN tt-planilha2.largura-coluna[1] = 10.
    /* SÇrie */
    ASSIGN tt-planilha2.largura-coluna[2] = 8.
    /* Nota Fiscal */
    ASSIGN tt-planilha2.largura-coluna[3] = 12.
    /* Nat Oper */
    ASSIGN tt-planilha2.largura-coluna[4] = 12.
    /* Seq */
    ASSIGN tt-planilha2.largura-coluna[5] = 5.
    /* Item */
    ASSIGN tt-planilha2.largura-coluna[6] = 16.
    /* Tipo Tributo */
    ASSIGN tt-planilha2.largura-coluna[7] = 15.
    /* Configuraá∆o Tributo */
    ASSIGN tt-planilha2.largura-coluna[8] = 30.
    /* Aliq */
    ASSIGN tt-planilha2.largura-coluna[9] = 8.
    /* Base Calc. Tributo */
    ASSIGN tt-planilha2.largura-coluna[10] = 15.
    /* Val Tributo */
    ASSIGN tt-planilha2.largura-coluna[11] = 15.
    /* Cod Tributaá∆o */
    ASSIGN tt-planilha2.largura-coluna[12] = 15.
    /* Perc Reduá∆o */
    ASSIGN tt-planilha2.largura-coluna[13] = 15.
    /* Quant de Valor Fixo */
    ASSIGN tt-planilha2.largura-coluna[14] = 20.
    /* Valor Fixo */
    ASSIGN tt-planilha2.largura-coluna[15] = 15.
    /* Situaá∆o Tributo */
    ASSIGN tt-planilha2.largura-coluna[16] = 15.
    /* Cod Formula Base Calc */
    ASSIGN tt-planilha2.largura-coluna[17] = 25.
    /* Chave Cen†rio */
    ASSIGN tt-planilha2.largura-coluna[18] = 70.
    /* F¢rmula Calc Tributo */
    ASSIGN tt-planilha2.largura-coluna[19] = 70.
    /* Mem¢ria C†lculo F¢rmula Tributo */
    ASSIGN tt-planilha2.largura-coluna[20] = 50.
    /* F¢rmula Calc Base Calc Tributo */
    ASSIGN tt-planilha2.largura-coluna[21] = 70.
    /* Mem¢ria C†lculo F¢rmula Base Calc Tributo */
    ASSIGN tt-planilha2.largura-coluna[22] = 50.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piConfigPlanilha:
/********************************************************************************
    Procedure responsavel pelas configuraá‰es gerais da planilha
********************************************************************************/
    CREATE tt-configuracao2.
    ASSIGN tt-configuracao2.versao-integracao   = 001
           tt-configuracao2.arquivo-num         = i-num-arquivo
           tt-configuracao2.arquivo             = c-arquivo-planilha
           tt-configuracao2.total-planilhas     = 5
           tt-configuracao2.exibir-construcao   = NO
           tt-configuracao2.abrir-excel-termino = YES.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piGeraDadosPlanilha:
/********************************************************************************
    Procedure respons†vel por gerar os dados para impress∆o na planilha
********************************************************************************/
    FIND FIRST embarque-imp WHERE embarque-imp.cod-estabel = tt-parametros.cod-estabel 
                              AND embarque-imp.embarque    = tt-parametros.embarque NO-LOCK NO-ERROR.

    IF NOT AVAIL embarque-imp THEN 
        RETURN "NOK":U.
    
    FIND FIRST ordens-embarque WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel 
                                 AND ordens-embarque.embarque    = embarque-imp.embarque NO-LOCK NO-ERROR.

    IF NOT AVAIL ordens-embarque THEN
        RETURN "NOK":U.
    
    FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.
    
    ASSIGN i-mo-codigo = IF AVAIL ordem-compra THEN ordem-compra.mo-codigo ELSE 0.
    
    FIND FIRST moeda WHERE moeda.mo-codigo = i-mo-codigo NO-LOCK NO-ERROR.

    ASSIGN c-desc-moeda = IF AVAIL moeda THEN moeda.descricao ELSE "".
    
    FIND FIRST emitente WHERE emitente.cod-emitente = tt-parametros.cod-emitente NO-LOCK NO-ERROR.

    ASSIGN c-desc-emitente = IF AVAIL emitente THEN emitente.nome-emit ELSE "".
    
    FIND cotacao WHERE
         cotacao.mo-codigo   = i-mo-codigo AND
         cotacao.ano-periodo = STRING(YEAR(tt-parametros.da-cotacao)) + STRING(MONTH(tt-parametros.da-cotacao),"99") AND
         cotacao.cotacao[INT(DAY(tt-parametros.da-cotacao))] <> 0 NO-LOCK NO-ERROR.
    
    ASSIGN de-cotacao-dia-nota = IF AVAIL cotacao THEN cotacao.cotacao[INT(DAY(tt-parametros.da-cotacao))] ELSE 1.

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
           tt-epc.val-parameter = STRING(de-cotacao-dia-nota).

    {include/i-epc201.i "CalculoPrecoUnitario"} 

    FIND FIRST tt-epc
         WHERE tt-epc.cod-event     = "CalculoPrecoUnitario":U
           AND tt-epc.cod-parameter = "AlteraCotacao":U NO-ERROR.

    IF  AVAIL tt-epc THEN
        ASSIGN de-cotacao-dia-nota    = DEC(tt-epc.val-parameter).

    FIND FIRST natur-oper WHERE natur-oper.nat-operacao = tt-parametros.nat-operacao NO-LOCK NO-ERROR.
    
    ASSIGN c-desc-natur = IF AVAIL natur-oper THEN natur-oper.denominacao ELSE "".
           
    FIND FIRST param-imp WHERE param-imp.cod-estabel = tt-parametros.cod-estabel NO-LOCK NO-ERROR.
    
    IF NOT AVAIL param-imp THEN
        RETURN "NOK":U.
    
    {cdp/cd4300.i3}
    {cxbo/bocx250.i50}
    {cdp/cd4300.i4 "yes" param-imp.char-1}
    {cxbo/bocx250.i51 "yes"}
    
    assign i-desp-ii = i-desp-ii-i50.

    FOR EACH tt-docum-est:
        DELETE tt-docum-est.
    END.
    
    FIND FIRST docum-est WHERE docum-est.serie-docto  = tt-parametros.serie 
                           AND docum-est.nro-docto    = tt-parametros.nro-docto 
                           AND docum-est.cod-emitente = tt-parametros.cod-emitente 
                           AND docum-est.nat-operacao = tt-parametros.nat-operacao NO-LOCK NO-ERROR.

    IF NOT AVAIL docum-est THEN DO:
          RETURN "NOK":U.
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
        FOR EACH item-doc-est NO-LOCK
           WHERE item-doc-est.serie-docto  = tt-docum-est.serie-docto 
             AND item-doc-est.nro-docto    = tt-docum-est.nro-docto   
             AND item-doc-est.cod-emitente = tt-docum-est.cod-emitente 
             AND item-doc-est.nat-operacao = tt-docum-est.nat-operacao:
        
            FIND FIRST classif-fisc 
                 WHERE classif-fisc.class-fiscal = item-doc-est.class-fiscal NO-LOCK NO-ERROR.
            
            ASSIGN c-desc-class-fisc = IF AVAIL classif-fisc THEN classif-fisc.descricao ELSE "".
            
            FIND FIRST ITEM 
                 WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-LOCK NO-ERROR.

            ASSIGN c-desc-item = IF AVAIL ITEM THEN ITEM.desc-item ELSE "".

            IF  tt-parametros.l-nf-simples-remessa     AND
                tt-parametros.idi-nf-simples-remes = 1 THEN DO:

                ASSIGN l-gera-prim-remessa = YES.

                IF TRIM(substring(item-doc-est.char-2,940,1)) <> "S":U THEN DO: /*Gera primeira remessa com NF Míe*/
                    ASSIGN i-numero-ordem = item-doc-est.num-ord-import
                           i-parcela      = item-doc-est.num-parc-import.
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

            FIND FIRST cotacao-item 
                WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                  AND cotacao-item.cod-emitente = item-doc-est.cod-emitente 
                  AND cotacao-item.it-codigo    = item-doc-est.it-codigo    
                  AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.
    
            FIND FIRST tt-epc
                 WHERE tt-epc.cod-event     = "CalculoPrecoUnitario":U
                   AND tt-epc.cod-parameter = "AlteraCotacao":U NO-ERROR.
    
            IF  AVAIL tt-epc THEN
                ASSIGN de-preco-total-me = item-doc-est.preco-total[1] / de-cotacao-dia-nota.
            ELSE DO:
                IF AVAIL cotacao-item THEN DO:
                    assign de-preco-unit-mo = cotacao-item.pre-unit-for.
                    ASSIGN de-preco-unit-mo = (de-preco-unit-mo * 100) / (100 + cotacao-item.aliquota-ipi).
                    assign de-preco-total-me  = de-preco-unit-mo * item-doc-est.qt-do-forn.
                END.
            END.
                    
            ASSIGN de-peso-bruto         = item.peso-bruto       * item-doc-est.quantidade
                   de-peso-liq-unit      = item-doc-est.peso-liquido / item-doc-est.quantidade
                   de-preco-unit-sem-ipi = 0.

            FIND FIRST ordens-embarque
                 WHERE ordens-embarque.cod-estabel  = embarque-imp.cod-estabel  AND
                       ordens-embarque.embarque     = embarque-imp.embarque     AND
                       ordens-embarque.numero-ordem = ordem-compra.numero-ordem AND
                       ordens-embarque.parcela      = i-parcela                 NO-LOCK NO-ERROR.

            ASSIGN i-num-adicao = IF (l-gera-prim-remessa AND AVAIL b-ordens-embarque) THEN b-ordens-embarque.num-adic 
                                      ELSE IF AVAIL ordens-embarque THEN ordens-embarque.num-adic ELSE 0.

            IF  AVAIL ordens-embarque THEN DO:
                {cxbo/bocx225e.i2 no ordens-embarque} /* busca valores atributos livres */
                
                ASSIGN de-taxa-siscomex = 0.
                FOR FIRST item-doc-est-cex NO-LOCK
                    WHERE item-doc-est-cex.serie-docto  = item-doc-est.serie-docto
                      AND item-doc-est-cex.nro-docto    = item-doc-est.nro-docto
                      AND item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente
                      AND item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao
                      AND item-doc-est-cex.sequencia    = item-doc-est.sequencia
                      AND item-doc-est-cex.cod-desp     = param-imp.cdn-despes-siscomex:
                    ASSIGN de-taxa-siscomex = item-doc-est-cex.val-desp.
                END.
            END.
            ELSE DO:
                ASSIGN de-taxa-siscomex = 0.
            END.
    
            IF  AVAIL ordens-embarque THEN DO:
                {cxbo/bocx225e.i4 no ordens-embarque} /* busca valores atributos livres */
                ASSIGN l-gravado = l-ja-gravado
                       de-peso-bruto = de-peso-bruto-i1.
            END.
            ELSE DO:
                FIND FIRST ordens-embarque
                 WHERE ordens-embarque.cod-estabel  = embarque-imp.cod-estabel  AND
                       ordens-embarque.embarque     <> embarque-imp.embarque     AND
                       ordens-embarque.numero-ordem = ordem-compra.numero-ordem AND
                       ordens-embarque.parcela      = i-parcela                 NO-LOCK NO-ERROR.


                ASSIGN i-num-adicao = IF (l-gera-prim-remessa AND AVAIL b-ordens-embarque) THEN b-ordens-embarque.num-adic 
                                      ELSE IF AVAIL ordens-embarque THEN ordens-embarque.num-adic ELSE 0.

                IF AVAIL ordens-embarque THEN DO:
                    {cxbo/bocx225e.i2 no ordens-embarque} /* busca valores atributos livres */
                    ASSIGN de-taxa-siscomex = 0.
                    FOR FIRST item-doc-est-cex NO-LOCK
                        WHERE item-doc-est-cex.serie-docto  = item-doc-est.serie-docto
                          AND item-doc-est-cex.nro-docto    = item-doc-est.nro-docto
                          AND item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente
                          AND item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao
                          AND item-doc-est-cex.sequencia    = item-doc-est.sequencia
                          AND item-doc-est-cex.cod-desp     = param-imp.cdn-despes-siscomex:
                        ASSIGN de-taxa-siscomex = item-doc-est-cex.val-desp.
                    END.
                END.
                ELSE
                    ASSIGN de-taxa-siscomex = 0.
                IF  AVAIL ordens-embarque THEN DO:
                {cxbo/bocx225e.i4 no ordens-embarque} /* busca valores atributos livres */
                ASSIGN l-gravado = l-ja-gravado
                       de-peso-bruto = de-peso-bruto-i1.
                END.
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
    
            CASE i-trib-ii-i1:
                WHEN 1 THEN
                    ASSIGN c-trib-ii = "T":U.
                WHEN 2 THEN
                    ASSIGN c-trib-ii = "I":U.
                WHEN 3 THEN
                    ASSIGN c-trib-ii = "O":U.
                WHEN 4 THEN
                    ASSIGN c-trib-ii = "R":U.
            END CASE.

            CASE item-doc-est.cd-trib-icm:
                WHEN 1 THEN
                    ASSIGN c-trib-icm = "T":U.
                WHEN 2 THEN
                    ASSIGN c-trib-icm = "I":U.
                WHEN 3 THEN
                    ASSIGN c-trib-icm = "O":U.
                WHEN 4 THEN
                    ASSIGN c-trib-icm = "R":U.
                WHEN 5 THEN
                    ASSIGN c-trib-icm = "D":U.
            END CASE.

            CASE item-doc-est.cd-trib-ipi:
                WHEN 1 THEN
                    ASSIGN c-trib-ipi = "T":U.
                WHEN 2 THEN
                    ASSIGN c-trib-ipi = "I":U.
                WHEN 3 THEN
                    ASSIGN c-trib-ipi = "O":U.
                WHEN 4 THEN
                    ASSIGN c-trib-ipi = "R":U.
            END CASE.
        
            CASE item-doc-est.idi-tributac-pis:
                WHEN 1 THEN
                    ASSIGN c-trib-pis = "T":U.
                WHEN 2 THEN
                    ASSIGN c-trib-pis = "I":U.
                WHEN 3 THEN
                    ASSIGN c-trib-pis = "O":U.
                WHEN 4 THEN
                    ASSIGN c-trib-pis = "R":U.
            END CASE.   

            CASE item-doc-est.idi-tributac-cofins:
                WHEN 1 THEN
                    ASSIGN c-trib-cofins = "T":U.
                WHEN 2 THEN
                    ASSIGN c-trib-cofins = "I":U.
                WHEN 3 THEN
                    ASSIGN c-trib-cofins = "O":U.
                WHEN 4 THEN
                    ASSIGN c-trib-cofins = "R":U.
            END CASE.
            
            FOR FIRST item-docto-estoq-nfe-imp
                WHERE item-docto-estoq-nfe-imp.cod-ser-docto     =  item-doc-est.serie-docto
                AND   item-docto-estoq-nfe-imp.cod-docto         =  item-doc-est.nro-docto
                AND   item-docto-estoq-nfe-imp.cdn-emitente      =  item-doc-est.cod-emitente
                AND   item-docto-estoq-nfe-imp.cod-natur-operac  =  item-doc-est.nat-operacao
                AND   item-docto-estoq-nfe-imp.num-seq           =  item-doc-est.sequencia NO-LOCK:
            END.
            
            ASSIGN de-base-ii = IF AVAIL item-docto-estoq-nfe-imp THEN item-docto-estoq-nfe-imp.val-base ELSE 0.

            FOR FIRST item-doc-est-cex WHERE
                      item-doc-est-cex.serie-docto  = item-doc-est.serie-docto AND
                      item-doc-est-cex.nro-docto    = item-doc-est.nro-docto   AND
                      item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente AND
                      item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao AND
                      item-doc-est-cex.sequencia    = item-doc-est.sequencia    AND
                      item-doc-est-cex.cod-desp     = i-desp-ii NO-LOCK:
            END.

            ASSIGN de-val-desp-ii = 0
                   de-val-desp-ii = IF AVAIL item-doc-est-cex THEN item-doc-est-cex.val-desp ELSE 0.

            FOR FIRST processo-imp FIELDS (nr-proc-imp)
                WHERE processo-imp.num-pedido = ordem-compra.num-pedido NO-LOCK: END.

            /* Despesas do item */
            RUN piDespesasItem.

            IF NOT VALID-HANDLE(h-cdapi995) THEN
                RUN cdp/cdapi995.p PERSISTENT SET h-cdapi995.
                
            RUN recupera-aliquotas IN h-cdapi995 (INPUT "item-doc-est",
                                                  INPUT item-doc-est.serie-docto + "/" + 
                                                        item-doc-est.nro-docto + "/" + 
                                                        STRING(item-doc-est.cod-emitente) + "/" + 
                                                        item-doc-est.nat-operacao + "/" + 
                                                        STRING(item-doc-est.sequencia), 
                                                  OUTPUT de-aliq-pis, 
                                                  OUTPUT de-aliq-cofins).	 
            
            ASSIGN de-val-pis                = item-doc-est.valor-pis
                   de-val-cofins             = item-doc-est.val-cofins
                   de-preco-tot-geral-me     = de-preco-tot-geral-me + de-preco-total-me
                   de-preco-tot-geral-mn     = de-preco-tot-geral-mn + item-doc-est.preco-total[1]
                   de-peso-bruto-tot-geral   = de-peso-bruto-tot-geral + de-peso-bruto
                   de-peso-liq-tot-geral     = de-peso-liq-tot-geral + item-doc-est.peso-liquido
                   de-base-ii-tot-geral      = de-base-ii-tot-geral + de-base-ii
                   de-base-ipi-trib-geral    = de-base-ipi-trib-geral + item-doc-est.base-ipi[1]
                   de-base-ipi-out-geral     = de-base-ipi-out-geral + item-doc-est.ipi-outras[1]
                   de-base-ipi-isen-geral    = de-base-ipi-isen-geral + item-doc-est.ipi-ntrib[1]
                   de-base-icm-trib-geral    = de-base-icm-trib-geral + item-doc-est.base-icm[1]
                   de-base-icm-out-geral     = de-base-icm-out-geral + item-doc-est.icm-outras[1]
                   de-base-icm-isen-geral    = de-base-icm-isen-geral + item-doc-est.icm-ntrib[1]
                   de-base-pis-tot-geral     = de-base-pis-tot-geral + item-doc-est.base-pis
                   de-base-cofins-tot-geral  = de-base-cofins-tot-geral + item-doc-est.val-base-calc-cofins
                   de-val-desp-ii-tot-geral  = de-val-desp-ii-tot-geral + de-val-desp-ii
                   de-val-ipi-tot-geral      = de-val-ipi-tot-geral + item-doc-est.valor-ipi[1]
                   de-val-icm-tot-geral      = de-val-icm-tot-geral + item-doc-est.valor-icm[1]
                   de-val-pis-tot-geral      = de-val-pis-tot-geral + de-val-pis
                   de-val-cofins-tot-geral   = de-val-cofins-tot-geral + de-val-cofins
                   de-tot-tx-siscomex        = de-tot-tx-siscomex + de-taxa-siscomex
                   i-coluna-item             = 0
                   i-linha-item              = i-linha-item + 1.

            /* Seq */
            RUN piCriaDadosItem (INPUT "#####",
                                 INPUT item-doc-est.sequencia).

            /* Item */
            RUN piCriaDadosItem (INPUT c-formato-char,
                                 INPUT item-doc-est.it-codigo).

            /* Descriá∆o */
            RUN piCriaDadosItem (INPUT c-formato-char,
                                 INPUT c-desc-item).

            /* Class Fiscal */
            RUN piCriaDadosItem (INPUT c-formato-char,
                                 INPUT STRING(item-doc-est.class-fiscal, "9999.99.99")).
            /* Descriá∆o Class Fiscal */
            RUN piCriaDadosItem (INPUT c-formato-char,
                                 INPUT c-desc-class-fisc).
            /* Qtde */
            RUN piCriaDadosItem (INPUT "####.###.##0,0000",
                                 INPUT item-doc-est.qt-do-forn).
            /* Valor Unit */
            RUN piCriaDadosItem (INPUT "###.###.##0,00000",
                                 INPUT item-doc-est.preco-unit[1]).
            /* Total ME */
            RUN piCriaDadosItem (INPUT "####.###.##0,0000",
                                 INPUT de-preco-total-me).
            /* Total MN */
            RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                 INPUT item-doc-est.preco-total[1]).
            /* Peso Bruto Tot */
            RUN piCriaDadosItem (INPUT "#####.##0,00000",
                                 INPUT de-peso-bruto).
            /* Peso Liq Unit */
            RUN piCriaDadosItem (INPUT "####.##0,0000000000",
                                 INPUT de-peso-liq-unit).
            /* Peso Liq Tot */
            RUN piCriaDadosItem (INPUT "####.##0,00000",
                                 INPUT item-doc-est.peso-liquido).
            /* II */
            RUN piCriaDadosItem (INPUT c-formato-char,
                                 INPUT c-trib-ii).
            /* Base II */
            RUN piCriaDadosItem (INPUT "###.###.###.##0,00",
                                 INPUT de-base-ii).
            /* %II */
            RUN piCriaDadosItem (INPUT "##0,0000",
                                 INPUT de-aliq-ii-i1).
            /* Valor II */
            RUN piCriaDadosItem (INPUT "#####.###.##0,00000",
                                 INPUT de-val-desp-ii).
            /* IPI */
            RUN piCriaDadosItem (INPUT c-formato-char,
                                 INPUT c-trib-ipi).
            /* Base IPI */
            CASE c-trib-ipi:
                WHEN "I" THEN
                    RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                         INPUT item-doc-est.ipi-ntrib[1]).
                WHEN "O" THEN
                    RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                         INPUT item-doc-est.ipi-outras[1]).
                OTHERWISE
                    RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                         INPUT item-doc-est.base-ipi[1]).
            END CASE.
            /* %IPI */
            RUN piCriaDadosItem (INPUT "##0,00",
                                 INPUT item-doc-est.aliquota-ipi).
            /* Valor IPI */
            RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                 INPUT item-doc-est.valor-ipi[1]).
            /* ICMS */
            RUN piCriaDadosItem (INPUT c-formato-char,
                                 INPUT c-trib-icm).
            /* Base ICMS */
            CASE c-trib-icm:
                WHEN "I" THEN
                    RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                         INPUT item-doc-est.icm-ntrib[1]).
                WHEN "O" THEN
                    RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                         INPUT item-doc-est.icm-outras[1]).
                OTHERWISE
                    RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                         INPUT item-doc-est.base-icm[1]).
            END CASE.
            /* %ICMS */
            RUN piCriaDadosItem (INPUT "##0,00",
                                 INPUT item-doc-est.aliquota-icm).
            /* Valor ICMS */
            RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                 INPUT item-doc-est.valor-icm[1]).
            /* PIS */
            RUN piCriaDadosItem (INPUT c-formato-char,
                                 INPUT c-trib-pis).
            /* Base PIS */
            RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                 INPUT item-doc-est.base-pis).
            /* %PIS */
            RUN piCriaDadosItem (INPUT "##0,0000",
                                 INPUT de-aliq-pis).
            /* Valor PIS */
            RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                 INPUT de-val-pis).
            /* COFINS */
            RUN piCriaDadosItem (INPUT c-formato-char,
                                 INPUT c-trib-cofins).
            /* Base COFINS */
            RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                 INPUT item-doc-est.val-base-calc-cofins).   
            /* %COFINS */
            RUN piCriaDadosItem (INPUT "##0,0000",
                                 INPUT de-aliq-cofins).
            /* Valor COFINS */
            RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                 INPUT de-val-cofins).   
            
            IF l-nt2024002 THEN DO:
                ASSIGN c-trib-ibsuf       = ""
                       de-base-ibsuf      = 0
                       de-aliq-ibsuf      = 0
                       de-aliq-red-ibsuf  = 0
                       de-val-ibsuf       = 0
                       de-base-reg-ibsuf  = 0
                       de-aliq-reg-ibsuf  = 0
                       de-val-reg-ibsuf   = 0
                       c-trib-ibsmun      = ""
                       de-base-ibsmun     = 0
                       de-aliq-ibsmun     = 0
                       de-aliq-red-ibsmun = 0
                       de-val-ibsmun      = 0
                       de-base-reg-ibsmun = 0
                       de-aliq-reg-ibsmun = 0
                       de-val-reg-ibsmun  = 0
                       c-trib-cbs         = ""
                       de-base-cbs        = 0
                       de-aliq-cbs        = 0
                       de-aliq-red-cbs    = 0
                       de-val-cbs         = 0
                       de-base-reg-cbs    = 0
                       de-aliq-reg-cbs    = 0
                       de-val-reg-cbs     = 0
                       c-trib-is          = ""
                       de-base-is         = 0
                       de-aliq-is         = 0
                       de-aliq-espec-is   = 0
                       de-qtde-tribut-is  = 0
                       c-un-tribut-is     = ""
                       de-val-is          = 0.
                       
                ASSIGN c-cclasstrib-cbs        = ""
                       c-cclasstrib-is         = ""
                       c-cclasstrib-ibsuf      = ""
                       c-cclasstrib-ibsmun     = ""
                       c-cst-cbs               = ""
                       c-cst-is                = ""
                       c-cst-ibsuf             = ""
                       c-cst-ibsmun            = ""
                       c-cclasstrib-reg-cbs    = ""
                       c-cclasstrib-reg-ibsuf  = ""
                       c-cclasstrib-reg-ibsmun = ""
                       c-cst-reg-cbs           = ""
                       c-cst-reg-ibsuf         = ""
                       c-cst-reg-ibsmun        = "".
                       
                FOR EACH item-doc-est-tribut NO-LOCK
                   WHERE item-doc-est-tribut.cod-serie-docto  = item-doc-est.serie-docto
                     AND item-doc-est-tribut.cod-num-docto    = item-doc-est.nro-docto
                     AND item-doc-est-tribut.cdn-emitente     = item-doc-est.cod-emitente
                     AND item-doc-est-tribut.cod-natur-operac = item-doc-est.nat-operacao
                     AND item-doc-est-tribut.num-seq          = item-doc-est.sequencia:
                    
                    /* os nomes de alguns tributos e alguns campos s∆o diferentes entre importaá∆o x recebimento
                       pois no recebimento est† sendo utilizado classes para sua definiá∆o (rep.imp.*) */
                    CASE item-doc-est-tribut.nom-trib:
                        /* IBS UF */
                        WHEN rep.imp.Imposto:IBS-UF THEN DO: 
                            CASE item-doc-est-tribut.cod-campo:
                                WHEN rep.imp.AtributoImposto:COD-TRIB THEN
                                    ASSIGN c-trib-ibsuf = SUBSTRING({diinc/i01di628.i 04 INT(item-doc-est-tribut.cod-conteudo)},1,1).
                                WHEN rep.imp.AtributoImposto:BASE THEN
                                    ASSIGN de-base-ibsuf = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:ALIQUOTA THEN
                                    ASSIGN de-aliq-ibsuf = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:ALIQ-RED THEN
                                    ASSIGN de-aliq-red-ibsuf = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:VALOR THEN
                                    ASSIGN de-val-ibsuf = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:BASE-REG THEN
                                    ASSIGN de-base-reg-ibsuf = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:ALIQUOTA-REG THEN
                                    ASSIGN de-aliq-reg-ibsuf = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:VALOR-REG THEN
                                    ASSIGN de-val-reg-ibsuf = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:C-CLASS-TRIB THEN
                                    ASSIGN c-cclasstrib-ibsuf = item-doc-est-tribut.cod-conteudo.
                                WHEN rep.imp.AtributoImposto:CST THEN
                                    ASSIGN c-cst-ibsuf = item-doc-est-tribut.cod-conteudo.
                                WHEN rep.imp.AtributoImposto:C-CLASS-TRIB-REG THEN
                                    ASSIGN c-cclasstrib-reg-ibsuf = item-doc-est-tribut.cod-conteudo.
                                WHEN rep.imp.AtributoImposto:CST-REG THEN
                                    ASSIGN c-cst-reg-ibsuf = item-doc-est-tribut.cod-conteudo.
                            END CASE.
                        END.
                        /* IBS Mun */
                        WHEN rep.imp.Imposto:IBS-MUN THEN DO: 
                            CASE item-doc-est-tribut.cod-campo:
                                WHEN rep.imp.AtributoImposto:COD-TRIB THEN
                                    ASSIGN c-trib-ibsmun = SUBSTRING({diinc/i01di628.i 04 INT(item-doc-est-tribut.cod-conteudo)},1,1).
                                WHEN rep.imp.AtributoImposto:BASE THEN
                                    ASSIGN de-base-ibsmun = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:ALIQUOTA THEN
                                    ASSIGN de-aliq-ibsmun = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:ALIQ-RED THEN
                                    ASSIGN de-aliq-red-ibsmun = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:VALOR THEN
                                    ASSIGN de-val-ibsmun = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:BASE-REG THEN
                                    ASSIGN de-base-reg-ibsmun = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:ALIQUOTA-REG THEN
                                    ASSIGN de-aliq-reg-ibsmun = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:VALOR-REG THEN
                                    ASSIGN de-val-reg-ibsmun = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:C-CLASS-TRIB THEN
                                    ASSIGN c-cclasstrib-ibsmun = item-doc-est-tribut.cod-conteudo.
                                WHEN rep.imp.AtributoImposto:CST THEN
                                    ASSIGN c-cst-ibsmun = item-doc-est-tribut.cod-conteudo.
                                WHEN rep.imp.AtributoImposto:C-CLASS-TRIB-REG THEN
                                    ASSIGN c-cclasstrib-reg-ibsmun = item-doc-est-tribut.cod-conteudo.
                                WHEN rep.imp.AtributoImposto:CST-REG THEN
                                    ASSIGN c-cst-reg-ibsmun = item-doc-est-tribut.cod-conteudo.
                            END CASE.
                        END.
                        /* CBS */
                        WHEN rep.imp.Imposto:CBS THEN DO: 
                            CASE item-doc-est-tribut.cod-campo:
                                WHEN rep.imp.AtributoImposto:COD-TRIB THEN
                                    ASSIGN c-trib-cbs = SUBSTRING({diinc/i01di628.i 04 INT(item-doc-est-tribut.cod-conteudo)},1,1).
                                WHEN rep.imp.AtributoImposto:BASE THEN
                                    ASSIGN de-base-cbs = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:ALIQUOTA THEN
                                    ASSIGN de-aliq-cbs = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:ALIQ-RED THEN
                                    ASSIGN de-aliq-red-cbs = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:VALOR THEN
                                    ASSIGN de-val-cbs = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:BASE-REG THEN
                                    ASSIGN de-base-reg-cbs = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:ALIQUOTA-REG THEN
                                    ASSIGN de-aliq-reg-cbs = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:VALOR-REG THEN
                                    ASSIGN de-val-reg-cbs = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:C-CLASS-TRIB THEN
                                    ASSIGN c-cclasstrib-cbs = item-doc-est-tribut.cod-conteudo.
                                WHEN rep.imp.AtributoImposto:CST THEN
                                    ASSIGN c-cst-cbs = item-doc-est-tribut.cod-conteudo.
                                WHEN rep.imp.AtributoImposto:C-CLASS-TRIB-REG THEN
                                    ASSIGN c-cclasstrib-reg-cbs = item-doc-est-tribut.cod-conteudo.
                                WHEN rep.imp.AtributoImposto:CST-REG THEN
                                    ASSIGN c-cst-reg-cbs = item-doc-est-tribut.cod-conteudo.
                            END CASE.
                        END.
                        /* IS */
                        WHEN rep.imp.Imposto:IS THEN DO: 
                            CASE item-doc-est-tribut.cod-campo:
                                WHEN rep.imp.AtributoImposto:COD-TRIB THEN
                                    ASSIGN c-trib-is = SUBSTRING({diinc/i01di628.i 04 INT(item-doc-est-tribut.cod-conteudo)},1,1).
                                WHEN rep.imp.AtributoImposto:BASE THEN
                                    ASSIGN de-base-is = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:ALIQUOTA THEN
                                    ASSIGN de-aliq-is = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:ALIQ-ESPEC-UN THEN
                                    ASSIGN de-aliq-espec-is = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:QTDE-TRIBUT THEN
                                    ASSIGN de-qtde-tribut-is = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:UN-TRIBUT THEN
                                    ASSIGN c-un-tribut-is = item-doc-est-tribut.cod-conteudo.
                                WHEN rep.imp.AtributoImposto:VALOR THEN
                                    ASSIGN de-val-is = DEC(item-doc-est-tribut.cod-conteudo).
                                WHEN rep.imp.AtributoImposto:C-CLASS-TRIB THEN
                                    ASSIGN c-cclasstrib-is = item-doc-est-tribut.cod-conteudo.
                                WHEN rep.imp.AtributoImposto:CST THEN
                                    ASSIGN c-cst-is = item-doc-est-tribut.cod-conteudo.
                            END CASE.
                        END.
                    END CASE.
                END.
                
                /* Class Trib IBS UF */
                RUN piCriaDadosItem (INPUT c-formato-char,
                                     INPUT c-cclasstrib-ibsuf).   
                /* CST IBS UF */
                RUN piCriaDadosItem (INPUT c-formato-char,
                                     INPUT c-cst-ibsuf).   
                /* TRIB IBS UF */
                RUN piCriaDadosItem (INPUT c-formato-char,
                                     INPUT c-trib-ibsuf).
                /* Base IBS UF */
                RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                     INPUT de-base-ibsuf).
                ASSIGN de-base-ibsuf-tot-geral = de-base-ibsuf-tot-geral + de-base-ibsuf.
                /* %IBS UF */
                RUN piCriaDadosItem (INPUT "##0,00",
                                     INPUT de-aliq-ibsuf).
                /* %RED IBS UF */
                RUN piCriaDadosItem (INPUT "##0,00",
                                     INPUT de-aliq-red-ibsuf).
                /* Valor IBS UF */
                RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                     INPUT de-val-ibsuf).
                /* Class Trib Reg IBS UF */
                RUN piCriaDadosItem (INPUT c-formato-char,
                                     INPUT c-cclasstrib-reg-ibsuf).
                /* CST Reg IBS UF */
                RUN piCriaDadosItem (INPUT c-formato-char,
                                     INPUT c-cst-reg-ibsuf).
                ASSIGN de-val-ibsuf-tot-geral = de-val-ibsuf-tot-geral + de-val-ibsuf.
                /* Base Trib Reg IBS UF */
                RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                     INPUT de-base-reg-ibsuf).
                /* %Trib Reg IBS UF */
                RUN piCriaDadosItem (INPUT "##0,00",
                                     INPUT de-aliq-reg-ibsuf).
                /* Valor Trib Reg IBS UF */
                RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                     INPUT de-val-reg-ibsuf).   
                                     
                /* Class Trib IBS Mun */
                RUN piCriaDadosItem (INPUT c-formato-char,
                                     INPUT c-cclasstrib-ibsmun).
                /* CST IBS Mun */
                RUN piCriaDadosItem (INPUT c-formato-char,
                                     INPUT c-cst-ibsmun).
                /* TRIB IBS Mun */
                RUN piCriaDadosItem (INPUT c-formato-char,
                                     INPUT c-trib-ibsmun).
                /* Base IBS Mun */
                RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                     INPUT de-base-ibsmun).
                ASSIGN de-base-ibsmun-tot-geral = de-base-ibsmun-tot-geral + de-base-ibsmun.
                /* %IBS Mun */
                RUN piCriaDadosItem (INPUT "##0,00",
                                     INPUT de-aliq-ibsmun).
                /* %RED IBS Mun */
                RUN piCriaDadosItem (INPUT "##0,00",
                                     INPUT de-aliq-red-ibsmun).
                /* Valor IBS Mun */
                RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                     INPUT de-val-ibsmun).   
                /* Class Trib Reg IBS Mun */
                RUN piCriaDadosItem (INPUT c-formato-char,
                                     INPUT c-cclasstrib-reg-ibsmun).
                /* CST Reg IBS Mun */
                RUN piCriaDadosItem (INPUT c-formato-char,
                                     INPUT c-cst-reg-ibsmun).
                ASSIGN de-val-ibsmun-tot-geral = de-val-ibsmun-tot-geral + de-val-ibsmun.
                /* Base Trib Reg IBS Mun */
                RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                     INPUT de-base-reg-ibsmun).
                /* %Trib Reg IBS Mun */
                RUN piCriaDadosItem (INPUT "##0,00",
                                     INPUT de-aliq-reg-ibsmun).
                /* Valor Trib Reg IBS Mun */
                RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                     INPUT de-val-reg-ibsmun).   
                
                /* Class Trib CBS */
                RUN piCriaDadosItem (INPUT c-formato-char,
                                     INPUT c-cclasstrib-cbs).
                /* CST CBS */
                RUN piCriaDadosItem (INPUT c-formato-char,
                                     INPUT c-cst-cbs).
                /* TRIB CBS */
                RUN piCriaDadosItem (INPUT c-formato-char,
                                     INPUT c-trib-cbs).
                /* Base CBS */
                RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                     INPUT de-base-cbs).   
                ASSIGN de-base-cbs-tot-geral = de-base-cbs-tot-geral + de-base-cbs.
                /* %CBS */
                RUN piCriaDadosItem (INPUT "##0,00",
                                     INPUT de-aliq-cbs).
                /* %RED CBS */
                RUN piCriaDadosItem (INPUT "##0,00",
                                     INPUT de-aliq-red-cbs).
                /* Valor CBS */
                RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                     INPUT de-val-cbs).   
                /* Class Trib Reg CBS */
                RUN piCriaDadosItem (INPUT c-formato-char,
                                     INPUT c-cclasstrib-reg-cbs).
                /* CST Reg CBS */
                RUN piCriaDadosItem (INPUT c-formato-char,
                                     INPUT c-cst-reg-cbs).
                ASSIGN de-val-cbs-tot-geral = de-val-cbs-tot-geral + de-val-cbs.
                /* Base Trib Reg CBS */
                RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                     INPUT de-base-reg-cbs).   
                /* %Trib Reg CBS */
                RUN piCriaDadosItem (INPUT "##0,00",
                                     INPUT de-aliq-reg-cbs).
                /* Valor Trib Reg CBS */
                RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                     INPUT de-val-reg-cbs).   
            
                /* Class Trib IS */
                RUN piCriaDadosItem (INPUT c-formato-char,
                                     INPUT c-cclasstrib-is).
                /* CST IS */
                RUN piCriaDadosItem (INPUT c-formato-char,
                                     INPUT c-cst-is).
                /* TRIB IS */
                RUN piCriaDadosItem (INPUT c-formato-char,
                                     INPUT c-trib-is).
                /* Base IS */
                RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                     INPUT de-base-is).   
                ASSIGN de-base-is-tot-geral = de-base-is-tot-geral + de-base-is.
                /* %IS */
                RUN piCriaDadosItem (INPUT "##0,00",
                                     INPUT de-aliq-is).
                /* Aliq Espec UN */
                RUN piCriaDadosItem (INPUT "##0,00",
                                     INPUT de-aliq-espec-is).
                /* Qtde Trib IS*/
                RUN piCriaDadosItem (INPUT "####.###.##0,0000",
                                     INPUT de-qtde-tribut-is).
                /* UN Trib IS */
                RUN piCriaDadosItem (INPUT c-formato-char,
                                     INPUT c-un-tribut-is).
                /* Valor IS */
                RUN piCriaDadosItem (INPUT "####.###.##0,00",
                                     INPUT de-val-is).   
                ASSIGN de-val-is-tot-geral = de-val-is-tot-geral + de-val-is.
            END.
            
            /* Processo Imp */
            RUN piCriaDadosItem (INPUT c-formato-char,
                                 INPUT processo-imp.nr-proc-imp).
            /* Pedido */
            RUN piCriaDadosItem (INPUT "##.###.###",
                                 INPUT item-doc-est.num-pedido).
            /* Ordem Compra */
            RUN piCriaDadosItem (INPUT "##.###.###",
                                 INPUT item-doc-est.numero-ordem).
            /* Nr Adiá∆o */
            RUN piCriaDadosItem (INPUT "####",
                                 INPUT i-num-adicao).
            /* Taxa Siscomex */
            RUN piCriaDadosItem (INPUT "#####.###.##0,00000",
                                 INPUT de-taxa-siscomex).
            /* Total Despesas */
            RUN piCriaDadosItem (INPUT "#####.###.##0,00000",
                                 INPUT de-val-tot-desp-item).

            ASSIGN de-preco-total-me         = 0
                   de-peso-bruto             = 0
                   de-peso-liq-unit          = 0
                   de-val-desp-ii            = 0
                   de-val-pis                = 0
                   de-val-cofins             = 0.

            /****   Config Tributos  *****/
            RUN piDadosConfigTributos.

        END.
    END.
	
    IF VALID-HANDLE(h-cdapi995) THEN DO:
        DELETE PROCEDURE h-cdapi995.
        ASSIGN h-cdapi995 = ?.
	END.	

    FIND FIRST historico-embarque 
         WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel 
           AND historico-embarque.embarque    = embarque-imp.embarque NO-LOCK NO-ERROR.
    
    ASSIGN i-cod-itiner = historico-embarque.cod-itiner.
    
    FIND FIRST itinerario WHERE itinerario.cod-itiner = i-cod-itiner NO-LOCK NO-ERROR.
    
    FIND FIRST historico-embarque
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
        
            /* Imposto de Importaá∆o */
            FOR EACH docum-est-cex 
               WHERE docum-est-cex.serie-docto       = tt-docum-est.serie-docto  
                 AND docum-est-cex.nro-docto         = tt-docum-est.nro-docto    
                 AND docum-est-cex.cod-emitente      = tt-docum-est.cod-emitente 
                 AND docum-est-cex.nat-operacao      = tt-docum-est.nat-operacao 
                 AND docum-est-cex.cod-desp          = i-cod-desp-ii NO-LOCK:
    
                FIND FIRST desp-imp WHERE desp-imp.cod-desp = docum-est-cex.cod-desp NO-LOCK NO-ERROR.
                
                FOR FIRST desp-embarque FIELDS(descricao)  NO-LOCK
                    WHERE desp-embarque.cod-estabel = tt-docum-est.cod-estabel
                      AND desp-embarque.embarque    = tt-docum-est.embarque
                      AND desp-embarque.cod-desp    = docum-est-cex.cod-desp:
                END.
    
                IF NOT AVAIL desp-imp THEN 
                    NEXT.
    
                RUN pi-retornarDescricao IN THIS-PROCEDURE (INPUT  "desp-imp.tipo":U,
                                                            INPUT  desp-imp.tipo,
                                                            OUTPUT c-tipo).
    
                ASSIGN l-inc-ii         = desp-imp.log-2
                       l-inc-ipi        = desp-imp.inc-base-ipi
                       l-inc-icms       = desp-imp.inc-base-icms
                       l-val-duplic     = desp-imp.inc-val-duplic
                       l-pis-valor      = desp-imp.log-incid-base-pis-val
                       l-pis-despesa    = desp-imp.log-incid-base-pis-despes
                       l-cofins-valor   = desp-imp.log-incid-base-cofins-val
                       l-cofins-despesa = desp-imp.log-incid-base-cofins-despes.
                
                CREATE tt-desp-nacion.                                                                          
                ASSIGN tt-desp-nacion.cod-desp       = docum-est-cex.cod-desp                                    
                       tt-desp-nacion.cod-emit-desp  = docum-est-cex.cod-emitente-desp     
                       tt-desp-nacion.descricao      = IF AVAIL desp-embarque AND desp-embarque.descricao <> "":U THEN desp-embarque.descricao ELSE desp-imp.descricao
                       tt-desp-nacion.sequencia      = 0                              
                       tt-desp-nacion.cod-cond-pag   = docum-est-cex.cod-cond-pag                                
                       tt-desp-nacion.mo-codigo      = docum-est-cex.mo-codigo                                   
                       tt-desp-nacion.val-desp-orig  = docum-est-cex.val-desp                                    
                       tt-desp-nacion.de-cotacao     = IF docum-est-cex.mo-codigo = 0 THEN 1 ELSE de-cotacao-dia-nota 
                       tt-desp-nacion.val-desp       = IF docum-est-cex.mo-codigo = 0 THEN docum-est-cex.val-desp
                                                       ELSE (docum-est-cex.val-desp * de-cotacao-dia-nota)  
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
                       l-cofins-despesa              = NO.
            END.
        END.
        
        ASSIGN de-cotacao-despesa = 0.
        
        FOR EACH historico-embarque 
           WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel 
             AND historico-embarque.embarque    = embarque-imp.embarque    
             AND historico-embarque.cod-itiner  = i-cod-itiner 
             AND historico-embarque.sequencia   <= i-seq-nacionalizacao NO-LOCK:
                 
            FOR EACH tt-desp-embarque 
               WHERE tt-desp-embarque.cod-estabel   = historico-embarque.cod-estabel 
                 AND tt-desp-embarque.embarque      = historico-embarque.embarque    
                 AND tt-desp-embarque.cod-itiner    = historico-embarque.cod-itiner  
                 AND tt-desp-embarque.cod-pto-contr = historico-embarque.cod-pto-contr NO-LOCK:
           
                IF tt-desp-embarque.cod-desp = i-cod-desp-ii THEN DO: 
                    NEXT.
                END.
                         
                FIND FIRST desp-imp WHERE desp-imp.cod-desp = tt-desp-embarque.cod-desp NO-LOCK NO-ERROR.
                
                IF NOT AVAIL desp-imp THEN DO:
                    NEXT.
                END.
                          
                IF NOT desp-imp.inc-val-frete AND
                   NOT desp-imp.inc-val-seguro AND 
                   NOT desp-imp.inc-val-embal AND
                   NOT desp-imp.inc-val-outras-desp THEN DO:
                    NEXT.
                END.

                RUN pi-retornarDescricao IN THIS-PROCEDURE (INPUT "desp-imp.tipo":U,
                                                            INPUT desp-imp.tipo,
                                                            OUTPUT c-tipo).

                ASSIGN l-inc-ii         = desp-imp.log-2
                       l-inc-ipi        = desp-imp.inc-base-ipi
                       l-inc-icms       = desp-imp.inc-base-icms
                       l-val-duplic     = desp-imp.inc-val-duplic
                       l-pis-valor      = desp-imp.log-incid-base-pis-val
                       l-pis-despesa    = desp-imp.log-incid-base-pis-despes
                       l-cofins-valor   = desp-imp.log-incid-base-cofins-val
                       l-cofins-despesa = desp-imp.log-incid-base-cofins-despes.

                FIND FIRST cotacao 
                     WHERE cotacao.mo-codigo   = tt-desp-embarque.mo-codigo 
                       AND cotacao.ano-periodo = string(year(tt-parametros.da-cotacao)) + string(month(tt-parametros.da-cotacao),"99") 
                       AND cotacao.cotacao[int(day(tt-parametros.da-cotacao))] <> 0 NO-LOCK NO-ERROR.

                IF AVAIL cotacao THEN
                    ASSIGN de-cotacao-despesa = cotacao.cotacao[int(day(tt-parametros.da-cotacao))].
                ELSE 
                    ASSIGN de-cotacao-despesa = 1.

                FIND FIRST tt-epc
                     WHERE tt-epc.cod-event     = "CalculoPrecoUnitario":U
                       AND tt-epc.cod-parameter = "AlteraCotacao":U NO-ERROR.
                
                IF  AVAIL tt-epc THEN
                     ASSIGN de-cotacao-despesa    = DEC(tt-epc.val-parameter).

                CREATE tt-desp-nacion.
                ASSIGN tt-desp-nacion.cod-desp       = tt-desp-embarque.cod-desp
                       tt-desp-nacion.descricao      = IF tt-desp-embarque.descricao <> "":U THEN tt-desp-embarque.descricao ELSE desp-imp.descricao
                       tt-desp-nacion.cod-emit-desp  = tt-desp-embarque.cod-emitente-desp 
                       tt-desp-nacion.sequencia      = historico-embarque.sequencia
                       tt-desp-nacion.cod-cond-pag   = tt-desp-embarque.cod-cond-pag
                       tt-desp-nacion.mo-codigo      = tt-desp-embarque.mo-codigo
                       tt-desp-nacion.val-desp-orig  = tt-desp-embarque.val-desp
                       tt-desp-nacion.de-cotacao     = IF tt-desp-embarque.mo-codigo = 0 THEN 1 ELSE de-cotacao-despesa
                       tt-desp-nacion.val-desp       = IF tt-desp-embarque.mo-codigo = 0 THEN tt-desp-embarque.val-desp
                                                       ELSE (tt-desp-embarque.val-desp * de-cotacao-despesa)
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
                       de-cotacao-despesa            = 0.           
            END.
        END.
    END.


    /* Aba: NOTA - Cabeáalho e Dados */
    {utp/ut-liter.i Embarque}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT c-formato-char,
                         INPUT embarque-imp.embarque).

    {utp/ut-liter.i DI}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT c-formato-char,
                         INPUT embarque-imp.declaracao-import).

    {utp/ut-liter.i Moeda}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT c-formato-char,
                         INPUT c-desc-moeda).

    {utp/ut-liter.i Fornecedor}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT c-formato-char,
                         INPUT c-desc-emitente).

    {utp/ut-liter.i Taxa_CÉmbio}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT "###.#0,00000000",
                         INPUT de-cotacao-dia-nota).

    {utp/ut-liter.i Nat_Operaá∆o}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT c-formato-char,
                         INPUT tt-parametros.nat-operacao).

    {utp/ut-liter.i Desc_Nat_Operaá∆o}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT c-formato-char,
                         INPUT c-desc-natur).

    {utp/ut-liter.i Incoterm}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT c-formato-char,
                         INPUT embarque-imp.cod-incoterm).

    {utp/ut-liter.i Total_ME}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT "####.###.##0,0000",
                         INPUT de-preco-tot-geral-me).

    {utp/ut-liter.i Total_MN}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT "####.###.##0,00",
                         INPUT de-preco-tot-geral-mn).

    {utp/ut-liter.i Peso_Bruto_Tot}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT "#####.##0,00000",
                         INPUT de-peso-bruto-tot-geral).

    {utp/ut-liter.i Peso_Liq_Tot}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT "#####.##0,00000",
                         INPUT de-peso-liq-tot-geral).

    {utp/ut-liter.i Base_II}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT "####.###.##0,00",
                         INPUT de-base-ii-tot-geral).
    
    {utp/ut-liter.i Valor_II}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT "####.###.##0,00",
                         INPUT de-val-desp-ii-tot-geral).

    {utp/ut-liter.i Base_IPI_Isento}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT "####.###.##0,00",
                         INPUT de-base-ipi-isen-geral).
    
    {utp/ut-liter.i Base_IPI_Outros}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT "####.###.##0,00",
                         INPUT de-base-ipi-out-geral).
    
    {utp/ut-liter.i Base_IPI_Trib}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT "####.###.##0,00",
                         INPUT de-base-ipi-trib-geral).
    
    {utp/ut-liter.i Valor_IPI}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT "####.###.##0,00",
                         INPUT de-val-ipi-tot-geral).

    {utp/ut-liter.i Base_ICMS_Isento}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    RUN piCriaDadosNota (INPUT "####.###.##0,00",
                         INPUT de-base-icm-isen-geral).

    {utp/ut-liter.i Base_ICMS_Outros}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    RUN piCriaDadosNota (INPUT "####.###.##0,00",
                         INPUT de-base-icm-out-geral).
    
    {utp/ut-liter.i Base_ICMS_Trib}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    RUN piCriaDadosNota (INPUT "####.###.##0,00",
                         INPUT de-base-icm-trib-geral).
    
    {utp/ut-liter.i Valor_ICMS}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT "####.###.##0,00",
                         INPUT de-val-icm-tot-geral).

    {utp/ut-liter.i Base_PIS}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT "####.###.##0,00",
                         INPUT de-base-pis-tot-geral).

    {utp/ut-liter.i Valor_PIS}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT "####.###.##0,00",
                         INPUT de-val-pis-tot-geral).

    {utp/ut-liter.i Base_COFINS}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT "####.###.##0,00",
                         INPUT de-base-cofins-tot-geral).

    {utp/ut-liter.i Valor_COFINS}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).

    RUN piCriaDadosNota (INPUT "####.###.##0,00",
                         INPUT de-val-cofins-tot-geral).

    IF l-nt2024002 THEN DO:
        RUN piCriaCabecalhoNota (INPUT c-formato-char,    INPUT "Base IBS UF":U).
        RUN piCriaDadosNota     (INPUT "####.###.##0,00", INPUT de-base-ibsuf-tot-geral).

        RUN piCriaCabecalhoNota (INPUT c-formato-char,    INPUT "Valor IBS UF":U).
        RUN piCriaDadosNota     (INPUT "####.###.##0,00", INPUT de-val-ibsuf-tot-geral).
        
        RUN piCriaCabecalhoNota (INPUT c-formato-char,    INPUT "Base IBS Mun":U).
        RUN piCriaDadosNota     (INPUT "####.###.##0,00", INPUT de-base-ibsmun-tot-geral).

        RUN piCriaCabecalhoNota (INPUT c-formato-char,    INPUT "Valor IBS Mun":U).
        RUN piCriaDadosNota     (INPUT "####.###.##0,00", INPUT de-val-ibsmun-tot-geral).
        
        RUN piCriaCabecalhoNota (INPUT c-formato-char,    INPUT "Base CBS":U).
        RUN piCriaDadosNota     (INPUT "####.###.##0,00", INPUT de-base-cbs-tot-geral).

        RUN piCriaCabecalhoNota (INPUT c-formato-char,    INPUT "Valor CBS":U).
        RUN piCriaDadosNota     (INPUT "####.###.##0,00", INPUT de-val-cbs-tot-geral).
        
        RUN piCriaCabecalhoNota (INPUT c-formato-char,    INPUT "Base IS":U).
        RUN piCriaDadosNota     (INPUT "####.###.##0,00", INPUT de-base-is-tot-geral).

        RUN piCriaCabecalhoNota (INPUT c-formato-char,    INPUT "Valor IS":U).
        RUN piCriaDadosNota     (INPUT "####.###.##0,00", INPUT de-val-is-tot-geral).
    END.
    
    /* Aba: Despesa - Cabeáalho */
    {utp/ut-liter.i Forn_Desp}
    RUN piCriaCabecalhoDespesa (INPUT c-formato-char,
                                INPUT RETURN-VALUE).
    {utp/ut-liter.i Nome_Abrev}
    RUN piCriaCabecalhoDespesa (INPUT c-formato-char,
                                INPUT RETURN-VALUE).
    {utp/ut-liter.i Despesa}
    RUN piCriaCabecalhoDespesa (INPUT c-formato-char,
                                INPUT RETURN-VALUE).
    {utp/ut-liter.i Descriá∆o}
    RUN piCriaCabecalhoDespesa (INPUT c-formato-char,
                                INPUT RETURN-VALUE).
    {utp/ut-liter.i Cond_Pgto}
    RUN piCriaCabecalhoDespesa (INPUT c-formato-char,
                                INPUT RETURN-VALUE).
    {utp/ut-liter.i Valor_Despesa}
    RUN piCriaCabecalhoDespesa (INPUT c-formato-char,
                                INPUT RETURN-VALUE).
    {utp/ut-liter.i Mo_Desp}
    RUN piCriaCabecalhoDespesa (INPUT c-formato-char,
                                INPUT RETURN-VALUE).
    {utp/ut-liter.i Valor_Orig}
    RUN piCriaCabecalhoDespesa (INPUT c-formato-char,
                                INPUT RETURN-VALUE).
    {utp/ut-liter.i Taxa_CÉmbio}
    RUN piCriaCabecalhoDespesa (INPUT c-formato-char,
                                INPUT RETURN-VALUE).
    {utp/ut-liter.i Dupl}
    RUN piCriaCabecalhoDespesa (INPUT c-formato-char,
                                INPUT RETURN-VALUE).
    {utp/ut-liter.i II}
    RUN piCriaCabecalhoDespesa (INPUT c-formato-char,
                                INPUT RETURN-VALUE).
    {utp/ut-liter.i IPI}
    RUN piCriaCabecalhoDespesa (INPUT c-formato-char,
                                INPUT RETURN-VALUE).
    {utp/ut-liter.i ICMS}
    RUN piCriaCabecalhoDespesa (INPUT c-formato-char,
                                INPUT RETURN-VALUE).
    {utp/ut-liter.i PIS_VL_ADU}
    RUN piCriaCabecalhoDespesa (INPUT c-formato-char,
                                INPUT RETURN-VALUE).
    {utp/ut-liter.i PIS_DESP}
    RUN piCriaCabecalhoDespesa (INPUT c-formato-char,
                                INPUT RETURN-VALUE).
    {utp/ut-liter.i COFINS_ADU}
    RUN piCriaCabecalhoDespesa (INPUT c-formato-char,
                                INPUT RETURN-VALUE).
    {utp/ut-liter.i COFINS_DESP}
    RUN piCriaCabecalhoDespesa (INPUT c-formato-char,
                                INPUT RETURN-VALUE).
    IF l-nt2024002 THEN DO:
        RUN piCriaCabecalhoDespesa (INPUT c-formato-char, INPUT "IBS UF":U).
        RUN piCriaCabecalhoDespesa (INPUT c-formato-char, INPUT "IBS Mun":U).
        RUN piCriaCabecalhoDespesa (INPUT c-formato-char, INPUT "CBS VL ADU":U).
        RUN piCriaCabecalhoDespesa (INPUT c-formato-char, INPUT "IS":U).
    END.
    
    {utp/ut-liter.i Tipo}
    RUN piCriaCabecalhoDespesa (INPUT c-formato-char,
                                INPUT RETURN-VALUE).

    /* Aba Despesas - Dados */
    FOR EACH tt-desp-nacion BREAK BY tt-desp-nacion.cod-emit-desp
                                  BY tt-desp-nacion.sequencia:
        ASSIGN i-coluna-despesa = 0
               i-linha-despesa  = i-linha-despesa + 1.

        FIND emitente WHERE emitente.cod-emitente = tt-desp-nacion.cod-emit-desp NO-LOCK NO-ERROR.

        /* Forn Desp */
        RUN piCriaDadosDespesa (INPUT c-formato-char,
                                INPUT tt-desp-nacion.cod-emit-desp).
        /* Nome Abrev */
        RUN piCriaDadosDespesa (INPUT c-formato-char,
                                INPUT emitente.nome-abrev).
        /* Despesa */
        RUN piCriaDadosDespesa (INPUT c-formato-char,
                                INPUT tt-desp-nacion.cod-desp).
        /* Descriá∆o */
        RUN piCriaDadosDespesa (INPUT c-formato-char,
                                INPUT tt-desp-nacion.descricao).
        /* Cond Pagto */
        RUN piCriaDadosDespesa (INPUT c-formato-char,
                                INPUT tt-desp-nacion.cod-cond-pag).
        /* Valor Despesa */
        RUN piCriaDadosDespesa (INPUT "#####.###.##0,00000",
                                INPUT tt-desp-nacion.val-desp).
        /* Mo Desp */
        RUN piCriaDadosDespesa (INPUT c-formato-char,
                                INPUT tt-desp-nacion.mo-codigo).
        /* Valor Orig */
        RUN piCriaDadosDespesa (INPUT "#####.###.##0,00000",
                                INPUT tt-desp-nacion.val-desp-orig).
        /* Taxa de CÉmbrio */
        RUN piCriaDadosDespesa (INPUT "###.#0,00000000",
                                INPUT tt-desp-nacion.de-cotacao).
        /* Dupl */
        RUN piCriaDadosDespesa (INPUT c-formato-char,
                                INPUT IF tt-desp-nacion.val-duplic THEN c-sim ELSE c-nao).
        /* II */
        RUN piCriaDadosDespesa (INPUT c-formato-char,
                                INPUT IF tt-desp-nacion.inc-ii THEN c-sim ELSE c-nao).
        /* IPI */
        RUN piCriaDadosDespesa (INPUT c-formato-char,
                                INPUT IF tt-desp-nacion.inc-ipi THEN c-sim ELSE c-nao).
        /* ICMS */
        RUN piCriaDadosDespesa (INPUT c-formato-char,
                                INPUT IF tt-desp-nacion.inc-icms THEN c-sim ELSE c-nao).
        /* PIS VL ADU */
        RUN piCriaDadosDespesa (INPUT c-formato-char,
                                INPUT IF tt-desp-nacion.pis-valor THEN c-sim ELSE c-nao).
        /* PIS DESP */
        RUN piCriaDadosDespesa (INPUT c-formato-char,
                                INPUT IF tt-desp-nacion.pis-despesa THEN c-sim ELSE c-nao).
        /* COFINS ADU */
        RUN piCriaDadosDespesa (INPUT c-formato-char,
                                INPUT IF tt-desp-nacion.cofins-valor THEN c-sim ELSE c-nao).
        /* COFINS DESP */
        RUN piCriaDadosDespesa (INPUT c-formato-char,
                                INPUT IF tt-desp-nacion.cofins-despesa THEN c-sim ELSE c-nao).
        IF l-nt2024002 THEN DO:
            FIND FIRST desp-imp-trib WHERE desp-imp-trib.cod-desp = tt-desp-nacion.cod-desp NO-LOCK NO-ERROR.
            /* IBS UF */
            RUN piCriaDadosDespesa (INPUT c-formato-char,
                                    INPUT IF AVAIL desp-imp-trib AND desp-imp-trib.log-incide-base-IBSUF THEN c-sim ELSE c-nao).
            /* IBS Mun */
            RUN piCriaDadosDespesa (INPUT c-formato-char,
                                    INPUT IF AVAIL desp-imp-trib AND desp-imp-trib.log-incide-base-IBSMun THEN c-sim ELSE c-nao).
            /* CBS VL ADU */
            RUN piCriaDadosDespesa (INPUT c-formato-char,
                                    INPUT IF AVAIL desp-imp-trib AND desp-imp-trib.log-incide-base-CBS-vladu THEN c-sim ELSE c-nao).
            /* IS */
            RUN piCriaDadosDespesa (INPUT c-formato-char,
                                    INPUT IF AVAIL desp-imp-trib AND desp-imp-trib.log-incide-base-IS THEN c-sim ELSE c-nao).
        END.
        
        /* TIPO */
        RUN piCriaDadosDespesa (INPUT c-formato-char,
                                INPUT tt-desp-nacion.tipo).
    
        ASSIGN de-val-tot-desp = de-val-tot-desp + tt-desp-nacion.val-desp.
    END.

    /* Este campo Ç da aba de Nota - Total de Despesas */
    {utp/ut-liter.i Total_Despesas}
    RUN piCriaCabecalhoNota (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
       
    RUN piCriaDadosNota (INPUT "#####.###.##0,00000",
                         INPUT de-val-tot-desp).

    /***************************************************/
    /* ponto UPC VIPAL - criar coluna valor total nota */ 
    /***************************************************/
    IF  c-nom-prog-dpc-mg97  <> "" OR 
        c-nom-prog-appc-mg97 <> "" OR
        c-nom-prog-upc-mg97  <> "" THEN DO:

        for each tt-epc where tt-epc.cod-event = "manipula-im0100brp":
            delete tt-epc.
        end.
        
        create tt-epc.
        assign tt-epc.cod-event     = "manipula-im0100brp"
               tt-epc.cod-parameter = "handle-tt-dados"
               tt-epc.val-parameter = string(TEMP-TABLE tt-dados:HANDLE).

        create tt-epc.
        assign tt-epc.cod-event     = "manipula-im0100brp"
               tt-epc.cod-parameter = "handle-tt-planilha2"
               tt-epc.val-parameter = string(TEMP-TABLE tt-planilha2:HANDLE).
        
        create tt-epc.
        assign tt-epc.cod-event     = "manipula-im0100brp"
               tt-epc.cod-parameter = "handle-im0100brp.p"
               tt-epc.val-parameter = string(THIS-PROCEDURE:HANDLE).
        
        {include/i-epc201.i "manipula-im0100brp"}
    END.
    /***************************************************/
    /* ponto UPC VIPAL - criar coluna valor total nota */ 
    /***************************************************/    
                         
    ASSIGN i-coluna-item = 0.

    /* Aba: Item - Cabeáalho */
    {utp/ut-liter.i Seq}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Item}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Descriá∆o}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Class_Fiscal}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Desc_Class_Fiscal}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Qtde}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Valor_Unit}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Total_ME}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Total_MN}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Peso_Bruto_Tot}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Peso_Liq_Unit}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Peso_Liq_Tot}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i II}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Base_II}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i %II}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Valor_II}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i IPI}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Base_IPI}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i %IPI}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Valor_IPI}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i ICMS}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Base_ICMS}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i %ICMS}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Valor_ICMS}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i PIS}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Base_PIS}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i %PIS}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Valor_PIS}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i COFINS}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Base_COFINS}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i %COFINS}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Valor_COFINS}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    IF l-nt2024002 THEN DO:
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Class Trib IBS UF":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "CST IBS UF":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "IBS UF":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Base IBS UF":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "%IBS UF":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "%RED IBS UF":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Valor IBS UF":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Class Trib Reg IBS UF":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "CST Reg IBS UF":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Base Trib Reg IBS UF":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "%Trib Reg IBS UF":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Valor Trib Reg IBS UF":U).
        
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Class Trib IBS Mun":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "CST IBS Mun":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "IBS Mun":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Base IBS Mun":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "%IBS Mun":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "%RED IBS Mun":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Valor IBS Mun":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Class Trib Reg IBS Mun":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "CST Reg IBS Mun":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Base Trib Reg IBS Mun":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "%Trib Reg IBS Mun":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Valor Trib Reg IBS Mun":U).
        
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Class Trib CBS":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "CST CBS":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "CBS":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Base CBS":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "%CBS":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "%RED CBS":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Valor CBS":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Class Trib Reg CBS":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "CST Reg CBS":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Base Trib Reg CBS":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "%Trib Reg CBS":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Valor Trib Reg CBS":U).
    
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Class Trib IS":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "CST IS":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "IS":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Base IS":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "%IS":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Aliq Espec UN":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Qtde Trib IS":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "UN Trib IS":U).
        RUN piCriaCabecalhoItem (INPUT c-formato-char, INPUT "Valor IS":U).
    END.
    
    {utp/ut-liter.i Processo_Imp}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Pedido}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Ordem_Compra}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Nr_Adiá∆o}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Taxa_Siscomex}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    {utp/ut-liter.i Total_Despesas}
    RUN piCriaCabecalhoItem (INPUT c-formato-char,
                             INPUT RETURN-VALUE).
    
    ASSIGN i-coluna-desp-item = 0.

    /* Aba: Despesas Itens - Cabeáalho */
    {utp/ut-liter.i Seq}
    RUN piCriaCabecalhoDespItem (INPUT c-formato-char,
                                 INPUT RETURN-VALUE).
    {utp/ut-liter.i Item}
    RUN piCriaCabecalhoDespItem (INPUT c-formato-char,
                                 INPUT RETURN-VALUE).
    {utp/ut-liter.i Descriá∆o}
    RUN piCriaCabecalhoDespItem (INPUT c-formato-char,
                                 INPUT RETURN-VALUE).
    {utp/ut-liter.i Class_Fiscal}
    RUN piCriaCabecalhoDespItem (INPUT c-formato-char,
                                 INPUT RETURN-VALUE).
    {utp/ut-liter.i Desc_Class_Fiscal}
    RUN piCriaCabecalhoDespItem (INPUT c-formato-char,
                                 INPUT RETURN-VALUE).
    {utp/ut-liter.i Forn_Desp}
    RUN piCriaCabecalhoDespItem (INPUT c-formato-char,
                                 INPUT RETURN-VALUE).
    {utp/ut-liter.i Nome_Abrev}
    RUN piCriaCabecalhoDespItem (INPUT c-formato-char,
                                 INPUT RETURN-VALUE).
    {utp/ut-liter.i Despesa}
    RUN piCriaCabecalhoDespItem (INPUT c-formato-char,
                                 INPUT RETURN-VALUE).
    {utp/ut-liter.i Descriá∆o}
    RUN piCriaCabecalhoDespItem (INPUT c-formato-char,
                                 INPUT RETURN-VALUE).
    {utp/ut-liter.i Valor_Despesa}
    RUN piCriaCabecalhoDespItem (INPUT c-formato-char,
                                 INPUT RETURN-VALUE).
    
    
    /****** Aba Config Tributos - Cabeáalho ******/
    ASSIGN i-coluna-config = 0.
    {utp/ut-liter.i Emitente}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i SÇrie}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i Nota_Fiscal}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i Nat_Oper}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i Seq}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i Item }
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i Tipo_Tributo}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i Configuraá∆o_Tributo}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i Aliq}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i Base_Calc_Tributo}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i Val_Tributo}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i Cod_Tributaá∆o}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i Perc_Reduá∆o}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i Quant_de_Valor_Fixo}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i Valor_Fixo}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i Situaá∆o_Tributo}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i Cod_Formula_Base_Calc}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i Chave_Cen†rio}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i F¢rmula_Calc_Tributo}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i Mem¢ria_C†lculo_F¢rmula_Tributo}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i F¢rmula_Base_Calc_Tributo}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).
    {utp/ut-liter.i Mem¢ria_F¢rmula_Base_Calc_Tributo}
    RUN piCriaCabecalhoConfig (INPUT c-formato-char,
                               INPUT RETURN-VALUE).

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piCriaCabecalhoNota:
/********************************************************************************
    Procedure responsavel por criar o cabelho para Nota
********************************************************************************/
    DEFINE INPUT PARAMETER pcFormato  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcValor    AS CHARACTER NO-UNDO.
    
    CREATE tt-dados.
    ASSIGN i-coluna-nota                          = i-coluna-nota + 1
           tt-dados.arquivo-num                   = i-num-arquivo
           tt-dados.planilha-num                  = i-planilha-nota
           tt-dados.celula-linha                  = i-linha-cabecalho
           tt-dados.celula-coluna                 = i-coluna-nota
           tt-dados.celula-valor                  = pcValor
           tt-dados.celula-fonte-negrito          = YES 
           tt-dados.celula-fonte-tamanho          = 11
           tt-dados.celula-fonte-nome             = "Calibri":U
           tt-dados.celula-formato                = pcFormato
           tt-dados.celula-alinhamento-horizontal = 4
           tt-dados.celula-tipo-borda-sup         = 01
           tt-dados.celula-tipo-borda-inf         = 01
           tt-dados.celula-tipo-borda-esq         = 01
           tt-dados.celula-tipo-borda-dir         = 01.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piCriaDadosNota:
/********************************************************************************
    Procedure responsavel por criar os dados para Nota
********************************************************************************/
    DEFINE INPUT PARAMETER pcFormato   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcValor     AS CHARACTER NO-UNDO.
    
    CREATE tt-dados.
    ASSIGN tt-dados.arquivo-num           = i-num-arquivo
           tt-dados.planilha-num          = i-planilha-nota
           tt-dados.celula-linha          = i-planilha-nota + 1
           tt-dados.celula-coluna         = i-coluna-nota
           tt-dados.celula-fonte-tamanho  = 11
           tt-dados.celula-fonte-nome     = "Calibri":U
           tt-dados.celula-formato        = pcFormato
           tt-dados.celula-valor          = pcValor
           tt-dados.celula-tipo-borda-sup = 01
           tt-dados.celula-tipo-borda-inf = 01
           tt-dados.celula-tipo-borda-esq = 01
           tt-dados.celula-tipo-borda-dir = 01.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piCriaCabecalhoDespesa:
/********************************************************************************
    Procedure responsavel por criar o cabelho para Despesa
********************************************************************************/
    DEFINE INPUT PARAMETER pcFormato  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcValor    AS CHARACTER NO-UNDO.
    
    CREATE tt-dados.
    ASSIGN i-coluna-despesa                       = i-coluna-despesa + 1
           tt-dados.arquivo-num                   = i-num-arquivo
           tt-dados.planilha-num                  = i-planilha-despesa
           tt-dados.celula-linha                  = i-linha-cabecalho
           tt-dados.celula-coluna                 = i-coluna-despesa
           tt-dados.celula-valor                  = pcValor
           tt-dados.celula-fonte-negrito          = YES
           tt-dados.celula-fonte-tamanho          = 11
           tt-dados.celula-fonte-nome             = "Calibri":U
           tt-dados.celula-formato                = pcFormato
           tt-dados.celula-alinhamento-horizontal = 4
           tt-dados.celula-tipo-borda-sup         = 01
           tt-dados.celula-tipo-borda-inf         = 01
           tt-dados.celula-tipo-borda-esq         = 01
           tt-dados.celula-tipo-borda-dir         = 01.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piCriaDadosDespesa:
/********************************************************************************
    Procedure responsavel por criar os dados para Despesa
********************************************************************************/
    DEFINE INPUT PARAMETER pcFormato   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcValor     AS CHARACTER NO-UNDO.
    
    CREATE tt-dados.
    ASSIGN i-coluna-despesa               = i-coluna-despesa + 1
           tt-dados.arquivo-num           = i-num-arquivo
           tt-dados.planilha-num          = i-planilha-despesa
           tt-dados.celula-linha          = i-linha-despesa
           tt-dados.celula-coluna         = i-coluna-despesa        
           tt-dados.celula-fonte-tamanho  = 11
           tt-dados.celula-fonte-nome    = "Calibri":U  
           tt-dados.celula-formato        = pcFormato
           tt-dados.celula-valor          = pcValor
           tt-dados.celula-tipo-borda-sup = 01
           tt-dados.celula-tipo-borda-inf = 01
           tt-dados.celula-tipo-borda-esq = 01
           tt-dados.celula-tipo-borda-dir = 01.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piCriaCabecalhoItem:
/********************************************************************************
    Procedure responsavel por criar o cabelho para o Item
********************************************************************************/
    DEFINE INPUT PARAMETER pcFormato  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcValor    AS CHARACTER NO-UNDO.
    
    CREATE tt-dados.
    ASSIGN i-coluna-item                          = i-coluna-item + 1
           tt-dados.arquivo-num                   = i-num-arquivo
           tt-dados.planilha-num                  = i-planilha-itens
           tt-dados.celula-linha                  = i-linha-cabecalho
           tt-dados.celula-coluna                 = i-coluna-item
           tt-dados.celula-valor                  = pcValor
           tt-dados.celula-fonte-negrito          = YES
           tt-dados.celula-fonte-tamanho          = 11
           tt-dados.celula-fonte-nome             = "Calibri":U
           tt-dados.celula-formato                = pcFormato
           tt-dados.celula-alinhamento-horizontal = 4
           tt-dados.celula-tipo-borda-sup         = 01
           tt-dados.celula-tipo-borda-inf         = 01
           tt-dados.celula-tipo-borda-esq         = 01
           tt-dados.celula-tipo-borda-dir         = 01.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piCriaDadosItem:
/********************************************************************************
    Procedure responsavel por criar os dados para o Item
********************************************************************************/
    DEFINE INPUT PARAMETER pcFormato   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcValor     AS CHARACTER NO-UNDO.
    
    CREATE tt-dados.
    ASSIGN i-coluna-item                  = i-coluna-item + 1
           tt-dados.arquivo-num           = i-num-arquivo
           tt-dados.planilha-num          = i-planilha-itens
           tt-dados.celula-linha          = i-linha-item
           tt-dados.celula-coluna         = i-coluna-item       
           tt-dados.celula-fonte-tamanho  = 11
           tt-dados.celula-fonte-nome    = "Calibri":U  
           tt-dados.celula-formato        = pcFormato
           tt-dados.celula-valor          = pcValor
           tt-dados.celula-tipo-borda-sup = 01
           tt-dados.celula-tipo-borda-inf = 01
           tt-dados.celula-tipo-borda-esq = 01
           tt-dados.celula-tipo-borda-dir = 01.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piCriaCabecalhoDespItem:
/********************************************************************************
    Procedure responsavel por criar o cabelho para Despesas dos Itens
********************************************************************************/
    DEFINE INPUT PARAMETER pcFormato  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcValor    AS CHARACTER NO-UNDO.
    
    CREATE tt-dados.
    ASSIGN i-coluna-desp-item                     = i-coluna-desp-item + 1
           tt-dados.arquivo-num                   = i-num-arquivo
           tt-dados.planilha-num                  = i-planilha-desp-itens
           tt-dados.celula-linha                  = i-linha-cabecalho
           tt-dados.celula-coluna                 = i-coluna-desp-item
           tt-dados.celula-valor                  = pcValor
           tt-dados.celula-fonte-negrito          = YES
           tt-dados.celula-fonte-tamanho          = 11
           tt-dados.celula-fonte-nome             = "Calibri":U
           tt-dados.celula-formato                = pcFormato
           tt-dados.celula-alinhamento-horizontal = 4
           tt-dados.celula-tipo-borda-sup         = 01
           tt-dados.celula-tipo-borda-inf         = 01
           tt-dados.celula-tipo-borda-esq         = 01
           tt-dados.celula-tipo-borda-dir         = 01.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piCriaDadosDespItem:
/********************************************************************************
    Procedure responsavel por criar os dados para Despesas dos Itens
********************************************************************************/
    DEFINE INPUT PARAMETER pcFormato   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcValor     AS CHARACTER NO-UNDO.
    
    CREATE tt-dados.
    ASSIGN i-coluna-desp-item             = i-coluna-desp-item + 1
           tt-dados.arquivo-num           = i-num-arquivo
           tt-dados.planilha-num          = i-planilha-desp-itens
           tt-dados.celula-linha          = i-linha-desp-item
           tt-dados.celula-coluna         = i-coluna-desp-item       
           tt-dados.celula-fonte-tamanho  = 11
           tt-dados.celula-fonte-nome    = "Calibri":U  
           tt-dados.celula-formato        = pcFormato
           tt-dados.celula-valor          = pcValor
           tt-dados.celula-tipo-borda-sup = 01
           tt-dados.celula-tipo-borda-inf = 01
           tt-dados.celula-tipo-borda-esq = 01
           tt-dados.celula-tipo-borda-dir = 01.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piCriaCabecalhoConfig:
/********************************************************************************
    Procedure responsavel por criar o cabelho para Config Tributos
********************************************************************************/
    DEFINE INPUT PARAMETER pcFormato  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcValor    AS CHARACTER NO-UNDO.
    
    CREATE tt-dados.
    ASSIGN i-coluna-config                        = i-coluna-config + 1
           tt-dados.arquivo-num                   = i-num-arquivo
           tt-dados.planilha-num                  = i-planilha-config
           tt-dados.celula-linha                  = i-linha-cabecalho
           tt-dados.celula-coluna                 = i-coluna-config
           tt-dados.celula-valor                  = pcValor
           tt-dados.celula-fonte-negrito          = YES
           tt-dados.celula-fonte-tamanho          = 11
           tt-dados.celula-fonte-nome             = "Calibri":U
           tt-dados.celula-formato                = pcFormato
           tt-dados.celula-alinhamento-horizontal = 4
           tt-dados.celula-tipo-borda-sup         = 01
           tt-dados.celula-tipo-borda-inf         = 01
           tt-dados.celula-tipo-borda-esq         = 01
           tt-dados.celula-tipo-borda-dir         = 01.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piCriaDadosConfig:
/********************************************************************************
    Procedure responsavel por criar os dados para Config Tributos
********************************************************************************/
    DEFINE INPUT PARAMETER pcFormato   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcValor     AS CHARACTER NO-UNDO.
    
    CREATE tt-dados.
    ASSIGN i-coluna-config                = i-coluna-config + 1
           tt-dados.arquivo-num           = i-num-arquivo
           tt-dados.planilha-num          = i-planilha-config
           tt-dados.celula-linha          = i-linha-config
           tt-dados.celula-coluna         = i-coluna-config       
           tt-dados.celula-fonte-tamanho  = 11
           tt-dados.celula-fonte-nome    = "Calibri":U  
           tt-dados.celula-formato        = pcFormato
           tt-dados.celula-valor          = pcValor
           tt-dados.celula-tipo-borda-sup = 01
           tt-dados.celula-tipo-borda-inf = 01
           tt-dados.celula-tipo-borda-esq = 01
           tt-dados.celula-tipo-borda-dir = 01.

    RETURN "OK":U.
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

PROCEDURE pi-retornarDescricao:
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
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piDespesasItem:

    ASSIGN de-val-tot-desp-item = 0.
    FOR EACH item-doc-est-cex 
        WHERE item-doc-est-cex.serie-docto  = item-doc-est.serie-docto 
        AND   item-doc-est-cex.nro-docto    = item-doc-est.nro-docto   
        AND   item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente 
        AND   item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao 
        AND   item-doc-est-cex.sequencia    = item-doc-est.sequencia NO-LOCK:
        
        IF item-doc-est-cex.cod-desp = i-desp-ii
        OR item-doc-est-cex.cod-desp = param-imp.cdn-despes-siscomex THEN NEXT.

        FIND emitente WHERE emitente.cod-emitente = item-doc-est-cex.cod-emitente-desp NO-LOCK NO-ERROR.
        
        FIND FIRST desp-imp WHERE desp-imp.cod-desp = item-doc-est-cex.cod-desp NO-LOCK NO-ERROR.
        IF NOT AVAIL desp-imp THEN NEXT.
        
        FOR FIRST desp-embarque FIELDS(descricao)  NO-LOCK
            WHERE desp-embarque.cod-estabel = tt-docum-est.cod-estabel
              AND desp-embarque.embarque    = tt-docum-est.embarque
              AND desp-embarque.cod-desp    = item-doc-est-cex.cod-desp:
        END.
        
        ASSIGN i-coluna-desp-item = 0
               i-linha-desp-item  = i-linha-desp-item + 1.

        /* Seq */
        RUN piCriaDadosDespItem (INPUT "#####":U,
                                 INPUT item-doc-est.sequencia).
        /* Item */
        RUN piCriaDadosDespItem (INPUT c-formato-char,
                                 INPUT item-doc-est.it-codigo).
        /* Descriá∆o */
        RUN piCriaDadosDespItem (INPUT c-formato-char,
                                 INPUT c-desc-item).
        /* Class Fiscal */
        RUN piCriaDadosDespItem (INPUT c-formato-char,
                                 INPUT STRING(item-doc-est.class-fiscal, "9999.99.99")).
        /* Descriá∆o Class Fiscal */
        RUN piCriaDadosDespItem (INPUT c-formato-char,
                                 INPUT c-desc-class-fisc).
        /* Forn Desp */
        RUN piCriaDadosDespItem (INPUT c-formato-char,
                                 INPUT item-doc-est-cex.cod-emitente-desp).
        /* Nome Abrev */
        RUN piCriaDadosDespItem (INPUT c-formato-char,
                                 INPUT IF AVAIL emitente THEN emitente.nome-abrev ELSE "":U).
        /* Despesa */
        RUN piCriaDadosDespItem (INPUT c-formato-char,
                                 INPUT item-doc-est-cex.cod-desp).
        /* Descriá∆o */
        RUN piCriaDadosDespItem (INPUT c-formato-char,
                                 INPUT IF AVAIL desp-embarque AND desp-embarque.descricao <> "":U THEN desp-embarque.descricao ELSE desp-imp.descricao).
        /* Valor Despesa */
        RUN piCriaDadosDespItem (INPUT "#####.###.##0,00000":U,
                                 INPUT item-doc-est-cex.val-desp).

        ASSIGN de-val-tot-desp-item = de-val-tot-desp-item + item-doc-est-cex.val-desp.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE piDadosConfigTributos:

    FOR EACH ct-trib-item-doc-est NO-LOCK
       WHERE ct-trib-item-doc-est.cdn-emitente     = item-doc-est.cod-emitente
         AND ct-trib-item-doc-est.cod-ser-docto    = item-doc-est.serie-docto
         AND ct-trib-item-doc-est.cod-docto        = item-doc-est.nro-docto
         AND ct-trib-item-doc-est.cod-natur-operac = item-doc-est.nat-operacao
         AND ct-trib-item-doc-est.num-seq          = item-doc-est.sequencia:

        ASSIGN i-coluna-config = 0
               i-linha-config  = i-linha-config + 1.

        /* Emitente */
        RUN piCriaDadosConfig (INPUT c-formato-char,
                               INPUT ct-trib-item-doc-est.cdn-emitente).
        /* SÇrie */
        RUN piCriaDadosConfig (INPUT c-formato-char,
                               INPUT ct-trib-item-doc-est.cod-ser-docto).
        /* Nota Fiscal */
        RUN piCriaDadosConfig (INPUT c-formato-char,
                               INPUT ct-trib-item-doc-est.cod-docto).
        /* Nat Oper */
        RUN piCriaDadosConfig (INPUT c-formato-char,
                               INPUT IF SUBSTR(ct-trib-item-doc-est.cod-livre-1,1,6) <> "":U
                                     THEN SUBSTR(ct-trib-item-doc-est.cod-livre-1,1,6)
                                     ELSE ct-trib-item-doc-est.cod-natur-operac).
        /* Seq */
        RUN piCriaDadosConfig (INPUT "#####":U,
                               INPUT ct-trib-item-doc-est.num-seq).
        /* Item */
        RUN piCriaDadosConfig (INPUT c-formato-char,
                               INPUT ct-trib-item-doc-est.cod-item).
        /* Tipo Tributo */
        RUN piCriaDadosConfig (INPUT c-formato-char,
                               INPUT ct-trib-item-doc-est.cod-tip-trib).
        /* Configuraá∆o Tributo */
        RUN piCriaDadosConfig (INPUT c-formato-char,
                               INPUT ct-trib-item-doc-est.cod-configur-trib).
        /* Aliq */
        RUN piCriaDadosConfig (INPUT "###0,00":U,
                               INPUT ct-trib-item-doc-est.val-aliq).
        /* Base Calc. Tributo */
        RUN piCriaDadosConfig (INPUT "###.###.###.##0,00":U,
                               INPUT ct-trib-item-doc-est.val-base).
        /* Val Tributo */
        RUN piCriaDadosConfig (INPUT "###.###.###.##0,00":U,
                               INPUT ct-trib-item-doc-est.val-trib).
        /* Cod Tributaá∆o */
        RUN piCriaDadosConfig (INPUT c-formato-char,
                               INPUT SUBSTRING({diinc/i01di628.i 04 INT(ct-trib-item-doc-est.idi-cod-tributac)},1,1) ).
        /* Perc Reduá∆o */
        RUN piCriaDadosConfig (INPUT "###0,00":U,
                               INPUT ct-trib-item-doc-est.val-perc-reduc).
        /* Quant de Valor Fixo */
        RUN piCriaDadosConfig (INPUT "##.###.###.##0,00":U,
                               INPUT ct-trib-item-doc-est.val-quant-fix).
        /* Valor Fixo */
        RUN piCriaDadosConfig (INPUT "##.###.###.##0,00":U,
                               INPUT ct-trib-item-doc-est.val-fix-trib).
        /* Situaá∆o Tributo */
        RUN piCriaDadosConfig (INPUT c-formato-char,
                               INPUT ct-trib-item-doc-est.cod-sit-tributar).
        /* Cod Formula Base Calc */
        RUN piCriaDadosConfig (INPUT c-formato-char,
                               INPUT ct-trib-item-doc-est.cod-formul-base-calc).
        /* Chave Cen†rio */
        RUN piCriaDadosConfig (INPUT c-formato-char,
                               INPUT ct-trib-item-doc-est.cod-chave-cenar).
        
        ASSIGN c-cod-formul-trib = ""
               c-cod-formul-base-calc = "".
        FOR FIRST ct-configur-trib no-lock
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
        /* F¢rmula Calc Tributo */
        RUN piCriaDadosConfig (INPUT c-formato-char,
                               INPUT c-cod-formul-trib).
        /* Mem¢ria C†lculo F¢rmula Tributo */
        RUN piCriaDadosConfig (INPUT c-formato-char,
                               INPUT ct-trib-item-doc-est.cod-memo-calc-trib).
        /* F¢rmula Calc Base Calc Tributo */
        RUN piCriaDadosConfig (INPUT c-formato-char,
                               INPUT c-cod-formul-base-calc).
        /* Mem¢ria C†lculo F¢rmula Base Calc Tributo */
        RUN piCriaDadosConfig (INPUT c-formato-char,
                               INPUT ct-trib-item-doc-est.cod-memo-calc-base).
    END.

    RETURN "OK":U.
END PROCEDURE.
