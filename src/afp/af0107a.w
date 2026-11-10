&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI 
&ANALYZE-RESUME
/* Connected Databases 
          emscda           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttAf-variavel NO-UNDO LIKE af-variavel
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0107A 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AF0107
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE InitialPage       0

&GLOBAL-DEFINE ttTable           ttAf-variavel
&GLOBAL-DEFINE hDBOTable         hDBOaf011
&GLOBAL-DEFINE DBOTable          af-variavel

&GLOBAL-DEFINE page0KeyFields    ttAf-variavel.cod-variavel    
&GLOBAL-DEFINE page0Fields       ttAf-variavel.descricao ~
                                 ttAf-variavel.log-especifico ~
                                 ttAf-variavel.narrativa ~
                                 ttAf-variavel.programa ~
                                 ttAf-variavel.dt-implantacao ~
                                 ttAf-variavel.dt-alter ~
                                 ttAf-variavel.hora-alter ~
                                 ttAf-variavel.usuar-alter
&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.


/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttAf-variavel.cod-variavel ~
ttAf-variavel.descricao ttAf-variavel.log-especifico ttAf-variavel.programa ~
ttAf-variavel.narrativa 
&Scoped-define ENABLED-TABLES ttAf-variavel
&Scoped-define FIRST-ENABLED-TABLE ttAf-variavel
&Scoped-Define ENABLED-OBJECTS bt-programa btOK btSave btCancel btHelp ~
RECT-2 rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttAf-variavel.cod-variavel ~
ttAf-variavel.descricao ttAf-variavel.log-especifico ttAf-variavel.programa ~
ttAf-variavel.dt-implantacao ttAf-variavel.dt-alter ~
ttAf-variavel.hora-alter ttAf-variavel.usuar-alter ttAf-variavel.narrativa 
&Scoped-define DISPLAYED-TABLES ttAf-variavel
&Scoped-define FIRST-DISPLAYED-TABLE ttAf-variavel


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-programa 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 11.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 1.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttAf-variavel.cod-variavel AT ROW 1.63 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttAf-variavel.descricao AT ROW 1.63 COL 24.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 42.57 BY .88
     ttAf-variavel.log-especifico AT ROW 3.04 COL 16
          VIEW-AS TOGGLE-BOX
          SIZE 10.86 BY .88
     bt-programa AT ROW 3.71 COL 62
     ttAf-variavel.programa AT ROW 3.75 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 46 BY .88
     ttAf-variavel.dt-implantacao AT ROW 4.67 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     ttAf-variavel.dt-alter AT ROW 5.46 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     ttAf-variavel.hora-alter AT ROW 6.38 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     ttAf-variavel.usuar-alter AT ROW 7.25 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     ttAf-variavel.narrativa AT ROW 8.25 COL 16 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 60 BY 5
     btOK AT ROW 14.25 COL 2
     btSave AT ROW 14.25 COL 13
     btCancel AT ROW 14.25 COL 24
     btHelp AT ROW 14.25 COL 80
     RECT-2 AT ROW 2.75 COL 2
     rtKeys AT ROW 1.25 COL 2
     rtToolBar AT ROW 14 COL 1
     "Narrativa:" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 8.21 COL 9
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14.71
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttAf-variavel T "?" NO-UNDO emscda af-variavel
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 14.83
         WIDTH              = 90.57
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90.57
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90.57
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN ttAf-variavel.dt-alter IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ttAf-variavel.dt-implantacao IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ttAf-variavel.hora-alter IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ttAf-variavel.usuar-alter IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

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

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-programa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-programa wMaintenanceNoNavigation
ON CHOOSE OF bt-programa IN FRAME fpage0
DO:
  def var c-programa  as char no-undo.
  def var l-ok        as log  no-undo.

  assign c-programa = input frame fpage0 ttAf-variavel.programa.

  assign c-programa = replace(c-programa, "/", "~\").

  SYSTEM-DIALOG GET-FILE programa
     FILTERS "*.p" "*.p",
             "*.*" "*.*"         
     DEFAULT-EXTENSION "p"
     INITIAL-DIR "spool" 
     USE-FILENAME
     UPDATE l-ok.
  if  l-ok = yes then do:
      assign ttAf-variavel.programa:screen-value in frame fpage0 = replace(c-programa, "~\", "/").
      display ttAf-variavel.programa with frame fpage0.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    IF AVAIL ttAf-variavel THEN ASSIGN ttAf-variavel.ep-codigo = i-ep-codigo-usuario.
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    IF AVAIL ttAf-variavel THEN ASSIGN ttAf-variavel.ep-codigo = i-ep-codigo-usuario.
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAf-variavel.log-especifico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAf-variavel.log-especifico wMaintenanceNoNavigation
ON VALUE-CHANGED OF ttAf-variavel.log-especifico IN FRAME fpage0 /* Espec¡fica */
DO:
    run piHabilitaEspecifico.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DISABLE ttAf-variavel.dt-implantacao 
            ttAf-variavel.dt-alter
            ttAf-variavel.hora-alter
            ttAf-variavel.usuar-alter
            WITH FRAME fpage0.

    if AVAIL ttAf-variavel AND ttAf-variavel.padrao  then
        disable ttAf-variavel.log-especifico
                ttAf-variavel.programa bt-programa
                ttAf-variavel.descricao
                with frame fpage0.

    RUN piHabilitaEspecifico.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piHabilitaEspecifico wMaintenanceNoNavigation 
PROCEDURE piHabilitaEspecifico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT INPUT FRAME fpage0 ttAf-variavel.log-especifico:CHECKED THEN
       DISABLE ttAf-variavel.programa bt-programa with frame fpage0.
    ELSE 
       ENABLE ttAf-variavel.programa bt-programa with frame fpage0.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

