&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0518 2.00.00.001}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0518 MIM}
&ENDIF


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0518
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

 DEFINE INPUT  PARAMETER pr-item-fornec AS ROWID      NO-UNDO.  

/* Local Variable Definitions ---                                       */

 DEFINE VARIABLE h-boin178i  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE h-boad098na AS HANDLE     NO-UNDO.
 DEFINE VARIABLE h-boun006   AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS i-cdn-fabrican c-desc-fabricante ~
i-cdn-pais-orig c-desc-pais btOK btCancel btHelp2 RECT-1 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS i-cdn-fabrican c-desc-fabricante ~
i-cdn-pais-orig c-desc-pais 

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

DEFINE VARIABLE c-desc-fabricante AS CHARACTER FORMAT "x(40)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-pais AS CHARACTER FORMAT "x(40)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-fabrican AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fabricante" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-pais-orig AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Pa¡s de Origem" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 62 BY 3.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 63 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     i-cdn-fabrican AT ROW 2.29 COL 12.72 COLON-ALIGNED
     c-desc-fabricante AT ROW 2.29 COL 25 COLON-ALIGNED NO-LABEL
     i-cdn-pais-orig AT ROW 3.29 COL 12.72 COLON-ALIGNED
     c-desc-pais AT ROW 3.29 COL 25 COLON-ALIGNED NO-LABEL
     btOK AT ROW 5.58 COL 2
     btCancel AT ROW 5.58 COL 13
     btHelp2 AT ROW 5.58 COL 52
     RECT-1 AT ROW 1.5 COL 1.43
     rtToolBar AT ROW 5.38 COL 1
     "Regime de Importa‡Æo" VIEW-AS TEXT
          SIZE 16.29 BY .54 AT ROW 1.25 COL 2.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 63.43 BY 6.13
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
         HEIGHT             = 6
         WIDTH              = 63
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
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
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cdn-fabrican
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cdn-fabrican wWindow
ON LEAVE OF i-cdn-fabrican IN FRAME fpage0 /* Fabricante */
DO:
    {method/ReferenceFields.i 
    &HandleDBOLeave="h-boad098na"
    &KeyValue1="integer(i-cdn-fabrican:screen-value in frame fPage0)"
    &FieldName1="nome-abrev"
    &FieldScreen1="c-desc-fabricante"
    &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cdn-pais-orig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cdn-pais-orig wWindow
ON LEAVE OF i-cdn-pais-orig IN FRAME fpage0 /* Pa¡s de Origem */
DO:
    &GLOBAL-DEFINE DBOVersion     1.1
    
    {method/ReferenceFields.i 
    &HandleDBOLeave="h-boun006"
    &FindMethod="findCh_pais"
    &KeyValue1="i-cdn-pais-orig:SCREEN-VALUE IN FRAME fPage0"
    &FieldName1="nome-pais"
    &FieldScreen1="c-desc-pais"
    &Frame1="fPage0"}
    
    &GLOBAL-DEFINE DBOVersion     0
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

  IF  VALID-HANDLE(h-boin178i) THEN DO:
      RUN destroy IN h-boin178i.
      ASSIGN h-boin178i = ?.
  END.

  IF  VALID-HANDLE(h-boad098na) THEN DO:
      DELETE PROCEDURE h-boad098na NO-ERROR.
      ASSIGN h-boad098na = ?.
  END.

  IF  VALID-HANDLE(h-boun006) THEN DO:
      DELETE PROCEDURE h-boun006 NO-ERROR.
      ASSIGN h-boun006 = ?.
  END.


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

  DEFINE VARIABLE i-cdn-fabrican-aux  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i-cdn-pais-orig-aux AS INTEGER    NO-UNDO.

  IF NOT VALID-HANDLE(h-boin178i) THEN RUN inbo/boin178i.p PERSISTENT SET h-boin178i.

  IF  NOT VALID-HANDLE(h-boad098na) THEN
      RUN adbo/boad098na.p PERSISTENT SET h-boad098na. 

  RUN openQueryStatic IN h-boad098na (INPUT "Main":U).

  if  not valid-handle(h-boun006) then do:
      run unbo/boun006.p persistent set h-boun006.
  end.    

  IF pr-item-fornec <> ? THEN DO:

      RUN getImportFields IN h-boin178i (INPUT  pr-item-fornec,
                                         OUTPUT i-cdn-fabrican-aux,
                                         OUTPUT i-cdn-pais-orig-aux).

      ASSIGN i-cdn-fabrican:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = STRING(i-cdn-fabrican-aux)
             i-cdn-pais-orig:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(i-cdn-pais-orig-aux).

      APPLY "LEAVE":U TO i-cdn-fabrican  IN FRAME {&FRAME-NAME}.
      APPLY "LEAVE":U TO i-cdn-pais-orig IN FRAME {&FRAME-NAME}.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

