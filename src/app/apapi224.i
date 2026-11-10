/*************************************************************************
** 
**  Programa: APAPI224.I
** 
**  Objetivo: Defini‡Æo das temp-tables usadas na API apapi224.p
**
*************************************************************************/                                
def temp-table tt-impto-tit-ap-aux like impto-tit-ap
   INDEX ch-codigo IS PRIMARY ep-codigo
                              cod-estabel
                              cod-esp
                              serie
                              nr-docto
                              parcela
                              cod-fornec
                              cod-imposto
                              num-seq-impto.                               

def temp-table tt-impto-tit-ap like impto-tit-ap
    field cod-maq-origem   as   integer format "9999"
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
    field cod-maq-origem   as   integer format "9999"
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.                                
                                                               
    
def temp-table tt-emit-estat-aux like emit-estat
   INDEX ch-codigo IS PRIMARY cod-gr-emit
                              cod-emitente
                              data.

def temp-table tt-emit-estat like emit-estat
    field cod-maq-origem   as   integer format "9999"
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.  

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

def temp-table tt-che-emit like che-emit
    field cod-maq-origem   as   integer format "9999"
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.
                                                                
def temp-table tt-cheque-aux like cheque
   INDEX ch-codigo IS PRIMARY cod-banco
                              agencia
                              conta-corren
                              nr-cheque.                               

def temp-table tt-cheque like cheque
    field cod-maq-origem   as   integer format "9999"
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.  

