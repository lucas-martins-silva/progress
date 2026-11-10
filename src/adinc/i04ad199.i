/******************************************************************
**
** i04ad199.i - campo geracao (param-cb)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  Autom tico
&glob val2  Manual
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  Autom tico
&glob val2  Manual
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  Automatic
&glob val2  Manual
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

