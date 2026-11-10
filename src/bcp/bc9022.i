/********************************************************************************************
**   Include...: bc9022.i                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000                                                               **
**                                                                                         **
**   Objetivo..: Armazenar os dados para transacao de Packing List WMS                     **
**                                                                                         **
********************************************************************************************/

Define {1} Temp-Table tt-packing-wms
    Field cod-usuario               As Character    Format 'x(25)':U                                    Label 'Usuario' 
    Field cod-coletor               As Character    Format 'x(12)':U                                    Label 'Coletor' 
    Field cod-estabel               LIKE estabelec.cod-estabel                                          Label 'Estabel' 
    Field cod-local                 As Character    Format 'x(05)':U                                    Label 'Local' 
    Field cod-pedcli                As Character    Format 'x(12)':U                                    Label 'Pedido Cliente'           
    Field nom-abrev                 As Character    Format 'x(15)':U                                    Label 'Nome Abreviado'           
    Field cdd-embarq                As DECIMAL      Format '>>>>>>>>>>>>>>>9':U                         Label 'Embarque'         
    Field num-resumo                As Integer      Format '>>>>>>>9':U                                 Label 'Resumo'           
    Field num-volume-pack           As Integer      Format '>>>>>>>9':U                                 Label 'Volume Pack'           
    Field cod-volume                As Character    Format 'x(10)':U                                    Label 'Vol/Embal'      
    Field num-volume                As Integer      Format '>>>>>>>9':U                                 Label 'Seq Volume'           
    Field num-documento             As Decimal      Format '>>>>>>>>>9':U                               Label 'Documento' 
    Field num-tarefa                As Decimal      Format '>>>>>>>>>9':U                               Label 'Tarefa' 
    Field cod-equipamento           As Character    Format 'x(12)':U                                    Label 'Equipamento' 
    Field num-seq-volume            As Integer      Format '>>>>9':U                                    Label 'Seq Volume'
    Field num-serial                As Decimal      Format '>>>>>>>>>>>>>>':U                           Label 'Ultimo Serial'
    FIELD cod-item                  AS CHARACTER    FORMAT "X(16)"                                      LABEL 'Item'
    FIELD des-item                  AS CHARACTER    FORMAT "X(50)"                                      LABEL 'Des Item'
    FIELD qtd-item                  AS DECIMAL      FORMAT ">>>,>>>,>>9.9999"                           LABEL 'Quantidade'
    FIELD qtd-peso                  AS DECIMAL      FORMAT ">,>>>,>>9.9999"                             LABEL 'Peso'
    Field dat-transacao             As Date         Format '99/99/9999'                                 Label 'Transacao'
    Field log-finaliza              As Logical      Format 'Sim/NÆo'                                    Label 'Finaliza'
    Field log-inicializa            As Logical      Format 'Sim/NÆo'                                    Label 'Inicializa'
    Field tip-movimento             As Integer      Format '9':U                                        Label 'Tip Movto'           
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
    Field cod-opcao                 As INTEGER      Format 9.
/*******************************************************************************/


