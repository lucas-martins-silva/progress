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

{include/i-prgvrs.i BOAD00602 2.00.00.005 } /*** "010005" 09/04/2026 16:44:19 ***/

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOAD00602
&GLOBAL-DEFINE DBOVersion 2.00.00.001
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName internac-veic
&GLOBAL-DEFINE TableLabel Ve°culos
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com definiá∆o da temptable RowObject ---*/
{adbo/boad00602.i RowObject}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
{method/dboqry.i}
{utp/ut-glob.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF VAR c-placa-ini LIKE {&TableName}.cod-placa NO-UNDO.
DEF VAR c-placa-fim LIKE {&TableName}.cod-placa NO-UNDO.
DEF VAR c-nome-ini  LIKE {&TableName}.cod-placa NO-UNDO.
DEF VAR c-nome-fim  LIKE {&TableName}.cod-placa NO-UNDO.

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
         HEIGHT             = 14.63
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH internac-veic-reboque 
        WHERE internac-veic-reboque.cod-placa = RowObject.cod-placa EXCLUSIVE-LOCK:
        DELETE internac-veic-reboque.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
        WHEN "cod-ano-mod":U THEN ASSIGN pFieldValue = RowObject.cod-ano-mod.
        WHEN "cod-configur":U THEN ASSIGN pFieldValue = RowObject.cod-configur.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-placa":U THEN ASSIGN pFieldValue = RowObject.cod-placa.
        WHEN "des-veic":U THEN ASSIGN pFieldValue = RowObject.des-veic.
        WHEN "nom-marca":U THEN ASSIGN pFieldValue = RowObject.nom-marca.
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
  Purpose:     Retorna valores dos campos do °ndice intrncvc_id2
  Parameters:  
               retorna valor do campo cod-placa
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-placa LIKE internac-veic.cod-placa NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-placa = RowObject.cod-placa.

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
  Purpose:     Reposiciona registro com base no °ndice intrncvc_id2
  Parameters:  
               recebe valor do campo cod-placa
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-placa LIKE internac-veic.cod-placa NO-UNDO.

    FIND FIRST bfinternac-veic WHERE 
        bfinternac-veic.cod-placa = pcod-placa NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfinternac-veic THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfinternac-veic)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
        WHERE {&TableName}.des-veic >= c-nome-ini 
          AND {&TableName}.des-veic <= c-nome-fim
        BY {&TableName}.des-veic
        INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPlaca DBOProgram 
PROCEDURE openQueryPlaca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
        WHERE {&TableName}.cod-placa >= c-placa-ini 
          AND {&TableName}.cod-placa <= c-placa-fim
        BY {&TableName}.cod-placa
        INDEXED-REPOSITION.

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

    DEF INPUT PARAM p-nome-ini LIKE {&TableName}.des-veic NO-UNDO.
    DEF INPUT PARAM p-nome-fim LIKE {&TableName}.des-veic NO-UNDO.

    ASSIGN c-nome-ini = p-nome-ini
           c-nome-fim = p-nome-fim.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPlaca DBOProgram 
PROCEDURE setConstraintPlaca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-placa-ini LIKE {&TableName}.cod-placa NO-UNDO.
    DEF INPUT PARAM p-placa-fim LIKE {&TableName}.cod-placa NO-UNDO.

    ASSIGN c-placa-ini = p-placa-ini
           c-placa-fim = p-placa-fim.

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
    DEF VAR i-int AS INT NO-UNDO.
    
    IF  pType = "Create":U THEN DO:
        IF  CAN-FIND(FIRST bf{&TableName} 
                     WHERE bf{&tablename}.cod-placa = RowObject.cod-placa) THEN DO:
            {utp/ut-liter.i "Ve°culo" *}
            {method/svc/errors/inserr.i &ErrorNumber="4242" 
                                        &ErrorType="EMS"
                                        &ErrorParameters="RETURN-VALUE"}
        END. 
    END.

    IF  pType = "Create":U OR pType = "Update":U THEN DO:
        IF  RowObject.cod-placa = "" THEN DO:
            {utp/ut-liter.i "Placa" *}
            {method/svc/errors/inserr.i &ErrorNumber="17677" 
                                        &ErrorType="EMS"
                                        &ErrorParameters="RETURN-VALUE"}
        END.

        IF  RowObject.des-veic = "" THEN DO:
            {utp/ut-liter.i "Nome_Ve°culo" *}
            {method/svc/errors/inserr.i &ErrorNumber="17677" 
                                        &ErrorType="EMS"
                                        &ErrorParameters="RETURN-VALUE"}
        END.
        
        IF  RowObject.nom-marca = "" AND 
            i-pais-impto-usuario <> 7 /* Chile */ AND
            i-pais-impto-usuario <> 33 /* Peru */ THEN DO:
            {utp/ut-liter.i "Marca" *}
            {method/svc/errors/inserr.i &ErrorNumber="17677" 
                                        &ErrorType="EMS"
                                        &ErrorParameters="RETURN-VALUE"}
        END.

        IF  RowObject.cod-configur = "" AND
            i-pais-impto-usuario <> 7  /* Chile*/    AND
            i-pais-impto-usuario <> 9  /* Paraguai*/ AND
            i-pais-impto-usuario <> 33 /* Peru */ THEN DO:
            {utp/ut-liter.i "Configuraá∆o_Veicular" *}
            {method/svc/errors/inserr.i &ErrorNumber="17677" 
                                        &ErrorType="EMS"
                                        &ErrorParameters="RETURN-VALUE"}
        END.

        IF  RowObject.cod-ano-mod = "" AND
            i-pais-impto-usuario <> 7  /* Chile*/    AND
            i-pais-impto-usuario <> 9  /* Paraguai*/ AND
            i-pais-impto-usuario <> 33 /* Peru */ THEN DO:
            {utp/ut-liter.i "Ano_Fabricaá∆o" *}
            {method/svc/errors/inserr.i &ErrorNumber="17677" 
                                        &ErrorType="EMS"
                                        &ErrorParameters="RETURN-VALUE"}
        END.

        ASSIGN i-int = INT(RowObject.cod-ano-mod) NO-ERROR.
        IF  i-int = ? OR i-int = 0 AND 
            i-pais-impto-usuario <> 7  /* Chile*/    AND
            i-pais-impto-usuario <> 9  /* Paraguai*/ AND
            i-pais-impto-usuario <> 33 /* Peru */ THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="15204" 
                                        &ErrorType="EMS"
                                        &ErrorParameters="''"}
        END.

        IF i-pais-impto-usuario = 9 /* Paraguai*/ THEN DO:
            IF RowObject.num-livre-1 = 0 THEN DO:
                {utp/ut-liter.i "Tipo_Identificaá∆o" *}
                {method/svc/errors/inserr.i &ErrorNumber="265" 
                                            &ErrorType="EMS"
                                            &ErrorParameters="RETURN-VALUE"}
            END.
            IF RowObject.cod-livre-1 = "" THEN DO:
                CASE RowObject.num-livre-1:
                    WHEN 1 THEN
                        {utp/ut-liter.i "N£mero_Identificaá∆o" *}
                    OTHERWISE
                        {utp/ut-liter.i "N£mero_Matr°cula" *}
                END CASE.
                {method/svc/errors/inserr.i &ErrorNumber="265" 
                                            &ErrorType="EMS"
                                            &ErrorParameters="RETURN-VALUE"}
            END.
        END.
        
        IF i-pais-impto-usuario = 33 /* Peru */ THEN DO:
            IF RowObject.cod-livre-1 = "" THEN DO:
                {utp/ut-liter.i "Carteira_circulaá∆o" *}
                {method/svc/errors/inserr.i &ErrorNumber="265" 
                                            &ErrorType="EMS"
                                            &ErrorParameters="RETURN-VALUE"}
            END.
        END.
        
    END.

    IF  pType = "DELETE":U THEN DO:
        IF CAN-FIND (FIRST internac-veic-transp
                     WHERE internac-veic-transp.cod-placa = RowObject.cod-placa) THEN DO:
            {utp/ut-liter.i "Ve°culo" *} ASSIGN c-liter = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "Ve°culo_transporte" *}
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

