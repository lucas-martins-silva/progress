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

{include/i-prgvrs.i BOIN168FX 2.00.00.084 } /*** "010084" 17/09/2026 15:26:06 ***/


/* procedure para gerar a versÆo para o log do appserver ou client log, o metodo apenas precisa receber parametros nao precisa fazer nada */
PROCEDURE geraLogApp:
    DEFINE INPUT  PARAMETER cPrgObj AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER cPrgVrs AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER fineNameProcessor AS CHARACTER   NO-UNDO.    
END PROCEDURE.
RUN geraLogApp (c-prg-obj, c-prg-vrs, "{&FILE-NAME}").
/* fim - procedure para gerar a versÆo para o log do appserver ou client log, o metodo apenas precisa receber parametros nao precisa fazer nada */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin168fx MUT}
&ENDIF
/*:T-------------------------------------------------------------------------------
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
&GLOBAL-DEFINE DBOName BOIN168
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName it-requisicao
&GLOBAL-DEFINE TableLabel Item Requisi‡Æo
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin168.i RowObject}
{inbo/boin385.i ttRequisicao}
{inbo/boin168fx.i}  /* ttSummaryInventoryBalance, ttItRequisicaoHTML , ttItRequisicaoCount, dsAtendimento */
{cep/ceapi001k.i}   /* tt-movto */
{cep/ceapi001j.i1}  /* tt-movto-un */

&IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
    /* Integracao EMS EAI2.0 Mensagem unica */
    DEFINE NEW GLOBAL SHARED VARIABLE v_log_eai2_ativado AS LOGICAL NO-UNDO INITIAL NO.
    DEFINE VARIABLE h-ceapi310     AS HANDLE NO-UNDO.       
&ENDIF

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{cdp/cd0669.i}  /* defini‡Æo tt-erro */
{cdp/cd1001.i}  /* defini‡Æo tt_xml_input_1 */
{cdp/cd9590.i}  /* Unidade de Neg¢cio */
{utp/ut-glob.i} /* Vari veis Globais */
{cdp/cdcfgmat.i}
{include/i-epc200.i boin168fx}

def new shared var i-emp-inv like empresa.ep-codigo.
def new shared var i-ord-inv as int format ">>>,>>9".
def new shared var r-mov-inv as rowid.
def new global shared var l-agrupa-lote-wms as logical no-undo.

&if '{&bf_lote_avancado_liberado}' >= 'yes' &then
  {cep/ceapi030.i}
&endif

DEFINE TEMP-TABLE ttSummaryInventoryBalanceAux NO-UNDO
    LIKE ttSummaryInventoryBalance.

DEFINE TEMP-TABLE ttInventoryBalanceOrdered NO-UNDO
    LIKE ttSummaryInventoryBalance
    FIELD seq AS INT.

DEFINE TEMP-TABLE ttItRequisicao-aux NO-UNDO
    LIKE ttItRequisicaoHTML.

DEFINE TEMP-TABLE ttItRequisicaoSelec NO-UNDO
    LIKE ttItRequisicaoHTML.
    
DEFINE BUFFER bf-ttItRequisicaoSelec FOR ttItRequisicaoSelec.

def temp-table tt-erro-documentos no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

/* Valida‡äes Unidade de Neg¢cio */
def temp-table tt-erro-aux no-undo
    field i-sequen as int              
    field cd-erro  as int
    field mensagem as char format "x(255)".

/* Valida‡äes Aprova‡Æo Eletr“nica */
def temp-table tt-erro-aed no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)"
    field c-param  as char.

DEF TEMP-TABLE tt-matriz NO-UNDO
    FIELD cod-unid-neg AS CHAR
    FIELD perc-rateio  AS DEC.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro   as integer   format ">>>>,>>9" label "N£mero"          column-label "N£mero"
    field ttv_des_msg_ajuda  as character format "x(40)"    label "Mensagem Ajuda"  column-label "Mensagem Ajuda"
    field ttv_des_msg_erro   as character format "x(60)"    label "Mensagem Erro"   column-label "Inconsistˆncia".

def var h_api_cta_ctbl                  as handle    no-undo.
def var v_des_cta_ctbl                  as character no-undo.
def var v_cod_cta_ctbl                  as char      no-undo.
def var v_num_tip_cta_ctbl              as char      no-undo. 
def var v_num_sit_cta_ctbl              as char      no-undo. 
def var v_ind_finalid_cta               as char      no-undo.
def var i-estoque                       as integer   no-undo.
def var ind                             as integer   no-undo.
def var v_cod_finalid                   as character no-undo.
/* Vari veis Gerais */
def var c-empresa                       LIKE empresa.ep-codigo          no-undo.
/* Vari veis para tradu‡Æo */                                           
def var c-lst-situacao                  as char                         no-undo.                                                                        
/* Aprova‡Æo Eletr“nica */                                              
def var i-tipo-doc                      as int                          no-undo.
def var i-tipo-trans                    as int                          no-undo.                                                                       
def var h-boin385fx                     as handle                       no-undo.
def var h-boin658fx                     as handle                       no-undo. /* Unidade de Neg¢cio */
def var h-cdapi024                      as handle                       no-undo. /* Unidade de Neg¢cio */
def var h-boiv029                       as handle                       no-undo.
def var h-mceUtils                      as handle                       no-undo.
DEF VAR h-ceapi001k                     AS HANDLE                       NO-UNDO.
DEF VAR h-in2108                        AS HANDLE                       NO-UNDO.
def var l-integra-aed-ems               as log                          no-undo.
def var i-NrRequisicao                  like requisicao.nr-requisicao   no-undo.
def var l-flex-lastItem                 as logical initial no  no-undo.
def var l-lastItem                      as logical initial yes no-undo.
def var i-count                         as integer no-undo.
def var i-sequencia                     as integer no-undo.
def var qt-requis-inv                   as dec     no-undo.
def var l-modulo-in                     as logical no-undo.
def var l-ordem-inv                     as logical no-undo.
def var i-seq                           as integer no-undo.
def var iSeqRowErrors                   as integer no-undo.
def shared var v_cod_usuar_corren       as char format "x(12)" no-undo.
DEFINE VARIABLE cNomeAbrev              AS CHARACTER NO-UNDO.

DEFINE VARIABLE h-cdapi171              AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-tp-ressup             AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-tipo-acao             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-altera-sequencia      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-orig-html             AS LOGICAL INIT FALSE NO-UNDO.
DEFINE VARIABLE lElimOrdemIntegrMe      AS LOGICAL INIT NO    NO-UNDO.
DEFINE VARIABLE cNarrativaItem          AS CHARACTER   NO-UNDO.

DEFINE VARIABLE d-saldo-deposito AS DEC    NO-UNDO.
DEFINE VARIABLE l-perm-sald-neg  AS LOG    NO-UNDO.

DEFINE VARIABLE l-orig-api-WMS-SAAS AS LOGICAL NO-UNDO INITIAL NO.
DEFINE VARIABLE l-fim-req-WMS-SAAS  AS LOGICAL NO-UNDO INITIAL NO.
DEFINE VARIABLE i-atend-em-processo AS INTEGER NO-UNDO.

DEFINE BUFFER bf-movto-estoq FOR movto-estoq.

assign l-integra-aed-ems = can-find(first funcao
                                    where funcao.cd-funcao = "Integra_mla_EMS"
                                      and funcao.ativo     = yes).

/* Funcao criada para sugerir a sequencia dos itens de 1 em 1 */
DEF VAR l-sequencia-unitaria AS LOGICAL NO-UNDO.
ASSIGN l-sequencia-unitaria = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-seq-req-solic":U
                                                      AND funcao.ativo     = YES).
                                                      
                                                      
                                                     

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
         HEIGHT             = 22.33
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
{inbo/boin168fx.i1} /* createRequisitionCE0205 */ 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* Tradu‡äes */

/* Situa‡Æo da requisi‡Æo */
assign c-lst-situacao = {ininc/i01in385.i 03}.
run utp/ut-list.p (input-output c-lst-situacao).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN afterCreateUpdateRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateUpdateRecord DBOProgram 
PROCEDURE afterCreateUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Centralizar a execu‡Æo das regras de neg¢cio comuns a cria‡Æo e a
               modifica‡Æo do registro.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR l-pendente      AS LOG                       NO-UNDO.
    DEF VAR l-retorno       AS LOG                       NO-UNDO.
    DEF VAR c-msg           AS CHAR                      NO-UNDO.
    DEF VAR c-help          AS CHAR                      NO-UNDO.
    DEF VAR i-seq           LIKE RowErrors.ErrorSequence NO-UNDO.

    DEFINE BUFFER b-it-requis FOR it-requisicao.
    
    FIND FIRST param-aprov NO-LOCK NO-ERROR.

    /* Condicional de validação da necessidade de se manter o registro do 
       pedido de compra via alteração de uma flag no campo char-1. Leonardo Hermes*/
    
    if not valid-handle (h-boin385fx) then 
        run inbo/boin385fx.p persistent set h-boin385fx.
    
    run openQueryStatic in h-boin385fx (input "Main").
    
    run goToKey in h-boin385fx (input rowObject.nr-requisicao).
    
    run getRecord in h-boin385fx (output table ttRequisicao).
    
    find first ttRequisicao no-error.
    if  avail ttRequisicao then do:
        
        if l-flex-lastItem = YES then do:
            if l-lastItem = YES then do:
                ASSIGN OVERLAY(ttRequisicao.char-1,1,1) = "S".
            end.
            else do:
                ASSIGN OVERLAY(ttRequisicao.char-1,1,1) = "N".
            end.    
        end.
        ELSE DO:
            ASSIGN OVERLAY(ttRequisicao.char-1,1,1) = "N".
        END.
    end.
    
    run setRecord in h-boin385fx (input table ttRequisicao).
    
    run updateRecord in h-boin385fx.
    
    IF VALID-HANDLE(h-boin385fx) THEN DO:
        delete procedure h-boin385fx.
        assign h-boin385fx = ?.
    END.

    FIND FIRST requisicao
        WHERE requisicao.nr-requisicao = RowObject.nr-requisicao EXCLUSIVE-LOCK NO-ERROR.

    if  requisicao.tp-requis <> 3 then do: /* Solicita‡Æo Cota‡Æo */
        IF  (c-tipo-acao = "CREATE" or (c-tipo-acao = "UPDATE" and RowObject.qt-a-atender > 0)) then do:
            /*** Execu‡Æo Or‡ament ria ***/
            run cdp/cdapi198fx.p (input rowid(it-requisicao),
                                  input 2, /* confirma‡Æo */
                                  input yes,
                                  input-output table tt_xml_input_1,
                                  output table RowErrors append).
    
            if  return-value = "NOK" then 
                return "NOK".
        END.
        ELSE IF c-tipo-acao = "UPDATE" and RowObject.qt-a-atender = 0 THEN DO:
            run cdp/cdapi198fx.p (input rowid(requisicao), /*rowid requisicao*/
                                  INPUT 3,
                                  input yes,
                                  input-output table tt_xml_input_1, /* elimina requisicao(it-requisicao) */
                                  output table RowErrors APPEND ).  
            
            if  return-value = "nok" then 
                undo, return "ADM-ERROR":U.
        END.
    end.

    IF c-tipo-acao = "Create" THEN DO:

       /*** INVESTIMENTOS ***/
        IF  CONNECTED("mginv")
        AND param-global.modulo-in
        AND RowObject.num-ord-inv <> 0 THEN DO:
    
            RUN inp/in2101a.p (INPUT ROWID(requisicao),
                               INPUT ROWID(it-requisicao),
                               INPUT "Inclui",
                               INPUT NO, /* exibe mensagens de erro/alerta em tela */
                               OUTPUT TABLE RowErrors APPEND).
                               
            IF RETURN-VALUE = "NOK" THEN 
                RETURN "NOK".  
    
        END.

    END.

    
     /*** APROVA€ÇO ELETRâNICA ***/
    if  requisicao.tp-requis = 1                  /* Requisi‡Æo Estoque */
    and param-compra.log-1                        /* Aprova‡Æo Eletr“nica */  
    and substr(param-estoq.char-1,4,1) = "Y" then /* Aprova‡Æo Requisi‡Æo */
       assign i-tipo-doc = 2.
    else if requisicao.tp-requis = 2 /* Solicita‡Æo de Compra */
        and param-compra.log-1 then /* Aprova‡Æo Eletr“nica */
        assign i-tipo-doc = 1.
    else 
        assign i-tipo-doc = 0.

    /*** APROVA€ÇO ELETRâNICA ***/
    if  i-tipo-doc > 0 then do:

        if  l-integra-aed-ems
        or (i-tipo-doc = 1 and param-aprov.aprova-solic) or (i-tipo-doc = 2 and param-aprov.aprova-requis) then do: 
        
            
            /*Verifica se existem aprovadores para o documento*/
            assign l-retorno = no.
            run cdp/cdapi173.p (INPUT i-tipo-doc, 
                                INPUT RowObject.it-codigo, 
                                input requisicao.nome-abrev,
                                output l-retorno).

            if not l-retorno then do:
                run utp/ut-msgs.p (input "msg":U,
                                   input 15661,
                                   input "").
                assign c-msg = trim(return-value).
                
                run utp/ut-msgs.p (input "help":U,
                                   input 15661,
                                   input "").
                assign c-help = trim(return-value).
                
                FIND LAST RowErrors NO-LOCK NO-ERROR.
                assign i-seq = if avail RowErrors then RowErrors.ErrorSequence + 1 else 1.
                
                CREATE RowErrors.
                ASSIGN RowErrors.ErrorSequence     = i-seq
                        RowErrors.ErrorNumber      = 15661 
                        RowErrors.ErrorDescription = c-msg
                        RowErrors.ErrorHelp        = c-help
                        RowErrors.ErrorType        = ""
                        RowErrors.ErrorSubType     = "ERROR":U.

                return "NOK":U.
                        
            end.
            
            RUN cdp/cdapi171.p PERSISTENT SET h-cdapi171 (INPUT i-tipo-doc,INPUT 0,INPUT rowid(it-requisicao)).
            
            
            if (i-tipo-doc = 1 and substring(param-compra.char-2, 1, 3) = "sim":U) 
            or (i-tipo-doc = 2 and substring(param-compra.char-2, 4, 3) = "sim":U) then do:

                RUN pi-executar IN h-cdapi171 (input i-tipo-doc,           
                                               input 2, 
                                               input rowid(it-requisicao)).
            END.
            ELSE DO:
                IF  c-tipo-acao = "CREATE" THEN
                    RUN pi-executar IN h-cdapi171 (input i-tipo-doc,           
                                                   input 1, 
                                                   input rowid(it-requisicao)).
                ELSE
                    IF c-tipo-acao = "UPDATE" THEN
                        RUN pi-executar IN h-cdapi171 (input i-tipo-doc,           
                                                       input 2, 
                                                       input rowid(it-requisicao)).
            END.
                                 
            RUN pi-retorna-tt-erro IN h-cdapi171 (OUTPUT TABLE tt-erro-documentos).

            FOR EACH tt-erro-documentos:
                {method/svc/errors/inserr.i 
                    &ErrorNumber="tt-erro-documentos.cd-erro"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"} 
            END.


            assign l-pendente = no.
            /* Verifica‡Æo da Pendˆncia */
            run cdp/cdapi172.p (input  i-tipo-doc,
                                input  rowid(it-requisicao),
                                output l-pendente).
            
            /* Documento pendente de aprova‡Æo */
            if  l-pendente then do:
                assign requisicao.estado        = 2  /* NÆo Aprovada */
                       requisicao.nome-aprov    = ""
                       it-requisicao.estado     = 2
                       it-requisicao.nome-aprov = "". 
                /* Aprovacao por Total */
                if (i-tipo-doc = 1 and substring(param-compra.char-2, 1, 3) = "sim":U) 
                or (i-tipo-doc = 2 and substring(param-compra.char-2, 4, 3) = "sim":U) then
                    /* Reabre outras parcelas */
                   for each b-it-requis 
                      where b-it-requis.nr-requisicao = requisicao.nr-requisicao                            
                        and b-it-requis.sequencia <> it-requisicao.sequencia
                        and (b-it-requis.situacao = 1 or b-it-requis.situacao = 3)EXCLUSIVE-LOCK:                            
                        assign b-it-requis.estado = 2
                               b-it-requis.nome-aprov = "".    
                   end.
                
            end.
            else do:

                assign it-requisicao.estado = 1. /* Aprovada */

                if  can-find (first it-requisicao
                              where it-requisicao.nr-requisicao = RowObject.nr-requisicao
                                and it-requisicao.estado        = 2
                                AND rowid(it-requisicao) <> RowObject.r-rowid) then /* NÆo Aprovada */
                    assign requisicao.estado = 2. /* NÆo Aprovada */
                else
                    assign requisicao.estado = 1. /* Aprovada */
            end.

            
            if ((    i-tipo-doc = 1 /* Solicita‡Æo Compra */ 
                and substr(param-compra.char-2,1,3) = "SIM") /* Aprova‡Æo por Total */
            or (    i-tipo-doc = 2 /*  Requisi‡Æo Estoque */
                and substr(param-compra.char-2,4,3) = "SIM")) then do: /* Aprova‡Æo por Total */
                 IF l-lastItem = YES THEN DO:
                     run eletronicApprovalMessage.
                 END.
            end.
            ELSE if ((    i-tipo-doc = 1 /* Solicita‡Æo Compra */ 
                and substr(param-compra.char-2,1,3) = "NÆo") /* Aprova‡Æo por item */
            or (    i-tipo-doc = 2 /*  Requisi‡Æo Estoque */
                and substr(param-compra.char-2,4,3) = "NÆo") /* Aprova‡Æo por item */) then do:
                RUN eletronicApprovalMessage.
            END.
        end.
        else 
            assign requisicao.estado    = 1 /* Aprovada */
                   it-requisicao.estado = 1 /* Aprovada */.
    end.
    /* Aprova Requisi‡Æo e Item da Requisi‡Æo quando nÆo trabalha com Aprova‡Æo Eletr“nica */
    else
        assign requisicao.estado    = 1 /* Aprovada */
               it-requisicao.estado = 1 /* Aprovada */.
    /****************************/
    find first requisicao
        where requisicao.nr-requisicao = RowObject.nr-requisicao NO-LOCK no-error.

    
    IF VALID-HANDLE(h-cdapi171) THEN DO:
        DELETE PROCEDURE h-cdapi171.
        ASSIGN h-cdapi171 = ?.
    END.
    
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUFFER bf-requisicao FOR requisicao.

    IF NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.
    
    IF NOT AVAIL param-compra THEN
        FIND FIRST param-compra NO-LOCK NO-ERROR.    
    
    run afterCreateUpdateRecord.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
     
    /* Requisi‡Æo Estoque */
    if  RowObject.qt-a-atender = 0 then do:
        
        find first it-requisicao
            where rowid(it-requisicao) = RowObject.r-rowid exclusive-lock no-error.
        if  avail it-requisicao then
            assign it-requisicao.situacao  = 2 /* Fechada */.
        
        FIND FIRST requisicao exclusive-lock
             WHERE requisicao.nr-requisicao = it-requisicao.nr-requisicao no-error.
        
        if  avail requisicao THEN DO:
            IF requisicao.situacao = 1 THEN DO:

                IF not can-find(first it-requisicao 
                                where it-requisicao.nr-requisicao = requisicao.nr-requisicao
                                  and it-requisicao.situacao      = 1
                                  AND rowid(it-requisicao) <> RowObject.r-rowid) then do: /* Aberta */
                       assign requisicao.situacao = 2. /* Fechada */                   
                END.
           END.
        END.
        FIND FIRST requisicao NO-LOCK
             WHERE requisicao.nr-requisicao = it-requisicao.nr-requisicao no-error.
    end.
    
    if (    l-unidade-negocio
        and requisicao.tp-requis = 1) /* Requisi‡Æo Estoque */
    or (    l-mat-unid-negoc
        and (   requisicao.tp-requis = 2            /* Solicita‡Æo Compra */
             or requisicao.tp-requis = 3)) then do: /* Solicita‡Æo Cota‡Æo */

        if RowObject.cod-unid-negoc = ? then 
           assign RowObject.cod-unid-negoc = "".
        if  RowObject.cod-unid-negoc <> "" then do:

            /* Eliminar Unidades de Neg¢cio relacionadas do item da requisi‡Æo */
            IF NOT VALID-HANDLE(h-boin658fx) THEN
                RUN inbo/boin658fx.p PERSISTENT SET h-boin658fx.
        
            run openQueryStatic in h-boin658fx (input "Main").
            run getRowErrors in h-boin658fx (output table RowErrors append).
            FOR EACH RowErrors 
                WHERE (RowErrors.ErrorNumber   = 8 
                      or RowErrors.ErrorNumber = 3): 
                DELETE RowErrors.
            END.
        
            for each  unid-neg-requis
                where unid-neg-requis.nr-requisicao = RowObject.nr-requisicao
                  and unid-neg-requis.sequencia     = RowObject.sequencia
                  and unid-neg-requis.it-codigo     = RowObject.it-codigo no-lock:
        
                run repositionRecord in h-boin658fx (input rowid(unid-neg-requis)).
                run deleteRecord     in h-boin658fx.
                if  return-value = "NOK" then do:
                    run getRowErrors in h-boin658fx (output table RowErrors append).
                    FOR EACH RowErrors 
                        WHERE (RowErrors.ErrorNumber   = 8 
                              or RowErrors.ErrorNumber = 3): 
                        DELETE RowErrors.
                    END.
                    if  can-find(first RowErrors where RowErrors.ErrorSubType = "ERROR":U) then
                        return "NOK".
                end.
            end.

            IF h-boin658fx <> ? AND VALID-HANDLE(h-boin658fx) THEN DO:
                DELETE PROCEDURE h-boin658fx.
                ASSIGN h-boin658fx = ?.
            END.

        end.
    end.
    
    /*** INVESTIMENTOS ***/
    if  connected("mginv")
    and param-global.modulo-in
    and RowObject.num-ord-inv <> 0 then do:

        IF  RowObject.qt-atendida  = 0 
        AND RowObject.qt-a-atender = 0 THEN DO:

            ASSIGN it-requisicao.qt-requisitada = qt-requis-inv.

            run inp/in2101a.p(INPUT ROWID(requisicao), 
                              INPUT ROWID(it-requisicao), 
                              INPUT "Elimina",
                              INPUT NO, /* exibe mensagens de erro/alerta em tela */
                              OUTPUT TABLE RowErrors APPEND). 
            if  can-find(first RowErrors
                         where RowErrors.ErrorSubType = "error") then
                return "NOK".  

        END.
        ELSE DO:

            run inp/in2101a.p (input rowid(requisicao),
                               input rowid(it-requisicao),
                               input "Modifica",
                               input no, /* exibe mensagens de erro/alerta em tela */
                               output table RowErrors append).
            if  can-find(first RowErrors
                         where RowErrors.ErrorSubType = "error") then
                return "NOK". 

        END.
    end.
    /*********************/

    IF NOT AVAIL it-requisicao THEN
        find first it-requisicao
            where rowid(it-requisicao) = RowObject.r-rowid exclusive-lock no-error.

    /*** Atualiza situa‡Æo do item para comprador prosseguir com o processo de compra ***/
    if  it-requisicao.situacao = 3 then do: /* Incompleta */

        find first requisicao
            where requisicao.nr-requisicao = RowObject.nr-requisicao exclusive-lock no-error.
        if  avail requisicao then do:

            assign it-requisicao.situacao = 1. /* Aberta */

            if  can-find (first it-requisicao
                          where it-requisicao.nr-requisicao = RowObject.nr-requisicao
                            and it-requisicao.situacao      = 3) then /* Incompleta */
                assign requisicao.situacao = 3. /* Incompleta */
            else
                assign requisicao.situacao = 1. /* Aberta */
        end.
        find first requisicao
            where requisicao.nr-requisicao = RowObject.nr-requisicao NO-lock no-error.
    end.
    /************************************************************************************/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    run beforeCreateUpdateRecord.
              
    assign RowObject.tp-requis      = requisicao.tp-requis
           RowObject.qt-requisitada = RowObject.qt-a-atender
           RowObject.qt-atendida    = 0
           RowObject.qt-devolvida   = 0
           RowObject.qt-a-devolver  = 0.

    {cdp/finditemuniestab.i RowObject.it-codigo requisicao.cod-estabel}
    if  avail item-uni-estab then do:
        assign RowObject.cod-depos = item-uni-estab.deposito-pad.

        /* Gera‡Æo de Ordens: Grupo de Compras */
        if  param-compra.int-2 = 1 then
            assign RowObject.cod-grp-compra = item-uni-estab.cod-grp-compra.
        else /* Gera‡Æo de Ordens: Comprador */
            assign RowObject.cod-comprado = item-uni-estab.cod-comprado.
    end.
    
    if RowObject.cod-refer = ? then
        RowObject.cod-refer = "".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateUpdateRecord DBOProgram 
PROCEDURE beforeCreateUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Centralizar a execu‡Æo das regras de neg¢cio comuns a cria‡Æo e a
               modifica‡Æo do registro.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  avail estabelec
    and connected("mginv")
    and param-global.modulo-in
    and RowObject.num-ord-inv <> 0 then
        assign RowObject.ep-codigo = estabelec.ep-codigo.


    if  avail requisicao then
        assign RowObject.nome-abrev  = requisicao.nome-abrev
               RowObject.cod-estabel = requisicao.cod-estabel.


    assign RowObject.val-item = RowObject.qt-a-atender * RowObject.preco-unit.
    if  RowObject.val-item < 0.01 then
        assign RowObject.val-item = 0.01.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var l-pendente as log no-undo.

    /*** APROVA€ÇO ELETRâNICA ***/
    if  requisicao.tp-requis = 1                  /* Requisi‡Æo Estoque */
    and param-compra.log-1                        /* Aprova‡Æo Eletr“nica */  
    and substr(param-estoq.char-1,4,1) = "Y" then /* Aprova‡Æo Requisi‡Æo */
       assign i-tipo-doc = 2.
    else if requisicao.tp-requis = 2 /* Solicita‡Æo de Compra */
        and param-compra.log-1 then /* Aprova‡Æo Eletr“nica */
        assign i-tipo-doc = 1.
    else 
        assign i-tipo-doc = 0.

    if  i-tipo-doc > 0 then do:

        /* Aprova‡Æo por Item - Elimina‡Æo de Pendˆncias */
        if  (    i-tipo-doc = 1 /* Solicita‡Æo de Compra */
             and substr(param-compra.char-2,1,3) = "NAO")  /* Aprova‡Æo por Item */
        or  (    i-tipo-doc = 2 /* Requisi‡Æo Estoque */
             and substr(param-compra.char-2,4,3) = "NAO") then do: /* Aprova‡Æo por Item */
            run cdp/cdapi171.p (input i-tipo-doc,
                                input 3, /* Elimina‡Æo */
                                input RowObject.r-rowid).

            find first requisicao
                where requisicao.nr-requisicao = RowObject.nr-requisicao exclusive-lock no-error.

            if  not can-find(first it-requisicao
                             where it-requisicao.nr-requisicao = RowObject.nr-requisicao
                               and it-requisicao.situacao <> 2           /* Fechada */
                               and it-requisicao.situacao <> 4) then do: /* Com Ordem */

                assign requisicao.estado = 1. /* Aprovada */

                if  requisicao.tp-requis = 1 then /* Requisi‡Æo Estoque */
                    assign requisicao.situacao = 2. /* Fechada */
                else 
                    assign requisicao.situacao = 4. /* Com ordem */
            end.

            if  not can-find(first it-requisicao
                             where it-requisicao.nr-requisicao = RowObject.nr-requisicao
                               and it-requisicao.estado = 2) then do: /* Aprovada */
                assign requisicao.situacao = 1  /* Aberta */
                       requisicao.estado   = 1. /* Aprovada */
            end.
            find first requisicao
                where requisicao.nr-requisicao = RowObject.nr-requisicao NO-lock no-error.
        end.        
    end.
    /****************************/

    /*** INVESTIMENTOS ***/
    if  connected("mginv")
    and param-global.modulo-in
    and RowObject.num-ord-inv <> 0 then do:

        run inp/in2101a.p (input rowid(requisicao),
                           input rowid(it-requisicao),
                           input "Elimina",
                           input no, /* exibe mensagens de erro/alerta em tela */
                           output table RowErrors append).
        if  can-find(first RowErrors
                     where RowErrors.ErrorSubType = "error") then
            return "NOK".
    end.
    /*********************/

    /*** Elimina‡Æo das Unidades de Neg¢cio do Item da Requisi‡Æo ***/
    if l-unidade-negocio
    OR l-mat-unid-negoc then do:

        IF NOT VALID-HANDLE(h-boin658fx) THEN
            RUN inbo/boin658fx.p PERSISTENT SET h-boin658fx.

        run openQueryStatic in h-boin658fx (input "Main").

        for each  unid-neg-requis
            where unid-neg-requis.nr-requisicao = RowObject.nr-requisicao
              and unid-neg-requis.sequencia     = RowObject.sequencia
              and unid-neg-requis.it-codigo     = RowObject.it-codigo no-lock:

            run emptyRowErrors   in h-boin658fx.
            run repositionRecord in h-boin658fx (input rowid(unid-neg-requis)).
            run deleteRecord     in h-boin658fx.

            if  return-value = "NOK" then do:
                run getRowErrors in h-boin658fx (output table RowErrors append).

                for each RowErrors
                    where RowErrors.ErrorType = "INTERNAL":
                    delete RowErrors.
                end.

                if  can-find(first RowErrors where RowErrors.ErrorSubType = "ERROR") then
                    return "NOK".
            end.
        end.

        IF h-boin658fx <> ? AND VALID-HANDLE(h-boin658fx) THEN DO:
            DELETE PROCEDURE h-boin658fx.
            ASSIGN h-boin658fx = ?.
        END.

    end.
    /****************************************************************/

    /*** EXECU€ÇO OR€AMENTµRIA ***/
    if  requisicao.tp-requis <> 3 then do: /* Solicita‡Æo Cota‡Æo */
        run cdp/cdapi198fx.p (input RowObject.r-rowid,
                              input 1,
                              input yes,
                              input-output table tt_xml_input_1,
                              output table RowErrors append).  
        if  return-value = "NOK" then 
            return "NOK".
    end.
    /*****************************/

    /*if  not can-find(first it-requisicao
                     where it-requisicao.nr-requisicao = requisicao.nr-requisicao
                     and b-it-requis.situacao <> 2 and b-it-requis.situacao <> 4)
                     and can-find (first b-it-requis
                                   where b-it-requis.nr-requisicao = requisicao.nr-requisicao) then do: /* Atendida-Fechada */

        if  requisicao.tp-requis = 1 then /* requis */
            assign requisicao.situacao = 2. /* fechada */
        else 
            assign requisicao.situacao = 4. /* com ordem */
        assign requisicao.estado   = 1. /* aprovada */

    end.
    else do:
            /*Aprovacao Eletronica controle Total 26/05/2003 */
            if ((    i-tipo-doc = 1
                 and substr(param-compra.char-2, 1, 3) = "sim")
            or (    i-tipo-doc = 2
                and substr(param-compra.char-2, 4, 3) = "sim")) 
                   and avail requisicao then do:
                assign l-pendente = no.

/*                 for each it-requisicao                                                       */
/*                     where it-requisicao.nr-requisicao = requisicao.nr-requisicao             */
/*                     no-lock:                                                                 */
/*                     run cdp/cdapi172.p (i-tipo-doc,rowid(it-requisicao), output l-pendente). */
/*                     if  l-pendente then leave.                                               */
/*                 end.                                                                         */
/*                 assign requisicao.situacao = 1  /* aberta */                                 */
/*                        requisicao.estado   = if  not l-pendente then 1 /* aprovada */        */
/*                                                                 else 2.                      */
/*                 for each it-requisicao                                                       */
/*                     where it-requisicao.nr-requisicao = requisicao.nr-requisicao             */
/*                     and (   it-requisicao.situacao = 1                                       */
/*                          or it-requisicao.situacao = 3) exclusive-lock:                      */
/*                     assign it-requisicao.estado     = requisicao.estado                      */
/*                            it-requisicao.nome-aprov = "".                                    */
/*                 end.                                                                         */
            end.
            else do:
                /*Aprovacao Eletronica controle por Item*/
                if  not can-find ( first b-it-requis
                        where b-it-requis.nr-requisicao = requisicao.nr-requisicao
                        and   b-it-requis.estado = 2 ) 
                then do: /* aprovada */
                    assign requisicao.situacao = 1  /* aberta */
                           requisicao.estado   = 1. /* aprovada */
                    if  valid-handle(h-v02in385) then
                        run pi-atualiza-estado in h-v02in385.
                end.
            END.
*/

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE validateUpdateQtyAfterWms :

    DEFINE VARIABLE de-qt-requis-wms   AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-qt-ja-atendida  AS DECIMAL NO-UNDO.
    DEFINE VARIABLE l-possui-wms       AS LOGICAL NO-UNDO.
    DEFINE VARIABLE c-msg-wms-pendente AS CHARACTER NO-UNDO.

    DEFINE BUFFER bf-requisicao-wms    FOR requisicao.
    DEFINE BUFFER bf-it-requisicao-wms FOR it-requisicao.

    FIND FIRST bf-requisicao-wms NO-LOCK
         WHERE bf-requisicao-wms.nr-requisicao = RowObject.nr-requisicao
         NO-ERROR.

    IF NOT AVAIL bf-requisicao-wms THEN
        RETURN "OK":U.
    
    IF bf-requisicao-wms.tp-requis <> 1 THEN
        RETURN "OK":U.
    FIND FIRST bf-it-requisicao-wms NO-LOCK
         WHERE bf-it-requisicao-wms.nr-requisicao = RowObject.nr-requisicao
           AND bf-it-requisicao-wms.sequencia     = RowObject.sequencia
           AND bf-it-requisicao-wms.it-codigo     = RowObject.it-codigo
         NO-ERROR.

    IF NOT AVAIL bf-it-requisicao-wms THEN
        RETURN "OK":U.

    FOR EACH ws-atend-devol-it-requis NO-LOCK
        WHERE ws-atend-devol-it-requis.nr-requisicao  = bf-it-requisicao-wms.nr-requisicao
          AND ws-atend-devol-it-requis.seq-it-requis  = bf-it-requisicao-wms.sequencia
          AND ws-atend-devol-it-requis.it-codigo      = bf-it-requisicao-wms.it-codigo
          AND ws-atend-devol-it-requis.idi-tipo-movto = 1
          AND ws-atend-devol-it-requis.idi-sit-docto  < 3:
        ASSIGN l-possui-wms     = YES
               de-qt-requis-wms = de-qt-requis-wms
                                + ws-atend-devol-it-requis.qtd-requisitada.
    END.

    IF NOT l-possui-wms THEN
        RETURN "OK":U.
        
    ASSIGN de-qt-ja-atendida = bf-it-requisicao-wms.qt-atendida
                             + de-qt-requis-wms.
    IF de-qt-ja-atendida > 0
    AND RowObject.qt-a-atender < de-qt-ja-atendida THEN DO:
        ASSIGN c-msg-wms-pendente = "Existem itens pendentes de retorno no WMS.NÆo ‚ poss¡vel realizar a opera‡Æo pois existem itens pendentes de retorno no WMS.":U.
        RUN createRowErrors IN THIS-PROCEDURE (
            INPUT 2,
            INPUT 35736,
            INPUT c-msg-wms-pendente
        ).
        RETURN "NOK":U.
    END.
    RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN validateUpdateQtyAfterWms.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
        
    assign qt-requis-inv = RowObject.qt-requisitada.
    assign RowObject.qt-requisitada = RowObject.qt-a-atender + RowObject.qt-atendida.

    run beforeCreateUpdateRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lFlexLastItem DBOProgram
PROCEDURE lFlexLastItem :
/*------------------------------------------------------------------------------
  Purpose:     Verifica a necessidade de manter a requisição pendente,
               quando a mesmo estiver em edição pela tela flex.
  Parameters:  Flag do flex para manter a requisição pendente, flag do flex que 
               define se o item adicionado é a ultima interação da requisição.
  Notes:
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER p-flex-lastItem AS LOGICAL.
    DEFINE INPUT PARAMETER p-lastItem      AS LOGICAL.
    
    ASSIGN l-flex-lastItem = p-flex-lastItem
           l-lastItem      = p-lastItem.
    
    RETURN "OK":U.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eletronicApprovalMessage DBOProgram 
PROCEDURE eletronicApprovalMessage :
/*------------------------------------------------------------------------------
  Purpose:     Informar ao usu rio o estado da requisi‡Æo no M¢dulo de Aprova‡Æo
               Eletr“nica.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var c-tipo-moeda     as char    no-undo.
    def var c-moeda-lim      as char    no-undo.
    def var i-moeda-lim      as int     no-undo.
    def var i-tipo-moeda     as int     no-undo.
    def var de-valor-doc     as dec     no-undo.
    def var de-valor-lim     as dec     no-undo.
    DEF VAR c-valor-msg      AS CHARACTER NO-UNDO.
    DEF VAR l-oculta-preco   AS LOGICAL NO-UNDO.

    /* verifica se est  parametrizado para esconder o valor da pendˆncia */
    FOR FIRST usuar-mater FIELDS(char-1)
        WHERE usuar-mater.cod-usuario = c-seg-usuario NO-LOCK: 
        ASSIGN l-oculta-preco = IF SUBSTRING(usuar-mater.char-1,21,1) = "S":U THEN YES ELSE NO.
    END.

    for first it-requisicao fields(estado)
        where it-requisicao.nr-requisicao = RowObject.nr-requisicao 
          and it-requisicao.it-codigo     = RowObject.it-codigo
          and it-requisicao.sequencia     = RowObject.sequencia no-lock:
    end.

    if i-tipo-doc > 0 and avail it-requisicao then do:
        run cdp/cdapi174.p (input  i-tipo-doc,
                            input  rowid(it-requisicao),
                            output i-moeda-lim,
                            output i-tipo-moeda,
                            output de-valor-doc,
                            output de-valor-lim).

        {cdp/findmoeda.i i-moeda-lim}
        if  avail moeda then
            assign c-moeda-lim = string(i-moeda-lim,"9") + " - " + moeda.descricao.

        case i-tipo-moeda:
            when 1 then do:
                {utp/ut-liter.i (Usu rio)}
                assign c-tipo-moeda = return-value.
            end.
            when 2 then do:
                {utp/ut-liter.i (Aprovador)}
                assign c-tipo-moeda = return-value.
            end.
            when 3 then do:
                {utp/ut-liter.i (Fam¡lia)}
                assign c-tipo-moeda = return-value.
            end.
            when 4 then do:
                {utp/ut-liter.i (Mestre)}
                assign c-tipo-moeda = return-value.
            end.
        end case.

        /* Caso esteja parametrizado para esconder o valor da pendˆncia, mostrar apenas "-" na mensagem */
            IF l-oculta-preco THEN
                ASSIGN c-valor-msg = "-".
            ELSE
                ASSIGN c-valor-msg = string(de-valor-doc,'zzz,zzz,zzz,zzz,zz9.99').

        if  it-requisicao.estado = 1 then do:
            {method/svc/errors/inserr.i &ErrorNumber="16725"
                                        &ErrorType="EMS"
                                        &ErrorSubType="INFORMATION"
                                        &ErrorParameters="c-moeda-lim + '~~~~' +
                                                         string(de-valor-lim,'zzz,zzz,zzz,zzz,zz9.99') + c-tipo-moeda + '~~~~' +
                                                         c-valor-msg"} 
        end.
        else do:
            {method/svc/errors/inserr.i &ErrorNumber="16724"
                                        &ErrorType="EMS"
                                        &ErrorSubType="INFORMATION"
                                        &ErrorParameters="c-moeda-lim + '~~~~' +
                                                         string(de-valor-lim,'zzz,zzz,zzz,zzz,zz9.99') + c-tipo-moeda + '~~~~' +
                                                         c-valor-msg"} 
        end.
    end.
    else do:
        {method/svc/errors/inserr.i &ErrorNumber="16760"
                                    &ErrorType="EMS"
                                    &ErrorSubType="INFORMATION"
                                    &ErrorParameters="''"} 

    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-qtd-suficiente-atendimento DBOFunction 
FUNCTION fn-qtd-suficiente-atendimento RETURNS LOGICAL
  ( d-qtd-disponivel AS DECIMAL, d-qtd-atender AS DECIMAL):
  
    RETURN d-qtd-disponivel >= d-qtd-atender.
END FUNCTION.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-retorna-qtd-disponivel-lote DBOFunction 
FUNCTION fn-retorna-qtd-disponivel-lote RETURNS DECIMAL
  ( TABLE FOR ttSummaryInventoryBalance ):
  
    DEFINE VARIABLE d-qtd AS DECIMAL NO-UNDO.
    
    FOR EACH ttSummaryInventoryBalance
       WHERE ttSummaryInventoryBalance.dt-vali-lote >= TODAY
          OR ttSummaryInventoryBalance.is-wms-saas   = YES :
        ASSIGN d-qtd = d-qtd + ttSummaryInventoryBalance.qtidade-atu.
    END.

    RETURN d-qtd. 
END FUNCTION.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-retorna-qtd-disponivel DBOFunction 
FUNCTION fn-retorna-qtd-disponivel RETURNS DECIMAL
  ( TABLE FOR ttSummaryInventoryBalance ):
  
    DEFINE VARIABLE d-qtd AS DECIMAL NO-UNDO.
    
    FOR EACH ttSummaryInventoryBalance:
        ASSIGN d-qtd = d-qtd + ttSummaryInventoryBalance.qtidade-atu.
    END.

    RETURN d-qtd. 
END FUNCTION.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/************************ FUNCTIONS ***************/
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnLogProcessWMS DBOFunction 
FUNCTION fnLogProcessWMS RETURNS CHARACTER (INPUT pGeraWMS AS CHARACTER):
    IF pGeraWMS = "Y":U THEN {utp/ut-liter.i "Sim" *}
                        ELSE {utp/ut-liter.i "N’o" *}.
    RETURN RETURN-VALUE.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectedRequisitionProcessing DBOProgram 
PROCEDURE selectedRequisitionProcessing :
/*------------------------------------------------------------------------------
  Purpose:     Atendimento de requisi‡äes previamente selecionadas
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR ttItRequisicaoSelec.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
    
    EMPTY TEMP-TABLE RowErrors NO-ERROR.

    selectedRequisBlock:
    DO TRANSACTION ON ERROR UNDO, LEAVE selectedRequisBlock
                   ON STOP  UNDO, LEAVE selectedRequisBlock
                   ON QUIT  UNDO, LEAVE selectedRequisBlock:
                   
        FOR EACH ttItRequisicaoSelec:
        
           IF CAN-FIND(FIRST bf-ttItRequisicaoSelec 
                       WHERE bf-ttItRequisicaoSelec.nr-requisicao <>  ttItRequisicaoSelec.nr-requisicao) THEN DO:
                RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 58077, INPUT ""). /* Lote com data vencida */
                RETURN "NOK":U.
           END.

           EMPTY TEMP-TABLE ttItRequisicao-aux.

           CREATE ttItRequisicao-aux.
           BUFFER-COPY ttItRequisicaoSelec TO ttItRequisicao-aux.
           
          FOR FIRST it-requisicao FIELDS(nr-requisicao sequencia it-codigo cod-refer cod-estabel qt-a-atender)
                WHERE it-requisicao.nr-requisicao = ttItRequisicao-aux.nr-requisicao 
                  AND it-requisicao.sequencia     = ttItRequisicao-aux.sequencia NO-LOCK: END.

           EMPTY TEMP-TABLE RowErrors NO-ERROR.
           RUN simplifiedRequisitionProcessing IN THIS-PROCEDURE ( INPUT TABLE ttItRequisicao-aux,
                                                                  OUTPUT TABLE RowErrors).

           IF CAN-FIND(FIRST RowErrors 
                       WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
               UNDO selectedRequisBlock,  RETURN "NOK":U.           
           
        END.
        
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE simplifiedRequisitionProcessing DBOProgram 
PROCEDURE simplifiedRequisitionProcessing :
/*------------------------------------------------------------------------------
  Purpose:     Atendimento de requisi‡Æo por saldo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR ttItRequisicaoHTML.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
    
    EMPTY TEMP-TABLE RowErrors NO-ERROR.
    
    DEF VAR de-qtd-atender LIKE it-requisicao.qt-a-atender NO-UNDO.
    DEF VAR c-chave         AS CHAR                        NO-UNDO.

    DEFINE VARIABLE de-qtde-pendente-wms AS DECIMAL NO-UNDO.

    blk:
    DO  ON ERROR UNDO, LEAVE blk
        ON STOP  UNDO, LEAVE blk
        ON QUIT  UNDO, LEAVE blk: 

        FOR EACH ttItRequisicaoHTML:

            ASSIGN l-perm-sald-neg = YES.

            FOR FIRST requisicao FIELDS(cod-estabel) NO-LOCK
                WHERE requisicao.nr-requisicao = ttItRequisicaoHTML.nr-requisicao:
            END.

            FOR FIRST bfit-requisicao FIELDS(it-codigo cod-refer cod-estabel qt-a-atender)
                WHERE bfit-requisicao.nr-requisicao = ttItRequisicaoHTML.nr-requisicao 
                  AND bfit-requisicao.sequencia     = ttItRequisicaoHTML.sequencia NO-LOCK:

                ASSIGN de-qtde-pendente-wms = 0.
                FOR EACH ws-atend-devol-it-requis NO-LOCK
                    WHERE ws-atend-devol-it-requis.nr-requisicao  = bfit-requisicao.nr-requisicao
                      AND ws-atend-devol-it-requis.seq-it-requis  = bfit-requisicao.sequencia
                      AND ws-atend-devol-it-requis.idi-tipo-movto = 1  /* Atendimento */
                      AND ws-atend-devol-it-requis.idi-sit-docto  < 3: /* Em Processo ou Em Processo WMS */
                    ASSIGN de-qtde-pendente-wms = de-qtde-pendente-wms + ws-atend-devol-it-requis.qtd-requisitada.
                END.
                
                IF de-qtde-pendente-wms >= bfit-requisicao.qt-a-atender THEN DO:
                    RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, 27616, "").
                    LEAVE blk.
                END.
                
                ASSIGN de-qtd-atender = ttItRequisicaoHTML.qt-a-atender - de-qtde-pendente-wms.
                
                IF de-qtd-atender <= 0 THEN NEXT.

                FOR FIRST item FIELDS(tipo-con-est perm-saldo-neg) NO-LOCK 
                    WHERE item.it-codigo = bfit-requisicao.it-codigo: 
                END.

                FOR first item-uni-estab FIELDS(perm-saldo-neg)
                    where item-uni-estab.it-codigo   = bfit-requisicao.it-codigo
                      and item-uni-estab.cod-estabel = requisicao.cod-estabel no-lock:
                END.

                EMPTY TEMP-TABLE ttSummaryInventoryBalance.
                EMPTY TEMP-TABLE ttSummaryInventoryBalanceAux.

                /*Verifica se item aceita saldo negativo*/
                IF AVAIL item-uni-estab THEN DO:
                    IF item-uni-estab.perm-saldo-neg = 1 THEN
                        ASSIGN l-perm-sald-neg = NO.                
                END.
                ELSE DO:
                    IF AVAIL ITEM AND item.perm-saldo-neg = 1 THEN
                        ASSIGN l-perm-sald-neg = NO.
                END.

                RUN getItemBalance IN THIS-PROCEDURE ( INPUT ROWID(bfit-requisicao), 
                                                       INPUT NO,                
                                                      OUTPUT TABLE ttSummaryInventoryBalance).
                
                RUN validaQtdeAtender IN THIS-PROCEDURE (INPUT de-qtd-atender,
                                                         INPUT-OUTPUT TABLE ttSummaryInventoryBalance).
               
                /*Se ocorreu algum erro na validacao da quantidade a atender nao faz o atendimento*/
                IF CAN-FIND(FIRST RowErrors) THEN
                    LEAVE.

                /*faz a ordenacao dos depositos*/
                RUN ordenaDepositos IN THIS-PROCEDURE.
                
                /*Regra para distribuicao das quantidades caso dep½sito n’o tenha quantidade suficiente para atender a requisicao */
                FOR EACH ttInventoryBalanceOrdered
                      BY ttInventoryBalanceOrdered.seq:

                    EMPTY TEMP-TABLE RowErrors. 

                    IF AVAIL ITEM AND item.tipo-con-est >= 3 /*refer e lote*/ 
                        AND ttInventoryBalanceOrdered.dt-vali-lote < TODAY
                        AND ttInventoryBalanceOrdered.is-wms-saas  = NO THEN
                        RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 3007, INPUT ""). /* Lote com data vencida */

                    /* Valida Deposito */
                    FOR FIRST deposito FIELDS(ind-dep-cq ind-dep-rej) NO-LOCK 
                        WHERE deposito.cod-depos = ttInventoryBalanceOrdered.cod-depos:             
                        IF deposito.ind-dep-cq THEN
                            RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 8374, INPUT ""). /* Deposito de CQ nao pode ser movimentado */
                            
                        IF deposito.ind-dep-rej THEN
                            RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 5713, INPUT ""). /* Deposito de rejeicao nao pode ser movimentado */
                    END.

                    IF CAN-FIND(FIRST RowErrors) THEN
                        NEXT.
                    
                    CREATE ttSummaryInventoryBalanceAux.
                    ASSIGN ttSummaryInventoryBalanceAux.nr-requisicao = ttItRequisicaoHTML.nr-requisicao
                           ttSummaryInventoryBalanceAux.sequencia     = ttItRequisicaoHTML.sequencia
                           ttSummaryInventoryBalanceAux.cod-depos     = ttInventoryBalanceOrdered.cod-depos
                           ttSummaryInventoryBalanceAux.cod-localiz   = ttInventoryBalanceOrdered.cod-localiz
                           ttSummaryInventoryBalanceAux.lote          = ttInventoryBalanceOrdered.lote
                           ttSummaryInventoryBalanceAux.dt-vali-lote  = ttInventoryBalanceOrdered.dt-vali-lote
                           ttSummaryInventoryBalanceAux.cod-refer     = ttInventoryBalanceOrdered.cod-refer
                           ttSummaryInventoryBalanceAux.qtidade-atu   = ttInventoryBalanceOrdered.qtidade-atu
                           ttSummaryInventoryBalanceAux.is-wms-saas   = ttInventoryBalanceOrdered.is-wms-saas.

                    /* SEM SALDO EM ESTOQUE POREM ACEITA SALDO NEGATIVO */
                    IF d-saldo-deposito <= 0 THEN DO:
                           /*GRAVA A CHAVE DO REGISTRO ATUAL*/ 
                           ASSIGN c-chave = ttSummaryInventoryBalanceAux.cod-depos      + "|" + 
                                            ttSummaryInventoryBalanceAux.cod-localiz    + "|" + 
                                            ttSummaryInventoryBalanceAux.lote           + "|" + 
                                            ttSummaryInventoryBalanceAux.cod-refer.
                        LEAVE.
                    END.

                    /*Atende totalmente a quantidade requisitada quando a quantidade em estoque ‚ maior ou quando aceita saldo negativo*/
                    IF ttInventoryBalanceOrdered.qtidade-atu > de-qtd-atender /*OR
                      (ttInventoryBalanceOrdered.qtidade-atu <= 0)*/ THEN
                        ASSIGN ttSummaryInventoryBalanceAux.qt-a-atender = de-qtd-atender
                               de-qtd-atender = 0.
                    ELSE IF ttInventoryBalanceOrdered.qtidade-atu > 0 THEN /*Atendimento parcial no dep½sito corrente*/
                        ASSIGN ttSummaryInventoryBalanceAux.qt-a-atender = ttInventoryBalanceOrdered.qtidade-atu
                               de-qtd-atender = de-qtd-atender - ttInventoryBalanceOrdered.qtidade-atu
                               
                               /*GRAVA A CHAVE DO REGISTRO ATUAL*/ 
                               c-chave = ttSummaryInventoryBalanceAux.cod-depos      + "|" + 
                                         ttSummaryInventoryBalanceAux.cod-localiz    + "|" + 
                                         ttSummaryInventoryBalanceAux.lote           + "|" + 
                                         ttSummaryInventoryBalanceAux.cod-refer.
                                         
                    IF de-qtd-atender = 0 THEN
                        LEAVE.
                END.

                /*Se nao conseguiu atender totalmente a requisicao verifica se o item aceita saldo negativo e soma o saldo no ultimo deposito
                  que ocorreu atendimento */
                IF de-qtd-atender > 0 AND l-perm-sald-neg THEN DO: 
                    FIND FIRST ttSummaryInventoryBalanceAux 
                         WHERE ttSummaryInventoryBalanceAux.cod-depos   = TRIM(ENTRY(1,c-chave, "|"))
                           AND ttSummaryInventoryBalanceAux.cod-localiz = TRIM(ENTRY(2,c-chave, "|"))
                           AND ttSummaryInventoryBalanceAux.lote        = TRIM(ENTRY(3,c-chave, "|"))
                           AND ttSummaryInventoryBalanceAux.cod-refer   = TRIM(ENTRY(4,c-chave, "|")) NO-ERROR.
                    IF AVAILABLE ttSummaryInventoryBalanceAux THEN                
                        ASSIGN ttSummaryInventoryBalanceAux.qt-a-atender = ttSummaryInventoryBalanceAux.qt-a-atender + de-qtd-atender
                               de-qtd-atender = 0.
                END.

                /*Item n’o possui saldo suficiente em estoque*/
                IF NOT CAN-FIND(FIRST RowErrors) AND de-qtd-atender > 0 THEN
                    RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, 
                                                          INPUT 58078, 
                                                          INPUT bfit-requisicao.it-codigo + "~~"
                                                                + string(bfit-requisicao.nr-requisicao) + "~~"
                                                                + string(bfit-requisicao.sequencia)
                                                          ). /* Item sem saldo disponivel para atender requisicao  */


            END.
            
        END. 
        
        IF NOT CAN-FIND(FIRST RowErrors WHERE ErrorSubType = "ERROR") THEN DO:
            FOR EACH ttSummaryInventoryBalanceAux WHERE ttSummaryInventoryBalanceAux.qt-a-atender > 0:
                EMPTY TEMP-TABLE ttSummaryInventoryBalance.
                CREATE ttSummaryInventoryBalance.
                BUFFER-COPY ttSummaryInventoryBalanceAux TO ttSummaryInventoryBalance.
                
                IF ttSummaryInventoryBalance.is-wms-saas THEN DO:
                    RUN pi-cria-atend-wms-saas IN THIS-PROCEDURE (INPUT TABLE ttSummaryInventoryBalance, OUTPUT TABLE RowErrors).
                END.
                ELSE DO:
                    RUN processItemRequest IN THIS-PROCEDURE (INPUT TABLE ttSummaryInventoryBalance, 
                                                              INPUT ttSummaryInventoryBalanceAux.nr-requisicao, 
                                                              INPUT ttSummaryInventoryBalanceAux.sequencia, 
                                                              OUTPUT TABLE RowErrors).  
                END.
                
                IF CAN-FIND(first RowErrors WHERE ErrorSubType = "ERROR") THEN LEAVE.
            END.
        END.


        /*Cria mensagem de requisicao atendida com sucesso*/
        FIND FIRST rowErrors NO-LOCK NO-ERROR.
        IF NOT AVAIL rowErrors THEN DO:
            
            {utp/ut-liter.i "Atendimento_realizado_com_sucesso" *}

            CREATE RowErrors.
            ASSIGN RowErrors.ErrorNumber     = 32388
                   RowErrors.ErrorDescription = TRIM(RETURN-VALUE).
            
        END.        
        
    END.

    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processItemRequest DBOFunction
PROCEDURE processItemRequest:
/*------------------------------------------------------------------------------
  Purpose: Efetuar o atendimento da requisicao
  Parameters:  temp-table com os dados de atendimento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR ttSummaryInventoryBalance.
    DEFINE INPUT PARAMETER p-nr-requisicao AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-sequencia     AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
      
    def var de-quant-tot like ttSummaryInventoryBalance.qt-a-atender no-undo.
    def var l-possui-qt-aloc-prod AS logical INIT NO NO-UNDO.
    def var lcontrol              AS logical INIT NO NO-UNDO.
    def var l-ordem-mi            as logical INIT NO no-undo.
    def var i-seq                 AS INTEGER INIT 0  NO-UNDO.
    def var de-qtidade            as decimal         no-undo.
    def var de-fracao-val-quantidade   as decimal no-undo.
    def var de-saldo                   as decimal no-undo.
    def var de-qt-a-atender-orig  like it-requisicao.qt-a-atender  no-undo.
    def var de-qt-reserva-mi      like it-requisicao.qt-a-atender  no-undo.
    def var d-aloc-prod-ant       like it-requisicao.qt-a-atender  no-undo.
    def var d-qtde-atender        like it-requisicao.qt-a-atender  no-undo.
    
    def var iempresa              like empresa.ep-codigo           no-undo.
    
    DEFINE VARIABLE rw-it-requisicao AS ROWID   NO-UNDO.
    DEFINE VARIABLE h-in2108         AS HANDLE  NO-UNDO.
    DEFINE VARIABLE h-ceapi001k      AS HANDLE  NO-UNDO.
    DEFINE VARIABLE hBoSincroniz     AS HANDLE  NO-UNDO.

    empty temp-table tt-movto.
    empty temp-table tt-item-wms.
    
    &IF '{&bf_mat_versao_ems}':U >= '2.05':U &THEN
          assign lControl = yes.
    &else
        &IF '{&bf_mat_versao_ems}':U >= '2.04':U &THEN
          if can-find(first funcao
                      where funcao.cd-funcao = "spp-int-req-om":U
                      and   funcao.ativo     = true NO-LOCK) then do:
             assign lControl = yes.
          end.
        &ENDIF
    &ENDIF

    &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
        /* Carrega a variÿvel global v_log_eai2_ativado */
        RUN cdp/cd0101i.p. 
        /* Dispatch standard ADM method.                             */
    &ENDIF    
    
    IF NOT AVAIL param-estoq THEN
        FIND FIRST param-estoq NO-LOCK NO-ERROR.

    find first it-requisicao exclusive-lock 
         where it-requisicao.nr-requisicao = p-nr-requisicao
           and it-requisicao.sequencia     = p-sequencia no-wait no-error.
           
    /* Requisicao pendente aprovacao */       
    IF it-requisicao.estado = 2 THEN DO:
        RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 15921, INPUT "").
        return 'NOK':U.
    END.

    if locked(it-requisicao) then do:
        {utp/ut-table.i movind it-requisicao 1}
        RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 27837, INPUT "").    
    end.
    
    ASSIGN de-qt-a-atender-orig = it-requisicao.qt-a-atender.
    
    // se tiver ordem vai criar movimento igual ao CE0205
    IF it-requisicao.nr-ord-produ <> 0 THEN DO:
        RUN createRequisitionCE0205(INPUT TABLE ttSummaryInventoryBalance, 
                                    INPUT p-nr-requisicao, 
                                    INPUT p-sequencia).
        RETURN.
    END.  
    
    do  on error  undo, return error
        on stop   undo, return error
        on quit   undo, return error
        on endkey undo, return error:
        
        empty temp-table tt-matriz.

        for first it-requisicao no-lock
            where it-requisicao.nr-requisicao = p-nr-requisicao
              and it-requisicao.sequencia     = p-sequencia. end.
              
        for first requisicao no-lock
            where requisicao.nr-requisicao = p-nr-requisicao. end. 
            
        FOR FIRST item FIELDS(tipo-con-est perm-saldo-neg fraciona tipo-contr un) 
              WHERE item.it-codigo = it-requisicao.it-codigo: 
        END.

        assign i-seq = i-seq + 1
               de-qtidade = 0.

        for first req-ord-produc no-lock
            where req-ord-produc.nr-requisicao    =  p-nr-requisicao
              and req-ord-produc.sequencia        =  p-sequencia,
            first ord-prod no-lock
            where ord-prod.nr-ord-produ = req-ord-produc.nr-ord-produ. end.
            
        IF AVAIL req-ord-produc AND AVAIL ord-prod AND ord-prod.origem = "MI" THEN 
            ASSIGN l-ordem-mi = YES.
                      
        &if '{&bf_mat_versao_ems}' >= '2.062' &then
            if l-unidade-negocio and it-requisicao.num-ord-inv <> 0 then do:
               if not (avail ord-prod and ord-prod.origem = "MI") then do:
                   IF NOT AVAIL param-global THEN
                      find first param-global no-lock no-error.
                   assign iEmpresa = param-global.empresa-prin.
                   if not avail estabelec or (avail estabelec and estabelec.cod-estabel <> requisicao.cod-estabel) then 
                      for first estabelec fields (cod-estabel ep-codigo) 
                          where estabelec.cod-estabel = requisicao.cod-estabel no-lock: 
                      end.
                   if avail estabelec and estabelec.ep-codigo <> &if "{&mguni_version}" >= "2.071" &then "" &else 0 &endif then
                      assign iEmpresa = estabelec.ep-codigo.
        
                   run ivbo/boiv029.p persistent set h-boiv029.
                   run recebeEmpresa in h-boiv029 (input iempresa).
                   run retornaMatrizUnidNegoc in h-boiv029 (input it-requisicao.num-ord-inv,
                                                            output table tt-matriz,
                                                            output table tt-erro-inv).
                   delete procedure h-boiv029.
               end.
            end.     
            if item.fraciona              = no  and 
               item.tipo-contr           <> 4   and  
               l-unidade-negocio          = yes and 
               it-requisicao.num-ord-inv <> 0   and 
               can-find(first tt-matriz)        then do:
                for each tt-matriz:
                    create tt-movto-un.
                    assign tt-movto-un.i-sequen      = i-seq
                           tt-movto-un.cod-unid-neg  = tt-matriz.cod-unid-neg
                           tt-movto-un.perc-unid-neg = tt-matriz.perc-rateio.
                end.                                        
                for each tt-matriz:
                    delete tt-matriz.
                end.
            end.
        &endif     

        rateio:
        do:
            &if '{&bf_mat_versao_ems}' >= '2.062' &then
                if l-unidade-negocio               and
                   it-requisicao.num-ord-inv <> 0  AND
                   not can-find(first tt-movto-un) then do:

                    if (avail ord-prod 
                          and ord-prod.origem = "MI") then do:
                        create tt-matriz.
                        assign tt-matriz.cod-unid-neg = it-requisicao.cod-unid-negoc
                               tt-matriz.perc-rateio  = 100.
                        leave rateio.
                    end.

                    if can-find(first tt-erro-inv no-lock) then do:
                        FOR EACH tt-erro-inv :
                          RUN createRowErrors IN THIS-PROCEDURE(INPUT 2, INPUT tt-erro-inv.cd-erro, INPUT tt-erro-inv.mensagem).  
                        END.
                        return 'NOK':U.
                    end.

                end.
                else do:
                    create tt-matriz.
                    assign tt-matriz.cod-unid-neg = it-requisicao.cod-unid-negoc
                           tt-matriz.perc-rateio  = 100.
                end.
            &else
                create tt-matriz.
                assign tt-matriz.cod-unid-neg = ""
                       tt-matriz.perc-rateio  = 100.
            &endif
        end.   

        RUN getDefaultRequester (OUTPUT cNomeAbrev).

        for each  ttSummaryInventoryBalance
            where ttSummaryInventoryBalance.qt-a-atender > 0:  
            
            IF NOT CAN-FIND(FIRST usuar-depos
                            WHERE usuar-depos.cod-depos   = ttSummaryInventoryBalance.cod-depos
                              AND usuar-depos.cod-estabel = it-requisicao.cod-estabel
                              AND usuar-depos.cod-usuario = cNomeAbrev
                              AND usuar-depos.dat-val-fim >= TODAY) THEN DO:

                RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 55258, INPUT ""). /* Usuÿrio n’o possui permiss’o para atendimento */
                RETURN "NOK".
            END.
            
            ASSIGN l-possui-qt-aloc-prod = NO
                   de-qt-reserva-mi      = 0.
            
            FOR FIRST saldo-estoq FIELDS(cod-depos cod-estabel cod-localiz lote it-codigo cod-refer qt-aloc-prod) WHERE
                saldo-estoq.cod-depos   = ttSummaryInventoryBalance.cod-depos   AND
                saldo-estoq.cod-estabel = it-requisicao.cod-estabel             AND
                saldo-estoq.cod-localiz = ttSummaryInventoryBalance.cod-localiz AND
                saldo-estoq.lote        = ttSummaryInventoryBalance.lote        AND
                saldo-estoq.it-codigo   = it-requisicao.it-codigo               AND
                saldo-estoq.cod-refer   = ttSummaryInventoryBalance.cod-refer no-lock: END.
   
            FIND FIRST reservas
                 WHERE reservas.nr-ord-produ = req-ord-produc.nr-ord-produ
                 AND   reservas.it-codigo    = it-requisicao.it-codigo NO-LOCK NO-ERROR.               
                 
            IF AVAIL saldo-estoq AND AVAIL reservas AND l-ordem-mi THEN DO:
                IF reservas.quant-aloc <> 0 AND saldo-estoq.qt-aloc-prod > 0 THEN
                    ASSIGN l-possui-qt-aloc-prod = YES
                           de-qt-reserva-mi      = reservas.quant-aloc.            
            
            END.

            
            FIND FIRST deposito WHERE
                deposito.cod-depos = ttSummaryInventoryBalance.cod-depos NO-LOCK NO-ERROR.

            IF AVAIL deposito THEN DO:

                /* se deposito eh de WMS */
                IF deposito.log-gera-wms THEN DO:
                    IF NOT CONNECTED('mgscm') OR param-estoq.int-1 <> 1 THEN DO:
                        RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 27607, INPUT ttSummaryInventoryBalance.cod-depos).
                        LEAVE.
                    END.
                
                    FIND FIRST tt-item-wms NO-LOCK
                         WHERE tt-item-wms.cod-estabel  = it-requisicao.cod-estabel
                           AND tt-item-wms.cod-depos    = ttSummaryInventoryBalance.cod-depos  
                           AND tt-item-wms.cod-item     = it-requisicao.it-codigo   
                           AND tt-item-wms.cod-refer    = ttSummaryInventoryBalance.cod-refer  
                           AND tt-item-wms.cod-lote     = ttSummaryInventoryBalance.lote NO-ERROR.

                    IF NOT AVAIL tt-item-wms THEN DO:
                        CREATE tt-item-wms.
                        ASSIGN tt-item-wms.cod-estabel  = it-requisicao.cod-estabel
                               tt-item-wms.cod-depos    = ttSummaryInventoryBalance.cod-depos
                               tt-item-wms.cod-item     = it-requisicao.it-codigo
                               tt-item-wms.cod-refer    = ttSummaryInventoryBalance.cod-refer
                               tt-item-wms.cod-lote     = ttSummaryInventoryBalance.lote
                               tt-item-wms.num-seq-orig = it-requisicao.sequencia
                               tt-item-wms.qtd-item     = 0.
                    END.

                    ASSIGN tt-item-wms.qtd-item = tt-item-wms.qtd-item + ttSummaryInventoryBalance.qt-a-atender
                           de-qtidade = de-qtidade + ttSummaryInventoryBalance.qt-a-atender.
                    LEAVE.
                           
                END.
            END.

            ASSIGN de-fracao-val-quantidade = 0.
            
            FOR EACH tt-matriz:

                create tt-movto.
                assign tt-movto.cod-depos      = ttSummaryInventoryBalance.cod-depos
                       tt-movto.cod-emitente   = 0
                       tt-movto.cod-estabel    = it-requisicao.cod-estabel
                       tt-movto.cod-refer      = ttSummaryInventoryBalance.cod-refer
                       tt-movto.ct-codigo      = it-requisicao.ct-codigo
                       tt-movto.descricao-db   = it-requisicao.narrativa
                       tt-movto.dt-nf-saida    = ?
                       tt-movto.dt-trans       = ttSummaryInventoryBalance.dt-trans
                       tt-movto.esp-docto      = 30
                       tt-movto.i-sequen       = i-seq
                       tt-movto.it-codigo      = it-requisicao.it-codigo
                       tt-movto.cod-localiz    = ttSummaryInventoryBalance.cod-localiz
                       tt-movto.lote           = ttSummaryInventoryBalance.lote
                       tt-movto.nat-operacao   = ""
                       tt-movto.nro-docto      = &if '{&bf_mat_versao_ems}' >= '2.04' &then 
                                                     string(it-requisicao.nr-requisicao,"999,999,999")
                                                 &else
                                                     string(it-requisicao.nr-requisicao,"999,999")
                                                 &endif
                       tt-movto.num-sequen     = it-requisicao.sequencia
                       tt-movto.sequen-nf      = it-requisicao.sequencia
                       tt-movto.numero-ordem   = 0
                       tt-movto.peso-liquido   = 0
                       tt-movto.quantidade     = ttSummaryInventoryBalance.qt-a-atender * tt-matriz.perc-rateio / 100
                       tt-movto.referencia     = ""
                       tt-movto.sc-codigo      = it-requisicao.sc-codigo
                       tt-movto.serie-docto    = ""
                       tt-movto.tipo-preco     = 0
                       tt-movto.tipo-trans     = 2
                       tt-movto.tipo-valor     = 2
                       tt-movto.un             = item.un
                       tt-movto.cod-prog-orig  = "atReqPOUI":U
                       tt-movto.usuario        = c-seg-usuario
                       tt-movto.cod-versao-integracao = 1
                       tt-movto.num-ord-inv    = it-requisicao.num-ord-inv.

                &if '{&bf_mat_versao_ems}' >= '2.062' &then
                 IF  l-unidade-negocio THEN DO:
                     IF it-requisicao.num-ord-inv <> 0 AND NOT item.fraciona THEN DO:
                         ASSIGN de-fracao-val-quantidade = de-fracao-val-quantidade + (tt-movto.quantidade - TRUNC(tt-movto.quantidade,0))
                                tt-movto.quantidade = TRUNC(tt-movto.quantidade,0).
    
                         FIND FIRST tt-movto-un NO-LOCK NO-ERROR.
                         IF AVAIL tt-movto-un AND tt-movto-un.perc-unid-neg = 100 /*100%*/ THEN DO:
                             ASSIGN tt-movto.cod-unid-negoc = tt-movto-un.cod-unid-neg.
                             DELETE tt-movto-un.
                         END.
                         ELSE DO:
                             IF AVAIL tt-movto-un THEN
                                 ASSIGN tt-movto.cod-unid-negoc = tt-movto-un.cod-unid-neg.
                             ELSE
                                 ASSIGN tt-movto.cod-unid-negoc = tt-matriz.cod-unid-neg.
                         END.
                     END.
                     ELSE
                         ASSIGN tt-movto.cod-unid-negoc = tt-matriz.cod-unid-neg.
                 END.
                 ELSE
                     ASSIGN tt-movto.cod-unid-negoc = it-requisicao.cod-unid-negoc.
                     
                &endif
                 ASSIGN de-quant-tot = de-quant-tot + tt-movto.quantidade.
            END.

            assign de-qtidade = de-qtidade + ttSummaryInventoryBalance.qt-a-atender.
            
            IF  de-fracao-val-quantidade <> 0 THEN
                ASSIGN tt-movto.quantidade = tt-movto.quantidade + de-fracao-val-quantidade.

          &if '{&bf_mat_versao_ems}' >= '2.062' &then  
            /*Acerto de Residuo Rateio por Unidade de Negocio*/
            IF  l-unidade-negocio AND it-requisicao.num-ord-inv <> 0 and can-find(first tt-matriz
                                                                                  where tt-matriz.perc-rateio  <> 100) THEN DO:
               IF ttSummaryInventoryBalance.qt-a-atender <> de-quant-tot THEN
                     ASSIGN tt-movto.quantidade = tt-movto.quantidade + (ttSummaryInventoryBalance.qt-a-atender - de-quant-tot).                
            END.
          &ENDIF
          
        END.  //end foreach ttSummaryInventoryBalance  
        
        FIND FIRST ttSummaryInventoryBalance NO-ERROR.
        
        find it-requisicao
            where it-requisicao.nr-requisicao = p-nr-requisicao
            and   it-requisicao.sequencia     = p-sequencia
        NO-LOCK no-error no-wait.
        
        /* Valida se foi realizado outro atendimento ou se foi alterada a 
           quantidade do item da requisicao */
        IF (it-requisicao.qt-a-atender < de-qt-a-atender-orig ) THEN DO:
            RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 27978, INPUT "").
            for each tt-movto:
                delete tt-movto.
            end.
            &if '{&bf_mat_versao_ems}' >= '2.062' &then
            for each tt-movto-un:
                delete tt-movto-un.
            end.
            &endif
            RETURN "NOK".
        END.
     
        IF CAN-FIND(FIRST tt-item-wms) THEN DO:
            RUN cep/ceapi032.p (INPUT it-requisicao.nr-requisicao,
                                INPUT TABLE tt-item-wms,
                                OUTPUT TABLE RowErrors).
    
            IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                 RETURN "NOK":U.
            END.
    
            FIND CURRENT it-requisicao EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL it-requisicao THEN DO:
                ASSIGN OVERLAY(it-requisicao.char-1,15,1) = "Y":U.
                FIND CURRENT it-requisicao NO-LOCK NO-ERROR.
            END.
        END.

        blocoa:
        DO  TRANSACTION:
            IF can-find(FIRST tt-movto) THEN DO:
                run cep/ceapi001k.p persistent set h-ceapi001k.
    
                run pi-valida-movto-uneg in h-ceapi001k (input table tt-movto-un).

                IF l-possui-qt-aloc-prod THEN DO:
                    FOR FIRST saldo-estoq FIELDS(cod-depos cod-estabel cod-localiz lote it-codigo cod-refer qt-aloc-prod) WHERE
                        saldo-estoq.cod-depos   = ttSummaryInventoryBalance.cod-depos   AND
                        saldo-estoq.cod-estabel = it-requisicao.cod-estabel             AND
                        saldo-estoq.cod-localiz = ttSummaryInventoryBalance.cod-localiz AND
                        saldo-estoq.lote        = ttSummaryInventoryBalance.lote        AND
                        saldo-estoq.it-codigo   = it-requisicao.it-codigo               AND
                        saldo-estoq.cod-refer   = ttSummaryInventoryBalance.cod-refer EXCLUSIVE-LOCK: END.
                    IF AVAIL saldo-estoq AND saldo-estoq.qt-aloc-prod > 0 THEN DO:
                        ASSIGN d-aloc-prod-ant = saldo-estoq.qt-aloc-prod.
        
                        IF ttSummaryInventoryBalance.qt-a-atender >= de-qt-reserva-mi THEN 
                            ASSIGN saldo-estoq.qt-aloc-prod = saldo-estoq.qt-aloc-prod - de-qt-reserva-mi.
                        ELSE
                            ASSIGN saldo-estoq.qt-aloc-prod = saldo-estoq.qt-aloc-prod - ttSummaryInventoryBalance.qt-a-atender. 
                    END.
                END.
    
                run pi-execute in h-ceapi001k (input-output table tt-movto,
                                               input-output table tt-erro-ceapi001k,
                                               input yes).
                delete procedure h-ceapi001k.

                IF CAN-FIND(FIRST tt-erro-ceapi001k) THEN UNDO blocoa, LEAVE blocoa.
    
            END.
        END.

        if  can-find(first tt-erro-ceapi001k) then do:
            FOR EACH tt-erro-ceapi001k:
              RUN createRowErrors IN THIS-PROCEDURE(INPUT 2, INPUT tt-erro-ceapi001k.cd-erro, INPUT tt-erro-ceapi001k.mensagem).      
            END.
            return "NOK".
        end.
        else do:
             if return-value = "nok":U then
                 return "NOK".

             IF NOT AVAIL param-global THEN
                 find first param-global no-lock no-error.
             
             if  param-global.modulo-in     = yes and
                 it-requisicao.num-ord-inv <> 0   AND 
                 de-qtidade                <> 0   then do:
                
                IF NOT VALID-HANDLE(h-in2108) THEN
                    RUN inp/in2108.p PERSISTENT SET h-in2108. 
                    
                IF VALID-HANDLE(h-in2108) THEN DO:
                    for each tt-movto:
                        assign i-emp-inv  = it-requisicao.ep-codigo
                               i-ord-inv  = it-requisicao.num-ord-inv
                               r-mov-inv  = tt-movto.r-mov-inv.
                        RUN pi-execute IN h-in2108.
                    end.                
                END.
                   
                IF RETURN-VALUE = "NOK":U THEN DO:
                   RUN getRowErrors IN h-in2108(OUTPUT TABLE RowErrors).
                   UNDO, return "NOK".
                END.
                
                DELETE PROCEDURE h-in2108. 
                
            end.

            find requisicao
                where requisicao.nr-requisicao = p-nr-requisicao exclusive-lock no-error.
            find current it-requisicao exclusive-lock.
            assign requisicao.dt-atend         = ttSummaryInventoryBalance.dt-trans
                   it-requisicao.qt-atendida   = it-requisicao.qt-atendida   + de-qtidade
                   it-requisicao.qt-a-atender  = it-requisicao.qt-a-atender  - de-qtidade
                   it-requisicao.qt-a-devolver = it-requisicao.qt-a-devolver + de-qtidade 
                   it-requisicao.dt-atend      = ttSummaryInventoryBalance.dt-trans.
                   
            if  it-requisicao.qt-devolvida > 0 then do:
                assign it-requisicao.qt-devolvida = it-requisicao.qt-devolvida - de-qtidade.
                if  it-requisicao.qt-devolvida < 0 then
                    assign it-requisicao.qt-devolvida = 0.
            end.

            ASSIGN rw-it-requisicao = ROWID(it-requisicao).
            
            IF l-orig-api-WMS-SAAS = NO THEN DO:
                if  it-requisicao.qt-a-atender = 0 then do:
                    assign it-requisicao.situacao = 2.
                    find first bfit-requisicao
                        where bfit-requisicao.nr-requisicao = p-nr-requisicao
                        and   bfit-requisicao.situacao      = 1
                        no-lock no-error.
                    if  not avail bfit-requisicao then do:
                        assign requisicao.situacao = 2.
                    end.
                    else do:
                        assign de-saldo        = bfit-requisicao.qt-a-atender
                               d-qtde-atender  = bfit-requisicao.qt-a-atender.
                    end.
                end.
            END.
            ELSE DO:
                ASSIGN i-atend-em-processo = 0.
                FOR EACH ws-atend-devol-it-requis NO-LOCK
                WHERE ws-atend-devol-it-requis.nr-requisicao  = it-requisicao.nr-requisicao
                    AND ws-atend-devol-it-requis.seq-it-requis  = it-requisicao.sequencia
                    AND ws-atend-devol-it-requis.it-codigo      = it-requisicao.it-codigo
                    AND ws-atend-devol-it-requis.idi-tipo-movto = 1 // 1-Atendimento
                    AND (ws-atend-devol-it-requis.idi-sit-docto = 1 OR ws-atend-devol-it-requis.idi-sit-docto = 2)
                    BY ws-atend-devol-it-requis.seq-atend-devol.
                    ASSIGN i-atend-em-processo = i-atend-em-processo + 1.
                END.

                IF  l-fim-req-WMS-SAAS
                AND i-atend-em-processo < 2
                AND it-requisicao.qt-atendida >= it-requisicao.qt-requisitada THEN DO:
                    ASSIGN it-requisicao.situacao     = 2 /* FECHADA */
                           it-requisicao.qt-a-atender = 0.
                END.
                IF it-requisicao.qt-a-atender < 0 THEN ASSIGN it-requisicao.qt-a-atender = 0.
                
                find first bfit-requisicao
                    where bfit-requisicao.nr-requisicao = p-nr-requisicao
                    and   bfit-requisicao.situacao      = 1
                    no-lock no-error.
                if  not avail bfit-requisicao then do:
                    assign requisicao.situacao = 2.
                end.                
                
            END.

            find requisicao
                where requisicao.nr-requisicao = p-nr-requisicao no-lock no-error.
            /********************************************************
            ** Baixa de Reservas das Ordens de Producao ~\ Manutencao, 
            ** conforme as requisicoes~\solicitacoes por Ordem (CD0738)
            *********************************************************/
            IF l-possui-qt-aloc-prod THEN DO:
                FOR FIRST saldo-estoq FIELDS(cod-depos cod-estabel cod-localiz lote it-codigo cod-refer qt-aloc-prod) WHERE
                    saldo-estoq.cod-depos   = ttSummaryInventoryBalance.cod-depos   AND
                    saldo-estoq.cod-estabel = it-requisicao.cod-estabel             AND
                    saldo-estoq.cod-localiz = ttSummaryInventoryBalance.cod-localiz AND
                    saldo-estoq.lote        = ttSummaryInventoryBalance.lote        AND
                    saldo-estoq.it-codigo   = it-requisicao.it-codigo               AND
                    saldo-estoq.cod-refer   = ttSummaryInventoryBalance.cod-refer EXCLUSIVE-LOCK: END.
    
                IF AVAIL saldo-estoq THEN 
                    ASSIGN saldo-estoq.qt-aloc-prod = d-aloc-prod-ant.
            END.

            &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
                for each tt-movto:
                    assign r-mov-inv = tt-movto.r-mov-inv.
                    if lControl then do:
                        run cdp/cd0742d.p (input rw-it-requisicao, /*rowid(it-requisicao),  /** it-requisicao **/*/
                                           input "msg":U,
                                           input r-mov-inv).            /** movto-estoq   **/
                    end.
                end.
            &ENDIF
        end.

        if avail requisicao then do:
        
            IF de-qtidade = 0 THEN DO:
                release it-requisicao.
                return "NOK".
            END.
            
                
            &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
                IF v_log_eai2_ativado THEN 
                DO:                                           
                    /* Integracao EMS EAI2.0 AppointmentCost */                                        
                    IF NOT VALID-HANDLE(h-ceapi310) OR
                       h-ceapi310:TYPE <> "PROCEDURE":U OR
                       h-ceapi310:FILE-NAME <> "cep/ceapi310.p":U THEN DO:
                       RUN cep/ceapi310.p PERSISTENT SET h-ceapi310.
                    END. 
                                             
                    RUN pi-sendUpsert IN h-ceapi310 (BUFFER it-requisicao, INPUT ttSummaryInventoryBalance.dt-trans, INPUT de-qtidade, OUTPUT TABLE RowErrors).      
                      
                    IF VALID-HANDLE(h-ceapi310) AND
                       h-ceapi310:TYPE = "PROCEDURE":U AND
                       h-ceapi310:FILE-NAME = "cep/ceapi310.p":U THEN DO:
                       DELETE PROCEDURE h-ceapi310 NO-ERROR.
                       ASSIGN h-ceapi310 = ?.
                    END.
    
                    IF CAN-FIND(FIRST RowErrors) THEN DO:
                       UNDO, RETURN "NOK".
                    END.
                END.
            &ENDIF    

            RUN mnbo/bomni00307.p PERSISTENT SET hBoSincroniz.
            RUN adicionarSincroniz IN hBoSincroniz (INPUT "req-ord-produ":U,
                                                    INPUT STRING(requisicao.nr-requisicao) + ";" + STRING(it-requisicao.sequencia),
                                                    INPUT 2, /* Update */
                                                    INPUT c-seg-usuario).

            FIND FIRST req-ord-produc
                WHERE req-ord-produc.nr-requisicao = requisicao.nr-requisicao
                AND   req-ord-produc.sequencia     = it-requisicao.sequencia NO-LOCK NO-ERROR.

            IF AVAIL req-ord-produc THEN DO:

                RUN mnbo/bomni00307.p PERSISTENT SET hBoSincroniz.
                RUN adicionarSincroniz IN hBoSincroniz (INPUT "ord-manut":U,
                                                    INPUT STRING(req-ord-produc.nr-ord-produ),
                                                    INPUT 2, /* Update */
                                                    INPUT c-seg-usuario).
            END.

            IF VALID-HANDLE (hBoSincroniz) THEN
                DELETE OBJECT hBoSincroniz.

        end.
        
     END.     

    release it-requisicao.        
  
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getItemBalance DBOFunction 
PROCEDURE getItemBalance:
/*------------------------------------------------------------------------------
  Purpose:Retornar Saldo em Estoque
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT  PARAMETER pr-rowid    AS ROWID   NO-UNDO.
    DEFINE INPUT  PARAMETER pl-grouplot AS LOGICAL NO-UNDO.    
    DEFINE OUTPUT PARAMETER TABLE FOR ttSummaryInventoryBalance.
    
    DEFINE VARIABLE de-qtidade-saldo  LIKE saldo-estoq.qtidade-atu NO-UNDO.
    DEFINE VARIABLE c-log-process-wms AS   CHARACTER               NO-UNDO.
    DEFINE VARIABLE l-ordem-mi        AS   LOGICAL    INIT NO      NO-UNDO.
    
  &if '{&bf_lote_avancado_liberado}' >= 'yes' &then
    DEFINE VARIABLE l-lote-avancado AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-retorno       AS LOGICAL NO-UNDO.
    DEFINE VARIABLE h-ceapi030      AS HANDLE  NO-UNDO.
    
    IF CAN-FIND(FIRST funcao 
                WHERE funcao.cd-funcao = 'lote-avancado':U
                  AND funcao.ativo) then do:
                  
        ASSIGN l-lote-avancado = YES.

        IF NOT VALID-HANDLE(h-ceapi030) THEN
            RUN cep/ceapi030.p PERSISTENT SET h-ceapi030 (INPUT TABLE tt-dados-fda,
                                                          OUTPUT TABLE tt-valores,
                                                          OUTPUT TABLE tt-erro).
    END.
  &endif

    EMPTY TEMP-TABLE ttSummaryInventoryBalance NO-ERROR.
    
    userCodeBlock:
    DO ON ERROR UNDO, LEAVE userCodeBlock
       ON STOP  UNDO, LEAVE userCodeBlock
       ON QUIT  UNDO, LEAVE userCodeBlock:

        FOR FIRST bfit-requisicao FIELDS(it-codigo cod-estabel char-1 nr-requisicao sequencia cod-refer) NO-LOCK
            WHERE ROWID(bfit-requisicao) = pr-rowid: END.
            
        IF NOT AVAIL bfit-requisicao THEN RETURN "NOK":U.
    
        FOR FIRST item FIELDS(tipo-con-est ) NO-LOCK
            WHERE item.it-codigo = bfit-requisicao.it-codigo: END.
    
        FOR FIRST item-uni-estab FIELDS(perm-saldo-neg) NO-LOCK
            WHERE item-uni-estab.it-codigo   = bfit-requisicao.it-codigo 
              AND item-uni-estab.cod-estabel = bfit-requisicao.cod-estabel: END.
              
        IF AVAIL item-uni-estab THEN DO:
    
            IF item-uni-estab.perm-saldo-neg = 1 THEN DO: /* NAO PERMITE SALDO NEGATIVO */
            
                FOR EACH saldo-estoq FIELDS(cod-depos    it-codigo cod-estabel lote dt-vali-lote 
                                            qtidade-atu  qt-alocada qt-aloc-ped qt-aloc-prod 
                                            cod-localiz  cod-refer) NO-LOCK
                   WHERE saldo-estoq.it-codigo   = bfit-requisicao.it-codigo         
                     AND saldo-estoq.cod-estabel = bfit-requisicao.cod-estabel,     
                   FIRST deposito NO-LOCK                                        
                   WHERE deposito.cod-depos = saldo-estoq.cod-depos
                     AND deposito.ind-dep-cq = NO:

                    IF deposito.log-wms-externo THEN DO:
                        FIND FIRST ttSummaryInventoryBalance 
                          WHERE ttSummaryInventoryBalance.cod-depos   = saldo-estoq.cod-depos
                            AND ttSummaryInventoryBalance.cod-refer   = saldo-estoq.cod-refer
                            AND ttSummaryInventoryBalance.is-wms-saas = YES NO-ERROR.
                      
                        ASSIGN de-qtidade-saldo = saldo-estoq.qtidade-atu - 
                                                 (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-ped + saldo-estoq.qt-aloc-prod).
                      
                        //IF de-qtidade-saldo <= 0 THEN NEXT.
                      
                        IF NOT AVAILABLE ttSummaryInventoryBalance THEN DO:
                            RUN criaTTSummaryInventoryBalance IN THIS-PROCEDURE(INPUT bfit-requisicao.nr-requisicao, 
                                                                                INPUT bfit-requisicao.sequencia,
                                                                                INPUT saldo-estoq.cod-depos, 
                                                                                INPUT "", 
                                                                                INPUT "", 
                                                                                INPUT ?,
                                                                                INPUT saldo-estoq.cod-refer, 
                                                                                INPUT de-qtidade-saldo,
                                                                                INPUT 0, 
                                                                                INPUT "", 
                                                                                INPUT NO).
                            FIND LAST ttSummaryInventoryBalance NO-ERROR.
                            IF AVAILABLE ttSummaryInventoryBalance THEN
                                ASSIGN ttSummaryInventoryBalance.is-wms-saas = YES.
                        END.
                        ELSE DO:
                            ASSIGN ttSummaryInventoryBalance.qtidade-atu = ttSummaryInventoryBalance.qtidade-atu + de-qtidade-saldo.
                        END.
                        NEXT.
                    END.

                  &if '{&bf_lote_avancado_liberado}' >= 'yes' &then
                    ASSIGN l-retorno = YES.

                    IF  l-lote-avancado  
                    AND item.tipo-con-est > 2 THEN DO: /* Numero serie (i01in122.i) */
                    
                        RUN pi-identifica-saldo IN h-ceapi030 (INPUT 1,
                                                               INPUT saldo-estoq.it-codigo,
                                                               INPUT saldo-estoq.cod-estabel,
                                                               INPUT saldo-estoq.lote,
                                                               INPUT 0,
                                                               OUTPUT l-retorno,
                                                               OUTPUT TABLE tt-valores2,
                                                               OUTPUT TABLE tt-erro).
                    END.

                    IF NOT l-retorno THEN
                        ASSIGN de-qtidade-saldo = 0.
                    ELSE
                  &endif
                  
                     ASSIGN de-qtidade-saldo = saldo-estoq.qtidade-atu   - 
                                              (saldo-estoq.qt-alocada    +  
                                               saldo-estoq.qt-aloc-ped   +  
                                               saldo-estoq.qt-aloc-prod).
                         
                     ASSIGN l-ordem-mi = NO.

                     for first req-ord-produc no-lock
                         where req-ord-produc.nr-requisicao    =  bfit-requisicao.nr-requisicao
                           and req-ord-produc.sequencia        =  bfit-requisicao.sequencia,
                         first ord-prod no-lock
                         where ord-prod.nr-ord-produ = req-ord-produc.nr-ord-produ. end.

                     IF AVAIL req-ord-produc 
                          AND AVAIL ord-prod 
                          AND ord-prod.origem = "MI" 
                          AND saldo-estoq.qt-aloc-prod > 0 THEN 
                         ASSIGN l-ordem-mi = YES.

                     IF l-ordem-mi THEN DO:
                         FOR EACH req-ord-produc
                            WHERE req-ord-produc.nr-requisicao = bfit-requisicao.nr-requisicao
                              AND req-ord-produc.sequencia     = bfit-requisicao.sequencia NO-LOCK:

                             IF AVAIL req-ord-produc THEN DO:

                                 FIND FIRST reservas
                                      WHERE reservas.nr-ord-produ = req-ord-produc.nr-ord-produ
                                      AND   reservas.it-codigo    = bfit-requisicao.it-codigo NO-LOCK NO-ERROR.
    
                                 IF AVAIL reservas THEN DO:
    
                                     RUN criaTTSummaryInventoryBalance IN THIS-PROCEDURE(INPUT bfit-requisicao.nr-requisicao,
                                                                                         INPUT bfit-requisicao.sequencia,
                                                                                         INPUT saldo-estoq.cod-depos,
                                                                                         INPUT saldo-estoq.cod-localiz,
                                                                                         INPUT saldo-estoq.lote,
                                                                                         INPUT saldo-estoq.dt-vali-lote,
                                                                                         INPUT saldo-estoq.cod-refer,
                                                                                         INPUT reservas.quant-aloc + de-qtidade-saldo,
                                                                                         INPUT 0,
                                                                                         INPUT c-log-process-wms,
                                                                                         INPUT NO).
                                     FIND LAST ttSummaryInventoryBalance NO-ERROR.
                                     IF AVAILABLE ttSummaryInventoryBalance THEN ASSIGN ttSummaryInventoryBalance.is-wms-saas = NO.
                                 END.
                             END.
                         END.
                     END.
                     ELSE IF de-qtidade-saldo > 0 THEN DO:

                        ASSIGN c-log-process-wms = fnLogProcessWMS(SUBSTRING(bfit-requisicao.char-1,15,1)).
    
                        RUN criaTTSummaryInventoryBalance IN THIS-PROCEDURE(INPUT bfit-requisicao.nr-requisicao,
                                                                            INPUT bfit-requisicao.sequencia,
                                                                            INPUT saldo-estoq.cod-depos,
                                                                            INPUT saldo-estoq.cod-localiz,
                                                                            INPUT saldo-estoq.lote,
                                                                            INPUT saldo-estoq.dt-vali-lote,
                                                                            INPUT saldo-estoq.cod-refer,
                                                                            INPUT de-qtidade-saldo,
                                                                            INPUT 0,
                                                                            INPUT c-log-process-wms,
                                                                            INPUT NO).
                        FIND LAST ttSummaryInventoryBalance NO-ERROR.
                        IF AVAILABLE ttSummaryInventoryBalance THEN ASSIGN ttSummaryInventoryBalance.is-wms-saas = NO.
                    END.
                END.
            END.
            ELSE DO: /* PERMITE SALDO NEGATIVO */
                IF item.tipo-con-est = 4 THEN DO: /* Referencia (i01in122.i) */
     
                    FOR EACH saldo-estoq FIELDS(cod-depos    it-codigo   cod-estabel  lote qtidade-atu  
                                                qt-alocada   qt-aloc-ped qt-aloc-prod cod-localiz 
                                                dt-vali-lote cod-refer) NO-LOCK                   
                       WHERE saldo-estoq.it-codigo   = bfit-requisicao.it-codigo         
                         AND saldo-estoq.cod-estabel = bfit-requisicao.cod-estabel       
                         AND saldo-estoq.cod-refer   = bfit-requisicao.cod-refer,
                       FIRST deposito NO-LOCK
                       WHERE deposito.cod-depos = saldo-estoq.cod-depos
                         AND deposito.ind-dep-cq = NO: 

                        IF deposito.log-wms-externo THEN DO:
                            FIND FIRST ttSummaryInventoryBalance 
                              WHERE ttSummaryInventoryBalance.cod-depos   = saldo-estoq.cod-depos
                                AND ttSummaryInventoryBalance.cod-refer   = saldo-estoq.cod-refer
                                AND ttSummaryInventoryBalance.is-wms-saas = YES NO-ERROR.
                          
                            ASSIGN de-qtidade-saldo = saldo-estoq.qtidade-atu - 
                                                     (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-ped + saldo-estoq.qt-aloc-prod).
                          
                            IF NOT AVAILABLE ttSummaryInventoryBalance THEN DO:
                                RUN criaTTSummaryInventoryBalance IN THIS-PROCEDURE(INPUT bfit-requisicao.nr-requisicao, 
                                                                                    INPUT bfit-requisicao.sequencia,
                                                                                    INPUT saldo-estoq.cod-depos, 
                                                                                    INPUT "", 
                                                                                    INPUT "", 
                                                                                    INPUT ?,
                                                                                    INPUT saldo-estoq.cod-refer, 
                                                                                    INPUT de-qtidade-saldo,
                                                                                    INPUT 0, 
                                                                                    INPUT "", 
                                                                                    INPUT NO).
                            FIND LAST ttSummaryInventoryBalance NO-ERROR.
                            IF AVAILABLE ttSummaryInventoryBalance THEN
                                ASSIGN ttSummaryInventoryBalance.is-wms-saas = YES.
                            END.
                            ELSE DO:
                                ASSIGN ttSummaryInventoryBalance.qtidade-atu = ttSummaryInventoryBalance.qtidade-atu + de-qtidade-saldo.
                            END.
                            NEXT.
                        END.

                      &if '{&bf_lote_avancado_liberado}' >= 'yes' &then
                        ASSIGN l-retorno = YES.
                        
                        IF l-lote-avancado THEN DO:                           
                            RUN pi-identifica-saldo in h-ceapi030 (INPUT 1,
                                                                   INPUT saldo-estoq.it-codigo,
                                                                   INPUT saldo-estoq.cod-estabel,
                                                                   INPUT saldo-estoq.lote,
                                                                   INPUT 0,
                                                                   OUTPUT l-retorno,
                                                                   OUTPUT TABLE tt-valores2,
                                                                   OUTPUT TABLE tt-erro).
                        END.
    
                        IF NOT l-retorno THEN
                            ASSIGN de-qtidade-saldo = 0.
                        ELSE
                      &endif
                            ASSIGN de-qtidade-saldo = saldo-estoq.qtidade-atu - 
                                                     (saldo-estoq.qt-alocada +  
                                                      saldo-estoq.qt-aloc-ped +  
                                                      saldo-estoq.qt-aloc-prod).

                        ASSIGN c-log-process-wms = fnLogProcessWMS(SUBSTRING(bfit-requisicao.char-1,15,1)).
                        
                        RUN criaTTSummaryInventoryBalance IN THIS-PROCEDURE(INPUT bfit-requisicao.nr-requisicao,
                                                                            INPUT bfit-requisicao.sequencia,
                                                                            INPUT saldo-estoq.cod-depos,
                                                                            INPUT saldo-estoq.cod-localiz,
                                                                            INPUT saldo-estoq.lote,
                                                                            INPUT saldo-estoq.dt-vali-lote,
                                                                            INPUT saldo-estoq.cod-refer,
                                                                            INPUT de-qtidade-saldo,
                                                                            INPUT 0,
                                                                            INPUT c-log-process-wms,
                                                                            INPUT NO).
                        FIND LAST ttSummaryInventoryBalance NO-ERROR.
                        IF AVAILABLE ttSummaryInventoryBalance THEN ASSIGN ttSummaryInventoryBalance.is-wms-saas = NO.
                    END.
                END.            
                ELSE DO: /* ITEM NAO CONTROLADO POR REFERENCIA */
    
                    FOR EACH saldo-estoq FIELDS(cod-depos    it-codigo   cod-estabel  lote qtidade-atu  
                                                qt-alocada   qt-aloc-ped qt-aloc-prod cod-localiz 
                                                dt-vali-lote cod-refer) NO-LOCK
                       WHERE saldo-estoq.it-codigo   = bfit-requisicao.it-codigo
                         AND saldo-estoq.cod-estabel = bfit-requisicao.cod-estabel,
                       FIRST deposito NO-LOCK
                       WHERE deposito.cod-depos  = saldo-estoq.cod-depos
    	                AND deposito.ind-dep-cq = NO:
                        
                        IF deposito.log-wms-externo THEN DO:
                            FIND FIRST ttSummaryInventoryBalance 
                                WHERE ttSummaryInventoryBalance.cod-depos   = saldo-estoq.cod-depos
                                  AND ttSummaryInventoryBalance.cod-refer   = saldo-estoq.cod-refer
                                  AND ttSummaryInventoryBalance.is-wms-saas = YES NO-ERROR.
                            
                            ASSIGN de-qtidade-saldo = saldo-estoq.qtidade-atu - 
                                                     (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-ped + saldo-estoq.qt-aloc-prod).

                            IF NOT AVAILABLE ttSummaryInventoryBalance THEN DO:
                                RUN criaTTSummaryInventoryBalance IN THIS-PROCEDURE(INPUT bfit-requisicao.nr-requisicao, 
                                                                                    INPUT bfit-requisicao.sequencia,
                                                                                    INPUT saldo-estoq.cod-depos, 
                                                                                    INPUT "", 
                                                                                    INPUT "", 
                                                                                    INPUT ?,
                                                                                    INPUT saldo-estoq.cod-refer, 
                                                                                    INPUT de-qtidade-saldo,
                                                                                    INPUT 0, 
                                                                                    INPUT "", 
                                                                                    INPUT NO).
                                FIND LAST ttSummaryInventoryBalance NO-ERROR.
                                IF AVAILABLE ttSummaryInventoryBalance THEN
                                   ASSIGN ttSummaryInventoryBalance.is-wms-saas = YES.
                            END.
                            ELSE DO:
                                ASSIGN ttSummaryInventoryBalance.qtidade-atu = ttSummaryInventoryBalance.qtidade-atu + de-qtidade-saldo.
                            END.
                            NEXT.
                        END.

                      &if '{&bf_lote_avancado_liberado}' >= 'yes' &then
                        ASSIGN l-retorno = YES.
    
                        IF l-lote-avancado 
                        AND item.tipo-con-est = 3 THEN DO:  /* LOTE (i01in122.i) */
                           
                            RUN pi-identifica-saldo IN h-ceapi030 (INPUT 1,
                                                                   INPUT saldo-estoq.it-codigo,
                                                                   INPUT saldo-estoq.cod-estabel,
                                                                   INPUT saldo-estoq.lote,
                                                                   INPUT 0,
                                                                   OUTPUT l-retorno,
                                                                   OUTPUT TABLE tt-valores2,
                                                                   OUTPUT TABLE tt-erro).
    
                        END.
    
                        IF NOT l-retorno THEN
                            ASSIGN de-qtidade-saldo = 0.
                        ELSE
                      &endif
                            ASSIGN de-qtidade-saldo = saldo-estoq.qtidade-atu - 
                                                     (saldo-estoq.qt-alocada +  
                                                      saldo-estoq.qt-aloc-ped +  
                                                      saldo-estoq.qt-aloc-prod).
                                                      
                        ASSIGN c-log-process-wms = fnLogProcessWMS(SUBSTRING(bfit-requisicao.char-1,15,1)).
                        
                        RUN criaTTSummaryInventoryBalance IN THIS-PROCEDURE(INPUT bfit-requisicao.nr-requisicao,
                                                                            INPUT bfit-requisicao.sequencia,
                                                                            INPUT saldo-estoq.cod-depos,
                                                                            INPUT saldo-estoq.cod-localiz,
                                                                            INPUT saldo-estoq.lote,
                                                                            INPUT saldo-estoq.dt-vali-lote,
                                                                            INPUT saldo-estoq.cod-refer,
                                                                            INPUT de-qtidade-saldo,
                                                                            INPUT 0,
                                                                            INPUT c-log-process-wms,
                                                                            INPUT NO).
                        FIND LAST ttSummaryInventoryBalance NO-ERROR.
                        IF AVAILABLE ttSummaryInventoryBalance THEN ASSIGN ttSummaryInventoryBalance.is-wms-saas = NO.
                    END.
                END.
            END.
        END.
        
    END. 


    /* Agrupa Lotes WMS */
    IF pl-grouplot THEN    
        RUN groupLotWMS IN THIS-PROCEDURE(INPUT pl-grouplot, INPUT-OUTPUT TABLE ttSummaryInventoryBalance).

    FOR EACH ttSummaryInventoryBalance WHERE ttSummaryInventoryBalance.is-wms-saas = YES:
        IF ttSummaryInventoryBalance.qtidade-atu <= 0 THEN 
            DELETE ttSummaryInventoryBalance.
    END.

  &if '{&bf_lote_avancado_liberado}' >= 'yes' &then
    IF VALID-HANDLE(h-ceapi030) THEN DO:
      DELETE PROCEDURE h-ceapi030.
      ASSIGN h-ceapi030 = ?.
    END.
  &endif
    
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaQtdeAtender DBOFunction 
PROCEDURE validaQtdeAtender:
/*------------------------------------------------------------------------------
  Purpose:     Validar possibilidade de atendimento da requisicao
  Parameters:  Quantidade a Atender e temp-table com os saldos em estoque
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-qtd-atender AS DECIMAL NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttSummaryInventoryBalance.
        
    DEFINE VARIABLE de-qtde-total-disp AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-qtde-total-perm AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-qtde-venc-lote  AS DECIMAL     NO-UNDO.
    
    DEFINE VARIABLE l-item-contr-lote AS LOGICAL NO-UNDO.    
  
    ASSIGN l-item-contr-lote = AVAILABLE item AND item.tipo-con-est >= 3.
    
    IF p-qtd-atender > it-requisicao.qt-a-atender THEN DO:    
        RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 412, INPUT ""). /* Quantidade digitada maior que a requisitada (a atender). */                   
        RETURN "NOK":U.
    END.
    
    RUN retornaSaldosUsuarDepEstab IN THIS-PROCEDURE(INPUT it-requisicao.cod-estabel,
                                                     INPUT-OUTPUT TABLE ttSummaryInventoryBalance).
                                                     
    IF NOT CAN-FIND(FIRST ttSummaryInventoryBalance) THEN DO:
        /* Usu rio sem permissÆo em nenhum deposito */
        RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 55258, INPUT ""). /* Usu rio nÆo possui permissÆo para atendimento */
        RETURN "NOK".
    END.
    
    
    ASSIGN de-qtde-total-perm = fn-retorna-qtd-disponivel(TABLE ttSummaryInventoryBalance).
    
    IF l-item-contr-lote THEN
         ASSIGN de-qtde-venc-lote = fn-retorna-qtd-disponivel-lote(TABLE ttSummaryInventoryBalance).

    IF l-item-contr-lote THEN DO:           
        /* QUANTIDADE POR LOTE MENOR QUE A QUANTIDADE PERMITIDA */
        IF (de-qtde-venc-lote < de-qtde-total-perm) THEN DO:         
            /* QUANTIDADE POR LOTE  INSUFICIENTE MAS QUANTIDADE DISPONIVEL SUFICIENTE*/
            IF  NOT fn-qtd-suficiente-atendimento(de-qtde-venc-lote, p-qtd-atender)
            AND fn-qtd-suficiente-atendimento(de-qtde-total-perm, p-qtd-atender) THEN DO:              
            
                /*55257 - Sem saldo dispon¡vel em estoque para o usu rio. Saldo em estoque com data de validade......  */
                RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 55257, INPUT it-requisicao.it-codigo).  
                
                RETURN "NOK".
            END.
            
             /* QUANTIDADE POR LOTE INSUFICIENTE E QUANTIDADE DISPONIVEL INSUFICIENTE */
            IF  NOT fn-qtd-suficiente-atendimento(de-qtde-venc-lote, p-qtd-atender) 
            AND NOT fn-qtd-suficiente-atendimento(de-qtde-total-perm, p-qtd-atender) THEN DO:
            
                RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 55256, INPUT ""). /*Sem saldo dispon¡vel em estoque para o usu rio.   */
                RETURN "NOK":U.
            END.
        END.
        ELSE DO:
            /* VERIFICA SE A QUANTIDADE DISPONÖVEL  INSUFICIENTE PARA REALIZAR O ATENDIMENTO */
            IF NOT l-perm-sald-neg AND NOT fn-qtd-suficiente-atendimento(de-qtde-total-perm, p-qtd-atender) THEN DO: 
                RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 55256, INPUT ""). /*Sem saldo dispon¡vel em estoque para o usu rio.   */
                RETURN "NOK":U.
            END.
        END.
    END.
    ELSE DO:
        /* VERIFICA SE QUANTIDADE DISPONÖVEL  SUFICIENTE PARA REALIZAR O ATENDIMENTO */
        IF NOT l-perm-sald-neg AND NOT fn-qtd-suficiente-atendimento(de-qtde-total-perm, p-qtd-atender) THEN DO:
            RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 55256, INPUT ""). /*Sem saldo dispon¡vel em estoque para o usu rio.   */
            RETURN "NOK":U.
        END.
    END.
    
    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaSaldosUsuarDepEstab DBOFunction 
PROCEDURE retornaSaldosUsuarDepEstab:
/*------------------------------------------------------------------------------
  Purpose:     Retornar temp-table somente com os saldos que o usu rio
                tem permissÆo.
  Parameters:  Quantidade a Atender e temp-table com os saldos em estoque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttSummaryInventoryBalance.
    
    FOR EACH ttSummaryInventoryBalance:
        IF NOT CAN-FIND(FIRST usuar-depos
                        WHERE usuar-depos.cod-depos   = ttSummaryInventoryBalance.cod-depos
                          AND usuar-depos.cod-estabel = pc-cod-estabel
                          AND usuar-depos.cod-usuario = c-seg-usuario
                          AND usuar-depos.dat-val-fim >= TODAY) THEN DO:
            DELETE ttSummaryInventoryBalance.
            NEXT.
        END.
    END.
    
    RETURN "OK":U.
    
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ordenaDepositos DBOFunction 
PROCEDURE ordenaDepositos PRIVATE:

    /********************************************************
    ORDENA OS DEP…SITOS PARA FAZER O ATENDIMENTO SIMPLIFICADO
    ********************************************************/

    DEF VAR i-seq AS INT NO-UNDO.

    EMPTY TEMP-TABLE ttInventoryBalanceOrdered.

    IF AVAIL ITEM AND item.tipo-con-est >= 3 THEN DO:

        /*ORDENA POR DATA DE VALIDADE QUANDO A DATA FOR MAIOR QUE HOJE E QUANTIDADE MAIOR QUE ZERO*/
        FOR EACH ttSummaryInventoryBalance
           WHERE (ttSummaryInventoryBalance.dt-vali-lote >= TODAY
             AND ttSummaryInventoryBalance.qtidade-atu > 0)
             OR ttSummaryInventoryBalance.is-wms-saas  = YES
              BY ttSummaryInventoryBalance.dt-vali-lote
              BY ttSummaryInventoryBalance.qtidade-atu DESC:
            
            ASSIGN i-seq = i-seq + 1.
    
            CREATE ttInventoryBalanceOrdered.
            BUFFER-COPY ttSummaryInventoryBalance TO ttInventoryBalanceOrdered.
            ASSIGN ttInventoryBalanceOrdered.seq = i-seq
                   d-saldo-deposito = d-saldo-deposito + ttSummaryInventoryBalance.qtidade-atu.
    
            DELETE ttSummaryInventoryBalance.
    
        END.
    
        /*ORDENA SOMENTE PELA QUANTIDADE QUANDO A DATA FOR MAIOR QUE TODAY*/
        FOR EACH ttSummaryInventoryBalance
           WHERE ttSummaryInventoryBalance.dt-vali-lote >= TODAY
              OR ttSummaryInventoryBalance.is-wms-saas  = YES
              BY ttSummaryInventoryBalance.qtidade-atu DESC:
            
            ASSIGN i-seq = i-seq + 1.
    
            CREATE ttInventoryBalanceOrdered.
            BUFFER-COPY ttSummaryInventoryBalance TO ttInventoryBalanceOrdered.
            ASSIGN ttInventoryBalanceOrdered.seq = i-seq
                   d-saldo-deposito = d-saldo-deposito + ttSummaryInventoryBalance.qtidade-atu.
    
            DELETE ttSummaryInventoryBalance.
    
        END.
        
    END.
    ELSE DO:
    
        /*ORDENA OS DEPOSITOS RESTANTES*/
        FOR EACH ttSummaryInventoryBalance
              BY ttSummaryInventoryBalance.qtidade-atu DESC:
            
            ASSIGN i-seq = i-seq + 1.
    
            CREATE ttInventoryBalanceOrdered.
            BUFFER-COPY ttSummaryInventoryBalance TO ttInventoryBalanceOrdered.
            ASSIGN ttInventoryBalanceOrdered.seq = i-seq
            d-saldo-deposito = d-saldo-deposito + ttSummaryInventoryBalance.qtidade-atu.
    
            DELETE ttSummaryInventoryBalance.
    
        END.

    END.

    RETURN "OK":U.
    
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE groupLotWMS DBOFunction 
PROCEDURE groupLotWMS PRIVATE:
/*------------------------------------------------------------------------------
  Purpose: Samariza Saldo em Estoque para depositos que geram WMS
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-grouplot AS LOGICAL NO-UNDO. 
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttSummaryInventoryBalance.
    
    IF NOT AVAIL param-estoq THEN
        FIND FIRST param-estoq NO-LOCK NO-ERROR.
          
    IF param-estoq.int-1 = 1 AND CONNECTED("MGSCM") THEN DO:
        FOR EACH ttSummaryInventoryBalance,
            FIRST deposito NO-LOCK
            WHERE deposito.cod-depos = ttSummaryInventoryBalance.cod-depos
              AND deposito.log-gera-wms = YES
            BREAK BY ttSummaryInventoryBalance.cod-depos
                  BY ttSummaryInventoryBalance.cod-localiz
                  BY ttSummaryInventoryBalance.cod-refer:

            IF FIRST-OF(ttSummaryInventoryBalance.cod-refer) THEN DO:
                FOR EACH b-ttSummaryInventoryBalance
                   WHERE b-ttSummaryInventoryBalance.cod-depos   = ttSummaryInventoryBalance.cod-depos
                     AND b-ttSummaryInventoryBalance.cod-localiz = ttSummaryInventoryBalance.cod-localiz
                     AND b-ttSummaryInventoryBalance.cod-refer   = ttSummaryInventoryBalance.cod-refer
                     AND ROWID(b-ttSummaryInventoryBalance)     <> ROWID(ttSummaryInventoryBalance):
                    ASSIGN ttSummaryInventoryBalance.qtidade-atu  = ttSummaryInventoryBalance.qtidade-atu + b-ttSummaryInventoryBalance.qtidade-atu
                           ttSummaryInventoryBalance.lote = "".
                END.
            END.
            ELSE
                DELETE ttSummaryInventoryBalance.
        END.
    END.
           
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTSummaryInventoryBalance DBOFunction 
PROCEDURE criaTTSummaryInventoryBalance PRIVATE:
/*------------------------------------------------------------------------------
  Purpose: Cria temp table se saldo em estoque do item     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-nr-requisicao   LIKE it-requisicao.nr-requisicao NO-UNDO.
    DEFINE INPUT PARAMETER p-sequencia       LIKE it-requisicao.sequencia     NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-depos       LIKE saldo-estoq.cod-depos       NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-localiz     LIKE saldo-estoq.cod-localiz     NO-UNDO.
    DEFINE INPUT PARAMETER p-lote            LIKE saldo-estoq.lote            NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-vali-lote    LIKE saldo-estoq.dt-vali-lote    NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-refer       LIKE saldo-estoq.cod-refer       NO-UNDO.
    DEFINE INPUT PARAMETER p-qtidade-atu     AS DECIMAL                       NO-UNDO.
    DEFINE INPUT PARAMETER p-qt-a-atender    AS DECIMAL                       NO-UNDO.
    DEFINE INPUT PARAMETER p-logprocesswms   AS CHARACTER                     NO-UNDO.
    DEFINE INPUT PARAMETER p-close           AS LOGICAL                       NO-UNDO.
    
    CREATE ttSummaryInventoryBalance.
    ASSIGN ttSummaryInventoryBalance.nr-requisicao  = p-nr-requisicao
           ttSummaryInventoryBalance.sequencia      = p-sequencia
           ttSummaryInventoryBalance.cod-depos      = p-cod-depos    
           ttSummaryInventoryBalance.cod-localiz    = p-cod-localiz  
           ttSummaryInventoryBalance.lote           = p-lote         
           ttSummaryInventoryBalance.dt-vali-lote   = p-dt-vali-lote 
           ttSummaryInventoryBalance.cod-refer      = p-cod-refer    
           ttSummaryInventoryBalance.qtidade-atu    = p-qtidade-atu  
           ttSummaryInventoryBalance.qt-a-atender   = p-qt-a-atender 
           ttSummaryInventoryBalance.logprocesswms  = p-logprocesswms
           ttSummaryInventoryBalance.close          = p-close.
           
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE haveRowErrors DBOFunction 
PROCEDURE haveRowErrors PRIVATE: 
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/     
    DEFINE OUTPUT PARAMETER l-erro AS LOGICAL NO-UNDO.
    
    ASSIGN l-erro = CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U).

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRowErrors DBOFunction 
PROCEDURE createRowErrors PRIVATE: 
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/     
    DEFINE INPUT PARAMETER pTipoErro         AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pErrorNumber      AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pErrorDescription AS CHARACTER NO-UNDO.
    DEFINE VARIABLE        i-seq-erro        AS INTEGER   NO-UNDO.
    
    IF pTipoErro = 2 AND pErrorDescription <> "" THEN DO:
    
        FIND LAST RowErrors NO-ERROR.
        IF  AVAIL RowErrors then
            ASSIGN i-seq-erro = RowErrors.ErrorSequence + 1.
        ELSE 
            ASSIGN i-seq-erro = 1.

        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence    = i-seq-erro
               RowErrors.ErrorNumber      = pErrorNumber
               RowErrors.ErrorType        = "EMS":U
               RowErrors.ErrorSubType     = "ERROR":U
               RowErrors.ErrorDescription = pErrorDescription.
    
      
    END.
    ELSE DO:
    
        {method/svc/errors/inserr.i &ErrorNumber=pErrorNumber
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters=pErrorDescription} 
    
    END.
    /*   */                       

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        &if "{&bf_mat_versao_ems}" >= "2.071" &then
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nome-aprov":U THEN ASSIGN pFieldValue = RowObject.nome-aprov.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "cod-unid-negoc":U THEN ASSIGN pFieldValue = RowObject.cod-unid-negoc.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-atend":U THEN ASSIGN pFieldValue = RowObject.dt-atend.
        WHEN "dt-entrega":U THEN ASSIGN pFieldValue = RowObject.dt-entrega.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "preco-unit":U THEN ASSIGN pFieldValue = RowObject.preco-unit.
        WHEN "qt-a-atender":U THEN ASSIGN pFieldValue = RowObject.qt-a-atender.
        WHEN "qt-a-devolver":U THEN ASSIGN pFieldValue = RowObject.qt-a-devolver.
        WHEN "qt-atendida":U THEN ASSIGN pFieldValue = RowObject.qt-atendida.
        WHEN "qt-devolvida":U THEN ASSIGN pFieldValue = RowObject.qt-devolvida.
        WHEN "qt-requisitada":U THEN ASSIGN pFieldValue = RowObject.qt-requisitada.
        WHEN "val-item":U THEN ASSIGN pFieldValue = RowObject.val-item.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        &if "{&bf_mat_versao_ems}" < "2.071" &then
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-requisicao":U THEN ASSIGN pFieldValue = RowObject.nr-requisicao.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "prioridade-aprov":U THEN ASSIGN pFieldValue = RowObject.prioridade-aprov.
        WHEN "seq-planej":U THEN ASSIGN pFieldValue = RowObject.seq-planej.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice item-req
  Parameters:  
               retorna valor do campo nr-requisicao
               retorna valor do campo sequencia
               retorna valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-requisicao LIKE it-requisicao.nr-requisicao NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE it-requisicao.sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE it-requisicao.it-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-requisicao = RowObject.nr-requisicao
           psequencia = RowObject.sequencia
           pit-codigo = RowObject.it-codigo.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemOfRequest DBOProgram 
PROCEDURE openQueryItemOfRequest :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&QueryName}
        for each {&tableName}
            where {&tableName}.nr-requisicao = i-NrRequisicao no-lock indexed-reposition.

    return "OK".

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

    open query {&QueryName} for each it-requisicao no-lock indexed-reposition.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAction DBOProgram 
PROCEDURE setAction :
/*------------------------------------------------------------------------------
  Purpose:     Informa a Bo qual ação do usúario (Incluindo, Modificando, Deletando)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    ASSIGN c-tipo-acao = pType.

END PROCEDURE.

PROCEDURE setOrigin :
/*------------------------------------------------------------------------------
  Purpose:     Informa a origem da execu‡Æo da BO (ex HTML)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pOrigin AS LOGICAL NO-UNDO.

    ASSIGN c-orig-html = pOrigin.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItemOfRequest DBOProgram 
PROCEDURE setConstraintItemOfRequest :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pNrRequisicao like requisicao.nr-requisicao no-undo.

    assign i-NrRequisicao = pNrRequisicao.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateStatus DBOProgram 
PROCEDURE updateStatus :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza a situa‡Æo do item da requisi‡Æo e da requisi‡Æo de acordo
               com a a‡Æo executada pelo usu rio comprador.
  Parameters:  
  Notes:       Comprador altera a situa‡Æo do item da requisi‡Æo para sinalizar
               ao requisitante que nÆo h  informa‡äes suficientes para que o 
               comprador tenha condi‡äes de iniciar o processo de compra.
------------------------------------------------------------------------------*/

    find first requisicao
        where requisicao.nr-requisicao = RowObject.nr-requisicao exclusive-lock no-error.
    if  RowObject.situacao = 3 then do: /* Incompleta */

        if  avail requisicao then do:

            find first bf{&TableName}
                where bf{&TableName}.nr-requisicao = RowObject.nr-requisicao
                  and bf{&TableName}.sequencia     = RowObject.sequencia
                  and bf{&tablename}.it-codigo     = RowObject.it-codigo exclusive-lock no-error.
            if  avail bf{&TableName} then
                assign requisicao.situacao     = 3  /* Incompleta */
                       bf{&TableName}.situacao = 3. /* Incompleta */
        end.
    end.
    else if  RowObject.situacao = 1 then do: /* Aberta */

        find first bf{&TableName}
            where bf{&TableName}.nr-requisicao = RowObject.nr-requisicao
              and bf{&TableName}.sequencia     = RowObject.sequencia
              and bf{&tablename}.it-codigo     = RowObject.it-codigo exclusive-lock no-error.
        if  avail bf{&TableName} then
            assign bf{&TableName}.situacao = 1. /* Aberta */


        /* Se nÆo h  mais nenhum item incompleto, alterar o status da requisi‡Æo para aberto */
        if  not can-find(first it-requisicao
                         where it-requisicao.nr-requisicao = RowObject.nr-requisicao
                           and it-requisicao.situacao      = 3
                           and it-requisicao.it-codigo     <> RowObject.it-codigo
                           and it-requisicao.sequencia     <> RowObject.sequencia) then do: /* Incompleta */
            if  avail requisicao then
                assign requisicao.situacao = 1.  /* Aberta */
        end.
    end.
    find first requisicao
        where requisicao.nr-requisicao = RowObject.nr-requisicao NO-lock no-error.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateBtUpdateItem DBOProgram 
PROCEDURE validateBtUpdateItem :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes a modifica‡Æo de registros
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    if  avail requisicao then do:

        {cdp/findusuarmater.i requisicao.nome-abrev}
        if  avail usuar-mater
        and requisicao.nome-abrev <> c-seg-usuario
        and substr(usuar-mater.char-1,10,1) = "N" then do: /* Altera Requisi‡Æo */
            {utp/ut-liter.i modificar}
            {method/svc/errors/inserr.i &ErrorNumber="33913"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"} 
            return "NOK".
        end.

        if  it-requisicao.situacao = 2          /* Fechada */
        or  it-requisicao.situacao = 4 then do: /* Com Ordem */
            {utp/ut-table.i movind it-requisicao 1}
            {method/svc/errors/inserr.i &ErrorNumber="31232"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value + '~~~~' + entry(it-requisicao.situacao, c-lst-situacao)"}
            return "NOK".
        end.
    end.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateEletronicApproval DBOProgram 
PROCEDURE validateEletronicApproval :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes referente a Aprova‡Æo Eletr“nica
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    def var de-valor-item    as dec     no-undo.
    def var de-valor-total   as dec     no-undo.
    
    if  l-integra-aed-ems then do:

        assign i-tipo-trans = if pType = "Create" then 1 /* inclusÆo */ else 2 /* modifica‡Æo */.

        if  requisicao.tp-requis = 1                  /* Requisi‡Æo Estoque */
        and param-compra.log-1                        /* Aprova‡Æo Eletr“nica */  
        and substr(param-estoq.char-1,4,1) = "Y" then /* Aprova‡Æo Requisi‡Æo */
           assign i-tipo-doc = 2.
        else if requisicao.tp-requis = 2 /* Solicita‡Æo de Compra */
            and param-compra.log-1 then /* Aprova‡Æo Eletr“nica */
            assign i-tipo-doc = 1.
        else 
            assign i-tipo-doc = 0.
        
        if  i-tipo-doc > 0 then do:

            assign de-valor-item = RowObject.preco-unit * RowObject.qt-a-atender
                   de-valor-total = de-valor-item.

            for each bfit-requisicao fields(val-item)
                where bfit-requisicao.nr-requisicao = requisicao.nr-requisicao no-lock:
                assign de-valor-total = de-valor-total + bfit-requisicao.val-item.
            end.

            run lap/mlaapi173.p (input  i-tipo-doc,
                                  input  RowObject.it-codigo,
                                  input  requisicao.nome-abrev,
                                  input  RowObject.ct-codigo,
                                  input  requisicao.cod-estabel,
                                  input  RowObject.sc-codigo,
                                  input  de-valor-item,
                                  input  de-valor-total,
                                  input  requisicao.cod-estabel,  
                                  output table tt-erro-aed).

            if  return-value = "nok":U then do:
                find first tt-erro-aed no-error.
                if  avail tt-erro-aed then do:
                    {method/svc/errors/inserr.i &ErrorNumber="tt-erro-aed.cd-erro"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="tt-erro-aed.c-param"}
                end.
            end.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateInvestments DBOProgram 
PROCEDURE validateInvestments :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes referente a Investimentos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
        
    def var l-avail-sub-div-ordem   as log                              no-undo.
    def var c-ct-codigo             like it-requisicao.ct-codigo        no-undo.
    def var c-sc-codigo             like it-requisicao.sc-codigo        no-undo.


    if  pType = "Create"
    or  pType = "Update" then do:
              
        if  connected("mginv")
        and param-global.modulo-in then do:

            if  RowObject.num-ord-inv <> 0 then do:
                run inp/in2201.p (input  estabelec.ep-codigo,
                                  input  RowObject.num-ord-inv,
                                  input  no,
                                  output l-avail-sub-div-ordem,
                                  output c-ct-codigo,
                                  output c-sc-codigo).
            
                if  l-avail-sub-div-ordem = no then do:
                    {utp/ut-table.i mginv ordem-inv 1}
                    {method/svc/errors/inserr.i &ErrorNumber="56"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="return-value"} 
                    return "NOK".
                end.
            end.

            if RowObject.ct-codigo <> ? then do:
                run inp/inapi060.p (input  requisicao.cod-estabel,
                                    input  RowObject.ct-codigo,
                                    input  RowObject.sc-codigo,
                                    input  RowObject.num-ord-inv,
                                    input  no,
                                    output table tt-erro).
                find first tt-erro no-error.
                if avail tt-erro then do:                
                    {method/svc/errors/inserr.i &ErrorNumber="tt-erro.cd-erro"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="tt-erro.c-param"}                                                                 
                    return "NOK".
                end.
            end.
        end.
    end.
              
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
    
    DEF VAR cod-conta         AS CHARACTER       NO-UNDO.
    DEF VAR i-cont-prog       AS INTEGER         NO-UNDO.
    DEF VAR l-request-adapter AS LOGICAL INIT NO NO-UNDO.
    
    
    {cdp/findparamglobal.i}
    {cdp/findparamcompra.i}
    {cdp/findparamestoq.i}
    {cdp/findparammat.i}

    DO  i-cont-prog = 1 TO 10: /*VERIFICAR SE A SOLICITACAO VEM DO PROGRAMA CD1409 HTML*/
        IF  PROGRAM-NAME(i-cont-prog) MATCHES "*closeInventoryRequisition*":U OR
            PROGRAM-NAME(i-cont-prog) MATCHES "*pi-close-item-request*":U THEN DO:
            ASSIGN c-orig-html = TRUE.
            LEAVE.
        END.
    END.
    
    // Se a integra‡Æo com o PIMS est  ativa, verifica se a solicita‡Æo veio do integrador
    IF  CAN-FIND(FIRST funcao NO-LOCK
                 WHERE funcao.cd-funcao = "spp-eai2-integra-ems-pims" 
                 AND   funcao.ativo) THEN DO:
        DO  i-cont-prog = 1 TO 10: /* Verifica se a solicita‡Æo veio do integrador (ex: PIMS) */
            IF  PROGRAM-NAME(i-cont-prog) MATCHES "*com.totvs.datasul.logistics.mce.RequestAdapter*":U THEN DO:
                ASSIGN l-request-adapter = YES.
                LEAVE.
            END.
        END.
    END.
    
    IF pType = "UPDATE":U THEN DO:
        IF RowObject.cod-unid-negoc = "" AND (AVAIL it-requisicao AND it-requisicao.cod-unid-negoc <> "") THEN
            ASSIGN RowObject.cod-unid-negoc = it-requisicao.cod-unid-negoc.
    END.

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    if  not avail requisicao then do:
        {utp/ut-table.i movind requisicao 1}
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="return-value"} 
        return "NOK".
    end.

    // Se a chamada est  vindo do integrador (ex: PIMS), deve usar o usu rio da tabela, porque o usu rio logado ser  um gen‚rico
    IF  l-request-adapter THEN DO:
        {cdp/findusuarmater.i requisicao.nome-abrev}
    END.
    ELSE DO:
        // Mas se est  vindo do Progress, ou mesmo do HTML, entÆo usa o usu rio logado
        {cdp/findusuarmater.i c-seg-usuario}
    END.
    
    if  not avail usuar-mater then do:
        {utp/ut-table.i mgind usuar-mater 1}
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="return-value"} 

        return "NOK".
    end.

    {cdp/findestabelec.i requisicao.cod-estabel}
    if  not avail requisicao then do:
        {utp/ut-table.i mgadm estabelec 1}
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="return-value"} 

        return "NOK".
    end.

    {cdp/finditem.i RowObject.it-codigo}
    if  not avail item then do:
        {utp/ut-table.i mgind item 1}
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="return-value"} 
        return "NOK".
    end.
    
    {cdp/finditemuniestab.i RowObject.it-codigo requisicao.cod-estabel}
    if  not avail item-uni-estab then do:
        {method/svc/errors/inserr.i &ErrorNumber="25904"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="RowObject.it-codigo + '~~~~' + requisicao.cod-estabel"}
        return "NOK".
    end.
    
    IF CAN-FIND (FIRST funcao 
                 WHERE funcao.cd-funcao = "spp-integra-ems-his"
                   AND funcao.ativo     = YES) THEN DO:
        IF CAN-FIND (FIRST ITEM
                     WHERE item.it-codigo =  RowObject.it-codigo 
                       AND ITEM.log-orig-ext = YES
                       AND requisicao.tp-requis = 1) THEN DO:
                                   
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-item-nao-pode-ser-movimentado AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "ITEM_nao_pode_ser_movimentado" *}
            ASSIGN c-lbl-liter-item-nao-pode-ser-movimentado = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-item-somente-pode-ser-moviment AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "ITEM_somente_pode_ser_movimentado_pelo_Sistema_Hospitalar" *}
            ASSIGN c-lbl-liter-item-somente-pode-ser-moviment = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-merge-item-nao-pode-ser-movimentado AS CHARACTER NO-UNDO.
            ASSIGN c-lbl-merge-item-nao-pode-ser-movimentado = c-lbl-liter-item-nao-pode-ser-movimentado + ' ' + "~~" + ' ' + c-lbl-liter-item-somente-pode-ser-moviment.
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-merge-item-nao-pode-ser-movimentado"}
            
            return "NOK".
        END.
    END.
           
    IF RowObject.nr-ord-produ <> 0 THEN DO:    
        
        FIND FIRST ord-prod NO-LOCK
             WHERE ord-prod.nr-ord-produ = RowObject.nr-ord-produ NO-ERROR.

        IF AVAIL ord-prod AND requisicao.cod-estabel <> ord-prod.cod-estabel THEN DO:
            RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 6347, INPUT RowObject.nr-ord-produ).
            RETURN "NOK":U.
        END.
             
    END.
    
    IF pType = "UPDATE":U THEN DO:
        IF (AVAIL ord-prod AND ord-prod.origem = "MI":U) THEN DO:
            
            RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 17006, INPUT "Item_da_Requisicao_gerado_pelo_MI_ou_com_Ordem_vinculada_nao_pode_ser_modificado.").
            RETURN "NOK":U.
        END.
        
    END.
   
    IF (pType = "CREATE":U OR pType = "UPDATE":U) AND AVAIL ord-prod THEN DO:
        
        /* Valida Status da Ordem: Terminada */
        IF ord-prod.estado = 8 THEN DO:
            
            RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 26830, INPUT "").
            RETURN "NOK":U.
        END.

        /* Valida Status da Ordem: Cancelada */
        IF ord-prod.estado = 7 THEN DO:
            
            RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 26831, INPUT "").
            RETURN "NOK":U.
        END.

        /* Valida Operação e Roteiro (se o tipo de reporte da ordem exigir) */
        IF (ord-prod.rep-prod > 1 AND ord-prod.rep-prod < 4) THEN DO:
            
            /* Verifica se a combinação informada realmente existe na tabela de operações da ordem */
            FIND FIRST oper-ord NO-LOCK
                 WHERE oper-ord.nr-ord-produ = RowObject.nr-ord-produ
                   AND oper-ord.it-codigo    = RowObject.item-pai
                   AND oper-ord.op-codigo    = RowObject.op-seq
                   AND oper-ord.cod-roteiro  = RowObject.cod-roteiro NO-ERROR.

            IF NOT AVAIL oper-ord THEN DO:
                
                RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 17006, INPUT "Operacao/Roteiro_Invalido_para_Item-Pai.").
                RETURN "NOK":U.
            END.
        END.
    END.

    if  pType = "Create" then do:
               
        find last it-requisicao
            where it-requisicao.nr-requisicao = RowObject.nr-requisicao
            no-lock no-error.
        ASSIGN l-altera-sequencia = YES.

        FOR EACH tt-epc
           WHERE tt-epc.cod-event = "sequencia-item":
            DELETE tt-epc.
        END.
    
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "sequencia-item":U
               tt-epc.cod-parameter = "nr-requisicao":U
               tt-epc.val-parameter = STRING(RowObject.nr-requisicao).
    
        {include/i-epc201.i "sequencia-item"}
    
        FIND FIRST tt-epc
             WHERE tt-epc.cod-event     = "sequencia-item":U
               AND tt-epc.cod-parameter = "altera-sequencia":U NO-ERROR.

        IF AVAIL tt-epc THEN
            ASSIGN l-altera-sequencia = IF tt-epc.val-parameter = "yes" THEN YES ELSE NO.
            
        IF l-altera-sequencia THEN DO:
            if  avail it-requisicao then
                assign RowObject.sequencia = it-requisicao.sequencia + if l-sequencia-unitaria then 1 else 10.
            else
                assign RowObject.sequencia = if l-sequencia-unitaria then 1 else 10.
            
            ASSIGN i-sequencia = RowObject.sequencia.
            if  i-sequencia > 999 then do:
                do i-count = 1 to 999:
                    if can-find(first it-requisicao
                                where it-requisicao.nr-requisicao = requisicao.nr-requisicao
                                  and it-requisicao.sequencia     = i-count) then 
                        assign i-sequencia = 1.
                    else do:
                        assign i-sequencia = i-count.
                        leave.
                    end.
                end.
            end.
            ASSIGN RowObject.sequencia = i-sequencia.
        END.
        
        if  can-find(first it-requisicao
                     where it-requisicao.nr-requisicao = RowObject.nr-requisicao
                       and it-requisicao.sequencia     = RowObject.sequencia
                       and it-requisicao.it-codigo     = RowObject.it-codigo) then do:
            {utp/ut-table.i movind it-requisicao 1}       
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
            return "NOK".
        end.

        if  requisicao.tp-requis = 2 then do: /* Solicita‡Æo de Compra */
            if  RowObject.dt-entrega < (today + item-uni-estab.res-int-comp + item-uni-estab.res-for-comp) then do:
                {method/svc/errors/inserr.i &ErrorNumber="34406"
                                            &ErrorType="EMS"
                                            &ErrorSubType="WARNING"
                                            &ErrorParameters="string(today + item-uni-estab.res-int-comp + item-uni-estab.res-for-comp) + '~~~~' +
                                                              string(item-uni-estab.res-int-comp) + '~~~~' + string(item-uni-estab.res-for-comp)"}

            end.
        end.
    end.

    if  pType = "Create"
    or  pType = "Update" then do:

        if  requisicao.tp-requis = 1  THEN DO:       /* Requisi‡Æo Estoque */
            IF ITEM.tipo-contr = 4 THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="1569"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}
                return "NOK".
            END.

            {utp/ut-liter.i hora_atual}              
            if  RowObject.hra-entrega <= string(time, "HH:MM") and
                RowObject.dt-entrega <= TODAY then do:
                {method/svc/errors/inserr.i &ErrorNumber="30378"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="return-value"}
                return "NOK".
            end.
        END.

        if  item.tipo-con-est <> 2 /* N£mero de S‚rie */
        and (    pType = "create"
             or (    pType = "update"
                 and requisicao.tp-requis <> 1)) THEN DO: /* Requisi‡Æo Estoque */

            if  RowObject.qt-a-atender = 0 then do:
                {method/svc/errors/inserr.i &ErrorNumber="1570"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}
                return "NOK".
            end.
        end.
        
        if  requisicao.tp-requis = 1 then do: /* Requisi‡Æo Estoque */
            if  item-uni-estab.cod-obsoleto = 4 then do: /* Totalmente Obsoleto */
                {method/svc/errors/inserr.i &ErrorNumber="1885"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}
                return "NOK".
            end.
        end.
        else do: /* Solicita‡Æo de Compra/Cota‡Æo */
            if  item-uni-estab.cod-obsoleto = 2          /* Obsoleto Ordens Autom ticas */
            or  item-uni-estab.cod-obsoleto = 3          /* Obsoleto Todas as Ordens */
            or  item-uni-estab.cod-obsoleto = 4 then do: /* Totalmente Obsoleto */
                {method/svc/errors/inserr.i &ErrorNumber="1885"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}
                return "NOK".
            end.
        end.

        if  item.tipo-contr      = 4          /* D‚bito Direto */
        and requisicao.tp-requis = 1 then do: /* Requisi‡Æo Estoque */
            {method/svc/errors/inserr.i &ErrorNumber="1569"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}
            return "NOK".
        end.

        IF NOT item-uni-estab.altera-conta AND RowObject.ct-codigo = "":U THEN DO:
            IF item.tipo-contr = 4 THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="54606"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="RowObject.it-codigo"}
                return "NOK".
            END.
            ELSE DO:
                run cdp/cd1406a2.p (input item.it-codigo,
                                    input requisicao.cod-estabel,
                                    output i-tp-ressup).
                if i-tp-ressup <> 2 then do:  /*2 - tipo de ressuprimento manual */
                    {method/svc/errors/inserr.i &ErrorNumber="54606"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="RowObject.it-codigo"}
                    return "NOK".
                end.
            END.
        END.

        if  param-global.modulo-cc then do:
            if  requisicao.tp-requis = 2          /* Solicita‡Æo de Compra */
            or  requisicao.tp-requis = 3 then do: /* Solicita‡Æo de Cota‡Æo */

                if param-compra.int-2 = 1 then do: /* Gera‡Æo Ordens Compra - Grupo de Compras */
               
                   if  item-uni-estab.cod-grp-compra = "" then do:
                       {method/svc/errors/inserr.i &ErrorNumber="16419"
                                                   &ErrorType="EMS"
                                                   &ErrorSubType="ERROR"
                                                   &ErrorParameters="''"}
                       return "NOK".
                   end.
                end.
                else if param-compra.int-2 = 2 then do: /* Gera‡Æo Ordens Compra - Comprador */

                    {cdp/findcomprador.i item-uni-estab.cod-comprado}
                    if  not avail comprador then do:
                        {method/svc/errors/inserr.i &ErrorNumber="15712"
                                                   &ErrorType="EMS"
                                                   &ErrorSubType="ERROR"
                                                   &ErrorParameters="''"}
                       return "NOK".
                    end.
                end.
            end.
        end.
    
        if  item.tipo-con-est = 4 then do: /* Referˆncia */
            
            if not can-find(first referencia
                            where referencia.cod-refer = RowObject.cod-refer) then do:
                {method/svc/errors/inserr.i &ErrorNumber="529"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="RowObject.cod-refer"}
                return "NOK".
            end.
        end.
                                                              
        if  requisicao.tp-requis = 2 /* Solicita‡Æo de Compra */
        and RowObject.it-codigo <> ""
        and item.tipo-contr      = 4 then do:

            if  RowObject.preco-unit = 0 then do:
                {method/svc/errors/inserr.i &ErrorNumber="1573"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="RowObject.cod-refer"}
                return "NOK".
            end.
        end.

        if  item.fraciona = no
        and RowObject.qt-a-atender <> int(RowObject.qt-a-atender) then do:
            {method/svc/errors/inserr.i &ErrorNumber="847"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}
            return "NOK".
        end.

        if  RowObject.it-codigo = ?
        or  RowObject.it-codigo = ""
        or  item.tipo-contr     = 4 then do: /* D‚bito Direto */

            {cdp/findtabunidade.i RowObject.un}
            if  not avail tab-unidade then do:
                {utp/ut-table.i mgind tab-unidade 1}
                {method/svc/errors/inserr.i &ErrorNumber="56"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="return-value"} 

                return "NOK".
            end.
        end.
        else do:

            if  requisicao.tp-requis <> 1 AND RowObject.un <> item.un then do: /*Tipo de requisição diferente de "Requisição Estoque"*/
                {method/svc/errors/inserr.i &ErrorNumber="1571"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}
                return "NOK".
            end.
        end.

        if  item.tipo-contr     = 4
        and RowObject.it-codigo = ""
        and RowObject.narrativa = "" then do:
            {method/svc/errors/inserr.i &ErrorNumber="1572"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}
            return "NOK".
        end.

        if  item.tipo-con-est = 2 /* N£mero de S‚rie */
        and RowObject.qt-a-atender > 1 then do:    

            assign RowObject.qt-a-atender = 1.

            {method/svc/errors/inserr.i &ErrorNumber="30018"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}
        end.

        if item-uni-estab.altera-conta = no then do: /* Classifica‡Æo Cont bil */
            if avail estabelec then
                assign c-empresa = estabelec.ep-codigo when avail estabelec.
            else do:
                find first estabelec no-lock 
                     where estabelec.cod-estabel = RowObject.cod-estabel no-error.
                assign c-empresa = estabelec.ep-codigo when avail estabelec.
            end.

            run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
            IF RowObject.ct-codigo = ? THEN
                ASSIGN RowObject.ct-codigo = "".
                
            ASSIGN cod-conta = RowObject.ct-codigo.

            if cod-conta <> "" or (cod-conta = "" and item.tipo-contr = 4) then do:
            
                run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        c-empresa,              /* EMPRESA EMS2 */
                                                               input        "",                     /* PLANO DE CONTAS */
                                                               input-output cod-conta,              /* CONTA */
                                                               input        RowObject.dt-entrega,   /* DATA TRANSACAO */   
                                                               output       v_des_cta_ctbl,         /* DESCRICAO CONTA */
                                                               output       v_num_tip_cta_ctbl,     /* TIPO DA CONTA */
                                                               output       v_num_sit_cta_ctbl,     /* SITUACAO DA CONTA */
                                                               output       v_ind_finalid_cta,      /* FINALIDADES DA CONTA */
                                                               output table tt_log_erro).           /* ERROS */
               
    
                for first tt_log_erro:
                    {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro)"}
                    return "NOK".
                end.
    
              empty temp-table tt_log_erro.
              empty temp-table RowErrors.


              /* .alc */
              /* Valida a conta e centro de custo e verifica se o centro de custo informado pertence ao Mapa da conta */
              run pi_valida_conta_contabil in h_api_cta_ctbl (input  c-empresa,                                          /* EMPRESA EMS2 */
                                                              input  requisicao.cod-estabel,                              /* ESTABELECIMENTO EMS2 */
                                                              input  RowObject.cod-unid-negoc,                           /* UNIDADE NEGOCIO */
                                                              input  "",                                                 /* PLANO CONTAS */
                                                              input  cod-conta,                                          /* CONTA */
                                                              input  "",                                                 /* PLANO CCUSTO */
                                                              input  RowObject.sc-codigo,                                /* CCUSTO */
                                                              input  RowObject.dt-entrega,                               /* DATA TRANSACAO */
                                                              output table tt_log_erro).                                 /* ERROS */

              for first tt_log_erro:
                        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                              &ErrorType="EMS"
                                              &ErrorSubType="ERROR"
                                              &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro)"}
                  return "NOK".
              end.

              if valid-handle(h_api_cta_ctbl) then
                  delete object h_api_cta_ctbl.

                /* Verifica Estoque */
                assign ind       = 1
                       i-estoque = 0.
                do while ind <= 10:
                    assign v_cod_finalid = {adinc/i05ad049.i 4 ind}.
                
                    if lookup(v_cod_finalid, v_ind_finalid_cta) > 0 then do:
                        assign i-estoque = ind.
                        leave.
                    end.
                
                    assign ind = ind + 1.
                end.
    
                if not can-find(tt_log_erro) and 
                   (i-estoque = 0  or  
                   (i-estoque <> 1 and  
                    i-estoque <> 2 and  
                    i-estoque <> 3 and  
                    i-estoque <> 5 and  
                    i-estoque <> 6)) then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-conta AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Conta" *}
                    ASSIGN c-lbl-liter-conta = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-centro-custo AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Centro_Custo" *}
                    ASSIGN c-lbl-liter-centro-custo = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="1577"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="c-lbl-liter-conta + ' ' + String(RowObject.ct-codigo) + ' ' + c-lbl-liter-centro-custo + ' ' + String(RowObject.sc-codigo)"} 
                    return "NOK".
                end.
                if RowObject.sc-codigo = ? then
                    assign RowObject.sc-codigo = "".
    
                if  substr(param-estoq.char-1,3,1) = "Y" /* Valida Centro de Custo */
                and RowObject.sc-codigo            <> "" then do:
    
                    {cdp/findusuarccusto.i requisicao.nome-abrev RowObject.sc-codigo}
                    if  not avail usuar-ccusto then do:
                        {method/svc/errors/inserr.i &ErrorNumber="16040"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="return-value"} 
                        return "NOK".
                    end.
                end.
            end.
        end.

        IF c-orig-html = FALSE THEN DO: 
            if  substr(usuar-mater.char-1,1,1) = "Y" /* Utiliza‡äes Material */
            and RowObject.num-ord-inv          = 0 then do: 
                if substring(RowObject.char-2,1,12) = ? then
                    overlay(RowObject.char-2,1,12) = "".
                
                {cdp/findutilizacaomater.i substr(RowObject.char-2,1,12)} /* C¢digo de Utiliza‡Æo */
                if  not avail utilizacao-mater then do:
                    {utp/ut-table.i mgind utilizacao-mater 1}
                    {method/svc/errors/inserr.i &ErrorNumber="56"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="return-value"} 
                    return "NOK".
                end.
    
                {cdp/findutiliznatudespes.i item-uni-estab.nat-despesa substr(RowObject.char-2,1,12)} /* C¢digo de Utiliza‡Æo */
                if  not avail utiliz-natu-despes then do:
                    {method/svc/errors/inserr.i &ErrorNumber="16848"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="string(item-uni-estab.nat-despesa) + '~~~~' +
                                                                  substr(RowObject.char-2,1,12)"} 
    
                    return "NOK".
                end.
            end.
        END.

        if  RowObject.dt-entrega = ? then do:
            {method/svc/errors/inserr.i &ErrorNumber="173"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}   
            return "NOK".
        end.

        IF c-orig-html = FALSE THEN DO: 
            if  RowObject.dt-entrega < today then do:
                {method/svc/errors/inserr.i &ErrorNumber="1578"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"} 
                return "NOK".
            end.
        END.
        /*** VALIDA€åES UNIDADE DE NEGàCIO ***/

        /* "Requisi‡Æo  Estoque" + "Fun‡Æo EMS2-UNIDADE-NEGOCIO" "Solicita‡Æo Compras/Cota‡Æo" + "Usa Unidade de Neg¢cio" (Parƒmetros de materias) */
        IF  RowObject.num-ord-inv <> 0 THEN DO:
            IF NOT AVAIL estabelec OR (AVAIL estabelec AND estabelec.cod-estabel <> requisicao.cod-estabel) THEN
                FIND FIRST estabelec NO-LOCK 
                     WHERE estabelec.cod-estabel = requisicao.cod-estabel NO-ERROR.

            if AVAIL estabelec AND estabelec.ep-codigo <> "" then 
                ASSIGN c-empresa = estabelec.ep-codigo.

            IF NOT VALID-HANDLE(h-boiv029) THEN
                RUN ivbo/boiv029.p PERSISTENT SET h-boiv029.

            RUN recebeEmpresa IN h-boiv029 (INPUT c-empresa).
            RUN retornaMatrizUnidNegoc IN h-boiv029 (INPUT  RowObject.num-ord-inv,
                                                     OUTPUT TABLE tt-matriz,
                                                     OUTPUT TABLE tt-erro-aux).

            FOR EACH tt-erro-aux:
                {method/svc/errors/inserr.i &ErrorNumber="tt-erro-aux.cd-erro"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorDescription="tt-erro-aux.mensagem"} 
            END.

            IF h-boiv029 <> ? AND VALID-HANDLE(h-boiv029) THEN DO:
                DELETE PROCEDURE h-boiv029.
                ASSIGN h-boiv029 = ?.
            END.

        END.
        ELSE DO:
            if (requisicao.tp-requis      = 1 and l-unidade-negocio)
                or ((requisicao.tp-requis = 2 or requisicao.tp-requis = 3) and l-mat-unid-negoc) then do:
    
                if pType = "update" then do:
                    if avail RowObject then do:
                        if not can-find (first unid-neg-requis where
                                               unid-neg-requis.nr-requisicao = RowObject.nr-requisicao and
                                               unid-neg-requis.sequencia     = RowObject.sequencia) then do:
    
                            if RowObject.cod-unid-negoc = "" then do:

                                {utp/ut-liter.i Unidade_de_Neg¢cio}
                                {method/svc/errors/inserr.i &ErrorNumber="265"
                                                            &ErrorType="EMS"
                                                            &ErrorSubType="ERROR"
                                                            &ErrorParameters="return-value"} 
                                return "NOK".
                            end.
                        end.
                        else do:
                            if RowObject.cod-unid-negoc <> "" then do:
                                for each unid-neg-requis exclusive-lock where
                                         unid-neg-requis.nr-requisicao = RowObject.nr-requisicao and
                                         unid-neg-requis.sequencia     = RowObject.sequencia:
                                    delete unid-neg-requis.
                                end.

                                if return-value = "NOK" then
                                    return "NOK".
                            end.
                        end.
                    end.
                end.
                else do:
                    if RowObject.cod-unid-negoc = "" then do:
                    
                        {utp/ut-liter.i Unidade_de_Neg¢cio}
                        {method/svc/errors/inserr.i &ErrorNumber="265"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="return-value"} 
                        return "NOK".
                    end.
                    else do:
                        if not can-find (first unid-negoc
                                         where unid-negoc.cod-unid-negoc = RowObject.cod-unid-negoc) then do:

                            {utp/ut-liter.i Unidade_de_Neg¢cio}                                         
                            {method/svc/errors/inserr.i &ErrorNumber="2"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters="return-value + '~~~~' + RowObject.cod-unid-negoc"}   

                            return "NOK".
                        end.
        
                        IF NOT VALID-HANDLE(h-cdapi024) THEN
                            RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.

                        if valid-handle(h-cdapi024) then do:
        
                            empty temp-table tt-erro-aux.
        
                            /*UN X Estabelecimento*/
                            run ValidaUnidadeNegocioEstabel in h-cdapi024 (input requisicao.cod-estabel,
                                                                           input requisicao.dt-requisicao,
                                                                           input RowObject.cod-unid-negoc, 
                                                                           output table tt-erro-aux).
                            /*UN X Usu rio*/
                            run ValidaUnidadeNegocioUsuario in h-cdapi024 (input requisicao.nome-abrev,
                                                                           input RowObject.cod-unid-negoc, 
                                                                           output table tt-erro-aux append).

                            FOR EACH tt-erro-aux:
                                {method/svc/errors/inserr.i &ErrorNumber="tt-erro-aux.cd-erro"
                                                            &ErrorType="EMS"
                                                            &ErrorSubType="ERROR"
                                                            &ErrorDescription="tt-erro-aux.mensagem"}                                 
                            END.

                            IF h-cdapi024 <> ? AND VALID-HANDLE(h-cdapi024) THEN DO:
                                DELETE PROCEDURE h-cdapi024.
                                ASSIGN h-cdapi024 = ?.
                            END.

                            IF CAN-FIND(FIRST tt-erro-aux) THEN
                                RETURN "NOK".
                        end.
                    end.
                end.
            end.
        END.

        /*** EXECU€ÇO OR€AMENTµRIA ***/
        if pType = "update" and requisicao.tp-requis <> 3 then do: /* Solicita‡Æo Cota‡Æo */
            run cdp/cdapi198fx.p (input RowObject.r-rowid,
                                  input 1, /* registro alterado -> elimina it-requisicao */
                                  input no,
                                  input-output table tt_xml_input_1,
                                  output table RowErrors append).
            if  return-value = "NOK" then 
                return "NOK".
        end.
        /*****************************/
    end.

    if pType = "Delete" then do:               
        IF requisicao.nome-abrev <> c-seg-usuario and substr(usuar-mater.char-1,10,1) = "N" then do: /* Altera Requisi‡Æo */
            {utp/ut-liter.i eliminar}
            {method/svc/errors/inserr.i &ErrorNumber="33913"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"} 
            return "NOK".
        end.
    
        IF  it-requisicao.situacao = 2          /* Fechada */
        OR (it-requisicao.situacao = 4
        AND NOT lElimOrdemIntegrMe) then do: /* Com Ordem */
            {utp/ut-liter.i Requisi‡Æo}
            {method/svc/errors/inserr.i &ErrorNumber="31232"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value + '~~~~' + entry(requisicao.situacao, c-lst-situacao)"}
            return "NOK".
        end.
    
        if  (    requisicao.tp-requis = 1 /* Requisi‡Æo Estoque */
             and RowObject.qt-atendida   > 0)
        or  (    requisicao.tp-requis    > 1 /* Solicita‡Æo Compra/Cota‡Æo */
             and RowObject.numero-ordem <> 0
             AND NOT lElimOrdemIntegrMe) then do:
            {method/svc/errors/inserr.i &ErrorNumber="1621"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}
            return "NOK".
        end.
    end.
    
    /* Valida‡äes Aprova‡Æo Eletr“nica */
    run validateEletronicApproval (input pType).
    if  return-value = "NOK" then
        return "NOK".

    /* Valida‡äes Investimentos */
    run validateInvestments (input pType).
    if  return-value = "NOK" then
        return "NOK".
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF BUFFER bf-it-requis FOR it-requisicao.
 
    find first requisicao
         where requisicao.nr-requisicao = RowObject.nr-requisicao exclusive-lock no-error.
         
    IF can-find(first it-requisicao
                     where it-requisicao.nr-requisicao = requisicao.nr-requisicao) /* Tem algum item na Req? */
    AND not can-find(first bf-it-requis
                     where bf-it-requis.nr-requisicao = requisicao.nr-requisicao
                     and bf-it-requis.situacao <> 2 
                     and bf-it-requis.situacao <> 4)    then do: /* Todos os itens estÆo Atendidos ou Fechados? */
 
        if  requisicao.tp-requis = 1 then /* requis */
            assign requisicao.situacao = 2. /* fechada */
        ELSE 
            assign requisicao.situacao = 4. /* com ordem */
            
        assign requisicao.estado   = 1. /* aprovada */ 
    end.

    IF  requisicao.situacao = 4 /* Com Ordem */
    AND lElimOrdemIntegrMe THEN DO:
    
        find first it-requisicao
            where rowid(it-requisicao) = RowObject.r-rowid exclusive-lock no-error.
        if  avail it-requisicao then
            assign it-requisicao.situacao  = 2 /* Fechada */
                   it-requisicao.narrativa = IF lElimOrdemIntegrMe THEN TRIM(it-requisicao.narrativa + " " + cNarrativaItem)
                                             ELSE it-requisicao.narrativa.
    
        IF  NOT CAN-FIND(FIRST it-requisicao 
                         WHERE it-requisicao.nr-requisicao = requisicao.nr-requisicao
                           AND it-requisicao.situacao <> 2 /* Fechada */
                           AND ROWID(it-requisicao)   <> RowObject.r-rowid) THEN DO:
            ASSIGN requisicao.situacao  = 2 /* Fechada */
                   requisicao.narrativa = trim(requisicao.narrativa + " " + cNarrativaItem).
        END.
    END. 
    
    find first requisicao
         where requisicao.nr-requisicao = RowObject.nr-requisicao NO-LOCK no-error.

    /*   Ivomar - revisar quando utilizado aprovacao eletronica
    else do:
            /*Aprovacao Eletronica controle Total 26/05/2003 */
            if ((    i-tipo-doc = 1
                 and substr(param-compra.char-2, 1, 3) = "sim")
            or (    i-tipo-doc = 2
                and substr(param-compra.char-2, 4, 3) = "sim")) 
                   and avail requisicao then do:
                assign l-pendente = no.

/*                 for each it-requisicao                                                       */
/*                     where it-requisicao.nr-requisicao = requisicao.nr-requisicao             */
/*                     no-lock:                                                                 */
/*                     run cdp/cdapi172.p (i-tipo-doc,rowid(it-requisicao), output l-pendente). */
/*                     if  l-pendente then leave.                                               */
/*                 end.                                                                         */
/*                 assign requisicao.situacao = 1  /* aberta */                                 */
/*                        requisicao.estado   = if  not l-pendente then 1 /* aprovada */        */
/*                                                                 else 2.                      */
/*                 for each it-requisicao                                                       */
/*                     where it-requisicao.nr-requisicao = requisicao.nr-requisicao             */
/*                     and (   it-requisicao.situacao = 1                                       */
/*                          or it-requisicao.situacao = 3) exclusive-lock:                      */
/*                     assign it-requisicao.estado     = requisicao.estado                      */
/*                            it-requisicao.nome-aprov = "".                                    */
/*                 end.                                                                         */
            end.
            else do:
                /*Aprovacao Eletronica controle por Item*/
                if  not can-find ( first b-it-requis
                        where b-it-requis.nr-requisicao = requisicao.nr-requisicao
                        and   b-it-requis.estado = 2 ) 
                then do: /* aprovada */
                    assign requisicao.situacao = 1  /* aberta */
                           requisicao.estado   = 1. /* aprovada */
                    if  valid-handle(h-v02in385) then
                        run pi-atualiza-estado in h-v02in385.
                end.
            END.
*/

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLastSequence DBOProgram 
PROCEDURE getLastSequence :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice item-req
  Parameters:  
               recebe valor do campo nr-requisicao
               recebe valor do campo sequencia
               recebe valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pnr-requisicao LIKE it-requisicao.nr-requisicao NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-sequencia  LIKE it-requisicao.sequencia     NO-UNDO.

    FIND LAST bfit-requisicao WHERE 
        bfit-requisicao.nr-requisicao = pnr-requisicao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfit-requisicao THEN 
        RETURN "NOK":U.
    ELSE DO:
        ASSIGN pnr-sequencia = bfit-requisicao.sequencia.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectedRequisitionReturn DBOFunction 
PROCEDURE selectedRequisitionReturn:
/*------------------------------------------------------------------------------
  Purpose: Devolucao de Requisicao atraves do botao "Devolver Automaticamente"
  Parameters: 
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR ttItRequisicaoSelec.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    EMPTY TEMP-TABLE RowErrors NO-ERROR.
    userCodeBlock:
    DO TRANSACTION ON ERROR UNDO, LEAVE userCodeBlock
                   ON STOP  UNDO, LEAVE userCodeBlock
                   ON QUIT  UNDO, LEAVE userCodeBlock:
       
        FOR EACH ttItRequisicaoSelec:

           IF CAN-FIND(FIRST bf-ttItRequisicaoSelec 
                       WHERE bf-ttItRequisicaoSelec.nr-requisicao <> ttItRequisicaoSelec.nr-requisicao) THEN DO:
                RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 55321, INPUT ""). /* Atender Selecionados nao permitido. */
                RETURN "NOK":U.
           END.

           EMPTY TEMP-TABLE ttItRequisicao-aux.

           CREATE ttItRequisicao-aux.
           BUFFER-COPY ttItRequisicaoSelec TO ttItRequisicao-aux.

           EMPTY TEMP-TABLE RowErrors NO-ERROR.
           
           RUN simplifiedRequisitionReturn (INPUT TABLE ttItRequisicao-aux,
                                            OUTPUT TABLE RowErrors).
           IF CAN-FIND(FIRST RowErrors 
                       WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
               UNDO userCodeBlock,  RETURN "NOK":U.
        END.
        
    END.
    
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE requisitionReturn DBOFunction 
PROCEDURE requisitionReturn:
/*------------------------------------------------------------------------------
  Purpose: Devolucao de Requisicao
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR ttItRequisicaoHTML.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
       
    DEFINE VARIABLE d-qtd-tot-dev      AS DECIMAL NO-UNDO.
    // DEFINE VARIABLE lDtValidadeVencida AS LOGICAL NO-UNDO.

    blk:
    DO  ON ERROR UNDO, LEAVE blk
        ON STOP  UNDO, LEAVE blk
        ON QUIT  UNDO, LEAVE blk: 

        EMPTY TEMP-TABLE ttSummaryInventoryBalance.
        EMPTY TEMP-TABLE ttSummaryAux.
        
        FOR EACH ttItRequisicaoHTML:

            ASSIGN d-qtd-tot-dev = ttItRequisicaoHTML.qt-a-devolver.

            RUN getItemMovement IN THIS-PROCEDURE(INPUT TRIM(STRING(ttItRequisicaoHTML.nr-requisicao,"999,999,999":U)),
                                                  INPUT ttItRequisicaoHTML.sequencia,
                                                  INPUT ttItRequisicaoHTML.it-codigo,
                                                  OUTPUT TABLE ttSummaryAux).

            IF c-nom-prog-upc-mg97   <> "" AND
               c-nom-prog-upc-mg97   <> ?  THEN DO:
               {include/i-epc200.i2 &CodEvent       = '"after_getItemMovement"'
                                    &CodParameter   = '"h-ttItRequisicao"'
                                    &ValueParameter = "string(TEMP-TABLE ttItRequisicaoHTML:HANDLE)"}
                             
               {include/i-epc200.i2 &CodEvent       = '"after_getItemMovement"'
                                    &CodParameter   = '"h-ttSummaryAux"'
                                    &ValueParameter = "string(TEMP-TABLE ttSummaryAux:HANDLE)"}
                             
               {include/i-epc201.i "after_getItemMovement"}
            END.
            
            EMPTY TEMP-TABLE ttSummaryInventoryBalance.

            FOR EACH ttSummaryAux BY ttSummaryAux.dt-trans DESC:
                IF d-qtd-tot-dev = 0 THEN LEAVE.

                IF d-qtd-tot-dev >= ttSummaryAux.qtidade-atu THEN DO:
                    ASSIGN 
                    ttSummaryAux.qt-a-atender = ttSummaryAux.qtidade-atu
                    d-qtd-tot-dev = d-qtd-tot-dev - ttSummaryAux.qtidade-atu.
                END.    
                ELSE DO:
                    ASSIGN 
                    ttSummaryAux.qt-a-atender = d-qtd-tot-dev
                    d-qtd-tot-dev = 0.
                END.
                
                IF ttSummaryAux.qt-a-atender > 0 THEN DO:
                    CREATE ttSummaryInventoryBalance.
                    BUFFER-COPY ttSummaryAux TO ttSummaryInventoryBalance.
                END.                
            END.
        END.
        
        /* ASSIGN lDtValidadeVencida = NO.
        
        RUN validateLot IN THIS-PROCEDURE (INPUT TODAY, 
                                           INPUT TABLE ttSummaryInventoryBalance,
                                           OUTPUT lDtValidadeVencida,
                                           OUTPUT TABLE RowErrors).
                                           
        IF lDtValidadeVencida THEN RETURN "NOK". */        
        
        FOR EACH ttSummaryInventoryBalance WHERE ttSummaryInventoryBalance.nr-requisicao = it-requisicao.nr-requisicao
                                           AND   ttSummaryInventoryBalance.sequencia     = it-requisicao.sequencia,     
        FIRST deposito WHERE deposito.cod-depos = ttSummaryInventoryBalance.cod-depos:
          EMPTY TEMP-TABLE ttSummaryAux.
          CREATE ttSummaryAux.
          BUFFER-COPY ttSummaryInventoryBalance TO ttSummaryAux.
          IF deposito.log-wms-externo THEN DO:
              RUN pi-cria-devol-wms-saas (INPUT TABLE ttSummaryAux, 
                                          OUTPUT TABLE RowErrors).
          END.
          ELSE DO:
              RUN materialRequisitionReturn IN THIS-PROCEDURE (INPUT TABLE ttSummaryAux,
                                                               INPUT TODAY, 
                                                               INPUT NO,
                                                               OUTPUT TABLE RowErrors).
          END.
        END.
                                                     
    END.

    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE simplifiedRequisitionReturn DBOFunction 
PROCEDURE simplifiedRequisitionReturn:
/*------------------------------------------------------------------------------
  Purpose: Devolucao de Requisicao Simplificada
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR ttItRequisicaoHTML.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
       
    DEFINE VARIABLE d-qtd-tot-dev      AS DECIMAL NO-UNDO.
    // DEFINE VARIABLE lDtValidadeVencida AS LOGICAL NO-UNDO.

    blk:
    DO  ON ERROR UNDO, LEAVE blk
        ON STOP  UNDO, LEAVE blk
        ON QUIT  UNDO, LEAVE blk: 

        EMPTY TEMP-TABLE ttSummaryInventoryBalance.
        EMPTY TEMP-TABLE ttSummaryAux.
        
        FOR EACH ttItRequisicaoHTML:

            FOR FIRST it-requisicao 
            FIELDS(it-codigo qt-a-devolver)
            NO-LOCK
            WHERE it-requisicao.nr-requisicao = ttItRequisicaoHTML.nr-requisicao 
              AND it-requisicao.sequencia     = ttItRequisicaoHTML.sequencia:
              
                ASSIGN d-qtd-tot-dev = it-requisicao.qt-a-devolver.
            END.
            
            RUN getItemMovement IN THIS-PROCEDURE(INPUT TRIM(STRING(ttItRequisicaoHTML.nr-requisicao,"999,999,999":U)),
                                                  INPUT ttItRequisicaoHTML.sequencia,
                                                  INPUT ttItRequisicaoHTML.it-codigo,
                                                  OUTPUT TABLE ttSummaryAux).
                
            IF c-nom-prog-upc-mg97   <> "" AND
              c-nom-prog-upc-mg97   <> ?  THEN DO:
               {include/i-epc200.i2 &CodEvent       = '"after_getItemMovement"'
                                    &CodParameter   = '"h-ttItRequisicao"'
                                    &ValueParameter = "string(TEMP-TABLE ttItRequisicaoHTML:HANDLE)"}

               {include/i-epc200.i2 &CodEvent       = '"after_getItemMovement"'
                                    &CodParameter   = '"h-ttSummaryAux"'
                                    &ValueParameter = "string(TEMP-TABLE ttSummaryAux:HANDLE)"}
                             
               {include/i-epc201.i "after_getItemMovement"}
            END.
            
            EMPTY TEMP-TABLE ttSummaryInventoryBalance.
            
            FOR EACH ttSummaryAux BY ttSummaryAux.dt-trans DESC:
                IF d-qtd-tot-dev = 0 THEN LEAVE.
                
                IF d-qtd-tot-dev >= ttSummaryAux.qtidade-atu THEN DO:
                    ASSIGN 
                    ttSummaryAux.qt-a-atender = ttSummaryAux.qtidade-atu
                    d-qtd-tot-dev = d-qtd-tot-dev - ttSummaryAux.qtidade-atu.
                END.
                ELSE DO:
                    ASSIGN 
                    ttSummaryAux.qt-a-atender = d-qtd-tot-dev
                    d-qtd-tot-dev = 0.
                END.
                
                IF ttSummaryAux.qt-a-atender > 0 THEN DO:
                    CREATE ttSummaryInventoryBalance.
                    BUFFER-COPY ttSummaryAux TO ttSummaryInventoryBalance.
                END.
            END. 
        END.  

        /* ASSIGN lDtValidadeVencida = NO.
        
        RUN validateLot IN THIS-PROCEDURE (INPUT TODAY, 
                                           INPUT TABLE ttSummaryInventoryBalance,
                                           OUTPUT lDtValidadeVencida,
                                           OUTPUT TABLE RowErrors).
                                           
        IF lDtValidadeVencida THEN RETURN "NOK". */
       
       FOR EACH ttSummaryInventoryBalance WHERE ttSummaryInventoryBalance.nr-requisicao = it-requisicao.nr-requisicao
                                          AND   ttSummaryInventoryBalance.sequencia     = it-requisicao.sequencia,     
       FIRST deposito WHERE deposito.cod-depos = ttSummaryInventoryBalance.cod-depos:
          EMPTY TEMP-TABLE ttSummaryAux.
          CREATE ttSummaryAux.
          BUFFER-COPY ttSummaryInventoryBalance TO ttSummaryAux.
          IF deposito.log-wms-externo THEN DO:
              RUN pi-cria-devol-wms-saas (INPUT TABLE ttSummaryAux, 
                                          OUTPUT TABLE RowErrors).
          END.
          ELSE DO:
              RUN materialRequisitionReturn IN THIS-PROCEDURE (INPUT TABLE ttSummaryAux,
                                                               INPUT TODAY, 
                                                               INPUT NO,
                                                               OUTPUT TABLE RowErrors).
          END.
      END.

    END.

    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END 
&ANALYZE-RESUME
*/

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateLot DBOFunction 
PROCEDURE validateLot:
/*------------------------------------------------------------------------------
  Purpose: Valida Lote com validade vencida    
  Parameters: dateMaterialProcessing => DATE
              ttSummaryInventoryBalance
              plDtValidadeVencida => Retorna se a data de validade do lote estÿ vencida
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER dateMaterialProcessing AS DATE    NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR ttSummaryInventoryBalance.
    DEFINE OUTPUT PARAMETER plDtValidadeVencida    AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
    
    userCodeBlock:
    DO ON ERROR UNDO, LEAVE userCodeBlock
       ON STOP  UNDO, LEAVE userCodeBlock
       ON QUIT  UNDO, LEAVE userCodeBlock:

        FOR EACH ttSummaryInventoryBalance 
           WHERE ttSummaryInventoryBalance.qt-a-atender > 0:
        
            FIND FIRST it-requisicao NO-LOCK
                 WHERE it-requisicao.nr-requisicao = ttSummaryInventoryBalance.nr-requisicao
                   AND it-requisicao.sequencia     = ttSummaryInventoryBalance.sequencia NO-ERROR.
            IF AVAIL it-requisicao THEN DO:
                FIND FIRST item NO-LOCK
                     WHERE item.it-codigo = it-requisicao.it-codigo NO-ERROR.
                IF  AVAIL item 
                AND item.tipo-con-est > 2 THEN DO:
                    ASSIGN plDtValidadeVencida = ttSummaryInventoryBalance.dt-vali-lote < dateMaterialProcessing.
                    IF plDtValidadeVencida THEN DO:
                        IF THIS-PROCEDURE:GET-SIGNATURE("createRowErrors") <> "" THEN
                            RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, 
                                                                  INPUT 55345, 
                                                                  INPUT STRING(ttSummaryInventoryBalance.dt-vali-lote) + "~~" + 
                                                                        ttSummaryInventoryBalance.lote +  "~~" +
                                                                        it-requisicao.it-codigo).
                        LEAVE userCodeBlock.
                    END.
                END.
            END.
        END.
        
    END.
    
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getItemMovement DBOFunction
PROCEDURE getItemMovement:
/*------------------------------------------------------------------------------
 Purpose: Carrega os movimentos de atendimento de uma requisi‡Æo (base para devolu‡Æo)
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-num-docto    AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-seq          AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo    AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttSummaryAux.

    DEFINE VARIABLE d-qtd-a-devolver AS DECIMAL NO-UNDO.

    FIND FIRST it-requisicao NO-LOCK
         WHERE it-requisicao.nr-requisicao = p-num-docto
           AND it-requisicao.sequencia     = p-seq NO-ERROR.
    
    IF NOT AVAILABLE it-requisicao THEN RETURN "NOK":U.
    
    FOR EACH movto-estoq NO-LOCK
       WHERE movto-estoq.nro-docto    = TRIM(STRING(p-num-docto,"999,999,999"))
         AND (movto-estoq.sequen-nf   = p-seq OR movto-estoq.num-sequen = p-seq)
         AND movto-estoq.it-codigo    = p-it-codigo
         AND movto-estoq.serie-docto  = "" 
         AND movto-estoq.cod-emitente = 0 
         AND movto-estoq.nat-operacao = " " 
         AND movto-estoq.tipo-trans   = 2   // Saida
         AND movto-estoq.esp-docto    = 30  // RM
         BY movto-estoq.nr-trans:
         
        ASSIGN d-qtd-a-devolver = movto-estoq.quantidade.
        
        IF d-qtd-a-devolver <= 0 THEN NEXT.
        
        FIND FIRST saldo-estoq no-lock
             WHERE saldo-estoq.it-codigo = p-it-codigo
               AND saldo-estoq.lote      = movto-estoq.lote NO-ERROR.
               
        FIND FIRST deposito NO-LOCK 
             WHERE deposito.cod-depos = movto-estoq.cod-depos NO-ERROR.
             

        CREATE ttSummaryAux.
        ASSIGN ttSummaryAux.nr-requisicao = p-num-docto
               ttSummaryAux.sequencia     = p-seq
               ttSummaryAux.cod-depos     = movto-estoq.cod-depos
               ttSummaryAux.cod-localiz   = movto-estoq.cod-localiz
               ttSummaryAux.lote          = movto-estoq.lote
               ttSummaryAux.cod-refer     = movto-estoq.cod-refer
               ttSummaryAux.dt-trans      = movto-estoq.dt-trans
               ttSummaryAux.qtidade-atu   = d-qtd-a-devolver
               ttSummaryAux.qt-a-atender  = 0
               ttSummaryAux.close         = no /* Reabrir Item da Requisicao */
               ttSummaryAux.dt-vali-lote  = saldo-estoq.dt-vali-lote
               ttSummaryAux.rw-movto      = STRING(ROWID(movto-estoq))
               ttSummaryAux.is-wms-saas   = deposito.log-wms-externo.
    END.

    RETURN "OK":U.
   
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE materialRequisitionReturn DBOFunction 
PROCEDURE materialRequisitionReturn :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR ttSummaryInventoryBalance.
    DEFINE INPUT  PARAMETER pDateMaterialReturn AS DATE    NO-UNDO.
    DEFINE INPUT  PARAMETER pManterFechada      AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    find first ttSummaryInventoryBalance no-lock.

    LOG-MANAGER:WRITE-MESSAGE (">>>> Ponto 1 ") NO-ERROR.
    LOG-MANAGER:WRITE-MESSAGE (">>>> Ponto 2 - " + STRING(ttSummaryInventoryBalance.sequencia)) NO-ERROR.
    LOG-MANAGER:WRITE-MESSAGE (">>>> Ponto 3 - " + STRING(ttSummaryInventoryBalance.nr-requisicao)) NO-ERROR.

    FIND FIRST it-requisicao EXCLUSIVE-LOCK
         WHERE it-requisicao.nr-requisicao = ttSummaryInventoryBalance.nr-requisicao
           AND it-requisicao.sequencia     = ttSummaryInventoryBalance.sequencia NO-ERROR.

    // se tiver ordem vai criar movimento igual ao CE0205
    IF it-requisicao.nr-ord-produ <> 0 THEN DO:
        RUN createRequisitionReturn(INPUT TABLE ttSummaryInventoryBalance, 
                                    OUTPUT TABLE RowErrors).
        RETURN.
    END.  

    RUN initializeHandles IN THIS-PROCEDURE.

    BLK:
    DO TRANSACTION ON ERROR UNDO BLK, LEAVE BLK
                   ON STOP  UNDO BLK, LEAVE BLK
                   ON QUIT  UNDO BLK, LEAVE BLK:

        FOR FIRST param-global FIELDS(modulo-in) NO-LOCK: END.
        FOR FIRST param-estoq  FIELDS(int-1)     NO-LOCK: END.
       
        IF RETURN-VALUE = "NOK":U THEN
            UNDO BLK, RETURN "NOK":U.
        
        RUN validateReturnRecord IN THIS-PROCEDURE(INPUT TABLE ttSummaryInventoryBalance,
                                                   INPUT pDateMaterialReturn,
                                                   OUTPUT TABLE RowErrors).
        IF RETURN-VALUE = "NOK":U THEN
            UNDO BLK, RETURN "NOK":U.
                        
        /* epc */
        {cep/ceapi400.i1 "BeforeCreateMaterialRequisitionReturn"}
        
        IF AVAILABLE param-global THEN
            ASSIGN l-modulo-in = param-global.modulo-in AND it-requisicao.num-ord-inv <> 0.

        ASSIGN l-ordem-inv = l-unidade-negocio AND it-requisicao.num-ord-inv <> 0
               i-seq = 0.

        IF l-ordem-inv THEN
             RUN cria-tt-movto-un IN THIS-PROCEDURE.
            
        IF l-ordem-inv 
        AND NOT CAN-FIND(FIRST tt-movto-un)THEN DO:
            IF CAN-FIND(FIRST tt-erro-inv) THEN DO:
                RUN getRowErrorsByTTErro IN h-mceUtils(INPUT-OUTPUT iSeqRowErrors,
                                                       INPUT  TABLE tt-erro-inv, /* retornada do procedimento retornaMatrizUnidNegoc */
                                                       OUTPUT TABLE RowErrors).
                UNDO BLK, RETURN "NOK":U.
            END.
        END.
        ELSE DO:
            RUN cria-tt-matriz IN THIS-PROCEDURE.
        END.
           
        FOR EACH ttSummaryInventoryBalance:
            RUN cria-tt-movto IN THIS-PROCEDURE(INPUT pDateMaterialReturn).

            FIND FIRST deposito NO-LOCK
                 WHERE deposito.cod-depos = it-requisicao.cod-depos 
                   AND deposito.log-gera-wms = YES NO-ERROR.
                   
            IF AVAILABLE deposito THEN DO:
                RUN integraWMS IN THIS-PROCEDURE.
                IF RETURN-VALUE = "NOK" THEN
                    UNDO BLK, RETURN "NOK":U.
            END.
        END.

        RUN efetivaDevolucao IN THIS-PROCEDURE.
        IF RETURN-VALUE = "NOK" THEN
            UNDO BLK, RETURN "NOK":U.
            
        RUN atualizaQuantidadesItem IN THIS-PROCEDURE.



        FOR EACH tt-movto:
            /* Modulo Investimentos */
            IF l-modulo-in THEN DO:
                ASSIGN i-emp-inv  = it-requisicao.ep-codigo
                       i-ord-inv  = it-requisicao.num-ord-inv.
            END.
        
        
            ASSIGN r-mov-inv = tt-movto.r-mov-inv.
            
            IF l-modulo-in THEN DO:  /* Modulo Investimentos */
                RUN gera-movto-apr IN THIS-PROCEDURE.
                IF RETURN-VALUE = "NOK":U THEN DO:
                    UNDO BLK,RETURN "NOK":U.
                END.
            END.

            /********************************************************
             ** Devolucao de Reservas das Ordens de Producao ~\ Manutencao, 
             ** conforme as requisicoes~\solicitacoes por Ordem (CD0738)
             *********************************************************/  
            RUN devolveRerervasOP IN THIS-PROCEDURE(INPUT ROWID(it-requisicao), INPUT r-mov-inv).
             
            &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
                 RUN integraEAI IN THIS-PROCEDURE(INPUT pDateMaterialReturn).
                 IF RETURN-VALUE = "NOK":U THEN
                      UNDO BLK,RETURN "NOK":U.
            &ENDIF
        END.

        RUN atualizaSituacaoRequisicao IN THIS-PROCEDURE(INPUT pDateMaterialReturn, INPUT pManterFechada).

         /* epc */
        {cep/ceapi400.i1 "AfterCreateMaterialRequisitionReturn"}

    END.

    RUN destroyHandles IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateReturnRecord DBOFunction 
PROCEDURE validateReturnRecord PRIVATE:
/*------------------------------------------------------------------------------
  Purpose: Realizar validacoes iniciais para a devolucao
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR ttSummaryInventoryBalance.
    DEFINE INPUT  PARAMETER pDateMaterialReturn AS DATE NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
    
    DEFINE VARIABLE de-tot-qt-a-devolver AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE i-number-error       AS DECIMAL    NO-UNDO.    
    DEFINE VARIABLE c-param-msg          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-msg                AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-help               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE i-seq LIKE RowErrors.ErrorSequence NO-UNDO.

    IF NOT CAN-FIND(FIRST ttSummaryInventoryBalance) THEN DO:
        RUN getRowErrorsByCode IN h-mceUtils(INPUT-OUTPUT iSeqRowErrors, 
                                             INPUT 55263,  /* Devolucao Invalida! */
                                             INPUT "",     /* Nao foi informado nenhum saldo para a devolucao.*/
                                             OUTPUT TABLE RowErrors).
        RETURN "NOK":U.
    END.

    FIND FIRST ttSummaryInventoryBalance NO-ERROR.

    RUN validateLockTable IN THIS-PROCEDURE(INPUT ttSummaryInventoryBalance.nr-requisicao,
                                            INPUT ttSummaryInventoryBalance.sequencia).
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK":U.

    /* LIBERA LOCK REGISTRO */
    FIND FIRST it-requisicao NO-LOCK
         WHERE it-requisicao.nr-requisicao = ttSummaryInventoryBalance.nr-requisicao
           AND it-requisicao.sequencia     = ttSummaryInventoryBalance.sequencia NO-ERROR.

    FOR FIRST item FIELDS(fraciona tipo-contr un tipo-con-est) NO-LOCK
        WHERE item.it-codigo = it-requisicao.it-codigo: END.

    IF NOT AVAILABLE it-requisicao THEN DO:
        RUN getRowErrorsByCode IN h-mceUtils(INPUT-OUTPUT iSeqRowErrors, 
                                             INPUT 5068,  /* Item invalido para Requisicao */
                                             INPUT RETURN-VALUE,
                                             OUTPUT TABLE RowErrors).
        RETURN "NOK":U.
    END.

    FOR EACH ttSummaryInventoryBalance
        BREAK BY ttSummaryInventoryBalance.sequencia:

        IF FIRST-OF (ttSummaryInventoryBalance.sequencia) THEN
            ASSIGN de-tot-qt-a-devolver = 0. 
              
        /* VALIDACAO DATA MOVIMENTACAO */
        IF pDateMaterialReturn < ttSummaryInventoryBalance.dt-trans THEN DO:
            RUN getRowErrorsByCode IN h-mceUtils(INPUT-OUTPUT iSeqRowErrors, 
                                                 INPUT 4489,  /* Data da devolucao invalida!*/
                                                 INPUT "",
                                                 OUTPUT TABLE RowErrors).
            RETURN "NOK":U.
        END.
        
        /* Valida se foi informado quantidade a devolver */
        IF NOT CAN-FIND(FIRST ttSummaryInventoryBalance 
                        WHERE ttSummaryInventoryBalance.qt-a-atender > 0) THEN DO:
            RUN getRowErrorsByCode IN h-mceUtils(INPUT-OUTPUT iSeqRowErrors, 
                                                 INPUT 55301,
                                                 INPUT "",
                                                 OUTPUT TABLE RowErrors).
            RETURN "NOK":U.
        END.
        
        /* Valida se foi informado quantidade negativo */
        IF CAN-FIND(FIRST ttSummaryInventoryBalance 
                    WHERE ttSummaryInventoryBalance.qt-a-atender < 0) THEN DO:
            RUN getRowErrorsByCode IN h-mceUtils(INPUT-OUTPUT iSeqRowErrors, 
                                                 INPUT 55300,
                                                 INPUT "",
                                                 OUTPUT TABLE RowErrors).
            RETURN "NOK":U.
        END.
        
        /*Valida se o valor disponivel ‚ menor que o valor informado */
        IF ttSummaryInventoryBalance.qt-a-atender > ttSummaryInventoryBalance.qtidade-atu THEN DO:        
            CASE item.tipo-con-est:
                WHEN 3 THEN DO: /* lote */
                 ASSIGN i-number-error = 55276
                        c-param-msg = "'" + ttSummaryInventoryBalance.cod-depos + "'~~" + 
                                      "'" + ttSummaryInventoryBalance.cod-localiz + "'~~" +
                                      "'" + ttSummaryInventoryBalance.lote + "'".
                
                END.
                WHEN 4 THEN DO: /* referencia */
                    ASSIGN i-number-error = 55299
                           c-param-msg =  "'" + ttSummaryInventoryBalance.cod-depos   + "'~~" + 
                                          "'" + ttSummaryInventoryBalance.cod-localiz + "'~~" +
                                          "'" + ttSummaryInventoryBalance.lote + "'~~" +
                                          "'" + ttSummaryInventoryBalance.cod-refer + "'".
                END.
                OTHERWISE DO:
                     ASSIGN i-number-error = 55298
                            c-param-msg = "'" + ttSummaryInventoryBalance.cod-depos + "'~~" + 
                                          "'" + ttSummaryInventoryBalance.cod-localiz + "'".
                END.
            
            END CASE.
        
        
             RUN getRowErrorsByCode IN h-mceUtils(INPUT-OUTPUT iSeqRowErrors, 
                                                  INPUT i-number-error,
                                                  INPUT c-param-msg,
                                                  OUTPUT TABLE RowErrors).
             RETURN "NOK":U.
        END.

        ASSIGN de-tot-qt-a-devolver = de-tot-qt-a-devolver + ttSummaryInventoryBalance.qt-a-atender.

        /* VALIDACAO QUANTIDADE A DEVOLVER */
        IF LAST-OF (ttSummaryInventoryBalance.sequencia) THEN DO:

            IF de-tot-qt-a-devolver = 0 THEN DO:
                ASSIGN c-param-msg = STRING(ttSummaryInventoryBalance.sequencia) + "~~" + STRING(ttSummaryInventoryBalance.nr-requisicao).

                RUN getRowErrorsByCode IN h-mceUtils(INPUT-OUTPUT iSeqRowErrors, 
                                                     INPUT 55264,  /* Quantidade a devolver deve ser maior que zero!*/
                                                     INPUT c-param-msg,
                                                     OUTPUT TABLE RowErrors).
                RETURN "NOK":U.
            END.

            IF de-tot-qt-a-devolver > it-requisicao.qt-a-devolver THEN DO:
                ASSIGN c-param-msg = STRING(de-tot-qt-a-devolver) + "~~" + STRING(it-requisicao.qt-a-devolver).
                RUN getRowErrorsByCode IN h-mceUtils(INPUT-OUTPUT iSeqRowErrors, 
                                                     INPUT 55267,  /* Quantidade a devolver excede saldo dispon­vel. */
                                                     INPUT c-param-msg,
                                                     OUTPUT TABLE RowErrors).
                RETURN "NOK":U.
            END.
        END.
            
        
    END.
    
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateLockTable DBOFunction 
PROCEDURE validateLockTable PRIVATE:
/*------------------------------------------------------------------------------
  Purpose: Verifica se o registro estÿ preso com outro usuÿrio
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pNrRequest AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pSequence  AS INTEGER NO-UNDO.

    /* FIND COM EXCLUSIVE-LOCK PARA VERIFICACAO DA UTILIZACAO DA TABELA POR OUTRO USUARIO */
    FIND FIRST it-requisicao EXCLUSIVE-LOCK
         WHERE it-requisicao.nr-requisicao = ttSummaryInventoryBalance.nr-requisicao
           AND it-requisicao.sequencia     = ttSummaryInventoryBalance.sequencia NO-ERROR NO-WAIT.

    IF LOCKED it-requisicao THEN DO:
        {utp/ut-liter.i "Requisi‡Æo" *}
        RUN getRowErrorsByCode IN h-mceUtils(INPUT-OUTPUT iSeqRowErrors, 
                                             INPUT 468,  /* &1 est˜ sendo atualizado(a) ! */
                                             INPUT RETURN-VALUE,
                                             OUTPUT TABLE RowErrors).
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cria-tt-movto-un DBOFunction 
PROCEDURE cria-tt-movto-un PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
    IF VALID-HANDLE(h-boiv029) THEN
        RUN retornaMatrizUnidNegoc IN h-boiv029 (INPUT it-requisicao.num-ord-inv,
                                                 OUTPUT TABLE tt-matriz,
                                                 OUTPUT TABLE tt-erro-inv).

    IF  AVAILABLE ITEM 
    AND NOT item.fraciona
    AND l-unidade-negocio
    AND item.tipo-contr <> 4 /* Dýbito Direto (i09in122.i) */
    AND it-requisicao.num-ord-inv <> 0
    AND CAN-FIND(FIRST tt-matriz) THEN DO:
        FOR EACH tt-matriz:
            ASSIGN i-seq = i-seq + 1.
            CREATE tt-movto-un.
            ASSIGN tt-movto-un.i-sequen      = i-seq
                   tt-movto-un.cod-unid-neg  = tt-matriz.cod-unid-neg
                   tt-movto-un.perc-unid-neg = tt-matriz.perc-rateio.
            DELETE tt-matriz.
        END.
    END.                        
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cria-tt-matriz DBOFunction 
PROCEDURE cria-tt-matriz PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
    CREATE tt-matriz.
    ASSIGN tt-matriz.cod-unid-neg = it-requisicao.cod-unid-negoc
           tt-matriz.perc-rateio  = 100.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cria-tt-movto DBOFunction 
PROCEDURE cria-tt-movto PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pDateMaterialReturn AS DATE NO-UNDO.
    
    FIND FIRST movto-estoq NO-LOCK
         WHERE ROWID(movto-estoq) = TO-ROWID(ttSummaryInventoryBalance.rw-movto) NO-ERROR.    

    FOR EACH tt-matriz:
                
        CREATE tt-movto.
        ASSIGN tt-movto.cod-depos      = ttSummaryInventoryBalance.cod-depos
               tt-movto.cod-emitente   = 0
               tt-movto.cod-estabel    = it-requisicao.cod-estabel
               tt-movto.cod-refer      = ttSummaryInventoryBalance.cod-refer
               tt-movto.ct-codigo      = it-requisicao.ct-codigo
               tt-movto.descricao-db   = it-requisicao.narrativa
               tt-movto.dt-nf-saida    = IF AVAIL movto-estoq THEN movto-estoq.dt-trans ELSE ?
               tt-movto.dt-trans       = pDateMaterialReturn
               tt-movto.esp-docto      = 7 /* DRM */
               tt-movto.i-sequen       = i-seq
               tt-movto.it-codigo      = it-requisicao.it-codigo
               tt-movto.cod-localiz    = ttSummaryInventoryBalance.cod-localiz
               tt-movto.lote           = ttSummaryInventoryBalance.lote
               tt-movto.nat-operacao   = ""
               tt-movto.nro-docto      = STRING(it-requisicao.nr-requisicao,"999,999,999":U)
               tt-movto.num-sequen     = it-requisicao.sequencia
               tt-movto.sequen-nf      = it-requisicao.sequencia
               tt-movto.numero-ordem   = 0
               tt-movto.peso-liquido   = 0
               tt-movto.quantidade     = (ttSummaryInventoryBalance.qt-a-atender * tt-matriz.perc-rateio) / 100
               tt-movto.referencia     = ""
               tt-movto.sc-codigo      = it-requisicao.sc-codigo
               tt-movto.serie-docto    = ""
               tt-movto.tipo-preco     = 0
               tt-movto.tipo-trans     = 1 /* entrada */
               tt-movto.tipo-valor     = 2
               tt-movto.un             = IF AVAILABLE ITEM THEN item.un ELSE ""
               tt-movto.cod-prog-orig  = "dvReqPOUI":U
               tt-movto.usuario        = c-seg-usuario
               tt-movto.cod-versao-integracao = 1.

        IF l-ordem-inv THEN
            ASSIGN tt-movto.num-ord-inv    = it-requisicao.num-ord-inv.
        
        IF l-unidade-negocio THEN
            ASSIGN tt-movto.cod-unid-negoc = tt-matriz.cod-unid-neg.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE integraWMS DBOFunction 
PROCEDURE integraWMS PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF SUBSTRING(it-requisicao.char-1,15,1) = "Y":U THEN DO:
        {utp/ut-liter.i "Sequˆncia" *}
        RUN getRowErrorsByCode IN h-mceUtils(INPUT-OUTPUT iSeqRowErrors, 
                                             INPUT 34633,  /*&1 pendente*/
                                             INPUT RETURN-VALUE,
                                             OUTPUT TABLE RowErrors).
         RETURN "NOK":U. 
    END.

    RUN cep/ceapi033.p (INPUT it-requisicao.nr-requisicao,
                        INPUT it-requisicao.sequencia,
                        INPUT it-requisicao.it-codigo,
                        INPUT ttSummaryInventoryBalance.cod-depos,
                        INPUT ttSummaryInventoryBalance.lote,
                        INPUT ttSummaryInventoryBalance.cod-refer,
                        INPUT ttSummaryInventoryBalance.qt-a-atender,
                        OUTPUT TABLE tt-erro-aux).
                        
    IF CAN-FIND (FIRST tt-erro-aux) THEN DO:
        RUN getRowErrorsByTTErro IN h-mceUtils(INPUT-OUTPUT iSeqRowErrors,
                                               INPUT TABLE tt-erro-aux,
                                               OUTPUT TABLE RowErrors).
        RETURN "NOK":U.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-qtidade-atu DBOFunction
PROCEDURE pi-retorna-qtidade-atu: 
/*------------------------------------------------------------------------------
    Purpose:  Retornar a quantidade atual disponivel para devolucao
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nro-docto    AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-sequen   AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo    AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-depos    AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-lote         AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-localiz  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-refer    AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER d-qtd-tot-dev  AS DECIMAL   NO-UNDO.
    DEFINE VAR              qtd-proces-wms AS DECIMAL   NO-UNDO.
    
         IF CAN-FIND (FIRST deposito WHERE deposito.cod-depos = p-cod-depos AND deposito.log-wms-externo)  THEN DO:

            ASSIGN qtd-proces-wms = 0.
         
            FOR EACH  ws-atend-devol-it-requis NO-LOCK 
                WHERE ws-atend-devol-it-requis.nr-requisicao  = INT(p-nro-docto)
                AND   ws-atend-devol-it-requis.seq-it-requis  = p-num-sequen
                AND   ws-atend-devol-it-requis.it-codigo      = p-it-codigo
                AND   ws-atend-devol-it-requis.idi-sit-docto  < 3
                and   ws-atend-devol-it-requis.idi-tipo-movto = 2: // (1 - Em Processo, 2 - Em Processo WMS)
                    
                ASSIGN qtd-proces-wms = qtd-proces-wms + (ws-atend-devol-it-requis.qtd-requisitada - ws-atend-devol-it-requis.qtd-movto). // (2 - Devolucao)
            END.
         
         END.

    FOR EACH bf-movto-estoq NO-LOCK
       WHERE bf-movto-estoq.nro-docto    = TRIM(STRING(p-nro-docto,"999,999,999"))
         AND (bf-movto-estoq.sequen-nf   = p-num-sequen or bf-movto-estoq.num-sequen = p-num-sequen)
         AND bf-movto-estoq.it-codigo    = p-it-codigo
         AND bf-movto-estoq.serie-docto  = "" 
         AND bf-movto-estoq.cod-emitente = 0 
         AND bf-movto-estoq.nat-operacao = " "
         AND bf-movto-estoq.lote         = p-lote
         AND bf-movto-estoq.cod-depos    = p-cod-depos
         AND bf-movto-estoq.cod-localiz  = p-cod-localiz
         AND bf-movto-estoq.cod-refer    = p-cod-refer:
         
           ASSIGN d-qtd-tot-dev = IF (bf-movto-estoq.esp-docto = 7 or bf-movto-estoq.esp-docto = 5) THEN /* Entrada - DRM */
                                     d-qtd-tot-dev - bf-movto-estoq.quantidade
                                 ELSE IF (bf-movto-estoq.esp-docto = 30 or bf-movto-estoq.esp-docto = 28) THEN /* Saida - RM */
                                     d-qtd-tot-dev + bf-movto-estoq.quantidade
                                 ELSE d-qtd-tot-dev
                                 .
           
    
    END.

    ASSIGN d-qtd-tot-dev = d-qtd-tot-dev - qtd-proces-wms.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE efetivaDevolucao DBOFunction 
PROCEDURE efetivaDevolucao PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF CAN-FIND(FIRST tt-movto-un) THEN
        RUN pi-valida-movto-uneg IN h-ceapi001k (INPUT TABLE tt-movto-un).  

    RUN pi-execute IN h-ceapi001k (INPUT-OUTPUT TABLE tt-movto,
                                   INPUT-OUTPUT TABLE tt-erro-ceapi001k,
                                   INPUT YES).
                                   
    DELETE PROCEDURE h-ceapi001k.                              
                                               
    IF CAN-FIND(FIRST tt-erro-ceapi001k) THEN DO:
        FOR EACH tt-erro-ceapi001k:
            RUN createRowErrors IN THIS-PROCEDURE(INPUT 2, INPUT tt-erro-ceapi001k.cd-erro, INPUT tt-erro-ceapi001k.mensagem).      
        END.
        RETURN "NOK".
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaQuantidadesItem DBOFunction 
PROCEDURE atualizaQuantidadesItem PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FOR EACH ttSummaryInventoryBalance:
        
        FIND FIRST it-requisicao EXCLUSIVE-LOCK
             WHERE it-requisicao.nr-requisicao = ttSummaryInventoryBalance.nr-requisicao
               AND it-requisicao.sequencia     = ttSummaryInventoryBalance.sequencia NO-ERROR.
    
        ASSIGN it-requisicao.qt-devolvida  = it-requisicao.qt-devolvida   + ttSummaryInventoryBalance.qt-a-atender /*Qt devolvida*/
               it-requisicao.qt-a-devolver = it-requisicao.qt-a-devolver  - ttSummaryInventoryBalance.qt-a-atender /*Qt devolvida*/
               it-requisicao.qt-atendida   = it-requisicao.qt-atendida    - ttSummaryInventoryBalance.qt-a-atender /*Qt devolvida*/
               it-requisicao.qt-a-atender  = it-requisicao.qt-requisitada - it-requisicao.qt-atendida.
               
        IF it-requisicao.qt-a-atender < 0 AND 
            CAN-FIND (FIRST ws-atend-devol-requis-job NO-LOCK
                      WHERE ws-atend-devol-requis-job.nr-requisicao = ttSummaryInventoryBalance.nr-requisicao
                        AND ws-atend-devol-requis-job.seq-it-requis = ttSummaryInventoryBalance.sequencia) THEN           
            ASSIGN it-requisicao.qt-a-atender = 0.   
                        
    END.
     
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gera-movto-apr DBOFunction 
PROCEDURE gera-movto-apr PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-in2108) THEN DO:
        RUN pi-execute IN h-in2108.
        IF  RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN h-in2108(OUTPUT TABLE RowErrors).
            RETURN "NOK":U.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.    
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE integraEAI DBOFunction 
PROCEDURE integraEAI PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pDateMaterialReturn AS DATE NO-UNDO.
    DEFINE VARIABLE h-ceapi310 AS HANDLE NO-UNDO.

    /* Carrega a variavel global v_log_eai2_ativado */
    RUN cdp/cd0101i.p. 

    /* Integracao EMS EAI2.0 AppointmentCost */
    IF NOT VALID-HANDLE(h-ceapi310) OR
       h-ceapi310:TYPE <> "PROCEDURE":U OR
       h-ceapi310:FILE-NAME <> "cep/ceapi310.p":U THEN DO:
       RUN cep/ceapi310.p PERSISTENT SET h-ceapi310.
    END.

    FOR EACH ttSummaryInventoryBalance:

        RUN pi-sendDelete IN h-ceapi310 (BUFFER it-requisicao, 
                                         INPUT pDateMaterialReturn, 
                                         INPUT ttSummaryInventoryBalance.qt-a-atender, 
                                         OUTPUT TABLE RowErrors).
    END.

    IF VALID-HANDLE(h-ceapi310) AND
       h-ceapi310:TYPE = "PROCEDURE":U AND
       h-ceapi310:FILE-NAME = "cep/ceapi310.p":U THEN DO:
       DELETE PROCEDURE h-ceapi310 NO-ERROR.
       ASSIGN h-ceapi310 = ?.
    END.

    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.    
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaSituacaoRequisicao DBOFunction 
PROCEDURE atualizaSituacaoRequisicao PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: situacao: 1- aberta ; 2 - fechada
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pDateMaterialReturn AS DATE    NO-UNDO.
    DEFINE INPUT PARAMETER pManterFechada      AS LOGICAL NO-UNDO.

    FIND FIRST requisicao EXCLUSIVE-LOCK
         WHERE requisicao.nr-requisicao = it-requisicao.nr-requisicao NO-ERROR.
    IF AVAILABLE requisicao THEN DO:

        ASSIGN requisicao.dt-devol = pDateMaterialReturn.

        IF NOT pManterFechada THEN DO:
             ASSIGN requisicao.situacao    = 1
                    it-requisicao.situacao = 1.
        END.
        ELSE DO: 
        
            ASSIGN it-requisicao.qt-a-atender = 0.
            ASSIGN it-requisicao.qt-requisitada = it-requisicao.qt-atendida.
            
            /*** INVESTIMENTOS ***/
            IF CONNECTED("mginv")
            AND param-global.modulo-in
            AND it-requisicao.num-ord-inv <> 0 THEN DO:

                RUN inp/in2101a.p(INPUT ROWID(requisicao), 
                                  INPUT ROWID(it-requisicao), 
                                  INPUT "Modifica",
                                  INPUT NO, /* exibe mensagens de erro/alerta em tela */
                                  OUTPUT TABLE RowErrors APPEND). 
                IF CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorSubType = "error") THEN RETURN "NOK".  

            END.
            /*********************/   
        END.
        
        RELEASE requisicao.
        RELEASE it-requisicao.
    END.

    RETURN "OK":U.
END PROCEDURE.    
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE devolveRerervasOP DBOFunction 
PROCEDURE devolveRerervasOP PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prw-it-requisicao AS ROWID NO-UNDO.
    DEFINE INPUT PARAMETER prw-mov-inv       AS ROWID NO-UNDO.

    IF  CAN-FIND(FIRST funcao 
                 WHERE funcao.cd-funcao = "spp-int-req-om":U
                   AND funcao.ativo     = TRUE) THEN DO:

        RUN cdp/cd0742e.p (INPUT ROWID(it-requisicao),  /** it-requisicao **/
                           INPUT "MSG":U,
                           INPUT prw-mov-inv).  /** movto-estoq   **/
    END.

    RETURN "OK":U.
END PROCEDURE.    
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-devol-wms-saas B-table-Win 
PROCEDURE pi-cria-devol-wms-saas :
/*------------------------------------------------------------------------------
  Purpose:        
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR ttSummaryInventoryBalance.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
    
    DEF VAR c-msg-valida               AS CHARACTER  NO-UNDO.
    DEF VAR i-seq-atend-devol          AS INTEGER    NO-UNDO.
    DEF VAR de-qtde-atend-wms          AS DECIMAL    NO-UNDO.        
    DEF VAR de-qtde-requis-wms         AS DECIMAL    NO-UNDO.  
    DEF VAR de-qtde-digitada           AS DECIMAL    NO-UNDO. 
    DEF VAR de-qtde-devol-wms          AS DECIMAL    NO-UNDO.
    DEF VAR de-qtde-em-devol-wms       AS DECIMAL    NO-UNDO.
    DEF VAR c-msg                      AS CHARACTER  NO-UNDO.
    DEF VAR c-help                     AS CHARACTER  NO-UNDO.
    DEF VAR i-seq LIKE RowErrors.ErrorSequence       NO-UNDO.
    
    FIND FIRST ttSummaryInventoryBalance NO-ERROR.
    
    FIND FIRST it-requisicao NO-LOCK 
         WHERE it-requisicao.nr-requisicao = ttSummaryInventoryBalance.nr-requisicao
           AND it-requisicao.sequencia     = ttSummaryInventoryBalance.sequencia NO-ERROR.
    IF NOT AVAIL it-requisicao THEN DO:
    
        {utp/ut-table.i movind it-requisicao 1}
        RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, INPUT 5490, INPUT RETURN-VALUE).                 
        RETURN "NOK":U.  
    END.

    IF NOT CAN-FIND(FIRST ws-atend-devol-it-requis NO-LOCK
                    WHERE ws-atend-devol-it-requis.nr-requisicao  = it-requisicao.nr-requisicao
                      AND ws-atend-devol-it-requis.seq-it-requis  = it-requisicao.sequencia
                      AND ws-atend-devol-it-requis.it-codigo      = it-requisicao.it-codigo
                      AND ws-atend-devol-it-requis.idi-tipo-movto = 1    // (1 - Atendimento)˜
                      AND (ws-atend-devol-it-requis.idi-sit-docto = 2 OR // (2 - Em Processo WMS)
                           ws-atend-devol-it-requis.idi-sit-docto = 3))  // (3 - Conclu­do)
    THEN DO: 
    
        // Item da Requisicao nao possui Qtde. Atendida no WMS SAAS 
         RUN createRowErrors IN THIS-PROCEDURE(INPUT 1, 
                                               INPUT 57967, 
                                               INPUT TRIM(it-requisicao.it-codigo)                + "~~":U  +
                                                     TRIM(STRING(it-requisicao.sequencia,">>>9")) + "~~":U  +                   
                                                     TRIM(STRING(it-requisicao.nr-requisicao,">>>,>>>,>>9")) ).
        RETURN "NOK":U.                                 
    END.
    
    ASSIGN de-qtde-atend-wms = 0.
    FOR EACH ws-atend-devol-it-requis NO-LOCK
       WHERE ws-atend-devol-it-requis.nr-requisicao  = it-requisicao.nr-requisicao
         AND ws-atend-devol-it-requis.seq-it-requis  = it-requisicao.sequencia
         AND ws-atend-devol-it-requis.it-codigo      = it-requisicao.it-codigo
         AND ws-atend-devol-it-requis.idi-tipo-movto = 1    // (1 - Atendimento)
         AND (ws-atend-devol-it-requis.idi-sit-docto = 2 OR // (2 - Em Processo WMS)
              ws-atend-devol-it-requis.idi-sit-docto = 3):  // (3 - Conclu­do)
        ASSIGN de-qtde-atend-wms = de-qtde-atend-wms + ws-atend-devol-it-requis.qtd-movto.         
    END.

    ASSIGN de-qtde-em-devol-wms = 0.
    FOR EACH ws-atend-devol-it-requis NO-LOCK
       WHERE ws-atend-devol-it-requis.nr-requisicao  = it-requisicao.nr-requisicao
         AND ws-atend-devol-it-requis.seq-it-requis  = it-requisicao.sequencia
         AND ws-atend-devol-it-requis.it-codigo      = it-requisicao.it-codigo
         AND ws-atend-devol-it-requis.idi-tipo-movto = 2  // (2 - Devolucao)
         AND ws-atend-devol-it-requis.idi-sit-docto  = 2 // (2 - Em Processo WMS)
         AND ws-atend-devol-it-requis.qtd-movto < ws-atend-devol-it-requis.qtd-requisitada:
        ASSIGN de-qtde-em-devol-wms = de-qtde-em-devol-wms + (ws-atend-devol-it-requis.qtd-requisitada - ws-atend-devol-it-requis.qtd-movto).
    END.
    
    FOR EACH ws-atend-devol-it-requis NO-LOCK
       WHERE ws-atend-devol-it-requis.nr-requisicao  = it-requisicao.nr-requisicao
         AND ws-atend-devol-it-requis.seq-it-requis  = it-requisicao.sequencia
         AND ws-atend-devol-it-requis.it-codigo      = it-requisicao.it-codigo
         AND ws-atend-devol-it-requis.idi-tipo-movto = 2   // (2 - Devolucao)
         AND (ws-atend-devol-it-requis.idi-sit-docto = 1): // (1 - Em Processo)   
        ASSIGN de-qtde-em-devol-wms = de-qtde-em-devol-wms + ws-atend-devol-it-requis.qtd-requisitada.         
    END.       
    
    ASSIGN de-qtde-digitada = ttSummaryInventoryBalance.qt-a-atender.
    
    IF (it-requisicao.qt-atendida - de-qtde-em-devol-wms) < de-qtde-digitada THEN DO:
    
        // 57968: Item sem saldo para devolucao da requisicao no WMS SAAS!
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 57968,
                          INPUT "").
        ASSIGN c-msg = TRIM(RETURN-VALUE).
                    
        RUN utp/ut-msgs.p (INPUT "help":U,
                           INPUT 57968,
                           INPUT TRIM(it-requisicao.it-codigo)                                         + "~~":U +
                                 TRIM(STRING(it-requisicao.sequencia,">>>9"))                          + "~~":U +                   
                                 TRIM(STRING(it-requisicao.nr-requisicao,">>>,>>>,>>9"))     + CHR(10) + "~~":U + 
                                 TRIM(STRING(it-requisicao.qt-atendida,">>>,>>>,>>9.9999"))  + CHR(10) + "~~":U + 
                                 TRIM(STRING(it-requisicao.qt-devolvida,">>>,>>>,>>9.9999")) + CHR(10) + "~~":U +
                                 TRIM(STRING(de-qtde-em-devol-wms,">>>,>>>,>>9.9999"))       + CHR(10) + "~~":U +                                
                                 TRIM(STRING(de-qtde-digitada,">>>,>>>,>>9.9999"))           + CHR(10) + "~~":U).
                                  
        ASSIGN c-help = TRIM(RETURN-VALUE).
                   
        FIND LAST RowErrors NO-LOCK NO-ERROR.
        ASSIGN i-seq = IF AVAIL RowErrors THEN RowErrors.ErrorSequence + 1 ELSE 1. 
                    
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence    = i-seq
               RowErrors.ErrorNumber      = 57968 
               RowErrors.ErrorDescription = c-msg
               RowErrors.ErrorHelp        = c-help
               RowErrors.ErrorType        = "EMS":U
               RowErrors.ErrorSubType     = "error":U.

        RETURN "NOK":U.                                                   
    END.

    ASSIGN i-seq-atend-devol = 10.
    FOR EACH ws-atend-devol-requis-job NO-LOCK
       WHERE ws-atend-devol-requis-job.nr-requisicao  = it-requisicao.nr-requisicao
         AND ws-atend-devol-requis-job.seq-it-requis  = it-requisicao.sequencia
         AND ws-atend-devol-requis-job.it-codigo      = it-requisicao.it-codigo 
         AND ws-atend-devol-requis-job.idi-tipo-movto = 2  // (2 - Devolucao)
         BY ws-atend-devol-requis-job.seq-atend-devol DESC:
        ASSIGN i-seq-atend-devol = ws-atend-devol-requis-job.seq-atend-devol + 10.  
        LEAVE.  
    END. 
    
    FIND FIRST ws-atend-devol-requis-job NO-LOCK
         WHERE ws-atend-devol-requis-job.nr-requisicao   = it-requisicao.nr-requisicao
           AND ws-atend-devol-requis-job.seq-it-requis   = it-requisicao.sequencia
           AND ws-atend-devol-requis-job.it-codigo       = it-requisicao.it-codigo 
           AND ws-atend-devol-requis-job.seq-atend-devol = i-seq-atend-devol 
           AND  ws-atend-devol-requis-job.idi-tipo-movto = 2 NO-ERROR. // (2 - Devolucao) 
    IF NOT AVAIL ws-atend-devol-requis-job THEN DO:
        CREATE ws-atend-devol-requis-job.
        ASSIGN ws-atend-devol-requis-job.nr-requisicao    = it-requisicao.nr-requisicao
               ws-atend-devol-requis-job.seq-it-requis    = it-requisicao.sequencia
               ws-atend-devol-requis-job.it-codigo        = it-requisicao.it-codigo 
               ws-atend-devol-requis-job.seq-atend-devol  = i-seq-atend-devol
               ws-atend-devol-requis-job.idi-tipo-movto   = 2 // (2 - Devolucao)
               ws-atend-devol-requis-job.ts-disp-integr   = NOW
               ws-atend-devol-requis-job.rw-movto         = STRING(ttSummaryInventoryBalance.rw-movto).
    END.        

    CREATE ws-atend-devol-it-requis.
    ASSIGN ws-atend-devol-it-requis.nr-requisicao    = it-requisicao.nr-requisicao
           ws-atend-devol-it-requis.seq-it-requis    = it-requisicao.sequencia
           ws-atend-devol-it-requis.it-codigo        = it-requisicao.it-codigo 
           ws-atend-devol-it-requis.seq-atend-devol  = i-seq-atend-devol

           ws-atend-devol-it-requis.idi-tipo-movto   = 2 // (2 - Devolucao)
           ws-atend-devol-it-requis.idi-sit-docto    = 1 // (1 - Em Processo)

           ws-atend-devol-it-requis.cod-estabel      = it-requisicao.cod-estabel
           ws-atend-devol-it-requis.cod-depos        = ttSummaryInventoryBalance.cod-depos
           ws-atend-devol-it-requis.cod-refer        = ttSummaryInventoryBalance.cod-refer
           ws-atend-devol-it-requis.cod-lote         = ttSummaryInventoryBalance.lote 
           ws-atend-devol-it-requis.cod-localiz      = ttSummaryInventoryBalance.cod-localiz
           ws-atend-devol-it-requis.qtd-requisitada  = de-qtde-digitada.    

    RELEASE ws-atend-devol-requis-job. 
    RELEASE ws-atend-devol-it-requis.
    
    RETURN "OK":U. 
           
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-devol-wms-saas B-table-Win 
PROCEDURE pi-cria-atend-wms-saas:
/*------------------------------------------------------------------------------
  Purpose: Cria o job de atendimento para integra‡Æo com WMS-SaaS e aloca o saldo no ERP.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR ttSummaryInventoryBalance.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE i-seq-atend-devol      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE de-qtde-requis-wms     AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE de-qtde-saldo-real     AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE de-qtde-saldo-atual    AS DECIMAL   NO-UNDO.
    
    /* INÖCIO DA ADAPTA€ÇO: Vari veis para aloca‡Æo de saldo */
    DEFINE VARIABLE c-lote-aloc-wms-ext    AS CHARACTER NO-UNDO.
    DEFINE BUFFER    bf-deposito            FOR deposito.
    /* FIM DA ADAPTA€ÇO */

    DO TRANSACTION:
        FOR EACH ttSummaryInventoryBalance WHERE ttSummaryInventoryBalance.qt-a-atender > 0:

            FIND FIRST it-requisicao EXCLUSIVE-LOCK 
                WHERE it-requisicao.nr-requisicao = ttSummaryInventoryBalance.nr-requisicao
                  AND it-requisicao.sequencia     = ttSummaryInventoryBalance.sequencia
                  NO-WAIT NO-ERROR.

            IF LOCKED(it-requisicao) THEN DO:
                RUN createRowErrors(1, 27837, ""). /* Tabela sendo usada por outro usu rio */
                UNDO, RETURN "NOK".
            END.
            
            IF  CAN-FIND( FIRST aloca-reserva
                          where aloca-reserva.nr-ord-produ = it-requisicao.nr-ord-produ 
                          and   aloca-reserva.it-codigo    = it-requisicao.it-codigo 
                          and   aloca-reserva.cod-estabel  = it-requisicao.cod-estabel )
            AND CAN-FIND( FIRST deposito 
                          WHERE deposito.cod-depos = ttSummaryInventoryBalance.cod-depos 
                            AND deposito.log-aloca-saldo-wms-ext ) THEN DO:
                {utp/ut-liter.i "Existe aloca‡Æo para o item da ordem, estorne antes de efetuar o atendimento com dep¢sito que gera aloca‡Æo!" *} 
                RUN createRowErrors(1, 17006, RETURN-VALUE).
            END.
                

            /* Calcula o total j  pendente de atendimento no WMS */
            ASSIGN de-qtde-requis-wms = 0.
            FOR EACH ws-atend-devol-it-requis NO-LOCK
                WHERE ws-atend-devol-it-requis.nr-requisicao  = it-requisicao.nr-requisicao
                  AND ws-atend-devol-it-requis.seq-it-requis  = it-requisicao.sequencia
                  AND ws-atend-devol-it-requis.idi-tipo-movto = 1  /* Atendimento */
                  AND ws-atend-devol-it-requis.idi-sit-docto  < 3: /* Em Processo ou Em Processo WMS */
                ASSIGN de-qtde-requis-wms = de-qtde-requis-wms + ws-atend-devol-it-requis.qtd-requisitada.
            END.

            /* Valida se a quantidade total nÆo excede o saldo a atender */
            IF (ttSummaryInventoryBalance.qt-a-atender + de-qtde-requis-wms) > it-requisicao.qt-a-atender THEN DO:
                ASSIGN de-qtde-saldo-real = it-requisicao.qt-a-atender - de-qtde-requis-wms.
                IF de-qtde-saldo-real < 0 THEN ASSIGN de-qtde-saldo-real = 0.
                
                RUN createRowErrors(1, 57951, 
                    TRIM(it-requisicao.it-codigo) + "~~" + TRIM(STRING(it-requisicao.sequencia)) + "~~" +
                    TRIM(STRING(it-requisicao.qt-atendida)) + CHR(10) + "~~" + TRIM(STRING(de-qtde-requis-wms)) + CHR(10) + "~~" +
                    TRIM(STRING(ttSummaryInventoryBalance.qt-a-atender)) + CHR(10) + "~~" + TRIM(STRING(de-qtde-saldo-real))).
                UNDO, RETURN "NOK".
            END.

            /* INÖCIO DA LàGICA DE ALOCA€ÇO DE SALDO */
            FIND FIRST bf-deposito WHERE bf-deposito.cod-depos = ttSummaryInventoryBalance.cod-depos NO-LOCK NO-ERROR.
            
            IF NOT AVAIL item THEN FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = it-requisicao.it-codigo NO-ERROR.
            
            IF AVAILABLE bf-deposito AND bf-deposito.log-aloca-saldo-wms-ext THEN DO:
            
                ASSIGN de-qtde-saldo-atual = 0.
                FOR EACH saldo-estoq 
                   WHERE saldo-estoq.cod-estabel =  it-requisicao.cod-estabel
                     AND saldo-estoq.it-codigo   =  it-requisicao.it-codigo
                     AND saldo-estoq.cod-depos   =  ttSummaryInventoryBalance.cod-depos
                     AND saldo-estoq.cod-refer   =  ttSummaryInventoryBalance.cod-refer
                     AND saldo-estoq.cod-localiz =  "" NO-LOCK:
                     
                     ASSIGN de-qtde-saldo-atual = de-qtde-saldo-atual + saldo-estoq.qtidade-atu - 
                                                 (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-ped + saldo-estoq.qt-aloc-prod).     
                END.            
            
                IF AVAIL item AND item.tipo-con-est <> 1 /* Serial */ THEN DO:
                    FIND FIRST param-estoq NO-LOCK NO-ERROR.
                    IF AVAILABLE param-estoq THEN
                        ASSIGN c-lote-aloc-wms-ext = TRIM(SUBSTRING(param-estoq.char-2, 276, 40)).
                    
                    IF c-lote-aloc-wms-ext = "" OR c-lote-aloc-wms-ext = ? THEN DO:
                        RUN createRowErrors(1, 17386, ""). /* Lote Aloca‡Æo WMS Externo nÆo parametrizado no CE0101 */
                        UNDO, RETURN "NOK".
                    END.
                END. 
                
                FIND FIRST saldo-estoq EXCLUSIVE-LOCK
                    WHERE saldo-estoq.cod-estabel = it-requisicao.cod-estabel
                    AND saldo-estoq.it-codigo   = it-requisicao.it-codigo
                    AND saldo-estoq.cod-depos   = ttSummaryInventoryBalance.cod-depos
                    AND saldo-estoq.cod-refer   = ttSummaryInventoryBalance.cod-refer
                    AND saldo-estoq.cod-localiz = ""
                    AND saldo-estoq.lote        = c-lote-aloc-wms-ext NO-ERROR.
                
                IF NOT AVAILABLE saldo-estoq THEN DO:
                    CREATE saldo-estoq.
                    ASSIGN 
                        saldo-estoq.cod-estabel  = it-requisicao.cod-estabel
                        saldo-estoq.it-codigo    = it-requisicao.it-codigo
                        saldo-estoq.cod-depos    = ttSummaryInventoryBalance.cod-depos
                        saldo-estoq.cod-refer    = ttSummaryInventoryBalance.cod-refer
                        saldo-estoq.cod-localiz  = ""
                        saldo-estoq.lote         = c-lote-aloc-wms-ext
                        saldo-estoq.dt-vali-lote = 12/31/9999.
                END.
                ELSE DO:
                    IF de-qtde-saldo-atual < ttSummaryInventoryBalance.qt-a-atender THEN DO:
                        RUN createRowErrors(1, 27007, ""). 
                        UNDO, RETURN "NOK".
                    END.
                END.
                
                ASSIGN saldo-estoq.qt-aloc-prod = saldo-estoq.qt-aloc-prod + ttSummaryInventoryBalance.qt-a-atender.
                   
            END.
            /* FIM DA LàGICA DE ALOCA€ÇO DE SALDO */

            /* Encontra a pr¢xima sequˆncia para o job */
            ASSIGN i-seq-atend-devol = 10.
            FOR LAST ws-atend-devol-requis-job NO-LOCK
               WHERE ws-atend-devol-requis-job.nr-requisicao  = it-requisicao.nr-requisicao
                 AND ws-atend-devol-requis-job.seq-it-requis  = it-requisicao.sequencia
                 AND ws-atend-devol-requis-job.idi-tipo-movto = 1: /* Atendimento */
                ASSIGN i-seq-atend-devol = ws-atend-devol-requis-job.seq-atend-devol + 10.
            END.

            /* Cria o cabe‡alho do job */
            FIND FIRST ws-atend-devol-requis-job WHERE ws-atend-devol-requis-job.nr-requisicao = it-requisicao.nr-requisicao
                AND ws-atend-devol-requis-job.seq-it-requis = it-requisicao.sequencia
                AND ws-atend-devol-requis-job.seq-atend-devol = i-seq-atend-devol
                AND ws-atend-devol-requis-job.idi-tipo-movto = 1 NO-ERROR.
            
            IF NOT AVAILABLE ws-atend-devol-requis-job THEN DO:
                CREATE ws-atend-devol-requis-job.
                ASSIGN 
                    ws-atend-devol-requis-job.nr-requisicao    = it-requisicao.nr-requisicao
                    ws-atend-devol-requis-job.seq-it-requis    = it-requisicao.sequencia
                    ws-atend-devol-requis-job.it-codigo        = it-requisicao.it-codigo 
                    ws-atend-devol-requis-job.seq-atend-devol  = i-seq-atend-devol
                    ws-atend-devol-requis-job.idi-tipo-movto   = 1 /* Atendimento */
                    ws-atend-devol-requis-job.ts-disp-integr   = NOW.
            END.

            /* Cria o item do job */
            CREATE ws-atend-devol-it-requis.
            ASSIGN 
                ws-atend-devol-it-requis.nr-requisicao    = it-requisicao.nr-requisicao
                ws-atend-devol-it-requis.seq-it-requis    = it-requisicao.sequencia
                ws-atend-devol-it-requis.it-codigo        = it-requisicao.it-codigo 
                ws-atend-devol-it-requis.seq-atend-devol  = i-seq-atend-devol
                ws-atend-devol-it-requis.idi-tipo-movto   = 1 /* Atendimento */
                ws-atend-devol-it-requis.idi-sit-docto    = 1 /* Em Processo */
                ws-atend-devol-it-requis.cod-estabel      = it-requisicao.cod-estabel
                ws-atend-devol-it-requis.cod-depos        = ttSummaryInventoryBalance.cod-depos
                ws-atend-devol-it-requis.cod-refer        = ttSummaryInventoryBalance.cod-refer
                ws-atend-devol-it-requis.cod-lote         = ttSummaryInventoryBalance.lote 
                ws-atend-devol-it-requis.cod-localiz      = ttSummaryInventoryBalance.cod-localiz
                ws-atend-devol-it-requis.qtd-requisitada  = ttSummaryInventoryBalance.qt-a-atender.

            RELEASE it-requisicao.
        END. /* FOR EACH */
    END. /* TRANSACTION */
    
    RETURN "OK".
    
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaParamApiWmsSAAS DBOFunction
PROCEDURE setaParamApiWmsSAAS:
/*------------------------------------------------------------------------------
  Purpose: Recebe parƒmetros de contexto da API WMS (C¢pia da CEAPI400)
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-orig-api-WMS-SAAS AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pl-fim-req-WMS-SAAS  AS LOGICAL NO-UNDO.
    
    ASSIGN l-orig-api-WMS-SAAS = pl-orig-api-WMS-SAAS
           l-fim-req-WMS-SAAS  = pl-fim-req-WMS-SAAS.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeHandles DBOFunction 
PROCEDURE initializeHandles PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-mceUtils) THEN
        RUN cep/mce_utils.p PERSISTENT SET h-mceUtils.

    IF NOT VALID-HANDLE(h-in2108) THEN
        RUN inp/in2108.p PERSISTENT SET h-in2108.

   IF NOT VALID-HANDLE(h-boiv029) THEN
        RUN ivbo/boiv029.p PERSISTENT SET h-boiv029. 

    IF NOT VALID-HANDLE(h-ceapi001k) THEN
        RUN cep/ceapi001k.p PERSISTENT SET h-ceapi001k.

    RETURN "OK":U.
END PROCEDURE.    
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyHandles DBOFunction 
PROCEDURE destroyHandles PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-mceUtils) THEN DO:
        DELETE PROCEDURE h-mceUtils.
        ASSIGN h-mceUtils = ?.
    END.

    IF VALID-HANDLE(h-ceapi001k) THEN DO:
        DELETE PROCEDURE h-ceapi001k.
        ASSIGN h-ceapi001k = ?.
    END.

    IF VALID-HANDLE(h-in2108) THEN DO:
        DELETE PROCEDURE h-in2108.
        ASSIGN h-in2108 = ?.
    END.

    IF VALID-HANDLE(h-boiv029) THEN DO:
        DELETE PROCEDURE h-boiv029.
        ASSIGN h-boiv029 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.    
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDefaultRequester DBOProgram 
PROCEDURE getDefaultRequester:
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER cNomeAbrev LIKE requisicao.nome-abrev NO-UNDO.

    IF c-seg-usuario <> "" THEN
        cNomeAbrev = c-seg-usuario.
    ELSE
        cNomeAbrev = v_cod_usuar_corren.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setReqIntegrMe DBOProgram 
PROCEDURE setReqIntegrMe :
/*------------------------------------------------------------------------------
  Purpose: Informa a Bo que a ordem de compra da solicita‡Æo est  integrada 
           com o Mercado Eletr“nico e que esta ordem est  sendo eliminada
           via procedure piCancelaOrdemCompraME da boin274fx.p.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pOrdemIntegrMe AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pNarrativa     AS CHARACTER NO-UNDO.

    ASSIGN lElimOrdemIntegrMe = pOrdemIntegrMe
           cNarrativaItem     = pNarrativa.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
