&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
aa
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttCompEqpto NO-UNDO LIKE mab-comptmento-eqpto
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttRemonta NO-UNDO LIKE mab-movto-remon
       FIELD cod-causa AS CHARACTER LABEL "Causa"
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
{include/i-prgvrs.i AB0601 2.00.00.019 } /*** "010019" 24/11/2023 09:55:35 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0601 MAB}
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
&GLOBAL-DEFINE Program          AB0601
&GLOBAL-DEFINE Version        2.00.00.019

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Hist¢rico

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

&GLOBAL-DEFINE ttParent         ttCompEqpto
&GLOBAL-DEFINE hDBOParent       hDBOCompEqpto
&GLOBAL-DEFINE DBOParentTable   mab-comptmento-eqpto
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           ttRemonta
&GLOBAL-DEFINE hDBOSon1         hDBORemonta
&GLOBAL-DEFINE DBOSon1Table     movfro.mab-movto-remon
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE page0Fields      ttCompEqpto.cod-comptmento ttCompEqpto.cod-eqpto ~
                                ttCompEqpto.ep-codigo ttCompEqpto.val-perc-remon

&GLOBAL-DEFINE page1Browse      brSon1

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cCodModelo AS CHARACTER  NO-UNDO.

/** Sele‡Æo **/
define variable dtDataIni as date format "99/99/9999" initial 01/01/1800 no-undo.
define variable dtDataFim as date format "99/99/9999" initial today      no-undo.
DEFINE VARIABLE cCausaIni AS CHARACTER FORMAT "x(8)"  INITIAL "".
DEFINE VARIABLE cCausaFim AS CHARACTER FORMAT "x(8)"  INITIAL "ZZZZZZZZ".
define variable lAtual    as logical                  initial yes        no-undo.
define variable lAcima    as logical                  initial no         no-undo.
define variable lOK       as logical                  initial NO         no-undo.
define variable lAtivos         as logical            initial yes         no-undo.
define variable lInativos       as logical            initial yes         no-undo.
define variable lMotorizados    as logical            initial yes         no-undo.
define variable lNaoMotorizados as logical            initial yes         no-undo.
define variable lProprios       as logical            initial yes         no-undo.
define variable lTerceiros      as logical            initial yes         no-undo.


/* Global Variable Definitions ---                                      */
define new global shared variable iEmpresa like mab-comptmento-eqpto.ep-codigo no-undo.
define new global shared variable cEqpto   like mab-comptmento-eqpto.cod-eqpto   no-undo.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEqpto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOComp      AS HANDLE NO-UNDO.
DEF VAR r-rowid-retorno       AS ROWID NO-UNDO.

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
&Scoped-define INTERNAL-TABLES ttRemonta

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 ttRemonta.dat-movto ~
ttRemonta.hra-inicial ttRemonta.qtd-oleo ttRemonta.qtd-combust ~
ttRemonta.val-perc-remon ttRemonta.num-docto ttRemonta.cod-causa
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH ttRemonta NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH ttRemonta NO-LOCK.

&Scoped-define TABLES-IN-QUERY-brSon1 ttRemonta
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 ttRemonta


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttCompEqpto.ep-codigo ttCompEqpto.cod-eqpto ~
ttCompEqpto.cod-comptmento ttCompEqpto.val-perc-remon 
&Scoped-define ENABLED-TABLES ttCompEqpto
&Scoped-define FIRST-ENABLED-TABLE ttCompEqpto
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btSelecao btQueryJoins btReportsJoins btExit btHelp ~
fiDescEmp fiDescModelo fiDescComp fiAtual 
&Scoped-Define DISPLAYED-FIELDS ttCompEqpto.ep-codigo ttCompEqpto.cod-eqpto ~
ttCompEqpto.cod-comptmento ttCompEqpto.val-perc-remon 
&Scoped-define DISPLAYED-TABLES ttCompEqpto
&Scoped-define FIRST-DISPLAYED-TABLE ttCompEqpto
&Scoped-Define DISPLAYED-OBJECTS fiDescEmp fiDescModelo fiDescComp fiAtual 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 btSelecao 

/* _UIB-PREPROCESSOR-BLOCK-END */
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
       MENU-ITEM miSelecao      LABEL "S&ele‡Æo"       ACCELERATOR "CTRL-S"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "Re&lat¢rios"   
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
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btSelecao 
     IMAGE-UP FILE "image/im-ran.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-ran.bmp":U
     LABEL "Parƒmetros" 
     SIZE 4 BY 1.25 TOOLTIP "Parƒmetros"
     FONT 4.

DEFINE VARIABLE fiAtual AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Remonta Atual" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescComp AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescEmp AS CHARACTER FORMAT "x(70)" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      ttRemonta
       SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      ttRemonta.dat-movto FORMAT "99/99/9999":U
      ttRemonta.hra-inicial FORMAT "99:99:99":U
      ttRemonta.qtd-oleo FORMAT ">>>,>>>,>>9.99":U
      ttRemonta.qtd-combust FORMAT ">>>,>>>,>>9.99":U
      ttRemonta.val-perc-remon FORMAT ">>9.99":U
      ttRemonta.num-docto FORMAT ">>>,>>>,>>9":U
      ttRemonta.cod-causa FORMAT "x(8)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.13
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
     btSelecao AT ROW 1.13 COL 59 HELP
          "Parƒmetros"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     ttCompEqpto.ep-codigo AT ROW 2.88 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     fiDescEmp AT ROW 2.88 COL 29.57 COLON-ALIGNED HELP
          "Nome Abreviado da Empresa" NO-LABEL
     ttCompEqpto.cod-eqpto AT ROW 3.88 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     fiDescModelo AT ROW 3.88 COL 38.57 COLON-ALIGNED HELP
          "Descri‡Æo do Modelo" NO-LABEL
     ttCompEqpto.cod-comptmento AT ROW 4.88 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescComp AT ROW 4.88 COL 34.57 COLON-ALIGNED HELP
          "Descri‡Æo do Compartimento" NO-LABEL
     ttCompEqpto.val-perc-remon AT ROW 5.88 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiAtual AT ROW 5.88 COL 59.57 COLON-ALIGNED
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 8.38
         SIZE 84.43 BY 8.63
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttCompEqpto T "?" NO-UNDO mgfro mab-comptmento-eqpto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttmab-item-lubrific T "?" NO-UNDO movfro mab-item-lubrific
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttRemonta T "?" NO-UNDO movfro mab-movto-remon
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
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
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
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON btSelecao IN FRAME fPage0
   1                                                                    */
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
     _TblList          = "Temp-Tables.ttRemonta,Temp-Tables.ttmab-item-lubrific OF Temp-Tables.ttRemonta"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttRemonta.dat-movto
     _FldNameList[2]   = Temp-Tables.ttRemonta.hra-inicial
     _FldNameList[3]   = Temp-Tables.ttRemonta.qtd-oleo
     _FldNameList[4]   = Temp-Tables.ttRemonta.qtd-combust
     _FldNameList[5]   = Temp-Tables.ttRemonta.val-perc-remon
     _FldNameList[6]   = Temp-Tables.ttRemonta.num-docto
     _FldNameList[7]   = Temp-Tables.ttmab-item-lubrific.cod-causa
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
ON ROW-DISPLAY OF brSon1 IN FRAME fPage1
DO:
    if avail {&ttSon1} then do:
        if {&ttSon1}.val-perc-remon > {&ttParent}.val-perc-remon then 
            assign {&ttSon1}.dat-movto:fgcolor      in browse brSon1 = 12
                   {&ttSon1}.qtd-oleo:fgcolor       in browse brSon1 = 12
                   {&ttSon1}.qtd-combust:fgcolor    in browse brSon1 = 12
                   {&ttSon1}.val-perc-remon:fgcolor in browse brSon1 = 12.
    end.
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


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMasterDetail
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
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
    assign iEmpresa = &IF "{&mguni_version}" >= "2.071" &THEN "" &else 0 &ENDIF
           cEqpto   = "".
    {method/zoomreposition.i &ProgramZoom="frzoom\z01fr004.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSelecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelecao wMasterDetail
ON CHOOSE OF btSelecao IN FRAME fPage0 /* Parƒmetros */
OR CHOOSE OF MENU-ITEM miSelecao IN MENU mbMain DO:
  ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
  /** Programa Filtro **/
  RUN abp/ab0601a.w (INPUT-OUTPUT dtDataIni,
                     INPUT-OUTPUT dtDataFim,
                     INPUT-OUTPUT cCausaIni,
                     INPUT-OUTPUT cCausaFim,
                     INPUT-OUTPUT lAtual   ,
                     INPUT-OUTPUT lAcima   ,
                     INPUT-OUTPUT lAtivos  ,
                     INPUT-OUTPUT lInativos,
                     INPUT-OUTPUT lMotorizados,
                     INPUT-OUTPUT lNaoMotorizados,
                     INPUT-OUTPUT lProprios,
                     INPUT-OUTPUT lTerceiros,
                     OUTPUT       lOK      ).
  ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

  APPLY "ENTRY":U TO btSelecao IN FRAME fPage0.

  /** Busca os registros **/
  if lOK then do:
      /*:T Reposiciona registro com base em um rowid */

        RUN setConstraintMotorEqpto IN {&hDBOParent} (INPUT YES,                                                  
                                              INPUT lAtivos,
                                              INPUT lInativos,
                                              INPUT lMotorizados,
                                              INPUT lNaoMotorizados,
                                              INPUT lProprios,
                                              INPUT lTerceiros) NO-ERROR.

        RUN openQueryStatic IN {&hDBOParent} (INPUT "MotorEqpto":U) NO-ERROR.

        /*:TÿRetornaÿrowidÿdoÿregistroÿcorrenteÿdoÿDBOÿ*/
        RUN getRowid IN {&hDBOParent} (OUTPUT r-rowid-retorno).
        /*:TÿReposicionaÿregistroÿcomÿbaseÿemÿumÿrowidÿ*/
        RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowid-retorno).

end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttCompEqpto.cod-comptmento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttCompEqpto.cod-comptmento wMasterDetail
ON LEAVE OF ttCompEqpto.cod-comptmento IN FRAME fPage0 /* Compartimento */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOComp"
        &KeyValue1="{&ttParent}.cod-comptmento:screen-value in frame fPage0"
        &FieldName1="des-comptmento"
        &FieldScreen1="fiDescComp"
        &Frame1="fPage0"}   
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttCompEqpto.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttCompEqpto.cod-eqpto wMasterDetail
ON LEAVE OF ttCompEqpto.cod-eqpto IN FRAME fPage0 /* Equipamento */
DO:
   if avail {&ttParent} then do:
    run buscaModelo in this-procedure.
    {method\referenceFields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="cCodModelo"
        &FieldName1="des-model"
        &FieldScreen1="fiDescModelo"
        &Frame1="fPage0"}
   end.
   else 
       assign fiDescModelo:screen-value in frame fPage0 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttCompEqpto.ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttCompEqpto.ep-codigo wMasterDetail
ON LEAVE OF ttCompEqpto.ep-codigo IN FRAME fPage0 /* Empresa */
DO:
  /** Busca Descri‡Æo da empresa **/
  assign fiDescEmp:screen-value in frame fPage0 = "".
  if avail {&ttParent} then do:
      for first empresa fields(nome)
          where empresa.ep-codigo = {&ttParent}.ep-codigo no-lock:
          assign fiDescEmp:screen-value in frame fPage0 = empresa.nome.
      end.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{masterdetail/mainblock.i}

{abp/abapi001.i2} /** Cria‡Æo de erros **/
{abp/ab9005.i}    /** Valida‡Æo de parƒmetros **/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMasterDetail 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Override ap¢s finalizar o programa
------------------------------------------------------------------------------*/

 
 IF valid-handle(hDBOEqpto) THEN
     RUN destroy IN hDBOEqpto.

 IF valid-handle(hDBOModelo) THEN
     RUN destroy IN hDBOModelo.

 IF valid-handle(hDBOComp) THEN
     RUN destroy IN hDBOComp.
            
/** Elimina aplicativo **/
{method/showmessage.i3}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     afterDisplayFields
  Parameters:  <none>
  Notes:       Override (ap¢s) display de campos em tela
------------------------------------------------------------------------------*/
DEFINE VARIABLE cRemonta AS CHARACTER  NO-UNDO.

{utp/ut-liter.i "Remonta" MAB}
ASSIGN cRemonta = RETURN-VALUE
       {&ttParent}.val-perc-remon:LABEL IN FRAME fPage0 = "% " + cRemonta.

{utp/ut-liter.i "Atual"}
ASSIGN fiAtual:LABEL IN FRAME fPage0 = "% " + cRemonta + " " + RETURN-VALUE
       ttRemonta.val-perc-remon:LABEL IN BROWSE brSon1 = "% " + cRemonta.

/** Descri‡äes **/
apply "LEAVE":U to {&ttParent}.ep-codigo      in frame fPage0.
apply "LEAVE":U to {&ttParent}.cod-eqpto      in frame fPage0.
apply "LEAVE":U to {&ttParent}.cod-comptmento in frame fPage0.


if avail {&ttParent} then
    assign btSelecao:sensitive in frame fPage0 = yes
           menu-item miSelecao:sensitive in menu mbMain = yes.
else 
    assign btSelecao:sensitive in frame fPage0 = YES
           menu-item miSelecao:sensitive in menu mbMain = no.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMasterDetail 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override antes de inicializar a tela
------------------------------------------------------------------------------*/
/** Valida se os parÆmetros estÆo cadastrados **/
{utp/ut-liter.i "Abastecimento"}
run piValidaParametroModulo in this-procedure (input "17,18":U,
                                               input trim(return-value)).
if return-value = "NOK":U then do:
    /** Instancia aplicativo **/
    {method/showmessage.i1}
    /** Mostra caixa com erros **/
    {method/showmessage.i2 &Modal="YES"}
    /** Limpa temp-tables de erros **/
    empty temp-table RowErrors.
    /** Elimina aplicativo **/
    {method/showmessage.i3}
    return "NOK":U.
end.

return "OK":U.

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
{method\referenceFields.i
    &HandleDBOLeave="hDBOEqpto"
    &KeyValue1="{&ttParent}.ep-codigo"
    &KeyValue2="{&ttParent}.cod-eqpto"
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
    
    DEFINE VARIABLE cdnEmpresa LIKE {&ttParent}.ep-codigo    NO-UNDO.
    DEFINE VARIABLE codEqpto   LIKE {&ttParent}.cod-eqpto      NO-UNDO.
    DEFINE VARIABLE codComp    LIKE {&ttParent}.cod-comptmento NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        cdnEmpresa        AT ROW 1.21 COL 17.72 COLON-ALIGNED
        codEqpto          AT ROW 2.21 COL 17.72 COLON-ALIGNED
        codComp           AT ROW 3.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 4.63 COL 2.14
        btGoToCancel      AT ROW 4.63 COL 13
        rtGoToButton      AT ROW 4.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Compartimento Equipamento" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Compartimento_Equipamento"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cdnEmpresa
               codEqpto   
               codComp.
        
        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT cdnEmpresa , INPUT codEqpto, INPUT codComp ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Compartimento_Equipamento" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cdnEmpresa codEqpto codComp  btGoToOK btGoToCancel 
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
       {&hDBOParent}:FILE-NAME <> "frbo~\bofr004b.p":U THEN DO:
        run frbo/bofr004b.p persistent set {&hDBOParent}.
    END.

    run setConstraintMotorEqpto in {&hDBOParent} (input yes,                                                  
                                                  INPUT lAtivos,
                                                  INPUT lInativos,
                                                  INPUT lMotorizados,
                                                  INPUT lNaoMotorizados,
                                                  INPUT lProprios,
                                                  INPUT lTerceiros) no-error.


    RUN openQueryStatic IN {&hDBOParent} (INPUT "MotorEqpto":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "frbo~\bofr061.p":U THEN DO:
        run frbo/bofr061.p persistent set {&hDBOSon1}. 
    END.

    /*--- DBO Equipamento ---*/
    IF NOT VALID-HANDLE(hDBOEqpto) OR
       hDBOEqpto:TYPE <> "PROCEDURE":U OR
       hDBOEqpto:FILE-NAME <> "frbo~\bofr007.p":U THEN DO:
        run frbo/bofr007.p persistent set  hDBOEqpto.
    END.
    
    RUN openQueryStatic IN hDBOEqpto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo~\bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

    /*--- DBO Compartimento ---*/
    IF NOT VALID-HANDLE(hDBOComp) OR
       hDBOComp:TYPE <> "PROCEDURE":U OR
       hDBOComp:FILE-NAME <> "frbo~\bofr003.p":U THEN DO:
        run frbo/bofr003.p persistent set  hDBOComp.
    END.
    
    RUN openQueryStatic IN hDBOComp (INPUT "Main":U) NO-ERROR.

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

    /** Tratamento para campo % Remonta Atual **/
    run piRemontaAtual in this-procedure.
    /** Restri‡äes da sele‡Æo de data **/
    run setConstraintData in {&hDBOSon1} (input dtDataIni,
                                          input dtDataFim,
                                          input input frame fPage0 {&ttParent}.val-perc-remon) no-error.
    /** Abre query considerando remonta atual **/
    if lAcima then do:
        {masterdetail/openqueriesson.i &Parent="Historico"
                                       &Query="HistoricoPadrao"
                                       &PageNumber="1"}        
    end.
    /** Abre query normal **/
    else do:
        {masterdetail/openqueriesson.i &Parent="Historico"
                                       &Query="Historico"
                                       &PageNumber="1"}
    end.

DEFINE BUFFER bf-ttRemonta FOR ttRemonta.
FOR EACH  bf-ttRemonta:
    FOR FIRST mab-item-lubrific
        WHERE mab-item-lubrific.num-docto = bf-ttRemonta.num-docto
          AND mab-item-lubrific.cod-comptmento = bf-ttRemonta.cod-comptmento:
        ASSIGN bf-ttRemonta.cod-causa = mab-item-lubrific.cod-causa.
    END.
END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRemontaAtual wMasterDetail 
PROCEDURE piRemontaAtual :
/*------------------------------------------------------------------------------
  Purpose:     piRemontaAtual
  Parameters:  <none>
  Notes:       Calcula o campo % Remonta Atual
------------------------------------------------------------------------------*/
define variable cEventoTroca    like mab-event.cod-evento no-undo.
define variable cEventoRemonta  like mab-event.cod-evento no-undo.
define variable deAbastecimento as   decimal  initial 0   no-undo.
define variable deRemonta       as   decimal  initial 0   no-undo.

define buffer bfLubrific for mab-item-lubrific.

/** Verifica se mostra % Remonta Atual **/
if lAtual then do:
    /** Busca Eventos de troca e remonta do ¢leo **/
    for each  mab-param 
        where mab-param.cdn-param = 17 
        or    mab-param.cdn-param = 18 no-lock:
        if mab-param.cdn-param = 17 then
            assign cEventoTroca = mab-param.des-valor.
        else 
            assign cEventoRemonta = mab-param.des-valor.
    end.
    /** Busca éltima troca de àleo **/
    for last  mab-item-lubrific fields(val-dat-hora-invrtda)
        where mab-item-lubrific.ep-codigo      = {&ttParent}.ep-codigo
        and   mab-item-lubrific.cod-eqpto      = {&ttParent}.cod-eqpto
        and   mab-item-lubrific.cod-comptmento = {&ttParent}.cod-comptmento
        and   mab-item-lubrific.cod-evento     = cEventoTroca
        AND   mab-item-lubrific.cod-causa     >= cCausaIni
        AND   mab-item-lubrific.cod-causa     <= cCausaFim no-lock:
        /** Busca Abastecimentos posteriores a £ltima troca de ¢leo **/
        for each  mab-item-abastec fields(val-quant)
            where mab-item-abastec.ep-codigo             = {&ttParent}.ep-codigo
            and   mab-item-abastec.cod-eqpto             = {&ttParent}.cod-eqpto
            and   mab-item-abastec.val-dat-hora-invrtda  > mab-item-lubrific.val-dat-hora-invrtda 
            and   mab-item-abastec.log-abastec-prim  no-lock:
            /** Acumula abastecimentos **/
            assign deAbastecimento = deAbastecimento + mab-item-abastec.val-quant.
        end.
        /** Busca Remontas posteriores a £ltima troca de ¢leo **/
        for each  bfLubrific fields(val-quant)
            where bfLubrific.ep-codigo             = {&ttParent}.ep-codigo
            and   bfLubrific.cod-eqpto             = {&ttParent}.cod-eqpto
            and   bfLubrific.cod-comptmento        = {&ttParent}.cod-comptmento
            and   bfLubrific.val-dat-hora-invrtda >= mab-item-lubrific.val-dat-hora-invrtda
            and   bfLubrific.cod-evento            = cEventoRemonta
            AND   bfLubrific.cod-causa            >= cCausaIni
            AND   bfLubrific.cod-causa            <= cCausaFim no-lock:
            /** Acumula remontas de ¢leo **/
            assign deRemonta = deRemonta + bfLubrific.val-quant.
        end.
    end.
    
    assign fiAtual:hidden in frame fPage0 = no
           fiAtual = deRemonta / deAbastecimento * 100.
    
    if fiAtual = ? then
        assign fiAtual = 0.
    
    display fiAtual with frame fPage0.
end.
/** Elimina campo de tela **/
else do:
    assign fiAtual:hidden in frame fPage0 = yes
           fiAtual = 0.
end.
  
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaEquipamento wMasterDetail 
PROCEDURE setaEquipamento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:   Reposiciona no Rowid da Tabela pai  com base na consulta do programa ab0604.w  
------------------------------------------------------------------------------*/
DEF INPUT PARAM pRowid AS ROWID NO-UNDO. /**Rowid do Equipamento (mab-eqpto) no programa ab0604.w**/
DEFINE VARIABLE rRowid AS ROWID NO-UNDO.

buscaCompto:
DO TRANS ON ERROR UNDO,LEAVE :
FIND mab-eqpto WHERE ROWID(mab-eqpto) = pRowid NO-LOCK NO-ERROR.
     IF AVAIL mab-eqpto THEN DO:
         FOR EACH mab-comptmento-eqpto FIELDS (ep-codigo cod-eqpto cod-comptmento) 
              WHERE mab-comptmento-eqpto.ep-codigo = mab-eqpto.ep-codigo
              AND   mab-comptmento-eqpto.cod-eqpto = mab-eqpto.cod-eqpto NO-LOCK:
            
                 FOR FIRST mab-comptmento FIELDS (cod-comptmento log-motor)
                     WHERE mab-comptmento.cod-comptmento = mab-comptmento-eqpto.cod-comptmento NO-LOCK:
                     /**Somente rowid para compartimentos que seja igual a motor**/
                     IF mab-comptmento.log-motor = TRUE THEN DO:
                         
                         ASSIGN rRowid = ROWID(mab-comptmento-eqpto).
                         LEAVE buscaCompto.
                     END.
                 END.
         END.
     END.
END.

/**reposiciona no Rowid da Tabela pai**/
RUN repositionRecord IN THIS-PROCEDURE (INPUT rRowid).
if return-value = "NOK":U THEN DO:  
    run getFirst in this-procedure.
END.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

