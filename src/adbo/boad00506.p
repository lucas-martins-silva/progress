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

{include/i-prgvrs.i BOAD00506 2.00.00.006 } /*** "010006" 13/11/2023 11:45:42 ***/

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOAD00506
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName transpdor-veic-reboque
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
{adbo/boad00506.i RowObject}

DEFINE TEMP-TABLE tt-transpdor-veic-reboque-aux NO-UNDO LIKE transpdor-veic-reboque.


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF VAR i-cod-transp   LIKE rowobject.cod-transp NO-UNDO.
DEF VAR i-cdn-seq-veic LIKE rowobject.cdn-seq-veic NO-UNDO.

DEF TEMP-TABLE tt-transpdor-veic-reboque NO-UNDO LIKE transpdor-veic-reboque .
DEF VAR l-check  AS LOGICAL INITIAL TRUE NO-UNDO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkAction DBOProgram 
PROCEDURE checkAction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pl-check AS LOGICAL NO-UNDO.

    ASSIGN l-check = pl-check.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecordsCustom DBOProgram 
PROCEDURE getBatchRecordsCustom :
    DEFINE OUTPUT PARAMETER TABLE FOR tt-transpdor-veic-reboque-aux.

    FOR EACH tt-transpdor-veic-reboque-aux:
        DELETE tt-transpdor-veic-reboque-aux.
    END.

    FOR EACH transpdor-veic-reboque NO-LOCK 
       WHERE transpdor-veic-reboque.cod-transp   = i-cod-transp
         AND transpdor-veic-reboque.cdn-seq-veic = i-cdn-seq-veic:
           
         CREATE tt-transpdor-veic-reboque-aux.
         BUFFER-COPY transpdor-veic-reboque TO tt-transpdor-veic-reboque-aux.

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
        WHEN "cod-antt":U THEN ASSIGN pFieldValue = RowObject.cod-antt.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-placa":U THEN ASSIGN pFieldValue = RowObject.cod-placa.
        WHEN "cod-renavam":U THEN ASSIGN pFieldValue = RowObject.cod-renavam.
        WHEN "cod-uf":U THEN ASSIGN pFieldValue = RowObject.cod-uf.
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
        WHEN "qtd-capac-peso":U THEN ASSIGN pFieldValue = RowObject.qtd-capac-peso.
        WHEN "qtd-capac-vol":U THEN ASSIGN pFieldValue = RowObject.qtd-capac-vol.
        WHEN "tara":U THEN ASSIGN pFieldValue = RowObject.tara.
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
        WHEN "cdn-emitente":U THEN ASSIGN pFieldValue = RowObject.cdn-emitente.
        WHEN "cdn-seq-reboque":U THEN ASSIGN pFieldValue = RowObject.cdn-seq-reboque.
        WHEN "cdn-seq-veic":U THEN ASSIGN pFieldValue = RowObject.cdn-seq-veic.
        WHEN "cdn-tip-carroc":U THEN ASSIGN pFieldValue = RowObject.cdn-tip-carroc.
        WHEN "cdn-tip-veic":U THEN ASSIGN pFieldValue = RowObject.cdn-tip-veic.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "idi-tip-propriet":U THEN ASSIGN pFieldValue = RowObject.idi-tip-propriet.
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
  Purpose:     Retorna valores dos campos do °ndice trans-veic-reb-id
  Parameters:  
               retorna valor do campo cod-transp
               retorna valor do campo cdn-seq-veic
               retorna valor do campo cdn-seq-reboque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-transp LIKE transpdor-veic-reboque.cod-transp NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-seq-veic LIKE transpdor-veic-reboque.cdn-seq-veic NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-seq-reboque LIKE transpdor-veic-reboque.cdn-seq-reboque NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-transp = RowObject.cod-transp
           pcdn-seq-veic = RowObject.cdn-seq-veic
           pcdn-seq-reboque = RowObject.cdn-seq-reboque.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSeqAdd DBOProgram 
PROCEDURE getSeqAdd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAM pi-cod-transp   LIKE transpdor-veic-reboque.cod-transp.
DEFINE INPUT  PARAM pi-cdn-seq-veic LIKE transpdor-veic-reboque.cdn-seq-veic.
DEFINE OUTPUT PARAM pi-seq          LIKE transpdor-veic-reboque.cdn-seq-reboque.

    FIND LAST transpdor-veic-reboque 
        WHERE transpdor-veic-reboque.cod-transp   = pi-cod-transp
          AND transpdor-veic-reboque.cdn-seq-veic = pi-cdn-seq-veic NO-LOCK NO-ERROR.
    IF AVAIL transpdor-veic-reboque THEN
        ASSIGN pi-seq = transpdor-veic-reboque.cdn-seq-reboque + 1.
    ELSE 
        ASSIGN  pi-seq = 1.


    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice trans-veic-reb-id
  Parameters:  
               recebe valor do campo cod-transp
               recebe valor do campo cdn-seq-veic
               recebe valor do campo cdn-seq-reboque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-transp LIKE transpdor-veic-reboque.cod-transp NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-seq-veic LIKE transpdor-veic-reboque.cdn-seq-veic NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-seq-reboque LIKE transpdor-veic-reboque.cdn-seq-reboque NO-UNDO.


    FIND FIRST bftranspdor-veic-reboque WHERE 
        bftranspdor-veic-reboque.cod-transp = pcod-transp AND 
        bftranspdor-veic-reboque.cdn-seq-veic = pcdn-seq-veic AND 
        bftranspdor-veic-reboque.cdn-seq-reboque = pcdn-seq-reboque NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bftranspdor-veic-reboque THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
          
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftranspdor-veic-reboque)).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilitaReboque DBOProgram 
PROCEDURE habilitaReboque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pi-cod-transp AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM pi-veic AS INT NO-UNDO.
    DEFINE OUTPUT PARAM l-ok AS LOGICAL NO-UNDO.


    ASSIGN l-ok = CAN-FIND(FIRST transpdor-veic WHERE transpdor-veic.cod-transp   = pi-cod-transp
                                                  AND transpdor-veic.cdn-seq-veic = pi-veic).
                                                  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByTranspVeic DBOProgram 
PROCEDURE openQueryByTranspVeic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
         WHERE {&TableName}.cod-transp   = i-cod-transp
           AND {&TableName}.cdn-seq-veic = i-cdn-seq-veic INDEXED-REPOSITION.

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByTranspVeic DBOProgram 
PROCEDURE setConstraintByTranspVeic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pi-cod-transp   LIKE RowObject.cod-transp NO-UNDO.
    DEF INPUT PARAM pi-cdn-seq-veic LIKE RowObject.cdn-seq-veic NO-UNDO.

    ASSIGN i-cod-transp   = pi-cod-transp  
           i-cdn-seq-veic = pi-cdn-seq-veic.

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



    IF ptype = "Create":U THEN DO:
        IF NOT CAN-FIND(FIRST transpdor-veic WHERE transpdor-veic.cod-transp   = rowObject.cod-transp
                                               AND transpdor-veic.cdn-seq-veic = rowObject.cdn-seq-veic) THEN DO:
         
            {utp/ut-liter.i Ve≠culo_Inexistente *}
            {method/svc/errors/inserr.i
                   &ErrorNumber="17006"
                   &ErrorType="EMS"
                   &ErrorParameters=" "} 

            RETURN "NOK":U.
         END.
    END.
    
    IF ptype = "Create":U OR ptype = "Update":U THEN DO:
        
        IF rowObject.cod-placa = "" 
        OR rowObject.cod-placa = ? THEN DO:
            {utp/ut-liter.i Placa *}
            {method/svc/errors/inserr.i
                      &ErrorNumber="53947"
                      &ErrorType="EMS"
                      &ErrorParameters="return-value"}
                        
            RETURN "NOK":U.
        END.
        
        IF l-check THEN 
            {method/svc/errors/inserr.i
                          &ErrorNumber="53946"
                          &ErrorType="EMS"
                          &ErrorParameters=" "}    
                          
        IF RowObject.cod-uf = "" 
        OR RowObject.cod-uf = ? THEN DO:
            {utp/ut-liter.i UF *}
            {method/svc/errors/inserr.i
                   &ErrorNumber="53947"
                   &ErrorType="EMS"
                   &ErrorParameters="return-value"}  
            RETURN "NOK":U.            
        END.  

        IF NOT CAN-FIND(FIRST unid-feder WHERE unid-feder.estado = RowObject.cod-uf) THEN DO:
            {utp/ut-liter.i UF *}
            {method/svc/errors/inserr.i
                     &ErrorNumber="158"
                     &ErrorType="EMS"
                     &ErrorParameters="return-value"} 
        END.

        IF NOT CAN-FIND(FIRST tip-carroc WHERE tip-carroc.cdn-tip-carroc = RowObject.cdn-tip-carroc) THEN DO:
            {utp/ut-liter.i Tipo_Carroceria *}
            {method/svc/errors/inserr.i
                     &ErrorNumber="158"
                     &ErrorType="EMS"
                     &ErrorParameters="return-value"} 
        END.

        IF NOT CAN-FIND(FIRST tip-veic-transp WHERE tip-veic-transp.cdn-tip-veic = RowObject.cdn-tip-veic) THEN DO:
            {utp/ut-liter.i Tipo_Ve≠culo *}
            {method/svc/errors/inserr.i
                     &ErrorNumber="158"
                     &ErrorType="EMS"
                     &ErrorParameters="return-value"}
        END.
        
     END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaPlaca DBOProgram 
PROCEDURE verificaPlaca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pi-cod-transp AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAM pc-placa      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM l-ok         AS LOGICAL   NO-UNDO.

    ASSIGN l-ok = CAN-FIND(FIRST transpdor-veic-reboque WHERE transpdor-veic-reboque.cod-transp = pi-cod-transp
                                                          AND transpdor-veic-reboque.cod-placa  = pc-placa).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

