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
{include/i-prgvrs.i BOCX00443 2.00.00.013 } /*** "010013" 11/12/2023 10:13:19 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx00443 MUT}
&ENDIF
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOCX00443
&GLOBAL-DEFINE DBOVersion 2.0
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName adiant-despes-parc
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
{cxbo/bocx00443.i RowObject}
{cxbo/bocx00443.i tt-adiant-despes-parc}
{imp/im0720b.i}

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE ccod-estabel  LIKE adiant-despes.cod-estabel    NO-UNDO.
DEFINE VARIABLE de-cdd-adiant LIKE adiant-despes.cdd-adiant     NO-UNDO.
DEFINE VARIABLE ccod-refer    LIKE adiant-despes-parc.cod-refer NO-UNDO.
DEFINE VARIABLE h-bocx250     AS HANDLE                         NO-UNDO.
DEFINE VARIABLE l-im0720d     AS LOGICAL     INITIAL NO         NO-UNDO.
DEFINE VARIABLE c-cod-parcela-ini      AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-cod-parcela-fim      AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-cod-espec-docto-ini  AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-cod-espec-docto-fim  AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-cod-ser-docto-ini    AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-cod-ser-docto-fim    AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-cod-refer-ini        AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-cod-refer-fim        AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-cod-tit-ap-ini       AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-cod-tit-ap-fim       AS CHARACTER             NO-UNDO.
DEFINE VARIABLE dt-dat-emissao-ini     AS DATE                  NO-UNDO.
DEFINE VARIABLE dt-dat-emissao-fim     AS DATE                  NO-UNDO.
DEFINE VARIABLE dt-dat-vencto-ini      AS DATE                  NO-UNDO.
DEFINE VARIABLE dt-dat-vencto-fim      AS DATE                  NO-UNDO.
DEFINE VARIABLE de-val-adiant-moed-ini AS DECIMAL               NO-UNDO.
DEFINE VARIABLE de-val-adiant-moed-fim AS DECIMAL               NO-UNDO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaParcelaAtual DBOProgram 
PROCEDURE buscaParcelaAtual :
/*-----------------------------------------*-------------------------------------
  Purpose:     Respons vel por buscar a parcela atual para incrementar ao atualizar 
               no browser do im0720d
  Parameters:  Entrada: Esp‚cie, S‚rie, T¡tulo e Fornecedor.
               Sa¡da: Parcela atual
  Notes:       No Financeiro, existe valida‡Æo do adiantamento contra essas 
               informa‡äes (esp‚cie, s‚rie, t¡tulo, parcela e fornecedor). 
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pc-cod-espec-docto LIKE adiant-despes-parc.cod-espec-docto NO-UNDO.
DEFINE INPUT  PARAMETER pc-cod-ser-docto   LIKE adiant-despes-parc.cod-ser-docto   NO-UNDO.
DEFINE INPUT  PARAMETER pc-cod-tit-ap      LIKE adiant-despes-parc.cod-tit-ap      NO-UNDO.
DEFINE INPUT  PARAMETER pi-cdn-emitente    LIKE adiant-despes-parc.cdn-emitente    NO-UNDO.
DEFINE OUTPUT PARAMETER pc-parcela-atu    LIKE adiant-despes-parc.cod-parcela     NO-UNDO.

    FOR LAST {&tableName} NO-LOCK
       WHERE {&tableName}.cod-espec-docto = pc-cod-espec-docto
         AND {&tableName}.cod-ser-docto   = pc-cod-ser-docto  
         AND {&tableName}.cod-tit-ap      = pc-cod-tit-ap     
         AND {&tableName}.cdn-emitente    = pi-cdn-emitente   
        BY {&tableName}.cod-parcela:
        ASSIGN pc-parcela-atu = {&tableName}.cod-parcela.
    END.
    IF NOT AVAIL {&tableName} THEN
       ASSIGN pc-parcela-atu = "01":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaProximaParcela DBOProgram 
PROCEDURE buscaProximaParcela :
/*-----------------------------------------*-------------------------------------
  Purpose:     Respons vel por sugerir a pr¢xima parcela de acordo com a chave do 
               t¡tulo. 
  Parameters:  Entrada: Esp‚cie, S‚rie, T¡tulo e Fornecedor.
               Sa¡da: Nova parcela 
  Notes:       No Financeiro, existe valida‡Æo do adiantamento contra essas 
               informa‡äes (esp‚cie, s‚rie, t¡tulo, parcela e fornecedor). 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-espec-docto LIKE adiant-despes-parc.cod-espec-docto NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-ser-docto   LIKE adiant-despes-parc.cod-ser-docto   NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-tit-ap      LIKE adiant-despes-parc.cod-tit-ap      NO-UNDO.
    DEFINE INPUT PARAMETER pi-cdn-emitente    LIKE adiant-despes-parc.cdn-emitente    NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-new-parcela    LIKE adiant-despes-parc.cod-parcela     NO-UNDO.

    FOR LAST {&tableName} NO-LOCK
       WHERE {&tableName}.cod-espec-docto = pc-cod-espec-docto
         AND {&tableName}.cod-ser-docto   = pc-cod-ser-docto  
         AND {&tableName}.cod-tit-ap      = pc-cod-tit-ap     
         AND {&tableName}.cdn-emitente    = pi-cdn-emitente   
        BY {&tableName}.cod-parcela:

        IF INT({&tableName}.cod-parcela) < 9 THEN DO:
            ASSIGN pc-new-parcela = "0":U + STRING(INT({&tableName}.cod-parcela) + 1).
        END.
        ELSE DO:
            ASSIGN pc-new-parcela = STRING(INT({&tableName}.cod-parcela) + 1).
        END.
    END.
    IF NOT AVAIL {&tableName} THEN
       ASSIGN pc-new-parcela = "01":U.

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
        WHEN "cod-espec-docto":U THEN ASSIGN pFieldValue = RowObject.cod-espec-docto.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-parcela":U THEN ASSIGN pFieldValue = RowObject.cod-parcela.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-ser-docto":U THEN ASSIGN pFieldValue = RowObject.cod-ser-docto.
        WHEN "cod-tit-ap":U THEN ASSIGN pFieldValue = RowObject.cod-tit-ap.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
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
        WHEN "dat-emissao":U THEN ASSIGN pFieldValue = RowObject.dat-emissao.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-pagto":U THEN ASSIGN pFieldValue = RowObject.dat-pagto.
        WHEN "dat-prev-pagto":U THEN ASSIGN pFieldValue = RowObject.dat-prev-pagto.
        WHEN "dat-vencto":U THEN ASSIGN pFieldValue = RowObject.dat-vencto.
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
        WHEN "cdd-adiant":U THEN ASSIGN pFieldValue = RowObject.cdd-adiant.
        WHEN "val-adiant":U THEN ASSIGN pFieldValue = RowObject.val-adiant.
        WHEN "val-adiant-moed":U THEN ASSIGN pFieldValue = RowObject.val-adiant-moed.
        WHEN "val-adiant-orig":U THEN ASSIGN pFieldValue = RowObject.val-adiant-orig.
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
        WHEN "cdn-emitente":U THEN ASSIGN pFieldValue = RowObject.cdn-emitente.
        WHEN "cdn-moeda":U THEN ASSIGN pFieldValue = RowObject.cdn-moeda.
        WHEN "idi-situacao":U THEN ASSIGN pFieldValue = RowObject.idi-situacao.
        WHEN "idi-valor":U THEN ASSIGN pFieldValue = RowObject.idi-valor.
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
  Purpose:     Retorna valores dos campos do ¡ndice adntdspa_id2
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo cod-refer
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE adiant-despes-parc.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE adiant-despes-parc.cod-refer NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pcod-refer = RowObject.cod-refer.

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
        WHEN "log-gerou-tit-ap":U THEN ASSIGN pFieldValue = RowObject.log-gerou-tit-ap.
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
  Purpose:     Reposiciona registro com base no ¡ndice adntdspa_id2
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cod-refer
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE adiant-despes-parc.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE adiant-despes-parc.cod-refer NO-UNDO.

    FIND FIRST bfadiant-despes-parc WHERE 
        bfadiant-despes-parc.cod-estabel = pcod-estabel AND 
        bfadiant-despes-parc.cod-refer = pcod-refer NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfadiant-despes-parc THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfadiant-despes-parc)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyAdiant DBOProgram 
PROCEDURE goToKeyAdiant :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice adntdspa_id2
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cod-refer
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE adiant-despes-parc.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pde-cdd-adiant LIKE adiant-despes-parc.cdd-adiant NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE adiant-despes-parc.cod-refer NO-UNDO.


    FIND FIRST bfadiant-despes-parc WHERE 
        bfadiant-despes-parc.cod-estabel = pcod-estabel AND 
        bfadiant-despes-parc.cod-refer = pcod-refer AND 
        bfadiant-despes-parc.cdd-adiant = pde-cdd-adiant NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfadiant-despes-parc THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfadiant-despes-parc)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyParcela DBOProgram 
PROCEDURE goToKeyParcela :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice adntdspa_id4
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cdd-adiant
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE adiant-despes-parc.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-adiant  LIKE adiant-despes-parc.cdd-adiant  NO-UNDO.

    FIND FIRST bfadiant-despes-parc WHERE 
        bfadiant-despes-parc.cod-estabel = pcod-estabel AND 
        bfadiant-despes-parc.cdd-adiant  = pcdd-adiant  NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfadiant-despes-parc THEN 
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToAdiantDespes DBOProgram 
PROCEDURE linkToAdiantDespes :
/*------------------------------------------------------------------------------
  Purpose:     Procedure utilizada para relacionar o registro pai x registro filho
               na abertura da query e navega‡Æo.
  Parameters:  Entrada: Handle da DBO Pai
  Notes:       Utilizada no programa principal IM0720.w
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM ph-adiant-despes AS HANDLE NO-UNDO.

    RUN getKey IN ph-adiant-despes (OUTPUT ccod-estabel,
                                    OUTPUT de-cdd-adiant).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAdiantamento DBOProgram 
PROCEDURE openQueryAdiantamento :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query de acordo com estabelecimento e adiantamento
  Parameters:  <none>
  Notes:       Utilizada no programa principal IM0720.w
------------------------------------------------------------------------------*/
    
    OPEN QUERY {&QUERYNAME} FOR EACH {&TableName} NO-LOCK
         WHERE {&tableName}.cod-estabel = ccod-estabel
           AND {&tableName}.cdd-adiant  = de-cdd-adiant
            BY {&tableName}.cod-espec-docto
            BY {&tableName}.cod-ser-docto
            BY {&tableName}.cod-tit-ap
            BY {&tableName}.cod-parcela.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFilter DBOProgram 
PROCEDURE openQueryFilter :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query de acordo com os parametros passados no filtro 
  Parameters:  <none>
  Notes:       Utilizada no programa principal IM0721.w botao de filtro
------------------------------------------------------------------------------*/
    
    OPEN QUERY {&QUERYNAME} FOR EACH {&TableName} NO-LOCK
         WHERE {&tableName}.cod-estabel       = ccod-estabel
           AND {&tableName}.cdd-adiant        = de-cdd-adiant
           AND {&tableName}.cod-refer        >= c-cod-refer-ini
           AND {&tableName}.cod-refer        <= c-cod-refer-fim
           AND {&tableName}.cod-espec-docto  >= c-cod-espec-docto-ini
           AND {&tableName}.cod-espec-docto  <= c-cod-espec-docto-fim
           AND {&tableName}.cod-ser-docto    >= c-cod-ser-docto-ini
           AND {&tableName}.cod-ser-docto    <= c-cod-ser-docto-fim
           AND {&tableName}.cod-tit-ap       >= c-cod-tit-ap-ini
           AND {&tableName}.cod-tit-ap       <= c-cod-tit-ap-fim
           AND {&tableName}.cod-parcela      >= c-cod-parcela-ini
           AND {&tableName}.cod-parcela      <= c-cod-parcela-fim
           AND {&tableName}.val-adiant-moed  >= de-val-adiant-moed-ini
           AND {&tableName}.val-adiant-moed  <= de-val-adiant-moed-fim
           AND {&tableName}.dat-emissao      >= dt-dat-emissao-ini
           AND {&tableName}.dat-emissao      <= dt-dat-emissao-fim
           AND {&tableName}.dat-vencto       >= dt-dat-vencto-ini
           AND {&tableName}.dat-vencto       <= dt-dat-vencto-fim .

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura de todos os registros da query
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TableName} NO-LOCK.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE picriaReferencia DBOProgram 
PROCEDURE picriaReferencia :
/*------------------------------------------------------------------------------
  Purpose:     Gerar referˆncia £nica para o estabelecimento  
  Parameters:  Entrada: Estabelecimento
               Sa¡da: Referˆncia retornada pelo Financeiro
  Notes:       Utilizada no programa IM0720A e bocx00442.p
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pc-cod-estabel LIKE adiant-despes.cod-estabel    NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-cod-refer   LIKE adiant-despes-parc.cod-refer NO-UNDO.

    DEFINE VARIABLE c-lista        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE dt-aux         AS DATETIME    NO-UNDO.
    DEFINE VARIABLE i-ano          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-minutos      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-segundos     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE h-apb739ze     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE l-refer-unica  AS LOGICAL     INITIAL NO NO-UNDO.

    IF  NOT VALID-HANDLE(h-apb739ze) THEN
        RUN prgfin/apb/apb739ze.py PERSISTENT SET h-apb739ze.

    ASSIGN c-lista = "1;2;3;4;5;6;7;8;9;A;B;C;D;E;F;G;H;I;J;K;L;M;N;O;P;Q;R;S;T;U;V;W;X;Y;Z".

    REPEAT WHILE l-refer-unica = NO:
        /* DM (dia, mˆs com 1 caracter da lista) */
        ASSIGN pc-cod-refer = "I":U 
               pc-cod-refer = pc-cod-refer + ENTRY(MONTH(TODAY), c-lista, ";").
    
        /* A (ano onde busca os dois £ltimos caracteres e busca na lista)*/
        ASSIGN i-ano = INT(ENTRY(3, STRING(TODAY, "99/99/99":U), "/")).
    
        IF  i-ano > 35 THEN DO:
            bl-ano:
            REPEAT:
                ASSIGN i-ano = i-ano - 35.
                IF  i-ano <= 35 THEN 
                    LEAVE bl-ano.
            END.
        END.
    
        ASSIGN pc-cod-refer = pc-cod-refer + STRING(ENTRY(i-ano, c-lista, ";")).
    
        /* H (hora com um caracter da lista) */
        ASSIGN pc-cod-refer = pc-cod-refer + ENTRY(INTEGER(SUBSTRING(STRING(TIME,"hh:mm"),1,2)) + 1, c-lista, ";").
    
        /* SSS (soma dos minutos com os segundos) */
        ASSIGN i-minutos = INTEGER(SUBSTRING(STRING(TIME,"hh:mm"),4,2)).
    
        ASSIGN i-segundos = INTEGER(SUBSTRING(STRING(TIME,"hh:mm:ss"),7,2)).
    
        ASSIGN pc-cod-refer = pc-cod-refer + STRING(INTEGER(i-minutos + i-segundos)).
    
        IF SESSION:NUMERIC-FORMAT = "AMERICAN":U THEN DO:
                /* MMM (milesimos)*/
                ASSIGN dt-aux    = DATETIME(TODAY, MTIME)
                       pc-cod-refer = pc-cod-refer + ENTRY(2, STRING(dt-aux) , ".").
        END.
        ELSE DO:
                /* MMM (milesimos)*/
                ASSIGN dt-aux    = DATETIME(TODAY, MTIME)
                       pc-cod-refer = pc-cod-refer + ENTRY(2, STRING(dt-aux) , ",").
        END.
        RUN pi_verifica_refer_unica_apb IN h-apb739ze (INPUT  pc-cod-estabel,
                                                       INPUT  pc-cod-refer,
                                                       INPUT  "":U,
                                                       INPUT  ?,
                                                       OUTPUT l-refer-unica).
    END.

    IF  VALID-HANDLE(h-apb739ze) THEN DO:
        DELETE PROCEDURE h-apb739ze.
        ASSIGN h-apb739ze = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaSituacaoAPB DBOProgram 
PROCEDURE piRetornaSituacaoAPB :
/*------------------------------------------------------------------------------
  Purpose:     Retorna a situa‡Æo do t¡tulo de Antecipa‡Æo no Financeiro
  Parameters:  Entrada: Estabelecimento e Referˆncia (chaves da tabela antecip_pef_pend)
  Notes:       A situa‡Æo ‚ poss¡vel de consultar via apb701aa.p
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-cod-estabel  LIKE adiant-despes.cod-estabel    NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-refer    LIKE adiant-despes-parc.cod-refer NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-emitente LIKE adiant-despes.cdn-emitente   NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-situacao     AS   CHARACTER                    NO-UNDO.
    DEFINE OUTPUT PARAMETER l-gerou-apb     AS   LOGICAL                      NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_retorno_antecip_pef_pend.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_log_erro.

    DEFINE VARIABLE v_hld_api  AS HANDLE      NO-UNDO.

    IF NOT VALID-HANDLE(v_hld_api) THEN DO:
        RUN prgfin/acr/acr933zb.py PERSISTENT SET v_hld_api.
    END.

    EMPTY TEMP-TABLE tt_consult_antecip_pef_pend.
    EMPTY TEMP-TABLE tt_retorno_antecip_pef_pend.
        
    /*apenas cria temp-table passando estabelecimento e referencia 
      >> chave da tabela das antecipacoes no financeiro*/
    CREATE tt_consult_antecip_pef_pend.
    ASSIGN tt_consult_antecip_pef_pend.ttv_num_tip_leitura      = 1
           tt_consult_antecip_pef_pend.tta_cod_estab            = pc-cod-estabel
           tt_consult_antecip_pef_pend.tta_cod_espec_docto      = ""
           tt_consult_antecip_pef_pend.tta_cod_ser_docto        = ""
           tt_consult_antecip_pef_pend.tta_cod_tit_ap           = ""
           tt_consult_antecip_pef_pend.tta_cod_parcela          = ""
           tt_consult_antecip_pef_pend.tta_cdn_fornecedor       = pi-cod-emitente
           tt_consult_antecip_pef_pend.ttv_row_antecip_pef_pend = ?
           tt_consult_antecip_pef_pend.tta_cod_refer            = pc-cod-refer
           tt_consult_antecip_pef_pend.tta_dat_vencto_tit_ap    = ?
           tt_consult_antecip_pef_pend.tta_val_tit_ap           = 0.

    RUN pi_funcao_integracao        IN v_hld_api (INPUT "Recebimento 2.00":U).

    RUN pi_consult_antecip_pef_pend IN v_hld_api (INPUT  TABLE tt_consult_antecip_pef_pend,
                                                  OUTPUT TABLE tt_retorno_antecip_pef_pend,
                                                  OUTPUT TABLE tt_log_erro).
    

    IF VALID-HANDLE(v_hld_api) THEN DO:
        DELETE PROCEDURE v_hld_api.
        ASSIGN v_hld_api = ?.
    END.

    FIND FIRST tt_retorno_antecip_pef_pend
         WHERE tt_retorno_antecip_pef_pend.cod_estab  = pc-cod-estabel
           AND tt_retorno_antecip_pef_pend.cod_refer  = pc-cod-refer  NO-LOCK NO-ERROR.
    IF AVAIL tt_retorno_antecip_pef_pend THEN
        ASSIGN pc-situacao  = tt_retorno_antecip_pef_pend.ind_sit_pef_antecip
               l-gerou-apb = YES.
    ELSE DO:
        IF CAN-FIND(FIRST tt_log_erro) THEN DO:
            {utp/ut-liter.i NÆo_Gerado * R}         
            ASSIGN pc-situacao  = TRIM(RETURN-VALUE)
                   l-gerou-apb = NO.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaValidacao DBOProgram 
PROCEDURE piSetaValidacao :
/*------------------------------------------------------------------------------
  Purpose:     Controlar a valida‡Æo 428 da validateRecord, para que nÆo seja emitida
               quando o usu rio marcar no im0720d se deseja atualizar ou adicionar o valor
               na antecipa‡Æo selecionada.
  Parameters:  Entrada: pl-im0720d
  Notes:       Se "sim", foi executado pelo IM0720d e nÆo pode executar a valida‡Æo 428.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-im0720d AS LOGICAL NO-UNDO.

    ASSIGN l-im0720d = pl-im0720d.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSomatoriaAdiantParc DBOProgram 
PROCEDURE piSomatoriaAdiantParc :
/*------------------------------------------------------------------------------
  Purpose:     Realiza o somat¢rio de todas as parcelas do adiantamento.
  Parameters:  Entrada: Estabelecimento, Adiantamento e referˆncia
               Sa¡da: Soma dos valores adiantados das parcelas
  Notes:       Utilizado para validar o valor original da antecipa‡Æo (cabe‡alho) versus 
               somat¢ria das parcelas contra o Percentual de varia‡Æo permitido noIM0000
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-cod-estabel LIKE adiant-despes-parc.cod-estabel      NO-UNDO.
    DEFINE INPUT  PARAMETER pde-cdd-adiant LIKE adiant-despes-parc.cdd-adiant       NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-refer     LIKE adiant-despes-parc.cod-refer        NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-total      LIKE adiant-despes-parc.val-adiant-moed  NO-UNDO.

    ASSIGN pde-total = 0.

    FOR EACH bf{&tableName}
       WHERE bf{&tableName}.cod-estabel = pc-cod-estabel 
         AND bf{&tableName}.cdd-adiant  = pde-cdd-adiant 
         AND bf{&tableName}.cod-refer   <> pcod-refer NO-LOCK:
        ASSIGN pde-total = pde-total + bf{&tableName}.val-adiant-moed.
    END.
   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaValorParcela DBOProgram 
PROCEDURE piVerificaValorParcela :
/*:T------------------------------------------------------------------------------
  Purpose:     Verifica valor da parcela de acordo com as listas de mercadoria 
               vinculadas, para verificar se a parcela tamb‚m dever  ser eliminada
  Parameters:  Estabelecimento, Adiantamento e Referˆncia
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pc-cod-estabel LIKE adiant-despes-parc.cod-estabel      NO-UNDO.   
    DEFINE INPUT  PARAMETER pde-cdd-adiant LIKE adiant-despes-parc.cdd-adiant       NO-UNDO.   
    DEFINE INPUT  PARAMETER pc-cod-refer   LIKE adiant-despes-parc.cod-refer        NO-UNDO.   
    DEFINE OUTPUT PARAMETER pde-saldo      LIKE adiant-despes-parc.val-adiant-moed   NO-UNDO.

    DEFINE VARIABLE de-val-adiant-moed LIKE adiant-despes-parc.val-adiant-moed NO-UNDO.

    ASSIGN de-val-adiant-moed = 0.
    FIND FIRST adiant-despes-parc
         WHERE adiant-despes-parc.cod-estabel = pc-cod-estabel
           AND adiant-despes-parc.cdd-adiant  = pde-cdd-adiant
           AND adiant-despes-parc.cod-refer   = pc-cod-refer  NO-LOCK NO-ERROR.
    IF AVAIL adiant-despes-parc THEN DO:
        ASSIGN de-val-adiant-moed = adiant-despes-parc.val-adiant-moed.

        /*verifica se existe ainda alguma lista referente …quela parcela para verificar o saldo*/
        FOR EACH adiant-despes-lista NO-LOCK
           WHERE adiant-despes-lista.cod-estabel = pc-cod-estabel
             AND adiant-despes-lista.cdd-adiant  = pde-cdd-adiant
             AND adiant-despes-lista.cod-refer   = pc-cod-refer:
            ASSIGN pde-saldo = de-val-adiant-moed - adiant-despes-lista.val-adiant-moed.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFilter DBOProgram 
PROCEDURE setConstraintFilter :
/*------------------------------------------------------------------------------
  Purpose:     Seta os parametros para abertura da query "filter".
  Parameters:  Entrada: Parcela, Espécie, Série, Data Emissao, Data vencimento,
                        Referˆncia, Titulo, Valor
  Notes: Para todos os valores de entrada de parametros deve-se passar uma faixa
         (valor inicial e final. Ex.: cod-estabel-ini, cod-estabel-fim)      
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-refer-ini        AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-refer-fim        AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-espec-docto-ini  AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-espec-docto-fim  AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-ser-docto-ini    AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-ser-docto-fim    AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-tit-ap-ini       AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-tit-ap-fim       AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-parcela-ini      AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-parcela-fim      AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pdt-dat-emissao-ini     AS DATE         NO-UNDO.
    DEFINE INPUT PARAMETER pdt-dat-emissao-fim     AS DATE         NO-UNDO.
    DEFINE INPUT PARAMETER pdt-dat-vencto-ini      AS DATE         NO-UNDO.
    DEFINE INPUT PARAMETER pdt-dat-vencto-fim      AS DATE         NO-UNDO.
    DEFINE INPUT PARAMETER pde-val-adiant-moed-ini AS DECIMAL      NO-UNDO.
    DEFINE INPUT PARAMETER pde-val-adiant-moed-fim AS DECIMAL      NO-UNDO.


    ASSIGN c-cod-refer-ini        = pc-cod-refer-ini      
           c-cod-refer-fim        = pc-cod-refer-fim      
           c-cod-espec-docto-ini  = pc-cod-espec-docto-ini
           c-cod-espec-docto-fim  = pc-cod-espec-docto-fim
           c-cod-ser-docto-ini    = pc-cod-ser-docto-ini  
           c-cod-ser-docto-fim    = pc-cod-ser-docto-fim  
           c-cod-tit-ap-ini       = pc-cod-tit-ap-ini     
           c-cod-tit-ap-fim       = pc-cod-tit-ap-fim     
           c-cod-parcela-ini      = pc-cod-parcela-ini    
           c-cod-parcela-fim      = pc-cod-parcela-fim    
           dt-dat-emissao-ini     = pdt-dat-emissao-ini   
           dt-dat-emissao-fim     = pdt-dat-emissao-fim   
           dt-dat-vencto-ini      = pdt-dat-vencto-ini    
           dt-dat-vencto-fim      = pdt-dat-vencto-fim    
           de-val-adiant-moed-ini = pde-val-adiant-moed-ini    
           de-val-adiant-moed-fim = pde-val-adiant-moed-fim.    


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
    
    DEFINE VARIABLE i-aux             AS   INTEGER                            NO-UNDO.
    DEFINE VARIABLE c-liter           AS   CHARACTER                          NO-UNDO.
    DEFINE VARIABLE c-liter-est       AS   CHARACTER                          NO-UNDO.
    DEFINE VARIABLE c-liter-adiant    AS   CHARACTER                          NO-UNDO.
    DEFINE VARIABLE c-return1         AS   CHARACTER                          NO-UNDO.
    DEFINE VARIABLE c-return2         AS   CHARACTER                          NO-UNDO.
    DEFINE VARIABLE c-return3         AS   CHARACTER                          NO-UNDO.
    DEFINE VARIABLE c-situacao        AS   CHARACTER                          NO-UNDO.
    DEFINE VARIABLE l-gerou-apb       AS   LOGICAL                            NO-UNDO.
    DEFINE VARIABLE de-total          LIKE adiant-despes-parc.val-adiant-moed NO-UNDO.
    DEFINE VARIABLE de-perc-antecip   LIKE param-imp.perc-max-antecip         NO-UNDO.
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/

    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
        ASSIGN i-aux = INT(RowObject.cod-parcela) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            {utp/ut-liter.i Parcela * R }
            {method/svc/errors/inserr.i
                &ErrorNumber="32125"
                &ErrorType="EMS"
                &ErrorSubType="Error"
                &ErrorParameters="RETURN-VALUE"}
        END.
        ELSE 
            IF pType = "CREATE":U THEN DO:
                IF CAN-FIND(FIRST bf{&tableName}
                            WHERE bf{&tableName}.cod-estabel = RowObject.cod-estabel
                              AND bf{&tableName}.cod-refer   = RowObject.cod-refer) THEN DO:
                    {utp/ut-liter.i Adiantamento * R }
                    {method/svc/errors/inserr.i &ErrorNumber="7"
                                                &ErrorType="EMS"
                                                &ErrorSubType="Error"
                                                &ErrorParameters="RETURN-VALUE"}
                END.
                IF RowObject.dat-prev-pagto = ? 
                OR RowObject.dat-prev-pagto < TODAY THEN DO:
                    {utp/ut-liter.i PrevisÆo_de_Pagamento * R }
                    {method/svc/errors/inserr.i &ErrorNumber="55021"
                                                &ErrorType="EMS"
                                                &ErrorSubType="Error"
                                                &ErrorParameters="RETURN-VALUE"}
                END.
        
                IF  RowObject.dat-vencto <> ? 
                AND RowObject.dat-vencto < TODAY THEN DO:
                    {utp/ut-liter.i Data_de_Vencimento * R }
                    {method/svc/errors/inserr.i &ErrorNumber="55021"
                                                &ErrorType="EMS"
                                                &ErrorSubType="Error"
                                                &ErrorParameters="RETURN-VALUE"}
                END.
        END.

        IF NOT l-im0720d THEN DO:
            IF CAN-FIND(FIRST bf{&tableName}
                        WHERE bf{&tableName}.cod-espec-docto = RowObject.cod-espec-docto
                          AND bf{&tableName}.cod-ser-docto   = RowObject.cod-ser-docto
                          AND bf{&tableName}.cod-tit-ap      = RowObject.cod-tit-ap
                          AND bf{&tableName}.cod-parcela     = RowObject.cod-parcela
                          AND bf{&tableName}.cdn-emitente    = RowObject.cdn-emitente
                          AND ROWID(bf{&tableName})          <> RowObject.r-rowid) THEN DO:
                FIND FIRST bf{&tableName}
                     WHERE bf{&tableName}.cod-espec-docto = RowObject.cod-espec-docto
                       AND bf{&tableName}.cod-ser-docto   = RowObject.cod-ser-docto
                       AND bf{&tableName}.cod-tit-ap      = RowObject.cod-tit-ap   
                       AND bf{&tableName}.cod-parcela     = RowObject.cod-parcela  
                       AND bf{&tableName}.cdn-emitente    = RowObject.cdn-emitente
                       AND ROWID(bf{&tableName})          <> RowObject.r-rowid NO-LOCK NO-ERROR.
                IF AVAIL bf{&tableName} THEN DO:
                    {utp/ut-liter.i Estabelecimento * R}
                    ASSIGN c-liter-est = TRIM(RETURN-VALUE).
                    {utp/ut-liter.i Antecipa‡Æo * R}
                    ASSIGN c-liter-adiant = TRIM(RETURN-VALUE).
                    ASSIGN c-return1 = c-liter-est + ": " + bf{&tableName}.cod-estabel + " , " + c-liter-adiant + ": " + STRING(bf{&tableName}.cdd-adiant).
    
                    {utp/ut-liter.i Parcela * R }
                    ASSIGN c-liter = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="428"
                                                &ErrorType="EMS"
                                                &ErrorSubType="Error"
                                                &ErrorParameters="c-liter + '~~~~' + c-return1"}
                END.
            END.
        END.

        IF RowObject.cod-tit-ap = "":U THEN DO:
           {utp/ut-liter.i T¡tulo * L}    
           {method/svc/errors/inserr.i &ErrorNumber="265"
                                       &ErrorType="EMS"
                                       &ErrorSubType="Error"
                                       &ErrorParameters="RETURN-VALUE"}
        end.


        IF RowObject.cod-espec-docto = "":U THEN DO:
           {utp/ut-liter.i Esp‚cie * L}    
           {method/svc/errors/inserr.i &ErrorNumber="265"
                                       &ErrorType="EMS"
                                       &ErrorSubType="Error"
                                       &ErrorParameters="RETURN-VALUE"}
        end.
        ELSE IF CAN-FIND(FIRST espec-ap 
                         WHERE espec-ap.cod-esp = rowObject.cod-espec-docto
                           AND espec-ap.tipo <> 2) THEN DO:
            {utp/ut-liter.i Esp‚cie_T¡tulo_Antecipa‡Æo * L}
            {method/svc/errors/inserr.i &ErrorNumber="144"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="RETURN-VALUE"}
        END.
        ELSE DO:
            IF NOT CAN-FIND(FIRST espec-ap 
                            WHERE espec-ap.cod-esp = RowObject.cod-espec-docto) THEN DO:
               {utp/ut-liter.i Esp‚cie_Antecipa‡Æo * L}
               {method/svc/errors/inserr.i &ErrorNumber="2"
                                           &ErrorType="EMS"
                                           &ErrorSubType="Error"
                                           &ErrorParameters="RETURN-VALUE"}
            END.
        END.

        IF NOT CAN-FIND (FIRST serie 
                         WHERE serie.serie = RowObject.cod-ser-docto) THEN DO:
            {utp/ut-liter.i S‚rie * L}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="RETURN-VALUE"}
        END.
        ELSE DO:
             FOR FIRST ser-estab FIELDS()
                 WHERE ser-estab.serie = RowObject.cod-ser-docto
                   AND ser-estab.cod-estabel = RowObject.cod-estabel NO-LOCK:
             END.  
             IF NOT AVAIL ser-estab THEN DO:
                 {method/svc/errors/inserr.i &ErrorNumber="6514"
                                           &ErrorType="EMS"
                                           &ErrorSubType="Error"
                                           &ErrorParameters="RowObject.cod-ser-docto"}
             END.
        END.

        IF RowObject.cod-parcela = ""
        OR RowObject.cod-parcela = "0"
        OR RowObject.cod-parcela = "00" THEN DO:
            {utp/ut-liter.i Parcela * L}
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                       &ErrorType="EMS"
                                       &ErrorSubType="Error"
                                       &ErrorParameters="RETURN-VALUE"}
        END.

        IF RowObject.idi-valor = 1 AND RowObject.val-adiant-moed = 0 THEN DO:
            {utp/ut-liter.i Valor_do_Adiantamento * R }
            {method/svc/errors/inserr.i
                &ErrorNumber="17394"
                &ErrorType="EMS"
                &ErrorSubType="Error"
                &ErrorParameters="RETURN-VALUE"}
        END.

        FOR FIRST adiant-despes
            WHERE adiant-despes.cod-estabel = RowObject.cod-estabel
              AND adiant-despes.cdd-adiant  = RowObject.cdd-adiant NO-LOCK:
            
            IF RowObject.cdn-moeda <> adiant-despes.cdn-moeda THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="55028"    
                                            &ErrorType="EMS"
                                            &ErrorSubType="Error"
                                            &ErrorParameters="adiant-despes.cdn-moeda"}
            END.

            FOR FIRST param-imp 
                WHERE param-imp.cod-estabel = RowObject.cod-estabel NO-LOCK:

                RUN piSomatoriaAdiantParc IN THIS-PROCEDURE (INPUT  adiant-despes.cod-estabel,
                                                             INPUT  adiant-despes.cdd-adiant,
                                                             INPUT  RowObject.cod-refer,
                                                             OUTPUT de-total).
                ASSIGN de-total = de-total + RowObject.val-adiant-moed.
                ASSIGN c-return1 = string((de-total),'->>>,>>>,>>>,>>>,>>9.99':U)
                       c-return2 = string((param-imp.perc-max-antecip),'>>9.99':U) + "%":U
                       c-return3 = string((adiant-despes.val-adiant-orig),'->>>,>>>,>>>,>>>,>>9.99':U).
                IF de-total > adiant-despes.val-adiant-orig THEN DO:
                    ASSIGN de-perc-antecip = ((de-total * 100 / adiant-despes.val-adiant-orig) - 100).
                    IF de-perc-antecip > param-imp.perc-max-antecip THEN DO:
                        {utp/ut-liter.i Percentual_M ximo_Permitido * R }
                        ASSIGN c-liter = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="55291"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="Error"
                                                    &ErrorParameters="c-liter  + '~~~~' + 
                                                                      c-return1 + '~~~~' + 
                                                                      c-return2 + '~~~~' +
                                                                      '(' + c-return3 + ')' "}

                        /* A somat¢ria dos adiantamentos ultrapassou &1 permitido
                           Ex. A somat¢ria dos adiantamentos R$ 2.000,00 ‚ superior ao Percentual M ximo 
                           permitido 50% (R$ 1.000,00) que as Antecipa‡äes poderÆo ultrapassar o Adiantamento ao Fornecedor.*/
                    END.
                END.
            END.
        END.
    END.
    IF pType = "DELETE":U THEN DO:
        IF RowObject.log-gerou-tit-ap THEN DO:
            {utp/ut-liter.i Adiantamento_possui_T¡tulo_no_APB * R }
            {method/svc/errors/inserr.i &ErrorNumber="34621"    
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="RETURN-VALUE"}
        END.
        RUN piRetornaSituacaoAPB (INPUT RowObject.cod-estabel,
                                  INPUT RowObject.cod-refer,
                                  INPUT RowObject.cdn-emitente,
                                  OUTPUT c-situacao,
                                  OUTPUT l-gerou-apb,
                                  OUTPUT TABLE tt_retorno_antecip_pef_pend,
                                  OUTPUT TABLE tt_log_erro).
        IF CAN-FIND(FIRST tt_retorno_antecip_pef_pend) THEN DO:
            {utp/ut-liter.i Adiantamento * R }
            ASSIGN c-liter = TRIM(RETURN-VALUE).
            {utp/ut-liter.i T¡tulo_no_Contas_a_Pagar * R }
            {method/svc/errors/inserr.i &ErrorNumber="33207"    
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="c-liter + '~~~~' + RETURN-VALUE"}
        END.
        IF CAN-FIND(FIRST adiant-despes-lista
                    WHERE adiant-despes-lista.cod-estabel = RowObject.cod-estabel
                      AND adiant-despes-lista.cdd-adiant  = RowObject.cdd-adiant
                      AND adiant-despes-lista.cod-refer   = RowObject.cod-refer) THEN DO:

            {utp/ut-liter.i Adiantamento * R }
            ASSIGN c-liter = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Lista_de_Despesas/Impostos_e/ou_Mercadoria * R}
            {method/svc/errors/inserr.i &ErrorNumber="5"    
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="c-liter + '~~~~' + RETURN-VALUE"}

        END.

    END.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

