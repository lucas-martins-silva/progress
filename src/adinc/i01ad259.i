/******************************************************************
**
** i01ad259.i Campo: tipo (originado no arquivo tipo-rec-desp)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Receita
&glob val2 Despesa
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Ingreso
&glob val2 Gasto
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Income
&glob val2 Expense
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

