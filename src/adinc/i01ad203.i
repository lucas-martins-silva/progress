/******************************************************************
**
** i01ad203.i Campo: l-dt-fec-ap (..cr arquivo param-fec)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Fluxo
&glob val2 Vencimento
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Flujo
&glob val2 Vencimiento
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Flow
&glob val2 Due Date
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

