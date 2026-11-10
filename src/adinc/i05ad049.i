/******************************************************************
**
** i05ad049.i campo estoque (conta-contab)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Consumo
&glob val2 NÆo Consumo
&glob val3 Ordem servi‡o
&glob val4 Transferˆncia
&glob val5 MÆo-de-obra
&glob val6 Custo mercadoria vendida
&glob val7 Transit¢ria de compras
&glob val8 Transit¢ria de devolu‡Æo
&glob val9 Saldo por grupo de estoque
&glob val10 NÆo gera lan‡amentos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Consumo
&glob val2 No Consumo
&glob val3 Orden Servic
&glob val4 Transferencia
&glob val5 Mano de Obra
&glob val6 Costo Mercanc¡a Vendida
&glob val7 Transitoria de Compras
&glob val8 Transitoria Devoluci¢n
&glob val9 Saldo por Grupo Inventario
&glob val10 No Genera Asientos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Usage
&glob val2 No Usage
&glob val3 Service Order
&glob val4 Transfer
&glob val5 Labor
&glob val6 Sold Goods Cost
&glob val7 Purch Suspense Acct
&glob val8 Return Suspense Acct
&glob val9 Inventory Asset
&glob val10 No Trans Generation
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

