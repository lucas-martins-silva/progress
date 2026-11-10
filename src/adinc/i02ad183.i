/******************************************************************
**
**      i02ad183.i  - campo nominal (originado do arquivo mov-ap)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Portador
&glob val2 Fornecedor
&glob val3 Outros
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Portador
&glob val2 Proveedor
&glob val3 Otros
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Holder
&glob val2 Vendor
&glob val3 Others
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

