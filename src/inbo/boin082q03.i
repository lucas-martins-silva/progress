
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOTempTable
/*--------------------------------------------------------------------------
    Library    : dbott.i
    Purpose    : Include que cont‚m defini‡Æo da temptable RowObject

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

DEFINE TEMP-TABLE {1} NO-UNDO 
    FIELD numero-ordem LIKE ordem-compra.numero-ordem
    FIELD situacao     LIKE ordem-compra.situacao
    FIELD data-cotacao LIKE cotacao-item.data-cotacao
    FIElD cod-emitente LIKE cotacao-item.cod-emitente
    FIELD seq-cotac    LIKE cotacao-item.seq-cotac
    FIELD nome-abrev   LIKE emitente.nome-abrev
    FIELD desc-item    LIKE item.desc-item
    FIELD narr-item    LIKE item.narrativa
    FIELD narr-ordem   LIKE ordem-compra.narrativa
    FIELD narrativa    LIKE cotacao-item.narrativa
    FIELD it-codigo    LIKE cotacao-item.it-codigo
    FIELD preco-fornec LIKE cotacao-item.preco-fornec
    FIELD pre-unit-for LIKE cotacao-item.pre-unit-for
    FIELD preco-unit   LIKE cotacao-item.preco-unit
    FIELD valor-descto LIKE cotacao-item.valor-descto
    FIELD valor-frete  LIKE cotacao-item.valor-frete
    FIELD codigo-ipi   LIKE cotacao-item.codigo-ipi
    FIELD aliquota-ipi LIKE cotacao-item.aliquota-ipi
    FIELD r-item       AS ROWID
    FIELD r-rowid      AS ROWID
    FIELD r-ordem      AS ROWID.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOTempTable
   Allow:
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB)
  CREATE WINDOW DBOTempTable ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */

&ANALYZE-RESUME
