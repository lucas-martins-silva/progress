&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-mab-tip-mater NO-UNDO LIKE mab-tip-mater
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-mao-ensaio-padr NO-UNDO LIKE mao-ensaio-padr
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AO0103A 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ao0103a MAO}
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
&GLOBAL-DEFINE Program           AO0103A
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Parƒmetros,Recomenda‡äes,Observa‡äes


&GLOBAL-DEFINE ttParent          tt-mab-tip-mater
&GLOBAL-DEFINE DBOParentTable    hDBOTpMater

&GLOBAL-DEFINE ttTable           tt-mao-ensaio-padr
&GLOBAL-DEFINE hDBOTable         HDBOmao-ensaio-padr
&GLOBAL-DEFINE DBOTable          mao-ensaio-padr

&GLOBAL-DEFINE page0KeyFields   tt-mao-ensaio-padr.cod-model ~
                                tt-mao-ensaio-padr.cod-ensaio
                                 
&GLOBAL-DEFINE page0ParentFields tt-mab-tip-mater.cod-tip-mater ~
                                 tt-mab-tip-mater.des-tip-mater 



&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page1Fields       tt-mao-ensaio-padr.des-formato ~
                                 tt-mao-ensaio-padr.num-tabela ~
                                 tt-mao-ensaio-padr.log-padrao
                                 
&GLOBAL-DEFINE page2Fields       tt-mao-ensaio-padr.cod-event-troca ~
                                 tt-mao-ensaio-padr.dsl-obs-troca ~
                                 tt-mao-ensaio-padr.cod-event-nao-troca ~
                                 tt-mao-ensaio-padr.dsl-obs-nao-troca 
&GLOBAL-DEFINE page3Fields       tt-mao-ensaio-padr.dsl-obs

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE iTpResult AS INTEGER INITIAL 0   NO-UNDO.
/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEnsaio    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModel     AS HANDLE NO-UNDO.

DEFINE VARIABLE hDBOTpMater   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEvento    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOTabela    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOResultado AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOTOleoRea  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOTOleoNRea AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-mab-tip-mater.cod-tip-mater ~
tt-mab-tip-mater.des-tip-mater tt-mao-ensaio-padr.cod-model ~
tt-mao-ensaio-padr.cod-ensaio 
&Scoped-define ENABLED-TABLES tt-mab-tip-mater tt-mao-ensaio-padr
&Scoped-define FIRST-ENABLED-TABLE tt-mab-tip-mater
&Scoped-define SECOND-ENABLED-TABLE tt-mao-ensaio-padr
&Scoped-Define ENABLED-OBJECTS fi-des-model fi-des-ensaio btOK btSave ~
btCancel btHelp rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-mab-tip-mater.cod-tip-mater ~
tt-mab-tip-mater.des-tip-mater tt-mao-ensaio-padr.cod-model ~
tt-mao-ensaio-padr.cod-ensaio 
&Scoped-define DISPLAYED-TABLES tt-mab-tip-mater tt-mao-ensaio-padr
&Scoped-define FIRST-DISPLAYED-TABLE tt-mab-tip-mater
&Scoped-define SECOND-DISPLAYED-TABLE tt-mao-ensaio-padr
&Scoped-Define DISPLAYED-OBJECTS fi-des-model fi-des-ensaio 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "&Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-des-ensaio AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88.

DEFINE VARIABLE fi-des-model AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fi-val-max-dat AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-val-max-num AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-val-max-txt AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-val-min-dat AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-val-min-num AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-val-min-txt AS CHARACTER FORMAT "X(60)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fiDes-tabela AS CHARACTER FORMAT "X(30)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88.

DEFINE VARIABLE fitexto1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE IMAGE IMAGE-27
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 65 BY 3.25.

DEFINE VARIABLE fi-nao-troc-evento AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88.

DEFINE VARIABLE fi-troc-evento AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82 BY 4.5.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82 BY 4.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-mab-tip-mater.cod-tip-mater AT ROW 1.38 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-mab-tip-mater.des-tip-mater AT ROW 1.38 COL 28.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 40 BY .88
     tt-mao-ensaio-padr.cod-model AT ROW 2.46 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-des-model AT ROW 2.46 COL 28.29 COLON-ALIGNED HELP
          "Descri‡Æo do Modelo" NO-LABEL
     tt-mao-ensaio-padr.cod-ensaio AT ROW 3.46 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-des-ensaio AT ROW 3.46 COL 28.29 COLON-ALIGNED HELP
          "Formato do resultado do ensaio" NO-LABEL
     btOK AT ROW 16.63 COL 2
     btSave AT ROW 16.63 COL 13
     btCancel AT ROW 16.63 COL 24
     btHelp AT ROW 16.63 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 16.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.08
         FONT 1.

DEFINE FRAME fPage1
     tt-mao-ensaio-padr.num-tabela AT ROW 2 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fiDes-tabela AT ROW 2 COL 22.29 COLON-ALIGNED NO-LABEL
     tt-mao-ensaio-padr.des-formato AT ROW 3 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     fi-val-min-txt AT ROW 5.29 COL 22.72 COLON-ALIGNED
     fi-val-min-num AT ROW 5.33 COL 22.72 COLON-ALIGNED
     fi-val-min-dat AT ROW 5.33 COL 22.72 COLON-ALIGNED
     fi-val-max-dat AT ROW 5.33 COL 53.72 COLON-ALIGNED NO-LABEL
     fi-val-max-num AT ROW 5.33 COL 53.72 COLON-ALIGNED NO-LABEL
     fi-val-max-txt AT ROW 5.33 COL 53.72 COLON-ALIGNED NO-LABEL
     tt-mao-ensaio-padr.log-padrao AT ROW 7.71 COL 16.57
          VIEW-AS TOGGLE-BOX
          SIZE 9.29 BY .71
     fitexto1 AT ROW 4 COL 16 COLON-ALIGNED NO-LABEL
     IMAGE-27 AT ROW 5.38 COL 45
     IMAGE-28 AT ROW 5.33 COL 52.43
     RECT-3 AT ROW 4.25 COL 16
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5.83
         SIZE 84.43 BY 10.13
         FONT 1.

DEFINE FRAME fPage3
     tt-mao-ensaio-padr.dsl-obs AT ROW 1.13 COL 1.72 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
          SIZE 82.72 BY 9.75
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5.83
         SIZE 84.43 BY 10.13
         FONT 1.

DEFINE FRAME fPage2
     tt-mao-ensaio-padr.cod-event-troca AT ROW 1.83 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-troc-evento AT ROW 1.83 COL 28.72 COLON-ALIGNED HELP
          "Descri‡Æo do Modelo" NO-LABEL
     tt-mao-ensaio-padr.dsl-obs-troca AT ROW 2.83 COL 2.43 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
          SIZE 81 BY 2.92
     tt-mao-ensaio-padr.cod-event-nao-troca AT ROW 6.58 COL 20.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-nao-troc-evento AT ROW 6.58 COL 29 COLON-ALIGNED HELP
          "Descri‡Æo do Modelo" NO-LABEL
     tt-mao-ensaio-padr.dsl-obs-nao-troca AT ROW 7.67 COL 2.57 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
          SIZE 81 BY 2.92
     RECT-6 AT ROW 1.38 COL 2
     RECT-7 AT ROW 6.25 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5.83
         SIZE 84.43 BY 10.13
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-mab-tip-mater T "?" NO-UNDO mgfro mab-tip-mater
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-mao-ensaio-padr T "?" NO-UNDO mgfro mao-ensaio-padr
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
         HEIGHT             = 17.08
         WIDTH              = 90
         MAX-HEIGHT         = 17.08
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17.08
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FRAME fPage3
                                                                        */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
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
    ASSIGN  fi-val-min-txt:HIDDEN IN FRAME fPage1              = NO
            fi-val-max-txt:HIDDEN IN FRAME fPage1              = NO
            fi-val-min-dat:HIDDEN IN FRAME fPage1              = YES
            fi-val-max-dat:HIDDEN IN FRAME fPage1              = YES
            fi-val-min-num:HIDDEN IN FRAME fPage1              = YES
            fi-val-max-num:HIDDEN IN FRAME fPage1              = YES 
            fi-val-min-txt:SENSITIVE IN FRAME fPage1           = NO
            fi-val-max-txt:SENSITIVE IN FRAME fPage1           = NO
            fi-val-min-dat:SENSITIVE IN FRAME fPage1           = NO
            fi-val-max-dat:SENSITIVE IN FRAME fPage1           = NO
            fi-val-min-num:SENSITIVE IN FRAME fPage1           = NO 
            fi-val-max-num:SENSITIVE IN FRAME fPage1           = NO 
            {&ttTable}.cod-model:SCREEN-VALUE IN FRAME fPage0  = ""
            fi-des-model:SCREEN-VALUE IN FRAME fPage0          = ""
            {&ttTable}.cod-ensaio:SCREEN-VALUE IN FRAME fPage0 = ""
            fi-des-ensaio:SCREEN-VALUE IN FRAME fPage0         = ""
            fi-val-min-num:SCREEN-VALUE IN FRAME fPage1        = "0"
            fi-val-max-num:SCREEN-VALUE IN FRAME fPage1        = "0"
            fi-val-min-txt:SCREEN-VALUE IN FRAME fPage1        = "" 
            fi-val-max-txt:SCREEN-VALUE IN FRAME fPage1        = ""
            fi-val-min-dat:SCREEN-VALUE IN FRAME fPage1        = ""
            fi-val-max-dat:SCREEN-VALUE IN FRAME fPage1        = ""
            {&ttTable}.num-tabela:SCREEN-VALUE IN FRAME fPage1 = "0"
            fiDes-tabela:SCREEN-VALUE IN FRAME fPage1          = ""
            {&ttTable}.num-tabela:sensitive IN FRAME fPage1    = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-mao-ensaio-padr.cod-ensaio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mao-ensaio-padr.cod-ensaio wMaintenanceNoNavigation
ON LEAVE OF tt-mao-ensaio-padr.cod-ensaio IN FRAME fpage0 /* Ensaio */
DO:
     IF pcAction <> "UPDATE":U THEN DO:
         {method/referenceFields.i
                &HandleDBOLeave="hDBOEnsaio"
                &KeyValue1="{&ttTable}.cod-ensaio:screen-value in frame fPage0"
                &FieldName1="cod-ensaio"
                &FieldScreen1="{&ttTable}.cod-ensaio"
                &Frame1="fPage0"
                &FieldName2="des-ensaio"
                &FieldScreen2="fi-des-ensaio"
                &Frame2="fPage0"
                &FieldName3="des-formato"
                &FieldScreen3="{&ttTable}.des-formato"
                &Frame3="fPage1"
                &FieldName4="num-tabela"
                &FieldScreen4="{&ttTable}.num-tabela"
                &Frame4="fPage1"}
     END.
     ELSE
         RUN piLeaveCodEnsaio IN THIS-PROCEDURE.

     run piLeaveCampos in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mao-ensaio-padr.cod-ensaio wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-mao-ensaio-padr.cod-ensaio IN FRAME fpage0 /* Ensaio */
OR "F5":U OF {&ttTable}.cod-ensaio IN FRAME fPage0 DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr103.w"
           &FieldZoom1="cod-ensaio"
           &FieldScreen1="{&ttTable}.cod-ensaio"
           &Frame1="fPage0"
           &FieldZoom2="des-ensaio"
           &FieldScreen2="fi-des-ensaio"
           &Frame2="fPage0"
           &EnableImplant="YES"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tt-mao-ensaio-padr.cod-event-nao-troca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mao-ensaio-padr.cod-event-nao-troca wMaintenanceNoNavigation
ON LEAVE OF tt-mao-ensaio-padr.cod-event-nao-troca IN FRAME fPage2 /* Evento Troca NÆo Realiz */
DO:
  {method\referenceFields.i
        &HandleDBOLeave="hDBOEvento"
        &KeyValue1="{&ttTable}.cod-event-nao-troca:screen-value in frame fPage2"
        &FieldName1="des-evento"
        &FieldScreen1="fi-nao-troc-evento"
        &Frame1="fPage2"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mao-ensaio-padr.cod-event-nao-troca wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-mao-ensaio-padr.cod-event-nao-troca IN FRAME fPage2 /* Evento Troca NÆo Realiz */
OR "F5":U OF {&ttTable}.cod-event-nao-troca IN FRAME fPage2 DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr010.w"
           &FieldZoom1="cod-evento"
           &FieldScreen1="{&ttTable}.cod-event-nao-troca"
           &Frame1="fPage2"
           &FieldZoom2="des-evento"
           &FieldScreen2="fi-nao-troc-evento"
           &Frame2="fPage2"
           &RunMethod="run setaFiltro in hProgramZoom (yes, no, no, no , no, no)."
           &EnableImplant="YES"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-mao-ensaio-padr.cod-event-troca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mao-ensaio-padr.cod-event-troca wMaintenanceNoNavigation
ON LEAVE OF tt-mao-ensaio-padr.cod-event-troca IN FRAME fPage2 /* Evento Troca Realiz. */
DO:
  {method\referenceFields.i
        &HandleDBOLeave="hDBOEvento"
        &KeyValue1="{&ttTable}.cod-event-troca:screen-value in frame fPage2"
        &FieldName1="des-evento"
        &FieldScreen1="fi-troc-evento"
        &Frame1="fPage2"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mao-ensaio-padr.cod-event-troca wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-mao-ensaio-padr.cod-event-troca IN FRAME fPage2 /* Evento Troca Realiz. */
OR "F5":U OF {&ttTable}.cod-event-troca IN FRAME fPage2 DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr010.w"
           &FieldZoom1="cod-evento"
           &FieldScreen1="{&ttTable}.cod-event-troca"
           &Frame1="fPage2"
           &FieldZoom2="des-evento"
           &FieldScreen2="fi-troc-evento"
           &Frame2="fPage2"
           &RunMethod="run setaFiltro in hProgramZoom (yes, no, no, no , no, no)."
           &EnableImplant="YES"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME tt-mao-ensaio-padr.cod-model
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mao-ensaio-padr.cod-model wMaintenanceNoNavigation
ON LEAVE OF tt-mao-ensaio-padr.cod-model IN FRAME fpage0 /* Modelo */
DO:
  {method\referenceFields.i
        &HandleDBOLeave="hDBOModel"
        &KeyValue1="{&ttTable}.cod-model:screen-value in frame fPage0"
        &FieldName1="des-model"
        &FieldScreen1="fi-des-model"
        &Frame1="fPage0"}  
   IF INPUT FRAME fPage0 {&ttTable}.cod-model = "":U THEN DO:
       {utp/ut-liter.i Todos_os_Modelos_de_Equipamentos * }
       ASSIGN fi-des-model = TRIM(RETURN-VALUE).
       DISP fi-des-model WITH FRAME fPage0.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mao-ensaio-padr.cod-model wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-mao-ensaio-padr.cod-model IN FRAME fpage0 /* Modelo */
OR "F5":U OF {&ttTable}.cod-model IN FRAME fPage0 DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr016.w"
           &FieldZoom1="cod-model"
           &FieldScreen1="{&ttTable}.cod-model"
           &Frame1="fPage0"
           &FieldZoom2="des-model"
           &FieldScreen2="fi-des-model"
           &Frame2="fPage0"
           &EnableImplant="YES"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-mao-ensaio-padr.des-formato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mao-ensaio-padr.des-formato wMaintenanceNoNavigation
ON LEAVE OF tt-mao-ensaio-padr.des-formato IN FRAME fPage1 /* Formato */
DO:
    IF AVAIL {&ttTable} THEN DO WITH FRAME fpage1:

        DEFINE VARIABLE c-teste AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE i-cont1 AS INTEGER INITIAL 0 NO-UNDO.
        DEFINE VARIABLE i-cont2 AS INTEGER INITIAL 0 NO-UNDO.
        DEFINE VARIABLE c-aux1 AS CHARACTER FORMAT "X(30)" NO-UNDO.
        DEFINE VARIABLE c-aux2 AS CHARACTER FORMAT "X(30)" NO-UNDO.

        CASE iTpResult :
          WHEN 1 THEN DO:
              ASSIGN  fi-val-min-num:FORMAT  = {&ttTable}.des-formato:SCREEN-VALUE
                      fi-val-max-num:FORMAT  = {&ttTable}.des-formato:SCREEN-VALUE NO-ERROR.
              IF error-status:ERROR = NO AND 
                 (fi-val-max-num:SCREEN-VALUE IN FRAME fPage1 = "0" OR
                  fi-val-max-num:SCREEN-VALUE IN FRAME fPage1 = ""  OR 
                  fi-val-max-num:SCREEN-VALUE IN FRAME fPage1 = ?)  THEN DO:

                  /*caso tenha gravado sem erro o formato nos campos de val min e max, e o valor de max seja 0, "" ou nulo
                    entao completar o val max com 999 conforme o formato especificado pelo des-formato */

                  ASSIGN c-teste = ENTRY(2,{&ttTable}.des-formato:SCREEN-VALUE,".") NO-ERROR.
                  IF error-status:ERROR THEN DO:

                      /*caso o formato NÇO seja DECIMAL: */
                      DO WHILE i-cont1 <> LENGTH({&ttTable}.des-formato:SCREEN-VALUE):
                          ASSIGN i-cont1 = i-cont1 + 1.
                          IF SUBSTRING({&ttTable}.des-formato:SCREEN-VALUE,i-cont1,1) = ">" OR 
                             SUBSTRING({&ttTable}.des-formato:SCREEN-VALUE,i-cont1,1) = "9" THEN
                              ASSIGN i-cont2 = i-cont2 + 1.
                      END.
                      ASSIGN fi-val-max-num:SCREEN-VALUE = FILL("9", i-cont2).

                  END.
                  ELSE DO: /*caso seja DECIMAL*/

                      DO WHILE i-cont1 <> LENGTH(ENTRY(1,{&ttTable}.des-formato:SCREEN-VALUE,".")):
                          ASSIGN i-cont1 = i-cont1 + 1.
                          IF SUBSTRING(ENTRY(1,{&ttTable}.des-formato:SCREEN-VALUE,"."),i-cont1,1) = ">" OR 
                             SUBSTRING(ENTRY(1,{&ttTable}.des-formato:SCREEN-VALUE,"."),i-cont1,1) = "9" THEN
                              ASSIGN i-cont2 = i-cont2 + 1.
                      END.
                      ASSIGN c-aux1 = FILL("9",i-cont2).

                      ASSIGN i-cont1 = 0
                             i-cont2 = 0.

                      DO WHILE i-cont1 <> LENGTH(ENTRY(2,{&ttTable}.des-formato:SCREEN-VALUE,".")):
                          ASSIGN i-cont1 = i-cont1 + 1.
                          IF SUBSTRING(ENTRY(2,{&ttTable}.des-formato:SCREEN-VALUE,"."),i-cont1,1) = ">" OR 
                             SUBSTRING(ENTRY(2,{&ttTable}.des-formato:SCREEN-VALUE,"."),i-cont1,1) = "9" THEN
                              ASSIGN i-cont2 = i-cont2 + 1.
                      END.
                      ASSIGN c-aux2 = FILL("9",i-cont2).

                      ASSIGN fi-val-max-num:SCREEN-VALUE = STRING(c-aux1 + "," + c-aux2).

                  END. /*else*/

              END. /* IF error-status:ERROR = NO*/

          END. /*when 1*/
        WHEN 3 THEN DO:
            ASSIGN fi-val-min-txt:FORMAT  = {&ttTable}.des-formato:SCREEN-VALUE           
                   fi-val-max-txt:FORMAT  = {&ttTable}.des-formato:SCREEN-VALUE NO-ERROR.

        END. /*when 3*/
      END CASE.
    END. /*if avail*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-mao-ensaio-padr.num-tabela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mao-ensaio-padr.num-tabela wMaintenanceNoNavigation
ON LEAVE OF tt-mao-ensaio-padr.num-tabela IN FRAME fPage1 /* Tabela */
DO:
    {method\referenceFields.i
          &HandleDBOLeave="hDBOTabela"
          &KeyValue1="{&ttTable}.num-tabela:screen-value in frame fPage1"
          &FieldName1="des-tabela"
          &FieldScreen1="fiDes-tabela"
          &Frame1="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mao-ensaio-padr.num-tabela wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-mao-ensaio-padr.num-tabela IN FRAME fPage1 /* Tabela */
OR "F5":U OF {&ttTable}.num-tabela IN FRAME fPage1 DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr102.w"
           &FieldZoom1="num-tabela"
           &FieldScreen1="{&ttTable}.num-tabela"
           &Frame1="fPage1"
           &FieldZoom2="des-tabela"
           &FieldScreen2="fiDes-tabela"
           &Frame2="fPage1"
           &EnableImplant="YES"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

{&ttTable}.cod-model:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in frame fPage0.
{&ttTable}.cod-ensaio:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in frame fPage0.
{&ttTable}.num-tabela:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in frame fPage1.
{&ttTable}.cod-event-troca:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in frame fPage2.
{&ttTable}.cod-event-nao-troca:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in frame fPage2.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/** Modelo **/
if valid-handle(hDBOModel) then
    run destroy in hDBOModel.


/** Ensaio **/
if valid-handle(hDBOEnsaio) then
    run destroy in hDBOEnsaio.

/** Tabela **/
if valid-handle(hDBOTabela) then
    run destroy in hDBOTabela.

/*tipo de matrial*/
IF VALID-HANDLE (hDBOTpMater) THEN
       RUN destroy IN hDBOTpMater.


/*Evento*/
IF VALID-HANDLE (hDBOEvento) THEN
       RUN destroy IN hDBOEvento.


return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{utp/ut-liter.i Valores_Padräes * }
ASSIGN fitexto1 = TRIM(RETURN-VALUE).
DISP fitexto1
    WITH FRAME fpage1.

/*traducao label campos faixa*/
{utp/ut-liter.i Faixa * }
ASSIGN fi-val-min-txt:LABEL IN FRAME fpage1 = TRIM(RETURN-VALUE)
       fi-val-min-dat:LABEL IN FRAME fpage1 = TRIM(RETURN-VALUE)
       fi-val-min-num:LABEL IN FRAME fpage1 = TRIM(RETURN-VALUE)
       {&ttTable}.log-padrao:SENSITIVE IN FRAME fPage1 = YES.

DISP {&ttTable}.log-padrao WITH FRAME fPage1.                 

apply "LEAVE":U to {&ttTable}.cod-model in frame fPage0.
apply "LEAVE":U to {&ttTable}.cod-ensaio in frame fPage0.
apply "LEAVE":U to {&ttTable}.num-tabela  in frame fPage1.

RETURN "Ok":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenanceNoNavigation 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

CASE iTpResult:
     WHEN 1 THEN DO:
         ASSIGN  {&ttTable}.des-val-min = INPUT FRAME fpage1 fi-val-min-num
                 {&ttTable}.des-val-max = INPUT FRAME fpage1 fi-val-max-num.
     END.
     WHEN 3 THEN DO:
         ASSIGN {&ttTable}.des-val-min = INPUT FRAME fpage1 fi-val-min-txt
                {&ttTable}.des-val-max = INPUT FRAME fpage1 fi-val-max-txt.
     END.
     WHEN 4 THEN DO:
         ASSIGN  {&ttTable}.des-val-min = INPUT FRAME fpage1 fi-val-min-dat
                 {&ttTable}.des-val-max = INPUT FRAME fpage1 fi-val-max-dat.
     END.
     WHEN 2 THEN DO:
         ASSIGN  {&ttTable}.num-tabela  = INPUT FRAME fpage1 {&ttTable}.num-tabela
                 {&ttTable}.des-val-min = ""
                 {&ttTable}.des-val-max = "".
     END.
END CASE.

ASSIGN {&ttTable}.des-formato = {&ttTable}.des-formato:SCREEN-VALUE IN FRAME fPage1
       {&ttTable}.log-padrao  = INPUT FRAME fPage1 {&ttTable}.log-padrao.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     initializeDBOs
  Parameters:  <none>
  Notes:       Inicializa as BOs no programa
------------------------------------------------------------------------------*/
  /*:Tipo de MAterial ---*/
    IF NOT VALID-HANDLE (hDBOTpMater) OR 
           hDBOTpMater:TYPE <> "PROCEDURE":U OR
           hDBOTpMater:FILE-NAME <> "frbo~\bofr026.p ":U THEN DO:
            RUN  frbo/bofr026.p PERSISTENT SET hDBOTpMater.
    END.
    
    RUN openQueryStatic in hDBOTpMater (input "Main":U) NO-ERROR.


    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModel) OR
       hDBOModel:TYPE <> "PROCEDURE":U OR
       hDBOModel:FILE-NAME <> "frbo~\bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModel.
    END.
    
    RUN openQueryStatic IN hDBOModel (INPUT "Main":U) NO-ERROR.

       /*--- DBO Ensaio ---*/
    IF NOT VALID-HANDLE(hDBOEnsaio) OR
       hDBOEnsaio:TYPE <> "PROCEDURE":U OR
       hDBOEnsaio:FILE-NAME <> "frbo~\bofr103.p":U THEN DO:
        run frbo/bofr103.p persistent set  hDBOEnsaio.
    END.
    
    RUN openQueryStatic IN hDBOEnsaio (INPUT "Main":U) NO-ERROR.

       /*--- DBO Tabela ---*/
    IF NOT VALID-HANDLE(hDBOTabela) OR
       hDBOTabela:TYPE <> "PROCEDURE":U OR
       hDBOTabela:FILE-NAME <> "frbo~\bofr102.p":U THEN DO:
        run frbo/bofr102.p persistent set  hDBOTabela.
    END.
    
    RUN openQueryStatic IN hDBOTabela (INPUT "Main":U) NO-ERROR.

      /*--- DBO Evento ---*/
    IF NOT VALID-HANDLE(hDBOEvento) OR
       hDBOEvento:TYPE <> "PROCEDURE":U OR
       hDBOEvento:FILE-NAME <> "frbo~\bofr010.p":U THEN DO:
        run frbo/bofr010.p persistent set  hDBOEvento.
    END.
    
    RUN openQueryStatic IN hDBOEvento (INPUT "Main":U) NO-ERROR.


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLeaveCampos wMaintenanceNoNavigation 
PROCEDURE piLeaveCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF pcAction <> "UPDATE" THEN DO: /*CASO SEJA ADD OU UPD, CARREGA DIVERSAS INFORMACOES DA TABELA DE ENSAIO.*/

    /**** Busca tipo de Resultado***/
    RUN goToKey      IN hDBOEnsaio (input frame fPage0 {&ttTable}.cod-ensaio).
    RUN getIntField  IN hDBOEnsaio (input "idi-tip-restdo":U, output iTpResult).
    RUN getIntField  IN hDBOEnsaio (input "num-tabela":U, output {&ttTable}.num-tabela).
    disp {&ttTable}.num-tabela with frame fPage1.
    apply "LEAVE":U to {&ttTable}.num-tabela in frame fPage1.

    APPLY "leave":U TO {&ttTable}.des-formato IN FRAME fPage1.

    IF {&ttTable}.cod-ensaio:SCREEN-VALUE <> "" THEN DO WITH FRAME fPage1:

        CASE iTpResult:
            WHEN 1 THEN DO: /*num‚rico*/
                disable {&ttTable}.num-tabela WITH FRAME fpage1.
                ENABLE {&ttTable}.des-formato  WITH FRAME fpage1.
                RUN getcharField  IN hDBOEnsaio (input "des-val-min":U, output fi-val-min-num).
                RUN getcharField  IN hDBOEnsaio (input "des-val-max":U, output fi-val-max-num).

                  ASSIGN  fi-val-min-txt:HIDDEN               = YES
                          fi-val-max-txt:HIDDEN               = YES
                          fi-val-min-dat:HIDDEN               = YES
                          fi-val-max-dat:HIDDEN               = YES
                          fi-val-min-num:HIDDEN               = no
                          fi-val-max-num:HIDDEN               = no 
                          fi-val-min-txt:SENSITIVE            = NO
                          fi-val-max-txt:SENSITIVE            = NO
                          fi-val-min-dat:SENSITIVE            = NO
                          fi-val-max-dat:SENSITIVE            = NO
                          fi-val-min-num:SENSITIVE            = YES 
                          fi-val-max-num:SENSITIVE            = YES 
                          fi-val-min-txt:SCREEN-VALUE         = ""
                          fi-val-max-txt:SCREEN-VALUE         = ""
                          fi-val-min-dat:SCREEN-VALUE         = ""
                          fi-val-max-dat:SCREEN-VALUE         = ""
                          {&ttTable}.num-tabela:sensitive     = NO
                          {&ttTable}.num-tabela:SCREEN-VALUE  = "0"
                          fiDes-tabela:SCREEN-VALUE           = ""
                          {&ttTable}.des-formato:SENSITIVE    = YES.
                  DISP fi-val-min-num
                       fi-val-max-num .

            END. /*when 1*/
            WHEN 3 THEN DO: /*texto*/
                disable {&ttTable}.num-tabela WITH FRAME fpage1.
                enaBLE {&ttTable}.des-formato  WITH FRAME fpage1.
                RUN getcharField  IN hDBOEnsaio (input "des-val-min":U, output fi-val-min-txt).
                RUN getcharField  IN hDBOEnsaio (input "des-val-max":U, output fi-val-max-txt).

                ASSIGN  fi-val-min-txt:HIDDEN               = NO
                        fi-val-max-txt:HIDDEN               = NO
                        fi-val-min-dat:HIDDEN               = YES
                        fi-val-max-dat:HIDDEN               = YES
                        fi-val-min-num:HIDDEN               = YES
                        fi-val-max-num:HIDDEN               = YES 
                        fi-val-min-txt:SENSITIVE            = YES
                        fi-val-max-txt:SENSITIVE            = YES
                        fi-val-min-dat:SENSITIVE            = NO
                        fi-val-max-dat:SENSITIVE            = NO
                        fi-val-min-num:SENSITIVE            = NO 
                        fi-val-max-num:SENSITIVE            = NO 
                        fi-val-min-num:SCREEN-VALUE         = "0"
                        fi-val-max-num:SCREEN-VALUE         = "0"
                        fi-val-min-dat:SCREEN-VALUE         = "" 
                        fi-val-max-dat:SCREEN-VALUE         = "" 
                        {&ttTable}.num-tabela:sensitive     = NO
                        {&ttTable}.num-tabela:SCREEN-VALUE  = "0"
                        fiDes-tabela:SCREEN-VALUE           = ""
                        {&ttTable}.des-formato:SENSITIVE    = YES.
                DISP fi-val-min-txt
                     fi-val-max-txt .

            END /*when 3*/.
            WHEN 2 THEN DO: /*tabela*/
                enable {&ttTable}.num-tabela WITH FRAME fpage1.
                disaBLE {&ttTable}.des-formato  WITH FRAME fpage1.

            ASSIGN  fi-val-min-txt:HIDDEN               = NO
                    fi-val-max-txt:HIDDEN               = NO
                    fi-val-min-dat:HIDDEN               = YES
                    fi-val-max-dat:HIDDEN               = YES
                    fi-val-min-num:HIDDEN               = YES
                    fi-val-max-num:HIDDEN               = YES 
                    fi-val-min-txt:SENSITIVE            = NO
                    fi-val-max-txt:SENSITIVE            = NO
                    fi-val-min-dat:SENSITIVE            = NO
                    fi-val-max-dat:SENSITIVE            = NO
                    fi-val-min-num:SENSITIVE            = NO 
                    fi-val-max-num:SENSITIVE            = NO 
                    fi-val-min-num:SCREEN-VALUE         = "0"
                    fi-val-max-num:SCREEN-VALUE         = "0"
                    fi-val-min-txt:SCREEN-VALUE         = "" 
                    fi-val-max-txt:SCREEN-VALUE         = "" 
                    fi-val-min-dat:SCREEN-VALUE         = "" 
                    fi-val-max-dat:SCREEN-VALUE         = "" 
                    {&ttTable}.num-tabela:sensitive     = YES
                    {&ttTable}.des-formato:SENSITIVE    = NO.

            END. /*when 2*/
            WHEN 4  THEN DO: /*data*/
                disable {&ttTable}.num-tabela WITH FRAME fpage1.
                enaBLE {&ttTable}.des-formato  WITH FRAME fpage1.
                RUN getcharField  IN hDBOEnsaio (input "des-val-min":U, output fi-val-min-dat).
                RUN getcharField  IN hDBOEnsaio (input "des-val-max":U, output fi-val-max-dat).

                ASSIGN  fi-val-min-txt:HIDDEN               = YES
                        fi-val-max-txt:HIDDEN               = YES
                        fi-val-min-dat:HIDDEN               = NO
                        fi-val-max-dat:HIDDEN               = NO
                        fi-val-min-num:HIDDEN               = YES
                        fi-val-max-num:HIDDEN               = YES 
                        fi-val-min-txt:SENSITIVE            = NO
                        fi-val-max-txt:SENSITIVE            = NO
                        fi-val-min-dat:SENSITIVE            = YES
                        fi-val-max-dat:SENSITIVE            = YES
                        fi-val-min-num:SENSITIVE            = NO 
                        fi-val-max-num:SENSITIVE            = NO 
                        fi-val-min-num:SCREEN-VALUE         = "0"
                        fi-val-max-num:SCREEN-VALUE         = "0"
                        fi-val-min-txt:SCREEN-VALUE         = "" 
                        fi-val-max-txt:SCREEN-VALUE         = ""
                        {&ttTable}.num-tabela:sensitive     = NO
                        {&ttTable}.num-tabela:SCREEN-VALUE  = "0"
                        fiDes-tabela:SCREEN-VALUE           = ""
                        {&ttTable}.des-formato:SENSITIVE    = NO.
                DISP fi-val-min-dat
                     fi-val-max-dat .

            END. /*when 4*/
        END CASE.
    END. /*IF {&ttTable}.cod-ensaio:SCREEN-VALUE <> "" */
    ELSE /*caso nao tenha sido digitado nenhum cod-ensaio, ele desabilita os campos e limpa*/
        ASSIGN  fi-val-min-txt:HIDDEN               = NO
                fi-val-max-txt:HIDDEN               = NO
                fi-val-min-dat:HIDDEN               = YES
                fi-val-max-dat:HIDDEN               = YES
                fi-val-min-num:HIDDEN               = YES
                fi-val-max-num:HIDDEN               = YES 
                fi-val-min-txt:SENSITIVE            = NO
                fi-val-max-txt:SENSITIVE            = NO
                fi-val-min-dat:SENSITIVE            = NO
                fi-val-max-dat:SENSITIVE            = NO
                fi-val-min-num:SENSITIVE            = NO 
                fi-val-max-num:SENSITIVE            = NO 
                fi-val-min-num:SCREEN-VALUE         = "0"
                fi-val-max-num:SCREEN-VALUE         = "0"
                fi-val-min-txt:SCREEN-VALUE         = "" 
                fi-val-max-txt:SCREEN-VALUE         = ""
                fi-val-min-dat:SCREEN-VALUE         = ""
                fi-val-max-dat:SCREEN-VALUE         = ""
                {&ttTable}.num-tabela:sensitive     = NO
                {&ttTable}.num-tabela:SCREEN-VALUE  = "0"
                fiDes-tabela:SCREEN-VALUE           = "".     

END. /*IF pcAction <> "UPDATE"*/
ELSE DO:

    /**** Busca tipo de Resultado***/
/*     RUN goToKey      IN hDBOEnsaio (input frame fPage0 {&ttTable}.cod-ensaio). */
    RUN getIntField  IN hDBOEnsaio (input "idi-tip-restdo":U, output iTpResult).
/*     RUN getIntField  IN hDBOEnsaio (input "num-tabela":U, output {&ttTable}.num-tabela). */
    disp {&ttTable}.num-tabela with frame fPage1.
    apply "LEAVE":U to {&ttTable}.num-tabela in frame fPage1.

/*     APPLY "leave":U TO {&ttTable}.des-formato IN FRAME fPage1. */

    IF {&ttTable}.cod-ensaio:SCREEN-VALUE <> "" THEN DO WITH FRAME fPage1:

        CASE iTpResult:
            WHEN 1 THEN DO: /*num‚rico*/
                disable {&ttTable}.num-tabela WITH FRAME fpage1.
                ENABLE {&ttTable}.des-formato  WITH FRAME fpage1.
                RUN getcharField  IN HDBOmao-ensaio-padr (input "des-val-min":U, output fi-val-min-num).
                RUN getcharField  IN HDBOmao-ensaio-padr (input "des-val-max":U, output fi-val-max-num).

                  ASSIGN  fi-val-min-txt:HIDDEN               = YES
                          fi-val-max-txt:HIDDEN               = YES
                          fi-val-min-dat:HIDDEN               = YES
                          fi-val-max-dat:HIDDEN               = YES
                          fi-val-min-num:HIDDEN               = no
                          fi-val-max-num:HIDDEN               = no 
                          fi-val-min-txt:SENSITIVE            = NO
                          fi-val-max-txt:SENSITIVE            = NO
                          fi-val-min-dat:SENSITIVE            = NO
                          fi-val-max-dat:SENSITIVE            = NO
                          fi-val-min-num:SENSITIVE            = YES 
                          fi-val-max-num:SENSITIVE            = YES 
                          fi-val-min-txt:SCREEN-VALUE         = ""
                          fi-val-max-txt:SCREEN-VALUE         = ""
                          fi-val-min-dat:SCREEN-VALUE         = ""
                          fi-val-max-dat:SCREEN-VALUE         = ""
                          {&ttTable}.num-tabela:sensitive     = NO
                          {&ttTable}.num-tabela:SCREEN-VALUE  = "0"
                          fiDes-tabela:SCREEN-VALUE           = ""
                          {&ttTable}.des-formato:SENSITIVE    = YES.
                  DISP fi-val-min-num
                       fi-val-max-num .

            END. /*when 1*/
            WHEN 3 THEN DO: /*texto*/
                disable {&ttTable}.num-tabela WITH FRAME fpage1.
                enaBLE {&ttTable}.des-formato  WITH FRAME fpage1.
                RUN getcharField  IN HDBOmao-ensaio-padr (input "des-val-min":U, output fi-val-min-txt).
                RUN getcharField  IN HDBOmao-ensaio-padr (input "des-val-max":U, output fi-val-max-txt).

                ASSIGN  fi-val-min-txt:HIDDEN               = NO
                        fi-val-max-txt:HIDDEN               = NO
                        fi-val-min-dat:HIDDEN               = YES
                        fi-val-max-dat:HIDDEN               = YES
                        fi-val-min-num:HIDDEN               = YES
                        fi-val-max-num:HIDDEN               = YES 
                        fi-val-min-txt:SENSITIVE            = YES
                        fi-val-max-txt:SENSITIVE            = YES
                        fi-val-min-dat:SENSITIVE            = NO
                        fi-val-max-dat:SENSITIVE            = NO
                        fi-val-min-num:SENSITIVE            = NO 
                        fi-val-max-num:SENSITIVE            = NO 
                        fi-val-min-num:SCREEN-VALUE         = "0"
                        fi-val-max-num:SCREEN-VALUE         = "0"
                        fi-val-min-dat:SCREEN-VALUE         = "" 
                        fi-val-max-dat:SCREEN-VALUE         = "" 
                        {&ttTable}.num-tabela:sensitive     = NO
                        {&ttTable}.num-tabela:SCREEN-VALUE  = "0"
                        fiDes-tabela:SCREEN-VALUE           = ""
                        {&ttTable}.des-formato:SENSITIVE    = YES.
                DISP fi-val-min-txt
                     fi-val-max-txt .

            END /*when 3*/.
            WHEN 2 THEN DO: /*tabela*/
                enable {&ttTable}.num-tabela WITH FRAME fpage1.
                disaBLE {&ttTable}.des-formato  WITH FRAME fpage1.

            ASSIGN  fi-val-min-txt:HIDDEN               = NO
                    fi-val-max-txt:HIDDEN               = NO
                    fi-val-min-dat:HIDDEN               = YES
                    fi-val-max-dat:HIDDEN               = YES
                    fi-val-min-num:HIDDEN               = YES
                    fi-val-max-num:HIDDEN               = YES 
                    fi-val-min-txt:SENSITIVE            = NO
                    fi-val-max-txt:SENSITIVE            = NO
                    fi-val-min-dat:SENSITIVE            = NO
                    fi-val-max-dat:SENSITIVE            = NO
                    fi-val-min-num:SENSITIVE            = NO 
                    fi-val-max-num:SENSITIVE            = NO 
                    fi-val-min-num:SCREEN-VALUE         = "0"
                    fi-val-max-num:SCREEN-VALUE         = "0"
                    fi-val-min-txt:SCREEN-VALUE         = "" 
                    fi-val-max-txt:SCREEN-VALUE         = "" 
                    fi-val-min-dat:SCREEN-VALUE         = "" 
                    fi-val-max-dat:SCREEN-VALUE         = "" 
                    {&ttTable}.num-tabela:sensitive     = YES
                    {&ttTable}.des-formato:SENSITIVE    = NO.

            END. /*when 2*/
            WHEN 4  THEN DO: /*data*/
                disable {&ttTable}.num-tabela WITH FRAME fpage1.
                enaBLE {&ttTable}.des-formato  WITH FRAME fpage1.
                RUN getcharField  IN HDBOmao-ensaio-padr (input "des-val-min":U, output fi-val-min-dat).
                RUN getcharField  IN HDBOmao-ensaio-padr (input "des-val-max":U, output fi-val-max-dat).

                ASSIGN  fi-val-min-txt:HIDDEN               = YES
                        fi-val-max-txt:HIDDEN               = YES
                        fi-val-min-dat:HIDDEN               = NO
                        fi-val-max-dat:HIDDEN               = NO
                        fi-val-min-num:HIDDEN               = YES
                        fi-val-max-num:HIDDEN               = YES 
                        fi-val-min-txt:SENSITIVE            = NO
                        fi-val-max-txt:SENSITIVE            = NO
                        fi-val-min-dat:SENSITIVE            = YES
                        fi-val-max-dat:SENSITIVE            = YES
                        fi-val-min-num:SENSITIVE            = NO 
                        fi-val-max-num:SENSITIVE            = NO 
                        fi-val-min-num:SCREEN-VALUE         = "0"
                        fi-val-max-num:SCREEN-VALUE         = "0"
                        fi-val-min-txt:SCREEN-VALUE         = "" 
                        fi-val-max-txt:SCREEN-VALUE         = ""
                        {&ttTable}.num-tabela:sensitive     = NO
                        {&ttTable}.num-tabela:SCREEN-VALUE  = "0"
                        fiDes-tabela:SCREEN-VALUE           = ""
                        {&ttTable}.des-formato:SENSITIVE    = NO.
                DISP fi-val-min-dat
                     fi-val-max-dat .

            END. /*when 4*/
        END CASE.
    END. /*IF {&ttTable}.cod-ensaio:SCREEN-VALUE <> "" */
    ELSE /*caso nao tenha sido digitado nenhum cod-ensaio, ele desabilita os campos e limpa*/
        ASSIGN  fi-val-min-txt:HIDDEN               = NO
                fi-val-max-txt:HIDDEN               = NO
                fi-val-min-dat:HIDDEN               = YES
                fi-val-max-dat:HIDDEN               = YES
                fi-val-min-num:HIDDEN               = YES
                fi-val-max-num:HIDDEN               = YES 
                fi-val-min-txt:SENSITIVE            = NO
                fi-val-max-txt:SENSITIVE            = NO
                fi-val-min-dat:SENSITIVE            = NO
                fi-val-max-dat:SENSITIVE            = NO
                fi-val-min-num:SENSITIVE            = NO 
                fi-val-max-num:SENSITIVE            = NO 
                fi-val-min-num:SCREEN-VALUE         = "0"
                fi-val-max-num:SCREEN-VALUE         = "0"
                fi-val-min-txt:SCREEN-VALUE         = "" 
                fi-val-max-txt:SCREEN-VALUE         = ""
                fi-val-min-dat:SCREEN-VALUE         = ""
                fi-val-max-dat:SCREEN-VALUE         = ""
                {&ttTable}.num-tabela:SCREEN-VALUE  = "0"
                fiDes-tabela:SCREEN-VALUE           = ""
                {&ttTable}.num-tabela:sensitive     = NO.

END. /*ELSE DO IF PCACTION*/


return "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLeaveCodEnsaio wMaintenanceNoNavigation 
PROCEDURE piLeaveCodEnsaio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
         {method/referenceFields.i
                &HandleDBOLeave="hDBOEnsaio"
                &KeyValue1="{&ttTable}.cod-ensaio:screen-value in frame fPage0"
                &FieldName1="cod-ensaio"
                &FieldScreen1="{&ttTable}.cod-ensaio"
                &Frame1="fPage0"
                &FieldName2="des-ensaio"
                &FieldScreen2="fi-des-ensaio"
                &Frame2="fPage0"}
                
RETURN "OK":U.

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
ASSIGN {&ttTable}.cod-tip-mater = {&ttParent}.cod-tip-mater.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

