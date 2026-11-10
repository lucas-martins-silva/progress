/******************************************************************
**
** i03ad358.i  Campo: situacao (crta-remessa-exp)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Preparada
&glob val2 Emitida
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Preparada
&glob val2 Emitida
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Prepared
&glob val2 Issued
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
