/******************************************************************
**
** i02ad166.i  Campo: transacao
**             (utilizado nas tabelas lin-b-cr, mov-tit).
**
*******************************************************************
**Obs: Foram respeitados os c¢digos de transa‡Æo do MAGNUS, apenas
**     a transa‡Æo de implanta‡Æo (IMP), que no MAGNUS era 0(zero),
**     foi alterada para 14 que estava dispon¡vel no MAGNUS.
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  ALT   /* - Altera‡Æo                    */
&glob val2  BAX   /* - Baixa                        */ 
&glob val3  DEV   /* - Devolu‡Æo                    */
&glob val4  IMA   /* - Impl Antecipa‡Æo             */
&glob val5  DES   /* - Desc Duplicata               */
&glob val6  EST   /* - Estorno Desc Dupl            */
&glob val7  ABT   /* - Abatimento                   */
&glob val8  CAN   /* - Cancelamento                 */   
&glob val9  PDV   /* - Pedido Devol (Escr)          */
&glob val10 PBX   /* - Pedido Baixa (Escr)          */
&glob val11 PRO   /* - Protesto (Escr)              */
&glob val12 SUS   /* - Sust Protesto (Escr)         */   
&glob val13 AVA   /* - Acerto Valor                 */
&glob val14 IMP   /* - Impl Documento               */
&glob val15 GPF   /* - Ganhos/Perdas FASB           */
&glob val16 CMCAC /* - Corr Monet Integral          */
&glob val17 DSB   /* - Despesa Banc ria             */
&glob val18 NDC   /* - Impl Nota D‚bito/Cr‚dito     */
&glob val19 VC+   /* - Varia‡Æo Cƒmbial Maior       */
&glob val20 VC-   /* - Varia‡Æo Cƒmbial Menor       */ 
&glob val21 VEB   /* - Baixa Vendor Normal          */
&glob val22 VED   /* - Baixa Vendor D‚bito          */
&glob val23 VER   /* - Baixa Vendor Repactua        */
&glob val24 DVC   /* - Devolu‡Æo Cheque             */
&glob val25 DPC   /* - Dep¢sito Cheque              */
&glob val26 SUC   /* - Substitui‡Æo Cheque          */
&glob val27 VC+C  /* - Varia‡Æo Cambial Maior Cheque*/
&glob val28 VC-C  /* - Varia‡Æo Cambial Menor Cheque*/
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  ALT   /* - Alteraci¢n                   */
&glob val2  BAJ   /* - Baja                         */
&glob val3  DEV   /* - Devolucn                     */ 
&glob val4  IMA   /* - Impl Anticipo                */
&glob val5  DES   /* - Desc Factura                 */
&glob val6  REV   /* - Revers Desc Dupl             */     
&glob val7  RBJ   /* - Rebaja                       */
&glob val8  CAN   /* - Cancelaci¢n                  */
&glob val9  PDV   /* - Pedido Devol (Escr)          */
&glob val10 PBJ   /* - Pedido Baja (Escr)           */
&glob val11 PRO   /* - Protesta (Escr)              */
&glob val12 SUS   /* - Canc Protesta (Escr)         */
&glob val13 AVA   /* - Ajuste Valor                 */
&glob val14 IMP   /* - Impl Documento               */
&glob val15 GPF   /* - Ganancs/P‚rdid FASB          */
&glob val16 CMCAC /* - Corr Monet Integral          */
&glob val17 GSB   /* - Gasto Bancario               */
&glob val18 NDC   /* - Impl Nota D‚bito/Cr‚dito     */
&glob val19 VC+   /* - Variaci¢n Cambiar Mayor      */
&glob val20 VC-   /* - Variaci¢n Cambiaria Menor    */ 
&glob val21 VEB   /* - Baja Vendor Normal           */
&glob val22 VED   /* - Baja Vendor D‚bito           */
&glob val23 VER   /* - Baja Vendor Renegociaci¢n    */
&glob val24 DVC   /* - Devoluci¢n Cheque            */
&glob val25 DPC   /* - Dep¢sito Cheque              */
&glob val26 SUC   /* - Substituci¢n Cheque          */
&glob val27 VC+C  /* - Variaci¢n Cambiaria Mayor Cheque */
&glob Val28 VC-C  /* - Variaci¢n Cambiaria Menor Cheque */
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  MOD   /* - Modify                       */ 
&glob val2  PMT   /* - Payment                      */
&glob val3  RET   /* - Return                       */
&glob val4  IMA   /* - Adv Pymt Entry               */
&glob val5  DES   /* - Ivc Discount                 */
&glob val6  VOD   /* - Ivc Disc Void                */
&glob val7  ABT   /* - Reduction                    */
&glob val8  CAN   /* - Cancellation                 */
&glob val9  ROR   /* - Return Order                 */
&glob val10 COR   /* - Cancellation Order           */
&glob val11 PRO   /* - Protest                      */
&glob val12 CAN   /* - Cancellation                 */
&glob val13 ADJ   /* - Correct Value                */
&glob val14 ENT   /* - Document Entry               */
&glob val15 FPL   /* - FASB Profit/Losses           */
&glob val16 IMC   /* - Integrate Mon Corr           */
&glob val17 DSB   /* - Bank Expenses                */ 
&glob val18 DCN   /* - Add Debit/Credit Note        */ 
&glob val19 EV+   /* - Greater Exch Rate Var        */
&glob val20 EV-   /* - Less Exch Rate Var           */   
&glob val21 VEB   /* - Normal Vendor Payment        */
&glob val22 VED   /* - Debit Vendor Payment         */
&glob val23 VER   /* - Re-negotiates Vendor Payment */
&glob val24 CRT   /* - Check Return                 */
&glob val25 CDP   /* - Check Deposit                */
&glob val26 CRP   /* - Check Replacement            */
&glob val27 EV+C  /* - Check Higher Exchange Variance */
&glob val28 EV-C  /* - Check Lower Exchange Variance  */
&ENDIF

{include/ind11-50.i {1} {2}}

/* Fim */

