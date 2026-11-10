/*************************************************************************
** 
**  Programa: APAPI235.I - Manuten‡Æo ND/NC.
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

def temp-table tt-imposto-tit-ap-aux like impto-tit-ap
    INDEX ch-codigo IS PRIMARY ep-codigo
                               cod-estabel
                               cod-esp
                               serie
                               nr-docto
                               parcela
                               cod-fornec
                               cod-imposto
                               num-seq-impto.

def temp-table tt-tit-conta-ap-aux like tit-conta-ap
    INDEX ch-codigo IS PRIMARY ep-codigo
                               cod-fornec
                               cod-estabel
                               cod-esp
                               serie
                               nr-docto
                               parcela.                               

def temp-table tt-tit-ap like tit-ap
    field cod-maq-origem   as   integer format "9999"
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.
                                
def temp-table tt-mov-ap like mov-ap
    field cod-maq-origem   as   integer format "9999"
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.
    
def temp-table tt-tit-conta-ap like tit-conta-ap
    field cod-maq-origem   as   integer format "9999"
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.

def temp-table tt-imposto-tit-ap like impto-tit-ap
    field cod-maq-origem   as   integer format "9999"
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.  
                                
/* Fim de Include */


