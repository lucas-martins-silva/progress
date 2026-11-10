/********************************************************************************************
**   Include...: bc9017.i                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000                                                               **
**                                                                                         **
**   Objetivo..: Armazenar os dados para transacao de Armazenamento do WMS                 **
**                                                                                         **
********************************************************************************************/

Define {1} Temp-Table tt-ender-wms
    Field cod-usuario               As Character    Format 'x(25)':U                                    Label 'Usuario' 
    Field cod-coletor               As Character    Format 'x(14)':U                                    Label 'Coletor' 
    Field cod-estabel               LIKE estabelec.cod-estabel                                          Label 'Estabel' 
    Field cod-local                 As Character    Format 'x(05)':U                                    Label 'Local' 
    Field des-endereco              As Character    Format 'x(25)':U                                    Label 'Endereco'
    Field num-documento             As Decimal      Format '>>>>>>>>>9':U                               Label 'Documento' 
    Field num-movimento             As Decimal      Format '>>>>>>>>>9':U                               Label 'Movimento' 
    Field num-seq-item              As Integer      Format '>>>>9':U                                    Label 'Sequencia Item'
    Field num-box                   As Integer      Format '>>>>9':U                                    Label 'Box'           
    Field num-tempo-inicio          As Decimal      Format '>>>>>>>>>>>>>9':U                           Label 'Tempo Inicio'  
    Field cod-equipamento           As Character    Format 'x(14)':U                                    Label 'Equipamento' 
    Field num-doca                  As Integer      Format '>>9':U                                      Label 'Doca'          
    Field qtd-item-digit            As Decimal      Format '>>>>>9.999':U                               Label 'Qtd Item'            
    Field cod-item                  As Character    Format 'x(16)':U                                    Label 'Item'            
    Field qtd-item                  As Decimal      Format '>>>>>9.999':U                               Label 'Qtd Item'            
    Field num-box-lido              As Integer      Format '>>>>>>>9':U                                 Label 'Box Lido'
    Field cod-embalagem             As Character    Format 'x(10)':U                                    Label 'Embalagem'
    Field qtd-embalagem             As Decimal      Format '>>>>>9.999':U                               Label 'Qtd Embal'       
    Field qtd-embal-lidas           As Decimal      Format '>>>>>9.999':U                               Label 'Qtd Embal Lidas' 
    Field des-seriais               As Character    Format 'X(50)':U                                   Label 'Seriais'
    Field num-serial                As Decimal      Format '>>>>>>>>>>>>>>':U                           Label 'Ultimo Serial'
    Field dat-atualizacao           As Date         Format '99/99/9999'                                 Label 'Atualizacao'
    Field dat-transacao             As Date         Format '99/99/9999'                                 Label 'Transacao'
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
    Field cod-opcao                 As INTEGER      Format 9
    FIELD r-rowid                   AS ROWID 
    index ID  is primary num-serial.    

/*******************************************************************************/
