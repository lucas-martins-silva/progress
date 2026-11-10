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
{include/i-prgvrs.i AO0601B 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ao0601b MAO}
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
&GLOBAL-DEFINE Program        AO0601B
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 ~
                              fi-evento-fim fi-evento-ini fi-item-fim fi-item-ini fi-data-fim ~
                              fi-data-ini fi-lubrific-fim fi-lubrific-ini

def temp-table ttSelecao no-undo
     field c-ensaio-ini     as char initial "":U
     field c-ensaio-fim     as char initial "ZZZZZZZZ":U
     field d-data-ini       as date initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF 
     field d-data-fim       as date initial 12/31/9999
     field i-lubrific-ini   as int  initial 0
     field i-lubrific-fim   as int  initial 999999999
     field c-evento-ini     as char initial "":U
     field c-evento-fim     as char initial "ZZZZZZZZ":U
     field c-item-ini       as char initial "":U
     field c-item-fim       as char initial "ZZZZZZZZZZZZZZZ":U
     field lPadrao          as logical initial yes
     field lNPadrao         as logical initial yes
     field lData            as logical initial yes
     field lTexto           as logical initial yes
     field lNumerico        as logical initial yes 
     field lTabela          as logical initial yes 
     field lAprovado        as logical initial yes 
     field lReprovado       as logical initial yes 
     field lPendente        as logical initial yes 
     field lAprovUsuar      as logical initial yes. 

/* Parameters Definitions ---                                           */
define input-output parameter table for ttSelecao.
define input-output parameter pOK as logical no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-lubrific-fim fi-lubrific-ini fi-data-ini ~
fi-data-fim fi-evento-ini fi-evento-fim fi-item-ini fi-item-fim btOK ~
btCancel btHelp2 IMAGE-13 IMAGE-14 IMAGE-15 IMAGE-16 IMAGE-21 IMAGE-22 ~
IMAGE-5 IMAGE-6 RECT-30 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS fi-lubrific-fim fi-lubrific-ini ~
fi-data-ini fi-data-fim fi-evento-ini fi-evento-fim fi-item-ini fi-item-fim 

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

DEFINE VARIABLE fi-data-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-data-ini AS DATE FORMAT "99/99/9999" INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data":R12 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-evento-fim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-evento-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Evento" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-item-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-item-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-lubrific-fim AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-lubrific-ini AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Lubrifica‡Æo":R15 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-13
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 65 BY 4.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 65 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-lubrific-fim AT ROW 1.38 COL 43.57 COLON-ALIGNED HELP
          "C¢digo do Setor da Oficina" NO-LABEL
     fi-lubrific-ini AT ROW 1.42 COL 17 COLON-ALIGNED
     fi-data-ini AT ROW 2.42 COL 17 COLON-ALIGNED HELP
          "Data"
     fi-data-fim AT ROW 2.42 COL 43.72 COLON-ALIGNED NO-LABEL
     fi-evento-ini AT ROW 3.42 COL 17 COLON-ALIGNED
     fi-evento-fim AT ROW 3.42 COL 43.72 COLON-ALIGNED NO-LABEL
     fi-item-ini AT ROW 4.42 COL 17 COLON-ALIGNED
     fi-item-fim AT ROW 4.42 COL 43.72 COLON-ALIGNED NO-LABEL
     btOK AT ROW 5.88 COL 2
     btCancel AT ROW 5.88 COL 13
     btHelp2 AT ROW 5.88 COL 55
     IMAGE-13 AT ROW 2.42 COL 42
     IMAGE-14 AT ROW 2.42 COL 36
     IMAGE-15 AT ROW 1.5 COL 36
     IMAGE-16 AT ROW 1.5 COL 42
     IMAGE-21 AT ROW 3.42 COL 42
     IMAGE-22 AT ROW 3.42 COL 36
     IMAGE-5 AT ROW 4.42 COL 36
     IMAGE-6 AT ROW 4.42 COL 42
     RECT-30 AT ROW 1 COL 1
     rtToolBar AT ROW 5.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 65 BY 6.29
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
         TITLE              = "Sele‡Æo"
         HEIGHT             = 6.21
         WIDTH              = 65
         MAX-HEIGHT         = 12
         MAX-WIDTH          = 65
         VIRTUAL-HEIGHT     = 12
         VIRTUAL-WIDTH      = 65
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
ON END-ERROR OF wWindow /* Sele‡Æo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Sele‡Æo */
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

    assign pOK = no.
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
    run piGrava in this-procedure. 
    assign pOK = yes. 
    apply "CLOSE":U to this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


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
{utp/ut-liter.i Item * }
assign fi-item-ini:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i Data * }
assign fi-data-ini:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i Evento * }
assign fi-evento-ini:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i Lubrifica‡Æo * }
assign fi-lubrific-ini:label in frame fPage0 = trim(return-value).


do with frame fPage0:
    find first ttSelecao no-lock no-error.
    if avail ttSelecao then do:
        assign fi-item-ini:screen-value      = ttSelecao.c-item-ini
               fi-item-fim:screen-value      = ttSelecao.c-item-fim
               fi-data-ini:screen-value      = string(ttSelecao.d-data-ini) 
               fi-data-fim:screen-value      = string(ttSelecao.d-data-fim) 
               fi-evento-ini:screen-value    = ttSelecao.c-evento-ini
               fi-evento-fim:screen-value    = ttSelecao.c-evento-fim
               fi-lubrific-ini:screen-value  = string(ttSelecao.i-lubrific-ini)  
               fi-lubrific-fim:screen-value  = string(ttSelecao.i-lubrific-fim) .

    end.
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGrava wWindow 
PROCEDURE piGrava :
/*------------------------------------------------------------------------------
  Purpose:     piGrava
  Parameters:  <none>
  Notes:       Grava os dados de tela na temp-table 
------------------------------------------------------------------------------*/
find first ttSelecao exclusive-lock no-error.
if avail ttSelecao then do:
    assign ttSelecao.c-item-ini      =  fi-item-ini:screen-value in frame fPage0   
           ttSelecao.c-item-fim      =  fi-item-fim:screen-value in frame fPage0   
           ttSelecao.d-data-ini      =  date(fi-data-ini:screen-value  in frame fPage0) 
           ttSelecao.d-data-fim      =  date(fi-data-fim:screen-value  in frame fPage0) 
           ttSelecao.c-evento-ini    =  fi-evento-ini:screen-value      in frame fPage0      
           ttSelecao.c-evento-fim    =  fi-evento-fim:screen-value      in frame fPage0      
           ttSelecao.i-lubrific-ini  =  int( fi-lubrific-ini:screen-value  in frame fPage0)
           ttSelecao.i-lubrific-fim  =  int( fi-lubrific-fim:screen-value  in frame fPage0).
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

