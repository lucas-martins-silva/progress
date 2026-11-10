/******************************************************************************
***
*** app/ap0504.i - Defini‡Æo TempTable.
***
******************************************************************************/

def temp-table tt-digita-escolhe NO-UNDO
    field tt-ep-codigo             like tit-ap.ep-codigo
    field tt-cod-estabel           like tit-ap.cod-estabel
    field tt-cod-esp               like tit-ap.cod-esp
    field tt-serie                 like tit-ap.serie
    field tt-nr-docto              like tit-ap.nr-docto
    field tt-parcela               like tit-ap.parcela
    field tt-cod-fornec            like tit-ap.cod-fornec
    field tt-nome-abrev            like tit-ap.nome-abrev
    field tt-cod-port              like tit-ap.portador
    field tt-dt-emissao            like tit-ap.dt-emissao
    field tt-dt-vencimen           like tit-ap.dt-vencimen
    field tt-dt-desconto           like tit-ap.dt-desconto
    field tt-vl-desconto           like tit-ap.vl-desconto
    field tt-vl-saldo              like tit-ap.valor-saldo
    field tt-referencia            like tit-ap.referencia
    field tt-selecionado           as logical
    field tt-row-id-tit-ap         as rowid
    field tt-vl-juros              like mov-ap.valor-juros
    field tt-tp-pagto              like tit-ap.tp-pagto
    INDEX notaduplicata-id IS UNIQUE PRIMARY tt-ep-codigo
                                             tt-cod-estabel
                                             tt-cod-esp
                                             tt-serie
                                             tt-nr-docto
                                             tt-parcela
                                             tt-cod-fornec ASCENDING.

def temp-table tt-duplicata NO-UNDO
    field tt-dup-ep-codigo             like tit-ap.ep-codigo
    field tt-dup-cod-estabel           like tit-ap.cod-estabel
    field tt-dup-cod-esp               like tit-ap.cod-esp
    field tt-dup-serie                 like tit-ap.serie
    field tt-dup-nr-docto              like tit-ap.nr-docto
    field tt-dup-parcela               like tit-ap.parcela
    field tt-dup-dt-emissao            like tit-ap.dt-emissao
    field tt-dup-dt-vencimen           like tit-ap.dt-vencimen
    field tt-dup-vl-original           like tit-ap.vl-original
    field tt-dup-dt-desconto           like tit-ap.dt-desconto
    field tt-dup-vl-desconto           like tit-ap.vl-desconto
    field tt-dup-cod-fornec            like tit-ap.cod-fornec
    field tt-dup-nome-abrev            like tit-ap.nome-abrev
    field tt-dup-cod-port              like tit-ap.portador
    field tt-dup-modalidade            like tit-ap.modalidade
    field tt-dup-tp-codigo             like tit-ap.tp-codigo    
    field tt-dup-mo-codigo             like tit-ap.moeda
    field tt-dup-i-hist-padrao         like hist-padrao.hp-codigo
    field tt-dup-desc-historico        like mov-ap.historico
    field tt-dup-row-dup               as rowid
    INDEX duplicata-id IS UNIQUE PRIMARY tt-dup-ep-codigo
                                         tt-dup-cod-estabel
                                         tt-dup-cod-esp
                                         tt-dup-serie
                                         tt-dup-nr-docto
                                         tt-dup-parcela 
                                         tt-dup-cod-fornec ASCENDING.

def temp-table tt-impostos no-undo
    field tt-ep-codigo             like tit-ap.ep-codigo
    field tt-cod-estabel           like tit-ap.cod-estabel
    field tt-cod-esp               like tit-ap.cod-esp
    field tt-serie                 like tit-ap.serie
    field tt-nr-docto              like tit-ap.nr-docto
    field tt-parcela               like tit-ap.parcela
    field tt-cod-fornec            like tit-ap.cod-fornec
    field tt-cod-imposto           like impto-tit-ap.cod-imposto
    field tt-tipo                  like impto-tit-ap.tipo
    field tt-lancamento            like impto-tit-ap.lancamento
    field tt-vl-imposto            like impto-tit-ap.vl-imposto.

/* Fim de Include */

