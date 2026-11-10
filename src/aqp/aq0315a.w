&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
          mgmov            PROGRESS
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
{include/i-prgvrs.i AQ0315A 2.00.00.015 } /*** 010015 ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aq0315a MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        aq0315a
&GLOBAL-DEFINE Version        2.00.00.015

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0widgets   c-cod-estabel-ini c-cod-estabel-fim c-cod-regiao-ini c-cod-regiao-fim ~
                              c-cod-rota-ini c-cod-rota-fim i-cdn-grp-produt-ini i-cdn-grp-produt-fim  ~
                              i-cdn-produt-rural-ini i-cdn-produt-rural-fim c-cod-propried-ini c-cod-propried-fim ~
                              tg-sit-todos tg-sit-pendente tg-sit-confirmada tg-sit-nf-gerada ~
                              IMAGE-7 IMAGE-8 IMAGE-9 IMAGE-10 IMAGE-11 IMAGE-12 IMAGE-13 IMAGE-14 IMAGE-15 ~
                              IMAGE-16 IMAGE-17 IMAGE-18 btOk btCancel btHelp2 


/* Parameters Definitions ---                                           */
{aqp/aq0315.i} /*tt-filtro*/
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-filtro.


/* Local Variable Definitions ---                                       */
DEFINE TEMP-TABLE tt-orden-disp
    FIELD campo-cod  AS CHARACTER
    FIELD campo-nome AS CHARACTER
    FIELD mostra     AS LOGICAL.

DEFINE TEMP-TABLE tt-orden-usad
    FIELD campo-cod  AS CHARACTER
    FIELD campo-nome AS CHARACTER
    FIELD mostra     AS LOGICAL
    FIELD sequencia  AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brOrdenDisp

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-orden-disp tt-orden-usad

/* Definitions for BROWSE brOrdenDisp                                   */
&Scoped-define FIELDS-IN-QUERY-brOrdenDisp tt-orden-disp.campo-nome   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brOrdenDisp   
&Scoped-define SELF-NAME brOrdenDisp
&Scoped-define QUERY-STRING-brOrdenDisp FOR EACH tt-orden-disp WHERE tt-orden-disp.mostra
&Scoped-define OPEN-QUERY-brOrdenDisp OPEN QUERY {&SELF-NAME} FOR EACH tt-orden-disp WHERE tt-orden-disp.mostra.
&Scoped-define TABLES-IN-QUERY-brOrdenDisp tt-orden-disp
&Scoped-define FIRST-TABLE-IN-QUERY-brOrdenDisp tt-orden-disp


/* Definitions for BROWSE brOrdenUsad                                   */
&Scoped-define FIELDS-IN-QUERY-brOrdenUsad tt-orden-usad.campo-nome   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brOrdenUsad   
&Scoped-define SELF-NAME brOrdenUsad
&Scoped-define QUERY-STRING-brOrdenUsad FOR EACH tt-orden-usad WHERE tt-orden-usad.mostra BY tt-orden-usad.sequencia
&Scoped-define OPEN-QUERY-brOrdenUsad OPEN QUERY {&SELF-NAME} FOR EACH tt-orden-usad WHERE tt-orden-usad.mostra BY tt-orden-usad.sequencia.
&Scoped-define TABLES-IN-QUERY-brOrdenUsad tt-orden-usad
&Scoped-define FIRST-TABLE-IN-QUERY-brOrdenUsad tt-orden-usad


/* Definitions for FRAME fpage0                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-4 RECT-5 IMAGE-7 IMAGE-8 ~
IMAGE-9 IMAGE-10 IMAGE-11 IMAGE-12 IMAGE-13 IMAGE-14 IMAGE-15 IMAGE-16 ~
IMAGE-17 IMAGE-18 RECT-6 c-cod-estabel-ini c-cod-estabel-fim ~
c-cod-regiao-ini c-cod-regiao-fim c-cod-rota-ini c-cod-rota-fim ~
i-cdn-grp-produt-ini i-cdn-grp-produt-fim i-cdn-produt-rural-ini ~
i-cdn-produt-rural-fim c-cod-propried-ini c-cod-propried-fim tg-sit-todos ~
tg-sit-pendente tg-sit-confirmada tg-sit-nf-gerada brOrdenDisp brOrdenUsad ~
btAddTarget btDelTarget btUp btDown btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estabel-ini c-cod-estabel-fim ~
c-cod-regiao-ini c-cod-regiao-fim c-cod-rota-ini c-cod-rota-fim ~
i-cdn-grp-produt-ini i-cdn-grp-produt-fim i-cdn-produt-rural-ini ~
i-cdn-produt-rural-fim c-cod-propried-ini c-cod-propried-fim tg-sit-todos ~
tg-sit-pendente tg-sit-confirmada tg-sit-nf-gerada 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btAddTarget 
     IMAGE-UP FILE "image/next-au":U
     IMAGE-INSENSITIVE FILE "image/next-ai":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Inclui".

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDelTarget 
     IMAGE-UP FILE "image/prev-au":U
     IMAGE-INSENSITIVE FILE "image/prev-ai":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Retira".

DEFINE BUTTON btDown 
     IMAGE-UP FILE "image/im-abx1.bmp":U
     LABEL "D" 
     SIZE 3.57 BY 1 TOOLTIP "Mover para Baixo".

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btUp 
     IMAGE-UP FILE "image/im-acm1.bmp":U
     LABEL "U" 
     SIZE 3.57 BY 1 TOOLTIP "Mover para Cima".

DEFINE VARIABLE c-cod-estabel-fim LIKE fechto-produt-period.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-ini LIKE fechto-produt-period.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-propried-fim LIKE fechto-produt-period.cod-propried
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-propried-ini LIKE fechto-produt-period.cod-propried
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-regiao-fim LIKE fechto-produt-period.cod-regiao
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-regiao-ini LIKE fechto-produt-period.cod-regiao
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-rota-fim LIKE fechto-produt-period.cod-rota
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-rota-ini LIKE fechto-produt-period.cod-rota
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-grp-produt-fim LIKE grp-produt.cdn-grp-produt
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-grp-produt-ini LIKE grp-produt.cdn-grp-produt
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-produt-rural-fim LIKE fechto-produt-period.cdn-produt-rural
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-produt-rural-ini LIKE fechto-produt-period.cdn-produt-rural
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

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

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 8.25.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 2.79.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 7.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 84 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-sit-confirmada AS LOGICAL INITIAL no 
     LABEL "Confirmada" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sit-nf-gerada AS LOGICAL INITIAL no 
     LABEL "Com NF Gerada" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sit-pendente AS LOGICAL INITIAL no 
     LABEL "Pendente" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .88 NO-UNDO.

DEFINE VARIABLE tg-sit-todos AS LOGICAL INITIAL no 
     LABEL "Todos" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brOrdenDisp FOR 
      tt-orden-disp SCROLLING.

DEFINE QUERY brOrdenUsad FOR 
      tt-orden-usad SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brOrdenDisp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brOrdenDisp wWindow _FREEFORM
  QUERY brOrdenDisp DISPLAY
      tt-orden-disp.campo-nome WIDTH 10  FORMAT "X(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS NO-ROW-MARKERS SEPARATORS NO-SCROLLBAR-VERTICAL SIZE 30 BY 5.71
         FONT 1
         TITLE "Campos dispon°veis" FIT-LAST-COLUMN.

DEFINE BROWSE brOrdenUsad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brOrdenUsad wWindow _FREEFORM
  QUERY brOrdenUsad DISPLAY
      tt-orden-usad.campo-nome WIDTH 10  FORMAT "X(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS NO-ROW-MARKERS SEPARATORS SIZE 30 BY 5.71
         FONT 1
         TITLE "Campos utilizados" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-cod-estabel-ini AT ROW 3.04 COL 20.14 COLON-ALIGNED HELP
          "C¢digo do estabelecimento"
     c-cod-estabel-fim AT ROW 3.08 COL 49.14 COLON-ALIGNED HELP
          "C¢digo do estabelecimento" NO-LABEL
     c-cod-regiao-ini AT ROW 4.04 COL 20.14 COLON-ALIGNED HELP
          "C¢digo Regi∆o"
     c-cod-regiao-fim AT ROW 4.04 COL 49.14 COLON-ALIGNED HELP
          "C¢digo Regi∆o" NO-LABEL
     c-cod-rota-ini AT ROW 5.04 COL 20.14 COLON-ALIGNED HELP
          "C¢digo da rota"
     c-cod-rota-fim AT ROW 5.04 COL 49.14 COLON-ALIGNED HELP
          "C¢digo da rota" NO-LABEL
     i-cdn-grp-produt-ini AT ROW 6.04 COL 20.14 COLON-ALIGNED HELP
          "Grupo Produtor"
     i-cdn-grp-produt-fim AT ROW 6.04 COL 49.14 COLON-ALIGNED HELP
          "Grupo Produtor" NO-LABEL
     i-cdn-produt-rural-ini AT ROW 7.04 COL 20.14 COLON-ALIGNED HELP
          "Produtor Rural"
     i-cdn-produt-rural-fim AT ROW 7.04 COL 49.14 COLON-ALIGNED HELP
          "Produtor Rural" NO-LABEL
     c-cod-propried-ini AT ROW 8.04 COL 20.14 COLON-ALIGNED HELP
          "C¢digo Propriedade"
     c-cod-propried-fim AT ROW 8.04 COL 49.14 COLON-ALIGNED HELP
          "C¢digo Propriedade" NO-LABEL
     tg-sit-todos AT ROW 10.79 COL 14 WIDGET-ID 2
     tg-sit-pendente AT ROW 11.79 COL 14 WIDGET-ID 4
     tg-sit-confirmada AT ROW 11.79 COL 29 WIDGET-ID 6
     tg-sit-nf-gerada AT ROW 11.79 COL 44.72 WIDGET-ID 8
     brOrdenDisp AT ROW 14.5 COL 7 WIDGET-ID 100
     brOrdenUsad AT ROW 14.5 COL 44.14 WIDGET-ID 200
     btAddTarget AT ROW 16.79 COL 38.57 WIDGET-ID 14
     btDelTarget AT ROW 18 COL 38.57 WIDGET-ID 16
     btUp AT ROW 19.25 COL 74.72 HELP
          "Mover para Cima" WIDGET-ID 20
     btDown AT ROW 19.25 COL 78.43 HELP
          "Mover para Baixo" WIDGET-ID 18
     btOK AT ROW 21.42 COL 2
     btCancel AT ROW 21.42 COL 13
     btHelp2 AT ROW 21.46 COL 73
     "Ordenaá∆o" VIEW-AS TEXT
          SIZE 9 BY .67 AT ROW 13.29 COL 6 WIDGET-ID 12
     "Situaá∆o" VIEW-AS TEXT
          SIZE 9 BY .67 AT ROW 9.88 COL 6
     "Filtro" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 1.25 COL 6
     rtToolBar AT ROW 21.21 COL 1
     RECT-4 AT ROW 1.5 COL 3
     RECT-5 AT ROW 10.21 COL 3
     IMAGE-7 AT ROW 3.08 COL 38.86
     IMAGE-8 AT ROW 3.08 COL 48.14
     IMAGE-9 AT ROW 4.04 COL 38.86
     IMAGE-10 AT ROW 4.04 COL 48.14
     IMAGE-11 AT ROW 5.04 COL 38.86
     IMAGE-12 AT ROW 5.04 COL 48.14
     IMAGE-13 AT ROW 6.04 COL 38.86
     IMAGE-14 AT ROW 6.04 COL 48.14
     IMAGE-15 AT ROW 7.04 COL 38.86
     IMAGE-16 AT ROW 7.04 COL 48.14
     IMAGE-17 AT ROW 8.04 COL 38.86
     IMAGE-18 AT ROW 8.04 COL 48.14
     RECT-6 AT ROW 13.63 COL 3 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 22
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
         HEIGHT             = 22
         WIDTH              = 83.29
         MAX-HEIGHT         = 38.63
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.63
         VIRTUAL-WIDTH      = 182.86
         MAX-BUTTON         = no
         RESIZE             = no
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
/* BROWSE-TAB brOrdenDisp tg-sit-nf-gerada fpage0 */
/* BROWSE-TAB brOrdenUsad brOrdenDisp fpage0 */
/* SETTINGS FOR FILL-IN c-cod-estabel-fim IN FRAME fpage0
   LIKE = mgmov.fechto-produt-period.cod-estabel EXP-LABEL EXP-SIZE     */
/* SETTINGS FOR FILL-IN c-cod-estabel-ini IN FRAME fpage0
   LIKE = mgmov.fechto-produt-period.cod-estabel EXP-SIZE               */
/* SETTINGS FOR FILL-IN c-cod-propried-fim IN FRAME fpage0
   LIKE = mgmov.fechto-produt-period.cod-propried EXP-LABEL EXP-SIZE    */
/* SETTINGS FOR FILL-IN c-cod-propried-ini IN FRAME fpage0
   LIKE = mgmov.fechto-produt-period.cod-propried EXP-SIZE              */
/* SETTINGS FOR FILL-IN c-cod-regiao-fim IN FRAME fpage0
   LIKE = mgmov.fechto-produt-period.cod-regiao EXP-LABEL EXP-SIZE      */
/* SETTINGS FOR FILL-IN c-cod-regiao-ini IN FRAME fpage0
   LIKE = mgmov.fechto-produt-period.cod-regiao EXP-SIZE                */
/* SETTINGS FOR FILL-IN c-cod-rota-fim IN FRAME fpage0
   LIKE = mgmov.fechto-produt-period.cod-rota EXP-SIZE                  */
/* SETTINGS FOR FILL-IN c-cod-rota-ini IN FRAME fpage0
   LIKE = mgmov.fechto-produt-period.cod-rota EXP-SIZE                  */
/* SETTINGS FOR FILL-IN i-cdn-grp-produt-fim IN FRAME fpage0
   LIKE = mgcad.grp-produt.cdn-grp-produt EXP-LABEL EXP-SIZE            */
/* SETTINGS FOR FILL-IN i-cdn-grp-produt-ini IN FRAME fpage0
   LIKE = mgcad.grp-produt.cdn-grp-produt EXP-SIZE                      */
/* SETTINGS FOR FILL-IN i-cdn-produt-rural-fim IN FRAME fpage0
   LIKE = mgmov.fechto-produt-period.cdn-produt-rural EXP-LABEL         */
/* SETTINGS FOR FILL-IN i-cdn-produt-rural-ini IN FRAME fpage0
   LIKE = mgmov.fechto-produt-period.cdn-produt-rural                   */
ASSIGN 
       IMAGE-10:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-11:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-12:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-13:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-14:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-15:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-16:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-17:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-18:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-7:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-8:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-9:HIDDEN IN FRAME fpage0           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brOrdenDisp
/* Query rebuild information for BROWSE brOrdenDisp
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-orden-disp WHERE tt-orden-disp.mostra.
     _END_FREEFORM
     _Query            is NOT OPENED
*/  /* BROWSE brOrdenDisp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brOrdenUsad
/* Query rebuild information for BROWSE brOrdenUsad
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-orden-usad WHERE tt-orden-usad.mostra BY tt-orden-usad.sequencia.
     _END_FREEFORM
     _Query            is NOT OPENED
*/  /* BROWSE brOrdenUsad */
&ANALYZE-RESUME

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


&Scoped-define BROWSE-NAME brOrdenUsad
&Scoped-define SELF-NAME brOrdenUsad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brOrdenUsad wWindow
ON ITERATION-CHANGED OF brOrdenUsad IN FRAME fpage0 /* Campos utilizados */
DO:

    RUN habDesbBotoes IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddTarget wWindow
ON CHOOSE OF btAddTarget IN FRAME fpage0
DO:
    DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.
    DEFINE BUFFER b-tt-orden-usad FOR tt-orden-usad.

    ASSIGN i-sequencia = 1.
    FOR LAST b-tt-orden-usad NO-LOCK WHERE b-tt-orden-usad.mostra BY b-tt-orden-usad.sequencia: 

        ASSIGN i-sequencia = b-tt-orden-usad.sequencia + 1.
        
    END.

    brOrdenDisp:SELECT-FOCUSED-ROW() IN FRAME fPage0.
    IF AVAIL tt-orden-disp THEN DO:
        ASSIGN tt-orden-disp.mostra = NO.

        FOR FIRST tt-orden-usad 
            WHERE tt-orden-usad.campo-cod = tt-orden-disp.campo-cod:

            ASSIGN tt-orden-usad.mostra    = YES
                   tt-orden-usad.sequencia = i-sequencia.

        END.
          
    END.

    {&OPEN-QUERY-brOrdenDisp}
    {&OPEN-QUERY-brOrdenUsad}

    RUN habDesbBotoes IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN 'NOK'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelTarget wWindow
ON CHOOSE OF btDelTarget IN FRAME fpage0
DO:
    brOrdenUsad:SELECT-FOCUSED-ROW() IN FRAME fPage0.
    IF AVAIL tt-orden-usad THEN DO:
        ASSIGN tt-orden-usad.mostra = NO.

        FOR FIRST tt-orden-disp 
            WHERE tt-orden-disp.campo-cod = tt-orden-usad.campo-cod:

            ASSIGN tt-orden-disp.mostra = YES.

        END.

    END.

    {&OPEN-QUERY-brOrdenDisp}
    {&OPEN-QUERY-brOrdenUsad} 

    RUN habDesbBotoes IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDown wWindow
ON CHOOSE OF btDown IN FRAME fpage0 /* D */
DO:

    DEFINE VARIABLE i-seq-nova  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-seq-atual AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-campo-cod AS CHARACTER NO-UNDO.

    IF AVAIL tt-orden-usad THEN
        ASSIGN i-seq-atual = tt-orden-usad.sequencia
               c-campo-cod = tt-orden-usad.campo-cod.

    FIND FIRST tt-orden-usad WHERE tt-orden-usad.sequencia = i-seq-atual + 1.
    IF AVAIL tt-orden-usad THEN
        ASSIGN i-seq-nova              = tt-orden-usad.sequencia
               tt-orden-usad.sequencia = i-seq-atual.

    FOR FIRST tt-orden-usad
        WHERE tt-orden-usad.campo-cod  = c-campo-cod:
        ASSIGN tt-orden-usad.sequencia = i-seq-nova.
    END.

    {&OPEN-QUERY-brOrdenUsad}

    FIND FIRST tt-orden-usad
        WHERE tt-orden-usad.campo-cod = c-campo-cod.
    IF AVAIL tt-orden-usad THEN
         REPOSITION brOrdenUsad TO ROWID ROWID(tt-orden-usad) NO-ERROR.                             
    
    APPLY "VALUE-CHANGED":U TO brOrdenUsad IN FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    RUN piAtualizaParams IN THIS-PROCEDURE.    
    IF RETURN-VALUE = "OK":U THEN DO:
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN 'OK':U.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUp wWindow
ON CHOOSE OF btUp IN FRAME fpage0 /* U */
DO: 
  
    DEFINE VARIABLE i-seq-nova  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-seq-atual AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-campo-cod AS CHARACTER NO-UNDO.

    IF AVAIL tt-orden-usad THEN
        ASSIGN i-seq-atual = tt-orden-usad.sequencia
               c-campo-cod = tt-orden-usad.campo-cod.

    FIND FIRST tt-orden-usad WHERE tt-orden-usad.sequencia = i-seq-atual - 1.
    IF AVAIL tt-orden-usad THEN
        ASSIGN i-seq-nova              = tt-orden-usad.sequencia
               tt-orden-usad.sequencia = i-seq-atual.

    FOR FIRST tt-orden-usad
        WHERE tt-orden-usad.campo-cod  = c-campo-cod:
        ASSIGN tt-orden-usad.sequencia = i-seq-nova.
    END.

    {&OPEN-QUERY-brOrdenUsad}

    FIND FIRST tt-orden-usad
        WHERE tt-orden-usad.campo-cod = c-campo-cod.
    IF AVAIL tt-orden-usad THEN
         REPOSITION brOrdenUsad TO ROWID ROWID(tt-orden-usad) NO-ERROR.                             
    
    APPLY "VALUE-CHANGED":U TO brOrdenUsad IN FRAME fPage0.

    

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


&Scoped-define SELF-NAME tg-sit-confirmada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-sit-confirmada wWindow
ON VALUE-CHANGED OF tg-sit-confirmada IN FRAME fpage0 /* Confirmada */
DO:
  RUN piControlaSituacao IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-sit-nf-gerada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-sit-nf-gerada wWindow
ON VALUE-CHANGED OF tg-sit-nf-gerada IN FRAME fpage0 /* Com NF Gerada */
DO:
  RUN piControlaSituacao IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-sit-pendente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-sit-pendente wWindow
ON VALUE-CHANGED OF tg-sit-pendente IN FRAME fpage0 /* Pendente */
DO:
  RUN piControlaSituacao IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-sit-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-sit-todos wWindow
ON VALUE-CHANGED OF tg-sit-todos IN FRAME fpage0 /* Todos */
DO:
  
  IF tg-sit-todos:CHECKED THEN
      ASSIGN tg-sit-pendente:CHECKED = YES
             tg-sit-confirmada:CHECKED = YES
             tg-sit-nf-gerada:CHECKED = YES.
  ELSE  
      ASSIGN tg-sit-pendente:CHECKED = NO
             tg-sit-confirmada:CHECKED = NO
             tg-sit-nf-gerada:CHECKED = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brOrdenDisp
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
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
    FIND FIRST tt-filtro NO-ERROR.
    IF AVAIL tt-filtro THEN DO:
        ASSIGN c-cod-estabel-ini:SCREEN-VALUE      IN FRAME fPage0 = tt-filtro.cod-estabel-ini
               c-cod-estabel-fim:SCREEN-VALUE      IN FRAME fPage0 = tt-filtro.cod-estabel-fim
               c-cod-regiao-ini:SCREEN-VALUE       IN FRAME fPage0 = tt-filtro.cod-regiao-ini
               c-cod-regiao-fim:SCREEN-VALUE       IN FRAME fPage0 = tt-filtro.cod-regiao-fim
               c-cod-rota-ini:SCREEN-VALUE         IN FRAME fPage0 = tt-filtro.cod-rota-ini
               c-cod-rota-fim:SCREEN-VALUE         IN FRAME fPage0 = tt-filtro.cod-rota-fim
               i-cdn-grp-produt-ini:SCREEN-VALUE   IN FRAME fPage0 = STRING(tt-filtro.cdn-grp-produt-ini)
               i-cdn-grp-produt-fim:SCREEN-VALUE   IN FRAME fPage0 = STRING(tt-filtro.cdn-grp-produt-fim)
               i-cdn-produt-rural-ini:SCREEN-VALUE IN FRAME fPage0 = STRING(tt-filtro.cdn-produt-rural-ini)
               i-cdn-produt-rural-fim:SCREEN-VALUE IN FRAME fPage0 = STRING(tt-filtro.cdn-produt-rural-fim)
               c-cod-propried-ini:SCREEN-VALUE     IN FRAME fPage0 = tt-filtro.cod-propried-ini
               c-cod-propried-fim:SCREEN-VALUE     IN FRAME fPage0 = tt-filtro.cod-propried-fim
               tg-sit-todos:CHECKED                IN FRAME fPage0 = tt-filtro.tg-sit-todos
               tg-sit-pendente:CHECKED             IN FRAME fPage0 = tt-filtro.tg-sit-pendente
               tg-sit-confirmada:CHECKED           IN FRAME fPage0 = tt-filtro.tg-sit-confirmada
               tg-sit-nf-gerada:CHECKED            IN FRAME fPage0 = tt-filtro.tg-sit-nf-gerada
               tt-filtro.ordenacao                                 = "BY cod-estabel BY cod-regiao BY cod-rota BY cdn-produt-rural ".

    END.

    FIND FIRST tt-orden-disp NO-ERROR.
    IF NOT AVAIL tt-orden-disp THEN DO:
        CREATE tt-orden-disp.
        ASSIGN tt-orden-disp.campo-cod  = "cod-estabel":U
               tt-orden-disp.campo-nome = "Estabelecimento"
               tt-orden-disp.mostra     = YES.
        CREATE tt-orden-disp.
        ASSIGN tt-orden-disp.campo-cod  = "cod-regiao":U
               tt-orden-disp.campo-nome = "Regi∆o"
               tt-orden-disp.mostra     = YES.
        CREATE tt-orden-disp.
        ASSIGN tt-orden-disp.campo-cod  = "cod-rota":U
               tt-orden-disp.campo-nome = "Rota"
               tt-orden-disp.mostra     = YES.
        CREATE tt-orden-disp.
        ASSIGN tt-orden-disp.campo-cod  = "grp-produt":U
               tt-orden-disp.campo-nome = "Grupo Produtor"
               tt-orden-disp.mostra     = YES.
        CREATE tt-orden-disp.
        ASSIGN tt-orden-disp.campo-cod  = "nome-abrev":U
               tt-orden-disp.campo-nome = "Produtor Rural"
               tt-orden-disp.mostra     = YES.
        CREATE tt-orden-disp.
        ASSIGN tt-orden-disp.campo-cod  = "cod-propried":U
               tt-orden-disp.campo-nome = "Propriedade"
               tt-orden-disp.mostra     = YES.
    END.

    {&OPEN-QUERY-brOrdenDisp}

    FIND FIRST tt-orden-usad NO-ERROR.
    IF NOT AVAIL tt-orden-usad THEN DO:
        CREATE tt-orden-usad.
        ASSIGN tt-orden-usad.campo-cod  = "cod-estabel":U
               tt-orden-usad.campo-nome = "Estabelecimento"
               tt-orden-usad.mostra     = NO.
        CREATE tt-orden-usad.
        ASSIGN tt-orden-usad.campo-cod  = "cod-regiao":U
               tt-orden-usad.campo-nome = "Regi∆o"
               tt-orden-usad.mostra     = NO.
        CREATE tt-orden-usad.
        ASSIGN tt-orden-usad.campo-cod  = "cod-rota":U
               tt-orden-usad.campo-nome = "Rota"
               tt-orden-usad.mostra     = NO.
        CREATE tt-orden-usad.
        ASSIGN tt-orden-usad.campo-cod  = "grp-produt":U
               tt-orden-usad.campo-nome = "Grupo Produtor"
               tt-orden-usad.mostra     = NO.
        CREATE tt-orden-usad.
        ASSIGN tt-orden-usad.campo-cod  = "nome-abrev":U
               tt-orden-usad.campo-nome = "Produtor Rural"
               tt-orden-usad.mostra     = NO.
        CREATE tt-orden-usad.
        ASSIGN tt-orden-usad.campo-cod  = "cod-propried":U
               tt-orden-usad.campo-nome = "Propriedade"
               tt-orden-usad.mostra     = NO.

    END.

    {&OPEN-QUERY-brOrdenUsad}

    RUN habDesbBotoes IN THIS-PROCEDURE.

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habDesbBotoes wWindow 
PROCEDURE habDesbBotoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.

ASSIGN btAddTarget:SENSITIVE IN FRAME fPage0 = CAN-FIND (FIRST tt-orden-disp WHERE tt-orden-disp.mostra)
       btDelTarget:SENSITIVE IN FRAME fPage0 = CAN-FIND (FIRST tt-orden-usad WHERE tt-orden-usad.mostra)
       btUp:SENSITIVE        IN FRAME fPage0 = YES
       btDown:SENSITIVE      IN FRAME fPage0 = YES.

ASSIGN brOrdenDisp:SENSITIVE IN FRAME fPage0 = TRUE.
ASSIGN brOrdenUsad:SENSITIVE IN FRAME fPage0 = TRUE.


IF AVAIL tt-orden-usad THEN DO:
    
    ASSIGN i-seq = tt-orden-usad.sequencia
           btUp:SENSITIVE IN FRAME fPage0 = CAN-FIND (FIRST tt-orden-usad WHERE tt-orden-usad.mostra 
                                                        AND tt-orden-usad.sequencia < i-seq)
           btDown:SENSITIVE IN FRAME fPage0 = CAN-FIND (FIRST tt-orden-usad WHERE tt-orden-usad.mostra 
                                                          AND tt-orden-usad.sequencia > i-seq).

END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaParams wWindow 
PROCEDURE piAtualizaParams :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE c-lista AS CHARACTER NO-UNDO.
    DEFINE BUFFER bf-tt-orden-usad FOR tt-orden-usad.

    IF INPUT FRAME fPage0 c-cod-estabel-fim      < INPUT FRAME fPage0 c-cod-estabel-ini      OR
       INPUT FRAME fPage0 c-cod-regiao-fim       < INPUT FRAME fPage0 c-cod-regiao-ini       OR
       INPUT FRAME fPage0 c-cod-rota-fim         < INPUT FRAME fPage0 c-cod-rota-ini         OR
       INPUT FRAME fPage0 i-cdn-grp-produt-fim   < INPUT FRAME fPage0 i-cdn-grp-produt-ini   OR
       INPUT FRAME fPage0 i-cdn-produt-rural-fim < INPUT FRAME fPage0 i-cdn-produt-rural-ini OR
       INPUT FRAME fPage0 c-cod-propried-fim     < INPUT FRAME fPage0 c-cod-propried-ini THEN DO:
        RUN utp/ut-msgs.p(INPUT 'SHOW',
                          INPUT 51730,
                          INPUT '').
        RETURN "NOK":U.
    END.
    
    FIND FIRST tt-filtro NO-ERROR.
    IF AVAIL tt-filtro THEN DO:
        ASSIGN tt-filtro.cod-estabel-ini      = INPUT FRAME fPage0 c-cod-estabel-ini
               tt-filtro.cod-estabel-fim      = INPUT FRAME fPage0 c-cod-estabel-fim
               tt-filtro.cod-regiao-ini       = INPUT FRAME fPage0 c-cod-regiao-ini
               tt-filtro.cod-regiao-fim       = INPUT FRAME fPage0 c-cod-regiao-fim
               tt-filtro.cod-rota-ini         = INPUT FRAME fPage0 c-cod-rota-ini
               tt-filtro.cod-rota-fim         = INPUT FRAME fPage0 c-cod-rota-fim
               tt-filtro.cdn-grp-produt-ini   = INPUT FRAME fPage0 i-cdn-grp-produt-ini
               tt-filtro.cdn-grp-produt-fim   = INPUT FRAME fPage0 i-cdn-grp-produt-fim
               tt-filtro.cdn-produt-rural-ini = INPUT FRAME fPage0 i-cdn-produt-rural-ini
               tt-filtro.cdn-produt-rural-fim = INPUT FRAME fPage0 i-cdn-produt-rural-fim
               tt-filtro.cod-propried-ini     = INPUT FRAME fPage0 c-cod-propried-ini
               tt-filtro.cod-propried-fim     = INPUT FRAME fPage0 c-cod-propried-fim
               tt-filtro.tg-sit-todos         = IF INPUT FRAME fPage0 tg-sit-todos:CHECKED      THEN YES ELSE NO
               tt-filtro.tg-sit-pendente      = IF INPUT FRAME fPage0 tg-sit-pendente:CHECKED   THEN YES ELSE NO
               tt-filtro.tg-sit-confirmada    = IF INPUT FRAME fPage0 tg-sit-confirmada:CHECKED THEN YES ELSE NO
               tt-filtro.tg-sit-nf-gerada     = IF INPUT FRAME fPage0 tg-sit-nf-gerada:CHECKED  THEN YES ELSE NO.

        IF CAN-FIND (FIRST tt-orden-usad WHERE tt-orden-usad.mostra) THEN DO:
            
            ASSIGN tt-filtro.ordenacao = "".

            FOR EACH bf-tt-orden-usad WHERE bf-tt-orden-usad.mostra BY sequencia:

                ASSIGN tt-filtro.ordenacao = tt-filtro.ordenacao + " BY " + bf-tt-orden-usad.campo-cod.

            END.

        END.
        ELSE
            ASSIGN tt-filtro.ordenacao = "BY cod-estabel BY cod-regiao BY cod-rota BY cdn-produt-rural ".

    END.

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piControlaSituacao wWindow 
PROCEDURE piControlaSituacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME fPage0:

        IF tg-sit-pendente:CHECKED AND 
           tg-sit-confirmada:CHECKED AND
           tg-sit-nf-gerada:CHECKED  THEN
            ASSIGN tg-sit-todos:CHECKED = YES.
        ELSE
            ASSIGN tg-sit-todos:CHECKED = NO.
    
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

