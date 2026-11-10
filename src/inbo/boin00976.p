&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T-----------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/
{include/i-prgvrs.i BOIN00976 2.00.00.019 } /*** "010019" 13/11/2023 11:45:44 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
    {include/i-license-manager.i BOIN00976 MAQ}
&ENDIF
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN00976
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName pto-rota-coleta
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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin00976.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bfpropried-rural FOR propried-rural.
    
{aqp/aq0303.i} /*tt-digita*/
{cdp/cd0031.i} /* seguranca por estabelecimento */

DEF VAR i-cod-rota LIKE rota-coleta.cod-rota NO-UNDO.

DEFINE VARIABLE c-cod-rota-ini   like RowObject.cod-rota NO-UNDO.
DEFINE VARIABLE c-cod-rota-fim   like RowObject.cod-rota NO-UNDO.
DEFINE VARIABLE c-cod-pto-coleta like RowObject.cod-rota NO-UNDO.

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
         HEIGHT             = 12.38
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaRotaPrincipal DBOProgram 
PROCEDURE atualizaRotaPrincipal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER padd-del        AS CHAR                             NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-rota       LIKE pto-rota-coleta.cod-rota       NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-pto-coleta LIKE pto-rota-coleta.cod-pto-coleta NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF padd-del = "DEL":U THEN DO:

        FOR FIRST pto-coleta FIELDS(cod-propried) NO-LOCK
            WHERE pto-coleta.cod-pto-coleta = pcod-pto-coleta:
    
            FOR FIRST propried-rural EXCLUSIVE-LOCK
                WHERE propried-rural.cod-propried = pto-coleta.cod-propried:

                /*Se a rota ‚ a principal*/
                IF pcod-rota = propried-rural.cod-rota-princ THEN DO:

                    FOR FIRST bfpto-rota-coleta FIELDS(cod-rota) NO-LOCK
                        WHERE bfpto-rota-coleta.cod-pto-coleta = pcod-pto-coleta:
                    END.
                    IF AVAIL bfpto-rota-coleta THEN DO:
                    
                        ASSIGN propried-rural.cod-rota-princ = bfpto-rota-coleta.cod-rota. /*Encontrou outra rota que passa pela propriedade*/

                        {method/svc/errors/inserr.i &ErrorNumber     = "54647"
                                                    &ErrorType       = "EMS"
                                                    &ErrorSubType    = "INFORMATION"
                                                    &ErrorParameters = "propried-rural.cod-propried + '~~~~' + bfpto-rota-coleta.cod-rota"}

                    END.
                    ELSE
                        ASSIGN propried-rural.cod-rota-princ = "". 

                    /*se for coletivo atualizar a rota principal das propriedades dos produtores*/
                    FOR EACH produt-pto-coleta FIELDS(cod-propried) NO-LOCK
                       WHERE produt-pto-coleta.cod-pto-coleta = pcod-pto-coleta:
                    
                        FOR FIRST bfpropried-rural EXCLUSIVE-LOCK
                            WHERE bfpropried-rural.cod-propried = produt-pto-coleta.cod-propried: 
                        END.
                        
                        IF AVAIL bfpto-rota-coleta THEN DO:

                            ASSIGN bfpropried-rural.cod-rota-princ = bfpto-rota-coleta.cod-rota.
                            
                            {method/svc/errors/inserr.i &ErrorNumber     = "54647"
                                                        &ErrorType       = "EMS"
                                                        &ErrorSubType    = "INFORMATION"
                                                        &ErrorParameters = "bfpropried-rural.cod-propried + '~~~~' + bfpto-rota-coleta.cod-rota"}

                        END.
                        ELSE DO: 
                            IF AVAIL bfpropried-rural THEN
                                ASSIGN bfpropried-rural.cod-rota-princ = "".
                        END.
                           
                        
                    END.

                END.
    
            END.
    
        END.

    END.
    ELSE DO: /*ADD*/

        FOR FIRST pto-coleta FIELDS(cod-propried) NO-LOCK
            WHERE pto-coleta.cod-pto-coleta = pcod-pto-coleta:
        
            FOR FIRST propried-rural EXCLUSIVE-LOCK
                 WHERE propried-rural.cod-propried = pto-coleta.cod-propried:

                IF propried-rural.cod-rota-princ = "" THEN
                    ASSIGN propried-rural.cod-rota-princ = pcod-rota.

            END.

            /*se for coletivo atualizar a rota principal das propriedades dos produtores*/           
            FOR EACH produt-pto-coleta FIELDS(cod-propried)
               WHERE produt-pto-coleta.cod-pto-coleta = pcod-pto-coleta:
            
                FOR FIRST bfpropried-rural EXCLUSIVE-LOCK
                     WHERE bfpropried-rural.cod-propried = produt-pto-coleta.cod-propried:

                    ASSIGN bfpropried-rural.cod-rota-princ = pcod-rota.

                END.
                
            END.
    
        END.

    END.

    RELEASE propried-rural   NO-ERROR.
    RELEASE bfpropried-rural NO-ERROR.

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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-pto-coleta":U THEN ASSIGN pFieldValue = RowObject.cod-pto-coleta.
        WHEN "cod-rota":U THEN ASSIGN pFieldValue = RowObject.cod-rota.
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
        WHEN "cdn-seq":U THEN ASSIGN pFieldValue = RowObject.cdn-seq.
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
  Purpose:     Retorna valores dos campos do ¡ndice rota-coleta
  Parameters:  
               retorna valor do campo cod-rota
               retorna valor do campo cod-pto-coleta
               retorna valor do campo cdn-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-rota LIKE pto-rota-coleta.cod-rota NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-pto-coleta LIKE pto-rota-coleta.cod-pto-coleta NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-seq LIKE pto-rota-coleta.cdn-seq NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-rota = RowObject.cod-rota
           pcod-pto-coleta = RowObject.cod-pto-coleta
           pcdn-seq = RowObject.cdn-seq.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLastSequenceByRota DBOProgram 
PROCEDURE getLastSequenceByRota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-rota AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-cdn-seq AS INTEGER   NO-UNDO.

    FOR EACH bf{&TableName} FIELDS(cod-rota cdn-seq) NO-LOCK
       WHERE bf{&TableName}.cod-rota = pc-cod-rota
       BREAK BY bf{&TableName}.cod-rota 
             BY bf{&TableName}.cdn-seq:

        IF LAST-OF(bf{&TableName}.cod-rota) THEN
            ASSIGN pi-cdn-seq = bf{&TableName}.cdn-seq + 1.
    END.

    IF pi-cdn-seq = 0 THEN
        ASSIGN pi-cdn-seq = 1.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sortSequence DBOProgram 
PROCEDURE sortSequence :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-rota AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE i-count-seq AS INTEGER NO-UNDO.

    FOR EACH bf{&TableName} EXCLUSIVE-LOCK
       WHERE bf{&TableName}.cod-rota = pc-cod-rota
          BY bf{&TableName}.cdn-seq:
         ASSIGN i-count-seq = i-count-seq + 1.

        ASSIGN bf{&TableName}.cdn-seq = i-count-seq.        
    END.

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
  Purpose:     Reposiciona registro com base no ¡ndice rota-coleta
  Parameters:  
               recebe valor do campo cod-rota
               recebe valor do campo cod-pto-coleta
               recebe valor do campo cdn-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-rota LIKE pto-rota-coleta.cod-rota NO-UNDO.
    DEFINE INPUT PARAMETER pcod-pto-coleta LIKE pto-rota-coleta.cod-pto-coleta NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-seq LIKE pto-rota-coleta.cdn-seq NO-UNDO.

    FIND FIRST bfpto-rota-coleta WHERE 
        bfpto-rota-coleta.cod-rota = pcod-rota AND 
        bfpto-rota-coleta.cod-pto-coleta = pcod-pto-coleta AND 
        bfpto-rota-coleta.cdn-seq = pcdn-seq NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpto-rota-coleta THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpto-rota-coleta)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToRota DBOProgram 
PROCEDURE linkToRota :
/*---------------------------------------------------------------
  Purpose:     Recebe handle do DBO Item e execute m?todo getKey
  Parameters:  recebe handle de um DBO
  Notes:       
----------------------------------------------------------------*/
    def input param pHandle as handle no-undo.
    
    run getKey in pHandle (output i-cod-rota).   
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByRota DBOProgram 
PROCEDURE openQueryByRota :
/*------------------------------------------------------------------------------
  Purpose:  Abre quuery com base no cod-tranp   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cod-rota = i-cod-rota
            BY {&TableName}.cdn-seq INDEXED-REPOSITION.

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPtoColeta DBOProgram 
PROCEDURE openQueryPtoColeta :
/*------------------------------------------------------------------------------
  Purpose:  Abre quuery com base no ponto de coleta
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cod-pto-coleta = c-cod-pto-coleta.

    RETURN "OK":U.


END PROCEDURE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodigo DBOProgram 
PROCEDURE setConstraintCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER p-cod-rota-ini LIKE RowObject.cod-rota NO-UNDO.
    DEF INPUT PARAMETER p-cod-rota-fim LIKE RowObject.cod-rota NO-UNDO.

    ASSIGN c-cod-rota-ini = p-cod-rota-ini       
           c-cod-rota-fim = p-cod-rota-fim.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodigo DBOProgram 
PROCEDURE setConstraintPtoColeta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER p-cod-pto-coleta LIKE RowObject.cod-pto-coleta NO-UNDO.

    ASSIGN c-cod-pto-coleta = p-cod-pto-coleta.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTDigitaRota DBOProgram 
PROCEDURE criaTTDigitaRota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-digita.
    DEFINE INPUT        PARAM i-rd-amostra-pto-col AS INTEGER   NO-UNDO.       /* 1 - considera pto-coleta coletivos 2 - único para cada pto-coleta*/
    DEFINE INPUT        PARAM c-cod-estabel        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-des-pto-coleta LIKE pto-coleta.des-pto-coleta NO-UNDO.

    EMPTY TEMP-TABLE tt-digita NO-ERROR.

    FOR EACH {&tableName} FIELDS(cod-rota cod-pto-coleta cdn-seq) 
       WHERE {&tablename}.cod-rota >= c-cod-rota-ini
         AND {&tablename}.cod-rota <= c-cod-rota-fim NO-LOCK,
       FIRST rota-coleta FIELDS(cod-estabel) NO-LOCK
       WHERE rota-coleta.cod-estabel = c-cod-estabel
         AND rota-coleta.cod-rota    = {&tableName}.cod-rota:
       
       {cdp/cd0031a.i rota-coleta.cod-estabel} /* seguranca por estabelecimento */
        
        FOR FIRST pto-coleta FIELDS(des-pto-coleta) NO-LOCK WHERE pto-coleta.cod-pto-coleta = {&tablename}.cod-pto-coleta:
            ASSIGN c-des-pto-coleta = pto-coleta.des-pto-coleta.
        END.

        IF i-rd-amostra-pto-col = 1 THEN DO: /* 1 - considera pto-coleta coletivos */

            FOR EACH produt-pto-coleta FIELDS(cod-pto-coleta cdn-produt-rural) NO-LOCK
               WHERE produt-pto-coleta.cod-pto-coleta = {&tablename}.cod-pto-coleta 
                 AND produt-pto-coleta.log-livre-1 /* Ativo */:
                
                FOR FIRST emitente FIELDS(nome-emit) NO-LOCK WHERE emitente.cod-emitente = produt-pto-coleta.cdn-produt-rural:
            
                    CREATE tt-digita.
                    ASSIGN tt-digita.cod-rota         = {&tablename}.cod-rota
                           tt-digita.cod-pto-coleta   = produt-pto-coleta.cod-pto-coleta 
                           tt-digita.des-pto-coleta   = c-des-pto-coleta
                           tt-digita.nome-emit        = emitente.nome-emit
                           tt-digita.cdn-produt-rural = produt-pto-coleta.cdn-produt-rural
                           tt-digita.cdn-seq          = {&TableName}.cdn-seq.
            
                END.
            
            END.
        
        END.
        ELSE DO: /*  2 - único para cada pto-coleta */

            FOR FIRST produt-pto-coleta FIELDS(cod-pto-coleta cdn-produt-rural) NO-LOCK
                WHERE produt-pto-coleta.cod-pto-coleta = {&tablename}.cod-pto-coleta
                  AND produt-pto-coleta.log-livre-1 /* Ativo */
                  AND produt-pto-coleta.log-respons:
                
                FOR FIRST emitente FIELDS(nome-emit) NO-LOCK WHERE emitente.cod-emitente = produt-pto-coleta.cdn-produt-rural:
            
                    CREATE tt-digita.
                    ASSIGN tt-digita.cod-rota       = {&tablename}.cod-rota
                           tt-digita.cod-pto-coleta = produt-pto-coleta.cod-pto-coleta 
                           tt-digita.des-pto-coleta = c-des-pto-coleta
                           tt-digita.nome-emit      = emitente.nome-emit
                           tt-digita.cdn-produt-rural = produt-pto-coleta.cdn-produt-rural
                           tt-digita.cdn-seq          = {&TableName}.cdn-seq.
            
                END.
            
            END.

        END.

    END.

 RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTDigitaPtoCol DBOProgram 
PROCEDURE criaTTDigitaPtoCol :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAM c-cod-pto-coleta LIKE pto-coleta.cod-pto-coleta.
    DEFINE INPUT        PARAM i-rd-amostra-pto-col  AS INTEGER NO-UNDO.       /* 1 - considera pto-coleta coletivos 2 - único para cada pto-coleta*/
    DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-digita.

    DEFINE VARIABLE c-des-pto-coleta LIKE pto-coleta.des-pto-coleta NO-UNDO.
    
    FOR EACH {&tableName} FIELDS(cod-rota cod-pto-coleta cdn-seq)  
       WHERE {&tablename}.cod-pto-coleta = c-cod-pto-coleta NO-LOCK:
        
        FOR FIRST pto-coleta FIELDS(des-pto-coleta) NO-LOCK 
            WHERE pto-coleta.cod-pto-coleta = {&tablename}.cod-pto-coleta:
           ASSIGN c-des-pto-coleta = pto-coleta.des-pto-coleta.
        END.

        IF i-rd-amostra-pto-col = 1 THEN DO: /* 1 - considera pto-coleta coletivos */

            FOR EACH produt-pto-coleta FIELDS(cod-pto-coleta cdn-produt-rural) NO-LOCK
               WHERE produt-pto-coleta.cod-pto-coleta = {&tablename}.cod-pto-coleta 
                 AND produt-pto-coleta.log-livre-1 /* Ativo */:
    
                FOR FIRST emitente FIELDS(cod-emitente nome-emit) NO-LOCK WHERE emitente.cod-emitente = produt-pto-coleta.cdn-produt-rural:
                        
                    IF NOT CAN-FIND(FIRST tt-digita WHERE tt-digita.cod-pto-coleta   = produt-pto-coleta.cod-pto-coleta
                                                      AND tt-digita.cdn-produt-rural = emitente.cod-emitente) THEN DO:
        
                        CREATE tt-digita.
                        ASSIGN tt-digita.cod-rota         = {&tablename}.cod-rota
                               tt-digita.cod-pto-coleta   = produt-pto-coleta.cod-pto-coleta 
                               tt-digita.des-pto-coleta   = c-des-pto-coleta
                               tt-digita.nome-emit        = emitente.nome-emit
                               tt-digita.cdn-produt-rural = produt-pto-coleta.cdn-produt-rural
                               tt-digita.cdn-seq          = {&TableName}.cdn-seq.
    
                    END.
    
                END.
    
            END.
            
        END.
        ELSE DO: /*  2 - único para cada pto-coleta */

            FOR FIRST produt-pto-coleta FIELDS(cod-pto-coleta cdn-produt-rural) 
                WHERE produt-pto-coleta.cod-pto-coleta = {&tablename}.cod-pto-coleta
                  AND produt-pto-coleta.log-livre-1 /* Ativo */
                  AND produt-pto-coleta.log-respons NO-LOCK:
    
                FOR FIRST emitente FIELDS(cod-emitente nome-emit) NO-LOCK WHERE emitente.cod-emitente = produt-pto-coleta.cdn-produt-rural:
                        
                    IF NOT CAN-FIND(FIRST tt-digita WHERE tt-digita.cod-pto-coleta   = produt-pto-coleta.cod-pto-coleta
                                                      AND tt-digita.cdn-produt-rural = emitente.cod-emitente) THEN DO:
        
                        CREATE tt-digita.
                        ASSIGN tt-digita.cod-rota         = {&tablename}.cod-rota
                               tt-digita.cod-pto-coleta   = produt-pto-coleta.cod-pto-coleta 
                               tt-digita.des-pto-coleta   = c-des-pto-coleta
                               tt-digita.nome-emit        = emitente.nome-emit
                               tt-digita.cdn-produt-rural = produt-pto-coleta.cdn-produt-rural
                               tt-digita.cdn-seq          = {&TableName}.cdn-seq.
    
                    END.
    
                END.
    
            END.

        END.

    END.

    FOR EACH tt-digita WHERE tt-digita.cod-rota = "":
        DELETE tt-digita.
    END.

 RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
