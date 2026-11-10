{include/CallFlex.i}
{include/i-prgvrs.i AFCDP9070 2.00.00.000}

/* Define as variaveis necessarias para chamar o Zoom do Progress */
def var p-nr-ord-produ LIKE ord-prod.nr-ord-produ no-undo.

DEF NEW GLOBAL SHARED VAR gr-ord-prod AS rowid NO-UNDO.

find ord-prod
    where ord-prod.nr-ord-produ = int(zParams)
    no-lock no-error.
if  avail ord-prod then
    assign gr-ord-prod = ROWID(ord-prod).

run value("cdp/cd9070.p").
/* fim */
