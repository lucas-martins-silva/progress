/******************************************************************
**
**      i01ad098.i  - define o indicador emissao do pedido de compra
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Formul rio
&glob val2 Magn‚tico
&glob val3 Fax
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Formulario
&glob val2 Magn‚tico
&glob val3 Fax
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Form
&glob val2 Magnetic
&glob val3 Fax
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

