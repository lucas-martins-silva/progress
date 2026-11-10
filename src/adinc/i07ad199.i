/******************************************************************
**
** i01ad199.i - campo: tp-ordem (param-cb)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Considera
&glob val2 NÆo considera
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Considera
&glob val2 No Considera
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Include
&glob val2 Exclude
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

