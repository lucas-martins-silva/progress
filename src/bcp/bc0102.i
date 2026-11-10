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

&GLOBAL-DEFINE ROW-NUM-DEFINED YES

/* Temp Table Definitions ---                                           */
DEFINE TEMP-TABLE ttRegEstr NO-UNDO
    FIELD numItem               AS INTEGER   FORMAT ">>>>9":U
    FIELD sequencia             AS INTEGER   FORMAT ">>>>9":U
    FIELD numLayoutRegistro     AS INTEGER   FORMAT ">>>>>9":U
    FIELD codTipoLayoutRegistro AS INTEGER   FORMAT ">>9":U
    FIELD indOcorrencia         AS INTEGER   FORMAT "9":U
    FIELD tipoItem              AS INTEGER   FORMAT ">9":U
    FIELD valorItem             AS CHARACTER FORMAT "x(100)":U
    FIELD tipoDado              AS CHARACTER FORMAT "x(30)":U
    FIELD formato               AS CHARACTER FORMAT "x(30)":U
    FIELD posInicial            AS INTEGER   FORMAT ">>9":U
    FIELD numDecimais           AS INTEGER   FORMAT ">9":U
    FIELD idInicial             AS CHAR      FORMAT "x(20)":U
    FIELD idFinal               AS CHAR      FORMAT "x(20)":U
    FIELD DesLabel              AS CHAR      FORMAT "x(100)":U
    FIELD ValorCampo            AS CHAR      FORMAT "x(100)":U
    FIELD Detalhamento          AS CHAR      FORMAT "x(150)":U
    INDEX chEstr IS UNIQUE PRIMARY
          numItem
    INDEX chLayout numLayoutRegistro.

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


