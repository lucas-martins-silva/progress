&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttaf-formula NO-UNDO LIKE af-formula
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttaf-formula1 NO-UNDO LIKE af-formula
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wZoom 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i Z01AF013 2.00.00.004 } /*** 010004 ***/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           Z01AF013
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      F¢rmula,Descri‡Æo

&GLOBAL-DEFINE Range             YES

&GLOBAL-DEFINE FieldsAnyKeyPage1 YES
&GLOBAL-DEFINE FieldsAnyKeyPage2 YES


&GLOBAL-DEFINE ttTable1          ttAf-formula
&GLOBAL-DEFINE hDBOTable1        hDBOaf013
&GLOBAL-DEFINE DBOTable1         af-formula

&GLOBAL-DEFINE ttTable2          ttAf-formula1
&GLOBAL-DEFINE hDBOTable2        hDBOaf0131
&GLOBAL-DEFINE DBOTable2         af-formula

&GLOBAL-DEFINE page1Browse       brTable1
&GLOBAL-DEFINE page2Browse       brTable2

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable2} AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf022 AS HANDLE     NO-UNDO.

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
&Scoped-define INTERNAL-TABLES ttAf-formula ttAf-formula1

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 ttAf-formula.cod-formula ~
ttAf-formula.descricao ttAf-formula.nr-versao ttAf-formula.dt-ini-validade ~
ttAf-formula.dt-fim-validade ttAf-formula.padrao ~
ttAf-formula.dt-implantacao ttAf-formula.dt-alter ttAf-formula.hora-alter ~
ttAf-formula.usuar-alter ttAf-formula.expressao ttAf-formula.narrativa 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH ttAf-formula NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH ttAf-formula NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 ttAf-formula
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 ttAf-formula


/* Definitions for BROWSE brTable2                                      */
&Scoped-define FIELDS-IN-QUERY-brTable2 ttAf-formula1.cod-formula ~
ttAf-formula1.descricao ttAf-formula1.nr-versao ~
ttAf-formula1.dt-ini-validade ttAf-formula1.dt-fim-validade ~
ttAf-formula1.padrao ttAf-formula1.dt-implantacao ttAf-formula1.dt-alter ~
ttAf-formula1.hora-alter ttAf-formula1.usuar-alter ttAf-formula1.expressao ~
ttAf-formula1.narrativa 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable2 
&Scoped-define QUERY-STRING-brTable2 FOR EACH ttAf-formula1 NO-LOCK ~
    BY ttAf-formula1.descricao
&Scoped-define OPEN-QUERY-brTable2 OPEN QUERY brTable2 FOR EACH ttAf-formula1 NO-LOCK ~
    BY ttAf-formula1.descricao.
&Scoped-define TABLES-IN-QUERY-brTable2 ttAf-formula1
&Scoped-define FIRST-TABLE-IN-QUERY-brTable2 ttAf-formula1


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
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE i-cod-formula-fim AS INTEGER FORMAT "->>>>>9":U INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-formula-ini AS INTEGER FORMAT "->>>>>9":U INITIAL 0 
     LABEL "F¢rmula" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-versao-fim AS INTEGER FORMAT ">>>>>9":U INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-versao-ini LIKE af-versao-avaliacao.nr-versao
     LABEL "VersÆo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-24
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-25
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE BUTTON btCheck2 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "Button 1" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant2 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-descricao-fim AS CHARACTER FORMAT "X(50)":U INITIAL "ZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-ini AS CHARACTER FORMAT "X(50)":U 
     LABEL "Descri‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-26
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-27
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      ttAf-formula SCROLLING.

DEFINE QUERY brTable2 FOR 
      ttAf-formula1 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      ttAf-formula.cod-formula FORMAT ">>>>>9":U
      ttAf-formula.descricao FORMAT "x(50)":U
      ttAf-formula.nr-versao FORMAT ">>>>9":U WIDTH 7.29
      ttAf-formula.dt-ini-validade FORMAT "99/99/9999":U
      ttAf-formula.dt-fim-validade FORMAT "99/99/9999":U
      ttAf-formula.padrao FORMAT "Sim/NÆo":U
      ttAf-formula.dt-implantacao FORMAT "99/99/9999":U
      ttAf-formula.dt-alter FORMAT "99/99/9999":U
      ttAf-formula.hora-alter FORMAT "X(8)":U
      ttAf-formula.usuar-alter FORMAT "X(12)":U
      ttAf-formula.expressao FORMAT "x(2000)":U
      ttAf-formula.narrativa FORMAT "x(2000)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.75
         FONT 2 ROW-HEIGHT-CHARS .6.

DEFINE BROWSE brTable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable2 wZoom _STRUCTURED
  QUERY brTable2 NO-LOCK DISPLAY
      ttAf-formula1.cod-formula FORMAT ">>>>>9":U WIDTH 8.43
      ttAf-formula1.descricao FORMAT "x(50)":U
      ttAf-formula1.nr-versao FORMAT ">>>>9":U WIDTH 7.29
      ttAf-formula1.dt-ini-validade FORMAT "99/99/9999":U
      ttAf-formula1.dt-fim-validade FORMAT "99/99/9999":U
      ttAf-formula1.padrao FORMAT "Sim/NÆo":U
      ttAf-formula1.dt-implantacao FORMAT "99/99/9999":U
      ttAf-formula1.dt-alter FORMAT "99/99/9999":U
      ttAf-formula1.hora-alter FORMAT "X(8)":U
      ttAf-formula1.usuar-alter FORMAT "X(12)":U
      ttAf-formula1.expressao FORMAT "x(2000)":U
      ttAf-formula1.narrativa FORMAT "x(2000)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.25
         FONT 2 ROW-HEIGHT-CHARS .6.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.54 COL 2
     btCancel AT ROW 16.54 COL 13
     btHelp AT ROW 16.54 COL 80
     rtToolBar AT ROW 16.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.96
         FONT 1.

DEFINE FRAME fPage2
     c-descricao-ini AT ROW 1.25 COL 13 COLON-ALIGNED
     c-descricao-fim AT ROW 1.25 COL 46 COLON-ALIGNED NO-LABEL
     btCheck2 AT ROW 1.17 COL 79
     brTable2 AT ROW 3.75 COL 2
     btImplant2 AT ROW 13 COL 2
     i-nr-versao-ini AT ROW 2.25 COL 22 COLON-ALIGNED HELP
          "N£mero da VersÆo"
          LABEL "VersÆo"
     i-nr-versao-fim AT ROW 2.25 COL 46 COLON-ALIGNED NO-LABEL FORMAT ">>>>>9":U
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     IMAGE-3 AT ROW 1.25 COL 35
     IMAGE-4 AT ROW 1.25 COL 44.14
     IMAGE-26 AT ROW 2.25 COL 35
     IMAGE-27 AT ROW 2.25 COL 44.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.

DEFINE FRAME fPage1
     i-cod-formula-ini AT ROW 1.25 COL 22 COLON-ALIGNED
     i-cod-formula-fim AT ROW 1.25 COL 47 COLON-ALIGNED NO-LABEL
     btCheck1 AT ROW 1.17 COL 79
     brTable1 AT ROW 4.25 COL 2
     btImplant1 AT ROW 13 COL 2
     i-nr-versao-ini AT ROW 2.25 COL 22 COLON-ALIGNED HELP
          "N£mero da VersÆo"
          LABEL "VersÆo"
     i-nr-versao-fim AT ROW 2.25 COL 47 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 1.25 COL 35
     IMAGE-2 AT ROW 1.25 COL 45.29
     IMAGE-24 AT ROW 2.25 COL 35
     IMAGE-25 AT ROW 2.25 COL 45.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttaf-formula T "?" NO-UNDO emsdca af-formula
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttaf-formula1 T "?" NO-UNDO emsdca af-formula
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
         HEIGHT             = 16.96
         WIDTH              = 90
         MAX-HEIGHT         = 38.25
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.25
         VIRTUAL-WIDTH      = 182.86
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
/* SETTINGS FOR FILL-IN i-nr-versao-ini IN FRAME fPage1
   LIKE = schemsdca.af-versao-avaliacao.nr-versao EXP-LABEL EXP-SIZE    */
/* SETTINGS FOR FRAME fPage2
   Custom                                                               */
/* BROWSE-TAB brTable2 btCheck2 fPage2 */
/* SETTINGS FOR FILL-IN i-nr-versao-ini IN FRAME fPage2
   LIKE = schemsdca.af-versao-avaliacao.nr-versao EXP-LABEL EXP-SIZE    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.ttAf-formula"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttAf-formula.cod-formula
     _FldNameList[2]   = Temp-Tables.ttAf-formula.descricao
     _FldNameList[3]   > Temp-Tables.ttAf-formula.nr-versao
"ttAf-formula.nr-versao" ? ? "integer" ? ? ? ? ? ? no ? no no "7.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.ttAf-formula.dt-ini-validade
     _FldNameList[5]   = Temp-Tables.ttAf-formula.dt-fim-validade
     _FldNameList[6]   = Temp-Tables.ttAf-formula.padrao
     _FldNameList[7]   = Temp-Tables.ttAf-formula.dt-implantacao
     _FldNameList[8]   = Temp-Tables.ttAf-formula.dt-alter
     _FldNameList[9]   = Temp-Tables.ttAf-formula.hora-alter
     _FldNameList[10]   = Temp-Tables.ttAf-formula.usuar-alter
     _FldNameList[11]   = Temp-Tables.ttAf-formula.expressao
     _FldNameList[12]   = Temp-Tables.ttAf-formula.narrativa
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable2
/* Query rebuild information for BROWSE brTable2
     _TblList          = "Temp-Tables.ttAf-formula1"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.ttAf-formula1.descricao|yes"
     _FldNameList[1]   > Temp-Tables.ttAf-formula1.cod-formula
"ttAf-formula1.cod-formula" ? ? "integer" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.ttAf-formula1.descricao
     _FldNameList[3]   > Temp-Tables.ttAf-formula1.nr-versao
"ttAf-formula1.nr-versao" ? ? "integer" ? ? ? ? ? ? no ? no no "7.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.ttAf-formula1.dt-ini-validade
     _FldNameList[5]   = Temp-Tables.ttAf-formula1.dt-fim-validade
     _FldNameList[6]   = Temp-Tables.ttAf-formula1.padrao
     _FldNameList[7]   = Temp-Tables.ttAf-formula1.dt-implantacao
     _FldNameList[8]   = Temp-Tables.ttAf-formula1.dt-alter
     _FldNameList[9]   = Temp-Tables.ttAf-formula1.hora-alter
     _FldNameList[10]   = Temp-Tables.ttAf-formula1.usuar-alter
     _FldNameList[11]   = Temp-Tables.ttAf-formula1.expressao
     _FldNameList[12]   = Temp-Tables.ttAf-formula1.narrativa
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
ON CHOOSE OF btCheck1 IN FRAME fPage1
DO:
  RUN setConstraints IN THIS-PROCEDURE (INPUT 1).
  APPLY 'entry' TO brTable1. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btCheck2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck2 wZoom
ON CHOOSE OF btCheck2 IN FRAME fPage2 /* Button 1 */
DO:
  RUN setConstraints IN THIS-PROCEDURE (INPUT 2).
  APPLY 'entry' TO brTable2.
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
    {zoom/Implant.i &ProgramImplant="afp/af0108.w"
                    &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btImplant2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant2 wZoom
ON CHOOSE OF btImplant2 IN FRAME fPage2 /* Implantar */
DO:
    {zoom/Implant.i &ProgramImplant="afp/af0108.w"
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
{Zoom/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wZoom 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF VALID-HANDLE(h-boaf022) THEN DO:
    DELETE PROCEDURE h-boaf022.
    ASSIGN h-boaf022 = ?.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wZoom 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN i-cod-formula-ini:SCREEN-VALUE IN FRAME fpage1 = "0"
           i-cod-formula-fim:SCREEN-VALUE IN FRAME fpage1 = "999999"
           i-nr-versao-ini:SCREEN-VALUE IN FRAME fpage1 = "0"
           i-nr-versao-fim:SCREEN-VALUE IN FRAME fpage1 = "999999"
           i-nr-versao-ini:SCREEN-VALUE IN FRAME fpage2 = "0"
           i-nr-versao-fim:SCREEN-VALUE IN FRAME fpage2 = "999999"
           c-descricao-ini:SCREEN-VALUE IN FRAME fpage2 = ""
           c-descricao-fim:SCREEN-VALUE IN FRAME fpage2 = "ZZZZZZZZZZZZZZZZZZZ".

    
    IF NOT VALID-HANDLE(h-boaf022) THEN DO:
        RUN afbo/boaf022.p PERSISTENT SET h-boaf022.
        RUN openQueryStatic IN h-boaf022 (INPUT "Main":U) NO-ERROR.
    END.

    DEFINE VARIABLE l-usa-versao AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-usa-formula AS LOGICAL     NO-UNDO.

    RUN getLogField IN h-boaf022 (INPUT "log-usa-versao":U, OUTPUT l-usa-versao).
    RUN getLogField IN h-boaf022 (INPUT "log-versao-formula":U, OUTPUT l-usa-formula).

    IF l-usa-versao = TRUE AND l-usa-formula = TRUE THEN DO:
        ENABLE i-nr-versao-ini
               i-nr-versao-fim
        WITH FRAME fpage1.
        ENABLE i-nr-versao-ini
               i-nr-versao-fim
        WITH FRAME fpage2.
    END.
    ELSE DO:
        DISABLE i-nr-versao-ini
                i-nr-versao-fim
        WITH FRAME fpage1.
        DISABLE i-nr-versao-ini
                i-nr-versao-fim
        WITH FRAME fpage2.
    END.

    ENABLE i-cod-formula-ini
           i-cod-formula-fim
           btcheck1
        WITH FRAME fpage1.

    ENABLE c-descricao-ini
           c-descricao-fim
           btCheck2
        WITH FRAME fpage2.

    APPLY 'entry' TO brTable1.
    APPLY 'entry' TO i-cod-formula-ini.
    APPLY 'entry' TO brTable2.
    APPLY 'entry' TO c-descricao-ini.

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
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable1}) OR
       {&hDBOTable1}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable1}:FILE-NAME <> "afbo/boaf013.p":U THEN DO:
       {btb/btb008za.i1 afbo/boaf013.p YES}
       {btb/btb008za.i2 afbo/boaf013.p '' {&hDBOTable1}} 
    END.
    
    RUN setConstraintCodFormula IN {&hDBOTable1} (INPUT "", INPUT "999999", INPUT 0, INPUT 999999) NO-ERROR.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable2}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "afbo/boaf013.p":U THEN DO:
       
        {btb/btb008za.i1 afbo/boaf013.p YES}
        {btb/btb008za.i2 afbo/boaf013.p '' {&hDBOTable2}} 
    END.
    
    RUN setConstraintDescricao IN {&hDBOTable2} (INPUT "", INPUT "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ", INPUT 0, INPUT 999999) NO-ERROR.

    IF NOT VALID-HANDLE(h-boaf022) THEN DO:
        RUN afbo/boaf022.p PERSISTENT SET h-boaf022.        
    END.

    RUN openQueryStatic IN h-boaf022 (INPUT "Main":U) NO-ERROR.

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
    
    {zoom/OpenQueries.i &Query="CodFormula"
                        &PageNumber="1"}
    
    {zoom/OpenQueries.i &Query="Desc"
                        &PageNumber="2"}
    
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
            WHEN "cod-formula":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-formula).
            WHEN "descricao":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.descricao).
            WHEN "nr-versao":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nr-versao).
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
            WHEN "descricao":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.descricao).
            WHEN "cod-formula":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-formula).
            WHEN "nr-versao":U THEN 
                ASSIGN pcFieldValue = STRING({&ttTable2}.nr-versao).
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
            RUN setConstraintCodFormula IN {&hDBOTable1} (INPUT i-cod-formula-ini:SCREEN-VALUE IN FRAME fpage1,
                                                          INPUT i-cod-formula-fim:SCREEN-VALUE IN FRAME fpage1,
                                                          INPUT i-nr-versao-ini:SCREEN-VALUE IN FRAME fpage1,
                                                          INPUT i-nr-versao-fim:SCREEN-VALUE IN FRAME fpage1).
        
        WHEN 2 THEN
            /*:T--- Seta Constraints para o DBO Table2 ---*/
            RUN setConstraintDescricao IN {&hDBOTable2} (INPUT c-descricao-ini:SCREEN-VALUE IN FRAME fpage2,
                                                         INPUT c-descricao-fim:SCREEN-VALUE IN FRAME fpage2,
                                                         INPUT i-nr-versao-ini:SCREEN-VALUE IN FRAME fpage2,
                                                         INPUT i-nr-versao-fim:SCREEN-VALUE IN FRAME fpage2).
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

