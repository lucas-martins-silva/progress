&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : BC1003.I
    Purpose     : Fun‡Æo para Formatar o c¢digo do layout para mostrar
                  ao usu rio

    Syntax      : formataCodLayout (cod-layout, log-datasul, num-versao)

    Description : Retorna uma String com a chave do layout

    Author(s)   : Alcides Schulz
    Created     : Janeiro/2001
    Notes       : 
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD formataCodLayout Include 
FUNCTION formataCodLayout RETURNS CHARACTER
  ( p-cod-layout AS INTEGER, p-log-datasul AS LOGICAL, p-num-versao AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION formataCodLayout Include 
FUNCTION formataCodLayout RETURNS CHARACTER
  ( p-cod-layout AS INTEGER, p-log-datasul AS LOGICAL, p-num-versao AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  retorna o c¢digo do layout formatado para display
    Notes:  
------------------------------------------------------------------------------*/
    DEF VAR p-formatado     AS CHARACTER NO-UNDO.
    
    {utp/ut-liter.i "Datasul/Usu rio"}
    p-formatado = STRING(p-cod-layout)
                + "/":U 
                + STRING(p-log-datasul, TRIM(RETURN-VALUE))
                + "/":U
                + STRING(p-num-versao).
    RETURN p-formatado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

