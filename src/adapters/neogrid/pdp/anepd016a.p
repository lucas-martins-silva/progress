/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD016A 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i anepd016a MAN}
&ENDIF


/********************************************************************************
** Programa : anepd016a.p
** Funcao   : Retorno das informa‡äes de pd-vendor
** Data     : 06/2001
** Autor    : Sven Siegfried Imfeld
********************************************************************************/

{adapters/neogrid/pdp/anepd016.i} 

/* Parƒmetro de entrada */
DEFINE INPUT  PARAMETER pRowidPedVenda AS ROWID  NO-UNDO.

/* Parƒmetro de saida */
DEFINE OUTPUT PARAMETER TABLE FOR tt-pd-vendor. 

FOR FIRST ped-venda WHERE ROWID(ped-venda) = pRowidPedVenda NO-LOCK:

    /*Tabela PedVendor descontinuada*/
/*     FOR FIRST pd-vendor WHERE pd-vendor.nr-pedido = ped-venda.nr-pedido NO-LOCK: */
/*         CREATE tt-pd-vendor.                                                     */
/*         ASSIGN tt-pd-vendor.taxa-cliente     = pd-vendor.taxa-cliente * 100      */
/*                tt-pd-vendor.cod-cond-cli     = pd-vendor.cod-cond-cli            */
/*                tt-pd-vendor.dias-base        = pd-vendor.dias-base               */
/*                tt-pd-vendor.data-base        = pd-vendor.data-base               */
/*                tt-pd-vendor.vl-equal-prov    = pd-vendor.vl-equal-prov           */
/*                tt-pd-vendor.cod-cond-cli-aux = pd-vendor.cod-cond-cli-aux[1].    */
/*       END.                                                                       */
END.



       
