/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGBODI159COM 2.00.00.007 } /*** 010007 ***/




/*****************************************************************/
/* UPC-BODI159com                                                   */
/*****************************************************************/

{utp/ut-glob.i}
{include/i-epc200.i "bodi159com":U}

def input        param p-ind-event as char no-undo.
def input-output param table for tt-epc.
def var hDBOPedVenda    as handle  no-undo.
def var l-permissao     as logical no-undo.

def temp-table RowErrors no-undo
    field ErrorSequence    as int
    field ErrorNumber      as int
    field ErrorDescription as char
    field ErrorParameters  as char
    field ErrorType        as char
    field ErrorHelp        as char
    field ErrorSubType     as char.
    
def VAR p-row-ped-venda as rowid no-undo.

DEFINE VARIABLE c-mes1 AS CHARACTER FORMAT "x(30)"  NO-UNDO.
DEFINE VARIABLE c-mes2 AS CHARACTER FORMAT "x(59)"  NO-UNDO.
DEFINE VARIABLE c-mes3 AS CHARACTER FORMAT "x(35)"  NO-UNDO.
DEFINE VARIABLE c-mes4 AS CHARACTER FORMAT "x(50)"  NO-UNDO.

{utp/ut-liter.i "Pedido n∆o pode ser alterado!" * R}
assign c-mes1 = return-value.
{utp/ut-liter.i "Usu†rio n∆o possui permiss∆o para alterar pedido (GG1012)" * R}
assign c-mes2 = return-value.
{utp/ut-liter.i "Dados do Pedido est∆o Incompletos!" * R}
assign c-mes3 = return-value.
{utp/ut-liter.i "Verificar se foi informado o Comprador e a Safra." * R}
assign c-mes4 = return-value.




/**************************************************/

if  p-ind-event = 'BeforeCompleteOrder' then do:

    FIND FIRST tt-epc NO-LOCK
        WHERE tt-epc.cod-parameter = "Object-Handle":U NO-ERROR.
    IF  AVAIL tt-epc THEN
        ASSIGN hDBOPedVenda = widget-handle(tt-epc.val-parameter).
             
    FIND FIRST tt-epc 
        WHERE tt-epc.cod-parameter = "Table-Rowid":U NO-ERROR.
    
    IF  AVAIL tt-epc THEN DO:
        
    END.
END.

