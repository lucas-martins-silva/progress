/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**      
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.  
*********************************************************************************/
{include/i-prgvrs.i BOIN01095 2.00.00.003 } /*** "010003" 13/11/2023 11:45:46 ***/

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
&GLOBAL-DEFINE DBOName BOIN01095
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ct-trib-item-doc-est
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
{inbo/boin01095.i RowObject}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


DEFINE VARIABLE c-cod-ser-docto    LIKE ct-trib-item-doc-est.cod-ser-docto    NO-UNDO.
DEFINE VARIABLE c-cod-docto        LIKE ct-trib-item-doc-est.cod-docto        NO-UNDO.
DEFINE VARIABLE i-cdn-emitente     LIKE ct-trib-item-doc-est.cdn-emitente     NO-UNDO.
DEFINE VARIABLE c-cod-natur-operac LIKE ct-trib-item-doc-est.cod-natur-operac NO-UNDO.
DEFINE VARIABLE i-num-seq          LIKE ct-trib-item-doc-est.num-seq          NO-UNDO.

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
        WHEN "cod-ser-docto":U         THEN ASSIGN pFieldValue = RowObject.cod-ser-docto.
        WHEN "cod-docto":U             THEN ASSIGN pFieldValue = RowObject.cod-docto.
        WHEN "cod-natur-operac":U      THEN ASSIGN pFieldValue = RowObject.cod-natur-operac.
        WHEN "cod-item":U              THEN ASSIGN pFieldValue = RowObject.cod-item.
        WHEN "cod-tip-trib":U          THEN ASSIGN pFieldValue = RowObject.cod-tip-trib.
        WHEN "cod-configur-trib":U     THEN ASSIGN pFieldValue = RowObject.cod-configur-trib.
        WHEN "cod-estab":U             THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-embarq":U            THEN ASSIGN pFieldValue = RowObject.cod-embarq.
        WHEN "cod-chave-cenar":U       THEN ASSIGN pFieldValue = RowObject.cod-chave-cenar.
        WHEN "cod-sit-tributar":U      THEN ASSIGN pFieldValue = RowObject.cod-sit-tributar.
        WHEN "cod-formul-base-calc":U  THEN ASSIGN pFieldValue = RowObject.cod-formul-base-calc.
        WHEN "cod-memo-calc-base":U    THEN ASSIGN pFieldValue = RowObject.cod-memo-calc-base.
        WHEN "cod-formul-trib":U       THEN ASSIGN pFieldValue = RowObject.cod-formul-trib.
        WHEN "cod-memo-calc-trib":U    THEN ASSIGN pFieldValue = RowObject.cod-memo-calc-trib.
        WHEN "hra-ult-atualiz":U       THEN ASSIGN pFieldValue = RowObject.hra-ult-atualiz.
        WHEN "cod-usuar-ult-atualiz":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-ult-atualiz.
        WHEN "cod-livre-1":U           THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
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
        WHEN "val-aliq":U       THEN ASSIGN pFieldValue = RowObject.val-aliq.
        WHEN "val-base":U       THEN ASSIGN pFieldValue = RowObject.val-base.
        WHEN "val-trib":U       THEN ASSIGN pFieldValue = RowObject.val-trib.
        WHEN "val-perc-reduc":U THEN ASSIGN pFieldValue = RowObject.val-perc-reduc.
        WHEN "val-fix-trib":U   THEN ASSIGN pFieldValue = RowObject.val-fix-trib.  
        WHEN "val-quant-fix":U  THEN ASSIGN pFieldValue = RowObject.val-quant-fix. 
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
        WHEN "cdn-emitente":U     THEN ASSIGN pFieldValue = RowObject.cdn-emitente.
        WHEN "num-seq":U          THEN ASSIGN pFieldValue = RowObject.num-seq.
        WHEN "num-ct-trib":U      THEN ASSIGN pFieldValue = RowObject.num-ct-trib.
        WHEN "idi-cod-tributac":U THEN ASSIGN pFieldValue = RowObject.idi-cod-tributac.
        WHEN "cdn-msg-of":U       THEN ASSIGN pFieldValue = RowObject.cdn-msg-of.
        WHEN "cdn-msg-faturam":U  THEN ASSIGN pFieldValue = RowObject.cdn-msg-faturam.
        WHEN "num-ordem":U        THEN ASSIGN pFieldValue = RowObject.num-ordem.
        WHEN "num-parcela":U      THEN ASSIGN pFieldValue = RowObject.num-parcela.
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
               retorna valor do campo cod-ser-docto
               retorna valor do campo cod-docto
               retorna valor do campo cdn-emitente
               retorna valor do campo cod-natur-operac
               retorna valor do campo num-seq
               retorna valor do campo num-ct-trib
               retorna valor do campo cod-item
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-ser-docto     LIKE ct-trib-item-doc-est.cod-ser-docto     NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-docto         LIKE ct-trib-item-doc-est.cod-docto         NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-emitente      LIKE ct-trib-item-doc-est.cdn-emitente      NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-natur-operac  LIKE ct-trib-item-doc-est.cod-natur-operac  NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq           LIKE ct-trib-item-doc-est.num-seq           NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-ct-trib       LIKE ct-trib-item-doc-est.num-ct-trib       NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-item          LIKE ct-trib-item-doc-est.cod-item          NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tip-trib      LIKE ct-trib-item-doc-est.cod-tip-trib      NO-UNDO. 
    DEFINE OUTPUT PARAMETER pcod-configur-trib LIKE ct-trib-item-doc-est.cod-configur-trib NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-ser-docto     = RowObject.cod-ser-docto
           pcod-docto         = RowObject.cod-docto
           pcdn-emitente      = RowObject.cdn-emitente
           pcod-natur-operac  = RowObject.cod-natur-operac
           pnum-seq           = RowObject.num-seq
           pnum-ct-trib       = RowObject.num-ct-trib
           pcod-item          = RowObject.cod-item
           pcod-tip-trib      = RowObject.cod-tip-trib     
           pcod-configur-trib = RowObject.cod-configur-trib.

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
               recebe valor do campo cod-ser-docto
               recebe valor do campo cod-docto
               recebe valor do campo cdn-emitente
               recebe valor do campo cod-natur-operac
               recebe valor do campo num-seq
               recebe valor do campo num-ct-trib
               recebe valor do campo cod-item
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-ser-docto     LIKE ct-trib-item-doc-est.cod-ser-docto     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-docto         LIKE ct-trib-item-doc-est.cod-docto         NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente      LIKE ct-trib-item-doc-est.cdn-emitente      NO-UNDO.
    DEFINE INPUT PARAMETER pcod-natur-operac  LIKE ct-trib-item-doc-est.cod-natur-operac  NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq           LIKE ct-trib-item-doc-est.num-seq           NO-UNDO.
    DEFINE INPUT PARAMETER pnum-ct-trib       LIKE ct-trib-item-doc-est.num-ct-trib       NO-UNDO.
    DEFINE INPUT PARAMETER pcod-item          LIKE ct-trib-item-doc-est.cod-item          NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tip-trib      LIKE ct-trib-item-doc-est.cod-tip-trib      NO-UNDO.
    DEFINE INPUT PARAMETER pcod-configur-trib LIKE ct-trib-item-doc-est.cod-configur-trib NO-UNDO.

    FIND FIRST bfct-trib-item-doc-est NO-LOCK
         WHERE bfct-trib-item-doc-est.cod-ser-docto     = pcod-ser-docto
           AND bfct-trib-item-doc-est.cod-docto         = pcod-docto
           AND bfct-trib-item-doc-est.cdn-emitente      = pcdn-emitente
           AND bfct-trib-item-doc-est.cod-natur-operac  = pcod-natur-operac
           AND bfct-trib-item-doc-est.num-seq           = pnum-seq
           AND bfct-trib-item-doc-est.num-ct-trib       = pnum-ct-trib
           AND bfct-trib-item-doc-est.cod-item          = pcod-item  
           AND bfct-trib-item-doc-est.cod-tip-trib      = pcod-tip-trib     
           AND bfct-trib-item-doc-est.cod-configur-trib = pcod-configur-trib NO-ERROR.
    
    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfct-trib-item-doc-est THEN 
        RETURN "NOK":U.
    
    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfct-trib-item-doc-est)).
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
                                WHERE {&TableName}.cod-ser-docto    = c-cod-ser-docto 
                                AND   {&TableName}.cod-docto        = c-cod-docto   
                                AND   {&TableName}.cdn-emitente     = i-cdn-emitente    
                                AND   {&TableName}.cod-natur-operac = c-cod-natur-operac
                                AND   {&TableName}.num-seq          = i-num-seq INDEXED-REPOSITION.

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
    DEFINE INPUT PARAMETER pcod-ser-docto    LIKE ct-trib-item-doc-est.cod-ser-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-docto        LIKE ct-trib-item-doc-est.cod-docto        NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente     LIKE ct-trib-item-doc-est.cdn-emitente     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-natur-operac LIKE ct-trib-item-doc-est.cod-natur-operac NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq          LIKE ct-trib-item-doc-est.num-seq          NO-UNDO.

    ASSIGN c-cod-ser-docto    = pcod-ser-docto 
           c-cod-docto        = pcod-docto   
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
                                WHERE {&TableName}.cod-ser-docto    = c-cod-ser-docto 
                                AND   {&TableName}.cod-docto        = c-cod-docto   
                                AND   {&TableName}.cdn-emitente     = i-cdn-emitente    
                                AND   {&TableName}.cod-natur-operac = c-cod-natur-operac INDEXED-REPOSITION.

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
    DEFINE INPUT PARAMETER pcod-ser-docto    LIKE ct-trib-item-doc-est.cod-ser-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-docto        LIKE ct-trib-item-doc-est.cod-docto        NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente     LIKE ct-trib-item-doc-est.cdn-emitente     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-natur-operac LIKE ct-trib-item-doc-est.cod-natur-operac NO-UNDO.

    ASSIGN c-cod-ser-docto    = pcod-ser-docto 
           c-cod-docto        = pcod-docto   
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
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

