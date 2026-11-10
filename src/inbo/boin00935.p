&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 

{include/i-prgvrs.i BOIN00935 2.00.00.005 } /*** "010005" 27/10/2023 17:03:40  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin00935 MUT}
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
&GLOBAL-DEFINE DBOName BOIN00935
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName exam-emit
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
{inbo/boin00935.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE l-copia-comp AS LOGICAL NO-UNDO.

/*zoom */
DEFINE VARIABLE i-cod-emitente-ini  LIKE {&TableName}.cod-emitente NO-UNDO.
DEFINE VARIABLE i-cod-emitente-fim  LIKE {&TableName}.cod-emitente NO-UNDO.
DEFINE VARIABLE c-it-codigo-ini     LIKE {&TableName}.it-codigo    NO-UNDO.
DEFINE VARIABLE c-it-codigo-fim     LIKE {&TableName}.it-codigo    NO-UNDO.
DEFINE VARIABLE i-cod-exame-ini     LIKE {&TableName}.cod-exame    NO-UNDO.
DEFINE VARIABLE i-cod-exame-fim     LIKE {&TableName}.cod-exame    NO-UNDO.
DEFINE VARIABLE i-cdn-versao-ini    LIKE {&TableName}.cdn-versao   NO-UNDO.
DEFINE VARIABLE i-cdn-versao-fim    LIKE {&TableName}.cdn-versao   NO-UNDO.


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
         HEIGHT             = 9.54
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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram
PROCEDURE afterCreateRecord:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-boin00934 AS HANDLE NO-UNDO.
       
    IF l-copia-comp THEN DO:
            
        IF NOT VALID-HANDLE(h-boin00934) THEN 
            RUN inbo/boin00934.p PERSISTENT SET h-boin00934.
            
        IF VALID-HANDLE(h-boin00934) THEN DO:
            RUN setDefaultComponent IN h-boin00934(INPUT rowObject.cod-emitente,
                                                   INPUT rowObject.cod-exame,
                                                   INPUT rowObject.it-codigo,
                                                   INPUT rowObject.cdn-versao).
                                                   
            DELETE PROCEDURE h-boin00934.
            ASSIGN h-boin00934 = ?.                          
        END.
    END.
    
    
    ASSIGN l-copia-comp = NO.
    
    RETURN "OK":U.

END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram
PROCEDURE beforeDeleteRecord:
/*------------------------------------------------------------------------------
 Purpose: Elimina os componentes ligados ao exame corrente.
 Notes:
------------------------------------------------------------------------------*/

    FOR EACH comp-exam-emit OF rowObject EXCLUSIVE-LOCK:       
        DELETE comp-exam-emit.       
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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
        WHEN "cdn-versao":U THEN ASSIGN pFieldValue = RowObject.cdn-versao.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-exame":U THEN ASSIGN pFieldValue = RowObject.cod-exame.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice examemit_id2
  Parameters:  
               retorna valor do campo cod-emitente
               retorna valor do campo it-codigo
               retorna valor do campo cod-exame
               retorna valor do campo cdn-versao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE exam-emit.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE exam-emit.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-exame LIKE exam-emit.cod-exame NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-versao LIKE exam-emit.cdn-versao NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-emitente = RowObject.cod-emitente
           pit-codigo = RowObject.it-codigo
           pcod-exame = RowObject.cod-exame
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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
  Purpose:     Reposiciona registro com base no ¡ndice examemit_id2
  Parameters:  
               recebe valor do campo cod-emitente
               recebe valor do campo it-codigo
               recebe valor do campo cod-exame
               recebe valor do campo cdn-versao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-emitente LIKE exam-emit.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE exam-emit.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-exame LIKE exam-emit.cod-exame NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-versao LIKE exam-emit.cdn-versao NO-UNDO.

    FIND FIRST bfexam-emit WHERE 
        bfexam-emit.cod-emitente = pcod-emitente AND 
        bfexam-emit.it-codigo = pit-codigo AND 
        bfexam-emit.cod-exame = pcod-exame AND 
        bfexam-emit.cdn-versao = pcdn-versao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfexam-emit THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfexam-emit)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByEmitItExame DBOProgram
PROCEDURE openQueryByEmitItExame:
/*------------------------------------------------------------------------------
 Purpose: Abre a query pela faixa informada no zoom
 Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY qr{&tableName} 
      FOR EACH {&tableName} NO-LOCK
         WHERE {&tableName}.cod-emitente >= i-cod-emitente-ini
           AND {&tableName}.cod-emitente <= i-cod-emitente-fim
           AND {&tableName}.it-codigo    >= c-it-codigo-ini
           AND {&tableName}.it-codigo    <= c-it-codigo-fim  
           AND {&tableName}.cod-exame    >= i-cod-exame-ini
           AND {&tableName}.cod-exame    <= i-cod-exame-fim 
           AND {&tableName}.cdn-versao   >= i-cdn-versao-ini
           AND {&tableName}.cdn-versao   <= i-cdn-versao-fim 
            BY cod-emitente 
            BY it-codigo 
            BY cod-exame
            BY cdn-versao INDEXED-REPOSITION.
           
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
    
    OPEN QUERY qr{&tableName} FOR EACH {&tableName} NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByEmitItExame DBOProgram
PROCEDURE setConstraintByEmitItExame:
/*------------------------------------------------------------------------------
 Purpose: Contraint para openQueryByEmitItExame
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pi-cod-emitente-ini   LIKE {&TableName}.cod-emitente NO-UNDO.
    DEFINE INPUT PARAM pi-cod-emitente-fim   LIKE {&TableName}.cod-emitente NO-UNDO.    
    DEFINE INPUT PARAM pc-it-codigo-ini      LIKE {&TableName}.it-codigo    NO-UNDO.
    DEFINE INPUT PARAM pc-it-codigo-fim      LIKE {&TableName}.it-codigo    NO-UNDO.
    DEFINE INPUT PARAM pi-cod-exame-ini      LIKE {&TableName}.cod-exame    NO-UNDO.
    DEFINE INPUT PARAM pi-cod-exame-fim      LIKE {&TableName}.cod-exame    NO-UNDO.
    DEFINE INPUT PARAM pi-cdn-versao-ini     LIKE {&TableName}.cdn-versao   NO-UNDO.
    DEFINE INPUT PARAM pi-cdn-versao-fim     LIKE {&TableName}.cdn-versao   NO-UNDO.
    
    ASSIGN i-cod-emitente-ini = pi-cod-emitente-ini
           i-cod-emitente-fim = pi-cod-emitente-fim
           c-it-codigo-ini    = pc-it-codigo-ini
           c-it-codigo-fim    = pc-it-codigo-fim
           i-cod-exame-ini    = pi-cod-exame-ini
           i-cod-exame-fim    = pi-cod-exame-fim
           i-cdn-versao-ini   = pi-cdn-versao-ini
           i-cdn-versao-fim   = pi-cdn-versao-fim.
           
    RETURN "OK":U.
    
END PROCEDURE.

	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCopiaComp DBOProgram
PROCEDURE setConstraintCopiaComp:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pl-copia-comp AS LOGICAL NO-UNDO.
    
    ASSIGN l-copia-comp = pl-copia-comp.
    
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

    
    IF pType = "Create":U THEN DO:

        IF rowObject.cdn-versao = 0 THEN DO:
            {method/svc/errors/inserr.i
                    &ErrorNumber="55445" /* Exame não possui versão liberada! */
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=" "} 
             RETURN "NOK":U.
        END.
        
        IF CAN-FIND(FIRST exam-emit 
                    WHERE exam-emit.cod-emitente = rowObject.cod-emitente
                      AND exam-emit.it-codigo    = rowObject.it-codigo 
                      AND exam-emit.cod-exame    = rowObject.cod-exame
                      AND exam-emit.cdn-versao   = rowObject.cdn-versao) THEN
            {method/svc/errors/inserr.i
                    &ErrorNumber="54035"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="string(rowObject.cod-emitente) + '~~~~' + rowObject.it-codigo + '~~~~' + string(rowObject.cod-exame) + '~~~~' + string(rowObject.cdn-versao)"} 
                    
                    
        IF NOT CAN-FIND(FIRST it-exame 
                        WHERE it-exame.cod-exame = rowObject.cod-exame 
                          AND it-exame.it-codigo = rowObject.it-codigo) THEN
            {method/svc/errors/inserr.i
                    &ErrorNumber="3862"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="string(rowObject.cod-exame) + '~~~~' + rowObject.it-codigo"} 
       
    END.    
        
    
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

