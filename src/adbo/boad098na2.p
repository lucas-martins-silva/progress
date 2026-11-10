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
{include/i-prgvrs.i BOAD098NA2 2.00.00.007 } /*** "010007" 07/02/2024 11:19:50  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOAD098NA2 MUT}
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
&GLOBAL-DEFINE DBOName BOAD098NA2
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName emitente
&GLOBAL-DEFINE TableLabel Cliente/Fornecedor
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE KeyField1 cod-emitente  /*:T Informar os campos da chave quando o Progress n’o conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m²todo Receive Message) */
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

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
{adbo/boad098na2.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Defini»’o das variÿveis para a setConstraintCGC */

DEF VAR c-cgc-ini              AS CHAR NO-UNDO.
DEF VAR c-cgc-fim              AS CHAR NO-UNDO.
                                
/* Defini»’o das variÿveis para a setConstraintCodEmitente */

DEF VAR i-cod-emitente-ini     AS INT  NO-UNDO.
DEF VAR i-cod-emitente-fim     AS INT  NO-UNDO.

/* Defini»’o das variÿveis para a setConstraintGrupo */
                                
DEF VAR i-cod-gr-forn-ini      AS INT  NO-UNDO.
DEF VAR i-cod-gr-forn-fim      AS INT  NO-UNDO.
                                
/* Defini»’o das variÿveis para a setConstraintNomeAbrev */

DEF VAR c-nome-abrev-ini       AS CHAR NO-UNDO.
DEF VAR c-nome-abrev-fim       AS CHAR NO-UNDO.

/* Defini»’o das variÿveis para a setConstraintNomeEmitente */
                                
DEF VAR c-nome-emit-ini        AS CHAR NO-UNDO.
DEF VAR c-nome-emit-fim        AS CHAR NO-UNDO.

/* Defini»’o das variÿveis para a setConstraintNomeMatriz */

DEF VAR c-nome-matriz-ini      AS CHAR NO-UNDO.
DEF VAR c-nome-matriz-fim      AS CHAR NO-UNDO.

/* Defini»’o das variÿveis para a setConstraintIniciaCom */

DEF VAR c-iniciacom             AS CHAR NO-UNDO.
DEF VAR i-opcao-iniciacom       AS INT  NO-UNDO.

/*Defini‡Æo de variavel para listar todos os emitentes*/
DEF VAR l-todos-emitentes       AS LOG  NO-UNDO INITIAL "NO".
define temp-table RowErrorsFrotas no-undo
    field ErrorSequence    as integer
    field ErrorNumber      as integer
    field ErrorDescription as character
    field ErrorParameters  as character
    field ErrorType        as character
    field ErrorHelp        as character
    field ErrorSubType     as character.


/* utilizadas para validar regra de times */
DEFINE TEMP-TABLE ttAccount NO-UNDO
    FIELD cod_pessoa_erp   AS CHARACTER
    FIELD num_id_pessoa    AS INTEGER.

DEFINE TEMP-TABLE tt-reg_cta_erp NO-UNDO
    FIELD cod_mic_reg AS CHARACTER.

DEFINE TEMP-TABLE tt-cta_canal_clien NO-UNDO
    FIELD cod_pessoa_erp AS CHARACTER.
/* utilizadas para validar regra de times */

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cgc":U THEN ASSIGN pFieldValue = RowObject.cgc.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nome-emit":U THEN ASSIGN pFieldValue = RowObject.nome-emit.
        WHEN "nome-matriz":U THEN ASSIGN pFieldValue = RowObject.nome-matriz.
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-gr-forn":U THEN ASSIGN pFieldValue = RowObject.cod-gr-forn.
        WHEN "identific":U THEN ASSIGN pFieldValue = RowObject.identific.
        WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.
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
               retorna valor do campo cod-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE emitente.cod-emitente NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-emitente = RowObject.cod-emitente.

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
  Purpose:     Reposiciona registro com base no ¡ndice codigo
  Parameters:  
               recebe valor do campo cod-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-emitente LIKE emitente.cod-emitente NO-UNDO.

    FIND FIRST bfemitente WHERE 
        bfemitente.cod-emitente = pcod-emitente NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfemitente THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfemitente)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCGC DBOProgram 
PROCEDURE openQueryCGC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF l-todos-emitentes THEN DO:
        OPEN QUERY {&QueryName} FOR EACH emitente WHERE
                            emitente.cgc >= c-cgc-ini AND
                            emitente.cgc <= c-cgc-fim 
                            NO-LOCK
                            BY emitente.cgc
                            BY emitente.cod-emitente
                            INDEXED-REPOSITION.
        RETURN "OK":U.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH emitente WHERE
                                emitente.cgc >= c-cgc-ini AND
                                emitente.cgc <= c-cgc-fim AND
                                emitente.identific <> 1
                                NO-LOCK
                                BY emitente.cgc
                                BY emitente.cod-emitente
                                INDEXED-REPOSITION.
        RETURN "OK":U.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodEmitente DBOProgram 
PROCEDURE openQueryCodEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF l-todos-emitentes THEN DO:
        OPEN QUERY {&QueryName} FOR EACH emitente NO-LOCK WHERE
                            emitente.cod-emitente >= i-cod-emitente-ini AND
                            emitente.cod-emitente <= i-cod-emitente-fim 
                            BY emitente.cod-emitente
                            BY emitente.nome-abrev
                            INDEXED-REPOSITION.
        RETURN "OK":U.
    END.
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH emitente NO-LOCK WHERE
                                emitente.cod-emitente >= i-cod-emitente-ini AND
                                emitente.cod-emitente <= i-cod-emitente-fim AND
                                emitente.identific    > 1
                                BY emitente.cod-emitente
                                BY emitente.nome-abrev
                                INDEXED-REPOSITION.
        RETURN "OK":U.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryGrupo DBOProgram 
PROCEDURE openQueryGrupo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF l-todos-emitentes THEN DO:
        OPEN QUERY {&QueryName} FOR EACH emitente WHERE
                            emitente.cod-gr-forn >= i-cod-gr-forn-ini AND
                            emitente.cod-gr-forn <= i-cod-gr-forn-fim 
                            NO-LOCK
                            BY emitente.cod-gr-forn
                            BY emitente.cod-emitente
                            INDEXED-REPOSITION.
        RETURN "OK":U.
    END.

    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH emitente WHERE
                                emitente.cod-gr-forn >= i-cod-gr-forn-ini AND
                                emitente.cod-gr-forn <= i-cod-gr-forn-fim AND
                                emitente.identific   <> 1
                                NO-LOCK
                                BY emitente.cod-gr-forn
                                BY emitente.cod-emitente
                                INDEXED-REPOSITION.
        RETURN "OK":U.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryIniciaCom DBOProgram 
PROCEDURE openQueryIniciaCom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF l-todos-emitentes THEN DO:
        IF i-opcao-iniciacom = 1 THEN
            OPEN QUERY {&QueryName} FOR EACH emitente
                WHERE emitente.nome-emit BEGINS c-iniciacom
                NO-LOCK
                BY emitente.nome-emit INDEXED-REPOSITION.
        ELSE
            OPEN QUERY {&QueryName} FOR EACH emitente
                WHERE emitente.nome-abrev BEGINS c-iniciacom
                NO-LOCK
                BY emitente.nome-abrev INDEXED-REPOSITION.

        RETURN "OK":U.
    END.

    ELSE DO:
        IF i-opcao-iniciacom = 1 THEN
            OPEN QUERY {&QueryName} FOR EACH emitente
                WHERE emitente.nome-emit BEGINS c-iniciacom
                AND   emitente.identific <> 1
                NO-LOCK
                BY emitente.nome-emit INDEXED-REPOSITION.
        ELSE
            OPEN QUERY {&QueryName} FOR EACH emitente
                WHERE emitente.nome-abrev BEGINS c-iniciacom
                AND   emitente.identific <> 1
                NO-LOCK
                BY emitente.nome-abrev INDEXED-REPOSITION.
        
        RETURN "OK":U.
    END.

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
    OPEN QUERY qr{&tableName} FOR EACH {&tableName} 
       NO-LOCK
       INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNomeAbrev DBOProgram 
PROCEDURE openQueryNomeAbrev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF l-todos-emitentes THEN DO:
        OPEN QUERY {&QueryName} FOR EACH emitente NO-LOCK WHERE
                            emitente.nome-abrev >= c-nome-abrev-ini AND
                            emitente.nome-abrev <= c-nome-abrev-fim 
                            BY nome-abrev
                            BY cod-emitente
                            INDEXED-REPOSITION.
        RETURN "OK":U.
    END.
    
    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH emitente NO-LOCK WHERE
                                emitente.nome-abrev >= c-nome-abrev-ini AND
                                emitente.nome-abrev <= c-nome-abrev-fim AND
                                emitente.identific  > 1
                                BY nome-abrev
                                BY cod-emitente
                                INDEXED-REPOSITION.
        RETURN "OK":U.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNomeEmitente DBOProgram 
PROCEDURE openQueryNomeEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF l-todos-emitentes THEN DO:
        OPEN QUERY {&QueryName} FOR EACH emitente WHERE
                            emitente.nome-emit >= c-nome-emit-ini AND
                            emitente.nome-emit <= c-nome-emit-fim 
                            NO-LOCK
                            BY emitente.nome-emit
                            BY emitente.cod-emitente
                            INDEXED-REPOSITION.
        RETURN "OK":U.
    END.

    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH emitente WHERE
                                emitente.nome-emit >= c-nome-emit-ini AND
                                emitente.nome-emit <= c-nome-emit-fim AND
                                emitente.identific <> 1
                                NO-LOCK
                                BY emitente.nome-emit
                                BY emitente.cod-emitente
                                INDEXED-REPOSITION.
        RETURN "OK":U.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNomeMatriz DBOProgram 
PROCEDURE openQueryNomeMatriz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF l-todos-emitentes THEN DO:
        OPEN QUERY {&QueryName} FOR EACH emitente WHERE
                            emitente.nome-matriz >= c-nome-matriz-ini AND
                            emitente.nome-matriz <= c-nome-matriz-fim 
                            NO-LOCK
                            BY emitente.nome-matriz
                            BY emitente.cod-emitente
                            INDEXED-REPOSITION.
        RETURN "OK":U.
    END.

    ELSE DO:
        OPEN QUERY {&QueryName} FOR EACH emitente WHERE
                                emitente.nome-matriz >= c-nome-matriz-ini AND
                                emitente.nome-matriz <= c-nome-matriz-fim AND
                                emitente.identific > 1
                                NO-LOCK
                                BY emitente.nome-matriz
                                BY emitente.cod-emitente
                                INDEXED-REPOSITION.
        RETURN "OK":U.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCGC DBOProgram 
PROCEDURE setConstraintCGC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cgc-ini AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-cgc-fim AS CHAR NO-UNDO.

    ASSIGN c-cgc-ini = p-cgc-ini
           c-cgc-fim = p-cgc-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodEmitente DBOProgram 
PROCEDURE setConstraintCodEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-emitente-ini AS INT NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-emitente-fim AS INT NO-UNDO.

    ASSIGN i-cod-emitente-ini = p-cod-emitente-ini
           i-cod-emitente-fim = p-cod-emitente-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintGrupo DBOProgram 
PROCEDURE setConstraintGrupo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-gr-forn-ini AS INT NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-gr-forn-fim AS INT NO-UNDO.

    ASSIGN i-cod-gr-forn-ini = p-cod-gr-forn-ini
           i-cod-gr-forn-fim = p-cod-gr-forn-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintIniciaCom DBOProgram 
PROCEDURE setConstraintIniciaCom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-iniciacom       AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-opcao-iniciacom AS INT  NO-UNDO.
    
    ASSIGN c-iniciacom    = p-iniciacom
        i-opcao-iniciacom = p-opcao-iniciacom.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNomeAbrev DBOProgram 
PROCEDURE setConstraintNomeAbrev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-nome-abrev-ini AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-nome-abrev-fim AS CHAR NO-UNDO.

    ASSIGN c-nome-abrev-ini = p-nome-abrev-ini
           c-nome-abrev-fim = p-nome-abrev-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNomeEmitente DBOProgram 
PROCEDURE setConstraintNomeEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-nome-emit-ini AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-nome-emit-fim AS CHAR NO-UNDO.

    ASSIGN c-nome-emit-ini = p-nome-emit-ini
           c-nome-emit-fim = p-nome-emit-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNomeMatriz DBOProgram 
PROCEDURE setConstraintNomeMatriz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-nome-matriz-ini AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-nome-matriz-fim AS CHAR NO-UNDO.

    ASSIGN c-nome-matriz-ini = p-nome-matriz-ini
           c-nome-matriz-fim = p-nome-matriz-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE todosEmitentes DBOProgram 
PROCEDURE todosEmitentes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN l-todos-emitentes = YES.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDeleteFrotas DBOProgram 
PROCEDURE validateDeleteFrotas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define variable h-abapi008 as handle  no-undo.
define variable iErro      as integer no-undo.
define variable lValida    as logical no-undo.
define variable i-cont     as integer no-undo.

assign lValida = no.
do i-cont = 1 to 4:
    run cdp/cd9902.p (input i-cont).
    if return-value = "OK":U then do:
        assign lValida = yes.
        leave.
    end.
end.
if lValida then do:
    /** Passa o rowid para API de Frotas **/
    run abp/abapi008.p persistent set h-abapi008 (input RowObject.r-rowid).
    /** Valida‡äes de Frotas **/
    run validateEmitente in h-abapi008 (RowObject.cod-emitente).
    if return-value = "NOK":U then do:
        empty temp-table RowErrorsFrotas.
        /** Busca os erros ocorridos em frotas **/
        run getRowErrors in h-abapi008 (output table RowErrorsFrotas).
        assign iErro = 0.
        /** Se ocorreram erros noproduto padrÆo, busca a £ltima sequˆncia **/
        for last RowErrors no-lock:
            assign iErro = RowErrors.ErrorSequence.
        end.
        /** Percorre os erros ocorridos em frotas **/
        for each RowErrorsFrotas no-lock:
            /** Cria os erros no produto padrÆo **/
            create RowErrors.
            buffer-copy RowErrorsFrotas except ErrorSequence to RowErrors
                assign RowErrors.ErrorSequence = iErro + 1
                       iErro                   = RowErrors.ErrorSequence.
        end.
        empty temp-table RowErrorsFrotas.
    end.
    /** Elimina a API da mem¢ria **/
    if valid-handle(h-abapi008) then
        delete procedure h-abapi008.
end.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReturnCustomerSalesChannels DBOProgram 
PROCEDURE ReturnCustomerSalesChannels :
/*¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸
    Retorna todas as Contas relacionadas do 
    Canal de Cliente passado como parƒmetro;
¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸*/    

    DEFINE INPUT PARAM cod_canal_cliente AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-cta_canal_clien.

    EMPTY TEMP-TABLE tt-cta_canal_clien.

    FOR EACH emitente NO-LOCK WHERE emitente.cod-canal-venda = integer(cod_canal_cliente):
        CREATE tt-cta_canal_clien.
        ASSIGN tt-cta_canal_clien.cod_pessoa_erp = string(emitente.cod-emitente).
    END.
  
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReturnsCustumerListRegion DBOProgram 
PROCEDURE ReturnsCustumerListRegion :
/*¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸
  Retorna todas as contas de n¡vel especifico que estÆo 
  amarradas a regiÆo passada passado como parƒmetro;
¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸*/
    
    DEFINE INPUT  PARAM pc-cod_regiao_erp    AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pi-idi_niv_acess     AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR ttAccount.

    DEFINE VARIABLE pi-nivel-acess AS INTEGER     NO-UNDO.
    DEFINE VARIABLE h-distEmitente AS HANDLE      NO-UNDO.

    IF VALID-HANDLE(h-distEmitente) THEN
        DELETE PROCEDURE h-distEmitente.

    RUN dibo/bodi275.p PERSISTENT SET h-distEmitente.

    FOR EACH emitente NO-LOCK WHERE emitente.nome-mic-reg = pc-cod_regiao_erp :
        RUN ReturnAcesUserEms IN h-distEmitente (INPUT emitente.cod-emitente, OUTPUT pi-nivel-acess).

        IF pi-nivel-acess = pi-idi_niv_acess THEN DO:
            CREATE ttAccount.
            ASSIGN ttAccount.cod_pessoa_erp = STRING(emitente.cod-emitente).
        END.
    END.

    IF VALID-HANDLE(h-distEmitente) THEN
        DELETE PROCEDURE h-distEmitente.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReturnAccountRegion DBOProgram 
PROCEDURE ReturnAccountRegion :
/*¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸
  Retorna a Micro-RegiÆo da Conta passada como parƒmetro
¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸¸*/
    
    DEFINE INPUT  PARAM pc-cod_pessoa_erp  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-reg_cta_erp.

    DEFINE VARIABLE h-microReg AS HANDLE      NO-UNDO.

    IF VALID-HANDLE(h-microReg) THEN
        DELETE PROCEDURE h-microReg.

    RUN dibo/bodi107na.p PERSISTENT SET h-microReg.

    FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = INTEGER(pc-cod_pessoa_erp) NO-ERROR.
    IF AVAIL emitente THEN DO:
        RUN ReturnAllRegion IN h-microReg (INPUT emitente.nome-mic-reg, OUTPUT TABLE tt-reg_cta_erp ).
    END.

    IF VALID-HANDLE(h-microReg) THEN
        DELETE PROCEDURE h-microReg.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
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

    if pType = "Delete":U then
        run validateDeleteFrotas in this-procedure.
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

