
Define {1} Temp-Table tt-armazena-packing
    /* Info de Tela - Referente a Login */
    FIELD cod-usuario      AS CHARACTER FORMAT 'x(25)':U                    LABEL 'Usuario'         
    FIELD cod-coletor      AS CHARACTER FORMAT 'x(14)':U                    LABEL 'Coletor'      INITIAL ""
    FIELD cod-equipamento  AS CHARACTER FORMAT 'x(14)':U                    LABEL 'Equipamento'  INITIAL ""
    /* Info de Tela - Referente a Tarefa*/                                          
    FIELD num-serial       AS DECIMAL   FORMAT '>>>>>>>>>>>>>>>':U          LABEL 'Etiqueta'
    FIELD num-box          AS DECIMAL   FORMAT '>>>>>>>>>9':U               LABEL 'Endereco'
    /* Referente a tarefa */                                                        
    FIELD cod-estabel      AS CHARACTER FORMAT 'x(3)':U                     LABEL 'Estabelecimento'
    FIELD cod-local        AS CHARACTER FORMAT 'x(3)':U                     LABEL 'Local'
    FIELD cdd-embarq       AS DECIMAL   FORMAT '>>>>>>>>>>>>>>>9':U         LABEL 'Nr.Embarque'
    FIELD nr-resumo        AS INTEGER   FORMAT '>>>>,>>9':U                 LABEL 'Nr.Resumo'  
    FIELD nr-pedcli        AS CHARACTER FORMAT 'X(12)':U                    LABEL 'Nr.Pedido'
    FIELD nome-abrev       AS CHARACTER FORMAT 'X(12)':U                    LABEL 'Cliente'
    /* Campos extras padräes do Data Collection */                         
    Field dat-atualizacao  As Date       Format '99/99/9999'                Label 'Atualizacao'
    Field dat-transacao    As Date       Format '99/99/9999'                Label 'Transacao'
    field cod-lote         as character  Format 'x(40)'                     label 'Nr. S‚rie / Lote'
    Field cod-livre-1      As Character  Format 'x(40)':U                   Label 'Cod Livre 1'
    Field cod-livre-2      As Character  Format 'x(40)':U                   Label 'Cod Livre 2'
    Field cod-livre-3      As Character  Format 'x(40)':U                   Label 'Cod Livre 3'
    Field cod-livre-4      As Character  Format 'x(40)':U                   Label 'Cod Livre 4'
    Field cod-livre-5      As Character  Format 'x(40)':U                   Label 'Cod Livre 5'
    Field num-livre-1      As Integer    Format '>>>>>>>9':U                Label 'Num Livre 1'
    Field num-livre-2      As Integer    Format '>>>>>>>9':U                Label 'Num Livre 2'     
    Field num-livre-3      As Integer    Format '>>>>>>>9':U                Label 'Num Livre 3'
    Field num-livre-4      As Integer    Format '>>>>>>>9':U                Label 'Num Livre 4'
    Field num-livre-5      As Integer    Format '>>>>>>>9':U                Label 'Num Livre 5'
    Field dec-livre-1      As Decimal    Format '>>>>>>9.9999':U Decimals 4 Label 'Dec Livre 1'
    Field dec-livre-2      As Decimal    Format '>>>>>>9.9999':U Decimals 4 Label 'Dec Livre 2'
    Field dec-livre-3      As Decimal    Format '>>>>>>9.9999':U Decimals 4 Label 'Dec Livre 3'
    Field dec-livre-4      As Decimal    Format '>>>>>>9.9999':U Decimals 4 Label 'Dec Livre 4'
    Field dec-livre-5      As Decimal    Format '>>>>>>9.9999':U Decimals 4 Label 'Dec Livre 5'
    Field log-livre-1      As Logical    Format 'Sim/NÆo'                   Label 'Log Livre 1'
    Field log-livre-2      As Logical    Format 'Sim/NÆo'                   Label 'Log Livre 2'
    Field log-livre-3      As Logical    Format 'Sim/NÆo'                   Label 'Log Livre 3'
    Field log-livre-4      As Logical    Format 'Sim/NÆo'                   Label 'Log Livre 4'
    Field log-livre-5      As Logical    Format 'Sim/NÆo'                   Label 'Log Livre 5'
    Field dat-livre-1      As Date       Format '99/99/9999'                Label 'DataLivre 1'
    Field dat-livre-2      As Date       Format '99/99/9999'                Label 'DataLivre 2'
    Field dat-livre-3      As Date       Format '99/99/9999'                Label 'DataLivre 3'
    Field dat-livre-4      As Date       Format '99/99/9999'                Label 'DataLivre 4'
    Field dat-livre-5      As Date       Format '99/99/9999'                Label 'DataLivre 5'
    FIELD opcao            AS INTEGER    FORMAT '9':U                       LABEL 'Processo'
    index ID  is primary num-serial.







