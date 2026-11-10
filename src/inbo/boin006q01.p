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
&GLOBAL-DEFINE DBOName              BOIN006Q01 
&GLOBAL-DEFINE DBOVersion           1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName            rat-saldo-terc
&GLOBAL-DEFINE TableLabel           Rateio Saldo Poder Terceiros
&GLOBAL-DEFINE QueryName            qr{&TableName} 

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
{inbo/boin006.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
/* {method/dboqry.i} */
DEFINE QUERY {&QueryName} FOR saldo-terc, {&TableName} SCROLLING.

/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-it-codigo     LIKE rat-saldo-terc.it-codigo    NO-UNDO.
DEFINE VARIABLE i-cod-emitente  LIKE rat-saldo-terc.cod-emitente NO-UNDO.
DEFINE VARIABLE i-tipo-sal-terc LIKE saldo-terc.tipo-sal-terc    NO-UNDO.
DEFINE VARIABLE c-serie-docto   LIKE saldo-terc.serie-docto      NO-UNDO.
DEFINE VARIABLE c-nro-docto     LIKE saldo-terc.nro-docto        NO-UNDO.
DEFINE VARIABLE c-nat-operacao  LIKE saldo-terc.nat-operacao     NO-UNDO.
DEFINE VARIABLE i-sequencia     LIKE saldo-terc.sequencia        NO-UNDO.

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
         HEIGHT             = 11.13
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
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-item-altern":U THEN ASSIGN pFieldValue = RowObject.cod-item-altern.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "des-checksum":U THEN ASSIGN pFieldValue = RowObject.des-checksum.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dt-retorno":U THEN ASSIGN pFieldValue = RowObject.dt-retorno.
        WHEN "dt-vali-lote":U THEN ASSIGN pFieldValue = RowObject.dt-vali-lote.
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
        WHEN "qtd-aloc-trans":U THEN ASSIGN pFieldValue = RowObject.qtd-aloc-trans.
        WHEN "qtd-origin":U THEN ASSIGN pFieldValue = RowObject.qtd-origin.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
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
  Purpose:     Retorna valores dos campos do ¡ndice rat-saldo-terc
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo it-codigo
               retorna valor do campo cod-refer
               retorna valor do campo sequencia
               retorna valor do campo cod-depos
               retorna valor do campo lote
               retorna valor do campo cod-localiz
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE rat-saldo-terc.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE rat-saldo-terc.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE rat-saldo-terc.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE rat-saldo-terc.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE rat-saldo-terc.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE rat-saldo-terc.cod-refer NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE rat-saldo-terc.sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-depos LIKE rat-saldo-terc.cod-depos NO-UNDO.
    DEFINE OUTPUT PARAMETER plote LIKE rat-saldo-terc.lote NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-localiz LIKE rat-saldo-terc.cod-localiz NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           pit-codigo = RowObject.it-codigo
           pcod-refer = RowObject.cod-refer
           psequencia = RowObject.sequencia
           pcod-depos = RowObject.cod-depos
           plote = RowObject.lote
           pcod-localiz = RowObject.cod-localiz.

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
  Purpose:     Reposiciona registro com base no ¡ndice rat-saldo-terc
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo it-codigo
               recebe valor do campo cod-refer
               recebe valor do campo sequencia
               recebe valor do campo cod-depos
               recebe valor do campo lote
               recebe valor do campo cod-localiz
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE rat-saldo-terc.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE rat-saldo-terc.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE rat-saldo-terc.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE rat-saldo-terc.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE rat-saldo-terc.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE rat-saldo-terc.cod-refer NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE rat-saldo-terc.sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pcod-depos LIKE rat-saldo-terc.cod-depos NO-UNDO.
    DEFINE INPUT PARAMETER plote LIKE rat-saldo-terc.lote NO-UNDO.
    DEFINE INPUT PARAMETER pcod-localiz LIKE rat-saldo-terc.cod-localiz NO-UNDO.

    FIND FIRST bfrat-saldo-terc WHERE 
        bfrat-saldo-terc.serie-docto = pserie-docto AND 
        bfrat-saldo-terc.nro-docto = pnro-docto AND 
        bfrat-saldo-terc.cod-emitente = pcod-emitente AND 
        bfrat-saldo-terc.nat-operacao = pnat-operacao AND 
        bfrat-saldo-terc.it-codigo = pit-codigo AND 
        bfrat-saldo-terc.cod-refer = pcod-refer AND 
        bfrat-saldo-terc.sequencia = psequencia AND 
        bfrat-saldo-terc.cod-depos = pcod-depos AND 
        bfrat-saldo-terc.lote = plote AND 
        bfrat-saldo-terc.cod-localiz = pcod-localiz NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrat-saldo-terc THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrat-saldo-terc)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDocto DBOProgram 
PROCEDURE openQueryByDocto :
/*------------------------------------------------------------------------------
  Purpose:     Abre query para retornar todas ocorrencias da rat-saldo-terc com
               item, emitente, s‚rie, documento e natureza de opera‡Æo 
               proveniente da saldo-terc.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName}
        FOR EACH  saldo-terc NO-LOCK
            WHERE saldo-terc.it-codigo     = c-it-codigo   
            AND   saldo-terc.cod-emitente  = i-cod-emitente
            AND   saldo-terc.serie-docto   = c-serie-docto
            AND   saldo-terc.nro-docto     = c-nro-docto   
            AND   saldo-terc.nat-operacao  = c-nat-operacao
            AND   saldo-terc.sequencia     = i-sequencia,
        EACH {&TableName} NO-LOCK
            WHERE {&TableName}.serie-docto  = saldo-terc.serie-docto
            AND   {&TableName}.nro-docto    = saldo-terc.nro-docto
            AND   {&TableName}.cod-emitente = saldo-terc.cod-emitente
            AND   {&TableName}.nat-operacao = saldo-terc.nat-operacao
            AND   {&TableName}.it-codigo    = saldo-terc.it-codigo
            AND   {&TableName}.cod-refer    = saldo-terc.cod-refer
            AND   {&TableName}.sequencia    = saldo-terc.sequencia.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByLotDetails DBOProgram 
PROCEDURE openQueryByLotDetails :
/*------------------------------------------------------------------------------
  Purpose:     Abre query para retornar todas ocorrencias da rat-saldo-terc com
               item, emitente e tipo de saldo proveniente da saldo-terc.
  Parameters:  c-it-codigo -> C¢digo do item;    
               i-cod-emitente -> C¢digo do emitente;
               i-tipo-sal-terc -> C¢digo do tipo de saldo em terceiros;
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName}
        FOR EACH  saldo-terc NO-LOCK
            WHERE saldo-terc.it-codigo     = c-it-codigo    
            AND   saldo-terc.cod-emitente  = i-cod-emitente 
            AND   saldo-terc.tipo-sal-terc = i-tipo-sal-terc,
        EACH {&TableName} NO-LOCK
            WHERE {&TableName}.serie-docto  = saldo-terc.serie-docto
            AND   {&TableName}.nro-docto    = saldo-terc.nro-docto
            AND   {&TableName}.cod-emitente = saldo-terc.cod-emitente
            AND   {&TableName}.nat-operacao = saldo-terc.nat-operacao
            AND   {&TableName}.it-codigo    = saldo-terc.it-codigo
            AND   {&TableName}.cod-refer    = saldo-terc.cod-refer
            AND   {&TableName}.sequencia    = saldo-terc.sequencia.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByDocto DBOProgram 
PROCEDURE setConstraintByDocto :
/*------------------------------------------------------------------------------
  Purpose:     Seta restri‡Æo para pesquisa dos lotes/referˆncia por documento.
  Parameters:  p-c-it-codigo -> C¢digo do item;
               p-i-cod-emitente -> C¢digo do emitente;
               p-c-serie-docto -> S‚rie do documento;
               p-c-nro-docto -> N£mero do documento;
               p-c-nat-operacao -> Natureza de opera‡Æo do documento;
  Notes:       
------------------------------------------------------------------------------*/
    
   DEFINE INPUT PARAMETER p-c-it-codigo    LIKE rat-saldo-terc.it-codigo    NO-UNDO.
   DEFINE INPUT PARAMETER p-i-cod-emitente LIKE rat-saldo-terc.cod-emitente NO-UNDO.
   DEFINE INPUT PARAMETER p-c-serie-docto  LIKE rat-saldo-terc.serie-docto  NO-UNDO.
   DEFINE INPUT PARAMETER p-c-nro-docto    LIKE rat-saldo-terc.nro-docto    NO-UNDO.
   DEFINE INPUT PARAMETER p-c-nat-operacao LIKE rat-saldo-terc.nat-operacao NO-UNDO.
   DEFINE INPUT PARAMETER p-i-sequencia    LIKE rat-saldo-terc.sequencia    NO-UNDO.
   
   ASSIGN c-it-codigo    = p-c-it-codigo
          i-cod-emitente = p-i-cod-emitente
          c-serie-docto  = p-c-serie-docto
          c-nro-docto    = p-c-nro-docto
          c-nat-operacao = p-c-nat-operacao
          i-sequencia    = p-i-sequencia.
    
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByLotDetails DBOProgram 
PROCEDURE setConstraintByLotDetails :
/*------------------------------------------------------------------------------
  Purpose:     Seta restri‡Æo para pesquisa.
  Parameters:  p-c-it-codigo -> C¢digo do item;
               p-i-cod-emitente -> C¢digo do emitente;
               p-i-tipo-sal-terc -> C¢digo do tipo de saldo em terceiros;
  Notes:       
------------------------------------------------------------------------------*/
    
   DEFINE INPUT PARAMETER p-c-it-codigo     LIKE rat-saldo-terc.it-codigo    NO-UNDO.
   DEFINE INPUT PARAMETER p-i-cod-emitente  LIKE rat-saldo-terc.cod-emitente NO-UNDO.
   DEFINE INPUT PARAMETER p-i-tipo-sal-terc LIKE saldo-terc.tipo-sal-terc    NO-UNDO.

   ASSIGN c-it-codigo     = p-c-it-codigo. 
   ASSIGN i-cod-emitente  = p-i-cod-emitente.
   ASSIGN i-tipo-sal-terc = p-i-tipo-sal-terc.
    
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
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

