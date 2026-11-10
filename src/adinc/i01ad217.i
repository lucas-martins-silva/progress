/******************************************************************
**
** i01ad217.i  Campo: tp-reg (reg-cobra)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Header
&glob val2 Transa‡Æo
&glob val3 Trailler
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Header
&glob val2 Movimiento
&glob val3 Trailler
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Header
&glob val2 Transaction
&glob val3 Trailer
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

