/********************************************************************************************
**   Programa..: bc9051.i                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000                                                               **
**                                                                                         **
**   Finalidade: Adapter da transacao de Transferencia e Requisicao de alocados            **
**                                                                                         **
********************************************************************************************/

Define {1} Temp-Table tt-transfere-prod-bc NO-UNDO
    Field nr-ord-produ              As Integer      Format '>>>,>>>,>>9'                Label 'Ord.Produ‡Æo'
    Field nr-req-sum                As Integer      Format '>>>,>>>,>>9'                Label 'Req.Sum'
    Field cod-depos-sai             As Character    Format 'x(03)'                      Label 'Depos.Sai'
    Field cod-localiz-sai           As Character    Format 'x(20)'                      Label 'Local.Sai'
    Field cod-depos-ent             As Character    Format 'x(03)'                      Label 'Depos.Ent'
    Field cod-localiz-ent           As Character    Format 'x(20)'                      Label 'Local.Ent'
    Field it-codigo                 As Character    Format 'x(16)'                      Label 'Item'
    Field cod-refer                 As Character    Format 'x(10)'                      Label 'Referencia'
    Field lote-serie                As Character    Format 'x(40)'                      Label 'Lote/Serie'
    Field quantidade                As Decimal      Format '>>>>>>9.9999':U Decimals 4  Label 'Quantidade'
    Field data-transacao            As Date         Format '99/99/9999':U               Label "Data Trans"
    Field num-documento             As Character    Format 'x(10)':U                    Label "Nro Docto"
    Field cod-serie-documento       As Character    Format 'x(05)':U                    Label "Serie Docto"
    Field cod-usuario               As Character    Format 'x(12)':U                    Label "Usuario"
    
    index codigo  is primary unique nr-ord-produ it-codigo cod-refer lote-serie.
    
    
    
