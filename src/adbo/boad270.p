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

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOAD270
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ano-fiscal
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
{adbo/boad270.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "fim-periodo[1]":U THEN ASSIGN pFieldValue = RowObject.fim-periodo[1].
        WHEN "fim-periodo[2]":U THEN ASSIGN pFieldValue = RowObject.fim-periodo[2].
        WHEN "fim-periodo[3]":U THEN ASSIGN pFieldValue = RowObject.fim-periodo[3].
        WHEN "fim-periodo[4]":U THEN ASSIGN pFieldValue = RowObject.fim-periodo[4].
        WHEN "fim-periodo[5]":U THEN ASSIGN pFieldValue = RowObject.fim-periodo[5].
        WHEN "fim-periodo[6]":U THEN ASSIGN pFieldValue = RowObject.fim-periodo[6].
        WHEN "fim-periodo[7]":U THEN ASSIGN pFieldValue = RowObject.fim-periodo[7].
        WHEN "fim-periodo[8]":U THEN ASSIGN pFieldValue = RowObject.fim-periodo[8].
        WHEN "fim-periodo[9]":U THEN ASSIGN pFieldValue = RowObject.fim-periodo[9].
        WHEN "fim-periodo[10]":U THEN ASSIGN pFieldValue = RowObject.fim-periodo[10].
        WHEN "fim-periodo[11]":U THEN ASSIGN pFieldValue = RowObject.fim-periodo[11].
        WHEN "fim-periodo[12]":U THEN ASSIGN pFieldValue = RowObject.fim-periodo[12].
        WHEN "fim-periodo[13]":U THEN ASSIGN pFieldValue = RowObject.fim-periodo[13].
        WHEN "ini-periodo[1]":U THEN ASSIGN pFieldValue = RowObject.ini-periodo[1].
        WHEN "ini-periodo[2]":U THEN ASSIGN pFieldValue = RowObject.ini-periodo[2].
        WHEN "ini-periodo[3]":U THEN ASSIGN pFieldValue = RowObject.ini-periodo[3].
        WHEN "ini-periodo[4]":U THEN ASSIGN pFieldValue = RowObject.ini-periodo[4].
        WHEN "ini-periodo[5]":U THEN ASSIGN pFieldValue = RowObject.ini-periodo[5].
        WHEN "ini-periodo[6]":U THEN ASSIGN pFieldValue = RowObject.ini-periodo[6].
        WHEN "ini-periodo[7]":U THEN ASSIGN pFieldValue = RowObject.ini-periodo[7].
        WHEN "ini-periodo[8]":U THEN ASSIGN pFieldValue = RowObject.ini-periodo[8].
        WHEN "ini-periodo[9]":U THEN ASSIGN pFieldValue = RowObject.ini-periodo[9].
        WHEN "ini-periodo[10]":U THEN ASSIGN pFieldValue = RowObject.ini-periodo[10].
        WHEN "ini-periodo[11]":U THEN ASSIGN pFieldValue = RowObject.ini-periodo[11].
        WHEN "ini-periodo[12]":U THEN ASSIGN pFieldValue = RowObject.ini-periodo[12].
        WHEN "ini-periodo[13]":U THEN ASSIGN pFieldValue = RowObject.ini-periodo[13].
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "ano-fiscal":U THEN ASSIGN pFieldValue = RowObject.ano-fiscal.
        WHEN "estado-per[1]":U THEN ASSIGN pFieldValue = RowObject.estado-per[1].
        WHEN "estado-per[2]":U THEN ASSIGN pFieldValue = RowObject.estado-per[2].
        WHEN "estado-per[3]":U THEN ASSIGN pFieldValue = RowObject.estado-per[3].
        WHEN "estado-per[4]":U THEN ASSIGN pFieldValue = RowObject.estado-per[4].
        WHEN "estado-per[5]":U THEN ASSIGN pFieldValue = RowObject.estado-per[5].
        WHEN "estado-per[6]":U THEN ASSIGN pFieldValue = RowObject.estado-per[6].
        WHEN "estado-per[7]":U THEN ASSIGN pFieldValue = RowObject.estado-per[7].
        WHEN "estado-per[8]":U THEN ASSIGN pFieldValue = RowObject.estado-per[8].
        WHEN "estado-per[9]":U THEN ASSIGN pFieldValue = RowObject.estado-per[9].
        WHEN "estado-per[10]":U THEN ASSIGN pFieldValue = RowObject.estado-per[10].
        WHEN "estado-per[11]":U THEN ASSIGN pFieldValue = RowObject.estado-per[11].
        WHEN "estado-per[12]":U THEN ASSIGN pFieldValue = RowObject.estado-per[12].
        WHEN "estado-per[13]":U THEN ASSIGN pFieldValue = RowObject.estado-per[13].
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "num-periodos":U THEN ASSIGN pFieldValue = RowObject.num-periodos.
        WHEN "prox-pag-diario[1]":U THEN ASSIGN pFieldValue = RowObject.prox-pag-diario[1].
        WHEN "prox-pag-diario[2]":U THEN ASSIGN pFieldValue = RowObject.prox-pag-diario[2].
        WHEN "prox-pag-diario[3]":U THEN ASSIGN pFieldValue = RowObject.prox-pag-diario[3].
        WHEN "prox-pag-diario[4]":U THEN ASSIGN pFieldValue = RowObject.prox-pag-diario[4].
        WHEN "prox-pag-diario[5]":U THEN ASSIGN pFieldValue = RowObject.prox-pag-diario[5].
        WHEN "prox-pag-diario[6]":U THEN ASSIGN pFieldValue = RowObject.prox-pag-diario[6].
        WHEN "prox-pag-diario[7]":U THEN ASSIGN pFieldValue = RowObject.prox-pag-diario[7].
        WHEN "prox-pag-diario[8]":U THEN ASSIGN pFieldValue = RowObject.prox-pag-diario[8].
        WHEN "prox-pag-diario[9]":U THEN ASSIGN pFieldValue = RowObject.prox-pag-diario[9].
        WHEN "prox-pag-diario[10]":U THEN ASSIGN pFieldValue = RowObject.prox-pag-diario[10].
        WHEN "prox-pag-diario[11]":U THEN ASSIGN pFieldValue = RowObject.prox-pag-diario[11].
        WHEN "prox-pag-diario[12]":U THEN ASSIGN pFieldValue = RowObject.prox-pag-diario[12].
        WHEN "prox-pag-diario[13]":U THEN ASSIGN pFieldValue = RowObject.prox-pag-diario[13].
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice ch-empresa-ano
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo ano-fiscal
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE ano-fiscal.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pano-fiscal LIKE ano-fiscal.ano-fiscal NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pano-fiscal = RowObject.ano-fiscal.

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
        WHEN "encer-semestral":U THEN ASSIGN pFieldValue = RowObject.encer-semestral.
        WHEN "encerrado":U THEN ASSIGN pFieldValue = RowObject.encerrado.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "movto-eliminado":U THEN ASSIGN pFieldValue = RowObject.movto-eliminado.
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
  Purpose:     Reposiciona registro com base no ¡ndice ch-empresa-ano
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo ano-fiscal
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE ano-fiscal.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pano-fiscal LIKE ano-fiscal.ano-fiscal NO-UNDO.

    FIND FIRST bfano-fiscal WHERE 
        bfano-fiscal.ep-codigo = pep-codigo AND 
        bfano-fiscal.ano-fiscal = pano-fiscal NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfano-fiscal THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfano-fiscal)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaUltimoAno DBOProgram 
PROCEDURE carregaUltimoAno :
/*:T------------------------------------------------------------------------------
  Purpose:     Trazer último ano cadastrado para os anos fiscais
  Parameters:  recebe a empresa e retorna o último ano fiscal
------------------------------------------------------------------------------*/
    
    DEFINE INPUT  PARAMETER p-ep-codigo  LIKE RowObject.ep-codigo  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-ano-fiscal LIKE RowObject.ano-fiscal NO-UNDO.
    
    FOR LAST {&TableName} FIELDS(ano-fiscal) NO-LOCK
        WHERE {&TableName}.ep-codigo = p-ep-codigo:
    
        ASSIGN p-ano-fiscal = {&TableName}.ano-fiscal.

    END.

    IF NOT AVAIL {&TableName} THEN DO:

        {method/svc/errors/inserr.i 
                &ErrorNumber="679"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"}

    END.
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram
PROCEDURE openQueryMain:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.     

END PROCEDURE.
    
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
