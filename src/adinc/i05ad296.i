/******************************************************************
**
**  adiinc/i05ad296.i - ocor-bcia-bco.ind-tip-ocor-bcia.
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  Implantaá∆o
&glob val2  Acerto de Valor de pagamento
&glob val3  Cancelamento
&glob val4  Alteraá∆o Data de Emiss∆o
&glob val5  Alteraá∆o Data de Vencimento
&glob val6  Alteraá∆o Data de Desconto
&glob val7  Alteraá∆o Valor de Desconto
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  Implantaci¢n
&glob val2  Ajuste de Valor de Pago
&glob val3  Cancelaci¢n
&glob val4  Alteraci¢n Fch de Emisi¢n
&glob val5  Alteraci¢n Fch de Vencimento
&glob val6  Alteraci¢n Fecha Descuento
&glob val7  Alteraci¢n Valor Descuento
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  Entry
&glob val2  Payment Value Correction
&glob val3  Cancellation
&glob val4  Print Date Modification
&glob val5  Due Date Modification
&glob val6  Discount Date Modification
&glob val7  Discount Value Modification
&ENDIF

{include/ind11-50.i {1} {2}}
/* Fim */

