/*************************************************************************
** 
**  Programa: APAPI222.I
** 
**  Objetivo: Defini‡Æo das temp-tables usadas na API apapi222.p
**
*************************************************************************/                                
                
def temp-table tt-doc-b-ap-aux like doc-b-ap
   INDEX ch-codigo ep-codigo
                   referencia
   INDEX ch-estabel ep-codigo
                    cod-estabel
                    referencia.                               
                    
def temp-table tt-doc-b-ap like doc-b-ap
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.
                                
def temp-table tt-doc-b-ap-mp like doc-b-ap
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.

def temp-table tt-lin-b-ap-aux like lin-b-ap
   INDEX ch-codigo IS PRIMARY ep-codigo
                              referencia
                              sequencia.
                              

def temp-table tt2-lin-b-ap like lin-b-ap
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia. 

def temp-table tt-l-pre-ap-aux like l-pre-ap
   INDEX ch-codigo IS PRIMARY ep-cod-pre
                              cod-est-pre
                              cod-esp-pre
                              serie-pre
                              nr-docto-pre
                              parcela-pre
                              cod-fornec.

def temp-table tt-l-pre-ap like l-pre-ap
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.
                                

def temp-table tt-l-ant-ap-aux like l-ant-ap
   INDEX ch-codigo IS PRIMARY ep-codigo
                              cod-est-ant
                              cod-esp-ant
                              serie-ant
                              nr-docto-ant
                              parcela-ant
                              fornec-ant.

def temp-table tt-l-ant-ap like l-ant-ap
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.
                                
def temp-table tt-impto-tit-pend-ap-aux like impto-tit-pend-ap
   INDEX ch-codigo IS PRIMARY ep-codigo
                              cod-estabel
                              cod-esp
                              serie
                              nr-docto
                              parcela
                              cod-fornec
                              cod-imposto
                              num-seq-impto.                               

def temp-table tt-impto-tit-pend-ap like impto-tit-pend-ap
    field cod-maq-origem   as   integer format "999"       initial 0
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.  
                                
