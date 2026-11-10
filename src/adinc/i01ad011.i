/******************************************************************
**
** i01ad011.i Campo: apl-cota-per (apl-empr-banco) Cota/Percentual
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Cota
&glob val2 Percentual
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Cotz
&glob val2 Porcentaje
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Quote
&glob val2 Percentage
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

