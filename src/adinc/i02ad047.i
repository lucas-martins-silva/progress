/******************************************************************
**
** i02ad047.i  Campo: tipo (conta)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Despesa
&glob val2 Receita
&glob val3 Vendas
&glob val4 Passivo
&glob val5 Ativo
&glob val6 Titulo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Gasto
&glob val2 Ingreso
&glob val3 Ventas
&glob val4 Pasivo
&glob val5 Activo
&glob val6 T¡tulo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Expense
&glob val2 Income
&glob val3 Sales
&glob val4 Liability
&glob val5 Asset
&glob val6 Title
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

