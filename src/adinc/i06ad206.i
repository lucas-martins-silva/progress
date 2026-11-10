/******************************************************************
**
** i06ad206.i Campo: tipo-uso-mo (param-patrim)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Cotacao Mensal
&glob val2 Cotacao M‚dia
&glob val3 Cotacao Di ria
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Cotizc Mensual
&glob val2 Cotizcn Media
&glob val3 Cotiz Diaria
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Month Exch Rt
&glob val2 Avg Exch Rt
&glob val3 Daily Quote
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

