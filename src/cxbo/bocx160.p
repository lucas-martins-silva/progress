/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX160 2.00.00.026 } /*** "010026" 07/10/2024 16:59:54 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx160 MUT}
&ENDIF

/*
**  BOCX160.P
**
**  ped-venda-cex - Pedidos de Venda Cex
**
**  Cria‡Æo : 24/02/00 - GeraBO
*/

{cxbo/bocx160.i1} /* Fonte da BOCX160 */
