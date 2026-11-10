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
{include/i-prgvrs.i BOCX00435 2.00.00.009 } /*** "010009" 11/12/2023 10:13:18 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx00435 MUT}
&ENDIF

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00435
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ex-histor-alter
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND TRUE
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND-PROCS Main

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
{cxbo/bocx00435.i RowObject}
      

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE TEMP-TABLE tt-ex-histor-alter NO-UNDO LIKE ex-histor-alter
    FIELD r-rowid AS ROWID.

DEFINE VARIABLE c-tabela        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-campo         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-chave         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-hora-ini      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-hora-fim      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-usuario-ini   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-usuario-fim   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-date-ini      AS DATE FORMAT "99/99/9999"       NO-UNDO.
DEFINE VARIABLE d-date-fim      AS DATE FORMAT "99/99/9999"       NO-UNDO.
DEFINE VARIABLE i-ordenacao     AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-operacao      AS INTEGER     NO-UNDO.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "campo":U THEN ASSIGN pFieldValue = RowObject.campo.
        WHEN "chave":U THEN ASSIGN pFieldValue = RowObject.chave.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "hora-alter":U THEN ASSIGN pFieldValue = RowObject.hora-alter.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nome-tabela":U THEN ASSIGN pFieldValue = RowObject.nome-tabela.
        WHEN "prog-alter":U THEN ASSIGN pFieldValue = RowObject.prog-alter.
        WHEN "usuar-alter":U THEN ASSIGN pFieldValue = RowObject.usuar-alter.
        WHEN "vl-anterior-char":U THEN ASSIGN pFieldValue = RowObject.vl-anterior-char.
        WHEN "vl-novo":U THEN ASSIGN pFieldValue = RowObject.vl-novo.
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
        WHEN "dt-alter":U THEN ASSIGN pFieldValue = RowObject.dt-alter.
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
        WHEN "cdn-seq":U THEN ASSIGN pFieldValue = RowObject.cdn-seq.
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
  Purpose:     Retorna valores dos campos do °ndice exhstrlt_id5
  Parameters:  
               retorna valor do campo cdn-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-seq LIKE ex-histor-alter.cdn-seq NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-seq = RowObject.cdn-seq.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice exhstrlt_id5
  Parameters:  
               recebe valor do campo cdn-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-seq LIKE ex-histor-alter.cdn-seq NO-UNDO.

    FIND FIRST bfex-histor-alter WHERE 
        bfex-histor-alter.cdn-seq = pcdn-seq NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfex-histor-alter THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfex-histor-alter)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
OPEN QUERY qr{&tableName} FOR EACH {&tableName}  NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFirstMain DBOProgram 
PROCEDURE findFirstMain:

    FIND FIRST {&TableName} NO-LOCK NO-ERROR.

    return "OK":U.
end procedure.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNextMain DBOProgram 
PROCEDURE findNextMain:

    FIND NEXT {&TableName} NO-LOCK NO-ERROR.

    return "OK":U.
end procedure.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPrevMain DBOProgram 
PROCEDURE findPrevMain:

    FIND PREV {&TableName} NO-LOCK NO-ERROR.

    return "OK":U.
end procedure.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLastMain DBOProgram 
PROCEDURE findLastMain:

    FIND LAST {&TableName} NO-LOCK NO-ERROR.

    return "OK":U.
end procedure.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-seq DBOProgram 
PROCEDURE pi-busca-seq :
/*------------------------------------------------------------------------------
  Purpose: Retorna a £tima sequància da tabela.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM pi-sequencia LIKE ex-histor-alter.cdn-seq NO-UNDO.

    FOR LAST bf{&TableName}  FIELDS (cdn-seq) NO-LOCK
          BY bf{&TableName}.cdn-seq:
    END.

    IF NOT AVAIL bf{&TableName} OR bf{&TableName}.cdn-seq = ? OR bf{&TableName}.cdn-seq = 0 THEN
        ASSIGN pi-sequencia = 1.
    ELSE
        ASSIGN pi-sequencia = bf{&TableName}.cdn-seq + 1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-processa-query DBOProgram 
PROCEDURE pi-processa-query :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para retornar a temp-table filtrados pelos parÉmetros
  Parameters:  ttAf-historico-alteracao -> retorna os valores do hist¢rico
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETE TABLE FOR tt-ex-histor-alter.
    DEFINE VARIABLE c-tabela-filtro-ini AS CHARACTER  INIT "" NO-UNDO.
    DEFINE VARIABLE c-tabela-filtro-fim AS CHARACTER  INIT "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"  NO-UNDO.
    DEFINE VARIABLE c-campo-filtro      AS CHARACTER  INIT "" NO-UNDO.
    DEFINE VARIABLE c-chave-filtro-ini  AS CHARACTER  INIT "" NO-UNDO.
    DEFINE VARIABLE c-chave-filtro-fim  AS CHARACTER  INIT "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" NO-UNDO.
    DEFINE VARIABLE c-operacao          AS CHARACTER  INIT "" NO-UNDO.
                                                            
    IF i-operacao <> 1 THEN
        IF i-operacao = 2 THEN DO:
            {utp/ut-liter.i "Criaá∆o"}
            ASSIGN c-operacao = TRIM(RETURN-VALUE).
        END.
        ELSE IF i-operacao = 3 THEN DO:
            {utp/ut-liter.i "Alteraá∆o"}
            ASSIGN c-operacao = TRIM(RETURN-VALUE).
        END.                                       

    IF d-date-ini = ? THEN
        ASSIGN d-date-ini = TODAY.
    IF d-date-fim = ? THEN
        ASSIGN d-date-fim = TODAY.
    
    /*Verifica e seta os parÉmetros para mostar os dados*/
    IF TRIM(c-tabela) <> "" THEN
        ASSIGN c-tabela-filtro-ini = c-tabela
               c-tabela-filtro-fim = c-tabela.
    IF TRIM(c-campo) <> "Todos" THEN
        ASSIGN c-campo-filtro = c-campo.
    IF TRIM(c-chave) <> "" THEN
        CASE c-tabela:
            WHEN "processo-exp":U THEN 
                ASSIGN OVERLAY(c-chave-filtro-ini,1,12) = SUBSTRING(c-chave,1,12)
                       OVERLAY(c-chave-filtro-fim,1,12) = SUBSTRING(c-chave,1,12)
                       OVERLAY(c-chave-filtro-ini,13,5) = SUBSTRING(c-chave,13,5)
                       OVERLAY(c-chave-filtro-fim,13,5) = SUBSTRING(c-chave,13,5).
            WHEN "historico-proc-exp":U THEN
                ASSIGN OVERLAY(c-chave-filtro-ini,1,12) = SUBSTRING(c-chave,1,12)
                       OVERLAY(c-chave-filtro-fim,1,12) = SUBSTRING(c-chave,1,12)
                       OVERLAY(c-chave-filtro-ini,13,5) = SUBSTRING(c-chave,13,5)
                       OVERLAY(c-chave-filtro-fim,13,5) = SUBSTRING(c-chave,13,5).
            WHEN "pedido-drb" THEN
                ASSIGN OVERLAY(c-chave-filtro-ini,1,5) = SUBSTRING(c-chave,1,5)
                       OVERLAY(c-chave-filtro-fim,1,5) = SUBSTRING(c-chave,1,5)
                       OVERLAY(c-chave-filtro-ini,6,20) = SUBSTRING(c-chave,6,20)
                       OVERLAY(c-chave-filtro-fim,6,20) = SUBSTRING(c-chave,6,20).
            WHEN "pedido-drb-item" THEN
                ASSIGN OVERLAY(c-chave-filtro-ini,1,5) = SUBSTRING(c-chave,1,5)
                       OVERLAY(c-chave-filtro-fim,1,5) = SUBSTRING(c-chave,1,5)
                       OVERLAY(c-chave-filtro-ini,6,20) = SUBSTRING(c-chave,6,20)
                       OVERLAY(c-chave-filtro-fim,6,20) = SUBSTRING(c-chave,6,20).
            WHEN "ped-draw-nfe" THEN
                ASSIGN OVERLAY(c-chave-filtro-ini,1,5) = SUBSTRING(c-chave,1,5)
                       OVERLAY(c-chave-filtro-fim,1,5) = SUBSTRING(c-chave,1,5)
                       OVERLAY(c-chave-filtro-ini,6,20) = SUBSTRING(c-chave,6,20)
                       OVERLAY(c-chave-filtro-fim,6,20) = SUBSTRING(c-chave,6,20).
            WHEN "ped-draw-nfs" THEN
                ASSIGN OVERLAY(c-chave-filtro-ini,1,5) = SUBSTRING(c-chave,1,5)
                       OVERLAY(c-chave-filtro-fim,1,5) = SUBSTRING(c-chave,1,5)
                       OVERLAY(c-chave-filtro-ini,6,20) = SUBSTRING(c-chave,6,20)
                       OVERLAY(c-chave-filtro-fim,6,20) = SUBSTRING(c-chave,6,20).
            WHEN "movto-ato" THEN
                ASSIGN OVERLAY(c-chave-filtro-ini,1,5) = SUBSTRING(c-chave,1,5)
                       OVERLAY(c-chave-filtro-fim,1,5) = SUBSTRING(c-chave,1,5)
                       OVERLAY(c-chave-filtro-ini,6,20) = SUBSTRING(c-chave,6,20)
                       OVERLAY(c-chave-filtro-fim,6,20) = SUBSTRING(c-chave,6,20).
            WHEN "item-re" THEN
                ASSIGN OVERLAY(c-chave-filtro-ini,1,5) = SUBSTRING(c-chave,1,5)
                       OVERLAY(c-chave-filtro-fim,1,5) = SUBSTRING(c-chave,1,5)
                       OVERLAY(c-chave-filtro-ini,6,20) = SUBSTRING(c-chave,6,20)
                       OVERLAY(c-chave-filtro-fim,6,20) = SUBSTRING(c-chave,6,20).
        END CASE.
    
    EMPTY TEMP-TABLE tt-ex-histor-alter.
   
    CASE i-ordenacao:
        WHEN 1 THEN DO:

           RUN pi-processa-query-by-tabela(INPUT-OUTPUT TABLE tt-ex-histor-alter,
                                           INPUT c-tabela-filtro-ini,
                                           INPUT c-tabela-filtro-fim,
                                           INPUT c-campo-filtro,
                                           INPUT c-chave-filtro-ini,
                                           INPUT c-chave-filtro-fim,
                                           INPUT c-operacao).
        END.
        WHEN 2 THEN DO:
            RUN pi-processa-query-by-datahora(INPUT-OUTPUT TABLE tt-ex-histor-alter,
                                              INPUT c-tabela-filtro-ini,
                                              INPUT c-tabela-filtro-fim,
                                              INPUT c-campo-filtro,
                                              INPUT c-chave-filtro-ini,
                                              INPUT c-chave-filtro-fim,
                                              INPUT c-operacao).
        END.
        WHEN 3 THEN DO:
            RUN pi-processa-query-by-usuario(INPUT-OUTPUT TABLE tt-ex-histor-alter,
                                             INPUT c-tabela-filtro-ini,
                                             INPUT c-tabela-filtro-fim,
                                             INPUT c-campo-filtro,
                                             INPUT c-chave-filtro-ini,
                                             INPUT c-chave-filtro-fim,
                                             INPUT c-operacao).
        END.
    END CASE.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-processa-query-by-datahora DBOProgram 
PROCEDURE pi-processa-query-by-datahora :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para retornar a temp-table filtrados pelos parÉmetros
  Parameters:  tt-ex-histor-alter -> retorna os valores do hist¢rico
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETE TABLE FOR tt-ex-histor-alter.
    DEFINE INPUT PARAMETER c-tabela-filtro-ini AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER c-tabela-filtro-fim AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER c-campo-filtro      AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER c-chave-filtro-ini  AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER c-chave-filtro-fim  AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER c-operacao-filtro   AS CHARACTE   NO-UNDO.

    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.usuar-alter >= c-usuario-ini
        AND   bf{&TableName}.usuar-alter <= c-usuario-fim
        AND   bf{&TableName}.dt-alter >= d-date-ini
        AND   bf{&TableName}.dt-alter <= d-date-fim
        AND   bf{&TableName}.hora-alter >= c-hora-ini
        AND   bf{&TableName}.hora-alter <= c-hora-fim
        AND   bf{&TableName}.nome-tabela >= c-tabela-filtro-ini
        AND   bf{&TableName}.nome-tabela <= c-tabela-filtro-fim
        BY    bf{&TableName}.dt-alter
        BY    bf{&TableName}.hora-alter:

        CASE c-tabela:
            WHEN "processo-exp":U THEN DO:
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,12)) < TRIM(SUBSTRING(c-chave-filtro-ini,1,12)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,12)) > TRIM(SUBSTRING(c-chave-filtro-fim,1,12)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,13,5)) < TRIM(SUBSTRING(c-chave-filtro-ini,13,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,13,5)) > TRIM(SUBSTRING(c-chave-filtro-fim,13,5)) THEN NEXT.
            END.
            WHEN "historico-proc-exp":U THEN DO:
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,12)) < TRIM(SUBSTRING(c-chave-filtro-ini,1,12)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,12)) > TRIM(SUBSTRING(c-chave-filtro-fim,1,12)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,13,5)) < TRIM(SUBSTRING(c-chave-filtro-ini,13,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,13,5)) > TRIM(SUBSTRING(c-chave-filtro-fim,13,5)) THEN NEXT.
            END.
            WHEN "pedido-drb" THEN DO:
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) < TRIM(SUBSTRING(c-chave-filtro-ini,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) > TRIM(SUBSTRING(c-chave-filtro-fim,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) < TRIM(SUBSTRING(c-chave-filtro-ini,6,20)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) > TRIM(SUBSTRING(c-chave-filtro-fim,6,20)) THEN NEXT.
            END.
            WHEN "pedido-drb-item" THEN DO:
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) < TRIM(SUBSTRING(c-chave-filtro-ini,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) > TRIM(SUBSTRING(c-chave-filtro-fim,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) < TRIM(SUBSTRING(c-chave-filtro-ini,6,20)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) > TRIM(SUBSTRING(c-chave-filtro-fim,6,20)) THEN NEXT.
            END.
            WHEN "ped-draw-nfe" THEN DO:
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) < TRIM(SUBSTRING(c-chave-filtro-ini,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) > TRIM(SUBSTRING(c-chave-filtro-fim,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) < TRIM(SUBSTRING(c-chave-filtro-ini,6,20)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) > TRIM(SUBSTRING(c-chave-filtro-fim,6,20)) THEN NEXT.
            END.
            WHEN "ped-draw-nfs" THEN DO:
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) < TRIM(SUBSTRING(c-chave-filtro-ini,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) > TRIM(SUBSTRING(c-chave-filtro-fim,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) < TRIM(SUBSTRING(c-chave-filtro-ini,6,20)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) > TRIM(SUBSTRING(c-chave-filtro-fim,6,20)) THEN NEXT.
            END.
            WHEN "movto-ato" THEN DO:
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) < TRIM(SUBSTRING(c-chave-filtro-ini,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) > TRIM(SUBSTRING(c-chave-filtro-fim,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) < TRIM(SUBSTRING(c-chave-filtro-ini,6,20)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) > TRIM(SUBSTRING(c-chave-filtro-fim,6,20)) THEN NEXT.
            END.
            WHEN "item-re" THEN DO:
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) < TRIM(SUBSTRING(c-chave-filtro-ini,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) > TRIM(SUBSTRING(c-chave-filtro-fim,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) < TRIM(SUBSTRING(c-chave-filtro-ini,6,20)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) > TRIM(SUBSTRING(c-chave-filtro-fim,6,20)) THEN NEXT.
            END.
        END.

         /*Se os "campo" foi passado como filtro tem que verificar fora do select
            por causa da performace*/
        IF c-campo-filtro <> "" THEN
            IF  bf{&TableName}.campo <> c-campo-filtro THEN
                NEXT.

        IF c-operacao-filtro <> "" THEN
            IF NOT (SUBSTRING(bf{&TableName}.cod-livre-1,1,10) MATCHES (c-operacao-filtro + "*")) THEN
                NEXT.
    
        CREATE tt-ex-histor-alter.
        BUFFER-COPY bf{&TableName} TO tt-ex-histor-alter.    
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-processa-query-by-tabela DBOProgram 
PROCEDURE pi-processa-query-by-tabela :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para retornar a temp-table filtrados pelos parÉmetros
  Parameters:  tt-ex-histor-alter -> retorna os valores do hist¢rico
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETE TABLE FOR tt-ex-histor-alter.
    DEFINE INPUT PARAMETER c-tabela-filtro-ini AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER c-tabela-filtro-fim AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER c-campo-filtro      AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER c-chave-filtro-ini  AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER c-chave-filtro-fim  AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER c-operacao-filtro   AS CHARACTER  NO-UNDO.

    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.usuar-alter >= c-usuario-ini
        AND   bf{&TableName}.usuar-alter <= c-usuario-fim
        AND   bf{&TableName}.dt-alter >= d-date-ini
        AND   bf{&TableName}.dt-alter <= d-date-fim
        AND   bf{&TableName}.hora-alter >= c-hora-ini
        AND   bf{&TableName}.hora-alter <= c-hora-fim
        AND   bf{&TableName}.nome-tabela >= c-tabela-filtro-ini
        AND   bf{&TableName}.nome-tabela <= c-tabela-filtro-fim
        BY    bf{&TableName}.nome-tabela
        BY    bf{&TableName}.campo: 
        
        CASE c-tabela:
            WHEN "processo-exp":U THEN DO:
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,12)) < TRIM(SUBSTRING(c-chave-filtro-ini,1,12)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,12)) > TRIM(SUBSTRING(c-chave-filtro-fim,1,12)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,13,5)) < TRIM(SUBSTRING(c-chave-filtro-ini,13,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,13,5)) > TRIM(SUBSTRING(c-chave-filtro-fim,13,5)) THEN NEXT.
            END.
            WHEN "historico-proc-exp":U THEN DO:
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,12)) < TRIM(SUBSTRING(c-chave-filtro-ini,1,12)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,12)) > TRIM(SUBSTRING(c-chave-filtro-fim,1,12)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,13,5)) < TRIM(SUBSTRING(c-chave-filtro-ini,13,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,13,5)) > TRIM(SUBSTRING(c-chave-filtro-fim,13,5)) THEN NEXT.
            END.
            WHEN "pedido-drb" THEN DO:
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) < TRIM(SUBSTRING(c-chave-filtro-ini,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) > TRIM(SUBSTRING(c-chave-filtro-fim,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) < TRIM(SUBSTRING(c-chave-filtro-ini,6,20)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) > TRIM(SUBSTRING(c-chave-filtro-fim,6,20)) THEN NEXT.
            END.
            WHEN "pedido-drb-item" THEN DO:
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) < TRIM(SUBSTRING(c-chave-filtro-ini,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) > TRIM(SUBSTRING(c-chave-filtro-fim,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) < TRIM(SUBSTRING(c-chave-filtro-ini,6,20)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) > TRIM(SUBSTRING(c-chave-filtro-fim,6,20)) THEN NEXT.
            END.
            WHEN "ped-draw-nfe" THEN DO:
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) < TRIM(SUBSTRING(c-chave-filtro-ini,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) > TRIM(SUBSTRING(c-chave-filtro-fim,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) < TRIM(SUBSTRING(c-chave-filtro-ini,6,20)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) > TRIM(SUBSTRING(c-chave-filtro-fim,6,20)) THEN NEXT.
            END.
            WHEN "ped-draw-nfs" THEN DO:
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) < TRIM(SUBSTRING(c-chave-filtro-ini,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) > TRIM(SUBSTRING(c-chave-filtro-fim,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) < TRIM(SUBSTRING(c-chave-filtro-ini,6,20)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) > TRIM(SUBSTRING(c-chave-filtro-fim,6,20)) THEN NEXT.
            END.
            WHEN "movto-ato" THEN DO:
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) < TRIM(SUBSTRING(c-chave-filtro-ini,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) > TRIM(SUBSTRING(c-chave-filtro-fim,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) < TRIM(SUBSTRING(c-chave-filtro-ini,6,20)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) > TRIM(SUBSTRING(c-chave-filtro-fim,6,20)) THEN NEXT.
            END.
            WHEN "item-re" THEN DO:
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) < TRIM(SUBSTRING(c-chave-filtro-ini,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,1,5)) > TRIM(SUBSTRING(c-chave-filtro-fim,1,5)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) < TRIM(SUBSTRING(c-chave-filtro-ini,6,20)) THEN NEXT.
                IF TRIM(SUBSTRING(bf{&TableName}.chave,6,20)) > TRIM(SUBSTRING(c-chave-filtro-fim,6,20)) THEN NEXT.
            END.
        END.
        /*Se os "campo" foi passado como filtro tem que verificar fora do select
            por causa da performace*/
        IF c-campo-filtro <> "" THEN
            IF  bf{&TableName}.campo <> c-campo-filtro THEN
                NEXT.

        IF c-operacao-filtro <> "" THEN
            IF NOT (SUBSTRING(bf{&TableName}.cod-livre-1,1,10) MATCHES (c-operacao-filtro + "*")) THEN
                NEXT.

        CREATE tt-ex-histor-alter.
        BUFFER-COPY bf{&TableName} TO tt-ex-histor-alter.    
    END.
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-processa-query-by-usuario DBOProgram 
PROCEDURE pi-processa-query-by-usuario :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para retornar a temp-table filtrados pelos parÉmetros
  Parameters:  tt-ex-histor-alter -> retorna os valores do hist¢rico
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETE TABLE FOR tt-ex-histor-alter.
    DEFINE INPUT PARAMETER c-tabela-filtro-ini AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER c-tabela-filtro-fim AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER c-campo-filtro      AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER c-chave-filtro-ini  AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER c-chave-filtro-fim  AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER c-operacao-filtro   AS CHARACTER   NO-UNDO.

    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.usuar-alter >= c-usuario-ini
        AND   bf{&TableName}.usuar-alter <= c-usuario-fim
        AND   bf{&TableName}.dt-alter >= d-date-ini
        AND   bf{&TableName}.dt-alter <= d-date-fim
        AND   bf{&TableName}.hora-alter >= c-hora-ini
        AND   bf{&TableName}.hora-alter <= c-hora-fim
        AND   bf{&TableName}.nome-tabela >= c-tabela-filtro-ini
        AND   bf{&TableName}.nome-tabela <= c-tabela-filtro-fim
        BY    bf{&TableName}.usuar-alter:

        IF TRIM(SUBSTRING(bf{&TableName}.chave,1,12)) < TRIM(SUBSTRING(c-chave-filtro-ini,1,12)) THEN NEXT.
        IF TRIM(SUBSTRING(bf{&TableName}.chave,1,12)) > TRIM(SUBSTRING(c-chave-filtro-fim,1,12)) THEN NEXT.
        IF TRIM(SUBSTRING(bf{&TableName}.chave,13,5)) < TRIM(SUBSTRING(c-chave-filtro-ini,13,5)) THEN NEXT.
        IF TRIM(SUBSTRING(bf{&TableName}.chave,13,5)) > TRIM(SUBSTRING(c-chave-filtro-fim,13,5)) THEN NEXT.
        
        /*Se os "campo" foi passado como filtro tem que verificar fora do select
            por causa da performace*/
        IF c-campo-filtro <> "" THEN
            IF  bf{&TableName}.campo <> c-campo-filtro THEN
                NEXT.

        IF c-operacao-filtro <> "" THEN
            IF NOT (SUBSTRING(bf{&TableName}.cod-livre-1,1,10) MATCHES (c-operacao-filtro + "*")) THEN
                NEXT.

        CREATE tt-ex-histor-alter.
        BUFFER-COPY bf{&TableName} TO tt-ex-histor-alter.    
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-realiza-exclusao-historico DBOProgram 
PROCEDURE pi-realiza-exclusao-historico :
/*------------------------------------------------------------------------------
  Purpose:  Realiza a exclus∆o do registro da tabela ex-histor-alter.
  Parameters:  pRowid : INPUT : Rowid do registro que ser† exclu°do.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pRowid AS ROWID NO-UNDO.

    /*--- Reposiciona rowid do registro corrente ---*/
    RUN emptyRowObject IN THIS-PROCEDURE.
    RUN emptyRowErrors IN THIS-PROCEDURE.
    RUN openQueryStatic IN THIS-PROCEDURE (INPUT "main":U).
    RUN repositionRecord IN THIS-PROCEDURE (INPUT pRowid).
    IF RETURN-VALUE = "NOK":U THEN NEXT.
    RUN getRecord IN THIS-PROCEDURE (OUTPUT TABLE rowObject).
    FIND FIRST rowObject NO-ERROR.
    IF NOT AVAIL rowObject THEN NEXT.

    /* Realiza a exclus∆o do registro */
    RUN deleteRecord IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltro DBOProgram 
PROCEDURE setConstraintFiltro :
/*------------------------------------------------------------------------------
  Purpose:     Parametros para filtro da query
  Parameters:  pc-tabela        -> Nome da tabela
               pc-campo         -> Nome dos Campos
               pc-chave         -> Chave da tabela
               pc-hora-ini      -> Hora de In°cio
               pc-hora-fim      -> Hora de Fim
               pc-usuario-ini   -> Usu†rio In°cio
               pc-usuario-fim   -> Usu†rio Fim
               pd-date-ini      -> Data de In°cio
               pd-date-fim      -> Data de Fim
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pc-tabela        AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAMETER pc-campo         AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAMETER pc-chave         AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAMETER pc-hora-ini      AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAMETER pc-hora-fim      AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAMETER pc-usuario-ini   AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAMETER pc-usuario-fim   AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAMETER pd-date-ini      AS DATE  FORMAT "99/99/9999"     NO-UNDO.
DEFINE INPUT PARAMETER pd-date-fim      AS DATE  FORMAT "99/99/9999"     NO-UNDO.
DEFINE INPUT PARAMETER pi-ordenacao     AS INTEGER     NO-UNDO.
DEFINE INPUT PARAMETER pi-operacao      AS INTEGER     NO-UNDO.

ASSIGN  c-tabela        = pc-tabela     
        c-campo         = pc-campo      
        c-chave         = pc-chave      
        c-hora-ini      = pc-hora-ini   
        c-hora-fim      = pc-hora-fim   
        c-usuario-ini   = pc-usuario-ini
        c-usuario-fim   = pc-usuario-fim
        d-date-ini      = pd-date-ini   
        d-date-fim      = pd-date-fim
        i-ordenacao     = pi-ordenacao
        i-operacao      = pi-operacao.

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

