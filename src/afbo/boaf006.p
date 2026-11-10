&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAF006 2.00.00.011 } /*** "010011" 29/05/2025 12:29:13 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOAF006
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName af-item-contr-estab
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
{afbo/boaf006.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE iPerc            LIKE af-item-contr-form.percentual NO-UNDO.
DEFINE VARIABLE h-boaf007        AS HANDLE     NO-UNDO.
DEFINE VARIABLE cCodGroAvaliacao AS  CHAR NO-UNDO.
DEFINE VARIABLE iNrVersao        AS INTEGER     NO-UNDO.

{afbo/boaf006.i ttAf-Item-Contr-Estab}
{afbo/boaf007.i ttAf-item-contr-estab-form}
{afbo/boaf007.i bttAf-item-contr-estab-form}
{afbo/boaf017.i ttAf-Grp-Avaliacao}
{afbo/boaf018.i ttAf-Grp-Avaliacao-Form}

DEFINE TEMP-TABLE ttAf-item-contr-estab-form-old NO-UNDO
    FIELD nr-controle  like Af-item-contr-estab-form.nr-controle
    field dt-prox-aval like Af-item-contr-estab-form.dt-prox-aval
    field dt-ult-aval  like Af-item-contr-estab-form.dt-ult-aval.

DEF VAR c-cod-grp-avaliacao LIKE af-item-contr-estab.cod-grp-avaliacao NO-UNDO.
DEF VAR c-cod-estabel-ini   LIKE af-item-contr-estab.cod-estabel  NO-UNDO.
DEF VAR c-cod-estabel-fim   LIKE af-item-contr-estab.cod-estabel  NO-UNDO.
DEF VAR c-it-codigo-ini     LIKE af-item-contr-estab.it-codigo    NO-UNDO.
DEF VAR c-it-codigo-fim     LIKE af-item-contr-estab.it-codigo    NO-UNDO.
DEF VAR i-cod-emitente-ini  LIKE af-item-contr-estab.cod-emitente NO-UNDO.
DEF VAR i-cod-emitente-fim  LIKE af-item-contr-estab.cod-emitente NO-UNDO.
DEF VAR i-nr-versao-ini     LIKE af-item-contr-estab.nr-versao    NO-UNDO.
DEF VAR i-nr-versao-fim     LIKE af-item-contr-estab.nr-versao    NO-UNDO.

DEFINE TEMP-TABLE tt-versao-data NO-UNDO
    FIELD nr-versao      LIKE af-versao-avaliacao.nr-versao
    FIELD desc-versao    LIKE af-versao-avaliacao.desc-versao
    FIELD ano-avaliacao  LIKE af-versao-avaliacao.ano-avaliacao
    FIELD nr-periodo     LIKE af-versao-avaliacao.nr-periodo
    FIELD data-ini       AS DATE
    FIELD data-fim       AS DATE
    INDEX data-inicial
          data-ini.

DEFINE TEMP-TABLE tt-item-data NO-UNDO
    FIELD nr-versao      LIKE af-versao-avaliacao.nr-versao
    FIELD desc-versao    LIKE af-versao-avaliacao.desc-versao
    FIELD ano-avaliacao  LIKE af-versao-avaliacao.ano-avaliacao
    FIELD nr-periodo     LIKE af-versao-avaliacao.nr-periodo
    FIELD data-ini       AS DATE
    FIELD data-fim       AS DATE
    INDEX data-inicial
          data-ini.

{utp/ut-glob.i}

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 18.75
         WIDTH              = 44.57.
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
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN piCriaFormula.
IF RETURN-VALUE = "NOK":U THEN
    RETURN "NOK":U.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-boaf007) THEN
       RUN afbo/boaf007.p PERSISTENT SET h-boaf007.  
    RUN openQueryStatic IN h-boaf007 (INPUT "Main":U) NO-ERROR.
    FOR EACH af-item-contr-estab-form NO-LOCK
        WHERE af-item-contr-estab-form.ep-codigo    = RowObject.ep-codigo
        AND   af-item-contr-estab-form.it-codigo    = RowObject.it-codigo
        AND   af-item-contr-estab-form.cod-emitente = RowObject.cod-emitente
        AND   af-item-contr-estab-form.nr-versao    = RowObject.nr-versao
        AND   af-item-contr-estab-form.cod-estabel  = RowObject.cod-estabel:
        RUN repositionRecord IN h-boaf007 (INPUT ROWID(af-item-contr-estab-form)).
        RUN deleteRecord IN h-boaf007.
    END.
    IF VALID-HANDLE(h-boaf007) THEN DO:
        DELETE PROCEDURE h-boaf007.
        ASSIGN h-boaf007 = ?.
    END.

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
RUN piCriaFormula.
IF RETURN-VALUE = "NOK":U THEN
    RETURN "NOK":U.
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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "hora-alter":U THEN ASSIGN pFieldValue = RowObject.hora-alter.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "usuar-alter":U THEN ASSIGN pFieldValue = RowObject.usuar-alter.
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
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
        WHEN "dt-alter":U THEN ASSIGN pFieldValue = RowObject.dt-alter.
        WHEN "dt-implantacao":U THEN ASSIGN pFieldValue = RowObject.dt-implantacao.
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
        WHEN "demerito":U THEN ASSIGN pFieldValue = RowObject.demerito.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescItem DBOProgram 
PROCEDURE getDescItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pc-item      LIKE item.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-desc-item LIKE item.desc-item NO-UNDO.

    FOR FIRST item FIELDS (desc-item)
        WHERE item.it-codigo = pc-item NO-LOCK: END.
    IF  AVAIL item THEN
        ASSIGN pc-desc-item = item.desc-item.    
    ELSE DO:
        ASSIGN pc-desc-item = "".
        RETURN "NOK":U.
    END.

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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "nr-dia-max":U THEN ASSIGN pFieldValue = RowObject.nr-dia-max.
        WHEN "nr-dia-min":U THEN ASSIGN pFieldValue = RowObject.nr-dia-min.
        WHEN "nr-versao":U  THEN ASSIGN pFieldValue = RowObject.nr-versao.
        WHEN "nr-versao-grp-avaliacao":U THEN ASSIGN pFieldValue = RowObject.nr-versao-grp-avaliacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ep-item
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo it-codigo
               retorna valor do campo cod-emitente
               retorna valor do campo nr-versao
               retorna valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo      LIKE af-item-contr-estab.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo      LIKE af-item-contr-estab.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente   LIKE af-item-contr-estab.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-versao      LIKE af-item-contr-estab.nr-versao NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel    LIKE af-item-contr-estab.cod-estabel NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo    = RowObject.ep-codigo
           pit-codigo    = RowObject.it-codigo
           pcod-emitente = RowObject.cod-emitente
           pnr-versao    = RowObject.nr-versao
           pcod-estabel  = RowObject.cod-estabel.

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
        WHEN "data-entrega":U THEN ASSIGN pFieldValue = RowObject.data-entrega.
        WHEN "preco":U THEN ASSIGN pFieldValue = RowObject.preco.
        WHEN "qualidade":U THEN ASSIGN pFieldValue = RowObject.qualidade.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNomeEmitente DBOProgram 
PROCEDURE getNomeEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM pi-emitente   LIKE emitente.cod-emitente NO-UNDO.
    DEF OUTPUT PARAM pc-nome-emit  LIKE emitente.nome-emit    NO-UNDO.

    FOR FIRST emitente FIELDS (nome-emit)
        WHERE emitente.cod-emitente = pi-emitente NO-LOCK: END.
    IF AVAIL emitente THEN
        ASSIGN pc-nome-emit = emitente.nome-emit.    
    ELSE DO:
        ASSIGN pc-nome-emit = "".
        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNomeEstabel DBOProgram 
PROCEDURE getNomeEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pc-estabelec   LIKE estabelec.cod-estabel NO-UNDO.
    DEF OUTPUT PARAM pc-nome-estab  LIKE estabelec.nome        NO-UNDO.

    FOR FIRST estabelec FIELDS (nome)
        WHERE estabelec.cod-estabel = pc-estabelec NO-LOCK: END.
    IF AVAIL estabelec THEN
        ASSIGN pc-nome-estab = estabelec.nome.    
    ELSE DO:
        ASSIGN pc-nome-estab = "".
        RETURN "NOK":U.
    END.

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
  Purpose:     Reposiciona registro com base no °ndice ep-item
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo it-codigo
               recebe valor do campo cod-emitente
               recebe valor do campo nr-versao
               recebe valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo       LIKE af-item-contr-estab.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo       LIKE af-item-contr-estab.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente    LIKE af-item-contr-estab.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnr-versao       LIKE af-item-contr-estab.nr-versao NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel     LIKE af-item-contr-estab.cod-estabel NO-UNDO.

    FIND FIRST bfaf-item-contr-estab WHERE 
        bfaf-item-contr-estab.ep-codigo = pep-codigo AND 
        bfaf-item-contr-estab.it-codigo = pit-codigo AND 
        bfaf-item-contr-estab.cod-emitente = pcod-emitente AND 
        bfaf-item-contr-estab.nr-versao    = pnr-versao AND
        bfaf-item-contr-estab.cod-estabel = pcod-estabel NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfaf-item-contr-estab THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfaf-item-contr-estab)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodGrpAvaliacao DBOProgram 
PROCEDURE openQueryCodGrpAvaliacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} for each {&TableName} where
                             {&TableName}.cod-grp-avaliacao = cCodGroAvaliacao AND
                             {&TableName}.nr-versao-grp-avaliacao = iNrVersao
                             NO-LOCK INDEXED-REPOSITION.
        
    RETURN "OK":U.                                
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEstItemContr DBOProgram 
PROCEDURE openQueryEstItemContr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH af-item-contr-estab NO-LOCK WHERE 
                                     af-item-contr-estab.ep-codigo     = i-ep-codigo-usuario AND 
                                     af-item-contr-estab.cod-estabel  >= c-cod-estabel-ini   AND
                                     af-item-contr-estab.cod-estabel  <= c-cod-estabel-fim   AND
                                     af-item-contr-estab.it-codigo    >= c-it-codigo-ini     AND
                                     af-item-contr-estab.it-codigo    <= c-it-codigo-fim     AND
                                     af-item-contr-estab.cod-emitente >= i-cod-emitente-ini  AND 
                                     af-item-contr-estab.cod-emitente <= i-cod-emitente-fim  AND 
                                     af-item-contr-estab.nr-versao    >= i-nr-versao-ini     AND 
                                     af-item-contr-estab.nr-versao    <= i-nr-versao-fim INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroItem DBOProgram 
PROCEDURE openQueryFiltroItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH af-item-contr-estab NO-LOCK WHERE 
                                     af-item-contr-estab.ep-codigo               = i-ep-codigo-usuario  AND 
                                     af-item-contr-estab.cod-grp-avaliacao       = c-cod-grp-avaliacao  AND
                                     af-item-contr-estab.nr-versao-grp-avaliacao = i-nr-versao-ini      AND
                                     af-item-contr-estab.cod-estabel             >= c-cod-estabel-ini   AND
                                     af-item-contr-estab.cod-estabel             <= c-cod-estabel-fim   AND
                                     af-item-contr-estab.it-codigo               >= c-it-codigo-ini     AND
                                     af-item-contr-estab.it-codigo               <= c-it-codigo-fim     AND
                                     af-item-contr-estab.cod-emitente            >= i-cod-emitente-ini  AND 
                                     af-item-contr-estab.cod-emitente            <= i-cod-emitente-fim  INDEXED-REPOSITION.

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
OPEN QUERY {&QueryName} FOR EACH af-item-contr-estab NO-LOCK  
    WHERE af-item-contr-estab.ep-codigo = i-ep-codigo-usuario INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaAlteracao DBOProgram 
PROCEDURE piAtualizaAlteracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN RowObject.usuar-alter = c-seg-usuario
           RowObject.hora-alter  = STRING(TIME,"HH:MM:SS")
           RowObject.dt-alter    = TODAY.
     
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaDados DBOProgram 
PROCEDURE piAtualizaDados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE  FOR ttAf-Item-Contr-Estab.
    DEFINE INPUT PARAMETER TABLE  FOR ttAf-Grp-Avaliacao.
    DEFINE INPUT PARAMETER TABLE  FOR ttAf-Grp-Avaliacao-Form.
    DEFINE INPUT PARAMETER c-cod-grp-avaliacao LIKE Af-Item-Contr-Estab.cod-grp-avaliacao.
    DEFINE INPUT PARAMETER i-nr-versao LIKE Af-Item-Contr-Estab.nr-versao.

   
    FOR EACH ttAf-Item-Contr-Estab NO-LOCK:
        IF ttAf-Item-Contr-Estab.cod-grp-avaliacao = c-cod-grp-avaliacao THEN DO:
    
            FIND bfAf-Item-Contr-Estab WHERE 
                 bfaf-item-contr-estab.ep-codigo    = i-ep-codigo-usuario AND
                 bfaf-item-contr-estab.cod-estabel  = ttAf-Item-Contr-Estab.cod-estabel AND
                 bfaf-item-contr-estab.it-codigo    = ttAf-Item-Contr-Estab.it-codigo AND
                 bfaf-item-contr-estab.cod-emitente = ttAf-Item-Contr-Estab.cod-emitente AND
                 bfaf-item-contr-estab.nr-versao    = ttAf-Item-Contr-Estab.nr-versao EXCLUSIVE-LOCK NO-ERROR.
        END.

        IF ttAf-Item-Contr-Estab.cod-grp-avaliacao <> c-cod-grp-avaliacao THEN NEXT.

       
        IF AVAIL bfaf-item-contr-estab and
             bfaf-item-contr-estab.log-inf-grp-aval THEN DO:
            FIND ttAf-Grp-Avaliacao WHERE 
                 ttAf-Grp-Avaliacao.ep-codigo = i-ep-codigo-usuario AND
                 ttAf-Grp-Avaliacao.cod-grp-avaliacao = c-cod-grp-avaliacao AND 
                 ttAf-Grp-Avaliacao.nr-versao = i-nr-versao NO-LOCK NO-ERROR.
            IF AVAIL ttAf-Grp-Avaliacao THEN DO:
                ASSIGN bfAf-Item-Contr-Estab.narrativa               = ttAf-Grp-Avaliacao.narrativa
                       bfAf-Item-Contr-Estab.dt-implantacao           = ttAf-Grp-Avaliacao.dt-implantacao
                       bfAf-Item-Contr-Estab.demerito                = ttAf-Grp-Avaliacao.demerito
                       bfAf-Item-Contr-Estab.nr-dia-max              = ttAf-Grp-Avaliacao.nr-dia-max
                       bfAf-Item-Contr-Estab.nr-dia-min              = ttAf-Grp-Avaliacao.nr-dia-min
                       bfAf-Item-Contr-Estab.data-entrega            = ttAf-Grp-Avaliacao.data-entrega
                       bfAf-Item-Contr-Estab.preco                   = ttAf-Grp-Avaliacao.preco
                       bfAf-Item-Contr-Estab.qualidade               = ttAf-Grp-Avaliacao.qualidade 
                       bfAf-Item-Contr-Estab.quantidade              = ttAf-Grp-Avaliacao.quantidade
                       bfAf-Item-Contr-Estab.log-considera-qtd-receb = ttAf-Grp-Avaliacao.log-considera-qtd-receb
                       bfAf-Item-Contr-Estab.log-considera-val-receb = ttAf-Grp-Avaliacao.log-considera-val-receb
                       bfAf-Item-Contr-Estab.pct-qtd-min             = ttAf-Grp-Avaliacao.pct-qtd-min
                       bfAf-Item-Contr-Estab.pct-val-min             = ttAf-Grp-Avaliacao.pct-val-min
                       bfAf-Item-Contr-Estab.pct-qtd-max             = ttAf-Grp-Avaliacao.pct-qtd-max
                       bfAf-Item-Contr-Estab.pct-val-max             = ttAf-Grp-Avaliacao.pct-val-max
                       bfAf-Item-Contr-Estab.ativo                   = ttAf-Grp-Avaliacao.ativo
                       bfAf-Item-Contr-Estab.usuar-alter             = c-seg-usuario
                       bfAf-Item-Contr-Estab.hora-alter              = STRING(TIME,"HH:MM:SS")
                       bfAf-Item-Contr-Estab.dt-alter                = TODAY
                       bfAf-Item-Contr-Estab.cod-grp-avaliacao       = c-cod-grp-avaliacao
                       bfAf-Item-Contr-Estab.nr-versao-grp-avaliacao = i-nr-versao.

                for each ttAf-item-contr-estab-form-old:
                    delete ttAf-item-contr-estab-form-old.
                end.

                FOR EACH Af-Item-Contr-Estab-Form WHERE 
                              Af-Item-Contr-Estab-Form.ep-codigo    = i-ep-codigo-usuario AND
                              Af-Item-Contr-Estab-Form.cod-estabel  = bfaf-item-contr-estab.cod-estabel AND
                              Af-Item-Contr-Estab-Form.it-codigo    = bfaf-item-contr-estab.it-codigo AND
                              Af-Item-Contr-Estab-Form.cod-emitente = bfaf-item-contr-estab.cod-emitente AND
                              Af-Item-Contr-Estab-Form.nr-versao    = bfAf-Item-Contr-Estab.nr-versao  EXCLUSIVE-LOCK: 
                          CREATE ttAf-item-contr-estab-form-old.
                          ASSIGN ttAf-item-contr-estab-form-old.nr-controle  = Af-item-contr-estab-form.nr-controle
                                 ttAf-item-contr-estab-form-old.dt-prox-aval = Af-item-contr-estab-form.dt-prox-aval
                                 ttAf-item-contr-estab-form-old.dt-ult-aval  = Af-item-contr-estab-form.dt-ult-aval.
                          DELETE Af-Item-Contr-Estab-Form.
                END.
                FOR EACH ttAf-Grp-Avaliacao-Form WHERE 
                         ttAf-Grp-Avaliacao-Form.ep-codigo = i-ep-codigo-usuario AND
                         ttAf-Grp-Avaliacao-Form.cod-grp-avaliacao = c-cod-grp-avaliacao AND
                         ttAf-Grp-Avaliacao-Form.nr-versao = i-nr-versao NO-LOCK:
                     FIND FIRST ttAf-item-contr-estab-form-old 
                          WHERE ttAf-item-contr-estab-form-old.nr-controle = ttAf-Grp-Avaliacao-Form.nr-controle NO-LOCK NO-ERROR.

                     CREATE Af-Item-Contr-Estab-Form.
                     ASSIGN Af-Item-Contr-Estab-Form.ep-codigo        = i-ep-codigo-usuario
                            Af-Item-Contr-Estab-Form.nr-versao        = bfAf-Item-Contr-Estab.nr-versao
                            Af-Item-Contr-Estab-Form.cod-estabel      = bfaf-item-contr-estab.cod-estabel 
                            Af-Item-Contr-Estab-Form.it-codigo        = bfaf-item-contr-estab.it-codigo
                            Af-Item-Contr-Estab-Form.cod-emitente     = bfaf-item-contr-estab.cod-emitente
                            Af-Item-Contr-Estab-Form.nr-controle      = ttAf-Grp-Avaliacao-Form.nr-controle
                            Af-Item-Contr-Estab-Form.seq              = ttAf-Grp-Avaliacao-Form.seq        
                            Af-Item-Contr-Estab-Form.percentual       = ttAf-Grp-Avaliacao-Form.percentual   
                            Af-Item-Contr-Estab-Form.dt-implantacao   = ttAf-Grp-Avaliacao-Form.dt-implantacao
                            Af-Item-Contr-Estab-Form.dt-alter         = ttAf-Grp-Avaliacao-Form.dt-alter       
                            Af-item-Contr-Estab-Form.cod-grp-resp     = ttAf-Grp-Avaliacao-form.cod-grp-resp
                            Af-Item-Contr-Estab-Form.hora-alter       = ttAf-Grp-Avaliacao-Form.hora-alter     
                            Af-Item-Contr-Estab-Form.usuar-alter      = ttAf-Grp-Avaliacao-Form.usuar-alter    
                            Af-Item-Contr-Estab-Form.narrativa        = ttAf-Grp-Avaliacao-Form.narrativa
                            Af-Item-Contr-Estab-Form.log-per-variavel = ttAf-Grp-Avaliacao-Form.log-per-variavel
                            Af-Item-Contr-Estab-Form.dt-prox-aval     = IF AVAIL ttAf-item-contr-estab-form-old THEN ttAf-item-contr-estab-form-old.dt-prox-aval
                                                                        ELSE ?
                            Af-Item-Contr-Estab-Form.dt-ult-aval      = IF AVAIL ttAf-item-contr-estab-form-old THEN ttAf-item-contr-estab-form-old.dt-ult-aval
                                                                        ELSE ?
                            Af-Item-Contr-Estab-Form.ind-tipo-periodo = ttAf-Grp-Avaliacao-Form.ind-tipo-periodo.
                END.
            END.
        END.

    END.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaFormula DBOProgram 
PROCEDURE piCriaFormula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
        IF NOT VALID-HANDLE(h-boaf007) THEN
           RUN afbo/boaf007.p PERSISTENT SET h-boaf007.  
        RUN openQueryStatic IN h-boaf007 (INPUT "Main":U) NO-ERROR.

        FOR EACH bttAf-item-contr-estab-form:
            DELETE bttAf-item-contr-estab-form.
        END.
        RUN emptyRowerrors IN h-boaf007.
        ASSIGN iPerc = 0.
        FOR EACH ttAf-item-contr-estab-form NO-LOCK:
            ASSIGN iPerc = iPerc + ttAf-item-contr-estab-form.percentual.
        END.
        IF iPerc <> 100 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-percentual-da-formula-devera-s AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Percentual_da_f¢rmula_dever†_ser_100%" *}
            ASSIGN c-lbl-liter-percentual-da-formula-devera-s = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-a-somatoria-do-ponto-de-contro AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "A_somat¢ria_do_ponto_de_controle_dever†_ser_igual_a_100%" *}
            ASSIGN c-lbl-liter-a-somatoria-do-ponto-de-contro = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="17567"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-percentual-da-formula-devera-s"
                    &ErrorHelp="c-lbl-liter-a-somatoria-do-ponto-de-contro"}
            return "NOK":U.
        END.

        FOR EACH ttAf-item-contr-estab-form:
            CREATE bttAf-item-contr-estab-form.
            BUFFER-COPY ttAf-item-contr-estab-form TO bttAf-item-contr-estab-form.
            
            RUN gotokey IN h-boaf007  (INPUT ttAf-item-contr-estab-form.ep-codigo,
                                       INPUT ttAf-item-contr-estab-form.it-codigo,
                                       INPUT ttaf-item-contr-estab-form.cod-emitente,
                                       INPUT ttAf-item-contr-estab-form.nr-versao,
                                       INPUT ttaf-item-contr-estab-form.cod-estabel,
                                       INPUT ttaf-item-contr-estab-form.seq).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN EMPTYRowObject IN h-boaf007.
                RUN setRecord IN h-boaf007 (INPUT TABLE bttAf-item-contr-estab-form).
                RUN updateRecord IN h-boaf007.
            END.
            ELSE DO:
                RUN EMPTYRowObject IN h-boaf007.
                RUN newRecord  IN h-boaf007.
                RUN setRecord IN h-boaf007 (INPUT TABLE bttAf-item-contr-estab-form).
                RUN createRecord IN h-boaf007.
            END.
            DELETE bttAf-item-contr-estab-form.
        END.
        FOR EACH af-item-contr-estab-form
            WHERE af-item-contr-estab-form.ep-codigo    = RowObject.ep-codigo
            AND   af-item-contr-estab-form.it-codigo    = RowObject.it-codigo
            AND   af-item-contr-estab-form.cod-emitente = RowObject.cod-emitente
            AND   af-item-contr-estab-form.nr-versao    = RowObject.nr-versao
            AND   af-item-contr-estab-form.cod-estabel  = RowObject.cod-estabel:
            FIND ttAf-item-contr-estab-form OF af-item-contr-estab-form NO-LOCK NO-ERROR.
            IF NOT AVAIL ttAf-item-contr-estab-form THEN DO:
               RUN repositionRecord IN h-boaf007 (INPUT ROWID(af-item-contr-estab-form)).
               RUN deleteRecord IN h-boaf007.
            END.
        END.
        IF VALID-HANDLE(h-boaf007) THEN DO:
            DELETE PROCEDURE h-boaf007.
            ASSIGN h-boaf007 = ?.
        END.

        RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEliminaCodGrpAvaliacao DBOProgram 
PROCEDURE piEliminaCodGrpAvaliacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodEstabel      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pItCodigo        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pCodEmitente     AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER pCodGrpAvaliacao AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pNrVersao        AS INTEGER   NO-UNDO.

FIND bfaf-item-contr-estab WHERE 
       bfaf-item-contr-estab.ep-codigo    = i-ep-codigo-usuario AND
       bfaf-item-contr-estab.cod-estabel  = pCodEstabel  AND
       bfaf-item-contr-estab.cod-emitente = pCodEmitente AND 
       bfaf-item-contr-estab.it-codigo    = pItCodigo AND
       bfaf-item-contr-estab.cod-grp-avaliacao = pCodGrpAvaliacao AND 
       bfaf-item-contr-estab.nr-versao    = pNrVersao EXCLUSIVE-LOCK NO-ERROR.

IF AVAIL bfaf-item-contr-estab THEN
    ASSIGN bfaf-item-contr-estab.cod-grp-avaliacao = "".

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGravaCodGrpAvaliacao DBOProgram 
PROCEDURE piGravaCodGrpAvaliacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodEstabel      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pItCodigo        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pCodEmitente     AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER pNrVersao        AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER pCodGrpAvaliacao AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pNrVersaoGrpAval AS INTEGER   NO-UNDO.

FIND FIRST bfaf-item-contr-estab WHERE bfaf-item-contr-estab.ep-codigo               = i-ep-codigo-usuario 
                                 AND   bfaf-item-contr-estab.cod-estabel             = pCodEstabel
                                 AND   bfaf-item-contr-estab.cod-emitente            = pCodEmitente 
                                 AND   bfaf-item-contr-estab.it-codigo               = pItCodigo
                                 AND   bfaf-item-contr-estab.nr-versao               = pNrVersao
                                 AND   bfaf-item-contr-estab.cod-grp-avaliacao       = pCodGrpAvaliacao
                                 AND   bfaf-item-contr-estab.nr-versao-grp-avaliacao = pNrVersaoGrpAval
                                 NO-LOCK NO-ERROR.
IF NOT AVAIL bfaf-item-contr-estab THEN DO:
    CREATE bfaf-item-contr-estab.
    ASSIGN bfaf-item-contr-estab.ep-codigo               = i-ep-codigo-usuario
           bfaf-item-contr-estab.cod-estabel             = pCodEstabel     
           bfaf-item-contr-estab.cod-emitente            = pCodEmitente    
           bfaf-item-contr-estab.it-codigo               = pItCodigo 
           bfaf-item-contr-estab.nr-versao               = pNrVersao   /*pNrVersaoGrpAval*/
           bfaf-item-contr-estab.cod-grp-avaliacao       = pCodGrpAvaliacao
           bfaf-item-contr-estab.nr-versao-grp-avaliacao = pNrVersaoGrpAval.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRecebeFormula DBOProgram 
PROCEDURE piRecebeFormula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM TABLE FOR ttAf-item-contr-estab-form.
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaVersoesData DBOProgram 
PROCEDURE piRetornaVersoesData :
/*------------------------------------------------------------------------------
  Purpose:     Recebe uma temp-table de vers‰es com as datas iniciais informadas. Retorna a mesma temp-table com as datas finais calculadas.
  Parameters:  pep-codigo - recebe o codigo da empresa
               pit-codigo - recebe o codigo do item
               pcod-emitente - recebe o codigo do emitente
               pcod-estabel - recebe o codigo do estabelecimento
               tt-versao-data - recebe uma temp-table carregada com as vers‰es e datas iniciais 
               tt-item-data   - retorna a temp-table tt-versao-data com as datas finais preenchidas.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo    LIKE {&TableName}.ep-codigo.
    DEFINE INPUT PARAMETER pit-codigo    LIKE {&TableName}.it-codigo.
    DEFINE INPUT PARAMETER pcod-emitente LIKE {&TableName}.cod-emitente.
    DEFINE INPUT PARAMETER pcod-estabel  LIKE {&TableName}.cod-estabel.
    
    DEFINE INPUT  PARAMETER TABLE FOR tt-versao-data.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-item-data. 
    EMPTY TEMP-TABLE tt-item-data.
    FOR EACH tt-item-data:
        DELETE tt-item-data.
    END.


    FOR EACH bfaf-item-contr-estab NO-LOCK
        WHERE bfaf-item-contr-estab.ep-codigo    = pep-codigo
        AND   bfaf-item-contr-estab.it-codigo    = pit-codigo
        AND   bfaf-item-contr-estab.cod-emitente = pcod-emitente
        AND   bfaf-item-contr-estab.cod-estabel  = pcod-estabel
        AND   bfaf-item-contr-estab.ativo:

        CREATE tt-item-data.
        FOR FIRST tt-versao-data NO-LOCK
            WHERE tt-versao-data.nr-versao = bfaf-item-contr-estab.nr-versao:
            BUFFER-COPY tt-versao-data TO tt-item-data.
        END.
    END.

    DEFINE BUFFER bftt-item-data FOR tt-item-data.
    FOR EACH tt-item-data EXCLUSIVE-LOCK:
    
        FIND FIRST bftt-item-data 
            WHERE bftt-item-data.nr-versao = tt-item-data.nr-versao NO-LOCK NO-ERROR.
        /* Buscar o per°odo seguinte, pois a data de in°cio dele determina a data de tÇrmino do per°odo anterior*/
        FIND NEXT bftt-item-data NO-LOCK NO-ERROR.
    
        IF AVAIL bftt-item-data THEN DO:
            ASSIGN tt-item-data.data-fim = bftt-item-data.data-ini - 1.
        END.
        ELSE DO:
            ASSIGN tt-item-data.data-fim = 12/31/9999.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaInclusaoEmitente DBOProgram 
PROCEDURE piValidaInclusaoEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodEmitente     AS INTEGER   NO-UNDO.


FIND FIRST emitente 
    WHERE emitente.cod-emitente = pCodEmitente NO-LOCK NO-ERROR.

IF NOT AVAIL emitente THEN
    RETURN "NOK":U.
ELSE
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaInclusaoEstab DBOProgram 
PROCEDURE piValidaInclusaoEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodEstabel      AS CHARACTER NO-UNDO.

FIND FIRST estabelec 
    WHERE estabelec.cod-estabel = pCodEstabel NO-LOCK NO-ERROR. 

IF NOT AVAIL estabelec THEN 
    RETURN "NOK":U.
ELSE
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaInclusaoGrpAval DBOProgram 
PROCEDURE piValidaInclusaoGrpAval :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodEstabel      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pItCodigo        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pCodEmitente     AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER pNrVersao        AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER pGrpCodAval     AS CHARACTER NO-UNDO.

FIND FIRST af-item-contr-estab WHERE 
     af-item-contr-estab.ep-codigo    = i-ep-codigo-usuario AND
     af-item-contr-estab.cod-estabel  = pCodEstabel AND
     af-item-contr-estab.it-codigo    = pItCodigo AND
     af-item-contr-estab.cod-emitente = pCodEmitente  AND 
     af-item-contr-estab.nr-versao    = pNrVersao NO-LOCK NO-ERROR. 

IF AVAIL af-item-contr-estab AND 
    af-item-contr-estab.cod-grp-avaliacao <> "" THEN DO: 
    ASSIGN pGrpCodAval = af-item-contr-estab.cod-grp-avaliacao.
    RETURN "NOK":U.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaInclusaoItem DBOProgram 
PROCEDURE piValidaInclusaoItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pItCodigo        AS CHARACTER NO-UNDO.


FIND FIRST ITEM
    WHERE ITEM.it-codigo = pItCodigo NO-LOCK NO-ERROR.

IF NOT AVAIL ITEM THEN
    RETURN "NOK":U.
ELSE
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodGrpAvaliacao DBOProgram 
PROCEDURE setConstraintCodGrpAvaliacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pCodGrpAvaliacao AS CHARACTER NO-UNDO.
DEF INPUT PARAM pNrVersao        AS INTEGER NO-UNDO.

ASSIGN  cCodGroAvaliacao = pCodGrpAvaliacao
        iNRVersao        = pNrVersao.

RETURN "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEstItemContr DBOProgram 
PROCEDURE setConstraintEstItemContr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pc-cod-estabel-ini   LIKE af-item-contr-estab.cod-estabel  NO-UNDO.
DEF INPUT PARAM pc-cod-estabel-fim   LIKE af-item-contr-estab.cod-estabel  NO-UNDO.
DEF INPUT PARAM pc-it-codigo-ini     LIKE af-item-contr-estab.it-codigo    NO-UNDO.
DEF INPUT PARAM pc-it-codigo-fim     LIKE af-item-contr-estab.it-codigo    NO-UNDO.
DEF INPUT PARAM pi-cod-emitente-ini  LIKE af-item-contr-estab.cod-emitente NO-UNDO.
DEF INPUT PARAM pi-cod-emitente-fim  LIKE af-item-contr-estab.cod-emitente NO-UNDO.
DEF INPUT PARAM pi-nr-versao-ini     LIKE af-item-contr-estab.nr-versao    NO-UNDO.
DEF INPUT PARAM pi-nr-versao-fim     LIKE af-item-contr-estab.nr-versao    NO-UNDO.

ASSIGN c-cod-estabel-ini  = pc-cod-estabel-ini
       c-cod-estabel-fim  = pc-cod-estabel-fim
       c-it-codigo-ini    = pc-it-codigo-ini   
       c-it-codigo-fim    = pc-it-codigo-fim   
       i-cod-emitente-ini = pi-cod-emitente-ini
       i-cod-emitente-fim = pi-cod-emitente-fim
       i-nr-versao-ini    = pi-nr-versao-ini
       i-nr-versao-fim    = pi-nr-versao-fim.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroItem DBOProgram 
PROCEDURE setConstraintFiltroItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pc-cod-grp-avaliacao LIKE af-grp-avaliacao.cod-grp-avaliacao NO-UNDO.
DEF INPUT PARAM pc-cod-estabel-ini   LIKE af-item-contr-estab.cod-estabel  NO-UNDO.
DEF INPUT PARAM pc-cod-estabel-fim   LIKE af-item-contr-estab.cod-estabel  NO-UNDO.
DEF INPUT PARAM pc-it-codigo-ini     LIKE af-item-contr-estab.it-codigo    NO-UNDO.
DEF INPUT PARAM pc-it-codigo-fim     LIKE af-item-contr-estab.it-codigo    NO-UNDO.
DEF INPUT PARAM pi-cod-emitente-ini  LIKE af-item-contr-estab.cod-emitente NO-UNDO.
DEF INPUT PARAM pi-cod-emitente-fim  LIKE af-item-contr-estab.cod-emitente NO-UNDO.
DEF INPUT PARAM pi-nr-versao         LIKE af-item-contr-estab.nr-versao    NO-UNDO.

ASSIGN c-cod-grp-avaliacao = pc-cod-grp-avaliacao
       c-cod-estabel-ini   = pc-cod-estabel-ini
       c-cod-estabel-fim   = pc-cod-estabel-fim
       c-it-codigo-ini     = pc-it-codigo-ini   
       c-it-codigo-fim     = pc-it-codigo-fim   
       i-cod-emitente-ini  = pi-cod-emitente-ini
       i-cod-emitente-fim  = pi-cod-emitente-fim
       i-nr-versao-ini     = pi-nr-versao.

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
    IF pType = "CREATE":U THEN DO:
       FIND bf{&TableName}
           WHERE bf{&TableName}.ep-codigo    = RowObject.ep-codigo
           AND   bf{&TableName}.it-codigo    = RowObject.it-codigo
           AND   bf{&TableName}.cod-emitente = RowObject.cod-emitente
           AND   bf{&TableName}.nr-versao    = RowObject.nr-versao
           AND   bf{&TableName}.cod-estabel  = RowObject.cod-estabel
           NO-LOCK NO-ERROR.
       IF AVAIL bf{&TableName} THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-ponto-de-controle-item-estabel AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ponto_de_Controle_Item_Estabelecimento" *}
            ASSIGN c-lbl-liter-ponto-de-controle-item-estabel = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="7"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-ponto-de-controle-item-estabel"}
            return "NOK":U.
       END.       
       FIND ITEM 
           WHERE ITEM.it-codigo = RowObject.it-codigo NO-LOCK NO-ERROR.
       IF NOT AVAIL item THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-item-material AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item_Material" *}
            ASSIGN c-lbl-liter-item-material = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="56"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-item-material"}
            return "NOK":U.
       END.
       FIND estabelec
           WHERE estabelec.cod-estabel = RowObject.cod-estabel NO-LOCK NO-ERROR.
       IF NOT AVAIL item THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-estabelecimento AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Estabelecimento" *}
            ASSIGN c-lbl-liter-estabelecimento = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="56"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-estabelecimento"}
            return "NOK":U.
       END.
       FIND emitente
           WHERE emitente.cod-emitente = RowObject.cod-emitente NO-LOCK NO-ERROR.
       IF NOT AVAIL emitente THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-fornecedor AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Fornecedor" *}
            ASSIGN c-lbl-liter-fornecedor = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="56"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-fornecedor"}
            return "NOK":U.
       END.
       FIND FIRST af-versao-avaliacao
           WHERE af-versao-avaliacao.ep-codigo = RowObject.ep-codigo
           AND   af-versao-avaliacao.nr-versao = RowObject.nr-versao NO-LOCK NO-ERROR.
       IF NOT AVAIL af-versao-avaliacao THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-versao-avaliacao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Vers∆o_Avaliaá∆o" *}
            ASSIGN c-lbl-liter-versao-avaliacao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                    &ErrorNumber="56"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-versao-avaliacao"}
            return "NOK":U.
       END.
    END.

    IF pType = "CREATE":u OR pType = "UPDATE":U THEN DO:
       IF RowObject.cod-grp-avaliacao <> "" THEN DO:
           FIND FIRST af-grp-avaliacao
               WHERE af-grp-avaliacao.cod-grp-avaliacao = RowObject.cod-grp-avaliacao
               AND   af-grp-avaliacao.nr-versao         = RowObject.nr-versao-grp-avaliacao NO-LOCK NO-ERROR.
           IF NOT AVAIL af-grp-avaliacao THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-grupo-de-avaliacao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Grupo_de_Avaliaá∆o" *}
                ASSIGN c-lbl-liter-grupo-de-avaliacao = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                        &ErrorNumber="56"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"
                        &ErrorParameters="c-lbl-liter-grupo-de-avaliacao"}
                return "NOK":U.
           END.
       END.
    END.

    IF pType = "DELETE":U THEN DO:
        FIND FIRST param-af NO-LOCK
            WHERE param-af.ep-codigo = RowObject.ep-codigo NO-ERROR.
        
        IF CAN-FIND(FIRST af-contr-indice
                        WHERE af-contr-indice.ep-codigo    = RowObject.ep-codigo
                        AND   af-contr-indice.it-codigo    = RowObject.it-codigo
                        AND   af-contr-indice.cod-estabel  = RowObject.cod-estabel
                        AND   af-contr-indice.cod-emitente = RowObject.cod-emitente
                        AND   af-contr-indice.nr-versao    = RowObject.nr-versao) AND NOT param-af.log-elimina-relac THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-item-x-estabelecimento-x-forne AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item_x_Estabelecimento_x_Fornecedor" *}
            ASSIGN c-lbl-liter-item-x-estabelecimento-x-forne = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-indice-de-ponto-de-controle AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "÷ndice_de_ponto_de_controle" *}
            ASSIGN c-lbl-liter-indice-de-ponto-de-controle = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-merge-item-x-estabelecimento-x-forne AS CHARACTER NO-UNDO.
            ASSIGN c-lbl-merge-item-x-estabelecimento-x-forne = c-lbl-liter-item-x-estabelecimento-x-forne + ' ' + "~~" + ' ' + c-lbl-liter-indice-de-ponto-de-controle.
            {method/svc/errors/inserr.i
                        &ErrorNumber="5"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"
                        &ErrorParameters="c-lbl-merge-item-x-estabelecimento-x-forne"}
            RETURN "NOK":U.
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    IF pType <> "Delete" THEN RUN piAtualizaAlteracao.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
