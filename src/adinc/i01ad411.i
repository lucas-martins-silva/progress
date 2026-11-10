/******************************************************************
**
** i01ad411.i  Campo:renegoc-inadimp.idi-bloq-clien
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Nenhum
&glob val2 Todos
&glob val3 Suspenso
&glob val4 Pagto … Vista
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Ninguno
&glob val2 Todos
&glob val3 Suspendido
&glob val4 Pago al Contado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 None
&glob val2 All
&glob val3 Suspended
&glob val4 Pymt in Cash
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
