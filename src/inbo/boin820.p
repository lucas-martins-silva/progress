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
{include/i-prgvrs.i BOIN820 2.00.00.006 } /*** "010006" 25/10/2023 14:45:49  ***/

/* ***************************  Definitions  *******************************/

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN820
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName fda-lote-estado
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T Pre-processadores necess rios para utilizar o DBO no MetaDados*/                                        
&GLOBAL-DEFINE KeyField1             cod-status /*:T Informar os campos da chave da tabela, quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject.*/
&GLOBAL-DEFINE XMLReceiver           YES           /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message)*/
/* &GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES */          

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
{inbo/boin820.i RowObject}

DEF TEMP-TABLE ttEstadoLote NO-UNDO
    FIELD codStatus AS CHARACTER
    FIELD desStatus AS CHARACTER.

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


/*:T--- Defini‡Æo variaveis open queries zooms ---*/
DEFINE VARIABLE c-cod-status-ini      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-status-fim      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-des-estado-lote-ini AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-des-estado-lote-fim AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-idi-tip-estado-ini  AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-idi-tip-estado-fim  AS INTEGER   NO-UNDO.

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
         HEIGHT             = 14.25
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
PROCEDURE afterCreateRecord :
/*:T------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cont  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-lista AS CHARACTER   NO-UNDO.

    ASSIGN c-lista = {ininc/i03in218.i 03}.
    
    DO i-cont = 1 TO NUM-ENTRIES(c-lista):
        CREATE fda-lote-espec.
        ASSIGN fda-lote-espec.cod-status = RowObject.cod-status 
               fda-lote-espec.esp-docto  = i-cont .

        IF i-cont > 19 THEN DO:
            CASE rowObject.idi-tip-estado:
                WHEN 1 THEN
                    IF i-cont = 20 OR /*NFD*/
                       i-cont = 21 OR /*NFE*/
                       i-cont = 22 OR /*NFS*/
                       i-cont = 23 OR /*NFT*/
                       i-cont = 25 OR /*REF*/
                       i-cont = 26 OR /*RCS*/
                       i-cont = 28 OR /*REQ*/
                       i-cont = 29 OR /*RFS*/
                       i-cont = 30 OR /*TM*/
                       i-cont = 33 THEN /*TRA*/
                       ASSIGN fda-lote-espec.log-movto = YES.
                WHEN 2 THEN
                    IF i-cont = 20 OR /*NFD*/
                       i-cont = 23 OR /*NFT*/
                       i-cont = 25 OR /*REF*/
                       i-cont = 29 OR /*RFS*/
                       i-cont = 30 OR /*TM*/
                       i-cont = 33 THEN /*TRA*/
                       ASSIGN fda-lote-espec.log-movto = YES.
                WHEN 3 OR
                WHEN 4 OR
                WHEN 5 OR
                WHEN 6 THEN
                    IF i-cont = 23 OR /*NFT*/
                       i-cont = 25 OR /*REF*/
                       i-cont = 33 THEN /*TRA*/
                       ASSIGN fda-lote-espec.log-movto = YES.
    
            END CASE.
        END.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*:T------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes: 
------------------------------------------------------------------------------*/
    FOR EACH fda-lote-espec EXCLUSIVE-LOCK
       WHERE fda-lote-espec.cod-status = RowObject.cod-status :
        DELETE fda-lote-espec.
    END.
    
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
        WHEN "cod-status":U THEN ASSIGN pFieldValue =    RowObject.cod-status.
        WHEN "des-estado-lote":U THEN ASSIGN pFieldValue = RowObject.des-estado-lote.
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
        WHEN "idi-tip-estado":U THEN ASSIGN pFieldValue = RowObject.idi-tip-estado.
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
  Purpose:     Retorna valores dos campos do ¡ndice ltstd-id
  Parameters:  
               retorna valor do campo cod-status
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-status LIKE fda-lote-estado.cod-status NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-status = RowObject.cod-status.

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
        WHEN "log-aloca":U THEN ASSIGN pFieldValue = RowObject.log-aloca.
        WHEN "log-aloca-wms":U THEN ASSIGN pFieldValue = RowObject.log-aloca-wms.
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-sdo-dispon":U THEN ASSIGN pFieldValue = RowObject.log-sdo-dispon.
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
  Purpose:     Reposiciona registro com base no ¡ndice ltstd-id
  Parameters:  
               recebe valor do campo cod-status
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-status LIKE fda-lote-estado.cod-status NO-UNDO.

    FIND FIRST bffda-lote-estado WHERE 
        bffda-lote-estado.cod-status = pcod-status NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bffda-lote-estado THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bffda-lote-estado)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDescricao DBOProgram 
PROCEDURE openQueryByDescricao :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} 
      FOR EACH {&TableName} NO-LOCK 
         WHERE {&TableName}.des-estado-lote >= c-des-estado-lote-ini
           AND {&TableName}.des-estado-lote <= c-des-estado-lote-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByStatus DBOProgram 
PROCEDURE openQueryByStatus :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} 
      FOR EACH {&TableName} NO-LOCK 
         WHERE {&TableName}.cod-status >= c-cod-status-ini
           AND {&TableName}.cod-status <= c-cod-status-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByTipo DBOProgram 
PROCEDURE openQueryByTipo :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} 
      FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.idi-tip-estado >= i-idi-tip-estado-ini
           AND {&TableName}.idi-tip-estado <= i-idi-tip-estado-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
/*:T------------------------------------------------------------------------------
  Purpose: Procedure obrigat¢ria para execu‡Æo via MetaDados
  Parameters:  <none>
  Notes: Para execu‡Æo do DBO via Metadados ‚ necess rio que o DBO utilize a Procedure openQueryDefault para abrir a query principal do DBO.
         Esta Procedure pode ser customizada conforme necessidade do usu rio.
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaEstados DBOProgram 
PROCEDURE retornaEstados :
/*:T------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes: 
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM TABLE FOR ttEstadoLote.
    DEF OUTPUT PARAM TABLE FOR RowErrors.

    blockRetornaEstados:
    DO  ON ERROR UNDO blockRetornaEstados, LEAVE blockRetornaEstados 
        ON STOP  UNDO blockRetornaEstados, LEAVE blockRetornaEstados
        ON QUIT  UNDO blockRetornaEstados, LEAVE blockRetornaEstados:   
        IF CAN-FIND(FIRST fda-lote-estado) THEN DO:
            FOR EACH fda-lote-estado NO-LOCK:
               CREATE ttEstadoLote.
               ASSIGN ttEstadoLote.codStatus = fda-lote-estado.cod-status 
                      ttEstadoLote.desStatus = fda-lote-estado.des-estado-lote.
            END.
        END.
        ELSE DO:
            CREATE RowErrors.
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "NÆo_h _registros_para_Estados_do_Lote" *}
                ASSIGN RowErrors.ErrorDescription = RETURN-VALUE + ".".
        END.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByDescricao DBOProgram 
PROCEDURE setConstraintByDescricao :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-des-estado-lote-ini AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-des-estado-lote-fim AS CHARACTER NO-UNDO.
    
    ASSIGN c-des-estado-lote-ini = pc-des-estado-lote-ini
           c-des-estado-lote-fim = pc-des-estado-lote-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByStatus DBOProgram 
PROCEDURE setConstraintByStatus :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-status-ini AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-status-fim AS CHARACTER NO-UNDO.
    
    ASSIGN c-cod-status-ini = pc-cod-status-ini
           c-cod-status-fim = pc-cod-status-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByTipo DBOProgram 
PROCEDURE setConstraintByTipo :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-idi-tip-estado-ini AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pi-idi-tip-estado-fim AS INTEGER NO-UNDO.
    
    ASSIGN i-idi-tip-estado-ini = pi-idi-tip-estado-ini
           i-idi-tip-estado-fim = pi-idi-tip-estado-fim.
           
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

    DEFINE VARIABLE c-lb-lote-estado  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-lb-param-especif AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    IF pType = "Create":U THEN DO:
        {utp/ut-liter.i "Estado do Lote" *}
        IF RowObject.cod-status = "" THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="4241"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        END.
        
        IF RowObject.des-estado-lote = "" THEN DO:
            {utp/ut-liter.i "Descri‡Æo do Estado do Lote" *}
            {method/svc/errors/inserr.i &ErrorNumber="4241"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        END.        
        ELSE IF CAN-FIND(FIRST fda-lote-estado 
                         WHERE fda-lote-estado.cod-status = RowObject.cod-status) THEN
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
    END.
    ELSE IF pType = "Delete":U THEN DO:
        IF CAN-FIND(FIRST fda-lote-param 
                    WHERE fda-lote-param.cod-aprov-lote  = RowObject.cod-status
                       OR fda-lote-param.cod-inspec-lote = RowObject.cod-status 
                       OR fda-lote-param.cod-rej-lote    = RowObject.cod-status  
                       OR fda-lote-param.cod-status      = RowObject.cod-status) OR
           CAN-FIND(FIRST fda-lote-param-espcif 
                    WHERE fda-lote-param-espcif.cod-aprov-lote  = RowObject.cod-status
                       OR fda-lote-param-espcif.cod-inspec-lote = RowObject.cod-status 
                       OR fda-lote-param-espcif.cod-rej-lote    = RowObject.cod-status  
                       OR fda-lote-param-espcif.cod-status      = RowObject.cod-status) THEN DO:

            {utp/ut-table.i mgind fda-lote-estado 1}
            ASSIGN c-lb-lote-estado = RETURN-VALUE.
            {utp/ut-table.i mgind fda-lote-param-espcif 1}
            ASSIGN c-lb-param-especif = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="47218"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lb-lote-estado + '~~~~' + c-lb-param-especif"}
        END.


    END.
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

