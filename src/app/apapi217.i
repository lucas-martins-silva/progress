/*************************************************************************
** 
**  Programa: APAPI217.I - Cancelamento de Substitui‡äes.
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

def temp-table tt-tit-ap like tit-ap
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.
                                
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
                                                               
def temp-table tt-emite-ap-aux like emite-ap
   INDEX ch-codigo IS PRIMARY ep-codigo
                              cod-fornec
                              cod-estabel
                              cod-esp
                              serie
                              nr-docto 
                              parcela
                              transacao.   

def temp-table tt-emite-ap like emite-ap
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.
                                
def temp-table tt-nota-dup-aux like nota-dup
   INDEX ch-codigo IS PRIMARY ep-codigo-n
                              cod-fornec
                              cod-estabel-n
                              cod-esp-n
                              serie-n
                              nr-docto-n 
                              parcela-n.   

def temp-table tt-nota-dup like nota-dup
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.                                

/* Fim de Include */


