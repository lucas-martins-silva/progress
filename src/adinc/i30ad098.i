/******************************************************************
**
** i30ad098.i campo identific (originado no arquivo emitente)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Cliente
&glob val2 Fornecedor
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Cliente
&glob val2 Proveedor
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Customer
&glob val2 Vendor
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

