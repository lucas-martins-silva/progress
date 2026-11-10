/*************************************************************************
** 
**  Programa: APAPI201.I
** 
**  Objetivo: Defini‡Æo das temp-tables usadas na API apapi201.p
**
*************************************************************************/

def temp-table tt-doc-i-ap-aux like doc-i-ap
   INDEX ch-codigo IS PRIMARY ep-codigo
                              referencia. 

def temp-table tt-lin-i-ap-aux like lin-i-ap
   INDEX ch-codigo IS PRIMARY ep-codigo
                              referencia
                              sequencia
                              seq-import.

def temp-table tt-lin-conta-ap-aux like lin-conta-ap
   INDEX ch-codigo IS PRIMARY ep-codigo
                              cod-estabel
                              cod-esp
                              serie
                              nr-docto
                              parcela.

def temp-table tt-l-ant-ap-aux like l-ant-ap
   INDEX ch-codigo IS PRIMARY ep-codigo
                              cod-est-ant
                              parcela-ant
                              cod-esp-ant
                              serie-ant
                              nr-docto-ant. 

def temp-table tt-l-pre-ap-aux like l-pre-ap
   INDEX ch-codigo IS PRIMARY ep-cod-pre
                              cod-est-pre
                              parcela-pre
                              cod-esp-pre
                              serie-pre
                              nr-docto-pre.  

def temp-table tt-impto-tit-pend-ap-aux like impto-tit-pend-ap
   INDEX ch-codigo IS PRIMARY ep-codigo
                              parcela
                              cod-estabel
                              cod-esp
                              serie
                              nr-docto
                              cod-fornec.  
    
def temp-table tt-doc-i-ap-mp like doc-i-ap
    field cod-maq-origem   as   integer format "9999"
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.

/*** se a temp-table j  foi definida pela apapi001.i esta include nÆo redefine  
 *** as temp-tables tt-doc-i-ap e tt-lin-i-ap. Caso contr rio elas serÆo definidas no else.
 *** A vari vel c-apapi001-inc ‚ definida na apapi001.i.                         
 ***/

&if defined(c-apapi001-inc) &then   
&else
    def temp-table tt-lin-conta-ap like lin-conta-ap
        field cod-maq-origem   as   integer format "9999"
        field num-processo     as   integer format ">>>>>>>>9" initial 0
        field num-sequencia    as   integer format ">>>>>9"    initial 0
        field ind-tipo-movto   as   integer format "99"        initial 1
        INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                    num-processo
                                    num-sequencia.

    def temp-table tt-l-ant-ap like l-ant-ap
        field cod-maq-origem   as   integer format "9999"
        field num-processo     as   integer format ">>>>>>>>9" initial 0
        field num-sequencia    as   integer format ">>>>>9"    initial 0
        field ind-tipo-movto   as   integer format "99"        initial 1
        INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                    num-processo
                                    num-sequencia.                             

    def temp-table tt-lin-i-ap like lin-i-ap
        field cod-maq-origem   as   integer format "9999"
        field num-processo     as   integer format ">>>>>>>>9" initial 0
        field num-sequencia    as   integer format ">>>>>9"    initial 0
        field ind-tipo-movto   as   integer format "99"        initial 1
        INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                    num-processo
                                    num-sequencia.  

    def temp-table tt-doc-i-ap like doc-i-ap
        field cod-maq-origem   as   integer format "9999"
        field num-processo     as   integer format ">>>>>>>>9" initial 0
        field num-sequencia    as   integer format ">>>>>9"    initial 0
        field ind-tipo-movto   as   integer format "99"        initial 1
        INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                    num-processo
                                    num-sequencia.

    def temp-table tt-impto-tit-pend-ap like impto-tit-pend-ap
        field cod-maq-origem   as   integer format "9999"
        field num-processo     as   integer format ">>>>>>>>9" initial 0
        field num-sequencia    as   integer format ">>>>>9"    initial 0
        field ind-tipo-movto   as   integer format "99"        initial 1
        INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                    num-processo
                                    num-sequencia. 
    
    def temp-table tt-l-pre-ap like l-pre-ap
        field cod-maq-origem   as   integer format "9999"
        field num-processo     as   integer format ">>>>>>>>9" initial 0
        field num-sequencia    as   integer format ">>>>>9"    initial 0
        field ind-tipo-movto   as   integer format "99"        initial 1
        INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                    num-processo
                                    num-sequencia. 

    def temp-table tt-retorno-lin-i-ap
        field cod-erro   as character format "x(10)"
        field desc-erro  as character format "x(60)"
                            view-as editor max-chars 2000 
                            scrollbar-vertical size 50 by 4
        field situacao   as logical
        field cod-chave  as character
        INDEX ch-codigo  IS PRIMARY cod-erro
                                    cod-chave.
                                    
&endif
                                


