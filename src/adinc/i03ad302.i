/******************************************************************
**
** adinc/i03ad302.i  
**
*******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  Deposito em Conta Corrente
&glob val2  Pagamento de Emprestimos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  Deposito en Cuenta Corriente
&glob val2  Pago de Prestamos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  Deposit in Checking Account
&glob val2  Loan Payment
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

