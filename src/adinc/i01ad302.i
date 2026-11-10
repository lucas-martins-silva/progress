/******************************************************************
**
** adinc/i02ad302.i Campo: cheque.tipo-cheque
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Pr¢prio
&glob val2 Terceiros
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Propio
&glob val2 Terceros
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Own
&glob val2 Third Party
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

