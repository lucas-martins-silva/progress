/******************************************************************
**
**  i27ad098.i Campo: ind-sit-emitente (emitente)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Liberado
&glob val2 Bloqueado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Liberado
&glob val2 Bloqueado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Released
&glob val2 Blocked
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

