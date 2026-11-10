&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
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
&GLOBAL-DEFINE DBOName BOIN00965
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName produt-carg
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
{inbo/boin00965.i RowObject}
{inbo/boin00965.i RowObjectZoom}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
/*{method/dboqry.i}*/





/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE i-num-carg        AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-cdn-produt-ini  AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-cdn-produt-fim  AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-nome-produt-ini AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-nome-produt-fim AS CHARACTER NO-UNDO.

/***************************************
** TECNICA SEGURANCA ESTABELECIMENTO
***************************************/ 
&Scoped-define FIRST-TABLE-IN-QUERY-{&QueryName} {&TableName}
&Scoped-define SECOND-TABLE-IN-QUERY-{&QueryName} emitente 

&SCOPED-DEFINE REPOSITION-PROCEDURE-KEY-PHRASE TRUE NO-LOCK, ~
     FIRST emitente WHERE emitente.cod-emitente = produt-carg.cdn-produt-rural NO-LOCK

{include/i-estab-security.i}
/***************************************
** TECNICA SEGURANCA ESTABELECIMENTO

***************************************/

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-amostra":U THEN ASSIGN pFieldValue = RowObject.cod-amostra.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-docto-produt":U THEN ASSIGN pFieldValue = RowObject.cod-docto-produt.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-lacre":U THEN ASSIGN pFieldValue = RowObject.cod-lacre.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-lote":U THEN ASSIGN pFieldValue = RowObject.cod-lote.
        WHEN "cod-model-docto-produt":U THEN ASSIGN pFieldValue = RowObject.cod-model-docto-produt.
        WHEN "cod-propried":U THEN ASSIGN pFieldValue = RowObject.cod-propried.
        WHEN "cod-pto-coleta":U THEN ASSIGN pFieldValue = RowObject.cod-pto-coleta.
        WHEN "cod-ser-docto-produt":U THEN ASSIGN pFieldValue = RowObject.cod-ser-docto-produt.
        WHEN "des-obs":U THEN ASSIGN pFieldValue = RowObject.des-obs.
        WHEN "hra-coleta":U THEN ASSIGN pFieldValue = RowObject.hra-coleta.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
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
        WHEN "dat-coleta":U THEN ASSIGN pFieldValue = RowObject.dat-coleta.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-trans":U THEN ASSIGN pFieldValue = RowObject.dat-trans.
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
        WHEN "qtd-aferid":U THEN ASSIGN pFieldValue = RowObject.qtd-aferid.
        WHEN "qtd-coleta":U THEN ASSIGN pFieldValue = RowObject.qtd-coleta.
        WHEN "qtd-medid-regua":U THEN ASSIGN pFieldValue = RowObject.qtd-medid-regua.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-temperat":U THEN ASSIGN pFieldValue = RowObject.val-temperat.
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
        WHEN "cdn-compart":U THEN ASSIGN pFieldValue = RowObject.cdn-compart.
        WHEN "cdn-identif":U THEN ASSIGN pFieldValue = RowObject.cdn-identif.
        WHEN "cdn-motiv-nao-coleta":U THEN ASSIGN pFieldValue = RowObject.cdn-motiv-nao-coleta.
        WHEN "cdn-produt-respons":U THEN ASSIGN pFieldValue = RowObject.cdn-produt-respons.
        WHEN "cdn-produt-rural":U THEN ASSIGN pFieldValue = RowObject.cdn-produt-rural.
        WHEN "cdn-repos":U THEN ASSIGN pFieldValue = RowObject.cdn-repos.
        WHEN "cdn-sit":U THEN ASSIGN pFieldValue = RowObject.cdn-sit.
        WHEN "idi-nao-coleta":U THEN ASSIGN pFieldValue = RowObject.idi-nao-coleta.
        WHEN "num-carg":U THEN ASSIGN pFieldValue = RowObject.num-carg.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice produt-carg-id
  Parameters:  
               retorna valor do campo cdn-identif
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-identif LIKE produt-carg.cdn-identif NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-identif = RowObject.cdn-identif.

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
  Purpose:     Reposiciona registro com base no °ndice produt-carg-id
  Parameters:  
               recebe valor do campo cdn-identif
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-identif LIKE produt-carg.cdn-identif NO-UNDO.

    FIND FIRST bfprodut-carg WHERE 
        bfprodut-carg.cdn-identif = pcdn-identif NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfprodut-carg THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfprodut-carg)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNome DBOProgram 
PROCEDURE openQueryCustomNome :
/*------------------------------------------------------------------------------
  Purpose: Retorna os produtores de uma carga filtrados por nome  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR RowObjectZoom.

    DEFINE VARIABLE i-cdn-produt-rural AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-cdn-identif      AS INTEGER NO-UNDO.

    EMPTY TEMP-TABLE RowObjectZoom NO-ERROR.

    FOR EACH produt-carg 
       WHERE produt-carg.num-carg = i-num-carg NO-LOCK,
       FIRST emitente NO-LOCK
       WHERE emitente.cod-emitente = produt-carg.cdn-produt-rural
         AND emitente.nome-abrev  >= c-nome-produt-ini
         AND emitente.nome-abrev  <= c-nome-produt-fim
          BY emitente.nome-abrev:
          
         ASSIGN i-cdn-produt-rural = produt-carg.cdn-produt-rural
                i-cdn-identif      = produt-carg.cdn-identif.
                
         IF l-estab-security-active THEN DO:
            IF NOT CAN-FIND (FIRST tt_estab_ems2
                             WHERE tt_estab_ems2.tta_cod_estab = produt-carg.cod-estabel) THEN
                NEXT.
         END.
         
        IF NOT CAN-FIND(FIRST RowObjectZoom 
                        WHERE RowObjectZoom.cdn-produt-rural = i-cdn-produt-rural
                          AND RowObjectZoom.cdn-identif     <> i-cdn-identif) THEN DO:
            CREATE RowObjectZoom.
            BUFFER-COPY produt-carg TO RowObjectZoom.
        END.
         
    END.
    
    RETURN "OK":U. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNome DBOProgram 
PROCEDURE openQueryCustomProdutor :
/*------------------------------------------------------------------------------
  Purpose: Retorna os produtores de uma carga   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR RowObjectZoom.

    DEFINE VARIABLE i-cdn-produt-rural AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-cdn-identif      AS INTEGER NO-UNDO.

    EMPTY TEMP-TABLE RowObjectZoom NO-ERROR.

    FOR EACH produt-carg 
       WHERE produt-carg.num-carg = i-num-carg 
         AND produt-carg.cdn-produt-rural >= i-cdn-produt-ini
         AND produt-carg.cdn-produt-rural <= i-cdn-produt-fim NO-LOCK,
       FIRST emitente 
       WHERE emitente.cod-emitente = produt-carg.cdn-produt-rural NO-LOCK 
          BY produt-carg.cdn-produt-rural:         
         
         ASSIGN i-cdn-produt-rural = produt-carg.cdn-produt-rural
                i-cdn-identif      = produt-carg.cdn-identif.         
         
         IF l-estab-security-active THEN DO:
            IF NOT CAN-FIND (FIRST tt_estab_ems2
                             WHERE tt_estab_ems2.tta_cod_estab = produt-carg.cod-estabel) THEN
                NEXT.     
         END.
         
        IF NOT CAN-FIND(FIRST RowObjectZoom 
                        WHERE RowObjectZoom.cdn-produt-rural = i-cdn-produt-rural 
                          AND RowObjectZoom.cdn-identif <> i-cdn-identif) THEN DO:
            CREATE RowObjectZoom.
            BUFFER-COPY produt-carg TO RowObjectZoom.
        END.         
    END.
    
    RETURN "OK":U. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNome DBOProgram 
PROCEDURE openQueryNome :
/*------------------------------------------------------------------------------
  Purpose:  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   &scoped-define KEY-PHRASE {&TableName}.num-carg = i-num-carg NO-LOCK, ~
                    FIRST emitente NO-LOCK ~
                    WHERE emitente.cod-emitente = {&TableName}.cdn-produt-rural ~
                      AND emitente.nome-abrev  >= c-nome-produt-ini ~
                      AND emitente.nome-abrev  <= c-nome-produt-fim
                    
    /* inativo */                        
    &Scoped-define BY-ESTAB-IN BY nome-abrev BY cod-estabel
    /* ativo */                 
    &Scoped-define BY-ESTAB-AT BY cod-estabel BY nome-abrev
    
    {include/i-estab-openquery.i}  
    RETURN "OK":U. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryProdutor DBOProgram 
PROCEDURE openQueryProdutor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &scoped-define KEY-PHRASE {&TableName}.cdn-produt-rural >= i-cdn-produt-ini ~
                          AND {&TableName}.cdn-produt-rural <= i-cdn-produt-fim ~
                          AND {&TableName}.num-carg          = i-num-carg NO-LOCK, ~
                    FIRST emitente ~
                    WHERE emitente.cod-emitente = {&TableName}.cdn-produt-rural NO-LOCK
                    
    /* inativo */                        
    &Scoped-define BY-ESTAB-IN BY cdn-produt-rural BY cod-estabel
    /* ativo */                 
    &Scoped-define BY-ESTAB-AT BY cod-estabel BY cdn-produt-rural
    
    {include/i-estab-openquery.i}          
                                  
    RETURN "OK":U. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNome DBOProgram 
PROCEDURE setConstraintNome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-num-carg        AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pc-nome-produt-ini AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-nome-produt-fim AS CHARACTER NO-UNDO.

    ASSIGN i-num-carg        = pi-num-carg
           c-nome-produt-ini = pc-nome-produt-ini
           c-nome-produt-fim = pc-nome-produt-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintProdutor DBOProgram 
PROCEDURE setConstraintProdutor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-num-carg       AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pi-cdn-produt-ini AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pi-cdn-produt-fim AS INTEGER   NO-UNDO.

    ASSIGN i-num-carg       = pi-num-carg     
           i-cdn-produt-ini = pi-cdn-produt-ini
           i-cdn-produt-fim = pi-cdn-produt-fim.

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
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

