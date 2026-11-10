/*
**  BOAD098a.i3
**
**  Defini‡Æo das temp-tables necess rias ao detalhe
**  de contas a pagar/contas a receber
**
**  Ultima altera‡Æo : 02/07/99 - bre18759
*/

def temp-table tt-cta-pagar-rec no-undo
  field da-maior       as date    init ?
  field de-vl-maior    as decimal init 0
  field da-ultimo      as date    init 01/01/1901
  field de-vl-ultimo   as decimal init 0
  field i-atraso-medio as int     init 0
  field r-rowid        as rowid.
