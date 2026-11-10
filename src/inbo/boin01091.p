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
{include/i-prgvrs.i BOIN01091 2.00.00.019} /*** "010019" 03/11/2026 09:31:28 ***/

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01091
&GLOBAL-DEFINE DBOVersion 2.00.00.005
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-doc-est-tribut
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND TRUE
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND-PROCS Main

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
{inbo/boin01091.i RowObject}
{inbo/boin01091.i tt-item-doc-est-tribut}
{inbo/boin176.i tt-item-doc-est}

DEF TEMP-TABLE tt-soma-item-doc-est-tribut NO-UNDO
    LIKE item-doc-est-tribut
    FIELD vl-somatorio   LIKE item-doc-est.preco-total[1]
    FIELD vl-total-atrib LIKE item-doc-est.preco-total[1]
    FIELD seq-item-conv  LIKE item-doc-orig-nfe.seq-item.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}



/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


DEFINE VARIABLE c-cod-serie-docto  LIKE item-doc-est-tribut.cod-serie-docto  NO-UNDO.
DEFINE VARIABLE c-cod-num-docto    LIKE item-doc-est-tribut.cod-num-docto    NO-UNDO.
DEFINE VARIABLE i-cdn-emitente     LIKE item-doc-est-tribut.cdn-emitente     NO-UNDO.
DEFINE VARIABLE c-cod-natur-operac LIKE item-doc-est-tribut.cod-natur-operac NO-UNDO.
DEFINE VARIABLE i-num-seq          LIKE item-doc-est-tribut.num-seq          NO-UNDO.


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
         HEIGHT             = 21.71
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

DEFINE TEMP-TABLE RowErrorsAcum NO-UNDO LIKE RowErrors.

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
        WHEN "cod-campo":U THEN ASSIGN pFieldValue = RowObject.cod-campo.
        WHEN "cod-conteudo":U THEN ASSIGN pFieldValue = RowObject.cod-conteudo.
        WHEN "cod-natur-operac":U THEN ASSIGN pFieldValue = RowObject.cod-natur-operac.
        WHEN "cod-num-docto":U THEN ASSIGN pFieldValue = RowObject.cod-num-docto.
        WHEN "cod-serie-docto":U THEN ASSIGN pFieldValue = RowObject.cod-serie-docto.
        WHEN "nom-trib":U THEN ASSIGN pFieldValue = RowObject.nom-trib.
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
        WHEN "cdn-emitente":U THEN ASSIGN pFieldValue = RowObject.cdn-emitente.
        WHEN "num-seq":U THEN ASSIGN pFieldValue = RowObject.num-seq.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice itmdcstt_id2
  Parameters:  
               retorna valor do campo cod-serie-docto
               retorna valor do campo cod-num-docto
               retorna valor do campo cdn-emitente
               retorna valor do campo cod-natur-operac
               retorna valor do campo num-seq
               retorna valor do campo nom-trib
               retorna valor do campo cod-campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-serie-docto LIKE item-doc-est-tribut.cod-serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-num-docto LIKE item-doc-est-tribut.cod-num-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-emitente LIKE item-doc-est-tribut.cdn-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-natur-operac LIKE item-doc-est-tribut.cod-natur-operac NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq LIKE item-doc-est-tribut.num-seq NO-UNDO.
    DEFINE OUTPUT PARAMETER pnom-trib LIKE item-doc-est-tribut.nom-trib NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-campo LIKE item-doc-est-tribut.cod-campo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-serie-docto = RowObject.cod-serie-docto
           pcod-num-docto = RowObject.cod-num-docto
           pcdn-emitente = RowObject.cdn-emitente
           pcod-natur-operac = RowObject.cod-natur-operac
           pnum-seq = RowObject.num-seq
           pnom-trib = RowObject.nom-trib
           pcod-campo = RowObject.cod-campo.

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
  Purpose:     Reposiciona registro com base no °ndice itmdcstt_id2
  Parameters:  
               recebe valor do campo cod-serie-docto
               recebe valor do campo cod-num-docto
               recebe valor do campo cdn-emitente
               recebe valor do campo cod-natur-operac
               recebe valor do campo num-seq
               recebe valor do campo nom-trib
               recebe valor do campo cod-campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-serie-docto  LIKE item-doc-est-tribut.cod-serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-num-docto    LIKE item-doc-est-tribut.cod-num-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente     LIKE item-doc-est-tribut.cdn-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcod-natur-operac LIKE item-doc-est-tribut.cod-natur-operac NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq          LIKE item-doc-est-tribut.num-seq NO-UNDO.
    DEFINE INPUT PARAMETER pnom-trib         LIKE item-doc-est-tribut.nom-trib NO-UNDO.
    DEFINE INPUT PARAMETER pcod-campo        LIKE item-doc-est-tribut.cod-campo NO-UNDO.
    

    
    FIND FIRST bfitem-doc-est-tribut WHERE 
        bfitem-doc-est-tribut.cod-serie-docto = pcod-serie-docto AND 
        bfitem-doc-est-tribut.cod-num-docto = pcod-num-docto AND 
        bfitem-doc-est-tribut.cdn-emitente = pcdn-emitente AND 
        bfitem-doc-est-tribut.cod-natur-operac = pcod-natur-operac AND 
        bfitem-doc-est-tribut.num-seq = pnum-seq AND 
        bfitem-doc-est-tribut.nom-trib = pnom-trib AND 
        bfitem-doc-est-tribut.cod-campo = pcod-campo NO-LOCK NO-ERROR.
    
    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-doc-est-tribut THEN 
        RETURN "NOK":U.
    
    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-doc-est-tribut)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfItemDocEst DBOProgram 
PROCEDURE openQueryOfItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
	OPEN QUERY {&QueryName} FOR EACH  {&TableName} NO-LOCK 
                                WHERE {&TableName}.cod-serie-docto    = c-cod-serie-docto 
                                AND   {&TableName}.cod-num-docto      = c-cod-num-docto   
                                AND   {&TableName}.cdn-emitente       = i-cdn-emitente    
                                AND   {&TableName}.cod-natur-operac   = c-cod-natur-operac
                                AND   {&TableName}.num-seq            = i-num-seq         
                                INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfItemDocEst DBOProgram 
PROCEDURE setConstraintOfItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-serie-docto  LIKE item-doc-est-tribut.cod-serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-num-docto    LIKE item-doc-est-tribut.cod-num-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente     LIKE item-doc-est-tribut.cdn-emitente     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-natur-operac LIKE item-doc-est-tribut.cod-natur-operac NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq          LIKE item-doc-est-tribut.num-seq          NO-UNDO.

    ASSIGN c-cod-serie-docto  = pcod-serie-docto 
           c-cod-num-docto    = pcod-num-docto   
           i-cdn-emitente     = pcdn-emitente    
           c-cod-natur-operac = pcod-natur-operac
           i-num-seq          = pnum-seq.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocumEst DBOProgram 
PROCEDURE openQueryOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
	OPEN QUERY {&QueryName} FOR EACH  {&TableName} NO-LOCK 
                                WHERE {&TableName}.cod-serie-docto    = c-cod-serie-docto 
                                AND   {&TableName}.cod-num-docto      = c-cod-num-docto   
                                AND   {&TableName}.cdn-emitente       = i-cdn-emitente    
                                AND   {&TableName}.cod-natur-operac   = c-cod-natur-operac
                                INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfDocumEst DBOProgram 
PROCEDURE setConstraintOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-serie-docto  LIKE item-doc-est-tribut.cod-serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-num-docto    LIKE item-doc-est-tribut.cod-num-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente     LIKE item-doc-est-tribut.cdn-emitente     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-natur-operac LIKE item-doc-est-tribut.cod-natur-operac NO-UNDO.
    

    ASSIGN c-cod-serie-docto  = pcod-serie-docto 
           c-cod-num-docto    = pcod-num-docto   
           i-cdn-emitente     = pcdn-emitente    
           c-cod-natur-operac = pcod-natur-operac.

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
	OPEN QUERY {&QueryName} FOR EACH  {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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

    
    IF pType = "Create":U 
    OR pType = "Update":U THEN DO: 
        /* Conteudo deve ser diferente de branco */ 
        IF RowObject.cod-conteudo  = "" THEN DO:     
            {utp/ut-liter.i Conteudo *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="56733"
                    &ErrorType="EMS"
                    &ErrorParameters="RowObject.nom-trib + '~~~~' + RowObject.cod-campo "}  
        END.
         
        /*Campo CST somente aceita impostos ICMS,IPI,PIS e COFINS*/
        IF RowObject.cod-campo   = "CST"
            AND (RowObject.nom-trib <> "ICMS" 
            AND RowObject.nom-trib <> "IPI"
            AND RowObject.nom-trib <> "PIS" 
            AND RowObject.nom-trib <> "COFINS"
            AND RowObject.nom-trib <> "IBS UF"
            AND RowObject.nom-trib <> "IBS MUN"
            AND RowObject.nom-trib <> "CBS"
            AND RowObject.nom-trib <> "IS") THEN DO:     
                {method/svc/errors/inserr.i
                        &ErrorNumber="56726"
                        &ErrorType="EMS"
                        &ErrorParameters="RowObject.nom-trib + '~~~~' + RowObject.cod-campo"}  
        END.

        /* Validacao para nao deixar criar uma item-doc-est-tribut sem ter uma item-doc-est com as chaves iguais*/
        IF NOT CAN-FIND (FIRST item-doc-est
                            WHERE item-doc-est.serie-docto  = RowObject.cod-serie-docto
                              AND item-doc-est.nro-docto    = RowObject.cod-num-docto 
                              AND item-doc-est.cod-emitente = RowObject.cdn-emitente
                              AND item-doc-est.nat-operacao = RowObject.cod-natur-operac
                              AND item-doc-est.sequencia    = Rowobject.num-seq) THEN
            {method/svc/errors/inserr.i
                    &ErrorNumber="56727"
                    &ErrorType="EMS"
                    &ErrorParameters="return-value"}  
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvaRegistros DBOProgram 
PROCEDURE salvaRegistros:
    DEF INPUT PARAMETER TABLE FOR tt-item-doc-est-tribut.
    DEF OUTPUT PARAM TABLE FOR RowErrorsAcum.

    EMPTY TEMP-TABLE RowErrorsAcum.

    FOR EACH tt-item-doc-est-tribut:
        FIND FIRST item-doc-est-tribut 
             WHERE item-doc-est-tribut.cod-serie-docto  = tt-item-doc-est-tribut.cod-serie-docto
               AND item-doc-est-tribut.cod-num-docto    = tt-item-doc-est-tribut.cod-num-docto
               AND item-doc-est-tribut.cdn-emitente     = tt-item-doc-est-tribut.cdn-emitente
               AND item-doc-est-tribut.cod-natur-operac = tt-item-doc-est-tribut.cod-natur-operac
               AND item-doc-est-tribut.num-seq          = tt-item-doc-est-tribut.num-seq
               AND item-doc-est-tribut.nom-trib         = tt-item-doc-est-tribut.nom-trib
               AND item-doc-est-tribut.cod-campo        = tt-item-doc-est-tribut.cod-campo EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL item-doc-est-tribut THEN DO:
            //Update
            ASSIGN item-doc-est-tribut.cod-conteudo = tt-item-doc-est-tribut.cod-conteudo.
        END.
        ELSE DO:
            //Create
            RUN emptyRowErrors.
            RUN emptyRowObject.
            CREATE RowObject.
            BUFFER-COPY tt-item-doc-est-tribut TO RowObject.
            RUN validateRecord(INPUT "Create":U).
            IF RETURN-VALUE = "OK":U THEN DO:
                CREATE item-doc-est-tribut.
                BUFFER-COPY tt-item-doc-est-tribut TO item-doc-est-tribut.
            END.
            ELSE DO:
                FOR EACH RowErrors:
                    CREATE RowErrorsAcum.
                    BUFFER-COPY RowErrors TO RowErrorsAcum.
                END.
            END.
        END.
   END.
   RELEASE item-doc-est-tribut.

   IF CAN-FIND (FIRST RowErrorsAcum) THEN DO:
       RETURN "NOK":U.
   END. 

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTItemDocEstTributComBaseItemDocImpNfe DBOProgram 
PROCEDURE criaTTItemDocEstTributComBaseItemDocImpNfe:
    DEF INPUT  PARAMETER pc-chave-acesso AS CHAR NO-UNDO.
    DEF INPUT  PARAMETER TABLE FOR tt-item-doc-est.
    DEF OUTPUT PARAMETER TABLE FOR tt-item-doc-est-tribut.

    DEF VAR d-cod-conteudo       AS DEC NO-UNDO.
    DEF VAR d-fator-rateio-impto AS DEC NO-UNDO.

    EMPTY TEMP-TABLE tt-item-doc-est-tribut.
    EMPTY TEMP-TABLE tt-soma-item-doc-est-tribut.

    FOR EACH tt-item-doc-est:
        FIND FIRST item-doc-orig-nfe
             WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = pc-chave-acesso
               AND item-doc-orig-nfe.seq-item           = INT(SUBSTRING(tt-item-doc-est.char-2,832,5)) /*Seq Item monitor*/
               AND item-doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK NO-ERROR.

        IF NOT AVAIL item-doc-orig-nfe THEN
            RETURN "NOK":U.

        ASSIGN d-fator-rateio-impto = tt-item-doc-est.preco-total[1] / (item-doc-orig-nfe.preco-unit * item-doc-orig-nfe.qtd-comercial).

        FOR EACH item-doc-imp-nfe NO-LOCK
           WHERE item-doc-imp-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe                                       
             AND item-doc-imp-nfe.seq-item           = item-doc-orig-nfe.seq-item 
             AND item-doc-imp-nfe.tipo-reg           = "TRAD":U: 

            CREATE tt-item-doc-est-tribut.
            ASSIGN tt-item-doc-est-tribut.cod-serie-docto  = tt-item-doc-est.serie-docto
                   tt-item-doc-est-tribut.cod-num-docto    = tt-item-doc-est.nro-docto   
                   tt-item-doc-est-tribut.cdn-emitente     = tt-item-doc-est.cod-emitente
                   tt-item-doc-est-tribut.cod-natur-operac = tt-item-doc-est.nat-operacao
                   tt-item-doc-est-tribut.num-seq          = tt-item-doc-est.sequencia   
                   tt-item-doc-est-tribut.nom-trib         = item-doc-imp-nfe.nom-trib    
                   tt-item-doc-est-tribut.cod-campo        = item-doc-imp-nfe.cod-campo   
                   tt-item-doc-est-tribut.cod-conteudo     = item-doc-imp-nfe.cod-conteudo.
                   
            IF  item-doc-imp-nfe.cod-campo <> rep.imp.AtributoImposto:CSOSN
            AND item-doc-imp-nfe.cod-campo <> rep.imp.AtributoImposto:CST
            AND item-doc-imp-nfe.cod-campo <> rep.imp.AtributoImposto:CST-REG
            AND item-doc-imp-nfe.cod-campo <> rep.imp.AtributoImposto:MOTIVO-REDUC
            AND item-doc-imp-nfe.cod-campo <> rep.imp.AtributoImposto:DEDUZ-DESON
            AND item-doc-imp-nfe.cod-campo <> rep.imp.AtributoImposto:MOTIVO-DESON
            AND item-doc-imp-nfe.cod-campo <> rep.imp.AtributoImposto:MODALIDADE-BC
            AND item-doc-imp-nfe.cod-campo <> rep.imp.AtributoImposto:ORIGEM
            AND item-doc-imp-nfe.cod-campo <> rep.imp.AtributoImposto:C-CLASS-TRIB
            AND item-doc-imp-nfe.cod-campo <> rep.imp.AtributoImposto:C-CLASS-TRIB-REG
            AND item-doc-imp-nfe.cod-campo <> rep.imp.AtributoImposto:C-CLASS-CP
            AND item-doc-imp-nfe.cod-campo <> rep.imp.AtributoImposto:PROCESSO-SUFRAMA
            AND item-doc-imp-nfe.cod-campo <> rep.imp.AtributoImposto:UN-TRIBUT THEN DO:
                 // Conteudo do campo em formato decimal
                 ASSIGN d-cod-conteudo = 0.
                 ASSIGN d-cod-conteudo = DEC(REPLACE(item-doc-imp-nfe.cod-conteudo,".",",")) NO-ERROR.
            
                 ASSIGN tt-item-doc-est-tribut.cod-conteudo   = STRING(d-cod-conteudo).
            END.
                                  
            // Caso tenha FIFO e houver quebra de itens (tt-item-doc-est) Ç necess†rio ratear os valores/base de impostos entre os itens gerados
            IF d-fator-rateio-impto <> 1 THEN DO:
                IF SUBSTRING(tt-item-doc-est-tribut.cod-campo, 1, 4)  = "BASE" OR
                   (SUBSTRING(tt-item-doc-est-tribut.cod-campo, 1, 5) = "VALOR" AND tt-item-doc-est-tribut.cod-campo <> "VALOR UNID" ) OR 
                   tt-item-doc-est-tribut.cod-campo                   = "DESCONTO BASE" OR 
                   tt-item-doc-est-tribut.cod-campo                   = "QUANT UNID"  OR
				   tt-item-doc-est-tribut.cod-campo                   = "QTDE TRIBUT" THEN DO:
                    ASSIGN tt-item-doc-est-tribut.cod-conteudo = STRING(ROUND(DEC(REPLACE(tt-item-doc-est-tribut.cod-conteudo,".",",")) * d-fator-rateio-impto, 2)).
                                  
                    // cria a tabela de somatorio para poder realizar o ajuste de residuo
                    FIND FIRST tt-soma-item-doc-est-tribut
                         WHERE tt-soma-item-doc-est-tribut.seq-item-conv = item-doc-orig-nfe.seq-item
                           AND tt-soma-item-doc-est-tribut.nom-trib      = item-doc-imp-nfe.nom-trib
                           AND tt-soma-item-doc-est-tribut.cod-campo     = item-doc-imp-nfe.cod-campo NO-ERROR.
                    IF NOT AVAIL tt-soma-item-doc-est-tribut THEN DO:
                        CREATE tt-soma-item-doc-est-tribut.
                        BUFFER-COPY tt-item-doc-est-tribut TO tt-soma-item-doc-est-tribut.
                        ASSIGN tt-soma-item-doc-est-tribut.seq-item-conv  = item-doc-orig-nfe.seq-item
                               tt-soma-item-doc-est-tribut.vl-total-atrib = DEC(REPLACE(item-doc-imp-nfe.cod-conteudo,".",",")).
                    END.
                END.
            END.
        END.
    END.

    // Ajuste de residuo de BASE E VALOR de impostos (mais ou menos 1 centavo devido a arredondamento)
    FOR EACH tt-item-doc-est NO-LOCK
       BREAK BY SUBSTRING(tt-item-doc-est.char-2,832,5): /*Seq Item monitor*/

        FOR EACH tt-item-doc-est-tribut
           WHERE tt-item-doc-est-tribut.cod-serie-docto  = tt-item-doc-est.serie-docto 
             AND tt-item-doc-est-tribut.cod-num-docto    = tt-item-doc-est.nro-docto
             AND tt-item-doc-est-tribut.cdn-emitente     = tt-item-doc-est.cod-emitente
             AND tt-item-doc-est-tribut.cod-natur-operac = tt-item-doc-est.nat-operacao
             AND tt-item-doc-est-tribut.num-seq          = tt-item-doc-est.sequencia:
            FIND FIRST tt-soma-item-doc-est-tribut
                 WHERE tt-soma-item-doc-est-tribut.seq-item-conv = INT(SUBSTRING(tt-item-doc-est.char-2,832,5))
                   AND tt-soma-item-doc-est-tribut.nom-trib      = tt-item-doc-est-tribut.nom-trib
                   AND tt-soma-item-doc-est-tribut.cod-campo     = tt-item-doc-est-tribut.cod-campo NO-ERROR.

            // Se nao estiver avail n∆o Ç um atributo que necessita ajuste
            IF AVAIL tt-soma-item-doc-est-tribut THEN DO:
                // ajuste residuo na ultima sequencia
                IF LAST-OF(SUBSTRING(tt-item-doc-est.char-2,832,5)) /*Seq Item monitor*/ THEN DO:
                    ASSIGN tt-item-doc-est-tribut.cod-conteudo = STRING(tt-soma-item-doc-est-tribut.vl-total-atrib -
                                                                        tt-soma-item-doc-est-tribut.vl-somatorio).
                END.
                ELSE DO:
                    ASSIGN tt-soma-item-doc-est-tribut.vl-somatorio = tt-soma-item-doc-est-tribut.vl-somatorio +
                                                                      DEC(REPLACE(tt-item-doc-est-tribut.cod-conteudo, ".", ",")).
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
