/******************************************************************
**
** i01ad159.i campo tipo (lacto-padrao) Valor/Percentual
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Valor
&glob val2 Percentual
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Valor
&glob val2 Porcentaje
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Value
&glob val2 Percentage
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

