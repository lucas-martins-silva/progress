/******************************************************************
**
**  adiinc/i06ad296.i - ocor-bcia-bco.ind-tip-ocor-bcia.
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  Pagamento Efetuado
&glob val2  Pagamento Rejeitado
&glob val3  Lote Aceito
&glob val4  Lote n∆o Aceito
&glob val5  Confirmaá∆o de Pagamento Agendado
&glob val6  Confirmaá∆o de Alteraá∆o
&glob val7  Confirmaá∆o Cancelamento
&glob val8  Confirmaá∆o de Exclus∆o
&glob val9  Alteraá∆o Rejeitada
&glob val10 Cancelamento Rejeitado
&glob val11 Exclus∆o Rejeitada
&glob val12 Transferencia
&glob val13 Autorizaá∆o Rejeitada
&glob val14 Outras Baixas
&glob val15 Outros
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  Pago Efectuado
&glob val2  Pago Rechazado
&glob val3  Lote Aprob
&glob val4  Lote no Aprobad
&glob val5  Confirmaci¢n de Pago Agendado
&glob val6  Confirmaci¢n Alteraci¢n
&glob val7  Confirmaci¢n Cancelaci¢n
&glob val8  Confirmaci¢n Exclusi¢n
&glob val9  Alteracn Rechazada
&glob val10 Cancelaci¢n Rechazada
&glob val11 Exclusn Rechazada
&glob val12 Transferencia
&glob val13 Autorizacn Rechazada
&glob val14 Otras Bajas
&glob val15 Otros
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  Payment Made
&glob val2  Payment Rejected
&glob val3  Lot Accept
&glob val4  Lot Not Accept
&glob val5  Scheduled Payment Confirmation 
&glob val6  Mod Confirmation 
&glob val7  Cancel Confirmation
&glob val8  Exclusion Confirmation
&glob val9  Mod Rejected
&glob val10 Cancel Rejected
&glob val11 Exclusion Rejected
&glob val12 Transfer
&glob val13 Authoriz Rejected
&glob val14 Other Payment
&glob val15 Others
&ENDIF

{include/ind11-50.i {1} {2}}
/* Fim */

