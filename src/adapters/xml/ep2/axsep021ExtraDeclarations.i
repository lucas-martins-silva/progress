DEFINE BUFFER b-unid-feder-est FOR unid-feder.
DEFINE BUFFER b-cidade-est     FOR cidade.
DEFINE BUFFER b-emitente       FOR emitente.


DEF VAR c-dia        AS CHAR        NO-UNDO.
DEF VAR c-mes        AS CHAR        NO-UNDO.
DEF VAR c-ano        AS CHAR        NO-UNDO.
DEF VAR c-hora       AS CHAR        NO-UNDO FORMAT "x(15)".
DEF VAR da-tz        AS DATETIME-TZ NO-UNDO.
DEF VAR i-cont-nfe   AS INTEGER     NO-UNDO.
DEF VAR i-cont-nf    AS INTEGER     NO-UNDO.




DEFINE VARIABLE lcXMLMDFe AS LONGCHAR NO-UNDO.
DEFINE VARIABLE lObtemXMLMDFe AS LOGICAL  NO-UNDO.

DEFINE VARIABLE de-valor-carga AS DECIMAL FORMAT ">>>>>>>>>>>>9.99" NO-UNDO.
DEFINE VARIABLE de-peso-carga  AS DECIMAL FORMAT ">>>>>>>>>>9.9999" NO-UNDO.


DEF VAR l-integr-totvs-colab AS LOGICAL NO-UNDO.
