/*************************************************************************
** 
**  Programa: APAPI232.I
** 
**  Objetivo: Defini‡Æo das temp-tables usadas na API apapi232.p
**
*************************************************************************/                                
def temp-table tt-estabelec-aux like estabelec
   INDEX ch-codigo IS PRIMARY cod-estabel.

def temp-table tt-estabelec like estabelec
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.
