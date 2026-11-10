
/********************************************************************************************
**   Include...: bc9010.i                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - dez/2000 - Denis Roberto Eloterio                           **
**                                                                                         **
**   Objetivo..: Armazenar os dados para transacao de Saidas WMS                           **
**                                                                                         **
********************************************************************************************/

Define {1} Temp-Table tt-box-movto-bc 

    /* CAMPOS REFERENTES AO QUE FOI DEFINIDO PELO WMS */
    Field cod-estabel-ped           As Character    Format 'x(03)':U                    Label "Estab Ped"     
    Field id-box-ped                As Decimal      Format '>>>>>>>>>9':U               Label "ID Box Ped"    
    Field id-docto-ped              As Decimal      Format '>>>>>>>>>9':U               Label "ID Docto Ped"
    Field cod-local-ped             As Character    Format 'x(03)':U                    Label "Local Ped"   
    Field num-seq-item-ped          As Integer      Format '>>>>>9':U                   Label "Seq item Ped" 
    Field qtd-item-ped              As Decimal      Format '>>>,>>>,>>9.9999':U Decimals 4
                                                                                         Label "Qtd Item Ped"
    Field qti-embalagem-ped         As Decimal      Format '>>>>>>>>9':U                Label "Qti Emb  Ped"    
    Field cod-item-ped              As Character    Format 'x(15)':U                    Label "Cod item Ped"
    Field cod-embalagem-ped         As Character    Format 'x(10)':U                    Label "Cod Embal Ped"
    Field dt-transacao-ped          As Date         Format '99/99/9999'                 Label "Dt Trans Ped"
    
    /* CAMPOS REFERENTES AO QUE FOI LIDO PELO COLETOR */
    Field cod-estabel-col           As Character     Format 'x(03)':U                    Label "Estab Col"
    Field id-box-col                As Decimal       Format '>>>>>>>>>9':U               Label "ID Box Col"        
    Field id-docto-col              As Decimal       Format '>>>>>>>>>9':U               Label "ID Docto Col"
    Field cod-local-col             As Character     Format 'x(03)':U                    Label "Local Box Col"   
    Field num-seq-item-col          As Integer       Format '>>>>>9':U                   Label "Seq item Col" 
    Field qtd-item-col              As Decimal       Format '>>>,>>>,>>9.9999':U Decimals 4 
                                                                                         Label "Qtd Item Col"
    Field qti-embalagem-col         As Decimal       Format '>>>>>>>>9':U                Label "Qti Emb  Col"    
    Field cod-item-col              As Character     Format 'x(15)':U                    Label "Cod item Col"
    Field cod-embalagem-col         As Character     Format 'x(10)':U                    Label "Cod Embal Col"
    Field dt-transacao-col          As Date          Format '99/99/9999'                 Label "Dt Trans Col"
    
    /* CAMPOS DE CONTROLE */    
    Field ind-origem-docto          As Integer       Format '>>>>>>9':U                  Label "Ind Orig Doc"
    Field data-transacao-ini        As Date          Format '99/99/9999':U               Label "Data Ini Tra"
    Field hora-transacao-ini        As Character     Format 'x(08)':U                    Label "Hora Ini Tra"
    Field data-transacao-fim        As Date          Format '99/99/9999':U               Label "Data Fim Tra" 
    Field hora-transacao-fim        As Character     Format 'x(08)':U                    Label "Hora Fim Tra"
    Field usuario                   As Character     Format 'x(12)':U                    Label "Usu rio"
    
    /* CAMPOS LIVRES PADROES */
    Field cod-livre-1               As Character     Format 'x(40)':U                    Label "Cod Livre 1"
    Field cod-livre-2               As Character     Format 'x(40)':U                    Label "Cod Livre 2"
    Field cod-livre-3               As Character     Format 'x(40)':U                    Label "Cod Livre 3"
    Field num-livre-1               As Integer       Format '>>>>>>>9':U                 Label "Num Livre 1"     
    Field num-livre-2               As Integer       Format '>>>>>>>9':U                 Label "Num Livre 2"     
    Field num-livre-3               As Integer       Format '>>>>>>>9':U                 Label "Num Livre 3"
    Field dec-livre-1               As Decimal       Format '>>>>>>9.999':U Decimals 4   Label "Dec Livre 1"
    Field dec-livre-2               As Decimal       Format '>>>>>>9.999':U Decimals 4   Label "Dec Livre 2"
    Field dec-livre-3               As Decimal       Format '>>>>>>9.999':U Decimals 4   Label "Dec Livre 3"
    Field log-livre-1               As Logical       Format 'Sim/Nao'                    Label "Log Livre 1"
    Field log-livre-2               As Logical       Format 'Sim/Nao'                    Label "Log Livre 2"
    Field log-livre-3               As Logical       Format 'Sim/Nao'                    Label "Log Livre 3"
    Field dat-livre-1               As Date          Format '99/99/9999'                 Label 'DataLivre 1'
    Field dat-livre-2               As Date          Format '99/99/9999'                 Label 'DataLivre 2'
    Field dat-livre-3               As Date          Format '99/99/9999'                 Label 'DataLivre 3'
    INDEX Item IS PRIMARY id-docto-ped
    .
    
