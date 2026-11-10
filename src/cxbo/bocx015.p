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
{include/i-prgvrs.i BOCX015 2.00.00.008 } /*** "010008" 11/12/2023 10:13:22 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX015
&GLOBAL-DEFINE DBOVersion 2.00.00.006
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName decl-pais
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
{cxbo/bocx015.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{cdp/cdcfgmat.i} /* Definiá∆o de prÇ-processadores */

DEFINE VARIABLE i-de-codigo      AS INTEGER                 NO-UNDO.
DEFINE VARIABLE i-de-codigo-fin  AS INTEGER                 NO-UNDO.
DEFINE VARIABLE c-idioma-inicial AS CHAR                    NO-UNDO.
DEFINE VARIABLE i-pais-inicial   AS INTEGER                 NO-UNDO.
DEFINE VARIABLE i-de-codigo-ini  LIKE decl-pais.de-codigo   NO-UNDO.
DEFINE VARIABLE i-de-codigo-fim  LIKE decl-pais.de-codigo   NO-UNDO.
DEFINE VARIABLE i-cod-pais-ini   LIKE decl-pais.cod-pais    NO-UNDO.
DEFINE VARIABLE i-cod-pais-fim   LIKE decl-pais.cod-pais    NO-UNDO.
DEFINE VARIABLE c-cod-idioma-ini LIKE decl-pais.cod-idioma  NO-UNDO.
DEFINE VARIABLE c-cod-idioma-fim LIKE decl-pais.cod-idioma  NO-UNDO.

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
         HEIGHT             = 2.42
         WIDTH              = 33.
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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-idioma":U THEN ASSIGN pFieldValue = RowObject.cod-idioma.
        WHEN "texto":U THEN ASSIGN pFieldValue = RowObject.texto.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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
        WHEN "cod-pais":U THEN ASSIGN pFieldValue = RowObject.cod-pais.
        WHEN "de-codigo":U THEN ASSIGN pFieldValue = RowObject.de-codigo.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice pk-decl-pais
  Parameters:  
               retorna valor do campo de-codigo
               retorna valor do campo cod-pais
               retorna valor do campo cod-idioma
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pde-codigo LIKE decl-pais.de-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-pais LIKE decl-pais.cod-pais NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-idioma LIKE decl-pais.cod-idioma NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pde-codigo = RowObject.de-codigo
           pcod-pais = RowObject.cod-pais
           pcod-idioma = RowObject.cod-idioma.

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
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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
  Purpose:     Reposiciona registro com base no °ndice pk-decl-pais
  Parameters:  
               recebe valor do campo de-codigo
               recebe valor do campo cod-pais
               recebe valor do campo cod-idioma
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pde-codigo LIKE decl-pais.de-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-pais LIKE decl-pais.cod-pais NO-UNDO.
    DEFINE INPUT PARAMETER pcod-idioma LIKE decl-pais.cod-idioma NO-UNDO.

    FIND FIRST bfdecl-pais WHERE 
        bfdecl-pais.de-codigo = pde-codigo AND 
        bfdecl-pais.cod-pais = pcod-pais AND 
        bfdecl-pais.cod-idioma = pcod-idioma NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdecl-pais THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdecl-pais)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodIdiPais DBOProgram 
PROCEDURE openQueryCodIdiPais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 OPEN QUERY qr{&TableName} FOR EACH {&TableName}
     WHERE  {&TableName}.de-codigo  >= i-de-codigo
     AND    {&TableName}.cod-idioma >= c-idioma-inicial
     AND    {&TableName}.cod-pais   >= i-pais-inicial NO-LOCK.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDecl DBOProgram 
PROCEDURE openQueryDecl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 OPEN QUERY qr{&TableName} FOR EACH {&TableName} NO-LOCK
     WHERE  {&TableName}.de-codigo  >= i-de-codigo-ini
     AND    {&TableName}.de-codigo  <= i-de-codigo-fim
     AND    {&TableName}.cod-pais   >= i-cod-pais-ini
     AND    {&TableName}.cod-pais   <= i-cod-pais-fim
     AND    {&TableName}.cod-idioma >= c-cod-idioma-ini
     AND    {&TableName}.cod-idioma <= c-cod-idioma-fim
     BY     {&TableName}.de-codigo.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDeCod DBOProgram 
PROCEDURE openQueryDeCod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 OPEN QUERY qr{&TableName} FOR EACH {&TableName}
     WHERE  {&TableName}.de-codigo >= i-de-codigo-ini
     AND    {&TableName}.de-codigo <= i-de-codigo-fin NO-LOCK.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryIdioma DBOProgram 
PROCEDURE openQueryIdioma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 OPEN QUERY qr{&TableName} FOR EACH {&TableName} NO-LOCK
     WHERE  {&TableName}.de-codigo  >= i-de-codigo-ini
     AND    {&TableName}.de-codigo  <= i-de-codigo-fim
     AND    {&TableName}.cod-pais   >= i-cod-pais-ini
     AND    {&TableName}.cod-pais   <= i-cod-pais-fim
     AND    {&TableName}.cod-idioma >= c-cod-idioma-ini
     AND    {&TableName}.cod-idioma <= c-cod-idioma-fim
     BY     {&TableName}.cod-idioma.

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
    OPEN QUERY qr{&TableName} FOR EACH {&TableName} NO-LOCK.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPais DBOProgram 
PROCEDURE openQueryPais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 OPEN QUERY qr{&TableName} FOR EACH {&TableName} NO-LOCK
     WHERE  {&TableName}.de-codigo  >= i-de-codigo-ini
     AND    {&TableName}.de-codigo  <= i-de-codigo-fim
     AND    {&TableName}.cod-pais   >= i-cod-pais-ini
     AND    {&TableName}.cod-pais   <= i-cod-pais-fim
     AND    {&TableName}.cod-idioma >= c-cod-idioma-ini
     AND    {&TableName}.cod-idioma <= c-cod-idioma-fim
     BY     {&TableName}.cod-pais.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint1 DBOProgram 
PROCEDURE setConstraint1 :
/*------------------------------------------------------------------------------
  Purpose:     ParÉmetros para filtro das Querys
  Parameters:  p-de-codigo      = C¢digo da declaraá∆o
               p-idioma-inicial = Idioma
               p-pais-inicial   = Pa°s Inicial
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-de-codigo      AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-idioma-inicial AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-pais-inicial   AS CHAR NO-UNDO.
    
    ASSIGN i-de-codigo      = INTEGER(p-de-codigo)
           c-idioma-inicial = p-idioma-inicial
           i-pais-inicial   = INTEGER(p-pais-inicial).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:     ParÉmetros para filtro das Querys
  Parameters:  p-de-codigo-ini = C¢digo da declaraá∆o inicial do filtro
               p-de-codigo-fin = C¢digo da declaraá∆o final do filtro
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-de-codigo-ini  AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-de-codigo-fin  AS CHAR NO-UNDO.
    
    ASSIGN i-de-codigo-ini = INTEGER(p-de-codigo-ini)
           i-de-codigo-fin = INTEGER(p-de-codigo-fin).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint3 DBOProgram 
PROCEDURE setConstraint3 :
/*------------------------------------------------------------------------------
  Purpose:     ParÉmetros para filtro das Querys
  Parameters:  p-de-codigo-ini  = C¢digo da declaraá∆o inicial
               p-de-codigo-fim  = C¢digo da declaraá∆o final
               p-cod-pais-ini   = C¢digo do pa°s inicial
               p-cod-pais-fim   = C¢digo do pa°s final
               p-cod-idioma-ini = C¢digo do idioma final
               p-cod-idioma-fim = C¢digo do idioma inicial
  Notes:       
------------------------------------------------------------------------------*/
    /*
    ** utilizada pelo zoom wz02cx015
    */
    DEFINE INPUT PARAMETER p-de-codigo-ini  LIKE decl-pais.de-codigo  NO-UNDO.
    DEFINE INPUT PARAMETER p-de-codigo-fim  LIKE decl-pais.de-codigo  NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-pais-ini   LIKE decl-pais.cod-pais   NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-pais-fim   LIKE decl-pais.cod-pais   NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-idioma-ini LIKE decl-pais.cod-idioma NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-idioma-fim LIKE decl-pais.cod-idioma NO-UNDO.

    assign i-de-codigo-ini  = p-de-codigo-ini
           i-de-codigo-fim  = p-de-codigo-fim
           i-cod-pais-ini   = p-cod-pais-ini
           i-cod-pais-fim   = p-cod-pais-fim
           c-cod-idioma-ini = p-cod-idioma-ini
           c-cod-idioma-fim = p-cod-idioma-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCodigo DBOProgram 
PROCEDURE validateCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Valida o cpodig od o pa°s
  Parameters:  c-cod-pais = c¢digo do pa°s
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER c-cod-pais AS CHAR NO-UNDO.
    EMPTY TEMP-TABLE RowErrors.
    DEFINE VARIABLE i-teste AS INTEGER NO-UNDO.
    
    ASSIGN i-teste = INT(c-cod-pais) NO-ERROR.

    IF  ERROR-STATUS:ERROR THEN DO:
       {utp/ut-field.i mgcex decl-pais cod-pais 1}
       {method/svc/errors/inserr.i &ErrorNumber="16963"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters=" return-value "}
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
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF pType = "CREATE":U THEN DO:        
       if rowObject.cod-idioma = ? then do:            
            {utp/ut-field.i mgcex {&TABLE-NAME} cod-idioma 1}
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters=" return-value "}            
        end.
        else 
        &if defined(bf-mat-comex) &then                                    
            if not can-find(idioma where idioma.id-codigo = rowObject.cod-idioma) then do:
        &else
            if not can-find(idioma where idioma.cod_idioma = rowObject.cod-idioma) then do:
        &endif
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters=" return-value "}
        end.
        
        if rowObject.cod-pais = ? then do:            
            {utp/ut-field.i mgcex {&TABLE-NAME} cod-pais 1}
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters=" return-value "}            
        end.
        if not can-find(pais where pais.cod-pais = rowObject.cod-pais) then do:
              {utp/ut-table.i mguni pais 1}
              {method/svc/errors/inserr.i &ErrorNumber="2"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters=" return-value "}
        end.

        if rowObject.de-codigo = ? then do:            
            {utp/ut-field.i mgcex {&TABLE-NAME} de-codigo 1}
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters=" return-value "}
        end.
        else if not can-find(decl-padrao where decl-padrao.de-codigo = rowObject.de-codigo) then do:
               {utp/ut-table.i mgcex decl-padrao 1}
               {method/svc/errors/inserr.i &ErrorNumber="2"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters=" return-value "}
         end.

        IF NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:    
            find decl-pais where
                decl-pais.de-codigo  = rowObject.de-codigo  and
                decl-pais.cod-idioma = rowObject.cod-idioma and
                decl-pais.cod-pais   = rowObject.cod-pais 
                no-lock no-error.
            if avail decl-pais then do:                            
                {utp/ut-table.i mgcex decl-pais 1}
                {method/svc/errors/inserr.i &ErrorNumber="8"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters=" return-value "}
            end.
        end.

        if rowObject.cod-idioma = ? then do:
            {method/svc/errors/inserr.i &ErrorNumber="190"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters=" "}
        end.
         
        if rowObject.cod-pais = ? then do:
            {method/svc/errors/inserr.i &ErrorNumber="190"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters=" "}
        end.
     
        if rowObject.de-codigo = ? then do:
            {method/svc/errors/inserr.i &ErrorNumber="190"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters=" "}
        end.
          
        if rowObject.texto = "" then do:
            {utp/ut-field.i mgcex {&TABLE-NAME} texto 1}
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters=" return-value "}
        end. 
    
    END.
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

