/* axrsu003ExtraDeclarations.i -> declara‡Æo de variaveis do adapter AXRSU003 */

/* Include da API de Efetiva‡Æo */
{ocp/ocapi002.i}

DEFINE TEMP-TABLE ttLote NO-UNDO
     FIELD nr-lote AS CHARACTER
     FIELD ttQuotationLineID AS INTEGER.

DEFINE TEMP-TABLE ttLoteOrdem NO-UNDO
     FIELD nr-lote AS CHARACTER
     FIELD numero-ordem LIKE ordem-compra.numero-ordem
     FIELD ttQuotationLineID AS INTEGER.

DEFINE TEMP-TABLE ttRowErrorsAux LIKE RowErrors.
DEFINE BUFFER bttQuotationLine FOR ttQuotationLine.
DEFINE VARIABLE lAgrupaLote  AS LOGICAL   INITIAL NO      NO-UNDO.
DEFINE VARIABLE iNumeroOrdem AS INTEGER                   NO-UNDO.
DEFINE VARIABLE iLote        AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE iErrorSequence AS INTEGER NO-UNDO.

DEFINE TEMP-TABLE tt-proc-compra  LIKE proc-compra
    FIELD r-rowid AS ROWID.

DEFINE VARIABLE h-boin358   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin274vl AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin359   AS HANDLE      NO-UNDO.

DEF VAR l-tipo-erro-encontrado AS LOG INITIAL NO NO-UNDO.
