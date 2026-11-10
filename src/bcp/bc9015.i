/********************************************************************************************
**   Include...: bc9015.i                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000                                                               **
**                                                                                         **
**   Objetivo..: Armazenar os parametros da transacao de geracao de carga WMS/DC       **
**                                                                                         **
********************************************************************************************/


Define Temp-Table      tt-monta-cargas NO-UNDO
    Field tipo-trans                As Integer      Format '>9':U                                       LABEL 'Tipo Transa‡Æo'
    Field num-ponto                 As Integer      Format '9'                                          Label 'Ponto Carga'
    Field cod-usuario               As Character    Format 'x(25)':U                                    Label 'Usuario' 
    Field num-serial                As Decimal      Format '>>>>>>>>>>>>>9'                             Label 'Serial'
    Field dat-leitura               As Date         Format '99/99/9999':U                               Label 'Data Leitura'
    Field hra-leitura               As Character    Format 'x(08)':U                                    Label 'Hora Leitura'
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
    Field dat-livre-1               As Date         Format '99/99/9999':U                               Label 'DataLivre 1'
    Field dat-livre-2               As Date         Format '99/99/9999':U                               Label 'DataLivre 2'
    Field dat-livre-3               As Date         Format '99/99/9999':U                               Label 'DataLivre 3'
    Field dat-livre-4               As Date         Format '99/99/9999':U                               Label 'DataLivre 4'
    Field dat-livre-5               As Date         Format '99/99/9999':U                               Label 'DataLivre 5'
    index ID is primary unique num-serial.

DEFINE TEMP-TABLE tt-monta-cargas-bkp NO-UNDO LIKE tt-monta-cargas
       FIELD nr-trans               AS DECIMAL      FORMAT   'zzzzzzzzz9':U                             LABEL 'Transa‡Æo'.

DEFINE VARIABLE vcarganova AS LOGICAL NO-UNDO.
