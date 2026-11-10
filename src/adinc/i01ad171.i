/******************************************************************
**
**      i01ad171.i  - define o indicador mercado
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Interno
&glob val2 Externo
&glob val3 Diversos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Interno
&glob val2 Externo
&glob val3 Diversos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Internal
&glob val2 External
&glob val3 Misc
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

