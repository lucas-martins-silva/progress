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
{include/i-prgvrs.i BOIN274SDFX 2.00.00.010 } /*** "010010" 13/12/2024 08:55:19 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin274sdfx MUT}
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
&GLOBAL-DEFINE DBOName BOIN274SD
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ordem-compra
&GLOBAL-DEFINE TableLabel Ordem Compra
&GLOBAL-DEFINE QueryName qr{&TableName}

{inbo/boin274.i RowObject}
{inbo/boin274.i RowObjectDefault}
{inbo/boin657fx.i ttUnidNegOrdem}
{inbo/boin657fx.i ttUnidNegOrdemDefault}

def temp-table tt-unid-neg-inv no-undo
    field cod-unid-neg as char
    field perc-rateio  as dec.

&GLOBAL-DEFINE excludeFrameDefinition yes
{cdp/cd0666.i} /* tt-erro */

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */

{utp/ut-glob.i} /* Vari†veis Globais  */
{cdp/cd9590.i}  /* Unidade de Neg¢cio */                      

/* Vari†veis Gerais */                                        
def var i-empresa               like empresa.ep-codigo no-undo.
def var hboMngr                 as handle  no-undo.
def var h-cdapi024              as handle  no-undo.
def var h-boiv028               as handle  no-undo.
def var h-boiv029               as handle  no-undo.
def var h_api_cta_ctbl          as handle  no-undo.
def var v_des_cta_ctbl          as char    no-undo.
def var v_num_tip_cta_ctbl      as char    no-undo. 
def var v_num_sit_cta_ctbl      as char    no-undo. 
def var v_ind_finalid_cta       as char    no-undo. 

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro   as integer   format ">>>>,>>9" label "N£mero"          column-label "N£mero"
    field ttv_des_msg_ajuda  as character format "x(40)"    label "Mensagem Ajuda"  column-label "Mensagem Ajuda"
    field ttv_des_msg_erro   as character format "x(60)"    label "Mensagem Erro"   column-label "Inconsistància".

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
         HEIGHT             = 25.46
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

    def var c-enable              as char               no-undo. /* Quando houver ordem de investimento informada */

    {cdp/findparamglobal.i}
    if  not avail param-global then
        return "NOK".

    {cdp/findparamcompra.i}
    if  not avail param-compra then
        return "NOK".

    {cdp/finditem.i RowObject.it-codigo}
    if  not avail item then
        return "NOK".

    if  connected("mginv")
    and param-global.modulo-in
    and RowObject.num-ord-inv <> 0 then      
        run inp/in2112b.p (input i-ep-codigo-usuario,
                           input "habilita-conta",
                           output c-enable).

    case pFieldName:
        when "qt-solic" then
            assign pFieldEnable = pType = "create".

        when "numero-ordem" then
            assign pFieldEnable =     pType = "create"
                                  and substr(param-compra.char-2,14,1) = "Y".
       when "item-fornec" then
           assign pFieldEnable  = param-compra.gera-item-for.

        when "it-codigo" then
            assign pFieldEnable =    (    pType = "create"
                                      and not can-find(first item-contrat
                                                       where item-contrat.nr-contrato  = 0
                                                         and item-contrat.num-seq-item = 0))
                                  or (    pType = "create"
                                      and not can-find(first item-contrat
                                                       where item-contrat.nr-contrato  = RowObject.nr-contrato
                                                         and item-contrat.num-seq-item = RowObject.num-seq-item)).

        when "nr-contrato"  or
        when "num-seq-item" then
            assign pFieldEnable =     param-global.modulo-cn
                                  and RowObject.nr-processo = 0.

        when "nr-processo" then
            assign pFieldEnable =     param-compra.usa-proc = yes
                                  and RowObject.nr-contrato = 0.

        when "cod-estab-gestor" then
            assign pFieldEnable = RowObject.nr-contrato = 0.

        when "cod-unid-negoc" then
            assign pFieldEnable = l-mat-unid-negoc and 
                                  (/* Ordens de Compra - Normal */
                                   (RowObject.num-pedido = 0 and
                                    (RowObject.situacao = 1 or       /* Sem Cotaá∆o */
                                     RowObject.situacao = 5) and     /* Em Cotaá∆o */
                                    ((RowObject.ordem-servic = 0 and /* Ordem de Serviáo n∆o informada */ 
                                     (item.tipo-contr = 4 or         /* DÇbito Direto */
                                      item.tipo-contr = 1)) or       /* F°sico */
                                     (item.tipo-contr = 2 and        /* Total */
                                      RowObject.ordem-servic = 0 and /* Ordem de Serviáo n∆o informada */
                                      RowObject.ct-codigo <> "" and
                                      RowObject.sc-codigo <> "" )))   /* Conta Contabil informada */
                                  /* Ordens de Compra - Pedido Emergencial */
                                  or (RowObject.num-pedido  <> 0 and 
                                      RowObject.num-ord-inv  = 0 and 
                                      RowObject.ordem-servic = 0 and 
                                      RowObject.ct-codigo   <> "" and
                                      RowObject.sc-codigo   <> "" )).
        when "ct-codigo" then
            assign pFieldEnable = not (RowObject.ordem-servic <> 0 and (param-global.modulo-cp or param-global.modulo-mi)) or c-enable = "yes".
        
        when "sc-codigo" then
            assign pFieldEnable = not (RowObject.ordem-servic <> 0 and (param-global.modulo-cp or param-global.modulo-mi)) or c-enable = "yes".

        when "cod-estabel" then
            assign pFieldEnable =  if  rowObject.num-pedido <> 0 then no /* logica Ped Emergencial */
                                   else not(    pType = "update"
                                       and RowObject.num-ord-inv <> 0).

        when "num-ord-inv" then
            assign pFieldEnable =     pType = "create"
                                  and connected("mginv")
                                  and param-global.modulo-in
                                  and RowObject.ordem-servic = 0.

        when "un" then
            assign pFieldEnable =    param-mat.ind-sit-un = 1 /* Unidade de Medida: Informa */
                                  or (    param-mat.ind-sit-un = 2 /* Unidade de Medida: Default Item */
                                      and (   RowObject.it-codigo = ?
                                           or RowObject.it-codigo = ""   
                                           or item.tipo-contr     = 4)). /* DÇbito Direto */

        when "ordem-servic" THEN
            assign pFieldEnable = RowObject.num-ord-inv = 0 OR (RowObject.ordem-servic <> 0 AND RowObject.num-ord-inv <> 0).

        when "op-codigo" then
            assign pFieldEnable = RowObject.natureza = 3.

        when "codigo-icm" then
            assign pFieldEnable = param-compra.utiliza-icm.

        when "expectativa" then
            assign pFieldEnable = no. /* o campo Expectativa sempre permanecer† desabilitado */

        when "situacao" then
            assign pFieldEnable = no. /* o campo Situaá∆o sempre permanecer† desabilitado */

        when "origem" then
            assign pFieldEnable = no. /* o campo Origem sempre permanecer† desabilitado */

    end case.

    return "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveCodEstabel DBOProgram 
PROCEDURE leaveCodEstabel :
/*------------------------------------------------------------------------------
  Purpose:     Executar a sugest∆o de valores default a partir do c¢digo do 
               estabelecimento.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for RowObjectDefault.
    def output param table for ttUnidNegOrdemDefault.

    run setWarehouse            (output RowObjectDefault.dep-almoxar).

    run setExpenseType          (output RowObjectDefault.tp-despesa).

    run setBusinessUnit         (output table ttUnidNegOrdemDefault).

    run setManagementSite       (output RowObjectDefault.cod-estab-gestor).
    
    RUN setComprador            (OUTPUT RowObjectDefault.cod-comprado).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveContaContabil DBOProgram 
PROCEDURE leaveContaContabil :
/*------------------------------------------------------------------------------
  Purpose:     Executar a sugest∆o de valores default a partir da conta cont†bil.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for ttUnidNegOrdemDefault.

    run setBusinessUnit         (output table ttUnidNegOrdemDefault).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveDepAlmoxar DBOProgram 
PROCEDURE leaveDepAlmoxar :
/*------------------------------------------------------------------------------
  Purpose:     Executar a sugest∆o de valores default a partir do c¢digo do
               dep¢sito.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for ttUnidNegOrdemDefault.

    run setBusinessUnit         (output table ttUnidNegOrdemDefault).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveItCodigo DBOProgram 
PROCEDURE leaveItCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Executar a sugest∆o de valores default a partir do item da
               ordem de compra.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for RowObjectDefault.
    def output param table for ttUnidNegOrdemDefault.

    run setNature               (output RowObjectDefault.natureza).

    run setOperation            (output RowObjectDefault.op-codigo).

    run setWarehouse            (output RowObjectDefault.dep-almoxar).

    run setExpenseType          (output RowObjectDefault.tp-despesa).

    run setAccountSubAccount    (output RowObjectDefault.ct-codigo,
                                 output RowObjectDefault.sc-codigo).

    run setBusinessUnit         (output table ttUnidNegOrdemDefault).

    run setManagementSite       (output RowObjectDefault.cod-estab-gestor).

    RUN setComment              (OUTPUT RowObjectDefault.narrativa).

    RUN setContract             (OUTPUT RowObjectDefault.nr-contrato,
                                 OUTPUT RowObjectDefault.num-seq-item).
                                 
    RUN setComprador            (OUTPUT RowObjectDefault.cod-comprado).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveNatureza DBOProgram 
PROCEDURE leaveNatureza :
/*------------------------------------------------------------------------------
  Purpose:     Executar a sugest∆o de valores default a partir da natureza da
               ordem de compra.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for RowObjectDefault.

    run setOperation            (output RowObjectDefault.op-codigo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveNrContrato DBOProgram 
PROCEDURE leaveNrContrato :
/*------------------------------------------------------------------------------
  Purpose:     Executar a sugest∆o de valores default a partir do n£mero do
               contrato.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for RowObjectDefault.
    def output param table for ttUnidNegOrdemDefault.

    run setItemSequence         (output RowObjectDefault.num-seq-item).

    run setItem                 (output RowObjectDefault.it-codigo).

    run setWarehouse            (output RowObjectDefault.dep-almoxar).

    run setExpenseType          (output RowObjectDefault.tp-despesa).

    run setAccountSubAccount    (output RowObjectDefault.ct-codigo,
                                 output RowObjectDefault.sc-codigo).

    run setBusinessUnit         (output table ttUnidNegOrdemDefault).

    run setManagementSite       (output RowObjectDefault.cod-estab-gestor).

    run setItemComents          (output RowObjectDefault.narrativa).


END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveNumOrdInv DBOProgram 
PROCEDURE leaveNumOrdInv :
/*------------------------------------------------------------------------------
  Purpose:     Executar a sugest∆o de valores default a partir da ordem de
               investimento.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for RowObjectDefault.
    def output param table for ttUnidNegOrdemDefault.

    run setCompany              (output RowObjectDefault.ep-codigo).

    run setBusinessUnit         (output table ttUnidNegOrdemDefault).

    run setAccountSubAccount    (output RowObjectDefault.ct-codigo,
                                 output RowObjectDefault.sc-codigo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveNumSeqitem DBOProgram 
PROCEDURE leaveNumSeqitem :
/*------------------------------------------------------------------------------
  Purpose:     Executar a sugest∆o de valores default a partir da seqÅància do
               item do contrato.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for RowObjectDefault.

    run setItem                 (output RowObjectDefault.it-codigo).

    run setExpenseType          (output RowObjectDefault.tp-despesa).

    run setItemComents          (output RowObjectDefault.narrativa).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveOrdemServic DBOProgram 
PROCEDURE leaveOrdemServic :
/*------------------------------------------------------------------------------
  Purpose:     Executar a sugest∆o de valores default a partir da ordem de
               serviáo.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for RowObjectDefault.
    def output param table for ttUnidNegOrdemDefault.

    run setInvestmentOrder      (output RowObjectDefault.num-ord-inv).

    run setAccountSubAccount    (output RowObjectDefault.ct-codigo,
                                 output RowObjectDefault.sc-codigo).

    run setBusinessUnit         (output table ttUnidNegOrdemDefault).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAccountSubAccount DBOProgram 
PROCEDURE setAccountSubAccount :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir a conta cont†bil da ordem de compra.
  Parameters:  pContaContabil: retorna conta cont†bil
  Notes:       
------------------------------------------------------------------------------*/
    def output param p-ct-codigo as char no-undo.
    def output param p-sc-codigo as char no-undo.

    {cdp/findparamglobal.i}

    def var c-desc-ordem-inv        as char     no-undo.
    def var l-avail-sub-div-ordem   as log      no-undo.
    def var c-ct-codigo-inv         as char     no-undo.
    def var c-sc-codigo-inv         as char     no-undo.
    
    if  RowObjectDefault.ordem-servic = 0 then do:

        if  RowObjectDefault.num-ord-inv = 0 then do:

            {cdp/finditem.i RowObjectDefault.it-codigo}
            if avail item then
                assign p-ct-codigo = item.ct-codigo
                       p-sc-codigo = item.sc-codigo.
        end.
        else if connected("mginv")
            and param-global.modulo-in then do:

            {cdp/findestabelec.i RowObjectDefault.cod-estabel}
            if avail estabelec then do:
                assign i-empresa = estabelec.ep-codigo when avail estabelec.

                run inp/in2112a.p (input  i-empresa,
                                   input  RowObjectDefault.num-ord-inv,
                                   output c-desc-ordem-inv,
                                   output l-avail-sub-div-ordem,
                                   output c-ct-codigo-inv,
                                   output c-sc-codigo-inv).

                if l-avail-sub-div-ordem then do:
                    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

                    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,                  /* EMPRESA EMS2 */
                                                                   input        "",                         /* PLANO DE CONTAS */
                                                                   input-output c-ct-codigo-inv,            /* CONTA */
                                                                   input        RowObjectDefault.data-atualiz,  /* DATA TRANSACAO */   
                                                                   output       v_des_cta_ctbl,             /* DESCRICAO CONTA */
                                                                   output       v_num_tip_cta_ctbl,         /* TIPO DA CONTA */
                                                                   output       v_num_sit_cta_ctbl,         /* SITUAÄ«O DA CONTA */
                                                                   output       v_ind_finalid_cta,          /* FINALIDADES DA CONTA */
                                                                   output table tt_log_erro).               /* ERROS */
                    if valid-handle(h_api_cta_ctbl) then
                        delete object h_api_cta_ctbl.
                    
                    assign p-ct-codigo = c-ct-codigo-inv
                           p-sc-codigo = c-sc-codigo-inv.
                end.
            end.
        end.
    end.
    else do:
        {cdp/findparamglobal.i}
        if avail param-global then do:
            if param-global.modulo-cp or param-global.modulo-mi then do:
                {cdp/findordprod.i RowObjectDefault.ordem-servic}
                if avail ord-prod then
                    assign p-ct-codigo = ord-prod.ct-codigo
                           p-sc-codigo = ord-prod.sc-codigo.
            end.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setBusinessUnit DBOProgram 
PROCEDURE setBusinessUnit :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir a unidade de neg¢cio para a ordem de compra.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for ttUnidNegOrdemDefault.

    def var c-CodUnidNegoc like unid-neg-ordem.cod_unid_negoc no-undo.

    IF NOT VALID-HANDLE(h-cdapi024) THEN
        RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.
    IF NOT VALID-HANDLE(h-boiv029) THEN
        RUN ivbo/boiv029.p PERSISTENT SET h-boiv029.
        
    if  l-mat-unid-negoc then do:

        empty temp-table ttUnidNegOrdemDefault.

        /* Modificaá∆o */
        if  can-find(first ordem-compra
                     where ordem-compra.numero-ordem = RowObjectDefault.numero-ordem) then do:

            if  not can-find(first unid-neg-ordem
                             where unid-neg-ordem.numero-ordem = RowObjectDefault.numero-ordem) then do:

                if  RowObjectDefault.ordem-servic = 0 then do:
                
                    if  RowObjectDefault.num-ord-inv = 0 then do:
                        if  valid-handle(h-cdapi024) then do: /* Unidade de Neg¢cio do Item */

                            run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input RowObjectDefault.cod-estabel, 
                                                                               input RowObjectDefault.it-codigo,   
                                                                               input RowObjectDefault.dep-almoxar, 
                                                                               output c-CodUnidNegoc).

                            create ttUnidNegOrdemDefault.
                            assign ttUnidNegOrdemDefault.numero-ordem   = RowObjectDefault.numero-ordem
                                   ttUnidNegOrdemDefault.cod_unid_negoc = c-CodUnidNegoc
                                   ttUnidNegOrdemDefault.perc-unid-neg  = 100.
                        end.
                    end.
                    else do: /* Unidade de Neg¢cio da Ordem de Investimento */

                        if  valid-handle(h-boiv029) then do:
                            run retornaMatrizUnidNegoc in h-boiv029 (input  RowObjectDefault.num-ord-inv,
                                                                     output table tt-unid-neg-inv,
                                                                     output table tt-erro).

                            if  not can-find(first tt-erro) then
                                for each tt-unid-neg-inv:
                                    create ttUnidNegOrdemDefault.
                                    assign ttUnidNegOrdemDefault.numero-ordem   = RowObjectDefault.numero-ordem
                                           ttUnidNegOrdemDefault.cod_unid_negoc = tt-unid-neg-inv.cod-unid-neg
                                           ttUnidNegOrdemDefault.perc-unid-neg  = tt-unid-neg-inv.perc-rateio.
                                end.
                        end.
                    end.
                end.
                else do: 
                    /* Unidade de neg¢cio da ordem de investimento */
                    if RowObjectDefault.ordem-servic <> 0 and RowObjectDefault.num-ord-inv <> 0 then do:
                        if  valid-handle(h-boiv029) then do:
                            run retornaMatrizUnidNegoc in h-boiv029 (input  RowObjectDefault.num-ord-inv,
                                                                     output table tt-unid-neg-inv,
                                                                     output table tt-erro).
    
                            if  not can-find(first tt-erro) then
                                for each tt-unid-neg-inv:
                                    create ttUnidNegOrdemDefault.
                                    assign ttUnidNegOrdemDefault.numero-ordem   = RowObjectDefault.numero-ordem
                                           ttUnidNegOrdemDefault.cod_unid_negoc = tt-unid-neg-inv.cod-unid-neg
                                           ttUnidNegOrdemDefault.perc-unid-neg  = tt-unid-neg-inv.perc-rateio.
                                end.
                        end.
                    end.
                    ELSE DO:
                        /* Unidade de Neg¢cio da Ordem de Serviáo */
                        {cdp/findordprod.i RowObjectDefault.ordem-servic}
                        if  avail ord-prod then do:
        
                            create ttUnidNegOrdemDefault.
                            assign ttUnidNegOrdemDefault.numero-ordem   = RowObjectDefault.numero-ordem
                                   ttUnidNegOrdemDefault.cod_unid_negoc = ord-prod.cod-unid-negoc
                                   ttUnidNegOrdemDefault.perc-unid-neg  = 100.
                        end.
                    END.
                end.
            end.
            else do:
                if  valid-handle(h-cdapi024) then do: /* Unidade de Neg¢cio do Item */
                    run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input RowObjectDefault.cod-estabel,
                                                                       input RowObjectDefault.it-codigo,
                                                                       input RowObjectDefault.dep-almoxar,
                                                                       output c-CodUnidNegoc).

                     create ttUnidNegOrdemDefault.
                     assign ttUnidNegOrdemDefault.numero-ordem   = RowObjectDefault.numero-ordem
                            ttUnidNegOrdemDefault.cod_unid_negoc = c-CodUnidNegoc
                            ttUnidNegOrdemDefault.perc-unid-neg  = 100.
                end.
            end.
        end.
        /* Inclus∆o */
        else do:
    
            if  RowObjectDefault.ordem-servic = 0 then do:

                if  RowObjectDefault.num-ord-inv = 0 then do:
                    if  valid-handle(h-cdapi024) then do: /* Unidade de Neg¢cio do Item */

                        run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input RowObjectDefault.cod-estabel,
                                                                           input RowObjectDefault.it-codigo,
                                                                           input RowObjectDefault.dep-almoxar,
                                                                           output c-CodUnidNegoc).

                        create ttUnidNegOrdemDefault.
                        assign ttUnidNegOrdemDefault.numero-ordem   = RowObjectDefault.numero-ordem
                               ttUnidNegOrdemDefault.cod_unid_negoc = c-CodUnidNegoc
                               ttUnidNegOrdemDefault.perc-unid-neg  = 100.
                    end.
                end.
                else do: /* Unidade de Neg¢cio da Ordem de Investimento */

                    if  valid-handle(h-boiv029) then do:
                        run retornaMatrizUnidNegoc in h-boiv029 (input  RowObjectDefault.num-ord-inv,
                                                                 output table tt-unid-neg-inv,
                                                                 output table tt-erro).

                        if  not can-find(first tt-erro) then
                            for each tt-unid-neg-inv:
                                create ttUnidNegOrdemDefault.
                                assign ttUnidNegOrdemDefault.numero-ordem   = RowObjectDefault.numero-ordem
                                       ttUnidNegOrdemDefault.cod_unid_negoc = tt-unid-neg-inv.cod-unid-neg
                                       ttUnidNegOrdemDefault.perc-unid-neg  = tt-unid-neg-inv.perc-rateio.
                            end.
                    end.
                end.
            end.
            else do: 
                /* Unidade de neg¢cio da ordem de investimento */
                if RowObjectDefault.ordem-servic <> 0 and RowObjectDefault.num-ord-inv <> 0 then do:
                    if  valid-handle(h-boiv029) then do:
                        run retornaMatrizUnidNegoc in h-boiv029 (input  RowObjectDefault.num-ord-inv,
                                                                 output table tt-unid-neg-inv,
                                                                 output table tt-erro).

                        if  not can-find(first tt-erro) then
                            for each tt-unid-neg-inv:
                                create ttUnidNegOrdemDefault.
                                assign ttUnidNegOrdemDefault.numero-ordem   = RowObjectDefault.numero-ordem
                                       ttUnidNegOrdemDefault.cod_unid_negoc = tt-unid-neg-inv.cod-unid-neg
                                       ttUnidNegOrdemDefault.perc-unid-neg  = tt-unid-neg-inv.perc-rateio.
                            end.
                    end.
                end.
                ELSE DO:
                    /* Unidade de Neg¢cio da Ordem de Serviáo */
                    {cdp/findordprod.i RowObjectDefault.ordem-servic}
                    if  avail ord-prod then do:
    
                        create ttUnidNegOrdemDefault.
                        assign ttUnidNegOrdemDefault.numero-ordem   = RowObjectDefault.numero-ordem
                               ttUnidNegOrdemDefault.cod_unid_negoc = ord-prod.cod-unid-negoc
                               ttUnidNegOrdemDefault.perc-unid-neg  = 100.
                    end.
                END.
            end.
        end.
    end.
    
    IF VALID-HANDLE(h-cdapi024) THEN DO:
        DELETE PROCEDURE h-cdapi024.
        ASSIGN h-cdapi024 = ?.
    END.
    IF VALID-HANDLE(h-boiv029) THEN DO:
        DELETE PROCEDURE h-boiv029.
        ASSIGN h-boiv029 = ?.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setBuyer DBOProgram 
PROCEDURE setBuyer :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir comprador do item
  Parameters:  pCodComprado: retorna comprador do item
  Notes:       
------------------------------------------------------------------------------*/

    def output param pCodComprado like ordem-compra.cod-comprado no-undo.

    assign pCodComprado = c-seg-usuario.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCompany DBOProgram 
PROCEDURE setCompany :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir a empresa da ordem de investimento quando esta for
               informada.
  Parameters:  pEpCodigo: empresa da ordem de investimento
  Notes:       A empresa ser† gravada na ordem de compra apenas quando o
               M¢dulo de Insvestimentos estiver implantado e a ordem de 
               investimento for informada.
------------------------------------------------------------------------------*/

    def output param pEpCodigo      like ordem-compra.ep-codigo no-undo.

    if  RowObjectDefault.num-ord-inv <> 0 then do:
    
        {cdp/findparamglobal.i}
        if  avail param-global then do:

            if  param-global.modulo-in then do:
            
                {cdp/findestabelec.i RowObjectDefault.cod-estabel}
                if  avail estabelec then
                    assign  pEpCodigo = estabelec.ep-codigo.
            end.
        end.
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
    def input  param table for ttUnidNegOrdem.
    def output param table for RowObjectDefault.
    def output param table for ttUnidNegOrdemDefault.

    empty temp-table RowObjectDefault.
    empty temp-table ttUnidNegOrdemDefault.

    find first RowObject      no-error.

    /* Defaults na inicializaá∆o da tela */
    if  pType      = "create"
    and pFieldName = "" then do:

        create RowObjectDefault.
    
        run setRequisitionNumber (output RowObjectDefault.numero-ordem).
        run setStatus            (output RowObjectDefault.situacao).
        run setSource            (output RowObjectDefault.origem).
        run setRequester         (output RowObjectDefault.requisitante).
        run setPrintQuotation    (output RowObjectDefault.impr-ficha).
        run setSite              (output RowObjectDefault.cod-estabel).
        run setNature            (output RowObjectDefault.natureza).
        run leaveItCodigo        (output table RowObjectDefault,
                                  output table ttUnidNegOrdemDefault).
    end.
    /* Defaults de leave de campos (criaá∆o e modificaá∆o) */
    else do:
    
        if  avail RowObject then do:
            create RowObjectDefault.
            buffer-copy RowObject to RowObjectDefault.

            if  pType = "create" then
                run setPrintQuotation (output RowObjectDefault.impr-ficha).
        end.

        for each ttUnidNegOrdem:
            create ttUnidNegOrdemDefault.
            buffer-copy ttUnidNegOrdem to ttUnidNegOrdemDefault.
        end.
    end.

    /* Regras de neg¢cio para sugest∆o de valores defaults */
    case pFieldName:
        when "cod-estabel"      then run leaveCodEstabel    (output table RowObjectDefault,
                                                             output table ttUnidNegOrdemDefault).
        when "ct-codigo"        then run leaveContaContabil (output table ttUnidNegOrdemDefault).
        when "dep-almoxar"      then run leaveDepAlmoxar    (output table ttUnidNegOrdemDefault).
        when "it-codigo"        then run leaveItCodigo      (output table RowObjectDefault,
                                                             output table ttUnidNegOrdemDefault).
        when "natureza"         then run leaveNatureza      (output table RowObjectDefault).
        when "nr-contrato"      then run leaveNrContrato    (output table RowObjectDefault,
                                                             output table ttUnidNegOrdemDefault).
        when "num-ord-inv"      then run leaveNumOrdInv     (output table RowObjectDefault,
                                                             output table ttUnidNegOrdemDefault).
        when "num-seq-item"     then run leaveNumSeqItem    (output table RowObjectDefault).
        when "ordem-servic"     then run leaveOrdemServic   (output table RowObjectDefault,
                                                             output table ttUnidNegOrdemDefault).
    end case.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setExpenseType DBOProgram 
PROCEDURE setExpenseType :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir tipo de despesa do item
  Parameters:  pTpDespesa: retorna tipo de despesa do item
  Notes:       
------------------------------------------------------------------------------*/

    def output param pTpDespesa like ordem-compra.tp-despesa no-undo.

    if  RowObjectDefault.nr-contrato = 0 then do:

        {cdp/finditemuniestab.i RowObjectDefault.it-codigo RowObjectDefault.cod-estabel}
        if  avail item-uni-estab then
            assign pTpDespesa = item-uni-estab.tp-desp-padrao.
    end.
    else do:

        {cdp/finditemcontrat.i RowObjectDefault.nr-contrato RowObjectDefault.num-seq-item}
        if  avail item-contrat then
            assign pTpDespesa = item-contrat.tp-despesa.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setInvestmentOrder DBOProgram 
PROCEDURE setInvestmentOrder :
/*------------------------------------------------------------------------------
  Purpose:     Retornar a ordem de investimento informada na ordem de serviáo
  Parameters:  pNumOrdInv: retornar a ordem de investimento informada na OS
  Notes:       
------------------------------------------------------------------------------*/

    def output param pNumOrdInv like ordem-compra.num-ord-inv no-undo.

    IF NOT VALID-HANDLE(h-boiv028) THEN
        RUN ivbo/boiv028.p PERSISTENT SET h-boiv028.

    {cdp/findparamglobal.i}
    if  avail param-global
    and param-global.modulo-in
    and RowObjectDefault.ordem-servic <> 0 then
        run BuscaOrdemInvOrdProd in h-boiv028 (input        RowObjectDefault.ordem-servic,
                                               input-output pNumOrdInv).

    IF VALID-HANDLE(h-boiv028) THEN DO:
        DELETE PROCEDURE h-boiv028.
        ASSIGN h-boiv028 = ?.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setItem DBOProgram 
PROCEDURE setItem :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir a c¢digo do item com base no contrato informado
  Parameters:  pItCodigo: retorna c¢digo do item para o contrato informado
  Notes:       
------------------------------------------------------------------------------*/

    def output param pItCodigo like ordem-compra.it-codigo no-undo.

    assign pItCodigo = RowObjectDefault.it-codigo.

    {cdp/finditemcontrat.i RowObjectDefault.nr-contrato RowObjectDefault.num-seq-item}
    if  avail item-contrat then do:
    
        assign pItCodigo = item-contrat.it-codigo.

        /* Sobrescreve o c¢digo do item para setar os demais
           defaults que s∆o baseados no c¢digo do item */
        assign RowObjectDefault.it-codigo = pItCodigo.
    END.
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setItemComents DBOProgram 
PROCEDURE setItemComents :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir a narrativa do item do contrato
  Parameters:  pNarrativa: narrativa informado no item do contrato
  Notes:       
------------------------------------------------------------------------------*/

    def output param pNarrativa like ordem-compra.narrativa no-undo.

    {cdp/finditemcontrat.i RowObjectDefault.nr-contrato RowObjectDefault.num-seq-item}
    if  avail item-contrat then
        assign pNarrativa = item-contrat.narrat-item.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setItemSequence DBOProgram 
PROCEDURE setItemSequence :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir a seqÅància do item do contrato
  Parameters:  pNumSeqItem: retorna a sequància do item do contrato
  Notes:       
------------------------------------------------------------------------------*/

    def output param pNumSeqItem like ordem-compra.num-seq-item no-undo.

    ASSIGN pNumSeqItem = RowObjectDefault.num-seq-item.
    /*Se n∆o tiver sido informada sequància ou a sequància selecionada esteja cancelada*/
    IF RowObjectDefault.num-seq-item = 0 OR 
       can-find(FIRST item-contrat
                where item-contrat.nr-contrato  = RowObjectDefault.nr-contrato
                  and item-contrat.num-seq-item    = RowObjectDefault.num-seq-item
                  and item-contrat.ind-sit-item = 3 /* Cancelado */) THEN DO:
    
        find first item-contrat
            where item-contrat.nr-contrato  = RowObjectDefault.nr-contrato
              and item-contrat.it-codigo    = RowObjectDefault.it-codigo
              and item-contrat.ind-sit-item <> 3 /* Cancelado */ no-lock no-error.
        if  avail item-contrat then
            assign pNumSeqItem = item-contrat.num-seq-item.
        ELSE
            ASSIGN pNumSeqItem = 0.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setManagementSite DBOProgram 
PROCEDURE setManagementSite :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir estabelecimento gestor
  Parameters:  pCodEstabelGestor: retorna o estabelecimento gestor
  Notes:       
------------------------------------------------------------------------------*/

    def output param pCodEstabelGestor like ordem-compra.cod-estab-gestor no-undo.

    /*-- Se a ordem for de um pedido emergencial, sera o estab gestor do pedido --*/
    if  RowObjectDefault.num-pedido = 0 then do:

        if  RowObjectDefault.nr-contrato = 0 then do:
            {cdp/findparamcompra.i}
            if  avail param-compra then do:
                  if  substr(param-compra.char-2,97,3) = "YES" then do: /* Sugere Estabelecimento Gestor */
        
                      {cdp/finditemuniestab.i RowObjectDefault.it-codigo RowObjectDefault.cod-estabel}
                      if  avail item-uni-estab then
                          assign pCodEstabelGestor = item-uni-estab.cod-estab-gestor.
                  end.
            end.
        end.
        else do:
            
            {cdp/findcontratofor.i RowObjectDefault.nr-contrato}
            if  avail contrato-for then
                assign pCodEstabelGestor = contrato-for.cod-estab-gestor.
        end.
    end.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setComprador DBOProgram 
PROCEDURE setComprador :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir comprador.
  Parameters:  pSituacao: retorna a natureza cadastrada para o item informado
                          na ordem de compra.
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM pComprador LIKE ordem-compra.cod-comprado no-undo.

    FIND FIRST item-uni-estab NO-LOCK WHERE  
               item-uni-estab.cod-estabel = RowObjectDefault.cod-estabel AND
               item-uni-estab.it-codigo   = RowObjectDefault.it-codigo NO-ERROR.
    IF AVAIL item-uni-estab AND item-uni-estab.cod-comprado <> "" THEN DO: 
        ASSIGN pComprador = item-uni-estab.cod-comprado.
    END.      
    ELSE DO:
        {cdp/finditem.i RowObjectDefault.it-codigo}
         IF AVAIL ITEM THEN DO:
            ASSIGN pComprador = ITEM.cod-comprado.
         END.
         ELSE DO:   
            ASSIGN pComprador = c-seg-usuario.
         END.
    END.
    
     
   
END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setNature DBOProgram 

PROCEDURE setNature :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir natureza.
  Parameters:  pSituacao: retorna a natureza cadastrada para o item informado
                          na ordem de compra.
  Notes:       
------------------------------------------------------------------------------*/

    def output param pNatureza like ordem-compra.natureza no-undo.
    {cdp/findparamcompra.i}
    {cdp/finditem.i RowObjectDefault.it-codigo}
    if  avail item then do:
        if  item.ind-serv-mat = 2 then /* Material */
            assign pNatureza = 1. /* Compra */
        else
            assign pNatureza = 2. /* Serviáo */
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setOperation DBOProgram 
PROCEDURE setOperation :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir o c¢digo da operaá∆o
  Parameters:  pDepAlmoxar: retorna a c¢digo da operaá∆o
  Notes:       Retorna zero quando a natureza da ordem de compra for diferente
               de beneficiamento.
------------------------------------------------------------------------------*/

    def output param pOpCodigo like ordem-compra.op-codigo no-undo.

    if  RowObjectDefault.natureza <> 3 then /* Beneficiamento */
        assign RowObjectDefault.op-codigo = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPrintQuotation DBOProgram 
PROCEDURE setPrintQuotation :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir parÉmetro Imprime Ficha de Cotaá∆o.
  Parameters:  pImprFicha: retorna o parÉmetro para impress∆o da ficha.
  Notes:       
------------------------------------------------------------------------------*/

    def output param pImprFicha like ordem-compra.impr-ficha no-undo.

    if AVAIL RowObject AND RowObject.num-pedido <> 0 then 
        assign pImprFicha = no.
    else
        assign pImprFicha = yes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRequester DBOProgram 
PROCEDURE setRequester :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir o usu†rio requisitante
  Parameters:  pRequisitante: retorna usu†rio respons†vel pela ordem de compra.
  Notes:       Sugere o usu†rio logado no sistema como requisitante.
------------------------------------------------------------------------------*/

    def output param pRequisitante like ordem-compra.requisitante no-undo.

    assign pRequisitante = c-seg-usuario.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRequisitionDate DBOProgram 
PROCEDURE setRequisitionDate :
/*------------------------------------------------------------------------------
  Purpose:     Retornar a data de emiss∆o da ordem de compra
  Parameters:  pDataEmissao: retornar como data inicial TODAY
  Notes:       
------------------------------------------------------------------------------*/

    def output param pDataEmissao like ordem-compra.data-emissao no-undo.
               
    assign pDataEmissao = today.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRequisitionNumber DBOProgram 
PROCEDURE setRequisitionNumber :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir o pr¢ximo n£mero da ordem de compra
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param pNumeroOrdem like ordem-compra.numero-ordem no-undo.

    def var i-numero-ordem-ini  like ordem-compra.numero-ordem  no-undo. /* primeiro n£mero da ordem de compra (Param-compra) */
    def var i-numero-ordem-fim  like ordem-compra.numero-ordem  no-undo. /* £ltimo n£mero da ordem de compra (Param-compra) */

    def var i-length            as int                          no-undo.
    def var i-sequencia         as int                          no-undo.
    def var i-nova-sequencia    as int                          no-undo.
    def var i-numero-ordem      as int                          no-undo.
    def var i-novo-numero-ordem as int                          no-undo.
    def var l-ordem-multipla    as log                          no-undo.

    {cdp/findparamglobal.i}
    {cdp/findparamcompra.i}


    /*===============================================================================================
      SUGEST«O DA PR‡XIMA ORDEM MÈLTIPLA
      
      O trecho de c¢digo abaixo, que encontra-se comentado, Ç respons†vel pelo tratamento de sugest∆o
      da pr¢xima seqÅància de uma ordem m£ltipla. Esta funá∆o est† comentada, pois a µrea de Produto
      definiu que essa funá∆o n∆o estaria mais dispon°vel no Datasul By You. Entretanto, quando a
      decis∆o foi tomada a rotina de sugest∆o j† havia sido desenvolvida e por essa raz∆o permanece
      comentada. Futuramente, CASO ALGUM CLIENTE NECESSITE DESSA FUNÄ«O, BASTA DESCOMENTAR O C‡DIGO.
                  
      ===============================================================================================*/


    /* Identifica se a ordem anterior era uma ordem m£ltipla para sugerir a pr¢xima seqÅància da mesma ordem.
       Para isso o n£mero da ordem que foi inserida anteriormente deve ser gravada no campo RowObject.numero-ordem,
       caso contr†rio n∆o ser† poss°vel identificar se tratava de uma ordem m£ltipla e por conseguinte, o ser†
       sugerido o n£mero de uma ordem normal. */
/*     {cdp/findordemcompra.i RowObject.numero-ordem}                                                                     */
/*     if  avail ordem-compra then                                                                                        */
/*         assign i-length         = length(string(ordem-compra.numero-ordem))                                            */
/*                i-sequencia      = int(substr(string(ordem-compra.numero-ordem),i-length - 1,2))                        */
/*                i-numero-ordem   = int(substr(string(ordem-compra.numero-ordem),1,i-length - 2))                        */
/*                l-ordem-multipla = i-sequencia > 0. /* se possuir seqÅància informada trata-se de uma ordem m£ltipla */ */
/*     else                                                                                                               */
/*         assign l-ordem-multipla = no.                                                                                  */
/*                                                                                                                        */
/*     /* Incremento de seqÅància para a ordem m£ltipla */                                                                */
/*     if  l-ordem-multipla = yes then do:                                                                                */
/*                                                                                                                        */
/*         assign i-nova-sequencia = i-sequencia.                                                                         */
/*         repeat:                                                                                                        */
/*             if  i-nova-sequencia = 99 then do:                                                                         */
/*                 assign i-nova-sequencia = 0. /* N∆o existem seqÅàncias livres para a ordem m£ltipla */                 */
/*                 leave.                                                                                                 */
/*             end.                                                                                                       */
/*                                                                                                                        */
/*             assign i-nova-sequencia = i-nova-sequencia + 1.                                                            */
/*             if  not can-find(first ordem-compra                                                                        */
/*                              where ordem-compra.numero-ordem = (i-numero-ordem * 100) + i-nova-sequencia) then         */
/*                 leave.                                                                                                 */
/*         end.                                                                                                           */
/*                                                                                                                        */
/*         /* retorna novo n£mero da ordem de compra */                                                                   */
/*         assign pNumeroOrdem = (i-numero-ordem * 100) + i-nova-sequencia.                                               */
/*                                                                                                                        */
/*     end.                                                                                                               */
/*     /* Incremento para a ordem normal */                                                                               */
/*     else do:                                                                                                           */
/*                                                                                                                        */
/*         assign i-numero-ordem-ini = param-compra.prim-ord-man * 100                                                    */
/*                i-numero-ordem-fim = param-compra.ult-ord-man  * 100.                                                   */
/*                                                                                                                        */
/*         find last ordem-compra                                                                                         */
/*             where ordem-compra.numero-ordem <= i-numero-ordem-fim no-lock no-error.                                    */
/*         if  avail ordem-compra then do:                                                                                */
/*                                                                                                                        */
/*             /* verifica se o novo n£mero da ordem de compra encontra-se fora da faixa dos ParÉmetros de Compras  */    */
/*             if  (ordem-compra.numero-ordem + 100) < i-numero-ordem-ini                                                 */
/*             or  (ordem-compra.numero-ordem + 100) > i-numero-ordem-fim then                                            */
/*                 assign i-novo-numero-ordem = param-compra.prim-ord-man.                                                */
/*             else                                                                                                       */
/*                 assign i-novo-numero-ordem = trunc(ordem-compra.numero-ordem / 100,0) + 1.                             */
/*         end.                                                                                                           */
/*         else                                                                                                           */
/*             assign i-novo-numero-ordem = param-compra.prim-ord-man.                                                    */
/*                                                                                                                        */
/*         /* procura ordens livres na faixa dos ParÉmetros de Compras */                                                 */
/*         if i-novo-numero-ordem = param-compra.prim-ord-man then do:                                                    */
/*                                                                                                                        */
/*             repeat:                                                                                                    */
/*                 find first ordem-compra                                                                                */
/*                     where ordem-compra.numero-ordem = i-novo-numero-ordem * 100 no-lock no-error.                      */
/*                 if avail ordem-compra then do:                                                                         */
/*                                                                                                                        */
/*                     assign i-novo-numero-ordem = i-novo-numero-ordem + 1.                                              */
/*                                                                                                                        */
/*                     if  i-novo-numero-ordem > param-compra.ult-ord-man then                                            */
/*                         leave. /* n∆o h† ordens livres na faixa dos ParÉmetros de Compras */                           */
/*                 end.                                                                                                   */
/*                 /* verifica se o novo n£mero existe no BH  */                                                          */
/*                 else if avail param-global                                                                             */
/*                     and param-global.modulo-bh then do:                                                                */
/*                                                                                                                        */
/*                     find first ordem-compra                                                                            */
/*                         where ordem-compra.numero-ordem = i-novo-numero-ordem * 100 no-lock no-error.                  */
/*                     if  avail ordem-compra then do:                                                                    */
/*                                                                                                                        */
/*                         assign i-novo-numero-ordem = i-novo-numero-ordem + 1.                                          */
/*                         if  i-novo-numero-ordem > param-compra.ult-ord-man then                                        */
/*                             leave. /* n∆o h† ordens livres na faixa dos ParÉmetros de Compras */                       */
/*                     end.                                                                                               */
/*                 end.                                                                                                   */
/*                 else leave.                                                                                            */
/*             end.                                                                                                       */
/*         end.                                                                                                           */
/*                                                                                                                        */
/*         /* retorna novo n£mero da ordem de compra */                                                                   */
/*         assign pNumeroOrdem = i-novo-numero-ordem * 100.                                                               */
/*                                                                                                                        */
/*      end.                                                                                                              */
    
     /* SUGEST«O DO NÈMERO DA ORDEM DE COMPRA SEM CONSIDERAR ORDENS MÈLTIPLAS */
	RUN ccp/ccapi333.p (INPUT YES,/*parametro indica ordem manual*/
                        OUTPUT i-novo-numero-ordem).
	/*Trecho comentado pois a geracao do numero da ordem de compra
	  sera gerado pela ccapi333.p*/

    /*assign i-numero-ordem-ini = param-compra.prim-ord-man
           i-numero-ordem-fim = param-compra.ult-ord-man.

    find last ordem-compra
        where ordem-compra.numero-ordem <= i-numero-ordem-fim no-lock no-error.
    if  avail ordem-compra then do:
          
        /* verifica se o novo n£mero da ordem de compra encontra-se fora da faixa dos ParÉmetros de Compras  */
        if  (ordem-compra.numero-ordem) < i-numero-ordem-ini
        or  (ordem-compra.numero-ordem) > i-numero-ordem-fim then
            assign i-novo-numero-ordem = param-compra.prim-ord-man * 100.          
        else
            assign i-novo-numero-ordem = ordem-compra.numero-ordem + 1.
    end.
    else
        assign i-novo-numero-ordem = param-compra.prim-ord-man * 100.

    /* procura ordens livres na faixa dos ParÉmetros de Compras */
    if i-novo-numero-ordem = (param-compra.prim-ord-man * 100) then do:

        repeat:
            find first ordem-compra
                where ordem-compra.numero-ordem = i-novo-numero-ordem no-lock no-error.
            if avail ordem-compra then do:

                assign i-novo-numero-ordem = i-novo-numero-ordem + 1.

                if  i-novo-numero-ordem > (param-compra.ult-ord-man * 100) then
                    leave. /* n∆o h† ordens livres na faixa dos ParÉmetros de Compras */
            end.
            /* verifica se o novo n£mero existe no BH  */
            else if avail param-global
                and param-global.modulo-bh then do:

                find first ordem-compra
                    where ordem-compra.numero-ordem = i-novo-numero-ordem no-lock no-error.
                if  avail ordem-compra then do:

                    assign i-novo-numero-ordem = i-novo-numero-ordem + 1.
                    if  i-novo-numero-ordem > (param-compra.ult-ord-man * 100) then
                        leave. /* n∆o h† ordens livres na faixa dos ParÉmetros de Compras */
                end.
            end.
            else leave.
        end.
    end.

    /* retorna novo n£mero da ordem de compra */
	*/
    assign pNumeroOrdem = i-novo-numero-ordem.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSite DBOProgram 
PROCEDURE setSite :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir estabelecimento
  Parameters:  pCodEstabel: retorna o estabelecimento da ordem de compra
  Notes:       
------------------------------------------------------------------------------*/

    def output param pCodEstabel like ordem-compra.cod-estabel no-undo.

    {cdp/findparamcompra.i}
    if  avail param-compra then
        assign pCodEstabel = param-compra.end-entr-pad.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSource DBOProgram 
PROCEDURE setSource :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir origem.
  Parameters:  pSituacao: retorna a origem padr∆o da ordem de compra.
  Notes:       
------------------------------------------------------------------------------*/

    def output param pOrigem like ordem-compra.origem no-undo.

    assign pOrigem = 1. /* Manual */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setStatus DBOProgram 
PROCEDURE setStatus :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir situaá∆o.
  Parameters:  pSituacao: retorna a situaá∆o da ordem de compra.
  Notes:       
------------------------------------------------------------------------------*/

    def output param pSituacao like ordem-compra.situacao no-undo.

    assign pSituacao = 1. /* Sem Cotaá∆o */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setWarehouse DBOProgram 
PROCEDURE setWarehouse :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir dep¢sito do item
  Parameters:  pDepAlmoxar: retorna dep¢sito padr∆o do item
  Notes:       
------------------------------------------------------------------------------*/

    def output param pDepAlmoxar like ordem-compra.cod-comprado no-undo.

    {cdp/finditemuniestab.i RowObjectDefault.it-codigo RowObjectDefault.cod-estabel}
    if  avail item-uni-estab then
        assign pDepAlmoxar = item-uni-estab.deposito-pad.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setComment DBOProgram 
PROCEDURE setComment :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir narrativa do item na ordem
  Parameters:  pcNarrativa: retorna narrativa do item 
  Notes:       
------------------------------------------------------------------------------*/
    
    def output param pcNarrativa like ordem-compra.narrativa no-undo.
    {cdp/findparamcompra.i}
    {cdp/finditem.i RowObjectDefault.it-codigo}
      
    IF AVAIL param-compra AND 
       AVAIL ITEM AND 
       substring(param-compra.char-2,138,1) = "Y":U THEN 
        ASSIGN pcNarrativa = ITEM.narrativa.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setContract DBOProgram 
PROCEDURE setContract :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir contrato e sequància do item do contrato.
  Parameters:  pNrContrato: N£mero do contrato
  Notes:       pNumSeqItem: N£mero de sequància do item do contrato
------------------------------------------------------------------------------*/

    def output param pNrContrato like ordem-compra.nr-contrato no-undo.
    def output param pNumSeqItem like ordem-compra.num-seq-item no-undo.

    ASSIGN pNrContrato = 0
           pNumSeqItem = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
