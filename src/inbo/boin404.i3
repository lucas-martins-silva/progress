/*****************************************************************************
**
**       BOIN053.I3 - Determina Tipo Saldo em Poder Terceiros pelo Tipo Operacao do CFOP
**
**       Parametros: 
**                   {1} - Tipo de Operacao Terceiros ( cfop-natur.num-livre-1 )
**                          3. Transferencia
**                          4. Remessa Beneficiamento
**                          5. Retorno Beneficiamento
**                          6. Remessa Consignacao
**                          7. Faturamento Consignacao
**                          8. Devolucao Consignacao
**                          9. Devolucao Consignacao Simbolica
**                          12. Reajuste de Preco
**                          18. Remessa Dep Fechado
**                          19. Retorno Dep Fechado
**                          20. Remessa Armaz Geral
**                          21. Retorno Armaz Geral
**                  
*****************************************************************************/

/* Transferencia */
if  {1} = 3 then 
    assign i-tipo-sal-terc = 3.
else 
/*  Remessa Beneficiamento */
if  {1} = 4 then
    assign i-tipo-sal-terc = 2.
else 
/*  Retorno Beneficiamento */
if  {1} = 5 then
    assign i-tipo-sal-terc = 1.
else 
/*  Remessa Consignacao */
if  {1} = 6 then
    assign i-tipo-sal-terc = 5.                             
else 
/*  Faturamento de Consignacao */
if  {1} = 7 then
    assign i-tipo-sal-terc = 5.                             
else 
/*  Devolucao de Consignacao */
if  {1} = 8 then
    assign i-tipo-sal-terc = 4.	
/*  Devolucao de Consignacao simbolica*/
if  {1} = 9 then
    assign i-tipo-sal-terc = 4.		
	
/*Reajuste de Preco*/       
if  {1} = 12 then
    assign i-tipo-sal-terc = 5.
    
/*  Rem Dep Fechado */
if  {1} = 18 then
    assign i-tipo-sal-terc = 8.       
/*  Ret Dep Fechado */
if  {1} = 19 then
    assign i-tipo-sal-terc = 7.
    
/*  Rem Armaz Geral */
if  {1} = 20 then
    assign i-tipo-sal-terc = 10.       
/*  Ret Armaz Geral */
if  {1} = 21 then
    assign i-tipo-sal-terc = 9.

/* fim do include */
