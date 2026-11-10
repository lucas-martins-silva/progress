&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : bc1000.i
    Purpose     : Procedimento geraTTErro

    Syntax      : {cdp/cd0666.i}
                  {bcp/bc1000.i &local=<localizador do erro>}

    Description : Cont‚m a procedure padrÆo para gera‡Æo de mensagens
                  em tt-erro.

    Author(s)   : Alcides Schulz
    Created     : Janeiro/20001
    Notes       : O preprocessador &local ‚ acrescentado a mensagem
                  para indicar onde foi gerado o erro (normalmente o nome
                  do programa).
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


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraTTErro Include 
PROCEDURE geraTTErro :
/*------------------------------------------------------------------------------
  Purpose:     Gera a mensagem de erro em tt-erro
  Parameters:  num-mensagem, parametros, complemento
  Notes:       Complementa a mensagem com o nome do programa sendo executado
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-numero        AS INTEGER   NO-UNDO.
    DEF INPUT PARAM p-parametros    AS CHARACTER NO-UNDO.
    DEF INPUT PARAM p-complemento   AS CHARACTER NO-UNDO.

    DEF VAR v-seq-erro              AS INTEGER NO-UNDO.
    
    FIND LAST tt-erro NO-ERROR.
    IF  AVAIL tt-erro THEN
        v-seq-erro = tt-erro.i-sequen.
    
    RUN utp/ut-msgs.p ("msg":U, p-numero, p-parametros).
    CREATE tt-erro.
    ASSIGN v-seq-erro       = v-seq-erro + 1
           tt-erro.i-sequen = v-seq-erro
           tt-erro.cd-erro  = p-numero
           tt-erro.mensagem = RETURN-VALUE
                            + (IF p-complemento <> "":u THEN ": " + p-complemento ELSE "":U)
&IF "{&local}" <> "" &THEN
                            + " ({&local})":U.
&ENDIF
                            .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

