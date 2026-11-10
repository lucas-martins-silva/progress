&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movfro           PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-movto-event NO-UNDO LIKE mab-movto-event
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
{include/i-prgvrs.i AB0619 2.00.00.004 } /*** "010004" ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0619 MAB}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/



CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          AB0619
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE Folder           NO
&GLOBAL-DEFINE InitialPage      0
&GLOBAL-DEFINE FolderLabels    

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

&GLOBAL-DEFINE ttParent         TTmab-movto-event
&GLOBAL-DEFINE hDBOParent       hDBOMovtoEvent
&GLOBAL-DEFINE DBOParentTable   mab-movto-event
&GLOBAL-DEFINE DBOParentDestroy YES


&GLOBAL-DEFINE page0Fields TTmab-movto-event.ep-codigo ~
                           TTmab-movto-event.cod-eqpto ~
                           TTmab-movto-event.cod-evento ~
                           TTmab-movto-event.cod-ofici ~
                           TTmab-movto-event.cod-matr ~
                           TTmab-movto-event.ep-codigo-matr ~
                           TTmab-movto-event.cod-estabel-matr ~
                           TTmab-movto-event.cod-sub-sist ~
                           TTmab-movto-event.cd-tipo ~
                           TTmab-movto-event.cod-usuar ~
                           TTmab-movto-event.dat-final ~
                           TTmab-movto-event.dat-inicial ~
                           TTmab-movto-event.dsl-obs ~
                           TTmab-movto-event.num-docto ~
                           TTmab-movto-event.val-km-aviso ~
                           TTmab-movto-event.hra-final ~
                           TTmab-movto-event.hra-inicial ~
                           TTmab-movto-event.val-evento ~
                           TTmab-movto-event.ct-despesa ~
                           TTmab-movto-event.cc-despesa      

&GLOBAL-DEFINE page1Fields      
                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-desc-criterio AS CHAR FORMAT "x(40)" NO-UNDO.
DEFINE VARIABLE c-desc-padrao   AS CHAR FORMAT "x(40)" NO-UNDO.
DEFINE VARIABLE cStatus         AS CHAR FORMAT "x(40)" NO-UNDO.
DEFINE VARIABLE c-Estdo         AS CHAR FORMAT "x(40)" NO-UNDO.

DEFINE VARIABLE cFConta        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFSub          AS CHARACTER  NO-UNDO.
/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEvent     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOHistor    AS HANDLE NO-UNDO.

DEFINE VARIABLE iValor AS INTEGER    NO-UNDO.

DEF BUFFER bfMovtoEvento FOR mab-movto-km-eqpto.

{cdp/cdunif001.i} /*105 unifica‡Æo de conceitos*/
DEFINE VARIABLE cEmpresaEstab AS CHARACTER INITIAL ""     NO-UNDO.
DEFINE VARIABLE dDada         AS DATE      INITIAL TODAY  NO-UNDO.

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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS TTmab-movto-event.num-docto ~
TTmab-movto-event.dat-inicial TTmab-movto-event.hra-inicial ~
TTmab-movto-event.cod-usuar TTmab-movto-event.ep-codigo ~
TTmab-movto-event.cod-eqpto TTmab-movto-event.ep-codigo-matr ~
TTmab-movto-event.cod-estabel-matr TTmab-movto-event.cod-matr ~
TTmab-movto-event.val-km-aviso TTmab-movto-event.cod-evento ~
TTmab-movto-event.val-evento TTmab-movto-event.cd-tipo ~
TTmab-movto-event.ct-despesa TTmab-movto-event.cod-sub-sist ~
TTmab-movto-event.cc-despesa TTmab-movto-event.cod-ofici ~
TTmab-movto-event.dsl-obs TTmab-movto-event.dat-final ~
TTmab-movto-event.hra-final 
&Scoped-define ENABLED-TABLES TTmab-movto-event
&Scoped-define FIRST-ENABLED-TABLE TTmab-movto-event
&Scoped-Define ENABLED-OBJECTS RECT-17 RECT-18 RECT-19 RECT-38 rtParent ~
rtToolBar btFirst btPrev btNext btLast btGoTo btSearch btQueryJoins ~
btReportsJoins btExit btHelp cDescEmp cDescEqpto iDias cDescMotorista ~
cDescUn cDescEvent btMatriz fi-cod-unid-negoc cDescTpManut cDescSubSist ~
cDescOfic fi-cod-emitente 
&Scoped-Define DISPLAYED-FIELDS TTmab-movto-event.num-docto ~
TTmab-movto-event.dat-inicial TTmab-movto-event.hra-inicial ~
TTmab-movto-event.cod-usuar TTmab-movto-event.ep-codigo ~
TTmab-movto-event.cod-eqpto TTmab-movto-event.ep-codigo-matr ~
TTmab-movto-event.cod-estabel-matr TTmab-movto-event.cod-matr ~
TTmab-movto-event.val-km-aviso TTmab-movto-event.cod-evento ~
TTmab-movto-event.val-evento TTmab-movto-event.cd-tipo ~
TTmab-movto-event.ct-despesa TTmab-movto-event.cod-sub-sist ~
TTmab-movto-event.cc-despesa TTmab-movto-event.cod-ofici ~
TTmab-movto-event.dsl-obs TTmab-movto-event.dat-final ~
TTmab-movto-event.hra-final 
&Scoped-define DISPLAYED-TABLES TTmab-movto-event
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-movto-event
&Scoped-Define DISPLAYED-OBJECTS cDescEmp cDescEqpto iDias cDescMotorista ~
cDescUn cDescEvent fi-cod-unid-negoc cDescTpManut cDescSubSist cDescOfic ~
fi-cod-emitente 

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

DEFINE BUTTON btMatriz 
     IMAGE-UP FILE "image/im-negoc.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-negoc.bmp":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Matriz Unidade Neg¢cio".

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

DEFINE VARIABLE cDescEmp AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE cDescEqpto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE cDescEvent AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE cDescMotorista AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 25.29 BY .88 NO-UNDO.

DEFINE VARIABLE cDescOfic AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE cDescSubSist AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE cDescTpManut AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 40.86 BY .88 NO-UNDO.

DEFINE VARIABLE cDescUn AS CHARACTER FORMAT "xx" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE fi-cod-emitente AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-unid-negoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE iDias AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 999999 
     LABEL "Dias" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69 BY 3.21.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48.86 BY 1.75.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 30.14 BY 3.

DEFINE RECTANGLE RECT-38
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32 BY 3.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.54.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


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
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     TTmab-movto-event.num-docto AT ROW 3 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-movto-event.dat-inicial AT ROW 3 COL 28.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-movto-event.hra-inicial AT ROW 3 COL 54 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-movto-event.cod-usuar AT ROW 3 COL 75 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     TTmab-movto-event.ep-codigo AT ROW 4.42 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     cDescEmp AT ROW 4.42 COL 15.14 COLON-ALIGNED NO-LABEL
     TTmab-movto-event.cod-eqpto AT ROW 5.42 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     cDescEqpto AT ROW 5.42 COL 26 COLON-ALIGNED NO-LABEL
     iDias AT ROW 5.58 COL 67.86 COLON-ALIGNED
     TTmab-movto-event.ep-codigo-matr AT ROW 6.38 COL 10 COLON-ALIGNED
          LABEL "Motorista":R9
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-movto-event.cod-estabel-matr AT ROW 6.38 COL 15.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-movto-event.cod-matr AT ROW 6.38 COL 20.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cDescMotorista AT ROW 6.38 COL 30.57 COLON-ALIGNED NO-LABEL
     TTmab-movto-event.val-km-aviso AT ROW 6.54 COL 67.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cDescUn AT ROW 6.54 COL 78 COLON-ALIGNED HELP
          "Unidade do contador do equipamento" NO-LABEL
     TTmab-movto-event.cod-evento AT ROW 7.33 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     cDescEvent AT ROW 7.33 COL 18.14 COLON-ALIGNED NO-LABEL
     btMatriz AT ROW 8.17 COL 85
     fi-cod-unid-negoc AT ROW 8.25 COL 78 COLON-ALIGNED
     TTmab-movto-event.val-evento AT ROW 8.33 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     TTmab-movto-event.cd-tipo AT ROW 9.33 COL 10 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     cDescTpManut AT ROW 9.33 COL 15.29 COLON-ALIGNED NO-LABEL
     TTmab-movto-event.ct-despesa AT ROW 9.75 COL 67 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 20 BY .79
     TTmab-movto-event.cod-sub-sist AT ROW 10.33 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     cDescSubSist AT ROW 10.33 COL 18.14 COLON-ALIGNED NO-LABEL
     TTmab-movto-event.cc-despesa AT ROW 10.63 COL 67 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 20 BY .79
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.38
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage0
     TTmab-movto-event.cod-ofici AT ROW 11.33 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     cDescOfic AT ROW 11.33 COL 18.14 COLON-ALIGNED NO-LABEL
     fi-cod-emitente AT ROW 11.5 COL 67 COLON-ALIGNED
     TTmab-movto-event.dsl-obs AT ROW 13.33 COL 12 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 800 SCROLLBAR-VERTICAL
          SIZE 66 BY 2.04
     TTmab-movto-event.dat-final AT ROW 16.79 COL 19.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-movto-event.hra-final AT ROW 16.79 COL 45.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     "Usu rio:" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 3.17 COL 70.57
     "Data:" VIEW-AS TEXT
          SIZE 4 BY .79 AT ROW 16.79 COL 17.43
     "Execu‡Æo:" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 16.04 COL 13
     "Tipo Manut." VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 9.5 COL 3.57
     "Hora:" VIEW-AS TEXT
          SIZE 4 BY .54 AT ROW 16.96 COL 42.86
     "Observa‡äes" VIEW-AS TEXT
          SIZE 10.57 BY .54 AT ROW 12.46 COL 13
     "Avisar Ap¢s:" VIEW-AS TEXT
          SIZE 8.57 BY .54 AT ROW 4.5 COL 59.86
     "Hora:" VIEW-AS TEXT
          SIZE 4 BY .54 AT ROW 3.17 COL 51.72
     RECT-17 AT ROW 12.75 COL 10.57
     RECT-18 AT ROW 16.25 COL 10.72
     RECT-19 AT ROW 4.79 COL 59
     RECT-38 AT ROW 9.5 COL 58.72
     rtParent AT ROW 2.71 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.38
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: TTmab-movto-event T "?" NO-UNDO movfro mab-movto-event
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
         TITLE              = "Consulta Apontamento de Eventos"
         HEIGHT             = 17.17
         WIDTH              = 90
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.21
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
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN TTmab-movto-event.ep-codigo-matr IN FRAME fPage0
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail /* Consulta Apontamento de Eventos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail /* Consulta Apontamento de Eventos */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
                       INPUT INPUT FRAME fPage0 {&ttParent}.dat-inicial).

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
   {method/zoomreposition.i &ProgramZoom="frzoom~\z01fr059.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cDescUn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cDescUn wMasterDetail
ON LEAVE OF cDescUn IN FRAME fPage0
DO:
  FOR FIRST mab-eqpto FIELDS (cod-eqpto ep-codigo cod-model)
      WHERE mab-eqpto.ep-codigo = &IF "{&mguni_version}" >= "2.071" &THEN TTmab-movto-event.ep-codigo:SCREEN-VALUE IN FRAME fPage0 &else int(TTmab-movto-event.ep-codigo:SCREEN-VALUE IN FRAME fPage0) &ENDIF 
      AND   mab-eqpto.cod-eqpto = TTmab-movto-event.cod-eqpto:SCREEN-VALUE IN FRAME fPage0 NO-LOCK,
      FIRST mab-model FIELDS (cod-model un) 
            WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:
            ASSIGN cDescUn  = mab-model.un.
            DISP cDescUn WITH FRAME fPage0.
      
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*--- L¢gica para inicializa‡Æo do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{utp/ut-liter.i "Percurso" MAB}
ASSIGN {&ttParent}.val-km-aviso:LABEL IN FRAME fPage0 = RETURN-VALUE.

{utp/ut-liter.i Conta }
ASSIGN {&ttParent}.ct-despesa:LABEL IN FRAME fPage0 = RETURN-VALUE.

{utp/ut-liter.i Centro_Custo }
ASSIGN {&ttParent}.cc-despesa:LABEL IN FRAME fPage0 = RETURN-VALUE.

ASSIGN  cEmpresaEstab = INPUT FRAME fPage0 {&ttParent}.ep-codigo
        dDada         = INPUT FRAME fPage0 {&ttParent}.dat-inicial.

IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.  
IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT cEmpresaEstab,  /* EMPRESA EMS2 */
                                               INPUT "",          /* PLANO CCUSTO */
                                               INPUT dDada,               /* DATA DE TRANSACAO */
                                               OUTPUT p_cod_format_ccusto,      /* FORMATO CCUSTO */
                                               OUTPUT TABLE tt_log_erro). /* ERROS */


RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT cEmpresaEstab,
                                                   INPUT "",
                                                   INPUT dDada,
                                                   OUTPUT p_cod_format_cta_ctbl,
                                                   OUTPUT TABLE tt_log_erro).

IF VALID-HANDLE(h_api_ccusto) THEN DELETE OBJECT h_api_ccusto.
IF VALID-HANDLE(h_api_ccusto) THEN DELETE OBJECT h_api_ccusto.

{cdp/cdunif001b.i}

ASSIGN TTmab-movto-event.ct-despesa:FORMAT IN FRAME fPage0 = p_cod_format_cta_ctbl
       TTmab-movto-event.cc-despesa:FORMAT IN FRAME fPage0 = p_cod_format_ccusto.


    /*campo observacao com rolagem habilitada*/
    ASSIGN TTmab-movto-event.dsl-obs:READ-ONLY IN FRAME fPage0 = YES    
           TTmab-movto-event.dsl-obs:SENSITIVE IN FRAME fPage0 = YES.        
    
    disable TTmab-movto-event.ct-despesa     with frame fPage0.
    disable TTmab-movto-event.cc-despesa  with frame fPage0.

IF AVAIL TTmab-movto-event THEN DO:

    ASSIGN TTmab-movto-event.ep-codigo:SCREEN-VALUE IN FRAME fPage0     = string(TTmab-movto-event.ep-codigo)
           TTmab-movto-event.cod-eqpto:SCREEN-VALUE IN FRAME fPage0     = TTmab-movto-event.cod-eqpto   
           TTmab-movto-event.cod-evento:SCREEN-VALUE IN FRAME fPage0    = TTmab-movto-event.cod-evento  
           TTmab-movto-event.cod-ofici:SCREEN-VALUE IN FRAME fPage0     = TTmab-movto-event.cod-ofici 
           TTmab-movto-event.cod-sub-sist:SCREEN-VALUE IN FRAME fPage0  = TTmab-movto-event.cod-sub-sist 
           TTmab-movto-event.cd-tipo:SCREEN-VALUE IN FRAME fPage0       = string(TTmab-movto-event.cd-tipo)
           TTmab-movto-event.cod-usuar:SCREEN-VALUE IN FRAME fPage0     = TTmab-movto-event.cod-usuar
           TTmab-movto-event.dat-final:SCREEN-VALUE IN FRAME fPage0     = string(TTmab-movto-event.dat-final)
           TTmab-movto-event.dat-inicial:SCREEN-VALUE IN FRAME fPage0   = string(TTmab-movto-event.dat-inicial)
           TTmab-movto-event.dsl-obs:SCREEN-VALUE IN FRAME fPage0       = TTmab-movto-event.dsl-obs
           TTmab-movto-event.num-docto:SCREEN-VALUE IN FRAME fPage0     = string(TTmab-movto-event.num-docto) 
           TTmab-movto-event.val-km-aviso:SCREEN-VALUE IN FRAME fPage0  = string(TTmab-movto-event.val-km-aviso)
           TTmab-movto-event.hra-final:SCREEN-VALUE IN FRAME fPage0     = TTmab-movto-event.hra-final
           TTmab-movto-event.hra-inicial:SCREEN-VALUE IN FRAME fPage0   = TTmab-movto-event.hra-inicial
           TTmab-movto-event.val-evento:SCREEN-VALUE IN FRAME fPage0    = string(TTmab-movto-event.val-evento)
           TTmab-movto-event.cod-matr:SCREEN-VALUE IN FRAME fPage0      = string(TTmab-movto-event.cod-matr).

    FOR FIRST empresa FIELDS(ep-codigo nome) WHERE 
              empresa.ep-codigo = TTmab-movto-event.ep-codigo NO-LOCK:
        ASSIGN cDescEmp = empresa.nome.
        DISP cDescEmp WITH FRAME fPage0.
    END.

    for first mab-eqpto fields(cod-model)
        where mab-eqpto.ep-codigo = TTmab-movto-event.ep-codigo
        and   mab-eqpto.cod-eqpto = TTmab-movto-event.cod-eqpto no-lock:
        for first mab-model fields(des-model cod-model)
            where mab-model.cod-model = mab-eqpto.cod-model no-lock:
            assign cDescEqpto = mab-model.des-model.
            disp cDescEqpto with frame fPage0.
             apply "LEAVE":U to cDescUn in frame fPage0.
        end.
    end.

      
    FOR FIRST mab-event FIELDS(des-evento cod-evento ) WHERE 
               mab-event.cod-evento  = TTmab-movto-event.cod-evento:SCREEN-VALUE IN FRAME fPage0 NO-LOCK:
        ASSIGN cDescEvent = mab-event.des-evento.
        DISP cDescEvent WITH FRAME fPage0.
    END.


    IF INPUT FRAME fPage0 TTmab-movto-event.cod-ofici <> "" THEN DO:
       FOR FIRST mmv-ofici FIELDS(des-ofici cod-ofici ) WHERE 
               mmv-ofici.cod-ofici  = INPUT FRAME fPage0 TTmab-movto-event.cod-ofici NO-LOCK:
              ASSIGN cDescOfic = mmv-ofici.des-ofici.
              DISP cDescOfic WITH FRAME fPage0.
         END.
     END.
     ELSE DO:
         ASSIGN cDescOfic = "".
         DISP cDescOfic WITH FRAME fPage0.
     END.

       IF INPUT FRAME fPage0 TTmab-movto-event.cod-matr <> "" THEN DO:
       FOR FIRST mab-motoris FIELDS(nom-motoris cod-matr ) WHERE 
               mab-motoris.cod-matr  = INPUT FRAME fPage0 TTmab-movto-event.cod-matr NO-LOCK:
              ASSIGN cDescMotorista = mab-motoris.nom-motoris.
              DISP cDescMotorista WITH FRAME fPage0.
         END.
     END.
     ELSE DO:
         ASSIGN cDescMotorista = "".
         DISP cDescMotorista WITH FRAME fPage0.
     END.

    FOR FIRST mab-sub-sist FIELDS(des-sub-sist cod-sub-sist ) WHERE
              mab-sub-sist.cod-sub-sist  =  TTmab-movto-event.cod-sub-sist:SCREEN-VALUE IN FRAME fPage0 NO-LOCK:
        ASSIGN cDescSubSist = mab-sub-sist.des-sub-sist.
        DISP cDescSubSist WITH FRAME fPage0.
    END.

    IF INPUT FRAME fPage0 TTmab-movto-event.cd-tipo <> 0 THEN DO:
       FOR FIRST tipo-manut  FIELDS (descricao cd-tipo) 
           WHERE tipo-manut.cd-tipo = INPUT FRAME fPage0 TTmab-movto-event.cd-tipo NO-LOCK:
                 ASSIGN cDescTpManut = tipo-manut.descricao.
                 DISP cDescTpManut WITH FRAME fPage0.
        END.
    END.
    ELSE DO:
           ASSIGN cDescTpManut = "".
           DISP cDescTpManut WITH FRAME fPage0.
    END.

    ASSIGN iDias = TTmab-movto-event.dat-aviso - INPUT FRAME fPage0 TTmab-movto-event.dat-inicial.
    DISP iDias WITH FRAME fPage0.
    /*** Busca valores da conta e sub-conta****/
    run pi-busca-conta in this-procedure.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN DO:
            ASSIGN fi-cod-unid-negoc:SCREEN-VALUE IN FRAME fPage0 = TTmab-movto-event.cod-unid-negoc.
            /** Habilita/Desabilita botao Matriz de Unidade Negocio **/
            RUN piValidaMatriz IN THIS-PROCEDURE.
        END.
    &ENDIF
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{utp/ut-liter.i "Emitente"}
assign fi-cod-emitente:label in frame fPage0 = trim(return-value).

  FOR FIRST empresa FIELDS(ep-codigo nome) WHERE 
              empresa.ep-codigo = TTmab-movto-event.ep-codigo NO-LOCK:
        ASSIGN cDescEmp = empresa.nome.
        DISP cDescEmp WITH FRAME fPage0.

    END.

    for first mab-eqpto fields(cod-model)
        where mab-eqpto.ep-codigo = TTmab-movto-event.ep-codigo
        and   mab-eqpto.cod-eqpto = TTmab-movto-event.cod-eqpto no-lock:
        for first mab-model fields(des-model cod-model)
            where mab-model.cod-model = mab-eqpto.cod-model no-lock:
            assign cDescEqpto = mab-model.des-model.
            disp cDescEqpto with frame fPage0.
        end.
    end.

     FOR FIRST mab-event FIELDS(des-evento cod-evento ) WHERE 
               mab-event.cod-evento  = TTmab-movto-event.cod-evento:SCREEN-VALUE IN FRAME fPage0 NO-LOCK:
        ASSIGN cDescEvent = mab-event.des-evento.
        DISP cDescEvent WITH FRAME fPage0.

    END.
    
     IF INPUT FRAME fPage0 TTmab-movto-event.cod-ofici <> "" THEN DO:
       FOR FIRST mmv-ofici FIELDS(des-ofici cod-ofici ) WHERE 
               mmv-ofici.cod-ofici  = INPUT FRAME fPage0 TTmab-movto-event.cod-ofici NO-LOCK:
              ASSIGN cDescOfic = mmv-ofici.des-ofici.
              DISP cDescOfic WITH FRAME fPage0.
         END.
     END.
     ELSE DO:
         ASSIGN cDescOfic = "".
         DISP cDescOfic WITH FRAME fPage0.
     END.

       IF INPUT FRAME fPage0 TTmab-movto-event.cod-matr <> "" THEN DO:
       FOR FIRST mab-motoris FIELDS(nom-motoris cod-matr ) WHERE 
               mab-motoris.cod-matr  = INPUT FRAME fPage0 TTmab-movto-event.cod-matr NO-LOCK:
              ASSIGN cDescMotorista = mab-motoris.nom-motoris.
              DISP cDescMotorista WITH FRAME fPage0.
         END.
     END.
     ELSE DO:
         ASSIGN cDescMotorista = "".
         DISP cDescMotorista WITH FRAME fPage0.
     END.
    
    IF INPUT FRAME fPage0 TTmab-movto-event.cd-tipo <> 0 THEN DO:
       FOR FIRST tipo-manut  FIELDS (descricao cd-tipo) 
           WHERE tipo-manut.cd-tipo = INPUT FRAME fPage0 TTmab-movto-event.cd-tipo NO-LOCK:
                 ASSIGN cDescTpManut = tipo-manut.descricao.
                 DISP cDescTpManut WITH FRAME fPage0.
        END.
    END.
    ELSE DO:
           ASSIGN cDescTpManut = "".
           DISP cDescTpManut WITH FRAME fPage0.
    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMasterDetail 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var iDoc like TTmab-movto-event.num-docto no-undo.

/** Verifica se j  existe documento cadastrado para equipamento com o mesmo evento **/
RUN consisteInclusaoDocto in {&hDBOParent} (INPUT  INPUT FRAME fPage0 TTmab-movto-event.ep-codigo,
                                            INPUT  INPUT FRAME fPage0 TTmab-movto-event.cod-eqpto,
                                            INPUT  INPUT FRAME fPage0 TTmab-movto-event.cod-evento,
                                            output iDoc).
/** Pergunta para incluir documento duplicado **/
IF RETURN-VALUE <> "NOK":U THEN DO:
    RUN utp/ut-msgs.p (INPUT "show":U,
                       INPUT 28493,
                       INPUT bfMovtoEvento.cod-eqpto + '~~' + STRING(iDoc)).
    IF RETURN-VALUE = "NO":U THEN
        RETURN "NOK":U.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
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
    
   DEFINE VARIABLE iNrDoc LIKE {&ttParent}.num-docto
           VIEW-AS FILL-IN SIZE 16.00 BY 0.88 NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        iNrDoc  AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para o Documento" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_o_Documento"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN iNrDoc.
        
        /* Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT iNrDoc).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Documento" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            
            RETURN NO-APPLY.
        END.
        
        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE iNrDoc  btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "frbo~\bofr059.p":U THEN DO:
        RUN  frbo~/bofr059.p PERSISTENT SET  {&hDBOParent}.
    END.
  
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.
 
    
    /*:T--- Verifica se o DBO de Eventos j  est  inicializado ---*/
    IF NOT VALID-HANDLE(hDBOEvent) OR
       hDBOEvent:TYPE <> "PROCEDURE":U OR
       hDBOEvent:FILE-NAME <> "frbo/bofr010.p":U THEN DO:
        run "frbo/bofr010.p" persistent set hDBOEvent.
    END.

    RUN openQueryStatic IN hDBOEvent (INPUT "Main":U) NO-ERROR.

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
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-conta wMasterDetail 
PROCEDURE pi-busca-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEFINE VARIABLE l-int-ap AS LOGICAL initial no   NO-UNDO.
DEFINE VARIABLE cConta   AS character format "x(30)" NO-UNDO.
 run gotokey in hDBOEvent (input input frame fPage0 {&ttParent}.cod-evento).
 if return-value <> "NOK":U then do:
    run getLogField in hDBOEvent (input "log-integr-ap":U, output l-int-ap).
     /**** Verifica se evento integra com Contas  a Pagar***/
    if l-int-ap then do:

      assign TTmab-movto-event.ct-despesa:HIDDEN          in frame fpage0 = NO
             TTmab-movto-event.cc-despesa:HIDDEN       in frame fpage0 = NO
             fi-cod-emitente:HIDDEN  IN FRAME fPage0 = NO. 
      DISP rect-38 WITH FRAME fPage0.

      assign fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0 = STRING({&ttParent}.num-livre-1).
    end.
    /*** SenÆo desabilita os campos e joga branco***/
    else do:
          assign TTmab-movto-event.ct-despesa:screen-value         in frame fpage0    = "":U  
                 TTmab-movto-event.cc-despesa:screen-value      in frame fpage0 = "":U
                 fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0 = "":U
                 TTmab-movto-event.ct-despesa:HIDDEN          in frame fpage0 = YES
                 TTmab-movto-event.cc-despesa:HIDDEN       in frame fpage0 = YES
                 fi-cod-emitente:HIDDEN  IN FRAME fPage0 = YES. 
          HIDE rect-38 IN FRAME fPage0.
    end.
 end.

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
            RUN piRetornaUnidNegoc IN hDBOHistor (INPUT  {&ttParent}.ep-codigo,
                                                  INPUT  {&ttParent}.cod-eqpto,
                                                  INPUT  {&ttParent}.dat-inicial,
                                                  OUTPUT cUnidNegoc,
                                                  OUTPUT lTemMatriz,
                                                  OUTPUT TABLE tt-unid-negoc-histor).

            ASSIGN btMatriz:SENSITIVE IN FRAME fPage0 = lTemMatriz.
        END.
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMasterDetail 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF VALID-HANDLE (hDBOHistor) THEN
   DELETE PROCEDURE hDBOHistor.
    
IF VALID-HANDLE (h_api_cta_ctbl) THEN
   DELETE PROCEDURE h_api_cta_ctbl.  

IF VALID-HANDLE (hDBOEvent) THEN
   DELETE PROCEDURE hDBOEvent.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
