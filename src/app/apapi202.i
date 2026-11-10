/*************************************************************************
** 
**  Programa: CrAPI209.I
** 
**  Objetivo: Defini‡Æo das temp-tables usadas na API crapi209.p
**
*************************************************************************/    
def temp-table tt-emite-ap-aux like emite-ap
   INDEX ch-codigo IS PRIMARY ep-codigo
                              cod-fornec 
                              cod-estabel
                              cod-esp
                              serie
                              nr-docto.   

def temp-table tt-emite-ap like emite-ap
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.
                                
def temp-table tt-mov-ap-aux like mov-ap
   INDEX ch-codigo IS PRIMARY num-id-mov-ap.
                              

def temp-table tt-mov-ap like mov-ap
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.                
                                                                                                                                   
def temp-table tt-tit-ap-aux like tit-ap
   INDEX ch-codigo IS PRIMARY ep-codigo
                              cod-fornec
                              cod-estabel
                              cod-esp
                              serie
                              nr-docto.                               

def temp-table tt-tit-ap like tit-ap
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.
