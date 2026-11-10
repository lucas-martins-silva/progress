/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0001C2 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0001C2 MBC}
&ENDIF


                            
/*******
**   programa de inicializacao do nota fiscal de saida com AIM BRASIL - etiqueta 2d.
**
********/

DEF INPUT PARAM h-bc0001c AS HANDLE NO-UNDO.
DEF INPUT PARAM i-layout  AS INT    NO-UNDO.

DEF VAR c-segmento AS INT NO-UNDO.

run cria-bc-layout IN h-bc0001c ("bc-layout":U,i-layout,"SAIDA AIM - PADR«O DATASUL EMS 2":U,1,yes,1,"":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U,5,"":U).

run cria-bc-layout-registro IN h-bc0001c ("bc-layout-registro":U,i-layout,yes,1,1,OUTPUT c-segmento,1,"IT11":U,"FT":U,0,0,0,0,no,no,?,?,"":U,"NOTA FISCAL":U,"":U,"":U,"":U,"":U,1).

run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,1,1,"nota-fiscal.nr-nota-fis":U,"CHARACTER":U,"x(16)":U,1,0,"NF":U,"":U,"NF - nota-fiscal.nr-nota-fis (Nr Nota Fiscal)":U,"":U,0,0,0,0,no,no,?,?,"":U,"NUMERO DA NOTA - FORNECEDOR":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,2,1,"estabelec.cgc":U,"CHARACTER":U,"x(19)":U,1,0,"CE":U,"":U,"CE - estabelec.cgc (CGC)":U,"":U,0,0,0,0,no,no,?,?,"":U,"CGC - FORNECEDOR":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,3,1,"estabelec.nome":U,"CHARACTER":U,"X(40)":U,1,0,"RE":U,"":U,"RE - estabelec.nome (Nome)":U,"":U,0,0,0,0,no,no,?,?,"":U,"RAZ«O SOCIAL - FORNECEDOR":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,4,1,"estabelec.endereco":U,"CHARACTER":U,"X(35)":U,1,0,"EE":U,"":U,"EE - estabelec.endereco (Endereáo)":U,"":U,0,0,0,0,no,no,?,?,"":U,"ENDEREÄO - FORNECEDOR":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,5,1,"estabelec.cidade":U,"CHARACTER":U,"x(25)":U,1,0,"ME":U,"":U,"ME - estabelec.cidade (Cidade)":U,"":U,0,0,0,0,no,no,?,?,"":U,"MUNIC÷PIO - FORNECEDOR":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,6,1,"estabelec.estado":U,"CHARACTER":U,"!!xx":U,1,0,"UE":U,"":U,"UE - estabelec.estado (UF)":U,"":U,0,0,0,0,no,no,?,?,"":U,"ESTADO- FORNECEDOR":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,7,2,"FE047-9999999":U,"":U,"":U,0,0,"":U,"":U,"FE047-4417102 (Constante)":U,"":U,0,0,0,0,no,no,?,?,"":U,"FONE - FORNECEDOR":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,8,2,"XE047-9999999":U,"":U,"":U,0,0,"":U,"":U,"XE047-4417150 (Constante)":U,"":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,9,1,"estabelec.cep":U,"INTEGER":U,"99999999":U,1,0,"PE":U,"":U,"PE - estabelec.cep (CEP)":U,"":U,0,0,0,0,no,no,?,?,"":U,"CEP - FORNECEDOR":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,10,2,"CF":U,"":U,"":U,0,0,"":U,"":U,"CF (Constante)":U,"":U,0,0,0,0,no,no,?,?,"":U,"CFOB - DESTINATµRIO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,11,1,"emitente.cgc":U,"CHARACTER":U,"x(19)":U,1,0,"CD":U,"":U,"CD - emitente.cgc (CGCMF)":U,"":U,0,0,0,0,no,no,?,?,"":U,"CGC - DESTINATµRIO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,12,1,"emitente.insc-subs-trib":U,"CHARACTER":U,"x(19)":U,1,0,"FD":U,"":U,"FD - emitente.insc-subs-trib (Inscr Aux Subst Tribut†ria)":U,"":U,0,0,0,0,no,no,?,?,"":U,"INSCRIÄ«O ESTADUAL DO SUBSTITUTO":U,"TRIBUTµRIO - DESTINATµRIO":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,13,1,"nota-fiscal.nat-operacao":U,"CHARACTER":U,"x(06)":U,1,0,"NO":U,"":U,"NO - nota-fiscal.nat-operacao (Natureza operaá∆o)":U,"":U,0,0,0,0,no,no,?,?,"":U,"NATUREAZA DE OPERAÄ«O - DESTINAT":U,"µRIO":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,14,1,"emitente.ins-estadual":U,"CHARACTER":U,"X(19)":U,1,0,"ID":U,"":U,"ID - emitente.ins-estadual (Inscriá∆o Estadual)":U,"":U,0,0,0,0,no,no,?,?,"":U,"INCRIÄ«O ESTADUAL - DESTINATµRIO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,15,1,"emitente.nome-emit":U,"CHARACTER":U,"X(40)":U,1,0,"ND":U,"":U,"ND - emitente.nome-emit (Nome)":U,"":U,0,0,0,0,no,no,?,?,"":U,"RAZ«O SOCIAL - DESTINATµRIO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,16,1,"nota-fiscal.endereco":U,"CHARACTER":U,"X(40)":U,1,0,"ED":U,"":U,"ED - nota-fiscal.endereco (Endereáo)":U,"":U,0,0,0,0,no,no,?,?,"":U,"ENDEREÄO - DESTINATµRIO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,17,1,"nota-fiscal.cidade":U,"CHARACTER":U,"x(25)":U,1,0,"MD":U,"":U,"MD - nota-fiscal.cidade (Cidade)":U,"":U,0,0,0,0,no,no,?,?,"":U,"MUNIC÷PIO - DESTINATµRIO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,18,1,"nota-fiscal.estado":U,"CHARACTER":U,"x(04)":U,1,0,"UD":U,"":U,"UD - nota-fiscal.estado (UF)":U,"":U,0,0,0,0,no,no,?,?,"":U,"ESTADO - DESTINATµRIO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,19,1,"emitente.telefone[1]":U,"CHARACTER":U,"x(15)":U,1,0,"FD":U,"":U,"FD - emitente.telefone[1] (Telefone)":U,"":U,0,0,0,0,no,no,?,?,"":U,"FONE - DESTINATµRIO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,20,1,"emitente.telefax":U,"CHARACTER":U,"x(15)":U,1,0,"XD":U,"":U,"XD - emitente.telefax (Telefax)":U,"":U,0,0,0,0,no,no,?,?,"":U,"FAX - DESTINATµRIO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,21,1,"nota-fiscal.cep":U,"CHARACTER":U,"x(12)":U,1,0,"PD":U,"":U,"PD - nota-fiscal.cep (CEP)":U,"":U,0,0,0,0,no,no,?,?,"":U,"CEP - DESTINATµRIO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,22,1,"nota-fiscal.nr-pedcli":U,"CHARACTER":U,"x(12)":U,1,0,"NP":U,"":U,"NP - nota-fiscal.nr-pedcli (Pedido Cliente)":U,"":U,0,0,0,0,no,no,?,?,"":U,"NÈMERO DO PEDIDO - DIVERSOS":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,23,1,"nota-fiscal.dt-emis-nota":U,"DATE":U,"AAMMDD":U,1,0,"DE":U,"":U,"DE - nota-fiscal.dt-emis-nota (Dt Emiss∆o)":U,"":U,0,0,0,0,no,no,?,?,"":U,"DATA DE EMISS«O DA NOTA - DIVERS":U,"OS":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,24,1,"nota-fiscal.dt-saida":U,"DATE":U,"MMDDAAAA":U,1,0,"DS":U,"":U,"DS - nota-fiscal.dt-saida (Dt Sa°da Merc)":U,"":U,0,0,0,0,no,no,?,?,"":U,"DATA DA SA÷DA DA NOTA - DIVERSOS":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,25,1,"nota-fiscal.cod-cond-pag":U,"INTEGER":U,">>9":U,1,0,"CG":U,"":U,"CG - nota-fiscal.cod-cond-pag (Cond Pagto)":U,"":U,0,0,0,0,no,no,?,?,"":U,"CONDIÄ«O DE PAGAMENTO - DIVERSOS":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,26,2,"BI0":U,"":U,"":U,0,0,"":U,"":U,"BI0 (Constante)":U,"":U,0,0,0,0,no,no,?,?,"":U,"VALOR BASE ICMS - DADOS IMPOSTOS":U,"(ESTE VALOR DEVE SER OBTIDO ATR":U,"AV?S DOS ITENS)":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,27,2,"UI0":U,"":U,"":U,0,0,"":U,"":U,"UI0 (Constante)":U,"":U,0,0,0,0,no,no,?,?,"":U,"VALOR ICMS - DADOS IMPOSTOS (OBT":U,"ER ESTE VALOR PELO ITENS)":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,28,2,"VP0":U,"":U,"":U,0,0,"":U,"":U,"VP0 (Constante)":U,"":U,0,0,0,0,no,no,?,?,"":U,"VALOR IPI - DADOS IMPOSTOS (OBTE":U,"R ESTE VALOR ATRAV?S DOS ITENS)":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,29,1,"nota-fiscal.vl-mercad":U,"DECIMAL":U,"9999999999.99":U,1,0,"VT":U,"":U,"VT - nota-fiscal.vl-mercad (Vl Mercadoria)":U,"":U,0,0,0,0,no,no,?,?,"":U,"VALOR TOTAL DOS PRODUTOS - DADOS":U,"IMPOSTOS":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,30,1,"nota-fiscal.vl-tot-nota":U,"DECIMAL":U,"9999999999.99":U,1,0,"VN":U,"":U,"VN - nota-fiscal.vl-tot-nota (Vl Total Nota)":U,"":U,0,0,0,0,no,no,?,?,"":U,"VALOR TOTAL DA NOTA - DADOS IMPO":U,"STOS":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,31,1,"nota-fiscal.vl-frete":U,"DECIMAL":U,"999999999999.99":U,1,0,"VF":U,"":U,"VF - nota-fiscal.vl-frete (Valor Frete)":U,"":U,0,0,0,0,no,no,?,?,"":U,"VALOR DO FRETE - DADOS IMPOSTOS":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,32,1,"nota-fiscal.vl-seguro":U,"DECIMAL":U,"9999999999.99":U,1,0,"VG":U,"":U,"VG - nota-fiscal.vl-seguro (Valor Seguro)":U,"":U,0,0,0,0,no,no,?,?,"":U,"VALOR SEGURO - DADOS IMPOSTOS":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,33,2,"BC0":U,"":U,"":U,0,0,"":U,"":U,"BC0 (Constante)":U,"":U,0,0,0,0,no,no,?,?,"":U,"BASE DE CALCULO ICMS SUBSTITUTO":U,"- DADOS IMPOSTOS (OBTER VALOR AT":U,"RAV?S DO ITENS)":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,34,2,"OD0":U,"":U,"":U,0,0,"":U,"":U,"OD0 (Constante)":U,"":U,0,0,0,0,no,no,?,?,"":U,"OUTRAS DESPESAS - DADOS IMPOSTOS":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,35,2,"MS0":U,"":U,"":U,0,0,"":U,"":U,"MS0 (Constante)":U,"":U,0,0,0,0,no,no,?,?,"":U,"VALOR ICMS SUBSTITUTO - DADOS IM":U,"POSTO (OBTER ESTE VALOR ATRAV?S":U,"DOS ITENS)":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,36,1,"transporte.nome":U,"CHARACTER":U,"X(40)":U,1,0,"RT":U,"":U,"RT - transporte.nome (Nome)":U,"":U,0,0,0,0,no,no,?,?,"":U,"RAZ«O SOCIAL - TRANSPORTADORA":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,37,1,"nota-fiscal.cidade-cif":U,"CHARACTER":U,"X(25)":U,1,0,"PF":U,"":U,"PF - nota-fiscal.cidade-cif (Cidade CIF)":U,"":U,0,0,0,0,no,no,?,?,"":U,"PAGAMENTO DO FRETE - TRANSPORTAD":U,"ORA (CASO SEJA DIFERENTE DE BRAN":U,"CO VALOR IGUAL 2  CASO CONTRARIO":U,"SERµ IGUAL A 1)":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,38,1,"nota-fiscal.placa":U,"CHARACTER":U,"x(10)":U,1,0,"PV":U,"":U,"PV - nota-fiscal.placa (Placa)":U,"":U,0,0,0,0,no,no,?,?,"":U,"PLACA DO VE÷CULO - TRANSPORTADOR":U,"A":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,39,1,"transporte.cgc":U,"CHARACTER":U,"x(19)":U,1,0,"CT":U,"":U,"CT - transporte.cgc (CGC)":U,"":U,0,0,0,0,no,no,?,?,"":U,"CGC - TRANSPORTADORA":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,40,1,"nota-fiscal.nr-volumes":U,"CHARACTER":U,"x(10)":U,1,0,"QE":U,"":U,"QE - nota-fiscal.nr-volumes (Nr Volumes)":U,"":U,0,0,0,0,no,no,?,?,"":U,"QUANTIDADE DE VOLUMES - TRANSPOR":U,"TADORA":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,41,1,"nota-fiscal.peso-bru-tot":U,"DECIMAL":U,"99999999999.999":U,1,0,"PB":U,"":U,"PB - nota-fiscal.peso-bru-tot (Peso Bruto Total)":U,"":U,0,0,0,0,no,no,?,?,"":U,"PESO BRUTO  - TRANSPORTADORA":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,42,1,"nota-fiscal.peso-liq-tot":U,"DECIMAL":U,"999999999.999":U,1,0,"PL":U,"":U,"PL - nota-fiscal.peso-liq-tot (Peso L°quido Total)":U,"":U,0,0,0,0,no,no,?,?,"":U,"PESO L÷QUIDO - TRANSPORTADORA":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,43,6,"campo-hora":U,"CHARACTER":U,"SS**hh--mm":U,1,0,"":U,"":U,"fnc-time - campo-hora (Campo Fixo)":U,"fnc-time":U,0,0,0,0,no,no,?,?,"":U,"":U,"":U,"":U,"":U,"":U).

run cria-bc-layout-registro IN h-bc0001c ("bc-layout-registro":U,i-layout,yes,1,2,OUTPUT c-segmento,3,"LF":U,"FF":U,0,0,0,0,no,no,?,?,"":U,"DUPLICATAS DA NOTA FISCAL":U,"":U,"":U,"":U,"":U,2).

run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,1,1,"fat-duplic.nr-fatura":U,"CHARACTER":U,"x(16)":U,1,0,"NT":U,"":U,"NT - fat-duplic.nr-fatura (Nr Fatura)":U,"":U,0,0,0,0,no,no,?,?,"":U,"NÈMERO DA FATURA - FATURA":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,2,1,"fat-duplic.vl-parcela":U,"DECIMAL":U,">>>>>>>>>>9.99":U,1,0,"VL":U,"":U,"VL - fat-duplic.vl-parcela (Valor Liquido)":U,"":U,0,0,0,0,no,no,?,?,"":U,"VALOR DA FATURA - FATURA":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,3,1,"fat-duplic.dt-venciment":U,"DATE":U,"DDMMAAAA":U,1,0,"VC":U,"":U,"VC - fat-duplic.dt-venciment (Data de Vencimento)":U,"":U,0,0,0,0,no,no,?,?,"":U,"DATA DE VENCIMENTO - FATURA":U,"":U,"":U,"":U,"":U).

run cria-bc-layout-registro IN h-bc0001c ("bc-layout-registro":U,i-layout,yes,1,3,OUTPUT c-segmento,2,"LP":U,"FP":U,0,0,0,0,no,no,?,?,"":U,"ITENS DA NOTA FISCAL":U,"":U,"":U,"":U,"":U,2).

run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,1,1,"it-nota-fisc.it-codigo":U,"CHARACTER":U,"x(16)":U,1,0,"CP":U,"":U,"CP - it-nota-fisc.it-codigo (Item)":U,"":U,0,0,0,0,no,no,?,?,"":U,"C‡DIGO DO PRODUTO - PRODUTO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,2,1,"it-nota-fisc.class-fiscal":U,"CHARACTER":U,"9999.99.99":U,1,0,"CS":U,"":U,"CS - it-nota-fisc.class-fiscal (Classificaá∆o Fiscal)":U,"":U,0,0,0,0,no,no,?,?,"":U,"CLASSIFICAÄ«O FISCAL- PRODUTO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,3,1,"it-nota-fisc.un-fatur[1]":U,"CHARACTER":U,"xx":U,1,0,"UN":U,"":U,"UN - it-nota-fisc.un-fatur[1] (Unidade Faturada)":U,"":U,0,0,0,0,no,no,?,?,"":U,"UNIDADE DE MEDIDA - PRODUTO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,4,1,"it-nota-fisc.qt-faturada[1]":U,"DECIMAL":U,"9999999.9999":U,1,0,"QT":U,"":U,"QT - it-nota-fisc.qt-faturada[1] (Quantidade)":U,"":U,0,0,0,0,no,no,?,?,"":U,"QUANTIDADE - PRODUTO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,5,1,"it-nota-fisc.vl-preuni":U,"DECIMAL":U,"999999999.99999":U,1,0,"VU":U,"":U,"VU - it-nota-fisc.vl-preuni (Preáo Liquido)":U,"":U,0,0,0,0,no,no,?,?,"":U,"VALOR UNITµRIO - PRODUTO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,6,1,"it-nota-fisc.aliquota-icm":U,"DECIMAL":U,">>9.99":U,1,0,"IC":U,"":U,"IC - it-nota-fisc.aliquota-icm (Aliquota ICMS)":U,"":U,0,0,0,0,no,no,?,?,"":U,"ALIQUOTA ICM - PRODUTO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,7,1,"it-nota-fisc.aliquota-ipi":U,"DECIMAL":U,">>9.99":U,1,0,"IP":U,"":U,"IP - it-nota-fisc.aliquota-ipi (Aliquota IPI)":U,"":U,0,0,0,0,no,no,?,?,"":U,"ALIQUOTA DE IPI - PRODUTO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,8,1,"item.descricao-1":U,"CHARACTER":U,"x(18)":U,1,0,"DR":U,"":U,"DR - item.descricao-1 (Descriá∆o)":U,"":U,0,0,0,0,no,no,?,?,"":U,"DESCRIÄ«O - PRODUTO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,9,2,"ST0":U,"":U,"":U,0,0,"":U,"":U,"ST0 (Constante)":U,"":U,0,0,0,0,no,no,?,?,"":U,"C‡DIGO DE SITUAÄ«O TRIBUTµRIA -":U,"PRODUTO":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,10,1,"it-nota-fisc.vl-tot-item":U,"DECIMAL":U,"9999999999.99":U,1,0,"VR":U,"":U,"VR - it-nota-fisc.vl-tot-item (Vl Total Item)":U,"":U,0,0,0,0,no,no,?,?,"":U,"VALOR TOTAL - PRODUTO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,11,1,"it-nota-fisc.vl-ipi-it":U,"DECIMAL":U,"9999999999.99":U,1,0,"VA":U,"":U,"VA - it-nota-fisc.vl-ipi-it (Valor IPI Item)":U,"":U,0,0,0,0,no,no,?,?,"":U,"VALOR IPI - PRODUTO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,12,1,"nar-it-nota.narrativa":U,"CHARACTER":U,"x(2000)":U,1,0,"DP":U,"":U,"DP - nar-it-nota.narrativa (Narrativa)":U,"":U,0,0,0,0,no,no,?,?,"":U,"DESCRIÄ«O DOS SERVIÄOS - PRODUTO":U,"SERVIÄO":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,13,1,"it-nota-fisc.aliquota-ISS":U,"DECIMAL":U,">>9.99":U,1,0,"IS":U,"":U,"IS - it-nota-fisc.aliquota-ISS (Aliquota ISS)":U,"":U,0,0,0,0,no,no,?,?,"":U,"ALIQUOTA ISS - PRODUTO SERVIÄO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,14,1,"it-nota-fisc.vl-preuni":U,"DECIMAL":U,"9999999999.99999":U,1,0,"VS":U,"":U,"VS - it-nota-fisc.vl-preuni (Preáo Liquido)":U,"":U,0,0,0,0,no,no,?,?,"":U,"VALOR DE SERVIÄO - PRODUTO SERVI":U,"ÄO":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,15,2,"SP0":U,"":U,"":U,0,0,"":U,"":U,"SP0 (Constante)":U,"":U,0,0,0,0,no,no,?,?,"":U,"C‡DIGO DO SERVIÄO - PRODUTO SERV":U,"IÄO":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,16,1,"emitente.ins-municipal":U,"CHARACTER":U,"X(19)":U,1,0,"IM":U,"":U,"IM - emitente.ins-municipal (Inscriá∆o Municipal)":U,"":U,0,0,0,0,no,no,?,?,"":U,"INSCRIÄ«O MUNICIPAL - PRODUTO SE":U,"RVIÄO":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,17,1,"it-nota-fisc.vl-iss-it":U,"DECIMAL":U,"9999999999.99":U,1,0,"LI":U,"":U,"LI - it-nota-fisc.vl-iss-it (Valor ISS Item)":U,"":U,0,0,0,0,no,no,?,?,"":U,"VALOR ISS - PRODUTO SERVIÄO":U,"":U,"":U,"":U,"":U).
run cria-bc-layout-registro-item IN h-bc0001c ("bc-layout-registro":U,c-segmento,18,1,"it-nota-fisc.vl-tot-item":U,"DECIMAL":U,"9999999999.99":U,1,0,"TS":U,"":U,"TS - it-nota-fisc.vl-tot-item (Vl Total Item)":U,"":U,0,0,0,0,no,no,?,?,"":U,"VALOR TOTAL DOS SERVIÄOS - PRODU":U,"TO SERVIÄO":U,"":U,"":U,"":U).


