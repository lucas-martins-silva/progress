/******************************************************************
**
** i01ad412.i  Campo:tit-inadimp.idi-sit-bcia-tit
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Liberado
&glob val2 Protesto
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Liberado
&glob val2 Protesto
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Released
&glob val2 Protest
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
