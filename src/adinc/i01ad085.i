/******************************************************************
**
** i01ad085.i  Campo: transacao (det-rateio)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Acumula
&glob val2 Transferˆncia
&glob val3 Lan‡amento
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Acumula
&glob val2 Transferencia
&glob val3 Asiento
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Accum
&glob val2 Transfer
&glob val3 Transaction
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

