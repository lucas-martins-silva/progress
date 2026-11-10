/******************************************************************
**
** i05ad199.i - campo: saldo(param-cb) Banco/Contabilidade
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Banco
&glob val2 Contabilidade
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Banco
&glob val2 Contabilidad
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Bank
&glob val2 General Ledger
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

