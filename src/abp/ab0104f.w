&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttEspecModel NO-UNDO LIKE mab-model-especialid
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttModelo NO-UNDO LIKE mab-model
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
{include/i-prgvrs.i MV0301C 2.00.00.004 } /*** "010004" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0104f MAB}
&ENDIF



CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AB0104F
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE Folder           NO
&GLOBAL-DEFINE InitialPage      

&GLOBAL-DEFINE FolderLabels  
    
&GLOBAL-DEFINE ttTable        ttEspecModel 
&GLOBAL-DEFINE hDBOTable      hDBOEspecialidaModel
&GLOBAL-DEFINE DBOTable       mmv-model-especialid

&GLOBAL-DEFINE ttParent       ttModelo
&GLOBAL-DEFINE DBOParentTable hDBOModelo


&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0ParentFields ttEspecModel.cod-evento ~
                                 ttEspecModel.cod-sub-sist

&GLOBAL-DEFINE page0Fields       ttEspecModel.tipo-espec ~
                                 ttEspecModel.tp-especial ~
                                 ttEspecModel.nr-homens ~
                                 ttEspecModel.tempo ~
                                 ttEspecModel.tipo-tempo ~
                                 ttEspecModel.log-gera-espec-om ~
                                 ttEspecModel.des-obs

&GLOBAL-DEFINE page1Fields       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}      AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEspec         AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOSist          AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEvento        AS HANDLE NO-UNDO.


DEFINE VARIABLE l-achou     AS LOGICAL NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE VAR c-cod-evento    LIKE mmv-tempo-padr.cod-evento     NO-UNDO.
DEFINE VAR c-cod-sub-sist  LIKE mmv-tempo-padr.cod-sub-sist   NO-UNDO.
DEFINE VAR dc-tempo-padrao LIKE mmv-tempo-padr.val-tempo-padr NO-UNDO.

/* Buffer da tabela onde tem os eventos relacionados ao modelo */
DEFINE BUFFER bfTempoPadraoModelo FOR mmv-tempo-padr.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE wMaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttEspecModel.cod-evento ~
ttEspecModel.cod-sub-sist ttEspecModel.tp-especial ttEspecModel.tipo-espec ~
ttEspecModel.nr-homens ttEspecModel.tempo ttEspecModel.tipo-tempo ~
ttEspecModel.log-gera-espec-om ttEspecModel.des-obs 
&Scoped-define ENABLED-TABLES ttEspecModel
&Scoped-define FIRST-ENABLED-TABLE ttEspecModel
&Scoped-Define ENABLED-OBJECTS RECT-25 rtToolBar RECT-26 RECT-27 ~
fiDescEvento fiDescSub desc-espe btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS ttEspecModel.cod-evento ~
ttEspecModel.cod-sub-sist ttEspecModel.tp-especial ttEspecModel.tipo-espec ~
ttEspecModel.nr-homens ttEspecModel.tempo ttEspecModel.tipo-tempo ~
ttEspecModel.log-gera-espec-om ttEspecModel.des-obs 
&Scoped-define DISPLAYED-TABLES ttEspecModel
&Scoped-define FIRST-DISPLAYED-TABLE ttEspecModel
&Scoped-Define DISPLAYED-OBJECTS fiDescEvento fiDescSub desc-espe 

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

DEFINE VARIABLE desc-espe AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.43 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescEvento AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescSub AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.75.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.88.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 7.21.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttEspecModel.cod-evento AT ROW 1.33 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescEvento AT ROW 1.33 COL 25.57 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     ttEspecModel.cod-sub-sist AT ROW 2.33 COL 15 COLON-ALIGNED WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescSub AT ROW 2.33 COL 25.57 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     ttEspecModel.tp-especial AT ROW 4.29 COL 15 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     desc-espe AT ROW 4.29 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     ttEspecModel.tipo-espec AT ROW 5.5 COL 17 NO-LABEL WIDGET-ID 26
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Normal", 1,
"Apoio", 2
          SIZE 20 BY .88
     ttEspecModel.nr-homens AT ROW 6.63 COL 15 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttEspecModel.tempo AT ROW 7.63 COL 15 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttEspecModel.tipo-tempo AT ROW 8.75 COL 17.29 NO-LABEL WIDGET-ID 44
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Individual", 1,
"Total", 2
          SIZE 20 BY .88
     ttEspecModel.log-gera-espec-om AT ROW 8.75 COL 51 WIDGET-ID 70
          LABEL "Gera Especialidade OM"
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .83
     ttEspecModel.des-obs AT ROW 10.75 COL 2.29 HELP
          "" NO-LABEL WIDGET-ID 50
          VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
          SIZE 87.43 BY 6.25
     btOK AT ROW 17.92 COL 2
     btSave AT ROW 17.92 COL 13
     btCancel AT ROW 17.92 COL 24
     btHelp AT ROW 17.92 COL 80
     "Tipo Especialidade:" VIEW-AS TEXT
          SIZE 13.86 BY .88 AT ROW 5.5 COL 3.14 WIDGET-ID 38
     "Tipo Tempo:" VIEW-AS TEXT
          SIZE 9 BY .79 AT ROW 8.75 COL 7 WIDGET-ID 42
     "Observa‡Æo:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 10 COL 7 WIDGET-ID 54
     RECT-25 AT ROW 1 COL 1
     rtToolBar AT ROW 17.63 COL 1
     RECT-26 AT ROW 4 COL 1 WIDGET-ID 6
     RECT-27 AT ROW 10.29 COL 1 WIDGET-ID 56
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.04
         SIZE 90.57 BY 18.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: wMaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttEspecModel T "?" NO-UNDO mgfro mab-model-especialid
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttModelo T "?" NO-UNDO mgfro mab-model
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
         TITLE              = "Especialidades do Evento do Modelo"
         HEIGHT             = 18.38
         WIDTH              = 90.14
         MAX-HEIGHT         = 31.29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 31.29
         VIRTUAL-WIDTH      = 146.29
         MAX-BUTTON         = no
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
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR EDITOR ttEspecModel.des-obs IN FRAME fpage0
   EXP-HELP                                                             */
/* SETTINGS FOR TOGGLE-BOX ttEspecModel.log-gera-espec-om IN FRAME fpage0
   EXP-LABEL                                                            */
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
ON END-ERROR OF wMaintenanceNoNavigation /* Especialidades do Evento do Modelo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation /* Especialidades do Evento do Modelo */
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


&Scoped-define SELF-NAME ttEspecModel.cod-evento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEspecModel.cod-evento wMaintenanceNoNavigation
ON LEAVE OF ttEspecModel.cod-evento IN FRAME fpage0 /* Evento */
DO:
    IF  AVAIL ttModelo THEN DO:
        ASSIGN fiDescEvento:SCREEN-VALUE IN FRAME fPage0 = ttModelo.des-model.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttEspecModel.cod-sub-sist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEspecModel.cod-sub-sist wMaintenanceNoNavigation
ON LEAVE OF ttEspecModel.cod-sub-sist IN FRAME fpage0 /* Sub-Sistema */
DO:
    {method\referenceFields.i
            &HandleDBOLeave="hDBOSist"
            &KeyValue1="ttEspecModel.cod-sub-sist:screen-value in frame fPage0"
            &FieldName1="des-sub-sist"
            &FieldScreen1="fiDescSub"
            &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttEspecModel.tp-especial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEspecModel.tp-especial wMaintenanceNoNavigation
ON LEAVE OF ttEspecModel.tp-especial IN FRAME fpage0 /* Especialidade */
DO:
  run getDescFK in hDBOEspec (input "mi-espec":U, 
                              input input frame fPage0 ttEspecModel.tp-especial,
                              output desc-espe).
  display desc-espe with frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEspecModel.tp-especial wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttEspecModel.tp-especial IN FRAME fpage0 /* Especialidade */
OR F5 OF ttEspecModel.tp-especial IN FRAME fpage0 /* Especialidade */
DO:
  {method/zoomfields.i 
           &ProgramZoom="mnzoom/z02mn112.w"
           &FieldZoom1="tp-especial"
           &FieldScreen1="ttEspecModel.tp-especial"
           &Frame1="fPage0"
           &FieldZoom2="descricao"
           &FieldScreen2="desc-espe"
           &Frame2="fPage0"
           &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}
 ttEspecModel.tp-especial:LOAD-MOUSE-POINTER("image/lupa.cur") in frame fPage0.

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

    IF  VALID-HANDLE (hDBOEspec) THEN
        DELETE PROCEDURE hDBOEspec.

    IF  VALID-HANDLE (hDBOSist) THEN
        DELETE PROCEDURE hDBOSist.

    IF  VALID-HANDLE (hDBOEvento) THEN
        DELETE PROCEDURE hDBOEvento.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /** Descri‡äes **/
    APPLY "leave":U TO ttEspecModel.tp-especial IN FRAME fPage0.
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF  pcAction = "ADD":U OR pcAction = "UPDATE":U THEN DO:
        ASSIGN c-cod-evento   = ""
               c-cod-sub-sist = "".
        RUN piInformaEventoSelecionado IN phCaller (OUTPUT c-cod-evento, OUTPUT c-cod-sub-sist, OUTPUT dc-tempo-padrao) NO-ERROR.
        ASSIGN ttEspecModel.cod-evento:SCREEN-VALUE IN FRAME fPage0 = c-cod-evento.
        ASSIGN ttEspecModel.cod-sub-sist:SCREEN-VALUE IN FRAME fPage0 = c-cod-sub-sist.
        IF  pcAction = "ADD":U THEN
            ASSIGN ttEspecModel.tempo:SCREEN-VALUE IN FRAME fPage0 = STRING(dc-tempo-padrao).
        APPLY "LEAVE":U TO ttEspecModel.cod-evento  IN FRAME fPage0.       
        APPLY "LEAVE":U TO ttEspecModel.cod-sub-sist IN FRAME fPage0.       

    END.

    IF  pcAction = "ADD":U THEN DO:
        ASSIGN ttEspecModel.tp-especial:SENSITIVE IN FRAME fPage0 = YES.
        APPLY "ENTRY":U TO ttEspecModel.tp-especial IN FRAME fPage0.
    END.
    ELSE DO:
        ASSIGN ttEspecModel.tp-especial:SENSITIVE IN FRAME fPage0 = NO.
        APPLY "ENTRY":U TO ttEspecModel.tp-especial IN FRAME fPage0.
    END.

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
    /** Seta foco no campo correto **/
    
    RETURN "OK":U.

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
    /** Inicializa‡Æo das BOs **/
    RUN initializeDBOs IN THIS-PROCEDURE.
    
    RETURN "OK":U.

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

    /* Especialidade */
    IF NOT VALID-HANDLE(hDBOEspec) OR 
             hDBOEspec:TYPE <> "PROCEDURE":U OR
             hDBOEspec:FILE-NAME <> "frbo\bofr00145.p":U THEN DO:
            RUN frbo/bofr00145.p PERSISTENT SET hDBOEspec.
    END.
    RUN openQueryStatic in   hDBOEspec (input "Main":U) NO-ERROR.

    /*--- Sub-Sistema ---*/
    IF NOT VALID-HANDLE(hDBOSist) OR
       hDBOSist:TYPE <> "PROCEDURE":U OR
       hDBOSist:FILE-NAME <> "frbo\bofr025.p":U THEN DO:
        run frbo/bofr025.p persistent set hDBOSist.
    END.
    RUN openQueryStatic IN hDBOSist (INPUT "Main":U) NO-ERROR.

    /*--- Evento ---*/
    IF NOT VALID-HANDLE(hDBOEvento) OR
       hDBOEvento:TYPE <> "PROCEDURE":U OR
       hDBOEvento:FILE-NAME <> "frbo\bofr010.p":U THEN DO:
        run frbo/bofr010.p persistent set hDBOEvento.
    END.
    RUN openQueryStatic IN hDBOEvento (INPUT "Main":U) NO-ERROR.

    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN {&ttTable}.cod-model     = {&ttParent}.cod-model
           {&ttTable}.cod-sub-sist  = ttEspecModel.cod-sub-sist:SCREEN-VALUE IN FRAME fPage0
           {&ttTable}.cod-evento    = ttEspecModel.cod-evento:SCREEN-VALUE IN FRAME fPage0
           {&ttTable}.tp-especial   = ttEspecModel.tp-especial:SCREEN-VALUE IN FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

