/******************************************************************
**
** adinc/i01ad337.i  Campo: area (obj-cenario)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
    &GLOBAL-DEFINE val1 Pedidos
    &GLOBAL-DEFINE val2 Faturamento
    &GLOBAL-DEFINE val3 Compras
    &GLOBAL-DEFINE val4 Contas a Pagar
    &GLOBAL-DEFINE val5 Contar a Receber
    &GLOBAL-DEFINE val6 Fluxo de Caixa
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
    &GLOBAL-DEFINE val1 Pedidos
    &GLOBAL-DEFINE val2 Facturaci¢n
    &GLOBAL-DEFINE val3 Compras
    &GLOBAL-DEFINE val4 Cuentas por Pagar
    &GLOBAL-DEFINE val5 Cuentar por Cobrar
    &GLOBAL-DEFINE val6 Fluxo de Caja
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
    &GLOBAL-DEFINE val1 Orders
    &GLOBAL-DEFINE val2 Invoicing
    &GLOBAL-DEFINE val3 Purchases
    &GLOBAL-DEFINE val4 Accounts Payable
    &GLOBAL-DEFINE val5 Accounts Receivable
    &GLOBAL-DEFINE val6 Cash Flow
&ENDIF

{include/ind01-10.i {1} {2}}

/* Fim */
