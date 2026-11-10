/******************************************************************
**
** i01ad348.i  campo ind-tipo-documento (contr-docto-exp)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Invoice
&glob val2 Registro Exporta‡Æo
&glob val3 Packing List
&glob val4 Conhecimento Embarque
&glob val5 Carta Cr‚dito
&glob val6 Saque
&glob val7 Certificado Qualidade
&glob val8 Certificado Origem
&glob val9 Ap¢lice Seguro
&glob val10 Solicita‡Æo Despacho
&glob val11 Courier
&glob val12 Outros
&glob val13 Contrato Cƒmbio
&glob val14 Certificado Inspe‡Æo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Factura
&glob val2 Registro Exportaci¢n
&glob val3 Rpt Prep Embarque
&glob val4 Remito
&glob val5 Carta Cr‚dito
&glob val6 Retirada
&glob val7 Certificado Calidad
&glob val8 Certificado Origen
&glob val9 P¢liza Seguro
&glob val10 Solicitaci¢n Despacho
&glob val11 Courier
&glob val12 Otros
&glob val13 Contrato Cambio
&glob val14 Certificado Inspecci¢n
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Invoice
&glob val2 Export Record
&glob val3 Packing List
&glob val4 Packing Slip
&glob val5 Credit Card
&glob val6 Withdrawal
&glob val7 Quality Certificate
&glob val8 Source Certificate
&glob val9 Insurance Policy
&glob val10 Dispatch Request
&glob val11 Courier
&glob val12 Others
&glob val13 Exchange Contract
&glob val14 Inspection Certificate
&ENDIF

{include/ind11-50.i {1} {2}}

/* fim */
