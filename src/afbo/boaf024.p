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
{include/i-prgvrs.i BOAF024 2.00.00.005 } /*** "010005" 23/11/2023 16:19:39  ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOAF024
&GLOBAL-DEFINE DBOVersion 1.000.000.00
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName af-historico-alteracao
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
{afbo/boaf024.i RowObject}

{utp/ut-glob.i}.
/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{afp/afapi003.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF TEMP-TABLE ttAf-historico-alteracao NO-UNDO LIKE af-historico-alteracao.
/*FIELD r-rowid       AS ROWID.
FIELD c-desc-tabela LIKE af-historico-alteracao.nome-tabela
FIELD c-desc-campo  LIKE af-historico-alteracao.campo.*/

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
         HEIGHT             = 19.25
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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "chave":U THEN ASSIGN pFieldValue = RowObject.chave.
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        WHEN "hora-alter":U THEN ASSIGN pFieldValue = RowObject.hora-alter.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nome-tabela":U THEN ASSIGN pFieldValue = RowObject.nome-tabela.
        WHEN "prog-alter":U THEN ASSIGN pFieldValue = RowObject.prog-alter.
        WHEN "usuar-alter":U THEN ASSIGN pFieldValue = RowObject.usuar-alter.
        WHEN "vl-anterior":U THEN ASSIGN pFieldValue = RowObject.vl-anterior.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "seq":U THEN ASSIGN pFieldValue = RowObject.seq.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice seq-hist-alteracao
  Parameters:  
               retorna valor do campo seq
               retorna valor do campo ep-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pseq LIKE af-historico-alteracao.seq NO-UNDO.
    DEFINE OUTPUT PARAMETER pep-codigo LIKE af-historico-alteracao.ep-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pseq = RowObject.seq
           pep-codigo = RowObject.ep-codigo.

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
  Purpose:     Reposiciona registro com base no °ndice seq-hist-alteracao
  Parameters:  
               recebe valor do campo seq
               recebe valor do campo ep-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pseq LIKE af-historico-alteracao.seq NO-UNDO.
    DEFINE INPUT PARAMETER pep-codigo LIKE af-historico-alteracao.ep-codigo NO-UNDO.

    FIND FIRST bfaf-historico-alteracao WHERE 
        bfaf-historico-alteracao.seq = pseq AND 
        bfaf-historico-alteracao.ep-codigo = pep-codigo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfaf-historico-alteracao THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfaf-historico-alteracao)).
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
OPEN QUERY qr{&tableName} FOR EACH {&tableName} 
    WHERE {&tableName}.ep-codigo = v_cdn_empres_usuar NO-LOCK.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-next-sequence DBOProgram 
PROCEDURE pi-next-sequence :
/*------------------------------------------------------------------------------
  Purpose:     Retorna o pr¢ximo n£mero da sequància
  Parameters:  pseq -> retorna a sequància
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pseq LIKE af-historico-alteracao.seq NO-UNDO.
   
FOR LAST bf{&TableName}  FIELDS (seq) NO-LOCK
    WHERE bf{&TableName}.ep-codigo = v_cdn_empres_usuar
    BY  bf{&TableName}.seq:

    IF bf{&TableName}.seq = ? OR bf{&TableName}.seq = 0 THEN
        ASSIGN pseq = 1.
    ELSE
        ASSIGN pseq = bf{&TableName}.seq + 1.

END.

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
DEFINE OUTPUT PARAMETE TABLE FOR tt-af-historico-alteracao.
DEFINE VARIABLE c-tabela-filtro-ini AS CHARACTER  INIT ""  NO-UNDO.
DEFINE VARIABLE c-tabela-filtro-fim AS CHARACTER  INIT "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"  NO-UNDO.
DEFINE VARIABLE c-campo-filtro      AS CHARACTER  INIT "" NO-UNDO.
DEFINE VARIABLE c-chave-filtro-ini  AS CHARACTER  INIT "" NO-UNDO.
DEFINE VARIABLE c-chave-filtro-fim  AS CHARACTER  INIT "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" NO-UNDO.

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
IF TRIM(c-chave)<> "" THEN
    ASSIGN  c-chave-filtro-ini = c-chave
            c-chave-filtro-fim = c-chave.

EMPTY TEMP-TABLE tt-af-historico-alteracao.

CASE i-ordenacao:
    WHEN 1 THEN DO:
       RUN pi-processa-query-by-tabela(INPUT-OUTPUT TABLE tt-af-historico-alteracao,
                                       INPUT c-tabela-filtro-ini,
                                       INPUT c-tabela-filtro-fim,
                                       INPUT c-campo-filtro,
                                       INPUT c-chave-filtro-ini,
                                       INPUT c-chave-filtro-fim).
    END.
    WHEN 2 THEN DO:
        RUN pi-processa-query-by-datahora(INPUT-OUTPUT TABLE tt-af-historico-alteracao,
                                          INPUT c-tabela-filtro-ini,
                                          INPUT c-tabela-filtro-fim,
                                          INPUT c-campo-filtro,
                                          INPUT c-chave-filtro-ini,
                                          INPUT c-chave-filtro-fim).
    END.
    WHEN 3 THEN DO:
        RUN pi-processa-query-by-usuario(INPUT-OUTPUT TABLE tt-af-historico-alteracao,
                                         INPUT c-tabela-filtro-ini,
                                         INPUT c-tabela-filtro-fim,
                                         INPUT c-campo-filtro,
                                         INPUT c-chave-filtro-ini,
                                         INPUT c-chave-filtro-fim).
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
  Parameters:  ttAf-historico-alteracao -> retorna os valores do hist¢rico
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETE TABLE FOR tt-af-historico-alteracao.
DEFINE INPUT PARAMETER c-tabela-filtro-ini AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER c-tabela-filtro-fim AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER c-campo-filtro      AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER c-chave-filtro-ini  AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER c-chave-filtro-fim  AS CHARACTER  NO-UNDO.

FOR EACH bf{&TableName} NO-LOCK
    WHERE bf{&TableName}.ep-codigo = i-ep-codigo-usuario
    AND   bf{&TableName}.usuar-alter >= c-usuario-ini
    AND   bf{&TableName}.usuar-alter <= c-usuario-fim
    AND   bf{&TableName}.nome-tabela >= c-tabela-filtro-ini
    AND   bf{&TableName}.nome-tabela <= c-tabela-filtro-fim
    AND   bf{&TableName}.chave       >= c-chave-filtro-ini
    AND   bf{&TableName}.chave       <= c-chave-filtro-fim
    AND   bf{&TableName}.dt-alter >= d-date-ini
    AND   bf{&TableName}.dt-alter <= d-date-fim
    AND   bf{&TableName}.hora-alter >= c-hora-ini
    AND   bf{&TableName}.hora-alter <= c-hora-fim
    BY    bf{&TableName}.dt-alter
    BY    bf{&TableName}.hora-alter:
            
     /*Se os "campo" foi passado como filtro tem que verificar fora do select
        por causa da performace*/
    IF c-campo-filtro <> "" THEN
        IF  NOT (bf{&TableName}.campo MATCHES c-campo-filtro + "*") THEN
            NEXT.

    CREATE tt-af-historico-alteracao.
    BUFFER-COPY bf{&TableName} TO tt-af-historico-alteracao.    
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-processa-query-by-tabela DBOProgram 
PROCEDURE pi-processa-query-by-tabela :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para retornar a temp-table filtrados pelos parÉmetros
  Parameters:  ttAf-historico-alteracao -> retorna os valores do hist¢rico
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETE TABLE FOR tt-af-historico-alteracao.
DEFINE INPUT PARAMETER c-tabela-filtro-ini AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER c-tabela-filtro-fim AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER c-campo-filtro      AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER c-chave-filtro-ini  AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER c-chave-filtro-fim  AS CHARACTER  NO-UNDO.

FOR EACH bf{&TableName} NO-LOCK
    WHERE bf{&TableName}.ep-codigo = i-ep-codigo-usuario
    AND   bf{&TableName}.usuar-alter >= c-usuario-ini
    AND   bf{&TableName}.usuar-alter <= c-usuario-fim
    AND   bf{&TableName}.nome-tabela >= c-tabela-filtro-ini
    AND   bf{&TableName}.nome-tabela <= c-tabela-filtro-fim
    AND   bf{&TableName}.chave       >= c-chave-filtro-ini
    AND   bf{&TableName}.chave       <= c-chave-filtro-fim
    AND   bf{&TableName}.dt-alter >= d-date-ini
    AND   bf{&TableName}.dt-alter <= d-date-fim
    AND   bf{&TableName}.hora-alter >= c-hora-ini
    AND   bf{&TableName}.hora-alter <= c-hora-fim
    BY    bf{&TableName}.nome-tabela
    BY    bf{&TableName}.campo:
        
    /*Se os "campo" foi passado como filtro tem que verificar fora do select
        por causa da performace*/
    IF c-campo-filtro <> "" THEN
        IF  NOT (bf{&TableName}.campo MATCHES c-campo-filtro + "*") THEN
            NEXT.

    CREATE tt-af-historico-alteracao.
    BUFFER-COPY bf{&TableName} TO tt-af-historico-alteracao.    
END.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-processa-query-by-usuario DBOProgram 
PROCEDURE pi-processa-query-by-usuario :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para retornar a temp-table filtrados pelos parÉmetros
  Parameters:  ttAf-historico-alteracao -> retorna os valores do hist¢rico
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETE TABLE FOR tt-af-historico-alteracao.
DEFINE INPUT PARAMETER c-tabela-filtro-ini AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER c-tabela-filtro-fim AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER c-campo-filtro      AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER c-chave-filtro-ini  AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER c-chave-filtro-fim  AS CHARACTER  NO-UNDO.

FOR EACH bf{&TableName} NO-LOCK
    WHERE bf{&TableName}.ep-codigo = i-ep-codigo-usuario
    AND   bf{&TableName}.usuar-alter >= c-usuario-ini
    AND   bf{&TableName}.usuar-alter <= c-usuario-fim
    AND   bf{&TableName}.nome-tabela >= c-tabela-filtro-ini
    AND   bf{&TableName}.nome-tabela <= c-tabela-filtro-fim
    AND   bf{&TableName}.chave       >= c-chave-filtro-ini
    AND   bf{&TableName}.chave       <= c-chave-filtro-fim
    AND   bf{&TableName}.dt-alter >= d-date-ini
    AND   bf{&TableName}.dt-alter <= d-date-fim
    AND   bf{&TableName}.hora-alter >= c-hora-ini
    AND   bf{&TableName}.hora-alter <= c-hora-fim
    BY    bf{&TableName}.usuar-alter:
        
    /*Se os "campo" foi passado como filtro tem que verificar fora do select
        por causa da performace*/
    IF c-campo-filtro <> "" THEN
        IF  NOT (bf{&TableName}.campo MATCHES c-campo-filtro + "*") THEN
            NEXT.

    CREATE tt-af-historico-alteracao.
    BUFFER-COPY bf{&TableName} TO tt-af-historico-alteracao.    
END.


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
DEFINE INPUT PARAMETER pd-date-ini      AS DATE  FORMAT "99/99/9999"      NO-UNDO.
DEFINE INPUT PARAMETER pd-date-fim      AS DATE  FORMAT "99/99/9999"     NO-UNDO.
DEFINE INPUT PARAMETER pi-ordenacao     AS INTEGER     NO-UNDO.

ASSIGN  c-tabela        = pc-tabela     
        c-campo         = pc-campo      
        c-chave         = pc-chave      
        c-hora-ini      = pc-hora-ini   
        c-hora-fim      = pc-hora-fim   
        c-usuario-ini   = pc-usuario-ini
        c-usuario-fim   = pc-usuario-fim
        d-date-ini      = pd-date-ini   
        d-date-fim      = pd-date-fim
        i-ordenacao     = pi-ordenacao.

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

