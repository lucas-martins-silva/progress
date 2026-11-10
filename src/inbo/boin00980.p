&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
{include/i-prgvrs.i BOIN00980 2.00.00.018 } /*** "010018" 13/11/2023 11:45:44 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN00980 MAQ}
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
&GLOBAL-DEFINE DBOName BOIN00980
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName propried-rural
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
{inbo/boin00980.i RowObject}
{inbo/boin00980.i tt-propried-rural-aux}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

DEFINE BUFFER bf-pto-coleta FOR pto-coleta.


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def VARIABLE i-cod-propried-ini like RowObject.cod-propried no-undo.
def VARIABLE i-cod-propried-fim like RowObject.cod-propried no-undo.   
def VARIABLE c-des-propried-ini like RowObject.des-propried no-undo.
def VARIABLE c-des-propried-fim like RowObject.des-propried no-undo.

DEFINE VARIABLE i-produtor AS INT NO-UNDO.

/*temp-table integraá∆o com EMS5*/
def temp-table tt_propriedade_rural no-undo
    field tta_cod_prop_rural as character format "x(10)"
    field ttv_des_prop_rural as character format "x(60)" 
    .

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
         HEIGHT             = 6.92
         WIDTH              = 66.57.
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    /* Atualiza regiao dos pontos de coleta que possuem a propriedade atualizada */
    FOR EACH pto-coleta NO-LOCK
       WHERE pto-coleta.cod-propried = RowObject.cod-propried:
        IF pto-coleta.cod-regiao <> RowObject.cod-regiao THEN DO:         
            FIND FIRST bf-pto-coleta EXCLUSIVE-LOCK
                 WHERE ROWID(bf-pto-coleta) = ROWID(pto-coleta) NO-ERROR.
            IF AVAIL bf-pto-coleta THEN DO:           
                ASSIGN bf-pto-coleta.cod-regiao = RowObject.cod-regiao.
                RELEASE bf-pto-coleta.
            END.
        END.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaPropriedadeProdutor DBOProgram 
PROCEDURE buscaPropriedadeProdutor :
/*------------------------------------------------------------------------------
  Purpose: Retorna propriedades do produtor rural    
  Parameters:  pcdn-produt-rural -> codigo do produtor 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-produt-rural LIKE propried-rural.cdn-produt-rural NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-propried-rural-aux.

    EMPTY TEMP-TABLE tt-propried-rural-aux NO-ERROR.

    FOR EACH propried-rural NO-LOCK
       WHERE propried-rural.cdn-produt-rural = pcdn-produt-rural:
        CREATE tt-propried-rural-aux.
        BUFFER-COPY propried-rural TO tt-propried-rural-aux.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAllPropriedRural DBOProgram 
PROCEDURE getAllPropriedRural :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER p-cod-produtor LIKE propried-rural.cdn-produt-rural  NO-UNDO.     
    DEF OUTPUT PARAMETER TABLE FOR tt-propried-rural-aux.
      
    EMPTY TEMP-TABLE tt-propried-rural-aux.

    FOR EACH {&TableName} NO-LOCK
       WHERE {&TableName}.cdn-produt-rural = p-cod-produtor:

        CREATE tt-propried-rural-aux.
        BUFFER-COPY {&TableName} TO tt-propried-rural-aux.

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
        WHEN "cod-entrega":U THEN ASSIGN pFieldValue = RowObject.cod-entrega.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-propried":U THEN ASSIGN pFieldValue = RowObject.cod-propried.
        WHEN "cod-regiao":U THEN ASSIGN pFieldValue = RowObject.cod-regiao.
        WHEN "des-obs":U THEN ASSIGN pFieldValue = RowObject.des-obs.
        WHEN "des-propried":U THEN ASSIGN pFieldValue = RowObject.des-propried.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "cod-rota-princ":U THEN ASSIGN pFieldValue = RowObject.cod-rota-princ.
        WHEN "cod-nrp":U THEN ASSIGN pFieldValue = RowObject.cod-nrp.
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
        WHEN "cdn-produt-rural":U THEN ASSIGN pFieldValue = RowObject.cdn-produt-rural.
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
  Purpose:     Retorna valores dos campos do °ndice propried-rural-id
  Parameters:  
               retorna valor do campo cod-propried
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-propried LIKE propried-rural.cod-propried NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-propried = RowObject.cod-propried.

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
  Purpose:     Reposiciona registro com base no °ndice propried-rural-id
  Parameters:  
               recebe valor do campo cod-propried
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-propried LIKE propried-rural.cod-propried NO-UNDO.

    FIND FIRST bfpropried-rural WHERE 
        bfpropried-rural.cod-propried = pcod-propried NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpropried-rural THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpropried-rural)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDescricao DBOProgram 
PROCEDURE openQueryDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   OPEN QUERY {&QueryName} 
     FOR EACH {&TableName} NO-LOCK 
         WHERE {&TableName}.des-propried >= c-des-propried-ini
           AND {&TableName}.des-propried <= c-des-propried-fim
           AND {&tablename}.log-livre-1   = TRUE  /*indica que a propried est· ativo*/
            BY {&TableName}.des-propried INDEXED-REPOSITION.         

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPropProdutor DBOProgram 
PROCEDURE openQueryPropProdutor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   OPEN QUERY {&QueryName} 
     FOR EACH {&TableName} NO-LOCK 
        WHERE {&TableName}.cod-propried >= i-cod-propried-ini
          AND {&TableName}.cod-propried <= i-cod-propried-fim
          AND {&tablename}.cdn-produt-rural = i-produtor
          AND {&tablename}.log-livre-1      = TRUE  /*indica que a propried est· ativo*/
           BY {&TableName}.cod-propried INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPropProdutorDesc DBOProgram 
PROCEDURE openQueryPropProdutorDesc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   OPEN QUERY {&QueryName} 
     FOR EACH {&TableName} NO-LOCK 
         WHERE {&TableName}.des-propried >= c-des-propried-ini
           AND {&TableName}.des-propried <= c-des-propried-fim
           AND {&tablename}.cdn-produt-rural = i-produtor
           AND {&tablename}.log-livre-1      = TRUE  /*indica que a propried est· ativo*/
            BY {&TableName}.des-propried INDEXED-REPOSITION.         

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPropriedade DBOProgram 
PROCEDURE openQueryPropriedade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   OPEN QUERY {&QueryName} 
     FOR EACH {&TableName} NO-LOCK 
        WHERE {&TableName}.cod-propried >= i-cod-propried-ini
          AND {&TableName}.cod-propried <= i-cod-propried-fim 
          AND {&tablename}.log-livre-1   = TRUE  /*indica que a propried est· ativo*/
           BY {&TableName}.cod-propried INDEXED-REPOSITION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPropriedadeProdutor DBOProgram 
PROCEDURE openQueryPropriedadeProdutor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&queryName} for each {&tableName} no-lock
                               where {&tablename}.cdn-produt-rural = i-produtor.
    return "OK":U. 

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

def input parameter p-des-propried-ini like RowObject.des-propried no-undo.
def input parameter p-des-propried-fim like RowObject.des-propried no-undo.

    assign c-des-propried-ini = p-des-propried-ini       
           c-des-propried-fim = p-des-propried-fim.   

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

def input parameter p-cod-produtor AS INT no-undo.

    assign i-produtor = p-cod-produtor.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPropProdutor DBOProgram 
PROCEDURE setConstraintPropProdutor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-cod-produtor     AS INT no-undo.
def input parameter p-cod-propried-ini like RowObject.cod-propried no-undo.
def input parameter p-cod-propried-fim like RowObject.cod-propried no-undo.

    assign i-produtor         = p-cod-produtor
           i-cod-propried-ini = p-cod-propried-ini       
           i-cod-propried-fim = p-cod-propried-fim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPropProdutorDesc DBOProgram 
PROCEDURE setConstraintPropProdutorDesc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-cod-produtor     AS INT no-undo.
def input parameter p-des-propried-ini like RowObject.des-propried no-undo.
def input parameter p-des-propried-fim like RowObject.des-propried no-undo.

    assign i-produtor         = p-cod-produtor
           c-des-propried-ini = p-des-propried-ini       
           c-des-propried-fim = p-des-propried-fim.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPropriedade DBOProgram 
PROCEDURE setConstraintPropriedade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-cod-propried-ini like RowObject.cod-propried no-undo.
def input parameter p-cod-propried-fim like RowObject.cod-propried no-undo.

    assign i-cod-propried-ini = p-cod-propried-ini       
           i-cod-propried-fim = p-cod-propried-fim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validarPropriedade DBOProgram 
PROCEDURE validarPropriedade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Validar c¢digo da propriedade informado no EMS 5.
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-cdn-fornec AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-propried AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-log-erro AS LOGICAL NO-UNDO.

    ASSIGN p-log-erro = YES.
    FOR FIRST bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cdn-produt-rural = p-cdn-fornec 
          AND bf{&TableName}.cod-propried     = p-cod-propried:
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
    
    DEFINE VARIABLE h-boin00962 AS HANDLE  NO-UNDO.
    DEFINE VARIABLE h-aqapi005  AS HANDLE  NO-UNDO.
    DEFINE VARIABLE rRowid      AS ROWID   NO-UNDO.
    DEFINE VARIABLE iSituacao   AS INTEGER NO-UNDO.

    {utp/ut-liter.i Propriedade_Rural * L}
    ASSIGN c-label-tabela = RETURN-VALUE.

    IF pType = "create":U THEN DO:
        IF CAN-FIND(FIRST bf{&TABLEName} NO-LOCK 
                    WHERE bf{&TABLEName}.cod-propried  = rowObject.cod-propried) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-propried AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Propriedade_Rural" *}
            ASSIGN c-lbl-liter-propried = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="7"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-propried"}

        END.

        IF RowObject.cod-propried = "" THEN DO:
            {utp/ut-liter.i Propriedade *}
            {method/svc/errors/inserr.i
                               &ErrorNumber="164"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters="return-value"} 
        END.
        

    END.

    IF pType = "create":U OR pType = "update":U THEN DO:

        IF RowObject.des-propried = "" THEN DO:
            {utp/ut-liter.i Descriá∆o *}
            {method/svc/errors/inserr.i
                               &ErrorNumber="164"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters="return-value"} 
        END.
        
        IF NOT CAN-FIND(first produt-rural where produt-rural.cdn-produt-rural = RowObject.cdn-produt-rural) THEN DO:
            {utp/ut-liter.i Produtor_Rural *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        END.
        
        IF NOT CAN-FIND(FIRST loc-entr
                        WHERE loc-entr.nome-abrev  = RowObject.nome-abrev
                        AND   loc-entr.cod-entrega = RowObject.cod-entrega)  THEN DO:
           {utp/ut-liter.i Endereáo_Entrega *}
           {method/svc/errors/inserr.i &ErrorNumber="2"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters="return-value"}
        END.
        
        IF NOT CAN-FIND(FIRST rota-coleta
                        WHERE rota-coleta.cod-rota  = RowObject.cod-rota-princ)  THEN DO:
           {utp/ut-liter.i Rota_Principal *}
           {method/svc/errors/inserr.i &ErrorNumber="2"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters="return-value"}
        END.

        IF NOT CAN-FIND(FIRST regiao-abrangen
                        WHERE regiao-abrangen.cod-regiao  = RowObject.cod-regiao)  THEN DO:
           {utp/ut-liter.i Regi∆o *}
           {method/svc/errors/inserr.i &ErrorNumber="2"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters="return-value"}
        END.
        
    END.    

    IF pType = "Delete" THEN DO:

        IF CAN-FIND(FIRST pto-coleta WHERE pto-coleta.cod-propried = RowObject.cod-propried) THEN DO:
    
            {utp/ut-liter.i Ponto_de_Coleta * L}
            ASSIGN c-label-relac = RETURN-VALUE. 
    
            {method/svc/errors/inserr.i
                 &ErrorNumber="5"
                 &ErrorType="EMS"
                 &ErrorParameters="c-label-tabela + '~~~~' + c-label-relac"}
        END.
    
        IF CAN-FIND(FIRST produt-pto-coleta WHERE produt-pto-coleta.cod-propried = RowObject.cod-propried) THEN DO:
    
            {utp/ut-liter.i Ponto_Coleta_Coletivo * L}
            ASSIGN c-label-relac = RETURN-VALUE. 
    
            {method/svc/errors/inserr.i
                 &ErrorNumber="5"
                 &ErrorType="EMS"
                 &ErrorParameters="c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST regra-form-preco WHERE regra-form-preco.cod-propried = RowObject.cod-propried) THEN DO:

            {utp/ut-liter.i Regra_de_Formaá∆o_de_Preáo * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=" c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST fechto-produt-period WHERE fechto-produt-period.cod-propried = RowObject.cod-propried) THEN DO:

            {utp/ut-liter.i Valores_Fechamento_Produtor_por_Per°odo * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=" c-label-tabela + '~~~~' + c-label-relac"}
        END.    

        IF CAN-FIND(FIRST dest-cust-naocfedade WHERE dest-cust-naocfedade.cod-propried = RowObject.cod-propried) THEN DO:

            {utp/ut-liter.i Destino_Custo_N∆o_Conformidade * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=" c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST nf-produt-propried WHERE nf-produt-propried.cod-propried = RowObject.cod-propried) THEN DO:

            {utp/ut-liter.i Notas_Produtor_Propriedade * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=" c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST analis-lab-period WHERE analis-lab-period.cod-propried = RowObject.cod-propried) THEN DO:

            {utp/ut-liter.i Analise_Laborat¢rio_Periodo * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=" c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST fechto-qualid WHERE fechto-qualid.cod-propried = RowObject.cod-propried) THEN DO:

            {utp/ut-liter.i Fechamento_Valores_Qualidade * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=" c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST produt-carg WHERE produt-carg.cod-propried = RowObject.cod-propried) THEN DO:

            {utp/ut-liter.i Produtores_da_Carga * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=" c-label-tabela + '~~~~' + c-label-relac"}
        END.

            
        

        
        
    END.

        /*verifica se produt-rural est· ativo*/
        RUN aqp/aqapi005.p   PERSISTENT SET h-aqapi005.
        RUN inbo/boin00962.p PERSISTENT SET h-boin00962.
        
        
        IF VALID-HANDLE(h-boin00962) AND RowObject.log-livre-1 = YES THEN DO: /*est· tentando ativar a propried-rural*/
            RUN openQueryStatic IN h-boin00962(INPUT "Main":U).
        
            RUN goToKey IN h-boin00962 (INPUT RowObject.cdn-produt-rural).
        
            RUN getRowid IN h-boin00962 (OUTPUT rRowid).
        
            RUN piInicial IN h-aqapi005 (INPUT  "consultar":U,
                                         INPUT  "produtor":U,
                                         INPUT  rRowid,
                                         OUTPUT iSituacao,
                                         INPUT-OUTPUT TABLE rowErrors).              
        
            IF iSituacao = 0 THEN DO:
        
                {utp/ut-liter.i Propriedade}
                ASSIGN c-msg1 = RETURN-VALUE.
                {utp/ut-liter.i Para_salvar_propriedade_Ç_necess†rio_ativar_produtor}
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

        IF  h-boin00962 <> ? THEN DO:
            DELETE PROCEDURE h-boin00962.
            ASSIGN h-boin00962 = ?.    
        END.

    

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDadosPropriedadeRural DBOProgram 
PROCEDURE retornaDadosPropriedadeRural :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retornar temp-table com todos os registros da tabela para alimentar
         o zoom do EMS 5.
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-cdn-fornec AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_propriedade_rural.

    FOR EACH tt_propriedade_rural EXCLUSIVE-LOCK:
        DELETE tt_propriedade_rural.
    END.

    FOR EACH bf{&TableName} FIELDS(cod-propried des-propried) NO-LOCK
        WHERE bf{&TableName}.cdn-produt-rural = p-cdn-fornec:
        CREATE tt_propriedade_rural.
        ASSIGN tt_propriedade_rural.tta_cod_prop_rural = bf{&TableName}.cod-propried
               tt_propriedade_rural.ttv_des_prop_rural = bf{&TableName}.des-propried.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDadosTodasPropriedadeRural DBOProgram 
PROCEDURE retornaDadosTodasPropriedadeRural :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retornar temp-table com todos os registros da tabela para alimentar
         o zoom do EMS 5.
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER TABLE FOR tt_propriedade_rural.

    FOR EACH tt_propriedade_rural EXCLUSIVE-LOCK:
        DELETE tt_propriedade_rural.
    END.

    FOR EACH bf{&TableName} FIELDS(cod-propried des-propried) NO-LOCK:
        CREATE tt_propriedade_rural.
        ASSIGN tt_propriedade_rural.tta_cod_prop_rural = bf{&TableName}.cod-propried
               tt_propriedade_rural.ttv_des_prop_rural = bf{&TableName}.des-propried.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornarDescricaoPropriedade DBOProgram 
PROCEDURE retornarDescricaoPropriedade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retornar descriá∆o da propriedade rural para o EMS 5.
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-cod-propried AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-des-propried AS CHARACTER NO-UNDO.

    ASSIGN p-des-propried = "".
    FOR FIRST bf{&TableName} FIELDS(des-propried) NO-LOCK
        WHERE bf{&TableName}.cod-propried = p-cod-propried:
        ASSIGN p-des-propried = bf{&TableName}.des-propried.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornarPropriedadeFornecedor DBOProgram 
PROCEDURE retornarPropriedadeFornecedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retornar c¢digo da propriedade do fornecedor.
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-cdn-fornec AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cod-propried AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-des-propried AS CHARACTER NO-UNDO.

    ASSIGN p-cod-propried = ""
           p-des-propried = "".
    FOR FIRST bf{&TableName} FIELDS(cod-propried des-propried) NO-LOCK
        WHERE bf{&TableName}.cdn-produt-rural = p-cdn-fornec:
        ASSIGN p-cod-propried = bf{&TableName}.cod-propried
               p-des-propried = bf{&TableName}.des-propried.
    END.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornarRegiaoPropriedade DBOProgram 
PROCEDURE retornarRegiaoPropriedade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retornar c¢digo e nome da regi∆o da propriedade.
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-cod-propried AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cod-regiao AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-nom-regiao AS CHARACTER NO-UNDO.

    ASSIGN p-cod-regiao = ""
           p-nom-regiao = "".
    FOR FIRST bf{&TableName} FIELDS(cod-regiao) NO-LOCK
        WHERE bf{&TableName}.cod-propried = p-cod-propried:
        ASSIGN p-cod-regiao = bf{&TableName}.cod-regiao.
        FIND FIRST regiao-abrangen
            WHERE regiao-abrangen.cod-regiao = p-cod-regiao NO-LOCK NO-ERROR.
        IF AVAIL regiao-abrangen THEN
            ASSIGN p-nom-regiao = regiao-abrangen.nom-regiao.
    END.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
