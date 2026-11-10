&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : customHandler.p
    Purpose    : O Custom Handler ‚ um programa PROGRESS que tem por objetivo
                 disponibilizar para o usu rio uma maneira para poder realizar 
                 customiza‡äes nas informa‡äes que sÆo passadas para a o By You
                 e tamb‚m gerar os dados dos campos virtuais do Dataset.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/

    /* 
    Este parƒmetro foi adicionado para que exista a compatibilidade com a 
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
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 20.25
         WIDTH              = 37.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

/*
{method/dbo.i}
*/
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
              Esta procedure tem por objetivo ser executada APàS a sele‡Æo de
              TODOS os registros.
  Parameters: 
              ttDataset - Handle da temp-table ttDataset
  Notes:      
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER tableName AS CHARACTER.
    DEFINE INPUT-OUTPUT PARAMETER ttDataset AS HANDLE.
    
    DEFINE VARIABLE queryHandle     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE bufferHandle    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE contador        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE hTeste          AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hRecExpression  AS HANDLE      NO-UNDO.
    
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
    
    RUN prepareDatasetFields (INPUT-OUTPUT ttDataset).
    
    DEFINE VARIABLE hDSItem   AS HANDLE        NO-UNDO.
	DEFINE VARIABLE hDSExame  AS HANDLE        NO-UNDO.
	DEFINE VARIABLE hDSespec1   AS HANDLE      NO-UNDO.
	DEFINE VARIABLE hDSespec2   AS HANDLE      NO-UNDO.
	DEFINE VARIABLE hDSespec3   AS HANDLE      NO-UNDO.
	DEFINE VARIABLE hDSespec4   AS HANDLE      NO-UNDO.
	DEFINE VARIABLE hDSespec5   AS HANDLE      NO-UNDO.
	DEFINE VARIABLE hDSespec6   AS HANDLE      NO-UNDO.
	DEFINE VARIABLE h-boin164   AS HANDLE      NO-UNDO.
		
	define variable itCodigo  as character    no-undo.
	define variable codExame  as character    no-undo.
	DEFINE VARIABLE lespec1   AS logical      NO-UNDO.
	DEFINE VARIABLE lespec2   AS logical      NO-UNDO.
	DEFINE VARIABLE lespec3   AS logical      NO-UNDO.
	DEFINE VARIABLE lespec4   AS logical      NO-UNDO.
	DEFINE VARIABLE lespec5   AS logical      NO-UNDO.
	DEFINE VARIABLE lespec6   AS logical      NO-UNDO.
	
	
	hDSItem  = getDatasetFieldHandle("it-codigo").
	hDSExame = getDatasetFieldHandle("cod-exame").
	hDSespec1 = getDatasetFieldHandle("lespec1").
    hDSespec2 = getDatasetFieldHandle("lespec2").
    hDSespec3 = getDatasetFieldHandle("lespec3").
    hDSespec4 = getDatasetFieldHandle("lespec4"). 
    hDSespec5 = getDatasetFieldHandle("lespec5").
    hDSespec6 = getDatasetFieldHandle("lespec6").
	
	IF VALID-HANDLE(hDSItem) THEN itCodigo = hDSItem:BUFFER-VALUE.
	IF VALID-HANDLE(hDSExame)THEN codExame = string(hDSExame:BUFFER-VALUE).
		
	if itCodigo <> "" and codExame <> "" then do:
		run inbo/boin164.p persistent set h-boin164.
		run buscaTpInspecao in h-boin164 (input itCodigo,
										  input codExame,
										  OUTPUT lespec1,
										  OUTPUT lespec2,
										  OUTPUT lespec3,
										  OUTPUT lespec4,
										  OUTPUT lespec5,
										  OUTPUT lespec6).
	end.
												   
	  
    IF VALID-HANDLE(hDSespec1) THEN hDSespec1:BUFFER-VALUE = lespec1.
	IF VALID-HANDLE(hDSespec2) THEN hDSespec2:BUFFER-VALUE = lespec2.
	IF VALID-HANDLE(hDSespec3) THEN hDSespec3:BUFFER-VALUE = lespec3.
	IF VALID-HANDLE(hDSespec4) THEN hDSespec4:BUFFER-VALUE = lespec4.
	IF VALID-HANDLE(hDSespec5) THEN hDSespec5:BUFFER-VALUE = lespec5.
	IF VALID-HANDLE(hDSespec6) THEN hDSespec6:BUFFER-VALUE = lespec6.
	
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforePersistRecord DBOProgram 
PROCEDURE beforePersistRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  
              pType - Recebe o tipo de valida‡Æo (Create, Delete, Update).
              ttDataset - Handle da temp-table ttDataset
              RowObject - Handle da temp-table RowObject
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType            AS CHARACTER NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER ttDataset AS HANDLE.
    DEFINE INPUT-OUTPUT PARAMETER RowObject AS HANDLE.
    DEFINE INPUT PARAMETER hBoHandle        AS HANDLE NO-UNDO.
    
    /* captura os campos do Dataset */
    RUN prepareDatasetFields   (INPUT-OUTPUT ttDataset).
    RUN prepareRowObjectFields (INPUT-OUTPUT RowObject).
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
		
	DEFINE VARIABLE hDSItem   AS HANDLE        NO-UNDO.
	DEFINE VARIABLE hDSExame  AS HANDLE        NO-UNDO.
	DEFINE VARIABLE hDSespec1   AS HANDLE      NO-UNDO.
	DEFINE VARIABLE hDSespec2   AS HANDLE      NO-UNDO.
	DEFINE VARIABLE hDSespec3   AS HANDLE      NO-UNDO.
	DEFINE VARIABLE hDSespec4   AS HANDLE      NO-UNDO.
	DEFINE VARIABLE hDSespec5   AS HANDLE      NO-UNDO.
	DEFINE VARIABLE hDSespec6   AS HANDLE      NO-UNDO.
	DEFINE VARIABLE h-boin164   AS HANDLE      NO-UNDO.
		
	define variable itCodigo  as character    no-undo.
	define variable codExame  as character    no-undo.
	DEFINE VARIABLE lespec1   AS logical      NO-UNDO.
	DEFINE VARIABLE lespec2   AS logical      NO-UNDO.
	DEFINE VARIABLE lespec3   AS logical      NO-UNDO.
	DEFINE VARIABLE lespec4   AS logical      NO-UNDO.
	DEFINE VARIABLE lespec5   AS logical      NO-UNDO.
	DEFINE VARIABLE lespec6   AS logical      NO-UNDO.

	IF pType = "CREATE":U or pType = "UPDATE":U THEN DO:
		hDSItem  = getDatasetFieldHandle("it-codigo").
		hDSExame = getDatasetFieldHandle("cod-exame").
		hDSespec1 = getDatasetFieldHandle("lespec1").
        hDSespec2 = getDatasetFieldHandle("lespec2").
        hDSespec3 = getDatasetFieldHandle("lespec3").
        hDSespec4 = getDatasetFieldHandle("lespec4"). 
        hDSespec5 = getDatasetFieldHandle("lespec5").
        hDSespec6 = getDatasetFieldHandle("lespec6").
		
		
	    IF VALID-HANDLE(hDSItem) THEN itCodigo = hDSItem:BUFFER-VALUE.
	    IF VALID-HANDLE(hDSExame)THEN codExame = string(hDSExame:BUFFER-VALUE).
        IF VALID-HANDLE(hDSespec1)THEN lespec1 = hDSespec1:BUFFER-VALUE.
        IF VALID-HANDLE(hDSespec2)THEN lespec2 = hDSespec2:BUFFER-VALUE.
        IF VALID-HANDLE(hDSespec3)THEN lespec3 = hDSespec3:BUFFER-VALUE.
        IF VALID-HANDLE(hDSespec4)THEN lespec4 = hDSespec4:BUFFER-VALUE.
        IF VALID-HANDLE(hDSespec5)THEN lespec5 = hDSespec5:BUFFER-VALUE.
        IF VALID-HANDLE(hDSespec6)THEN lespec6 = hDSespec6:BUFFER-VALUE.   
					
        IF itCodigo <> "" AND codExame <> "" THEN DO:
    		run inbo/boin164.p persistent set h-boin164.
            run salvaTpInspecao in h-boin164 (input itCodigo,
                                              input codExame,
                                              INPUT lespec1,
                                              INPUT lespec2,
                                              INPUT lespec3,
                                              INPUT lespec4,
                                              INPUT lespec5,
                                              INPUT lespec6).
        END.
    END.
			
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareQuery DBOProgram 
PROCEDURE prepareQuery :
/*------------------------------------------------------------------------------
  Purpose:    
              Esta procedure tem por objetivo disponibilizar para o usu rio poder
              customizar a query.
  Parameters: 
              ttDataset - Handle da temp-table ttDataset
  Notes:      
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETER queryHandler AS HANDLE NO-UNDO.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

