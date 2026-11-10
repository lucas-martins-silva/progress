/******************************************************************
**
** i01ad038.i Campo: tipo (con-bh-adm)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Movimento
&glob val2 Hist¢rico
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Movimiento
&glob val2 Hist¢rico
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Transaction
&glob val2 Comments
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

