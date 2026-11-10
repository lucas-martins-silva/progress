/******************************************************************
**
** i02ad206.i campo moviment-per (param-patrim) Emitido/Nao Emitido
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Emitido
&glob val2 NÆo emitido
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Emitido
&glob val2 No Emitido
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Printed
&glob val2 Not printed
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

