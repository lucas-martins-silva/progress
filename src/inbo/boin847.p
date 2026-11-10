BLOCK-LEVEL ON ERROR UNDO, THROW.

USING com.totvs.framework.btb.metrics.*.

&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/****************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa. 
****************************************************************************/
{include/i-prgvrs.i BOIN847 2.00.00.231 } /*** "010031" 23/10/2026 12:53:16 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin847 MUT}
&ENDIF

/*:T----------------------------------------------------------------------
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
&GLOBAL-DEFINE DBOName BOIN847
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName doc-orig-nfe
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName}

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o [ Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cdp/cdcfgdis.i}       
{cdp/cdcfgmat.i}    
{include/i_prdvers.i}  
{inbo/boin847.i RowObject}
{inbo/boin090.i tt-docum-est}       
{inbo/boin176.i tt-item-doc-est}  
{inbo/boin176.i tt-item-doc-est-elegivel} 
{inbo/boin092.i tt-dupli-apagar}    
{inbo/boin567.i tt-dupli-imp}       
{inbo/boin366.i tt-rat-docum}   
{dibo/bodi515.i tt-nota-fisc-adc}   
{dibo/bodi516.i tt-item-nf-adc}
{inbo/boin367.i tt-rat-lote}
{inbo/boin010.i tt-rat-componente}   /* Temp-table tt-rat-componente */
{inbo/boin01109.i tt-doc-xml-compar}
{inbo/boin01109.i tt-doc-xml-compar-old}
{inbo/boin01109.i tt-doc-xml-compar-aux}
{inbo/boin01109.i tt-doc-xml-compar-add}
{inbo/boin01091.i tt-item-doc-est-tribut}

{utp/ut-glob.i}

{cdp/cd9590.i} /* Valida unidade de neg¢cio rec. fisico vers∆o 2.06 */

{rep/reapi321.i} /* Cria Temp-Tables da API - Recebimento F°sico*/

/* Definiá∆o/atribuiá∆o da vari†ve l-mult-natur-receb -> Usa multiplas naturezas no recebimento */
{cdp/cd9701.i}
{cdp/cd9700.i} /* definicao variaveis para cd9700.i1 */

DEF BUFFER b-medicao-contrat FOR medicao-contrat. //utilizada na pi-aloca-medicao 
/** N∆o elimine a linha abaixo, ˝ a chamada EPC **/
{include/i-epc200.i "boin847"}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

DEF TEMP-TABLE tt-digita-re0402 NO-UNDO
    field serie-docto  like docum-est.serie-docto
    field nro-docto    like docum-est.nro-docto
    field cod-emitente like docum-est.cod-emitente
    field nat-operacao like docum-est.nat-operacao.

DEFINE TEMP-TABLE tt-erro-contrato NO-UNDO
        FIELD i-sequen AS INTEGER
        FIELD cd-erro  AS INTEGER
        FIELD mensagem AS CHARACTER FORMAT "x(255)".


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}        FOR {&TableName}.
DEFINE BUFFER bfitem-doc-orig       FOR item-doc-orig-nfe.
DEFINE BUFFER bfmsg-ret-nfe         FOR msg-ret-nfe.
DEFINE buffer b-emit-estab          for emitente.
DEFINE BUFFER bf-emitente           FOR emitente.
DEFINE BUFFER bf-item-doc-orig-nfe  FOR item-doc-orig-nfe.

DEF TEMP-TABLE tt-manut-docto NO-UNDO
    FIELD mark             AS CHAR FORMAT "x(1)" INIT "*"
    FIELD rw-ordem-compra  AS ROWID
    FIELD data-entrega   LIKE prazo-compra.data-entrega
    FIELD it-codigo      LIKE ordem-compra.it-codigo
    FIELD descricao      LIKE item.desc-inter
    FIELD qtd-sald-forn  LIKE prazo-compra.qtd-sal-forn
    FIELD quantidade     LIKE prazo-compra.qtd-sal-forn
    FIELD preco-unit-for LIKE ordem-compra.pre-unit-for
    FIELD encerrada        AS LOGICAL FORMAT "Sim/N∆o"
    FIELD num-parcela      AS INTEGER
    FIELD ordem-compra   LIKE ordem-compra.numero-ordem
    FIELD num-pedido     LIKE ordem-compra.num-pedido
    FIELD de-preco-total LIKE item-doc-est.preco-total[0]
    FIELD preco-uni-orig    LIKE ordem-compra.pre-unit-for
    FIELD de-preco-tot-orig LIKE item-doc-est.preco-total[0]
    FIELD num-ord-inv    LIKE ordem-compra.num-ord-inv
    FIELD ord-producao   LIKE ordem-compra.ordem-servic
    FIELD nr-contrato    LIKE ordem-compra.nr-contrato
    FIELD descr-contr    LIKE contrato-for.des-contrat
    FIELD num-seq-item   LIKE ordem-compra.num-seq-item
    FIELD saldo          LIKE prazo-compra.qtd-sal-forn
    FIELD ct-codigo      LIKE ordem-compra.ct-codigo
    FIELD sc-codigo      LIKE ordem-compra.sc-codigo
    FIELD cod-unid-negoc   AS CHARACTER
    FIELD cod-refer        AS CHARACTER
    FIELD lote             AS CHARACTER
    FIELD dt-vali-lote   LIKE item-doc-est.dt-vali-lote
    FIELD un-fornec      LIKE item-fornec.unid-med-for
    FIELD seq-item-contr LIKE item-contrat.num-seq-item
    FIELD num-seq-med    LIKE medicao-contrat.num-seq-medicao
    FIELD num-seq-eve    LIKE medicao-contrat.num-seq-event
    FIELD vl-rec-medicao LIKE medicao-contrat.val-medicao
    FIELD vl-sdo-medicao LIKE medicao-contrat.val-medicao 
    FIELD val-medicao    LIKE medicao-contrat.val-medicao
    FIELD val-previsto   LIKE medicao-contrat.val-previsto
    FIELD class-fiscal   LIKE classif-fisc.class-fiscal
    FIELD cod-estab      LIKE ordem-compra.cod-estabel
    FIELD cod-depos      LIKE item-uni-estab.deposito-pad
    FIELD cod-localiz    LIKE item-uni-estab.cod-localiz
    FIELD sigla-moeda    LIKE moeda.sigla
    FIELD per-ppm          AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0
    FIELD r-rowid          AS ROWID
    FIELD i-linha          AS INTEGER.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD identif-segment AS CHAR
    FIELD cd-erro         AS INTEGER
    FIELD desc-erro       AS CHAR FORMAT "x(80)".

def temp-table tt-erro-rat no-undo
    field seq-erro  as int
    field cd-erro   as integer
    field desc-erro as char format "x(80)".

DEF TEMP-TABLE tt-natureza NO-UNDO
    FIELD nat-operacao   LIKE natur-oper.nat-operacao  /* Natureza de operaá∆o fiscal (itens) - nat-of */
    FIELD nat-oper-agrup LIKE natur-oper.nat-operacao  /* Natureza de operaá∆o agrupadora (documento) - nat-operacao */
    FIELD idi-tipo-oper LIKE item-doc-orig-nfe.int-2.  

DEF TEMP-TABLE tt-tipo-operacao NO-UNDO
    FIELD cod-cfop   LIKE cfop-natur.cod-cfop 
    FIELD tipo-operac AS INTEGER
    FIELD seq-item    AS INTEGER.
DEF TEMP-TABLE tt2-rat-ordem NO-UNDO
    LIKE rat-ordem
    FIELD r-rowid AS ROWID.
DEF TEMP-TABLE tt-rat-lote-medic-aux NO-UNDO
    LIKE rat-lote-medic-nfe
    FIELD qtd-saldo  LIKE rat-lote-medic-nfe.qtd-lote-fabrican
    INDEX seq-rat num-seq-rat ASC.

DEF TEMP-TABLE tt-rat-lote-aux NO-UNDO LIKE tt-rat-lote.

/* Temp-table que armazena tanto o agregado quanto o acabado. */
DEF TEMP-TABLE tt-movto-pend NO-UNDO
    LIKE movto-pend
    FIELD r-rowid AS ROWID.
               
/* Temp-table para gerar o agregado. */
DEF TEMP-TABLE tt-movto-pend-aux NO-UNDO
    LIKE tt-movto-pend.
               
DEFINE TEMP-TABLE tt-seq-saldo-terc NO-UNDO
    FIELD sequencia  AS INTEGER.
               
DEF TEMP-TABLE tt-doc-orig-nfe-aux NO-UNDO LIKE doc-orig-nfe
    FIELD r-rowid AS ROWID.

DEF TEMP-TABLE tt-doc-orig-nfe-agrup NO-UNDO LIKE doc-orig-nfe
    Field nat-oper      as char
    Field situacao      as INT
    FIELD desc-nat-oper AS CHAR
    Field r-rowid       as rowid.

DEF TEMP-TABLE tt-despesas-item NO-UNDO 
    FIELD seq-item  AS INTEGER
    FIELD nat-operacao AS CHAR
    FIELD vl-seguro AS DECIMAL
    FIELD vl-outros AS DECIMAL.

def temp-table tt-relac-saldo no-undo
    field sequencia         as int
    field seq-saldo-terc    like item-ref-nfe.seq-saldo-terc
    field qtd-alocar        like item-ref-nfe.qtd-alocada
    field cod-emitente      like item-ref-nfe.cod-emitente
    field nro-docto         like item-ref-nfe.nro-docto
    field serie-docto       like item-ref-nfe.serie-docto
    field nat-operacao      like item-ref-nfe.nat-operacao
    field nat-terc          like item-ref-nfe.nat-operacao
    field it-codigo         like item-ref-nfe.it-codigo
    index unico is primary unique
          sequencia.
          
def temp-table tt_log_erro  no-undo 
    field ttv_num_cod_erro  as integer   initial ?
    field ttv_des_msg_ajuda as character initial ?
    field ttv_des_msg_erro  as character initial ?.

/* TEMP-TABLE RESPONSAVEL PELA QUEBRA, CRIACAO E CONTROLE DOS ITENS GERADOS A PARTIR DO FIFO MANUAL. */
DEF TEMP-TABLE tt-rat-ordem-orig-nfe-aux NO-UNDO
    LIKE rat-ordem-orig-nfe      /* Copia todos os campos do FIFO manual do conversor. */
    FIELD seq-item-doc-est  LIKE item-doc-est.sequencia      /* Relaciona o FIFO com a item-doc-est.  */
    FIELD ordem-servic      LIKE ordem-compra.ordem-servic   /* Campo para fazer a quebra por FIFO.   */
    FIELD num-ord-inv       LIKE ordem-compra.num-ord-inv    /* Campo para fazer a quebra por FIFO.   */
    FIELD cod-refer         LIKE prazo-compra.cod-refer      /* Campo para fazer a quebra por FIFO.   */
    FIELD cod-unid-neg      AS CHAR FORMAT "X(3)"            /* Campo para fazer a quebra por FIFO.   */
    /*field unid-neg-fifo     as log*/                       /* Campo para fazer a quebra por FIFO. */
    FIELD ctrl-quebra       AS INT /* Codigo de controle de quebra.                           **
                                   ** Sequencias com o mesmo codigo pertencem a mesma quebra. */
    FIELD r-rowid           AS ROWID
    INDEX sequencial AS PRIMARY
    seq-item
    /* Os novos indices nao podem ser primarios nem unicos. */
    INDEX controle-quebra /* Controle de quebra. */
    ctrl-quebra. 

DEFINE TEMP-TABLE tt-rat-saldo-terc-dep NO-UNDO LIKE rat-saldo-terc
       field qtd-digitada as dec
       FIELD r-rowid AS ROWID 
       INDEX id IS PRIMARY UNIQUE serie-docto nro-docto cod-emitente nat-operacao it-codigo cod-refer sequencia lote cod-depos cod-localiz.

DEFINE TEMP-TABLE tt-ext-item-doc-est NO-UNDO LIKE ext-item-doc-est
    FIELD r-Rowid          AS ROWID.
    
DEFINE TEMP-TABLE tt-ext-docum-est NO-UNDO LIKE ext-docum-est
    FIELD r-Rowid AS ROWID.    

DEF TEMP-TABLE tt-doc-orig-nfe NO-UNDO LIKE doc-orig-nfe.

def temp-table tt-metricas-tip-diverg no-undo
    field desc-tipo-diverg  as char
    field quant-seq-item    as int
    index unico is primary unique
          desc-tipo-diverg.

define new global shared variable c-seg-usuario as char                      no-undo.
define variable h-boin01017             as handle                            no-undo.
define variable h-bodi516               as handle                            no-undo.
define variable h-bodi515               as handle                            no-undo.
define variable h-boin857               as handle                            no-undo.
define variable h-boin404re             as handle                            no-undo.
DEFINE VARIABLE h-boin368               AS HANDLE                            NO-UNDO.
define variable h-re1001p               as handle                            no-undo.
DEFINE VARIABLE h-boin223               AS HANDLE                            NO-UNDO.
DEFINE VARIABLE h-boin862               AS HANDLE                            NO-UNDO.
define variable h-cdapi024              as handle                            no-undo.
define variable h-axsep004              as handle                            no-undo.
DEFINE VARIABLE h-reapi401              AS HANDLE                            NO-UNDO.
DEFINE VARIABLE h-bodi538               AS HANDLE                            NO-UNDO.
define variable h-boin176               as handle                            no-undo.
define variable h-boin010               as handle                            no-undo.
define variable h-boin006               as handle                            no-undo.
define variable h-boin01109             as handle                            no-undo.
DEFINE VARIABLE i-empresa               LIKE empresa.ep-codigo               NO-UNDO.
define variable i-tipo-nota             as integer                           no-undo.
define variable i-total                 as integer                           no-undo.
DEFINE VARIABLE i-seq-item              AS INTEGER                           NO-UNDO.
define variable i-num-pedido            as integer                           no-undo.
DEFINE VARIABLE tg-digitada             AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE tg-digit-fisico         AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE tg-erro-neg             AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE tg-atualizada           AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE tg-eliminada            AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE tg-cancelada            AS LOGICAL                           NO-UNDO.
define variable tg-atualizada-fisico    as logical                           no-undo.
define variable tg-inutilizada          as logical                           no-undo.
DEFINE VARIABLE tg-validacao            AS LOGICAL                           NO-UNDO.
define variable l-validar-qtde          as logical initial yes               no-undo.
define variable l-contrato              as logical                           no-undo.
define variable l-terceiros             as logical                           no-undo.
DEFINE VARIABLE c-cod-emitente-ini      LIKE emitente.cod-emitente           NO-UNDO.
DEFINE VARIABLE c-cod-emitente-fim      LIKE emitente.cod-emitente           NO-UNDO.
DEFINE VARIABLE c-cod-estabel-ini       LIKE docum-est.cod-estabel           NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim       LIKE docum-est.cod-estabel           NO-UNDO.
DEFINE VARIABLE c-serie-ini             LIKE docum-est.serie-docto           NO-UNDO.
DEFINE VARIABLE c-serie-fim             LIKE docum-est.serie-docto           NO-UNDO.
DEFINE VARIABLE c-nro-docto-ini         LIKE docum-est.nro-docto             NO-UNDO.
DEFINE VARIABLE c-nro-docto-fim         LIKE docum-est.nro-docto             NO-UNDO.
DEFINE VARIABLE dt-emissao-ini          LIKE docum-est.dt-emissao            NO-UNDO.
DEFINE VARIABLE dt-emissao-fim          LIKE docum-est.dt-emissao            NO-UNDO.
define variable dt-transacao-ini        like docum-est.dt-trans              no-undo.
define variable dt-transacao-fim        like docum-est.dt-trans              no-undo.
DEFINE VARIABLE i-idi-orig-trad         LIKE doc-orig-nfe.idi-orig-trad      NO-UNDO.
define variable de-soma-dev-simb        as decimal                           no-undo.
define variable de-qtd-saldo            as decimal                           no-undo.
define variable de-frete-item           as decimal                           no-undo.
define variable de-despesa-item         as decimal                           no-undo.
DEFINE VARIABLE de-indice               AS DECIMAL                           NO-UNDO.
DEFINE VARIABLE unid-item-doc-est       as character                         NO-UNDO.
define variable c-modelo                as character                         no-undo.
DEFINE VARIABLE desc-erro               AS CHAR                              NO-UNDO.
define variable c-chave-acesso          like doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
define variable i-idi-origem            like doc-orig-nfe.idi-orig-trad      NO-UNDO.
DEFINE VARIABLE l-fifo-oc AS LOGICAL     NO-UNDO.
DEFINE VARIABLE desconto-item           AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE l-cria-rat-ordem        AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE l-erro-variacao         AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE tg-gerado-romaneio      AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE lLiberGeracRomaneio     AS LOGICAL INIT NO                   NO-UNDO.
DEFINE VARIABLE iRowIdRomaneioVinc      AS ROWID                             NO-UNDO.

define variable de-saldo-item           LIKE rat-lote-medic-nfe.qtd-lote-fabrican NO-UNDO.
define variable de-saldo-seq-it         LIKE rat-lote-medic-nfe.qtd-lote-fabrican NO-UNDO.
DEFINE VARIABLE de-saldo-lote           LIKE rat-lote-medic-nfe.qtd-lote-fabrican NO-UNDO.
DEFINE VARIABLE de-qtd-lote             LIKE rat-lote.quantidade                  NO-UNDO.
DEFINE VARIABLE c-cod-lote              LIKE rat-lote-medic-nfe.cod-lote-fabrican NO-UNDO.
DEFINE VARIABLE r-rowid-medic           AS   ROWID                                NO-UNDO.
DEFINE VARIABLE h-boin367               AS   HANDLE                               NO-UNDO.
DEFINE VARIABLE c-serie-docto-medic     LIKE item-doc-est.serie-docto             NO-UNDO.
DEFINE VARIABLE c-nro-docto-medic       LIKE item-doc-est.nro-docto               NO-UNDO.
DEFINE VARIABLE c-cod-emit-medic        LIKE item-doc-est.cod-emitente            NO-UNDO.
DEFINE VARIABLE c-nat-oper-medic        LIKE item-doc-est.nat-operacao            NO-UNDO.
DEFINE VARIABLE c-seq-medic             LIKE item-doc-est.sequencia               NO-UNDO.
DEFINE VARIABLE de-saldo-it-fiscal      LIKE item-doc-est.quantidade              NO-UNDO.
DEFINE VARIABLE c-it-codigo-medic       LIKE item-doc-est.it-codigo               NO-UNDO.
                                                                    
DEF VAR i-cod-emitente-ini  LIKE doc-orig-nfe.cod-emitente      NO-UNDO.
DEF VAR i-cod-emitente-fim  LIKE doc-orig-nfe.cod-emitente      NO-UNDO.
DEF VAR c-serie-docto-ini   LIKE doc-orig-nfe.serie-docto       NO-UNDO.
DEF VAR c-serie-docto-fim   LIKE doc-orig-nfe.serie-docto       NO-UNDO.
DEF VAR c-nat-operacao-ini  LIKE item-doc-orig-nfe.nat-operacao NO-UNDO.
DEF VAR c-nat-operacao-fim  LIKE item-doc-orig-nfe.nat-operacao NO-UNDO.
DEF VAR c-ch-acesso-nfe     AS CHAR                             NO-UNDO.
DEF VAR h-boin859           AS HANDLE                           NO-UNDO.

DEF VAR h-cdapi995          AS HANDLE                           NO-UNDO.
DEF VAR de-pc-pis           AS DECIMAL FORMAT ">9.9999"         NO-UNDO.
DEF VAR de-pc-cofins        AS DECIMAL FORMAT ">9.9999"         NO-UNDO.

DEFINE VARIABLE d-aliq-pis             AS DECIMAL   NO-UNDO.
DEFINE VARIABLE d-aliq-cofins          AS DECIMAL   NO-UNDO.
DEFINE VARIABLE d-val-base-pis         AS DECIMAL   NO-UNDO.
DEFINE VARIABLE d-val-base-cofins      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE d-val-pis              AS DECIMAL   NO-UNDO.
DEFINE VARIABLE d-val-cofins           AS DECIMAL   NO-UNDO.

DEFINE VARIABLE l-nota-composta        AS LOGICAL INITIAL NO   NO-UNDO.

/***************************************************************
** Engenharia PIS/COFINS por Unidade de Produto Lei 10833 MAT **
***************************************************************/
DEFINE VARIABLE de-valor-un-pis-devol    AS DECIMAL FORMAT ">>>9.99999" NO-UNDO.
DEFINE VARIABLE de-valor-un-cofins-devol AS DECIMAL FORMAT ">>>9.99999" NO-UNDO.

DEFINE BUFFER b-natur-oper              FOR natur-oper.
DEFINE BUFFER bf-natur-oper-tipo-operac FOR natur-oper.

{inbo/boin847.i tt-doc-orig-nfe-aux-1}

{rep/imp/utilizaImpostosMonitor.i}
DEFINE VARIABLE lFuncaoImpostosAtivada AS LOG INIT NO NO-UNDO. // re-impto-xml-nfe
DEFINE VARIABLE l-tipoOperPermitidoImpMonitor AS LOG INIT NO NO-UNDO.
ASSIGN lFuncaoImpostosAtivada = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-re-impto-xml-nfe":U 
                                                        AND funcao.ativo).
                                                        
DEFINE VARIABLE lNT2024002 AS LOGICAL     NO-UNDO.                                                        
ASSIGN lNT2024002 = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-NT2024002":U AND funcao.ativo).
                                                        

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
         HEIGHT             = 23.67
         WIDTH              = 39.86.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaFiscalFisico DBOProgram 
PROCEDURE verificaFiscalFisico :
/*------------------------------------------------------------------------------
  Purpose: Atualiza a natureza de operaá∆o de todos os itens do documento que possu°em
  CFOP igual a informada
    
  Parameters:  
  i-cod-emitente: C¢digo do emitente
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pr-nota              AS ROWID      NO-UNDO.
    
    DEFINE VARIABLE i-situacao AS INTEGER     NO-UNDO.
    
    FOR FIRST {&TableName} NO-LOCK
        WHERE ROWID({&TableName}) = pr-nota:
        FOR FIRST docum-est FIELDS(ce-atual)
            WHERE docum-est.serie-docto              = {&TableName}.serie-docto
              AND docum-est.nro-docto                = {&TableName}.nro-docto
              AND docum-est.cod-emitente             = {&TableName}.cod-emitente
              AND docum-est.cod-chave-aces-nf-eletro = {&TableName}.ch-acesso-comp-nfe NO-LOCK:
            ASSIGN i-situacao = IF docum-est.ce-atual THEN 3 ELSE 1.
        END.
        IF NOT AVAIL docum-est THEN
            
            FOR FIRST doc-fisico FIELDS(situacao)
                WHERE doc-fisico.serie-docto  = {&TableName}.serie-docto
                  AND doc-fisico.nro-docto    = {&TableName}.nro-docto
                  AND doc-fisico.cod-emitente = {&TableName}.cod-emitente
                  AND doc-fisico.dt-emissao   = {&TableName}.dt-emissao NO-LOCK:
                CASE doc-fisico.situacao.
                    WHEN 2 THEN
                        ASSIGN i-situacao = 7. /* Atualizada Receb. F°sico */
                    WHEN 3 THEN
                        ASSIGN i-situacao = 1. /* Digitada Receb. Fiscal */
                    OTHERWISE
                        ASSIGN i-situacao = 6. /* Digitada Receb. F°sico */
                END CASE.
            END.

        IF i-situacao > 0 THEN DO:
            RUN atualizaSituacao(INPUT {&TableName}.ch-acesso-comp-nfe,
                                 INPUT {&TableName}.cod-emitente,
                                 INPUT {&TableName}.cod-estabel,
                                 INPUT {&TableName}.serie-docto,
                                 INPUT {&TableName}.nro-docto,
                                 INPUT "",
                                 INPUT {&TableName}.dt-emissao,
                                 INPUT i-situacao).
            CASE i-situacao.
                WHEN 7 THEN
                    {utp/ut-liter.i Nota_j†_atualizada_no_Receb._F°sico *}
                WHEN 1 THEN
                    {utp/ut-liter.i Nota_j†_digitada_no_Receb._Fiscal *}
                WHEN 6 THEN
                    {utp/ut-liter.i Nota_j†_digitada_no_Receb._F°sico *} 
                WHEN 3 THEN
                    {utp/ut-liter.i Nota_j†_atualizada_no_Receb._Fiscal *}
            END CASE.

            RUN implantaErro(INPUT {&TableName}.ch-acesso-comp-nfe,
                             INPUT 17006,
                             INPUT RETURN-VALUE,
                             INPUT 1).    /* Erro */ 

            RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaSituacao DBOProgram 
PROCEDURE atualizaSituacao :
/*------------------------------------------------------------------------------
  Purpose:  
  Atualiza a situaá∆o do Documento Origem Nota Entrada para a situaá∆o passada como parÉmetro.
    
  Parameters:  
  i-cod-emitente: C¢digo do emitente
  c-cod-estabel : C¢digo do estabelecimento
  c-serie-docto : SÇrie do documento
  c-nro-docto   : N£mero do documento
  c-nat-operacao: Natureza de operaá∆o 
  p-dt-emissao  : Data de emiss∆o do documento
  i-situacao    : Situaá∆o para qual o documento ser† atualizado
  
  Notes: S¢ atualiza o documento se a Origem do mesmo for Traduzido (2)      
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM c-chave-comp-nfe LIKE doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAM i-cod-emitente   LIKE doc-orig-nfe.cod-emitente       NO-UNDO.
    DEFINE INPUT PARAM c-cod-estabel    LIKE doc-orig-nfe.cod-estabel        NO-UNDO.
    DEFINE INPUT PARAM c-serie-docto    LIKE doc-orig-nfe.nro-docto          NO-UNDO.
    DEFINE INPUT PARAM c-nro-docto      LIKE doc-orig-nfe.nro-docto          NO-UNDO.
    DEFINE INPUT PARAM c-nat-operacao   AS CHARACTER                         NO-UNDO.
    DEFINE INPUT PARAM p-dt-emissao     LIKE doc-orig-nfe.dt-emissao             NO-UNDO.
    DEFINE INPUT PARAM i-situacao       AS INTEGER                           NO-UNDO.

    /* Busca pela chave eletrìnica. */
    IF c-chave-comp-nfe <> "":U THEN
        find first bf{&TableName} exclusive-lock
            where bf{&TableName}.ch-acesso-comp-nfe = c-chave-comp-nfe
            and bf{&TableName}.idi-orig-trad        = 2 no-error.

    IF NOT AVAIL bf{&TableName} THEN DO:

        if trim(c-serie-docto) = "" then
            find first bf{&TableName} exclusive-lock 
                where bf{&TableName}.cod-emitente  = i-cod-emitente
                and   bf{&TableName}.cod-estabel   = c-cod-estabel 
                and   bf{&TableName}.nro-docto     = c-nro-docto
                and   bf{&TableName}.idi-orig-trad = 2
                and   bf{&TableName}.serie-docto   < "1" 
                AND   bf{&TableName}.dt-emissao    = p-dt-emissao no-error.
        else
            find first bf{&TableName} exclusive-lock 
                where bf{&TableName}.cod-emitente  = i-cod-emitente
                and   bf{&TableName}.cod-estabel   = c-cod-estabel
                and   bf{&TableName}.serie-docto   = c-serie-docto
                and   bf{&TableName}.nro-docto     = c-nro-docto
                and   bf{&TableName}.idi-orig-trad = 2
                AND   bf{&TableName}.dt-emissao    = p-dt-emissao no-error.

    END.

    IF AVAIL bf{&TableName} THEN DO:
        /* Desaloca o saldo alocado pelo Conversor, pois a nota est† sendo digitada 
           manualmente no recebimento f°sico ou fiscal */

        /* jaks */
        IF  NOT VALID-HANDLE(h-boin176) THEN
            RUN inbo/boin176.p PERSISTENT SET h-boin176.

        RUN getFatAntecipEntFutura IN h-boin176(INPUT c-nat-operacao,
                                                OUTPUT l-fatura-fat-antecip,
                                                OUTPUT l-remessa-fat-antecip,
                                                OUTPUT l-fatura-ent-futura, 
                                                OUTPUT l-remessa-ent-futura).
        IF  NOT l-remessa-ent-futura THEN DO: 
        /* jaks */

            IF i-situacao = 6 OR /* Digitada no receb. f°sico*/  
               i-situacao = 1    /* Digitada no receb. fiscal */ THEN DO:
                if avail bf{&TableName}
                and ((i-situacao = 6 AND bf{&TableName}.idi-situacao <> 6) OR
                    (i-situacao = 1)) then do: 
    
                    if not valid-handle(h-boin857) or
                        h-boin857:type      <> "PROCEDURE":U or
                        h-boin857:file-name <> "inbo/boin857.p":U THEN                    
                        RUN inbo/boin857.p PERSISTENT SET h-boin857.
    
                    if not valid-handle(h-boin404re) 
                        or h-boin404re:type      <> "PROCEDURE":U 
                        or h-boin404re:file-name <> "inbo/boin404re.p":U then
                            run inbo/boin404re.p persistent set h-boin404re.
    
                    
                    for each item-doc-orig-nfe of bf{&TableName} exclusive-lock
                        where item-doc-orig-nfe.idi-orig-trad = 2:
    
                        /* Somente desaloca dos itens que pertencem a nota digitada **
                        ** para evitar desalocacoes indevidas por digitar uma nota  **
                        ** com mesmo numero, serie, emitente e natureza diferente.  */
                        IF c-nat-operacao <> "" THEN DO:
                            IF i-situacao = 1 AND item-doc-orig-nfe.nat-operacao <> c-nat-operacao THEN
                                NEXT.
                        END.

                        for each item-ref-nfe NO-LOCK
                            where item-ref-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                            and   item-ref-nfe.seq-item           = item-doc-orig-nfe.seq-item:
                            
                            FIND FIRST natur-oper
                                 WHERE natur-oper.nat-operacao = item-doc-orig-nfe.nat-operacao NO-LOCK NO-ERROR.
                            IF AVAIL natur-oper AND natur-oper.terceiros AND natur-oper.tp-oper-terc = 4 THEN do: /* faturamento de consignaá∆o */
                                FOR EACH rat-lote-medic-nfe                                                        
                                   WHERE rat-lote-medic-nfe.ch-acesso-comp-nfe = item-ref-nfe.ch-acesso-comp-nfe
                                     AND rat-lote-medic-nfe.idi-orig-trad      = 2                                 
                                     AND rat-lote-medic-nfe.seq-item           = item-ref-nfe.seq-saldo-terc EXCLUSIVE-LOCK:
                                     IF SUBSTRING(rat-lote-medic-nfe.cod-livre-1,51,16) = item-ref-nfe.nro-docto THEN
                                        DELETE rat-lote-medic-nfe.
                                END.
                            END.
                           
                        end.
                    end.
    
                    IF  VALID-HANDLE(h-boin857)        AND
                        h-boin857:TYPE = "PROCEDURE":U AND
                        h-boin857:FILE-NAME = "inbo/boin857.p":U THEN DO:
                        DELETE PROCEDURE h-boin857.
                        ASSIGN h-boin857 = ?.
                    END.
    
                    IF  VALID-HANDLE(h-boin404re)        AND
                        h-boin404re:TYPE = "PROCEDURE":U AND
                        h-boin404re:FILE-NAME = "inbo/boin404re.p":U THEN DO:
                        DELETE PROCEDURE h-boin404re.
                        ASSIGN h-boin404re = ?.
                    END.
    
                end.            
            END.
        
            /* jaks */
            IF  VALID-HANDLE(h-boin176) THEN DO:
                RUN destroy IN h-boin176.
                DELETE PROCEDURE h-boin176 NO-ERROR.
                ASSIGN h-boin176 = ?.
            END.
        END.
        /* jaks */

        assign bf{&TableName}.idi-situacao = i-situacao.

    END.

    RELEASE bf{&TableName}.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaSituacaoAtualizacaoRecFiscal DBOProgram 
PROCEDURE atualizaSituacaoAtualizacaoRecFiscal :
/*------------------------------------------------------------------------------
  Purpose:  
  Atualiza a situaá∆o do Documento Origem Nota Entrada quando ocorre a atualizaá∆o
  do recebimento fiscal
    
  Parameters:  
  c-chave-comp-nfe: Chave de acesso completa da NFe
  c-serie-docto:    SÇrie do Documento
  c-nro-docto:      N£mero do Documento
  i-cod-emitente:   C¢digo do Emitente
  c-nat-operacao:   Natureza de operaá∆o
  c-cod-estabel:    C¢digo do estabelecimento
  
  Notes: S¢ atualiza o documento se a Origem do mesmo for Traduzido (2)      
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM c-chave-comp-nfe LIKE doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAM c-serie-docto    LIKE doc-orig-nfe.serie-docto        NO-UNDO.
    DEFINE INPUT PARAM c-nro-docto      LIKE doc-orig-nfe.nro-docto          NO-UNDO.
    DEFINE INPUT PARAM i-cod-emitente   LIKE doc-orig-nfe.cod-emitente       NO-UNDO.
    DEFINE INPUT PARAM c-nat-operacao   LIKE docum-est.nat-operacao          NO-UNDO.
    DEFINE INPUT PARAM c-cod-estabel    LIKE doc-orig-nfe.cod-estabel        NO-UNDO.

    find first bf{&TableName} exclusive-lock 
        where  bf{&TableName}.ch-acesso-comp-nfe = c-chave-comp-nfe
        and    bf{&TableName}.idi-orig-trad  =  2 no-error.
       

    IF NOT AVAIL bf{&TableName} THEN DO:
        if trim(c-serie-docto) = "" THEN DO:
            FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
                WHERE bf{&TableName}.cod-emitente  = i-cod-emitente
                AND   bf{&TableName}.cod-estabel   = c-cod-estabel
                AND   bf{&TableName}.nro-docto     = c-nro-docto
                AND   bf{&TableName}.idi-orig-trad = 2 
                AND   bf{&TableName}.serie-docto   < "1" NO-ERROR.
        END.
        ELSE DO:
            FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
                WHERE bf{&TableName}.cod-emitente  = i-cod-emitente
                AND   bf{&TableName}.cod-estabel   = c-cod-estabel
                AND   bf{&TableName}.serie-docto   = c-serie-docto
                AND   bf{&TableName}.nro-docto     = c-nro-docto
                AND   bf{&TableName}.idi-orig-trad = 2 NO-ERROR.
        END.
    END.

    IF AVAIL bf{&TableName} THEN DO:
        
        IF NOT CAN-FIND(FIRST docum-est WHERE docum-est.serie-docto  = c-serie-docto   AND
                                          docum-est.nro-docto        = c-nro-docto     AND
                                          docum-est.cod-emitente     = i-cod-emitente  AND 
                                          docum-est.nat-operacao     <> c-nat-operacao AND
                                          NOT docum-est.ce-atual) THEN
            ASSIGN bf{&TableName}.idi-situacao = 3. /* Atualizada Receb. Fiscal */ 
    END.
        

    IF NOT AVAIL bf{&TableName} THEN DO:
        FOR FIRST movto-pend
            WHERE movto-pend.cod-emitente = i-cod-emitente
              AND movto-pend.serie-comp   = c-serie-docto
              AND movto-pend.nro-comp     = c-nro-docto
              AND movto-pend.nat-comp     = c-nat-operacao NO-LOCK:
            FOR FIRST bf{&TableName} EXCLUSIVE-LOCK
                WHERE bf{&TableName}.ch-acesso-comp-nfe = movto-pend.cod-chave-aces-nf-eletro
                  AND bf{&TableName}.idi-orig-trad = 2:

                IF NOT CAN-FIND(FIRST docum-est WHERE docum-est.serie-docto  = c-serie-docto  AND
                                      docum-est.nro-docto                    = c-nro-docto    AND
                                      docum-est.cod-emitente                 = i-cod-emitente AND 
                                      docum-est.nat-operacao                 <> c-nat-operacao AND
                                      NOT docum-est.ce-atual) THEN
                    ASSIGN bf{&TableName}.idi-situacao = 3. /* Atualizada Receb. Fiscal */ 
            END.
        END.
    END.

    RELEASE bf{&TableName}.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaSituacaoEliminacaoDocFisico DBOProgram 
PROCEDURE atualizaSituacaoEliminacaoDocFisico :
/*------------------------------------------------------------------------------
  Purpose:  
  Atualiza a situaá∆o do Documento Origem Nota Entrada quando ocorre a eliminaá∆o 
  do documento f°sico
    
  Parameters:  
  c-serie-docto:    SÇrie do documento
  c-nro-docto:      N£mero do documento
  i-cod-emitente:   C¢digo do emitente
  c-cod-estabel:    C¢digo do estabelecimento
  i-tipo-nota:      Tipo de operaá∆o da nota
  p-chave-acesso:   Chave de acesso do documento NF-e
  p-dt-emissao:     Data de emiss∆o do documento
  
  
  Notes: 
  
  Seta a situaá∆o do documento para 4 (Eliminada Recebimento)e  
  zera o pedido, ordem e parcela da tabela espec°fica do conversor.
     
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM c-serie-docto    LIKE doc-orig-nfe.serie-docto            NO-UNDO.
    DEFINE INPUT PARAM c-nro-docto      LIKE doc-orig-nfe.nro-docto              NO-UNDO.
    DEFINE INPUT PARAM i-cod-emitente   LIKE doc-orig-nfe.cod-emitente           NO-UNDO.
    DEFINE INPUT PARAM c-cod-estabel    LIKE doc-orig-nfe.cod-estabel            NO-UNDO.
    DEFINE INPUT PARAM i-tipo-nota      LIKE doc-fisico.tipo-nota                NO-UNDO.
    DEFINE INPUT PARAM p-chave-acesso   LIKE doc-fisico.cod-chave-aces-nf-eletro NO-UNDO.
    DEFINE INPUT PARAM p-dt-emissao     LIKE doc-orig-nfe.dt-emissao             NO-UNDO.
    
    IF p-chave-acesso <> "" THEN DO:
       FOR FIRST doc-orig-nfe NO-LOCK
           WHERE doc-orig-nfe.ch-acesso-comp-nfe = p-chave-acesso
             AND doc-orig-nfe.idi-orig-trad = 2 :
       END.
    END.

    IF NOT AVAIL doc-orig-nfe THEN DO:
       IF c-serie-docto = "" THEN DO:
           FIND FIRST doc-orig-nfe 
               WHERE doc-orig-nfe.cod-emitente  = i-cod-emitente 
                 AND doc-orig-nfe.cod-estabel   = c-cod-estabel
                 AND doc-orig-nfe.nro-docto     = c-nro-docto
                 AND doc-orig-nfe.idi-orig-trad = 2
                 AND doc-orig-nfe.serie-docto   < "1"
                 AND doc-orig-nfe.dt-emissao    = p-dt-emissao NO-LOCK NO-ERROR.
       END.
       ELSE DO:
           FIND FIRST doc-orig-nfe 
                WHERE doc-orig-nfe.cod-emitente  = i-cod-emitente 
                  AND doc-orig-nfe.cod-estabel   = c-cod-estabel
                  AND doc-orig-nfe.serie-docto   = c-serie-docto
                  AND doc-orig-nfe.nro-docto     = c-nro-docto
                  AND doc-orig-nfe.idi-orig-trad = 2
                  AND doc-orig-nfe.dt-emissao    = p-dt-emissao NO-LOCK NO-ERROR.
       END.    
    END.
    
        
    IF AVAIL doc-orig-nfe  THEN DO:

        FOR FIRST bf{&TableName} EXCLUSIVE-LOCK
            WHERE ROWID(bf{&TableName}) = ROWID(doc-orig-nfe) :

            IF NOT CAN-FIND(FIRST docum-est 
                            WHERE docum-est.serie-docto              = c-serie-docto
                              AND docum-est.nro-docto                = c-nro-docto  
                              AND docum-est.cod-emitente             = i-cod-emitente
                              AND docum-est.cod-chave-aces-nf-eletro = doc-orig-nfe.ch-acesso-comp-nfe) 
            AND NOT CAN-FIND(FIRST doc-fisico /* Passa a verificar a tabela doc-fisico ao eliminar documento */
                             WHERE doc-fisico.serie-docto  = c-serie-docto
                               AND doc-fisico.nro-docto    = c-nro-docto
                               AND doc-fisico.cod-emitente = i-cod-emitente
                               AND doc-fisico.tipo-nota    <> i-tipo-nota
                               AND doc-fisico.dt-emissao   = doc-orig-nfe.dt-emissao
                               AND doc-fisico.cod-chave-aces-nf-eletro = doc-orig-nfe.ch-acesso-comp-nfe) THEN DO:
                
                ASSIGN bf{&TableName}.idi-situacao = 4. /* Eliminada Recebimento */

                IF NOT CAN-FIND(FIRST msg-ret-nfe 
                                WHERE msg-ret-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe 
                                  AND msg-ret-nfe.idi-orig-trad      = 2 
                                  AND msg-ret-nfe.log-ativo
                                  AND msg-ret-nfe.cd-msg             = 5168) /* Nota rejeitada pela Sefaz */ THEN
                    FOR EACH msg-ret-nfe EXCLUSIVE-LOCK
                       WHERE msg-ret-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
                         AND msg-ret-nfe.idi-orig-trad      = 2
                         AND msg-ret-nfe.log-ativo:
                        ASSIGN msg-ret-nfe.log-ativo = NO.
                    END.

                IF NOT VALID-HANDLE(h-boin857) 
                OR h-boin857:TYPE      <> "PROCEDURE":U 
                OR h-boin857:FILE-NAME <> "inbo/boin857.p":U THEN
                    RUN inbo/boin857.p PERSISTENT SET h-boin857.
    
                IF NOT VALID-HANDLE(h-boin404re)
                OR h-boin404re:TYPE      <> "PROCEDURE":U 
                OR h-boin404re:FILE-NAME <> "inbo/boin404re.p":U THEN
                    RUN inbo/boin404re.p PERSISTENT SET h-boin404re.
    
                FOR EACH item-doc-orig-nfe NO-LOCK
                   WHERE item-doc-orig-nfe.ch-acesso-comp-nfe  = bf{&TableName}.ch-acesso-comp-nfe
                     AND item-doc-orig-nfe.idi-orig-trad = 2:
                    
                    /* Realoca o saldo para manter a ordem e o pedido no conversor  */
                    IF item-doc-orig-nfe.numero-ordem <> 0 THEN DO:
                        RUN findOrdemCompra     IN h-boin857 (INPUT item-doc-orig-nfe.numero-ordem).
                        RUN validaContratoOrdem IN h-boin857 (OUTPUT l-contrato,
                                                              OUTPUT i-total   ).
                        IF i-total = 0 THEN
                            RUN pi-aloca-ordem-cc IN h-boin857 (INPUT YES,
                                                                INPUT item-doc-orig-nfe.numero-ordem,
                                                                INPUT item-doc-orig-nfe.parcela,
                                                                INPUT item-doc-orig-nfe.qtd-interna).
                    END.
                    ELSE
                        FOR EACH rat-ordem-orig-nfe NO-LOCK
                           WHERE rat-ordem-orig-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                             AND rat-ordem-orig-nfe.seq-item           = item-doc-orig-nfe.seq-item:

                            RUN findOrdemCompra     IN h-boin857(INPUT rat-ordem-orig-nfe.numero-ordem).
                            RUN validaContratoOrdem IN h-boin857(OUTPUT l-contrato,
                                                                 OUTPUT i-total   ).
                            IF i-total = 0 THEN
                                RUN pi-aloca-ordem-cc IN h-boin857(INPUT YES, /* Aloca */
                                                                   INPUT rat-ordem-orig-nfe.numero-ordem ,
                                                                   INPUT rat-ordem-orig-nfe.parcela, 
                                                                   INPUT rat-ordem-orig-nfe.qtd-interna).
                        END.
    
                    /* Realocar saldo em poder de terceiros, notas de terceiros */
                    FOR EACH item-ref-nfe 
                       WHERE item-ref-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                         AND item-ref-nfe.seq-item           = item-doc-orig-nfe.seq-item  NO-LOCK:
                        
                        RUN alocaSaldoTerc IN h-boin404re (INPUT YES,
                                                           INPUT item-ref-nfe.qtd-alocada,
                                                           INPUT item-ref-nfe.seq-saldo-terc,
                                                           INPUT item-ref-nfe.cod-emitente,
                                                           INPUT item-ref-nfe.nro-docto,
                                                           INPUT item-ref-nfe.serie-docto,
                                                           INPUT item-doc-orig-nfe.nat-operacao, /* Natureza do item. */
                                                           INPUT item-ref-nfe.nat-operacao,      /* Natureza do saldo em terceiros. */
                                                           INPUT item-ref-nfe.it-codigo).
                    END.
                END.
    
                IF  VALID-HANDLE(h-boin857)
                AND h-boin857:TYPE = "PROCEDURE":U 
                AND h-boin857:FILE-NAME = "inbo/boin857.p":U THEN DO:
                    DELETE PROCEDURE h-boin857.
                    ASSIGN h-boin857 = ?.
                END.
    
                IF  VALID-HANDLE(h-boin404re)
                AND h-boin404re:TYPE = "PROCEDURE":U 
                AND h-boin404re:FILE-NAME = "inbo/boin404re.p":U THEN DO:
                    DELETE PROCEDURE h-boin404re.
                    ASSIGN h-boin404re = ?.
                END.

                /* Evento Cancelamento */
                FOR FIRST event-nfe-cte FIELDS(idi-sit-event) EXCLUSIVE-LOCK
                    WHERE event-nfe-cte.ch-acesso-comp-nfe = doc-orig-nfe.ch-acesso-comp-nfe
                      AND event-nfe-cte.idi-tip-docto     = 1 /* 1-) 367-NF-E */
                      AND event-nfe-cte.idi-sit-event     = 1 /* Pendente */ :

                    RUN cancelaDocumento(INPUT ROWID(doc-orig-nfe), ?).
                    IF RETURN-VALUE = "OK":U THEN DO:
                        ASSIGN event-nfe-cte.idi-sit-event = 2. /* processado */
                        /* Mensagem a ser mostrada no browse de informaÁıes do conversor */
                        {utp/ut-liter.i NF-e_foi_cancelada *}
                        RUN implantaErroConfCadastroMsg(INPUT event-nfe-cte.ch-acesso-comp-nfe,
                                                        INPUT 54213,  /* Mensagem: NF-e foi cancelada devido a recepá∆o do XML de cancelamento. */
                                                        INPUT RETURN-VALUE,
                                                        INPUT 4). /* Informacao */
                    END.
                END.
            END.    
        END.
        RELEASE bf{&TableName}.
        
        IF CAN-FIND(FIRST msg-ret-nfe 
                    WHERE msg-ret-nfe.ch-acesso-comp-nfe = doc-orig-nfe.ch-acesso-comp-nfe
                      AND msg-ret-nfe.idi-orig-trad      = 2 
                      AND msg-ret-nfe.log-ativo
                      AND msg-ret-nfe.cd-msg             = 5168) /* Nota rejeitada pela Sefaz */ THEN
            RUN inutilizaNFE(INPUT doc-orig-nfe.ch-acesso-comp-nfe,
                             INPUT YES).
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaSituacaoEliminacaoDocumEst DBOProgram 
PROCEDURE atualizaSituacaoEliminacaoDocumEst :
/*------------------------------------------------------------------------------
  Purpose:  
  Atualiza a situaá∆o do Documento Origem Nota Entrada quando ocorre a eliminaá∆o 
  do documento fiscal
    
  Parameters:  
  c-chave-comp-nfe: Chave de acesso completa da NFe
  c-serie-docto:    SÇrie do documento
  c-nro-docto:      N£mero do documento
  i-cod-emitente:   C¢digo do emitente
  i-tipo-nota:      Tipo da nota
  c-nat-operacao:   Natureza de operaá∆o da nota
  da-emissao:       data de emiss∆o do documento

  Notes: 
  
  Dependendo de como se encontra a nota, seta a situaá∆o do documento para 
  1 (Digitada Receb. Fiscal), 
  4 (Eliminada Recebimento) ou 
  7 (Atualizada Receb. F°sico), alÇm de em caso de eliminaá∆o do documento, 
  zerar o pedido, ordem e parcela da tabela espec°fica do conversor, 
  e desfazer a relaá∆o com os documentos referenciados pelo conversor, 
  por motivos de consistància de base.
     
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM c-chave-comp-nfe LIKE doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAM c-serie-docto    LIKE doc-orig-nfe.serie-docto        NO-UNDO.
    DEFINE INPUT PARAM c-nro-docto      LIKE doc-orig-nfe.nro-docto          NO-UNDO.
    DEFINE INPUT PARAM i-cod-emitente   LIKE doc-orig-nfe.cod-emitente       NO-UNDO.
    DEFINE INPUT PARAM i-tipo-nota      LIKE docum-est.tipo-nota             NO-UNDO.
    DEFINE INPUT PARAM c-nat-operacao   LIKE docum-est.nat-operacao          NO-UNDO.
    DEFINE INPUT PARAM da-emissao       LIKE docum-est.dt-emissao            NO-UNDO.


    find first bf{&TableName} exclusive-lock 
        WHERE bf{&TableName}.ch-acesso-comp-nfe = c-chave-comp-nfe AND
              bf{&TableName}.idi-orig-trad = 2 NO-ERROR.

    if not avail bf{&TableName} THEN DO:
        /* Se a nota foi digitada manualmente, a chave pode divergir. */
        if trim(c-serie-docto) = "" then
            find first bf{&TableName} exclusive-lock 
                where  bf{&TableName}.cod-emitente  = i-cod-emitente
                and    bf{&TableName}.nro-docto     = c-nro-docto
                and    bf{&TableName}.dt-emissao    = da-emissao
                AND    bf{&TableName}.idi-orig-trad = 2
                and    bf{&TableName}.serie-docto   < "1" no-error.
        else
            find first bf{&TableName} exclusive-lock 
                where bf{&TableName}.cod-emitente  = i-cod-emitente
                and   bf{&TableName}.serie-docto   = c-serie-docto
                and   bf{&TableName}.nro-docto     = c-nro-docto
                and   bf{&TableName}.dt-emissao    = da-emissao 
                and   bf{&TableName}.idi-orig-trad = 2 no-error.
    END.
    
    IF AVAIL bf{&TableName} THEN DO:
        if can-find(first doc-fisico
                    where doc-fisico.serie-docto  = c-serie-docto
                      and doc-fisico.nro-docto    = c-nro-docto
                      and doc-fisico.cod-emitente = i-cod-emitente
                      and doc-fisico.tipo-nota    = i-tipo-nota
                      and doc-fisico.dt-emissao   = da-emissao) THEN DO:

            assign bf{&TableName}.idi-situacao = 7. /*  Atualizada Receb. F°sico */
        END.
        else do:
            /* Verificar se todas as notas est∆o eliminadas - Caso existam mais de um documento no recebimento 
            (Documento com naturezas distintas no conversor) */

            /* Verifica se h† notas digitadas no recebimento */
            IF CAN-FIND(FIRST docum-est 
                        WHERE docum-est.serie-docto  = c-serie-docto  
                          AND docum-est.nro-docto    = c-nro-docto    
                          AND docum-est.cod-emitente = i-cod-emitente 
                          AND docum-est.dt-emissao   = da-emissao
                          AND docum-est.nat-operacao <> c-nat-operacao 
                          AND NOT docum-est.ce-atual) THEN DO: 

                ASSIGN bf{&TableName}.idi-situacao = 1. /* Digitada recebimento fiscal */
            END.
            /* Verifica se h† notas atualizadas no recebimento */
            ELSE IF CAN-FIND(FIRST docum-est 
                             WHERE docum-est.serie-docto  = c-serie-docto
                               AND docum-est.nro-docto    = c-nro-docto 
                               AND docum-est.cod-emitente = i-cod-emitente 
                               AND docum-est.dt-emissao   = da-emissao
                               AND docum-est.nat-operacao <> c-nat-operacao 
                               AND docum-est.ce-atual) THEN DO:
                ASSIGN bf{&TableName}.idi-situacao = 3. /* Atualizada Receb. Fiscal */
            END.
            ELSE DO:
                ASSIGN bf{&TableName}.idi-situacao = 4. /* Eliminada Recebimento */
            END.

            IF NOT CAN-FIND(FIRST msg-ret-nfe 
                            WHERE msg-ret-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe 
                              AND msg-ret-nfe.idi-orig-trad      = 2 
                              AND msg-ret-nfe.log-ativo
                              AND msg-ret-nfe.cd-msg             = 5168) /* Nota rejeitada pela Sefaz */ THEN
                FOR EACH msg-ret-nfe EXCLUSIVE-LOCK
                   WHERE msg-ret-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
                     AND msg-ret-nfe.idi-orig-trad      = 2
                     AND msg-ret-nfe.log-ativo:
                    ASSIGN msg-ret-nfe.log-ativo = NO.
                END.

            /* Se chegar a esse ponto significa que a nota que foi eliminada est† somente
               no conversor NF-e e precisa ter suas ordens realocadas */
            IF NOT VALID-HANDLE(h-boin857) 
            OR h-boin857:TYPE      <> "PROCEDURE":U 
            OR h-boin857:FILE-NAME <> "inbo/boin857.p":U THEN
                RUN inbo/boin857.p PERSISTENT SET h-boin857.

            IF NOT VALID-HANDLE(h-boin404re)
            OR h-boin404re:TYPE      <> "PROCEDURE":U 
            OR h-boin404re:FILE-NAME <> "inbo/boin404re.p":U THEN
                RUN inbo/boin404re.p PERSISTENT SET h-boin404re.

            IF  NOT VALID-HANDLE(h-boin176) THEN
                RUN inbo/boin176.p PERSISTENT SET h-boin176.

            RUN getFatAntecipEntFutura IN h-boin176(INPUT c-nat-operacao,
                                                    OUTPUT l-fatura-fat-antecip,
                                                    OUTPUT l-remessa-fat-antecip,
                                                    OUTPUT l-fatura-ent-futura, 
                                                    OUTPUT l-remessa-ent-futura).

            IF bf{&TableName}.idi-situacao = 4 /* Eliminada Recebimento */ THEN DO:                
            
                FOR EACH item-doc-orig-nfe OF bf{&TableName} NO-LOCK
                    WHERE item-doc-orig-nfe.idi-orig-trad = 2:

                    /* ############################################################### **
                    ** Realoca o saldo para manter a ordem e o pedido no conversor.    **
                    ** Caso o usuario digite o documento manualmente, as demais UPCs   **
                    ** se encarregarao de desalocar o saldo e zerar a ordem de compra. **
                    ** ############################################################### */
                    
                    IF  NOT l-fatura-ent-futura
                    AND NOT l-remessa-ent-futura THEN DO:

                        IF item-doc-orig-nfe.numero-ordem <> 0 THEN DO:
        
                            RUN findOrdemCompra     IN h-boin857 (INPUT item-doc-orig-nfe.numero-ordem).
                            RUN validaContratoOrdem IN h-boin857 (OUTPUT l-contrato,
                                                                  OUTPUT i-total   ).
                            IF i-total = 0 THEN
                                RUN pi-aloca-ordem-cc IN h-boin857 (INPUT YES,
                                                                    INPUT item-doc-orig-nfe.numero-ordem,
                                                                    INPUT item-doc-orig-nfe.parcela,
                                                                    INPUT item-doc-orig-nfe.qtd-interna).
                        END.
                        ELSE DO:
                            FOR EACH rat-ordem-orig-nfe EXCLUSIVE-LOCK
                                WHERE rat-ordem-orig-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                                  AND rat-ordem-orig-nfe.seq-item           = item-doc-orig-nfe.seq-item:
                                    
                                IF rat-ordem-orig-nfe.val-medicao > 0 THEN DO:
                                    FOR FIRST medicao-contrat
                                        WHERE medicao-contrat.nr-contrato     = rat-ordem-orig-nfe.nr-contrato
                                          AND medicao-contrat.num-seq-item    = rat-ordem-orig-nfe.num-seq-item
                                          AND medicao-contrat.numero-ordem    = rat-ordem-orig-nfe.numero-ordem   
                                          AND medicao-contrat.num-seq-event   = rat-ordem-orig-nfe.num-seq-event  
                                          AND medicao-contrat.num-seq-medicao = rat-ordem-orig-nfe.num-seq-medicao NO-LOCK:
                                        RUN pi-aloca-medicao(INPUT YES, /*aloca*/
                                                             INPUT rat-ordem-orig-nfe.val-medicao, 
                                                             INPUT ROWID(medicao-contrat)).
                                    END.
                                END.
                                ELSE DO:
                                    RUN pi-aloca-ordem-cc IN h-boin857 (INPUT YES,
                                                                        INPUT rat-ordem-orig-nfe.numero-ordem,
                                                                        INPUT rat-ordem-orig-nfe.parcela,
                                                                        INPUT rat-ordem-orig-nfe.qtd-interna).
                                END.
                            END.
                        END.
                    END.

                    /* Realocar saldo em poder de terceiros, notas de terceiros: */
                    FOR EACH item-ref-nfe 
                        WHERE item-ref-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                          AND item-ref-nfe.seq-item           = item-doc-orig-nfe.seq-item  NO-LOCK:

                        /* Aloca o saldo em poder de terceiros. */
                        RUN alocaSaldoTerc IN h-boin404re (INPUT YES,
                                                           INPUT item-ref-nfe.qtd-alocada,
                                                           INPUT item-ref-nfe.seq-saldo-terc,
                                                           INPUT item-ref-nfe.cod-emitente,
                                                           INPUT item-ref-nfe.nro-docto,
                                                           INPUT item-ref-nfe.serie-docto,
                                                           INPUT item-doc-orig-nfe.nat-operacao, /* Natureza do item. */
                                                           INPUT item-ref-nfe.nat-operacao,      /* Natureza do saldo em terceiros. */
                                                           INPUT item-ref-nfe.it-codigo).

                    END.
                END.
            END.

            IF  VALID-HANDLE(h-boin857)
            AND h-boin857:TYPE = "PROCEDURE":U 
            AND h-boin857:FILE-NAME = "inbo/boin857.p":U THEN DO:
                DELETE PROCEDURE h-boin857.
                ASSIGN h-boin857 = ?.
            END.

            IF  VALID-HANDLE(h-boin404re)
            AND h-boin404re:TYPE = "PROCEDURE":U 
            AND h-boin404re:FILE-NAME = "inbo/boin404re.p":U THEN DO:
                DELETE PROCEDURE h-boin404re.
                ASSIGN h-boin404re = ?.
            END.

            IF  VALID-HANDLE(h-boin176) THEN DO:
                RUN destroy IN h-boin176.
                DELETE PROCEDURE h-boin176 NO-ERROR.
                ASSIGN h-boin176 = ?.
            END.

        end.
    END.
    ELSE DO:
        /* Verifica se o documento foi gerado pelo f°sico. */
        for first doc-fisico where 
                  doc-fisico.serie-docto  = c-serie-docto and 
                  doc-fisico.nro-docto    = c-nro-docto and 
                  doc-fisico.cod-emitente = i-cod-emitente and 
                  doc-fisico.tipo-nota    = i-tipo-nota and 
                  doc-fisico.dt-emissao   = da-emissao no-lock,
            first bf{&TableName} exclusive-lock
            where bf{&TableName}.cod-estabel   =  doc-fisico.cod-estabel
            and   bf{&TableName}.serie-docto   =  doc-fisico.serie-docto
            and   bf{&TableName}.nro-docto     =  doc-fisico.nro-docto
            and   bf{&TableName}.cod-emitente  =  doc-fisico.cod-emitente
            and   bf{&TableName}.idi-orig-trad =  2:
        end.

        /* Quando o documento fisico Ç atualizado, o saldo Ç abatido da **
        ** quantidade total da ordem, portanto nao deve realocar nada.  */
        if avail bf{&TableName} then
            assign bf{&TableName}.idi-situacao = 7. /*  Atualizada Receb. F°sico */
        else do:
            /** Se agregado/acabado, Ç preciso buscar pela chave do documento **/
            FOR FIRST movto-pend
                WHERE movto-pend.cod-emitente = i-cod-emitente
                  AND movto-pend.serie-comp   = c-serie-docto
                  AND movto-pend.nro-comp     = c-nro-docto
                  AND movto-pend.nat-comp     = c-nat-operacao NO-LOCK:

                FOR FIRST bf{&TableName} EXCLUSIVE-LOCK
                    WHERE bf{&TableName}.ch-acesso-comp-nfe = movto-pend.cod-chave-aces-nf-eletro
                    AND   bf{&TableName}.idi-orig-trad = 2:
                    ASSIGN bf{&TableName}.idi-situacao = 1. /* Digitada recebimento fiscal */
                END.
            END.
        end.
    END.

    /* Evento cancelamento */
    IF AVAIL bf{&TableName} 
    AND bf{&TableName}.idi-situacao = 4 /* Eliminada Recebimento */ THEN DO:         
        FOR FIRST event-nfe-cte FIELDS(idi-sit-event) EXCLUSIVE-LOCK
            WHERE event-nfe-cte.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
              AND event-nfe-cte.idi-tip-docto    = 1   /*1-) 367-NF-E*/
              AND event-nfe-cte.idi-sit-event    = 1 /* Pendente */ :

            RUN cancelaDocumento(INPUT ROWID(bf{&TableName}), ?).
            IF RETURN-VALUE = "OK":U THEN DO:
                ASSIGN event-nfe-cte.idi-sit-event = 2. /* processado */

                /* Mensagem a ser mostrada no browse de informaÁıes do conversor */
                {utp/ut-liter.i NF-e_foi_cancelada *}                
                RUN implantaErroConfCadastroMsg(INPUT event-nfe-cte.ch-acesso-comp-nfe,
                                                INPUT 54213,  /* Mensagem: NF-e foi cancelada devido a recepá∆o do XML de cancelamento. */
                                                INPUT RETURN-VALUE,
                                                INPUT 4). /* Informacao */  
            END.
        END.    
    END.
    RELEASE bf{&TableName}.

    IF CAN-FIND(FIRST msg-ret-nfe 
                WHERE msg-ret-nfe.ch-acesso-comp-nfe = c-chave-comp-nfe
                  AND msg-ret-nfe.idi-orig-trad      = 2 
                  AND msg-ret-nfe.log-ativo
                  AND msg-ret-nfe.cd-msg             = 5168) /* Nota rejeitada pela Sefaz */ THEN
        RUN inutilizaNFE(INPUT c-chave-comp-nfe,
                         INPUT YES).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inutilizaNFE DBOProgram 
PROCEDURE inutilizaNFE :
/*------------------------------------------------------------------------------
  Purpose:  
  Inutiliza NFE.
    
  Parameters: 
  c-chave-comp-nfe: Chave de acesso 
  l-desaloca      : Desaloca saldos
  i-situacao      : Situaá∆o para qual o documento ser† atualizado
  
  Notes: Documento com Origem Traduzido (2)
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM c-chave-comp-nfe LIKE doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAM l-desaloca       AS LOGICAL                           NO-UNDO.

    /* Busca pela chave eletrìnica. */
    FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
         WHERE bf{&TableName}.ch-acesso-comp-nfe = c-chave-comp-nfe
           AND bf{&TableName}.idi-orig-trad        = 2 NO-ERROR.

    IF AVAIL bf{&TableName} THEN DO:
        /* Desaloca o saldo alocado pelo Conversor */
        IF l-desaloca THEN DO: 

            IF NOT VALID-HANDLE(h-boin857) THEN
                RUN inbo/boin857.p PERSISTENT SET h-boin857.

            IF NOT VALID-HANDLE(h-boin404re) THEN
                RUN inbo/boin404re.p PERSISTENT SET h-boin404re.

            IF CAN-FIND(FIRST rat-ordem-orig-nfe 
                        WHERE rat-ordem-orig-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe)
            AND NOT VALID-HANDLE(h-reapi401) THEN
                RUN rep/reapi401.p PERSISTENT SET h-reapi401.
            
            FOR EACH item-doc-orig-nfe OF bf{&TableName} EXCLUSIVE-LOCK
               WHERE item-doc-orig-nfe.idi-orig-trad = 2:

                /* Desalocar o saldo das ordens de compra. */
                IF VALID-HANDLE(h-boin857) THEN DO:

                    IF item-doc-orig-nfe.numero-ordem <> 0 THEN DO:
                        
                        /* Posiciona a ordem de compra na BO. */
                        RUN findOrdemCompra     IN h-boin857(INPUT  item-doc-orig-nfe.numero-ordem).
                        RUN validaContratoOrdem IN h-boin857(OUTPUT l-contrato,
                                                             OUTPUT i-total).
                        IF i-total = 0 THEN
                            RUN pi-aloca-ordem-cc IN h-boin857(INPUT NO, /* Desaloca. */
                                                               INPUT item-doc-orig-nfe.numero-ordem,
                                                               INPUT item-doc-orig-nfe.parcela,
                                                               INPUT item-doc-orig-nfe.qtd-interna).
                         ASSIGN item-doc-orig-nfe.num-pedido   = 0
                                item-doc-orig-nfe.numero-ordem = 0
                                item-doc-orig-nfe.parcela      = 0
                                item-doc-orig-nfe.encerra-pa   = NO.
                    END.
                    ELSE /* Desaloca e Limpa a tabela rat-ordem-orig-nfe */
                        IF VALID-HANDLE(h-reapi401) THEN
                            RUN piLimpaRatOrdemOrigNfe IN h-reapi401(INPUT item-doc-orig-nfe.ch-acesso-comp-nfe,
                                                                     INPUT item-doc-orig-nfe.seq-item,
                                                                     INPUT-OUTPUT h-boin857).
                END.

                FOR EACH item-ref-nfe EXCLUSIVE-LOCK
                   WHERE item-ref-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                     AND item-ref-nfe.seq-item           = item-doc-orig-nfe.seq-item:
                    
                    /* Desalocar o saldo das referencias. */
                    IF VALID-HANDLE(h-boin404re) THEN
                        RUN alocaSaldoTerc IN h-boin404re(INPUT NO,
                                                          INPUT item-ref-nfe.qtd-alocada,
                                                          INPUT item-ref-nfe.seq-saldo-terc,
                                                          INPUT item-ref-nfe.cod-emitente,
                                                          INPUT item-ref-nfe.nro-docto,
                                                          INPUT item-ref-nfe.serie-docto,
                                                          INPUT item-doc-orig-nfe.nat-operacao, /* Natureza do item. */
                                                          INPUT item-ref-nfe.nat-operacao,      /* Natureza do saldo em terceiros. */
                                                          INPUT item-ref-nfe.it-codigo).
                    DELETE item-ref-nfe.
                END.
            END.

            IF  VALID-HANDLE(h-boin857) THEN DO:
                DELETE PROCEDURE h-boin857.
                ASSIGN h-boin857 = ?.
            END.
            IF  VALID-HANDLE(h-boin404re) THEN DO:
                DELETE PROCEDURE h-boin404re.
                ASSIGN h-boin404re = ?.
            END.
            IF  VALID-HANDLE(h-reapi401) THEN DO:
                DELETE PROCEDURE h-reapi401 NO-ERROR.
                ASSIGN h-reapi401 = ?.
            END.
        END.

        ASSIGN bf{&TableName}.idi-situacao = 8. /* Inutilizada */

    END.

    RELEASE bf{&TableName}.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaSituacaoPelaChaveDeAcesso DBOProgram 
PROCEDURE atualizaSituacaoPelaChaveDeAcesso :
/*------------------------------------------------------------------------------
  Purpose:  
  Atualiza a situaá∆o do Documento Origem Nota Entrada para a situaá∆o passada como parÉmetro.
    
  Parameters:  
  c-chave-comp-nfe: Chave de acesso completa da NFe
  c-serie-docto:    SÇrie do Documento
  c-nro-docto:      N£mero do Documento
  i-cod-emitente:   C¢digo do Emitente
  c-nat-operacao:   Natureza de operaá∆o
  i-situacao:       Situaá∆o para a qual o documento deve ser atualizado.

  
  Notes: S¢ atualiza o documento se a Origem do mesmo for Traduzido (2)      
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM c-chave-comp-nfe LIKE doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAM c-serie-docto    LIKE doc-orig-nfe.serie-docto        NO-UNDO.
    DEFINE INPUT PARAM c-nro-docto      LIKE doc-orig-nfe.nro-docto          NO-UNDO.
    DEFINE INPUT PARAM i-cod-emitente   LIKE doc-orig-nfe.cod-emitente       NO-UNDO.
    DEFINE INPUT PARAM c-nat-operacao   LIKE docum-est.nat-operacao          NO-UNDO.
    DEFINE INPUT PARAM c-estabel        LIKE docum-est.cod-estabel           NO-UNDO.
    DEFINE INPUT PARAM i-situacao       AS INTEGER                           NO-UNDO.


    find first bf{&TableName} exclusive-lock 
        where  bf{&TableName}.ch-acesso-comp-nfe = c-chave-comp-nfe
        and    bf{&TableName}.idi-orig-trad  =  2 no-error.
       
    IF NOT AVAIL bf{&TableName} THEN DO:
        /* Se a nota for digitada manualmente, a chave pode divergir */
        if trim(c-serie-docto) = "" THEN DO:
            find first bf{&TableName} exclusive-lock 
                where bf{&TableName}.cod-emitente  = i-cod-emitente
                and   bf{&TableName}.cod-estabel   = c-estabel 
                and   bf{&TableName}.nro-docto     = c-nro-docto
                and   bf{&TableName}.idi-orig-trad = 2
                and   bf{&TableName}.serie-docto   < "1" no-error.
        END.
        ELSE DO:
            find first bf{&TableName} exclusive-lock 
                where bf{&TableName}.cod-emitente  = i-cod-emitente
                and   bf{&TableName}.cod-estabel   = c-estabel
                and   bf{&TableName}.serie-docto   = c-serie-docto
                and   bf{&TableName}.nro-docto     = c-nro-docto
                and   bf{&TableName}.idi-orig-trad = 2 no-error.
        END.

        FOR FIRST movto-pend
            WHERE movto-pend.cod-emitente = i-cod-emitente
              AND movto-pend.serie-comp   = c-serie-docto
              AND movto-pend.nro-comp     = c-nro-docto
              AND movto-pend.nat-comp     = c-nat-operacao NO-LOCK:
            FOR FIRST bf{&TableName} EXCLUSIVE-LOCK
                WHERE bf{&TableName}.ch-acesso-comp-nfe = movto-pend.cod-chave-aces-nf-eletro
                  AND bf{&TableName}.idi-orig-trad = 2:
            END.
        END.
    END.

    IF AVAIL bf{&TableName} THEN DO:
        ASSIGN bf{&TableName}.idi-situacao = i-situacao.

        DEFINE VARIABLE i-nivel AS INTEGER     NO-UNDO.

        /* Se foi incluido pelo RE1001H1, desaloca o saldo da OC. */
        REPEAT WHILE PROGRAM-NAME(i-nivel) <> ?:
            IF PROGRAM-NAME(i-nivel) MATCHES "*re1001h1*":U THEN DO:
            
                if not valid-handle(h-boin857) 
                or h-boin857:type      <> "PROCEDURE":U 
                or h-boin857:file-name <> "inbo/boin857.p":U then
                    run inbo/boin857.p persistent set h-boin857.
                
                for each item-doc-orig-nfe of bf{&TableName} exclusive-lock
                    where item-doc-orig-nfe.idi-orig-trad = 2:
    
                    /* Somente desaloca dos itens que pertencem a nota digitada, **
                    ** para evitar desalocacoes indevidas por causa da quebra de **
                    ** documento por natureza.                                   */
                    if item-doc-orig-nfe.nat-operacao <> c-nat-operacao then
                        next.
    
                    /* Desalocar o saldo das ordens de compra. */
                    if valid-handle(h-boin857) then do:
    
                        if  item-doc-orig-nfe.numero-ordem <> 0 then do:
                            
                            /* Posiciona a ordem de compra na BO. */
                            run findOrdemCompra in h-boin857 (input item-doc-orig-nfe.numero-ordem).
    
                            run validaContratoOrdem in h-boin857 (output l-contrato,
                                                                  output i-total    ).
                            if i-total = 0 then
                                run pi-aloca-ordem-cc in h-boin857 (input no, /* Desaloca. */
                                                                    input item-doc-orig-nfe.numero-ordem,
                                                                    input item-doc-orig-nfe.parcela,
                                                                    input item-doc-orig-nfe.qtd-interna).
                        end.
                    end.
    
                    assign item-doc-orig-nfe.num-pedido   = 0
                           item-doc-orig-nfe.numero-ordem = 0
                           item-doc-orig-nfe.parcela      = 0
                           item-doc-orig-nfe.encerra-pa   = NO.
                end.
                
                IF  VALID-HANDLE(h-boin857)        AND
                    h-boin857:TYPE = "PROCEDURE":U AND
                    h-boin857:FILE-NAME = "inbo/boin857.p":U THEN DO:
                    DELETE PROCEDURE h-boin857.
                    ASSIGN h-boin857 = ?.
                END.
            END.

            ASSIGN i-nivel = i-nivel + 1.
        end.
    END.

    RELEASE bf{&TableName}.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE baixaSaldoOrdem DBOProgram 
PROCEDURE baixaSaldoOrdem :
/*------------------------------------------------------------------------------
  Purpose: Desaloca o saldo para a boin176 alocar o saldo corretamente.
  Parameters: 
  
  pl-aloca:        Indica se ir† alocar ou desalocar a quantidade
  pi-numero-ordem: N£mero da ordem de compra
  pi-parcela:      N£mero da parcela
  pde-quantidade:  Quantidade a ser alocada/desalocada
   
  Notes:       
------------------------------------------------------------------------------*/
    define input param pl-aloca         as logical no-undo.
    define input param pi-numero-ordem  as integer no-undo.
    define input param pi-parcela       as integer no-undo.
    define input param pde-quantidade   as decimal no-undo.

    IF not valid-handle(h-boin857) OR h-boin857:file-name <> "inbo/boin857.p":U THEN
        RUN inbo/boin857.p PERSISTENT SET h-boin857.

    run validaContratoOrdem in h-boin857 (output l-contrato,
                                          output i-total   ).

    if i-total = 0 and pi-numero-ordem <> 0 then
        /* Desaloca a quantidade para a ordem. */
        run pi-aloca-ordem-cc in h-boin857 (input pl-aloca,
                                            input pi-numero-ordem,
                                            input pi-parcela,
                                            input pde-quantidade).
        
    IF  VALID-HANDLE(h-boin857)        AND
        h-boin857:TYPE = "PROCEDURE":U AND
        h-boin857:FILE-NAME = "inbo/boin857.p":U THEN DO:
        DELETE PROCEDURE h-boin857.
        ASSIGN h-boin857 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaNaturezaOperacao DBOProgram 
PROCEDURE buscaNaturezaOperacao :
/*------------------------------------------------------------------------------
 Purpose: 
 Notes:
------------------------------------------------------------------------------*/    
    DEFINE INPUT  PARAMETER pchave-acesso  LIKE doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE OUTPUT PARAM c-nat-oper         LIKE item-doc-orig-nfe.nat-operacao  NO-UNDO.
    
    FOR EACH doc-orig-nfe FIELDS() NO-LOCK 
       WHERE doc-orig-nfe.ch-acesso-comp-nfe = pchave-acesso
         AND doc-orig-nfe.idi-orig-trad      = 2: 
        FOR EACH item-doc-orig-nfe FIELDS(nat-operacao) 
              OF doc-orig-nfe NO-LOCK:  
            IF item-doc-orig-nfe.nat-operacao <> "" THEN
                ASSIGN c-nat-oper = item-doc-orig-nfe.nat-operacao.
            LEAVE.  
        END.
    END.  
     
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelaDocumento DBOProgram 
PROCEDURE cancelaDocumento :
/*------------------------------------------------------------------------------
  Purpose: Cancela o documento    
  Parameters:  pr-nota: Rowid da nota a ser cancelada
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pr-nota  AS ROWID    NO-UNDO.
    DEFINE INPUT  PARAMETER c-motivo AS CHAR     NO-UNDO.

    FOR FIRST bf{&TableName} FIELDS (ch-acesso-comp-nfe nro-docto)
        WHERE ROWID(bf{&TableName}) = pr-nota NO-LOCK:
    END.
    IF AVAIL bf{&TableName} THEN DO:
        /** CRIA MENSAGEM NOTIFICANDO QUE A NF FOI CANCELADA **/
        FOR EACH msg-ret-nfe FIELDS (seq-msg) NO-LOCK
           WHERE msg-ret-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
             AND msg-ret-nfe.idi-orig-trad      = 2
             AND msg-ret-nfe.log-ativo:

            FOR FIRST bfmsg-ret-nfe EXCLUSIVE-LOCK
                WHERE bfmsg-ret-nfe.seq-msg    = msg-ret-nfe.seq-msg
                  AND bfmsg-ret-nfe.cd-msg    <> 52843: // nao jogar para historico a mensagem de consulta que retornou que est· cancelada, isso ja eh o motivo do cancelamento
                ASSIGN bfmsg-ret-nfe.log-ativo = NO.
            END.
            RELEASE bfmsg-ret-nfe.
        END.

        RUN implantaErroConfCadastroMsg (INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                         INPUT 19531,
                                         INPUT "" + "~~" + "" + "~~" + bf{&TableName}.nro-docto,
                                         INPUT 0).

        IF c-motivo <> ? AND TRIM(c-motivo) <> "" THEN DO:
            RUN implantaErroConfCadastroMsg (INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                             INPUT 57446,
                                             INPUT c-motivo,
                                             INPUT 0).
        END.
        RELEASE bfmsg-ret-nfe.
        /*****************/
    END.

    FOR FIRST bf{&TableName} 
        WHERE ROWID(bf{&TableName}) = pr-nota EXCLUSIVE-LOCK:
    END.
    IF AVAIL bf{&TableName} then do:
        if not valid-handle(h-boin857) 
        or h-boin857:type      <> "PROCEDURE":U 
        or h-boin857:file-name <> "inbo/boin857.p":U then
            run inbo/boin857.p persistent set h-boin857.
            
        if not valid-handle(h-boin404re) 
        or h-boin404re:type      <> "PROCEDURE":U 
        or h-boin404re:file-name <> "inbo/boin404re.p":U then
            run inbo/boin404re.p persistent set h-boin404re.

        IF CAN-FIND(FIRST rat-ordem-orig-nfe 
                    WHERE rat-ordem-orig-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe)
        AND NOT VALID-HANDLE(h-reapi401) THEN
            RUN rep/reapi401.p PERSISTENT SET h-reapi401.

        for each item-doc-orig-nfe exclusive-lock
           where item-doc-orig-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
             and item-doc-orig-nfe.idi-orig-trad      = 2:

            for each item-ref-nfe exclusive-lock
                where item-ref-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                and   item-ref-nfe.seq-item           = item-doc-orig-nfe.seq-item:
            
                /* Desaloca o saldo em poder de terceiros e deleta as referàncias. */
                run alocaSaldoTerc IN h-boin404re (input no,
                                                   input item-ref-nfe.qtd-alocada,
                                                   input item-ref-nfe.seq-saldo-terc,
                                                   input item-ref-nfe.cod-emitente,
                                                   input item-ref-nfe.nro-docto,
                                                   input item-ref-nfe.serie-docto,
                                                   input item-doc-orig-nfe.nat-operacao,
                                                   input item-ref-nfe.nat-operacao,
                                                   input item-ref-nfe.it-codigo).

                delete item-ref-nfe.
            end.

            IF item-doc-orig-nfe.numero-ordem > 0 THEN DO:

                run validaContratoOrdem in h-boin857 (output l-contrato,
                                                      output i-total   ).
                if i-total = 0 then
                /* Desaloca a quantidade para a ordem. */
                run pi-aloca-ordem-cc in h-boin857 (input no,
                                                    input item-doc-orig-nfe.numero-ordem,
                                                    input item-doc-orig-nfe.parcela,
                                                    input item-doc-orig-nfe.qtd-interna).
                
                assign item-doc-orig-nfe.num-pedido   = 0
                       item-doc-orig-nfe.numero-ordem = 0
                       item-doc-orig-nfe.parcela      = 0
                       item-doc-orig-nfe.encerra-pa   = NO.
            END.
            ELSE /* Limpa a tabela rat-ordem-orig-nfe e desaloca. */
                IF VALID-HANDLE(h-reapi401) THEN
                    RUN piLimpaRatOrdemOrigNfe IN h-reapi401(INPUT item-doc-orig-nfe.ch-acesso-comp-nfe,
                                                             INPUT item-doc-orig-nfe.seq-item,
                                                             INPUT-OUTPUT h-boin857).
        end.

        IF  VALID-HANDLE(h-boin857)        AND
            h-boin857:TYPE = "PROCEDURE":U AND
            h-boin857:FILE-NAME = "inbo/boin857.p":U THEN DO:
            DELETE PROCEDURE h-boin857.
            ASSIGN h-boin857 = ?.
        END.

        IF  VALID-HANDLE(h-boin404re)        AND
            h-boin404re:TYPE = "PROCEDURE":U AND
            h-boin404re:FILE-NAME = "inbo/boin404re.p":U THEN DO:
            DELETE PROCEDURE h-boin404re.
            ASSIGN h-boin404re = ?.
        END.

        IF  VALID-HANDLE(h-reapi401) THEN DO:
            DELETE PROCEDURE h-reapi401 NO-ERROR.
            ASSIGN h-reapi401 = ?.
        END.

        ASSIGN bf{&TableName}.idi-situacao = 5 /** CANCELADA **/.
    end.
    RELEASE bf{&TableName}.

    /****** PONTO UPC COFCO *******/
    IF c-nom-prog-dpc-mg97  <> ""
    OR c-nom-prog-upc-mg97  <> ""
    OR c-nom-prog-appc-mg97 <> "" THEN DO:
    
        EMPTY TEMP-TABLE tt-epc.
    
        {include/i-epc200.i2 &CodEvent       = "'afterCancelaDocumento'"
                             &CodParameter   = "'rowid-doc-orig-nfe'"
                             &ValueParameter =  STRING(pr-nota)}
                             
        /*** Chamada do programa EPC ***/
        {include/i-epc201.i  "afterCancelaDocumento" }
    END.
    /*****************************/

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaItemNotaDevolFisico DBOProgram 
PROCEDURE criaItemNotaDevolFisico :
/*------------------------------------------------------------------------------
  Purpose: Cria itens da nota de devolucao de cliente de acordo com o RE2001
  Parameters: 
  Notes: Procedure construida com base no programa cd5327, chamado pelo mÇtodo
  pi-add-browse do b10in163.
------------------------------------------------------------------------------*/
    
    /* Ao entrar nesta procedure, a it-nota-fisc j† deve estar posicionada. */
    
    ASSIGN de-indice = 1.
    
    FOR FIRST item-fornec FIELDS(fator-conver num-casa-dec)
        WHERE item-fornec.cod-emitente = bf{&tablename}.cod-emitente 
          AND item-fornec.it-codigo    = item-doc-orig-nfe.it-codigo 
          AND item-fornec.ativo NO-LOCK:
        ASSIGN de-indice = item-fornec.fator-conver / EXP(10,item-fornec.num-casa-dec).
    END.

    /* Posiciona o item corrente. */
    for first item no-lock
        where item.it-codigo = item-doc-orig-nfe.it-codigo:
    end.

    /* Adaptar para o conversor. */
    create tt-it-doc-fisico.
    assign tt-it-doc-fisico.sequencia      = i-seq-item
           tt-it-doc-fisico.nro-docto      = bf{&TableName}.nro-docto
           tt-it-doc-fisico.serie-docto    = bf{&TableName}.serie-docto
           tt-it-doc-fisico.cod-emitente   = bf{&TableName}.cod-emitente
           tt-it-doc-fisico.tipo-nota      = 2 /* Devolucao de Cliente. */
           tt-it-doc-fisico.it-codigo      = item-doc-orig-nfe.it-codigo
           tt-it-doc-fisico.cod-refer      = item-doc-orig-nfe.cod-refer
           tt-it-doc-fisico.fifo-oc        = l-fifo-oc 
           tt-it-doc-fisico.nr-ord-produ   = item-doc-orig-nfe.nr-ord-produ
           tt-it-doc-fisico.num-pedido     = item-doc-orig-nfe.num-pedido
           tt-it-doc-fisico.numero-ordem   = item-doc-orig-nfe.numero-ordem
           tt-it-doc-fisico.parcela        = item-doc-orig-nfe.parcela
           tt-it-doc-fisico.encerra-pa     = IF item-doc-orig-nfe.encerra-pa = ? THEN NO ELSE item-doc-orig-nfe.encerra-pa
           tt-it-doc-fisico.serie-comp     = item-ref-nfe.serie-docto
           tt-it-doc-fisico.nro-comp       = item-ref-nfe.nro-docto
           tt-it-doc-fisico.nat-comp       = item-ref-nfe.nat-operacao
           tt-it-doc-fisico.seq-comp       = item-ref-nfe.seq-saldo-terc
           tt-it-doc-fisico.reabre-pd      = item-ref-nfe.reabre-pd
           tt-it-doc-fisico.un             = unid-item-doc-est
           tt-it-doc-fisico.dt-vali-lote   = item-doc-orig-nfe.dt-vali-lote
           tt-it-doc-fisico.quantidade     = item-ref-nfe.qtd-alocada
           tt-it-doc-fisico.qt-do-forn     = IF AVAIL ITEM AND ITEM.fraciona THEN ( item-ref-nfe.qtd-alocada * de-indice ) 
                                             ELSE ROUND((item-ref-nfe.qtd-alocada * de-indice),0)
           tt-it-doc-fisico.preco-unit     = round(item-doc-orig-nfe.preco-unit, 5)
           tt-it-doc-fisico.preco-total    = round(item-doc-orig-nfe.preco-unit, 5) * tt-it-doc-fisico.qt-do-forn
           tt-it-doc-fisico.desconto       = if item-doc-orig-nfe.vl-desconto = ? then 0 else item-doc-orig-nfe.vl-desconto
           tt-it-doc-fisico.num-seq-event  = item-doc-orig-nfe.int-1 /* EVENTO - Adicionado para correá∆o da validacao de valor. */
           tt-it-doc-fisico.vl-frete       = de-frete-item
           tt-it-doc-fisico.despesas       = de-despesa-item + de-frete-item
           i-seq-item                      = i-seq-item + if param-re.inc-seq > 0 then param-re.inc-seq else 10
           i-num-pedido                    = item-doc-orig-nfe.num-pedido
           tt-it-doc-fisico.cod-depos      = item-doc-orig-nfe.cod-depos
           tt-it-doc-fisico.cod-localiz    = item-doc-orig-nfe.cod-localiz
           tt-it-doc-fisico.cod-refer      = item-doc-orig-nfe.cod-refer
           tt-it-doc-fisico.lote           = item-doc-orig-nfe.lote-serie
           tt-it-doc-fisico.dt-vali-lote   = item-doc-orig-nfe.dt-vali-lote
           tt-it-doc-fisico.narrativa      = item-doc-orig-nfe.narrativa
           OVERLAY(tt-it-doc-fisico.char-2,42,5) = STRING(item-doc-orig-nfe.seq-item)
           tt-it-doc-fisico.ind-bem-movel-usado = IF lNT2024002 THEN item-doc-orig-nfe.ind-bem-movel-usado ELSE NO
           tt-it-doc-fisico.log-doacao = IF lNT2024002 THEN item-doc-orig-nfe.log-doacao ELSE NO

           /* Informacoes da nota de sa°da. */
           tt-it-doc-fisico.nr-pd-seq      = it-nota-fisc.nr-seq-ped
           tt-it-doc-fisico.nr-pedcli      = it-nota-fisc.nr-pedcli
           tt-it-doc-fisico.data-comp      = it-nota-fisc.dt-emis-nota
           tt-it-doc-fisico.peso-liquido   = it-nota-fisc.peso-liq-fat
           tt-it-doc-fisico.baixa-ce       = it-nota-fisc.baixa-estoq
           tt-it-doc-fisico.log-2          = it-nota-fisc.ind-icm-ret.
           
    /** Atualiza narrativa **/
    for first nar-it-nota fields (narrativa) no-lock 
        where nar-it-nota.cod-estabel   = it-nota-fisc.cod-estabel
        and   nar-it-nota.serie         = it-nota-fisc.serie
        and   nar-it-nota.nr-nota-fis   = it-nota-fisc.nr-nota-fis
        and   nar-it-nota.nr-sequencia  = it-nota-fisc.nr-seq-fat 
        and   nar-it-nota.it-codigo     = it-nota-fisc.it-codigo: 
        assign tt-it-doc-fisico.narrativa = IF tt-it-doc-fisico.narrativa <> "" THEN 
                                               (tt-it-doc-fisico.narrativa + " | " + nar-it-nota.narrativa) 
                                            ELSE nar-it-nota.narrativa. 
    end.


    /* CRIACAO DE CONTROLE DE SERIAIS MANTIDA PELA COMPATIBILIDADE COM O CDP/CD5327. */
   find first funcao no-lock
       where funcao.cd-funcao = "spp-seriais-nf":U 
       and   funcao.ativo     = yes                 no-error.
   if avail funcao then do:
        for each  it-nota-fisc-serial no-lock
            where it-nota-fisc-serial.cod-estab       = it-nota-fisc.cod-estabel
            and   it-nota-fisc-serial.cod-serie       = it-nota-fisc.serie
            and   it-nota-fisc-serial.cod-nota-fisc   = it-nota-fisc.nr-nota-fis
            and   it-nota-fisc-serial.num-seq-item-nf = it-nota-fisc.nr-seq-fat
            and   it-nota-fisc-serial.cod-item        = it-nota-fisc.it-codigo:

            if not can-find(first it-doc-fisico-serial
                            where it-doc-fisico-serial.cod-ser-docto = tt-it-doc-fisico.serie-docto
                            and   it-doc-fisico-serial.cod-docto     = tt-it-doc-fisico.nro-docto
                            and   it-doc-fisico-serial.cdn-emitente  = tt-it-doc-fisico.cod-emitente
                            and   it-doc-fisico-serial.idi-tip-nf    = tt-it-doc-fisico.tipo-nota
                            and   it-doc-fisico-serial.num-seq       = tt-it-doc-fisico.sequencia
                            and   it-doc-fisico-serial.cod-serial    = it-nota-fisc-serial.cod-serial)
                and can-find(first item-dist
                             where item-dist.it-codigo = it-nota-fisc-serial.cod-item
                             and   item-dist.log-1     = yes)
                and can-find(first serial-faturam
                             where serial-faturam.cod-serial        = it-nota-fisc-serial.cod-serial
                             and   serial-faturam.idi-estado-serial = 2) then do:

                create it-doc-fisico-serial.
                assign it-doc-fisico-serial.cod-ser-docto = tt-it-doc-fisico.serie-docto
                       it-doc-fisico-serial.cod-docto     = tt-it-doc-fisico.nro-docto
                       it-doc-fisico-serial.cdn-emitente  = tt-it-doc-fisico.cod-emitente
                       it-doc-fisico-serial.idi-tip-nf    = tt-it-doc-fisico.tipo-nota
                       it-doc-fisico-serial.num-seq       = tt-it-doc-fisico.sequencia
                       it-doc-fisico-serial.cod-serial    = it-nota-fisc-serial.cod-serial. 
            end.
        end.
    end.

    /* Sugestao ct-codigo e sc-codigo de acordo com o cdp/cd5327. */
    if  item.tipo-contr = 4 /* Debito Direto. */
    or  item.tipo-contr = 1 then do: /* Fisico. */
    
        /* Posicionar o item. */
        if  it-nota-fisc.ct-cuscon = " " THEN
            assign tt-it-doc-fisico.ct-codigo      = item.ct-codigo 
                   tt-it-doc-fisico.sc-codigo      = item.sc-codigo.
        ELSE
            assign tt-it-doc-fisico.ct-codigo = it-nota-fisc.ct-cuscon
                   tt-it-doc-fisico.sc-codigo = it-nota-fisc.sc-cuscon.
    end.

    /* Posiciona o item para buscar a conta de aplicaá∆o.   **
    ** A conta de aplicaá∆o do item Ç a £ltima na ordem     **
    ** de prioridade para sugest∆o de ct-codigo.       */
    find first item no-lock
         where item.it-codigo = item-doc-orig-nfe.it-codigo no-error.
    if avail item 
    and tt-it-doc-fisico.ct-codigo = "" then
        assign tt-it-doc-fisico.ct-codigo = item.ct-codigo
               tt-it-doc-fisico.sc-codigo = ITEM.sc-codigo.

    /* Se nao sugeriu por nenhuma das logicas acima, leva a ct-codigo do conversor. */
    if trim(tt-it-doc-fisico.ct-codigo) = "" then
        assign tt-it-doc-fisico.ct-codigo = item-doc-orig-nfe.ct-codigo
               tt-it-doc-fisico.sc-codigo = item-doc-orig-nfe.sc-codigo.
    /** Unidade de Neg¢cio **/
    if  tt-it-doc-fisico.ct-codigo <> "" 
    AND tt-it-doc-fisico.sc-codigo <> "" then
        assign tt-it-doc-fisico.cod-unid-negoc = it-nota-fisc.cod-unid-negoc.

    /* Mantem a sugestao da nota de saida, se for utilizada. */
    if  l-mat-unid-negoc 
    and tt-it-doc-fisico.cod-unid-negoc = "" then do:
        
        if  tt-it-doc-fisico.nr-ord-produ <> 0
        and l-unidade-negocio then do:
            for first ord-prod fields (nr-ord-produ cod-unid-negoc)
                where ord-prod.nr-ord-produ = tt-it-doc-fisico.nr-ord-produ no-lock:
                assign tt-it-doc-fisico.cod-unid-negoc = ord-prod.cod-unid-negoc.
            end.
        end.
        else do:
            /* Se a UN de negocio estiver em branco, sugere conforme a logica da viewer v05in163. */
            if  tt-doc-fisico.tipo-nota = 2 /* Devolucao */ then do:
        
                if not valid-handle(h-cdapi024) 
                    or h-cdapi024:type <> "PROCEDURE"
                    or h-cdapi024:file-name <> "cdp/cdapi024.p" then do:
                    run cdp/cdapi024.p persistent set h-cdapi024.
                end.
        
                if valid-handle(h-cdapi024) then
                    run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input  tt-doc-fisico.cod-estabel,
                                                                       input  tt-it-doc-fisico.it-codigo,
                                                                       input  "", /* cod-depos */
                                                                       output tt-it-doc-fisico.cod-unid-negoc).
                
                IF  VALID-HANDLE(h-cdapi024)        AND
                    h-cdapi024:TYPE = "PROCEDURE":U AND
                    h-cdapi024:FILE-NAME = "cdp/cdapi024.p":U THEN DO:
                    DELETE PROCEDURE h-cdapi024.
                    ASSIGN h-cdapi024 = ?.
                END.

            end.
        end.
    end.
    /** FIM - Unidade de Neg¢cio **/

    RETURN "OK":U.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaItemNotaRefer DBOProgram 
PROCEDURE criaItemNotaRefer :
/*------------------------------------------------------------------------------
  Purpose: Cria os itens da nota de retorno de terceiros apartir do componente de
          remessa.   
  Parameters:  <none>
  Notes: 
------------------------------------------------------------------------------*/
    def var l-dev-simb       as logical no-undo.
    def var de-indice-aux    as decimal no-undo.
    def var de-qtd-conv-aux  as decimal no-undo.
    def VAR de-despesas-item AS DECIMAL NO-UNDO.
    def VAR  de-indice       as decimal no-undo.
    
    assign de-qtd-conv-aux = IF AVAIL item-ref-nfe THEN item-ref-nfe.qtd-alocada ELSE item-doc-orig-nfe.qtd-comercial
           l-dev-simb      = {cdp/cd0066.i doc-orig-nfe.cod-estabel natur-oper}
        
    /* Faz o fator de conversao para calcular a quantidade do fornecedor. */
    IF  AVAIL item-ref-nfe
    AND item-doc-orig-nfe.qtd-interna <> item-doc-orig-nfe.qtd-comercial THEN
        FOR FIRST it-nota-fisc NO-LOCK
            WHERE it-nota-fisc.cod-estabel     = bf{&TableName}.cod-estabel
              AND it-nota-fisc.serie           = item-ref-nfe.serie-docto
              AND it-nota-fisc.nr-nota-fis     = item-ref-nfe.nro-docto
              AND it-nota-fisc.nr-seq-fat      = item-ref-nfe.seq-saldo-terc
              AND it-nota-fisc.it-codigo       = item-ref-nfe.it-codigo
              AND it-nota-fisc.qt-faturada[1] <> it-nota-fisc.qt-faturada[2],
            FIRST item FIELDS(fraciona)
            WHERE item.it-codigo = it-nota-fisc.it-codigo NO-LOCK:
            ASSIGN de-qtd-conv-aux = IF item.fraciona THEN
                                         (de-qtd-conv-aux * (it-nota-fisc.dec-ftconv-unest / EXP(10,it-nota-fisc.num-casa-dec-unest)))
                                     ELSE ROUND((de-qtd-conv-aux * (it-nota-fisc.dec-ftconv-unest / EXP(10,it-nota-fisc.num-casa-dec-unest))),0).
        END.
    IF AVAIL natur-oper AND natur-oper.terceiros AND natur-oper.tp-oper-terc = 4 /* Fat. Consignacao  */ THEN DO:

        FIND FIRST ITEM NO-LOCK
                    WHERE ITEM.it-codigo = item-doc-orig-nfe.it-codigo NO-ERROR.
       
                
        IF AVAIL ITEM THEN DO:

            {cdp/cd9950.i item.un
                          item-doc-orig-nfe.un-comercial
                          bf{&TableName}.cod-emitente}
            
            assign de-qtd-conv-aux = de-qtd-conv-aux * de-indice.

        END.
    END.
    
    /* S¢ ser∆o sugeridos os campos vazios. */
    create tt-item-doc-est.
    assign tt-item-doc-est.cod-emitente          = bf{&TableName}.cod-emitente 
           tt-item-doc-est.serie-docto           = bf{&TableName}.serie-docto
           tt-item-doc-est.nro-docto             = bf{&TableName}.nro-docto
           tt-item-doc-est.nat-operacao          = IF AVAIL tt-natureza THEN tt-natureza.nat-oper-agrup ELSE natur-oper.nat-operacao /* Pode ser a nat agrup ou nat oper (Usa múlti. natur ou nío) */
           tt-item-doc-est.sequencia             = i-seq-item                     
           i-seq-item                            = i-seq-item + if param-re.inc-seq > 0 then param-re.inc-seq else 10
           tt-item-doc-est.it-codigo             = item-doc-orig-nfe.it-codigo
           tt-item-doc-est.num-pedido            = item-doc-orig-nfe.num-pedido
           tt-item-doc-est.numero-ordem          = item-doc-orig-nfe.numero-ordem
           tt-item-doc-est.parcela               = item-doc-orig-nfe.parcela
           tt-item-doc-est.encerra-pa            = IF item-doc-orig-nfe.encerra-pa = ? THEN NO ELSE item-doc-orig-nfe.encerra-pa
           tt-item-doc-est.preco-unit[1]         = ROUND(item-doc-orig-nfe.preco-unit,5)
           tt-item-doc-est.un                    = unid-item-doc-est
           tt-item-doc-est.log-1                 = l-fifo-oc
           tt-item-doc-est.log-fifo-oc           = l-fifo-oc
           tt-item-doc-est.lote                  = item-doc-orig-nfe.lote-serie
           tt-item-doc-est.dt-vali-lote          = item-doc-orig-nfe.dt-vali-lote
           tt-item-doc-est.desconto[1]           = IF item-doc-orig-nfe.vl-desconto = ? THEN
                                                       (ROUND(( componente.desconto[1]  / componente.quantidade ), 5) * (IF AVAIL item-ref-nfe THEN item-ref-nfe.qtd-alocada ELSE item-doc-orig-nfe.qtd-interna))
                                                   ELSE ((item-doc-orig-nfe.vl-desconto / item-doc-orig-nfe.qtd-comercial) * de-qtd-conv-aux)
           tt-item-doc-est.ct-codigo             = componente.ct-codigo
           tt-item-doc-est.sc-codigo             = componente.sc-codigo                       
           tt-item-doc-est.narrativa             = IF item-doc-orig-nfe.narrativa <> "" THEN 
                                                       (item-doc-orig-nfe.narrativa + " | " + componente.narrativa) 
                                                   ELSE componente.narrativa
           tt-item-doc-est.cd-trib-ipi           = 0
           tt-item-doc-est.cd-trib-icm           = 0
           tt-item-doc-est.aliquota-ipi          = componente.aliquota-ipi
           tt-item-doc-est.aliquota-icm          = componente.aliquota-icm
           tt-item-doc-est.log-2                 = componente.log-2          /* Item possui ICMS Retido */
           tt-item-doc-est.pr-total-cmi          = if item-doc-orig-nfe.vl-frete = ? then 0 else item-doc-orig-nfe.vl-frete
           tt-item-doc-est.nat-of                = item-doc-orig-nfe.nat-operacao     /* Sempre grava a natureza fiscal (nat-of) */
           OVERLAY(tt-item-doc-est.char-2,832,5) = STRING(item-doc-orig-nfe.seq-item) /* Grava a sequencia do item do monitor nfe */
           tt-item-doc-est.reabre-pd             = IF AVAIL item-ref-nfe THEN item-ref-nfe.reabre-pd ELSE NO.
            
    /* Validaá∆o para os demais campos. */
    
    /** BUSCA PARCELA DA OC **/
    if  not avail item-ref-nfe
    and not item-doc-orig-nfe.log-fifo-oc 
    and item-doc-orig-nfe.parcela = 0 then do:
         /* Aloca na primeira parcela em aberto que ainda tenha saldo. */
        for first prazo-compra fields (quant-saldo dec-1 parcela)
            where prazo-compra.numero-ordem = item-doc-orig-nfe.numero-ordem
            and   prazo-compra.situacao     = 2 
            and   prazo-compra.dec-1        < prazo-compra.quant-saldo no-lock:
    
            assign tt-item-doc-est.parcela = prazo-compra.parcela.
        end.
        if not avail prazo-compra then do:
            /* Aloca na primeira parcela em aberto. */
            for first prazo-compra fields (quant-saldo dec-1 parcela)
                where prazo-compra.numero-ordem = item-doc-orig-nfe.numero-ordem
                and   prazo-compra.situacao     = 2 no-lock: 

                assign tt-item-doc-est.parcela = prazo-compra.parcela.
            end.
        end.
    end.

    /* Valida item-ref-nfe para saber de que forma dever∆o ser criados alguns campos da tt-item-doc-est. */
    if avail item-ref-nfe then do:

        assign tt-item-doc-est.qt-do-forn       =   de-qtd-conv-aux
               tt-item-doc-est.quantidade       =   item-ref-nfe.qtd-alocada
               tt-item-doc-est.preco-total[1]   =   ROUND(ROUND(item-doc-orig-nfe.preco-total / item-doc-orig-nfe.qtd-interna, 10) * tt-item-doc-est.quantidade,2)
               tt-item-doc-est.serie-comp       =   item-ref-nfe.serie-docto
               tt-item-doc-est.nro-comp         =   item-ref-nfe.nro-docto
               tt-item-doc-est.nat-comp         =   item-ref-nfe.nat-operacao 
               tt-item-doc-est.seq-comp         =   item-ref-nfe.seq-saldo-terc
               tt-item-doc-est.emite-comp       =   item-ref-nfe.cod-emitente.
        
        /* Alterado para evitar arredondamento para 0 com quantidades muito pequenas. */
        if  tt-item-doc-est.preco-total[1] = 0
        and item-doc-orig-nfe.preco-unit  <> 0 
        and item-ref-nfe.qtd-alocada      <> 0 then
            assign tt-item-doc-est.preco-total[1] = 0.01.

        if  natur-oper.log-oper-triang then
            assign tt-item-doc-est.serie-terc     = item-ref-nfe.serie-docto
                   tt-item-doc-est.nro-docto-terc = item-ref-nfe.nro-docto
                   tt-item-doc-est.nat-terc       = item-ref-nfe.nat-operacao
                   tt-item-doc-est.seq-terc       = item-ref-nfe.seq-saldo-terc
                   tt-item-doc-est.cod-emit-terc  = item-ref-nfe.cod-emitente.
        
        if item-doc-orig-nfe.cod-depos <> "" then
            assign tt-item-doc-est.cod-depos = item-doc-orig-nfe.cod-depos.
        else 
            assign tt-item-doc-est.cod-depos = saldo-terc.cod-depos.

        if saldo-terc.nr-ord-produ <> 0 then
            assign tt-item-doc-est.nr-ord-produ = saldo-terc.nr-ord-produ.
        else
            assign tt-item-doc-est.nr-ord-produ = item-doc-orig-nfe.nr-ord-produ.

        IF natur-oper.tp-oper-terc = 5 THEN DO: /*devolucao consignacao*/
       
            for first it-nota-fisc no-lock
                where it-nota-fisc.cod-estabel = bf{&TableName}.cod-estabel
                and   it-nota-fisc.serie       = item-ref-nfe.serie-docto
                and   it-nota-fisc.nr-nota-fis = item-ref-nfe.nro-docto
                and   it-nota-fisc.nr-seq-fat  = item-ref-nfe.seq-saldo-terc
                and   it-nota-fisc.it-codigo   = item-ref-nfe.it-codigo:

                RUN piBuscaPisCofins IN h-cdapi995 (INPUT  "it-nota-fisc",
                                                    INPUT  ROWID(it-nota-fisc),
                                                    INPUT  NO, /* n∆o recalcular e gravar quando j† existe na ext-it-nota-fisc */
                                                    INPUT  NO,
                                                    OUTPUT d-aliq-pis,
                                                    OUTPUT d-val-base-pis,
                                                    OUTPUT d-val-pis,
                                                    OUTPUT d-aliq-cofins,
                                                    OUTPUT d-val-base-cofins,
                                                    OUTPUT d-val-cofins).
                
                /**************************
                * PIS/COFINS POR UNIDADE *
                **************************/
            
                de-valor-un-pis-devol    = IF it-nota-fisc.idi-forma-calc-pis = 2 /* Pis Un Prod */
                                           THEN it-nota-fisc.val-unit-pis         /* Vl Unit Pis*/
                                           ELSE 0.
                de-valor-un-cofins-devol = IF it-nota-fisc.idi-forma-calc-cofins = 2 /* Pis Un Prod */
                                           THEN it-nota-fisc.val-unit-cofins         /* Vl Unit Pis*/
                                           ELSE 0. 
            
                IF de-valor-un-pis-devol <> 0 then
                    assign d-aliq-pis = 0.
            
                IF de-valor-un-cofins-devol <> 0 then
                    assign d-aliq-cofins = 0. 

            
                ASSIGN tt-item-doc-est.idi-tributac-pis    = int(substring(it-nota-fisc.char-2,96,1))  /* Tributacao PIS     */     
                       tt-item-doc-est.idi-tributac-cofins = int(substring(it-nota-fisc.char-2,97,1))  /* Tributacao COFINS  */     
                       tt-item-doc-est.val-aliq-pis        = d-aliq-pis    /* Aliquota PIS       */     
                       tt-item-doc-est.val-aliq-cofins     = d-aliq-cofins. /* Aliquota do COFINS */ 

                IF tt-item-doc-est.idi-tributac-pis  = 2 /*Isento*/ THEN DO:                                        
                    assign tt-item-doc-est.base-pis                = 0
                           tt-item-doc-est.val-base-calc-cofins    = 0.        
                END.
                            
                RUN grava-aliquotas IN h-cdapi995 (INPUT "item-doc-est",
                                                   INPUT tt-item-doc-est.serie-docto + "/" + 
                                                         tt-item-doc-est.nro-docto + "/" + 
                                                         string(tt-item-doc-est.cod-emitente) + "/" + 
                                                         tt-item-doc-est.nat-operacao + "/" + 
                                                         string(tt-item-doc-est.sequencia), 
                                                   INPUT d-aliq-pis, 
                                                   INPUT d-aliq-cofins).                                                  
            END.
        END.
    end.
    else
        assign tt-item-doc-est.qt-do-forn     = item-doc-orig-nfe.qtd-comercial
               tt-item-doc-est.quantidade     = item-doc-orig-nfe.qtd-interna
               tt-item-doc-est.preco-total[1] = item-doc-orig-nfe.preco-total
               tt-item-doc-est.nr-ord-produ   = item-doc-orig-nfe.nr-ord-produ
               tt-item-doc-est.cod-depos      = item-doc-orig-nfe.cod-depos.
        
    /* Preenchimento das despesas do item */
    assign de-despesas-item = 0.
    
    if item-doc-orig-nfe.vl-frete <> ? then 
        ASSIGN de-despesas-item = item-doc-orig-nfe.vl-frete.
    else 
        ASSIGN tt-item-doc-est.pr-total-cmi = truncate(((bf{&TableName}.valor-frete * round(item-doc-orig-nfe.preco-total, 5)) 
                                    / bf{&TableName}.valor-produto),2)
               de-despesas-item = tt-item-doc-est.pr-total-cmi.
    
    if item-doc-orig-nfe.vl-outros <> ? THEN 
        assign de-despesas-item = de-despesas-item + item-doc-orig-nfe.vl-outros.
    else if bf{&TableName}.valor-outros <> 0 THEN 
        assign de-despesas-item = de-despesas-item + truncate(((bf{&TableName}.valor-outros * tt-item-doc-est.preco-total[1]) 
                                                                        / bf{&TableName}.valor-produto),2).
        
    if item-doc-orig-nfe.vl-seguro <> ? then 
        assign de-despesas-item = de-despesas-item + item-doc-orig-nfe.vl-seguro.
    else if bf{&TableName}.valor-seguro <> 0 THEN 
        assign de-despesas-item = de-despesas-item + truncate(((bf{&TableName}.valor-seguro * tt-item-doc-est.preco-total[1]) 
                                                                          / bf{&TableName}.valor-produto),2).
        
    ASSIGN tt-item-doc-est.despesas[1]     = de-despesas-item.

    /* FIM - Preenchimento das despesas do item */

    if item-doc-orig-nfe.cod-refer <> "" then 
        assign tt-item-doc-est.cod-refer = item-doc-orig-nfe.cod-refer. 
    else 
        assign tt-item-doc-est.cod-refer = componente.cod-refer.
    
    if componente.ct-codigo <> "" then
        assign tt-item-doc-est.ct-codigo = componente.ct-codigo
               tt-item-doc-est.sc-codigo = componente.sc-codigo.
    else
        assign tt-item-doc-est.ct-codigo = item-doc-orig-nfe.ct-codigo
               tt-item-doc-est.sc-codigo = item-doc-orig-nfe.sc-codigo.
    
    if  natur-oper.tp-oper-terc = 4 /* Fat. Consignacao  */
    or  natur-oper.tp-oper-terc = 6 /* Reajuste de Preco */
    or  l-dev-simb then
        assign tt-item-doc-est.baixa-ce = no.
    else do:
        if natur-oper.transf then 
            assign tt-item-doc-est.baixa-ce = yes.
        else
            assign tt-item-doc-est.baixa-ce = componente.baixa-ce.
    end.
    
    if item-doc-orig-nfe.class-fiscal <> "" then
        assign tt-item-doc-est.class-fiscal = item-doc-orig-nfe.class-fiscal.
    else
        assign tt-item-doc-est.class-fiscal = componente.class-fiscal.

    if item-doc-orig-nfe.cod-localiz <> "" then
        assign tt-item-doc-est.cod-localiz = item-doc-orig-nfe.cod-localiz.
    else
        assign tt-item-doc-est.cod-localiz = saldo-terc.cod-localiz.
    
    if int(item-doc-orig-nfe.peso-liq) <> 0 then
        assign tt-item-doc-est.peso-liquido   = dec(string(item-doc-orig-nfe.peso-liq, ">>>>,>>9.99999")) no-error.
    else
        assign tt-item-doc-est.peso-liquido   = (tt-item-doc-est.quantidade * componente.peso-liquido) / componente.quantidade.
   
    /* Grava chave da reserva da ordem de produá∆o. */       
    if substr(componente.char-1,1,16) <> "" then
       assign tt-item-doc-est.item-pai    = substr(componente.char-1,1,16)
              tt-item-doc-est.cod-roteiro = substr(componente.char-1,17,16)
              tt-item-doc-est.op-codigo   = int(substr(componente.char-1,35,5)).
    else do:
        for first reservas fields (quant-orig quant-atend quant-terc nr-ord-produ
                                   it-codigo item-pai op-codigo cod-roteiro)
            where reservas.nr-ord-produ = tt-item-doc-est.nr-ord-produ
            and   reservas.quant-orig  > 0 no-lock:
            
            assign de-qtd-saldo = reservas.quant-orig - (reservas.quant-atend + reservas.quant-terc).
            
            if (natur-oper.tp-oper-terc = 4 or natur-oper.tp-oper-terc = 6)
            and de-qtd-saldo <= 0 then 
                next.
            else 
            assign tt-item-doc-est.item-pai    = reservas.item-pai   
                   tt-item-doc-est.cod-roteiro = reservas.cod-roteiro
                   tt-item-doc-est.op-codigo   = reservas.op-codigo.
        end.
    end.

    assign tt-item-doc-est.cod-unid-negoc = item-doc-orig-nfe.cod-unid-negoc WHEN l-mat-unid-negoc
           tt-item-doc-est.int-1          = item-doc-orig-nfe.int-1.

    IF  l-remessa-ent-futura = yes THEN 
        assign tt-item-doc-est.ct-codigo = ""
               tt-item-doc-est.sc-codigo = ""
               tt-item-doc-est.cod-unid-negoc = "".

    /* Zera a Ordem de Producao para notas de Faturamento de Consignacao e */
    /* Reajuste Preco. Quando  o  item nao possuir tipo de controle Fisico */ 
    /* ou Debito Direto a Conta de Aplicacao tambÇm sera zerada.           */
    for first item fields (tipo-contr) no-lock 
        where item.it-codigo = tt-item-doc-est.it-codigo:
    end.
    if  can-do("4,6", string(natur-oper.tp-oper-terc)) then do:
        
        assign tt-item-doc-est.nr-ord-produ = 0.
        /* Item com tipo de controle Total ou Consignado */
        if  can-do("2,3", string(item.tipo-contr)) then
            assign tt-item-doc-est.ct-codigo      = " "
                   tt-item-doc-est.sc-codigo      = " ".
    end.
    
    if tt-item-doc-est.nr-ord-produ <> 0 then do:
        for first ord-prod fields ( nr-ord-produ cod-estabel estado 
                                    ct-codigo sc-codigo nr-linha origem
                                    cod-unid-negoc /* Unidade de Neg¢cio */ )
            where ord-prod.nr-ord-produ = tt-item-doc-est.nr-ord-produ no-lock:
            assign tt-item-doc-est.ct-codigo      = ord-prod.ct-codigo
                   tt-item-doc-est.sc-codigo      = ord-prod.sc-codigo
                   tt-item-doc-est.cod-unid-negoc = ord-prod.cod-unid-negoc WHEN l-mat-unid-negoc.
        end.
    end.
    else do:
        if tt-item-doc-est.ct-codigo = componente.ct-codigo AND
           tt-item-doc-est.sc-codigo = componente.sc-codigo then
            assign tt-item-doc-est.cod-unid-negoc = componente.cod-unid-negoc WHEN l-mat-unid-negoc.
    end.

    /*Se for faturamento de consignaá∆o atualizar† sempre a unidade de neg¢cio com a unidade de neg¢cio 
    do saldo em poder de terceiros*/
    if  natur-oper.tp-oper-terc        = 4   /* Faturamento Consignaá∆o */
    and l-mat-unid-negoc
    and tt-item-doc-est.cod-unid-negoc = "" then 
        assign tt-item-doc-est.cod-unid-negoc = componente.cod-unid-negoc.

    RUN salvarDadosFCIItemRecebFiscal.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaItemNotaReferFisico DBOProgram 
PROCEDURE criaItemNotaReferFisico :
/*------------------------------------------------------------------------------
  Purpose: Cria itens do documento de terceiros de acordo com o RE2001
  Parameters: 
  Notes: Procedure constru°da com base no programa cd4326, chamado pelo mÇtodo
  pi-add-browse do b11in163.
------------------------------------------------------------------------------*/
    
    def var c-un                like it-nota-fisc.un-fatur  no-undo.
    def var de-qtd-conv-aux     as decimal                  no-undo.

    find first param-global no-lock no-error.

    /* Posiciona o item. */
    find first item no-lock
        where item.it-codigo = saldo-terc.it-codigo no-error.
    
    find first familia no-lock
        where familia.fm-codigo = item.fm-codigo no-error.

    ASSIGN de-qtd-conv-aux = IF AVAIL item-ref-nfe THEN item-ref-nfe.qtd-alocada ELSE item-doc-orig-nfe.qtd-comercial.

    IF  AVAIL item-ref-nfe
    AND item-doc-orig-nfe.qtd-interna <> item-doc-orig-nfe.qtd-comercial THEN
        FOR FIRST it-nota-fisc 
            WHERE it-nota-fisc.cod-estabel     = bf{&TableName}.cod-estabel
              AND it-nota-fisc.serie           = item-ref-nfe.serie-docto
              AND it-nota-fisc.nr-nota-fis     = item-ref-nfe.nro-docto
              AND it-nota-fisc.nr-seq-fat      = item-ref-nfe.seq-saldo-terc
              AND it-nota-fisc.it-codigo       = item-ref-nfe.it-codigo 
              AND it-nota-fisc.qt-faturada[1] <> it-nota-fisc.qt-faturada[2] NO-LOCK:
            ASSIGN de-qtd-conv-aux = IF item.fraciona THEN
                                         (de-qtd-conv-aux * (it-nota-fisc.dec-ftconv-unest / EXP(10,it-nota-fisc.num-casa-dec-unest)))
                                     ELSE ROUND((de-qtd-conv-aux * (it-nota-fisc.dec-ftconv-unest / EXP(10,it-nota-fisc.num-casa-dec-unest))),0).
        END.
    
    create tt-it-doc-fisico.
    assign tt-it-doc-fisico.sequencia     = i-seq-item /*item-doc-orig-nfe.seq-item*/
           tt-it-doc-fisico.nro-docto     = bf{&TableName}.nro-docto
           tt-it-doc-fisico.serie-docto   = bf{&TableName}.serie-docto
           tt-it-doc-fisico.cod-emitente  = bf{&TableName}.cod-emitente
           tt-it-doc-fisico.tipo-nota     = if i-tipo-nota = 0 then 1 else i-tipo-nota
           tt-it-doc-fisico.quantidade    = IF AVAIL item-ref-nfe THEN item-ref-nfe.qtd-alocada ELSE item-doc-orig-nfe.qtd-interna
           tt-it-doc-fisico.reabre-pd     = IF AVAIL item-ref-nfe THEN item-ref-nfe.reabre-pd   ELSE NO
           i-seq-item                     = i-seq-item + IF param-re.inc-seq > 0 THEN param-re.inc-seq ELSE 10.

    if saldo-terc.nat-operacao begins "5" 
    or saldo-terc.nat-operacao begins "6" 
    or saldo-terc.nat-operacao begins "7" then
        find first it-nota-fisc no-lock
            where it-nota-fisc.cod-estabel = saldo-terc.cod-estabel        
            and   it-nota-fisc.serie       = componente.serie-docto        
            and   it-nota-fisc.nr-nota-fis = componente.nro-docto          
            and   it-nota-fisc.nr-seq-fat  = componente.sequencia          
            and   it-nota-fisc.it-codigo   = componente.it-codigo no-error.
       
    if avail it-nota-fisc then
        assign c-un[1] = (if it-nota-fisc.ind-fat-qtfam  = no then it-nota-fisc.un-fatur[1] else it-nota-fisc.un-fatur[2]).
    else 
        assign c-un[1] = item.un.
    
    assign tt-it-doc-fisico.it-codigo            = item-doc-orig-nfe.it-codigo
           tt-it-doc-fisico.desconto             = IF item-doc-orig-nfe.vl-desconto = ? THEN
                                                       (ROUND(( componente.desconto[1]  / componente.quantidade ), 5) * (IF AVAIL item-ref-nfe THEN item-ref-nfe.qtd-alocada ELSE item-doc-orig-nfe.qtd-interna))
                                                   ELSE ((item-doc-orig-nfe.vl-desconto / item-doc-orig-nfe.qtd-comercial) * de-qtd-conv-aux)
           tt-it-doc-fisico.peso-liquido         = tt-it-doc-fisico.quantidade / componente.quantidade * componente.peso-liquido
           tt-it-doc-fisico.cod-refer            = componente.cod-refer 
           tt-it-doc-fisico.serie-comp           = componente.serie-docto
           tt-it-doc-fisico.nro-comp             = componente.nro-docto
           tt-it-doc-fisico.nat-comp             = componente.nat-operacao 
           tt-it-doc-fisico.seq-comp             = componente.sequencia
           tt-it-doc-fisico.un                   = c-un[1]
           tt-it-doc-fisico.nr-ord-produ          = if componente.nr-ord-produ <> 0 then componente.nr-ord-produ else item-doc-orig-nfe.nr-ord-produ
           tt-it-doc-fisico.ct-codigo            = componente.ct-codigo
           tt-it-doc-fisico.sc-codigo            = componente.sc-codigo
           tt-it-doc-fisico.baixa-ce             = if i-tipo-nota = 7 then no /* Faturamento Consignacao */
                                                   else componente.baixa-ce
           tt-it-doc-fisico.narrativa            = IF item-doc-orig-nfe.narrativa <> "" THEN 
                                                       (item-doc-orig-nfe.narrativa + " | " + componente.narrativa) 
                                                   ELSE componente.narrativa
           tt-it-doc-fisico.cod-depos            = item-doc-orig-nfe.cod-depos
           tt-it-doc-fisico.lote                 = item-doc-orig-nfe.lote-serie
           tt-it-doc-fisico.dt-vali-lote         = item-doc-orig-nfe.dt-vali-lote
           tt-it-doc-fisico.cod-localiz          = item-doc-orig-nfe.cod-localiz
           tt-it-doc-fisico.preco-unit           = ROUND(item-doc-orig-nfe.preco-unit,5)
           tt-it-doc-fisico.preco-total          = IF AVAIL item-ref-nfe THEN 
                                                       ROUND(ROUND(item-doc-orig-nfe.preco-total / item-doc-orig-nfe.qtd-interna, 10) * tt-it-doc-fisico.quantidade,2) 
                                                   ELSE item-doc-orig-nfe.preco-total
           /* A quantidade do emitente sempre Ç buscada de acordo com  a quantidade da nota de saida.  */
           tt-it-doc-fisico.qt-do-forn           = de-qtd-conv-aux
           /* Grava chave da reserva da ordem de producao */
           tt-it-doc-fisico.item-pai             = substr(componente.char-1,1,16)
           tt-it-doc-fisico.cod-roteiro          = substr(componente.char-1,17,16)
           tt-it-doc-fisico.op-codigo            = int(substr(componente.char-1,35,5))
           tt-it-doc-fisico.num-seq-event        = item-doc-orig-nfe.int-1 /* EVENTO - Adicionado para correá∆o da validacao de valor. */
           tt-it-doc-fisico.vl-frete             = de-frete-item
           tt-it-doc-fisico.despesas             = de-despesa-item + de-frete-item
           OVERLAY(tt-it-doc-fisico.char-2,42,5) = STRING(item-doc-orig-nfe.seq-item).

    if  i-pais-impto-usuario <> 1 
    and avail saldo-terc 
    and saldo-terc.log-entreg-fut then
        assign tt-it-doc-fisico.numero-ordem = saldo-terc.numero-ordem
               tt-it-doc-fisico.num-pedido   = saldo-terc.num-pedido  
               tt-it-doc-fisico.parcela      = saldo-terc.num-parcela
               i-num-pedido                  = saldo-terc.num-pedido.     
        
    /* Zera a Ordem de Producao e a Conta de Aplicacao para notas */
    /* de Faturamento Consignacao e Reajuste Preco, quado o  item */
    /* nao possuir tipo de controle Fisico ou Debito Direto.      */
    
    if i-tipo-nota = 7 then do: /* Faturamento Consig. Receb. Fisico */
        assign tt-it-doc-fisico.nr-ord-produ = 0.
    
        /* Item com tipo de controle Total ou Consignado */
        if  can-do("2,3", string(item.tipo-contr)) then
            assign tt-it-doc-fisico.ct-codigo = "":U
                   tt-it-doc-fisico.sc-codigo = "":U.
    end.
    else do:
        if i-tipo-nota = 7 /* Faturamento Consignacao */
        or i-tipo-nota = 5 /* Retorno Beneficiamento */
        or i-tipo-nota = 8 /* Devolucao Consignacao */ then
            run pi-unid-negoc.
    end.

    run pi-unid-negoc.

    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EliminaNFe DBOProgram 
PROCEDURE EliminaNFe :
/*------------------------------------------------------------------------------
  Purpose:     Eliminar os registros da NF-e.
  Parameters:  c-chave-nfe -> Chave £nica de acesso a NF-e no SEFAZ.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER c-chave-nfe AS CHAR NO-UNDO.

    DEFINE VARIABLE h-boin857   AS HANDLE  NO-UNDO.
    DEFINE VARIABLE h-boin404re AS HANDLE  NO-UNDO.
    
    /* In°cio exclus∆o NF-e */
    
    FOR EACH rat-lote-medic-nfe WHERE rat-lote-medic-nfe.ch-acesso-comp-nfe = c-chave-nfe EXCLUSIVE-LOCK:
       DELETE rat-lote-medic-nfe. 
    END.    
    
    FOR EACH msg-ret-nfe WHERE msg-ret-nfe.ch-acesso-comp-nfe = c-chave-nfe EXCLUSIVE-LOCK:
        DELETE msg-ret-nfe.
    END.
    
    FOR EACH item-doc-orig-arma-nfe WHERE item-doc-orig-arma-nfe.ch-acesso-comp-nfe = c-chave-nfe EXCLUSIVE-LOCK:
        DELETE item-doc-orig-arma-nfe.
    END. 
    
    FOR EACH item-doc-orig-comb-nfe WHERE item-doc-orig-comb-nfe.ch-acesso-comp-nfe = c-chave-nfe EXCLUSIVE-LOCK:
        DELETE item-doc-orig-comb-nfe.
    END. 
                   
    FOR EACH item-doc-orig-med-nfe WHERE item-doc-orig-med-nfe.ch-acesso-comp-nfe = c-chave-nfe EXCLUSIVE-LOCK:
        DELETE item-doc-orig-med-nfe.
    END. 
    
    FOR EACH item-doc-orig-di-nfe WHERE item-doc-orig-di-nfe.ch-acesso-comp-nfe = c-chave-nfe EXCLUSIVE-LOCK:
        DELETE item-doc-orig-di-nfe.
    END. 
    
    FOR EACH item-doc-orig-adic-nfe WHERE item-doc-orig-adic-nfe.ch-acesso-comp-nfe = c-chave-nfe EXCLUSIVE-LOCK:
        DELETE item-doc-orig-adic-nfe.
    END. 
    
    FOR EACH doc-orig-deduc-cana WHERE doc-orig-deduc-cana.ch-acesso-comp-nfe = c-chave-nfe EXCLUSIVE-LOCK:
        DELETE doc-orig-deduc-cana.
    END.  
    
    FOR EACH doc-orig-proc-ref-nfe WHERE doc-orig-proc-ref-nfe.ch-acesso-comp-nfe = c-chave-nfe EXCLUSIVE-LOCK:
        DELETE doc-orig-proc-ref-nfe.
    END. 
    
    FOR EACH doc-orig-lacre-nfe WHERE doc-orig-lacre-nfe.ch-acesso-comp-nfe = c-chave-nfe EXCLUSIVE-LOCK:
        DELETE doc-orig-lacre-nfe.
    END. 
       
    FOR EACH doc-orig-duplic-nfe WHERE doc-orig-duplic-nfe.ch-acesso-comp-nfe = c-chave-nfe EXCLUSIVE-LOCK:
        DELETE doc-orig-duplic-nfe.
    END. 
    
    FOR EACH doc-orig-refer-nfe WHERE doc-orig-refer-nfe.ch-acesso-comp-nfe = c-chave-nfe EXCLUSIVE-LOCK:
        DELETE doc-orig-refer-nfe.
    END. 

    FOR EACH log-config-regra WHERE log-config-regra.cod-chave = c-chave-nfe EXCLUSIVE-LOCK:
        DELETE log-config-regra.
    END.     
    
    /* Desalocar saldo em poder de terceiros, notas de terceiros: */
    IF  NOT VALID-HANDLE(h-boin404re) THEN
        RUN inbo/boin404re.p PERSISTENT SET h-boin404re.
    FOR EACH item-ref-nfe WHERE item-ref-nfe.ch-acesso-comp-nfe = c-chave-nfe EXCLUSIVE-LOCK:
        IF VALID-HANDLE(h-boin404re) THEN DO:
            FOR FIRST item-doc-orig-nfe FIELDS (nat-operacao)
                WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = c-chave-nfe
                AND item-doc-orig-nfe.seq-item = item-ref-nfe.seq-item 
                AND item-doc-orig-nfe.idi-orig-trad = 2 NO-LOCK:
                
                /* Desaloca o saldo em poder de terceiros. */
                RUN alocaSaldoTerc IN h-boin404re (INPUT NO,
                                                   INPUT item-ref-nfe.qtd-alocada,
                                                   INPUT item-ref-nfe.seq-saldo-terc,
                                                   INPUT item-ref-nfe.cod-emitente,
                                                   INPUT item-ref-nfe.nro-docto,
                                                   INPUT item-ref-nfe.serie-docto,
                                                   INPUT item-doc-orig-nfe.nat-operacao, /* Natureza do item. */
                                                   INPUT item-ref-nfe.nat-operacao,      /* Natureza do saldo em terceiros. */
                                                   INPUT item-ref-nfe.it-codigo).
            END.
        END.
        DELETE item-ref-nfe.
    END.
    IF  VALID-HANDLE(h-boin404re) THEN DO:
        DELETE PROCEDURE h-boin404re.
        ASSIGN h-boin404re = ?.
    END.
    /* FIM Desalocar saldo em poder de terceiros, notas de terceiros. */
    
    FOR EACH doc-orig-for-dia-cana WHERE doc-orig-for-dia-cana.ch-acesso-comp-nfe = c-chave-nfe EXCLUSIVE-LOCK:
        DELETE doc-orig-for-dia-cana.
    END.  
    
    FOR EACH doc-orig-volume-nfe WHERE doc-orig-volume-nfe.ch-acesso-comp-nfe = c-chave-nfe EXCLUSIVE-LOCK:
        DELETE doc-orig-volume-nfe.
    END. 
    
    FOR EACH item-doc-imp-nfe WHERE item-doc-imp-nfe.ch-acesso-comp-nfe = c-chave-nfe EXCLUSIVE-LOCK:
        DELETE item-doc-imp-nfe.
    END.

    /* Desalocar saldo de ordem de compra vinculada ao item da NF-e: */
    IF  NOT VALID-HANDLE(h-boin857) THEN
        RUN inbo/boin857.p PERSISTENT SET h-boin857.

    IF CAN-FIND(FIRST rat-ordem-orig-nfe 
                WHERE rat-ordem-orig-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe)
    AND NOT VALID-HANDLE(h-reapi401) THEN
        RUN rep/reapi401.p PERSISTENT SET h-reapi401.

    FOR EACH item-doc-orig-nfe WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = c-chave-nfe EXCLUSIVE-LOCK:       
        IF  item-doc-orig-nfe.numero-ordem <> 0 AND VALID-HANDLE(h-boin857) THEN DO:
            RUN findOrdemCompra     IN h-boin857 (INPUT item-doc-orig-nfe.numero-ordem).
            RUN validaContratoOrdem IN h-boin857 (OUTPUT l-contrato, OUTPUT i-total).
            IF  i-total = 0 THEN
                RUN pi-aloca-ordem-cc IN h-boin857 (INPUT NO,
                                                    INPUT item-doc-orig-nfe.numero-ordem,
                                                    INPUT item-doc-orig-nfe.parcela,
                                                    INPUT item-doc-orig-nfe.qtd-interna).
        END.
        ELSE /* Desaloca e Limpa a tabela rat-ordem-orig-nfe */
            IF VALID-HANDLE(h-reapi401) THEN
                RUN piLimpaRatOrdemOrigNfe IN h-reapi401(INPUT item-doc-orig-nfe.ch-acesso-comp-nfe,
                                                         INPUT item-doc-orig-nfe.seq-item,
                                                         INPUT-OUTPUT h-boin857).
        DELETE item-doc-orig-nfe.
    END.    
    IF  VALID-HANDLE(h-boin857) THEN DO:
        DELETE PROCEDURE h-boin857.
        ASSIGN h-boin857 = ?.
    END.
    IF  VALID-HANDLE(h-reapi401) THEN DO:
        DELETE PROCEDURE h-reapi401 NO-ERROR.
        ASSIGN h-reapi401 = ?.
    END.
    /* FIM Desalocar saldo de ordem de compra */

    FOR EACH movto-pend-nfe WHERE movto-pend-nfe.ch-acesso-comp-nfe = c-chave-nfe EXCLUSIVE-LOCK:
        DELETE movto-pend-nfe.
    END.

    /* Eliminar tabela de eventos */
    FOR EACH event-nfe-cte 
       WHERE event-nfe-cte.ch-acesso-comp-nfe = c-chave-nfe 
         AND event-nfe-cte.idi-tip-docto = 1 /* Evento NF-e */ EXCLUSIVE-LOCK:
        DELETE event-nfe-cte.
    END.

    /* Eliminar tabela comparativo XML */
    FOR EACH doc-xml-compar
       WHERE doc-xml-compar.ch-acesso-comp-nfe = c-chave-nfe 
         AND doc-xml-compar.idi-tip-docto      = 1 /* NF-e */ EXCLUSIVE-LOCK:
        DELETE doc-xml-compar.
    END.

    /* Valida se existe a nota passada no parÉmetro... */
    IF  NOT CAN-FIND(FIRST doc-orig-nfe WHERE doc-orig-nfe.ch-acesso-comp-nfe = c-chave-nfe) THEN
        RETURN "NOK":U.
    
    FOR EACH doc-orig-nfe WHERE doc-orig-nfe.ch-acesso-comp-nfe = c-chave-nfe EXCLUSIVE-LOCK:
        DELETE doc-orig-nfe.
    END.
    
    /* Fim exclus∆o NF-e */

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNaturOper DBOProgram 
PROCEDURE findNaturOper :
/*------------------------------------------------------------------------------
  Purpose: Permite a programas externos posicionarem a natureza de operaá∆o.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    define input param pc-nat-operacao as char no-undo.
    
    find first natur-oper no-lock
        where natur-oper.nat-operacao = pc-nat-operacao no-error.
    if avail natur-oper then
        return "OK":U.
    else 
        return "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraDuplicatas DBOProgram 
PROCEDURE geraDuplicatas :
/*------------------------------------------------------------------------------
  Purpose: Geraá∆o de duplicatas    
  Parameters: p-tipo: Tipo de geraá∆o de duplicata (1 - Conforme XML
                                                    2 - Conforme RE1001)
              p-chave: Chave de acesso do documento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-tipo  AS INTEGER     NO-UNDO.
    DEFINE INPUT PARAMETER p-chave AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE h-boin090       AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-boin092       AS HANDLE      NO-UNDO.
    DEFINE VARIABLE rw-documento    AS ROWID       NO-UNDO.
    DEFINE VARIABLE i-parcela       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iRowsReturned   AS INTEGER     NO-UNDO.
    define variable i-tp-despesa    as integer     no-undo.
    DEFINE VARIABLE i-gera-dupl-nfe AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l-gera-impto    AS LOGICAL     NO-UNDO.

    if not valid-handle(h-boin862) 
    or h-boin862:type      <> "PROCEDURE":U 
    or h-boin862:file-name <> "inbo/boin862.p":U then
        run inbo/boin862.p persistent set h-boin862.
        
    RUN openQueryStatic IN h-boin862 (INPUT "Main":U) NO-ERROR.
    RUN getFirst IN h-boin862.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    ELSE DO:
        RUN getIntField IN h-boin862 (INPUT "idi-gera-dupl-nfe":U, OUTPUT i-gera-dupl-nfe).
        RUN getLogField IN h-boin862 (INPUT "log-gera-impto":U,    OUTPUT l-gera-impto).
    END.   

        CASE p-tipo:
    
            /** GERA DUPLICATAS CONFORME XML **/
            WHEN 1 THEN DO:
                IF  NOT bf{&TableName}.log-multi-cfop 
                AND (i-gera-dupl-nfe = 1) THEN DO:
                    if  avail natur-oper 
                    and natur-oper.emite-duplic then do:

                        FOR FIRST emitente FIELDS (tp-desp-padrao)
                            WHERE emitente.cod-emitente = bf{&TableName}.cod-emitente NO-LOCK:
                        END.
                        IF NOT AVAIL emitente THEN
                            RETURN "NOK":U.
        
                        ASSIGN i-parcela = 0.
                        FOR EACH doc-orig-duplic-nfe 
                            WHERE doc-orig-duplic-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
                              AND doc-orig-duplic-nfe.idi-orig-trad      = 2 NO-LOCK
                            BREAK BY doc-orig-duplic-nfe.dt-vencim:
                            
                            ASSIGN i-parcela = i-parcela + 1.
                            
                            run retornaTipoDespDupli (output i-tp-despesa).
                            CREATE tt-dupli-apagar.
                            ASSIGN tt-dupli-apagar.cod-emitente     = bf{&TableName}.cod-emitente
                                   tt-dupli-apagar.dt-emissao       = bf{&TableName}.dt-emissao
                                   tt-dupli-apagar.dt-trans         = bf{&TableName}.dt-transacao
                                   tt-dupli-apagar.dt-vencim        = doc-orig-duplic-nfe.dt-vencim
                                   tt-dupli-apagar.ep-codigo        = i-empresa
                                   tt-dupli-apagar.esp-movto        = 1
                                   tt-dupli-apagar.cod-esp          = param-re.esp-def-dup
                                   tt-dupli-apagar.cod-estabel      = bf{&TableName}.cod-estabel
                                   tt-dupli-apagar.parcela          = STRING(i-parcela, "99")
                                   tt-dupli-apagar.nr-duplic        = bf{&TableName}.nro-docto
                                   tt-dupli-apagar.nro-docto        = bf{&TableName}.nro-docto
                                   tt-dupli-apagar.mo-codigo        = 0
                                   tt-dupli-apagar.nat-operacao     = tt-natureza.nat-oper-agrup
                                   tt-dupli-apagar.serie-docto      = bf{&TableName}.serie-docto
                                   tt-dupli-apagar.tp-despesa       = i-tp-despesa
                                   tt-dupli-apagar.vl-a-pagar       = doc-orig-duplic-nfe.vl-duplicata.
                        END.
                    end.
                END.
            END.
            /** GERA DUPLICATAS CONFORME XML **/
    
            /** GERA DUPLICATAS CONFORME RE1001 **/
            WHEN 2 THEN DO:
                IF (i-gera-dupl-nfe = 2) THEN DO:
                    
                    RUN inbo/boin090.p PERSISTENT SET h-boin090.
                    RUN openQueryStatic IN h-boin090 (INPUT "Main":U) NO-ERROR.
            
                    for each tt-natureza:
                        
                        /* Posiciona a natureza atual. */
                        find first natur-oper no-lock
                            where natur-oper.nat-operacao = tt-natureza.nat-oper-agrup
                            and   natur-oper.emite-duplic = yes no-error.
                        if avail natur-oper then do:
                            
                            /* Posiciona o documento da natureza atual. */
                            FOR EACH tt-docum-est no-lock
                                where tt-docum-est.nat-operacao = tt-natureza.nat-oper-agrup:

                                RUN goToKey IN h-boin090 (INPUT tt-docum-est.serie-docto,
                                                          INPUT tt-docum-est.nro-docto,
                                                          INPUT tt-docum-est.cod-emitente,
                                                          INPUT tt-docum-est.nat-operacao).
                                IF RETURN-VALUE <> "NOK":U THEN DO:
                                    RUN getRowid IN h-boin090 (OUTPUT rw-documento).
                    
                                    IF rw-documento <> ? THEN
                                        RUN rep/re9341.p (INPUT rw-documento, INPUT NO).
                                    
                                END.
                            END.
                        END.
                    END.
            
                    DELETE PROCEDURE h-boin090.
                    ASSIGN h-boin090 = ?.
                END.
            
                /* Geraá∆o de impostos */
                IF l-gera-impto THEN DO:
    
                    RUN inbo/boin092.p PERSISTENT SET h-boin092.
    
                    for each tt-natureza:

                        find first natur-oper no-lock
                            where natur-oper.nat-operacao = tt-natureza.nat-oper-agrup 
                            and   natur-oper.emite-duplic = yes no-error.
                        if avail natur-oper then do:

                            FOR EACH tt-docum-est no-lock
                               where tt-docum-est.nat-operacao = tt-natureza.nat-oper-agrup:
            
                                RUN setConstraintOfDocumEst  IN h-boin092 (INPUT tt-docum-est.cod-emitente,
                                                                           INPUT tt-docum-est.serie-docto,
                                                                           INPUT tt-docum-est.nro-docto,
                                                                           INPUT tt-docum-est.nat-operacao).
                                RUN openQueryStatic          IN h-boin092 (INPUT "OfDocumEst":U) NO-ERROR.
                                RUN getBatchRecords          IN h-boin092 (INPUT ?,
                                                                           INPUT NO,
                                                                           INPUT ?,
                                                                           OUTPUT iRowsReturned,
                                                                           OUTPUT TABLE tt-dupli-apagar).
                                
                                IF CAN-FIND(FIRST tt-dupli-apagar) THEN DO:
                                    
                                    IF CAN-FIND(FIRST funcao WHERE 
                                                      funcao.cd-funcao = "spp-aut-impto":U AND
                                                      funcao.ativo) THEN DO:

                                        RUN emptyRowErrors.
                                        RUN rep/re9343.p (INPUT  TABLE tt-dupli-apagar, OUTPUT TABLE RowErrors).

                                        FOR EACH RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U:
                                            RUN implantaErro(INPUT p-chave,
                                                             INPUT RowErrors.errorNumber,
                                                             INPUT RowErrors.errorDescription,
                                                             INPUT 2).    /* Aviso */
                                            RELEASE msg-ret-nfe.
                                        END.
                                    END.
                                END.
                            END.
                        end.
                    end.
    
                    DELETE PROCEDURE h-boin092.
                    ASSIGN h-boin092 = ?.
                END.
            END.
            /** GERA DUPLICATAS CONFORME RE1001 **/
    
        END CASE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraFIFO DBOProgram 
PROCEDURE geraFIFO :
/*------------------------------------------------------------------------------
  Purpose:    Gerar rat-ordem conforme os pedidos selecionados em tela no RE0118A 
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/

    IF  NOT VALID-HANDLE(h-boin857) 
    OR  h-boin857:TYPE <> "PROCEDURE":U 
    OR  h-boin857:FILE-NAME <> "inbo/boin857.p":U THEN
        RUN inbo/boin857.p PERSISTENT SET h-boin857.

    IF  NOT VALID-HANDLE(h-boin857) THEN
        RETURN "NOK":U.

    EMPTY TEMP-TABLE tt2-rat-ordem.

    FOR EACH tt-natureza:
        FOR EACH item-doc-orig-nfe OF bf{&TableName} 
            WHERE item-doc-orig-nfe.nat-operacao = tt-natureza.nat-operacao NO-LOCK:
            
            /******PONTO UPC AETHRA*******/
            IF c-nom-prog-dpc-mg97  <> ""
            OR c-nom-prog-upc-mg97  <> ""
            OR c-nom-prog-appc-mg97 <> "" THEN DO:
            
                EMPTY TEMP-TABLE tt-epc.
            
                {include/i-epc200.i2 &CodEvent       = "'CriaRatOrdemExt'"
                                     &CodParameter   = "'rowid-item-doc-est'"
                                     &ValueParameter =  STRING(ROWID(item-doc-est))}
                                     
                {include/i-epc200.i2 &CodEvent       = "'CriaRatOrdemExt'"
                                     &CodParameter   = "'rowid-item-doc-orig-nfe'"
                                     &ValueParameter =  STRING(ROWID(item-doc-orig-nfe))}
            
                /*** Chamada do programa EPC ***/
                {include/i-epc201.i  "CriaRatOrdemExt" }

                FOR FIRST tt-epc
                    WHERE tt-epc.cod-event     = "CriaRatOrdemExt"  
                      AND tt-epc.cod-parameter = "GerarFifo":U:
                    ASSIGN l-cria-rat-ordem    = LOGICAL(tt-epc.val-parameter).
                END.
            END.
            /*****************************/

            IF  CAN-FIND(FIRST rat-ordem-orig-nfe NO-LOCK
                         WHERE rat-ordem-orig-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                           AND rat-ordem-orig-nfe.seq-item           = item-doc-orig-nfe.seq-item) THEN DO:

                /*--- Busca cada tt-rat-ordem-orig-nfe-aux do item para gerar todas as sequencias de FIFO. ---*/
                FOR EACH tt-rat-ordem-orig-nfe-aux NO-LOCK
                    WHERE tt-rat-ordem-orig-nfe-aux.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                      AND tt-rat-ordem-orig-nfe-aux.seq-item           = item-doc-orig-nfe.seq-item:
                    
                    FOR FIRST rat-ordem-orig-nfe NO-LOCK
                        WHERE rat-ordem-orig-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe 
                          AND rat-ordem-orig-nfe.seq-item           = item-doc-orig-nfe.seq-item
                          AND rat-ordem-orig-nfe.num-pedido         = tt-rat-ordem-orig-nfe-aux.num-pedido
                          AND rat-ordem-orig-nfe.numero-ordem       = tt-rat-ordem-orig-nfe-aux.numero-ordem
                          AND rat-ordem-orig-nfe.parcela            = tt-rat-ordem-orig-nfe-aux.parcela
                          AND rat-ordem-orig-nfe.nr-contrato        = tt-rat-ordem-orig-nfe-aux.nr-contrato 
                          AND rat-ordem-orig-nfe.num-seq-item       = tt-rat-ordem-orig-nfe-aux.num-seq-item 
                          AND rat-ordem-orig-nfe.num-seq-medicao    = tt-rat-ordem-orig-nfe-aux.num-seq-medicao
                          AND rat-ordem-orig-nfe.num-seq-event      = tt-rat-ordem-orig-nfe-aux.num-seq-event:

                        CREATE tt2-rat-ordem.
                        BUFFER-COPY rat-ordem-orig-nfe TO tt2-rat-ordem.

                        /*--- Leva a sequencia da item-doc-est gravada na tt-rat-ordem-orig-nfe-aux. ---*/
                        ASSIGN tt2-rat-ordem.sequencia    = tt-rat-ordem-orig-nfe-aux.seq-item-doc-est
                               tt2-rat-ordem.qtidade-forn = tt-rat-ordem-orig-nfe-aux.val-quant-emit
                               tt2-rat-ordem.quantidade   = tt-rat-ordem-orig-nfe-aux.qtd-interna
                               tt2-rat-ordem.serie-docto  = bf{&TableName}.serie-docto
                               tt2-rat-ordem.nro-docto    = bf{&TableName}.nro-docto
                               tt2-rat-ordem.cod-emitente = bf{&TableName}.cod-emitente
                               tt2-rat-ordem.nat-operacao = tt-natureza.nat-oper-agrup.

                        /*--- Armazena o rowid da rat-ordem-orig-nfe para controle na trigger delete da tabela rat-ordem, 
                              pois quando for eliminada uma rat-ordem que possui rat-ordem-orig-nfe correspondente nao
                              deve desalocar a quantidade da parcela ---*/
                        ASSIGN OVERLAY(tt2-rat-ordem.char-1,50,50) = STRING(tt-rat-ordem-orig-nfe-aux.r-rowid). 

                        RUN findOrdemCompra     IN h-boin857 (INPUT tt2-rat-ordem.numero-ordem).
                        RUN validaContratoOrdem IN h-boin857 (OUTPUT l-contrato,
                                                              OUTPUT i-total).

                        /*--- desaloca a ordem de compra, pois a boin368 ira gerar a rat-ordem e 
                              tambem fara a alocacao ---*/
                        RUN pi-aloca-ordem-cc IN h-boin857 (INPUT NO, /* desaloca */
                                                            INPUT tt2-rat-ordem.numero-ordem,
                                                            INPUT tt2-rat-ordem.parcela, 
                                                            INPUT tt2-rat-ordem.quantidade).
                        IF tt2-rat-ordem.val-medicao > 0 THEN 
                            FOR FIRST medicao-contrat
                                WHERE medicao-contrat.nr-contrato     = tt2-rat-ordem.nr-contrato
                                  AND medicao-contrat.num-seq-item    = tt2-rat-ordem.num-seq-item
                                  AND medicao-contrat.numero-ordem    = tt2-rat-ordem.numero-ordem
                                  AND medicao-contrat.num-seq-event   = tt2-rat-ordem.num-seq-event
                                  AND medicao-contrat.num-seq-medicao = tt2-rat-ordem.num-seq-medicao NO-LOCK:

                                RUN pi-aloca-medicao(INPUT NO, /*desaloca*/
                                                     INPUT tt2-rat-ordem.val-medicao, 
                                                     INPUT ROWID(medicao-contrat)).
                            END.
                    END. /*FOR FIRST rat-ordem-orig-nfe NO-LOCK*/
                END. /*FOR EACH tt-rat-ordem-orig-nfe-aux */
            END. /*IF  CAN-FIND(FIRST rat-ordem-orig-nfe*/
        END. /*FOR EACH item-doc-orig-nfe OF bf{&TableName}*/
    END. /*FOR EACH tt-natureza*/
    
    IF  VALID-HANDLE(h-boin857)        AND
        h-boin857:TYPE = "PROCEDURE":U AND
        h-boin857:FILE-NAME = "inbo/boin857.p":U THEN DO:
        DELETE PROCEDURE h-boin857.
        ASSIGN h-boin857 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraLoteMedic DBOProgram 
PROCEDURE geraLoteMedic :
/*------------------------------------------------------------------------------
  Purpose:    Distribuir lotes de acordo com os lotes cadastrados na aba 
              Lotes do RE0708
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pr-nota        AS ROWID     NO-UNDO.
    DEFINE INPUT  PARAMETER p-tipo         AS INT       NO-UNDO.
    DEFINE OUTPUT PARAMETER l-ok-aux       AS LOG       NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.
        
    IF  NOT VALID-HANDLE(h-boin367) THEN DO:
        RUN inbo/boin367.p PERSISTENT SET h-boin367.
        RUN openQueryStatic IN h-boin367 ( "Main":U ).
    END.

    EMPTY TEMP-TABLE tt-rat-lote-medic-aux.

    FOR FIRST bf{&TableName} exclusive-lock
        WHERE ROWID(bf{&TableName}) = pr-nota:
        
        IF AVAIL natur-oper AND natur-oper.terceiros AND natur-oper.tp-oper-terc = 4 THEN do: /* faturamento de consignaá∆o */
           
           FOR EACH item-doc-orig-nfe OF bf{&TableName} NO-LOCK:
          
               FOR EACH rat-lote-medic-nfe NO-LOCK
                  WHERE rat-lote-medic-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
                    AND rat-lote-medic-nfe.idi-orig-trad      = 2 
                    AND rat-lote-medic-nfe.qtd-lote-fabrican  > 0:

                    IF INT(SUBSTRING(rat-lote-medic-nfe.cod-livre-1,68,4)) = item-doc-orig-nfe.seq-item THEN DO:

                        if  not valid-handle ( h-boin006 ) then
                            run inbo/boin006.p persistent set h-boin006.
                
                        if  not valid-handle(h-boin010) then 
                            run inbo/boin010.p persistent set h-boin010.
                                
                        run openQueryStatic in h-boin010 ( input "Main").
                                
                        for each tt-rat-componente:
                            delete tt-rat-componente.
                        end.
                                
                        CREATE tt-rat-componente.
                        ASSIGN tt-rat-componente.serie-docto  = bf{&TableName}.serie-docto
                               tt-rat-componente.nro-docto    = bf{&TableName}.nro-docto
                               tt-rat-componente.cod-emitente = bf{&TableName}.cod-emitente
                               tt-rat-componente.nat-operacao = natur-oper.nat-operacao
                               tt-rat-componente.it-codigo    = rat-lote-medic-nfe.it-codigo 
                               tt-rat-componente.cod-refer    = rat-lote-medic-nfe.cod-refer
                               tt-rat-componente.cod-depos    = rat-lote-medic-nfe.cod-depos   
                               tt-rat-componente.cod-localiz  = rat-lote-medic-nfe.cod-localiz
                               tt-rat-componente.lote         = rat-lote-medic-nfe.cod-lote-fabrican
                               tt-rat-componente.dt-vali-lote = rat-lote-medic-nfe.dat-valid-lote-fabrican
                               tt-rat-componente.quantidade   = rat-lote-medic-nfe.qtd-lote-fabrican
                               tt-rat-componente.componente   = 2.
                                      
                        FOR EACH item-ref-nfe
                           WHERE item-ref-nfe.ch-acesso-comp-nfe = rat-lote-medic-nfe.ch-acesso-comp-nfe
                           AND   item-ref-nfe.seq-saldo-terc     = rat-lote-medic-nfe.seq-item 
                           AND   item-ref-nfe.it-codigo          = rat-lote-medic-nfe.it-codigo NO-LOCK:

                           IF item-ref-nfe.nro-docto = SUBSTRING(rat-lote-medic-nfe.cod-livre-1,51,16) AND 
                              item-ref-nfe.seq-item  = INT(SUBSTRING(rat-lote-medic-nfe.cod-livre-1,68,4)) THEN DO:
                           
                              ASSIGN tt-rat-componente.nro-comp   = item-ref-nfe.nro-docto
                                     tt-rat-componente.serie-comp = item-ref-nfe.serie-docto
                                     tt-rat-componente.nat-comp   = item-ref-nfe.nat-operacao
                                     tt-rat-componente.seq-comp   = item-ref-nfe.seq-saldo-terc
                                     tt-rat-componente.emite-comp = item-ref-nfe.cod-emitente.
        
                              FOR EACH item-doc-est NO-LOCK
                                 WHERE item-doc-est.serie-docto  = bf{&TableName}.serie-docto
                                   AND item-doc-est.nro-docto    = bf{&TableName}.nro-docto
                                    AND item-doc-est.cod-emitente = bf{&TableName}.cod-emitente
                                    AND item-doc-est.nro-comp     = item-ref-nfe.nro-docto    
                                    AND item-doc-est.serie-comp   = item-ref-nfe.serie-docto    
                                    AND item-doc-est.nat-comp     = item-ref-nfe.nat-operacao   
                                    AND item-doc-est.seq-comp     = item-ref-nfe.seq-saldo-terc 
                                    AND item-doc-est.emite-comp   = item-ref-nfe.cod-emitente:
                                    IF INT(SUBSTRING(item-doc-est.char-2,832,5)) = item-ref-nfe.seq-item then
                                       ASSIGN tt-rat-componente.sequencia = item-doc-est.sequencia.
                                            
                              END.
                           END.
                        END.
        
                        
                        RUN updateQtdAloc IN h-boin006 (INPUT tt-rat-componente.serie-comp,     
                                                        INPUT tt-rat-componente.nro-comp, 
                                                        INPUT tt-rat-componente.nat-comp, 
                                                        INPUT rat-lote-medic-nfe.seq-item,
                                                        INPUT tt-rat-componente.emite-comp, 
                                                        INPUT tt-rat-componente.it-codigo, 
                                                        INPUT tt-rat-componente.cod-refer, 
                                                        INPUT tt-rat-componente.lote, 
                                                        INPUT "aloca", 
                                                        INPUT tt-rat-componente.quantidade).
                            
                        find first rowErrors no-lock no-error.
                                   
                        run emptyRowObject in h-boin010.
                        run emptyRowErrors in h-boin010.                    
                                
                        run setRecord      in h-boin010 ( input table tt-rat-componente ).
                        run createRecord   in h-boin010. /* Cria tabela rat-componente */
                
                        run getRowErrors in h-boin010 ( output table rowErrors ).
                
                        find first rowErrors no-lock no-error.
                        if  avail rowErrors and
                            rowErrors.ErrorSubType = "ERROR":U then do:
                            return "NOK":U.
                        end.               
                    END.
                    
                    ELSE DO:

                        RUN CreateRatComponente (INPUT rowid(bf{&TableName}),
                                                 INPUT  TABLE tt-docum-est,
                                                 INPUT item-doc-orig-nfe.seq-item,
                                                 OUTPUT l-ok-aux).
                    END.
               END.
           END.
        END. 
        ELSE DO:
            FOR EACH item-doc-orig-nfe OF bf{&TableName} NO-LOCK:
    
                /* se nao encontrar rat-lote-medic-nfe para a sequencia de item, entao nao elimina nem re-gera o rat-lote */
                IF  NOT CAN-FIND(FIRST rat-lote-medic-nfe 
                                 WHERE rat-lote-medic-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
                                   AND rat-lote-medic-nfe.idi-orig-trad      = 2
                                   AND rat-lote-medic-nfe.seq-item           = item-doc-orig-nfe.seq-item) THEN
                    NEXT.
    
                FOR EACH rat-lote-medic-nfe 
                   WHERE rat-lote-medic-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
                     AND rat-lote-medic-nfe.idi-orig-trad      = 2
                     AND rat-lote-medic-nfe.seq-item           = item-doc-orig-nfe.seq-item:
                    
                    CREATE tt-rat-lote-medic-aux.
                    BUFFER-COPY rat-lote-medic-nfe TO tt-rat-lote-medic-aux.
                    ASSIGN tt-rat-lote-medic-aux.it-codigo = item-doc-orig-nfe.it-codigo
                           tt-rat-lote-medic-aux.qtd-saldo = rat-lote-medic-nfe.qtd-lote-fabrican.

                END.
    
                IF p-tipo = 1 THEN DO: /*Fiscal*/
    
                    IF  item-doc-orig-nfe.int-2 = 3 THEN NEXT.

                    FOR EACH item-doc-est NO-LOCK
                       WHERE item-doc-est.serie-docto  = bf{&TableName}.serie-docto
                         AND item-doc-est.nro-docto    = bf{&TableName}.nro-docto
                         AND item-doc-est.cod-emitente = bf{&TableName}.cod-emitente:
                                           
                        IF int(SUBSTRING(item-doc-est.char-2,832,5)) <> item-doc-orig-nfe.seq-item
                        OR item-doc-est.nat-of <> item-doc-orig-nfe.nat-operacao THEN
                            NEXT.
    
                        ASSIGN c-serie-docto-medic = item-doc-est.serie-docto
                               c-nro-docto-medic   = item-doc-est.nro-docto 
                               c-cod-emit-medic    = item-doc-est.cod-emitente
                               c-nat-oper-medic    = item-doc-est.nat-operacao
                               c-seq-medic         = item-doc-est.sequencia
                               de-saldo-it-fiscal  = item-doc-est.quantidade
                               c-it-codigo-medic   = item-doc-est.it-codigo.
    
                        RUN createRatLoteMedic (OUTPUT TABLE tt-erro).
    
                    END.
    
                END.
                ELSE DO: /*Fisico*/
                    /*nao regera o rat-lote quando for nota de devoluá∆o, transferencia ou retorno,*/
                    /*pois para esses tipos de nota a rat-lote Ç copiada da fat-ser-lote (NF saida)*/
                    
                    IF item-doc-orig-nfe.int-2 = 2  OR   /*Devoluá∆o Cli*/
                       item-doc-orig-nfe.int-2 = 3  OR   /*Transferància*/
                       item-doc-orig-nfe.int-2 = 5  OR   /*Retorno Benef*/
                       item-doc-orig-nfe.int-2 = 8  OR   /*Devol Consig */ 
                       item-doc-orig-nfe.int-2 = 19 OR   /*Ret Dep Fechado*/
                       item-doc-orig-nfe.int-2 = 21 THEN /*Ret Armaz Geral*/
                        NEXT.
    
                    find first doc-fisico
                        where  doc-fisico.nro-docto    = bf{&TableName}.nro-docto   
                        and    doc-fisico.serie-docto  = bf{&TableName}.serie-docto 
                        and    doc-fisico.cod-emitente = bf{&TableName}.cod-emitente NO-LOCK no-error.
                    if  avail doc-fisico then do:
    
                        for each  it-doc-fisico
                            where it-doc-fisico.serie-docto  = doc-fisico.serie-docto
                            and   it-doc-fisico.nro-docto    = doc-fisico.nro-docto
                            and   it-doc-fisico.cod-emitente = doc-fisico.cod-emitente
                            and   it-doc-fisico.tipo-nota    = doc-fisico.tipo-nota NO-LOCK:
    
                            IF int(SUBSTRING(it-doc-fisico.char-2,42,5)) <> item-doc-orig-nfe.seq-item THEN
                            NEXT.
    
                            ASSIGN c-serie-docto-medic = it-doc-fisico.serie-docto
                                   c-nro-docto-medic   = it-doc-fisico.nro-docto 
                                   c-cod-emit-medic    = it-doc-fisico.cod-emitente
                                   c-nat-oper-medic    = ""
                                   c-seq-medic         = it-doc-fisico.sequencia
                                   de-saldo-it-fiscal  = it-doc-fisico.quantidade
                                   c-it-codigo-medic   = it-doc-fisico.it-codigo.
    
                            RUN createRatLoteMedic (OUTPUT TABLE tt-erro).
    
                        END.                       
                    END.
                END.  
            END.
        END.
    END.

    IF  VALID-HANDLE(h-boin367) THEN
        DELETE PROCEDURE h-boin367.

    if  valid-handle (h-boin010) then do:
        delete procedure h-boin010.
        assign h-boin010 = ?.
    end.

    if  valid-handle (h-boin006) then do:
        delete procedure h-boin006.
        assign h-boin006 = ?.
    end.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST tt-erro) THEN
        RETURN "NOK":U.
    ELSE
        ASSIGN l-ok-aux = YES.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRatLoteMedic DBOProgram 
PROCEDURE CreateRatLoteMedic :
/*------------------------------------------------------------------------------
  Purpose:    Criar lotes de acordo com os lotes cadastrados na aba 
              Lotes do RE0708
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

        
    DEF VAR de-saldo-item   LIKE rat-lote-medic-nfe.qtd-lote-fabrican NO-UNDO.
    DEF VAR de-saldo-seq-it LIKE rat-lote-medic-nfe.qtd-lote-fabrican NO-UNDO.
    DEF VAR de-saldo-lote   LIKE rat-lote-medic-nfe.qtd-lote-fabrican NO-UNDO.

    FOR EACH tt-rat-lote-aux:
        DELETE tt-rat-lote-aux.
    END.
    
    /*busca dados do rat-lote para usar como base na criaªío do novo registro*/
    RUN goToKey IN h-boin367(INPUT c-serie-docto-medic,
                             INPUT c-nro-docto-medic,
                             INPUT c-cod-emit-medic,
                             INPUT c-nat-oper-medic,
                             INPUT c-seq-medic).

    
    IF RETURN-VALUE <> "NOK":U THEN
       RUN getRecord IN h-boin367 (OUTPUT TABLE tt-rat-lote-aux).
    ELSE DO:
        FIND FIRST tt-rat-lote-aux NO-LOCK
             WHERE tt-rat-lote-aux.cod-emitente = c-cod-emit-medic
               AND tt-rat-lote-aux.nro-docto    = c-nro-docto-medic
               AND tt-rat-lote-aux.nat-operacao = c-nat-oper-medic
               AND tt-rat-lote-aux.serie-docto  = c-serie-docto-medic
               AND tt-rat-lote-aux.sequencia    = c-seq-medic NO-ERROR.
        IF NOT AVAIL tt-rat-lote-aux THEN DO:
            CREATE tt-rat-lote-aux.
            ASSIGN tt-rat-lote-aux.cod-emitente = c-cod-emit-medic   
                   tt-rat-lote-aux.nro-docto    = c-nro-docto-medic  
                   tt-rat-lote-aux.nat-operacao = c-nat-oper-medic   
                   tt-rat-lote-aux.serie-docto  = c-serie-docto-medic
                   tt-rat-lote-aux.sequencia    = c-seq-medic
                   tt-rat-lote-aux.it-codigo    = c-it-codigo-medic.

        END.
    END.

    /*elimina os registros da rat-lote para criaªío dos novos*/
    FOR EACH rat-lote EXCLUSIVE-LOCK
       WHERE rat-lote.cod-emitente = c-cod-emit-medic
         AND rat-lote.nro-docto    = c-nro-docto-medic
         AND rat-lote.nat-operacao = c-nat-oper-medic
         AND rat-lote.serie-docto  = c-serie-docto-medic
         AND rat-lote.sequencia    = c-seq-medic:
        DELETE rat-lote.

    END.

    ASSIGN de-saldo-seq-it = de-saldo-it-fiscal.

    DO WHILE de-saldo-seq-it > 0:

        ASSIGN de-saldo-lote = 0
               c-cod-lote    = ""
               r-rowid-medic = ?.
        
        FOR EACH tt-rat-lote-medic-aux 
           WHERE tt-rat-lote-medic-aux.it-codigo = c-it-codigo-medic
             AND tt-rat-lote-medic-aux.seq-item  = item-doc-orig-nfe.seq-item
             AND tt-rat-lote-medic-aux.qtd-saldo > 0:

            ASSIGN de-saldo-lote = tt-rat-lote-medic-aux.qtd-saldo
                   c-cod-lote    = tt-rat-lote-medic-aux.cod-lote-fabrican
                   r-rowid-medic = ROWID(tt-rat-lote-medic-aux).

            /*se achou saldo sai*/
            IF de-saldo-lote > 0 THEN
                LEAVE.
        END.

        /*Se saldo for zero vai para a prΩxima sequºncia */
        IF de-saldo-lote = 0 AND c-cod-lote = "" THEN
            LEAVE.

        FIND FIRST tt-rat-lote-medic-aux 
            WHERE ROWID(tt-rat-lote-medic-aux) = r-rowid-medic EXCLUSIVE-LOCK NO-ERROR.

        /*Quando o saldo do item ≤ maior que o lote zera o lote*/
        IF de-saldo-seq-it > de-saldo-lote THEN
            ASSIGN de-qtd-lote = de-saldo-lote
                   de-saldo-seq-it = de-saldo-seq-it - de-saldo-lote
                   tt-rat-lote-medic-aux.qtd-saldo = 0.
        ELSE DO:    /*Quando o saldo do item ≤ menor que o lote armazena o saldo para a proxima sequºncia */
            ASSIGN de-qtd-lote = de-saldo-seq-it
                   tt-rat-lote-medic-aux.qtd-saldo = tt-rat-lote-medic-aux.qtd-saldo - de-saldo-seq-it
                   de-saldo-seq-it = 0.
        END.

        FOR EACH tt-rat-lote-aux:
           
            FIND item-uni-estab
              WHERE item-uni-estab.it-codigo   = item-doc-orig-nfe.it-codigo
                AND item-uni-estab.cod-estabel = bf{&TableName}.cod-estabel NO-LOCK NO-ERROR.
            
            /*Cria registros na rat-lote com base na rat-lote de origem e tamb≤m dos dados da aba lote no re0118*/
            CREATE rat-lote.
            BUFFER-COPY tt-rat-lote-aux TO rat-lote
            ASSIGN rat-lote.sequencia        = c-seq-medic
                   rat-lote.lote             = c-cod-lote
                   rat-lote.quantidade       = de-qtd-lote
                   rat-lote.cod-depos        = tt-rat-lote-medic-aux.cod-depos
                   rat-lote.cod-localiz      = IF AVAIL item-uni-estab AND item-uni-estab.loc-unica THEN item-uni-estab.cod-localiz ELSE tt-rat-lote-medic-aux.cod-localiz
                   rat-lote.dt-vali-lote     = tt-rat-lote-medic-aux.dat-valid-lote-fabrican
                   rat-lote.dat-fabricc-lote = tt-rat-lote-medic-aux.dat-fabricc-lote.

            FIND FIRST saldo-estoq       
                 WHERE saldo-estoq.it-codigo   = c-it-codigo-medic
                   AND saldo-estoq.lote        = rat-lote.lote  
                   AND saldo-estoq.qtidade-atu > 0   no-lock no-error.
            IF AVAIL saldo-estoq THEN
               ASSIGN rat-lote.dt-vali-lote     = saldo-estoq.dt-vali-lote
                      rat-lote.dat-fabricc-lote =  saldo-estoq.dt-fabric.
        END.

        FIND FIRST rat-lote NO-LOCK 
            WHERE rat-lote.cod-emitente = c-cod-emit-medic
              AND rat-lote.nro-docto    = c-nro-docto-medic
              AND rat-lote.nat-operacao = c-nat-oper-medic
              AND rat-lote.serie-docto  = c-serie-docto-medic
              AND rat-lote.sequencia    = c-seq-medic NO-ERROR.

        IF de-saldo-seq-it = 0 THEN
            LEAVE.

    END.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "Bairro":U THEN ASSIGN pFieldValue = RowObject.Bairro.
        WHEN "bairro-dest":U THEN ASSIGN pFieldValue = RowObject.bairro-dest.
        WHEN "bairro-ent":U THEN ASSIGN pFieldValue = RowObject.bairro-ent.
        WHEN "bairro-ret":U THEN ASSIGN pFieldValue = RowObject.bairro-ret.
        WHEN "cep":U THEN ASSIGN pFieldValue = RowObject.cep.
        WHEN "cep-destino":U THEN ASSIGN pFieldValue = RowObject.cep-destino.
        WHEN "cfop-ret":U THEN ASSIGN pFieldValue = RowObject.cfop-ret.
        WHEN "ch-acesso-comp-nfe":U THEN ASSIGN pFieldValue = RowObject.ch-acesso-comp-nfe.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cnae-fiscal":U THEN ASSIGN pFieldValue = RowObject.cnae-fiscal.
        WHEN "cnpj":U THEN ASSIGN pFieldValue = RowObject.cnpj.
        WHEN "cnpj-destino":U THEN ASSIGN pFieldValue = RowObject.cnpj-destino.
        WHEN "cnpj-emissor":U THEN ASSIGN pFieldValue = RowObject.cnpj-emissor.
        WHEN "cnpj-entrega":U THEN ASSIGN pFieldValue = RowObject.cnpj-entrega.
        WHEN "cnpj-retirada":U THEN ASSIGN pFieldValue = RowObject.cnpj-retirada.
        WHEN "cnpj-transp":U THEN ASSIGN pFieldValue = RowObject.cnpj-transp.
        WHEN "cod-dv":U THEN ASSIGN pFieldValue = RowObject.cod-dv.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-fatura":U THEN ASSIGN pFieldValue = RowObject.cod-fatura.
        WHEN "cod-finalidade":U THEN ASSIGN pFieldValue = RowObject.cod-finalidade.
        WHEN "cod-rntc":U THEN ASSIGN pFieldValue = RowObject.cod-rntc.
        WHEN "cod-rntc-reboque[1]":U THEN ASSIGN pFieldValue = RowObject.cod-rntc-reboque[1].
        WHEN "cod-rntc-reboque[2]":U THEN ASSIGN pFieldValue = RowObject.cod-rntc-reboque[2].
        WHEN "complemento":U THEN ASSIGN pFieldValue = RowObject.complemento.
        WHEN "complemento-dest":U THEN ASSIGN pFieldValue = RowObject.complemento-dest.
        WHEN "complemento-ent":U THEN ASSIGN pFieldValue = RowObject.complemento-ent.
        WHEN "complemento-ret":U THEN ASSIGN pFieldValue = RowObject.complemento-ret.
        WHEN "cpf":U THEN ASSIGN pFieldValue = RowObject.cpf.
        WHEN "cpf-destino":U THEN ASSIGN pFieldValue = RowObject.cpf-destino.
        WHEN "cpf-transp":U THEN ASSIGN pFieldValue = RowObject.cpf-transp.
        WHEN "end-transp":U THEN ASSIGN pFieldValue = RowObject.end-transp.
        WHEN "fone":U THEN ASSIGN pFieldValue = RowObject.fone.
        WHEN "fone-destino":U THEN ASSIGN pFieldValue = RowObject.fone-destino.
        WHEN "fone-emit":U THEN ASSIGN pFieldValue = RowObject.fone-emit.
        WHEN "Forma-emissao":U THEN ASSIGN pFieldValue = RowObject.Forma-emissao.
        WHEN "Forma-imp":U THEN ASSIGN pFieldValue = RowObject.Forma-imp.
        WHEN "inf-adicionais":U THEN ASSIGN pFieldValue = RowObject.inf-adicionais.
        WHEN "inf-complement":U THEN ASSIGN pFieldValue = RowObject.inf-complement.
        WHEN "inf-contrato":U THEN ASSIGN pFieldValue = RowObject.inf-contrato.
        WHEN "inf-pedido":U THEN ASSIGN pFieldValue = RowObject.inf-pedido.
        WHEN "insc-estad-subs-dest":U THEN ASSIGN pFieldValue = RowObject.insc-estad-subs-dest.
        WHEN "insc-estadual":U THEN ASSIGN pFieldValue = RowObject.insc-estadual.
        WHEN "insc-estadual-dest":U THEN ASSIGN pFieldValue = RowObject.insc-estadual-dest.
        WHEN "insc-estadual-subs":U THEN ASSIGN pFieldValue = RowObject.insc-estadual-subs.
        WHEN "insc-estadual-transp":U THEN ASSIGN pFieldValue = RowObject.insc-estadual-transp.
        WHEN "insc-municipal":U THEN ASSIGN pFieldValue = RowObject.insc-municipal.
        WHEN "localiz-embarque":U THEN ASSIGN pFieldValue = RowObject.localiz-embarque.
        WHEN "logradouro":U THEN ASSIGN pFieldValue = RowObject.logradouro.
        WHEN "logradouro-dest":U THEN ASSIGN pFieldValue = RowObject.logradouro-dest.
        WHEN "logradouro-ent":U THEN ASSIGN pFieldValue = RowObject.logradouro-ent.
        WHEN "logradouro-ret":U THEN ASSIGN pFieldValue = RowObject.logradouro-ret.
        WHEN "matr-agente":U THEN ASSIGN pFieldValue = RowObject.matr-agente.
        WHEN "mod-doc-fisc":U THEN ASSIGN pFieldValue = RowObject.mod-doc-fisc.
        WHEN "mod-frete":U THEN ASSIGN pFieldValue = RowObject.mod-frete.
        WHEN "nom-agente":U THEN ASSIGN pFieldValue = RowObject.nom-agente.
        WHEN "nom-municipio-end":U THEN ASSIGN pFieldValue = RowObject.nom-municipio-end.
        WHEN "nom-municipio-ent":U THEN ASSIGN pFieldValue = RowObject.nom-municipio-ent.
        WHEN "nom-municipio-ret":U THEN ASSIGN pFieldValue = RowObject.nom-municipio-ret.
        WHEN "nom-pais":U THEN ASSIGN pFieldValue = RowObject.nom-pais.
        WHEN "nom-pais-dest":U THEN ASSIGN pFieldValue = RowObject.nom-pais-dest.
        WHEN "nome-fantasia":U THEN ASSIGN pFieldValue = RowObject.nome-fantasia.
        WHEN "nota-empenho":U THEN ASSIGN pFieldValue = RowObject.nota-empenho.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "num-dar":U THEN ASSIGN pFieldValue = RowObject.num-dar.
        WHEN "num-end-dest":U THEN ASSIGN pFieldValue = RowObject.num-end-dest.
        WHEN "num-end-emit":U THEN ASSIGN pFieldValue = RowObject.num-end-emit.
        WHEN "num-end-ent":U THEN ASSIGN pFieldValue = RowObject.num-end-ent.
        WHEN "num-end-ret":U THEN ASSIGN pFieldValue = RowObject.num-end-ret.
        WHEN "obs-cont[1]":U THEN ASSIGN pFieldValue = RowObject.obs-cont[1].
        WHEN "obs-cont[2]":U THEN ASSIGN pFieldValue = RowObject.obs-cont[2].
        WHEN "obs-cont[3]":U THEN ASSIGN pFieldValue = RowObject.obs-cont[3].
        WHEN "obs-cont[4]":U THEN ASSIGN pFieldValue = RowObject.obs-cont[4].
        WHEN "obs-cont[5]":U THEN ASSIGN pFieldValue = RowObject.obs-cont[5].
        WHEN "obs-cont[6]":U THEN ASSIGN pFieldValue = RowObject.obs-cont[6].
        WHEN "obs-cont[7]":U THEN ASSIGN pFieldValue = RowObject.obs-cont[7].
        WHEN "obs-cont[8]":U THEN ASSIGN pFieldValue = RowObject.obs-cont[8].
        WHEN "obs-cont[9]":U THEN ASSIGN pFieldValue = RowObject.obs-cont[9].
        WHEN "obs-cont[10]":U THEN ASSIGN pFieldValue = RowObject.obs-cont[10].
        WHEN "obs-cont-txt[1]":U THEN ASSIGN pFieldValue = RowObject.obs-cont-txt[1].
        WHEN "obs-cont-txt[2]":U THEN ASSIGN pFieldValue = RowObject.obs-cont-txt[2].
        WHEN "obs-cont-txt[3]":U THEN ASSIGN pFieldValue = RowObject.obs-cont-txt[3].
        WHEN "obs-cont-txt[4]":U THEN ASSIGN pFieldValue = RowObject.obs-cont-txt[4].
        WHEN "obs-cont-txt[5]":U THEN ASSIGN pFieldValue = RowObject.obs-cont-txt[5].
        WHEN "obs-cont-txt[6]":U THEN ASSIGN pFieldValue = RowObject.obs-cont-txt[6].
        WHEN "obs-cont-txt[7]":U THEN ASSIGN pFieldValue = RowObject.obs-cont-txt[7].
        WHEN "obs-cont-txt[8]":U THEN ASSIGN pFieldValue = RowObject.obs-cont-txt[8].
        WHEN "obs-cont-txt[9]":U THEN ASSIGN pFieldValue = RowObject.obs-cont-txt[9].
        WHEN "obs-cont-txt[10]":U THEN ASSIGN pFieldValue = RowObject.obs-cont-txt[10].
        WHEN "obs-fisco[1]":U THEN ASSIGN pFieldValue = RowObject.obs-fisco[1].
        WHEN "obs-fisco[2]":U THEN ASSIGN pFieldValue = RowObject.obs-fisco[2].
        WHEN "obs-fisco[3]":U THEN ASSIGN pFieldValue = RowObject.obs-fisco[3].
        WHEN "obs-fisco[4]":U THEN ASSIGN pFieldValue = RowObject.obs-fisco[4].
        WHEN "obs-fisco[5]":U THEN ASSIGN pFieldValue = RowObject.obs-fisco[5].
        WHEN "obs-fisco[6]":U THEN ASSIGN pFieldValue = RowObject.obs-fisco[6].
        WHEN "obs-fisco[7]":U THEN ASSIGN pFieldValue = RowObject.obs-fisco[7].
        WHEN "obs-fisco[8]":U THEN ASSIGN pFieldValue = RowObject.obs-fisco[8].
        WHEN "obs-fisco[9]":U THEN ASSIGN pFieldValue = RowObject.obs-fisco[9].
        WHEN "obs-fisco[10]":U THEN ASSIGN pFieldValue = RowObject.obs-fisco[10].
        WHEN "obs-fisco-txt[1]":U THEN ASSIGN pFieldValue = RowObject.obs-fisco-txt[1].
        WHEN "obs-fisco-txt[2]":U THEN ASSIGN pFieldValue = RowObject.obs-fisco-txt[2].
        WHEN "obs-fisco-txt[3]":U THEN ASSIGN pFieldValue = RowObject.obs-fisco-txt[3].
        WHEN "obs-fisco-txt[4]":U THEN ASSIGN pFieldValue = RowObject.obs-fisco-txt[4].
        WHEN "obs-fisco-txt[5]":U THEN ASSIGN pFieldValue = RowObject.obs-fisco-txt[5].
        WHEN "obs-fisco-txt[6]":U THEN ASSIGN pFieldValue = RowObject.obs-fisco-txt[6].
        WHEN "obs-fisco-txt[7]":U THEN ASSIGN pFieldValue = RowObject.obs-fisco-txt[7].
        WHEN "obs-fisco-txt[8]":U THEN ASSIGN pFieldValue = RowObject.obs-fisco-txt[8].
        WHEN "obs-fisco-txt[9]":U THEN ASSIGN pFieldValue = RowObject.obs-fisco-txt[9].
        WHEN "obs-fisco-txt[10]":U THEN ASSIGN pFieldValue = RowObject.obs-fisco-txt[10].
        WHEN "org-emissor":U THEN ASSIGN pFieldValue = RowObject.org-emissor.
        WHEN "placa":U THEN ASSIGN pFieldValue = RowObject.placa.
        WHEN "placa-reboque[1]":U THEN ASSIGN pFieldValue = RowObject.placa-reboque[1].
        WHEN "placa-reboque[2]":U THEN ASSIGN pFieldValue = RowObject.placa-reboque[2].
        WHEN "proc-emissao":U THEN ASSIGN pFieldValue = RowObject.proc-emissao.
        WHEN "razao-social":U THEN ASSIGN pFieldValue = RowObject.razao-social.
        WHEN "razao-social-dest":U THEN ASSIGN pFieldValue = RowObject.razao-social-dest.
        WHEN "razao-social-transp":U THEN ASSIGN pFieldValue = RowObject.razao-social-transp.
        WHEN "RepEmit":U THEN ASSIGN pFieldValue = RowObject.RepEmit.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "tipo-amb":U THEN ASSIGN pFieldValue = RowObject.tipo-amb.
        WHEN "tp-nf":U THEN ASSIGN pFieldValue = RowObject.tp-nf.
        WHEN "uf":U THEN ASSIGN pFieldValue = RowObject.uf.
        WHEN "uf-avulsa":U THEN ASSIGN pFieldValue = RowObject.uf-avulsa.
        WHEN "uf-destino":U THEN ASSIGN pFieldValue = RowObject.uf-destino.
        WHEN "uf-embarque":U THEN ASSIGN pFieldValue = RowObject.uf-embarque.
        WHEN "uf-end":U THEN ASSIGN pFieldValue = RowObject.uf-end.
        WHEN "uf-entrega":U THEN ASSIGN pFieldValue = RowObject.uf-entrega.
        WHEN "uf-placa":U THEN ASSIGN pFieldValue = RowObject.uf-placa.
        WHEN "uf-reboque[1]":U THEN ASSIGN pFieldValue = RowObject.uf-reboque[1].
        WHEN "uf-reboque[2]":U THEN ASSIGN pFieldValue = RowObject.uf-reboque[2].
        WHEN "uf-retirada":U THEN ASSIGN pFieldValue = RowObject.uf-retirada.
        WHEN "uf-transp":U THEN ASSIGN pFieldValue = RowObject.uf-transp.
        WHEN "versao-proc":U THEN ASSIGN pFieldValue = RowObject.versao-proc.
        WHEN "cidade-fato-gerador":U THEN ASSIGN pFieldValue = RowObject.cidade-fato-gerador.
        WHEN "uf-fato-gerador":U THEN ASSIGN pFieldValue = RowObject.uf-fato-gerador.
        WHEN "cod-tipo-nf-cred-deb":U THEN ASSIGN pFieldValue = RowObject.cod-tipo-nf-cred-deb.
        WHEN "cnpj-intermediador":U THEN ASSIGN pFieldValue = RowObject.cnpj-intermediador.
        WHEN "id-cad-intermediador":U THEN ASSIGN pFieldValue = RowObject.id-cad-intermediador.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dt-emissao":U THEN ASSIGN pFieldValue = RowObject.dt-emissao.
        WHEN "dt-emissao-dar":U THEN ASSIGN pFieldValue = RowObject.dt-emissao-dar.
        WHEN "dt-entrada":U THEN ASSIGN pFieldValue = RowObject.dt-entrada.
        WHEN "dt-pag-dar":U THEN ASSIGN pFieldValue = RowObject.dt-pag-dar.
        WHEN "dt-prev-entrega":U THEN ASSIGN pFieldValue = RowObject.dt-prev-entrega.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "aliq-icms-ret":U THEN ASSIGN pFieldValue = RowObject.aliq-icms-ret.
        WHEN "base-icms":U THEN ASSIGN pFieldValue = RowObject.base-icms.
        WHEN "base-icms-ret":U THEN ASSIGN pFieldValue = RowObject.base-icms-ret.
        WHEN "base-icms-subs":U THEN ASSIGN pFieldValue = RowObject.base-icms-subs.
        WHEN "base-iss":U THEN ASSIGN pFieldValue = RowObject.base-iss.
        WHEN "base-prev-ret":U THEN ASSIGN pFieldValue = RowObject.base-prev-ret.
        WHEN "valor-cofins":U THEN ASSIGN pFieldValue = RowObject.valor-cofins.
        WHEN "valor-cofins-iss":U THEN ASSIGN pFieldValue = RowObject.valor-cofins-iss.
        WHEN "valor-cofins-ret":U THEN ASSIGN pFieldValue = RowObject.valor-cofins-ret.
        WHEN "valor-csll-ret":U THEN ASSIGN pFieldValue = RowObject.valor-csll-ret.
        WHEN "valor-dar":U THEN ASSIGN pFieldValue = RowObject.valor-dar.
        WHEN "valor-desc-fatura":U THEN ASSIGN pFieldValue = RowObject.valor-desc-fatura.
        WHEN "valor-desconto":U THEN ASSIGN pFieldValue = RowObject.valor-desconto.
        WHEN "valor-frete":U THEN ASSIGN pFieldValue = RowObject.valor-frete.
        WHEN "valor-icms":U THEN ASSIGN pFieldValue = RowObject.valor-icms.
        WHEN "valor-icms-ret":U THEN ASSIGN pFieldValue = RowObject.valor-icms-ret.
        WHEN "valor-icms-subs":U THEN ASSIGN pFieldValue = RowObject.valor-icms-subs.
        WHEN "valor-ii":U THEN ASSIGN pFieldValue = RowObject.valor-ii.
        WHEN "valor-ipi":U THEN ASSIGN pFieldValue = RowObject.valor-ipi.
        WHEN "valor-iss":U THEN ASSIGN pFieldValue = RowObject.valor-iss.
        WHEN "valor-liq-fatura":U THEN ASSIGN pFieldValue = RowObject.valor-liq-fatura.
        WHEN "valor-orig-fatura":U THEN ASSIGN pFieldValue = RowObject.valor-orig-fatura.
        WHEN "valor-outros":U THEN ASSIGN pFieldValue = RowObject.valor-outros.
        WHEN "valor-pis":U THEN ASSIGN pFieldValue = RowObject.valor-pis.
        WHEN "valor-pis-iss":U THEN ASSIGN pFieldValue = RowObject.valor-pis-iss.
        WHEN "valor-pis-ret":U THEN ASSIGN pFieldValue = RowObject.valor-pis-ret.
        WHEN "valor-prev-ret":U THEN ASSIGN pFieldValue = RowObject.valor-prev-ret.
        WHEN "valor-produto":U THEN ASSIGN pFieldValue = RowObject.valor-produto.
        WHEN "valor-seguro":U THEN ASSIGN pFieldValue = RowObject.valor-seguro.
        WHEN "valor-serv-ret-trans":U THEN ASSIGN pFieldValue = RowObject.valor-serv-ret-trans.
        WHEN "valor-total":U THEN ASSIGN pFieldValue = RowObject.valor-total.
        WHEN "valor-tot-nf-rt":U THEN ASSIGN pFieldValue = RowObject.valor-tot-nf-rt.
        WHEN "preco-total-liquido":U THEN ASSIGN pFieldValue = RowObject.preco-total-liquido.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "ch-acesso-nfe":U THEN ASSIGN pFieldValue = RowObject.ch-acesso-nfe.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-municipio":U THEN ASSIGN pFieldValue = RowObject.cod-municipio.
        WHEN "cod-municipio-dest":U THEN ASSIGN pFieldValue = RowObject.cod-municipio-dest.
        WHEN "cod-municipio-end":U THEN ASSIGN pFieldValue = RowObject.cod-municipio-end.
        WHEN "cod-municipio-ent":U THEN ASSIGN pFieldValue = RowObject.cod-municipio-ent.
        WHEN "cod-municipio-fg":U THEN ASSIGN pFieldValue = RowObject.cod-municipio-fg.
        WHEN "cod-municipio-ret":U THEN ASSIGN pFieldValue = RowObject.cod-municipio-ret.
        WHEN "cod-municipio-transp":U THEN ASSIGN pFieldValue = RowObject.cod-municipio-transp.
        WHEN "cod-pais":U THEN ASSIGN pFieldValue = RowObject.cod-pais.
        WHEN "cod-pais-dest":U THEN ASSIGN pFieldValue = RowObject.cod-pais-dest.
        WHEN "cod-observa":U THEN ASSIGN pFieldValue = RowObject.cod-observa.
        WHEN "idi-orig-trad":U THEN ASSIGN pFieldValue = RowObject.idi-orig-trad.
        WHEN "idi-situacao":U THEN ASSIGN pFieldValue = RowObject.idi-situacao.
        WHEN "cod-munic-fato-ger":U THEN ASSIGN pFieldValue = RowObject.cod-munic-fato-ger.
        WHEN "idi-presenca":U THEN ASSIGN pFieldValue = RowObject.idi-presenca.        
        WHEN "cod-tipo-oper-gov":U THEN ASSIGN pFieldValue = RowObject.cod-tipo-oper-gov.
        WHEN "cod-tipo-ente-gov":U THEN ASSIGN pFieldValue = RowObject.cod-tipo-ente-gov.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice unico
  Parameters:  
               retorna valor do campo ch-acesso-comp-nfe
               retorna valor do campo idi-orig-trad
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pch-acesso-comp-nfe LIKE doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-orig-trad LIKE doc-orig-nfe.idi-orig-trad NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
           pidi-orig-trad = RowObject.idi-orig-trad.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.  

    CASE pFieldName:
        WHEN "log-intermediador":U THEN ASSIGN pFieldValue = RowObject.log-intermediador.
        
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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
  Purpose:     Reposiciona registro com base no °ndice unico
  Parameters:  
               recebe valor do campo ch-acesso-comp-nfe
               recebe valor do campo idi-orig-trad
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pch-acesso-comp-nfe LIKE doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAMETER pidi-orig-trad LIKE doc-orig-nfe.idi-orig-trad NO-UNDO.

    FIND FIRST bfdoc-orig-nfe WHERE 
        bfdoc-orig-nfe.ch-acesso-comp-nfe = pch-acesso-comp-nfe AND 
        bfdoc-orig-nfe.idi-orig-trad = pidi-orig-trad NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdoc-orig-nfe THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdoc-orig-nfe)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE implantaErro DBOProgram 
PROCEDURE implantaErro :
/*------------------------------------------------------------------------------
  Purpose:     Implanta o erro na msg-ret-nfe conforme o que eh passado por parametro
  Parameters:  Chave de acesso, Codigo da mensagem, Texto da mensagem e tipo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-c-ch-acesso-comp-nfe LIKE msg-ret-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAMETER p-i-cd-msg             LIKE msg-ret-nfe.cd-msg             NO-UNDO.
    DEFINE INPUT PARAMETER p-c-texto-msg          LIKE msg-ret-nfe.texto-msg          NO-UNDO.
    DEFINE INPUT PARAMETER p-i-tipo-msg           LIKE msg-ret-nfe.tipo-msg           NO-UNDO.
    
    CREATE msg-ret-nfe.
    ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = p-c-ch-acesso-comp-nfe
           msg-ret-nfe.idi-orig-trad      = 2
           msg-ret-nfe.dt-msg             = TODAY
           msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
           msg-ret-nfe.log-ativo          = YES
           msg-ret-nfe.cd-msg             = p-i-cd-msg
           msg-ret-nfe.texto-msg          = p-c-texto-msg
           msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe)
           msg-ret-nfe.tipo-msg           = p-i-tipo-msg
           msg-ret-nfe.usuario            = c-seg-usuario
           .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE implantaErroConfCadastroMsg DBOProgram 
PROCEDURE implantaErroConfCadastroMsg :
/*------------------------------------------------------------------------------
  Purpose:     Implanta o erro na msg-ret-nfe conforme o cadastro de mensagens (ut-msgs)
  Parameters:  Chave de acesso, Codigo da mensagem, Parametros da mensagem e tipo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-c-ch-acesso-comp-nfe LIKE msg-ret-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAMETER p-i-cd-msg             LIKE msg-ret-nfe.cd-msg             NO-UNDO.
    DEFINE INPUT PARAMETER p-c-params-msg         AS CHAR                             NO-UNDO.
    DEFINE INPUT PARAMETER p-i-tipo-msg           LIKE msg-ret-nfe.tipo-msg           NO-UNDO.

    RUN utp/ut-msgs.p(INPUT "msg":U,
                      INPUT p-i-cd-msg,
                      INPUT p-c-params-msg).

    RUN implantaErro(INPUT p-c-ch-acesso-comp-nfe,
                     INPUT p-i-cd-msg,
                     INPUT RETURN-VALUE,
                     INPUT p-i-tipo-msg).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDocumento DBOProgram 
PROCEDURE openQueryDocumento :
/*------------------------------------------------------------------------------
  Purpose: Abertura da query com base na chave do documento e origem    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} 
        FOR EACH {&TableName} NO-LOCK
           WHERE {&TableName}.ch-acesso-comp-nfe = c-chave-acesso
             AND {&TableName}.idi-orig-trad      = i-idi-origem INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDocumentosDoc DBOProgram 
PROCEDURE openQueryDocumentosDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} 
      FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cod-emitente  >= i-cod-emitente-ini
           AND {&TableName}.cod-emitente  <= i-cod-emitente-fim
           AND {&TableName}.cod-estabel   >= c-cod-estabel-ini
           AND {&TableName}.cod-estabel   <= c-cod-estabel-fim
           AND {&TableName}.serie-docto   >= c-serie-docto-ini
           AND {&TableName}.serie-docto   <= c-serie-docto-fim
           AND {&TableName}.nro-docto     >= c-nro-docto-ini
           AND {&TableName}.nro-docto     <= c-nro-docto-fim
           AND {&TableName}.dt-emissao    >= dt-emissao-ini
           AND {&TableName}.dt-emissao    <= dt-emissao-fim
           AND {&TableName}.dt-transacao  >= dt-transacao-ini
           AND {&TableName}.dt-transacao  <= dt-transacao-fim INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDocumentosDocZ02IN847 DBOProgram 
PROCEDURE retornaDocumentosDocZ02IN847 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAM TABLE FOR tt-doc-orig-nfe-agrup.

    EMPTY TEMP-TABLE tt-doc-orig-nfe-agrup.

    FOR EACH {&TableName} NO-LOCK
       WHERE {&TableName}.nro-docto     >= c-nro-docto-ini
         AND {&TableName}.nro-docto     <= c-nro-docto-fim
         AND {&TableName}.serie-docto   >= c-serie-docto-ini
         AND {&TableName}.serie-docto   <= c-serie-docto-fim
         AND {&TableName}.dt-emissao    >= dt-emissao-ini
         AND {&TableName}.dt-emissao    <= dt-emissao-fim
         AND {&TableName}.dt-transacao  >= dt-transacao-ini
         AND {&TableName}.dt-transacao  <= dt-transacao-fim
         AND {&TableName}.idi-orig-trad  = 2 /* Traduzido */
         /*AND ({&TableName}.idi-situacao  = 2 OR /* Erro de neg¢cio */
              {&TableName}.idi-situacao  = 4 OR /* Eliminada */
              {&TableName}.idi-situacao  = 5)   /* Cancelada */ */ ,
       FIRST item-doc-orig-nfe NO-LOCK
       WHERE item-doc-orig-nfe.ch-acesso-comp-nfe  = {&TableName}.ch-acesso-comp-nfe
         AND item-doc-orig-nfe.idi-orig-trad       = {&TableName}.idi-orig-trad
         AND item-doc-orig-nfe.nat-operacao       >= c-nat-operacao-ini
         AND item-doc-orig-nfe.nat-operacao       <= c-nat-operacao-fim:

        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = item-doc-orig-nfe.nat-operacao
               AND natur-oper.terceiros    = YES
               AND natur-oper.tp-oper-terc = 2 NO-ERROR.
        
        CREATE tt-doc-orig-nfe-agrup.
        BUFFER-COPY doc-orig-nfe TO tt-doc-orig-nfe-agrup.
        ASSIGN tt-doc-orig-nfe-agrup.nat-oper      = item-doc-orig-nfe.nat-operacao
               tt-doc-orig-nfe-agrup.desc-nat-oper = (IF AVAIL natur-oper THEN natur-oper.denominacao ELSE "")
               tt-doc-orig-nfe-agrup.situacao      = doc-orig-nfe.idi-situacao 
               tt-doc-orig-nfe-agrup.r-rowid       = ROWID(doc-orig-nfe).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose: Abertura da query principal do DBO     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMonitor DBOProgram 
PROCEDURE openQueryMonitor :
/*------------------------------------------------------------------------------
  Purpose: Abertura da query utilizada pelo monitor do conversor de notas fiscais 
           de entrada     
  Parameters: tt-doc-orig-nfe-aux: Temp-table contendo os registros da abertura da query
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM TABLE FOR tt-doc-orig-nfe-aux.

    DEFINE VARIABLE c-lista-param      AS CHAR     NO-UNDO.
    DEFINE VARIABLE c-lista-a-comparar AS CHAR     NO-UNDO.
    DEFINE VARIABLE i-cont             AS INT      NO-UNDO.

    DEFINE VARIABLE cQuery AS CHARACTER INITIAL "FOR EACH doc-orig-nfe NO-LOCK" NO-UNDO.
    DEFINE VARIABLE cWhere         AS CHARACTER INITIAL "" NO-UNDO.
    DEFINE VARIABLE cWhereVariavel AS CHARACTER INITIAL "" NO-UNDO.

    DEFINE VARIABLE d-data-default-ini AS DATE FORMAT "99/99/9999" INITIAL 01/01/1800 NO-UNDO. 
    DEFINE VARIABLE d-data-default-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 NO-UNDO. 
    DEFINE VARIABLE l-orig-ativo       AS LOGICAL NO-UNDO.

    EMPTY TEMP-TABLE tt-doc-orig-nfe-aux.

    IF c-cod-emitente-ini <> 0 OR c-cod-emitente-fim <> 999999999 THEN DO:
        IF c-cod-emitente-ini = c-cod-emitente-fim THEN
            ASSIGN cWhere = cWhere + " AND doc-orig-nfe.cod-emitente = " + string(c-cod-emitente-ini).
        ELSE
            ASSIGN cWhere = cWhere + " AND doc-orig-nfe.cod-emitente >= " + string(c-cod-emitente-ini) +
                                     " AND doc-orig-nfe.cod-emitente <= " + string(c-cod-emitente-fim).
    END.

    IF c-cod-estabel-ini <> "" OR c-cod-estabel-fim <> "ZZZZZ" THEN DO:
        IF c-cod-estabel-ini = c-cod-estabel-fim THEN
            ASSIGN cWhere = cWhere + " AND doc-orig-nfe.cod-estabel = '" + c-cod-estabel-ini + "'".
        ELSE
            ASSIGN cWhere = cWhere + " AND doc-orig-nfe.cod-estabel >= '" + c-cod-estabel-ini + "'" +
                                     " AND doc-orig-nfe.cod-estabel <= '" + c-cod-estabel-fim + "'".
    END.

    IF c-serie-ini <> "" OR c-serie-fim <> "ZZZZZZ" THEN DO:
        IF c-serie-ini = c-serie-fim THEN
            ASSIGN cWhere = cWhere + " AND doc-orig-nfe.serie-docto = '" + c-serie-ini + "'".
        ELSE
            ASSIGN cWhere = cWhere + " AND doc-orig-nfe.serie-docto >= '" + c-serie-ini + "'" +
                                     " AND doc-orig-nfe.serie-docto <= '" + c-serie-fim + "'".
    END.

    IF c-nro-docto-ini <> "" OR c-nro-docto-fim <> "ZZZZZZZZZZZZZZZZ" THEN DO:
        IF c-nro-docto-ini = c-nro-docto-fim THEN
            ASSIGN cWhere = cWhere + " AND doc-orig-nfe.nro-docto = '" + c-nro-docto-ini + "'".
        ELSE
            ASSIGN cWhere = cWhere + " AND doc-orig-nfe.nro-docto >= '" + c-nro-docto-ini + "'" +
                                     " AND doc-orig-nfe.nro-docto <= '" + c-nro-docto-fim + "'".
    END.
                                                                      
    IF dt-emissao-ini <> d-data-default-ini OR dt-emissao-fim <> d-data-default-fim THEN DO:
        IF dt-emissao-ini = dt-emissao-fim THEN
            ASSIGN cWhere = cWhere + " AND doc-orig-nfe.dt-emissao = DATE('":U + TRIM(STRING(dt-emissao-ini)) + "')".
        ELSE
            ASSIGN cWhere = cWhere + " AND doc-orig-nfe.dt-emissao >= DATE('":U + TRIM(STRING(dt-emissao-ini)) + "')" + 
                                     " AND doc-orig-nfe.dt-emissao <= DATE('":U + TRIM(STRING(dt-emissao-fim)) + "')".
    END.

    IF dt-transacao-ini <> d-data-default-ini OR dt-transacao-fim <> d-data-default-fim THEN DO:
        IF dt-transacao-ini = dt-transacao-fim THEN
            ASSIGN cWhere = cWhere + " AND doc-orig-nfe.dt-transacao = DATE('":U + TRIM(STRING(dt-transacao-ini)) + "')".
        ELSE
            ASSIGN cWhere = cWhere + " AND doc-orig-nfe.dt-transacao >= DATE('":U + TRIM(STRING(dt-transacao-ini)) + "')" + 
                                     " AND doc-orig-nfe.dt-transacao <= DATE('":U + TRIM(STRING(dt-transacao-fim)) + "')".
    END.

    /* Originaá∆o de Gr∆os Implantado  */
    RUN cdp/cd0032.p (OUTPUT l-orig-ativo).
    ASSIGN c-lista-a-comparar = "1;2;3;4;5;6;7;8;9;".
    IF l-orig-ativo THEN
        ASSIGN c-lista-a-comparar = c-lista-a-comparar + "10;".

    if  tg-digitada          then assign c-lista-param = "1" + ";".
    if  tg-erro-neg          then assign c-lista-param = c-lista-param + "2" + ";".
    if  tg-atualizada        then assign c-lista-param = c-lista-param + "3" + ";".
    if  tg-eliminada         then assign c-lista-param = c-lista-param + "4" + ";".
    if  tg-cancelada         then assign c-lista-param = c-lista-param + "5" + ";".
    if  tg-digit-fisico      then assign c-lista-param = c-lista-param + "6" + ";".
    IF  tg-atualizada-fisico then assign c-lista-param = c-lista-param + "7" + ";".
    if  tg-inutilizada       then assign c-lista-param = c-lista-param + "8" + ";".
    if  tg-validacao         then assign c-lista-param = c-lista-param + "9" + ";".
    if  l-orig-ativo and tg-gerado-romaneio then assign c-lista-param = c-lista-param + "10" + ";".

    if  num-entries(c-lista-param, ";") - 1 > 0 then do:
        /* Todas as situacoes selecionadas, nao precisa filtrar idi-situacao */
        IF c-lista-param = c-lista-a-comparar THEN DO:
            ASSIGN cWhereVariavel = " WHERE doc-orig-nfe.idi-orig-trad = " + string(i-idi-orig-trad).

            RUN queryDinamica (INPUT cQuery + cWhereVariavel + cWhere).
        END.
        ELSE DO:
            do i-cont = 1 to num-entries(c-lista-param, ";") - 1:
                ASSIGN cWhereVariavel = " WHERE doc-orig-nfe.idi-situacao = " + entry(i-cont, c-lista-param, ";") + 
                                        " AND doc-orig-nfe.idi-orig-trad  = " + string(i-idi-orig-trad).
    
                RUN queryDinamica (INPUT cQuery + cWhereVariavel + cWhere).
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE queryDinamica DBOProgram 
PROCEDURE queryDinamica :
/*------------------------------------------------------------------------------
  Purpose: Query dinamica da doc-orig-nfe
  Parameters: Recebe a query por parÉmetro
  Cria registros na tt-doc-orig-nfe-aux.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER cQuery AS CHAR NO-UNDO.
    DEFINE VARIABLE qh     AS HANDLE    NO-UNDO.

    CREATE QUERY qh.
    qh:SET-BUFFERS(BUFFER doc-orig-nfe:HANDLE).
    qh:QUERY-PREPARE(cQuery).
    qh:FORWARD-ONLY = TRUE.
    qh:QUERY-OPEN().

    REPEAT:
        qh:GET-NEXT().
        IF qh:QUERY-OFF-END THEN LEAVE.

        CREATE tt-doc-orig-nfe-aux.
        BUFFER-COPY doc-orig-nfe TO tt-doc-orig-nfe-aux.
        ASSIGN tt-doc-orig-nfe-aux.r-rowid = ROWID(doc-orig-nfe).
    END.

    qh:QUERY-CLOSE().
    DELETE OBJECT qh.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryTraduzido DBOProgram 
PROCEDURE openQueryTraduzido :
/*------------------------------------------------------------------------------
  Purpose: Abertura da query para mostrar apenas documentos traduzidos    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} 
      FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.idi-orig-trad = 2 INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-item-fiscal DBOProgram 
PROCEDURE pi-item-fiscal :
/*------------------------------------------------------------------------------
  Purpose: Preenchimento de atributos fiscais do item da nota
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND ITEM WHERE ITEM.it-codigo = tt-item-doc-est.it-codigo NO-LOCK NO-ERROR.

    if avail item then do:

        run validaTipoNota(output i-tipo-nota).
    
        find param-re where param-re.usuario = tt-docum-est.usuario no-lock no-error.
        
        if  i-tipo-nota = 2 then DO:         /* Devol */

            find it-nota-fisc
               where it-nota-fisc.cod-estabel  = tt-docum-est.cod-estabel 
                 and it-nota-fisc.serie        = tt-item-doc-est.serie-comp
                 and it-nota-fisc.nr-nota-fis  = tt-item-doc-est.nro-comp
                 and it-nota-fisc.nr-seq-fat   = tt-item-doc-est.seq-comp
                 and it-nota-fisc.it-codigo    = tt-item-doc-est.it-codigo no-lock no-error.

            IF  AVAIL it-nota-fisc THEN 
                assign tt-item-doc-est.aliquota-ipi = it-nota-fisc.aliquota-ipi
                       tt-item-doc-est.cd-trib-ipi  = it-nota-fisc.cd-trib-ipi
                       tt-item-doc-est.aliquota-icm = it-nota-fisc.aliquota-icm
                       tt-item-doc-est.cd-trib-icm  = it-nota-fisc.cd-trib-icm
                       tt-item-doc-est.log-2        = it-nota-fisc.ind-icm-ret.

            ELSE DO: /* Devoluá∆o sem Nota de Origem */
                
                /* Rotina para determinar o codigo de tributacao de ICMS. */
                run cdp/cd4302.p ( input  item.cd-trib-icm,
                                   input  natur-oper.cd-trib-icm,
                                   output tt-item-doc-est.cd-trib-icm ).

                /* Rotina para determinar o codigo de tributacao de IPI.  */
                run cdp/cd4303.p ( input  item.cd-trib-ipi,
                                   input  natur-oper.cd-trib-ipi,
                                   output tt-item-doc-est.cd-trib-ipi ).

            END.

        END.
        else DO:
            if  i-tipo-nota = 9 then DO:          /* Nota Rateio  */                    
                assign tt-item-doc-est.cd-trib-ipi  = natur-oper.cd-trib-ipi
                       tt-item-doc-est.cd-trib-icm  = natur-oper.cd-trib-icm
                       tt-item-doc-est.aliquota-icm = natur-oper.aliquota-icm.
                
            END. 
            else do:
                
                assign tt-item-doc-est.cd-trib-iss  = 2.
               
                /* Rotina para determinar o codigo de tributacao de ICMS. */
                run cdp/cd4302.p ( input  item.cd-trib-icm,
                                   input  natur-oper.cd-trib-icm,
                                   output tt-item-doc-est.cd-trib-icm ).
                
        
                /* Rotina para determinar o codigo de tributacao de IPI.  */
                run cdp/cd4303.p ( input  item.cd-trib-ipi,
                                   input  natur-oper.cd-trib-ipi,
                                   output tt-item-doc-est.cd-trib-ipi ).
                
        
                /* Busca Estabelecimento Origem na NFT */
                if  i-tipo-nota = 3 then      /* Transf */
                    find estabelec
                        where estabelec.cod-estabel = tt-docum-est.estab-de-or no-lock no-error.
                else 
                    find estabelec
                        where estabelec.cod-estabel = tt-docum-est.cod-estabel no-lock no-error.
        
                find b-emit-estab
                   where b-emit-estab.cod-emitente = estabelec.cod-emitente no-lock no-error.
    
                FIND bf-emitente
                    WHERE bf-emitente.cod-emitente = bf{&TableName}.cod-emitente NO-LOCK NO-ERROR.
    
                /* Determina Aliquota ICMS */
                run cdp/cd4301a.p ( ( if  avail b-emit-estab then 
                                          b-emit-estab.contrib-icms
                                      else
                                          yes),
                                    ( if  avail b-emit-estab THEN
                                          b-emit-estab.natureza
                                      else 2 /*"J"*/),
                                    ( if  i-tipo-nota = 2 OR /* devol  */
                                          i-tipo-nota = 3 OR /* transf */
                                          i-tipo-nota = 8 then /* devol consig */
                                          estabelec.estado
                                      else bf-emitente.estado ),
                                    ( if  i-tipo-nota = 2 then /* devol */
                                           estabelec.pais
                                      else bf-emitente.pais ),
                                    ( if  i-tipo-nota = 2 OR /* devol  */
                                          i-tipo-nota = 3 OR /* transf */
                                          i-tipo-nota = 8 then /* devol consig */    
                                          bf-emitente.estado
                                      else estabelec.estado ),
                                    tt-item-doc-est.it-codigo,
                                    natur-oper.aliquota-icm,
                                    natur-oper.nat-operacao,
                                    tt-item-doc-est.class-fiscal,
                                    bf-emitente.cod-emitente,
                                    tt-docum-est.dt-emissao,
                                    tt-docum-est.cod-estabel,
                                    output tt-item-doc-est.aliquota-icm ).
                         
                /* Determina Aliquota de IPI */                           
                if  natur-oper.terceiros OR natur-oper.transf THEN DO:  
                    find componente
                        where componente.serie-docto   = tt-item-doc-est.serie-comp
                          and componente.cod-emitente  = tt-item-doc-est.cod-emitente
                          and componente.nro-docto     = tt-item-doc-est.nro-comp
                          and componente.nat-operacao  = tt-item-doc-est.nat-comp
                          and componente.it-codigo     = tt-item-doc-est.it-codigo
                          and componente.cod-refer     = tt-item-doc-est.cod-refer
                          and componente.sequencia     = tt-item-doc-est.seq-comp no-lock no-error.                          
                    if  avail componente then DO:
                        assign tt-item-doc-est.aliquota-ipi = componente.aliquota-ipi.
                        /* Determina Aliquota de ICMS */   
                        IF i-tipo-nota = 3 THEN DO:
                            ASSIGN tt-item-doc-est.aliquota-icm   = componente.aliquota-icm.
                        END.            
                    END.
                END.
                else do:
                    
                    find classif-fisc 
                        where classif-fisc.class-fiscal = tt-item-doc-est.class-fiscal no-lock no-error.
                        
                    assign tt-item-doc-est.aliquota-ipi = if  param-re.orig-aliq-ip = 1 
                                                       and avail classif-fisc then 
                                                           classif-fisc.aliquota-ipi
                                                       else 
                                                           item.aliquota-ipi.     
                end.                                                   
            end.
        END.

        if  i-tipo-nota <> 2 then /* Devoluá∆o Cliente */        
            assign tt-item-doc-est.val-perc-rep-ipi  = natur-oper.perc-red-ipi
                   tt-item-doc-est.val-perc-red-icms = natur-oper.perc-red-icm.
    end.

    IF SUBSTRING(item-doc-orig-nfe.char-1,10,20) <> "" THEN DO:
        IF CAN-FIND (FIRST sit-tribut NO-LOCK
                     WHERE sit-tribut.cdn-tribut     = 11 /*CEST*/
                       AND sit-tribut.cdn-sit-tribut = INT(SUBSTRING(item-doc-orig-nfe.char-1,10,20))) THEN
            ASSIGN OVERLAY(tt-item-doc-est.char-2,840,20) = SUBSTRING(item-doc-orig-nfe.char-1,10,20). /*c¢digo CEST*/
    END.

    RUN salvarDadosFCIItemRecebFiscal.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-unid-negoc DBOProgram 
PROCEDURE pi-unid-negoc :
/*------------------------------------------------------------------------------
  Purpose: Preenchimento de informaá‰es de unidade de neg¢cio
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Variaveis setadas pela include cdp/cd9590.i, existente apenas na 2.06 */
    if  l-unidade-negocio and l-mat-unid-negoc then do:

        if  saldo-terc.nr-ord-produ <> 0 then do:
            for first ord-prod fields(nr-ord-produ cod-unid-negoc)
                where ord-prod.nr-ord-produ = saldo-terc.nr-ord-produ no-lock:
            assign tt-it-doc-fisico.cod-unid-negoc = ord-prod.cod-unid-negoc.
            end.
        end.
        else
            if  componente.ct-codigo <> "" then
            assign tt-it-doc-fisico.cod-unid-negoc = componente.cod-unid-negoc.
        
        if  i-tipo-nota = 7 /* Faturamento Consignacao */
    and tt-it-doc-fisico.cod-unid-negoc = "" then
        assign tt-it-doc-fisico.cod-unid-negoc = componente.cod-unid-negoc.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLibGeracRoman DBOProgram 
PROCEDURE piLibGeracRoman :
/*------------------------------------------------------------------------------
  Purpose:     Permitir que o processo faáa geraá∆o do romaneio ao invÇs do documento fiscal
  Parameters:  <none>
  Notes:       Rotinas que ativam este flag s∆o RE0708 e GG2000J
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pLiberGeracRomaneio AS LOGICAL NO-UNDO.

    ASSIGN lLiberGeracRomaneio = pLiberGeracRomaneio.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVincChaveRoman DBOProgram 
PROCEDURE piVincChaveRoman :
/*------------------------------------------------------------------------------
  Purpose:     Permitir que o processo vincule a chave ao romaneio selecionado
  Parameters:  <none>
  Notes:       Rotina que ativa este flag GG2000J
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pRowIdRomaneioVincular AS ROWID NO-UNDO.

    ASSIGN iRowIdRomaneioVinc = pRowIdRomaneioVincular.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processaAcabado DBOProgram 
PROCEDURE processaAcabado :
/*------------------------------------------------------------------------------
  Purpose: Processa nota de entrada de acabado.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var i-seq-acabado   as int  no-undo.
    
           
    /* Cria tt-movto-pend para cada item do documento que tiver ordem de produá∆o. */
    for each item-doc-orig-nfe of bf{&TableName}
        where item-doc-orig-nfe.nr-ord-produ <> 0 no-lock:


        FIND FIRST ord-prod
            WHERE ord-prod.nr-ord-produ = item-doc-orig-nfe.nr-ord-produ NO-LOCK NO-ERROR.


        IF AVAIL ord-prod AND (can-find(first natur-oper 
                               where natur-oper.nat-operacao = item-doc-orig-nfe.nat-operacao 
                               and   natur-oper.tipo-compra  =  4 /* Material Agregado. */ )) THEN DO:

            /* Se passou na validaá∆o posiciona o buffer no item corrente. */
            FIND FIRST bf-item-doc-orig-nfe OF bf{&TableName}
                where bf-item-doc-orig-nfe.it-codigo = ord-prod.it-codigo 
                and   bf-item-doc-orig-nfe.seq-item  = item-doc-orig-nfe.seq-item no-error.
            IF AVAIL bf-item-doc-orig-nfe THEN DO:

                /* Busca a sequencia do ultimo item do acabado gerado. */
                find last tt-movto-pend
                    where tt-movto-pend.tipo         = 1 /* Acabado. */
                    and   tt-movto-pend.cod-emitente = movto-pend-nfe.cod-emitente        
                    and   tt-movto-pend.nat-operacao = bf-item-doc-orig-nfe.nat-operacao  
                    and   tt-movto-pend.nro-docto    = bf{&TableName}.nro-docto           
                    and   tt-movto-pend.serie-docto  = bf{&TableName}.serie-docto no-error.
                if avail tt-movto-pend then
                    assign i-seq-acabado = tt-movto-pend.sequencia + IF param-re.inc-seq > 0 THEN param-re.inc-seq ELSE 10.
                else
                    assign i-seq-acabado = if avail param-re then param-re.seq-item-um else 1.

                CREATE tt-movto-pend.
                ASSIGN tt-movto-pend.cod-emitente   = movto-pend-nfe.cod-emitente
                       tt-movto-pend.cod-observa    = bf{&TableName}.cod-observa
                       tt-movto-pend.ct-codigo      = ord-prod.ct-codigo
                       tt-movto-pend.sc-codigo      = ord-prod.sc-codigo
                       tt-movto-pend.nat-operacao   = bf-item-doc-orig-nfe.nat-operacao
                       tt-movto-pend.nro-docto      = bf{&TableName}.nro-docto
                       tt-movto-pend.serie-docto    = bf{&TableName}.serie-docto
                       tt-movto-pend.tipo           = 1 /* Acabado */ 
                       tt-movto-pend.lote           = bf-item-doc-orig-nfe.lote-serie
                       tt-movto-pend.dt-vali-lote   = bf-item-doc-orig-nfe.dt-vali-lote
                       tt-movto-pend.cod-localiz    = bf-item-doc-orig-nfe.cod-localiz
                       tt-movto-pend.nr-ord-produ   = bf-item-doc-orig-nfe.nr-ord-produ
                       tt-movto-pend.it-codigo      = bf-item-doc-orig-nfe.it-codigo
                       tt-movto-pend.quantidade     = bf-item-doc-orig-nfe.qtd-interna
                       tt-movto-pend.cod-depos      = bf-item-doc-orig-nfe.cod-depos
                       tt-movto-pend.cod-refer      = bf-item-doc-orig-nfe.cod-refer
                       /* Conforme simulacao, o RE1001 nao sugere OC para o acabado. */
                       /*tt-movto-pend.num-pedido     = bf-item-doc-orig-nfe.num-pedido
                       tt-movto-pend.numero-ordem   = bf-item-doc-orig-nfe.numero-ordem
                       tt-movto-pend.parcela        = bf-item-doc-orig-nfe.parcela*/
                       tt-movto-pend.sequencia      = i-seq-acabado. /*bf-item-doc-orig-nfe.seq-item.*/ 

            end.
        end.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processaAgregado DBOProgram 
PROCEDURE processaAgregado :
/*------------------------------------------------------------------------------
  Purpose: Processa nota de entrada de agregado    
  Parameters: p-acao: Aá∆o (1 - Validaá∆o,
                            2 - Criaá∆o)
              p-agregado: Indica a presenáa de uma nota de agregaá∆o
              p-conta: Conta 
              p-sub-conta: Sub-Conta
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-acao           AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-conta          AS CHAR    NO-UNDO.
    DEFINE OUTPUT PARAMETER p-sub-conta      AS CHAR    NO-UNDO.

    CASE p-acao:

        /** VALIDA **/
        WHEN 1 THEN DO:

            FIND FIRST movto-pend-nfe
                WHERE movto-pend-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe NO-LOCK NO-ERROR.            
            
            IF      c-nom-prog-dpc-mg97  <> ""
                OR  c-nom-prog-upc-mg97  <> ""
                OR  c-nom-prog-appc-mg97 <> "" THEN DO:

                FOR EACH tt-epc exclusive-lock:
                    DELETE tt-epc.
                END.


                 /*** Criacao do registro para temp-table tt-epc ***/
                {include/i-epc200.i2 &CodEvent       ="'GerarQuebraOP'"
                                     &CodParameter   = "'Emitente'"
                                     &ValueParameter = STRING(bf{&TableName}.cod-emitente)}
                                     
                {include/i-epc200.i2 &CodEvent       = "'GerarQuebraOP'"
                                     &CodParameter   = "'Serie-docto'"
                                         &ValueParameter = bf{&TableName}.serie-docto}

                {include/i-epc200.i2 &CodEvent       = "'GerarQuebraOP'"
                                     &CodParameter   = "'Nro-docto'"
                                     &ValueParameter = bf{&TableName}.nro-docto}

                {include/i-epc200.i2 &CodEvent       = "'GerarQuebraOP'"
                                     &CodParameter   = "'Nat-operacao'"
                                     &ValueParameter = tt-natureza.nat-operacao}

                {include/i-epc200.i2 &CodEvent       = "'GerarQuebraOP'"
                                     &CodParameter   = "'chave-acesso'"
                                     &ValueParameter =  bf{&TableName}.ch-acesso-comp-nfe}

                {include/i-epc200.i2 &CodEvent       = "'GerarQuebraOP'"
                                     &CodParameter   = "'handle-bo'"
                                     &ValueParameter =  string(THIS-PROCEDURE)}                                         


                /*** Chamada do programa EPC ***/
                {include/i-epc201.i  "GerarQuebraOP" }



               FOR EACH  tt-epc
                   WHERE tt-epc.cod-event     = "Retorno-erro":U
                   AND   tt-epc.cod-parameter = "ERRO-EPC" no-lock:

                   CREATE tt-erro.
                   ASSIGN tt-erro.cd-erro   = 17006
                          tt-erro.desc-erro = tt-epc.val-parameter.


                    RETURN "NOK":U .
               END.
            END.

            /* Validaá∆o para criar a nota agregada corretamente **
            ** quando o documento tiver m£ltiplas naturezas      */
            if avail natur-oper
            and natur-oper.tipo-compra = 4 then do:
                IF AVAIL movto-pend-nfe THEN DO:

                    CREATE tt-movto-pend.
                    ASSIGN tt-movto-pend.cod-emitente   = movto-pend-nfe.cod-emitente
                           tt-movto-pend.cod-observa    = bf{&TableName}.cod-observa
                           tt-movto-pend.ct-codigo      = movto-pend-nfe.ct-codigo
                           tt-movto-pend.sc-codigo      = movto-pend-nfe.sc-codigo
                           tt-movto-pend.nat-comp       = tt-natureza.nat-operacao
                           tt-movto-pend.nat-operacao   = movto-pend-nfe.nat-operacao
                           tt-movto-pend.nro-comp       = bf{&TableName}.nro-docto
                           tt-movto-pend.nro-docto      = movto-pend-nfe.nro-docto
                           tt-movto-pend.serie-comp     = bf{&TableName}.serie-docto
                           tt-movto-pend.serie-docto    = movto-pend-nfe.serie-docto
                           tt-movto-pend.tipo           = 2 /* Agregado */ 
                           p-conta                      = movto-pend-nfe.ct-codigo
                           p-sub-conta                  = movto-pend-nfe.sc-codigo.
                END.
                ELSE DO:
                    ASSIGN p-conta          = "":U
                           p-sub-conta      = "":U.
                END.

            END.
        END.
        
        /** CRIA **/
        WHEN 2 THEN DO:
            
            if not valid-handle(h-boin223) then
               run inbo/boin223.p persistent set h-boin223.

            if can-find(first tt-movto-pend) then do:
                
                run openQueryStatic     in h-boin223 (input "Main":U) no-error.
                run setaCriaDocumento   in h-boin223 (input no).
                
                /* Gera o agregado e o acabado. */
                for each tt-movto-pend:
                    
                    run emptyRowErrors  in h-boin223.
                    run findDocumento   in h-boin223 (input tt-movto-pend.cod-emitente,
                                                      input tt-movto-pend.serie-docto,
                                                      input tt-movto-pend.nro-docto,
                                                      input tt-movto-pend.nat-operacao).

                    run findUsuario     in h-boin223.  
                    run newRecord       in h-boin223.  

                    create tt-movto-pend-aux.
                    buffer-copy tt-movto-pend TO tt-movto-pend-aux.
    
                    run emptyRowObject  in h-boin223.
                    run setRecord       in h-boin223 (input table tt-movto-pend-aux).
                    run validateRecord  in h-boin223 (input "CREATE":U).  
                    
                    delete tt-movto-pend-aux.
                    
                    if return-value = "NOK":U then do:
                    
                        run getRowErrors    in h-boin223 (output table RowErrors).
            
                        for each RowErrors:
                            create tt-erro.
                            assign tt-erro.cd-erro   = RowErrors.ErrorNumber
                                   tt-erro.desc-erro = RowErrors.ErrorDescription.                        
                        end.
                        return "NOK":U.
                    end.

                    run createRecord    in h-boin223.
                end.
                EMPTY TEMP-TABLE tt-movto-pend.
                
                
            end.
            if valid-handle(h-boin223) then do:
                delete procedure h-boin223.
                assign h-boin223 = ?.
           end.
        end.

    end case.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processaFisico DBOProgram 
PROCEDURE processaFisico :
/*------------------------------------------------------------------------------
  Purpose: Processa o documento do conversor para o recebimento f°sico    
  Parameters: pr-nota:              Rowid da nota de entrada (doc-orig-nfe)
              l-erro-doc-proc-fis:  Indica erro no processamento do documento
              l-erro-item-proc-fis: Indica erro no processamento no item do documento
              l-erro-rat-proc-fis:  Indica erro no processamento do rateio
              l-warning:            Indica presenáa de warnings no processamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pr-nota              AS ROWID      NO-UNDO.
    DEFINE OUTPUT PARAMETER l-erro-doc-proc-fis  AS LOGICAL    NO-UNDO.
    DEFINE OUTPUT PARAMETER l-erro-item-proc-fis AS LOGICAL    NO-UNDO.
    DEFINE OUTPUT PARAMETER l-erro-rat-proc-fis  AS LOGICAL    NO-UNDO.
    define output parameter l-warning            as logical    no-undo.

    {inbo/boin847.m2}
    
    // o return ok esta na include, pois foi adicionado o finally la tambem
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reprocessaNota DBOProgram 
PROCEDURE reprocessaNota :
/*------------------------------------------------------------------------------
  Purpose:     Reprocessa NF-e atravÇs da REAPI316
  Parameters:  pr-nota -> ROWID nota a ser processada
  Notes:       
------------------------------------------------------------------------------*/
    {inbo/boin847.m1}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarFiscalAPI DBOProgram 
PROCEDURE gerarFiscalAPI :
/*------------------------------------------------------------------------------
  Purpose:     Gera fiscal atravÇs da REAPI316, sera utilizado pela API rest
  Parameters:  chave de acesso da nota a ser processada
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-chaveAcessoNFe   AS CHAR             NO-UNDO.
    DEFINE OUTPUT PARAMETER l-docGerado        AS LOGICAL  INIT NO NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE iCodMsg AS INTEGER     NO-UNDO.
    RUN validacoesGeracao (INPUT c-chaveAcessoNFe).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN RETURN-VALUE.

    /* Se chegou ate aqui eh porque nao esta em processamento */
    /* Coloca em 'processamento' */
    RUN setProcessamento (INPUT c-chaveAcessoNFe, INPUT TRUE).

    if param-convrsr-nfe.log-valid-chave-aces-fisc then do: /* re0119 - marcado para validar chave na geracao fiscal */
        RUN validacaoChaveGeracaoDocto (INPUT c-chaveAcessoNFe,
                                        OUTPUT iCodMsg).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN setProcessamento (INPUT c-chaveAcessoNFe, INPUT FALSE). /* Retira do 'em processamento' */
            RETURN RETURN-VALUE.
        END.
    end.

    RUN reprocessaNota (INPUT rowid(doc-orig-nfe),
                        OUTPUT l-docGerado).
    IF param-convrsr-nfe.log-valid-chave-aces-fisc THEN DO: /* re0119 - marcado para validar chave na geracao fiscal */
       RUN ativarMensagensDocto (INPUT c-chaveAcessoNFe,
                                 INPUT iCodMsg).
    END.

    /* Retira do 'em processamento' */
    RUN setProcessamento (INPUT c-chaveAcessoNFe, INPUT FALSE).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processaFisicoAPI DBOProgram 
PROCEDURE processaFisicoAPI :
/*------------------------------------------------------------------------------
  Purpose:     Gera fiscal atravÇs da REAPI316, sera utilizado pela API rest
  Parameters:  chave de acesso da nota a ser processada
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-chaveAcessoNFe   AS CHAR             NO-UNDO.
    DEFINE OUTPUT PARAMETER l-docGerado        AS LOGICAL  INIT NO NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE iCodMsg              AS INTEGER  NO-UNDO.
    DEFINE VARIABLE l-erro-doc-proc-fis  AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE l-erro-item-proc-fis AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE l-erro-rat-proc-fis  AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE l-warning            AS LOGICAL  NO-UNDO.

    RUN validacoesGeracao (INPUT c-chaveAcessoNFe).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN RETURN-VALUE.
    
    RUN validaMultiNatOperRecFisico(INPUT c-chaveAcessoNFe).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN RETURN-VALUE.

    /* Se chegou ate aqui eh porque nao esta em processamento */
    /* Coloca em 'processamento' */
    RUN setProcessamento (INPUT c-chaveAcessoNFe, INPUT TRUE).

    if param-convrsr-nfe.log-valid-chave-aces-fisic then do: /* re0119 - marcado para validar chave na geracao fisico */
         RUN validacaoChaveGeracaoDocto (INPUT c-chaveAcessoNFe,
                                         OUTPUT iCodMsg).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN setProcessamento (INPUT c-chaveAcessoNFe, INPUT FALSE). /* Retira do 'em processamento' */
            RETURN RETURN-VALUE.
        END.
    end.

    RUN processaFisico (INPUT  ROWID(doc-orig-nfe),
                        OUTPUT l-erro-doc-proc-fis,
                        OUTPUT l-erro-item-proc-fis,
                        OUTPUT l-erro-rat-proc-fis,
                        OUTPUT l-warning).

    if param-convrsr-nfe.log-valid-chave-aces-fisic then do: /* re0119 - marcado para validar chave na geracao fisico */
       RUN ativarMensagensDocto (INPUT c-chaveAcessoNFe,
                                 INPUT iCodMsg).
    END.

    /* Retira do 'em processamento' */
    RUN setProcessamento (INPUT c-chaveAcessoNFe, INPUT FALSE).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviaMetricasAdicionais DBOProgram 
PROCEDURE enviaMetricasAdicionais :
/*------------------------------------------------------------------------------
  Purpose:     Envia as metricas adicionais para o LS
  Parameters:  Nenhum
  Notes:       Devera estar posicionada a doc-orig-nfe para que seja feito o envio
               O ponto de envio das metricas ficou definido como sendo na geracao
               do fisico e do fiscal
------------------------------------------------------------------------------*/

    IF NOT AVAIL doc-orig-nfe THEN
        RETURN "NOK":U.

    IF doc-orig-nfe.log-metric-env-ls THEN // metricas ja enviadas
        RETURN "NOK":U.

    RUN enviaMetricasAdicionaisComparativo.
    IF RETURN-VALUE = "OK":U THEN DO:
        FIND CURRENT doc-orig-nfe EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN doc-orig-nfe.log-metric-env-ls = TRUE.
        FIND CURRENT doc-orig-nfe NO-LOCK NO-ERROR. /* garantindo a retirada do lock */
        RETURN "OK":U.
    END.

    RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviaMetricasAdicionaisComparativo DBOProgram 
PROCEDURE enviaMetricasAdicionaisComparativo :
/*------------------------------------------------------------------------------
  Purpose:     Envia as metricas adicionais especificas do comparativo para o LS
  Parameters:  Nenhum
  Notes:       Devera estar posicionada a doc-orig-nfe para que seja feito o envio
------------------------------------------------------------------------------*/
    DEFINE VARIABLE rotinaMetricAdic               AS Routine          NO-UNDO.
    DEFINE VARIABLE subRotinaMetricAdic            AS Metric           NO-UNDO.
    DEFINE VARIABLE subRotinaMetricAdicTipoDiverg  AS Metric           NO-UNDO.
    DEFINE VARIABLE descTipoDiverg                 AS CHAR EXTENT 10   NO-UNDO.

    IF NOT AVAIL doc-orig-nfe THEN
        RETURN "NOK":U.

    IF doc-orig-nfe.idi-sit-diverg = 1 OR
       doc-orig-nfe.idi-sit-diverg = 2 OR
       doc-orig-nfe.idi-sit-diverg = 3 THEN DO:

        ASSIGN rotinaMetricAdic = new Routine("Comparativo_XML":U, "MRE":U).
        ASSIGN subRotinaMetricAdic = new Metric().
        CASE doc-orig-nfe.idi-sit-diverg:
            WHEN 1 THEN ASSIGN subRotinaMetricAdic:subRoutine = "1-Divergencias_nao_resolvidas":U.
            WHEN 2 THEN ASSIGN subRotinaMetricAdic:subRoutine = "2-Sem_divergencias":U.
            WHEN 3 THEN ASSIGN subRotinaMetricAdic:subRoutine = "3-Divergencias_resolvidas":U.
        END CASE.
        subRotinaMetricAdic:addDetail("recebimento-datasul_quantidade-xmls-validadas_total":U, 1). // registra no LS que houve a comparacao de uma NF-e

        FIND LAST item-doc-orig-nfe
            WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = doc-orig-nfe.ch-acesso-comp-nfe
              AND item-doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK NO-ERROR.
        IF AVAIL item-doc-orig-nfe THEN
            subRotinaMetricAdic:addDetail("recebimento-datasul_quantidade-de-itens-validados-no-xml_total":U, item-doc-orig-nfe.seq-item). // registra no LS a quantidade de itens da NF-e

        rotinaMetricAdic:addMetric(subRotinaMetricAdic).

        // Nao traduzir porque no LS nao deve enviar dado traduzido
        ASSIGN descTipoDiverg[1]  = "Preco":U.
        ASSIGN descTipoDiverg[2]  = "Quantidade":U.
        ASSIGN descTipoDiverg[3]  = "Dt_entrega":U.
        ASSIGN descTipoDiverg[4]  = "Cond_pagto_val":U.
        ASSIGN descTipoDiverg[5]  = "Cond_pagto_data":U.
        ASSIGN descTipoDiverg[6]  = "Transportadora":U.
        ASSIGN descTipoDiverg[7]  = "Fornecedor":U.
        ASSIGN descTipoDiverg[8]  = "Pend_Aprov":U.
        ASSIGN descTipoDiverg[9]  = "Estab_entrega":U.
        ASSIGN descTipoDiverg[10] = "Sem_pedido":U.

        EMPTY TEMP-TABLE tt-metricas-tip-diverg.
        FOR EACH doc-xml-compar FIELDS (idi-tip-compar seq-item) NO-LOCK
           WHERE doc-xml-compar.ch-acesso-comp-nfe = doc-orig-nfe.ch-acesso-comp-nfe
             AND doc-xml-compar.idi-tip-docto      = 1
           BREAK BY doc-xml-compar.idi-tip-compar 
                 BY doc-xml-compar.seq-item:

            IF FIRST-OF(doc-xml-compar.seq-item) THEN DO:
                FIND FIRST tt-metricas-tip-diverg
                     WHERE tt-metricas-tip-diverg.desc-tipo-diverg = descTipoDiverg[doc-xml-compar.idi-tip-compar] NO-ERROR.
                IF NOT AVAIL tt-metricas-tip-diverg THEN DO:
                    CREATE tt-metricas-tip-diverg.
                    ASSIGN tt-metricas-tip-diverg.desc-tipo-diverg = descTipoDiverg[doc-xml-compar.idi-tip-compar].
                END.
                ASSIGN tt-metricas-tip-diverg.quant-seq-item = tt-metricas-tip-diverg.quant-seq-item + 1.
            END.
        END.

        FOR EACH tt-metricas-tip-diverg:
            ASSIGN subRotinaMetricAdicTipoDiverg = new Metric(tt-metricas-tip-diverg.desc-tipo-diverg).
            // registra no LS a quantidade por tipo diverg
            subRotinaMetricAdicTipoDiverg:addDetail("recebimento-datasul_quantidade-de-itens-inconsistentes-na-validacao-dos-xmls_total":U, tt-metricas-tip-diverg.quant-seq-item).
            rotinaMetricAdic:addMetric(subRotinaMetricAdicTipoDiverg).
        END.

        IF rotinaMetricAdic:sendMetrics() THEN DO: // envia todas as metricas para o LS de uma so vez
            LOG-MANAGER:WRITE-MESSAGE("***Metricas comparativo enviadas com sucesso!") NO-ERROR.
            RETURN "OK":U.
        END.
        ELSE DO:
            LOG-MANAGER:WRITE-MESSAGE("***Erro envio metricas comparativo: " + STRING(rotinaMetricAdic:getMsgError())) NO-ERROR.
            LOG-MANAGER:WRITE-MESSAGE("***JSON metricas: " + STRING(rotinaMetricAdic:getJsonAsText())) NO-ERROR.
            RETURN "NOK":U.
        END.
    END.

    RETURN "NOK":U.
    FINALLY:
        DELETE OBJECT rotinaMetricAdic NO-ERROR.
        DELETE OBJECT subRotinaMetricAdic NO-ERROR.
        DELETE OBJECT subRotinaMetricAdicTipoDiverg NO-ERROR.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaMultiNatOperRecFisico DBOProgram 
PROCEDURE validaMultiNatOperRecFisico PRIVATE:
    DEFINE INPUT  PARAMETER pch-acesso-comp-nfe   AS CHAR  NO-UNDO.
    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    
    /** VERIFICA MAIS DE UMA NATUREZA DE OPERACAO **/
    IF l-mult-natur-receb = NO THEN DO:
       ASSIGN i-cont = 0.
       EMPTY TEMP-TABLE tt-natureza.

       FOR EACH  item-doc-orig-nfe FIELDS (nat-operacao int-2)
           WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = pch-acesso-comp-nfe
             AND item-doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK:

           IF NOT CAN-FIND(FIRST tt-natureza
                        WHERE tt-natureza.nat-operacao = item-doc-orig-nfe.nat-operacao) THEN DO:
            CREATE tt-natureza.
            ASSIGN tt-natureza.nat-operacao  = item-doc-orig-nfe.nat-operacao
                   tt-natureza.idi-tipo-oper = item-doc-orig-nfe.int-2
                   i-cont                    = i-cont + 1.
                
           END.

           IF i-cont > 1 THEN DO:
              {method/svc/errors/inserr.i &ErrorNumber="57051"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
           
              RETURN "NOK":U.
           END.
       END.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validacoesGeracao DBOProgram 
PROCEDURE validacoesGeracao PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:     Gera mensagem de erro se o documento esta em situacao invalida
               ou em processamento
  Parameters:  chave de acesso da nota
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-chaveAcessoNFe   AS CHAR             NO-UNDO.
    DEF VAR c-sit-txt AS CHAR NO-UNDO.

    RUN validacaoParametrosConversor.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RUN verificaEmProcessamento (INPUT c-chaveAcessoNFe). /* Verifica se ja esta em processamento */
    IF RETURN-VALUE = "NOK":U THEN /* documento ja esta em processamento ou nao esta avail */
        RETURN RETURN-VALUE.

    /* valida situacoes que nao pode ser executada a geracao */
    RUN validacaoSituacaoNfe.
    IF RETURN-VALUE = "NOK":U THEN DO:
        assign c-sit-txt = {ininc/i01in847.i 04 doc-orig-nfe.idi-situacao}.
        {method/svc/errors/inserr.i &ErrorNumber="57040"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U 
                                    &ErrorParameters="c-sit-txt"}
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validacaoSituacaoNfe DBOProgram 
PROCEDURE validacaoSituacaoNfe PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:     Retorna se o documento esta em situacao invalida
  Parameters:  chave de acesso da nota
------------------------------------------------------------------------------*/

    IF NOT AVAIL doc-orig-nfe AND AVAIL bf{&TableName} THEN // Para poder validar conforme o buffer
        FIND FIRST doc-orig-nfe WHERE ROWID(doc-orig-nfe) = ROWID(bf{&TableName}) NO-LOCK NO-ERROR.

    IF NOT AVAIL doc-orig-nfe THEN
        RETURN "NOK":U.

    RUN validacaoParametrosConversor.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    /* valida situacoes bloqueio */
    IF CAN-DO("1,3,5,6,7,8,9,10", STRING(doc-orig-nfe.idi-situacao)) THEN
        IF (doc-orig-nfe.idi-situacao = 5 /* Cancelada */ AND param-convrsr-nfe.log-bloq-nfe-cancda) OR 
            doc-orig-nfe.idi-situacao <> 5 THEN
            RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validacaoParametrosConversor DBOProgram 
PROCEDURE validacaoParametrosConversor:
/*------------------------------------------------------------------------------
  Purpose:     Valida se os parametros do conversor existem
------------------------------------------------------------------------------*/

    IF AVAIL param-convrsr-nfe THEN
        RETURN "OK":U.

    FIND FIRST param-convrsr-nfe NO-LOCK NO-ERROR.
    IF NOT AVAIL param-convrsr-nfe THEN DO:
        {utp/ut-liter.i Parametros_conversor_NF-e *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U 
                                    &ErrorParameters="RETURN-VALUE"}
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaEmProcessamento DBOProgram 
PROCEDURE verificaEmProcessamento :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se o documento esta em processamento e gera os erros caso
               nao esteja o registro disponivel ou ja em processamento
  Parameters:  chave de acesso da nota
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER c-chaveAcessoNFe   AS CHAR   NO-UNDO.

    FIND FIRST doc-orig-nfe
         WHERE doc-orig-nfe.ch-acesso-comp-nfe = c-chaveAcessoNFe
           AND doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK NO-ERROR.

    
    IF NOT AVAIL doc-orig-nfe THEN DO:
        {utp/ut-liter.i Documento_XML_NF-e *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U 
                                    &ErrorParameters="RETURN-VALUE + '~~~~' + c-chaveAcessoNFe"}
        RETURN "NOK":U.
    END.
  
    IF doc-orig-nfe.log-procmto THEN DO:

        IF INTERVAL (NOW, DATETIME(STRING(doc-orig-nfe.dat-process) + " " + doc-orig-nfe.hra-proces), "minutes":U) > 15 THEN // Ja faz mais de 15 minutos que esta em processamento
           RETURN "OK":U. // libera para que seja reprocessado 

        {method/svc/errors/inserr.i &ErrorNumber="57036"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U 
                                    &ErrorParameters="c-chaveAcessoNFe + '~~~~' + doc-orig-nfe.cod-usuar-proces + '~~~~' + string(doc-orig-nfe.dat-process) + ' ' + doc-orig-nfe.hra-proces"}
        RETURN "NOK":U.
    END.
    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setProcessamento DBOProgram 
PROCEDURE setProcessamento :
/*------------------------------------------------------------------------------
  Purpose:     Coloca o documento em processamento ou retira do processamento
  Parameters:  chave de acesso da nota
               l-processamento = yes/no
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-chaveAcessoNFe   AS CHAR             NO-UNDO.
    DEFINE INPUT  PARAMETER l-processamento    AS LOG              NO-UNDO.

    FIND FIRST doc-orig-nfe
         WHERE doc-orig-nfe.ch-acesso-comp-nfe = c-chaveAcessoNFe
           AND doc-orig-nfe.idi-orig-trad      = 2 EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAIL doc-orig-nfe THEN
        RETURN "NOK":U.

    ASSIGN doc-orig-nfe.log-procmto      = l-processamento
           doc-orig-nfe.cod-usuar-proces = c-seg-usuario
           doc-orig-nfe.dat-process      = TODAY
           doc-orig-nfe.hra-proces       = STRING(TIME,"HH:MM:SS").

    FIND CURRENT doc-orig-nfe NO-LOCK NO-ERROR. /* garantindo a retirada do lock */

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ativarMensagensDocto DBOProgram 
PROCEDURE ativarMensagensDocto PRIVATE:
    DEFINE INPUT PARAMETER pchaveAcessoNFe AS CHAR    NO-UNDO.
    DEFINE INPUT PARAMETER pCodMsg         AS INTEGER NO-UNDO.
     IF pCodMsg <> 0 THEN DO:
        /* A boin847 seta as mensagens criadas antes deste ponto como historico, portanto para  **
        ** esta validacao ser mostrada a mensagem deve ser gerada apos o processamento da nota. */

        FOR LAST msg-ret-nfe EXCLUSIVE-LOCK
           WHERE msg-ret-nfe.ch-acesso-comp-nfe = pchaveAcessoNFe
             AND msg-ret-nfe.idi-orig-trad      = 2
             AND msg-ret-nfe.cd-msg             = pCodMsg:
            ASSIGN msg-ret-nfe.log-ativo = YES. /* Atualiza para ativa a msg criada j† criada na BO */
        END.
        RELEASE msg-ret-nfe.
     END.
     RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validacaoChaveGeracaoDocto DBOProgram 
PROCEDURE validacaoChaveGeracaoDocto PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:     Deve ser usado somente na geracao do fiscal e fisico
               Executa a validacao da chave SEFAZ e cancela o docto se necessario
  Parameters:  chave de acesso da nota
  Notes:       param-convrsr-nfe e doc-orig-nfe deverao estar posicionados
  Return:      OK - continuar a geracao, NOK - nao continuar
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-chaveAcessoNFe   AS CHAR   NO-UNDO.
    DEFINE OUTPUT PARAMETER pCodMsg            AS INT    NO-UNDO.
    
    DEFINE VARIABLE i-cod-msg         as INT   NO-UNDO.
    DEFINE VARIABLE c-texto-msg       as CHAR  NO-UNDO.

    IF NOT AVAIL param-convrsr-nfe OR NOT AVAIL doc-orig-nfe THEN
        RETURN "NOK":U.
    
    RUN validaChaveSEFAZ (INPUT c-chaveAcessoNFe,
                          OUTPUT i-cod-msg,
                          OUTPUT c-texto-msg).        

    IF doc-orig-nfe.idi-situacao = 5 /* Cancelada */
       OR i-cod-msg = 52843 /* Cancelada SEFAZ */ THEN DO:
        IF param-convrsr-nfe.log-bloq-nfe-cancda THEN DO: /* re0119 - bloqueio nf cancelada, nao pode atualizar entao cancela */
            RUN cancelaDocumento (INPUT ROWID(doc-orig-nfe), ?). // Ajustado na procedure de cancelamento para nao jogar para historico a mensagem de consulta de chave cancelada - 52843
            RETURN "NOK":U.
        END.
    END.

    FOR FIRST param-re NO-LOCK 
    WHERE param-re.usuario = c-seg-usuario:
        IF  (i-cod-msg = 33140 OR i-cod-msg = 53045) /* Danfe invalido OU  NF nao consta na base da SEFAZ - pode ter sido emitida em contingencia */
        AND param-re.log-atual-nfe-danfe-invldo = NO THEN DO:  /* re0101 - Danfe invalido - nao atualiza */
            RETURN "NOK":U.
        END.
    END.
    ASSIGN pCodMsg = i-cod-msg.

    IF  i-cod-msg <> 0
    AND i-cod-msg <> 17006
    AND i-cod-msg <> 33140          /* Danfe Inv†lido */
    AND i-cod-msg <> 53045          /* NFE n∆o consta na base da SEFAZ */    
    AND i-cod-msg <> 52844          /* NFE Autorizada na SEFAZ */
    AND i-cod-msg <> 52843 THEN DO: /* NFE Cancelada na SEFAZ */
        {METHOD/svc/errors/inserr.i &ErrorNumber="i-cod-msg"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="c-texto-msg"}
        RETURN "NOK":U.                                
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inativarMensagensDocto DBOProgram 
PROCEDURE inativarMensagensDocto :
/*------------------------------------------------------------------------------
  Purpose:     Inativar as mensagens do documento
  Parameters:  chave de acesso da nota
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-chaveAcessoNFe   AS CHAR      NO-UNDO.

    FOR EACH msg-ret-nfe EXCLUSIVE-LOCK
       WHERE msg-ret-nfe.ch-acesso-comp-nfe = c-chaveAcessoNFe
         AND msg-ret-nfe.idi-orig-trad      = 2
         AND msg-ret-nfe.log-ativo:
        ASSIGN msg-ret-nfe.log-ativo = NO.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE engineRegras DBOProgram 
PROCEDURE engineRegras:
    DEFINE INPUT  PARAMETER c-chaveAcessoNFe   AS CHAR   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
    
    DEFINE VARIABLE c-situacao-txt AS CHARACTER   NO-UNDO.
    
    EMPTY TEMP-TABLE tt-doc-orig-nfe.

    FIND FIRST bf{&TableName} 
         WHERE bf{&TableName}.ch-acesso-comp-nfe = c-chaveAcessoNFe
           AND bf{&TableName}.idi-orig-trad      = 2 NO-LOCK NO-ERROR.

    IF NOT AVAIL bf{&TableName} THEN
        RETURN "NOK":U.

    IF bf{&TableName}.idi-situacao  = 2           /* 2 - Erro de Neg¢cio. */
    OR bf{&TableName}.idi-situacao  = 4           /* 4 - Eliminada.       */
    OR bf{&TableName}.idi-situacao  = 5 THEN DO:  /* 5 - Cancelada.       */

        CREATE tt-doc-orig-nfe.
        BUFFER-COPY bf{&TableName} TO tt-doc-orig-nfe.
       
        RUN rep/reapi319.p (INPUT TABLE tt-doc-orig-nfe,
                            INPUT "todos":U,
                            INPUT ?).    
        
        IF RETURN-VALUE = "OK":U THEN DO:
           {utp/ut-liter.i "Regras_aplicadas"}
           {method/svc/errors/inserr.i &ErrorNumber="32388" /*&1 com sucesso*/
                                       &ErrorType="EMS":U
                                       &ErrorSubType="INFORMATION":U
                                       &ErrorParameters="RETURN-VALUE"}
        END.

    END.
    ELSE DO:
        assign c-situacao-txt = {ininc/i01in847.i 04 bf{&TableName}.idi-situacao}.
        {method/svc/errors/inserr.i &ErrorNumber="57052"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U 
                                    &ErrorParameters="c-situacao-txt"}
        RETURN "NOK":U.

    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDocumento DBOProgram 
PROCEDURE retornaDocumento :
/*------------------------------------------------------------------------------
  Purpose: Retorna o Rowid da docum-est com base na chave     
  Parameters: pchave-acesso: Chave de acesso da NF-e
              pserie-docto:  SÇrie do documento
              pnro-docto:    N£mero do documento
              pcod-emitente: C¢digo do emitente
              pcnat-operacao: Natureza de operaÁ„o
              pr-docto:      Rowid do documento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pchave-acesso  LIKE doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT  PARAMETER pserie-docto   LIKE docum-est.serie-docto           NO-UNDO.
    DEFINE INPUT  PARAMETER pnro-docto     LIKE docum-est.nro-docto             NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-emitente  LIKE docum-est.cod-emitente          NO-UNDO.
    DEFINE INPUT  PARAMETER pcnat-operacao LIKE docum-est.nat-operacao          NO-UNDO.
    DEFINE OUTPUT PARAMETER pr-docto      AS ROWID                              NO-UNDO.

    DEFINE VARIABLE c-nat-operacao AS CHARACTER INIT ""  NO-UNDO.

    /* Buscar nota de retorno de beneficiamento para posicionar no RE1001 caso exista */
    FOR FIRST item-doc-orig-nfe WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = pchave-acesso AND
         CAN-FIND (FIRST natur-oper WHERE
                         natur-oper.nat-operacao = item-doc-orig-nfe.nat-operacao AND
                         natur-oper.terceiros = YES AND
                         natur-oper.tp-oper-terc = 2) NO-LOCK:

        ASSIGN c-nat-operacao = item-doc-orig-nfe.nat-operacao.
    END.

    IF c-nat-operacao = "" THEN DO:
        FOR FIRST docum-est 
            WHERE docum-est.serie-docto  = pserie-docto 
              AND docum-est.nro-docto    = pnro-docto 
              AND docum-est.cod-emitente = pcod-emitente
              and docum-est.nat-operacao = pcnat-operacao NO-LOCK:
        END.
    END.
    ELSE DO:
        FOR FIRST docum-est 
            WHERE docum-est.serie-docto  = pserie-docto 
              AND docum-est.nro-docto    = pnro-docto 
              AND docum-est.cod-emitente = pcod-emitente
              AND docum-est.nat-operacao = c-nat-operacao NO-LOCK:
        END.

        IF NOT AVAIL docum-est THEN DO:
            FOR FIRST docum-est 
                WHERE docum-est.serie-docto  = pserie-docto 
                  AND docum-est.nro-docto    = pnro-docto 
                  AND docum-est.cod-emitente = pcod-emitente NO-LOCK:
            END.
        END.
    END.

    IF NOT AVAIL docum-est AND pserie-docto = "0" THEN DO:
        FOR FIRST docum-est 
            WHERE docum-est.serie-docto  <= "1" 
              AND docum-est.nro-docto    = pnro-docto 
              AND docum-est.cod-emitente = pcod-emitente
              and docum-est.nat-operacao = pcnat-operacao NO-LOCK:
        END.
    END.

    IF AVAIL docum-est THEN
        ASSIGN pr-docto = ROWID(docum-est).
    ELSE
        ASSIGN pr-docto = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDocumentoFisico DBOProgram 
PROCEDURE retornaDocumentoFisico :
/*------------------------------------------------------------------------------
  Purpose: Retorna o Rowid da doc-fisico com base na chave     
  Parameters: pserie-docto:  SÇrie do documento e
              pnro-docto:    N£mero do documento
              pcod-emitente: C¢digo do emitente 
              
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-serie-docto  LIKE doc-fisico.serie-docto   NO-UNDO.
    DEFINE INPUT  PARAMETER p-nro-docto    LIKE doc-fisico.nro-docto     NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-emitente LIKE doc-fisico.cod-emitente  NO-UNDO.
    DEFINE OUTPUT PARAMETER pr-docto       AS ROWID                      NO-UNDO.

    find first doc-fisico NO-LOCK
        where doc-fisico.serie-docto  = p-serie-docto
        and   doc-fisico.nro-docto    = p-nro-docto
        and   doc-fisico.cod-emitente = p-cod-emitente no-error.

    IF NOT AVAIL doc-fisico THEN DO:
        IF p-serie-docto <= "0" THEN DO:

            find first doc-fisico NO-LOCK                                       
                where doc-fisico.serie-docto  < "1"            
                and   doc-fisico.nro-docto    = p-nro-docto              
                and   doc-fisico.cod-emitente = p-cod-emitente no-error. 
        END.
    END.

    IF AVAIL doc-fisico THEN
        ASSIGN pr-docto = ROWID(doc-fisico).
    ELSE
        ASSIGN pr-docto = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDocumentosDoc DBOProgram 
PROCEDURE retornaDocumentosDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM TABLE FOR tt-doc-orig-nfe-agrup.

    DEF VAR c-cod-emitente AS CHAR NO-UNDO.
    DEF VAR l-bloq-canc    AS LOG  NO-UNDO.

    EMPTY TEMP-TABLE tt-doc-orig-nfe-agrup.

    /* Retornar cod-emitente do documento */
    IF NOT VALID-HANDLE(h-boin859)
    OR h-boin859:TYPE      <> "PROCEDURE":U
    OR h-boin859:FILE-NAME <> "inbo/boin859.p":U THEN
        RUN inbo/boin859.p PERSISTENT SET h-boin859.

    RUN retornaEmitente IN h-boin859 (INPUT  c-ch-acesso-nfe,
                                      OUTPUT c-cod-emitente).

    IF VALID-HANDLE(h-boin859)         AND
        h-boin859:TYPE = "PROCEDURE":U AND
        h-boin859:FILE-NAME = "inbo/boin859.p":U THEN DO:
        DELETE PROCEDURE h-boin859.
        ASSIGN h-boin859 = ?.
    END.
    /* Fim retorno cod-emitente documento*/

    /* Retorno bloqueio nfe cancelada */
    IF NOT VALID-HANDLE(h-boin862) 
    OR h-boin862:TYPE      <> "PROCEDURE":U 
    OR h-boin862:FILE-NAME <> "inbo/boin862.p":U THEN
        RUN inbo/boin862.p PERSISTENT SET h-boin862.
        
    RUN openQueryStatic IN h-boin862 (INPUT "Main":U) NO-ERROR.
    RUN getFirst        IN h-boin862.
    RUN getLogField     IN h-boin862 (INPUT  "log-bloq-nfe-cancda":U,
                                      OUTPUT l-bloq-canc).

    IF VALID-HANDLE(h-boin862)         AND
        h-boin862:TYPE = "PROCEDURE":U AND
        h-boin862:FILE-NAME = "inbo/boin862.p":U THEN DO:
        DELETE PROCEDURE h-boin862.
        ASSIGN h-boin862 = ?.
    END.
    /* Fim retorno bloqueo nfe cancelada */
    
    documento:
    FOR EACH {&TableName} NO-LOCK
       WHERE {&TableName}.nro-docto     >= c-nro-docto-ini
         AND {&TableName}.nro-docto     <= c-nro-docto-fim
         AND {&TableName}.serie-docto   >= c-serie-docto-ini
         AND {&TableName}.serie-docto   <= c-serie-docto-fim
         AND {&TableName}.dt-emissao    >= dt-emissao-ini
         AND {&TableName}.dt-emissao    <= dt-emissao-fim
         AND {&TableName}.dt-transacao  >= dt-transacao-ini
         AND {&TableName}.dt-transacao  <= dt-transacao-fim
         AND {&TableName}.idi-orig-trad  = 2 /* Traduzido */
         AND {&TableName}.cod-emitente   = INT(c-cod-emitente)
         AND ({&TableName}.idi-situacao  = 2 OR /* Erro de neg¢cio */
              {&TableName}.idi-situacao  = 4 OR /* Eliminada */
              {&TableName}.idi-situacao  = 5)   /* Cancelada */:

        IF {&TableName}.idi-situacao = 5 /* Cancelada */ AND l-bloq-canc THEN
            NEXT documento.

        IF {&TableName}.ch-acesso-comp-nfe = c-ch-acesso-nfe THEN
            NEXT documento.

        FIND FIRST item-doc-orig-nfe NO-LOCK
             WHERE item-doc-orig-nfe.ch-acesso-comp-nfe  = {&TableName}.ch-acesso-comp-nfe
               AND item-doc-orig-nfe.idi-orig-trad       = {&TableName}.idi-orig-trad
               AND item-doc-orig-nfe.nat-operacao       >= c-nat-operacao-ini
               AND item-doc-orig-nfe.nat-operacao       <= c-nat-operacao-fim NO-ERROR.
        IF AVAIL item-doc-orig-nfe THEN DO:

            FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = item-doc-orig-nfe.nat-operacao
                   AND natur-oper.terceiros    = YES
                   AND natur-oper.tp-oper-terc = 2 NO-ERROR.
            IF AVAIL natur-oper THEN DO:

                CREATE tt-doc-orig-nfe-agrup.
                BUFFER-COPY doc-orig-nfe TO tt-doc-orig-nfe-agrup.
                ASSIGN tt-doc-orig-nfe-agrup.nat-oper      = item-doc-orig-nfe.nat-operacao
                       tt-doc-orig-nfe-agrup.desc-nat-oper = natur-oper.denominacao
                       tt-doc-orig-nfe-agrup.situacao      = doc-orig-nfe.idi-situacao 
                       tt-doc-orig-nfe-agrup.r-rowid       = ROWID(doc-orig-nfe).
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaNatComp DBOProgram 
PROCEDURE retornaNatComp :
/*---------------------------------------------------------------------------------------
  Purpose: Retorna a natureza complementar para o documento do Conversor NF-e conforme a chave
           do documento no recebimento
  Parameters:  
  c-chave-comp-nfe: Chave de acesso da NF-e
  i-cod-emitente  : C¢digo do emitente
  c-cod-estabel   : C¢digo do estabelecimento
  c-serie-docto   : SÇrie do documento
  c-nro-docto     : N£mero do documento
  c-nat-comp      : Natureza de operaá∆o complementar
                 
  Notes:  
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM c-chave-comp-nfe LIKE doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT  PARAM i-cod-emitente   LIKE doc-orig-nfe.cod-emitente       NO-UNDO.
    DEFINE INPUT  PARAM c-cod-estabel    LIKE doc-orig-nfe.cod-estabel        NO-UNDO.
    DEFINE INPUT  PARAM c-serie-docto    LIKE doc-orig-nfe.nro-docto          NO-UNDO.
    DEFINE INPUT  PARAM c-nro-docto      LIKE doc-orig-nfe.nro-docto          NO-UNDO.
    DEFINE INPUT  PARAM c-nat-operacao   AS CHARACTER                         NO-UNDO.
    DEFINE OUTPUT PARAM c-nat-comp       AS CHARACTER                         NO-UNDO.

    IF c-chave-comp-nfe <> "":U THEN
        find first bf{&TableName} NO-LOCK
            where bf{&TableName}.ch-acesso-comp-nfe = c-chave-comp-nfe
            and bf{&TableName}.idi-orig-trad        = 2 no-error.

    IF NOT AVAIL bf{&TableName} THEN DO:
        if trim(c-serie-docto) = "" then
            find first bf{&TableName} NO-LOCK 
                where bf{&TableName}.cod-emitente  = i-cod-emitente
                and   bf{&TableName}.cod-estabel   = c-cod-estabel 
                and   bf{&TableName}.nro-docto     = c-nro-docto
                and   bf{&TableName}.idi-orig-trad = 2
                and   bf{&TableName}.serie-docto   < "1" no-error.
        else
            find first bf{&TableName} NO-LOCK 
                where bf{&TableName}.cod-emitente  = i-cod-emitente
                and   bf{&TableName}.cod-estabel   = c-cod-estabel
                and   bf{&TableName}.serie-docto   = c-serie-docto
                and   bf{&TableName}.nro-docto     = c-nro-docto
                and   bf{&TableName}.idi-orig-trad = 2 no-error.
    END.

    /* Caso o documento existir retorna busca a natureza complementar nos itens */
    IF AVAIL  bf{&TableName} THEN DO:

        if not valid-handle(h-boin857) or
            h-boin857:type      <> "PROCEDURE":U or
            h-boin857:file-name <> "inbo/boin857.p":U THEN                    
            RUN inbo/boin857.p PERSISTENT SET h-boin857.
        
        RUN retornaNatComp IN h-boin857 (INPUT c-chave-comp-nfe,
                                         INPUT c-nat-operacao,
                                         OUTPUT c-nat-comp).
        
        IF  VALID-HANDLE(h-boin857)        AND
            h-boin857:TYPE = "PROCEDURE":U AND
            h-boin857:FILE-NAME = "inbo/boin857.p":U THEN DO:
            DELETE PROCEDURE h-boin857.
            ASSIGN h-boin857 = ?.
        END.
    END.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaNatFiscalItemConversor DBOProgram 
PROCEDURE retornaNatFiscalItemConversor :
/*------------------------------------------------------------------------------
  Purpose:     Buscar a natureza fiscal informada para o item no conversor.
  Parameters:  p-cCodEstabel  -> C¢digo do estabelecimento do documento;
               p-iCodEmitente -> C¢digo do emitente do documento;
               p-cDocumento   -> N£mero do documento;
               p-cSerie       -> SÇrie do documento;
               p-cItem        -> C¢digo do item;
               p-iSequencia   -> Sequància do item no conversor;
               p-cNaturOper   -> Retorna a natureza fiscal informada para o item
                                 no conversor NF-e (re0708).
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cCodEstabel  LIKE doc-orig-nfe.cod-estabel    NO-UNDO.
    DEFINE INPUT  PARAMETER p-iCodEmitente LIKE doc-orig-nfe.cod-emitente   NO-UNDO.
    DEFINE INPUT  PARAMETER p-cDocumento   LIKE doc-orig-nfe.nro-docto      NO-UNDO.
    DEFINE INPUT  PARAMETER p-cSerie       LIKE doc-orig-nfe.serie-docto    NO-UNDO.
    DEFINE INPUT  PARAMETER p-cItem        LIKE item-doc-orig-nfe.it-codigo NO-UNDO.
    DEFINE INPUT  PARAMETER p-iSequencia   LIKE item-doc-orig-nfe.seq       NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cNaturOper   LIKE natur-oper.nat-operacao     NO-UNDO.
                     
    FOR FIRST bf{&TableName} FIELDS (ch-acesso-comp-nfe idi-orig-trad) NO-LOCK
    	 WHERE bf{&TableName}.cod-estabel   = p-cCodEstabel 
    	   AND bf{&TableName}.cod-emitente  = p-iCodEmitente
    	   AND bf{&TableName}.nro-docto     = p-cDocumento 
           AND bf{&TableName}.serie-docto   = p-cSerie
           AND bf{&TableName}.idi-orig-trad = 2 : /* Reg. traduzido */
    END.
    	   
    IF  NOT AVAIL bf{&TableName} THEN
        RETURN "NOK":U.
    
    FOR EACH bf-item-doc-orig-nfe FIELDS (it-codigo seq-item nat-operacao) NO-LOCK
        WHERE bf-item-doc-orig-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
        AND   bf-item-doc-orig-nfe.idi-orig-trad      = bf{&TableName}.idi-orig-trad :
        
        IF  bf-item-doc-orig-nfe.it-codigo <> p-cItem OR bf-item-doc-orig-nfe.seq-item <> p-iSequencia THEN
            NEXT. /* Item diferente OU Sequencia diferente */
    	 
    	 ASSIGN p-cNaturOper = bf-item-doc-orig-nfe.nat-operacao.
    	 RETURN "OK":U.
    END.
    
    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaNatOperConversor DBOProgram 
PROCEDURE retornaNatOperConversor :
/*-------------------------------------------------------------------------------
  Purpose:     Quando o usu†rio informa um documento, verifica se o documento em 
  quest∆o existe no Conversor de NF-e, caso exista, sugere a natureza de operaá∆o
  deste documento
  Parameters:  p-iCodEmitente - entrada - c¢digo do Emitente da nota fiscal.
               p-cSerie       - entrada - sÇrie da nota fiscal.
               p-cDocumento   - entrada - n£mero da nota fiscal.
               p-cNaturOper   - sa°da   - natureza de operaá∆o da nota fiscal 
                                          que se encontra no conversor.
  Notes:       
-------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-iCodEmitente AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER p-cSerie       AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-cDocumento   AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-iTipoNota    AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cNaturOper   AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-iCodObserva  AS INTEGER     NO-UNDO.

    IF p-cDocumento = "0000000" OR p-cDocumento = "" THEN
        RETURN "NOK":U.

    FOR EACH doc-orig-nfe NO-LOCK
       WHERE doc-orig-nfe.cod-emitente  = p-iCodEmitente
         AND doc-orig-nfe.serie-docto   = p-cSerie
         AND doc-orig-nfe.nro-docto     = p-cDocumento
         AND doc-orig-nfe.idi-orig-trad = 2:

        IF doc-orig-nfe.idi-situacao  = 7 OR        /* Atualizada Receb. Fisico */ 
           doc-orig-nfe.idi-situacao  = 1 THEN DO:  /* Digitada Recebimento fiscal - Quando gerou mais de uma NF */		

            ASSIGN p-iCodObserva = doc-orig-nfe.cod-observa.

            FOR EACH item-doc-orig-nfe NO-LOCK
               WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = doc-orig-nfe.ch-acesso-comp-nfe
                 AND item-doc-orig-nfe.idi-orig-trad      = 2:

                ASSIGN p-cNaturOper = item-doc-orig-nfe.nat-operacao.
                IF item-doc-orig-nfe.int-2 = p-iTipoNota AND p-cNaturOper <> "" THEN
                    RETURN "OK":U.
            END.

            IF p-cNaturOper <> "" THEN
                RETURN "OK":U.
            ELSE
                RETURN "NOK":U.
        END.
    END.

    RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaNomeAbrev DBOProgram 
PROCEDURE retornaNomeAbrev :
/*------------------------------------------------------------------------------
  Purpose: Retorna o nome abreviado do emitente     
  Parameters: p-cod-emitente: C¢digo do emitente 
              p-nome-abrev:   Nome abreviado do emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAMETER p-cod-emitente LIKE emitente.cod-emitente NO-UNDO.
    DEF OUTPUT PARAMETER p-nome-abrev   LIKE emitente.nome-abrev   NO-UNDO.

    FOR FIRST emitente FIELDS (nome-abrev pais estado)
        WHERE emitente.cod-emitente = p-cod-emitente NO-LOCK:
    END.
    IF AVAIL emitente THEN
        ASSIGN p-nome-abrev = emitente.nome-abrev.
    ELSE 
        ASSIGN p-nome-abrev = "".

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaTipoDespDupli DBOProgram 
PROCEDURE retornaTipoDespDupli :
/*------------------------------------------------------------------------------
  Purpose: Retorna o tipo de despesa da duplicata     
  Parameters: pi-tp-despesa: Tipo de despesa da duplicata
  Notes:       
------------------------------------------------------------------------------*/
    
    define output param pi-tp-despesa as int no-undo.

    for first item-doc-orig-nfe fields(num-pedido numero-ordem) no-lock
        where item-doc-orig-nfe.ch-acesso-comp-nfe = doc-orig-duplic-nfe.ch-acesso-comp-nfe
        and   item-doc-orig-nfe.idi-orig-trad = 2
        and   item-doc-orig-nfe.num-pedido > 0:
        
    end.
    if  avail item-doc-orig-nfe then do:
        for first ordem-compra fields (tp-despesa) no-lock
            where ordem-compra.numero-ordem = item-doc-orig-nfe.numero-ordem:
        end.
        if  avail ordem-compra then             
            assign pi-tp-despesa = ordem-compra.tp-despesa.
            
    end.
    else do:
        for each doc-orig-nfe no-lock of doc-orig-duplic-nfe, 
            each item-doc-orig-nfe no-lock of doc-orig-nfe:
            
            for first rat-ordem
                fields ( cod-emitente serie-docto nro-docto nat-operacao numero-ordem )
                where rat-ordem.cod-emitente = doc-orig-nfe.cod-emitente
                and   rat-ordem.serie-docto  = doc-orig-nfe.serie-docto
                and   rat-ordem.nro-docto    = doc-orig-nfe.nro-docto
                and   rat-ordem.nat-operacao = item-doc-orig-nfe.nat-operacao 
                and   rat-ordem.numero-ordem <> 0 no-lock:
            end.
    
            if  avail rat-ordem then do:              
                for first ordem-compra 
                   fields ( tp-despesa )
                    where ordem-compra.numero-ordem = rat-ordem.numero-ordem no-lock:
                end.
                if  avail ordem-compra then             
                    assign pi-tp-despesa = ordem-compra.tp-despesa.
            end.
            else do:
                for first emitente fields(tp-desp-padrao) no-lock
                    where emitente.cod-emitente = doc-orig-nfe.cod-emitente:
                end.
                if  avail emitente then
                    assign pi-tp-despesa = emitente.tp-desp-padrao.
            end.                
        end.
    end.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaTtDigitaRe0402 DBOProgram 
PROCEDURE retornaTtDigitaRe0402 :
/*------------------------------------------------------------------------------
  Purpose:  retorna temp-tabel para carregar a tt-digita da programa re0402.   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pchave-acesso  LIKE doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT  PARAMETER pserie-docto   LIKE docum-est.serie-docto           NO-UNDO.
    DEFINE INPUT  PARAMETER pnro-docto     LIKE docum-est.nro-docto             NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-emitente  LIKE docum-est.cod-emitente          NO-UNDO.    
    DEFINE OUTPUT PARAMETER TABLE FOR tt-digita-re0402.
    
    EMPTY TEMP-TABLE tt-digita-re0402 NO-ERROR.    
    
    FOR EACH docum-est 
       WHERE docum-est.serie-docto              = pserie-docto 
         AND docum-est.nro-docto                = pnro-docto 
         AND docum-est.cod-emitente             = pcod-emitente NO-LOCK:             
        IF docum-est.cod-chave-aces-nf-eletro = pchave-acesso THEN DO:             
            CREATE tt-digita-re0402.
            ASSIGN tt-digita-re0402.cod-emitente = docum-est.cod-emitente
                   tt-digita-re0402.serie-docto  = docum-est.serie-docto
                   tt-digita-re0402.nro-docto    = docum-est.nro-docto
                   tt-digita-re0402.nat-operacao = docum-est.nat-operacao. 
        END. 
    END.         
        
    IF CAN-FIND(FIRST tt-digita-re0402) THEN
        RETURN "OK":U.
    ELSE
        RETURN "NOK":U.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDocumento DBOProgram 
PROCEDURE setConstraintDocumento :
/*------------------------------------------------------------------------------
  Purpose: Setar a chave do documento    
  Parameters: p-chave-acesso: Chave de acesso do documento
              p-idi-origem:   Origem do documento
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER p-chave-acesso LIKE item-doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEF INPUT PARAMETER p-idi-origem   LIKE item-doc-orig-nfe.idi-orig-trad      NO-UNDO.

    ASSIGN c-chave-acesso = p-chave-acesso
           i-idi-origem   = p-idi-origem  .

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDocumentosDoc DBOProgram 
PROCEDURE setConstraintDocumentosDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-nro-docto-ini     LIKE doc-orig-nfe.nro-docto         NO-UNDO.
    DEF INPUT PARAM p-nro-docto-fim     LIKE doc-orig-nfe.nro-docto         NO-UNDO.
    DEF INPUT PARAM p-serie-docto-ini   LIKE doc-orig-nfe.serie-docto       NO-UNDO.
    DEF INPUT PARAM p-serie-docto-fim   LIKE doc-orig-nfe.serie-docto       NO-UNDO.
    DEF INPUT PARAM p-nat-operacao-ini  LIKE item-doc-orig-nfe.nat-operacao NO-UNDO.
    DEF INPUT PARAM p-nat-operacao-fim  LIKE item-doc-orig-nfe.nat-operacao NO-UNDO.
    DEF INPUT PARAM p-dt-emissao-ini    LIKE doc-orig-nfe.dt-emissao        NO-UNDO.
    DEF INPUT PARAM p-dt-emissao-fim    LIKE doc-orig-nfe.dt-emissao        NO-UNDO.
    DEF INPUT PARAM p-dt-transacao-ini  LIKE doc-orig-nfe.dt-transacao      NO-UNDO.
    DEF INPUT PARAM p-dt-transacao-fim  LIKE doc-orig-nfe.dt-transacao      NO-UNDO.
    DEF INPUT PARAM p-ch-acesso-nfe     AS CHAR                             NO-UNDO.

    ASSIGN c-nro-docto-ini    = p-nro-docto-ini
           c-nro-docto-fim    = p-nro-docto-fim
           c-serie-docto-ini  = p-serie-docto-ini
           c-serie-docto-fim  = p-serie-docto-fim
           c-nat-operacao-ini = p-nat-operacao-ini
           c-nat-operacao-fim = p-nat-operacao-fim
           dt-emissao-ini     = p-dt-emissao-ini
           dt-emissao-fim     = p-dt-emissao-fim
           dt-transacao-ini   = p-dt-transacao-ini
           dt-transacao-fim   = p-dt-transacao-fim
           c-ch-acesso-nfe    = p-ch-acesso-nfe.
           
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMonitor DBOProgram 
PROCEDURE setConstraintMonitor :
/*------------------------------------------------------------------------------
  Purpose: Setar vari†veis utilizadas na abertura da query utilizada pelo monitor   
  Parameters: p-tg-digitada:
              p-digit-fisico:         Mostrar notas digitadas no recebimento f°sico
              p-tg-erro-neg:          Mostrar notas com erro de neg¢cio
              p-tg-atualizada:        Mostrar notas atualizadas no recebimento fiscal
              p-tg-eliminada:         Mostrar notas eliminadas
              p-tg-cancelada:         Mostrar notas canceladas
              p-tg-atualizada-fisico: Mostrar notas atualizas no recebimento f°sico
              p-tg-inutilizada:       Mostrar notas inutilizadas
              p-tg-validacao:         Mostrar notas em validaá∆o
              p-cod-emitente-ini:     C¢digo do emitente inicial a ser apresentado
              p-cod-emitente-fim:     C¢digo do emitente fainal a ser apresentado
              p-cod-estabel-ini:      C¢digo do estabelecimento inicial a ser apresentado
              p-cod-estabel-fim:      C¢digo do estabelecimento final a ser apresentado
              p-serie-ini:            SÇrie inicial dos documentos a serem apresentados
              p-serie-fim:            SÇrie final dos documentos  a serem apresentados
              p-nro-docto-ini:        N£mero do documento inicial a ser aprsentado
              p-nro-docto-fim:        N£mero do documento final a ser aprsentado  
              p-dt-emissao-ini:       Data de emiss∆o inicial das notas a serem apresentadas
              p-dt-emissao-fim:       Data de emiss∆o final das notas a serem apresentadas
              p-idi-orig-trad:        Origem dos documentos a serem apresentados    
              p-tg-gerado-romaneio:   Mostrar Notas que geraram Romaneios
                      
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-tg-digitada            AS LOGICAL                      NO-UNDO.
    DEFINE INPUT PARAM p-digit-fisico           AS LOGICAL                      NO-UNDO.
    DEFINE INPUT PARAM p-tg-erro-neg            AS LOGICAL                      NO-UNDO.
    DEFINE INPUT PARAM p-tg-atualizada          AS LOGICAL                      NO-UNDO.
    DEFINE INPUT PARAM p-tg-eliminada           AS LOGICAL                      NO-UNDO.
    DEFINE INPUT PARAM p-tg-cancelada           AS LOGICAL                      NO-UNDO.
    define input param p-tg-atualizada-fisico   as logical                      no-undo.
    define input param p-tg-inutilizada         as logical                      no-undo.
    DEFINE INPUT PARAM p-tg-validacao           AS LOGICAL                      NO-UNDO.
    DEFINE INPUT PARAM p-cod-emitente-ini       LIKE emitente.cod-emitente      NO-UNDO.
    DEFINE INPUT PARAM p-cod-emitente-fim       LIKE emitente.cod-emitente      NO-UNDO.
    DEFINE INPUT PARAM p-cod-estabel-ini        LIKE docum-est.cod-estabel      NO-UNDO.
    DEFINE INPUT PARAM p-cod-estabel-fim        LIKE docum-est.cod-estabel      NO-UNDO.
    DEFINE INPUT PARAM p-serie-ini              LIKE docum-est.serie-docto      NO-UNDO.
    DEFINE INPUT PARAM p-serie-fim              LIKE docum-est.serie-docto      NO-UNDO.
    DEFINE INPUT PARAM p-nro-docto-ini          LIKE docum-est.nro-docto        NO-UNDO.
    DEFINE INPUT PARAM p-nro-docto-fim          LIKE docum-est.nro-docto        NO-UNDO.
    DEFINE INPUT PARAM p-dt-emissao-ini         LIKE docum-est.dt-emissao       NO-UNDO.
    DEFINE INPUT PARAM p-dt-emissao-fim         LIKE docum-est.dt-emissao       NO-UNDO.
    DEFINE INPUT PARAM p-dt-transacao-ini       LIKE docum-est.dt-trans         NO-UNDO.
    DEFINE INPUT PARAM p-dt-transacao-fim       LIKE docum-est.dt-trans         NO-UNDO.
    DEFINE INPUT PARAM p-idi-orig-trad          LIKE doc-orig-nfe.idi-orig-trad NO-UNDO.
    DEFINE INPUT PARAM p-tg-gerado-romaneio     AS LOGICAL                      NO-UNDO.

    ASSIGN tg-digitada          = p-tg-digitada 
           tg-digit-fisico      = p-digit-fisico
           tg-erro-neg          = p-tg-erro-neg     
           tg-atualizada        = p-tg-atualizada   
           tg-eliminada         = p-tg-eliminada   
           tg-cancelada         = p-tg-cancelada   
           tg-atualizada-fisico = p-tg-atualizada-fisico
           tg-inutilizada       = p-tg-inutilizada
           tg-validacao         = p-tg-validacao
           c-cod-emitente-ini   = p-cod-emitente-ini
           c-cod-emitente-fim   = p-cod-emitente-fim
           c-cod-estabel-ini    = p-cod-estabel-ini 
           c-cod-estabel-fim    = p-cod-estabel-fim 
           c-serie-ini          = p-serie-ini       
           c-serie-fim          = p-serie-fim       
           c-nro-docto-ini      = p-nro-docto-ini   
           c-nro-docto-fim      = p-nro-docto-fim   
           dt-emissao-ini       = p-dt-emissao-ini  
           dt-emissao-fim       = p-dt-emissao-fim
           dt-transacao-ini     = p-dt-transacao-ini  
           dt-transacao-fim     = p-dt-transacao-fim
           i-idi-orig-trad      = p-idi-orig-trad
           tg-gerado-romaneio   = p-tg-gerado-romaneio.
        
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaChaveSEFAZ DBOProgram 
PROCEDURE validaChaveSEFAZ :
/*------------------------------------------------------------------------------
  Purpose: Valida nota na SEFAZ    
  Parameters:  pc-ch-acesso-comp-nfe: Chave de acesso da NF-e
               pi-cod-msg: Codigo da mensagem
               pc-texto-msg: Texto da mensagem
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-ch-acesso-comp-nfe like doc-orig-nfe.ch-acesso-comp-nfe no-undo.
    def output param pi-cod-msg            as int initial 0                     no-undo.
    def output param pc-texto-msg          as char                              no-undo.

    DEF VAR i-meio-validacao     AS INT INIT 0 NO-UNDO.
    DEF VAR cTpTrans             AS CHARACTER  NO-UNDO.

    find first bf{&TableName} no-lock
         where bf{&TableName}.ch-acesso-comp-nfe = pc-ch-acesso-comp-nfe
           and bf{&TableName}.idi-orig-trad      = 2 no-error.

    /* Nova tela que configura o tipo de integraá∆o da chave de acesso por estabelecimento (CD0360) */
    RUN cdp/cd0360b.p (INPUT bf{&TableName}.cod-estabel,
                       INPUT "ConsChave":U, /* Consulta Chave */
                       OUTPUT cTpTrans).

    CASE cTpTrans:
        WHEN "Nenhum":U THEN RETURN "OK":U.
        WHEN "TSS":U    THEN ASSIGN i-meio-validacao = 2.
        WHEN "TC":U     THEN ASSIGN i-meio-validacao = 2.
        WHEN "TC2":U    THEN ASSIGN i-meio-validacao = 3.
        WHEN "TPF":U    THEN ASSIGN i-meio-validacao = 3.
        OTHERWISE            ASSIGN i-meio-validacao = 99. /* N∆o configurado no CD0360 */
    END CASE.

    /* N∆o foi configurado o CD0360 - suavizaá∆o */
    IF i-meio-validacao = 99 THEN DO:
        DEF VAR l-integr-totvs-colab AS LOG  NO-UNDO.
        RUN cdp/cd0029a.p (output l-integr-totvs-colab).

        IF RETURN-VALUE >= "2.0":U THEN
            ASSIGN i-meio-validacao = 3. /* Colaboraá∆o Ass°ncrono (TC 2.0) */
        ELSE
            ASSIGN i-meio-validacao = 2. /* TSS - S°ncrono */
    END.

    IF i-meio-validacao = 3 THEN DO: /* TOTVS COLABORAÄ«O 2.0 - Ass°ncrono - Envio da mensagem consSitNFe ou consSitCTe */
        RUN rep/reapi331.p (INPUT TRIM(pc-ch-acesso-comp-nfe),
                            INPUT bf{&TableName}.cod-estabel,
                            INPUT i-meio-validacao,                /* 0-Nenhum; 1-EAI; 2-TSS; 3-Colaboraá∆o Ass°ncrono */
                            INPUT 1,                               /* Etapa s¢ Ç utilizado quando o i-meio-validacao = 3 (Ass°ncrono) */
                            INPUT "",                              /* S¢ Ç usado na integraá∆o via EAI - Neogrid */
                            OUTPUT TABLE tt_log_erro).
                            
        FOR FIRST tt_log_erro:
            
            {utp/ut-liter.i N∆o_foi_poss°vel_validar_a_chave_da_NF-e. *}            
            ASSIGN pi-cod-msg   = tt_log_erro.ttv_num_cod_erro
                   pc-texto-msg = RETURN-VALUE + "~~":U + tt_log_erro.ttv_des_msg_erro + " OPSYS: " + STRING(OPSYS).          
                               
            RETURN "NOK":U.
        END.                            
    END.

    RUN rep/reapi331.p (INPUT TRIM(pc-ch-acesso-comp-nfe),
                        INPUT bf{&TableName}.cod-estabel,
                        INPUT i-meio-validacao,                /* 0-Nenhum; 1-EAI; 2-TSS; 3-Colaboraá∆o Ass°ncrono */
                        INPUT 2,                               /* Etapa s¢ Ç utilizado quando o i-meio-validacao = 3 (Ass°ncrono) */
                        INPUT "",                              /* S¢ Ç usado na integraá∆o via EAI - Neogrid */
                        OUTPUT TABLE tt_log_erro).

    RUN inativarMensagensDocto (INPUT pc-ch-acesso-comp-nfe).

    FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
    IF NOT AVAIL tt_log_erro THEN RETURN "NOK":U.

    ASSIGN pi-cod-msg   = tt_log_erro.ttv_num_cod_erro
           pc-texto-msg = tt_log_erro.ttv_des_msg_erro.

    IF pi-cod-msg = 17006 THEN DO:
        {utp/ut-liter.i N∆o_foi_poss°vel_validar_a_chave_da_NF-e._Verifique_a_configuraá∆o_do_ambiente_de_integraá∆o. *}
        ASSIGN pc-texto-msg = RETURN-VALUE.
    END.

    IF tt_log_erro.ttv_des_msg_ajuda <> "" AND tt_log_erro.ttv_des_msg_ajuda <> ? THEN
        ASSIGN pc-texto-msg = pc-texto-msg + "~~":U + tt_log_erro.ttv_des_msg_ajuda.

    RUN implantaErro(INPUT pc-ch-acesso-comp-nfe,
                     INPUT pi-cod-msg,
                     INPUT pc-texto-msg,
                     INPUT 4).    /* Informacao */

    /* Cancelada ou Danfe invalido */
    if  pi-cod-msg = 52843 OR pi-cod-msg = 33140 THEN
        ASSIGN msg-ret-nfe.tipo-msg = 1. /* Erro */

    RELEASE msg-ret-nfe.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaDevolSimbolica DBOProgram 
PROCEDURE validaDevolSimbolica :
/*------------------------------------------------------------------------------
  Purpose:     Validar a natureza se Ç do tipo Devoluá∆o Consignaá∆o e Simb¢lica
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH item-doc-orig-nfe fields(int-2) NO-LOCK
       WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
         AND item-doc-orig-nfe.idi-orig-trad      = 2:
                 
        IF item-doc-orig-nfe.int-2 = 9 THEN /* Tipo operacao Devolucao Consig Simbol*/  
            RETURN "NOK":U. 
      
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaquantidade DBOProgram 
PROCEDURE validaquantidade :
/*------------------------------------------------------------------------------
  Purpose:    Colocar Pedido e Ordem de Compra por FIFO
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param l-ok-aux as log no-undo.
    def output param table for tt-erro.

    def var i-seq-erro  as int no-undo.

    DEFINE VARIABLE i-quant      AS DECIMAL  NO-UNDO.
    define variable i-seq-conv   as integer  no-undo.
    DEFINE VARIABLE l-sem-pedido AS LOGICAL NO-UNDO.

    assign l-ok-aux = yes
           i-seq-conv = 1.
     
    for each tt-item-doc-est NO-LOCK:
        
        for first item-doc-est NO-LOCK
            where item-doc-est.serie-docto  = tt-item-doc-est.serie-docto
              and item-doc-est.nro-docto    = tt-item-doc-est.nro-docto
              and item-doc-est.cod-emitente = tt-item-doc-est.cod-emitente
              and item-doc-est.nat-operacao = tt-item-doc-est.nat-operacao
              and item-doc-est.sequencia    = tt-item-doc-est.sequencia:
        END.
        
        run executarEngineRecSemPedido (INPUT INT(SUBSTRING(tt-item-doc-est.char-2,832,5)),
                                        output  l-sem-pedido).
        IF AVAIL item-doc-est AND 
           item-doc-est.numero-ordem = 0 AND 
           item-doc-est.log-1 AND
           NOT l-sem-pedido THEN DO:
            
            ASSIGN i-quant = 0.
            for each rat-ordem no-lock
               where rat-ordem.nro-docto    = item-doc-est.nro-docto
                 and rat-ordem.serie-docto  = item-doc-est.serie-docto
                 and rat-ordem.cod-emitente = item-doc-est.cod-emitente
                 and rat-ordem.nat-operacao = item-doc-est.nat-operacao
                 and rat-ordem.sequencia    = item-doc-est.sequencia:

               ASSIGN i-quant = i-quant + rat-ordem.quantidade.

            END.
            
            IF i-quant > item-doc-est.quantidade or 
               (i-quant < item-doc-est.quantidade and not l-sem-pedido ) THEN DO:

                assign l-ok-aux = no
                       i-seq-erro = i-seq-erro + 1.
                        
                /* Criaá∆o dos erros. */
                /* Validaá∆o para n∆o criar tt-erro replicada, 
                pois um erro pode ocorrer para mais de um registro. */
                do while can-find(first tt-erro 
                                  where tt-erro.identif-segment = string(i-seq-erro)):
                    assign i-seq-erro = i-seq-erro + 1.
                end.
            
                /* Calcula a sequencia do item no conversor. */
                assign i-seq-conv = IF INT(SUBSTRING(item-doc-est.char-2,832,5)) > 0 THEN INT(SUBSTRING(item-doc-est.char-2,832,5))
                                    ELSE item-doc-est.sequencia / if param-re.inc-seq > 0 then param-re.inc-seq else 10.

                create tt-erro.
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Total_das_ordens_de_compra_difere_da_quantidade_do_item" *}
                assign tt-erro.identif-segment  = string(i-seq-erro)
                       tt-erro.desc-erro        = RETURN-VALUE + " " + string(i-seq-conv) + "."
                       tt-erro.cd-erro          = 15455
                       i-seq-erro               = i-seq-erro + 1.

            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaSaldoTerc DBOProgram 
PROCEDURE validaSaldoTerc :
/*------------------------------------------------------------------------------
  Purpose: Validaá∆o de saldo em poder de terceiros    
  Parameters: l-ok-aux: Indica sucesso no processamento 
  Notes:       
------------------------------------------------------------------------------*/
    define output param l-ok-aux as logical initial yes no-undo.

    DEFINE VARIABLE lDevSimbConsig AS LOGICAL     NO-UNDO.

    if  avail natur-oper
    and {cdp/cd0066.i2 saldo-terc.cod-estabel}
    and natur-oper.tp-oper-terc = 4 /* Faturamento de Consignaá∆o*/ then do:

        for each  componente no-lock
            where componente.cod-emitente = saldo-terc.cod-emitente
            and   componente.nro-comp     = saldo-terc.nro-docto
            and   componente.serie-comp   = saldo-terc.serie-docto
            and   componente.nat-comp     = saldo-terc.nat-operacao
            and   componente.seq-comp     = saldo-terc.sequencia:

            FIND FIRST b-natur-oper NO-LOCK
                 WHERE b-natur-oper.nat-operacao = componente.nat-operacao NO-ERROR.
            IF  AVAIL b-natur-oper THEN DO:
                ASSIGN lDevSimbConsig  = {cdp/cd0066.i1 b-natur-oper componente}.
            END.
            ELSE
                ASSIGN lDevSimbConsig  = NO.

            IF lDevSimbConsig then do: /***Devoluá∆o Simb¢lica***/
                assign l-validar-qtde = no
                       de-soma-dev-simb = de-soma-dev-simb +
                              (componente.qtd-devol-simbol -
                               componente.qtd-fatur-consig -
                               componente.qtd-afatur-consig).
            end.

            IF AVAIL item-ref-nfe THEN DO:
                /* Necess†rio desconsiderar a quantidade alocada pelo conversor, 
                   pois esse valor j† foi atualizado no campo qtd-afatur-consig */

                ASSIGN de-soma-dev-simb = de-soma-dev-simb + item-ref-nfe.qtd-alocada.
            END.
        end.

        if de-soma-dev-simb < item-doc-orig-nfe.qtd-comercial  then do:
            /* Quantidade de Saldo em Terceiros Insuficiente para Sequencia */
            /* Busca descriá∆o do erro. N∆o Ç apresentada mensagem em tela. */

            create tt-erro.
            run utp/ut-msgs.p (input "HELP":U,
                               input 5934,
                               input item-doc-orig-nfe.seq-item).
            assign tt-erro.cd-erro   = 5934
                   tt-erro.desc-erro = return-value
                   l-ok-aux          = no.
        end.
    end.
    else do:
        if avail item-ref-nfe then do:
            if natur-oper.tp-oper-terc <> 6 /* Diferente de Reajuste de Preco */
            and saldo-terc.quantidade - (saldo-terc.dec-1 - item-ref-nfe.qtd-alocada) < item-ref-nfe.qtd-alocada then do:
                /* Quantidade de Saldo em Terceiros Insuficiente para Sequencia     */
                /* Busca a descriá∆o do erro. N∆o Ç apresentada mensagem em tela.   */

                create tt-erro.
                run utp/ut-msgs.p (input "HELP":U, 
                                   input 5934,
                                   input item-doc-orig-nfe.seq-item).
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Quantidade_de_Saldo_em_Terceiros_Insuficiente_para_Sequància" *}
                assign tt-erro.cd-erro   = 5934
                       tt-erro.desc-erro = RETURN-VALUE + " " + string(item-doc-orig-nfe.seq-item)
                       l-ok-aux          = no.
            end.
        end.
        else do:
            /* Validaá∆o do conversor mantida caso haja saldo-terc porÇm n∆o    **
            ** haja registro em item-ref-nfe.                                   */
            assign de-qtd-saldo = de-qtd-saldo + (saldo-terc.quantidade - saldo-terc.dec-1).
            if  de-qtd-saldo < item-doc-orig-nfe.qtd-comercial then do:
                /* Quantidade de Saldo em Terceiros Insuficiente para Sequencia     */
                /* Busca a descriá∆o do erro. N∆o Ç apresentada mensagem em tela.   */

                create tt-erro.
                run utp/ut-msgs.p (input "HELP":U,
                                   input 5934,
                                   input item-doc-orig-nfe.seq-item).
                
                assign tt-erro.cd-erro   = 5934
                       tt-erro.desc-erro = return-value
                       l-ok-aux          = no.
            end.
        end.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaSaldoTercTipoOperac DBOProgram
PROCEDURE validaSaldoTercTipoOperac:
/*------------------------------------------------------------------------------
 Purpose: Valida o saldo em terceiros para o recebimento fisico atravÈs do conversor.
          
 Notes:   Passa a usar o tipo de operacao para verificar se e reajsute de preco
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM l-ok-aux AS LOGICAL INITIAL YES NO-UNDO.
    
    IF AVAIL item-ref-nfe THEN DO:
        IF  tt-tipo-operacao.tipo-operac <> 12 /* Diferente de Reajuste de Preco */
        AND saldo-terc.quantidade - (saldo-terc.dec-1 - item-ref-nfe.qtd-alocada) < item-ref-nfe.qtd-alocada THEN DO:
            /* Quantidade de Saldo em Terceiros Insuficiente para Sequencia     */
            /* Busca a descriá∆o do erro. N∆o Ç apresentada mensagem em tela.   */
            CREATE tt-erro.
            run utp/ut-msgs.p (INPUT "HELP":U, 
                               INPUT 5934,
                               INPUT item-doc-orig-nfe.seq-item).
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Quantidade_de_Saldo_em_Terceiros_Insuficiente_para_Sequància" *}
            ASSIGN tt-erro.cd-erro   = 5934
                   tt-erro.desc-erro = RETURN-VALUE + " " + string(item-doc-orig-nfe.seq-item)
                   l-ok-aux          = NO.
        END.
    END.
    ELSE DO:
        /* Validaá∆o do conversor mantida caso haja saldo-terc porÇm n∆o    **
         ** haja registro em item-ref-nfe.                                   */
        ASSIGN de-qtd-saldo = de-qtd-saldo + (saldo-terc.quantidade - saldo-terc.dec-1).
        IF  de-qtd-saldo < item-doc-orig-nfe.qtd-comercial THEN DO:
            /* Quantidade de Saldo em Terceiros Insuficiente para Sequencia     */
            /* Busca a descriá∆o do erro. N∆o Ç apresentada mensagem em tela.   */
            CREATE tt-erro.
            RUN utp/ut-msgs.p (INPUT "HELP":U,
                               INPUT 5934,
                               INPUT item-doc-orig-nfe.seq-item).
            
            ASSIGN tt-erro.cd-erro   = 5934
                   tt-erro.desc-erro = RETURN-VALUE
                   l-ok-aux          = NO.
        END.
    END.
    
    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    IF pType = "UPDATE":U THEN DO:

        /** VALIDAÄ«O EMITENTE **/
        IF NOT CAN-FIND(FIRST emitente NO-LOCK
                        WHERE emitente.cod-emitente = RowObject.cod-emitente) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-emitente AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Emitente" *}
            ASSIGN c-lbl-liter-emitente = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-emitente"}
        END.
        ELSE DO:
            FOR FIRST emitente FIELDS(cgc)
                WHERE emitente.cod-emitente = RowObject.cod-emitente NO-LOCK:
                FOR FIRST bfdoc-orig-nfe FIELDS(cnpj cpf) NO-LOCK
                    WHERE bfdoc-orig-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
                      AND bfdoc-orig-nfe.idi-orig-trad      = 1: /* registro original */
                    /* 14976 - Alteracao para comparar se o campo CNPJ esta em branco tambem no caso de notas avulsas */
                    IF ((bfdoc-orig-nfe.cnpj <> ? AND bfdoc-orig-nfe.cnpj <> "") AND emitente.cgc <> bfdoc-orig-nfe.cnpj) OR
                       (bfdoc-orig-nfe.cpf  <> ? AND emitente.cgc <> bfdoc-orig-nfe.cpf) THEN DO:
                        
                        {method/svc/errors/inserr.i &ErrorNumber="57005"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="STRING(RowObject.cod-emitente) + '~~~~' + emitente.cgc + '~~~~' + if bfdoc-orig-nfe.cnpj = ? then '' else bfdoc-orig-nfe.cnpj + '~~~~' + if bfdoc-orig-nfe.cpf = ? then '' else bfdoc-orig-nfe.cpf" }
                    END.
                END.
            END.
        END.

        /** VALIDAÄ«O SERIE **/
        IF NOT CAN-FIND(FIRST serie NO-LOCK
                        WHERE serie.serie = RowObject.serie-docto) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-serie AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Serie" *}
            ASSIGN c-lbl-liter-serie = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-serie"}
        END.

        /** VALIDAÄ«O NATUREZA COMPLEMENTAR **/
        IF  RowObject.nat-oper-comp <> ""
        AND NOT CAN-FIND(FIRST natur-oper NO-LOCK
                        WHERE natur-oper.nat-operacao = RowObject.nat-oper-comp) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-natureza-complementar AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Natureza_Complementar" *}
            ASSIGN c-lbl-liter-natureza-complementar = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-natureza-complementar"}
        END.

        /** VALIDAÄ«O ESTABELECIMENTO **/
        IF NOT CAN-FIND(FIRST estabelec NO-LOCK
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-estabelecimento AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Estabelecimento" *}
            ASSIGN c-lbl-liter-estabelecimento = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-estabelecimento"}
        END.
        FIND FIRST estabelec 
             WHERE estabelec.cod-estabel = RowObject.cod-estabel NO-LOCK NO-ERROR.
        IF AVAIL estabelec THEN DO:                   
            FOR FIRST bf{&TableName} NO-LOCK
                WHERE bf{&TableName}.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
                  AND bf{&TableName}.idi-orig-trad      = 1:                  
                IF bf{&TableName}.cnpj-destino <> estabelec.cgc THEN DO:                    
     
                    {utp/ut-liter.i "destino" *}
                    {method/svc/errors/inserr.i &ErrorNumber="54356"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U 
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
                END.              
            END. 
        END.            

        /** VALIDAÄÂES DATAS **/
        IF  RowObject.dt-transacao > TODAY THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="1788"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U }
        END.

        IF RowObject.dt-transacao < RowObject.dt-emissao THEN DO:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-transacao AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Transaá∆o" *}
             ASSIGN c-lbl-liter-transacao = TRIM(RETURN-VALUE).
             DEFINE VARIABLE c-lbl-liter-emissao AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Emiss∆o" *}
             ASSIGN c-lbl-liter-emissao = TRIM(RETURN-VALUE).
             {method/svc/errors/inserr.i &ErrorNumber="89"
                                         &ErrorType="EMS":U
                                         &ErrorSubType="ERROR":U
                                         &ErrorParameters="c-lbl-liter-transacao + '~~~~' + c-lbl-liter-emissao"  }
        END.

        /* Data nao pode ser Inferior ao Ultimo Medio */
        IF NOT AVAIL param-estoq THEN
            FIND FIRST param-estoq NO-LOCK NO-ERROR.
        IF  param-estoq.tp-fech = 2 THEN DO:
            FIND FIRST estab-mat NO-LOCK WHERE estab-mat.cod-estabel = RowObject.cod-estabel NO-ERROR.
            IF AVAIL estab-mat AND 
                RowObject.dt-transacao <= estab-mat.mensal-ate THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="1586"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U }
            END.
        END.
        ELSE 
           IF  param-estoq.log-1 AND 
               RowObject.dt-transacao <= param-estoq.mensal-ate THEN DO:
               {method/svc/errors/inserr.i &ErrorNumber="1586"
                                           &ErrorType="EMS":U
                                           &ErrorSubType="ERROR":U }
           END.

        IF RowObject.mod-frete <> "" THEN DO:
            IF NOT CAN-FIND(FIRST modalid-frete 
                            WHERE modalid-frete.cod-modalid-frete = RowObject.mod-frete) THEN DO:
                {utp/ut-liter.i "Modalidade_de_Frete" *}
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="RETURN-VALUE" }
            END.
        END.
        
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaTipoMsg DBOProgram 
PROCEDURE validaTipoMsg :
/*------------------------------------------------------------------------------
  Purpose:     Valida o tipo da mensagem de acordo com o cadastro no EMS.
  Parameters:  pi-cod-msg, pi-tipo-msg.
  Notes:       Tipos: 1 - Erro; 2 - Aviso; 3 - Pergunta; 4 - Informaá∆o.
------------------------------------------------------------------------------*/
    
    define input param  pi-cod-msg  as integer no-undo.
    define output param pi-tipo-msg as integer no-undo.

    RUN utp/ut-msgs.p("codtype":U,pi-cod-msg,"").

    ASSIGN pi-tipo-msg = INT(RETURN-VALUE) NO-ERROR.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaTipoNota DBOProgram 
PROCEDURE validaTipoNota :
/*------------------------------------------------------------------------------
  Purpose:     Valida o tipo da nota a ser gerada no Fisico.
  Parameters:  pi-tipo-nota
  Notes:       O tipo da nota Ç 1 (Compra) por default!
------------------------------------------------------------------------------*/
    def output param pi-tipo-nota as int initial 1 no-undo.
    
    if not avail natur-oper then
        return.
    else do:
        if natur-oper.transf then
            assign pi-tipo-nota = 3. /* Transferencia */
        else do:
            
            /* O valor do tipo da nota na doc-fisico sempre ser† o valor do campo   **
            ** tp-oper-terc + 3, a n∆o ser que tp-oper-terc seja maior que 5        **
            ** (Reajuste Preáo e Drawback n∆o s∆o utilizados):                      **
            ** Segue tabela:
            **   ____________________________________________________________________
            **  |Valor de tp-oper-terc |Valor  de tipo-nota |     Tipo da nota       |
                |====================================================================|
                |          1           |          4         | Entrada Beneficiamento |
                |          2           |          5         | Retorno Beneficiamento |
                |          3           |          6         | Entrada Consignada     |
                |          4           |          7         | Fatura Consignada      |
                |          5           |          8         | Devolucao Consignada   |
                |          8           |         18         | Entrada Dep Fechado    |
                |          9           |         19         | Retorno Dep Fechado    |
                |         10           |         20         | Entrada Armaz Geral    |
                |         11           |         21         | Retorno Armaz Geral    |
                ----------------------------------------------------------------------
            */

            if natur-oper.terceiros 
            and natur-oper.tp-oper-terc < 6 then
                assign pi-tipo-nota = natur-oper.tp-oper-terc + 3.
            else do:
                if l-terceiros and natur-oper.tp-oper-terc >= 8 then do:
                    if natur-oper.tp-oper-terc = 8 then
                        assign pi-tipo-nota = 18.
                    else IF natur-oper.tp-oper-terc = 9 then
                        assign pi-tipo-nota = 19.
                    else IF natur-oper.tp-oper-terc = 10 then
                        assign pi-tipo-nota = 20.
                    else IF natur-oper.tp-oper-terc = 11 then
                        assign pi-tipo-nota = 21.
                end.
                else if natur-oper.nota-rateio then
                    assign pi-tipo-nota = 9. /* Nota de Rateio */
                else
                    /* Verifica se o tipo de compra Ç Devolucao Cliente */
                    if natur-oper.tipo-compra = 3 then
                        assign pi-tipo-nota = 2.
            end.
        end.
    end.
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaNaturezas DBOProgram 
PROCEDURE verificaNaturezas :
/*------------------------------------------------------------------------------
  Purpose:    Verificar se h† mais de uma natureza de operaá∆o 
  Parameters: pr-nota: Rowid da nota a ser verificada
              pch-acesso-comp-nfe: Chave de acesso
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pr-nota AS ROWID                                         NO-UNDO.
    DEFINE INPUT PARAMETER pch-acesso-comp-nfe LIKE doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    
    DEFINE VARIABLE i-cont            AS INTEGER                    NO-UNDO. 
    DEFINE VARIABLE oTipoOperacaoUtil AS rep.utils.TipoOperacaoUtil NO-UNDO. 
    DEFINE VARIABLE i-tipo-operacao   AS INTEGER                    NO-UNDO. 

    EMPTY TEMP-TABLE tt-natureza.

    /** VERIFICA MAIS DE UMA NATUREZA DE OPERACAO **/
    ASSIGN i-cont = 0.
    FOR EACH item-doc-orig-nfe FIELDS (nat-operacao int-2)
        WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = pch-acesso-comp-nfe
          AND item-doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK:

        IF NOT CAN-FIND(FIRST tt-natureza
                        WHERE tt-natureza.nat-operacao = item-doc-orig-nfe.nat-operacao) THEN DO:
            CREATE tt-natureza.
            ASSIGN tt-natureza.nat-operacao  = item-doc-orig-nfe.nat-operacao
                   tt-natureza.idi-tipo-oper = item-doc-orig-nfe.int-2
                   i-cont                    = i-cont + 1.
        END.

        IF i-cont > 1 THEN
            LEAVE.
    END.

    FOR FIRST bf{&TableName} EXCLUSIVE-LOCK
        WHERE ROWID(bf{&TableName}) = pr-nota:
        ASSIGN bf{&TableName}.log-multi-cfop = IF i-cont > 1 THEN YES ELSE NO.

        FIND FIRST tt-natureza NO-LOCK NO-ERROR. 
        IF AVAIL tt-natureza THEN DO:         
            IF tt-natureza.idi-tipo-oper = 0 THEN DO:
                ASSIGN oTipoOperacaoUtil = new rep.utils.TipoOperacaoUtil().
                ASSIGN i-tipo-operacao = oTipoOperacaoUtil:defaultTipoOper(INPUT tt-natureza.nat-operacao).
                DELETE OBJECT oTipoOperacaoUtil NO-ERROR.
            END.

            ASSIGN bf{&TableName}.cod-natur-operac = tt-natureza.nat-operacao
                   bf{&TableName}.idi-tip-operac = IF tt-natureza.idi-tipo-oper <> 0 THEN tt-natureza.idi-tipo-oper ELSE i-tipo-operacao.
        END. 
    END.
    RELEASE bf{&TableName}.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateRatLotTerc DBOProgram 
PROCEDURE CreateRatLotTerc :
/*------------------------------------------------------------------------------
  Purpose:    Criar rat-lote de acordo com os lotes das notas de origem dos saldos
              em poder de terceiros
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pr-nota        AS ROWID     NO-UNDO.
    DEFINE INPUT  PARAMETER table for tt-docum-est.
    DEFINE OUTPUT PARAMETER l-ok-aux       AS LOG       NO-UNDO.

    DEFINE VARIABLE d-quantidade-terc-aux AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-qtd-saldo-rat       AS DECIMAL     NO-UNDO.

    ASSIGN l-ok-aux = YES.

    FOR EACH item-doc-est NO-LOCK
       WHERE item-doc-est.serie-docto  = tt-docum-est.serie-docto
         AND item-doc-est.nro-docto    = tt-docum-est.nro-docto  
         AND item-doc-est.cod-emitente = tt-docum-est.cod-emitente
         AND item-doc-est.nat-operacao = tt-docum-est.nat-operacao:

        IF CAN-FIND(FIRST item
                    WHERE item.it-codigo = item-doc-est.it-codigo
                      AND (item.tipo-con-est = 3 OR item.tipo-con-est = 4)) THEN DO:

            /*elimina os registros da rat-lote para criaá∆o dos novos*/
            FOR EACH rat-lote EXCLUSIVE-LOCK
               WHERE rat-lote.cod-emitente = item-doc-est.cod-emitente
                 AND rat-lote.nro-docto    = item-doc-est.nro-docto
                 AND rat-lote.nat-operacao = item-doc-est.nat-operacao
                 AND rat-lote.serie-docto  = item-doc-est.serie-docto
                 AND rat-lote.sequencia    = item-doc-est.sequencia:

                 DELETE rat-lote.
            END.

            ASSIGN d-quantidade-terc-aux = item-doc-est.quantidade.

            IF CAN-FIND(FIRST fat-ser-lote
                        WHERE fat-ser-lote.cod-estabel = tt-docum-est.cod-estabel
                          AND fat-ser-lote.serie       = item-doc-est.serie-comp
                          AND fat-ser-lote.nr-nota-fis = item-doc-est.nro-comp
                          AND fat-ser-lote.nr-seq-fat  = item-doc-est.seq-comp) THEN DO:
                for each fat-ser-lote
                   where fat-ser-lote.cod-estabel = tt-docum-est.cod-estabel
                     and fat-ser-lote.serie       = item-doc-est.serie-comp
                     and fat-ser-lote.nr-nota-fis = item-doc-est.nro-comp
                     and fat-ser-lote.nr-seq-fat  = item-doc-est.seq-comp no-lock:

                    IF d-quantidade-terc-aux = 0 THEN LEAVE.

                    FOR EACH rat-saldo-terc 
                       WHERE rat-saldo-terc.serie-docto    = item-doc-est.serie-comp
                         AND rat-saldo-terc.nro-docto      = item-doc-est.nro-comp
                         AND rat-saldo-terc.nat-operacao   = item-doc-est.nat-comp
                         AND rat-saldo-terc.cod-emitente   = item-doc-est.cod-emitente
                         AND rat-saldo-terc.it-codigo      = item-doc-est.it-codigo
                         AND rat-saldo-terc.sequencia      = fat-ser-lote.nr-seq-fat
                         AND rat-saldo-terc.lote           = fat-ser-lote.nr-serlote 
                         AND rat-saldo-terc.quantidade     > 0
                         AND rat-saldo-terc.qtd-aloc-trans < rat-saldo-terc.quantidade EXCLUSIVE-LOCK: 

                         ASSIGN d-qtd-saldo-rat = rat-saldo-terc.quantidade - rat-saldo-terc.qtd-aloc-trans.

                         CREATE rat-lote.
                         assign rat-lote.serie-docto  = item-doc-est.serie-docto
                                rat-lote.nro-docto    = item-doc-est.nro-docto
                                rat-lote.nat-operacao = item-doc-est.nat-operacao
                                rat-lote.cod-emitente = item-doc-est.cod-emitente
                                rat-lote.sequencia    = item-doc-est.sequencia
                                rat-lote.it-codigo    = item-doc-est.it-codigo   
                                rat-lote.cod-refer    = item-doc-est.cod-refer
                                rat-lote.int-2        = 2
                                rat-lote.cod-depos    = IF item-doc-est.cod-depos   <> "" THEN item-doc-est.cod-depos   ELSE fat-ser-lote.cod-depos
                                rat-lote.cod-localiz  = IF item-doc-est.cod-localiz <> "" THEN item-doc-est.cod-localiz ELSE fat-ser-lote.cod-localiz
                                rat-lote.lote         = rat-saldo-terc.lote
                                rat-lote.dt-vali-lote = rat-saldo-terc.dt-vali-lote
                                rat-lote.quantidade   = IF d-qtd-saldo-rat < d-quantidade-terc-aux THEN d-qtd-saldo-rat ELSE d-quantidade-terc-aux
                                rat-lote.qtd-origin   = rat-lote.quantidade
                                d-quantidade-terc-aux = d-quantidade-terc-aux - rat-lote.quantidade
                                rat-saldo-terc.qtd-aloc-trans = rat-saldo-terc.qtd-aloc-trans + rat-lote.quantidade. /* Aloca a quantidade na rat-saldo-terc */

                         IF d-quantidade-terc-aux >= rat-saldo-terc.quantidade THEN NEXT. 

                         IF d-quantidade-terc-aux = 0  THEN LEAVE. 

                    END. /* rat-saldo-terc */ 
                END. /* fat-ser-lote */
            END. /*IF CAN-FIND(FIRST fat-ser-lote*/
            ELSE DO:
                FOR EACH rat-saldo-terc 
                   WHERE rat-saldo-terc.serie-docto    = item-doc-est.serie-comp
                     AND rat-saldo-terc.nro-docto      = item-doc-est.nro-comp
                     AND rat-saldo-terc.nat-operacao   = item-doc-est.nat-comp
                     AND rat-saldo-terc.cod-emitente   = item-doc-est.cod-emitente
                     AND rat-saldo-terc.it-codigo      = item-doc-est.it-codigo
                     AND rat-saldo-terc.sequencia      = item-doc-est.seq-comp
                     AND rat-saldo-terc.quantidade     > 0
                     AND rat-saldo-terc.qtd-aloc-trans < rat-saldo-terc.quantidade EXCLUSIVE-LOCK: 

                     ASSIGN d-qtd-saldo-rat = rat-saldo-terc.quantidade - rat-saldo-terc.qtd-aloc-trans.

                     CREATE rat-lote.
                     ASSIGN rat-lote.serie-docto  = item-doc-est.serie-docto
                            rat-lote.nro-docto    = item-doc-est.nro-docto
                            rat-lote.nat-operacao = item-doc-est.nat-operacao
                            rat-lote.cod-emitente = item-doc-est.cod-emitente
                            rat-lote.sequencia    = item-doc-est.sequencia
                            rat-lote.it-codigo    = item-doc-est.it-codigo   
                            rat-lote.cod-refer    = item-doc-est.cod-refer
                            rat-lote.int-2        = 2
                            rat-lote.cod-depos    = IF item-doc-est.cod-depos   <> "" THEN item-doc-est.cod-depos   ELSE rat-saldo-terc.cod-depos
                            rat-lote.cod-localiz  = IF item-doc-est.cod-localiz <> "" THEN item-doc-est.cod-localiz ELSE rat-saldo-terc.cod-localiz
                            rat-lote.lote         = rat-saldo-terc.lote
                            rat-lote.dt-vali-lote = rat-saldo-terc.dt-vali-lote
                            rat-lote.quantidade   = IF d-qtd-saldo-rat < d-quantidade-terc-aux THEN d-qtd-saldo-rat ELSE d-quantidade-terc-aux
                            rat-lote.qtd-origin   = rat-lote.quantidade
                            d-quantidade-terc-aux = d-quantidade-terc-aux - rat-lote.quantidade.

                     ASSIGN rat-saldo-terc.qtd-aloc-trans = rat-saldo-terc.qtd-aloc-trans + rat-lote.quantidade. /* Aloca a quantidade na rat-saldo-terc */

                     IF d-quantidade-terc-aux >= rat-saldo-terc.quantidade THEN NEXT. 

                     IF d-quantidade-terc-aux = 0  THEN LEAVE. 
                END. /* rat-saldo-terc */ 
            END.
        END. /* can-find item */
    END. /* item-doc-est*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowErrorsToMsgRetNFe DBOProgram 
PROCEDURE rowErrorsToMsgRetNFe :
/*------------------------------------------------------------------------------
  Purpose:    Gerar a tabela msg-ret-nfe recebendo uma RowErrors
  Parameters: c-ch-acesso-comp-nfe     - Chave de acesso da NF-e
              l-considera-erro-interno - Gerar msg-ret-nfe para erros internos?  (RowErrors.ErrorType = "INTERNAL")
              RowErrors                - Erros de negocio de BO ou API
  Notes:      
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER c-ch-acesso-comp-nfe  LIKE  item-doc-orig-nfe.ch-acesso-comp-nfe  NO-UNDO.
    DEFINE INPUT PARAMETER l-considera-erro-interno  AS LOG NO-UNDO. /* Por padrao passar YES */
    DEFINE INPUT PARAMETER table for RowErrors.

    FOR EACH RowErrors: 
        IF NOT l-considera-erro-interno
           AND RowErrors.ErrorType = "INTERNAL":U THEN NEXT. /* Desconsidera erros internos */

        RUN implantaErro(INPUT c-ch-acesso-comp-nfe,
                         INPUT RowErrors.errorNumber,
                         INPUT RowErrors.errorDescription,
                         INPUT IF RowErrors.ErrorSubType = "WARNING":U THEN 2 ELSE 1). /* 1-Erro, 2-Aviso */
        RELEASE msg-ret-nfe.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateRatComponente DBOProgram 
PROCEDURE CreateRatComponente :
/*------------------------------------------------------------------------------
  Purpose:    Criar rat-componente de acordo com sugest∆o da boin006
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pr-nota        AS ROWID                        NO-UNDO.
    DEFINE INPUT  PARAMETER table for tt-docum-est.
    DEFINE INPUT  PARAMETER pi-seq-item    LIKE item-doc-orig-nfe.seq-item NO-UNDO.
    DEFINE OUTPUT PARAMETER l-ok-aux       AS LOG                          NO-UNDO.

    ASSIGN l-ok-aux = YES.
    
    FOR FIRST bf{&TableName} exclusive-lock
        WHERE ROWID(bf{&TableName}) = pr-nota:

          if  not valid-handle ( h-boin006 ) then
              run inbo/boin006.p persistent set h-boin006.

          if  not valid-handle(h-boin010) then 
              run inbo/boin010.p persistent set h-boin010.

          run openQueryStatic in h-boin010 ( input "Main").

          FOR EACH item-ref-nfe NO-LOCK
             WHERE item-ref-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
               AND item-ref-nfe.seq-item           = pi-seq-item:

             FIND FIRST ITEM NO-LOCK
                  WHERE ITEM.it-codigo = item-ref-nfe.it-codigo NO-ERROR.
                  
             IF AVAIL ITEM AND (item.tipo-con-est = 3 OR item.tipo-con-est = 4) THEN DO:

                 FIND FIRST item-doc-orig-nfe NO-LOCK 
                      WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe 
                        AND item-doc-orig-nfe.seq-item           = item-ref-nfe.seq-item 
                        and item-doc-orig-nfe.idi-orig-trad      = 2 NO-ERROR.
    
                 IF NOT CAN-FIND(FIRST tt-rat-saldo-terc-dep                                      
                                 WHERE tt-rat-saldo-terc-dep.serie-docto  = item-ref-nfe.serie-docto     
                                   AND tt-rat-saldo-terc-dep.nro-docto    = item-ref-nfe.nro-docto       
                                   AND tt-rat-saldo-terc-dep.nat-operacao = item-ref-nfe.nat-operacao    
                                   AND tt-rat-saldo-terc-dep.cod-emitente = item-ref-nfe.cod-emitente    
                                   AND tt-rat-saldo-terc-dep.it-codigo    = item-ref-nfe.it-codigo) THEN                     
                                   
                 run getBatchRecordsOfDocumento in h-boin006 ( input  item-doc-orig-nfe.nat-operacao,
                                                               INPUT  item-ref-nfe.serie-docto, 
                                                               INPUT  item-ref-nfe.nro-docto,   
                                                               INPUT  item-ref-nfe.cod-emitente,
                                                               INPUT  item-ref-nfe.nat-operacao,
                                                               INPUT  bf{&TableName}.cod-estabel,  
                                                               INPUT  100,
                                                               OUTPUT TABLE tt-rat-saldo-terc-dep ).
    
                 FOR EACH tt-rat-saldo-terc-dep
                    WHERE tt-rat-saldo-terc-dep.serie-docto  = item-ref-nfe.serie-docto     
                    AND   tt-rat-saldo-terc-dep.nro-docto    = item-ref-nfe.nro-docto       
                    AND   tt-rat-saldo-terc-dep.nat-operacao = item-ref-nfe.nat-operacao    
                    AND   tt-rat-saldo-terc-dep.cod-emitente = item-ref-nfe.cod-emitente 
                    AND   tt-rat-saldo-terc-dep.sequencia    = item-ref-nfe.seq-saldo-terc
                    AND   tt-rat-saldo-terc-dep.it-codigo    = item-ref-nfe.it-codigo NO-lock:
                    
                    IF valid-handle(h-boin006) THEN 
                    RUN SugereQtdLote IN h-boin006 ( INPUT tt-rat-saldo-terc-dep.sequencia, 
                                                     INPUT tt-rat-saldo-terc-dep.it-codigo, 
                                                     INPUT tt-rat-saldo-terc-dep.nro-docto, 
                                                     INPUT item-ref-nfe.qtd-alocada,         /* Qtd que estou retornando */
                                                     INPUT-OUTPUT TABLE tt-rat-saldo-terc-dep).
    
                 END. /*for each tt-rat-saldo-terc-dep*/
  
                 FOR EACH tt-rat-saldo-terc-dep
                    WHERE tt-rat-saldo-terc-dep.serie-docto  = item-ref-nfe.serie-docto     
                    AND   tt-rat-saldo-terc-dep.nro-docto    = item-ref-nfe.nro-docto       
                    AND   tt-rat-saldo-terc-dep.nat-operacao = item-ref-nfe.nat-operacao    
                    AND   tt-rat-saldo-terc-dep.cod-emitente = item-ref-nfe.cod-emitente 
                    AND   tt-rat-saldo-terc-dep.it-codigo    = item-ref-nfe.it-codigo 
                    AND   tt-rat-saldo-terc-dep.sequencia    = item-ref-nfe.seq-saldo-terc
                    AND   tt-rat-saldo-terc-dep.qtd-digitada > 0 
		    NO-LOCK:
                    
                    IF valid-handle(h-boin006) THEN DO: 
                    
                        RUN validateSaldo IN h-boin006 ( INPUT tt-rat-saldo-terc-dep.serie-docto, 
                                                         INPUT tt-rat-saldo-terc-dep.nro-docto, 
                                                         INPUT tt-rat-saldo-terc-dep.cod-emitente, 
                                                         INPUT tt-rat-saldo-terc-dep.nat-operacao, 
                                                         INPUT tt-rat-saldo-terc-dep.it-codigo, 
                                                         INPUT tt-rat-saldo-terc-dep.cod-refer, 
                                                         INPUT tt-rat-saldo-terc-dep.sequencia, 
                                                         INPUT tt-rat-saldo-terc-dep.lote, 
                                                         INPUT tt-rat-saldo-terc-dep.qtd-digitada). 
                    END.
                    
                                                      
                    IF RETURN-VALUE <> "NOK":U THEN DO:
                                            
                       for each tt-rat-componente:
                           delete tt-rat-componente.
                       end.
    
                       CREATE tt-rat-componente.
                       ASSIGN tt-rat-componente.serie-docto  = bf{&TableName}.serie-docto  
                              tt-rat-componente.nro-docto    = bf{&TableName}.nro-docto  
                              tt-rat-componente.cod-emitente = bf{&TableName}.cod-emitente 
                              tt-rat-componente.it-codigo    = tt-rat-saldo-terc-dep.it-codigo 
                              tt-rat-componente.cod-refer    = tt-rat-saldo-terc-dep.cod-refer
                              tt-rat-componente.cod-depos    = tt-rat-saldo-terc-dep.cod-depos   
                              tt-rat-componente.cod-localiz  = tt-rat-saldo-terc-dep.cod-localiz
                              tt-rat-componente.lote         = tt-rat-saldo-terc-dep.lote
                              tt-rat-componente.dt-vali-lote = tt-rat-saldo-terc-dep.dt-vali-lote
                              tt-rat-componente.quantidade   = tt-rat-saldo-terc-dep.qtd-digitada
                              tt-rat-componente.nro-comp     = item-ref-nfe.nro-docto
                              tt-rat-componente.serie-comp   = item-ref-nfe.serie-docto
                              tt-rat-componente.nat-comp     = item-ref-nfe.nat-operacao
                              tt-rat-componente.seq-comp     = tt-rat-saldo-terc-dep.sequencia
                              tt-rat-componente.emite-comp   = item-ref-nfe.cod-emitente
                              tt-rat-componente.componente   = 2.
                           
                       FOR EACH item-doc-est NO-LOCK
                          WHERE item-doc-est.serie-docto  = bf{&TableName}.serie-docto
                            AND item-doc-est.nro-docto    = bf{&TableName}.nro-docto
                            AND item-doc-est.cod-emitente = bf{&TableName}.cod-emitente
                            AND item-doc-est.nro-comp     = item-ref-nfe.nro-docto    
                            AND item-doc-est.serie-comp   = item-ref-nfe.serie-docto    
                            AND item-doc-est.nat-comp     = item-ref-nfe.nat-operacao   
                            AND item-doc-est.seq-comp     = item-ref-nfe.seq-saldo-terc 
                            AND item-doc-est.emite-comp   = item-ref-nfe.cod-emitente:
                            IF INT(SUBSTRING(item-doc-est.char-2,832,5)) = item-ref-nfe.seq-item then
                                ASSIGN tt-rat-componente.sequencia    = item-doc-est.sequencia
                                       tt-rat-componente.nat-operacao = item-doc-est.nat-operacao.
                       END.


                       RUN updateQtdAloc IN h-boin006 (INPUT tt-rat-componente.serie-comp,     
                                                       INPUT tt-rat-componente.nro-comp, 
                                                       INPUT tt-rat-componente.nat-comp, 
                                                       INPUT tt-rat-componente.seq-comp ,
                                                       INPUT tt-rat-componente.emite-comp, 
                                                       INPUT tt-rat-componente.it-codigo, 
                                                       INPUT tt-rat-componente.cod-refer, 
                                                       INPUT tt-rat-componente.lote, 
                                                       INPUT "aloca", 
                                                       INPUT tt-rat-componente.quantidade).
    
                       find first rowErrors no-lock no-error.
                              
                       run emptyRowObject in h-boin010.
                       run emptyRowErrors in h-boin010.                    
                            
                       run setRecord      in h-boin010 ( input table tt-rat-componente ).
                       run createRecord   in h-boin010. /* Cria tabela rat-componente */
            
                       run getRowErrors in h-boin010 ( output table rowErrors ).
            
                       find first rowErrors no-lock no-error.
                       if  avail rowErrors and
                                 rowErrors.ErrorSubType = "ERROR":U then do:
                           ASSIGN l-ok-aux = NO.
                       end.
                         
                    END.  /* return-value = ok */
                 END. /* FOR EACH tt-rat-saldo-terc-dep */
             END. /*IF AVAIL ITEM*/
          END. /* for each item-ref-nfe*/           
    END.   /*FOR FIRST bf{&TableName}*/         

    IF  VALID-HANDLE(h-boin006) THEN DO:
        DELETE PROCEDURE h-boin006 NO-ERROR.
        ASSIGN h-boin006 = ?.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelaDocumentoAPI DBOProgram 
PROCEDURE cancelaDocumentoAPI :
/*------------------------------------------------------------------------------
  Purpose: Cancela o documento    
  Parameters:  pr-nota: Rowid da nota a ser cancelada
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-chaveAcessoNFe   AS CHAR             NO-UNDO.
    DEFINE INPUT  PARAMETER c-motivo           AS CHAR             NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE c-sit-txt   AS CHARACTER   NO-UNDO.

    RUN validacaoParametrosConversor.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RUN verificaEmProcessamento (INPUT c-chaveAcessoNFe). /* Verifica se ja esta em processamento */
    IF RETURN-VALUE = "NOK":U THEN /* documento ja esta em processamento ou nao esta avail */
        RETURN RETURN-VALUE.

    IF doc-orig-nfe.idi-situacao <> 2 AND
       doc-orig-nfe.idi-situacao <> 4 THEN DO:

        ASSIGN c-sit-txt = {ininc/i01in847.i 04 doc-orig-nfe.idi-situacao}.
        {method/svc/errors/inserr.i &ErrorNumber="57050"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-sit-txt"}
        RETURN "NOK":U.
    END.

    RUN inativarMensagensDocto (INPUT c-chaveAcessoNFe).
    IF param-convrsr-nfe.log-justif-cancel THEN DO: /* Motivo cancelamento obrigatorio */
        IF (c-motivo = ? OR TRIM(c-motivo) = "") THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="57451"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}

            RUN implantaErroConfCadastroMsg(INPUT c-chaveAcessoNFe,
                                            INPUT 57451,
                                            INPUT "",
                                            INPUT 1).
            RETURN "NOK":U.
        END.

        IF LENGTH(TRIM(c-motivo)) < 15 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="57452"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}

            RUN implantaErroConfCadastroMsg(INPUT c-chaveAcessoNFe,
                                            INPUT 57452,
                                            INPUT "",
                                            INPUT 1).
            RETURN "NOK":U.
        END.
    END.

    RUN setProcessamento (INPUT c-chaveAcessoNFe, INPUT TRUE).

    RUN cancelaDocumento(INPUT ROWID(doc-orig-nfe),
                         INPUT c-motivo).
    IF RETURN-VALUE = "OK":U THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="19531"
                                    &ErrorType="EMS"
                                    &ErrorSubType="INFORMATION"
                                    &ErrorParameters="doc-orig-nfe.cod-estabel + '~~~~' + doc-orig-nfe.serie-docto + '~~~~' + doc-orig-nfe.nro-docto"}
    END.

    /* Retira do 'em processamento' */
    RUN setProcessamento (INPUT c-chaveAcessoNFe, INPUT FALSE).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EliminaNFeAPI DBOProgram 
PROCEDURE EliminaNFeAPI :
/*------------------------------------------------------------------------------
  Purpose: Cancela o documento    
  Parameters:  pr-nota: Rowid da nota a ser cancelada
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-chaveAcessoNFe   AS CHAR             NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE c-sit-txt   AS CHARACTER   NO-UNDO.

    RUN verificaEmProcessamento (INPUT c-chaveAcessoNFe). /* Verifica se ja esta em processamento */
    IF RETURN-VALUE = "NOK":U THEN /* documento ja esta em processamento ou nao esta avail */
        RETURN RETURN-VALUE.

    FOR FIRST param-estoq NO-LOCK:
    END.

    IF  doc-orig-nfe.idi-situacao <> 9 AND
        doc-orig-nfe.idi-situacao <> 5 AND
        doc-orig-nfe.idi-situacao <> 8 THEN DO:

        ASSIGN c-sit-txt = {ininc/i01in847.i 04 doc-orig-nfe.idi-situacao}.
        {method/svc/errors/inserr.i &ErrorNumber="57054"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U 
                                    &ErrorParameters="c-sit-txt"}
        RETURN "NOK":U.
    END.

    RUN EliminaNFe (INPUT doc-orig-nfe.ch-acesso-comp-nfe).  
    IF RETURN-VALUE = "NOK":U THEN
        RETURN RETURN-VALUE.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaChaveSEFAZAPI DBOProgram 
PROCEDURE validaChaveSEFAZAPI:
/*------------------------------------------------------------------------------
  Purpose:     Deve ser usado somente na geracao do fiscal e fisico
               Executa a validacao da chave SEFAZ e cancela o docto se necessario
  Parameters:  chave de acesso da nota
  Notes:       param-convrsr-nfe e doc-orig-nfe deverao estar posicionados
  Return:      OK - continuar a geracao, NOK - nao continuar
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-chaveAcessoNFe   AS CHAR   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE i-cod-msg         as INT   NO-UNDO.
    DEFINE VARIABLE c-texto-msg       as CHAR  NO-UNDO.
    DEFINE VARIABLE cTpTrans          AS CHAR  NO-UNDO.

    FIND FIRST doc-orig-nfe
         WHERE doc-orig-nfe.ch-acesso-comp-nfe = c-chaveAcessoNFe
           AND doc-orig-nfe.idi-orig-trad      = 2 EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAIL doc-orig-nfe THEN DO:
        {utp/ut-liter.i Documento_XML_NF-e *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U 
                                    &ErrorParameters="RETURN-VALUE + '~~~~' + c-chaveAcessoNFe"}
        RETURN "NOK":U.                            
    END.
        
    RUN validaChaveSEFAZ (INPUT c-chaveAcessoNFe,
                          OUTPUT i-cod-msg,
                          OUTPUT c-texto-msg).
       
    IF  i-cod-msg       <> 0
    AND RETURN-VALUE    =  "NOK":U THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="i-cod-msg"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U 
                                    &ErrorParameters="c-texto-msg"}
                                    
        RETURN "NOK":U.                                    
    
    END.
    ELSE DO :
   
         /* Nova tela que configura o tipo de integraá∆o da chave de acesso por estabelecimento (CD0360) */
        RUN cdp/cd0360b.p (INPUT doc-orig-nfe.cod-estabel,
    					   INPUT "ConsChave":U, /* Consulta Chave */
    					   OUTPUT cTpTrans).
        IF cTpTrans = "Nenhum":U THEN DO:
           {method/svc/errors/inserr.i &ErrorNumber="57100"
                                       &ErrorType="EMS":U
                                       &ErrorSubType="ERROR":U}
        END.
    END.
    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE conferido DBOProgram 
PROCEDURE conferir :
/*------------------------------------------------------------------------------
  Purpose: Alteraá∆o conferido
  Parameters:  pch-acesso-comp-nfe: Chave de acesso do documento
               plog-confer: Conferido: Sim ou N∆o
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pch-acesso-comp-nfe LIKE doc-orig-nfe.ch-acesso-comp-nfe    NO-UNDO.
    DEFINE INPUT  PARAMETER plog-confer         LIKE doc-orig-nfe.log-confer            NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    EMPTY TEMP-TABLE RowErrors.

    FOR FIRST bf{&TableName}
        WHERE bf{&TableName}.ch-acesso-comp-nfe = pch-acesso-comp-nfe 
        AND   bf{&TableName}.idi-orig-trad = 2 EXCLUSIVE-LOCK:
        ASSIGN bf{&TableName}.log-confer = plog-confer.
    END.
    FIND CURRENT bf{&TableName} NO-LOCK NO-ERROR.
    
    IF NOT AVAIL bf{&TableName} THEN DO:
        {utp/ut-liter.i "Documento" *}      
        {method/svc/errors/inserr.i    
        &ErrorNumber="2"               
        &ErrorType="EMS"               
        &ErrorSubType="ERROR"          
        &ErrorParameters= RETURN-VALUE}
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE considEndNfSaida DBOProgram 
PROCEDURE considEndNfSaida :
/*------------------------------------------------------------------------------
  Purpose: Alteraá∆o conferido
  Parameters:  pch-acesso-comp-nfe: Chave de acesso do documento
               plog-confer: Conferido: Sim ou N∆o
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pch-acesso-comp-nfe         LIKE doc-orig-nfe.ch-acesso-comp-nfe    NO-UNDO.
    DEFINE INPUT  PARAMETER plog-consid-ender-nf-saida  LIKE doc-orig-nfe.log-consid-ender-nf-saida            NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    EMPTY TEMP-TABLE RowErrors.

    FOR FIRST bf{&TableName}
        WHERE bf{&TableName}.ch-acesso-comp-nfe = pch-acesso-comp-nfe 
        AND   bf{&TableName}.idi-orig-trad = 2 EXCLUSIVE-LOCK:
        ASSIGN bf{&TableName}.log-consid-ender-nf-saida = plog-consid-ender-nf-saida.
    END.
    FIND CURRENT bf{&TableName} NO-LOCK NO-ERROR.
    
    IF NOT AVAIL bf{&TableName} THEN DO:
        {utp/ut-liter.i "Documento" *}      
        {method/svc/errors/inserr.i    
        &ErrorNumber="2"               
        &ErrorType="EMS"               
        &ErrorSubType="ERROR"          
        &ErrorParameters= RETURN-VALUE}
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaObservComparativo DBOProgram 
PROCEDURE atualizaObservComparativo :
/*------------------------------------------------------------------------------
  Purpose: Atualiza o campo comparativo XML
  Parameters:  pch-acesso-comp-nfe: Chave de acesso do documento
               pObservComparativo: observa∆o comparativo XML
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pch-acesso-comp-nfe LIKE doc-orig-nfe.ch-acesso-comp-nfe    NO-UNDO.
    DEFINE INPUT  PARAMETER pObservComparativo  LIKE doc-orig-nfe.observ-compar          NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    EMPTY TEMP-TABLE RowErrors.
    
       
    IF LENGTH(TRIM(pObservComparativo)) > 1000 THEN DO:
       {utp/ut-liter.i "Observaá∆o_comparativo" *}  
       {method/svc/errors/inserr.i &ErrorNumber="57359"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="RETURN-VALUE + '~~~~' + ' 1000'"}
       RETURN "NOK":U.
    END.
        
    FOR FIRST bf{&TableName} EXCLUSIVE-LOCK
        WHERE bf{&TableName}.ch-acesso-comp-nfe = pch-acesso-comp-nfe 
        AND   bf{&TableName}.idi-orig-trad = 2 :
        ASSIGN bf{&TableName}.observ-compar = pObservComparativo.
        
    END.
    FIND CURRENT bf{&TableName} NO-LOCK NO-ERROR.
    
    IF NOT AVAIL bf{&TableName} THEN DO:
        {utp/ut-liter.i "Documento" *}      
        {method/svc/errors/inserr.i    
        &ErrorNumber="2"               
        &ErrorType="EMS"               
        &ErrorSubType="ERROR"          
        &ErrorParameters= RETURN-VALUE}
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE executarEngineRecSemPedido DBOProgram 
PROCEDURE executarEngineRecSemPedido:
    DEFINE INPUT  PARAM pSeqItem LIKE item-doc-orig-nfe.seq-item NO-UNDO.
    DEFINE OUTPUT PARAM pRecebeSemPedido AS LOGICAL NO-UNDO.
    DEFINE VARIABLE h-reapi427  AS HANDLE      NO-UNDO.
    
    FIND FIRST estabelec WHERE estabelec.cod-estabel =  bf{&TableName}.cod-estabel NO-LOCK NO-ERROR.

    IF NOT AVAIL estabelec THEN RETURN "NOK":U.

    FOR FIRST bfitem-doc-orig NO-LOCK
        WHERE bfitem-doc-orig.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
          AND bfitem-doc-orig.idi-orig-trad      = 2
          AND bfitem-doc-orig.seq-item           = pSeqItem:

        RUN rep/reapi427.p PERSISTENT SET h-reapi427.
    
        RUN setChaveDocto  IN h-reapi427 (INPUT bf{&TableName}.ch-acesso-comp-nfe).
        RUN setCodEstabel  IN h-reapi427 (INPUT estabelec.cod-estabel).
        RUN setCodEmitente IN h-reapi427 (INPUT bf{&TableName}.cod-emitente).
        RUN setCodObserva  IN h-reapi427 (INPUT bf{&TableName}.cod-observa).
        RUN setUsuario     IN h-reapi427 (INPUT c-seg-usuario).
        RUN setNatOperacao IN h-reapi427 (INPUT bf{&TableName}.cod-natur-operac).
        RUN setNatFiscal   IN h-reapi427 (INPUT bfitem-doc-orig.nat-operacao).
        RUN setItCodigo    IN h-reapi427 (INPUT bfitem-doc-orig.it-codigo).
        RUN setSeqItem     IN h-reapi427 (INPUT bfitem-doc-orig.seq-item).

        RUN engineRegrasRecSemPedido IN h-reapi427 (OUTPUT pRecebeSemPedido).
    END.
    
    RETURN "OK":U.
    FINALLY:
        DELETE PROCEDURE h-reapi427 NO-ERROR.
        ASSIGN h-reapi427 = ?.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-contrato DBOProgram 
PROCEDURE pi-valida-contrato:
    DEFINE INPUT PARAM pNrOrdemCompra   LIKE ordem-compra.numero-ordem  NO-UNDO.
    DEFINE INPUT PARAM pNrContrato      LIKE ordem-compra.nr-contrato  NO-UNDO.
    DEFINE INPUT PARAM pNumSeqItem      LIKE ordem-compra.num-seq-item NO-UNDO.
    DEFINE INPUT PARAM pSeqItem         LIKE item-doc-orig-nfe.seq-item NO-UNDO.

    DEFINE VARIABLE l-conta-matriz      AS LOGICAL      NO-UNDO.
    DEFINE VARIABLE c-msg-aux AS CHARACTER   NO-UNDO.

     /* Nao permite gerar nota sem saldar todo o FIFO manual. */
    IF CAN-FIND (FIRST contrato-for
                 WHERE contrato-for.nr-contrato = pNrContrato
                 AND contrato-for.ind-control-rec = 1) OR
        CAN-FIND (FIRST item-contrat
                  WHERE item-contrat.num-seq-item     = pNumSeqItem
                    AND item-contrat.nr-contrato      = pNrContrato
                    AND item-contrat.ind-tipo-control = 1) THEN DO:
        {utp/ut-liter.i "Rec. F°sico n∆o permite contrato por mediá∆o. Sequància: " *}
        ASSIGN c-msg-aux = RETURN-VALUE + STRING(pSeqItem).
        RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                         INPUT 56920,
                         INPUT c-msg-aux,
                         INPUT 0).
        RETURN "NOK":U.
    END.
    ELSE DO:
        RUN cnp/cn9072.p (INPUT pNrOrdemCompra,
                          INPUT ?,
                          INPUT 12,                    /* Conta-Atual   */
                          OUTPUT l-conta-matriz,
                          INPUT-OUTPUT TABLE tt-erro-contrato).
        EMPTY TEMP-TABLE tt-erro-contrato.
        IF l-conta-matriz THEN DO:
            {utp/ut-liter.i "Rec. F°sico n∆o permite contratos com matriz de rateio. Sequància: " *}
            ASSIGN c-msg-aux = RETURN-VALUE + STRING(pSeqItem).
            RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                             INPUT 56902,
                             INPUT c-msg-aux,
                             INPUT 0).

            RETURN "NOK":U.
        END.
    END.
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvarDadosFCIItemRecebFiscal DBOProgram 
PROCEDURE salvarDadosFCIItemRecebFiscal PRIVATE:

    IF NOT AVAIL item-doc-orig-nfe OR
       NOT AVAIL tt-docum-est OR
       NOT AVAIL tt-item-doc-est THEN
        RETURN "NOK":U.

    IF TRIM(SUBSTRING(item-doc-orig-nfe.char-1,30,50)) <> "" THEN DO:
        IF  NOT VALID-HANDLE(h-bodi538) THEN
            RUN dibo/bodi538.p PERSISTENT SET h-bodi538.
        
        RUN pi-Inclui-Altera-ItemDocEst IN h-bodi538 (INPUT tt-item-doc-est.nro-docto,
                                                      INPUT tt-item-doc-est.serie-docto,
                                                      INPUT tt-docum-est.cod-estabel,
                                                      INPUT tt-item-doc-est.cod-emitente,
                                                      INPUT tt-item-doc-est.nat-operacao,
                                                      INPUT tt-docum-est.dt-trans,
                                                      INPUT tt-item-doc-est.it-codigo,
                                                      INPUT tt-item-doc-est.sequencia,
                                                      INPUT NO,
                                                      INPUT TRIM(SUBSTRING(item-doc-orig-nfe.char-1,30,50))).
        
        IF  VALID-HANDLE(h-bodi538) THEN DO:
            DELETE PROCEDURE h-bodi538.
            ASSIGN h-bodi538 = ?.
        END.

        RETURN "OK":U.
    END.

    RETURN "NOK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaQtdeFracionada DBOProgram 
PROCEDURE validaQtdeFracionada PRIVATE:
    DEF VAR c-texto-msg AS CHAR NO-UNDO.

    IF NOT AVAIL doc-orig-nfe AND 
       NOT AVAIL item-doc-orig-nfe THEN
        RETURN "NOK":U.

    IF NOT CAN-FIND(FIRST funcao
                    WHERE funcao.cd-funcao = "SPP-REC-VALID-XML-FRAC":U
                      AND funcao.ativo) THEN
        RETURN "OK":U. //S¢ valida se tiver a funá∆o ativada

    FIND FIRST item NO-LOCK WHERE item.it-codigo = item-doc-orig-nfe.it-codigo NO-ERROR.
    IF NOT AVAIL item THEN
        RETURN "NOK":U.

    FOR FIRST item-fornec NO-LOCK
        WHERE item-fornec.cod-emitente = doc-orig-nfe.cod-emitente
          AND item-fornec.it-codigo    = item-doc-orig-nfe.it-codigo
          AND item-fornec.ativo:
    END.

    IF TRUNCATE(item-doc-orig-nfe.qtd-comercial, 0) <> item-doc-orig-nfe.qtd-comercial AND //Fracionado
       NOT item.fraciona AND //N∆o pode fracionar, permite somente inteiros esse item no estoque
       item-doc-orig-nfe.un-interna = item-doc-orig-nfe.un-comercial AND //unidade medida igual: a interna e do fornecedor
       (NOT AVAIL item-fornec OR
       (AVAIL item-fornec AND
        item-fornec.fator-conver = 1 AND
        item-fornec.num-casa-dec = 0)) THEN DO:

        RUN utp/ut-msgs.p(INPUT "msg":U,
                          INPUT 58267,
                          INPUT STRING(item-doc-orig-nfe.qtd-comercial) + "~~" + STRING(item-doc-orig-nfe.seq-item) + "~~" + STRING(item-doc-orig-nfe.it-codigo)).
        ASSIGN c-texto-msg = RETURN-VALUE.
        RUN utp/ut-msgs.p(INPUT "help":U,
                          INPUT 58267,
                          INPUT STRING(item-doc-orig-nfe.qtd-comercial) + "~~" + STRING(item-doc-orig-nfe.seq-item) + "~~" + STRING(item-doc-orig-nfe.it-codigo)).
        ASSIGN c-texto-msg = c-texto-msg + ". " + RETURN-VALUE.

        RUN implantaErro(INPUT item-doc-orig-nfe.ch-acesso-comp-nfe,
                         INPUT 58267,
                         INPUT c-texto-msg,
                         INPUT 1). //ERRO
        RETURN "ERROR":U.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validarSaldoTercInsuficiente DBOProgram 
PROCEDURE validarSaldoTercInsuficiente PRIVATE:
    DEFINE VARIABLE qtdAlocada LIKE item-ref-nfe.qtd-alocada INIT 0 NO-UNDO.

    IF NOT AVAIL item-doc-orig-nfe THEN RETURN "NOK".

    IF item-doc-orig-nfe.int-2 = 5  /* Retorno Beneficiamento  */
    OR item-doc-orig-nfe.int-2 = 7  /* Faturamento Consignacao */
    OR item-doc-orig-nfe.int-2 = 8  /* Devolucao Consignacao   */
    OR item-doc-orig-nfe.int-2 = 19 /* Retorno Dep Fechado     */
    OR item-doc-orig-nfe.int-2 = 21 /* Ret Armaz Geral         */
    OR item-doc-orig-nfe.int-2 = 2  /* Devolucao de Cliente    */
    THEN DO: 

        FOR EACH item-ref-nfe NO-LOCK
           WHERE item-ref-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
             AND item-ref-nfe.seq-item           = item-doc-orig-nfe.seq-item:
            ASSIGN qtdAlocada = qtdAlocada + item-ref-nfe.qtd-alocada.
        END.

        IF (item-doc-orig-nfe.qtd-interna - qtdAlocada) > 0 THEN DO:
            RUN implantaErroConfCadastroMsg(INPUT item-doc-orig-nfe.ch-acesso-comp-nfe,
                                            INPUT 5934, //Quantidade saldo em terceiros insuficiente para sequencia &1
                                            INPUT STRING(item-doc-orig-nfe.seq-item) + "! Qtde interna: " + STRING(item-doc-orig-nfe.qtd-interna) + ", Qtde relac: " + STRING(qtdAlocada),
                                            INPUT 1).
            RETURN "ERROR":U. //ainda ha saldo disponivel para devolucao/alocacao terceiros
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{inbo/boin847.m4} /*procedures comparativo*/
{rep/re1001p1.i1} /* procedure pi-aloca-medicao */
