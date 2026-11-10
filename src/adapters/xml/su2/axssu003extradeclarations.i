DEFINE VARIABLE cEvent       AS CHARACTER INITIAL ?       NO-UNDO.
DEFINE VARIABLE cTranAction  AS CHARACTER INITIAL ?       NO-UNDO.
DEFINE VARIABLE iQuoteLine   AS INTEGER   INITIAL 0       NO-UNDO.
DEFINE VARIABLE iExtraInfo   AS INTEGER   INITIAL 0       NO-UNDO.
DEFINE VARIABLE lSameProcess AS LOGICAL   INITIAL FALSE   NO-UNDO.
DEFINE VARIABLE iLastProcess LIKE proc-compra.nr-processo NO-UNDO.
DEFINE VARIABLE lAgrupaLote  AS LOGICAL   INITIAL NO      NO-UNDO.
DEFINE VARIABLE iDeliveryID  AS INTEGER   INITIAL 0       NO-UNDO.
DEFINE VARIABLE lBBM         AS LOGICAL   INITIAL NO      NO-UNDO.

DEFINE TEMP-TABLE ttQuotation NO-UNDO
     FIELD rw-cotacao-item AS ROWID.

DEFINE TEMP-TABLE ttLote NO-UNDO
     FIELD nr-lote AS CHARACTER
     FIELD ttQuotationLineID AS INTEGER.

DEFINE TEMP-TABLE ttLoteOrdem NO-UNDO
     FIELD nr-lote AS CHARACTER
     FIELD numero-ordem LIKE ordem-compra.numero-ordem
     FIELD ttQuotationLineID AS INTEGER.

DEFINE BUFFER bttQuotationLine FOR ttQuotationLine.
DEFINE BUFFER bttDeliveryScheduleInforma_00 FOR ttDeliveryScheduleInforma_00.
DEFINE BUFFER bttExtraInformation FOR ttExtraInformation.
DEFINE TEMP-TABLE ttQuotationLineAux NO-UNDO LIKE ttQuotationLine.

{cdp/cdcfgmat.i}

