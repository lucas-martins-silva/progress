&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-proces-esocial-recebimento NO-UNDO LIKE proces-esocial-recebimento
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-proces-esocial-recebimento-2 NO-UNDO LIKE proces-esocial-recebimento
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wZoom 
/*:T********************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i Z01AD00535 2.00.00.005 } /*** "010005" ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i Z01AD00535 CDP}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           Z01AD00535
&GLOBAL-DEFINE Version        2.00.00.005

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Emitente,Data

&GLOBAL-DEFINE Range             NO

&GLOBAL-DEFINE FieldsRangePage1  
&GLOBAL-DEFINE FieldsAnyKeyPage1 NO

&GLOBAL-DEFINE ttTable1          tt-proces-esocial-recebimento
&GLOBAL-DEFINE hDBOTable1        h-boad00535
&GLOBAL-DEFINE DBOTable1         proces-esocial-recebimento

&GLOBAL-DEFINE ttTable2          tt-proces-esocial-recebimento-2
&GLOBAL-DEFINE hDBOTable2        h-boad00535-aux
&GLOBAL-DEFINE DBOTable2         proces-esocial-recebimento

&GLOBAL-DEFINE page1Browse       brTable1
&GLOBAL-DEFINE page2Browse       brTable2

&GLOBAL-DEFINE NumRowsReturned  100000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE i-tp-process  AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cd-emit  AS INTEGER     NO-UNDO.
DEFINE VARIABLE d-data-emis   AS DATE        NO-UNDO.
/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable2} AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Zoom
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTable1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-proces-esocial-recebimento ~
tt-proces-esocial-recebimento-2

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 ~
tt-proces-esocial-recebimento.cdn-emitente ~
tt-proces-esocial-recebimento.cod-process-judic ~
tt-proces-esocial-recebimento.cod-imposto ~
tt-proces-esocial-recebimento.cod-classif-impto ~
tt-proces-esocial-recebimento.dat-inic-valid ~
tt-proces-esocial-recebimento.dat-fim-valid ~
tt-proces-esocial-recebimento.percentual ~
tt-proces-esocial-recebimento.log-integr ~
fn-tp-retenc(tt-proces-esocial-recebimento.idi-retenc) 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-proces-esocial-recebimento NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-proces-esocial-recebimento NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-proces-esocial-recebimento
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-proces-esocial-recebimento


/* Definitions for BROWSE brTable2                                      */
&Scoped-define FIELDS-IN-QUERY-brTable2 ~
tt-proces-esocial-recebimento-2.cdn-emitente ~
tt-proces-esocial-recebimento-2.cod-process-judic ~
tt-proces-esocial-recebimento-2.cod-imposto ~
tt-proces-esocial-recebimento-2.cod-classif-impto ~
tt-proces-esocial-recebimento-2.dat-inic-valid ~
tt-proces-esocial-recebimento-2.dat-fim-valid ~
tt-proces-esocial-recebimento-2.percentual ~
tt-proces-esocial-recebimento-2.log-integr ~
fn-tp-retenc(tt-proces-esocial-recebimento-2.idi-retenc) 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable2 
&Scoped-define QUERY-STRING-brTable2 FOR EACH tt-proces-esocial-recebimento-2 NO-LOCK
&Scoped-define OPEN-QUERY-brTable2 OPEN QUERY brTable2 FOR EACH tt-proces-esocial-recebimento-2 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable2 tt-proces-esocial-recebimento-2
&Scoped-define FIRST-TABLE-IN-QUERY-brTable2 tt-proces-esocial-recebimento-2


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brTable2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-tp-retenc wZoom 
FUNCTION fn-tp-retenc RETURNS CHARACTER
   (i-idi-retenc AS INT) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wZoom AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btCheck1 
     IMAGE-UP FILE "image/im-sav":U
     LABEL "btcheck 1" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE i-emitente-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE i-emitente-ini LIKE tt-proces-esocial-recebimento.cdn-emitente
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE IMAGE IMAGE-03
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-04
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-tipo-processo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Principal", 1,
"Adicional", 2,
"Ambos", 3
     SIZE 40 BY 1 NO-UNDO.

DEFINE BUTTON btCheck2 
     IMAGE-UP FILE "image/im-sav":U
     LABEL "btcheck 2" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant2 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE da-data-fim-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/2199 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-fim-ini AS DATE FORMAT "99/99/9999" INITIAL 01/01/1800 
     LABEL "Fim Validade" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-inic-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/2199 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-inic-ini AS DATE FORMAT "99/99/9999" INITIAL 01/01/1800 
     LABEL "Inicio Validade" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-tipo-processo2 AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Principal", 1,
"Adicional", 2,
"Ambos", 3
     SIZE 40 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-proces-esocial-recebimento SCROLLING.

DEFINE QUERY brTable2 FOR 
      tt-proces-esocial-recebimento-2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-proces-esocial-recebimento.cdn-emitente FORMAT ">>>>>>>>9":U
      tt-proces-esocial-recebimento.cod-process-judic FORMAT "x(21)":U
      tt-proces-esocial-recebimento.cod-imposto COLUMN-LABEL "Imposto" FORMAT "x(5)":U
      tt-proces-esocial-recebimento.cod-classif-impto FORMAT "x(5)":U
            WIDTH 15
      tt-proces-esocial-recebimento.dat-inic-valid FORMAT "99/99/9999":U
      tt-proces-esocial-recebimento.dat-fim-valid FORMAT "99/99/9999":U
      tt-proces-esocial-recebimento.percentual
      tt-proces-esocial-recebimento.log-integr FORMAT "Sim/NÆo":U
            WIDTH 8
      fn-tp-retenc(tt-proces-esocial-recebimento.idi-retenc) COLUMN-LABEL "Tipo Processo" FORMAT "x(20)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.5
         FONT 2.

DEFINE BROWSE brTable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable2 wZoom _STRUCTURED
  QUERY brTable2 NO-LOCK DISPLAY
      tt-proces-esocial-recebimento-2.cdn-emitente FORMAT ">>>>>>>>9":U
      tt-proces-esocial-recebimento-2.cod-process-judic FORMAT "x(21)":U
      tt-proces-esocial-recebimento-2.cod-imposto COLUMN-LABEL "Imposto" FORMAT "x(5)":U
      tt-proces-esocial-recebimento-2.cod-classif-impto FORMAT "x(5)":U
      tt-proces-esocial-recebimento-2.dat-inic-valid FORMAT "99/99/9999":U
      tt-proces-esocial-recebimento-2.dat-fim-valid FORMAT "99/99/9999":U
      tt-proces-esocial-recebimento-2.percentual
      tt-proces-esocial-recebimento-2.log-integr FORMAT "Sim/NÆo":U
      fn-tp-retenc(tt-proces-esocial-recebimento-2.idi-retenc) COLUMN-LABEL "Tipo Processo" FORMAT "x(20)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.5
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.71 COL 2
     btCancel AT ROW 16.71 COL 13
     btHelp AT ROW 16.71 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     i-emitente-ini AT ROW 1.25 COL 18.57 COLON-ALIGNED HELP
          "C¢digo do emitente"
     i-emitente-fim AT ROW 1.25 COL 48.43 COLON-ALIGNED HELP
          "C¢digo do emitente" NO-LABEL
     rs-tipo-processo AT ROW 2.25 COL 21 NO-LABEL WIDGET-ID 2
     btCheck1 AT ROW 1.21 COL 78.86
     brTable1 AT ROW 3.5 COL 2
     btImplant1 AT ROW 13 COL 2
     "Tipo Processo Retenc:" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 2.38 COL 4.57 WIDGET-ID 6
     IMAGE-03 AT ROW 1.25 COL 33
     IMAGE-04 AT ROW 1.25 COL 47
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.

DEFINE FRAME fPage2
     da-data-inic-ini AT ROW 1.25 COL 18.72 COLON-ALIGNED HELP
          "Data Inicio Validade"
     da-data-inic-fim AT ROW 1.25 COL 48.43 COLON-ALIGNED HELP
          "Data Inicio Validade" NO-LABEL
     da-data-fim-ini AT ROW 2.25 COL 18.72 COLON-ALIGNED HELP
          "Data Fim Validade"
     da-data-fim-fim AT ROW 2.25 COL 48.43 COLON-ALIGNED HELP
          "Data Fim Validade" NO-LABEL
     rs-tipo-processo2 AT ROW 3.25 COL 21 NO-LABEL WIDGET-ID 2
     btCheck2 AT ROW 1.21 COL 78.86
     brTable2 AT ROW 4.5 COL 2
     btImplant2 AT ROW 13 COL 2
     "Tipo Processo Retenc:" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 3.38 COL 4.72 WIDGET-ID 6
     IMAGE-5 AT ROW 1.25 COL 33
     IMAGE-6 AT ROW 1.25 COL 47
     IMAGE-7 AT ROW 2.25 COL 33
     IMAGE-8 AT ROW 2.25 COL 47
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-proces-esocial-recebimento T "?" NO-UNDO mgcad proces-esocial-recebimento
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-proces-esocial-recebimento-2 T "?" NO-UNDO mgcad proces-esocial-recebimento
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wZoom ASSIGN
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wZoom 
/* ************************* Included-Libraries *********************** */

{zoom/zoom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wZoom
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* BROWSE-TAB brTable1 btCheck1 fPage1 */
/* SETTINGS FOR FILL-IN i-emitente-ini IN FRAME fPage1
   LIKE = Temp-Tables.tt-proces-esocial-recebimento.cdn-emitente EXP-SIZE */
/* SETTINGS FOR FRAME fPage2
   Custom                                                               */
/* BROWSE-TAB brTable2 btCheck2 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-proces-esocial-recebimento"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-proces-esocial-recebimento.cdn-emitente
     _FldNameList[2]   = Temp-Tables.tt-proces-esocial-recebimento.cod-process-judic
     _FldNameList[3]   > Temp-Tables.tt-proces-esocial-recebimento.cod-imposto
"tt-proces-esocial-recebimento.cod-imposto" "Imposto" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-proces-esocial-recebimento.cod-classif-impto
"tt-proces-esocial-recebimento.cod-classif-impto" ? ? "character" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.tt-proces-esocial-recebimento.dat-inic-valid
     _FldNameList[6]   = Temp-Tables.tt-proces-esocial-recebimento.dat-fim-valid
     _FldNameList[7]   = Temp-Tables.tt-proces-esocial-recebimento-2.percentual
     _FldNameList[8]   > Temp-Tables.tt-proces-esocial-recebimento.log-integr
"tt-proces-esocial-recebimento.log-integr" ? ? "logical" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"fn-tp-retenc(tt-proces-esocial-recebimento.idi-retenc)" "Tipo Processo" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable2
/* Query rebuild information for BROWSE brTable2
     _TblList          = "Temp-Tables.tt-proces-esocial-recebimento-2"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-proces-esocial-recebimento-2.cdn-emitente
     _FldNameList[2]   = Temp-Tables.tt-proces-esocial-recebimento-2.cod-process-judic
     _FldNameList[3]   > Temp-Tables.tt-proces-esocial-recebimento-2.cod-imposto
"tt-proces-esocial-recebimento-2.cod-imposto" "Imposto" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.tt-proces-esocial-recebimento-2.cod-classif-impto
     _FldNameList[5]   = Temp-Tables.tt-proces-esocial-recebimento-2.dat-inic-valid
     _FldNameList[6]   = Temp-Tables.tt-proces-esocial-recebimento-2.dat-fim-valid
     _FldNameList[7]   = Temp-Tables.tt-proces-esocial-recebimento-2.percentual
     _FldNameList[8]   = Temp-Tables.tt-proces-esocial-recebimento-2.log-integr
     _FldNameList[9]   > "_<CALC>"
"fn-tp-retenc(tt-proces-esocial-recebimento-2.idi-retenc)" "Tipo Processo" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brTable2 */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wZoom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wZoom wZoom
ON END-ERROR OF wZoom
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wZoom wZoom
ON WINDOW-CLOSE OF wZoom
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wZoom
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btCheck1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck1 wZoom
ON CHOOSE OF btCheck1 IN FRAME fPage1 /* btcheck 1 */
DO:
    run setConstraints in this-procedure (input 1).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btCheck2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck2 wZoom
ON CHOOSE OF btCheck2 IN FRAME fPage2 /* btcheck 2 */
DO:
    run setConstraints in this-procedure (input 2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wZoom
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btImplant1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant1 wZoom
ON CHOOSE OF btImplant1 IN FRAME fPage1 /* Implantar */
DO:
    {zoom/implant.i &ProgramImplant="cdp/cd2021.w"
                    &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btImplant2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant2 wZoom
ON CHOOSE OF btImplant2 IN FRAME fPage2 /* Implantar */
DO:
    {zoom/implant.i &ProgramImplant="cdp/cd2021.w"
                    &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wZoom
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    RUN returnValues IN THIS-PROCEDURE.
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brTable1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wZoom 


/* ***************************  Main Block  *************************** */

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{zoom/mainblock.i}

/* Sobrescrita das triggers para evitar erro de rolagem
do browse em Oracle */
ON OFF-END OF brTable1 IN FRAME fPage1
OR END OF brTable1 IN FRAME fPage1
OR HOME OF brTable1 IN FRAME fPage1
OR OFF-HOME OF brTable1 IN FRAME fPage1
DO:
END.

/* Sobrescrita das triggers para evitar erro de rolagem
do browse em Oracle */
ON OFF-END OF brTable2 IN FRAME fPage2
OR END OF brTable2 IN FRAME fPage2
OR HOME OF brTable2 IN FRAME fPage2
OR OFF-HOME OF brTable2 IN FRAME fPage2
DO:
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wZoom 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    ENABLE btCheck1
           rs-tipo-processo
           i-emitente-ini
           i-emitente-fim WITH FRAME fPage1. 

    ENABLE btCheck2
           rs-tipo-processo2
           da-data-inic-ini
           da-data-inic-fim
           da-data-fim-ini
           da-data-fim-fim WITH FRAME fPage2.

    IF i-tp-process <> 0 THEN DO:
        ASSIGN rs-tipo-processo2:SENSITIVE  IN FRAME fPage2 = NO.
        RUN SetFolder  IN hFolder (INPUT 1).
        RUN SetEnabled IN hFolder (INPUT 1 ,
                                   INPUT FALSE).
    END.
    ELSE
        ASSIGN i-tp-process = 3.
    ASSIGN i-emitente-fim:SCREEN-VALUE    IN FRAME fPage1 = "999999999"
           rs-tipo-processo:SCREEN-VALUE  IN FRAME fPage1 = STRING(i-tp-process)
           da-data-inic-ini:SCREEN-VALUE  IN FRAME fPage2 = "01/01/1800"    
           da-data-inic-fim:SCREEN-VALUE  IN FRAME fPage2 = "31/12/2199" 
           da-data-fim-ini:SCREEN-VALUE   IN FRAME fPage2 = "01/01/1800"
           da-data-fim-fim:SCREEN-VALUE   IN FRAME fPage2 = "31/12/2199"
           rs-tipo-processo2:SCREEN-VALUE IN FRAME fPage2 = STRING(i-tp-process).

    APPLY "CHOOSE" TO btCheck1 IN FRAME fpage1.
    APPLY "CHOOSE" TO btCheck2 IN FRAME fpage2.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wZoom 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO jÿ estÿ inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable1}) OR
       {&hDBOTable1}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable1}:FILE-NAME <> "adbo/boad00535":U THEN DO:
        {btb/btb008za.i1 adbo/boad00535.p YES}
        {btb/btb008za.i2 adbo/boad00535.p '' {&hDBOTable1}}
    END.

    /*:T--- Verifica se o DBO jÿ estÿ inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable2}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "adbo/boad00535":U THEN DO:
        {btb/btb008za.i1 adbo/boad00535.p YES}
        {btb/btb008za.i2 adbo/boad00535.p '' {&hDBOTable2}}
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueries wZoom 
PROCEDURE openQueries :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    {zoom/openqueries.i &Query="emitente"
                        &PageNumber="1"}
                        
    IF i-cd-emit = 0 THEN DO:
        {zoom/openqueries.i &Query="data"
                        &PageNumber="2"}
    END.
    ELSE DO:
        {zoom/openqueries.i &Query="data2"
                        &PageNumber="2"}
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage1 wZoom 
PROCEDURE returnFieldsPage1 :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 1
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable1} THEN DO:
        CASE pcField:
            WHEN "cod-process-judic":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-process-judic).
            WHEN "cod-imposto":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-imposto).
        END CASE.
    END.
      
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage2 wZoom 
PROCEDURE returnFieldsPage2 :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 2
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable2} THEN DO:
        CASE pcField:
            WHEN "cod-process-judic":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-process-judic).
            WHEN "cod-imposto":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-imposto).
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraints wZoom 
PROCEDURE setConstraints :
/*:T------------------------------------------------------------------------------
  Purpose:     Seta constraints e atualiza o browse, conforme n£mero da p gina
               passado como parƒmetro
  Parameters:  recebe n£mero da p gina
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.

    /*:T--- Seta constraints conforme n£mero da p gina ---*/
    CASE pPageNumber:
        WHEN 1 THEN
            /*:T--- Seta Constraints para o DBO Table1 ---*/
            RUN setConstraintEmitente IN {&hDBOTable1} (INPUT INPUT FRAME fPage1 i-emitente-ini,
                                                        INPUT INPUT FRAME fPage1 i-emitente-fim,
                                                        INPUT INPUT FRAME fPage1 rs-tipo-processo).
        
        WHEN 2 THEN DO:
           IF i-cd-emit = 0 THEN DO:
                /*:T--- Seta Constraints para o DBO Table2 ---*/
                RUN setConstraintData IN {&hDBOTable2} (INPUT INPUT FRAME fpage2 da-data-inic-ini,
                                                        INPUT INPUT FRAME fpage2 da-data-inic-fim,
                                                        INPUT INPUT FRAME fpage2 da-data-fim-ini,
                                                        INPUT INPUT FRAME fpage2 da-data-fim-fim,
                                                        INPUT INPUT FRAME fPage2 rs-tipo-processo2).
          END.
          ELSE DO:
                RUN setConstraintData2 IN {&hDBOTable2} (INPUT INPUT FRAME fpage2 da-data-inic-ini,
                                                         INPUT INPUT FRAME fpage2 da-data-inic-fim,
                                                         INPUT INPUT FRAME fpage2 da-data-fim-ini,
                                                         INPUT INPUT FRAME fpage2 da-data-fim-fim,
                                                         INPUT INPUT FRAME fPage2 rs-tipo-processo2,
                                                         INPUT                    d-data-emis,
                                                         INPUT                    i-cd-emit  ). // ADICIONAR O RESTO 
          END.

        END.
    END CASE.
    
    /*:T--- Seta vari vel iConstraintPageNumber com o n£mero da p gina atual 
          Esta vari vel ‚ utilizada no m‚todo openQueries ---*/
    ASSIGN iConstraintPageNumber = pPageNumber.
    
    /*:T--- Atualiza browse ---*/
    RUN openQueries IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-tp-retenc wZoom 
FUNCTION fn-tp-retenc RETURNS CHARACTER
   (i-idi-retenc AS INT):
   RETURN {adinc/i01ad00535.i 4 i-idi-retenc}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaVariable wZoom 
PROCEDURE setaVariable :
/*:T------------------------------------------------------------------------------
  Purpose:     Filtrar o tipo de processo
               passado como parƒmetro
  Parameters:  recebe o tipo de processo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER p-i-tp-proces AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-d-data-emis AS DATE    NO-UNDO.
    DEFINE INPUT PARAMETER p-i-cd-emit   AS INTEGER NO-UNDO.

    ASSIGN  i-cd-emit    = p-i-cd-emit.
    ASSIGN  d-data-emis  = p-d-data-emis.
    ASSIGN  i-tp-process = p-i-tp-proces.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
