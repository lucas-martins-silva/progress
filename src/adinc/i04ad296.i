/******************************************************************
**
** adiinc/i04ad296.i - ocor-bcia-bco.ind-modul-dtsul.
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Contas a Receber
&glob val2 Contas a Pagar
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Ctas por Cobrar
&glob val2 Ctas por Pagar
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Acct Receivable
&glob val2 Acct Payable
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

