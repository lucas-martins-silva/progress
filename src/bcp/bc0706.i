&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOTempTable 
/*:T--------------------------------------------------------------------------
    Library    : dbott.i
    Purpose    : Include que cont‚m defini‡Æo da temptable RowObject

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

DEFINE TEMP-TABLE tt-server-error NO-UNDO
    LIKE bc-servid-erro.

DEFINE TEMP-TABLE tt-var-equip NO-UNDO
    FIELD cod-servidor  AS CHARACTER    FORMAT "x(12)":U                    LABEL "Servidor OPC"
    FIELD cd-trans      AS CHARACTER    FORMAT "x(8)":U                     LABEL "Transacao"
    FIELD cod-eqpto     AS CHARACTER    FORMAT "x(12)":U                    LABEL "Equipamento"
    FIELD dt-geracao    AS DATE         FORMAT "99/99/9999"                 LABEL "Data Geracao"
    FIELD hr-geracao    AS CHARACTER    FORMAT "x(12)":U                    LABEL "Hora Geracao"
    FIELD cod-var-dtsul AS CHARACTER    FORMAT "x(1500)":U                  LABEL "Cod Variavel EMS"
    FIELD cod-var-eqpto AS CHARACTER    FORMAT "x(1500)":U                  Label "Cod Variavel Equip"
    FIELD valor         AS CHARACTER    FORMAT "x(1500)":U                  LABEL "Valor da Variavel"

    INDEX idMain AS PRIMARY UNIQUE
        cod-servidor
        cd-trans
        cod-eqpto
        cod-var-dtsul
        cod-var-eqpto.

DEFINE TEMP-TABLE tt-server-param NO-UNDO
    FIELD paramName  AS CHARACTER
    FIELD paramValue AS CHARACTER.

DEFINE VARIABLE lErrorFound AS LOGICAL    NO-UNDO
    INITIAL NO.

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
         HEIGHT             = 9.67
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOTempTable 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


