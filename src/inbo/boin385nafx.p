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
{include/i-prgvrs.i BOIN385NAFX 2.00.00.006 } /*** "010006" 17/06/2025 16:40:49 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin385nafx MUT}
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
&GLOBAL-DEFINE DBOName BOIN385NA
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName requisicao
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin385.i RowObject}

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m²todo Receive Message) */
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}

{cdp/cdcfgmat.i}
{include/i-epc200.i "BOIN385NAFX"}
/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Vari veis dos m‚todos setConstraint */
def var c-Requisitante          like requisicao.nome-abrev      no-undo.
def var da-DtRequisicaoIni      like requisicao.dt-requisicao   no-undo.
def var da-DtRequisicaoFim      like requisicao.dt-requisicao   no-undo.
def var l-SolicAbertas          as log                          no-undo.
def var l-SolicIncompletas      as log                          no-undo.
def var l-SolicAprovadas        as log                          no-undo.
def var l-SolicNaoAprovadas     as log                          no-undo.
def var c-Campo                 as char                         no-undo.
def var c-Conteudo              as char                         no-undo.
DEF VAR l-ConsideraRequisEstoque AS LOG                          NO-UNDO.
/*-----Variaveis Estoque-------*/
def var c-Estabelec                  like requisicao.cod-estabel     no-undo.
def var da-DtRequisicaoEstoqIni      like requisicao.dt-requisicao   no-undo.
def var da-DtRequisicaoEstoqFim      like requisicao.dt-requisicao   no-undo.
def var l-Pendentes             as log                          no-undo.
def var l-Atrasadas             as log                          no-undo.
def var l-Fechadas              as log                          no-undo.

/* Vari veis totalizadoras para o portlet */
def var i-Abertas               as int                          no-undo.
def var i-Incompletas           as int                          no-undo.
def var i-AbertasAprovadas      as int                          no-undo.
def var i-AbertasNaoAprovadas   as int                          no-undo.
def var i-Aprovadas             as int                          no-undo.
def var i-NaoAprovadas          as int                          no-undo.
/*-----Variaveis Estoque-------*/
def var i-Pendentes             as int                          no-undo.
def var i-Atrasadas             as int                          no-undo.
def var i-Fechadas              as int                          no-undo.

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
         HEIGHT             = 12
         WIDTH              = 41.86.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryKeepInventoryRequisition DBOProgram 
PROCEDURE openQueryKeepInventoryRequisition :
/*------------------------------------------------------------------------------
  Purpose: Processar as requisi‡äes de estoque.
  Parameters:  <none>
  Notes: Este m‚todo calcula e retorna as Requisi‡oes de estoques, atrasadas,
         pendentes e fechadas.        
------------------------------------------------------------------------------*/

    def var i-index             as int              no-undo.
    def var i-situacao          as int extent 2     no-undo.
    def var l-req-atrasada      as logical          no-undo.

    /* inicializa‡äes */
    empty temp-table RowObject.
                                      
    assign i-Pendentes  = 0
           i-Atrasadas  = 0
           i-Fechadas   = 0.

    for each requisicao
       where requisicao.tp-requis = 1 /* Requisi‡Æo Estoque */
         and requisicao.estado = 1   /* Aprovada */
         and requisicao.dt-requisicao >= da-DtRequisicaoEstoqIni
         and requisicao.dt-requisicao <= da-DtRequisicaoEstoqFim no-lock:
    
        if c-Estabelec <> "" and c-Estabelec <> requisicao.cod-estabel then
            next.
    
        if l-Fechadas and requisicao.situacao = 2 then do:

            create RowObject.
            buffer-copy requisicao to RowObject
            assign RowObject.r-rowid = rowid(requisicao).

        end.
        else do:

            if not l-Fechadas and requisicao.situacao = 2 then
                next.

            for first it-requisicao 
                where it-requisicao.nr-requisicao = requisicao.nr-requisicao
                and   (      (it-requisicao.dt-entrega  < today)
                       &if "{&bf_mat_versao_ems}" >= "2.071" &then

                       or    (    it-requisicao.dt-entrega  = today
                              and it-requisicao.hra-entrega < string(time,"HH:MM"))
                       &endif) no-lock: end. 
            if  avail it-requisicao then 
                assign i-Atrasadas = i-Atrasadas + 1
                       l-req-atrasada = true.
            else
                assign i-Pendentes = i-Pendentes + 1
                       l-req-atrasada = false.


            if not l-Atrasadas and l-req-atrasada  then
                next.

            if not l-Pendentes and not l-req-atrasada  then
                next.      

            create RowObject.
            buffer-copy requisicao to RowObject
            assign RowObject.r-rowid = rowid(requisicao).

        end.
    end.
               
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getMyRequests DBOProgram 
PROCEDURE getMyRequests :
/*------------------------------------------------------------------------------
  Purpose:     Utilizar esse m‚todo para retornar os dados do m‚todo
               openQueryMyRequests.
  Parameters:  
  Notes:       Uso exclusivo do m‚todo openQueryMyRequests, pois a query 
               principal do BO nÆo ‚ aberta nesse caso.
------------------------------------------------------------------------------*/

    def output param table for RowObject.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTotalsInventoryRequisition DBOProgram 
PROCEDURE getTotalsInventoryRequisition :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def output param pPendentes             as integer no-undo.
    def output param pAtrasadas             as integer no-undo.
    def output param pFechadas              as integer no-undo.


        assign pPendentes     = i-Pendentes  
               pAtrasadas     = i-Atrasadas
               pFechadas      = i-Fechadas.
   

    END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTotalsRequester DBOProgram 
PROCEDURE getTotalsRequester :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param pAbertas               as int no-undo.
    def output param pIncompletas           as int no-undo.
    def output param pAbertasAprovadas      as int no-undo.
    def output param pAbertasNaoAprovadas   as int no-undo.
    def output param pAprovadas             as int no-undo.
    def output param pNaoAprovadas          as int no-undo.

    assign pAbertas             = i-abertas
           pIncompletas         = i-incompletas
           pAbertasAprovadas    = i-abertasAprovadas
           pAbertasNaoAprovadas = i-abertasNaoAprovadas
           pAprovadas           = i-Aprovadas
           pNaoAprovadas        = i-NaoAprovadas.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice requisicao
  Parameters:  
               recebe valor do campo nr-requisicao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-requisicao LIKE requisicao.nr-requisicao NO-UNDO.

    FIND FIRST bfrequisicao WHERE 
        bfrequisicao.nr-requisicao = pnr-requisicao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrequisicao THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrequisicao)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMyRequests DBOProgram 
PROCEDURE openQueryMyRequests :
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

    def var i-index             as int              no-undo.
    def var i-situacao          as int extent 2     no-undo.
    DEF VAR i-tp-requis         AS INT              NO-UNDO.
    DEF VAR i-teste             AS INT              NO-UNDO.
    DEF VAR l-can-find-it-req   AS LOG              NO-UNDO.

    /* inicializa‡äes */
    empty temp-table RowObject.
    assign i-abertas             = 0
           i-incompletas         = 0
           i-abertasAprovadas    = 0
           i-abertasNaoAprovadas = 0
           i-Aprovadas           = 0
           i-NaoAprovadas        = 0.

    if  l-ConsideraRequisEstoque then
        assign i-tp-requis = 1.    /* Requisicao Estoque */
    else
        assign i-tp-requis = 2.    /* Solicitacao Compras */
           
    assign i-situacao[1] = 1  /* Aberta */
           i-situacao[2] = 3. /* Incomplementa */
    
    /* ao menos uma op‡Æo deve ser selecionada para carregar os registros */
    if  (   l-SolicAbertas      = yes
         or l-SolicIncompletas  = yes)
    and (   l-SolicAprovadas    = yes
         or l-SolicNaoAprovadas = yes) then do:

        do i-index = 1 to 2:
        
            for each requisicao
                where requisicao.nome-abrev     = c-Requisitante
                  and requisicao.situacao       = i-situacao[i-index]
                  and requisicao.tp-requis     >=  i-tp-requis 
                  and requisicao.dt-requisicao >= da-DtRequisicaoIni 
                  and requisicao.dt-requisicao <= da-DtRequisicaoFim no-lock:

                if  l-ConsideraRequisEstoque and requisicao.tp-requis > 1 then 
                    leave.
    
                /*** Totalizadores para o Portlet e Detalhar do Portlet ***/
                if  requisicao.situacao = 1 then do: /* Abertas */          
                    assign i-Abertas = i-Abertas + 1.
                                    
                    if  requisicao.estado = 1 then /* Aprovadas */
                        assign i-AbertasAprovadas = i-AbertasAprovadas + 1.
                    else
                        assign i-AbertasNaoAprovadas = i-AbertasNaoAprovadas + 1.
                end.
                else if  requisicao.situacao = 3 then /* Incompletas */ 
                    assign i-Incompletas = i-Incompletas + 1.

                /* totalizar requisi‡äes aprovadas e nÆo aprovadas */
                if  requisicao.estado = 1 then /* Aprovadas */
                    assign i-Aprovadas = i-Aprovadas + 1.
                else
                    assign i-NaoAprovadas = i-NaoAprovadas + 1.
                /********************************/

                /* visualizar solicita‡äes abertas */
                if  l-SolicAbertas      = yes
                and l-SolicIncompletas  = no
                and requisicao.situacao <> 1  then next. /* Abertas */

                /* visualizar solicita‡äes incompletas */
                if  l-SolicAbertas      = no
                and l-SolicIncompletas  = yes
                and requisicao.situacao <> 3  then next. /* Incompletas */

                /* visualizar solicita‡äes aprovadas */
                if  l-SolicAprovadas    = yes
                and l-SolicNaoAprovadas = no
                and requisicao.estado   = 2 then next. /* NÆo Aprovada */

                /* visualizar solicita‡äes nÆo aprovadas */
                if  l-SolicAprovadas    = no
                and l-SolicNaoAprovadas = yes
                and requisicao.estado   = 1 then next. /* Aprovada */
 
                if c-campo <> "" then do:

                    case c-campo:
                        when "requisitionsOfItem" then do:
                            if not can-find (first it-requisicao 
                                         where it-requisicao.nr-requisicao = requisicao.nr-requisicao
                                         and   it-requisicao.it-codigo begins c-conteudo) then
                                next.
                        end.
                        when "requisitionsOfItemByDesc" then do:
                            ASSIGN l-can-find-it-req = NO.

                            for each it-requisicao
                               where it-requisicao.nr-requisicao = requisicao.nr-requisicao no-lock:
                                if can-find (item where item.desc-item BEGINS c-conteudo AND
                                             ITEM.it-codigo = it-requisicao.it-codigo) THEN DO:
                                    ASSIGN l-can-find-it-req = YES.
                                    LEAVE.
                                END.
                            end.

                            /* NÆo existem itens nÆo requisi‡Æo que possuam a descri‡Æo pesquisada */
                            IF  l-can-find-it-req = NO THEN
                                NEXT.

                        end.
                        when "site" then do:
                            if not(requisicao.cod-estabel begins c-conteudo) then
                                next.
                        end.
                        when "requisition" then do:
                            ASSIGN i-teste = INT(c-conteudo) NO-ERROR.
                                IF ERROR-STATUS:ERROR THEN
                                    RETURN.
                            if not(requisicao.nr-requisicao = int(c-conteudo)) then
                                next.
                        end.
                    end case.
                end.

               /*Criar UPC input requisicao.nr-requisicao
                           output  l_contens_narrativa*/

                /*--- UPC ---*/
                if  c-nom-prog-dpc-mg97  <> "":U
                or  c-nom-prog-appc-mg97 <> "":U
                or  c-nom-prog-upc-mg97  <> "":U then do:
        
                    FOR EACH tt-epc:
                        DELETE tt-epc.
                    END.

                    CREATE tt-epc.
                    ASSIGN tt-epc.cod-event     = "BOIN385NAFX_openQueryMyRequests"
                           tt-epc.cod-parameter = "BOIN385NAFX_c-campo"
                           tt-epc.val-parameter = c-campo.

                    CREATE tt-epc.
                    ASSIGN tt-epc.cod-event     = "BOIN385NAFX_openQueryMyRequests"
                           tt-epc.cod-parameter = "BOIN385NAFX_c-conteudo"
                           tt-epc.val-parameter = c-conteudo.
        
                    CREATE tt-epc.
                    ASSIGN tt-epc.cod-event     = "BOIN385NAFX_openQueryMyRequests"
                           tt-epc.cod-parameter = "BOIN385NAFX_nr-requis"
                           tt-epc.val-parameter = STRING(requisicao.nr-requisicao).
        
                    {include/i-epc201.i "BOIN385NAFX_openQueryMyRequests"}
        
                    find first tt-epc
                         where tt-epc.cod-event     = "BOIN385NAFX_openQueryMyRequests"
                         and   tt-epc.cod-parameter = "l_contens_narrativa"
                         AND   tt-epc.val-parameter = "NO"
                         no-lock no-error.
                    if  available tt-epc then
                         next.
        
                    FOR EACH tt-epc:
                        DELETE tt-epc.
                    END.
                end. 



               create RowObject.
                buffer-copy requisicao to RowObject
                    assign RowObject.r-rowid = rowid(requisicao).

            end.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMyRequests DBOProgram 
PROCEDURE setConstraintMyRequests :
/*------------------------------------------------------------------------------
  Purpose:     Receber os parƒmetros para abertura da query MyRequests
  Parameters:  pRequisitante....: requisitante logado
               pDtRequisicaoIni.: data inicial para sele‡Æo das requisi‡äes
               pDtRequisicaoFim.: data final para sele‡Æo das requisi‡äes
               pSolicAbertas....: indica que solicita‡äes abertas devem ser
                                  consideradas na sele‡Æo das solicita‡äes
               pSolicIncompletas: indica que solicita‡äes incompletas devem ser
                                  consideradas na sele‡Æo das solicita‡äes
               pSolicAprovada...: indica que solicita‡äes aprovadas devem ser
                                  consideradas na sele‡Æo das solicita‡äes
               pSolicNaoAprovada: indica que solicita‡äes nÆo aprovadas devem ser
                                  consideradas na sele‡Æo das solicita‡äes
               pConsideraRequisEstoque: indica que serÆo consideradas as requisi‡äes
                                        de estoque
  Notes:       
------------------------------------------------------------------------------*/

    def input  param pRequisitante      like requisicao.nome-abrev      no-undo.
    def input  param pDtRequisicaoIni   like requisicao.dt-requisicao   no-undo.
    def input  param pDtRequisicaoFim   like requisicao.dt-requisicao   no-undo.
    def input  param pSolicAbertas      as log                          no-undo.
    def input  param pSolicIncompletas  as log                          no-undo.
    def input  param pSolicAprovadas    as log                          no-undo.
    def input  param pSolicNaoAprovadas as log                          no-undo.
    def input  param pCampo             as char                         no-undo.
    def input  param pConteudo          as char                         no-undo.
    DEF INPUT  PARAM pConsideraRequisEstoque AS LOG                          NO-UNDO.

    assign c-Requisitante           = pRequisitante
           da-DtRequisicaoIni       = pDtRequisicaoIni
           da-DtRequisicaoFim       = pDtRequisicaoFim
           l-SolicAbertas           = pSolicAbertas
           l-SolicIncompletas       = pSolicIncompletas
           l-SolicAprovadas         = pSolicAprovadas
           l-SolicNaoAprovadas      = pSolicNaoAprovadas
           c-Campo                  = pCampo
           c-Conteudo               = pConteudo
           l-ConsideraRequisEstoque = pConsideraRequisEstoque.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintInventoryRequisition DBOProgram 
PROCEDURE setConstraintInventoryRequisition :
/*------------------------------------------------------------------------------
   Purpose:     Receber os parƒmetros para abertura da query KeepInventoryRequisition
  Parameters:  pEstabelec.............: estabelecimento
               pDtRequisicaoEstoqIni..: data inicial para sele‡Æo das requisi‡äes
               pDtRequisicaoEstoqFim..: data final para sele‡Æo das requisi‡äes
               pAtrasadas.............: indica que solicita‡äes Atrasadas devem ser
                                        consideradas na sele‡Æo das solicita‡äes
               pPendentes.............: indica que solicita‡äes Pendentes devem ser
                                        consideradas na sele‡Æo das solicita‡äes
               pFechadas..............: indica que solicita‡äes Fechadas devem ser
                                        consideradas na sele‡Æo das solicita‡äes
  Notes:       
------------------------------------------------------------------------------*/

    def input  param pEstabelec                   like requisicao.cod-estabel     no-undo.
    def input  param pDtRequisicaoEstoqIni        like requisicao.dt-requisicao   no-undo.
    def input  param pDtRequisicaoEstoqFim        like requisicao.dt-requisicao   no-undo.
    def input  param pAtrasadas                   as log                          no-undo.
    def input  param pPendentes                   as log                          no-undo.
    def input  param pFechadas                    as log                          no-undo.

    assign c-Estabelec               = pEstabelec
           da-DtRequisicaoEstoqIni   = pDtRequisicaoEstoqIni
           da-DtRequisicaoEstoqFim   = pDtRequisicaoEstoqFim
           l-Pendentes               = pPendentes
           l-Atrasadas               = pAtrasadas
           l-Fechadas                = pFechadas.
           
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

