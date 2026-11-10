/******************************************************************
**
** i08ad200.i  Campo: param-cr.tipo-envio-serasa
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Di rio
&glob val2 Mensal
&glob val3 Semanal
&glob val4 Quinzenal
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Diario
&glob val2 Mensual
&glob val3 Semanal
&glob val4 Quincenal
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Daily
&glob val2 Monthly
&glob val3 Weekly
&glob val4 Biweekly
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
