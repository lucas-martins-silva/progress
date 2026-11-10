/********************************************************************************************
**   Include...: bc9004.i                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - Set/2000 - Luciano Leonhardt                                **
**                                                                                         **
**   Objetivo..: Armazenar os dados para transacao de Requisicao de Materiais              **
**                                                                                         **
********************************************************************************************/

Define {1} Temp-Table tt-requis-mat-bc NO-UNDO
    Field sequen-nf                 As Integer      Format '>>9':U                                      Label 'SeqNf'
    Field cod-depos                 As Character    Format 'x(03)':U                                    Label 'Deposito'
    Field cod-emitente              As Integer      Format '>>>>>>>>9':U                                Label 'Emitente'
    Field cod-estabel               LIKE estabelec.cod-estabel                                          Label 'Estab'
    Field cod-refer                 As Character    Format 'x(08)':U                                    Label 'Referencia'
    Field ct-codigo                 As Character    Format 'x(20)':U                                    Label 'Conta'
    Field descricao-db              As Character    Format 'x(2000)':U                                  Label 'Descricao DB'
    Field dt-nf-saida               As Date         Format '99/99/9999':U                               Label 'DtSaidaNF'
    Field esp-docto                 As Integer      Format '>9':U                                       Label 'EspDocto'
    Field it-codigo                 As Character    Format 'x(16)':U                                    Label 'Item'
    Field cod-localiz               As Character    Format 'x(20)':U                                    Label 'Localiz'
    Field lote                      As Character    Format 'x(40)':U                                    Label 'Lote'
    Field nat-operacao              As Character    Format '9.99-xxx':U                                 Label 'NatOper'
    Field nro-docto                 As Character    Format 'x(16)':U                                    Label 'NroDocto'
    Field num-sequen                As Integer      Format '>>>>>9':U                                   Label 'NumSequen'
    Field numero-ordem              As Integer      Format '>>>>>9,99':U                                Label 'NumOrdem'
    Field nr-ord-produ              As Integer      Format '>>>>>>>>9':U                                Label 'OrdemProd'
    Field peso-liquido              As Decimal      Format '>>>>>>9.9999':U     Decimals 4              Label 'PesoLiq'
    Field quantidade                As Decimal      Format '>>>>>>9.9999':U     Decimals 4              Label 'Quantidade'
    Field referencia                As Character    Format 'x(10)':U                                    Label 'Referencia'
    Field sc-codigo                 As Character    Format 'x(20)':U                                    Label 'Centro de Custo'
    Field serie-docto               As Character    Format 'x(05)':U                                    Label 'SerieDocto'
    Field tipo-preco                As Integer      Format '>9':U                           Extent 3    Label 'TpPreco'
    Field tipo-trans                As Integer      Format '>9':U                                       Label 'TpTrans'
    Field tipo-valor                As Integer      Format '9':U                                        Label 'TpValor'
    Field un                        As Character    Format 'x(02)':U                                    Label 'Un'
    Field valor-mat-m               As Decimal      Format '>>>>>>>>>9.9999':U  Decimals 4  Extent 3    Label 'VlrMat-M':U
    Field valor-mat-o               As Decimal      Format '>>>>>>>>>9.9999':U  Decimals 4  Extent 3    Label 'VlrMat-O':U
    Field valor-mat-p               As Decimal      Format '>>>>>>>>>9.9999':U  Decimals 4  Extent 3    Label 'VlrMat-P':U
    Field valor-mob-m               As Decimal      Format '>>>>>>>>>9.9999':U  Decimals 4  Extent 3    Label 'VlrMob-M'
    Field valor-mob-o               As Decimal      Format '>>>>>>>>>9.9999':U  Decimals 4  Extent 3    Label 'VlrMob-O'
    Field valor-mob-p               As Decimal      Format '>>>>>>>>>9.9999':U  Decimals 4  Extent 3    Label 'VlrMob-P'
    Field valor-ggf-m               As Decimal      Format '>>>>>>>>>9.9999':U  Decimals 4  Extent 3    Label 'VlrGgf-M'
    Field valor-ggf-o               As Decimal      Format '>>>>>>>>>9.9999':U  Decimals 4  Extent 3    Label 'VlrGgf-O'
    Field valor-ggf-p               As Decimal      Format '>>>>>>>>>9.9999':U  Decimals 4  Extent 3    Label 'VlrGgf-P'
    Field valor-nota                As Decimal      Format '>>>>>>>>>9.9999':U  Decimals 4              Label 'VlrNota'
    Field vl-nota-fasb              As Decimal      Format '>>>>>>>>>9.9999':U  Decimals 4  Extent 2    Label 'VlrNotaFasb'
    Field nr-ord-refer              As Integer      Format '>>>>>>>>9':U                                Label 'NrOrdRefer'
    Field nr-req-sum                As Integer      Format '>>>>>>>>9':U                                Label 'NrReqSum'
    Field cod-roteiro               As Character    Format 'x(16)':U                                    Label 'Roteiro'
    Field nr-reporte                As Integer      Format '>>>>>>>9':U                                 Label 'NrReporte'
    Field item-pai                  As Character    Format 'x(16)':U                                    Label 'ItemPai'
    Field op-codigo                 As Integer      Format '>>>9':U                                     Label 'Opera‡Æo'
    Field ct-db                     As Character    Format 'x(20)':U                                    Label 'Conta Db'
    Field sc-db                     As Character    Format 'x(20)':U                                    Label 'Centro Custo Db'
    Field dt-vali-lote              As Date         Format '99/99/9999':U                               Label 'DatValiLote'
    Field op-seq                    As Integer      Format '>>>9':U                                     Label 'SeqOper'
    Field nr-trans                  As Integer      Format '>>>>>>>9':U                                 Label 'NrTrans'
    Field cod-estabel-des           As Character    Format 'x(03)':U                                    Label 'EstabDes'
    Field origem-valor              As Character    Format 'x(02)':U                                    Label 'ValorOrigem'
    Field num-ord-des               As Integer      Format '>>>>>>>>9':U                                Label 'NumOrdemDes'
    Field num-seq-des               As Integer      Format '>>>>>9':U                                   Label 'NumSeqDes'
    Field num-ord-inv               As Integer      Format '>>>>>9':U                                   Label 'NumOrdInv'
    Field valor-ipi                 As Decimal      Format '>>>>>>>>>9.9999':U  Decimals 4              Label 'ValorIPI'
    Field valor-iss                 As Decimal      Format '>>>>>>9.9999':U     Decimals 4              Label 'ValorISS'
    Field valor-icm                 As Decimal      Format '>>>>>>9.9999':U     Decimals 4              Label 'ValorICM'
    Field vl-icm-fasb               As Decimal      Format '>>>>>>>>>9.9999':U  Decimals 4  Extent 2    Label 'VlIcmFasb'
    Field vl-iss-fasb               As Decimal      Format '>>>>>>9.9999':U     Decimals 4  Extent 2    Label 'VlIssFasb'
    Field vl-ipi-fasb               As Decimal      Format '>>>>>>9.9999':U     Decimals 4  Extent 2    Label 'VlIpiFasb'
    Field atualiza-ul-ent           As Logical      Format 'Sim/NÆo'            Initial No              Label 'AtualUltEnt'
    Field i-sequen                  As Integer      Format '>>>>>>>9':U                                 Label 'Sequen'
    Field procura-saldos            As Logical      Format 'Sim/NÆo'            Initial No              Label 'ProcuraSaldo'
    Field qt-alocada                As Decimal      Format '>>>>>>9.9999':U     Decimals 4              Label 'QtAlocada'
    Field data-transacao            As Date         Format '99/99/9999':U                               Label 'Data Trans'
    Field cod-unico                 As Character    Format 'x(16)':U                                    Label 'Codig Unico'
    Field cod-usuario               As Character    Format 'x(12)':U                                    Label 'Usuario'
    Field cod-usu-ult-alter         As Character    Format 'x(12)':U                                    Label 'Usuaio'
    Field cod-versao-integracao     As Integer      Format '999'
    Field cod-prog-orig             As Character    Format 'x(10)'
    Field l-mov-erro                As Logical      Format 'Sim/NÆo'
    Field r-mov-inv                 As Rowid
    Field r-mov-orig                As Rowid
    Field cod-livre-1               As Character    Format 'x(40)':U                                    Label 'Cod Livre 1'
    Field cod-livre-2               As Character    Format 'x(40)':U                                    Label 'Cod Livre 2'
    Field cod-livre-3               As Character    Format 'x(40)':U                                    Label 'Cod Livre 3'
    Field cod-livre-4               As Character    Format 'x(40)':U                                    Label 'Cod Livre 4'
    Field cod-livre-5               As Character    Format 'x(40)':U                                    Label 'Cod Livre 5'
    Field num-livre-1               As Integer      Format '>>>>>>>9':U                                 Label 'Num Livre 1'
    Field num-livre-2               As Integer      Format '>>>>>>>9':U                                 Label 'Num Livre 2'     
    Field num-livre-3               As Integer      Format '>>>>>>>9':U                                 Label 'Num Livre 3'
    Field num-livre-4               As Integer      Format '>>>>>>>9':U                                 Label 'Num Livre 4'
    Field num-livre-5               As Integer      Format '>>>>>>>9':U                                 Label 'Num Livre 5'
    Field dec-livre-1               As Decimal      Format '>>>>>>9.9999':U     Decimals 4              Label 'Dec Livre 1'
    Field dec-livre-2               As Decimal      Format '>>>>>>9.9999':U     Decimals 4              Label 'Dec Livre 2'
    Field dec-livre-3               As Decimal      Format '>>>>>>9.9999':U     Decimals 4              Label 'Dec Livre 3'
    Field dec-livre-4               As Decimal      Format '>>>>>>9.9999':U     Decimals 4              Label 'Dec Livre 4'
    Field dec-livre-5               As Decimal      Format '>>>>>>9.9999':U     Decimals 4              Label 'Dec Livre 5'
    Field log-livre-1               As Logical      Format 'Sim/NÆo'                                    Label 'Log Livre 1'
    Field log-livre-2               As Logical      Format 'Sim/NÆo'                                    Label 'Log Livre 2'
    Field log-livre-3               As Logical      Format 'Sim/NÆo'                                    Label 'Log Livre 3'
    Field log-livre-4               As Logical      Format 'Sim/NÆo'                                    Label 'Log Livre 4'
    Field log-livre-5               As Logical      Format 'Sim/NÆo'                                    Label 'Log Livre 5'
    Field dat-livre-1               As Date         Format '99/99/9999'                                 Label 'DataLivre 1'
    Field dat-livre-2               As Date         Format '99/99/9999'                                 Label 'DataLivre 2'
    Field dat-livre-3               As Date         Format '99/99/9999'                                 Label 'DataLivre 3'
    Field dat-livre-4               As Date         Format '99/99/9999'                                 Label 'DataLivre 4'
    Field dat-livre-5               As Date         Format '99/99/9999'                                 Label 'DataLivre 5'
    index codigo  is primary unique it-codigo.

/*****[ Documenta‡Æo dos Campos ]**********************************************
/*************[ INICIO Campos Utilizados no Ems e no Magnus I00 ]*************/
Campos:
    1.) Cod-depos.............: C¢digo Dep¢sito
    2.) Cod-estabel...........: C¢digo Estabelecimento
    3.) Cod-refer.............: C¢digo Referencia
    4.) Ct-codigo.............: Conta
    5.) Nr-ord-produ..........: Numero Ordem Produ‡Æo
    6.) It-codigo.............: C¢digo do Item
    7.) Cod-localiz...........: C¢digo da Localiza‡Æo
    8.) Lote..................: Numero do Lote
    9.) Nro-docto.............: Numero do Documento
   10.) Num-sequen............: Sequencia da Requisi‡Æo
   11.) Quantidade............: Quantidade Requisitada
   12.) Sc-codigo.............: SubConta
   13.) Op-codigo.............: C¢digo da Opera‡Æo
   14.) Un....................: Unidade de Medida
   15.) Dt-vali-lote..........: Data Validade Lote
   16.) Data-transacao........: Data da Transa‡Æo
   17.) Cod-unico.............: C¢digo Unico
   18.) Cod-usuario...........: C¢digo do Usuario

/*************[ FINAL  Campos Utilizados no Ems e no Magnus I00 ]*************/

/*****************[ INICIO Campos Utilizados somente no Ems ]****************/
/****************************************************************************/
Campos:
    1.) Cod-depos.............: C¢digo Dep¢sito
    5.) Nr-ord-produ..........: Numero Ordem Produ‡Æo
    2.) nr-ord-refer..........: N£mero Ordem Referencia
    3.) nr-req-sum............: Numero Requisi‡Æo Simarizada
    4.) cod-roteiro...........: C¢digo do Roteiro
    5.) nr-reporte............: Numero do Reporte
    6.) item-pai..............: C¢digo do Item Pai
    7.) Op-codigo.............: C¢digo da Opera‡Æo
    8.) Cod-usuario...........: C¢digo do Usuario
    9.) qt-alocada............: Quantidade Alocada
   10.) gera-saldo............: Indicador se Gera Saldo


/*****************[ FINAL  Campos Utilizados somente no Ems ]****************/

/*************[ INICIO Campos Utilizados somente no Magnus I00 ]*************/
Campos:
    1.) livre-2...............: Para alimentar este campo utilizar o cod-livre-1
    2.) char-1................: Para alimentar este campo utilizar o cod-livre-2
    3.) u-char-1..............: Para alimentar este campo utilizar o cod-livre-3
    4.) livre-1...............: Para alimentar este campo utilizar o num-livre-1
    5.) int-1.................: Para alimentar este campo utilizar o num-livre-2
    6.) livre-3...............: Para alimentar este campo utilizar o dec-livre-1
    7.) livre-4...............: Para alimentar este campo utilizar o dec-livre-2
    8.) dec-1.................: Para alimentar este campo utilizar o dec-livre-3
    9.) dec-2.................: Para alimentar este campo utilizar o dec-livre-4
   10.) u-dec-1...............: Para alimentar este campo utilizar o dec-livre-5
   11.) log-1.................: Para alimentar este campo utilizar o log-livre-1

/*************[ FINAL  Campos Utilizados somente no Magnus I00 ]*************/

/*******************[ INICIO Campos de Uso Interno Datasul ]*****************/
/*******************[      NÆo Devem Ser Alimentados       ]*****************/ 
/****************************************************************************/
Campos:
    1.) Sequen-nf.............: Sequencia Nota Fiscal
    2.) Cod-emitente..........: C¢digo do Emitente
    3.) Descricao-db..........: Descri‡Æo D‚bito Direto
    4.) Dt-nf-saida...........: Data Nota Fiscal Saida
    5.) Nat-operacao..........: Natureza de Opera‡Æo
    6.) Numero-ordem..........: Numero da Ordem
    7.) Esp-docto.............: Esp‚cie Documento
    8.) Peso-liquido..........: Peso Liquido
    9.) Referencia............: C¢digo Referencia (apenas documentacional)
   10.) Serie-docto...........: Serie Documento
   11.) Tipo-trans............: Tipo Transacao
   12.) Tipo-preco............: Tipo Preco
   13.) Tipo-valor............: Tipo Valor
   14.) Valor-mat-m...........: Valor Materiais
   15.) Valor-mat-o...........: Valor Materiais
   16.) Valor-mat-p...........: Valor Materiais
   17.) Valor-mob-m...........: Valor MÆo-de-Obra
   18.) Valor-mob-o...........: Valor MÆo-de-Obra
   19.) Valor-mob-p...........: Valor MÆo-de-Obra
   20.) Valor-ggf-m...........: Valor GGF
   21.) Valor-ggf-o...........: Valor GGF
   22.) Valor-ggf-p...........: Valor GGF
   23.) Valor-nota............: Valor Nota Fiscal
   24.) Vl-nota-fasb..........: Valor Nota Fiscal Fasb
   25.) Nr-ord-refer..........: Numero Ordem Referencia
   26.) Nr-req-sum............: Numero requisi‡Æo Sumarizada
   27.) Cod-roteiro...........: C¢digo Roteiro
   28.) Nr-reporte............: Numero do Reporte
   29.) Item-pai..............: C¢digo Item Pai
   32.) Ct-db.................: Conta Debito Direto
   33.) Sc-db.................: SubConta Debito Direto
   34.) Op-seq................: Sequencia Opera‡Æo
   35.) Nr-trans..............: Numero da Transa‡Æo
   36.) Cod-estabel-des.......: C¢digo Estabelecimento Destino
   37.) Origem-valor..........: Origem do Valor
   38.) Num-ord-des...........: Numero Ordem Destino
   39.) Num-seq-des...........: Numero Ordem 
   40.) Num-ord-inv...........: Numero Ordem Inventario
   41.) Valor-ipi.............: Valor IPI
   42.) Valor-iss.............: Valor ISS
   43.) Valor-icm.............: Valor ICM
   44.) Vl-icm-fasb...........: Valor ICM Fasb
   45.) Vl-iss-fasb...........: Valor ISS Fasb
   46.) Vl-ipi-fasb...........: Valor IPI Fasb
   47.) Atualiza-ul-ent.......: Indicador se atualiza a ultima entrada
   48.) I-sequen..............: Sequencia
   49.) Gera-saldo............: Indicador se gera saldo
   50.) Qt-alocada............: Quantidade Alocada
   51.) Cod-versao-integracao.: C¢digo VersÆo Integra‡Æo
   52.) Cod-prog-orig.........: C¢digo Programa origem
   53.) Cod-usu-ult-alter.....: C¢digo Usuario Ultima Altera‡Æo
   54.) L-mov-erro............: Indicador Gera Erro
   55.) R-mov-inv.............: RowId Movimento Inventario
   56.) R-mov-orig............: RowId Movimento Origem

/*****************[ FINAL  Campos Utilizados somente no Ems ]****************/

*******************************************************************************/
