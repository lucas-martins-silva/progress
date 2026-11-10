/******************************************************************
**
**  i02ad260.i Campo: enviado (tit-ap)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 NÆo enviado
&glob val2 Enviado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 No Enviado
&glob val2 Enviado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Not sent
&glob val2 Sent
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

