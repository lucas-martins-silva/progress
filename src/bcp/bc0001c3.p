/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0001C3 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0001C3 MBC}
&ENDIF


                            
/*******
**   programa de inicializacao do nota fiscal de saida com separador - etiqueta 2d.
**
********/

DEF INPUT PARAM h-bc0001c AS HANDLE NO-UNDO.
DEF INPUT PARAM i-layout  AS INTEGER NO-UNDO.

DEF VAR c-segmento AS INT NO-UNDO.

FIND FIRST param-bc
     NO-LOCK NO-ERROR.

run cria-bc-layout IN h-bc0001c ("bc-layout":U,i-layout,"SAIDA SEPARAD - PADRÇO DATASUL EMS 2":U,1,yes,1,"":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U,3,"|":U).

run cria-bc-layout-registro IN h-bc0001c ("bc-layout-registro":U,i-layout,yes,1,1,OUTPUT c-segmento,1,"NF":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U,1).

run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,1,1,"nota-fiscal.serie":U,"character":U,"x(5)":U,1,0,"":U,"":U,"nota-fiscal.serie  (S‚rie)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,2,1,"nota-fiscal.nr-nota-fis":U,"character":U,"x(16)":U,1,0,"":U,"":U,"nota-fiscal.nr-nota-fis  (Nr Nota Fiscal)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,3,1,"nota-fiscal.dt-emis-nota":U,"date":U,"99/99/9999":U,1,0,"":U,"":U,"nota-fiscal.dt-emis-nota  (Dt EmissÆo)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,4,6,"DATA-TRANSACAO":U,"DATE":U,"99/99/9999":U,1,0,"":U,"":U,"FCN-TODAY - DATA-TRANSACAO (Campo Fixo)":U,"FCN-TODAY":U,0,0,0,0,no,no,?,?,"":U,"DATA DA GERA€ÇO DA ETIQUETA":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,5,1,"nota-fiscal.vl-tot-nota":U,"decimal":U,">>,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"nota-fiscal.vl-tot-nota  (Vl Total Nota)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,6,1,"nota-fiscal.nat-operacao":U,"character":U,"x(06)":U,1,0,"":U,"":U,"nota-fiscal.nat-operacao  (Natureza opera‡Æo)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,7,1,"transporte.via-transp":U,"integer":U,"9":U,1,0,"":U,"":U,"transporte.via-transp  (Via Transporte)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,8,1,"estabelec.estado":U,"character":U,"!!xx":U,1,0,"":U,"":U,"estabelec.estado  (UF)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,9,1,"nota-fiscal.vl-frete":U,"decimal":U,">>,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"nota-fiscal.vl-frete  (Valor Frete)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,10,1,"nota-fiscal.vl-mercad":U,"decimal":U,">>,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"nota-fiscal.vl-mercad  (Vl Mercadoria)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,11,1,"nota-fiscal.vl-embalagem":U,"decimal":U,">>,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"nota-fiscal.vl-embalagem  (Vl Embalagem)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,12,1,"nota-fiscal.vl-seguro":U,"decimal":U,">>,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"nota-fiscal.vl-seguro  (Valor Seguro)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).

&if '{&mgcld_version}' <= '2.04' &then
    IF  param-bc.int-2 <= 1 /* ems */
&else
    IF  param-bc.ind-sistema <= 1 /* ems */
&endif

THEN DO:
   run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,13,1,"nota-fiscal.observ-nota":U,"character":U,"x(2000)":U,1,0,"":U,"":U,"nota-fiscal.observ-nota  (Observa‡Æo)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
   run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,14,1,"nota-fiscal.val-desconto-total":U,"decimal":U,">>>,>>>,>>9.99":U,1,0,"":U,"":U,"nota-fiscal.val-desconto-total  (Valor Desconto Total)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
END.
ELSE DO:
   run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,13,1,"nota-fiscal.observ-nota[1]":U,"character":U,"x(2000)":U,1,0,"":U,"":U,"nota-fiscal.observ-nota[1]  (Observa‡Æo)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
   run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,14,1,"nota-fiscal.descto1":U,"decimal":U,">>>,>>>,>>9.99":U,1,0,"":U,"":U,"nota-fiscal.descto1  (Valor Desconto 1)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
END.
   
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,15,6,"DATA-VENCIMENTO-ICM":U,"DATE":U,"99/99/9999":U,1,0,"":U,"":U,"FNC-TODAY - DATA-VENCIMENTO-ICM (Campo Fixo)":U,"FNC-TODAY":U,0,0,0,0,no,no,?,?,"":U,"DATA DE VENCIMENTO DO ICM":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,16,6,"DATA-VENCIMENTO-IPI":U,"DATE":U,"99/99/9999":U,1,0,"":U,"":U,"FNC-TODAY - DATA-VENCIMENTO-IPI (Campo Fixo)":U,"FNC-TODAY":U,0,0,0,0,no,no,?,?,"":U,"DATA DE VENCIMENTO DO IPI":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,17,1,"nota-fiscal.cidade-cif":U,"CHARACTER":U,"x(25)":U,1,0,"":U,"":U,"nota-fiscal.cidade-cif  (Cidade CIF)":U,"":U,0,0,0,0,no,no,?,?,"":U,"COBRAN€A DO FRETE ( VALOR EM BRA":U,"NCO '2' CONTRA O DESTINATµRIO -":U,"VALOR DIFERENTE DE BRANCO '1' CO":U,"NTRA O EMITENTE)":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,18,1,"nota-fiscal.peso-bru-tot":U,"decimal":U,">>>,>>>,>>9.999":U,1,0,"":U,"":U,"nota-fiscal.peso-bru-tot  (Peso Bruto Total)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,19,1,"nota-fiscal.emite-duplic":U,"logical":U,"Sim/NÆo":U,1,0,"":U,"":U,"nota-fiscal.emite-duplic  (Gera Faturamento)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,20,1,"estabelec.cgc":U,"CHARACTER":U,"x(19)":U,1,0,"":U,"":U,"estabelec.cgc  (CGC)":U,"":U,0,0,0,0,no,no,?,?,"":U,"CGC EMISSOR DA NOTA":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,21,1,"emitente.cgc":U,"CHARACTER":U,"x(19)":U,1,0,"":U,"":U,"emitente.cgc  (CGCMF)":U,"":U,0,0,0,0,no,no,?,?,"":U,"CGC RECEPTOR DA NOTA":U,"":U,"":U,"":U,"":U).

run cria-bc-layout-registro IN h-bc0001c ("bc-layout-registro":U,i-layout,yes,1,2,OUTPUT c-segmento,2,"IT":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U,2).

run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,1,1,"it-nota-fisc.aliquota-ipi":U,"decimal":U,">>9.99":U,1,0,"":U,"":U,"it-nota-fisc.aliquota-ipi  (Aliquota IPI)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,2,1,"it-nota-fisc.aliquota-ISS":U,"decimal":U,">>9.99":U,1,0,"":U,"":U,"it-nota-fisc.aliquota-ISS  (Aliquota ISS)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,3,1,"it-nota-fisc.aliquota-icm":U,"decimal":U,">>9.99":U,1,0,"":U,"":U,"it-nota-fisc.aliquota-icm  (Aliquota ICMS)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,4,1,"it-nota-fisc.class-fiscal":U,"character":U,"9999.99.99":U,1,0,"":U,"":U,"it-nota-fisc.class-fiscal  (Classifica‡Æo Fiscal)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,5,1,"it-nota-fisc.it-codigo":U,"character":U,"x(16)":U,1,0,"":U,"":U,"it-nota-fisc.it-codigo  (Item)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,6,1,"it-nota-fisc.nr-seq-fat":U,"integer":U,">>,>>9":U,1,0,"":U,"":U,"it-nota-fisc.nr-seq-fat  (Sequˆncia)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,7,1,"it-nota-fisc.peso-liq-fat":U,"decimal":U,">>>,>>>,>>9.99999":U,1,0,"":U,"":U,"it-nota-fisc.peso-liq-fat  (Peso Liquido)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,8,1,"it-nota-fisc.qt-faturada[1]":U,"DECIMAL":U,">>>>,>>9.9999":U,1,0,"":U,"":U,"it-nota-fisc.qt-faturada[1]  (Quantidade)":U,"":U,0,0,0,0,no,no,?,?,"":U,"QUANTIDADE DO CLIENTE":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,9,1,"it-nota-fisc.un-fatur[1]":U,"character":U,"xx":U,1,0,"":U,"":U,"it-nota-fisc.un-fatur[1]  (Unidade Faturada)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,10,1,"it-nota-fisc.vl-bipi-it":U,"decimal":U,">,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"it-nota-fisc.vl-bipi-it  (Base Calc IPI Item)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,11,1,"it-nota-fisc.vl-bicms-it":U,"decimal":U,">,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"it-nota-fisc.vl-bicms-it  (Base Calc ICMS Item)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,12,1,"it-nota-fisc.vl-biss-it":U,"decimal":U,">,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"it-nota-fisc.vl-biss-it  (Base Calc ISS Item)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,13,1,"it-nota-fisc.vl-despes-it":U,"decimal":U,">,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"it-nota-fisc.vl-despes-it  (Valor Despesas Item)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,14,1,"it-nota-fisc.vl-ipint-it":U,"decimal":U,">,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"it-nota-fisc.vl-ipint-it  (Vl IPI NÆo Tributado)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,15,1,"it-nota-fisc.vl-icmsnt-it":U,"decimal":U,">,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"it-nota-fisc.vl-icmsnt-it  (Vl ICMS NÆo Trib)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,16,1,"it-nota-fisc.vl-issnt-it":U,"decimal":U,">,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"it-nota-fisc.vl-issnt-it  (Vl ISS Nƒo Tributado)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,17,1,"it-nota-fisc.vl-ipiou-it":U,"decimal":U,">,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"it-nota-fisc.vl-ipiou-it  (Vl IPI Outras)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,18,1,"it-nota-fisc.vl-icmsou-it":U,"decimal":U,">,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"it-nota-fisc.vl-icmsou-it  (Vl ICMS Outras)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,19,1,"it-nota-fisc.vl-issou-it":U,"decimal":U,">,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"it-nota-fisc.vl-issou-it  (Vl ISS Outras)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,20,1,"it-nota-fisc.vl-tot-item":U,"decimal":U,">,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"it-nota-fisc.vl-tot-item  (Vl Total Item)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,21,1,"it-nota-fisc.vl-icmscomp-it":U,"decimal":U,">,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"it-nota-fisc.vl-icmscomp-it  (ICMS Complementar)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).

&if '{&mgcld_version}' <= '2.04' &then
    IF  param-bc.int-2 <= 1 /* ems */
&else
    IF  param-bc.ind-sistema <= 1 /* ems */
&endif

THEN DO:
    run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,22,1,"it-nota-fisc.val-desconto-total":U,"decimal":U,">>>,>>>,>>9.99":U,1,0,"":U,"":U,"it-nota-fisc.val-desconto-total  (Valor Desconto Total)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
    run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,23,1,"fat-ser-lote.dt-vali-lote":U,"date":U,"99/99/9999":U,1,0,"":U,"":U,"fat-ser-lote.dt-vali-lote  (Dt Valid Lote)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
END.
ELSE DO: /* campo nao existe no magnus */
    run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,22,5,"VALOR-DESCONTO-ITEM":U,"decimal":U,">>>,>>>,>>9.99":U,1,0,"":U,"":U,"VALOR-DESCONTO-ITEM  (Auxiliar)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
    run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,23,5,"DATA-VALIDADE-LOTE":U,"date":U,"99/99/9999":U,1,0,"":U,"":U,"DATA-VALIDADE-LOTE  (Auxiliar)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
END.

run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,24,1,"it-nota-fisc.nr-pedcli":U,"character":U,"x(12)":U,1,0,"":U,"":U,"it-nota-fisc.nr-pedcli  (Pedido Cliente)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,25,1,"it-nota-fisc.parcela":U,"integer":U,">9":U,1,0,"":U,"":U,"it-nota-fisc.parcela  (Parcela)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,26,1,"it-nota-fisc.qt-faturada[1]":U,"DECIMAL":U,">>>>,>>9.9999":U,1,0,"":U,"":U,"it-nota-fisc.qt-faturada[1]  (Quantidade)":U,"":U,0,0,0,0,no,no,?,?,"":U,"MINHA QUANTIDADE":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,27,1,"it-nota-fisc.vl-ipi-it":U,"decimal":U,">,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"it-nota-fisc.vl-ipi-it  (Valor IPI Item)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,28,1,"it-nota-fisc.vl-icms-it":U,"decimal":U,">,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"it-nota-fisc.vl-icms-it  (Valor ICMS Item)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,29,1,"it-nota-fisc.vl-iss-it":U,"decimal":U,">,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"it-nota-fisc.vl-iss-it  (Valor ISS Item)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,30,1,"it-nota-fisc.cod-refer":U,"character":U,"x(8)":U,1,0,"":U,"":U,"it-nota-fisc.cod-refer  (Referˆncia)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,31,1,"it-nota-fisc.vl-icmsub-it":U,"decimal":U,">,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"it-nota-fisc.vl-icmsub-it  (Valor ICMS Item Subs)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,32,1,"it-nota-fisc.vl-bsubs-it":U,"decimal":U,">,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"it-nota-fisc.vl-bsubs-it  (Base ICMS Item Subs)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,33,6,"HORA":U,"CHARACTER":U,"HH:MM:SS":U,1,0,"":U,"":U,"FNC-TIME - HORA (Campo Fixo)":U,"FNC-TIME":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,34,1,"it-nota-fisc.ind-icm-ret":U,"LOGICAL":U,"1/0":U,1,0,"":U,"":U,"it-nota-fisc.ind-icm-ret  (Ret‚m ICMS Fonte)":U,"":U,0,0,0,0,no,no,?,?,"":U,"Valor 1 igual  a SIM e Valor 0 i":U,"gual a NÇO":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,35,1,"it-nota-fisc.cd-trib-iss":U,"integer":U,"99":U,1,0,"":U,"":U,"it-nota-fisc.cd-trib-iss  (Tributa‡Æo ISS)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,36,1,"it-nota-fisc.cd-trib-ipi":U,"integer":U,"99":U,1,0,"":U,"":U,"it-nota-fisc.cd-trib-ipi  (Tributa‡Æo IPI)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,37,1,"it-nota-fisc.cd-trib-icm":U,"integer":U,"99":U,1,0,"":U,"":U,"it-nota-fisc.cd-trib-icm  (Tributa‡Æo ICMS)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).

run cria-bc-layout-registro IN h-bc0001c ("bc-layout-registro":U,i-layout,yes,1,3,OUTPUT c-segmento,3,"DU":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U,2).

run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,1,1,"fat-duplic.parcela":U,"character":U,">9":U,1,0,"":U,"":U,"fat-duplic.parcela  (Parcela)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,2,6,"DATA-TRANSACAO":U,"DATE":U,"99/99/9999":U,1,0,"":U,"":U,"FNC-TODAY - DATA-TRANSACAO (Campo Fixo)":U,"FNC-TODAY":U,0,0,0,0,no,no,?,?,"":U,"DATA DA TRANSA€ÇO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,3,1,"fat-duplic.dt-venciment":U,"date":U,"99/99/9999":U,1,0,"":U,"":U,"fat-duplic.dt-venciment  (Data de Vencimento)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,4,1,"fat-duplic.vl-parcela":U,"decimal":U,">>,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"fat-duplic.vl-parcela  (Valor Liquido)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,5,1,"fat-duplic.dt-desconto":U,"date":U,"99/99/9999":U,1,0,"":U,"":U,"fat-duplic.dt-desconto  (Dt Desconto)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,6,1,"fat-duplic.vl-desconto":U,"decimal":U,">>,>>>,>>>,>>9.99":U,1,0,"":U,"":U,"fat-duplic.vl-desconto  (Valor Desconto)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,7,1,"fat-duplic.nr-fatura":U,"character":U,"x(16)":U,1,0,"":U,"":U,"fat-duplic.nr-fatura  (Nr Fatura)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).


