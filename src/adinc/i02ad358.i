/******************************************************************
**
** i02ad358.i  Campo: ind-destino (crta-remessa-exp)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Banco
&glob val2 Despachante
&glob val3 Sacado
&glob val4 Outros
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Banco
&glob val2 Despachante
&glob val3 Sacado
&glob val4 Otros
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Bank
&glob val2 Forwarding
&glob val3 Drawee
&glob val4 Others
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
