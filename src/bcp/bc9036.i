/********************************************************************************************
**   Include...: bc9034.i                                                                  **
**                                                                                         **
**   Versao....: 1.00.00.000                                                               **
**                                                                                         **
**   Objetivo..: Armazenar os dados para transacao de Conferˆncia de Embarque WMS          **
**                                                                                         **
********************************************************************************************/

Define {1} Temp-Table tt-conferencia-embarque-wms-bc
    Field cod-usuario               As Character    Format 'x(25)':U                                    Label 'Usuario' 
    Field cod-coletor               As Character    Format 'x(14)':U                                    Label 'Coletor' 
    Field cod-equipamento           As Character    Format 'x(14)':U                                    Label 'Equipamento' 
    Field cod-tarefa                As INTEGER      Format '>>9':U                                      Label 'Tarefa ' 
    Field cod-estabel               As Character    Format 'x(3)':U                                     Label 'Estab'
    Field cod-local                 As Character    Format 'x(5)':U                                     Label 'Local'
    Field cod-embalagem             As Character    Format 'x(10)':U                                    Label 'Local'

    Field id-docto                  As DECIMAL      format '>>>>>>>>>>>>>>9'                            Label 'Id docto'
    FIELD id-tarefa                 AS DECIMAL      FORMAT '>>>>>>>>>>>>>>>'                            LABEL 'Id Tarefa'

    FIELD cdd-embarq                AS DECIMAL      FORMAT '>>>>>>>>>>>>>>>9'                           LABEL 'Embarque'
    FIELD nr-resumo                 AS INTEGER      FORMAT '>>>>>>>>>9'                                 LABEL 'Resumo'
    FIELD nr-pedcli                 AS CHARACTER    Format 'x(20)':U                                    Label 'Nr Ped Cli'
    FIELD nome-abrev                AS CHARACTER    Format 'x(20)':U                                    Label 'Nome Abrev'
    FIELD num-volume                AS INTEGER      FORMAT '>>>>>>>>>9'                                 LABEL 'Num Voume'
    FIELD nr-leitura                AS INTEGER      FORMAT '>>>>>>>>>9'                                 LABEL 'Nr Leitura'

    Field num-etiqueta-packing      As DECIMAL      format '>>>>>>>>>>>>>>9'                            Label 'Etiqueta Packing'
    
    FIELD qtd-total-leituras        AS DECIMAL      Format '>>>>>>9.9999':U     Decimals 4              LABEL 'Qt Total Volume'
    FIELD qtd-leituras-efetuadas    AS DECIMAL      Format '>>>>>>9.9999':U     Decimals 4              LABEL 'Qt Lida Volume'
    
    Field log-inicia-processo       As Logical      Format 'yes/no'                                     Label 'Inicia Processo'
    Field log-finaliza-processo     As Logical      Format 'yes/no'                                     Label 'Finaliza Processo'

    Field tipo-conferencia          As INTEGER      Format '9'                                          Label 'Tipo Conferencia'
    
    FIELD data-transacao            AS DATE         Format '99/99/9999'                                 LABEL 'Data Transa‡Æo' 
    FIELD hora-transacao            AS CHARACTER    Format 'x(10)'                                      LABEL 'Hora Transa‡Æo'

    FIELD rowid-tabela              AS ROWID        
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
    FIELD opcao                     AS INTEGER      FORMAT '9'                                          LABEL 'Processo'
    index ID  is primary id-docto.

/*******************************************************************************/
