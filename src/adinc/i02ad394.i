/******************************************************************
**
** i02ad394.i  Campo:clien-inadimp.idi-espec-padr-vda
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Aberto
&glob val2 Fechado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Abierto
&glob val2 Cerrado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Open
&glob val2 Cloased
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
