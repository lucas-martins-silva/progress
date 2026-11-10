/******************************************************************
**
** i01ad206.i campo calc-periodo (param-patrim) Emitido/Nao Emitido
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Emitido
&glob val2 NÆo emitido
&glob val3 Descalculo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Emitido
&glob val2 No Emitido
&glob val3 No C lculado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Printed
&glob val2 Not Printed
&glob val3 Not Calculated
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
