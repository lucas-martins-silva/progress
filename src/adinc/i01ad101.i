/******************************************************************
**
** Include: i01ad101.i  Campo: cmi-prim-ult (empresa)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Primeira
&glob val2 éltima
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Primera
&glob val2 éltima
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 First
&glob val2 Last
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

