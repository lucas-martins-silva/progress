/*************************************************************************
** 
**  Programa: APAPI233.I
**  Objetivo: Defini‡Æo das temp-tables usadas na API apapi233.p
**
*************************************************************************/                                
        
def temp-table tt-tit-ap-aux like tit-ap
    INDEX ch-codigo IS PRIMARY ep-codigo
                               cod-fornec
                               cod-estabel
                               cod-esp
                               serie
                               nr-docto
                               parcela.
    
def temp-table tt-usuar-autoriza-tit-aux like usuar-autoriza-tit
    INDEX ch-codigo IS PRIMARY ep-codigo
                               nr-bordero
                               cod-portador
                               cod-fornec
                               cod-estabel
                               cod-esp
                               serie
                               nr-docto
                               parcela.
    
def temp-table tt-tit-ap like tit-ap
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.
        
def temp-table tt-usuar-autoriza-tit like usuar-autoriza-tit
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.
        
/* Fim de Include */


