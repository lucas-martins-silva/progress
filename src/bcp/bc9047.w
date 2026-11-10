&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgscm            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9047 2.00.00.004 } /*** "010004" 03/07/2023 10:43:21  ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BC9047 MBM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        bc9047.w
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   ""
&GLOBAL-DEFINE page0Widgets   c-cod-estabel c-desc-estabel c-cod-local ~
                              c-desc-local c-id-box-ini c-id-box-fim c-Cod-bloco-ini c-Cod-bloco-fim ~
                              c-Cod-rua-ini c-Cod-rua-fim c-Cod-nivel-ini c-Cod-nivel-fim ~
                              c-Cod-coluna-ini c-Cod-coluna-fim cb-lado-ini cb-lado-fim rs-classif ~
                              btQueryJoins btReportsJoins btExit btHelp ~
                              btImprime
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE NEW GLOBAL SHARED VAR c-seg-usuario as char format "x(12)" no-undo.

{bcp/bcapi002.i}    /*** Definicao da temp-table para a API de criacao de etiquetas tt-etiqueta ***/
{bcp/bcapi001.i}    /* Definicao da temp-table de transacoes    */
{cdp/cd0666.i}      /* Definicao da temp-table de erros         */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-bosc047           AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-bosc041           AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-acomp             AS HANDLE       NO-UNDO.
DEFINE VARIABLE hApiImpressao       AS HANDLE       NO-UNDO.
DEFINE VARIABLE c-lista             AS CHAR         NO-UNDO.
DEFINE VARIABLE i-cont              AS INT          NO-UNDO.
DEFINE VARIABLE cCdTrans            AS CHARACTER INITIAL "WMOut012" NO-UNDO.
DEFINE VARIABLE c-etiq-impressa     AS INTEGER      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-1 RECT-2 IMAGE-13 ~
IMAGE-14 IMAGE-15 IMAGE-16 IMAGE-17 IMAGE-18 IMAGE-53 IMAGE-54 IMAGE-55 ~
IMAGE-56 RECT-17 RECT-21 IMAGE-11 IMAGE-12 btQueryJoins btReportsJoins ~
btExit btHelp c-cod-estabel c-desc-estabel c-cod-local c-desc-local ~
c-id-box-ini c-id-box-fim c-Cod-bloco-ini c-Cod-bloco-fim c-Cod-rua-ini ~
c-Cod-rua-fim c-Cod-nivel-ini c-Cod-nivel-fim c-Cod-coluna-ini ~
c-Cod-coluna-fim cb-lado-ini cb-lado-fim rs-classif btImprime 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estabel c-desc-estabel c-cod-local ~
c-desc-local c-id-box-ini c-id-box-fim c-Cod-bloco-ini c-Cod-bloco-fim ~
c-Cod-rua-ini c-Cod-rua-fim c-Cod-nivel-ini c-Cod-nivel-fim ~
c-Cod-coluna-ini c-Cod-coluna-fim cb-lado-ini cb-lado-fim rs-classif 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
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

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btImprime 
     LABEL "Imprimir" 
     SIZE 10 BY 1.

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

DEFINE VARIABLE cb-lado-fim AS CHARACTER FORMAT "X(10)":U 
     VIEW-AS COMBO-BOX INNER-LINES 2
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE cb-lado-ini AS CHARACTER FORMAT "X(10)":U 
     LABEL "Lado" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE c-Cod-bloco-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-Cod-bloco-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Bloco" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-Cod-coluna-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-Cod-coluna-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Coluna" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-cod-estabel LIKE wm-estabel.cod-estabel
     LABEL "Estabelecimento":R18 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-local AS CHARACTER FORMAT "X(3)" 
     LABEL "Local":R7 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-Cod-nivel-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-Cod-nivel-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "N¡vel" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-Cod-rua-fim AS CHARACTER FORMAT "x(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-Cod-rua-ini AS CHARACTER FORMAT "x(3)":U 
     LABEL "Rua" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-local AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-id-box-fim AS DECIMAL FORMAT ">>>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-id-box-ini AS DECIMAL FORMAT ">>>>>>>>>9":U INITIAL 0 
     LABEL "ID Endere‡o" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-fir":U
     SIZE 3 BY .88. 

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-53
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-54
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-55
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-56
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-classif AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Nivel/Coluna", 1,
"Coluna/N¡vel", 2
     SIZE 39 BY .83 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 2.75.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 2.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 6.58.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 1.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 79 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 79 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 63.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 67.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 71.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 75.72 HELP
          "Ajuda"
     c-cod-estabel AT ROW 3.08 COL 16.57 COLON-ALIGNED HELP
          "C¢digo do estabelecimento." 
          LABEL "Estabelecimento":R18
     c-desc-estabel AT ROW 3.08 COL 25.14 COLON-ALIGNED NO-LABEL 
     c-cod-local AT ROW 4.08 COL 16.57 COLON-ALIGNED HELP
          "C¢digo do Local." 
     c-desc-local AT ROW 4.08 COL 23.14 COLON-ALIGNED NO-LABEL 
     c-id-box-ini AT ROW 5.92 COL 29.72 RIGHT-ALIGNED HELP
          "Identificador £nico do box." 
     c-id-box-fim AT ROW 5.92 COL 49 HELP
          "Identificador £nico do box." NO-LABEL 
     c-Cod-bloco-ini AT ROW 6.96 COL 29.72 RIGHT-ALIGNED HELP
          "C¢digo do bloco no WMS." 
     c-Cod-bloco-fim AT ROW 6.96 COL 49 HELP
          "C¢digo do bloco no WMS." NO-LABEL 
     c-Cod-rua-ini AT ROW 7.96 COL 29.72 RIGHT-ALIGNED HELP
          "C¢digo da rua no WMS." 
     c-Cod-rua-fim AT ROW 7.96 COL 49 HELP
          "C¢digo da rua no WMS." NO-LABEL 
     c-Cod-nivel-ini AT ROW 8.96 COL 29.72 RIGHT-ALIGNED HELP
          "C¢digo do n¡vel do WMS" 
     c-Cod-nivel-fim AT ROW 8.96 COL 49 HELP
          "C¢digo do n¡vel do WMS" NO-LABEL 
     c-Cod-coluna-ini AT ROW 9.96 COL 29.72 RIGHT-ALIGNED HELP
          "C¢digo da coluna no WMS" 
     c-Cod-coluna-fim AT ROW 9.96 COL 49 HELP
          "C¢digo da coluna no WMS" NO-LABEL 
     cb-lado-ini AT ROW 10.96 COL 29.72 RIGHT-ALIGNED 
     cb-lado-fim AT ROW 10.96 COL 49 NO-LABEL 
     rs-classif AT ROW 13.25 COL 20.86 NO-LABEL 
     btImprime AT ROW 14.83 COL 2
     "Classifica‡Æo" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 12.63 COL 20.86 
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 14.63 COL 1
     RECT-1 AT ROW 2.58 COL 1 
     RECT-2 AT ROW 5.54 COL 1 
     IMAGE-13 AT ROW 6.96 COL 31.86 
     IMAGE-14 AT ROW 6.96 COL 44.86 
     IMAGE-15 AT ROW 7.96 COL 31.86 
     IMAGE-16 AT ROW 7.96 COL 44.86 
     IMAGE-17 AT ROW 8.96 COL 31.86 
     IMAGE-18 AT ROW 8.96 COL 44.86 
     IMAGE-53 AT ROW 9.96 COL 31.86 
     IMAGE-54 AT ROW 9.96 COL 44.86 
     IMAGE-55 AT ROW 10.96 COL 31.86 
     IMAGE-56 AT ROW 10.96 COL 44.86 
     RECT-17 AT ROW 12.38 COL 1 
     RECT-21 AT ROW 12.88 COL 19 
     IMAGE-11 AT ROW 5.92 COL 31.86 
     IMAGE-12 AT ROW 5.92 COL 44.86 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 79.14 BY 15.08
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 15.13
         WIDTH              = 79
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 93.29
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 93.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-Cod-bloco-fim IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-Cod-bloco-ini IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN c-Cod-coluna-fim IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-Cod-coluna-ini IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME fpage0
   LIKE = mgscm.wm-estabel.cod-estabel EXP-LABEL EXP-SIZE               */
/* SETTINGS FOR FILL-IN c-Cod-nivel-fim IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-Cod-nivel-ini IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN c-Cod-rua-fim IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-Cod-rua-ini IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN c-id-box-fim IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-id-box-ini IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR COMBO-BOX cb-lado-fim IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX cb-lado-ini IN FRAME fpage0
   ALIGN-R                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btImprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImprime wWindow
ON CHOOSE OF btImprime IN FRAME fpage0 /* OK */
DO:
    run pi-imprime.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wWindow
ON F5 OF c-cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc047.w"
                     &FieldZoom1="cod-local"
                     &FieldScreen1="c-cod-local"
                     &Frame1="fPage0"
                     &FieldZoom2="nom-local"
                     &FieldScreen2="c-desc-local"
                     &Frame2="fPage0"
                     &FieldZoom3="cod-estabel"
                     &FieldScreen3="c-cod-estabel"
                     &Frame3="fPage0"
                     &FieldZoom4="nom-estabel"
                     &FieldScreen4="c-desc-estabel"
                     &Frame4="fPage0"
                     &EnableImplant="no"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wWindow
ON LEAVE OF c-cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    {method/ReferenceFields.i
       &HandleDBOLeave="h-bosc041"
       &KeyValue1="c-cod-estabel:SCREEN-VALUE IN FRAME fPage0"
       &FieldName1="nom-estabel"
       &FieldScreen1="c-desc-estabel"
       &Frame1="fPage0"}

     RUN getNomEstabel IN h-bosc047 (INPUT  c-cod-estabel:screen-value IN FRAME fPage0,
                                     OUTPUT c-desc-estabel).
     IF  RETURN-VALUE = "OK":U THEN
         DISPLAY c-desc-estabel WITH FRAME fPage0.
     ELSE
         ASSIGN c-desc-estabel:screen-value IN FRAME fPage0 = "":U.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    APPLY "F5":U TO SELF.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-local
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-local wWindow
ON F5 OF c-cod-local IN FRAME fpage0 /* Local */
DO:
    {method/zoomfields.i &ProgramZoom="sczoom/z01sc047.w"
                      &FieldZoom1="cod-local"
                      &FieldScreen1="c-cod-local"
                      &Frame1="fPage0"
                      &FieldZoom2="nom-local"
                      &FieldScreen2="c-desc-local"
                      &Frame2="fPage0"
                      &FieldZoom3="cod-estabel"
                      &FieldScreen3="c-cod-estabel"
                      &Frame3="fPage0"
                      &FieldZoom4="nom-estabel"
                      &FieldScreen4="c-desc-estabel"
                      &Frame4="fPage0"
                     &EnableImplant="no"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-local wWindow
ON LEAVE OF c-cod-local IN FRAME fpage0 /* Local */
DO:
    {method/ReferenceFields.i
        &HandleDBOLeave="h-bosc047"
        &KeyValue1="c-cod-estabel:SCREEN-VALUE IN FRAME fPage0"
        &KeyValue2="c-cod-local:SCREEN-VALUE IN FRAME fPage0"
        &FieldName1="nom-local"
        &FieldScreen1="c-desc-local"
        &Frame1="fPage0"}

      RUN getNomLocal IN h-bosc047 (INPUT c-cod-estabel:screen-value IN FRAME fPage0,   
                                    INPUT c-cod-local:screen-value   IN FRAME fPage0,
                                    OUTPUT c-desc-local).
      IF  RETURN-VALUE = "OK":U THEN
          DISPLAY c-desc-local WITH FRAME fPage0.
      ELSE
          ASSIGN c-desc-local:screen-value IN FRAME fPage0 = "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-local wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cod-local IN FRAME fpage0 /* Local */
DO:
    APPLY "F5":U TO SELF.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
c-cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPage0.
c-cod-local:LOAD-MOUSE-POINTER("image/lupa.cur":U)     IN FRAME fPage0.

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR pcod-estabel LIKE wm-local.cod-estabel NO-UNDO.
    DEF VAR pcod-local   LIKE wm-local.cod-local   NO-UNDO.
    
    RUN initializeDBOs.
    
    RUN getEstabelLocalPad IN h-bosc047 (OUTPUT pcod-estabel,
                                         OUTPUT pcod-local).
    
    ASSIGN c-cod-estabel:screen-value       IN FRAME fPage0 = pcod-estabel 
           c-cod-local:screen-value         IN FRAME fPage0 = pcod-local   
           c-desc-estabel:sensitive          IN FRAME fPage0 = NO           
           c-desc-local:sensitive            IN FRAME fPage0 = NO.
    
    APPLY "LEAVE" TO c-cod-estabel IN FRAME fPage0.
    APPLY "LEAVE" TO c-cod-local   IN FRAME fPage0.
    
    DISABLE c-desc-estabel
            c-desc-local WITH FRAME fPage0.
    
    /* Descri‡Æo do Lado */
    ASSIGN c-lista = "".
    DO i-cont = 1 TO NUM-ENTRIES({scinc/i02sc030.i  03}):
       ASSIGN c-lista = c-lista + ENTRY(i-cont, {scinc/i02sc030.i  03}) + "," + ENTRY(i-cont, {scinc/i02sc030.i  03})  + ",".
    END.
    ASSIGN c-lista = SUBSTRING(c-lista, 1, LENGTH(c-lista) - 1).

    ASSIGN cb-lado-ini:LIST-ITEM-PAIRS IN FRAME fPage0 = c-lista
           cb-lado-fim:LIST-ITEM-PAIRS IN FRAME fPage0 = c-lista.

    ASSIGN cb-lado-ini:SCREEN-VALUE IN FRAME fPage0 = {scinc/i02sc030.i 04 1}
           cb-lado-fim:SCREEN-VALUE IN FRAME fPage0 = {scinc/i02sc030.i 04 2}.

    APPLY "entry" TO c-cod-estabel IN FRAME fPage0.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-bosc041) THEN
        RUN scbo/bosc041.p PERSISTENT SET h-bosc041.
    RUN openQueryStatic IN h-bosc041 (INPUT "Main":U).      
    
    IF NOT VALID-HANDLE(h-bosc047) THEN
        RUN scbo/bosc047.p PERSISTENT SET h-bosc047.
    RUN openQueryStatic IN h-bosc047 (INPUT "Main":U).      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroyInterface wWindow 
PROCEDURE beforeDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(h-bosc041) THEN
        RUN destroy IN h-bosc041.

    IF VALID-HANDLE(h-bosc047) THEN
        RUN destroy IN h-bosc047.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-imprime wWindow 
PROCEDURE pi-imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-etiqueta.
    EMPTY TEMP-TABLE tt-trans.
    EMPTY TEMP-TABLE RowErrors. 
    
    run utp/ut-acomp.p persistent set h-acomp.
    {utp/ut-liter.i Gera‡Æo_Etiqueta_Endere‡os WMS *}
    run pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

    FIND FIRST bc-tipo-trans
        WHERE bc-tipo-trans.cd-trans = cCdTrans NO-LOCK NO-ERROR.

    ASSIGN c-etiq-impressa = 0.
    /*Classifica‡Æo por Nivel e Coluna*/
    IF INT(rs-classif:SCREEN-VALUE IN FRAME Fpage0) = 1 THEN DO:
        FOR EACH wm-box NO-LOCK
            WHERE wm-box.cod-estabel = c-cod-estabel:SCREEN-VALUE IN FRAME Fpage0
            AND   wm-box.cod-local   = c-cod-local:SCREEN-VALUE IN FRAME Fpage0
            AND   wm-box.id-box     >= INT (c-id-box-ini:SCREEN-VALUE IN FRAME Fpage0)
            AND   wm-box.id-box     <= INT (c-id-box-fim:SCREEN-VALUE IN FRAME Fpage0)  
            AND   wm-box.cod-bloco  >= c-cod-bloco-ini:SCREEN-VALUE IN FRAME Fpage0
            AND   wm-box.cod-bloco  <= c-cod-bloco-fim:SCREEN-VALUE IN FRAME Fpage0 
            AND   wm-box.cod-rua    >= c-cod-rua-ini:SCREEN-VALUE IN FRAME Fpage0   
            AND   wm-box.cod-rua    <= c-cod-rua-fim:SCREEN-VALUE IN FRAME Fpage0   
            AND   wm-box.cod-nivel  >= c-cod-nivel-ini:SCREEN-VALUE IN FRAME Fpage0 
            AND   wm-box.cod-nivel  <= c-cod-nivel-fim:SCREEN-VALUE IN FRAME Fpage0 
            AND   wm-box.cod-coluna >= c-cod-coluna-ini:SCREEN-VALUE IN FRAME Fpage0
            AND   wm-box.cod-coluna <= c-cod-coluna-fim:SCREEN-VALUE IN FRAME Fpage0
            AND ((IF cb-lado-ini:SCREEN-VALUE IN FRAME Fpage0 = "Esquerdo":U THEN 
                  wm-box.ind-posicao-box = 1 ELSE wm-box.ind-posicao-box = 2)    /* 1 - Esquerdo 2 - Direito */
              OR (IF cb-lado-fim:SCREEN-VALUE IN FRAME Fpage0 = "Esquerdo":U THEN 
                  wm-box.ind-posicao-box = 1 ELSE wm-box.ind-posicao-box = 2)) /* 1 - Esquerdo 2 - Direito */
            BY wm-box.cod-bloco
            BY wm-box.cod-rua
            BY wm-box.cod-nivel
            BY wm-box.cod-coluna: 
            /*Gera etiqueta endere‡o*/
            RUN pi-imprime-end.
        END.
    END.
    /*Classifica‡ao por Coluna e N¡vel*/
    IF INT(rs-classif:SCREEN-VALUE IN FRAME Fpage0) = 2 THEN DO:
        FOR EACH wm-box NO-LOCK
            WHERE wm-box.cod-estabel = c-cod-estabel:SCREEN-VALUE IN FRAME Fpage0
            AND   wm-box.cod-local   = c-cod-local:SCREEN-VALUE IN FRAME Fpage0
            AND   wm-box.id-box     >= INT (c-id-box-ini:SCREEN-VALUE IN FRAME Fpage0)
            AND   wm-box.id-box     <= INT (c-id-box-fim:SCREEN-VALUE IN FRAME Fpage0)  
            AND   wm-box.cod-bloco  >= c-cod-bloco-ini:SCREEN-VALUE IN FRAME Fpage0
            AND   wm-box.cod-bloco  <= c-cod-bloco-fim:SCREEN-VALUE IN FRAME Fpage0 
            AND   wm-box.cod-rua    >= c-cod-rua-ini:SCREEN-VALUE IN FRAME Fpage0   
            AND   wm-box.cod-rua    <= c-cod-rua-fim:SCREEN-VALUE IN FRAME Fpage0   
            AND   wm-box.cod-nivel  >= c-cod-nivel-ini:SCREEN-VALUE IN FRAME Fpage0 
            AND   wm-box.cod-nivel  <= c-cod-nivel-fim:SCREEN-VALUE IN FRAME Fpage0 
            AND   wm-box.cod-coluna >= c-cod-coluna-ini:SCREEN-VALUE IN FRAME Fpage0
            AND   wm-box.cod-coluna <= c-cod-coluna-fim:SCREEN-VALUE IN FRAME Fpage0
            AND ((IF cb-lado-ini:SCREEN-VALUE IN FRAME Fpage0 = "Esquerdo":U THEN 
                  wm-box.ind-posicao-box = 1 ELSE wm-box.ind-posicao-box = 2)    /* 1 - Esquerdo 2 - Direito */
              OR (IF cb-lado-fim:SCREEN-VALUE IN FRAME Fpage0 = "Esquerdo":U THEN 
                  wm-box.ind-posicao-box = 1 ELSE wm-box.ind-posicao-box = 2)) /* 1 - Esquerdo 2 - Direito */
            BY wm-box.cod-bloco
            BY wm-box.cod-rua
            BY wm-box.cod-coluna
            BY wm-box.cod-nivel:
            /*Gera etiqueta endere‡o*/
            RUN pi-imprime-end.
        END.
    END.
    /*Verifica se foi emitida alguma etiqueta*/
    IF c-etiq-impressa = 0 THEN DO:
        RUN piCriaErros IN THIS-PROCEDURE (INPUT 8057,
                                           INPUT "",
                                           INPUT "EMS":U,
                                           INPUT "ERROR":U).
    END.

    run pi-finalizar in h-acomp.

    FIND FIRST RowErrors NO-LOCK NO-ERROR.
    IF AVAIL RowErrors THEN DO:
        {method/showmessage.i1}        
        {method/showmessage.i2} 
        RETURN "NOK":U.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-imprime wWindow 
PROCEDURE pi-imprime-end :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-etiqueta.
    EMPTY TEMP-TABLE tt-trans.
    
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Gerando_Etiqueta_Endere‡o" *}
    run pi-acompanhar in h-acomp (input RETURN-VALUE + ":" + STRING(wm-box.id-box)).

    CREATE tt-etiqueta.
    ASSIGN tt-etiqueta.cod-versao-integracao = 1
           tt-etiqueta.i-sequen              = 1
           tt-etiqueta.qt-etiqueta           = 1
           tt-etiqueta.cd-trans              = cCdTrans
           tt-etiqueta.tipo-etiq             = bc-tipo-trans.tipo-etiq
           tt-etiqueta.usuario               = c-seg-usuario
           tt-etiqueta.quantidade            = 1
           tt-etiqueta.it-codigo             = ""
           tt-etiqueta.dt-impressao          = TODAY
           tt-etiqueta.hora-Impressao        = STRING(TIME,"HH:MM:SS")                                        
           tt-etiqueta.auxiliar-10           = STRING(wm-box.id-box,"9999999999")  
           tt-etiqueta.auxiliar-08           = wm-box.cod-bloco + "/" +
                                               wm-box.cod-rua   + "/" +
                                               wm-box.cod-nivel + "/" +
                                               wm-box.cod-coluna + "/" +
                                               {scinc/i02sc030.i 04 wm-box.ind-posicao-box}.
    /* Se estiver configurado, imprime  */
    CREATE tt-trans.
    assign tt-trans.cod-versao-integracao = 1
           tt-trans.i-sequen              = 1
           tt-trans.cd-trans              = cCdTrans
           tt-trans.usuario               = c-seg-usuario
           tt-trans.atualizada            = NO 
           tt-trans.etiqueta              = YES
           tt-trans.detalhe               = " Box: " + STRING(wm-box.id-box).
           
    IF NOT VALID-HANDLE(hApiImpressao) THEN
        RUN bcp/bcapiimp.p PERSISTENT SET hApiImpressao.
      
    RUN piSelecionaImpressora IN hApiImpressao ( INPUT c-seg-usuario).
   
    IF VALID-HANDLE(hApiImpressao) THEN DO:
        DELETE PROCEDURE hApiImpressao NO-ERROR.
        ASSIGN hApiImpressao = ?.
    END. 
    
    RAW-TRANSFER tt-etiqueta TO tt-trans.conteudo-trans.
    RUN bcp/bcapi001.p (INPUT-OUTPUT TABLE tt-trans,
                        INPUT-OUTPUT TABLE tt-erro).
    
    FIND FIRST tt-erro NO-ERROR.
    IF AVAIL tt-erro THEN DO:
        FOR EACH tt-erro NO-LOCK:
            RUN piCriaErros IN THIS-PROCEDURE (INPUT tt-erro.cd-erro,
                                               INPUT tt-erro.mensagem,
                                               INPUT "EMS":U,
                                               INPUT "ERROR":U).
        END.
    END.        
    ELSE DO:
        ASSIGN c-etiq-impressa = c-etiq-impressa + 1.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Etiqueta_Endere‡o_Impressa" *}
        run pi-acompanhar in h-acomp (input RETURN-VALUE + ": " + String(wm-box.id-box)).
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaErros wWindow 
PROCEDURE piCriaErros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pErrorNumber     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pErrorParameters AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorType       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorSubType    AS CHARACTER NO-UNDO.
   
    DEFINE VARIABLE i-sequencia AS INTEGER NO-UNDO.

    FIND LAST RowErrors NO-LOCK NO-ERROR.
    IF AVAIL RowErrors THEN
        ASSIGN i-sequencia = RowErrors.ErrorSequence + 1.
    ELSE    
        ASSIGN i-sequencia = 1.
    
    RUN utp/ut-msgs.p (INPUT "msg",
                       INPUT pErrorNumber,
                       INPUT pErrorParameters).  

    FIND FIRST RowErrors 
         WHERE RowErrors.ErrorDescription = RETURN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAIL RowErrors THEN DO:
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence    = i-sequencia
               RowErrors.ErrorNumber      = pErrorNumber
               RowErrors.ErrorParameters  = pErrorParameters
               RowErrors.ErrorType        = pErrorType
               RowErrors.ErrorSubType     = pErrorSubType
               RowErrors.ErrorDescription = RETURN-VALUE.

        RUN utp/ut-msgs.p (INPUT "help",
                           INPUT RowErrors.ErrorNumber,
                           INPUT RowErrors.ErrorParameters).  
        ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.
    END.
    
    RETURN "OK":U.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

