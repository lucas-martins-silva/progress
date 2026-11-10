/***************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa. 
**************************************************************************/
{include/i-prgvrs.i BOIN090 2.00.00.186 } /*** "010086" 03/11/2026 11:13:19 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin090 MUT}
&ENDIF
        
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que contÆm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  ******************************/

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN090
&GLOBAL-DEFINE DBOVersion 1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  docum-est
&GLOBAL-DEFINE TableLabel Documentos Recebimento
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE excludeFrameDefinition YES

/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/ 
{include/i-estab-security.i}
/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idÆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin090.i RowObject}


/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
/*{method/dboqry.i}*/

{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgcex.i}
{include/i_prdvers.i}
{cdp/cd2508.i}

/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF BUFFER b-docum-est    FOR docum-est.
DEF BUFFER b-rat-docum    FOR rat-docum.
DEF BUFFER b-estabelec    FOR estabelec.
DEF BUFFER b-emitente     FOR emitente.
DEF BUFFER bf-emitente    FOR emitente.
DEF BUFFER b-natur-oper   FOR natur-oper.
DEF BUFFER b-item-doc-est FOR item-doc-est.

/* Vari veis Utilizadas para Controle de Programas Espec¡ficos */
def new global shared var i-cod-emit-aux like emitente.cod-emitente no-undo. 
def new global shared var rw-nota-fis    as   rowid                 no-undo. 
def new global shared var gl-natOperTr   LIKE natur-oper.nat-operacao   no-undo.
DEF VAR c-cod-estabel-usuar LIKE estabelec.cod-estabel NO-UNDO.
DEF VAR l-erro-nat      AS LOGICAL  NO-UNDO.

define new global shared variable gc-peso-bruto-tot as CHAR no-undo.
DEF VAR i-forma-emis      AS INTEGER  NO-UNDO.
DEF VAR rw-prox-docum-est AS ROWID    NO-UNDO.

{utp/ut-glob.i}

def var l-industria     as logical  no-undo.
def var l-comercio      as logical  no-undo.
def var l-devolucao     as logical  no-undo.
def var l-dev-transf    as logical  no-undo.
def var l-servicos      as logical  no-undo.
def var l-transf        as logical  no-undo.
def var l-ent-cons      as logical  no-undo.
def var l-retorno       as logical  no-undo.
def var l-ret-fat       as logical  no-undo.
def var l-reaj-preco    as logical  no-undo.
DEF VAR l-multa-juros   AS LOGICAL  NO-UNDO.
def var h_bodi317im2bra as handle   no-undo.
def var h_boin060       as handle   no-undo.
def var h_boin176       as handle   no-undo.
def var h-boin367       as handle   no-undo.
def var h-bocx378       as handle   no-undo.
def var h-bocx383       as handle   no-undo.
def var h-boin01016     as handle   no-undo. 
def var h-reapi007      as handle   no-undo.

def var l-movto-est     as logical  no-undo.
def var l-erro-item-pf  as logical  no-undo.
def var l-spp-NT2024002 as logical  no-undo.

def var c-docto-ini     like docum-est.nro-docto       no-undo.
def var c-docto-fim     like docum-est.nro-docto       no-undo.
def var i-emite-ini     like docum-est.cod-emitente    no-undo.
def var i-emite-fim     like docum-est.cod-emitente    no-undo.
def var da-data-ini     like docum-est.dt-trans        no-undo.
def var da-data-fim     like docum-est.dt-trans        no-undo.
def var i-empresa       like param-global.empresa-prin no-undo.

/*Defini‡äes para a setconstraitbydocto*/
def var cDoctoIni       like docum-est.nro-docto    no-undo.
def var cDoctoFim       like docum-est.nro-docto    no-undo.
def var iEmiteIni       like docum-est.cod-emitente no-undo.
def var iEmiteFim       like docum-est.cod-emitente no-undo.   
def var daDataIni       like docum-est.dt-trans     no-undo.
def var daDataFim       like docum-est.dt-trans     no-undo.
def var cEstabIni       like docum-est.cod-estabel  no-undo. 
def var cEstabFim       like docum-est.cod-estabel  no-undo.
def var cSerieIni       like docum-est.serie-docto  no-undo. 
def var cSerieFim       like docum-est.serie-docto  no-undo.
DEF VAR cNrEmbarque       AS CHAR FORMAT "x(12)"    NO-UNDO.

/*Defini‡äes para a setconstraitChave*/
DEF VAR cSerie       LIKE docum-est.serie-docto  no-undo.
DEF VAR cDocto       like docum-est.nro-docto    no-undo. 
DEF VAR cEmitente    like docum-est.cod-emitente no-undo. 
DEF VAR CnatOperacao like docum-est.nat-operacao no-undo.
/* Fretes */
DEFINE VARIABLE h-bosc003 AS HANDLE     NO-UNDO.


def var c-serie-docto      as char      no-undo.
def var i-cod-emitente     as int       no-undo.
def var c-nro-docto        as char      no-undo.
def var c-nat-operacao     as char      no-undo.
def var l-grava-consist-nota  as log    no-undo.
def var c-nat-operacao-aux as char      no-undo.
def var c-nat-oper-comp    as char      no-undo.
def var l-varias-oper      as log       no-undo initial no.
def var cType              as char      no-undo.
/*vari veis utilizadas para o m¢dulo de importa‡Æo*/
def var l-imp              as logical   no-undo initial no.
def var l-fornec-fundap    as logical   no-undo. /* Nas opera‡„es de FUNDAP permite Fornecedores Nacionais */
def var lErro              as logical   no-undo.
def var h-bocx332          as handle    no-undo.
def var h-bocx250          as handle    no-undo.
def var l-inc-icms-tot-nf  as logical   no-undo.
def var l-item             as logical   no-undo.
def var de-nota            as decimal   no-undo.

/****************************************/
DEF VAR c-arrendador       AS CHAR NO-UNDO.
DEF VAR c-contrato-leasing AS CHAR NO-UNDO.
/****************************************/

DEF VAR c-cidade-fato-gerador AS CHAR NO-UNDO.
DEF VAR c-uf-fato-gerador     AS CHAR NO-UNDO.
DEF VAR c-pais-fato-gerador   AS CHAR NO-UNDO.

def var h_api_cta_ctbl     as handle no-undo.
def var h_api_ccusto       as handle no-undo.
def var v_log_utz_ccusto   as log    no-undo.
def var v_num_tip_cta_ctbl as int    no-undo.
def var v_num_sit_cta_ctbl as int    no-undo.
def var v_cod_cta_ctbl     as char   no-undo.
def var v_des_cta_ctbl     as char   no-undo.
def var v_ind_finalid_cta  as char   no-undo.
def var v_cod_formato      as char   no-undo.
def var v_des_ccusto       as char   no-undo.
def var v_cod_ccusto       as char   no-undo.
DEF VAR icont              AS INT    NO-UNDO.
def var c-cod-estabel-oc   like ordem-compra.cod-estabel no-undo.

/******** UF RECINTO********/
DEFINE VARIABLE h-reapi413 AS HANDLE      NO-UNDO.
DEFINE VARIABLE cUfRecinto AS CHARACTER   NO-UNDO.
/***************************/

/* Definicao de Temp-Table para Calculo dos Impostos */
{dibo/bodi317im2bra.i1 }

{inbo/boin176.i5 tt-saldo-terc } /* Defini‡Æo tt-saldo-terc */
{inbo/boin176.i2}                /* Defini‡Æo TT-TOTAL-ITEM */

{cdp/cd0666.i}                   /* Defini‡Æo tt-erro */
{cdp/cd4300.i3}                  /* Variaveis para CD4300.I4  */
{cdp/cd0604.i50}                 /* Variaveis para CD0604     */  
{include/i-epc200.i boin090}     /* Upc */

{rep/re1005.i05}
{rep/re1005b8.i}
{dibo/bodi515.i tt-nota-fisc-adc} 
{dibo/bodi516.i tt-item-nf-adc}
{rep/re1001a.i50}   /* variaveis e informacoes utilizadas pelo re1001a.i51 */
{inbo/boin01126.i tt-docum-est-tribut}
{inbo/boin01126.i tt-docum-est-tribut-aux}

/** Funcao Bloqueio de Fornecedores - 205 **/
def temp-table tt-erro-cdapi029 no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)":U
    field c-param  as char.
/*--- temp-tables usadas na atualizacao do documento ---*/
define temp-table tt-param NO-UNDO
    field destino            as integer
    field arquivo            as char
    field usuario            as char
    field data-exec          as date
    field hora-exec          as integer
    field classifica         as integer
    field c-cod-estabel-ini  as char
    field c-cod-estabel-fim  as char
    field i-cod-emitente-ini as integer
    field i-cod-emitente-fim as integer
    field c-nro-docto-ini    as char
    field c-nro-docto-fim    as char
    field c-serie-docto-ini  as char
    field c-serie-docto-fim  as char
    field c-nat-operacao-ini as char
    field c-nat-operacao-fim as char
    field da-dt-trans-ini    as date
    field da-dt-trans-fim    as date.
    

define temp-table tt-digita NO-UNDO
    field r-docum-est        as rowid.
        
DEFINE TEMP-TABLE tt-nat-of-itens NO-UNDO /* Naturezas fiscais informadas para os itens do browser re2001t */
    FIELD sequencia   LIKE it-doc-fisico.sequencia /* tt utilizada no recebimento f¡sico... */
    FIELD nat-of      LIKE item-doc-est.nat-of
    INDEX i-sequencia IS PRIMARY sequencia.

DEFINE TEMP-TABLE tt-ext-docum-est NO-UNDO LIKE ext-docum-est
    FIELD r-Rowid          AS ROWID.

DEF TEMP-TABLE tt-ext-item-doc-est NO-UNDO LIKE ext-item-doc-est
    FIELD r-Rowid          AS ROWID.

def var raw-param        as raw no-undo.

def var h_b01cx255       as HANDLE NO-UNDO.
def temp-table tt-raw-digita NO-UNDO
   field raw-digita   as raw.
   
/*Utilizado no pre-processador {&bf_libera_15_posicoes}*/ 
define variable c-formato as char format "x(16)" no-undo. /*Alterado em 05/01/2010*/

assign c-formato = ">>>>>>>>9999999". /* Formato de 15 posi‡äes */

{include/i-win.i}   /* Usado para rodar o aplicativo em windows */

/*--------------------------------------------*/


def var h_bocx220       as handle.
DEF VAR h-boin847       AS HANDLE NO-UNDO.
def var c-return as char no-undo. 

/* Fretes */
DEFINE VARIABLE h-bosc014     AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-bosc019     AS HANDLE     NO-UNDO.
DEFINE VARIABLE l-log-frete   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE i-cod-servico AS INTEGER    NO-UNDO.


/*-----------------------Automa‡Æo das reten‡äes no recebimento--------------------------------*/
def var h-btb009za     as handle no-undo.
def var c-help         as char   no-undo.
def var l-conectado    as log    no-undo.
def var l-ja-conectado as log    no-undo.
def var l-erro-imp     as log    no-undo.

DEFINE VARIABLE c-cod-empresa LIKE estabelec.ep-codigo   NO-UNDO.
DEFINE VARIABLE c-cod-estabel LIKE estabelec.cod-estabel NO-UNDO.

{btb/btb009za.i}
{inbo/boin176.m33}

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seqˆncia" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistˆncia" column-label "Inconsistˆncia"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    index tt_id                           
          ttv_num_seq                      ascending
          ttv_num_cod_erro                 ascending.

	
/* IRRF */

/*--- Temp-tables utilizadas para traduzir a empresa/estab ---*/
def temp-table tt_xml_input_output no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_des_conteudo_aux             as character format "x(40)"
    field ttv_num_seq_1                    as integer format ">>>,>>9".                

/*--- Temp-tables utilizadas para retornar os impostos do fornecedor ---*/
def temp-table tt_param_integr_imptos_apb no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_val_pagto_tit_ap             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Pagamentos" column-label "Vl Pagtos"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field ttv_log_impto_obrig              as logical format "Sim/NÆo" initial no label "Imptos Obrigat¢rios"
    field ttv_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP".

def temp-table tt_integr_imptos_pgto_apb no-undo
    field ttv_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_nom_abrev_fornec             as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_des_imposto                  as character format "x(40)" label "Descr  Imposto" column-label "Descri‡Æo"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field tta_val_aliq_impto               as decimal format ">9.9999" decimals 4 initial 0.00 label "Al¡quota" column-label "Aliq"
    field tta_val_imposto                  as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut vel" column-label "Vl Rendto Tribut"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_log_impto_opcnal             as logical format "Sim/NÆo" initial no label "Imposto Opcional" column-label "Opcional".

def temp-table tt_erros_integr_imptos_apb no-undo
    field ttv_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "Número" column-label "Numero"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda".
	
/*IRRF*/	
	
	
/*---------------------------------------------------------------------------------------------*/


/* Nf-e */

DEF NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOG NO-UNDO.

DEFINE VARIABLE h-axsep003 AS HANDLE NO-UNDO .

{btb/btb912zb.i}

DEFINE TEMP-TABLE tt_nfe_erro NO-UNDO
    FIELD cStat     AS CHAR  
    FIELD chNFe     AS CHAR  
    FIELD dhRecbto  AS CHAR  
    FIELD nProt     AS CHAR. 

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_num_cod_erro  AS INTEGER   INITIAL ?
     FIELD ttv_des_msg_ajuda AS CHARACTER INITIAL ?
     FIELD ttv_des_msg_erro  AS CHARACTER INITIAL ?.

DEFINE TEMP-TABLE ttReturnInvoiceDocument NO-UNDO
    FIELD chNFe     AS CHARACTER INITIAL ? 
    FIELD cStat     AS CHARACTER INITIAL ? 
    FIELD dhRecbto  AS CHARACTER INITIAL ? 
    FIELD digVal    AS CHARACTER INITIAL ? 
    FIELD id        AS CHARACTER INITIAL ? 
    FIELD nProt     AS CHARACTER INITIAL ? 
    FIELD Signature AS CHARACTER INITIAL ? 
    FIELD tpAmb     AS CHARACTER INITIAL ? 
    FIELD verAplic  AS CHARACTER INITIAL ? 
    FIELD versao    AS DECIMAL   INITIAL ? 
    FIELD xMotivo   AS CHARACTER INITIAL ? 
    FIELD tpEmis    AS CHARACTER INITIAL ?
    FIELD lDanfe    AS LOGICAL.

/* Substitui‡Æo Tributaria Antecipada */
DEF VAR h-boad107na                   AS HANDLE   NO-UNDO.
DEF VAR c-cod-cta-icms-antecip AS CHAR     NO-UNDO.
DEFINE VARIABLE c-char-2 AS CHARACTER   NO-UNDO.

/*--- Fat antecip / Ent fut no recebimento ---*/
{cdp/cd9700.i} /* definicao variaveis para cd9700.i1 */

/* Defini‡Æo/atribui‡Æo da vari ve l-mult-natur-receb -> Usa multiplas naturezas no recebimento */
{cdp/cd9701.i}

/*engine de regras*/
DEFINE TEMP-TABLE tt-variavel NO-UNDO
    FIELD cod-var-oper   AS CHARACTER FORMAT "x(16)"
    FIELD valor-variavel AS CHARACTER FORMAT "x(60)".

DEFINE TEMP-TABLE tt-retorno NO-UNDO
    FIELD valor-retorno AS CHARACTER FORMAT "x(60)"
    FIELD campo-retorno AS CHARACTER FORMAT "x(60)"
    FIELD perc-rateio   AS DECIMAL FORMAT ">>9,99".

DEFINE VARIABLE oTipoOperacaoUtil   AS rep.utils.TipoOperacaoUtil NO-UNDO.

DEFINE TEMP-TABLE RowErrorsAux NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

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
         HEIGHT             = 3.99
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

    {method/svc/autentic/autentic.i 
             &vUserCountryTax="i-pais-impto-usuario"
             &vUserName="c-seg-usuario"}

    for first param-estoq 
       fields ( estabel-pad  estab-uni   
                mensal-ate   tp-fech 
                rec-fisico             ) no-lock:
    end.   

   for first param-global
       fields ( empresa-prin  
                modulo-bh
                modulo-ft     modulo-of  
                modulo-07     modulo-cp
                modulo-mi     modulo-pd 
                modulo-ex ) no-lock:
   end.

    ASSIGN c-cod-estabel-usuar = param-estoq.estabel-pad.

    ASSIGN l-spp-NT2024002 = CAN-FIND(FIRST funcao NO-LOCK
                                      WHERE funcao.cd-funcao = "spp-NT2024002" AND funcao.ativo).

    /**** Fun‡Æo Super/Minas  *****/
    &IF DEFINED(Bf_dis_usuario_estab) &THEN
        IF CAN-FIND(funcao WHERE funcao.cd-funcao = "Fn-estab-usuario"
                             AND funcao.ativo     = YES) THEN DO:
           RUN cdp/cd8702.p (INPUT c-seg-usuario,
                            INPUT-OUTPUT c-cod-estabel-usuar).
        END.
    &ENDIF
    /********************************************************************************** 
    ** define procedure externa para execu‡Æo do programa de visualiza‡Æo do relatorio
    ** necess rio para a include  i-rptrm.i
    **********************************************************************************/
    PROCEDURE WinExec  EXTERNAL  "kernel32.dll":
      DEF INPUT PARAM prg_name      AS CHARACTER.
      DEF INPUT PARAM prg_style     AS SHORT.
    END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recebeNaturezaComplementar DBOProgram 
PROCEDURE recebeNaturezaComplementar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: /*** Corre‡Æo FO 888.358 (Liziane) ****/      
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pNatOperComp AS CHARACTER  NO-UNDO.

    assign c-nat-oper-comp = pNatOperComp.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
{inbo/boin090.m07} /* PROCEDURE afterCreateRecord : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
{inbo/boin090.m08} /* PROCEDURE afterDeleteRecord : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterNewRecord DBOProgram 
PROCEDURE afterNewRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
        Seta Defaults que independem da nota fiscal
------------------------------------------------------------------------------*/
        

      assign RowObject.dt-emissao  = today 
             RowObject.dt-trans    = today
             RowObject.cod-estabel = c-cod-estabel-usuar
             RowObject.esp-docto   = 21
             RowObject.cod-observa = 1.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignValueMercad DBOProgram 
PROCEDURE assignValueMercad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piValorMercad like docum-est.valor-mercad no-undo.
    

    for first b-docum-est
        fields ( cod-emitente  serie-docto
                 nro-docto     nat-operacao
                 valor-mercad )
        where b-docum-est.cod-emitente = RowObject.cod-emitente                 
          and b-docum-est.serie-docto  = RowObject.serie-docto
          and b-docum-est.nro-docto    = RowObject.nro-docto
          and b-docum-est.nat-operacao = RowObject.nat-operacao exclusive-lock.
    end.
    

    if  avail b-docum-est then
        assign b-docum-est.valor-mercad = piValorMercad.
        
    release b-docum-est.
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignValuePedagio DBOProgram 
PROCEDURE assignValuePedagio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piValorPedagio like docum-est.valor-mercad no-undo.
    

    for first b-docum-est
        fields ( cod-emitente  serie-docto
                 nro-docto     nat-operacao
                 valor-mercad  char-2)
        where b-docum-est.cod-emitente = RowObject.cod-emitente                 
          and b-docum-est.serie-docto  = RowObject.serie-docto
          and b-docum-est.nro-docto    = RowObject.nro-docto
          and b-docum-est.nat-operacao = RowObject.nat-operacao exclusive-lock.
    end.
    

    if  avail b-docum-est then
        assign overlay(b-docum-est.char-2,153,13) = string(piValorPedagio)
               b-docum-est.despesa-nota = b-docum-est.valor-frete 
                                        + b-docum-est.valor-seguro 
                                        + b-docum-est.valor-embal 
                                        + b-docum-est.valor-outras 
                                        + piValorPedagio. /*adiciona o ped gio nas despesas da nota*/
                                                                
    release b-docum-est.
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaDocumento DBOProgram 
{inbo/boin090.m09} /* PROCEDURE atualizaDocumento : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  param-global.modulo-ex AND CONNECTED("mgcex") THEN DO:

        IF NOT AVAIL estabelec OR
                     estabelec.cod-estabel <> RowObject.cod-estabel THEN
            RUN findEstabelec (INPUT RowObject.cod-estabel).
        
        IF NOT AVAIL emitente OR
                     emitente.cod-emitente <> RowObject.cod-emitente THEN
            RUN findEmitente (INPUT RowObject.cod-emitente).

        IF  AVAIL emitente  AND
            AVAIL estabelec AND 
            emitente.pais = estabelec.pais THEN DO:
            run findNaturOper ( input RowObject.nat-operacao ).
            IF  RETURN-VALUE = "OK":U THEN
                ASSIGN RowObject.log-memorando = natur-oper.log-memorando.
        END.
    END.

    IF RowObject.cod-tipo-ente-gov = 0 THEN DO:
        RUN setaEnteGov (INPUT RowObject.cod-estabel,
                         INPUT RowObject.cod-emitente,
                         INPUT RowObject.nat-operacao,
                         INPUT TRUE,
                         INPUT-OUTPUT RowObject.cod-tipo-ente-gov).
    END.
    
    assign RowObject.tipo-docto  = 1
           RowObject.pais-origem = "RE1001":U
           RowObject.sit-atual   = 2
           RowObject.ind-sit-wms-ext = 0. /*Digitada*/

    /* 
    **Tratamento para NAO sobrescrever valor enviado de despesa
    ** pelo modulo de importacao (visao DI). 
    ** Sobscrever o valor pode gerar problema de arredondamento
    */
    IF  param-global.modulo-07 
    AND CONNECTED("mgcex") 
    AND RowObject.origem = "I":U
    AND RowObject.despesa-nota <> 0         
    AND RowObject.declaracao-import <> ""     
    AND SUBSTRING(RowObject.char-1,1,20) <> "" THEN DO:

        IF NOT VALID-HANDLE(h-bocx383) THEN
            RUN cxbo/bocx383.p PERSISTENT SET h-bocx383.

        RUN openQueryStatic     IN h-bocx383 (INPUT "Main":U).
        RUN goToKeyByDiSiscomex IN h-bocx383 (INPUT RowObject.declaracao-import).

        /*
        ** Caso nao ache a DI calcula a despesa.
        ** Achando o registro (return "OK"), manter o valor vindo do importacao,
        ** nao realizando nenhum calculo nesse ponto.
        */
        IF RETURN-VALUE = "NOK":U THEN DO:
            run calculateDespesaNota (input RowObject.valor-frete,
                                      input RowObject.valor-seguro,
                                      input RowObject.valor-embal,
                                      input RowObject.valor-outras,
                                      input SUBSTR(RowObject.char-2,153,13),
                                      output RowObject.despesa-nota ).
        END.

    END.
    ELSE DO:
        run calculateDespesaNota ( input RowObject.valor-frete,
                                   input RowObject.valor-seguro,
                                   input RowObject.valor-embal,
                                   input RowObject.valor-outras,
                                   input SUBSTR(RowObject.char-2,153,13),
                                   output RowObject.despesa-nota ).
    END.
                             

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
{inbo/boin090.m10} /* PROCEDURE beforeDeleteRecord : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroy DBOProgram 
PROCEDURE beforeDestroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  valid-handle (h_boin060) then do:
        delete procedure h_boin060.
        assign h_boin060 = ?.
    end.

    if  valid-handle (h_boin176) then do:
        RUN destroy IN h_boin176.
        delete procedure h_boin176 NO-ERROR.
        assign h_boin176 = ?.
    end.

    if  valid-handle (h_bodi317im2bra) then do:
        delete procedure h_bodi317im2bra.
        assign h_bodi317im2bra = ?.
    end.    

    if  valid-handle (h-bosc014) then do:
        delete procedure h-bosc014.
        assign h-bosc014 = ?.
    end.

    if  valid-handle (h-bosc019) then do:
        delete procedure h-bosc019.
        assign h-bosc019 = ?.
    end.

    if  valid-handle (h-bosc019) then do:
        delete procedure h-bosc019.
        assign h-bosc019 = ?.
    end.

    IF  CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-conv-nfe-entrada":U AND funcao.ativo NO-LOCK) THEN DO:
        IF  VALID-HANDLE(h-boin847)        AND
            h-boin847:TYPE = "PROCEDURE":U AND
            h-boin847:FILE-NAME = "inbo/boin847.p":U THEN DO:
            DELETE PROCEDURE h-boin847.
            ASSIGN h-boin847 = ?.
        END.
    END.

    if valid-handle(h-bocx383) then do:
        delete procedure h-bocx383.
        assign h-bocx383 = ?.
    end.

    IF VALID-HANDLE(h-boin01016) THEN DO:
       DELETE PROCEDURE h-boin01016.
       ASSIGN h-boin01016 = ?.
    END.


    return "OK":U.

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
    /********Contrato Leasing*******/
    IF  AVAIL param-re
    AND SUBSTRING(param-re.char-1,27,1) = 'S'
    AND c-arrendador       <> ""
    AND c-contrato-leasing <> "" then 
        run CreatettExtDocumEst(INPUT "contrato-leasing":U).
    /*******************************/

    IF  l-spp-NT2024002 THEN
        RUN CreatettExtDocumEst(INPUT "fatogeradorCBS-IBS":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
    IF NOT RowObject.rec-fisico AND
       (RowObject.ind-sit-wms-ext  <> 0  AND /*Digitada*/
        RowObject.ind-sit-wms-ext  <> 1  AND /*NÆo Integra*/
        RowObject.ind-sit-wms-ext  <> 5  AND /*Conferencia OK*/
        RowObject.ind-sit-wms-ext  <> 6) THEN DO: /*Inativo*/
        {method/svc/errors/inserr.i &ErrorNumber="57473"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
        return "NOK".
    END.

  run calculateDespesaNota ( input RowObject.valor-frete,
                             input RowObject.valor-seguro,
                             input RowObject.valor-embal,
                             input RowObject.valor-outras,
                             INPUT SUBSTR(RowObject.char-2,153,13),
                             output RowObject.despesa-nota ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculateDespesaNota DBOProgram 
PROCEDURE calculateDespesaNota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piValorFrete    like docum-est.valor-frete  no-undo.
    def input param piValorSeguro   like docum-est.valor-seguro no-undo.
    def input param piValorEmbal    like docum-est.valor-embal  no-undo.
    def input param piValorOutras   like docum-est.valor-outras no-undo.
    def input param piPedagio       like docum-est.valor-outras no-undo.
    def output param piDespesaNota  like docum-est.despesa-nota no-undo.

    assign piDespesaNota = piValorFrete 
                         + piValorSeguro
                         + piValorEmbal
                         + piValorOutras
                         + piPedagio.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculateICMSFonte DBOProgram 
{inbo/boin090.m11} /* PROCEDURE calculateICMSFonte : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculateNumberInvoice DBOProgram 
{inbo/boin090.m06} /* PROCEDURE calculateNumberInvoice : */

/*{inbo/boin090.m06} PROCEDURE getHandleBOImpto : */
/*{inbo/boin090.m06} PROCEDURE habilitaembarque : */
/*{inbo/boin090.m06} PROCEDURE validateEmbarque : */
/*{inbo/boin090.m06} PROCEDURE verificaModuloImp : */
/*{inbo/boin090.m06} PROCEDURE desabilitaBtCheckImp : */


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculateTotalNota DBOProgram 
{inbo/boin090.m12} /* PROCEDURE calculateTotalNota : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consistNotaDevolCli DBOProgram 
{inbo/boin090.m13} /* PROCEDURE consistNotaDevolCli : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consistNotaTerceiros DBOProgram 
{inbo/boin090.m14} /* PROCEDURE consistNotaTerceiros : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDoctoItemOfRecFisico DBOProgram 
{inbo/boin090.m15} /* PROCEDURE createDoctoItemOfRecFisico : */

/*{inbo/boin090.m15} PROCEDURE validateFieldsKey : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTbWtDocto DBOProgram 
{inbo/boin090.m16} /* PROCEDURE createTbWtDocto : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE defaultContaTransit DBOProgram 
{inbo/boin090.m17} /* PROCEDURE defaultContaTransit : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaEmitenteNFe DBOProgram 
{inbo/boin090.m26} /* PROCEDURE verificaEmitenteNFe : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE defineTypeNota DBOProgram 
PROCEDURE defineTypeNota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param piProgram  as integer no-undo.

    run findNaturOper ( RowObject.nat-operacao ).

    if  return-value = "NOK":U then 
        return "NOK":U.

    run setFlagsNota ( input RowObject.cod-observa,
                       input RowObject.nat-operacao ).
    if  return-value <> "OK":U then 
        RETURN "NOK":U.
        
    {cdp/cd9700.i1 natur-oper}

    assign piProgram = IF l-multa-juros THEN 6
                       ELSE
                       IF  l-remessa-fat-antecip AND NOT l-devolucao THEN
                           5
                       ELSE
                       if  l-retorno or l-ret-fat or l-reaj-preco then  /* Retorno Terceiros */
                           4          
                       else 
                       if  l-devolucao OR l-dev-transf then             /* Devolu‡Æo Cliente ou devolu‡Æo de transferˆncia*/
                           3
                       else 
                       if  natur-oper.nota-rateio then   /* Nota Rateio */
                           2
                       else 
                       if not l-transf then
                           1              
                       else 
                           0.                 
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE determinevaluevalid DBOProgram 
PROCEDURE determinevaluevalid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

If avail param-global 
     and param-global.modulo-07 
     and avail emitente 
          and (emitente.natureza = 3 or
               emitente.natureza = 4)
          and avail estabelec 
          and emitente.pais <> estabelec.pais then Return "OK":U.
else do:
    assign c-embarque = " ".
    {rep/re1001a.i51 "no"}
    {cdp/cd4300.i4  "no" RowObject.char-1}   
    Return "NOK":U.
end.  
  

return "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enablebtrecfisico DBOProgram 
{inbo/boin090.m01} /* PROCEDURE enablebtrecfisico : */

/*{inbo/boin090.m01} PROCEDURE enableButtons : */
/*{inbo/boin090.m01} PROCEDURE enableFields : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCGCEmitente DBOProgram 
{inbo/boin090.m03} /* PROCEDURE findCGCEmitente : */

/*{inbo/boin090.m03} PROCEDURE findContaContab : */
/*{inbo/boin090.m03} PROCEDURE findEmitente : */
/*{inbo/boin090.m03} PROCEDURE findEstabelec : */
/*{inbo/boin090.m03} PROCEDURE findNaturOper : */
/*{inbo/boin090.m03} PROCEDURE findUnidFeder : */
/*{inbo/boin090.m03} PROCEDURE findUnidFederEstab : */
/*{inbo/boin090.m03} PROCEDURE findUsuario : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
{inbo/boin090.m04} /* PROCEDURE getCharField : */

/*{inbo/boin090.m04} PROCEDURE getCodServico : */
/*{inbo/boin090.m04} PROCEDURE getDateField : */
/*{inbo/boin090.m04} PROCEDURE getDecField : */
/*{inbo/boin090.m04} PROCEDURE getDescriptionFields : */
/*{inbo/boin090.m04} PROCEDURE getEspDocto : */
/*{inbo/boin090.m04} PROCEDURE getFlagsNota : */
/*{inbo/boin090.m04} PROCEDURE getHandleBOItemDoc : */
/*{inbo/boin090.m04} PROCEDURE getIntField : */
/*{inbo/boin090.m04} PROCEDURE getKey : */
/*{inbo/boin090.m04} PROCEDURE getLogField : */
/*{inbo/boin090.m04} PROCEDURE getRawField : */
/*{inbo/boin090.m04} PROCEDURE getReabrePedido : */
/*{inbo/boin090.m04} PROCEDURE getTipoNotaDtTrans : */
/*{inbo/boin090.m04} PROCEDURE getUsuario : */
/*{inbo/boin090.m04} PROCEDURE getConsideraEnderecoNF : */
/*{inbo/boin090.m04} PROCEDURE consistEnderecoNF : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice documento
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE docum-est.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE docum-est.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE docum-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE docum-est.nat-operacao NO-UNDO.
		
    IF l-estab-security-active = YES THEN
        FIND FIRST bfdocum-est  
            WHERE bfdocum-est.serie-docto = pserie-docto  
              AND bfdocum-est.nro-docto = pnro-docto  
              AND bfdocum-est.cod-emitente = pcod-emitente  
              AND bfdocum-est.nat-operacao = pnat-operacao   
              AND CAN-FIND(FIRST {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = bfdocum-est.cod-estabel) NO-LOCK NO-ERROR.	
    ELSE
        FIND FIRST bfdocum-est  
             WHERE bfdocum-est.serie-docto = pserie-docto  
               AND  bfdocum-est.nro-docto = pnro-docto  
               AND  bfdocum-est.cod-emitente = pcod-emitente  
               AND  bfdocum-est.nat-operacao = pnat-operacao NO-LOCK NO-ERROR.	

   /* RUN openQueryDocto. erro RE0708i */

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdocum-est THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrÆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdocum-est)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey2 DBOProgram 
PROCEDURE goToKey2 :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice documento (ce-atual = no)
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE docum-est.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE docum-est.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE docum-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE docum-est.nat-operacao NO-UNDO.
	
	IF l-estab-security-active = YES THEN 
	    FIND FIRST bfdocum-est 
		     WHERE bfdocum-est.serie-docto = pserie-docto  
			  AND  bfdocum-est.nro-docto = pnro-docto  
			  AND  bfdocum-est.cod-emitente = pcod-emitente  
			  AND  bfdocum-est.nat-operacao = pnat-operacao 
			  AND  bfdocum-est.ce-atual = no  
			  AND  CAN-FIND(FIRST {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = bfdocum-est.cod-estabel) NO-LOCK NO-ERROR.	
	ELSE
		FIND FIRST bfdocum-est  
			WHERE  bfdocum-est.serie-docto = pserie-docto  
			  AND  bfdocum-est.nro-docto = pnro-docto  
			  AND  bfdocum-est.cod-emitente = pcod-emitente  
			  AND  bfdocum-est.nat-operacao = pnat-operacao 
			  AND  bfdocum-est.ce-atual = no NO-LOCK NO-ERROR.

 
    /* RUN openQueryDocto. erro RE0708i */
	
    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdocum-est THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrÆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdocum-est)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey2 DBOProgram 
PROCEDURE goToKey3 :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice documento (ce-atual = no)
  Parameters:  Recebe valor do campo Chave de Acesso NFE
              
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pchave-acesso-nfe  LIKE docum-est.cod-chave-aces-nf-eletro  NO-UNDO.
	
	IF l-estab-security-active = YES THEN 
	    FIND FIRST bfdocum-est 
		     WHERE bfdocum-est.cod-chave-aces-nf-eletro = pchave-acesso-nfe
			  AND  bfdocum-est.ce-atual = no  
			  AND  CAN-FIND(FIRST {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = bfdocum-est.cod-estabel) NO-LOCK NO-ERROR.	
	ELSE
		FIND FIRST bfdocum-est  
			WHERE  bfdocum-est.cod-chave-aces-nf-eletro = pchave-acesso-nfe
			  AND  bfdocum-est.ce-atual = no NO-LOCK NO-ERROR.
 
    /* RUN openQueryDocto. erro RE0708i */
	
    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdocum-est THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrÆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdocum-est)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQuerybyDataTransacao DBOProgram 
{inbo/boin090.m05} /* PROCEDURE OpenQuerybyDataTransacao : */

/*{inbo/boin090.m05} PROCEDURE OpenQuerybydocto : */
/*{inbo/boin090.m05} PROCEDURE OpenQuerybydttrans : */
/*{inbo/boin090.m05} PROCEDURE OpenQuerybyemitente : */
/*{inbo/boin090.m05} PROCEDURE openQueryDocto : */
/*{inbo/boin090.m05} PROCEDURE openQueryMain : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaCCAtualiza DBOProgram 
{inbo/boin090.m02} /* PROCEDURE retornaCCAtualiza : */

/*{inbo/boin090.m02} PROCEDURE retornaDocumentoImportado : */
/*{inbo/boin090.m02} PROCEDURE returnFormatParamGlobal : */
/*{inbo/boin090.m02} PROCEDURE returnPessoaEmitente : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintbyDataTransacao DBOProgram 
PROCEDURE setConstraintbyDataTransacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  def input parameter p-docto-ini like docum-est.nro-docto    no-undo. 
  def input parameter p-docto-fim like docum-est.nro-docto    no-undo.
  def input parameter p-emite-ini like docum-est.cod-emitente no-undo. 
  def input parameter p-emite-fim like docum-est.cod-emitente no-undo.
  def input parameter p-data-ini  like docum-est.dt-trans     no-undo. 
  def input parameter p-data-fim  like docum-est.dt-trans     no-undo.
  

    assign c-docto-ini = p-docto-ini
           c-docto-fim = p-docto-fim
           i-emite-ini = p-emite-ini
           i-emite-fim = p-emite-fim
           da-data-ini = p-data-ini
           da-data-fim = p-data-fim.
    

  RETURN "OK":U.
      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintbydocto DBOProgram 
PROCEDURE setConstraintbydocto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  def input parameter pcDoctoIni like docum-est.nro-docto    no-undo. 
  def input parameter pcDoctoFim like docum-est.nro-docto    no-undo.
  def input parameter piEmiteIni like docum-est.cod-emitente no-undo. 
  def input parameter piEmiteFim like docum-est.cod-emitente no-undo.
  def input parameter pdaDataIni like docum-est.dt-trans     no-undo. 
  def input parameter pdaDataFim like docum-est.dt-trans     no-undo.
  def input parameter pcEstabIni like docum-est.cod-estabel  no-undo. 
  def input parameter pcEstabFim like docum-est.cod-estabel  no-undo.
  def input parameter pcSerieIni like docum-est.serie-docto  no-undo. 
  def input parameter pcSerieFim like docum-est.serie-docto  no-undo.
  

    assign cDoctoIni = pcDoctoIni
           cDoctoFim = pcDoctoFim
           iEmiteIni = piEmiteIni
           iEmiteFim = piEmiteFim
           daDataIni = pdaDataIni
           daDataFim = pdaDataFim
           cEstabIni = pcEstabIni
           cEstabFim = pcEstabFim
           cSerieIni = pcSerieIni
           cSerieFim = pcSerieFim.
    

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintChave DBOProgram 
PROCEDURE setConstraintChave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  def input parameter p-serie       LIKE docum-est.serie-docto  no-undo.
  def input parameter p-docto       like docum-est.nro-docto    no-undo. 
  def input parameter p-emitente    like docum-est.cod-emitente no-undo. 
  def input parameter p-natOperacao like docum-est.nat-operacao no-undo.
    
  ASSIGN cSerie       = p-serie
         cDocto       = p-docto   
         cEmitente    = p-emitente
         cNatOperacao = p-natOperacao.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintChave DBOProgram 
PROCEDURE verificaSitNota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF INPUT  PARAM pserie-docto  LIKE  docum-est.serie-docto  NO-UNDO.
   DEF INPUT  PARAM pnro-docto    LIKE  docum-est.nro-docto    NO-UNDO.
   DEF INPUT  PARAM pcod-emitente LIKE  docum-est.cod-emitente NO-UNDO.
   DEF INPUT  PARAM pnat-oper     LIKE  docum-est.nat-operacao NO-UNDO.
   DEF OUTPUT PARAM pce-atual     LIKE docum-est.ce-atual no-undo.
    
   FIND FIRST b-docum-est NO-LOCK
       WHERE b-docum-est.serie-docto   = pserie-docto  
       AND   b-docum-est.nro-docto     = pnro-docto    
       AND   b-docum-est.cod-emitente  = pcod-emitente 
       AND   b-docum-est.nat-operacao  = pnat-oper         NO-ERROR.
  IF AVAIL b-docum-est THEN
     ASSIGN pce-atual = b-docum-est.ce-atual.
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsNota DBOProgram 
{inbo/boin090.m18} /* PROCEDURE setDefaultsNota : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFlagsNota DBOProgram 
PROCEDURE setFlagsNota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   def input parameter p-cod-observa  like docum-est.cod-observa  no-undo.
   def input parameter p-nat-operacao like docum-est.nat-operacao no-undo.
   

   if  p-nat-operacao <> "":U
   and p-nat-operacao <> ?  then 
       run findNaturOper ( p-nat-operacao ).
   

   if  return-value <> "OK":U
   or  not avail natur-oper then 
       RETURN "NOK":U.
       

   assign l-industria  = p-cod-observa = 1
          l-comercio   = p-cod-observa = 2
          l-devolucao  = p-cod-observa = 3
          l-servicos   = p-cod-observa = 4
          l-transf     = natur-oper.transf
          l-ent-cons   = natur-oper.terceiros           and
                         ( natur-oper.tp-oper-terc = 1  or 
                           natur-oper.tp-oper-terc = 3)
          l-retorno    = natur-oper.terceiros           and
                         ( natur-oper.tp-oper-terc = 2  or 
                           natur-oper.tp-oper-terc = 5  or 
                           natur-oper.tp-oper-terc = 9  or 
                           natur-oper.tp-oper-terc = 11)
          l-ret-fat    = natur-oper.terceiros           and
                         natur-oper.tp-oper-terc = 4
          l-reaj-preco = natur-oper.terceiros           and
                         natur-oper.tp-oper-terc = 6
          l-dev-transf = natur-oper.tipo-compra = 8.
          
         RUN isMultaJuros ( INPUT natur-oper.nat-operacao,
                            OUTPUT l-multa-juros).
         
  
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE isMultaJuros DBOProgram 
PROCEDURE isMultaJuros :
   DEF INPUT PARAMETER p-nat-operacao LIKE docum-est.nat-operacao NO-UNDO.
   DEF OUTPUT PARAM pMultaJuros AS LOGICAL no-undo.
   
   ASSIGN pMultaJuros = NO.
   
   if  p-nat-operacao <> "":U
   and p-nat-operacao <> ?  then 
       run findNaturOper ( p-nat-operacao ).
   

   if  return-value <> "OK":U
   or  not avail natur-oper then 
       RETURN "NOK":U.
   
   ASSIGN pMultaJuros = (    natur-oper.tipo-compra = 9 //NF cr‚dito d‚bito  
                          AND (   (RowObject.cod-finalidade = '5' AND RowObject.cod-tipo-nf-cred-deb    = '1') /*5 = NF cr‚dito e 1 = Multa e juros*/
                               OR (RowObject.cod-finalidade = '6' AND RowObject.cod-tipo-nf-cred-deb    = '4'))). /*6 = NF d‚bito e 4 = Multa e juros*/

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setHandleBOImpto DBOProgram 
PROCEDURE setHandleBOImpto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  not valid-handle(h_bodi317im2bra) then 
        run dibo/bodi317im2bra.p persistent set h_bodi317im2bra.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTotaisNota DBOProgram 
{inbo/boin090.m19} /* PROCEDURE setTotaisNota : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setUsuario DBOProgram 
PROCEDURE setUsuario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    for first b-docum-est
        fields ( usuario )
        where b-docum-est.cod-emitente = RowObject.cod-emitente
          and b-docum-est.serie-docto  = RowObject.serie-docto
          and b-docum-est.nro-docto    = RowObject.nro-docto
          and b-docum-est.nat-operacao = RowObject.nat-operacao exclusive-lock: 
   end.

    if  avail b-docum-est then do:
        assign b-docum-est.usuario = c-seg-usuario.
        release b-docum-est.
    end.

    return "OK":U.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateGerouNota DBOProgram 
PROCEDURE ValidaGeraNotaCredito :
/*------------------------------------------------------------------------------
  Purpose:      Valida‡Æo para RE0996.w
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    FOR FIRST natur-oper NO-LOCK
        WHERE natur-oper.nat-operacao = rowObject.nat-operacao:

        IF  natur-oper.tipo <> 2 OR
            rowObject.cod-observa = 3 THEN
            RETURN "5532":U.
    END.

    IF  NOT natur-oper.log-gera-ncredito THEN
        RETURN "34147":U.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateServiceItem DBOProgram 
PROCEDURE updateServiceItem :
/*------------------------------------------------------------------------------
  Purpose:  Cria Item de servi‡o na tabela docum-est
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pcod-item-serv AS CHAR NO-UNDO.

    for first b-docum-est
        where b-docum-est.cod-emitente = RowObject.cod-emitente                 
          and b-docum-est.serie-docto  = RowObject.serie-docto
          and b-docum-est.nro-docto    = RowObject.nro-docto
          and b-docum-est.nat-operacao = RowObject.nat-operacao exclusive-lock.
    end.
    
    if  avail b-docum-est THEN DO:
        &IF "{&bf_dis_versao_ems}" >= "2.09" &THEN
            ASSIGN b-docum-est.cod-item-serv = pcod-item-serv.
        &ELSE
            OVERLAY(b-docum-est.char-1,176,16) = pcod-item-serv.
        &ENDIF
    END.
        
    release b-docum-est.
    
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueServiceItem DBOProgram 
PROCEDURE valueServiceItem :
/*------------------------------------------------------------------------------
  Purpose: Se c¢digo de observa‡Æo do documento for igual a "Servi‡os", 
           entÆo item de servi‡o deve ser diferente de zero.
           Verifica se item ‚ debito direto.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pcod-item-serv AS CHAR NO-UNDO.
    DEF INPUT PARAM p-aux          AS INT  NO-UNDO.

    /*Verifica se item ‚ debito direto*/
    IF p-aux = 1 THEN DO:

        FIND FIRST item NO-LOCK
            WHERE ITEM.it-codigo  = pcod-item-serv
            AND   item.tipo-contr = 4 NO-ERROR.

        IF AVAIL ITEM THEN
            RETURN "OK".
        ELSE RETURN "NOK". 
        
    END.
    /*Verifica se observa‡Æo esta igual "Servi‡o"*/
    ELSE DO:
        
        if rowObject.cod-observa = 4
        AND pcod-item-serv = "" THEN DO:
            RETURN "NOK".
        END.
        ELSE RETURN "OK".

    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnValueItserv DBOProgram 
PROCEDURE returnValueItserv :
/*------------------------------------------------------------------------------
  Purpose: Retorna c¢digo do item de servi‡o
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM pcod-item-serv AS CHAR NO-UNDO.

    ASSIGN pcod-item-serv = "".

    &IF "{&bf_dis_versao_ems}" >= "2.09" &THEN
        ASSIGN pcod-item-serv = rowObject.cod-item-serv.
    &ELSE
        ASSIGN pcod-item-serv = SUBSTRING(rowObject.char-1,176,16).
    &ENDIF
    
    RETURN "OK".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnValueColEscrituraPedagio DBOProgram 
PROCEDURE returnValueColEscrituraPedagio :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM pColEscritPed AS CHAR NO-UNDO.

    ASSIGN pColEscritPed = ""
           pColEscritPed = SUBSTRING(rowObject.char-2,215,1).
    
    RETURN "OK".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignValueColEscrituraPedagio DBOProgram 
PROCEDURE assignValueColEscrituraPedagio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
    def input param piColEscritPed AS INTEGER NO-UNDO.

    for first b-docum-est
        fields (char-2)
        where b-docum-est.cod-emitente = RowObject.cod-emitente                 
          and b-docum-est.serie-docto  = RowObject.serie-docto
          and b-docum-est.nro-docto    = RowObject.nro-docto
          and b-docum-est.nat-operacao = RowObject.nat-operacao exclusive-lock.
    end.

    if  avail b-docum-est then
        assign overlay(b-docum-est.char-2,215,1) = string(piColEscritPed).
                                                                
    release b-docum-est.
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaObservDiferimICMS DBOProgram 
PROCEDURE atualizaObservDiferimICMS :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza a Observação do documento com o valor total de diferimento
  dos itens.
  Parameters:  recebe:  rowid do documento
                        valor total de diferimento dos itens
                   
               
               Retorna: observação       
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pr-rowid-docum-est  AS ROWID.
    DEF INPUT  PARAM pd-tot-icms-diferim AS DECIMAL. 
    DEF OUTPUT PARAM pc-mensagem-diferim AS CHAR FORMAT "X(200)".

    DEFINE VARIABLE de-tot-icms AS DECIMAL NO-UNDO.

    FIND FIRST b-docum-est 
         WHERE ROWID(b-docum-est) = pr-rowid-docum-est NO-LOCK NO-ERROR.
   
    IF  AVAIL b-docum-est THEN DO:

        FIND FIRST estabelec 
             WHERE estabelec.cod-estabel =  b-docum-est.cod-estabel
             NO-LOCK NO-ERROR.

        ASSIGN de-tot-icms = 0.

        FOR EACH item-doc-est
            WHERE item-doc-est.serie-docto  = b-docum-est.serie-docto
              AND item-doc-est.nro-docto    = b-docum-est.nro-docto
              AND item-doc-est.cod-emitente = b-docum-est.cod-emitente
              AND item-doc-est.nat-operacao = b-docum-est.nat-operacao NO-LOCK:

            ASSIGN de-tot-icms = de-tot-icms + item-doc-est.valor-icm[1].

            IF NOT AVAIL diferim-parcial-icms THEN DO:
                FOR FIRST diferim-parcial-icms NO-LOCK
                    WHERE diferim-parcial-icms.cod-estado = estabelec.estado
                    AND   diferim-parcial-icms.cod-item   = item-doc-est.it-codigo:
                        FIND FIRST mensagem
                             WHERE mensagem.cod-mensagem = diferim-parcial-icms.num-mensagem NO-LOCK NO-ERROR.
                END.
            END.
        END.
        IF  AVAIL mensagem THEN DO:
            ASSIGN pc-mensagem-diferim = TRIM(REPLACE(mensagem.texto-mensag,"##26",(STRING(diferim-parcial-icms.num-inciso) + "#")))
                   pc-mensagem-diferim = TRIM(REPLACE(pc-mensagem-diferim,"##27",TRIM(STRING(pd-tot-icms-diferim,">>,>>>,>>>,>>9.99"))))
                   pc-mensagem-diferim = REPLACE(REPLACE(REPLACE(REPLACE(pc-mensagem-diferim,"1#","I"),"2#","II"),"3#","III"),"4#","IV")
                   pc-mensagem-diferim = TRIM(REPLACE(pc-mensagem-diferim,"##28",TRIM(STRING(de-tot-icms + pd-tot-icms-diferim,">>,>>>,>>>,>>9.99"))))
                   pc-mensagem-diferim = TRIM(REPLACE(pc-mensagem-diferim,"#","")).
        END. 
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnUseVisionDI DBOProgram 
PROCEDURE returnUseVisionDI :
/*------------------------------------------------------------------------------
  Purpose: Return TRUE if uses the vision DI else return FALSE
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM i-cod-emitente  AS INT  NO-UNDO.
    DEF INPUT  PARAM c-serie-docto   AS CHAR NO-UNDO.
    DEF INPUT  PARAM c-nat-operacao  AS CHAR NO-UNDO.
    DEF INPUT  PARAM c-nro-docto     AS CHAR NO-UNDO.
    DEF OUTPUT PARAM l-use-vision-di AS LOG  NO-UNDO.
    
    for first b-docum-est
        fields ( declaracao-import )
        where b-docum-est.cod-emitente = i-cod-emitente
          and b-docum-est.serie-docto  = c-serie-docto
          and b-docum-est.nro-docto    = c-nro-docto
          and b-docum-est.nat-operacao = c-nat-operacao NO-LOCK: 
    end.
    
    if  avail b-docum-est then do:
        IF b-docum-est.declaracao-import <> "" THEN
            assign l-use-vision-di = YES.
    end.
    
    RETURN "OK".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trataNotaFiscalEletronica DBOProgram 
{inbo/boin090.m27} /* PROCEDURE trataNotaFiscalEletronica : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateContaTransit DBOProgram 
{inbo/boin090.m20} /* PROCEDURE validateContaTransit : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreateRecord DBOProgram 
{inbo/boin090.m21} /* PROCEDURE validateCreateRecord : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
{inbo/boin090.m22} /* PROCEDURE validateRecord : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateTransferencia DBOProgram 
{inbo/boin090.m23} /* PROCEDURE validateTransferencia : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateTypeMovto DBOProgram 
{inbo/boin090.m24} /* PROCEDURE validateTypeMovto : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateValues DBOProgram 
{inbo/boin090.m25} /* PROCEDURE validateValues : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-criaDocumentoFiscal DBOProgram 
{inbo/boin090.m28} /* PROCEDURE pi-criaDocumentoFiscal : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE defineFatAntecipEntFutura DBOProgram 
{inbo/boin090.m29} /* PROCEDURE defineFatAntecipEntFutura : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFatAntecipEntFutura DBOProgram 
{inbo/boin090.m30} /* PROCEDURE getFatAntecipEntFutura : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescConta DBOProgram 
{inbo/boin090.m31} /* PROCEDURE getDescConta : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFormatoConta DBOProgram 
{inbo/boin090.m32} /* PROCEDURE getFormatoConta : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getZoomConta DBOProgram 
{inbo/boin090.m33} /* PROCEDURE getZoomConta : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getZoomCcusto DBOProgram 
{inbo/boin090.m34} /* PROCEDURE getZoomCcusto : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValidaCcusto DBOProgram 
{inbo/boin090.m35} /* PROCEDURE getValidaCcusto : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFormatoCCusto DBOProgram 
{inbo/boin090.m36} /* PROCEDURE getFormatoCCusto : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consistNotaFatAntecip DBOProgram 
{inbo/boin090.m37} /* PROCEDURE consistNotaFatAntecip : */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaChaveNfeEletronica DBOProgram 
{inbo/boin090.m38} /* PROCEDURE atualizaChaveNfeEletronica: */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME  

/*REINF*/
{inbo/boin090.m39}

{inbo/boin090.m40} /* piSetaDadosLeasing, SetDadosFatoGerador, CreatettExtDocumEst, DeletettExtDocumEst */

{inbo/boin090.m41} /*setCodEmitente , setNatOperacao, setSerieDocto, setNroDocto, setDtEmissao, setChaveSemDigito
 getChaveAcessoCompleta,setFieldsByRowidDocFisico, setChaveAcessoCompleta, validaPosicao35Chave, retornaChaveAcesso, validaDigito */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE determinaTipoDFe DBOProgram 
{inbo/boin090.m42} /* PROCEDURE determinaTipoDFe: */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME  
 
{inbo/boin090.m43} /* copiaEnteOperGovNForig, setaEnteGov, buscaNatOperNfFatura */
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE utilizaImpostosMonitor DBOProgram 
{rep/imp/utilizaImpostosMonitor.i} 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE guardaRowidNext DBOProgram 
PROCEDURE guardaRowidNext :

    ASSIGN rw-prox-docum-est = ?.

    GET NEXT {&QueryName} NO-LOCK.

    if avail docum-est then do:
        assign rw-prox-docum-est = rowid(docum-est).

        if RowObject.r-rowid <> rowid(docum-est) then /* quando achar um proximo ele nao devera ter o mesmo rowid do anterior, pode ser que ja esteja no ultimo */
            GET PREV {&QueryName} NO-LOCK.
    end.
    else
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE desabilitaBtCheckXML DBOProgram 
PROCEDURE desabilitaBtCheckXML:
    DEFINE INPUT PARAMETER pserie-docto    LIKE docum-est.serie-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto      LIKE docum-est.nro-docto      NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente   LIKE docum-est.cod-emitente   NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao   LIKE docum-est.nat-operacao   NO-UNDO.
    DEFINE INPUT PARAMETER pseq-item       LIKE item-doc-imp-nfe.seq-item NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-desabilita  AS LOGICAL                    NO-UNDO.
    
    DEFINE VARIABLE l-utilizaImpostoMonitor AS LOGICAL  NO-UNDO.
    ASSIGN l-utilizaImpostoMonitor = NO.
    
    RUN utilizaImpostosMonitorRecFiscal (INPUT  pserie-docto,
                                         INPUT  pnro-docto,
                                         INPUT  pcod-emitente,
                                         INPUT  pnat-operacao,
                                         INPUT  pseq-item,
                                         OUTPUT l-utilizaImpostoMonitor).
    
    ASSIGN pl-desabilita = l-utilizaImpostoMonitor.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionNextRecord DBOProgram 
PROCEDURE repositionNextRecord:

    if rw-prox-docum-est = ? then
        RUN getNext.
    else do:
        /* Foi necessario incluir estes getNext porque nas notas de ret. benef. com material agregado
           os proximos registro de agregado tambem eh atualizado na mesma execucao do re1005. */
        if can-find(first docum-est 
                    where rowid(docum-est) = rw-prox-docum-est
                      and docum-est.ce-atual) then do:
            RUN vaiParaProximoSeAtualizado.
        end.
        else do:
            RUN repositionRecord (INPUT rw-prox-docum-est).

            if return-value = "NOK":U then
                RUN getNext.
        end.
    end.

    RETURN RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE vaiParaProximoSeAtualizado DBOProgram 
PROCEDURE vaiParaProximoSeAtualizado:

    if can-find(first docum-est 
                where rowid(docum-est) = rw-prox-docum-est
                  and docum-est.ce-atual) then do:
        RUN getNext.
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getRowid (OUTPUT rw-prox-docum-est).
            RUN vaiParaProximoSeAtualizado.
        END.
    end.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

