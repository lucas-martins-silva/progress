&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

{include/i-prgvrs.i BOAD00597 2.00.00.002 } /*** "010002" 28/11/2023 09:56:23  ***/

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOAD00597
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName internac-col
&GLOBAL-DEFINE TableLabel Colìnias
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com definiá∆o da temptable RowObject ---*/
{adbo/boad00597.i RowObject}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
{method/dboqry.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF VAR c-col-ini    LIKE {&TableName}.cod-col NO-UNDO.
DEF VAR c-col-fim    LIKE {&TableName}.cod-col NO-UNDO.
DEF VAR c-nome-ini   LIKE {&TableName}.nom-col NO-UNDO.
DEF VAR c-nome-fim   LIKE {&TableName}.nom-col NO-UNDO.
DEF VAR c-fisc-ini   LIKE {&TableName}.cod-fisc   NO-UNDO.
DEF VAR c-fisc-fim   LIKE {&TableName}.cod-fisc   NO-UNDO.
DEF VAR c-postal-ini LIKE {&TableName}.cod-postal NO-UNDO.
DEF VAR c-postal-fim LIKE {&TableName}.cod-postal NO-UNDO.

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
         HEIGHT             = 13.75
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-col":U THEN ASSIGN pFieldValue = RowObject.cod-col.
        WHEN "cod-fisc":U THEN ASSIGN pFieldValue = RowObject.cod-fisc.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-postal":U THEN ASSIGN pFieldValue = RowObject.cod-postal.
        WHEN "nom-col":U THEN ASSIGN pFieldValue = RowObject.nom-col.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
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
  Purpose:     Retorna valores dos campos do °ndice intrnccl_id2
  Parameters:  
               retorna valor do campo cod-col
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-col LIKE internac-col.cod-col NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-col = RowObject.cod-col.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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
  Purpose:     Reposiciona registro com base no °ndice intrnccl_id2
  Parameters:  
               recebe valor do campo cod-col
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-col LIKE internac-col.cod-col NO-UNDO.

    FIND FIRST bfinternac-col WHERE 
        bfinternac-col.cod-col = pcod-col NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfinternac-col THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfinternac-col)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodigo DBOProgram 
PROCEDURE openQueryCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
        WHERE {&TableName}.cod-col    >= c-col-ini 
          AND {&TableName}.cod-col    <= c-col-fim
          AND {&TableName}.nom-col    >= c-nome-ini 
          AND {&TableName}.nom-col    <= c-nome-fim
          AND {&TableName}.cod-fisc   >= c-fisc-ini 
          AND {&TableName}.cod-fisc   <= c-fisc-fim
          AND {&TableName}.cod-postal >= c-postal-ini 
          AND {&TableName}.cod-postal <= c-postal-fim
        BY {&TableName}.cod-col
        INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNome DBOProgram 
PROCEDURE openQueryNome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
        WHERE {&TableName}.nom-col >= c-nome-ini 
          AND {&TableName}.nom-col <= c-nome-fim
          AND {&TableName}.cod-col    >= c-col-ini 
          AND {&TableName}.cod-col    <= c-col-fim
          AND {&TableName}.cod-fisc   >= c-fisc-ini 
          AND {&TableName}.cod-fisc   <= c-fisc-fim
          AND {&TableName}.cod-postal >= c-postal-ini 
          AND {&TableName}.cod-postal <= c-postal-fim
        BY {&TableName}.nom-col
        INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodigo DBOProgram 
PROCEDURE setConstraintCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-col-ini    LIKE {&TableName}.cod-col    NO-UNDO.
    DEF INPUT PARAM p-col-fim    LIKE {&TableName}.cod-col    NO-UNDO.
    DEF INPUT PARAM p-nome-ini   LIKE {&TableName}.nom-col    NO-UNDO.
    DEF INPUT PARAM p-nome-fim   LIKE {&TableName}.nom-col    NO-UNDO.
    DEF INPUT PARAM p-fisc-ini   LIKE {&TableName}.cod-fisc   NO-UNDO.
    DEF INPUT PARAM p-fisc-fim   LIKE {&TableName}.cod-fisc   NO-UNDO.
    DEF INPUT PARAM p-postal-ini LIKE {&TableName}.cod-postal NO-UNDO.
    DEF INPUT PARAM p-postal-fim LIKE {&TableName}.cod-postal NO-UNDO.

    ASSIGN c-col-ini    = p-col-ini
           c-col-fim    = p-col-fim
           c-nome-ini   = p-nome-ini
           c-nome-fim   = p-nome-fim
           c-fisc-ini   = p-fisc-ini  
           c-fisc-fim   = p-fisc-fim  
           c-postal-ini = p-postal-ini
           c-postal-fim = p-postal-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNome DBOProgram 
PROCEDURE setConstraintNome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-nome-ini   LIKE {&TableName}.nom-col    NO-UNDO.
    DEF INPUT PARAM p-nome-fim   LIKE {&TableName}.nom-col    NO-UNDO.
    DEF INPUT PARAM p-col-ini    LIKE {&TableName}.cod-col    NO-UNDO.
    DEF INPUT PARAM p-col-fim    LIKE {&TableName}.cod-col    NO-UNDO.
    DEF INPUT PARAM p-fisc-ini   LIKE {&TableName}.cod-fisc   NO-UNDO.
    DEF INPUT PARAM p-fisc-fim   LIKE {&TableName}.cod-fisc   NO-UNDO.
    DEF INPUT PARAM p-postal-ini LIKE {&TableName}.cod-postal NO-UNDO.
    DEF INPUT PARAM p-postal-fim LIKE {&TableName}.cod-postal NO-UNDO.

    ASSIGN c-col-ini    = p-col-ini
           c-col-fim    = p-col-fim
           c-nome-ini   = p-nome-ini
           c-nome-fim   = p-nome-fim
           c-fisc-ini   = p-fisc-ini  
           c-fisc-fim   = p-fisc-fim  
           c-postal-ini = p-postal-ini
           c-postal-fim = p-postal-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    DEF VAR c-liter AS CHAR NO-UNDO.

    IF  pType = "Create":U THEN DO:
        IF  CAN-FIND(FIRST bf{&TableName} 
                     WHERE bf{&tablename}.cod-col = RowObject.cod-col) THEN DO:
            {utp/ut-liter.i "Colìnia" *}
            {method/svc/errors/inserr.i &ErrorNumber="4242" 
                                        &ErrorType="EMS"
                                        &ErrorParameters="RETURN-VALUE"}
        END. 
    END.

    IF  pType = "Create":U OR pType = "Update":U THEN DO:
        IF  RowObject.cod-col = "" THEN DO:
            {utp/ut-liter.i "Colìnia" *}
            {method/svc/errors/inserr.i &ErrorNumber="17677" 
                                        &ErrorType="EMS"
                                        &ErrorParameters="RETURN-VALUE"}
        END.

        IF  RowObject.nom-col = "" THEN DO:
            {utp/ut-liter.i "Nome_Colìnia" *}
            {method/svc/errors/inserr.i &ErrorNumber="17677" 
                                        &ErrorType="EMS"
                                        &ErrorParameters="RETURN-VALUE"}
        END.

        IF  RowObject.cod-fisc = "" THEN DO:
            {utp/ut-liter.i "C¢digo_Fiscal" *}
            {method/svc/errors/inserr.i &ErrorNumber="17677" 
                                        &ErrorType="EMS"
                                        &ErrorParameters="RETURN-VALUE"}
        END.

        IF  RowObject.cod-postal = "" THEN DO:
            {utp/ut-liter.i "C¢digo_Postal" *}
            {method/svc/errors/inserr.i &ErrorNumber="17677" 
                                        &ErrorType="EMS"
                                        &ErrorParameters="RETURN-VALUE"}
        END.
    END.

    IF  pType = "DELETE":U THEN DO:
        IF CAN-FIND (FIRST internac-transp-cp
                     WHERE internac-transp-cp.cod-col = RowObject.cod-col) THEN DO:
            {utp/ut-liter.i "Colìnia" *} ASSIGN c-liter = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "Colìnia_Carta_Porte" *}
            ASSIGN c-liter = c-liter + "~~" + TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                         &ErrorNumber="5906"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="c-liter"} 
        END.
    END.


    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

