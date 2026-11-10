/*
**
** Include para definicao da temp-table para informacoes do item
** para o adapter NeoGrid.
** 
** Autor: Anderson Elton Kruger
** Data: 16/05/2001
** 
*/


def temp-table tt-item like item
    field reference like ref-item.cod-refer
    field manufacturer like item-fornec.cod-emitente
    field reorder like item-mat.ponto-encomenda.


/*
** END OF INCLUDE
*/
