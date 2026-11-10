/******************************************************************
**
** i04ad206.i campo sum-contabil (param-patrim) Emitido/Nao Emitido
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Emitido
&glob val2 NÆo emitido
&glob val3 Contabilizado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Emitido
&glob val2 No Emitido
&glob val3 Contabilizado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Printed
&glob val2 Not printed
&glob val3 Posted to GL
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
