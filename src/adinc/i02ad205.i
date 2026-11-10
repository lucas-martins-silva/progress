/******************************************************************
**
** i02ad205.i Campo: cgc-cpf (param-global)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Antecipa
&glob val2 Adia
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Adelanta
&glob val2 Prorr
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Advance
&glob val2 Pstpn
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

