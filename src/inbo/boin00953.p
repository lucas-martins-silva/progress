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

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN00953
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName param-de-para-integr-mes
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
{inbo/boin00953.i RowObject}

DEFINE VARIABLE c-des-contdo-erp-ini AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-des-contdo-erp-fim AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-idi-tip-contdo     AS INTEGER NO-UNDO.

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
   Other Settings: CODE-ONLY
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
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-livre-3":U THEN ASSIGN pFieldValue = RowObject.cod-livre-3.
        WHEN "cod-livre-4":U THEN ASSIGN pFieldValue = RowObject.cod-livre-4.
        WHEN "des-contdo-erp":U THEN ASSIGN pFieldValue = RowObject.des-contdo-erp.
        WHEN "des-contdo-mes":U THEN ASSIGN pFieldValue = RowObject.des-contdo-mes.
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
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-livre-3":U THEN ASSIGN pFieldValue = RowObject.dat-livre-3.
        WHEN "dat-livre-4":U THEN ASSIGN pFieldValue = RowObject.dat-livre-4.
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
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-livre-3":U THEN ASSIGN pFieldValue = RowObject.val-livre-3.
        WHEN "val-livre-4":U THEN ASSIGN pFieldValue = RowObject.val-livre-4.
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
        WHEN "idi-tip-contdo":U THEN ASSIGN pFieldValue = RowObject.idi-tip-contdo.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-livre-3":U THEN ASSIGN pFieldValue = RowObject.num-livre-3.
        WHEN "num-livre-4":U THEN ASSIGN pFieldValue = RowObject.num-livre-4.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice prmdprnt_ix2
  Parameters:  
               retorna valor do campo idi-tip-contdo
               retorna valor do campo des-contdo-erp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pidi-tip-contdo LIKE param-de-para-integr-mes.idi-tip-contdo NO-UNDO.
    DEFINE OUTPUT PARAMETER pdes-contdo-erp LIKE param-de-para-integr-mes.des-contdo-erp NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pidi-tip-contdo = RowObject.idi-tip-contdo
           pdes-contdo-erp = RowObject.des-contdo-erp.

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
        WHEN "log-livre-3":U THEN ASSIGN pFieldValue = RowObject.log-livre-3.
        WHEN "log-livre-4":U THEN ASSIGN pFieldValue = RowObject.log-livre-4.
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
  Purpose:     Reposiciona registro com base no ¡ndice prmdprnt_ix2
  Parameters:  
               recebe valor do campo idi-tip-contdo
               recebe valor do campo des-contdo-erp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pidi-tip-contdo LIKE param-de-para-integr-mes.idi-tip-contdo NO-UNDO.
    DEFINE INPUT PARAMETER pdes-contdo-erp LIKE param-de-para-integr-mes.des-contdo-erp NO-UNDO.

    FIND FIRST bfparam-de-para-integr-mes WHERE 
        bfparam-de-para-integr-mes.idi-tip-contdo = pidi-tip-contdo AND 
        bfparam-de-para-integr-mes.des-contdo-erp = pdes-contdo-erp NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfparam-de-para-integr-mes THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfparam-de-para-integr-mes)).
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
 Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroDePara DBOProgram 
PROCEDURE openQueryFiltroDePara :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
        {&TableName}.des-contdo-erp >= c-des-contdo-erp-ini AND
        {&TableName}.des-contdo-erp <= c-des-contdo-erp-fim AND 
        {&TableName}.idi-tip-contdo = i-idi-tip-contdo NO-LOCK.
    
    RETURN "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroDePara DBOProgram 
PROCEDURE setConstraintFiltroDePara:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-des-contdo-erp-ini AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-des-contdo-erp-fim AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-idi-tip-contdo     AS INTEGER   NO-UNDO.
    
    ASSIGN c-des-contdo-erp-ini = p-des-contdo-erp-ini
           c-des-contdo-erp-fim = p-des-contdo-erp-fim
           i-idi-tip-contdo = p-idi-tip-contdo.

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
    IF pType = "Create":U THEN DO:
        /** Chave duplicada **/
        IF CAN-FIND(bf{&TableName} WHERE bf{&TableName}.idi-tip-contdo = rowObject.idi-tip-contdo AND
                                         bf{&TableName}.des-contdo-erp = rowObject.des-contdo-erp) AND
                                         rowObject.des-contdo-erp <> "" THEN DO:
            {utp/ut-liter.i De-Para * }
            {method/svc/errors/inserr.i
                &ErrorNumber = "1"
                &ErrorType = "EMS"
                &ErrorSubType = "ERROR"
                &ErrorParameters="return-value"}
        END.
        /** Conteudo MES duplicado **/
        IF CAN-FIND(bf{&TableName} WHERE bf{&TableName}.des-contdo-mes = rowObject.des-contdo-mes AND
                                         rowObject.des-contdo-mes <> "") THEN DO:
            {utp/ut-liter.i "Conte£do MES" * }
            {method/svc/errors/inserr.i
                &ErrorNumber = "7"
                &ErrorType = "EMS"
                &ErrorSubType = "ERROR"
                &ErrorParameters="return-value"}
        END.
        /* Conteúdo do ERP deve ser preenchido */
        IF rowObject.des-contdo-erp = "":U THEN DO:
            {utp/ut-liter.i "Conte£do ERP"}
            {method/svc/errors/inserr.i
                &ErrorNumber = "3145"
                &ErrorType = "EMS"
                &ErrorSubType = "ERROR"
                &ErrorParameters="RETURN-VALUE"}
        END.
        /* Conteúdo do MES deve ser preenchido */
        IF rowObject.des-contdo-mes = "":U THEN DO:
            {utp/ut-liter.i "Conte£do mes"}
            {method/svc/errors/inserr.i
                &ErrorNumber = "3145"
                &ErrorType = "EMS"
                &ErrorSubType = "ERROR"
                &ErrorParameters="RETURN-VALUE"}
        END.
        /* Tipo de conteúdo deve ser preenchido */
        IF rowObject.idi-tip-contdo = ? OR 
           rowObject.idi-tip-contdo = 0 THEN DO:
            {utp/ut-liter.i "Tipo Conte£do"}
            {method/svc/errors/inserr.i
                &ErrorNumber = "3145"
                &ErrorType = "EMS"
                &ErrorSubType = "ERROR"
                &ErrorParameters="RETURN-VALUE"}
        END.
        /* Valida a empresa */
        IF rowObject.idi-tip-contdo = 1 THEN DO:
            IF NOT CAN-FIND(FIRST empresa WHERE empresa.ep-codigo = rowObject.des-contdo-erp NO-LOCK) THEN DO:
                {utp/ut-liter.i Empresa * R}
                {method/svc/errors/inserr.i
                    &ErrorNumber = "56"
                    &ErrorType = "EMS"
                    &ErrorSubType = "ERROR"
                    &ErrorParameters="RETURN-VALUE"}
            END.
        END.
    END.
    
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

