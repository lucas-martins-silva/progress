/*************************************************************
**
**  i01ad330.i  - Define o indicador movto-cheque.transacao
**
*************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  IMD   /* Implanta‡Æo */
&glob val2  DEV   /* Devolu‡Æo */
&glob val3  EST   /* Estorno */
&glob val4  VC+   /* Varia‡Æo Cambial Positiva */
&glob val5  VC-   /* Varia‡Æo Cambial Negativa */
&glob val6  DEP   /* Dep¢sito */
&glob val7  SUB   /* Substitui‡Æo */
&glob val8  ALT   /* Altera‡Æo (NÆo Cont bil) */
&glob val9  COM   /* Compensa‡Æo */
&glob val10 DES   /* Desconto */
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  IMP   /* Implantaci¢n*/
&glob val2  DEV   /* Devoluci¢n  */
&glob val3  CAN   /* Cancelaci¢n */
&glob val4  VC+   /* Variaci¢n Cambiaria Positiva */
&glob val5  VC-   /* Variaci¢n Cambiaria Negativa */
&glob val6  DEP   /* Dep¢sito */
&glob val7  SUB   /* Substituci¢n */
&glob val8  MOD   /* Modificaci¢n (No Contable) */
&glob val9  COM   /* Compensaci¢n */
&glob val10 DES   /* Descuento */
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  ADD   /* Addition */
&glob val2  RTN   /* Return */
&glob val3  VOD   /* Void */
&glob val4  EV+   /* Positive Exchange Variance */
&glob val5  EV-   /* Negative Exchange Variance */
&glob val6  DEP   /* Deposit */
&glob val7  RPL   /* Replacement */
&glob val8  MOD   /* Modification (Not GL) */
&glob val9  CLR   /* Clearing */
&glob val10 CSH   /* Discount */
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */
