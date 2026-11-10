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

{include/i-prgvrs.i BOIN01005 2.00.00.006 } /*** "010006" 17/06/2025 16:40:42 ***/
    
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN 
  {include/i-license-manager.i boin01005 MUT}
&ENDIF

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01005
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName nf-produt-propried
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
{inbo/boin01005.i RowObject}

DEFINE TEMP-TABLE tt-param NO-UNDO
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG
    FIELD regiao-ini       as char format "x(12)":U
    FIELD regiao-fim       as char format "x(12)":U
    FIELD rota-ini         as char format "x(12)":U
    FIELD rota-fim         as char format "x(12)":U
    FIELD grp-prod-ini     AS INTEGER
    FIELD grp-prod-fim     AS INTEGER
    FIELD prod-rural-ini   AS INTEGER
    FIELD prod-rural-fim   AS INTEGER
    FIELD cod-estabel      as char format "x(5)":U
    FIELD cod-periodo      AS CHAR FORMAT "99/9999"
    FIELD cod-serie        as char format "x(5)":U
    FIELD dt-emissao       AS DATE FORMAT "99/99/9999"
    FIELD it-codigo        AS CHAR FORMAT "X(16)":U
    FIELD nat-operacao     AS CHAR FORMAT "X(6)":U 
    FIELD cod-transp-ini   AS INTEGER
    FIELD cod-transp-fim   AS INTEGER
    FIELD cod-propried     AS CHARACTER.
    /*Fim alteracao 15/02/2005*/

/* Definiá∆o tt-digita */
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD cdn-produt   AS INTEGER   FORMAT ">>>,>>>,>>9"      
    FIELD nom-produt   AS CHARACTER FORMAT "X(30)"                             
    FIELD cod-propried AS CHARACTER FORMAT "X(16)"
    FIELD des-propried AS CHARACTER FORMAT "X(60)"
    FIELD val-unit     AS DECIMAL
    FIELD val-total    AS DECIMAL
    FIELD quantidade   AS DECIMAL
    INDEX id cdn-produt.

define temp-table tt-digita-aq0326 no-undo
    FIELD cod-transp       LIKE transpdor-coleta.cod-transp COLUMN-LABEL "Transportador"
    FIELD descricao        AS CHARACTER FORMAT "x(150)":U   COLUMN-LABEL "Nome Transportador"
    FIELD nome-abrev       AS CHARACTER FORMAT "x(12)":U    
    FIELD email            AS CHARACTER FORMAT "x(120)":U   COLUMN-LABEL "E-mail"
    INDEX id cod-transp.
    

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-period":U THEN ASSIGN pFieldValue = RowObject.cod-period.
        WHEN "cod-propried":U THEN ASSIGN pFieldValue = RowObject.cod-propried.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
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
        WHEN "cdn-id-movto-event":U THEN ASSIGN pFieldValue = RowObject.cdn-id-movto-event.
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
  Purpose:     Retorna valores dos campos do °ndice nf-produt-id
  Parameters:  
               retorna valor do campo cod-period
               retorna valor do campo cdn-produt-rural
               retorna valor do campo cod-propried
               retorna valor do campo it-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo nat-operacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-period LIKE nf-produt-propried.cod-period NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-produt-rural LIKE nf-produt-propried.cdn-produt-rural NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-propried LIKE nf-produt-propried.cod-propried NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE nf-produt-propried.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE nf-produt-propried.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pserie-docto LIKE nf-produt-propried.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE nf-produt-propried.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE nf-produt-propried.nat-operacao NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-period = RowObject.cod-period
           pcdn-produt-rural = RowObject.cdn-produt-rural
           pcod-propried = RowObject.cod-propried
           pit-codigo = RowObject.it-codigo
           pcod-estabel = RowObject.cod-estabel
           pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pnat-operacao = RowObject.nat-operacao.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTempTableNF DBOProgram 
PROCEDURE getTempTableNF :
/*------------------------------------------------------------------------------
  Purpose: Cria temp-table de digitaá∆o para Programa de Geraá∆o de NF Complementar (AQ0327)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE  INPUT PARAM busca-unica AS LOGICAL NO-UNDO. /* YES - Aba Digitaá∆o / NO - Aba Seleá∆o */
    DEFINE  INPUT PARAM TABLE FOR tt-param.
    DEFINE OUTPUT PARAM TABLE FOR tt-digita.

    DEFINE VARIABLE de-qtde    AS DECIMAL NO-UNDO.

    EMPTY TEMP-TABLE tt-digita.

    FIND FIRST tt-param NO-ERROR.

    IF NOT AVAIL tt-param THEN
      LEAVE.

    blk_produt:
    FOR EACH produt-rural FIELDS (cdn-produt-rural)
       WHERE produt-rural.cdn-produt-rural >= tt-param.prod-rural-ini
         AND produt-rural.cdn-produt-rural <= tt-param.prod-rural-fim
         AND produt-rural.cdn-grp-produt   >= tt-param.grp-prod-ini
         AND produt-rural.cdn-grp-produt   <= tt-param.grp-prod-fim NO-LOCK:

        blk_propried:
        FOR EACH propried-rural fields(cod-propried des-propried) NO-LOCK
           WHERE propried-rural.cdn-produt-rural = produt-rural.cdn-produt-rural 
             AND propried-rural.cod-regiao      >= tt-param.regiao-ini 
             AND propried-rural.cod-regiao      <= tt-param.regiao-fim
             AND propried-rural.cod-rota-princ  >= tt-param.rota-ini
             AND propried-rural.cod-rota-princ  <= tt-param.rota-fim:

            IF busca-unica THEN DO:
              IF tt-param.cod-propried = "" THEN
                LEAVE blk_produt.
              IF tt-param.cod-propried <> propried-rural.cod-propried THEN
                NEXT blk_propried.
            END.

            FOR EACH bf{&TableName} NO-LOCK
               WHERE bf{&TableName}.cod-period       = tt-param.cod-periodo
                 AND bf{&TableName}.cdn-produt-rural = produt-rural.cdn-produt-rural
                 AND bf{&TableName}.cod-propried     = propried-rural.cod-propried
                 AND bf{&TableName}.it-codigo        = tt-param.it-codigo
                 AND bf{&TableName}.cod-estabel      = tt-param.cod-estabel
                 AND bf{&TableName}.num-livre-1      = 0: /* deve buscar somente notas de mercadoria */

                FOR FIRST emitente FIELDS(nome-emit) NO-LOCK
                    WHERE emitente.cod-emitente = bf{&TableName}.cdn-produt-rural:
                END.

                IF NOT CAN-FIND(FIRST tt-digita 
                                WHERE tt-digita.cdn-produt   = bf{&TableName}.cdn-produt-rural
                                  AND tt-digita.cod-propried = bf{&TableName}.cod-propried) THEN DO:

                    CREATE tt-digita.
                    ASSIGN tt-digita.cdn-produt   = bf{&TableName}.cdn-produt-rural
                           tt-digita.nom-produt   = IF AVAIL emitente THEN emitente.nome-emit ELSE ""
                           tt-digita.cod-propried = bf{&TableName}.cod-propried
                           tt-digita.des-propried = propried-rural.des-propried.
                END.     

                ASSIGN de-qtde = 0.
                FOR EACH item-doc-est FIELDS (quantidade)
                   WHERE item-doc-est.serie-docto  = bf{&TableName}.serie-docto
                     AND item-doc-est.nro-docto    = bf{&TableName}.nro-docto   
                     AND item-doc-est.cod-emitente = bf{&TableName}.cdn-produt-rural
                     AND item-doc-est.nat-operacao = bf{&TableName}.nat-operacao NO-LOCK:

                    ASSIGN de-qtde = de-qtde + item-doc-est.quantidade.
                END.

                ASSIGN tt-digita.quantidade = tt-digita.quantidade + de-qtde.

                IF busca-unica THEN
                  NEXT blk_produt.
             END.
        END.
    END.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice nf-produt-id
  Parameters:  
               recebe valor do campo cod-period
               recebe valor do campo cdn-produt-rural
               recebe valor do campo cod-propried
               recebe valor do campo it-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo nat-operacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-period LIKE nf-produt-propried.cod-period NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-produt-rural LIKE nf-produt-propried.cdn-produt-rural NO-UNDO.
    DEFINE INPUT PARAMETER pcod-propried LIKE nf-produt-propried.cod-propried NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE nf-produt-propried.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE nf-produt-propried.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pserie-docto LIKE nf-produt-propried.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE nf-produt-propried.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE nf-produt-propried.nat-operacao NO-UNDO.

    FIND FIRST bfnf-produt-propried WHERE 
        bfnf-produt-propried.cod-period = pcod-period AND 
        bfnf-produt-propried.cdn-produt-rural = pcdn-produt-rural AND 
        bfnf-produt-propried.cod-propried = pcod-propried AND 
        bfnf-produt-propried.it-codigo = pit-codigo AND 
        bfnf-produt-propried.cod-estabel = pcod-estabel AND 
        bfnf-produt-propried.serie-docto = pserie-docto AND 
        bfnf-produt-propried.nro-docto = pnro-docto AND 
        bfnf-produt-propried.nat-operacao = pnat-operacao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfnf-produt-propried THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfnf-produt-propried)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaListaTransportadoresNF DBOProgram 
PROCEDURE retornaListaTransportadoresNF :
/*------------------------------------------------------------------------------
  Purpose: Retorna lista de transportadores para a tela aq0326
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM TABLE FOR tt-param.
    DEFINE OUTPUT PARAM TABLE FOR tt-digita-aq0326.

    EMPTY TEMP-TABLE tt-digita-aq0326.

    FIND FIRST tt-param NO-ERROR.

    IF NOT AVAIL tt-param THEN
        LEAVE.

    FOR EACH bf{&TableName} FIELDS(cdn-produt-rural nro-docto cod-estabel serie-docto) NO-LOCK
       WHERE bf{&TableName}.it-codigo   = tt-param.it-codigo
         AND bf{&TableName}.cod-period  = tt-param.cod-periodo
         AND bf{&TableName}.num-livre-1 = 0, /* desconsidera complementar */         
       FIRST nota-fiscal FIELDS(nome-transp) NO-LOCK
       WHERE nota-fiscal.nr-nota-fis =  bf{&TableName}.nro-docto
         AND nota-fiscal.cod-estabel =  bf{&TableName}.cod-estabel
         AND nota-fiscal.serie      =   bf{&TableName}.serie-docto,
       FIRST transporte FIELDS(cod-transp nome nome-abrev) NO-LOCK
       WHERE transporte.nome-abrev = nota-fiscal.nome-transp
         AND transporte.cod-transp >= tt-param.cod-transp-ini 
         AND transporte.cod-transp <= tt-param.cod-transp-fim:
        FOR EACH propried-rural FIELDS() NO-LOCK
           WHERE propried-rural.cdn-produt-rural = bf{&TableName}.cdn-produt-rural 
             AND propried-rural.cod-regiao      >= tt-param.regiao-ini 
             AND propried-rural.cod-regiao      <= tt-param.regiao-fim
             AND propried-rural.cod-rota-princ  >= tt-param.rota-ini
             AND propried-rural.cod-rota-princ  <= tt-param.rota-fim:
             
            FOR FIRST cont-tran FIELDS(e-mail) NO-LOCK 
                WHERE cont-tran.cod-transp = transporte.cod-transp
                  AND &IF '{&bf_dis_versao_ems}' >= '2.09':U &THEN 
                      cont-tran.cdn-aplic-contat
                      &ELSE  
                      cont-tran.int-1
                      &ENDIF = 2: /* Destinatario XML NF-e*/
            END.
           
            IF NOT CAN-FIND(FIRST tt-digita-aq0326 
                            WHERE tt-digita-aq0326.cod-transp = transporte.cod-transp) THEN DO:
                CREATE tt-digita-aq0326.
                ASSIGN tt-digita-aq0326.cod-transp = transporte.cod-transp
                       tt-digita-aq0326.descricao  = transporte.nome
                       tt-digita-aq0326.nome-abrev = transporte.nome-abrev
                       tt-digita-aq0326.email      = IF AVAIL cont-tran THEN cont-tran.e-mail ELSE "".
            END. 
        END.
      
    END.
    
    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE canFindNotaTransp DBOProgram 
PROCEDURE canFindNotaTransp :
/*------------------------------------------------------------------------------
  Purpose: Verifica se o transportador transportou alguma nota fiscal
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-cod-transp AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR tt-param.
    DEFINE OUTPUT PARAMETER pl-encontrou-nota AS LOGICAL NO-UNDO.

    ASSIGN pl-encontrou-nota = NO.
    
    FIND FIRST tt-param NO-ERROR.

    IF NOT AVAIL tt-param THEN
        RETURN "NOK":U.
        
    FOR EACH nf-produt-propried FIELDS(cdn-produt-rural nro-docto cod-estabel serie-docto) NO-LOCK
       WHERE nf-produt-propried.it-codigo   = tt-param.it-codigo
         AND nf-produt-propried.cod-period  = tt-param.cod-periodo
         AND nf-produt-propried.num-livre-1 = 0,/* desconsidera complementar */         
       FIRST nota-fiscal FIELDS(nome-transp) NO-LOCK
       WHERE nota-fiscal.nr-nota-fis =  nf-produt-propried.nro-docto
         AND nota-fiscal.cod-estabel =  nf-produt-propried.cod-estabel
         AND nota-fiscal.serie       =  nf-produt-propried.serie-docto,
       FIRST transporte FIELDS(cod-transp nome) NO-LOCK
       WHERE transporte.nome-abrev = nota-fiscal.nome-transp
         AND transporte.cod-transp = pi-cod-transp:
         ASSIGN pl-encontrou-nota = YES.
         LEAVE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaProdutor DBOProgram 
PROCEDURE validaProdutor :
/*------------------------------------------------------------------------------
  Purpose: Verifica se existe registro para o produtor e propriedade    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM p-cod-produtor LIKE produt-rural.cdn-produt-rural.
    DEFINE INPUT PARAM p-cod-propried LIKE propried-rural.cod-propried.

    FOR FIRST bf{&TableName} FIELDS() NO-LOCK
        WHERE bf{&TableName}.cdn-produt-rural = p-cod-produtor
          AND bf{&TableName}.cod-propried     = p-cod-propried:

        RETURN "OK":U.

    END.

    RETURN "NOK":U.

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

