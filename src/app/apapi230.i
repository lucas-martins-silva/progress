/*************************************************************************
** 
**  Programa: APAPI230.I
** 
**  Objetivo: Defini‡Æo das temp-tables usadas na API apapi230.p
**
*************************************************************************/    
def temp-table tt-tit-conta-ap-aux like tit-conta-ap
   INDEX ch-codigo IS PRIMARY ep-codigo
                              cod-estabel
                              cod-esp
                              serie
                              nr-docto
                              parcela
                              cod-fornec.                             

def temp-table tt-tit-conta-ap like tit-conta-ap
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.   
