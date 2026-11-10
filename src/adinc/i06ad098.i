/******************************************************************
**
**  i06ad098.i Campo: esp-pd-venda (emitente)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Pedido Simples
&glob val2 Programa‡Æo Entrega
   &if defined(bf_dis_contr_fornec) &then
       &glob val3 Contrato Fornecimento
   &endif    
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Pedido Simple
&glob val2 Programaci¢n Entrega
   &if defined(bf_dis_contr_fornec) &then
       &glob val3 Contrato Aprovisionamiento
   &endif    
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Simple Order
&glob val2 Delivery Schedule
   &if defined(bf_dis_contr_fornec) &then
       &glob val3 Blanket Order
   &endif    
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

