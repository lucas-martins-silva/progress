/*************************************************************************
** 
**  Programa: apapi200.I
** 
**  Objetivo: Defini‡Æo das temp-tables usadas na API apapi200.p       
**             Contabiliza‡Æo no Constas a Pagar
**
*************************************************************************/
/* Traducao */    
def temp-table tt-traducao-aux like traducao
    INDEX ch-codigo IS PRIMARY ep-codigo
                               ct-codigo
                               sc-codigo
                               dt-trans
                               ct-cp-trad
                               sc-cp-trad.

def temp-table tt-traducao like traducao
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.
