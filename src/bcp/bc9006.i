/********************************************************************************************
**   Include...: bc9006.i                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - Set/2000 - Luciano Leonhardt                                **
**                                                                                         **
**   Objetivo..: Armazenar os dados para transacao de Reporte Repetitivo                   **
**                                                                                         **
********************************************************************************************/

Define Temp-Table tt-reporte-repet-bc NO-UNDO
    Field nr-reporte                As Integer      Format '>>>>>>>9':U                 Label 'Nr-Reporte'
    Field data                      As Date         Format '99/99/9999':U               Label 'DataFabric'
    Field qt-reporte                As Decimal      Format '>>>>>>9.9999':U Decimals 4   Label 'Quant.Reporte'
    Field qt-refugo                 As Decimal      Format '>>>>>>9.9999':U Decimals 4   Label 'Quant.Refugo'
    Field qt-estorno                As Decimal      Format '>>>>>>9.9999':U Decimals 4   Label 'Quant.Estorno'
    Field cod-usuario               As Character    Format 'x(12)':U                    Label 'usuario'
    Field hora                      As Character    Format 'x(08)':U                    Label 'Hora'
    Field it-codigo                 As Character    Format 'x(16)':U                    Label 'Item'
    Field ct-refugo                 As Character    Format 'x(20)':U                    Label 'Conta Refugo'
    Field sc-refugo                 As Character    Format 'x(20)':U                    Label 'Centro Custo Refugo'
    Field qt-apr-cond               As Decimal      Format '>>>>>>9.9999':U Decimals 4   Label 'Quant.Apr.Cond'
    Field nro-docto                 As Character    Format 'x(16)':U                    Label 'Nro.Docto'
    Field serie-docto               As Character    Format 'x(05)':U                    Label 'Serie Docto'
    Field cod-depos                 As Character    Format 'x(03)':U                    Label 'Depos Aca'
    Field lote-serie                As Character    Format 'x(40)':U                    Label 'Lote'
    Field cod-refer                 As Character    Format 'x(08)':U                    Label 'Referencia'
    Field dt-vali-lote              As Date         Format '99/99/9999':U               Label 'DtValLote'
    Field cod-localiz               As Character    Format 'x(20)':U                    Label 'Local Aca'
    Field cod-estabel               LIKE estabelec.cod-estabel                          Label 'Estabelec'
    Field cod-cta-aplic             As Character    Format 'x(20)':U                    Label 'Conta Aplic'
    field cod-ccusto-aplic          As Character    Format 'x(20)':U                    Label 'Centro Custo Aplic'
    Field qt-est-aprov              As Decimal      Format '>>>>>>9.9999':U Decimals 4   Label 'Quant.Est.Apro'
    Field qt-est-refugo             As Decimal      Format '>>>>>>9.9999':U Decimals 4   Label 'Quant.Est.Ref'
    Field cod-local-sai             As Character    Format 'x(20)':U                    Label 'Local Sai'
    Field cod-depos-sai             As Character    Format 'x(03)':U                    Label 'Depos Sai'
    Field loc-sai-unica             As Logical      Format 'Sim/Nao'                    Label 'Local Unica'
    Field rw-rep-prod               As Rowid
    Field prog-seg                  As Character    Format 'x(20)':U                    Label 'Prog.Chamador'
    Field time-out                  As Integer      Format '>>>>>>>9':U    Initial 30   Label 'Time Out'
    Field tentativas                As Integer      Format '>>>>>>>9':U    Initial 10   Label 'Tentativas'
    Field cod-versao-integracao     As Integer      Format '>>9':U                      Label 'Cod.Vers∆o'
    Field estado-rep                As Character    Format 'X(08)'                      Label 'EstadoRep'
    Field ct-db-codigo              As Integer      Format '9':U                        Label 'Conta'
    Field sc-db-codigo              As Integer      Format '9':U                        Label 'SubConta'
    Field data-transacao            As Date         Format '99/99/9999':U               Label 'Dt.Transaá∆o'
    Field cod-unico                 As Character    Format 'x(16)':U                    Label 'Cod.Unido'
    Field cod-livre-1               As Character    Format 'x(40)':U                    Label 'Cod Livre 1'
    Field cod-livre-2               As Character    Format 'x(40)':U                    Label 'Cod Livre 2'
    Field cod-livre-3               As Character    Format 'x(40)':U                    Label 'Cod Livre 3'
    Field num-livre-1               As Integer      Format '>>>>>>>9':U                 Label 'Num Livre 1'     
    Field num-livre-2               As Integer      Format '>>>>>>>9':U                 Label 'Num Livre 2'     
    Field num-livre-3               As Integer      Format '>>>>>>>9':U                 Label 'Num Livre 3'
    Field dec-livre-1               As Decimal      Format '>>>>>>9.9999':U Decimals 4   Label 'Dec Livre 1'
    Field dec-livre-2               As Decimal      Format '>>>>>>9.9999':U Decimals 4   Label 'Dec Livre 2'
    Field dec-livre-3               As Decimal      Format '>>>>>>9.9999':U Decimals 4   Label 'Dec Livre 3'
    Field log-livre-1               As Logical      Format 'Sim/Nao'                    Label 'Log Livre 1'
    Field log-livre-2               As Logical      Format 'Sim/Nao'                    Label 'Log Livre 2'
    Field log-livre-3               As Logical      Format 'Sim/Nao'                    Label 'Log Livre 3'
    Field dat-livre-1               As Date         Format '99/99/9999'                 Label 'DataLivre 1'
    Field dat-livre-2               As Date         Format '99/99/9999'                 Label 'DataLivre 2'
    Field dat-livre-3               As Date         Format '99/99/9999'                 Label 'DataLivre 3'
    INDEX Item IS PRIMARY It-codigo
    .


/***********************************************************************************/


/*****[ Documentaá∆o dos Campos ]**********************************************
/*************[ INICIO Campos Utilizados no Ems e no Magnus I00 ]*************/
Campos:
    1.) nr-reporte............: Sequencia de Reportes
    2.) data..................: Data de Fabricaá∆o
    3.) qt-reporte............: Quantidade Reportada
    4.) qt-refugo.............: Quantidade Refugada
    5.) qt-estorno............: Quantidade Estornada
    6.) usuario...............: Usuario
    7.) hora..................: Hora Fabricaá∆o
    8.) it-codigo.............: Item Acabado
    9.) ct-refugo.............: Conta Refugo
   10.) sc-refugo.............: Centro de Custo Refugo
   11.) qt-apr-cond...........: Quantidade Aprovado Condicional
   12.) nro-docto.............: Numero Documento
   13.) serie-docto...........: Serie do Documento
   14.) cod-depos.............: Deposito Destino
   15.) lote-serie............: Lote
   16.) cod-refer.............: Referencia
   17.) dt-vali-lote .........: Data Validade Lote
   18.) cod-localiz...........: Localizacao Destino
   19.) cod-estabel...........: Estabelecimento
   20.) cod-depos-sai.........: Deposito Origem
   21.) dat-transacao.........: Data da Transaá∆o
   22.) cod-unico.............: C¢digo Unico


/*************[ FINAL  Campos Utilizados no Ems e no Magnus I00 ]*************/

/*****************[ INICIO Campos Utilizados somente no Ems ]****************/
/****************************************************************************/
Campos:
    1.) cod-cta-aplic-unif....: Conta Aplicaá∆o
    2.) cod-ccusto-aplic-unif.: Centro de Custo Aplicaá∆o
    3.) qt-est-aprov..........: Quantidade Estornado Aprovado Condicional
    4.) qt-est-refugo.........: Quantidade Estornado Refugo
    5.) cod-local-sai.........: Localizaá∆o Origem
    6.) loc-sai-unica.........: Localizaá∆o Unica


/*****************[ FINAL  Campos Utilizados somente no Ems ]****************/

/*************[ INICIO Campos Utilizados somente no Magnus I00 ]*************/
Campos:
    1.) estado-rep............: Estado Reporte
    2.) ct-db-codigo..........: Conta
    3.) sc-db-codigo..........: SubConta


/*************[ FINAL  Campos Utilizados somente no Magnus I00 ]*************/

/*******************[ INICIO Campos de Uso Interno Datasul ]*****************/
/*******************[      N∆o Devem Ser Alimentados       ]*****************/ 
/****************************************************************************/
Campos:
    1.) rw-rep-prod...........: RowId Reporte Producao
    2.) prog-seg..............: Programa chamador
    3.) time-out..............: Campos Utilizado somente quando processo for via RPC
    4.) tentativas............: Campos Utilizado somente quando processo for via RPC
    5.) cod-versao-integracao.: C¢digo vers∆o de integraá∆o
    6.) l-emite-rel...........: Indicador se emite relat¢rio
    7.) l-utiliza-faixa.......: Indicador se utiliza uma faixa

/*****************[ FINAL  Campos Utilizados somente no Ems ]****************/
*******************************************************************************/
