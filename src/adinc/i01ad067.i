/******************************************************************
**
** i01ad067.i Campo: tipo (demon-col)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Opera‡Æo
&glob val2 Valor
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Operaci¢n
&glob val2 Valor
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Operation
&glob val2 Value
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

