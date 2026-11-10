/************************************************************************
***
***  app/ap1002p.i - Defini‡Æo de Variaveis Locais.
***
************************************************************************/

def var i-cont        as integer no-undo.
def var i-aux         as integer init 0 no-undo.
def var i-erro        as integer init 0 no-undo.
def var i-qte-erro    as integer init 0 no-undo.
def var l-data-cons   as logical init no no-undo.
def var da-ta-cons-ini as date format "99/99/9999" no-undo.
def var da-ta-cons-fim as date format "99/99/9999" no-undo.
def var id-lote        as char format "x(15)" no-undo.
def var c-message      as char format "x(40)" no-undo.
def var c-numero       like tit-ap.titulo-banco format "x(15)" no-undo.
def var c-numero-banco like tit-ap.titulo-banco format "x(15)" no-undo.
def var i-cod-trans    as int format "99" no-undo.
def var h-acomp        as handle  no-undo.

/* Fim de Include */

