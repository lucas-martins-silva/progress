&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI 
&ANALYZE-RESUME
/* Connected Databases 
          emscda           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0601F 2.00.00.000}  /*** 010002 ***/
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
&GLOBAL-DEFINE Program        AF0601F
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 ~
                              c-cod-grp-aval-ini c-cod-grp-aval-fim ~
                              c-cod-grp-resp-ini c-cod-grp-resp-fim ~
                              i-cod-gr-forn-ini i-cod-gr-forn-fim ~
                              c-fm-codigo-ini c-fm-codigo-fim ~
                              i-ge-codigo-ini i-ge-codigo-fim rs-media
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
def input-output param p-cod-grp-aval-ini  like af-item-contr-estab.cod-grp-avaliacao no-undo.
def input-output param p-cod-grp-aval-fim  like af-item-contr-estab.cod-grp-avaliacao no-undo.
def input-output param p-cod-grp-resp-ini  like af-item-contr-estab-form.cod-grp-resp no-undo.
def input-output param p-cod-grp-resp-fim  like af-item-contr-estab-form.cod-grp-resp no-undo.
def input-output param p-cod-gr-forn-ini   like emitente.cod-gr-forn no-undo.
def input-output param p-cod-gr-forn-fim   like emitente.cod-gr-forn no-undo.
def input-output param p-fm-codigo-ini     like item.fm-codigo       no-undo.
def input-output param p-fm-codigo-fim     like item.fm-codigo       no-undo.
def input-output param p-ge-codigo-ini     like item.ge-codigo       no-undo.
def input-output param p-ge-codigo-fim     like item.ge-codigo       no-undo.
def input-output param p-media             as   int                  no-undo.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-cod-grp-aval-ini c-cod-grp-aval-fim ~
c-cod-grp-resp-ini c-cod-grp-resp-fim i-cod-gr-forn-ini i-cod-gr-forn-fim ~
c-fm-codigo-ini c-fm-codigo-fim i-ge-codigo-ini i-ge-codigo-fim rs-media ~
btHelp2 btOK btCancel IMAGE-1 IMAGE-109 IMAGE-110 IMAGE-2 IMAGE-91 IMAGE-92 ~
IMAGE-93 IMAGE-94 IMAGE-95 IMAGE-96 RECT-33 RECT-4 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS c-cod-grp-aval-ini c-cod-grp-aval-fim ~
c-cod-grp-resp-ini c-cod-grp-resp-fim i-cod-gr-forn-ini i-cod-gr-forn-fim ~
c-fm-codigo-ini c-fm-codigo-fim i-ge-codigo-ini i-ge-codigo-fim rs-media 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-cod-grp-aval-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-grp-aval-ini LIKE af-item-contr-estab.cod-grp-avaliacao
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-grp-resp-fim AS CHARACTER FORMAT "X(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE c-cod-grp-resp-ini AS CHARACTER FORMAT "X(8)" 
     LABEL "Grupo Respons vel" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-fm-codigo-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE c-fm-codigo-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Fam¡lia":R9 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-cod-gr-forn-fim AS INTEGER FORMAT ">9" INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE i-cod-gr-forn-ini AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "Grupo Fornecedor":R18 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE i-ge-codigo-fim AS INTEGER FORMAT ">9" INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE i-ge-codigo-ini AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "Grupo Estoque":R16 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-109
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-110
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-91
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-92
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-93
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-94
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-95
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-96
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-media AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Sem m‚dia", 1,
"Com m‚dia", 2,
"Somente m‚dia", 3
     SIZE 43 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 50 BY 2.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 50 BY 5.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 50 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-cod-grp-aval-ini AT ROW 1.5 COL 14 COLON-ALIGNED
     c-cod-grp-aval-fim AT ROW 1.5 COL 36 COLON-ALIGNED NO-LABEL
     c-cod-grp-resp-ini AT ROW 2.5 COL 14 COLON-ALIGNED
     c-cod-grp-resp-fim AT ROW 2.5 COL 36 COLON-ALIGNED NO-LABEL
     i-cod-gr-forn-ini AT ROW 3.5 COL 22 COLON-ALIGNED HELP
          "C¢digo do grupo de fornecedores"
     i-cod-gr-forn-fim AT ROW 3.5 COL 36 COLON-ALIGNED HELP
          "C¢digo do grupo de fornecedores" NO-LABEL
     c-fm-codigo-ini AT ROW 4.5 COL 16 COLON-ALIGNED HELP
          "Fam¡lia de material a que pertence o item"
     c-fm-codigo-fim AT ROW 4.5 COL 36 COLON-ALIGNED HELP
          "Fam¡lia de material a que pertence o item" NO-LABEL
     i-ge-codigo-ini AT ROW 5.5 COL 22 COLON-ALIGNED HELP
          "Grupo de estoque a que pertence o item"
     i-ge-codigo-fim AT ROW 5.5 COL 36 COLON-ALIGNED HELP
          "Grupo de estoque a que pertence o item" NO-LABEL
     rs-media AT ROW 7.25 COL 4 NO-LABEL
     btHelp2 AT ROW 9.25 COL 40
     btOK AT ROW 9.29 COL 2
     btCancel AT ROW 9.29 COL 13
     IMAGE-1 AT ROW 3.5 COL 29
     IMAGE-109 AT ROW 2.5 COL 29
     IMAGE-110 AT ROW 2.5 COL 34
     IMAGE-2 AT ROW 3.5 COL 34
     IMAGE-91 AT ROW 4.5 COL 29
     IMAGE-92 AT ROW 4.5 COL 34
     IMAGE-93 AT ROW 5.5 COL 29
     IMAGE-94 AT ROW 5.5 COL 34
     IMAGE-95 AT ROW 1.5 COL 29
     IMAGE-96 AT ROW 1.5 COL 34
     RECT-33 AT ROW 6.75 COL 1
     RECT-4 AT ROW 1 COL 1
     rtToolBar AT ROW 9 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.04
         SIZE 50.14 BY 9.46
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
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 9.5
         WIDTH              = 50.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 99.72
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 99.72
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
/* SETTINGS FOR FILL-IN c-cod-grp-aval-ini IN FRAME fpage0
   LIKE = emscda.af-item-contr-estab.cod-grp-avaliacao EXP-SIZE         */
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


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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

    assign p-cod-grp-aval-ini = input frame fpage0 c-cod-grp-aval-ini
           p-cod-grp-aval-fim = input frame fpage0 c-cod-grp-aval-fim
           p-cod-grp-resp-ini = INPUT FRAME fpage0 c-cod-grp-resp-ini
           p-cod-grp-resp-fim = INPUT FRAME fpage0 c-cod-grp-resp-fim
           p-cod-gr-forn-ini  = input frame fpage0 i-cod-gr-forn-ini
           p-cod-gr-forn-fim  = input frame fpage0 i-cod-gr-forn-fim
           p-fm-codigo-ini    = input frame fpage0 c-fm-codigo-ini
           p-fm-codigo-fim    = input frame fpage0 c-fm-codigo-fim
           p-ge-codigo-ini    = input frame fpage0 i-ge-codigo-ini
           p-ge-codigo-fim    = input frame fpage0 i-ge-codigo-fim
           p-media            = input frame fpage0 rs-media.
           
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializa‡Æo do programam ---*/
{window/MainBlock.i}

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

    assign c-cod-grp-aval-ini = p-cod-grp-aval-ini  
           c-cod-grp-aval-fim = p-cod-grp-aval-fim 
           c-cod-grp-resp-ini = p-cod-grp-resp-ini
           c-cod-grp-resp-fim = p-cod-grp-resp-fim
           i-cod-gr-forn-ini  = p-cod-gr-forn-ini
           i-cod-gr-forn-fim  = p-cod-gr-forn-fim
           c-fm-codigo-ini    = p-fm-codigo-ini
           c-fm-codigo-fim    = p-fm-codigo-fim
           i-ge-codigo-ini    = p-ge-codigo-ini
           i-ge-codigo-fim    = p-ge-codigo-fim
           rs-media           = p-media.
    
    disp  c-cod-grp-aval-ini
          c-cod-grp-aval-fim
          c-cod-grp-resp-ini
          c-cod-grp-resp-fim
          i-cod-gr-forn-ini 
          i-cod-gr-forn-fim 
          c-fm-codigo-ini  
          c-fm-codigo-fim   
          i-ge-codigo-ini  
          i-ge-codigo-fim 
          rs-media with frame fPage0.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

