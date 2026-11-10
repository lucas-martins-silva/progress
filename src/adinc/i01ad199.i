/******************************************************************
**
** i01ad199.i - campo: tp-ordem (param-cb)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Ambas
&glob val2 Confirmada
&glob val3 NÆo confirmada
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Ambas
&glob val2 Confirmada
&glob val3 No Confirmada
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Both
&glob val2 Confirmed
&glob val3 Not confirmed
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

