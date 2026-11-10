&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 

{include/i-prgvrs.i BOIN01020 2.00.00.011 } /*** "010011" 13/11/2023 11:45:46 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin01020 MAQ}
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
&GLOBAL-DEFINE DBOName BOIN01020
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName config-peso-qualid
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
{inbo/boin01020.i RowObject}
{inbo/boin01020.i tt-config-peso-qualid}
{inbo/boin01021.i tt-peso-period}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE TEMP-TABLE tt-peso-qualid NO-UNDO
    field cod-estabel like config-peso-qualid.cod-estabel
    field it-codigo   as char
    field cod-exame   as char
    field cod-comp    as char
    field qtd-period  as char
    field dat-inic    as char
    field dat-fim     as char
    field cdn-period  as char
    field val-peso    as char
    field desc-item   as char
    field desc-exame  as char
    field desc-comp   as char
    field cdn-seq     like {&TableName}.cdn-seq
    field r-rowid     as rowid.

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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
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
        WHEN "dat-fim":U THEN ASSIGN pFieldValue = RowObject.dat-fim.
        WHEN "dat-inic":U THEN ASSIGN pFieldValue = RowObject.dat-inic.
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
        WHEN "qtd-period":U THEN ASSIGN pFieldValue = RowObject.qtd-period.
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
        WHEN "cod-comp":U THEN ASSIGN pFieldValue = RowObject.cod-comp.
        WHEN "cod-exame":U THEN ASSIGN pFieldValue = RowObject.cod-exame.
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
  Purpose:     Retorna valores dos campos do ¡ndice unico_id2
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo it-codigo
               retorna valor do campo cod-exame
               retorna valor do campo cod-comp
               retorna valor do campo cdn-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE config-peso-qualid.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE config-peso-qualid.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-exame LIKE config-peso-qualid.cod-exame NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-comp LIKE config-peso-qualid.cod-comp NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-seq LIKE config-peso-qualid.cdn-seq NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pit-codigo = RowObject.it-codigo
           pcod-exame = RowObject.cod-exame
           pcod-comp = RowObject.cod-comp
           pcdn-seq = RowObject.cdn-seq.

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
  Purpose:     Reposiciona registro com base no ¡ndice unico_id2
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo it-codigo
               recebe valor do campo cod-exame
               recebe valor do campo cod-comp
               recebe valor do campo cdn-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE config-peso-qualid.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE config-peso-qualid.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-exame LIKE config-peso-qualid.cod-exame NO-UNDO.
    DEFINE INPUT PARAMETER pcod-comp LIKE config-peso-qualid.cod-comp NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-seq LIKE config-peso-qualid.cdn-seq NO-UNDO.

    FIND FIRST bfconfig-peso-qualid WHERE 
        bfconfig-peso-qualid.cod-estabel = pcod-estabel AND 
        bfconfig-peso-qualid.it-codigo = pit-codigo AND 
        bfconfig-peso-qualid.cod-exame = pcod-exame AND 
        bfconfig-peso-qualid.cod-comp = pcod-comp AND 
        bfconfig-peso-qualid.cdn-seq = pcdn-seq NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfconfig-peso-qualid THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfconfig-peso-qualid)).
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
    
    DEFINE VARIABLE c-texto1 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-texto2 AS CHARACTER NO-UNDO.

    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/

    IF pType = "CREATE":U THEN DO:

        IF NOT CAN-FIND(FIRST it-comp-exame NO-LOCK
                        WHERE it-comp-exame.it-codigo = RowObject.it-codigo
                          AND it-comp-exame.cod-comp  = RowObject.cod-comp
                          AND it-comp-exame.cod-exame = RowObject.cod-exame) THEN DO:
        
            {utp/ut-liter.i Relacionamento_Item_x_exame_x_componente}
            {method/svc/errors/inserr.i 
                        &ErrorNumber     = 31768 
                        &ErrorType       = "EMS"
                        &ErrorSubType    = "ERROR"
                        &ErrorParameters = RETURN-VALUE}
    
        END.
       
        /*conflito de vigência de datas*/
        IF CAN-FIND (FIRST {&TableName} WHERE {&TableName}.cod-estabel = RowObject.cod-estabel
                                          AND {&TableName}.it-codigo   = RowObject.it-codigo
                                          AND {&TableName}.cod-exame   = RowObject.cod-exame
                                          AND {&TableName}.cod-comp    = RowObject.cod-comp
                                          AND {&TableName}.dat-fim    >= RowObject.dat-inic 
                                          AND {&TableName}.dat-inic   <= RowObject.dat-fim)  THEN DO:
        
            /*Já existe outra configuração de pesos com período de validade em conflito. 
            Help: Já existe outra configuração de peso para o mesmo Estabelecimento, Item, Exame e Componente, 
            e com período de validade em conflito. 
            Período da outra configuração de: <periodo_ini_valid_outra_config>, até: <periodo-fim-valid-outra-config>. */
        
            {METHOD/svc/errors/inserr.i 
                        &ErrorNumber="54985"                             
                        &ErrorType="EMS"
                        &ErrorParameters  = "STRING(RowObject.dat-inic) + '~~~~' + STRING(RowObject.dat-fim)"}
            
            
        END.
        /*************************/

    END.

    IF pType = "Update":U THEN DO:

        /*conflito de vigência de datas*/
        IF CAN-FIND (FIRST {&TableName} WHERE {&TableName}.cod-estabel = RowObject.cod-estabel
                                          AND {&TableName}.it-codigo   = RowObject.it-codigo
                                          AND {&TableName}.cod-exame   = RowObject.cod-exame
                                          AND {&TableName}.cod-comp    = RowObject.cod-comp
                                          AND {&TableName}.dat-fim    >= RowObject.dat-inic 
                                          AND {&TableName}.dat-inic   <= RowObject.dat-fim 
                                          AND ROWID({&TableName})     <> RowObject.r-rowid) THEN DO:
            /*Já existe outra configuração de pesos com período de validade em conflito. 
            Help: Já existe outra configuração de peso para o mesmo Estabelecimento, Item, Exame e Componente, 
            e com período de validade em conflito. 
            Período da outra configuração de: <periodo_ini_valid_outra_config>, até: <periodo-fim-valid-outra-config>. */

            {METHOD/svc/errors/inserr.i 
                        &ErrorNumber="54985"                             
                        &ErrorType="EMS"
                        &ErrorParameters  = "STRING({&TableName}.dat-inic) + '~~~~' + STRING({&TableName}.dat-fim)"}
    
                        RETURN "NOK":U.
        END.
        /*************************/

    END.

    IF pType = "Update":U OR pType = "Create":U THEN DO:

        IF  RowObject.dat-fim  < RowObject.dat-inic THEN DO:
        
            {utp/ut-liter.i Data_Final}
            ASSIGN c-texto1 = RETURN-VALUE.
        
            {utp/ut-liter.i Data_Inicial}
            ASSIGN c-texto2 = RETURN-VALUE.
        
            {method/svc/errors/inserr.i
                        &ErrorNumber      = "7017"
                        &ErrorType        = "EMS"
                        &ErrorParameters  = "c-texto1 + '~~~~' + c-texto2"}
        
        END.

    END.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTTpesoQualid DBOProgram 
PROCEDURE getTTpesoQualid :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT  PARAM p-cod-estabel LIKE config-peso-qualid.cod-estabel.
    DEFINE OUTPUT PARAM TABLE FOR tt-peso-qualid.

    EMPTY TEMP-TABLE tt-peso-qualid.

    FOR EACH config-peso-qualid NO-LOCK
        WHERE config-peso-qualid.cod-estabel = p-cod-estabel
        GROUP BY config-peso-qualid.it-codigo
              BY config-peso-qualid.cod-exame
              BY config-peso-qualid.cod-comp
              BY config-peso-qualid.dat-inic DESC:

        FOR FIRST item FIELDS(desc-item) NO-LOCK
            WHERE item.it-codigo = config-peso-qualid.it-codigo: END.

        FOR FIRST exame FIELDS(cod-exame descricao) NO-LOCK
            WHERE exame.cod-exame = config-peso-qualid.cod-exame: END.

        FOR FIRST comp-exame FIELDS(descricao) NO-LOCK
            WHERE comp-exame.cod-exame = exame.cod-exame
              AND comp-exame.cod-comp  = config-peso-qualid.cod-comp: END.

        FOR EACH peso-period NO-LOCK
            WHERE peso-period.cod-estabel = config-peso-qualid.cod-estabel
              AND peso-period.it-codigo   = config-peso-qualid.it-codigo  
              AND peso-period.cod-exame   = config-peso-qualid.cod-exame  
              AND peso-period.cod-comp    = config-peso-qualid.cod-comp
              AND peso-period.cdn-seq     = config-peso-qualid.cdn-seq
            BREAK BY peso-period.cdn-seq:

            IF FIRST-OF(peso-period.cdn-seq) THEN DO:

                CREATE tt-peso-qualid.
                ASSIGN tt-peso-qualid.cod-estabel = config-peso-qualid.cod-estabel
                       tt-peso-qualid.it-codigo   = config-peso-qualid.it-codigo
                       tt-peso-qualid.cod-exame   = STRING(config-peso-qualid.cod-exame)
                       tt-peso-qualid.cod-comp    = STRING(config-peso-qualid.cod-comp)
                       tt-peso-qualid.cdn-seq     = config-peso-qualid.cdn-seq 
                       tt-peso-qualid.qtd-period  = STRING(config-peso-qualid.qtd-period)
                       tt-peso-qualid.dat-inic    = STRING(config-peso-qualid.dat-inic, '99/99/9999')
                       tt-peso-qualid.dat-fim     = STRING(config-peso-qualid.dat-fim , '99/99/9999')
                       tt-peso-qualid.cdn-period  = STRING(peso-period.cdn-period)
                       tt-peso-qualid.val-peso    = STRING(peso-period.val-peso)
                       tt-peso-qualid.desc-item   = IF AVAIL item THEN item.desc-item ELSE ""
                       tt-peso-qualid.desc-exame  = IF AVAIL exame THEN exame.descricao ELSE ""
                       tt-peso-qualid.desc-comp   = IF AVAIL comp-exame THEN comp-exame.descricao ELSE ""
                       tt-peso-qualid.r-rowid     = ROWID(config-peso-qualid).

            END.
            ELSE DO:

                CREATE tt-peso-qualid.
                ASSIGN tt-peso-qualid.cod-estabel = config-peso-qualid.cod-estabel
                       tt-peso-qualid.it-codigo   = ""
                       tt-peso-qualid.cod-exame   = ""
                       tt-peso-qualid.cod-comp    = ""
                       tt-peso-qualid.qtd-period  = ""
                       tt-peso-qualid.dat-inic    = ""
                       tt-peso-qualid.dat-fim     = ""
                       tt-peso-qualid.cdn-period  = STRING(peso-period.cdn-period)
                       tt-peso-qualid.val-peso    = STRING(peso-period.val-peso)
                       tt-peso-qualid.desc-item   = ""
                       tt-peso-qualid.desc-exame  = ""
                       tt-peso-qualid.desc-comp   = ""
                       tt-peso-qualid.r-rowid     = ROWID(config-peso-qualid).
 
            END. /*NOT FIRST OF*/

        END. /*FOR EACH peso-period*/    

    END. /*FOR FIRST config-peso-qualid*/ 
        

    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaSequencia DBOProgram 
PROCEDURE buscaSequencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-config-peso-qualid.
    DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-peso-period.
   
    FOR FIRST tt-config-peso-qualid EXCLUSIVE-LOCK:

        FOR LAST {&TableName} FIELDS(cdn-seq) NO-LOCK
            WHERE {&TableName}.cod-estabel = tt-config-peso-qualid.cod-estabel
              AND {&TableName}.it-codigo   = tt-config-peso-qualid.it-codigo  
              AND {&TableName}.cod-exame   = tt-config-peso-qualid.cod-exame  
              AND {&TableName}.cod-comp    = tt-config-peso-qualid.cod-comp:   

            ASSIGN tt-config-peso-qualid.cdn-seq = {&TableName}.cdn-seq + 1.

        END.

        IF NOT AVAIL {&TableName} THEN DO:
            ASSIGN tt-config-peso-qualid.cdn-seq = 1.

        END.

        FOR EACH tt-peso-period EXCLUSIVE-LOCK:
        
            ASSIGN tt-peso-period.cdn-seq = tt-config-peso-qualid.cdn-seq.
        
        END.

    END.

    RETURN "OK":U.

END PROCEDURE.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecordsPesoPeriod DBOProgram 
PROCEDURE deleteRecordsPesoPeriod :
/*------------------------------------------------------------------------------
  Purpose: Excluir os registros do periodo para a configuração.    
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pcod-estabel LIKE config-peso-qualid.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo   LIKE config-peso-qualid.it-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-exame   LIKE config-peso-qualid.cod-exame   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-comp    LIKE config-peso-qualid.cod-comp    NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-seq     LIKE config-peso-qualid.cdn-seq     NO-UNDO.

    FOR EACH peso-period EXCLUSIVE-LOCK
        WHERE peso-period.cod-estabel = pcod-estabel
          AND peso-period.it-codigo   = pit-codigo  
          AND peso-period.cod-exame   = pcod-exame  
          AND peso-period.cod-comp    = pcod-comp   
          AND peso-period.cdn-seq     = pcdn-seq:    

        DELETE peso-period.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecordCustom DBOProgram 
PROCEDURE updateRecordCustom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM TABLE FOR tt-config-peso-qualid.

    FOR FIRST tt-config-peso-qualid:

        FOR FIRST config-peso-qualid NO-LOCK
            WHERE config-peso-qualid.cod-estabel = tt-config-peso-qualid.cod-estabel
              AND config-peso-qualid.it-codigo   = tt-config-peso-qualid.it-codigo
              AND config-peso-qualid.cod-exame   = tt-config-peso-qualid.cod-exame
              AND config-peso-qualid.cod-comp    = tt-config-peso-qualid.cod-comp
              AND config-peso-qualid.cdn-seq     = tt-config-peso-qualid.cdn-seq:
    
            ASSIGN tt-config-peso-qualid.r-rowid = ROWID(config-peso-qualid).
    
        END.

        RUN emptyRowObject IN THIS-PROCEDURE.
        RUN setRecord      IN THIS-PROCEDURE (INPUT TABLE tt-config-peso-qualid).
        RUN validateRecord IN THIS-PROCEDURE (INPUT "Update":U).
        
        IF RETURN-VALUE = "OK":U THEN DO:

            FOR FIRST config-peso-qualid EXCLUSIVE-LOCK
                WHERE config-peso-qualid.cod-estabel = tt-config-peso-qualid.cod-estabel
                  AND config-peso-qualid.it-codigo   = tt-config-peso-qualid.it-codigo
                  AND config-peso-qualid.cod-exame   = tt-config-peso-qualid.cod-exame
                  AND config-peso-qualid.cod-comp    = tt-config-peso-qualid.cod-comp
                  AND config-peso-qualid.cdn-seq     = tt-config-peso-qualid.cdn-seq:
        
                ASSIGN config-peso-qualid.dat-inic   = tt-config-peso-qualid.dat-inic
                       config-peso-qualid.dat-fim    = tt-config-peso-qualid.dat-fim   
                       config-peso-qualid.qtd-period = tt-config-peso-qualid.qtd-period.
    
            END.
    
            FOR EACH peso-period EXCLUSIVE-LOCK
                WHERE peso-period.cod-estabel = tt-config-peso-qualid.cod-estabel
                  AND peso-period.it-codigo   = tt-config-peso-qualid.it-codigo
                  AND peso-period.cod-exame   = tt-config-peso-qualid.cod-exame
                  AND peso-period.cod-comp    = tt-config-peso-qualid.cod-comp
                  AND peso-period.cdn-seq     = tt-config-peso-qualid.cdn-seq:
        
                DELETE peso-period.
    
            END.
    
        END.
        ELSE 
            RETURN
                "NOK":U.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
