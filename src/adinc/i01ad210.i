/******************************************************************
**
** i01ad210.i Campo: encerra (processo)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Encerra
&glob val2 NÆo encerra
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Cerrar
&glob val2 No Cerrar
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Close
&glob val2 Not close
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

