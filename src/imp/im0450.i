&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : imp/im0450.i
    Description : Defini‡Æo da tabela tt-param
    Author(s)   : TOTVS S.A.
    Created     : 29.08.2011
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE TEMP-TABLE tt-param NO-UNDO 
    FIELD destino          AS   INTEGER
    FIELD arquivo          AS   CHAR FORMAT "x(35)":U
    FIELD arq-entrada      AS   CHAR FORMAT "x(35)":U
    FIELD arq-destino      AS   CHAR FORMAT "x(35)":U
    FIELD usuario          AS   CHAR FORMAT "x(12)":U
    FIELD nome-usuario     AS   CHAR FORMAT "x(40)":U
    FIELD data-exec        AS   DATE
    FIELD hora-exec        AS   INTEGER
    FIELD num-di-ems       LIKE decla-import.num-di-ems
    FIELD banco-access     AS   CHAR FORMAT "x(60)":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 29.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


