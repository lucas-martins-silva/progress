/*************************************************************************
** 
**  Programa: APAPI238.I
**  Objetivo: Defini‡Æo das temp-tables usadas na API apapi238.p
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
    
def temp-table tt-mov-ap-aux like mov-ap
    INDEX ch-codigo IS PRIMARY ep-codigo
                               cod-fornec
                               cod-estabel
                               cod-esp
                               serie
                               nr-docto
                               parcela
                               dt-transacao.                              

def temp-table tt-his-d-ap-aux like his-d-ap
   INDEX ch-codigo IS PRIMARY ep-codigo
                              cod-estabel
                              cod-esp
                              serie
                              nr-docto
                              parcela
                              cod-fornec
                              dt-his-doc
                              sequencia.                               

def temp-table tt-tit-ap like tit-ap
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.

def temp-table tt-mov-ap like mov-ap
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.    

def temp-table tt-his-d-ap like his-d-ap
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.  


/* Fim de Include */
                                
