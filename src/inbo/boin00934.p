&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
{include/i-prgvrs.i BOIN00934 2.00.00.007 } /*** "010007" 30/01/2026 17:08:59 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin00934 MUT}
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
&GLOBAL-DEFINE DBOName BOIN00934
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName comp-exam-emit
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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin00934.i RowObject}
{inbo/boin00934.i tt-comp-exam-emit}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE cItCodigo LIKE exam-emit.it-codigo  NO-UNDO.
DEFINE VARIABLE cCodEmit  LIKE exam-emit.cod-emitente  NO-UNDO.
DEFINE VARIABLE cCodExam  LIKE exam-emit.cod-exame  NO-UNDO.
DEFINE VARIABLE cCdnVer   LIKE exam-emit.cdn-versao  NO-UNDO.

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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecordsCustom DBOProgram 
PROCEDURE getBatchRecordsCustom :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pi-cod-emitente LIKE {&TableName}.cod-emitente NO-UNDO.
    DEFINE INPUT PARAM pi-cod-exame    LIKE {&TableName}.cod-exame    NO-UNDO.
    DEFINE INPUT PARAM pc-it-codigo    LIKE {&TableName}.it-codigo    NO-UNDO.
    DEFINE INPUT PARAM pi-cdn-versao   LIKE {&TableName}.cdn-versao   NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-comp-exam-emit.
    
    EMPTY TEMP-TABLE tt-comp-exam-emit.
    
    FOR EACH {&TableName}             
       WHERE {&TableName}.cod-emitente = pi-cod-emitente
         AND {&TableName}.cod-exame    = pi-cod-exame
         AND {&TableName}.it-codigo    = pc-it-codigo
         AND {&TableName}.cdn-versao   = pi-cdn-versao NO-LOCK:
             
        CREATE tt-comp-exam-emit.
        ASSIGN tt-comp-exam-emit.cod-emitente      = {&TableName}.cod-emitente 
               tt-comp-exam-emit.it-codigo         = {&TableName}.it-codigo    
               tt-comp-exam-emit.cdn-versao        = {&TableName}.cdn-versao   
               tt-comp-exam-emit.cod-exame         = {&TableName}.cod-exame                      
               tt-comp-exam-emit.cod-comp          = {&TableName}.cod-comp     
               tt-comp-exam-emit.descricao         = {&TableName}.descricao    
               tt-comp-exam-emit.tipo-result       = {&TableName}.tipo-result  
               tt-comp-exam-emit.nr-tabela         = {&TableName}.nr-tabela    
               tt-comp-exam-emit.unidade           = {&TableName}.unidade      
               tt-comp-exam-emit.local-cq          = {&TableName}.local-cq     
               tt-comp-exam-emit.log-ativo         = {&TableName}.log-1        
               tt-comp-exam-emit.narrativa         = {&TableName}.narrativa        
               tt-comp-exam-emit.result-min        = {&TableName}.result-min       
               tt-comp-exam-emit.result-max        = {&TableName}.result-max       
               tt-comp-exam-emit.inst-equip        = {&TableName}.inst-equip       
               tt-comp-exam-emit.compl-res         = {&TableName}.compl-res        
               tt-comp-exam-emit.refer-tec         = {&TableName}.refer-tec        
               tt-comp-exam-emit.metodo            = {&TableName}.metodo           
               tt-comp-exam-emit.nr-decimais       = {&TableName}.nr-decimais      
               tt-comp-exam-emit.nr-horas          = {&TableName}.nr-horas         
               tt-comp-exam-emit.check-sum         = {&TableName}.check-sum        
               tt-comp-exam-emit.certificado       = {&TableName}.certificado      
               tt-comp-exam-emit.log-1             = {&TableName}.log-1       
               tt-comp-exam-emit.qti-test-realzdo  = {&TableName}.qti-test-realzdo 
               tt-comp-exam-emit.r-rowid           = ROWID({&TableName}).                
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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "compl-res":U THEN ASSIGN pFieldValue = RowObject.compl-res.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "inst-equip":U THEN ASSIGN pFieldValue = RowObject.inst-equip.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "metodo":U THEN ASSIGN pFieldValue = RowObject.metodo.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "refer-tec":U THEN ASSIGN pFieldValue = RowObject.refer-tec.
        WHEN "unidade":U THEN ASSIGN pFieldValue = RowObject.unidade.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "result-max":U THEN ASSIGN pFieldValue = RowObject.result-max.
        WHEN "result-min":U THEN ASSIGN pFieldValue = RowObject.result-min.
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
        WHEN "cdn-versao":U THEN ASSIGN pFieldValue = RowObject.cdn-versao.
        WHEN "certificado":U THEN ASSIGN pFieldValue = RowObject.certificado.
        WHEN "cod-comp":U THEN ASSIGN pFieldValue = RowObject.cod-comp.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-exame":U THEN ASSIGN pFieldValue = RowObject.cod-exame.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "local-cq":U THEN ASSIGN pFieldValue = RowObject.local-cq.
        WHEN "nr-decimais":U THEN ASSIGN pFieldValue = RowObject.nr-decimais.
        WHEN "nr-horas":U THEN ASSIGN pFieldValue = RowObject.nr-horas.
        WHEN "nr-tabela":U THEN ASSIGN pFieldValue = RowObject.nr-tabela.
        WHEN "qti-test-realzdo":U THEN ASSIGN pFieldValue = RowObject.qti-test-realzdo.
        WHEN "tipo-result":U THEN ASSIGN pFieldValue = RowObject.tipo-result.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice cmpxmmt_id2
  Parameters:  
               retorna valor do campo cod-emitente
               retorna valor do campo it-codigo
               retorna valor do campo cod-exame
               retorna valor do campo cod-comp
               retorna valor do campo cdn-versao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE comp-exam-emit.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE comp-exam-emit.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-exame LIKE comp-exam-emit.cod-exame NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-comp LIKE comp-exam-emit.cod-comp NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-versao LIKE comp-exam-emit.cdn-versao NO-UNDO.         

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-emitente = RowObject.cod-emitente
           pit-codigo = RowObject.it-codigo
           pcod-exame = RowObject.cod-exame
           pcod-comp = RowObject.cod-comp
           pcdn-versao = RowObject.cdn-versao.

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
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-ativo":U THEN ASSIGN pFieldValue = RowObject.log-ativo.
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
  Purpose:     Reposiciona registro com base no °ndice cmpxmmt_id2
  Parameters:  
               recebe valor do campo cod-emitente
               recebe valor do campo it-codigo
               recebe valor do campo cod-exame
               recebe valor do campo cod-comp
               recebe valor do campo cdn-versao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-emitente LIKE comp-exam-emit.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE comp-exam-emit.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-exame LIKE comp-exam-emit.cod-exame NO-UNDO.
    DEFINE INPUT PARAMETER pcod-comp LIKE comp-exam-emit.cod-comp NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-versao LIKE comp-exam-emit.cdn-versao NO-UNDO.

    FIND FIRST bfcomp-exam-emit WHERE 
        bfcomp-exam-emit.cod-emitente = pcod-emitente AND 
        bfcomp-exam-emit.it-codigo = pit-codigo AND 
        bfcomp-exam-emit.cod-exame = pcod-exame AND 
        bfcomp-exam-emit.cod-comp = pcod-comp AND 
        bfcomp-exam-emit.cdn-versao = pcdn-versao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcomp-exam-emit THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcomp-exam-emit)).
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
    
    OPEN QUERY qr{&TableName} FOR EACH {&tableName} NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCompExam DBOProgram 
PROCEDURE openQueryCompExam :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} where
                                     {&TableName}.it-codigo    = cItCodigo and
                                     {&TableName}.cod-emitente = cCodEmit  and
                                     {&TableName}.cod-exame    = cCodExam  AND
                                     {&TableName}.cdn-versao   = cCdnVer   NO-LOCK .
    RETURN "ok":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCompExam DBOProgram 
PROCEDURE setConstraintCompExam :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcod-item AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-emit AS INTEGER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-exam AS INTEGER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcdn-ver  AS INTEGER    NO-UNDO.
    ASSIGN cItCodigo = pcod-item                                                    
           cCodEmit  = pcod-emit
           cCodExam  = pcod-exam
           cCdnVer   = pcdn-ver. 
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToCompExam DBOProgram 
PROCEDURE linkToCompExam :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
   
   RUN getKey IN pHandle (OUTPUT cCodEmit,
                          OUTPUT cItCodigo,
                          OUTPUT cCodExam,
                          OUTPUT cCdnVer).
   
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultComponent DBOProgram 
PROCEDURE setDefaultComponent :
/*------------------------------------------------------------------------------
 Purpose: Verifica se existem registros na comp-exame para a chave informada. 
          Se existir copia os registros da tabela comp-exame para a tabela 
          comp-exam-emit.
 Notes:
 Parameters: pi-cod-emitente - CÛdigo Emitente
             pi-cod-exame    - CÛdigo do exame
             pc-it-codigo    - CÛdigo Item
             pi-cdn-versao   - CÛdigo da vers„o  
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-cod-emitente LIKE {&TableName}.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pi-cod-exame    LIKE {&TableName}.cod-exame    NO-UNDO.
    DEFINE INPUT PARAMETER pc-it-codigo    LIKE {&TableName}.it-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER pi-cdn-versao   LIKE {&TableName}.cdn-versao   NO-UNDO.

    FOR EACH comp-exame 
       WHERE comp-exame.cod-exame  = pi-cod-exame
         AND comp-exame.cdn-versao = pi-cdn-versao NO-LOCK:
         
        IF CAN-FIND(FIRST comp-exam-emit
                    WHERE comp-exam-emit.cod-emitente = pi-cod-emitente
                      AND comp-exam-emit.cod-exame    = comp-exame.cod-exame 
                      AND comp-exam-emit.it-codigo    = pc-it-codigo
                      AND comp-exam-emit.cdn-versao   = comp-exame.cdn-versao 
                      AND comp-exam-emit.cod-comp     = comp-exame.cod-comp) THEN DO:
            /* Se existir o registro vai para o prÛximo registro da comp-exame */                        
            NEXT.
        END.    
      
        CREATE comp-exam-emit.
        ASSIGN comp-exam-emit.cod-emitente     = pi-cod-emitente   
               comp-exam-emit.it-codigo        = pc-it-codigo     
               comp-exam-emit.cdn-versao       = pi-cdn-versao
               comp-exam-emit.cod-exame        = comp-exame.cod-exame       
               comp-exam-emit.cod-comp         = comp-exame.cod-comp        
               comp-exam-emit.descricao        = comp-exame.descricao       
               comp-exam-emit.narrativa        = comp-exame.narrativa       
               comp-exam-emit.result-min       = comp-exame.result-min      
               comp-exam-emit.result-max       = comp-exame.result-max      
               comp-exam-emit.tipo-result      = comp-exame.tipo-result     
               comp-exam-emit.nr-tabela        = comp-exame.nr-tabela       
               comp-exam-emit.Unidade          = comp-exame.Unidade         
               comp-exam-emit.local-cq         = comp-exame.local-cq        
               comp-exam-emit.inst-equip       = comp-exame.inst-equip      
               comp-exam-emit.compl-res        = comp-exame.compl-res       
               comp-exam-emit.refer-tec        = comp-exame.refer-tec       
               comp-exam-emit.metodo           = comp-exame.metodo          
               comp-exam-emit.nr-decimais      = comp-exame.nr-decimais     
               comp-exam-emit.nr-horas         = comp-exame.nr-horas        
               comp-exam-emit.check-sum        = comp-exame.check-sum       
               comp-exam-emit.certificado      = comp-exame.certificado     
               comp-exam-emit.log-1            = comp-exame.log-1  
               comp-exam-emit.qti-test-realzdo = comp-exame.qti-test-realzdo.

    END.     
    
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
    
    DEFINE VARIABLE l-lote-avancado AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE c-aux-liter-1   AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE c-aux-liter-2   AS CHARACTER          NO-UNDO.
    
    IF CAN-FIND(FIRST funcao 
                WHERE funcao.cd-funcao = "lote-avancado":U 
                  AND funcao.ativo) THEN
        ASSIGN l-lote-avancado = YES.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    IF  pType = "CREATE" THEN DO:        
        IF RowObject.cod-comp = 0 THEN DO:
            {utp/ut-liter.i Componente * } 
            {method/svc/errors/inserr.i
                        &ErrorNumber="7966" /* Componente deve ser diferente de zero */
                        &ErrorType="EMS"
                        &ErrorParameters= RETURN-VALUE}    
            RETURN "NOK":U.                                 
        END.  
        
        IF RowObject.descricao = "" THEN DO:
            {utp/ut-liter.i do_componente * } 
            {method/svc/errors/inserr.i
                        &ErrorNumber="30572" /* DescriÁ„o deve ser diferente de branco */
                        &ErrorType="EMS"
                        &ErrorParameters= RETURN-VALUE} 
            RETURN 'NOK':U.            
        END.         
        
        IF CAN-FIND({&TableName} 
              WHERE {&TableName}.cod-emitente = RowObject.cod-emitente
                AND {&TableName}.it-codigo    = RowObject.it-codigo
                AND {&TableName}.cod-comp     = RowObject.cod-comp 
                AND {&TableName}.cod-exame    = RowObject.cod-exame 
                AND {&TableName}.cdn-versao   = RowObject.cdn-versao) THEN DO:
            {method/svc/errors/inserr.i
                        &ErrorNumber="54067" 
                        &ErrorType="EMS"
                        &ErrorParameters= "STRING(RowObject.cod-comp)  + '~~~~' + 
                                           STRING(RowObject.cod-exame) + '~~~~' + 
                                           STRING(RowObject.cod-emitente) "}
                                           
        END.                                   
    END.
   
               
    IF l-lote-avancado THEN DO:       
        IF pType = "DELETE":U THEN DO :            
            FOR FIRST exam-emit FIELDS(cod-exame cdn-versao)NO-LOCK
                WHERE exam-emit.cod-emitente = RowObject.cod-emitente 
                  AND exam-emit.cod-exame    = RowObject.cod-exame
                  AND exam-emit.it-codigo    = RowObject.it-codigo
                  AND exam-emit.cdn-versao   = RowObject.cdn-versao: 
                FOR FIRST exame FIELDS(cdn-sit-vers)
                    WHERE exame.cod-exame  = exam-emit.cod-exame 
                      AND exame.cdn-versao = exam-emit.cdn-versao NO-LOCK:
                    IF exame.cdn-sit-vers = 2 
                    OR exame.cdn-sit-vers = 3 THEN DO:
                        {utp/ut-liter.i Somente_versoes_pendentes_poderao_ser_eliminadas}
                        {method/svc/errors/inserr.i
                                    &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorParameters=RETURN-VALUE}
                    END.                 
                END.    
            END.            
        END.
            
        IF CAN-FIND(FIRST res-fic-cq
                    WHERE res-fic-cq.cod-exame = RowObject.cod-exame
                      AND res-fic-cq.cod-comp  = RowObject.cod-comp) THEN DO:                
            {utp/ut-liter.i comp-exame-emit}
            ASSIGN c-aux-liter-1 = RETURN-VALUE.    
                            
            {utp/ut-liter.i res-fic-cq}
            ASSIGN c-aux-liter-2 = RETURN-VALUE.
                
            {method/svc/errors/inserr.i
                    &ErrorNumber="5"
                    &ErrorType="EMS"
                    &ErrorParameters = c-aux-liter-1 ~~ c-aux-liter-2}
        END. 
    END.
      
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

