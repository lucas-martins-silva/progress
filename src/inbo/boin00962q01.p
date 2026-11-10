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
{include/i-prgvrs.i BOIN00962Q01 2.00.00.016 } /*** "010016" 13/11/2023 11:45:43 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN00962Q01 MAQ}
&ENDIF

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

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN00962
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName produt-rural
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE XMLReceiver YES  
&GLOBAL-DEFINE XMLProducer YES
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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin00962.i RowObject}
{inbo/boin00962.i RowObject-aux}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
/*{method/dboqry.i}*/
DEFINE QUERY {&QUERYNAME} for {&TABLENAME},emitente scrolling.

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEF VARIABLE i-cdn-produt-ini  LIKE RowObject.cdn-produt-rural NO-UNDO.
DEF VARIABLE i-cdn-produt-fim  LIKE RowObject.cdn-produt-rural NO-UNDO.
DEF VARIABLE c-nome-produt-ini LIKE emitente.nome-abrev        NO-UNDO.
DEF VARIABLE c-nome-produt-fim LIKE emitente.nome-abrev        NO-UNDO.
DEF VARIABLE i-tipo-selecao    AS INTEGER                      NO-UNDO.
DEF VARIABLE c-cnpj-ini        LIKE emitente.cgc               NO-UNDO.
DEF VARIABLE c-cnpj-fim        LIKE emitente.cgc               NO-UNDO.
DEF VARIABLE i-situacao        AS INTEGER                      NO-UNDO.

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
         HEIGHT             = 10.96
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCopyBuffer2TT DBOProgram 
PROCEDURE afterCopyBuffer2TT :
/*:T------------------------------------------------------------------------------
  Purpose:     Carrega o nome-abrev na tt2 do zoom para ordenar pelo mesmo
------------------------------------------------------------------------------*/
    
    FIND emitente WHERE emitente.cod-emitente = {&TableName}.cdn-produt-rural NO-LOCK NO-ERROR.
    IF avail emitente THEN DO:

        ASSIGN RowObject.cod-livre-1 = emitente.nome-abrev.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-cart-produt":U THEN ASSIGN pFieldValue = RowObject.cod-cart-produt.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-obs":U THEN ASSIGN pFieldValue = RowObject.cod-obs.
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
        WHEN "cdn-grp-produt":U THEN ASSIGN pFieldValue = RowObject.cdn-grp-produt.
        WHEN "cdn-produt-rural":U THEN ASSIGN pFieldValue = RowObject.cdn-produt-rural.
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
  Purpose:     Retorna valores dos campos do °ndice cod-produt
  Parameters:  
               retorna valor do campo cdn-produt-rural
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-produt-rural LIKE produt-rural.cdn-produt-rural NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-produt-rural = RowObject.cdn-produt-rural.

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
  Purpose:     Reposiciona registro com base no °ndice cod-produt
  Parameters:  
               recebe valor do campo cdn-produt-rural
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-produt-rural LIKE produt-rural.cdn-produt-rural NO-UNDO.

    FIND FIRST bfprodut-rural WHERE 
        bfprodut-rural.cdn-produt-rural = pcdn-produt-rural NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfprodut-rural THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfprodut-rural)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNome DBOProgram 
PROCEDURE openQueryNome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} 
         FOR EACH {&TableName} NO-LOCK,
            FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = {&TableName}.cdn-produt-rural
              AND emitente.nome-emit  >= c-nome-produt-ini
              AND emitente.nome-emit  <= c-nome-produt-fim 
         BY {&TableName}.cod-livre-1 INDEXED-REPOSITION.
    
    RETURN "OK":U.
                                   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryProdutor DBOProgram 
PROCEDURE openQueryProdutor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} 
         FOR EACH {&TableName} NO-LOCK
             WHERE cdn-produt-rural >= i-cdn-produt-ini
               AND cdn-produt-rural <= i-cdn-produt-fim,
             FIRST emitente 
             WHERE emitente.cod-emitente = {&TableName}.cdn-produt-rural NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCustomCNPJ DBOProgram 
PROCEDURE openQueryCustomCNPJ :
/*------------------------------------------------------------------------------
  Purpose: Retorna os produtores de uma carga filtrados por CNPJ  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR RowObject-aux.

    EMPTY TEMP-TABLE RowObject-aux NO-ERROR.
    FIND FIRST param-global NO-LOCK NO-ERROR.

    FOR EACH {&TableName} NO-LOCK
       WHERE (({&tablename}.log-livre-1 AND (i-situacao = 1 OR i-situacao = 3)) /*indica que a propried est† ativo*/
          OR  (NOT {&tablename}.log-livre-1 AND (i-situacao = 2 OR i-situacao = 3))),
       FIRST emitente NO-LOCK
       WHERE emitente.cod-emitente = {&TableName}.cdn-produt-rural
         AND emitente.cgc  >= c-cnpj-ini
         AND emitente.cgc  <= c-cnpj-fim:
         
        /*O zoom de Produtores mostra em tela o nome do emitente atravÇs de um campo calculado. PorÇm ao fazer a ordenaá∆o n∆o conseguimos ordenar campos calculados.
          Neste caso, optou-se por usar o cod-livre-1 para armazenar o nome-emit e permitir fazer a ordenaá∆o pelo nome do produtor. Este campo Ç usado temporariamente 
          somente no zoom.*/
        IF NOT CAN-FIND(FIRST RowObject-aux 
                        WHERE RowObject-aux.cdn-produt-rural = {&TableName}.cdn-produt-rural) THEN DO:
            CREATE RowObject-aux.
            BUFFER-COPY {&TableName} TO RowObject-aux.
            ASSIGN RowObject-aux.r-rowid     = ROWID({&TableName})
                   RowObject-aux.cod-livre-1 = emitente.nome-emit
                   RowObject-aux.cod-livre-2 = IF emitente.natureza = 1 THEN 
                                                  STRING(emitente.cgc, param-global.formato-id-pessoal) 
                                               ELSE STRING(emitente.cgc, param-global.formato-id-federal).
        END.
    END.
    
    RETURN "OK":U. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCustomNome DBOProgram 
PROCEDURE openQueryCustomNome :
/*------------------------------------------------------------------------------
  Purpose: Retorna os produtores de uma carga filtrados por nome  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR RowObject-aux.

    EMPTY TEMP-TABLE RowObject-aux NO-ERROR.
    FIND FIRST param-global NO-LOCK NO-ERROR.

    CASE i-tipo-selecao:
        WHEN 1 THEN DO: /*faixa*/
            FOR EACH {&TableName} NO-LOCK
               WHERE (({&tablename}.log-livre-1 AND (i-situacao = 1 OR i-situacao = 3)) /*indica que a propried est† ativo*/
                  OR  (NOT {&tablename}.log-livre-1 AND (i-situacao = 2 OR i-situacao = 3))),
               FIRST emitente NO-LOCK
               WHERE emitente.cod-emitente = {&TableName}.cdn-produt-rural
                 AND emitente.nome-emit  >= c-nome-produt-ini
                 AND emitente.nome-emit  <= c-nome-produt-fim:

                /*O zoom de Produtores mostra em tela o nome do emitente atravÇs de um campo calculado. PorÇm ao fazer a ordenaá∆o n∆o conseguimos ordenar campos calculados.
                  Neste caso, optou-se por usar o cod-livre-1 para armazenar o nome-emit e permitir fazer a ordenaá∆o pelo nome do produtor. Este campo Ç usado temporariamente 
                  somente no zoom.*/
                IF NOT CAN-FIND(FIRST RowObject-aux 
                                WHERE RowObject-aux.cdn-produt-rural = {&TableName}.cdn-produt-rural) THEN DO:
                    CREATE RowObject-aux.
                    BUFFER-COPY {&TableName} TO RowObject-aux.
                    ASSIGN RowObject-aux.r-rowid     = ROWID({&TableName})
                           RowObject-aux.cod-livre-1 = emitente.nome-emit
                           RowObject-aux.cod-livre-2 = IF emitente.natureza = 1 THEN 
                                                          STRING(emitente.cgc, param-global.formato-id-pessoal) 
                                                       ELSE STRING(emitente.cgc, param-global.formato-id-federal).
                END.
            END.
        END.
        WHEN 2 THEN DO: /*inicia com*/
            FOR EACH {&TableName} NO-LOCK
               WHERE (({&tablename}.log-livre-1 AND (i-situacao = 1 OR i-situacao = 3)) /*indica que a propried est† ativo*/
                  OR  (NOT {&tablename}.log-livre-1 AND (i-situacao = 2 OR i-situacao = 3))),
               FIRST emitente NO-LOCK
               WHERE emitente.cod-emitente = {&TableName}.cdn-produt-rural
                 AND emitente.nome-emit BEGINS c-nome-produt-ini:

                /*O zoom de Produtores mostra em tela o nome do emitente atravÇs de um campo calculado. PorÇm ao fazer a ordenaá∆o n∆o conseguimos ordenar campos calculados.
                  Neste caso, optou-se por usar o cod-livre-1 para armazenar o nome-emit e permitir fazer a ordenaá∆o pelo nome do produtor. Este campo Ç usado temporariamente 
                  somente no zoom.*/
                IF NOT CAN-FIND(FIRST RowObject-aux 
                                WHERE RowObject-aux.cdn-produt-rural = {&TableName}.cdn-produt-rural) THEN DO:
                    CREATE RowObject-aux.
                    BUFFER-COPY {&TableName} TO RowObject-aux.
                    ASSIGN RowObject-aux.r-rowid     = ROWID({&TableName})
                           RowObject-aux.cod-livre-1 = emitente.nome-emit
                           RowObject-aux.cod-livre-2 = IF emitente.natureza = 1 THEN 
                                                          STRING(emitente.cgc, param-global.formato-id-pessoal) 
                                                       ELSE STRING(emitente.cgc, param-global.formato-id-federal).
                END.
            END.
        END.
        WHEN 3 THEN DO: /*contem*/
            FOR EACH {&TableName} NO-LOCK
               WHERE (({&tablename}.log-livre-1 AND (i-situacao = 1 OR i-situacao = 3)) /*indica que a propried est† ativo*/
                  OR  (NOT {&tablename}.log-livre-1 AND (i-situacao = 2 OR i-situacao = 3))),
               FIRST emitente NO-LOCK
               WHERE emitente.cod-emitente = {&TableName}.cdn-produt-rural
                 AND emitente.nome-emit MATCHES ("*" + c-nome-produt-ini + "*"):

                /*O zoom de Produtores mostra em tela o nome do emitente atravÇs de um campo calculado. PorÇm ao fazer a ordenaá∆o n∆o conseguimos ordenar campos calculados.
                  Neste caso, optou-se por usar o cod-livre-1 para armazenar o nome-emit e permitir fazer a ordenaá∆o pelo nome do produtor. Este campo Ç usado temporariamente 
                  somente no zoom.*/
                IF NOT CAN-FIND(FIRST RowObject-aux 
                                WHERE RowObject-aux.cdn-produt-rural = {&TableName}.cdn-produt-rural) THEN DO:
                    CREATE RowObject-aux.
                    BUFFER-COPY {&TableName} TO RowObject-aux.
                    ASSIGN RowObject-aux.r-rowid     = ROWID({&TableName})
                           RowObject-aux.cod-livre-1 = emitente.nome-emit
                           RowObject-aux.cod-livre-2 = IF emitente.natureza = 1 THEN 
                                                          STRING(emitente.cgc, param-global.formato-id-pessoal) 
                                                       ELSE STRING(emitente.cgc, param-global.formato-id-federal).
                END.
            END.
        END.
    END CASE.
    
    RETURN "OK":U. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCustomProdutor DBOProgram 
PROCEDURE openQueryCustomProdutor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER TABLE FOR RowObject-aux.

    EMPTY TEMP-TABLE RowObject-aux NO-ERROR.
    FIND FIRST param-global NO-LOCK NO-ERROR.

    FOR EACH {&TableName} NO-LOCK
       WHERE {&TableName}.cdn-produt-rural >= i-cdn-produt-ini
         AND {&TableName}.cdn-produt-rural <= i-cdn-produt-fim
         AND (({&tablename}.log-livre-1 AND (i-situacao = 1 OR i-situacao = 3)) /*indica que a propried est† ativo*/
          OR  (NOT {&tablename}.log-livre-1 AND (i-situacao = 2 OR i-situacao = 3))),
       FIRST emitente NO-LOCK
       WHERE emitente.cod-emitente = {&TableName}.cdn-produt-rural:

        /*O zoom de Produtores mostra em tela o nome do emitente atravÇs de um campo calculado. PorÇm ao fazer a ordenaá∆o n∆o conseguimos ordenar campos calculados.
          Neste caso, optou-se por usar o cod-livre-1 para armazenar o nome-emit e permitir fazer a ordenaá∆o pelo nome do produtor. Este campo Ç usado temporariamente 
          somente no zoom.*/
        IF NOT CAN-FIND(FIRST RowObject-aux 
                        WHERE RowObject-aux.cdn-produt-rural = {&TableName}.cdn-produt-rural) THEN DO:
            CREATE RowObject-aux.
            BUFFER-COPY {&TableName} TO RowObject-aux.
            ASSIGN RowObject-aux.r-rowid     = ROWID({&TableName})
                   RowObject-aux.cod-livre-1 = emitente.nome-emit
                   RowObject-aux.cod-livre-2 = IF emitente.natureza = 1 THEN 
                                                  STRING(emitente.cgc, param-global.formato-id-pessoal) 
                                               ELSE STRING(emitente.cgc, param-global.formato-id-federal).
        END.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCNPJ DBOProgram 
PROCEDURE setConstraintCNPJ :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-cnpj-ini like emitente.cgc no-undo.
def input parameter p-cnpj-fim like emitente.cgc no-undo.
def input parameter p-situacao as integer        no-undo.

    assign c-cnpj-ini = p-cnpj-ini        
           c-cnpj-fim = p-cnpj-fim
           i-situacao = p-situacao.   

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNome DBOProgram 
PROCEDURE setConstraintNome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-nome-produt-ini like emitente.nome-abrev no-undo.
def input parameter p-nome-produt-fim like emitente.nome-abrev no-undo.
def input parameter p-situacao        as integer               no-undo.
def input parameter p-tipo-selecao    as integer               no-undo.

    assign c-nome-produt-ini = p-nome-produt-ini        
           c-nome-produt-fim = p-nome-produt-fim
           i-situacao        = p-situacao
           i-tipo-selecao    = p-tipo-selecao.   

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintProdutor DBOProgram 
PROCEDURE setConstraintProdutor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-i-cdn-produt-ini like RowObject.cdn-produt-rural no-undo.
def input parameter p-i-cdn-produt-fim like RowObject.cdn-produt-rural no-undo.
def input parameter p-situacao         as integer                      no-undo.

    assign i-cdn-produt-ini = p-i-cdn-produt-ini        
           i-cdn-produt-fim = p-i-cdn-produt-fim
           i-situacao       = p-situacao.   

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

