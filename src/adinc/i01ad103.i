/******************************************************************
**
** i01ad103.i - campo tipo (originado do arquivo esp-doc)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Normal
&glob val2 Antecipa‡Æo
&glob val3 PrevisÆo
&glob val4 Nota de D‚bito
&glob val5 Nota de Cr‚dito
&glob val6 Juros
&glob val7 Recibo
&glob val8 Reten‡Æo
&glob val9 Nota Promiss¢ria
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Normal
&glob val2 Anticipo
&glob val3 Previsi¢n
&glob val4 Nota de D‚bito
&glob val5 Nota de Cr‚dito
&glob val6 Inter‚s
&glob val7 Recibo
&glob val8 Retenci¢n
&glob val9 Pagar‚
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Normal
&glob val2 Advance Pymt
&glob val3 Forecast
&glob val4 Debit Note
&glob val5 Credit Note
&glob val6 Intrst
&glob val7 Rcpt
&glob val8 Retention
&glob val9 Promissory Note
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

