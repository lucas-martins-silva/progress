/******************************************************************
**
** i03ad181.i campo: transacao (mov-cb)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Pagamento
&glob val2 Recebimento
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Pago
&glob val2 Recepci¢n
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Payment
&glob val2 Receipt
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

