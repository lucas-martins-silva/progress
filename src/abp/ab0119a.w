&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-mab-eqpto NO-UNDO LIKE mab-eqpto
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-mab-relac-eqpto-sub-sist NO-UNDO LIKE mab-relac-eqpto-sub-sist
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
{include/i-prgvrs.i AB0119A 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0119a MAB}
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
&GLOBAL-DEFINE Program           AB0119A
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Durabilidade

&GLOBAL-DEFINE ttTable           tt-mab-relac-eqpto-sub-sist
&GLOBAL-DEFINE hDBOTable         hDBOmab-relac
&GLOBAL-DEFINE DBOTable          mab-relac-eqpto-sub-sist

&GLOBAL-DEFINE ttParent          tt-mab-eqpto
&GLOBAL-DEFINE DBOParentTable    mab-eqpto

&GLOBAL-DEFINE page0KeyFields    tt-mab-relac-eqpto-sub-sist.cod-sub-sist

&GLOBAL-DEFINE page0Fields       tt-mab-relac-eqpto-sub-sist.dat-cadastro
&GLOBAL-DEFINE page0ParentFields tt-mab-eqpto.ep-codigo     ~
                                 tt-mab-eqpto.cod-eqpto     ~
                                 tt-mab-eqpto.idi-tip-eqpto
                                 
                                 

&GLOBAL-DEFINE page1Fields tt-mab-relac-eqpto-sub-sist.qti-max   ~
                           tt-mab-relac-eqpto-sub-sist.val-km-inicial ~
                           tt-mab-relac-eqpto-sub-sist.dat-ult-troca  ~
                           tt-mab-relac-eqpto-sub-sist.val-km-hora-gartia ~
                           tt-mab-relac-eqpto-sub-sist.num-dias-gartia    ~
                           tt-mab-relac-eqpto-sub-sist.val-uso-estimad    ~
                           tt-mab-relac-eqpto-sub-sist.num-dias-estimad   ~
                           tt-mab-relac-eqpto-sub-sist.val-km-aviso       ~
                           tt-mab-relac-eqpto-sub-sist.num-dias-antecip   ~
                           fi-un ~
                           tt-mab-relac-eqpto-sub-sist.log-livre-1
     


/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOSubSist   AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-mab-eqpto.ep-codigo tt-mab-eqpto.cod-eqpto ~
tt-mab-eqpto.idi-tip-eqpto tt-mab-relac-eqpto-sub-sist.cod-sub-sist 
&Scoped-define ENABLED-TABLES tt-mab-eqpto tt-mab-relac-eqpto-sub-sist
&Scoped-define FIRST-ENABLED-TABLE tt-mab-eqpto
&Scoped-define SECOND-ENABLED-TABLE tt-mab-relac-eqpto-sub-sist
&Scoped-define DISPLAYED-TABLES tt-mab-eqpto tt-mab-relac-eqpto-sub-sist
&Scoped-define FIRST-DISPLAYED-TABLE tt-mab-eqpto
&Scoped-define SECOND-DISPLAYED-TABLE tt-mab-relac-eqpto-sub-sist
&Scoped-Define ENABLED-OBJECTS fDesModel fDesSubSist btOK btSave btCancel ~
btHelp rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-mab-eqpto.ep-codigo ~
tt-mab-eqpto.cod-eqpto tt-mab-eqpto.idi-tip-eqpto ~
tt-mab-relac-eqpto-sub-sist.cod-sub-sist ~
tt-mab-relac-eqpto-sub-sist.dat-cadastro 
&Scoped-Define DISPLAYED-OBJECTS fDesModel fDesSubSist 

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

DEFINE VARIABLE fDesModel AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE fDesSubSist AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.46.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fi-un AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 36.57 BY 2.75.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 37.14 BY 3.92.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 36.57 BY 2.75.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 37.14 BY 2.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-mab-eqpto.ep-codigo AT ROW 1.25 COL 11.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-mab-eqpto.cod-eqpto AT ROW 1.25 COL 17.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     fDesModel AT ROW 1.25 COL 30.43 COLON-ALIGNED NO-LABEL
     tt-mab-eqpto.idi-tip-eqpto AT ROW 2.21 COL 14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Motorizado", 1,
"NÆo Motorizado", 2
          SIZE 25.29 BY 1
     tt-mab-relac-eqpto-sub-sist.cod-sub-sist AT ROW 3.29 COL 12.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     fDesSubSist AT ROW 3.29 COL 19.29 COLON-ALIGNED NO-LABEL
     tt-mab-relac-eqpto-sub-sist.dat-cadastro AT ROW 3.29 COL 70.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     btOK AT ROW 16.75 COL 2
     btSave AT ROW 16.75 COL 13
     btCancel AT ROW 16.75 COL 24
     btHelp AT ROW 16.75 COL 80
     rtKeys AT ROW 1.04 COL 1
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.08
         FONT 1.

DEFINE FRAME fPage1
     fi-un AT ROW 6.5 COL 35 COLON-ALIGNED NO-LABEL
     tt-mab-relac-eqpto-sub-sist.log-livre-1 AT ROW 2.25 COL 51 HELP
          "Atributo livre para uso interno"
          LABEL "Controla pelo Contador Secund rio":L9
          VIEW-AS TOGGLE-BOX
          SIZE 27 BY .83
     tt-mab-relac-eqpto-sub-sist.qti-max AT ROW 1.25 COL 19.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-mab-relac-eqpto-sub-sist.val-km-inicial AT ROW 3.17 COL 16.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     tt-mab-relac-eqpto-sub-sist.dat-ult-troca AT ROW 4.17 COL 16.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-mab-relac-eqpto-sub-sist.val-km-hora-gartia AT ROW 3.21 COL 55.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22.72 BY .88
     tt-mab-relac-eqpto-sub-sist.num-dias-gartia AT ROW 4.21 COL 55.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22.72 BY .88
     tt-mab-relac-eqpto-sub-sist.val-uso-estimad AT ROW 6.5 COL 17.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     tt-mab-relac-eqpto-sub-sist.num-dias-estimad AT ROW 7.5 COL 17.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     tt-mab-relac-eqpto-sub-sist.val-km-aviso AT ROW 6.46 COL 59.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.14 BY .88
     tt-mab-relac-eqpto-sub-sist.num-dias-antecip AT ROW 7.46 COL 59.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.14 BY .88
     RECT-1 AT ROW 2.71 COL 7.29
     RECT-2 AT ROW 1.54 COL 46.14
     RECT-3 AT ROW 6 COL 7.29
     RECT-4 AT ROW 5.96 COL 46.14
     "Antecipa‡Æo" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 5.75 COL 48.14
     "Uso Estimado" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 5.75 COL 9.72
     "Garantia" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 1.25 COL 48.14
     "éltima Troca" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 2.46 COL 9.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.33
         SIZE 84.43 BY 9.67
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-mab-eqpto T "?" NO-UNDO mgfro mab-eqpto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-mab-relac-eqpto-sub-sist T "?" NO-UNDO mgfro mab-relac-eqpto-sub-sist
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
         HEIGHT             = 17.42
         WIDTH              = 90.57
         MAX-HEIGHT         = 28.67
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.67
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-mab-relac-eqpto-sub-sist.dat-cadastro IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       tt-mab-relac-eqpto-sub-sist.dat-cadastro:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* SETTINGS FOR TOGGLE-BOX tt-mab-relac-eqpto-sub-sist.log-livre-1 IN FRAME fPage1
   EXP-LABEL EXP-HELP                                                   */
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
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
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


&Scoped-define SELF-NAME tt-mab-eqpto.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-eqpto.cod-eqpto wMaintenanceNoNavigation
ON LEAVE OF tt-mab-eqpto.cod-eqpto IN FRAME fpage0 /* cod-eqpto */
DO:
        {method\referenceFields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="tt-mab-eqpto.cod-model"
        &FieldName1="des-model"
        &FieldScreen1="fDesModel"
        &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-mab-relac-eqpto-sub-sist.cod-sub-sist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-relac-eqpto-sub-sist.cod-sub-sist wMaintenanceNoNavigation
ON LEAVE OF tt-mab-relac-eqpto-sub-sist.cod-sub-sist IN FRAME fpage0 /* Sub-Sistema */
DO:
        {method\referenceFields.i
        &HandleDBOLeave="hDBOSubSist"
        &KeyValue1="tt-mab-relac-eqpto-sub-sist.cod-sub-sist"
        &FieldName1="des-sub-sist"
        &FieldScreen1="fDesSubSist"
        &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-mab-relac-eqpto-sub-sist.log-livre-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-relac-eqpto-sub-sist.log-livre-1 wMaintenanceNoNavigation
ON VALUE-CHANGED OF tt-mab-relac-eqpto-sub-sist.log-livre-1 IN FRAME fPage1 /* Controla pelo Contador Secund rio */
DO:
  /*Se contador secundario estiver habilitado, traz unidade secundaria*/
FOR FIRST mab-model
    WHERE mab-model.cod-model = tt-mab-eqpto.cod-model:
    IF tt-mab-eqpto.log-cont-sec AND tt-mab-relac-eqpto-sub-sist.log-livre-1:CHECKED IN FRAME fPage1 THEN DO:
        ASSIGN fi-un:SCREEN-VALUE IN FRAME fPage1 = SUBSTRING(mab-model.cod-livre-1,1,2).
    END.
    ELSE DO:
        ASSIGN fi-un:SCREEN-VALUE IN FRAME fPage1 = mab-model.un.
    END.
END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-mab-eqpto.ep-codigo:LABEL = "Equipamento".
DISABLE tt-mab-relac-eqpto-sub-sist.dat-cadastro.

{utp/ut-liter.i "Controla_pelo_Contador_Secund rio"}
ASSIGN tt-mab-relac-eqpto-sub-sist.log-livre-1:LABEL IN FRAME fPage1 = return-value.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
APPLY "leave":U TO tt-mab-eqpto.cod-eqpto IN FRAME fPage0.
APPLY "leave":U TO tt-mab-relac-eqpto-sub-sist.cod-sub-sist IN FRAME fPage0.
APPLY "value-changed":U TO tt-mab-relac-eqpto-sub-sist.log-livre-1 IN FRAME fPage1.

RETURN "OK":U.

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
ASSIGN tt-mab-relac-eqpto-sub-sist.dat-cadastro:SENSITIVE IN FRAME fPage0 = NO
       fi-un:SENSITIVE IN FRAME fPage1 = NO.

/*Se estiver selecionado o contador secundario o campo ‚ habilitado - padrÆo checked = NO*/
IF tt-mab-eqpto.log-cont-sec THEN DO:
    ASSIGN tt-mab-relac-eqpto-sub-sist.log-livre-1:SENSITIVE IN FRAME fPage1 = YES.
/*     FOR FIRST mab-relac-eqpto-sub-sist                                                                                 */
/*         WHERE mab-relac-eqpto-sub-sist.cod-eqpto = tt-mab-relac-eqpto-sub-sist.cod-eqpto                               */
/*           AND mab-relac-eqpto-sub-sist.ep-codigo = tt-mab-relac-eqpto-sub-sist.ep-codigo:                              */
/*         ASSIGN tt-mab-relac-eqpto-sub-sist.log-livre-1:CHECKED IN FRAME fPage1 = mab-relac-eqpto-sub-sist.log-livre-1. */
/*     END.                                                                                                               */
END.
ELSE DO:
    ASSIGN tt-mab-relac-eqpto-sub-sist.log-livre-1:SENSITIVE IN FRAME fPage1 = NO
           tt-mab-relac-eqpto-sub-sist.log-livre-1:CHECKED IN FRAME fPage1 = NO.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT VALID-HANDLE(hDBOModelo) OR
    hDBOModelo:TYPE <> "PROCEDURE":U OR
    hDBOModelo:FILE-NAME <> "frbo~\bofr016.p":U THEN DO:
      run frbo/bofr016.p persistent set  hDBOModelo.
END.
    
RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

IF NOT VALID-HANDLE(hDBOSubSist) OR
    hDBOSubSist:TYPE <> "PROCEDURE":U OR
    hDBOSubSist:FILE-NAME <> "frbo~\bofr025.p":U THEN DO:
      run frbo/bofr025.p persistent set  hDBOSubSist.
END.
    
RUN openQueryStatic IN hDBOSubSist (INPUT "Main":U) NO-ERROR.


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
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF VALID-HANDLE (hDBOModelo) THEN
   DELETE PROCEDURE hDBOModelo.  
    
IF VALID-HANDLE (hDBOSubSist) THEN
   DELETE PROCEDURE hDBOSubSist.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
