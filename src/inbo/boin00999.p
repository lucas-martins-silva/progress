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
{include/i-prgvrs.i BOIN00999 2.00.00.016 } /*** "010016" 13/11/2023 11:45:45 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN00999 MAQ}
&ENDIF
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN00999
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName fechto-produt-period
&GLOBAL-DEFINE TableLabel Valores Fechamento Produtor por Per°odo
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
{inbo/boin00999.i RowObject}

DEFINE TEMP-TABLE tt-fechto-produt-period NO-UNDO LIKE fechto-produt-period
       FIELD checkSum          AS CHARACTER FORMAT 'x(1)'
       FIELD val-unit          AS DECIMAL 
       FIELD val-total         AS DECIMAL
       FIELD val-per-anterior  AS DECIMAL 
       FIELD diferenca         AS DECIMAL
       FIELD cidade            LIKE loc-entr.cidade
       FIELD nome-abrev        LIKE emitente.nome-abrev
       FIELD grp-produt        LIKE grp-produt.des-grp-produt
       FIELD r-rowid           AS ROWID.  

{aqp/aq0315.i} /*tt-filtro*/

{utp/ut-glob.i}

DEFINE VARIABLE c-cod-estabel LIKE RowObject.cod-estabel NO-UNDO.
DEFINE VARIABLE c-cod-period  LIKE RowObject.cod-period  NO-UNDO.
DEFINE VARIABLE c-it-codigo   LIKE RowObject.it-codigo   NO-UNDO.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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
         HEIGHT             = 24.54
         WIDTH              = 67.57.
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
        WHEN "cod-period":U THEN ASSIGN pFieldValue = RowObject.cod-period.
        WHEN "cod-propried":U THEN ASSIGN pFieldValue = RowObject.cod-propried.
        WHEN "cod-usuar-alter":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-alter.
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
        WHEN "dat-alter":U THEN ASSIGN pFieldValue = RowObject.dat-alter.
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
        WHEN "qtd-period":U THEN ASSIGN pFieldValue = RowObject.qtd-period.
        WHEN "val-bonus-fix":U THEN ASSIGN pFieldValue = RowObject.val-bonus-fix.
        WHEN "val-bonus-fix-inf":U THEN ASSIGN pFieldValue = RowObject.val-bonus-fix-inf.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-livre-3":U THEN ASSIGN pFieldValue = RowObject.val-livre-3.
        WHEN "val-livre-4":U THEN ASSIGN pFieldValue = RowObject.val-livre-4.
        WHEN "val-livre-5":U THEN ASSIGN pFieldValue = RowObject.val-livre-5.
        WHEN "val-livre-6":U THEN ASSIGN pFieldValue = RowObject.val-livre-6.
        WHEN "val-preco-base":U THEN ASSIGN pFieldValue = RowObject.val-preco-base.
        WHEN "val-preco-final-inf":U THEN ASSIGN pFieldValue = RowObject.val-preco-final-inf.
        WHEN "val-var-qualid":U THEN ASSIGN pFieldValue = RowObject.val-var-qualid.
        WHEN "val-var-volum":U THEN ASSIGN pFieldValue = RowObject.val-var-volum.
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
        WHEN "idi-situacao":U THEN ASSIGN pFieldValue = RowObject.idi-situacao.
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
  Purpose:     Retorna valores dos campos do °ndice fech-per-idx
  Parameters:  
               retorna valor do campo cod-period
               retorna valor do campo cdn-produt-rural
               retorna valor do campo cod-propried
               retorna valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-period LIKE fechto-produt-period.cod-period NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-produt-rural LIKE fechto-produt-period.cdn-produt-rural NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-propried LIKE fechto-produt-period.cod-propried NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE fechto-produt-period.it-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-period = RowObject.cod-period
           pcdn-produt-rural = RowObject.cdn-produt-rural
           pcod-propried = RowObject.cod-propried
           pit-codigo = RowObject.it-codigo.

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
  Purpose:     Reposiciona registro com base no °ndice fech-per-idx
  Parameters:  
               recebe valor do campo cod-period
               recebe valor do campo cdn-produt-rural
               recebe valor do campo cod-propried
               recebe valor do campo it-codigo
               recebe valor do campo cod-estabel 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-period LIKE fechto-produt-period.cod-period NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-produt-rural LIKE fechto-produt-period.cdn-produt-rural NO-UNDO.
    DEFINE INPUT PARAMETER pcod-propried LIKE fechto-produt-period.cod-propried NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE fechto-produt-period.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE fechto-produt-period.cod-estabel NO-UNDO.

    FIND FIRST bffechto-produt-period WHERE 
        bffechto-produt-period.cod-period = pcod-period AND 
        bffechto-produt-period.cdn-produt-rural = pcdn-produt-rural AND 
        bffechto-produt-period.cod-propried = pcod-propried AND 
        bffechto-produt-period.it-codigo = pit-codigo AND 
        bffechto-produt-period.cod-estabel = pcod-estabel NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bffechto-produt-period THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bffechto-produt-period)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPeriodoItem DBOProgram 
PROCEDURE setConstraintPeriodoItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER p-cod-period LIKE RowObject.cod-period NO-UNDO.
    DEF INPUT PARAMETER p-it-codigo  LIKE RowObject.it-codigo  NO-UNDO.

    ASSIGN c-cod-period = p-cod-period
           c-it-codigo  = p-it-codigo.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPeriodoItem DBOProgram 
PROCEDURE openQueryPeriodoItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK WHERE     
                                 {&tableName}.cod-period = c-cod-period
                             AND {&tableName}.it-codigo = c-it-codigo INDEXED-REPOSITION.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEstabel DBOProgram 
PROCEDURE setConstraintEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER p-cod-estabel LIKE RowObject.cod-estabel NO-UNDO.
    
    ASSIGN c-cod-estabel = p-cod-estabel.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEstabel DBOProgram 
PROCEDURE openQueryEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK WHERE     
                                 {&tableName}.cod-estabel = c-cod-estabel INDEXED-REPOSITION.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTTFechtoProdutPeriod DBOProgram 
PROCEDURE getTTFechtoProdutPeriod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEFINE INPUT  PARAM TABLE FOR tt-filtro.
  DEFINE OUTPUT PARAM de-tot-qtd-period        AS DECIMAL NO-UNDO.
  DEFINE OUTPUT PARAM de-tot-valor             AS DECIMAL NO-UNDO.
  DEFINE OUTPUT PARAM de-tot-frete             AS DECIMAL NO-UNDO.
  DEFINE OUTPUT PARAM de-impto-sanidade-animal AS DECIMAL NO-UNDO.
  DEFINE OUTPUT PARAM TABLE FOR tt-fechto-produt-period.

  DEFINE VARIABLE h-boad098na  AS HANDLE NO-UNDO.

  DEFINE VARIABLE c-period-anterior LIKE RowObject.cod-period NO-UNDO.
  DEFINE VARIABLE c-cidade AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE c-nome-abrev LIKE emitente.nome-abrev NO-UNDO.


  IF NOT VALID-HANDLE(h-boad098na) THEN DO:
    RUN adbo/boad098na.p PERSISTENT SET h-boad098na.
  END.
  RUN openQueryStatic IN h-boad098na (INPUT "Main":U).

  ASSIGN de-tot-qtd-period        = 0  /*totais*/
         de-tot-valor             = 0
         de-tot-frete             = 0
         de-impto-sanidade-animal = 0.
  
  EMPTY TEMP-TABLE tt-fechto-produt-period NO-ERROR.

  FOR FIRST tt-filtro:

        FOR EACH {&tableName}
           WHERE {&tableName}.cod-period       =  tt-filtro.cod-period
             AND {&tableName}.it-codigo        =  tt-filtro.it-codigo
             AND {&tableName}.cod-estabel      >= tt-filtro.cod-estabel-ini     
             AND {&tableName}.cod-estabel      <= tt-filtro.cod-estabel-fim     
             AND {&tableName}.cod-regiao       >= tt-filtro.cod-regiao-ini      
             AND {&tableName}.cod-regiao       <= tt-filtro.cod-regiao-fim      
             AND {&tableName}.cod-rota         >= tt-filtro.cod-rota-ini        
             AND {&tableName}.cod-rota         <= tt-filtro.cod-rota-fim        
             AND {&tableName}.cdn-produt-rural >= tt-filtro.cdn-produt-rural-ini
             AND {&tableName}.cdn-produt-rural <= tt-filtro.cdn-produt-rural-fim
             AND {&tableName}.cod-propried     >= tt-filtro.cod-propried-ini    
             AND {&tableName}.cod-propried     <= tt-filtro.cod-propried-fim NO-LOCK:

            IF NOT CAN-FIND (FIRST produt-rural WHERE produt-rural.cdn-produt-rural = {&tableName}.cdn-produt-rural
                               AND produt-rural.cdn-grp-produt >= tt-filtro.cdn-grp-produt-ini
                               AND produt-rural.cdn-grp-produt <= tt-filtro.cdn-grp-produt-fim) THEN
                NEXT.

            IF NOT tt-filtro.tg-sit-todos THEN DO: /*Quando for marcado todos n∆o È necess·rio verificar a situaÁ„o*/

                CASE {&tableName}.idi-situacao:
                
                    WHEN 1 THEN DO: /*Pendente*/
                        IF NOT tt-filtro.tg-sit-pendente THEN /*Usu·rio n„o marcou "Pendente" na seleÁ„o*/
                            NEXT.
                    END.
                    WHEN 2 THEN DO: /*Confirmada*/
                        IF NOT tt-filtro.tg-sit-confirmada THEN /*Usu·rio n„o marcou "Confirmada" na seleÁ„o*/
                            NEXT.
                    END.
                    WHEN 3 THEN DO: /*NF-Gerada*/
                        IF NOT tt-filtro.tg-sit-nf-gerada THEN /*Usu·rio n„o marcou "nf-gerada" na seleÁ„o*/
                            NEXT.
                    END.

                    OTHERWISE
                        NEXT.

                END CASE.

            END.
            
            CREATE tt-fechto-produt-period.

            /*buscando valor do perÌodo anterior*/
            ASSIGN c-period-anterior = IF INT(SUBSTRING({&tableName}.cod-period,1,2)) = 1  /*janeiro*/
                                           THEN "12" + STRING(INT(SUBSTRING({&tableName}.cod-period,3,4)) - 1)
                                       ELSE IF INT(SUBSTRING({&tableName}.cod-period,1,2)) <= 10
                                           THEN "0" + STRING(INT(SUBSTRING({&tableName}.cod-period,1,2)) - 1) + SUBSTRING({&tableName}.cod-period,3,4)
                                       ELSE     
                                           STRING(INT(SUBSTRING({&tableName}.cod-period,1,2)) - 1) + SUBSTRING({&tableName}.cod-period,3,4).

            FIND FIRST bffechto-produt-period WHERE bffechto-produt-period.cod-period       = c-period-anterior
                                                AND bffechto-produt-period.cod-propried     = {&tableName}.cod-propried
                                                AND bffechto-produt-period.cdn-produt-rural = {&tableName}.cdn-produt-rural NO-ERROR.

            IF AVAIL bffechto-produt-period THEN
                ASSIGN tt-fechto-produt-period.val-per-anterior = bffechto-produt-period.val-preco-final-inf. /*Preáo Ant*/
            ELSE
                ASSIGN tt-fechto-produt-period.val-per-anterior = 0. /*Preáo Ant*/
            /************************************/


            /*buscando cidade e nome do produtor*/
                IF VALID-HANDLE(h-boad098na) THEN DO:
                    RUN GotoKey in h-boad098na (INPUT {&tableName}.cdn-produt-rural).
                    IF RETURN-VALUE = "OK":U THEN DO:
                        RUN GetCharField in h-boad098na (INPUT "cidade", OUTPUT c-cidade).  
                        RUN GetCharField in h-boad098na (INPUT "nome-abrev", OUTPUT c-nome-abrev).
                    END.
                    ELSE 
                    ASSIGN c-cidade     = "":U
                           c-nome-abrev = "":U.
        
                END.
                
                ASSIGN tt-fechto-produt-period.cidade     = c-cidade
                       tt-fechto-produt-period.nome-abrev = c-nome-abrev.
            /********************************/

            /*buscando grupo do produtor*/
            FOR FIRST produt-rural FIELDS(cdn-grp-produt) NO-LOCK   
                WHERE produt-rural.cdn-produt-rural = {&tableName}.cdn-produt-rural:

                FOR FIRST grp-produt FIELDS(des-grp-produt) NO-LOCK
                    WHERE grp-produt.cdn-grp-produt = produt-rural.cdn-grp-produt:

                    ASSIGN tt-fechto-produt-period.grp-produt = grp-produt.des-grp-produt.

                END.

            END.
            /****************************/
            
            ASSIGN tt-fechto-produt-period.cod-period          = {&tableName}.cod-period                    
                   tt-fechto-produt-period.it-codigo           = {&tableName}.it-codigo       
                   tt-fechto-produt-period.cod-estabel         = {&tableName}.cod-estabel     
                   tt-fechto-produt-period.cod-regiao          = {&tableName}.cod-regiao      
                   tt-fechto-produt-period.cod-rota            = {&tableName}.cod-rota        
                   tt-fechto-produt-period.cdn-produt-rural    = {&tableName}.cdn-produt-rural
                   tt-fechto-produt-period.cod-propried        = {&tableName}.cod-propried    
                   tt-fechto-produt-period.qtd-period          = {&tableName}.qtd-period
                   tt-fechto-produt-period.val-preco-base      = {&tableName}.val-preco-base
                   tt-fechto-produt-period.val-var-qualid      = {&tableName}.val-var-qualid
                   tt-fechto-produt-period.val-var-volum       = {&tableName}.val-var-volum
                   tt-fechto-produt-period.val-bonus-fix       = {&tableName}.val-bonus-fix
                   tt-fechto-produt-period.val-unit            = {&tableName}.val-preco-base +   /* Pre Unit */
                                                                 {&tableName}.val-var-qualid +   /* Pre Unit */
                                                                 {&tableName}.val-var-volum  +   /* Pre Unit */
                                                                 {&tableName}.val-bonus-fix      /* Pre Unit */ 
                   tt-fechto-produt-period.val-bonus-fix-inf   = {&tableName}.val-bonus-fix-inf
                   tt-fechto-produt-period.val-preco-final-inf = {&tableName}.val-preco-final-inf
                   tt-fechto-produt-period.diferenca           = {&tableName}.val-preco-final-inf -       /* Diferenáa */ 
                                                                 tt-fechto-produt-period.val-per-anterior /* Diferenáa */
                   tt-fechto-produt-period.val-total           = tt-fechto-produt-period.qtd-period *        /* Total */
                                                                 tt-fechto-produt-period.val-preco-final-inf /* Total */  
                   tt-fechto-produt-period.val-frete           = {&tableName}.val-frete
    
                   de-tot-qtd-period = de-tot-qtd-period + {&tableName}.qtd-period            /*totais*/
                   de-tot-valor      = de-tot-valor      + tt-fechto-produt-period.val-total  /*totais*/
                   de-tot-frete      = de-tot-frete      + {&tableName}.val-frete             /*totais*/
    
                   tt-fechto-produt-period.cod-livre-2          = {&tableName}.cod-livre-2    /*Observaá∆o*/
                   tt-fechto-produt-period.idi-situacao         = {&tableName}.idi-situacao
                   tt-fechto-produt-period.val-livre-1          = {&tableName}.val-livre-1    /*Ajuste*/  
                   tt-fechto-produt-period.val-impto            = {&tableName}.val-impto      /*impto sanidade animal*/  
                   de-impto-sanidade-animal                     = de-impto-sanidade-animal + {&tableName}.val-impto
                   .

        END.

  END.

  IF VALID-HANDLE(h-boad098na) THEN DO:
    DELETE PROCEDURE h-boad098na.
    ASSIGN h-boad098na = ?.
  END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRowObject DBOProgram 
PROCEDURE updateRowObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-val-bonus-fix-inf   LIKE RowObject.val-bonus-fix-inf   NO-UNDO.
    DEFINE INPUT PARAMETER p-val-preco-final-inf LIKE RowObject.val-preco-final-inf NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-livre-2         LIKE RowObject.cod-livre-2         NO-UNDO.
    DEFINE INPUT PARAMETER p-val-livre-1         LIKE RowObject.val-livre-1         NO-UNDO.

    ASSIGN RowObject.val-bonus-fix-inf   = p-val-bonus-fix-inf  
           RowObject.val-preco-final-inf = p-val-preco-final-inf
           RowObject.idi-situacao        = 2                       /*Confirmada*/
           RowObject.cod-usuar-alter     = v_cod_usuar_corren
           RowObject.dat-alter           = TODAY
           RowObject.cod-livre-2         = p-cod-livre-2           /*Observaá∆o*/
           RowObject.val-livre-1         = p-val-livre-1.          /*Ajuste*/ 

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaRegistro DBOProgram 
PROCEDURE verificaRegistro :
/*------------------------------------------------------------------------------
  Purpose: Verificar consistància no registro enviado pela tela de ajuste de valores.    
  Parameters:  Tabela tt-fechto-produt-period-aux
------------------------------------------------------------------------------*/
  
  DEFINE INPUT  PARAM TABLE FOR tt-fechto-produt-period.
   
  DEFINE VARIABLE c-texto1 AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE c-texto2 AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c-texto3 AS CHARACTER NO-UNDO.

    FOR FIRST tt-fechto-produt-period:

        IF tt-fechto-produt-period.val-preco-final-inf <= 0 THEN DO:
    
            {method/svc/errors/inserr.i &ErrorNumber="54800"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="tt-fechto-produt-period.cdn-produt-rural"}

        END.

        IF tt-fechto-produt-period.idi-situacao = 3 THEN DO:
    
            {utp/ut-liter.i "simulaá‰es" *}
            ASSIGN c-texto1 = RETURN-VALUE.

            {utp/ut-liter.i "Nota_Fiscal_gerada" *}
            ASSIGN c-texto2 = RETURN-VALUE.

            {utp/ut-liter.i "N∆o_Ç_poss°vel_alterar_simulaá‰es_que_possuem_Nota_Fiscal_Gerada._Favor_verificar" *}
            ASSIGN c-texto3 = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="54801"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-texto1 + '~~~~' + c-texto2 + '~~~~' + c-texto3"}

        END.

    END.
  
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaIncentivo DBOProgram 
PROCEDURE retornaIncentivo :
/*------------------------------------------------------------------------------
  Purpose: Retornar o incentivo com base nas regras do engine de regras
  Parameters: 
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-cod-period          LIKE fechto-produt-period.cod-period          NO-UNDO.
    DEFINE INPUT  PARAMETER p-cdn-produt-rural    LIKE produt-rural.cdn-produt-rural            NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo           LIKE item.it-codigo                           NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel         LIKE fechto-produt-period.cod-estabel         NO-UNDO.
    DEFINE INPUT  PARAMETER p-qtd-period          LIKE fechto-produt-period.qtd-period          NO-UNDO.
    DEFINE INPUT  PARAMETER p-val-preco-base      LIKE fechto-produt-period.val-preco-base      NO-UNDO.
    DEFINE INPUT  PARAMETER p-val-var-volum       LIKE fechto-produt-period.val-var-volum       NO-UNDO.
    DEFINE INPUT  PARAMETER p-val-bonus-fix-inf   LIKE fechto-produt-period.val-bonus-fix-inf   NO-UNDO.
    DEFINE INPUT  PARAMETER p-val-var-qualid      LIKE fechto-produt-period.val-var-qualid      NO-UNDO.
    DEFINE INPUT  PARAMETER p-val-preco-final-inf LIKE fechto-produt-period.val-preco-final-inf NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-ajuste          LIKE fechto-produt-period.val-livre-1         NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-incent          LIKE fechto-produt-period.val-livre-1         NO-UNDO.
    DEFINE OUTPUT PARAMETER p-imp-retido          LIKE fechto-produt-period.val-livre-1         NO-UNDO.

    DEFINE VARIABLE da-data-inicial       AS DATE    NO-UNDO.
    DEFINE VARIABLE da-data-final         AS DATE    NO-UNDO.
    DEFINE VARIABLE i-cod-regra-utilizada AS INTEGER NO-UNDO.
    DEFINE VARIABLE l-erro                AS LOGICAL NO-UNDO.
    DEFINE VARIABLE da-ini-period         AS DATE    NO-UNDO.
    DEFINE VARIABLE da-fim-period         AS DATE    NO-UNDO.

    /*atravÈs do perÌodo obtÈm-se a data inicial e final*/
    ASSIGN da-ini-period = DATE("01/" + SUBSTRING(p-cod-period,1,2) + "/" + SUBSTRING(p-cod-period,3,4)).
           da-fim-period = IF INT(SUBSTRING(p-cod-period,1,2)) < 12 
                               THEN DATE("01/" + STRING(MONTH(da-ini-period) + 1) + "/" + STRING(YEAR(da-ini-period))) - 1  /* £ltimo dia do màs */
                               ELSE DATE("31/" +         "12"                     + "/" + STRING(YEAR(da-ini-period))).     /* digitado em tela  */
    /****************************************************/

    /*Busca dados no Engine de Regras para tratamento de incentivo*/
    FOR FIRST produt-rural FIELDS(cdn-produt-rural log-optan-incent) NO-LOCK
        WHERE produt-rural.cdn-produt-rural = p-cdn-produt-rural:
    END.

    IF NOT AVAIL produt-rural THEN
        RETURN "NOK":U.

    /*controle de quantidade entregue pelo produtor*/
    FOR FIRST quant-fornec-produt FIELDS(qtd-fornec) NO-LOCK
        WHERE quant-fornec-produt.cdn-produt-rural = produt-rural.cdn-produt-rural
          AND quant-fornec-produt.it-codigo        = p-it-codigo
          AND quant-fornec-produt.dat-inic         = DATE("01/01/" + SUBSTRING(p-cod-period,3,4))
          AND quant-fornec-produt.dat-fim          = DATE("31/12/" + SUBSTRING(p-cod-period,3,4)):
    END.

    /*Se n∆o achou, cria default*/
    IF NOT AVAIL quant-fornec-produt THEN DO:
        
        {utp/ut-liter.i Inclu°do_automaticamente_pelo_AQ0311 *}
        CREATE quant-fornec-produt.
        ASSIGN quant-fornec-produt.cdn-produt-rural = produt-rural.cdn-produt-rural
               quant-fornec-produt.it-codigo        = p-it-codigo
               quant-fornec-produt.dat-inic         = date("01/01/" + STRING(YEAR(da-ini-period)))
               quant-fornec-produt.dat-fim          = date("31/12/" + STRING(YEAR(da-fim-period)))
               quant-fornec-produt.qtd-fornec       = 0
               quant-fornec-produt.cod-obs          = RETURN-VALUE.

    END.

    IF CAN-FIND(FIRST config-operac 
                WHERE config-operac.cdn-empresa    = i-ep-codigo-usuario
                  AND config-operac.cod-estab      = p-cod-estabel
                  AND config-operac.cod-tip-operac = "AQR-NF-Produtor":U) THEN DO:

        EMPTY TEMP-TABLE tt-variavel.

        /*Carrega variaveis para o engine de regras*/
        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "optante":U
               tt-variavel.valor-variavel    = IF AVAIL produt-rural THEN string(produt-rural.log-optan-incent) ELSE "NO":U.

        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "item":U
               tt-variavel.valor-variavel    = p-it-codigo.
    
        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "vol-acum-ano":U
               tt-variavel.valor-variavel    = IF AVAIL quant-fornec-produt THEN string(quant-fornec-produt.qtd-fornec) ELSE "0".
    
        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "vol-mes":U
               tt-variavel.valor-variavel    = string(p-qtd-period).
    
        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "vol-ano-mes":U
               tt-variavel.valor-variavel    = IF AVAIL quant-fornec-produt THEN string(quant-fornec-produt.qtd-fornec + p-qtd-period) ELSE string(p-qtd-period).

        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "preco-base":U
               tt-variavel.valor-variavel    = string(p-val-preco-base,"->>>,>>9.9999").
    
        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "var-volume":U
               tt-variavel.valor-variavel    = string(p-val-var-volum,"->>>,>>9.9999").
    
        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "bonus-fix-inf":U
               tt-variavel.valor-variavel    = string(p-val-bonus-fix-inf,"->>>,>>9.9999").
        
        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "var-qualid":U
               tt-variavel.valor-variavel    = string(p-val-var-qualid,"->>>,>>9.9999").

        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "preco-final-inf":U
               tt-variavel.valor-variavel    = string(p-val-preco-final-inf,"->>>,>>9.9999").
    
        RUN cdp/cdapi034.p  (INPUT i-ep-codigo-usuario,
                             INPUT p-cod-estabel,
                             INPUT "AQR-NF-Produtor":U,
                             INPUT TABLE tt-variavel,
                             OUTPUT i-cod-regra-utilizada,
                             OUTPUT TABLE tt-retorno,
                             OUTPUT TABLE RowErrors).

        FOR EACH RowErrors:

            /*desconsidera erro de regra n∆o encontrada, neste caso ele ir† gerar as notas com os parametros informados em tela*/
            IF RowErrors.ErrorNumber = 25997 THEN
                NEXT.
                
            {method/svc/errors/inserr.i &ErrorNumber="RowErrors.ErrorNumber"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="RowErrors.ErrorDescription"}

            ASSIGN l-erro = YES.

        END.

        IF l-erro THEN
            RETURN "NOK":U.
        
        /*ajuste*/
        FOR FIRST tt-retorno 
            WHERE tt-retorno.campo-retorno = "val-ajuste":U:

            ASSIGN p-val-ajuste = DEC(tt-retorno.valor-retorno).

        END.

        /*valor do incentivo*/
        FOR FIRST tt-retorno 
            WHERE tt-retorno.campo-retorno = "val-despesa":U:

            ASSIGN p-val-incent = DEC(tt-retorno.valor-retorno).

        END.

        /*imposto retido*/
        FOR FIRST tt-retorno 
            WHERE tt-retorno.campo-retorno = "imp-retido":U:

            ASSIGN p-imp-retido = DEC(tt-retorno.valor-retorno).

        END.

    END.

    RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
