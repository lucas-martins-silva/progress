/******************************************************************
**
** i01ad012.i Campo: tp-calculo (apl-empr-banco)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Linear
&glob val2 Exponencial
&glob val3 Ambos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Linear
&glob val2 Exponencial
&glob val3 Ambos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Linear
&glob val2 Exponential
&glob val3 Both
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

