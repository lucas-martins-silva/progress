&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 

{include/i-prgvrs.i boin01050 2.00.00.001 } /* 27/10/2023 17:03:40 */

{include/i-epc200.i boin01050}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin01050 MCP}
&ENDIF
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName boin01050
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName pend-apont
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin01050.i RowObject}

/* Filtro */
DEFINE VARIABLE dt-dat-envio-ini AS DATE      NO-UNDO.
DEFINE VARIABLE dt-dat-envio-fim AS DATE      NO-UNDO.
DEFINE VARIABLE i-idi-pend-ini   AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-idi-pend-fim   AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-idi-tip-status AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-nr-ord-ini     AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-nr-ord-fim     AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-usuario-ini    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-usuario-fim    AS CHARACTER NO-UNDO.

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


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
         HEIGHT             = 2
         WIDTH              = 40.
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

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


DEFINE TEMP-TABLE rowErrorsAux NO-UNDO LIKE rowErrors.

/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram  
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-ctrab":U THEN ASSIGN pFieldValue = RowObject.cod-ctrab.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "lote-serie":U THEN ASSIGN pFieldValue = RowObject.lote-serie.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "hra-inic-reporte":U THEN ASSIGN pFieldValue = RowObject.hra-inic-reporte.
        WHEN "hra-fim-reporte":U THEN ASSIGN pFieldValue = RowObject.hra-fim-reporte.
        WHEN "usuar-resp":U THEN ASSIGN pFieldValue = RowObject.usuar-resp.
        WHEN "cod-equipe":U THEN ASSIGN pFieldValue = RowObject.cod-equipe.
        WHEN "cod-operador":U THEN ASSIGN pFieldValue = RowObject.cod-operador.
        WHEN "hra-pend":U THEN ASSIGN pFieldValue = RowObject.hra-pend.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram  
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-valid-lote":U   THEN ASSIGN pFieldValue = RowObject.dat-valid-lote.
        WHEN "dat-inic-reporte":U THEN ASSIGN pFieldValue = RowObject.dat-inic-reporte.
        WHEN "dat-fim-reporte":U  THEN ASSIGN pFieldValue = RowObject.dat-fim-reporte.
        WHEN "dat-pend":U         THEN ASSIGN pFieldValue = RowObject.dat-pend.
        WHEN "dat-livre-1":U      THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U      THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram  
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "qt-produzida":U THEN ASSIGN pFieldValue = RowObject.qt-produzida.
        WHEN "qt-refugada":U  THEN ASSIGN pFieldValue = RowObject.qt-refugada.
        WHEN "val-livre-1":U  THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U  THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram  
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "idi-pend-apont":U THEN ASSIGN pFieldValue = RowObject.idi-pend-apont.
        WHEN "idi-status-pend":U THEN ASSIGN pFieldValue = RowObject.idi-status-pend.
        WHEN "idi-origem-pend":U THEN ASSIGN pFieldValue = RowObject.idi-origem-pend.
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "num-operac-sfc":U THEN ASSIGN pFieldValue = RowObject.num-operac-sfc.
        WHEN "num-split-operac":U THEN ASSIGN pFieldValue = RowObject.num-split-operac.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice pndcntgr-id2
  Parameters:  
               retorna valor do campo num-id-pend-apont
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pidi-pend-apont LIKE pend-apont.idi-pend-apont NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pidi-pend-apont = RowObject.idi-pend-apont.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram  
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram  
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram  
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice pndcntgr-id2
  Parameters:  
               recebe valor do campo num-id-pend-apont
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pidi-pend-apont LIKE pend-apont.idi-pend-apont NO-UNDO.

    FIND FIRST bfpend-apont WHERE 
        bfpend-apont.idi-pend-apont = pidi-pend-apont NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpend-apont THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpend-apont)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltro DBOProgram
PROCEDURE openQueryFiltro:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

    IF i-idi-tip-status = 0 THEN /* TODOS */    
        OPEN QUERY {&QueryName} 
          FOR EACH {&TableName} NO-LOCK
             WHERE {&TableName}.dat-pend        >= date(dt-dat-envio-ini)
               AND {&TableName}.dat-pend        <= date(dt-dat-envio-fim)                        
               AND {&TableName}.idi-pend-apont  >= i-idi-pend-ini
               AND {&TableName}.idi-pend-apont  <= i-idi-pend-fim
               AND {&TableName}.nr-ord-produ    >= i-nr-ord-ini
               AND {&TableName}.nr-ord-produ    <= i-nr-ord-fim
               AND {&TableName}.usuar-resp      >= c-usuario-ini
               AND {&TableName}.usuar-resp      <= c-usuario-fim
                BY {&TableName}.idi-pend-apont. 
    ELSE 
        OPEN QUERY {&QueryName} 
          FOR EACH {&TableName} NO-LOCK
             WHERE {&TableName}.dat-pend       >= date(dt-dat-envio-ini)
               AND {&TableName}.dat-pend       <= date(dt-dat-envio-fim)
               AND {&TableName}.idi-pend-apont >= i-idi-pend-ini
               AND {&TableName}.idi-pend-apont <= i-idi-pend-fim
               AND {&TableName}.nr-ord-produ   >= i-nr-ord-ini
               AND {&TableName}.nr-ord-produ   <= i-nr-ord-fim
               AND {&TableName}.usuar-resp     >= c-usuario-ini
               AND {&TableName}.usuar-resp     <= c-usuario-fim   
               AND {&TableName}.idi-status-pend = i-idi-tip-status
                BY {&TableName}.idi-pend-apont.     

    RETURN "OK":U.

END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram
PROCEDURE openQueryMain:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U. 

END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltro DBOProgram
PROCEDURE setConstraintFiltro:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdt-dat-envio-ini AS DATE      NO-UNDO.
    DEFINE INPUT PARAMETER pdt-dat-envio-fim AS DATE      NO-UNDO.
    DEFINE INPUT PARAMETER pidi-pend-ini     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pidi-pend-fim     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pidi-tip-status   AS INTEGER   NO-UNDO.  
    DEFINE INPUT PARAMETER pc-usuario-ini    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-usuario-fim    AS CHARACTER NO-UNDO.	
    DEFINE INPUT PARAMETER pi-nr-ord-ini     AS INTEGER   NO-UNDO.	
    DEFINE INPUT PARAMETER pi-nr-ord-fim     AS INTEGER   NO-UNDO.  
      
    ASSIGN dt-dat-envio-ini  = pdt-dat-envio-ini
           dt-dat-envio-fim  = pdt-dat-envio-fim
           i-idi-pend-ini    = pidi-pend-ini 
           i-idi-pend-fim    = pidi-pend-fim 
           i-idi-tip-status  = pidi-tip-status
		   c-usuario-ini     = pc-usuario-ini
		   c-usuario-fim     = pc-usuario-fim
           i-nr-ord-ini      = pi-nr-ord-ini
           i-nr-ord-fim      = pi-nr-ord-fim.
          
    RETURN "OK":U.
    
END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram
PROCEDURE setConstraintMain:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

    RETURN "OK":U.

END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

