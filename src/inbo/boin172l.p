/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN172L 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN172L MUT}
&ENDIF



def input        param c-cod-lista-destino like item.cod-lista-destino no-undo.
def input-output param cod-erro-pi-valida  as char format "x(500)"     no-undo.
            
find first lista-destino where lista-destino.cd-lista-destino = c-cod-lista-destino no-lock no-error.
if not avail lista-destino then do:
    if cod-erro-pi-valida = "" then
        assign cod-erro-pi-valida = "6142".
    else
        assign cod-erro-pi-valida = cod-erro-pi-valida + ",6142".
end.
