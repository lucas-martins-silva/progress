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
&GLOBAL-DEFINE DBOName BOCX343
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-docto-import
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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE KeyField1 it-codigo
&GLOBAL-DEFINE KeyField2 cod-emitente
&GLOBAL-DEFINE KeyField3 cod-pais
&GLOBAL-DEFINE KeyField4 cod-docto


/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cxbo/bocx343.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cItIni    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cItFim    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iPaisIni  AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPaisFim  AS INTEGER    NO-UNDO.
DEFINE VARIABLE iEmitIni  AS INTEGER    NO-UNDO.
DEFINE VARIABLE iEmitFim  AS INTEGER    NO-UNDO.
DEFINE VARIABLE cDoctoIni AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDoctoFim AS CHARACTER  NO-UNDO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE altera-it-codigo DBOProgram 
PROCEDURE altera-it-codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pc-it-codigo     LIKE ITEM.it-codigo NO-UNDO.
DEF INPUT  PARAM pc-it-codigo-new LIKE ITEM.it-codigo NO-UNDO.
DEF OUTPUT PARAM i-qtd-registros  AS INT              NO-UNDO.

    FOR EACH  bfitem-docto-import
        WHERE bfitem-docto-import.it-codigo = pc-it-codigo
        EXCLUSIVE-LOCK:
        ASSIGN bfitem-docto-import.it-codigo = pc-it-codigo-new
               i-qtd-registros               = i-qtd-registros + 1.
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
        WHEN "cod-docto":U THEN ASSIGN pFieldValue = RowObject.cod-docto.
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "cod-pais":U THEN ASSIGN pFieldValue = RowObject.cod-pais.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice itmdctmp-id
  Parameters:  
               retorna valor do campo it-codigo
               retorna valor do campo cod-emitente
               retorna valor do campo cod-pais
               retorna valor do campo cod-docto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item-docto-import.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE item-docto-import.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-pais LIKE item-docto-import.cod-pais NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-docto LIKE item-docto-import.cod-docto NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo
           pcod-emitente = RowObject.cod-emitente
           pcod-pais = RowObject.cod-pais
           pcod-docto = RowObject.cod-docto.

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
  Purpose:     Reposiciona registro com base no °ndice itmdctmp-id
  Parameters:  
               recebe valor do campo it-codigo
               recebe valor do campo cod-emitente
               recebe valor do campo cod-pais
               recebe valor do campo cod-docto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item-docto-import.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE item-docto-import.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcod-pais LIKE item-docto-import.cod-pais NO-UNDO.
    DEFINE INPUT PARAMETER pcod-docto LIKE item-docto-import.cod-docto NO-UNDO.

    FIND FIRST bfitem-docto-import WHERE 
        bfitem-docto-import.it-codigo = pit-codigo AND 
        bfitem-docto-import.cod-emitente = pcod-emitente AND 
        bfitem-docto-import.cod-pais = pcod-pais AND 
        bfitem-docto-import.cod-docto = pcod-docto NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-docto-import THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-docto-import)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixa DBOProgram 
PROCEDURE openQueryFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK 
                            WHERE {&tableName}.it-codigo    >= cItIni
                            AND   {&tableName}.it-codigo    <= cItFim
                            AND   {&tableName}.cod-pais     >= (IF {&tableName}.cod-pais = ? THEN ? ELSE iPaisIni)
                            AND   {&tableName}.cod-pais     <= (IF {&tableName}.cod-pais = ? THEN ? ELSE iPaisFim)
                            AND   {&tableName}.cod-emitente >= (IF {&tableName}.cod-emitente = ? THEN ? ELSE iEmitIni)
                            AND   {&tableName}.cod-emitente <= (IF {&tableName}.cod-emitente = ? THEN ? ELSE iEmitFim)
                            AND   {&tableName}.cod-docto    >= cDoctoIni
                            AND   {&tableName}.cod-docto    <= cDoctoFim
                            BY    {&tableName}.it-codigo  
                            BY    {&tableName}.cod-pais
                            BY    {&tableName}.cod-emitente
                            BY    {&tableName}.cod-docto INDEXED-REPOSITION.
    RETURN "ok":U.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixa DBOProgram 
PROCEDURE setConstraintFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pItIni    AS CHAR    NO-UNDO.
DEF INPUT PARAM pItFim    AS CHAR    NO-UNDO.
DEF INPUT PARAM pPaisIni  AS INTEGER NO-UNDO.
DEF INPUT PARAM pPaisFim  AS INTEGER NO-UNDO.
DEF INPUT PARAM pEmitIni  AS INTEGER NO-UNDO.
DEF INPUT PARAM pEmitFim  AS INTEGER NO-UNDO.
DEF INPUT PARAM pDoctoIni AS CHAR    NO-UNDO.
DEF INPUT PARAM pDoctoFim AS CHAR    NO-UNDO.

ASSIGN cItIni = pItIni
       cItFim = pItFim
       iPaisIni = pPaisIni
       iPaisFim = pPaisFim
       iEmitIni = pEmitIni
       iEmitFim = pEmitFim
       cDoctoIni = pDoctoIni
       cDoctoFim = pDoctoFim.

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
        IF pType = "Create":U  THEN DO:
            IF CAN-FIND(first bf{&TableName}
                        WHERE bf{&TableName}.it-codigo    = RowObject.it-codigo
                          AND bf{&TableName}.cod-pais     = RowObject.cod-pais
                          AND bf{&TableName}.cod-emitente = RowObject.cod-emitente
                          AND bf{&TableName}.cod-docto    = RowObject.cod-docto NO-LOCK) THEN
               /* Inicio -- Projeto Internacional */
               DO:
               DEFINE VARIABLE c-lbl-liter-item-x-documento-importacao AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Item_x_Documento_Importacao" *}
               ASSIGN c-lbl-liter-item-x-documento-importacao = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i
                  &ErrorNumber="1"
                  &ErrorType="EMS"
                  &ErrorParameters="c-lbl-liter-item-x-documento-importacao"}
               END. 
        END.


        IF pType = "Create":U OR pType = "Update":U THEN DO:
            IF NOT CAN-FIND(ITEM WHERE  
                        item.it-codigo = rowObject.it-codigo NO-LOCK) THEN     
                /* Inicio -- Projeto Internacional */
                DO:
                DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Item" *}
                ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                       &ErrorNumber="2"
                       &ErrorType="EMS"
                       &ErrorParameters="c-lbl-liter-item"}
                END. 
            
            IF NOT CAN-FIND(docto-import WHERE  
                        docto-import.cod-docto = rowObject.cod-docto NO-LOCK) THEN     
                /* Inicio -- Projeto Internacional */
                DO:
                DEFINE VARIABLE c-lbl-liter-documento AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Documento" *}
                ASSIGN c-lbl-liter-documento = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                       &ErrorNumber="2"
                       &ErrorType="EMS"
                       &ErrorParameters="c-lbl-liter-documento"}
                END.   
            
			IF program-name(3) MATCHES "*java/metadados.p*" THEN DO:
				IF RowObject.cod-pais = 0 THEN
					ASSIGN RowObject.cod-pais = ?.
				IF RowObject.cod-emitente = 0 THEN
					ASSIGN RowObject.cod-emitente = ?.					
			END.
			
			IF RowObject.cod-pais <> ? THEN DO: 
               IF NOT CAN-FIND(pais WHERE  
                           pais.cod-pais = rowObject.cod-pais NO-LOCK) THEN 
                 /* Inicio -- Projeto Internacional */
                 DO:
                 DEFINE VARIABLE c-lbl-liter-pais AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "Pa°s" *}
                 ASSIGN c-lbl-liter-pais = TRIM(RETURN-VALUE).
                 {method/svc/errors/inserr.i
                        &ErrorNumber="2"
                        &ErrorType="EMS"
                        &ErrorParameters="c-lbl-liter-pais"}
                 END. 
            END. 

			IF RowObject.cod-emitente <> ? THEN DO:
               IF NOT CAN-FIND(emitente WHERE  
                           emitente.cod-emitente = rowObject.cod-emitente NO-LOCK) THEN 
                  /* Inicio -- Projeto Internacional */
                  DO:
                  DEFINE VARIABLE c-lbl-liter-fornecedor AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "Fornecedor" *}
                  ASSIGN c-lbl-liter-fornecedor = TRIM(RETURN-VALUE).
                  {method/svc/errors/inserr.i
                        &ErrorNumber="2"
                        &ErrorType="EMS"
                        &ErrorParameters="c-lbl-liter-fornecedor"}
                  END. 
               END.       


        END.
            
            
            

                
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

