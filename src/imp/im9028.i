/*******************************************************************************
**
** IM9028.i - API Importacao
**
** Objetivo: Rateio do valor das despesas do documento (docum-est-cex) entre os
**           itens do documento(item-doc-est-cex)
**
********************************************************************************/

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */

def var de-valor            as   decimal format ">>>>>,>>>,>>9.99" no-undo.
def var de-valor2           as   decimal format ">>>>>,>>>,>>9.99" no-undo.
def var de-tot-item         as   decimal format ">>>>>,>>>,>>9.99" init 0 no-undo.
def var de-diferenca        as   decimal format ">>>>>,>>>,>>9.99" no-undo.
def var de-maior            as   decimal format ">>>>>,>>>,>>9.99" init 0 no-undo.
def var r-item              as   rowid                             no-undo.
def var l-soma              as   logical                           no-undo.
def var de-desp             as   decimal format ">>>>>,>>>,>>9.99" no-undo.
def var de-val-desp-it      as   decimal format ">>>>>,>>>,>>9.99" no-undo.

def var de-fator            as   decimal format ">>>>>,>>>,>>9.99" no-undo.

&if defined(bf-mat-comex) &then   
    {cdp/cd4305.i1}      /* Definicao Temp-Table TT-DOCTO, TT-IT-DOC */
&else
&endif

procedure pi-atualizaItens:
    def input  parameter r-docum-est-cex as rowid   no-undo.
    def input  parameter de-val as decimal no-undo.
    
    find docum-est-cex 
        where rowid(docum-est-cex) = r-docum-est-cex
        exclusive-lock no-error.
        
    if avail docum-est-cex then do:
    
        if docum-est-cex.val-desp <> de-val then do:     
                     
            assign de-fator = de-val / docum-est-cex.val-desp.      
            
            find desp-imp 
                where desp-imp.cod-desp = docum-est-cex.cod-desp 
                no-lock no-error.
                                                              
            assign docum-est-cex.val-desp = de-val.
            
            for each item-doc-est-cex of docum-est-cex exclusive-lock:
            
                assign de-val-desp-it            = item-doc-est-cex.val-desp
                       item-doc-est-cex.val-desp = round(item-doc-est-cex.val-desp * de-fator,2).
                       
                if item-doc-est-cex.val-desp < 0 then
                    assign item-doc-est-cex.val-desp = 0.                       

                &if defined(bf-mat-comex) &then   
                    find tt-it-docto where 
                        tt-it-docto.serie         = item-doc-est-cex.serie-docto and
                        tt-it-docto.nr-nota       = int(item-doc-est-cex.nro-docto) and
                        tt-it-docto.cod-emitente  = item-doc-est-cex.cod-emitente and
                        tt-it-docto.nat-operacao  = item-doc-est-cex.nat-operacao and
                        tt-it-docto.nr-sequencia  = item-doc-est-cex.sequencia no-error.
                    
                    if  avail tt-it-docto then do:            
                        assign tt-it-docto.vl-despes-it = tt-it-docto.vl-despes-it 
                                                        - de-val-desp-it
                                                        + item-doc-est-cex.val-desp
                               tt-it-docto.alterado     = yes.
                                                        
                        if  desp-imp.inc-val-frete then                                                    
                            assign tt-it-docto.vl-frete = tt-it-docto.vl-frete 
                                                        - de-val-desp-it
                                                        + item-doc-est-cex.val-desp.
                    end.
                    
                &else
                
                    find item-doc-est 
                        where item-doc-est.serie-docto  = item-doc-est-cex.serie-docto 
                          and item-doc-est.nro-docto    = item-doc-est-cex.nro-docto 
                          and item-doc-est.cod-emitente = item-doc-est-cex.cod-emitente 
                          and item-doc-est.nat-operacao = item-doc-est-cex.nat-operacao 
                          and item-doc-est.sequencia    = item-doc-est-cex.sequencia 
                          exclusive-lock no-error.                        
                    if  avail item-doc-est then do:        
                        assign item-doc-est.despesas[1] = item-doc-est.despesas[1] 
                                                        - de-val-desp-it
                                                        + item-doc-est-cex.val-desp.
                        if item-doc-est.despesas[1] < 0 then
                            assign item-doc-est.despesas[1] = 0.
                        if  desp-imp.inc-val-frete then do:                                                                                                         
                            item-doc-est.pr-total-cmi = item-doc-est.pr-total-cmi 
                                                      - de-val-desp-it
                                                      + item-doc-est-cex.val-desp. /* frete constante */
                            if item-doc-est.pr-total-cmi < 0 then
                                assign item-doc-est.pr-total-cmi = 0.
                        end.                                
                    end.                    
                &endif
                
                assign de-tot-item = de-tot-item
                                   + item-doc-est-cex.val-desp.
                if de-maior < item-doc-est-cex.val-desp then
                    assign de-maior = item-doc-est-cex.val-desp
                           r-item   = rowid(item-doc-est-cex).
            end.
            if de-tot-item <> de-val then do:
    
                assign de-diferenca = de-val - de-tot-item.
            
                find item-doc-est-cex
                    where rowid(item-doc-est-cex) = r-item
                    exclusive-lock no-error.
                if avail item-doc-est-cex then do:
                    assign item-doc-est-cex.val-desp = item-doc-est-cex.val-desp
                                                     + de-diferenca.
                    if item-doc-est-cex.val-desp < 0 then
                        assign item-doc-est-cex.val-desp = 0.
                end.                                                                     
            end.         
        end.            
    end.                
end procedure.
