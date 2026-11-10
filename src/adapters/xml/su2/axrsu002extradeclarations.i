{cdp/cd9043.i}
{cdp/cd9043.i1}

/* Variaveis */
DEF VAR h-boin274           AS HANDLE NO-UNDO.
DEF VAR h-boin274vl         AS HANDLE NO-UNDO.
DEF VAR h-boin274sd         AS HANDLE NO-UNDO.
DEF VAR h-boin295           AS HANDLE NO-UNDO.
DEF VAR h-boin356           AS HANDLE NO-UNDO.
DEF VAR h-boin356ca         AS HANDLE NO-UNDO.
DEF VAR h-boin356na         AS HANDLE NO-UNDO.
DEF VAR h-boin356vl         AS HANDLE NO-UNDO.
DEF VAR h-boin356q02        AS HANDLE NO-UNDO.
DEF VAR i-nro-rows          AS INT    NO-UNDO.
DEF VAR i-num-ordem         AS INT    NO-UNDO.
DEF VAR i-cont              AS INT    NO-UNDO.
DEF VAR l-manut-item-fornec AS LOG    NO-UNDO.
DEF VAR r-ordem-compra      AS ROWID  NO-UNDO.
DEF VAR r-ordem-ret         AS ROWID  NO-UNDO.

/* Variaveis p/ busca de defaults */
DEF VAR i-parcela     AS INT   NO-UNDO.
DEF VAR de-quantidade AS DEC   NO-UNDO.
DEF VAR c-un-aux      LIKE prazo-compra.un           NO-UNDO.
DEF VAR da-dt-entrega LIKE prazo-compra.data-entrega NO-UNDO.

DEF TEMP-TABLE ttErrors NO-UNDO LIKE RowErrors.
