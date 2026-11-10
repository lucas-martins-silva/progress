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
{include/i-prgvrs.i BOIN274SD 2.00.00.030 } /*** 010030 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin274sd MUT}
&ENDIF
/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName ordem-compra
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName ordem-compra
&GLOBAL-DEFINE TableLabel ordem-compra
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin274.p) est† com as funá‰es de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque S‡ nela foram implementadas as triggers do dicion†rio.
**  Para desabilitar as procedures foram usados os prÇ-processadores abaixo.
**  A procedure validateRecord dessa DBO n∆o deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin274.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{cdp/cdcfgmat.i}

/*********** Multiplanta **************/
{cdp/cd7300.i1}
{mpp/mpapi011.i}
/*************************************/

    def var iSequencia     as int.
    def var iOrdAux        as int no-undo.  /* Vari†veis auxiliares para  */
    def var iOrdAux1       as int no-undo.  /* o c†lculo do nro. da Ordem */
    def var iOrdIni        as int no-undo.  /* Vari†veis que devem conter o primeiro       */
    def var iOrdFim        as int no-undo.  /* e £ltimo nro. de ordem nos param. de compra */
    def var iCont          as int no-undo.  /* Contador */
    def var lPrimeiraOrdem as log no-undo.  /* Primeira Ordem est† sendo inclu°da? */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram



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
         HEIGHT             = 2.13
         WIDTH              = 38.14.
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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaContaInvestimento DBOProgram 
PROCEDURE buscaContaInvestimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  parameter c-cod-estabel    like ordem-compra.cod-estabel no-undo.
    def input  parameter i-ordem-inv      like ordem-compra.num-ord-inv no-undo.
    def output parameter c-ct-codigo      as character                  no-undo.
    def output parameter c-sc-codigo      as character                  no-undo.
    def output parameter l-hab-ct         as   log                      no-undo.
    def output parameter l-hab-sc         as   log                      no-undo.
    def output parameter l-hab-ord-serv   as   log                      no-undo.

    def var c-descricao as char no-undo.
    def var l-achou     as log  no-undo.
    &IF "{&mguni_version}" >= "2.071" &THEN
    def var i-empresa   like empresa.ep-codigo.
    &ELSE
    def var i-empresa   as int  no-undo.
    &ENDIF
    def var c-habilita  as char no-undo.
    
    if not avail param-global then
        find first param-global no-lock no-error.
    
    if param-global.modulo-cp then 
        assign l-hab-ord-serv = yes.
    else 
        assign l-hab-ord-serv = no.

    assign l-hab-ct = yes
           l-hab-sc = yes.
    if available param-global       and
       param-global.modulo-in = yes and 
       i-ordem-inv > 0          then do:

        assign l-hab-ct       = no
               l-hab-sc       = no.
        assign l-hab-ord-serv = no.
        
        if not avail estabelec or (avail estabelec and estabelec.cod-estabel <> c-cod-estabel) then
            find estabelec where estabelec.cod-estabel = c-cod-estabel no-lock no-error.

        if avail estabelec then
           assign i-empresa = estabelec.ep-codigo.
    
        run inp/in2112a.p (input  i-empresa,
                           input  i-ordem-inv,
                           output c-descricao,
                           output l-achou,
                           output c-ct-codigo,
                           output c-sc-codigo).
    
        run inp/in2112b.p (input i-empresa,
                           input "habilita-conta":U,
                           output c-habilita).
        assign l-hab-ct = (c-habilita = "yes":U).
    
        if c-sc-codigo = "" or c-sc-codigo = "0" then do:
           assign l-hab-sc = yes.
        end.
    end.

    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME       


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaContaServico DBOProgram 
PROCEDURE buscaContaServico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  parameter i-ordem-servic   like ordem-compra.ordem-servic   no-undo.
    def output parameter c-ct-codigo      as character                     no-undo.
    def output parameter c-sc-codigo      as character                     no-undo.
    def output parameter l-hab-ct         as log                           no-undo.
    def output parameter l-hab-sc         as log                           no-undo.
    def output parameter l-hab-ord-inv    as log                           no-undo.

    if not avail param-global then
        find first param-global no-lock no-error.

    if param-global.modulo-in then 
        assign l-hab-ord-inv = yes. 
    else 
        assign l-hab-ord-inv = no.
    
    assign l-hab-ct = yes
           l-hab-sc = yes.
        
    if available param-global       and
       param-global.modulo-cp = yes and 
       i-ordem-servic > 0           then do:
    
        assign l-hab-ct      = no
               l-hab-sc      = no
               l-hab-ord-inv = no.
    
        if avail param-global and
                 param-global.modulo-mi = yes and 
                 can-find (first ord-manut where ord-manut.nr-ord-produ = i-ordem-servic no-lock)then do:
              for first ord-manut no-lock
                  where ord-manut.nr-ord-produ = i-ordem-servic: 
                  assign c-ct-codigo =  ord-manut.ct-codigo
                         c-sc-codigo =  ord-manut.sc-codigo.
              end.
        end.
        else do:
            for first ord-prod no-lock
                where ord-prod.nr-ord-produ = i-ordem-servic : end.
            if available ord-prod then do: 
                assign c-ct-codigo = ord-prod.ct-codigo
                       c-sc-codigo = ord-prod.sc-codigo.
            end.
            else do:
                assign c-ct-codigo = ""
                       c-sc-codigo = "".
            end.
        end.
    
        if c-ct-codigo = "" or c-ct-codigo = "0" then 
            assign l-hab-ct = yes.

        if c-sc-codigo = "" or c-sc-codigo = "0" then 
            assign l-hab-sc = yes.
    end.
    
    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getItemContrato DBOProgram 
PROCEDURE getItemContrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEF INPUT PARAMETER pNrContrato      AS INT NO-UNDO.
 DEF INPUT-OUTPUT  PARAMETER pSeqitem AS INT NO-UNDO.
 DEF INPUT-OUTPUT PARAMETER pItCodigo AS CHAR FORMAT "x(16)" NO-UNDO.
 DEF OUTPUT PARAMETER pHabItem        AS LOG NO-UNDO.

 IF pNrContrato > 0 THEN DO:

    IF pSeqItem = 0 THEN DO:
        
        FIND contrato-for
           WHERE contrato-for.nr-contrato = pNrContrato 
           NO-LOCK NO-ERROR.
        IF AVAIL contrato-for THEN
           
           FIND FIRST item-contrat 
              WHERE item-contrat.it-codigo   = pItCodigo
              AND   item-contrat.nr-contrato = pNrContrato
              NO-LOCK NO-ERROR.
           IF AVAIL item-contrat THEN
               ASSIGN pSeqItem = item-contrat.num-seq-item
                      pHabItem = NO.
           ELSE
               ASSIGN pSeqItem = 0
                      pHabItem = YES.
    END.
    ELSE DO:
        FIND item-contrat  
            WHERE item-contrat.nr-contrato  = pNrContrato AND
                  item-contrat.num-seq-item = pSeqItem  NO-LOCK NO-ERROR.
        IF AVAIL item-contrat THEN
            ASSIGN pItCodigo = item-contrat.it-codigo
                   pHabItem  = NO.
        ELSE
            ASSIGN pItCodigo = ""
                   pHabitem  = YES.
    END.
 END.
 ELSE
     pHabItem = YES.


          return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaInfOrdemLeaveItem DBOProgram 
PROCEDURE buscaInfOrdemLeaveItem :
/*------------------------------------------------------------------------------
  Purpose:     No cc0300, ao sair do campo item Ç preciso sugerir
               algumas informaá‰es da ordem-compra
------------------------------------------------------------------------------*/
    def input  parameter pc-it-codigo      like ordem-compra.it-codigo      no-undo.
    def input  parameter pc-cod-estabel    like ordem-compra.cod-estabel    no-undo.
    def input  parameter pi-num-pedido     like ordem-compra.num-pedido     no-undo.
    def output parameter pc-cod-comprador  like ordem-compra.cod-comprado   no-undo.
    def output parameter pc-ct-codigo      as character                     no-undo.
    def output parameter pc-sc-codigo      as character                     no-undo.
    def output parameter pc-deposito       like ordem-compra.dep-almoxar    no-undo.
    def output parameter pi-tp-despesa     like ordem-compra.tp-despesa     no-undo.
    def var i-nr-processo as int no-undo initial 0.

    find first item-uni-estab no-lock 
         where item-uni-estab.it-codigo   = pc-it-codigo   
           and item-uni-estab.cod-estabel = pc-cod-estabel no-error.
    if avail item-uni-estab then assign pi-tp-despesa = item-uni-estab.tp-desp-padrao.

    for first pedido-compr fields(nr-processo)
        where pedido-compr.num-pedido = pi-num-pedido no-lock: 
        assign i-nr-processo = pedido-compr.nr-processo.
    end.

    if i-nr-processo <> 0 then do:
       for first proc-compra fields(cod-comprado) 
           where proc-compra.nr-processo = i-nr-processo no-lock: 
           assign pc-cod-comprador = proc-compra.cod-comprado.
       end.
    end.
    else do:
       if avail item-uni-estab then assign pc-cod-comprador = item-uni-estab.cod-comprado.
    end.

    if avail item-uni-estab then
       assign pc-ct-codigo = item-uni-estab.ct-codigo
              pc-sc-codigo = item-uni-estab.sc-codigo
              pc-deposito  = item-uni-estab.deposito-pad.

    for first item no-lock
        where item.it-codigo = pc-it-codigo:
        assign pc-ct-codigo = ITEM.ct-codigo
               pc-sc-codigo = ITEM.sc-codigo.
    end.

    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaInformParcelasOrdemCompra DBOProgram 
PROCEDURE buscaInformParcelasOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:  Carrega vari†veis que retornar∆o com informaá‰es das parcelas das ordens relacionadas a 
            ordem-compra p/ consulta em uma tela de  modificaá∆o da Ordem de Compra / Parcela.
  Parameters: 
            ipar1  : prOrdemCompra  : rowid tabela ordem-compra
            ipar2  : prPrazoCompra  : rowid tabela prazo-compra
            opar3  : pcUn           : unidade de medida na tabela cotacao-item
            opar4  : piMoeda        : c¢digo da moeda
            opar5  : pdaDataEntrega : data de entrega na tabela prazo-compra
            opar6  : pcCodRefer     : codigo da referencia na tabela prazo-compra
            opar7  : pdQtdDoForn    : quantidade fornecedor na tabela prazo-compra
            opar8  : pdQuantidade   : quantidade na tabela prazo-compra
            opar9  : pcNomeAbrev    : nome abreviado na tabela prazo-compra
            opar10 : pcPedidoClien  : pedido do cliente na tabela prazo-compra
            opar11 : pdQtdSalForn   : quantidade do saldo do fornecedor
            opar12 : pdSaldo        : quantidade do saldo na tabela prazo-compra
            opar13 : pcSituacao     : combo carregado com a situaá∆o na tabela prazo-compra
            opar14 : pcUnAnt        : unidade de medida da cotacao-item anterior
  Notes:       
------------------------------------------------------------------------------*/

      def input  param prOrdemCompra  as rowid no-undo.
      def input  param prPrazoCompra  as rowid no-undo.
      def output param pcUn            as char  no-undo.
      def output param piMoeda         as int   no-undo.
      def output param pdaDataEntrega as date  no-undo.
      def output param pcCodRefer     as char  no-undo.
      def output param pdQtdDoForn   as dec   no-undo.
      def output param pdQuantidade    as dec   no-undo.
      def output param pcNomeAbrev    as char  no-undo.
      def output param pcPedidoClien  as char  no-undo.
      def output param pdQtdSalForn  as dec   no-undo.
      def output param pdSaldo         as dec   no-undo.
      def output param pcSituacao     as char  no-undo.
      def output param pcUnAnt        as char no-undo.

    for first ordem-compra fields(it-codigo numero-ordem cod-emitente mo-codigo) where
        rowid(ordem-compra) = prOrdemCompra
        no-lock: end.
    if avail ordem-compra then do:
        if can-find( prazo-compra where
                     rowid(prazo-compra) = prPrazoCompra) then do:
            for first cotacao-item fields (numero-ordem cod-emitente it-codigo 
                                           un           cot-aprovada) where 
                cotacao-item.numero-ordem   = ordem-compra.numero-ordem and
                cotacao-item.cod-emitente   = ordem-compra.cod-emitente and
                cotacao-item.it-codigo      = ordem-compra.it-codigo    and
                cotacao-item.cot-aprovada   = yes no-lock: end.
            if avail cotacao-item then
               assign pcUn     = cotacao-item.un
                      pcUnAnt = cotacao-item.un.
        end.
    end.
    if avail ordem-compra then
       assign piMoeda = ordem-compra.mo-codigo.

    for first prazo-compra fields(numero-ordem data-entrega cod-refer    qtd-do-forn quantidade
                                  nome-abrev   pedido-clien qtd-sal-forn quant-saldo situacao)   where
         rowid(prazo-compra) = prPrazoCompra
         no-lock: end.
    for first ordem-compra fields(numero-ordem it-codigo) where
         ordem-compra.numero-ordem = prazo-compra.numero-ordem no-lock: end.

      if  avail ordem-compra and 
          avail prazo-compra then 
          assign pdaDataEntrega = prazo-compra.data-entrega
                 pcCodRefer     = prazo-compra.cod-refer
                 pdQtdDoForn    = prazo-compra.qtd-do-forn
                 pdQuantidade   = prazo-compra.quantidade
                 pcNomeAbrev    = prazo-compra.nome-abrev
                 pcPedidoClien  = prazo-compra.pedido-clien
                 pdQtdSalForn   = prazo-compra.qtd-sal-forn
                 pdSaldo        = prazo-compra.quant-saldo.
      if avail prazo-compra then 
         assign pcSituacao = string(prazo-compra.situacao).
      else 
         assign pcSituacao = string(02).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piModuloIn DBOProgram 
PROCEDURE piModuloIn :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER pLDesabilita AS LOG NO-UNDO.
    
    FIND FIRST param-global NO-LOCK NO-ERROR.
   
    IF AVAIL param-global 
    AND param-global.modulo-in = NO THEN 

        ASSIGN pLDesabilita = YES.
    ELSE
        ASSIGN pLDesabilita = NO.

   return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraDadosExclusaoMultiplantaOrdemCompra DBOProgram 
PROCEDURE geraDadosExclusaoMultiplantaOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose: Gera dados para envio via multiplanta de eliminaá∆o
           de prazos de compra. 
  Parameters:  ipar1 : piTipoMovto : Tipo do movimento
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter piTipoMovto as int.

     IF param-global.modulo-mp AND
        tt-replica-msg.log-replica-msg = yes THEN DO:
        CREATE tt-dados-env.
        ASSIGN tt-dados-env.num-sequencia  = iSequencia
               tt-dados-env.cod-tipo-reg   = 64
               tt-dados-env.ind-tipo-movto = piTipoMovto
               tt-dados-env.identif-msg    = string({&tablename}.numero-ordem).
        RAW-TRANSFER {&TABLENAME} TO tt-dados-env.conteudo-msg.

        FOR EACH prazo-compra WHERE
                 prazo-compra.numero-ordem = {&TABLENAME}.numero-ordem NO-LOCK:
            ASSIGN iSequencia = iSequencia + 1.
            CREATE tt-dados-env.
            ASSIGN tt-dados-env.num-sequencia  = iSequencia
                   tt-dados-env.cod-tipo-reg   = 65
                   tt-dados-env.ind-tipo-movto = piTipoMovto
                   tt-dados-env.identif-msg    = string(prazo-compra.numero-ordem) + " , " +
                                                 string(prazo-compra.parcela).
            RAW-TRANSFER prazo-compra TO tt-dados-env.conteudo-msg.
        end.
     end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraNumeroOrdemPedEmerg DBOProgram 
PROCEDURE geraNumeroOrdemPedEmerg :
/*------------------------------------------------------------------------------
  Purpose:  Gera um novo n£mero de ordem para a
            manutená∆o de pedidos emergenciais (wcc0310b)  
  Parameters: 
             ipar1 : piOrdem  : N£mero da ordem gerado
             opar2 : rowErrors : Tabela de erros
  
  Notes:       
------------------------------------------------------------------------------*/

    def output param piOrdem as int no-undo.
    def output param table     for rowErrors.

    find first param-compra
        no-lock no-error.
    find first param-global 
        no-lock no-error.

    &IF "{&bf_mat_versao_ems}":U >= "2.08":U &THEN
        RUN ccp/ccapi333.p (INPUT YES,
                            OUTPUT piOrdem).        
        RETURN.

    &ELSE
        assign iOrdIni = param-compra.prim-ord-man * 100.
               iOrdFim = param-compra.ult-ord-man  * 100.
               
        find last ordem-compra where 
                  ordem-compra.numero-ordem <= iOrdFim
                  no-lock no-error.
    
        if avail ordem-compra then do:
            if ordem-compra.numero-ordem = 0 then do:
                assign iCont = 1.
                repeat:
                    find prev ordem-compra no-lock no-error.
                    if avail ordem-compra then
                        if ordem-compra.numero-ordem = 0 then
                            assign iCont = iCont + 1.
                        else leave.                
                    else do:
                        find last ordem-compra where 
                            ordem-compra.numero-ordem <= iOrdFim and 
                            ordem-compra.numero-ordem <> 0 
                            no-lock no-error.
                        if not avail ordem-compra then
                            find last ordem-compra where 
                                ordem-compra.numero-ordem <= iOrdFim
                                no-lock no-error.
                        assign lPrimeiraOrdem = yes.
                        leave.
                    end.
                end.
            end.
            if avail ordem-compra then do:       
                if iCont > 0 and not lPrimeiraOrdem  then do:
                    if (ordem-compra.numero-ordem + 100) > iOrdFim or
                       (ordem-compra.numero-ordem + 100) < iOrdIni then do:
                       assign iOrdAux = param-compra.prim-ord-man.          
                    end.
                    else assign iOrdAux = trunc(ordem-compra.numero-ordem / 100, 0) + iCont + 1.  
                end.
                else do:
                    if (ordem-compra.numero-ordem + 100) > iOrdFim
                    or (ordem-compra.numero-ordem + 100) < iOrdIni then
                        assign iOrdAux = param-compra.prim-ord-man.          
                    else assign iOrdAux = trunc(ordem-compra.numero-ordem / 100, 0) + 1.
                end.
                
            end.
            else assign iOrdAux = param-compra.prim-ord-man.
        end.
        else assign iOrdAux = param-compra.prim-ord-man.
    
        if iOrdAux = param-compra.prim-ord-man then do:
            repeat:
                find ordem-compra where
                    ordem-compra.numero-ordem = (iOrdAux * 100) 
                    no-lock no-error.
                if avail ordem-compra then do:
                    assign iOrdAux = iOrdAux + 1.
                    if iOrdAux > param-compra.ult-ord-man then do:
                        assign piOrdem = iOrdAux * 100.
                        {method/svc/errors/inserr.i
                                             &ErrorNumber="842"
                                             &ErrorType="EMS"
                                             &ErrorSubType="ERROR" }
                    end.
                end.
                else leave.
            end.
        end.
        assign iOrdAux1 = iOrdAux.
    
            /**** cc0301b.i1 ****/
              if avail param-global and param-global.modulo-bh then do:
                find last his-ord-compra no-lock where
                          his-ord-compra.numero-ordem <= param-compra.ult-ord-man * 100 
                          no-error.
                if  avail his-ord-compra 
                and avail ordem-compra
                and his-ord-compra.numero-ordem > ordem-compra.numero-ordem then
                    assign iOrdAux1 = truncate(his-ord-compra.numero-ordem / 100,0) + 1.
              end.          
           /**** cc0301b.i1 ****/
        
        if iOrdAux1 > iOrdAux then
            assign iOrdAux1 = (if iOrdAux1 > param-compra.ult-ord-man or iOrdAux1 < param-compra.prim-ord-man 
                                then param-compra.prim-ord-man else iOrdAux1). 
        else 
            assign iOrdAux1 = iOrdAux.
    
        assign piOrdem = iOrdAux1 * 100.
    &ENDIF.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraNumOrdemAddManutOrdCompra DBOProgram 
PROCEDURE geraNumOrdemAddManutOrdCompra :
/*------------------------------------------------------------------------------
  Purpose:  Procedure para geraá∆o do n£mero da ordem.
            Para ordens normais, ela sugere a pr¢xima numeraá∆o dispon°vel.
            Para ordens m£ltiplas, ela sugere a pr¢xima sequencia dispon°vel para a numeraá∆o passada por parÉmetro.
            Caso n∆o seja passada nenhuma ordem no parÉmetro, ir† sugerir sequencia m£ltipla para nova ordem.
            
            Chamado por wcc0300 e wcc0301.

  Parameters: 
            ipar1  : plNormal          : Indica se a Ordem que est† sendo inclu°da Ç normal ou m£ltipla
            iopar2 : piSequencia       : Sequància para ordens m£ltiplas
            iopar3 : piOrdem           : N£mero da ordem gerado
  Notes:       
------------------------------------------------------------------------------*/
    def input        param plNormal     as log no-undo.  /* Normal ou m£ltipla */ 
    def input        param plIncSeq     as log no-undo.  /* Incrementar s¢ a sequencia? - usado no cc0300b */ 
    def input-output param piSequencia  as int no-undo.  /* Sequencia da Ordem */
    def input-output param piOrdem      as int no-undo.  /* Numero da Ordem    */

    def var c-aux-ordem as char no-undo.
    def var i-seq-aux   as int  no-undo.

    assign i-seq-aux = piSequencia.

    if not plNormal then do:
        find bf{&TableName} where 
             bf{&TableName}.numero-ordem = int(string(piOrdem,"999999") + string(piSequencia,"99"))
             no-lock no-error.
        if not avail bf{&TableName} then do:
           if plIncSeq 
           then return "NOK".
           else do:
                /* Caso n∆o seja informada a ordem, ser† resgatada a £ltima para avaliaá∆o da ordem m£ltipla. */
                def var i-numero-ordem as int  no-undo.
                def var c-numero-ordem as char no-undo.
                run geraNumeroOrdemPedEmerg (output i-numero-ordem, output table RowErrors).
                assign c-numero-ordem = string(i-numero-ordem,"99999999").
                assign piOrdem     = int(substring(c-numero-ordem,1,6))
                       piSequencia = int(substring(c-numero-ordem,7,2)).
           end.
        end.
    end.

    find first param-compra no-lock no-error.
        assign iOrdAux = param-compra.ult-ord-man * 100. 
        find last ordem-compra where 
                  ordem-compra.numero-ordem <> 0 and
                  ordem-compra.numero-ordem <= iOrdAux 
                  no-lock no-error.
        if avail ordem-compra then do:  
            if plIncSeq then do:
                assign iOrdAux     = truncate(bf{&TableName}.numero-ordem / 100 , 0).
                assign c-aux-ordem = string(bf{&TableName}.numero-ordem,"99999999").
                assign piSequencia = int(substring(c-aux-ordem,7,2)).

                assign i-seq-aux = piSequencia.
                repeat:
                    if i-seq-aux = 99 then do:
                       assign plIncSeq = no.
                       assign piSequencia = 0.
                       leave.
                    end.
                    assign i-seq-aux = i-seq-aux + 1.
                    find bf{&TableName} where 
                         bf{&TableName}.numero-ordem = int(string(piOrdem) + string(i-seq-aux))
                         no-lock no-error.
                    if not avail bf{&TableName} 
                       then leave.
                end.
            end.
            if not plIncSeq then do:
                assign iOrdAux = truncate(ordem-compra.numero-ordem / 100 , 0) + 1
                       iOrdAux = (if iOrdAux > param-compra.ult-ord-man
                                  or iOrdAux < param-compra.prim-ord-man
                                  then param-compra.prim-ord-man else iOrdAux).
            end.
        end.
        else
            assign iOrdAux = param-compra.prim-ord-man.

    if plNormal then 
        assign piOrdem     = iOrdAux
               piSequencia = 0.  
    else do:
        assign piSequencia = piSequencia + 1
               piOrdem     = iOrdAux.
    end.

    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH ordem-compra NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE quebraNumOrdemModManutOrdCompra DBOProgram 
PROCEDURE quebraNumOrdemModManutOrdCompra :
/*------------------------------------------------------------------------------
  Purpose:  Gera o N£mero da Ordem na modificaá∆o para a
            Manutená∆o de Ordens (wcc0301a).    
  Parameters: 
            ipar1 : piOrdem           : N£mero da ordem gerado
            opar2 : piSequencia       : Sequància para ordens m£ltiplas
            opar3 : piOrdem           : N£mero da ordem truncada
  Notes:       
------------------------------------------------------------------------------*/
    def input  param piOrdem      as int no-undo.  /* Numero da Ordem    */
    def output param piSequencia  as int no-undo.  /* Sequencia final do nro da Ordem */
    def output param piOrdemTr    as int no-undo.  /* Numero da Ordem truncada   */
    def var cOrdAux as char no-undo.

    if piOrdem > 0 then 
       assign piOrdemTr   = truncate(piOrdem / 100 , 0)
              cOrdAux     = string(piOrdem,"99999999")
              piSequencia = int(substring(cOrdAux,7,2)).

    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCodComprado DBOProgram 
PROCEDURE getCodComprado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pNrProcesso    AS INT  NO-UNDO.
DEF OUTPUT PARAMETER pCodComprado  AS CHAR FORMAT "x(12)" NO-UNDO.
   
   FIND proc-compra
      WHERE proc-compra.nr-processo = pNrProcesso NO-LOCK NO-ERROR.
   IF AVAIL proc-compra THEN
      ASSIGN pCodComprado = proc-compra.cod-comprado.
   ELSE
      ASSIGN pCodComprado = "".

         return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEstabEntrega DBOProgram 
PROCEDURE getEstabEntrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER pEstabEntrega AS CHAR NO-UNDO.
    
FIND FIRST param-compra NO-LOCK NO-ERROR.

    IF AVAIL param-compra THEN 
       ASSIGN pEstabEntrega = param-compra.end-entr-pad.
    ELSE
       ASSIGN pEstabEntrega = "".

         return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnEnableLocEntrega DBOProgram 
PROCEDURE returnEnableLocEntrega :
/*------------------------------------------------------------------------------
  Parameters: rw-oc - rowid da ordem-compra a ser testada.
              l-enable - retorna se dever∆o ser habilitados os campos referentes
                         ao local de entrega no prog manutená∆o de Ordens Compra.
------------------------------------------------------------------------------*/
    def input  param rw-oc    as rowid no-undo.
    def output param l-enable as log   no-undo.

    for first bfordem-compra fields(situacao num-pedido) where
         rowid(bfordem-compra) = rw-oc no-lock: end.
    if  not avail bfordem-compra then
        return "NOK":U.
        
    if  bfordem-compra.situacao = 4 /* eliminada */ then do:
        assign l-enable = no.
        return "NOK":U.
    end.
    
    if  bfordem-compra.num-pedido <> 0 then
         if can-find(first pedido-compr
                     where pedido-compr.num-pedido = bfordem-compra.num-pedido
                       and (   pedido-compr.situacao = 1 /* Impresso */
                            or pedido-compr.situacao = 3 /* Eliminado */ )) then do:
             assign l-enable = no.
             return "NOK":U.                     
         end.
    
    assign l-enable = yes.
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFormatParamGlobal DBOProgram 
PROCEDURE returnFormatParamGlobal :
/*------------------------------------------------------------------------------
  Parameters: c-campo   - recebe o nome do campo com o formato desejado.
              c-formato - retorna o formato do campo recebido como parÉmetro.
  Notes: Retorna o formato parametrizado nos parametros globais (cd0101), do 
         campo recebido como parametro.       
------------------------------------------------------------------------------*/
    def input  param c-campo   as char no-undo.
    def output param c-formato as char no-undo.
    
    find first param-global no-lock no-error.
    
    if  not avail param-global then
        return "NOK":U.

    case c-campo:
         when "formato-cep":U then 
              assign c-formato = param-global.formato-cep.

         when "formato-id-estadual":U then
              assign c-formato = param-global.formato-id-estadual.         

         when "formato-id-federal":U then
              assign c-formato = param-global.formato-id-federal.         

         when "formato-id-pessoal":U then
              assign c-formato = param-global.formato-id-pessoal.         

         when "formato-nr-nota":U then
              assign c-formato = param-global.formato-nr-nota.

         otherwise return "NOK":U.
    end case.
 
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEstabEntrega DBOProgram 
PROCEDURE retornaEstabelecimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 def input  param i-cod-estabel  like estabelec.cod-estabel no-undo.
 def output param i-empresa      like estabelec.ep-codigo   no-undo.
 
 if not avail param-global then
    find first param-global no-lock no-error.

 if  param-global.modulo-in then do:
      find estabelec where 
           estabelec.cod-estabel = i-cod-estabel no-lock no-error.
      if avail estabelec then
          assign i-empresa = estabelec.ep-codigo.
      else
          assign i-empresa = param-global.empresa-prin.   
 end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


