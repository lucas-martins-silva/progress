/******************************************************************
**
** i02ad122.i  Campo: tp-freq (frequencia)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Normal
&glob val2 Di ria
&glob val3 Semanal
&glob val4 Quinzenal
&glob val5 Mensal
&glob val6 Informada
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Normal
&glob val2 Diaria
&glob val3 Semanal
&glob val4 Quincenal
&glob val5 Mensual
&glob val6 Informada
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Normal
&glob val2 Jrnl Rpt
&glob val3 Weekly
&glob val4 Semi-monthly
&glob val5 Monthly
&glob val6 Entered
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

