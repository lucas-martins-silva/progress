&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : bcapi019.i
    Purpose     : Defini‡Æo da temp-table tt-campos

    Author(s)   : Alcides Schulz
    Created     : Janeiro/2001
    Notes       : O campo sequencia deve ser sempre o primeiro do indice
                  para ter a mesma ordem que tt-xml e bc-trans-filho
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/*     temptable da api 017 foi retirada para nÆo dar conflito  
       DEF TEMP-TABLE tt-campos NO-UNDO                                 */
/*     FIELD sequencia     AS INTEGER   FORM ">>>>9":U LABEL "Sequencia" */
/*     FIELD segmento      AS INTEGER   FORM ">>>>9":U LABEL "Segmento"  */
/*     FIELD registro      AS INTEGER   FORM ">>>>9":U LABEL "Registro"  */
/*     FIELD campo         AS CHARACTER FORM "x(30)":U LABEL "Campo"     */
/*     FIELD valor         AS CHARACTER FORM "x(30)":U LABEL "Valor"     */
/*     INDEX ch-tt-campos IS PRIMARY sequencia segmento registro campo   */
/*     INDEX ch-layout-registro segmento registro.                       */

DEF TEMP-TABLE tt-campos NO-UNDO
    FIELD sequencia     AS INTEGER   FORM ">>>>9":U COLUMN-LABEL "Sequencia"
    FIELD segmento      AS INTEGER   FORM ">>>>9":U COLUMN-LABEL "Segmento"
    FIELD registro      AS INTEGER   FORM ">>>>9":U COLUMN-LABEL "Registro"
    FIELD campo         AS CHARACTER FORM "x(30)":U COLUMN-LABEL "Campo"
    FIELD valor         AS CHARACTER FORM "x(100)":U COLUMN-LABEL "Valor"
    FIELD num-decimal   AS INTEGER   FORM ">>>>9":U COLUMN-LABEL "Num Decimal"
    INDEX ch-tt-campos IS PRIMARY sequencia segmento registro campo
    INDEX ch-layout-registro segmento registro.

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
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


