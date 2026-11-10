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
{include/i-prgvrs.i BOIN00916 2.00.00.009 } /*** "010009" 27/10/2023 17:03:40  ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN00916
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName exam-sub-proces-cq
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
{inbo/boin00916.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bf-copy{&TableName} FOR {&TableName}.
{inbo/boin00916.i tt-exam-sub-proces-cq}

DEFINE VARIABLE c-ep-codigo       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-estabel     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-area-produc AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-proces      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-sub-proces  AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-copy-proces NO-UNDO
        FIELD c-ep-codigo-ori LIKE sub-proces-cq.ep-codigo 
        FIELD c-ep-codigo-des LIKE sub-proces-cq.ep-codigo
        FIELD c-cod-estab-ori LIKE sub-proces-cq.cod-estabel
        FIELD c-cod-estab-des LIKE sub-proces-cq.cod-estabel
        FIELD c-cod-area-ori  LIKE sub-proces-cq.cod-area-produc
        FIELD c-cod-area-des  LIKE sub-proces-cq.cod-area-produc
        FIELD c-cod-proc-ori  LIKE sub-proces-cq.cod-proces
        FIELD c-cod-proc-des  LIKE sub-proces-cq.cod-proces
        FIELD c-cod-sub-proc  LIKE sub-proces-cq.cod-sub-proces.

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
         HEIGHT             = 11.54
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyExames DBOProgram 
PROCEDURE copyExames :
/*------------------------------------------------------------------------------
  Purpose:     Copias os exames do processo de origem para a destino
  Parameters:  tt-copy-proces - temp-table com os subprocessos
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-copy-proces.

    FOR EACH tt-copy-proces NO-LOCK:
        FOR EACH bf-copy{&TableName} FIELDS (ep-codigo cod-estabel cod-area-produc cod-proces cod-sub-proces cod-exame) NO-LOCK
            WHERE bf-copy{&TableName}.ep-codigo       = tt-copy-proces.c-ep-codigo-ori
            AND   bf-copy{&TableName}.cod-estabel     = tt-copy-proces.c-cod-estab-ori
            AND   bf-copy{&TableName}.cod-area-produc = tt-copy-proces.c-cod-area-ori
            AND   bf-copy{&TableName}.cod-proces      = tt-copy-proces.c-cod-proc-ori
            AND   bf-copy{&TableName}.cod-sub-proces  = tt-copy-proces.c-cod-sub-proc:

            EMPTY TEMP-TABLE tt-exam-sub-proces-cq.
            CREATE tt-exam-sub-proces-cq.
            ASSIGN tt-exam-sub-proces-cq.ep-codigo       = tt-copy-proces.c-ep-codigo-des
                   tt-exam-sub-proces-cq.cod-estabel     = tt-copy-proces.c-cod-estab-des
                   tt-exam-sub-proces-cq.cod-area-produc = tt-copy-proces.c-cod-area-des
                   tt-exam-sub-proces-cq.cod-proces      = tt-copy-proces.c-cod-proc-des 
                   tt-exam-sub-proces-cq.cod-sub-proces  = tt-copy-proces.c-cod-sub-proc
                   tt-exam-sub-proces-cq.cod-exame       = bf-copy{&TableName}.cod-exame.

            RUN emptyRowErrors IN THIS-PROCEDURE.
            RUN setRecord IN THIS-PROCEDURE (INPUT TABLE tt-exam-sub-proces-cq). 
            RUN createRecord IN THIS-PROCEDURE.
        END.
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
        WHEN "cod-area-produc":U THEN ASSIGN pFieldValue = RowObject.cod-area-produc.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-proces":U THEN ASSIGN pFieldValue = RowObject.cod-proces.
        WHEN "cod-sub-proces":U THEN ASSIGN pFieldValue = RowObject.cod-sub-proces.
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
        WHEN "cod-exame":U THEN ASSIGN pFieldValue = RowObject.cod-exame.
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
  Purpose:     Retorna valores dos campos do °ndice exmsubproc_id
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo cod-area-produc
               retorna valor do campo cod-proces
               retorna valor do campo cod-sub-proces
               retorna valor do campo cod-exame
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE exam-sub-proces-cq.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE exam-sub-proces-cq.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-area-produc LIKE exam-sub-proces-cq.cod-area-produc NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-proces LIKE exam-sub-proces-cq.cod-proces NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-sub-proces LIKE exam-sub-proces-cq.cod-sub-proces NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-exame LIKE exam-sub-proces-cq.cod-exame NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-estabel = RowObject.cod-estabel
           pcod-area-produc = RowObject.cod-area-produc
           pcod-proces = RowObject.cod-proces
           pcod-sub-proces = RowObject.cod-sub-proces
           pcod-exame = RowObject.cod-exame.

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
  Purpose:     Reposiciona registro com base no °ndice exmsubproc_id
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-area-produc
               recebe valor do campo cod-proces
               recebe valor do campo cod-sub-proces
               recebe valor do campo cod-exame
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE exam-sub-proces-cq.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE exam-sub-proces-cq.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-area-produc LIKE exam-sub-proces-cq.cod-area-produc NO-UNDO.
    DEFINE INPUT PARAMETER pcod-proces LIKE exam-sub-proces-cq.cod-proces NO-UNDO.
    DEFINE INPUT PARAMETER pcod-sub-proces LIKE exam-sub-proces-cq.cod-sub-proces NO-UNDO.
    DEFINE INPUT PARAMETER pcod-exame LIKE exam-sub-proces-cq.cod-exame NO-UNDO.

    FIND FIRST bfexam-sub-proces-cq WHERE 
        bfexam-sub-proces-cq.ep-codigo = pep-codigo AND 
        bfexam-sub-proces-cq.cod-estabel = pcod-estabel AND 
        bfexam-sub-proces-cq.cod-area-produc = pcod-area-produc AND 
        bfexam-sub-proces-cq.cod-proces = pcod-proces AND 
        bfexam-sub-proces-cq.cod-sub-proces = pcod-sub-proces AND 
        bfexam-sub-proces-cq.cod-exame = pcod-exame NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfexam-sub-proces-cq THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfexam-sub-proces-cq)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkTosub-proces-cq DBOProgram 
PROCEDURE linkTosub-proces-cq :
/*------------------------------------------------------------------------------
  Purpose:     Faz o link entre a tabela pai e o browser
  Parameters:  pHandle - Handle que est† sendo utilizado
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.

    DEFINE VARIABLE c-codigo      LIKE sub-proces-cq.ep-codigo       NO-UNDO.             
    DEFINE VARIABLE c-estabel     LIKE sub-proces-cq.cod-estabel     NO-UNDO.         
    DEFINE VARIABLE c-area-produc LIKE sub-proces-cq.cod-area-produc NO-UNDO. 
    DEFINE VARIABLE c-proces      LIKE sub-proces-cq.cod-proces      NO-UNDO.
    DEFINE VARIABLE c-sub-proces  LIKE sub-proces-cq.cod-sub-proces  NO-UNDO.

    RUN getKey IN pHandle (OUTPUT c-codigo,
                           OUTPUT c-estabel,
                           OUTPUT c-area-produc,
                           OUTPUT c-proces,
                           OUTPUT c-sub-proces).

    RUN setConstraintBySubProcesso IN THIS-PROCEDURE (INPUT c-codigo,
                                                      INPUT c-estabel,
                                                      INPUT c-area-produc,
                                                      INPUT c-proces,
                                                      INPUT c-sub-proces).    
        


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryBySubProcesso DBOProgram 
PROCEDURE openQueryBySubProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName}
        WHERE {&TableName}.ep-codigo        = c-ep-codigo
        AND   {&TableName}.cod-estabel      = c-cod-estabel
        AND   {&TableName}.cod-area-produc  = c-cod-area-produc
        AND   {&TableName}.cod-proces       = c-cod-proces
        AND   {&TableName}.cod-sub-proces   = c-cod-sub-proces NO-LOCK.

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
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintBySubProcesso DBOProgram 
PROCEDURE setConstraintBySubProcesso :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para receber os parÉmetros para filtrar a query de um
               subprocesso
  Parameters:  p-ep-codigo       - Empresa
               p-cod-estabel     - Estabelecimento
               p-cod-area-produc - µrea de Produá∆o
               p-cod-proces      - Processo
               p-cod-sub-proces  - SubProcesso
  
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE INPUT PARAMETER p-ep-codigo       LIKE exam-sub-proces-cq.ep-codigo       NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel     LIKE exam-sub-proces-cq.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-area-produc LIKE exam-sub-proces-cq.cod-area-produc NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-proces      LIKE exam-sub-proces-cq.cod-proces      NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-sub-proces  LIKE exam-sub-proces-cq.cod-sub-proces  NO-UNDO.

    ASSIGN c-ep-codigo       = p-ep-codigo      
           c-cod-estabel     = p-cod-estabel    
           c-cod-area-produc = p-cod-area-produc
           c-cod-proces      = p-cod-proces     
           c-cod-sub-proces  = p-cod-sub-proces.

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

