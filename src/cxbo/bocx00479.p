&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : BOCX00479.p
    Purpose    : Cont‚m a l¢gica de neg¢cio e acesso a dados para a tabela emitente-siscomex.
    Parameters : 
    Notes      : 
  ------------------------------------------------------------------------*/

{include/i-prgvrs.i BOCX00479 2.00.00.012 } /*** "010012" 05/12/2024 17:52:44 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOCX00479
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName emitente-siscomex
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*:T--- Include com defini‡Æo da temptable RowObject ---*/
{cxbo/bocx00479.i RowObject}
{utp/ut-glob.i} 

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE l-erro-emitente-cex AS  LOGICAL                       NO-UNDO.
DEFINE VARIABLE c-cod-trader-ini    LIKE emitente-siscomex.cod-trader NO-UNDO.
DEFINE VARIABLE c-cod-trader-fim    LIKE emitente-siscomex.cod-trader NO-UNDO.
DEFINE VARIABLE c-nome-ini          LIKE emitente-siscomex.des-nome   NO-UNDO.
DEFINE VARIABLE c-nome-fim          LIKE emitente-siscomex.des-nome   NO-UNDO.
DEFINE VARIABLE i-cdn-emitente-ini  LIKE emitente.cod-emitente        NO-UNDO.
DEFINE VARIABLE i-cdn-emitente-fim  LIKE emitente.cod-emitente        NO-UNDO.

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
         HEIGHT             = 8.83
         WIDTH              = 57.86.
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

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-cep":U        THEN ASSIGN pFieldValue = RowObject.cod-cep.
        WHEN "cod-cnpj-cpf":U   THEN ASSIGN pFieldValue = RowObject.cod-cnpj-cpf.
        WHEN "cod-livre-1":U    THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U    THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-pais-iso":U   THEN ASSIGN pFieldValue = RowObject.cod-pais-iso.
        WHEN "cod-subdiv-iso":U THEN ASSIGN pFieldValue = RowObject.cod-subdiv-iso.
        WHEN "cod-trader":U     THEN ASSIGN pFieldValue = RowObject.cod-trader.
        WHEN "des-ender":U      THEN ASSIGN pFieldValue = RowObject.des-ender.
        WHEN "des-nome":U       THEN ASSIGN pFieldValue = RowObject.des-nome.       
        WHEN "nom-cidade":U     THEN ASSIGN pFieldValue = RowObject.nom-cidade.
        WHEN "cod-versao":U     THEN ASSIGN pFieldValue = RowObject.cod-versao.
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

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-refer":U   THEN ASSIGN pFieldValue = RowObject.dat-refer.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDefaults DBOProgram 
PROCEDURE getDefaults :
/*------------------------------------------------------------------------------
  Purpose: Retorna a temp-table RowObject com informa‡äes padräes para cria‡Æo de um
           novo registro        
  Parameters: i-emitente (INPUT - Integer): C¢digo do emitente
              RowObject (OUTPUT - Temp-table): Registro contendo os valores padräes para 
                                               cria‡Æo de um novo registro.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER i-emitente LIKE emitente.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowObject.

    FOR FIRST emitente FIELDS (nome-emit endereco cidade cep pais) 
        WHERE emitente.cod-emitente = i-emitente NO-LOCK:

        FOR FIRST pais FIELDS(char-1) WHERE pais.nome-pais = emitente.pais NO-LOCK:
        END.

        IF NOT AVAIL param-global THEN
            FIND FIRST param-global NO-LOCK NO-ERROR.

        FOR FIRST empresa FIELDS(cgc) WHERE empresa.ep-codigo = param-global.empresa-prin NO-LOCK:
        END.

        EMPTY TEMP-TABLE RowObject.
        CREATE RowObject.
        ASSIGN RowObject.cdn-emitente   = i-emitente
               RowObject.des-nome       = SUBSTRING(emitente.nome-emit, 1, 70)
               RowObject.cod-cnpj-cpf   = IF AVAIL empresa THEN empresa.cgc ELSE "":U
               RowObject.des-ender      = emitente.endereco
               RowObject.nom-cidade     = emitente.cidade
               RowObject.cod-cep        = emitente.cep
               RowObject.cod-pais-iso   = IF AVAIL pais THEN SUBSTRING(pais.char-1,23,2) ELSE "":U.
    END.
    
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
        WHEN "cdn-emitente":U THEN ASSIGN pFieldValue = RowObject.cdn-emitente.
        WHEN "num-livre-1":U  THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U  THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "cod-situacao":U THEN ASSIGN pFieldValue = RowObject.cod-situacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice prim rio
  Parameters:  
               retorna valor do campo cdn-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-emitente LIKE emitente-siscomex.cdn-emitente NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-emitente = RowObject.cdn-emitente.

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

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-integrad-siscomex":U THEN ASSIGN pFieldValue = RowObject.log-integrad-siscomex.
        WHEN "log-livre-1":U           THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U           THEN ASSIGN pFieldValue = RowObject.log-livre-2.
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
  Purpose:     Reposiciona registro com base no ¡ndice prim rio
  Parameters:  
               recebe valor do campo cdn-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-emitente LIKE emitente-siscomex.cdn-emitente NO-UNDO.

    FIND FIRST bfemitente-siscomex WHERE 
        bfemitente-siscomex.cdn-emitente = pcdn-emitente NO-LOCK NO-ERROR.

    IF NOT AVAILABLE bfemitente-siscomex THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfemitente-siscomex)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodigoTrader DBOProgram 
PROCEDURE openQueryCodigoTrader :
/*------------------------------------------------------------------------------
  Purpose: Realiza a abertura da query principal, filtrado por c¢digo do 
           operador estrangeiro   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                               WHERE {&TableName}.cod-trader >= c-cod-trader-ini
                                 AND {&TableName}.cod-trader <= c-cod-trader-fim
                                 AND {&TableName}.cod-trader <> "":U NO-LOCK
                                  BY {&TableName}.cod-trader INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEmitente DBOProgram 
PROCEDURE openQueryEmitente :
/*------------------------------------------------------------------------------
  Purpose: Realiza a abertura da query principal, filtrado por c¢digo do 
           emitente (operador estrangeiro)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                               WHERE {&TableName}.cdn-emitente >= i-cdn-emitente-ini
                                 AND {&TableName}.cdn-emitente <= i-cdn-emitente-fim NO-LOCK
                                  BY {&TableName}.cdn-emitente INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose: Realiza a abertura da query principal, com todos os registros da tabela    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNome DBOProgram 
PROCEDURE openQueryNome :
/*------------------------------------------------------------------------------
  Purpose: Realiza a abertura da query principal, filtrado por nome
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                               WHERE {&TableName}.des-nome >= c-nome-ini
                                 AND {&TableName}.des-nome <= c-nome-fim
                                 AND {&TableName}.cod-trader <> "":U NO-LOCK
                                  BY {&TableName}.des-nome INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaErroEmitenteCex DBOProgram 
PROCEDURE piSetaErroEmitenteCex :
/*------------------------------------------------------------------------------
  Purpose: - Seta dentro desta DBO se houve alguma valida‡Æo na BOCX155b para que os
           registros da emitente-siscomex nÆo sejam salvos na base de dados.
           Devem ser salvos somente se nÆo ocorrer erro de valida‡Æo tamb‚m na bocx155b
           - Setado atrav‚s da procedure "ValidateFields" da BOCX155b
  Parameters:  pl-erro-emitente-cex: l¢gico (entrada)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-erro-emitente-cex AS LOGICAL NO-UNDO.

    ASSIGN l-erro-emitente-cex = pl-erro-emitente-cex.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaEnvioSiscomex DBOProgram 
PROCEDURE piValidaEnvioSiscomex :
/*------------------------------------------------------------------------------
  Purpose: Valida‡äes feitas no envio do fornecedor para o Siscomex    
  Parameters: pi-cod-emitente (INPUT - integer): C¢digo do emitente a ser validado
              RowErrors (OUTPUT - temp-table): Temp-table com as valida‡äes realizadas
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-cod-emitente LIKE emitente.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    EMPTY TEMP-TABLE RowErrors.

    DEFINE VARIABLE c-lb-emitente-siscomex  AS CHARACTER   NO-UNDO.

    {utp/ut-liter.i o_Emitente_Siscomex *}
    ASSIGN c-lb-emitente-siscomex = RETURN-VALUE.

    IF NOT CAN-FIND(FIRST bf{&TableName}
                    WHERE bf{&TableName}.cdn-emitente = pi-cod-emitente) THEN DO:
        {utp/ut-liter.i Siscomex_para_o_emitente *}
        {method/svc/errors/inserr.i
                    &ErrorNumber="56834"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}                     
    END.
    ELSE DO:
        FOR FIRST bf{&TableName} 
            WHERE bf{&TableName}.cdn-emitente = pi-cod-emitente NO-LOCK:
            IF bf{&TableName}.cod-cnpj-cpf = "":U THEN DO:
                {utp/ut-liter.i CNPJ_Importador/Exportador *}
                {method/svc/errors/inserr.i
                            &ErrorNumber="55925"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-emitente-siscomex + ' ' + string(bf{&TableName}.cdn-emitente)"}
            END.
    
            IF bf{&TableName}.cod-pais-iso = "":U THEN DO:
                {utp/ut-liter.i Pa¡s_ISO *}
                {method/svc/errors/inserr.i
                            &ErrorNumber="55925"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-emitente-siscomex + ' ' + string(bf{&TableName}.cdn-emitente)"}
            END.
    
            IF bf{&TableName}.des-nome = "":U THEN DO:
                {utp/ut-liter.i Nome *}
                {method/svc/errors/inserr.i
                            &ErrorNumber="55925"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-emitente-siscomex + ' ' + string(bf{&TableName}.cdn-emitente)"}
            END.
    
            IF bf{&TableName}.des-ender = "":U THEN DO:
                {utp/ut-liter.i Logradouro *}
                {method/svc/errors/inserr.i
                            &ErrorNumber="55925"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-emitente-siscomex + ' ' + string(bf{&TableName}.cdn-emitente)"}
            END.
    
            IF bf{&TableName}.nom-cidade = "":U THEN DO:
                {utp/ut-liter.i Cidade *}
                {method/svc/errors/inserr.i
                            &ErrorNumber="55925"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-emitente-siscomex + ' ' + string(bf{&TableName}.cdn-emitente)"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodigoTrader DBOProgram 
PROCEDURE setConstraintCodigoTrader :
/*------------------------------------------------------------------------------
  Purpose: Recebe os parƒmetros para abertura da query "CodigoTrader"
  Parameters:  Entrada: pc-cod-trader-ini (character): C¢digo inicial do Operador Estrangeiro
               Entrada: pc-cod-trader-fim (character): C¢digo final do Operador Estrangeiro
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-trader-ini LIKE emitente-siscomex.cod-trader NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-trader-fim LIKE emitente-siscomex.cod-trader NO-UNDO.

    ASSIGN c-cod-trader-ini = pc-cod-trader-ini
           c-cod-trader-fim = pc-cod-trader-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNome DBOProgram 
PROCEDURE setConstraintNome :
/*------------------------------------------------------------------------------
  Purpose: Recebe os parƒmetros para abertura da query "Nome"
  Parameters:  Entrada: pc-cod-trader-ini (character): Nome inicial do Operador Estrangeiro
               Entrada: pc-cod-trader-fim (character): C¢digo final do Operador Estrangeiro
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-des-nome-ini LIKE emitente-siscomex.des-nome NO-UNDO.
    DEFINE INPUT PARAMETER pc-des-nome-fim LIKE emitente-siscomex.des-nome NO-UNDO.

    ASSIGN c-nome-ini = pc-des-nome-ini
           c-nome-fim = pc-des-nome-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodigoEmit DBOProgram 
PROCEDURE setConstraintCodigoEmit :
/*------------------------------------------------------------------------------
  Purpose: Recebe os parƒmetros para abertura da query "CodigoTrader"
  Parameters:  Entrada: pc-cod-trader-ini (character): C¢digo inicial do Operador Estrangeiro
               Entrada: pc-cod-trader-fim (character): C¢digo final do Operador Estrangeiro
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-cdn-emitente-ini LIKE emitente-siscomex.cdn-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pi-cdn-emitente-fim LIKE emitente-siscomex.cdn-emitente NO-UNDO.

    ASSIGN i-cdn-emitente-ini = pi-cdn-emitente-ini
           i-cdn-emitente-fim = pi-cdn-emitente-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do include: method/svc/errors/inserr.i
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    IF pType = "CREATE":U THEN DO:
        IF CAN-FIND(FIRST bfemitente-siscomex 
                    WHERE bfemitente-siscomex.cdn-emitente = RowObject.cdn-emitente) THEN DO:
            {utp/ut-liter.i Emitente_Siscomex *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="8"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END. 
    END.
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    /* Se encontrou algum erro de valida‡Æo realizada pela BOCX155b, 
       o registro nÆo deve ser efetivado na base de dados */
    IF l-erro-emitente-cex THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE findEmitente:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    RUN startMethod ("FIND").
    DEFINE INPUT   PARAMETER i-cdn-emitente AS INTEGER NO-UNDO.
    DEFINE OUTPUT  PARAMETER c-return       AS CHAR    NO-UNDO.
 
    FIND FIRST emitente-siscomex WHERE
        emitente-siscomex.cdn-emitente = i-cdn-emitente NO-LOCK NO-ERROR.
    IF NOT AVAIL emitente-siscomex THEN DO:    
       {utp/ut-table.i mgadm emitente-siscomex 1}
        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 2,
                           INPUT RETURN-VALUE).
        ASSIGN c-return = RETURN-VALUE.
    END.
    ELSE DO:
       RUN setCurrent.
    END.
    RUN endMethod ("FIND").

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
