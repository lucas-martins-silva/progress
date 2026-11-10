/********************************************************************************************
**   Include...: bc9011.i                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - Jun/2001 - Carlos Alberto Soares Pereira                    **
**                                                                                         **
**   Objetivo..: Armazenar os dados para transacao de Requisicao de Materiais Ordem Manut  **
**                                                                                         **
********************************************************************************************/

Define {1} Temp-Table tt-requis-manut-bc
    Field cod-estabel               LIKE estabelec.cod-estabel                                          Label 'Estabel'        
    Field nro-docto                 as CHAR         Format 'x(16)':U                                    Label 'Nro Documento'  
    Field serie-docto               as Char         Format 'x(5)':U                                     Label 'Serie Docto'    
    Field dt-trans                  as Date         Format '99/99/9999'                                 Label 'Data Trans'     
    Field numero-ordem              as Int          Format '>>>>>>>>9'                                  Label 'Numero Ordem'   
    Field op-codigo                 as Int          Format '>>>9'                                       Label 'Atividade'      
    Field it-codigo                 as Char         Format 'x(16)'                                      Label 'Item'           
    Field cod-refer                 as Char         Format 'x(8)'                                       Label 'Refer'          
    Field cod-depos                 as Char         Format 'x(3)'                                       Label 'Deposito'       
    Field localizacao               as Char         Format 'x(8)'                                       Label 'Localizacao'    
    Field lote                      as Char         Format 'x(10)'                                      Label 'Lote'           
    Field quantidade                as Deci         Format '>>>>>9.99'                                  Label 'Quantidade'     
    Field un                        as Char         Format 'x(2)'                                       Label 'Unidade Medida' 
    Field dt-validade-lote          as Date         Format '99/99/9999'                                 Label 'Data Lote'
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
    Field dat-livre-5               As Date         Format '99/99/9999'                                 Label 'DataLivre 5'.

/*****************[ FINAL  Campos Utilizados somente no Ems ]****************/

