/******************************************************************
**
** adinc/i01ad303.i  Campo: operac-financ.ind-situacao.
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Implantado
&glob val2 Enviado
&glob val3 Confirmado
&glob val4 Repactuado
&glob val5 Debitado
&glob val6 Rejeitado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Implantado
&glob val2 Enviado
&glob val3 Confirmado
&glob val4 Repacto
&glob val5 Debitado
&glob val6 Rechazado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Entered
&glob val2 Sent
&glob val3 Confirmed
&glob val4 Redone
&glob val5 Debited
&glob val6 Rejected
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

