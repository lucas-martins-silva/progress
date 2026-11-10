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
&GLOBAL-DEFINE DBOName BOIN867
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-fornec-fabrican-umd
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
{inbo/boin867.i RowObject}


{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


DEFINE VARIABLE cCodItemIni  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCodItemFim  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cUnMedIni    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cUnMedFim    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cPaisOrigIni AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cPaisOrigFim AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iFornecIni   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iFornecFim   AS INTEGER     NO-UNDO.

DEFINE VARIABLE iCodErro  AS INTEGER     NO-UNDO.
DEFINE VARIABLE cRetorno1 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cRetorno2 AS CHARACTER   NO-UNDO.


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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH item-fornec-fabrican-umd NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItem DBOProgram 
PROCEDURE openQueryByItem :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH item-fornec-fabrican-umd NO-LOCK
                               WHERE item-fornec-fabrican-umd.cod-item   >= cCodItemIni
                                 AND item-fornec-fabrican-umd.cod-item   <= cCodItemFim
                                  BY item-fornec-fabrican-umd.cod-item
                                  BY item-fornec-fabrican-umd.cod-un-medid
                                  BY item-fornec-fabrican-umd.cod-pais-orig
                                  BY item-fornec-fabrican-umd.cdn-emitente
                                  INDEXED-REPOSITION.
 
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByItem DBOProgram 
PROCEDURE setConstraintByItem :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT  PARAMETER pcCodItemIni AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pcCodItemFim AS CHARACTER   NO-UNDO.

    ASSIGN cCodItemIni = pcCodItemIni
           cCodItemFim = pcCodItemFim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByUnMed DBOProgram 
PROCEDURE openQueryByUnMed :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH item-fornec-fabrican-umd NO-LOCK
                               WHERE item-fornec-fabrican-umd.cod-un-medid >= cUnMedIni
                                 AND item-fornec-fabrican-umd.cod-un-medid <= cUnMedFim
                                  BY item-fornec-fabrican-umd.cod-un-medid
                                  BY item-fornec-fabrican-umd.cod-item
                                  BY item-fornec-fabrican-umd.cod-pais-orig
                                  BY item-fornec-fabrican-umd.cdn-emitente
                                  INDEXED-REPOSITION.
 
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByUnMed DBOProgram 
PROCEDURE setConstraintByUnMed :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT  PARAMETER pcUnMedIni   AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pcUnMedFim   AS CHARACTER   NO-UNDO.

    ASSIGN cUnMedIni   = pcUnMedIni
           cUnMedFim   = pcUnMedFim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByPaisOrig DBOProgram 
PROCEDURE openQueryByPaisOrig :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH item-fornec-fabrican-umd NO-LOCK
                               WHERE item-fornec-fabrican-umd.cod-pais-orig >= cPaisOrigIni
                                 AND item-fornec-fabrican-umd.cod-pais-orig <= cPaisOrigFim
                                  BY item-fornec-fabrican-umd.cod-pais-orig
                                  BY item-fornec-fabrican-umd.cod-item
                                  BY item-fornec-fabrican-umd.cod-un-medid
                                  BY item-fornec-fabrican-umd.cdn-emitente
                                  INDEXED-REPOSITION.
 
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByPaisOrig DBOProgram 
PROCEDURE setConstraintByPaisOrig :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT  PARAMETER pcPaisOrigIni AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pcPaisOrigFim AS CHARACTER   NO-UNDO.

    ASSIGN cPaisOrigIni = pcPaisOrigIni
           cPaisOrigFim = pcPaisOrigFim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFornec DBOProgram 
PROCEDURE openQueryByFornec :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH item-fornec-fabrican-umd NO-LOCK
                               WHERE item-fornec-fabrican-umd.cdn-emitente  >= iFornecIni
                                 AND item-fornec-fabrican-umd.cdn-emitente  <= iFornecFim
                                  BY item-fornec-fabrican-umd.cdn-emitente
                                  BY item-fornec-fabrican-umd.cod-item
                                  BY item-fornec-fabrican-umd.cod-un-medid
                                  BY item-fornec-fabrican-umd.cod-pais-orig
                                  INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByFornec DBOProgram 
PROCEDURE setConstraintByFornec :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT  PARAMETER piFornecIni   AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER piFornecFim   AS INTEGER     NO-UNDO.

    ASSIGN iFornecIni   = piFornecIni
           iFornecFim   = piFornecFim.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-ean":U THEN ASSIGN pFieldValue = RowObject.cod-ean.
        WHEN "cod-fabrican":U THEN ASSIGN pFieldValue = RowObject.cod-fabrican.
        WHEN "cod-item":U THEN ASSIGN pFieldValue = RowObject.cod-item.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-livre-3":U THEN ASSIGN pFieldValue = RowObject.cod-livre-3.
        WHEN "cod-livre-4":U THEN ASSIGN pFieldValue = RowObject.cod-livre-4.
        WHEN "cod-livre-5":U THEN ASSIGN pFieldValue = RowObject.cod-livre-5.
        WHEN "cod-pais-orig":U THEN ASSIGN pFieldValue = RowObject.cod-pais-orig.
        WHEN "cod-un-medid":U THEN ASSIGN pFieldValue = RowObject.cod-un-medid.
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
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-livre-3":U THEN ASSIGN pFieldValue = RowObject.dat-livre-3.
        WHEN "dat-livre-4":U THEN ASSIGN pFieldValue = RowObject.dat-livre-4.
        WHEN "dat-livre-5":U THEN ASSIGN pFieldValue = RowObject.dat-livre-5.
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
        WHEN "val-fator-conver":U THEN ASSIGN pFieldValue = RowObject.val-fator-conver.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-livre-3":U THEN ASSIGN pFieldValue = RowObject.val-livre-3.
        WHEN "val-livre-4":U THEN ASSIGN pFieldValue = RowObject.val-livre-4.
        WHEN "val-livre-5":U THEN ASSIGN pFieldValue = RowObject.val-livre-5.
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
        WHEN "cdn-emitente":U THEN ASSIGN pFieldValue = RowObject.cdn-emitente.
        WHEN "num-casas-dec":U THEN ASSIGN pFieldValue = RowObject.num-casas-dec.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-livre-3":U THEN ASSIGN pFieldValue = RowObject.num-livre-3.
        WHEN "num-livre-4":U THEN ASSIGN pFieldValue = RowObject.num-livre-4.
        WHEN "num-livre-5":U THEN ASSIGN pFieldValue = RowObject.num-livre-5.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice itmfrnca-id
  Parameters:  
               retorna valor do campo cod-item
               retorna valor do campo cdn-emitente
               retorna valor do campo cod-pais-orig
               retorna valor do campo cod-un-medid
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-item LIKE item-fornec-fabrican-umd.cod-item NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-emitente LIKE item-fornec-fabrican-umd.cdn-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-pais-orig LIKE item-fornec-fabrican-umd.cod-pais-orig NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-un-medid LIKE item-fornec-fabrican-umd.cod-un-medid NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-item = RowObject.cod-item
           pcdn-emitente = RowObject.cdn-emitente
           pcod-pais-orig = RowObject.cod-pais-orig
           pcod-un-medid = RowObject.cod-un-medid.

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
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-livre-3":U THEN ASSIGN pFieldValue = RowObject.log-livre-3.
        WHEN "log-livre-4":U THEN ASSIGN pFieldValue = RowObject.log-livre-4.
        WHEN "log-livre-5":U THEN ASSIGN pFieldValue = RowObject.log-livre-5.
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
  Purpose:     Reposiciona registro com base no ¡ndice itmfrnca-id
  Parameters:  
               recebe valor do campo cod-item
               recebe valor do campo cdn-emitente
               recebe valor do campo cod-pais-orig
               recebe valor do campo cod-un-medid
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pcod-item      LIKE item-fornec-fabrican-umd.cod-item      NO-UNDO.
    DEFINE INPUT PARAMETER pcod-un-medid  LIKE item-fornec-fabrican-umd.cod-un-medid  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-pais-orig LIKE item-fornec-fabrican-umd.cod-pais-orig NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente  LIKE item-fornec-fabrican-umd.cdn-emitente  NO-UNDO.

    FIND FIRST bfitem-fornec-fabrican-umd WHERE 
        bfitem-fornec-fabrican-umd.cod-item = pcod-item AND 
        bfitem-fornec-fabrican-umd.cdn-emitente = pcdn-emitente AND 
        bfitem-fornec-fabrican-umd.cod-pais-orig = pcod-pais-orig AND 
        bfitem-fornec-fabrican-umd.cod-un-medid = pcod-un-medid NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-fornec-fabrican-umd THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-fornec-fabrican-umd)).
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

    IF  pType = "create":U THEN DO:
    
        IF  CAN-FIND (FIRST item-fornec-fabrican-umd NO-LOCK
                      WHERE item-fornec-fabrican-umd.cod-item      = RowObject.cod-item     
                        AND item-fornec-fabrican-umd.cod-un-medid  = RowObject.cod-un-medid 
                        AND item-fornec-fabrican-umd.cod-pais-orig = RowObject.cod-pais-orig
                        AND item-fornec-fabrican-umd.cdn-emitente  = RowObject.cdn-emitente) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-item-x-un-med-x-pais-origem-x AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item_x_Un_Med_x_Pa¡s_Origem_x_Fornecedor" *}
            ASSIGN c-lbl-liter-item-x-un-med-x-pais-origem-x = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="8"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-item-x-un-med-x-pais-origem-x"}
        END.

        IF (RowObject.cod-item <> "" AND RowObject.cod-item <> "*")
        AND NOT CAN-FIND (FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = RowObject.cod-item) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind item 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.

        IF (RowObject.cod-un-medid <> "" AND RowObject.cod-un-medid <> "*")
        AND NOT CAN-FIND (FIRST tab-unidade NO-LOCK WHERE tab-unidade.un = RowObject.cod-un-medid) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind tab-unidade 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.

        IF (RowObject.cod-pais-orig <> "" AND RowObject.cod-pais-orig <> "0")
        AND NOT CAN-FIND (FIRST pais NO-LOCK WHERE pais.cod-pais = INT(TRIM(RowObject.cod-pais-orig)) ) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-pais-origem AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Pa¡s_Origem" *}
            ASSIGN c-lbl-liter-pais-origem = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-pais-origem"}
        END.

        IF  RowObject.cdn-emitente <> 0
        AND NOT CAN-FIND (FIRST emitente NO-LOCK WHERE emitente.cod-emitente = RowObject.cdn-emitente) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-fornecedor AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Fornecedor" *}
            ASSIGN c-lbl-liter-fornecedor = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-fornecedor"}
        END.
    END.

    IF  pType <> "delete":U
    AND TRIM(RowObject.cod-ean) <> "":U THEN
        RUN pi-Validacao-GTIN-EAN.
    
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Validacao-GTIN-EAN DBOProgram  
PROCEDURE pi-Validacao-GTIN-EAN :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE h-bodi247 AS HANDLE      NO-UNDO.

    RUN dibo/bodi247.p PERSISTENT SET h-bodi247.

    ASSIGN iCodErro = 0.

    RUN validaDigitoVerificadorGTIN IN h-bodi247 (INPUT TRIM(RowObject.cod-ean),
                                                  OUTPUT iCodErro,
                                                  OUTPUT cRetorno1,
                                                  OUTPUT cRetorno2).
    
    IF  iCodErro <> 0 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="iCodErro"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="cRetorno1 + '~~~~':U + cRetorno2"}
    END.

    DELETE PROCEDURE h-bodi247.
    ASSIGN h-bodi247 = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
