&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttAbast NO-UNDO LIKE mab-item-abastec
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttApontamento NO-UNDO LIKE mab-abastec-lubrific
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttLubrif NO-UNDO LIKE mab-item-lubrific
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0611 2.00.00.006 } /*** 010006 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0611 MAB}
&ENDIF


/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          AB0611
&GLOBAL-DEFINE Version        2.00.00.006

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Combust¡vel, àleo/Filtro

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        NO
&GLOBAL-DEFINE CopyParent       NO
&GLOBAL-DEFINE UpdateParent     NO
&GLOBAL-DEFINE DeleteParent     NO

&GLOBAL-DEFINE AddSon1          NO
&GLOBAL-DEFINE CopySon1         NO
&GLOBAL-DEFINE UpdateSon1       NO
&GLOBAL-DEFINE DeleteSon1       NO

&GLOBAL-DEFINE AddSon2          NO
&GLOBAL-DEFINE CopySon2         NO
&GLOBAL-DEFINE UpdateSon2       NO
&GLOBAL-DEFINE DeleteSon2       NO

&GLOBAL-DEFINE ttParent         ttApontamento
&GLOBAL-DEFINE hDBOParent       hDBOApontamento
&GLOBAL-DEFINE DBOParentTable   mab-abastec-lubrific
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           ttAbast
&GLOBAL-DEFINE hDBOSon1         hDBOAbast
&GLOBAL-DEFINE DBOSon1Table     mab-item-abastec
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE ttSon2           ttLubrif
&GLOBAL-DEFINE hDBOSon2         hDBOLubrif
&GLOBAL-DEFINE DBOSon2Table     mab-item-lubrific
&GLOBAL-DEFINE DBOSon2Destroy   YES

&GLOBAL-DEFINE page0Fields      ttApontamento.ep-codigo ttApontamento.cod-eqpto ~
                                ttApontamento.dat-movto ttApontamento.num-docto ~
                                ttApontamento.cod-ativid ttApontamento.ep-codigo-matr ~
                                ttApontamento.cod-ativid ttApontamento.cod-estabel-matr ~
                                ttApontamento.cod-ativid ttApontamento.cod-matr ~
                                ttApontamento.cod-posto ttApontamento.cod-usuar ~
                                ttApontamento.dat-movto ttApontamento.hra-final ~
                                ttApontamento.hra-inicial ttApontamento.nr-nota-fis ~
                                ttApontamento.serie ttApontamento.val-hodom-horim ttApontamento.num-docto-orig ~
                                ttApontamento.val-hodom-horim-sec fiUnSec ttApontamento.dat-livre-1 ~
                                ttApontamento.dat-livre-2 ttApontamento.cod-livre-1

&GLOBAL-DEFINE page0Widgets     btIntegraXML

&GLOBAL-DEFINE page1Browse      brSon1
&GLOBAL-DEFINE page2Browse      brSon2

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cCodModelo  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDescricao  AS CHARACTER format "x(30)" NO-UNDO.
DEFINE VARIABLE cDescricao2 AS CHARACTER format "x(30)" NO-UNDO.
DEFINE VARIABLE cDescricao3 AS CHARACTER format "x(30)" NO-UNDO.
DEFINE VARIABLE rRowidSon1 AS ROWID NO-UNDO.
DEFINE VARIABLE rRowidSon2 AS ROWID NO-UNDO.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEqpto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOPosto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOMoto      AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOAtiv      AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOHistor    AS HANDLE NO-UNDO.

&IF DEFINED(bf_mnt_ems206b) &THEN
    {frbo/bofr133.i tt-unid-negoc-histor}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttAbast ttLubrif

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 ttAbast.cod-posto ttAbast.cod-bomba ~
ttAbast.cod-tip-mater fnDescMaterial(ttAbast.cod-tip-mater) @ cDescricao ~
ttAbast.it-codigo ttAbast.cod-refer ttAbast.lote ttAbast.cod-localiz ~
ttAbast.val-quant ttAbast.val-mater-1 ttAbast.cod-cta-ctbl ~
ttAbast.cod-ccusto 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH ttAbast NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH ttAbast NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 ttAbast
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 ttAbast


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 ttLubrif.cod-comptmento ~
fnDescComp(ttLubrif.cod-comptmento) @ cDescricao2 ttLubrif.cod-tip-mater ~
fnDescMaterial(ttLubrif.cod-tip-mater) @ cDescricao ttLubrif.it-codigo ~
ttLubrif.cod-refer ttLubrif.lote ttLubrif.cod-localiz ttLubrif.cod-evento ~
fnDescEvento(ttLubrif.cod-evento) @ cDescricao3 ttLubrif.cd-tipo ~
ttLubrif.val-quant ttLubrif.val-mater-1 ttLubrif.cod-cta-ctbl ~
ttLubrif.cod-ccusto 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH ttLubrif NO-LOCK
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH ttLubrif NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon2 ttLubrif
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 ttLubrif


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttApontamento.num-docto ~
ttApontamento.dat-movto ttApontamento.hra-inicial ttApontamento.hra-final ~
ttApontamento.val-hodom-horim ttApontamento.ep-codigo ~
ttApontamento.cod-eqpto ttApontamento.val-hodom-horim-sec ~
ttApontamento.nr-nota-fis ttApontamento.cod-posto ttApontamento.serie ~
ttApontamento.ep-codigo-matr ttApontamento.cod-estabel-matr ~
ttApontamento.cod-matr ttApontamento.num-docto-orig ~
ttApontamento.cod-ativid ttApontamento.dat-livre-1 ttApontamento.cod-usuar ~
ttApontamento.dat-livre-2 ttApontamento.cod-livre-1 
&Scoped-define ENABLED-TABLES ttApontamento
&Scoped-define FIRST-ENABLED-TABLE ttApontamento
&Scoped-Define ENABLED-OBJECTS IMAGE-1 IMAGE-2 RECT-27 RECT-28 rtParent ~
rtToolBar btFirst btPrev btNext btLast btGoTo btSearch btIntegraXML ~
btQueryJoins btReportsJoins btExit btHelp fiUn fiDescModelo fiUnSec ~
fiStatus fiEstoque fiDescPosto fiTipPosto fiDescMotorista btMatriz ~
fiDescAtiv fi-cod-unid-negoc tg-rastreamento 
&Scoped-Define DISPLAYED-FIELDS ttApontamento.num-docto ~
ttApontamento.dat-movto ttApontamento.hra-inicial ttApontamento.hra-final ~
ttApontamento.val-hodom-horim ttApontamento.ep-codigo ~
ttApontamento.cod-eqpto ttApontamento.val-hodom-horim-sec ~
ttApontamento.nr-nota-fis ttApontamento.cod-posto ttApontamento.serie ~
ttApontamento.ep-codigo-matr ttApontamento.cod-estabel-matr ~
ttApontamento.cod-matr ttApontamento.num-docto-orig ~
ttApontamento.cod-ativid ttApontamento.dat-livre-1 ttApontamento.cod-usuar ~
ttApontamento.dat-livre-2 ttApontamento.cod-livre-1 
&Scoped-define DISPLAYED-TABLES ttApontamento
&Scoped-define FIRST-DISPLAYED-TABLE ttApontamento
&Scoped-Define DISPLAYED-OBJECTS fiUn fiDescModelo fiUnSec fiStatus ~
fiEstoque fiDescPosto fiTipPosto fiDescMotorista fiDescAtiv ~
fi-cod-unid-negoc tg-rastreamento 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescComp wMasterDetail 
FUNCTION fnDescComp RETURNS CHARACTER
  ( pComp as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescEvento wMasterDetail 
FUNCTION fnDescEvento RETURNS CHARACTER
  ( pEvento as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescMaterial wMasterDetail 
FUNCTION fnDescMaterial RETURNS CHARACTER
  ( pMaterial as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "P&r¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "Pes&quisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miQueryJoins   LABEL "C&onsultas"    
       MENU-ITEM miReportsJoins LABEL "Rela&t¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "Aj&uda"        .


/* Definitions of the field level widgets                               */
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

DEFINE BUTTON btIntegraXML 
     IMAGE-UP FILE "image\im-exp":U
     IMAGE-INSENSITIVE FILE "image/im-exp.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Exporta‡Æo XML".

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image/im-las":U
     IMAGE-INSENSITIVE FILE "image/ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btMatriz 
     IMAGE-UP FILE "image/im-negoc.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-negoc.bmp":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Matriz Unidade Neg¢cio".

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image/im-nex":U
     IMAGE-INSENSITIVE FILE "image/ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

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

DEFINE VARIABLE fi-cod-unid-negoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unid. Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescAtiv AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescMotorista AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 33.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescPosto AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE fiEstoque AS CHARACTER FORMAT "X(20)":U 
     LABEL "Integra‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fiStatus AS CHARACTER FORMAT "X(50)":U 
     LABEL "Status" 
     VIEW-AS FILL-IN 
     SIZE 33 BY .88 NO-UNDO.

DEFINE VARIABLE fiTipPosto AS CHARACTER FORMAT "X(10)":U 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiUn AS CHARACTER FORMAT "xx" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fiUnSec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 1.42.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 1.42.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 7.92.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE tg-rastreamento AS LOGICAL INITIAL no 
     LABEL "Integra Rastreamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE BUTTON btDetalhe1 
     LABEL "&Detalhar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDetalhe2 
     LABEL "&Detalhar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      ttAbast SCROLLING.

DEFINE QUERY brSon2 FOR 
      ttLubrif SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      ttAbast.cod-posto FORMAT "x(8)":U
      ttAbast.cod-bomba FORMAT "x(12)":U
      ttAbast.cod-tip-mater FORMAT "x(8)":U
      fnDescMaterial(ttAbast.cod-tip-mater) @ cDescricao COLUMN-LABEL "Descri‡Æo" FORMAT "x(30)":U
            WIDTH 30
      ttAbast.it-codigo FORMAT "x(16)":U
      ttAbast.cod-refer FORMAT "x(8)":U
      ttAbast.lote FORMAT "40":U WIDTH 40
      ttAbast.cod-localiz FORMAT "20":U WIDTH 20
      ttAbast.val-quant FORMAT ">>>,>>9.99":U
      ttAbast.val-mater-1 FORMAT ">>>,>>>,>>9.9999":U
      ttAbast.cod-cta-ctbl COLUMN-LABEL "Conta Cont bil":R20 FORMAT "x(20)":U
      ttAbast.cod-ccusto COLUMN-LABEL "Centro de Custo":R20 FORMAT "x(20)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 4
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _STRUCTURED
  QUERY brSon2 NO-LOCK DISPLAY
      ttLubrif.cod-comptmento FORMAT "x(8)":U
      fnDescComp(ttLubrif.cod-comptmento) @ cDescricao2 COLUMN-LABEL "Descri‡Æo" FORMAT "x(30)":U
            WIDTH 30
      ttLubrif.cod-tip-mater FORMAT "x(8)":U
      fnDescMaterial(ttLubrif.cod-tip-mater) @ cDescricao COLUMN-LABEL "Descri‡Æo" FORMAT "x(30)":U
            WIDTH 30
      ttLubrif.it-codigo FORMAT "x(16)":U
      ttLubrif.cod-refer FORMAT "x(8)":U
      ttLubrif.lote FORMAT "40":U WIDTH 40
      ttLubrif.cod-localiz FORMAT "20":U WIDTH 20
      ttLubrif.cod-evento FORMAT "x(08)":U
      fnDescEvento(ttLubrif.cod-evento) @ cDescricao3 COLUMN-LABEL "Descri‡Æo" FORMAT "x(30)":U
            WIDTH 30
      ttLubrif.cd-tipo FORMAT ">>,>>9":U
      ttLubrif.val-quant FORMAT ">,>>>,>>9.99":U
      ttLubrif.val-mater-1 FORMAT ">>>,>>>,>>9.9999":U
      ttLubrif.cod-cta-ctbl FORMAT "x(20)":U WIDTH 15
      ttLubrif.cod-ccusto COLUMN-LABEL "Centro de Custo" FORMAT "x(20)":U
            WIDTH 15
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 4
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
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
     btIntegraXML AT ROW 1.13 COL 61.86
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     ttApontamento.num-docto AT ROW 2.83 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     ttApontamento.dat-movto AT ROW 2.83 COL 29.14 COLON-ALIGNED
          LABEL "Data"
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     ttApontamento.hra-inicial AT ROW 2.83 COL 39.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ttApontamento.hra-final AT ROW 2.83 COL 55.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ttApontamento.val-hodom-horim AT ROW 2.83 COL 71.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fiUn AT ROW 2.83 COL 84 COLON-ALIGNED HELP
          "Unidade do contador do equipamento" NO-LABEL
     ttApontamento.ep-codigo AT ROW 3.83 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttApontamento.cod-eqpto AT ROW 3.83 COL 14.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     fiDescModelo AT ROW 3.83 COL 28.72 COLON-ALIGNED HELP
          "Descri‡Æo Modelo Equipamento" NO-LABEL
     ttApontamento.val-hodom-horim-sec AT ROW 3.83 COL 71.57 COLON-ALIGNED
          LABEL "Cont Sec"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fiUnSec AT ROW 3.83 COL 84 COLON-ALIGNED NO-LABEL
     fiStatus AT ROW 4.83 COL 9.14 COLON-ALIGNED
     fiEstoque AT ROW 4.83 COL 51.57 COLON-ALIGNED
     ttApontamento.nr-nota-fis AT ROW 4.83 COL 75 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     ttApontamento.cod-posto AT ROW 5.83 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescPosto AT ROW 5.83 COL 19.57 COLON-ALIGNED HELP
          "Descri‡Æo do Posto" NO-LABEL
     fiTipPosto AT ROW 5.83 COL 54 COLON-ALIGNED NO-LABEL
     ttApontamento.serie AT ROW 5.83 COL 75.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     ttApontamento.ep-codigo-matr AT ROW 6.83 COL 9 COLON-ALIGNED
          LABEL "Motorista":R9
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttApontamento.cod-estabel-matr AT ROW 6.83 COL 14.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttApontamento.cod-matr AT ROW 6.83 COL 19.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescMotorista AT ROW 6.83 COL 30 COLON-ALIGNED HELP
          "Nome do Motorista" NO-LABEL
     ttApontamento.num-docto-orig AT ROW 6.83 COL 75.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.67
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage0
     btMatriz AT ROW 7.79 COL 82
     ttApontamento.cod-ativid AT ROW 7.83 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescAtiv AT ROW 7.83 COL 19.57 COLON-ALIGNED HELP
          "Descri‡Æo da Atividade" NO-LABEL
     fi-cod-unid-negoc AT ROW 7.83 COL 75 COLON-ALIGNED
     ttApontamento.dat-livre-1 AT ROW 9.46 COL 9.29 COLON-ALIGNED
          LABEL "Data":R9
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     ttApontamento.cod-usuar AT ROW 9.46 COL 28.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     ttApontamento.dat-livre-2 AT ROW 9.46 COL 50.72 COLON-ALIGNED
          LABEL "Data":R9
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     ttApontamento.cod-livre-1 AT ROW 9.46 COL 70.14 COLON-ALIGNED
          LABEL "Usu rio":R9
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tg-rastreamento AT ROW 10.67 COL 68.86
     "Altera‡Æo" VIEW-AS TEXT
          SIZE 7.29 BY .54 AT ROW 8.88 COL 46.72
     "Cria‡Æo" VIEW-AS TEXT
          SIZE 5.72 BY .54 AT ROW 8.88 COL 5.29
     IMAGE-1 AT ROW 2.88 COL 49.72
     IMAGE-2 AT ROW 2.88 COL 54.29
     RECT-27 AT ROW 9.08 COL 4.29
     RECT-28 AT ROW 9.08 COL 45.72
     rtParent AT ROW 2.58 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.67
         FONT 1.

DEFINE FRAME fPage2
     brSon2 AT ROW 1 COL 2
     btDetalhe2 AT ROW 5 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 11.75
         SIZE 84.43 BY 5.25
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1 COL 2
     btDetalhe1 AT ROW 5 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 11.75
         SIZE 84.43 BY 5.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttAbast T "?" NO-UNDO movfro mab-item-abastec
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttApontamento T "?" NO-UNDO movfro mab-abastec-lubrific
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttLubrif T "?" NO-UNDO movfro mab-item-lubrific
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMasterDetail ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.67
         WIDTH              = 90
         MAX-HEIGHT         = 26.25
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 26.25
         VIRTUAL-WIDTH      = 146.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMasterDetail 
/* ************************* Included-Libraries *********************** */

{masterdetail/masterdetail.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMasterDetail
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE
       FRAME fPage2:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN ttApontamento.cod-livre-1 IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttApontamento.dat-livre-1 IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttApontamento.dat-livre-2 IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttApontamento.dat-movto IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttApontamento.ep-codigo-matr IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttApontamento.val-hodom-horim-sec IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
ASSIGN 
       brSon1:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       brSon1:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
ASSIGN 
       brSon2:COLUMN-RESIZABLE IN FRAME fPage2       = TRUE
       brSon2:COLUMN-MOVABLE IN FRAME fPage2         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.ttAbast"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttAbast.cod-posto
     _FldNameList[2]   = Temp-Tables.ttAbast.cod-bomba
     _FldNameList[3]   = Temp-Tables.ttAbast.cod-tip-mater
     _FldNameList[4]   > "_<CALC>"
"fnDescMaterial(ttAbast.cod-tip-mater) @ cDescricao" "Descri‡Æo" "x(30)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.ttAbast.it-codigo
     _FldNameList[6]   = Temp-Tables.ttAbast.cod-refer
     _FldNameList[7]   > Temp-Tables.ttAbast.lote
"ttAbast.lote" ? "" "character" ? ? ? ? ? ? no ? no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttAbast.cod-localiz
"ttAbast.cod-localiz" ? "" "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   = Temp-Tables.ttAbast.val-quant
     _FldNameList[10]   = Temp-Tables.ttAbast.val-mater-1
     _FldNameList[11]   > Temp-Tables.ttAbast.cod-cta-ctbl
"ttAbast.cod-cta-ctbl" ? ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "R20" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.ttAbast.cod-ccusto
"ttAbast.cod-ccusto" "Centro de Custo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "R20" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.ttLubrif"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttLubrif.cod-comptmento
     _FldNameList[2]   > "_<CALC>"
"fnDescComp(ttLubrif.cod-comptmento) @ cDescricao2" "Descri‡Æo" "x(30)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.ttLubrif.cod-tip-mater
     _FldNameList[4]   > "_<CALC>"
"fnDescMaterial(ttLubrif.cod-tip-mater) @ cDescricao" "Descri‡Æo" "x(30)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.ttLubrif.it-codigo
     _FldNameList[6]   = Temp-Tables.ttLubrif.cod-refer
     _FldNameList[7]   > Temp-Tables.ttLubrif.lote
"lote" ? "" "character" ? ? ? ? ? ? no ? no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttLubrif.cod-localiz
"cod-localiz" ? "" "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   = Temp-Tables.ttLubrif.cod-evento
     _FldNameList[10]   > "_<CALC>"
"fnDescEvento(ttLubrif.cod-evento) @ cDescricao3" "Descri‡Æo" "x(30)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   = Temp-Tables.ttLubrif.cd-tipo
     _FldNameList[12]   = Temp-Tables.ttLubrif.val-quant
     _FldNameList[13]   = Temp-Tables.ttLubrif.val-mater-1
     _FldNameList[14]   > Temp-Tables.ttLubrif.cod-cta-ctbl
"cod-cta-ctbl" ? ? "character" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.ttLubrif.cod-ccusto
"cod-ccusto" "Centro de Custo" ? "character" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDetalhe1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhe1 wMasterDetail
ON CHOOSE OF btDetalhe1 IN FRAME fPage1 /* Detalhar */
DO:

  assign {&window-name}:sensitive = no.
  /** Detalhe Lubrifica‡Æo **/

  ASSIGN rRowidSon1 = {&ttSon1}.r-rowid.

  run abp/ab0611a.w (input table {&ttParent},
                     input table {&ttSon1},
                     INPUT rRowidSon1).
  assign {&window-name}:sensitive = yes.

  apply "ENTRY":U to btDetalhe1 in frame fPage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDetalhe2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhe2 wMasterDetail
ON CHOOSE OF btDetalhe2 IN FRAME fPage2 /* Detalhar */
DO:

  assign {&window-name}:sensitive = no.
  /** Detalhe Lubrifica‡Æo **/

  ASSIGN rRowidSon2 = {&ttSon2}.r-rowid.

  run abp/ab0611b.w (input table {&ttParent},
                     input table {&ttSon2},
                     INPUT rRowidSon2).
  assign {&window-name}:sensitive = yes.

  apply "ENTRY":U to btDetalhe2 in frame fPage2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMasterDetail
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMasterDetail
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
     RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btIntegraXML
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIntegraXML wMasterDetail
ON CHOOSE OF btIntegraXML IN FRAME fPage0
DO:
    /*--- Seta cursor do mouse para espera ---*/
    session:set-wait-state("GENERAL":U).
    assign {&window-name}:sensitive = no.
    
    /*--- Executa programa de manuten‡Æo de filho ---*/
    run abp/ab0302d.w (input input frame fPage0 ttApontamento.num-docto).
    
    assign {&window-name}:sensitive = yes.
    /*--- Seta cursor do mouse para normal ---*/
    session:set-wait-state("":U).   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMasterDetail
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btMatriz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMatriz wMasterDetail
ON CHOOSE OF btMatriz IN FRAME fPage0
DO:
    /*--- Seta cursor do mouse para espera ---*/
    SESSION:SET-WAIT-STATE("GENERAL":U).

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

    /*--- Executa programa de manuten‡Æo de filho ---*/
    RUN abp/ab0302e.w (INPUT INPUT FRAME fPage0 {&ttParent}.ep-codigo,
                       INPUT INPUT FRAME fPage0 {&ttParent}.cod-eqpto,
                       INPUT INPUT FRAME fPage0 {&ttParent}.dat-movto).

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    /*--- Seta cursor do mouse para normal ---*/
    SESSION:SET-WAIT-STATE("":U).

    APPLY "ENTRY":U TO btMatriz IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMasterDetail
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMasterDetail
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="frzoom/z01fr055.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttApontamento.cod-ativid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApontamento.cod-ativid wMasterDetail
ON LEAVE OF ttApontamento.cod-ativid IN FRAME fPage0 /* Atividade */
DO:
    {method/referenceFields.i
        &HandleDBOLeave="hDBOAtiv"
        &KeyValue1="{&ttParent}.cod-ativid:screen-value in frame fPage0"
        &FieldName1="des-ativid"
        &FieldScreen1="fiDescAtiv"
        &Frame1="fPage0"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttApontamento.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApontamento.cod-eqpto wMasterDetail
ON LEAVE OF ttApontamento.cod-eqpto IN FRAME fPage0 /* cod-eqpto */
DO:
    IF AVAIL ttApontamento THEN DO:
        FOR FIRST mab-eqpto
            WHERE mab-eqpto.cod-eqpto = ttApontamento.cod-eqpto 
            AND   mab-eqpto.ep-codigo = ttApontamento.ep-codigo NO-LOCK:
            ASSIGN tg-rastreamento:CHECKED IN FRAME fPage0 = mab-eqpto.log-livre-1.
        END.
    END.

    run buscaModelo in this-procedure.
    {method/referenceFields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="cCodModelo"
        &FieldName1="des-model"
        &FieldScreen1="fiDescModelo"
        &Frame1="fPage0"
        &FieldName2="un"
        &FieldScreen2="fiUN"
        &Frame2="fPage0"}
        
    FOR FIRST mab-eqpto
        WHERE mab-eqpto.cod-eqpto = ttApontamento.cod-eqpto
        AND   mab-eqpto.ep-codigo = ttApontamento.ep-codigo NO-LOCK:
        IF mab-eqpto.log-cont-sec THEN DO:
            FOR FIRST mab-model
                WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:
                    ASSIGN fiUnSec:SCREEN-VALUE IN FRAME fPage0 = substring(mab-model.cod-livre-1,1,2).
            END.
        END.
        ELSE DO:
            ASSIGN fiUnSec:SCREEN-VALUE IN FRAME fPage0 = "".
        END.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttApontamento.cod-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApontamento.cod-matr wMasterDetail
ON LEAVE OF ttApontamento.cod-matr IN FRAME fPage0 /* cod-matr */
DO:
         
  {method/ReferenceFields.i
      &HandleDBOLeave="hDBOMoto"
      &KeyValue1="input frame fPage0 {&ttParent}.ep-codigo-matr"
      &KeyValue2="input frame fPage0 {&ttParent}.cod-estabel-matr"
      &KeyValue3="input frame fPage0 {&ttParent}.cod-matr"
      &FieldName1="nom-motoris"
      &FieldScreen1="fiDescMotorista"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttApontamento.cod-posto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApontamento.cod-posto wMasterDetail
ON LEAVE OF ttApontamento.cod-posto IN FRAME fPage0 /* Posto */
DO:
   
    ASSIGN fiTipPosto = "".

    FOR FIRST mab-posto 
        WHERE mab-posto.cod-posto = {&ttParent}.cod-posto:screen-value in frame fPage0 NO-LOCK:
        IF mab-posto.idi-posto = 1 THEN DO:
           
            {utp/ut-liter.i Pr¢prio *}
            ASSIGN fiTipPosto = RETURN-VALUE.
           
        END.

        ELSE DO:
            {utp/ut-liter.i Terceiro *}
            ASSIGN fiTipPosto = RETURN-VALUE.
           
        END.
    END.

    DISP fiTipPosto WITH FRAME fPage0.

    {method/referenceFields.i
        &HandleDBOLeave="hDBOPosto"
        &KeyValue1="{&ttParent}.cod-posto:screen-value in frame fPage0"
        &FieldName1="des-posto"
        &FieldScreen1="fiDescPosto"
        &Frame1="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMasterDetail 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) finaliza‡Æo do programa
------------------------------------------------------------------------------*/
/** Equipamento **/
if valid-handle(hDBOEqpto) then
    run Destroy in hDBOEqpto.
/** Modelo **/
if valid-handle(hDBOModelo) then
    run Destroy in hDBOModelo.
/** Posto **/
if valid-handle(hDBOPosto) then
    run Destroy in hDBOPosto.
/** Atividade **/
if valid-handle(hDBOAtiv) THEN
    run Destroy in hDBOAtiv.
/** Motorista **/
if valid-handle(hDBOMoto) then
    run Destroy in hDBOMoto.
/** Historico **/
IF VALID-HANDLE(hDBOHistor) THEN
    RUN Destroy IN hDBOHistor.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     afterDisplayFields
  Parameters:  <none>
  Notes:       Override (ap¢s) mostrar campos em tela
------------------------------------------------------------------------------*/
/** Mostra Status da Consistˆncia do Documento em tela **/
if avail {&ttParent} THEN DO:
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then

        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao001 = {frinc/i00fr055.i 04 {&ttparent}.idi-consist}.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                            INPUT "*",
                            INPUT "").
        ASSIGN  fiStatus:screen-value in frame fPage0 = RETURN-VALUE.
        ASSIGN cAuxTraducao001 = {frinc/i01fr055.i 04 {&ttparent}.idi-integr}.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                            INPUT "*",
                            INPUT "").
        ASSIGN  fiEstoque:screen-value in frame fPage0 = RETURN-VALUE.
    &else
        ASSIGN  fiStatus:screen-value in frame fPage0 = {frinc/i00fr055.i 04 {&ttparent}.idi-consist}
               fiEstoque:screen-value in frame fPage0 = {frinc/i01fr055.i 04 {&ttparent}.idi-integr}.
    &endif
END.
else 
    assign fiStatus:screen-value in frame fPage0 = ""
           fiEstoque:SCREEN-VALUE IN FRAME fPage0 = "".

apply "LEAVE":U to {&ttParent}.cod-eqpto  in frame fPage0.
apply "LEAVE":U to {&ttParent}.cod-ativid in frame fPage0.
apply "LEAVE":U to {&ttParent}.cod-matr   in frame fPage0.
apply "LEAVE":U to {&ttParent}.cod-posto  in frame fPage0.

/** Habilita / Desabilita botäes **/
run piBotoes in this-procedure.

&IF DEFINED(bf_mnt_ems206b) &THEN
    IF l-usa-unid-negoc THEN DO:
        ASSIGN fi-cod-unid-negoc:SCREEN-VALUE IN FRAME fPage0 = {&ttParent}.cod-unid-negoc.

        /** Habilita/Desabilita botao Matriz de Unidade Negocio **/
        RUN piValidaMatriz IN THIS-PROCEDURE.
    END.
&ENDIF

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{utp/ut-liter.i Equipamento *}
ASSIGN {&ttParent}.ep-codigo:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i Data *}
ASSIGN ttApontamento.dat-livre-1:LABEL IN FRAME fPage0 = RETURN-VALUE.
ASSIGN ttApontamento.dat-livre-2:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i Usu rio *}
ASSIGN ttApontamento.cod-livre-1:LABEL IN FRAME fPage0 = RETURN-VALUE.

/** Verifica integra‡Æo com rastreamento **/
for first mab-param-integr
    where mab-param-integr.cdn-param = 10 no-lock:
    {utp/ut-liter.i Sim}
    if entry(4,mab-param-integr.des-valor) = return-value then do:
        assign btIntegraXML:visible in frame fPage0    = yes
               btIntegraXML:sensitive in frame fPage0  = yes
               tg-rastreamento:visible in frame fPage0 = yes.
    end.
    else do:
        assign btIntegraXML:visible in frame fPage0    = no
               btIntegraXML:sensitive in frame fPage0  = NO
               tg-rastreamento:visible in frame fPage0 = NO.
    end.
end.

if not avail mab-param-integr then do:
    assign btIntegraXML:visible in frame fPage0   = no
           btIntegraXML:sensitive in frame fPage0  = NO
           tg-rastreamento:visible in frame fPage0 = NO.
end.

ASSIGN btMatriz:SENSITIVE        IN FRAME fPage0 = l-usa-unid-negoc
       btMatriz:VISIBLE          IN FRAME fPage0 = l-usa-unid-negoc
       fi-cod-unid-negoc:VISIBLE IN FRAME fPage0 = l-usa-unid-negoc.

/** Habilita/Desabilita botao Matriz de Unidade Negocio **/
IF l-usa-unid-negoc THEN
    RUN piValidaMatriz IN THIS-PROCEDURE.
ELSE
    ASSIGN btMatriz:TOOLTIP IN FRAME fPage0 = "":U.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaModelo wMasterDetail 
PROCEDURE buscaModelo :
/*------------------------------------------------------------------------------
  Purpose:     buscaModelo
  Parameters:  <none>
  Notes:       Busca o c¢digo do modelo no equipamento
------------------------------------------------------------------------------*/
{method/referenceFields.i
    &HandleDBOLeave="hDBOEqpto"
    &KeyValue1="input frame fPage0 {&ttParent}.ep-codigo"
    &KeyValue2="input frame fPage0 {&ttParent}.cod-eqpto"
    &FieldName1="cod-model"
    &Variable1="cCodModelo"}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY
         LABEL "&Cancelar"
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE BUTTON btGoToOK AUTO-GO
         LABEL "&OK"
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE
         SIZE 58 BY 1.42
         BGCOLOR 7.

    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

    DEFINE VARIABLE iDocumento LIKE {&ttParent}.num-docto
        VIEW-AS FILL-IN
        SIZE 12 BY .88 NO-UNDO.

    DEFINE FRAME fGoToRecord
        iDocumento       AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK         AT ROW 2.63 COL 2.14
        btGoToCancel     AT ROW 2.63 COL 13
        rtGoToButton     AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE
             THREE-D SCROLLABLE TITLE "V  Para Apontamento" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:HANDLE).

    {utp/ut-liter.i "V  Para Apontamento"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN iDocumento.

        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT iDocumento).
        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-liter.i "Apontamento Abastecimento Lubrifica‡Æo"}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT return-value).

            RETURN NO-APPLY.
        END.

        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).

        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.

    ENABLE iDocumento btGoToOK btGoToCancel
        WITH FRAME fGoToRecord.

    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "frbo/bofr055.p":U THEN DO:
        run frbo/bofr055.p persistent set {&hDBOParent}.
    END.
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "frbo/bofr057.p":U THEN DO:
        run frbo/bofr057.p persistent set {&hDBOSon1}.
    END.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon2}) OR
       {&hDBOSon2}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon2}:FILE-NAME <> "frbo/bofr058.p":U THEN DO:
        run frbo/bofr058.p persistent set {&hDBOSon2}.
    END.

    /*--- DBO Equipamento ---*/
    IF NOT VALID-HANDLE(hDBOEqpto) OR
       hDBOEqpto:TYPE <> "PROCEDURE":U OR
       hDBOEqpto:FILE-NAME <> "frbo/bofr007.p":U THEN DO:
        run frbo/bofr007.p persistent set  hDBOEqpto.
    END.
    
    RUN openQueryStatic IN hDBOEqpto (INPUT "Main":U) NO-ERROR.
    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo/bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.

    END.

    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

    /*--- DBO Posto  ---*/
    IF NOT VALID-HANDLE(hDBOPosto) OR
       hDBOPosto:TYPE <> "PROCEDURE":U OR
       hDBOPosto:FILE-NAME <> "frbo/bofr021.p":U THEN DO:
        run frbo/bofr021.p persistent set  hDBOPosto.

    END.

    RUN openQueryStatic IN hDBOPosto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Atividade  ---*/
    IF NOT VALID-HANDLE(hDBOAtiv) OR
       hDBOAtiv:TYPE <> "PROCEDURE":U OR
       hDBOAtiv:FILE-NAME <> "frbo/bofr001.p":U THEN DO:
        run frbo/bofr001.p persistent set  hDBOAtiv.

    END.

    RUN openQueryStatic IN hDBOAtiv (INPUT "Main":U) NO-ERROR.

    /*--- DBO Motorista  ---*/
    IF NOT VALID-HANDLE(hDBOMoto) OR
       hDBOMoto:TYPE <> "PROCEDURE":U OR
       hDBOMoto:FILE-NAME <> "frbo/bofr017.p":U THEN DO:
        run frbo/bofr017.p persistent set  hDBOMoto.

    END.

    RUN openQueryStatic IN hDBOMoto (INPUT "Main":U) NO-ERROR.
   
    /*--- DBO Historico  ---*/
    IF NOT VALID-HANDLE(hDBOHistor) OR
       hDBOHistor:TYPE <> "PROCEDURE":U OR
       hDBOHistor:FILE-NAME <> "frbo/bofr013.p":U THEN DO:
        run frbo/bofr013.p persistent set  hDBOHistor.

    END.

    RUN openQueryStatic IN hDBOHistor (INPUT "Main":U) NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    {masterdetail/openqueriesson.i &Parent="Apontamento"
                                   &Query="Apontamento"
                                   &PageNumber="1"}
    
    {masterdetail/openqueriesson.i &Parent="Apontamento"
                                   &Query="Apontamento"
                                   &PageNumber="2"}
                                   
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBotoes wMasterDetail 
PROCEDURE piBotoes :
/*------------------------------------------------------------------------------
  Purpose:     piBotoes
  Parameters:  <none>
  Notes:       Habilita / Desabilita botäes
------------------------------------------------------------------------------*/

assign btDetalhe1:sensitive in frame fPage1 = if avail {&ttSon1} 
                                              then yes
                                              else no
       btDetalhe2:sensitive in frame fPage2 = if avail {&ttSon2} 
                                              then yes
                                              else no.
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaMatriz wMasterDetail 
PROCEDURE piValidaMatriz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lTemMatriz AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE cUnidNegoc AS CHARACTER FORMAT "x(3)" NO-UNDO.

    &IF DEFINED(bf_mnt_ems206b) &THEN    
        IF AVAIL {&ttParent} THEN DO:
            RUN piRetornaUnidNegoc IN hDBOHistor (INPUT {&ttParent}.ep-codigo,
                                                  INPUT {&ttParent}.cod-eqpto,
                                                  INPUT {&ttParent}.dat-movto,
                                                  OUTPUT cUnidNegoc,
                                                  OUTPUT lTemMatriz,
                                                  OUTPUT TABLE tt-unid-negoc-histor).

            IF lTemMatriz AND cUnidNegoc = INPUT FRAME fPage0 fi-cod-unid-negoc THEN
                ASSIGN btMatriz:SENSITIVE IN FRAME fPage0 = YES.
            ELSE
                ASSIGN btMatriz:SENSITIVE IN FRAME fPage0 = NO.
        END.
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescComp wMasterDetail 
FUNCTION fnDescComp RETURNS CHARACTER
  ( pComp as char ) :
/*------------------------------------------------------------------------------
  Purpose:  fnDescComp
    Notes:  Busca descri‡Æo do campo Compartimento
------------------------------------------------------------------------------*/

DEFINE VARIABLE cDescComp AS CHARACTER format "x(30)" NO-UNDO.

define buffer bfComp for mab-comptmento.

for first bfComp fields(des-comptmento)
    where bfComp.cod-comptmento = pComp no-lock:
    assign cDescComp = bfComp.des-comptmento.
end.
  RETURN cDescComp.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescEvento wMasterDetail 
FUNCTION fnDescEvento RETURNS CHARACTER
  ( pEvento as char ) :
/*------------------------------------------------------------------------------
  Purpose:  fnDescEvento
    Notes:  Busca descri‡Æo do campo Evento
------------------------------------------------------------------------------*/

DEFINE VARIABLE cDescEvento AS CHARACTER format "x(30)" NO-UNDO.

define buffer bfEvento for mab-event.

for first bfEvento fields(des-evento)
    where bfEvento.cod-evento = pEvento no-lock:
    assign cDescEvento = bfEvento.des-evento.
end.
  RETURN cDescEvento.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescMaterial wMasterDetail 
FUNCTION fnDescMaterial RETURNS CHARACTER
  ( pMaterial as char ) :
/*------------------------------------------------------------------------------
  Purpose:  fnDescMaterial
    Notes:  Busca descri‡Æo do campo tipo de material
------------------------------------------------------------------------------*/

DEFINE VARIABLE cDescMat AS CHARACTER format "x(30)" NO-UNDO.

define buffer bfMat for mab-tip-mater.

for first bfMat fields(des-tip-mater)
    where bfMat.cod-tip-mater = pMaterial no-lock:
    assign cDescMat = bfMat.des-tip-mater.
end.

  RETURN cDescMat.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

