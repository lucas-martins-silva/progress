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
{include/i-prgvrs.i BOIN773 2.00.00.013 } /*** "010013" 24/11/2023 13:25:28  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin773 MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : BOIN773.P
    Purpose    : Cont‚m a l¢gica de neg¢cio e acesso a dados para a tabela mla-param-aprov
    Parameters : 
    Notes      : 
  ------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName boin773
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName mla-param-aprov
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*Pre-processadores para acelerador de implanta‡Æo*/
&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

{inbo/boin773.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-ep-codigo AS CHARACTER     NO-UNDO.

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

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U         THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U         THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "char-3":U         THEN ASSIGN pFieldValue = RowObject.char-3.
        WHEN "char-4":U         THEN ASSIGN pFieldValue = RowObject.char-4.
        WHEN "char-5":U         THEN ASSIGN pFieldValue = RowObject.char-5.
        WHEN "cod-estabel":U    THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "compl-email":U    THEN ASSIGN pFieldValue = RowObject.compl-email.
        WHEN "servidor-asp":U   THEN ASSIGN pFieldValue = RowObject.servidor-asp.
        WHEN "servidor-email":U THEN ASSIGN pFieldValue = RowObject.servidor-email.
        WHEN "hra-execucao":U   THEN ASSIGN pFieldValue = RowObject.hra-execucao.
        WHEN "ep-codigo":U      THEN ASSIGN pFieldValue = RowObject.ep-codigo.
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
        WHEN "destino-verba":U  THEN ASSIGN pFieldValue = RowObject.destino-verba.
        WHEN "int-1":U          THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U          THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "int-3":U          THEN ASSIGN pFieldValue = RowObject.int-3.
        WHEN "int-4":U          THEN ASSIGN pFieldValue = RowObject.int-4.
        WHEN "int-5":U          THEN ASSIGN pFieldValue = RowObject.int-5.
        WHEN "porta-email":U    THEN ASSIGN pFieldValue = RowObject.porta-email.
        WHEN "sequencia":U      THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "cdn-rej":U        THEN ASSIGN pFieldValue = RowObject.cdn-rej.
            
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice principal
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE mla-param-aprov.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE mla-param-aprov.cod-estabel NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-estabel = RowObject.cod-estabel.

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
        WHEN "log-1":U                      THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U                      THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-3":U                      THEN ASSIGN pFieldValue = RowObject.log-3.
        WHEN "log-4":U                      THEN ASSIGN pFieldValue = RowObject.log-4.
        WHEN "log-5":U                      THEN ASSIGN pFieldValue = RowObject.log-5.
        WHEN "log-aprov-altern":U           THEN ASSIGN pFieldValue = RowObject.log-aprov-altern.
        WHEN "log-atachado":U               THEN ASSIGN pFieldValue = RowObject.log-atachado.
        WHEN "log-email":U                  THEN ASSIGN pFieldValue = RowObject.log-email.
        WHEN "log-email-altern":U           THEN ASSIGN pFieldValue = RowObject.log-email-altern.
        WHEN "log-exchange":U               THEN ASSIGN pFieldValue = RowObject.log-exchange.
        WHEN "log-senha":U                  THEN ASSIGN pFieldValue = RowObject.log-senha.
        WHEN "log-aprovac-altern-dat":U     THEN ASSIGN pFieldValue = RowObject.log-aprovac-altern-dat.
        WHEN "log-priorid-aprova-docto":U   THEN ASSIGN pFieldValue = RowObject.log-priorid-aprova-docto.
        WHEN "log-cond-pagto":U             THEN ASSIGN pFieldValue = RowObject.log-cond-pagto.
        WHEN "log-ord-recbda":U             THEN ASSIGN pFieldValue = RowObject.log-ord-recbda.
        WHEN "log-ord-confda":U             THEN ASSIGN pFieldValue = RowObject.log-ord-confda.
        WHEN "log-assume-permissoes-prin":U THEN pFieldValue = IF SUBSTRING(mla-param-aprov.char-1,3,1) = "S":U THEN YES ELSE NO.
        WHEN "log-assume-lotacoes-prin":U   THEN pFieldValue = IF SUBSTRING(mla-param-aprov.char-1,2,1) = "S":U THEN YES ELSE NO.
        WHEN "log-assume-mestre-prin":U     THEN pFieldValue = IF SUBSTRING(mla-param-aprov.char-1,4,1) = "S":U THEN YES ELSE NO.
        WHEN "log-integr-fluig":U           THEN ASSIGN pFieldValue = RowObject.log-integr-fluig.
        WHEN "log-praz-conclus":U           THEN ASSIGN pFieldValue = RowObject.log-praz-conclus.
        
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
  Purpose:     Reposiciona registro com base no ¡ndice principal
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE mla-param-aprov.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE mla-param-aprov.cod-estabel NO-UNDO.

    FIND FIRST bfmla-param-aprov
         WHERE bfmla-param-aprov.ep-codigo = pep-codigo
           AND bfmla-param-aprov.cod-estabel = pcod-estabel NO-LOCK NO-ERROR.

    IF NOT AVAILABLE bfmla-param-aprov THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-param-aprov)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEmpresa DBOProgram 
PROCEDURE setConstraintEmpresa :
/*------------------------------------------------------------------------------
  Purpose: Atualiza o valor da empresa para abertura da query por empresa     
  Parameters: c-ep-codigo (input): C¢digo da empresa (caracter)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-ep-codigo LIKE mla-param-aprov.ep-codigo.

    ASSIGN c-ep-codigo = pc-ep-codigo.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEmpresa DBOProgram 
PROCEDURE openQueryEmpresa :
/*------------------------------------------------------------------------------
  Purpose: Abertura da query para parƒmetros de aprova‡Æo de uma determinada empresa    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} 
        FOR EACH {&TABLENAME} WHERE {&TABLENAME}.ep-codigo = c-ep-codigo
                 NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s da include: method/svc/errors/inserr.i
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:

        IF pType = "CREATE":U
        AND CAN-FIND(FIRST mla-param-aprov
                     WHERE mla-param-aprov.ep-codigo = RowObject.ep-codigo
                       AND mla-param-aprov.cod-estabel = RowObject.cod-estabel) THEN DO:
            {utp/ut-liter.i "parƒmetros de aprova‡Æo"}
            
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
    
        /* Existˆncia do estabelecimento */
        IF NOT CAN-FIND (FIRST estabelec
                         WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            {utp/ut-liter.i "estabelecimento"}
            
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=RETURN-VALUE}
        END.
    
        IF RowObject.int-1 < 1 OR RowObject.int-1 > 2 THEN DO:
            {utp/ut-liter.i "lota‡Æo_de_aprova‡Æo_autom tica"}
            
            {method/svc/errors/inserr.i &ErrorNumber="158"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=RETURN-VALUE}
        END.
    
        
        IF RowObject.destino-verba < 1 OR RowObject.destino-verba > 2 THEN DO:
            {utp/ut-liter.i "debita_verba"}
            
            {method/svc/errors/inserr.i &ErrorNumber="158"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=RETURN-VALUE}
        END.
    END.

    /*Valida dados de integra‡Æo com o Fluig*/
    {utp/ut-field.i mgind mla-param-aprov hra-execucao 1}
    RUN pi-valida-hora(INPUT RowObject.hra-execucao, INPUT TRIM(RETURN-VALUE)).
        
    IF NOT CAN-FIND (FIRST mla-rej-aprov 
                     WHERE mla-rej-aprov.cod-rejeicao = RowObject.cdn-rej) THEN DO:
         {utp/ut-field.i mgind mla-param-aprov cdn-rej 1}
         
         {method/svc/errors/inserr.i &ErrorNumber="2"
                                     &ErrorType="EMS"
                                     &ErrorSubType="ERROR"
                                     &ErrorParameters=RETURN-VALUE}
    END.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-hora DBOProgram
PROCEDURE pi-valida-hora :
/*------------------------------------------------------------------------------
  Purpose:     Valida os campos hora de processamento relacionados ao fluig
  Parameters:  cFieldValue - Valor do campo
               cFieldLabel - R½tulo do campo
  Notes:       
------------------------------------------------------------------------------*/
    {inbo/boin784.m02}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
