/******************************************************************
**  Objeto: i03ad229.i
**  Campo: repres.idi-tip-comis-agent
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Nenhum
&glob val2 A Remeter
&glob val3 Conta Gr fica
&glob val4 Faturada
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Ning£n
&glob val2 A Remeter
&glob val3 Cuenta Gr fica
&glob val4 Facturada
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 None
&glob val2 To Send
&glob val3 Graphic Account
&glob val4 Invoiced
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
