/******************************************************************
**
**  i03ad209.i Campo: modalidade (portador)
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
&glob val3 Fianza
&glob val4 Judicial
&glob val5 Repres
&glob val6 Cartera
&glob val7 Provee
&glob val8 Cheque
&glob val9 Pagare
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Simple
&glob val2 Discount
&glob val3 Escrow
&glob val4 In Court
&glob val5 Represent 
&glob val6 Portfolio
&glob val7 Vendor
&glob val8 Check
&glob val9 Promissory Note
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
