/******************************************************************
**
** i02ad397.i  Campo:param-inadimp.idi-modalid-padr
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Cb Simples
&glob val2 Desconto
&glob val3 Cau‡Æo
&glob val4 Judicial
&glob val5 Repres
&glob val6 Carteira
&glob val7 Vendor
&glob val8 Cheque
&glob val9 Nota Promiss¢ria
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Cb Simple
&glob val2 Descuento
&glob val3 Cauci¢n
&glob val4 Judicial
&glob val5 Repres
&glob val6 Cartera
&glob val7 Vendor
&glob val8 Cheque
&glob val9 Pagar‚
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Simple Chrge
&glob val2 Discount
&glob val3 Caution
&glob val4 Judicial
&glob val5 Repres
&glob val6 Portfolio
&glob val7 Vendor
&glob val8 Check
&glob val9 Promissory Note
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
