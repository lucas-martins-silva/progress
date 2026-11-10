&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : api-ab0708h.i
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{include/i_dbtype.i}  /** Define o tipo de banco de dados **/
{abp/ab0708.i1} /** tt-param **/

DEFINE VARIABLE c-campos AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-tam    AS CHARACTER  NO-UNDO.

define input parameter table for tt-param.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piGeraCabecalho) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraCabecalho Procedure 
PROCEDURE piGeraCabecalho :
/*------------------------------------------------------------------------------
  Purpose:     piGeraCabecalho
  Parameters:  c-dump = dump-name da tabela em quest∆o
  Notes:       Gerar cabeáalho (contento os campos da tabela) no arquivo exportado.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER c-dump AS CHARACTER  NO-UNDO.

find first tt-param no-lock no-error.

ASSIGN c-campos = "".
    
IF tt-param.gera-cabecalho = NO THEN RETURN "OK":U.

&IF "{&ems_dbtype}":U <> "PROGRESS":U &THEN 
    FOR FIRST shmgfro._file
        WHERE shmgfro._file._dump-name = c-dump 
        AND   shmgfro._file._hidden    = NO NO-LOCK:
        FOR EACH  shmgfro._field 
            WHERE shmgfro._field._file-recid = recid(shmgfro._file) NO-LOCK 
            BY   shmgfro._field._order:
            IF shmgfro._field._label = 'Livre 1':U OR 
               shmgfro._field._label = 'Livre 2':U THEN DO:
                ASSIGN c-campos = c-campos + ";" + trim(shmgfro._field._field-name).
            END.
            ELSE 
                IF c-campos = "" THEN
                    ASSIGN c-campos = trim(shmgfro._field._label).
                ELSE 
                    ASSIGN c-campos = c-campos + ";" + trim(shmgfro._field._label).
        END.
        ASSIGN c-tam = "x(" + string(length(c-campos)) + ")".
    END.
&ELSE 
    FOR FIRST mgfro._file
        WHERE mgfro._file._dump-name = c-dump 
        AND   mgfro._file._hidden    = NO NO-LOCK:
        FOR EACH  mgfro._field 
            WHERE mgfro._field._file-recid = recid(mgfro._file) NO-LOCK 
            BY   mgfro._field._order:
            IF mgfro._field._label = 'Livre 1':U OR 
               mgfro._field._label = 'Livre 2':U THEN DO:
                ASSIGN c-campos = c-campos + ";" + trim(mgfro._field._field-name).
            END.
            ELSE 
                IF c-campos = "" THEN
                    ASSIGN c-campos = trim(mgfro._field._label).
                ELSE 
                    ASSIGN c-campos = c-campos + ";" + trim(mgfro._field._label).
        END.
        ASSIGN c-tam = "x(" + string(length(c-campos)) + ")".
    END.
&ENDIF

PUT c-campos FORMAT c-tam.
PUT SKIP.

RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

