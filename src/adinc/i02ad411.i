/******************************************************************
**
** i02ad411.i  Campo:renegoc-inadimp.idi-periodic
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Diaria
&glob val2 Semanal
&glob val3 Quinzenal
&glob val4 Mensal
&glob val5 Nr. Dias
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Diaria
&glob val2 Semanal
&glob val3 Quincenal
&glob val4 Mensual
&glob val5 Nr. Dias
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Day
&glob val2 Weekly
&glob val3 Bimonthly
&glob val4 Monthly
&glob val5 Nr. Days
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
