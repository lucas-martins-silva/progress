/****************************************************************************
**   adinc/i01ad204.i - Tipos de Gr ficos.
****************************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Gr fico de Compras Efetuadas no Per¡odo
&glob val2 Gr fico de Recebimentos Efetuados no Per¡odo
&glob val3 Gr fico de Compras X Recebimentos Efetuados no Per¡odo
&glob val4 Gr fico de Vendas Efetuadas no Per¡odo
&glob val5 Gr fico de Faturamentos Efetuados no Per¡odo
&glob val6 Gr fico de Vendas X Faturamentos Efetuados no Per¡odo
&glob val7 Gr fico de Recebimentos de Contas a Receber Efetuados no Per¡odo
&glob val8 Gr fico de Vencimentos de Contas a Receber Ocorridos no Per¡odo
&glob val9 Gr fico de Recebimentos X Vencimentos de Contas a Receber no Per¡odo
&glob val10 Gr fico de Pago de Contas a Pagar Efetuados no Per¡odo
&glob val11 Gr fico de Vencimentos de Contas a Pagar Ocorridos no Per¡odo
&glob val12 Gr fico de Pago X Vencimentos de Contas a Pagar no Per¡odo
&glob val13 Gr fico do Fluxo de Caixa do Caixas e Bancos
&glob val14 Gr fico de Pago do AP e Recebimento do CR Ocorridos no Per¡odo
&glob val15 Gr fico de Evolu‡Æo do Prazo M‚dio de Contas a Receber
&glob val16 Gr fico de Evolu‡Æo do Atraso M‚dio de Contas a Receber
&glob val17 Gr fico de Evolu‡Æo do Prazo M‚dio de Contas a Pagar
&glob val18 Gr fico de Evolu‡Æo do Atraso M‚dio de Contas a Pagar
&glob val19 Gr fico Comparativo do Prazo M‚dio de Contas a Receber e a Pagar
&glob val20 Gr fico Comparativo do Atraso M‚dio do Contas a Receber e a Pagar
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Gr fico de Compras Efectuadas en Per¡odo
&glob val2 Gr fico de Recepciones Efectuados en Per¡odo
&glob val3 Gr fico de Compras X Recepciones Efectuados en Per¡odo
&glob val4 Gr fico de Ventas Efectuadas en Per¡odo
&glob val5 Gr fico de Facturaciones Efectuadas en Per¡odo
&glob val6 Gr fico de Ventas X Facturaciones Efectuadas en Per¡odo
&glob val7 Gr fico de Recepciones de Cuentas por Cobrar Efectuadas en Per¡odo
&glob val8 Gr fico de Vencimientos de Cuentas por Cobrar Ocurridos en Per¡odo
&glob val9 Gr fico de Recepciones X Vencimientos de Cuentas por Cobrar en Per¡odo
&glob val10 Gr fico de Pagado de Cuentas por Pagar Efectuados en Per¡odo
&glob val11 Gr fico de Vencimientos de Cuentas por Pagar Ocurridos en Per¡odo
&glob val12 Gr fico de Pagado X Vencimientos de Cuentas por Pagar en Per¡odo
&glob val13 Gr fico de Flujo de Caja de Cajas y Bancos
&glob val14 Gr fico de Pagado de AP y Recepci¢n de CR Ocurridos en Per¡odo
&glob val15 Gr fico de evoluci¢n del plazo medio de Cuentas por Cobrar
&glob val16 Gr fico de evoluci¢n del atraso medio de Cuentas por Cobrar
&glob val17 Gr fico de evoluci¢n del plazo medio de Cuentas por Pagar
&glob val18 Gr fico de evoluci¢n del atraso medio de Cuentas por Pagar
&glob val19 Gr fico comparativo del plazo medio de Cuentas por Cobrar y por Pagar
&glob val20 Gr fico comparativo del atraso medio de Cuentas por Cobrar y Pagar
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Period Executed Purchase Graphic
&glob val2 Period Executed Receiving Graphic
&glob val3 Period Executed Receiving X Purchase Graphic
&glob val4 Period Executed Sales Graphic
&glob val5 Period Executed Invoicing Graphic
&glob val6 Period Executed Invoicing X Sales Graphic
&glob val7 Period Executed Accounts Receivable Receiving Graphic
&glob val8 Accounts Receivable Due Date Graphic Occurred in Period
&glob val9 Period Accounts Receivable Due Date X Receiving Graphic
&glob val10 Payment Graph of Accounts Payable Executed in Period
&glob val11 Period Executed Accounts Payable Due Date Graphic
&glob val12 Account Payable Payment X Term Graph in Period
&glob val13 Cash Management Cash Flow Graphic
&glob val14 AP Payments an AR Receiving Graph Occurred in Period
&glob val15 Accounts Receivable average term evolution graphic
&glob val16 Accounts Receivable average late evolution graphic
&glob val17 Accounts Payable average term evolution graphic
&glob val18 Accounts Payable average late evolution graphic
&glob val19 Accounts Receivable and Payable average term comparison graphic
&glob val20 Accounts Payable and Receivable Average Term Comparison Graph
&ENDIF

{include/ind11-50.i {1} {2}}
/* Fim */
