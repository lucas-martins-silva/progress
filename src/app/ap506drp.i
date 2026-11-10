/*****************************************************************************
***
*** app/ap506drp.i - Inicializa‡Æo do programa de cancelamento cheques.
*** 
*****************************************************************************/

{utp/ut-glob.i}
{app/ap9100.i}
{cdp/cd0666.i}

{app/ap0506d.i}

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

def var c-titulo-tela          as char                   no-undo.
def var c-parametro            as char format "x(12)"    no-undo.
def var c-impressao            as char format "x(12)"    no-undo.
def var c-destino              as char                   no-undo.
def var h-acomp                as handle                 no-undo.

form
   space(20)
   che-emit.cod-estabel 
   che-emit.cod-esp     
   che-emit.dt-emissao  
   che-emit.serie       
   che-emit.nr-docto    
   "/"
   che-emit.parcela     
   che-emit.cod-fornec  
   che-emit.nr-cheque   
   che-emit.portador    
   che-emit.valor-docto
   with stream-io no-box  no-attr-space width 132 down frame f-detalhe . 

form 
   skip(02)
   c-parametro         no-label at 01
   tt-param.portador   colon 30  skip
   tt-param.dt-emissao colon 30  skip
   tt-param.nr-cheque  colon 30
   skip(02)
   c-impressao         no-label at 01 
   c-destino           colon 30       
   " - " 
   tt-param.arquivo    no-label format "x(60)" skip
   tt-param.usuario    colon 30 skip(02) 
   with stream-io side-labels no-box width 132 frame f-selecao.

{utp/ut-liter.i Destino * C}
assign c-destino:label in frame f-selecao = trim(return-value).

{utp/ut-liter.i Parƒmetros * C}
assign c-parametro = trim(return-value).

{utp/ut-liter.i ImpressÆo * C}
assign c-impressao = trim(return-value).

{include/i-rpvar.i}
{app/ap9100.i1}

create tt-param.
raw-transfer raw-param to tt-param. 

find first tt-param no-lock no-error.
find first param-ap no-lock
     where param-ap.ep-codigo = tt-param.i-ep-codigo  no-error.

find first empresa where empresa.ep-codigo = tt-param.i-ep-codigo no-lock no-error.
if  avail empresa then
    assign c-empresa = empresa.razao-social.    

{utp/ut-liter.i Cancelamento_de_Cheques * C}
assign c-titulo-tela = trim(return-value).

{utp/ut-liter.i CONTAS_A_PAGAR * C}
assign c-sistema = trim(return-value).

{utp/ut-liter.i Cancelamento_Cheques_Referente_Dia * C}
assign c-titulo-relat = trim(return-value)
       c-programa     = "AP0506D"
       c-versao       = "1.00"
       c-revisao      = "000"
       c-titulo-relat = c-titulo-relat + " " + string(today, "99/99/9999").

run utp/ut-trfrrp.p (input frame f-selecao:handle).
run utp/ut-trfrrp.p (input frame f-detalhe:handle).
{include/i-rpout.i}
{include/i-rpcab.i}                         

view frame f-cabec.
view frame f-rodape.       

/* Fim de Include */
