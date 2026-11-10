/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IMR2020RP 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i imr2020rp MIM}
&ENDIF

/*****************************************************************************
**
**       PROGRAMA: imr2020rp.p
**
**       DATA....: 
**
**       Objetivo: Contratos a Embarcar
**
**       VERSAO..: 0.00.000 - 
**
******************************************************************************/
{utp/ut-glob.i}
{include/i-rpvar.i}
{imp/imr2020.i} 
/***************************Defini‡Æo de Parƒmetros *****************************/
def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

/******************************Defini‡Æo de Form *********************************/
{imp/imr2020.i2}

/****************************** L i t e r a i s **********************************/
{utp/ut-liter.i SELE€ÇO * R}
assign c-selecao = trim(return-value).
{utp/ut-liter.i Estabelecimento * L}
assign c-impressao = trim(return-value).
{utp/ut-liter.i CLASSIFICA€ÇO * R}
assign c-classifica = trim(return-value).
{utp/ut-liter.i Pedidos_de_Drawback(Aprovados/Reprovados) * C}
assign c-titulo-relat = trim(return-value).


/*************************Cabe‡alho***************************************/
{utp/ut-liter.i DI/RE * R}
assign c-di-re = return-value.
{utp/ut-liter.i Data * R}
assign c-dt-di-re = return-value.
{utp/ut-liter.i NF * R}
assign c-nf = return-value.
{utp/ut-liter.i Data * R}
assign c-dt-nf = return-value.
{utp/ut-liter.i NCM * R}
assign c-class-fisc = return-value.
{utp/ut-liter.i Descr._Mercadoria * R}
assign c-desc-merc = return-value.
{utp/ut-liter.i Peso * R}
assign c-peso = return-value.
{utp/ut-liter.i Quant. * R}
assign c-quant = return-value.
{utp/ut-liter.i Vl.local_de_Embarque * R}
assign c-vl-merc = return-value.
{utp/ut-liter.i Vl.total * R}
assign c-vl-tot = return-value.
{utp/ut-liter.i DI * R}
assign c-text-1 = return-value.
{utp/ut-liter.i RE * R}
assign c-text-2 = return-value.
/*************************Cabe‡alho***************************************/

{utp/ut-liter.i Nr._Pedido_Drawback * R}
assign c-ped-drb = return-value.
{utp/ut-liter.i Data_EmissÆo * R}
assign c-dt-emis = return-value.
{utp/ut-liter.i Modalidade * R}
assign c-mod = return-value.
{utp/ut-liter.i Motivo_Reprova‡Æo * R}
assign c-mot = return-value.

           
           
           

/****************************** E X E C U € Ç O **********************************/

{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

find empresa no-lock where empresa.ep-codigo = tt-param.ep-codigo no-error.
assign c-empresa  = (if avail empresa then empresa.nome else "")
       c-programa = "imr2020"
       c-destino  = {varinc/var00002.i 04 tt-param.destino}. 
{include/i-rpout.i}
view frame f-cabec.
view frame f-rodape.

main-block:
do  on error  undo main-block, leave main-block
    on endkey undo main-block, leave main-block
    on stop   undo main-block, leave main-block:
    for each tt-aux-aprov:
        delete tt-aux-aprov.
    end.
    for each tt-aux-reprov:
        delete tt-aux-reprov.
    end.
      if tt-param.aprovado then
         assign i-situacao = 2.
      else  assign i-situacao = 0.
      if tt-param.reprovado then
         assign i-situacao1 = 3.
      else  assign i-situacao1 = 0.
      for each pedido-drb no-lock
          where pedido-drb.nr-pedido-drb  >= tt-param.nr-ped-draw-ini
            and pedido-drb.nr-pedido-drb  <= tt-param.nr-ped-draw-fim 
            and pedido-drb.cod-sit-ped-drb = i-situacao:
            create tt-aux-aprov.
            assign tt-aux-aprov.fixo       = "Aprovados"
                   tt-aux-aprov.nr-pedido  = pedido-drb.nr-pedido-drb
                   tt-aux-aprov.dt-emis    = pedido-drb.data-emissao
                   tt-aux-aprov.modalidade = string({cxinc/i01cx311.i 04 pedido-drb.modalidade}).
      end. /*pedido-drb*/
      for each pedido-drb no-lock
          where pedido-drb.nr-pedido-drb  >= tt-param.nr-ped-draw-ini
            and pedido-drb.nr-pedido-drb  <= tt-param.nr-ped-draw-fim 
            and pedido-drb.cod-sit-ped-drb = i-situacao1:
            create tt-aux-reprov.
            assign tt-aux-reprov.fixo          = "Reprovados"
                   tt-aux-reprov.nr-pedido     = pedido-drb.nr-pedido-drb
                   tt-aux-reprov.dt-emis       = pedido-drb.data-emissao
                   tt-aux-reprov.modalidade    = string({cxinc/i01cx311.i 04 pedido-drb.modalidade})
                   tt-aux-reprov.motivo-reprov = pedido-drb.motivo-reprovacao.
      end. /*pedido-drb*/              
      
END.


if tt-param.aprovado then
for each tt-aux-aprov break by tt-aux-aprov.fixo:
   if first-of(tt-aux-aprov.fixo) then do:
      disp c-ped-drb
           c-dt-emis
           c-mod
           c-mot
           tt-aux-aprov.fixo
           with width 132 frame f-fixo-aprov.
   end.        
   disp tt-aux-aprov.nr-pedido 
        tt-aux-aprov.dt-emis
        tt-aux-aprov.modalidade
        with width 132 frame f-aprovado.
        down with width 132 frame f-aprovado.
end.

if tt-param.reprovado then
for each tt-aux-reprov break by tt-aux-reprov.fixo:
   if first-of(tt-aux-reprov.fixo) then 
      disp c-ped-drb
           c-dt-emis
           c-mod
           c-mot
           tt-aux-reprov.fixo
           with width 132 frame f-fixo-reprov.
   disp tt-aux-reprov.nr-pedido
        tt-aux-reprov.dt-emis
        tt-aux-reprov.modalidade
        tt-aux-reprov.motivo-reprov
        with width 132 frame f-reprovado.
        down with width 132 frame f-reprovado.        
end.

{include/i-rpclo.i}
/* FIM  */


