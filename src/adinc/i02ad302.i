/******************************************************************
**
** adinc/i02ad302.i  - cheque.situacao-cheque
**
*******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  Pendente
&glob val2  Depositado
&glob val3  Cau‡Æo
&glob val4  Substitu¡do
&glob val5  Devolvido
&glob val6  Cancelado
&glob val7  Descontado
&glob val8  Compensado
&glob val9  Pagamento Emprestimos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  Pendiente
&glob val2  Almacenado
&glob val3  Fianza
&glob val4  Substituido
&glob val5  Devuelto
&glob val6  Cancelado
&glob val7  Descontado
&glob val8  Compensado
&glob val9  Pago Pr‚stamos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  Pending
&glob val2  Deposited
&glob val3  Escrow
&glob val4  Replaced
&glob val5  Returned
&glob val6  Canceled
&glob val7  Discounted
&glob val8  Cleared
&glob val9  Loan Payment
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

