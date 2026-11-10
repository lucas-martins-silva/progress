/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN172B 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN172B MUT}
&ENDIF

/*****************************************************************************
**
**  BOIN172B - Atualiza a tabela mi-pl-item.
**
******************************************************************************/

def  input param p-it-codigo  as char no-undo.
def  input param p-contr-plan as int  no-undo.
def  input param p-modulo-pl  as log  no-undo.
def  input param p-modulo-pi  as log  no-undo.
def  input param p-tipo-con-est as int no-undo.

/*** Item planejado pelo MRP ***/   
find mi-pl-item
    where mi-pl-item.it-codigo = p-it-codigo exclusive-lock no-error.
    
if  p-contr-plan = 1 
and p-modulo-pl then do:

    if  available mi-pl-item then 
        delete mi-pl-item.
end.

if  p-contr-plan = 2 and p-modulo-pi then do:

    if  not avail mi-pl-item then
        create mi-pl-item.

    assign mi-pl-item.replaneja-mi = yes
           mi-pl-item.it-codigo    = p-it-codigo.
end.

