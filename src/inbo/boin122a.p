/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN122A 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN122A MUT}
&ENDIF

/******************************************************************************
**
** BOIN122A - Valida‡Æo das tabelas do banco mgdis
**
*******************************************************************************/

def input        param p-fm-codigo  as char   no-undo.
def input-output param c-erro       as char format "x(100)" no-undo.

{cdp/cdcfgdis.i} /* defini‡Æo de pr‚-processadores distribui‡Æo */


if  can-find(first fat-estat
             where fat-estat.fm-codigo = p-fm-codigo) then do:
    if  c-erro = "ok" then
        assign c-erro = "".
    else
        assign c-erro = c-erro + ",".
    assign c-erro = c-erro + "fat-estat".
end.


/*****************************************************
* Pr‚-Processador utilizado a fim de que a valida‡Æo *
* seja feita somente ap¢s a release 2.03             * 
*****************************************************/

&if defined(bf_dis_desc_bonif) &then  /* preprocessador */
  
    /* Elimina‡Æo da tabela familia, verificar se a familia  
    est  sendo usada na tabela desconto.*/
    
    if can-find(first desconto
                where desconto.fm-codigo = p-fm-codigo) then do:        
        if  c-erro = "ok" then
            assign c-erro = "".
        else
            assign c-erro = c-erro + ",".
        assign c-erro = c-erro + "desconto".        
    end.
     
&endif /* preprocessador */ 

/*****************************************************/

