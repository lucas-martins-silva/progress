/******************************************************************
**
** i01ad013.i  Campo: sit-apolice (apolice)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Vigˆncia
&glob val2 Renovada
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Vigencia
&glob val2 Renovada
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Validity
&glob val2 Renewed
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

