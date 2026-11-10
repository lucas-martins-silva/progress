/*****************************************************************
**
**      i01ad165.i  - define o indicador transacao
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  IMD   /* Implanta‡Æo de documentos */
&glob val2  BND   /* Baixa de documentos */
&glob val3  PEF   /* Pagto extra-fornecedor (d‚bito) */
&glob val4  PEC   /* Pagto extra-fornecedor (cr‚dito) */
&glob val5  AVA   /* Acerto de Valor */
&glob val6  SND   /* Substitui‡Æo de Notas por Duplicatas */
&glob val7  XYZ   /* Utilizado na razÆo dos movimentos para gravar o saldo inicial do fornec, nÆo ‚ cont bil*/
&glob val8  GPF   /* Ganhos e perdas FASB */
&glob val9  CMCAC /* Movimento CMCAC */
&glob val10 CAN   /* Escritural - Cancelar t¡tulo */
&glob val11 SUS   /* Escritural - Sustar cancelamento t¡tulo */
&glob val12 CSP   /* Escritural - Cancelar/Sustar Protesto */
&glob val13 DSV   /* Escritural - Alterar data de vencimento */
&glob val14 DSD   /* Escritural - Alterar data de desconto */
&glob val15 ALT   /* Escritural - Alterar outros dados */
&glob val16 NDC   /* Nota de d‚bito/cr‚dito */
&glob val17 VC+   /* Varia‡Æo cambial a maior */
&glob val18 VC-   /* Varia‡Æo cambial a menor */
&glob val19 IVA   /* Utilizado na Argentina para iva-liberado contabiliza‡Æo */
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  IMD   /* Implantaci¢n de documentos */
&glob val2  BND   /* Baja de documentos */
&glob val3  PEF   /* Pago extra proveedor (d‚bito) */
&glob val4  PEC   /* Pago extra proveedor (cr‚dito) */
&glob val5  AVA   /* Ajuste de Valor */
&glob val6  SND   /* Substituci¢n de Notas por Duplicatas */
&glob val7  XYZ   /* Utilizando en la raz¢n de los Movimientos para gravar el saldo inicial del proveed, no es contable */
&glob val8  GPF   /* Ganancias y P‚rdidas FASB */
&glob val9  CMCAC /* Movimiento CMCAC */
&glob val10 CAN   /* Escritural - Cancelar t¡tulo */
&glob val11 SUS   /* Escritural - Cancelaci¢n t¡tulo */
&glob val12 CSP   /* Escritural - Cancelar/Sustar Protesta */
&glob val13 DSV   /* Escritural - Alterar fecha vencimiento */
&glob val14 DSD   /* Escritural - Alterar fecha descuento */
&glob val15 ALT   /* Escritural - Alterar otros datos */
&glob val16 NDC   /* Nota de d‚bito/cr‚dito */
&glob val17 VC+   /* Variaci¢n cambiar la mayor */
&glob val18 VC-   /* Variaci¢n cambiar la menor */
&glob val19 IVA   /* Utilizado en la Argentina para IVA-liberado contabilizaci¢n */  
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  ENT   /* Document Entry */
&glob val2  IPT   /* Invoice payment */
&glob val3  OPT   /* Other payments (debit) */
&glob val4  OPC   /* Other payments (credit) */
&glob val5  ADJ   /* Adjust values */
&glob val6  RPL   /* Document Replacement by Invoices */
&glob val7  ZYZ   /* Used in the transaction  */
&glob val8  FPL   /* FASB profit/loss */
&glob val9  IMC   /* FACCAC Trans */
&glob val10 CAN   /* Special Chrages - Cancel document */
&glob val11 SUS   /* Spec Chrg - Doc cancel suspension */
&glob val12 CSP   /* Spec Chrg - Declaration Cancellation */
&glob val13 DSV   /* Spec Chrg - Modify due date */
&glob val14 DSD   /* Spec Chrg - Modify discount date */
&glob val15 MOD   /* Spec Chrg - Modify other data */
&glob val16 DCN   /* Debit/credit note */
&glob val17 EV+   /* Greater Ex Rate Variance */
&glob val18 EV-   /* Low Exchange Variation  */
&glob val19 IVA   /* Used in Argentina for Accounting Tax-release  */   
&ENDIF

{include/ind11-50.i {1} {2}}
/* Fim */


