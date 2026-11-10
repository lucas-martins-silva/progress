/******************************************************************
**
** i01ad00535.i campo idi-retenc
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Principal
&glob val2 Adicional
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Principal
&glob val2 Adicional
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Main
&glob val2 Adicional
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */
