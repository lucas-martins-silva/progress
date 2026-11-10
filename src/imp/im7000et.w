&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decla-import NO-UNDO LIKE decla-import
       field r-Rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM7000ET 2.00.00.003 } /*** "010003" 11/08/2026 08:51:58 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM7000ET MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM7000ET
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   CBS, IBS UF, IBS Mun, IS

&GLOBAL-DEFINE First          NO
&GLOBAL-DEFINE Prev           NO
&GLOBAL-DEFINE Next           NO
&GLOBAL-DEFINE Last           NO
&GLOBAL-DEFINE GoTo           NO
&GLOBAL-DEFINE Search         NO

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         NO
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         NO
&GLOBAL-DEFINE Save           NO

&GLOBAL-DEFINE ttTable        tt-decla-import 
&GLOBAL-DEFINE hDBOTable      h-BOCX383
&GLOBAL-DEFINE DBOTable       decla-import

&GLOBAL-DEFINE page0KeyFields i-num-duimp-dts c-cod-estabel da-data-duimp c-cod-duimp-siscomex i-num-versao
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields cb-idi-tributac-cbs de-val-aliq-cbs de-perc-reduc-cbs de-base-cbs de-valor-impostos-cbs c-cst-cbs c-class-trib-cbs
&GLOBAL-DEFINE page2Fields cb-idi-tributac-ibsuf de-val-aliq-ibsuf de-perc-reduc-ibsuf de-base-ibsuf de-valor-impostos-ibsuf c-cst-ibsuf c-class-trib-ibsuf
&GLOBAL-DEFINE page3Fields cb-idi-tributac-ibsmun de-val-aliq-ibsmun de-perc-reduc-ibsmun de-base-ibsmun de-valor-impostos-ibsmun c-cst-ibsmun c-class-trib-ibsmun
&GLOBAL-DEFINE page4Fields cb-idi-tributac-is


/* Parameters Definitions ---                                           */
DEFINE NEW GLOBAL SHARED VAR gr-duimp-siscomex AS ROWID NO-UNDO.

DEFINE INPUT PARAMETER pcod-estab  AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pcod-duimp  AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pcod-comex  AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pnum-adic   AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pnum-ordem  AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pcod-embarq AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pcod-item   AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pdesc-item  AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pttnum-de-ems AS INT NO-UNDO.
DEFINE INPUT PARAMETER pttnum-adic   AS INT NO-UNDO.
DEFINE INPUT PARAMETER pttcdd-scmx-dts AS DEC NO-UNDO.
DEFINE INPUT PARAMETER pttnum-ordem AS INT NO-UNDO.
DEFINE INPUT PARAMETER pttnum-parcela AS INT NO-UNDO.
DEFINE INPUT PARAMETER pttnum-seq     AS IN NO-UNDO.

/* Local Variable Definitions ---                                       */
define variable c-unid-med  as character no-undo.
define variable c-desc-item as character format 'x(40)' no-undo.
define variable i-cont      as integer no-undo.
DEFINE VARIABLE c-return    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nome-abrev  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-serie-docto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nro-docto   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nat-oper    AS CHARACTER   NO-UNDO.
define variable c-class-fiscal like item.class-fiscal no-undo.
define variable c-nr-proc-imp  like processo-imp.nr-proc-imp no-undo.
DEFINE VARIABLE i-trib-ibsuf  AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE i-trib-ibsmun AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE i-trib-cbs    AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE i-trib-is     AS INTEGER INITIAL 1 NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
define variable {&hDBOTable}  as handle  no-undo.
DEFINE VARIABLE h-bocx383a    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx00487   AS HANDLE NO-UNDO.

define variable iRowsReturned as integer no-undo.
define variable i-conta-reg   as integer no-undo.
DEFINE VARIABLE l-encontrou   AS LOGICAL NO-UNDO.


DEFINE VARIABLE l-nt2024002         AS LOGICAL     NO-UNDO.

/* Programa de pesquisa */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.


/* Reforma Tribut ria */
ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-nt2024002":U AND funcao.ativo).
                              
{cxbo/bocx00487.i tt-duimp-siscomex}  

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys rtToolBar-2 btFirst btPrev ~
btNext btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp ~
c-cod-estabel i-num-duimp-dts c-cod-duimp-siscomex i-seq c-num-ordem ~
c-embarque c-cod-item c-des-item da-data-duimp i-num-versao btOk btCancelar ~
btAjuda 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estabel i-num-duimp-dts ~
c-cod-duimp-siscomex i-seq c-num-ordem c-embarque c-cod-item c-des-item ~
da-data-duimp i-num-versao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btAjuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btCancelar 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image/im-fir":U
     IMAGE-INSENSITIVE FILE "image/ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image/im-enter":U
     IMAGE-INSENSITIVE FILE "image/ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image/im-las":U
     IMAGE-INSENSITIVE FILE "image/ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image/im-nex":U
     IMAGE-INSENSITIVE FILE "image/ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btOk 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image/im-pre":U
     IMAGE-INSENSITIVE FILE "image/ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image/im-joi":U
     IMAGE-INSENSITIVE FILE "image/ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image/im-pri":U
     IMAGE-INSENSITIVE FILE "image/ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE c-cod-duimp-siscomex AS CHARACTER FORMAT "x(15)" 
     LABEL "DUIMP Siscomex" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "x(5)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE c-cod-item AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE c-embarque AS CHARACTER FORMAT "X(256)":U 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-num-ordem AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ordem" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-duimp AS DATE FORMAT "99/99/9999" 
     LABEL "Data DUIMP" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .38.

DEFINE VARIABLE i-num-duimp-dts AS DECIMAL FORMAT ">>>>>>>>>>>>>>>9" INITIAL 0 
     LABEL "N£mero Interno DUIMP" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE i-num-versao AS INTEGER FORMAT "9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .5.

DEFINE VARIABLE i-seq AS CHARACTER FORMAT "X(256)":U 
     LABEL "Seq" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE cb-idi-tributac-cbs AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tributa‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-class-trib-cbs AS CHARACTER FORMAT "X(256)":U 
     LABEL "Class Trib" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-class-trib-reg-cbs AS CHARACTER FORMAT "X(256)":U 
     LABEL "Class Trib" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-cbs AS CHARACTER FORMAT "X(256)":U 
     LABEL "CST" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-reg-cbs AS CHARACTER FORMAT "X(256)":U 
     LABEL "CST" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE de-base-cbs AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     LABEL "Base C lculo" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-base-reg-cbs AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     LABEL "Base C lculo" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-reduc-cbs AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Redu‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-aliq-cbs AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Al¡quota" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-aliq-reg-cbs AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Al¡quota" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-impostos-cbs AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     LABEL "Valor" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-impostos-reg-cbs AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     LABEL "Valor" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 11.75.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 11.75.

DEFINE VARIABLE cb-idi-tributac-ibsuf AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tributa‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-class-trib-ibsuf AS CHARACTER FORMAT "X(256)":U 
     LABEL "Class Trib" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-class-trib-reg-ibsuf AS CHARACTER FORMAT "X(256)":U 
     LABEL "Class Trib" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-ibsuf AS CHARACTER FORMAT "X(256)":U 
     LABEL "CST" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-reg-ibsuf AS CHARACTER FORMAT "X(256)":U 
     LABEL "CST" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE de-base-ibsuf AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     LABEL "Base C lculo" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-base-reg-ibsuf AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     LABEL "Base C lculo" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-reduc-ibsuf AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Redu‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-aliq-ibsuf AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Al¡quota" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-aliq-reg-ibsuf AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Al¡quota" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-impostos-ibsuf AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     LABEL "Valor" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-impostos-reg-ibsuf AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     LABEL "Valor" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 11.75.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 11.75.

DEFINE VARIABLE cb-idi-tributac-ibsmun AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tributa‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-class-trib-ibsmun AS CHARACTER FORMAT "X(256)":U 
     LABEL "Class Trib" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-class-trib-reg-ibsmun AS CHARACTER FORMAT "X(256)":U 
     LABEL "Class Trib" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-ibsmun AS CHARACTER FORMAT "X(256)":U 
     LABEL "CST" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-reg-ibsmun AS CHARACTER FORMAT "X(256)":U 
     LABEL "CST" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE de-base-ibsmun AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     LABEL "Base C lculo" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-base-reg-ibsmun AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     LABEL "Base C lculo" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-reduc-ibsmun AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Redu‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-aliq-ibsmun AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Al¡quota" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-aliq-reg-ibsmun AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Al¡quota" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-impostos-ibsmun AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     LABEL "Valor" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-impostos-reg-ibsmun AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     LABEL "Valor" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 11.75.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 11.75.

DEFINE VARIABLE cb-idi-tributac-is AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tributa‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-class-trib-is AS CHARACTER FORMAT "X(256)":U 
     LABEL "Class Trib" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-is AS CHARACTER FORMAT "X(256)":U 
     LABEL "CST" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-trib-is AS CHARACTER FORMAT "X(256)":U 
     LABEL "Un Tribut vel" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE de-aliq-espec-is AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     LABEL "Aliq Espec Un" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE de-base-is AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     LABEL "Base C lculo" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-qtde-trib-is AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     LABEL "Qtde Tribut vel" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-aliq-is AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Al¡quota" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-impostos-is AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     LABEL "Valor" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 31 BY 11.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrˆncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrˆncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrˆncia"
     btLast AT ROW 1.13 COL 13.57 HELP
          "éltima ocorrˆncia"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V  Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     c-cod-estabel AT ROW 3 COL 13 COLON-ALIGNED WIDGET-ID 6
     i-num-duimp-dts AT ROW 3 COL 41 COLON-ALIGNED HELP
          "N£mero Interno DUIMP" WIDGET-ID 10
     c-cod-duimp-siscomex AT ROW 3 COL 71 COLON-ALIGNED HELP
          "C¢digo DI Siscomex" WIDGET-ID 4
     i-seq AT ROW 4 COL 13 COLON-ALIGNED WIDGET-ID 22
     c-num-ordem AT ROW 4 COL 41 COLON-ALIGNED WIDGET-ID 28
     c-embarque AT ROW 4 COL 71 COLON-ALIGNED WIDGET-ID 30
     c-cod-item AT ROW 5 COL 13 COLON-ALIGNED WIDGET-ID 24
     c-des-item AT ROW 5 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     da-data-duimp AT ROW 5 COL 82 COLON-ALIGNED HELP
          "Data da DI" WIDGET-ID 8
     i-num-versao AT ROW 5.25 COL 65 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     btOk AT ROW 21 COL 2 WIDGET-ID 16
     btCancelar AT ROW 21 COL 13 WIDGET-ID 18
     btAjuda AT ROW 21 COL 79 WIDGET-ID 20
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.75 COL 2
     rtToolBar-2 AT ROW 20.75 COL 1 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.86 BY 21.29
         FONT 1.


DEFINE FRAME fpage4
     cb-idi-tributac-is AT ROW 2 COL 12 COLON-ALIGNED WIDGET-ID 2
     de-val-aliq-is AT ROW 3 COL 12 COLON-ALIGNED WIDGET-ID 6
     de-aliq-espec-is AT ROW 4 COL 12 COLON-ALIGNED WIDGET-ID 8
     de-qtde-trib-is AT ROW 5 COL 12 COLON-ALIGNED WIDGET-ID 34
     c-un-trib-is AT ROW 6 COL 12 COLON-ALIGNED WIDGET-ID 36
     de-base-is AT ROW 7 COL 12 COLON-ALIGNED WIDGET-ID 10
     de-valor-impostos-is AT ROW 8 COL 12 COLON-ALIGNED WIDGET-ID 12
     c-class-trib-is AT ROW 9 COL 12 COLON-ALIGNED WIDGET-ID 14
     c-cst-is AT ROW 10 COL 12 COLON-ALIGNED WIDGET-ID 16
     RECT-8 AT ROW 1.5 COL 2 WIDGET-ID 28
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.5
         SIZE 87.43 BY 13
         FONT 1 WIDGET-ID 400.

DEFINE FRAME fpage3
     cb-idi-tributac-ibsmun AT ROW 2 COL 11 COLON-ALIGNED WIDGET-ID 2
     de-val-aliq-reg-ibsmun AT ROW 2 COL 43 COLON-ALIGNED WIDGET-ID 18
     de-val-aliq-ibsmun AT ROW 3 COL 11 COLON-ALIGNED WIDGET-ID 6
     de-base-reg-ibsmun AT ROW 3 COL 43 COLON-ALIGNED WIDGET-ID 20
     de-perc-reduc-ibsmun AT ROW 4 COL 11 COLON-ALIGNED WIDGET-ID 8
     de-valor-impostos-reg-ibsmun AT ROW 4 COL 43 COLON-ALIGNED WIDGET-ID 22
     de-base-ibsmun AT ROW 5 COL 11 COLON-ALIGNED WIDGET-ID 10
     c-class-trib-reg-ibsmun AT ROW 5 COL 43 COLON-ALIGNED WIDGET-ID 24
     de-valor-impostos-ibsmun AT ROW 6 COL 11 COLON-ALIGNED WIDGET-ID 12
     c-cst-reg-ibsmun AT ROW 6 COL 43 COLON-ALIGNED WIDGET-ID 26
     c-class-trib-ibsmun AT ROW 7 COL 11 COLON-ALIGNED WIDGET-ID 14
     c-cst-ibsmun AT ROW 8 COL 11 COLON-ALIGNED WIDGET-ID 16
     "Tributa‡Æo Regular" VIEW-AS TEXT
          SIZE 14 BY .54 AT ROW 1.25 COL 35 WIDGET-ID 32
     RECT-6 AT ROW 1.5 COL 2 WIDGET-ID 28
     RECT-7 AT ROW 1.5 COL 34 WIDGET-ID 30
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.5
         SIZE 87.43 BY 13
         FONT 1 WIDGET-ID 300.

DEFINE FRAME fpage2
     cb-idi-tributac-ibsuf AT ROW 2 COL 11 COLON-ALIGNED WIDGET-ID 2
     de-val-aliq-reg-ibsuf AT ROW 2 COL 43 COLON-ALIGNED WIDGET-ID 18
     de-val-aliq-ibsuf AT ROW 3 COL 11 COLON-ALIGNED WIDGET-ID 6
     de-base-reg-ibsuf AT ROW 3 COL 43 COLON-ALIGNED WIDGET-ID 20
     de-perc-reduc-ibsuf AT ROW 4 COL 11 COLON-ALIGNED WIDGET-ID 8
     de-valor-impostos-reg-ibsuf AT ROW 4 COL 43 COLON-ALIGNED WIDGET-ID 22
     de-base-ibsuf AT ROW 5 COL 11 COLON-ALIGNED WIDGET-ID 10
     c-class-trib-reg-ibsuf AT ROW 5 COL 43 COLON-ALIGNED WIDGET-ID 24
     de-valor-impostos-ibsuf AT ROW 6 COL 11 COLON-ALIGNED WIDGET-ID 12
     c-cst-reg-ibsuf AT ROW 6 COL 43 COLON-ALIGNED WIDGET-ID 26
     c-class-trib-ibsuf AT ROW 7 COL 11 COLON-ALIGNED WIDGET-ID 14
     c-cst-ibsuf AT ROW 8 COL 11 COLON-ALIGNED WIDGET-ID 16
     "Tributa‡Æo Regular" VIEW-AS TEXT
          SIZE 14 BY .54 AT ROW 1.25 COL 35 WIDGET-ID 32
     RECT-4 AT ROW 1.5 COL 2 WIDGET-ID 28
     RECT-5 AT ROW 1.5 COL 34 WIDGET-ID 30
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.5
         SIZE 87.43 BY 13
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fpage1
     cb-idi-tributac-cbs AT ROW 2 COL 11 COLON-ALIGNED WIDGET-ID 2
     de-val-aliq-reg-cbs AT ROW 2 COL 43 COLON-ALIGNED WIDGET-ID 18
     de-val-aliq-cbs AT ROW 3 COL 11 COLON-ALIGNED WIDGET-ID 6
     de-base-reg-cbs AT ROW 3 COL 43 COLON-ALIGNED WIDGET-ID 20
     de-perc-reduc-cbs AT ROW 4 COL 11 COLON-ALIGNED WIDGET-ID 8
     de-valor-impostos-reg-cbs AT ROW 4 COL 43 COLON-ALIGNED WIDGET-ID 22
     de-base-cbs AT ROW 5 COL 11 COLON-ALIGNED WIDGET-ID 10
     c-class-trib-reg-cbs AT ROW 5 COL 43 COLON-ALIGNED WIDGET-ID 24
     de-valor-impostos-cbs AT ROW 6 COL 11 COLON-ALIGNED WIDGET-ID 12
     c-cst-reg-cbs AT ROW 6 COL 43 COLON-ALIGNED WIDGET-ID 26
     c-class-trib-cbs AT ROW 7 COL 11 COLON-ALIGNED WIDGET-ID 14
     c-cst-cbs AT ROW 8 COL 11 COLON-ALIGNED WIDGET-ID 16
     "Tributa‡Æo Regular" VIEW-AS TEXT
          SIZE 14 BY .54 AT ROW 1.25 COL 35 WIDGET-ID 32
     RECT-2 AT ROW 1.5 COL 2 WIDGET-ID 28
     RECT-3 AT ROW 1.5 COL 34 WIDGET-ID 30
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.5
         SIZE 87.43 BY 13
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-decla-import T "?" NO-UNDO mgcex decla-import
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 21.17
         WIDTH              = 91.86
         MAX-HEIGHT         = 21.33
         MAX-WIDTH          = 91.86
         VIRTUAL-HEIGHT     = 21.33
         VIRTUAL-WIDTH      = 91.86
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fpage1:FRAME = FRAME fpage0:HANDLE
       FRAME fpage2:FRAME = FRAME fpage0:HANDLE
       FRAME fpage3:FRAME = FRAME fpage0:HANDLE
       FRAME fpage4:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fpage1
                                                                        */
/* SETTINGS FOR FRAME fpage2
                                                                        */
/* SETTINGS FOR FRAME fpage3
                                                                        */
/* SETTINGS FOR FRAME fpage4
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage1
/* Query rebuild information for FRAME fpage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage2
/* Query rebuild information for FRAME fpage2
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage3
/* Query rebuild information for FRAME fpage3
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage4
/* Query rebuild information for FRAME fpage4
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancelar wMaintenance
ON CHOOSE OF btCancelar IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fpage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fpage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage1
&Scoped-define SELF-NAME c-class-trib-cbs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-cbs wMaintenance
ON F5 OF c-class-trib-cbs IN FRAME fpage1 /* Class Trib */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z01in01127.w"
                       &FieldZoom1="cod-cclass-trib"
                       &FieldScreen1="c-class-trib-cbs"
                       &Frame1="fpage1"
                       &EnableImplant="NO"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-cbs wMaintenance
ON LEAVE OF c-class-trib-cbs IN FRAME fpage1 /* Class Trib */
DO:
    ASSIGN c-cst-cbs:SCREEN-VALUE IN FRAME fpage1 = SUBSTRING(c-class-trib-cbs:SCREEN-VALUE IN FRAME fpage1,1,3).
    
    FIND FIRST class-trib NO-LOCK
         WHERE class-trib.cod-cclass-trib = c-class-trib-cbs:SCREEN-VALUE IN FRAME fpage1
           AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
    IF AVAIL class-trib
    AND class-trib.trib-regular = 1 THEN DO:
        IF INPUT FRAME fpage1 de-val-aliq-cbs <> 0 THEN
            ASSIGN de-val-aliq-reg-cbs:SCREEN-VALUE IN FRAME fpage1 = de-val-aliq-cbs:SCREEN-VALUE IN FRAME fpage1.
        
        ENABLE c-class-trib-reg-cbs c-cst-reg-cbs WITH FRAME fpage1.
    END.
    ELSE DO:
        ASSIGN de-val-aliq-reg-cbs:SCREEN-VALUE IN FRAME fpage1 = "0"
               c-class-trib-reg-cbs:SCREEN-VALUE IN FRAME fpage1 = ""
               c-cst-reg-cbs:SCREEN-VALUE IN FRAME fpage1 = "".
        DISABLE c-class-trib-reg-cbs c-cst-reg-cbs WITH FRAME fpage1.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-cbs wMaintenance
ON MOUSE-SELECT-DBLCLICK OF c-class-trib-cbs IN FRAME fpage1 /* Class Trib */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME c-class-trib-ibsmun
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibsmun wMaintenance
ON F5 OF c-class-trib-ibsmun IN FRAME fpage3 /* Class Trib */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z01in01127.w"
                       &FieldZoom1="cod-cclass-trib"
                       &FieldScreen1="c-class-trib-ibsmun"
                       &Frame1="fpage3"
                       &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibsmun wMaintenance
ON LEAVE OF c-class-trib-ibsmun IN FRAME fpage3 /* Class Trib */
DO:
    ASSIGN c-cst-ibsmun:SCREEN-VALUE IN FRAME fpage3 = SUBSTRING(c-class-trib-ibsmun:SCREEN-VALUE IN FRAME fpage3,1,3).
    
    FIND FIRST class-trib NO-LOCK
         WHERE class-trib.cod-cclass-trib = c-class-trib-ibsmun:SCREEN-VALUE IN FRAME fpage3
           AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
    IF AVAIL class-trib
    AND class-trib.trib-regular = 1 THEN DO:
        IF INPUT FRAME fpage3 de-val-aliq-ibsmun <> 0 THEN
            ASSIGN de-val-aliq-reg-ibsmun:SCREEN-VALUE IN FRAME fpage3 = de-val-aliq-ibsmun:SCREEN-VALUE IN FRAME fpage3.
        
        ENABLE c-class-trib-reg-ibsmun c-cst-reg-ibsmun WITH FRAME fpage3.
    END.
    ELSE DO:
        ASSIGN de-val-aliq-reg-ibsmun:SCREEN-VALUE IN FRAME fpage3 = "0"
               c-class-trib-reg-ibsmun:SCREEN-VALUE IN FRAME fpage3 = ""
               c-cst-reg-ibsmun:SCREEN-VALUE IN FRAME fpage3 = "".
        DISABLE c-class-trib-reg-ibsmun c-cst-reg-ibsmun WITH FRAME fpage3.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibsmun wMaintenance
ON MOUSE-SELECT-DBLCLICK OF c-class-trib-ibsmun IN FRAME fpage3 /* Class Trib */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage2
&Scoped-define SELF-NAME c-class-trib-ibsuf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibsuf wMaintenance
ON F5 OF c-class-trib-ibsuf IN FRAME fpage2 /* Class Trib */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z01in01127.w"
                       &FieldZoom1="cod-cclass-trib"
                       &FieldScreen1="c-class-trib-ibsuf"
                       &Frame1="fpage2"
                       &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibsuf wMaintenance
ON LEAVE OF c-class-trib-ibsuf IN FRAME fpage2 /* Class Trib */
DO:
    ASSIGN c-cst-ibsuf:SCREEN-VALUE IN FRAME fpage2 = SUBSTRING(c-class-trib-ibsuf:SCREEN-VALUE IN FRAME fpage2,1,3).
    
    FIND FIRST class-trib NO-LOCK
         WHERE class-trib.cod-cclass-trib = c-class-trib-ibsuf:SCREEN-VALUE IN FRAME fpage2
           AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
    IF AVAIL class-trib
    AND class-trib.trib-regular = 1 THEN DO:
        IF INPUT FRAME fpage2 de-val-aliq-ibsuf <> 0 THEN
            ASSIGN de-val-aliq-reg-ibsuf:SCREEN-VALUE IN FRAME fpage2 = de-val-aliq-ibsuf:SCREEN-VALUE IN FRAME fpage2.
        
        ENABLE c-class-trib-reg-ibsuf c-cst-reg-ibsuf WITH FRAME fpage2.
    END.
    ELSE DO:
        ASSIGN de-val-aliq-reg-ibsuf:SCREEN-VALUE IN FRAME fpage2 = "0"
               c-class-trib-reg-ibsuf:SCREEN-VALUE IN FRAME fpage2 = ""
               c-cst-reg-ibsuf:SCREEN-VALUE IN FRAME fpage2 = "".
        DISABLE c-class-trib-reg-ibsuf c-cst-reg-ibsuf WITH FRAME fpage2.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibsuf wMaintenance
ON MOUSE-SELECT-DBLCLICK OF c-class-trib-ibsuf IN FRAME fpage2 /* Class Trib */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage4
&Scoped-define SELF-NAME c-class-trib-is
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-is wMaintenance
ON F5 OF c-class-trib-is IN FRAME fpage4 /* Class Trib */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z01in01127.w"
                       &FieldZoom1="cod-cclass-trib"
                       &FieldScreen1="c-class-trib-is"
                       &Frame1="fpage4"
                       &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-is wMaintenance
ON LEAVE OF c-class-trib-is IN FRAME fpage4 /* Class Trib */
DO:
    ASSIGN c-cst-is:SCREEN-VALUE IN FRAME fpage4 = SUBSTRING(c-class-trib-is:SCREEN-VALUE IN FRAME fpage4,1,3).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-is wMaintenance
ON MOUSE-SELECT-DBLCLICK OF c-class-trib-is IN FRAME fpage4 /* Class Trib */
DO:
    APPLY "F5" TO SELF.
END.

&Scoped-define SELF-NAME btOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOk wMaintenance
ON CHOOSE OF btOk IN FRAME fPage0 /* Alterar */
DO:
    RUN pi-grava-impostos.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-un-trib-is
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-un-trib-is wMaintenance
ON F5 OF c-un-trib-is IN FRAME fpage4 /* Un Tribut vel */
DO:
  {include/zoomvar.i   &prog-zoom="inzoom\z01in417.w"
                       &campo=c-un-trib-is
                       &campozoom=un
                       &frame="fpage4"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-un-trib-is wMaintenance
ON MOUSE-SELECT-DBLCLICK OF c-un-trib-is IN FRAME fpage4 /* Un Tribut vel */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage1
&Scoped-define SELF-NAME de-val-aliq-cbs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-val-aliq-cbs wMaintenance
ON LEAVE OF de-val-aliq-cbs IN FRAME fpage1 /* Al¡quota */
DO:
    IF INPUT FRAME fpage1 de-val-aliq-cbs <> 0 THEN DO:
        FIND FIRST class-trib NO-LOCK
             WHERE class-trib.cod-cclass-trib = c-class-trib-cbs:SCREEN-VALUE IN FRAME fpage1
               AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
        IF AVAIL class-trib
        AND class-trib.trib-regular = 1 THEN DO:
            ASSIGN de-val-aliq-reg-cbs:SCREEN-VALUE IN FRAME fpage1 = de-val-aliq-cbs:SCREEN-VALUE IN FRAME fpage1.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME de-val-aliq-ibsmun
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-val-aliq-ibsmun wMaintenance
ON LEAVE OF de-val-aliq-ibsmun IN FRAME fpage3 /* Al¡quota */
DO:
    IF INPUT FRAME fpage3 de-val-aliq-ibsmun <> 0 THEN DO:
        FIND FIRST class-trib NO-LOCK
             WHERE class-trib.cod-cclass-trib = c-class-trib-ibsmun:SCREEN-VALUE IN FRAME fpage3
               AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
        IF AVAIL class-trib
        AND class-trib.trib-regular = 1 THEN DO:
            ASSIGN de-val-aliq-reg-ibsmun:SCREEN-VALUE IN FRAME fpage3 = de-val-aliq-ibsmun:SCREEN-VALUE IN FRAME fpage3.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage2
&Scoped-define SELF-NAME de-val-aliq-ibsuf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-val-aliq-ibsuf wMaintenance
ON LEAVE OF de-val-aliq-ibsuf IN FRAME fpage2 /* Al¡quota */
DO:
    IF INPUT FRAME fpage2 de-val-aliq-ibsuf <> 0 THEN DO:
        FIND FIRST class-trib NO-LOCK
             WHERE class-trib.cod-cclass-trib = c-class-trib-ibsuf:SCREEN-VALUE IN FRAME fpage2
               AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
        IF AVAIL class-trib
        AND class-trib.trib-regular = 1 THEN DO:
            ASSIGN de-val-aliq-reg-ibsuf:SCREEN-VALUE IN FRAME fpage2 = de-val-aliq-ibsuf:SCREEN-VALUE IN FRAME fpage2.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMaintenance
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
ASSIGN c-cod-duimp-siscomex:FORMAT IN FRAME fpage0 = "x(20)".

IF c-class-trib-ibsuf:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage2 THEN.
IF c-class-trib-ibsmun:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage3 THEN.
IF c-class-trib-cbs:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage1 THEN.
IF c-class-trib-is:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage4 THEN.
IF c-un-trib-is:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage4 THEN.

{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    if valid-handle(h-bocx383a) then delete procedure h-bocx383a. 
    IF VALID-HANDLE(h-bocx00487) THEN DELETE PROCEDURE h-bocx00487.
        
    ASSIGN  h-bocx383a  = ?
            h-bocx00487 = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    IF gr-duimp-siscomex <> ? THEN DO:
        RUN repositionRecord IN h-bocx00487 (INPUT gr-duimp-siscomex).        
        RUN getRecord        IN h-bocx00487 (OUTPUT TABLE tt-duimp-siscomex).        
    END.
    FOR FIRST tt-duimp-siscomex NO-LOCK: END.
    
    IF AVAIL tt-duimp-siscomex THEN DO:
       ASSIGN i-num-duimp-dts:SCREEN-VALUE      IN FRAME fPage0 = string(tt-duimp-siscomex.cod-duimp-dts)
              c-cod-duimp-siscomex:SCREEN-VALUE IN FRAME fPage0 = tt-duimp-siscomex.cod-duimp-siscomex
              i-num-versao:SCREEN-VALUE         IN FRAME fPage0 = string(tt-duimp-siscomex.num-versao)
              c-cod-estabel:SCREEN-VALUE        IN FRAME fPage0 = tt-duimp-siscomex.cod-estabel
              da-data-duimp:SCREEN-VALUE        IN FRAME fPage0 = string(DATE(tt-duimp-siscomex.dtz-reg-siscomex),"99/99/9999":U).
   
        RUN openQueryStatic IN h-bocx383 (INPUT "Main":U) NO-ERROR.
        RUN goToKey         IN h-bocx383 (INPUT tt-duimp-siscomex.cod-duimp-dts,
                                          INPUT 99, 
                                          INPUT tt-duimp-siscomex.cdd-siscomex-dts). 
                                
        IF RETURN-VALUE = "OK":U THEN
            RUN getRecord IN h-bocx383(OUTPUT TABLE tt-decla-import).
        
        FOR FIRST tt-decla-import NO-LOCK: END.
       
        
    END.
    ASSIGN c-cod-estabel:SCREEN-VALUE IN FRAME fPage0 =  pcod-estab
           i-num-duimp-dts:SCREEN-VALUE IN FRAME fPage0 =  pcod-duimp
           c-cod-duimp-siscomex:SCREEN-VALUE IN FRAME fPage0 =  pcod-comex
           i-seq:SCREEN-VALUE IN FRAME fPage0 =  pnum-adic
           c-num-ordem:SCREEN-VALUE IN FRAME fPage0 = pnum-ordem
           c-embarque:SCREEN-VALUE IN FRAME fPage0 =  pcod-embarq
           c-cod-item:SCREEN-VALUE IN FRAME fPage0 =  pcod-item
           c-des-item:SCREEN-VALUE IN FRAME fPage0 =  pdesc-item.
    RUN pi-busca-valor-impostos.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenance 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
   
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

   ENABLE btOk btCancelar WITH FRAME fPage0.    

   ASSIGN btGoTo:HIDDEN IN FRAME fPage0 = YES
          btSearch:HIDDEN IN FRAME fPage0 = YES.

   DISABLE da-data-duimp i-num-versao WITH FRAME fPage0.
   ASSIGN  da-data-duimp:HIDDEN IN FRAME fPage0 = YES
           i-num-versao:HIDDEN IN FRAME fPage0 = YES.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenance 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    ASSIGN cb-idi-tributac-ibsuf:LIST-ITEMS  IN FRAME fpage2 = {diinc/i01di628.i 03}
           cb-idi-tributac-ibsmun:LIST-ITEMS IN FRAME fpage3 = {diinc/i01di628.i 03}
           cb-idi-tributac-cbs:LIST-ITEMS    IN FRAME fpage1 = {diinc/i01di628.i 03}
           cb-idi-tributac-is:LIST-ITEMS     IN FRAME fpage4 = {diinc/i01di628.i 03}.          
    
    //ASSIGN cb-idi-tributac-cbs:SCREEN-VALUE    IN FRAME fpage1 = "Tributado".
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDBOParentHandle wMaintenance 
PROCEDURE getDBOParentHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pDBOHandle  AS HANDLE  NO-UNDO.

    ASSIGN pDBOHandle = h-bocx383.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDBOSonHandle wMaintenance 
PROCEDURE getDBOSonHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE  INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pDBOHandle  AS HANDLE  NO-UNDO.

    CASE pPageNumber:        
        WHEN 1 THEN DO:
            //ASSIGN pDBOHandle = h-bocx404.
        END.
        WHEN 2 THEN DO:
            //ASSIGN pDBOHandle = h-bocx403.
        END.
    END CASE.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getParentRecord wMaintenance 
PROCEDURE getParentRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR tt-decla-import.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
    Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---  */
    IF  NOT VALID-HANDLE({&hDBOTable}) OR
        {&hDBOTable}:TYPE      <> "PROCEDURE":U OR
        {&hDBOTable}:FILE-NAME <> "cxbo/bocx383.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx383.p YES}
        {btb/btb008za.i2 cxbo/bocx383.p '' {&hDBOTable}}
    END.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

     IF NOT VALID-HANDLE (h-bocx383a) THEN DO:
        RUN cxbo/bocx383a.p PERSISTENT SET h-bocx383a.
        RUN openQueryStatic IN h-bocx383a (INPUT "Main":U) NO-ERROR.
    END.
    
    IF NOT VALID-HANDLE(h-bocx00487) THEN DO:
        RUN cxbo/bocx00487.p PERSISTENT SET h-bocx00487.
    END.
    RUN openQueryStatic IN h-bocx00487 (INPUT "Main":U) NO-ERROR.
                
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-valor-impostos wMaintenance 
PROCEDURE pi-busca-valor-impostos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*  valores do combo-box de tributa»’o:
        0 - tributado 
        1 - Isento
        2 - Outros
        3 - Reduzido
    */
    IF l-nt2024002 THEN DO:
        ASSIGN de-val-aliq-ibsuf        = 0
               de-val-aliq-ibsmun       = 0
               de-val-aliq-cbs          = 0
               de-val-aliq-is           = 0
               de-perc-reduc-ibsuf      = 0
               de-perc-reduc-ibsmun     = 0
               de-perc-reduc-cbs        = 0
               de-base-ibsuf            = 0
               de-base-ibsmun           = 0
               de-base-cbs              = 0
               de-base-is               = 0
               de-valor-impostos-ibsuf  = 0
               de-valor-impostos-ibsmun = 0
               de-valor-impostos-cbs    = 0
               de-valor-impostos-is     = 0
               c-cst-ibsuf              = ""
               c-cst-ibsmun             = ""
               c-cst-cbs                = ""
               c-cst-is                 = ""
               c-class-trib-ibsuf       = ""
               c-class-trib-ibsmun      = ""
               c-class-trib-cbs         = ""
               c-class-trib-is          = ""
               i-trib-ibsuf             = 1
               i-trib-ibsmun            = 1
               i-trib-cbs               = 1
               i-trib-is                = 1
               de-val-aliq-reg-ibsuf    = 0
               de-val-aliq-reg-ibsmun   = 0
               de-val-aliq-reg-cbs      = 0
               de-base-reg-ibsuf        = 0
               de-base-reg-ibsmun       = 0
               de-base-reg-cbs          = 0
               de-valor-impostos-reg-ibsuf  = 0
               de-valor-impostos-reg-ibsmun = 0
               de-valor-impostos-reg-cbs    = 0
               c-class-trib-reg-ibsuf       = ""
               c-class-trib-reg-ibsmun      = ""
               c-class-trib-reg-cbs         = ""
               c-cst-reg-ibsuf              = ""
               c-cst-reg-ibsmun             = ""
               c-cst-reg-cbs                = ""
               de-aliq-espec-is             = 0
               de-qtde-trib-is              = 0
               c-un-trib-is                 = "".
                                                           

        FOR EACH decla-import-adic-trib NO-LOCK
           WHERE decla-import-adic-trib.num-di-ems       = pttnum-de-ems
             AND decla-import-adic-trib.num-adic         = pttnum-adic
             AND decla-import-adic-trib.cdd-siscomex-dts = pttcdd-scmx-dts:
            
            CASE decla-import-adic-trib.nom-trib:
                WHEN "IBSUF":U THEN DO:
                    CASE decla-import-adic-trib.cod-campo:
                        WHEN "COD-TRIB":U THEN
                            ASSIGN i-trib-ibsuf = INT(decla-import-adic-trib.cod-conteudo).
                        WHEN "ALIQUOTA":U THEN
                            ASSIGN de-val-aliq-ibsuf = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "ALIQ-RED":U THEN
                            ASSIGN de-perc-reduc-ibsuf = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "BASE":U THEN
                            ASSIGN de-base-ibsuf = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "VALOR":U OR 
                        WHEN "OUTROS":U THEN
                            ASSIGN de-valor-impostos-ibsuf = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "CST":U THEN
                            ASSIGN c-cst-ibsuf = decla-import-adic-trib.cod-conteudo.
                        WHEN "C-CLASS-TRIB":U THEN
                            ASSIGN c-class-trib-ibsuf = decla-import-adic-trib.cod-conteudo.
                        WHEN "ALIQ-EFETIVA-REG":U THEN
                            ASSIGN de-val-aliq-reg-ibsuf = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "BASE-REG":U THEN
                            ASSIGN de-base-reg-ibsuf = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "VALOR-REG":U THEN
                            ASSIGN de-valor-impostos-reg-ibsuf = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "C-CLASS-TRIB-REG":U THEN
                            ASSIGN c-class-trib-reg-ibsuf = decla-import-adic-trib.cod-conteudo.
                        WHEN "CST-REG":U THEN
                            ASSIGN c-cst-reg-ibsuf = decla-import-adic-trib.cod-conteudo.
                    END CASE.
                END.
                WHEN "IBSMUN":U THEN DO:
                    CASE decla-import-adic-trib.cod-campo:
                        WHEN "COD-TRIB":U THEN
                            ASSIGN i-trib-ibsmun = INT(decla-import-adic-trib.cod-conteudo).
                        WHEN "ALIQUOTA":U THEN
                            ASSIGN de-val-aliq-ibsmun = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "ALIQ-RED":U THEN
                            ASSIGN de-perc-reduc-ibsmun = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "BASE":U THEN
                            ASSIGN de-base-ibsmun = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "VALOR":U OR 
                        WHEN "OUTROS":U THEN
                            ASSIGN de-valor-impostos-ibsmun = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "CST":U THEN
                            ASSIGN c-cst-ibsmun = decla-import-adic-trib.cod-conteudo.
                        WHEN "C-CLASS-TRIB":U THEN
                            ASSIGN c-class-trib-ibsmun = decla-import-adic-trib.cod-conteudo.
                        WHEN "ALIQ-EFETIVA-REG":U THEN
                            ASSIGN de-val-aliq-reg-ibsmun = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "BASE-REG":U THEN
                            ASSIGN de-base-reg-ibsmun = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "VALOR-REG":U THEN
                            ASSIGN de-valor-impostos-reg-ibsmun = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "C-CLASS-TRIB-REG":U THEN
                            ASSIGN c-class-trib-reg-ibsmun = decla-import-adic-trib.cod-conteudo.
                        WHEN "CST-REG":U THEN
                            ASSIGN c-cst-reg-ibsmun = decla-import-adic-trib.cod-conteudo.
                    END CASE.
                END.
                WHEN "CBS":U THEN DO:
                    CASE decla-import-adic-trib.cod-campo:
                        WHEN "COD-TRIB":U THEN
                            ASSIGN i-trib-cbs = INT(decla-import-adic-trib.cod-conteudo).
                        WHEN "ALIQUOTA":U THEN
                            ASSIGN de-val-aliq-cbs = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "ALIQ-RED":U THEN
                            ASSIGN de-perc-reduc-cbs = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "BASE":U THEN
                            ASSIGN de-base-cbs = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "VALOR":U OR 
                        WHEN "OUTROS":U THEN
                            ASSIGN de-valor-impostos-cbs = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "CST":U THEN
                            ASSIGN c-cst-cbs = decla-import-adic-trib.cod-conteudo.
                        WHEN "C-CLASS-TRIB":U THEN
                            ASSIGN c-class-trib-cbs = decla-import-adic-trib.cod-conteudo.
                        WHEN "ALIQ-EFETIVA-REG":U THEN
                            ASSIGN de-val-aliq-reg-cbs = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "BASE-REG":U THEN
                            ASSIGN de-base-reg-cbs = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "VALOR-REG":U THEN
                            ASSIGN de-valor-impostos-reg-cbs = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "C-CLASS-TRIB-REG":U THEN
                            ASSIGN c-class-trib-reg-cbs = decla-import-adic-trib.cod-conteudo.
                        WHEN "CST-REG":U THEN
                            ASSIGN c-cst-reg-cbs = decla-import-adic-trib.cod-conteudo.
                    END CASE.
                END.
                WHEN "IS":U THEN DO:
                    CASE decla-import-adic-trib.cod-campo:        
                        WHEN "COD-TRIB":U THEN
                            ASSIGN i-trib-is = INT(decla-import-adic-trib.cod-conteudo).
                        WHEN "ALIQUOTA":U THEN
                            ASSIGN de-val-aliq-is = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "ALIQ-ESPEC-UN":U THEN
                            ASSIGN de-aliq-espec-is = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "QTDE-TRIBUT":U THEN
                            ASSIGN de-qtde-trib-is = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "UN-TRIBUT":U THEN
                            ASSIGN c-un-trib-is = decla-import-adic-trib.cod-conteudo.
                        WHEN "BASE":U THEN
                            ASSIGN de-base-is = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "VALOR":U OR 
                        WHEN "OUTROS":U THEN
                            ASSIGN de-valor-impostos-is = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "CST":U THEN
                            ASSIGN c-cst-is = decla-import-adic-trib.cod-conteudo.
                        WHEN "C-CLASS-TRIB":U THEN
                            ASSIGN c-class-trib-is = decla-import-adic-trib.cod-conteudo.
                    END CASE.
                END.
            END CASE.
        END.
        
        ASSIGN cb-idi-tributac-ibsuf:SCREEN-VALUE  IN FRAME fpage2 = {diinc/i01di628.i 04 i-trib-ibsuf}
               cb-idi-tributac-ibsmun:SCREEN-VALUE IN FRAME fpage3 = {diinc/i01di628.i 04 i-trib-ibsmun}
               cb-idi-tributac-cbs:SCREEN-VALUE    IN FRAME fpage1 = {diinc/i01di628.i 04 i-trib-cbs}.
               cb-idi-tributac-is:SCREEN-VALUE     IN FRAME fpage4 = {diinc/i01di628.i 04 i-trib-is}.
        
        DISP de-val-aliq-ibsuf            
             de-perc-reduc-ibsuf          
             de-base-ibsuf                
             de-valor-impostos-ibsuf      
             c-cst-ibsuf                  
             c-class-trib-ibsuf           
             de-val-aliq-reg-ibsuf        
             de-base-reg-ibsuf            
             de-valor-impostos-reg-ibsuf  
             c-class-trib-reg-ibsuf       
             c-cst-reg-ibsuf WITH FRAME fpage2.
        DISP de-val-aliq-ibsmun            
             de-perc-reduc-ibsmun          
             de-base-ibsmun                
             de-valor-impostos-ibsmun      
             c-cst-ibsmun                  
             c-class-trib-ibsmun           
             de-val-aliq-reg-ibsmun        
             de-base-reg-ibsmun            
             de-valor-impostos-reg-ibsmun  
             c-class-trib-reg-ibsmun       
             c-cst-reg-ibsmun WITH FRAME fpage3.
        DISP de-val-aliq-is
             de-aliq-espec-is
             de-qtde-trib-is
             c-un-trib-is
             de-base-is
             de-valor-impostos-is
             c-cst-is
             c-class-trib-is WITH FRAME fpage4.
        DISP de-val-aliq-cbs
             de-perc-reduc-cbs
             de-base-cbs
             de-valor-impostos-cbs
             c-cst-cbs
             c-class-trib-cbs
             de-val-aliq-reg-cbs
             de-base-reg-cbs
             de-valor-impostos-reg-cbs
             c-class-trib-reg-cbs
             c-cst-reg-cbs WITH FRAME fpage1.

        APPLY "LEAVE":U TO c-class-trib-ibsuf  IN FRAME fpage2.
        APPLY "LEAVE":U TO c-class-trib-ibsmun IN FRAME fpage3.
        APPLY "LEAVE":U TO c-class-trib-cbs    IN FRAME fpage1.
        APPLY "LEAVE":U TO c-class-trib-is     IN FRAME fpage4.
        
        DISABLE cb-idi-tributac-ibsuf       
                de-base-ibsuf               
                de-valor-impostos-ibsuf     
                de-val-aliq-reg-ibsuf       
                de-base-reg-ibsuf           
                de-valor-impostos-reg-ibsuf WITH FRAME fpage2.
        DISABLE cb-idi-tributac-ibsmun       
                de-base-ibsmun               
                de-valor-impostos-ibsmun     
                de-val-aliq-reg-ibsmun       
                de-base-reg-ibsmun           
                de-valor-impostos-reg-ibsmun WITH FRAME fpage3.
        DISABLE cb-idi-tributac-cbs 
                de-base-cbs 
                de-valor-impostos-cbs
                de-val-aliq-reg-cbs
                de-base-reg-cbs
                de-valor-impostos-reg-cbs WITH FRAME fpage1.
         DISABLE cb-idi-tributac-is de-base-is de-valor-impostos-is WITH FRAM fpage4.
         ENABLE de-val-aliq-cbs de-perc-reduc-cbs c-cst-cbs c-class-trib-cbs WITH FRAME fpage1.
         ENABLE de-val-aliq-ibsuf de-perc-reduc-ibsuf c-cst-ibsuf c-class-trib-ibsuf WITH FRAME fpage2.
         ENABLE de-val-aliq-ibsmun de-perc-reduc-ibsmun c-cst-ibsmun c-class-trib-ibsmun WITH FRAME fpage3.
         ENABLE de-val-aliq-is c-cst-is c-class-trib-is c-un-trib-is  de-aliq-espec-is de-qtde-trib-is WITH FRAME fpage4.
    END.
        
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-decla-import-adic-trib wMaintenance 
PROCEDURE pi-grava-decla-import-adic-trib :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nom-trib      AS CHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-campo     AS CHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-conteudo  AS CHAR  NO-UNDO.

    IF LOOKUP(p-cod-campo,"ALIQ-EFETIVA-REG,BASE-REG,VALOR-REG,C-CLASS-TRIB-REG,CST-REG") > 0 
    AND (p-cod-conteudo = "" OR p-cod-conteudo = "0") THEN DO:
        FOR FIRST decla-import-adic-trib
            WHERE decla-import-adic-trib.num-di-ems       = pttnum-de-ems     
              AND decla-import-adic-trib.num-adic         = pttnum-adic
              AND decla-import-adic-trib.cdd-siscomex-dts = pttcdd-scmx-dts
              AND decla-import-adic-trib.nom-trib         = p-nom-trib 
              AND decla-import-adic-trib.cod-campo        = p-cod-campo EXCLUSIVE-LOCK:
            DELETE decla-import-adic-trib NO-ERROR.
        END.
    END.
    ELSE DO:
        FIND FIRST decla-import-adic-trib
             WHERE decla-import-adic-trib.num-di-ems       = pttnum-de-ems
               AND decla-import-adic-trib.num-adic         = pttnum-adic
               AND decla-import-adic-trib.cdd-siscomex-dts = pttcdd-scmx-dts
               AND decla-import-adic-trib.nom-trib         = p-nom-trib 
               AND decla-import-adic-trib.cod-campo        = p-cod-campo EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL decla-import-adic-trib THEN DO:
            CREATE decla-import-adic-trib.
            ASSIGN decla-import-adic-trib.num-di-ems       = pttnum-de-ems 
                   decla-import-adic-trib.num-adic         = pttnum-adic
                   decla-import-adic-trib.cdd-siscomex-dts = pttcdd-scmx-dts
                   decla-import-adic-trib.nom-trib         = p-nom-trib 
                   decla-import-adic-trib.cod-campo        = p-cod-campo.
        END.
        ASSIGN decla-import-adic-trib.cod-conteudo = p-cod-conteudo.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-impostos wMaintenance 
PROCEDURE pi-grava-impostos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF l-nt2024002 THEN DO:
         ASSIGN INPUT FRAME fpage2 cb-idi-tributac-ibsuf
                INPUT FRAME fpage3 cb-idi-tributac-ibsmun
                INPUT FRAME fpage1 cb-idi-tributac-cbs
                INPUT FRAME fpage4 cb-idi-tributac-is.
                
         /* IBS UF */
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "COD-TRIB",     INPUT {diinc/i01di628.i 06 cb-idi-tributac-ibsuf:SCREEN-VALUE IN FRAME fpage2}).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "ALIQUOTA",     INPUT INPUT FRAME fpage2 de-val-aliq-ibsuf).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "ALIQ-RED",     INPUT INPUT FRAME fpage2 de-perc-reduc-ibsuf).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "BASE",         INPUT INPUT FRAME fpage2 de-base-ibsuf).
         IF SUBSTRING(INPUT FRAME fpage2 cb-idi-tributac-ibsuf,1,1) = "O":U THEN //Outros
            RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "OUTROS",    INPUT INPUT FRAME fpage2 de-valor-impostos-ibsuf). 
         ELSE
            RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "VALOR",     INPUT INPUT FRAME fpage2 de-valor-impostos-ibsuf).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "CST",          INPUT INPUT FRAME fpage2 c-cst-ibsuf).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "C-CLASS-TRIB", INPUT INPUT FRAME fpage2 c-class-trib-ibsuf).
         
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "ALIQ-EFETIVA-REG", INPUT INPUT FRAME fpage2 de-val-aliq-reg-ibsuf).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "BASE-REG",         INPUT INPUT FRAME fpage2 de-base-reg-ibsuf).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "VALOR-REG",        INPUT INPUT FRAME fpage2 de-valor-impostos-reg-ibsuf).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "C-CLASS-TRIB-REG", INPUT INPUT FRAME fpage2 c-class-trib-reg-ibsuf).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "CST-REG",          INPUT INPUT FRAME fpage2 c-cst-reg-ibsuf).

         /* IBS Mun */
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "COD-TRIB",     INPUT {diinc/i01di628.i 06 cb-idi-tributac-ibsmun:SCREEN-VALUE IN FRAME fpage3}).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "ALIQUOTA",     INPUT INPUT FRAME fpage3 de-val-aliq-ibsmun).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "ALIQ-RED",     INPUT INPUT FRAME fpage3 de-perc-reduc-ibsmun).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "BASE",         INPUT INPUT FRAME fpage3 de-base-ibsmun).
         IF SUBSTRING(INPUT FRAME fpage3 cb-idi-tributac-ibsmun,1,1) = "O":U THEN //Outros
            RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "OUTROS",    INPUT INPUT FRAME fpage3 de-valor-impostos-ibsmun). 
         ELSE
            RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "VALOR",     INPUT INPUT FRAME fpage3 de-valor-impostos-ibsmun).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "CST",          INPUT INPUT FRAME fpage3 c-cst-ibsmun).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "C-CLASS-TRIB", INPUT INPUT FRAME fpage3 c-class-trib-ibsmun).
         
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "ALIQ-EFETIVA-REG", INPUT INPUT FRAME fpage3 de-val-aliq-reg-ibsmun).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "BASE-REG",         INPUT INPUT FRAME fpage3 de-base-reg-ibsmun).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "VALOR-REG",        INPUT INPUT FRAME fpage3 de-valor-impostos-reg-ibsmun).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "C-CLASS-TRIB-REG", INPUT INPUT FRAME fpage3 c-class-trib-reg-ibsmun).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "CST-REG",          INPUT INPUT FRAME fpage3 c-cst-reg-ibsmun).

         /* CBS */
         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "COD-TRIB",     INPUT {diinc/i01di628.i 06 cb-idi-tributac-cbs:SCREEN-VALUE IN FRAME fpage1}).
         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "ALIQUOTA",     INPUT INPUT FRAME fpage1 de-val-aliq-cbs).
         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "ALIQ-RED",     INPUT INPUT FRAME fpage1 de-perc-reduc-cbs).
         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "BASE",         INPUT INPUT FRAME fpage1 de-base-cbs).
         IF SUBSTRING(INPUT FRAME fpage1 cb-idi-tributac-cbs,1,1) = "O":U THEN //Outros
            RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "OUTROS",    INPUT INPUT FRAME fpage1 de-valor-impostos-cbs). 
         ELSE
            RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "VALOR",     INPUT INPUT FRAME fpage1 de-valor-impostos-cbs).
         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "CST",          INPUT INPUT FRAME fpage1 c-cst-cbs).
         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "C-CLASS-TRIB", INPUT INPUT FRAME fpage1 c-class-trib-cbs).

         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "ALIQ-EFETIVA-REG", INPUT INPUT FRAME fpage1 de-val-aliq-reg-cbs).
         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "BASE-REG",         INPUT INPUT FRAME fpage1 de-base-reg-cbs).
         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "VALOR-REG",        INPUT INPUT FRAME fpage1 de-valor-impostos-reg-cbs).
         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "C-CLASS-TRIB-REG", INPUT INPUT FRAME fpage1 c-class-trib-reg-cbs).
         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "CST-REG",          INPUT INPUT FRAME fpage1 c-cst-reg-cbs).
         
         /* IS */
         RUN pi-grava-decla-import-adic-trib (INPUT "IS", INPUT "COD-TRIB",     INPUT {diinc/i01di628.i 06 cb-idi-tributac-is:SCREEN-VALUE IN FRAME fpage4}).
         RUN pi-grava-decla-import-adic-trib (INPUT "IS", INPUT "ALIQUOTA",     INPUT INPUT FRAME fpage4 de-val-aliq-is).
         RUN pi-grava-decla-import-adic-trib (INPUT "IS", INPUT "ALIQ-ESPEC-UN",INPUT INPUT FRAME fpage4 de-aliq-espec-is).
         RUN pi-grava-decla-import-adic-trib (INPUT "IS", INPUT "QTDE-TRIBUT",  INPUT INPUT FRAME fpage4 de-qtde-trib-is).
         RUN pi-grava-decla-import-adic-trib (INPUT "IS", INPUT "UN-TRIBUT", INPUT INPUT FRAME fpage4 c-un-trib-is).
         RUN pi-grava-decla-import-adic-trib (INPUT "IS", INPUT "BASE",         INPUT INPUT FRAME fpage4 de-base-is).
         IF SUBSTRING(INPUT FRAME fpage4 cb-idi-tributac-is,1,1) = "O":U THEN //Outros
            RUN pi-grava-decla-import-adic-trib (INPUT "IS", INPUT "OUTROS",    INPUT INPUT FRAME fpage4 de-valor-impostos-is). 
         ELSE
            RUN pi-grava-decla-import-adic-trib (INPUT "IS", INPUT "VALOR",     INPUT INPUT FRAME fpage4 de-valor-impostos-is).
         RUN pi-grava-decla-import-adic-trib (INPUT "IS", INPUT "CST",          INPUT INPUT FRAME fpage4 c-cst-is).
         RUN pi-grava-decla-import-adic-trib (INPUT "IS", INPUT "C-CLASS-TRIB", INPUT INPUT FRAME fpage4 c-class-trib-is).
         
         
         /* Atualiza a decla-import-ord-trib com as altera»„es da adi»’o pttnum-de-ems pttnum-adic pttcdd-scmx-dts pttnum-ordem pttnum-parcela pttnum-seq*/
         FOR EACH decla-import-ord-trib EXCLUSIVE-LOCK
             WHERE decla-import-ord-trib.num-di-ems       = pttnum-de-ems
             AND   decla-import-ord-trib.num-ordem        = pttnum-ordem  
             AND   decla-import-ord-trib.num-parcela      = pttnum-parcela
             AND   decla-import-ord-trib.cdd-siscomex-dts = pttcdd-scmx-dts:
           
             FOR FIRST decla-import-adic-trib NO-LOCK
                 WHERE decla-import-adic-trib.num-di-ems       = pttnum-de-ems
                 AND   decla-import-adic-trib.num-adic         = pttnum-adic
                 AND   decla-import-adic-trib.cdd-siscomex-dts = pttcdd-scmx-dts
                 AND   decla-import-adic-trib.nom-trib         = decla-import-ord-trib.nom-trib
                 AND   decla-import-adic-trib.cod-campo        = decla-import-ord-trib.cod-campo:
                 ASSIGN decla-import-ord-trib.cod-conteudo = decla-import-adic-trib.cod-conteudo.
             END.
         END.
        
         /* Atualiza a decla-imp-adic-it-trib com as altera»„es da adi»’o */
         FOR EACH decla-imp-adic-it-trib EXCLUSIVE-LOCK
             WHERE decla-imp-adic-it-trib.num-di-ems       = pttnum-de-ems
             AND   decla-imp-adic-it-trib.num-adic         = pttnum-adic
             AND   decla-imp-adic-it-trib.num-seq          = pttnum-seq
             AND   decla-imp-adic-it-trib.cdd-siscomex-dts = pttcdd-scmx-dts:
           
             FOR FIRST decla-import-adic-trib NO-LOCK
                 WHERE decla-import-adic-trib.num-di-ems       = pttnum-de-ems
                 AND   decla-import-adic-trib.num-adic         = pttnum-adic
                 AND   decla-import-adic-trib.cdd-siscomex-dts = pttcdd-scmx-dts
                 AND   decla-import-adic-trib.nom-trib         = decla-imp-adic-it-trib.nom-trib
                 AND   decla-import-adic-trib.cod-campo        = decla-imp-adic-it-trib.cod-campo:               
                 ASSIGN decla-imp-adic-it-trib.cod-conteudo = decla-import-adic-trib.cod-conteudo.
             END.
         END.
     END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionRecordSon wMaintenance 
PROCEDURE repositionRecordSon :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid      AS ROWID   NO-UNDO.
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
