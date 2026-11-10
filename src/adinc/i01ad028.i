/******************************************************************
**
** i01ad028.i  Campo: tp-transacao (bordero-ap)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Border“
&glob val2 Cheque
&glob val3 Ordem Pagamento Tesouraria
&glob val4 Antecipa‡Æo
&glob val5 Fundo Fixo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Border¢
&glob val2 Cheque
&glob val3 Orden Pagamento Tesorer¡a
&glob val4 Anticipo
&glob val5 Fondo Fijo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Statement
&glob val2 Check
&glob val3 Treasury Payment Order
&glob val4 Adv Pymt
&glob val5 Cash Fund
&ENDIF

{include/ind01-10.i {1} {2}}
/* fim */
