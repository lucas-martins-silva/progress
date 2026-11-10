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
{include/i-prgvrs.i BOIN01122 2.00.00.003 } /*** "010003" 20/12/2023 16:18:38 ***/

/* ***************************  Definitions  *******************************/

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01122
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName saldo-produto-lpd
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T Pre-processadores necess†rios para utilizar o DBO no MetaDados*/                                        
&GLOBAL-DEFINE KeyField1             dt-producao /*:T Informar os campos da chave da tabela, quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject.*/
&GLOBAL-DEFINE KeyField2             cod-produto /*:T Informar os campos da chave da tabela, quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject.*/
&GLOBAL-DEFINE KeyField3             cod-estabel /*:T Informar os campos da chave da tabela, quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject.*/
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
{inbo/boin01122.i RowObject}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE TEMP-TABLE tt-saldo-produto-lpd-aux NO-UNDO LIKE saldo-produto-lpd
       field r-rowid as rowid.

DEFINE TEMP-TABLE tt-saldo-produto-lpd NO-UNDO LIKE saldo-produto-lpd
       field r-rowid as rowid.

DEFINE TEMP-TABLE tt-saldo-item-produto-lpd NO-UNDO LIKE saldo-item-produto-lpd
       field r-rowid as rowid.


{cdp/cd0669.i} //tt-erro

/*:T--- Definiá∆o variaveis open queries zooms ---*/
DEFINE VARIABLE dt-producao-ini   AS DATE      NO-UNDO.
DEFINE VARIABLE dt-producao-fim   AS DATE      NO-UNDO.
DEFINE VARIABLE c-cod-estabel-ini AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-produto-ini AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-produto-fim AS CHARACTER NO-UNDO.
DEFINE VARIABLE dt-producao LIKE saldo-produto-lpd.dt-producao NO-UNDO.
DEFINE VARIABLE cod-produto LIKE saldo-produto-lpd.cod-produto NO-UNDO.
DEFINE VARIABLE cod-estabel LIKE saldo-produto-lpd.cod-estabel NO-UNDO.

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
    DEFINE OUTPUT PARAMETER pdt-producao LIKE saldo-produto-lpd.dt-producao NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-produto LIKE saldo-produto-lpd.cod-produto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE saldo-produto-lpd.cod-estabel NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pdt-producao = RowObject.dt-producao
           pcod-produto = RowObject.cod-produto
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
    DEFINE INPUT PARAMETER pdt-producao LIKE saldo-produto-lpd.dt-producao NO-UNDO.
    DEFINE INPUT PARAMETER pcod-produto LIKE saldo-produto-lpd.cod-produto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE saldo-produto-lpd.cod-estabel NO-UNDO.

    FIND FIRST bfsaldo-produto-lpd
         WHERE bfsaldo-produto-lpd.dt-producao = pdt-producao
           AND bfsaldo-produto-lpd.cod-produto = pcod-produto
           AND bfsaldo-produto-lpd.cod-estabel = pcod-estabel NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfsaldo-produto-lpd THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfsaldo-produto-lpd)).
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecordsCustomItemEstabProduto DBOProgram 
PROCEDURE getBatchRecordsCustomDataProdutoEstab :

    DEFINE INPUT PARAMETER c-data-periodo AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-saldo-produto-lpd-aux.

    DEFINE VARIABLE data-ini     AS DATE NO-UNDO.
    DEFINE VARIABLE da-data      AS DATE NO-UNDO.
    DEFINE VARIABLE da-data-fim  AS DATE NO-UNDO.

    ASSIGN data-ini = DATE(INT(TRIM(SUBSTRING(c-data-periodo,6,7))), 01 ,INT(TRIM(SUBSTRING(c-data-periodo,1,4)))).

    FOR EACH tt-saldo-produto-lpd-aux:
        DELETE tt-saldo-produto-lpd-aux.
    END.
    
    IF MONTH(data-ini) = 12 THEN
        ASSIGN da-data-fim = DATE(01,01 , YEAR(data-ini) + 1) - 1.
    ELSE
        ASSIGN da-data-fim = DATE(MONTH(data-ini) + 1,01 , YEAR(data-ini)) - 1.
    
    
    DO da-data = data-ini TO da-data-fim:
        CREATE tt-saldo-produto-lpd-aux.
        ASSIGN tt-saldo-produto-lpd-aux.dt-producao = da-data.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToProduto DBOProgram 
PROCEDURE linkToDataProdutoEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
    
    RUN getKey IN pHandle (OUTPUT dt-producao,
                           OUTPUT cod-produto,
                           OUTPUT cod-estabel).   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByStatus DBOProgram 
PROCEDURE setConstraintByDataProdutoEstab :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pdt-dt-producao-ini AS DATE      NO-UNDO.
    DEFINE INPUT PARAMETER pdt-dt-producao-fim AS DATE      NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-produto-ini  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-produto-fim  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel-ini  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel-fim  AS CHARACTER NO-UNDO.
    
    ASSIGN dt-producao-ini   = pdt-dt-producao-ini
           dt-producao-fim   = pdt-dt-producao-fim
           c-cod-estabel-ini = pc-cod-estabel-ini
           c-cod-estabel-fim = pc-cod-estabel-fim
           c-cod-produto-ini = pc-cod-produto-ini
           c-cod-produto-fim = pc-cod-produto-fim.

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

PROCEDURE eliminaVinculoProdutoLPD:

    DEF INPUT PARAM pc-cod-estabel LIKE estab-produto-lpd.cod-estabel NO-UNDO.
    DEF INPUT PARAM pc-cod-produto LIKE estab-produto-lpd.cod-produto NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-erro.

    FOR EACH  estab-produto-lpd
        WHERE estab-produto-lpd.cod-estabel = pc-cod-estabel 
          AND estab-produto-lpd.cod-produto = pc-cod-produto EXCLUSIVE-LOCK:

        /*--- nao elimina caso tenha sido digitada alguma quantidade ---*/
        IF  CAN-FIND(FIRST saldo-produto-lpd
                     WHERE saldo-produto-lpd.cod-estabel = estab-produto-lpd.cod-estabel
                       AND saldo-produto-lpd.cod-produto = estab-produto-lpd.cod-produto
                       AND ( saldo-produto-lpd.observacao <> ""
                           OR (saldo-produto-lpd.qtd-cana-moida      +
                               saldo-produto-lpd.qtd-consumo         + 
                               saldo-produto-lpd.qtd-ent-anid-hidrat + 
                               saldo-produto-lpd.qtd-ent-out         + 
                               saldo-produto-lpd.qtd-estoq-final     + 
                               saldo-produto-lpd.qtd-estoq-ini       + 
                               saldo-produto-lpd.qtd-ini-mel         + 
                               saldo-produto-lpd.qtd-perda           + 
                               saldo-produto-lpd.qtd-prod-alc-mel    +
                               saldo-produto-lpd.qtd-prod-mel        +
                               saldo-produto-lpd.qtd-produzida       +
                               saldo-produto-lpd.qtd-sai-anid-hidrat +
                               saldo-produto-lpd.qtd-saidas          + 
                               saldo-produto-lpd.qtd-utiliz-mel) > 0)) THEN DO:

            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "N∆o foi poss°vel desvincular o produto LPD com o estab: " + estab-produto-lpd.cod-estabel
                   tt-erro.cd-erro  = 30639
                   tt-erro.c-param  = "desvincular o estabelec " + estab-produto-lpd.cod-estabel + "~~" + 
                                      "Existe quantidade informada para o produto no Estab " + estab-produto-lpd.cod-estabel +
                                      "Para desvincular n∆o pode ter valor informado em nenhum per°odo. Verifique tambÇm o campo Observaá∆o":U.

            NEXT.
        END.

        FOR EACH  saldo-produto-lpd EXCLUSIVE-LOCK                                            
            WHERE saldo-produto-lpd.cod-estabel = estab-produto-lpd.cod-estabel     
              AND saldo-produto-lpd.cod-produto = estab-produto-lpd.cod-produto:
            DELETE saldo-produto-lpd.
        END.

        FOR EACH item-estab-produto-lpd EXCLUSIVE-LOCK
            WHERE item-estab-produto-lpd.cod-produto = estab-produto-lpd.cod-produto
              AND item-estab-produto-lpd.cod-estabel = estab-produto-lpd.cod-estabel:
            DELETE item-estab-produto-lpd.
        END.

        FOR EACH saldo-item-produto-lpd EXCLUSIVE-LOCK
            WHERE saldo-item-produto-lpd.cod-produto = estab-produto-lpd.cod-produto
              AND saldo-item-produto-lpd.cod-estabel = estab-produto-lpd.cod-estabel:
            DELETE saldo-item-produto-lpd.
        END.

        FOR EACH tt-erro:
            DELETE tt-erro.
        END.

        CREATE tt-erro.
        ASSIGN tt-erro.mensagem = "Eliminaá∆o da Integraá∆o Estab " + estab-produto-lpd.cod-estabel + " com produto " + estab-produto-lpd.cod-produto +  " realizada com sucesso!"
               tt-erro.cd-erro  = 56200
               tt-erro.c-param  = "Eliminaá∆o da Integraá∆o Estab " + estab-produto-lpd.cod-estabel + " com produto " + estab-produto-lpd.cod-produto.

        DELETE estab-produto-lpd.

    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE geraVinculoProdutoLPD:

    DEF INPUT PARAM pc-cod-estabel LIKE estab-produto-lpd.cod-estabel NO-UNDO.
    DEF INPUT PARAM pc-cod-produto LIKE estab-produto-lpd.cod-produto NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-erro.

    DEF VAR l-gerou AS LOG NO-UNDO.

    IF NOT CAN-FIND (FIRST estab-produto-lpd 
                     WHERE estab-produto-lpd.cod-produto = pc-cod-produto 
                       AND estab-produto-lpd.cod-estabel = pc-cod-estabel) THEN DO:

        CREATE estab-produto-lpd.
        ASSIGN estab-produto-lpd.cod-estabel = pc-cod-estabel
               estab-produto-lpd.cod-produto = pc-cod-produto
               l-gerou                       = YES.

    END.

    FOR EACH  item-lpd 
        WHERE item-lpd.cod-produto = pc-cod-produto NO-LOCK:
            
        IF  NOT CAN-FIND(FIRST item-estab-produto-lpd 
                         WHERE item-estab-produto-lpd.cod-produto = pc-cod-produto 
                           AND item-estab-produto-lpd.cod-estabel = pc-cod-estabel 
                           AND item-estab-produto-lpd.it-codigo   = item-lpd.it-codigo) THEN DO:

            CREATE item-estab-produto-lpd.
            ASSIGN item-estab-produto-lpd.cod-estabel = pc-cod-estabel
                   item-estab-produto-lpd.cod-produto = pc-cod-produto
                   item-estab-produto-lpd.it-codigo   = item-lpd.it-codigo.


        END.
    END.

    FOR EACH tt-erro:
        DELETE tt-erro.
    END.

    IF  l-gerou THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.mensagem = "Integraá∆o Estab " + pc-cod-estabel + " com produto " + pc-cod-produto +  " gerada com sucesso!"
               tt-erro.cd-erro  = 56200
               tt-erro.c-param  = "Integraá∆o Estab " + pc-cod-estabel + " com produto " + pc-cod-produto.
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE geraEngineProdutoLPD:

    DEFINE INPUT PARAMETER pc-estabel    AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER pc-tip-operac AS CHAR NO-UNDO.

    FIND estabelec WHERE
         estabelec.cod-estabel = pc-estabel NO-LOCK NO-ERROR.

    IF  NOT AVAIL estabelec THEN
        RETURN "NOK".

    //CRIA REGISTRO ENTRADA OUTRAS, QUANTIDADE PRODUZIDA E QUANTIDADE SAIDAS CASO NAO ESTEJA CRIADO - CD0025
    IF  NOT CAN-FIND (FIRST config-tip-operac 
                      WHERE config-tip-operac.cod-tip-operac = pc-tip-operac) THEN DO:

        CREATE config-tip-operac.

        IF  pc-tip-operac = "LPD_Entradas_Outras" THEN    //Entrada Outras
            ASSIGN config-tip-operac.cod-tip-operac = "LPD_Entradas_Outras"
                   config-tip-operac.des-tip-operac = "Regras para definir Quantidade Outras Entradas - LPD".
        ELSE IF pc-tip-operac = "LPD_Quant_Produzida" THEN //Quantidade Produzida
            ASSIGN config-tip-operac.cod-tip-operac = "LPD_Quant_Produzida"
                   config-tip-operac.des-tip-operac = "Regras para definir Quantidade Produzida - LPD".
        ELSE IF pc-tip-operac = "LPD_Quant_Saidas" THEN //Quantidade SAIDAs
            ASSIGN config-tip-operac.cod-tip-operac = "LPD_Quant_Saidas"
                   config-tip-operac.des-tip-operac = "Regras para definir Quantidade SAIDAs - LPD".

    END.

    IF  NOT CAN-FIND (FIRST config-operac 
                      WHERE config-operac.cdn-empresa    = estabelec.ep-codigo
                        AND config-operac.cod-estab      = pc-estabel
                        AND config-operac.cod-tip-operac = pc-tip-operac) THEN DO: 

        //******************CRIACAO ENGINE CD0024**************************//
        CREATE config-operac.
        ASSIGN config-operac.cdn-empresa    = estabelec.ep-codigo
               config-operac.cod-estab      = pc-estabel
               config-operac.cod-tip-operac = pc-tip-operac.
        //******************CRIACAO ENGINE CD0024**************************//

        //******************CRIACAO DAS VARIAVEIS - INICIO **************************//
        FIND FIRST config-var-operac
             WHERE config-var-operac.cdn-empresa    = estabelec.ep-codigo
               AND config-var-operac.cod-estab      = pc-estabel
               AND config-var-operac.cod-tip-operac = pc-tip-operac NO-LOCK NO-ERROR.
        IF  NOT AVAIL config-var-operac THEN DO:
            CREATE config-var-operac.
            ASSIGN config-var-operac.cdn-empresa    = estabelec.ep-codigo
                   config-var-operac.cod-estab      = pc-estabel
                   config-var-operac.cod-tip-operac = pc-tip-operac
                   config-var-operac.cod-variavel   = "cod-depos"
                   config-var-operac.des-variavel   = "Codigo Deposito"
                   config-var-operac.num-livre-1    = 1.
    
            CREATE config-var-operac.
            ASSIGN config-var-operac.cdn-empresa    = estabelec.ep-codigo
                   config-var-operac.cod-estab      = pc-estabel
                   config-var-operac.cod-tip-operac = pc-tip-operac
                   config-var-operac.cod-variavel   = "cod-emitente"
                   config-var-operac.des-variavel   = "Codigo Fornecedor/Cliente"
                   config-var-operac.num-livre-1    = 2.
    
            CREATE config-var-operac.
            ASSIGN config-var-operac.cdn-empresa    = estabelec.ep-codigo
                   config-var-operac.cod-estab      = pc-estabel
                   config-var-operac.cod-tip-operac = pc-tip-operac
                   config-var-operac.cod-variavel   = "cod-estabel"
                   config-var-operac.des-variavel   = "Codigo Estabelecimento"
                   config-var-operac.num-livre-1    = 1.
    
            CREATE config-var-operac.
            ASSIGN config-var-operac.cdn-empresa    = estabelec.ep-codigo
                   config-var-operac.cod-estab      = pc-estabel
                   config-var-operac.cod-tip-operac = pc-tip-operac
                   config-var-operac.cod-variavel   = "cod-localiz"
                   config-var-operac.des-variavel   = "Codigo Localizacao"
                   config-var-operac.num-livre-1    = 1.
    
            CREATE config-var-operac.
            ASSIGN config-var-operac.cdn-empresa    = estabelec.ep-codigo
                   config-var-operac.cod-estab      = pc-estabel
                   config-var-operac.cod-tip-operac = pc-tip-operac
                   config-var-operac.cod-variavel   = "cod-refer"
                   config-var-operac.des-variavel   = "Referància"
                   config-var-operac.num-livre-1    = 1.
    
            CREATE config-var-operac.
            ASSIGN config-var-operac.cdn-empresa    = estabelec.ep-codigo
                   config-var-operac.cod-estab      = pc-estabel
                   config-var-operac.cod-tip-operac = pc-tip-operac
                   config-var-operac.cod-variavel   = "cod-unid-negoc"
                   config-var-operac.des-variavel   = "Unidade de Neg¢cio"
                   config-var-operac.num-livre-1    = 1.
    
            CREATE config-var-operac.
            ASSIGN config-var-operac.cdn-empresa    = estabelec.ep-codigo
                   config-var-operac.cod-estab      = pc-estabel
                   config-var-operac.cod-tip-operac = pc-tip-operac
                   config-var-operac.cod-variavel   = "ct-codigo"
                   config-var-operac.des-variavel   = "Conta Cont†bil"
                   config-var-operac.num-livre-1    = 1.
    
            CREATE config-var-operac.
            ASSIGN config-var-operac.cdn-empresa    = estabelec.ep-codigo
                   config-var-operac.cod-estab      = pc-estabel
                   config-var-operac.cod-tip-operac = pc-tip-operac
                   config-var-operac.cod-variavel   = "esp-docto"
                   config-var-operac.des-variavel   = "EspÇcie Documento"
                   config-var-operac.num-livre-1    = 2.
    
            CREATE config-var-operac.
            ASSIGN config-var-operac.cdn-empresa    = estabelec.ep-codigo
                   config-var-operac.cod-estab      = pc-estabel
                   config-var-operac.cod-tip-operac = pc-tip-operac
                   config-var-operac.cod-variavel   = "it-codigo"
                   config-var-operac.des-variavel   = "Codigo Item"
                   config-var-operac.num-livre-1    = 1.
    
            CREATE config-var-operac.
            ASSIGN config-var-operac.cdn-empresa    = estabelec.ep-codigo
                   config-var-operac.cod-estab      = pc-estabel
                   config-var-operac.cod-tip-operac = pc-tip-operac
                   config-var-operac.cod-variavel   = "lote"
                   config-var-operac.des-variavel   = "N£mero Lote"
                   config-var-operac.num-livre-1    = 1.
    
            CREATE config-var-operac.
            ASSIGN config-var-operac.cdn-empresa    = estabelec.ep-codigo
                   config-var-operac.cod-estab      = pc-estabel
                   config-var-operac.cod-tip-operac = pc-tip-operac
                   config-var-operac.cod-variavel   = "nat-operacao"
                   config-var-operac.des-variavel   = "Natureza de Operacao"
                   config-var-operac.num-livre-1    = 1.
    
            CREATE config-var-operac.
            ASSIGN config-var-operac.cdn-empresa    = estabelec.ep-codigo
                   config-var-operac.cod-estab      = pc-estabel
                   config-var-operac.cod-tip-operac = pc-tip-operac
                   config-var-operac.cod-variavel   = "sc-codigo"
                   config-var-operac.des-variavel   = "Centro de Custo"
                   config-var-operac.num-livre-1    = 1.
    
            CREATE config-var-operac.
            ASSIGN config-var-operac.cdn-empresa    = estabelec.ep-codigo
                   config-var-operac.cod-estab      = pc-estabel
                   config-var-operac.cod-tip-operac = pc-tip-operac
                   config-var-operac.cod-variavel   = "tipo-trans"
                   config-var-operac.des-variavel   = "Tipo Transacao (1 = Entrada / 2 = SAIDA)"
                   config-var-operac.num-livre-1    = 2.
    
            CREATE config-var-operac.
            ASSIGN config-var-operac.cdn-empresa    = estabelec.ep-codigo
                   config-var-operac.cod-estab      = pc-estabel
                   config-var-operac.cod-tip-operac = pc-tip-operac
                   config-var-operac.cod-variavel   = "usuario"
                   config-var-operac.des-variavel   = "Codigo Usu†rio"
                   config-var-operac.num-livre-1    = 1.
        END.
        //******************CRIACAO DAS VARIAVEIS - FIM **************************//

        //******************CRIACAO DAS REGRAS - INICIO **************************//
        IF  NOT CAN-FIND(FIRST config-var-operac-regra
                         WHERE config-var-operac-regra.cdn-empresa       = estabelec.ep-codigo
                           AND config-var-operac-regra.cod-estab         = pc-estabel
                           AND config-var-operac-regra.cod-tip-operac    = pc-tip-operac
                           AND config-var-operac-regra.cdn-regra-operac  = 1) THEN DO:
            CREATE config-var-operac-regra.
            ASSIGN config-var-operac-regra.cdn-empresa       = estabelec.ep-codigo
                   config-var-operac-regra.cod-estab         = pc-estabel
                   config-var-operac-regra.cod-tip-operac    = pc-tip-operac
                   config-var-operac-regra.cdn-regra-operac  = 1
                   config-var-operac-regra.des-regra-operac  = IF      pc-tip-operac = "LPD_Entradas_Outras" THEN "Condicoes para carregar outras entradas"
                                                               ELSE IF pc-tip-operac = "LPD_Quant_Produzida" THEN "Condicoes para carregar quantidade produzida"
                                                               ELSE "Condicoes para carregar quantidade SAIDAs".
        END.
        //******************CRIACAO DAS REGRAS - FIM **************************//

        //******************CRIACAO DAS CONDICOES DA REGRA - INICIO **************************//
        IF  NOT CAN-FIND(FIRST config-var-operac-regra-cond
                         WHERE config-var-operac-regra-cond.cdn-empresa    = estabelec.ep-codigo
                           AND config-var-operac-regra-cond.cod-estab      = pc-estabel
                           AND config-var-operac-regra-cond.cod-tip-operac = pc-tip-operac
                           AND config-var-operac-regra-cond.cdn-seq-regra  = 1) THEN DO:

            IF  pc-tip-operac = "LPD_Entradas_Outras" THEN DO: //ENTRADA OUTRAS
                CREATE config-var-operac-regra-cond.
                ASSIGN config-var-operac-regra-cond.cdn-empresa        = estabelec.ep-codigo
                       config-var-operac-regra-cond.cod-estab          = pc-estabel
                       config-var-operac-regra-cond.cod-tip-operac     = pc-tip-operac
                       config-var-operac-regra-cond.cdn-seq-regra      = 1
                       config-var-operac-regra-cond.cdn-regra-operac   = 1
                       config-var-operac-regra-cond.cod-variavel       = "esp-docto"
                       config-var-operac-regra-cond.cdn-cond-regra     = 2 //MAIOR QUE
                       config-var-operac-regra-cond.cod-val-var        = "2"
                       config-var-operac-regra-cond.cdn-operador-regra = 1. //E
        
                CREATE config-var-operac-regra-cond.
                ASSIGN config-var-operac-regra-cond.cdn-empresa        = estabelec.ep-codigo
                       config-var-operac-regra-cond.cod-estab          = pc-estabel
                       config-var-operac-regra-cond.cod-tip-operac     = pc-tip-operac
                       config-var-operac-regra-cond.cdn-seq-regra      = 2
                       config-var-operac-regra-cond.cdn-regra-operac   = 1
                       config-var-operac-regra-cond.cod-variavel       = "tipo-trans"
                       config-var-operac-regra-cond.cdn-cond-regra     = 1 //IGUAL A
                       config-var-operac-regra-cond.cod-val-var        = "1".
            END.
            ELSE IF pc-tip-operac = "LPD_Quant_Produzida" THEN DO: //QUANTIDADE PRODUZIDA
                CREATE config-var-operac-regra-cond.
                ASSIGN config-var-operac-regra-cond.cdn-empresa        = estabelec.ep-codigo
                       config-var-operac-regra-cond.cod-estab          = pc-estabel
                       config-var-operac-regra-cond.cod-tip-operac     = pc-tip-operac
                       config-var-operac-regra-cond.cdn-seq-regra      = 1
                       config-var-operac-regra-cond.cdn-regra-operac   = 1
                       config-var-operac-regra-cond.cod-variavel       = "esp-docto"
                       config-var-operac-regra-cond.cod-val-var        = "1"
                       config-var-operac-regra-cond.cdn-cond-regra     = 1 //IGUAL A
                       config-var-operac-regra-cond.cdn-operador-regra = 1 //E
                       config-var-operac-regra-cond.num-livre-1        = 1 //1o agrupamento/Abre parenteses
                       config-var-operac-regra-cond.num-livre-2        = 2. 
    
                CREATE config-var-operac-regra-cond.
                ASSIGN config-var-operac-regra-cond.cdn-empresa        = estabelec.ep-codigo
                       config-var-operac-regra-cond.cod-estab          = pc-estabel
                       config-var-operac-regra-cond.cod-tip-operac     = pc-tip-operac
                       config-var-operac-regra-cond.cdn-seq-regra      = 2
                       config-var-operac-regra-cond.cdn-regra-operac   = 1
                       config-var-operac-regra-cond.cod-variavel       = "tipo-trans"
                       config-var-operac-regra-cond.cod-val-var        = "1"
                       config-var-operac-regra-cond.cdn-cond-regra     = 1 //IGUAL A
                       config-var-operac-regra-cond.cdn-operador-regra = 2 //OU
                       config-var-operac-regra-cond.num-livre-1        = 1 //1o agrupamento/Fecha parenteses
                       config-var-operac-regra-cond.num-livre-2        = 2. 
    
                CREATE config-var-operac-regra-cond.
                ASSIGN config-var-operac-regra-cond.cdn-empresa        = estabelec.ep-codigo
                       config-var-operac-regra-cond.cod-estab          = pc-estabel
                       config-var-operac-regra-cond.cod-tip-operac     = pc-tip-operac
                       config-var-operac-regra-cond.cdn-seq-regra      = 3
                       config-var-operac-regra-cond.cdn-regra-operac   = 1
                       config-var-operac-regra-cond.cod-variavel       = "esp-docto"
                       config-var-operac-regra-cond.cod-val-var        = "8"
                       config-var-operac-regra-cond.cdn-cond-regra     = 1 //IGUAL A
                       config-var-operac-regra-cond.cdn-operador-regra = 1 //E
                       config-var-operac-regra-cond.num-livre-1        = 3 //2o agrupamento/Abre parenteses
                       config-var-operac-regra-cond.num-livre-2        = 4.
    
                CREATE config-var-operac-regra-cond.
                ASSIGN config-var-operac-regra-cond.cdn-empresa        = estabelec.ep-codigo
                       config-var-operac-regra-cond.cod-estab          = pc-estabel
                       config-var-operac-regra-cond.cod-tip-operac     = pc-tip-operac
                       config-var-operac-regra-cond.cdn-seq-regra      = 4
                       config-var-operac-regra-cond.cdn-regra-operac   = 1
                       config-var-operac-regra-cond.cod-variavel       = "tipo-trans"
                       config-var-operac-regra-cond.cod-val-var        = "2"
                       config-var-operac-regra-cond.cdn-cond-regra     = 1 //IGUAL A
                       config-var-operac-regra-cond.cdn-operador-regra = 0
                       config-var-operac-regra-cond.num-livre-1        = 3 //2o agrupamento/Fecha parenteses
                       config-var-operac-regra-cond.num-livre-2        = 4.
            END.
            ELSE IF pc-tip-operac = "LPD_Quant_Saidas" THEN DO: //QUANTIDADE SAIDAS

                CREATE config-var-operac-regra-cond.
                ASSIGN config-var-operac-regra-cond.cdn-empresa        = estabelec.ep-codigo
                       config-var-operac-regra-cond.cod-estab          = pc-estabel
                       config-var-operac-regra-cond.cod-tip-operac     = pc-tip-operac
                       config-var-operac-regra-cond.cdn-seq-regra      = 1
                       config-var-operac-regra-cond.cdn-regra-operac   = 1
                       config-var-operac-regra-cond.cod-variavel       = "esp-docto"
                       config-var-operac-regra-cond.cdn-cond-regra     = 2 //MAIOR QUE
                       config-var-operac-regra-cond.cod-val-var        = "2"
                       config-var-operac-regra-cond.cdn-operador-regra = 1. //E
    
                CREATE config-var-operac-regra-cond.
                ASSIGN config-var-operac-regra-cond.cdn-empresa        = estabelec.ep-codigo
                       config-var-operac-regra-cond.cod-estab          = pc-estabel
                       config-var-operac-regra-cond.cod-tip-operac     = pc-tip-operac
                       config-var-operac-regra-cond.cdn-seq-regra      = 2
                       config-var-operac-regra-cond.cdn-regra-operac   = 1
                       config-var-operac-regra-cond.cod-variavel       = "esp-docto"
                       config-var-operac-regra-cond.cdn-cond-regra     = 3 //MENOR QUE
                       config-var-operac-regra-cond.cod-val-var        = "8"
                       config-var-operac-regra-cond.cdn-operador-regra = 2 //OU
                       config-var-operac-regra-cond.num-livre-1        = 2
                       config-var-operac-regra-cond.num-livre-2        = 3.

                CREATE config-var-operac-regra-cond.
                ASSIGN config-var-operac-regra-cond.cdn-empresa        = estabelec.ep-codigo
                       config-var-operac-regra-cond.cod-estab          = pc-estabel
                       config-var-operac-regra-cond.cod-tip-operac     = pc-tip-operac
                       config-var-operac-regra-cond.cdn-seq-regra      = 3
                       config-var-operac-regra-cond.cdn-regra-operac   = 1
                       config-var-operac-regra-cond.cod-variavel       = "esp-docto"
                       config-var-operac-regra-cond.cdn-cond-regra     = 2 //MAIOR QUE
                       config-var-operac-regra-cond.cod-val-var        = "8"
                       config-var-operac-regra-cond.cdn-operador-regra = 1 //E
                       config-var-operac-regra-cond.num-livre-1        = 2
                       config-var-operac-regra-cond.num-livre-2        = 3.


                CREATE config-var-operac-regra-cond.
                ASSIGN config-var-operac-regra-cond.cdn-empresa        = estabelec.ep-codigo
                       config-var-operac-regra-cond.cod-estab          = pc-estabel
                       config-var-operac-regra-cond.cod-tip-operac     = pc-tip-operac
                       config-var-operac-regra-cond.cdn-seq-regra      = 4
                       config-var-operac-regra-cond.cdn-regra-operac   = 1
                       config-var-operac-regra-cond.cod-variavel       = "tipo-trans"
                       config-var-operac-regra-cond.cdn-cond-regra     = 1 //IGUAL A
                       config-var-operac-regra-cond.cod-val-var        = "2".
    
            END.
            //******************CRIACAO DAS CONDICOES DA REGRA - FIM **************************//
    
            //******************CRIACAO DO RETORNO - INICIO **************************//
            CREATE config-var-operac-regra-ret.
            ASSIGN config-var-operac-regra-ret.cdn-empresa        = estabelec.ep-codigo
                   config-var-operac-regra-ret.cod-estab          = pc-estabel
                   config-var-operac-regra-ret.cod-tip-operac     = pc-tip-operac
                   config-var-operac-regra-ret.cdn-regra-operac   = 1
                   config-var-operac-regra-ret.cdn-seq-ret        = 1
                   config-var-operac-regra-ret.cod-campo-ret      = IF      pc-tip-operac = "LPD_Entradas_Outras" THEN "EntradaOutras"
                                                                    ELSE IF pc-tip-operac = "LPD_Quant_Produzida" THEN "QuantidadeProduzida"
                                                                    ELSE "QuantidadeSaidas"
                   config-var-operac-regra-ret.cod-val-ret        = "Sim":U
                   config-var-operac-regra-ret.num-livre-1        = 1.
            //******************CRIACAO DO RETORNO - FIM ****************************//

        END. //IF  NOT CAN-FIND(FIRST config-var-operac-regra-cond...

    END.

END PROCEDURE.

PROCEDURE geraIntegracaoSped:
    
    /** Gera tabelas utilizadas pelo MLF para gerar os registros 1390 e 1391
        Os registros gerados podem ser visualizados via LF0203, na opcao "Movimento Producao Usina" 
    **/
    
    DEF INPUT PARAM TABLE FOR tt-saldo-produto-lpd.

    FOR EACH tt-saldo-produto-lpd:
        //Se tiver quantidade residuo porÈm n„o for selecionado nenhum tipo residuo, ir· bloquear
        IF tt-saldo-produto-lpd.qtd-residuo <> 0 AND tt-saldo-produto-lpd.idi-tp-residuo = 0 THEN
            RETURN "NOK":U. 
    END.

    FOR EACH tt-saldo-produto-lpd:

        FIND FIRST dwf-movto-produc-usina
             WHERE dwf-movto-produc-usina.dat-produc = tt-saldo-produto-lpd.dt-producao
               AND dwf-movto-produc-usina.cod-produt = tt-saldo-produto-lpd.cod-produto 
               AND dwf-movto-produc-usina.cod-estab  = tt-saldo-produto-lpd.cod-estabel EXCLUSIVE-LOCK NO-ERROR.

        //Se jah existe vai sobrepor, senao gera um novo
        IF  NOT AVAIL dwf-movto-produc-usina THEN DO:
            CREATE dwf-movto-produc-usina.
            ASSIGN dwf-movto-produc-usina.dat-produc = tt-saldo-produto-lpd.dt-producao
                   dwf-movto-produc-usina.cod-produt = tt-saldo-produto-lpd.cod-produto 
                   dwf-movto-produc-usina.cod-estab  = tt-saldo-produto-lpd.cod-estabel.
        END.

        ASSIGN dwf-movto-produc-usina.val-cana-moida        = tt-saldo-produto-lpd.qtd-cana-moida
               dwf-movto-produc-usina.val-estoq-inicial     = tt-saldo-produto-lpd.qtd-estoq-ini
               dwf-movto-produc-usina.val-quant-produz      = tt-saldo-produto-lpd.qtd-produzida
               dwf-movto-produc-usina.val-entr-anid-hidr    = tt-saldo-produto-lpd.qtd-ent-anid-hidrat
               dwf-movto-produc-usina.val-outras-entr       = tt-saldo-produto-lpd.qtd-ent-out
               dwf-movto-produc-usina.val-perda             = tt-saldo-produto-lpd.qtd-perda
               dwf-movto-produc-usina.val-consumo           = tt-saldo-produto-lpd.qtd-consumo
               dwf-movto-produc-usina.val-saida-anid-hidr   = tt-saldo-produto-lpd.qtd-sai-anid-hidrat
               dwf-movto-produc-usina.val-saida             = tt-saldo-produto-lpd.qtd-saidas
               dwf-movto-produc-usina.val-estoq-fim         = tt-saldo-produto-lpd.qtd-estoq-final
               dwf-movto-produc-usina.val-estoq-inicial-mel = tt-saldo-produto-lpd.qtd-ini-mel
               dwf-movto-produc-usina.val-produc-dia-mel    = tt-saldo-produto-lpd.qtd-prod-mel
               dwf-movto-produc-usina.val-quant-util-mel    = tt-saldo-produto-lpd.qtd-utiliz-mel
               dwf-movto-produc-usina.val-produc-alc-mel    = tt-saldo-produto-lpd.qtd-prod-alc-mel
               dwf-movto-produc-usina.cod-livre-1           = tt-saldo-produto-lpd.it-cod-residuo //COD_ITEM
               dwf-movto-produc-usina.num-livre-1           = tt-saldo-produto-lpd.idi-tp-residuo //TP_RESIDUO
               dwf-movto-produc-usina.val-livre-1           = tt-saldo-produto-lpd.qtd-residuo    //QTD_RESIDUO
               dwf-movto-produc-usina.val-qtd-residuo-ddg   = tt-saldo-produto-lpd.val-qtd-residuo-ddg  
               dwf-movto-produc-usina.val-qtd-residuo-wdg   = tt-saldo-produto-lpd.val-qtd-residuo-wdg  
               dwf-movto-produc-usina.val-qtd-residuo-cana  = tt-saldo-produto-lpd.val-qtd-residuo-cana.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE atualizaQuantidades:

    DEF INPUT PARAM TABLE FOR tt-saldo-item-produto-lpd.

    FOR EACH tt-saldo-item-produto-lpd:

        FIND FIRST saldo-item-produto-lpd 
             WHERE saldo-item-produto-lpd.dt-producao = tt-saldo-item-produto-lpd.dt-producao
               AND saldo-item-produto-lpd.cod-produto = tt-saldo-item-produto-lpd.cod-produto
               AND saldo-item-produto-lpd.cod-estabel = tt-saldo-item-produto-lpd.cod-estabel
               AND saldo-item-produto-lpd.it-codigo   = tt-saldo-item-produto-lpd.it-codigo EXCLUSIVE-LOCK NO-ERROR.

        IF  NOT AVAIL saldo-item-produto-lpd THEN DO:
            CREATE saldo-item-produto-lpd.
            BUFFER-COPY tt-saldo-item-produto-lpd TO saldo-item-produto-lpd.
        END.

        ASSIGN saldo-item-produto-lpd.qtd-estoq-ini    = tt-saldo-item-produto-lpd.qtd-estoq-ini  
               saldo-item-produto-lpd.qtd-produzida    = tt-saldo-item-produto-lpd.qtd-produzida  
               saldo-item-produto-lpd.qtd-ent-out      = tt-saldo-item-produto-lpd.qtd-ent-out    
               saldo-item-produto-lpd.qtd-saidas       = tt-saldo-item-produto-lpd.qtd-saidas     
               saldo-item-produto-lpd.qtd-estoq-final  = tt-saldo-item-produto-lpd.qtd-estoq-final.

    END.

    RETURN "OK".

END PROCEDURE.


PROCEDURE recalculaSaldos:

    DEF INPUT PARAM pc-cod-estabel    LIKE saldo-item-produto-lpd.cod-estabel   NO-UNDO.
    DEF INPUT PARAM pc-cod-produto    LIKE saldo-item-produto-lpd.cod-produto   NO-UNDO.
    DEF INPUT PARAM pc-it-codigo      LIKE saldo-item-produto-lpd.it-codigo     NO-UNDO.
    DEF INPUT PARAM pda-dt-producao   LIKE saldo-item-produto-lpd.dt-producao   NO-UNDO.
    DEF INPUT PARAM pde-qtd-estoq-ini LIKE saldo-item-produto-lpd.qtd-estoq-ini NO-UNDO.
    DEF INPUT PARAM pl-atualiza-obs   AS LOG                                    NO-UNDO.
    DEF INPUT PARAM pc-seg-usuario    LIKE usuar-mater.cod-usuario              NO-UNDO.
    DEF INPUT PARAM TABLE FOR tt-saldo-produto-lpd.
    DEF INPUT PARAM TABLE FOR tt-saldo-item-produto-lpd.

    FIND FIRST tt-saldo-produto-lpd NO-ERROR.
    FIND FIRST tt-saldo-item-produto-lpd NO-ERROR.

    DEF VAR de-qtd-estoq-final-dia-ant  AS DEC NO-UNDO.

    DEF BUFFER b-saldo-item-produto-lpd FOR saldo-item-produto-lpd.

    FIND FIRST saldo-produto-lpd
         WHERE saldo-produto-lpd.cod-produto = pc-cod-produto
           AND saldo-produto-lpd.cod-estabel = pc-cod-estabel 
           AND saldo-produto-lpd.dt-producao = pda-dt-producao EXCLUSIVE-LOCK NO-ERROR.

    IF  NOT AVAIL saldo-produto-lpd 
    AND AVAIL tt-saldo-produto-lpd THEN DO:
        CREATE saldo-produto-lpd.
        BUFFER-COPY tt-saldo-produto-lpd TO saldo-produto-lpd.
    END.

    FIND FIRST saldo-item-produto-lpd
         WHERE saldo-item-produto-lpd.cod-produto = pc-cod-produto
           AND saldo-item-produto-lpd.cod-estabel = pc-cod-estabel 
           AND saldo-item-produto-lpd.dt-producao = pda-dt-producao 
           AND saldo-item-produto-lpd.it-codigo   = pc-it-codigo EXCLUSIVE-LOCK NO-ERROR.

    IF  NOT AVAIL saldo-item-produto-lpd 
    AND AVAIL tt-saldo-item-produto-lpd THEN DO:
        CREATE saldo-item-produto-lpd.
        BUFFER-COPY tt-saldo-item-produto-lpd TO saldo-item-produto-lpd.
    END.

    IF  AVAIL saldo-produto-lpd
    AND AVAIL saldo-item-produto-lpd THEN DO:
        ASSIGN saldo-item-produto-lpd.qtd-estoq-ini   = pde-qtd-estoq-ini
               saldo-item-produto-lpd.qtd-estoq-final = saldo-item-produto-lpd.qtd-estoq-ini + 
                                                        saldo-item-produto-lpd.qtd-produzida +
                                                        saldo-item-produto-lpd.qtd-ent-out   -
                                                        saldo-item-produto-lpd.qtd-saidas
               de-qtd-estoq-final-dia-ant             = saldo-item-produto-lpd.qtd-estoq-final.

        IF  pl-atualiza-obs THEN
            ASSIGN saldo-produto-lpd.observacao           = "Saldo Inicial Informado pelo usu†rio " + pc-seg-usuario + 
                                                            " data: " + STRING(TODAY,"99/99/99")     + "  |  " +  
                                                            saldo-produto-lpd.observacao.

        FOR EACH  b-saldo-item-produto-lpd
            WHERE b-saldo-item-produto-lpd.cod-estabel = saldo-item-produto-lpd.cod-estabel
              AND b-saldo-item-produto-lpd.cod-produto = saldo-item-produto-lpd.cod-produto
              AND b-saldo-item-produto-lpd.it-codigo   = saldo-item-produto-lpd.it-codigo
              AND b-saldo-item-produto-lpd.dt-producao > saldo-item-produto-lpd.dt-producao EXCLUSIVE-LOCK
            BY b-saldo-item-produto-lpd.dt-producao:

            ASSIGN b-saldo-item-produto-lpd.qtd-estoq-ini   = de-qtd-estoq-final-dia-ant                     
                   b-saldo-item-produto-lpd.qtd-estoq-final = b-saldo-item-produto-lpd.qtd-estoq-ini +
                                                              b-saldo-item-produto-lpd.qtd-produzida +
                                                              b-saldo-item-produto-lpd.qtd-ent-out   -
                                                              b-saldo-item-produto-lpd.qtd-saidas     
                   de-qtd-estoq-final-dia-ant               = b-saldo-item-produto-lpd.qtd-estoq-final.


        END.
                                                      
    END.

    RETURN "OK".

END PROCEDURE.
