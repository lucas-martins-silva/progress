/***************************************************************************
** 
**  Programa: APAPI228.I
** 
**  Objetivo: Defini‡Æo das temp-tables usadas na API apapi228.p/apapi328.p
**
***************************************************************************/    
def temp-table tt-mov-ap-aux like mov-ap
    INDEX ch-codigo IS PRIMARY ep-codigo
                               cod-fornec
                               cod-estabel
                               cod-esp
                               serie
                               nr-docto
                               parcela
                               dt-transacao.

def temp-table tt-mov-ap like mov-ap
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.
  
