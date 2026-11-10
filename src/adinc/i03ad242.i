/******************************************************************
**
** i03ad242.i Campo: situacao (simulacao)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Real
&glob val2 Previs∆o
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Real
&glob val2 Previsi¢n
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Actul
&glob val2 Forecast
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

