/******************************************************************
**
** adinc/i01ad290.i Campo: Origem-impto
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Implanta‡Æo Documento
&glob val2 Baixa Documento
&glob val3 Descontos
&glob val4 Juros
&glob val5 Varia‡Æo Monet ria Descontos
&glob val6 Varia‡Æo Monet ria Juros
&glob val7 Devolu‡Æo
&glob val8 Varia‡Æo Monet ria Devolu‡Æo
&glob val9 Faturamento 
&glob val10 Nota D‚bito/Cr‚dito
&glob val11 Altera‡Æo Documento
&glob val12 Cancelamento Documento
&glob val13 Imposto nÆo Cont bil
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Implantaci¢n Documento
&glob val2 Baja Documento
&glob val3 Descuentos
&glob val4 Inter‚s
&glob val5 Variaci¢n Monetaria Descuentos
&glob val6 Variaci¢n Monetaria Interes
&glob val7 Devoluci¢n
&glob val8 Variaci¢n Monetaria Devoluci¢n
&glob val9 Facturaci¢n
&glob val10 Nota D‚bito/Cr‚dito
&glob val11 Alteraci¢n del Documento
&glob val12 Cancelaci¢n del Documento
&glob val13 Impuesto no Contable
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Doc Entry
&glob val2 Doc Payment
&glob val3 Discounts
&glob val4 Interest
&glob val5 Discount Monetary Variance
&glob val6 Interest Monetary Variance 
&glob val7 Return
&glob val8 Return Monetary Variance
&glob val9 Invoicing
&glob val10 Credit/Debit Note
&glob val11 Document Alteration
&glob val12 Document Cancellation
&glob val13 Tax not Accounted
&ENDIF

{include/ind11-50.i {1} {2}}

/* Fim */

