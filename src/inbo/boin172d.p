/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN172D 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN172D MUT}
&ENDIF

/******************************************************************************
**
** BOIN172D - Valida‡Æo das tabelas do banco mgmnt 
**
*******************************************************************************/

def input        param p-it-codigo       as char format "x(16)"  no-undo.
def input-output param c-relacionados    as char format "x(100)" no-undo.
def input-output param i-relacionamentos as int no-undo.

/*** Verifica se item ‚ componente de equipamento manuten‡Æo industrial ***/
if  can-find (first comp-equipto where
                    comp-equipto.it-codigo = p-it-codigo) then do:
    assign i-relacionamentos = i-relacionamentos + 1.
    {utp/ut-table.i mgind comp-equipto 1}
    if  c-relacionados = "" then 
        assign c-relacionados  = return-value.
    else
        assign c-relacionados = c-relacionados + ", " + return-value.
end.

