/******************************************************************
**
** i03ad397.i  Campo:clien-inadimp.idi-vencto-fer
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Integral
&glob val2 Saldo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Integral
&glob val2 Saldo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Integral
&glob val2 Balance
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */

