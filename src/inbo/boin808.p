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
{include/i-prgvrs.i BOIN808 2.00.00.002 } /*** "010002" 13/11/2023 11:45:50 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin808 MUT}
&ENDIF


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
&GLOBAL-DEFINE DBOName                  BOIN808
&GLOBAL-DEFINE DBOVersion               2.04.00.001
&GLOBAL-DEFINE DBOCustomFunctions       
&GLOBAL-DEFINE TableName config-var-operac           
&GLOBAL-DEFINE TableLabel config-var-operac
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
{inbo/boin808.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE variable i-cod-empresa LIKE config-operac.cdn-empresa NO-UNDO.
DEFINE variable c-cod-estabel LIKE config-operac.cod-estab NO-UNDO.
DEFINE variable c-cod-tipo-oper LIKE config-operac.cod-tip-operac NO-UNDO.

DEFINE variable i-cod-empresa-key   LIKE config-operac.cdn-empresa NO-UNDO.
DEFINE variable c-cod-estabel-key   LIKE config-operac.cod-estab NO-UNDO.
DEFINE variable c-cod-tipo-oper-key LIKE config-operac.cod-tip-operac NO-UNDO.

DEFINE TEMP-TABLE tt-variavel no-undo
    FIELD cod-variavel LIKE config-var-operac.cod-variavel
    FIELD valor-variavel LIKE config-var-operac-regra-cond.cod-val-var.

DEFINE VARIABLE c-cod-var-ini  LIKE config-var-operac.cod-variavel NO-UNDO.
DEFINE VARIABLE c-cod-var-fim  LIKE config-var-operac.cod-variavel NO-UNDO.
DEFINE VARIABLE c-desc-var-ini LIKE config-var-operac.des-variavel NO-UNDO.
DEFINE VARIABLE c-desc-var-fim LIKE config-var-operac.des-variavel NO-UNDO.

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
         HEIGHT             = 6.33
         WIDTH              = 48.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraTTSimulador DBOProgram 
PROCEDURE geraTTSimulador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER TABLE FOR tt-variavel.

    FOR EACH tt-variavel:
        DELETE tt-variavel.
    END.

    FOR EACH {&TableName}
       WHERE {&TableName}.cdn-empresa = i-cod-empresa
         AND {&TableName}.cod-estab = c-cod-estabel
         AND {&TableName}.cod-tip-operac = c-cod-tipo-oper NO-LOCK:

        CREATE tt-variavel.
        ASSIGN tt-variavel.cod-variavel = {&TableName}.cod-variavel.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        &IF "{&mguni_version}" >= "2.071" &THEN
            WHEN "cdn-empresa":U THEN ASSIGN pFieldValue = RowObject.cdn-empresa.
        &ENDIF
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-tip-operac":U THEN ASSIGN pFieldValue = RowObject.cod-tip-operac.
        WHEN "cod-variavel":U THEN ASSIGN pFieldValue = RowObject.cod-variavel.
        WHEN "des-variavel":U THEN ASSIGN pFieldValue = RowObject.des-variavel.
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
        &IF "{&mguni_version}" < "2.071" &THEN
            WHEN "cdn-empresa":U THEN ASSIGN pFieldValue = RowObject.cdn-empresa.
        &ENDIF
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice ch-var-oper
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo ind-tip-oper
               retorna valor do campo cod-var-oper
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE config-var-operac.cdn-empresa NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE config-var-operac.cod-estab NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tipo-oper LIKE config-var-operac.cod-tip-operac NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-var-oper LIKE config-var-operac.cod-variavel NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.cdn-empresa
           pcod-estabel = RowObject.cod-estab
           pcod-tipo-oper = RowObject.cod-tip-operac
           pcod-var-oper = RowObject.cod-variavel.

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
  Purpose:     Reposiciona registro com base no ¡ndice ch-var-oper
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo ind-tip-oper
               recebe valor do campo cod-var-oper
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE config-var-operac.cdn-empresa NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE config-var-operac.cod-estab NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tipo-oper LIKE config-var-operac.cod-tip-operac NO-UNDO.
    DEFINE INPUT PARAMETER pcod-var-oper LIKE config-var-operac.cod-variavel NO-UNDO.

    FIND FIRST bfconfig-var-operac WHERE 
        bfconfig-var-operac.cdn-empresa = pep-codigo AND 
        bfconfig-var-operac.cod-estab = pcod-estabel AND 
        bfconfig-var-operac.cod-tip-operac = pcod-tipo-oper AND 
        bfconfig-var-operac.cod-variavel = pcod-var-oper NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfconfig-var-operac THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfconfig-var-operac)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToconfig-operac DBOProgram 
PROCEDURE linkToconfig-operac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pHandle as handle no-undo.

run getKey in pHandle (output i-cod-empresa, 
                       output c-cod-estabel, 
                       OUTPUT c-cod-tipo-oper).

return "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodigo DBOProgram 
PROCEDURE openQueryCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                               WHERE {&TableName}.cdn-empresa     = i-cod-empresa-key  
                                 AND {&TableName}.cod-estab   = c-cod-estabel-key  
                                 AND {&TableName}.cod-tip-operac = c-cod-tipo-oper-key
                                 AND {&TableName}.cod-variavel >= c-cod-var-ini 
                                 AND {&TableName}.cod-variavel <= c-cod-var-fim INDEXED-REPOSITION.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDescricao DBOProgram 
PROCEDURE openQueryDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                               WHERE {&TableName}.cdn-empresa     = i-cod-empresa-key  
                                 AND {&TableName}.cod-estab   = c-cod-estabel-key  
                                 AND {&TableName}.cod-tip-operac = c-cod-tipo-oper-key
                                 AND {&TableName}.des-variavel >= c-desc-var-ini 
                                 AND {&TableName}.des-variavel <= c-desc-var-fim INDEXED-REPOSITION.

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

    return "OK":U.               
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOperacao DBOProgram 
PROCEDURE openQueryOperacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
        WHERE {&TableName}.cdn-empresa = i-cod-empresa 
          AND {&TableName}.cod-estab = c-cod-estabel 
          AND {&TableName}.cod-tip-operac = c-cod-tipo-oper NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodigo DBOProgram 
PROCEDURE setConstraintCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-ep-codigo LIKE config-var-operac.cdn-empresa     NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estab LIKE config-var-operac.cod-estab     NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-oper  LIKE config-var-operac.cod-tip-operac NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-ini   LIKE config-var-operac.cod-variavel  NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-fim   LIKE config-var-operac.cod-variavel  NO-UNDO.

    ASSIGN i-cod-empresa-key   = p-ep-codigo
           c-cod-estabel-key   = p-cod-estab
           c-cod-tipo-oper-key = p-cod-oper
           c-cod-var-ini       = p-cod-ini
           c-cod-var-fim       = p-cod-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDescricao DBOProgram 
PROCEDURE setConstraintDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-ep-codigo LIKE config-var-operac.cdn-empresa.
    DEFINE INPUT PARAMETER p-cod-estab LIKE config-var-operac.cod-estab.
    DEFINE INPUT PARAMETER p-cod-oper  LIKE config-var-operac.cod-tip-operac.
    DEFINE INPUT PARAMETER p-desc-ini  LIKE config-var-operac.des-variavel NO-UNDO.
    DEFINE INPUT PARAMETER p-desc-fim  LIKE config-var-operac.des-variavel NO-UNDO.

    ASSIGN i-cod-empresa-key   = p-ep-codigo
           c-cod-estabel-key   = p-cod-estab
           c-cod-tipo-oper-key = p-cod-oper 
           c-desc-var-ini      = p-desc-ini
           c-desc-var-fim      = p-desc-fim.

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
    
    IF pType = "Create" THEN DO:

        FIND FIRST bfconfig-var-operac NO-LOCK 
             WHERE bfconfig-var-operac.cdn-empresa = RowObject.cdn-empresa
               AND bfconfig-var-operac.cod-estab = RowObject.cod-estab
               AND bfconfig-var-operac.cod-tip-operac = RowObject.cod-tip-operac
               AND bfconfig-var-operac.cod-variavel =  RowObject.cod-variavel NO-ERROR.
        IF AVAIL bfconfig-var-operac THEN DO:

              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-variavel AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Vari vel" *}
              ASSIGN c-lbl-liter-variavel = TRIM(RETURN-VALUE).
              {method/svc/errors/inserr.i &ErrorNumber="1"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-lbl-liter-variavel"}
                    
        END.

        IF RowObject.cod-variavel = "" THEN DO:

            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-variavel-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Vari vel" *}
            ASSIGN c-lbl-liter-variavel-2 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="17677"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-variavel-2"}

        END.
        
    END.

    IF pType = "Create" OR pType = "Update" THEN DO:

        IF RowObject.des-variavel = "" THEN DO:

            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-descricao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Descri‡Æo" *}
            ASSIGN c-lbl-liter-descricao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="17677"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-descricao"}

        END.

    END.    

    IF pType = "Delete" THEN DO:

        FIND FIRST config-var-operac-regra-cond NO-LOCK 
             WHERE config-var-operac-regra-cond.cdn-empresa = RowObject.cdn-empresa
               AND config-var-operac-regra-cond.cod-estab = RowObject.cod-estab
               AND config-var-operac-regra-cond.cod-tip-operac = RowObject.cod-tip-operac
               AND config-var-operac-regra-cond.cod-variavel =  RowObject.cod-variavel NO-ERROR.
        IF AVAIL config-var-operac-regra-cond THEN DO:

            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-variavel-3 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Vari vel" *}
            ASSIGN c-lbl-liter-variavel-3 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-condicaoregra AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Condi‡Æo/Regra" *}
            ASSIGN c-lbl-liter-condicaoregra = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-merge-variavelcondicaoregra AS CHARACTER NO-UNDO.
            ASSIGN c-lbl-merge-variavelcondicaoregra = c-lbl-liter-variavel-3 + "~~" + c-lbl-liter-condicaoregra.
            {method/svc/errors/inserr.i &ErrorNumber="5"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-lbl-merge-variavelcondicaoregra"}

        END.

    END.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

