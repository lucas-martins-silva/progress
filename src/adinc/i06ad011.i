/******************************************************************
**
**  i06ad011.i Campo: prazo (apl-empr-banco)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Curto
&glob val2 M‚dio
&glob val3 Longo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Corto
&glob val2 Medio
&glob val3 Largo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Short
&glob val2 Average
&glob val3 Long
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

