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

/* ***************************  Definitions  ****************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN00957
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName agrup-invent
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
{inbo/boin00957.i RowObject}

&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE i-cdn-agrup-ini     LIKE agrup-invent.cdn-agrup    NO-UNDO.
DEFINE VARIABLE i-cdn-agrup-fim     LIKE agrup-invent.cdn-agrup    NO-UNDO.
DEFINE VARIABLE c-descricao-ini     LIKE agrup-invent.descricao    NO-UNDO.
DEFINE VARIABLE c-descricao-fim     LIKE agrup-invent.descricao    NO-UNDO.

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
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-respons":U THEN ASSIGN pFieldValue = RowObject.cod-respons.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
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
        WHEN "dt-criacao":U THEN ASSIGN pFieldValue = RowObject.dt-criacao.
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
        WHEN "cdn-agrup":U THEN ASSIGN pFieldValue = RowObject.cdn-agrup.
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
  Purpose:     Retorna valores dos campos do ¡ndice cod_agrup
  Parameters:  
               retorna valor do campo cdn-agrup
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-agrup LIKE agrup-invent.cdn-agrup NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-agrup = RowObject.cdn-agrup.

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
  Purpose:     Reposiciona registro com base no ¡ndice cod_agrup
  Parameters:  
               recebe valor do campo cdn-agrup
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-agrup LIKE agrup-invent.cdn-agrup NO-UNDO.

    FIND FIRST bfagrup-invent WHERE 
        bfagrup-invent.cdn-agrup = pcdn-agrup NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfagrup-invent THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfagrup-invent)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram  
PROCEDURE goToDesc :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice cod_agrup
  Parameters:  
               recebe valor do campo cdn-agrup
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdescricao LIKE agrup-invent.descricao NO-UNDO.

    FIND FIRST bfagrup-invent WHERE 
        bfagrup-invent.descricao = pdescricao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfagrup-invent THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfagrup-invent)).
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
    
    DEFINE INPUT PARAMETER pType  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-texto-erro  AS CHARACTER NO-UNDO. 
    DEFINE VARIABLE c-texto-erro2 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-cdn-agrup LIKE {&TableName}.cdn-agrup  NO-UNDO.    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    
    IF pType = "Create" THEN DO:

        /*código agrupadorjá existente*/
        IF CAN-FIND(bfagrup-invent WHERE bfagrup-invent.cdn-agrup  = RowObject.cdn-agrup) THEN DO: 
             
             {utp/ut-liter.i "Agrupador_Invent rio"}   
             ASSIGN c-texto-erro = RETURN-VALUE. 
             
             {method/svc/errors/inserr.i &ErrorNumber="1"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters="c-texto-erro"}     
        END.
        
        /*descricao agrupadorjá existente*/
        IF CAN-FIND(bfagrup-invent WHERE bfagrup-invent.descricao  = RowObject.descricao) THEN DO:  
             
             {utp/ut-liter.i "em_Agrupador_Invent rio_com_a_descri‡Æo_informada"}   
             ASSIGN c-texto-erro = RETURN-VALUE. 
             
             {method/svc/errors/inserr.i &ErrorNumber="30219"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters="c-texto-erro"}     
        END.
        
        /*verifica se usuário digitou descricao vazia*/
        IF RowObject.descricao = "":U THEN DO:
                    
            {method/svc/errors/inserr.i &ErrorNumber="190"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
                                        
        END.
        
                
        /*verifica se usuário digitou somente numero na descricao*/
        IF RowObject.descricao <>"" THEN DO:
            ASSIGN i-cdn-agrup = INT(RowObject.descricao) NO-ERROR.
            IF NOT ERROR-STATUS:ERROR THEN DO: /* Digitou somente numeros */
            
                {utp/ut-liter.i "Descri‡Æo_do_agrupador"}   
                ASSIGN c-texto-erro = RETURN-VALUE. 
                
                {utp/ut-liter.i "apenas_n£meros"}   
                ASSIGN c-texto-erro2 = RETURN-VALUE.
                
                {method/svc/errors/inserr.i &ErrorNumber="7972"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-texto-erro + '~~~~' + c-texto-erro2"}
                                            
            END.
        END. 
        
        /*verifica se existe o usuário digitado*/
        IF NOT CAN-FIND(usuar-mater where usuar-mater.cod-usuario = RowObject.cod-respons) THEN DO:
          
            {utp/ut-liter.i "Usu rio_Materiais"}   
            ASSIGN c-texto-erro = RETURN-VALUE. 
            
            {method/svc/errors/inserr.i &ErrorNumber="5773"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-texto-erro"}
          
        END.
        
    END.
 
    IF pType = "Update" THEN DO:
        
        /*descricao agrupadorjá existente*/
        FOR FIRST bfagrup-invent WHERE bfagrup-invent.descricao  = RowObject.descricao:  
             IF bfagrup-invent.cdn-agrup <> RowObject.cdn-agrup THEN DO:
             
                 {utp/ut-liter.i "em_Agrupador_Invent rio_com_a_descri‡Æo_informada"}   
                 ASSIGN c-texto-erro = RETURN-VALUE. 
                 {method/svc/errors/inserr.i &ErrorNumber="30219"
                                             &ErrorType="EMS"
                                             &ErrorSubType="ERROR"
                                             &ErrorParameters="c-texto-erro"}     
             END.                                
        END.
                        
        /*verifica se usuário digitou somente numero na descricao*/
        ASSIGN i-cdn-agrup = INT(RowObject.descricao) NO-ERROR.
        IF NOT ERROR-STATUS:ERROR THEN DO: /* Digitou somente numeros */
        
            {utp/ut-liter.i "Descri‡Æo_do_agrupador"}   
            ASSIGN c-texto-erro = RETURN-VALUE. 
            
            {utp/ut-liter.i "apenas_n£meros"}   
            ASSIGN c-texto-erro2 = RETURN-VALUE.
            
            {method/svc/errors/inserr.i &ErrorNumber="7972"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-texto-erro + '~~~~' + c-texto-erro2"}
                                        
        END.
        
        /*verifica se usuário digitou descricao vazia*/
        IF RowObject.descricao = "":U THEN DO:
                    
            {method/svc/errors/inserr.i &ErrorNumber="190"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
                                        
        END.
        
        /*verifica se existe o usuário digitado*/
        IF NOT CAN-FIND(usuar-mater where usuar-mater.cod-usuario = RowObject.cod-respons) THEN DO:
          
            {utp/ut-liter.i "Usu rio_Materiais"}   
            ASSIGN c-texto-erro = RETURN-VALUE. 
          
            {method/svc/errors/inserr.i &ErrorNumber="5773"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-texto-erro"}
        
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
PROCEDURE openQueryMain:
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/

   OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLastCdnAgrup DBOProgram  
PROCEDURE getLastCdnAgrup :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor do ultimo codigo agrupador
  Parameters:  
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-agrup AS INTEGER NO-UNDO.

    FIND LAST bfagrup-invent  NO-LOCK NO-ERROR.
    
    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfagrup-invent THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfagrup-invent)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    ELSE
        Assign pcdn-agrup = {&TableName}.cdn-agrup.
    
    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintParamZoom DBOProgram 
PROCEDURE setConstraintParamZoom :
/*------------------------------------------------------------------------------
  Purpose:     Parƒmetros para filtro do zoom
  Parameters:  p--codigo-ini  - Empresa Inicial
               p-ep-codigo-fim  - Empresa final
               p-estab-ini      - Estabelecimento Inicial
               p-estab-fim      - Estabelecimento final
               
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  p-cdn-agrup-ini   LIKE agrup-invent.cdn-agrup   NO-UNDO.
    DEFINE INPUT PARAMETER  p-cdn-agrup-fim   LIKE agrup-invent.cdn-agrup   NO-UNDO.
    DEFINE INPUT PARAMETER  p-descricao-ini   LIKE agrup-invent.descricao   NO-UNDO.
    DEFINE INPUT PARAMETER  p-descricao-fim   LIKE agrup-invent.descricao   NO-UNDO.
   
    ASSIGN  i-cdn-agrup-ini =  p-cdn-agrup-ini
            i-cdn-agrup-fim =  p-cdn-agrup-fim
            c-descricao-ini =  p-descricao-ini    
            c-descricao-fim =  p-descricao-fim.    
   

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryZoom DBOProgram 
PROCEDURE OpenQueryZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
        WHERE {&TableName}.cdn-agrup      >=  i-cdn-agrup-ini
        AND   {&TableName}.cdn-agrup      <=  i-cdn-agrup-fim
        AND   {&TableName}.descricao      >=  c-descricao-ini    
        AND   {&TableName}.descricao      <=  c-descricao-fim NO-LOCK.

        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaAgrupador DBOProgram 
PROCEDURE piRetornaAgrupador :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir agrupador para ficha inventario
  Parameters:  pDtSaldo    - Data da ficha atual
               pAgrupador  - Agrupador sugerido
               
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER  pDtSaldo   LIKE inventario.dt-saldo    NO-UNDO.
    DEFINE OUTPUT PARAMETER  pAgrupador LIKE agrup-invent.descricao NO-UNDO.
    DEFINE VARIABLE i-cdn-agrup LIKE {&TableName}.cdn-agrup         NO-UNDO.
    
    find first inventario where inventario.dt-saldo = pDtSaldo  
                          and  inventario.cdn-agrup <> 0  NO-LOCK NO-ERROR.
    
    if avail inventario then do:
        assign i-cdn-agrup = inventario.cdn-agrup.
        if not can-find (first inventario where inventario.dt-saldo = pDtSaldo
                                           and inventario.cdn-agrup <> i-cdn-agrup NO-LOCK) then do:
            for first {&TableName} where {&TableName}.cdn-agrup = inventario.cdn-agrup NO-LOCK:
                assign pAgrupador = {&TableName}.descricao.
            end.
        end.
        else assign pAgrupador = "":U.
    end.
    else assign pAgrupador = "":U.    
      

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
