/********************************************************************************
**
** IM9018fx.i
**
** Objetivo  : Respons vel pelas integra‡äes do m¢dulo de importa‡Æo
**             verifica se a cotacao requisitada para a aprova‡Æo possui um mapa
**             de despesas de importa‡Æo cadastrado ou informado.                  
********************************************************************************/

{method/dbotterr.i} /* RowErrors */

def input parameter r-cotacao-item as rowid no-undo.
DEF OUTPUT PARAMETER TABLE FOR RowErrors.

{cdp/cd4300.i3}  /* variáveis utilizadas pelo cd4300.i4 */
{ccp/cc9019.i50} /* variáveis e informações utilizadas pelo cc9019.i51 */

{cdp/cdcfgmat.i} /* definicao pre-processadores importacao */

find cotacao-item where rowid(cotacao-item) = r-cotacao-item no-lock no-error.
if avail cotacao-item then do:

    {cdp/cd4300.i4 "yes" cotacao-item.char-1}
    {ccp/cc9019.i51 "yes"}

    find emitente where emitente.cod-emitente = cotacao-item.cod-emitente no-lock no-error.
    if avail emitente and 
        (emitente.natureza = 3 or emitente.natureza = 4) and
        (emitente.identific = 2 or emitente.identific = 3) then do:

        find first cotacao-item-cex where 
             cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem and
             cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente and
             cotacao-item-cex.it-codigo    = cotacao-item.it-codigo and
             cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac 
             no-lock no-error.
        if avail cotacao-item-cex then do:
            find first cotacao-item-cex where cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem and
                                              cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente and
                                              cotacao-item-cex.it-codigo    = cotacao-item.it-codigo AND
                                              cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac AND
                                              cotacao-item-cex.mapa-cotacao = i-mapa-cotacao-i50 no-lock no-error.
            if not avail cotacao-item-cex then do:
                
                create RowErrors.
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-nao-existe-mapa-de-cotacao-inf AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "NÆo_existe_mapa_de_cota‡Æo_informado_para_a_cota‡Æo" *}
                ASSIGN c-lbl-liter-nao-existe-mapa-de-cotacao-inf = TRIM(RETURN-VALUE).
                assign RowErrors.errornumber       = 17168
                       RowErrors.ErrorType         = "EMS" 
                       RowErrors.ErrorSubType      = "WARNING"
                       RowErrors.errorDescription  = c-lbl-liter-nao-existe-mapa-de-cotacao-inf + "."
                       RowErrors.ErrorHelp         = c-lbl-liter-nao-existe-mapa-de-cotacao-inf + ".".
            end.                                               
        end.
        else do:                                    
            {utp/ut-liter.i cadastrado mim L}
            create RowErrors.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-nao-existe-mapa-de-cotacao-cad AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "NÆo_existe_mapa_de_cota‡Æo_cadastrado_para_a_cota‡Æo" *}
            ASSIGN c-lbl-liter-nao-existe-mapa-de-cotacao-cad = TRIM(RETURN-VALUE).
            assign RowErrors.errornumber       = 17168
                   RowErrors.ErrorType         = "EMS" 
                   RowErrors.ErrorSubType      = "WARNING"
                   RowErrors.errorDescription  = c-lbl-liter-nao-existe-mapa-de-cotacao-cad + "."
                   RowErrors.ErrorHelp         = c-lbl-liter-nao-existe-mapa-de-cotacao-cad + ".".
        end.
    end.
end.     

