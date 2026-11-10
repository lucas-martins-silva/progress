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
{include/i-prgvrs.i BOIN717 2.00.00.003} /*** "010003" 29/11/2023 09:07:15  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN717 MUT}
&ENDIF

/*--------------------------------------------------------------------------
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

{cdp/cdcfgmat.i} /* PrÇ-processadores de release */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN717
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName rma-it-dep-mov
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE ignoredErrors "3,8,10"
&GLOBAL-DEFINE newRecordOffQuery NO

/* DBO-XML-BEGIN */
/* Pre-processadores para ativar XML no DBO */
/* Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /* DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /* Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /* Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /* Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /* Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /* Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /* Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /* DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /* Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /* Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/* Campos livres - RMA */
&IF DEFINED(bf_mat_versao_ems) &THEN 
  &IF {&bf_mat_versao_ems} >= 2.05 &THEN
    &GLOBAL-DEFINE FALSE-log-recebe-mercad rma-item.log-recebe-mercad = NO
  &ELSE
    &GLOBAL-DEFINE FALSE-log-recebe-mercad rma-item.log-livre-2 = NO
  &ENDIF
&ENDIF

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin717.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/*--- Local variables definitions ---*/
DEF VAR cCodEstabel   LIKE rma-it-dep-mov.cod-estabel   NO-UNDO.
DEF VAR cCodRMA       LIKE rma-it-dep-mov.cod-rma       NO-UNDO.
DEF VAR iNumSequencia LIKE rma-it-dep-mov.num-sequencia NO-UNDO.
DEF VAR iNumSeqDep    LIKE rma-it-dep-mov.num-seq-dep   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram



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
         HEIGHT             = 1.96
         WIDTH              = 33.57.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose: Comportamento ap¢s a inclus∆o de um registro
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN 
    RETURN "NOK":U.
    
 /*** RMA do movimento ***/
 FOR FIRST rma WHERE
           rma.cod-estabel = rma-it-dep-mov.cod-estabel AND
           rma.cod-rma     = rma-it-dep-mov.cod-rma     NO-LOCK: END.
 IF NOT AVAIL rma THEN 
    RETURN "NOK":U.
    
 /*** Item do movimento ***/
 FOR FIRST rma-item WHERE 
           rma-item.cod-estabel   = rma-it-dep-mov.cod-estabel AND
           rma-item.cod-rma       = rma-it-dep-mov.cod-rma     AND
           rma-item.num-sequencia = rma-it-dep-mov.num-sequencia NO-LOCK: END.
 IF NOT AVAIL rma-item THEN
   RETURN "NOK":U.    
   
 /*** Caso o item do RMA n∆o baixe estoque, 
      ser† verificado se a criaá∆o deste movimento
      n∆o mudar† a situaá∆o do RMA para "Autorizado" ***/
      
  IF {&FALSE-log-recebe-mercad} THEN DO:  /*** N∆o baixa estoque ***/

     /*** Totaliza a quantidade j† recebida do RMA ***/
     FOR EACH bfrma-it-dep-mov WHERE
         bfrma-it-dep-mov.cod-estabel   = rma.cod-estabel   AND
         bfrma-it-dep-mov.cod-rma       = rma.cod-rma       NO-LOCK:
         ACCUMULATE bfrma-it-dep-mov.qtd-recebida (TOTAL).
     END.
     
     /*** Totaliza a quantidade a receber do RMA ***/  
     FOR EACH rma-item WHERE
              rma-item.cod-estabel = rma.cod-estabel AND
              rma-item.cod-rma     = rma.cod-rma NO-LOCK:
         ACCUMULATE rma-item.qtd-a-receber - rma-item.qtd-cancelada (TOTAL).
     END.
     
     /*** Se toda a quantidade a receber do RMA j† foi 
          efetivamente recebida, muda a situaá∆o para "Autorizado" ***/
     IF (ACCUM TOTAL bfrma-it-dep-mov.qtd-recebida) >= (ACCUM TOTAL rma-item.qtd-a-receber - 
                                                                    rma-item.qtd-cancelada) THEN DO:
       FIND CURRENT rma EXCLUSIVE-LOCK NO-ERROR.
       ASSIGN rma.cdn-situacao = 5.
     END.
  END.       
      
  RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterNewRecord DBOProgram 
PROCEDURE afterNewRecord :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FIND FIRST rowObject NO-ERROR.
  IF NOT AVAIL rowObject THEN
     RETURN "NOK":U.

  FOR LAST rma-it-dep-mov WHERE
           rma-it-dep-mov.cod-estabel   = cCodEstabel   AND
           rma-it-dep-mov.cod-rma       = cCodRMA       AND
           rma-it-dep-mov.num-sequencia = iNumSequencia AND
           rma-it-dep-mov.num-seq-dep   = iNumSeqDep    NO-LOCK: END.

  RUN incSeq (INPUT IF AVAIL rma-it-dep-mov THEN
                       rma-it-dep-mov.num-seq-dep-mov
                    ELSE 0).
      
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearIgnoredErrors DBOProgram 
PROCEDURE clearIgnoredErrors :
/*------------------------------------------------------------------------------
  Purpose: Remove da tabela de erros, registros que representam erros 
           ignorados apresentados incorretamente pelos DBOs.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH rowErrors WHERE
             lookup(STRING(rowErrors.errorNumber), {&ignoredErrors}) <> 0 :
       DELETE rowErrors.     
    END.         
    
  IF NOT CAN-FIND (FIRST rowErrors) THEN 
    RETURN "OK":U.
  ELSE
    RETURN "NOK":U.
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
        WHEN "cod-rma":U THEN ASSIGN pFieldValue = RowObject.cod-rma.
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
        WHEN "qtd-estocada":U THEN ASSIGN pFieldValue = RowObject.qtd-estocada.
        WHEN "qtd-recebida":U THEN ASSIGN pFieldValue = RowObject.qtd-recebida.
        WHEN "qtd-refugada":U THEN ASSIGN pFieldValue = RowObject.qtd-refugada.
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
        WHEN "num-seq-dep":U THEN ASSIGN pFieldValue = RowObject.num-seq-dep.
        WHEN "num-seq-dep-mov":U THEN ASSIGN pFieldValue = RowObject.num-seq-dep-mov.
        WHEN "num-sequencia":U THEN ASSIGN pFieldValue = RowObject.num-sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice dep-mov
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo cod-rma
               retorna valor do campo num-sequencia
               retorna valor do campo num-seq-dep
               retorna valor do campo num-seq-dep-mov
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE rma-it-dep-mov.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-rma LIKE rma-it-dep-mov.cod-rma NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-sequencia LIKE rma-it-dep-mov.num-sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-dep LIKE rma-it-dep-mov.num-seq-dep NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-dep-mov LIKE rma-it-dep-mov.num-seq-dep-mov NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pcod-rma = RowObject.cod-rma
           pnum-sequencia = RowObject.num-sequencia
           pnum-seq-dep = RowObject.num-seq-dep
           pnum-seq-dep-mov = RowObject.num-seq-dep-mov.

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
  Purpose:     Reposiciona registro com base no °ndice dep-mov
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cod-rma
               recebe valor do campo num-sequencia
               recebe valor do campo num-seq-dep
               recebe valor do campo num-seq-dep-mov
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE rma-it-dep-mov.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-rma LIKE rma-it-dep-mov.cod-rma NO-UNDO.
    DEFINE INPUT PARAMETER pnum-sequencia LIKE rma-it-dep-mov.num-sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-dep LIKE rma-it-dep-mov.num-seq-dep NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-dep-mov LIKE rma-it-dep-mov.num-seq-dep-mov NO-UNDO.

    FIND FIRST bfrma-it-dep-mov WHERE 
        bfrma-it-dep-mov.cod-estabel = pcod-estabel AND 
        bfrma-it-dep-mov.cod-rma = pcod-rma AND 
        bfrma-it-dep-mov.num-sequencia = pnum-sequencia AND 
        bfrma-it-dep-mov.num-seq-dep = pnum-seq-dep AND 
        bfrma-it-dep-mov.num-seq-dep-mov = pnum-seq-dep-mov NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrma-it-dep-mov THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrma-it-dep-mov)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE incSeq DBOProgram 
PROCEDURE incSeq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM piLastSeq LIKE rma-it-dep-mov.num-seq-dep-mov NO-UNDO.

  ASSIGN rowObject.num-seq-dep-mov = piLastSeq + 1.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToRMAItDep DBOProgram 
PROCEDURE linkToRMAItDep :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.

  RUN getKey IN pHandle (OUTPUT cCodEstabel,
                         OUTPUT cCodRma,
                         OUTPUT iNumSequencia,
                         OUTPUT iNumSeqDep).

  RUN setConstraintRMAItDep IN THIS-PROCEDURE (INPUT cCodEstabel,
                                               INPUT cCodRma,
                                               INPUT iNumSequencia,
                                               INPUT iNumSeqDep).

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToRMAItem DBOProgram 
PROCEDURE linkToRMAItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.

  RUN getKey IN pHandle (OUTPUT cCodEstabel,
                         OUTPUT cCodRma,
                         OUTPUT iNumSequencia).

  RUN setConstraintRMAItem IN THIS-PROCEDURE (INPUT cCodEstabel,
                                              INPUT cCodRma,
                                              INPUT iNumSequencia).

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

    OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRMAItDep DBOProgram 
PROCEDURE openQueryRMAItDep :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   OPEN QUERY {&queryName} FOR EACH {&tableName} WHERE
                                    {&tableName}.cod-estabel   = cCodEstabel   AND
                                    {&tableName}.cod-rma       = cCodRma       AND
                                    {&tableName}.num-sequencia = iNumSequencia AND
                                    {&tableName}.num-seq-dep   = iNumSeqDep 
                                    NO-LOCK INDEXED-REPOSITION.                                    
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRMAItem DBOProgram 
PROCEDURE openQueryRMAItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   OPEN QUERY {&queryName} FOR EACH {&tableName} WHERE
                                    {&tableName}.cod-estabel   = cCodEstabel   AND
                                    {&tableName}.cod-rma       = cCodRma       AND
                                    {&tableName}.num-sequencia = iNumSequencia 
                                    NO-LOCK INDEXED-REPOSITION.                                    
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRMAItDep DBOProgram 
PROCEDURE setConstraintRMAItDep :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pcCodEstabel   LIKE rma-it-dep-mov.cod-estabel   NO-UNDO.
DEF INPUT PARAM pcCodRMa       LIKE rma-it-dep-mov.cod-rma       NO-UNDO.
DEF INPUT PARAM piNumSequencia LIKE rma-it-dep-mov.num-sequencia NO-UNDO.
DEF INPUT PARAM piNumSeqDep    LIKE rma-it-dep-mov.num-seq-dep   NO-UNDO.

  ASSIGN cCodEstabel   = pcCodEstabel
         cCodRMA       = pcCodRMA
         iNumSequencia = piNumSequencia
         iNumSeqDep    = piNumSeqDep.
                
  RETURN "OK":u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRMAItem DBOProgram 
PROCEDURE setConstraintRMAItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pcCodEstabel   LIKE rma-it-dep-mov.cod-estabel   NO-UNDO.
DEF INPUT PARAM pcCodRMa       LIKE rma-it-dep-mov.cod-rma       NO-UNDO.
DEF INPUT PARAM piNumSequencia LIKE rma-it-dep-mov.num-sequencia NO-UNDO.

  ASSIGN cCodEstabel   = pcCodEstabel
         cCodRMA       = pcCodRMA
         iNumSequencia = piNumSequencia.
                
  RETURN "OK":u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



