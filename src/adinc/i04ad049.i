/******************************************************************
**
** i04ad049.i: campo caixa-bancos (conta-contab)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 NÆo gera lan‡amentos
&glob val2 Gera lan‡amentos
&glob val3 Conta de saldo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 No Genera Asientos
&glob val2 Genera Asientos
&glob val3 Cta de saldo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 No Trans Generation
&glob val2 Gen transactions
&glob val3 Balance acct
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

