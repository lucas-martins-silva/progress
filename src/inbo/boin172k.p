/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN172K 2.00.00.003}  /*** 010003 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin172k MUT}
&ENDIF

{cdp/cdcfgmat.i}
{cdp/cd7300.i1} /* MultiPlanta */
{inbo/boin172.i RowObject}
{utp/ut-glob.i} 

def input param table for RowObject.
def input param table for tt-replica-msg.
def input param c-item       like item.it-codigo no-undo.
def input param i-tipo-movto as int              no-undo.
def input param p-transacao  as char             no-undo.

def temp-table tt-item-aux NO-UNDO like item
    index ch-codigo is primary it-codigo.

&if defined(bf_mat_tipo_ressup) &then
    def TEMP-TABLE tt-item-mat NO-UNDO like item-mat.
&endif

{cdp/cd7300.i5 "001" p-transacao}

find first param-global   no-lock no-error.
find first RowObject      no-lock no-error.
find first tt-replica-msg no-lock no-error.
find first item where item.it-codigo = c-item no-lock no-error.

if param-global.modulo-mp and
  (avail tt-replica-msg and
         tt-replica-msg.log-replica-msg = yes) then do: 
    if avail RowObject then do:
        create tt-dados-env.
        assign tt-dados-env.num-sequencia  = i-seq
               tt-dados-env.cod-tipo-reg   = 3
               tt-dados-env.ind-tipo-movto = i-tipo-movto
               tt-dados-env.identif-msg    = item.it-codigo.

        buffer-copy RowObject to tt-item-aux.
        raw-transfer tt-item-aux to tt-dados-env.conteudo-msg.
    
        assign i-seq = i-seq + 1.
    end.

    &if defined(bf_mat_tipo_ressup) &then
        if p-transacao = "MAT040" or 
           p-transacao = "MAT007" or 
           p-transacao = "MAT042" then do:

            for each tt-item-mat:
                delete tt-item-mat.
            end.   

            find item-mat where item-mat.it-codigo = item.it-codigo no-lock no-error.
            if avail item-mat then do:
                create tt-item-mat.
                buffer-copy item-mat to tt-item-mat.
                create tt-dados-env.
                assign tt-dados-env.num-sequencia  = i-seq
                       tt-dados-env.cod-tipo-reg   = 268
                       tt-dados-env.ind-tipo-movto = i-tipo-movto
                         tt-dados-env.identif-msg  = item-mat.it-codigo.
                raw-transfer tt-item-mat to tt-dados-env.conteudo-msg.
                assign i-seq = i-seq + 1.
            end.
        end.
    &endif
    
end.

{cdp/cd7300.i7 "001" p-transacao}

return "OK":U.
