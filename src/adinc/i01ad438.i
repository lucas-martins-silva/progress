/******************************************************************
**
** i01ad438.i Campo: idi-tip-reg (contat-manad-in)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 MANAD
&glob val2 IN86
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 MANAD
&glob val2 IN86
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 MANAD
&glob val2 IN86
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */
