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
&GLOBAL-DEFINE DBOName BOIN010
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName rat-componente
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
{inbo/boin010.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
/*{method/dboqry.i}*/

DEFINE QUERY {&QueryName} FOR {&TableName} SCROLLING.

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


DEFINE VARIABLE c-serie-docto  LIKE rat-saldo-terc.serie-docto  NO-UNDO.
DEFINE VARIABLE c-nro-docto    LIKE rat-saldo-terc.nro-docto    NO-UNDO.
DEFINE VARIABLE i-cod-emitente LIKE rat-saldo-terc.cod-emitente NO-UNDO.
DEFINE VARIABLE c-nat-operacao LIKE rat-saldo-terc.nat-operacao NO-UNDO.
DEFINE VARIABLE c-it-codigo    LIKE rat-saldo-terc.it-codigo    NO-UNDO. 
DEFINE VARIABLE c-cod-refer    LIKE rat-saldo-terc.cod-refer    NO-UNDO.
DEFINE VARIABLE i-sequencia    LIKE rat-saldo-terc.sequencia    NO-UNDO.
DEFINE VARIABLE c-lote         LIKE rat-saldo-terc.lote         NO-UNDO.

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
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "des-checksum":U THEN ASSIGN pFieldValue = RowObject.des-checksum.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "nat-comp":U THEN ASSIGN pFieldValue = RowObject.nat-comp.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-comp":U THEN ASSIGN pFieldValue = RowObject.nro-comp.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-comp":U THEN ASSIGN pFieldValue = RowObject.serie-comp.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "componente":U THEN ASSIGN pFieldValue = RowObject.componente.
        WHEN "emite-comp":U THEN ASSIGN pFieldValue = RowObject.emite-comp.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "seq-comp":U THEN ASSIGN pFieldValue = RowObject.seq-comp.
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
  Purpose:     Retorna valores dos campos do °ndice rat_componente_id
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo it-codigo
               retorna valor do campo cod-refer
               retorna valor do campo sequencia
               retorna valor do campo lote
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE rat-componente.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE rat-componente.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE rat-componente.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE rat-componente.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE rat-componente.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE rat-componente.cod-refer NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE rat-componente.sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER plote LIKE rat-componente.lote NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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
           plote = RowObject.lote.

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
        WHEN "baixa-ce":U THEN ASSIGN pFieldValue = RowObject.baixa-ce.
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
  Purpose:     Reposiciona registro com base no °ndice rat_componente_id
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo it-codigo
               recebe valor do campo cod-refer
               recebe valor do campo sequencia
               recebe valor do campo lote
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE rat-componente.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE rat-componente.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE rat-componente.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE rat-componente.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE rat-componente.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE rat-componente.cod-refer NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE rat-componente.sequencia NO-UNDO.
    DEFINE INPUT PARAMETER plote LIKE rat-componente.lote NO-UNDO.

    FIND FIRST bfrat-componente WHERE 
        bfrat-componente.serie-docto = pserie-docto AND 
        bfrat-componente.nro-docto = pnro-docto AND 
        bfrat-componente.cod-emitente = pcod-emitente AND 
        bfrat-componente.nat-operacao = pnat-operacao AND 
        bfrat-componente.it-codigo = pit-codigo AND 
        bfrat-componente.cod-refer = pcod-refer AND 
        bfrat-componente.sequencia = psequencia AND 
        bfrat-componente.lote = plote NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrat-componente THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrat-componente)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToSaldoTerc DBOProgram 
PROCEDURE linkTorat-saldo-terc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
   
   DEF  VAR c-cod-depos LIKE rat-saldo-terc.cod-depos NO-UNDO.
   def var c-cod-localiz LIKE rat-saldo-terc.cod-localiz NO-UNDO.
  
   RUN getKey IN pHandle(OUTPUT c-serie-docto,
                         OUTPUT c-nro-docto,
                         OUTPUT i-cod-emitente,
                         OUTPUT c-nat-operacao,
                         OUTPUT c-it-codigo,
                         OUTPUT c-cod-refer,
                         OUTPUT i-sequencia
                        /* OUTPUT c-cod-depos, 
                           OUTPUT c-lote,
                           OUTPUT c-cod-localiz */).
                         
                         
       /*                  
    DEFINE OUTPUT PARAMETER pserie-docto LIKE saldo-terc.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE saldo-terc.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE saldo-terc.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE saldo-terc.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE saldo-terc.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE saldo-terc.cod-refer NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE saldo-terc.sequencia NO-UNDO.   */                      

 

   RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain:
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryBySaldoTerc DBOProgram 
PROCEDURE openQueryByrat-saldo-terc:
/*------------------------------------------------------------------------------
  Purpose:Abre query para retornar todas movimentaÁıes da rat-componente com
          com base na chave proveniente da rat-saldo-terc             
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName}
        FOR EACH  {&TableName} 
               WHERE {&tableName}.cod-emitente         = i-cod-emitente
               AND   (  (    {&tableName}.serie-docto  = c-serie-docto
                         AND {&tableName}.nro-docto    = c-nro-docto
                         AND {&tableName}.nat-operacao = c-nat-operacao
                         AND {&tableName}.sequencia    = i-sequencia    )
                      OR (   {&tableName}.serie-comp   = c-serie-docto
                         AND {&tableName}.nro-comp     = c-nro-docto
                         AND {&tableName}.nat-comp     = c-nat-operacao
                         AND {&tableName}.seq-comp     = i-sequencia    ) )
               AND   {&tableName}.it-codigo            = c-it-codigo
               AND   {&tableName}.cod-refer            = c-cod-refer              
                     NO-LOCK
                     BY {&tableName}.dt-retorno
                     BY {&tableName}.nro-docto
                     BY {&tableName}.serie-docto
                     BY {&tableName}.cod-emitente
                     BY {&tableName}.nat-operacao
                     BY {&tablename}.it-codigo
                     BY {&tableName}.cod-refer
                     BY {&tableName}.sequencia
                     INDEXED-REPOSITION.           


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setContraintBySaldoTerc DBOProgram 
PROCEDURE setConstraintByrat-saldo-terc :
/*------------------------------------------------------------------------------
  Purpose:     Seta restriªío para pesquisa da rat-comp por saldo-trec.
  Parameters:  p-c-serie-docto -> S≤rie do documento;
               p-c-nro-docto -> Número do documento;
               p-i-cod-emitente -> CΩdigo do emitente;
               p-c-nat-operacao -> Natureza de operaªío do documento;
               p-c-it-codigo -> CΩdigo do item;
               p-c-cod-refer -> Referencia;
               p-i-sequencia -> sequencia,
  Notes:       
------------------------------------------------------------------------------*/
    
DEFINE INPUT PARAMETER p-c-serie-docto  LIKE rat-componente.serie-docto  NO-UNDO.
DEFINE INPUT PARAMETER p-c-nro-docto    LIKE rat-componente.nro-docto    NO-UNDO.
DEFINE INPUT PARAMETER p-i-cod-emitente LIKE rat-componente.cod-emitente NO-UNDO.
DEFINE INPUT PARAMETER p-c-nat-operacao LIKE rat-componente.nat-operacao NO-UNDO.
DEFINE INPUT PARAMETER p-c-it-codigo    LIKE rat-componente.it-codigo    NO-UNDO. 
DEFINE INPUT PARAMETER p-c-cod-refer    LIKE rat-componente.cod-refer    NO-UNDO.
DEFINE INPUT PARAMETER p-i-sequencia    LIKE rat-componente.sequencia    NO-UNDO.
DEFINE INPUT PARAMETER p-lote           LIKE rat-componente.lote         NO-UNDO.


ASSIGN c-serie-docto  = p-c-serie-docto  
       c-nro-docto    = p-c-nro-docto   
       i-cod-emitente = p-i-cod-emitente 
       c-nat-operacao = p-c-nat-operacao 
       c-it-codigo    = p-c-it-codigo    
       c-cod-refer    = p-c-cod-refer    
       i-sequencia    = p-i-sequencia
       c-lote         = p-lote.

    
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

