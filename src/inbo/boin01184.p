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
&GLOBAL-DEFINE DBOName BOIN01184
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName classif-atrib-cond-atrib
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
{inbo/boin01184.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE VARIABLE c-cod-class-fisc LIKE classif-atrib-cond-atrib.cod-class-fisc NO-UNDO.
DEFINE VARIABLE c-cod-atrib      LIKE classif-atrib-cond-atrib.cod-atrib      NO-UNDO.
DEFINE VARIABLE c-cod-domin      LIKE classif-atrib-cond-atrib.cod-domin      NO-UNDO.
DEFINE VARIABLE i-ind-modal      LIKE classif-atrib-cond-atrib.ind-modal      NO-UNDO.
DEFINE VARIABLE i-num-condicao   LIKE classif-atrib-cond-atrib.num-condicao   NO-UNDO.

DEFINE VARIABLE cod-class-fisc     LIKE classif-atrib-cond-atrib.cod-class-fisc NO-UNDO.
DEFINE VARIABLE cod-atrib          LIKE classif-atrib-cond-atrib.cod-atrib      NO-UNDO.
DEFINE VARIABLE cod-atrib-cond-ini LIKE classif-atrib-cond-atrib.cod-atrib-cond NO-UNDO.
DEFINE VARIABLE cod-atrib-cond-fim LIKE classif-atrib-cond-atrib.cod-atrib-cond NO-UNDO.
DEFINE VARIABLE cod-domin-ini      LIKE classif-atrib-cond-atrib.cod-domin      NO-UNDO.
DEFINE VARIABLE cod-domin-fim      LIKE classif-atrib-cond-atrib.cod-domin      NO-UNDO.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-atrib":U THEN ASSIGN pFieldValue = RowObject.cod-atrib.
        WHEN "cod-atrib-cond":U THEN ASSIGN pFieldValue = RowObject.cod-atrib-cond.
        WHEN "cod-class-fisc":U THEN ASSIGN pFieldValue = RowObject.cod-class-fisc.
        WHEN "cod-domin":U THEN ASSIGN pFieldValue = RowObject.cod-domin.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-valor":U THEN ASSIGN pFieldValue = RowObject.cod-valor.
        WHEN "nome-apres-atrib":U THEN ASSIGN pFieldValue = RowObject.nome-apres-atrib.
        WHEN "nome-atrib":U THEN ASSIGN pFieldValue = RowObject.nome-atrib.
        WHEN "orgaos":U THEN ASSIGN pFieldValue = RowObject.orgaos.
        WHEN "orient-preench":U THEN ASSIGN pFieldValue = RowObject.orient-preench.
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
        WHEN "dat-fim-vigencia":U THEN ASSIGN pFieldValue = RowObject.dat-fim-vigencia.
        WHEN "dat-ini-vigencia":U THEN ASSIGN pFieldValue = RowObject.dat-ini-vigencia.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
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
        WHEN "val-valor":U THEN ASSIGN pFieldValue = RowObject.val-valor.
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
        WHEN "idi-forma-preench":U THEN ASSIGN pFieldValue = RowObject.idi-forma-preench.
        WHEN "ind-modal":U THEN ASSIGN pFieldValue = RowObject.ind-modal.
        WHEN "num-condicao":U THEN ASSIGN pFieldValue = RowObject.num-condicao.
        WHEN "num-decimal":U THEN ASSIGN pFieldValue = RowObject.num-decimal.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-valor":U THEN ASSIGN pFieldValue = RowObject.num-valor.
        WHEN "val-tamanho-max":U THEN ASSIGN pFieldValue = RowObject.val-tamanho-max.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice clAtCondAtr
  Parameters:  
               retorna valor do campo cod-class-fisc
               retorna valor do campo cod-atrib
               retorna valor do campo cod-domin
               retorna valor do campo ind-modal
               retorna valor do campo num-condicao
               retorna valor do campo cod-atrib-cond
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-class-fisc LIKE classif-atrib-cond-atrib.cod-class-fisc NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-atrib LIKE classif-atrib-cond-atrib.cod-atrib NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-domin LIKE classif-atrib-cond-atrib.cod-domin NO-UNDO.
    DEFINE OUTPUT PARAMETER pind-modal LIKE classif-atrib-cond-atrib.ind-modal NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-condicao LIKE classif-atrib-cond-atrib.num-condicao NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-atrib-cond LIKE classif-atrib-cond-atrib.cod-atrib-cond NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-class-fisc = RowObject.cod-class-fisc
           pcod-atrib = RowObject.cod-atrib
           pcod-domin = RowObject.cod-domin
           pind-modal = RowObject.ind-modal
           pnum-condicao = RowObject.num-condicao
           pcod-atrib-cond = RowObject.cod-atrib-cond.

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
        WHEN "log-condicionado":U THEN ASSIGN pFieldValue = RowObject.log-condicionado.
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-obrigatorio":U THEN ASSIGN pFieldValue = RowObject.log-obrigatorio.
        WHEN "log-valor":U THEN ASSIGN pFieldValue = RowObject.log-valor.
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
  Purpose:     Reposiciona registro com base no °ndice clAtCondAtr
  Parameters:  
               recebe valor do campo cod-class-fisc
               recebe valor do campo cod-atrib
               recebe valor do campo cod-domin
               recebe valor do campo ind-modal
               recebe valor do campo num-condicao
               recebe valor do campo cod-atrib-cond
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-class-fisc LIKE classif-atrib-cond-atrib.cod-class-fisc NO-UNDO.
    DEFINE INPUT PARAMETER pcod-atrib LIKE classif-atrib-cond-atrib.cod-atrib NO-UNDO.
    DEFINE INPUT PARAMETER pcod-domin LIKE classif-atrib-cond-atrib.cod-domin NO-UNDO.
    DEFINE INPUT PARAMETER pind-modal LIKE classif-atrib-cond-atrib.ind-modal NO-UNDO.
    DEFINE INPUT PARAMETER pnum-condicao LIKE classif-atrib-cond-atrib.num-condicao NO-UNDO.
    DEFINE INPUT PARAMETER pcod-atrib-cond LIKE classif-atrib-cond-atrib.cod-atrib-cond NO-UNDO.

    FIND FIRST bfclassif-atrib-cond-atrib WHERE 
        bfclassif-atrib-cond-atrib.cod-class-fisc = pcod-class-fisc AND 
        bfclassif-atrib-cond-atrib.cod-atrib = pcod-atrib AND 
        bfclassif-atrib-cond-atrib.cod-domin = pcod-domin AND 
        bfclassif-atrib-cond-atrib.ind-modal = pind-modal AND 
        bfclassif-atrib-cond-atrib.num-condicao = pnum-condicao AND 
        bfclassif-atrib-cond-atrib.cod-atrib-cond = pcod-atrib-cond NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfclassif-atrib-cond-atrib THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfclassif-atrib-cond-atrib)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAtribCond DBOProgram 
PROCEDURE openQueryAtribCond :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cod-class-fisc = c-cod-class-fisc
                                 AND {&TABLENAME}.cod-atrib      = c-cod-atrib
                                 AND {&TABLENAME}.cod-domin      = c-cod-domin
                                 AND {&TABLENAME}.ind-modal      = i-ind-modal
                                 AND {&TABLENAME}.num-condicao   = i-num-condicao
                            NO-LOCK INDEXED-REPOSITION.

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
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintAtribCond DBOProgram 
PROCEDURE setConstraintAtribCond :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cod-class-fisc LIKE classif-atrib-cond-atrib.cod-class-fisc NO-UNDO.
    DEF INPUT PARAM p-cod-atrib      LIKE classif-atrib-cond-atrib.cod-atrib      NO-UNDO.
    DEF INPUT PARAM p-cod-domin      LIKE classif-atrib-cond-atrib.cod-domin      NO-UNDO.
    DEF INPUT PARAM p-ind-modal      LIKE classif-atrib-cond-atrib.ind-modal      NO-UNDO.
    DEF INPUT PARAM p-num-condicao   LIKE classif-atrib-cond-atrib.num-condicao   NO-UNDO.
    
    ASSIGN c-cod-class-fisc = p-cod-class-fisc
           c-cod-atrib      = p-cod-atrib
           c-cod-domin      = p-cod-domin
           i-ind-modal      = p-ind-modal
           i-num-condicao   = p-num-condicao.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom DBOProgram 
PROCEDURE setConstraintZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-class-fisc     LIKE classif-atrib-cond-atrib.cod-class-fisc   NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-atrib          LIKE classif-atrib-cond-atrib.cod-atrib        NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-atrib-cond-ini LIKE classif-atrib-cond-atrib.cod-atrib-cond   NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-atrib-cond-fim LIKE classif-atrib-cond-atrib.cod-atrib-cond   NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-domin-ini      LIKE classif-atrib.cod-domin                   NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-domin-fim      LIKE classif-atrib.cod-domin                   NO-UNDO.

    ASSIGN cod-class-fisc     = pc-cod-class-fisc
           cod-atrib          = pc-cod-atrib
           cod-atrib-cond-ini = pc-cod-atrib-cond-ini
           cod-atrib-cond-fim = pc-cod-atrib-cond-fim
           cod-domin-ini      = pc-cod-domin-ini
           cod-domin-fim      = pc-cod-domin-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom DBOProgram 
PROCEDURE openQueryZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName}
                               WHERE {&TableName}.cod-class-fisc  = cod-class-fisc
                                 AND {&TableName}.cod-atrib       = cod-atrib
                                 AND {&TableName}.cod-atrib-cond >= cod-atrib-cond-ini
                                 AND {&TableName}.cod-atrib-cond <= cod-atrib-cond-fim
                                 AND {&TableName}.cod-domin      >= cod-domin-ini
                                 AND {&TableName}.cod-domin      <= cod-domin-fim NO-LOCK.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom2 DBOProgram 
PROCEDURE setConstraintZoom2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-class-fisc     LIKE classif-atrib-cond-atrib.cod-class-fisc   NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-atrib          LIKE classif-atrib-cond-atrib.cod-atrib        NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-atrib-cond-ini LIKE classif-atrib-cond-atrib.cod-atrib-cond   NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-atrib-cond-fim LIKE classif-atrib-cond-atrib.cod-atrib-cond   NO-UNDO.

    ASSIGN cod-class-fisc     = pc-cod-class-fisc
           cod-atrib          = pc-cod-atrib
           cod-atrib-cond-ini = pc-cod-atrib-cond-ini
           cod-atrib-cond-fim = pc-cod-atrib-cond-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom2 DBOProgram 
PROCEDURE openQueryZoom2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName}
                               WHERE {&TableName}.cod-class-fisc  = cod-class-fisc
                                 AND {&TableName}.cod-atrib       = cod-atrib
                                 AND {&TableName}.cod-atrib-cond >= cod-atrib-cond-ini
                                 AND {&TableName}.cod-atrib-cond <= cod-atrib-cond-fim NO-LOCK 
                                  BY {&TableName}.cod-class-fisc
                                  BY {&TableName}.cod-atrib     
                                  BY {&TableName}.cod-atrib-cond.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyCustom DBOProgram  
PROCEDURE goToKeyCustom :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice clAtCondAtr
  Parameters:  
               recebe valor do campo cod-class-fisc
               recebe valor do campo cod-atrib
               recebe valor do campo cod-domin
               recebe valor do campo ind-modal
               recebe valor do campo cod-atrib-cond
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-class-fisc LIKE classif-atrib-cond-atrib.cod-class-fisc NO-UNDO.
    DEFINE INPUT PARAMETER pcod-atrib LIKE classif-atrib-cond-atrib.cod-atrib NO-UNDO.
    DEFINE INPUT PARAMETER pcod-domin LIKE classif-atrib-cond-atrib.cod-domin NO-UNDO.
    DEFINE INPUT PARAMETER pind-modal LIKE classif-atrib-cond-atrib.ind-modal NO-UNDO.
    DEFINE INPUT PARAMETER pcod-atrib-cond LIKE classif-atrib-cond-atrib.cod-atrib-cond NO-UNDO.

    FIND FIRST bfclassif-atrib-cond-atrib WHERE 
        bfclassif-atrib-cond-atrib.cod-class-fisc = pcod-class-fisc AND 
        bfclassif-atrib-cond-atrib.cod-atrib = pcod-atrib AND 
        bfclassif-atrib-cond-atrib.cod-domin = pcod-domin AND 
        bfclassif-atrib-cond-atrib.ind-modal = pind-modal AND 
        bfclassif-atrib-cond-atrib.cod-atrib-cond = pcod-atrib-cond NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfclassif-atrib-cond-atrib THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfclassif-atrib-cond-atrib)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

