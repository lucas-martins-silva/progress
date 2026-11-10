/*******************************************************************************
**
** IMAPI005.i - API Importacao
**
** Objetivo: Atualiza‡Æo Item-doc-est-cex,
**           atualiza os relacionamentos do Item-doc-est-cex com Docum-est-cex,
**           Docum-est, Item-doc-est
**
*********************************************************************************/

/************************** Parametros *******************************************
    c-param - movimento do registro ( "add", "mod", "del")  
    r-chave - rowid do item-doc-est-cex
*********************************************************************************/

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */

{cdp/cd4300.i3}
{ccp/cc9019.i50}

def input parameter c-param as char no-undo.
def input parameter r-chave as rowid no-undo.
def input parameter de-val-orig like item-doc-est-cex.val-desp no-undo.

def buffer b-item-doc-est-cex for item-doc-est-cex.

find item-doc-est-cex 
    where rowid(item-doc-est-cex) = r-chave 
    no-lock no-error.

/* O Magnus nao chama o codigo a seguir pois o mesmo e realizado no im1001i.p e no im1001i.i05. Portanto,
   quando o codigo abaixo for alterado, os programas im1001i.p e im1001i.i05 tambem devem ser atualizados.
   Nao foi possivel a criacao de um codigo unico devida a necessidade de criacao de diversos parametros 
   para tratar Magnus ( primeiro pede a confirmacao dos totais depois efetiva transacoes na base )
   ou EMS ( atualiza os itens da nota na base depois pede confirmacao dos totais ) tornando o 
   codigo ilegivel */
   
def var de-val-icm-orig  like item-doc-est.base-icm extent 0 no-undo.
def var de-val-icm-atual like item-doc-est.base-icm extent 0 no-undo.
def var de-dif-val-icm    like item-doc-est.base-icm extent 0 no-undo.   
   
&if defined(bf-mat-comex) &then        
&else     
    find docum-est where 
        docum-est.serie-docto  = item-doc-est-cex.serie-docto and
        docum-est.nro-docto    = item-doc-est-cex.nro-docto and                     
        docum-est.cod-emitente = item-doc-est-cex.cod-emitente and
        docum-est.nat-operacao = item-doc-est-cex.nat-operacao
        no-lock no-error.
                         
    find desp-imp where 
        desp-imp.cod-desp = item-doc-est-cex.cod-desp no-lock no-error.
    
    if  avail desp-imp then do:
        case c-param:    
            when "add" then do:            
                find item-doc-est 
                    where item-doc-est.serie-docto  = item-doc-est-cex.serie-docto 
                      and item-doc-est.nro-docto    = item-doc-est-cex.nro-docto 
                      and item-doc-est.cod-emitente = item-doc-est-cex.cod-emitente 
                      and item-doc-est.nat-operacao = item-doc-est-cex.nat-operacao 
                      and item-doc-est.sequencia    = item-doc-est-cex.sequencia
                      exclusive-lock no-error.            
                if  desp-imp.inc-val-frete then
                    assign item-doc-est.pr-total-cmi = item-doc-est.pr-total-cmi 
                                                     + item-doc-est-cex.val-desp.
                if desp-imp.inc-despesa-nota then
                    assign item-doc-est.despesas[1] = item-doc-est.despesas[1] 
                                                    + item-doc-est-cex.val-desp.                           
                if  desp-imp.inc-base-ipi then
                    assign item-doc-est.base-ipi = item-doc-est.base-ipi[1] 
                                                  + item-doc-est-cex.val-desp.
                if  desp-imp.inc-base-icms then do:
                    assign de-val-icm-orig = (item-doc-est.base-icm[1] * item-doc-est.aliquota-icm)
                                              / 100.                
                    assign item-doc-est.base-icm[1] = item-doc-est.base-icm[1] 
                                                      + item-doc-est-cex.val-desp.
                    assign de-val-icm-atual = (item-doc-est.base-icm[1] * item-doc-est.aliquota-icm)
                                               / 100.
                    assign de-dif-val-icm = de-val-icm-atual - de-val-icm-orig.
                    assign item-doc-est.despesas[1] = item-doc-est.despesas[1] + de-dif-val-icm.                                                  
                end.                                                  
            end.
            when "mod" then do:        
                find item-doc-est where 
                    item-doc-est.serie-docto  = item-doc-est-cex.serie-docto and
                    item-doc-est.nro-docto    = item-doc-est-cex.nro-docto and                                                        
                    item-doc-est.cod-emitente = item-doc-est-cex.cod-emitente and
                    item-doc-est.nat-operacao = item-doc-est-cex.nat-operacao and
                    item-doc-est.sequencia    = item-doc-est-cex.sequencia
                    exclusive-lock no-error.            
                if  desp-imp.inc-val-frete then
                    assign item-doc-est.pr-total-cmi = ( item-doc-est.pr-total-cmi - de-val-orig ) 
                                                     + item-doc-est-cex.val-desp.
                if  desp-imp.inc-despesa-nota then
                    assign item-doc-est.despesas[1] = ( item-doc-est.despesas[1] - de-val-orig ) 
                                                    + item-doc-est-cex.val-desp.
                if  desp-imp.inc-base-ipi then
                    assign item-doc-est.base-ipi = ( item-doc-est.base-ipi[1] - de-val-orig )
                                                  + item-doc-est-cex.val-desp.
                if  desp-imp.inc-base-icms then do:
                    assign de-val-icm-orig = (item-doc-est.base-icm[1] * item-doc-est.aliquota-icm)
                                              / 100.
                    assign item-doc-est.base-icm[1] = ( item-doc-est.base-icm[1] - de-val-orig )
                                                      + item-doc-est-cex.val-desp.
                    assign de-val-icm-atual = (item-doc-est.base-icm[1] * item-doc-est.aliquota-icm)
                                               / 100.
                    assign de-dif-val-icm = de-val-icm-atual - de-val-icm-orig.
                    assign item-doc-est.despesas[1] = item-doc-est.despesas[1] + de-dif-val-icm.
                end.                                                  
            end.
            when "del" then do:
                find item-doc-est where 
                    item-doc-est.serie-docto  = item-doc-est-cex.serie-docto and
                    item-doc-est.nro-docto    = item-doc-est-cex.nro-docto and                                    
                    item-doc-est.cod-emitente = item-doc-est-cex.cod-emitente and
                    item-doc-est.nat-operacao = item-doc-est-cex.nat-operacao and
                    item-doc-est.sequencia    = item-doc-est-cex.sequencia
                    exclusive-lock no-error.            
                if  desp-imp.inc-val-frete then
                    assign item-doc-est.pr-total-cmi = item-doc-est.pr-total-cmi 
                                                     - item-doc-est-cex.val-desp.
                if  desp-imp.inc-despesa-nota then
                    assign item-doc-est.despesas[1] = item-doc-est.despesas[1] 
                                                    - item-doc-est-cex.val-desp.                           
                if  desp-imp.inc-base-ipi then
                    assign item-doc-est.base-ipi = item-doc-est.base-ipi[1] 
                                                  - item-doc-est-cex.val-desp.
                if  desp-imp.inc-base-icms then do:
                    assign de-val-icm-orig = (item-doc-est.base-icm[1] * item-doc-est.aliquota-icm)
                                              / 100.
                    assign item-doc-est.base-icm[1] = item-doc-est.base-icm[1] 
                                                      - item-doc-est-cex.val-desp.                                                  
                    assign de-val-icm-atual = (item-doc-est.base-icm[1] * item-doc-est.aliquota-icm)
                                               / 100.
                    assign de-dif-val-icm = de-val-icm-atual - de-val-icm-orig.
                    assign item-doc-est.despesas[1] = item-doc-est.despesas[1] + de-dif-val-icm.
                
                end.                                                  
            end.
        end case.
        if  item-doc-est.pr-total-cmi < 0 then
            assign item-doc-est.pr-total-cmi = 0.
        if  item-doc-est.despesas[1] < 0 then
            assign item-doc-est.despesas[1] = 0.
        if  item-doc-est.base-ipi[1] < 0 then
            assign item-doc-est.base-ipi[1] = 0.
        if  item-doc-est.base-icm[1] < 0 then
            assign item-doc-est.base-icm[1] = 0.        
    end.
&endif    

/* IMAPI005.I */
