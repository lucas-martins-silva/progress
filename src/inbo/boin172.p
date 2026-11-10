
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
{include/i-prgvrs.i BOIN172 2.00.00.064 } /*** "010064" 17/06/2025 16:40:46 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin172 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName item
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName item
&GLOBAL-DEFINE TableLabel item
&GLOBAL-DEFINE QueryName qr{&TableName}
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND TRUE
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND-PROCS Main

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
      
{cdp/cdcfgman.i}

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
  &GLOBAL-DEFINE KeyField1 it-codigo /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
  &GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
  /* &GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES */
&endif

{inbo/boin172.i RowObject}
{inbo/boin311.i tt-pl-it-prod}
{inbo/boin172.i tt-item}
{cxbo/bocx00480.i tt-item-siscomex}

/* Variaveis utilizadas na integra‡Æo EMS2/NEOLOG */
{cdp/cdapi090def.i}

/** Unifica‡Æo de Conceitos **/
{cdp/cdunif001.i}

{cdp/cd9590.i}

/* Temp-table utilizada para o EAI*/
DEFINE TEMP-TABLE tt-EAI NO-UNDO LIKE ITEM .

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* Definição das variáveis necessárias ao setConstraint2 e 5 */
def var c-it-codigo-ini as char no-undo.

/* Definição das variáveis necessárias as setConstraint3 */
def var c-descricao-1    as char no-undo.

/* Definição das variáveis necessárias as setConstraint4 */
def var c-perc-acres    as char no-undo.
def var c-data-base     as char no-undo.
def var c-it-codigo-fim as char no-undo.
def var c-fam-mat-ini   as char no-undo.
def var c-fam-mat-fim   as char no-undo.
def var c-fam-com-ini   as char no-undo.
def var c-fam-com-fim   as char no-undo.
def var i-gr-estoq-ini  as int  no-undo.
def var i-gr-estoq-fim  as int  no-undo.
def var c-estab-ini     as char no-undo.
def var c-estab-fin     as char no-undo.

{utp/ut-glob.i}

/* Definição das variáveis necessárias as setConstraint6 */
DEFINE VARIABLE c-desc-item-ini    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-desc-item-fim    AS CHARACTER NO-UNDO.

DEFINE VARIABLE i-seq-erros-api-ctb-cc AS INTEGER     NO-UNDO.

def var c-palavra        as char no-undo.
def var c-comprado-ini   as char no-undo.
def var c-comprado-fim   as char no-undo.
def var c-planejador-ini as char no-undo.
def var c-planejador-fim as char no-undo.

define variable l-pacote-OK   as logical initial yes                    no-undo.
def new shared var l-erro    as logical init no no-undo.
DEF VAR l-atualiza-item AS LOG NO-UNDO.
ASSIGN l-atualiza-item = CAN-FIND(FIRST funcao NO-LOCK
                                  WHERE funcao.cd-funcao = "spp-it-ser-terc":U
                                    AND funcao.ativo ).
/* Definicao das variaveis necessarias para SetaInicializaDesmontagem */
def var lDesmonta as log init yes no-undo.
         
/* Definicao das variaveis necessarias ao setConstraintFiltroZoom*/
         
def var  c-fm-codigo-ini    as char no-undo.
def var  c-fm-codigo-fim    as char no-undo.
def var  c-fm-cod-com-ini   as char no-undo.
def var  c-fm-cod-com-fim   as char no-undo.
def var  i-ge-codigo-ini    as int  no-undo.
def var  i-ge-codigo-fim    as int  no-undo.
def var  c-cod-refer-ini    as char no-undo.
def var  c-cod-refer-fim    as char no-undo.
def var  i-cod-obsoleto-ini as int  no-undo.
def var  i-cod-obsoleto-fim as int  no-undo.
def var  i-ordena           as int  no-undo.

def var i-tp-contr-ini  as int  no-undo.
def var i-tp-contr-fim  as int  no-undo.
def var c-it-descricao-ini  as char no-undo.
def var c-it-descricao-fim  as char no-undo.

DEF VAR h-ceapi001k AS HANDLE NO-UNDO.
DEF VAR h-bocx00480 AS HANDLE NO-UNDO.

/* Utilizada em procedure de neg¢cio */
DEFINE TEMP-TABLE tt-valida-item NO-UNDO
       field cod-item as char.
	   
	   
define variable c-empresa-prin as character no-undo.
	   

/*************  Defini‡äes para: Pi-Valida-Inclusao-Item  *************************/
/*************                   Pi-Valida-Gravacao-Item  *************************/
/*************                   Pi-Valida-Exclusao-Item  *************************/
{inbo/boin172j.i}

 DEF TEMP-TABLE tt-tabela NO-UNDO
     FIELD aplicativo     AS INT  FORMAT "9"
     FIELD nome-tabela    AS CHAR FORMAT "x(30)"     
     FIELD campo-chave    AS CHAR 
     FIELD campo-chave1   AS CHAR 
     FIELD campo-chave2   AS CHAR 
     FIELD campo-chave3   AS CHAR
     FIELD campo-chave4   AS CHAR
     FIELD campo-chave5   AS CHAR.
/******[ Fim das Defini‡äes para PI de valida‡Æo ]*************************/

       
/******************************ATENCAO*************************************
 Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se nÆo, EMS. Utilizado pelo produto Comercio Exterior
**************************************************************************/ 
{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */

/* Definicao de temp-tables e variaveis */
&if defined(bf-mat-comex) &then     
&else
    {cep/ceapi001k.i}
&endif    
{cdp/cd0666.i}

/* Defini‡Æo TTs e Vari veis - Valida‡Æo Decimais */
{cep/ce1234.i} 

&if defined(bf-mat-comex) &then     
&else
    /* Funcao para consistencia de datas */
    {cpp/cp0311.i2}
&endif        

def temp-table tt-raw-transfere NO-UNDO
   field raw-registro as raw.
   
def temp-table tt-depos NO-UNDO
  field cod-depos  like deposito.cod-depos     
  field nome       like deposito.nome          
  field quantidade like movto-estoq.quantidade
  index dep cod-depos.   
  
{cpp/cp0318.i}

{cdp/cd7300.i1} /* MultiPlanta */

define temp-table RowErrorsFrotas NO-UNDO
    field ErrorSequence    as integer
    field ErrorNumber      as integer
    field ErrorDescription as character
    field ErrorParameters  as character
    field ErrorType        as character
    field ErrorHelp        as character
    field ErrorSubType     as character.

def temp-table tt-saldo NO-UNDO
    field it-codigo      like movto-estoq.it-codigo
    field cod-refer      like movto-estoq.cod-refer
    field cod-estabel    like movto-estoq.cod-estabel
    FIELD cod-depos      like movto-estoq.cod-depos
    field lote           like movto-estoq.lote
    field dt-vali-lote   like saldo-estoq.dt-vali-lote
    field cod-localiz    like movto-estoq.cod-localiz
    FIELD quantidade     LIKE movto-estoq.quantidade
    FIELD quant-nova     LIKE movto-estoq.quantidade
    FIELD l-config       AS   LOGICAL INIT NO
    FIELD num-ord-des    LIKE movto-estoq.num-ord-des
    FIELD num-seq-des    LIKE movto-estoq.num-seq-des
    field valor-mat-m    as dec  extent 3  form ">>>>>>,>>>,>>9.99"
    field valor-ggf-m    as dec  extent 3  form ">>>>>>,>>>,>>9.99"
    field valor-mob-m    as dec  extent 3  form ">>>>>>,>>>,>>9.99"
    INDEX it-codigo cod-refer cod-estabel cod-depos lote cod-localiz.

/* Utilizada para integra‡Æo EAI */
DEF NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO.

def var h-boin172j as handle no-undo.

DEFINE VARIABLE hDBOproxy AS HANDLE NO-UNDO.

DEF TEMP-TABLE ttItemReplica     NO-UNDO
    FIELD it-codigo             LIKE wm-item.cod-item
    FIELD desc-item             LIKE wm-item.des-item
    FIELD unid-med              LIKE wm-item.cod-unid-med
    FIELD peso-bruto            LIKE wm-item.qtd-peso
    FIELD largura               LIKE wm-item.qtd-largura
    FIELD comprimento           LIKE wm-item.qtd-comprimento
    FIELD altura                LIKE wm-item.qtd-altura
    FIELD tipo-con-est          LIKE wm-item.ind-tipo-contr-est
    FIELD fm-cod-com            LIKE wm-item.cod-familia
    FIELD fm-codigo             LIKE wm-item.cod-familia
    INDEX ch-codigo AS PRIMARY UNIQUE it-codigo.

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
def var l-lote-avancado    as log    no-undo.
def var h-ceapi030         as handle no-undo.
def var l-retorno          as log    no-undo.
def var c-lbl-liter-item-3 as CHAR   no-undo.

{cep/ceapi030.i}

if can-find(first funcao where funcao.cd-funcao = "lote-avancado":u and
                               funcao.ativo) then do:
    assign l-lote-avancado = yes.
end.
&endif

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
         HEIGHT             = 3.42
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

    &IF "{&bf_mat_versao_ems}":U >= "2.08":U &THEN
    
         IF program-name(3) MATCHES("*axrma005*") THEN
            ASSIGN item.log-orig-ext = YES.

    &ELSE 
        IF program-name(3) MATCHES("*axrma005*") THEN
           ASSIGN OVERLAY(item.char-1,267,1) = "S":U.
    &ENDIF
    
    
    /* Include respons vel pela envio de dados do EMS2 ao NEOLOG */
    {cdp/cdapi090.i CREATE item}
    RUN piIntegracao("CREATE":U).
    
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
    if avail item then do:

        &IF "{&bf_mat_versao_ems}":U >= "2.08":U &THEN
    
             IF program-name(3) MATCHES("*axrma005*") THEN
                ASSIGN item.log-orig-ext = YES.
    
        &ELSE 
            IF program-name(3) MATCHES("*axrma005*") THEN
               ASSIGN OVERLAY(item.char-1,267,1) = "S":U.
        &ENDIF
        IF NOT ITEM.contr-qualid THEN
            &IF '{&bf_mat_versao_ems}':U >= '2.081':U &THEN
                ASSIGN ITEM.log-altera-valid-lote = NO.
            &ELSE
                ASSIGN OVERLAY(ITEM.char-2,13,1) = '2':U.
            &ENDIF

        find first item-man where item-man.it-codigo = item.it-codigo exclusive-lock no-error.
        if avail item-man then 
           assign 
           item-man.tipo-est-seg = item.tipo-est-seg
           item-man.emissao-ord  = item.emissao-ord
           item-man.demanda      = item.demanda
           item-man.tipo-con-est = item.tipo-con-est
           item-man.ind-refugo   = item.ind-refugo
           item-man.contr-qualid = item.contr-qualid
           item-man.fraciona     = item.fraciona
           item-man.fator-refugo = item.fator-refugo
           item-man.tempo-segur  = item.tempo-segur
           item-man.quant-perda  = item.quant-perda
           item-man.quant-segur  = item.quant-segur.
    end.
    release item-man.


    IF CONNECTED('mgscm') THEN DO:
        IF RowObject.cod-obsoleto = 1 THEN DO:
            IF NOT VALID-HANDLE(hDBOproxy) THEN
                RUN wmp/wmprx044.p PERSISTENT SET hDBOproxy.
            EMPTY TEMP-TABLE ttItemReplica.
            CREATE ttItemReplica.
            ASSIGN ttItemReplica.it-codigo    = RowObject.it-codigo
                   ttItemReplica.desc-item    = RowObject.desc-item
                   ttItemReplica.unid-med     = RowObject.un
                   ttItemReplica.peso-bruto   = RowObject.peso-bruto
                   ttItemReplica.largura      = RowObject.largura
                   ttItemReplica.comprimento  = RowObject.comprim
                   ttItemReplica.altura       = RowObject.altura
                   ttItemReplica.tipo-con-est = RowObject.tipo-con-est
                   ttItemReplica.fm-cod-com   = RowObject.fm-cod-com
                   ttItemReplica.fm-codigo    = RowObject.fm-codigo.
            RUN ReplicaItem IN hDBOproxy(INPUT TABLE ttItemReplica,
                                         OUTPUT TABLE RowErrors).
            RUN destroy     IN hDBOproxy.
        END.
    END.

    
    /* Include respons vel pela envio de dados do EMS2 ao NEOLOG */
    {cdp/cdapi090.i UPSERT item}
    RUN piIntegracao("UPDATE").

    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaItem DBOProgram 
PROCEDURE atualizaItem :
/*------------------------------------------------------------------------------
  Purpose:   : Executa a atualização dos seguintes campos da tabela de 
               itens (in172 - Item):preco-base, data-base , data-ult-sai,
               preco-ult-ent, data-ult-ent, preco-repos, data-ult-rep, 
               preco-fiscal, dt-pr-fisc, moeda-padrao.  
  Parameters:  ipar1  : p-r-rowid            : Rowid do Registro a ser Atualizado          
                ipar2  : p-de-preco-base-calc : Preço Base recalculado  
                ipar3  : p-de-preco-ult-ent   : Preço da última entrada
                ipar4  : p-de-preco-repos     : Preço de Reposição
                ipar5  : p-de-preco-fiscal    : Preço Fiscal
                ipar6  : p-da-data-base       : Data Base
                ipar7  : p-da-data-ult-sai    : Data última Saída
                ipar8  : p-da-data-ult-ent    : Data última Entrada
                ipar9  : p-da-data-ult-rep    : Data última Reposição
                ipar10 : p-da-dt-pr-fisc      : Data do Preço Fiscal
                ipar11 : p-i-moeda-padrao     : Moeda Padrão   
     
------------------------------------------------------------------------------*/
    def input param p-r-rowid            as rowid.
    def input param p-de-preco-base-calc as decimal.
    def input param p-de-preco-ult-ent   as decimal.
    def input param p-de-preco-repos     as decimal.
    def input param p-de-preco-fiscal    as decimal.
    def input param p-da-data-base       as date.
    def input param p-da-data-ult-sai    as date.
    def input param p-da-data-ult-ent    as date.
    def input param p-da-data-ult-rep    as date.
    def input param p-da-dt-pr-fisc      as date.
    def input param p-i-moeda-padrao     as int.

            
    FIND {&TABLENAME} WHERE rowid({&TABLENAME}) = p-r-rowid EXCLUSIVE-LOCK NO-ERROR.
    
    IF AVAIL {&TABLENAME} THEN
     ASSIGN   {&TABLENAME}.preco-base      = p-de-preco-base-calc
              {&TABLENAME}.preco-ul-ent    = p-de-preco-ult-ent
               {&TABLENAME}.preco-repos     = p-de-preco-repos
               {&TABLENAME}.preco-fiscal    = p-de-preco-fiscal
               {&TABLENAME}.data-base       = p-da-data-base
               {&TABLENAME}.data-ult-sai    = p-da-data-ult-sai
               {&TABLENAME}.data-ult-ent    = p-da-data-ult-ent
               {&TABLENAME}.data-ult-rep    = p-da-data-ult-rep
               {&TABLENAME}.dt-pr-fisc      = p-da-dt-pr-fisc
               {&TABLENAME}.moeda-padrao    = p-i-moeda-padrao.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaMoeda DBOProgram 
PROCEDURE atualizaMoeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pItCodigo as char no-undo.
def input param pMoeda    as int  no-undo.

    find item where
         item.it-codigo = pItCodigo exclusive-lock no-error.
         
    if avail item then
        assign item.moeda-padrao = pMoeda.


    RELEASE ITEM.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CalculaPrecoMedio DBOProgram 
PROCEDURE CalculaPrecoMedio :
/*------------------------------------------------------------------------------
  Purpose:     Calcula o pre‡o m‚dio do item entre todos os estabelecimentos.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  c-it-codigo    AS CHAR           NO-UNDO.
    DEFINE OUTPUT PARAMETER de-preco-medio LIKE ITEM.preco-base.
    DEFINE VARIABLE de-total               LIKE ITEM.preco-base INIT 0.
    DEFINE VARIABLE de-total-aux           AS DECIMAL INIT 0 NO-UNDO.
    DEFINE VARIABLE i-cont                 AS INTEGER INIT 0 NO-UNDO.
    
    FOR EACH item-estab
       WHERE item-estab.it-codigo = c-it-codigo NO-LOCK:
           
           ASSIGN de-total-aux = 0
                  de-total-aux = item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1].
           IF de-total-aux <> 0 THEN
               ASSIGN de-total = de-total + de-total-aux
                      i-cont   = i-cont + 1.
    END.
    ASSIGN de-preco-medio = ROUND(de-total / i-cont,4).
   
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CalculaQuantidadeEstoque DBOProgram 
PROCEDURE CalculaQuantidadeEstoque :
/*------------------------------------------------------------------------------
  Purpose:   Calcula Quantidade inicial e final de itens no estoque.   
  Parameters:ipar1  : p-rowid        : rowid do Item.
             ipar2  : p-estabel      : Estabelecimento do Item.
             ipar3  : p-depo-ini     : Dep¢sito Inicial do Item.
             ipar4  : p-depo-fin     : Dep¢sito Final do Item.
             ipar5  : p-lot-ini      : Lote Inicial do Item.
             ipar6  : p-lot-fim      : Lote Final do Item.
             ipar7  : p-loca-ini     : Localiza‡Æo Inicial do Item.
             ipar8  : p-loca-fin     : Localiza‡Æo Final do Item.
             ipar9  : p-data-ini     : Data Inicial da Transa‡Æo.
             ipar10 : p-data-fin     : Data Final da Transa‡Æo.
             opar11 : p-qtidade-ini  : Retorna Quantidade Inicial do Item no Estoque.
             opar12 : p-qtidade-fim  : Retorna Quantidade Final do Item no Estoque.
------------------------------------------------------------------------------*/
    def input  param p-rowid         as rowid no-undo. 
    def input  param p-estabel       as char  no-undo.
    def input  param p-depo-ini      as char  no-undo.
    def input  param p-depo-fin      as char  no-undo.
    def input  param p-lot-ini       as char  no-undo.
    def input  param p-lot-fim       as char  no-undo.
    def input  param p-loca-ini      as char  no-undo.
    def input  param p-loca-fin      as char  no-undo.
    def input  param p-data-ini      as date  no-undo.
    def input  param p-data-fin      as date  no-undo.
    def output param p-qtidade-ini   as dec   no-undo.
    def output param p-qtidade-fim   as dec   no-undo. 
    
    find item where rowid(item) = p-rowid no-lock no-error.
    if avail item then do:
        /* calcula o saldo inicial e final do item. */
        assign p-qtidade-ini = 0
               p-qtidade-fim = 0.
        for each saldo-estoq fields (saldo-estoq.qtidade-atu)
            where saldo-estoq.it-codigo  = item.it-codigo 
            and saldo-estoq.cod-estabel  = p-estabel
            and saldo-estoq.cod-depos    >= p-depo-ini
            and saldo-estoq.cod-depos    <= p-depo-fin
            and saldo-estoq.lote         >= p-lot-ini
            and saldo-estoq.lote         <= p-lot-fim
            and saldo-estoq.cod-localiz  >= p-loca-ini
            and saldo-estoq.cod-localiz  <= p-loca-fin
            no-lock:       
            assign p-qtidade-ini = p-qtidade-ini + saldo-estoq.qtidade-atu
                   p-qtidade-fim = p-qtidade-fim + saldo-estoq.qtidade-atu.
        end.
    
        /* Calcula o saldo inicial e final */
        find first saldo-estoq
            where saldo-estoq.it-codigo  = item.it-codigo 
            and saldo-estoq.cod-estabel  = p-estabel
            and saldo-estoq.cod-depos    >= p-depo-ini
            and saldo-estoq.cod-depos    <= p-depo-fin
            and saldo-estoq.lote         >= p-lot-ini
            and saldo-estoq.lote         <= p-lot-fim
            and saldo-estoq.cod-localiz  >= p-loca-ini
            and saldo-estoq.cod-localiz  <= p-loca-fin
            no-lock no-error.     
    
            if not avail saldo-estoq then do:
               assign p-qtidade-ini = 0
                      p-qtidade-fim = 0.
            end.    
            else do:
                for each item-estab fields (cod-estabel)
                    where item-estab.it-codigo = item.it-codigo
                    and item-estab.cod-estabel = p-estabel
                    no-lock:
                    for each movto-estoq fields (movto-estoq.tipo-trans
                                                 movto-estoq.dt-trans
                                                 movto-estoq.quantidade) use-index item-data
                        where movto-estoq.cod-estabel  = item-estab.cod-estabel
                          and movto-estoq.it-codigo    = item.it-codigo
                          and movto-estoq.dt-trans    >= p-data-ini
                          and movto-estoq.cod-depos   >= p-depo-ini
                          and movto-estoq.cod-depos   <= p-depo-fin
                          and movto-estoq.lote        >= p-lot-ini
                          and movto-estoq.lote        <= p-lot-fim
                          and movto-estoq.cod-localiz >= p-loca-ini
                          and movto-estoq.cod-localiz <= p-loca-fin
                          no-lock:
    
                        if movto-estoq.tipo-trans = 1 then do:         /* Movimento de Entrada */
                            /* Se a data for maior que o per¡odo especificado pelo usu rio,
                               altera a quantidade do saldo inicial/final */
                            if movto-estoq.dt-trans > p-data-fin then
                                assign
                                    p-qtidade-fim = p-qtidade-fim - movto-estoq.quantidade
                                    p-qtidade-ini = p-qtidade-ini - movto-estoq.quantidade.
                            else
                                assign p-qtidade-ini = p-qtidade-ini - movto-estoq.quantidade.
                        end.
                        else do:
                            if movto-estoq.dt-trans > p-data-fin then
                               assign p-qtidade-fim = p-qtidade-fim + movto-estoq.quantidade
                                      p-qtidade-ini = p-qtidade-ini + movto-estoq.quantidade.
                            else
                              assign p-qtidade-ini = p-qtidade-ini + movto-estoq.quantidade.
                        end.
                end.
            end.
        end.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaValorMaterialGgfMaoObra DBOProgram 
PROCEDURE calculaValorMaterialGgfMaoObra :
/*------------------------------------------------------------------------------
  Purpose:   Calcula o Valor Unitário do Material, o Valor Unitário da Mão Obra, 
              o Valor Unitário de GGF e o Valor Total. E cada valor em 3 moedas: a corrente 
              e outras cujos códigos estão cadastrados na param-estoq (moeda1 e moeda2).
  Parameters:ipar1  : p-r-rowid            : Rowid do Item corrente da interface
              ipar2  : p-l-ok               : Testa se a interface já inicializou os valores do estab e custo
              opar3  : p-c_estab            : Estabelecimento usado no cálculo
              opar4  : p-c_preco_item       : Custo usado no cálculo
              opar5  : p-de-vl_total_1      : Valor total                na moeda corrente
              opar6  : p-de-vl_total_2      : Valor total                na moeda 1
              opar7  : p-de-vl_total_3      : Valor total                na moeda 2
              opar8  : p-de_vl_unit_mat_1   : Valor Unit rio do Material na moeda corrente
              opar9  : p-de_vl_unit_mat_2   : Valor Unit rio do Material na moeda 1
              opar10 : p-de_vl_unit_mat_3   : Valor Unit rio do Material na moeda 2
              opar11 : p-de_vl_mao_obra_1   : Valor Unit rio da Mão Obra na moeda corrente
              opar12 : p-de_vl_mao_obra_2   : Valor Unit rio da Mão Obra na moeda 1
              opar13 : p-de_vl_mao_obra_3   : Valor Unit rio da Mão Obra na moeda 2
              opar14 : p-de_vl-unit-ggf_1   : Valor Unit rio de GGF      na moeda corrente
              opar15 : p-de_vl-unit-ggf_2   : Valor Unit rio de GGF      na moeda 1
              opar16 : p-de_vl-unit-ggf_3   : Valor Unit rio de GGF      na moeda 2
------------------------------------------------------------------------------*/
    def input  param p-r-rowid             as rowid   no-undo.
    def input  param p-l-ok                as log     no-undo.
    def input-output param p-c_estab       as char    no-undo.
    def input-output param p-c_preco_item  as char    no-undo.
    def output param p-de-vl_total_1       as decimal no-undo.
    def output param p-de-vl_total_2       as decimal no-undo.
    def output param p-de-vl_total_3       as decimal no-undo.
    def output param p-de_vl_unit_mat_1    as decimal no-undo.
    def output param p-de_vl_unit_mat_2    as decimal no-undo.
    def output param p-de_vl_unit_mat_3    as decimal no-undo.
    def output param p-de_vl_mao_obra_1    as decimal no-undo.
    def output param p-de_vl_mao_obra_2    as decimal no-undo.
    def output param p-de_vl_mao_obra_3    as decimal no-undo.
    def output param p-de_vl-unit-ggf_1    as decimal no-undo.
    def output param p-de_vl-unit-ggf_2    as decimal no-undo.
    def output param p-de_vl-unit-ggf_3    as decimal no-undo.

    def var c_estab_fim         as char    no-undo.
    def var c_preco_item_fim    as char    no-undo.
    def var de-vl_total_1       as decimal no-undo.
    def var de-vl_total_2       as decimal no-undo.
    def var de-vl_total_3       as decimal no-undo.
    def var de_vl_unit_mat_1    as decimal no-undo.
    def var de_vl_unit_mat_2    as decimal no-undo.
    def var de_vl_unit_mat_3    as decimal no-undo.
    def var de_vl_mao_obra_1    as decimal no-undo.
    def var de_vl_mao_obra_2    as decimal no-undo.
    def var de_vl_mao_obra_3    as decimal no-undo.
    def var de_vl-unit-ggf_1    as decimal no-undo.
    def var de_vl-unit-ggf_2    as decimal no-undo.
    def var de_vl-unit-ggf_3    as decimal no-undo.
    def var c-ok                as char no-undo.
    def var i-custo             like estabelec.custo-contab no-undo.
    def var c-estabel           like estabelec.cod-estabel  no-undo.
    
    if p-l-ok then c-ok = "yes".
              else c-ok = "no".

    assign i-custo   = integer(p-c_preco_item)
           c-estabel = p-c_estab.

    find first item where rowid(item) = p-r-rowid no-lock no-error.

    if  p-l-ok = no then do:
        if string(i-custo) = "" then assign i-custo   = 1.
        if i-custo         = 0  then assign i-custo   = 1.
        if c-estabel       = "" then assign c-estabel = item.cod-estabel.

        assign c_estab_fim      = c-estabel.
        assign c_preco_item_fim = string(i-custo).

        &if  defined(bf_mat_custeio_item) &then  
            find estab-mat where estab-mat.cod-estabel      = item.cod-estabel no-lock no-error.
            if avail estab-mat then assign c_preco_item_fim = string(estab-mat.custo-contab).
        &else
            find estabelec where estabelec.cod-estabel      = item.cod-estabel no-lock no-error.
            if avail estabelec then assign c_preco_item_fim = string(estabelec.custo-contab).
        &endif
        
    end.
    else do:
        /* teste para ver se o estab que veio da interface faz parte da lista de estabs do item atual */

        def var c-lista-estabel as char no-undo.
        RUN montaListaEstabelecimentosItem (input  p-r-rowid,
                                            output c-lista-estabel).
         /* se o c-estabel nÆo estiver contido na c-lista-estabel grava-se o estabelec do item atual */

        if LOOKUP(c-estabel, c-lista-estabel) = 0    /* entÆo c-estabel nÆo est  na c-lista-estabel */
           then assign c-estabel = item.cod-estabel.


        assign c_estab_fim      = c-estabel
               c_preco_item_fim = string(i-custo).
    end.

    find first item-estab
         where item-estab.it-codigo   = item.it-codigo
         and   item-estab.cod-estabel = c_estab_fim no-lock no-error.
    if  avail item-estab then do:
        if  i-custo = 1 then do:
            assign de-vl_total_1    = item-estab.val-unit-mat-m[1]
                                    + item-estab.val-unit-mob-m[1]
                                    + item-estab.val-unit-ggf-m[1]
                   de-vl_total_2    = item-estab.val-unit-mat-m[2]
                                    + item-estab.val-unit-mob-m[2]
                                    + item-estab.val-unit-ggf-m[2]
                   de-vl_total_3    = item-estab.val-unit-mat-m[3]
                                    + item-estab.val-unit-mob-m[3]
                                    + item-estab.val-unit-ggf-m[3].

            assign de_vl_unit_mat_1 = item-estab.val-unit-mat-m[1]
                   de_vl_unit_mat_2 = item-estab.val-unit-mat-m[2]
                   de_vl_unit_mat_3 = item-estab.val-unit-mat-m[3]

                   de_vl_mao_obra_1 = item-estab.val-unit-mob-m[1]
                   de_vl_mao_obra_2 = item-estab.val-unit-mob-m[2]
                   de_vl_mao_obra_3 = item-estab.val-unit-mob-m[3]

                   de_vl-unit-ggf_1 = item-estab.val-unit-ggf-m[1]
                   de_vl-unit-ggf_2 = item-estab.val-unit-ggf-m[2]
                   de_vl-unit-ggf_3 = item-estab.val-unit-ggf-m[3].
        end.
        if  i-custo = 2 then do:
            assign de-vl_total_1    = item-estab.val-unit-mat-o[1]
                                    + item-estab.val-unit-mob-o[1]
                                    + item-estab.val-unit-ggf-o[1]
                   de-vl_total_2    = item-estab.val-unit-mat-o[2]
                                    + item-estab.val-unit-mob-o[2]
                                    + item-estab.val-unit-ggf-o[2]
                   de-vl_total_3    = item-estab.val-unit-mat-o[3]
                                    + item-estab.val-unit-mob-o[3]
                                    + item-estab.val-unit-ggf-o[3].

            assign de_vl_unit_mat_1 = item-estab.val-unit-mat-o[1]
                   de_vl_unit_mat_2 = item-estab.val-unit-mat-o[2]
                   de_vl_unit_mat_3 = item-estab.val-unit-mat-o[3]

                   de_vl_mao_obra_1 = item-estab.val-unit-mob-o[1]
                   de_vl_mao_obra_2 = item-estab.val-unit-mob-o[2]
                   de_vl_mao_obra_3 = item-estab.val-unit-mob-o[3]

                   de_vl-unit-ggf_1 = item-estab.val-unit-ggf-o[1]
                   de_vl-unit-ggf_2 = item-estab.val-unit-ggf-o[2]
                   de_vl-unit-ggf_3 = item-estab.val-unit-ggf-o[3].
        end.
        if  i-custo = 3 then do:
            assign de-vl_total_1    = item-estab.val-unit-mat-p[1]
                                    + item-estab.val-unit-mob-p[1]
                                    + item-estab.val-unit-ggf-p[1]
                   de-vl_total_2    = item-estab.val-unit-mat-p[2]
                                    + item-estab.val-unit-mob-p[2]
                                    + item-estab.val-unit-ggf-p[2]
                   de-vl_total_3    = item-estab.val-unit-mat-p[3]
                                    + item-estab.val-unit-mob-p[3]
                                    + item-estab.val-unit-ggf-p[3].

            assign de_vl_unit_mat_1 = item-estab.val-unit-mat-p[1]
                   de_vl_unit_mat_2 = item-estab.val-unit-mat-p[2]
                   de_vl_unit_mat_3 = item-estab.val-unit-mat-p[3]

                   de_vl_mao_obra_1 = item-estab.val-unit-mob-p[1]
                   de_vl_mao_obra_2 = item-estab.val-unit-mob-p[2]
                   de_vl_mao_obra_3 = item-estab.val-unit-mob-p[3]

                   de_vl-unit-ggf_1 = item-estab.val-unit-ggf-p[1]
                   de_vl-unit-ggf_2 = item-estab.val-unit-ggf-p[2]
                   de_vl-unit-ggf_3 = item-estab.val-unit-ggf-p[3].
        end.
    end.
    else do:
        assign de-vl_total_1    = 0
               de-vl_total_2    = 0
               de-vl_total_3    = 0

               de_vl_unit_mat_1 = 0
               de_vl_unit_mat_2 = 0
               de_vl_unit_mat_3 = 0

               de_vl_mao_obra_1 = 0
               de_vl_mao_obra_2 = 0
               de_vl_mao_obra_3 = 0

               de_vl-unit-ggf_1 = 0
               de_vl-unit-ggf_2 = 0
               de_vl-unit-ggf_3 = 0.
    end.

    /* gravar os valores na vari veis de retorno */
    assign p-c_estab           = c_estab_fim.
    assign p-c_preco_item      = c_preco_item_fim.
    assign p-de-vl_total_1     = de-vl_total_1.
    assign p-de-vl_total_2     = de-vl_total_2.
    assign p-de-vl_total_3     = de-vl_total_3.
    assign p-de_vl_unit_mat_1  = de_vl_unit_mat_1.
    assign p-de_vl_unit_mat_2  = de_vl_unit_mat_2.
    assign p-de_vl_unit_mat_3  = de_vl_unit_mat_3.
    assign p-de_vl_mao_obra_1  = de_vl_mao_obra_1.
    assign p-de_vl_mao_obra_2  = de_vl_mao_obra_2.
    assign p-de_vl_mao_obra_3  = de_vl_mao_obra_3.
    assign p-de_vl-unit-ggf_1  = de_vl-unit-ggf_1.
    assign p-de_vl-unit-ggf_2  = de_vl-unit-ggf_2.
    assign p-de_vl-unit-ggf_3  = de_vl-unit-ggf_3.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE efetivaDesmontagem DBOProgram 
PROCEDURE efetivaDesmontagem :
/*------------------------------------------------------------------------------
  Purpose:     Efetivar a desmontagem de itens.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param i-empresa-prin           LIKE empresa.ep-codigo no-undo.
    def input param c-conta-contabil         as char no-undo.
    def input param c-ccusto                 as char no-undo.
    def input param c-dt-trans               as date format "99/99/9999" no-undo.
    def input param c-serie-docto            as char no-undo.
    def input param c-nro-docto              as char no-undo.
    def input param c-it-codigo              as char no-undo.
    def input param c-cod-estabel            as char no-undo.
    def input param c-cod-depos              as char no-undo.
    def input param c-lote                   as char no-undo.
    def input param p-refer                  as char no-undo.
    def input param c-cod-localiz            as char no-undo.
    def input param de-quantidade            as dec  no-undo.
    def input param c-un                     as char no-undo.
    def input param c-conta-contab-aplic     as char no-undo.
    def input param c-ccusto-aplic           as char no-undo.
    def input param l-atu-ult-ent            as log  no-undo.
    def input param l-consiste-val-retorno   as log  no-undo.
    def input-output param table for tt-work.
    def       output param table for tt-erro.
    
    def buffer b-saldo-estoq for saldo-estoq.
    
    def var de-aux-1 as dec  no-undo.
    def var de-aux-2 as dec  no-undo.
    def var i-x      as int  no-undo.
    def var i-valor-mat-m               like item-estab.val-unit-mat-m[1] extent 3.
    def var i-valor-ggf-m               like item-estab.val-unit-ggf-m[1] extent 3.
    def var i-valor-mob-m               like item-estab.val-unit-mob-m[1] extent 3.
    def var i-valor-mat-o               like item-estab.val-unit-mat-o[1] extent 3.
    def var i-valor-ggf-o               like item-estab.val-unit-ggf-o[1] extent 3.
    def var i-valor-mob-o               like item-estab.val-unit-mob-o[1] extent 3.
    def var i-valor-mat-p               like item-estab.val-unit-mat-p[1] extent 3.
    def var i-valor-ggf-p               like item-estab.val-unit-ggf-p[1] extent 3.
    def var i-valor-mob-p               like item-estab.val-unit-mob-p[1] extent 3.
    
    def var i-num-trans-desmont as int init 1 no-undo.

    DEF VAR h-cdapi024       AS HANDLE    NO-UNDO.
    DEF VAR c-cod-unid-negoc AS CHARACTER NO-UNDO.

    IF NOT VALID-HANDLE(h-cdapi024) THEN
        RUN cdp/cdapi024.p persistent set h-cdapi024.

    for each tt-movto exclusive-lock:
        delete tt-movto.
    end.

    /* Gera movimentacao */                                    
    for each tt-work where tt-work.quantidade <> 0 no-lock:            
        
        find item 
            where item.it-codigo = tt-work.it-codigo no-lock no-error.
        

        RUN RetornaUnidadeNegocio IN h-cdapi024 (INPUT  tt-work.cod-estabel,
                                                 INPUT  tt-work.it-codigo,
                                                 INPUT  tt-work.cod-depos,
                                                 OUTPUT c-cod-unid-negoc).


        CREATE tt-movto.       
        ASSIGN tt-movto.cod-versao-integracao = 001
               tt-movto.cod-estabel       = tt-work.cod-estabel
               tt-movto.cod-depos         = tt-work.cod-depos
               tt-movto.it-codigo         = tt-work.it-codigo
               tt-movto.cod-localiz       = tt-work.cod-localiz
               tt-movto.lote              = tt-work.lote
               tt-movto.dt-vali-lote      = tt-work.dt-vali-lote
               tt-movto.cod-refer         = tt-work.cod-refer
               tt-movto.num-ord-des       = tt-work.num-ord-des
               tt-movto.num-seq-des       = tt-work.num-seq-des
               tt-movto.tipo-trans        = 1                       /* Entrada */
               tt-movto.ct-codigo         = c-conta-contabil /* conta-contab.ct-codigo */
               tt-movto.sc-codigo         = c-ccusto
               tt-movto.dt-trans          = c-dt-trans
               tt-movto.esp-docto         = 6                       /* Div */
               tt-movto.serie-docto       = c-serie-docto
               tt-movto.quantidade        = tt-work.quantidade
               tt-movto.un                = tt-work.unidade
               tt-movto.valor-mat-m[1]    = tt-work.valor-mat-m[1]
               tt-movto.valor-ggf-m[1]    = tt-work.valor-ggf-m[1]
               tt-movto.valor-mob-m[1]    = tt-work.valor-mob-m[1]
               tt-movto.nro-docto         = c-nro-docto
               tt-movto.atualiza-ul-ent   = l-atu-ult-ent  
               tt-movto.cod-unid-negoc    = c-cod-unid-negoc
               tt-movto.cod-prog-orig     = "CP0318"
               tt-movto.tipo-valor        = if  l-consiste-val-retorno
                                            then 1
                                            else 2. 
                
               /** ATUALIZA OS VALORES NAS MOEDAS ALTERNATIVAS (QDO IMPLANTADAS). **/
               find first param-estoq no-lock no-error.
               if  param-estoq.tem-moeda1 then do:
                   /*** materiais ***/
                   run cdp/cd0813.p (0, 
                                     1, 
                                     tt-movto.valor-mat-m[1],
                                     tt-movto.dt-trans, 
                                     output de-aux-1).
                   assign tt-movto.valor-mat-m[2] = de-aux-1.

                   /*** ggf ***/
                   run cdp/cd0813.p (0, 
                                     1, 
                                     tt-movto.valor-ggf-m[1],
                                     tt-movto.dt-trans, 
                                     output de-aux-1).
                   assign tt-movto.valor-ggf-m[2] = de-aux-1.

                   /*** MOD ***/
                   run cdp/cd0813.p (0, 
                                     1, 
                                     tt-movto.valor-mob-m[1],
                                     tt-movto.dt-trans, 
                                     output de-aux-1).
                   assign tt-movto.valor-mob-m[2] = de-aux-1.


               end.
               if  param-estoq.tem-moeda2 then do:
                   /*** mat ***/
                   run cdp/cd0813.p (0, 
                                     2, 
                                     tt-movto.valor-mat-m[1],
                                     tt-movto.dt-trans, 
                                     output de-aux-2).
                   assign tt-movto.valor-mat-m[3] = de-aux-2.

                   /*** ggf  ***/
                   run cdp/cd0813.p (0, 
                                     2, 
                                     tt-movto.valor-ggf-m[1],
                                     tt-movto.dt-trans, 
                                     output de-aux-2).
                   assign tt-movto.valor-ggf-m[3] = de-aux-2.

                   /*** mob ***/                                          
                   run cdp/cd0813.p (0, 
                                     2, 
                                     tt-movto.valor-mob-m[1],
                                     tt-movto.dt-trans, 
                                     output de-aux-2).
                   assign tt-movto.valor-mob-m[3] = de-aux-2.

               end.
        
        IF tt-work.ct-codigo <> "" THEN DO:
            ASSIGN tt-movto.ct-db = tt-work.ct-codigo
                   tt-movto.sc-db = tt-work.sc-codigo.
        END.

        IF  AVAIL(tt-movto) THEN DO:
            FOR FIRST saldo-estoq FIELDS (it-codigo
                                          lote
                                          cod-depos
                                          cod-estabel
                                          cod-refer
                                          cod-localiz
                                          dt-vali-lote
                                          qtidade-atu
                                          qt-alocada
                                          qt-aloc-prod
                                          qt-aloc-ped)                        
                WHERE saldo-estoq.it-codigo   = tt-movto.it-codigo
                  AND saldo-estoq.cod-estabel = tt-movto.cod-estabel
                  AND saldo-estoq.cod-localiz = tt-movto.cod-localiz
                  AND saldo-estoq.lote        = tt-movto.lote 
                  AND saldo-estoq.cod-refer   = tt-movto.cod-refer NO-LOCK: END.

            IF AVAIL saldo-estoq THEN DO:
                IF item.tipo-con-est   =  2 AND 
                   tt-movto.esp-docto  <> 2 AND  
                   tt-movto.quantidade <> 0 AND 
                   tt-movto.referencia <> "RecFis":U THEN DO:  /* Nao deve consistir as notas de entrada provenientes do rec fisico que geraram movto-estoq pelo fðsico */ 
                    IF ((tt-movto.tipo-trans = 2         AND /* Saida   */  
                         saldo-estoq.qtidade-atu <= -1 ) OR
                       (tt-movto.tipo-trans     =   1    AND /* Entrada */  
                        saldo-estoq.qtidade-atu >=  1 )) AND
                    NOT l-atualiza-item THEN do:
                    /* Nao deve consistir as notas de entrada provenientes do rec fisico que geraram movto-estoq pelo fðsico */ 
                    run pi-gera-temp-erro (input 8995, input string(tt-movto.it-codigo + " N£mero de S‚rie " + tt-movto.lote + " j  ")).
                    
                    FIND FIRST tt-erro NO-LOCK NO-ERROR.
                    IF AVAIL(tt-erro) THEN
                        RETURN "adm-error".
                  END.
                END.
            END.
        END.
    END. /* for each tt-work */
     
    find first tt-movto no-lock no-error.
     
    if  avail(tt-movto) then do:
        IF NOT VALID-HANDLE(h-ceapi001k) THEN
            RUN cep/ceapi001k.p PERSISTENT SET h-ceapi001k.


        RUN pi-execute IN h-ceapi001k (INPUT-OUTPUT TABLE tt-movto,
                                       INPUT-OUTPUT TABLE tt-erro,
                                       INPUT YES).

        DELETE PROCEDURE h-ceapi001k.

        find first tt-erro no-lock no-error.
        if  avail(tt-erro) then
            return "adm-error".
        
        IF RETURN-VALUE = "Nok" THEN
            RETURN "adm-error":u.

        /* Bloco K Desmontagem */
        for last desmont fields (num-trans-desmont) no-lock:
            assign i-num-trans-desmont = desmont.num-trans-desmont + 1.
        end.

        create desmont.
        assign desmont.num-trans-desmont = i-num-trans-desmont
               desmont.dt-trans          = c-dt-trans
               desmont.serie-docto       = c-serie-docto
               desmont.nro-docto         = c-nro-docto
               desmont.ct-codigo         = c-conta-contabil
               desmont.cc-codigo         = c-ccusto
               desmont.nr-ord-produ      = 0
               desmont.nr-reporte        = 0
               desmont.it-codigo         = c-it-codigo
               desmont.referencia        = p-refer
               desmont.cod-estabel       = c-cod-estabel
               desmont.cod-depos         = c-cod-depos
               desmont.cod-localiz       = c-cod-localiz
               desmont.lote              = c-lote
               desmont.quantidade        = de-quantidade
               desmont.un                = c-un
               desmont.conta-aplicacao   = c-conta-contab-aplic
               desmont.ccusto-aplic      = c-ccusto-aplic
               desmont.ind-ult-entr      = l-atu-ult-ent
               desmont.tipo-mov          = 0.
        VALIDATE desmont.
        
        for each tt-movto:
            create movto-desmont.
            assign movto-desmont.num-trans-desmont = i-num-trans-desmont
                   movto-desmont.nr-trans          = tt-movto.nr-trans
                   movto-desmont.it-codigo         = tt-movto.it-codigo
                   movto-desmont.quantidade        = tt-movto.quantidade
                   movto-desmont.tipo-trans        = tt-movto.tipo-trans no-error.
            IF ERROR-STATUS:ERROR THEN
                undo, return "adm-error".
        end.
        /* Fim Bloco K Desmontagem */
    end.   
     
    assign i-valor-mat-m[1] = 0
           i-valor-mob-m[1] = 0
           i-valor-ggf-m[1] = 0.
    if  l-consiste-val-retorno then do:
        for each tt-movto no-lock:
            find movto-estoq 
                where rowid(movto-estoq) = tt-movto.r-mov-inv no-lock no-error.
            if  avail(movto-estoq) then do:
                do  i-x = 1 to 3 :
                    assign i-valor-mat-m[i-x] = i-valor-mat-m[i-x] + movto-estoq.valor-mat-m[i-x]
                           i-valor-mob-m[i-x] = i-valor-mob-m[i-x] + movto-estoq.valor-mob-m[i-x]
                           i-valor-ggf-m[i-x] = i-valor-ggf-m[i-x] + movto-estoq.valor-ggf-m[i-x]
                           i-valor-mat-o[i-x] = i-valor-mat-o[i-x] + movto-estoq.valor-mat-o[i-x]
                           i-valor-mob-o[i-x] = i-valor-mob-o[i-x] + movto-estoq.valor-mob-o[i-x]
                           i-valor-ggf-o[i-x] = i-valor-ggf-o[i-x] + movto-estoq.valor-ggf-o[i-x]
                           i-valor-mat-p[i-x] = i-valor-mat-p[i-x] + movto-estoq.valor-mat-p[i-x]
                           i-valor-mob-p[i-x] = i-valor-mob-p[i-x] + movto-estoq.valor-mob-p[i-x]
                           i-valor-ggf-p[i-x] = i-valor-ggf-p[i-x] + movto-estoq.valor-ggf-p[i-x].
                end.
            end.
        end.
    end.
    for each tt-movto exclusive-lock:
        delete tt-movto.
    end.
    
    RUN RetornaUnidadeNegocio IN h-cdapi024 (INPUT  c-cod-estabel,
                                             INPUT  c-it-codigo,
                                             INPUT  c-cod-depos,
                                             OUTPUT c-cod-unid-negoc).


    create tt-movto.
    assign tt-movto.cod-versao-integracao = 001
           tt-movto.dt-trans     = c-dt-trans
           tt-movto.serie-docto  = c-serie-docto
           tt-movto.nro-docto    = c-nro-docto
           tt-movto.nr-ord-produ = 0
           tt-movto.ct-codigo    = c-conta-contabil
           tt-movto.sc-codigo    = c-ccusto
           tt-movto.it-codigo    = c-it-codigo
           tt-movto.cod-estabel  = c-cod-estabel
           tt-movto.cod-depos    = c-cod-depos
           tt-movto.cod-localiz  = c-cod-localiz
           tt-movto.lote         = c-lote
           tt-movto.cod-refer    = p-refer /** c-refer **/
           tt-movto.quantidade   = de-quantidade
           tt-movto.un           = c-un
           tt-movto.tipo-trans   = 2   /* sa¡da */
           tt-movto.esp-docto    = 6   /* Div */
           tt-movto.cod-prog-orig  = "CP0318"
           tt-movto.cod-unid-negoc = c-cod-unid-negoc
           tt-movto.tipo-valor     = if l-consiste-val-retorno
                                     then 1
                                     else 2.
                                     
    if  l-consiste-val-retorno then do i-x = 1 to 3:
        assign tt-movto.valor-mat-m[i-x] = i-valor-mat-m[i-x]
               tt-movto.valor-ggf-m[i-x] = i-valor-ggf-m[i-x]
               tt-movto.valor-mob-m[i-x] = i-valor-mob-m[i-x]
               tt-movto.valor-mat-o[i-x] = i-valor-mat-o[i-x]
               tt-movto.valor-ggf-o[i-x] = i-valor-ggf-o[i-x]
               tt-movto.valor-mob-o[i-x] = i-valor-mob-o[i-x]
               tt-movto.valor-mat-p[i-x] = 0  /*i-valor-mat-p[i-x]*/
               tt-movto.valor-ggf-p[i-x] = 0  /*i-valor-ggf-p[i-x]*/
               tt-movto.valor-mob-p[i-x] = 0. /*i-valor-mob-p[i-x].*/
    end.
    
    find item 
        where item.it-codigo = c-it-codigo no-lock no-error.
    
    if  item.tipo-contr <> 2 then do:
        /* Item pai ‚ de debito direto ou controle fisico */
        assign tt-movto.ct-db    = c-conta-contab-aplic
               tt-movto.sc-db    = c-ccusto-aplic.
    end.
    
    if  item.tipo-contr = 3 then do:

        if  l-consiste-val-retorno 
        and i-valor-mat-m[1] + i-valor-mob-m[1] + i-valor-ggf-m[1] > 0 then do:
        
            RUN RetornaUnidadeNegocio IN h-cdapi024 (INPUT  c-cod-estabel,
                                                     INPUT  c-it-codigo,
                                                     INPUT  c-cod-depos,
                                                     OUTPUT c-cod-unid-negoc).

            create tt-movto.
            assign tt-movto.cod-versao-integracao = 001
                   tt-movto.dt-trans     = c-dt-trans
                   tt-movto.serie-docto  = c-serie-docto
                   tt-movto.nro-docto    = c-nro-docto
                   tt-movto.nr-ord-produ = 0
                   tt-movto.ct-codigo    = c-conta-contab-aplic
                   tt-movto.sc-codigo    = c-ccusto-aplic
                   tt-movto.it-codigo    = c-it-codigo
                   tt-movto.cod-estabel  = c-cod-estabel
                   tt-movto.cod-depos    = c-cod-depos
                   tt-movto.cod-localiz  = c-cod-localiz
                   tt-movto.lote         = c-lote
                   tt-movto.cod-refer    = p-refer /** c-refer **/
                   tt-movto.quantidade   = 0
                   tt-movto.un           = c-un
                   tt-movto.tipo-trans   = 1   /* entrada */
                   tt-movto.esp-docto    = 6   /* Div */
                   tt-movto.cod-prog-orig  = "CP0318"
                   tt-movto.cod-unid-negoc = c-cod-unid-negoc
                   tt-movto.tipo-valor     = if l-consiste-val-retorno
                                             then 1
                                             else 2.
            
            if  l-consiste-val-retorno then do i-x = 1 to 3:
                assign tt-movto.valor-mat-m[i-x] = i-valor-mat-m[i-x]
                       tt-movto.valor-ggf-m[i-x] = i-valor-ggf-m[i-x]
                       tt-movto.valor-mob-m[i-x] = i-valor-mob-m[i-x]
                       tt-movto.valor-mat-o[i-x] = i-valor-mat-o[i-x]
                       tt-movto.valor-ggf-o[i-x] = i-valor-ggf-o[i-x]
                       tt-movto.valor-mob-o[i-x] = i-valor-mob-o[i-x] 
                       tt-movto.valor-mat-p[i-x] = 0  /*i-valor-mat-p[i-x]*/
                       tt-movto.valor-ggf-p[i-x] = 0  /*i-valor-ggf-p[i-x]*/
                       tt-movto.valor-mob-p[i-x] = 0. /*i-valor-mob-p[i-x].*/
            end.
        end.
    end.

    

    IF NOT VALID-HANDLE(h-ceapi001k) THEN
        RUN cep/ceapi001k.p PERSISTENT SET h-ceapi001k.


    RUN pi-execute IN h-ceapi001k (INPUT-OUTPUT TABLE tt-movto,
                                   INPUT-OUTPUT TABLE tt-erro,
                                   INPUT YES).

    DELETE PROCEDURE h-ceapi001k.

    DELETE OBJECT h-cdapi024.
    
    find first tt-erro no-lock no-error.
    if  avail(tt-erro) then
        return "adm-error".

    IF RETURN-VALUE = "Nok" THEN
        RETURN "adm-error".
    
    /* Bloco K Desmontagem */
    for each tt-movto no-lock:
        create movto-desmont.
        assign movto-desmont.num-trans-desmont = i-num-trans-desmont
               movto-desmont.nr-trans          = tt-movto.nr-trans
               movto-desmont.it-codigo         = tt-movto.it-codigo
               movto-desmont.quantidade        = tt-movto.quantidade
               movto-desmont.tipo-trans        = tt-movto.tipo-trans no-error.
        IF ERROR-STATUS:ERROR THEN
            undo, return "adm-error".
    end.
    /* Fim Bloco K Desmontagem */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE filtraRegistros DBOProgram 
PROCEDURE filtraRegistros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param p-cod-ini  like item.it-codigo no-undo.
    def input  param p-cod-fim  like item.it-codigo no-undo.
    def input  param p-desc-ini like item.desc-item no-undo.
    def input  param p-desc-fim like item.desc-item no-undo.
    def output param table for tt-item.

    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
        EMPTY TEMP-TABLE tt-item.
    &ELSE
        FOR EACH tt-item exclusive-lock:
            DELETE tt-item.
        END.
    &ENDIF                                 

    for each  {&TableName} no-lock
        where {&tablename}.it-codigo >= p-cod-ini
          and {&tablename}.it-codigo <= p-cod-fim
          and {&TableName}.desc-item >= p-desc-ini
          and {&TableName}.desc-item <= p-desc-fim:

        create tt-item.
        buffer-copy {&TableName} to tt-item.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*------------------------------------------------------------------------------
  Purpose:   Procura pelo índice, caso não ache, retorna
                mensagem de erro padrão do  EMS
  Parameters: ipar:c-it-codigo: Item
 ------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter c-it-codigo as char no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToKey (input c-it-codigo).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findComprador DBOProgram 
PROCEDURE findComprador :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo índice, caso não ache, retorna
                mensagem de erro padrão do  EMS
  Parameters:ipar1:c-cod-comprado:Comprador 
             ipar2:c-it-codigo: Item
------------------------------------------------------------------------------*/
    /* ------------------------ PROXIES BO 1.1 ----------------------------- */
     
    def input parameter c-cod-comprado as char no-undo.
    def input parameter c-it-codigo as char no-undo.
    def output parameter pcreturn as char no-undo.
         
         
    RUN openQueryStatic (input "Main":U).
     
    run goToComprador (input c-cod-comprado,
                       input c-it-codigo).
 
    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
    end.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findContaReduzida DBOProgram 
PROCEDURE findContaReduzida :
/*------------------------------------------------------------------------------
  Purpose:     Localizar a conta-contabil de acordo com a conta reduzida informada.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-empresa-prin LIKE empresa.ep-codigo  no-undo.
    def input param p-reduzida     as char no-undo.
    def output param p-conta       as char no-undo.

    if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.  
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (INPUT p-empresa-prin,
                                              INPUT "",
                                              INPUT-OUTPUT p-reduzida,
                                              INPUT TODAY,
                                              OUTPUT p_des_titulo,
                                              OUTPUT v_num_tip_cta_ctbl,
                                              OUTPUT v_num_sit_cta_ctbl,
                                              OUTPUT v_ind_finalid_cta,
                                              OUTPUT TABLE tt_log_erro).
												  
	 if not can-find(first tt_log_erro) then do:
		assign p-conta = p-reduzida.
	 end.
	 
	if valid-handle(h_api_cta_ctbl) then
		delete object h_api_cta_ctbl.	 
	 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFirstMain DBOProgram 
PROCEDURE findFirstMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
     FIND FIRST item NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findGrupo DBOProgram 
PROCEDURE findGrupo :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo índice, caso não ache, retorna
                mensagem de erro padrão do  EMS
  Parameters:ipar1:i-ge-codigo:Grupo Estoque
             ipar2:c-it-codigo: Item
------------------------------------------------------------------------------*/
    /* ------------------------ PROXIES BO 1.1 ----------------------------- */

    def input parameter i-ge-codigo as inte no-undo.
    def input parameter c-it-codigo as char no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToGrupo (input i-ge-codigo,
                   input c-it-codigo).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
    end.       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findKeyRowid DBOProgram 
PROCEDURE findKeyRowid :
/*------------------------------------------------------------------------------
  Purpose:   Localiza registro pela chave e retorna o rowid.
  Parameters:ipar:p-it-codigo:Item
             opar:p-rowid:Rowid que será retornado
  -----------------------------------------------------------------------------*/  
    def input  parameter p-it-codigo like item.it-codigo.
    def output parameter p-rowid as rowid no-undo.

    find {&TABLENAME} where
        {&tablename}.it-codigo = p-it-codigo
        no-lock no-error.
    if available {&TABLENAME} then
        assign p-rowid = rowid({&TABLENAME}).
        assign p-rowid = rowid({&TABLENAME}).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLastMain DBOProgram 
PROCEDURE findLastMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
     FIND LAST item NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLinha DBOProgram 
PROCEDURE findLinha :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo índice, caso não ache, retorna
                mensagem de erro padrão do  EMS
  Parameters:ipar1:i-nr-linha:Linha Produção 
             ipar2:c-it-codigo: Item
------------------------------------------------------------------------------*/
    /* ------------------------ PROXIES BO 1.1 ----------------------------- */    
    def input parameter i-nr-linha as inte no-undo.
    def input parameter c-it-codigo as char no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToLinha (input i-nr-linha,
                   input c-it-codigo).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findMovtoEstoq DBOProgram 
PROCEDURE findMovtoEstoq :
/*------------------------------------------------------------------------------
  Purpose:     Procura um movto de estoque que j  exista com o n£mero de s‚rie
               e documento informado.
  Parameters:  <none>
  Notes:       Esta procedure deve estar na bo do movto-estoq, por‚m esta BO encontrava-se
               com problemas no momento em que este c¢digo era necess rio, entÆo optou-se 
               por criar esta procedure aqui.  
------------------------------------------------------------------------------*/
    def  input param p-serie-docto as char no-undo.
    def  input param p-nro-docto   as char no-undo.
    def output param p-avail-movto as log  no-undo.

    find first movto-estoq 
        where movto-estoq.serie-docto = p-serie-docto 
          and movto-estoq.nro-docto   = p-nro-docto no-lock no-error.
    assign p-avail-movto = avail movto-estoq.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNextMain DBOProgram 
PROCEDURE findNextMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
     FIND NEXT item NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPlanejador DBOProgram 
PROCEDURE findPlanejador :
/*------------------------------------------------------------------------------
  Purpose:   Procura pelo índice, caso não ache, retorna
             mensagem de erro padrão do  EMS
  Parameters:ipar1:c-cd-planejado:Planejador
             ipar2:c-it-codigo: Item
             ipar3:i-tipo-contr:Tipo Controle
             ipar4:i-tipo-requis:Tipo Requisição
------------------------------------------------------------------------------*/
    /* ------------------------ PROXIES BO 1.1 ----------------------------- */    
    def input parameter c-cd-planejado as char no-undo.
    def input parameter c-it-codigo as char no-undo.
    def input parameter i-tipo-contr as inte no-undo.
    def input parameter i-tipo-requis as inte no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToPlanejador (input c-cd-planejado,
                        input c-it-codigo,
                        input i-tipo-contr,
                        input i-tipo-requis).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPrevMain DBOProgram 
PROCEDURE findPrevMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
     FIND PREV item NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findUn DBOProgram 
PROCEDURE findUn :
/*------------------------------------------------------------------------------
  Purpose:   Procura pelo índice, caso não ache, retorna
             mensagem de erro padrão do  EMS
  Parameters:ipar1:c-un:Unidade Medida
             ipar2:c-it-codigo: Item
------------------------------------------------------------------------------*/
    /* ------------------------ PROXIES BO 1.1 ----------------------------- */    
    def input parameter c-un as char no-undo.
    def input parameter c-it-codigo as char no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToUn (input c-un,
                input c-it-codigo).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
    end.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cd-folh-item":U THEN ASSIGN pFieldValue = RowObject.cd-folh-item.            
        WHEN "cd-folh-lote":U THEN ASSIGN pFieldValue = RowObject.cd-folh-lote.
        WHEN "cd-planejado":U THEN ASSIGN pFieldValue = RowObject.cd-planejado.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "class-fiscal":U THEN ASSIGN pFieldValue = RowObject.class-fiscal.
        WHEN "cod-auxiliar":U THEN ASSIGN pFieldValue = RowObject.cod-auxiliar.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-produto":U THEN ASSIGN pFieldValue = RowObject.cod-produto.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "codigo-refer":U THEN ASSIGN pFieldValue = RowObject.codigo-refer.
        WHEN "de-codigo-prin":U THEN ASSIGN pFieldValue = RowObject.de-codigo-prin.
        WHEN "deposito-pad":U THEN ASSIGN pFieldValue = RowObject.deposito-pad.
        WHEN "desc-inter":U THEN ASSIGN pFieldValue = RowObject.desc-inter.        
        WHEN "desc-nacional":U THEN ASSIGN pFieldValue = RowObject.desc-nacional.        
        WHEN "descricao-1":U THEN ASSIGN pFieldValue = RowObject.descricao-1.
        WHEN "descricao-2":U THEN ASSIGN pFieldValue = RowObject.descricao-2.        
        WHEN "fm-cod-com":U THEN ASSIGN pFieldValue = RowObject.fm-cod-com.
        WHEN "fm-codigo":U THEN ASSIGN pFieldValue = RowObject.fm-codigo.        
        WHEN "inform-compl":U THEN ASSIGN pFieldValue = RowObject.inform-compl.        
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.        
        WHEN "it-demanda":U THEN ASSIGN pFieldValue = RowObject.it-demanda.        
        WHEN "niv-rest-fora":U THEN ASSIGN pFieldValue = RowObject.niv-rest-fora.
        WHEN "niv-rest-icms":U THEN ASSIGN pFieldValue = RowObject.niv-rest-icms.        
        WHEN "path":U THEN ASSIGN pFieldValue = RowObject.path.        
        WHEN "responsavel":U THEN ASSIGN pFieldValue = RowObject.responsavel.        
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.        
        WHEN "usuario-alt":U THEN ASSIGN pFieldValue = RowObject.usuario-alt.
        WHEN "usuario-obsol":U THEN ASSIGN pFieldValue = RowObject.usuario-obsol.                    
        WHEN "dsl-destaq":U THEN ASSIGN pFieldValue = RowObject.dsl-destaq.
        WHEN "desc-item":U THEN ASSIGN pFieldValue = RowObject.desc-item.
        WHEN "cd-referencia":U THEN ASSIGN pFieldValue = RowObject.cd-referencia.
        WHEN "cd-tag":U THEN ASSIGN pFieldValue = RowObject.cd-tag.            
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "prefixo-lote":U THEN ASSIGN pFieldValue = RowObject.prefixo-lote.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "cod-imagem":U THEN ASSIGN pFieldValue = RowObject.cod-imagem.
        WHEN "cod-lista-destino":U THEN ASSIGN pFieldValue = RowObject.cod-lista-destino.            
        WHEN "conta-aplicacao":U THEN ASSIGN pFieldValue = RowObject.conta-aplicacao.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.            
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.            
        WHEN "cod-item-refugo":U THEN ASSIGN pFieldValue = RowObject.cod-item-refugo.       
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-base":U THEN ASSIGN pFieldValue = RowObject.data-base.
        WHEN "data-implant":U THEN ASSIGN pFieldValue = RowObject.data-implant.
        WHEN "data-liberac":U THEN ASSIGN pFieldValue = RowObject.data-liberac.
        WHEN "data-obsol":U THEN ASSIGN pFieldValue = RowObject.data-obsol.
        WHEN "data-ult-con":U THEN ASSIGN pFieldValue = RowObject.data-ult-con.
        WHEN "data-ult-ent":U THEN ASSIGN pFieldValue = RowObject.data-ult-ent.
        WHEN "data-ult-rep":U THEN ASSIGN pFieldValue = RowObject.data-ult-rep.
        WHEN "data-ult-sai":U THEN ASSIGN pFieldValue = RowObject.data-ult-sai.
        WHEN "dt-pr-fisc":U THEN ASSIGN pFieldValue = RowObject.dt-pr-fisc.
        WHEN "dt-ult-ben":U THEN ASSIGN pFieldValue = RowObject.dt-ult-ben.
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.            
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-ISS":U THEN ASSIGN pFieldValue = RowObject.aliquota-ISS.    
        WHEN "altura":U THEN ASSIGN pFieldValue = RowObject.altura.    
        WHEN "cap-est-fabr":U THEN ASSIGN pFieldValue = RowObject.cap-est-fabr.                        
        WHEN "comprim":U THEN ASSIGN pFieldValue = RowObject.comprim.
        WHEN "concentracao":U THEN ASSIGN pFieldValue = RowObject.concentracao.
        WHEN "consumo-aad":U THEN ASSIGN pFieldValue = RowObject.consumo-aad.
        WHEN "consumo-prev":U THEN ASSIGN pFieldValue = RowObject.consumo-prev.        
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "fator-conver":U THEN ASSIGN pFieldValue = RowObject.fator-conver.
        WHEN "fator-refugo":U THEN ASSIGN pFieldValue = RowObject.fator-refugo.
        WHEN "ft-conv-fmcoml":U THEN ASSIGN pFieldValue = RowObject.ft-conv-fmcoml.
        WHEN "ft-conversao":U THEN ASSIGN pFieldValue = RowObject.ft-conversao.
        WHEN "largura":U THEN ASSIGN pFieldValue = RowObject.largura.
        WHEN "lote-economi":U THEN ASSIGN pFieldValue = RowObject.lote-economi.
        WHEN "lote-minimo":U THEN ASSIGN pFieldValue = RowObject.lote-minimo.
        WHEN "lote-multipl":U THEN ASSIGN pFieldValue = RowObject.lote-multipl.
        WHEN "lote-mulven":U THEN ASSIGN pFieldValue = RowObject.lote-mulven.
        WHEN "per-min-luc":U THEN ASSIGN pFieldValue = RowObject.per-min-luc.
        WHEN "per-rest-fora":U THEN ASSIGN pFieldValue = RowObject.per-rest-fora.
        WHEN "per-rest-icms":U THEN ASSIGN pFieldValue = RowObject.per-rest-icms.
        WHEN "perc-demanda":U THEN ASSIGN pFieldValue = RowObject.perc-demanda.
        WHEN "perc-nqa":U THEN ASSIGN pFieldValue = RowObject.perc-nqa.
        WHEN "peso-bruto":U THEN ASSIGN pFieldValue = RowObject.peso-bruto.
        WHEN "peso-liquido":U THEN ASSIGN pFieldValue = RowObject.peso-liquido.
        WHEN "pr-sem-tx":U THEN ASSIGN pFieldValue = RowObject.pr-sem-tx.
        WHEN "preco-base":U THEN ASSIGN pFieldValue = RowObject.preco-base.
        WHEN "preco-fiscal":U THEN ASSIGN pFieldValue = RowObject.preco-fiscal.
        WHEN "preco-repos":U THEN ASSIGN pFieldValue = RowObject.preco-repos.
        WHEN "preco-ul-ent":U THEN ASSIGN pFieldValue = RowObject.preco-ul-ent.
        WHEN "qt-max-ordem":U THEN ASSIGN pFieldValue = RowObject.qt-max-ordem.                    
        WHEN "quant-perda":U THEN ASSIGN pFieldValue = RowObject.quant-perda.
        WHEN "quant-segur":U THEN ASSIGN pFieldValue = RowObject.quant-segur.                    
        WHEN "rendimento":U THEN ASSIGN pFieldValue = RowObject.rendimento.
        WHEN "tp-cons-prev":U THEN ASSIGN pFieldValue = RowObject.tp-cons-prev.
        WHEN "tx-importacao":U THEN ASSIGN pFieldValue = RowObject.tx-importacao.
        WHEN "var-mob-maior":U THEN ASSIGN pFieldValue = RowObject.var-mob-maior.
        WHEN "var-mob-menor":U THEN ASSIGN pFieldValue = RowObject.var-mob-menor.
        WHEN "var-rep":U THEN ASSIGN pFieldValue = RowObject.var-rep.
        WHEN "var-req-maior":U THEN ASSIGN pFieldValue = RowObject.var-req-maior.
        WHEN "var-req-menor":U THEN ASSIGN pFieldValue = RowObject.var-req-menor.
        WHEN "var-transf":U THEN ASSIGN pFieldValue = RowObject.var-transf.
        WHEN "variac-acum":U THEN ASSIGN pFieldValue = RowObject.variac-acum.
        WHEN "vl-mat-ant":U THEN ASSIGN pFieldValue = RowObject.vl-mat-ant.
        WHEN "vl-mob-ant":U THEN ASSIGN pFieldValue = RowObject.vl-mob-ant.        
        WHEN "volume":U THEN ASSIGN pFieldValue = RowObject.volume.                                
        WHEN "fator-reaj-icms":U THEN ASSIGN pFieldValue = RowObject.fator-reaj-icms.        
        WHEN "qt-var-max":U THEN ASSIGN pFieldValue = RowObject.qt-var-max.
        WHEN "qt-var-min":U THEN ASSIGN pFieldValue = RowObject.qt-var-min.            
        WHEN "qtd-batch-padrao":U THEN ASSIGN pFieldValue = RowObject.qtd-batch-padrao.
        WHEN "qtd-refer-custo-dis":U THEN ASSIGN pFieldValue = RowObject.qtd-refer-custo-dis.
        WHEN "quant-pacote":U THEN ASSIGN pFieldValue = RowObject.quant-pacote.
        WHEN "valor-ipi-beb":U THEN ASSIGN pFieldValue = RowObject.valor-ipi-beb.            
        WHEN "val-fator-custo-dis":U THEN ASSIGN pFieldValue = RowObject.val-fator-custo-dis.
        WHEN "vl-var-max":U THEN ASSIGN pFieldValue = RowObject.vl-var-max.
        WHEN "vl-var-min":U THEN ASSIGN pFieldValue = RowObject.vl-var-min.
        WHEN "val-relac-refugo-item":U THEN ASSIGN pFieldValue = RowObject.val-relac-refugo-item.  
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDetalheItem DBOProgram 
PROCEDURE getDetalheItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM r-rowid       AS ROWID   NO-UNDO.
DEF OUTPUT PARAM i-cod-destaq  AS INTEGER NO-UNDO.
DEF OUTPUT PARAM c-dsl-destaq  AS CHAR    NO-UNDO.

    FIND FIRST bf{&TableName}
        WHERE ROWID(bf{&TableName}) = r-rowid NO-LOCK NO-ERROR.
    
    IF AVAIL bf{&TableName} THEN DO:
        ASSIGN i-cod-destaq = bf{&TableName}.cod-destaq
               c-dsl-destaq = bf{&TableName}.dsl-destaq.
    END.
    
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "calc-lead-time":U THEN ASSIGN pFieldValue = RowObject.calc-lead-time.    
        WHEN "cd-formula":U THEN ASSIGN pFieldValue = RowObject.cd-formula.
        WHEN "cd-origem":U THEN ASSIGN pFieldValue = RowObject.cd-origem.     
        WHEN "ciclo-contag":U THEN ASSIGN pFieldValue = RowObject.ciclo-contag.        
        WHEN "cod-obsoleto":U THEN ASSIGN pFieldValue = RowObject.cod-obsoleto.
        WHEN "cod-servico":U THEN ASSIGN pFieldValue = RowObject.cod-servico.           
        WHEN "codigo-orig":U THEN ASSIGN pFieldValue = RowObject.codigo-orig.        
        WHEN "contr-plan":U THEN ASSIGN pFieldValue = RowObject.contr-plan.        
        WHEN "dec-conv-fmcoml":U THEN ASSIGN pFieldValue = RowObject.dec-conv-fmcoml.
        WHEN "dec-ftcon":U THEN ASSIGN pFieldValue = RowObject.dec-ftcon.
        WHEN "div-ordem":U THEN ASSIGN pFieldValue = RowObject.div-ordem.
        WHEN "ge-codigo":U THEN ASSIGN pFieldValue = RowObject.ge-codigo.
        WHEN "horiz-fixo":U THEN ASSIGN pFieldValue = RowObject.horiz-fixo.
        WHEN "ind-imp-desc":U THEN ASSIGN pFieldValue = RowObject.ind-imp-desc.
        WHEN "INT-1":U THEN ASSIGN pFieldValue = RowObject.INT-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "isencao-import":U THEN ASSIGN pFieldValue = RowObject.isencao-import.
        WHEN "moeda-padrao":U THEN ASSIGN pFieldValue = RowObject.moeda-padrao.
        WHEN "nat-despesa":U THEN ASSIGN pFieldValue = RowObject.nat-despesa.
        WHEN "niv-mais-bai":U THEN ASSIGN pFieldValue = RowObject.niv-mais-bai.
        WHEN "niv-mps":U THEN ASSIGN pFieldValue = RowObject.niv-mps.
        WHEN "nivel":U THEN ASSIGN pFieldValue = RowObject.nivel.
        WHEN "nr-item-dcr":U THEN ASSIGN pFieldValue = RowObject.nr-item-dcr.
        WHEN "nr-linha":U THEN ASSIGN pFieldValue = RowObject.nr-linha.        
        WHEN "periodo-fixo":U THEN ASSIGN pFieldValue = RowObject.periodo-fixo.
        WHEN "perm-saldo-neg":U THEN ASSIGN pFieldValue = RowObject.perm-saldo-neg.
        WHEN "prioridade":U THEN ASSIGN pFieldValue = RowObject.prioridade.
        WHEN "rep-prod":U THEN ASSIGN pFieldValue = RowObject.rep-prod.
        WHEN "res-cq-comp":U THEN ASSIGN pFieldValue = RowObject.res-cq-comp.
        WHEN "res-cq-fabri":U THEN ASSIGN pFieldValue = RowObject.res-cq-fabri.
        WHEN "res-for-comp":U THEN ASSIGN pFieldValue = RowObject.res-for-comp.
        WHEN "res-int-comp":U THEN ASSIGN pFieldValue = RowObject.res-int-comp.
        WHEN "ressup-fabri":U THEN ASSIGN pFieldValue = RowObject.ressup-fabri.
        WHEN "tempo-segur":U THEN ASSIGN pFieldValue = RowObject.tempo-segur.   
        WHEN "tipo-con-est":U THEN ASSIGN pFieldValue = RowObject.tipo-con-est.             
        WHEN "tipo-insp":U THEN ASSIGN pFieldValue = RowObject.tipo-insp.        
        WHEN "tp-adm-lote":U THEN ASSIGN pFieldValue = RowObject.tp-adm-lote.
        WHEN "tp-aloc-lote":U THEN ASSIGN pFieldValue = RowObject.tp-aloc-lote.
        WHEN "tp-desp-padrao":U THEN ASSIGN pFieldValue = RowObject.tp-desp-padrao.        
        WHEN "cod-destaq":U THEN ASSIGN pFieldValue = RowObject.cod-destaq.
        WHEN "demanda":U THEN ASSIGN pFieldValue = RowObject.demanda.
        WHEN "emissao-ord":U THEN ASSIGN pFieldValue = RowObject.emissao-ord.
        WHEN "enquad-beb":U THEN ASSIGN pFieldValue = RowObject.enquad-beb.
        WHEN "esp-beb":U THEN ASSIGN pFieldValue = RowObject.esp-beb.
        WHEN "fase-medio":U THEN ASSIGN pFieldValue = RowObject.fase-medio.
        WHEN "calc-cons-prev":U THEN ASSIGN pFieldValue = RowObject.calc-cons-prev.
        WHEN "capac-recip-beb":U THEN ASSIGN pFieldValue = RowObject.capac-recip-beb.
        WHEN "cd-trib-icm":U THEN ASSIGN pFieldValue = RowObject.cd-trib-icm.
        WHEN "cd-trib-ipi":U THEN ASSIGN pFieldValue = RowObject.cd-trib-ipi.
        WHEN "cd-trib-iss":U THEN ASSIGN pFieldValue = RowObject.cd-trib-iss.
        WHEN "ind-calc-meta":U THEN ASSIGN pFieldValue = RowObject.ind-calc-meta.
        WHEN "ind-prev-demanda":U THEN ASSIGN pFieldValue = RowObject.ind-prev-demanda.
        WHEN "ind-serv-mat":U THEN ASSIGN pFieldValue = RowObject.ind-serv-mat.
        WHEN "nivel-apr-compra":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-compra.
        WHEN "nivel-apr-manut":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-manut.
        WHEN "nivel-apr-requis":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-requis.
        WHEN "nivel-apr-solic":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-solic.
        WHEN "nr-pontos-quotas":U THEN ASSIGN pFieldValue = RowObject.nr-pontos-quotas.
        WHEN "Nr-ult-peca":U THEN ASSIGN pFieldValue = RowObject.Nr-ult-peca.
        WHEN "politica":U THEN ASSIGN pFieldValue = RowObject.politica.
        WHEN "reporte-ggf":U THEN ASSIGN pFieldValue = RowObject.reporte-ggf.
        WHEN "reporte-mob":U THEN ASSIGN pFieldValue = RowObject.reporte-mob.
        WHEN "resumo-mp":U THEN ASSIGN pFieldValue = RowObject.resumo-mp.
        WHEN "sit-aloc":U THEN ASSIGN pFieldValue = RowObject.sit-aloc.
        WHEN "tipo-atp":U THEN ASSIGN pFieldValue = RowObject.tipo-atp.
        WHEN "tipo-contr":U THEN ASSIGN pFieldValue = RowObject.tipo-contr.
        WHEN "tipo-desc-nt":U THEN ASSIGN pFieldValue = RowObject.tipo-desc-nt.
        WHEN "tipo-est-seg":U THEN ASSIGN pFieldValue = RowObject.tipo-est-seg.
        WHEN "tipo-lote-ec":U THEN ASSIGN pFieldValue = RowObject.tipo-lote-ec.
        WHEN "tipo-recip-beb":U THEN ASSIGN pFieldValue = RowObject.tipo-recip-beb.
        WHEN "tipo-requis":U THEN ASSIGN pFieldValue = RowObject.tipo-requis.
        WHEN "tipo-sched":U THEN ASSIGN pFieldValue = RowObject.tipo-sched.
        WHEN "classe-repro":U THEN ASSIGN pFieldValue = RowObject.classe-repro.
        WHEN "classif-abc":U THEN ASSIGN pFieldValue = RowObject.classif-abc.
        WHEN "cod-tax":U THEN ASSIGN pFieldValue = RowObject.cod-tax.
        WHEN "cod-tax-serv":U THEN ASSIGN pFieldValue = RowObject.cod-tax-serv.
        WHEN "compr-fabric":U THEN ASSIGN pFieldValue = RowObject.compr-fabric.
        WHEN "criticidade":U THEN ASSIGN pFieldValue = RowObject.criticidade.            
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice CODIGO
  Parameters:
               retorna valor dos campos do ¡ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item.it-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo.

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "atu-conf":U THEN ASSIGN pFieldValue = RowObject.atu-conf.    
        WHEN "baixa-estoq":U THEN ASSIGN pFieldValue = RowObject.baixa-estoq.
        WHEN "contr-qualid":U THEN ASSIGN pFieldValue = RowObject.contr-qualid.                
        WHEN "curva-abc":U THEN ASSIGN pFieldValue = RowObject.curva-abc.
        WHEN "fraciona":U THEN ASSIGN pFieldValue = RowObject.fraciona.
        WHEN "id-grade":U THEN ASSIGN pFieldValue = RowObject.id-grade.
        WHEN "ind-backorder":U THEN ASSIGN pFieldValue = RowObject.ind-backorder.
        WHEN "ind-especifico":U THEN ASSIGN pFieldValue = RowObject.ind-especifico.
        WHEN "ind-inf-qtf":U THEN ASSIGN pFieldValue = RowObject.ind-inf-qtf.
        WHEN "ind-ipi-dife":U THEN ASSIGN pFieldValue = RowObject.ind-ipi-dife.
        WHEN "ind-item-fat":U THEN ASSIGN pFieldValue = RowObject.ind-item-fat.
        WHEN "loc-unica":U THEN ASSIGN pFieldValue = RowObject.loc-unica.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "pm-ja-calc":U THEN ASSIGN pFieldValue = RowObject.pm-ja-calc.            
        WHEN "alt-refer":U THEN ASSIGN pFieldValue = RowObject.alt-refer.
        WHEN "incentivado":U THEN ASSIGN pFieldValue = RowObject.incentivado.
        WHEN "ind-confprodcom":U THEN ASSIGN pFieldValue = RowObject.ind-confprodcom.
        WHEN "ind-quotas":U THEN ASSIGN pFieldValue = RowObject.ind-quotas.
        WHEN "log-atualiz-via-mmp":U THEN ASSIGN pFieldValue = RowObject.log-atualiz-via-mmp.
        WHEN "log-carac-tec":U THEN ASSIGN pFieldValue = RowObject.log-carac-tec.
        WHEN "log-utiliza-batch-padrao":U THEN ASSIGN pFieldValue = RowObject.log-utiliza-batch-padrao.
        WHEN "rot-quant":U THEN ASSIGN pFieldValue = RowObject.rot-quant.
        WHEN "rot-refer":U THEN ASSIGN pFieldValue = RowObject.rot-refer.
        WHEN "rot-revis":U THEN ASSIGN pFieldValue = RowObject.rot-revis.
        WHEN "tp-lote-econom":U THEN ASSIGN pFieldValue = RowObject.tp-lote-econom.
        WHEN "tp-lote-minimo":U THEN ASSIGN pFieldValue = RowObject.tp-lote-minimo.
        WHEN "tp-lote-multiplo":U THEN ASSIGN pFieldValue = RowObject.tp-lote-multiplo.
        WHEN "conv-tempo-seg":U THEN ASSIGN pFieldValue = RowObject.conv-tempo-seg.        
        WHEN "log-control-estoq-refugo":U THEN ASSIGN pFieldValue = RowObject.log-control-estoq-refugo. 
        WHEN "log-refugo-preco-fisc":U THEN ASSIGN pFieldValue = RowObject.log-refugo-preco-fisc.
        WHEN "log-necessita-li":U THEN ASSIGN pFieldValue = RowObject.log-necessita-li.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetPaisImpto DBOProgram 
PROCEDURE GetPaisImpto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM p-pais-impto-usuario AS INT NO-UNDO.

{method/svc/autentic/autentic.i 
    &vUserCountryTax="i-pais-impto-usuario"}

   ASSIGN p-pais-impto-usuario = i-pais-impto-usuario.

        return "OK".
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
               retorna status do processo
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToComprador DBOProgram 
PROCEDURE goToComprador :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo índice, caso não ache, retorna
                mensagem de erro padrão do  EMS
  Parameters:ipar1:pcod-comprado:Comprador 
             ipar2:pit-codigo: Item
------------------------------------------------------------------------------*/
    def input parameter pcod-comprado as char no-undo.
    def input parameter pit-codigo as char no-undo.

    FIND FIRST bfitem WHERE
        bfitem.cod-comprado = pcod-comprado and
        bfitem.it-codigo = pit-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToGrupo DBOProgram 
PROCEDURE goToGrupo :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo índice, caso não ache, retorna
                mensagem de erro padrão do  EMS
  Parameters:ipar1:pge-codigo:Grupo Estoque
             ipar2:pit-codigo: Item
------------------------------------------------------------------------------*/
    def input parameter pge-codigo as inte no-undo.
    def input parameter pit-codigo as char no-undo.

    FIND FIRST bfitem WHERE
        bfitem.ge-codigo = pge-codigo and
        bfitem.it-codigo = pit-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.   
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToItem DBOProgram 
PROCEDURE goToItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
    DEFINE INPUT PARAMETER prow_id AS ROWID NO-UNDO.
  
    /*Reposiciona a query atraves do e rowid e verifica a existencia de error.
      Caso exista error, será retornado a flag "NOK" */
     
    RUN repositionRecord in THIS-PROCEDURE(INPUT prow_id).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
     
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice CODIGO
  Parameters:
               recebe valor dos campos do ¡ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item.it-codigo NO-UNDO.

    FIND FIRST bfitem WHERE
        bfitem.it-codigo = pit-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyDemanda DBOProgram 
PROCEDURE goToKeyDemanda :
/*------------------------------------------------------------------------------
  Purpose:     Procura o registro com o item informado e demanda = 1
  Parameters:  i - c¢digo do item
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item.it-codigo NO-UNDO.

    FIND FIRST bfitem WHERE
        bfitem.it-codigo = pit-codigo AND
        bfitem.demanda   = 1
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyRowid DBOProgram 
PROCEDURE goToKeyRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prowid AS rowid NO-UNDO.

    FIND FIRST bfitem WHERE
         rowid(bfitem) = prowid
         NO-LOCK NO-ERROR.
   
    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToLinha DBOProgram 
PROCEDURE goToLinha :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo índice, caso não ache, retorna
              mensagem de erro padrão do  EMS
  Parameters: ipar1:pnr-linha:Linha Produção 
              ipar2:pit-codigo: Item
------------------------------------------------------------------------------*/
    def input parameter pnr-linha as inte no-undo.
    def input parameter pit-codigo as char no-undo.

    FIND FIRST bfitem WHERE
        bfitem.nr-linha = pnr-linha and
        bfitem.it-codigo = pit-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToPlanejador DBOProgram 
PROCEDURE goToPlanejador :
/*------------------------------------------------------------------------------
  Purpose:   Procura pelo índice, caso não ache, retorna
             mensagem de erro padrão do  EMS
  Parameters:ipar1:pcd-planejado:Planejador
             ipar2:pit-codigo: Item
             ipar3:ptipo-contr:Tipo Controle
             ipar4:ptipo-requis:Tipo Requisição
------------------------------------------------------------------------------*/
    def input parameter pcd-planejado as char no-undo.
    def input parameter pit-codigo as char no-undo.
    def input parameter ptipo-contr as inte no-undo.
    def input parameter ptipo-requis as inte no-undo.

    FIND FIRST bfitem WHERE
        bfitem.cd-planejado = pcd-planejado and
        bfitem.it-codigo = pit-codigo and
        bfitem.tipo-contr = ptipo-contr and
        bfitem.tipo-requis = ptipo-requis
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToUn DBOProgram 
PROCEDURE goToUn :
/*------------------------------------------------------------------------------
  Purpose:   Procura pelo índice, caso não ache, retorna
             mensagem de erro padrão do  EMS
  Parameters:ipar1:pun:Unidade Medida
             ipar2:pit-codigo: Item
------------------------------------------------------------------------------*/
    def input parameter pun as char no-undo.
    def input parameter pit-codigo as char no-undo.

    FIND FIRST bfitem WHERE
        bfitem.un = pun and
        bfitem.it-codigo = pit-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicializaDesmontagem DBOProgram 
PROCEDURE inicializaDesmontagem :
/*------------------------------------------------------------------------------
  Purpose:     Inicializar a tabela tempor ria para desmontagem de itens.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-it-codigo                 as char no-undo.
    def input param p-sequencia                 as INT  no-undo.
    def input param p-dt-validade               as date no-undo.
    def input param p-cod-estabel               as char no-undo.
    def input param p-lote                      as char no-undo.
    def input param p-refer                     as char no-undo.
    def input param l-consiste-valor-retorno    as log  no-undo.
    def input param p-percentual-acrescimo      as dec  no-undo.
    def input param p-conta-contabil-aplicacao  as char no-undo.
    def input param p-ccusto-aplicacao  as char no-undo.
    def input-output param table for tt-depos.
    def input-output param table for tt-work.
    def input-output param table for tt-raw-transfere.

    /*Foi criado novo programa para esta procedure, pois a BO estava estourada*/
    run inbo/boin172m.p(input p-it-codigo,
                        INPUT p-sequencia,
                        input p-dt-validade,
                        input p-cod-estabel,
                        input p-lote,
                        input p-refer,
                        input l-consiste-valor-retorno,
                        input p-percentual-acrescimo,
                        input p-conta-contabil-aplicacao,
                        input p-ccusto-aplicacao,
                        input-output table tt-depos,
                        input-output table tt-work,
                        input-output table tt-raw-transfere,
                        input ldesmonta).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicializaDesmontagemConfOrdem DBOProgram 
PROCEDURE inicializaDesmontagemConfOrdem :
/*------------------------------------------------------------------------------
  Purpose:     Inicializar a tabela tempor ria para desmontagem de itens.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &IF DEFINED(bf_man_204) &THEN
         def input param p-it-codigo                 as char no-undo.
         def input param p-dt-validade               as date no-undo.
         def input param p-cod-estabel               as char no-undo.
         def input param p-lote                      as char no-undo.
         def input param p-refer                     as char no-undo.
         def input param l-consiste-valor-retorno    as log  no-undo.
         def input param p-percentual-acrescimo      as dec  no-undo.
         def input param p-conta-contabil-aplicacao  as char no-undo.
         def input param p-ccusto-aplicacao          as char no-undo.
         DEF INPUT PARAM p-nr-ord-produ              AS INT  NO-UNDO.
         DEF INPUT PARAM p-nr-reporte                AS INT  NO-UNDO.
         DEF INPUT PARAM p-movt-ordem                AS LOG  NO-UNDO.
         DEF INPUT PARAM p-tp-movto                  AS INT  NO-UNDO.
         DEF INPUT PARAM p-quant-devolvida           AS DEC  NO-UNDO.
         DEF INPUT PARAM p-config                    AS LOG  NO-UNDO.
         def input-output param table for tt-depos.
         def input-output param table for tt-work.
         def input-output param table for tt-raw-transfere.


         RUN cpp/cp0318d.p (INPUT p-it-codigo,
                            INPUT p-dt-validade,
                            INPUT p-cod-estabel,
                            INPUT p-lote,
                            INPUT p-refer,
                            INPUT l-consiste-valor-retorno,
                            INPUT p-percentual-acrescimo,
                            INPUT p-conta-contabil-aplicacao,
                            INPUT p-ccusto-aplicacao,
                            INPUT p-nr-ord-produ,
                            INPUT p-nr-reporte,
                            INPUT p-movt-ordem,
                            INPUT p-tp-movto,
                            INPUT p-quant-devolvida,
                            INPUT p-config,
                            INPUT-OUTPUT TABLE tt-depos,
                            INPUT-OUTPUT TABLE tt-work,
                            INPUT-OUTPUT TABLE tt-raw-transfere).


    &endif

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE montaListaEstabelecimentosItem DBOProgram 
PROCEDURE montaListaEstabelecimentosItem :
/*------------------------------------------------------------------------------
  Purpose:    Monta a Lista de estabelecimentos do Item. 
  Parameters: ipar1  : p-r-rowid            : Rowid do Item corrente da interface
               opar2  : p-c-lista-estab-item : Estabelecimento usado no cálculo
 ------------------------------------------------------------------------------*/
    def input  param p-r-rowid            as rowid no-undo.
    def output param p-c-lista-estab-item as char  no-undo.

    def var c-lista-estabel as char no-undo.
    def var c-chave-item    as char no-undo.

    assign c-chave-item = string(p-r-rowid).

    find item where rowid(item) = to-rowid(c-chave-item) no-lock no-error.
    if avail item then do:
      for each item-estab where item-estab.it-codigo = item.it-codigo no-lock:
          assign c-lista-estabel = c-lista-estabel
                         + (if num-entries(c-lista-estabel) > 0 then "," else "")
                         + item-estab.cod-estabel.
      end.
      IF c-lista-estabel = "" THEN
          assign c-lista-estabel = item.cod-estabel.
    end.
    assign p-c-lista-estab-item = c-lista-estabel.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH ITEM NO-LOCK INDEXED-REPOSITION.

return 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    define input parameter i-abertura as integer no-undo.
       case i-abertura:
           when 1 then
              RUN openQueryStatic (input "Main":U). 
              
           when 6 then
              RUN openQueryStatic (input "ByFiltroItCodigo":U).
       
           when 7 then
              RUN openQueryStatic (input "ByFiltroDescricao":U).
                
           when 2 then
              RUN openQueryStatic (input "FiltroItCodIni":U).
           
           when 3 then
              RUN openQueryStatic (input "Descricao":U).
              
           when 4 then
              RUN openQueryStatic (input "Filtro":U).
 
           when 5 then
              RUN openQueryStatic (input "ItCodigoIni":U).             
          
           when 8 then
              RUN openQueryStatic (input "FiltroFmCodigo":U).
              
           when 9 then
             RUN openQueryStatic (input "ItCodigoInicial":U).                        
       end case.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCodigoRefer DBOProgram 
PROCEDURE openQueryByCodigoRefer :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela item dentro de uma faixa
             de Ötens Inicial e Final.
------------------------------------------------------------------------------*/
        open query {&QUERYNAME} for each {&TABLENAME} where 
                                         {&TABLENAME}.codigo-refer >= c-it-codigo-ini AND
                                         {&TABLENAME}.codigo-refer <= c-it-codigo-fim
                                         NO-LOCK by {&TABLENAME}.codigo-refer indexed-reposition.
        RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDescItem DBOProgram 
PROCEDURE openQueryByDescItem :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela item dentro de uma faixa
             de Ötens Inicial e Final.
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where 
                                     {&TABLENAME}.desc-item >= c-it-codigo-ini AND
                                     {&TABLENAME}.desc-item <= c-it-codigo-fim
                                     NO-LOCK by {&TABLENAME}.desc-item indexed-reposition.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFiltroDescricao DBOProgram 
PROCEDURE openQueryByFiltroDescricao :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela item dentro de uma faixa
             de código do item e descrição-1. Ordena por descrição-1.
  ------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where 
                                   {&tablename}.it-codigo   >= c-it-codigo-ini AND
                                           {&tablename}.it-codigo   <= c-it-codigo-fim AND
                                           {&TABLENAME}.descricao-1 >= c-desc-item-ini AND
                                           {&TABLENAME}.descricao-1 <= c-desc-item-fim 
                                           NO-LOCK by {&TABLENAME}.descricao-1 INDEXED-REPOSITION.
  
                                             
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFiltroItCodigo DBOProgram 
PROCEDURE openQueryByFiltroItCodigo :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela item dentro de uma faixa
             de código do item e descrição-1. Ordena por código do item.
  ------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where 
                                   {&tablename}.it-codigo   >= c-it-codigo-ini AND
                                           {&tablename}.it-codigo   <= c-it-codigo-fim AND
                                           {&TABLENAME}.descricao-1 >= c-desc-item-ini AND
                                           {&TABLENAME}.descricao-1 <= c-desc-item-fim 
                                           no-lock by {&tablename}.it-codigo INDEXED-REPOSITION.   
                                                
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFmCodComl DBOProgram 
PROCEDURE openQueryByFmCodComl :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela item dentro de uma faixa
             de Ötens Inicial e Final.
------------------------------------------------------------------------------*/
        open query {&QUERYNAME} for each {&TABLENAME} where 
                                         {&TABLENAME}.fm-cod-com >= c-it-codigo-ini AND
                                         {&TABLENAME}.fm-cod-com <= c-it-codigo-fim
                                         NO-LOCK by {&TABLENAME}.fm-cod-com indexed-reposition.
        RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFmCodigo DBOProgram 
PROCEDURE openQueryByFmCodigo :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela item dentro de uma faixa
             de Ötens Inicial e Final.
------------------------------------------------------------------------------*/
        open query {&QUERYNAME} for each {&TABLENAME} where 
                                         {&TABLENAME}.fm-codigo >= c-it-codigo-ini AND
                                         {&TABLENAME}.fm-codigo <= c-it-codigo-fim
                                         NO-LOCK by {&TABLENAME}.fm-codigo indexed-reposition.
        RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByGeCodigo DBOProgram 
PROCEDURE openQueryByGeCodigo :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela item dentro de uma faixa
             de grupo estoque Inicial e Final.
------------------------------------------------------------------------------*/
        open query {&QUERYNAME} for each {&TABLENAME} where 
                                         {&TABLENAME}.ge-codigo >= int(c-it-codigo-ini) AND
                                         {&TABLENAME}.ge-codigo <= int(c-it-codigo-fim)
                                         NO-LOCK by {&TABLENAME}.ge-codigo indexed-reposition.
        RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItCodigo DBOProgram 
PROCEDURE openQueryByItCodigo :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela item dentro de uma faixa
             de Ötens Inicial e Final.
------------------------------------------------------------------------------*/
        open query {&QUERYNAME} for each {&TABLENAME} where 
                                         {&tablename}.it-codigo >= c-it-codigo-ini AND
                                         {&tablename}.it-codigo <= c-it-codigo-fim
                                         NO-LOCK by {&tablename}.it-codigo  indexed-reposition.
        RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryComponentes DBOProgram 
PROCEDURE openQueryComponentes :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH item 
                                     where item.politica <> 5
                                          &if '{&ems_dbtype}' = 'Progress' &then
                                             no-lock indexed-reposition.
                                          &else 
                                              no-lock.
                                          &endif

    RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
     OPEN QUERY {&QueryName} FOR EACH item &if '{&ems_dbtype}' = 'Progress' &then
                                             no-lock indexed-reposition.
                                          &else 
                                              NO-LOCK indexed-reposition.  /* Foi inclu¡do o indexed-reposition     */
                                          &endif                           /* para Oracle resolvendo problema de    */
                                                                           /* performance DAKO                      */


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryContrRefer DBOProgram
PROCEDURE openQueryContrRefer :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH item NO-LOCK where
                                 item.tipo-con-est = 4 INDEXED-REPOSITION.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDemanda DBOProgram 
PROCEDURE openQueryDemanda :
/*------------------------------------------------------------------------------
  Purpose:     Abre a query de Item para todos os itens com demanda dependente
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TABLENAME} WHERE {&TABLENAME}.demanda = 1 NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerydescItem DBOProgram 
PROCEDURE openQuerydescItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 open query {&QUERYNAME} for each {&TABLENAME} where 
                                         {&TABLENAME}.desc-item >= c-it-descricao-ini AND
                                         {&TABLENAME}.desc-item <= c-it-descricao-fim
                                         NO-LOCK by {&TABLENAME}.desc-item 
                                                 BY {&TABLENAME}.it-codigo.
        RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDescricao DBOProgram 
PROCEDURE openQueryDescricao :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela item dentro de uma 
              faixa de descrição-1.  
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where
                                     {&TABLENAME}.descricao-1 >= c-descricao-1
                                      no-lock INDEXED-REPOSITION.
                                      
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltro DBOProgram 
PROCEDURE openQueryFiltro :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela item dentro de uma faixa
           de código do item, família, e grupo de estoque.
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where 
                                  {&tablename}.it-codigo >= c-it-codigo-ini AND
                                          {&tablename}.it-codigo   <= c-it-codigo-fim AND
                                          {&TABLENAME}.fm-codigo   >= c-fam-mat-ini   AND
                                          {&TABLENAME}.fm-codigo   <= c-fam-mat-fim   AND
                                          {&TABLENAME}.ge-codigo   >= i-gr-estoq-ini  AND 
                                          {&TABLENAME}.ge-codigo   <= i-gr-estoq-fim
                                           no-lock INDEXED-REPOSITION.

                                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*Criado a procedure openQueryFiltro-ce0424 para que a busca possa ser realizada por estabelecimento, no programa ce0424*/
&analyze-suspend _UIB-CODE-BLOCK _PROCEDURE openQueryFiltro-ce0424 DBOProgram
procedure openQueryFiltro-ce0424:
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela item dentro de uma faixa
           de código do item, família, e grupo de estoque e Estabelecimento.
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where 
                                     {&tablename}.it-codigo   >= c-it-codigo-ini AND
                                     {&tablename}.it-codigo   <= c-it-codigo-fim AND
                                     {&TABLENAME}.fm-codigo   >= c-fam-mat-ini   AND
                                     {&TABLENAME}.fm-codigo   <= c-fam-mat-fim   AND
                                     {&TABLENAME}.ge-codigo   >= i-gr-estoq-ini  AND 
                                     {&TABLENAME}.ge-codigo   <= i-gr-estoq-fim  and
                                     {&TABLENAME}.cod-estabel >= c-estab-ini     and
                                     {&TABLENAME}.cod-estabel <= c-estab-fin
                                     no-lock INDEXED-REPOSITION.

                                  
    RETURN "OK":U.

end procedure.

/*_UIB-CODE-BLOCK-END*/
&analyze-resume

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroComprado DBOProgram 
PROCEDURE openQueryFiltroComprado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} FOR EACH {&TABLENAME}
                               WHERE {&TABLENAME}.cod-comprado >= c-comprado-ini
                                 AND {&TABLENAME}.cod-comprado <= c-comprado-fim
                                 AND {&TABLENAME}.demanda       = 1 NO-LOCK
                                  BY {&TABLENAME}.cod-comprado INDEXED-REPOSITION.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroDescItConfig DBOProgram 
PROCEDURE openQueryFiltroDescItConfig :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&QUERYNAME} FOR EACH {&TABLENAME}
                               WHERE {&TABLENAME}.desc-item >= c-desc-item-ini
                                 AND {&TABLENAME}.desc-item <= c-desc-item-fim
                                 AND {&TABLENAME}.politica   = 5 NO-LOCK BY desc-item INDEXED-REPOSITION.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroDescItNotConfig DBOProgram 
PROCEDURE openQueryFiltroDescItNotConfig :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&QUERYNAME} FOR EACH {&TABLENAME}
                               WHERE {&TABLENAME}.desc-item >= c-desc-item-ini
                                 AND {&TABLENAME}.desc-item <= c-desc-item-fim
                                 AND {&TABLENAME}.politica   <> 5 NO-LOCK BY {&TABLENAME}.desc-item.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroDescricao DBOProgram 
PROCEDURE openQueryFiltroDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if c-palavra = "" then do:
       OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME}
            WHERE {&TABLENAME}.desc-item >= c-desc-item-ini and
                  {&TABLENAME}.desc-item <= c-desc-item-fim and
                  {&TABLENAME}.demanda = 1 NO-LOCK
            BY {&TABLENAME}.desc-item INDEXED-REPOSITION.
    end.
    else do:
       &if "{&mgind_dbtype}" = "PROGRESS" &then
           OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME}
               WHERE {&TABLENAME}.desc-item >= c-desc-item-ini and
                     {&TABLENAME}.desc-item <= c-desc-item-fim and
                     {&TABLENAME}.demanda = 1 and
                     {&TABLENAME}.desc-item MATCHES ("*" + c-palavra + "*") NO-LOCK
               BY {&TABLENAME}.desc-item INDEXED-REPOSITION.
      &else
          OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME}
               WHERE {&TABLENAME}.desc-item >= c-desc-item-ini and
                     {&TABLENAME}.desc-item <= c-desc-item-fim and
                     {&TABLENAME}.demanda = 1 and
                     {&TABLENAME}.desc-item matches (c-palavra) NO-LOCK
               BY {&TABLENAME}.desc-item INDEXED-REPOSITION.
      &endif.
   end.
             
   RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroFmCodigo DBOProgram 
PROCEDURE openQueryFiltroFmCodigo :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela item dentro de uma faixa
             de família inicial e final.  
------------------------------------------------------------------------------*/

    open query {&QUERYNAME} for each {&TABLENAME} where 
                                         {&TABLENAME}.fm-codigo >= c-fam-mat-ini AND
                                        {&TABLENAME}.fm-codigo <= c-fam-mat-fim 
                                        NO-LOCK by {&tablename}.it-codigo INDEXED-REPOSITION.

                                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroFmDemanda DBOProgram 
PROCEDURE openQueryFiltroFmDemanda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} FOR EACH {&TABLENAME}
                               WHERE {&TABLENAME}.fm-codigo >= c-fam-mat-ini
                                 AND {&TABLENAME}.fm-codigo <= c-fam-mat-fim
                                 AND {&TABLENAME}.demanda    = 1 NO-LOCK
                                  BY {&TABLENAME}.fm-codigo INDEXED-REPOSITION.
                                  
    RETURN "OK":U.                                     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroItCodConfig DBOProgram 
PROCEDURE openQueryFiltroItCodConfig :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&QUERYNAME} FOR EACH {&TABLENAME}
                               WHERE {&tablename}.it-codigo >= c-it-codigo-ini
                                 AND {&tablename}.it-codigo <= c-it-codigo-fim
                                 AND {&TABLENAME}.politica   = 5 NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroItCodigo DBOProgram 
PROCEDURE openQueryFiltroItCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} FOR EACH {&TABLENAME}
                               WHERE {&tablename}.it-codigo >= c-it-codigo-ini
                                 AND {&tablename}.it-codigo <= c-it-codigo-fim
                                 AND {&TABLENAME}.demanda    = 1 NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroItCodIni DBOProgram 
PROCEDURE openQueryFiltroItCodIni :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela item, dentro de uma
              faixa de código do item inicial. 
  ------------------------------------------------------------------------------*/

    open query {&QUERYNAME} for each {&TABLENAME} where
                                     {&tablename}.it-codigo >= c-it-codigo-ini
                                      no-lock INDEXED-REPOSITION.            
                                       
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroItCodNotConfig DBOProgram 
PROCEDURE openQueryFiltroItCodNotConfig :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&QUERYNAME} FOR EACH {&TABLENAME}
                               WHERE {&tablename}.it-codigo >= c-it-codigo-ini
                                 AND {&tablename}.it-codigo <= c-it-codigo-fim
                                 AND {&TABLENAME}.politica   <> 5 NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroItemDesc DBOProgram 
PROCEDURE openQueryFiltroItemDesc :
/*------------------------------------------------------------------------------
  Purpose:     Busca conjunto de registros da tabela item dentro de uma faixa
               de codigo do item e descricao.Ordena de acordo com a op‡Æo selecionada.
     
------------------------------------------------------------------------------*/
if i-ordena = 1 then do :  
    open query {&QUERYNAME} for each {&TABLENAME} NO-LOCK where 
                                     {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                     {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                     {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                     {&TABLENAME}.desc-item    <= c-desc-item-fim    
                                     USE-INDEX codigo
                                     INDEXED-REPOSITION.
                                         
  end.
  if i-ordena = 2 then do :  
    open query {&QUERYNAME} for each {&TABLENAME} NO-LOCK where 
                                     {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                     {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                     {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                     {&TABLENAME}.desc-item    <= c-desc-item-fim    
                                     USE-INDEX descricao
                                     INDEXED-REPOSITION.
                                         
  end.
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroPlanejador DBOProgram 
PROCEDURE openQueryFiltroPlanejador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} FOR EACH {&TABLENAME}
                               WHERE {&TABLENAME}.cd-planejado >= c-planejador-ini
                                 AND {&TABLENAME}.cd-planejado <= c-planejador-fim
                                 AND {&TABLENAME}.demanda       = 1 NO-LOCK
                                  BY {&TABLENAME}.cd-planejado INDEXED-REPOSITION.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroZoom DBOProgram 
PROCEDURE openQueryFiltroZoom :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela item dentro de uma faixa
             de codigo do item, descricao,familia,familia complementar,grupo
             estoque,codigo complementar e situacao. Ordena de acordo com a op‡Æo selecionada.
    
------------------------------------------------------------------------------*/
  if i-ordena = 1 then do :  
    open query {&QUERYNAME} for each {&TABLENAME} where 
                                     {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                     {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                     {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                     {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                     {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                     {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                     {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                     {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                     {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                     {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                     {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                     {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND 
                                     {&TABLENAME}.cod-obsoleto >= i-cod-obsoleto-ini AND
                                     {&TABLENAME}.cod-obsoleto <= i-cod-obsoleto-fim 
                                      no-lock by {&tablename}.it-codigo INDEXED-REPOSITION.
                                         
  end.
  if i-ordena = 2 then do :  
    open query {&QUERYNAME} for each {&TABLENAME} where 
                                     {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                     {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                     {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                     {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                     {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                     {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                     {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                     {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                     {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                     {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                     {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                     {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND 
                                     {&TABLENAME}.cod-obsoleto >= i-cod-obsoleto-ini AND
                                     {&TABLENAME}.cod-obsoleto <= i-cod-obsoleto-fim  
                                      no-lock by {&TABLENAME}.desc-item INDEXED-REPOSITION.
                                         
  end.
  if i-ordena = 3 then do :  
    open query {&QUERYNAME} for each {&TABLENAME} where 
                                     {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                     {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                     {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                     {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                     {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                     {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                     {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                     {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                     {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                     {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                     {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                     {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND 
                                     {&TABLENAME}.cod-obsoleto >= i-cod-obsoleto-ini AND
                                     {&TABLENAME}.cod-obsoleto <= i-cod-obsoleto-fim 
                                      no-lock by {&TABLENAME}.fm-codigo INDEXED-REPOSITION.
                                         
  end.
  if i-ordena = 4 then do :  
    open query {&QUERYNAME} for each {&TABLENAME} where 
                                     {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                     {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                     {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                     {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                     {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                     {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                     {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                     {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                     {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                     {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                     {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                     {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND 
                                     {&TABLENAME}.cod-obsoleto >= i-cod-obsoleto-ini AND
                                     {&TABLENAME}.cod-obsoleto <= i-cod-obsoleto-fim  
                                      no-lock by {&TABLENAME}.fm-cod-com INDEXED-REPOSITION.
                                         
  end.
if i-ordena = 5 then do :  
    open query {&QUERYNAME} for each {&TABLENAME} where 
                                     {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                     {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                     {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                     {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                     {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                     {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                     {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                     {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                     {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                     {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                     {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                     {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND 
                                     {&TABLENAME}.cod-obsoleto >= i-cod-obsoleto-ini AND
                                     {&TABLENAME}.cod-obsoleto <= i-cod-obsoleto-fim  
                                      no-lock by {&TABLENAME}.ge-codigo INDEXED-REPOSITION.
                                         
  end.
  if i-ordena = 6 then do :  
    open query {&QUERYNAME} for each {&TABLENAME} where 
                                     {&tablename}.it-codigo    >= c-it-codigo-ini    AND
                                     {&tablename}.it-codigo    <= c-it-codigo-fim    AND
                                     {&TABLENAME}.desc-item    >= c-desc-item-ini    AND
                                     {&TABLENAME}.desc-item    <= c-desc-item-fim    AND
                                     {&TABLENAME}.fm-codigo    >= c-fm-codigo-ini    AND
                                     {&TABLENAME}.fm-codigo    <= c-fm-codigo-fim    AND
                                     {&TABLENAME}.fm-cod-com   >= c-fm-cod-com-ini   AND
                                     {&TABLENAME}.fm-cod-com   <= c-fm-cod-com-fim   AND
                                     {&TABLENAME}.ge-codigo    >= i-ge-codigo-ini    AND
                                     {&TABLENAME}.ge-codigo    <= i-ge-codigo-fim    AND
                                     {&TABLENAME}.codigo-refer >= c-cod-refer-ini    AND
                                     {&TABLENAME}.codigo-refer <= c-cod-refer-fim    AND 
                                     {&TABLENAME}.cod-obsoleto >= i-cod-obsoleto-ini AND
                                     {&TABLENAME}.cod-obsoleto <= i-cod-obsoleto-fim  
                                      no-lock by {&TABLENAME}.codigo-refer INDEXED-REPOSITION.
                                         
  end.
                                        
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItCodigoContrRef DBOProgram 
PROCEDURE openQueryItCodigoContrRef :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH item NO-LOCK where 
                                 ITEM.it-codigo >= c-it-codigo-ini AND
                                 ITEM.it-codigo <= c-it-codigo-fim AND
                                 item.tipo-con-est = 4 INDEXED-REPOSITION.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItCodigoIni DBOProgram 
PROCEDURE openQueryItCodigoIni :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela item conforme o código do item .   
  
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where 
                                     {&tablename}.it-codigo = c-it-codigo-ini
                                      no-lock INDEXED-REPOSITION.

                                           
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItCodigoInicial DBOProgram 
PROCEDURE openQueryItCodigoInicial :
/*------------------------------------------------------------------------------
  Purpose: Busca conjunto de registros da tabela item conforme o 
           código do item inicial .   
 ------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} use-index codigo
                               where {&tablename}.it-codigo = trim(c-it-codigo-ini) 
                                     no-lock INDEXED-REPOSITION.

                                           
    RETURN "OK":U.         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItConfigurado DBOProgram 
PROCEDURE openQueryItConfigurado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&QUERYNAME} for each {&TABLENAME} where
                                     {&TABLENAME}.politica = 5
                                     no-lock INDEXED-REPOSITION.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItDescContrRef DBOProgram 
PROCEDURE openQueryItDescContrRef :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH item NO-LOCK where 
                                 ITEM.desc-item >= c-desc-item-ini AND
                                 ITEM.desc-item <= c-desc-item-fim AND
                                 item.tipo-con-est = 4 INDEXED-REPOSITION.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryWMS DBOProgram 
PROCEDURE openQueryWMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH item NO-LOCK where 
    item.it-codigo    >= c-it-codigo-ini and
    item.it-codigo    <= c-it-codigo-fim and
    item.ge-codigo    >= i-gr-estoq-ini and
    item.ge-codigo    <= i-gr-estoq-fim and 
    item.tipo-con-est >= i-tp-contr-ini and
    item.tipo-con-est <= i-tp-contr-fim and
    item.cod-obsoleto  = 1 INDEXED-REPOSITION.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-Valida-Alteracao-Item DBOProgram 
PROCEDURE Pi-Valida-Alteracao-Item :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters: tt-pi-valida       - Tabela com os campos a serem validados.
              cod-erro-pi-valida - Retorna o c¢digo do erro caso ocorra.                  
  Notes:  
------------------------------------------------------------------------------*/
 
DEF INPUT PARAM TABLE FOR tt-pi-valida.
DEF OUTPUT PARAM cod-erro-pi-valida AS CHAR FORMAT "x(500)" NO-UNDO.

if not valid-handle(h-boin172j) then
    run inbo/boin172j.p persistent set h-boin172j.

run pi-alteracao in h-boin172j(input table tt-pi-valida,
                               output cod-erro-pi-valida).

if valid-handle(h-boin172j) then
    delete procedure h-boin172j.

return "ok":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-Valida-Exclusao-Item DBOProgram 
PROCEDURE Pi-Valida-Exclusao-Item :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters: tt-pi-valida       - Tabela com os campos a serem validados.
              cod-erro-pi-valida - Retorna o c¢digo do erro caso ocorra.                  
  Notes:  
------------------------------------------------------------------------------*/

DEF INPUT  PARAM TABLE FOR tt-pi-valida.
DEF OUTPUT PARAM cod-erro-pi-valida AS CHAR FORMAT "x(500)" NO-UNDO.

if not valid-handle(h-boin172j) then
    run inbo/boin172j.p persistent set h-boin172j.

run pi-exclusao in h-boin172j(input table tt-pi-valida,
                              output cod-erro-pi-valida).

if valid-handle(h-boin172j) then
    delete procedure h-boin172j.

return 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-Valida-Inclusao-Item DBOProgram 
PROCEDURE Pi-Valida-Inclusao-Item :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters: tt-pi-valida       - Tabela com os campos a serem validados.
              cod-erro-pi-valida - Retorna o c¢digo do erro caso ocorra.                  
  Notes:  
------------------------------------------------------------------------------*/

DEF INPUT PARAM TABLE FOR tt-pi-valida.
DEF OUTPUT PARAM cod-erro-pi-valida AS CHAR FORMAT "x(500)" NO-UNDO.

if not valid-handle(h-boin172j) then
    run inbo/boin172j.p persistent set h-boin172j.

run pi-inclusao in h-boin172j(input table tt-pi-valida,
                              output cod-erro-pi-valida).

if valid-handle(h-boin172j) then
    delete procedure h-boin172j.

return "ok":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDefaultReq DBOProgram 
PROCEDURE retornaDefaultReq :
/*------------------------------------------------------------------------------
  Purpose:   Implementação para o wpd0508  
  Parameters: 
      
------------------------------------------------------------------------------*/
    def input  parameter p-it-codigo like item.it-codigo.
    def input  parameter r-requisicao     as rowid   no-undo.
    def output parameter de-qt-a-atender  as decimal no-undo.
    def output parameter c-narrativa      as char    no-undo.
    def output parameter c-cod-utiliz     as char    no-undo.
    def output parameter c-ct-codigo      as char    no-undo.
    def output parameter c-cod-refer      as char    no-undo.

    def var l-classif  as logical no-undo.
    def var i-nat-desp as integer no-undo.
    assign i-nat-desp = ?.

    find requisicao where
        rowid(requisicao) = r-requisicao
        no-lock no-error.

    find usuar-mater where
        usuar-mater.cod-usuario = requisicao.nome-abrev
        no-lock no-error.

    find {&TABLENAME} where
        {&tablename}.it-codigo = p-it-codigo
        no-lock no-error.

    if available {&TABLENAME} then do:
        if {&TABLENAME}.tipo-con-est = 2 then
            assign de-qt-a-atender = 1.

        find narrativa of {&TABLENAME} no-lock no-error.
        if available narrativa then
            assign c-narrativa = narrativa.descricao.

        for first param-item-estab fields (it-codigo cod-estabel nat-despesa altera-conta)
            where param-item-estab.it-codigo   = {&tablename}.it-codigo
            and   param-item-estab.cod-estabel = requisicao.cod-estabel
            no-lock:
        end.
        if avail param-item-estab then
            assign i-nat-desp = param-item-estab.nat-despesa
                   l-classif  = param-item-estab.altera-conta.
        else do:
            for first param-familia-estab fields (fm-codigo cod-estabel nat-despesa altera-conta)
                where param-familia-estab.fm-codigo   = {&TABLENAME}.fm-codigo
                and   param-familia-estab.cod-estabel = requisicao.cod-estabel
                no-lock:
            end.
            if avail param-familia-estab then
                assign i-nat-desp = param-familia-estab.nat-despesa
                       l-classif  = param-familia-estab.altera-conta.
            else
                assign i-nat-desp = {&TABLENAME}.nat-despesa
                       l-classif  = no.
        end.

        if not l-classif then do:
            for first natureza-despesa fields (nat-despesa ct-codigo) where
                natureza-despesa.nat-despesa = i-nat-desp
                no-lock:
            end.
            if avail natureza-despesa then do:
                if substring(usuar-mater.char-1,1,1) = "y" then do:  /**** Utiliza‡Æo de Material ******/
                    for first utiliz-natu-despes fields (cod-nat-despesa ct-codigo cod-utiliz) where
                        utiliz-natu-despes.cod-nat-despesa = natureza-despesa.nat-despesa
                        no-lock:
                    end.
                    if avail utiliz-natu-despes then do:
                        for first utilizacao-mater fields (cod-utiliz des-utiliz) where
                            utilizacao-mater.cod-utiliz = utiliz-natu-despes.cod-utiliz
                            no-lock:
                        end.
                        assign c-cod-utiliz = utiliz-natu-despes.cod-utiliz
                               c-ct-codigo  = utiliz-natu-despes.ct-codigo.
                    end.
                end.
                else
                    assign c-ct-codigo = natureza-despesa.ct-codigo.
            end.
        end.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendMessageEAI DBOProgram 
PROCEDURE sendMessageEAI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 def input  parameter p-action         AS CHAR NO-UNDO.
 def input  parameter p-program        AS CHAR NO-UNDO.
 def input  parameter p-version        AS CHAR NO-UNDO.

 IF NOT CAN-FIND(FIRST funcao
                 WHERE funcao.cd-funcao = "spp-integra-ems-his":U
                 AND   funcao.ativo     = YES) THEN DO:
 
    /* Execucao caso usuario possua integracao EAI */
    IF v_log_eai_habilit THEN DO:
    
       CREATE tt-EAI.
       BUFFER-COPY RowObject TO tt-EAI.
       RUN adapters/xml/ma2/axsma003.p (INPUT p-action,
                                        INPUT p-program,
                                        INPUT p-version,
                                        INPUT TABLE tt-EAI,
                                        OUTPUT TABLE RowErrors).  
       DELETE tt-EAI NO-ERROR.
    
           IF CAN-FIND (FIRST RowErrors WHERE 
                              RowErrors.ErrorSubType = "ERROR":U) THEN
              RETURN "NOK":U.
    END.

 END.
 RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendMessageMultiPlanta DBOProgram 
PROCEDURE sendMessageMultiPlanta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM i-tipo-movto AS INTEGER NO-UNDO.
DEF INPUT PARAM c-transacao  AS CHAR    NO-UNDO.

run inbo/boin172k.p(input table RowObject,
                    input table tt-replica-msg,
                    input item.it-codigo,
                    input i-tipo-movto,
                    input c-transacao).

return "ok":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetaInicializaDesmontagem DBOProgram 
PROCEDURE SetaInicializaDesmontagem :
/*------------------------------------------------------------------------------
  Purpose: Seta o parƒmetro ] para que a l¢gica de desmontagem do cp0318 
           seja executada apenas quando ele for o programa chamador, por default 
           a vari vel lDesmonta ‚ YES, ela receber  como parƒmetro "NO" do
           CP0318.
  Parameters: - pDesmonta - receber  NO do programa cp0318.
  Notes:  
------------------------------------------------------------------------------*/

def input parameter pDesmonta as log no-undo.
assign lDesmonta = pDesmonta.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:   Seta as variáveis de controle para queries contendo o código do item.  
  Parameters:ipar:p-it-codigo: Item
     
------------------------------------------------------------------------------*/
    /* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter p-it-codigo as char.
    
    run setConstraintItCodigo(p-it-codigo).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint3 DBOProgram 
PROCEDURE setConstraint3 :
/*------------------------------------------------------------------------------
  Purpose:   Seta as variáveis de controle para queries contendo a descrição-1.  
  Parameters:ipar:p-descricao-1:Descrição      
------------------------------------------------------------------------------*/
    /* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter p-descricao-1 as char.  
    
    run setConstraintDescricao (p-descricao-1).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint4 DBOProgram 
PROCEDURE setConstraint4 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variáveis de controle para queries contendo o percentual 
              acréscimo, data base, item inicial e final, família inicial e 
              final, grupo estoque inicial e final.
  Parameters: ipar1: p-perc-acres:Percentual Acréscimo    
              ipar2: p-data-base:Data Base     
              ipar3: p-it-codigo-ini:Item Inicial 
              ipar4:p-it-codigo-fim:Item Final 
              ipar5: p-fam-mat-ini:Família Inicial  
              ipar6: p-fam-mat-fim:Família Final 
              ipar7: p-gr-estoq-ini:Grupo Estoque Inicial  
              ipar8: p-gr-estoq-fim:Grupo Estoque Final  
-----------------------------------------------------------------------------*/
    /* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input param p-perc-acres    as char.
    def input param p-data-base     as char.
    def input param p-it-codigo-ini as char.
    def input param p-it-codigo-fim as char.
    def input param p-fam-mat-ini   as char.
    def input param p-fam-mat-fim   as char.
    def input param p-gr-estoq-ini  as char.
    def input param p-gr-estoq-fim  as char.
    
     run setConstraintFiltro (p-perc-acres,
                              p-data-base,
                              p-it-codigo-ini,
                              p-it-codigo-fim,
                              p-fam-mat-ini,
                              p-fam-mat-fim,
                              p-gr-estoq-ini,
                              p-gr-estoq-fim).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint5 DBOProgram 
PROCEDURE setConstraint5 :
/*------------------------------------------------------------------------------
  Purpose:   Seta as variáveis de controle para queries contendo o código 
             do item inicial.  
  Parameters:ipar:p-it-codigo-ini:Item Inicial
  
------------------------------------------------------------------------------*/
    /* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input param p-it-codigo-ini as char.
    
    run setConstraintItCodigoIni (p-it-codigo-ini).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint6 DBOProgram 
PROCEDURE setConstraint6 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variáveis de controle para queries contendo o item
              inicial e final e a descrição inicial e final.
  Parameters: ipar1:p-it-codigo-ini:Item Inicial
              ipar2:p-it-codigo-fim:Item Final
              ipar3:p-desc-item-ini:Descrição Inicial
              ipar4:p-desc-item-fim:Descrição Final
 ------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
        
    def input param p-it-codigo-ini as char.
    def input param p-it-codigo-fim as char.
    def input param p-desc-item-ini as char.
    def input param p-desc-item-fim as char.
    
    run setConstraintFiltroItCodDesc (p-it-codigo-ini,
                                      p-it-codigo-fim,
                                      p-desc-item-ini,
                                      p-desc-item-fim).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint7 DBOProgram 
PROCEDURE setConstraint7 :
/*------------------------------------------------------------------------------
  Purpose:   Seta as variáveis de controle para queries contendo a família
             inicial e final.  
  Parameters: ipar1:p-familia-ini:Família Inicial
              ipar2:p-familia-fim:Família Final 
 -----------------------------------------------------------------------------*/
    /* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input param p-familia-ini as char no-undo.
    def input param p-familia-fim as char no-undo.
    
    run setConstraintFiltroFmCodigo (p-familia-ini,
                                     p-familia-fim).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDescItem DBOProgram 
PROCEDURE setConstraintDescItem :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo o item
              inicial e final.
  Parameters: ipar1:pit-descricao-ini:Item Inicial
              ipar2:pit-descricao-fim:Item Final
------------------------------------------------------------------------------*/
  def input param pit-descricao-ini as char.
  def input param pit-descricao-fim as char.

  assign c-it-descricao-ini = pit-descricao-ini
         c-it-descricao-fim = pit-descricao-fim.  
       
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDescricao DBOProgram 
PROCEDURE setConstraintDescricao :
/*------------------------------------------------------------------------------
  Purpose:   Seta as variáveis de controle para queries contendo a descrição-1.  
  Parameters:ipar:pdescricao-1:Descrição      
    
------------------------------------------------------------------------------*/

    def input parameter pdescricao-1 as char.

    assign c-descricao-1 = pdescricao-1.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltro DBOProgram 
PROCEDURE setConstraintFiltro :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variáveis de controle para queries contendo o percentual 
              acréscimo, data base, item inicial e final, família inicial e 
              final, grupo estoque inicial e final.
  Parameters: ipar1: pperc-acres:Percentual Acréscimo    
              ipar2: pdata-base:Data Base     
              ipar3: pit-codigo-ini:Item Inicial 
              ipar4: pit-codigo-fim:Item Final 
              ipar5: pfam-mat-ini:Família Inicial  
              ipar6: pfam-mat-fim:Família Final 
              ipar7: pgr-estoq-ini:Grupo Estoque Inicial  
              ipar8: pgr-estoq-fim:Grupo Estoque Final  
------------------------------------------------------------------------------*/
    def input param pperc-acres    as char.
    def input param pdata-base     as char.
    def input param pit-codigo-ini as char.
    def input param pit-codigo-fim as char.
    def input param pfam-mat-ini   as char.  
    def input param pfam-mat-fim   as char.
    def input param pgr-estoq-ini  as char.
    def input param pgr-estoq-fim  as char.

    ASSIGN  c-perc-acres     = pperc-acres   
            c-data-base      = pdata-base    
            c-it-codigo-ini  = pit-codigo-ini
            c-it-codigo-fim  = pit-codigo-fim
            c-fam-mat-ini    = pfam-mat-ini  
            c-fam-mat-fim    = pfam-mat-fim  
            i-gr-estoq-ini   = int(pgr-estoq-ini) 
            i-gr-estoq-fim   = int(pgr-estoq-fim).

    RETURN "OK":U.                    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/*CRIADO A PROCEDURE setConstraintFiltro-ce0424 PAPRA QUE NÃO ACHA ERRO DE PASSAGEM EM OUTROS PROGRAMAS*/
&analyze-suspend _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltro-ce0424 DBOProgram
procedure setConstraintFiltro-ce0424:

    def input param pceperc-acres    as char.
    def input param pcedata-base     as char.
    def input param pceit-codigo-ini as char.
    def input param pceit-codigo-fim as char.
    def input param pcefam-mat-ini   as char.  
    def input param pcefam-mat-fim   as char.
    def input param pcegr-estoq-ini  as char.
    def input param pcegr-estoq-fim  as char.
    def input param pceestab-ini     as char.
    def input param pceestab-fin     as char. 

    ASSIGN  c-perc-acres     = pceperc-acres   
            c-data-base      = pcedata-base    
            c-it-codigo-ini  = pceit-codigo-ini
            c-it-codigo-fim  = pceit-codigo-fim
            c-fam-mat-ini    = pcefam-mat-ini  
            c-fam-mat-fim    = pcefam-mat-fim  
            i-gr-estoq-ini   = int(pcegr-estoq-ini) 
            i-gr-estoq-fim   = int(pcegr-estoq-fim)
            c-estab-ini      = pceestab-ini
            c-estab-fin      = pceestab-fin. 
            
    RETURN "OK":U.  
end procedure.

/* _UIB-CODE-BLOCK-END */
&analyze-resume



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroComprado DBOProgram 
PROCEDURE setConstraintFiltroComprado :
/*------------------------------------------------------------------------------
  Purpose:   Seta as variáveis de controle para queries contendo o Comprador
             inicial e final.  
  Parameters: ipar1:pcomprador-ini:Comprador Inicial
              ipar2:pcomprador-fim:Comprador Final 
------------------------------------------------------------------------------*/
    def input param pcomprador-ini as char no-undo.
    def input param pcomprador-fim as char no-undo.
    
    assign c-comprado-ini = pcomprador-ini
           c-comprado-fim = pcomprador-fim.
           
    RETURN "OK":U.     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroFmCodigo DBOProgram 
PROCEDURE setConstraintFiltroFmCodigo :
/*------------------------------------------------------------------------------
  Purpose:   Seta as variáveis de controle para queries contendo a família
             inicial e final.  
  Parameters: ipar1:pfamilia-ini:Família Inicial
              ipar2:pfamilia-fim:Família Final 
------------------------------------------------------------------------------*/
    def input param pfamilia-ini as char no-undo.
    def input param pfamilia-fim as char no-undo.
    
    assign c-fam-mat-ini = pfamilia-ini
           c-fam-mat-fim = pfamilia-fim.
           
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroItCodDesc DBOProgram 
PROCEDURE setConstraintFiltroItCodDesc :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variáveis de controle para queries contendo o item
              inicial e final e a descrição inicial e final.
  Parameters: ipar1:pit-codigo-ini:Item Inicial
              ipar2:pit-codigo-fim:Item Final
              ipar3:pdesc-item-ini:Descrição Inicial
              ipar4:pdesc-item-fim:Descrição Final
------------------------------------------------------------------------------*/
  def input param pit-codigo-ini as char.
  def input param pit-codigo-fim as char.
  def input param pdesc-item-ini as char.
  def input param pdesc-item-fim as char.
  
  assign c-it-codigo-ini = pit-codigo-ini
         c-it-codigo-fim = pit-codigo-fim
         c-desc-item-ini = pdesc-item-ini
         c-desc-item-fim = pdesc-item-fim.
         
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroItCodigo DBOProgram 
PROCEDURE setConstraintFiltroItCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo o item
              inicial e final.
  Parameters: ipar1:pit-codigo-ini:Item Inicial
              ipar2:pit-codigo-fim:Item Final
------------------------------------------------------------------------------*/
  def input param pit-codigo-ini as char.
  def input param pit-codigo-fim as char.

  assign c-it-codigo-ini = pit-codigo-ini
         c-it-codigo-fim = pit-codigo-fim.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroItemDesc DBOProgram 
PROCEDURE setConstraintFiltroItemDesc :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variaveis de controle para queries contendo o item
              inicial e final , descricao inicial e final,ordena.   
  Parameters: ipar1:pit-codigo-ini:Item Inicial
              ipar2:pit-codigo-fim:Item Final
              ipar3:pdesc-item-ini:Descricao Inicial
              ipar4:pdesc-item-fim:Descricao Final
              ipar5:p-ordena:Ordena‡Æo 

  Notes:       
------------------------------------------------------------------------------*/
  def input param pit-codigo-ini     as char.
  def input param pit-codigo-fim     as char.
  def input param pdesc-item-ini     as char.
  def input param pdesc-item-fim     as char.
  def input param p-ordena           as integer.
  
  assign c-it-codigo-ini    = pit-codigo-ini
         c-it-codigo-fim    = pit-codigo-fim
         c-desc-item-ini    = pdesc-item-ini
         c-desc-item-fim    = pdesc-item-fim
         i-ordena           = p-ordena.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroPlanejador DBOProgram 
PROCEDURE setConstraintFiltroPlanejador :
/*------------------------------------------------------------------------------
  Purpose:   Seta as variáveis de controle para queries contendo o Planejador
             inicial e final.  
  Parameters: ipar1:pplanejador-ini:Planejador Inicial
              ipar2:pplanejador-fim:Planejador Final 
------------------------------------------------------------------------------*/
    def input param pplanejador-ini as char no-undo.
    def input param pplanejador-fim as char no-undo.
    
    assign c-planejador-ini = pplanejador-ini
           c-planejador-fim = pplanejador-fim.
           
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroZoom DBOProgram 
PROCEDURE setConstraintFiltroZoom :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variaveis de controle para queries contendo o item
              inicial e final, descricao inicial e final,familia inicial e final,
              familia comercial inicial e final, grupo estoque inicial e final,
              codigo complementar inicial e final, situacao inicial e final,ordena.   
  Parameters: ipar1:pit-codigo-ini:Item Inicial
              ipar2:pit-codigo-fim:Item Final
              ipar3:pdesc-item-ini:Descricao Inicial
              ipar4:pdesc-item-fim:Descricao Final
              ipar5:pfm-codigo-ini:Familia Inicial
              ipar6:pfm-codigo-fim:Familia Final
              ipar7:pfm-cod-com-ini:Familia Comercial Inicial
              ipar8:pfm-cod-com-fim:Familia Comercial Final
              ipar9:pge-codigo-ini:Grupo Estoque Inicial
              ipar10:pge-codigo-fim:Grupo Estoque Final
              ipar11:pcod-refer-ini:Codigo Complementar Inicial
              ipar12:pcod-refer-fim:Codigo Complementar Final
              ipar13:pcod-obsoleto-ini:Situacao Inicial
              ipar14:pcod-obsoleto-fim:Situacao Final
              ipar15:p-ordena:Ordena‡Æo 
------------------------------------------------------------------------------*/
  def input param pit-codigo-ini     as char.
  def input param pit-codigo-fim     as char.
  def input param pdesc-item-ini     as char.
  def input param pdesc-item-fim     as char.
  def input param pfm-codigo-ini     as char.
  def input param pfm-codigo-fim     as char.
  def input param pfm-cod-com-ini    as char.
  def input param pfm-cod-com-fim    as char.
  def input param pge-codigo-ini     as integer.
  def input param pge-codigo-fim     as integer.
  def input param pcod-refer-ini     as char.
  def input param pcod-refer-fim     as char.
  def input param pcod-obsoleto-ini  as integer.
  def input param pcod-obsoleto-fim  as integer.
  def input param p-ordena           as integer.
  
  assign c-it-codigo-ini    = pit-codigo-ini
         c-it-codigo-fim    = pit-codigo-fim
         c-desc-item-ini    = pdesc-item-ini
         c-desc-item-fim    = pdesc-item-fim
         c-fm-codigo-ini    = pfm-codigo-ini
         c-fm-codigo-fim    = pfm-codigo-fim
         c-fm-cod-com-ini   = pfm-cod-com-ini
         c-fm-cod-com-fim   = pfm-cod-com-fim
         i-ge-codigo-ini    = pge-codigo-ini
         i-ge-codigo-fim    = pge-codigo-fim
         c-cod-refer-ini    = pcod-refer-ini
         c-cod-refer-fim    = pcod-refer-fim
         i-cod-obsoleto-ini = pcod-obsoleto-ini
         i-cod-obsoleto-fim = pcod-obsoleto-fim
         i-ordena           = p-ordena.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItCodigo DBOProgram 
PROCEDURE setConstraintItCodigo :
/*------------------------------------------------------------------------------
  Purpose:   Seta as variáveis de controle para queries contendo o código do item.  
  Parameters:ipar:pit-codigo: Item
------------------------------------------------------------------------------*/
    def input parameter pit-codigo as char.
 
    assign c-it-codigo-ini = pit-codigo. 
                           
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItCodigoIni DBOProgram 
PROCEDURE setConstraintItCodigoIni :
/*------------------------------------------------------------------------------
  Purpose:   Seta as variáveis de controle para queries contendo o código 
             do item inicial.  
  Parameters:ipar:pit-codigo-ini:Item Inicial
------------------------------------------------------------------------------*/
    def input param pit-codigo-ini as char.

    assign c-it-codigo-ini = pit-codigo-ini.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPalavra DBOProgram 
PROCEDURE setConstraintPalavra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param p-palavra as char.

assign c-palavra = p-palavra.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintWMS DBOProgram 
PROCEDURE setConstraintWMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pit-codigo-ini  as char no-undo.
def input param pit-codigo-fim  as char no-undo.
def input param pge-codigo-ini  as int  no-undo.
def input param pge-codigo-fim  as int  no-undo.
def input param ptp-contr-ini   as int  no-undo.
def input param ptp-contr-fim   as int  no-undo.

assign c-it-codigo-ini = pit-codigo-ini
       c-it-codigo-fim = pit-codigo-fim
       i-gr-estoq-ini  = pge-codigo-ini
       i-gr-estoq-fim  = pge-codigo-fim
       i-tp-contr-ini  = ptp-contr-ini
       i-tp-contr-fim  = ptp-contr-fim.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaDesmontagem DBOProgram 
PROCEDURE validaDesmontagem :
/*------------------------------------------------------------------------------
  Purpose:     Faz as valida‡äes para o programa de desmontagem de item.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-dt-trans                 as date no-undo.
    def input param p-it-codigo                as char no-undo.
    def input param p-cod-estabel              as char no-undo.
    def input param p-conta-contabil           as char no-undo.
    def input param i-empresa-prin             LIKE empresa.ep-codigo  no-undo.
    def input param p-ccusto                   as char  no-undo.
    def input param p-cod-depos                as char no-undo.
    def input param p-cod-localiz              as char no-undo.
    def input param p-un                       as char no-undo.
    def input param p-quantidade               as dec no-undo.
    def input param p-lote                     as char no-undo.
    def input param p-refer                    as char no-undo.
    def input param p-conta-contabil-aplicacao as char no-undo.
    def input param p-ccusto-aplicacao         as char  no-undo.
                                   
    def var i-codigo-erro   as int   no-undo.
    def var c-ano-periodo   as char  no-undo.
    def var v-dia           as int   no-undo.
    def var c-msg-aux       as char  no-undo.
    
    assign v_cod_finalid = {adinc/i05ad049.i 4 5} /* 5 - Mão-de-obra */
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 6} /* 6 - Custo mercadoria vendida */
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 9} /* 9 - Saldo por grupo de estoque */
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 10}. /* 10 - Não gera lançamentos */
    
    if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.  
    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
    
    /*************/
   
    /* Funcao definida na include cp0311.i2 */   
    assign i-codigo-erro =  f-consiste-datas(INPUT p-dt-trans,
                                             INPUT yes,
                                             INPUT p-it-codigo,
                                             INPUT p-cod-estabel,
                                             INPUT 0).
    if  i-codigo-erro > 0 then do:
        {method/svc/errors/inserr.i &ErrorNumber=i-codigo-erro
                                    &ErrorType="EMS"
                                    &ErrorParameters="''"}
    end.
 
    assign c-ano-periodo = string((year(p-dt-trans))) + substring(string(p-dt-trans),4,2)
           v-dia         = day(p-dt-trans).
    find first param-estoq no-lock no-error.
    if  param-estoq.tem-moeda1 then do:
        find moeda 
            where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
        find cotacao 
            where cotacao.mo-codigo   = param-estoq.moeda1 
              and cotacao.ano-periodo = c-ano-periodo no-lock no-error.
        if  avail cotacao 
        and cotacao.cotacao[v-dia] = 0  then do:
            assign c-msg-aux = moeda.descricao + '~~' + string(p-dt-trans).
        
            /* NÆo h  cota‡Æo para a moeda __ na data __ */
            {method/svc/errors/inserr.i &ErrorNumber="316"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-msg-aux"} 
        end.
    end.
    
    if  param-estoq.tem-moeda2 then do:
        find moeda 
            where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
        find cotacao
            where cotacao.mo-codigo   = param-estoq.moeda2 
              and cotacao.ano-periodo = c-ano-periodo no-lock no-error.
        if  avail cotacao 
        and cotacao.cotacao[v-dia] = 0 then do:
            assign c-msg-aux = moeda.descricao + "~~" + string(p-dt-trans).

            /* NÆo h  cota‡Æo para a moeda __ na data __ */
            {method/svc/errors/inserr.i &ErrorNumber="316"
                                        &ErrorType="EMS"
                                        &ErrorParameters=c-msg-aux}
        end.
    end.
    
    assign c-empresa-prin = "".
    
    find first estabelec
        where estabelec.cod-estabel = p-cod-estabel no-lock no-error.
    if avail estabelec then
        run cdp/cd9970.p (input rowid(estabelec),
                          output c-empresa-prin).
    
    /** Unificação de conceito **/
    empty temp-table tt_log_erro.
    if not valid-handle(h_api_cta_ctbl) then 
        run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
        

    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (INPUT c-empresa-prin,
                                                   INPUT "",
                                                   input-output p-conta-contabil,
                                                   INPUT TODAY,
                                                   output p_des_titulo,
                                                   output v_num_tip_cta_ctbl,
                                                   output v_num_sit_cta_ctbl,
                                                   output v_ind_finalid_cta,
                                                   OUTPUT TABLE tt_log_erro).
                                                  
    if can-find (first tt_log_erro) then do:
        FOR EACH tt_log_erro:
            CREATE RowErrors.
            ASSIGN RowErrors.errorNumber = tt_log_erro.ttv_num_cod_erro
                   RowErrors.errorHelp   = tt_log_erro.ttv_des_msg_ajuda
                   RowErrors.errorDescription = tt_log_erro.ttv_des_msg_erro
                   RowErrors.errorsequence = i-seq-erros-api-ctb-cc
                   i-seq-erros-api-ctb-cc = i-seq-erros-api-ctb-cc + 1.
        END.
    end. ELSE DO:

        if lookup(v_cod_finalid, v_ind_finalid_cta) > 0 then do:
            /* "Conta Invalida". */
            {method/svc/errors/inserr.i &ErrorNumber="288"
                                        &ErrorType="EMS"
                                        &ErrorParameters="''"}
        END.
        
        if v_num_sit_cta_ctbl <> 3 then do:
            /* "Conta nao e de Sistema". */
           {method/svc/errors/inserr.i  &ErrorNumber="443"
                                        &ErrorType="EMS"
                                        &ErrorParameters="''"}
        end.
        
        if not valid-handle(h_api_ccusto) then 
            run prgint/utb/utb742za.py persistent set h_api_ccusto.
            
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (INPUT c-empresa-prin,
                                                           INPUT p-cod-estabel,
                                                           INPUT "",
                                                           INPUT p-conta-contabil,
                                                           INPUT TODAY,
                                                           OUTPUT p_log_ccusto,
                                                           OUTPUT TABLE tt_log_erro).
        if p_log_ccusto then do:
            /** CENTRO DE CUSTO **/
            run pi_busca_dados_ccusto in h_api_ccusto (INPUT c-empresa-prin,
                                                       INPUT "",
                                                       input p-ccusto,
                                                       INPUT TODAY,
                                                       output p_des_titulo,
                                                       OUTPUT TABLE tt_log_erro).
            
            if can-find (first tt_log_erro no-lock) then do:
                FOR EACH tt_log_erro:
                    CREATE RowErrors.
                    ASSIGN RowErrors.errorNumber = tt_log_erro.ttv_num_cod_erro
                           RowErrors.errorHelp   = tt_log_erro.ttv_des_msg_ajuda
                           RowErrors.errorDescription = tt_log_erro.ttv_des_msg_erro
                           RowErrors.errorsequence = i-seq-erros-api-ctb-cc
                           i-seq-erros-api-ctb-cc = i-seq-erros-api-ctb-cc + 1.
                END.
            end.
        end.
    END.

    find item where item.it-codigo = p-it-codigo no-lock no-error.
    if  not avail item then do:
        /* "Item nao cadastrado" */
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item" *}
        ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-liter-item"}      
    end.
    
    if  item.cod-obsoleto = 4 then do:
        /* "Item obsoleto". */
        {method/svc/errors/inserr.i &ErrorNumber="563"
                                    &ErrorType="EMS"
                                    &ErrorParameters="''"}      
    end.    
    
    if  p-cod-estabel <> "" then do:
        find estabelec 
            where estabelec.cod-estabel = p-cod-estabel no-lock no-error.
        if  not avail estabelec then do:
            /* "Estabelecimento nao cadastrado". */
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-estabelecimento AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Estabelecimento" *}
            ASSIGN c-lbl-liter-estabelecimento = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-lbl-liter-estabelecimento"}         
        end.      
    end.   
    
    find first deposito where
               deposito.cod-depos = p-cod-depos no-lock no-error.
    if  not available deposito then do:
        /* "Deposito nao Cadastrado.". */
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-deposito AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Dep¢sito" *}
        ASSIGN c-lbl-liter-deposito = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-liter-deposito"}       
    end.      
    
    if p-cod-localiz <> "" then do:
       find localizacao where 
            localizacao.cod-estabel = p-cod-estabel  and
            localizacao.cod-depos   = p-cod-depos    and
            localizacao.cod-localiz = p-cod-localiz
            no-lock no-error.
       if not available localizacao then do:
           /* "Localizacao nao cadastrada !". */
         /* Inicio -- Projeto Internacional */
         DEFINE VARIABLE c-lbl-liter-localizacao AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Localiza‡Æo" *}
         ASSIGN c-lbl-liter-localizacao = TRIM(RETURN-VALUE).
         {method/svc/errors/inserr.i  &ErrorNumber="56"
                                      &ErrorType="EMS"
                                      &ErrorParameters="c-lbl-liter-localizacao"}
       end.
    end.   
   
    if p-un <> item.un then do:
       /* "Unidade de medida deve ser igual a do item !". */
         {method/svc/errors/inserr.i  &ErrorNumber="1225"
                                      &ErrorType="EMS"
                                      &ErrorParameters="''"}      
    end.              
    
    if p-quantidade <= 0 then do:
         /* Inicio -- Projeto Internacional */
         DEFINE VARIABLE c-lbl-liter-quantidade AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Quantidade" *}
         ASSIGN c-lbl-liter-quantidade = TRIM(RETURN-VALUE).
         {method/svc/errors/inserr.i  &ErrorNumber="36"
                                      &ErrorType="EMS"
                                      &ErrorParameters="c-lbl-liter-quantidade"}   
    end.
       
    if not item.fraciona and p-quantidade <> integer(p-quantidade) then do:
       /* "Quantidade nao pode ser fracionada". */
         {method/svc/errors/inserr.i  &ErrorNumber="1222"
                                      &ErrorType="EMS"
                                      &ErrorParameters="''"}      
    end.      
    
    if item.tipo-con-est = 2 and p-quantidade <> 1 then do:
       /* Quantidade de item por serie deve ser 1 */
         {method/svc/errors/inserr.i  &ErrorNumber="1234"
                                      &ErrorType="EMS"
                                      &ErrorParameters="''"}      
    end.                          
 
    find saldo-estoq use-index estabel-dep
        where saldo-estoq.cod-estabel = p-cod-estabel  
          and saldo-estoq.cod-depos   = p-cod-depos   
          and saldo-estoq.cod-localiz = p-cod-localiz  
          and saldo-estoq.lote        = p-lote         
          and saldo-estoq.it-codigo   = p-it-codigo  
          and saldo-estoq.cod-refer   = p-refer no-lock no-error.
    if  not available saldo-estoq then do:
        if  item.perm-saldo-neg = 1 then do:
            /* "Item sem saldo neste deposito" */      
            {method/svc/errors/inserr.i &ErrorNumber="1793"
                                        &ErrorType="EMS"
                                        &ErrorParameters="''"}
          
        end.
    end.      
    else do:
        
      &if '{&bf_lote_avancado_liberado}' = 'yes' &then
        assign l-retorno = yes.

        if l-lote-avancado and
           item.tipo-con-est > 2 then do:

            if not valid-handle(h-ceapi030) then
                run cep/ceapi030.p persistent set h-ceapi030 (input table tt-dados-fda,
                                                              output table tt-valores,
                                                              output table tt-erro).

            run pi-identifica-saldo in h-ceapi030 (input 1,
                                                   input saldo-estoq.it-codigo,
                                                   input saldo-estoq.cod-estabel,
                                                   input saldo-estoq.lote,
                                                   input 0,
                                                   output l-retorno,
                                                   output table tt-valores2,
                                                   output table tt-erro).
            if return-value = "nok":u then do:
                for each tt-erro:
                    {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                &ErrorType="EMS"
                                                &ErrorParameters="tt-erro.mensagem"}
                end.
            end.

        end.

        if l-retorno then
      &endif

        if  p-quantidade > (saldo-estoq.qtidade-atu  - saldo-estoq.qt-alocada   -
                            saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped  ) then do:
            if  item.perm-saldo-neg = 1 then do:
                /* "Item sem saldo neste deposito" */
                {method/svc/errors/inserr.i &ErrorNumber="1793"
                                            &ErrorType="EMS"
                                            &ErrorParameters="''"}
            end.
        end.                 
    end.
   
    if (item.tipo-contr = 1  
    or  item.tipo-contr = 3  
    or  item.tipo-contr = 4) 
    and p-conta-contabil-aplicacao = "" then do:
        /* "Conta nao cadastrada !". */
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-conta AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Conta" *}
        ASSIGN c-lbl-liter-conta = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-liter-conta"}
    
    
    
        /** Unifica‡Æo de conceito **/
        /** CONTA APLICACAO **/
        empty temp-table tt_log_erro.
        if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.  
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (INPUT c-empresa-prin,
                                                       INPUT "",
                                                       input-output p-conta-contabil-aplicacao,
                                                       INPUT TODAY,
                                                       output p_des_titulo,
                                                       output v_num_tip_cta_ctbl,
                                                       output v_num_sit_cta_ctbl,
                                                       output v_ind_finalid_cta,
                                                       OUTPUT TABLE tt_log_erro).

        if can-find (first tt_log_erro no-lock) then do:
            FOR EACH tt_log_erro:
                CREATE RowErrors.
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Conta_Contabil_Aplica‡Æo" *}
                ASSIGN RowErrors.errorNumber = tt_log_erro.ttv_num_cod_erro
                       RowErrors.errorHelp   = tt_log_erro.ttv_des_msg_ajuda
                       RowErrors.errorDescription = RETURN-VALUE + ": " + tt_log_erro.ttv_des_msg_erro
                       RowErrors.errorsequence = i-seq-erros-api-ctb-cc
                       i-seq-erros-api-ctb-cc = i-seq-erros-api-ctb-cc + 1.
            END.                                         
        end.
        ELSE DO:

            if lookup(v_cod_finalid, v_ind_finalid_cta) > 0 then do:
                /* "Conta Invalida". */
                {method/svc/errors/inserr.i  &ErrorNumber="288"
                                             &ErrorType="EMS"
                                             &ErrorParameters="''"}
            END.
            
            if v_num_sit_cta_ctbl <> 3 then do:
                /* "Conta Aplicacao nao e de Sistema". */
               {method/svc/errors/inserr.i  &ErrorNumber="52150"
                                            &ErrorType="EMS"
                                            &ErrorParameters="''"}
            end.
            
            if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
            run pi_verifica_utilizacao_ccusto in h_api_ccusto (INPUT c-empresa-prin,
                                                               INPUT p-cod-estabel,
                                                               INPUT "",
                                                               INPUT p-conta-contabil-aplicacao,
                                                               INPUT TODAY,
                                                               OUTPUT p_log_ccusto,
                                                               OUTPUT TABLE tt_log_erro).
                                                               
            if p_log_ccusto then do:
                /** CENTRO DE CUSTO APLICAÇÃO **/
                run pi_busca_dados_ccusto in h_api_ccusto (INPUT c-empresa-prin,
                                                           INPUT "",
                                                           input p-ccusto-aplicacao,
                                                           INPUT TODAY,
                                                           output p_des_titulo,
                                                           OUTPUT TABLE tt_log_erro).
                
                if can-find (first tt_log_erro no-lock) then do:
                    FOR EACH tt_log_erro:
                        CREATE RowErrors.
                        /* Inicio -- Projeto Internacional */
                        {utp/ut-liter.i "Centro_de_Custo_Aplica‡Æo" *}
                        ASSIGN RowErrors.errorNumber = tt_log_erro.ttv_num_cod_erro
                               RowErrors.errorHelp   = tt_log_erro.ttv_des_msg_ajuda
                               RowErrors.errorDescription = RETURN-VALUE + ": " + tt_log_erro.ttv_des_msg_erro
                               RowErrors.errorsequence = i-seq-erros-api-ctb-cc
                               i-seq-erros-api-ctb-cc = i-seq-erros-api-ctb-cc + 1.
                    END.                                         
                end.
            end.
        END.
    end.
    
    /* Faz todas as validações necessárias para a Conta. */
    if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.  
    run pi_valida_conta_contabil in h_api_cta_ctbl (input  c-empresa-prin,      /* EMPRESA EMS2 */
                                                    input  p-cod-estabel,      /* ESTABELECIMENTO EMS2 */
                                                    input  "",      /* UNIDADE NEG…CIO */
                                                    input  "",      /* PLANO CONTAS */ 
                                                    input  p-conta-contabil,  /* CONTA */
                                                    input  "",      /* PLANO CCUSTO */ 
                                                    input  p-ccusto,      /* CCUSTO */
                                                    input  today,   /* DATA TRANSACAO */
                                                    output table tt_log_erro). /* ERROS */
    
    if can-find (first tt_log_erro no-lock) then do:
        FOR EACH tt_log_erro:
            CREATE RowErrors.
            ASSIGN RowErrors.errorNumber = tt_log_erro.ttv_num_cod_erro
                   RowErrors.errorHelp   = tt_log_erro.ttv_des_msg_ajuda
                   RowErrors.errorDescription = tt_log_erro.ttv_des_msg_erro
                   RowErrors.errorsequence = i-seq-erros-api-ctb-cc
                   i-seq-erros-api-ctb-cc = i-seq-erros-api-ctb-cc + 1.
        END.                                         
    end.
    
    
    /* Faz todas as validações necessárias para a Conta de Aplicação. */
    if (item.tipo-contr = 1  
    or  item.tipo-contr = 3  
    or  item.tipo-contr = 4) 
    and p-conta-contabil-aplicacao = "" then do:
        run pi_valida_conta_contabil in h_api_cta_ctbl (input  c-empresa-prin, /* EMPRESA EMS2 */
                                                        input  p-cod-estabel,  /* ESTABELECIMENTO EMS2 */
                                                        input  "",      /* UNIDADE NEG…CIO */
                                                        input  "",      /* PLANO CONTAS */ 
                                                        input  p-conta-contabil-aplicacao,  /* CONTA */
                                                        input  "",      /* PLANO CCUSTO */ 
                                                        input  p-ccusto-aplicacao,      /* CCUSTO */
                                                        input  today,   /* DATA TRANSACAO */
                                                        output table tt_log_erro). /* ERROS */
        
        if can-find (first tt_log_erro no-lock) then do:
            FOR EACH tt_log_erro:
                CREATE RowErrors.
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Centro_de_Custo_Aplica‡Æo" *}
                ASSIGN RowErrors.errorNumber = tt_log_erro.ttv_num_cod_erro
                       RowErrors.errorHelp   = tt_log_erro.ttv_des_msg_ajuda
                       RowErrors.errorDescription = RETURN-VALUE + ": " + tt_log_erro.ttv_des_msg_erro
                       RowErrors.errorsequence = i-seq-erros-api-ctb-cc
                       i-seq-erros-api-ctb-cc = i-seq-erros-api-ctb-cc + 1.
            END.                    
        end.
    end.
    
    &if '{&bf_lote_avancado_liberado}' = 'yes' &then
        if valid-handle(h-ceapi030) then
            delete procedure h-ceapi030.
    &endif
    
    if valid-handle(h_api_ccusto) then
        delete object h_api_ccusto.
    if valid-handle(h_api_cta_ctbl) then
        delete object h_api_cta_ctbl.
                
    RETURN "OK":U.        
		
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaProcesRotListaCompon DBOProgram 
PROCEDURE validaProcesRotListaCompon :
/*------------------------------------------------------------------------------
  Purpose:     Valida proces-item, roteiro e lista-compon.
                       
  Notes:       
------------------------------------------------------------------------------*/

def input param pCase     as int  no-undo.
def input param pItCodigo as char no-undo.
def input param pCodRot   as char no-undo.
def input param pCodLista as char no-undo.

case pCase:
when 1 then do:
    if pCodRot <> "" or pCodLista <> "" then do:
        find first proces-item where proces-item.it-codigo        = pItCodigo and
                                     proces-item.cod-lista-compon = pCodLista and
                                     proces-item.cod-roteiro      = pCodRot no-lock no-error.
        if not avail proces-item then 
            return "NOK":U.
    end.
end.

when 2 then do:
    if pCodRot <> "" then do:
        find first rot-fabric where rot-fabric.cod-roteiro = pCodRot no-lock no-error.
        if avail rot-fabric then 
            return "OK":U.
        else return "NOK":U.
    end.
end.

when 3 then do:
    if pCodLista <> "" then do:
        find first lista-compon where lista-compon.cod-lista-compon = pCodlista no-lock no-error.
        if avail lista-compon then 
            return "OK":U.
        else return "NOK":U.
    end.
end.

end case.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE integraNeogrid DBOProgram 
PROCEDURE integraNeogrid:
    DEFINE INPUT PARAMETER pitCodigo LIKE item.it-codigo NO-UNDO.

    FIND FIRST bfitem WHERE 
        bfitem.it-codigo = pitCodigo NO-LOCK NO-ERROR.
     /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem THEN 
        RETURN "NOK":U.
    
    /* Integra»’o Neogrid */
    run utp/ut-neog.p.
    if return-value = "OK" then
        for each estabelec fields (cod-emitente cod-estabel) no-lock,
            first dist-emitente fields (cod-emitente)
            where dist-emitente.cod-emitente = estabelec.cod-emitente
            and   dist-emitente.parceiro-b2b = yes no-lock:
        
            run adapters/neogrid/enp/aneen005.p (input ROWID(bfitem),
                                                 input estabelec.cod-estabel,
                                                 input estabelec.cod-emitente,
                                                 input "Update").
        END.            

   
    RETURN "OK":U.
END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deletePenditem DBOProgram 
PROCEDURE deletePenditem:
    DEFINE INPUT PARAMETER pitCodigo LIKE item.it-codigo NO-UNDO.
    DEFINE VARIABLE h-boin296a AS HANDLE      NO-UNDO.

    IF  NOT VALID-HANDLE(h-boin296a) THEN
        RUN inbo/boin296a.p PERSISTENT SET h-boin296a.

    FIND FIRST bfitem WHERE 
               bfitem.it-codigo = pitCodigo NO-LOCK NO-ERROR.
     /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem THEN 
        RETURN "NOK":U.
    
    run deletePenditem IN h-boin296a (input bfitem.it-codigo,
                                      input "MRE").
    RETURN "OK":U.

    FINALLY:
        DELETE PROCEDURE h-boin296a NO-ERROR.
    END FINALLY.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eaiIntegration DBOProgram 
PROCEDURE eaiIntegration :
    DEFINE INPUT PARAMETER pitCodigo LIKE item.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR RowErrors.
    
    DEFINE VARIABLE  h-ut-integration AS HANDLE      NO-UNDO.

     FIND FIRST bfitem WHERE 
                bfitem.it-codigo = pitCodigo NO-LOCK NO-ERROR.
     /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem THEN 
        RETURN "NOK":U.

     /*Api de Integra»’o*/
    RUN utp/ut-integration.p PERSISTENT SET h-ut-integration.
    RUN eai-integration IN h-ut-integration (INPUT "Item",            /* Nome da transa»’o     */
                                             INPUT ROWID(bfitem),   /* Registro da transa»’o */
                                             INPUT "UPDATE",          /* Evento da transa»’o   */
                                             OUTPUT TABLE RowErrors). /* Erros da transa»’o    */
     

    RETURN "OK":U.
    FINALLY:
        DELETE PROCEDURE h-ut-integration  NO-ERROR.
    END FINALLY.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDeleteFrotas DBOProgram 
PROCEDURE validateDeleteFrotas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define variable h-abapi008 as handle  no-undo.
define variable iErro      as integer no-undo.
define variable lValida    as logical no-undo.
define variable i-cont     as integer no-undo.

assign lValida = no.
do i-cont = 1 to 5:
    run cdp/cd9902.p (input i-cont).
    if return-value = "OK":U then do:
        assign lValida = yes.
        leave.
    end.
end.
if lValida then do:
    /** Passa o rowid para API de Frotas **/
    run abp/abapi008.p persistent set h-abapi008 (input RowObject.r-rowid).
    /** Valida‡äes de Frotas **/
    run validateItem in h-abapi008 (RowObject.it-codigo).
    if return-value = "NOK":U then do:
        empty temp-table RowErrorsFrotas.
        /** Busca os erros ocorridos em frotas **/
        run getRowErrors in h-abapi008 (output table RowErrorsFrotas).
        assign iErro = 0.
        /** Se ocorreram erros noproduto padrÆo, busca a £ltima sequˆncia **/
        for last RowErrors no-lock:
            assign iErro = RowErrors.ErrorSequence.
        end.
        /** Percorre os erros ocorridos em frotas **/
        for each RowErrorsFrotas no-lock:
            /** Cria os erros no produto padrÆo **/
            create RowErrors.
            buffer-copy RowErrorsFrotas except ErrorSequence to RowErrors
                assign RowErrors.ErrorSequence = iErro + 1
                       iErro                   = RowErrors.ErrorSequence.
        end.
        empty temp-table RowErrorsFrotas.
    end.
    /** Elimina a API da mem¢ria **/
    if valid-handle(h-abapi008) then
        delete procedure h-abapi008.
end.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    DEFINE BUFFER b2-item FOR ITEM.
    
    FIND FIRST param-global NO-LOCK no-error.

    IF NOT VALID-HANDLE(h-bocx00480) THEN DO:
       RUN cxbo/bocx00480.p PERSISTENT SET h-bocx00480.
       RUN openQueryStatic IN h-bocx00480 (INPUT "Main":U).
    END.

    IF RowObject.tipo-con-est = 3 AND
        CAN-FIND(FIRST ITEM WHERE
                 ITEM.it-codigo     = RowObject.it-codigo AND
                 ITEM.tipo-con-est <> 3) AND
        CAN-FIND(first item-lista-compon where
                 item-lista-compon.es-codigo         = RowObject.it-codigo and
                 item-lista-compon.log-compon-altern = YES) THEN DO:

        /* O Componente nÆo pode ser controlado por Lote para ser Alternativo da Lista */

        {method/svc/errors/inserr.i
            &ErrorNumber="18233"
            &ErrorType="EMS"
            &ErrorParameters="' '"}  
    END.

    if pType = "CREATE":U then do:
       IF CAN-FIND(item
          WHERE item.it-codigo = RowObject.it-codigo) THEN
          /* Inicio -- Projeto Internacional */
          DO:
          DEFINE VARIABLE c-lbl-liter-item-2 AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Item" *}
          ASSIGN c-lbl-liter-item-2 = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i
           &ErrorNumber="7" 
           &ErrorType="EMS"
           &ErrorParameters="c-lbl-liter-item-2"}
          END.   
    end.
    
    if RowObject.peso-liquido >
       RowObject.peso-bruto then do:
          {method/svc/errors/inserr.i
           &ErrorNumber="3912" 
           &ErrorType="EMS"
           &ErrorParameters="''"}  
    end.		
    
    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/
    
    if param-global.modulo-co = yes and 
       can-find(first modelo-cf where modelo-cf.item-criado = RowObject.it-codigo) then do:
         FIND FIRST b2-item WHERE b2-item.it-codigo = RowObject.it-codigo NO-LOCK NO-ERROR.
         IF avail b2-item THEN DO:
             if b2-item.politica = 5                   and
                b2-item.politica <> RowObject.politica then 
                   {method/svc/errors/inserr.i
                     &ErrorNumber="4329" 
                     &ErrorType="EMS"
                     &ErrorParameters="''"}  
             
             if b2-item.tipo-con-est = 4                       AND
                b2-item.tipo-con-est <> RowObject.tipo-con-est then             
                    {method/svc/errors/inserr.i
                     &ErrorNumber="19060" 
                     &ErrorType="EMS"
                     &ErrorParameters="''"}  
         END.
    end.

    /******VALIDA LOTE ECONâMICO************/
    IF  CAN-FIND(ITEM WHERE ITEM.it-codigo     = RowObject.it-codigo
                        AND NOT RowObject.fraciona 
                        AND RowObject.lote-economi - INT(RowObject.lote-economi) <> 0 ) THEN DO:

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Item" *}
        ASSIGN c-lbl-liter-item-3 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                   &ErrorNumber="55909"
                   &ErrorType="EMS"
                   &ErrorParameters="c-lbl-liter-item-3"}
    END.

    /******VALIDA LOTE MÖNIMO************/
    IF  CAN-FIND(ITEM WHERE ITEM.it-codigo     = RowObject.it-codigo
                        AND NOT RowObject.fraciona 
                        AND RowObject.lote-minimo  - INT(RowObject.lote-minimo) <> 0 ) THEN DO:

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Item" *}
        ASSIGN c-lbl-liter-item-3 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                   &ErrorNumber="55908"
                   &ErrorType="EMS"
                   &ErrorParameters="c-lbl-liter-item-3"}
    END.

    /******VALIDA LOTE MéLTIPLO************/
    IF  CAN-FIND(ITEM WHERE ITEM.it-codigo     = RowObject.it-codigo
                        AND NOT RowObject.fraciona 
                        AND RowObject.lote-multipl - INT(RowObject.lote-multipl) <> 0 ) THEN DO:

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Item" *}
        ASSIGN c-lbl-liter-item-3 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                   &ErrorNumber="26120"
                   &ErrorType="EMS"
                   &ErrorParameters="c-lbl-liter-item-3"}
    END.

    IF pType <> "DELETE":U THEN DO:
        FIND FIRST tt-item-siscomex NO-LOCK NO-ERROR.

        IF AVAIL tt-item-siscomex THEN DO:
           RUN piSetaErroItem IN h-bocx00480 (INPUT CAN-FIND(FIRST RowErrors)).
           RUN emptyRowObject     IN h-bocx00480.
           RUN emptyRowErrors     IN h-bocx00480.
           RUN goToKey            IN h-bocx00480(INPUT tt-item-siscomex.cod-item).
           
           IF RETURN-VALUE = "OK":U THEN DO:
               RUN setRecord    IN h-bocx00480 (INPUT TABLE tt-item-siscomex).
               RUN updateRecord IN h-bocx00480.
           END.
           ELSE DO:
               RUN setRecord    IN h-bocx00480 (INPUT TABLE tt-item-siscomex).
               RUN createRecord IN h-bocx00480.
           END.
           
           RUN getRowErrors IN h-bocx00480 (OUTPUT TABLE RowErrors).
        END. 
    END.
    
    IF VALID-HANDLE(h-bocx00480) THEN DO:
       DELETE PROCEDURE h-bocx00480.
       ASSIGN h-bocx00480 = ?.
    END.  

    if pType = "Delete":U then
        run validateDeleteFrotas in this-procedure.

    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaTtItem DBOProgram 
PROCEDURE validaTtItem :
/*------------------------------------------------------------------------------
  Purpose:     Valida dados para cria‡Æo da tabela de registro.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  parameter table for tt-valida-item.             
    def output parameter table for RowErrors.
    
    def var item-atual as char no-undo.
        
    for each RowErrors exclusive-lock:
        delete RowErrors.
    end.
         
    for each tt-valida-item no-lock:
        if tt-valida-item.cod-item <> "" then do:   
            assign item-atual = tt-valida-item.cod-item. 
                
             find first {&tablename} where {&TABLENAME}.it-codigo = item-atual
            no-lock no-error.
            if not avail {&TABLENAME} then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-item-4 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Item" *}
                ASSIGN c-lbl-liter-item-4 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i  &ErrorNumber="2"
                                             &ErrorType="EMS"
                                             &ErrorParameters="c-lbl-liter-item-4"}      
                leave.
            end.
        end. 
    end.
    
    RETURN "OK":U.      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaParametros DBOProgram 
PROCEDURE verificaParametros :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se os parƒmetros globais e os parƒmetros de estoque estÆo atualizados.
               Retorna a empresa principal dos parƒmetros globais ou do estabelecimento.
  Parameters:  output - c¢digo do erro.
               output - empresa
  Notes:       
------------------------------------------------------------------------------*/
    def output param pcd-erro       as int.
    def output param pempresa-prin LIKE empresa.ep-codigo.
    
    
    find first param-global no-lock no-error.
    if not available param-global then
       assign pcd-erro = 16.
     
    find first param-estoq no-lock no-error.
    if not avail param-estoq then
       assign pcd-erro = 1059.
    
    if avail param-global and avail param-estoq then do:
        assign pempresa-prin = param-global.empresa-prin.
        &IF DEFINED (bf_mat_conta_estab) &THEN
            find first estabelec
                 where estabelec.cod-estabel = param-estoq.estabel-pad no-lock no-error.
            if avail estabelec then
               run cdp/cd9970.p (input rowid(estabelec),
                                 output pempresa-prin).
        &ENDIF
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaSaldoItemDeposito DBOProgram 
PROCEDURE verificaSaldoItemDeposito :
/*------------------------------------------------------------------------------
  Purpose:    Verifica o saldo total do item existente em varios depositos
  Parameters:ipar: p-it-codigo : Codigo do item a ser pesquisado
             opar: p-saldo     : Saldo total do item nos depósitos

------------------------------------------------------------------------------*/
    def input parameter p-it-codigo like item.it-codigo no-undo.
    def output parameter p-saldo     as dec             no-undo.

    assign p-saldo = 0.

    find first item where item.it-codigo = p-it-codigo no-lock no-error.
    if avail item then do:
        for each saldo-estoq fields(it-codigo qtidade-atu qt-alocada
                                    qt-aloc-prod qt-aloc-ped)
            use-index item
            where saldo-estoq.it-codigo = item.it-codigo no-lock,
            each deposito fields(cod-depos cons-saldo)
                where deposito.cod-depos  = saldo-estoq.cod-depos  and
                      deposito.cons-saldo no-lock:

              &if '{&bf_lote_avancado_liberado}' = 'yes' &then
                assign l-retorno = yes.
    
                if l-lote-avancado and
                   item.tipo-con-est > 2 then do:
    
                    if not valid-handle(h-ceapi030) then
                        run cep/ceapi030.p persistent set h-ceapi030 (input table tt-dados-fda,
                                                                      output table tt-valores,
                                                                      output table tt-erro).
    
                    run pi-identifica-saldo in h-ceapi030 (input 1,
                                                           input saldo-estoq.it-codigo,
                                                           input saldo-estoq.cod-estabel,
                                                           input saldo-estoq.lote,
                                                           input 0,
                                                           output l-retorno,
                                                           output table tt-valores2,
                                                           output table tt-erro).
                    if return-value = "nok":u then do:
                        for each tt-erro:
                            /* Inicio -- Projeto Internacional */
                            DEFINE VARIABLE c-lbl-liter-tt-erromensagem AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "tt-erro.mensagem" *}
                            ASSIGN c-lbl-liter-tt-erromensagem = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                        &ErrorType="EMS"
                                                        &ErrorParameters="c-lbl-liter-tt-erromensagem"}
                        end.
                    end.
    
                end.
    
                if l-retorno then
              &endif

                 assign p-saldo = p-saldo +
                                 (saldo-estoq.qtidade-atu  - saldo-estoq.qt-alocada -
                                  saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped).
        end.

        for each saldo-terc fields(it-codigo quantidade)
            where saldo-terc.it-codigo = item.it-codigo no-lock,
            each deposito fields(cod-depos cons-saldo)
                where deposito.cod-depos  = saldo-terc.cod-depos   and
                      deposito.cons-saldo  no-lock:

              &if '{&bf_lote_avancado_liberado}' = 'yes' &then
                assign l-retorno = yes.
    
                if l-lote-avancado and
                   item.tipo-con-est > 2 then do:
    
                    if not valid-handle(h-ceapi030) then
                        run cep/ceapi030.p persistent set h-ceapi030 (input table tt-dados-fda,
                                                                      output table tt-valores,
                                                                      output table tt-erro).
    
                    run pi-identifica-saldo in h-ceapi030 (input 1,
                                                           input saldo-estoq.it-codigo,
                                                           input saldo-estoq.cod-estabel,
                                                           input saldo-estoq.lote,
                                                           input 0,
                                                           output l-retorno,
                                                           output table tt-valores2,
                                                           output table tt-erro).
                    if return-value = "nok":u then do:
                        for each tt-erro:
                            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                        &ErrorType="EMS"
                                                        &ErrorParameters="tt-erro.mensagem"}
                        end.
                    end.
    
                end.
    
                if l-retorno then
              &endif

                 assign p-saldo = p-saldo + saldo-terc.quantidade.
        end.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEnviaItemSiscomex DBOProgram 
procedure piEnviaItemSiscomex:
/*
** Recebe temp-table tt-item-siscomex para que os dados sejam validados 
** na cria‡Æo/modifica‡Æo/elimina‡Æo do registro da tabela item
*/
    define input parameter table for tt-item-siscomex.

    return "OK":U.
end procedure.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piIntegracao DBOProgram 
PROCEDURE piIntegracao:
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    DEFINE VARIABLE h-ut-integration AS HANDLE      NO-UNDO.

    RUN utp/ut-integration.p PERSISTENT SET h-ut-integration.
    RUN eai-integration IN h-ut-integration (INPUT "Item":U,          /* Nome da transa‡Æo     */
                                             INPUT ROWID(ITEM),       /* Registro da transa‡Æo */
                                             INPUT pType,             /* Evento da transa‡Æo   */
                                             OUTPUT TABLE RowErrors). /* Erros da transa‡Æo    */
    DELETE PROCEDURE h-ut-integration.
END PROCEDURE.


{cep/ceapi001.i1} /* pi-gera-temp-erro e pi-gera-temp-erro-help */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

