/*************************************************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*************************************************************************************************************/
/*************************************************************************************************************
** Include: API012.I
** Objetivo: Defini‡Æo da temp-table do BCPAPI012.P
*************************************************************************************************************/

def temp-table tt_param NO-UNDO
    field   opcao           as integer     /* 1-Nr.Transacao, 2-Cod.Transacao, 3-String Detalhe, 4-Lista Tudo conforme sele‡Æo  */
    field   nr-transacao    as integer
    field   cd-transacao    as char
    field   detalhe         as char
    field   cd-trans-ini    as char     initial ""
    field   cd-trans-fim    as char     initial "ZZZZZZZZZZ"
    field   nr-trans-ini    as decimal  initial 0
    field   nr-trans-fim    as decimal  initial 9999999999
    field   data-ini        as date     initial 01/01/1901
    field   data-fim        as date     initial today
    field   hora-ini        as char     initial "00:00:00"
    field   hora-fim        as char     initial "99:99:00"
    field   usuario-ini     as char     initial ""
    field   usuario-fim     as char     initial "ZZZZZZZZZZZZ".

def temp-table tt_bc_trans NO-UNDO
    field   cd-trans            as char
    field   char-1              as char
    field   char-2              as char
    field   check-sum           as char
    field   conteudo-trans      as raw
    field   data                as date
    field   data-1              as date
    field   data-2              as date
    field   data-atualizacao    as date
    field   dec-1               as decimal
    field   dec-2               as decimal
    field   detalhe             as char
    field   ep-codigo           LIKE empresa.ep-codigo
    field   estado-trans        as integer
    field   etiq-impressa       as logical
    field   hora-atualizacao    as char
    field   horario             as char
    field   int-1               as integer
    field   int-2               as integer
    field   log-1               as logical
    field   log-2               as logical
    field   nr-trans            as decimal
    field   usuario             as char.
