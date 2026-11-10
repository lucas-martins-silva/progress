/******************************************************************
**
** i03ad200.i Campo: flag-comis (param-cr)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Valor L¡quido
&glob val2 Valor Bruto
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Valor Neto
&glob val2 Valor Bruto
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Net Value
&glob val2 Gross Value
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

