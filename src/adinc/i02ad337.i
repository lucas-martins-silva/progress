/******************************************************************
**
** adinc/i02ad337.i  Campo: cod-conteudo (obj-cenario)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
    &GLOBAL-DEFINE val1 Valor de pedidos de venda implantados
    &GLOBAL-DEFINE val2 Valor de pedidos de venda em aberto
    &GLOBAL-DEFINE val3 Valor de notas emitidas
    &GLOBAL-DEFINE val4 Valor de devolu‡Æo de clientes
    &GLOBAL-DEFINE val5 Valor de pedidos de compra implantados
    &GLOBAL-DEFINE val6 Valor de pedidos de compra em aberto
    &GLOBAL-DEFINE val7 Valor de recebimentos de compras
    &GLOBAL-DEFINE val8 Valor pago
    &GLOBAL-DEFINE val9 Valor a pagar
    &GLOBAL-DEFINE val10 Valor com atraso de mais de 30 dias
    &GLOBAL-DEFINE val11 Percentual de atraso sobre o valor a pagar
    &GLOBAL-DEFINE val12 Percentual m‚dio de pagamento
    &GLOBAL-DEFINE val13 Percentual atraso m‚dio de pagamento
    &GLOBAL-DEFINE val14 Valor recebido
    &GLOBAL-DEFINE val15 Valor a receber
    &GLOBAL-DEFINE val16 Valor com atraso de mais de 30 dias
    &GLOBAL-DEFINE val17 Percentual de atraso sobre o valor a receber
    &GLOBAL-DEFINE val18 Percentual m‚dio de recebimento
    &GLOBAL-DEFINE val19 Percentual de atraso m‚dio de recebimento
    &GLOBAL-DEFINE val20 Valor dispon¡vel
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
    &GLOBAL-DEFINE val1 Valor de pedidos de venta implantados
    &GLOBAL-DEFINE val2 Valor de pedidos de venta abiertos
    &GLOBAL-DEFINE val3 Valor de notas emitidas
    &GLOBAL-DEFINE val4 Valor de devoluci¢n de clientes
    &GLOBAL-DEFINE val5 Valor de pedidos de compra implantados
    &GLOBAL-DEFINE val6 Valor de pedidos de compra abiertos
    &GLOBAL-DEFINE val7 Valor de recebimientos de compras
    &GLOBAL-DEFINE val8 Valor pagado
    &GLOBAL-DEFINE val9 Valor por pagar
    &GLOBAL-DEFINE val10 Valor con atraso de m s de 30 d¡as
    &GLOBAL-DEFINE val11 Porcentaje de atraso sobre el valor por pagar
    &GLOBAL-DEFINE val12 Porcentaje medio de pagamento
    &GLOBAL-DEFINE val13 Porcentaje atraso medio de pagamento
    &GLOBAL-DEFINE val14 Valor recibido
    &GLOBAL-DEFINE val15 Valor por cobrar
    &GLOBAL-DEFINE val16 Valor con atraso de m s de 30 d¡as
    &GLOBAL-DEFINE val17 Porcentaje de atraso sobre el valor a recibir
    &GLOBAL-DEFINE val18 Porcentaje medio de recibimiento
    &GLOBAL-DEFINE val19 Porcentaje de atraso medio de recibimiento
    &GLOBAL-DEFINE val20 Valor disponible
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
    &GLOBAL-DEFINE val1 Added customer order value
    &GLOBAL-DEFINE val2 Open customer order value
    &GLOBAL-DEFINE val3 Printed doc value
    &GLOBAL-DEFINE val4 Customer return value
    &GLOBAL-DEFINE val5 Added purchase requisition value
    &GLOBAL-DEFINE val6 Open purchase requisition value
    &GLOBAL-DEFINE val7 Purchase receiving value
    &GLOBAL-DEFINE val8 Paid value
    &GLOBAL-DEFINE val9 Value payable
    &GLOBAL-DEFINE val10 Value with more than 30 days late
    &GLOBAL-DEFINE val11 Days late percentage on value payable
    &GLOBAL-DEFINE val12 Payment average percentage
    &GLOBAL-DEFINE val13 Payment average days late percentage
    &GLOBAL-DEFINE val14 Value received 
    &GLOBAL-DEFINE val15 Value receivable
    &GLOBAL-DEFINE val16 Value with more than 30 days late
    &GLOBAL-DEFINE val17 Days late percentage on value receivable
    &GLOBAL-DEFINE val18 Receiving average percentage
    &GLOBAL-DEFINE val19 Receiving average days late percentage
    &GLOBAL-DEFINE val20 Available value
&ENDIF

{include/ind11-50.i {1} {2}}

/* Fim */
