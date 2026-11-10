/******************************************************************
**
**  adiinc/i03ad296.i - ocor-bcia-bco.ind-tip-ocor-bcia.
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  Abatimento Cancelado
&glob val2  Abatimento Concedido
&glob val3  Alteraá∆o Vencimento
&glob val4  Baixa Autom†tica
&glob val5  Baixa Instruá∆o
&glob val6  Baixa por Transferància
&glob val7  Campo Especial Alterado
&glob val8  Cobranáa Parcial
&glob val9  Confirm Recebimento Instr. nao Prot.
&glob val10 Titulo em Ser
&glob val11 Debito Custas Cartorias
&glob val12 Emiss∆o Carta Protesto
&glob val13 Entrada Confirmada
&glob val14 Entrada Rejeitada
&glob val15 Entrada por Transferància
&glob val16 Entrada de Pedido de Protesto
&glob val17 Entrada de Sustaá∆o de Protesto
&glob val18 Enviado Cart¢rio
&glob val19 Juros Dispensados
&glob val20 Liquidaá∆o Cart¢rio
&glob val21 Liquidaá∆o Compensaá∆o
&glob val22 Liquidaá∆o Conta
&glob val23 Liquidaá∆o Normal
&glob val24 Liquidaá∆o Saldo
&glob val25 Outras Baixas
&glob val26 Outras Liquidaá‰es
&glob val27 Pagamento
&glob val28 Pagamento Ap¢s Baixa
&glob val29 Pedido Baixa Rejeitado
&glob val30 Pedido Alteraá∆o Rejeitado
&glob val31 Pedido Alteraá∆o Acatado
&glob val32 Protesto Sustado
&glob val33 Protesto n∆o Sustado
&glob val34 Protesto Devolvido Cart¢rio
&glob val35 Tarifas Banc†rias
&glob val36 Transaá∆o Rejeitada
&glob val37 Transferància Carteira Entrada
&glob val38 Transferància Carteira Baixa
&glob val39 Vencimento Alterado
&glob val40 Amortizaá‰es
&glob val41 Outros
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  Rebaja Cancelado
&glob val2  Rebaja Concedida
&glob val3  Alteraci¢n Vencto
&glob val4  Baja Autom†tica
&glob val5  Baja Instruccn
&glob val6  Baja por Transferencia
&glob val7  Campo Especial Alterado
&glob val8  Cobro Parcial
&glob val9  Confirm Recepci¢n Instr no Prot
&glob val10 T°tulo en Ser
&glob val11 DÇbito Costos Notar°a
&glob val12 Emisi¢n Carta Protesta
&glob val13 Entrada Confirmada
&glob val14 Entrada Rechazada
&glob val15 Entrada por Transferencia
&glob val16 Entrada de Pedido de Protesta
&glob val17 Entrada de Cancelaci¢n Protesta
&glob val18 Enviado Notar°a
&glob val19 Inter Dispensados
&glob val20 Liquidaci¢n Notar°a
&glob val21 Liquidaci¢n Compensacn
&glob val22 Liquidaci¢n Cta
&glob val23 Liquidacn Normal
&glob val24 Liquidacn Saldo
&glob val25 Otras Bajas
&glob val26 Otras Liquidac
&glob val27 Pago
&glob val28 Pago DespuÇs Baja
&glob val29 Pedido Baja Rechazado
&glob val30 Ped Alteraci¢n Rechazado
&glob val31 Ped Alteraci¢n Acatado
&glob val32 Protesta Cancel
&glob val33 Protesta no Cancel
&glob val34 Protesta Devuelta Notar°a
&glob val35 Tarifas Bancarias
&glob val36 Movto Rechazado
&glob val37 Transferencia Cartera Entrada
&glob val38 Transferencia Cartera Baja
&glob val39 Vencto Alterado
&glob val40 Amortizaci¢n
&glob val41 Otros
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  Reduction Canceled
&glob val2  Reduction Granted
&glob val3  Due Dt Modification
&glob val4  Automatic Pymt
&glob val5  Instruction
&glob val6  Transfer Payment
&glob val7  Modified Special Field
&glob val8  Partial Billing
&glob val9  Confirm Receipt
&glob val10 Document
&glob val11 Notary Cost Debit
&glob val12 Declaration Printing
&glob val13 Confirmed Receipt
&glob val14 Rejected Receipt
&glob val15 Receipt via Transfer
&glob val16 Declaration Receipt
&glob val17 Declaration Cancel Receipt
&glob val18 Notary Dispatch
&glob val19 Interest Waived
&glob val20 Notary Settlement
&glob val21 Clearance Settlement
&glob val22 Acct Settlement
&glob val23 Normal Settlement
&glob val24 Bal Settlement
&glob val25 Other Payment
&glob val26 Other Settlements
&glob val27 Payment
&glob val28 Payment After Cancel
&glob val29 Cancellation Rejected
&glob val30 Modification Rejected
&glob val31 Modification Accepted
&glob val32 Declar Canceled
&glob val33 Declar Not Canceled
&glob val34 Notary Returned Declar
&glob val35 Bank Tariffs
&glob val36 Trans Rejected
&glob val37 Receipt Backlog Transfer
&glob val38 Payment Backlog Transfer
&glob val39 Due Date Modified
&glob val40 Amortization
&glob val41 Others
&ENDIF

{include/ind11-50.i {1} {2}}
/* Fim */

