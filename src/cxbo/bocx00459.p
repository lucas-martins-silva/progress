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
{include/i-prgvrs.i BOCX00459 2.00.00.026 } /*** "010026" 07/10/2024 16:59:54 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOCX00459
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName due-nf
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
{cxbo/bocx00459.i RowObject}
{cxbo/bocx00459.i tt-due-nf-faixa}
{cxbo/bocx00459.i tt-due-nf-aux}

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}
{cxbo/bocx00459.i1} /*tt-param-nota, tt-nota-fiscal*/
{cdp/cdapi1004.i1} /* Variaveis usadas na API de Log */

/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE de-cdd-due-ems LIKE due-nf.cdd-due-ems  NO-UNDO.
DEFINE VARIABLE l-fn-due-v3    AS   LOGICAL             NO-UNDO.

ASSIGN l-fn-due-v3 = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-due-v3":U AND funcao.ativo).

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-chave-aces-nf-eletro":U THEN ASSIGN pFieldValue = RowObject.cod-chave-aces-nf-eletro.
        WHEN "cod-estab-proces-export":U THEN ASSIGN pFieldValue = RowObject.cod-estab-proces-export.
        WHEN "cod-estabel-nf":U THEN ASSIGN pFieldValue = RowObject.cod-estabel-nf.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-nota-fisc":U THEN ASSIGN pFieldValue = RowObject.cod-nota-fisc.
        WHEN "cod-proces-export":U THEN ASSIGN pFieldValue = RowObject.cod-proces-export.
        WHEN "cod-serie-nf":U THEN ASSIGN pFieldValue = RowObject.cod-serie-nf.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nom-abrev-clien":U THEN ASSIGN pFieldValue = RowObject.nom-abrev-clien.
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
        WHEN "dat-emis-nf":U THEN ASSIGN pFieldValue = RowObject.dat-emis-nf.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cdd-due-ems":U THEN ASSIGN pFieldValue = RowObject.cdd-due-ems.
        WHEN "cdd-embarq":U THEN ASSIGN pFieldValue = RowObject.cdd-embarq.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cdn-emitente":U THEN ASSIGN pFieldValue = RowObject.cdn-emitente.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-versao-due":U THEN ASSIGN pFieldValue = RowObject.num-versao-due.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice dclncxpr_id1
  Parameters:  
               retorna valor do campo cdd-due-ems
               retorna valor do campo cod-estabel-nf
               retorna valor do campo cod-serie-nf
               retorna valor do campo cod-nota-fisc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdd-due-ems LIKE due-nf.cdd-due-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel-nf LIKE due-nf.cod-estabel-nf NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-serie-nf LIKE due-nf.cod-serie-nf NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-nota-fisc LIKE due-nf.cod-nota-fisc NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdd-due-ems = RowObject.cdd-due-ems
           pcod-estabel-nf = RowObject.cod-estabel-nf
           pcod-serie-nf = RowObject.cod-serie-nf
           pcod-nota-fisc = RowObject.cod-nota-fisc.

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
  Purpose:     Reposiciona registro com base no ¡ndice dclncxpr_id1
  Parameters:  
               recebe valor do campo cdd-due-ems
               recebe valor do campo cod-estabel-nf
               recebe valor do campo cod-serie-nf
               recebe valor do campo cod-nota-fisc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdd-due-ems LIKE due-nf.cdd-due-ems NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel-nf LIKE due-nf.cod-estabel-nf NO-UNDO.
    DEFINE INPUT PARAMETER pcod-serie-nf LIKE due-nf.cod-serie-nf NO-UNDO.
    DEFINE INPUT PARAMETER pcod-nota-fisc LIKE due-nf.cod-nota-fisc NO-UNDO.

    FIND FIRST bfdue-nf WHERE 
        bfdue-nf.cdd-due-ems = pcdd-due-ems AND 
        bfdue-nf.cod-estabel-nf = pcod-estabel-nf AND 
        bfdue-nf.cod-serie-nf = pcod-serie-nf AND 
        bfdue-nf.cod-nota-fisc = pcod-nota-fisc NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdue-nf THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdue-nf)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyNF DBOProgram 
PROCEDURE goToKeyNF :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice dclncxpr_ix2
  Parameters:  
               recebe valor do campo cod-estabel-nf
               recebe valor do campo cod-serie-nf
               recebe valor do campo cod-nota-fisc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel-nf LIKE due-nf.cod-estabel-nf NO-UNDO.
    DEFINE INPUT PARAMETER pcod-serie-nf   LIKE due-nf.cod-serie-nf   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-nota-fisc  LIKE due-nf.cod-nota-fisc  NO-UNDO.

    FIND FIRST bfdue-nf 
         WHERE bfdue-nf.cod-estabel-nf = pcod-estabel-nf 
           AND bfdue-nf.cod-serie-nf = pcod-serie-nf 
           AND bfdue-nf.cod-nota-fisc = pcod-nota-fisc NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdue-nf THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdue-nf)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDue DBOProgram 
PROCEDURE openQueryByDue :
/*------------------------------------------------------------------------------
  Purpose: Realiza a abertura da query conforme parƒmetros recebidos pela 
           execu‡Æo da setConstraintByDue    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cdd-due-ems = de-cdd-due-ems 
                               NO-LOCK INDEXED-REPOSITION.    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNF DBOProgram 
PROCEDURE openQueryByNF :
/*------------------------------------------------------------------------------
  Purpose: Realiza a abertura da query conforme parƒmetros recebidos pela 
           execu‡Æo da setConstraintByDUE, muda apenas a ordena‡Æo dos registros    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cdd-due-ems = de-cdd-due-ems 
                               NO-LOCK BY {&TABLENAME}.cod-estabel-nf
                                       BY {&TABLENAME}.cod-serie-nf
                                       BY {&TABLENAME}.cod-nota-fisc 
                                       BY {&TABLENAME}.dat-emis-nf INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByProcExp DBOProgram 
PROCEDURE openQueryByProcExp :
/*------------------------------------------------------------------------------
  Purpose: Realiza a abertura da query conforme parƒmetros recebidos pela 
           execu‡Æo da setConstraintByDUE, muda apenas a ordena‡Æo dos registros    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cdd-due-ems = de-cdd-due-ems 
                               NO-LOCK BY {&TABLENAME}.cod-estab-proces-export
                                       BY {&TABLENAME}.cod-proces-export INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query com todos os registros da tabela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaNotasVinculadas DBOProgram 
PROCEDURE piBuscaNotasVinculadas :
/*------------------------------------------------------------------------------
  Purpose: Busca as notas a vinculadas na DU-E com base nas informa‡äes do filtro   
  Parameters:  pcdd-due-ems : Vari vel com o n£mero da DU-E - (input) (vari vel) 
               pl-filtro-vincul : Vari vel que indica se o filtro foi usado (input) (vari vel)
               tt-param-nota : Temp-table com os parƒmetros de busca - (input) (temp-table)
               tt-due-nf-aux : Temp-table com as notas da DU-E - (output)(temp-table)              
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pcdd-due-ems LIKE due-nf.cdd-due-ems NO-UNDO.
    DEFINE INPUT  PARAM pl-filtro-vincul AS LOGICAL          NO-UNDO. 
    DEFINE INPUT  PARAM TABLE FOR tt-param-nota.
    DEFINE OUTPUT PARAM TABLE FOR tt-due-nf-aux.

    DEFINE VARIABLE iRowsReturned AS INTEGER     NO-UNDO.

    EMPTY TEMP-TABLE tt-due-nf-aux NO-ERROR.

    RUN setConstraintByDue (INPUT pcdd-due-ems).
    RUN openQueryStatic (INPUT "ByDue":U) NO-ERROR.
    RUN getBatchRecords (INPUT ?,
                         INPUT ?,
                         INPUT 99999,
                         OUTPUT iRowsReturned,
                         OUTPUT TABLE tt-due-nf-faixa ).

    IF pl-filtro-vincul THEN DO:
   
       FIND FIRST tt-param-nota NO-LOCK NO-ERROR.
       IF NOT AVAIL tt-param-nota THEN RETURN "NOK":U.
   
       FOR EACH tt-due-nf-faixa 
          WHERE tt-due-nf-faixa.cod-estabel-nf          >= tt-param-nota.cod-estabel-ini
            AND tt-due-nf-faixa.cod-estabel-nf          <= tt-param-nota.cod-estabel-fim
            AND tt-due-nf-faixa.cod-serie-nf            >= tt-param-nota.cod-serie-ini
            AND tt-due-nf-faixa.cod-serie-nf            <= tt-param-nota.cod-serie-fim
            AND tt-due-nf-faixa.cod-nota-fisc           >= tt-param-nota.nr-nota-fisc-ini
            AND tt-due-nf-faixa.cod-nota-fisc           <= tt-param-nota.nr-nota-fisc-fim
            AND tt-due-nf-faixa.dat-emis-nf             >= tt-param-nota.dat-emissao-ini        
            AND tt-due-nf-faixa.dat-emis-nf             <= tt-param-nota.dat-emissao-fim        
            AND tt-due-nf-faixa.nat-operacao            >= tt-param-nota.nat-operacao-ini       
            AND tt-due-nf-faixa.nat-operacao            <= tt-param-nota.nat-operacao-fim       
            AND tt-due-nf-faixa.cod-estab-proces-export >= tt-param-nota.cod-estab-proc-exp-ini 
            AND tt-due-nf-faixa.cod-estab-proces-export <= tt-param-nota.cod-estab-proc-exp-fim 
            AND tt-due-nf-faixa.cod-proces-export       >= tt-param-nota.nr-proc-exp-ini        
            AND tt-due-nf-faixa.cod-proces-export       <= tt-param-nota.nr-proc-exp-fim        
            AND tt-due-nf-faixa.cdn-emitente            >= tt-param-nota.cdn-emitente-ini       
            AND tt-due-nf-faixa.cdn-emitente            <= tt-param-nota.cdn-emitente-fim       
            AND tt-due-nf-faixa.nom-abrev-clien         >= tt-param-nota.nome-abrev-ini         
            AND tt-due-nf-faixa.nom-abrev-clien         <= tt-param-nota.nome-abrev-fim         
            AND tt-due-nf-faixa.cdd-embarq              >= tt-param-nota.cdd-embarq-ini         
            AND tt-due-nf-faixa.cdd-embarq              <= tt-param-nota.cdd-embarq-fim NO-LOCK:   
            CREATE tt-due-nf-aux.
            BUFFER-COPY tt-due-nf-faixa TO tt-due-nf-aux.                                                         
       END.
    END.
    ELSE DO:
       FOR EACH tt-due-nf-faixa NO-LOCK:
           CREATE tt-due-nf-aux.
           BUFFER-COPY tt-due-nf-faixa TO tt-due-nf-aux. 
       END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaNotasVincular DBOProgram 
PROCEDURE piBuscaNotasVincular :
/*------------------------------------------------------------------------------
  Purpose: Busca as notas a vincular na DU-E com base nas informa‡äes do filtro   
  Parameters:  tt-param-nota : Temp-table com os parƒmetros de busca - (input) (temp-table)
               p-cdd-due-ems : Código da DU-e                        - (input) (variavel integer)
               pi-filtro     : Filtro Utilizado na abertura da query dos registros:
                               1 - NFs Com Pedido de Venda, 
                               2 - NFs Sem Pedido de Venda, 
                               3 - Todas as NFs
               tt-nota-fiscal: Temp-table com as notas encontradas   - (output)(temp-table) 
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAM TABLE FOR tt-param-nota.
   DEFINE INPUT  PARAM p-cdd-due-ems LIKE due-siscomex.cdd-due-ems NO-UNDO.
   DEFINE INPUT  PARAM pi-filtro     AS   INTEGER                  NO-UNDO.
   DEFINE INPUT  PARAM p-log-negocio AS   LOGICAL                  NO-UNDO.
   DEFINE OUTPUT PARAM TABLE FOR tt-nota-fiscal.

   DEFINE VARIABLE de-qtd-devolv   AS DECIMAL     NO-UNDO.
   DEFINE VARIABLE de-qtd-faturada AS DECIMAL     NO-UNDO.
   DEFINE VARIABLE c-arq-log       AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE l-log-negocio   AS LOGICAL     NO-UNDO.

   ASSIGN c-arq-log     = "LOG_NEGOCIO_due_":U + STRING(p-cdd-due-ems) + ".txt":U
          l-log-negocio = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-log-negocio":U AND funcao.ativo)
                          AND p-log-negocio.

   IF l-log-negocio THEN DO:
      {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="2" &iType="1" &cMessage="'INICIO piBuscaNotasVincular':U"}
   END.

   EMPTY TEMP-TABLE tt-nota-fiscal NO-ERROR.

   FIND FIRST due-siscomex
        WHERE due-siscomex.cdd-due-ems = p-cdd-due-ems NO-LOCK NO-ERROR.

   FIND FIRST tt-param-nota NO-LOCK NO-ERROR.
   IF NOT AVAIL tt-param-nota THEN RETURN "NOK":U.

   FOR EACH nota-fiscal FIELDS(cod-estabel serie nr-nota-fis dt-emis-nota nat-operacao 
                               cod-estab-proces-export nr-proc-exp cod-emitente 
                               nome-ab-cli cdd-embarq cod-chave-aces-nf-eletro 
                               idi-sit-nf-eletro dt-cancela)
      WHERE nota-fiscal.idi-sit-nf-eletro        = 3
        AND nota-fiscal.dt-emis-nota            >= tt-param-nota.dat-emissao-ini        
        AND nota-fiscal.dt-emis-nota            <= tt-param-nota.dat-emissao-fim        
        AND nota-fiscal.cod-estabel             >= tt-param-nota.cod-estabel-ini
        AND nota-fiscal.cod-estabel             <= tt-param-nota.cod-estabel-fim
        AND nota-fiscal.serie                   >= tt-param-nota.cod-serie-ini
        AND nota-fiscal.serie                   <= tt-param-nota.cod-serie-fim
        AND nota-fiscal.nr-nota-fis             >= tt-param-nota.nr-nota-fisc-ini
        AND nota-fiscal.nr-nota-fis             <= tt-param-nota.nr-nota-fisc-fim
        AND nota-fiscal.nat-operacao            >= tt-param-nota.nat-operacao-ini       
        AND nota-fiscal.nat-operacao            <= tt-param-nota.nat-operacao-fim       
        AND nota-fiscal.cod-estab-proces-export >= tt-param-nota.cod-estab-proc-exp-ini 
        AND nota-fiscal.cod-estab-proces-export <= tt-param-nota.cod-estab-proc-exp-fim 
        AND nota-fiscal.nr-proc-exp             >= tt-param-nota.nr-proc-exp-ini        
        AND nota-fiscal.nr-proc-exp             <= tt-param-nota.nr-proc-exp-fim        
        AND nota-fiscal.cod-emitente            >= tt-param-nota.cdn-emitente-ini       
        AND nota-fiscal.cod-emitente            <= tt-param-nota.cdn-emitente-fim       
        AND nota-fiscal.nome-ab-cli             >= tt-param-nota.nome-abrev-ini         
        AND nota-fiscal.nome-ab-cli             <= tt-param-nota.nome-abrev-fim         
        AND nota-fiscal.cdd-embarq              >= tt-param-nota.cdd-embarq-ini         
        AND nota-fiscal.cdd-embarq              <= tt-param-nota.cdd-embarq-fim NO-LOCK:     

       /*Desconsidera nota com chave de acesso nÆo for informada*/
       IF nota-fiscal.cod-chave-aces-nf-eletro = "":U THEN DO:
           IF l-log-negocio THEN DO:
               {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="2" &cMessage="'Estabel: ':U + TRIM(STRING(nota-fiscal.cod-estabel)) + 
                                                                                    ' S‚rie: ':U + TRIM(STRING(nota-fiscal.serie)) + 
                                                                                    ' NF: ':U + TRIM(STRING(nota-fiscal.nr-nota-fis)) + ' -> ':U +
                                                                                    'Chave de acesso nÆo foi informada na NF-e':U"}
           END.
           NEXT. 
       END.

       /*Desconsidera nota que nÆo estiver como Uso Autorizado*/
       IF nota-fiscal.idi-sit-nf-eletro <> 3 THEN NEXT. 

       /*Desconsidera nota cancelada */
       IF nota-fiscal.dt-cancela <> ? THEN DO:
           IF l-log-negocio THEN DO:
               {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="2" &cMessage="'Estabel: ':U + TRIM(STRING(nota-fiscal.cod-estabel)) +
                                                                                    ' S‚rie: ':U + TRIM(STRING(nota-fiscal.serie)) +
                                                                                    ' NF: ':U + TRIM(STRING(nota-fiscal.nr-nota-fis)) + ' -> ':U +
                                                                                    'NF-e est  cancelada - Dt.Cancelamento = ':U + STRING(nota-fiscal.dt-cancela)"}
           END.
           NEXT.
       END.

       /*Desconsidera nota que nÆo seja de Exporta‡Æo*/
       IF NOT nota-fiscal.nat-operacao BEGINS "7":U THEN DO:
           IF l-log-negocio THEN DO:
               {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="2" &cMessage="'Estabel: ':U + TRIM(STRING(nota-fiscal.cod-estabel)) +
                                                                                    ' S‚rie: ':U + TRIM(STRING(nota-fiscal.serie)) +
                                                                                    ' NF: ':U + TRIM(STRING(nota-fiscal.nr-nota-fis)) + ' -> ':U +
                                                                                    'Natureza de opera‡Æo nÆo ‚ de Exporta‡Æo - Nat.Operacao = ':U + TRIM(STRING(nota-fiscal.nat-operacao))"}
           END.
           NEXT. 
       END.

       /*Desconsidera nota cujo emitente nÆo seja estrangeiro ou trading*/
       IF NOT CAN-FIND(FIRST emitente 
                       WHERE emitente.cod-emitente = nota-fiscal.cod-emitente
                        AND (emitente.natureza = 3 /*Estrangeiro*/
                          OR emitente.natureza = 4 /*Trading*/  )) THEN DO: 
           IF l-log-negocio THEN DO:
               {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="2" &cMessage="'Estabel: ':U + TRIM(STRING(nota-fiscal.cod-estabel)) +
                                                                                    ' S‚rie: ':U + TRIM(STRING(nota-fiscal.serie)) +
                                                                                    ' NF: ':U + TRIM(STRING(nota-fiscal.nr-nota-fis)) + ' -> ':U +
                                                                                    'Natureza do Emitente ‚ diferente de Estrangeiro ou Trading':U"}
           END.
           NEXT.
       END.

       /*Desconsidera notas vinculadas a outra DU-E*/
       IF CAN-FIND(FIRST bf{&TableName}
                   WHERE bf{&TableName}.cod-estabel-nf = nota-fiscal.cod-estabel
                     AND bf{&TableName}.cod-serie-nf   = nota-fiscal.serie
                     AND bf{&TableName}.cod-nota-fisc  = nota-fiscal.nr-nota-fis) THEN DO: 
           IF l-log-negocio THEN DO:
               {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="2" &cMessage="'Estabel: ':U + TRIM(STRING(nota-fiscal.cod-estabel)) +
                                                                                    ' S‚rie: ':U + TRIM(STRING(nota-fiscal.serie)) +
                                                                                    ' NF: ':U + TRIM(STRING(nota-fiscal.nr-nota-fis)) + ' -> ':U +
                                                                                    'NF-e est  vinculada a outra DU-E':U"}
           END.
           NEXT.
       END.

       /*Desconsidera as notas que possuem Registro de Exporta‡Æo*/
       IF CAN-FIND(FIRST reg-export NO-LOCK
                   WHERE reg-export.cod-estabel = nota-fiscal.cod-estab-proces-export
                   AND   reg-export.nr-proc-exp = nota-fiscal.nr-proc-exp) THEN DO: 
           IF l-log-negocio THEN DO:
               {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="2" &cMessage="'Estabel: ':U + TRIM(STRING(nota-fiscal.cod-estabel)) +
                                                                                    ' S‚rie: ':U + TRIM(STRING(nota-fiscal.serie)) +
                                                                                    ' NF: ':U + TRIM(STRING(nota-fiscal.nr-nota-fis)) + ' -> ':U +
                                                                                    'NF-e possui Registro de Exporta‡Æo':U"}
           END.
           NEXT.
       END.

       FIND FIRST it-nota-fisc
            WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel 
              AND it-nota-fisc.serie       = nota-fiscal.serie
              AND it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.

       IF AVAIL it-nota-fisc THEN DO:
           IF l-fn-due-v3 THEN DO:
               IF  pi-filtro = 1 THEN DO: /*Desconsidera notas sem Pedido de Venda*/
                   IF it-nota-fisc.nr-pedido = 0 THEN DO:
                       IF l-log-negocio THEN DO:
                           {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="2" &cMessage="'Estabel: ':U + TRIM(STRING(nota-fiscal.cod-estabel)) +
                                                                                                ' S‚rie: ':U + TRIM(STRING(nota-fiscal.serie)) +
                                                                                                ' NF: ':U + TRIM(STRING(nota-fiscal.nr-nota-fis)) + ' -> ':U +
                                                                                                'Filtro considera apenas NFs com Pedido de Venda - Nr Pedido = ':U + STRING(it-nota-fisc.nr-pedido)"}
                       END.
                       NEXT.
                   END.
               END.
               ELSE DO:
                   IF pi-filtro = 2 THEN DO: /*Desconsidera notas com Pedido de Venda*/
                       IF it-nota-fisc.nr-pedido <> 0 THEN DO:
                           IF l-log-negocio THEN DO:
                               {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="2" &cMessage="'Estabel: ':U + TRIM(STRING(nota-fiscal.cod-estabel)) + 
                                                                                                    ' S‚rie: ':U + TRIM(STRING(nota-fiscal.serie)) +
                                                                                                    ' NF: ':U + TRIM(STRING(nota-fiscal.nr-nota-fis)) + ' -> ':U +
                                                                                                    'Filtro considera apenas NFs sem Pedido de Venda - Nr Pedido = ':U + STRING(it-nota-fisc.nr-pedido)"}
                           END.
                           NEXT.
                       END.
                   END.
               END.
           END.
           ELSE DO:
               IF it-nota-fisc.nr-pedido = 0 THEN DO:
                   IF l-log-negocio THEN DO:
                       {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="2" &cMessage="'Estabel: ':U + TRIM(STRING(nota-fiscal.cod-estabel)) + 
                                                                                            ' S‚rie: ':U + TRIM(STRING(nota-fiscal.serie)) +
                                                                                            ' NF: ':U + TRIM(STRING(nota-fiscal.nr-nota-fis)) + ' -> ':U + 
                                                                                            'NF nÆo possui pedido de venda - Nr Pedido = ':U"}
                   END.
                   NEXT.
               END.
           END.

           FOR FIRST moeda FIELDS(mo-codigo)
               WHERE moeda.mo-codigo = due-siscomex.cdn-moed-siscomex NO-LOCK:
           END.
           IF NOT AVAIL moeda THEN DO:
               IF l-log-negocio THEN DO:
                   {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="2" &cMessage="'Estabel: ':U + TRIM(STRING(nota-fiscal.cod-estabel)) + 
                                                                                        ' S‚rie: ':U + TRIM(STRING(nota-fiscal.serie)) +
                                                                                        ' NF: ':U + TRIM(STRING(nota-fiscal.nr-nota-fis)) + ' -> ':U +
                                                                                        'Moeda da DU-e Siscomex nÆo cadastrada - Cod.Moeda = ':U + TRIM(STRING(due-siscomex.cdn-moed-siscomex))"}
               END.
               NEXT.
           END.
           
           /*Desconsidera notas com moeda diferente da moeda da DU-e*/ 
           IF CAN-FIND(FIRST ped-venda 
                       WHERE ped-venda.nr-pedido = it-nota-fisc.nr-pedido
                         AND ped-venda.mo-codigo <> moeda.mo-codigo) THEN DO:
               IF l-log-negocio THEN DO:
                   {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="2" &cMessage="'Estabel: ':U + TRIM(STRING(nota-fiscal.cod-estabel)) + 
                                                                                        ' S‚rie: ':U + TRIM(STRING(nota-fiscal.serie)) +
                                                                                        ' NF: ':U + TRIM(STRING(nota-fiscal.nr-nota-fis)) + ' -> ':U +
                                                                                        'Moeda do Pedido ‚ diferente da moeda informada na DU-E Siscomex':U"}
               END.
               NEXT.
           END.
       END.

       /*Desconsidera notas devolvidas totalmente*/
       ASSIGN de-qtd-devolv   = 0
              de-qtd-faturada = 0.
       FOR EACH it-nota-fisc NO-LOCK
          WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel 
          AND   it-nota-fisc.serie       = nota-fiscal.serie
          AND   it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis:
          ASSIGN de-qtd-faturada = de-qtd-faturada + it-nota-fisc.qt-faturada[1].

          FOR EACH devol-cli fields(qt-devolvida) where
                   devol-cli.cod-estabel = it-nota-fisc.cod-estabel and
                   devol-cli.serie       = it-nota-fisc.serie       and
                   devol-cli.nr-nota-fis = it-nota-fisc.nr-nota-fis and
                   devol-cli.it-codigo   = it-nota-fisc.it-codigo no-lock: 
              assign de-qtd-devolv = de-qtd-devolv + devol-cli.qt-devolvida.
          end.
       END.

       IF de-qtd-devolv >= de-qtd-faturada THEN DO:
           IF l-log-negocio THEN DO:
               {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="2" &cMessage="'Estabel: ':U + TRIM(STRING(nota-fiscal.cod-estabel)) + 
                                                                                    ' S‚rie: ':U + TRIM(STRING(nota-fiscal.serie)) +
                                                                                    ' NF: ':U + TRIM(STRING(nota-fiscal.nr-nota-fis)) + ' -> ':U +
                                                                                    'Quantidade Devolvida: ':U + string(de-qtd-devolv) + ' ‚ maior ou igual … Quantidade Faturada: ':U + string(de-qtd-faturada)"}
           END.
           NEXT.
       END.

       CREATE tt-nota-fiscal.
       BUFFER-COPY nota-fiscal TO tt-nota-fiscal NO-ERROR.
                                                     
   END.

    IF l-log-negocio THEN DO:
        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="4" &iType="1" &cMessage="'FIM piBuscaNotasVincular':U"}
    END.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaAtualizaRelacNfsEmbDue DBOProgram 
PROCEDURE piValidaAtualizaRelacNfsEmbDue :
/*:T------------------------------------------------------------------------------
  Purpose:     Verifica se j  existe DU-E vinculada as notas fiscais ao relacionar 
               nota ou embarque a um processo de exporta‡Æo (ex0190l). 
               Atualiza tamb‚m as informa‡äes de processo de exporta‡Æo nas tabelas de 
               itens da DU-e e notas da DU-e.
  Parameters:  p-origem: Origem: 1 - Nota Fiscal ou 2 - Embarque - (input)(vari vel) 
               p-estab: C¢dido do Estabelecimento da Nota Fiscal - (input) (vari vel)      
               p-serie: S‚rie da Nota Fiscal - (input) (vari vel)      
               p-nota: N£mero da Nota Fiscal - (input) (vari vel)       
               p-embarque: C¢digo do Embarque - (input) (vari vel) 
               p-nr-proc-exp: C¢digo do processo de exporta‡Æo - (input) (vari vel)  
               p-cod-estab-proc-exp: Estabelecimento do processo de exporta‡Æo - (input) (vari vel)  
               RowErrors: Temp-table de erros - (output)(temp-table)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-origem             AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-estab              AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-serie              AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-nota               AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-embarque           AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-proc-exp        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estab-proc-exp AS CHARACTER NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR RowErrors.

    IF p-origem = 1 THEN DO: /* Nota Fiscal */
       FIND FIRST bfdue-nf 
            WHERE bfdue-nf.cod-estabel-nf = p-estab  
              AND bfdue-nf.cod-serie-nf   = p-serie 
              AND bfdue-nf.cod-nota-fisc  = p-nota  EXCLUSIVE-LOCK NO-ERROR.
       IF AVAIL bfdue-nf THEN DO:  
           ASSIGN bfdue-nf.cod-estab-proces-export = p-cod-estab-proc-exp
                  bfdue-nf.cod-proces-export       = p-nr-proc-exp.

           FOR FIRST due-item WHERE due-item.cdd-due-ems    = bfdue-nf.cdd-due-ems 
                                AND due-item.num-versao-due = bfdue-nf.num-versao-due
                                AND due-item.cod-estabel-nf = bfdue-nf.cod-estabel-nf
                                AND due-item.cod-serie-nf   = bfdue-nf.cod-serie-nf 
                                AND due-item.cod-nota-fisc  = bfdue-nf.cod-nota-fisc EXCLUSIVE-LOCK:
               ASSIGN due-item.cod-estab-proces-export = p-cod-estab-proc-exp
                      due-item.cod-proces-export       = p-nr-proc-exp.
           END.

           {method/svc/errors/inserr.i
                     &ErrorNumber="55949"
                     &ErrorType="EMS"
                     &ErrorSubType="INFORMATION"
                     &ErrorParameters="''"}
       END.

    END.
    ELSE DO: /* Embarque */
       FOR EACH nota-fiscal FIELDS(cod-estabel nr-nota-fis serie) NO-LOCK
           WHERE nota-fiscal.cdd-embarq   = p-Embarque:
           FIND FIRST bfdue-nf 
                WHERE bfdue-nf.cod-estabel-nf = nota-fiscal.cod-estabel  
                  AND bfdue-nf.cod-serie-nf   = nota-fiscal.serie       
                  AND bfdue-nf.cod-nota-fisc  = nota-fiscal.nr-nota-fis EXCLUSIVE-LOCK NO-ERROR.
           IF AVAIL bfdue-nf THEN DO:
               ASSIGN bfdue-nf.cod-estab-proces-export = p-cod-estab-proc-exp
                      bfdue-nf.cod-proces-export       = p-nr-proc-exp.

               FOR FIRST due-item WHERE due-item.cdd-due-ems    = bfdue-nf.cdd-due-ems 
                                    AND due-item.num-versao-due = bfdue-nf.num-versao-due
                                    AND due-item.cod-estabel-nf = bfdue-nf.cod-estabel-nf
                                    AND due-item.cod-serie-nf   = bfdue-nf.cod-serie-nf 
                                    AND due-item.cod-nota-fisc  = bfdue-nf.cod-nota-fisc EXCLUSIVE-LOCK:
                   ASSIGN due-item.cod-estab-proces-export = p-cod-estab-proc-exp
                          due-item.cod-proces-export       = p-nr-proc-exp.
               END.

               IF NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorNumber = 55950) THEN DO:
                   {method/svc/errors/inserr.i
                          &ErrorNumber="55950"
                          &ErrorType="EMS"
                          &ErrorSubType="INFORMATION"
                          &ErrorParameters="''"}
               END.
           END.
       END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaNfsDueEnvio DBOProgram 
PROCEDURE piValidaNfsDueEnvio :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida informa‡äes das notas da DU-E antes do envio para Siscomex
  Parameters:  p-cdd-due-ems: N£mero interno da DU-E - (input)(integer)
               RowErrors: Temp-table de erros - (output)(temp-table)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cdd-due-ems LIKE due-siscomex.cdd-due-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE c-lb-notas AS CHARACTER   NO-UNDO.

    IF NOT CAN-FIND(FIRST bfdue-nf
                    WHERE bfdue-nf.cdd-due-ems = p-cdd-due-ems) THEN DO:
        {utp/ut-liter.i "Notas Fiscais" *}
         ASSIGN c-lb-notas = RETURN-VALUE.
        {utp/ut-liter.i "a_DU-E" *}
        {method/svc/errors/inserr.i
                    &ErrorNumber="16381"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-lb-notas + '~~~~' + RETURN-VALUE + ': ' + string(p-cdd-due-ems)"}
    END.
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaNfsDue DBOProgram 
PROCEDURE piVerificaNfsDue :
/*:T------------------------------------------------------------------------------
  Purpose:     Verifica se existe notas vinculadas na DU-E
  Parameters:  p-cdd-due-ems: N£mero interno da DU-E - (input)(integer)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cdd-due-ems LIKE due-siscomex.cdd-due-ems NO-UNDO.

    IF CAN-FIND(FIRST bfdue-nf
                WHERE bfdue-nf.cdd-due-ems = p-cdd-due-ems) THEN DO:
        RETURN "NOK":U.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByDue DBOProgram 
PROCEDURE setConstraintByDue :
/*------------------------------------------------------------------------------
  Purpose: Recebe os parƒmetros para abertura da query "ByDue"    
  Parameters: pcdd-due-ems: N£mero interno da DUE - (INPUT)(DECIMAL)  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdd-due-ems    LIKE due-nf.cdd-due-ems  NO-UNDO.

    ASSIGN de-cdd-due-ems = pcdd-due-ems.   

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
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

