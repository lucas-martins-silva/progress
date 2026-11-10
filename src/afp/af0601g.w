&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI 
&ANALYZE-RESUME
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
{include/i-prgvrs.i AF0601G 2.00.00.000}  /*** 010002 ***/
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
&GLOBAL-DEFINE Program        AF0601G
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 ~
                              c-titulo c-eixo-x c-eixo-y ~
                              rs-tipo rs-linhas
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                */
{utp/utapi011.i}

def input-output param TABLE FOR tt-atributos.
DEF OUTPUT PARAM p-cancela AS LOG NO-UNDO.

ASSIGN p-cancela = YES.

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
&Scoped-Define ENABLED-OBJECTS c-titulo c-eixo-x rs-tipo c-eixo-y rs-linhas ~
btHelp2 btOK btCancel RECT-27 RECT-28 RECT-29 RECT-30 RECT-31 RECT-4 ~
rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS c-titulo c-eixo-x rs-tipo c-eixo-y ~
rs-linhas 

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

DEFINE VARIABLE c-eixo-x AS CHARACTER FORMAT "X(60)":U 
     LABEL "T¡tulo X" 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-eixo-y AS CHARACTER FORMAT "X(60)":U 
     LABEL "T¡tulo Y" 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-titulo AS CHARACTER FORMAT "X(80)":U 
     LABEL "T¡tulo Gr fico" 
     VIEW-AS FILL-IN 
     SIZE 65 BY .88 NO-UNDO.

DEFINE VARIABLE rs-linhas AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Sem linhas estat¡sticas", 1,
"Meio", 2,
"Valores m ximo e m¡nimo", 3,
"Valores m ximo e m¡nimo e linha de meio", 4,
"Desvio padrÆo", 5,
"Desvio padrÆo e meio", 6,
"Desvio padrÆo e valores m ximo e m¡nimo", 7,
"Desvio padrÆo, valores m ximo e m¡nimo e meio", 8,
"Tendˆncia", 9,
"Tendˆncia e meio", 10,
"Tendˆncia e valores m ximo e m¡nimo", 11,
"Tendˆncia, valores m ximo e m¡nimo e meio", 12,
"Tendˆncia e linha de desvio padrÆo", 13,
"Tendˆncia, desvio padrÆo e meio", 14,
"Tendˆncia, desvio padrÆo e valores m ximo e m¡nimo", 15,
"Todas as linhas", 16
     SIZE 45 BY 11.25 NO-UNDO.

DEFINE VARIABLE rs-tipo AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pizza 2D", 1,
"Pizza 3D", 2,
"Barra 2D", 3,
"Barra 3D", 4,
"Gantt", 5,
"Linha", 6,
"Log/lin", 7,
"µrea 2D", 8,
"DispersÆo 2D", 9,
"Polar", 10,
"High-low-close", 11,
"Bolha", 12,
"Fita", 13,
"µrea 3D", 14,
"Log/log", 15,
"Lin/log", 16,
"Box-whisker", 17,
"Open-high-low-close", 18,
"Casti‡al", 19,
"Superf¡cie True3D", 20,
"DispersÆo True3D", 21,
"Time series", 22
     SIZE 25 BY 14 NO-UNDO.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 78 BY 1.5.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 78 BY 1.5.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29 BY 14.75.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 48 BY 12.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 48 BY 2.5.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 17.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 80 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-titulo AT ROW 1.5 COL 11 COLON-ALIGNED
     c-eixo-x AT ROW 3.25 COL 10 COLON-ALIGNED
     rs-tipo AT ROW 3.5 COL 53 NO-LABEL
     c-eixo-y AT ROW 4.25 COL 10 COLON-ALIGNED
     rs-linhas AT ROW 6.25 COL 3 NO-LABEL
     btHelp2 AT ROW 18.5 COL 70
     btOK AT ROW 18.54 COL 2
     btCancel AT ROW 18.54 COL 13
     RECT-27 AT ROW 1.25 COL 2
     RECT-28 AT ROW 1.25 COL 2
     RECT-29 AT ROW 3 COL 51
     RECT-30 AT ROW 5.75 COL 2
     RECT-31 AT ROW 3 COL 2
     RECT-4 AT ROW 1 COL 1
     rtToolBar AT ROW 18.25 COL 1
     "Tipo Gr fico" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 2.75 COL 52
     "Linhas estat¡sticas" VIEW-AS TEXT
          SIZE 14 BY .54 AT ROW 5.5 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.14 BY 18.75
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
         HEIGHT             = 18.75
         WIDTH              = 80.14
         MAX-HEIGHT         = 19.63
         MAX-WIDTH          = 99.72
         VIRTUAL-HEIGHT     = 19.63
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
    ASSIGN p-cancela = YES.
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

    ASSIGN tt-atributos.graphtype   = INPUT FRAME fpage0 rs-tipo
           tt-atributos.graphtitle  = INPUT FRAME fpage0 c-titulo
           tt-atributos.bottomtitle = INPUT FRAME fpage0 c-eixo-x
           tt-atributos.lefttitle   = INPUT FRAME fpage0 c-eixo-y
           tt-atributos.LineStats   = INPUT FRAME fpage0 rs-linhas - 1.

    ASSIGN p-cancela = NO.
           
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
    
    FIND FIRST tt-atributos NO-ERROR.
                                              
    ASSIGN rs-tipo    = tt-atributos.graphtype
           c-titulo   = tt-atributos.graphtitle
           c-eixo-x   = tt-atributos.bottomtitle
           c-eixo-y   = tt-atributos.lefttitle
           rs-linhas  = tt-atributos.LineStats + 1.

    DISP rs-tipo c-titulo c-eixo-x c-eixo-y rs-linhas WITH FRAME fpage0.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

