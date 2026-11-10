{utp/ut-glob.i}

/* Preprocessadores */
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

/* Defini‡Æo de temp-table's */
{method/dbotterr.i} 

DEF TEMP-TABLE tt-docto-adapter      NO-UNDO
    FIELD cod-estabel                LIKE nota-fiscal.cod-estabel
    FIELD serie                      AS CHAR
    FIELD nr-nota-fis                AS CHAR
    FIELD nat-operacao               AS CHAR
    FIELD nome-abrev                 AS CHAR
    FIELD cgc                        AS CHAR
    FIELD esp-docto                  LIKE nota-fiscal.esp-docto
    FIELD estab-nome-abrev           AS CHAR
    FIELD estab-cgc                  AS CHAR
    FIELD ins-estadual               AS CHAR
    FIELD idi-format-emis-danfe      AS INT
    FIELD nom-model-danfe            AS CHAR
    FIELD pto-contr-cod-uf           AS CHAR
    FIELD ind-sit-nota               AS INT
    FIELD dt-confirm                 AS DATE
    FIELD dt-cancela                 AS DATE
    FIELD dt-atual-cr                AS DATE
    FIELD log-nf-eletro              AS LOG
    FIELD dt-at-ofest                AS DATE
    FIELD dt-at-est                  AS DATE
    FIELD ind-contabil               AS LOG
    FIELD dt-emis-nota               AS DATE
    FIELD dt-saida                   AS DATE
    FIELD desc-cancela               AS CHAR
    FIELD cod-canal-venda            LIKE nota-fiscal.cod-canal-venda
    FIELD cod-des-merc               LIKE nota-fiscal.cod-des-merc
    FIELD cdd-embarq                 LIKE nota-fiscal.cdd-embarq
    FIELD nr-resumo                  LIKE nota-fiscal.nr-resumo
    FIELD dt-embarque                LIKE nota-fiscal.dt-embarque
    FIELD nome-transp                LIKE nota-fiscal.nome-transp
    FIELD cod-rota                   LIKE nota-fiscal.cod-rota
    FIELD uf-placa                   LIKE nota-fiscal.uf-placa
    FIELD placa                      LIKE nota-fiscal.placa
    FIELD ind-tp-frete               LIKE nota-fiscal.ind-tp-frete
    FIELD cidade-cif                 LIKE nota-fiscal.cidade-cif
    FIELD cond-redespa               LIKE nota-fiscal.cond-redespa
    FIELD observ-nota                LIKE nota-fiscal.observ-nota
    FIELD cod-mensagem               LIKE nota-fiscal.cod-mensagem
    FIELD ind-lib-nota               LIKE nota-fiscal.ind-lib-nota
    FIELD emite-duplic               LIKE nota-fiscal.emite-duplic
    FIELD nr-fatura                  LIKE nota-fiscal.nr-fatura
    FIELD ind-tip-nota               LIKE nota-fiscal.ind-tip-nota
    FIELD nr-praz-med                LIKE nota-fiscal.nr-praz-med
    FIELD cod-portador               LIKE nota-fiscal.cod-portador
    FIELD modalidade                 LIKE nota-fiscal.modalidade
    FIELD cod-cond-pag               LIKE nota-fiscal.cod-cond-pag
    FIELD nr-proc-exp                LIKE nota-fiscal.nr-proc-exp
    FIELD peso-bru-tot               LIKE nota-fiscal.peso-bru-tot
    FIELD peso-liq-tot               LIKE nota-fiscal.peso-liq-tot
    field mo-codigo                  like nota-fiscal.mo-codigo
    field nr-tabpre                  like nota-fiscal.nr-tabpre
    field nr-tab-finan               like nota-fiscal.nr-tab-finan
    field nr-ind-finan               like nota-fiscal.nr-ind-finan
    field tp-preco                   like nota-fiscal.tp-preco
    field des-pct-desconto-inform    like nota-fiscal.des-pct-desconto-inform
    field perc-desco1                like nota-fiscal.perc-desco1
    field val-pct-desconto-tab-preco like nota-fiscal.val-pct-desconto-tab-preco
    field vl-desconto                like nota-fiscal.vl-desconto
    field val-desconto-total         like nota-fiscal.val-desconto-total
    field val-pct-desconto-total     like nota-fiscal.val-pct-desconto-total
    field perc-desco2                like nota-fiscal.perc-desco2
    field val-pct-desconto-valor     like nota-fiscal.val-pct-desconto-valor
    field vl-embalagem               like nota-fiscal.vl-embalagem
    field perc-tax-emb               like nota-fiscal.perc-tax-emb
    field tax-emb                    like nota-fiscal.tax-emb
    field vl-frete                   like nota-fiscal.vl-frete
    field perc-tax-fre               like nota-fiscal.perc-tax-fre
    field tax-frete                  like nota-fiscal.tax-frete
    field vl-seguro                  like nota-fiscal.vl-seguro
    field perc-tax-seg               like nota-fiscal.perc-tax-seg
    field tax-seg                    like nota-fiscal.tax-seg
    field vl-comis-nota              like nota-fiscal.vl-comis-nota
    field vl-taxa-exp                like nota-fiscal.vl-taxa-exp
    field vl-acum-dump               like nota-fiscal.vl-acum-dup
    field vl-fatura                  like nota-fiscal.vl-fatura
    field vl-mercad                  like nota-fiscal.vl-mercad
    field vl-merc-tot-fat            like nota-fiscal.vl-merc-tot-fat
    field vl-tot-itens-fat           like nota-fiscal.vl-tot-itens-fat
    field vl-tot-nota                like nota-fiscal.vl-tot-nota
    FIELD desc-valor-nota            LIKE it-nota-fisc.dec-1
    FIELD cod-cf-final               AS CHAR
    /* Projeto 90 - Gestão de Caixas */
    FIELD num-cx-financ              LIKE nota-fiscal.num-cx-financ
    FIELD num-process-negoc          LIKE nota-fiscal.num-process-negoc
    /* Fim Projeto 90 - Gestão de caixas*/
    .
def temp-table tt-fat-repre-adapter no-undo
    field seq-tt-docto as   int
    field sequencia    as   int
    field cod-rep      like nota-fiscal.cod-rep               
    field nome-ab-rep  like fat-repre.nome-ab-rep             
    field perc-comis   like fat-repre.perc-comis form ">9.99" 
    field comis-emis   like fat-repre.comis-emis
    field vl-comis     as dec
    field vl-emis      as dec
    FIELD cod-classif  LIKE fat-repre.cod-classif
    index codigo is primary
          sequencia.

DEF TEMP-TABLE tt-it-docto-adapter NO-UNDO
    FIELD nr-seq-fat    LIKE it-nota-fisc.nr-seq-fat
    FIELD it-codigo     LIKE it-nota-fisc.it-codigo
    FIELD cod-refer     LIKE it-nota-fisc.cod-refer
    FIELD nat-operacao  LIKE it-nota-fisc.nat-operacao
    FIELD class-fiscal  LIKE it-nota-fisc.class-fiscal
    FIELD ct-cusven     LIKE it-nota-fisc.ct-cusven
    FIELD ct-cuscon     LIKE it-nota-fisc.ct-cuscon
    FIELD ind-imp-desc  LIKE it-nota-fisc.ind-imp-desc
    FIELD ind-componen  LIKE it-nota-fisc.ind-componen
    FIELD tipo-atend    LIKE it-nota-fisc.tipo-atend
    FIELD narrativa     AS CHAR
    FIELD nr-pedcli     LIKE it-nota-fisc.nr-pedcli
    FIELD nr-seq-ped    LIKE it-nota-fisc.nr-seq-ped
    FIELD baixa-estoq   LIKE it-nota-fisc.baixa-estoq
    FIELD nr-ord-prod   LIKE it-nota-fisc.nr-ord-prod
    FIELD qt-faturada   LIKE it-nota-fisc.qt-faturada
    FIELD un-fatur      LIKE it-nota-fisc.un-fatur
    FIELD peso-bruto    LIKE it-nota-fisc.peso-bruto
    FIELD peso-liq-fat  LIKE it-nota-fisc.peso-liq-fat
    FIELD serie-docum   LIKE it-nota-fisc.serie-docum
    FIELD nr-docum      LIKE it-nota-fisc.nr-docum
    FIELD nat-docum     LIKE it-nota-fisc.nat-docum
    FIELD serie-ant     LIKE it-nota-fisc.serie-ant
    FIELD nr-nota-ant   LIKE it-nota-fisc.nr-nota-ant
    field vl-frete-it   like it-nota-fisc.vl-frete-it
    field vl-despes-it  like it-nota-fisc.vl-despes-it
    field vl-cuscontab  like it-nota-fisc.vl-cuscontab
    field vl-precon     like it-nota-fisc.vl-precon
    field vl-pretab     like it-nota-fisc.vl-pretab
    field vl-preori     like it-nota-fisc.vl-preori
    field vl-preuni     like it-nota-fisc.vl-preuni
    field vl-merc-tab   like it-nota-fisc.vl-merc-tab
    field vl-merc-ori   like it-nota-fisc.vl-merc-ori
    field vl-merc-liq   like it-nota-fisc.vl-merc-liq
    field vl-merc-sicm  like it-nota-fisc.vl-merc-sicm
    field vl-tot-item   like it-nota-fisc.vl-tot-item
    field status-icms   as   char format "x(2)"
    field status-ipi    as   char format "x(2)"
    field status-pis    as   char format "x(2)"
    field status-cofins as   char format "x(2)"
    field mod-icms      as   char format "x(2)"
    field mod-ipi       as   char format "x(2)"
    field mod-icms-st   as   char format "x(2)"
    field Ean-cod       as   char format "x(14)".

def temp-table tt-it-docto-imp-adapter no-undo
    field nr-seq-imp   like it-nota-imp.nr-seq-imp
    field cod-taxa     like it-nota-imp.cod-taxa
    field tipo-tax     like it-nota-imp.tipo-tax
    field conta-tax    like it-nota-imp.conta-tax
    field aliquota     like it-nota-imp.aliquota
    field vl-base-imp  like it-nota-imp.vl-base-imp
    field perc-redimp  like it-nota-imp.perc-redimp
    field vl-imposto   like it-nota-imp.vl-imposto.

def temp-table tt-fat-duplic-adapter no-undo
    field parcela       like fat-duplic.parcela
    field nr-fatura     like fat-duplic.nr-fatura
    field cod-esp       like fat-duplic.cod-esp
    field tp-receita    like fat-duplic.tp-receita
    field dt-emissao    like fat-duplic.dt-emissao
    field dt-venciment  like fat-duplic.dt-venciment
    field vl-desconto   like fat-duplic.vl-desconto
    field vl-parcela    like fat-duplic.vl-parcela
    field vl-comis      like fat-duplic.vl-comis.

def temp-table tt-nota-embal-adapter NO-UNDO
    field sigla-emb     like nota-embal.sigla-emb
    field qt-volumes    like nota-embal.qt-volumes
    field desc-vol      like nota-embal.desc-vol.

def temp-table tt-item-embal-adapter NO-UNDO 
    field nr-seq-fat    like item-embal.nr-seq-fat
    field it-codigo     like item-embal.it-codigo
    field sigla-emb     like item-embal.sigla-emb
    FIELD qt-embalada   LIKE item-embal.dec-1
    FIELD volume        LIKE item-embal.int-1.


def temp-table tt-saldo-estoq-adapter no-undo
    field seq-tt-saldo-estoq  as   int
    field seq-tt-it-docto     as   int
    field it-codigo           like saldo-estoq.it-codigo
    field cod-refer           like saldo-estoq.cod-refer
    field cod-depos           like saldo-estoq.cod-depos
    field cod-localiz         like saldo-estoq.cod-localiz
    field lote                like saldo-estoq.lote
    field dt-vali-lote        like saldo-estoq.dt-vali-lote
    field quantidade          like saldo-estoq.qtidade-atu
    field qtd-contada         like saldo-estoq.qtidade-atu
    index seq is unique
          seq-tt-saldo-estoq.

DEF VAR iCount    AS INT  NO-UNDO.
DEF VAR iSequence AS INT  NO-UNDO.
DEF VAR iId AS INTEGER INITIAL ? NO-UNDO.

DEF TEMP-TABLE ttRetornaCliente NO-UNDO
    FIELD XMLElementName AS CHAR
    FIELD FieldName      AS CHAR
    FIELD FieldValue     AS DEC.

{ftp/ft2010.i1}  /* Definicao da temp-table tt-notas-geradas    */






