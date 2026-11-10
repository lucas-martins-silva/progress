/******************************************************************
**
** im0710.i  Campo: via-transp (transporte) combo-box em tela de parƒmetros
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Mar¡tima
&glob val2 Fluvial
&glob val3 Lacustre
&glob val4 A‚rea
&glob val5 Postal
&glob val6 Ferrovi rio
&glob val7 Rodovi rio
&glob val8 Tubo Conduto
&glob val9 Meios Pr¢prios
&glob val10 Entrada Ficta
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Maritima
&glob val2 Fluvial
&glob val3 Lacustre
&glob val4 Aerea
&glob val5 Postal
&glob val6 Ferroviario
&glob val7 Rodoviario
&glob val8 Tubo Conduto
&glob val9 Meios Proprios
&glob val10 Entrada Ficta
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Maritima
&glob val2 Fluvial
&glob val3 Lacustre
&glob val4 Aerea
&glob val5 Postal
&glob val6 Ferroviario
&glob val7 Rodoviario
&glob val8 Tubo Conduto
&glob val9 Meios Proprios
&glob val10 Entrada Ficta
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

