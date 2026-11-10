&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : ab0708.i4
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.75
         WIDTH              = 30.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
if this-procedure:persistent then
    return "OK":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piValidaBase) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaBase Procedure 
PROCEDURE piValidaBase :
/*------------------------------------------------------------------------------
  Purpose:     piValidaBase
  Parameters:  <none>
  Notes:       Verifica se existem na base MB as seguintes tabelas:
               1- empresa; 
               2- impressora; 
               3- procedimento; 
               4- funcao.
               Se as mesmas existirem, retorna um erro para o usu rio informando para o mesmo
               que deve-se alterar os nomes das tabelas e executar novamente o programa
------------------------------------------------------------------------------*/
define output parameter l-erro-empresa      as logical no-undo.
define output parameter l-erro-impressora   as logical no-undo.
define output parameter l-erro-procedimento as logical no-undo.
define output parameter l-erro-funcao       as logical no-undo.

if can-find (first mb._File
             where mb._File._File-Name = "empresa":U no-lock) then do:
    assign l-erro-empresa = yes.
end.
else do:
    assign l-erro-empresa = no.
end.

if can-find (first mb._File
             where mb._File._File-Name = "impressora":U no-lock) then do:
    assign l-erro-impressora = yes.
end.
else do:
    assign l-erro-impressora = no.
end.

if can-find (first mb._File
             where mb._File._File-Name = "procedimento":U no-lock) then do:
    assign l-erro-procedimento = yes.
end.
else do:
    assign l-erro-procedimento = no.
end.

if can-find (first mb._File
             where mb._File._File-Name = "funcao":U no-lock) then do:
    assign l-erro-funcao = yes.
end.
else do:
    assign l-erro-funcao = no.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

