&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
{include/i-prgvrs.i BOIN00966 2.00.00.018 } /*** "010018" 13/11/2023 11:45:43 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN00966 MAQ}
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
&GLOBAL-DEFINE DBOName BOIN00966
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName pto-coleta
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
{inbo/boin00966.i RowObject}
{inbo/boin00966.i RowObject-aux}

def VARIABLE i-cod-pto-coleta-ini like RowObject.cod-pto-coleta no-undo.
def VARIABLE i-cod-pto-coleta-fim like RowObject.cod-pto-coleta no-undo.   
def VARIABLE c-des-pto-coleta-ini like RowObject.des-pto-coleta no-undo.
def VARIABLE c-des-pto-coleta-fim like RowObject.des-pto-coleta no-undo.   

def VARIABLE c-cod-filtro-ini  like RowObject.cod-pto-coleta      no-undo.
def VARIABLE c-cod-filtro-fim  like RowObject.cod-pto-coleta      no-undo.   
def VARIABLE c-des-filtro-ini  like RowObject.des-pto-coleta      no-undo.
def VARIABLE c-des-filtro-fim  like RowObject.des-pto-coleta      no-undo.
def VARIABLE i-cod-regiao-ini  LIKE regiao-abrangen.cod-regiao    NO-UNDO.
def VARIABLE i-cod-regiao-fim  LIKE regiao-abrangen.cod-regiao    NO-UNDO.

DEFINE VARIABLE i-cdn-produt-rural AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-cod-externo      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-propried     AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-log-respons      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE h-boin00990        AS HANDLE    NO-UNDO.

{inbo/boin00990.i tt-produt-pto-coleta}


/*temp-table de integraá∆o com o EMS5*/
def temp-table tt_ponto_coleta no-undo
    field ttv_cod_pto_coleta               as character format "x(12)"
    field ttv_des_pto_coleta               as character format "x(40)"
    field ttv_cod_propriet_rural           as character format "x(16)"
    field ttv_cdn_fornecedor_rural         as integer format 999999999
    .

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE VARIABLE i-produtor AS INT NO-UNDO.

{utp/utapi036.i} /* tt-coordenadas */

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
         HEIGHT             = 7.63
         WIDTH              = 62.29.
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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-pto-coleta":U THEN ASSIGN pFieldValue = RowObject.cod-pto-coleta.
        WHEN "cod-un":U THEN ASSIGN pFieldValue = RowObject.cod-un.
        WHEN "des-obs":U THEN ASSIGN pFieldValue = RowObject.des-obs.
        WHEN "des-pto-coleta":U THEN ASSIGN pFieldValue = RowObject.des-pto-coleta.
        WHEN "cod-propried":U THEN ASSIGN pFieldValue = RowObject.cod-propried.
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
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-media":U THEN ASSIGN pFieldValue = RowObject.val-media.
        WHEN "qtd-distan-km":U THEN ASSIGN pFieldValue = RowObject.qtd-distan-km.
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
  Purpose:     Retorna valores dos campos do °ndice ptclt_id2
  Parameters:  
               retorna valor do campo cod-pto-coleta
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-pto-coleta LIKE pto-coleta.cod-pto-coleta NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-pto-coleta = RowObject.cod-pto-coleta.

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
        WHEN "log-pto-coleta-coletiv":U THEN ASSIGN pFieldValue = RowObject.log-pto-coleta-coletiv.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTablePtoColeta DBOProgram 
PROCEDURE getTablePtoColeta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT  PARAMETER p-cod-pto-coleta LIKE pto-coleta.cod-pto-coleta NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR Rowobject-aux.
    
    EMPTY TEMP-TABLE Rowobject-aux.

    FIND FIRST bf{&TableName} WHERE bf{&TableName}.cod-pto-coleta = p-cod-pto-coleta NO-LOCK NO-ERROR.
    IF AVAIL bf{&TableName} THEN DO:
        
        CREATE Rowobject-aux.
        BUFFER-COPY bf{&TableName} TO Rowobject-aux.

    END.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ≠ndice ptclt_id2
  Parameters:  
               recebe valor do campo cod-pto-coleta
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-pto-coleta LIKE pto-coleta.cod-pto-coleta NO-UNDO.

    FIND FIRST bfpto-coleta WHERE 
        bfpto-coleta.cod-pto-coleta = pcod-pto-coleta NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serˇ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpto-coleta THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav≤s de rowid e verifica a ocorrºncia de erros, caso
          existam erros serˇ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpto-coleta)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodigo DBOProgram 
PROCEDURE openQueryCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
 OPEN QUERY {&QueryName} 
      FOR EACH {&tableName} NO-LOCK
         WHERE {&tablename}.cod-pto-coleta >= i-cod-pto-coleta-ini
           AND {&tablename}.cod-pto-coleta <= i-cod-pto-coleta-fim
           AND {&tablename}.log-livre-1     = TRUE  /*indica que o reposit est· ativo*/ 
            BY {&tablename}.cod-pto-coleta INDEXED-REPOSITION.

 RETURN "OK":U.
         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDescricao DBOProgram 
PROCEDURE openQueryDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
 OPEN QUERY {&QueryName} 
      FOR EACH {&tableName} NO-LOCK
         WHERE {&tablename}.des-pto-coleta >= c-des-pto-coleta-ini
           AND {&tablename}.des-pto-coleta <= c-des-pto-coleta-fim 
           AND {&tablename}.log-livre-1     = TRUE  /*indica que o reposit est· ativo*/
            BY {&tablename}.des-pto-coleta INDEXED-REPOSITION.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPtoColetaProdutor DBOProgram 
PROCEDURE openQueryPtoColetaProdutor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE qry  AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cqry AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cqrypropried AS CHARACTER   NO-UNDO.
        
    ASSIGN cqrypropried = "".
    FOR EACH propried-rural NO-LOCK WHERE propried-rural.cdn-produt-rural = i-produtor:
        IF cqrypropried <> "" THEN ASSIGN cqrypropried = cqrypropried + " OR ".
        ASSIGN cqrypropried = cqrypropried + "pto-coleta.cod-propried = '" + propried-rural.cod-propried + "'".
    END.

    IF cqrypropried = "" THEN  /*produtor n„o tem propriedade*/
        ASSIGN cqrypropried = "pto-coleta.cod-propried = '" + " " + "'".

    ASSIGN cqry = "FOR EACH PTO-COLETA NO-LOCK WHERE " + cqrypropried.
    qry = QUERY {&queryName}:HANDLE. 

    qry:QUERY-PREPARE(cqry).
    qry:QUERY-OPEN().

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPtoColFiltro DBOProgram 
PROCEDURE openQueryPtoColFiltro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEF OUTPUT PARAM TABLE FOR RowObject-aux.
    EMPTY TEMP-TABLE RowObject-aux.

    FOR EACH {&TableName} 
         WHERE {&tablename}.cod-pto-coleta >= c-cod-filtro-ini
           AND {&tablename}.cod-pto-coleta <= c-cod-filtro-fim
           AND {&tablename}.des-pto-coleta >= c-des-filtro-ini
           AND {&tablename}.des-pto-coleta <= c-des-filtro-fim
           AND {&tablename}.cod-regiao     >= i-cod-regiao-ini
           AND {&tablename}.cod-regiao     <= i-cod-regiao-fim NO-LOCK:

        CREATE RowObject-aux.
        BUFFER-COPY {&TableName} TO RowObject-aux.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDadosPontoColeta DBOProgram 
PROCEDURE retornaDadosPontoColeta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retornar temp-table com todos os registros da tabela para alimentar
         o zoom do EMS 5.
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER cod-pto-coleta-inic AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER cod-pto-coleta-fim  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER des-pto-coleta-inic AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER des-pto-coleta-fim  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER cod-propried-inic   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER cod-propried-fim    AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_ponto_coleta.

    FOR EACH tt_ponto_coleta EXCLUSIVE-LOCK:
        DELETE tt_ponto_coleta.
    END.

    FOR EACH bf{&TableName} FIELDS(cod-pto-coleta des-pto-coleta cod-propried) NO-LOCK
        WHERE bf{&TableName}.cod-pto-coleta >= cod-pto-coleta-inic
          AND bf{&TableName}.cod-pto-coleta <= cod-pto-coleta-fim 
          AND bf{&TableName}.des-pto-coleta >= des-pto-coleta-inic
          AND bf{&TableName}.des-pto-coleta <= des-pto-coleta-fim 
          AND bf{&TableName}.cod-propried   >= cod-propried-inic   
          AND bf{&TableName}.cod-propried   <= cod-propried-fim:
        CREATE tt_ponto_coleta.
        ASSIGN tt_ponto_coleta.ttv_cod_pto_coleta     = bf{&TableName}.cod-pto-coleta
               tt_ponto_coleta.ttv_des_pto_coleta     = bf{&TableName}.des-pto-coleta
               tt_ponto_coleta.ttv_cod_propriet_rural = bf{&TableName}.cod-propried.

        FOR FIRST propried-rural FIELDS(cdn-produt-rural) NO-LOCK
            WHERE propried-rural.cod-propried = bf{&TableName}.cod-propried:
            ASSIGN tt_ponto_coleta.ttv_cdn_fornecedor_rural = propried-rural.cdn-produt-rural.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornarDescricaoPontoColeta DBOProgram 
PROCEDURE retornarDescricaoPontoColeta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retornar dados da tabela conforme o c¢digo enviado.
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-cod-pto-coleta AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-des-pto-coleta AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cod-propried AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cdn-fornec AS INTEGER NO-UNDO.

    FOR FIRST bf{&TableName} FIELDS(des-pto-coleta cod-propried) NO-LOCK
        WHERE bf{&TableName}.cod-pto-coleta = p-cod-pto-coleta:
        ASSIGN p-des-pto-coleta = bf{&TableName}.des-pto-coleta
               p-cod-propried   = bf{&TableName}.cod-propried.

        FOR FIRST propried-rural FIELDS(cod-propried cdn-produt-rural) NO-LOCK
            WHERE propried-rural.cod-propried = p-cod-propried:
            ASSIGN p-cdn-fornec = propried-rural.cdn-produt-rural.
        END.
    END.

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

def input parameter p-cod-pto-coleta-ini like RowObject.cod-pto-coleta no-undo.
def input parameter p-cod-pto-coleta-fim like RowObject.cod-pto-coleta no-undo.

    assign i-cod-pto-coleta-ini = p-cod-pto-coleta-ini       
           i-cod-pto-coleta-fim = p-cod-pto-coleta-fim.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDescricao DBOProgram 
PROCEDURE setConstraintDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-des-pto-coleta-ini like RowObject.des-pto-coleta no-undo.
def input parameter p-des-pto-coleta-fim like RowObject.des-pto-coleta no-undo.

    assign c-des-pto-coleta-ini = p-des-pto-coleta-ini       
           c-des-pto-coleta-fim = p-des-pto-coleta-fim.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPtoColFiltro DBOProgram 
PROCEDURE setConstraintPtoColFiltro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-cod-pto-coleta-ini like RowObject.cod-pto-coleta   no-undo.
    def input parameter p-cod-pto-coleta-fim like RowObject.cod-pto-coleta   no-undo.
    def input parameter p-des-pto-coleta-ini like RowObject.des-pto-coleta   no-undo.
    def input parameter p-des-pto-coleta-fim like RowObject.des-pto-coleta   no-undo.
    def input parameter p-cod-regiao-ini     LIKE regiao-abrangen.cod-regiao NO-UNDO.
    def input parameter p-cod-regiao-fim     LIKE regiao-abrangen.cod-regiao NO-UNDO.
    
    ASSIGN c-cod-filtro-ini = p-cod-pto-coleta-ini
           c-cod-filtro-fim = p-cod-pto-coleta-fim
           c-des-filtro-ini = p-des-pto-coleta-ini
           c-des-filtro-fim = p-des-pto-coleta-fim
           i-cod-regiao-ini = p-cod-regiao-ini
           i-cod-regiao-fim = p-cod-regiao-fim. 
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validarPontoColeta DBOProgram 
PROCEDURE validarPontoColeta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Validar c¢digo do Ponto Coleta informado no EMS 5.
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-cod-pto-coleta AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-propried AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-log-erro AS LOGICAL NO-UNDO.

    ASSIGN p-log-erro = YES.
    FOR FIRST bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-pto-coleta = p-cod-pto-coleta 
          AND bf{&TableName}.cod-propried   = p-cod-propried:
        ASSIGN p-log-erro = NO.
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
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    DEF VAR c-label-tabela AS CHAR   NO-UNDO.
    DEF VAR c-label-relac  AS CHAR   NO-UNDO.

    DEFINE VARIABLE c-msg1 AS CHAR NO-UNDO.
    DEFINE VARIABLE c-msg2 AS CHAR NO-UNDO.
    
    DEFINE VARIABLE h-boin00980 AS HANDLE  NO-UNDO.
    DEFINE VARIABLE h-aqapi005  AS HANDLE  NO-UNDO.
    DEFINE VARIABLE rRowid      AS ROWID   NO-UNDO.
    DEFINE VARIABLE iSituacao   AS INTEGER NO-UNDO.

    {utp/ut-liter.i Ponto_de_Coleta * L}
    ASSIGN c-label-tabela = RETURN-VALUE.

    IF pType = "Create" THEN DO:
        IF CAN-FIND(FIRST bf{&TableName} WHERE bf{&TableName}.cod-pto-coleta = RowObject.cod-pto-coleta) THEN DO:
            {utp/ut-liter.i Ponto_Coleta *}
            {method/svc/errors/inserr.i
                     &ErrorNumber="1"
                     &ErrorType="EMS"
                     &ErrorParameters="return-value"} 
        END.
    END.
    
    IF NOT CAN-FIND(FIRST tab-unidade 
         where tab-unidade.un = RowObject.cod-un) then do:
        {method/svc/errors/inserr.i
                &ErrorNumber="846"
                &ErrorType="EMS"
                &ErrorSubType="Error"}
    end.

    IF NOT CAN-FIND(first regiao-abrangen
         where regiao-abrangen.cod-regiao = RowObject.cod-regiao) then do:
        {utp/ut-liter.i Regi∆o_de_Abrangància *}
        {method/svc/errors/inserr.i
                &ErrorNumber="56" /* Regiao inexistente */
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="return-value" }
    end.

     IF NOT CAN-FIND(FIRST propried-rural NO-LOCK
                     WHERE propried-rural.cod-propried = RowObject.cod-propried) THEN DO:
        {utp/ut-liter.i Propriedade *}
        {method/svc/errors/inserr.i
                           &ErrorNumber="56" /*Propriedade Inexistente*/
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters="return-value"} 
    END.

    IF pType = "Delete" THEN DO:

        IF CAN-FIND(FIRST pto-rota-coleta WHERE pto-rota-coleta.cod-pto-coleta = RowObject.cod-pto-coleta) THEN DO:
    
            {utp/ut-liter.i Ponto_de_Coleta_da_Rota * L}
            ASSIGN c-label-relac = RETURN-VALUE. 
    
            {method/svc/errors/inserr.i
                 &ErrorNumber="5"
                 &ErrorType="EMS"
                 &ErrorParameters="c-label-tabela + '~~~~' + c-label-relac"}
        END.
    
        IF CAN-FIND(FIRST reposit WHERE reposit.cod-pto-coleta = RowObject.cod-pto-coleta) THEN DO:
    
            {utp/ut-liter.i Reposit¢rio * L}
            ASSIGN c-label-relac = RETURN-VALUE. 
    
            {method/svc/errors/inserr.i
                 &ErrorNumber="5"
                 &ErrorType="EMS"
                 &ErrorParameters="c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST regra-form-preco WHERE regra-form-preco.cod-pto-coleta = RowObject.cod-pto-coleta) THEN DO:

            {utp/ut-liter.i Regra_de_Formaá∆o_de_Preáo * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i
                 &ErrorNumber="5"
                 &ErrorType="EMS"
                 &ErrorParameters="c-label-tabela + '~~~~' + c-label-relac"}
        END. 
        
        IF CAN-FIND(FIRST produt-carg WHERE produt-carg.cod-pto-coleta = RowObject.cod-pto-coleta) THEN DO:

            {utp/ut-liter.i Produtor_Carga * L}
            ASSIGN c-label-relac = RETURN-VALUE. 

            {method/svc/errors/inserr.i
                 &ErrorNumber="5"
                 &ErrorType="EMS"
                 &ErrorParameters="c-label-tabela + '~~~~' + c-label-relac"}
        END.        
        
        IF CAN-FIND(FIRST analis-lab-period WHERE analis-lab-period.cod-pto-coleta = RowObject.cod-pto-coleta) THEN DO:

            {utp/ut-liter.i Analise_Laborat¢rio_Periodo * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=" c-label-tabela + '~~~~' + c-label-relac"}
        END.

        

    END.


    IF pType = "Update":U THEN DO:
    
        /*verifica se propried-rural est· ativa*/
        RUN aqp/aqapi005.p   PERSISTENT SET h-aqapi005.
        RUN inbo/boin00980.p PERSISTENT SET h-boin00980.
        
        
        IF VALID-HANDLE(h-boin00980) AND RowObject.log-livre-1 = YES THEN DO: /*est· tentando ativar o pto-coleta*/
            RUN openQueryStatic IN h-boin00980(INPUT "Main":U).
        
            RUN goToKey IN h-boin00980 (INPUT RowObject.cod-propried).
        
            RUN getRowid IN h-boin00980 (OUTPUT rRowid).
        
            RUN piInicial IN h-aqapi005 (INPUT  "consultar":U,
                                         INPUT  "propriedade":U,
                                         INPUT  rRowid,
                                         OUTPUT iSituacao,
                                         INPUT-OUTPUT TABLE rowErrors).              
        
            IF iSituacao = 0 THEN DO:
        
                {utp/ut-liter.i Ponto_de_Coleta}
                ASSIGN c-msg1 = RETURN-VALUE.
                {utp/ut-liter.i Para_salvar_ponto_de_coleta_Ç_necess†rio_ativar_propriedade}
                ASSIGN c-msg2 = RETURN-VALUE.
                
                {method/svc/errors/inserr.i
                         &ErrorNumber="54277"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="c-msg1 + '~~~~' + c-msg2"}
        
            END.
        END.

    END.

    IF  h-aqapi005 <> ? THEN DO:
        DELETE PROCEDURE h-aqapi005.
        ASSIGN h-aqapi005 = ?.    
    END.

    IF  h-boin00980 <> ? THEN DO:
        DELETE PROCEDURE h-boin00980.
        ASSIGN h-boin00980 = ?.    
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose: Excluir todos os produtores relacionados com o ponto de coleta.
------------------------------------------------------------------------------*/

    FOR EACH produt-pto-coleta EXCLUSIVE-LOCK
        WHERE produt-pto-coleta.cod-pto-coleta = RowObject.cod-pto-coleta:

        DELETE produt-pto-coleta.

    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintProdutPtoColeta DBOProgram 
PROCEDURE setConstraintProdutPtoColeta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-cdn-produt-rural AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-externo      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pl-log-respons      AS LOGICAL   NO-UNDO.
    
    ASSIGN i-cdn-produt-rural = pi-cdn-produt-rural
           c-cod-externo      = pc-cod-externo
           l-log-respons      = pl-log-respons.
           
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPtoPropriedade DBOProgram 
PROCEDURE setConstraintPtoPropriedade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-propried AS CHARACTER NO-UNDO.

    ASSIGN c-cod-propried = pc-cod-propried.
           
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodigo DBOProgram 
PROCEDURE openQueryPtoPropriedade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
 OPEN QUERY {&QueryName} 
      FOR EACH {&tableName} NO-LOCK
         WHERE {&tablename}.cod-propried = c-cod-propried.

 RETURN "OK":U.
         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* ALTERACAO DO RELACIONAMENTO DO PONTO DE COLETA COM O PRODUTOR */ 
    IF NOT VALID-HANDLE(h-boin00990) THEN
        RUN inbo/boin00990.p PERSISTENT SET h-boin00990.   
    
    IF VALID-HANDLE(h-boin00990) THEN DO:
    
        RUN openQueryStatic IN h-boin00990(INPUT 'Main':U).
        
        EMPTY TEMP-TABLE tt-produt-pto-coleta NO-ERROR.
        
        RUN goToKey IN h-boin00990(INPUT i-cdn-produt-rural, 
                                   INPUT RowObject.cod-pto-coleta, 
                                   INPUT RowObject.cod-propried).                               
        IF RETURN-VALUE = "OK":U THEN DO:            
            RUN getRecord IN h-boin00990(OUTPUT TABLE tt-produt-pto-coleta).
            
            IF c-cod-externo = "" THEN
                REPEAT:
                    ASSIGN c-cod-externo = REPLACE(REPLACE(STRING(NEXT-VALUE(seq-cod-ext)), ".", ""), ",", "").
                    IF NOT CAN-FIND(FIRST produt-pto-coleta 
                                    WHERE produt-pto-coleta.cod-externo = c-cod-externo) THEN
                        LEAVE.
                END.

            FIND FIRST tt-produt-pto-coleta NO-ERROR.
            IF AVAIL tt-produt-pto-coleta THEN
                ASSIGN tt-produt-pto-coleta.cod-externo = c-cod-externo
                       tt-produt-pto-coleta.log-respons = YES
                       tt-produt-pto-coleta.log-livre-1 = RowObject.log-livre-1.
                    
            RUN emptyRowErrors IN h-boin00990.         
            RUN setRecord      IN h-boin00990(INPUT TABLE tt-produt-pto-coleta).
            RUN updateRecord   IN h-boin00990.
            RUN getRowErrors   IN h-boin00990(OUTPUT TABLE RowErrors).
            
            DELETE PROCEDURE h-boin00990.
            ASSIGN h-boin00990 = ?.
            
            /*:T--- Verifica ocorrància de erros ---*/
            IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
                RETURN "NOK":U.        
        END.
    END.    
  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/  
  
    /* CRIACAO DO RELACIONAMENTO DO PONTO DE COLETA COM O PRODUTOR */  
    IF NOT VALID-HANDLE(h-boin00990) THEN
        RUN inbo/boin00990.p PERSISTENT SET h-boin00990.   
  
    IF VALID-HANDLE(h-boin00990) THEN DO:    
        RUN openQueryStatic IN h-boin00990(INPUT 'Main':U).
        
        IF c-cod-externo = "" THEN DO:
            REPEAT:
                ASSIGN c-cod-externo = REPLACE(REPLACE(STRING(NEXT-VALUE(seq-cod-ext)), ".", ""), ",", "").
                IF NOT CAN-FIND(FIRST produt-pto-coleta 
                                WHERE produt-pto-coleta.cod-externo = c-cod-externo) THEN
                    LEAVE.
            END.
        END.    
        
        EMPTY TEMP-TABLE tt-produt-pto-coleta.
        CREATE tt-produt-pto-coleta.
        ASSIGN tt-produt-pto-coleta.cdn-produt-rural = i-cdn-produt-rural
               tt-produt-pto-coleta.cod-propried     = RowObject.cod-propried 
               tt-produt-pto-coleta.cod-pto-coleta   = RowObject.cod-pto-coleta
               tt-produt-pto-coleta.cod-externo      = c-cod-externo
               tt-produt-pto-coleta.log-respons      = l-log-respons
               tt-produt-pto-coleta.log-livre-1      = RowObject.log-livre-1.    

        RUN emptyRowObject  IN h-boin00990. 
        RUN emptyRowErrors  IN h-boin00990.     
        RUN setRecord       IN h-boin00990(INPUT TABLE tt-produt-pto-coleta).
        RUN createRecord    IN h-boin00990.
        RUN getRowErrors    IN h-boin00990(OUTPUT TABLE RowErrors).
        
        DELETE PROCEDURE h-boin00990.
        ASSIGN h-boin00990 = ?.
        
         /*:T--- Verifica ocorrància de erros ---*/
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
            RETURN "NOK":U.   
    END.       
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mostraMapa DBOProgram 
PROCEDURE mostraMapa:
/*------------------------------------------------------------------------------
  Purpose: Mostrar 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pc-cod-pto-coleta LIKE pto-coleta.cod-pto-coleta NO-UNDO.

    DEFINE VARIABLE h-utapi036 AS HANDLE      NO-UNDO.
    DEFINE VARIABLE i-ind AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-ret AS CHARACTER   NO-UNDO.

    EMPTY TEMP-TABLE tt-coordenadas NO-ERROR.

    FOR FIRST pto-coleta FIELDS(cod-pto-coleta val-latitude val-longitude) NO-LOCK
        WHERE pto-coleta.cod-pto-coleta = pc-cod-pto-coleta:
    
        IF pto-coleta.val-latitude  <> 0 AND 
           pto-coleta.val-longitude <> 0 THEN DO:
        
            i-ind = i-ind + 1.
        
            CREATE tt-coordenadas.
            ASSIGN tt-coordenadas.iIndice    = i-ind
                   tt-coordenadas.cLatitude  = REPLACE(STRING(pto-coleta.val-latitude), ",", ".")
                   tt-coordenadas.cLongitude = REPLACE(STRING(pto-coleta.val-longitude), ",", ".").

        END.
        ELSE DO:

            {method/svc/errors/inserr.i
                &ErrorNumber="55285"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="pto-coleta.cod-pto-coleta"}

        END.
    
    END.

    RUN utp/utapi036.p PERSISTENT SET h-utapi036.

    ASSIGN c-ret = "OK":U.

    IF NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RUN pMapaLocalRota IN h-utapi036 (INPUT TABLE tt-coordenadas, OUTPUT c-ret). 

    IF h-utapi036 <> ? THEN DO:
        DELETE PROCEDURE h-utapi036.
        ASSIGN h-utapi036 = ?.
    END.

    IF c-ret <> "OK":U THEN DO:

        {method/svc/errors/inserr.i
            &ErrorNumber="55286"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"}

    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

