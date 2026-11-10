/******************************************************************
**
** i01ad343.i  Campo: ind-tipo-documento (contr-docto-imp)  
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Invoice
&glob val2 Declara‡Æo Importa‡Æo
&glob val3 Licen‡a Importa‡Æo
&glob val4 Conhecimento Embarque
&glob val5 Carta Cr‚dito
&glob val6 Saque
&glob val7 Registro Opera‡Æo Financeira
&glob val8 Comprovante Importa‡Æo
&glob val9 Certificado Qualidade
&glob val10 Certificado Origem
&glob val11 Outros
&glob val12 Contrato Cƒmbio
&glob val13 Solicita‡Æo Despacho
&glob val14 Certificado Inspe‡Æo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Factura
&glob val2 Declaraci¢n Importaci¢n
&glob val3 Licencia Importaci¢n
&glob val4 Conocimiento Embarque
&glob val5 Carta Cr‚dito
&glob val6 Saque
&glob val7 Registro Operaci¢n Financiera
&glob val8 Comprobante Importaci¢n
&glob val9 Certificado Calidad
&glob val10 Certificado Origen
&glob val11 Otros
&glob val12 Contrato Cambio
&glob val13 Solicitaci¢n Despacho
&glob val14 Certificado Inspecci¢n
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Invoice
&glob val2 Import Statement
&glob val3 Import Licence
&glob val4 Bill of Landing
&glob val5 Credit Card
&glob val6 Withdrawal
&glob val7 Financial Operation Record
&glob val8 Import Receipt
&glob val9 Quality Certificate
&glob val10 Source Certificate
&glob val11 Others
&glob val12 Exchange Contract
&glob val13 Dispatch Request
&glob val14 Inspection Certificate
&ENDIF

{include/ind11-50.i {1} {2}}

/* fim */
