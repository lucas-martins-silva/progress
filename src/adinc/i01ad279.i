/******************************************************************
**
** i01ad279.i Campo: ind-produto
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 EMS 2.0
&glob val2 EMS 5.0
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 EMS 2.0
&glob val2 EMS 5.0
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 EMS 2.0
&glob val2 EMS 5.0
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */
