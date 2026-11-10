&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
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
{include/i-prgvrs.i IM0101B 2.00.00.012 } /*** "010012" 08/12/2025 14:50:49  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0101b MIM}
&ENDIF

/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{cxbo/bocx220h.i tt-selecao-embarque}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM0101B
&GLOBAL-DEFINE Version        2.00.00.012

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Embarques

&GLOBAL-DEFINE ttParent         tt-embarque-imp
&GLOBAL-DEFINE hDBOParent       h-bocx220
&GLOBAL-DEFINE DBOParentTable   embarque-imp
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           tt-selecao-embarque
&GLOBAL-DEFINE hDBOSon1         h-bocx220h
&GLOBAL-DEFINE DBOSon1Table     tt-selecao-embarque
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE page0Fields      

&GLOBAL-DEFINE page1Browse      brSon1 

&GLOBAL-DEFINE NumRowsReturned  40

&GLOBAL-DEFINE MOUSE-SELECT-DBLCLICK1 yes
&GLOBAL-DEFINE VALUE-CHANGED1   yes

&GLOBAL-DEFINE DBOVersion       1.1

{cdp/cdcfgmat.i}
{cdp/cdcfgcex.i}

/* Parameters Definitions ---                                           */
&IF "{&mguni_version}" >= "2.071" &THEN
define input         parameter c-cod-estabel            LIKE estabelec.cod-estabel      no-undo.     
&ELSE
define input         parameter c-cod-estabel            as char format "x(03)"      no-undo.     
&ENDIF
DEFINE INPUT         PARAMETER i-tipo-geracao           AS INT                      NO-UNDO.
define input-output  parameter c-embarque-ini           as char format "x(12)"      no-undo. 
define input-output  parameter c-embarque-fim           as char format "x(12)"      no-undo. 
define input-output  parameter i-num-di-ems-ini         as int  format ">>>>>>>>9"  no-undo.    
define input-output  parameter i-num-di-ems-fim         as int  format ">>>>>>>>9"  NO-UNDO.  
define input-output  parameter l-desembarque-parcial    as log                      no-undo. 
define input-output  parameter dt-nacionalizacao-ini    as date format "99/99/9999" no-undo. 
define input-output  parameter dt-nacionalizacao-fim    as date format "99/99/9999" no-undo. 
define input-output  parameter c-container-ini          as char format "x(20)"      no-undo. 
define input-output  parameter c-container-fim          as char format "x(20)"      no-undo. 
define input-output  parameter c-processo-ini           as char format "x(12)"      no-undo. 
define input-output  parameter c-processo-fim           as char format "x(12)"      no-undo. 
define input-output  parameter c-declaracao-imp-ini     as char format "x(20)"      no-undo. 
define input-output  parameter c-declaracao-imp-fim     as char format "x(20)"      no-undo. 
define input-output  parameter dt-di-ini                as date format "99/99/9999" no-undo. 
define input-output  parameter dt-di-fim                as date format "99/99/9999" no-undo. 
define input-output  parameter i-itinerario-ini         as int  format ">>,>>9"     no-undo. 
define input-output  parameter i-itinerario-fim         as int  format ">>,>>9"     no-undo. 
define input-output  parameter i-exportador-ini         as int  format ">>>>>>>>9"  no-undo. 
define input-output  parameter i-exportador-fim         as int  format ">>>>>>>>9"  no-undo. 
define input-output  parameter i-localizacao            as int  format ">>,>>9"     no-undo. 
define input-output  parameter dt-chegada-ini           as date format "99/99/9999" no-undo. 
define input-output  parameter dt-chegada-fim           as date format "99/99/9999" no-undo. 
define input-output  parameter c-veiculo-transp-ini     as char format "x(20)"      no-undo. 
define input-output  parameter c-veiculo-transp-fim     as char format "x(20)"      no-undo. 
&if "{&bf_cex_versao_ems}" >= "2.062" &then
    &if "{&bf_mat_versao_ems}" >= "2.04" &then
        define input-output  parameter c-nr-conhecto-master-ini as char format "x(25)"  no-undo. 
        define input-output  parameter c-nr-conhecto-master-fim as char format "x(25)"  no-undo. 
        define input-output  parameter c-nr-conhecto-house-ini  as char format "x(25)"  no-undo. 
        define input-output  parameter c-nr-conhecto-house-fim  as char format "x(25)"  no-undo. 
    &endif
&else
    &if '{&bf_mat_versao_ems}' >= '2.05' &then
        define input-output  parameter c-nr-conhecto-master-ini as char format "x(25)"  no-undo. 
        define input-output  parameter c-nr-conhecto-master-fim as char format "x(25)"  no-undo. 
        define input-output  parameter c-nr-conhecto-house-ini  as char format "x(25)"  no-undo. 
        define input-output  parameter c-nr-conhecto-house-fim  as char format "x(25)"  no-undo. 
    &else
        define input-output  parameter c-nr-conhecto-ini        as char format "x(18)"  no-undo. 
        define input-output  parameter c-nr-conhecto-fim        as char format "x(18)"  no-undo.  
    &endif
&endif
define input-output parameter table for tt-selecao-embarque.
DEFINE INPUT        PARAMETER i-num-di-ems-aux              LIKE decla-import.num-di-ems NO-UNDO.
define output       parameter l-ok                          as log                  no-undo.


/* Global Variable Definitions ---                                       */
define new global shared variable gr-historico-embarque as rowid                    no-undo.
define new global shared variable gr-embarque-imp       as rowid                    no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE  h-tt-selecao-embarque-im0101b  AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
define variable l-label1                                as log                      no-undo.
define variable l-label2                                as log                      no-undo.
/* Local Variable Definitions (DBOs Handles) ---                        */
define variable {&hDBOParent} as handle no-undo.
define variable {&hDBOSon1}   as handle no-undo.

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
&Scoped-define INTERNAL-TABLES tt-selecao-embarque

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-selecao-embarque.embarque tt-selecao-embarque.declaracao-import tt-selecao-embarque.num-di-ems tt-selecao-embarque.dt-nacionalizacao tt-selecao-embarque.cod-exportador tt-selecao-embarque.cod-itiner &if "{&bf_cex_versao_ems}" >= "2.062" &then &if "{&bf_mat_versao_ems}" >= "2.04" &then tt-selecao-embarque.cod-conhecto-master tt-selecao-embarque.cod-conhecto-house &endif &else &if '{&bf_mat_versao_ems}' >= '2.05' &then tt-selecao-embarque.cod-conhecto-master tt-selecao-embarque.cod-conhecto-house &else tt-selecao-embarque.nr-conhecimento &endif &endif tt-selecao-embarque.embarque-original   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define SELF-NAME brSon1
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-selecao-embarque
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME} FOR EACH tt-selecao-embarque.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-selecao-embarque
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-selecao-embarque


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-selecao btQueryJoins btReportsJoins ~
btExit btHelp rtToolBar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

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
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
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
DEFINE BUTTON bt-selecao 
     IMAGE-UP FILE "IMAGE~\im-ran":U
     LABEL "Sel" 
     SIZE 4 BY 1.25 TOOLTIP "Faixa de Embarques a Selecionar".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image~\im-exi":U
     IMAGE-INSENSITIVE FILE "image~\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image~\im-hel":U
     IMAGE-INSENSITIVE FILE "image~\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image~\im-joi":U
     IMAGE-INSENSITIVE FILE "image~\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image~\im-pri":U
     IMAGE-INSENSITIVE FILE "image~\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-desmarca-todos 
     LABEL "&Desmarca Todos" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-detalhes 
     LABEL "De&talhes" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-marca-desmarca 
     LABEL "Ma&rca" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-marca-todos 
     LABEL "&Marca Todos" 
     SIZE 12 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-selecao-embarque SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 DISPLAY
      tt-selecao-embarque.embarque           
 tt-selecao-embarque.declaracao-import COLUMN-LABEL "DI/DUIMP Siscomex":U 
 tt-selecao-embarque.num-di-ems COLUMN-LABEL "DI/DUIMP EMS":U
 tt-selecao-embarque.dt-nacionalizacao  
 tt-selecao-embarque.cod-exportador     
 tt-selecao-embarque.cod-itiner         
 &if "{&bf_cex_versao_ems}" >= "2.062" &then
    &if "{&bf_mat_versao_ems}" >= "2.04" &then
        tt-selecao-embarque.cod-conhecto-master
        tt-selecao-embarque.cod-conhecto-house 
    &endif
 &else
    &if '{&bf_mat_versao_ems}' >= '2.05' &then
        tt-selecao-embarque.cod-conhecto-master
        tt-selecao-embarque.cod-conhecto-house 
    &else
        tt-selecao-embarque.nr-conhecimento    
    &endif
 &endif
 tt-selecao-embarque.embarque-original
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 82 BY 11.08
         FONT 2 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     bt-selecao AT ROW 1.13 COL 70.86 HELP
          "Faixa de Embarques a Selecionar"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 17.04
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     bt-marca-desmarca AT ROW 12.25 COL 2
     bt-marca-todos AT ROW 12.25 COL 14
     bt-desmarca-todos AT ROW 12.25 COL 26
     bt-detalhes AT ROW 12.25 COL 38
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.25
         SIZE 84.43 BY 12.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-embarque-imp T "?" NO-UNDO mgcex embarque-imp
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
         HEIGHT             = 17.04
         WIDTH              = 90.14
         MAX-HEIGHT         = 27.83
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.83
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
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME L-To-R,COLUMNS                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
ASSIGN 
       brSon1:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       brSon1:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-selecao-embarque.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brSon1 */
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


&Scoped-define BROWSE-NAME brSon1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON MOUSE-SELECT-DBLCLICK OF brSon1 IN FRAME fPage1
DO:
    {masterdetail/dblclick.i &PageNumber="1"}
    apply "choose":U  to bt-marca-desmarca in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON ROW-DISPLAY OF brSon1 IN FRAME fPage1
DO:

    if  avail tt-selecao-embarque then do:
        if  tt-selecao-embarque.marca = "X":U then 
            assign tt-selecao-embarque.embarque:fgcolor             in browse brSon1 = 9
                   tt-selecao-embarque.declaracao-import:fgcolor    in browse brSon1 = 9
                   tt-selecao-embarque.num-di-ems:FGCOLOR           in browse brSon1 = 9
                   tt-selecao-embarque.dt-nacionalizacao:fgcolor    in browse brSon1 = 9
                   tt-selecao-embarque.cod-exportador:fgcolor       in browse brSon1 = 9
                   tt-selecao-embarque.cod-itiner:fgcolor           in browse brSon1 = 9
                   tt-selecao-embarque.embarque-original:fgcolor    in browse brSon1 = 9
                   tt-selecao-embarque.embarque:font                in browse brSon1 = 6
                   tt-selecao-embarque.declaracao-import:font       in browse brSon1 = 6
                   tt-selecao-embarque.num-di-ems:font              in browse brSon1 = 6
                   tt-selecao-embarque.dt-nacionalizacao:font       in browse brSon1 = 6
                   tt-selecao-embarque.cod-exportador:font          in browse brSon1 = 6
                   tt-selecao-embarque.cod-itiner:font              in browse brSon1 = 6
                   &if "{&bf_cex_versao_ems}" >= "2.062" &then
                       &if "{&bf_mat_versao_ems}" >= "2.04" &then
                           tt-selecao-embarque.cod-conhecto-master:font     in browse brSon1 = 6
                           tt-selecao-embarque.cod-conhecto-house:font      in browse brSon1 = 6
                           tt-selecao-embarque.cod-conhecto-master:fgcolor  in browse brSon1 = 9
                           tt-selecao-embarque.cod-conhecto-house:fgcolor   in browse brSon1 = 9
                       &endif
                   &else
                       &if '{&bf_mat_versao_ems}' >= '2.05' &then
                           tt-selecao-embarque.cod-conhecto-master:font     in browse brSon1 = 6
                           tt-selecao-embarque.cod-conhecto-house:font      in browse brSon1 = 6
                           tt-selecao-embarque.cod-conhecto-master:fgcolor  in browse brSon1 = 9
                           tt-selecao-embarque.cod-conhecto-house:fgcolor   in browse brSon1 = 9
                       &else
                           tt-selecao-embarque.nr-conhecimento:fgcolor      in browse brSon1 = 9
                           tt-selecao-embarque.nr-conhecimento:font         in browse brSon1 = 6
                       &endif
                   &endif
                   tt-selecao-embarque.embarque-original:font       in browse brSon1 = 6.
        else 
            assign tt-selecao-embarque.embarque:fgcolor             in browse brSon1 = ?
                   tt-selecao-embarque.declaracao-import:fgcolor    in browse brSon1 = ?
                   tt-selecao-embarque.num-di-ems:fgcolor           in browse brSon1 = ?
                   tt-selecao-embarque.dt-nacionalizacao:fgcolor    in browse brSon1 = ?
                   tt-selecao-embarque.cod-exportador:fgcolor       in browse brSon1 = ?
                   tt-selecao-embarque.cod-itiner:fgcolor           in browse brSon1 = ?
                   tt-selecao-embarque.embarque-original:fgcolor    in browse brSon1 = ?
                   tt-selecao-embarque.embarque:font                in browse brSon1 = ?
                   tt-selecao-embarque.declaracao-import:font       in browse brSon1 = ?
                   tt-selecao-embarque.num-di-ems:font              in browse brSon1 = ?
                   tt-selecao-embarque.dt-nacionalizacao:font       in browse brSon1 = ?
                   tt-selecao-embarque.cod-exportador:font          in browse brSon1 = ?
                   tt-selecao-embarque.cod-itiner:font              in browse brSon1 = ?
                   &if "{&bf_cex_versao_ems}" >= "2.062" &then
                       &if "{&bf_mat_versao_ems}" >= "2.04" &then
                           tt-selecao-embarque.cod-conhecto-master:font     in browse brSon1 = ?
                           tt-selecao-embarque.cod-conhecto-house:font      in browse brSon1 = ?
                           tt-selecao-embarque.cod-conhecto-master:fgcolor  in browse brSon1 = ?
                           tt-selecao-embarque.cod-conhecto-house:fgcolor   in browse brSon1 = ?
                           tt-selecao-embarque.cod-conhecto-house:fgcolor   in browse brSon1 = 9
                       &endif
                   &else
                       &if '{&bf_mat_versao_ems}' >= '2.05' &then
                           tt-selecao-embarque.cod-conhecto-master:font     in browse brSon1 = ?
                           tt-selecao-embarque.cod-conhecto-house:font      in browse brSon1 = ?
                           tt-selecao-embarque.cod-conhecto-master:fgcolor  in browse brSon1 = ?
                           tt-selecao-embarque.cod-conhecto-house:fgcolor   in browse brSon1 = ?
                       &else
                           tt-selecao-embarque.nr-conhecimento:fgcolor      in browse brSon1 = ?
                           tt-selecao-embarque.nr-conhecimento:font         in browse brSon1 = ?
                       &endif
                   &endif
                   tt-selecao-embarque.embarque-original:font       in browse brSon1 = ? .
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON VALUE-CHANGED OF brSon1 IN FRAME fPage1
DO:
    {masterdetail/valuechanged.i &PageNumber="1"}
    define variable i-cont as int no-undo.
    
    assign l-label1 = no
           l-label2 = no.
    if  brSon1:num-selected-rows in frame fPage1 > 0 then do: 
        do  i-cont = 1 to brSon1:num-selected-rows in frame fPage1:
            if  brSon1:fetch-selected-row(i-cont) in frame fPage1 then do:

                get current brSon1.
                if  avail tt-selecao-embarque then do:
                    if  tt-selecao-embarque.marca = "" then
                        assign l-label1 = yes.
                    else
                        assign l-label2 = yes.
                end.

            end.
        end.
        if  l-label1 and l-label2 then 
            assign bt-marca-desmarca:label     in frame fPage1 = "Ma&rca"
                   bt-marca-desmarca:sensitive in frame fPage1 = no.
        else if l-label1 then
            assign bt-marca-desmarca:label     in frame fPage1 = "Ma&rca"
                   bt-marca-desmarca:sensitive in frame fPage1 = yes.
           else if l-label2 then
               assign bt-marca-desmarca:label     in frame fPage1 = "D&esmarca"
                      bt-marca-desmarca:sensitive in frame fPage1 = yes.
    end.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desmarca-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desmarca-todos wMasterDetail
ON CHOOSE OF bt-desmarca-todos IN FRAME fPage1 /* Desmarca Todos */
DO:
    for each tt-selecao-embarque:
        assign tt-selecao-embarque.marca = "".
    end.

    open query brSon1 for each tt-selecao-embarque.

    browse brSon1:select-row(1) no-error.

    apply "value-changed":U to brSon1 in frame fPage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-detalhes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-detalhes wMasterDetail
ON CHOOSE OF bt-detalhes IN FRAME fPage1 /* Detalhes */
DO:
    def var h-bocx230 as handle no-undo.
    def var h-im0555  as handle no-undo.

    if  brSon1:num-selected-rows > 0 then do: 
        get current brSon1.
        if  not valid-handle (h-bocx230) then 
            run cxbo/bocx230.p persistent set h-bocx230.
        run openQuery in h-bocx230 (input 1).

        run trazrowidhistemb in h-bocx230 (input  tt-selecao-embarque.cod-estabel,
                                           input  tt-selecao-embarque.embarque,
                                           input  tt-selecao-embarque.cod-itiner,
                                           output gr-historico-embarque).
        run rowidembarque    in h-bocx220 (input tt-selecao-embarque.cod-estabel,
                                           input tt-selecao-embarque.embarque,
                                           output gr-embarque-imp).

        if  not valid-handle (h-im0555) then
            run imp/im0555.w persistent set h-im0555.
        run initializeInterface in h-im0555.
        wait-for close of h-im0555.
        if  valid-handle (h-im0555) then do:
            delete procedure h-im0555.
            assign h-im0555 = ?.
        end.
        if  valid-handle (h-bocx230) then do:
            delete procedure h-bocx230.
            assign h-bocx230 = ?.
        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca-desmarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca-desmarca wMasterDetail
ON CHOOSE OF bt-marca-desmarca IN FRAME fPage1 /* Marca */
DO:
    def var i-cont as int no-undo.

    if  brSon1:num-selected-rows > 0 then do: 
        do  i-cont = 1 to brSon1:num-selected-rows in frame fPage1:
            if  brSon1:fetch-selected-row(i-cont) in frame fPage1 then do:
                get current brSon1.
                if  tt-selecao-embarque.marca = "" then
                    assign tt-selecao-embarque.marca = "X":U.
                else
                    assign tt-selecao-embarque.marca = "":U.
                brSon1:refresh() in frame fPage1.
            end.
        end.
    end.

    apply "value-changed":U to brSon1 in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca-todos wMasterDetail
ON CHOOSE OF bt-marca-todos IN FRAME fPage1 /* Marca Todos */
DO:
    for each tt-selecao-embarque:
        assign tt-selecao-embarque.marca = "X".
    end.

    open query brSon1 for each tt-selecao-embarque.

    browse brSon1:select-row(1) no-error.

    apply "value-changed":U to brSon1 in frame fPage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME bt-selecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-selecao wMasterDetail
ON CHOOSE OF bt-selecao IN FRAME fPage0 /* Sel */
DO:

    run imp/im0101b1.w (input        c-cod-estabel,           
                        INPUT        i-tipo-geracao,
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
                        input table tt-selecao-embarque,
                        INPUT i-num-di-ems-aux,
                        output l-ok).


    if  l-ok then do:
        for each  tt-selecao-embarque
            where tt-selecao-embarque.marca = "X":
            assign tt-selecao-embarque.marca = "".
        end.

        run openQueriesSon in this-procedure.

        IF i-tipo-geracao = 2 THEN do: /*Declara‡Æo Importa‡Æo*/
            for each  tt-selecao-embarque:
                assign tt-selecao-embarque.marca = "X".
            end.
            open query brSon1 for each tt-selecao-embarque.
        END.
        browse brSon1:select-row(1) no-error.
    end.

    apply "value-changed":U to brSon1 in frame fPage1.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    apply "CLOSE":U to this-procedure.
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {utp/ut-liter.i Ma&rca c}
    assign bt-marca-desmarca:label in frame fPage1 = trim(return-value).
    {utp/ut-liter.i "&Marca_Todos" c}
    assign bt-marca-todos:label in frame fPage1 = trim(return-value).
    {utp/ut-liter.i "&Desmarca_Todos" c}
    assign bt-desmarca-todos:label in frame fPage1 = trim(return-value).
    {utp/ut-liter.i De&talhes c}
    assign bt-detalhes:label in frame fPage1 = trim(return-value).
    
    assign bt-selecao:sensitive        in frame fPage0 = yes
           bt-marca-desmarca:sensitive in frame fPage1 = yes
           bt-marca-todos:sensitive    in frame fPage1 = yes
           bt-desmarca-todos:sensitive in frame fPage1 = yes
           bt-detalhes:sensitive       in frame fPage1 = yes.

    if  can-find (first  tt-selecao-embarque
                   where tt-selecao-embarque.marca = "X") then 
        open query brSon1 for each tt-selecao-embarque.
    else do:
        view wMasterDetail.
        apply "CHOOSE":U to bt-selecao in frame fPage0.
    end.

    /* -----   Inclus’o Chamada UPC   ----- */
    IF c-nom-prog-upc-mg97 <> "":U AND c-nom-prog-upc-mg97 <> ? THEN 
      ASSIGN h-tt-selecao-embarque-im0101b = TEMP-TABLE tt-selecao-embarque:HANDLE.
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
    
    if  not valid-handle ({&hDBOParent}) then
        run cxbo/bocx220.p persistent set {&hDBOParent}.
    run openQuery in h-bocx220 (input 1).
    if  not valid-handle({&hDBOSon1}) then  
        run cxbo/bocx220h.p persistent set {&hDBOSon1}.

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

    if  l-ok
    and not can-find (first  tt-selecao-embarque
                       where tt-selecao-embarque.marca = "X":U) then do:

        session:set-wait-state("GENERAL":U).
        empty temp-table tt-selecao-embarque.

        RUN pi-set-mostra-embarq-sem-despesa IN h-bocx220h(INPUT YES).
        
        run carregaTtSelecaoEmbarque in h-bocx220h (input c-cod-estabel,           
                                                    INPUT i-tipo-geracao,
                                                    input c-embarque-ini,          
                                                    input c-embarque-fim,          
                                                    INPUT i-num-di-ems-ini,
                                                    INPUT i-num-di-ems-fim,
                                                    input l-desembarque-parcial,   
                                                    input dt-nacionalizacao-ini,   
                                                    input dt-nacionalizacao-fim,   
                                                    input c-container-ini,         
                                                    input c-container-fim,         
                                                    input c-processo-ini,          
                                                    input c-processo-fim,          
                                                    input c-declaracao-imp-ini,    
                                                    input c-declaracao-imp-fim,    
                                                    input dt-di-ini,               
                                                    input dt-di-fim,               
                                                    input i-itinerario-ini,        
                                                    input i-itinerario-fim,        
                                                    input i-exportador-ini,        
                                                    input i-exportador-fim,        
                                                    input i-localizacao,           
                                                    input dt-chegada-ini,          
                                                    input dt-chegada-fim,          
                                                    input c-veiculo-transp-ini,    
                                                    input c-veiculo-transp-fim,    
                                            &if "{&bf_cex_versao_ems}" >= "2.062" &then
                                                &if "{&bf_mat_versao_ems}" >= "2.04" &then
                                                    input c-nr-conhecto-master-ini,
                                                    input c-nr-conhecto-master-fim,
                                                    input c-nr-conhecto-house-ini, 
                                                    input c-nr-conhecto-house-fim,
                                            &endif
                                            &else
                                                &if '{&bf_mat_versao_ems}' >= '2.05' &then
                                                    input c-nr-conhecto-master-ini,
                                                    input c-nr-conhecto-master-fim,
                                                    input c-nr-conhecto-house-ini, 
                                                    input c-nr-conhecto-house-fim,
                                                &else
                                                    input c-nr-conhecto-ini,
                                                    input c-nr-conhecto-fim,
                                                &endif
                                            &endif
                                                    output table tt-selecao-embarque). 
        open query brSon1 for each tt-selecao-embarque.
        session:set-wait-state("":U).
    end.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

