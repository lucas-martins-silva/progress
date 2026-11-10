/*************************************************************************
** 
**  Programa: APAPI212.I
**  Objetivo: Defini‡Æo das temp-tables usadas na API apapi212.p
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

def temp-table tt-bord-tit-aux like bord-tit
    INDEX ch-codigo IS PRIMARY ep-codigo
                               nr-bordero 
                               portador
                               cod-fornec
                               cod-estabel
                               cod-esp
                               serie
                               nr-docto
                               parcela.

def temp-table tt-hist-tit-eliminados-aux like hist-tit-eliminados
    INDEX ch-codigo IS PRIMARY ep-codigo
                               cod-estabel
                               cod-esp
                               serie
                               nr-docto
                               parcela
                               cod-fornec
                               sequencia.


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

def temp-table tt-hist-tit-eliminados like hist-tit-eliminados
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.  
                                
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
                                                               
def temp-table tt-bord-tit like bord-tit
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.

def temp-table tt-che-emit like che-emit
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.

/* Fim de Include */



