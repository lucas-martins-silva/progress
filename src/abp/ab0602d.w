&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-histor-ativid NO-UNDO LIKE mab-histor-ativid
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0602D 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0602d MAB}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i} /** l-usa-unid-negoc **/
CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0602D
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Hist¢rico

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            no 
&GLOBAL-DEFINE Copy           no
&GLOBAL-DEFINE Update         no
&GLOBAL-DEFINE Delete         no
&GLOBAL-DEFINE Undo           no
&GLOBAL-DEFINE Cancel         no
&GLOBAL-DEFINE Save           no

&GLOBAL-DEFINE ttTable     TTmab-histor-ativid   
&GLOBAL-DEFINE hDBOTable   hDBOMabHistorAtivid   
&GLOBAL-DEFINE DBOTable    mab-histor-ativid       

&GLOBAL-DEFINE page0KeyFields  TTmab-histor-ativid.ep-codigo ~
                               TTmab-histor-ativid.cod-eqpto
&GLOBAL-DEFINE page0Fields     TTmab-histor-ativid.dat-cadastro    
&GLOBAL-DEFINE page1Fields     TTmab-histor-ativid.cod-estabel ~
                               TTmab-histor-ativid.cod-grp-eqpto ~
                               TTmab-histor-ativid.cod-ativid ~
                               TTmab-histor-ativid.cc-codigo ~
                               TTmab-histor-ativid.cd-tag ~
                               fi-cod-unid-negoc ~
                               TTmab-histor-ativid.ct-codigo ~
                               TTmab-histor-ativid.cod-cidade ~
                               TTmab-histor-ativid.cod-estado ~
                               TTmab-histor-ativid.cod-pais ~
                               TTmab-histor-ativid.cod-ccusto-alter ~
                               fi-cod-placa ~
                               text-emplacamento ~
                               TTmab-histor-ativid.cod-cta-ctbl-lubrific ~
                               TTmab-histor-ativid.cod-ccusto-lubrific


/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER pRowSon AS ROWID      NO-UNDO.


/* Local Variable Definitions ---                                       */

define new global shared variable iEmpresa like mab-histor-ativid.ep-codigo no-undo.
define new global shared variable cEqpto   like mab-histor-ativid.cod-eqpto no-undo.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE  {&hDBOTable} AS HANDLE              NO-UNDO.
define variable  hDBOEqpto    as handle              no-undo.
define variable  cCodModelo   as char                no-undo.
define variable  hDBOModelo   as handle              no-undo.
define variable  hDBOMaterial as handle              no-undo.
DEFINE VARIABLE  l-mod-doctos AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE  hDBOUnNegoc  AS HANDLE              NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS TTmab-histor-ativid.ep-codigo ~
TTmab-histor-ativid.cod-eqpto TTmab-histor-ativid.dat-cadastro 
&Scoped-define ENABLED-TABLES TTmab-histor-ativid
&Scoped-define FIRST-ENABLED-TABLE TTmab-histor-ativid
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp cDescEqpto 
&Scoped-Define DISPLAYED-FIELDS TTmab-histor-ativid.ep-codigo ~
TTmab-histor-ativid.cod-eqpto TTmab-histor-ativid.dat-cadastro 
&Scoped-define DISPLAYED-TABLES TTmab-histor-ativid
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-histor-ativid
&Scoped-Define DISPLAYED-OBJECTS cDescEqpto 

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

DEFINE VARIABLE cDescEqpto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE cDescAtividade AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE cDescGrupo AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE cDescTag AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 31.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-placa AS CHARACTER FORMAT "x(12)" 
     LABEL "Placa":R7 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE fi-cod-unid-negoc AS CHARACTER FORMAT "x(8)" 
     LABEL "Unidade Neg¢cio":R18 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE text-emplacamento AS CHARACTER FORMAT "X(256)":U INITIAL "Emplacamento" 
      VIEW-AS TEXT 
     SIZE 12 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 55 BY 2.75.


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
     TTmab-histor-ativid.ep-codigo AT ROW 2.92 COL 12.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-histor-ativid.cod-eqpto AT ROW 2.92 COL 18 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     cDescEqpto AT ROW 2.92 COL 34.29 COLON-ALIGNED NO-LABEL
     TTmab-histor-ativid.dat-cadastro AT ROW 3.83 COL 12.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     rtKeys AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.5
         FONT 1.

DEFINE FRAME fPage1
     TTmab-histor-ativid.cod-estabel AT ROW 1.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-histor-ativid.cod-grp-eqpto AT ROW 2.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cDescGrupo AT ROW 2.25 COL 31 COLON-ALIGNED NO-LABEL
     TTmab-histor-ativid.cod-ativid AT ROW 3.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cDescAtividade AT ROW 3.25 COL 31 COLON-ALIGNED NO-LABEL
     TTmab-histor-ativid.ct-codigo AT ROW 4.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     TTmab-histor-ativid.cc-codigo AT ROW 4.25 COL 41.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     TTmab-histor-ativid.cod-cta-ctbl-lubrific AT ROW 5.25 COL 21 COLON-ALIGNED WIDGET-ID 2
          LABEL "Conta Lubrifica‡Æo"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88 TOOLTIP "Conta Contabil Lubrifica‡Æo"
     TTmab-histor-ativid.cod-ccusto-lubrific AT ROW 5.25 COL 41.29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 20 BY .88 TOOLTIP "Centro Custo Lubrifica‡Æo"
     TTmab-histor-ativid.cod-ccusto-alter AT ROW 6.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     fi-cod-unid-negoc AT ROW 6.25 COL 59 COLON-ALIGNED
     TTmab-histor-ativid.cd-tag AT ROW 7.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     cDescTag AT ROW 7.25 COL 37.14 COLON-ALIGNED NO-LABEL
     fi-cod-placa AT ROW 9.29 COL 21 COLON-ALIGNED
     TTmab-histor-ativid.cod-cidade AT ROW 9.29 COL 41.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 26.72 BY .88
     TTmab-histor-ativid.cod-estado AT ROW 10.29 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     TTmab-histor-ativid.cod-pais AT ROW 10.29 COL 41.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     text-emplacamento AT ROW 8.5 COL 17.86 COLON-ALIGNED HELP
          "Emplacamento" NO-LABEL
     RECT-1 AT ROW 8.75 COL 17
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.75
         SIZE 84.43 BY 11.5
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: TTmab-histor-ativid T "?" NO-UNDO mgfro mab-histor-ativid
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
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
         HEIGHT             = 18.54
         WIDTH              = 90
         MAX-HEIGHT         = 22.46
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22.46
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN TTmab-histor-ativid.cod-ccusto-lubrific IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN TTmab-histor-ativid.cod-cta-ctbl-lubrific IN FRAME fPage1
   EXP-LABEL                                                            */
ASSIGN 
       text-emplacamento:PRIVATE-DATA IN FRAME fPage1     = 
                "Emplacamento".

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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
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


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    assign iEmpresa = INPUT FRAME fPage0 TTmab-histor-ativid.ep-codigo
           cEqpto   = INPUT FRAME fPage0 TTmab-histor-ativid.cod-eqpto.
    {method/zoomreposition.i &ProgramZoom="frzoom\z01fr013.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME TTmab-histor-ativid.cd-tag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-histor-ativid.cd-tag wMaintenance
ON LEAVE OF TTmab-histor-ativid.cd-tag IN FRAME fPage1 /* TAG */
DO:
  FOR FIRST tag FIELDS (cd-tag descricao) WHERE
             tag.cd-tag   = TTmab-histor-ativid.cd-tag:SCREEN-VALUE IN FRAME fPage1 NO-LOCK.
           ASSIGN cDescTag = tag.descricao.
           DISP cDescTag WITH FRAME fPage1.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-histor-ativid.cod-ativid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-histor-ativid.cod-ativid wMaintenance
ON LEAVE OF TTmab-histor-ativid.cod-ativid IN FRAME fPage1 /* Atividade */
DO:
 FOR FIRST mab-ativid FIELDS (cod-ativid des-ativid) WHERE
            mab-ativid.cod-ativid   = TTmab-histor-ativid.cod-ativid:SCREEN-VALUE IN FRAME fPage1 NO-LOCK.
           ASSIGN cDescAtividade = mab-ativid.des-ativid.
           DISP cDescAtividade WITH FRAME fPage1.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME TTmab-histor-ativid.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-histor-ativid.cod-eqpto wMaintenance
ON LEAVE OF TTmab-histor-ativid.cod-eqpto IN FRAME fpage0 /* cod-eqpto */
DO:
  
      FOR FIRST mab-eqpto FIELDS (ep-codigo cod-eqpto) WHERE mab-eqpto.ep-codigo = INPUT FRAME fPage0 TTmab-histor-ativid.ep-codigo
                 AND mab-eqpto.cod-eqpto = TTmab-histor-ativid.cod-eqpto:SCREEN-VALUE IN FRAME fPage0,
                 FIRST mab-model FIELDS (cod-model des-model) WHERE
                        mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:
        
                        ASSIGN cDescEqpto = mab-model.des-model.
                        DISP cDescEqpto WITH FRAME fPage0.
    END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME TTmab-histor-ativid.cod-grp-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-histor-ativid.cod-grp-eqpto wMaintenance
ON LEAVE OF TTmab-histor-ativid.cod-grp-eqpto IN FRAME fPage1 /* Grupo Equipamento */
DO:
  FOR FIRST mab-grp-eqpto FIELDS (cod-grp-eqpto des-grp-eqpto) WHERE
            mab-grp-eqpto.cod-grp-eqpto  = TTmab-histor-ativid.cod-grp-eqpto:SCREEN-VALUE IN FRAME fPage1 NO-LOCK.
           ASSIGN cDescGrupo = mab-grp-eqpto.des-grp-eqpto.
           DISP cDescGrupo WITH FRAME fPage1.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/** Descri‡äes de campos **/
apply "LEAVE":U to TTmab-histor-ativid .cod-eqpto     in frame fPage0.
apply "LEAVE":U to TTmab-histor-ativid .cod-grp-eqpto in frame fPage1.
apply "LEAVE":U to TTmab-histor-ativid .cod-ativid    in frame fPage1.
apply "LEAVE":U to TTmab-histor-ativid .cd-tag        in frame fPage1.

IF l-mod-doctos THEN DO:
    /*buscando cod da placa caso mod doctos esteja implantado*/
    IF AVAIL TTmab-histor-ativid THEN
        FOR FIRST mab-eqpto FIELDS (ep-codigo cod-eqpto cod-placa) 
                            WHERE mab-eqpto.ep-codigo = TTmab-histor-ativid.ep-codigo
                              AND mab-eqpto.cod-eqpto = TTmab-histor-ativid.cod-eqpto NO-LOCK:
        END.
    IF AVAIL mab-eqpto THEN
         ASSIGN fi-cod-placa = mab-eqpto.cod-placa.
    ELSE
         ASSIGN fi-cod-placa = "":U.
    
    DISP fi-cod-placa WITH FRAME fPage1.
END.
ELSE DO:
    /*mod doctos nao est  implantado, escondendo campos de emplacamento*/
    ASSIGN l-mod-doctos = NO
           TTmab-histor-ativid.cod-cidade:HIDDEN IN FRAME fPage1 = YES
           TTmab-histor-ativid.cod-pais:HIDDEN IN FRAME fPage1 = YES
           TTmab-histor-ativid.cod-estado:HIDDEN IN FRAME fPage1 = YES
           fi-cod-placa:HIDDEN IN FRAME fPage1 = YES
           text-emplacamento:HIDDEN IN FRAME fPage1 = YES.
    HIDE RECT-1 IN FRAME fPage1.
END.

&IF DEFINED(bf_mnt_ems206b) &THEN
    IF l-usa-unid-negoc THEN
        ASSIGN fi-cod-unid-negoc:SCREEN-VALUE IN FRAME fPage1 = {&ttTable}.cod-unid-negoc.   
&ELSE
    ASSIGN fi-cod-unid-negoc:SCREEN-VALUE IN FRAME fPage1 = {&ttTable}.cod_unid_negoc.
&ENDIF

APPLY "LEAVE":U TO fi-cod-unid-negoc IN FRAME fPage1.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{utp/ut-liter.i "Equipamento" *}
ASSIGN TTmab-histor-ativid.ep-codigo:LABEL IN FRAME fPage0 = RETURN-VALUE.
if pRowSon <> ? then do:
    /*:T Reposiciona registro com base no rowid do browse do programa AB0138 */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT pRowSon).
end.

/*verifica se modulo de doctos est  implantado*/
RUN cdp/cd9902.p (INPUT 7).
IF RETURN-VALUE = "NOK":U THEN DO:
    /*mod doctos nao est  implantado, escondendo campos de emplacamento*/
    ASSIGN l-mod-doctos = NO
           TTmab-histor-ativid.cod-cidade:HIDDEN IN FRAME fPage1 = YES
           TTmab-histor-ativid.cod-pais:HIDDEN IN FRAME fPage1 = YES
           TTmab-histor-ativid.cod-estado:HIDDEN IN FRAME fPage1 = YES
           fi-cod-placa:HIDDEN IN FRAME fPage1 = YES
           text-emplacamento:HIDDEN IN FRAME fPage1 = YES.
    HIDE RECT-1 IN FRAME fPage1.
END.
ELSE
    ASSIGN l-mod-doctos = YES.

&IF DEFINED(bf_mnt_ems206b) &THEN
    ASSIGN fi-cod-unid-negoc:VISIBLE   IN FRAME fPage1 = l-usa-unid-negoc.    
&ENDIF

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
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
    DEFINE VARIABLE cep-codigo    LIKE {&ttTable}.ep-codigo
    VIEW-AS FILL-IN SIZE 5.00 BY 0.88 NO-UNDO.
    DEFINE VARIABLE ccod-eqpto    LIKE {&ttTable}.cod-eqpto 
    VIEW-AS FILL-IN SIZE 14.00 BY 0.88 NO-UNDO.
    DEFINE VARIABLE ddat-cadastro LIKE {&ttTable}.dat-cadastro 
    VIEW-AS FILL-IN SIZE 10.00 BY 0.88 NO-UNDO.
    
    
    DEFINE FRAME fGoToRecord
        cep-codigo  AT ROW 1.21 COL 17.72 COLON-ALIGNED
        ccod-eqpto  AT ROW 2.21 COL 17.72 COLON-ALIGNED
        ddat-cadastro  AT ROW 3.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 4.63 COL 2.14
        btGoToCancel      AT ROW 4.63 COL 13
        rtGoToButton      AT ROW 4.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Hist¢rico da Atividade" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Hist¢rico_da_Atividade"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cep-codigo ccod-eqpto ddat-cadastro.
        
        RUN goToKey IN {&hDBOTable} (INPUT cep-codigo , INPUT ccod-eqpto , INPUT  ddat-cadastro ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "mab-histor-ativid":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cep-codigo ccod-eqpto  ddat-cadastro btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
   /*--- DBO Hist-Atividade ---*/
    IF NOT VALID-HANDLE ({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "frbo~\bofr013.p":U THEN DO:
        run frbo/bofr013.p persistent set  {&hDBOTable}.
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF NOT VALID-HANDLE(hDBOUnNegoc)                OR
            hDBOUnNegoc:TYPE      <> "PROCEDURE":U      OR
            hDBOUnNegoc:FILE-NAME <> "inbo/boin745.p":U THEN DO:
            RUN inbo/boin745.p PERSISTENT SET hDBOUnNegoc.
        END.

        RUN openQueryStatic IN hDBOUnNegoc (INPUT "Main":U) NO-ERROR.
    &ENDIF
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

