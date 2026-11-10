&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : customHandler.p
    Purpose    : O Custom Handler e um programa PROGRESS que tem por objetivo
                 disponibilizar para o usuario uma maneira para poder realizar 
                 customizacoes nas informacoes que sao passadas para a o By You
                 e tambem gerar os dados dos campos virtuais do Dataset.
    Parameters :
    Notes      : 
  ------------------------------------------------------------------------*/
    /* %73%69%6D%6F%6E%00 */
    /* 
    Este parametro foi adicionado para que exista a compatibilidade com a 
    forma antiga de desenvolver os Query Handlers. A tratativa referente 
    ao QueryHandler deve ser feita dentro da procedure prepareQuery
    
*/
    DEFINE INPUT-OUTPUT PARAMETER queryHandler AS HANDLE NO-UNDO.

RETURN "OK":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW

&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */
{java/datasetHandler.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 
/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterAllSelectedRecords DBOProgram 
PROCEDURE afterAllSelectedRecords :
/*------------------------------------------------------------------------------
  Purpose:    
              Esta procedure tem por objetivo ser executada Apos a selecao de
              TODOS os registros.
  Parameters: 
ttDataset - Handle da temp-tablettDataset
Notes:      
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER tableName AS CHARACTER.
DEFINE INPUT-OUTPUT PARAMETER ttDataset AS HANDLE.

    DEFINE VARIABLE queryHandle     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE bufferHandle    AS HANDLE      NO-UNDO.


    CREATE QUERY queryHandle.
ASSIGN bufferHandle = ttDataset:DEFAULT-BUFFER-HANDLE.
	
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSelectedRecord DBOProgram 
PROCEDURE afterSelectedRecord :
/*------------------------------------------------------------------------------
  Purpose:    
              Esta procedure tem por objetivo ser executada A CADA registro 
encontrado.
  Parameters: 
              ttDataset - Handle da temp-table ttDataset
  Notes:      
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER tableName AS CHARACTER.
    DEFINE INPUT-OUTPUT PARAMETER ttDataset AS HANDLE.
    
    DEFINE VARIABLE i-cod-emitente AS INTEGER NO-UNDO.
    
    DEFINE VARIABLE hDScodEmitente AS HANDLE NO-UNDO.
    DEFINE VARIABLE hDScgc         AS HANDLE NO-UNDO.
    DEFINE VARIABLE hDScodGrCli    AS HANDLE NO-UNDO.
    DEFINE VARIABLE hDScodGrForn   AS HANDLE NO-UNDO.
    DEFINE VARIABLE hDSnomeMatriz  AS HANDLE NO-UNDO.
    DEFINE VARIABLE hDSnomeAbrev   AS HANDLE NO-UNDO.
    DEFINE VARIABLE hDSnome        AS HANDLE NO-UNDO.
    DEFINE VARIABLE hDSidentific   AS HANDLE NO-UNDO.
        
    hDScodEmitente = getDatasetFieldHandle("cod-emitente").
    IF VALID-HANDLE(hDScodEmitente) THEN DO:
        i-cod-emitente = integer(hDScodEmitente:BUFFER-VALUE).
    END.
    
    IF tableName <> "mgind.item-fornec" THEN DO:
        RETURN "OK":U.
    END.

    RUN prepareDatasetFields (INPUT-OUTPUT ttDataset).
    
    FOR FIRST emitente FIELDS(cod-emitente cgc cod-gr-cli cod-gr-forn nome-matriz nome-abrev nome-emit identific)
        WHERE emitente.cod-emitente = i-cod-emitente NO-LOCK:

        hDScodEmitente = getDatasetFieldHandle("codEmitente").
        IF VALID-HANDLE(hDScodEmitente) THEN DO:
            hDScodEmitente:BUFFER-VALUE = emitente.cod-emitente.
        END.
        
        hDScgc = getDatasetFieldHandle("cgc").
        IF VALID-HANDLE(hDScgc) THEN DO:
            hDScgc:BUFFER-VALUE = emitente.cgc.
        END.

        hDScodGrCli = getDatasetFieldHandle("codGrCli").
        IF VALID-HANDLE(hDScodGrCli) THEN DO:
            hDScodGrCli:BUFFER-VALUE = string(emitente.cod-gr-cli).
        END.

        hDScodGrForn = getDatasetFieldHandle("codGrForn").
        IF VALID-HANDLE(hDScodGrForn) THEN DO:
            hDScodGrForn:BUFFER-VALUE = string(emitente.cod-gr-forn).
        END.

        hDSnomeMatriz = getDatasetFieldHandle("nomeMatriz").
        IF VALID-HANDLE(hDSnomeMatriz) THEN DO:
            hDSnomeMatriz:BUFFER-VALUE = emitente.nome-matriz.
        END.

        hDSnomeAbrev = getDatasetFieldHandle("nomeAbrev").
        IF VALID-HANDLE(hDSnomeAbrev) THEN DO:
            hDSnomeAbrev:BUFFER-VALUE = emitente.nome-abrev.
        END.

        hDSnome = getDatasetFieldHandle("nome").
        IF VALID-HANDLE(hDSnome) THEN DO:
            hDSnome:BUFFER-VALUE = emitente.nome-emit.
        END.

        hDSidentific = getDatasetFieldHandle("identific").
        IF VALID-HANDLE(hDSidentific) THEN DO:
            hDSidentific:BUFFER-VALUE = emitente.identific.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforePersistRecord DBOProgram 
PROCEDURE beforePersistRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validacoes pertinentes ao DBO
  Parameters:  
              pType - Recebe o tipo de validacao (Create, Delete, Update).
ttDataset - Handle da temp-table ttDataset
              RowObject - Handle da temp-table RowObject
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER ttDataset AS HANDLE.
    DEFINE INPUT-OUTPUT PARAMETER RowObject AS HANDLE.
    DEFINE INPUT PARAMETER hBoHandle AS HANDLE NO-UNDO.

/* captura os campos do Dataset */
RUN prepareDatasetFields   (INPUT-OUTPUT ttDataset).
RUN prepareRowObjectFields (INPUT-OUTPUT RowObject).

/*:T--- Utilize o parametro pType para identificar quais as validacoes a serem
          executadas ---*/
    /*:T--- Os valores possiveis para o parametro sao: Create, Delete e Update ---*/


/*IF pType = "CREATE":U THEN DO:        

    END.*/	

    /*IF pType = "UPDATE":U THEN DO:        

    END.*/	

    /*IF pType = "DELETE":U THEN DO:        

    END.*/	

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareQuery DBOProgram 
PROCEDURE prepareQuery :
/*------------------------------------------------------------------------------
  Purpose:    
              Esta procedure tem por objetivo disponibilizar para o usuario poder
customizar a query.
  Parameters: 
              ttDataset - Handle da temp-table ttDataset
  Notes:      
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER queryHandle AS HANDLE NO-UNDO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
