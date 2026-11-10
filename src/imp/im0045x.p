/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0045X 2.00.00.000}  /*** 010000 ***/

/* Defini‡Æo de elementos referentes a UPC */
{include/i-epc200.i "im0045x"}

/* Defini‡Æo de parƒmetros */
def input  parameter p-ind-param          as int   no-undo.
def input  parameter rw-prazo-compra      as rowid no-undo.

if p-ind-param = 1 then do:
    for each tt-epc:
       delete tt-epc.
    end.
    create tt-epc.
    assign tt-epc.cod-event     = "after-program"
           tt-epc.cod-parameter = "prazo-compra-rowid"
           tt-epc.val-parameter = string(rw-prazo-compra).
      
    {include/i-epc201.i "after-program"}
end.

if  return-value = "NOK" then
    return "NOK".
