/******************************************************************
**
** i04ad200.i  Campo: tp-juros-mora (param-cr)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Emiss∆o DP
&glob val2 Remessa Banco
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Emisi¢n DP
&glob val2 Env°o Banco
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Ivc Print
&glob val2 Bank Remit
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

