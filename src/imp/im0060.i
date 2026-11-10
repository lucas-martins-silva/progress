/*
**
** M¢dulo Importaá∆o
** 
** IM0060.I - Include Padr∆o p/ chamada do programa Cotaá∆o do Item (Importaá∆o) - IM0060
**
*/

/*
**
** Vari†veis:
**
** l-importacao: vari†vel padr∆o que determina se o m¢dulo de Importaá∆o est† implantado ou n∆o
**
*/

def var c-return-msg as char    no-undo.
def var l-im0060     as logical no-undo.

if l-importacao then do:

    if "{1}":U = "gr-ordem-compra":U then do:
        find ordem-compra
            where rowid(ordem-compra) = {1} no-lock no-error.
        for first cotacao-item fields(cod-emitente numero-ordem cot-aprovada)
            where cotacao-item.numero-ordem = ordem-compra.numero-ordem 
              and cotacao-item.cot-aprovada no-lock:
        end.
    end.
    
    if "{1}":U = "gr-cotacao-item":U then do:
        find cotacao-item
            where rowid(cotacao-item) = {1} no-lock no-error.                
    end.    
    
    /*
    ** Verifica Emitente do Material
    */    
    if avail cotacao-item then do:
        IF cotacao-item.cot-aprovada THEN
            ASSIGN gi-numero-ordem-alt = cotacao-item.numero-ordem.

        ASSIGN gr-cotacao-item     = ROWID(cotacao-item)
               gr-cotacao-item-i   = rowid(cotacao-item).
        find emitente
            where emitente.cod-emitente = cotacao-item.cod-emitente no-lock no-error.                    
        if avail emitente and (emitente.natureza = 3 or emitente.natureza = 4) then
            assign l-im0060 = yes.
        else
            assign l-im0060 = no.            
    end.
    
    if not avail emitente then
        assign l-im0060 = no.
        
    if not l-im0060 then do:        
        {utp/ut-liter.i Ordem/Cotaá∆o_do_Item * L}
        assign c-return-msg = trim(return-value).
        {utp/ut-liter.i de_importaá∆o. * L}
        run utp/ut-msgs.p (input "show":U,
                           input 17195,
                           input c-return-msg + "~~" + trim(return-value)).
    end.
    else do:
        run imp/im0060.w.
    end.        
    
end.

/* IM0060.I */
