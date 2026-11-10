/**************************************************************************
**
**   Include: BCAPI004.I - Definicao da temp-table Relacao de Programas com
**                         o Tipo da Transa‡Æo
**
***************************************************************************/

def temp-table tt-prog-bc NO-UNDO
    field cod-versao-integracao     as integer
    field usuario                   as char     format "X(12)"
    field cod-prog-dtsul            as char     format "X(50)"
    field cd-trans                  as char     format "X(12)"
    field descricao                 as char     format "X(12)"
    field prog-api-atualizacao      as char     format "X(12)"
    field prog-altera               as char     format "X(12)"
    field prog-etiq                 as char     format "X(12)"
    field prog-import               as char     format "X(12)"
    field prog-criacao              as char     format "X(12)"
    field prog-leitura              as char     format "X(12)"
    field gera-etiq-total           as logical
    field imp-apos-trans            as logical
    field atualiza-on-line          as logical
    field erros-on-line             as logical
    field atualiz-etiq              as logical
    field baixa-reserva             as integer  format ">9"
    field codigo-rejei              as integer  format ">>9"
    /*inicio altera‡äes projeto - 107*/
    field cod-cta-aplic-unif        as char     format "X(20)"
    field cod-ccusto-aplic-unif     as char     format "X(20)"
    field cod-cta-refugo-unif       as char     format "X(20)"
    field cod-ccusto-refugo-unif    as char     format "X(20)"
    /*fim altera‡äes projeto - 107*/
    field motivo-backflush          as integer  format ">9"
    field muda-status               as logical
    field nome-dir-etiq             as char     format "X(100)"
    field nr-trans                  as decimal  format ">>>>>>>>>9"
    field data                      as date
    field data-atualizacao          as date
    field detalhe                   as char     format "X(60)"
    field ep-codigo                 LIKE mguni.empresa.ep-codigo            
    field estado-trans              as integer  format ">9"
    field etiq-impressa             as logical
    field hora-atualizacao          as char     format "X(08)"
    field horario                   as char     format "X(08)"
    field log-1                     as logical
    field opcao                     as integer  format "99"     initial 1.
