/*
**
** IM0091.I - Include defini»’o temp-table im0091.p
**
*/

def temp-table tt-desp-rateio no-undo
    field numero-ordem       like ordem-compra.numero-ordem
    field parcela            like prazo-compra.parcela
    field cod-desp           like desp-imp.cod-desp    
    field it-codigo          like ordem-compra.it-codigo
    field val-desp-unit      like cotacao-item-cex.val-desp
    field val-desp-unit-mo   like cotacao-item-cex.val-desp
    field val-desp           like cotacao-item-cex.val-desp
    field val-desp-mo        like cotacao-item-cex.val-desp
    field val-desp-isento    like cotacao-item-cex.val-desp
    field val-desp-isento-mo like cotacao-item-cex.val-desp
    field num-adic           as int
    index codigo is unique primary
        numero-ordem
        parcela
        cod-desp
        num-adic
    index despesa 
        cod-desp.

DEF TEMP-TABLE tt-itens-rateio NO-UNDO
    FIELD numero-ordem  like ordem-compra.numero-ordem   
    FIELD parcela       like prazo-compra.parcela      
    FIELD seq           AS INTEGER         
    FIELD cod-desp      like desp-imp.cod-desp
    FIELD val-desp      like cotacao-item-cex.val-desp
    FIELD quantidade    like prazo-compra.quantidade
    index codigo is unique primary
        numero-ordem              
        parcela  
        seq
        cod-desp.

def temp-table tt-ordens-totais no-undo
    field numero-ordem      like ordem-compra.numero-ordem
    field parcela           like prazo-compra.parcela    
    field it-codigo         like item.it-codigo
    field mo-codigo         like moeda.mo-codigo
    field quantidade        like prazo-compra.quantidade
    field preco-total       like cotacao-item.preco-unit
    field preco-unit        like cotacao-item.pre-unit-for
    field peso-total        like item.peso-bruto
    field peso-unit         like item.peso-bruto
    &if '{&bf_mat_versao_ems}' >= '2.05' &then
        field cubagem-total as dec format ">>>>>,>>>,>>9.999999"
        &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        field val-cub-tot   as dec format ">>>>>,>>>,>>9.999999"
        &else
        field val-cub-uni   as dec format ">>>>>,>>>,>>9.999999"
        &endif
    &endif
    field aliquota-ii       AS DECIMAL FORMAT ">>9.9999"
    field base-ii           like cotacao-item.preco-unit
    field base-ii-mo        like cotacao-item.preco-unit
    field i-trib-ii         as integer
    field aliquota-ipi      like item.aliquota-ipi
    field base-ipi          like cotacao-item.preco-unit
    field base-ipi-mo       like cotacao-item.preco-unit
    field i-trib-ipi        as integer
    field aliquota-pis      like item.aliquota-ipi
    field base-pis          like cotacao-item.preco-unit
    field base-pis-mo       like cotacao-item.preco-unit
    field i-trib-pis        as integer
    field aliquota-cofins   like item.aliquota-ipi
    field base-cofins       like cotacao-item.preco-unit
    field base-cofins-mo    like cotacao-item.preco-unit
    field i-trib-cofins     as integer
    field aliquota-icms     like item.aliquota-ipi
    field base-icms         like cotacao-item.preco-unit
    field base-icms-mo      like cotacao-item.preco-unit
    field i-trib-icms       as integer
    field qtd-do-forn       like prazo-compra.qtd-do-forn
    FIELD seq-cotac         LIKE cotacao-item.seq-cotac
    FIELD cod-emitente      LIKE cotacao-item.cod-emitente
    field aliquota-est      like item.aliquota-ipi
    field base-est          like cotacao-item.preco-unit
    field base-est-mo       like cotacao-item.preco-unit
    field i-trib-est        as integer
    index codigo is unique primary
        numero-ordem
        parcela.
        
DEF TEMP-TABLE tt-ordens-totais-incoterm NO-UNDO
    FIELD numero-ordem    LIKE ordem-compra.numero-ordem
    FIELD parcela         LIKE prazo-compra.parcela
    FIELD cod-incoterm    AS CHAR FORMAT "x(03)"
    FIELD val-incoterm    AS DEC  FORMAT ">>>>,>>>,>>>,>>9.99"
    FIELD val-incoterm-mo AS DEC  FORMAT ">>>>,>>>,>>>,>>9.99"
    INDEX codigo IS UNIQUE PRIMARY
          numero-ordem
          parcela
          cod-incoterm.

def temp-table tt-ordens-desp no-undo
    field numero-ordem      like ordem-compra.numero-ordem
    field parcela           like prazo-compra.parcela    
    field cod-desp          like desp-imp.cod-desp
    FIELD sequencia         AS INT FORMAT ">>9"
    FIELD cod-incoterm      AS CHAR
    FIELD cod-estabel       AS CHAR
    index codigo is unique primary
        numero-ordem    
        parcela
        cod-desp.
        
def temp-table tt-ordens-desp-cot no-undo
    field numero-ordem      like ordem-compra.numero-ordem
    field parcela           like prazo-compra.parcela    
    field cod-desp          like desp-imp.cod-desp
    field val-desp          like cotacao-item-cex.val-desp
    field val-desp-mo       like cotacao-item-cex.val-desp
    index codigo is unique primary
        numero-ordem    
        parcela
        cod-desp
    index despesa
        cod-desp.
        
def temp-table tt-desp-totais no-undo
    field cod-desp           like desp-imp.cod-desp
    field quantidade         like prazo-compra.quantidade
    field preco-total        like cotacao-item.preco-unit
    field peso-total         like item.peso-bruto
    &if '{&bf_mat_versao_ems}' >= '2.05' &then
        field cubagem-total as dec format ">>>>>,>>>,>>9.999999"
    &endif
    field val-desp           like cotacao-item-cex.val-desp
    field val-desp-mo        like cotacao-item-cex.val-desp
    field val-desp-cot       like cotacao-item-cex.val-desp
    field val-desp-cot-mo    like cotacao-item-cex.val-desp
    field val-desp-isento    like cotacao-item-cex.val-desp
    field val-desp-isento-mo like cotacao-item-cex.val-desp
    field cod-emitente-desp  like emitente.cod-emitente
    field cod-cond-pag       like cond-pagto.cod-cond-pag
    field mo-codigo          like moeda.mo-codigo
    field cotacao            like docum-est-cex.cotacao
    field cod-pto-contr      like pto-contr.cod-pto-contr
    field qtd-do-forn        like prazo-compra.qtd-do-forn
    &if '{&bf_mat_versao_ems}':U >= '2.062':U &then
    field tp-despesa         like desp-imp.tp-despesa
    &endif
    field num-adic            as int
    index codigo is unique primary
        cod-desp
        num-adic.
        
DEF TEMP-TABLE tt-desp-totais-incoterm NO-UNDO
    FIELD cod-desp        LIKE desp-imp.cod-desp
    FIELD cod-incoterm    AS CHAR FORMAT "x(03)"
    FIELD val-incoterm    AS DEC  FORMAT ">>>>,>>>,>>>,>>9.99"
    FIELD val-incoterm-mo AS DEC  FORMAT ">>>>,>>>,>>>,>>9.99" 
    INDEX codigo IS UNIQUE PRIMARY
          cod-desp
          cod-incoterm.

&if "{&bf_mat_versao_ems}":U >= "2.04":U &then
    /** Temp-table com o total das despesas de todos os embarques
        usada p/ gerar duplicatas **/
    def temp-table tt-desp-totais-embarques-mult no-undo
        field cod-desp          like desp-imp.cod-desp
        field quantidade        like prazo-compra.quantidade
        field preco-total       like cotacao-item.preco-unit
        field peso-total        like item.peso-bruto
        &if '{&bf_mat_versao_ems}' >= '2.05' &then
            field cubagem-total as dec format ">>>>>,>>>,>>9.999999"
        &endif
        field val-desp          like cotacao-item-cex.val-desp
        field val-desp-mo       like cotacao-item-cex.val-desp
        field val-desp-cot      like cotacao-item-cex.val-desp
        field val-desp-cot-mo   like cotacao-item-cex.val-desp
        field cod-emitente-desp like emitente.cod-emitente
        field cod-cond-pag      like cond-pagto.cod-cond-pag
        field mo-codigo         like moeda.mo-codigo
        field cotacao           like docum-est-cex.cotacao
        field cod-pto-contr     like pto-contr.cod-pto-contr
        field qtd-do-forn       like prazo-compra.qtd-do-forn
        &if '{&bf_mat_versao_ems}':U >= '2.062':U &then
        field tp-despesa        like desp-imp.tp-despesa
        &endif
        field num-adic            as int
        index codigo is unique primary
            cod-desp
            cod-emitente-desp.
&endif

def temp-table tt-itiner-emb no-undo
    field cod-itiner        like itinerario.cod-itiner
    field i-seq-pto-desemb  as integer
    field i-pto-desembarque like pto-contr.cod-pto-contr
    index codigo is unique primary
        cod-itiner.
        
DEF TEMP-TABLE tt-despesas NO-UNDO
    FIELD cod-desp          LIKE desp-imp.cod-desp
    FIELD val-desp          LIKE despes-ped-compra.val-desp
    FIELD mo-codigo         LIKE despes-ped-compra.mo-codigo
    FIELD cod-emitente-desp LIKE despes-ped-compra.cod-emitente-desp
    FIELD cod-cond-pag      LIKE despes-ped-compra.cod-cond-pag
    FIELD cod-pto-contr     LIKE despes-ped-compra.cod-pto-contr
    FIELD cod-incoterm-rat  LIKE despes-ped-compra.cod-incoterm-rat
    FIELD tp-despesa        LIKE despes-ped-compra.tp-despesa.

DEF TEMP-TABLE tt-ordem-compra NO-UNDO
    FIELD numero-ordem LIKE ordem-compra.numero-ordem.

DEF TEMP-TABLE tt-desp-cif NO-UNDO
    FIELD numero-ordem       AS INTEGER
    FIELD parcela            AS INTEGER
    FIELD val-desp           AS DECIMAL
    FIELD val-desp-mo        AS DECIMAL
    FIELD val-desp-isento    AS DECIMAL
    FIELD val-desp-isento-mo AS DECIMAL.

/* IM0091.I */        
