/*
**
**  IMAPI001.I - Definicoes temp-tables utilizadas pelo programa IMAPI001.I
** 
*/

def temp-table tt-cotacao-im001 no-undo
    field cod-versao-integracao as integer
    field cod-itiner       like itinerario.cod-itiner
    field cod-incoterm     like inco-cx.cod-incoterm
    field it-codigo        like item.it-codigo
    field cod-emitente     like emitente.cod-emitente
    &if defined(bf-mat-comex) &then          
        field data-cotacao like cotacao-item.data-cotacao
    &else
        field seq-cotac    like cotacao-item.seq-cotac    
    &endif
    field numero-ordem     like ordem-compra.numero-ordem.

def temp-table tt-despesas-im001 no-undo
    field seq            as integer
    field cod-desp       like desp-imp.cod-desp
    field cod-pto-contr  like pto-contr.cod-pto-contr
    field cod-emitente   like emitente.cod-emitente
    field nr-tab         like desp-tb-pr-cex.nr-tab
    index codigo is unique primary
        seq ascending.
             
def temp-table tt-parametros-im001 no-undo
    field cod-versao-integracao as integer
    field cod-desp       like desp-imp.cod-desp
    field cod-incoterm   like inco-cx.cod-incoterm
    field it-codigo      like item.it-codigo
    field cod-itiner     like itinerario.cod-itiner
    field cod-emitente   like emitente.cod-emitente
    &if defined(bf-mat-comex) &then              
        field data-cotac like cotacao-item.data-cotacao
    &else
        field seq-cotac  like cotacao-item.seq-cotac    
    &endif        
    field numero-ordem   like ordem-compra.numero-ordem
    field cod-pto-contr  like pto-contr.cod-pto-contr
    field primeira-vez   as logical
    index codigo is primary unique
        cod-desp.
   
def temp-table tt-erro-im001 no-undo
    field i-sequen as integer
    field cd-erro  as integer
    field mensagem as char format "x(255)"
    field parametros as char format "x(255)" init "".
    
def temp-table tt-emitente-im001 no-undo
    field cod-emitente      like emitente.cod-emitente
    field despesas-inclusas as logical initial no
    index codigo is primary unique
        cod-emitente.

/* IMAPI001.I */
