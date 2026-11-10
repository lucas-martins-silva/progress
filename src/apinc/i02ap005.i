/***********************************************************************
**
**   i02ap005.i   log-ordem.situacao
**
***********************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Ordem Producao
&glob val2 Ordem Compra
&glob val3 Ordem Compra de Beneficiamento
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Orden Producci¢n
&glob val2 Orden Compra
&glob val3 Orden Compra de Maquila
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Manufacturing Order
&glob val2 Purchase Requisition
&glob val3 Subcontracting Purchase Requisition
&ENDIF
 
{include/ind01-10.i {1} {2}}

/*  Fim  */
