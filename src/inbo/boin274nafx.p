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
{include/i-prgvrs.i BOIN274NAFX 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin274nafx MUT}
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
&GLOBAL-DEFINE DBOName BOIN274
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ordem-compra
&GLOBAL-DEFINE TableLabel Ordem Compra
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin274.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* temp-table para tratar pagina‡Æo de registros */
def temp-table ttListaRowid no-undo
    field uid as rowid.

/* Vari veis dos m‚todos setConstraint */
def var c-Comprador          like ordem-compra.cod-comprado     no-undo.
def var da-DtEmissaoIni      like ordem-compra.data-emissao     no-undo.
def var da-DtEmissaoFim      like ordem-compra.data-emissao     no-undo.
def var i-Situacao           like ordem-compra.situacao         no-undo.
def var l-PendAprovador      as log                             no-undo.
def var l-NaoPendAprovador   as log                             no-undo.
def var i-NrProcesso         like ordem-compra.nr-processo      no-undo.
def var i-NumPedido          like ordem-compra.num-pedido       no-undo.

/* Vari veis totalizadoras para o portlet */
def var i-SemCotacao         as int                             no-undo.
def var i-EmCotacao          as int                             no-undo.
def var i-Cotada             as int                             no-undo.

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
         HEIGHT             = 12.54
         WIDTH              = 46.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTotalsPurchRequisition DBOProgram 
PROCEDURE getTotalsPurchRequisition :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param pSemCotacao      as int no-undo.
    def output param pEmCotacao       as int no-undo.
    def output param pCotada          as int no-undo.

    assign pSemCotacao = i-SemCotacao
           pEmCotacao  = i-EmCotacao
           pCotada     = i-Cotada.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice ordem
  Parameters:  
               recebe valor do campo numero-ordem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    FIND FIRST bfordem-compra WHERE 
        bfordem-compra.numero-ordem = pnumero-ordem NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfordem-compra THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfordem-compra)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRequisitionsOfOrder DBOProgram 
PROCEDURE openQueryRequisitionsOfOrder :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    for each ordem-compra
        where ordem-compra.num-pedido = i-NumPedido no-lock:

        create RowObject.
        buffer-copy ordem-compra to RowObject
            assign RowObject.r-rowid = rowid(ordem-compra).
    end.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRequisitionsOfPackage DBOProgram 
PROCEDURE openQueryRequisitionsOfPackage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    for each ordem-compra
        where ordem-compra.nr-processo = i-NrProcesso no-lock:

        create RowObject.
        buffer-copy ordem-compra to RowObject
            assign RowObject.r-rowid = rowid(ordem-compra).
    end.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySearchPurchaseRequisitions DBOProgram 
PROCEDURE openQuerySearchPurchaseRequisitions :
/*------------------------------------------------------------------------------
  Purpose:     Pesquisar as ordens de compra que estÆo sob responsabilidade do
               comprador para vincul -las ao pacote de compra.
  Parameters:  c-Comprador.: comprador logado
  Notes:       Permite ao comprador vincular ao pacote selecionada as ordens de
               compra que estÆo sob sua responsabilidade. Ser  permitido vincular
               ordens com situa‡Æo "Sem Cota‡Æo", "Em Cota‡Æo", "Cotada" e
               "Confirmada" e que ainda nÆo tenham sido vinculadas nenhum pacote.
               Caso a ordem de compra esteja relacionada a algum pedido de compra,
               s¢ ser  permitido vincular a ordem ao pacote se o pedido tamb‚m
               pertencer ao pacote em questÆo.
------------------------------------------------------------------------------*/

    def var i-index              as int             no-undo.
    def var i-situacoes          as int extent 4    no-undo.
    def var l-erro               as log             no-undo.

    {cdp/findparamglobal.i}

    assign i-situacoes[1] = 1  /* Sem Cota‡Æo */
           i-situacoes[2] = 2  /* Confirmada */
           i-situacoes[3] = 3  /* Cotada */
           i-situacoes[4] = 5. /* Em Cota‡Æo */

    do  i-index = 1 to 4:
    
        for each ordem-compra use-index compr-sit
            where ordem-compra.cod-comprado  = c-Comprador
              and ordem-compra.situacao      = i-situacoes[i-index]
              and ordem-compra.nr-processo   = 0 no-lock:

            /* NÆo carrega ordens de compra cujo pacote selecionado     */
            /* seja diferente do pacote informado no pedido de compra.  */
            /* Condi‡Æo aplicada apenas a ordens de compra confirmadas. */
            if  ordem-compra.num-pedido <> 0 then do:
                {cdp/findpedidocompr.i ordem-compra.num-pedido}
                if  avail pedido-compr then do:
                    if  pedido-compr.nr-processo <> i-NrProcesso then 
                        next.
                end.
                else 
                    next.
            end.

            if   param-global.modulo-mp
            and (   ordem-compra.num-pedido = 0
                 or can-find(first pedido-compr
                             where pedido-compr.num-pedido = ordem-compra.num-pedido
                               and pedido-compr.situacao = 1 /* Impresso */ )) then do:
                run ccp/ccapi199.p(input  "Ordem-compra",
                                   input  rowid(ordem-compra),
                                   output l-erro).
                if  l-erro then
                    next.
            end.
  
            create RowObject.
            buffer-copy ordem-compra to RowObject
                assign RowObject.r-rowid = rowid(ordem-compra).
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnRowids DBOProgram 
PROCEDURE returnRowids :
/*------------------------------------------------------------------------------
  Purpose:     Possibilitar o tratamento de pagina‡Æo de registros.
  Parameters:  ttListaRowid: temp-table com o rowid dos registros carregados
               pelos m‚todos openQuery.
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for ttListaRowid.

    empty temp-table ttListaRowid.

    for each RowObject:
        create ttListaRowid.
        assign ttListaRowid.uid = RowObject.r-rowid.
    end.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRequisitionsOfOrder DBOProgram 
PROCEDURE setConstraintRequisitionsOfOrder :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pNumPedido like ordem-compra.num-pedido  no-undo.

    assign i-NumPedido = pNumPedido.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRequisitionsOfPackage DBOProgram 
PROCEDURE setConstraintRequisitionsOfPackage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pNrProcesso like ordem-compra.nr-processo no-undo.

    assign i-NrProcesso = pNrProcesso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSearchPurchaseRequisitions DBOProgram 
PROCEDURE setConstraintSearchPurchaseRequisitions :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param pComprador            like ordem-compra.cod-comprado no-undo.
    def input  param pNrProcesso           like ordem-compra.nr-processo  no-undo.

    assign c-Comprador  = pComprador
           i-NrProcesso = pNrProcesso.

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

