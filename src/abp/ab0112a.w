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
{include/i-prgvrs.i AB0112A 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0112a MAB}
&ENDIF


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
&GLOBAL-DEFINE Program       AB0112A
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE page0Widgets   tbOleo  tbFiltro tbMecanica tbParada tbCustos tbOutros btOK btCancel  btHelp

/* Parameters Definitions ---                                           */


def  input-output parameter lOleo     as logical. 
def  input-output parameter lFiltro   as logical. 
def  input-output parameter lMecanica as logical. 
def  input-output parameter lParada   as logical. 
def  input-output parameter lCustos   as logical. 
def  input-output parameter lOutros   as logical. 
def  input-output parameter l-ok      as logical. 


/* Local Variable Definitions ---                                       */
def var c-lista-estados as char no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbOleo tbFiltro tbMecanica tbParada tbCustos ~
tbOutros btOK btCancel btHelp RECT-16 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS tbOleo tbFiltro tbMecanica tbParada ~
tbCustos tbOutros 

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

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34 BY 6.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 34 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tbCustos AS LOGICAL INITIAL yes 
     LABEL "Custos" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tbFiltro AS LOGICAL INITIAL yes 
     LABEL "Manuten‡Æo Filtros" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .88 NO-UNDO.

DEFINE VARIABLE tbMecanica AS LOGICAL INITIAL yes 
     LABEL "Manuten‡Æo Mecƒnica" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE tbOleo AS LOGICAL INITIAL yes 
     LABEL "Manuten‡Æo Compartimentos àleo" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE tbOutros AS LOGICAL INITIAL yes 
     LABEL "Outros" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tbParada AS LOGICAL INITIAL yes 
     LABEL "Motivos de Parada" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tbOleo AT ROW 2.04 COL 4
     tbFiltro AT ROW 3.04 COL 4
     tbMecanica AT ROW 4.04 COL 4
     tbParada AT ROW 5.04 COL 4
     tbCustos AT ROW 6.04 COL 4
     tbOutros AT ROW 7.04 COL 4
     btOK AT ROW 8.63 COL 1.43
     btCancel AT ROW 8.63 COL 12.43
     btHelp AT ROW 8.63 COL 24.57
     RECT-16 AT ROW 1.71 COL 1
     rtToolBar AT ROW 8.38 COL 1
     "Filtro" VIEW-AS TEXT
          SIZE 5.29 BY .71 AT ROW 1.29 COL 3.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.57 ROW 1
         SIZE 34.86 BY 8.92
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
         TITLE              = "Filtro"
         HEIGHT             = 8.96
         WIDTH              = 35
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 146.29
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
ON END-ERROR OF wWindow /* Filtro */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Filtro */
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
    assign l-ok    = no.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    assign lOleo       =  tbOleo:checked in frame   fPage0         
           lFiltro     =  tbFiltro:checked in frame fPage0 
           lMecanica   =  tbMecanica:checked in frame fPage0      
           lParada     =  tbParada:checked in frame fPage0      
           lCustos     =  tbCustos:checked in frame fPage0      
           lOutros     =  tbOutros:checked in frame fPage0      
           l-ok        =  yes.




  
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
ASSIGN cAuxTraducao001 = {frinc/i00fr012.i 03}.
RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao001).
ASSIGN c-lista-estados                               = cAuxTraducao001.
&else
ASSIGN c-lista-estados                               = {frinc/i00fr012.i 03}.
&endif
ASSIGN 
         tbOleo:label in frame {&frame-name}           = entry(1,c-lista-estados)   
         tbFiltro:label in frame {&frame-name}         = entry(2,c-lista-estados)
         tbMecanica:label in frame {&frame-name}       = entry(3,c-lista-estados)
         tbParada:label in frame {&frame-name}         = entry(4,c-lista-estados)
         tbCustos:label in frame {&frame-name}         = entry(5,c-lista-estados)
         tbOutros:label in frame {&frame-name}         = entry(6,c-lista-estados).   

              


/*--- L¢gica para inicializa‡Æo do programam ---*/
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
&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
ASSIGN cAuxTraducao002 = {frinc/i00fr012.i 03}.
RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao002).
ASSIGN c-lista-estados                               = cAuxTraducao002.
&else
ASSIGN c-lista-estados                               = {frinc/i00fr012.i 03}.
&endif
ASSIGN 
         tbOleo:label in frame {&frame-name}           = entry(1,c-lista-estados)   
         tbFiltro:label in frame {&frame-name}         = entry(2,c-lista-estados)
         tbMecanica:label in frame {&frame-name}       = entry(3,c-lista-estados)
         tbParada:label in frame {&frame-name}         = entry(4,c-lista-estados)
         tbCustos:label in frame {&frame-name}         = entry(5,c-lista-estados)
         tbOutros:label in frame {&frame-name}         = entry(6,c-lista-estados).   


assign   tbOleo:checked in frame fPage0                = lOleo 
         tbFiltro:checked in frame fPage0              = lFiltro
         tbMecanica:checked in frame fPage0            = lMecanica
         tbParada:checked in frame fPage0              = lParada
         tbCustos:checked in frame fPage0              = lCustos
         tbOutros:checked in frame fPage0              = lOutros.
       
   

         


RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

