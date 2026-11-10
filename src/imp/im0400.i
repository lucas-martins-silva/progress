/*
**
** IM0400.I - Include defini»’o temp-table para o rateio da declara‡Æo de importa‡Æo bocx383.p (pi-rateio-di)
**
*/

def temp-table tt-ordens-totais no-undo
    field num-di-ems        like decla-import-ord.num-di-ems
    field num-adic          like decla-import-ord.num-di-ems
    field numero-ordem      like ordem-compra.numero-ordem
    FIELD num-seq           like decla-import-adic-itens.num-seq
    field parcela           like prazo-compra.parcela    
    field it-codigo         like item.it-codigo
    field mo-codigo         like moeda.mo-codigo
    field quantidade        like decla-import-ord.qtd-item
    field val-merc          like decla-import-adic-itens.val-vmle
    field val-preco-merc    like decla-import-adic-itens.val-vmle
    field preco-merc-tot    like decla-import-adic-itens.val-vmle
    field preco-unit        like decla-import-adic-itens.val-vmle
    field peso-total        like decla-import-adic.val-peso-liq
    field peso-unit         like decla-import-adic.val-peso-liq
    field val-cub-tot       like decla-import-ord.val-cub-tot
    field val-cub-uni       like decla-import-ord.val-cub-tot
    field aliquota-ii       like decla-import-adic.val-aliq-ii
    field base-ii           like decla-import-adic.val-base-ii
    field base-ii-mo        like decla-import-adic.val-base-ii
    field i-trib-ii         as integer
    field aliquota-ipi      like decla-import-adic.val-aliq-ipi  
    field base-ipi          like decla-import-adic.val-base-ipi  
    field base-ipi-mo       like decla-import-adic.val-base-ipi  
    field i-trib-ipi        as integer
    field aliquota-pis      like decla-import-adic.val-aliq-pis  
    field base-pis          like decla-import-adic.val-base-pis  
    field base-pis-mo       like decla-import-adic.val-base-pis  
    field i-trib-pis        as integer
    field aliquota-cofins   like decla-import-adic.val-aliq-cofins  
    field base-cofins       like decla-import-adic.val-base-cofins  
    field base-cofins-mo    like decla-import-adic.val-base-cofins  
    field i-trib-cofins     as integer
    field aliquota-icms     like decla-import-adic.val-aliq-icms  
    field base-icms         like decla-import-adic.val-base-icms  
    field base-icms-mo      like decla-import-adic.val-base-icms  
    field i-trib-icms       as integer
    field qtd-do-forn       like decla-import-ord.qtd-fornec
    FIELD seq-cotac         like cotacao-item.seq-cotac
    FIELD cod-emitente      like decla-import-ord.cdn-fornec
    index codigo is unique primary
        num-di-ems
        num-adic
        numero-ordem
        parcela.
        
def temp-table tt-adic-totais no-undo
    field num-adic          like decla-import-adic.num-adic
    field num-di-ems        like decla-import-adic.num-di-ems    
    field quantidade        like decla-import-ord.qtd-item
    field val-merc-adic     like decla-import-adic-itens.val-vmle
    field val-preco-adic    like decla-import-adic-itens.val-vmle
    field preco-unit        like decla-import-adic-itens.val-vmle
    field peso-total        like decla-import-adic.val-peso-liq
    field peso-unit         like decla-import-adic.val-peso-liq
    field val-cub-tot       like decla-import-ord.val-cub-tot
    field val-cub-uni       like decla-import-ord.val-cub-tot
    field qtd-do-forn       like decla-import-ord.qtd-fornec
    index codigo is unique primary
        num-di-ems
        num-adic.

def temp-table tt-di-totais NO-UNDO 
    field num-di-ems        like decla-import-ord.num-di-ems
    field quantidade        like decla-import-ord.qtd-item
    field val-merc-di       like decla-import-adic-itens.val-vmle
    field peso-total        like decla-import-adic.val-peso-liq
    field val-cub-tot       like decla-import-ord.val-cub-tot
    field cod-incoterm      like inco-cx.cod-incoterm
    index codigo is unique primary
        num-di-ems.

DEF TEMP-TABLE tt-ordens-totais-incoterm NO-UNDO
    FIELD num-di-ems      LIKE decla-import-ord.num-di-ems
    FIELD numero-ordem    LIKE ordem-compra.numero-ordem
    FIELD parcela         LIKE prazo-compra.parcela
    FIELD cod-incoterm    AS CHAR FORMAT "x(03)"
    FIELD val-incoterm    AS DEC  FORMAT ">>>>,>>>,>>>,>>9.99"
    FIELD val-incoterm-mo AS DEC  FORMAT ">>>>,>>>,>>>,>>9.99"
    INDEX codigo IS UNIQUE PRIMARY
          num-di-ems
          numero-ordem
          parcela
          cod-incoterm.

DEF TEMP-TABLE tt-desp-totais-incoterm NO-UNDO
    FIELD num-di-ems      LIKE decla-import-ord.num-di-ems
    FIELD cod-desp        LIKE desp-imp.cod-desp
    FIELD cod-incoterm    AS CHAR FORMAT "x(03)"
    FIELD val-incoterm    AS DEC  FORMAT ">>>>,>>>,>>>,>>9.99"
    FIELD val-incoterm-mo AS DEC  FORMAT ">>>>,>>>,>>>,>>9.99" 
    INDEX codigo IS UNIQUE PRIMARY
          num-di-ems
          cod-desp
          cod-incoterm.

DEF TEMP-TABLE tt-desp-totais-incoterm-adic NO-UNDO
    FIELD num-di-ems      LIKE decla-import-ord.num-di-ems
    FIELD cod-incoterm    AS CHAR FORMAT "x(03)"
    FIELD num-adic LIKE decla-import-ord.num-adic
    FIELD val-incoterm    AS DEC  FORMAT ">>>>,>>>,>>>,>>9.99"
     INDEX codigo IS UNIQUE PRIMARY
          num-di-ems
          cod-incoterm
          num-adic.

def temp-table tt-ordens-desp no-undo
    field num-di-ems        like decla-import-ord.num-di-ems
    field num-adic          like decla-import-ord.num-di-ems
    field numero-ordem      like ordem-compra.numero-ordem
    field parcela           like prazo-compra.parcela    
    field cod-desp          like desp-imp.cod-desp
    FIELD sequencia         AS INT FORMAT ">>9"
    FIELD cod-incoterm      AS CHAR
    FIELD cod-estabel       AS CHAR
    index codigo is unique primary
        num-di-ems
        num-adic
        numero-ordem    
        parcela
        cod-desp.

def temp-table tt-adic-desp no-undo
    field num-di-ems        like decla-import-ord.num-di-ems
    field num-adic          like decla-import-ord.num-adic
    field cod-desp          like desp-imp.cod-desp
    FIELD sequencia         AS INT FORMAT ">>9"
    FIELD cod-incoterm      AS CHAR
    FIELD cod-estabel       AS CHAR
    index codigo is unique primary
        num-di-ems
        num-adic
        cod-desp.

def temp-table tt-desp-totais-di no-undo
    field num-di-ems         LIKE decla-import-ord.num-di-ems
    field cod-desp           like desp-imp.cod-desp
    field quantidade         like prazo-compra.quantidade
    field val-merc-desp      like decla-import-adic.val-vmle
    field peso-total         like item.peso-bruto
    field val-cub-tot        LIKE decla-import-ord.val-cub-tot
    field val-desp           like despes-decla-import.val-desp
    field val-desp-mo        like despes-decla-import.val-desp
    field val-desp-cot       like despes-decla-import.val-desp
    field val-desp-cot-mo    like despes-decla-import.val-desp
    field cod-emitente-desp  like emitente.cod-emitente
    field cod-cond-pag       like cond-pagto.cod-cond-pag
    field mo-codigo          like moeda.mo-codigo
    field cotacao            like docum-est-cex.cotacao
    field cod-pto-contr      like pto-contr.cod-pto-contr
    field qtd-do-forn        like prazo-compra.qtd-do-forn
    field tp-despesa         like desp-imp.tp-despesa
    index codigo is unique primary
        num-di-ems
        cod-desp.

def temp-table tt-desp-totais-adic no-undo
    field num-di-ems         LIKE decla-import-ord.num-di-ems
    field num-adic           like decla-import-ord.num-adic
    field cod-desp           like desp-imp.cod-desp
    field quantidade         like prazo-compra.quantidade
    field val-merc-desp      like decla-import-adic.val-vmle
    field peso-total         like item.peso-bruto
    field val-cub-tot        LIKE decla-import-ord.val-cub-tot
    field val-desp           like despes-decla-import.val-desp
    field val-desp-mo        like despes-decla-import.val-desp
    field val-desp-cot       like despes-decla-import.val-desp
    field val-desp-cot-mo    like despes-decla-import.val-desp
    field cod-emitente-desp  like emitente.cod-emitente
    field cod-cond-pag       like cond-pagto.cod-cond-pag
    field mo-codigo          like moeda.mo-codigo
    field cotacao            like docum-est-cex.cotacao
    field cod-pto-contr      like pto-contr.cod-pto-contr
    field qtd-do-forn        like prazo-compra.qtd-do-forn
    field tp-despesa         like desp-imp.tp-despesa
    index codigo is unique primary
        num-di-ems
        num-adic
        cod-desp.

def temp-table tt-desp-rateio no-undo
    field num-di-ems        LIKE decla-import-ord.num-di-ems
    field num-adic          LIKE decla-import-adic.num-adic
    field numero-ordem      like ordem-compra.numero-ordem
    field parcela           like prazo-compra.parcela
    field cod-desp          like desp-imp.cod-desp    
    field val-desp-unit     like despes-decla-import.val-despes
    field val-desp          like despes-decla-import.val-despes    
    index codigo is unique primary
        num-di-ems
        cod-desp
        num-adic
    index despesa 
        cod-desp.

def temp-table tt-desp-rateio-item no-undo
    field num-di-ems        LIKE decla-import-ord.num-di-ems
    field num-adic          LIKE decla-import-adic.num-adic
    field numero-ordem      like ordem-compra.numero-ordem
    field parcela           like prazo-compra.parcela
    field num-seq           like decla-import-adic-itens.num-seq
    field cod-desp          like desp-imp.cod-desp    
    field val-desp-unit     like despes-decla-import.val-despes
    field val-desp          like despes-decla-import.val-despes    
    index codigo is unique primary
        num-di-ems
        num-adic
        numero-ordem
        parcela
        cod-desp
    index despesa 
        cod-desp.

DEF TEMP-TABLE tt-taxa-rateio NO-UNDO
    FIELD cod-incoterm LIKE inco-cx.cod-incoterm
    FIELD numero-ordem LIKE ordem-compra.numero-ordem
    FIELD val-desp-tot LIKE desp-imp.val-desp
    FIELD taxa-rateio AS DEC.

DEFINE TEMP-TABLE tt-taxa-rateio-adic LIKE tt-taxa-rateio
    FIELD num-adic LIKE decla-import-adic.num-adic.

DEF TEMP-TABLE tt-despesas NO-UNDO
    FIELD num-di-ems             LIKE decla-import.num-di-ems
    FIELD num-adic               LIKE decla-import.num-adic
    FIELD cdn-emit-despes        LIKE despes-decla-import.cdn-emit-despes
    FIELD cdn-despes             LIKE despes-decla-import.cdn-despes
    FIELD cdn-moeda              LIKE despes-decla-import.cdn-moeda
    FIELD val-despes             LIKE despes-decla-import.val-despes
    FIELD cdn-cond-pagto         LIKE despes-decla-import.cdn-cond-pagto
    FIELD cod-incoterm-rat       LIKE despes-decla-import.cod-incoterm-rat
    FIELD log-frete              AS LOGICAL INITIAL NO
    FIELD log-seguro             AS LOGICAL INITIAL NO
    FIELD log-incid-vmle         LIKE despes-decla-import.log-incid-vmle
    FIELD log-forma-preco-compra LIKE despes-adic.log-forma-preco-compra
    FIELD log-incid-val-aduana   AS LOGICAL
    FIELD i-tip-incid-nf         LIKE despes-decla-import.idi-tip-incid-nf.

/* IM0400.I */        
