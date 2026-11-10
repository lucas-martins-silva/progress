/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0305B 2.06.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0305B MIM}
&ENDIF

/*****************************************************************************
**
**  IM0305B - Integracao Importacao Compras
**
**  Objetivo: Atualizar a situacao do pedido de compra
**
*****************************************************************************/

DEF INPUT PARAMETER pNumPedido LIKE pedido-compr.num-pedido NO-UNDO.

{cdp/cdcfgmat.i} /* defini‡Æo pre-processador Importa‡Æo */

FIND pedido-compr WHERE 
     pedido-compr.num-pedido = pNumPedido EXCLUSIVE-LOCK NO-ERROR.
&IF DEFINED(bf-mat-comex) &THEN
    ASSIGN pedido-compr.impr-pedido = NO
           pedido-compr.situacao    = "I".
&ELSE
    ASSIGN pedido-compr.impr-pedido = NO
           pedido-compr.situacao    = 1.
&ENDIF

