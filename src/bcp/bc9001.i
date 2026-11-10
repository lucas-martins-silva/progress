/********************************************************************************************
**   Include...: bc9001.i                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - Set/2000 - Luciano Leonhardt                                **
**                                                                                         **
**   Objetivo..: Armazenar os dados para transacao de Transferencia de Materiais           **
**                                                                                         **
********************************************************************************************/

Define {1} Temp-Table tt-transfere-bc NO-UNDO
    Field cod-estabel               LIKE estabelec.cod-estabel                          Label "Estab" 
    Field num-documento             As Character    Format 'x(10)':U                    Label "Nro Docto"
    Field cod-serie-documento       As Character    Format 'x(05)':U                    Label "Serie Docto"
    Field num-especie-documento     As Integer      Format '>9':U                       Label "Espec Docto"
    Field data-transacao            As Date         Format '99/99/9999':U               Label "Data Trans"
    Field cod-item                  As Character    Format 'x(16)':U                    Label "Item" 
    Field cod-unico                 As Character    Format 'x(16)':U                    Label "Codig Unico" 
    Field cod-refer-origem          As Character    Format 'x(08)':U                    Label "Refer Orig"
    Field cod-refer-destino         As Character    Format 'x(08)':U                    Label "Refer Dest"
    Field cod-depos-origem          As Character    Format 'x(03)':U                    Label "Depos Orig"
    Field cod-depos-destino         As Character    Format 'x(03)':U                    Label "Depos Dest"
    Field cod-local-origem          As Character    Format 'x(20)':U                    Label "Local Orig"
    Field cod-local-destino         As Character    Format 'x(20)':U                    Label "Local Dest"
    Field cod-lote-origem           As Character    Format 'x(40)':U                    Label "Lote Orig"
    Field cod-lote-destino          As Character    Format 'x(40)':U                    Label "Lote Dest"
    Field dat-valid-lote-origem     As Date         Format '99/99/9999':U               Label "Vl Lote Orig"
    Field dat-valid-lote-destino    As Date         Format '99/99/9999':U               Label "Vl Lote Dest"
    Field cod-usuario               As Character    Format 'x(12)':U                    Label "Usuario"
    Field qtd-movimento             As Decimal      Format '>>>>>>9.9999':U Decimals 4   Label "Quantidade"
    /*****[ Inicio Campos Utilizados somente para Produto Magnus I00 ] *****/
    Field ct-codigo                 As Character    Format 'x(08)':U                    Label "Conta"
    Field sc-codigo                 As Character    Format 'x(05)':U                    Label "SubConta"
    Field num-sequencia             As Integer      Format '>>9':U                      Label "Seq"
    Field un                        As Character    Format 'x(03)':U                    Label "Un"
    /*****[ Fim Campos Utilizados somente para Produto Magnus I00 ] *****/
    Field cod-livre-1               As Character    Format 'x(40)':U                    Label "Cod Livre 1"
    Field cod-livre-2               As Character    Format 'x(40)':U                    Label "Cod Livre 2"
    Field cod-livre-3               As Character    Format 'x(40)':U                    Label "Cod Livre 3"
    Field num-livre-1               As Integer      Format '>>>>>>>9':U                 Label "Num Livre 1"     
    Field num-livre-2               As Integer      Format '>>>>>>>9':U                 Label "Num Livre 2"     
    Field num-livre-3               As Integer      Format '>>>>>>>9':U                 Label "Num Livre 3"
    Field dec-livre-1               As Decimal      Format '>>>>>>9.9999':U Decimals 4   Label "Dec Livre 1"
    Field dec-livre-2               As Decimal      Format '>>>>>>9.9999':U Decimals 4   Label "Dec Livre 2"
    Field dec-livre-3               As Decimal      Format '>>>>>>9.9999':U Decimals 4   Label "Dec Livre 3"
    Field log-livre-1               As Logical      Format 'Sim/Nao'                    Label "Log Livre 1"
    Field log-livre-2               As Logical      Format 'Sim/Nao'                    Label "Log Livre 2"
    Field log-livre-3               As Logical      Format 'Sim/Nao'                    Label "Log Livre 3"
    Field dat-livre-1               As Date         Format '99/99/9999'                 Label 'DataLivre 1'
    Field dat-livre-2               As Date         Format '99/99/9999'                 Label 'DataLivre 2'
    Field dat-livre-3               As Date         Format '99/99/9999'                 Label 'DataLivre 3'
    INDEX Item IS PRIMARY Cod-Item
    .
    
/***********************************************************************************/

/*****[ Documenta‡Æo dos Campos ]**********************************************
/*************[ INICIO Campos Utilizados no Ems e no Magnus I00 ]*************/
Campos:
    1.) cod-estabel............: C¢digo do Estabelecimento
    2.) num-documento..........: Numero do Documento
    3.) data-transacao.........: Data da Transa‡Æo
    4.) cod-item...............: C¢digo do Item
    5.) cod-unico..............: C¢digo Unico
    6.) cod-depos-origem.......: C¢digo Deposito Origem
    7.) cod-depos-destino......: C¢digo Deposito Destino
    8.) cod-local-origem.......: C¢digo Localiza‡Æo Origem
    9.) cod-local-destino......: C¢digo Localiza‡Æo Destino
   10.) cod-lote-origem........: C¢digo Lote Origem
   11.) qtd-movimento..........: Quantidade Movimentada

/*************[ FINAL  Campos Utilizados no Ems e no Magnus I00 ]*************/

/*****************[ INICIO Campos Utilizados somente no Ems ]****************/
/****************************************************************************/
Campos:
    1.) cod-unico..............: C¢digo Unico

/*****************[ FINAL  Campos Utilizados somente no Ems ]****************/

/*************[ INICIO Campos Utilizados somente no Magnus I00 ]*************/
/****************************************************************************/
Campos:
    1.) cod-serie-documento....: Serie Documento
    2.) num-especie-documento..: Especie Documento
    3.) cod-refer-origem.......: C¢digo Referencia Origem
    4.) cod-refer-destino......: C¢digo Referencia Destino
    5.) cod-lote-destino.......: C¢digo Lote Destino
    6.) dat-valid-lote-origem..: Data Validade Lote Origem
    7.) dat-valid-lote-destino.: Data Validade Lote Destino
    8.) cod-usuario............: C¢digo Usuario
    9.) ct-codigo..............: Conta
   10.) sc-codigo..............: SubConta
   11.) num-sequencia..........: Sequencia
   12.) un.....................: Unidade Medida

/*************[ FINAL  Campos Utilizados somente no Magnus I00 ]*************/

/*******************[ INICIO Campos de Uso Interno Datasul ]*****************/
/*******************[      NÆo Devem Ser Alimentados       ]*****************/ 
/****************************************************************************/
Campos:
*******************************************************************************/

