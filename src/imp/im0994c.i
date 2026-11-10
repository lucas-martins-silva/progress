/***************************************************************************
**                                                                        **
** im0994c.i  Defini‡Æo da Temp-table tt-dupli-imp e tt-it-docest-imp     **    
**                                                                        **
****************************************************************************/

def temp-table tt-it-docest-imp NO-UNDO
    field sequencia             like item-doc-est.sequencia
    field cod-imposto           like impto-tit-ap.cod-imposto
    field num-seq-impto         like impto-tit-ap.num-seq-impto

    field vl-base               like impto-tit-ap.vl-base
    field vl-imposto            like impto-tit-ap.vl-imposto
    field vl-percepcao          like impto-tit-ap.vl-percepcao        
    field vl-iva-liberado       like impto-tit-ap.vl-iva-liberado

    field vl-base-me            like impto-tit-ap.vl-base
    field vl-imposto-me         like impto-tit-ap.vl-imposto
    field vl-percepcao-me       like impto-tit-ap.vl-percepcao        
    field vl-iva-liberado-me    like impto-tit-ap.vl-iva-liberado

    field ind-tipo-imposto-iva  as integer

    index sequencia is unique primary sequencia
                                      num-seq-impto
                                      ascending
                                   

    index imposto     sequencia
                      cod-imposto
                      ascending.


def temp-table tt-dupli-imp NO-UNDO
    field ep-codigo             like impto-tit-ap.ep-codigo
    field cod-emitente          like emitente.cod-emitente
    field cod-imposto           like impto-tit-ap.cod-imposto
    field desc-imposto          like tipo-tax.descricao
    field num-seq-impto         like dupli-imp.parcela-imp
    field uf                    like docum-est.uf

    field vl-base               like impto-tit-ap.vl-base
    field vl-imposto            like impto-tit-ap.vl-imposto
    field vl-percepcao          like impto-tit-ap.vl-percepcao        
    field vl-iva-liberado       like impto-tit-ap.vl-iva-liberado

    field vl-base-me            like impto-tit-ap.vl-base
    field vl-imposto-me         like impto-tit-ap.vl-imposto
    field vl-percepcao-me       like impto-tit-ap.vl-percepcao        
    field vl-iva-liberado-me    like impto-tit-ap.vl-iva-liberado

    field perc-imposto          like impto-tit-ap.perc-imposto
    field perc-percepcao        like impto-tit-ap.perc-percepcao      
    field perc-iva-liberado     like impto-tit-ap.perc-iva-liberado

    /*field conta-imposto         like tipo-tax.conta-tax
    field conta-percepcao       like tipo-tax.conta-percepcao
    field conta-iva-liberado    like impto-tit-ap.conta-iva-liberado*/

    FIELD ct-imposto            LIKE tipo-tax.ct-tax
    FIELD sc-imposto            LIKE tipo-tax.sc-tax
    FIELD ct-percepcao          LIKE tipo-tax.ct-percepcao
    FIELD sc-percepcao          LIKE tipo-tax.sc-percepcao
    FIELD ct-iva-liberado       LIKE impto-tit-ap.ct-iva-liberado
    FIELD sc-iva-liberado       LIKE impto-tit-ap.sc-iva-liberado

    field ind-tipo-imposto-iva  as integer

    index sequencia is unique primary num-seq-impto
                       ascending

    index imposto    cod-imposto
                       ascending.

def temp-table tt-total NO-UNDO
    field   despesa-nota-calc   like docum-est.despesa-nota-me
    field   despesa-nota-dif    like docum-est.despesa-nota-me
    field   despesa-nota-fat    like docum-est.despesa-nota-me
    field   tot-desconto-calc   like docum-est.tot-desconto-me
    field   tot-desconto-dif    like docum-est.tot-desconto-me
    field   tot-desconto-fat    like docum-est.tot-desconto-me
    field   tot-taxa-calc       like docum-est.tot-taxa-me
    field   tot-taxa-dif        like docum-est.tot-taxa-me
    field   tot-taxa-fat        like docum-est.tot-taxa-me
    field   tot-valor-calc      like docum-est.tot-valor-me
    field   tot-valor-dif       like docum-est.tot-valor-me
    field   tot-valor-fat       like docum-est.tot-valor-me
    field   valor-mercad-calc   like docum-est.valor-mercad-me
    field   valor-mercad-dif    like docum-est.valor-mercad-me
    field   valor-mercad-fat    like docum-est.valor-mercad-me
    field   sit-docum           like docum-est.sit-docum
    field   cod-cond-pag        like ordem-compra.cod-cond-pag
    field   cod-esp             like dupli-apagar.cod-esp
    field   tp-despesa          like dupli-apagar.tp-despesa
    field   taxa-inc-calc       like docum-est.tot-taxa-me
    field   taxa-inc-dif        like docum-est.tot-taxa-me
    field   taxa-inc-fat        like docum-est.tot-taxa-me.






