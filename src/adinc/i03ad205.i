/******************************************************************
**
** i03ad205.i Campo: bloqueio-cgc (param-global)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Sem bloqueio
&glob val2 Advertencia
&glob val3 Com bloqueio
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Sin bloqueo
&glob val2 Advertencia
&glob val3 Con bloqueo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 No Hold
&glob val2 Warning
&glob val3 With hold
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

