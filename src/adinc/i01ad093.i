/******************************************************************
**
** adinc/i01ad093.i  Campo: doc-i-ap.ind-sit-lote-implanta‡Æo-ap
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Normal
&glob val2 Antecipa‡äes
&glob val3 Ordem de Pagto
&glob val4 Nota Promiss¢ria
&glob val5 Confirma‡Æo Fatura
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Normal
&glob val2 Anticipos
&glob val3 Orden de Pagamento
&glob val4 Pagar‚ 
&glob val5 Confirmaci¢n Factura
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Normal
&glob val2 Adv Payments
&glob val3 Payment Order
&glob val4 Promissory Note
&glob val5 Invoicing Confirmation
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

