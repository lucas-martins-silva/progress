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
{include/i-prgvrs.i BOIN358NAFX 2.00.00.001} /*** "010001" 17/06/2025 16:40:48 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN


{include/i-license-manager.i boin358nafx MUT}
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
&GLOBAL-DEFINE DBOName BOIN358
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName proc-compra
&GLOBAL-DEFINE TableLabel Pacotes de Compra
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin358.i RowObject}

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
def var c-Comprador              like proc-compra.cod-comprado   no-undo.
def var da-DtCriacaoPacoteIni    like proc-compra.dt-inicio      no-undo.
def var da-DtCriacaoPacoteFim    like proc-compra.dt-inicio      no-undo.
def var i-SituacaoSelecionada    like ordem-compra.situacao      no-undo.

/* Vari veis totalizadoras para o portlet */
def var i-PacotesSemCotacao     as int      no-undo.
def var i-PacotesEmCotacao      as int      no-undo.
def var i-PacotesCotados        as int      no-undo.
def var i-TodasSituacoes        as int      no-undo.

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
         HEIGHT             = 10.58
         WIDTH              = 44.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPurchasePackage DBOProgram 
PROCEDURE getPurchasePackage :
/*------------------------------------------------------------------------------
  Purpose:     Utilizar esse m‚todo para retornar os dados do m‚todo
               openQueryPurchasePackage.
  Parameters:  
  Notes:       Uso exclusivo do m‚todo openQueryPurchasePackage, pois a query 
               principal do BO nÆo ‚ aberta nesse caso.
------------------------------------------------------------------------------*/

    def output param table for RowObject.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTotalsPurchasePackage DBOProgram 
PROCEDURE getTotalsPurchasePackage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param pPacotesSemCotacao     as int no-undo.
    def output param pPacotesEmCotacao      as int no-undo.
    def output param pPacotesCotados        as int no-undo.
    def output param pTodasSituacoes        as int no-undo.

    assign pPacotesSemCotacao = i-PacotesSemCotacao
           pPacotesEmCotacao  = i-PacotesEmCotacao
           pPacotesCotados    = i-PacotesCotados
           pTodasSituacoes    = i-TodasSituacoes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice codigo
  Parameters:  
               recebe valor do campo nr-processo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-processo LIKE proc-compra.nr-processo NO-UNDO.

    FIND FIRST bfproc-compra WHERE 
        bfproc-compra.nr-processo = pnr-processo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproc-compra THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproc-compra)).
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

    open query {&QueryName}
        for each {&tableName} no-lock indexed-reposition.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPurchasePackage DBOProgram 
PROCEDURE openQueryPurchasePackage :
/*------------------------------------------------------------------------------
  Purpose:     Processar os pacotes de compra do comprador, bem como calcular os 
               totais a serem apresentados no portlet "Pacotes de Compra".
  Parameters:  <none>
  Notes:       Este m‚todo apenas efetua a leitura da base de dados conforme
               os paramˆtros de entrada. Para obter o resultado desse processa-
               mento devem ser executados o m‚todo getBatchRecords para obten‡Æo
               da temp-table com os resultados e o m‚todo getTotalsPurchRequisition
               para obter os totalizadores.
------------------------------------------------------------------------------*/
    
    def var i-OrdensSemCotacao      as int      no-undo.
    def var i-OrdensEmCotacao       as int      no-undo.
    def var i-OrdensCotados         as int      no-undo.
    def var i-SituacaoPacote        as int      no-undo.
    
    /* inicializa‡äes */
    empty temp-table RowObject.
    assign i-PacotesSemCotacao = 0
           i-PacotesEmCotacao  = 0
           i-PacotesCotados    = 0
           i-TodasSituacoes    = 0.

    for each proc-compra
        where proc-compra.cod-comprado  = c-Comprador
          and proc-compra.dt-inicio  >= da-DtCriacaoPacoteIni
          and proc-compra.dt-inicio  <= da-DtCriacaoPacoteFim no-lock:

        assign i-SituacaoPacote   = 0
               i-OrdensSemCotacao = 0
               i-OrdensEmCotacao  = 0
               i-OrdensCotados    = 0.

        /*** Totalizadores para o Portlet ***/

        assign i-TodasSituacoes = i-TodasSituacoes + 1.

        if  not can-find(first ordem-compra
                         where ordem-compra.nr-processo = proc-compra.nr-processo) then
            assign i-PacotesSemCotacao = i-PacotesSemCotacao + 1 /* Se nÆo houver ordem para o pacote considera como Sem Cota‡Æo */
                   i-SituacaoPacote    = 1. /* Sem Cota‡Æo */
        else do:
            for each ordem-compra fields (nr-processo situacao numero-ordem)
                where ordem-compra.nr-processo = proc-compra.nr-processo no-lock:
    
                if  ordem-compra.situacao = 2 /* Confirmada */
                or  ordem-compra.situacao = 4 /* Eliminada */
                or  ordem-compra.situacao = 6 /* Recebida */ then next.
                else if ordem-compra.situacao = 5 /* Em Cota‡Æo */ then do:
                    assign i-OrdensEmCotacao = i-OrdensEmCotacao + 1.
                    leave. /* basta uma ordem de compra com situa‡Æo "Em Cota‡Æo" para que o pacote seja considerado "Em Cota‡Æo" */
                end.
                else if ordem-compra.situacao = 1 /* Sem Cota‡Æo */ then
                    assign i-OrdensSemCotacao = i-OrdensSemCotacao + 1.
                else if ordem-compra.situacao = 3 /* Cotada */ then
                    assign i-OrdensCotados = i-OrdensCotados + 1.

            end.
    
            /* Classifica‡Æo da Pacote de acordo com a situa‡Æo das Ordens do Pacote */
            if  i-OrdensCotados    > 0
            and i-OrdensEmCotacao  = 0 
            and i-OrdensSemCotacao = 0 then
                assign i-PacotesCotados = i-PacotesCotados + 1
                       i-SituacaoPacote = 3. /* Cotada */
            else if i-OrdensCotados    = 0
                and i-OrdensEmCotacao  = 0 
                and i-OrdensSemCotacao > 0 then
                assign i-PacotesSemCotacao = i-PacotesSemCotacao + 1
                       i-SituacaoPacote    = 1. /* Sem Cota‡Æo */
            else if i-OrdensEmCotacao  > 0
                 or i-OrdensSemCotacao > 0 then
                 assign i-PacotesEmCotacao = i-PacotesEmCotacao + 1
                        i-SituacaoPacote   = 2. /* Em Cota‡Æo */
        end.
        /************************************/

        /* Situa‡Æo selecionada nÆo corresponde a situa‡Æo do Pacote de Compra */
        /* i-SituacaoSelecionada = 1 -> Sem Cota‡Æo */
        /* i-SituacaoSelecionada = 2 -> Em Cota‡Æo */
        /* i-SituacaoSelecionada = 3 -> Cotada */
        /* i-SituacaoSelecionada = 4 -> Todas as situa‡äes poss¡veis para o pacote (1, 2 e 3) */
        if  i-SituacaoSelecionada <> 4 /* se igual a 4, visualiza todos os pacotes independente da situa‡Æo */
        and i-SituacaoSelecionada <> i-SituacaoPacote then next.

        create RowObject.
        buffer-copy proc-compra to RowObject
            assign RowObject.r-rowid = rowid(proc-compra).
    end.

    return "OK".

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPurchasePackage DBOProgram 
PROCEDURE setConstraintPurchasePackage :
/*------------------------------------------------------------------------------
  Purpose:     Receber os parƒmetros para abertura da query PurchasePackage
  Parameters:  pComprador..........: comprador logado
               pDtCriacaoPacoteIni.: data inicial para sele‡Æo dos pacotes
               pDtCriacaoPacoteFim.: data final para sele‡Æo dos pacotes
               pSituacaoPacote.....: situa‡Æo do pacote de compra
  Notes:       
------------------------------------------------------------------------------*/

    def input  param pComprador             like proc-compra.cod-comprado   no-undo.
    def input  param pDtCriacaoPacoteIni    like proc-compra.dt-inicio      no-undo.
    def input  param pDtCriacaoPacoteFim    like proc-compra.dt-inicio      no-undo.
    def input  param pSituacaoSelecionada   like ordem-compra.situacao      no-undo.

    assign c-Comprador           = pComprador
           da-DtCriacaoPacoteIni = pDtCriacaoPacoteIni
           da-DtCriacaoPacoteFim = pDtCriacaoPacoteFim
           i-SituacaoSelecionada = pSituacaoSelecionada.

    return "OK".

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

