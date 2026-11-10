/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9030 2.00.00.002} /*** "010002" 09/10/2025 13:38:06 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9030 MIM}
&ENDIF

/* 
**
** IM9030 - Integracao Consulta Ordens/Pedido
**
** Verifica parƒmetros para abrir o Acompanhamento do Processo ou 
** Acompanhamento do Embarque 
**
*/

/* Opcao consulta - 1 - Pedido de Compra / 2 - Ordem de Compra */
def input parameter p-opcao as integer no-undo.
def input parameter p-rowid as rowid   no-undo.

def var l-achou        as logical no-undo.
def var i-numero-ordem like ordem-compra.numero-ordem no-undo.

def new global shared var gr-par-processo-imp as rowid no-undo.
def new global shared var gr-par-ordem-compra as rowid no-undo.
def new global shared var gr-processo-imp     as rowid no-undo.

assign gr-par-processo-imp = ?
       gr-par-ordem-compra = ?.

if p-opcao = 1 then do:
    find pedido-compr where rowid(pedido-compr) = p-rowid no-lock no-error.
end.
if p-opcao = 2 then do:
    find ordem-compra where rowid(ordem-compra)     = p-rowid no-lock no-error.
    find pedido-compr where pedido-compr.num-pedido = ordem-compra.num-pedido no-lock no-error.
    IF AVAIL ordem-compra  THEN 
           assign gr-par-ordem-compra = p-rowid    
           i-numero-ordem      = ordem-compra.numero-ordem.
end.

if avail pedido-compr then do:
    find processo-imp where processo-imp.num-pedido = pedido-compr.num-pedido no-lock no-error.
    if avail processo-imp then do:
        assign gr-par-processo-imp = rowid(processo-imp)
               gr-processo-imp     = rowid(processo-imp).
        
        find param-imp where param-imp.cod-estabel = processo-imp.cod-estabel no-lock no-error.
        if avail param-imp then do:            
            if param-imp.hist-processo then do:
                if can-find(first historico-proc-imp
                                where historico-proc-imp.cod-estabel = processo-imp.cod-estabel
                                  and historico-proc-imp.nr-proc-imp = processo-imp.nr-proc-imp) then
                    run imp/im0550br.w.
                else
                    run imp/im0040.w.                                                    
            end.
            else do:
                for each ordem-compra where ordem-compra.num-pedido = processo-imp.num-pedido no-lock:
                    if p-opcao = 2 then
                        if ordem-compra.numero-ordem <> i-numero-ordem then next.
                    if can-find(first ordens-embarque
                                    where ordens-embarque.numero-ordem = ordem-compra.numero-ordem) then
                        assign l-achou = yes.
                end.
                if l-achou then 
                    run imp/im0555br.w.
                else 
                    run imp/im0540.w.
            end.
        end.                                
    end.
end.

/* IM9030.P */
