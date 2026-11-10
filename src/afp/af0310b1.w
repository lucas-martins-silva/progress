&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI 
&ANALYZE-RESUME
/* Connected Databases 
          emscda           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-af-contr-indice NO-UNDO LIKE af-contr-indice
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0310B 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AF0310B
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         no

&GLOBAL-DEFINE page0Widgets   btOK btHelp2 

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER i-epcodigo    LIKE af-item-contr-estab.ep-codigo NO-UNDO.
DEFINE INPUT  PARAMETER c-Itcodigo    LIKE af-item-contr-estab.it-codigo NO-UNDO.
DEFINE INPUT  PARAMETER i-Codemitente LIKE af-item-contr-estab.cod-emitente NO-UNDO.
DEFINE INPUT  PARAMETER c-Codestabel  LIKE af-item-contr-estab.cod-estabel NO-UNDO.
DEFINE INPUT  PARAMETER i-Nrcontrole  LIKE af-controle.nr-controle NO-UNDO.

/* Local Variable Definitions ---                                       */
define variable h-boaf008 as handle no-undo.

DEFINE VARIABLE c-narrativa-1 LIKE af-controle.narrativa NO-UNDO.             
DEFINE VARIABLE c-narrativa-2 LIKE af-item-contr-estab.narrativa NO-UNDO.     
DEFINE VARIABLE c-narrativa-3 LIKE af-item-contr-estab-form.narrativa NO-UNDO.
DEFINE VARIABLE c-narrativa-4 LIKE ITEM.narrativa NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS EDITOR_narrativa EDITOR_narrativa-2 ~
EDITOR_narrativa-3 EDITOR_narrativa-4 btOK btHelp2 RECT-47 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS EDITOR_narrativa EDITOR_narrativa-2 ~
EDITOR_narrativa-3 EDITOR_narrativa-4 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE EDITOR_narrativa AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 60 BY 3.5.

DEFINE VARIABLE EDITOR_narrativa-2 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 60 BY 3.5.

DEFINE VARIABLE EDITOR_narrativa-3 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 60 BY 3.5.

DEFINE VARIABLE EDITOR_narrativa-4 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 60 BY 3.5.

DEFINE RECTANGLE RECT-47
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 67 BY 18.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 67 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     EDITOR_narrativa AT ROW 2 COL 4 NO-LABEL
     EDITOR_narrativa-2 AT ROW 6.75 COL 4 NO-LABEL
     EDITOR_narrativa-3 AT ROW 11.25 COL 4 NO-LABEL
     EDITOR_narrativa-4 AT ROW 15.75 COL 4 NO-LABEL
     btOK AT ROW 19.96 COL 2
     btHelp2 AT ROW 20 COL 54
     RECT-47 AT ROW 1 COL 1
     rtToolBar AT ROW 19.75 COL 1
     "Narrativa Ponto Controle" VIEW-AS TEXT
          SIZE 19 BY .54 AT ROW 1.25 COL 26
     "Narrativa Item X Fornec X Estab" VIEW-AS TEXT
          SIZE 23 BY .54 AT ROW 6 COL 24
     "Narrativa Item X Fornec X Estab Ponto Controle" VIEW-AS TEXT
          SIZE 33 BY .54 AT ROW 10.5 COL 18
     "Narrativa Item" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 15 COL 29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 67.57 BY 20.33
         FONT 1
         DEFAULT-BUTTON btOK.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-af-contr-indice T "?" NO-UNDO emscda af-contr-indice
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 20.29
         WIDTH              = 67.43
         MAX-HEIGHT         = 26.88
         MAX-WIDTH          = 128.43
         VIRTUAL-HEIGHT     = 26.88
         VIRTUAL-WIDTH      = 128.43
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
   NOT-VISIBLE FRAME-NAME                                               */
ASSIGN 
       EDITOR_narrativa:READ-ONLY IN FRAME fpage0        = TRUE.

ASSIGN 
       EDITOR_narrativa-2:READ-ONLY IN FRAME fpage0        = TRUE.

ASSIGN 
       EDITOR_narrativa-3:READ-ONLY IN FRAME fpage0        = TRUE.

ASSIGN 
       EDITOR_narrativa-4:READ-ONLY IN FRAME fpage0        = TRUE.

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
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if  valid-handle (h-boaf008) then do:
        delete procedure h-boaf008.
        assign h-boaf008 = ?.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    RUN piRetornaNarrativa IN h-boaf008 ( INPUT i-epcodigo,   
                                          INPUT c-Itcodigo,   
                                          INPUT i-Codemitente,
                                          INPUT c-Codestabel, 
                                          INPUT i-Nrcontrole, 
                                          OUTPUT c-narrativa-1,
                                          OUTPUT c-narrativa-2,
                                          OUTPUT c-narrativa-3,
                                          OUTPUT c-narrativa-4).

    ASSIGN EDITOR_narrativa:SCREEN-VALUE IN FRAME fpage0 = c-narrativa-1
           EDITOR_narrativa-2:SCREEN-VALUE IN FRAME fpage0 = c-narrativa-2
           EDITOR_narrativa-3:SCREEN-VALUE IN FRAME fpage0 = c-narrativa-3
           EDITOR_narrativa-4:SCREEN-VALUE IN FRAME fpage0 = c-narrativa-4.

    ENABLE EDITOR_narrativa 
           EDITOR_narrativa-2
           EDITOR_narrativa-3
           EDITOR_narrativa-4 WITH FRAME fpage0.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if  not valid-handle (h-boaf008) then
        run afbo/boaf008.p persistent set h-boaf008.

    run openQueryStatic in h-boaf008 (input "Main").

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

