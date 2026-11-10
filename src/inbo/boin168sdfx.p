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
{include/i-prgvrs.i BOIN168SDFX 2.00.00.026 } /*** "010026" 06/01/2025 11:40:36  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin168sdfx MUT}
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
&GLOBAL-DEFINE DBOName BOIN168SD
&GLOBAL-DEFINE DBOVersion
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName it-requisicao
&GLOBAL-DEFINE TableLabel Item Requisiá∆o
&GLOBAL-DEFINE QueryName qr{&TableName}

{cdp/cdcfgmat.i}
{inbo/boin168.i RowObject}
{inbo/boin168.i RowObjectDefault}
{inbo/boin658fx.i ttUnidNegRequis}
{inbo/boin658fx.i ttUnidNegRequisDefault}

def temp-table tt-unid-neg-inv no-undo
    field cod-unid-neg as char
    field perc-rateio  as dec.

&GLOBAL-DEFINE excludeFrameDefinition yes
{cdp/cd0666.i} /* tt-erro */

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
    
{utp/ut-glob.i} /* Vari†veis Globais  */
{cdp/cd9590.i}  /* Unidade de Neg¢cio */
{include/i-epc200.i "boin168sdfx"} /* EPC */

def var h-cdapi024                      as handle no-undo.
def var h-boiv029                       as handle no-undo.
def var i-empresa                       as character no-undo.
def var i-count                         as integer no-undo.
def var i-sequencia                     as integer no-undo.

/* Funcao criada para sugerir a sequencia dos itens de 1 em 1 */
DEF VAR l-sequencia-unitaria AS LOGICAL NO-UNDO.
ASSIGN l-sequencia-unitaria = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-seq-req-solic":U
                                                      AND funcao.ativo     = YES).

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer   
    field ttv_des_msg_ajuda as character
    field ttv_des_msg_erro  as character.

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
         HEIGHT             = 22.29
         WIDTH              = 34.43.
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


{method/svc/autentic/autentic.i         
            &vUserName="c-seg-usuario"}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields DBOProgram 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Habilitar os campos de interface segundo a regra de neg¢cio.
  Parameters:  pType: Tipo de Transaá∆o ("Create", "Update" ou "Delete") 
               pFieldName: Atributo da tabela.
               pFieldEnable: Habilita ou n∆o o atributo.
  Notes:       
------------------------------------------------------------------------------*/

    def input  param pType        as char               no-undo.
    def input  param pFieldName   as char               no-undo.
    def output param pFieldEnable as log    init yes    no-undo.

    def var c-enable              as char no-undo. /* Quando houver ordem de investimento informada */

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    if  not avail requisicao then
        return "NOK".

    {cdp/findestabelec.i requisicao.cod-estabel}
    if  not avail estabelec then
        return "NOK".

    {cdp/finditem.i RowObject.it-codigo}
    if  not avail item then
        return "NOK".

    {cdp/finditemuniestab.i RowObject.it-codigo requisicao.cod-estabel}
    if  not avail item-uni-estab then
        return "NOK".

    {cdp/findusuarmater.i requisicao.nome-abrev}
    if  not avail usuar-mater then
        return "NOK".
    
    {cdp/findparamglobal.i}
    if  not avail param-global then
        return "NOK".

    {cdp/findparammat.i}
    if  not avail param-mat then
        return "NOK".

    if  connected("mginv")
    and param-global.modulo-in
    and RowObject.num-ord-inv <> 0 then      
        run inp/in2112b.p (input estabelec.ep-codigo,
                           input "habilita-conta",
                           output c-enable).

    case pFieldName:
        when "it-codigo" then 
            assign pFieldEnable = pType = "create".

        when "ct-codigo" then
            assign pFieldEnable = usuar-mater.log-1.

        when "sc-codigo" then 
            assign pFieldEnable = usuar-mater.log-2.

        when "cod-refer" then
            assign pFieldEnable = item.tipo-con-est = 4. /* Referància */

        when "preco-unit" then
            assign pFieldEnable =     requisicao.tp-requis = 2 /* Solicitaá∆o de Compra */
                                  and item.tipo-contr      = 4. /* DÇbito Direto */

        when "utilizationCode" then
            assign pFieldEnable = IF RowObject.num-ord-inv <> 0 AND param-global.modulo-in THEN NO 
                                  ELSE substr(usuar-mater.char-1,1,1) = "y". /* Utilizaá‰es Materiais */
        
        when "num-ord-inv" then
            assign pFieldEnable =     connected("mginv")
                                  and param-global.modulo-in 
                                  and pType = "create":U.

        when "cod-unid-negoc" then
            assign pFieldEnable =   (    l-unidade-negocio
                                     and requisicao.tp-requis = 1 /* Requisiá∆o */
                                     and (    (    pType = "create"
                                               and RowObject.num-ord-inv = 0)
                                          or  (    pType = "update"
                                               and RowObject.qt-atendida  = 0
                                               and RowObject.num-ord-inv  = 0)
                                          )
                                     )
                                  or (l-mat-unid-negoc and 
                                     (requisicao.tp-requis = 2 /* Solicitaá∆o Compra */ or 
                                      requisicao.tp-requis = 3) /* Solicitaá∆o Cotaá∆o */ and 
                                     ((pType = "create" and 
                                      RowObject.num-ord-inv = 0) or  
                                     ( pType = "update" and 
                                       RowObject.situacao <> 4 /* Com Ordem */ and 
                                       RowObject.num-ord-inv = 0)) and 
                                     ((RowObject.ct-codigo + RowObject.sc-codigo) <> "" or 
                                      item-uni-estab.altera-conta)).
        when "un" then
            assign pFieldEnable = param-mat.ind-sit-un = 1 /* Unidade de Medida: Informa */ or 
                                 (param-mat.ind-sit-un = 2 /* Unidade de Medida: Default Item */ and 
                                 (RowObject.it-codigo = ? or RowObject.it-codigo = "" or item.tipo-contr = 4)). /* DÇbito Direto */
        when "conta-contabil" then
            assign pFieldEnable = no. /* o campo Conta Cont†bil sempre permanecer† desabilitado */
    end case.

    return "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAveragePrice DBOProgram 
PROCEDURE getAveragePrice :
/*------------------------------------------------------------------------------
  Purpose:     Retornar o preáo mÇdio do item para valorizar a requisiá∆o.
  Parameters:  pPrecoMedio: preáo mÇdio
  Notes:       
------------------------------------------------------------------------------*/

    def output param pPrecoMedio        as dec no-undo.

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    if  avail requisicao then do:

        {cdp/findestabmat.i requisicao.cod-estabel}
        if  avail estab-mat then do:

            {cdp/finditemestab.i RowObject.it-codigo requisicao.cod-estabel}
            if  avail item-estab then do:

                if  estab-mat.custo-contab = 1 then /* Mensal */
                    assign pPrecoMedio = (item-estab.val-unit-mat-m[1]
                                       +  item-estab.val-unit-ggf-m[1]
                                       +  item-estab.val-unit-mob-m[1]).
                else if estab-mat.custo-contab = 2 then /* On-line */
                    assign pPrecoMedio = (item-estab.val-unit-mat-o[1]
                                       +  item-estab.val-unit-ggf-o[1]
                                       +  item-estab.val-unit-mob-o[1]).
            end.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBasePrice DBOProgram 
PROCEDURE getBasePrice :
/*------------------------------------------------------------------------------
  Purpose:     Retornar o preáo base do item para valorizar a requisiá∆o.
  Parameters:  pPrecoRepos: preáo base
  Notes:       
------------------------------------------------------------------------------*/

    def output param pPrecoRepos        as dec no-undo.

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    if  avail requisicao then do:

        {cdp/finditemuniestab.i RowObject.it-codigo requisicao.cod-estabel}
        {cdp/finditem.i RowObject.it-codigo}
        IF AVAILABLE item THEN
            ASSIGN pPrecoRepos = item.preco-base.
        if  avail item-uni-estab then
            assign pPrecoRepos = item-uni-estab.preco-base.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLastReceiptPrice DBOProgram 
PROCEDURE getLastReceiptPrice :
/*------------------------------------------------------------------------------
  Purpose:     Retornar o preáo de £ltima entrada do item para valorizar a requisiá∆o.
  Parameters:  pPrecoUltEnt: preáo de £ltima entrada
  Notes:       
------------------------------------------------------------------------------*/

    def output param pPrecoUltEnt        as dec no-undo.

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    if  avail requisicao then do:

        {cdp/finditemuniestab.i RowObject.it-codigo requisicao.cod-estabel}
        {cdp/finditem.i RowObject.it-codigo}
        IF AVAILABLE item THEN
            ASSIGN pPrecoUltEnt = item.preco-ul-ent.

        if  avail item-uni-estab then
            assign pPrecoUltEnt = item-uni-estab.preco-ul-ent.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLastSequence DBOProgram 
PROCEDURE getLastSequence :
/*------------------------------------------------------------------------------
  Purpose:     Retornar o numero da £ltima sequencia da requisicao
  Parameters:  pPrecoUltEnt: numero da requisicao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNrRequisicao AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pSequence     AS INTEGER NO-UNDO.

    FIND LAST it-requisicao NO-LOCK
        WHERE it-requisicao.nr-requisicao = pNrRequisicao NO-ERROR.
        
    IF NOT AVAILABLE it-requisicao THEN RETURN "NOK":U.
    
    ASSIGN pSequence = it-requisicao.sequencia.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getReplacementPrice DBOProgram 
PROCEDURE getReplacementPrice :
/*------------------------------------------------------------------------------
  Purpose:     Retornar o preáo de reposiá∆o do item para valorizar a requisiá∆o.
  Parameters:  pPrecoRepos: preáo de reposiá∆o
  Notes:       
------------------------------------------------------------------------------*/

    def output param pPrecoRepos        as dec no-undo.

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    if  avail requisicao then do:

        {cdp/finditemuniestab.i RowObject.it-codigo requisicao.cod-estabel}
        {cdp/finditem.i RowObject.it-codigo}
        IF AVAILABLE item THEN
            ASSIGN pPrecoRepos = item.preco-repos.
        if  avail item-uni-estab then
            assign pPrecoRepos = item-uni-estab.preco-repos.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveCodUtilizacao DBOProgram 
PROCEDURE leaveCodUtilizacao :
/*------------------------------------------------------------------------------
  Purpose:     Executar a sugest∆o de valores default a partir do c¢digo de
               utilizaá∆o.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

	if  RowObject.num-ord-inv = 0 then do:
		{cdp/findrequisicao.i RowObject.nr-requisicao}
		if  avail requisicao then do:
			{cdp/finditemuniestab.i RowObject.it-codigo requisicao.cod-estabel}
			if  avail item-uni-estab
			and item-uni-estab.altera-conta = no then do:
				{cdp/findusuarmater.i requisicao.nome-abrev}
				if  avail usuar-mater
				and substr(usuar-mater.char-1,1,1) = "y" /* Utilizaá‰es Material */
				and RowObject.num-ord-inv = 0 then do:
					{cdp/findnaturezadespesa.i item-uni-estab.nat-despesa}
					if  avail natureza-despesa then do:
						find first utiliz-natu-despes no-lock 
							where utiliz-natu-despes.cod-nat-despesa = natureza-despesa.nat-despesa and utiliz-natu-despes.cod-utiliz = substring(RowObjectDefault.char-2,1,12) no-error.
						if avail utiliz-natu-despes then do:
							ASSIGN RowObjectDefault.ct-codigo = utiliz-natu-despes.ct-codigo.
						end.
					end.
				end.
			end.
		end.
    end.
	
	run setSubAccount (output RowObjectDefault.sc-codigo).
		
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveCtCodigo DBOProgram 
PROCEDURE leaveCtCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Executar a sugest∆o de valores default a partir da conta.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for RowObjectDefault.

    run setSubAccount (output RowObjectDefault.sc-codigo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveItCodigo DBOProgram 
PROCEDURE leaveItCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Executar a sugest∆o de valores default a partir do item da
               requisiá∆o.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for RowObjectDefault.
    def output param table for ttUnidNegRequisDefault.

    def var c-cod-utiliz as char no-undo.

    run setDeliveryDate         (input  RowObject.nr-requisicao,
                                 input  RowObject.it-codigo,
                                 output RowObjectDefault.dt-entrega).

    run setRequestedQuantity    (output RowObjectDefault.qt-a-atender).

    run setItemComents          (output RowObjectDefault.narrativa).

    run setUtilizationCode      (output c-cod-utiliz).
	
	if RowObjectDefault.char-2 = ? then
		assign RowObjectDefault.char-2 = "".

    if RowObjectDefault.sc-codigo = ? then
		assign RowObjectDefault.sc-codigo = "".
		
    assign overlay(RowObjectDefault.char-2,1,12) = c-cod-utiliz.

    run setAccount              (output RowObjectDefault.ct-codigo).

    run setSubAccount           (output RowObjectDefault.sc-codigo).

    run setUnitOfMeasure        (output RowObjectDefault.un).

    run setUnitPriceItem        (output RowObjectDefault.preco-unit).
    
    run setBusinessUnit         (output table ttUnidNegRequisDefault).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveNumOrdInv DBOProgram 
PROCEDURE leaveNumOrdInv :
/*------------------------------------------------------------------------------
  Purpose:     Executar a sugest∆o de valores default a partir da ordem de
               investimento.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for RowObjectDefault.
    def output param table for ttUnidNegRequisDefault.

    def var c-cod-utiliz as char no-undo.

    run setCompany              (output RowObjectDefault.ep-codigo).

    run setUtilizationCode      (output c-cod-utiliz).
    assign overlay(RowObjectDefault.char-2,1,12) = c-cod-utiliz.

    run setAccount              (output RowObjectDefault.ct-codigo).

    run setSubAccount           (output RowObjectDefault.sc-codigo). 
  
    run setUnitPriceItem        (output RowObjectDefault.preco-unit).

    run setBusinessUnit         (output table ttUnidNegRequisDefault).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveScCodigo DBOProgram 
PROCEDURE leaveScCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Executar a sugest∆o de valores default a partir da sub-conta.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for RowObjectDefault.
            
    run setSubAccount    (output RowObjectDefault.sc-codigo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAccount DBOProgram 
PROCEDURE setAccount :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir a conta.
  Parameters:  pCtCodigo: c¢digo de utilizaá∆o
  Notes:       
------------------------------------------------------------------------------*/

    def output param pCtCodigo          like it-requisicao.ct-codigo no-undo.

    def var c-ct-codigo                 as char no-undo.
    def var c-sc-codigo                 as char no-undo.
    
    if  RowObject.num-ord-inv = 0 then do:

        {cdp/finditemuniestab.i RowObject.it-codigo requisicao.cod-estabel}
        if  avail item-uni-estab
        and item-uni-estab.altera-conta = no then do:

            {cdp/findrequisicao.i RowObject.nr-requisicao}
            if  avail requisicao then do:

                if  substr(usuar-mater.char-1,1,1) = "y" then do: /* Utilizaá‰es Material */
                    
                    {cdp/findnaturezadespesa.i item-uni-estab.nat-despesa}
                    if  avail natureza-despesa then do:
                        {cdp/findutiliznatudespes.i natureza-despesa.nat-despesa substr(RowObjectDefault.char-2,1,12)}
                        if  avail utiliz-natu-despes then
                            assign pCtCodigo = utiliz-natu-despes.ct-codigo.
                    end.
                end.
                else do:
                    {cdp/findnaturezadespesa.i item-uni-estab.nat-despesa}
                    if  avail natureza-despesa then
                        assign pCtCodigo = natureza-despesa.ct-codigo.
                end.
            end.
        end.
    end.
    else do:
        run setAccountOrdemInv (output c-ct-codigo,
                                output c-sc-codigo).

        assign pCtCodigo = c-ct-codigo.

    end.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAccountOrdemInv DBOProgram 
PROCEDURE setAccountOrdemInv :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir conta e sub-conta a partir da ordem de investimento.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param pCtCodigo       like it-requisicao.ct-codigo no-undo.
    def output param pScCodigo       like it-requisicao.sc-codigo no-undo.

    def var c-ct-codigo              as char no-undo.
    def var c-sc-codigo              as char no-undo.
    def var l-achou                  as log  no-undo.

    IF NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    if  avail requisicao then do:

        {cdp/findestabelec.i requisicao.cod-estabel}
        if  avail estabelec then do:

            if connected("mginv") and param-global.modulo-in then do:
                run inp/in2201.p (input  estabelec.ep-codigo,
                                  input  RowObject.num-ord-inv,
                                  input  yes,
                                  output l-achou,
                                  output c-ct-codigo,
                                  output c-sc-codigo).

                if return-value = "NOK" then
                    return "NOK".

                assign pCtCodigo = c-ct-codigo
                       pScCodigo = c-sc-codigo.
            end.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSubAccount DBOProgram 
PROCEDURE setSubAccount :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir a conta cont†bil do item da requisiá∆o.
  Parameters:  pContaContabil: conta cont†bil
  Notes:       A conta cont†bil Ç a juná∆o entre a conta e o centro de custo do
               usu†rio.
------------------------------------------------------------------------------*/
    def output param psc-codigo as character no-undo.
    
    DEFINE VARIABLE h_api_ccusto    AS HANDLE  NO-UNDO.
    DEFINE VARIABLE isUseCostCenter AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-classif       AS LOGICAL NO-UNDO.
    DEFINE VARIABLE c-ct-codigo     AS CHAR    NO-UNDO.
    DEFINE VARIABLE c-sc-codigo     AS CHAR    NO-UNDO.

    ASSIGN psc-codigo = RowObjectDefault.sc-codigo.

    IF  RowObject.num-ord-inv = 0 THEN DO:

        {cdp/finditemuniestab.i RowObject.it-codigo requisicao.cod-estabel}

        IF AVAIL item-uni-estab THEN
            ASSIGN l-classif = item-uni-estab.altera-conta.

        /* Se utilizar classificacao contabil, nao sugere a conta  */
        IF NOT l-classif THEN DO:

            {cdp/cd9970.i requisicao.cod-estabel}
        
            IF NOT VALID-HANDLE(h_api_ccusto) THEN
                RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
        
            RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto(input i-empresa,
                                                              input requisicao.cod-estabel,
                                                              input "",
                                                              input RowObjectDefault.ct-codigo,
                                                              input TODAY,
                                                              output isUseCostCenter,
                                                              output table tt_log_erro).
        
            IF isUseCostCenter THEN DO:
                {cdp/findusuarmater.i requisicao.nome-abrev}
                IF AVAIL usuar-mater AND psc-codigo = "":U THEN DO:
                    ASSIGN psc-codigo = usuar-mater.sc-codigo.
                END.
            END.
            ELSE 
                ASSIGN psc-codigo = "".

        END.
        ELSE
            ASSIGN psc-codigo = "".
    END.
    ELSE DO:
        run setAccountOrdemInv (output c-ct-codigo,
                                output c-sc-codigo).
        assign psc-codigo = c-sc-codigo.    
    END.
    
    IF VALID-HANDLE(h_api_ccusto) THEN DO:
        DELETE PROCEDURE h_api_ccusto.
        ASSIGN h_api_ccusto = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setBusinessUnit DBOProgram 
PROCEDURE setBusinessUnit :
/*------------------------------------------------------------------------------                         
  Purpose:     Sugerir a unidade de neg¢cio para o item da requisiá∆o.
  Parameters:  pCodUnidNegoc: unidade de neg¢cio
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for ttUnidNegRequisDefault.

    def var c-CodUnidNegoc like unid-neg-requis.cod_unid_negoc no-undo.

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    if  avail requisicao then do:

        if  (    l-unidade-negocio
             and requisicao.tp-requis = 1) /* Requisiá∆o de Estoque */
        or  (    l-mat-unid-negoc
             and (   requisicao.tp-requis = 2            /* Solicitaá∆o de Compra */
                  or requisicao.tp-requis = 3)) then do: /* Solicitaá∆o de Cotaá∆o */

            empty temp-table ttUnidNegRequisDefault.

            if  RowObject.num-ord-inv = 0 then do:
            
                IF NOT VALID-HANDLE(h-cdapi024) THEN
                    RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.

                if  valid-handle(h-cdapi024) then do:
                    run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input  requisicao.cod-estabel,
                                                                       input  RowObject.it-codigo,
                                                                       input  "", /* Dep¢sito */
                                                                       output c-CodUnidNegoc).

                    create ttUnidNegRequisDefault.
                    assign ttUnidNegRequisDefault.nr-requisicao  = RowObject.nr-requisicao
                           ttUnidNegRequisDefault.sequencia      = RowObject.sequencia
                           ttUnidNegRequisDefault.it-codigo      = RowObject.it-codigo
                           ttUnidNegRequisDefault.cod_unid_negoc = c-CodUnidNegoc
                           ttUnidNegRequisDefault.perc-unid-neg  = 100.
                end.
                IF h-cdapi024 <> ? AND VALID-HANDLE(h-cdapi024) THEN DO:
                    DELETE PROCEDURE h-cdapi024.
                    ASSIGN h-cdapi024 = ?.
                END.
            end.
            else do:

                IF NOT VALID-HANDLE(h-boiv029) THEN
                    RUN ivbo/boiv029.p PERSISTENT SET h-boiv029.

                if  valid-handle(h-boiv029) then do:
                    run retornaMatrizUnidNegoc in h-boiv029 (input  RowObject.num-ord-inv,
                                                             output table tt-unid-neg-inv,
                                                             output table tt-erro).
                
                    if  not can-find(first tt-erro) then
                        for each tt-unid-neg-inv:
                            create ttUnidNegRequisDefault.
                            assign ttUnidNegRequisDefault.nr-requisicao  = RowObject.nr-requisicao
                                   ttUnidNegRequisDefault.sequencia      = RowObject.sequencia
                                   ttUnidNegRequisDefault.it-codigo      = RowObject.it-codigo
                                   ttUnidNegRequisDefault.cod_unid_negoc = tt-unid-neg-inv.cod-unid-neg
                                   ttUnidNegRequisDefault.perc-unid-neg  = tt-unid-neg-inv.perc-rateio.
                        end.
                end.
                IF h-boiv029 <> ? AND VALID-HANDLE(h-boiv029) THEN DO:
                    DELETE PROCEDURE h-boiv029.
                    ASSIGN h-boiv029 = ?.
                END.
            end.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCompany DBOProgram 
PROCEDURE setCompany :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir a empresa da ordem de investimento quando esta for
               informada.
  Parameters:  pEpCodigo: empresa da ordem de investimento
  Notes:       A empresa ser† gravada no item da requisiá∆o apenas quando o
               M¢dulo de Insvestimentos estiver implantado e a ordem de 
               investimento for informada.
------------------------------------------------------------------------------*/

    def output param pEpCodigo      like it-requisicao.ep-codigo no-undo.

    if  RowObjectDefault.num-ord-inv <> 0 then do:
    
        {cdp/findparamglobal.i}
        if  avail param-global then do:

            if  param-global.modulo-in then do:
            
                {cdp/findrequisicao.i RowObject.nr-requisicao}
                if  avail requisicao then do:
    
                    {cdp/findestabelec.i requisicao.cod-estabel}
                    if  avail estabelec then
                        assign  pEpCodigo = estabelec.ep-codigo.
                end.
            end.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCostCenter DBOProgram 
PROCEDURE setCostCenter :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir o centro de custo do usu†rio requisitante para compor a
               conta cont†bil.
  Parameters:  pScCodigo: centro de custo do usu†rio requisitante
  Notes:       
------------------------------------------------------------------------------*/

    def output param pScCodigo          like it-requisicao.sc-codigo no-undo.

    def var c-ct-codigo                 as char no-undo.
    def var c-sc-codigo                 as char no-undo.

    if  RowObject.num-ord-inv = 0 then do:

        {cdp/finditemuniestab.i RowObject.it-codigo requisicao.cod-estabel}
        if  avail item-uni-estab
        and item-uni-estab.altera-conta = no then do:

            {cdp/findrequisicao.i RowObject.nr-requisicao}
            if  avail requisicao then do:
                {cdp/findusuarmater.i requisicao.nome-abrev}
                if  avail usuar-mater then
                    assign pScCodigo = usuar-mater.sc-codigo.
            end.
        end.
    end.
    else do:
        run setAccountOrdemInv (output c-ct-codigo,
                                output c-sc-codigo).
        assign pScCodigo = c-sc-codigo.    
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaults DBOProgram 
PROCEDURE setDefaults :
/*------------------------------------------------------------------------------
  Purpose:     Executar o leave dos campos para sugest∆o de valores default.
  Parameters:  pType: Tipo de Transaá∆o ("Create", "Update" ou "Delete")
               pFieldName: Atributo da tabela
               RowObject: temp-table com os dados da tela
               RowObjectDefault: temp-table com os dados default
  Notes:       O mÇtodo SetDefaults deve ser executado apenas quando tratar-se
               de uma inclus∆o ou da modificaá∆o de algum campo.
------------------------------------------------------------------------------*/

    def input  param pType        as char no-undo.
    def input  param pFieldName   as char no-undo.
    def input  param table for RowObject.
    def input  param table for ttUnidNegRequis.
    def output param table for RowObjectDefault.
    def output param table for ttUnidNegRequisDefault.

    empty temp-table RowObjectDefault.
    empty temp-table ttUnidNegRequisDefault.

    find first RowObject       no-error.

    {cdp/findrequisicao.i RowObject.nr-requisicao}

    /* Defaults na inicializaá∆o da tela */
    if  pType      = "create"
    and pFieldName = "" then do:

        /* Item da Requisiá∆o */
        create RowObjectDefault.
        /* Grava chave do registro pai para, posteriormente, habilitar/desabilitar os campos (enableFields) */
        assign RowObjectDefault.nr-requisicao = RowObject.nr-requisicao.

        run setSequence   (output RowObjectDefault.sequencia).
        run setCostCenter (output RowObjectDefault.sc-codigo).
        run setState      (output RowObjectDefault.estado).
        run setStatus     (output RowObjectDefault.situacao).
        &if "{&bf_mat_versao_ems}" >= "2.071" &then
            RUN setDeliveryTime (OUTPUT RowObjectDefault.hra-entrega).
        &ENDIF
    end.
    /* Defaults de leave de campos (criaá∆o e modificaá∆o) */
    else do:
    
        if  avail RowObject then do:
            create RowObjectDefault.
            buffer-copy RowObject to RowObjectDefault.
        end.

        for each ttUnidNegRequis:
            create ttUnidNegRequisDefault.
            buffer-copy ttUnidNegRequis to ttUnidNegRequisDefault.
        end.
    end.

    /* Regras de neg¢cio para sugest∆o de valores defaults */
    case pFieldName:
        when "it-codigo"        then run leaveItCodigo      (output table RowObjectDefault,
                                                             output table ttUnidNegRequisDefault).
        when "num-ord-inv"      then run leaveNumOrdInv     (output table RowObjectDefault,
                                                             output table ttUnidNegRequisDefault).
        when "sc-codigo"        then run leaveScCodigo      (output table RowObjectDefault).
        when "ct-codigo"        then run leaveCtCodigo      (output table RowObjectDefault).
		
		WHEN "cod-utiliz"		then do:
			run leaveCodUtilizacao.
		end.
	end case.

    /*PONTO UPC*/
    IF c-nom-prog-dpc-mg97  <> ""
    OR c-nom-prog-upc-mg97  <> ""
    OR c-nom-prog-appc-mg97 <> "" THEN DO:

        EMPTY TEMP-TABLE tt-epc.

        create tt-epc.
        assign tt-epc.cod-event     = "afterSetDefaults":U
               tt-epc.cod-parameter = "handle_RowObject"
               tt-epc.val-parameter = string(TEMP-TABLE RowObject:HANDLE).

        create tt-epc.
        assign tt-epc.cod-event     = "afterSetDefaults":U
               tt-epc.cod-parameter = "handle_RowObjectDefault"
               tt-epc.val-parameter = string(TEMP-TABLE RowObjectDefault:HANDLE).

        /*** Chamada do programa EPC ***/
        {include/i-epc201.i  "afterSetDefaults" }
    END.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDeliveryDate DBOProgram 
PROCEDURE setDeliveryDate :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir a data de entrega.
  Parameters:  pNrRequisicao.: n£mero da requisiá∆o
               pItCodigo.....: c¢digo do item 
               pDtEntrega....: data de entrega do item
  Notes:       
------------------------------------------------------------------------------*/

    def input  param pNrRequisicao  like it-requisicao.nr-requisicao                no-undo.
    def input  param pItCodigo      like it-requisicao.it-codigo                    no-undo.
    def output param pDtEntrega     like it-requisicao.dt-entrega initial today     no-undo.

    {cdp/findrequisicao.i pNrRequisicao}
    if  avail requisicao then do:
    
        if  requisicao.tp-requis <> 2 then /* Solicitaá∆o de Compra */
            assign pDtEntrega = today.
        else do:
    
            {cdp/finditemuniestab.i pItCodigo requisicao.cod-estabel}
            if  avail item-uni-estab then
                assign pDtEntrega = today + item-uni-estab.res-int-comp + item-uni-estab.res-for-comp.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDeliveryTime DBOProgram 
PROCEDURE setDeliveryTime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param pHora like it-requisicao.hra-entrega no-undo.
    
    assign pHora = "23:59". 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setItemComents DBOProgram 
PROCEDURE setItemComents :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir a narrativa do item
  Parameters:  pNarrativa: narrativa padr∆o do item
  Notes:       
------------------------------------------------------------------------------*/

    def output param pNarrativa like it-requisicao.narrativa no-undo.

    {cdp/findnarrativa.i RowObject.it-codigo}
    if  avail narrativa then
        assign pNarrativa = narrativa.descricao.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRequestedQuantity DBOProgram 
PROCEDURE setRequestedQuantity :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir a quantidade para itens controlados por n£mero de sÇrie.
  Parameters:  pQtAAtender: quantidade a atender
  Notes:       Para itens com tipo de controle no estoque igual a n£mero de
               sÇrie retorna a quantidade igual a 1.
------------------------------------------------------------------------------*/

    def output param pQtAAtender like it-requisicao.qt-a-atender no-undo.

    assign pQtAAtender = RowObject.qt-a-atender.

    {cdp/finditem.i RowObject.it-codigo}
    if  avail item then do:
        if  item.tipo-con-est = 2 then /* N£mero de SÇrie */
            assign pQtAAtender = 1.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSequence DBOProgram 
PROCEDURE setSequence :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir a pr¢xima sequància do item
  Parameters:  pSequencia: pr¢xima sequància do item da requisiá∆o
  Notes:       
------------------------------------------------------------------------------*/

    def output param pSequencia       like it-requisicao.sequencia no-undo.

    find last it-requisicao
        where it-requisicao.nr-requisicao = RowObject.nr-requisicao
        no-lock no-error.
    if  avail it-requisicao then
        assign pSequencia = it-requisicao.sequencia + if l-sequencia-unitaria then 1 else 10.
    else
        assign pSequencia = if l-sequencia-unitaria then 1 else 10.
    
    if  pSequencia > 999 then do:
        do i-count = 1 to 999:
            if can-find(first it-requisicao
                        where it-requisicao.nr-requisicao = requisicao.nr-requisicao
                          and it-requisicao.sequencia     = i-count) then 
                assign pSequencia = 1.
            else do:
                assign pSequencia = i-count.
                leave.
            end.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setState DBOProgram 
PROCEDURE setState :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir estado.
  Parameters:  pEstado: retorna o estado do item da requisiá∆o.
  Notes:       
------------------------------------------------------------------------------*/

    def output param pEstado like requisicao.estado no-undo.

    assign pEstado = 2. /* N∆o Aprovado */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setStatus DBOProgram 
PROCEDURE setStatus :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir situaá∆o.
  Parameters:  pSituacao: retorna a situaá∆o do item da requisiá∆o.
  Notes:       
------------------------------------------------------------------------------*/

    def output param pSituacao like requisicao.situacao no-undo.

    assign pSituacao = 1. /* Aberta */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setUnitOfMeasure DBOProgram 
PROCEDURE setUnitOfMeasure :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir unidade de medida para o item da requisiá∆o.
  Parameters:  pUn: unidade de medida
  Notes:       
------------------------------------------------------------------------------*/

    def output param pUn       like it-requisicao.un no-undo.

    assign pUn = RowObject.un.

    {cdp/findparammat.i}
    if  avail param-mat then do:

        if  param-mat.ind-sit-un = 2 then do: /* Default Item */

            {cdp/finditem.i RowObject.it-codigo}
            if  avail item then
                assign pUn = item.un.

        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setUnitPrice DBOProgram 
PROCEDURE setUnitPrice :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir preáo unit†rio para os itens.
  Parameters:  pPrecoUnit: preáo unit†rio
  Notes:       
------------------------------------------------------------------------------*/

    def output param pPrecoUnit       like it-requisicao.preco-unit no-undo.

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    if  avail requisicao then do:

        {cdp/findusuarmater.i requisicao.nome-abrev}
        if  avail usuar-mater then do:
    
            if  usuar-mater.tp-preco = 1 then do: /* Preáo MÇdio */
        
                run getAveragePrice (output pPrecoUnit).
                if  pPrecoUnit = 0 then
                    run getLastReceiptPrice (output pPrecoUnit).
                    if  pPrecoUnit = 0 then
                        run getReplacementPrice (output pPrecoUnit).
                        if  pPrecoUnit = 0 then
                            run getBasePrice (output pPrecoUnit).
                            if  pPrecoUnit = 0 then
                                assign pPrecoUnit = 1. /* Valorizada 1,00 */
            end.
            else if  usuar-mater.tp-preco = 2 then do: /* Preáo Base */
        
                run getBasePrice (output pPrecoUnit).
                if  pPrecoUnit = 0 then
                    run getLastReceiptPrice (output pPrecoUnit).
                    if  pPrecoUnit = 0 then
                        run getReplacementPrice (output pPrecoUnit).
                        if  pPrecoUnit = 0 then
                            assign pPrecoUnit = 1. /* Valorizada 1,00 */
            end.
            else if  usuar-mater.tp-preco = 3 then do: /* Preáo Reposiá∆o */
        
                run getReplacementPrice (output pPrecoUnit).
                if  pPrecoUnit = 0 then
                    run getLastReceiptPrice (output pPrecoUnit).
                    if  pPrecoUnit = 0 then
                        run getBasePrice (output pPrecoUnit).
                        if  pPrecoUnit = 0 then
                            assign pPrecoUnit = 1. /* Valorizada 1,00 */
            end.
            else if usuar-mater.tp-preco = 4 then do: /* Preáo Èltima Entrada */
        
                run getLastReceiptPrice (output pPrecoUnit).
                if  pPrecoUnit = 0 then
                    run getReplacementPrice (output pPrecoUnit).
                    if  pPrecoUnit = 0 then
                        run getBasePrice (output pPrecoUnit).
                        if  pPrecoUnit = 0 then
                            assign pPrecoUnit = 1. /* Valorizada 1,00 */
            end.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setUnitPriceItem DBOProgram 
PROCEDURE setUnitPriceItem :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir preáo unit†rio para os itens.
  Parameters:  pPrecoUnit: preáo unit†rio
  Notes:       
------------------------------------------------------------------------------*/

    def output param pPrecoUnit       like it-requisicao.preco-unit no-undo.

    /* Retorna o mesmo preáo quando nenhuma das condiá‰es abaixo for executada */
    assign pPrecoUnit = RowObject.preco-unit.

    if  RowObject.it-codigo <> "" then do:
    
        {cdp/findrequisicao.i RowObject.nr-requisicao}
        if  avail requisicao then do:
            
            if  requisicao.tp-requis = 2 then do: /* Solicitaá∆o Compra */
    
                {cdp/finditem.i RowObject.it-codigo}
                if  avail item then do:
    
                    if  item.tipo-contr = 4 then do: /* DÇbito Direto */
    
                        {cdp/findusuarmater.i requisicao.nome-abrev}
                        if  avail usuar-mater then do:
    
                            if  usuar-mater.log-suger-preco-item-db-diret then /* Sugere preáo para item DD */
                                run setUnitPrice (output pPrecoUnit).
                        end.
                    end.
                    else do:

                        /* Caso tenha OI informada e a requisiá∆o tenha sido planejada, n∆o dever† valorizar */
                        if  RowObject.num-ord-inv = 0
                        or  RowObject.preco-unit  = 0 then
                            run setUnitPrice (output pPrecoUnit).

                    end.
                end.
            end.
            else
                run setUnitPrice (output pPrecoUnit).
        end.
    end.
    ELSE DO:
        ASSIGN pPrecoUnit = 0.
    END.
    
    return "ok".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setUtilizationCode DBOProgram 
PROCEDURE setUtilizationCode :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir o c¢digo de utilizaá∆o do item da requisiá∆o.
  Parameters:  pCodUtilizacao: c¢digo de utilizaá∆o
  Notes:       
------------------------------------------------------------------------------*/

    def output param pCodUtilizacao       as char no-undo.
    if  RowObject.num-ord-inv = 0 then do:
        {cdp/finditemuniestab.i RowObject.it-codigo requisicao.cod-estabel}
        if  avail item-uni-estab 
        and item-uni-estab.altera-conta = no then do:

            {cdp/findusuarmater.i requisicao.nome-abrev}
            if  avail usuar-mater
            and substr(usuar-mater.char-1,1,1) = "y" /* Utilizaá‰es Material */
            and RowObject.num-ord-inv = 0 then do:
        
                {cdp/findnaturezadespesa.i item-uni-estab.nat-despesa}
                if  avail natureza-despesa then do:
        
                    find first utiliz-natu-despes
                        where utiliz-natu-despes.cod-nat-despesa = natureza-despesa.nat-despesa no-lock no-error.
                    if  avail utiliz-natu-despes then do:
    
                        {cdp/findutilizacaomater.i utiliz-natu-despes.cod-utiliz}
                        if  avail utilizacao-mater then
                            assign pCodUtilizacao = trim(utilizacao-mater.cod-utiliz).
                    end.
                end.
            end.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

