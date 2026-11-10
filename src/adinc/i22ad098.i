/******************************************************************
**
** i22ad098.i  Campo: tp-pagto
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  DOC
&glob val2  Cr‚dito Conta Corrente
&glob val3  Cheque Administrativo
&glob val4  Cobran‡a em Carteira
&glob val5  Cheque Nominal
&glob val6  D‚bito em Conta Corrente
&glob val7  CartÆo de Cr‚dito
&glob val8  Agendamento Eletr“nico
&glob val9  Boleto
&glob val10 Guia de Imposto
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  DOC 
&glob val2  Cr‚dito en Cuenta Corriente
&glob val3  Cheque Administrativo
&glob val4  Cobranza en Cartera
&glob val5  Cheque Nominal
&glob val6  D‚bito en Cuenta Corriente
&glob val7  Tarjeta de Cr‚dito
&glob val8  Agendamiento Electr“nico
&glob val9  Palanquilla
&glob val10 Gu¡a de Impuestos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  Interbank Transfer
&glob val2  Checking Acct Credit
&glob val3  Banker‹s Check
&glob val4  Cust Ord Collection
&glob val5  Nominal Check
&glob val6  Checking Acct Debit
&glob val7  Credit Card
&glob val8  Electronic Scheduling
&glob val9  Billet
&glob val10 Tax Guide
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
