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
    FIELD it-codigo LIKE item.it-codigo
    FIELD desc-item LIKE item.desc-item
    FIELD un LIKE item.un
    FIELD fm-codigo LIKE item.fm-codigo
    FIELD ge-codigo LIKE item.ge-codigo
    FIELD cod-obsoleto LIKE item.cod-obsoleto
    FIELD compr-fabric LIKE item.compr-fabric
    FIELD deposito-pad LIKE item.deposito-pad
    FIELD cod-localiz LIKE item.cod-localiz
    FIELD cod-estabel LIKE item.cod-estabel
    FIELD codigo-refer LIKE item.codigo-refer
    FIELD inform-compl LIKE item.inform-compl
    FIELD cd-planejado LIKE item.cd-planejado
    FIELD cod-comprado LIKE item.cod-comprado
    FIELD narrativa LIKE item.narrativa
    FIELD tipo-con-est LIKE item.tipo-con-est
    FIELD r-Rowid AS ROWID.

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
*/

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOTempTable

/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
