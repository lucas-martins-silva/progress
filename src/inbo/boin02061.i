&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOTempTable
/*:T--------------------------------------------------------------------------
    Library    : dbott.i
    Purpose    : Include que contem definicao da temp-table RowObject.

    Notes      : Fonte do projeto AgEstoque.
  ------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

DEFINE TEMP-TABLE {1} NO-UNDO LIKE ag-estoque-analise
    FIELD r-Rowid AS ROWID.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK
/* ********************  Preprocessor Definitions  ******************** */
/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOTempTable
   Allow:
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOTempTable
/* ***************************  Main Block  *************************** */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
