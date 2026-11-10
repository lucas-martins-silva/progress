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
{include/i-prgvrs.i BOIN168NAFX 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin168nafx MUT}
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
&GLOBAL-DEFINE DBOName BOIN168NA
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName it-requisicao
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin168.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}

/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m²todo Receive Message) */
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

/* temp-table para tratar pagina‡Æo de registros */
def temp-table ttListaRowid no-undo
    field uid as rowid.

/* Vari veis dos m‚todos setConstraint */
def var i-NumeroOrdem               like it-requisicao.numero-ordem no-undo.
def var i-NrRequisicao              like requisicao.nr-requisicao   no-undo.
def var c-Comprador                 like requisicao.nome-abrev      no-undo.
def var da-DtRequisicaoIni          like requisicao.dt-requisicao   no-undo.
def var da-DtRequisicaoFim          like requisicao.dt-requisicao   no-undo.
def var l-SolicAbertas              as log                          no-undo.
def var l-SolicIncompletas          as log                          no-undo.
def var l-SolicUrgente              as log                          no-undo.
def var l-SolicNaoUrgente           AS log                          no-undo.
DEF VAR c-Campo                     AS CHAR                         NO-UNDO.
DEF VAR c-Conteudo                  AS CHAR                         NO-UNDO.

/* Vari veis totalizadoras para o portlet */
def var i-Urgentes                  as int                          no-undo.
def var i-NaoUrgentes               as int                          no-undo.
def var i-UrgentesAbertas           as int                          no-undo.
def var i-UrgentesIncompletas       as int                          no-undo.
def var i-NaoUrgentesAbertas        as int                          no-undo.
def var i-NaoUrgentesIncompletas    as int                          no-undo.

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
         HEIGHT             = 17.08
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getItemsOfRequestsRule DBOProgram 
PROCEDURE getItemsOfRequestsRule :
/*------------------------------------------------------------------------------
  Purpose:     Utilizar esse m‚todo para retornar os dados do m‚todo
               openQueryItemsOfRequestRule.
  Parameters:  
  Notes:       Uso exclusivo do m‚todo openQueryItemsOfRequestRule, pois a query 
               principal do BO nÆo ‚ aberta nesse caso.
------------------------------------------------------------------------------*/

    def output param table for RowObject.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTotalsBuyer DBOProgram 
PROCEDURE getTotalsBuyer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param pUrgentes                 as int no-undo.
    def output param pNaoUrgentes              as int no-undo.
    def output param pUrgentesAbertas          as int no-undo.
    def output param pUrgentesIncompletas      as int no-undo.
    def output param pNaoUrgentesAbertas       as int no-undo.
    def output param pNaoUrgentesIncompletas   as int no-undo.

    assign pUrgentes               = i-Urgentes
           pNaoUrgentes            = i-NaoUrgentes
           pUrgentesAbertas        = i-UrgentesAbertas
           pUrgentesIncompletas    = i-UrgentesIncompletas
           pNaoUrgentesAbertas     = i-NaoUrgentesAbertas
           pNaoUrgentesIncompletas = i-NaoUrgentesIncompletas.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice item-req
  Parameters:  
               recebe valor do campo nr-requisicao
               recebe valor do campo sequencia
               recebe valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-requisicao LIKE it-requisicao.nr-requisicao NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE it-requisicao.sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE it-requisicao.it-codigo NO-UNDO.

    FIND FIRST bfit-requisicao WHERE 
        bfit-requisicao.nr-requisicao = pnr-requisicao AND 
        bfit-requisicao.sequencia = psequencia AND 
        bfit-requisicao.it-codigo = pit-codigo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfit-requisicao THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfit-requisicao)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemsOfRequest DBOProgram 
PROCEDURE openQueryItemsOfRequest :
/*------------------------------------------------------------------------------
  Purpose:     Abre a query para os itens de um requisi‡Æo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName}
        for each {&tableName}
            where {&tableName}.nr-requisicao = i-NrRequisicao no-lock indexed-reposition.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemsOfRequestRule DBOProgram 
PROCEDURE openQueryItemsOfRequestRule :
/*------------------------------------------------------------------------------
  Purpose:     Processar as requisi‡äes do requisitante, bem como calcular os 
               totais a serem apresentados no portlet "Minhas Solicita‡äes"
  Parameters:  <none>
  Notes:       Este m‚todo apenas efetua a leitura da base de dados conforme
               os paramˆtros de entrada. Para obter o resultado desse processa-
               mento devem ser executados o m‚todo getBatchRecords para obten‡Æo
               da temp-table com os resultados e o m‚todo getTotalsRequester
               para obter os totalizadores.
               Obs.: NÆo deve ser executado pelo m‚todo openQeuryStatic, mas
               diretamente. Ex.: run openQeuryMyRequests in h-boin385na.
------------------------------------------------------------------------------*/

    FOR EACH it-requisicao WHERE it-requisicao.nr-requisicao = i-NrRequisicao NO-LOCK:
        if c-campo <> "" then do:   
            case c-campo:
                when "requisitionsOfItem" then do:
                    if not it-requisicao.it-codigo begins c-conteudo then
                        next.
                end.
                when "requisitionsOfItemByDesc" then do:

                    {cdp/finditem.i it-requisicao.it-codigo}
                    IF AVAIL ITEM THEN
                        IF NOT ITEM.desc-item BEGINS c-conteudo THEN
                            NEXT.
                end.
            end case.
        end.

        create RowObject.
        buffer-copy it-requisicao to RowObject
           assign RowObject.r-rowid = rowid(it-requisicao).
    END.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRequestsOfRequisition DBOProgram 
PROCEDURE openQueryRequestsOfRequisition :
/*------------------------------------------------------------------------------
  Purpose:     Abre a query para as requisi‡äes de uma ordem de compra
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName}
        for each {&tableName}
            where {&tableName}.numero-ordem = i-NumeroOrdem no-lock indexed-reposition.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItemsOfRequest DBOProgram 
PROCEDURE setConstraintItemsOfRequest :
/*------------------------------------------------------------------------------
  Purpose:     Receber os parƒmetros para abertura da query ItemsOfRequest
  Parameters:  pNrRequisicao: n£mero da requisi‡Æo
  Notes:       
------------------------------------------------------------------------------*/

    def input param pNrRequisicao like requisicao.nr-requisicao no-undo.

    assign i-NrRequisicao = pNrRequisicao.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItemsOfRequestRule DBOProgram 
PROCEDURE setConstraintItemsOfRequestRule :
/*------------------------------------------------------------------------------
  Purpose:     Receber os parƒmetros para abertura da query MyRequests
  Parameters:  pNrRequisicao: n£mero da requisi‡Æo
               pCampo: Campo pelo qual ser  feito o campo
               pCriterio: Crit‚rio do filtro
  Notes:       
------------------------------------------------------------------------------*/

    def input param pNrRequisicao like requisicao.nr-requisicao no-undo.
    DEF INPUT PARAM pCampo    AS CHAR NO-UNDO.
    DEF INPUT PARAM pCriterio AS CHAR NO-UNDO.

    assign i-NrRequisicao = pNrRequisicao
           c-Campo        = pCampo
           c-Conteudo     = pCriterio.

    return "OK".

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRequestsOfRequisition DBOProgram 
PROCEDURE setConstraintRequestsOfRequisition :
/*------------------------------------------------------------------------------
  Purpose:     Receber os parƒmetros para abertura da query RequestsOfRequisition
  Parameters:  pNumeroOrdem: n£mero da ordem de compra
  Notes:       
------------------------------------------------------------------------------*/

    def input param pNumeroOrdem like it-requisicao.numero-ordem no-undo.

    assign i-NumeroOrdem = pNumeroOrdem.

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

