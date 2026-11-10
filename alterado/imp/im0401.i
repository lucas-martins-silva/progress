/************************************************************************************************************
**
** IM0401.I - Definicoes de temp-tables, vari veis e buffers
**
************************************************************************************************************/
{include/i_dbvers.i}

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

DEFINE TEMP-TABLE  tt-param
    FIELD destino                AS INTEGER 
    FIELD arquivo                AS CHARACTER FORMAT "X(80)"
    FIELD usuario                AS CHARACTER FORMAT "X(20)"
    FIELD data-exec              AS DATE 
    FIELD hora-exec              AS INTEGER
    FIELD ep-codigo              LIKE empresa.ep-codigo
    /*faixa de selecao*/
    FIELD c-cod-estabel-ini      LIKE estabelec.cod-estabel
    FIELD c-cod-estabel-fim      LIKE estabelec.cod-estabel
    FIELD c-embarque-ini         LIKE embarque-imp.embarque
    FIELD c-embarque-fim         LIKE embarque-imp.embarque
    FIELD c-di-siscomex-ini      LIKE docum-est.declaracao-import 
    FIELD c-di-siscomex-fim      LIKE docum-est.declaracao-import 
    FIELD dt-nacionalizacao-ini  AS   DATE FORMAT "99/99/9999":U      
    FIELD dt-nacionalizacao-fim  AS   DATE FORMAT "99/99/9999":U      
    FIELD i-emitente-ini         LIKE emitente.cod-emitente
    FIELD i-emitente-fim         LIKE emitente.cod-emitente
    FIELD c-serie-ini            LIKE docum-est.serie-docto
    FIELD c-serie-fim            LIKE docum-est.serie-docto
    FIELD c-docto-ini            LIKE docum-est.nro-docto
    FIELD c-docto-fim            LIKE docum-est.nro-docto
    FIELD c-nat-operacao-ini     LIKE docum-est.nat-operacao
    FIELD c-nat-operacao-fim     LIKE docum-est.nat-operacao
    FIELD dt-emis-ini            AS   DATE FORMAT "99/99/9999":U
    FIELD dt-emis-fim            AS   DATE FORMAT "99/99/9999":U
    /*parametros*/
    FIELD i-moeda                LIKE moeda.mo-codigo
    FIELD desc-moeda             AS   CHARACTER 
    FIELD l-dt-nacionaliza       AS   LOGICAL FORMAT "Sim/NÆo"
    FIELD dt-conversao           AS   DATE
    FIELD l-somente-ce-atual     AS   LOGICAL FORMAT "Sim/NÆo"
    FIELD l-detalha-nfc          AS   LOGICAL FORMAT "Sim/NÆo"
    FIELD l-somente-nfc-ce-atual AS   LOGICAL FORMAT "Sim/NÆo"
    FIELD l-item                 AS   LOGICAL FORMAT "Sim/NÆo"
    FIELD l-despesas-item        AS   LOGICAL FORMAT "Sim/NÆo"
    FIELD l-despesa              AS   LOGICAL FORMAT "Sim/NÆo"
    FIELD l-duplicatas           AS   LOGICAL FORMAT "Sim/NÆo"
    FIELD l-itinerario           AS   LOGICAL FORMAT "Sim/NÆo"
    FIELD l-imprime-param        AS   LOGICAL FORMAT "Sim/NÆo".

DEF TEMP-TABLE tt-doc NO-UNDO
    FIELD serie-docto  LIKE docum-est.serie-docto
    FIELD nro-docto    LIKE docum-est.nro-docto
    FIELD cod-emitente LIKE docum-est.cod-emitente
    FIELD nat-operacao LIKE docum-est.nat-operacao
    FIELD num-pedido   LIKE pedido-compr.num-pedido
    FIELD sequencia    LIKE item-doc-est.sequencia
    FIELD tipo         AS   INTEGER. /* 1-Documento
                                        2-Item do Documento
                                        3-Duplicatas de despesas */

DEF TEMP-TABLE tt_log_erro NO-UNDO
    FIELD ttv_num_cod_erro  AS INTEGER   FORMAT ">>>>,>>9":U LABEL "N£mero"         COLUMN-LABEL "N£mero"
    FIELD ttv_des_msg_ajuda AS CHARACTER FORMAT "x(40)":U    LABEL "Mensagem Ajuda" COLUMN-LABEL "Mensagem Ajuda"
    FIELD ttv_des_msg_erro  AS CHARACTER FORMAT "x(60)":U    LABEL "Mensagem Erro"  COLUMN-LABEL "Inconsistˆncia"
    .

def temp-table tt-pedidos NO-UNDO
    field num-pedido LIKE pedido-compr.num-pedido
    field quantidade as integer.

DEFINE BUFFER b-historico-embarque  FOR historico-embarque.
DEFINE BUFFER bf-historico-embarque FOR historico-embarque.
DEFINE BUFFER bf-docum-est          FOR docum-est.
DEFINE BUFFER bf-item-doc-est       FOR item-doc-est.
DEFINE BUFFER bf-natur-oper         FOR natur-oper.
DEFINE BUFFER bf-emitente           FOR emitente.
DEFINE BUFFER bf-ordem-compra       FOR ordem-compra.
DEFINE BUFFER bf-ordens-embarque    FOR ordens-embarque.

DEFINE VARIABLE de-vl-frete                 LIKE item-doc-est-cex.val-desp                 NO-UNDO.
DEFINE VARIABLE de-vl-seguro                LIKE item-doc-est-cex.val-desp                 NO-UNDO.
DEFINE VARIABLE de-vl-embalagem             LIKE item-doc-est-cex.val-desp                 NO-UNDO.
DEFINE VARIABLE de-vl-outras                LIKE item-doc-est-cex.val-desp                 NO-UNDO.
DEFINE VARIABLE de-valor                    LIKE dupli-apagar.vl-a-pagar                   extent 10 NO-UNDO decimals 2 init 0.
DEFINE VARIABLE de-valor-dup                LIKE docum-est.tot-valor                       NO-UNDO.
DEFINE VARIABLE da-partida-dup              LIKE docum-est.dt-emissao                      NO-UNDO.
DEFINE VARIABLE de-valor-desp               LIKE docum-est.valor-mercad                    NO-UNDO.
DEFINE VARIABLE i-pedido                    LIKE pedido-compr.num-pedido                   NO-UNDO.
DEFINE VARIABLE i-cond                      LIKE cond-pagto.cod-cond-pag                   extent 6  NO-UNDO.
DEFINE VARIABLE de-valor-pagar              LIKE dupli-apagar.vl-a-pagar                   NO-UNDO.
DEFINE VARIABLE i-empresa                   LIKE empresa.ep-codigo                         NO-UNDO.
DEFINE VARIABLE i-numero-ordem              LIKE item-doc-est.numero-ordem                 NO-UNDO. 
DEFINE VARIABLE i-parcela                   LIKE item-doc-est.parcela                      NO-UNDO.
DEFINE VARIABLE de-pc-pis                   AS DEC FORMAT ">>9.9999":U                     NO-UNDO.
DEFINE VARIABLE de-pc-cofins                AS DEC FORMAT ">>9.9999":U                     NO-UNDO.
DEFINE VARIABLE c-embarque-orig             LIKE embarque-imp.embarque                     NO-UNDO.
DEFINE VARIABLE de-peso-bruto               LIKE docum-est.tot-peso                        NO-UNDO.
DEFINE VARIABLE c-embarque-imp              LIKE embarque-imp.embarque                     NO-UNDO.
DEFINE VARIABLE i-pto-solic-li              LIKE itinerario.cdn-pto-solic-licenciam-import NO-UNDO.
DEFINE VARIABLE i-cod-exportador            LIKE emitente.cod-emitente                     NO-UNDO.
DEFINE VARIABLE c-nome-abrev                LIKE emitente.nome-abrev                       NO-UNDO.
DEFINE VARIABLE i-mo-codigo                 LIKE cotacao-item.mo-codigo                    NO-UNDO.

DEFINE VARIABLE c-arq-digita                AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-terminal                  AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-arq-layout                AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-arq-temp                  AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-ct-codigo                 AS   CHARACTER FORMAT "x(20)":U                NO-UNDO.
DEFINE VARIABLE c-sc-codigo                 AS   CHARACTER FORMAT "x(20)":U                NO-UNDO.
DEFINE VARIABLE c-ct-transit                AS   CHARACTER FORMAT "x(20)":U                NO-UNDO.
DEFINE VARIABLE c-sc-transit                AS   CHARACTER FORMAT "x(20)":U                NO-UNDO.
DEFINE VARIABLE c-FORMATo-conta             AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-FORMATo-ccusto            AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-nota-simples-remessa      AS   CHARACTER FORMAT "x(10)":U                NO-UNDO. 
DEFINE VARIABLE c-gera-nf-mae-filha         AS   CHARACTER FORMAT "x(3)":U                 NO-UNDO.
DEFINE VARIABLE c-item-gera-nf-mae-filha    AS   CHARACTER FORMAT "x(3)":U                 NO-UNDO.
DEFINE VARIABLE c-tipo-contr                AS   CHARACTER FORMAT "x(15)":U                NO-UNDO.
DEFINE VARIABLE c-situacao                  AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-trib-ipi                  AS   CHARACTER FORMAT "x(10)":U                NO-UNDO.
DEFINE VARIABLE c-trib-iss                  AS   CHARACTER FORMAT "x(10)":U                NO-UNDO.
DEFINE VARIABLE c-trib-icm                  AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-perc-red-ipi              AS   CHARACTER FORMAT "x(8)":U                 NO-UNDO. 
DEFINE VARIABLE c-perc-red-icm              AS   CHARACTER FORMAT "x(8)":U                 NO-UNDO. 
DEFINE VARIABLE c-classif-desc              AS   CHARACTER FORMAT "x(45)":U                NO-UNDO.
DEFINE VARIABLE c-trib-pis                  AS   CHARACTER FORMAT "x(1)":U                 NO-UNDO.
DEFINE VARIABLE c-trib-cofins               AS   CHARACTER FORMAT "x(1)":U                 NO-UNDO.
DEFINE VARIABLE c-nat-of-desc               AS   CHARACTER FORMAT "x(35)":U                NO-UNDO.
DEFINE VARIABLE c-esp-docto                 AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-observa                   AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-transp                    AS   CHARACTER FORMAT "X(15)":U                NO-UNDO.
DEFINE VARIABLE c-esp-movto                 AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE cAuxTraducao023             AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE cAuxTraducao024             AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE cAuxTraducao025             AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-descricao                 AS   CHARACTER FORMAT "X(30)":U                NO-UNDO.
DEFINE VARIABLE c-pto-solic-li              AS   CHARACTER FORMAT "x(30)":U                NO-UNDO.
DEFINE VARIABLE c-pto-emb                   AS   CHARACTER FORMAT "x(30)":U                NO-UNDO.
DEFINE VARIABLE c-pto-des                   AS   CHARACTER FORMAT "x(30)":U                NO-UNDO.
DEFINE VARIABLE c-situacao-embarque         AS   CHARACTER FORMAT "X(20)":U                NO-UNDO.
DEFINE VARIABLE c-trib-ii                   AS   CHARACTER FORMAT "x(01)":U                NO-UNDO.
DEFINE VARIABLE c-lb-tit-it                 AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-lb-tit-dup                AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-lb-tit-end                AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-lb-titulo                 AS   CHARACTER                                 NO-UNDO EXTENT 2.
DEFINE VARIABLE c-lb-tit-nfc                AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-lb-tit-docs               AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-lb-despesa                AS   CHARACTER FORMAT "X(8)":U                 NO-UNDO.
DEFINE VARIABLE c-lb-duplicata              AS   CHARACTER FORMAT "X(10)":U                NO-UNDO.
DEFINE VARIABLE c-lb-itiner                 AS   CHARACTER FORMAT "X(22)":U                NO-UNDO.
DEFINE VARIABLE c-lb-item                   AS   CHARACTER FORMAT "X(13)":U                NO-UNDO.
DEFINE VARIABLE c-lb-desp-item              AS   CHARACTER FORMAT "X(18)":U                NO-UNDO.
DEFINE VARIABLE c-lb-nfe-ce                 AS   CHARACTER FORMAT "X(54)":U                NO-UNDO.
DEFINE VARIABLE c-lb-nfc                    AS   CHARACTER FORMAT "X(23)":U                NO-UNDO.
DEFINE VARIABLE c-lb-nfc-ce                 AS   CHARACTER FORMAT "X(55)":U                NO-UNDO.
DEFINE VARIABLE c-lb-sel                    AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-lb-par                    AS   CHARACTER FORMAT "X(10)":U                NO-UNDO.
DEFINE VARIABLE c-lb-imprime                AS   CHARACTER FORMAT "X(7)":U                 NO-UNDO.
DEFINE VARIABLE c-lb-imp                    AS   CHARACTER FORMAT "X(9)":U                 NO-UNDO.
DEFINE VARIABLE c-lb-dest                   AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-lb-usu                    AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-lb-imprime-param          AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-lb-estabel                AS   CHARACTER FORMAT "X(15)":U                NO-UNDO.
DEFINE VARIABLE c-lb-embarque               AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-lb-di-siscomex            AS   CHARACTER FORMAT "x(11)":U                NO-UNDO. 
DEFINE VARIABLE c-lb-dt-nacionaliza         AS   CHARACTER FORMAT "X(22)":U                NO-UNDO.
DEFINE VARIABLE c-lb-emite                  AS   CHARACTER                                 NO-UNDO.
DEFINE VARIABLE c-lb-serie                  AS   CHARACTER FORMAT "X(5)":U                 NO-UNDO.
DEFINE VARIABLE c-lb-docto                  AS   CHARACTER FORMAT "X(9)":U                 NO-UNDO.
DEFINE VARIABLE c-lb-natur                  AS   CHARACTER FORMAT "X(12)":U                NO-UNDO.
DEFINE VARIABLE c-lb-dt-emissao             AS   CHARACTER FORMAT "X(15)":U                NO-UNDO.
DEFINE VARIABLE da-ven-icm                  AS   DATE      FORMAT "99/99/9999":U           NO-UNDO INIT ?.
DEFINE VARIABLE da-ven-ipi                  AS   DATE      FORMAT "99/99/9999":U           NO-UNDO INIT ?.
DEFINE VARIABLE da-ven-iss                  AS   DATE      FORMAT "99/99/9999":U           NO-UNDO INIT ?.
DEFINE VARIABLE da-data                     AS   DATE      FORMAT "99/99/9999":U           NO-UNDO init ? EXTENT 10.
DEFINE VARIABLE da-partida                  AS   DATE      FORMAT "99/99/9999":U           NO-UNDO.
DEFINE VARIABLE dt-vencto                   AS   DATE      FORMAT "99/99/9999":U           NO-UNDO.
DEFINE VARIABLE c-ex-tarifario              AS   CHARACTER FORMAT "x(12)":U                NO-UNDO.

DEFINE VARIABLE de-aliq-pis                 AS   DECIMAL   FORMAT ">9.9999":U              NO-UNDO.
DEFINE VARIABLE de-aliq-cofins              AS   DECIMAL   FORMAT ">9.9999":U              NO-UNDO.
DEFINE VARIABLE de-base-calc-pis            AS   DECIMAL   FORMAT ">>,>>>,>>>,>>9.99":U    NO-UNDO.
DEFINE VARIABLE de-valor-pis                AS   DECIMAL   FORMAT ">>>,>>>,>>>,>>9.99":U   NO-UNDO.
DEFINE VARIABLE de-base-calc-cofins         AS   DECIMAL   FORMAT ">>,>>>,>>>,>>9.99":U    NO-UNDO.
DEFINE VARIABLE de-valor-cofins             AS   DECIMAL   FORMAT ">>>,>>>,>>>,>>9.99":U   NO-UNDO.
DEFINE VARIABLE de-base-pis                 AS   DECIMAL                                   NO-UNDO.
DEFINE VARIABLE de-pis                      AS   DECIMAL                                   NO-UNDO. 
DEFINE VARIABLE de-base-cofins              AS   DECIMAL                                   NO-UNDO. 
DEFINE VARIABLE de-cofins                   AS   DECIMAL                                   NO-UNDO. 
DEFINE VARIABLE de-valor-total              AS   DECIMAL                                   NO-UNDO DECIMALS 2.
DEFINE VARIABLE de-cotacao-dia              AS   DECIMAL   FORMAT ">>>,>9.99999999":U      NO-UNDO.

DEFINE VARIABLE h-im9014                    AS   HANDLE                                    NO-UNDO.
DEFINE VARIABLE h-im9014a                   AS   HANDLE                                    NO-UNDO.
DEFINE VARIABLE h-cdapi995                  AS   HANDLE                                    NO-UNDO.
DEFINE VARIABLE h-acomp                     AS   HANDLE                                    NO-UNDO.
DEFINE VARIABLE h_api_cta_ctbl              AS   HANDLE                                    NO-UNDO.
DEFINE VARIABLE h_api_ccusto                AS   HANDLE                                    NO-UNDO.
DEFINE VARIABLE h-boun005                   AS   HANDLE                                    NO-UNDO.

DEFINE VARIABLE i-quantidade                AS   INTEGER                                   NO-UNDO.
DEFINE VARIABLE i-cont                      AS   INTEGER                                   NO-UNDO.
DEFINE VARIABLE i-cond-pagto                AS   INTEGER                                   NO-UNDO.
DEFINE VARIABLE i-num-parc                  AS   INTEGER                                   NO-UNDO.
DEFINE VARIABLE i-ind                       AS   INTEGER                                   NO-UNDO.
DEFINE VARIABLE i-diferenca                 AS   INTEGER                                   NO-UNDO.
DEFINE VARIABLE i-diferenca-pto             AS   INTEGER                                   NO-UNDO.

DEFINE VARIABLE l-ok                        AS   LOGICAL                                   NO-UNDO.
DEFINE VARIABLE l-docto-imp                 AS   LOGICAL                                   NO-UNDO.
DEFINE VARIABLE l-compras                   AS   LOGICAL                                   NO-UNDO INIT NO.
DEFINE VARIABLE l-of-online                 AS   LOGICAL                                   NO-UNDO FORMAT "On line/Batch".
DEFINE VARIABLE l-ap-online                 AS   LOGICAL                                   NO-UNDO FORMAT "On line/Batch".
DEFINE VARIABLE l-cr-online                 AS   LOGICAL                                   NO-UNDO FORMAT "Atualiza/NÆo Atualiza".
DEFINE VARIABLE l-mostra                    AS   LOGICAL                                   NO-UNDO.
DEFINE VARIABLE l-primeiro                  AS   LOGICAL                                   NO-UNDO.
DEFINE VARIABLE l-memorando-exportacao      AS   LOGICAL                                   NO-UNDO.
DEFINE VARIABLE l-gravado                   AS   LOGICAL INITIAL NO                        NO-UNDO.
DEFINE VARIABLE l-spp-NT2024002             AS   LOGICAL INITIAL NO                        NO-UNDO.

/* Novos Tributos (CBS, IBS MUN, IBS UF e IS) */
DEFINE VARIABLE de-base-cbs          AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-valor-cbs         AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-base-ibs-uf       AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-valor-ibs-uf      AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-aliq-efet-ibs-uf  AS DECIMAL   FORMAT ">>9.9999":U         INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-aliq-efet-cbs     AS DECIMAL   FORMAT ">>9.9999":U         INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-aliq-efet-ibs-mun AS DECIMAL   FORMAT ">>9.9999":U         INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-base-ibs-mun      AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-valor-ibs-mun     AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-base-cbs-reg      AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-valor-cbs-reg     AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-base-ibs-uf-reg   AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-valor-ibs-uf-reg  AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-base-ibs-mun-reg  AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-valor-ibs-mun-reg AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-aliq-reg-ibs-uf   AS DECIMAL   FORMAT ">>9.9999":U         INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-aliq-reg-cbs      AS DECIMAL   FORMAT ">>9.9999":U         INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-aliq-reg-ibs-mun  AS DECIMAL   FORMAT ">>9.9999":U         INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-base-is           AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-valor-is          AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-aliq-efet-is      AS DECIMAL   FORMAT ">>9.9999":U         INITIAL   0 NO-UNDO.

/* Compra Governamental por tributo (CBS, IBS UF, IBS MUN) */
DEFINE VARIABLE de-base-gov-cbs          AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-base-gov-ibs-uf       AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-base-gov-ibs-mun      AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-valor-gov-cbs         AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-valor-gov-ibs-uf      AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-valor-gov-ibs-mun     AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-aliq-efet-gov-cbs     AS DECIMAL   FORMAT ">>9.9999":U         INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-aliq-efet-gov-ibs-uf  AS DECIMAL   FORMAT ">>9.9999":U         INITIAL   0 NO-UNDO.
DEFINE VARIABLE de-aliq-efet-gov-ibs-mun AS DECIMAL   FORMAT ">>9.9999":U         INITIAL   0 NO-UNDO.

def var dat-tipo-dia   like calen-coml.tipo-dia no-undo. /*CD9020.i7*/

