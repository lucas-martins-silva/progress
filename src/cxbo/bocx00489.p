&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
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
{include/i-prgvrs.i BOCX00489 1.00.00.002} /*** "010002" 26/12/2024 16:22:03 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOCX00489
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName duimp-docto
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{cxbo/bocx00489.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE variable de-cod-duimp-dts  LIKE duimp-docto.cod-duimp-dts NO-UNDO.
DEFINE variable i-documento       LIKE duimp-docto.documento NO-UNDO.
DEFINE variable i-sequencia       LIKE duimp-docto.seq-docto NO-UNDO.
DEFINE VARIABLE i-seq-docto       LIKE duimp-docto.seq-docto      NO-UNDO.
DEFINE VARIABLE i-cod-tipo-docto  LIKE duimp-docto.cod-tipo-docto NO-UNDO.

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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "valor":U THEN ASSIGN pFieldValue = RowObject.valor.
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
        WHEN "cod-duimp-dts":U THEN ASSIGN pFieldValue = RowObject.cod-duimp-dts.
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
        WHEN "cod-chave":U THEN ASSIGN pFieldValue = RowObject.cod-chave.
        WHEN "cod-tipo-docto":U THEN ASSIGN pFieldValue = RowObject.cod-tipo-docto.
        WHEN "documento":U THEN ASSIGN pFieldValue = RowObject.documento.
        WHEN "seq-docto":U THEN ASSIGN pFieldValue = RowObject.seq-docto.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice id1-chave
  Parameters:  
               retorna valor do campo cod-duimp-dts
               retorna valor do campo documento
               retorna valor do campo seq-docto
               retorna valor do campo cod-tipo-docto
               retorna valor do campo cod-chave
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-duimp-dts LIKE duimp-docto.cod-duimp-dts NO-UNDO.
    DEFINE OUTPUT PARAMETER pdocumento LIKE duimp-docto.documento NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-docto LIKE duimp-docto.seq-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tipo-docto LIKE duimp-docto.cod-tipo-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-chave LIKE duimp-docto.cod-chave NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-duimp-dts = RowObject.cod-duimp-dts
           pdocumento = RowObject.documento
           pseq-docto = RowObject.seq-docto
           pcod-tipo-docto = RowObject.cod-tipo-docto
           pcod-chave = RowObject.cod-chave.

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
  Purpose:     Reposiciona registro com base no ¡ndice id1-chave
  Parameters:  
               recebe valor do campo cod-duimp-dts
               recebe valor do campo documento
               recebe valor do campo seq-docto
               recebe valor do campo cod-tipo-docto
               recebe valor do campo cod-chave
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-duimp-dts LIKE duimp-docto.cod-duimp-dts NO-UNDO.
    DEFINE INPUT PARAMETER pdocumento LIKE duimp-docto.documento NO-UNDO.
    DEFINE INPUT PARAMETER pseq-docto LIKE duimp-docto.seq-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tipo-docto LIKE duimp-docto.cod-tipo-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-chave LIKE duimp-docto.cod-chave NO-UNDO.

    FIND FIRST bfduimp-docto WHERE 
        bfduimp-docto.cod-duimp-dts = pcod-duimp-dts AND 
        bfduimp-docto.documento = pdocumento AND 
        bfduimp-docto.seq-docto = pseq-docto AND 
        bfduimp-docto.cod-tipo-docto = pcod-tipo-docto AND 
        bfduimp-docto.cod-chave = pcod-chave NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfduimp-docto THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfduimp-docto)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
    IF  RowObject.valor = "" THEN DO:

        IF  RowObject.documento = 3 /* Declara‡Æo */ THEN DO:        
            IF  RowObject.cod-chave = 1 THEN DO:
                {utp/ut-liter.i N£mero_da_Declara‡Æo *}
                {method/svc/errors/inserr.i
                            &ErrorNumber="265"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="RETURN-VALUE"}
            END.
            ELSE 
            IF  RowObject.cod-chave = 2 THEN DO:
                {utp/ut-liter.i Item_Inicial *}
                {method/svc/errors/inserr.i
                            &ErrorNumber="265"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="RETURN-VALUE"}
            END.
            ELSE DO:
                {utp/ut-liter.i Item_Final *}
                {method/svc/errors/inserr.i
                            &ErrorNumber="265"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="RETURN-VALUE"}
            END.
        END.
        ELSE 
        IF  RowObject.documento = 2 /* Processo/Dossiˆ */ THEN DO:
            {utp/ut-liter.i Processo/Dossiˆ *}
            {method/svc/errors/inserr.i
                        &ErrorNumber="265"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="RETURN-VALUE"}
        END.
    END.    
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query com todos os registros da tabela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryTipoDocto DBOProgram 
PROCEDURE openQueryTipoDocto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cod-duimp-dts  = de-cod-duimp-dts
                                 AND {&TABLENAME}.documento      = i-documento 
                                 AND {&TABLENAME}.seq-docto      = i-seq-docto 
                                 AND {&TABLENAME}.cod-tipo-docto = i-cod-tipo-docto
                                 NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDuimp DBOProgram 
PROCEDURE openQueryByDuimp :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query a partir do campo "DUIMP Interno"
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cod-duimp-dts = de-cod-duimp-dts 
                               NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintbyDuimp DBOProgram 
PROCEDURE setConstraintbyDuimp :
/*------------------------------------------------------------------------------
  Purpose:     Recebe os parƒmetros para abertura da query "Duimp"
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-duimp-dts  LIKE duimp-docto.cod-duimp-dts NO-UNDO.
    
    ASSIGN de-cod-duimp-dts = p-cod-duimp-dts. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDocto DBOProgram 
PROCEDURE openQueryDocto :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query a partir do campo "DUIMP Interno"
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cod-duimp-dts = de-cod-duimp-dts
                                 AND {&TABLENAME}.documento = i-documento 
                                 NO-LOCK INDEXED-REPOSITION.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySeqDocto DBOProgram 
PROCEDURE openQuerySeqDocto :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query a partir do campo "DUIMP Interno"
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cod-duimp-dts = de-cod-duimp-dts
                                 and {&TABLENAME}.documento = i-documento 
                                 AND {&TABLENAME}.seq-docto = i-sequencia NO-LOCK 
                                  BY {&TABLENAME}.cod-duimp-dts
                                  BY {&TABLENAME}.documento 
                                  by {&TABLENAME}.seq-docto INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDocto DBOProgram 
PROCEDURE setConstraintDocto :
/*------------------------------------------------------------------------------
  Purpose:     Recebe os parƒmetros para abertura da query "Docto"
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-duimp-dts  LIKE duimp-docto.cod-duimp-dts NO-UNDO.
    DEFINE INPUT PARAMETER p-documento      LIKE duimp-docto.documento NO-UNDO.
    
    ASSIGN de-cod-duimp-dts = p-cod-duimp-dts
           i-documento      = p-documento. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSeqDocto DBOProgram 
PROCEDURE setConstraintSeqDocto :
/*------------------------------------------------------------------------------
  Purpose:     Recebe os parƒmetros para abertura da query "Docto"
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-duimp-dts  LIKE duimp-docto.cod-duimp-dts NO-UNDO.
    DEFINE INPUT PARAMETER p-documento      LIKE duimp-docto.documento NO-UNDO.
    DEFINE INPUT PARAMETER p-sequencia      LIKE duimp-docto.seq-docto NO-UNDO.
    
    ASSIGN de-cod-duimp-dts = p-cod-duimp-dts
           i-documento      = p-documento
           i-sequencia      = p-sequencia.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintTipoDocto DBOProgram 
PROCEDURE setConstraintTipoDocto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-duimp-dts  LIKE {&TableName}.cod-duimp-dts  NO-UNDO.
    DEFINE INPUT PARAMETER pdocumento      LIKE {&TableName}.documento      NO-UNDO.
    DEFINE INPUT PARAMETER pseq-docto      LIKE {&TableName}.seq-docto      NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tipo-docto LIKE {&TableName}.cod-tipo-docto NO-UNDO.

    ASSIGN de-cod-duimp-dts = pcod-duimp-dts
           i-documento      = pdocumento
           i-seq-docto      = pseq-docto
           i-cod-tipo-docto = pcod-tipo-docto.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piProximaSeq DBOProgram 
PROCEDURE piProximaSeq :
/*------------------------------------------------------------------------------
  Purpose:     Sugere proxima sequencia do documento
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-duimp-dts LIKE bf{&TableName}.cod-duimp-dts NO-UNDO.
    DEFINE INPUT PARAMETER pdocumento LIKE bf{&TableName}.documento NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tipo-docto LIKE bf{&TableName}.cod-tipo-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-chave LIKE bf{&TableName}.cod-chave NO-UNDO.
    DEFINE OUTPUT PARAMETER p-seq-docto LIKE bf{&TableName}.seq-docto NO-UNDO.
                
    FIND LAST bf{&TableName} NO-LOCK 
        WHERE bf{&TableName}.cod-duimp-dts = pcod-duimp-dts
          AND bf{&TableName}.documento = pdocumento NO-ERROR.
    IF  NOT AVAIL bf{&TableName} THEN
        ASSIGN p-seq-docto = 1.
    ELSE 
        ASSIGN p-seq-docto = bf{&TableName}.seq-docto + 1.

    IF p-seq-docto > 99999 THEN
       ASSIGN p-seq-docto = 1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
