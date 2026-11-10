/*
**  BOIN274b.i
**
**  ordem-compra - Arquivo de Ordens de Compra
**
**  Ultima altera‡Æo : 02/04/99 - GeraBO
*/

    def temp-table {1} no-undo
        field  numero-ordem like  ordem-compra.numero-ordem
        field  it-codigo    like  ordem-compra.it-codigo
        field  quantidade   like  prazo-compra.quantidade
        field  un           like  prazo-compra.un
        field  data-entrega like  prazo-compra.data-entrega
        field  r-rowid      as    rowid.
