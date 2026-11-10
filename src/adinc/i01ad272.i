/******************************************************************
**
** i01ad272.i  Campo: tipo-uso (moeda-empresa)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Di rio
&glob val2 M‚dio
&glob val3 Mensal
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Diario
&glob val2 Medio
&glob val3 Mensual
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Daily
&glob val2 Average
&glob val3 Monthly
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

