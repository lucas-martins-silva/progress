
define temp-table {1} no-undo like af-contr-indice
    field nome-emit         like emitente.nome-emit
    field desc-item         like item.desc-item
    field nome-estabel      like estabelec.nome
    field nome-controle     like af-controle.descricao
    field cod-grp-aval      like af-grp-avaliacao.cod-grp-avaliacao
    field nome-grp-aval     like af-grp-avaliacao.des-grp-avaliacao
    field cod-grp-resp      like af-grp-responsavel.cod-grp-resp   
    field nome-grp-resp     like af-grp-responsavel.des-grp-resp
    field log-per-variavel  like af-item-contr-estab-form.log-per-variavel
    field ind-tipo          as integer
    field r-rowid           as rowid.
