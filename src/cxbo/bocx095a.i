/*
**
**  BOCX095A.I - Definicao das temp-tables para api BOCX095A.P
**
*/

{cdp/cdcfgmat.i} /* Definicao preprocessador */

def temp-table tt-parametros no-undo
    field cod-versao-integracao as integer
    field cod-desp              like desp-imp.cod-desp
    field cod-emitente          like emitente.cod-emitente
    field cod-itiner            like itinerario.cod-itiner
    field cod-incoterm          like inco-cx.cod-incoterm
    field nr-tab                like tb-pr-cex.nr-tab
    field valor                 like desp-imp.val-desp  
    field quantidade            as decimal format ">>>>,>>9.9999"
    field peso                  like item.peso-bruto
    field volume                like item.volume
    field qt-solic              as decimal format ">>>>,>>9.9999"
    field pre-unit-for          as decimal format ">>>>>,>>>,>>9.99999"
    field valor-taxa            as decimal format ">>9.9999"
    field nr-dias-taxa          as decimal
    field cod-emitente-desp     like emitente.cod-emitente
    field modulo                as char.
    
def temp-table tt-parametros-imp no-undo
    field numero-ordem like ordem-compra.numero-ordem
    field it-codigo    like item.it-codigo
    &if defined(bf-mat-comex) &then
        field data      like cotacao-item.data-cotacao
    &else
        field seq-cotac like cotacao-item.seq-cotac
    &endif    
    field mapa-cotacao like cotacao-item-cex.mapa-cotacao
    FIELD cod-emitente LIKE cotacao-item-cex.cod-emitente.

def temp-table tt-parametros-exp no-undo
    field r-rowid     as rowid
    field cod-estabel like estabelec.cod-estabel
    field nr-proc-exp like processo-exp.nr-proc-exp
    field nr-pedido   like ped-venda.nr-pedido.
   
def temp-table tt-erro no-undo
    field i-sequen as int
    field cd-erro  as int
    field mensagem as char format "x(255)"
    field parametros as char format "x(255)" init ""
    field errortype as char format "x(20)"
    field errorhelp as char format "x(20)"
    field errorsubtype as character.

/* CDAPI700.I */
