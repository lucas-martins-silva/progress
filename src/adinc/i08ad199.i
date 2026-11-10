/******************************************************************
**
** i08ad199.i - campo: ind-produt-modulo-ae (param-cb)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 EMS 2
&glob val2 EMS 5
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 EMS 2
&glob val2 EMS 5
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 EMS 2
&glob val2 EMS 5
&ENDIF

{include/ind01-10.i {1} {2}}

/* Fim */

