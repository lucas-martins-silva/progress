/******************************************************************
**
** i01ad049.i campo origem-orcam (conta-contab) Calculado/Informado
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Calculado
&glob val2 Informado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Calculado
&glob val2 Informado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Calculated
&glob val2 Entered
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

