/******************************************************************
**
**      i04ad264.i  - define o indicador modalidade
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
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Cb Simple 
&glob val2 Descuento
&glob val3 Fianza
&glob val4 Judicial
&glob val5 Repres
&glob val6 Cartera
&glob val7 Proveedor
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 CB Simple 
&glob val2 Discount
&glob val3 Escrow
&glob val4 Judicial
&glob val5 Representant
&glob val6 Back Log
&glob val7 Vendor
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */


