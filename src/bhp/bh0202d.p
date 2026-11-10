/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BH0202D 2.00.00.003} /*** "010003" 14/07/2026 15:13:27  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i Bh0202d MBH}
&ENDIF

/*******************************************************************************
**
**  BH0202D - Faz a transferencia do registro para o banco de movimentos
**
**            PEDIDOS E FATURAMENTO
**
*******************************************************************************/

def new global shared var c-arqtrans as character no-undo.
def shared var h-acomp    as handle no-undo.

def shared var r-nota-fisc as rowid.
def shared var i-reg-ft as int format ">>>,>>9".

def var i-cont as int.
/*
 * find first  hisdis.nota-fiscal where rowid(hisdis.nota-fiscal) = r-nota-fisc
 *      no-lock no-error.
 * 
 * for each  hisdis.it-nota-fisc use-index ch-nota-item
 *     where  hisdis.it-nota-fisc.cod-estabel =  hisdis.nota-fiscal.cod-estabel
 *       and  hisdis.it-nota-fisc.serie       = hisdis.nota-fiscal.serie
 *       and  hisdis.it-nota-fisc.nr-nota-fis = hisdis.nota-fiscal.nr-nota-fis
 *     exclusive-lock:
 * 
 *     for each  hisdis.ped-venda use-index ch-pedido
 *        where  hisdis.ped-venda.nome-abrev =  hisdis.it-nota-fisc.nome-ab-cli
 *           and hisdis.ped-venda.nr-pedcli  =  hisdis.it-nota-fisc.nr-pedcli
 *         exclusive-lock:
 * 
 *         for each  hisdis.ped-item of hisdis.ped-venda exclusive-lock:
 * 
 *             for each  hisdis.ped-ent of hisdis.ped-item exclusive-lock:
 *                 {bhp/bh9801.i &area=dis &arqmov=ped-ent}        
 *                 delete  hisdis.ped-ent validate(true,"").
 *                 assign i-reg-ft = i-reg-ft + 1.
 *             end.
 * 
 *             for each  hisdis.his-ped-ent of  hisdis.ped-item exclusive-lock:
 *                 {bhp/bh9801.i &area=dis &arqmov=his-ped-ent}
 *                 delete  hisdis.his-ped-ent validate(true,"").
 *                 assign i-reg-ft = i-reg-ft + 1.
 *             end.
 * 
 *             {bhp/bh9801.i &area=dis &arqmov=ped-ent}
 *             delete  hisdis.ped-item validate(true,"").
 *             assign i-reg-ft = i-reg-ft + 1.
 *         end.
 *         for each  hisdis.ped-repre use-index ch-pedrep1
 *             where hisdis.ped-repre.nr-pedido = hisdis.ped-venda.nr-pedido
 *             exclusive-lock:
 * 
 *             {bhp/bh9801.i &area=dis &arqmov=ped-repre}
 *             delete  hisdis.ped-repre validate(true,"").
 *             assign i-reg-ft = i-reg-ft + 1.
 *         end.
 *         for each  hisdis.con-pges use-index ch-pagtoesp
 *             where hisdis.con-pges.nr-pedido =  hisdis.ped-venda.nr-pedido
 *             exclusive-lock:
 * 
 *             {bhp/bh9801.i &area=dis &arqmov=con-pges}
 *             delete  hisdis.con-pges validate(true,"").
 *             assign i-reg-ft = i-reg-ft + 1.
 *         end.
 * 
 *         {bhp/bh9801.i &area=dis &arqmov=ped-venda}
 *         
 *         /*----------------- Eliminacao da tabela de locks ----------------*/
 *         find first his-ped-venda where
 *                    his-ped-venda.nr-pedido  =  hisdis.ped-venda.nr-pedido and
 *                    his-ped-venda.nr-pedcli  =  hisdis.ped-venda.nr-pedcli and
 *                    his-ped-venda.nome-abrev =  hisdis.ped-venda.nome-abrev
 *                    exclusive-lock no-error.
 *         if  avail his-ped-venda then
 *             delete his-ped-venda validate(true,"").
 *         /*----------------------------------------------------------------*/
 * 
 *         delete  hisdis.ped-venda validate(true,"").
 *         assign i-reg-ft = i-reg-ft + 1.
 *     end.
 * 
 *     for each  hisdis.fat-ser-lote use-index ch-lote
 *         where hisdis.fat-ser-lote.cod-estabel =
 *                                    hisdis.nota-fiscal.cod-estabel
 *           and  hisdis.fat-ser-lote.serie       =
 *                                    hisdis.nota-fiscal.serie
 *           and  hisdis.fat-ser-lote.nr-nota-fis =
 *                                    hisdis.nota-fiscal.nr-nota-fis
 *           and  hisdis.fat-ser-lote.nr-seq-fat  =
 *                                    hisdis.it-nota-fisc.nr-seq-fat
 *         exclusive-lock:
 *         {bhp/bh9801.i &area=dis &arqmov=fat-ser-lote}
 *         delete  hisdis.fat-ser-lote validate(true,"").
 *         assign i-reg-ft = i-reg-ft + 1.
 *     end.
 * 
 *     for each  hisdis.nar-it-nota use-index ch-narrat-it
 *         where hisdis.nar-it-nota.cod-estabel =
 *                                   hisdis.nota-fiscal.cod-estabel
 *           and  hisdis.nar-it-nota.serie         =
 *                                   hisdis.nota-fiscal.serie
 *           and  hisdis.nar-it-nota.nr-nota-fis   =
 *                                   hisdis.nota-fiscal.nr-nota-fis
 *           and  hisdis.nar-it-nota.nr-sequencia  =
 *                                   hisdis.it-nota-fisc.nr-seq-fat
 *         exclusive-lock:
 *         {bhp/bh9801.i &area=dis &arqmov=nar-it-nota}
 *         delete  hisdis.nar-it-nota validate(true, "").
 *         assign i-reg-ft = i-reg-ft + 1.
 *     end.
 * 
 *     {bhp/bh9801.i &area=dis &arqmov=it-nota-fisc}
 *     delete  hisdis.it-nota-fisc validate(true, "").
 *     assign i-reg-ft = i-reg-ft + 1.   
 * end.*/

/* fim do programa */

