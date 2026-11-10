&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-relat 
/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0101 2.00.00.050 } /*** "010050" 19/08/2026 14:49:30 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0101 MIM}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessadores do Template de Relat¢rio                            */
/* Obs: Retirar o valor do preprocessador para as p ginas que nÆo existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA f-pg-cla
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGDIG 
&GLOBAL-DEFINE PGIMP 

&glob bf_nr_nota yes /*Pre-processador utilizado no aumento do formato da nota fiscal*/

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{cdp/cdcfgmat.i} /* pre-processadores */
{cdp/cdcfgcex.i} /*Include de Pr‚-Processadores*/
{include/i_dbvers.i} /*Include de Pr‚-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar valida‡Æo produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
    {cdp/cdapi558.i1}
&endif

{utp/ut-glob.i}

{include/boerrtab.i}
{imp/im0101.i tt-param-im0101}
{cxbo/bocx310a.i tt-desp-embarque}
{cxbo/bocx310a.i tt-desp-embarque-aux}
{cxbo/bocx220h.i tt-selecao-embarque}
{adbo/boad107.i tt-estabelec}
{cxbo/bocx250.i tt-param-imp}
{dibo/bodi01141.i tt-relacto-tributo}

{rep/reapi190a.i} /*definicao tt-docum-est*/
{cdp/cd0667.i -conting-nfe}  /*DEFINI€ÇO tt-erro-conting-nfe*/
{imp/im0400.i} /*Temp Tables - tt-desp-rateio-item*/
define temp-table tt-docum-est-atu-aux NO-UNDO like tt-docum-est.

define variable l-ok                     as logical                     no-undo.
define variable l-formato                as logical                     no-undo.
define variable c-arq-digita             as char                        no-undo.
define variable c-terminal               as char                        no-undo.
define variable hProgramZoom             as handle                      no-undo.
define variable hShowMsg                 as handle                      no-undo.
define variable i-cont                   as int                         no-undo.
define variable c-formato                as char                        no-undo.
define variable l-criou                  as logical                     no-undo initial no.
define variable l-verifica-erro          as logical                     no-undo initial no.
define variable c-num-embarque           LIKE embarque-imp.embarque     no-undo.
define variable l-chama-carregado        as log                         no-undo initial no.
define variable h-im0101a                as handle                      no-undo.          
define variable c-embarque-ini           LIKE embarque-imp.embarque     no-undo. 
define variable c-embarque-fim           LIKE embarque-imp.embarque     no-undo initial "ZZZZZZZZZZZZZZZZ". 
define variable i-num-di-ems-ini         as int  format ">>>>>>>>9"     no-undo.    
define variable i-num-di-ems-fim         as int  format ">>>>>>>>9"     NO-UNDO INITIAL "999999999".  
define variable l-desembarque-parcial    as log                         no-undo. 
define variable dt-nacionalizacao-ini    as date format "99/99/9999"    no-undo initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF. 
define variable dt-nacionalizacao-fim    as date format "99/99/9999"    no-undo initial 12/31/9999. 
define variable c-container-ini          as char format "x(20)"         no-undo.                              
define variable c-container-fim          as char format "x(20)"         no-undo initial "ZZZZZZZZZZZZZZZZZZZZ". 
define variable c-processo-ini           as char format "x(12)"         no-undo.                              
define variable c-processo-fim           as char format "x(12)"         no-undo initial "ZZZZZZZZZZZZ".       
define variable c-declaracao-imp-ini     as char format "x(20)"         no-undo.                              
define variable c-declaracao-imp-fim     as char format "x(20)"         no-undo initial "ZZZZZZZZZZZZZZZZZZZZ". 
define variable dt-di-ini                as date format "99/99/9999"    no-undo initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF.                
define variable dt-di-fim                as date format "99/99/9999"    no-undo initial 12/31/9999.           
define variable i-itinerario-ini         as int  format ">>,>>9"        no-undo.                              
define variable i-itinerario-fim         as int  format ">>,>>9"        no-undo initial 99999.                
define variable i-exportador-ini         as int  format ">>>>>>>>9"     no-undo.                              
define variable i-exportador-fim         as int  format ">>>>>>>>9"     no-undo initial 999999999.            
define variable i-localizacao            as int  format ">>,>>9"        no-undo.                              
define variable dt-chegada-ini           as date format "99/99/9999"    no-undo initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF.                
define variable dt-chegada-fim           as date format "99/99/9999"    no-undo initial 12/31/9999.           
define variable c-veiculo-transp-ini     as char format "x(20)"         no-undo.                              
define variable c-veiculo-transp-fim     as char format "x(20)"         no-undo initial "ZZZZZZZZZZZZZZZZZZZZ". 
define variable c-nr-conhecto-master-ini as char format "x(25)"         no-undo.                              
define variable c-nr-conhecto-master-fim as char format "x(25)"         no-undo initial "ZZZZZZZZZZZZZZZZZZZZZZZZZ". 
define variable c-nr-conhecto-house-ini  as char format "x(25)"         no-undo.                              
define variable c-nr-conhecto-house-fim  as char format "x(25)"         no-undo initial "ZZZZZZZZZZZZZZZZZZZZZZZZZ". 
define variable c-nr-conhecto-ini        as char format "x(18)"         no-undo.                              
define variable c-nr-conhecto-fim        as char format "x(18)"         no-undo initial "ZZZZZZZZZZZZZZZZZZ".     
define variable l-possui-reg-marcado     as log                         no-undo.
define variable h-bocx220h               as handle                      no-undo.
define variable cod-desp-ini             as int format ">>,>>9"         no-undo.
define variable cod-desp-fim             as int format ">>,>>9"         no-undo initial 99999.
define variable fornec-desp-ini          as int format ">>>>>>>>9"      no-undo.
define variable fornec-desp-fim          as int format ">>>>>>>>9"      no-undo initial 999999999.
define variable pto-controle-ini         as int format ">>,>>9"         no-undo.
define variable pto-controle-fim         as int format ">>,>>9"         no-undo initial 99999.
define variable l-ok-c                   as log                         no-undo initial no.
define variable h-bocx310a               as handle                      no-undo.
define variable c-embarque-anterior      LIKE embarque-imp.embarque     no-undo initial ?.
define variable c-di-anterior            as CHAR format "x(20)"         NO-UNDO.
define variable i-num-reg                as int                         no-undo.
define variable cdiembarqueframe         as char                        no-undo.
define variable c-tipo-geracao           as char                        no-undo.
define variable ccod-observacao          as char                        no-undo.
define variable ctributacao-ipi          as char                        no-undo.
define variable ctributacao-icms         as char                        no-undo.
define variable ctributacao-pis          as char                        no-undo.
define variable ctributacao-cofins       as char                        no-undo.
define variable cvalormercad             as char                        no-undo.
define variable cdescricaodesp           as char                        no-undo.
define new global shared variable adm-broker-hdl as handle              no-undo.
define variable l-executar               as log                         no-undo.
define variable h-bocx095                as handle                      no-undo.
define variable h-bocx310                as handle                      no-undo.
DEFINE VARIABLE h-bocx250                AS HANDLE                      NO-UNDO.
DEFINE VARIABLE i-empresa                LIKE param-global.empresa-prin NO-UNDO.
DEFINE VARIABLE i-empresa-prin           LIKE param-global.empresa-prin NO-UNDO.  
define variable c-formato-nf             as char format "x(16)":U       no-undo.
DEFINE VARIABLE i-num-di-ems-aux         LIKE decla-import.num-di-ems   NO-UNDO.
DEFINE VARIABLE nr-docto-aux             LIKE docum-est.nro-docto       NO-UNDO.
DEFINE VARIABLE nr-docto-old             LIKE docum-est.nro-docto       NO-UNDO.
DEFINE VARIABLE c-mensagem               AS CHAR FORMAT "x(300)"        NO-UNDO.
DEFINE VARIABLE i-count                  AS INTEGER                     NO-UNDO.
DEFINE VARIABLE l-format-out             AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE c-numeros                AS CHAR INITIAL "0123456789"   NO-UNDO.
DEFINE VARIABLE c-return                 AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE log-nfse-nacional        AS LOGICAL                     NO-UNDO.

/* NFE */
define variable l-spp-nfe                as log                         no-undo.
DEFINE VARIABLE l-emitente-nfe           AS LOG                         NO-UNDO.
DEFINE VARIABLE c-chave-nfe              AS CHAR FORMAT "x(60)"         NO-UNDO.

DEF VAR h-bocx383                        AS   HANDLE                    NO-UNDO.
DEF VAR i-num-di-ems                     LIKE decla-import.num-di-ems   NO-UNDO.
DEF VAR c-cod-estab                      AS   CHARACTER                 NO-UNDO.
DEF VAR data-di                          AS   DATE                      NO-UNDO.
DEF VAR conta                            AS   CHARACTER                 NO-UNDO.
DEF VAR h-bocx403                        AS   HANDLE                    NO-UNDO.
DEF VAR i-fornec                         AS   INTEGER                   NO-UNDO.
DEF VAR l-embarque-invalido              AS   LOG                       NO-UNDO.
DEF VAR l-nota-fat                       AS   LOG                       NO-UNDO.
DEF VAR h-bocx402                        AS HANDLE                      NO-UNDO.
DEF VAR l-encontrou                      AS LOGICAL                     NO-UNDO.
DEF VAR vdat-di                          AS DATE                        NO-UNDO.
DEF VAR vnat-operacao                    AS CHARACTER                   NO-UNDO.
DEF VAR h-bocx220a                       AS HANDLE                      NO-UNDO.
DEF VAR llog-situacao                    AS LOGICAL                     NO-UNDO.
DEF VAR ccalculo-faltante                AS CHARACTER                   NO-UNDO.
def stream relat-acomp.

DEFINE VARIABLE cValSensi     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cValInsensi   AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-old-natureza     AS   CHAR                             NO-UNDO.
DEFINE VARIABLE h-cdapi1005        AS   HANDLE                           NO-UNDO.
DEFINE VARIABLE dAliq              LIKE relacto-tributo.aliquota         NO-UNDO.
DEFINE VARIABLE dPercDifer         LIKE relacto-tributo.perc-diferido    NO-UNDO.
DEFINE VARIABLE dPercRed           LIKE relacto-tributo.perc-red         NO-UNDO.
DEFINE VARIABLE dPercCredPresum    LIKE relacto-tributo.perc-cred-presum NO-UNDO.
DEFINE VARIABLE vnum-di-siscomex   LIKE decla-import.cod-di-siscomex     NO-UNDO.
DEFINE VARIABLE d-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts    NO-UNDO.
DEFINE VARIABLE dAliqDeson         AS   DECIMAL                          NO-UNDO.
DEFINE VARIABLE dPercRedAliqGov    AS   DECIMAL                          NO-UNDO.   
DEFINE VARIABLE l-nt2024002        AS LOGICAL  NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002":U AND funcao.ativo).

&IF DEFINED(DBOVersion) <> 0 &THEN
    DEFINE TEMP-TABLE RowErrors    NO-UNDO
            FIELD ErrorSequence    AS INTEGER
            FIELD ErrorNumber      AS INTEGER
            FIELD ErrorDescription AS CHARACTER
            FIELD ErrorParameters  AS CHARACTER
            FIELD ErrorType        AS CHARACTER
            FIELD ErrorHelp        AS CHARACTER
            FIELD ErrorSubType     AS CHARACTER.
&ELSE
    {method/dbotterr.i}
&ENDIF

        
def temp-table tt-editor no-undo
    field linha      as integer
    field conteudo   as character format "x(120)"
    index editor-id is primary unique linha.

{include/pi-edit.i} 

{imp/im0101.i1} /* defini‡Æo de forms: f-param, f-sel-embarque, f-sel-embarque-2, 
                                       f-sel-despesa, f-despesa-cex, f-documento */
define temp-table tt-param
    field destino            as integer
    field arquivo            as char
    field usuario            as char
    field data-exec          as date
    field hora-exec          as integer.

IF  i-pais-impto-usuario <> 1 THEN DO:
    RUN utp/ut-msgs.p (INPUT "show":U, INPUT 31458, INPUT "IM0101":U + "~~":U + "IM3101":U).
    RETURN "NOK":U.
END.

FIND FIRST param-global NO-LOCK NO-ERROR.
ASSIGN i-empresa = param-global.empresa-prin.
/***********API FINANCAS****************/
def var h_api_cta          as handle no-undo.
def var h_api_ccust        as handle no-undo.
def var p_cod_format_cta_ctbl   as char   no-undo.
DEF VAR p_cod_format_ccusto     AS CHAR NO-UNDO.
DEF VAR p_des_titulo        AS CHAR NO-UNDO.
DEF VAR v_des_ccusto        AS CHAR NO-UNDO.
DEF VAR v_cod_cta_ctbl AS CHAR NO-UNDO.
DEF VAR v_cod_ccusto AS CHAR NO-UNDO.
DEF VAR v_des_cta_ctbl AS CHAR NO-UNDO.
DEF VAR v_num_tip_cta_ctbl AS CHAR NO-UNDO.
DEF VAR v_num_sit_cta_ctbl AS CHAR NO-UNDO.
DEF VAR v_ind_finalid_cta AS CHAR NO-UNDO.
DEF VAR v_log_utz_ccusto AS CHAR NO-UNDO.

run prgint/utb/utb743za.py persistent set h_api_cta.
run prgint/utb/utb742za.py persistent set h_api_ccust.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¬ncia".

def temp-table tt_cta_integr no-undo
    field ttv_cod_cta_ctbl         as char format "x(20)" label "Conta Contÿbil"
    field ttv_des_titulo           as char format "x(40)"
    field ttv_num_tip_cta_ctbl     as int  format ">9" label "Tipo Conta" column-label "Tipo Conta"
    field ttv_num_sit_cta_ctbl     as int  format ">9" label "Situa‡Æo Conta" column-label "Situa‡Æo Cta"
    field ttv_ind_finalid_ctbl_cta as char format "X(40)" label "Finalidade Contÿbil".

def temp-table tt_ccusto_integr no-undo
    field ttv_cod_ccusto as char format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field ttv_des_titulo as char format "x(40)".

/***************************************/
/*### Formato conta contabil*/
run pi_retorna_formato_cta_ctbl in h_api_cta (input  i-empresa,                 /* EMPRESA EMS 2 */
                                              input  "",                 /* PLANO CONTAS */
                                              input  TODAY, /* DATA DE TRANSACAO */
                                              output p_cod_format_cta_ctbl,   /* FORMATO cta */
                                              output table tt_log_erro). /* ERROS */

/* formato centro de custo*/
run pi_retorna_formato_ccusto in h_api_ccust (input  i-empresa,                 /* EMPRESA EMS2 */
                                              input  "",             /* PLANO CCUSTO */
                                              input  TODAY,              /* DATA DE TRANSACAO */
                                              output p_cod_format_ccusto, /* FORMATO CCUSTO */
                                              output table tt_log_erro). /* ERROS */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-cla

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-9 RECT-19 de-aliq-ipi de-aliq-icms ~
c-tributacao-ipi c-tributacao-icms ddata-vencto-ipi ddata-vencto-icms ~
de-aliq-pis de-aliq-cofins c-tributacao-pis c-tributacao-cofins ~
de-aliq-ibsuf de-perc-red-ibsuf de-aliq-ibsmun de-perc-red-ibsmun ~
de-aliq-cbs de-perc-red-cbs de-aliq-is 
&Scoped-Define DISPLAYED-OBJECTS de-aliq-ipi de-aliq-icms c-tributacao-ipi ~
c-tributacao-icms ddata-vencto-ipi ddata-vencto-icms de-aliq-pis ~
de-aliq-cofins c-tributacao-pis c-tributacao-cofins de-aliq-ibsuf ~
de-perc-red-ibsuf de-aliq-ibsmun de-perc-red-ibsmun de-aliq-cbs ~
de-perc-red-cbs de-aliq-is 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-relat AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-tributacao-cofins AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cod Tributa‡Æo COFINS" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-tributacao-icms AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cod Tributa‡Æo ICMS" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-tributacao-ipi AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cod Tributa‡Æo IPI" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-tributacao-pis AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cod Tributa‡Æo PIS" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE ddata-vencto-icms AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data Vencimento ICMS" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE ddata-vencto-ipi AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data Vencimento IPI" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE de-aliq-cbs AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Al¡quota CBS" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE de-aliq-cofins AS DECIMAL FORMAT ">>9.9999":U INITIAL 0 
     LABEL "Al¡quota COFINS" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE de-aliq-ibsmun AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Al¡quota IBS Mun" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE de-aliq-ibsuf AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Al¡quota IBS UF" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE de-aliq-icms AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Al¡quota ICMS" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE de-aliq-ipi AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Al¡quota IPI" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE de-aliq-is AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Al¡quota IS" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE de-aliq-pis AS DECIMAL FORMAT ">>9.9999":U INITIAL 0 
     LABEL "Al¡quota PIS" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-red-cbs AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Perc Redu‡Æo CBS" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-red-ibsmun AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Perc Redu‡Æo IBS Mun" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-red-ibsuf AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Perc Redu‡Æo IBS UF" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 4.5.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 6.13.

DEFINE VARIABLE EDITOR-2 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 55.86 BY 3.25 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-serv AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item Servi‡o" 
     VIEW-AS FILL-IN 
     SIZE 12.72 BY .88 NO-UNDO.

DEFINE VARIABLE cod-ibge-dest AS CHARACTER FORMAT "X(7)":U 
     LABEL "C¢d IBGE Munic Dest" 
     VIEW-AS FILL-IN 
     SIZE 7.86 BY .88 NO-UNDO.

DEFINE VARIABLE cod-ibge-orig AS CHARACTER FORMAT "X(7)":U 
     LABEL "C¢d IBGE Munic Orig" 
     VIEW-AS FILL-IN 
     SIZE 7.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 4.75.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 1.58.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 1.58.

DEFINE VARIABLE c-cod-observacao AS CHARACTER FORMAT "X(20)":U INITIAL "Industria" 
     LABEL "Cod Observa‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Industria","Servico" 
     DROP-DOWN-LIST
     SIZE 17.57 BY 1 NO-UNDO.

DEFINE VARIABLE anoMesEmissao AS CHARACTER FORMAT "X(6)":U INITIAL "0000" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-chaveNFSe-amb-ger AS CHARACTER FORMAT "X(1)":U INITIAL "2" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE c-chaveNFSe-cgc AS CHARACTER FORMAT "X(14)":U 
     VIEW-AS FILL-IN NATIVE 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-chaveNFSe-data AS CHARACTER FORMAT "X(4)":U 
     VIEW-AS FILL-IN NATIVE 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-chaveNFSe-tp-if AS CHARACTER FORMAT "X(1)":U 
     VIEW-AS FILL-IN NATIVE 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE c-declaracao-imp AS CHARACTER FORMAT "x(20)":U 
     LABEL "Declara‡Æo Importa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE cccusto-trans AS CHARACTER FORMAT "X(20)":U 
     LABEL "CCusto Transit¢ria" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-emitente-desp AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 12.29 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-estabel LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R7 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-estabel-fisc LIKE estabelec.cod-estabel
     LABEL "Estabelecimento Fiscal":R7 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE cconta-trans AS CHARACTER FORMAT "X(20)":U 
     LABEL "Conta Transit¢ria" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE cembarque AS CHARACTER FORMAT "X(16)":U 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE cnatureza AS CHARACTER FORMAT "X(6)":U 
     LABEL "Natureza Opera‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE CnpjEmitente AS CHARACTER FORMAT "X(14)":U INITIAL "00000000000000" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE cnr-docto AS CHARACTER FORMAT "X(16)":U 
     LABEL "Nro Docto" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE codigoNumerico AS INTEGER FORMAT "999999999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE codigoUF AS CHARACTER FORMAT "X(02)":U INITIAL "00" 
     LABEL "Chave Acesso" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE cserie AS CHARACTER FORMAT "X(10)":U 
     LABEL "S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE d-chaveNFSe-nro-docto AS DECIMAL FORMAT "9999999999999":U INITIAL 0 
     VIEW-AS FILL-IN NATIVE 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE ddata-cotacao AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data Cota‡Æo Moeda" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE ddata-emissao AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data EmissÆo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE ddata-trans AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data Transa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE digitoVerific AS INTEGER FORMAT "9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE i-chaveNFSe-digito AS INTEGER FORMAT "9":U INITIAL 0 
     VIEW-AS FILL-IN NATIVE 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE i-chaveNFSe-muni AS INTEGER FORMAT "9999999":U INITIAL 0 
     LABEL "Chave Acesso" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-chaveNFSe-nr-nfe AS INTEGER FORMAT "999999999":U INITIAL 0 
     VIEW-AS FILL-IN NATIVE 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE modelo AS CHARACTER FORMAT "X(02)":U INITIAL "00" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE numeroNFE AS CHARACTER FORMAT "X(9)":U INITIAL "000000000" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE serie AS CHARACTER FORMAT "X(03)":U INITIAL "000" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE rb-tipo-geracao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Embarque", 1,
"Declara‡Æo de Importa‡Æo - DI", 2,
"Declara‡Æo énica de Importa‡Æo - DUIMP", 3
     SIZE 71 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 3.25.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 2.33.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 2.42.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 1.5.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 1.42.

DEFINE VARIABLE tg-agrupar-unico-fornec AS LOGICAL INITIAL no 
     LABEL "Agrupar em um £nico Fornecedor" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.57 BY .83 NO-UNDO.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-conferencia 
     LABEL "Conferˆncia" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-limpa-selec 
     IMAGE-UP FILE "IMAGE/im-undo.bmp":U
     LABEL "Limpa Sele‡Æo" 
     SIZE 4.14 BY 1.21 TOOLTIP "Limpa Sele‡Æo".

DEFINE BUTTON bt-sel-despesas 
     IMAGE-UP FILE "IMAGE/im-fpv.bmp":U
     LABEL "Sel" 
     SIZE 4.14 BY 1.21 TOOLTIP "Sele‡Æo de Despesas".

DEFINE BUTTON bt-sel-embarques 
     IMAGE-UP FILE "IMAGE/im-ran":U
     LABEL "Sel" 
     SIZE 4.14 BY 1.21 TOOLTIP "Sele‡Æo de Embarques".

DEFINE IMAGE im-pg-cla
     FILENAME "image/im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-par
     FILENAME "image/im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image/im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 79 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 12.25
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0    
     SIZE .43 BY 12.17
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0    
     SIZE .43 BY 12.17
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     bt-sel-embarques AT ROW 15.42 COL 46.29 HELP
          "Sele‡Æo de Embarques"
     bt-sel-despesas AT ROW 15.42 COL 50.72 HELP
          "Sele‡Æo de Despesas"
     bt-limpa-selec AT ROW 15.42 COL 55.14 HELP
          "Sele‡Æo de Despesas"
     bt-executar AT ROW 15.54 COL 3 HELP
          "Dispara a execu‡Æo do relat¢rio"
     bt-cancelar AT ROW 15.54 COL 13.14 HELP
          "Fechar"
     bt-conferencia AT ROW 15.54 COL 23.29 HELP
          "Simula‡Æo do C lculo da NFC"
     bt-ajuda AT ROW 15.54 COL 70 HELP
          "Ajuda"
     "Parƒmetros 3" VIEW-AS TEXT
          SIZE 9.86 BY .75 AT ROW 1.58 COL 34.86
     "Parƒmetros 1" VIEW-AS TEXT
          SIZE 9.86 BY .75 AT ROW 1.58 COL 4
     "Parƒmetros 2" VIEW-AS TEXT
          SIZE 9.86 BY .75 AT ROW 1.58 COL 19.14
     rt-folder-left AT ROW 2.54 COL 2.14
     RECT-6 AT ROW 14.75 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     rt-folder-top AT ROW 2.54 COL 2.14
     RECT-1 AT ROW 15.29 COL 2
     rt-folder AT ROW 2.63 COL 2
     im-pg-cla AT ROW 1.5 COL 17.86
     im-pg-sel AT ROW 1.5 COL 2.14
     im-pg-par AT ROW 1.5 COL 33.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 16
         BGCOLOR 17 FONT 1
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-sel
     rb-tipo-geracao AT ROW 1.29 COL 5 NO-LABEL
     c-declaracao-imp AT ROW 2.75 COL 18 COLON-ALIGNED
     cembarque AT ROW 2.75 COL 18 COLON-ALIGNED
     ccod-estabel AT ROW 2.75 COL 57.29 COLON-ALIGNED HELP
          ""
          LABEL "Estabelecimento":R7
     ccod-emitente-desp AT ROW 3.75 COL 18 COLON-ALIGNED
     ddata-trans AT ROW 3.75 COL 57.29 COLON-ALIGNED
     tg-agrupar-unico-fornec AT ROW 4.75 COL 20 HELP
          "Indica se a NFC agrupar  as despesas em um £nico fornecedor"
     ddata-emissao AT ROW 4.75 COL 57.29 COLON-ALIGNED
     cnatureza AT ROW 6 COL 18 COLON-ALIGNED
     cserie AT ROW 6 COL 57.29 COLON-ALIGNED
     cnr-docto AT ROW 7 COL 18 COLON-ALIGNED
     ccod-estabel-fisc AT ROW 7 COL 57.29 COLON-ALIGNED HELP
          ""
          LABEL "Estabelecimento Fiscal":R7
     ddata-cotacao AT ROW 8.5 COL 18 COLON-ALIGNED
     c-cod-observacao AT ROW 9.5 COL 18 COLON-ALIGNED
     cconta-trans AT ROW 8.5 COL 53.14 COLON-ALIGNED
     cccusto-trans AT ROW 9.5 COL 53.14 COLON-ALIGNED
     codigoUF AT ROW 11 COL 16 COLON-ALIGNED
     anoMesEmissao AT ROW 11 COL 20 COLON-ALIGNED NO-LABEL
     CnpjEmitente AT ROW 11 COL 26 COLON-ALIGNED NO-LABEL
     modelo AT ROW 11 COL 40 COLON-ALIGNED NO-LABEL
     serie AT ROW 11 COL 44 COLON-ALIGNED NO-LABEL
     numeroNFE AT ROW 11 COL 49 COLON-ALIGNED NO-LABEL
     codigoNumerico AT ROW 11 COL 59 COLON-ALIGNED NO-LABEL
     digitoVerific AT ROW 11 COL 69 COLON-ALIGNED NO-LABEL
     i-chaveNFSe-muni AT ROW 11 COL 15.14 COLON-ALIGNED WIDGET-ID 46
     c-chaveNFSe-amb-ger AT ROW 11 COL 23.14 COLON-ALIGNED HELP
          "2-Sistema nacional NFS-e" NO-LABEL WIDGET-ID 34
     c-chaveNFSe-tp-if AT ROW 11 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     c-chaveNFSe-cgc AT ROW 11 COL 28.86 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     d-chaveNFSe-nro-docto AT ROW 11 COL 43.72 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     c-chaveNFSe-data AT ROW 11 COL 56.57 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     i-chaveNFSe-nr-nfe AT ROW 11 COL 61.43 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     i-chaveNFSe-digito AT ROW 11 COL 71.29 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     RECT-11 AT ROW 2.5 COL 2
     RECT-12 AT ROW 5.83 COL 2
     RECT-13 AT ROW 8.25 COL 2
     RECT-14 AT ROW 10.75 COL 2
     RECT-20 AT ROW 1 COL 2 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 76.86 BY 11.62
         BGCOLOR 17 FONT 1.

DEFINE FRAME f-pg-par
     c-it-serv AT ROW 1.79 COL 10.29 COLON-ALIGNED
     c-desc-item AT ROW 1.79 COL 23.29 COLON-ALIGNED NO-LABEL
     cod-ibge-orig AT ROW 4.04 COL 16.29 COLON-ALIGNED HELP
          "Informar o C¢digo IBGE do Munic¡pio de in¡cio da presta‡Æo"
     cod-ibge-dest AT ROW 4.04 COL 42 COLON-ALIGNED HELP
          "Informar o C¢digo IBGE do Munic¡pio de t‚rmino da presta‡Æo"
     EDITOR-2 AT ROW 6.54 COL 12 NO-LABEL
     "Observa‡Æo" VIEW-AS TEXT
          SIZE 9.29 BY .75 AT ROW 5.58 COL 3
     "Nota Frete" VIEW-AS TEXT
          SIZE 9.29 BY .75 AT ROW 3.33 COL 3
     RECT-10 AT ROW 5.92 COL 2
     RECT-15 AT ROW 1.5 COL 2
     RECT-18 AT ROW 3.67 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 76.86 BY 11.5
         BGCOLOR 17 FONT 1.

DEFINE FRAME f-pg-cla
     de-aliq-ipi AT ROW 1.54 COL 17.43 COLON-ALIGNED
     de-aliq-icms AT ROW 1.54 COL 51.72 COLON-ALIGNED
     c-tributacao-ipi AT ROW 2.54 COL 17.43 COLON-ALIGNED
     c-tributacao-icms AT ROW 2.54 COL 51.72 COLON-ALIGNED
     ddata-vencto-ipi AT ROW 3.54 COL 17.43 COLON-ALIGNED
     ddata-vencto-icms AT ROW 3.54 COL 51.72 COLON-ALIGNED
     de-aliq-pis AT ROW 4.54 COL 17.43 COLON-ALIGNED
     de-aliq-cofins AT ROW 4.54 COL 51.72 COLON-ALIGNED
     c-tributacao-pis AT ROW 5.54 COL 17.43 COLON-ALIGNED
     c-tributacao-cofins AT ROW 5.54 COL 51.72 COLON-ALIGNED
     de-aliq-ibsuf AT ROW 7.79 COL 17.43 COLON-ALIGNED WIDGET-ID 2
     de-perc-red-ibsuf AT ROW 7.79 COL 51.72 COLON-ALIGNED WIDGET-ID 16
     de-aliq-ibsmun AT ROW 8.79 COL 17.43 COLON-ALIGNED WIDGET-ID 14
     de-perc-red-ibsmun AT ROW 8.79 COL 51.72 COLON-ALIGNED WIDGET-ID 18
     de-aliq-cbs AT ROW 9.79 COL 17.43 COLON-ALIGNED WIDGET-ID 8
     de-perc-red-cbs AT ROW 9.79 COL 51.72 COLON-ALIGNED WIDGET-ID 20
     de-aliq-is AT ROW 10.79 COL 17.43 COLON-ALIGNED WIDGET-ID 22
     RECT-9 AT ROW 1.13 COL 2
     RECT-19 AT ROW 7.5 COL 2 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 76.86 BY 11.5
         BGCOLOR 17 FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-relat ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.17
         WIDTH              = 81.29
         MAX-HEIGHT         = 36.63
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 36.63
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-relat 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-relat
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-pg-cla
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME f-pg-par
                                                                        */
/* SETTINGS FOR FRAME f-pg-sel
   Custom                                                               */
/* SETTINGS FOR FILL-IN anoMesEmissao IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-chaveNFSe-amb-ger IN FRAME f-pg-sel
   NO-ENABLE                                                            */
ASSIGN 
       c-chaveNFSe-amb-ger:HIDDEN IN FRAME f-pg-sel           = TRUE.

/* SETTINGS FOR FILL-IN c-chaveNFSe-cgc IN FRAME f-pg-sel
   NO-ENABLE                                                            */
ASSIGN 
       c-chaveNFSe-cgc:HIDDEN IN FRAME f-pg-sel           = TRUE.

/* SETTINGS FOR FILL-IN c-chaveNFSe-data IN FRAME f-pg-sel
   NO-ENABLE                                                            */
ASSIGN 
       c-chaveNFSe-data:HIDDEN IN FRAME f-pg-sel           = TRUE.

/* SETTINGS FOR FILL-IN c-chaveNFSe-tp-if IN FRAME f-pg-sel
   NO-ENABLE                                                            */
ASSIGN 
       c-chaveNFSe-tp-if:HIDDEN IN FRAME f-pg-sel           = TRUE.

/* SETTINGS FOR FILL-IN c-declaracao-imp IN FRAME f-pg-sel
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       c-declaracao-imp:HIDDEN IN FRAME f-pg-sel           = TRUE.

/* SETTINGS FOR FILL-IN ccod-estabel IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
/* SETTINGS FOR FILL-IN ccod-estabel-fisc IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
/* SETTINGS FOR FILL-IN CnpjEmitente IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN codigoUF IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-chaveNFSe-nro-docto IN FRAME f-pg-sel
   NO-ENABLE                                                            */
ASSIGN 
       d-chaveNFSe-nro-docto:HIDDEN IN FRAME f-pg-sel           = TRUE.

/* SETTINGS FOR FILL-IN i-chaveNFSe-digito IN FRAME f-pg-sel
   NO-ENABLE                                                            */
ASSIGN 
       i-chaveNFSe-digito:HIDDEN IN FRAME f-pg-sel           = TRUE.

/* SETTINGS FOR FILL-IN i-chaveNFSe-muni IN FRAME f-pg-sel
   NO-ENABLE                                                            */
ASSIGN 
       i-chaveNFSe-muni:HIDDEN IN FRAME f-pg-sel           = TRUE.

/* SETTINGS FOR FILL-IN i-chaveNFSe-nr-nfe IN FRAME f-pg-sel
   NO-ENABLE                                                            */
ASSIGN 
       i-chaveNFSe-nr-nfe:HIDDEN IN FRAME f-pg-sel           = TRUE.

/* SETTINGS FOR FILL-IN modelo IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN numeroNFE IN FRAME f-pg-sel
   NO-ENABLE                                                            */
ASSIGN 
       RECT-14:HIDDEN IN FRAME f-pg-sel           = TRUE.

/* SETTINGS FOR FILL-IN serie IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-relat
                                                                        */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-left IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-right IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-top IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
THEN w-relat:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-cla
/* Query rebuild information for FRAME f-pg-cla
     _Query            is NOT OPENED
*/  /* FRAME f-pg-cla */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-sel
/* Query rebuild information for FRAME f-pg-sel
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON END-ERROR OF w-relat
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON WINDOW-CLOSE OF w-relat
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-relat
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-relat
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Fechar */
DO:
   apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-conferencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-conferencia w-relat
ON CHOOSE OF bt-conferencia IN FRAME f-relat /* Conferˆncia */
DO:
    assign l-executar = no.
    do  transaction:
        run pi-executar.
        for each tt-param-im0101:
            delete tt-param-im0101.
        end.
        undo, leave.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar w-relat
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
    assign l-executar = yes.
    do  on error undo, return no-apply:
        RUN pi-Upc( input "verifica-pend",
                    input "CONTAINER",
                    input {&WINDOW-NAME}:HANDLE,
                    input FRAME f-pg-sel:HANDLE,
                    input "",
                    input "") NO-ERROR. 
       run pi-executar.
       for each tt-param-im0101:
           delete tt-param-im0101.
       end.
    end. /* do  on error undo, return no-apply: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-limpa-selec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-limpa-selec w-relat
ON CHOOSE OF bt-limpa-selec IN FRAME f-relat /* Limpa Sele‡Æo */
DO:    
    for each tt-selecao-embarque:  delete tt-selecao-embarque.  end.
    for each tt-desp-embarque:     delete tt-desp-embarque.     end.
    for each tt-desp-embarque-aux: delete tt-desp-embarque-aux. end.
    assign c-declaracao-imp:screen-value in frame f-pg-sel = ""
           c-declaracao-imp:sensitive    in frame f-pg-sel = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sel-despesas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sel-despesas w-relat
ON CHOOSE OF bt-sel-despesas IN FRAME f-relat /* Sel */
DO:
    def var c-return   as char   no-undo.

    assign input frame f-pg-sel tg-agrupar-unico-fornec
           input frame f-pg-sel ccod-emitente-desp.

    {utp/ut-liter.i Fornecedor_deve_ser_informado * L}
    if tg-agrupar-unico-fornec = no
        and ccod-emitente-desp = 0 then do:
        run utp/ut-msgs.p (input "show":U, 
                           input 25997,
                           input RETURN-VALUE + ".").

        apply "entry":U to ccod-emitente-desp in frame f-pg-sel.
        return no-apply.
    end.

    if  not can-find(first  tt-selecao-embarque
                      where tt-selecao-embarque.marca = "X") then do:
        if  not valid-handle (h-bocx220h) then
            run cxbo/bocx220h.p persistent set h-bocx220h.
        /* selecao usando embarque informado em tela */
        run chamaCarregaTtSelecaoEmbarque in this-procedure.
        if  valid-handle (h-bocx220h) then do:
            delete procedure h-bocx220h.
            assign h-bocx220h = ?.
        end.
    end.

    if  not can-find (first  tt-selecao-embarque
                       where tt-selecao-embarque.marca = "X":U) then do:

        run utp/ut-msgs.p (input "show":U, 
                           input 29398,
                           input "").

        apply "entry":U to cembarque in frame f-pg-sel.
        return no-apply.
    end.

    assign w-relat:sensitive = no
           l-ok-c            = no.

    IF NOT CAN-FIND(FIRST tt-desp-embarque-aux) THEN DO:
        FOR EACH tt-desp-embarque:
            ASSIGN tt-desp-embarque.selecionado = NO. /*quando ainda nao h  registros selecionados no browser, 
                                                       devera ser aberta a tela de selecao das despesas. 
                                                       Isso ocorre quando ‚ selecionado primeiro a conferencia e depois a despesa sera selecionada*/
        END.
    END.

    run imp/im0101c.w (input tg-agrupar-unico-fornec,
                       input ccod-emitente-desp,
                       input table tt-selecao-embarque,
                       input-output table tt-desp-embarque,
                       input-output cod-desp-ini,    
                       input-output cod-desp-fim,    
                       input-output fornec-desp-ini, 
                       input-output fornec-desp-fim, 
                       input-output pto-controle-ini,
                       input-output pto-controle-fim,
                       input-output l-ok-c,
                       input-output table tt-desp-embarque-aux).

    assign w-relat:sensitive = yes.
    apply 'entry' to bt-sel-despesas in frame f-relat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sel-embarques
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sel-embarques w-relat
ON CHOOSE OF bt-sel-embarques IN FRAME f-relat /* Sel */
DO:
    def var h-boad107 as handle no-undo.
    def var c-return  as char   no-undo.
    ASSIGN FRAME f-pg-sel rb-tipo-geracao.

    assign ccod-estabel:sensitive in frame f-pg-sel = yes.
    IF rb-tipo-geracao = 1 THEN
       ASSIGN cembarque:sensitive    in frame f-pg-sel = yes
              cembarque:screen-value in frame f-pg-sel = c-embarque-anterior.
    ELSE
       ASSIGN c-declaracao-imp:sensitive    in frame f-pg-sel = yes
              c-declaracao-imp:screen-value in frame f-pg-sel = c-di-anterior.

    if  not valid-handle(h-boad107) then
        run adbo/boad107.p persistent set h-boad107.
    run findCodigo in h-boad107 (input ccod-estabel:screen-value in frame f-pg-sel,
                                 output c-return).
    if ccod-estabel:screen-value in frame f-pg-sel = "" OR 
       c-return <> "":U then do:
        {utp/ut-table.i mgadm Estabelec 1}
        run utp/ut-msgs.p (input "show":U,
                           input 2,
                           input return-value).
        if  valid-handle (h-boad107) then do:
            delete procedure h-boad107.
            assign h-boad107 = ?.
        end.
        apply "entry":U to ccod-estabel in frame f-pg-sel.
        return no-apply.
    end.
    if  valid-handle (h-boad107) then do:
        delete procedure h-boad107.
        assign h-boad107 = ?.
    end.

    assign w-relat:sensitive = no.
    run imp/im0101b.w (input ccod-estabel:screen-value in frame f-pg-sel,         
                       INPUT int(rb-tipo-geracao),
                       input-output c-embarque-ini,               
                       input-output c-embarque-fim,               
                       INPUT-OUTPUT i-num-di-ems-ini,
                       INPUT-OUTPUT i-num-di-ems-fim,
                       input-output l-desembarque-parcial,        
                       input-output dt-nacionalizacao-ini,        
                       input-output dt-nacionalizacao-fim,        
                       input-output c-container-ini,              
                       input-output c-container-fim,              
                       input-output c-processo-ini,               
                       input-output c-processo-fim,               
                       input-output c-declaracao-imp-ini,         
                       input-output c-declaracao-imp-fim,         
                       input-output dt-di-ini,                    
                       input-output dt-di-fim,                    
                       input-output i-itinerario-ini,             
                       input-output i-itinerario-fim,             
                       input-output i-exportador-ini,             
                       input-output i-exportador-fim,             
                       input-output i-localizacao,                
                       input-output dt-chegada-ini,               
                       input-output dt-chegada-fim,               
                       input-output c-veiculo-transp-ini,         
                       input-output c-veiculo-transp-fim,         
                       &if "{&bf_cex_versao_ems}" >= "2.062" &then
                           &if "{&bf_mat_versao_ems}" >= "2.04" &then
                               input-output c-nr-conhecto-master-ini, 
                               input-output c-nr-conhecto-master-fim, 
                               input-output c-nr-conhecto-house-ini,  
                               input-output c-nr-conhecto-house-fim,  
                        &endif
                        &else
                            &if '{&bf_mat_versao_ems}' >= '2.05' &then
                               input-output c-nr-conhecto-master-ini, 
                               input-output c-nr-conhecto-master-fim, 
                               input-output c-nr-conhecto-house-ini,  
                               input-output c-nr-conhecto-house-fim,  
                            &else
                               input-output c-nr-conhecto-ini,        
                               input-output c-nr-conhecto-fim,    
                            &endif
                       &endif
                       input-output table tt-selecao-embarque,
                       INPUT i-num-di-ems-aux,
                       output l-ok). 

    if  l-ok then do:
        for each tt-desp-embarque:
            delete tt-desp-embarque.
        end.
        for each tt-desp-embarque-aux:
            delete tt-desp-embarque-aux.
        end.
    end.

    if  can-find (first  tt-selecao-embarque
                   where tt-selecao-embarque.marca = "X") then DO:
        IF rb-tipo-geracao = 1 THEN
            assign cembarque:screen-value in frame f-pg-sel = "" 
                   cembarque:sensitive    in frame f-pg-sel = no.
        ELSE
            assign c-declaracao-imp:screen-value in frame f-pg-sel = "" 
                   c-declaracao-imp:sensitive    in frame f-pg-sel = no.
        ASSIGN ccod-estabel:sensitive in frame f-pg-sel = no.
    END.
    else do:
       
        IF rb-tipo-geracao = 1 THEN
            assign cembarque:screen-value in frame f-pg-sel = c-embarque-anterior 
                   cembarque:sensitive    in frame f-pg-sel = YES.
        ELSE
            assign c-declaracao-imp:screen-value in frame f-pg-sel = c-di-anterior 
                   c-declaracao-imp:sensitive    in frame f-pg-sel = YES.

        ASSIGN ccod-estabel:sensitive in frame f-pg-sel = yes.
        if  not valid-handle (h-bocx220h) then
            run cxbo/bocx220h.p persistent set h-bocx220h.
        /* selecao usando o embarque informado em tela */
        run chamaCarregaTtSelecaoEmbarque in this-procedure.
        if  valid-handle (h-bocx220h) then do:
            delete procedure h-bocx220h.
            assign h-bocx220h = ?.
        end.
    end.

    assign w-relat:sensitive = yes.
    IF rb-tipo-geracao = 1 THEN
        apply 'entry':U to cembarque in frame f-pg-sel.
    ELSE
        apply 'entry':U to c-declaracao-imp in frame f-pg-sel.

    RUN pi-mostra-conta-trans.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME c-cod-observacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-observacao w-relat
ON VALUE-CHANGED OF c-cod-observacao IN FRAME f-pg-sel /* Cod Observa‡Æo */
DO:
    
    RUN piSetaDefaultImpostos.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-declaracao-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-declaracao-imp w-relat
ON F5 OF c-declaracao-imp IN FRAME f-pg-sel /* Declara‡Æo Importa‡Æo */
DO:
    ASSIGN INPUT FRAME f-pg-sel rb-tipo-geracao.
    {method/zoomfields.i &ProgramZoom   = "cxzoom/z01cx400.w"
                         &FieldZoom1    = "cod-di-siscomex"
                         &FieldScreen1  = "c-declaracao-imp"
                         &Frame1        = "f-pg-sel"
                         &FieldZoom2    = "cod-estab"
                         &FieldScreen2  = "ccod-estabel"
                         &Frame2        = "f-pg-sel"
                         &FieldZoom3    = "cod-estab"
                         &FieldScreen3  = "ccod-estabel-fisc"
                         &Frame3        = "f-pg-sel"
                         &FieldZoom4    = "dat-di"
                         &FieldScreen4  = "ddata-cotacao"
                         &Frame4        = "f-pg-sel"
                         &FieldZoom5    = "conta-transit-import"
                         &FieldScreen5  = "cconta-trans"
                         &Frame5        = "f-pg-sel" 
                         &RunMethod     = "RUN setaTpNacionaliz IN hProgramZoom (input rb-tipo-geracao)."
                         &EnableImplant = "NO" }
                       
    IF p_cod_format_cta_ctbl <> "" THEN
          ASSIGN cconta-trans:FORMAT IN FRAME f-pg-sel = p_cod_format_cta_ctbl.
      ELSE
          ASSIGN cconta-trans:FORMAT IN FRAME f-pg-sel = "X(20)":U.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-declaracao-imp w-relat
ON LEAVE OF c-declaracao-imp IN FRAME f-pg-sel /* Declara‡Æo Importa‡Æo */
DO: 
    
    ASSIGN INPUT FRAME f-pg-sel c-declaracao-imp.
    
    if  c-di-anterior <> input frame f-pg-sel c-declaracao-imp then do:
        for each tt-selecao-embarque:  delete tt-selecao-embarque.  end.
        for each tt-desp-embarque:     delete tt-desp-embarque.     end.
        for each tt-desp-embarque-aux: delete tt-desp-embarque-aux. end.
        assign c-di-anterior = c-declaracao-imp:screen-value in frame f-pg-sel.
    end. /* if  c-di-anterior <> input frame f-pg-sel c-declaracao-imp */
    
    if c-declaracao-imp <> "" then do:
        run cxbo/bocx250.p persistent set h-bocx250.
        RUN cxbo/bocx383.p PERSISTENT SET h-bocx383.
        RUN openQueryStatic      IN h-bocx383 ("Main":U).
        RUN findBySiscomexAndEms IN h-bocx383 (INPUT c-declaracao-imp).
        IF  RETURN-VALUE <> "NOK":U THEN DO:

            RUN getIntField IN h-bocx383 (INPUT "num-di-ems":U, OUTPUT i-num-di-ems).
            RUN getDecField IN h-bocx383 (INPUT "cdd-siscomex-dts":U, OUTPUT d-cdd-siscomex-dts).
    
            ASSIGN i-num-di-ems-aux = i-num-di-ems.
    
            RUN getCharField IN h-bocx383 (INPUT "cod-estab":U, OUTPUT c-cod-estab).
            ASSIGN ccod-estabel:screen-value      in frame f-pg-sel = c-cod-estab
                   ccod-estabel-fisc:screen-value in frame f-pg-sel = c-cod-estab.
    
            RUN getDateField IN h-bocx383 (INPUT "dat-di":U, OUTPUT data-di).
            ASSIGN ddata-cotacao:screen-value in frame f-pg-sel = string(data-di).

            APPLY "LEAVE":U TO ccod-estabel IN FRAME f-pg-sel.

            /*** posiciona registro ***/
            RUN findCodigo IN h-bocx250 (INPUT ccod-estabel, OUTPUT c-return).

            /*** verifica se t¡tulo em transito oriundo ***/
            if c-return = "" then DO:
                RUN getCharField IN h-bocx250 (INPUT "ct-transit-import":U, OUTPUT conta).
                ASSIGN cconta-trans:SCREEN-VALUE IN FRAME f-pg-sel = conta.
            END.
    
           /*RUN setaFornecedor.*/ /* Baseado no C¢digo DI Siscomex informado, busca o fornecedor da primeira adi‡Æo da DI */
        END. /* IF  RETURN-VALUE <> "NOK":U THEN */
    END.
    
    ELSE ASSIGN ccod-estabel:screen-value       in frame f-pg-sel = ""
                ccod-estabel-fisc:screen-value  in frame f-pg-sel = ""
                ddata-cotacao:screen-value      in frame f-pg-sel = string(TODAY)
                ccod-emitente-desp:screen-value in frame f-pg-sel = ""
                i-num-di-ems-aux                                  = 0. 
   
    APPLY "leave":U TO ccod-estabel IN FRAME f-pg-sel.

    IF  VALID-HANDLE (h-bocx383) THEN DO:
        DELETE PROCEDURE h-bocx383.
        ASSIGN h-bocx383 = ?.
    END. /* IF  VALID-HANDLE (h-bocx383) */
    
    IF  VALID-HANDLE (h-bocx250) THEN DO:
        DELETE PROCEDURE h-bocx250.
        ASSIGN h-bocx250 = ?.
    END. /* IF  VALID-HANDLE (h-bocx250) */



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-declaracao-imp w-relat
ON MOUSE-SELECT-DBLCLICK OF c-declaracao-imp IN FRAME f-pg-sel /* Declara‡Æo Importa‡Æo */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME c-it-serv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-serv w-relat
ON F5 OF c-it-serv IN FRAME f-pg-par /* Item Servi‡o */
DO:
  {include/zoomvar.i &prog-zoom = inzoom/z02in172.w
                     &campo = c-it-serv
                     &campozoom = it-codigo
                     &campo2=c-desc-item
                     &campozoom2=desc-item}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-serv w-relat
ON LEAVE OF c-it-serv IN FRAME f-pg-par /* Item Servi‡o */
DO:
   FOR FIRST item NO-LOCK 
        WHERE ITEM.it-codigo = (c-it-serv:SCREEN-VALUE IN FRAME f-pg-par):
        ASSIGN c-desc-item:SCREEN-VALUE IN FRAME f-pg-par = ITEM.desc-item. 
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-serv w-relat
ON MOUSE-SELECT-DBLCLICK OF c-it-serv IN FRAME f-pg-par /* Item Servi‡o */
DO:
  apply "F5".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME cccusto-trans
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cccusto-trans w-relat
ON ENTRY OF cccusto-trans IN FRAME f-pg-sel /* CCusto Transit¢ria */
DO:
  ASSIGN cccusto-trans:FORMAT IN FRAME f-pg-sel = "X(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cccusto-trans w-relat
ON F5 OF cccusto-trans IN FRAME f-pg-sel /* CCusto Transit¢ria */
DO:
    ASSIGN cconta-trans:FORMAT IN FRAME f-pg-sel = "X(20)".
   
    run pi_zoom_ccusto_x_cta_ctbl in h_api_ccust (input                 i-empresa,                          /* EMPRESA EMS2 */
                                                  input                 ccod-estabel:SCREEN-VALUE,          /* ESTABELECIMENTO EMS2 */
                                                  input                 yes,                                /* TODOS ESTABELECIMENTOS ? */
                                                  input                 "",                                 /* UNIDADE DE NEGOCIO */
                                                  input                 "",                                 /* PLANO CONTAS */
                                                  input                 cconta-trans:SCREEN-VALUE,          /* CONTA */
                                                  input                 "",                                 /* CODIGO DO PLANO CCUSTO */
                                                  input INPUT FRAME     f-pg-sel ddata-trans,               /* DATA DE TRANSACAO */
                                                  output                v_cod_ccusto,                       /* CODIGO CCUSTO */
                                                  output                v_des_ccusto,                       /* DESCRICAO CCUSTO */
                                                  output table          tt_log_erro).                       /* ERROS */
    
    IF v_cod_ccusto <> "" THEN
        ASSIGN cccusto-trans = v_cod_ccusto
               cccusto-trans:SCREEN-VALUE = v_cod_ccusto.
    ASSIGN cconta-trans:FORMAT IN FRAME f-pg-sel = p_cod_format_cta_ctbl.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cccusto-trans w-relat
ON LEAVE OF cccusto-trans IN FRAME f-pg-sel /* CCusto Transit¢ria */
DO:

  /*IF cccusto-trans:SCREEN-VALUE <> "" THEN DO:
      IF p_cod_format_ccusto <> "" THEN
          ASSIGN cccusto-trans:FORMAT IN FRAME f-pg-sel = p_cod_format_ccusto.
      ELSE
          ASSIGN cccusto-trans:FORMAT IN FRAME f-pg-sel = "X(20)".
  END.
  ELSE
      ASSIGN cccusto-trans:FORMAT IN FRAME f-pg-sel = "X(20)".*/



      ASSIGN cccusto-trans:FORMAT IN FRAME f-pg-sel = "X(20)".
    IF cccusto-trans:SCREEN-VALUE <> "" THEN DO:
   
        run pi_busca_dados_ccusto in h_api_ccust (input                 i-empresa,                  /* EMPRESA EMS2 */
                                                  input                 "",                         /* CODIGO DO PLANO CCUSTO */
                                                  input                 cccusto-trans:SCREEN-VALUE, /* CCUSTO */
                                                  input  INPUT FRAME    f-pg-sel ddata-trans,       /* DATA DE TRANSACAO */
                                                  output                v_des_ccusto,               /* DESCRICAO DO CCUSTO */
                                                  output table          tt_log_erro).               /* ERROS */       
                                                  
    IF RETURN-VALUE = "OK" THEN
        ASSIGN cccusto-trans:FORMAT IN FRAME f-pg-sel = p_cod_format_ccusto.
    ELSE
        ASSIGN cccusto-trans:FORMAT IN FRAME f-pg-sel = "X(20)".
  END.
  ELSE
    ASSIGN cccusto-trans:FORMAT IN FRAME f-pg-sel = "X(20)".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cccusto-trans w-relat
ON MOUSE-SELECT-DBLCLICK OF cccusto-trans IN FRAME f-pg-sel /* CCusto Transit¢ria */
DO:
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ccod-emitente-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-emitente-desp w-relat
ON F5 OF ccod-emitente-desp IN FRAME f-pg-sel /* Fornecedor */
DO:
    assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
                       &campo="ccod-emitente-desp"
                       &campozoom="cod-emitente"
                       &frame="f-pg-sel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-emitente-desp w-relat
ON LEAVE OF ccod-emitente-desp IN FRAME f-pg-sel /* Fornecedor */
DO:

  IF  l-spp-nfe OR log-nfse-nacional THEN
      RUN piMontaChaveNFE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-emitente-desp w-relat
ON MOUSE-SELECT-DBLCLICK OF ccod-emitente-desp IN FRAME f-pg-sel /* Fornecedor */
DO:
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ccod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel w-relat
ON F5 OF ccod-estabel IN FRAME f-pg-sel /* Estabelecimento */
DO:
    &if defined(bf-mat-comex) &then
        {method/ZoomFields.i
         &ProgramZoom="adzoom/z10ad107.w"
         &FieldZoom1="cod-estabel"
         &FieldScreen1="ccod-estabel"
         &Frame1="f-pg-sel"
         &EnableImplant="no"} 
    &else
        {method/ZoomFields.i
         &ProgramZoom="adzoom/z10ad107.w"
         &FieldZoom1="cod-estabel"
         &FieldScreen1="ccod-estabel"
         &Frame1="f-pg-sel"}
    &endif     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel w-relat
ON LEAVE OF ccod-estabel IN FRAME f-pg-sel /* Estabelecimento */
DO:
    RUN pi-retorna-empresa.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel w-relat
ON MOUSE-SELECT-DBLCLICK OF ccod-estabel IN FRAME f-pg-sel /* Estabelecimento */
DO:
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ccod-estabel-fisc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel-fisc w-relat
ON F5 OF ccod-estabel-fisc IN FRAME f-pg-sel /* Estabelecimento Fiscal */
DO:
    &if defined(bf-mat-comex) &then
        {method/zoomfields.i 
         &ProgramZoom="adzoom/z10ad107.w"
         &FieldZoom1="cod-estabel"
         &FieldScreen1="ccod-estabel-fisc"
         &Frame1="f-pg-sel"
         &EnableImplant="no"}        
    &else
        {method/zoomfields.i 
         &ProgramZoom="adzoom/z10ad107.w"
         &FieldZoom1="cod-estabel"
         &FieldScreen1="ccod-estabel-fisc"
         &Frame1="f-pg-sel"}
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel-fisc w-relat
ON MOUSE-SELECT-DBLCLICK OF ccod-estabel-fisc IN FRAME f-pg-sel /* Estabelecimento Fiscal */
DO:
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cconta-trans
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cconta-trans w-relat
ON ENTRY OF cconta-trans IN FRAME f-pg-sel /* Conta Transit¢ria */
DO:
  ASSIGN cconta-trans:FORMAT IN FRAME f-pg-sel = "X(20)"
         cccusto-trans:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cconta-trans w-relat
ON F5 OF cconta-trans IN FRAME f-pg-sel /* Conta Transit¢ria */
DO:
    &if defined(bf-mat-comex) &then
        assign l-implanta = no.
    &else
        assign l-implanta = yes.
    &endif                   

    run pi_zoom_cta_ctbl_integr in h_api_cta (input                 i-empresa,              /* EMPRESA EMS2 */
                                              input                 "CEP",                  /* M…DULO */
                                              input                 "",                     /* PLANO DE CONTAS */
                                              input                 "(nenhum)",             /* FINALIDADES */
                                              input  INPUT FRAME    f-pg-sel ddata-trans,   /* DATA TRANSACAO */
                                              output                v_cod_cta_ctbl,         /* CODIGO CONTA */
                                              output                v_des_cta_ctbl,         /* DESCRICAO CONTA */
                                              output                v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              output table          tt_log_erro).           /* ERROS */ 
    FIND FIRST tt_log_erro NO-ERROR.
    IF NOT AVAIL tt_log_erro THEN
        ASSIGN cconta-trans = v_cod_cta_ctbl
               cconta-trans:SCREEN-VALUE = v_cod_cta_ctbl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cconta-trans w-relat
ON LEAVE OF cconta-trans IN FRAME f-pg-sel /* Conta Transit¢ria */
DO:
  ASSIGN cconta-trans:FORMAT IN FRAME f-pg-sel = "x(20)"
         v_cod_cta_ctbl = cconta-trans:SCREEN-VALUE.

  run pi_busca_dados_cta_ctbl in h_api_cta (INPUT                   i-empresa,                                      /* EMPRESA EMS2 */
                                            INPUT                   "",                                             /* PLANO DE CONTAS */
                                            INPUT-OUTPUT            v_cod_cta_ctbl,                                 /* CONTA */
                                            INPUT   INPUT FRAME     f-pg-sel ddata-trans,                           /* DATA TRANSACAO */   
                                            OUTPUT                  v_des_cta_ctbl,                                 /* DESCRICAO CONTA */
                                            OUTPUT                  v_num_tip_cta_ctbl,                             /* TIPO DA CONTA */
                                            OUTPUT                  v_num_sit_cta_ctbl,                             /* SITUA€ÇO DA CONTA */
                                            OUTPUT                  v_ind_finalid_cta,                              /* FINALIDADES DA CONTA */
                                            OUTPUT TABLE            tt_log_erro).                                   /* ERROS */     
  FIND FIRST tt_log_erro NO-ERROR.
  IF NOT AVAIL tt_log_erro THEN DO:
      ASSIGN cconta-trans:SCREEN-VALUE = v_cod_cta_ctbl
             cconta-trans = v_cod_cta_ctbl.
      
      IF p_cod_format_cta_ctbl <> "" THEN
          ASSIGN cconta-trans:FORMAT IN FRAME f-pg-sel = p_cod_format_cta_ctbl.
      ELSE
          ASSIGN cconta-trans:FORMAT IN FRAME f-pg-sel = "X(20)":U.
 END.
 ELSE DO:
     ASSIGN cccusto-trans:SENSITIVE = NO
                cccusto-trans:SCREEN-VALUE = ""
                cccusto-trans = "".

 END.
 IF cccusto-trans:SENSITIVE <> NO THEN DO:
 run pi_verifica_utilizacao_ccusto in h_api_ccust (input i-empresa,           /* EMPRESA EMS 2 */
                                                   input ccod-estabel:SCREEN-VALUE,                  /* ESTABELECIMENTO EMS2 */
                                                   input "",                  /* PLANO CONTAS */
                                                   input cconta-trans,        /* CONTA */
                                                   input  today,              /* DT TRANSACAO */
                                                   output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                   output table tt_log_erro). /* ERROS */
 IF NOT AVAIL tt_log_erro THEN DO:             
     IF v_log_utz_ccusto = "NO" THEN
         ASSIGN cccusto-trans:SENSITIVE = NO
                cccusto-trans:SCREEN-VALUE = ""
                cccusto-trans = "".
     ELSE
         ASSIGN cccusto-trans:SENSITIVE = YES.
 END.
 END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cconta-trans w-relat
ON MOUSE-SELECT-DBLCLICK OF cconta-trans IN FRAME f-pg-sel /* Conta Transit¢ria */
DO:
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cembarque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cembarque w-relat
ON F5 OF cembarque IN FRAME f-pg-sel /* Embarque */
DO:
    {method/zoomfields.i &ProgramZoom="cxzoom/z04cx220.w"
                         &FieldZoom1="embarque"
                         &FieldScreen1="cembarque"
                         &Frame1="f-pg-sel"
                         &FieldZoom2="cod-estabel"
                         &FieldScreen2="ccod-estabel"
                         &Frame2="f-pg-sel"
                         &FieldZoom3="cod-estab-fisc"
                         &FieldScreen3="ccod-estabel-fisc"
                         &Frame3="f-pg-sel"
                         &FieldZoom4="ct-transit-import"
                         &FieldScreen4="cconta-trans"
                         &Frame4="f-pg-sel"
                         &FieldZoom5="cod-emitente"
                         &FieldScreen5="ccod-emitente-desp"
                         &Frame5="f-pg-sel"
                         &EnableImplant="no"}

      IF p_cod_format_cta_ctbl <> "" THEN
          ASSIGN cconta-trans:FORMAT IN FRAME f-pg-sel = p_cod_format_cta_ctbl.
      ELSE
          ASSIGN cconta-trans:FORMAT IN FRAME f-pg-sel = "X(20)":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cembarque w-relat
ON LEAVE OF cembarque IN FRAME f-pg-sel /* Embarque */
DO:
    if  c-embarque-anterior <> input frame f-pg-sel cembarque then do:
        for each tt-selecao-embarque:
            delete tt-selecao-embarque.
        end.
        for each tt-desp-embarque:
            delete tt-desp-embarque.
        end.
        for each tt-desp-embarque-aux:
            delete tt-desp-embarque-aux.
        end.
        assign c-embarque-anterior = cembarque:screen-value in frame f-pg-sel.
    end.

    APPLY "leave":U TO ccod-estabel IN FRAME f-pg-sel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cembarque w-relat
ON MOUSE-SELECT-DBLCLICK OF cembarque IN FRAME f-pg-sel /* Embarque */
DO:
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cnatureza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cnatureza w-relat
ON ENTRY OF cnatureza IN FRAME f-pg-sel /* Natureza Opera‡Æo */
DO:
    ASSIGN c-old-natureza = cnatureza:SCREEN-VALUE IN FRAME f-pg-sel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cnatureza w-relat
ON F5 OF cnatureza IN FRAME f-pg-sel /* Natureza Opera‡Æo */
DO: 
    &if defined(bf-mat-comex) &then
        assign l-implanta = no.
    &else
        assign l-implanta = yes.
    &endif

    {include/zoomvar.i &prog-zoom="inzoom/z01in245.w"
                   &campo="cnatureza"
                   &campozoom="nat-operacao"
                   &frame="f-pg-sel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cnatureza w-relat
ON LEAVE OF cnatureza IN FRAME f-pg-sel /* Natureza Opera‡Æo */
DO:
   IF  (l-spp-nfe AND l-emitente-nfe)
   OR  log-nfse-nacional THEN
       RUN piMontaChaveNFE.

   RUN piSetaDefaultImpostos.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cnatureza w-relat
ON MOUSE-SELECT-DBLCLICK OF cnatureza IN FRAME f-pg-sel /* Natureza Opera‡Æo */
DO:  
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cnr-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cnr-docto w-relat
ON LEAVE OF cnr-docto IN FRAME f-pg-sel /* Nro Docto */
DO:

   ASSIGN l-format-out = NO.

   IF  (l-spp-nfe AND l-emitente-nfe)
   OR  log-nfse-nacional THEN
       RUN piMontaChaveNFE.

   IF NOT log-nfse-nacional THEN DO:
   
   &IF defined(bf_nr_nota) &THEN
       IF  cnr-docto:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "0"
       AND cnr-docto:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN DO:

           DO i-count = 1 TO LENGTH(input frame f-pg-sel cnr-docto):
               IF INDEX(c-numeros, SUBSTRING(input frame f-pg-sel cnr-docto, i-count,1)) = 0 THEN
                   ASSIGN l-format-out = YES.
           END.

           IF l-format-out THEN DO:
               run utp/ut-msgs.p (input "show":U, 
                                 input 27390, 
                                 input cnr-docto:LABEL).
        
                apply "entry":U to cnr-docto in frame {&frame-name}.
                return "NOK":U.
           END.

           if length(left-trim(string(input frame f-pg-sel cnr-docto, c-formato-nf))) > length(c-formato-nf) then do:
              run utp/ut-msgs.p (input "show":U, 
                                 input 36151, 
                                 input length(c-formato-nf)).
        
                apply "entry":U to cnr-docto in frame {&frame-name}.
                return "NOK":U.
            end. 
        
            assign cnr-docto:screen-value in frame {&frame-name} = left-trim(string(dec(input frame {&frame-name} cnr-docto),c-formato-nf)).
       END.
   &ENDIF
   END.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME cod-ibge-dest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-ibge-dest w-relat
ON F5 OF cod-ibge-dest IN FRAME f-pg-par /* C¢d IBGE Munic Dest */
DO:
    {method/zoomfields.i &ProgramZoom="dizoom/z01di341.w"
                         &FieldZoom1="cdn-munpio-ibge"
                         &FieldScreen1="cod-ibge-dest"
                         &Frame1="f-pg-par"
                         &enableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-ibge-dest w-relat
ON MOUSE-SELECT-DBLCLICK OF cod-ibge-dest IN FRAME f-pg-par /* C¢d IBGE Munic Dest */
DO:
    APPLY "F5".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-ibge-orig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-ibge-orig w-relat
ON F5 OF cod-ibge-orig IN FRAME f-pg-par /* C¢d IBGE Munic Orig */
DO:
    {method/zoomfields.i &ProgramZoom="dizoom/z01di341.w"
                         &FieldZoom1="cdn-munpio-ibge"
                         &FieldScreen1="cod-ibge-orig"
                         &Frame1="f-pg-par"
                         &enableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-ibge-orig w-relat
ON MOUSE-SELECT-DBLCLICK OF cod-ibge-orig IN FRAME f-pg-par /* C¢d IBGE Munic Orig */
DO:
    APPLY "F5".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME cserie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cserie w-relat
ON F5 OF cserie IN FRAME f-pg-sel /* S‚rie */
DO:
    &if defined(bf-mat-comex) &then
        {method/zoomfields.i 
         &ProgramZoom="inzoom/z10in407.w"
         &FieldZoom1="serie"
         &FieldScreen1="cserie"
         &Frame1="f-pg-sel"
         &EnableImplant="no"}
    &else
        assign l-implanta = yes.    
        {include/zoomvar.i &prog-zoom="inzoom/z01in407.w"
                       &campo="cserie"
                       &campozoom="serie"
                       &frame="f-pg-sel"}
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cserie w-relat
ON LEAVE OF cserie IN FRAME f-pg-sel /* S‚rie */
DO:
  IF  (l-spp-nfe AND l-emitente-nfe)
  OR  log-nfse-nacional THEN
      RUN piMontaChaveNFE.

  /*** Busca numera‡Æo do faturamento ***/
  IF CAN-FIND(FIRST natur-oper 
              WHERE natur-oper.nat-operacao = INPUT FRAME f-pg-sel cnatureza
              AND   natur-oper.imp-nota /* Gera Nota Faturamento */) THEN DO:
      FIND FIRST ser-estab NO-LOCK
          WHERE  ser-estab.serie       = INPUT FRAME f-pg-sel cserie
          AND    ser-estab.cod-estabel = ccod-estabel:screen-value in frame f-pg-sel NO-ERROR.
      IF  AVAIL  ser-estab THEN DO:

          &IF '{&bf_libera_15_posicoes}' = 'yes' &THEN
              ASSIGN cnr-docto:SCREEN-VALUE IN FRAME {&frame-name} = TRIM(STRING(DEC(ser-estab.nr-ult-nota) + 1,"999999999999999")).
          &ELSE
              ASSIGN cnr-docto:SCREEN-VALUE IN FRAME {&frame-name} = TRIM(STRING(DEC(ser-estab.nr-ult-nota) + 1,"9999999999")).
          &ENDIF
          
      END.
  END. /* IF  CAN-FIND(FIRST natur-oper */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cserie w-relat
ON MOUSE-SELECT-DBLCLICK OF cserie IN FRAME f-pg-sel /* S‚rie */
DO:
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ddata-emissao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ddata-emissao w-relat
ON LEAVE OF ddata-emissao IN FRAME f-pg-sel /* Data EmissÆo */
DO:
    IF  (l-spp-nfe AND l-emitente-nfe)
    OR  log-nfse-nacional THEN
        RUN piMontaChaveNFE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-cla
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-cla w-relat
ON MOUSE-SELECT-CLICK OF im-pg-cla IN FRAME f-relat
DO:
    /*self:move-to-top() in frame f-relat.
    im-pg-sel:move-to-bottom() in frame f-relat.
    im-pg-par:move-to-bottom() in frame f-relat.*/
    hide frame f-pg-sel.
    hide frame f-pg-par.
    view frame f-pg-cla. 

    run pi-troca-pagina.
    RUN pi_altera_folder IN h-facelift ("cust", "DN", im-pg-sel:HANDLE IN FRAME f-relat, im-pg-cla:HANDLE).
    RUN pi_altera_folder IN h-facelift ("cust", "DN", im-pg-par:HANDLE IN FRAME f-relat, im-pg-cla:HANDLE).
    RUN pi_altera_folder IN h-facelift ("cust", "UP", im-pg-cla:HANDLE IN FRAME f-relat, im-pg-cla:HANDLE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-par
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-par w-relat
ON MOUSE-SELECT-CLICK OF im-pg-par IN FRAME f-relat
DO:
    /*self:move-to-top() in frame f-relat.
    im-pg-sel:move-to-bottom() in frame f-relat.
    im-pg-cla:move-to-bottom() in frame f-relat.*/
    hide frame f-pg-sel.
    HIDE frame f-pg-cla.
    view frame f-pg-par.

    run pi-troca-pagina.
    RUN pi_altera_folder IN h-facelift ("cust", "DN", im-pg-sel:HANDLE IN FRAME f-relat, im-pg-par:HANDLE).
    RUN pi_altera_folder IN h-facelift ("cust", "DN", im-pg-cla:HANDLE IN FRAME f-relat, im-pg-par:HANDLE).
    RUN pi_altera_folder IN h-facelift ("cust", "UP", im-pg-PAR:HANDLE IN FRAME f-relat, im-pg-par:HANDLE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel w-relat
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    /*self:move-to-top() in frame f-relat.
    im-pg-cla:move-to-bottom() in frame f-relat.
    im-pg-par:move-to-bottom() in frame f-relat. */
    hide frame f-pg-cla.
    hide frame f-pg-par.
    view frame f-pg-sel. 

    run pi-troca-pagina.
    RUN pi_altera_folder IN h-facelift ("cust", "DN", im-pg-cla:HANDLE IN FRAME f-relat, im-pg-sel:HANDLE).
    RUN pi_altera_folder IN h-facelift ("cust", "DN", im-pg-par:HANDLE IN FRAME f-relat, im-pg-sel:HANDLE).
    RUN pi_altera_folder IN h-facelift ("cust", "UP", im-pg-sel:HANDLE IN FRAME f-relat, im-pg-sel:HANDLE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME rb-tipo-geracao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rb-tipo-geracao w-relat
ON VALUE-CHANGED OF rb-tipo-geracao IN FRAME f-pg-sel
DO:
    ASSIGN FRAME f-pg-sel rb-tipo-geracao.

    IF  rb-tipo-geracao = 1 /* Embarque */ THEN DO:
        ASSIGN cembarque:HIDDEN              IN FRAME f-pg-sel = FALSE
               cembarque:SENSITIVE           IN FRAME f-pg-sel = TRUE
               c-declaracao-imp:SCREEN-VALUE IN FRAME f-pg-sel = ""
               c-declaracao-imp:HIDDEN       IN FRAME f-pg-sel = TRUE
               ccod-estabel:SCREEN-VALUE     IN FRAME f-pg-sel = "".
    END. 
    ELSE DO: 
        ASSIGN c-declaracao-imp:HIDDEN       IN FRAME f-pg-sel = FALSE
               c-declaracao-imp:SENSITIVE    IN FRAME f-pg-sel = TRUE
               c-declaracao-imp:SCREEN-VALUE IN FRAME f-pg-sel = ""
               cembarque:SCREEN-VALUE        IN FRAME f-pg-sel = ""
               cembarque:HIDDEN              IN FRAME f-pg-sel = TRUE
               ccod-estabel:SCREEN-VALUE     IN FRAME f-pg-sel = "".
        IF rb-tipo-geracao = 2 THEN
            ASSIGN c-declaracao-imp:LABEL IN FRAME f-pg-sel = "Declara‡Æo Importa‡Æo":U.
        ELSE 
            ASSIGN c-declaracao-imp:LABEL IN FRAME f-pg-sel = "DUIMP":U.
    END. 

    ASSIGN ccod-estabel-fisc:SCREEN-VALUE  IN FRAME f-pg-sel = ""
           ccod-emitente-desp:SCREEN-VALUE IN FRAME f-pg-sel = ""
           ddata-cotacao:SCREEN-VALUE      IN FRAME f-pg-sel = STRING(TODAY).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-cla
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-relat 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "IM0101" "2.00.00.050"} /* 19/08/2026 14:49:30 */

/* inicializa‡äes do template de relat¢rio */
RUN pi_altera_folder IN h-facelift ("cust", "UP", im-pg-sel:HANDLE IN FRAME f-relat, im-pg-sel:HANDLE).
RUN pi_altera_folder IN h-facelift ("cust", "DN", im-pg-par:HANDLE IN FRAME f-relat, im-pg-par:HANDLE).
RUN pi_altera_folder IN h-facelift ("cust", "DN", im-pg-cla:HANDLE IN FRAME f-relat, im-pg-cla:HANDLE).
RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME f-relat:HANDLE).
RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME f-pg-sel:HANDLE).
RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME f-param:HANDLE).
RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME f-pg-cla:HANDLE).
RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME f-pg-par:HANDLE).
RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME f-documento:HANDLE).
RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME f-despesa-cex:HANDLE).
RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME f-sel-despesa:HANDLE).
RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME f-sel-embarque-2:HANDLE).
RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME f-sel-embarque:HANDLE).

RUN pi_procura_caminho_image IN h-facelift (INPUT 'IMAGE/im-fpv.bmp', OUTPUT cValSensi, OUTPUT cValInsensi).
bt-sel-despesas:load-image-up(cValSensi).

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    ccod-emitente-desp:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-sel.
    cembarque:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-sel.
    ccod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-sel.
    cserie:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-sel.
    cnatureza:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-sel.
    ccod-estabel-fisc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-sel.
    cconta-trans:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-sel.
    cccusto-trans:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-sel.
    c-declaracao-imp:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-sel.
    c-it-serv:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame f-pg-par.
    cod-ibge-orig:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-par.
    cod-ibge-dest:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-par.
    RUN enable_UI.  

    {imp/im0100b.i3 ERROR}

    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.

END.

{utp/ut-liter.i "Estabelecimento Fiscal" * L}
assign ccod-estabel-fisc:LABEL IN FRAME f-pg-sel = trim(return-value).

ASSIGN c-tributacao-ipi:LIST-ITEMS    IN FRAME f-pg-cla = {ininc/i10in172.i 03}
       c-tributacao-icms:LIST-ITEMS   IN FRAME f-pg-cla = {ininc/i01in245.i 03}
       c-tributacao-pis:LIST-ITEMS    IN FRAME f-pg-cla = {ininc/i04in176.i 03}
       c-tributacao-cofins:LIST-ITEMS IN FRAME f-pg-cla = {ininc/i04in176.i 03}.

find first param-global no-lock no-error.
assign cconta-trans:format in frame f-pg-sel = param-global.formato-conta-contabil
       i-empresa-prin                        = param-global.empresa-prin.

/* NFE */
ASSIGN codigoUF      :HIDDEN IN FRAME f-pg-sel = YES 
       anoMesEmissao :HIDDEN IN FRAME f-pg-sel = YES 
       CnpjEmitente  :HIDDEN IN FRAME f-pg-sel = YES 
       modelo        :HIDDEN IN FRAME f-pg-sel = YES 
       serie         :HIDDEN IN FRAME f-pg-sel = YES  
       numeroNFE     :HIDDEN IN FRAME f-pg-sel = YES  
       codigoNumerico:HIDDEN IN FRAME f-pg-sel = YES  
       digitoVerific :HIDDEN IN FRAME f-pg-sel = YES
       RECT-14       :HIDDEN IN FRAME f-pg-sel = YES.

IF  can-find(FIRST funcao NO-LOCK
             WHERE funcao.cd-funcao = "spp-nfe":U
             AND   funcao.ativo) THEN
    ASSIGN l-spp-nfe = YES.

IF  l-spp-nfe THEN
    ASSIGN codigoUF      :HIDDEN IN FRAME f-pg-sel = NO
           anoMesEmissao :HIDDEN IN FRAME f-pg-sel = NO 
           CnpjEmitente  :HIDDEN IN FRAME f-pg-sel = NO 
           modelo        :HIDDEN IN FRAME f-pg-sel = NO 
           serie         :HIDDEN IN FRAME f-pg-sel = NO  
           numeroNFE     :HIDDEN IN FRAME f-pg-sel = NO  
           codigoNumerico:HIDDEN IN FRAME f-pg-sel = NO  
           digitoVerific :HIDDEN IN FRAME f-pg-sel = NO
           RECT-14       :HIDDEN IN FRAME f-pg-sel = NO.

IF NOT l-nt2024002 THEN DO:
    ASSIGN de-aliq-ibsuf:HIDDEN      IN FRAME f-pg-cla = YES
           de-aliq-ibsmun:HIDDEN     IN FRAME f-pg-cla = YES
           de-aliq-cbs:HIDDEN        IN FRAME f-pg-cla = YES
           de-aliq-is:HIDDEN         IN FRAME f-pg-cla = YES
           de-perc-red-ibsuf:HIDDEN  IN FRAME f-pg-cla = YES
           de-perc-red-ibsmun:HIDDEN IN FRAME f-pg-cla = YES
           de-perc-red-cbs:HIDDEN    IN FRAME f-pg-cla = YES
           RECT-19:HIDDEN            IN FRAME f-pg-cla = YES.
END.

run pi-inicializa-valores.

//im-pg-sel:move-to-top() in frame f-relat.
//im-pg-cla:move-to-bottom() in frame f-relat.

VIEW FRAME f-relat.

PROCEDURE WinExec  EXTERNAL  "kernel32.dll":
  DEF INPUT PARAM prg_name      AS CHARACTER.
  DEF INPUT PARAM prg_style     AS SHORT.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-relat  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-relat  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chamaCarregaTtSelecaoEmbarque w-relat 
PROCEDURE chamaCarregaTtSelecaoEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    run carregaTtSelecaoEmbarque in h-bocx220h (input ccod-estabel:screen-value in frame f-pg-sel,
                                                INPUT int(rb-tipo-geracao), 
                                                input cembarque:screen-value in frame f-pg-sel,   
                                                input cembarque:screen-value in frame f-pg-sel,
                                                INPUT 0,
                                                INPUT 999999999,
                                                input no,
                                                input &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF,                       
                                                input 12/31/9999,                       
                                                input "",                               
                                                input "ZZZZZZZZZZZZZZZZZZZZ",           
                                                input "",                               
                                                input "ZZZZZZZZZZZZ",                   
                                                INPUT input frame f-pg-sel c-declaracao-imp,
                                                INPUT input frame f-pg-sel c-declaracao-imp,           
                                                input &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF,                       
                                                input 12/31/9999,                       
                                                input 0,                                
                                                input 99999,                            
                                                input 0,                                
                                                input 999999999,                        
                                                input 0,                                
                                                input &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF,                       
                                                input 12/31/9999,                       
                                                input "",                               
                                                input "ZZZZZZZZZZZZZZZZZZZZ",           
                                                &if "{&bf_cex_versao_ems}" >= "2.062" &then
                                                    &if "{&bf_mat_versao_ems}" >= "2.04" &then
                                                        input "",                 
                                                        input "ZZZZZZZZZZZZZZZZZZ",
                                                        input "",                 
                                                        input "ZZZZZZZZZZZZZZZZZZ",
                                                    &endif
                                                &else
                                                    &if '{&bf_mat_versao_ems}' >= '2.05' &then
                                                        input "",                 
                                                        input "ZZZZZZZZZZZZZZZZZZ",
                                                        input "",                 
                                                        input "ZZZZZZZZZZZZZZZZZZ",
                                                    &else
                                                        input "",
                                                        input "ZZZZZZZZZZZZZZZZZZ",
                                                    &endif
                                                &endif
                                                output table tt-selecao-embarque). 



    find first tt-selecao-embarque no-error.
    if  avail tt-selecao-embarque then do:
        assign i-num-reg = 0.
        for each tt-selecao-embarque
            USE-INDEX selecao:
            assign i-num-reg = i-num-reg + 1
                   tt-selecao-embarque.marca = "X":U.
        end.
        if  i-num-reg = 1 then              
            assign c-embarque-ini         = cembarque:screen-value in frame f-pg-sel
                   c-embarque-fim         = cembarque:screen-value in frame f-pg-sel
                   i-num-di-ems-ini       = 0
                   i-num-di-ems-fim       = 999999999
                   dt-nacionalizacao-ini  = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
                   dt-nacionalizacao-fim  = 12/31/9999
                   c-container-ini        = ""
                   c-container-fim        = "ZZZZZZZZZZZZZZZZZZZZ"
                   c-processo-ini         = ""
                   c-processo-fim         = "ZZZZZZZZZZZZ"
                   c-declaracao-imp-ini   = c-declaracao-imp:screen-value in frame f-pg-sel
                   c-declaracao-imp-fim   = c-declaracao-imp:screen-value in frame f-pg-sel
                   dt-di-ini              = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
                   dt-di-fim              = 12/31/9999
                   i-itinerario-ini       = 0
                   i-itinerario-fim       = 99999
                   i-exportador-ini       = 0
                   i-exportador-fim       = 999999999
                   i-localizacao          = 0
                   dt-chegada-ini         = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
                   dt-chegada-fim         = 12/31/9999
                   c-veiculo-transp-ini   = ""
                   c-veiculo-transp-fim   = "ZZZZZZZZZZZZZZZZZZZZ"
                   &if "{&bf_cex_versao_ems}" >= "2.062" &then
                       &if "{&bf_mat_versao_ems}" >= "2.04" &then
                           c-nr-conhecto-master-ini = ""                   
                           c-nr-conhecto-master-fim = "ZZZZZZZZZZZZZZZZZZZZZZZZZ" 
                           c-nr-conhecto-house-ini  = ""
                           c-nr-conhecto-house-fim  = "ZZZZZZZZZZZZZZZZZZZZZZZZZ"
                       &endif
                   &else
                       &if '{&bf_mat_versao_ems}' >= '2.05' &then
                           c-nr-conhecto-master-ini = ""                   
                           c-nr-conhecto-master-fim = "ZZZZZZZZZZZZZZZZZZZZZZZZZ" 
                           c-nr-conhecto-house-ini  = ""
                           c-nr-conhecto-house-fim  = "ZZZZZZZZZZZZZZZZZZZZZZZZZ"
                       &else
                           c-nr-conhecto-ini        = ""                   
                           c-nr-conhecto-fim        = "ZZZZZZZZZZZZZZZZZZ" 
                       &endif
                   &endif .
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-relat  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
  THEN DELETE WIDGET w-relat.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayChaveAcessoPadraoNac w-relat 
PROCEDURE displayChaveAcessoPadraoNac :
/*------------------------------------------------------------------------------
  Purpose: mostrar chave de acesso nfse padr’o nacional    
  Parameters:  
  Notes:   displayChaveAcessoPadraoNac     
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER ph-boin090 AS HANDLE NO-UNDO.
    
    DEFINE VARIABLE c-chave-nfse-aux AS CHARACTER   NO-UNDO.

    RUN retornaChaveAcessoPadraoNac IN ph-boin090 (INPUT  INPUT FRAME f-pg-sel ccod-emitente-desp,
                                                   INPUT  INPUT FRAME f-pg-sel cnr-docto,
                                                   INPUT  INPUT FRAME f-pg-sel ddata-emissao,
                                                   OUTPUT c-chave-nfse-aux).   
                                                  
    IF c-chave-nfse-aux <> "" AND c-chave-nfse-aux <> ? THEN DO:

        ASSIGN i-chaveNFSe-muni:SCREEN-VALUE      IN FRAME f-pg-sel = SUBSTRING(c-chave-nfse-aux,1,7)
               c-chaveNFSe-amb-ger:SCREEN-VALUE   IN FRAME f-pg-sel = SUBSTRING(c-chave-nfse-aux,8,1)
               c-chaveNFSe-tp-if:SCREEN-VALUE     IN FRAME f-pg-sel = SUBSTRING(c-chave-nfse-aux,9,1) 
               c-chaveNFSe-cgc:SCREEN-VALUE       IN FRAME f-pg-sel = SUBSTRING(c-chave-nfse-aux,10,14)
               d-chaveNFSe-nro-docto:SCREEN-VALUE IN FRAME f-pg-sel = SUBSTRING(c-chave-nfse-aux,24,13)
               c-chaveNFSe-data:SCREEN-VALUE      IN FRAME f-pg-sel = SUBSTRING(c-chave-nfse-aux,37,4)
               i-chaveNFSe-nr-nfe:SCREEN-VALUE    IN FRAME f-pg-sel = SUBSTRING(c-chave-nfse-aux,41,9)
               i-chaveNFSe-digito:SCREEN-VALUE    IN FRAME f-pg-sel = SUBSTRING(c-chave-nfse-aux,50,1).

        ENABLE i-chaveNFSe-muni       /*habilitar pois pode existir mais de um endere»o*/
               c-chaveNFSe-amb-ger    /*2-Sistema nacional de NFS-e 1-Prefeitura*/
               i-chaveNFSe-nr-nfe     /*habilitar para usuÿrio preencher*/
               i-chaveNFSe-digito     /*habilitar para usuÿrio preencher*/
            WITH FRAME f-pg-sel. 
            
    END.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-relat  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE im-pg-cla im-pg-sel im-pg-par bt-sel-embarques bt-sel-despesas 
         bt-limpa-selec bt-executar bt-cancelar bt-conferencia bt-ajuda 
      WITH FRAME f-relat IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY de-aliq-ipi de-aliq-icms c-tributacao-ipi c-tributacao-icms 
          ddata-vencto-ipi ddata-vencto-icms de-aliq-pis de-aliq-cofins 
          c-tributacao-pis c-tributacao-cofins de-aliq-ibsuf de-perc-red-ibsuf 
          de-aliq-ibsmun de-perc-red-ibsmun de-aliq-cbs de-perc-red-cbs 
          de-aliq-is 
      WITH FRAME f-pg-cla IN WINDOW w-relat.
  ENABLE RECT-9 RECT-19 de-aliq-ipi de-aliq-icms c-tributacao-ipi 
         c-tributacao-icms ddata-vencto-ipi ddata-vencto-icms de-aliq-pis 
         de-aliq-cofins c-tributacao-pis c-tributacao-cofins de-aliq-ibsuf 
         de-perc-red-ibsuf de-aliq-ibsmun de-perc-red-ibsmun de-aliq-cbs 
         de-perc-red-cbs de-aliq-is 
      WITH FRAME f-pg-cla IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-cla}
  DISPLAY c-it-serv c-desc-item cod-ibge-orig cod-ibge-dest EDITOR-2 
      WITH FRAME f-pg-par IN WINDOW w-relat.
  ENABLE RECT-10 RECT-15 RECT-18 c-it-serv c-desc-item cod-ibge-orig 
         cod-ibge-dest EDITOR-2 
      WITH FRAME f-pg-par IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  DISPLAY rb-tipo-geracao cembarque ccod-estabel ccod-emitente-desp ddata-trans 
          tg-agrupar-unico-fornec ddata-emissao cnatureza cserie cnr-docto 
          ccod-estabel-fisc ddata-cotacao c-cod-observacao cconta-trans 
          cccusto-trans codigoUF anoMesEmissao CnpjEmitente modelo serie 
          numeroNFE codigoNumerico digitoVerific i-chaveNFSe-muni 
          c-chaveNFSe-amb-ger c-chaveNFSe-tp-if c-chaveNFSe-cgc 
          d-chaveNFSe-nro-docto c-chaveNFSe-data i-chaveNFSe-nr-nfe 
          i-chaveNFSe-digito 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  ENABLE rb-tipo-geracao cembarque ccod-estabel ccod-emitente-desp ddata-trans 
         tg-agrupar-unico-fornec ddata-emissao cnatureza cserie cnr-docto 
         ccod-estabel-fisc ddata-cotacao c-cod-observacao cconta-trans 
         cccusto-trans codigoNumerico digitoVerific RECT-11 RECT-12 RECT-13 
         RECT-14 RECT-20 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  VIEW w-relat.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-relat 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.

   RETURN "OK":U.       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ContingenciaNFe w-relat 
PROCEDURE pi-ContingenciaNFe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-serie-SCAN   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-bodi317ef    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-retorno-aux  AS CHARACTER   NO-UNDO.

    IF  NOT VALID-HANDLE(h-bodi317ef) THEN
        RUN dibo/bodi317ef.p PERSISTENT SET h-bodi317ef.
    
    IF NOT CAN-FIND(FIRST emitente
                    WHERE emitente.cod-emitente = INPUT FRAME f-pg-sel ccod-emitente-desp) THEN DO:

        {utp/ut-liter.i Fornecedor *L}
        ASSIGN c-retorno-aux = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 2,
                          INPUT c-retorno-aux).
        APPLY "entry":U TO ccod-emitente-desp IN FRAME f-pg-sel.
        RETURN NO-APPLY.
    END.

    IF NOT CAN-FIND(FIRST natur-oper
                    WHERE natur-oper.nat-operacao =  INPUT FRAME f-pg-sel cnatureza:SCREEN-VALUE) THEN DO:

        {utp/ut-liter.i Natureza_Operacao * L}
        ASSIGN c-retorno-aux = TRIM(RETURN-VALUE).
        run utp/ut-msgs.p (input "show":U, 
                           input 2,
                           input c-retorno-aux).
        apply "entry":U to cnatureza in frame f-pg-sel.
        return no-apply.
    END.
    
    IF NOT CAN-FIND(FIRST estabelec
                    WHERE estabelec.cod-estabel = INPUT FRAME f-pg-sel ccod-estabel:SCREEN-VALUE) THEN DO:

        {utp/ut-liter.i Estabelecimento *L}
        ASSIGN c-retorno-aux = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 2,
                          INPUT c-retorno-aux).
        APPLY "entry":U TO ccod-estabel IN FRAME f-pg-sel.
        RETURN NO-APPLY.
    END.

    RUN verificaContingenciaNFe IN h-bodi317ef (INPUT  "PERGUNTA":U, /*Tipo de Msg*/
                                                INPUT  INPUT FRAME f-pg-sel ccod-emitente-desp:SCREEN-VALUE,
                                                INPUT  INPUT FRAME f-pg-sel cnatureza:SCREEN-VALUE,
                                                INPUT  INPUT FRAME f-pg-sel ccod-estabel:SCREEN-VALUE,
                                                INPUT  INPUT FRAME f-pg-sel cserie:SCREEN-VALUE,
                                                OUTPUT c-serie-SCAN,
                                                OUTPUT TABLE tt-erro-conting-nfe).

    IF  VALID-HANDLE(h-bodi317ef) THEN DO:
        DELETE PROCEDURE h-bodi317ef.
        ASSIGN h-bodi317ef = ?.
    END.
    
    IF  CAN-FIND (FIRST tt-erro-conting-nfe) THEN
        FOR EACH tt-erro-conting-nfe NO-LOCK:
    
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT tt-erro-conting-nfe.cd-erro,
                               INPUT tt-erro-conting-nfe.mensagem).
    
            /*Pergunta*/
            IF  RETURN-VALUE <> "yes":U THEN
                RETURN "NOK":U.

            /*Erro*/
            &IF '{&bf_dis_versao_ems}' <= '2.062' &THEN                                     
                IF  CAN-FIND (FIRST cad-msgs NO-LOCK                                        
                              WHERE cad-msgs.cd-msg   = tt-erro-conting-nfe.cd-erro         
                              AND   cad-msgs.tipo-msg = 1) /* 1 - Erro */                   
                                                                                            
            &ELSE                                                                           
                IF  CAN-FIND (FIRST cadast_msg NO-LOCK                                      
                              WHERE cadast_msg.cdn_msg     = tt-erro-conting-nfe.cd-erro    
                              AND   cadast_msg.idi_tip_msg = 1) /* 1 - Erro */              
            &ENDIF THEN RETURN "NOK":U.                

        END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar w-relat 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var l-embarque-invalido as log no-undo.
    DEF VAR l-nota-fat          AS LOG NO-UNDO.

    do on error undo, return error on stop  undo, return error:

        RUN pi-validate-ibge.
        IF RETURN-VALUE <> "OK":U THEN
            RETURN "NOK":U.

        /*--- Contingˆncia NF-e --*/
        IF  l-spp-nfe THEN DO:
        
            RUN pi-ContingenciaNFe.
            IF  RETURN-VALUE <> "OK":U THEN
                RETURN "NOK":U.
        END. /* IF  l-spp-nfe THEN DO: */
        /*-----------------------------[ Contingˆncia NF-e ]---*/

        ASSIGN c-chave-nfe = "".
        IF  l-spp-nfe 
        AND l-emitente-nfe 
        AND NOT log-nfse-nacional THEN DO: 
            ASSIGN INPUT FRAME f-pg-sel codigoUF      
                   INPUT FRAME f-pg-sel anoMesEmissao 
                   INPUT FRAME f-pg-sel CnpjEmitente  
                   INPUT FRAME f-pg-sel modelo        
                   INPUT FRAME f-pg-sel serie         
                   INPUT FRAME f-pg-sel numeroNFE     
                   INPUT FRAME f-pg-sel codigoNumerico
                   INPUT FRAME f-pg-sel digitoVerific .

            FOR FIRST natur-oper FIELDS(imp-nota) NO-LOCK
                WHERE natur-oper.nat-operacao = INPUT FRAME f-pg-sel cnatureza:
                ASSIGN l-nota-fat = natur-oper.imp-nota.
            END.

            IF  NOT l-nota-fat THEN DO:
                RUN piValidaDigito.

                IF  RETURN-VALUE <> "OK":U THEN DO:
                    APPLY "entry":U TO digitoVerific IN FRAME f-pg-sel.
                    RETURN "NOK":U.
                END. /* IF  RETURN-VALUE <> "OK":U */
            END. /* IF  NOT l-nota-fat THEN DO: */
        END. /* IF  l-spp-nfe AND l-emitente-nfe THEN */
        IF log-nfse-nacional THEN DO:
            ASSIGN INPUT FRAME f-pg-sel i-chaveNFSe-muni
                   INPUT FRAME f-pg-sel c-chaveNFSe-amb-ger
                   INPUT FRAME f-pg-sel c-chaveNFSe-tp-if
                   INPUT FRAME f-pg-sel c-chaveNFSe-cgc
                   INPUT FRAME f-pg-sel d-chaveNFSe-nro-docto
                   INPUT FRAME f-pg-sel c-chaveNFSe-data
                   INPUT FRAME f-pg-sel i-chaveNFSe-nr-nfe
                   INPUT FRAME f-pg-sel i-chaveNFSe-digito.
                   
            /* Chave de acesso padr’o nacional - 50 digitos */       
            ASSIGN c-chave-nfe = TRIM(STRING(i-chaveNFSe-muni,"9999999")        + /*7*/
                                 c-chaveNFSe-amb-ger                            + /*1*/
                                 c-chaveNFSe-tp-if                              + /*1*/
                                 c-chaveNFSe-cgc                                + /*14*/
                                 STRING(d-chaveNFSe-nro-docto,"9999999999999")  + /*13*/
                                 c-chaveNFSe-data                               + /*4*/
                                 STRING(i-chaveNFSe-nr-nfe,"999999999")         + /*9*/
                                 STRING(i-chaveNFSe-digito, "9"))                 /*1*/ .                    
        END.

        ASSIGN INPUT FRAME f-pg-sel
               ccod-emitente-desp
               ddata-trans
               ddata-emissao 
               cnr-docto
               cserie
               cnatureza 
               ccod-estabel-fisc
               ddata-cotacao
               c-cod-observacao
               cconta-trans
               cccusto-trans
               tg-agrupar-unico-fornec no-error.

        assign input frame f-pg-cla
               ddata-vencto-ipi
               ddata-vencto-icms 
               de-aliq-ipi
               de-aliq-icms
               c-tributacao-ipi
               c-tributacao-icms 
               de-aliq-pis
               de-aliq-cofins
               c-tributacao-pis
               c-tributacao-cofins no-error.

        ASSIGN INPUT FRAME f-pg-par
               c-it-serv
               editor-2 no-error.

        if  not valid-handle(h-im0101a) then            
            run imp/im0101a.p persistent set h-im0101a.

        /** Se nao encontrar nenhum embarque selecionado cria a tabela com os dados informados em tela **/
        if  not can-find(first tt-selecao-embarque
                         where tt-selecao-embarque.marca = "X") then do:
            if  not valid-handle (h-bocx220h) then
                run cxbo/bocx220h.p persistent set h-bocx220h.
            /* selecao usando o embarque informado em tela */
            run chamaCarregaTtSelecaoEmbarque in this-procedure.
            if  not can-find (first tt-selecao-embarque) then do:
                /** Embarque informado em tela e invalido, mas cria o registro na tt-selecao-embarque
                    para criar os erros no im0101a e mostrar ao usuario  **/
                create tt-selecao-embarque.

                ASSIGN FRAME f-pg-sel rb-tipo-geracao.
                IF  rb-tipo-geracao = 1 /* Embarque*/ THEN DO:
                    ASSIGN tt-selecao-embarque.embarque = cembarque:screen-value in frame f-pg-sel
                           INPUT FRAME f-pg-sel cembarque
                           INPUT FRAME f-pg-sel ccod-estabel.
                    IF NOT VALID-HANDLE(h-bocx402) THEN RUN cxbo/bocx402.p PERSISTENT SET h-bocx402.

                    RUN verificaRelacionamentos IN h-bocx402 (INPUT cembarque, INPUT ccod-estabel, OUTPUT vnum-di-siscomex, OUTPUT l-encontrou, OUTPUT vdat-di, OUTPUT vnat-operacao).

                    IF  l-encontrou THEN DO:
                        /* Como existe DI relacionada ao embarque, entÆo a l¢gica segue a linha do Tipo de Nacionaliza‡Æo DI (tipo 2)*/
                        IF NOT VALID-HANDLE(h-bocx220a) THEN RUN cxbo/bocx220a.p PERSISTENT SET h-bocx220a.
                        RUN pi-recebe-tp-nacionaliz IN h-bocx220a (INPUT 2).

                        RUN verificaCalculosDI IN h-bocx402 (INPUT vnum-di-siscomex, OUTPUT llog-situacao, OUTPUT ccalculo-faltante). 

                        IF  NOT llog-situacao THEN DO:
                            RUN utp/ut-msgs.p (INPUT 'show', INPUT 52260, INPUT string(vnum-di-siscomex) + '~~' + ccalculo-faltante).
                            RETURN NO-APPLY.
                        END. /* IF  NOT llog-situacao */

                        ASSIGN tt-selecao-embarque.declaracao-import = vnum-di-siscomex.
                    END. /* IF  l-encontrou */
                END. /* IF  i-tipo-geracao = 1 */
                ELSE DO:
                    ASSIGN tt-selecao-embarque.declaracao-import = c-declaracao-imp:SCREEN-VALUE IN FRAME f-pg-sel
                           tt-selecao-embarque.embarque = cembarque:screen-value in frame f-pg-sel.
                END. /* ELSE DO: */

                ASSIGN tt-selecao-embarque.cod-estabel       = ccod-estabel:screen-value in frame f-pg-sel
                       tt-selecao-embarque.marca             = "X":U
                       l-embarque-invalido                   = yes.
            
            end. /* if  not can-find(first tt-selecao-embarque) */
            if  valid-handle (h-bocx220h) then do:
                delete procedure h-bocx220h.
                assign h-bocx220h = ?.
            end. /* if  valid-handle (h-bocx220h) */
        end. /* if  not can-find(first tt-selecao-embarque */

        for each  tt-selecao-embarque
            where tt-selecao-embarque.marca = "X":U
            USE-INDEX selecao:

            create tt-param-im0101.
            assign tt-param-im0101.embarque             = tt-selecao-embarque.embarque
                   tt-param-im0101.cod-estabel          = tt-selecao-embarque.cod-estabel 
                   tt-param-im0101.num-di-ems           = tt-selecao-embarque.num-di-ems
                   tt-param-im0101.declaracao-import    = tt-selecao-embarque.declaracao-import
                   tt-param-im0101.cod-emitente-desp    = ccod-emitente-desp
                   tt-param-im0101.da-transacao         = ddata-trans
                   tt-param-im0101.da-emissao           = ddata-emissao
                   tt-param-im0101.da-venc-ipi          = ddata-vencto-ipi
                   tt-param-im0101.da-venc-icms         = ddata-vencto-icms
                   &if defined(bf-mat-comex) &then                    
                       tt-param-im0101.nro-docto        = integer(cnr-docto)
                   &else                                 
                       tt-param-im0101.nro-docto        = cnr-docto                    
                   &endif                                
                   tt-param-im0101.serie                = cserie
                   tt-param-im0101.nat-operacao         = cnatureza
                   tt-param-im0101.estab-fisc           = ccod-estabel-fisc
                   tt-param-im0101.ct-transit           = cconta-trans
                   tt-param-im0101.sc-transit           = cccusto-trans
                   tt-param-im0101.da-cotacao           = ddata-cotacao
                   tt-param-im0101.observacao           = editor-2
                   tt-param-im0101.aliquota-ipi         = de-aliq-ipi
                   tt-param-im0101.aliquota-icms        = de-aliq-icms
                   tt-param-im0101.aliquota-pis         = de-aliq-pis
                   tt-param-im0101.aliquota-cofins      = de-aliq-cofins
                   tt-param-im0101.i-tributacao-ipi     = {ininc/i10in172.i 06 c-tributacao-ipi}
                   tt-param-im0101.i-tributacao-icms    = {ininc/i01in245.i 06 c-tributacao-icms}
                   tt-param-im0101.i-tributacao-pis     = {ininc/i04in176.i 06 c-tributacao-pis}
                   tt-param-im0101.i-tributacao-cofins  = {ininc/i04in176.i 06 c-tributacao-cofins}
                   tt-param-im0101.usuario              = c-seg-usuario
                   tt-param-im0101.l-acomp              = yes
                   tt-param-im0101.i-pais-impto-usuario = i-pais-impto-usuario
                   tt-param-im0101.l-agrupar-unico-forn = tg-agrupar-unico-fornec
                   tt-param-im0101.chave-nfe            = c-chave-nfe
                   tt-param-im0101.cod-item-serv        = c-it-serv:SCREEN-VALUE IN FRAME f-pg-par
                   tt-param-im0101.cod-ibge-orig        = INPUT FRAME f-pg-par cod-ibge-orig
                   tt-param-im0101.cod-ibge-dest        = INPUT FRAME f-pg-par cod-ibge-dest.

            IF l-nt2024002 THEN DO:
                ASSIGN INPUT FRAME f-pg-cla 
                       de-aliq-ibsuf 
                       de-aliq-ibsmun 
                       de-aliq-cbs
                       de-aliq-is
                       de-perc-red-ibsuf
                       de-perc-red-ibsmun
                       de-perc-red-cbs.
                ASSIGN tt-param-im0101.aliquota-ibsuf  = de-aliq-ibsuf
                       tt-param-im0101.aliquota-ibsmun = de-aliq-ibsmun
                       tt-param-im0101.aliquota-cbs    = de-aliq-cbs
                       tt-param-im0101.aliquota-is     = de-aliq-is
                       tt-param-im0101.perc-red-ibsuf  = de-perc-red-ibsuf
                       tt-param-im0101.perc-red-ibsmun = de-perc-red-ibsmun
                       tt-param-im0101.perc-red-cbs    = de-perc-red-cbs.
            END.
            
            if  c-cod-observacao = "Industria" then 
                &if defined(bf-mat-comex) &then 
                    assign tt-param-im0101.cod-observacao = 0.
                &else
                    assign tt-param-im0101.cod-observacao = 1.
                &endif        
            else
                &if defined(bf-mat-comex) &then 
                    assign tt-param-im0101.cod-observacao   = 3.
                &else
                    assign tt-param-im0101.cod-observacao   = 4.
                &endif
        end. /* for each  tt-selecao-embarque */

        if  l-embarque-invalido then do:
            for each tt-selecao-embarque:
                delete tt-selecao-embarque.
            end.
        end.

        if  can-find(first tt-desp-embarque) then do:

            for each tt-desp-embarque
                USE-INDEX ch-embarque:

                if not can-find(first tt-selecao-embarque
                                where tt-selecao-embarque.cod-estabel = tt-desp-embarque.cod-estabel
                                  and tt-selecao-embarque.embarque    = tt-desp-embarque.embarque
                                  and tt-selecao-embarque.marca       = "X":U)
                    OR not tt-desp-embarque.selecionado then
                    delete tt-desp-embarque.
            end. /* for each tt-desp-embarque USE-INDEX ch-embarque: */
        end. /* if  can-find(first tt-desp-embarque) */
        else do:
            assign input frame f-pg-sel tg-agrupar-unico-fornec
                   input frame f-pg-sel ccod-emitente-desp.

            if  tg-agrupar-unico-fornec = yes 
            and ccod-emitente-desp = 0 then do:
                {utp/ut-liter.i Fornecedor_deve_ser_informado * L}
                run utp/ut-msgs.p (input "show":U, 
                                   input 25997,
                                   input RETURN-VALUE + ".").

                apply "entry":U to ccod-emitente-desp in frame f-pg-sel.
                return no-apply.
            end. /* if  tg-agrupar-unico-fornec */

            if  not valid-handle(h-bocx310a) then
                run cxbo/bocx310a.p persistent set h-bocx310a.

            run piRetornaSelecaoDespesa in h-bocx310a (input tg-agrupar-unico-fornec,
                                                       input ccod-emitente-desp,
                                                       input  0,
                                                       input  99999,
                                                       input  0,
                                                       input  999999999,
                                                       input  0,
                                                       input  99999,
                                                       input  table tt-selecao-embarque,
                                                       output table tt-desp-embarque).
            for each  tt-selecao-embarque
                where tt-selecao-embarque.marca = "X":U:

                for each  tt-desp-embarque
                    where tt-desp-embarque.cod-estabel = tt-selecao-embarque.cod-estabel
                    and   tt-desp-embarque.embarque    = tt-selecao-embarque.embarque
                    USE-INDEX ch-embarque:

                    assign tt-desp-embarque.selecionado = yes.
                end. /* for each  tt-desp-embarque */
            end. /* for each  tt-selecao-embarque */

            for each  tt-desp-embarque
                where tt-desp-embarque.selecionado = no:
                delete tt-desp-embarque.
            end. /* for each  tt-desp-embarque */

            if  valid-handle (h-bocx310a) then do:
                delete procedure h-bocx310a.
                assign h-bocx310a = ?.
            end. /* if  valid-handle (h-bocx310a) */
        end. /* else do: */ 

        RUN setTtSelecao     IN h-im0101a (input table tt-desp-embarque).
        RUN rateioDespCompDI IN THIS-PROCEDURE.
        run createNFComplementar in h-im0101a (INPUT  int(rb-tipo-geracao),
                                               input  table tt-param-im0101,
                                               output table tt-docum-est-atu-aux,
                                               output table RowErrors).
        if  valid-handle (h-im0101a) then
            delete procedure h-im0101a.    
        if  can-find(first RowErrors 
                     where RowErrors.ErrorSubtype <> "ERROR":U) 
        and return-value = "OK":U then do:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="yes"}
        end.

        if  can-find(first RowErrors 
                     where RowErrors.ErrorSubtype <> "INFORMATION":U) 
        and return-value = "OK":U then do:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="yes"}
            run pi-inicializa-valores.
        end.

        if  can-find(first RowErrors) and return-value = "NOK":U then do:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="yes"}
            return "NOK":U.
        end.
    end. /* do  on error undo, return error on stop  undo, return error: */

    if  not can-find(first RowErrors 
                     where RowErrors.ErrorSubtype = "ERROR":U) then do:
        run pi-gera-relat-acomp (input table tt-docum-est-atu-aux).
        
        IF l-executar THEN DO:
            FOR EACH tt-desp-embarque:
                DELETE tt-desp-embarque.
            END.
            FOR EACH tt-desp-embarque-aux:
                DELETE tt-desp-embarque-aux.
            END.

            FOR EACH tt-selecao-embarque:
                DELETE tt-selecao-embarque.
            END.
        END.
    end.
    RUN pi-Upc( input "efetua-rateio",
                input "CONTAINER",
                input {&WINDOW-NAME}:HANDLE,
                input FRAME f-pg-sel:HANDLE,
                input "",
                input "") NO-ERROR.

    RETURN "OK":U.           
end PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-relat-acomp w-relat 
PROCEDURE pi-gera-relat-acomp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    define input parameter table for tt-docum-est-atu-aux.

    output stream relat-acomp to value (session:temp-directory + "im0101.tmp") CONVERT TARGET "iso8859-1":U. 

    find first tt-docum-est-atu-aux no-lock no-error.

    find first tt-param-im0101 no-error.
    if  avail tt-param-im0101 then do:

        &if defined(bf-mat-comex) &then 
            if  tt-param-im0101.cod-observacao = 0 then
                assign ccod-observacao = "Industria".
            if  tt-param-im0101.cod-observacao = 3 then
                assign ccod-observacao = "Servico".
        &else
            if  tt-param-im0101.cod-observacao = 1 then 
                assign ccod-observacao = "Industria".
            if  tt-param-im0101.cod-observacao = 4 then
                assign ccod-observacao = "Servico".
        &endif        

        IF int(rb-tipo-geracao:SCREEN-VALUE IN FRAME f-pg-sel) = 1 THEN DO:
            {utp/ut-liter.i "Embarque"}
            ASSIGN cdiembarqueframe   = c-embarque-anterior
                   c-tipo-geracao     = RETURN-VALUE.
        END.
        ELSE DO:
            {utp/ut-liter.i "Declaracao Importacao"}
             ASSIGN cdiembarqueframe   = c-di-anterior
                    cdiembarqueframe:LABEL IN FRAME f-param = RETURN-VALUE
                    c-tipo-geracao     = RETURN-VALUE.
        END.        
        
        assign ctributacao-ipi  = {ininc/i10in172.i 04 tt-param-im0101.i-tributacao-ipi}
               ctributacao-icms = {ininc/i01in245.i 04 tt-param-im0101.i-tributacao-icms}
               ctributacao-pis  = {ininc/i04in176.i 04 tt-param-im0101.i-tributacao-pis}
               ctributacao-cofins = {ininc/i04in176.i 04 tt-param-im0101.i-tributacao-cofins}.
        IF l-executar THEN DO:
            {utp/ut-liter.i "Mensagem"}
            c-mensagem = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "Cod."}
            PUT stream relat-acomp SKIP(2)
                trim(RETURN-VALUE) FORMAT "x(5)" AT 01
                c-mensagem   AT 07 SKIP
                FILL('-', 5) AT 01 FORMAT "x(5)"
                FILL('-', 120) AT 07 FORMAT "x(120)" SKIP.
        END.

        IF l-executar AND 
           nr-docto-aux <> "" AND 
           nr-docto-old <> tt-param-im0101.nro-docto THEN DO:
            run utp/ut-msgs.p (input "help", input 5268, nr-docto-old + "~~" +  tt-param-im0101.nro-docto).
            ASSIGN c-mensagem = TRIM(RETURN-VALUE).
            RUN pi-print-editor (INPUT TRIM(RETURN-VALUE), INPUT 120).   
            FOR EACH tt-editor:
                IF tt-editor.linha = 1 THEN
                   PUT stream relat-acomp
                       string(5268) FORMAT "x(5)" AT 01
                       tt-editor.conteudo AT 07 SKIP.
                ELSE 
                   PUT stream relat-acomp
                       tt-editor.conteudo AT 07 SKIP.
            END.
            ASSIGN tt-param-im0101.nro-docto = nr-docto-old.
        END.

        IF l-executar THEN DO:
            run utp/ut-msgs.p ( input "msg", input 27207, "").
            ASSIGN c-mensagem = TRIM(RETURN-VALUE).
            PUT stream relat-acomp 
                STRING(27207) FORMAT "x(5)" AT 01
                c-mensagem AT 07 SKIP(2).
        END.
        
        disp stream relat-acomp
            c-tipo-geracao
            cdiembarqueframe                               
            tt-param-im0101.cod-estabel         
            tt-param-im0101.cod-emitente-desp   
            tt-param-im0101.da-transacao        
            tt-param-im0101.l-agrupar-unico-forn
            tt-param-im0101.da-emissao          
            tt-param-im0101.nro-docto           
            tt-param-im0101.estab-fisc          
            tt-param-im0101.serie               
            tt-param-im0101.nat-operacao        
            tt-param-im0101.da-cotacao          
            ccod-observacao                     
            tt-param-im0101.ct-transit       
            tt-param-im0101.sc-transit
            tt-param-im0101.aliquota-ipi        
            tt-param-im0101.aliquota-icms       
            ctributacao-ipi                     
            ctributacao-icms                    
            tt-param-im0101.da-venc-ipi         
            tt-param-im0101.da-venc-icms
            tt-param-im0101.aliquota-pis
            tt-param-im0101.aliquota-cofins
            ctributacao-pis
            ctributacao-cofins
            tt-param-im0101.aliquota-ibsuf
            tt-param-im0101.perc-red-ibsuf
            tt-param-im0101.aliquota-cbs
            tt-param-im0101.perc-red-cbs
            tt-param-im0101.aliquota-ibsmun
            tt-param-im0101.perc-red-ibsmun
            tt-param-im0101.aliquota-is
            tt-param-im0101.cod-item-serv with frame f-param.
    end.

    {utp/ut-liter.i EMBARQUES_SELECIONADOS * L}
    put stream relat-acomp
                                         skip(2)
        "------------------------" at 45 skip      
        RETURN-VALUE               at 46 skip      
        "------------------------" at 45 skip(2). 

    for each  tt-selecao-embarque
        where tt-selecao-embarque.marca = "X":U:
        &if "{&bf_mat_versao_ems}" <= "2.04" &then
            disp stream relat-acomp
                tt-selecao-embarque.embarque          
                tt-selecao-embarque.cod-incoterm                             
                tt-selecao-embarque.declaracao-import 
                tt-selecao-embarque.nr-conhecimento with frame f-sel-embarque.
            down with frame f-sel-embarque.
        &else
            disp stream relat-acomp
                tt-selecao-embarque.embarque            
                tt-selecao-embarque.cod-incoterm                               
                tt-selecao-embarque.declaracao-import   
                tt-selecao-embarque.cod-conhecto-master        
                tt-selecao-embarque.cod-conhecto-house with frame f-sel-embarque-2.
            down with frame f-sel-embarque-2.
        &endif
    end.

    {utp/ut-liter.i DESPESAS_SELECIONADOS * L}
    put stream relat-acomp
                                         skip(2)   
        "------------------------" at 45 skip
        RETURN-VALUE               at 46 skip
        "------------------------" at 45 skip(2).

    for each  tt-desp-embarque
        where tt-desp-embarque.selecionado = yes:
        disp stream relat-acomp
            tt-desp-embarque.cod-desp          
            tt-desp-embarque.desc-desp         
            tt-desp-embarque.cod-emitente-desp 
            tt-desp-embarque.embarque          
            tt-desp-embarque.cod-pto-contr     
            tt-desp-embarque.val-desp          
            tt-desp-embarque.cond-pagto with frame f-sel-despesa.
        down with frame f-sel-despesa.
    end.

    find docum-est 
        where docum-est.cod-emitente = input frame f-pg-sel ccod-emitente-desp
        and   docum-est.nro-docto    = input frame f-pg-sel cnr-docto
        and   docum-est.serie-docto  = input frame f-pg-sel cserie
        and   docum-est.nat-operacao = input frame f-pg-sel cnatureza no-lock no-error.
    if  avail docum-est then do:
        disp stream relat-acomp
            docum-est.cod-emitente  
            docum-est.nro-docto    
            docum-est.serie-docto   
            docum-est.nat-operacao 
            docum-est.valor-mercad with frame f-documento.
    end.
    else do:
        find docum-est
            where docum-est.cod-emitente = input frame f-pg-sel ccod-emitente-desp
            and   docum-est.nro-docto    = tt-docum-est-atu-aux.nro-docto
            and   docum-est.serie-docto  = input frame f-pg-sel cserie
            and   docum-est.nat-operacao = input frame f-pg-sel cnatureza no-lock no-error.

        if  avail docum-est then do:
            disp stream relat-acomp
                docum-est.cod-emitente  
                docum-est.nro-docto
                docum-est.serie-docto   
                docum-est.nat-operacao 
                docum-est.valor-mercad with frame f-documento.
        end.
    end.

    if  not valid-handle (h-bocx095) then
        run cxbo/bocx095.p persistent set h-bocx095.

    if  not valid-handle (h-bocx310) then
        run cxbo/bocx310.p persistent set h-bocx310.

    put stream relat-acomp skip (2).
    for each  docum-est-cex 
        where docum-est-cex.serie-docto       = docum-est.serie-docto
        and   docum-est-cex.nro-docto         = docum-est.nro-docto
        and   docum-est-cex.cod-emitente      = docum-est.cod-emitente
        and   docum-est-cex.nat-operacao      = docum-est.nat-operacao no-lock:
    
        RUN findDespesa IN h-bocx310 (INPUT docum-est.cod-estabel,
                                      INPUT docum-est.embarque,
                                      INPUT docum-est-cex.cod-desp,
                                      OUTPUT c-return).
        IF c-return = "":U THEN DO:
            RUN getCharField IN h-bocx310(INPUT "descricao":U,
                                          OUTPUT cdescricaodesp).
        END.
        ELSE 
            run retornaDescDespesa in h-bocx095 (input docum-est-cex.cod-desp, output cdescricaodesp).

        disp stream relat-acomp
            docum-est-cex.cod-desp         
            cdescricaodesp                 
            docum-est-cex.cod-emitente-desp
            docum-est-cex.val-desp         
            docum-est-cex.cod-cond-pag with frame f-despesa-cex.
        down with frame f-despesa-cex.
    end.

    if  valid-handle (h-bocx095) then do:
        delete procedure h-bocx095.
        assign h-bocx095 = ?.
    end.

    if  valid-handle (h-bocx310) then do:
        delete procedure h-bocx310.
        assign h-bocx310 = ?.
    end.

    output stream relat-acomp close.

    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = 3
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.arquivo         = session:temp-directory + "im0101.tmp".

    {include/i-rptrm.i}

    return "OK":U.           
end PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-valores w-relat 
PROCEDURE pi-inicializa-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    clear frame f-pg-sel.
    clear frame f-pg-cla.
    clear frame f-pg-par.
    
    /* 
    ** inicializa‡Æo dos valores de tela
    */
    assign c-tributacao-ipi:list-items in frame f-pg-cla    = {ininc/i10in172.i 03}
           c-tributacao-icms:list-items in frame f-pg-cla   = {ininc/i10in172.i 03}
           c-tributacao-pis:list-items in frame f-pg-cla    = {ininc/i04in176.i 03}
           c-tributacao-cofins:list-items in frame f-pg-cla = {ininc/i04in176.i 03}.
    
    assign ddata-trans:screen-value in frame f-pg-sel       = string(today)
           ddata-emissao:screen-value in frame f-pg-sel     = string(today)
           ddata-vencto-ipi:screen-value in frame f-pg-cla  = string(today)
           ddata-vencto-icms:screen-value in frame f-pg-cla = string(today)
           ddata-cotacao:screen-value in frame f-pg-sel     = string(today)
           c-tributacao-ipi:screen-value in frame f-pg-cla  = {ininc/i10in172.i 04 1}
           c-tributacao-icms:screen-value in frame f-pg-cla = {ininc/i01in245.i 04 1}
           c-tributacao-pis:screen-value in frame f-pg-cla  = {ininc/i04in176.i 04 1}
           c-tributacao-cofins:screen-value in frame f-pg-cla = {ininc/i04in176.i 04 1}
           de-aliq-ipi:screen-value in frame f-pg-cla       = string(0)
           de-aliq-icms:screen-value in frame f-pg-cla      = string(0)
           de-aliq-pis:screen-value in frame f-pg-cla       = string(0)
           de-aliq-cofins:screen-value in frame f-pg-cla    = string(0)
           c-it-serv:screen-value in frame f-pg-par         = "".
    
    &if '{&bf_libera_15_posicoes}' = 'yes' &then
        assign c-formato-nf = ">>>>>>>>9999999". /* Formato de 15 posi»„es */
    &else
        assign c-formato-nf = ">>>9999999". /* Formato de 10 posi»„es */
    &endif

    IF l-nt2024002 THEN DO:
        ASSIGN de-aliq-ibsuf:SCREEN-VALUE      IN FRAME f-pg-cla = STRING(0)
               de-aliq-ibsmun:SCREEN-VALUE     IN FRAME f-pg-cla = STRING(0)
               de-aliq-cbs:SCREEN-VALUE        IN FRAME f-pg-cla = STRING(0)
               de-aliq-is:SCREEN-VALUE         IN FRAME f-pg-cla = STRING(0)
               de-perc-red-ibsuf:SCREEN-VALUE  IN FRAME f-pg-cla = STRING(0)
               de-perc-red-ibsmun:SCREEN-VALUE IN FRAME f-pg-cla = STRING(0)
               de-perc-red-cbs:SCREEN-VALUE    IN FRAME f-pg-cla = STRING(0).
    END.
    
    APPLY "VALUE-CHANGED":U TO rb-tipo-geracao IN FRAME f-pg-sel.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-conta-trans w-relat 
PROCEDURE pi-mostra-conta-trans :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-return        AS CHARACTER   NO-UNDO.

    APPLY "LEAVE":U TO ccod-estabel IN FRAME f-pg-sel.

    IF NOT VALID-HANDLE(h-bocx250) THEN
        RUN cxbo/bocx250.p PERSISTENT SET h-bocx250.

    EMPTY TEMP-TABLE tt-param-imp.

    RUN findCodigo IN h-bocx250 (INPUT ccod-estabel,
                                 OUTPUT c-return).

    IF c-return = "":U THEN
        RUN GetCurrent IN h-bocx250 (OUTPUT TABLE tt-param-imp).

    FOR FIRST tt-param-imp:
        ASSIGN cconta-trans = tt-param-imp.ct-transit-import.
    END.

    DISP cconta-trans WITH FRAME f-pg-sel.

    DELETE PROCEDURE h-bocx250.
    ASSIGN h-bocx250 = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-empresa w-relat 
PROCEDURE pi-retorna-empresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-return        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE r-rowid-estabel AS ROWID       NO-UNDO.
    DEFINE VARIABLE h-boad107       AS HANDLE      NO-UNDO.

    ASSIGN i-empresa       = i-empresa-prin.
           r-rowid-estabel = ?.

    IF NOT VALID-HANDLE(h-boad107) THEN
        RUN adbo/boad107.p PERSISTENT SET h-boad107.

    EMPTY TEMP-TABLE tt-estabelec.
    RUN findCodigo IN h-boad107 (INPUT INPUT FRAME f-pg-sel ccod-estabel,
                                 OUTPUT c-return).
    IF c-return = "":U THEN DO:
        ASSIGN INPUT FRAME f-pg-sel ccod-estabel.
        RUN GetCurrent IN h-boad107 (OUTPUT TABLE tt-estabelec).
    END.

    FOR FIRST tt-estabelec:
        ASSIGN r-rowid-estabel = tt-estabelec.r-rowid.
    END.

    RUN cdp/cd9970.p (INPUT r-rowid-estabel,
                      OUTPUT i-empresa).

    DELETE PROCEDURE h-boad107.
    ASSIGN h-boad107 = ?.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina w-relat 
PROCEDURE pi-troca-pagina :
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Upc w-relat 
PROCEDURE pi-Upc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-ind-event     AS CHAR          NO-UNDO.
DEF INPUT PARAM p-ind-object    AS CHAR          NO-UNDO.
DEF INPUT PARAM p-wgh-object    AS HANDLE        NO-UNDO.
DEF INPUT PARAM p-wgh-frame     AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p-cod-table     AS CHAR          NO-UNDO.
DEF INPUT PARAM p-row-table     AS ROWID         NO-UNDO.


IF  c-nom-prog-dpc-mg97  <> "" THEN RUN VALUE(c-nom-prog-dpc-mg97) (p-ind-event,p-ind-object,p-wgh-object,p-wgh-frame,p-cod-table,p-row-table) NO-ERROR.
IF  c-nom-prog-appc-mg97 <> "" THEN RUN VALUE(c-nom-prog-appc-mg97)(p-ind-event,p-ind-object,p-wgh-object,p-wgh-frame,p-cod-table,p-row-table) NO-ERROR.
IF  c-nom-prog-upc-mg97  <> "" THEN RUN VALUE(c-nom-prog-upc-mg97) (p-ind-event,p-ind-object,p-wgh-object,p-wgh-frame,p-cod-table,p-row-table) NO-ERROR.

IF RETURN-VALUE = "NOK":U THEN
    RETURN ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate-ibge w-relat 
PROCEDURE pi-validate-ibge :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF cod-ibge-orig:SCREEN-VALUE IN FRAME f-pg-par <> "" THEN DO:
        IF NOT CAN-FIND(FIRST cidade 
                                        WHERE cidade.cdn-munpio-ibge = INT(cod-ibge-orig:SCREEN-VALUE IN FRAME f-pg-par)) THEN DO:
            APPLY 'MOUSE-SELECT-CLICK' TO im-pg-par IN FRAME f-relat.
                APPLY 'entry' TO cod-ibge-orig IN FRAME f-pg-par.
                {utp/ut-liter.i "Origem" *}
                run utp/ut-msgs.p (INPUT "show",
                                                   INPUT 55635,
                                                   INPUT RETURN-VALUE).
                RETURN "NOK":U.
        END.
    END.
    ELSE DO:
        IF CAN-FIND(FIRST natur-oper
                                WHERE natur-oper.nat-operacao = INPUT FRAME f-pg-sel cnatureza
                                  AND natur-oper.tipo-compra = 2) 
        AND (modelo:SCREEN-VALUE IN FRAME f-pg-sel = "57" 
        OR   modelo:SCREEN-VALUE IN FRAME f-pg-sel = "63" 
        OR   modelo:SCREEN-VALUE IN FRAME f-pg-sel = "67") THEN DO:
                {utp/ut-liter.i "Origem" *}
                RUN utp/ut-msgs.p (INPUT "show",
                                                   INPUT 55636, 
                                                   INPUT TRIM(RETURN-VALUE)).
            APPLY 'MOUSE-SELECT-CLICK' TO im-pg-par IN FRAME f-relat.
                APPLY 'entry' TO cod-ibge-orig IN FRAME f-pg-par.
                RETURN "NOK":U.
        END.
    END.
    
    IF cod-ibge-dest:SCREEN-VALUE IN FRAME f-pg-par <> "" THEN DO:
        IF NOT CAN-FIND(FIRST cidade 
                                        WHERE cidade.cdn-munpio-ibge = INT(cod-ibge-dest:SCREEN-VALUE IN FRAME f-pg-par)) THEN DO:
            APPLY 'MOUSE-SELECT-CLICK' TO im-pg-par IN FRAME f-relat.
                APPLY 'entry' TO cod-ibge-dest IN FRAME f-pg-par.
                {utp/ut-liter.i "Destino" *}
                run utp/ut-msgs.p (INPUT "show",
                                                   INPUT 55635,
                                                   INPUT RETURN-VALUE).
                RETURN "NOK":U.
        END.
    END.
    ELSE DO:
        IF CAN-FIND(FIRST natur-oper
                                WHERE natur-oper.nat-operacao = INPUT FRAME f-pg-sel cnatureza 
                                  AND natur-oper.tipo-compra = 2) 
        AND (modelo:SCREEN-VALUE IN FRAME f-pg-sel = "57" 
        OR   modelo:SCREEN-VALUE IN FRAME f-pg-sel = "63" 
        OR   modelo:SCREEN-VALUE IN FRAME f-pg-sel = "67") THEN DO:
                {utp/ut-liter.i "Destino" *}
                RUN utp/ut-msgs.p (INPUT "show",
                                                   INPUT 55636, 
                                                   INPUT TRIM(RETURN-VALUE)).
            APPLY 'MOUSE-SELECT-CLICK' TO im-pg-par IN FRAME f-relat.
                APPLY 'entry' TO cod-ibge-dest IN FRAME f-pg-par.
                RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMontaChaveNFE w-relat 
PROCEDURE piMontaChaveNFE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
      DEFINE VARIABLE h-boin090         AS HANDLE      NO-UNDO.
            
      ASSIGN l-emitente-nfe                                   = NO
             codigoUF:SCREEN-VALUE          IN FRAME f-pg-sel = ""
             cnpjEmitente:SCREEN-VALUE      IN FRAME f-pg-sel = ""
             anoMesEmissao:SCREEN-VALUE     IN FRAME f-pg-sel = ""
             modelo:SCREEN-VALUE            IN FRAME f-pg-sel = ""
             serie:SCREEN-VALUE             IN FRAME f-pg-sel = ""
             numeroNFE:SCREEN-VALUE         IN FRAME f-pg-sel = ""
             codigoNumerico:SENSITIVE       IN FRAME f-pg-sel = NO
             digitoVerific:SENSITIVE        IN FRAME f-pg-sel = NO.

      IF  INPUT FRAME f-pg-sel codigoNumerico = 0 THEN
          DISP "" @ codigoNumerico 
               "" @ digitoVerific  WITH FRAME f-pg-sel.
               
      RUN inbo/boin090.p PERSISTENT SET h-boin090.
      
      RUN VerificaPadraoNacional IN h-boin090 (INPUT INPUT FRAME f-pg-sel cnatureza,
                                               OUTPUT log-nfse-nacional).  
                                               
      IF log-nfse-nacional THEN DO:
         RUN displayChaveAcessoPadraoNac (INPUT h-boin090).
         RUN reorganizarChaveAcesso      (INPUT YES).
      END.
      ELSE DO:
          RUN reorganizarChaveAcesso (INPUT NO).
          IF  NOT AVAIL emitente OR emitente.cod-emitente <> INPUT FRAME f-pg-sel ccod-emitente-desp THEN
              FOR FIRST emitente FIELDS(cod-emitente estado pais cgc char-1  &if "{&bf_mat_versao_ems}" >= "2.07" &then log-possui-nf-eletro &ENDIF) NO-LOCK
                  WHERE emitente.cod-emitente = INPUT FRAME f-pg-sel ccod-emitente-desp:
              END.

          IF  AVAIL emitente THEN DO:
              ASSIGN l-emitente-nfe =  &if "{&bf_mat_versao_ems}" >= "2.07" &then log-possui-nf-eletro &ELSE substr(emitente.char-1,99,1) = "1" &ENDIF .

              IF  l-emitente-nfe THEN DO:
                  ASSIGN cnpjEmitente:SCREEN-VALUE IN FRAME f-pg-sel = FILL("0",(14 - LENGTH(emitente.cgc))) + string(emitente.cgc).

                  FOR FIRST unid-feder FIELDS( char-1 &IF "{&bf_mat_versao_ems}" >= "2.07" &THEN cod-uf-ibge &ENDIF )
                      WHERE unid-feder.pais   = emitente.pais
                      AND   unid-feder.estado = emitente.estado NO-LOCK:

                      &IF "{&bf_mat_versao_ems}" >= "2.07" &THEN
                           ASSIGN codigoUF:SCREEN-VALUE IN FRAME f-pg-sel = FILL("0",(2 - LENGTH(unid-feder.cod-uf-ibge))) + STRING(unid-feder.cod-uf-ibge).
                      &ELSE
                           ASSIGN codigoUF:SCREEN-VALUE IN FRAME f-pg-sel = FILL("0",(2 - LENGTH(SUBSTR(unid-feder.char-1,1,2)))) + SUBSTR(unid-feder.char-1,1,2).
                      &ENDIF

                  END.
              END.
          END.

          IF  NOT l-emitente-nfe THEN
              RETURN "OK":U.

          ASSIGN codigoNumerico:SENSITIVE       IN FRAME f-pg-sel = YES
                 digitoVerific:SENSITIVE        IN FRAME f-pg-sel = YES.

          ASSIGN anoMesEmissao:SCREEN-VALUE IN FRAME f-pg-sel = SUBSTR(STRING(YEAR (INPUT FRAME f-pg-sel ddata-emissao),"9999"),3,2) +
                                                                STRING(MONTH(INPUT FRAME f-pg-sel ddata-emissao),"99") .

          IF  LENGTH(INPUT FRAME f-pg-sel cnr-docto) > 9 THEN
              ASSIGN numeroNFE:SCREEN-VALUE IN FRAME f-pg-sel = SUBSTR(INPUT FRAME f-pg-sel cnr-docto,1,9).
          ELSE
              ASSIGN numeroNFE:SCREEN-VALUE IN FRAME f-pg-sel = FILL("0",(9 - LENGTH(INPUT FRAME f-pg-sel cnr-docto))) + INPUT FRAME f-pg-sel cnr-docto.

          ASSIGN serie:SCREEN-VALUE IN FRAME f-pg-sel = FILL("0",(3 - LENGTH(INPUT FRAME f-pg-sel cserie))) + INPUT FRAME f-pg-sel cserie.

          ASSIGN modelo:SCREEN-VALUE IN FRAME f-pg-sel = "00".
          FOR FIRST natur-oper FIELDS(imp-nota tipo nat-operacao char-2 &IF "{&bf_mat_versao_ems}" >= "2.07" &THEN cod-model-nf-eletro &ENDIF ) NO-LOCK
              WHERE natur-oper.nat-operacao = INPUT FRAME f-pg-sel cnatureza:
              &IF "{&bf_mat_versao_ems}" >= "2.07" &THEN
                  ASSIGN modelo:SCREEN-VALUE IN FRAME f-pg-sel = FILL("0",(2 - LENGTH(natur-oper.cod-model-nf-eletro))) + STRING(natur-oper.cod-model-nf-eletro).
              &ELSE
                  ASSIGN modelo:SCREEN-VALUE IN FRAME f-pg-sel = FILL("0",(2 - LENGTH(SUBSTR(natur-oper.char-2,120,2)))) + SUBSTR(natur-oper.char-2,120,2).
              &ENDIF
          END.
      END.
      
      IF VALID-HANDLE(h-boin090) THEN DO:
        DELETE PROCEDURE h-boin090.
        ASSIGN h-boin090 = ?.
      END.

      RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaDefaultImpostos w-relat 
PROCEDURE piSetaDefaultImpostos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    ASSIGN INPUT FRAME f-pg-sel c-cod-observacao.
    IF c-cod-observacao = "servico":U THEN DO:
        ASSIGN de-aliq-ipi:screen-value in frame f-pg-cla          = "0":U
               de-aliq-icms:screen-value in frame f-pg-cla         = "0":U
               c-tributacao-ipi:screen-value in frame f-pg-cla     = {ininc/i10in172.i 04 2}
               c-tributacao-icms:screen-value in frame f-pg-cla    = {ininc/i01in245.i 04 2}
               de-aliq-pis:screen-value in frame f-pg-cla          = "0":U
               de-aliq-cofins:screen-value in frame f-pg-cla       = "0":U
               c-tributacao-pis:screen-value in frame f-pg-cla     = {ininc/i04in176.i 04 2}
               c-tributacao-cofins:screen-value in frame f-pg-cla  = {ininc/i04in176.i 04 2}.
        
        IF l-nt2024002 THEN
            ASSIGN de-aliq-ibsuf:screen-value in frame f-pg-cla      = "0":U
                   de-aliq-ibsmun:screen-value in frame f-pg-cla     = "0":U
                   de-aliq-cbs:screen-value in frame f-pg-cla        = "0":U
                   de-aliq-is:screen-value in frame f-pg-cla         = "0":U
                   de-perc-red-ibsuf:screen-value in frame f-pg-cla  = "0":U
                   de-perc-red-ibsmun:screen-value in frame f-pg-cla = "0":U
                   de-perc-red-cbs:screen-value in frame f-pg-cla    = "0":U.
    END.
    ELSE DO:
        ASSIGN INPUT FRAME f-pg-sel cnatureza.
        FOR FIRST natur-oper FIELDS(cd-trib-ipi cd-trib-icm aliquota-icm char-1 perc-pis[2] per-fin-soc[2] cod-cfop) NO-LOCK
            WHERE natur-oper.nat-operacao = cnatureza:
    
            ASSIGN c-tributacao-ipi:screen-value in frame f-pg-cla = {ininc/i10in172.i 04 natur-oper.cd-trib-ipi} NO-ERROR.
            
            /* ICMS */
            IF natur-oper.cd-trib-icm > c-tributacao-icms:NUM-ITEMS IN FRAME f-pg-cla THEN
                ASSIGN c-tributacao-icms:screen-value in frame f-pg-cla   = {ininc/i01in245.i 04 1}
                       de-aliq-icms:screen-value in frame f-pg-cla        = "0":U.
            ELSE
                ASSIGN c-tributacao-icms:screen-value in frame f-pg-cla   = {ininc/i01in245.i 04 natur-oper.cd-trib-icm}
                       de-aliq-icms:screen-value in frame f-pg-cla        = STRING(natur-oper.aliquota-icm).
            
            /* PIS */
            IF INTEGER(SUBSTRING(natur-oper.char-1,86,1)) > c-tributacao-pis:NUM-ITEMS in frame f-pg-cla THEN
                ASSIGN c-tributacao-pis:screen-value in frame f-pg-cla    = {ininc/i04in176.i 04 1}
                       de-aliq-pis:screen-value in frame f-pg-cla         = "0":U.
            ELSE
                ASSIGN c-tributacao-pis:screen-value in frame f-pg-cla    = {ininc/i04in176.i 04 INTEGER(SUBSTRING(natur-oper.char-1,86,1))}
                       de-aliq-pis:screen-value in frame f-pg-cla         = IF SUBSTR(natur-oper.char-1,183,9) <> "":U THEN SUBSTR(natur-oper.char-1,183,9) 
                                                                            ELSE STRING(natur-oper.perc-pis[2]).

            /* COFINS */
            IF INTEGER(SUBSTRING(natur-oper.char-1,87,1)) > c-tributacao-cofins:NUM-ITEMS in frame f-pg-cla THEN
                ASSIGN c-tributacao-cofins:screen-value in frame f-pg-cla = {ininc/i04in176.i 04 1}
                       de-aliq-cofins:screen-value in frame f-pg-cla      = "0":U.
            ELSE
                ASSIGN c-tributacao-cofins:screen-value in frame f-pg-cla = {ininc/i04in176.i 04 INTEGER(SUBSTRING(natur-oper.char-1,87,1))}
                       de-aliq-cofins:screen-value in frame f-pg-cla      = IF SUBSTR(natur-oper.char-1,192,9) <> "":U THEN SUBSTR(natur-oper.char-1,192,9) 
                                                                            ELSE STRING(natur-oper.per-fin-soc[2]).

            IF l-nt2024002 
            AND c-old-natureza <> cnatureza THEN DO:
                FOR FIRST emitente NO-LOCK
                    WHERE emitente.cod-emitente = INPUT FRAME f-pg-sel ccod-emitente-desp:
                END.
                FOR FIRST estabelec NO-LOCK
                    WHERE estabelec.cod-estabel = INPUT FRAME f-pg-sel ccod-estabel:
                END.
                IF NOT VALID-HANDLE(h-cdapi1005) THEN
                    RUN cdp/cdapi1005.p PERSISTENT SET h-cdapi1005.    

                RUN emptyTtRelactoTributo IN h-cdapi1005. 
                RUN setDados              IN h-cdapi1005 (INPUT 1, /*Entrada*/
                                                          INPUT TODAY,
                                                          INPUT ccod-estabel:SCREEN-VALUE  IN FRAME f-pg-sel,
                                                          INPUT cnatureza,
                                                          INPUT '*',
                                                          INPUT '*',
                                                          INPUT IF AVAIL emitente THEN emitente.cod-gr-forn ELSE ?,
                                                          INPUT ccod-emitente-desp:SCREEN-VALUE IN FRAME f-pg-sel,
                                                          INPUT natur-oper.cod-cfop,
                                                          INPUT ?,
                                                          INPUT IF AVAIL estabelec THEN estabelec.cidade ELSE '*',   /*cidade*/
                                                          INPUT IF AVAIL estabelec THEN estabelec.estado ELSE '*').  /*UF*/
                RUN gerattcombinacao IN h-cdapi1005.
                
                ASSIGN dAliq           = 0
                       dPercDifer      = 0
                       dPercRed        = 0
                       dPercCredPresum = 0
                       dAliqDeson      = 0
                       dPercRedAliqGov = 0.

                RUN emptyTtRelactoTributo IN h-cdapi1005. 
                RUN setIndTributo         IN h-cdapi1005 (INPUT 1). /*1-CBS, 2-IBS UF e 3-IBS MUN*/
                RUN buscarRelactotributo  IN h-cdapi1005.           
                RUN getTributo            IN h-cdapi1005 (OUTPUT dAliq,
                                                          OUTPUT dPercDifer,
                                                          OUTPUT dPercRed,
                                                          OUTPUT dPercCredPresum,
                                                          OUTPUT dAliqDeson,
                                                          OUTPUT dPercRedAliqGov).  
                                                          
                ASSIGN de-aliq-cbs:SCREEN-VALUE IN FRAME f-pg-cla     = STRING(dAliq)
                       de-perc-red-cbs:SCREEN-VALUE IN FRAME f-pg-cla = STRING(dPercRed).
                                                
                ASSIGN dAliq           = 0
                       dPercDifer      = 0
                       dPercRed        = 0
                       dPercCredPresum = 0
                       dAliqDeson      = 0
                       dPercRedAliqGov = 0.
         
                RUN emptyTtRelactoTributo IN h-cdapi1005. 
                RUN setIndTributo         IN h-cdapi1005 (INPUT 2). /*IBS UF*/ 
                RUN buscarRelactotributo  IN h-cdapi1005.           
                RUN getTributo            IN h-cdapi1005 (OUTPUT dAliq,
                                                          OUTPUT dPercDifer,
                                                          OUTPUT dPercRed,
                                                          OUTPUT dPercCredPresum,
                                                          OUTPUT dAliqDeson, 
                                                          OUTPUT dPercRedAliqGov).

                ASSIGN de-aliq-ibsuf:SCREEN-VALUE IN FRAME f-pg-cla     = STRING(dAliq)
                       de-perc-red-ibsuf:SCREEN-VALUE IN FRAME f-pg-cla = STRING(dPercRed).
                                                
                ASSIGN dAliq           = 0
                       dPercDifer      = 0
                       dPercRed        = 0
                       dPercCredPresum = 0
                       dAliqDeson      = 0
                       dPercRedAliqGov = 0.
                           
                RUN emptyTtRelactoTributo IN h-cdapi1005.             
                RUN setIndTributo         IN h-cdapi1005 (INPUT 3). /*IBS MUN*/ 
                RUN buscarRelactotributo  IN h-cdapi1005.           
                RUN getTributo            IN h-cdapi1005 (OUTPUT dAliq,
                                                          OUTPUT dPercDifer,
                                                          OUTPUT dPercRed,
                                                          OUTPUT dPercCredPresum,
                                                          OUTPUT dAliqDeson,
                                                          OUTPUT dPercRedAliqGov).

                ASSIGN de-aliq-ibsmun:SCREEN-VALUE IN FRAME f-pg-cla     = STRING(dAliq)
                       de-perc-red-ibsmun:SCREEN-VALUE IN FRAME f-pg-cla = STRING(dPercRed).
                
                // IS
                RUN emptyTtRelactoTributo IN h-cdapi1005.
                RUN setIndTributo         IN h-cdapi1005 (INPUT 4). /* IS */
                RUN buscarRelactotributo  IN h-cdapi1005.
                
                EMPTY TEMP-TABLE tt-relacto-tributo.
                
                /*retorna a temp-table com o dados que foram filtrados*/
                RUN getTtRelactoTributo   IN h-cdapi1005 (OUTPUT TABLE tt-relacto-tributo).  
                 
                FOR FIRST tt-relacto-tributo: 
                    ASSIGN de-aliq-is:SCREEN-VALUE IN FRAME f-pg-cla = STRING(tt-relacto-tributo.aliquota).
                END.
            
                IF VALID-HANDLE(h-cdapi1005) THEN DO:
                    DELETE PROCEDURE h-cdapi1005.
                    ASSIGN h-cdapi1005 = ?.
                END.   
            END.
            
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaDigito w-relat 
PROCEDURE piValidaDigito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR l-valida-diverg AS LOG      INITIAL NO   NO-UNDO.
    DEF VAR h-boin090       AS HANDLE                NO-UNDO.

    ASSIGN c-chave-nfe = codigoUF + anoMesEmissao + CnpjEmitente + modelo + 
                         serie    + numeroNFE     + STRING(codigoNumerico,"999999999").
    ASSIGN c-chave-nfe = c-chave-nfe + string(digitoVerific).
    
    IF NOT VALID-HANDLE(h-boin090) THEN
        RUN inbo/boin090.p PERSISTENT SET h-boin090.
        
    RUN validaDigito IN h-boin090 (INPUT  c-chave-nfe,
                                   OUTPUT l-valida-diverg).

    IF VALID-HANDLE(h-boin090) THEN DO:
        DELETE PROCEDURE h-boin090.
        ASSIGN h-boin090 = ?.
    END.
    
    IF l-valida-diverg THEN DO:
       RUN utp/ut-msgs.p (INPUT 'show':U, INPUT 932, INPUT '').
       IF RETURN-VALUE <> "YES":U THEN
         RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rateioDespCompDI w-relat 
PROCEDURE rateioDespCompDI :
/* -----------------------------------------------------------
  Purpose:     Rateia as despesas da nota complementar caso 
               nÆo tenham sido rateadas na DI (IM0400)
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE VARIABLE h-bocx383a AS HANDLE NO-UNDO.
    DEFINE VARIABLE l-rateio-realizado AS LOGICAL NO-UNDO.

    EMPTY TEMP-TABLE tt-desp-rateio-item.

    RUN cxbo/bocx383a.p PERSISTENT SET h-bocx383a.
    FOR EACH tt-param-im0101 
       WHERE tt-param-im0101.num-di-ems <> 0:
        RUN pi-ver-rateio-desp-comp IN h-bocx383a(INPUT tt-param-im0101.num-di-ems,
                                                  INPUT d-cdd-siscomex-dts,   //***avaliar na gera‡Æo da NF se esta passando pelo LEAVE OF c-declaracao-imp IN FRAME f-pg-sel
                                                  OUTPUT l-rateio-realizado).
        IF NOT l-rateio-realizado THEN DO:
            DO TRANS:
                RUN emptyRowErrors IN h-bocx383a.
                RUN pi-rateio-di   IN h-bocx383a(INPUT tt-param-im0101.num-di-ems,
                                                 INPUT d-cdd-siscomex-dts,   //***avaliar na gera‡Æo da NF se esta passando pelo LEAVE OF c-declaracao-imp IN FRAME f-pg-sel
                                                 INPUT 2). /*Rateia Despesas Complementares*/
                RUN getRowErrors   IN h-bocx383a(OUTPUT TABLE RowErrors).
                IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
                   /*--- Inicializa janela de mensagens de erro ---*/
                   {method/showmessage.i1}
                   {method/showmessage.i2}                   
            
                   IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorType     <> "INTERNAL":U
                                               AND   RowErrors.ErrorSubType  = "ERROR":U) THEN DO:
                      UNDO,LEAVE.
                   END.
                END.
                ELSE DO:
                    RUN getTTdesp-rateio-item IN h-bocx383a (OUTPUT TABLE tt-desp-rateio-item).
                    UNDO,LEAVE.
                END.
            END.
            RUN pi-atual-val-rat-compl-embarque  IN h-bocx383a (INPUT tt-param-im0101.num-di-ems,
                                                                INPUT d-cdd-siscomex-dts,   //***avaliar na gera‡Æo da NF se esta passando pelo LEAVE OF c-declaracao-imp IN FRAME f-pg-sel
                                                                INPUT TABLE tt-desp-rateio-item).
        END.
    END.

    if  valid-handle (h-bocx383a) then do:
        delete procedure h-bocx383a.
        assign h-bocx383a = ?.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reorganizarChaveAcesso w-relat 
PROCEDURE reorganizarChaveAcesso :

    DEFINE INPUT  PARAMETER p-log-nfse-nacional AS LOGICAL     NO-UNDO.
    
    ASSIGN codigoUF       :HIDDEN IN FRAME f-pg-sel = p-log-nfse-nacional
           anoMesEmissao  :HIDDEN IN FRAME f-pg-sel = p-log-nfse-nacional
           cnpjEmitente   :HIDDEN IN FRAME f-pg-sel = p-log-nfse-nacional
           modelo         :HIDDEN IN FRAME f-pg-sel = p-log-nfse-nacional
           serie          :HIDDEN IN FRAME f-pg-sel = p-log-nfse-nacional
           numeroNFE      :HIDDEN IN FRAME f-pg-sel = p-log-nfse-nacional
           codigoNumerico :HIDDEN IN FRAME f-pg-sel = p-log-nfse-nacional
           digitoVerific  :HIDDEN IN FRAME f-pg-sel = p-log-nfse-nacional .             

    ASSIGN i-chaveNFSe-muni     :HIDDEN IN FRAME f-pg-sel = NOT p-log-nfse-nacional
           c-chaveNFSe-amb-ger  :HIDDEN IN FRAME f-pg-sel = NOT p-log-nfse-nacional
           c-chaveNFSe-tp-if    :HIDDEN IN FRAME f-pg-sel = NOT p-log-nfse-nacional
           c-chaveNFSe-cgc      :HIDDEN IN FRAME f-pg-sel = NOT p-log-nfse-nacional
           d-chaveNFSe-nro-docto:HIDDEN IN FRAME f-pg-sel = NOT p-log-nfse-nacional
           c-chaveNFSe-data     :HIDDEN IN FRAME f-pg-sel = NOT p-log-nfse-nacional
           i-chaveNFSe-nr-nfe   :HIDDEN IN FRAME f-pg-sel = NOT p-log-nfse-nacional
           i-chaveNFSe-digito   :HIDDEN IN FRAME f-pg-sel = NOT p-log-nfse-nacional .
           
    IF p-log-nfse-nacional THEN        
        i-chaveNFSe-muni:MOVE-TO-TOP().  
    ELSE
        codigoUF:MOVE-TO-TOP(). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-relat  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this Window, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaFornecedor w-relat 
PROCEDURE setaFornecedor :
/* -----------------------------------------------------------
  Purpose:     
    Notes:       
-------------------------------------------------------------*/
    RUN cxbo/bocx403.p PERSISTENT SET h-bocx403. 
    RUN retornaFornPrimeiraAdic IN h-bocx403(INPUT c-declaracao-imp, OUTPUT i-fornec).

    ASSIGN ccod-emitente-desp:SCREEN-VALUE IN FRAME f-pg-sel = STRING(i-fornec)
           INPUT FRAME f-pg-sel ccod-emitente-desp.

    if  valid-handle (h-bocx403) then do:
        delete procedure h-bocx403.
        assign h-bocx403 = ?.
    end.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-relat 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
    DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

    run pi-trata-state (p-issuer-hdl, p-state).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

