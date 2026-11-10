/*************************************************************************
** 
**  Programa: APAPI218.I
**  Objetivo: Defini‡Æo das temp-tables usadas na API apapi218.p
**
*************************************************************************/                                                                
    
def temp-table tt-che-emit-aux like che-emit
    INDEX ch-codigo IS PRIMARY ep-codigo
                               portador
                               nr-cheque
                               cod-fornec
                               cod-estabel
                               cod-esp
                               serie
                               nr-docto
                               parcela.
    
def temp-table tt-cheque-aux like cheque
    INDEX ch-codigo IS PRIMARY cod-banco
                               agencia
                               conta-corren
                               nr-cheque.

def temp-table tt-che-emit like che-emit
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.
                                
def temp-table tt-cheque like cheque
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.
                                

/* Fim de Include */


