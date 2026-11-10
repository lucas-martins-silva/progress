&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
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
{include/i-prgvrs.i BOIN157FX 2.00.00.013 } /*** "010013" 17/06/2025 16:40:46 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN157
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName inventario
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
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
{inbo/boin157.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}  FOR {&TableName}.
DEFINE BUFFER bf2{&TableName} FOR {&TableName}.




{utp/ut-glob.i}
{fch/fchmat/fchmatkeeptrackmaterialrequisition.i ttTotals} 
{fch/fchmat/fchmatkeeptrackinventorycount.i3 ttInventoryCountParam} 
{fch/fchmat/fchmatkeeptrackinventorycount.i5 ttRelatedActionsParameter} 
{fch/fchmat/fchmatkeeptrackinventorycount.i ttVarianceParameter} 
{fch/fchmat/fchmatkeeptrackinventorycount.i1 ttVariance} 
{fch/fchmat/fchmatkeeptrackinventorycount.i6 ttInventoryCurrency} 
{fch/fchmat/fchmatkeeptrackinventorycount.i8 ttInterval} 
{fch/fchmat/fchmatkeeptrackinventorycount.i9 ttItemWithoutValue} 
{fch/fchmat/fchmatkeeptrackinventorycount.i9 ttItemWithoutValueAux} 
{fch/fchmat/fchmatkeeptrackinventorycount.i4 ttCountingParameter}
{fch/fchmat/fchmatkeeptrackinventorycount.i2 ttCounting}
{fch/fchmat/fchmatkeeptrackinventorycount.i7 ttStringReturn}
{fch/fchmat/fchmatkeeptrackinventorycount.i10 ttDigitaSite}
{fch/fchmat/fchmatkeeptrackinventorycount.i11 ttDigitaItem}
{fch/fchmat/fchmatkeeptrackofcountingsheets.i ttCountingSheetsParam} 
{fch/fchmat/fchmatkeeptrackofcountingsheets.i1 ttCountingSheets} 
{fch/fchmat/fchmatkeeptrackofcountingsheets.i1 ttCountingSheets2}
{fch/fchmat/fchmatinventoryitemmovementdetail.i ttMovementDetail}

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}
    
{include/i-epc200.i boin157fx}         /* Definicao da temp-table tt-epc */

DEFINE BUFFER c-movto        FOR movto-estoq.


def new global shared var v_cod_aplicat_dtsul_corren as character format "x(3)":U  no-undo.
def new global shared var v_cod_grp_usuar_lst        as character format "x(3)":U  no-undo.
def new global shared var v_cod_idiom_usuar          as character format "x(8)":U  no-undo.
def new global shared var v_cod_pais_empres_usuar    as character format "x(3)":U  no-undo.
def new global shared var v_cod_usuar_corren         as character format "x(12)":U no-undo.
def new global shared var v_cod_usuar_corren_criptog as character format "x(16)":U no-undo.

def var h_api_cta as handle no-undo.
def var h_api_ccust as handle no-undo.
def var v_des_cta_ctbl AS CHAR no-undo.
def var v_num_tip_cta_ctbl AS INTEGER no-undo.
def var v_num_sit_cta_ctbl AS INTEGER no-undo.
def var v_ind_finalid_cta AS CHAR no-undo.
def var v_des_ccusto AS CHAR no-undo.
def var sc-conta like movto-estoq.sc-codigo no-undo.
def var ct-conta like movto-estoq.ct-codigo no-undo.
DEFINE VARIABLE i-empresa     LIKE param-global.empresa-prin NO-UNDO.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N·mero" column-label "N·mero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsist™ncia".

DEFINE TEMP-TABLE RowErrorsAux NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

def temp-table tt-raw-digita no-undo
   field raw-digita      as raw.

def var raw-param      as raw no-undo.

def temp-table tt-retorno-erro no-undo
    field cod-erro         as integer format ">>>>>>>>9"
    field desc-erro        as character.

def temp-table tt-pedido-execucao no-undo
    field num-ped-exec      as integer format "99999"
    field data-exec         as date format "99/99/9999"
    field hora-exec         as char format "99:99:99".

define temp-table tt-paramUpdateInventory no-undo
    field destino      as integer
    field arquivo      as char
    field usuario      as char format "x(12)"
    field data-exec    as date
    field hora-exec    as integer
    field c-estab-ini  as char
    field c-estab-fim  as char
    field c-depos-ini  as char
    field c-depos-fim  as char
    field i-ficha-ini  as integer
    field i-ficha-fim  as integer
    field c-item-ini   as char
    field c-item-fim   as char
    field da-corte     as date format "99/99/9999"
    field da-trans     as date format "99/99/9999"
    field c-conta-ent  as char
    field c-ccusto-ent as char
    field c-conta-sai  as char
    field c-ccusto-sai as char
    field i-atual      as integer
    field c-atual      as char
    field c-destino    as char
    field l-imp-param  as log.

define temp-table tt-paramGenerateCountingSheets
    field destino             as integer   format "99"
    field arquivo             as character format "x(80)"
    field usuario             as character
    field data-exec           as date
    field hora-exec           as integer
    field item-ini            like item.it-codigo
    field item-fim            like item.it-codigo
    field ge-ini              like item.ge-codigo
    field ge-fim              like item.ge-codigo
    field familia-ini         like item.fm-codigo
    field familia-fim         like item.fm-codigo
    field lote-ini            like inventario.lote
    field lote-fim            like inventario.lote
    field refer-ini           like inventario.cod-refer  
    field refer-fim           like inventario.cod-refer  
    field localizacao-ini     like inventario.cod-localiz
    field localizacao-fim     like inventario.cod-localiz
    field depos-ini           like inventario.cod-depos
    field depos-fim           like inventario.cod-depos
    field estab-ini           like inventario.cod-estabel
    field estab-fim           like inventario.cod-estabel
    field zera-variac         as logical
    field ciclo-cont          as logical
    field saldo-zero          as logical
    field sem-saldo           as logical
    field consignado          as logical
    field obsoleto            as integer
    field data-movto-ini      as date      format "99/99/9999"
    field data-movto-fim      as date      format "99/99/9999"
    field data-corte          as date      format "99/99/9999"
    field data-ultima-entrada as date      format "99/99/9999"
    field data-ultima-saida   as date      format "99/99/9999"
    field preco               as integer
    field valor               as decimal   format "->>,>>9.99"
    FIELD epcValue            AS CHAR
    field cdn-agrup           like inventario.cdn-agrup.

define temp-table tt-paramPrintCountingSheets
    field destino      as integer
    field arquivo      as char
    field usuario      as char
    field data-exec    as date
    field hora-exec    as integer
    field classifica   as integer
    field item-ini     like inventario.it-codigo
    field item-fim     like inventario.it-codigo
    field familia-ini  like item.fm-codigo
    field familia-fim  like item.fm-codigo
    field lote-ini     like inventario.lote
    field lote-fim     like inventario.lote
    field localiz-ini  like inventario.cod-localiz
    field localiz-fim  like inventario.cod-localiz
    field depos-ini    like inventario.cod-depos
    field depos-fim    like inventario.cod-depos
    field estab-ini    like inventario.cod-estabel
    field estab-fim    like inventario.cod-estabel
    field ge-ini       like item.ge-codigo
    field ge-fim       like item.ge-codigo
    field ficha-ini    like inventario.nr-ficha
    field ficha-fim    like inventario.nr-ficha
    field data-corte   as date
    field ficha-etiq   as integer
    field qt-bran      as integer
    field fic-ini      as integer
    field c-destino    as char
    field l-imp-param  as logical
    field epcValue     as char.

define temp-table tt-paramDeleteInventory
    field destino          as integer
    field arquivo          as char
    field usuario          as char
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field it-codigo-i      like inventario.it-codigo
    field it-codigo-f      like inventario.it-codigo
    field nr-ficha-i       like inventario.nr-ficha
    field nr-ficha-f       like inventario.nr-ficha
    field cod-estabel-i    like inventario.cod-estabel
    field cod-estabel-f    like inventario.cod-estabel
    field cod-depos-i      like inventario.cod-depos
    field cod-depos-f      like inventario.cod-depos
    field dt-saldo-i       like inventario.dt-saldo
    field dt-saldo-f       like inventario.dt-saldo
    field rs-par-invent    as integer
     field l-imp-param     as log.

def new global shared var v_log_eai_habilit as logical no-undo.

DEFINE TEMP-TABLE tt-inventario NO-UNDO LIKE inventario
       field r-rowid as rowid.

DEFINE TEMP-TABLE tt-inventario-adapter NO-UNDO LIKE inventario
       field r-rowid as rowid.

DEFINE TEMP-TABLE tt-inventario-aux NO-UNDO LIKE inventario
       field r-rowid as rowid.



DEFINE TEMP-TABLE ttParamMD NO-UNDO
    FIELD itCodigoIni         AS CHARACTER
    FIELD itCodigoFim         AS CHARACTER
    FIELD fmCodigoIni         AS CHARACTER
    FIELD fmCodigoFim         AS CHARACTER
    FIELD geCodigoIni         AS INTEGER
    FIELD geCodigoFim         AS INTEGER
    FIELD codLocalizIni       AS CHARACTER
    FIELD codLocalizFim       AS CHARACTER
    FIELD codDeposIni         AS CHARACTER
    FIELD codDeposFim         AS CHARACTER
    FIELD codEstabelIni       AS CHARACTER
    FIELD codEstabelFim       AS CHARACTER
    FIELD nrFichaIni          AS INTEGER
    FIELD nrFichaFim          AS INTEGER
    FIELD codConfteContagIni  AS CHARACTER
    FIELD codConfteContagFim  AS CHARACTER
    FIELD loteIni             AS CHARACTER
    FIELD loteFim             AS CHARACTER
    FIELD dtSaldo             AS DATE.

DEFINE TEMP-TABLE ttInventarioMD NO-UNDO
    FIELD nrFicha          AS INTEGER  
    FIELD itCodigo         AS CHARACTER
    FIELD descItem         AS CHARACTER
    FIELD codEstabel       AS CHARACTER
    FIELD codDepos         AS CHARACTER
    FIELD codLocaliz       AS CHARACTER
    FIELD lote             AS CHARACTER
    FIELD codRefer         AS CHARACTER
    FIELD valorContab      AS DECIMAL
    FIELD un               AS CHARACTER
    FIELD codConfteContag1 AS CHARACTER
    FIELD valApurado1      AS CHARACTER
    FIELD codConfteContag2 AS CHARACTER
    FIELD valApurado2      AS CHARACTER
    FIELD codConfteContag3 AS CHARACTER
    FIELD valApurado3      AS CHARACTER
    FIELD situacao         AS CHARACTER
    FIELD situacaoInt      AS INTEGER
    FIELD itemDepBloq      AS CHARACTER
    FIELD dtAtualiza       AS DATE
    FIELD descTabUnidade   AS CHARACTER
    FIELD dtSaldo          AS DATE.
       
DEFINE VARIABLE h-boin157q01 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin172    AS HANDLE NO-UNDO.

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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 10.42
         WIDTH              = 45.43.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addCountingSheets DBOProgram 
PROCEDURE addCountingSheets :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM TABLE FOR ttCountingSheets.
DEF OUTPUT PARAM TABLE FOR RowErrors.
DEF VAR r-rowid-aux           AS ROWID                  NO-UNDO.
DEF VAR l-loc-unica           AS LOG                    NO-UNDO.
DEF VAR l-habilita            AS LOG                    NO-UNDO.
DEF VAR d-return              AS DATE                   NO-UNDO.

IF  NOT VALID-HANDLE(h-boin157q01) THEN DO:
    RUN inbo/boin157q01.p PERSISTENT SET h-boin157q01.
    FIND FIRST ttCountingSheets NO-LOCK NO-ERROR.
    Run setConstraintDataSaldo in h-boin157q01 (INPUT ttCountingSheets.inventoryDate).
    RUN openQueryStatic  IN h-boin157q01 (INPUT "Inclui":U)  NO-ERROR.    
    IF CAN-FIND (FIRST RowErrors WHERE RowErrors.errorsubtype = "ERROR") THEN DO:
        RETURN "NOK":U.
    END.
END.
    
CRIA:
DO TRANSACTION:
    
    IF VALID-HANDLE(h-boin157q01) THEN DO:

        RUN setConstraintInclui IN h-boin157q01 (1). /* 1¶ contagem */
        RUN setConstraintValidValues   IN h-boin157q01 (NO). 

        FOR FIRST ttCountingSheets NO-LOCK:
            CREATE tt-inventario.
            ASSIGN tt-inventario.cod-depos       = ttCountingSheets.warehouse 
                   tt-inventario.cod-estabel     = ttCountingSheets.site 
                   tt-inventario.cod-localiz     = ttCountingSheets.binLocation 
                   tt-inventario.cod-refer       = ttCountingSheets.reference 
                   tt-inventario.dt-saldo        = ttCountingSheets.inventoryDate 
                   tt-inventario.it-codigo       = ttCountingSheets.item 
                   tt-inventario.lote            = ttCountingSheets.lot 
                   tt-inventario.nr-ficha        = ttCountingSheets.countingSheetNumber 
                   tt-inventario.situacao        = ttCountingSheets.situation
                   tt-inventario.val-apurado[1]  = IF ttCountingSheets.quantity = ? THEN -1 ELSE ttCountingSheets.quantity.
            
            
            RUN piRetornaData IN h-boin157q01 (INPUT ttCountingSheets.item ,
                                               OUTPUT l-habilita,
                                               OUTPUT d-return).

            ASSIGN tt-inventario.dt-ult-saida = d-return
                   tt-inventario.dt-ult-entra = IF l-habilita THEN ttCountingSheets.lotValidity ELSE ?.

            RUN emptyRowObject     IN h-boin157q01.
            RUN setRecord          IN h-boin157q01 (INPUT TABLE tt-inventario).

            RUN piInicializa       IN h-boin157q01  (OUTPUT TABLE RowErrors).
            
            /* Inicializa parÉmetros de estoque */
            run piValidaReferSaldo in h-boin157q01 (INPUT tt-inventario.it-codigo,
                                                    OUTPUT l-habilita).
            EMPTY TEMP-TABLE RowErrors NO-ERROR.
            RUN emptyRowErrors     in h-boin157q01.
            
            RUN createRecord       IN h-boin157q01.
            RUN getRowErrors       IN h-boin157q01 (OUTPUT TABLE RowErrors).
        END.

            
        IF NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            /* Atualiza saldo */
            RUN getRowid       in h-boin157q01 (output r-rowid-aux).
            RUN piCalculaSaldo in h-boin157q01 (input "CREATE":U, input r-rowid-aux).
            RUN getRowErrors   in h-boin157q01 (output table RowErrors).
        END.
        
        RUN setLocUnica IN h-boin157q01 (INPUT NO).

        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            UNDO CRIA, RETURN "NOK":U.
        END.

    END.
    DELETE PROCEDURE h-boin157q01.
    ASSIGN h-boin157q01 = ?.

END.

RETURN "OK":U.
  
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE analyseVariance DBOProgram 
PROCEDURE analyseVariance :
/*------------------------------------------------------------------------------ 
  Purpose: Retorna itens que tiveram variacao (quantidade/valor) no inventario
  Parameters:
  Notes:
------------------------------------------------------------------------------*/ 
   DEF INPUT  PARAM TABLE FOR ttInventoryCountParam .
   DEF INPUT  PARAM TABLE FOR ttVarianceParameter .
   DEF OUTPUT PARAM TABLE FOR ttVariance.
   DEF OUTPUT PARAM TABLE FOR ttInterval.


    def var l-saldo         as logical                                         no-undo.
    def var de-qcontabil    as decimal format "->>>>,>>9.9999"                 no-undo.
    def var de-vcontabil    as decimal format "->>>>>>>>>9.99"      decimals 2 no-undo.
    def var de-qapurado     like de-qcontabil                                  no-undo.
    def var de-vapurado     like de-vcontabil                                  no-undo.

    def var de-qtd-apu         like inventario.valor-final   no-undo.
    def var c-per-atu          like param-estoq.ult-per-fech no-undo.
    def var da-iniper-x-atu    as date format "99/99/9999"   no-undo.
    def var da-fimper-x-atu    as date format "99/99/9999"   no-undo.
    def var da-iniper-fech-atu as date format "99/99/9999"   no-undo.
    def var da-fimper-fech-atu as date format "99/99/9999"   no-undo.
    def var i-per-corrente-atu as integer                    no-undo.
    def var i-ano-corrente-atu as integer                    no-undo.
    DEFINE VARIABLE i-mo AS INTEGER     NO-UNDO.
    DEFINE VARIABLE p-descricao AS CHAR.
    DEFINE VAR log-foundEpc AS LOGICAL.

    FIND FIRST ttInventoryCountParam NO-LOCK NO-ERROR.
    FIND FIRST ttVarianceParameter   NO-LOCK NO-ERROR.
    
    
    
    DEFINE VARIABLE intervalo     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE lastIntervalo AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i             AS DECIMAL     NO-UNDO.
    
    ASSIGN intervalo = TRUNCATE(((ttVarianceParameter.finalVariance - ttVarianceParameter.initialVariance) / ttVarianceParameter.INTERVAL), 0).
    
    ASSIGN i = ttVarianceParameter.initialVariance.    
    
    DO WHILE(i < ttVarianceParameter.finalVariance):       
        ASSIGN lastIntervalo = i
               i = i + intervalo.

        IF (i > ttVarianceParameter.finalVariance) THEN DO:
            FIND LAST ttInterval EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL ttInterval THEN DO:
                ASSIGN ttInterval.finalInterval = ttVarianceParameter.finalVariance.
            END.
            LEAVE.
        END.
        
        CREATE ttInterval.
        ASSIGN ttInterval.initialInterval = lastIntervalo
               ttInterval.finalInterval = i
               ttInterval.quantity = 0.
    END.

    RUN findEpc(OUTPUT log-foundEpc).

    IF log-foundEpc THEN DO:
        /* Include i-epc200.i2: Criacao de registro para temp-table tt-epc */
        for each tt-epc where tt-epc.cod-event = "busca_es_inventario":
            delete tt-epc.
        end.

        IF ENTRY(1,ttVarianceParameter.variance,"|") = "es_inventario" THEN DO:

            ASSIGN p-descricao                   =  String(ENTRY(3,ttVarianceParameter.variance,"|"))
                   ttVarianceParameter.variance  = String(ENTRY(2,ttVarianceParameter.variance,"|")).

           {include/i-epc200.i2 &CodEvent='"busca_es_inventario"'
                                &CodParameter='"descricao"'
                                &ValueParameter="p-descricao"}
           /* Include i-epc201.i: Chamada do programa de EPC */
           {include/i-epc201.i "busca_es_inventario"}

        END.
    END.


    for each inventario no-lock
        where  inventario.dt-saldo     = ttInventoryCountParam.inventoryDate 
        and    inventario.cod-estabel >= ttInventoryCountParam.initialSite
        and    inventario.cod-estabel <= ttInventoryCountParam.finalSite
        and    inventario.it-codigo   >= ttInventoryCountParam.initialItem
        and    inventario.it-codigo   <= ttInventoryCountParam.finalItem         
        and    inventario.cod-depos   >= ttInventoryCountParam.initialWarehouse
        and    inventario.cod-depos   <= ttInventoryCountParam.finalWarehouse
        and    inventario.cod-localiz >= ttInventoryCountParam.initialBinLocation
        and    inventario.cod-localiz <= ttInventoryCountParam.finalBinLocation
        and    (   ( inventario.val-apurado[3] <> ?
                or (     inventario.val-apurado[3] = ?
                     and inventario.val-apurado[1] = inventario.val-apurado[2]
                     and inventario.situacao       = 4)
                or   inventario.situacao        = 3)
                or   inventario.situacao        = 1
                or ( inventario.val-apurado[1] <> ? and ttVarianceParameter.firstCounting) ),
        each item
           /* fields ( it-codigo fm-codigo ge-codigo 
                     loc-unica desc-item un tipo-con-est desc-item)   */
            where item.it-codigo  = inventario.it-codigo
            and   item.fm-codigo >= ttInventoryCountParam.initialFamily
            and   item.fm-codigo <= ttInventoryCountParam.finalFamily
            and   item.ge-codigo >= ttInventoryCountParam.initialInventoryGroup
            and   item.ge-codigo <= ttInventoryCountParam.finalInventoryGroup no-lock
        break by inventario.dt-saldo
              by inventario.cod-estabel
              by inventario.it-codigo
              by inventario.cod-depos
              by inventario.lote
              BY inventario.cod-refer:

    IF log-foundEpc AND p-descricao <> "" THEN DO:

        IF NOT CAN-FIND( FIRST tt-epc where tt-epc.cod-event = "busca_es_inventario"
            AND ENTRY(1,tt-epc.cod-parameter,",") = "retorna_es_inventario"
            AND ENTRY(1,tt-epc.val-parameter,",") = string(inventario.dt-saldo,"99/99/9999") 
            AND ENTRY(2,tt-epc.val-parameter,",") = inventario.cod-estabel
            AND ENTRY(3,tt-epc.val-parameter,",") = inventario.it-codigo  
            AND ENTRY(4,tt-epc.val-parameter,",") = inventario.cod-depos  
            AND ENTRY(5,tt-epc.val-parameter,",") = inventario.lote       
            AND ENTRY(6,tt-epc.val-parameter,",") = inventario.cod-refer) THEN DO:

            NEXT.
        end. 

    END.

    if  first-of(inventario.it-codigo) then do:
        assign de-vcontabil = 0
               de-vapurado  = 0
               de-qcontabil = 0
               de-qapurado  = 0.

        find item-estab
            where item-estab.cod-estabel = inventario.cod-estabel
            and   item-estab.it-codigo   = inventario.it-codigo
            no-lock no-error.
    end.

    /* RECALCULO DO SALDO DE ESTOQUE NA DATA DE CORTE DO INVENTARIO */
    run cep/ce0799.p (input rowid(inventario)).


    if first-of(inventario.lote) OR first-of(inventario.cod-refer) THEN 
        assign l-saldo = yes.
  

    /* Quantidade apurada */
    assign de-qtd-apu  = if ttVarianceParameter.firstCounting then inventario.val-apurado[1] else inventario.valor-final
           de-qapurado = de-qapurado + de-qtd-apu.
    

    find item-uni-estab
            where item-uni-estab.cod-estabel = inventario.cod-estabel
            and   item-uni-estab.it-codigo   = inventario.it-codigo
            no-lock no-error.
    
        if  inventario.dt-atualiza = ? then do:
            IF l-saldo OR item-uni-estab.loc-unica = NO then do:
    
                assign l-saldo = no.
                for each  saldo-estoq no-lock
                    where saldo-estoq.it-codigo   = inventario.it-codigo
                    and   saldo-estoq.cod-estabel = inventario.cod-estabel
                    and   saldo-estoq.cod-depos   = inventario.cod-depos
                    and   saldo-estoq.lote        = inventario.lote
                    AND saldo-estoq.cod-refer     = inventario.cod-refer:
        
                   IF (item-uni-estab.loc-unica = NO AND saldo-estoq.cod-localiz = inventario.cod-localiz) OR
                       item-uni-estab.loc-unica = YES THEN
                       assign de-qcontabil = de-qcontabil + saldo-estoq.qtidade-atu.
                end.
                IF  item.tipo-con-est = 1 THEN DO:
    
                    for each  movto-estoq no-lock
                        where movto-estoq.it-codigo   = inventario.it-codigo
                        AND   movto-estoq.cod-refer   = inventario.cod-refer
                        and   movto-estoq.cod-estabel = inventario.cod-estabel
                        and   movto-estoq.cod-depos   = inventario.cod-depos
                        and   movto-estoq.lote        = inventario.lote
                        and   movto-estoq.dt-trans    > ttInventoryCountParam.inventoryDate:
                        IF (item-uni-estab.loc-unica = NO AND movto-estoq.cod-localiz = inventario.cod-localiz) or
                            item-uni-estab.loc-unica = YES THEN
                            assign de-qcontabil = de-qcontabil
                                                + if movto-estoq.tipo-trans = 1
                                                     then - movto-estoq.quantidade
                                                     else   movto-estoq.quantidade.
                    end.
                END.
                ELSE DO:
                    for each  movto-estoq no-lock
                        where movto-estoq.it-codigo   = inventario.it-codigo
                        AND movto-estoq.cod-refer     = inventario.cod-refer
                        and   movto-estoq.cod-estabel = inventario.cod-estabel
                        and   movto-estoq.cod-depos   = inventario.cod-depos
                        and   movto-estoq.lote        = inventario.lote
                        and   movto-estoq.dt-trans    > ttInventoryCountParam.inventoryDate:
                        IF (item-uni-estab.loc-unica = NO AND movto-estoq.cod-localiz = inventario.cod-localiz) or
                            item-uni-estab.loc-unica = YES THEN
                            assign de-qcontabil = de-qcontabil
                                                + if movto-estoq.tipo-trans = 1
                                                     then - movto-estoq.quantidade
                                                     else   movto-estoq.quantidade.
                    end.
                END.
            END.
        END.
        ELSE DO:
            assign de-qcontabil = de-qcontabil + inventario.qtidade-atu.
        END.

        if inventario.dt-atualiza <> ? then do:
            assign c-per-atu =  String(year(inventario.dt-atualiza),"9999") + 
                                String(month(inventario.dt-atualiza),"99").
            run cdp/cdapi005.p (input c-per-atu ,
                                output da-iniper-x-atu,
                                output da-fimper-x-atu,
                                output i-per-corrente-atu,
                                output i-ano-corrente-atu,
                                output da-iniper-fech-atu,
                                output da-fimper-fech-atu).    
           find pr-it-per 
                where pr-it-per.it-codigo   = inventario.it-codigo
                  and pr-it-per.cod-estabel = inventario.cod-estabel
                  and pr-it-per.periodo     = da-fimper-fech-atu no-lock no-error.
           if not avail pr-it-per then 
              assign da-fimper-fech-atu = ?.
        end.
        else 
           assign da-fimper-fech-atu = ?.


        if  avail item-estab then do:
            assign i-mo = ttVarianceParameter.currency + 1.
            case ttVarianceParameter.costType:
                when 1 then do:
                    if da-fimper-fech-atu <> ? then do:
                       {inbo/boin157fx.i1 "pr-it-per" "m"}
                    end.   
                    else do:
                       {inbo/boin157fx.i1 "item-estab" "m"}
                    end.   
                end.
                when 2 then do:        
                    if da-fimper-fech-atu <> ? then do:
                       {inbo/boin157fx.i1 "pr-it-per" "o"}
                    end.   
                    else do:
                       {inbo/boin157fx.i1 "item-estab" "o"}
                    end.   
                end.
            end case.
        end.
       
       IF LAST-OF(inventario.it-codigo) THEN DO:
           
           IF (ttVarianceParameter.variance = "1":U) THEN DO:
               IF NOT ttVarianceParameter.largerThanFinalVariance 
                   AND TRUNCATE(((de-qapurado - de-qcontabil) * 100 / IF de-qcontabil <> 0 THEN de-qcontabil ELSE 1),0) > ttVarianceParameter.finalVariance THEN NEXT.
               IF NOT ttVarianceParameter.smallerThanZero 
                   AND TRUNCATE(((de-qapurado - de-qcontabil) * 100 / IF de-qcontabil <> 0 THEN de-qcontabil ELSE 1),0) < 0 THEN NEXT.
           END.
           ELSE DO:
               IF NOT ttVarianceParameter.largerThanFinalVariance 
                   AND TRUNCATE(((de-vapurado - de-vcontabil) * 100 / IF de-vcontabil <> 0 THEN de-vcontabil ELSE 1),0) > ttVarianceParameter.finalVariance THEN NEXT.
               IF NOT ttVarianceParameter.smallerThanZero 
                   AND TRUNCATE(((de-vapurado - de-vcontabil) * 100 / IF de-vcontabil <> 0 THEN de-vcontabil ELSE 1),0) < 0 THEN NEXT.
           END.

           CREATE ttVariance.
           ASSIGN ttVariance.site = inventario.cod-estabel
                  ttVariance.ITEM = inventario.it-codigo
                  ttVariance.itemDescription = ITEM.desc-item
                  ttVariance.unitOfMeasure = ITEM.un
                  ttVariance.countedQuantity = de-qapurado
                  ttVariance.countedValue = de-vapurado
                  ttVariance.accountingQuantity = de-qcontabil
                  ttVariance.accountingValue = de-vcontabil.
           
           IF (ttVarianceParameter.variance = "1":U) THEN DO:
               {inbo/boin157fx.i "countedQuantity" "accountingQuantity"}
           END.
           ELSE DO:
               {inbo/boin157fx.i "countedValue" "accountingValue"}
           END.
       END.
    END.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteInventoryCountRecord DBOProgram 
PROCEDURE deleteInventoryCountRecord :
/*------------------------------------------------------------------------------ 
  Purpose:    Executa o programa ce0707rp para eliminar fichas do inventario
  Parameters:                                       
  Notes:                                                                         
------------------------------------------------------------------------------*/ 
    define INPUT  parameter table for ttRelatedActionsParameter.
    define OUTPUT parameter table for ttStringReturn.
    define output parameter table for RowErrors.

    DEFINE VARIABLE cPedidoNum AS CHARACTER   NO-UNDO.

    empty temp-table ttStringReturn.
    
    for first ttRelatedActionsParameter no-lock:
    
        create tt-paramDeleteInventory.
        assign tt-paramDeleteInventory.usuario       = v_cod_usuar_corren
               tt-paramDeleteInventory.destino       = 2
               tt-paramDeleteInventory.data-exec     = today
               tt-paramDeleteInventory.hora-exec     = time
               tt-paramDeleteInventory.arquivo       = "CE0707FX.LST"
               tt-paramDeleteInventory.classifica    = 1
               tt-paramDeleteInventory.it-codigo-i   = ttRelatedActionsParameter.initialItem
               tt-paramDeleteInventory.it-codigo-f   = ttRelatedActionsParameter.finalItem
               tt-paramDeleteInventory.nr-ficha-i    = ttRelatedActionsParameter.initialSheet
               tt-paramDeleteInventory.nr-ficha-f    = ttRelatedActionsParameter.finalSheet
               tt-paramDeleteInventory.cod-estabel-i = ttRelatedActionsParameter.initialSite
               tt-paramDeleteInventory.cod-estabel-f = ttRelatedActionsParameter.finalSite
               tt-paramDeleteInventory.cod-depos-i   = ttRelatedActionsParameter.initialWarehouse
               tt-paramDeleteInventory.cod-depos-f   = ttRelatedActionsParameter.finalWarehouse
               tt-paramDeleteInventory.dt-saldo-i    = ttRelatedActionsParameter.initialBalDateForInvCount
               tt-paramDeleteInventory.dt-saldo-f    = ttRelatedActionsParameter.finalBalDateForInvCount
               tt-paramDeleteInventory.rs-par-invent = ttRelatedActionsParameter.movementType
            .
        
        raw-transfer tt-paramDeleteInventory to raw-param.
        
        for each tt-raw-digita:
            delete tt-raw-digita.
        end.

        run inbo/boin157fxrpw.p (input raw-param,
                                 input table tt-raw-digita,
                                 input tt-paramDeleteInventory.arquivo,
                                 input 'CE0707':U,
                                 input 0707,
                                 input 'cep/ce0707rp.p':U,
                                 output cPedidoNum,
                                 output table RowErrors).

        create ttStringReturn.
        assign ttStringReturn.stringValue = cPedidoNum.

    end.
    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GenerateCountingSheets DBOProgram 
PROCEDURE GenerateCountingSheets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM TABLE FOR ttRelatedActionsParameter.
    def input  param table for ttDigitaItem.
    define OUTPUT parameter table for ttStringReturn.
    DEF OUTPUT PARAM TABLE FOR RowErrors.


    DEFINE VARIABLE cPedidoNum AS CHARACTER   NO-UNDO.

    empty temp-table ttStringReturn.

    FOR FIRST ttRelatedActionsParameter NO-LOCK:

        create tt-paramGenerateCountingSheets.
        assign tt-paramGenerateCountingSheets.usuario             = v_cod_usuar_corren
               tt-paramGenerateCountingSheets.destino             = 2
               tt-paramGenerateCountingSheets.data-exec           = today
               tt-paramGenerateCountingSheets.hora-exec           = time
               tt-paramGenerateCountingSheets.item-ini            = ttRelatedActionsParameter.initialItem
               tt-paramGenerateCountingSheets.item-fim            = ttRelatedActionsParameter.finalItem
               tt-paramGenerateCountingSheets.ge-ini              = ttRelatedActionsParameter.initialInventoryGroup
               tt-paramGenerateCountingSheets.ge-fim              = ttRelatedActionsParameter.finalInventoryGroup
               tt-paramGenerateCountingSheets.familia-ini         = ttRelatedActionsParameter.initialFamily
               tt-paramGenerateCountingSheets.familia-fim         = ttRelatedActionsParameter.finalFamily
               tt-paramGenerateCountingSheets.lote-ini            = ttRelatedActionsParameter.initialLot
               tt-paramGenerateCountingSheets.lote-fim            = ttRelatedActionsParameter.finalLot
               tt-paramGenerateCountingSheets.refer-ini           = ttRelatedActionsParameter.initialReference
               tt-paramGenerateCountingSheets.refer-fim           = ttRelatedActionsParameter.finalReference        
               tt-paramGenerateCountingSheets.localizacao-ini     = ttRelatedActionsParameter.initialBinLocation
               tt-paramGenerateCountingSheets.localizacao-fim     = ttRelatedActionsParameter.finalBinLocation
               tt-paramGenerateCountingSheets.depos-ini           = ttRelatedActionsParameter.initialWarehouse
               tt-paramGenerateCountingSheets.depos-fim           = ttRelatedActionsParameter.finalWarehouse
               tt-paramGenerateCountingSheets.estab-ini           = ttRelatedActionsParameter.initialSite
               tt-paramGenerateCountingSheets.estab-fim           = ttRelatedActionsParameter.finalSite
               tt-paramGenerateCountingSheets.zera-variac         = ttRelatedActionsParameter.zeroAccumVariance
               tt-paramGenerateCountingSheets.ciclo-cont          = ttRelatedActionsParameter.includeCountingCycle
               tt-paramGenerateCountingSheets.saldo-zero          = ttRelatedActionsParameter.itemsWithZeroBalance
               tt-paramGenerateCountingSheets.sem-saldo           = ttRelatedActionsParameter.itemsWithoutBalance
               tt-paramGenerateCountingSheets.consignado          = ttRelatedActionsParameter.consignedItems
               tt-paramGenerateCountingSheets.obsoleto            = ttRelatedActionsParameter.obsolescenceCode
               tt-paramGenerateCountingSheets.data-movto-ini      = ttRelatedActionsParameter.initialTransBetween
               tt-paramGenerateCountingSheets.data-movto-fim      = ttRelatedActionsParameter.finalTransBetween
               tt-paramGenerateCountingSheets.data-corte          = ttRelatedActionsParameter.inventoryDate
               tt-paramGenerateCountingSheets.data-ultima-entrada = ttRelatedActionsParameter.lastReceiptDate
               tt-paramGenerateCountingSheets.data-ultima-saida   = ttRelatedActionsParameter.lastIssueDate
               tt-paramGenerateCountingSheets.preco               = ttRelatedActionsParameter.priceType
               tt-paramGenerateCountingSheets.valor               = ttRelatedActionsParameter.amountToCount
               tt-paramGenerateCountingSheets.arquivo             = "CE0701FX.LST"
               tt-paramGenerateCountingSheets.epcValue            = ttRelatedActionsParameter.epcValue.

        RAW-TRANSFER tt-paramGenerateCountingSheets TO raw-param.
        
        FOR EACH tt-raw-digita:
            DELETE tt-raw-digita.
        END.
        FOR EACH ttDigitaItem:
            CREATE tt-raw-digita.
            RAW-TRANSFER ttDigitaItem to tt-raw-digita.raw-digita.
        END.

        RUN inbo/boin157fxrpw.p (INPUT raw-param,
                                 INPUT TABLE tt-raw-digita,
                                 INPUT tt-paramGenerateCountingSheets.arquivo,
                                 INPUT 'CE0701':U,
                                 INPUT 0701,
                                 INPUT 'cep/ce0701rp.p':U,
                                 OUTPUT cPedidoNum,
                                 OUTPUT TABLE RowErrors).
        
        create ttStringReturn.
        assign ttStringReturn.stringValue = cPedidoNum.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCounting DBOProgram 
PROCEDURE getCounting :
/*------------------------------------------------------------------------------ 
  Purpose:     Retorna fichas de contagem e os valores apurados nas Contagem 1,
               Contagem 2 e Contagem 3
  Parameters:
  Notes:
------------------------------------------------------------------------------*/ 
    DEF INPUT  PARAM TABLE FOR ttInventoryCountParam .
    DEF INPUT  PARAM TABLE FOR ttCountingParameter .
    DEF OUTPUT PARAM TABLE FOR ttCounting.
    DEF OUTPUT PARAM TABLE FOR ttTotals.

    define buffer bfTotals for ttTotals.

    DEFINE VARIABLE lOk AS LOGICAL     NO-UNDO.

    FOR FIRST ttInventoryCountParam NO-LOCK:
    END.

    FOR FIRST ttCountingParameter NO-LOCK:
    END.

    FOR FIRST param-estoq NO-LOCK:
    END.

    EMPTY TEMP-TABLE ttCounting.
    EMPTY TEMP-TABLE ttTotals.

    {utp/ut-liter.i Todos}
    CREATE ttTotals.
    ASSIGN ttTotals.situationId = 0
           ttTotals.situation = RETURN-VALUE
           ttTotals.quantity = 0.
    
    {utp/ut-liter.i Contagem_1}
    CREATE ttTotals.
    ASSIGN ttTotals.situationId = 1
           ttTotals.situation = RETURN-VALUE
           ttTotals.quantity = 0.
        
    {utp/ut-liter.i Contagem_2}
    CREATE ttTotals.
    ASSIGN ttTotals.situationId = 2
           ttTotals.situation = RETURN-VALUE
           ttTotals.quantity = 0.    
    
    {utp/ut-liter.i Contagem_3}
    CREATE ttTotals.
    ASSIGN ttTotals.situationId = 3
           ttTotals.situation = RETURN-VALUE
           ttTotals.quantity = 0.


    FOR EACH inventario 
        FIELDS ( val-apurado[1] val-apurado[2] val-apurado[3] cod-localiz
                 it-codigo      situacao       nr-ficha       cod-estabel 
                 cod-depos      cod-refer      lote           qtidade-atu )
        WHERE inventario.dt-saldo     = ttInventoryCountParam.inventoryDate       
        AND   inventario.cod-estabel   >= ttInventoryCountParam.initialSite
        AND   inventario.cod-estabel   <= ttInventoryCountParam.finalSite
        AND   inventario.cod-depos   >= ttInventoryCountParam.initialWarehouse
        AND   inventario.cod-depos   <= ttInventoryCountParam.finalWarehouse
        AND   inventario.cod-localiz >= ttInventoryCountParam.initialBinLocation
        AND   inventario.cod-localiz <= ttInventoryCountParam.finalBinLocation
        AND   inventario.it-codigo   >= ttInventoryCountParam.initialItem
        AND   inventario.it-codigo   <= ttInventoryCountParam.finalItem
        AND  (ttCountingParameter.noBalance
        OR   (NOT ttCountingParameter.noBalance AND inventario.qtidade-atu <> 0)) NO-LOCK
            BREAK BY inventario.it-codigo
                  BY inventario.cod-estabel
                  BY inventario.cod-depos
                  BY inventario.cod-localiz 
                  BY inventario.nr-ficha ON STOP UNDO, LEAVE:
        IF  NOT AVAIL ITEM
        OR (    AVAIL ITEM 
            AND ITEM.it-codigo <> inventario.it-codigo) THEN
            FOR FIRST ITEM
                FIELDS (fm-codigo ge-codigo it-codigo desc-item un)
                WHERE ITEM.it-codigo = inventario.it-codigo NO-LOCK:
            END.

        IF ITEM.fm-codigo < ttInventoryCountParam.initialFamily
        OR ITEM.fm-codigo > ttInventoryCountParam.finalFamily THEN NEXT.

        IF ITEM.ge-codigo < ttInventoryCountParam.initialInventoryGroup
        OR ITEM.ge-codigo > ttInventoryCountParam.finalInventoryGroup THEN NEXT.

        /* RECALCULO DOS SALDOS NA DATA DE CORTE DO INVENTARIO */
        RUN cep/ce0799.p (INPUT ROWID(inventario)).

        assign lOk = false.
        IF  ttCountingParameter.itemType = 1 THEN DO:
            IF   val-apurado[3] <> ?

            OR  (val-apurado[2] <> ? and (val-apurado[2]  = val-apurado[1] OR  (val-apurado[2]  = qtidade-atu and param-estoq.cons-invent = 1) ))

            OR  (val-apurado[1] <> ? and  val-apurado[1]  = qtidade-atu AND  param-estoq.cons-invent = 1)

            OR  (val-apurado[3]  = ? and  val-apurado[2] <> ? and  NOT ttCountingParameter.counting3)

            OR  (val-apurado[2]  = ? and  val-apurado[1] <> ? and  NOT ttCountingParameter.counting2)

            OR  (val-apurado[1]  = ? and  NOT ttCountingParameter.counting1) then next.
        END.
        else do:
            if  val-apurado[3] <> ? then
                assign lOk = true.
            else
            if  val-apurado[2] <> ? then do:
                if  val-apurado[2] = val-apurado[1]
                    or (val-apurado[2] = qtidade-atu
                    and param-estoq.cons-invent = 1) then do:
                    assign lOk = true.
                end.
            end.
            else
            if  val-apurado[1] <> ? then do:
                if (val-apurado[1] = qtidade-atu
                    and param-estoq.cons-invent = 1) then do:
                    assign lOk = true.
                end.
            end.
        end.
        
        CREATE ttCounting.
        ASSIGN ttCounting.warehouse = inventario.cod-depos
               ttCounting.site = inventario.cod-estabel
               ttCounting.location = inventario.cod-localiz
               ttCounting.reference = inventario.cod-refer
               ttCounting.ITEM = ITEM.it-codigo
               ttCounting.lot = inventario.lote
               ttCounting.sheet = inventario.nr-ficha
               ttCounting.accountingBalance = inventario.qtidade-atu
               ttCounting.situation = inventario.situacao
               ttCounting.situationDescription = {ininc/i01in157.i 04 inventario.situacao}
               ttCounting.counting1 = STRING(inventario.val-apurado[1])
               ttCounting.counting2 = STRING(inventario.val-apurado[2])
               ttCounting.counting3 = STRING(inventario.val-apurado[3])
               ttCounting.itemDescription = ITEM.desc-item
               ttCounting.unitOfMeasure = ITEM.un
               ttCounting.ROWID = STRING(ROWID(inventario))
               ttCounting.countingDate = if inventario.dt-atualiza <> ? then inventario.dt-saldo else ? /*inventario.dt-atualiza*/
               ttCounting.pendingSituation = if lOk then 1 else 0.
        
        IF  ttCountingParameter.itemType = 1 THEN do:    

            IF inventario.val-apurado[2] <> ? THEN DO:
                FOR FIRST ttTotals
                    WHERE ttTotals.situationId = 3 EXCLUSIVE-LOCK:
                    ASSIGN ttTotals.quantity = ttTotals.quantity + 1.
                    FOR FIRST bfTotals
                        WHERE bfTotals.situationId = 0 EXCLUSIVE-LOCK:
                        ASSIGN bfTotals.quantity = bfTotals.quantity + 1.
                    END.
                end.
            END.
            else IF inventario.val-apurado[1] <> ? THEN DO:
                FOR FIRST ttTotals
                    WHERE ttTotals.situationId = 2 EXCLUSIVE-LOCK:
                    ASSIGN ttTotals.quantity = ttTotals.quantity + 1.
                    FOR FIRST bfTotals
                        WHERE bfTotals.situationId = 0 EXCLUSIVE-LOCK:
                        ASSIGN bfTotals.quantity = bfTotals.quantity + 1.
                    END.
                end.
            END.
            else IF inventario.val-apurado[1] = ? THEN DO:
                FOR FIRST ttTotals
                    WHERE ttTotals.situationId = 1 EXCLUSIVE-LOCK:
                    ASSIGN ttTotals.quantity = ttTotals.quantity + 1.
                    FOR FIRST bfTotals
                        WHERE bfTotals.situationId = 0 EXCLUSIVE-LOCK:
                        ASSIGN bfTotals.quantity = bfTotals.quantity + 1.
                    END.
                END.
            END.

        end.
        else do:
            IF inventario.val-apurado[1] <> ? THEN DO:
                FOR FIRST ttTotals
                    WHERE ttTotals.situationId = 1 EXCLUSIVE-LOCK:
                    ASSIGN ttTotals.quantity = ttTotals.quantity + 1.
                    FOR FIRST bfTotals
                        WHERE bfTotals.situationId = 0 EXCLUSIVE-LOCK:
                        ASSIGN bfTotals.quantity = bfTotals.quantity + 1.
                    END.
                end.
            END.
            IF inventario.val-apurado[2] <> ? THEN DO:
                FOR FIRST ttTotals
                    WHERE ttTotals.situationId = 2 EXCLUSIVE-LOCK:
                    ASSIGN ttTotals.quantity = ttTotals.quantity + 1.
                    FOR FIRST bfTotals
                        WHERE bfTotals.situationId = 0 EXCLUSIVE-LOCK:
                        ASSIGN bfTotals.quantity = bfTotals.quantity + 1.
                    END.            
                end.
            END.
            IF inventario.val-apurado[3] <> ? THEN DO:
                FOR FIRST ttTotals
                    WHERE ttTotals.situationId = 3 EXCLUSIVE-LOCK:
                    ASSIGN ttTotals.quantity = ttTotals.quantity + 1.
                    FOR FIRST bfTotals
                        WHERE bfTotals.situationId = 0 EXCLUSIVE-LOCK:
                        ASSIGN bfTotals.quantity = bfTotals.quantity + 1.
                    END.
                END.
            END.
        end.

        /*for last movto-estoq USE-INDEX item-data 
            WHERE movto-estoq.it-codigo  = inventario.it-codigo
            AND movto-estoq.cod-estabel  = inventario.cod-estabel
            AND movto-estoq.dt-trans     = inventario.dt-atualiz
            AND movto-estoq.cod-depos    = inventario.cod-depos
            AND movto-estoq.lote         = inventario.lote
            AND movto-estoq.cod-refer    = inventario.cod-refer
            AND (movto-estoq.cod-localiz = inventario.cod-localiz 
                 OR item-uni-estab.loc-unica = YES)
            AND movto-estoq.esp-docto    = 15 no-lock:

            assign ttCounting.countingDate = movto-estoq.dt-trans.

        end.*/

    END.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCountingSheets DBOProgram 
PROCEDURE getCountingSheets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pInventoryDate AS DATE NO-UNDO.
DEF INPUT PARAM pCountingNumber AS INTEGER NO-UNDO.
DEF INPUT PARAM TABLE FOR ttCountingSheetsParam.
DEF OUTPUT PARAM TABLE FOR ttCountingSheets.
DEF OUTPUT PARAM TABLE FOR RowErrors.
    
    FIND FIRST ttCountingSheetsParam NO-LOCK NO-ERROR.
        
    FOR EACH inventario 
        FIELDS ( val-apurado[1] val-apurado[2] val-apurado[3] cod-localiz
                 it-codigo      situacao       nr-ficha       cod-estabel 
                 cod-depos      cod-refer      lote           qtidade-atu
                 dt-ult-entra     dt-saldo )
        WHERE inventario.dt-saldo     = pInventoryDate       
        AND   inventario.cod-estabel   >= ttCountingSheetsParam.initialSite
        AND   inventario.cod-estabel   <= ttCountingSheetsParam.finalSite
        AND   inventario.cod-depos   >= ttCountingSheetsParam.initialWarehouse
        AND   inventario.cod-depos   <= ttCountingSheetsParam.finalWarehouse
        AND   inventario.cod-localiz >= ttCountingSheetsParam.initialBinLocation
        AND   inventario.cod-localiz <= ttCountingSheetsParam.finalBinLocation
        AND   inventario.it-codigo   >= ttCountingSheetsParam.initialItem
        AND   inventario.it-codigo   <= ttCountingSheetsParam.finalItem
        AND   inventario.lote        >= ttCountingSheetsParam.initialLotSeries
        AND   inventario.lote        <= ttCountingSheetsParam.finalLotSeries
        AND   inventario.cod-refer   >= ttCountingSheetsParam.initialReference
        AND   inventario.cod-refer   <= ttCountingSheetsParam.finalReference
        AND   (inventario.situacao = 2 OR inventario.situacao = 3 OR inventario.situacao = 4)
        NO-LOCK
        BREAK BY inventario.it-codigo
              BY inventario.cod-estabel
              BY inventario.cod-depos
              BY inventario.cod-localiz 
              BY inventario.nr-ficha ON STOP UNDO, LEAVE :
        
        IF  NOT AVAIL ITEM
        OR (    AVAIL ITEM 
            AND ITEM.it-codigo <> inventario.it-codigo) THEN
            FOR FIRST ITEM
                FIELDS (fm-codigo ge-codigo it-codigo desc-item un)
                WHERE ITEM.it-codigo = inventario.it-codigo NO-LOCK:
        END.
            
        IF ITEM.fm-codigo < ttCountingSheetsParam.initialFamily
        OR ITEM.fm-codigo > ttCountingSheetsParam.finalFamily THEN NEXT.

        IF ITEM.ge-codigo < ttCountingSheetsParam.initialInventoryGroup
        OR ITEM.ge-codigo > ttCountingSheetsParam.finalInventoryGroup THEN NEXT.

        /*IF pCountingNumber = 1 AND inventario.val-apurado[1] = ? THEN NEXT.
        ELSE IF pCountingNumber = 2 AND inventario.val-apurado[2] = ? THEN NEXT.
        ELSE IF pCountingNumber = 3 AND inventario.val-apurado[3] = ? THEN NEXT.*/

        CREATE ttCountingSheets.
            ASSIGN ttCountingSheets.warehouse          = inventario.cod-depos
                ttCountingSheets.site                  = inventario.cod-estabel
                ttCountingSheets.item                  = inventario.it-codigo
                ttCountingSheets.binLocation           = inventario.cod-localiz
                ttCountingSheets.lot                   = inventario.lote
                ttCountingSheets.reference             = inventario.cod-refer
                ttCountingSheets.situation             = inventario.situacao
                ttCountingSheets.countingSheetNumber   = inventario.nr-ficha
                ttCountingSheets.situationDescription  = {ininc/i01in157.i 04 inventario.situacao}
                ttCountingSheets.lotValidity           = inventario.dt-ult-entra
                ttCountingSheets.itemDescription       = ITEM.desc-item
                ttCountingSheets.inventoryDate         = inventario.dt-saldo 
                ttCountingSheets.unitOfMeasure         = ITEM.un
                ttCountingSheets.quantity              = IF inventario.val-apurado[pCountingNumber] = ? THEN -1 ELSE inventario.val-apurado[pCountingNumber].
            
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCountingSheetsStatus DBOProgram 
PROCEDURE getCountingSheetsStatus :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------ 
  Purpose:     Retorna dados para a formacao do gr†fico do portlet e do painel
               Posicao Inventario
  Parameters:                                       
  Notes:      
------------------------------------------------------------------------------*/ 
DEF INPUT PARAM pInventoryDate AS DATE.
DEF INPUT PARAM TABLE FOR ttCountingSheetsParam.
DEF OUTPUT PARAM TABLE FOR ttTotals.
DEF OUTPUT PARAM TABLE FOR RowErrors.

    find first ttCountingSheetsParam no-error.
    if  not avail ttCountingSheetsParam THEN 
        return "NOK":U.

    /*Para evitar o erro 1457 - Illegal operator for unknown value or zero-length character string.
      O Erro acontece somente em Oracle. 
      Somente ocorre quando utilizado em uma query (For each, find, etc) um campo com ? e somente quando utilizado ">", "<" ou "<=" 
      No entanto, ao usar ">=" em uma variavel ? o Oracle nao entende como campo "", entao tem que forcar o valor.*/
    IF ttCountingSheetsParam.initialSite        = ? THEN ttCountingSheetsParam.initialSite        = "".
    IF ttCountingSheetsParam.finalSite          = ? THEN ttCountingSheetsParam.finalSite          = "".
    IF ttCountingSheetsParam.initialWarehouse   = ? THEN ttCountingSheetsParam.initialWarehouse   = "".
    IF ttCountingSheetsParam.finalWarehouse     = ? THEN ttCountingSheetsParam.finalWarehouse     = "".
    IF ttCountingSheetsParam.initialBinLocation = ? THEN ttCountingSheetsParam.initialBinLocation = "".
    IF ttCountingSheetsParam.finalBinLocation   = ? THEN ttCountingSheetsParam.finalBinLocation   = "".
    IF ttCountingSheetsParam.initialItem        = ? THEN ttCountingSheetsParam.initialItem        = "".
    IF ttCountingSheetsParam.finalItem          = ? THEN ttCountingSheetsParam.finalItem          = "".
    IF ttCountingSheetsParam.initialLotSeries   = ? THEN ttCountingSheetsParam.initialLotSeries   = "".
    IF ttCountingSheetsParam.finalLotSeries     = ? THEN ttCountingSheetsParam.finalLotSeries     = "".
    IF ttCountingSheetsParam.initialReference   = ? THEN ttCountingSheetsParam.initialReference   = "".
    IF ttCountingSheetsParam.finalReference     = ? THEN ttCountingSheetsParam.finalReference     = "".



    for each  inventario fields (situacao it-codigo)
        where inventario.dt-saldo     = pInventoryDate     
        and   inventario.cod-estabel >= ttCountingSheetsParam.initialSite       
        and   inventario.cod-estabel <= ttCountingSheetsParam.finalSite         
        and   inventario.cod-depos   >= ttCountingSheetsParam.initialWarehouse  
        and   inventario.cod-depos   <= ttCountingSheetsParam.finalWarehouse    
        and   inventario.cod-localiz >= ttCountingSheetsParam.initialBinLocation
        and   inventario.cod-localiz <= ttCountingSheetsParam.finalBinLocation
        and   inventario.it-codigo   >= ttCountingSheetsParam.initialItem       
        and   inventario.it-codigo   <= ttCountingSheetsParam.finalItem
        AND   inventario.lote        >= ttCountingSheetsParam.initialLotSeries
        AND   inventario.lote        <= ttCountingSheetsParam.finalLotSeries
        AND   inventario.cod-refer   >= ttCountingSheetsParam.initialReference
        AND   inventario.cod-refer   <= ttCountingSheetsParam.finalReference
        AND   (inventario.situacao = 2 OR inventario.situacao = 3 OR inventario.situacao = 4)
        no-lock:
        
        if  not avail item
            or (    avail item
                    and item.it-codigo <> inventario.it-codigo) then
            for first item fields (fm-codigo ge-codigo it-codigo)
            where item.it-codigo = inventario.it-codigo no-lock: end.
                
        if  not avail item then
            next.
            
        if  item.fm-codigo < ttCountingSheetsParam.initialFamily
        or  item.fm-codigo > ttCountingSheetsParam.finalFamily then 
            next.

        if  item.ge-codigo < ttCountingSheetsParam.initialInventoryGroup
        or  item.ge-codigo > ttCountingSheetsParam.finalInventoryGroup then 
            next.
            
        find ttTotals
            where ttTotals.situationId = inventario.situacao no-error.
        if  not avail ttTotals then do:

            create ttTotals.
            assign ttTotals.situationId = inventario.situacao
                   ttTotals.situation   = {ininc/i01in157.i 04 inventario.situacao}.
        END.
            
        assign ttTotals.quantity = ttTotals.quantity + 1.
    
    END.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDefaultsParamMD DBOProgram 
PROCEDURE getDefaultsParamMD:
	DEF OUTPUT PARAM TABLE FOR ttParamMD.
	
	CREATE ttParamMD.
	ASSIGN ttParamMD.itCodigoIni         = ""
	       ttParamMD.itCodigoFim         = "ZZZZZZZZZZZZZZZZ"
	       ttParamMD.fmCodigoIni         = ""
	       ttParamMD.fmCodigoFim         = "ZZZZZZZZ"
	       ttParamMD.geCodigoIni         = 0
	       ttParamMD.geCodigoFim         = 99
	       ttParamMD.codLocalizIni       = ""
	       ttParamMD.codLocalizFim       = "ZZZZZZZZZZ"
	       ttParamMD.codDeposIni         = ""
	       ttParamMD.codDeposFim         = "ZZZ"
	       ttParamMD.codEstabelIni       = ""
	       ttParamMD.codEstabelFim       = "ZZZZZ"
	       ttParamMD.nrFichaIni          = 0
	       ttParamMD.nrFichaFim          = 9999999
	       ttParamMD.codConfteContagIni  = ""
	       ttParamMD.codConfteContagFim  = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
	       ttParamMD.loteIni             = ""
	       ttParamMD.loteFim             = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ".

	find first param-estoq no-lock no-error.
        if  avail param-estoq then
            assign ttParamMD.codEstabelIni = param-estoq.estabel-pad
				   ttParamMD.codEstabelFim = param-estoq.estabel-pad.

    find last bfinventario no-lock no-error.
	if  avail bfinventario then 
		assign ttParamMD.dtSaldo = bfinventario.dt-saldo.
	else
		assign ttParamMD.dtSaldo = TODAY.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDefaultsParam DBOProgram 
PROCEDURE getDefaultsParam :
/*------------------------------------------------------------------------------ 
  Purpose:     Determina valores defaults para a tela de configuracoes do Portlet 
               e da Tela Monitar Inventario
  Parameters:                                       
  Notes:      
------------------------------------------------------------------------------*/ 
    DEF OUTPUT PARAM TABLE FOR ttInventoryCountParam.

    create ttInventoryCountParam.
    assign ttInventoryCountParam.initialSite           = ""
           ttInventoryCountParam.finalSite             = "ZZZZZ"
           ttInventoryCountParam.initialWarehouse      = ""
           ttInventoryCountParam.finalWarehouse        = "ZZZ"
           ttInventoryCountParam.initialBinLocation    = ""
           ttInventoryCountParam.finalBinLocation      = "ZZZZZZZZZZ"
           ttInventoryCountParam.initialItem           = ""
           ttInventoryCountParam.finalItem             = "ZZZZZZZZZZZZZZZZ"
           ttInventoryCountParam.initialFamily         = ""
           ttInventoryCountParam.finalFamily           = "ZZZZZZZZ"
           ttInventoryCountParam.initialInventoryGroup = 0
           ttInventoryCountParam.finalInventoryGroup   = 99.


    find last bfinventario no-lock no-error.
    if  avail bfinventario then 
        assign ttInventoryCountParam.inventoryDate = bfinventario.dt-saldo.
    else
        assign ttInventoryCountParam.inventoryDate = today.
    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDefaultsRelatedAction DBOProgram 
PROCEDURE getDefaultsRelatedAction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM TABLE FOR ttRelatedActionsParameter.

    /*create ttRelatedActionsParameter.
    assign ttRelatedActionsParameter.initialItem           = "samoel"
           ttRelatedActionsParameter.finalItem             = "ZZZZZZZZZZZZZZZZ"
           ttRelatedActionsParameter.initialSite           = "tu"
           ttRelatedActionsParameter.finalSite             = "ZZZZZ"
           ttRelatedActionsParameter.initialWarehouse      = ""
           ttRelatedActionsParameter.finalWarehouse        = "ZZZda"
           ttRelatedActionsParameter.initialBinLocation    = ""
           ttRelatedActionsParameter.finalBinLocation      = "ZZZZZZrtwZZZZ"
           ttRelatedActionsParameter.initialItem           = ""
           ttRelatedActionsParameter.finalItem             = "dddd"
           ttRelatedActionsParameter.initialFamily         = "aaa"
           ttRelatedActionsParameter.finalFamily           = "ZZZZZZZZ"
           ttRelatedActionsParameter.initialInventoryGroup = 0
           ttRelatedActionsParameter.finalInventoryGroup   = 99
           ttRelatedActionsParameter.initialSheet          = 0
           ttRelatedActionsParameter.finalSheet            = 998888 
           ttRelatedActionsParameter.inventoryDate         = 10/01/2009
           ttRelatedActionsParameter.updateDate            = 10/05/2009
           ttRelatedActionsParameter.updateType             = 2
          ttRelatedActionsParameter.initialInventoryGroup  = 1
          ttRelatedActionsParameter.finalInventoryGroup    = 10
          ttRelatedActionsParameter.initialFamily          = ""
          ttRelatedActionsParameter.finalFamily            = "ZZZZZe"
          ttRelatedActionsParameter.initialLot             = ""
          ttRelatedActionsParameter.finalLot               = "ZZZs"
          ttRelatedActionsParameter.initialReference       = ""
          ttRelatedActionsParameter.finalReference         = "ZZZZZZ"
          ttRelatedActionsParameter.initialBinLocation     = ""
          ttRelatedActionsParameter.finalBinLocation       = "ZZZ"
          ttRelatedActionsParameter.zeroAccumVariance      = TRUE
          ttRelatedActionsParameter.includeCountingCycle   = FALSE
          ttRelatedActionsParameter.itemsWithoutBalance    = TRUE
          ttRelatedActionsParameter.consignedItems         = FALSE
          ttRelatedActionsParameter.initialTransBetween    = 01/01/2007
          ttRelatedActionsParameter.finalTransBetween      = 01/12/2007
          ttRelatedActionsParameter.lastReceiptDate        = 01/01/2007
          ttRelatedActionsParameter.lastIssueDate          = 01/01/2007
          ttRelatedActionsParameter.obsolescenceCode       = 3
          ttRelatedActionsParameter.amountToCount          = 15
          ttRelatedActionsParameter.priceType              = 1
          ttRelatedActionsParameter.priceTypeDescription   = "Sei la"
          ttRelatedActionsParameter.printType              = 2
          ttRelatedActionsParameter.blankQtyToPrint        = 2
          ttRelatedActionsParameter.blankStartSheetNumber  = 3
          ttRelatedActionsParameter.initialBalDateForInvCount = 01/08/2007
          ttRelatedActionsParameter.movementType           = 2
          ttRelatedActionsParameter.finalBalDateForInvCount = 01/08/2009
          ttRelatedActionsParameter.generateType          = 1
          ttRelatedActionsParameter.itemsWithZeroBalance = TRUE.*/


    /*find last bfinventario use-index nr-ficha no-lock no-error.
    if  avail bfinventario then 
        assign ttRelatedActionsParameter.inventoryDate = bfinventario.dt-saldo.
    else
        assign ttRelatedActionsParameter.inventoryDate = today.*/
    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getInventoryCurrency DBOProgram 
PROCEDURE getInventoryCurrency :
/*------------------------------------------------------------------------------ 
  Purpose: Retorna as moedas do estoque ce0101
  Parameters:
  Notes:
------------------------------------------------------------------------------*/ 
   DEF OUTPUT PARAM TABLE FOR ttInventoryCurrency.

    find moeda
        where moeda.mo-codigo = 0 no-lock no-error.  
    if  avail moeda then do:
    
        create ttInventoryCurrency.
        assign ttInventoryCurrency.currency = 0
               ttInventoryCurrency.currDescription = "0 - ":U + moeda.descricao.
    end.

    if  param-estoq.tem-moeda1 then do:

        find moeda 
            where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
        if  avail moeda then do:
        
            create ttInventoryCurrency.
            assign ttInventoryCurrency.currency = 1
                   ttInventoryCurrency.currDescription = "1 - ":U + moeda.descricao.
        end.
    end.
    
    if  param-estoq.tem-moeda2 then do:
        find moeda 
            where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
        if  avail moeda then do:

            create ttInventoryCurrency.
            assign ttInventoryCurrency.currency = 2
                   ttInventoryCurrency.currDescription = "2 - ":U + moeda.descricao.
        end.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getItemsWithoutValue DBOProgram 
PROCEDURE getItemsWithoutValue :
/*------------------------------------------------------------------------------
  Purpose: Busca itens inventariados sem valor
  Parameters:
  Notes:
------------------------------------------------------------------------------*/ 
    DEF INPUT  PARAM TABLE FOR ttInventoryCountParam.
    DEF OUTPUT PARAM TABLE FOR ttItemWithoutValue.


    DEFINE VARIABLE da-fim-per-inv LIKE inventario.dt-saldo NO-UNDO.
    DEFINE VARIABLE da-mensal-ate  LIKE inventario.dt-saldo NO-UNDO.
   

    if not avail param-estoq then
        find first param-estoq no-lock no-error.

    FOR FIRST ttInventoryCountParam NO-LOCK:
    END.


    FOR EACH {&TableName} NO-LOCK 
       WHERE {&TableName}.dt-saldo     = ttInventoryCountParam.inventoryDate
         AND {&TableName}.cod-estabel >= ttInventoryCountParam.initialSite
         AND {&TableName}.cod-estabel <= ttInventoryCountParam.finalSite
         AND {&TableName}.cod-depos   >= ttInventoryCountParam.initialWarehouse
         AND {&TableName}.cod-depos   <= ttInventoryCountParam.finalWarehouse
         AND {&TableName}.cod-localiz >= ttInventoryCountParam.initialBinLocation
         AND {&TableName}.cod-localiz <= ttInventoryCountParam.finalBinLocation
         AND {&tablename}.it-codigo   >= ttInventoryCountParam.initialItem
         AND {&tablename}.it-codigo   <= ttInventoryCountParam.finalItem
         AND ( {&TableName}.situacao = 2 OR
               {&TableName}.situacao = 4 OR
               {&TableName}.situacao = 3),
       EACH ITEM NO-LOCK
       WHERE ITEM.it-codigo  = {&TableName}.it-codigo
         AND ITEM.fm-codigo >= ttInventoryCountParam.initialFamily
         AND ITEM.fm-codigo <= ttInventoryCountParam.finalFamily
         AND ITEM.ge-codigo >= ttInventoryCountParam.initialInventoryGroup
         AND ITEM.ge-codigo <= ttInventoryCountParam.finalInventoryGroup
       BREAK BY {&TableName}.cod-estabel
             BY {&TableName}.it-codigo:


        FIND item-estab
            WHERE item-estab.it-codigo = inventario.it-codigo
            AND   item-estab.cod-estabel = inventario.cod-estabel NO-LOCK NO-ERROR.

        ASSIGN da-fim-per-inv = IF  MONTH({&TableName}.dt-saldo) = 12 THEN DATE(01,01,YEAR({&TableName}.dt-saldo) + 1) - 1
                                                                   ELSE DATE(MONTH({&TableName}.dt-saldo) + 1,01,
                                                                   YEAR({&TableName}.dt-saldo)) - 1.       

        FOR FIRST estabelec
            FIELDS ( cod-estabel   custo-contab )
            WHERE estabelec.cod-estabel = {&TableName}.cod-estabel NO-LOCK.
        END.


        &IF DEFINED(bf_mat_fech_estab) &THEN
            IF param-estoq.tp-fech = 2 THEN DO:
                IF AVAIL estabelec THEN DO:
                    FOR FIRST estab-mat
                        FIELDS ( cod-estabel    mensal-ate )
                        WHERE estab-mat.cod-estabel = estabelec.cod-estabel NO-LOCK:
                    END.
                END.
                IF  AVAIL estab-mat THEN DO:
                    ASSIGN da-mensal-ate = estab-mat.mensal-ate.
                END.
            END.
            ELSE DO:
                ASSIGN da-mensal-ate = param-estoq.mensal-ate.
            END.
        &ELSE
            ASSIGN da-mensal-ate = param-estoq.mensal-ate.
        &ENDIF

        FIND FIRST movto-estoq 
             WHERE movto-estoq.it-codigo   = {&TableName}.it-codigo
               AND movto-estoq.cod-estabel = {&TableName}.cod-estabel 
               AND movto-estoq.esp-docto   = 1
               AND movto-estoq.dt-trans    > da-mensal-ate
               AND movto-estoq.dt-trans   <= da-fim-per-inv NO-LOCK NO-ERROR.

        IF  NOT AVAIL movto-estoq AND AVAIL item THEN DO:
            FIND FIRST c-movto 
                 WHERE c-movto.it-codigo   = {&TableName}.it-codigo
                   AND c-movto.cod-estabel = {&TableName}.cod-estabel 
                   AND c-movto.esp-docto   = 21
                   AND c-movto.dt-trans    > da-mensal-ate
                   AND c-movto.dt-trans   <= da-fim-per-inv NO-LOCK NO-ERROR.

            IF NOT AVAIL c-movto 
                AND (avail item and item.tipo-contr = 2)

                AND (NOT AVAIL item-estab
                     OR (AVAIL item-estab
                          AND  item-estab.val-unit-mat-m[1] +
                               item-estab.val-unit-mob-m[1] +
                               item-estab.val-unit-ggf-m[1] = 0
                          AND  AVAIL estabelec 
                          AND estabelec.custo-contab = 1)
                     OR (AVAIL item-estab 
                          AND  item-estab.val-unit-mat-o[1] +
                               item-estab.val-unit-mob-o[1] +
                               item-estab.val-unit-ggf-o[1] = 0
                          AND  AVAIL estabelec 
                          AND  estabelec.custo-contab = 2)
                     OR (AVAIL item-estab
                          AND  item-estab.val-unit-mat-p[1] +
                               item-estab.val-unit-mob-p[1] +
                               item-estab.val-unit-ggf-p[1] = 0 
                          AND  AVAIL estabelec 
                          AND estabelec.custo-contab = 3) )
                    AND ({&TableName}.val-apurado[1] <> {&TableName}.qtidade-atu
                        OR  {&TableName}.val-apurado[2] <> {&TableName}.qtidade-atu
                        OR  {&TableName}.val-apurado[3] <> {&TableName}.qtidade-atu) 

                AND ({&TableName}.valor-mat-m[1] + {&TableName}.valor-ggf-m[1] + {&TableName}.valor-mob-m[1] = 0) 
                THEN DO:

                IF NOT CAN-FIND(ttItemWithoutValue
                                WHERE ttItemWithoutValue.site = {&TableName}.cod-estabel
                                AND   ttItemWithoutValue.ITEM = {&TableName}.it-codigo NO-LOCK) THEN DO:
                    CREATE ttItemWithoutValue.
                    ASSIGN ttItemWithoutValue.site = {&TableName}.cod-estabel
                           ttItemWithoutValue.ITEM = {&TableName}.it-codigo
                           ttItemWithoutValue.itemDescription = ITEM.desc-item
                           ttItemWithoutValue.unitOfMeasure = ITEM.un
                           ttItemWithoutValue.family = ITEM.fm-codigo
                           ttItemWithoutValue.onhandAmount = 0
                           ttItemWithoutValue.materialAmount = 0
                           ttItemWithoutValue.laborAmount = 0.                    
                END.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLotValidityDate DBOProgram 
PROCEDURE getLotValidityDate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
	
	DEF INPUT PARAM lotValue AS character.
	DEF INPUT PARAM itemCode AS character.
    DEF INPUT PARAM site AS character.
    DEF INPUT PARAM deposit AS character.
    DEF INPUT PARAM location AS character.
    DEF OUTPUT PARAM TABLE FOR ttStringReturn.
    DEF OUTPUT PARAM TABLE FOR RowErrors.
	
	DEF VAR dateVar AS DATE FORMAT "99/99/9999" NO-UNDO.
	
	FIND FIRST SALDO-ESTOQ 
		WHERE SALDO-ESTOQ.lote = lotValue
		AND saldo-estoq.it-codigo = (IF itemCode = "" THEN saldo-estoq.it-codigo ELSE itemCode)
		AND saldo-estoq.cod-estabel = (IF site = "" THEN saldo-estoq.cod-estabel ELSE site)
		AND saldo-estoq.cod-depos = (IF deposit = "" THEN saldo-estoq.cod-depos ELSE deposit)
		AND saldo-estoq.cod-localiz = (IF location = "" THEN saldo-estoq.cod-localiz ELSE location)
		NO-LOCK NO-ERROR.

    CREATE ttStringReturn.
    ASSIGN ttStringReturn.stringValue = "".
    
	IF AVAIL SALDO-ESTOQ THEN DO:
		ASSIGN dateVar = SALDO-ESTOQ.dt-vali-lote.
        ASSIGN ttStringReturn.stringValue = string(dateVar, "99/99/9999").
	END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getMovementDetail DBOProgram 
PROCEDURE getMovementDetail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM transactionNumber AS INTEGER NO-UNDO.
DEF INPUT PARAM currencyCode      AS INTEGER NO-UNDO.
DEF INPUT PARAM averageType       AS INTEGER NO-UNDO.
DEF OUTPUT PARAM TABLE FOR ttMovementDetail.
DEF OUTPUT PARAM TABLE FOR RowErrors.

run prgint/utb/utb743za.py persistent set h_api_cta.
run prgint/utb/utb742za.py persistent set h_api_ccust.

find first param-estoq no-lock no-error.

FIND FIRST movto-estoq WHERE nr-trans = transactionNumber NO-LOCK NO-ERROR.
    IF AVAIL movto-estoq THEN DO:
        FIND FIRST estabelec 
            WHERE estabelec.cod-estabel = movto-estoq.cod-estabel NO-LOCK NO-ERROR.
        ASSIGN i-empresa = IF AVAIL estabelec THEN estabelec.ep-codigo ELSE "".

        CREATE ttMovementDetail.
        ASSIGN ttMovementDetail.item                    = movto-estoq.it-codigo
            ttMovementDetail.site                       = movto-estoq.cod-estabel
            ttMovementDetail.warehouse                  = movto-estoq.cod-depos
            ttMovementDetail.reference                  = movto-estoq.cod-refer
            ttMovementDetail.userName                   = movto-estoq.usuario
            ttMovementDetail.vendor                     = movto-estoq.cod-emitente
            ttMovementDetail.quantity                   = movto-estoq.quantidade
            ttMovementDetail.reqBalance                 = movto-estoq.saldo-req
            ttMovementDetail.localization               = movto-estoq.cod-localiz
            ttMovementDetail.lot                        = movto-estoq.lote
            ttMovementDetail.transactionDate            = movto-estoq.dt-trans
            ttMovementDetail.operationType              = movto-estoq.nat-operacao
            ttMovementDetail.documentSeries             = movto-estoq.serie-docto
            ttMovementDetail.documentNumber             = movto-estoq.nro-docto
            ttMovementDetail.account                    = movto-estoq.ct-codigo
            ttMovementDetail.costCenter                 = movto-estoq.sc-codigo
            ttMovementDetail.businessUnit               = movto-estoq.cod-unid-negoc
            ttMovementDetail.inventoryReqNumber         = movto-estoq.num-ord-inv
            ttMovementDetail.productReqNumber           = movto-estoq.nr-ord-produ
            ttMovementDetail.reqNumber                  = movto-estoq.numero-ordem
            ttMovementDetail.documentClass              = {ininc/i03in218.i 04 movto-estoq.esp-docto}
            ttMovementDetail.fiscalOutDate              = movto-estoq.dt-nf-saida
            ttMovementDetail.transType                  = movto-estoq.tipo-trans
            ttMovementDetail.narrative                  = movto-estoq.descricao-db
            ttMovementDetail.isCurrency1                = true
            .
        
        if averageType = 1 then do:
            assign ttMovementDetail.mobValue1 = string(movto-estoq.valor-mob-m[1])
                   ttMovementDetail.ggfValue1 = string(movto-estoq.valor-ggf-m[1])
                   ttMovementDetail.matValue1 = string(movto-estoq.valor-mat-m[1]).

            if param-estoq.tem-moeda1 = yes then do:
                assign ttMovementDetail.mobValue2   = string(movto-estoq.valor-mob-m[2])
                       ttMovementDetail.ggfValue2   = string(movto-estoq.valor-ggf-m[2])
                       ttMovementDetail.matValue2   = string(movto-estoq.valor-mat-m[2])
                       ttMovementDetail.isCurrency2 = true.
            end.

            if param-estoq.tem-moeda2 = yes then do:
                assign ttMovementDetail.mobValue3   = string(movto-estoq.valor-mob-m[3])
                       ttMovementDetail.ggfValue3   = string(movto-estoq.valor-ggf-m[3])
                       ttMovementDetail.matValue3   = string(movto-estoq.valor-mat-m[3])
                       ttMovementDetail.isCurrency3 = true.
            end.
        end.
        else if averageType = 2 then do:
            assign ttMovementDetail.mobValue1 = string(movto-estoq.valor-mob-o[1])
                   ttMovementDetail.ggfValue1 = string(movto-estoq.valor-ggf-o[1])
                   ttMovementDetail.matValue1 = string(movto-estoq.valor-mat-o[1]).

            if param-estoq.tem-moeda1 = yes then do:
                assign ttMovementDetail.mobValue2   = string(movto-estoq.valor-mob-o[2])
                       ttMovementDetail.ggfValue2   = string(movto-estoq.valor-ggf-o[2])
                       ttMovementDetail.matValue2   = string(movto-estoq.valor-mat-o[2])
                       ttMovementDetail.isCurrency2 = true.
            end.

            if param-estoq.tem-moeda2 = yes then do:
                assign ttMovementDetail.mobValue3   = string(movto-estoq.valor-mob-o[3])
                       ttMovementDetail.ggfValue3   = string(movto-estoq.valor-ggf-o[3])
                       ttMovementDetail.matValue3   = string(movto-estoq.valor-mat-o[3])
                       ttMovementDetail.isCurrency3 = true.
            end.
        end.

        find moeda where moeda.mo-codigo = 0 no-lock no-error.
        if avail moeda then do:
            assign ttMovementDetail.currency1Description = moeda.descricao.
        end.

        if param-estoq.tem-moeda1 then do:
            find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
            if avail moeda then do:
                assign ttMovementDetail.currency2Description = moeda.descricao.
            end.
        END.

        if param-estoq.tem-moeda2 then do:
            find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
            if avail moeda then do:
                assign ttMovementDetail.currency3Description = moeda.descricao.
            end.
        END.
        
        /* Busca Data de validade do lote */
        FOR FIRST saldo-estoq FIELD (cod-depos cod-estabel cod-localiz lote
                                     it-codigo dt-vali-lote ) WHERE 
            saldo-estoq.cod-depos   = movto-estoq.cod-depos   AND
            saldo-estoq.cod-estabel = movto-estoq.cod-estabel AND
            saldo-estoq.cod-localiz = movto-estoq.cod-localiz AND
            saldo-estoq.lote        = movto-estoq.lote        AND
            saldo-estoq.it-codigo   = movto-estoq.it-codigo   
            NO-LOCK: 
        END.
            IF  AVAIL saldo-estoq THEN
                ASSIGN ttMovementDetail.lotValidityDate = saldo-estoq.dt-vali-lote.
            
        /* Busca n£mero do pedido */
        FOR FIRST ordem-compra FIELD (numero-ordem num-pedido) WHERE
            ordem-compra.numero-ordem = movto-estoq.numero-ordem 
            NO-LOCK: 
        END.
            IF AVAILABLE ordem-compra THEN
                ASSIGN ttMovementDetail.requisition = STRING(ordem-compra.num-pedido,"zzzzz,zz9").
            ELSE DO:
                FOR FIRST ord-prod FIELD (nr-ord-produ nr-pedido) WHERE
                    ord-prod.nr-ord-produ = movto-estoq.nr-ord-produ 
                    NO-LOCK: 
                END.
                IF  AVAIL ord-prod THEN
                    ASSIGN ttMovementDetail.requisition = STRING(ord-prod.nr-pedido).
            END.
            

        /* Busca a descriá∆o do item*/
        FIND ITEM WHERE item.it-codigo = movto-estoq.it-codigo NO-LOCK NO-ERROR.
            IF  AVAIL ITEM THEN 
                ASSIGN ttMovementDetail.itemDescription = item.desc-item.
            ELSE
                ASSIGN ttMovementDetail.itemDescription = "". 
                
        /*Busca a descriá∆o do estabelecimento */
        FIND estabelec WHERE
            estabelec.cod-estabel = movto-estoq.cod-estabel NO-LOCK NO-ERROR.
            IF  AVAIL estabelec THEN
                ASSIGN ttMovementDetail.siteDescription = estabelec.nome.
            ELSE
                ASSIGN ttMovementDetail.siteDescription = "".
                    
        /* Busca a descriá∆o do dep¢sito */
        FIND deposito WHERE 
            deposito.cod-depos = movto-estoq.cod-depos NO-LOCK NO-ERROR.
            IF  AVAIL deposito THEN
                ASSIGN ttMovementDetail.warehouseDescription = deposito.nome.
            ELSE
                ASSIGN ttMovementDetail.warehouseDescription = "".
                        
        /* Busca descriá∆o do fornecedor*/
        FIND emitente WHERE 
            emitente.cod-emitente = movto-estoq.cod-emitente NO-LOCK NO-ERROR.
            IF  AVAIL emitente THEN
                ASSIGN ttMovementDetail.vendorDescription = emitente.nome-abrev.
            ELSE
                ASSIGN ttMovementDetail.vendorDescription = "".
            
        /* Busca a descriá∆o da conta cont†bil */
      assign ct-conta = movto-estoq.ct-codigo.
       run pi_busca_dados_cta_ctbl in h_api_cta (input        i-empresa,          /* EMPRESA EMS2 */
                                                 input        "",                 /* PLANO DE CONTAS */
                                                 input-output ct-conta,            /* CONTA */
                                                 input        today,              /* DATA TRANSACAO */
                                                 output       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                 output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                 output       v_num_sit_cta_ctbl, /* SITUA¯∞O DA CONTA */
                                                 output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA*/
                                                 output table tt_log_erro).       /* ERROS */

       find first tt_log_erro no-error.
       if avail tt_log_erro THEN
            ASSIGN ttMovementDetail.accountDescription = "".
       ELSE
           ASSIGN ttMovementDetail.accountDescription = v_des_cta_ctbl.

       ASSIGN sc-conta = movto-estoq.sc-codigo.

       run pi_busca_dados_ccusto in h_api_ccust (input  i-empresa,        /* EMPRESA EMS2 */
                                                 input  "",                 /* CODIGO DO PLANO CCUSTO*/
                                                 input  sc-conta,           /* CCUSTO */
                                                 input  today,              /* DATA DE TRANSACAO */
                                                 output v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                                 output table tt_log_erro). /* ERROS */

       find first tt_log_erro no-error.
       IF avail tt_log_erro THEN
            ASSIGN ttMovementDetail.costCenterDescription = "".
       ELSE                                                             
           ASSIGN ttMovementDetail.costCenterDescription = v_des_ccusto.
        
        /* Busca a descriá∆o da Unidade de Neg¢cio */
        FIND unid-negoc
            WHERE unid-negoc.cod-unid-negoc = movto-estoq.cod-unid-negoc NO-LOCK NO-ERROR.
            ASSIGN ttMovementDetail.businessUnitDescription = IF  AVAIL unid-negoc THEN unid-negoc.des-unid-negoc 
                                                              ELSE "".


    END.

    DELETE PROCEDURE h_api_ccust.
    ASSIGN h_api_ccust = ?.

    DELETE PROCEDURE h_api_cta.
    ASSIGN h_api_cta = ?.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTotalCounting DBOProgram 
PROCEDURE getTotalCounting :
/*------------------------------------------------------------------------------ 
  Purpose: Retorna dados para formacao do grafico de Contagens
  Parameters:
  Notes: Representa o numero de fichas que ja tiveram Contagem 1, 2 e 3
------------------------------------------------------------------------------*/ 
    DEFINE INPUT  PARAM TABLE FOR ttInventoryCountParam .
        DEFINE INPUT  PARAM TABLE FOR ttCountingParameter .
    DEFINE OUTPUT PARAM TABLE FOR ttTotals .

    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE keepTrackInventoryCount DBOProgram 
PROCEDURE keepTrackInventoryCount :
/*------------------------------------------------------------------------------ 
  Purpose:     Retorna dados para a formacao do gr†fico do portlet e do painel
               Posicao Inventario
  Parameters:                                       
  Notes:      
------------------------------------------------------------------------------*/ 
        DEF INPUT  PARAM TABLE FOR ttInventoryCountParam .
        DEF OUTPUT PARAM TABLE FOR ttTotals.

    find first ttInventoryCountParam no-error.
    if  not avail ttInventoryCountParam then
        return "NOK":U.

    for each  inventario fields (situacao it-codigo)
        where inventario.dt-saldo     = ttInventoryCountParam.inventoryDate     
        and   inventario.cod-estabel >= ttInventoryCountParam.initialSite       
        and   inventario.cod-estabel <= ttInventoryCountParam.finalSite         
        and   inventario.cod-depos   >= ttInventoryCountParam.initialWarehouse  
        and   inventario.cod-depos   <= ttInventoryCountParam.finalWarehouse    
        and   inventario.cod-localiz >= ttInventoryCountParam.initialBinLocation
        and   inventario.cod-localiz <= ttInventoryCountParam.finalBinLocation
        and   inventario.it-codigo   >= ttInventoryCountParam.initialItem       
        and   inventario.it-codigo   <= ttInventoryCountParam.finalItem no-lock:

        if  not avail item
        or (    avail item
            and item.it-codigo <> inventario.it-codigo) then
            for first item fields (fm-codigo ge-codigo it-codigo)
                where item.it-codigo = inventario.it-codigo no-lock: end.

        if  not avail item then
            next.

        if  item.fm-codigo < ttInventoryCountParam.initialFamily
        or  item.fm-codigo > ttInventoryCountParam.finalFamily then 
            next.

        if  item.ge-codigo < ttInventoryCountParam.initialInventoryGroup
        or  item.ge-codigo > ttInventoryCountParam.finalInventoryGroup then 
            next.
            
        find ttTotals
            where ttTotals.situationId = inventario.situacao no-error.
        if  not avail ttTotals then do:

            create ttTotals.
            assign ttTotals.situationId = inventario.situacao
                   ttTotals.situation   = {ininc/i01in157.i 04 inventario.situacao}.
        end.

        assign ttTotals.quantity = ttTotals.quantity + 1.
    end.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE keyCountingSheets DBOProgram 
PROCEDURE keyCountingSheets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM TABLE FOR ttCountingSheets.
DEF INPUT PARAM pCountingNumber AS INTEGER NO-UNDO.
DEF OUTPUT PARAM TABLE FOR RowErrors.
DEF VAR l-habilita            AS LOG                    NO-UNDO.

DEF VAR r-rowid-aux AS ROWID NO-UNDO.
    EMPTY TEMP-TABLE RowErrors.

    IF  NOT VALID-HANDLE(h-boin157q01) THEN DO:
        RUN inbo/boin157q01.p PERSISTENT SET h-boin157q01.
        FIND FIRST ttCountingSheets NO-LOCK NO-ERROR.
        Run setConstraintDataSaldo in h-boin157q01 (INPUT ttCountingSheets.inventoryDate).
        RUN openQueryStatic  IN h-boin157q01 (INPUT "Inclui":U)  NO-ERROR.
        RUN piInicializa     IN h-boin157q01 (OUTPUT table RowErrors). 
        IF CAN-FIND (FIRST RowErrors WHERE RowErrors.errorsubtype = "ERROR") THEN DO:
            RETURN "NOK":U.
        END.
    END.
        
MODIFICA:
DO TRANSACTION :

    RUN setConstraintInclui IN h-boin157q01 (pCountingNumber). /* primeira contagem */
    RUN setConstraintFlex   IN h-boin157q01 (YES).
    
    FOR EACH ttCountingSheets NO-LOCK:
        ASSIGN ttCountingSheets.quantity = IF ttCountingSheets.quantity = -1 THEN ? ELSE ttCountingSheets.quantity.
        EMPTY TEMP-TABLE tt-inventario.
            
        RUN emptyRowErrors       IN h-boin157q01.
        
        RUN goToKey IN h-boin157q01 (INPUT ttCountingSheets.inventoryDate,
                                     INPUT ttCountingSheets.site,
                                     INPUT ttCountingSheets.warehouse,
                                     INPUT ttCountingSheets.binLocation,
                                     INPUT ttCountingSheets.lot,
                                     INPUT ttCountingSheets.item,
                                     INPUT ttCountingSheets.reference).
            
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getRecord IN h-boin157q01 (OUTPUT TABLE tt-inventario).
            FOR FIRST tt-inventario EXCLUSIVE-LOCK:
                ASSIGN tt-inventario.val-apurado[pCountingNumber] = ttCountingSheets.quantity.
				
				/*atualiza conferente da contagem caso o conferente estiver em branco*/
				if pCountingNumber = 1 
				AND (tt-inventario.cod-confte-contag-1 = "" 
					 OR tt-inventario.cod-confte-contag-1 = ?) then
					 ASSIGN tt-inventario.cod-confte-contag-1 = v_cod_usuar_corren.
				else if pCountingNumber = 2 
					 AND (tt-inventario.cod-confte-contag-2 = "" 
						  OR tt-inventario.cod-confte-contag-2 = ?) then
						ASSIGN tt-inventario.cod-confte-contag-2 = v_cod_usuar_corren.
					else if pCountingNumber = 3 
						 AND (tt-inventario.cod-confte-contag-3 = "" 
							  OR tt-inventario.cod-confte-contag-3 = ?) then
							ASSIGN tt-inventario.cod-confte-contag-3 = v_cod_usuar_corren.
							
				
				
                RUN emptyRowObject      IN h-boin157q01.
                RUN setRecord           IN h-boin157q01 (INPUT TABLE tt-inventario).
                RUN updateRecord        IN h-boin157q01.

                IF RETURN-VALUE = "NOK":U THEN DO:
                    RUN getRowErrors IN h-boin157q01 (OUTPUT TABLE RowErrorsAux).
                END.

                for each RowErrorsAux no-lock:
                    create RowErrors.
                    buffer-copy RowErrorsAux to RowErrors.
                    {utp/ut-liter.i Erro_ocorrido_na_digitaá∆o_da_ficha}
                    assign RowErrors.ErrorHelp = return-value + ": " + string(ttCountingSheets.countingSheetNumber).
                end.
                    
                IF NOT CAN-FIND(FIRST RowErrorsAux WHERE RowErrorsAux.ErrorSubType = "ERROR":U) THEN DO:
                    /* Atualiza saldo */
                    RUN getRowid       in h-boin157q01 (output r-rowid-aux).
                    RUN piCalculaSaldo in h-boin157q01 (input "UPDATE":U, input r-rowid-aux).
                    RUN getRowErrors   in h-boin157q01 (output table RowErrorsAux).

                    for each RowErrorsAux no-lock:
                        create RowErrors.
                        buffer-copy RowErrorsAux to RowErrors.
                        {utp/ut-liter.i Ficha}
                        assign RowErrors.ErrorHelp = return-value + ": " + string(ttCountingSheets.countingSheetNumber).
                    end.

                    /*A BO est†ˇ gerando esta mensagem 2 vezes*/
                    FIND FIRST RowErrors WHERE RowErrors.ErrorNumber = 4555 NO-LOCK NO-ERROR. 
                        FIND NEXT RowErrors WHERE RowErrors.ErrorNumber = 4555 EXCLUSIVE-LOCK NO-ERROR.
                            IF AVAIL RowErrors THEN
                                DELETE RowErrors.
                    FIND FIRST RowErrors WHERE RowErrors.ErrorNumber = 7337 NO-LOCK NO-ERROR.
                        FIND NEXT RowErrors WHERE RowErrors.ErrorNumber = 7337 EXCLUSIVE-LOCK NO-ERROR.
                            IF AVAIL RowErrors THEN
                                DELETE RowErrors.
                END.
            END.
        END.
    END.
    DELETE PROCEDURE h-boin157q01.
    ASSIGN h-boin157q01 = ?.
END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outdateInventory DBOProgram 
PROCEDURE outdateInventory :
/*------------------------------------------------------------------------------ 
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/ 
    DEFINE INPUT PARAMETER TABLE FOR ttCounting .
    DEFINE INPUT PARAMETER dateTrans AS DATE NO-UNDO .
    define output parameter table for RowErrors.
    

    DEFINE VARIABLE num-reg-elim  AS INTEGER INITIAL 0           NO-UNDO.
    DEFINE VARIABLE l-ultimo-item AS LOGICAL                     NO-UNDO.
    DEFINE VARIABLE c-periodo     AS CHARACTER FORMAT "9999/99"  NO-UNDO.
/*     DEFINE VARIABLE i-empresa     LIKE param-global.empresa-prin NO-UNDO. */

    DEFINE VARIABLE l-finderror AS LOGICAL     NO-UNDO.


    DEFINE BUFFER b-consumo-estab FOR consumo-estab.

    FIND FIRST param-estoq  NO-LOCK NO-ERROR.
    FIND FIRST param-global NO-LOCK NO-ERROR.

    FIND empresa WHERE empresa.ep-codigo = param-global.empresa-prin NO-LOCK NO-ERROR.

    ASSIGN i-empresa = empresa.ep-codigo.

    assign l-finderror = yes.

    /**  LOOPING DE LEITURA DOS REGISTROS DE INVENTARIO - DESATUALIZACAO **/
    bloco:
    DO TRANSACTION:
        FOR EACH ttCounting NO-LOCK:

            FOR FIRST inventario
                WHERE STRING(ROWID(inventario)) = ttCounting.ROWID NO-LOCK:
        
                FIND ITEM WHERE ITEM.it-codigo = inventario.it-codigo NO-LOCK NO-ERROR.
        
                FIND item-uni-estab WHERE item-uni-estab.cod-estabel = inventario.cod-estabel 
                                      AND item-uni-estab.it-codigo   = inventario.it-codigo NO-LOCK NO-ERROR.              
        
                IF NOT CAN-FIND (FIRST movto-estoq 
                        WHERE movto-estoq.it-codigo    = inventario.it-codigo
                          AND movto-estoq.cod-estabel  = inventario.cod-estabel
                          AND movto-estoq.dt-trans     = ttCounting.countingDate
                          AND movto-estoq.cod-depos    = inventario.cod-depos
                          AND movto-estoq.lote         = inventario.lote
                          AND movto-estoq.cod-refer    = inventario.cod-refer
                          AND (movto-estoq.cod-localiz = inventario.cod-localiz 
                           OR item-uni-estab.loc-unica = YES)
                          AND movto-estoq.esp-docto    = 15 ) THEN DO:
                    NEXT.
                END.

                assign l-finderror = no.
        
                ASSIGN num-reg-elim = num-reg-elim + 1.
                
                IF NOT item-uni-estab.loc-unica THEN
                   ASSIGN l-ultimo-item = YES.
                ELSE DO:
                     IF NOT CAN-FIND (first bf{&TableName} 
                                      where bf{&TableName}.dt-saldo     =  inventario.dt-saldo   
                                        and bf{&TableName}.cod-estabel  =  inventario.cod-estabel
                                        and bf{&TableName}.cod-depos    =  inventario.cod-depos   
                                        and bf{&TableName}.lote         =  inventario.lote        
                                        and bf{&TableName}.cod-refer    =  inventario.cod-refer           
                                        and bf{&TableName}.it-codigo    =  inventario.it-codigo
                                        and bf{&TableName}.situacao     = 1 
                                        and bf{&TableName}.nr-ficha     <> inventario.nr-ficha
                                        and bf{&TableName}.cod-localiz  <> inventario.cod-localiz) THEN 
                           ASSIGN l-ultimo-item = YES.
                      ELSE ASSIGN l-ultimo-item = NO.
                END.                
                
                /**  BUSCA A MOVIMENTACAO DE ESTOQUE REF. AO REGISTRO DE INVENTARIO **/
                FOR EACH movto-estoq where 
                    movto-estoq.it-codigo    = inventario.it-codigo    AND
                    movto-estoq.cod-estabel  = inventario.cod-estabel  AND
                    movto-estoq.dt-trans     = ttCounting.countingDate AND
                    movto-estoq.cod-depos    = inventario.cod-depos    AND
                    movto-estoq.lote         = inventario.lote         AND
                    movto-estoq.cod-refer    = inventario.cod-refer    AND
                    (movto-estoq.cod-localiz = inventario.cod-localiz  OR
                    item-uni-estab.loc-unica = yes)                    AND
                    movto-estoq.esp-docto    = 15 EXCLUSIVE-LOCK:
        
                    IF l-ultimo-item THEN DO:
        
                            /**  BUSCA O SALDO DE ESTOQUE REF AO REGISTRO DE INVENTARIO - QTE 
                            **/
                            find first saldo-estoq where
                                saldo-estoq.cod-estabel = inventario.cod-estabel  and
                                saldo-estoq.cod-depos   = inventario.cod-depos    and
                                saldo-estoq.cod-localiz = movto-estoq.cod-localiz and
                                saldo-estoq.lote        = inventario.lote         and
                                saldo-estoq.cod-refer   = inventario.cod-refer    and
                                saldo-estoq.it-codigo   = inventario.it-codigo    exclusive-lock no-error.
            
                            /**  ESTORNA QUANTIDADES DO SALDO DE ESTOQUE SEGUNDO MOVTO **/
                            assign saldo-estoq.qtidade-atu = saldo-estoq.qtidade-atu +
                                                             if movto-estoq.tipo-trans = 1 
                                                             then - movto-estoq.quantidade
                                                             else + movto-estoq.quantidade.
            
                            /**  BUSCA O ITEM-ESTAB DO ITEM DO REGISTRO DE INVENTARIO  **/
                            find first item-estab where
                                item-estab.it-codigo    = inventario.it-codigo and
                                item-estab.cod-estabel  = inventario.cod-estabel 
                                exclusive-lock no-error.
            
                            /**  ESTORNA QUANTIDADES DA VARIACAO ACUMULADA NO ITEM-ESTAB  **/
                            assign item-estab.varia-acum = item-estab.varia-acum +
                                                           if movto-estoq.tipo-trans = 1
                                                           then - movto-estoq.quantidade
                                                           else + movto-estoq.quantidade.
        
                        find estabelec 
                           where estabelec.cod-estabel = movto-estoq.cod-estabel 
                           no-lock no-error.
        
                        &if defined(bf_mat_custeio_item) &then
                            for first estab-mat fields(usa-on-line) 
                                where estab-mat.cod-estabel = movto-estoq.cod-estabel
                                no-lock: end.
                            if avail estab-mat and estab-mat.usa-on-line = yes then DO:
                                if movto-estoq.tipo-trans = 1 then
                                    assign item-estab.qtidade-atu = item-estab.qtidade-atu - movto-estoq.quantidade.
                                else
                                    assign item-estab.qtidade-atu = item-estab.qtidade-atu + movto-estoq.quantidade.
                                run pi-desatualiza-custo.
                            END.
                        &else
                            if  estabelec.usa-on-line = yes 
                            or  estabelec.usa-padrao  = yes then
                                if movto-estoq.tipo-trans = 1 then
                                    assign item-estab.qtidade-atu  = item-estab.qtidade-atu
                                                                     - movto-estoq.quantidade.
                                else
                                    assign item-estab.qtidade-atu  = item-estab.qtidade-atu
                                                                     + movto-estoq.quantidade.
        
                            if  estabelec.usa-on-line = yes then do :
                                {cep/ce0711.i1 "-o"}
        
                                if avail item-estab then
                                    assign  item-estab.val-unit-mat-o[1] = item-estab.sald-atu-mat-o[1]
                                                                         / if item-estab.qtidade-atu > 0 
                                                                              then item-estab.qtidade-atu
                                                                              else 1
                                            item-estab.val-unit-mat-o[2] = item-estab.sald-atu-mat-o[2]
                                                                         / if item-estab.qtidade-atu > 0 
                                                                              then item-estab.qtidade-atu
                                                                              else 1                                                         
                                            item-estab.val-unit-mat-o[3] = item-estab.sald-atu-mat-o[3]
                                                                         / if item-estab.qtidade-atu > 0 
                                                                              then item-estab.qtidade-atu
                                                                              else 1                                                         
                                            item-estab.val-unit-mob-o[1] = item-estab.sald-atu-mob-o[1]
                                                                         / if item-estab.qtidade-atu > 0 
                                                                              then item-estab.qtidade-atu
                                                                              else 1
                                            item-estab.val-unit-mob-o[2] = item-estab.sald-atu-mob-o[2]
                                                                         / if item-estab.qtidade-atu > 0 
                                                                              then item-estab.qtidade-atu
                                                                              else 1
                                            item-estab.val-unit-mob-o[3] = item-estab.sald-atu-mob-o[3]
                                                                         / if item-estab.qtidade-atu > 0 
                                                                              then item-estab.qtidade-atu
                                                                              else 1
                                            item-estab.val-unit-ggf-o[1] = item-estab.sald-atu-ggf-o[1]
                                                                         / if item-estab.qtidade-atu > 0 
                                                                              then item-estab.qtidade-atu
                                                                              else 1
                                            item-estab.val-unit-ggf-o[2] = item-estab.sald-atu-ggf-o[2]
                                                                         / if item-estab.qtidade-atu > 0 
                                                                              then item-estab.qtidade-atu
                                                                              else 1
                                            item-estab.val-unit-ggf-o[3] = item-estab.sald-atu-ggf-o[3]
                                                                         / if item-estab.qtidade-atu > 0 
                                                                              then item-estab.qtidade-atu
                                                                              else 1.
                            end.
                            if  estabelec.usa-padrao = yes then do:
                                {cep/ce0711.i1 "-p"}
                            end.
                        &endif
                    END. /* IF l-ultimo-item THEN */
        
                    /**  BUSCA O ITEM REFERENTE AO REGISTRO DE INVENTARIO  **/
                    find item where item.it-codigo = inventario.it-codigo exclusive-lock no-error.
        
                    IF l-ultimo-item THEN  /**  ESTORNA QUANTIDADES DA VARIACAO ACUMULADA NO ITEM  **/
                    assign item.variac-acum = item.variac-acum +
                                              if movto-estoq.tipo-trans = 1
                                              then - movto-estoq.quantidade
                                              else + movto-estoq.quantidade.
        
                    &IF DEFINED (bf_mat_versao_ems) &THEN   /* release 2.03 */
                        for first item-uni-estab 
                            fields ( it-codigo cod-estabel variac-acum ) 
                            where item-uni-estab.it-codigo   = item.it-codigo
                              and item-uni-estab.cod-estabel = movto-estoq.cod-estabel exclusive-lock: 
                        end.
                        if  avail item-uni-estab AND l-ultimo-item THEN 
                            assign item-uni-estab.variac-acum = item-uni-estab.variac-acum +
                                                                if movto-estoq.tipo-trans = 1
                                                                then - movto-estoq.quantidade
                                                                else + movto-estoq.quantidade.
                    &ENDIF
        
                    /**  ESTORNO DE CONSUMO, CASO CONTA CONTABIL DE CONSUMO 
                         VERIFICA PERIODO DO MOVTO DE ESTOQUE  **/
                    assign c-periodo = string(year(movto-estoq.dt-trans),"9999") +
                                       string(month(movto-estoq.dt-trans),"99").
        
                    /**  BUSCA CONTA CONTABIL DO MOVTO DE ESTOQUE **/
        
                    &if defined (bf_dis_consiste_conta) &then
                        find estabelec where
                             estabelec.cod-estabel = movto-estoq.cod-estabel no-lock no-error.
        
                             run cdp/cd9970.p (input rowid(estabelec),
                                               output i-empresa).
                    &endif              
        
                    find conta-contab where conta-contab.ep-codigo = i-empresa             and
                                            conta-contab.ct-codigo = movto-estoq.ct-codigo and
                                            conta-contab.sc-codigo = movto-estoq.sc-codigo no-lock no-error.
        
                    if avail conta-contab then do:
                        /**  SE CONTA ê DE CONSUMO, ESTORNA O CONSUMO  **/
                        IF conta-contab.estoque = 1 OR
                           conta-contab.estoque = 3 OR
                           conta-contab.estoque = 6 THEN DO FOR b-consumo-estab:
        
                            /**  BUSCA REGISTRO DE CONSUMO PARA ESTORNO  **/
                            find estab-mat where
                                 estab-mat.cod-estabel = movto-estoq.cod-estabel
                                no-lock no-error.
                            find b-consumo-estab where 
                                b-consumo-estab.ct-codigo        = conta-contab.ct-codigo         and
                                b-consumo-estab.sc-codigo        = conta-contab.sc-codigo         and
                                b-consumo-estab.it-codigo        = movto-estoq.it-codigo          and
                                b-consumo-estab.cod-estabel-prin = estab-mat.cod-estabel-prin     and
                                b-consumo-estab.periodo          = c-periodo                      and
                                b-consumo-estab.ct-codigo        = conta-contab.ct-codigo         and
                                b-consumo-estab.sc-codigo        = conta-contab.sc-codigo 
                                no-error.
        
                            /**  ESTORNO DO REGISTRO DE CONSUMO  **/
                            if avail b-consumo-estab AND l-ultimo-item THEN do: 
                                if movto-estoq.tipo-trans = 1 then do:
                                    assign b-consumo-estab.qt-entrada = b-consumo-estab.qt-entrada - movto-estoq.quantidade.
                                end.
                                else do:
                                    assign b-consumo-estab.qt-saida = b-consumo-estab.qt-saida - movto-estoq.quantidade.
                                end.
                            end.
                        end.
                    end.
        
                    /** EAI **/
                    if v_log_eai_habilit then do:
                        run adapters/xml/ar2/axsar001.p (input "ce0711rp":U,
                                                         input c-prg-vrs,
                                                         input "del":U,
                                                         input rowid(movto-estoq),
                                                         output table RowErrors).

                        if  can-find (first  RowErrors 
                                       where RowErrors.errorSubtype = "ERROR":U) then
                            undo bloco, leave bloco.  
                    end.
        
                    /**  ELIMINA MOVTO DE ESTOQUE REFERENTE AO REGISTRO DE INVENTARIO  **/
                     IF l-ultimo-item then 
                       delete movto-estoq validate(true," ").
        
                end.
        
                find bf2{&TableName} where rowid(bf2{&TableName}) = rowid(inventario) exclusive-lock NO-ERROR.
                /**  VOLTA SITUACAO DO REGISTRO DE INVENTARIO PARA FUTURA ATUALIZACAO  **/
                assign bf2{&TableName}.dt-atualiza = ?
                       bf2{&TableName}.situacao    = 4.
        
                /**  RECALCULO DA QUANTIDADE FINAL PARA ATUALIZAR INVENTARIO  **/
                if inventario.qtidade-atu = inventario.val-apurado[1] and 
                    param-estoq.cons-invent = 1 then do:
                    if inventario.val-apurado[1] = ? then do:
                        assign bf2{&TableName}.valor-final = 0.   
                    end.
                    else do:
                        assign bf2{&TableName}.valor-final = inventario.val-apurado[1].
                    end.
                end.
                else do:
                    if inventario.qtidade-atu = inventario.val-apurado[2] and 
                        param-estoq.cons-invent = 1 then do:
                        if inventario.val-apurado[2] = ? then
                            assign bf2{&TableName}.valor-final = 0.
                        else
                            assign bf2{&TableName}.valor-final = inventario.val-apurado[2].
                    end.
                    else do:
                        if inventario.val-apurado[1] = inventario.val-apurado[2] then do:
                            if inventario.val-apurado[1] = ? then do:
                                assign bf2{&TableName}.valor-final = 0.
                            end.
                            else do:
                                assign bf2{&TableName}.valor-final = inventario.val-apurado[1].
                            end.
                        end.
                        else do:
                            if inventario.val-apurado[2] = ? then do:
                                assign bf2{&TableName}.valor-final = 0.
                            end.
                            else do:
                                assign bf2{&TableName}.valor-final = 
                                if inventario.val-apurado[3] = ? then
                                    if inventario.val-apurado[1] = ? then 0
                                    else inventario.val-apurado[1]
                                    else inventario.val-apurado[3].
                            END.
                        END. 
                    END.
        
                END.
        
            END.
    
        END.
    END.

    if (l-finderror = yes) then do:
        create RowErrors.
        assign RowErrors.ErrorSequence = 0
               RowErrors.ErrorNumber = 17006
               RowErrors.ErrorType = "EMS":U
               RowErrors.ErrorSubType = "ERROR":U.
        {utp/ut-liter.i Alguns_registros_n∆o_foram_desatualizados}
        assign RowErrors.ErrorDescription = return-value.
        {utp/ut-liter.i N∆o_foram_encontrados_registros_para_desatualizaá∆o}
        assign RowErrors.ErrorHelp = return-value.
    end.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE printCountingSheets DBOProgram 
PROCEDURE printCountingSheets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM TABLE FOR ttRelatedActionsParameter.
    def input  param table for ttDigitaItem.
    define OUTPUT parameter table for ttStringReturn.
    DEF OUTPUT PARAM TABLE FOR RowErrors.


    DEFINE VARIABLE cPedidoNum AS CHARACTER   NO-UNDO.

    empty temp-table ttStringReturn.

    FOR FIRST ttRelatedActionsParameter NO-LOCK:

        create tt-paramPrintCountingSheets.
        assign tt-paramPrintCountingSheets.usuario      = c-seg-usuario
               tt-paramPrintCountingSheets.destino      = 2
               tt-paramPrintCountingSheets.data-exec    = today
               tt-paramPrintCountingSheets.hora-exec    = time
               tt-paramPrintCountingSheets.c-destino    = SESSION:TEMP-DIRECTORY
               tt-paramPrintCountingSheets.classifica   = ttRelatedActionsParameter.movementType /* Est† sendo setado o movementType para o classifica */
               tt-paramPrintCountingSheets.item-ini     = ttRelatedActionsParameter.initialItem
               tt-paramPrintCountingSheets.item-fim     = ttRelatedActionsParameter.finalItem
               tt-paramPrintCountingSheets.familia-ini  = ttRelatedActionsParameter.initialFamily
               tt-paramPrintCountingSheets.familia-fim  = ttRelatedActionsParameter.finalFamily
               tt-paramPrintCountingSheets.lote-ini     = ttRelatedActionsParameter.initialLot
               tt-paramPrintCountingSheets.lote-fim     = ttRelatedActionsParameter.finalLot
               tt-paramPrintCountingSheets.localiz-ini  = ttRelatedActionsParameter.initialBinLocation
               tt-paramPrintCountingSheets.localiz-fim  = ttRelatedActionsParameter.finalBinLocation
               tt-paramPrintCountingSheets.depos-ini    = ttRelatedActionsParameter.initialWarehouse
               tt-paramPrintCountingSheets.depos-fim    = ttRelatedActionsParameter.finalWarehouse
               tt-paramPrintCountingSheets.estab-ini    = ttRelatedActionsParameter.initialSite
               tt-paramPrintCountingSheets.estab-fim    = ttRelatedActionsParameter.finalSite
               tt-paramPrintCountingSheets.ge-ini       = ttRelatedActionsParameter.initialInventoryGroup
               tt-paramPrintCountingSheets.ge-fim       = ttRelatedActionsParameter.finalInventoryGroup
               tt-paramPrintCountingSheets.ficha-ini    = ttRelatedActionsParameter.initialSheet
               tt-paramPrintCountingSheets.ficha-fim    = ttRelatedActionsParameter.finalSheet
               tt-paramPrintCountingSheets.data-corte   = ttRelatedActionsParameter.inventoryDate
               tt-paramPrintCountingSheets.ficha-etiq   = ttRelatedActionsParameter.printType
               tt-paramPrintCountingSheets.qt-bran      = ttRelatedActionsParameter.blankQtyToPrint
               tt-paramPrintCountingSheets.fic-ini      = ttRelatedActionsParameter.blankStartSheetNumber
               tt-paramPrintCountingSheets.epcValue     = ttRelatedActionsParameter.epcValue
               tt-paramPrintCountingSheets.l-imp-param  = TRUE
               tt-paramPrintCountingSheets.arquivo      = "CE0708FX.LST".
        
        RAW-TRANSFER tt-paramPrintCountingSheets TO raw-param.
        
        FOR EACH tt-raw-digita:
            DELETE tt-raw-digita.
        END.
        FOR EACH ttDigitaItem:
            CREATE tt-raw-digita.
            RAW-TRANSFER ttDigitaItem to tt-raw-digita.raw-digita.
        END.
        
        RUN inbo/boin157fxrpw.p (INPUT raw-param,
                                 INPUT TABLE tt-raw-digita,
                                 INPUT tt-paramPrintCountingSheets.arquivo,
                                 INPUT 'CE0708':U,
                                 INPUT 0708,
                                 INPUT 'cep/ce0708rp.p':U,
                                 OUTPUT cPedidoNum,
                                 OUTPUT TABLE RowErrors).

        create ttStringReturn.
        assign ttStringReturn.stringValue = cPedidoNum.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeCountingSheets DBOProgram 
PROCEDURE removeCountingSheets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM TABLE FOR ttCountingSheets.
DEF INPUT PARAM pCountingNumber AS INTEGER NO-UNDO.
DEF OUTPUT PARAM TABLE FOR RowErrors.

    def var h-handle as handle no-undo.

    empty temp-table tt-inventario.
  
    run inbo/boin157q01.p persistent set h-handle.
    run openQueryStatic in h-handle ("Inclui":U).
    FIND FIRST ttCountingSheets NO-LOCK NO-ERROR.
    Run setConstraintDataSaldo in h-handle (INPUT ttCountingSheets.inventoryDate).

    CodeBlock:
    DO  ON ERROR undo CodeBlock, LEAVE CodeBlock
        ON STOP  undo CodeBlock, LEAVE CodeBlock
        ON QUIT  undo CodeBlock, LEAVE CodeBlock:

        for each ttCountingSheets no-lock:

            empty temp-table RowErrorsAux.

            find first inventario
                where inventario.dt-saldo    = ttCountingSheets.inventoryDate
                and   inventario.nr-ficha    = ttCountingSheets.countingSheetNumber 
                and   inventario.it-codigo   = ttCountingSheets.item
                and   inventario.cod-estabel = ttCountingSheets.site exclusive-lock no-error.



            if (pCountingNumber = 1 and (inventario.val-apurado[2] <> ? or inventario.val-apurado[3] <> ?))
                or (pCountingNumber = 2 and inventario.val-apurado[3] <> ?) then do:
                create RowErrors.
                assign RowErrors.ErrorSequence = 0
                       RowErrors.ErrorNumber = 17006
                       RowErrors.ErrorType = "EMS":U
                       RowErrors.ErrorSubType = "ERROR":U.
                {utp/ut-liter.i Somente_Ç_poss°vel_remover_a_£ltima_contagem_da_ficha.}
                assign RowErrors.ErrorDescription = return-value.
                {utp/ut-liter.i Ficha}
                assign RowErrors.ErrorHelp = return-value + ": " + string(ttCountingSheets.countingSheetNumber).

                next.
            end.
    
            empty temp-table tt-inventario.
            run repositionRecord in h-handle (input rowid(inventario)).
            run emptyRowErrors   in h-handle.
    
            IF  inventario.situacao = 1 or (inventario.situacao = 3 and inventario.dt-atualiza <> ?) then do:
                /* Contagem n∆o pode ser eliminada, pois o registro j† foi atualizado */
                {utp/ut-liter.i Ficha}
                {method/svc/errors/inserr.i
                                &ErrorNumber="4977"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorHelp=return-value + ": " + string(ttCountingSheets.countingSheetNumber)}
                next.
            end.
            else do:   
    
                if  inventario.val-apurado[3] <> ? then do:
    
                    assign inventario.val-apurado[3] = ?.
    
                    create tt-inventario.
                    buffer-copy inventario to tt-inventario.
    
                    run setRecord           in h-handle (input table tt-inventario).
                    run setConstraintInclui in h-handle (2).
                    run piCalculaSaldo      in h-handle (input "update":U, input rowid(inventario)).
                    run getRowErrors        in h-handle (output table RowErrorsAux).

                end.
                else if  inventario.val-apurado[2] <> ? then do:
    
                    assign inventario.val-apurado[2] = ?.
    
                    create tt-inventario.
                    buffer-copy inventario to tt-inventario.
    
                    run setRecord           in h-handle (input table tt-inventario).
                    run setConstraintInclui in h-handle (1).
                    run piCalculaSaldo      in h-handle (input "update":U, input rowid(inventario)).
                    run getRowErrors        in h-handle (output table RowErrorsAux).

                end.
                else do:    
                    assign inventario.situacao       = 2
                           inventario.val-apurado    = ?
                           inventario.valor-mat-m[1] = 0
                           inventario.valor-mob-m[1] = 0
                           inventario.valor-ggf-m[1] = 0
                           inventario.valor-final    = 0.
                end.
            end.

            for each RowErrorsAux no-lock:
                create RowErrors.
                buffer-copy RowErrorsAux to RowErrors.
                {utp/ut-liter.i Ficha}
                assign RowErrors.ErrorHelp = return-value + ": " + string(ttCountingSheets.countingSheetNumber).
            end.

        end.

    end.

    DELETE PROCEDURE h-handle.
    ASSIGN h-handle = ?.


    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsCountingSheets DBOProgram 
PROCEDURE setDefaultsCountingSheets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM fieldName AS CHARACTER NO-UNDO.
DEF INPUT PARAM TABLE FOR ttCountingSheets.
DEF OUTPUT PARAM TABLE FOR ttCountingSheets2.
DEF OUTPUT PARAM TABLE FOR RowErrors.
DEF VARIABLE c-return         AS CHARACTER          NO-UNDO.
DEF VARIABLE c-un             AS CHARACTER          NO-UNDO.
DEF VARIABLE i-tipo-con-est   AS INTEGER            NO-UNDO.
DEF VARIABLE l-habilita       AS LOGICAL            NO-UNDO.
DEF VARIABLE l-loc-unica      AS LOGICAL            NO-UNDO.
DEF VARIABLE pl-localiza      AS LOGICAL INITIAL NO NO-UNDO.


    IF  NOT VALID-HANDLE(h-boin157q01) THEN DO:
        RUN inbo/boin157q01.p PERSISTENT SET h-boin157q01.
        FIND FIRST ttCountingSheets NO-LOCK NO-ERROR.
        Run setConstraintDataSaldo in h-boin157q01 (INPUT ttCountingSheets.inventoryDate).
        RUN openQueryStatic  IN h-boin157q01 (INPUT "Inclui":U)  NO-ERROR.
        IF CAN-FIND (FIRST RowErrors WHERE RowErrors.errorsubtype = "ERROR") THEN DO:
            RETURN "NOK":U.
        END.
    END.    
    
    IF  NOT VALID-HANDLE(h-boin172) THEN DO:
        RUN inbo/boin172.p PERSISTENT SET h-boin172.
        RUN openQueryStatic  IN h-boin172 (INPUT "Main":U)  NO-ERROR.
        IF CAN-FIND (FIRST RowErrors WHERE RowErrors.errorsubtype = "ERROR") THEN DO:
            RETURN "NOK":U.
        END.
    END.   

    FOR FIRST ttCountingSheets NO-LOCK:
        EMPTY TEMP-TABLE ttCountingSheets2.
        BUFFER-COPY ttCountingSheets TO ttCountingSheets2 NO-ERROR.
        FIND FIRST ttCountingSheets2 EXCLUSIVE-LOCK NO-ERROR.

        EMPTY TEMP-TABLE tt-inventario.
            
        CREATE tt-inventario.
        ASSIGN tt-inventario.cod-depos    = ttCountingSheets.warehouse 
            tt-inventario.cod-estabel     = ttCountingSheets.site 
            tt-inventario.cod-localiz     = ttCountingSheets.binLocation 
            tt-inventario.cod-refer       = ttCountingSheets.reference 
            tt-inventario.dt-saldo        = ttCountingSheets.inventoryDate 
            tt-inventario.dt-ult-saida    = ttCountingSheets.lotValidity 
            tt-inventario.it-codigo       = ttCountingSheets.item 
            tt-inventario.lote            = ttCountingSheets.lot 
            tt-inventario.nr-ficha        = ttCountingSheets.countingSheetNumber 
            tt-inventario.situacao        = ttCountingSheets.situation.
        
        run emptyRowObject     in h-boin157q01.
        run setRecord          in h-boin157q01 (input table tt-inventario).

    /*VALIDAÄ«O LEAVE DATA INVENTµRIO*/
        IF fieldName = "inventoryDateField" THEN DO:
            
            /* Sugere numero da ficha */
            DEFINE VAR i-nr-ficha AS INTEGER NO-UNDO.
            IF CAN-FIND(FIRST bf2{&TableName}) THEN DO:
                if valid-handle(h-boin157q01) and avail ttCountingSheets2 then do:
                    run piRetornaFicha in h-boin157q01 ( input ttCountingSheets.inventoryDate,
                                                         output i-nr-ficha,
                                                         output table RowErrors ).
                    assign ttCountingSheets2.countingSheetNumber = if i-nr-ficha <> 0 then i-nr-ficha
                                                                   else 1.
                END.
            END.
            RETURN "OK":U.
        END.
        
        /*VALIDAÄ«O LEAVE ITEM */
        IF fieldName = "itemField" THEN DO:
            if valid-handle(h-boin172) and valid-handle(h-boin157q01) then do:
                run goToKey in h-boin172 (input ttCountingSheets.item).
                    if return-value = "OK":U then do:
                        
                        /* Busca localicaá∆o padr∆o Item X Estab */
                        run getLocalizacao in h-boin157q01 (input ttCountingSheets.item, 
                                                            input ttCountingSheets.site,
                                                            output c-return).
                        ASSIGN ttCountingSheets2.binLocation = c-return.
                        
                        /* Busca unidade medida */
                        run getCharField in h-boin172 (input "un", output c-return).
                        ASSIGN ttCountingSheets2.unitOfMeasure = c-return.
                        
                        run getIntField in h-boin172 (input "tipo-con-est", output i-tipo-con-est).
                        /* Tipo Controle Estoque: 2 - por sÇrie
                                                  3 - por lote
                                                  4 - por referància */
                        if i-tipo-con-est = 2 or i-tipo-con-est = 3 or i-tipo-con-est = 4 then do:
                            ASSIGN ttCountingSheets2.enableLot = YES.
                                
                            if i-tipo-con-est = 3 or i-tipo-con-est = 4 then do:
                                ASSIGN ttCountingSheets2.enableLotValidity = YES.
                                    
                                if  ttCountingSheets.lotValidity <> ?  and
                                    ttCountingSheets.lot         <> "" then do:
                                    assign ttCountingSheets2.lotValidity = ?.
                                    ASSIGN ttCountingSheets2.enableLotValidity = NO.
                                END.
                            END.
                            
                            /* Habilita/desabilita referencia */
                            run piValidaReferSaldo in h-boin157q01 (input ttCountingSheets.item, 
                                                                    output l-habilita).


                                if l-habilita AND i-tipo-con-est = 4 THEN
                                    ASSIGN ttCountingSheets2.enableReference = YES.
                                else do:
                                    assign ttCountingSheets2.reference = ""
                                           ttCountingSheets2.enableReference = NO.
                                END.
                        END.
                        else do:
                            assign  ttCountingSheets2.reference     = ""
                                ttCountingSheets2.lot               = ""
                                ttCountingSheets2.lotValidity       = ?.
                            ASSIGN  ttCountingSheets2.enableLot     = NO
                                ttCountingSheets2.enableReference   = NO
                                ttCountingSheets2.enableLotValidity = NO.
                        END.
                        
                        /*  Habilita localizacao  */
                        
                        run piHabilitaCampos in h-boin157q01 (input "Create":U, input "cod-localiz":U, output l-habilita).
                            assign l-loc-unica = if l-habilita then no else yes.
                                if (l-loc-unica and pl-localiza) or not l-loc-unica THEN
                                    ASSIGN ttCountingSheets2.enableBinLocation = YES. 
                                ELSE
                                    ASSIGN ttCountingSheets2.enableBinLocation = NO.  
                                        
                                /* Busca referencia do saldo do estoque */
                                run piRetornaValor in (h-boin157q01) (input "Update":U, input "cod-refer":U, output c-return).
                                    if c-return <> "" then
                                        assign ttCountingSheets2.reference = c-return.
                                    
                                    /* Habilita data validade para itens controlados por lote e referencia e sem saldo */
                                    if i-tipo-con-est >= 3 and ttCountingSheets2.lotValidity = ? then 
                                        ASSIGN ttCountingSheets2.enableLotValidity = YES.
                                    ELSE
                                        ASSIGN ttCountingSheets2.enableLotValidity = NO.
                    END.
                        
                    else assign ttCountingSheets2.itemDescription = ""
                                ttCountingSheets2.lotValidity = ?
                                ttCountingSheets2.unitOfMeasure = "".
                    /* Verifica se o item Ç Obsoleto*/    
                    FOR FIRST item-uni-estab FIELDS(loc-unica cod-localiz data-ult-ent cod-obsoleto it-codigo)
                        WHERE item-uni-estab.it-codigo   = ttCountingSheets2.item  AND 
                        item-uni-estab.cod-estabel       = ttCountingSheets2.site NO-LOCK:
                        ASSIGN ttCountingSheets2.obsoleteItem = IF AVAIL item-uni-estab AND
                            item-uni-estab.cod-obsoleto = 4 THEN YES
                            ELSE NO. 
                    END.
            END.
            RETURN "OK":U.
        END.
    
    
    /* VALIDAÄ«O LEAVE ESTABELECIMENTO */
        IF fieldName = "siteField" THEN DO:
            
            assign c-return = "".

            /* Busca localicaá∆o padr∆o Item X Estab */
            if valid-handle(h-boin157q01) then do:
                /*  Habilita localizacao  */
                run piHabilitaCampos in h-boin157q01 (input "Create":U, input "cod-localiz":U, output l-habilita).
                assign l-loc-unica = if l-habilita then no else yes.
                    
                if (l-loc-unica and pl-localiza) or not l-loc-unica then
                    ASSIGN ttCountingSheets2.enableBinLocation = YES.
                ELSE 
                    ASSIGN ttCountingSheets2.enableBinLocation = NO. 
                    
                run getLocalizacao in h-boin157q01 (input ttCountingSheets.ITEM, 
                                                    input ttCountingSheets.site,
                                                    output c-return).
                ASSIGN ttCountingSheets2.BinLocation = c-return.
            END.
            /* Verifica se o item Ç Obsoleto*/    
            FOR FIRST item-uni-estab FIELDS(loc-unica cod-localiz data-ult-ent cod-obsoleto it-codigo)
                WHERE item-uni-estab.it-codigo   = ttCountingSheets2.item  AND
                item-uni-estab.cod-estabel       = ttCountingSheets2.site NO-LOCK:
                ASSIGN ttCountingSheets2.obsoleteItem = IF AVAIL item-uni-estab AND
                    item-uni-estab.cod-obsoleto = 4 THEN YES
                    ELSE NO. 
            END.

            RETURN "OK":U.
        END.

      
    /* VALIDAÄ«O LEAVE LOTE */
        IF fieldName = "lotField" THEN DO:

            if valid-handle(h-boin172) and valid-handle(h-boin157q01) then do:
                
                /* Busca data validade do saldo de estoque */
                RUN piRetornaValor IN (h-boin157q01) (INPUT "Update":U, INPUT "dt-vali-lote":U, OUTPUT c-return).
                assign ttCountingSheets2.lotValidity = date(c-return).
                    
                /* Busca referencia do saldo de estoque */
                RUN piRetornaValor IN (h-boin157q01) (INPUT "Update":U, INPUT "cod-refer":U, OUTPUT c-return).
                assign ttCountingSheets2.reference = c-return.
                    
                run getIntField in h-boin172 (input "tipo-con-est", output i-tipo-con-est).
                
                /* Habilita/desabilita "Referencia" */
                RUN piVerificaSaldo in h-boin157q01 (OUTPUT l-habilita).
                if l-habilita THEN
                    assign ttCountingSheets2.enableReference = l-habilita.
                else 
                    if i-tipo-con-est = 2 or i-tipo-con-est = 3 or i-tipo-con-est = 4 then do:
                        /* Habilita/desabilita referencia */
                        run piValidaReferSaldo in h-boin157q01 (input ttCountingSheets.item, 
                                                                output l-habilita).
                        if l-habilita then
                            ASSIGN ttCountingSheets2.enableReference = YES.
                        else 
                            ASSIGN ttCountingSheets2.enableReference = NO.
                    END.
                    
                    /* Habilita/desabilita "Dt Validade" */
                    run piHabilitaCampos in h-boin157q01 (input "Create":U, input "dt-vali-lote":U, output l-habilita).
                        
                    if l-habilita or (i-tipo-con-est >= 3 and ttCountingSheets.lotValidity = ?) then do:
                        ASSIGN ttCountingSheets2.lotValidity = ?.
                        ASSIGN ttCountingSheets2.enableLotValidity = YES.
                    END.
                    ELSE ASSIGN ttCountingSheets2.enableLotValidity = NO. 
                    
                    /* Busca data validade do saldo do estoque */
                    run piRetornaValor in (h-boin157q01) (input "Update":U, input "dt-vali-lote":U, output c-return).
                    if c-return <> "" then
                        ASSIGN ttCountingSheets2.lotValidity = date(c-return).
            END.
            RETURN "OK":U.
        END.
    END.       
    DELETE PROCEDURE h-boin157q01.
    ASSIGN h-boin157q01 = ?.

    DELETE PROCEDURE h-boin172.
    ASSIGN h-boin172 = ?.

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateCountingSheets DBOProgram 
PROCEDURE updateCountingSheets :
/*------------------------------------------------------------------------------ 
  Purpose: Atualiza o valor material, ggf e mob nas fichas de inventario
  Parameters:
  Notes:
------------------------------------------------------------------------------*/ 
    DEFINE INPUT  PARAM TABLE FOR ttInventoryCountParam .
        DEFINE INPUT  PARAM TABLE FOR ttItemWithoutValue .
    DEFINE OUTPUT PARAM TABLE FOR RowErrors .
   
    DEFINE VARIABLE da-fim-per-inv LIKE inventario.dt-saldo NO-UNDO.
    DEFINE VARIABLE da-mensal-ate  LIKE inventario.dt-saldo NO-UNDO.

    FOR FIRST param-estoq NO-LOCK. END.

    FOR FIRST ttInventoryCountParam NO-LOCK:
    END.
        

    FOR EACH ttItemWithoutValue NO-LOCK:

        FOR EACH {&TableName} NO-LOCK 
           WHERE {&TableName}.dt-saldo     = ttInventoryCountParam.inventoryDate
             AND {&TableName}.cod-estabel  = ttItemWithoutValue.site
             AND {&TableName}.cod-depos   >= ttInventoryCountParam.initialWarehouse
             AND {&TableName}.cod-depos   <= ttInventoryCountParam.finalWarehouse
             AND {&TableName}.cod-localiz >= ttInventoryCountParam.initialBinLocation
             AND {&TableName}.cod-localiz <= ttInventoryCountParam.finalBinLocation
             AND {&tablename}.it-codigo    = ttItemWithoutValue.ITEM
             AND ( {&TableName}.situacao = 2 OR
                   {&TableName}.situacao = 4 OR
                   {&TableName}.situacao = 3),
           EACH ITEM NO-LOCK
           WHERE ITEM.it-codigo  = {&TableName}.it-codigo
             AND ITEM.fm-codigo >= ttInventoryCountParam.initialFamily
             AND ITEM.fm-codigo <= ttInventoryCountParam.finalFamily
             AND ITEM.ge-codigo >= ttInventoryCountParam.initialInventoryGroup
             AND ITEM.ge-codigo <= ttInventoryCountParam.finalInventoryGroup
           BREAK BY {&TableName}.cod-estabel
                 BY {&TableName}.it-codigo:
     
            find item-estab
                where item-estab.it-codigo = inventario.it-codigo
                and   item-estab.cod-estabel = inventario.cod-estabel no-lock no-error.

            ASSIGN da-fim-per-inv = IF  MONTH({&TableName}.dt-saldo) = 12 THEN DATE(01,01,YEAR({&TableName}.dt-saldo) + 1) - 1
                                                                       ELSE DATE(MONTH({&TableName}.dt-saldo) + 1,01,
                                                                       YEAR({&TableName}.dt-saldo)) - 1.       
            
            FOR FIRST estabelec
                FIELDS ( cod-estabel   custo-contab )
                WHERE estabelec.cod-estabel = {&TableName}.cod-estabel NO-LOCK.
            END.
            
            &IF DEFINED(bf_mat_fech_estab) &THEN
                IF param-estoq.tp-fech = 2 THEN DO:
                    IF AVAIL estabelec THEN DO:
                        FOR FIRST estab-mat
                            FIELDS ( cod-estabel    mensal-ate )
                            WHERE estab-mat.cod-estabel = estabelec.cod-estabel NO-LOCK:
                        END.
                    END.
                    IF  AVAIL estab-mat THEN DO:
                        ASSIGN da-mensal-ate = estab-mat.mensal-ate.
                    END.
                END.
                ELSE DO:
                    ASSIGN da-mensal-ate = param-estoq.mensal-ate.
                END.
            &ELSE
                ASSIGN da-mensal-ate = param-estoq.mensal-ate.
            &ENDIF
    
            FIND FIRST movto-estoq 
                 WHERE movto-estoq.it-codigo   = {&TableName}.it-codigo
                   AND movto-estoq.cod-estabel = {&TableName}.cod-estabel 
                   AND movto-estoq.esp-docto   = 1
                   AND movto-estoq.dt-trans    > da-mensal-ate
                   AND movto-estoq.dt-trans   <= da-fim-per-inv NO-LOCK NO-ERROR.
    
            IF  NOT AVAIL movto-estoq AND AVAIL item THEN DO:
                FIND FIRST c-movto 
                     WHERE c-movto.it-codigo   = {&TableName}.it-codigo
                       AND c-movto.cod-estabel = {&TableName}.cod-estabel 
                       AND c-movto.esp-docto   = 21
                       AND c-movto.dt-trans    > da-mensal-ate
                       AND c-movto.dt-trans   <= da-fim-per-inv NO-LOCK NO-ERROR.

                IF NOT AVAIL c-movto 
                    AND (avail item and item.tipo-contr = 2)
    
                    AND (NOT AVAIL item-estab
                         OR (AVAIL item-estab
                              AND  item-estab.val-unit-mat-m[1] +
                                   item-estab.val-unit-mob-m[1] +
                                   item-estab.val-unit-ggf-m[1] = 0
                              AND  AVAIL estabelec 
                              AND estabelec.custo-contab = 1)
                         OR (AVAIL item-estab 
                              AND  item-estab.val-unit-mat-o[1] +
                                   item-estab.val-unit-mob-o[1] +
                                   item-estab.val-unit-ggf-o[1] = 0
                              AND  AVAIL estabelec 
                              AND  estabelec.custo-contab = 2)
                         OR (AVAIL item-estab
                              AND  item-estab.val-unit-mat-p[1] +
                                   item-estab.val-unit-mob-p[1] +
                                   item-estab.val-unit-ggf-p[1] = 0 
                              AND  AVAIL estabelec 
                              AND estabelec.custo-contab = 3) )
                        AND ({&TableName}.val-apurado[1] <> {&TableName}.qtidade-atu
                            OR  {&TableName}.val-apurado[2] <> {&TableName}.qtidade-atu
                            OR  {&TableName}.val-apurado[3] <> {&TableName}.qtidade-atu) 
    
                    AND ({&TableName}.valor-mat-m[1] + {&TableName}.valor-ggf-m[1] + {&TableName}.valor-mob-m[1] = 0) 
                    THEN DO:

                    FOR FIRST bf{&TableName}
                        WHERE rowid(bf{&TableName}) = ROWID({&TableName}) EXCLUSIVE-LOCK:

                        ASSIGN bf{&TableName}.valor-mat-m[1] = ttItemWithoutValue.materialAmount
                               bf{&TableName}.valor-ggf-m[1] = ttItemWithoutValue.laborAmount
                               bf{&TableName}.valor-mob-m[1] = ttItemWithoutValue.onhandAmount.

                    END.

                    RELEASE bf{&TableName}.

                END.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateInventory DBOProgram 
PROCEDURE updateInventory :
/*------------------------------------------------------------------------------ 
  Purpose:     Executa o programa ce0703rp para atualizacao do inventario
  Parameters:                                       
  Notes:                                                                         
------------------------------------------------------------------------------*/ 
    define INPUT  parameter table for ttRelatedActionsParameter.
    def input  param table for ttDigitaSite.
    define OUTPUT parameter table for ttStringReturn.
    define OUTPUT parameter table for RowErrors.

    DEFINE VARIABLE cPedidoNum AS CHARACTER   NO-UNDO.

    empty temp-table ttStringReturn.

    for first ttRelatedActionsParameter no-lock:

        /*run verifyItemsWithoutValueForReport.
        if return-value = "NOK":U then do:
            create ttStringReturn.
            assign ttStringReturn.stringValue = '-1'.
            return "OK":U.
        end.*/

            
        create tt-paramUpdateInventory.
        assign tt-paramUpdateInventory.usuario     = v_cod_usuar_corren
               tt-paramUpdateInventory.destino     = 2
               tt-paramUpdateInventory.data-exec   = today
               tt-paramUpdateInventory.hora-exec   = time
               tt-paramUpdateInventory.c-destino   = SESSION:TEMP-DIRECTORY
               tt-paramUpdateInventory.c-estab-ini = ttRelatedActionsParameter.initialSite
               tt-paramUpdateInventory.c-estab-fim = ttRelatedActionsParameter.finalSite
               tt-paramUpdateInventory.c-depos-ini = ttRelatedActionsParameter.initialWarehouse
               tt-paramUpdateInventory.c-depos-fim = ttRelatedActionsParameter.finalWarehouse
               tt-paramUpdateInventory.i-ficha-ini = ttRelatedActionsParameter.initialSheet
               tt-paramUpdateInventory.i-ficha-fim = ttRelatedActionsParameter.finalSheet
               tt-paramUpdateInventory.c-item-ini  = ttRelatedActionsParameter.initialItem
               tt-paramUpdateInventory.c-item-fim  = ttRelatedActionsParameter.finalItem
               tt-paramUpdateInventory.da-corte    = ttRelatedActionsParameter.inventoryDate
               tt-paramUpdateInventory.da-trans    = ttRelatedActionsParameter.updateDate
               tt-paramUpdateInventory.i-atual     = ttRelatedActionsParameter.updateType
               /*tt-paramUpdateInventory.c-conta-ent = 
               tt-paramUpdateInventory.c-conta-sai = */
               tt-paramUpdateInventory.l-imp-param = true
               tt-paramUpdateInventory.arquivo     = "CE0703FX.LST".
        
        raw-transfer tt-paramUpdateInventory to raw-param.
        
        for each tt-raw-digita:
            delete tt-raw-digita.
        end.
        for each ttDigitaSite:
            create tt-raw-digita.
            raw-transfer ttDigitaSite to tt-raw-digita.raw-digita.
        end.
        
        run inbo/boin157fxrpw.p (input raw-param,
                                 input table tt-raw-digita,
                                 input tt-paramUpdateInventory.arquivo,
                                 input 'CE0703':U,
                                 input 0703,
                                 input 'cep/ce0703rp.p':U,
                                 output cPedidoNum,
                                 output table RowErrors).
        
        create ttStringReturn.
        assign ttStringReturn.stringValue = cPedidoNum.

    end.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getInventarioByFilter DBOProgram
PROCEDURE getInventarioByFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR ttParamMD.
    DEFINE OUTPUT PARAMETER piTotalRecord  AS INTEGER.
    DEFINE OUTPUT PARAMETER TABLE FOR ttInventarioMD.
    
    find first ttParamMD no-error.
    
    assign piTotalRecord = 0.
        
    FOR EACH inventario 
        FIELDS ( nr-ficha it-codigo cod-estabel cod-depos cod-localiz
                 lote cod-refer  valor-contab situacao dt-atualiza
                 cod-confte-contag-1 cod-confte-contag-2 cod-confte-contag-3
                 val-apurado[1] val-apurado[2] val-apurado[3])
        WHERE inventario.dt-saldo     = ttParamMD.dtSaldo
        AND   inventario.nr-ficha    >= ttParamMD.nrFichaIni
        AND   inventario.nr-ficha    <= ttParamMD.nrFichaFim
        AND   inventario.cod-estabel   >= ttParamMD.codEstabelIni
        AND   inventario.cod-estabel   <= ttParamMD.codEstabelFim
        AND   inventario.cod-depos   >= ttParamMD.codDeposIni
        AND   inventario.cod-depos   <= ttParamMD.codDeposFim
        AND   inventario.cod-localiz >= ttParamMD.codLocalizIni
        AND   inventario.cod-localiz <= ttParamMD.codLocalizFim
        AND   inventario.it-codigo   >= ttParamMD.itCodigoIni
        AND   inventario.it-codigo   <= ttParamMD.itCodigoFim
        AND   inventario.lote        >= ttParamMD.loteIni
        AND   inventario.lote        <= ttParamMD.loteFim NO-LOCK
           BY inventario.cod-estabel 
           BY inventario.nr-ficha
           BY inventario.it-codigo:
        
        IF  (inventario.cod-confte-contag-1 < ttParamMD.codConfteContagIni
          OR inventario.cod-confte-contag-1 > ttParamMD.codConfteContagFim)
        AND (inventario.cod-confte-contag-2 < ttParamMD.codConfteContagIni
          OR inventario.cod-confte-contag-2 > ttParamMD.codConfteContagFim)
        AND (inventario.cod-confte-contag-3 < ttParamMD.codConfteContagIni
          OR inventario.cod-confte-contag-3 > ttParamMD.codConfteContagFim) THEN NEXT.
		
		IF  NOT AVAIL ITEM
		OR (    AVAIL ITEM 
			AND ITEM.it-codigo <> inventario.it-codigo) THEN
			FOR FIRST ITEM
				FIELDS (fm-codigo ge-codigo it-codigo desc-item un)
				WHERE ITEM.it-codigo = inventario.it-codigo NO-LOCK:
			END.
		IF ITEM.fm-codigo < ttParamMD.fmCodigoIni
		OR ITEM.fm-codigo > ttParamMD.fmCodigoFim THEN NEXT.
		IF ITEM.ge-codigo < ttParamMD.geCodigoIni
		OR ITEM.ge-codigo > ttParamMD.geCodigoFim THEN NEXT.
		
        find first bloq-movto-item-depos 
             where bloq-movto-item-depos.cod-estabel = inventario.cod-estabel
               and bloq-movto-item-depos.it-codigo   = inventario.it-codigo
               and bloq-movto-item-depos.cod-depos   = inventario.cod-depos no-lock no-error.
               
		find first tab-unidade
			where tab-unidade.un = item.un no-lock no-error.
             
        assign piTotalRecord = piTotalRecord + 1.
        
        create ttInventarioMD.
        assign ttInventarioMD.nrFicha          = inventario.nr-ficha
               ttInventarioMD.itCodigo         = inventario.it-codigo
               ttInventarioMD.descItem         = item.desc-item
               ttInventarioMD.codEstabel       = inventario.cod-estabel
               ttInventarioMD.codDepos         = inventario.cod-depos
               ttInventarioMD.codLocaliz       = inventario.cod-localiz
               ttInventarioMD.lote             = inventario.lote
               ttInventarioMD.codRefer         = inventario.cod-refer
               ttInventarioMD.valorContab      = inventario.valor-contab
               ttInventarioMD.un               = item.un
               ttInventarioMD.codConfteContag1 = inventario.cod-confte-contag-1
               ttInventarioMD.valApurado1      = STRING(inventario.val-apurado[1])
               ttInventarioMD.codConfteContag2 = inventario.cod-confte-contag-2
               ttInventarioMD.valApurado2      = STRING(inventario.val-apurado[2])
               ttInventarioMD.codConfteContag3 = inventario.cod-confte-contag-3
               ttInventarioMD.valApurado3      = STRING(inventario.val-apurado[3])
               ttInventarioMD.situacao         = {ininc/i01in157.i 04 inventario.situacao}
               ttInventarioMD.situacaoInt      = inventario.situacao
               ttInventarioMD.dtAtualiza       = inventario.dt-atualiza
               ttInventarioMD.dtSaldo          = inventario.dt-saldo.
               
        if avail bloq-movto-item-depos then
            assign ttInventarioMD.itemDepBloq    = STRING(bloq-movto-item-depos.dat-inic-bloq) + " " + STRING(bloq-movto-item-depos.hra-inic-bloq, "99:99:99").
        
        if avail tab-unidade then
            assign ttInventarioMD.descTabUnidade = tab-unidade.descricao.

    END.                                                                 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alteraInvetario DBOProgram
PROCEDURE alteraInvetario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER TABLE FOR ttInventarioMD.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
    for each ttInventarioMD:
        
    FOR FIRST inventario 
        WHERE inventario.dt-saldo    = ttInventarioMD.dtSaldo
          and inventario.cod-estabel = ttInventarioMD.codEstabel
          and inventario.cod-depos   = ttInventarioMD.codDepos 
          and inventario.cod-localiz = ttInventarioMD.codLocaliz
          and inventario.lote        = ttInventarioMD.lote     
          and inventario.it-codigo   = ttInventarioMD.itCodigo
          and inventario.cod-refer   = ttInventarioMD.codRefer EXCLUSIVE-LOCK:
        IF  ttInventarioMD.codConfteContag1 <> ?
        AND ttInventarioMD.codConfteContag1 <> "" THEN 
            ASSIGN inventario.cod-confte-contag-1 = ttInventarioMD.codConfteContag1.
        IF  ttInventarioMD.codConfteContag2 <> ?
        AND ttInventarioMD.codConfteContag2 <> "" THEN 
            ASSIGN inventario.cod-confte-contag-2 = ttInventarioMD.codConfteContag2.
        IF  ttInventarioMD.codConfteContag3 <> "" 
        AND ttInventarioMD.codConfteContag3 <> ? THEN
            ASSIGN inventario.cod-confte-contag-3 = ttInventarioMD.codConfteContag3.
    END.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

  
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaConferente DBOProgram
PROCEDURE atualizaConferente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER TABLE FOR ttParamMD.
    DEFINE INPUT PARAMETER TABLE FOR ttInventarioMD.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    find first ttInventarioMD no-error.
    find first ttParamMD no-error.
    
    FOR EACH inventario 
        FIELDS ( it-codigo cod-estabel cod-depos cod-localiz
                 lote cod-refer dt-saldo cod-confte-contag-1 
                 cod-confte-contag-2 cod-confte-contag-3)
        WHERE inventario.dt-saldo     = ttParamMD.dtSaldo
        AND   inventario.nr-ficha    >= ttParamMD.nrFichaIni
        AND   inventario.nr-ficha    <= ttParamMD.nrFichaFim
        AND   inventario.cod-estabel   >= ttParamMD.codEstabelIni
        AND   inventario.cod-estabel   <= ttParamMD.codEstabelFim
        AND   inventario.cod-depos   >= ttParamMD.codDeposIni
        AND   inventario.cod-depos   <= ttParamMD.codDeposFim
        AND   inventario.cod-localiz >= ttParamMD.codLocalizIni
        AND   inventario.cod-localiz <= ttParamMD.codLocalizFim
        AND   inventario.it-codigo   >= ttParamMD.itCodigoIni
        AND   inventario.it-codigo   <= ttParamMD.itCodigoFim
        AND   inventario.lote        >= ttParamMD.loteIni
        AND   inventario.lote        <= ttParamMD.loteFim
        AND   (inventario.situacao = 2 OR inventario.situacao = 4) EXCLUSIVE-LOCK ON STOP UNDO, LEAVE:
				  
		IF  (inventario.cod-confte-contag-1 < ttParamMD.codConfteContagIni
          OR inventario.cod-confte-contag-1 > ttParamMD.codConfteContagFim)
        AND (inventario.cod-confte-contag-2 < ttParamMD.codConfteContagIni
          OR inventario.cod-confte-contag-2 > ttParamMD.codConfteContagFim)
        AND (inventario.cod-confte-contag-3 < ttParamMD.codConfteContagIni
          OR inventario.cod-confte-contag-3 > ttParamMD.codConfteContagFim) THEN NEXT.		  
				  
        IF  NOT AVAIL ITEM
        OR (    AVAIL ITEM 
            AND ITEM.it-codigo <> inventario.it-codigo) THEN
            FOR FIRST ITEM
                FIELDS (fm-codigo ge-codigo it-codigo desc-item un)
                WHERE ITEM.it-codigo = inventario.it-codigo NO-LOCK:
            END.
        IF ITEM.fm-codigo < ttParamMD.fmCodigoIni
        OR ITEM.fm-codigo > ttParamMD.fmCodigoFim THEN NEXT.
        IF ITEM.ge-codigo < ttParamMD.geCodigoIni
        OR ITEM.ge-codigo > ttParamMD.geCodigoFim THEN NEXT.
       
        IF  inventario.val-apurado[1] = ?
        AND ttInventarioMD.codConfteContag1 <> ?
        AND ttInventarioMD.codConfteContag1 <> "" THEN 
            ASSIGN inventario.cod-confte-contag-1 = ttInventarioMD.codConfteContag1.
        IF  inventario.val-apurado[2] = ?
        AND ttInventarioMD.codConfteContag2 <> ?
        AND ttInventarioMD.codConfteContag2 <> "" THEN 
            ASSIGN inventario.cod-confte-contag-2 = ttInventarioMD.codConfteContag2.
        IF ttInventarioMD.codConfteContag3 <> "" 
        AND ttInventarioMD.codConfteContag3 <> ? THEN
            ASSIGN inventario.cod-confte-contag-3 = ttInventarioMD.codConfteContag3.
               
    END.
    DELETE PROCEDURE h-boin157q01.
    ASSIGN h-boin157q01 = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createUpdateCount DBOProgram
PROCEDURE createUpdateCount :
/*------------------------------------------------------------------------------
  Purpose:     Atualizar as fichas de invent†rio recebidas pelo adapter de 
               integraá∆o.
  Parameters:  tt-inventario-adapter = tabela com as informaá‰es da ficha a ser 
               atualizada.
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-inventario-adapter.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FIND FIRST tt-inventario-adapter NO-ERROR.

    IF  NOT VALID-HANDLE(h-boin157q01) THEN DO:
        RUN inbo/boin157q01.p PERSISTENT SET h-boin157q01.
        Run setConstraintDataSaldo in h-boin157q01 (INPUT tt-inventario-adapter.dt-saldo).
        RUN openQueryStatic  IN h-boin157q01 (INPUT "Inclui":U)  NO-ERROR.    
        IF CAN-FIND (FIRST RowErrors WHERE RowErrors.errorsubtype = "ERROR") THEN DO:
            RETURN "NOK":U.
        END.
    END.

    if tt-inventario-adapter.lote = ? then 
		assign tt-inventario-adapter.lote = "".	
	
    RUN emptyRowObject IN h-boin157q01.
    RUN goToKey IN h-boin157q01 (INPUT tt-inventario-adapter.dt-saldo,
                                 INPUT tt-inventario-adapter.cod-estabel,
                                 INPUT tt-inventario-adapter.cod-depos,
                                 INPUT tt-inventario-adapter.cod-localiz,
                                 INPUT tt-inventario-adapter.lote,
                                 INPUT tt-inventario-adapter.it-codigo,
                                 INPUT tt-inventario-adapter.cod-refer).
	
	/*CASO A FICHA Jµ EXISTA SERµ APENAS ATUALIZADO O VALOR DIGITADO E O CONFERENTE*/
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN updateCount IN THIS-PROCEDURE (INPUT TABLE tt-inventario-adapter,
                                           OUTPUT TABLE RowErrors).
    END.
    /*CASO A FICHA N«O EXISTA SERµ CRIADA*/
    ELSE DO:
        FIND FIRST ITEM 
             WHERE ITEM.it-codigo = tt-inventario-adapter.it-codigo NO-LOCK NO-ERROR.

        CREATE ttCountingSheets.
        ASSIGN ttCountingSheets.warehouse                 = tt-inventario-adapter.cod-depos 
               ttCountingSheets.site                      = tt-inventario-adapter.cod-estabel 
               ttCountingSheets.item                      = tt-inventario-adapter.it-codigo
               ttCountingSheets.binLocation               = tt-inventario-adapter.cod-localiz 
               ttCountingSheets.lot                       = tt-inventario-adapter.lote 
               ttCountingSheets.reference                 = tt-inventario-adapter.cod-refer 
               ttCountingSheets.situation                 = tt-inventario-adapter.situacao 
               ttCountingSheets.countingSheetNumber       = tt-inventario-adapter.nr-ficha 
               ttCountingSheets.itemDescription           = if avail item then ITEM.desc-item else ""
               ttCountingSheets.inventoryDate             = tt-inventario-adapter.dt-saldo
               ttCountingSheets.quantity                  = tt-inventario-adapter.val-apurado[1].
                                                                
		RUN addCountingSheets IN THIS-PROCEDURE (INPUT TABLE  ttCountingSheets,
                                     OUTPUT TABLE RowErrors).
        /*AP‡S A CRIAÄ«O DA FICHA SERµ ATUALIZADO O VALOR DIGITADO E O CONFERENTE*/
        RUN updateCount IN THIS-PROCEDURE (INPUT TABLE tt-inventario-adapter,
                                           OUTPUT TABLE RowErrors).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateCount DBOProgram
PROCEDURE updateCount :
/*------------------------------------------------------------------------------
  Purpose:     Atualizar as contagens das fichas de invent†rio recebidas pelo 
               adapter de integraá∆o.
  Parameters:  tt-inventario-adapter = tabela com as informaá‰es da ficha a ser 
               atualizada.
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-inventario-adapter.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE r-rowid-aux AS ROWID       NO-UNDO.
    
    IF  NOT VALID-HANDLE(h-boin157q01) THEN DO:
        RUN inbo/boin157q01.p PERSISTENT SET h-boin157q01.
        FIND FIRST tt-inventario-adapter NO-ERROR.
        RUN inbo/boin157q01.p PERSISTENT SET h-boin157q01.
        Run setConstraintDataSaldo in h-boin157q01 (INPUT tt-inventario-adapter.dt-saldo).
        RUN openQueryStatic  IN h-boin157q01 (INPUT "Inclui":U)  NO-ERROR.    
        IF CAN-FIND (FIRST RowErrors WHERE RowErrors.errorsubtype = "ERROR") THEN DO:
            RETURN "NOK":U.
        END.
    END.

    for each tt-inventario-adapter:
        RUN emptyRowObject IN h-boin157q01.
        RUN goToKey IN h-boin157q01 (INPUT tt-inventario-adapter.dt-saldo,
                                     INPUT tt-inventario-adapter.cod-estabel,
                                     INPUT tt-inventario-adapter.cod-depos,
                                     INPUT tt-inventario-adapter.cod-localiz,
                                     INPUT tt-inventario-adapter.lote,
                                     INPUT tt-inventario-adapter.it-codigo,
                                     INPUT tt-inventario-adapter.cod-refer).
        
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getRecord IN h-boin157q01 (OUTPUT TABLE tt-inventario-aux).
            FOR FIRST tt-inventario-aux:
			
                IF tt-inventario-adapter.val-apurado[1] <> ? THEN
                    ASSIGN tt-inventario-aux.val-apurado[1] = tt-inventario-adapter.val-apurado[1].
                IF tt-inventario-adapter.val-apurado[2] <> ? THEN
				    ASSIGN tt-inventario-aux.val-apurado[2] = tt-inventario-adapter.val-apurado[2].                
				IF tt-inventario-adapter.val-apurado[3] <> ? THEN
                    ASSIGN tt-inventario-aux.val-apurado[3] = tt-inventario-adapter.val-apurado[3].
					
				IF  tt-inventario-adapter.cod-confte-contag-1 <> "" 
				AND tt-inventario-adapter.cod-confte-contag-1 <> ? THEN
					ASSIGN tt-inventario-aux.cod-confte-contag-1 = tt-inventario-adapter.cod-confte-contag-1.
				
				IF  tt-inventario-adapter.cod-confte-contag-2 <> "" 
				AND tt-inventario-adapter.cod-confte-contag-2 <> ? THEN
					ASSIGN tt-inventario-aux.cod-confte-contag-2 = tt-inventario-adapter.cod-confte-contag-2.
				
				IF  tt-inventario-adapter.cod-confte-contag-3 <> "" 
				AND tt-inventario-adapter.cod-confte-contag-3 <> ? THEN
					ASSIGN tt-inventario-aux.cod-confte-contag-3 = tt-inventario-adapter.cod-confte-contag-3.
                
                RUN emptyRowObject      IN h-boin157q01.
                RUN setRecord           IN h-boin157q01 (INPUT TABLE tt-inventario-aux).
                RUN updateRecord        IN h-boin157q01.
                
                IF RETURN-VALUE = "NOK":U THEN DO:
                    RUN getRowErrors IN h-boin157q01 (OUTPUT TABLE RowErrorsAux).
                END.

                IF NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                    /* Atualiza saldo */
                    RUN getRowid       in h-boin157q01 (output r-rowid-aux).
                    RUN piCalculaSaldo in h-boin157q01 (input "UPDATE":U, input r-rowid-aux).
                    RUN getRowErrors   in h-boin157q01 (output table RowErrors).
                END.

                for each RowErrorsAux no-lock:
                    create RowErrors.
                    buffer-copy RowErrorsAux to RowErrors.
                    {utp/ut-liter.i Erro_ocorrido_na_digitaá∆o_da_ficha}
                    assign RowErrors.ErrorHelp = return-value + ": " + string(tt-inventario-adapter.nr-ficha).
                end.
            END.
        END.
        ELSE DO:
            {utp/ut-liter.i "N∆o_foi_possivel_encontrar_a_ficha:_" *}
            CREATE RowErrors.
            ASSIGN RowErrors.ErrorNumber = 17006
                   RowErrors.ErrorDescription = RETURN-VALUE + String(tt-inventario-adapter.nr-ficha).
        END.
    end.
    DELETE PROCEDURE h-boin157q01.
    ASSIGN h-boin157q01 = ?.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE findEpc :
DEFINE OUTPUT PARAM foundEpc AS LOGICAL.

    if c-nom-prog-dpc-mg97  <> "" or
       c-nom-prog-appc-mg97 <> "" or 
       c-nom-prog-upc-mg97  <> "" then 
        ASSIGN foundEpc = YES.

    RETURN "OK".
END PROCEDURE.
