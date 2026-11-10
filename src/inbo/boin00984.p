&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
      
{include/i-prgvrs.i BOIN00984 2.00.00.009 } /*** "010009" 13/11/2023 11:45:45 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN00984 MAQ}
&ENDIF

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

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN00984
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName reposit
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE XMLReceiver YES  
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin00984.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-cod-pto-coleta  LIKE {&TableName}.cod-pto-coleta NO-UNDO.
DEFINE VARIABLE i-cdn-repos-ini   LIKE {&TableName}.cdn-repos      NO-UNDO.
DEFINE VARIABLE i-cdn-repos-fim   LIKE {&TableName}.cdn-repos      NO-UNDO.
DEFINE VARIABLE c-des-reposit-ini LIKE {&TableName}.des-reposit    NO-UNDO.
DEFINE VARIABLE c-des-reposit-fim LIKE {&TableName}.des-reposit    NO-UNDO.
DEFINE VARIABLE i-produtor        AS   INT NO-UNDO.
DEF VARIABLE l-valida-produtor    AS LOG                             NO-UNDO.
DEF VARIABLE i-cdn-produtor       LIKE produt-rural.cdn-produt-rural NO-UNDO.

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
         HEIGHT             = 6.75
         WIDTH              = 39.57.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDescReposit DBOProgram 
PROCEDURE findDescReposit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  pc-cod-pto-coleta AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER  pi-cdn-repos      AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-des-reposit    AS CHARACTER NO-UNDO.

    FIND FIRST bfReposit NO-LOCK
         WHERE bfReposit.cod-pto-coleta = pc-cod-pto-coleta
           AND bfReposit.cdn-repos      = pi-cdn-repos NO-ERROR.
    IF AVAIL bfReposit THEN
        ASSIGN pc-des-reposit = bfReposit.des-reposit.

    RETURN 'OK':U.

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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-marca":U THEN ASSIGN pFieldValue = RowObject.cod-marca.
        WHEN "cod-modelo":U THEN ASSIGN pFieldValue = RowObject.cod-modelo.
        WHEN "cod-num-serie":U THEN ASSIGN pFieldValue = RowObject.cod-num-serie.
        WHEN "cod-pto-coleta":U THEN ASSIGN pFieldValue = RowObject.cod-pto-coleta.
        WHEN "des-reposit":U THEN ASSIGN pFieldValue = RowObject.des-reposit.
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
        WHEN "qtd-capac":U THEN ASSIGN pFieldValue = RowObject.qtd-capac.
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
        WHEN "cdn-repos":U THEN ASSIGN pFieldValue = RowObject.cdn-repos.
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
  Purpose:     Retorna valores dos campos do °ndice reposit_id
  Parameters:  
               retorna valor do campo cod-reposit
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-reposit LIKE reposit.cdn-repos NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-reposit = RowObject.cdn-repos.

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
  Purpose:     Reposiciona registro com base no °ndice reposit_id
  Parameters:  
               recebe valor do campo cod-reposit
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-reposit    LIKE reposit.cdn-repos NO-UNDO.
    DEFINE INPUT PARAMETER pcod-pto-coleta LIKE reposit.cod-pto-coleta NO-UNDO.

    FIND FIRST bfreposit WHERE 
        bfreposit.cdn-repos      = pcod-reposit 
    AND bfreposit.cod-pto-coleta = pcod-pto-coleta NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfreposit THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfreposit)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE execValidacaoProdutorPtoColeta DBOProgram 
PROCEDURE execValidacaoProdutorPtoColeta:
/*------------------------------------------------------------------------------
  Purpose:     Ativa validaá∆o do Produtor x Pto Coleta
  Parameters:  Recebe log de ativaá∆o e produtor
               
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pvalidaProdut     AS LOG NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-produt-rural LIKE produt-rural.cdn-produt-rural NO-UNDO.
    
    ASSIGN l-valida-produtor = pvalidaProdut
           i-cdn-produtor    = pcdn-produt-rural.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaProdutorPtoColeta DBOProgram 
PROCEDURE validaProdutorPtoColeta:
/*------------------------------------------------------------------------------
  Purpose:     Busca o produtor com base no ponto de coleta
  Parameters:  
               recebe valor do campo cod-pto-coleta
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pcod-pto-coleta LIKE pto-coleta.cod-pto-coleta NO-UNDO.
    
    FIND FIRST pto-coleta 
         WHERE pto-coleta.cod-pto-coleta = pcod-pto-coleta NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pto-coleta THEN 
        RETURN "NOK":U.

    FIND FIRST propried-rural NO-LOCK 
         WHERE propried-rural.cod-propried = pto-coleta.cod-propried NO-ERROR.
    IF NOT AVAILABLE propried-rural THEN 
        RETURN "NOK":U.
    ELSE DO:
        IF i-cdn-produtor <> propried-rural.cdn-produt-rural THEN
            RETURN "NOK":U.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToPtoColeta DBOProgram 
PROCEDURE linkToPtoColeta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pHandle as handle no-undo.
    
    run getKey in pHandle (output c-cod-pto-coleta).   
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToProdutor DBOProgram 
PROCEDURE linkToProdutor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pHandle as handle no-undo.
    
    run getKey in pHandle (output i-produtor).   
    
    return "OK":U.

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

    OPEN QUERY qr{&tableName} FOR EACH {&tableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPtoColCodigo DBOProgram 
PROCEDURE openQueryPtoColCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    OPEN QUERY {&queryName} 
      FOR EACH {&tableName} NO-LOCK
         WHERE {&tablename}.cod-pto-coleta = c-cod-pto-coleta
           AND {&tablename}.log-livre-1    = TRUE  /*indica que o reposit est· ativo*/
           AND {&tablename}.cdn-repos     >= i-cdn-repos-ini 
           AND {&tablename}.cdn-repos     <= i-cdn-repos-fim INDEXED-REPOSITION.

     RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPtoColDesc DBOProgram 
PROCEDURE openQueryPtoColDesc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&queryName} 
      FOR EACH {&tableName} NO-LOCK
         WHERE {&tablename}.cod-pto-coleta = c-cod-pto-coleta
           AND {&tablename}.log-livre-1    = TRUE  /*indica que o reposit est· ativo*/
           AND {&tablename}.des-reposit   >= c-des-reposit-ini 
           AND {&tablename}.des-reposit   <= c-des-reposit-fim INDEXED-REPOSITION.

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryReposPtoCol DBOProgram 
PROCEDURE openQueryReposPtoCol :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&queryName} for each {&tableName} no-lock
                               where {&tablename}.cod-pto-coleta = c-cod-pto-coleta 
                        BY {&tablename}.cod-pto-coleta INDEXED-REPOSITION.
    return "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryReposProdutor DBOProgram 
PROCEDURE openQueryReposProdutor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

	DEFINE VARIABLE qry  AS HANDLE              NO-UNDO.
    DEFINE VARIABLE cqry AS CHARACTER           NO-UNDO.
    DEFINE VARIABLE cqryptocoleta AS CHARACTER  NO-UNDO.

    ASSIGN cqryptocoleta = "".
    FOR EACH propried-rural WHERE  propried-rural.cdn-produt-rural = i-produtor:
        FOR EACH pto-coleta WHERE pto-coleta.cod-propried = propried-rural.cod-propried:
            if cqryptocoleta <> "" then 
                assign cqryptocoleta = cqryptocoleta + " OR ".
    
    		ASSIGN cqryptocoleta = cqryptocoleta + "reposit.cod-pto-coleta = '" + pto-coleta.cod-pto-coleta + "'".
        END.
    END.
    
    IF cqryptocoleta = "" THEN /*produtor n„o tem propriedade*/
        ASSIGN cqryptocoleta = "reposit.cod-pto-coleta = '" + " " + "'".

    ASSIGN cqry = "for each reposit no-lock where " + cqryptocoleta.

    qry = QUERY {&queryName}:HANDLE. 
    qry:QUERY-PREPARE(cqry).
    qry:QUERY-OPEN().

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPtoColCodigo DBOProgram 
PROCEDURE setConstraintPtoColCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-pto-coleta LIKE {&TableName}.cod-pto-coleta NO-UNDO.
    DEFINE INPUT PARAMETER pi-cdn-repos-ini  LIKE {&TableName}.cdn-repos      NO-UNDO.
    DEFINE INPUT PARAMETER pi-cdn-repos-fim  LIKE {&TableName}.cdn-repos      NO-UNDO.

    ASSIGN c-cod-pto-coleta = pc-cod-pto-coleta 
           i-cdn-repos-ini  = pi-cdn-repos-ini    
           i-cdn-repos-fim  = pi-cdn-repos-fim.

    RETURN 'OK':U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPtoColDesc DBOProgram 
PROCEDURE setConstraintPtoColDesc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-pto-coleta  LIKE {&TableName}.cod-pto-coleta NO-UNDO.
    DEFINE INPUT PARAMETER pc-des-reposit-ini LIKE {&TableName}.des-reposit    NO-UNDO.
    DEFINE INPUT PARAMETER pc-des-reposit-fim LIKE {&TableName}.des-reposit    NO-UNDO.

    ASSIGN c-cod-pto-coleta  =  pc-cod-pto-coleta 
           c-des-reposit-ini =  pc-des-reposit-ini
           c-des-reposit-fim =  pc-des-reposit-fim.
                               
    RETURN 'OK':U.

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

    DEFINE VARIABLE c-msg1 AS CHAR NO-UNDO.
    DEFINE VARIABLE c-msg2 AS CHAR NO-UNDO.
    
    DEFINE VARIABLE h-boin00966 AS HANDLE  NO-UNDO.
    DEFINE VARIABLE h-aqapi005  AS HANDLE  NO-UNDO.
    DEFINE VARIABLE rRowid      AS ROWID   NO-UNDO.
    DEFINE VARIABLE iSituacao   AS INTEGER NO-UNDO.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
     IF pType = "Create" THEN DO:
        IF CAN-FIND(FIRST bf{&TableName} WHERE bf{&TableName}.cdn-repos = RowObject.cdn-repos
                                           AND bf{&TableName}.cod-pto-coleta = RowObject.cod-pto-coleta) THEN DO:
            {utp/ut-liter.i Reposit¢rio *}
            {method/svc/errors/inserr.i
                     &ErrorNumber="1"
                     &ErrorType="EMS"
                     &ErrorParameters="return-value"} 
        END.

        IF RowObject.cdn-repos = 0 THEN DO:
            {utp/ut-liter.i C¢digo_Reposit¢rio *}
            {method/svc/errors/inserr.i
                               &ErrorNumber="164"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters="return-value"} 
        END.
    END.

    IF l-valida-produtor THEN DO:

        RUN validaProdutorPtoColeta (INPUT RowObject.cod-pto-coleta).
        IF RETURN-VALUE = "NOK" THEN DO:

            {utp/ut-liter.i Propriedade_rural_selecionada}
            ASSIGN c-msg1 = RETURN-VALUE.

            {utp/ut-liter.i produtor}
            ASSIGN c-msg2 = RETURN-VALUE.
           
            {method/svc/errors/inserr.i
                 &ErrorNumber="19254"
                 &ErrorType="EMS"
                 &ErrorSubType="ERROR"
                 &ErrorParameters="c-msg1 + '~~~~' + c-msg2"}
        
        END.

    END.

    IF RowObject.des-reposit = "" THEN DO:
        {utp/ut-liter.i Descriá∆o *}
        {method/svc/errors/inserr.i
                           &ErrorNumber="164"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters="return-value"} 
    END.

    /*verifica se pto-coleta est· ativo*/
    RUN aqp/aqapi005.p   PERSISTENT SET h-aqapi005.
    RUN inbo/boin00966.p PERSISTENT SET h-boin00966.

    IF VALID-HANDLE(h-boin00966) AND RowObject.log-livre-1 = YES THEN DO: /*est· tentando ativar reposit*/
        RUN openQueryStatic IN h-boin00966(INPUT "Main":U).

        RUN goToKey IN h-boin00966 (INPUT RowObject.cod-pto-coleta).

        RUN getRowid IN h-boin00966 (OUTPUT rRowid).

        RUN piInicial IN h-aqapi005 (INPUT  "consultar":U,
                                     INPUT  "PontoDeColeta":U,
                                     INPUT  rRowid,
                                     OUTPUT iSituacao,
                                     INPUT-OUTPUT TABLE rowErrors).              

        IF iSituacao = 0 THEN DO:
    
            {utp/ut-liter.i Repositorio}
            ASSIGN c-msg1 = RETURN-VALUE.
            {utp/ut-liter.i Para_salvar_reposit¢rio_Ç_necess†rio_ativar_ponto_de_coleta}
            ASSIGN c-msg2 = RETURN-VALUE.
            
            {method/svc/errors/inserr.i
                     &ErrorNumber="54277"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="c-msg1 + '~~~~' + c-msg2"}
    
        END.
    END.

    IF  h-aqapi005 <> ? THEN DO:
        DELETE PROCEDURE h-aqapi005.
        ASSIGN h-aqapi005 = ?.    
    END.

    IF  h-boin00966 <> ? THEN DO:
        DELETE PROCEDURE h-boin00966.
        ASSIGN h-boin00966 = ?.    
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

