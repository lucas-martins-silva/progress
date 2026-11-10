/******************************************************************
**
** i01ad372.i Campo: modulo (config-nome-arq)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Contas a Pagar 
&glob val2 Contas a Receber
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Cuentas por Pagar 
&glob val2 Cuentas por Cobrar
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Accounts Payable 
&glob val2 Accounts Receivable
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */
