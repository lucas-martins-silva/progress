/******************************************************************
**
** adiinc/i01ad296.i - ocor-bcia-bco.ind-ocor-bcia.
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Remessa
&glob val2 Retorno
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Remesa
&glob val2 Retorno
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Shipment
&glob val2 Return
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

