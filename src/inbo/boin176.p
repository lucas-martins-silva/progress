USING rep.imp.*.
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**      
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.  
******************************************************************************/

{include/i-prgvrs.i BOIN176 2.00.00.271 } /*** "010071" 16/10/2026 18:02:34 ***/
    
/*{include/i-license-manager.i boin176 MUT}*/
        
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*---------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ì um programa PROGRESS 
                 que contìm a l®gica de neg®cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 
	        
    Notes      : 
----------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.                 */
/*--------------------------------------------------------------------------*/


/****************************  Definitions  *******************************/
      
/*--- Diretrizes de definiîÒo ---*/
&GLOBAL-DEFINE DBOName BOIN176
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-doc-est
&GLOBAL-DEFINE TableLabel Itens Documento Recebimento
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND TRUE
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND-PROCS Main,OfDocumEst,OfMovtoPend

{cdp/cdcfgdis.i}            /* Preprocessadores Distribui»’o */
{inbo/boin176.i RowObject}
{method/dboqry.i}

/* Defini¯Êo do prý-processador de versÊo do produto */
{include/i_prdvers.i}

/*--- DefiniîÒo de buffer que serÙ utilizado pelo mìtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF TEMP-TABLE tt-matriz NO-UNDO 
    FIELD cod-unid-neg AS CHAR
    FIELD perc-rateio  AS DEC.

DEFINE TEMP-TABLE tt-rateio     NO-UNDO LIKE tt-matriz.
DEFINE TEMP-TABLE tt-rateio-aux NO-UNDO LIKE tt-matriz.

DEFINE TEMP-TABLE tt-RowErrorsAux NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

DEFINE TEMP-TABLE tt-ext-item-doc-est NO-UNDO LIKE ext-item-doc-est
    FIELD r-Rowid          AS ROWID.

{cdp/cdcfgmat.i} /* Include uso de pre-processadores */
{cdp/cdcfgman.i}

{cdp/cd9731.i6}                      /* Verifica Integra»’o MIV x MIM */
{dibo/bodi317im2bra.i1 }             /* DefiniŒão de Temp-Table para Cëlculo dos Impostos */

{dibo/bodi613calc.i3}  //defini‡Æo da tb-wt-it-impostoCBSIBS

DEF BUFFER b-tb-ct-trib-wt-item-docto FOR tb-ct-trib-wt-item-docto.
{inbo/boin176.i2 }                   /* DefiniŒão de Temp-Table de Totais */
{inbo/boin176.i3 tt-ordem-item }     /* DefiniîÒo tt-ordem-item */
{inbo/boin176.i4 tt-item-devol-cli } /* DefiniîÒo tt-item-devol-cli */
{inbo/boin176.i5 tt-saldo-terc }     /* DefiniîÒo tt-saldo-terc e tt-item-saldo-terc-aux*/
{cdp/cd4329.i2}                      /* Aloca/Desaloca parcela de Compra */
{cep/ce1234.i}                       /* ValidaîÒo Decimais */
{bcp/bcapi011.i}                     /* Temp-table tt-etq-item */
{bcp/bcapi004.i}                     /* Temp-table tt-prog-bc  */
{dibo/bodi515.i tt-nota-fisc-adc}    /* Temp-Table tt-nota-fisc-adc */
{dibo/bodi516.i tt-item-nf-adc}      /* Temp-table tt-item-nf-adc */
{dibo/bodi516.i tt2-item-nf-adc}     /* Temp-table tt2-item-nf-adc */
{inbo/boin006.i tt-rat-saldo-terc}   /* Temp-table tt-rat-saldo-terc */
{inbo/boin010.i tt-rat-componente}   /* Temp-table tt-rat-componente */
{cxbo/bocx315.i tt-pedido-drb-item}  /* Temp-table tt-pedido-drb-item */
{include/i-epc200.i BOIN176}         /* Definicao da temp-table tt-epc */
{cdp/cdcfgmnt.i} /* Verifica Versao */
{cdp/cd9911.i} /* Verifica Unidade Neg½cio */
{inbo/boin368.i tt-rat-docum}
{inbo/boin01091.i tt-item-doc-est-tribut} /*temp-table item-doc-est-tribut*/
{abp/abapi016.i} /* tt-mab-item-abastec-lubrific */
{dibo/bodi01141.i tt-relacto-tributo} /*temp-table do cdapi1005*/

{inbo/boin090.i tt-docum-est}
DEFINE TEMP-TABLE tt-item-doc-est-tribut-aux NO-UNDO LIKE tt-item-doc-est-tribut.
DEFINE TEMP-TABLE tt-ext-item-doc-est-aux    NO-UNDO LIKE tt-ext-item-doc-est.


DEFINE TEMP-TABLE tt-rateio-multa-juros NO-UNDO
    FIELD id            AS INTEGER
    FIELD tot-val-itens AS DECIMAL
    FIELD valor-rateado AS DECIMAL.
    
/* Seguranca estabelecimento:
Quando outro programa que usa a seguranca eh aberto apos essa BO ja instanciada e esta sendo realizada uma operacao
entre 2 estabelecimentos (ex. transferencia), sendo que o usuario nao tem acesso ao estab origem, ocorre erro ao buscar o estab origem.
Entao o ON FIND da estabelec precisa ser desativado quando eh realizada a busca do estabelecimento (procedure findEstabelec - boin176.m05) */
DEFINE NEW GLOBAL SHARED TEMP-TABLE tt_estab_ems2 NO-UNDO
     FIELD tta_cod_estab AS CHARACTER FORMAT "x(5)" LABEL "Estabelecimento" COLUMN-LABEL "Estab".

DEFINE VARIABLE l-seg-ativa-modulo AS LOGICAL INIT NO NO-UNDO.
ASSIGN l-seg-ativa-modulo = CAN-FIND(param_seg_estab WHERE param_seg_estab.cdn_param = 5 /*Recebimento*/ AND param_seg_estab.des_valor = "SIM":U) OR
                            CAN-FIND(param-global WHERE SUBSTRING(param-global.char-2, 37, 1) = "S":U /*Seg Estab CD0101*/).


DEFINE TEMP-TABLE tt-rat-saldo-terc-dep NO-UNDO LIKE rat-saldo-terc
       field qtd-digitada as dec
       FIELD r-rowid AS ROWID 
       INDEX id IS PRIMARY UNIQUE serie-docto nro-docto cod-emitente nat-operacao it-codigo 
                                  cod-refer sequencia lote cod-depos cod-localiz.

&if "{&mgadm_version}" >= "2.04" &then 
    /*--- ExecuÂÆo OrÂament‰ria ---*/
    {cdp/cd1002.i}  /*--- funÂÆo execuÂÆo orÂament‰ria ---*/
&ENDIF
DEF VAR iempresa LIKE empresa.ep-codigo NO-UNDO.
/*speto*/
DEF VAR de-v-men LIKE param-cp.var-req-menor NO-UNDO.
DEF VAR de-v-mai LIKE param-cp.var-requis    NO-UNDO.
DEF VAR de-v-rep LIKE param-cp.var-rep       NO-UNDO.
DEF VAR c-v-msgs AS   CHAR                   NO-UNDO.
{cpp/cpapi029.i}
/*speto*/

{btb/btb009za.i}
DEF VAR h-btb009za AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-rat-lote NO-UNDO LIKE rat-lote
       FIELD r-Rowid AS ROWID.    
DEF TEMP-TABLE tt-exam-ficha NO-UNDO LIKE exam-ficha.
define temp-table tt-rat-config no-undo
    field it-codigo     like item.it-codigo
    field de-qtd-saldo  as dec
    field sequencia     like item-doc-est.sequencia
    field lote          like rat-lote.lote
    field cod-refer     like rat-lote.cod-refer.

DEF TEMP-TABLE tt-saldo-lote NO-UNDO
    FIELD it-codigo    LIKE      item-doc-est.it-codigo   
    FIELD cod-localiz  LIKE      item-doc-est.cod-localiz
    FIELD cod-depos    LIKE      item-doc-est.cod-depos
    FIELD lote         LIKE      item-doc-est.lote        
    FIELD quantidade   LIKE      item-doc-est.quantidade. 
DEF TEMP-TABLE tt-saldo-lote-rec LIKE tt-saldo-lote.

def buffer b-item-doc-est  for item-doc-est.
def buffer b-docum-est     for docum-est.
def buffer b-emit-estab    for emitente.
def buffer b-rat-lote      for rat-lote.
def buffer b-rat-ordem     for rat-ordem.
def buffer b-ordem-compra  for ordem-compra.
def buffer b-natur-oper    for natur-oper.
def buffer b-estabelec     for estabelec.
DEF BUFFER b-natur-oper-item FOR natur-oper.
def buffer bf-item-doc-est for item-doc-est.
def buffer bf-nota-fisc-adc-1 for nota-fisc-adc.
def buffer bf-nota-fisc-adc-2 for nota-fisc-adc.
def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".


def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¼ncia"
    .

def var h_api_cta_ctbl     as handle no-undo.
def var h_api_ccusto       as handle no-undo.
def var v_log_utz_ccusto   as log    no-undo.
def var v_num_tip_cta_ctbl as int    no-undo.
def var v_num_sit_cta_ctbl as int    no-undo.
def var v_cod_cta_ctbl     as char   no-undo.
def var v_des_cta_ctbl     as char   no-undo.
def var v_ind_finalid_cta  as char   no-undo.
DEF VAR i-num-finalid-cta  AS INT    NO-UNDO.
def var icont              as int    no-undo.
DEF VAR v_cod_formato      AS CHAR   NO-UNDO.
DEF VAR v_cod_ccusto       AS CHAR   NO-UNDO.
DEF VAR v_des_ccusto       AS CHAR   NO-UNDO.
DEF VAR p-contacontabil AS CHARACTER NO-UNDO.

{utp/ut-glob.i}

/* Local Variable Definitions */
def new global shared var i-totaliza as int                   no-undo.
def NEW shared var l-conta-matriz    as LOGICAL               no-undo.
def new global shared var l-passou   as log                   no-undo initial no.

def var cLastItem            as char                          no-undo.
def var lAgrupaPorItem       as log                           no-undo initial no.
/*def var c-nav                as char                          no-undo.*/
def var c-item               as char                          no-undo.
def var c-item-atual         as char                          no-undo.

def var l-industria          as logical                       no-undo.
def var l-devolucao          as logical                       no-undo.
def var l-transf             as logical                       no-undo.
def var l-comercio           as logical                       no-undo.
def var l-servicos           as logical                       no-undo.
def var l-retorno            as logical                       no-undo.
def var l-ret-fat            as logical                       no-undo.
def var l-ent-cons           as logical                       no-undo.
def var l-dev-transf         as logical                       no-undo.
def var l-multa-juros        as logical                       no-undo.

def var l-pede-compra        as logical                       no-undo.
def var l-NFDebCred          as logical                       no-undo.
def var l-pede-pedordem      as logical                       no-undo.
def var l-pede-baixa-ce      as logical                       no-undo.
def var l-pede-conta         as logical                       no-undo.
def var l-pede-ord-prod      as logical                       no-undo.
def var l-pede-qtd           as logical                       no-undo.
def var l-pede-peso          as logical                       no-undo.
def var l-pede-valor         as logical                       no-undo.
def var l-alter-itens        as logical                       no-undo.
def var l-evento             as logical                       no-undo.
def var l-encerra-pa         as logical                       no-undo.
def var l-pede-data-comp     as logical                       no-undo.
def var l-material-agregado  as logical                       no-undo.
def var l-contrato           as logical                       no-undo.
DEF VAR i-ini-cod-emitente   AS INTEGER                       NO-UNDO.
DEF VAR c-ini-nro-docto      AS CHARACTER                     NO-UNDO.
DEF VAR c-ini-it-codigo      AS CHARACTER                     NO-UNDO.
DEF VAR i-fin-cod-emitente   AS INTEGER                       NO-UNDO.
DEF VAR c-fin-nro-docto      AS CHARACTER                     NO-UNDO.
DEF VAR c-fin-it-codigo      AS CHARACTER                     NO-UNDO.
DEF VAR i-ini-seq-item       AS INTEGER                       NO-UNDO.
DEF VAR i-fin-seq-item       AS INTEGER                       NO-UNDO.
def var i-cod-emitente       as int                           no-undo.
def var c-serie-docto        as char                          no-undo.
def var c-nro-docto          as char                          no-undo.
def var c-nat-operacao       as char                          no-undo.
def var i-nr-linhas          as int                           no-undo. 
def var i-cont               as int                           no-undo.
def var c-descricao-aux      as char                          no-undo.
def var i-tamanho-linha      as int                           no-undo.
def var i-total              as int                           no-undo.
def var l-recalcula          as logical                       no-undo.
def var de-vl-merc-liq       as decimal                       no-undo.
def var de-vl-aux            as decimal                       no-undo.
def var c-tipo               as char                          no-undo.
def var de-indice            as decimal                       no-undo.
def var de-qtd-aux           like item-doc-est.quantidade     no-undo.
def var de-val-aux           as decimal                       no-undo.
def var de-desconto          like item-doc-est.desconto[1]    no-undo.
def var c-it-do-forn         like item-doc-est.it-codigo      no-undo.
def var de-qt-ori            like item-doc-est.quantidade     no-undo.
def var de-preco-cc          as decimal                       no-undo.
def var de-desconto-cc       as decimal                       no-undo.
def var de-aliquota-pis      AS DECIMAL FORMAT ">9.9999"      no-undo.
def var de-base-pis          as dec                           no-undo.
def var de-vl-pis            as dec                           no-undo.
def var de-aliquota-cofins   AS DECIMAL FORMAT ">9.9999"      no-undo.
def var de-base-cofins       as dec                           no-undo.
def var de-vl-cofins         as dec                           no-undo.
def var de-aliq-simplesnac   as dec FORMAT ">9.9999"          no-undo.
def var de-vl-simplesnac     as dec                           no-undo.
def var de-qtd-fornec-receb  like item-doc-est.quantidade     no-undo.
def var l-conecta-emsuni     as logical                       no-undo.
def var l-conecta-emsfin     as logical                       no-undo.
def var l-conecta-emsbas     as logical                       no-undo.
def var l-EMS5-conectado     as logical                       no-undo.
def var i-empresa            like param-global.empresa-prin   no-undo.
def var l-cria-rat-lote      as logical initial "yes"         no-undo.
def var l-deposito           as logical initial "yes"         no-undo.
def var h_bodi317im2bra      as handle                        no-undo.
def var h-cdcfgfiscal        as handle                        no-undo.
def var h-boin060            as handle                        no-undo.
def var h-boin090            as handle                        no-undo.
def var h-boin367            as handle                        no-undo.
def var h-bocx00488          as handle                        no-undo.
def var h-boin404re          as handle                        no-undo.
def var h-cd4337             as handle                        no-undo.
def var h-cd4338             as handle                        no-undo.
def var h-bocx332            as handle                        no-undo.
def var h-bocx225            as handle                        no-undo.
def var h-boiv029            as handle                        no-undo.
def var h-bodi515            as handle                        no-undo.
def var h-boin006            as handle                        no-undo.
def var h-boin010            as handle                        no-undo.
def var h-cdapi995           as handle                        no-undo.        
def var h-boin01017          as handle                        no-undo.        
DEF VAR h-boin01091          AS HANDLE                        NO-UNDO.
DEF VAR h-bodi538            AS HANDLE                        NO-UNDO.
DEF VAR h-reapi429           AS HANDLE                        NO-UNDO.
DEF VAR h-reapi435           AS HANDLE                        NO-UNDO.
def var l-default-tributacao as logical init yes              no-undo.
def var l-default-aliquota   as logical init yes              no-undo.
def var l-alteracao-nat-oper as logical init no               no-undo.
def var i-evento-aux         as int                           no-undo.
def var l-conectado          as logical                       no-undo.
def var l-ja-conectado       as logical  initial no           no-undo.
def var de-quant-forn        like item-doc-est.quantidade     no-undo.
DEF VAR e-per-ppm            AS DECIMAL FORMAT ">>>,>>9.9999":U   NO-UNDO.
DEF VAR i-nr-linhas-nota     AS INTEGER                       no-undo.
DEF VAR l-nf-transf-devol-ret AS LOGICAL                      no-undo.
def var l-imp                as logical  initial NO           no-undo.
def var de-valor-ipi-unid    LIKE item.valor-ipi-beb          NO-UNDO.
def var de-valor-un-pis          as dec format ">>>9.99999"   no-undo.
def var de-valor-un-cofins       as dec format ">>>9.99999"   no-undo.
def var de-valor-un-pis-devol    as dec format ">>>9.99999"   no-undo.
def var de-valor-un-cofins-devol as dec format ">>>9.99999"   no-undo.
DEF VAR l-utilizaImpostoMonitor  AS LOGICAL INITIAL NO        NO-UNDO.
DEF VAR l-executar-fifo-re1001p  AS LOGICAL INITIAL YES       NO-UNDO.
DEF VAR lSujTribMonofasica       AS LOGICAL INITIAL NO        NO-UNDO.

DEF VAR de-peso-un           LIKE item-doc-est.peso-liquido INIT 0  NO-UNDO.
def new global shared var gl-natOperTr   LIKE natur-oper.nat-operacao   no-undo.

def var de-val-reduc-pis-normal    as decimal format ">>9.99":U no-undo.
def var de-val-reduc-cofins-normal as decimal format ">>9.99":U no-undo.
DEF VAR l-matriz-re1001b4          AS LOGICAL                   NO-UNDO.
DEF VAR l-unid-negoc-frotas        AS LOGICAL                   NO-UNDO.
DEF VAR hMMVUnidNegoc              AS HANDLE NO-UNDO.
DEF VAR l-integra-ems-his          AS LOGICAL                   NO-UNDO.
def var l-upc-considera-desconto   as logical                   no-undo. /*TTROLK*/
def var l-recalcula-pis-cofins     as logical                   no-undo.
ASSIGN l-matriz-re1001b4 = NO.

DEF VAR h-bocx378    AS HANDLE                               NO-UNDO.
DEF VAR h-bocx407    AS HANDLE                               NO-UNDO.
DEF VAR h-bocx315    AS HANDLE                               NO-UNDO.
DEF VAR de-quant-sdo AS DEC                                  NO-UNDO.
DEF VAR d-qt-solic   LIKE pedido-drb-item.qtd-alocada-import NO-UNDO.
DEF VAR c-msg        AS CHARACTER                            NO-UNDO.
DEF VAR i-IntNac     AS INTEGER                              NO-UNDO.
DEF VAR l-erro       AS LOGICAL                              NO-UNDO.
DEF VAR c-nr-ato-concessorio-antigo LIKE pedido-drb.nr-ato-concessorio NO-UNDO.
DEF VAR l-validar    AS LOGICAL                              NO-UNDO.
DEF VAR p-retorno    AS LOGICAL                              NO-UNDO.

DEF VAR d-data-corte-cq AS DATE                              NO-UNDO.
def var l-vinc-rot-pend AS LOGICAL                           NO-UNDO.
def var i-cont-cq       AS INTEGER                           NO-UNDO.
DEF VAR i-numero-ordem     LIKE item-doc-est.numero-ordem    NO-UNDO.
DEF VAR h-bodi613calc2      AS HANDLE       NO-UNDO.
DEF VAR l-procedimento-ok   AS LOGICAL      NO-UNDO.
DEF VAR l-executa-engine    AS LOG INIT NO  NO-UNDO.

def var de-val-desc-icm-recalc  as decimal  no-undo.
def var l-apl-desc-icm-recalc   as logical  no-undo.

/*Controle saldo por lote*/
def buffer bf-saldo-terc     for saldo-terc.
def buffer bf-natur-oper-aux for natur-oper.

{cnp/cn9077.i}
{cdp/cd7300.i1}
{mpp/mpapi011.i}

/* Defini‡Æo/atribui‡Æo da vari ve l-mult-natur-receb -> Usa multiplas naturezas no recebimento */
{cdp/cd9701.i}

&IF DEFINED(bf_nr_nota) &THEN
    {inbo/boin176.m54}
&ENDIF


{cdp/cd9590.i} /*Indica a utiliza»’o da fun»’o e dos par³metros de Unidade de Neg½cio*/
DEFINE VARIABLE h-cdapi024       AS HANDLE     NO-UNDO.
DEFINE VARIABLE l-re-unid-negoc  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-valida-un-terc AS LOGICAL    NO-UNDO.
find first param-re no-lock 
    where param-re.usuario = c-seg-usuario no-error.
if avail param-re then
    assign l-re-unid-negoc = param-re.log-pedir-unid-negoc.

{cep/ceapi030.i}
{fch/fchmat/fchmatqualitycontrolsimulation.i ttCQSimulationVO}

ASSIGN l-integra-ems-his = CAN-FIND(FIRST funcao
                                    WHERE funcao.cd-funcao = "spp-integra-ems-his":U
                                      AND funcao.ativo     = YES).

DEF VAR l-NT2024002             AS LOG INITIAL NO NO-UNDO.
ASSIGN l-NT2024002 = CAN-FIND (FIRST funcao no-lock 
                               WHERE funcao.cd-funcao = "spp-NT2024002"
                                 AND funcao.ativo     = YES).    

/*--- variaveis para include cd9700.i1 ---*/
{cdp/cd9700.i}
{inbo/boin368.i tt-rat-ordem}             


FIND FIRST param-global NO-LOCK NO-ERROR.

IF NOT VALID-HANDLE(h-cdapi995) THEN
    RUN cdp/cdapi995.p PERSISTENT SET h-cdapi995.

{cdp/cdapi1001.i} /* tt-sit-tribut */ 
DEF VAR h-cdapi1001 AS HANDLE NO-UNDO. /* SIT-TRIBUT */ 


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
         HEIGHT             = 2.08
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



{inbo/boin176.m52} /*engine de regras*/


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */
   {method/svc/autentic/autentic.i 
               &vUserCountryTax="i-pais-impto-usuario"
               &vUserName="c-seg-usuario"}

    run ivbo/boiv029.p persistent set h-boiv029.


    /** Busca Par³metros necessÿrios **/
    run findParamGlobal.
    for first param-mat 
        fields ( ind-unid-neg ) no-lock:
    end.
    run findParamCompra.
    run findParamCQ.
    /***************************************************
    ** Verifica se Manuten»’o Frotas estÿ implantado
    ***************************************************/
    {cdp/cd9903.man2 RowObject}
    /**************************************************/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
{inbo/boin176.m07} /* PROCEDURE afterCreateRecord : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
{inbo/boin176.m08} /* PROCEDURE afterDeleteRecord : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterNewRecord DBOProgram 
PROCEDURE afterNewRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:   Atualiza a chave do item da nota atravìs do documento.
------------------------------------------------------------------------------*/

    if  not avail docum-est then 
        return "NOK":U.
            

    assign RowObject.cod-emitente  = docum-est.cod-emitente 
           RowObject.serie-docto   = docum-est.serie-docto
           RowObject.nro-docto     = docum-est.nro-docto
           RowObject.nat-operacao  = docum-est.nat-operacao.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
{inbo/boin176.m09} /* PROCEDURE afterUpdateRecord : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignValueImposto DBOProgram 
{inbo/boin176.m10} /* PROCEDURE assignValueImposto : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCopyBuffer2TT DBOProgram 
{inbo/boin176.m03} /* PROCEDURE beforeCopyBuffer2TT : */

/*{inbo/boin176.m03} PROCEDURE beforeDestroy : */
/*{inbo/boin176.m03} PROCEDURE beforeUpdateRecord : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
{inbo/boin176.m49} /* PROCEDURE beforeDeleteRecord : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE byOC_AliquotaIPI DBOProgram 
PROCEDURE byOC_AliquotaIPI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
        - Executado pela GeraîÒo de Itens a partir da Ordem de Compra ( RE1001F )
        - Retorna o valor da AlÐquota de IPI e se habilita ou nÒo o atributo.
------------------------------------------------------------------------------*/

    def input  param piItem         like item-doc-est.it-codigo     no-undo.
    def output param piAliquotaIPI  like item-doc-est.aliquota-ipi  no-undo.
    def output param piHabilitaIPI    as logical                    no-undo.


    run findItem ( input piItem ).
    

    if  avail item then do:
        

        run getAliquotaIPI ( input item.class-fiscal,
                             input item.it-codigo,
                             output piAliquotaIPI ).
                             

        run enableFields ( input "Create",
                           input "aliquota-ipi",
                           output piHabilitaIPI ).
    end.
    else 
        RETURN "NOK":U.
        

    RETURN "OK":U.                                                              


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE byOC_ClassFiscal DBOProgram 
PROCEDURE byOC_ClassFiscal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
        - Executado pela GeraîÒo de Itens a partir da Ordem de Compra ( RE1001F )
        - Retorna a classificaîÒo Fiscal do Item e se a mesma deve ser habilitada ou nÒo
------------------------------------------------------------------------------*/
    def input  param piItem             like item.it-codigo     no-undo.
    def output param piClassFiscal      like item.class-fiscal  no-undo.
    def output param piHabilitaClass      as logical            no-undo.

    run findItem ( input piItem ).
    

    if  avail item then do:
        assign piClassFiscal = item.class-fiscal.
        

        run enableFields ( input "CREATE":U,
                           input "class-fiscal":U,
                           output piHabilitaClass ).
    end.
    else 
        RETURN "NOK":U.        


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE byOC_DtEntrega DBOProgram 
PROCEDURE byOC_DtEntrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retorna data de entrega da parcela da ordem de compra.      
------------------------------------------------------------------------------*/

    def input  param r-ordem-compra  as rowid no-undo.
    def output param piDtEntrega     as char  no-undo.   
    

    def var i-cont                   as int   no-undo.
    

    run findOrdemCompra ( input ?,
                          input r-ordem-compra ).
    

    if  not avail ordem-compra then
        return "NOK":U.
        

    for each prazo-compra 
       fields ( numero-ordem    parcela         quant-saldo
                situacao        data-entrega    dec-1
                quant-rejeit     qtd-sal-forn     quantidade
                quant-receb     cod-refer                   )
       where prazo-compra.numero-ordem = ordem-compra.numero-ordem no-lock:

        assign i-cont = i-cont + 1.
    

        if  i-cont = 1 then
            assign piDtEntrega = string(prazo-compra.data-entrega,"99/99/9999").
        if  i-cont = 2 then 
            assign piDtEntrega = "PARCELADA".
    end.
    

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE byOC_PrecoTotal DBOProgram 
PROCEDURE byOC_PrecoTotal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
        - Executado pela GeraîÒo de Itens a partir da Ordem de Compra ( RE1001F )
        - Retorna a o Preîo Total de Acordo com as Ordens de Compra.
------------------------------------------------------------------------------*/

    def input  param r-ordem-compra     as rowid   no-undo.
    def output param de-preco-ordem     as decimal no-undo.
    
    run findParamGlobal.


    run calculatePriceOrdemCompra ( input r-ordem-compra,
                                    output de-preco-ordem ).
                                    
    if  de-qtd-fornec-receb > 0 then 
        assign de-preco-ordem = ( de-preco-ordem + de-desconto-cc ) * de-qtd-fornec-receb.
        

    RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE byOC_QuantReceber DBOProgram 
{inbo/boin176.m04} /* PROCEDURE byOC_QuantReceber : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculateDescontoCC DBOProgram 
{inbo/boin176.m11} /* PROCEDURE calculateDescontoCC : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculateImpostos DBOProgram 
{inbo/boin176.m12} /* PROCEDURE calculateImpostos : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculateItensNota DBOProgram 
{inbo/boin176.m13} /* PROCEDURE calculateItensNota : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculatePisCofins DBOProgram 
{inbo/boin176.m14} /* PROCEDURE calculatePIS : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculatePriceOrdemCompra DBOProgram 
{inbo/boin176.m15} /* PROCEDURE calculatePriceOrdemCompra : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculateTotalItem DBOProgram 
{inbo/boin176.m16} /* PROCEDURE calculateTotalItem : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculateVariationQuantity DBOProgram 
{inbo/boin176.m17} /* PROCEDURE calculateVariationQuantity : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculateVariationValue DBOProgram 
{inbo/boin176.m18} /* PROCEDURE calculateVariationValue : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculate_ICMS_SubsTrib_ICMSComp DBOProgram 
{inbo/boin176.m19} /* PROCEDURE calculate_ICMS_SubsTrib_ICMSComp : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculate_IPI_ISS DBOProgram 
{inbo/boin176.m20} /* PROCEDURE calculate_IPI_ISS : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createItemOfComponente DBOProgram 
{inbo/boin176.m21} /* PROCEDURE createItemOfComponente : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createItemOfNotaFiscal DBOProgram 
{inbo/boin176.m22} /* PROCEDURE createItemOfNotaFiscal : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createItemOfPedido DBOProgram 
{inbo/boin176.m23} /* PROCEDURE createItemOfPedido : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRatLote DBOProgram 
{inbo/boin176.m24} /* PROCEDURE createRatLote : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRatLoteDevolTerc DBOProgram 
{inbo/boin176.m25} /* PROCEDURE createRatLoteDevolTerc : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRatLoteByRatSaldoTerc DBOProgram 
{inbo/boin176.m64} /* PROCEDURE createRatLoteByRatSaldoTerc : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTbWtDocto DBOProgram 
{inbo/boin176.m01} /* PROCEDURE createTbWtDocto : */

/*{inbo/boin176.m01} PROCEDURE createTbWtItDocto : */
/*{inbo/boin176.m01} PROCEDURE createTbWtItImposto : */
/*{inbo/boin176.m01} PROCEDURE createTempTableImpostos : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DesalocaOC DBOProgram 
{inbo/boin176.m26} /* PROCEDURE DesalocaOC : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE determineValueValid DBOProgram 
{inbo/boin176.m27} /* PROCEDURE determineValueValid : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableButtons DBOProgram 
{inbo/boin176.m28} /* PROCEDURE enableButtons : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields DBOProgram 
{inbo/boin176.m29} /* PROCEDURE enableFields : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findBcoExt DBOProgram 
{inbo/boin176.m05} /* PROCEDURE findBcoExt : */

/*{inbo/boin176.m05} PROCEDURE findClassFiscal : */
/*{inbo/boin176.m05} PROCEDURE findContaContabil : */
/*{inbo/boin176.m05} PROCEDURE findDeposito : */
/*{inbo/boin176.m05} PROCEDURE findDocumento : */
/*{inbo/boin176.m05} PROCEDURE findEmitente : */
/*{inbo/boin176.m05} PROCEDURE findEstabelec : */
/*{inbo/boin176.m05} PROCEDURE findFichaCQ : */
/*{inbo/boin176.m05} PROCEDURE findItem : */
/*{inbo/boin176.m05} PROCEDURE findItemUniEstab : */
/*{inbo/boin176.m05} PROCEDURE findItemFornec : */
/*{inbo/boin176.m05} PROCEDURE findItNotaFisc : */
/*{inbo/boin176.m05} PROCEDURE findLocalizacao : */
/*{inbo/boin176.m05} PROCEDURE findNaturOper : */
/*{inbo/boin176.m05} PROCEDURE findNossoItem : */
/*{inbo/boin176.m05} PROCEDURE findOrdemCompra : */
/*{inbo/boin176.m05} PROCEDURE findOrdProd : */
/*{inbo/boin176.m05} PROCEDURE findParamCompra : */
/*{inbo/boin176.m05} PROCEDURE findParamCQ : */
/*{inbo/boin176.m05} PROCEDURE findParamGlobal : */
/*{inbo/boin176.m05} PROCEDURE findPedido : */
/*{inbo/boin176.m05} PROCEDURE findPrazoCompra : */
/*{inbo/boin176.m05} PROCEDURE findReferencia : */
/*{inbo/boin176.m05} PROCEDURE findRowidDocumEst : */
/*{inbo/boin176.m05} PROCEDURE findUsuario : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAliquotaIPI DBOProgram 
{inbo/boin176.m02} /* PROCEDURE getAliquotaIPI : */

/*{inbo/boin176.m02} PROCEDURE getCamposNaturOper : */
/*{inbo/boin176.m02} PROCEDURE getCharField : */
/*{inbo/boin176.m02} PROCEDURE getDateField : */
/*{inbo/boin176.m02} PROCEDURE getDecField : */
/*{inbo/boin176.m02} PROCEDURE getDescriptionFields : */
/*{inbo/boin176.m02} PROCEDURE getDocumEst : */
/*{inbo/boin176.m02} PROCEDURE getHandleDocumEst : */
/*{inbo/boin176.m02} PROCEDURE getIndice : */
/*{inbo/boin176.m02} PROCEDURE getIntField : */
/*{inbo/boin176.m02} PROCEDURE getItem : */
/*{inbo/boin176.m02} PROCEDURE getItemFornec : */
/*{inbo/boin176.m02} PROCEDURE getKey : */
/*{inbo/boin176.m02} PROCEDURE getLogField : */
/*{inbo/boin176.m02} PROCEDURE getQuantOrig : */
/*{inbo/boin176.m02} PROCEDURE getRawField : */
/*{inbo/boin176.m02} PROCEDURE getRowidDocumEst : */
/*{inbo/boin176.m02} PROCEDURE getSeqItem : */
/*{inbo/boin176.m02} PROCEDURE getTotalizaNota : */
/*{inbo/boin176.m02} PROCEDURE getUnidadeMedida : */
/*{inbo/boin176.m02} PROCEDURE getValuesItemMatEstab : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no Ðndice documento
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE item-doc-est.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE item-doc-est.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE item-doc-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE item-doc-est.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE item-doc-est.sequencia NO-UNDO.

    FIND FIRST bfitem-doc-est WHERE 
        bfitem-doc-est.serie-docto = pserie-docto AND 
        bfitem-doc-est.nro-docto = pnro-docto AND 
        bfitem-doc-est.cod-emitente = pcod-emitente AND 
        bfitem-doc-est.nat-operacao = pnat-operacao AND 
        bfitem-doc-est.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÙ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-doc-est THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravìs de rowid e verifica a ocorrªncia de erros, caso
          existam erros serÙ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-doc-est)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeFind DBOProgram 
{inbo/boin176.m30} /* PROCEDURE initializeFind : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeUpdate DBOProgram 
{inbo/boin176.m31} /* PROCEDURE initializeUpdate : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToDocumEst DBOProgram 
PROCEDURE linkToDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter pHandle as handle no-undo.
    

    run getKey in pHandle ( output i-cod-emitente,
                            output c-serie-docto,
                            output c-nro-docto,
                            output c-nat-operacao ).
                            

    run findDocumento ( input i-cod-emitente,
                        input c-serie-docto,
                        input c-nro-docto,
                        input c-nat-operacao ).
                                                    

    RETURN "OK":U.                              


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToMovtoPend DBOProgram 
PROCEDURE linkToMovtoPend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter pHandle as handle no-undo.
    

    run getKey1 in pHandle ( output i-cod-emitente,
                             output c-serie-docto,
                             output c-nro-docto,
                             output c-nat-operacao ).
                            

    RETURN "OK":U.    
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE navegaItemAnterior DBOProgram 
PROCEDURE navegaItemAnterior :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign c-item = {&tablename}.it-codigo.
    assign c-item-atual = c-item.

    repeat while (c-item = c-item-atual):
        get prev qr{&TableName} no-lock no-wait.
        if avail {&TableName} 
        then do: 
            assign c-item-atual = {&tablename}.it-codigo.
            if {&tablename}.it-codigo = "" then return "NOK":U.
        end.
        else return "NOK":U.
    end.

    return "OK":U.
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

    open query qr{&tableName} for each {&tableName} 
        no-lock
        indexed-reposition.
     

    return "OK":U  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFirstMain DBOProgram 
PROCEDURE findFirstMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST {&tableName} 
        NO-LOCK NO-ERROR.
 

    return "OK":U  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLastMain DBOProgram 
PROCEDURE findLastMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND LAST {&tableName} 
        NO-LOCK NO-ERROR.
     

    return "OK":U  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNextMain DBOProgram 
PROCEDURE findNextMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND NEXT {&tableName} 
        NO-LOCK NO-ERROR.
     

    return "OK":U  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPrevMain DBOProgram 
PROCEDURE findPrevMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND PREV {&tableName} 
        NO-LOCK NO-ERROR.
     

    return "OK":U  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocumEst DBOProgram 
PROCEDURE openQueryOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.cod-emitente = i-cod-emitente
           and {&tableName}.serie-docto  = c-serie-docto
           and {&tableName}.nro-docto    = c-nro-docto
           and {&tableName}.nat-operacao = c-nat-operacao 
           no-lock 
           indexed-reposition.
       
    return "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocumEstZoom DBOProgram 
PROCEDURE openQueryOfDocumEstZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    open query qr{&tableName} for each {&tableName}
         where {&tableName}.cod-emitente >= i-ini-cod-emitente
           AND {&tableName}.cod-emitente <= i-fin-cod-emitente
           and {&tablename}.it-codigo  >= c-ini-it-codigo
           and {&tablename}.it-codigo  <= c-fin-it-codigo
           and {&tableName}.nro-docto  >= c-ini-nro-docto
           and {&tableName}.nro-docto  <= c-fin-nro-docto
           AND {&tableName}.cod-emitente = i-cod-emitente
           AND {&tableName}.serie-docto  = c-serie-docto 
           AND {&tableName}.nro-docto     = c-nro-docto   
           AND {&tableName}.nat-operacao = c-nat-operacao
           NO-LOCK indexed-reposition.
    return "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfItDocEstZoom DBOProgram 
PROCEDURE openQueryOfItDocEstZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    OPEN QUERY qr{&tableName} FOR EACH {&tableName}
         WHERE {&tableName}.cod-emitente = i-cod-emitente
           AND {&tableName}.serie-docto  = c-serie-docto 
           AND {&tableName}.nro-docto    = c-nro-docto   
           AND {&tableName}.nat-operacao = c-nat-operacao
           AND {&tableName}.sequencia   >= i-ini-seq-item 
           AND {&tableName}.sequencia   <= i-fin-seq-item 
           AND {&tablename}.it-codigo   >= c-ini-it-codigo
           AND {&tablename}.it-codigo   <= c-fin-it-codigo
           NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFirstOfDocumEst DBOProgram 
PROCEDURE findFirstOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST {&tableName}
         where {&tableName}.cod-emitente = i-cod-emitente
           and {&tableName}.serie-docto  = c-serie-docto
           and {&tableName}.nro-docto    = c-nro-docto
           and {&tableName}.nat-operacao = c-nat-operacao 
           no-lock NO-ERROR.
       

    return "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLastOfDocumEst DBOProgram 
PROCEDURE findLastOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND LAST  {&tableName}
         where {&tableName}.cod-emitente = i-cod-emitente
           and {&tableName}.serie-docto  = c-serie-docto
           and {&tableName}.nro-docto    = c-nro-docto
           and {&tableName}.nat-operacao = c-nat-operacao 
           no-lock NO-ERROR.
       

    return "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNextOfDocumEst DBOProgram 
PROCEDURE findNextOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND NEXT  {&tableName}
         where {&tableName}.cod-emitente = i-cod-emitente
           and {&tableName}.serie-docto  = c-serie-docto
           and {&tableName}.nro-docto    = c-nro-docto
           and {&tableName}.nat-operacao = c-nat-operacao 
           no-lock NO-ERROR.
       

    return "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPrevOfDocumEst DBOProgram 
PROCEDURE findPrevOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND PREV  {&tableName}
         where {&tableName}.cod-emitente = i-cod-emitente
           and {&tableName}.serie-docto  = c-serie-docto
           and {&tableName}.nro-docto    = c-nro-docto
           and {&tableName}.nat-operacao = c-nat-operacao 
           NO-LOCK NO-ERROR.


    return "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocumEstByItem DBOProgram 
PROCEDURE openQueryOfDocumEstByItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName} 
         where {&tableName}.cod-emitente = i-cod-emitente
           and {&tableName}.serie-docto  = c-serie-docto
           and {&tableName}.nro-docto    = c-nro-docto
           and {&tableName}.nat-operacao = c-nat-operacao no-lock
            by {&tableName}.serie-docto
            by {&tableName}.nro-docto
            by {&tableName}.cod-emitente
            by {&tableName}.nat-operacao
            by {&tablename}.it-codigo
            indexed-reposition.

    return "OK":U. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfMovtoPend DBOProgram 
PROCEDURE openQueryOfMovtoPend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.cod-emitente = i-cod-emitente
           and {&tableName}.serie-docto  = c-serie-docto
           and {&tableName}.nro-docto    = c-nro-docto
           and {&tableName}.nat-operacao = c-nat-operacao 
           no-lock 
           indexed-reposition.
       

    return "OK":U.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFirstOfMovtoPend DBOProgram 
PROCEDURE findFirstOfMovtoPend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST {&tableName}
         where {&tableName}.cod-emitente = i-cod-emitente
           and {&tableName}.serie-docto  = c-serie-docto
           and {&tableName}.nro-docto    = c-nro-docto
           and {&tableName}.nat-operacao = c-nat-operacao 
           no-lock NO-ERROR.


    return "OK":U.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLastOfMovtoPend DBOProgram 
PROCEDURE findLastOfMovtoPend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND LAST  {&tableName}
         where {&tableName}.cod-emitente = i-cod-emitente
           and {&tableName}.serie-docto  = c-serie-docto
           and {&tableName}.nro-docto    = c-nro-docto
           and {&tableName}.nat-operacao = c-nat-operacao 
           no-lock NO-ERROR.                        


    return "OK":U.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNextOfMovtoPend DBOProgram 
PROCEDURE findNextOfMovtoPend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND NEXT  {&tableName}
         where {&tableName}.cod-emitente = i-cod-emitente
           and {&tableName}.serie-docto  = c-serie-docto
           and {&tableName}.nro-docto    = c-nro-docto
           and {&tableName}.nat-operacao = c-nat-operacao 
           no-lock NO-ERROR.


    return "OK":U.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPrevOfMovtoPend DBOProgram 
PROCEDURE findPrevOfMovtoPend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND PREV  {&tableName}
         where {&tableName}.cod-emitente = i-cod-emitente
           and {&tableName}.serie-docto  = c-serie-docto
           and {&tableName}.nro-docto    = c-nro-docto
           and {&tableName}.nat-operacao = c-nat-operacao 
           no-lock NO-ERROR.


    return "OK":U.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


{inbo/boin176.m32} /* PROCEDUREs recalculateImposto e recalculaDespesa: */


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE releaseTable DBOProgram 
PROCEDURE releaseTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  LiberaîÒo de registros.     
------------------------------------------------------------------------------*/

    if  avail ord-prod then
        release ord-prod.

    if  avail item then
        release item.

    if  avail item-fornec then
        release item-fornec.
        
    if  avail referencia then
        release referencia.
        
    if  avail pedido-compr then
        release pedido-compr.
        
    if  avail ordem-compra then
        release ordem-compra.

    if  avail prazo-compra then
        release prazo-compra.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnConnectEMS5 DBOProgram 
PROCEDURE returnConnectEMS5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param piConecta as logical no-undo.

    assign piConecta = l-conectado.
    

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnDtVarUsuario DBOProgram 
PROCEDURE returnDtVarUsuario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  Retorna para o zoom de ordens de compra a variaîÒo de data do usuÙrio
          do recebimento.      
------------------------------------------------------------------------------*/

    def output param d-dt-var as date no-undo.

    if  not avail param-re then 
        return "NOK":U.
        
    assign d-dt-var = today + param-re.variacao.        
 

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnItemDocEst DBOProgram 
PROCEDURE returnItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param piSequencia   like item-doc-est.sequencia    no-undo.
    def output param poItCodigo    like item-doc-est.it-codigo    no-undo.
    def output param poCodEmitente like item-doc-est.cod-emitente no-undo.
    def output param poSerieDocto  like item-doc-est.serie-docto  no-undo.
    def output param poNroDocto    like item-doc-est.nro-docto    no-undo.
    def output param poNatOperacao like item-doc-est.nat-operacao no-undo.

    find first item-doc-est 
        where item-doc-est.sequencia    = piSequencia
          and item-doc-est.cod-emitente = i-cod-emitente
          and item-doc-est.serie-docto  = c-serie-docto
          and item-doc-est.nro-docto    = c-nro-docto
          and item-doc-est.nat-operacao = c-nat-operacao no-lock no-error. 

    if avail item-doc-est then do:
       assign poItCodigo    = item-doc-est.it-codigo       
              poCodEmitente = i-cod-emitente
              poSerieDocto  = c-serie-docto
              poNroDocto    = c-nro-docto
              poNatOperacao = c-nat-operacao.
       return "OK":U.
    end.    
    else return "NOK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnNatOperacao DBOProgram 
PROCEDURE returnNatOperacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  Retorna natureza de operaîÒo para o zoom de ordens de compra.     
------------------------------------------------------------------------------*/

    def output param piNatOper like item-doc-est.nat-operacao no-undo.
    
    assign piNatOper = c-nat-operacao.

    return "OK":U.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnPedido DBOProgram 
PROCEDURE returnPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        DEFINE INPUT  PARAM pRowid   AS ROWID NO-UNDO.
        DEFINE OUTPUT PARAM piPedido AS INTE  NO-UNDO.

        FIND FIRST item-doc-est WHERE
             rowid(item-doc-est) = pRowid NO-LOCK NO-ERROR.
        IF AVAIL item-doc-est THEN do:
            IF item-doc-est.num-pedido <> 0 THEN
                ASSIGN piPedido = item-doc-est.num-pedido.
            ELSE DO:
                find first rat-ordem where 
                           rat-ordem.cod-emitente = item-doc-est.cod-emitente and 
                           rat-ordem.serie-docto = item-doc-est.serie-docto   and 
                           rat-ordem.nro-docto = item-doc-est.nro-docto       AND
                           rat-ordem.nat-operacao = item-doc-est.nat-operacao and 
                           rat-ordem.sequencia = item-doc-est.sequencia       
                     no-lock no-error.
                     if  avail rat-ordem then 
                         ASSIGN piPedido = rat-ordem.num-pedido.
            END.
        END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnUnidadeNegocio DBOProgram 
PROCEDURE returnUnidadeNegocio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retorna se o cliente trabalha com Unidades de Neg®cio     
------------------------------------------------------------------------------*/
    def output param piUnidadeNegocio as logical no-undo.

    FIND FIRST ord-prod
        WHERE ord-prod.nr-ord-produ = RowObject.nr-ord-produ NO-LOCK NO-ERROR.
    FIND FIRST unid-negoc-om
        WHERE unid-negoc-om.num-ord-manut = RowObject.nr-ord-produ NO-LOCK NO-ERROR.
    IF AVAIL ord-prod AND ord-prod.origem = "MV":U THEN DO:
    
        IF NOT VALID-HANDLE(hMMVUnidNegoc) THEN
            RUN frbo/bofr134.p PERSISTENT SET hMmvUnidNegoc.

        RUN canFindMatrizMMV IN hMMVUnidNegoc (INPUT ord-prod.nr-ord-produ).

        IF RETURN-VALUE = "OK":U THEN 
            ASSIGN l-unid-negoc-frotas = YES.
        ELSE
            ASSIGN l-unid-negoc-frotas = NO.

        IF VALID-HANDLE(hMMVUnidNegoc) THEN
            DELETE OBJECT hMMVUnidNegoc.
    END.
    if not avail RowObject then
        assign piUnidadeNegocio = no.
    else do:
        /***** Leitura da Naureza de Opera»’o *****/
        run findNaturOper ( RowObject.nat-operacao ).

        /***** Leitura do Item *****/
        run findItem ( input RowObject.it-codigo ).

        if l-mat-unid-negoc /*Parametro de materiais para UN*/
            and not l-ent-cons and not l-retorno and not l-ret-fat /*Terceiros*/
            and not l-devolucao /*Devolu‡Æo*/
            and not natur-oper.log-oper-triang /*Opera‡Æo Triƒngular*/
            and not l-transf /* Transferˆncia */
            and l-re-unid-negoc /*PermissÆo de altera‡Æo da UN pelo usu rio do recebimento*/
            and (RowObject.nr-ord-produ = 0 OR /***** Ordem de produ‡Æo nÆo informada *****/
                 (RowObject.nr-ord-produ <> 0 AND RowObject.num-ord-inv <> 0 AND param-global.modulo-in) ) /***** Ordem de produ‡Æo informada com OI *****/
            and ((item.tipo-contr = 1 or item.tipo-contr = 4) /* 1 - F¡sico 4 - D‚bito Direto*/
                 or (item.tipo-contr = 2 /*2 - Total*/
                     and RowObject.ct-codigo <> ""))
            OR (AVAIL ord-prod AND ( ord-prod.origem = "MI" OR ord-prod.origem = "MV":U ) AND (AVAIL unid-negoc-om OR l-unid-negoc-frotas ) AND l-unidade-negocio) THEN
            assign piUnidadeNegocio = yes.
        ELSE
            assign piUnidadeNegocio = NO.
    end.

    
    return "OK".        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnUnidadeNegocioNF DBOProgram 
PROCEDURE returnUnidadeNegocioNF :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retorna se o cliente trabalha com Unidades de Neg®cio     
------------------------------------------------------------------------------*/
    def output param piUnidadeNegocio as logical no-undo.


    /***** Leitura da Naureza de Opera»’o *****/
    run findNaturOper ( docum-est.nat-operacao ).

    if l-mat-unid-negoc /*Parƒmetro de materiais para UN*/
    and not l-ent-cons and not l-retorno and not l-ret-fat /*Terceiros*/
    and not l-devolucao /*Devolu‡Æo*/
    and not natur-oper.log-oper-triang /*Opera‡Æo Triƒngular*/
    and not l-transf THEN /* Transferˆncia */
        assign piUnidadeNegocio = yes.
    else
        assign piUnidadeNegocio = no.

    
    return "OK".        

END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnUnidNegCriacaoMatrizRateio DBOProgram 
PROCEDURE returnUnidNegCriacaoMatrizRateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retorna se o cliente trabalha com Unidades de Neg©cio para a cria¯Êo da
         matriz de rateio na tabela unid-neg-nota.    
------------------------------------------------------------------------------*/
    def output param piUnidadeNegocio as logical no-undo.
    
    {cdp/cd9911.i} /* Verifica Unidade de Neg½cio */
    
    FIND FIRST ord-prod
        WHERE ord-prod.nr-ord-produ = RowObject.nr-ord-produ NO-LOCK NO-ERROR.
    FIND FIRST unid-negoc-om
        WHERE unid-negoc-om.num-ord-manut = RowObject.nr-ord-produ NO-LOCK NO-ERROR.
    IF AVAIL ord-prod AND ord-prod.origem = "MV":U THEN DO:
    
        IF NOT VALID-HANDLE(hMMVUnidNegoc) THEN
            RUN frbo/bofr134.p PERSISTENT SET hMmvUnidNegoc.

        RUN canFindMatrizMMV IN hMMVUnidNegoc (INPUT ord-prod.nr-ord-produ).

        IF RETURN-VALUE = "OK":U THEN 
            ASSIGN l-unid-negoc-frotas = YES.
        ELSE
            ASSIGN l-unid-negoc-frotas = NO.

        IF VALID-HANDLE(hMMVUnidNegoc) THEN
            DELETE OBJECT hMMVUnidNegoc.
    END.
    if not avail RowObject then
        assign piUnidadeNegocio = no.
    else do:
        /***** Leitura da Naureza de Opera¯Êo *****/
        run findNaturOper ( RowObject.nat-operacao ).

        /***** Leitura do Item *****/
        run findItem ( input RowObject.it-codigo ).

        if l-mat-unid-negoc /*Parƒmetro de materiais para UN*/
            and not l-ent-cons and not l-retorno and not l-ret-fat /*Terceiros*/
            and not l-devolucao /*Devolu‡Æo*/
            and not natur-oper.log-oper-triang /*Opera‡Æo Triƒngular*/
            and not l-transf /* Transferˆncia */
            and (RowObject.nr-ord-produ = 0 OR /***** Ordem de produ‡Æo nÆo informada *****/
                 (RowObject.nr-ord-produ <> 0 AND RowObject.num-ord-inv <> 0 AND param-global.modulo-in) ) /***** Ordem de produ‡Æo nÆo informada *****/
            and ((item.tipo-contr = 1 or item.tipo-contr = 4) /* 1 - F¡sico 4 - D‚bito Direto*/
                 or (item.tipo-contr = 2 /*2 - Total*/
                     and RowObject.ct-codigo <> ""))
            OR (AVAIL ord-prod AND ( ord-prod.origem = "MI" OR ord-prod.origem = "MV":U ) AND (AVAIL unid-negoc-om OR l-unid-negoc-frotas ) AND l-unidade-negocio) THEN DO:
            ASSIGN piUnidadeNegocio = yes.
        END.
        ELSE
            ASSIGN piUnidadeNegocio = NO.
    end.

    
    return "OK".        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE matrizRateioUnidNegocio DBOProgram 
PROCEDURE matrizRateioUnidNegocio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Cria ou Elimina unid-neg-nota de acordo Unidades de Neg«cio da ordem de compra
------------------------------------------------------------------------------*/
    DEF INPUT PARAM piOpcao AS LOGICAL NO-UNDO.

    IF piOpcao THEN DO: /* Criar */
        FOR EACH unid-neg-ordem                                                               
           WHERE unid-neg-ordem.numero-ordem  = ordem-compra.numero-ordem                         
             AND unid-neg-ordem.perc-unid-neg > 0 NO-LOCK:
            CREATE unid-neg-nota.
            ASSIGN unid-neg-nota.cod-emitente   = RowObject.cod-emitente
                   unid-neg-nota.serie-docto    = RowObject.serie-docto
                   unid-neg-nota.nro-docto      = RowObject.nro-docto
                   unid-neg-nota.nat-operacao   = RowObject.nat-operacao
                   unid-neg-nota.sequencia      = RowObject.sequencia
                   unid-neg-nota.cod_unid_negoc = unid-neg-ordem.cod_unid_negoc
                   unid-neg-nota.perc-unid-neg  = unid-neg-ordem.perc-unid-neg.
        END.
    END.
    ELSE DO: /* Deletar */
        IF AVAIL RowObject THEN DO:
            FOR EACH unid-neg-nota
               WHERE unid-neg-nota.cod-emitente = RowObject.cod-emitente
                 AND unid-neg-nota.serie-docto  = RowObject.serie-docto
                 AND unid-neg-nota.nro-docto    = RowObject.nro-docto
                 AND unid-neg-nota.nat-operacao = RowObject.nat-operacao
                 AND unid-neg-nota.sequencia    = RowObject.sequencia EXCLUSIVE-LOCK:
                DELETE unid-neg-nota.
            END.
        END.

    END.
    
    return "OK".        

END PROCEDURE. 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAgrupaPorItem DBOProgram 
PROCEDURE setAgrupaPorItem :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM plAgrupaPorItem as log no-undo.

  ASSIGN lAgrupaPorItem = plAgrupaPorItem.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConnectEMS5 DBOProgram 
{inbo/boin176.m33} /* PROCEDURE setConnectEMS5 : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    return "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfDocumEst DBOProgram 
PROCEDURE setConstraintOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param i-cod-emit  as int  no-undo.
    def input param c-ser-docto as char no-undo.
    def input param c-nr-docto  as char no-undo.
    def input param c-nat-oper  as char no-undo.

        assign i-cod-emitente = i-cod-emit
               c-serie-docto  = c-ser-docto
               c-nro-docto    = c-nr-docto
               c-nat-operacao = c-nat-oper.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfDocumEstZoom DBOProgram 
PROCEDURE setConstraintOfDocumEstZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param i-ini-cod-emit  as int  no-undo.
    def input param i-fin-cod-emit  as int  no-undo.
    def input param c-ini-nro-doc as char no-undo.
    def input param c-fin-nro-doc as char no-undo.
    def input param c-ini-it-cod  as char no-undo.
    def input param c-fin-it-cod  as char no-undo.


        ASSIGN i-ini-cod-emitente = i-ini-cod-emit
               c-ini-nro-docto    = c-ini-nro-doc
               c-ini-it-codigo    = c-ini-it-cod
              
               i-fin-cod-emitente = i-fin-cod-emit
               c-fin-nro-docto    = c-fin-nro-doc
               c-fin-it-codigo    = c-fin-it-cod.
               
               
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfItDocEstZoom DBOProgram 
PROCEDURE setConstraintOfItDocEstZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM i-cod-emit    AS INT  NO-UNDO.
    DEF INPUT PARAM c-ser-docto   AS CHAR NO-UNDO.
    DEF INPUT PARAM c-nr-docto    AS CHAR NO-UNDO.
    DEF INPUT PARAM c-nat-oper    AS CHAR NO-UNDO.
    DEF INPUT PARAM c-ini-seq-it  AS INT  NO-UNDO.
    DEF INPUT PARAM c-fin-seq-it  AS INT  NO-UNDO.
    DEF INPUT PARAM c-ini-it-cod  AS CHAR NO-UNDO.
    DEF INPUT PARAM c-fin-it-cod  AS CHAR NO-UNDO.

    ASSIGN i-cod-emitente   = i-cod-emit
           c-serie-docto    = c-ser-docto
           c-nro-docto      = c-nr-docto
           c-nat-operacao   = c-nat-oper
           i-ini-seq-item   = c-ini-seq-it
           i-fin-seq-item   = c-fin-seq-it
           c-ini-it-codigo  = c-ini-it-cod
           c-fin-it-codigo  = c-fin-it-cod.
               
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultCalculoImpostos DBOProgram 
{inbo/boin176.m06} /* PROCEDURE setDefaultCalculoImpostos : */

/*{inbo/boin176.m06} PROCEDURE setDefaultsEstoque : */
/*{inbo/boin176.m06} PROCEDURE setDefaultsEtiquetas : */
/*{inbo/boin176.m06} PROCEDURE setDefaultsFields : */
/*{inbo/boin176.m06} PROCEDURE setDefaultsItem : */
/*{inbo/boin176.m06} PROCEDURE setDefaultsOperTriang : */
/*{inbo/boin176.m06} PROCEDURE setDefaultsOrdCompServico : */
/*{inbo/boin176.m06} PROCEDURE setDefaultsOrdemCompra : */
/*{inbo/boin176.m06} PROCEDURE setDefaultsPrecoTotal : */
/*{inbo/boin176.m06} PROCEDURE setDefaultsQtdScreen : */
/*{inbo/boin176.m06} PROCEDURE setDefaultsQuantidade : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDescItem DBOProgram 
{inbo/boin176.m34} /* PROCEDURE setDescItem : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDespesasItem DBOProgram 
{inbo/boin176.m35} /* PROCEDURE setDespesasItem : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setQtdeTributavelIS DBOProgram 
{inbo/boin176.m53} /* PROCEDURE setQtdeTributavelIS : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDocumEst DBOProgram 
PROCEDURE setDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    run getKey in h-boin090 ( output i-cod-emitente,
                              output c-serie-docto,
                              output c-nro-docto,
                              output c-nat-operacao ).

    run setConstraintOfDocumEst ( input i-cod-emitente,
                                  input c-serie-docto,  
                                  input c-nro-docto,
                                  input c-nat-operacao ).

    run findDocumento ( input i-cod-emitente,
                        input c-serie-docto,
                        input c-nro-docto,
                        input c-nat-operacao ).

    run findUsuario ( docum-est.usuario ).

    if  not avail param-re then do:
        find docum-est 
           where docum-est.cod-emitente = i-cod-emitente
             and docum-est.serie-docto  = c-serie-docto
             and docum-est.nro-docto    = c-nro-docto
             and docum-est.nat-operacao = c-nat-operacao exclusive-lock no-error.
        if  avail docum-est THEN DO:
            assign docum-est.usuario = c-seg-usuario.                                                         
            release docum-est.
        END.
    end.    

    run InitializeFind.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEpCodigo DBOProgram 
PROCEDURE setEpCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Determina a empresa principal.      
------------------------------------------------------------------------------*/

    def output param piEmpresa like param-global.empresa-prin no-undo.

    if  not avail docum-est then
        return "NOK":U.

    run findEstabelec ( docum-est.cod-estabel ).
    

    assign piEmpresa = i-empresa.

    RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setHandleDocumEst DBOProgram 
PROCEDURE setHandleDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-boin090   as handle no-undo.


    assign h-boin090 = p-boin090.
    

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setItDoForn DBOProgram 
PROCEDURE setItDoForn :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  Recebe item do fornecedor.
------------------------------------------------------------------------------*/

    def input param pItDoForn like item-doc-est.it-codigo no-undo.
    

    assign c-it-do-forn = pItDoForn.
    

    return "OK":U.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSimplesNac DBOProgram 
PROCEDURE setSimplesNac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  Recebe item do fornecedor.
------------------------------------------------------------------------------*/
    
    DEF INPUT PARAM pAliqSimplesNac AS DECIMAL NO-UNDO.

    ASSIGN de-aliq-simplesnac = pAliqSimplesNac.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE totalizaItens DBOProgram 
PROCEDURE totalizaItens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  parameter pi-cod-emit  as int  no-undo.
    def input  parameter pc-ser-docto as char no-undo.
    def input  parameter pc-nr-docto  as char no-undo.
    def input  parameter pc-nat-oper  as char no-undo.

    def input  parameter pccod-item   as char no-undo.
    def output parameter pde-qtde     as dec  no-undo.
    def output parameter pde-unit     as dec  no-undo.
    def output parameter pde-total    as dec  no-undo.

    for each bf{&TableName} where bf{&tableName}.cod-emitente = pi-cod-emit
                              and bf{&tableName}.serie-docto  = pc-ser-docto
                              and bf{&tableName}.nro-docto    = pc-nr-docto
                              and bf{&tableName}.nat-operacao = pc-nat-oper
                              and bf{&tablename}.it-codigo    = pccod-item no-lock:

        assign pde-qtde   = pde-qtde  + bf{&TableName}.quantidade.
        /* assign pde-unit   = pde-unit  + bf{&TableName}.preco-unit[1].*/
        assign pde-total  = pde-total + bf{&TableName}.preco-total[1].
    end.

    assign pde-unit = pde-total / pde-qtde.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TransferTotalItensNota DBOProgram 
{inbo/boin176.m36} /* PROCEDURE TransferTotalItensNota : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateContaContabil DBOProgram 
{inbo/boin176.m37} /* PROCEDURE validateContaContabil : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreateRecord DBOProgram 
{inbo/boin176.m38} /* PROCEDURE validateCreateRecord : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDevolucao DBOProgram 
{inbo/boin176.m39} /* PROCEDURE validateDevolucao : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateOperTriang DBOProgram 
{inbo/boin176.m40} /* PROCEDURE validateOperTriang : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateOrdProd DBOProgram 
{inbo/boin176.m41} /* PROCEDURE validateOrdProd : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validatePedidoOrdem DBOProgram 
{inbo/boin176.m42} /* PROCEDURE validatePedidoOrdem : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidateType DBOProgram 
PROCEDURE ValidateType :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: ValidaŒ‹es da quantidade.
------------------------------------------------------------------------------*/

    def OUTPUT parameter pType  as char                       no-undo.

    IF l-passou = YES THEN
       ASSIGN pType = c-tipo.
    ELSE
       ASSIGN pType = "".

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateQuantidade DBOProgram 
{inbo/boin176.m43} /* PROCEDURE validateQuantidade : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
{inbo/boin176.m44} /* PROCEDURE validateRecord : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUpdateRecord DBOProgram 
{inbo/boin176.m45} /* PROCEDURE validateUpdateRecord : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateValores DBOProgram 
{inbo/boin176.m46} /* PROCEDURE validateValores : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateValoresIpiPisCofins DBOProgram 
{inbo/boin176.m47} /* PROCEDURE validateValoresIpiPis : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugereItemUniEstab DBOProgram 
{inbo/boin176.m48} /* PROCEDURE sugereItemUniEstab : */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindMoeda DBOProgram 
PROCEDURE FindMoeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo    LIKE item-doc-est.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pnumero-ordem LIKE item-doc-est.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pmoeda       AS INTEGER NO-UNDO.

    FIND cotacao-item
        WHERE cotacao-item.it-codigo    = pit-codigo 
          AND cotacao-item.numero-ordem = pnumero-ordem   
          AND cotacao-item.cot-aprovada = YES NO-LOCK NO-ERROR .

    IF AVAIL cotacao-item THEN
       ASSIGN pmoeda = cotacao-item.mo-codigo .

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gravaPerPpm DBOProgram 
PROCEDURE gravaPerPpm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pe-per-ppm AS DECIMAL FORMAT ">>>,>>9.9999" NO-UNDO.
    ASSIGN e-per-ppm = pe-per-ppm.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsUnidadeNegocio DBOProgram 
{inbo/boin176.m50} /* PROCEDURE setDefaultsUnidadeNegocio : */

/*{inbo/boin176.m50} PROCEDURE setUnidadeNegocioOrdemProducao : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUnidadeNegocio DBOProgram 
{inbo/boin176.m51} /* PROCEDURE validateUnidadeNegocio : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFatAntecipEntFutura DBOProgram 
{inbo/boin176.m55} /* PROCEDURE getFatAntecipEntFutura : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getContaEntFutFatAntecip DBOProgram 
{inbo/boin176.m56} /* PROCEDURE getContaEntFutFatAntecip : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createItemOfFatAntecip DBOProgram 
{inbo/boin176.m57} /* PROCEDURE createItemOfFatAntecip : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getZoomConta DBOProgram 
{inbo/boin176.m58} /* PROCEDURE getZoomConta : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValidaConta DBOProgram 
{inbo/boin176.m59} /* PROCEDURE getValidaConta : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFormatoConta DBOProgram 
{inbo/boin176.m60} /* PROCEDURE getFormatoConta : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getZoomCcusto DBOProgram 
{inbo/boin176.m61} /* PROCEDURE getZoomCcusto : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValidaCcusto DBOProgram 
{inbo/boin176.m62} /* PROCEDURE getValidaCcusto : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFormatoCCusto DBOProgram 
{inbo/boin176.m63} /* PROCEDURE getFormatoCCusto : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getZoomCcustoxCtaCtbl DBOProgram 
{inbo/boin176.m65} /* PROCEDURE getZoomCcustoxCtaCtbl : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaNatOperItem DBOProgram 
{inbo/boin176.m66} /* PROCEDURE validaNatOperItem : */
/*{inbo/boin176.m66}  PROCEDURE validateTypeMovto : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createItemOfRemessaFatAntecip DBOProgram 
{inbo/boin176.m68} /* PROCEDURE createItemOfRemessaFatAntecip : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recalculateImpostoICMS DBOProgram
{inbo/boin176.m69} /* PROCEDURE recalculateImpostoICMS : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugere_simples_nacional DBOProgram
{inbo/boin176.m70} /* PROCEDURE sugere_simples_nacional : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaDescontoICMS DBOProgram
{inbo/boin176.m71} /* PROCEDURE calculaDescontoICMS: */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{inbo/boin176.m72} /* PROCEDURE createItemOfMultaJuros, rateioProporcional, piEngineMultaJurosNatOf e piVarEngineMultaJurosNatOf*/


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gravar-dados-cfg-trib DBOProgram 
{inbo/boin176.m98} /* PROCEDURE pi-gravar-dados-cfg-trib : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*REINF*/
{inbo/boin176.m100}

/*CST*/
{inbo/boin176.m101}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQtdsParcela DBOProgram 
PROCEDURE getQtdsParcela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAM p-numero-ordem  LIKE prazo-compra.numero-ordem.
    DEFINE INPUT  PARAM p-parcela       LIKE prazo-compra.parcela.
    DEFINE OUTPUT PARAM p-qt-do-forn    LIKE item-doc-est.qt-do-forn.
    DEFINE OUTPUT PARAM p-quantidade    LIKE item-doc-est.quantidade.

    FOR FIRST prazo-compra FIELDS( numero-ordem    parcela         quant-saldo 
                                   situacao        data-entrega    dec-1       
                                   quant-rejeit     qtd-sal-forn     quantidade  
                                   quant-receb     cod-refer       un 
                                   qtd-do-forn) 
        WHERE prazo-compra.numero-ordem = p-numero-ordem
          AND prazo-compra.parcela      = p-parcela NO-LOCK:
        ASSIGN p-qt-do-forn = prazo-compra.qtd-do-forn 
               p-quantidade = prazo-compra.quantidade.

    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaIndiceConversao DBOProgram 
PROCEDURE retornaIndiceConversao :
/*------------------------------------------------------------------------------
  Purpose:     Procedure utilizada para retornar o ­ndice de convers’o
               das unidades do fornecedor
  Parameters:  pc-item - c½digo do item
               pi-emitente - c½digo do Fornecedor
               p-un-fornec - unidade do Fornecedor
               p-de-indice - ­ndice de convers’o
  Notes:
------------------------------------------------------------------------------*/
    define input  param pc-item         like item-doc-est.it-codigo  no-undo.
    define input  param pi-emitente     like emitente.cod-emitente   no-undo.
    DEFINE INPUT  PARAM p-un-fornec     LIKE item-doc-est.un         no-undo.
    DEFINE OUTPUT PARAM p-de-indice     as decimal                   no-undo.

    DEFINE VARIABLE de-indice AS DECIMAL     NO-UNDO.
    run findItem (pc-item).
    
    IF RETURN-VALUE = "NOK" THEN
       RETURN "NOK". 
    
    {cdp/cd9950.i item.un p-un-fornec pi-emitente} /*calcula ­ndice de convers’o*/
       
    assign p-de-indice = de-indice.
       
    return "OK":U.
    
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-set-cria-rat-lote DBOProgram 
PROCEDURE pi-set-cria-rat-lote :
/*------------------------------------------------------------------------------
  Purpose:     NO - Nao deve criar o rat-lote pelos defaults setDefaultsEstoque
               
  Parameters:  yes/no
               
  Notes:
------------------------------------------------------------------------------*/
	DEF INPUT PARAM p-input as log no-undo.

	assign l-cria-rat-lote = p-input.
		    /* qdo for FALSE nao seta os defaults de depos, local, refer na setDefaultsEstoque */
	
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaDocFisico DBOProgram 
PROCEDURE verificaDocFisico :
/*------------------------------------------------------------------------------
  Purpose:     Procedure utilizada para verificar se hÿ documento f­sico
               cadastrado para o documento fiscal que estÿ sendo criado
  Parameters:  l-doc-fisico - campo l½gico que indica se hÿ documento f­sico
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM l-doc-fisico as log no-undo.

    if not avail param-estoq then
        find first param-estoq no-lock no-error.

    if avail param-estoq then
        assign l-doc-fisico = avail RowObject 
                                and avail docum-est
                                and param-estoq.rec-fisico
                                and can-find(first doc-fisico 
                                        where doc-fisico.serie-docto  = RowObject.serie-docto 
                                          and doc-fisico.nro-docto    = RowObject.nro-docto   
                                          and doc-fisico.cod-emitente = RowObject.cod-emitente
                                          and doc-fisico.tipo-nota    = docum-est.tipo-nota).
    return "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE naoRecalculaItensNota DBOProgram 
PROCEDURE naoRecalculaItensNota :
/*------------------------------------------------------------------------------
  Purpose:     Se a nota for complementar de importa‡Æo nÆo recalcula nada
  Parameters:  recebe:  codigo do emitente
                        serie do documento
                        numero do documento
                        natureza de opera‡Æo
               
               Retorna: OK ou NOK        
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-emitente LIKE item-doc-est.cod-emitente.
    DEFINE INPUT PARAMETER p-serie-docto  LIKE item-doc-est.serie-docto.
    DEFINE INPUT PARAMETER p-nro-docto    LIKE item-doc-est.nro-docto.
    DEFINE INPUT PARAMETER p-nat-operacao LIKE item-doc-est.nat-operacao.

    run getDocumEst (input p-cod-emitente,
                     input p-serie-docto,
                     input p-nro-docto,
                     input p-nat-operacao).

    IF TRIM(SUBSTRING(docum-est.char-1,1,20)) <> "" THEN DO:        /*Verifica se tem embarque caracterizando importa‡Æo */
        IF CAN-FIND (FIRST natur-oper
                     WHERE natur-oper.nat-operacao = docum-est.nat-operacao
                       AND natur-oper.nota-rateio /*Complementar*/
                       /*AND (natur-oper.nat-operacao BEGINS "1" OR natur-oper.nat-operacao BEGINS "2")*/) THEN
                        
                            RETURN "OK":U.                                                               
        ELSE
            RETURN "NOK":U.
    END.
    ELSE
        RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
/*    526635    */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAliquotaPIS DBOProgram 
PROCEDURE setAliquotaPIS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-aliq-pis    as dec format ">>9.9999" no-undo.
    assign de-aliquota-pis = p-aliq-pis.
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAliquotaCOFINS DBOProgram 
PROCEDURE setAliquotaCOFINS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-aliq-cofins    as dec format ">>9.9999" no-undo.
    assign de-aliquota-cofins = p-aliq-cofins.
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE executarEngineRecSemPedido DBOProgram 
PROCEDURE executarEngineRecSemPedido:
    DEFINE OUTPUT PARAM pRecebeSemPedido AS LOGICAL NO-UNDO.
    DEFINE VARIABLE h-reapi427  AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cChaveDocto AS CHARACTER   NO-UNDO.
    
    RUN rep/reapi427.p PERSISTENT SET h-reapi427.
    
    ASSIGN cChaveDocto = STRING(docum-est.cod-emitente) + "|" + docum-est.serie-docto + "|" + docum-est.nro-docto + "|" + string(docum-est.nat-operacao) + "|" + string(RowObject.sequencia).

    RUN setChaveDocto  IN h-reapi427 (INPUT cChaveDocto).
    RUN setCodEstabel  IN h-reapi427 (INPUT docum-est.cod-estabel).
    RUN setCodEmitente IN h-reapi427 (INPUT docum-est.cod-emitente).
    RUN setCodObserva  IN h-reapi427 (INPUT docum-est.cod-observa).
    RUN setUsuario     IN h-reapi427 (INPUT docum-est.usuario).
    RUN setNatOperacao IN h-reapi427 (INPUT docum-est.nat-operacao).
    RUN setNatFiscal   IN h-reapi427 (INPUT RowObject.nat-of).
    RUN setItCodigo    IN h-reapi427 (INPUT RowObject.it-codigo).
    RUN setSeqItem     IN h-reapi427 (INPUT RowObject.sequencia).
    RUN engineRegrasRecSemPedido IN h-reapi427 (OUTPUT pRecebeSemPedido).

    RETURN "OK":U.
    FINALLY:
        DELETE PROCEDURE h-reapi427 NO-ERROR.
        ASSIGN h-reapi427 = ?.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE utilizaImpostosMonitor DBOProgram 
{rep/imp/utilizaImpostosMonitor.i} 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME  

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calc-exclusao-bc-pis-cofins DBOProgram 
PROCEDURE pi-calc-exclusao-bc-pis-cofins:
    /*Calcular a exclusÆo do ICMS da base de c lculo do PIS/COFINS */

    DEFINE INPUT    PARAMETER p-cod-chave-aces-nf-eletro    LIKE docum-est.cod-chave-aces-nf-eletro NO-UNDO.
    DEFINE INPUT    PARAMETER p-origem                      AS CHARACTER                            NO-UNDO.
    DEFINE INPUT    PARAMETER p-sequencia                   AS INTEGER                              NO-UNDO.
   
    ASSIGN l-utilizaImpostoMonitor = NO.
    RUN utilizaImpostosMonitorRecFiscal (INPUT  RowObject.serie-docto,
                                         INPUT  RowObject.nro-docto,
                                         INPUT  RowObject.cod-emitente,
                                         INPUT  RowObject.nat-operacao,
                                         INPUT  INT(SUBSTRING(RowObject.char-2,832,5)),
                                         OUTPUT l-utilizaImpostoMonitor).
            
    IF l-utilizaImpostoMonitor = NO THEN DO:
        
        IF  NOT VALID-HANDLE(h-reapi429) THEN        
            RUN rep/reapi429.p PERSISTENT SET h-reapi429.
        empty temp-table tt-item-doc-est-tribut-aux.     
        RUN emptyTtItemDocEstTribut IN h-reapi429.

        RUN calcDescBcPisCofins  IN h-reapi429 (INPUT BUFFER RowObject:HANDLE).
        RUN getTtItemDocEstTribut   IN h-reapi429 ( OUTPUT TABLE tt-item-doc-est-tribut-aux).
        
        FOR EACH tt-item-doc-est-tribut-aux:
        
            FIND FIRST tt-item-doc-est-tribut
                 WHERE tt-item-doc-est-tribut.cod-serie-docto   = tt-item-doc-est-tribut-aux.cod-serie-docto 
                   AND tt-item-doc-est-tribut.cod-num-docto     = tt-item-doc-est-tribut-aux.cod-num-docto
                   AND tt-item-doc-est-tribut.cdn-emitente      = tt-item-doc-est-tribut-aux.cdn-emitente
                   AND tt-item-doc-est-tribut.cod-natur-operac  = tt-item-doc-est-tribut-aux.cod-natur-operac
                   AND tt-item-doc-est-tribut.num-seq           = tt-item-doc-est-tribut-aux.num-seq
                   AND tt-item-doc-est-tribut.nom-trib          = tt-item-doc-est-tribut-aux.nom-trib
                   AND tt-item-doc-est-tribut.cod-campo         = tt-item-doc-est-tribut-aux.cod-campo  NO-ERROR.
          
            IF AVAIL tt-item-doc-est-tribut THEN DO:
               ASSIGN tt-item-doc-est-tribut.cod-conteudo = tt-item-doc-est-tribut-aux.cod-conteudo.
            END.
            ELSE DO:
                CREATE tt-item-doc-est-tribut.
                BUFFER-COPY tt-item-doc-est-tribut-aux to tt-item-doc-est-tribut.
            END.   
        END.
    END.
    
    RETURN "OK":U.
    FINALLY:
      IF VALID-HANDLE(h-reapi429) THEN DO:
         DELETE PROCEDURE h-reapi429 NO-ERROR.
         ASSIGN h-reapi429 = ?.     
      END.
    END FINALLY.
END PROCEDURE.          
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setExecutarFifoRe1001p DBOProgram 
PROCEDURE setExecutarFifoRe1001p:
    DEFINE INPUT PARAMETER pl-executar-fifo-re1001p AS LOGICAL NO-UNDO.
    
    ASSIGN l-executar-fifo-re1001p = pl-executar-fifo-re1001p.
    
    RETURN "OK":U.

END PROCEDURE.          
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{abp/ab0805.i RowObject}
