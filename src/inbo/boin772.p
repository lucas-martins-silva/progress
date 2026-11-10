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
{include/i-prgvrs.i BOIN772 2.00.00.011 } /*** "010011" 24/11/2023 13:25:28  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin772 MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : BOIN772.P
    Purpose    : Cont‚m a l¢gica de neg¢cio e acesso a dados para tabela mla-lotacao
    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName boin772
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName mla-lotacao
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
{inbo/boin772.i RowObject}

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
{method/dboqry.i}

/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-ep-codigo        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-lotacao-ini  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-lotacao-fim  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-desc-lotacao-ini AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-desc-lotacao-fim AS CHARACTER NO-UNDO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaLotacaoUsuarOrig DBOProgram 
PROCEDURE buscaLotacaoUsuarOrig :
/*------------------------------------------------------------------------------
  Purpose: Busca lota‡Æo do usu rio da requisi‡Æo para ser usado na aprova‡Æo do 
           documento apenas para Cota‡Æo, Pedido Compra Item e Pedido Emergencial Item   
  Parameters: pi-tipo      - C¢digo do documento no MLA - INTEGER
              pi-nr-requis - N£mero da requisi‡Æo       - INTEGER
              pc-usuario   - C¢digo do usu rio          - CHARACTER
              pc-lotacao   - Lota‡Æo ou centro de custo - CHARACTER
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-tipo      LIKE mla-tipo-doc-aprov.cod-tip-doc NO-UNDO.
    DEFINE INPUT  PARAMETER pi-nr-requis LIKE requisicao.nr-requisicao    NO-UNDO.
    DEFINE INPUT  PARAMETER pc-usuario   LIKE mla-usuar-aprov.cod-usuar   NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-lotacao   LIKE mla-usuar-aprov.cod-lotacao NO-UNDO.

    DEFINE BUFFER bf-mla-usuar-aprov FOR  mla-usuar-aprov.
    
  /*Se marcado parƒmetro "Utiliza lota‡Æo usu rio documento de origem" 
    e a ordem for criada a partir de uma requisi‡Æo
    busca a lota‡Æo do usu rio criador da requisi‡Æo.
   */
    IF pi-tipo = 5 /*Cota‡Æo*/ OR
       pi-tipo = 6 /*Pedido de Compra - Item*/ OR
       pi-tipo = 19 /*Pedido Emergencial - Item*/ THEN DO:
    
        FOR FIRST mla-usuar-aprov NO-LOCK
            WHERE mla-usuar-aprov.cod-usuar = pc-usuario: END.

        if pi-nr-requis <> 0 then do:
           IF AVAIL mla-usuar-aprov AND mla-usuar-aprov.destino-lotacao = 1 /*Lota‡Æo*/ AND
              trim(SUBSTRING(mla-usuar-aprov.char-1,2,1)) = "1" /* Utiliza lota‡Æo usu rio documento de origem */
               THEN DO:
               FOR FIRST requisicao FIELDS(nome-abrev) no-lock
                  WHERE requisicao.nr-requisicao = pi-nr-requis:
                  FOR FIRST bf-mla-usuar-aprov fields(cod-lotacao)
                      WHERE bf-mla-usuar-aprov.cod-usuar = requisicao.nome-abrev NO-LOCK:
                      ASSIGN pc-lotacao = bf-mla-usuar-aprov.cod-lotacao.
                  END.
               END.
           END.
        END.
        ELSE DO:
             /*Se nÆo tiver requisi‡Æo busca a lota‡Æo do usu rio caso o 
             mesmo esteja configurado para trabalhar com lota‡Æo*/
             IF  AVAIL mla-usuar-aprov AND mla-usuar-aprov.destino-lotacao = 1 /*Lota‡Æo*/ THEN
                 ASSIGN pc-lotacao = mla-usuar-aprov.cod-lotacao.
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

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U       THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U       THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "char-3":U       THEN ASSIGN pFieldValue = RowObject.char-3.
        WHEN "char-4":U       THEN ASSIGN pFieldValue = RowObject.char-4.
        WHEN "char-5":U       THEN ASSIGN pFieldValue = RowObject.char-5.
        WHEN "cod-lotacao":U  THEN ASSIGN pFieldValue = RowObject.cod-lotacao.
        WHEN "desc-lotacao":U THEN ASSIGN pFieldValue = RowObject.desc-lotacao.
        WHEN "ep-codigo":U    THEN ASSIGN pFieldValue = RowObject.ep-codigo.
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

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-3":U THEN ASSIGN pFieldValue = RowObject.data-3.
        WHEN "data-4":U THEN ASSIGN pFieldValue = RowObject.data-4.
        WHEN "data-5":U THEN ASSIGN pFieldValue = RowObject.data-5.
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

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "dec-3":U THEN ASSIGN pFieldValue = RowObject.dec-3.
        WHEN "dec-4":U THEN ASSIGN pFieldValue = RowObject.dec-4.
        WHEN "dec-5":U THEN ASSIGN pFieldValue = RowObject.dec-5.
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

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "int-3":U THEN ASSIGN pFieldValue = RowObject.int-3.
        WHEN "int-4":U THEN ASSIGN pFieldValue = RowObject.int-4.
        WHEN "int-5":U THEN ASSIGN pFieldValue = RowObject.int-5.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice codigo
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-lotacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE mla-lotacao.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-lotacao LIKE mla-lotacao.cod-lotacao NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-lotacao = RowObject.cod-lotacao.

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

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-3":U THEN ASSIGN pFieldValue = RowObject.log-3.
        WHEN "log-4":U THEN ASSIGN pFieldValue = RowObject.log-4.
        WHEN "log-5":U THEN ASSIGN pFieldValue = RowObject.log-5.
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
  Purpose:     Reposiciona registro com base no ¡ndice codigo
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-lotacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo   LIKE mla-lotacao.ep-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-lotacao LIKE mla-lotacao.cod-lotacao NO-UNDO.

    FIND FIRST bfmla-lotacao 
         WHERE bfmla-lotacao.ep-codigo   = pep-codigo 
           AND bfmla-lotacao.cod-lotacao = pcod-lotacao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-lotacao THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-lotacao)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
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
    DEF INPUT PARAMETER p-ordem AS CHAR NO-UNDO.

    RUN openQueryStatic (INPUT "Main":U). 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEmpresa DBOProgram 
PROCEDURE openQueryEmpresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME}
        FOR EACH {&TABLENAME}
           WHERE {&TABLENAME}.ep-codigo = c-ep-codigo
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
    OPEN QUERY {&QUERYNAME} 
        FOR EACH {&TABLENAME} 
                 NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangeCodLotacao DBOProgram 
PROCEDURE openQueryRangeCodLotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} 
        FOR EACH {&TABLENAME}
           WHERE {&TABLENAME}.ep-codigo    = c-ep-codigo
             AND {&TABLENAME}.cod-lotacao >= c-cod-lotacao-ini
             AND {&TABLENAME}.cod-lotacao <= c-cod-lotacao-fim
                 NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangeDescLotacao DBOProgram 
PROCEDURE openQueryRangeDescLotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} 
        FOR EACH {&TABLENAME}
           WHERE {&TABLENAME}.ep-codigo     = c-ep-codigo
             AND {&TABLENAME}.desc-lotacao >= c-desc-lotacao-ini
             AND {&TABLENAME}.desc-lotacao <= c-desc-lotacao-fim
                 NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEmpresa DBOProgram 
PROCEDURE setConstraintEmpresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-ep-codigo AS CHARACTER NO-UNDO.

    ASSIGN c-ep-codigo = pc-ep-codigo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangeCodLotacao DBOProgram 
PROCEDURE setConstraintRangeCodLotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-ep-codigo       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-lotacao-ini AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-lotacao-fim AS CHARACTER NO-UNDO.

    ASSIGN c-ep-codigo       = pc-ep-codigo
           c-cod-lotacao-ini = pc-cod-lotacao-ini
           c-cod-lotacao-fim = pc-cod-lotacao-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangeDescLotacao DBOProgram 
PROCEDURE setConstraintRangeDescLotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-ep-codigo        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-desc-lotacao-ini AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-desc-lotacao-fim AS CHARACTER NO-UNDO.

    ASSIGN c-ep-codigo        = pc-ep-codigo
           c-desc-lotacao-ini = pc-desc-lotacao-ini
           c-desc-lotacao-fim = pc-desc-lotacao-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do include: method/svc/errors/inserr.i
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
        
        /* Chave prim ria */
        IF pType = "CREATE":U
        AND CAN-FIND(FIRST mla-lotacao
                     WHERE mla-lotacao.ep-codigo = RowObject.ep-codigo
                       AND mla-lotacao.cod-lotacao = RowObject.cod-lotacao) THEN DO:
            {utp/ut-liter.i "lota‡äes_do_usu rio"}
            
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" 
                                        &ErrorParameters=RETURN-VALUE}
        END.

        /* Existˆncia da empresa */
        IF NOT CAN-FIND (FIRST empresa
                         WHERE empresa.ep-codigo = RowObject.ep-codigo) THEN DO:
            {utp/ut-liter.i "empresa"}

            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=RETURN-VALUE}
        END.
    END.
    ELSE DO:
        
        /**  Pendˆncias de aprova‡Æo **/
        IF CAN-FIND(FIRST mla-doc-pend-aprov 
                    WHERE mla-doc-pend-aprov.cod-lotacao-doc = RowObject.cod-lotacao
                      AND mla-doc-pend-aprov.ep-codigo       = RowObject.ep-codigo) THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="54480"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=RowObject.cod-lotacao}               
        END.
        
        IF CAN-FIND(FIRST mla-doc-pend-aprov
                    WHERE mla-doc-pend-aprov.cod-lotacao-trans = RowObject.cod-lotacao
                      AND mla-doc-pend-aprov.ep-codigo         = RowObject.ep-codigo) THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="54480"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=RowObject.cod-lotacao}                         
        END.
        
        /**  Faixas da aprova‡Æo **/
        IF CAN-FIND(FIRST mla-faixa-aprov 
                    WHERE mla-faixa-aprov.cod-lotacao = RowObject.cod-lotacao
                      AND mla-faixa-aprov.ep-codigo   = RowObject.ep-codigo) THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="54481"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=RowObject.cod-lotacao}                      
        END.
        
        /**  Hierarquia de aprovadores **/
        IF CAN-FIND(FIRST mla-hierarquia-aprov 
                    WHERE mla-hierarquia-aprov.cod-lotacao = RowObject.cod-lotacao
                      AND mla-hierarquia-aprov.ep-codigo   = RowObject.ep-codigo) THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="54482"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=RowObject.cod-lotacao}                   
        END.
        
        /**  Hierarquia da faixa **/
        IF CAN-FIND(FIRST mla-hierarquia-faixa
                    WHERE mla-hierarquia-faixa.cod-lotacao = RowObject.cod-lotacao
                      AND mla-hierarquia-faixa.ep-codigo   = RowObject.ep-codigo) THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="54479"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=RowObject.cod-lotacao}                       
        END.
        
        /**  Permissäes da lota‡Æo **/
        IF CAN-FIND(FIRST mla-perm-lotacao
                    WHERE mla-perm-lotacao.cod-lotacao = RowObject.cod-lotacao
                      AND mla-perm-lotacao.ep-codigo   = RowObject.ep-codigo) THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="54483"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=RowObject.cod-lotacao}                       
        END.
        
        /**  Usu rios da aprova‡Æo **/
        IF CAN-FIND(FIRST mla-usuar-aprov 
                    WHERE mla-usuar-aprov.cod-lotacao = RowObject.cod-lotacao
                      AND mla-usuar-aprov.ep-codigo   = RowObject.ep-codigo) THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="54484"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=RowObject.cod-lotacao}                       
        END.
    END.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

