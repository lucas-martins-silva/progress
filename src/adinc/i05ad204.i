/****************************************************************************
**   adinc/i01ad204.i - Tipos de Gr ficos
****************************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
    &glob val1 Gr fico dos objetivos do valor de pedidos de venda implantados
    &glob val2 Gr fico dos objetivos do valor de pedidos de venda em aberto
    &glob val3 Gr fico dos objetivos do valor de notas emitidas
    &glob val4 Gr fico dos objetivos do valor de devolu‡Æo de clientes
    &glob val5 Gr fico dos objetivos do valor de pedidos de compra implantados
    &glob val6 Gr fico dos objetivos do valor de pedidos de compra em aberto
    &glob val7 Gr fico dos objetivos do valor de recebimentos de compras
    &glob val8 Gr fico dos objetivos do valor pago
    &glob val9 Gr fico dos objetivos do valor a pagar
    &glob val10 Gr fico dos objetivos do valor com atraso de mais de 30 dias
    &glob val11 Gr fico dos objetivos do percentual de atraso sobre o valor a pagar
    &glob val12 Gr fico dos objetivos do prazo m‚dio de pagamento 
    &glob val13 Gr fico dos objetivos do atraso m‚dio de pagamento
    &glob val14 Gr fico dos objetivos do valor recebido
    &glob val15 Gr fico dos objetivos do valor a receber
    &glob val16 Gr fico dos objetivos do valor com atraso de mais de 30 dias
    &glob val17 Gr fico dos objetivos do percentual de atraso sobre o valor a receber
    &glob val18 Gr fico dos objetivos do prazo m‚dio de recebimento
    &glob val19 Gr fico dos objetivos do atraso m‚dio de recebimento 
    &glob val20 Gr fico dos objetivos do valor dispon¡vel 
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
    &glob val1 Gr fico de objetivos de valor de pedidos de venta implantados
    &glob val2 Gr fico de objetivos de valor de pedidos de venta abiertos
    &glob val3 Gr fico de objetivos de valor de notas emitidas
    &glob val4 Gr fico de objetivos de valor de devoluci¢n de clientes
    &glob val5 Gr fico de objetivos de valor de pedidos de compra implantados
    &glob val6 Gr fico de objetivos de valor de pedidos de compra abiertos
    &glob val7 Gr fico de objetivos de valor de recibimientos de compras
    &glob val8 Gr fico de objetivos de valor pagado
    &glob val9 Gr fico de objetivos de valor por pagar
    &glob val10 Gr fico de objetivos de valor con atraso de m s de 30 d¡as
    &glob val11 Gr fico de objetivos de porcentaje de atraso sobre valor por pagar
    &glob val12 Gr fico de objetivos de plazo medio de pagamento 
    &glob val13 Gr fico de objetivos de atraso medio de pagamento
    &glob val14 Gr fico de objetivos de valor recibido
    &glob val15 Gr fico de objetivos de valor por cobrar
    &glob val16 Gr fico de objetivos de valor con atraso de m s de 30 d¡as
    &glob val17 Gr fico de objetivos de porcentaje de atraso sobre el valor por cobrar
    &glob val18 Gr fico de objetivos de plazo medio de recibimiento
    &glob val19 Gr fico de objetivos de atraso medio de recibimiento 
    &glob val20 Gr fico de objetivos de valor disponible 
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
    &glob val1 Added customer order value objective graph
    &glob val2 Open customer order value objective graph
    &glob val3 Issued note value objective graph
    &glob val4 Customer return value objective graph
    &glob val5 Added customer order value objective graph
    &glob val6 Open customer order value objective graph
    &glob val7 Purchase receiving value objective graph
    &glob val8 Paid value objective graph
    &glob val9 Value payable objective graph
    &glob val10 Objective graph of value late in more than 30 days
    &glob val11 Days late percentage objective graph on value payable
    &glob val12 Payment average term objective graph 
    &glob val13 Payment average days late objective graph
    &glob val14 Received value objective graph
    &glob val15 Value receivable objective graph
    &glob val16 Objetive graph of value late in more than 30 days
    &glob val17 Days late percentage objective graph on value receivable
    &glob val18 Receiving average term objective graph
    &glob val19 Receiving average days late objective graph 
    &glob val20 Main value objective graph
&ENDIF

{include/ind11-50.i {1} {2}}
/* Fim */
