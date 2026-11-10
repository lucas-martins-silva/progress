/*
**  BOAD180.I
**
**  mov-ap - Movimentação dos Documentos (Contas a Pagar)
**
**  Ultima altera‡Æo : 23/05/200 -Anderson Nass
*/

DEFINE TEMP-TABLE {1} no-undo like mov-ap
    field r-rowid            as rowid
    field c-transacao      like mov-ap.transacao
    field c-lancamento     like mov-ap.lancamento
    field c-modalidade       as char format "x(15)"
    field i-nr-bordero     like mov-ap.nr-bordero
    field c-origem           as char format "x(20)"
    field de-vl-juros-neg    as decimal format "->,>>>,>>9.99"
    field de-vl-juros-me-neg as decimal format "->,>>>,>>9.99".
 
