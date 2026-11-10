/******************************************************************
**
** i01ad350.i  Campo: ** transacao (contr-emprestimo)  
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Aplica‡Æo 
&glob val2 Resgate
&glob val3 Equaliza‡Æo
&glob val4 Libera‡Æo
&glob val5 Pagamento 
&glob val6 Corre‡Æo 
&glob val7 Juros
&glob val8 Corre‡Æo Competˆncia
&glob val9 Juros Competˆncia
&glob val10 Var Camb Competˆncia
&glob val11 Varia‡Æo Cambial
&glob val12 Acerto Valor a Maior
&glob val13 Acerto Valor a Menor 
&glob val14 Imposto
&glob val15 Despesa Banc ria
&glob val16 Arbitragem APB
&glob val17 Arbitragem ACR
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Inversi¢n 
&glob val2 Rescate
&glob val3 Igualaci¢n
&glob val4 Liberaci¢n
&glob val5 Pagamento 
&glob val6 Correcci¢n 
&glob val7 Intereses
&glob val8 Correcci¢n Competencia 
&glob val9 Intereses Competencia 
&glob val10 Var Camb Competencia 
&glob val11 Variaci¢n Cambiaria
&glob val12 Ajuste Valor a M s 
&glob val13 Ajuste Valor a Menos 
&glob val14 Impuesto
&glob val15 Gasto Bancario
&glob val16 Arbitraje APB
&glob val17 Arbitraje ACR
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Investment 
&glob val2 Withdrawal
&glob val3 Equalization
&glob val4 Release
&glob val5 Payment 
&glob val6 Correction 
&glob val7 Interests
&glob val8 Competence Correction 
&glob val9 Competence Interests 
&glob val10 Competence Exch Rate Var 
&glob val11 Exch Rate Variance
&glob val12 Value Adjust in More 
&glob val13 Value Adjust in Less 
&glob val14 Tax
&glob val15 Banking Expense
&glob val16 APB Arbitration
&glob val17 ACR Arbitration
&ENDIF

{include/ind11-50.i {1} {2}}

/* fim */
