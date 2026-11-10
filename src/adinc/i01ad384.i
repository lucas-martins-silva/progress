/******************************************************************
**
** i01ad384.i
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 DB
&glob val2 CR
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 DB
&glob val2 CC
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 DR
&glob val2 CR
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */
