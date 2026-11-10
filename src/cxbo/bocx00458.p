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
{include/i-prgvrs.i BOCX00458 2.00.00.029} /*** "010029" 09/02/2026 08:53:25 ***/
/* ***************************  Definitions  ***************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00458
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName due-siscomex
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

{utp/ut-glob.i} /*Definiá∆o de vari†veis globais do sistema*/

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
{cxbo/bocx00458.i RowObject}

DEFINE TEMP-TABLE tt-row-doc-fiscal NO-UNDO
    FIELD r-rowid AS ROWID.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE de-cdd-due-ems         LIKE due-siscomex.cdd-due-ems      NO-UNDO.
DEFINE VARIABLE de-cdd-due-ems-ini     LIKE due-siscomex.cdd-due-ems      NO-UNDO.
DEFINE VARIABLE de-cdd-due-ems-fim     LIKE due-siscomex.cdd-due-ems      NO-UNDO.
DEFINE VARIABLE i-num-versao-due       LIKE due-siscomex.num-versao-due   NO-UNDO.
DEFINE VARIABLE c-cod-due-siscomex-ini LIKE due-siscomex.cod-due-siscomex NO-UNDO.
DEFINE VARIABLE c-cod-due-siscomex-fim LIKE due-siscomex.cod-due-siscomex NO-UNDO.
DEFINE VARIABLE c-cod-ruc-ini          LIKE due-siscomex.cod-ruc          NO-UNDO.
DEFINE VARIABLE c-cod-ruc-fim          LIKE due-siscomex.cod-ruc          NO-UNDO.
DEFINE VARIABLE c-cod-estabel-ini      LIKE due-siscomex.cod-estab        NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim      LIKE due-siscomex.cod-estab        NO-UNDO.
DEFINE VARIABLE d-dt-criacao-ini       LIKE due-siscomex.dat-criac        NO-UNDO.
DEFINE VARIABLE d-dt-criacao-fim       LIKE due-siscomex.dat-criac        NO-UNDO.
DEFINE VARIABLE c-lbl-help             AS   CHARACTER                     NO-UNDO.
DEFINE VARIABLE c-lbl-msg1             AS   CHARACTER                     NO-UNDO.
DEFINE VARIABLE c-cnpj                 AS   CHARACTER   FORMAT "x(19)":U  NO-UNDO.
DEFINE VARIABLE i-cont                 AS   INTEGER                       NO-UNDO.
DEFINE VARIABLE l-erro-caracter        AS   LOGICAL                       NO-UNDO.
DEFINE VARIABLE l-fn-due-manual        AS   LOGICAL                       NO-UNDO.
DEFINE VARIABLE l-ex7000c              AS   LOGICAL     INITIAL NO        NO-UNDO.

ASSIGN l-fn-due-manual = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-due-manual":U AND funcao.ativo).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Respons†vel por atualizar informaá‰es na tabela antes da 
               criaá∆o do registro
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN RowObject.dat-criac        = TODAY
           RowObject.hra-criac        = STRING(TIME, "HH:MM:SS":U)
           RowObject.cod-usuar-criac    = c-seg-usuario
           RowObject.idi-tratam-priorit = 1.

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
        WHEN "cod-chave-aces-due":U THEN ASSIGN pFieldValue = RowObject.cod-chave-aces-due.
        WHEN "cod-cnpj-cpf":U THEN ASSIGN pFieldValue = RowObject.cod-cnpj-cpf.
        WHEN "cod-cnpj-respons":U THEN ASSIGN pFieldValue = RowObject.cod-cnpj-respons.
        WHEN "cod-due-siscomex":U THEN ASSIGN pFieldValue = RowObject.cod-due-siscomex.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-incoterm":U THEN ASSIGN pFieldValue = RowObject.cod-incoterm.
        WHEN "cod-latitude-despch":U THEN ASSIGN pFieldValue = RowObject.cod-latitude-despch.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-longitude-despch":U THEN ASSIGN pFieldValue = RowObject.cod-longitude-despch.
        WHEN "cod-moed":U THEN ASSIGN pFieldValue = RowObject.cod-moed.
        WHEN "cod-pais-dest-final":U THEN ASSIGN pFieldValue = RowObject.cod-pais-dest-final.
        WHEN "cod-ruc":U THEN ASSIGN pFieldValue = RowObject.cod-ruc.
        WHEN "cod-telef":U THEN ASSIGN pFieldValue = RowObject.cod-telef.
        WHEN "cod-usuar-criac":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-criac.
        WHEN "des-email":U THEN ASSIGN pFieldValue = RowObject.des-email.
        WHEN "des-ender-despch":U THEN ASSIGN pFieldValue = RowObject.des-ender-despch.
        WHEN "des-ender-embarq":U THEN ASSIGN pFieldValue = RowObject.des-ender-embarq.
        WHEN "des-inform-compl":U THEN ASSIGN pFieldValue = RowObject.des-inform-compl.
        WHEN "hra-criac":U THEN ASSIGN pFieldValue = RowObject.hra-criac.
        WHEN "nom-contato":U THEN ASSIGN pFieldValue = RowObject.nom-contato.
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
        WHEN "dat-criac":U THEN ASSIGN pFieldValue = RowObject.dat-criac.
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
        WHEN "cdd-due-ems":U THEN ASSIGN pFieldValue = RowObject.cdd-due-ems.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-perc-comis-agent":U THEN ASSIGN pFieldValue = RowObject.val-perc-comis-agent.
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
        WHEN "cdn-aduana-despch":U THEN ASSIGN pFieldValue = RowObject.cdn-aduana-despch.
        WHEN "cdn-aduana-embarq":U THEN ASSIGN pFieldValue = RowObject.cdn-aduana-embarq.
        WHEN "cdn-moed-siscomex":U THEN ASSIGN pFieldValue = RowObject.cdn-moed-siscomex.
        WHEN "cdn-recinto-aduana-despch":U THEN ASSIGN pFieldValue = RowObject.cdn-recinto-aduana-despch.
        WHEN "cdn-recinto-aduana-embarq":U THEN ASSIGN pFieldValue = RowObject.cdn-recinto-aduana-embarq.
        WHEN "cdn-urf-despch":U THEN ASSIGN pFieldValue = RowObject.cdn-urf-despch.
        WHEN "cdn-urf-embarq":U THEN ASSIGN pFieldValue = RowObject.cdn-urf-embarq.
        WHEN "cod-enquad-1":U THEN ASSIGN pFieldValue = RowObject.cod-enquad-1.
        WHEN "cod-enquad-2":U THEN ASSIGN pFieldValue = RowObject.cod-enquad-2.
        WHEN "cod-enquad-3":U THEN ASSIGN pFieldValue = RowObject.cod-enquad-3.
        WHEN "cod-enquad-4":U THEN ASSIGN pFieldValue = RowObject.cod-enquad-4.
        WHEN "idi-caract-operac":U THEN ASSIGN pFieldValue = RowObject.idi-caract-operac.
        WHEN "idi-sit-especial":U THEN ASSIGN pFieldValue = RowObject.idi-sit-especial.
        WHEN "idi-sit-siscomex":U THEN ASSIGN pFieldValue = RowObject.idi-sit-siscomex.
        WHEN "idi-tratam-priorit":U THEN ASSIGN pFieldValue = RowObject.idi-tratam-priorit.
        WHEN "idi-via-transp":U THEN ASSIGN pFieldValue = RowObject.idi-via-transp.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-versao-due":U THEN ASSIGN pFieldValue = RowObject.num-versao-due.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice dclncxpr_id2
  Parameters:  
               retorna valor do campo cdd-due-ems
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdd-due-ems LIKE due-siscomex.cdd-due-ems NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdd-due-ems = RowObject.cdd-due-ems.

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
        WHEN "log-ativa":U   THEN ASSIGN pFieldValue = RowObject.log-ativa.
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
  Purpose:     Reposiciona registro com base no °ndice dclncxpr_id2
  Parameters:  
               recebe valor do campo cdd-due-ems
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdd-due-ems LIKE due-siscomex.cdd-due-ems NO-UNDO.

    FIND FIRST bfdue-siscomex WHERE 
        bfdue-siscomex.cdd-due-ems = pcdd-due-ems NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdue-siscomex THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdue-siscomex)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryData DBOProgram 
PROCEDURE openQueryData :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query a partir do campo "Data de Criaá∆o" e "Estabelecimento"
               Filtrados pelo programa de pesquisa z01cx00458
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cod-estabel >= c-cod-estabel-ini
                                 AND {&TABLENAME}.cod-estabel <= c-cod-estabel-fim 
                                 AND {&TABLENAME}.dat-criac   >= d-dt-criacao-ini 
                                 AND {&TABLENAME}.dat-criac   <= d-dt-criacao-fim NO-LOCK 
                                BY {&TABLENAME}.dat-criac
                                BY {&TABLENAME}.cod-estabel INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDUE DBOProgram 
PROCEDURE openQueryDUE :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query a partir do campo "DU-E Interno" e "DU-E Siscomex" 
               Filtrados pelo programa de pesquisa z01cx00458
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cdd-due-ems      >= de-cdd-due-ems-ini
                                 AND {&TABLENAME}.cdd-due-ems      <= de-cdd-due-ems-fim
                                 AND {&TABLENAME}.cod-due-siscomex >= c-cod-due-siscomex-ini
                                 AND {&TABLENAME}.cod-due-siscomex <= c-cod-due-siscomex-fim 
                                 AND {&TABLENAME}.cod-ruc          >= c-cod-ruc-ini 
                                 AND {&TABLENAME}.cod-ruc          <= c-cod-ruc-fim NO-LOCK 
                                BY {&TABLENAME}.cdd-due-ems INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDueByKey DBOProgram 
PROCEDURE openQueryDueByKey :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query a partir do campo "DU-E Interno" e "Vers„o" 
               Que sao chaves tabela 
               Filtrados pelo programa ex7000a
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cdd-due-ems      = de-cdd-due-ems
                                 AND {&TABLENAME}.num-versao-due   = i-num-versao-due NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query com todos os registros da tabela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piProximoDUE DBOProgram 
PROCEDURE piProximoDUE :
/*------------------------------------------------------------------------------
  Purpose:     Sugere pr¢xima numeraá∆o do c¢digo da DU-E Interno
  Parameters:  Sa°da p-cdd-due-ems: pr¢xima numeraá∆o sugerida pelo sistema
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-cdd-due-ems LIKE bf{&TableName}.cdd-due-ems NO-UNDO.
                
    FIND LAST bf{&TableName} NO-LOCK NO-ERROR.
    IF NOT AVAIL bf{&TableName} THEN
       ASSIGN p-cdd-due-ems = 1.
    ELSE 
        ASSIGN p-cdd-due-ems = bf{&TableName}.cdd-due-ems + 1.

    IF p-cdd-due-ems > 9999999999999999 THEN
       ASSIGN p-cdd-due-ems = 1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaEX7000c DBOProgram 
PROCEDURE piSetaEX7000c :
/*------------------------------------------------------------------------------
  Purpose:     Procedure respons†vel por setar a vari†vel "l-ex7000c" para 
               validar os enquadramentos que s∆o inseridos no Facilitador de 
               Preenchimento para os Itens da DU-E (EX7000c)
               
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-ex7000c AS LOGICAL NO-UNDO.

    ASSIGN l-ex7000c = pl-ex7000c.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaEnquadramentos DBOProgram 
PROCEDURE piValidaEnquadramentos :
/*------------------------------------------------------------------------------
  Purpose: Valida os enquadramentos da DU-e    
  Parameters: i-cod-enquad-1 (INPUT - Integer) - Primeiro enquadramento
              i-cod-enquad-2 (INPUT - Integer) - Segundo enquadramento
              i-cod-enquad-3 (INPUT - Integer) - Terceiro enquadramento
              i-cod-enquad-4 (INPUT - Integer) - Quarto enquadramento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER i-cod-enquad-1 LIKE due-siscomex.cod-enquad-1   NO-UNDO.
    DEFINE INPUT PARAMETER i-cod-enquad-2 LIKE due-siscomex.cod-enquad-2   NO-UNDO.
    DEFINE INPUT PARAMETER i-cod-enquad-3 LIKE due-siscomex.cod-enquad-3   NO-UNDO.
    DEFINE INPUT PARAMETER i-cod-enquad-4 LIKE due-siscomex.cod-enquad-4   NO-UNDO.

    IF rowObject.cod-enquad-1 = 0 THEN DO:
            {method/svc/errors/inserr.i
            &ErrorNumber="55945"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"}
    END.
    ELSE DO:
        IF NOT CAN-FIND(FIRST enquad-oper 
                        WHERE enquad-oper.cod-enquad = i-cod-enquad-1) THEN DO:
            {utp/ut-liter.i Enquadramento}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
    END.

    IF i-cod-enquad-2 > 0
    AND NOT CAN-FIND(FIRST enquad-oper 
                     where enquad-oper.cod-enquad = i-cod-enquad-2) THEN DO:
        {utp/ut-liter.i Enquadramento}
        {method/svc/errors/inserr.i
                &ErrorNumber="2"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="RETURN-VALUE"}
    END.

    IF i-cod-enquad-3 > 0
    AND NOT CAN-FIND(FIRST enquad-oper 
                     where enquad-oper.cod-enquad = i-cod-enquad-3) THEN DO:
        {utp/ut-liter.i Enquadramento}
        {method/svc/errors/inserr.i
                &ErrorNumber="2"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="RETURN-VALUE"}
    END.

    IF i-cod-enquad-4 > 0
    AND NOT CAN-FIND(FIRST enquad-oper 
                     where enquad-oper.cod-enquad = i-cod-enquad-4) THEN DO:
        {utp/ut-liter.i Enquadramento}
        {method/svc/errors/inserr.i
                &ErrorNumber="2"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="RETURN-VALUE"}
    END.

    IF RowObject.idi-sit-siscomex <> 12 THEN DO:

        /*Drawback Isená∆o*/
        IF (i-cod-enquad-1 = 81105
        OR  i-cod-enquad-2 = 81105
        OR  i-cod-enquad-3 = 81105 
        OR  i-cod-enquad-4 = 81105) THEN DO:
            {method/svc/errors/inserr.i
                    &ErrorNumber="56424"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"}
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaEnvio DBOProgram 
PROCEDURE piValidaEnvio :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es feitas no envio da DU-E para o Siscomex
  Parameters:  p-cdd-due-ems: N£mero interno da DU-E - (input)(integer)
               RowErrors: Temp-table de erros - (output)(temp-table)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cdd-due-ems LIKE due-siscomex.cdd-due-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE BUFFER bfdue-item FOR due-item.
    DEFINE VARIABLE h-bocx00460 AS HANDLE    NO-UNDO.
    DEFINE VARIABLE h-bocx00459 AS HANDLE    NO-UNDO.
    DEFINE VARIABLE c-lb-due    AS CHARACTER NO-UNDO.

    {utp/ut-liter.i a_DU-E *}
    ASSIGN c-lb-due = RETURN-VALUE.

    IF p-cdd-due-ems = ? OR p-cdd-due-ems <= 0 THEN DO:
        {utp/ut-liter.i "N£mero_da_DUE" *}
        {method/svc/errors/inserr.i
                    &ErrorNumber="366"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
    END.

    IF NOT CAN-FIND(FIRST bfdue-siscomex
                    WHERE bfdue-siscomex.cdd-due-ems = p-cdd-due-ems) THEN DO:
        {utp/ut-liter.i Declaraá∆o_Ènica_de_Exportaá∆o *}
        {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        
    END.
    ELSE DO:
        FOR FIRST bfdue-siscomex FIELDS(cdd-due-ems nom-contato des-email cod-telef num-versao-due)
            WHERE bfdue-siscomex.cdd-due-ems = p-cdd-due-ems NO-LOCK:
            
            /*Valida dados do respons†vel caso algum item tenha a 
            justificativa de valores estat°sticos preenchido*/
            IF CAN-FIND(FIRST bfdue-item
                        WHERE bfdue-item.cdd-due-ems    = bfdue-siscomex.cdd-due-ems
                          AND bfdue-item.num-versao-due = bfdue-siscomex.num-versao-due 
                          AND bfdue-item.des-justif-valores <> "":U) THEN DO:

                /*Valida nome do respons†vel*/
                IF bfdue-siscomex.nom-contato = "":U THEN DO:
                    {utp/ut-liter.i Nome_do_respons†vel *}
                    {method/svc/errors/inserr.i
                                &ErrorNumber="55925"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-due + ' ' + string(bfdue-siscomex.cdd-due-ems)"}

                END.
                /*Valida e-mail do respons†vel*/
                IF bfdue-siscomex.des-email = "":U THEN DO:
                    {utp/ut-liter.i E-mail_do_respons†vel *}
                    {method/svc/errors/inserr.i
                                &ErrorNumber="55925"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-due + ' ' + string(bfdue-siscomex.cdd-due-ems)"}
                END.
                /*Valida telefone do respons†vel*/
                IF bfdue-siscomex.cod-telef = "":U THEN DO:
                    {utp/ut-liter.i Telefone_do_respons†vel *}
                    {method/svc/errors/inserr.i
                                &ErrorNumber="55925"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-due + ' ' + string(bfdue-siscomex.cdd-due-ems)"}
                END.
            END.
            
            /*Valida as notas da DU-E no envio*/
            RUN cxbo/bocx00459.p PERSISTENT SET h-bocx00459.
            RUN piValidaNfsDueEnvio IN h-bocx00459(INPUT bfdue-siscomex.cdd-due-ems,
                                                     OUTPUT TABLE RowErrors APPEND).
            
            DELETE PROCEDURE h-bocx00459.
            ASSIGN h-bocx00459 = ?.
        
            /*Valida os itens da DU-E no envio*/
            RUN cxbo/bocx00460.p PERSISTENT SET h-bocx00460.
            RUN piValidaItensDueEnvio IN h-bocx00460(INPUT bfdue-siscomex.cdd-due-ems,
                                                     OUTPUT TABLE RowErrors APPEND).
            
            DELETE PROCEDURE h-bocx00460.
            ASSIGN h-bocx00460 = ?.
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaAtualizaDUExOF DBOProgram 
PROCEDURE piVerificaAtualizaDUExOF :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se ao menos uma das NFs relacionadas Ö DU-E de exportaá∆o 
               precisa ter a informaá∆o da Data de Averbaá∆o atualizada no Documento em OF
  Parameters:  tt-row-doc-fiscal (temp-table): Rowid dos documentos fiscais vinculados na DU-E (entrada)
               pd-dt-averbacao   (data)      : Data de Averbaá∆o da DU-E (entrada)
               pl-atualiza-of    (l¢gico)    : Identifica se o documento dever† ser 
                                             atualizado automaticamente em OF com base na DU-E (Sa°da)
               
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR tt-row-doc-fiscal.
    DEFINE INPUT  PARAMETER pd-dt-averbacao  AS DATE         NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-atualiza-of   AS LOGICAL      NO-UNDO.

    ASSIGN pl-atualiza-of = NO.

    bloco_of:
    FOR EACH tt-row-doc-fiscal:
        FOR FIRST doc-fiscal
            WHERE ROWID(doc-fiscal) = tt-row-doc-fiscal.r-rowid NO-LOCK:

            FOR FIRST docto-fisc-export 
                WHERE docto-fisc-export.cod-estabel      = doc-fiscal.cod-estabel            
                  AND docto-fisc-export.cod-serie        = doc-fiscal.serie                  
                  AND docto-fisc-export.cod-docto-fisc   = doc-fiscal.nr-doc-fis             
                  AND docto-fisc-export.cdn-emitente     = doc-fiscal.cod-emitente           
                  AND docto-fisc-export.cod-natur-operac = doc-fiscal.nat-operacao NO-LOCK:

                IF docto-fisc-export.dat-averb <> pd-dt-averbacao THEN DO:
                    ASSIGN pl-atualiza-of = YES.
                    LEAVE bloco_of.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintData DBOProgram 
PROCEDURE setConstraintData :
/*------------------------------------------------------------------------------
  Purpose:     Recebe os parÉmetros para abertura da query "Data"
  Parameters:  Entrada: pc-cod-estabel-ini (character): C¢digo inicial do Estabelecimento
               Entrada: pc-cod-estabel-fim (character): C¢digo final do Estabelecimento
               Entrada: pd-dt-criacao-ini (date): Data Inicial de Criaá∆o do registro no sistema
               Entrada: pd-dt-criacao-fim (date): Data Final de Criaá∆o do registro no sistema
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel-ini LIKE due-siscomex.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel-fim LIKE due-siscomex.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pd-dt-criacao-ini  AS   DATE                     NO-UNDO.
    DEFINE INPUT PARAMETER pd-dt-criacao-fim  AS   DATE                     NO-UNDO.
    
    ASSIGN c-cod-estabel-ini = pc-cod-estabel-ini
           c-cod-estabel-fim = pc-cod-estabel-fim
           d-dt-criacao-ini  = pd-dt-criacao-ini 
           d-dt-criacao-fim  = pd-dt-criacao-fim. 
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDue DBOProgram 
PROCEDURE setConstraintDue :
/*------------------------------------------------------------------------------
  Purpose:     Recebe os parÉmetros para abertura da query "DU-E"
  Parameters:  Entrada: pde-cdd-due-ems-ini (decimal): C¢digo inicial do DU-E Interno
               Entrada: pde-cdd-due-ems-fim (decimal): C¢digo final do DU-E Interno
               Entrada: pc-cod-due-siscomex-ini (character): C¢digo inicial da DU-E registrada no Siscomex
               Entrada: pc-cod-due-siscomex-fim (character): C¢digo final da DU-E registrada no Siscomex
               Entrada: pc-cod-ruc-ini (character): C¢digo inicial do RUC no Siscomex
               Entrada: pc-cod-ruc-fim (character): C¢digo final do RUC no Siscomex
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pde-cdd-due-ems-ini     LIKE due-siscomex.cdd-due-ems      NO-UNDO.
    DEFINE INPUT PARAMETER pde-cdd-due-ems-fim     LIKE due-siscomex.cdd-due-ems      NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-due-siscomex-ini LIKE due-siscomex.cod-due-siscomex NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-due-siscomex-fim LIKE due-siscomex.cod-due-siscomex NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-ruc-ini          LIKE due-siscomex.cod-ruc          NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-ruc-fim          LIKE due-siscomex.cod-ruc          NO-UNDO.

    ASSIGN de-cdd-due-ems-ini     = pde-cdd-due-ems-ini    
           de-cdd-due-ems-fim     = pde-cdd-due-ems-fim    
           c-cod-due-siscomex-ini = pc-cod-due-siscomex-ini
           c-cod-due-siscomex-fim = pc-cod-due-siscomex-fim
           c-cod-ruc-ini          = pc-cod-ruc-ini
           c-cod-ruc-fim          = pc-cod-ruc-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDueKey DBOProgram 
PROCEDURE setConstraintDueKey :
/*------------------------------------------------------------------------------
  Purpose:     Recebe os parÉmetros para abertura da query "DueByKey"
  Parameters:  Entrada: pde-cdd-due-ems   (decimal): C¢digo DU-E Interno
               Entrada: pi-num-versao-due (integer): Numero versao DU-E 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pde-cdd-due-ems   LIKE due-siscomex.cdd-due-ems    NO-UNDO.
    DEFINE INPUT PARAMETER pi-num-versao-due LIKE due-siscomex.num-versao-due NO-UNDO.

    ASSIGN de-cdd-due-ems   = pde-cdd-due-ems
           i-num-versao-due = pi-num-versao-due.

    
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
        IF RowObject.cdd-due-ems = 0 THEN DO:
            {utp/ut-liter.i N£mero_Interno_da_DU-E *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="1491"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
        ELSE
            IF CAN-FIND(FIRST bfdue-siscomex 
                        WHERE bfdue-siscomex.cdd-due-ems = RowObject.cdd-due-ems) THEN DO:
                {utp/ut-liter.i Declaraá∆o_Ènica_de_Exportaá∆o *}
                {method/svc/errors/inserr.i
                        &ErrorNumber="8"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="RETURN-VALUE"}
            END.
    END.

    IF l-fn-due-manual THEN DO:
        IF RowObject.cod-due-siscomex <> "":U THEN DO:
            IF CAN-FIND(FIRST bfdue-siscomex 
                        WHERE bfdue-siscomex.cdd-due-ems <> RowObject.cdd-due-ems
                          AND bfdue-siscomex.cod-due-siscomex = RowObject.cod-due-siscomex) THEN DO:
                {utp/ut-liter.i "C¢digo_DU-E_Siscomex" *}
                {method/svc/errors/inserr.i
                        &ErrorNumber="8"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="RETURN-VALUE"}
            END.
            IF RowObject.dat-livre-1 = ? THEN DO: /*Data de Registro da DU-E no Siscomex*/
              {utp/ut-liter.i Data_de_Registro_da_DU-E_no_Siscomex *}
              ASSIGN c-lbl-msg1 = TRIM(RETURN-VALUE).
              {utp/ut-liter.i Quando_informado_o_N£mero_da_DU-E_do_SISCOMEX_Ç_obrigat¢rio_informar_a_Data_do_seu_registro *}
              {method/svc/errors/inserr.i
                     &ErrorNumber="56116"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="c-lbl-msg1 + '~~~~' + RETURN-VALUE "}
          END.
        END.
        IF RowObject.cod-ruc <> "":U THEN DO:
            IF CAN-FIND(FIRST bfdue-siscomex 
                        WHERE bfdue-siscomex.cdd-due-ems <> RowObject.cdd-due-ems
                          AND bfdue-siscomex.cod-ruc = RowObject.cod-ruc) THEN DO:
                {utp/ut-liter.i "C¢digo_RUC" *}
                {method/svc/errors/inserr.i
                        &ErrorNumber="8"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="RETURN-VALUE"}
            END.
        END.
    END.

    IF RowObject.cod-estabel = "":U THEN DO:
        {utp/ut-liter.i Estabelecimento *}
        {method/svc/errors/inserr.i
                &ErrorNumber="265"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="RETURN-VALUE"}
    END.
    ELSE DO:
        IF NOT CAN-FIND(FIRST estabelec
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            {utp/ut-liter.i Estabelecimento *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
        ELSE DO:
            IF NOT CAN-FIND(FIRST param-exp
                            WHERE param-exp.cod-estabel = RowObject.cod-estabel) THEN DO:
                {utp/ut-liter.i Estabelecimento_dos_ParÉmetros_de_Exportaá∆o_(EX0180) *}
                {method/svc/errors/inserr.i
                        &ErrorNumber="2"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="RETURN-VALUE"}
            END.
        END.
    END.
    IF RowObject.cod-cnpj-cpf = "":U THEN DO:
        {utp/ut-liter.i CNPJ/CPF_do_Declarante * }
        {method/svc/errors/inserr.i
                &ErrorNumber="265"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="RETURN-VALUE"}

    END.
    /*ELSE DO:
        ASSIGN l-erro-caracter = NO.
        DO  i-cont = 1 TO LENGTH(RowObject.cod-cnpj-cpf):
            IF  CAN-DO("0,1,2,3,4,5,6,7,8,9",SUBSTRING(RowObject.cod-cnpj-cpf,i-cont,1)) THEN
                ASSIGN c-cnpj = c-cnpj + SUBSTR(RowObject.cod-cnpj-cpf,i-cont,1).
            ELSE DO:
                IF  SUBSTRING(RowObject.cod-cnpj-cpf,i-cont,1) <> ".":U
                AND SUBSTRING(RowObject.cod-cnpj-cpf,i-cont,1) <> "/":U
                AND SUBSTRING(RowObject.cod-cnpj-cpf,i-cont,1) <> "-":U
                AND SUBSTRING(RowObject.cod-cnpj-cpf,i-cont,1) <> " ":U  THEN DO:
                    ASSIGN l-erro-caracter = YES.
                END.
            END.
         END.
         IF l-erro-caracter THEN DO:
            {utp/ut-liter.i CNPJ/CPF_do_Declarante * }
            {method/svc/errors/inserr.i
                    &ErrorNumber="55900"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
         END.
         ELSE DO:
            IF DEC(RowObject.cod-cnpj-cpf) = 0 THEN DO: 
                {utp/ut-liter.i CNPJ/CPF_do_Declarante * }
                {method/svc/errors/inserr.i
                        &ErrorNumber="1491"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="RETURN-VALUE"}
            END.
         END.
         ASSIGN l-erro-caracter = NO.
    END.*/
    
    IF NOT CAN-FIND(FIRST moeda
                    WHERE moeda.mo-codigo = RowObject.cdn-moed-siscomex) THEN DO:
        {utp/ut-liter.i Moeda * }
        {method/svc/errors/inserr.i
                &ErrorNumber="2"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="RETURN-VALUE"}

    END.

    IF RowObject.cod-moed = "":U THEN DO:
        {utp/ut-liter.i Verifique_se_foi_informada_moeda_de_negociaá∆o(ISO_4217)_para_a_moeda_correspondente_no_Cadastro_de_Moedas_(CD0914)}
        ASSIGN c-lbl-help = TRIM(RETURN-VALUE).
        {utp/ut-liter.i Moeda_de_Negociaá∆o * }
        {method/svc/errors/inserr.i
                &ErrorNumber="5561"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="RETURN-VALUE + '~~~~' + c-lbl-help"}
    END.

    /*Local de Despacho*/
    IF RowObject.cdn-urf-despch = 0 THEN DO:
        {utp/ut-liter.i Unidade_da_RFB_para_Despacho *} 
        {method/svc/errors/inserr.i
                &ErrorNumber="265"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="RETURN-VALUE"}

    END.
    ELSE DO:
        IF NOT CAN-FIND(FIRST unid-rf 
                        WHERE unid-rf.cdn-unid-recta-feder = RowObject.cdn-urf-despch) THEN DO:
            {utp/ut-liter.i Unidade_da_RFB_para_Despacho *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
    END.
    
    IF RowObject.cdn-recinto-aduana-despch = 281 THEN DO: /*Em Recinto Aduaneiro*/
        IF NOT CAN-FIND(FIRST recinto-aduana
                        WHERE recinto-aduana.cdn-aduana = RowObject.cdn-aduana-despch) THEN DO: 
            {utp/ut-liter.i Recinto_Aduaneiro_para_Despacho *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}

        END.
    END.
    ELSE DO: /*22: Fora do Recinto duaneiro, Ç obrigat¢rio informar o CNPJ do respons†vel, demais campos s∆o opcionais*/
        IF RowObject.cod-cnpj-respons = "":U THEN DO:
            {utp/ut-liter.i CNPJ_do_Respons†vel * }
            {method/svc/errors/inserr.i
                    &ErrorNumber="265"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
       /* ELSE DO:
             ASSIGN l-erro-caracter = NO.
             DO  i-cont = 1 TO LENGTH(RowObject.cod-cnpj-respons):
                IF  CAN-DO("0,1,2,3,4,5,6,7,8,9",SUBSTRING(RowObject.cod-cnpj-respons,i-cont,1)) THEN
                    ASSIGN c-cnpj = c-cnpj + SUBSTR(RowObject.cod-cnpj-respons,i-cont,1).
                ELSE DO:
                    IF  SUBSTRING(RowObject.cod-cnpj-respons,i-cont,1) <> ".":U
                    AND SUBSTRING(RowObject.cod-cnpj-respons,i-cont,1) <> "/":U
                    AND SUBSTRING(RowObject.cod-cnpj-respons,i-cont,1) <> "-":U
                    AND SUBSTRING(RowObject.cod-cnpj-respons,i-cont,1) <> " ":U  THEN DO:
                        ASSIGN l-erro-caracter = YES.
                    END.
                END.
             END.
             IF l-erro-caracter THEN DO:
                 {utp/ut-liter.i CNPJ/CPF_do_Respons†vel * }    
                 {method/svc/errors/inserr.i
                         &ErrorNumber="55900"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="RETURN-VALUE"}
             END.
             ELSE DO:
                IF DEC(RowObject.cod-cnpj-respons) = 0 THEN DO: 
                    {utp/ut-liter.i CNPJ/CPF_do_Respons†vel * }
                    {method/svc/errors/inserr.i
                            &ErrorNumber="1491"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="RETURN-VALUE"}
                END.
             END.
             ASSIGN l-erro-caracter = NO.
        END.*/
    END.

    /*Local de Embarque*/
    IF RowObject.cdn-urf-embarq = 0 THEN DO:
        {utp/ut-liter.i Unidade_da_RFB_para_Embarque *} 
        {method/svc/errors/inserr.i
                &ErrorNumber="265"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="RETURN-VALUE"}

    END.
    ELSE DO:
        IF NOT CAN-FIND(FIRST unid-rf 
                        WHERE unid-rf.cdn-unid-recta-feder = RowObject.cdn-urf-embarq) THEN DO:
            {utp/ut-liter.i Unidade_da_RFB_para_Embarque *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        
        END.
    END.

    IF RowObject.cdn-recinto-aduana-embarq = 281 THEN DO: /*Em Recinto Aduaneiro*/
        IF NOT CAN-FIND(FIRST recinto-aduana
                        WHERE recinto-aduana.cdn-aduana = RowObject.cdn-aduana-embarq) THEN DO: 
            {utp/ut-liter.i Recinto_Aduaneiro_para_Despacho *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
    END.

    /*Somente deve validar os enquadramentos caso o usu†rio tenha acessado o programa EX7000C*/
    IF l-ex7000c THEN
        RUN piValidaEnquadramentos IN THIS-PROCEDURE (INPUT rowObject.cod-enquad-1,
                                                      INPUT rowObject.cod-enquad-2,
                                                      INPUT rowObject.cod-enquad-3,
                                                      INPUT rowObject.cod-enquad-4).

    IF pType = "DELETE":U THEN DO:
        IF RowObject.idi-sit-siscomex <> 1 THEN DO: /*Somente ser† poss°vel eliminar DU-E que ainda n∆o foi integrada */
            {utp/ut-liter.i Eliminaá∆o * }
            {method/svc/errors/inserr.i
                    &ErrorNumber="17148"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.

        IF CAN-FIND(FIRST due-nf
                    WHERE due-nf.cdd-due-ems = RowObject.cdd-due-ems) THEN DO:
            {utp/ut-liter.i Declaraá∆o_Ènica_de_Exportaá∆o * }
            ASSIGN c-lbl-msg1 = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Nota_fiscal_da_DU-E * }
            {method/svc/errors/inserr.i
                    &ErrorNumber="5"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-lbl-msg1 + '~~~~' + trim(return-value)"}

        END.
    END.

    IF RowObject.des-email <> "":U THEN DO:
        IF INDEX(RowObject.des-email,"@":U) = 0 
        OR INDEX(RowObject.des-email,".":U) = 0 THEN DO:
            {utp/ut-liter.i E-mail_do_Respons†vel * R}
            {method/svc/errors/inserr.i
                &ErrorNumber="54"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="trim(return-value)"}
        END.    
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

