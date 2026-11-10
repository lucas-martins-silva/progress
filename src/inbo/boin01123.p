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
{include/i-prgvrs.i BOIN01123 2.00.00.002 } /*** "010002" 01/12/2023 10:50:59  ***/

/* ***************************  Definitions  *******************************/

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01123
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName saldo-item-produto-lpd
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T Pre-processadores necess†rios para utilizar o DBO no MetaDados*/                                        
&GLOBAL-DEFINE KeyField1             dt-producao /*:T Informar os campos da chave da tabela, quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject.*/
&GLOBAL-DEFINE KeyField2             cod-estabel /*:T Informar os campos da chave da tabela, quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject.*/
&GLOBAL-DEFINE KeyField3             cod-produto /*:T Informar os campos da chave da tabela, quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject.*/
&GLOBAL-DEFINE KeyField4             it-codigo   /*:T Informar os campos da chave da tabela, quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject.*/
&GLOBAL-DEFINE XMLReceiver           YES           /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message)*/
/* &GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES */          

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
{inbo/boin01123.i RowObject}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE TEMP-TABLE tt-saldo-item-produto-lpd-aux NO-UNDO LIKE saldo-item-produto-lpd
       field r-rowid as rowid.

/*:T--- Definiá∆o variaveis open queries zooms ---*/
DEFINE VARIABLE dt-producao-ini   AS DATE      NO-UNDO.
DEFINE VARIABLE dt-producao-fim   AS DATE      NO-UNDO.
DEFINE VARIABLE c-cod-estabel-ini AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-produto-ini AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-produto-fim AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-it-codigo-ini   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-it-codigo-fim   AS CHARACTER NO-UNDO.

DEFINE VARIABLE dt-producao LIKE saldo-item-produto-lpd.dt-producao NO-UNDO.
DEFINE VARIABLE cod-estabel LIKE saldo-item-produto-lpd.cod-estabel NO-UNDO.
DEFINE VARIABLE cod-produto LIKE saldo-item-produto-lpd.cod-produto NO-UNDO.
DEFINE VARIABLE it-codigo   LIKE saldo-item-produto-lpd.it-codigo   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE NO

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
         HEIGHT             = 14.25
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*:T------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes: 
------------------------------------------------------------------------------*/

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-produto":U THEN ASSIGN pFieldValue = RowObject.cod-produto.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue   = RowObject.it-codigo.
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
        WHEN "dt-producao":U THEN ASSIGN pFieldValue = RowObject.dt-producao.
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

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice saldo-produto-lpd
  Parameters:  
               retorna valor do campo dt-producao cod-produto cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pdt-producao LIKE saldo-item-produto-lpd.dt-producao NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE saldo-item-produto-lpd.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-produto LIKE saldo-item-produto-lpd.cod-produto NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo   LIKE saldo-item-produto-lpd.it-codigo   NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pdt-producao = RowObject.dt-producao
           pcod-estabel = RowObject.cod-estabel
           pcod-produto = RowObject.cod-produto
           pit-codigo   = RowObject.it-codigo.

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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL   NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW       NO-UNDO.

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
  Purpose:     Reposiciona registro com base no °ndice saldo-produto-lpd
  Parameters:  
               recebe valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdt-producao LIKE saldo-item-produto-lpd.dt-producao NO-UNDO.
    DEFINE INPUT PARAMETER pcod-produto LIKE saldo-item-produto-lpd.cod-produto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE saldo-item-produto-lpd.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo   LIKE saldo-item-produto-lpd.it-codigo   NO-UNDO.

    FIND FIRST bfsaldo-item-produto-lpd
         WHERE bfsaldo-item-produto-lpd.dt-producao = pdt-producao
           AND bfsaldo-item-produto-lpd.cod-estabel = pcod-estabel
           AND bfsaldo-item-produto-lpd.cod-produto = pcod-produto
           AND bfsaldo-item-produto-lpd.it-codigo   = pit-codigo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfsaldo-item-produto-lpd THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfsaldo-item-produto-lpd)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
/*:T------------------------------------------------------------------------------
  Purpose: Procedure obrigat¢ria para execuá∆o via MetaDados
  Parameters:  <none>
  Notes: Para execuá∆o do DBO via Metadados Ç necess†rio que o DBO utilize a Procedure openQueryDefault para abrir a query principal do DBO.
         Esta Procedure pode ser customizada conforme necessidade do usu†rio.
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecordsCustomDataEstabProdutoItCodigo DBOProgram 
PROCEDURE getBatchRecordsCustomDataEstabProdutoItCodigo :

    DEFINE INPUT PARAMETER c-data-periodo AS CHAR                                 NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-estabel  LIKE item-estab-produto-lpd.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-produto  LIKE item-estab-produto-lpd.cod-produto NO-UNDO.
    DEFINE INPUT PARAMETER c-it-codigo    LIKE item-estab-produto-lpd.it-codigo   NO-UNDO.
    
    DEFINE OUTPUT PARAMETER TABLE FOR tt-saldo-item-produto-lpd-aux.

    DEFINE VARIABLE data-ini     AS DATE    NO-UNDO.
    DEFINE VARIABLE da-data      AS DATE    NO-UNDO.
    DEFINE VARIABLE da-data-fim  AS DATE    NO-UNDO.
    DEFINE VARIABLE de-saldo-fim-dia-ant AS DECIMAL NO-UNDO.
    DEFINE VARIABLE da-data-ini-per-ant  AS DATE    NO-UNDO.
    DEFINE VARIABLE da-data-fim-per-ant  AS DATE    NO-UNDO.

    DEF BUFFER b-saldo-item-produto-lpd FOR saldo-item-produto-lpd.

    DEFINE VARIABLE da-mensal-ate AS DATE  NO-UNDO.

    FIND FIRST param-estoq NO-LOCK NO-ERROR.
    IF  param-estoq.tp-fech = 1 /*fech por empresa*/ THEN
        ASSIGN da-mensal-ate = param-estoq.mensal-ate.
    ELSE DO:
        FIND FIRST estab-mat
             WHERE estab-mat.cod-estabel = c-cod-estabel NO-LOCK NO-ERROR.
        ASSIGN da-mensal-ate = estab-mat.mensal-ate.
    END.

    ASSIGN data-ini = DATE(INT(TRIM(SUBSTRING(c-data-periodo,6,7))), 01 ,INT(TRIM(SUBSTRING(c-data-periodo,1,4)))).

    FOR EACH tt-saldo-item-produto-lpd-aux:
        DELETE tt-saldo-item-produto-lpd-aux.
    END.
    
    IF MONTH(data-ini) = 12 THEN
        ASSIGN da-data-fim = DATE(01,01 , YEAR(data-ini) + 1) - 1.
    ELSE
        ASSIGN da-data-fim = DATE(MONTH(data-ini) + 1,01 , YEAR(data-ini)) - 1.
     
    /*--- INICIO - carregar saldo inicial com base no saldo final do periodo anterior ---*/
        
    // define faixa de datas para busca de registro com saldo
    ASSIGN da-data-fim-per-ant = data-ini - 1
           da-data-ini-per-ant = da-data-fim-per-ant - 1095.

    DO  da-data = da-data-fim-per-ant TO da-data-ini-per-ant BY -1:
        // localiza ultimo dia que possuia saldo no periodo anterior
        FOR FIRST b-saldo-item-produto-lpd
             WHERE b-saldo-item-produto-lpd.cod-estabel = c-cod-estabel  
               AND b-saldo-item-produto-lpd.cod-produto = c-cod-produto
               AND b-saldo-item-produto-lpd.it-codigo   = c-it-codigo  
               AND b-saldo-item-produto-lpd.dt-producao = da-data NO-LOCK: END.
    
        IF  AVAIL b-saldo-item-produto-lpd THEN DO:
            ASSIGN de-saldo-fim-dia-ant = b-saldo-item-produto-lpd.qtd-estoq-final.
            LEAVE.
        END.
    END.
    /*--- FIM - carregar saldo inicial com base no saldo final do periodo anterior ---*/

    DO  da-data = data-ini TO da-data-fim:
        CREATE tt-saldo-item-produto-lpd-aux.
        ASSIGN tt-saldo-item-produto-lpd-aux.dt-producao = da-data
               tt-saldo-item-produto-lpd-aux.cod-estabel = c-cod-estabel  
               tt-saldo-item-produto-lpd-aux.cod-produto = c-cod-produto
               tt-saldo-item-produto-lpd-aux.it-codigo   = c-it-codigo.

        FIND FIRST saldo-item-produto-lpd
             WHERE saldo-item-produto-lpd.cod-estabel = c-cod-estabel  
               AND saldo-item-produto-lpd.cod-produto = c-cod-produto
               AND saldo-item-produto-lpd.it-codigo   = c-it-codigo  
               AND saldo-item-produto-lpd.dt-producao = da-data EXCLUSIVE-LOCK NO-ERROR.

        IF  NOT AVAIL saldo-item-produto-lpd THEN DO:
            CREATE saldo-item-produto-lpd.
            ASSIGN saldo-item-produto-lpd.cod-estabel = c-cod-estabel 
                   saldo-item-produto-lpd.cod-produto = c-cod-produto 
                   saldo-item-produto-lpd.it-codigo   = c-it-codigo   
                   saldo-item-produto-lpd.dt-producao = da-data.
        END.

        /* atualiza somente registros de periodos em que o medio ainda nao foi calculado
           se jah foi calculado, mantem o que estah gravado na tabela */
        IF  saldo-item-produto-lpd.dt-producao > da-mensal-ate THEN
            ASSIGN saldo-item-produto-lpd.qtd-estoq-ini   = IF  de-saldo-fim-dia-ant > 0 THEN 
                                                                de-saldo-fim-dia-ant 
                                                            ELSE
                                                                saldo-item-produto-lpd.qtd-estoq-ini.

        ASSIGN saldo-item-produto-lpd.qtd-estoq-final = saldo-item-produto-lpd.qtd-estoq-ini + 
                                                        saldo-item-produto-lpd.qtd-produzida +
                                                        saldo-item-produto-lpd.qtd-ent-out   -
                                                        saldo-item-produto-lpd.qtd-saidas
               de-saldo-fim-dia-ant                   = saldo-item-produto-lpd.qtd-estoq-final.

        BUFFER-COPY saldo-item-produto-lpd TO tt-saldo-item-produto-lpd-aux.
 
    END.
    
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToProduto DBOProgram 
PROCEDURE linkToDataEstabProdutoItCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
    
    RUN getKey IN pHandle (OUTPUT dt-producao,
                           OUTPUT cod-estabel,
                           OUTPUT cod-produto,
                           OUTPUT it-codigo).   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByStatus DBOProgram 
PROCEDURE setConstraintByDataEstabProdutoItCodigo :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdt-dt-producao-ini AS DATE      NO-UNDO.
    DEFINE INPUT PARAMETER pdt-dt-producao-fim AS DATE      NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel-ini  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel-fim  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-produto-ini  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-produto-fim  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-it-codigo-ini    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-it-codigo-fim    AS CHARACTER NO-UNDO.

    
    ASSIGN dt-producao-ini   = pdt-dt-producao-ini
           dt-producao-fim   = pdt-dt-producao-fim
           c-cod-estabel-ini = pc-cod-estabel-ini
           c-cod-estabel-fim = pc-cod-estabel-fim
           c-cod-produto-ini = pc-cod-produto-ini
           c-cod-produto-fim = pc-cod-produto-fim
           c-it-codigo-ini   = pc-it-codigo-ini
           c-it-codigo-fim   = pc-it-codigo-fim        .

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

