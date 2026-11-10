/******************************************************************
**
** i01ad161.i Campo: tp-registro (lay-out)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Header
&glob val2 Detalhe
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Header
&glob val2 Detalle
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Header
&glob val2 Detail
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

