/******************************************************************
**
**      i01ad053.i  - campo onus-ioc (originado do arquivo convenio)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Fornecedor
&glob val2 Financiado ao Cliente
&glob val3 Embutido na Taxa
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Proveedor
&glob val2 Financiado al Cliente
&glob val3 Incluido en Tasa
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Vendor
&glob val2 Financing To Customer
&glob val3 Rate Inserted
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

