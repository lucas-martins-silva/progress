/******************************************************************
**
** i02ad209.i  Campo: emite-bloq (portador)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Empresa
&glob val2 Banco
&glob val3 Boleto Hibrido TECHFIN
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Empresa
&glob val2 Banco
&glob val3 Bilhete Híbrido TECHFIN
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Company
&glob val2 Bank
&glob val3 Ticket Hybrid TECHFIN
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

