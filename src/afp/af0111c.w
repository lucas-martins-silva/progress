&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0111C 2.00.00.001 } /*** 010001 ***/
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
&GLOBAL-DEFINE Program        AF0111C
&GLOBAL-DEFINE Version        2.00.00.001
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          NO
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          NO
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   
&GLOBAL-DEFINE page5Widgets   
&GLOBAL-DEFINE page6Widgets   
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */

DEF INPUT PARAM pCodGrpAvaliacao LIKE af-grp-avaliacao.cod-grp-avaliacao NO-UNDO.
DEF INPUT-OUTPUT PARAM pCodEstabIni       AS CHARACTER NO-UNDO.
DEF INPUT-OUTPUT PARAM pCodEstabFim       AS CHARACTER NO-UNDO.
DEF INPUT-OUTPUT PARAM pCodItemIni        AS CHARACTER NO-UNDO.
DEF INPUT-OUTPUT PARAM pCodItemFim        AS CHARACTER NO-UNDO.
DEF INPUT-OUTPUT PARAM pCodFornecIni      AS INTEGER   NO-UNDO.
DEF INPUT-OUTPUT PARAM pCodFornecFim      AS INTEGER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-10 IMAGE-15 IMAGE-16 IMAGE-17 IMAGE-2 ~
IMAGE-4 RECT-20 rtToolBar c-cod-estab-ini c-cod-estab-fim c-cod-item-ini ~
c-cod-item-fim i-cod-fornec-ini i-cod-fornec-fim btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estab-ini c-cod-estab-fim ~
c-cod-item-ini c-cod-item-fim i-cod-fornec-ini i-cod-fornec-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-cod-estab-fim AS CHARACTER FORMAT "X(05)" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE c-cod-estab-ini AS CHARACTER FORMAT "X(05)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE c-cod-item-fim AS CHARACTER FORMAT "X(16)" 
     VIEW-AS FILL-IN 
     SIZE 26.72 BY .88.

DEFINE VARIABLE c-cod-item-ini AS CHARACTER FORMAT "X(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 26.72 BY .88.

DEFINE VARIABLE i-cod-fornec-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-cod-fornec-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-fir":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image/im-fir":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-fir":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.86 BY 3.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-cod-estab-ini AT ROW 1.5 COL 13 COLON-ALIGNED HELP
          "C¢digo do Estabelecimento."
     c-cod-estab-fim AT ROW 1.5 COL 51 COLON-ALIGNED HELP
          "C¢digo do Estabelecimento." NO-LABEL
     c-cod-item-ini AT ROW 2.5 COL 13 COLON-ALIGNED HELP
          "C¢digo do Item."
     c-cod-item-fim AT ROW 2.5 COL 51 COLON-ALIGNED HELP
          "C¢digo do Item." NO-LABEL
     i-cod-fornec-ini AT ROW 3.5 COL 13 COLON-ALIGNED HELP
          "C¢digo do Fornecedor."
     i-cod-fornec-fim AT ROW 3.5 COL 51 COLON-ALIGNED HELP
          "C¢digo do Fornecedor." NO-LABEL
     btOK AT ROW 5.21 COL 2
     btCancel AT ROW 5.21 COL 13
     btHelp2 AT ROW 5.21 COL 80
     IMAGE-10 AT ROW 2.5 COL 43
     IMAGE-15 AT ROW 2.5 COL 49
     IMAGE-16 AT ROW 3.5 COL 43
     IMAGE-17 AT ROW 3.5 COL 48.72
     IMAGE-2 AT ROW 1.5 COL 43
     IMAGE-4 AT ROW 1.5 COL 49
     RECT-20 AT ROW 1 COL 1.14
     rtToolBar AT ROW 5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 99 BY 5.58
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 5.54
         WIDTH              = 90.14
         MAX-HEIGHT         = 29.29
         MAX-WIDTH          = 182.43
         VIRTUAL-HEIGHT     = 29.29
         VIRTUAL-WIDTH      = 182.43
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{Report~/Report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

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

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wReport
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:

    ASSIGN pCodEstabIni  = c-cod-estab-ini:screen-value  IN FRAME fPage0
           pCodEstabFim  = c-cod-estab-fim:screen-value  IN FRAME fPage0
           pCodItemIni   = c-cod-item-ini:screen-value   IN FRAME fPage0 
           pCodItemFim   = c-cod-item-fim:screen-value   IN FRAME fPage0 
           pCodFornecIni = INT(i-cod-fornec-ini:screen-value IN FRAME fPage0)
           pCodFornecFim = INT(i-cod-fornec-fim:screen-value IN FRAME fPage0).

    APPLY "CLOSE":U TO THIS-PROCEDURE.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*--- L¢gica para inicializa‡Æo do programam ---*/

ASSIGN c-cod-estab-ini:Sensitive       IN FRAME fPage0 = YES 
       c-cod-estab-fim:Sensitive       IN FRAME fPage0 = YES
       c-cod-item-ini:Sensitive          IN FRAME fPage0 = YES 
       c-cod-item-fim:Sensitive          IN FRAME fPage0 = YES
       i-cod-fornec-ini:Sensitive        IN FRAME fPage0 = YES
       i-cod-fornec-fim:Sensitive        IN FRAME fPage0 = YES
       c-cod-estab-ini:SCREEN-VALUE IN FRAME fPage0 = pCodEstabIni 
       c-cod-estab-fim:SCREEN-VALUE IN FRAME fPage0 = pCodEstabFim
       c-cod-item-ini:SCREEN-VALUE    IN FRAME fPage0 = pCodItemIni 
       c-cod-item-fim:SCREEN-VALUE    IN FRAME fPage0 = pCodItemFim
       i-cod-fornec-ini:SCREEN-VALUE  IN FRAME fPage0 = STRING(pCodFornecIni)
       i-cod-fornec-fim:SCREEN-VALUE  IN FRAME fPage0 = STRING(pCodFornecFim).
       
{report/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


