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
{include/i-prgvrs.i BOIN757 2.00.00.003 } /*** "010003" 29/11/2023 09:07:16  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin757 MUT}
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
&GLOBAL-DEFINE DBOName BOIN757
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName impto-remito-fatur
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
{inbo/boin757.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-estabel-ini  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-estabel-fim  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-natureza-ini AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-natureza-fim AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-pais-ini     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-pais-fim     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-estado-ini   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-estado-fim   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cidade-ini   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cidade-fim   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-familia-ini  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-familia-fim  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-item-ini     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-item-fim     AS CHARACTER NO-UNDO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH impto-remito-fatur-det EXCLUSIVE-LOCK 
      WHERE impto-remito-fatur-det.cod-estabel  = RowObject.cod-estabel AND
            impto-remito-fatur-det.nat-operacao = RowObject.nat-operacao AND
            impto-remito-fatur-det.nome-pais    = RowObject.nome-pais   AND
            impto-remito-fatur-det.cod-estado   = RowObject.cod-estado  AND
            impto-remito-fatur-det.nom-cidade   = RowObject.nom-cidade  AND
            impto-remito-fatur-det.fm-codigo    = RowObject.fm-codigo   AND
            impto-remito-fatur-det.it-codigo    = RowObject.it-codigo:
      DELETE impto-remito-fatur-det.
  END.
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
        WHEN "cod-estado":U THEN ASSIGN pFieldValue = RowObject.cod-estado.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "fm-codigo":U THEN ASSIGN pFieldValue = RowObject.fm-codigo.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nom-cidade":U THEN ASSIGN pFieldValue = RowObject.nom-cidade.
        WHEN "nome-pais":U THEN ASSIGN pFieldValue = RowObject.nome-pais.
        WHEN "cod-usuar-atualiz":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-atualiz.
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
        WHEN "dat-ult-atualiz":U THEN ASSIGN pFieldValue = RowObject.dat-ult-atualiz.
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
  Purpose:     Retorna valores dos campos do °ndice imptrmtf-id
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo nat-operacao
               retorna valor do campo nome-pais
               retorna valor do campo cod-estado
               retorna valor do campo nom-cidade
               retorna valor do campo fm-codigo
               retorna valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE impto-remito-fatur.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE impto-remito-fatur.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pnome-pais LIKE impto-remito-fatur.nome-pais NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estado LIKE impto-remito-fatur.cod-estado NO-UNDO.
    DEFINE OUTPUT PARAMETER pnom-cidade LIKE impto-remito-fatur.nom-cidade NO-UNDO.
    DEFINE OUTPUT PARAMETER pfm-codigo LIKE impto-remito-fatur.fm-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE impto-remito-fatur.it-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pnat-operacao = RowObject.nat-operacao
           pnome-pais = RowObject.nome-pais
           pcod-estado = RowObject.cod-estado
           pnom-cidade = RowObject.nom-cidade
           pfm-codigo = RowObject.fm-codigo
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
  Purpose:     Reposiciona registro com base no °ndice imptrmtf-id
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo nat-operacao
               recebe valor do campo nome-pais
               recebe valor do campo cod-estado
               recebe valor do campo nom-cidade
               recebe valor do campo fm-codigo
               recebe valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE impto-remito-fatur.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE impto-remito-fatur.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pnome-pais LIKE impto-remito-fatur.nome-pais NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estado LIKE impto-remito-fatur.cod-estado NO-UNDO.
    DEFINE INPUT PARAMETER pnom-cidade LIKE impto-remito-fatur.nom-cidade NO-UNDO.
    DEFINE INPUT PARAMETER pfm-codigo LIKE impto-remito-fatur.fm-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE impto-remito-fatur.it-codigo NO-UNDO.

    FIND FIRST bfimpto-remito-fatur WHERE 
        bfimpto-remito-fatur.cod-estabel = pcod-estabel AND 
        bfimpto-remito-fatur.nat-operacao = pnat-operacao AND 
        bfimpto-remito-fatur.nome-pais = pnome-pais AND 
        bfimpto-remito-fatur.cod-estado = pcod-estado AND 
        bfimpto-remito-fatur.nom-cidade = pnom-cidade AND 
        bfimpto-remito-fatur.fm-codigo = pfm-codigo AND 
        bfimpto-remito-fatur.it-codigo = pit-codigo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfimpto-remito-fatur THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfimpto-remito-fatur)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryEstabel DBOProgram 
PROCEDURE OpenQueryEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
        {&TableName}.cod-estabel >= c-estabel-ini AND
        {&TableName}.cod-estabel <= c-estabel-fim BY {&TableName}.cod-estabel 
        INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryFamilia DBOProgram 
PROCEDURE OpenQueryFamilia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
        {&TableName}.fm-codigo >= c-familia-ini AND
        {&TableName}.fm-codigo <= c-familia-fim BY {&TableName}.fm-codigo
        INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryItem DBOProgram 
PROCEDURE OpenQueryItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
        {&tablename}.it-codigo >= c-item-ini AND
        {&tablename}.it-codigo <= c-item-fim BY {&tablename}.it-codigo
        INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryMain DBOProgram 
PROCEDURE OpenQueryMain :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryNatureza DBOProgram 
PROCEDURE OpenQueryNatureza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
        {&TableName}.nat-operacao >= c-natureza-ini AND
        {&TableName}.nat-operacao <= c-natureza-fim BY {&TableName}.nat-operacao
        INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryRegiao DBOProgram 
PROCEDURE OpenQueryRegiao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
        {&TableName}.nome-pais  >= c-pais-ini   AND
        {&TableName}.nome-pais  <= c-pais-fim   AND
        {&TableName}.cod-estado >= c-estado-ini AND
        {&TableName}.cod-estado <= c-estado-fim AND
        {&TableName}.nom-cidade >= c-cidade-ini AND
        {&TableName}.nom-cidade <= c-cidade-fim BY {&TableName}.nome-pais
        INDEXED-REPOSITION.

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
    DEFINE INPUT PARAMETER p-cod-estabel-ini LIKE impto-remito-fatur.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-fim LIKE impto-remito-fatur.cod-estabel NO-UNDO.

    ASSIGN c-estabel-ini = p-cod-estabel-ini
           c-estabel-fim = p-cod-estabel-fim.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFamilia DBOProgram 
PROCEDURE setConstraintFamilia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-familia-ini LIKE impto-remito-fatur.fm-codigo NO-UNDO.
    DEFINE INPUT PARAMETER p-familia-fim LIKE impto-remito-fatur.fm-codigo NO-UNDO.

    ASSIGN c-familia-ini = p-familia-ini
           c-familia-fim = p-familia-fim.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItem DBOProgram 
PROCEDURE setConstraintItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-item-ini LIKE impto-remito-fatur.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER p-item-fim LIKE impto-remito-fatur.it-codigo NO-UNDO.

    ASSIGN c-item-ini = p-item-ini
           c-item-fim = p-item-fim.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNatureza DBOProgram 
PROCEDURE setConstraintNatureza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-natureza-ini LIKE impto-remito-fatur.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER p-natureza-fim LIKE impto-remito-fatur.nat-operacao NO-UNDO.

    ASSIGN c-natureza-ini = p-natureza-ini
           c-natureza-fim = p-natureza-fim.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRegiao DBOProgram 
PROCEDURE setConstraintRegiao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-pais-ini   LIKE impto-remito-fatur.nome-pais  NO-UNDO.
    DEFINE INPUT PARAMETER p-pais-fim   LIKE impto-remito-fatur.nome-pais  NO-UNDO.
    DEFINE INPUT PARAMETER p-estado-ini LIKE impto-remito-fatur.cod-estado NO-UNDO.
    DEFINE INPUT PARAMETER p-estado-fim LIKE impto-remito-fatur.cod-estado NO-UNDO.
    DEFINE INPUT PARAMETER p-cidade-ini LIKE impto-remito-fatur.nom-cidade NO-UNDO.
    DEFINE INPUT PARAMETER p-cidade-fim LIKE impto-remito-fatur.nom-cidade NO-UNDO.

    ASSIGN c-pais-ini   = p-pais-ini 
           c-pais-fim   = p-pais-fim
           c-estado-ini = p-estado-ini
           c-estado-fim = p-estado-fim
           c-cidade-ini = p-cidade-ini
           c-cidade-fim = p-cidade-fim.

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
    
    IF pType = "Create":U OR pType = "Update":U THEN DO:

        IF RowObject.cod-estabel <> "?" AND RowObject.cod-estabel <> ? THEN
           IF NOT CAN-FIND(FIRST estabelec  WHERE estabelec.cod-estabel  = RowObject.cod-estabel) THEN DO:
                /* Estabelecimento n∆o existe */
                /* Inicio -- Projeto Internacional */
                {utp/ut-table.i mgadm estabelec 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS":U
                    &ErrorSubType="ERROR":U
                    &ErrorParameters=TRIM(RETURN-VALUE)}
           END.       
        
        IF RowObject.nat-operacao <> "?" AND RowObject.nat-operacao <> ? THEN
           IF NOT CAN-FIND(FIRST natur-oper WHERE natur-oper.nat-operacao  = RowObject.nat-operacao) THEN DO:
                /* Nat Operaá∆o n∆o existe */
                /* Inicio -- Projeto Internacional */
                {utp/ut-table.i mgind natur-oper 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS":U
                    &ErrorSubType="ERROR":U
                    &ErrorParameters=TRIM(RETURN-VALUE)}
           END.   

        IF RowObject.nome-pais <> "?" AND RowObject.nome-pais <> ? THEN
           IF NOT CAN-FIND(FIRST pais WHERE pais.nome-pais  = RowObject.nome-pais) THEN DO:
                /* Pa°s n∆o existe */
                /* Inicio -- Projeto Internacional */
                {utp/ut-table.i mguni pais 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS":U
                    &ErrorSubType="ERROR":U
                    &ErrorParameters=TRIM(RETURN-VALUE)}
           END.   

        IF RowObject.cod-estado <> "?" AND RowObject.cod-estado <> ? THEN
           IF NOT CAN-FIND(FIRST unid-feder  WHERE
                             unid-feder.pais   = RowObject.nome-pais AND 
                             unid-feder.estado = RowObject.cod-estado) THEN DO:
                /* Estado n∆o existe */
                /* Inicio -- Projeto Internacional */
                {utp/ut-table.i mguni unid-feder 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS":U
                    &ErrorSubType="ERROR":U
                    &ErrorParameters=TRIM(RETURN-VALUE)}
           END.   

        FOR FIRST param-global WHERE param-global.dec-1 = 1 NO-LOCK:
            IF RowObject.nom-cidade <> "?" AND RowObject.nom-cidade <> ? THEN
               IF NOT CAN-FIND(FIRST cidade  WHERE
                                 cidade.cidade = RowObject.nom-cidade AND 
                                 cidade.estado = RowObject.cod-estado AND
                                 cidade.pais   = RowObject.nome-pais) THEN DO:
                    /* Cidade n∆o existe */
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-table.i mgdis cidade 1} /* Busca o label da tabela */
                    {method/svc/errors/inserr.i
                        &ErrorNumber="2"
                        &ErrorType="EMS":U
                        &ErrorSubType="ERROR":U
                        &ErrorParameters=TRIM(RETURN-VALUE)}
               END.  
        END.


        IF RowObject.fm-codigo <> "?" AND RowObject.fm-codigo <> ? THEN
           IF NOT CAN-FIND(FIRST familia WHERE familia.fm-codigo = RowObject.fm-codigo) THEN DO:
                /* Fam°lia n∆o existe */
                /* Inicio -- Projeto Internacional */
                {utp/ut-table.i mgind familia 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS":U
                    &ErrorSubType="ERROR":U
                    &ErrorParameters=TRIM(RETURN-VALUE)}
           END.  

        IF RowObject.it-codigo <> "?" AND RowObject.it-codigo <> ? THEN
           IF NOT CAN-FIND(FIRST item WHERE item.it-codigo = RowObject.it-codigo) THEN DO:
                /* Item n∆o existe */
                /* Inicio -- Projeto Internacional */
                {utp/ut-table.i mgind item 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS":U
                    &ErrorSubType="ERROR":U
                    &ErrorParameters=TRIM(RETURN-VALUE)}
           END.  

    END.
    IF pType = "Create":U THEN DO:
           IF CAN-FIND(FIRST bf{&TableName}  WHERE
                             bf{&TableName}.cod-estabel  = RowObject.cod-estabel  AND
                             bf{&TableName}.nat-operacao = RowObject.nat-operacao AND
                             bf{&TableName}.nome-pais    = RowObject.nome-pais    AND
                             bf{&TableName}.cod-estado   = RowObject.cod-estado   AND
                             bf{&TableName}.nom-cidade   = RowObject.nom-cidade   AND
                             bf{&TableName}.fm-codigo    = RowObject.fm-codigo    AND
                             bf{&tablename}.it-codigo    = RowObject.it-codigo) THEN DO:
                /* J† existe ocorrància do registro */
                /* Inicio -- Projeto Internacional */
                {utp/ut-table.i mgind item 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i
                    &ErrorNumber="1"
                    &ErrorType="EMS":U
                    &ErrorSubType="ERROR":U
                    &ErrorParameters=TRIM(RETURN-VALUE)}
         END.                                                                                                    
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
