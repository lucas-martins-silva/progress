&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : bcapi017.i
    Purpose     : Defini‡äes para bcapi017.p

    Description : temp-table tt-xml, tt-campos

    Author(s)   : Alcides Schulz
    Created     : Janeiro/2001
    Notes       : O campo sequencia deve ser o primeiro do indice
                  para ter sempre a mesma ordem em tt-xml, tt-campos e
                  bc-trans-filho.
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF TEMP-TABLE tt-xml NO-UNDO
    FIELD sequencia     AS INTEGER   FORM ">>>>9":U LABEL "Sequencia"
    FIELD segmento      AS INTEGER   FORM ">>>>9":U LABEL "Segmento"
    FIELD registro      AS INTEGER   FORM ">>>>9":U LABEL "Registro"
    FIELD conteudo      AS CHARACTER FORM "x(78)":U LABEL "Conteudo"
    INDEX ch-codigo IS PRIMARY UNIQUE sequencia segmento registro.

DEF TEMP-TABLE tt-tab-handle NO-UNDO
    FIELD tabela        AS CHARACTER
    FIELD tab-handle    AS HANDLE
    INDEX ch-codigo IS PRIMARY UNIQUE tabela.

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


