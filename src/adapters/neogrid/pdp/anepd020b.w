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
{include/i-prgvrs.i ANEPD020B 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEPD020B MPD}
&ENDIF


/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ANEPD020B
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 ~
                              tb-sald-terc l-entrada-benef l-remessa-benef l-entrada-consig l-remessa-consig l-transferencia

def input-output param p-sald-terc      as log no-undo.
def input-output param p-entrada-benef  as log no-undo.
def input-output param p-remessa-benef  as log no-undo.
def input-output param p-entrada-consig as log no-undo.
def input-output param p-remessa-consig as log no-undo.
def input-output param p-transferencia  as log no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tb-sald-terc l-remessa-benef l-entrada-benef ~
l-transferencia l-remessa-consig l-entrada-consig btOK btCancel btHelp2 ~
RECT-38 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS tb-sald-terc l-remessa-benef ~
l-entrada-benef l-transferencia l-remessa-consig l-entrada-consig fi-titulo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-titulo AS CHARACTER FORMAT "X(25)":U 
      VIEW-AS TEXT 
     SIZE 28 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-38
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 39 BY 7.08.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 40 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE l-entrada-benef AS LOGICAL INITIAL no 
     LABEL "Entrada p/ Beneficiamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.43 BY .83 NO-UNDO.

DEFINE VARIABLE l-entrada-consig AS LOGICAL INITIAL no 
     LABEL "Entrada em Consigna‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.43 BY .83 NO-UNDO.

DEFINE VARIABLE l-remessa-benef AS LOGICAL INITIAL yes 
     LABEL "Remessa p/ Beneficiamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.43 BY .83 NO-UNDO.

DEFINE VARIABLE l-remessa-consig AS LOGICAL INITIAL yes 
     LABEL "Remessa em Consigna‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.43 BY .83 NO-UNDO.

DEFINE VARIABLE l-transferencia AS LOGICAL INITIAL yes 
     LABEL "Transferˆncia" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.43 BY .83 NO-UNDO.

DEFINE VARIABLE tb-sald-terc AS LOGICAL INITIAL yes 
     LABEL "Considera Saldo em Poder de Terceiros?" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tb-sald-terc AT ROW 1.96 COL 4
     l-remessa-benef AT ROW 2.96 COL 4
     l-entrada-benef AT ROW 3.96 COL 4
     l-transferencia AT ROW 4.96 COL 4
     l-remessa-consig AT ROW 5.96 COL 4
     l-entrada-consig AT ROW 6.96 COL 4
     btOK AT ROW 8.96 COL 2
     btCancel AT ROW 8.96 COL 13
     btHelp2 AT ROW 8.96 COL 30
     fi-titulo AT ROW 1.25 COL 6 COLON-ALIGNED NO-LABEL
     RECT-38 AT ROW 1.42 COL 2
     rtToolBar AT ROW 8.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 40.72 BY 9.29
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
         HEIGHT             = 9.42
         WIDTH              = 40.29
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
/* SETTINGS FOR FILL-IN fi-titulo IN FRAME fpage0
   NO-ENABLE                                                            */
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
    ASSIGN p-sald-terc      = tb-sald-terc:CHECKED     IN FRAME fPage0
           p-entrada-benef  = l-entrada-benef:CHECKED  IN FRAME fPage0
           p-remessa-benef  = l-remessa-benef:CHECKED  IN FRAME fPage0
           p-entrada-consig = l-entrada-consig:CHECKED IN FRAME fPage0
           p-remessa-consig = l-remessa-consig:CHECKED IN FRAME fPage0
           p-transferencia  = l-transferencia:CHECKED  IN FRAME fPage0.
        
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
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

    {utp/ut-liter.i Considera_Saldo_em_Poder_de_Terceiros? MPD r} assign tb-sald-terc:label in frame fPage0 = trim(return-value).
    {utp/ut-liter.i Saldo_em_Terceiros        MPD r} assign fi-titulo = trim(return-value). 
    {utp/ut-liter.i Remessa_p/_Beneficiamento MPD r} assign l-remessa-benef:LABEL  in frame fPage0 = trim(return-value).
    {utp/ut-liter.i Entrada_p/_Beneficiamento MPD r} assign l-entrada-benef:label  in frame fPage0 = trim(return-value).
    {utp/ut-liter.i Transferˆncia             MPD r} assign l-transferencia:LABEL  in frame fPage0 = trim(return-value).
    {utp/ut-liter.i Entrada_em_Consigna‡Æo    MPD r} assign l-entrada-consig:label in frame fPage0 = trim(return-value).
    {utp/ut-liter.i Remessa_em_Consigna‡Æo    MPD r} assign l-remessa-consig:label in frame fPage0 = trim(return-value).

    DISP fi-titulo WITH FRAME fPage0.
    
    ASSIGN tb-sald-terc:CHECKED     IN FRAME fPage0 = p-sald-terc     
           l-entrada-benef:CHECKED  IN FRAME fPage0 = p-entrada-benef 
           l-remessa-benef:CHECKED  IN FRAME fPage0 = p-remessa-benef 
           l-entrada-consig:CHECKED IN FRAME fPage0 = p-entrada-consig
           l-remessa-consig:CHECKED IN FRAME fPage0 = p-remessa-consig
           l-transferencia:CHECKED  IN FRAME fPage0 = p-transferencia.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

