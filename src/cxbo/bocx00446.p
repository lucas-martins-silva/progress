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
{include/i-prgvrs.i BOCX00446 2.00.00.009 } /*** "010009" 07/11/2025 11:15:48 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00446
&GLOBAL-DEFINE DBOVersion 2.0
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName adiant-despes-embarq
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
{cxbo/bocx00446.i RowObject}
{cxbo/bocx00446.i tt-adiant-despes-embarq}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


DEFINE VARIABLE c-cod-estabel       LIKE adiant-despes-embarq.cod-estab        NO-UNDO. 
DEFINE VARIABLE d-cdd-adiant        LIKE adiant-despes-embarq.cdd-adiant       NO-UNDO.
DEFINE VARIABLE i-num-di-ems        LIKE adiant-despes-embarq.num-di-ems       NO-UNDO.
DEFINE VARIABLE d-cdd-siscomex-dts  LIKE adiant-despes-embarq.cdd-siscomex-dts NO-UNDO.
DEFINE VARIABLE d-cod-embarq        LIKE adiant-despes-embarq.cod-embarq       NO-UNDO.
DEFINE VARIABLE c-liter              AS   CHARACTER                            NO-UNDO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-DI-adiant DBOProgram 
PROCEDURE pi-atualiza-DI-adiant :
/*------------------------------------------------------------------------------
  Purpose: Atualiza o numero da DI no embarque do adiantamento das despesas    
  Parameters:  Recebe o c¢digo do estabelecimento
               Recebe o c¢digo do embarque
               Recebe o numero da DI EMS
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel       LIKE adiant-despes-embarq.cod-estabel       NO-UNDO.
    DEFINE INPUT PARAMETER pcod-embarq        LIKE adiant-despes-embarq.cod-embarq        NO-UNDO.  
    DEFINE INPUT PARAMETER pnum-di-ems        LIKE adiant-despes-embarq.num-di-ems        NO-UNDO.
        
    FIND FIRST adiant-despes-embarq EXCLUSIVE-LOCK
        WHERE  adiant-despes-embarq.cod-estabel = pcod-estabel
        AND    adiant-despes-embarq.cod-embarq  = pcod-embarq NO-ERROR.
    IF AVAIL adiant-despes-embarq THEN DO:
       ASSIGN adiant-despes-embarq.num-di-ems = pnum-di-ems.
    END.
    RELEASE adiant-despes-embarq.

RETURN "OK":U.
END PROCEDURE.

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
        WHEN "cod-embarq":U  THEN ASSIGN pFieldValue = RowObject.cod-embarq.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.        
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
        WHEN "cdd-adiant":U THEN ASSIGN pFieldValue = RowObject.cdd-adiant.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "cdd-siscomex-dts":U THEN ASSIGN pFieldValue = RowObject.cdd-siscomex-dts.
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
        WHEN "num-di-ems":U  THEN ASSIGN pFieldValue = RowObject.num-di-ems.
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
  Purpose:     Retorna valores dos campos do °ndice adntdspa_id2
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo cdd-adiant 
               retorna valor do campo num-di-ems 
               retorna valor do campo cdd-siscomex-dts
               retorna valor do campo cod-embarq 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel      LIKE adiant-despes-embarq.cod-estabel       NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdd-adiant       LIKE adiant-despes-embarq.cdd-adiant        NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-di-ems       LIKE adiant-despes-embarq.num-di-ems        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdd-siscomex-dts LIKE adiant-despes-embarq.cdd-siscomex-dts  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-embarq       LIKE adiant-despes-embarq.cod-embarq        NO-UNDO.
    
    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel      = RowObject.cod-estabel
           pcdd-adiant       = RowObject.cdd-adiant
           pnum-di-ems       = RowObject.num-di-ems
           pcdd-siscomex-dts = RowObject.cdd-siscomex-dts
           pcod-embarq       = RowObject.cod-embarq.

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
  Purpose:     Reposiciona registro com base no °ndice adntdspa_id2
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cdd-adiant
               recebe valor do campo num-di-ems
               recebe valor do campo cdd-siscomex-dts
               recebe valor do campo cod-embarq
               
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel      LIKE adiant-despes-embarq.cod-estabel      NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-adiant       LIKE adiant-despes-embarq.cdd-adiant       NO-UNDO.
    DEFINE INPUT PARAMETER pnum-di-ems       LIKE adiant-despes-embarq.num-di-ems       NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-siscomex-dts LIKE adiant-despes-embarq.cdd-siscomex-dts NO-UNDO.
    DEFINE INPUT PARAMETER pcod-embarq       LIKE adiant-despes-embarq.cod-embarq       NO-UNDO.
    
    FIND FIRST bfadiant-despes-embarq 
         WHERE bfadiant-despes-embarq.cod-estabel       = pcod-estabel  
         AND   bfadiant-despes-embarq.cdd-adiant        = pcdd-adiant 
         AND   bfadiant-despes-embarq.num-di-ems        = pnum-di-ems 
         AND   bfadiant-despes-embarq.cdd-siscomex-dts  = pcdd-siscomex-dts
         AND   bfadiant-despes-embarq.cod-embarq        = pcod-embarq   NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfadiant-despes-embarq THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfadiant-despes-embarq)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyEmbarque DBOProgram  
PROCEDURE goToKeyEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no estabelecimento, adiantamento e embarque
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cdd-adiant
               recebe valor do campo cod-embarq
               
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE adiant-despes-embarq.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-adiant  LIKE adiant-despes-embarq.cdd-adiant  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-embarq  LIKE adiant-despes-embarq.cod-embarq  NO-UNDO.
    
    FIND FIRST bfadiant-despes-embarq 
         WHERE bfadiant-despes-embarq.cod-estabel = pcod-estabel  
         AND   bfadiant-despes-embarq.cdd-adiant  = pcdd-adiant 
         AND   bfadiant-despes-embarq.cod-embarq  = pcod-embarq   NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfadiant-despes-embarq THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfadiant-despes-embarq)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToAdiantDespes DBOProgram 
PROCEDURE linkToAdiantDespes :
/*------------------------------------------------------------------------------
  Purpose:     Procedure utilizada para relacionar o registro pai x registro filho
               na abertura da query e navegaá∆o.
  Parameters:  Entrada: Handle da DBO Pai
  Notes:       Utilizada no programa principal IM0720.w
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM ph-adiant-despes AS HANDLE NO-UNDO.

    RUN getKey IN ph-adiant-despes (OUTPUT c-cod-estabel,
                                    OUTPUT d-cdd-adiant ).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAdiantamento DBOProgram 
PROCEDURE openQueryAdiantamento :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query de acordo com estabelecimento e adiantamento
  Parameters:  <none>
  Notes:       Utilizada no programa principal IM0720.w
------------------------------------------------------------------------------*/
    
    OPEN QUERY {&QUERYNAME} FOR EACH {&TableName} NO-LOCK
         WHERE {&tableName}.cod-estabel = c-cod-estabel
           AND {&tableName}.cdd-adiant  = d-cdd-adiant 
            BY {&tableName}.cod-estabel
            BY {&tableName}.cod-embarq.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByAdiant DBOProgram 
PROCEDURE openQueryByAdiant :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da Query pela chave do Adiantamento
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TableName} NO-LOCK
         WHERE {&tableName}.cod-estabel = c-cod-estabel
         AND   {&tableName}.cdd-adiant  = d-cdd-adiant.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura de todos os registros da query
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK 
                       INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByAdiantamento DBOProgram 
PROCEDURE setConstraintByAdiant :
/*------------------------------------------------------------------------------
  Purpose: Informa chave do adiantamento para abrir a query     
  Parameters: p-cod-estab    = C¢digo do estabelecimento
              p-cdd-adiant   = C¢digo do adiantamento
              
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-cod-estab   LIKE adiant-despes.cod-estab    NO-UNDO.
DEF INPUT PARAM p-cdd-adiant  LIKE adiant-despes.cdd-adiant   NO-UNDO. 

ASSIGN c-cod-estabel   = p-cod-estab   
       d-cdd-adiant    = p-cdd-adiant.      

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
    
    DEFINE VARIABLE i-aux AS INTEGER     NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    IF pType = "CREATE" 
        OR pType = "COPY" THEN DO:
        IF CAN-FIND (FIRST adiant-despes-embarq
                     WHERE adiant-despes-embarq.cod-estabel = RowObject.cod-estabel
                     AND   adiant-despes-embarq.cdd-adiant  = RowObject.cdd-adiant
                     AND   adiant-despes-embarq.cod-embarq  = RowObject.cod-embarq ) THEN DO:
            {utp/ut-liter.i Embarque * R}
            ASSIGN c-liter = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Adiantamento * R}  
            {method/svc/errors/inserr.i
                  &ErrorNumber="55312"
                  &ErrorType="EMS"
                  &ErrorParameters="c-liter + '~~~~' + RETURN-VALUE"}
        END.
    END.
    
    IF pType = "DELETE":U THEN DO:
        IF CAN-FIND(FIRST adiant-despes-lista
                    WHERE adiant-despes-lista.cod-estabel = RowObject.cod-estabel
                      AND adiant-despes-lista.cdd-adiant  = RowObject.cdd-adiant
                      AND adiant-despes-lista.cod-embarq  = RowObject.cod-embarq) THEN DO:
            {utp/ut-liter.i Embarque * R }
            ASSIGN c-liter = TRIM(RETURN-VALUE).
            {utp/ut-liter.i lista_de_antecipaá‰es * R}
            {method/svc/errors/inserr.i &ErrorNumber="5"    
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="c-liter + '~~~~' + RETURN-VALUE"}
        END.

    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

