/******************************************************************
**
** Include de Tradu‡Æo do campo param-ap.acum-ir
**
*******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Empresa
&glob val2 Estabelecimento
&glob val3 NÆo Acumula
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Empresa
&glob val2 Sucursal
&glob val3 No Acumula
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Company
&glob val2 Site
&glob val3 Not Accumulate
&ENDIF

{include/ind01-10.i {1} {2}}

/* Fim Include */
