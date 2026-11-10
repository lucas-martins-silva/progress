/*************************************************************************
**
** Include: ap8100.i3 - Execu‡Æo do programa ap8100.p
**
*************************************************************************/

assign l-quebra-ap8100      = {1}
       l-ignora-gpf-ap8100  = {2}
       l-ignora-cmi-ap8100  = {3}
       l-contabiliza-ap8100 = {4}
       c-est-ini-ap8100     = {5}
       c-est-fim-ap8100     = {6}
       c-refer-ini-ap8100   = {7}
       c-refer-fim-ap8100   = {8}
       c-esp-ini-ap8100     = {9}
       c-esp-fim-ap8100     = {10}
       da-ini-per-ap8100    = {11}
       da-fim-per-ap8100    = {12}
       c-include-ap8100     = "{13}"
       c-prog-hist-ap8100   = "{14}"
       c-programa-ap8100    = c-programa
       i-port-ini-ap8100    = {15}
       i-port-fim-ap8100    = {16}.

if  c-refer-fim-ap8100 = "" then
    assign c-refer-fim-ap8100 = "ZZZZZZZZZZ".
if  c-est-fim-ap8100 = "" then
    assign c-est-fim-ap8100 = "ZZZ".
if  c-esp-fim-ap8100 = "" then
    assign c-esp-fim-ap8100 = "ZZ".
if  i-port-fim-ap8100 = 0 or
    i-port-fim-ap8100 = ? then
    assign i-port-fim-ap8100 = 99999.    

run app/ap8100.p.

/* ap8100.i3 */
