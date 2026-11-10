/******************************************************************
**
** i01ad257.i  Campo: tipo-ordem (tipo-fluxo)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Confirmadas
&glob val2 NÆo Confirmadas
&glob val3 Ambas
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Confirmadas
&glob val2 No Confirmadas
&glob val3 Ambas
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Confirmed
&glob val2 Unconfirmed
&glob val3 Both
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

