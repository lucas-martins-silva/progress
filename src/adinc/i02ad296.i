/******************************************************************
**
**  adiinc/i02ad296.i - ocor-bcia-bco.ind-tip-ocor-bcia.
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  Implantaá∆o
&glob val2  Pedido de Baixa
&glob val3  Prorrogaá∆o Vencimento
&glob val4  Concess∆o Abatimento
&glob val5  Cancelamento do Abatimento
&glob val6  Alteraá∆o do Vencimento
&glob val7  Alteraá∆o Seu N£mero
&glob val8  Alteraá∆o do Uso da Empresa
&glob val9  Cancelar de Protesto
&glob val10 Baixa de Cobranáa sem T°tulo
&glob val11 Pedido de Entrega Franco Pagamento
&glob val12 Alteraá∆o Outros Dados
&glob val13 Protestar Imediatamente
&glob val14 N∆o cobrar Juros Mora
&glob val15 Pedido de Devoluá∆o
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  Implantaci¢n  
&glob val2  Pedidos de Baja
&glob val3  Prorrogaci¢n de Vencimiento
&glob val4  Concesi¢n de Rebaja
&glob val5  Cancelaci¢n de la Rebaja
&glob val6  Alteraci¢n del Vencimiento
&glob val7  Alterci¢n de su N£mero
&glob val8  Alteraci¢n del uso de Empresa
&glob val9  Cancelaci¢n de Declaraci¢n
&glob val10 Baja de Cobranza sin T°tulo
&glob val11 Pedido de Entrega franco Pagamento
&glob val12 Alteraci¢n de Otros Datos 
&glob val13 Protestar Inmediatamente 
&glob val14 No Cobrar Intereses en Mora
&glob val15 Pedido de Devoluci¢n
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  Implantation
&glob val2  Cancellation Order
&glob val3  Due Date Prorogation
&glob val4  Reduction Allowed
&glob val5  Reduction Cancellation
&glob val6  Due Date Alteration
&glob val7  Own Number Alteration
&glob val8  Company Use Alteration
&glob val9  Declaration Cancelation
&glob val10 Collection Payment without Document
&glob val11 Payment Deliver Request
&glob val12 Other Data Alteration
&glob val13 Immediate Declaration
&glob val14 Dont Chrge Interest on Arrears 
&glob val15 Return Request
&ENDIF

{include/ind11-50.i {1} {2}}

/* fim */
