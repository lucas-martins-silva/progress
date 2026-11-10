/******************************************************************
**
** i04ad198.i  Campo: prazo-pagto-ir (param-ap)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Primeiro dia £til
&glob val2 Segundo dia £til
&glob val3 terceiro dia £til
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Primer D¡a H bil
&glob val2 Segund d¡a h bil
&glob val3 Tercer D¡a H bil
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 First Working day
&glob val2 Second Working day
&glob val3 Third Working day
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

