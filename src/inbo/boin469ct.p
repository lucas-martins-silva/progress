/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN469CT 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN469CT MUT}
&ENDIF

{cdp/cdcfgman.i}

&IF DEFINED (bf_man_sfc_lc) &THEN 


def var v-qtd-tempo-turno as decimal extent 10 no-undo.

def var h-bo as handle.

{inbo/boin469c.i}
run inbo/boin469c.p persistent set h-bo.

find first area-produc-ctrab where
           cod-ctrab = "inja-01" no-lock.

create tt-tempo-turno-ctrab.
assign tt-tempo-turno-ctrab.cod-area      = area-produc-ctrab.cod-area-produc
       tt-tempo-turno-ctrab.gm-codigo     = area-produc-ctrab.gm-codigo
       tt-tempo-turno-ctrab.cod-ctrab     = area-produc-ctrab.cod-ctrab
       tt-tempo-turno-ctrab.dat-inic      = date (5,1,2000)
       tt-tempo-turno-ctrab.dat-fim       = date (5,5,2000)
       tt-tempo-turno-ctrab.qtd-segs-inic = 36000 
       tt-tempo-turno-ctrab.qtd-segs-fim  = 36000.

run DeterminarTempoTurnoCtrab in h-bo
                            (buffer tt-tempo-turno-ctrab).

display tt-tempo-turno-ctrab.qtd-tempo-turno.

pause.

find next area-produc-ctrab.

assign tt-tempo-turno-ctrab.cod-area      = area-produc-ctrab.cod-area-produc
       tt-tempo-turno-ctrab.gm-codigo     = area-produc-ctrab.gm-codigo
       tt-tempo-turno-ctrab.cod-ctrab     = area-produc-ctrab.cod-ctrab
       tt-tempo-turno-ctrab.dat-inic      = date (5,1,2000)
       tt-tempo-turno-ctrab.dat-fim       = date (5,5,2000)
       tt-tempo-turno-ctrab.qtd-segs-inic = 16000 
       tt-tempo-turno-ctrab.qtd-segs-fim  = 36000.

run DeterminarTempoTurnoCtrab in h-bo
                            (buffer tt-tempo-turno-ctrab).

display tt-tempo-turno-ctrab.qtd-tempo-turno.
pause.
find prev area-produc-ctrab.

assign tt-tempo-turno-ctrab.cod-area      = area-produc-ctrab.cod-area-produc
       tt-tempo-turno-ctrab.gm-codigo     = area-produc-ctrab.gm-codigo
       tt-tempo-turno-ctrab.cod-ctrab     = area-produc-ctrab.cod-ctrab
       tt-tempo-turno-ctrab.dat-inic      = date (5,1,2000)
       tt-tempo-turno-ctrab.dat-fim       = date (6,5,2000)
       tt-tempo-turno-ctrab.qtd-segs-inic = 36000 
       tt-tempo-turno-ctrab.qtd-segs-fim  = 36000.

run DeterminarTempoTurnoCtrab in h-bo
                            (buffer tt-tempo-turno-ctrab).

display tt-tempo-turno-ctrab.qtd-tempo-turno.
                             
delete procedure h-bo.                             

&ENDIF
