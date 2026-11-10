/******************************************************************
**
** i01ad268.i  Campo: via-transp (transporte)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Rodovi rio
&glob val2 Aerovi rio
&glob val3 Mar¡timo
&glob val4 Ferrovi rio
&glob val5 Rodoferrovi rio
&glob val6 Rodofluvial
&glob val7 Rodoaerovi rio
&glob val8 Outros
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Terrestre
&glob val2 Aereo
&glob val3 Maritimo
&glob val4 Ferroviario
&glob val5 Terr-Ferroviario
&glob val6 Terr/Fluvial
&glob val7 TerrestreAereo
&glob val8 Otros
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Road
&glob val2 Air 
&glob val3 Sea
&glob val4 Railroad
&glob val5 Road & Railroad
&glob val6 River
&glob val7 Land & Air
&glob val8 Others
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

