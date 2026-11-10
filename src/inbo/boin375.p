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
{include/i-prgvrs.i BOIN375 2.00.00.035 } /*** "010035" 26/10/2023 09:43:23  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin375 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ² um programa PROGRESS
                 que cont²m a l½gica de neg½cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini»’o ---*/
&GLOBAL-DEFINE DBOName ref-item
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName ref-item
&GLOBAL-DEFINE TableLabel ref-item
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE KeyField1 cod-refer /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField2 it-codigo /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
{inbo/boin375.i RowObject}
{java/boRest.i}

/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Vari veis necess rias aos setConstraint's */

define variable c-cod-refer-ini  as character no-undo.
define variable c-cod-refer-fim  as character no-undo.
define variable c-it-codigo      as character no-undo.
define variable c-desc-refer-ini as character no-undo.
define variable c-desc-refer-fim as character no-undo.
define variable c-it-codigo-ini as character no-undo.
define variable c-it-codigo-fim as character no-undo.

DEFINE VARIABLE lIntCRM11 AS LOGICAL NO-UNDO INITIAL FALSE.
RUN utp/ut-crm11.p (OUTPUT lIntCRM11) .


DEFINE TEMP-TABLE RowObjectExtra NO-UNDO
    FIELD r-Rowid   AS ROWID
    FIELD descricao LIKE referencia.descricao.

DEFINE VARIABLE hDBOproxy AS HANDLE      NO-UNDO.


DEFINE TEMP-TABLE tt-refer-auxi no-undo
       FIELD it-codigo       AS CHAR
       FIELD cod-refer       AS CHAR  format "x(12)"
       INDEX it-refer IS PRIMARY cod-refer it-codigo.

DEFINE TEMP-TABLE RowErrorsEAI NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

DEFINE VARIABLE h-ut-integration AS HANDLE      NO-UNDO.

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
         HEIGHT             = 31.58
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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCopyBuffer2TT DBOProgram 
PROCEDURE afterCopyBuffer2TT :
/*------------------------------------------------------------------------------
Purpose: Copia informaï¿½ï¿½es extras para a RowObjectExtra.
Parameters: 
Notes: 
------------------------------------------------------------------------------*/
    CREATE RowObjectExtra.
    ASSIGN RowObjectExtra.r-Rowid = ROWID({&TableName}).
    
    FOR FIRST referencia FIELDS(cod-refer descricao) NO-LOCK
        WHERE referencia.cod-refer = {&TableName}.cod-refer:
        ASSIGN RowObjectExtra.descricao = referencia.descricao.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &IF '{&mgscm_version}' >= '2.06B' &THEN
    IF CONNECTED('mgscm') THEN DO:
        IF NOT VALID-HANDLE(hDBOproxy) THEN
            RUN wmp/wmprx051.p PERSISTENT SET hDBOproxy.
    
        RUN ReplicaReferenciaItem IN hDBOproxy(INPUT rowObject.it-codigo,
                                               INPUT rowObject.cod-refer,
                                               OUTPUT TABLE RowErrors).

        RUN destroy IN hDBOproxy.
    END.
    &ENDIF
    
    IF NOT VALID-HANDLE(h-ut-integration) THEN
        RUN utp/ut-integration.p PERSISTENT SET h-ut-integration.

    /*Integra‡Æo EAI*/
    run eai-integration in h-ut-integration (INPUT "ItemReference",       /* Nome da transa‡Æo     */
                                             INPUT ROWID({&TableName}),   /* Registro da transa‡Æo */
                                             INPUT "CREATE",              /* Evento da transa‡Æo   */
                                             OUTPUT TABLE RowErrorsEAI).  /* Erros da transa‡Æo    */ 

    IF CAN-FIND(FIRST RowErrorsEAI) THEN DO:
        FOR EACH RowErrorsEAI:
            CREATE RowErrors.
            BUFFER-COPY RowErrorsEAI TO RowErrors.
        END.
    END.

    DELETE PROCEDURE h-ut-integration.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &IF '{&mgscm_version}' >= '2.06B' &THEN
    IF CONNECTED('mgscm') THEN DO: 
        IF NOT VALID-HANDLE(hDBOproxy) THEN
            RUN wmp/wmprx051.p PERSISTENT SET hDBOproxy.

        RUN eliminaReferenciaItem IN hDBOproxy(INPUT rowObject.it-codigo,
                                               INPUT rowObject.cod-refer,
                                               OUTPUT TABLE RowErrors).

        RUN destroy IN hDBOproxy.
    END.
    &ENDIF
    
    IF NOT VALID-HANDLE(h-ut-integration) THEN
        RUN utp/ut-integration.p PERSISTENT SET h-ut-integration.

    /*Integra‡Æo EAI*/
    run eai-integration in h-ut-integration (INPUT "ItemReference",       /* Nome da transa‡Æo     */
                                             INPUT ROWID({&TableName}),      /* Registro da transa‡Æo */
                                             INPUT "DELETE",              /* Evento da transa‡Æo   */
                                             OUTPUT TABLE RowErrorsEAI).  /* Erros da transa‡Æo    */ 

    IF CAN-FIND(FIRST RowErrorsEAI) THEN DO:
        FOR EACH RowErrorsEAI:
            CREATE RowErrors.
            BUFFER-COPY RowErrorsEAI TO RowErrors.
        END.
    END.

    DELETE PROCEDURE h-ut-integration.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaReferenciaPadrao DBOProgram 
PROCEDURE buscaReferenciaPadrao :
/*------------------------------------------------------------------------------
  Purpose:    Caso haja relacionamente de item x referencia ser  retornada a 
              primeira referˆncia do relacionamento caso o item nÆo possua referˆncias 
              cadastradas ser  retornada a primeira referˆncia da tabela referencia.
  Parameters: ipar1:p-it-codigo:C¢digo Item
              opar2:p-cod-refer:C¢digo Referˆncia
              
-----------------------------------------------------------------------------*/
    def input  parameter p-it-codigo LIKE ref-item.it-codigo no-undo.
    def OUTPUT parameter p-cod-refer LIKE ref-item.cod-refer no-undo.
   
    FIND FIRST ref-item 
         WHERE ref-item.it-codigo = p-it-codigo NO-LOCK NO-ERROR.
    IF AVAIL ref-item THEN
       ASSIGN p-cod-refer = ref-item.cod-refer.
    ELSE DO:
        FIND FIRST referencia NO-LOCK NO-ERROR.
        IF AVAIL referencia THEN
             ASSIGN p-cod-refer = referencia.cod-refer.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaListaReferenciasItem DBOProgram 
PROCEDURE carregaListaReferenciasItem :
/*------------------------------------------------------------------------------
  Purpose:    Traz as referˆncias de um item c/ tipo de controle por referˆncia. 
  Parameters: ipar1:p-it-codigo:C¢digo Item 
              ipar2:p-lista:Lista de referˆncias do item  
------------------------------------------------------------------------------*/
    def input parameter p-it-codigo as char no-undo.                
    def output parameter p-lista    as char no-undo.     

    def var contador as integer no-undo.
    assign  contador = 0
            p-lista  = "".
    for each ref-item fields(it-codigo cod-refer)
        where ref-item.it-codigo = p-it-codigo no-lock:
        assign contador = contador + 1.
        /*** chr(1) estÿ sendo usado como separador pois pode existir valores na base 
             que possuam v­rgulas ***/
        assign p-lista = p-lista + min(p-lista, chr(1)) + ref-item.cod-refer.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItCodigo DBOProgram 
PROCEDURE findItCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo ­ndice, caso n’o ache, retorna
              mensagem de erro padr’o do  EMS
  Parameters: ipar:c-it-codigo:Item  
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter c-it-codigo as char no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToKeyItem (input c-it-codigo).
                 

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo nÊo acha o registro */
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItem DBOProgram 
PROCEDURE findItem :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo ¡ndice, caso nÆo ache, retorna
              mensagem de erro padrÆo do  EMS
  Parameters: ipar1:c-cod-refer:Referˆncia
              ipar2:c-it-codigo:Item  
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter c-it-codigo as char no-undo.
    def input parameter c-cod-refer as char no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToKey (input c-it-codigo,
                 input c-cod-refer).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo n’o acha o registro */
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findReferencia DBOProgram 
PROCEDURE findReferencia :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo ¡ndice, caso nÆo ache, retorna
        mensagem de erro padrÆo do  EMS
  Parameters: ipar1:c-cod-refer:Referˆncia
              ipar2:c-it-codigo:Item  
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter c-cod-refer as char no-undo.
    def input parameter c-it-codigo as char no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToKey (input c-it-codigo,
                 input c-cod-refer).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo n’o acha o registro */
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarListaRef DBOProgram 
PROCEDURE gerarListaRef :
/*------------------------------------------------------------------------------
  Purpose:     Gera uma lista com as refer¼ncias do item
  Parameters:  i - C½digo do Item, o - Lista
  Notes:       
------------------------------------------------------------------------------*/

def input param pit-codigo like ref-item.it-codigo no-undo.
def output param plista    as char.

for each ref-item
    where ref-item.it-codigo = pit-codigo no-lock:
          
    if  plista = "" then
        assign plista = ref-item.cod-refer.
    else
        assign plista = plista + ',' + ref-item.cod-refer.
        
end.        
                                
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-ean":U THEN ASSIGN pFieldValue = RowObject.cod-ean.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "cdd-alt":U THEN ASSIGN pFieldValue = RowObject.cdd-alt.
        WHEN "cdd-comprim":U THEN ASSIGN pFieldValue = RowObject.cdd-comprim.
        WHEN "cdd-larg":U THEN ASSIGN pFieldValue = RowObject.cdd-larg.
        WHEN "cdd-peso-liq":U THEN ASSIGN pFieldValue = RowObject.cdd-peso-liq.
        WHEN "cdd-peso-brut":U THEN ASSIGN pFieldValue = RowObject.cdd-peso-brut.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice ITEM
  Parameters:
               retorna valor dos campos do ­ndice ITEM
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE ref-item.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE ref-item.cod-refer NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo.
    ASSIGN pcod-refer = RowObject.cod-refer.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l½gico
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowObjectExtra DBOProgram 
PROCEDURE getRowObjectExtra :
/*------------------------------------------------------------------------------
Purpose: Retorna a temp-table RowObjectExtra
Parameters: RowObjectExtra - Temp-table com informaï¿½ï¿½es extras
Notes: 
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR RowObjectExtra.
    
    RETURN "OK":U.
    END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ­ndice ITEM
  Parameters:
               recebe valor dos campos do ­ndice ITEM
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE ref-item.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE ref-item.cod-refer NO-UNDO.

    FIND FIRST bfref-item WHERE
        bfref-item.it-codigo = pit-codigo AND
        bfref-item.cod-refer = pcod-refer
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfref-item THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfref-item)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyItem DBOProgram 
PROCEDURE goToKeyItem :
/*------------------------------------------------------------------------------
  Purpose:     Posicionar o registro com base no c½digo do item
  Parameters:  C½digo do Item
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE ref-item.it-codigo NO-UNDO.

    FIND FIRST bfref-item WHERE
        bfref-item.it-codigo = pit-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfref-item THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfref-item)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LinkToItem DBOProgram 
PROCEDURE LinkToItem :
/*------------------------------------------------------------------------------
  Purpose:     Posicionar o registro com base no c½digo do item
  Parameters:  C½digo do Item
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM hDboParent AS HANDLE NO-UNDO.


    RUN getKey IN hDboParent (OUTPUT c-it-codigo).
   
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
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    define input parameter i-abertura as integer no-undo.
       case i-abertura:
           when 1 then
              RUN openQueryStatic (input "CodReferIni":U). 
              
           when 2 then
              RUN openQueryStatic (input "CodReferItCod":U).
           
           when 3 then
              RUN openQueryStatic (input "FiltroCodRefer":U).
           
       end case.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodReferIni DBOProgram 
PROCEDURE openQueryCodReferIni :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela ref-item, 
              dentro de uma faixa de referˆncia inicial. 
        
------------------------------------------------------------------------------*/

    open query {&QUERYNAME} for each {&TABLENAME} where 
                                     {&TABLENAME}.cod-refer >= c-cod-refer-ini
                                      no-lock INDEXED-REPOSITION.
                                          
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodReferItCod DBOProgram 
PROCEDURE openQueryCodReferItCod :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela ref-item, 
              dentro de uma faixa de referˆncia inicial e
              conforme o c¢digo do item. 
     
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where 
                                     {&TABLENAME}.cod-refer >= c-cod-refer-ini and
                                     {&tablename}.it-codigo  = c-it-codigo 
                                      no-lock INDEXED-REPOSITION.

                                          
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroCodRefer DBOProgram 
PROCEDURE openQueryFiltroCodRefer :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela ref-item, 
              dentro de uma faixa de referˆncia inicial e final,
              conforme o c¢digo do item. 
      
------------------------------------------------------------------------------*/
   open query {&QUERYNAME} for each {&TABLENAME} where 
                                    {&tablename}.it-codigo  = c-it-codigo     and
                                    {&TABLENAME}.cod-refer >= c-cod-refer-ini and
                                    {&TABLENAME}.cod-refer <= c-cod-refer-fim
                                     no-lock INDEXED-REPOSITION.

                                          
    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItCodigo DBOProgram 
PROCEDURE openQueryItCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela ref-item, 
              dentro de uma faixa de referˆncia inicial e
              conforme o c¢digo do item. 
     
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where 
                                     {&tablename}.it-codigo  = c-it-codigo 
                                      no-lock INDEXED-REPOSITION.

                                          
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH ref-item NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroDescRefer DBOProgram 
PROCEDURE openQueryFiltroDescRefer :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela referencia, 
              dentro de uma faixa de descri‡Æo de referˆncia inicial e final,
              conforme o c¢digo do item. 
      
------------------------------------------------------------------------------*/
   open query {&QUERYNAME} for each {&TABLENAME} where 
                                    {&tablename}.it-codigo  = c-it-codigo       and
                                    referencia.descricao    >= c-desc-refer-ini and
                                    referencia.descricao    <= c-desc-refer-fim
                                    no-lock INDEXED-REPOSITION.

                                          
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryWMS DBOProgram 
PROCEDURE openQueryWMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
open query {&QUERYNAME} for each {&TABLENAME} where 
                                 {&tablename}.it-codigo >= c-it-codigo-ini and
                                 {&tablename}.it-codigo <= c-it-codigo-fim and
                                 {&TABLENAME}.cod-refer >= c-cod-refer-ini and
                                 {&TABLENAME}.cod-refer <= c-cod-refer-fim
                                  no-lock INDEXED-REPOSITION.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pegaDescricaoReferencia DBOProgram 
PROCEDURE pegaDescricaoReferencia :
/*------------------------------------------------------------------------------
  Purpose:    Atrav‚s do Item (ser for um item com tipo de controle de estoque 
              diferente de referˆncia a descri‡Æo retornar  em branco)
              passado p/ parƒmetro, procura na tabela de Ref-Item 
              (relacionamento) e depois na tabela de referˆncia a descri‡Æo.
  Parameters: ipar1:p-it-codigo:C¢digo Item
              ipar2:p-cod-refer:C¢digo Referˆncia
              opar3:p-descricao:Vari vel que retorna a descri‡Æo da referˆncia   
-----------------------------------------------------------------------------*/
    def input  parameter p-it-codigo as char no-undo.
    def input  parameter p-cod-refer as char no-undo.
    def output parameter p-descricao as char no-undo.

    assign p-descricao = "".

    for each item fields(it-codigo tipo-con-est)
        where item.it-codigo = p-it-codigo NO-LOCK:
        if  item.tipo-con-est = 4 then do: 
            for each ref-item fields(it-codigo cod-refer)
                where ref-item.it-codigo = item.it-codigo
                  and ref-item.cod-refer = p-cod-refer NO-LOCK,
                first referencia FIELDS(cod-refer descricao) 
                    where referencia.cod-refer = ref-item.cod-refer NO-LOCK:
                     assign p-descricao  =  referencia.descricao.
            end.
        end.    
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint1 DBOProgram 
PROCEDURE setConstraint1 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo 
              a referˆncia e o item. 
  Parameters: ipar1:p-cod-refer:Referˆncia
              ipar2:p-item:     Item
     
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    define input parameter p-cod-refer as char no-undo.
    define input parameter p-item      as char no-undo.
    
    run setConstraintCodReferItCod (p-cod-refer,
                                    p-item).
                                    
    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:     Seta as vari veis de controle para queries contendo 
               o item e a referˆncia inicial e final. 
  Parameters:  ipar1:p-it-codigo:    Item
               ipar2:p-cod-refer-ini:Referˆncia Inicial
               ipar3:p-cod-refer-fim:Referˆncia Final
  ------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    define input parameter p-it-codigo     as char no-undo.
    define input parameter p-cod-refer-ini as char no-undo.
    define input parameter p-cod-refer-fim as char no-undo.
    
    run setConstraintFiltroCodRefer (p-it-codigo,
                                     p-cod-refer-ini,
                                     p-cod-refer-fim).
                                    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodReferItCod DBOProgram 
PROCEDURE setConstraintCodReferItCod :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo 
              a referˆncia e o item. 
  Parameters: ipar1:pcod-refer:Referˆncia
              ipar2:pitem:     Item
      
------------------------------------------------------------------------------*/
  define input parameter pcod-refer as char no-undo.
  define input parameter pitem      as char no-undo.
     
     assign c-cod-refer-ini = pcod-refer
            c-it-codigo     = pitem. 
            
     RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroCodRefer DBOProgram 
PROCEDURE setConstraintFiltroCodRefer :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo 
               o item e a referˆncia inicial e final. 
  Parameters:  ipar1:pit-codigo:    Item
               ipar2:pcod-refer-ini:Referˆncia Inicial
               ipar3:pcod-refer-fim:Referˆncia Final
 -----------------------------------------------------------------------------*/
    define input parameter pit-codigo     as char.
    define input parameter pcod-refer-ini as char.
    define input parameter pcod-refer-fim as char.
    
       assign c-it-codigo     = pit-codigo
              c-cod-refer-ini = pcod-refer-ini
              c-cod-refer-fim = pcod-refer-fim.
           
       RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroDescRefer DBOProgram 
PROCEDURE setConstraintFiltroDescRefer :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo 
               o item e a descri‡Æo da referˆncia inicial e final. 
  Parameters:  ipar1:pit-codigo:    Item
               ipar2:pdesc-refer-ini:Descri‡Æo da Referˆncia Inicial
               ipar3:pdesc-refer-fim:Descri‡Æo da Referˆncia Final
 -----------------------------------------------------------------------------*/
    define input parameter pit-codigo      as char.
    define input parameter pdesc-refer-ini as char.
    define input parameter pdesc-refer-fim as char.
    
       assign c-it-codigo      = pit-codigo
              c-desc-refer-ini = pdesc-refer-ini
              c-desc-refer-fim = pdesc-refer-fim.
           
       RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintWMS DBOProgram 
PROCEDURE setConstraintWMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pit-codigo-ini as char no-undo.
    define input parameter pit-codigo-fim as char no-undo.
    define input parameter pcod-refer-ini as char no-undo.
    define input parameter pcod-refer-fim as char no-undo.
    
    assign c-it-codigo-ini = pit-codigo-ini
           c-it-codigo-fim = pit-codigo-fim
           c-cod-refer-ini = pcod-refer-ini
           c-cod-refer-fim = pcod-refer-fim.
        
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida»’o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-msg AS CHAR NO-UNDO.

    DEFINE BUFFER b-ref-estrut FOR ref-estrut.
    DEFINE BUFFER b-est-ref-prod FOR est-ref-prod.
    /*--- Utilize o par³metro pType para identificar quais as valida»„es a serem
          executadas ---*/
    /*--- Os valores poss­veis para o par³metro s’o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav²s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida»„es ---*/

    /*--- Verifica ocorr¼ncia de erros ---*/
    IF pType = "Create" THEN DO:
        IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                    WHERE bf{&tablename}.it-codigo = rowObject.it-codigo AND
                          bf{&TableName}.cod-refer = rowObject.cod-refer) THEN DO:
               {utp/ut-liter.i Referˆncia_do_item *}
              {method/svc/errors/inserr.i
                        &ErrorNumber="8" 
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters=return-value}
                        
        END.
            
    END.

    IF pType = "Delete" THEN DO:
        IF CAN-FIND(FIRST reservas NO-LOCK
                    WHERE reservas.it-codigo = rowObject.it-codigo AND
                          reservas.cod-refer = rowObject.cod-refer) THEN DO:
            {method/svc/errors/inserr.i
                        &ErrorNumber="25901" 
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" }

        END.

        find first b-ref-estrut 
             where b-ref-estrut.it-codigo  = rowObject.it-codigo
             and   b-ref-estrut.cod-ref-it = rowObject.cod-refer
             no-lock no-error.
        if avail b-ref-estrut then do:
           
            {utp/ut-table.i mgind ref-item 1}
            ASSIGN c-msg = RETURN-VALUE + '~~'.
           {utp/ut-table.i mgind ref-estrut 1}
           ASSIGN c-msg = c-msg + RETURN-VALUE.
           
           {method/svc/errors/inserr.i
                        &ErrorNumber="6"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters=c-msg}
           
        end.

        find first b-ref-estrut 
             where b-ref-estrut.es-codigo  = rowObject.it-codigo
             and   b-ref-estrut.cod-ref-es = rowObject.cod-refer
             no-lock no-error.
        if avail b-ref-estrut then do:
            
            {utp/ut-table.i mgind ref-item 1}
            ASSIGN c-msg = RETURN-VALUE + '~~'.
            {utp/ut-table.i mgind ref-estrut 1}
            ASSIGN c-msg = c-msg + RETURN-VALUE.

            {method/svc/errors/inserr.i
                        &ErrorNumber="6"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters=c-msg}
        END.

        find first b-est-ref-prod 
             where b-est-ref-prod.it-codigo = rowObject.it-codigo
             and   b-est-ref-prod.cod-refer = rowObject.cod-refer
         no-lock no-error. 
        if avail b-est-ref-prod then do:
            
            {utp/ut-table.i mgind ref-item 1}
            ASSIGN c-msg = RETURN-VALUE + '~~'.
            {utp/ut-table.i mgind ref-estrut 1}
            ASSIGN c-msg = c-msg + RETURN-VALUE.

            {method/svc/errors/inserr.i
                        &ErrorNumber="6"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters=RETURN-VALUE}
        END.

        find first alternativo 
             where alternativo.al-codigo = rowObject.it-codigo no-lock no-error.
        if  avail alternativo then do:
            find first ref-estrut where
                       ref-estrut.it-codigo  = alternativo.it-codigo and
                       ref-estrut.sequencia  = alternativo.sequencia and
                       ref-estrut.es-codigo  = alternativo.es-codigo and
                       ref-estrut.cod-ref-es = rowObject.cod-refer    no-lock no-error.
            if avail ref-estrut then do:        
                ASSIGN c-msg = rowObject.cod-refer + '~~' + 
                               alternativo.al-codigo + '~~' +
                               alternativo.it-codigo + '~~' +
                               string(alternativo.sequencia) + '~~' +
                               alternativo.es-codigo.
                {method/svc/errors/inserr.i
                        &ErrorNumber="16612"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters=c-msg}
            end.
        END.
        

        IF can-find(first ped-item where 
                       ped-item.it-codigo = rowObject.it-codigo and
                       ped-item.cod-refer = rowobject.cod-refer) THEN DO:
            {method/svc/errors/inserr.i
                        &ErrorNumber="27826"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters=rowObject.it-codigo}
       END.

       /* Integração com o CRM */
        IF lIntCRM11 THEN DO:
            DEFINE VARIABLE h-cd1506crm AS HANDLE NO-UNDO.
            RUN integracoes/adapters/emstocrm/cd1506-crm.p PERSISTENT SET h-cd1506crm.
            RUN validaReferenciaEmUso IN h-cd1506crm (INPUT rowObject.it-codigo,
                                                      INPUT rowObject.cod-refer,
                                                      OUTPUT TABLE rowErrors APPEND).
            DELETE PROCEDURE h-cd1506crm.

            FOR EACH RowErrors
                WHERE RowErrors.errorType = "Internal"
                  AND RowErrors.errorNumber = 10: /*Ultimo Registro posicionado*/
                
                DELETE RowErrors.
            END.

        END.
        /* Integração com o CRM */
   end.


    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram  
PROCEDURE openQueryDefault :
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
                                      
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTRefer DBOProgram 
PROCEDURE criaTTRefer :
/*------------------------------------------------------------------------------
  Purpose:     Gera uma lista com as refer¼ncias do item
  Parameters:  i - C½digo do Item, o - Lista
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-it-codigo as char no-undo.   
def output param TABLE FOR tt-refer-auxi.

   for each ref-item
       Where ref-item.it-codigo = p-it-codigo NO-LOCK:
       create tt-refer-auxi.
       BUFFER-COPY ref-item TO tt-refer-auxi.

   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
