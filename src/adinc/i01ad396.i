/******************************************************************
**
** i01ad396.i  Campo: histor-padr-inadimp.idi-forma-rat-motiv
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Percentual
&glob val2 Valor
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Porcentaje
&glob val2 Valor
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Percentage
&glob val2 Value
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
