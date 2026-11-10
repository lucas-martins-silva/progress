/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSAR001A 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axsar001a MAX}
&ENDIF


def input param p-num-ord-inv like movto-estoq.num-ord-inv no-undo.
def output param p-cod-id-solum as char no-undo.
def output param p-sigla        as char no-undo.

{cdp/cdcfgmat.i}

find first sub-div-ordem where sub-div-ordem.num-ord-magnus = p-num-ord-inv no-lock no-error.
if avail sub-div-ordem then do:

    &if "{&bf_mat_versao_ems}" >= "2.08" &then
        assign p-cod-id-solum = sub-div-ordem.cod-id-solum.
    &else
        assign p-cod-id-solum = substring(sub-div-ordem.char-1,1,100).
    &endif
    
    find first proj-inv where proj-inv.ep-codigo   = sub-div-ordem.ep-codigo and
                              proj-inv.num-projeto = sub-div-ordem.num-projeto no-lock no-error.
    if avail proj-inv then
        assign p-sigla = proj-inv.sigla.

end.

return "ok":u.
