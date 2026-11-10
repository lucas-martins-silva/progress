/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN172A 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN172A MUT}
&ENDIF

/*****************************************************************************
**
**  BOIN172A - Verifica se a un pode ser alterada considerando as tabelas do
**             banco mgdis e movdis.
**
******************************************************************************/

def  input param p-it-codigo  as char no-undo.
def output param p-retorno    as log  no-undo.

if  can-find (first preco-item   use-index ch-itemtab   
              where preco-item.it-codigo           = p-it-codigo) 
or  can-find (first ped-item    
              where ped-item.it-codigo             = p-it-codigo)
or  can-find (first item-cli     use-index ch-item-cli  
              where item-cli.it-codigo             = p-it-codigo)
or  can-find (first it-nota-fisc use-index ch-item-nota 
              where it-nota-fisc.it-codigo         = p-it-codigo)
or  can-find (first it-ult-ent   use-index ch-it-dt     
              where it-ult-ent.it-codigo           = p-it-codigo) 
or  can-find (first it-doc-fisc  use-index ch-item      
              where it-doc-fisc.it-codigo          = p-it-codigo) then
    assign p-retorno = no.
else
    assign p-retorno = yes.
    
