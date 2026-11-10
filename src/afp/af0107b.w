&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI 
&ANALYZE-RESUME
/* Connected Databases 
          emscda           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttAf-variavel NO-UNDO LIKE af-variavel
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttAf-variavel-valor NO-UNDO LIKE af-variavel-valor
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
{include/i-prgvrs.i AF0107B 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AF0107B
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       0

&GLOBAL-DEFINE ttTable           ttAf-variavel-valor
&GLOBAL-DEFINE hDBOTable         hDBOaf011
&GLOBAL-DEFINE DBOTable          af-variavel-valor

&GLOBAL-DEFINE ttParent          ttAf-variavel
&GLOBAL-DEFINE DBOParentTable    af-variavel

&GLOBAL-DEFINE page0KeyFields    ttAf-variavel-valor.dt-ini-validade

&GLOBAL-DEFINE page0Fields       ttAf-variavel-valor.dt-fim-validade ttAf-variavel-valor.valor-var ttAf-variavel-valor.dt-alter ttAf-variavel-valor.usuar-alter ttAf-variavel-valor.narrativa ttAf-variavel-valor.hora-alter ttAf-variavel-valor.dt-implantacao

&GLOBAL-DEFINE page0ParentFields ttAf-variavel.cod-variavel ttAf-variavel.descricao 
                                 

&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */


/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

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
ttAf-variavel.descricao ttAf-variavel-valor.dt-ini-validade ~
ttAf-variavel-valor.dt-fim-validade ttAf-variavel-valor.valor-var ~
ttAf-variavel-valor.dt-implantacao ttAf-variavel-valor.hora-alter ~
ttAf-variavel-valor.dt-alter ttAf-variavel-valor.usuar-alter ~
ttAf-variavel-valor.narrativa 
&Scoped-define ENABLED-TABLES ttAf-variavel ttAf-variavel-valor
&Scoped-define FIRST-ENABLED-TABLE ttAf-variavel
&Scoped-define SECOND-ENABLED-TABLE ttAf-variavel-valor
&Scoped-Define ENABLED-OBJECTS btOK btSave btCancel btHelp RECT-10 RECT-3 ~
RECT-4 rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttAf-variavel.cod-variavel ~
ttAf-variavel.descricao ttAf-variavel-valor.dt-ini-validade ~
ttAf-variavel-valor.dt-fim-validade ttAf-variavel-valor.valor-var ~
ttAf-variavel-valor.dt-implantacao ttAf-variavel-valor.hora-alter ~
ttAf-variavel-valor.dt-alter ttAf-variavel-valor.usuar-alter ~
ttAf-variavel-valor.narrativa 
&Scoped-define DISPLAYED-TABLES ttAf-variavel ttAf-variavel-valor
&Scoped-define FIRST-DISPLAYED-TABLE ttAf-variavel
&Scoped-define SECOND-DISPLAYED-TABLE ttAf-variavel-valor


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

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

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 5.75.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 2.25.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 1.29.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 1.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 89.86 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttAf-variavel.cod-variavel AT ROW 1.33 COL 16.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     ttAf-variavel.descricao AT ROW 1.33 COL 26 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 36.86 BY .88
     ttAf-variavel-valor.dt-ini-validade AT ROW 2.71 COL 16.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     ttAf-variavel-valor.dt-fim-validade AT ROW 3.67 COL 16.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .79
     ttAf-variavel-valor.valor-var AT ROW 4.92 COL 16.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     ttAf-variavel-valor.dt-implantacao AT ROW 6.29 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     ttAf-variavel-valor.hora-alter AT ROW 6.29 COL 67 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     ttAf-variavel-valor.dt-alter AT ROW 7.25 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     ttAf-variavel-valor.usuar-alter AT ROW 7.25 COL 67 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     ttAf-variavel-valor.narrativa AT ROW 8.21 COL 18.86 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 60 BY 3.25
     btOK AT ROW 12.13 COL 3.86
     btSave AT ROW 12.13 COL 14.86
     btCancel AT ROW 12.13 COL 25.86
     btHelp AT ROW 12.13 COL 80.72
     RECT-10 AT ROW 6 COL 2
     RECT-3 AT ROW 2.42 COL 2
     RECT-4 AT ROW 4.71 COL 2
     rtKeys AT ROW 1.13 COL 2
     rtToolBar AT ROW 11.88 COL 2
     "Narrativa:" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 7.96 COL 11.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.86 BY 12.58
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
      TABLE: ttAf-variavel-valor T "?" NO-UNDO emscda af-variavel-valor
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
         HEIGHT             = 12.71
         WIDTH              = 91
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 92.57
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 92.57
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
    RUN saveRecord IN THIS-PROCEDURE.
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
    DISABLE ttAf-variavel-valor.dt-implantacao 
            ttAf-variavel-valor.dt-alter
            ttAf-variavel-valor.hora-alter
            ttAf-variavel-valor.usuar-alter
            WITH FRAME fpage0.
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
    ASSIGN ttAf-variavel-valor.ep-codigo    = ttAf-variavel.ep-codigo
           ttAf-variavel-valor.cod-variavel = ttAf-variavel.cod-variavel.
          
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

