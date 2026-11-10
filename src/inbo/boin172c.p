/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN172C 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin172c MUT}
&ENDIF


/******************************************************************************
**
** BOIN172C - Valida‡Æo das tabelas do banco mgdis 
**
*******************************************************************************/

def input        param p-it-codigo       as char format "x(16)"  no-undo.
def input        param p-ge-codigo       as int                  no-undo.
def input-output param c-relacionados    as char format "x(100)" no-undo.
def input-output param i-relacionamentos as int no-undo.

{cdp/cdcfgdis.i} /* defini‡Æo de pr‚-processadores distribui‡Æo */


/*** Verifica se existe tabela de pre‡os ?? para o item ***/ 
if  can-find (first preco-item use-index ch-itemtab 
              where preco-item.it-codigo = p-it-codigo) then do:
   assign i-relacionamentos = i-relacionamentos + 1.
   {utp/ut-table.i mgdis preco-item 1}
   if  c-relacionados = "" then 
       assign c-relacionados  = return-value.
   else
      assign c-relacionados = c-relacionados + ", " + return-value.                     
end.                                        
 
/*** Verifica se existe algum pedido do item ***/
if  can-find (first ped-item where
                    ped-item.it-codigo = p-it-codigo) then  do:
   assign i-relacionamentos = i-relacionamentos + 1.
   {utp/ut-table.i mgdis ped-item 1}
   if c-relacionados = "" then 
       assign c-relacionados  = return-value.
   else
      assign c-relacionados = c-relacionados + ", " + return-value.                     
end.  

/*** Verifica se item ‚ de algum cliente cadastrado ***/
if  can-find (first item-cli use-index ch-item-cli where
                    item-cli.it-codigo = p-it-codigo) then  do:
   assign i-relacionamentos = i-relacionamentos + 1.
   {utp/ut-table.i mgdis item-cli 1}
   if c-relacionados = "" then 
       assign c-relacionados  = return-value.
   else
      assign c-relacionados = c-relacionados + ", " + return-value.                     
end.   
 
/*** Verifica existencia de nota fiscal do item ***/
if  can-find (first it-nota-fisc use-index ch-item-nota where
                    it-nota-fisc.it-codigo = p-it-codigo) then do:
   assign i-relacionamentos = i-relacionamentos + 1.
   {utp/ut-table.i mgdis it-nota-fisc 1}
   if c-relacionados = "" then 
       assign c-relacionados  = return-value.
   else
      assign c-relacionados = c-relacionados + ", " + return-value.                     
end.   
 
/*** Verifica‡Æo com item-caixa ?? ***/
if  can-find (first item-caixa use-index ch-item where
                    item-caixa.it-codigo = p-it-codigo) then do:
   assign i-relacionamentos = i-relacionamentos + 1.
   {utp/ut-table.i mgdis item-caixa 1}
   if c-relacionados = "" then 
       assign c-relacionados  = return-value.
   else
      assign c-relacionados = c-relacionados + ", " + return-value.                     
end.   
 
/*** Verifica documentos fiscais onde aparece o item ***/
if  can-find (first it-doc-fisc use-index ch-item where
                    it-doc-fisc.it-codigo = p-it-codigo) then do:
   assign i-relacionamentos = i-relacionamentos + 1.
   {utp/ut-table.i mgdis it-doc-fisc 1}
   if return-value <> ? THEN 
   if c-relacionados = "" then 
       assign c-relacionados  = return-value.
   else
      assign c-relacionados = c-relacionados + ", " + return-value.                     
end.   
 
/*** Verifica estat¡sticas de faturamento do item ((Æo deveria ser elimina‡Æo em cascata) ***/
if  can-find (first fat-estat use-index ch-grupo 
              where fat-estat.ge-codigo = p-ge-codigo  
                and fat-estat.it-codigo = p-it-codigo) then do:
    assign i-relacionamentos = i-relacionamentos + 1.

    {utp/ut-table.i mgdis fat-estat 1}
    if  return-value <> ? THEN 
        if  c-relacionados = "" then 
            assign c-relacionados  = return-value.
        else
           assign c-relacionados = c-relacionados + ", " + return-value.
end.   

/*** Verifica ultima entrada do item ***/
if  can-find (first it-ult-ent use-index ch-it-dt where
                    it-ult-ent.it-codigo = p-it-codigo) then do:
    assign i-relacionamentos = i-relacionamentos + 1.
    {utp/ut-table.i mgdis it-ult-ent 1}
    if return-value <> ? THEN                             
    if c-relacionados = "" then 
        assign c-relacionados  = return-value.
    else
       assign c-relacionados = c-relacionados + ", " + return-value.
end.   

/*** Verifica‡Æo de relacionamentos com item-uf ***/
if  can-find (first item-uf use-index ch-item-uf where
                    item-uf.it-codigo = p-it-codigo) then do:
   assign i-relacionamentos = i-relacionamentos + 1.
   {utp/ut-table.i mgdis item-uf 1}
   if c-relacionados = "" then 
       assign c-relacionados  = return-value.
   else
      assign c-relacionados = c-relacionados + ", " + return-value.                     
end. 

/*******************************************************************************************
*Pr‚-Processador utilizado a fim de que a valida‡Æo seja feita somente ap¢s a release 2.03 * 
*******************************************************************************************/

&if defined(bf_dis_desc_bonif) &then  /* preprocessador */
  
    /* Elimina‡Æo da tabela item, verificar se o item
       est  sendo usado nas tabelas: desconto e item-bonif-cliente.*/
    
    if can-find (first desconto 
                  where desconto.it-codigo = p-it-codigo) then do:
        assign i-relacionamentos = i-relacionamentos + 1.
        {utp/ut-table.i mgdis desconto 1}
        if c-relacionados = "" then 
            assign c-relacionados  = return-value.
        else
           assign c-relacionados = c-relacionados + ", " + return-value.                     
    end. 

    if  can-find (first item-bonif-cliente 
                  where item-bonif-cliente.cod-item-bonif = p-it-codigo) then do:
        assign i-relacionamentos = i-relacionamentos + 1.
        {utp/ut-table.i mgdis item-bonif-cliente 1}
        if c-relacionados = "" then 
            assign c-relacionados  = return-value.
        else
           assign c-relacionados = c-relacionados + ", " + return-value.                     
    end.


&endif /* preprocessador */ 

