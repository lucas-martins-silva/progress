/******************************************************************
**
** i01ad204.i  Campo: portador.ad-cliente
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Cliente
&glob val2 Portador
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Cliente
&glob val2 Portador
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Customer
&glob val2 Collector
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
