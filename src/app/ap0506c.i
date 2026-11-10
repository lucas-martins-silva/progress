/*****************************************************************************
**                         Parametros para o Relat¢rio                      **
*****************************************************************************/


{utp/ut-liter.i SELE€ÇO * C}
assign c-text-6 = trim(return-value).
{utp/ut-liter.i PAR¶METROS * C}
assign c-text-8 = trim(return-value).
{utp/ut-liter.i IMPRESSÇO * C}
assign c-text-9 = trim(return-value).

{utp/ut-field.i mgadm mov-ap cod-estabel 1}
assign tt-param.cod-estabel:label in frame f-parametros = trim(return-value).
{utp/ut-field.i mgadm mov-ap cod-esp 1}
assign tt-param.cod-esp:label in frame f-parametros = return-value.
{utp/ut-field.i mgadm mov-ap serie 1}
assign tt-param.serie:label in frame f-parametros = return-value.
{utp/ut-field.i mgadm mov-ap nr-docto 1}
assign tt-param.nr-docto:label in frame f-parametros = return-value.
{utp/ut-field.i mgadm mov-ap parcela * 1}
assign tt-param.parcela:label in frame f-parametros = return-value. 
{utp/ut-field.i mgadm mov-ap cod-fornec 1}
assign tt-param.cod-fornec:label in frame f-parametros = return-value. 
{utp/ut-field.i mgadm mov-ap portador * 1}
assign tt-param.portador:label in frame f-parametros = return-value. 
{utp/ut-field.i mgadm mov-ap dt-transacao 1}
assign tt-param.dt-transacao:label in frame f-parametros = return-value. 
{utp/ut-field.i mgadm mov-ap conta-contabil 1}
assign tt-param.conta-contabil:label in frame f-parametros = return-value. 
{utp/ut-field.i mgadm mov-ap nr-cheque 1}
assign tt-param.nr-cheque:label in frame f-parametros = return-value. 
{utp/ut-field.i mgadm mov-ap valor-mov 1}
assign tt-param.valor-mov:label in frame f-parametros = return-value. 

{utp/ut-liter.i Usu rio * C}
assign tt-param.usuario:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Destino * C}
assign c-destino:label in frame f-parametros = trim(return-value)
       c-destino = {varinc/var00002.i 04 tt-param.destino}.

if  page-number > 0 then page.

disp 
   c-text-6   
   tt-param.cod-estabel       
   tt-param.cod-esp           
   tt-param.serie             
   tt-param.nr-docto          
   tt-param.parcela           
   tt-param.cod-fornec        
   tt-param.portador          
   tt-param.dt-transacao      
   tt-param.conta-contabil    
   tt-param.nr-cheque         
   tt-param.valor-mov         
   c-text-9    
   c-destino                  
   tt-param.arquivo  
   tt-param.usuario           
   with frame f-parametros.
 down with frame f-parametros.  
