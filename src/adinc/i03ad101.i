/******************************************************************
**
** i03ad101.i  Campo: tp-variacao empresa (cambial/previsao)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Cambial
&glob val2 Previs∆o
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Cambiar
&glob val2 Previsi¢n
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Exch Rt
&glob val2 Forecast
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

