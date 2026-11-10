&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
/* Connected Databases 
          emsdca           PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-af-versao-avaliacao NO-UNDO LIKE af-versao-avaliacao
       field r-rowid as rowid.



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
{include/i-prgvrs.i BOAF023 2.00.00.004 } /*** "010004" 23/11/2023 16:19:39  ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOAF023
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName af-versao-avaliacao
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
{afbo/boaf023.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*Include para pegar a empresa do usu†rio*/
{utp/ut-glob.i}.
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE VARIABLE i-ini-versao    LIKE af-versao-avaliacao.nr-versao     NO-UNDO.
DEFINE VARIABLE i-fim-versao    LIKE af-versao-avaliacao.nr-versao     NO-UNDO.
DEFINE VARIABLE c-ini-desc      LIKE af-versao-avaliacao.desc-versao   NO-UNDO.
DEFINE VARIABLE c-fim-desc      LIKE af-versao-avaliacao.desc-versao   NO-UNDO.
DEFINE VARIABLE i-ini-ano       LIKE af-versao-avaliacao.ano-avaliacao NO-UNDO.
DEFINE VARIABLE i-fim-ano       LIKE af-versao-avaliacao.ano-avaliacao NO-UNDO.
DEFINE VARIABLE i-ini-periodo   LIKE af-versao-avaliacao.nr-periodo    NO-UNDO.
DEFINE VARIABLE i-fim-periodo   LIKE af-versao-avaliacao.nr-periodo    NO-UNDO.

DEFINE TEMP-TABLE tt-versao-data NO-UNDO
    FIELD nr-versao      LIKE {&TableName}.nr-versao
    FIELD desc-versao    LIKE {&TableName}.desc-versao
    FIELD ano-avaliacao  LIKE {&TableName}.ano-avaliacao
    FIELD nr-periodo     LIKE {&TableName}.nr-periodo
    FIELD data-ini       AS DATE
    FIELD data-fim       AS DATE
    INDEX data-inicial
          data-ini.

DEFINE TEMP-TABLE tt-ano NO-UNDO
        FIELD ano       AS INTEGER
        FIELD ep-codigo AS CHAR
        INDEX ano_ord ano.

DEFINE TEMP-TABLE tt-periodo NO-UNDO
    FIELD ano       AS INTEGER
    FIELD periodo   AS INTEGER
    FIELD nr-versao AS INTEGER
    INDEX periodo_ord periodo.

DEFINE VARIABLE ano-busca       AS INTEGER NO-UNDO.
DEFINE VARIABLE ep-codigo-busca AS CHAR NO-UNDO.
DEFINE VARIABLE periodo-busca   AS INTEGER NO-UNDO.
DEFINE VARIABLE h-boaf022 AS HANDLE      NO-UNDO.

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
   Temp-Tables and Buffers:
      TABLE: tt-af-versao-avaliacao T "?" NO-UNDO emsdca af-versao-avaliacao
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 14.08
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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "desc-versao":U THEN ASSIGN pFieldValue = RowObject.desc-versao.
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
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
        WHEN "ano-avaliacao":U THEN ASSIGN pFieldValue = RowObject.ano-avaliacao.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-periodo":U THEN ASSIGN pFieldValue = RowObject.nr-periodo.
        WHEN "nr-versao":U THEN ASSIGN pFieldValue = RowObject.nr-versao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice seq-versao
  Parameters:  
               retorna valor do campo nr-versao
               retorna valor do campo ep-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-versao LIKE af-versao-avaliacao.nr-versao NO-UNDO.
    DEFINE OUTPUT PARAMETER pep-codigo LIKE af-versao-avaliacao.ep-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-versao = RowObject.nr-versao
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
  Purpose:     Reposiciona registro com base no °ndice seq-versao
  Parameters:  
               recebe valor do campo nr-versao
               recebe valor do campo ep-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-versao LIKE af-versao-avaliacao.nr-versao NO-UNDO.
    DEFINE INPUT PARAMETER pep-codigo LIKE af-versao-avaliacao.ep-codigo NO-UNDO.

    FIND FIRST bfaf-versao-avaliacao WHERE 
        bfaf-versao-avaliacao.nr-versao = pnr-versao AND 
        bfaf-versao-avaliacao.ep-codigo = pep-codigo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfaf-versao-avaliacao THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfaf-versao-avaliacao)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryVersao DBOProgram 
PROCEDURE openQueryVersao :
/*------------------------------------------------------------------------------
  Purpose:     Query para a leitura da tabela af-versao-avaliacao com os 
                parÉmetros de filtro
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY qr{&tableName} FOR EACH {&tableName} 
        WHERE ({&tableName}.nr-versao >= i-ini-versao AND {&tableName}.nr-versao <= i-fim-versao)
        AND ({&tableName}.desc-versao >= c-ini-desc AND {&tableName}.desc-versao <= c-fim-desc)
        AND ({&tableName}.ano-avaliacao >= i-ini-ano AND {&tableName}.ano-avaliacao <= i-fim-ano)
        AND (({&tableName}.ano-avaliacao = i-ini-ano AND {&tableName}.nr-periodo >= i-ini-periodo)
        OR  ({&tableName}.ano-avaliacao = i-fim-ano AND {&tableName}.nr-periodo <= i-fim-periodo)
        OR  ({&tableName}.ano-avaliacao <> i-ini-ano AND {&tableName}.ano-avaliacao <> i-fim-ano))
        AND ({&tableName}.ep-codigo = v_cdn_empres_usuar ) NO-LOCK.         

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-existe-versao DBOProgram 
PROCEDURE pi-existe-versao :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para verificar se existe alguma vers∆o cadastrada para 
                o ano espec°fico
  Parameters:  pi-ano = Ano para filtro na verificaá∆o da vers∆o
               pc-retorno = Retorno da Procedure "OK" existe, "NOK" n∆o existe.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-ano AS INTEGER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-retorno AS CHARACTER NO-UNDO.    

    IF CAN-FIND (FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.ep-codigo = v_cdn_empres_usuar
                 AND   bf{&TableName}.ano-avaliacao = pi-ano)   THEN
        ASSIGN pc-retorno = "OK":U.
    ELSE
        ASSIGN pc-retorno = "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-menor-versao DBOProgram 
PROCEDURE pi-menor-versao :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para retornar uma vers∆o espec°fica.
  Parameters:  pi-ano = Ano para filtro na busca da vers∆o
               pi-nr-periodo = Per°odo para filtro busca da vers∆o
               pi-versao = N£mero da vers∆o que ser† retornado.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-ano AS INTEGER  NO-UNDO.
    DEFINE INPUT PARAMETER pi-nr-periodo AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-versao AS INTEGER NO-UNDO.    

    FIND FIRST bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.ep-codigo = v_cdn_empres_usuar
        AND   bf{&TableName}.ano-avaliacao = pi-ano
        AND   bf{&TableName}.nr-periodo = pi-nr-periodo NO-ERROR.

    IF AVAIL bf{&TableName} THEN
        ASSIGN pi-versao = bf{&TableName}.nr-versao.        
    ELSE
        RETURN "NOK":U.    
                   
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-menor-versao DBOProgram 
PROCEDURE pi-retorna-menor-versao :
/*------------------------------------------------------------------------------
  Purpose:     Retorna a menor vers∆o existente
  Parameters:  retorna o valor da vers∆o
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pnr-versao LIKE af-versao-avaliacao.nr-versao NO-UNDO.
DEFINE VARIABLE i-ano-ini AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-ano-fim AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-existe-registro AS LOGICAL INIT FALSE    NO-UNDO.

IF CAN-FIND(bf{&TableName} NO-LOCK
            WHERE bf{&TableName}.ep-codigo = v_cdn_empres_usuar
            AND   bf{&TableName}.nr-versao = 0) THEN DO:
    ASSIGN pnr-versao = 0
           l-existe-registro = TRUE.
END.
ELSE DO:    
    FOR EACH bf{&TableName} NO-LOCK
        WHERE   bf{&TableName}.ep-codigo = v_cdn_empres_usuar
        BY      bf{&TableName}.ano-avaliacao
        BY      bf{&TableName}.nr-periodo:
        ASSIGN pnr-versao = bf{&TableName}.nr-versao
               l-existe-registro = TRUE.
        LEAVE.
    END. 
END.

IF NOT l-existe-registro THEN
    RETURN "NOK":U.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ultimo-registro DBOProgram 
PROCEDURE pi-ultimo-registro :
/*------------------------------------------------------------------------------
  Purpose:     Retornar o ultimo n£mero de vers∆o
  Parameters:  pnr-versao retorna a ultima vers∆o
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pnr-versao LIKE af-versao-avaliacao.nr-versao NO-UNDO.

    ASSIGN pnr-versao = 0.

    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.ep-codigo = v_cdn_empres_usuar
        BY bf{&TableName}.nr-versao DESCENDING:

        ASSIGN pnr-versao = bf{&TableName}.nr-versao.
        LEAVE.
    END.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaVersaoPeriodo DBOProgram 
PROCEDURE piRetornaVersaoPeriodo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  p-periodo - recebe o per°odo
               p-ep-codigo - recebe o codigo da empresa
               p-nr-versao - retorna o numero da vers∆o referente ao per°odo/empresa recebidos por parametros.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE  INPUT PARAMETER p-periodo AS CHAR NO-UNDO.
    DEFINE  INPUT PARAMETER p-ep-codigo LIKE af-versao-avaliacao.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER p-nr-versao LIKE af-versao-avaliacao.nr-versao NO-UNDO.

    ASSIGN ano-busca       = INT(ENTRY(2,p-periodo,"/")) /*int(SUBSTRING(p-periodo,3,4))*/
           periodo-busca   = INT(ENTRY(1,p-periodo,"/")) /*int(substring(p-periodo,1,2))*/
           ep-codigo-busca = p-ep-codigo.

    FOR EACH af-versao-avaliacao NO-LOCK:
        IF NOT CAN-FIND(FIRST tt-ano
                            WHERE tt-ano.ano       = af-versao-avaliacao.ano-avaliacao
                            AND   tt-ano.ep-codigo = af-versao-avaliacao.ep-codigo) THEN DO:
            CREATE tt-ano.
            ASSIGN tt-ano.ano       = af-versao-avaliacao.ano-avaliacao
                   tt-ano.ep-codigo = af-versao-avaliacao.ep-codigo.
        END.
    END.

    FOR EACH tt-ano,
        EACH af-versao-avaliacao NO-LOCK
            WHERE af-versao-avaliacao.ano-avaliacao = tt-ano.ano
            AND   af-versao-avaliacao.ep-codigo     = tt-ano.ep-codigo:
        IF NOT CAN-FIND(FIRST tt-periodo
                            WHERE tt-periodo.ano     = af-versao-avaliacao.ano-avaliacao
                            AND   tt-periodo.periodo = af-versao-avaliacao.nr-periodo) THEN DO:
            CREATE tt-periodo.
            ASSIGN tt-periodo.ano       = af-versao-avaliacao.ano-avaliacao
                   tt-periodo.periodo   = af-versao-avaliacao.nr-periodo
                   tt-periodo.nr-versao = af-versao-avaliacao.nr-versao.
        END.

    END.

    FIND FIRST tt-ano 
        WHERE tt-ano.ano       = ano-busca
        AND   tt-ano.ep-codigo = p-ep-codigo NO-ERROR.
    
    IF AVAIL tt-ano THEN DO:
        FIND FIRST tt-periodo 
            WHERE tt-periodo.ano     = tt-ano.ano
            AND   tt-periodo.periodo = periodo-busca NO-ERROR.
    
        IF AVAIL tt-periodo THEN
            ASSIGN p-nr-versao = tt-periodo.nr-versao.
        ELSE DO:
            FIND LAST tt-periodo
                WHERE tt-periodo.ano     = tt-ano.ano
                AND   tt-periodo.periodo < periodo-busca NO-ERROR.
            IF AVAIL tt-periodo THEN
                ASSIGN p-nr-versao = tt-periodo.nr-versao.
            ELSE DO:
                FIND LAST tt-ano 
                    WHERE tt-ano.ano < ano-busca NO-ERROR.
                IF AVAIL tt-ano THEN DO:
                    FIND LAST tt-periodo 
                        WHERE tt-periodo.ano = tt-ano.ano NO-ERROR.
                    IF AVAIL tt-periodo THEN
                        ASSIGN p-nr-versao = tt-periodo.nr-versao.
                END.
            END.
        END.
    END.
    ELSE DO:
        FIND LAST tt-ano 
            WHERE tt-ano.ano < ano-busca NO-ERROR.
        IF AVAIL tt-ano THEN DO:
            FIND LAST tt-periodo 
                WHERE tt-periodo.ano = tt-ano.ano NO-ERROR.
            IF AVAIL tt-periodo THEN
                ASSIGN p-nr-versao = tt-periodo.nr-versao.
        END.
    END.
    
    
   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaVersoesData DBOProgram 
PROCEDURE piRetornaVersoesData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE  INPUT PARAMETER pep-codigo LIKE af-versao-avaliacao.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-versao-data.

    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.ep-codigo = pep-codigo:
        CREATE tt-versao-data.
        BUFFER-COPY bf{&TableName} TO tt-versao-data.
        
        FOR FIRST af-periodo-aval NO-LOCK
            WHERE af-periodo-aval.ano-avaliacao = bf{&TableName}.ano-avaliacao
            AND   af-periodo-aval.ep-codigo     = bf{&TableName}.ep-codigo:
            
            ASSIGN tt-versao-data.data-ini   = af-periodo-aval.dt-periodo-ini[bf{&TableName}.nr-periodo].
        END.
    END.

    /* carregar a data-fim */
    DEFINE BUFFER bftt-versao-data FOR tt-versao-data.
    FOR EACH tt-versao-data EXCLUSIVE-LOCK:
    
        FIND FIRST bftt-versao-data 
            WHERE bftt-versao-data.nr-versao = tt-versao-data.nr-versao NO-LOCK NO-ERROR.
        /* Buscar o per°odo seguinte, pois a data de in°cio dele determina a data de tÇrmino do per°odo anterior*/
        FIND NEXT bftt-versao-data NO-LOCK NO-ERROR.
    
        IF AVAIL bftt-versao-data THEN DO:
            ASSIGN tt-versao-data.data-fim = bftt-versao-data.data-ini - 1.
        END.
        ELSE DO:
            ASSIGN tt-versao-data.data-fim = 12/31/9999.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintVersao DBOProgram 
PROCEDURE setConstraintVersao :
/*------------------------------------------------------------------------------
  Purpose:      Passar os ParÉmetros de inicio e fim da vers∆o
  Parameters:   i-ini-ver = faixa inicial de seleá∆o da vers∆o
                i-fim-ver = faixa final de seleá∆o da vers∆o
                c-ini-desc-ver = faixa inicial de seleá∆o de descriá∆o 
                c-fim-desc-ver = faixa final de seleá∆o de descriá∆o
                i-ini-ano-aval = faixa inicial de seleá∆o do ano de avaliaá∆o
                i-fim-ano-aval = faixa final de seleá∆o do ano de avaliaá∆o
                i-ini-nrPeriodo = faixa inicial de seleá∆o do per°odo
                i-fim-nrPeriodo = faixa final de seleá∆o  do per°odo
                
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM i-ini-ver        LIKE af-versao-avaliacao.nr-versao      NO-UNDO.   
DEFINE INPUT PARAM i-fim-ver        LIKE af-versao-avaliacao.nr-versao      NO-UNDO.
DEFINE INPUT PARAM c-ini-desc-ver   LIKE af-versao-avaliacao.desc-versao    NO-UNDO.
DEFINE INPUT PARAM c-fim-desc-ver   LIKE af-versao-avaliacao.desc-versao    NO-UNDO.
DEFINE INPUT PARAM i-ini-ano-aval   LIKE af-versao-avaliacao.ano-avaliacao  NO-UNDO.
DEFINE INPUT PARAM i-fim-ano-aval   LIKE af-versao-avaliacao.ano-avaliacao  NO-UNDO.
DEFINE INPUT PARAM i-ini-nrPeriodo  LIKE af-versao-avaliacao.nr-periodo     NO-UNDO.
DEFINE INPUT PARAM i-fim-nrPeriodo  LIKE af-versao-avaliacao.nr-periodo     NO-UNDO.

ASSIGN i-ini-versao     = i-ini-ver
       i-fim-versao     = i-fim-ver
       i-ini-ano        = i-ini-ano-aval
       i-fim-ano        = i-fim-ano-aval
       c-ini-desc       = c-ini-desc-ver
       c-fim-desc       = c-fim-desc-ver
       i-ini-periodo    = i-ini-nrPeriodo
       i-fim-periodo    = i-fim-nrPeriodo.

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
    IF pType = "CREATE":U THEN DO:
        IF NOT VALID-HANDLE(h-boaf022) THEN DO:
            RUN afbo/boaf022.p PERSISTENT SET h-boaf022.
        END.    
        RUN openQueryStatic IN h-boaf022 (INPUT "Main":U) NO-ERROR.

        DEFINE VARIABLE l-usa-versao AS LOGICAL     NO-UNDO.
        RUN getLogField IN h-boaf022 (INPUT "log-usa-versao":U, OUTPUT l-usa-versao).

        IF NOT l-usa-versao THEN DO:
            IF RowObject.nr-versao <> 0 THEN DO:
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter-informar-um-codigo-de-versao-d AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "informar_um_c¢digo_de_vers∆o_diferente_de_zero_(0)_sem_utilizar_o_controle_de_vers‰es" *}
                 ASSIGN c-lbl-liter-informar-um-codigo-de-versao-d = TRIM(RETURN-VALUE).
                 {method/svc/errors/inserr.i &ErrorNumber="33073"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-lbl-liter-informar-um-codigo-de-versao-d + '.'"}
            END.
        END.

        IF VALID-HANDLE(h-boaf022) THEN DO:
            DELETE PROCEDURE h-boaf022.
            ASSIGN h-boaf022 = ?.
        END.
    END.

    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
        IF TRIM(RowObject.desc-versao) = "" THEN
            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-da-versao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "da_vers∆o" *}
            ASSIGN c-lbl-liter-da-versao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="16983"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="c-lbl-liter-da-versao"}
            END. 
        
        IF CAN-FIND (FIRST af-versao-avaliacao NO-LOCK
                    WHERE af-versao-avaliacao.ep-codigo = RowObject.ep-codigo 
                    AND af-versao-avaliacao.nr-versao <> RowObject.nr-versao
                    AND af-versao-avaliacao.ano-avaliacao = RowObject.ano-avaliacao 
                    AND af-versao-avaliacao.nr-periodo = RowObject.nr-periodo) THEN
            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-versao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Vers∆o" *}
            ASSIGN c-lbl-liter-versao = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-ano-e-periodo AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "ano_e_per°odo" *}
            ASSIGN c-lbl-liter-ano-e-periodo = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="32682"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="c-lbl-liter-versao + '~~~~' + c-lbl-liter-ano-e-periodo"}
            END. 
                
            IF pType = "CERATE":U THEN DO:
                IF CAN-FIND (FIRST af-versao-avaliacao NO-LOCK
                    WHERE af-versao-avaliacao.ep-codigo = RowObject.ep-codigo 
                    AND af-versao-avaliacao.nr-versao = RowObject.nr-versao) THEN
                    /* Inicio -- Projeto Internacional */
                    DO:
                    DEFINE VARIABLE c-lbl-liter-versoes AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Vers‰es" *}
                    ASSIGN c-lbl-liter-versoes = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-codigo AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "c¢digo" *}
                    ASSIGN c-lbl-liter-codigo = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="32682"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="c-lbl-liter-versoes + '~~~~' + c-lbl-liter-codigo"}
                    END. 

                IF CAN-FIND (FIRST param-af NO-LOCK
                    WHERE param-af.log-usa-versao = NO
                    AND param-af.ep-codigo = RowObject.ep-codigo) THEN DO:

                    IF RowObject.nr-versao <> 0 THEN
                        /* Inicio -- Projeto Internacional */
                        DO:
                        DEFINE VARIABLE c-lbl-liter-parametro-utiliza-controle-de AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "ParÉmetro_Utiliza_controle_de_vers∆o" *}
                        ASSIGN c-lbl-liter-parametro-utiliza-controle-de = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-marcado-no-programa-af0101 AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "marcado_no_programa_AF0101" *}
                        ASSIGN c-lbl-liter-marcado-no-programa-af0101 = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="17187"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="c-lbl-liter-parametro-utiliza-controle-de + '~~~~' + c-lbl-liter-marcado-no-programa-af0101"}
                        END.   
                END.
            END.
    END.        
    ELSE DO:
        IF CAN-FIND (FIRST af-familia-contr NO-LOCK
                    WHERE af-familia-contr.ep-codigo = RowObject.ep-codigo 
                    AND af-familia-contr.nr-versao = RowObject.nr-versao) THEN

            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-versao-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Vers∆o" *}
            ASSIGN c-lbl-liter-versao-2 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-familia-avaliacao-fornecedor AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Fam°lia_Avaliaá∆o_Fornecedor" *}
            ASSIGN c-lbl-liter-familia-avaliacao-fornecedor = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="5"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="c-lbl-liter-versao-2 + '~~~~' + c-lbl-liter-familia-avaliacao-fornecedor"}
            END. 
                
        IF CAN-FIND (FIRST af-item-contr NO-LOCK
                    WHERE af-item-contr.ep-codigo = RowObject.ep-codigo 
                    AND af-item-contr.nr-versao = RowObject.nr-versao) THEN

            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-versao-3 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Vers∆o" *}
            ASSIGN c-lbl-liter-versao-3 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-item-avaliacao-fornecedor AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item_Avaliaá∆o_Fornecedor" *}
            ASSIGN c-lbl-liter-item-avaliacao-fornecedor = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="5"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="c-lbl-liter-versao-3 + '~~~~' + c-lbl-liter-item-avaliacao-fornecedor"}
            END. 

        IF CAN-FIND (FIRST af-item-contr-estab NO-LOCK
                    WHERE af-item-contr-estab.ep-codigo = RowObject.ep-codigo 
                    AND af-item-contr-estab.nr-versao = RowObject.nr-versao) THEN

            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-versao-4 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Vers∆o" *}
            ASSIGN c-lbl-liter-versao-4 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-item-estabelicimento-avaliacao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item_Estabelicimento_Avaliaá∆o_Fornecedor" *}
            ASSIGN c-lbl-liter-item-estabelicimento-avaliacao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="5"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="c-lbl-liter-versao-4 + '~~~~' + c-lbl-liter-item-estabelicimento-avaliacao"}
            END. 
                
        IF CAN-FIND (FIRST af-grp-avaliacao NO-LOCK
                    WHERE af-grp-avaliacao.ep-codigo = RowObject.ep-codigo 
                    AND af-grp-avaliacao.nr-versao = RowObject.nr-versao) THEN

            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-versao-5 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Vers∆o" *}
            ASSIGN c-lbl-liter-versao-5 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-grupo-de-avaliacao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Grupo_de_Avaliaá∆o" *}
            ASSIGN c-lbl-liter-grupo-de-avaliacao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="5"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="c-lbl-liter-versao-5 + '~~~~' + c-lbl-liter-grupo-de-avaliacao"}
            END. 
                
        IF CAN-FIND (FIRST af-contr-indice NO-LOCK
                    WHERE af-contr-indice.ep-codigo = RowObject.ep-codigo 
                    AND af-contr-indice.nr-versao = RowObject.nr-versao) THEN

            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-versao-6 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Vers∆o" *}
            ASSIGN c-lbl-liter-versao-6 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-indice AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "÷ndice" *}
            ASSIGN c-lbl-liter-indice = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="5"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="c-lbl-liter-versao-6 + '~~~~' + c-lbl-liter-indice"}
            END. 
                
       IF CAN-FIND (FIRST af-faixa-demerito NO-LOCK
                    WHERE af-faixa-demerito.ep-codigo =  RowObject.ep-codigo 
                    AND   af-faixa-demerito.nr-versao = RowObject.nr-versao) THEN
            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-versao-7 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Vers∆o" *}
            ASSIGN c-lbl-liter-versao-7 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-faixas-de-demerito AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Faixas_de_demÇrito" *}
            ASSIGN c-lbl-liter-faixas-de-demerito = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="5"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="c-lbl-liter-versao-7 + '~~~~' + c-lbl-liter-faixas-de-demerito"}
            END.          
            
       IF CAN-FIND (FIRST af-formula NO-LOCK
                    WHERE af-formula.ep-codigo =  RowObject.ep-codigo 
                    AND   af-formula.nr-versao = RowObject.nr-versao) THEN
            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-versao-8 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Vers∆o" *}
            ASSIGN c-lbl-liter-versao-8 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-formulas-de-calculo AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "F¢rmulas_de_c†lculo" *}
            ASSIGN c-lbl-liter-formulas-de-calculo = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="5"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="c-lbl-liter-versao-8 + '~~~~' + c-lbl-liter-formulas-de-calculo"}
            END.         
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

