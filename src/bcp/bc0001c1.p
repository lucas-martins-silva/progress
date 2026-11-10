/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0001C1 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0001C1 MBC}
&ENDIF


                            
/*******
**   programa de inicializacao do nota fiscal de entrada com tamanho fixo - etiqueta 2d.
**
********/

DEF INPUT PARAM h-bc0001c AS HANDLE NO-UNDO.
DEF INPUT PARAM i-layout  AS INT    NO-UNDO.


DEF VAR c-segmento AS INT NO-UNDO.
   
run cria-bc-layout IN h-bc0001c ("bc-layout":U,i-layout,"ENTRADA SEPARAD - PADRÇO DATASUL EMS 2":U,1,yes,2,"":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U,3,"|":U).

run cria-bc-layout-registro IN h-bc0001c ("bc-layout-registro":U,i-layout,yes,1,1,OUTPUT c-segmento,1,"NF":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U,1).
    
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,1,1,"docum-est.serie-docto":U,"character":U,"x(5)":U,1,0,"":U,"":U,"docum-est.serie-docto (S‚rie)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,2,1,"docum-est.nro-docto":U,"character":U,"x(16)":U,1,0,"":U,"":U,"docum-est.nro-docto (Documento)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,3,1,"docum-est.dt-emissao":U,"date":U,"99/99/9999":U,1,0,"":U,"":U,"docum-est.dt-emissao (Data EmissÆo)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,4,1,"docum-est.dt-trans":U,"date":U,"99/99/9999":U,1,0,"":U,"":U,"docum-est.dt-trans (Data Transa‡Æo)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,5,1,"docum-est.tot-valor":U,"DECIMAL":U,">>>>,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"docum-est.tot-valor (Valor Total)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,6,1,"docum-est.nat-operacao":U,"character":U,"x(06)":U,1,0,"":U,"":U,"docum-est.nat-operacao  (Nat Opera‡Æo)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,7,1,"docum-est.via-transp":U,"INTEGER":U,"9":U,1,0,"":U,"":U,"docum-est.via-transp (Via Transporte)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,8,1,"docum-est.uf":U,"character":U,"!!xx":U,1,0,"":U,"":U,"docum-est.uf  (Unid Federa‡Æo)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,9,1,"docum-est.valor-frete":U,"decimal":U,">>>>>,>>>,>>9.99":U,1,0,"":U,"":U,"docum-est.valor-frete (Valor Frete)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,10,1,"docum-est.valor-mercad":U,"decimal":U,">>>>>,>>>,>>9.99":U,1,0,"":U,"":U,"docum-est.valor-mercad (Valor Total Merc)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,11,1,"docum-est.valor-outras":U,"decimal":U,">>>>>,>>>,>>9.99":U,1,0,"":U,"":U,"docum-est.valor-outras (Outras)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,12,1,"docum-est.valor-seguro":U,"decimal":U,">>>>>,>>>,>>9.99":U,1,0,"":U,"":U,"docum-est.valor-seguro (Seguro)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,13,1,"docum-est.observacao":U,"character":U,"x(2000)":U,1,0,"":U,"":U,"docum-est.observacao  (Observa‡Æo)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,14,1,"docum-est.tot-desconto":U,"decimal":U,">>>>>,>>>,>>9.99":U,1,0,"":U,"":U,"docum-est.tot-desconto  (Total Descto)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,15,1,"docum-est.dt-venc-icm":U,"DATE":U,"99/99/9999":U,1,0,"":U,"":U,"docum-est.dt-venc-icm (Data Vcto ICMS)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,16,1,"docum-est.dt-venc-ipi":U,"DATE":U,"99/99/9999":U,1,0,"":U,"":U,"docum-est.dt-venc-ipi (Data Vcto IPI)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,17,1,"docum-est.mod-frete":U,"CHARACTER":U,"X(50)":U,1,0,"":U,"":U,"docum-est.mod-frete (Modalidade Frete)":U,"":U,0,0,0,0,no,no,?,?,"":U,"Valor diferente de branco o fret":U,"e ‚ cobrado do Emitente.Valor i":U,"gual a branco o frete ‚ cobrado":U,"do Destinat rio.":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,18,1,"docum-est.tot-peso":U,"decimal":U,">>>>,>>>,>>9.9999":U,1,0,"":U,"":U,"docum-est.tot-peso (Peso Total)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,19,1,"docum-est.nff":U,"logical":U,"Sim/NÆo":U,1,0,"":U,"":U,"docum-est.nff  (Nota Fiscal Fatura)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,20,5,"EMISSOR-NOTA-CGC":U,"CHARACTER":U,"X(30)":U,1,0,"":U,"":U,"EMISSOR-NOTA-CGC (Auxiliar)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,21,5,"RECEPTOR-NOTA-CGC":U,"CHARACTER":U,"X(30)":U,1,0,"":U,"":U,"RECEPTOR-NOTA-CGC (Auxiliar)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,22,6,"docum-est.esp-docto":U,"INTEGER":U,">9":U,1,0,"":U,"":U,"21 - docum-est.esp-docto (Campo Fixo)":U,"21":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,23,6,"docum-est.conta-transit":U,"CHARACTER":U,"x(17)":U,1,0,"":U,"":U,"0000212021111 - docum-est.conta-transit (Campo Fixo)":U,"0000212021111":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,24,6,"docum-est.estab-fisc":U,"CHARACTER":U,"x(3)":U,1,0,"":U,"":U,"1 - docum-est.estab-fisc (Campo Fixo)":U,"1":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,25,6,"docum-est.estab-fisc":U,"CHARACTER":U,"x(3)":U,1,0,"":U,"":U,"1 - docum-est.estab-fisc (Campo Fixo)":U,"1":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).

run cria-bc-layout-registro IN h-bc0001c ("bc-layout-registro":U,i-layout,yes,1,2,OUTPUT c-segmento,2,"IT":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U,2).

run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,1,1,"item-doc-est.aliquota-ipi":U,"decimal":U,">>9.99":U,1,0,"":U,"":U,"item-doc-est.aliquota-ipi (Aliquota IPI)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,2,1,"item-doc-est.aliquota-iss":U,"decimal":U,">>9.99":U,1,0,"":U,"":U,"item-doc-est.aliquota-iss (Aliquota ISS)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,3,1,"item-doc-est.aliquota-icm":U,"decimal":U,">>9.99":U,1,0,"":U,"":U,"item-doc-est.aliquota-icm  (Aliquota ICMS)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,4,1,"item-doc-est.class-fiscal":U,"character":U,"9999.99.99":U,1,0,"":U,"":U,"item-doc-est.class-fiscal (Classifica‡Æo Fiscal)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,5,1,"item-doc-est.it-codigo":U,"character":U,"x(16)":U,1,0,"":U,"":U,"item-doc-est.it-codigo (Item)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,6,1,"item-doc-est.sequencia":U,"integer":U,">>>>9":U,1,0,"":U,"":U,"item-doc-est.sequencia (Seq)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,7,1,"item-doc-est.peso-liquido":U,"decimal":U,">>>>,>>9.99999":U,1,0,"":U,"":U,"item-doc-est.peso-liquido (Peso Liq)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,8,1,"item-doc-est.quantidade":U,"decimal":U,">>>>>,>>9.9999":U,1,0,"":U,"":U,"item-doc-est.quantidade (Nossa Qtde)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,9,1,"item-doc-est.un":U,"CHARACTER":U,"xx":U,1,0,"":U,"":U,"item-doc-est.un (Unid)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,10,1,"item-doc-est.base-ipi[1]":U,"decimal":U,">>>>,>>>,>>9.99":U,1,0,"":U,"":U,"item-doc-est.base-ipi[1] (Base C lculo IPI)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,11,1,"item-doc-est.base-icm[1]":U,"decimal":U,">>>>,>>>,>>9.99":U,1,0,"":U,"":U,"item-doc-est.base-icm[1] (Base C lculo ICMS)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,12,1,"item-doc-est.base-iss[1]":U,"decimal":U,">>>>,>>>,>>9.99":U,1,0,"":U,"":U,"item-doc-est.base-iss[1] (Base C lculo ISS)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,13,1,"item-doc-est.despesas[1]":U,"decimal":U,">>>>,>>>,>>9.99":U,1,0,"":U,"":U,"item-doc-est.despesas[1] (Despesas)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,14,1,"item-doc-est.ipi-ntrib[1]":U,"decimal":U,">>>>,>>>,>>9.99":U,1,0,"":U,"":U,"item-doc-est.ipi-ntrib[1] (IPI NÆo Tributado)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,15,1,"item-doc-est.icm-ntrib[1]":U,"decimal":U,">>>>,>>>,>>9.99":U,1,0,"":U,"":U,"item-doc-est.icm-ntrib[1] (ICMS NÆo Tributado)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,16,1,"item-doc-est.iss-ntrib[1]":U,"decimal":U,">>>>,>>>,>>9.99":U,1,0,"":U,"":U,"item-doc-est.iss-ntrib[1] (ISS NÆo Tributado)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,17,1,"item-doc-est.ipi-outras[1]":U,"decimal":U,">>>>,>>>,>>9.99":U,1,0,"":U,"":U,"item-doc-est.ipi-outras[1] (IPI Outras)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,18,1,"item-doc-est.icm-outras[1]":U,"decimal":U,">>>>,>>>,>>9.99":U,1,0,"":U,"":U,"item-doc-est.icm-outras[1] (ICMS Outras)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,19,1,"item-doc-est.iss-outras[1]":U,"decimal":U,">>>>,>>>,>>9.99":U,1,0,"":U,"":U,"item-doc-est.iss-outras[1] (ISS Outras)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,20,1,"item-doc-est.preco-total[1]":U,"decimal":U,">>>>,>>>,>>9.99":U,1,0,"":U,"":U,"item-doc-est.preco-total[1] (Pre‡o Total)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,21,1,"item-doc-est.icm-complem[1]":U,"decimal":U,">>>>,>>>,>>9.99":U,1,0,"":U,"":U,"item-doc-est.icm-complem[1] (ICMS Complementar)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,22,1,"item-doc-est.desconto[1]":U,"decimal":U,">>>>,>>>,>>9.99":U,1,0,"":U,"":U,"item-doc-est.desconto[1]  (Desconto)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,23,1,"item-doc-est.dt-vali-lote":U,"date":U,"99/99/9999":U,1,0,"":U,"":U,"item-doc-est.dt-vali-lote (Validade Lote)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,24,1,"item-doc-est.num-pedido":U,"integer":U,">>>>>,>>9":U,1,0,"":U,"":U,"item-doc-est.num-pedido (Pedido)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,25,1,"item-doc-est.parcela":U,"integer":U,">>>>9":U,1,0,"":U,"":U,"item-doc-est.parcela (Parcela)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,26,1,"item-doc-est.qt-do-forn":U,"decimal":U,">>>>,>>>,>>9.9999":U,1,0,"":U,"":U,"item-doc-est.qt-do-forn (Qtde Emitente)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,27,1,"item-doc-est.valor-ipi[1]":U,"decimal":U,">>>>,>>>,>>9.99":U,1,0,"":U,"":U,"item-doc-est.valor-ipi[1] (Valor IPI)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,28,1,"item-doc-est.valor-icm[1]":U,"decimal":U,">>>>,>>>,>>9.99":U,1,0,"":U,"":U,"item-doc-est.valor-icm[1] (Valor ICMS)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,29,1,"item-doc-est.valor-iss[1]":U,"decimal":U,">>>>,>>>,>>9.99":U,1,0,"":U,"":U,"item-doc-est.valor-iss[1] (Valor ISS)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,30,1,"item-doc-est.cod-refer":U,"character":U,"x(8)":U,1,0,"":U,"":U,"item-doc-est.cod-refer (Referˆncia)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,31,1,"item-doc-est.vl-subs[1]":U,"decimal":U,">>>>>,>>>,>>9.99":U,1,0,"":U,"":U,"item-doc-est.vl-subs[1] (Valor Subst Trib)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,32,1,"item-doc-est.base-subs[1]":U,"decimal":U,">>>>>,>>>,>>9.99":U,1,0,"":U,"":U,"item-doc-est.base-subs[1] (Base Substitui‡Æo Tribut ria)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,33,1,"item-doc-est.hora":U,"character":U,"x(08)":U,1,0,"":U,"":U,"item-doc-est.hora (Hora)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,34,6,"item-doc-est.cod-depos":U,"CHARACTER":U,"x(3)":U,1,0,"":U,"":U,"alm - item-doc-est.cod-depos (Campo Fixo)":U,"alm":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,35,1,"item-doc-est.log-icm-retido":U,"logical":U,"Sim/NÆo":U,1,0,"":U,"":U,"item-doc-est.log-icm-retido  (ICMS Retido)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,36,1,"item-doc-est.cd-trib-iss":U,"integer":U,">9":U,1,0,"":U,"":U,"item-doc-est.cd-trib-iss  (C¢digo Tributa‡Æo ISS)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,37,1,"item-doc-est.cd-trib-ipi":U,"integer":U,">9":U,1,0,"":U,"":U,"item-doc-est.cd-trib-ipi  (C¢digo Tributa‡Æo IPI)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,38,1,"item-doc-est.cd-trib-icm":U,"integer":U,">9":U,1,0,"":U,"":U,"item-doc-est.cd-trib-icm  (C¢digo Tributa‡Æo ICMS)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).

run cria-bc-layout-registro IN h-bc0001c ("bc-layout-registro":U,i-layout,yes,1,3,OUTPUT c-segmento,3,"DU":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U,2).

run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,1,1,"dupli-apagar.parcela":U,"character":U,"x(2)":U,1,0,"":U,"":U,"dupli-apagar.parcela (Parcela)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,2,1,"dupli-apagar.dt-trans":U,"date":U,"99/99/9999":U,1,0,"":U,"":U,"dupli-apagar.dt-trans (Data Transa‡Æo)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,3,1,"dupli-apagar.dt-vencim":U,"date":U,"99/99/9999":U,1,0,"":U,"":U,"dupli-apagar.dt-vencim (Data Vencimento)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,4,1,"dupli-apagar.vl-a-pagar":U,"decimal":U,">>>>>,>>>,>>9.99":U,1,0,"":U,"":U,"dupli-apagar.vl-a-pagar (Valor Duplicata)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,5,1,"dupli-apagar.dt-venc-desc":U,"date":U,"99/99/9999":U,1,0,"":U,"":U,"dupli-apagar.dt-venc-desc (Vencimento com Desconto)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,6,1,"dupli-apagar.vl-desconto":U,"decimal":U,">>>>>,>>>,>>9.99":U,1,0,"":U,"":U,"dupli-apagar.vl-desconto (Descto)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,7,1,"dupli-apagar.nr-duplic":U,"character":U,"x(16)":U,1,0,"":U,"":U,"dupli-apagar.nr-duplic (N£mero Duplicata)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,8,6,"dupli-apagar.cod-esp":U,"CHARACTER":U,"!!":U,1,0,"":U,"":U,"DP - dupli-apagar.cod-esp (Campo Fixo)":U,"DP":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).

run cria-bc-layout-registro IN h-bc0001c ("bc-layout-registro":U,i-layout,yes,1,4,OUTPUT c-segmento,4,"DI":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U,2).

run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,1,1,"dupli-imp.parcela":U,"character":U,"x(2)":U,1,0,"":U,"":U,"dupli-imp.parcela (Parcela)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,2,1,"dupli-imp.vl-imposto":U,"DECIMAL":U,">>>,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"dupli-imp.vl-imposto (Valor Imposto)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,3,1,"dupli-imp.rend-trib":U,"decimal":U,"->>>,>>>,>>9.99":U,1,0,"":U,"":U,"dupli-imp.rend-trib  (Rend Trib)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,4,1,"dupli-imp.aliquota":U,"decimal":U,">>9.99":U,1,0,"":U,"":U,"dupli-imp.aliquota (Al¡quota)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,5,1,"dupli-imp.dt-venc-imp":U,"date":U,"99/99/9999":U,1,0,"":U,"":U,"dupli-imp.dt-venc-imp (Vencimento Imposto)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,6,1,"dupli-imp.nr-duplic":U,"character":U,"x(16)":U,1,0,"":U,"":U,"dupli-imp.nr-duplic (N£mero Duplicata)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro-item":U,c-segmento,7,6,"dupli-imp.cod-esp":U,"CHARACTER":U,"!!":U,1,0,"":U,"":U,"DP - dupli-imp.cod-esp (Campo Fixo)":U,"DP":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
