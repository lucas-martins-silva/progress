
Define {1} Temp-Table tt-storage-serial-wms
    /* Info de Tela - Referente a Login */
    Field cod-usuario      As Character  Format 'x(14)':U                   Label 'Usuario' 
    Field cod-coletor      As Character  Format 'x(14)':U                   Label 'Coletor' 
    Field cod-equipamento  As Character  Format 'x(14)':U                   Label 'Equipamento' 
    /* Info de Tela - Referente a Tarefa*/                                 
    Field num-serial       As Decimal    Format '>>>>>>>>>>>>>>':U          Label 'Ultimo Serial'
    Field des-endereco     As Character  Format 'x(18)':U                   Label 'Endereco'
    Field cod-item         As Character  Format 'x(10)':U                   Label 'Item'            
    Field num-box-lido     As Decimal    Format '>>>>>9':U                  Label 'Box Lido'
    /* Referente a tarefa */                                               
    Field cod-estabel      LIKE estabelec.cod-estabel                       Label 'Estabel' 
    Field cod-local        As Character  Format 'x(05)':U                   Label 'Local' 
    Field id-docto         As Decimal    Format '>>>>>>>>>9':U              Label 'Documento' 
    FIELD ind-tipo-movto   AS INTEGER    FORMAT '>9':U                      LABEL 'Tipo Movto'
    Field id-movto         As Decimal    Format '>>>>>>>>>9':U              Label 'Movimento' 
    Field num-seq-item     As Integer    Format '>>>>9':U                   Label 'Sequencia Item'
    Field num-box          As Integer    Format '>>>>>9':U                  Label 'Box'           
    Field tipo-equipamento As Integer    Format '>9':U                      Label 'Tipo Equipamento' 
    Field qtd-saldo        As Decimal    Format '>>>>>>>9.9999':U           Label 'Qtd Saldo' 
    Field horario-inicio   As Integer    Format '>>>>>>9':U                 Label 'Hora Inicial da Tarefa' 
    /* Campos extras padräes do Data Collection */                         
    Field dat-atualizacao  As Date       Format '99/99/9999'                Label 'Atualizacao'
    Field dat-transacao    As Date       Format '99/99/9999'                Label 'Transacao'
    field cod-lote         as character  Format 'x(40)'                     label 'Nr. S‚rie / Lote'
    Field cod-livre-1      As Character  Format 'x(1000)':U                 Label 'Cod Livre 1'
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







