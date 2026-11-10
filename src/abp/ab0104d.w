&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-model NO-UNDO LIKE mab-model
       field r-rowid as rowid.
DEFINE TEMP-TABLE TTmmv-tempo-padr NO-UNDO LIKE mmv-tempo-padr
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
{include/i-prgvrs.i AB0104D 2.00.00.001} /*** "010001" 16/05/2025 17:37:31 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0104d MAB}
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
&GLOBAL-DEFINE Program           AB0104D
&GLOBAL-DEFINE Version           2.00.00.001

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       0

&GLOBAL-DEFINE FolderLabels      Tempo-Padr

&GLOBAL-DEFINE ttTable           TTmmv-tempo-padr
&GLOBAL-DEFINE hDBOTable         hDBOTempoPadr
&GLOBAL-DEFINE DBOTable          mmv-tempo-padr

&GLOBAL-DEFINE ttParent          TTmab-model
&GLOBAL-DEFINE DBOParentTable    hDBOMfoModel              

&GLOBAL-DEFINE page0KeyFields   
                                
                                   
&GLOBAL-DEFINE page0ParentFields TTmab-model.cod-model TTmab-model.des-model
                                  
&GLOBAL-DEFINE page0Fields   TTmmv-tempo-padr.cod-evento TTmmv-tempo-padr.cod-sub-sist TTmmv-tempo-padr.val-tempo-padr      


/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOMfoModel   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEvento     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOSubSist    AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS TTmab-model.cod-model TTmab-model.des-model ~
TTmmv-tempo-padr.cod-evento TTmmv-tempo-padr.cod-sub-sist ~
TTmmv-tempo-padr.val-tempo-padr 
&Scoped-define ENABLED-TABLES TTmab-model TTmmv-tempo-padr
&Scoped-define FIRST-ENABLED-TABLE TTmab-model
&Scoped-define SECOND-ENABLED-TABLE TTmmv-tempo-padr
&Scoped-define DISPLAYED-TABLES TTmab-model TTmmv-tempo-padr
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-model
&Scoped-define SECOND-DISPLAYED-TABLE TTmmv-tempo-padr
&Scoped-Define ENABLED-OBJECTS cDescEvento cDescSubSist btOK btSave ~
btCancel btHelp rtKeys rtKeys-2 rtToolBar 
&Scoped-Define DISPLAYED-FIELDS TTmab-model.cod-model TTmab-model.des-model ~
TTmmv-tempo-padr.cod-evento TTmmv-tempo-padr.cod-sub-sist ~
TTmmv-tempo-padr.val-tempo-padr 
&Scoped-Define DISPLAYED-OBJECTS cDescEvento cDescSubSist 

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

DEFINE VARIABLE cDescEvento AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE cDescSubSist AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.96.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 4.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     TTmab-model.cod-model AT ROW 2 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-model.des-model AT ROW 2 COL 30.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 30 BY .88
     TTmmv-tempo-padr.cod-evento AT ROW 4.38 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     cDescEvento AT ROW 4.38 COL 28 COLON-ALIGNED NO-LABEL
     TTmmv-tempo-padr.cod-sub-sist AT ROW 5.38 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     cDescSubSist AT ROW 5.38 COL 28 COLON-ALIGNED NO-LABEL
     TTmmv-tempo-padr.val-tempo-padr AT ROW 6.38 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     btOK AT ROW 8.33 COL 2
     btSave AT ROW 8.33 COL 13
     btCancel AT ROW 8.33 COL 24
     btHelp AT ROW 8.33 COL 80
     rtKeys AT ROW 1.25 COL 1
     rtKeys-2 AT ROW 3.42 COL 1
     rtToolBar AT ROW 8.08 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 8.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: TTmab-model T "?" NO-UNDO mgfro mab-model
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: TTmmv-tempo-padr T "?" NO-UNDO mgfro mmv-tempo-padr
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
         TITLE              = "Tempo Padr∆o por Evento/Sub-Sistema"
         HEIGHT             = 8.46
         WIDTH              = 89.86
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
ON END-ERROR OF wMaintenanceNoNavigation /* Tempo Padr∆o por Evento/Sub-Sistema */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation /* Tempo Padr∆o por Evento/Sub-Sistema */
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


&Scoped-define SELF-NAME TTmmv-tempo-padr.cod-evento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmmv-tempo-padr.cod-evento wMaintenanceNoNavigation
ON LEAVE OF TTmmv-tempo-padr.cod-evento IN FRAME fpage0 /* Evento */
DO:
  {method/ReferenceFields.i
        &HandleDBOLeave="hDBOEvento"
        &KeyValue1="input frame fPage0 TTmmv-tempo-padr.cod-evento"
        &FieldName1="des-evento"
        &FieldScreen1="cDescEvento"
        &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmmv-tempo-padr.cod-evento wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmmv-tempo-padr.cod-evento IN FRAME fpage0 /* Evento */
OR F5 OF TTmmv-tempo-padr.cod-evento IN FRAME fPage0 DO:
     {method/zoomfields.i 
       &ProgramZoom="frzoom~\z01fr010.w"
       &FieldZoom1="cod-evento"
       &FieldScreen1="TTmmv-tempo-padr.cod-evento"
       &Frame1="fPage0"
       &FieldZoom2="des-evento"
       &FieldScreen2="cDescEvento"
       &Frame2="fPage0"
       &EnableImplant="yes"}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmmv-tempo-padr.cod-sub-sist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmmv-tempo-padr.cod-sub-sist wMaintenanceNoNavigation
ON LEAVE OF TTmmv-tempo-padr.cod-sub-sist IN FRAME fpage0 /* Sub Sistema */
DO:
  {method/ReferenceFields.i
        &HandleDBOLeave="hDBOSubSist"
        &KeyValue1="input frame fPage0 TTmmv-tempo-padr.cod-sub-sist"
        &FieldName1="des-sub-sist"
        &FieldScreen1="cDescSubSist"
        &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmmv-tempo-padr.cod-sub-sist wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmmv-tempo-padr.cod-sub-sist IN FRAME fpage0 /* Sub Sistema */
OR F5 OF TTmmv-tempo-padr.cod-sub-sist IN FRAME fPage0 DO:
     {method/zoomfields.i 
       &ProgramZoom="frzoom~\z01fr025.w"
       &FieldZoom1="cod-sub-sist"
       &FieldScreen1="TTmmv-tempo-padr.cod-sub-sist"
       &Frame1="fPage0"
       &FieldZoom2="des-sub-sist"
       &FieldScreen2="cDescSubSist"
       &Frame2="fPage0"
       &EnableImplant="yes"}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


TTmmv-tempo-padr.cod-evento:load-mouse-pointer ("image/lupa.cur")  in frame fPage0.
TTmmv-tempo-padr.cod-sub-sist:load-mouse-pointer ("image/lupa.cur")  in frame fPage0.
/*--- L¢gica para inicializaá∆o do programam ---*/
{maintenancenonavigation/mainblock.i}

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
IF VALID-HANDLE (hDBOMfoModel) THEN
       RUN destroy IN hDBOMfoModel.

IF VALID-HANDLE (hDBOEvento) THEN
       RUN destroy IN hDBOEvento.

IF VALID-HANDLE (hDBOSubSist) THEN
       RUN destroy IN hDBOSubSist.


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

FOR FIRST mab-event  FIELDS (des-evento cod-evento) WHERE 
    mab-event.cod-evento = TTmmv-tempo-padr.cod-evento:SCREEN-VALUE IN FRAME fPage0 NO-LOCK:
    
    ASSIGN cDescEvento:SCREEN-VALUE IN FRAME fPage0 = mab-event.des-evento.
END.

FOR FIRST mab-sub-sist FIELDS (cod-sub-sist des-sub-sist) WHERE 
    mab-sub-sist.cod-sub-sist  = TTmmv-tempo-padr.cod-sub-sist:SCREEN-VALUE IN FRAME fPage0 NO-LOCK:
    
    ASSIGN cDescSubSist:SCREEN-VALUE IN FRAME fPage0 =  mab-sub-sist.des-sub-sist.
END.

if pcAction = "UPDATE":U then do:   
      ASSIGN  TTmmv-tempo-padr.val-tempo-padr:SENSITIVE IN FRAME fPage0 = YES
              TTmmv-tempo-padr.cod-evento:SENSITIVE IN FRAME fPage0 = NO
              TTmmv-tempo-padr.cod-sub-sist:SENSITIVE IN FRAME fPage0 = NO.      
        
      
end. 

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
FOR FIRST mab-event  FIELDS (des-evento cod-evento) WHERE 
    mab-event.cod-evento = TTmmv-tempo-padr.cod-evento:SCREEN-VALUE IN FRAME fPage0 NO-LOCK:
    
    ASSIGN cDescEvento:SCREEN-VALUE IN FRAME fPage0 = mab-event.des-evento.
END.

FOR FIRST mab-sub-sist FIELDS (cod-sub-sist des-sub-sist) WHERE 
    mab-sub-sist.cod-sub-sist  = TTmmv-tempo-padr.cod-sub-sist:SCREEN-VALUE IN FRAME fPage0 NO-LOCK:
    
    ASSIGN cDescSubSist:SCREEN-VALUE IN FRAME fPage0 =  mab-sub-sist.des-sub-sist.
END.


if pcAction = "UPDATE":U then do:   
      ASSIGN  TTmmv-tempo-padr.val-tempo-padr:SENSITIVE IN FRAME fPage0 = YES
              TTmmv-tempo-padr.cod-evento:SENSITIVE IN FRAME fPage0 = NO
              TTmmv-tempo-padr.cod-sub-sist:SENSITIVE IN FRAME fPage0 = NO.      
end.


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
   /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE ({&hDBOTable}) OR 
           {&hDBOTable}:TYPE <> "PROCEDURE":U OR
           {&hDBOTable}:FILE-NAME <> "frbo~\bofr078.p ":U THEN DO:
            RUN  frbo/bofr078.p PERSISTENT SET {&hDBOTable}.
    END.
    
    RUN openQueryStatic in {&hDBOTable} (input "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE (hDBOMfoModel) OR 
           hDBOMfoModel:TYPE <> "PROCEDURE":U OR
           hDBOMfoModel:FILE-NAME <> "frbo~\bofr016.p ":U THEN DO:
            RUN  frbo/bofr016.p PERSISTENT SET hDBOMfoModel.
    END.
    
    RUN openQueryStatic in hDBOMfoModel (input "Main":U) NO-ERROR.

     /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE (hDBOEvento) OR 
           hDBOEvento:TYPE <> "PROCEDURE":U OR
           hDBOEvento:FILE-NAME <> "frbo~\bofr020.p":U THEN DO:
            RUN  frbo/bofr010.p PERSISTENT SET hDBOEvento.
    END.
    
    RUN openQueryStatic in hDBOEvento (input "Main":U) NO-ERROR.

       /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE (hDBOSubSist) OR 
           hDBOSubsist:TYPE <> "PROCEDURE":U OR
           hDBOSubsist:FILE-NAME <> "frbo~\bofr025.p":U THEN DO:
            RUN  frbo/bofr025.p PERSISTENT SET hDBOSubsist.
    END.
    
    RUN openQueryStatic in hDBOSubsist (input "Main":U) NO-ERROR.

 RETURN "ok":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este mÇtodo somente Ç executado quando a vari†vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/

assign {&ttTable}.cod-model = {&ttParent}.cod-model.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

