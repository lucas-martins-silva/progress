&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-bomba NO-UNDO LIKE mab-bomba
       field r-rowid as rowid.
DEFINE TEMP-TABLE TTmab-posto NO-UNDO LIKE mab-posto
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
{include/i-prgvrs.i AB0118B 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0118b MAB}
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
&GLOBAL-DEFINE Program            AB0118B
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       0

&GLOBAL-DEFINE FolderLabels     Bomba

&GLOBAL-DEFINE ttTable           TTmab-bomba
&GLOBAL-DEFINE hDBOTable         hDBOBomba
&GLOBAL-DEFINE DBOTable          mab-bomba

&GLOBAL-DEFINE ttParent          TTmab-posto
&GLOBAL-DEFINE DBOParentTable    hDBOPosto

&GLOBAL-DEFINE page0KeyFields     TTmab-bomba.cod-bomba ~
                                  TTmab-bomba.cod-tip-mater    
&GLOBAL-DEFINE page0Fields        TTmab-bomba.idi-control-leitura       
&GLOBAL-DEFINE page0ParentFields  TTmab-posto.cod-posto ~
                                  TTmab-posto.des-posto
                                  
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
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOPosto    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOTpMatl   AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS TTmab-posto.cod-posto TTmab-posto.des-posto ~
TTmab-bomba.cod-bomba TTmab-bomba.cod-tip-mater ~
TTmab-bomba.idi-control-leitura 
&Scoped-define ENABLED-TABLES TTmab-posto TTmab-bomba
&Scoped-define FIRST-ENABLED-TABLE TTmab-posto
&Scoped-define SECOND-ENABLED-TABLE TTmab-bomba
&Scoped-define DISPLAYED-TABLES TTmab-posto TTmab-bomba
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-posto
&Scoped-define SECOND-DISPLAYED-TABLE TTmab-bomba
&Scoped-Define ENABLED-OBJECTS cDescMatl btOK btSave btCancel btHelp ~
RECT-17 RECT-25 rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS TTmab-posto.cod-posto TTmab-posto.des-posto ~
TTmab-bomba.cod-bomba TTmab-bomba.cod-tip-mater ~
TTmab-bomba.idi-control-leitura 
&Scoped-Define DISPLAYED-OBJECTS cDescMatl 

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

DEFINE VARIABLE cDescMatl AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40 BY 2.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 5.67.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     TTmab-posto.cod-posto AT ROW 1.58 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-posto.des-posto AT ROW 2.58 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 40 BY .88
     TTmab-bomba.cod-bomba AT ROW 4.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-bomba.cod-tip-mater AT ROW 5.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cDescMatl AT ROW 5.5 COL 30.14 COLON-ALIGNED NO-LABEL
     TTmab-bomba.idi-control-leitura AT ROW 7.79 COL 26.86 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Nao Controla Leitura", 1,
"Controla Leitura", 2
          SIZE 31.57 BY .71
     btOK AT ROW 10.13 COL 2
     btSave AT ROW 10.13 COL 13
     btCancel AT ROW 10.13 COL 24
     btHelp AT ROW 10.13 COL 80
     RECT-17 AT ROW 7.21 COL 22
     RECT-25 AT ROW 4.08 COL 1
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 9.88 COL 1
     "Tipo Controle" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 6.96 COL 24.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 10.33
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: TTmab-bomba T "?" NO-UNDO mgfro mab-bomba
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: TTmab-posto T "?" NO-UNDO mgfro mab-posto
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
         TITLE              = "Manuten‡Æo de Bombas de Combust¡vel"
         HEIGHT             = 10.42
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
ON END-ERROR OF wMaintenanceNoNavigation /* Manuten‡Æo de Bombas de Combust¡vel */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation /* Manuten‡Æo de Bombas de Combust¡vel */
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


&Scoped-define SELF-NAME TTmab-bomba.cod-tip-mater
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-bomba.cod-tip-mater wMaintenanceNoNavigation
ON LEAVE OF TTmab-bomba.cod-tip-mater IN FRAME fpage0 /* Tipo Material */
DO:
  {method/ReferenceFields.i
        &HandleDBOLeave="hDBOTpMatl"
        &KeyValue1="TTmab-bomba.cod-tip-mater:SCREEN-VALUE IN FRAME fPage0"
        &FieldName1="des-tip-mater"
        &FieldScreen1="cDescMatl"
        &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-bomba.cod-tip-mater wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-bomba.cod-tip-mater IN FRAME fpage0 /* Tipo Material */
OR F5 OF TTmab-bomba.cod-tip-mater IN FRAME fPage0 DO:
   {method/zoomfields.i 
     &ProgramZoom="frzoom~\z01fr026.w"
     &FieldZoom1="cod-tip-mater"
     &FieldScreen1="TTmab-bomba.cod-tip-mater"
     &Frame1="fPage0"
     &FieldZoom2="des-tip-mater"
     &FieldScreen2="cDescMatl"
     &Frame2="fPage0"
     &EnableImplant="yes"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


TTmab-bomba.cod-tip-mater:load-mouse-pointer ("image/lupa.cur")  in frame fPage0.
/*--- L¢gica para inicializa‡Æo do programam ---*/
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
IF VALID-HANDLE (hDBOTpMatl) THEN
       RUN destroy IN hDBOTpMatl.

IF VALID-HANDLE (hDBOPosto) THEN
       RUN destroy IN hDBOPosto.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDiplayFields wMaintenanceNoNavigation 
PROCEDURE afterDiplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FOR FIRST  mab-tip-mater FIELDS (cod-tip-mater des-tip-mater ) WHERE
             mab-tip-mater.cod-tip-mater= TTmab-bomba.cod-tip-mater  NO-LOCK:
              assign cDescMatl:SCREEN-VALUE IN FRAME fPage0 = mab-tip-mater.des-tip-mater.
  END.


   IF pcAction = "Update":U THEN DO:
      ASSIGN  TTmab-bomba.cod-tip-mater:SENSITIVE IN FRAME fPage0 = YES
              TTmab-bomba.idi-control-leitura:SENSITIVE IN FRAME fPage0 = YES
              TTmab-bomba.cod-bomba:SENSITIVE IN FRAME fPage0 = NO.
   END.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisabelFields wMaintenanceNoNavigation 
PROCEDURE afterDisabelFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


  FOR FIRST  mab-tip-mater FIELDS (cod-tip-mater des-tip-mater  ) WHERE
             mab-tip-mater.cod-tip-mater= TTmab-bomba.cod-tip-mater  NO-LOCK:
              assign cDescMatl:SCREEN-VALUE IN FRAME fPage0 = mab-tip-mater.des-tip-mater.
  END.


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
  FOR FIRST  mab-tip-mater FIELDS (cod-tip-mater des-tip-mater  ) WHERE
             mab-tip-mater.cod-tip-mater= TTmab-bomba.cod-tip-mater  NO-LOCK:
              assign cDescMatl:SCREEN-VALUE IN FRAME fPage0 = mab-tip-mater.des-tip-mater.
  END.

 IF pcAction = "Update":U THEN DO:
     ASSIGN  TTmab-bomba.cod-tip-mater:SENSITIVE IN FRAME fPage0 = YES
             TTmab-bomba.idi-control-leitura:SENSITIVE IN FRAME fPage0 = YES
             TTmab-bomba.cod-bomba:SENSITIVE IN FRAME fPage0 = NO.
 END.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveFields wMaintenanceNoNavigation 
PROCEDURE afterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
    ASSIGN cDescMatl:SCREEN-VALUE IN FRAME fPage0 = "".

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

   /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE ({&hDBOTable}) OR 
           {&hDBOTable}:TYPE <> "PROCEDURE":U OR
           {&hDBOTable}:FILE-NAME <> "frbo~\bofr002.p ":U THEN DO:
            RUN  frbo/bofr002.p PERSISTENT SET {&hDBOTable}.
    END.
    
    RUN openQueryStatic in {&hDBOTable} (input "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE (hDBOPosto) OR 
           hDBOPosto:TYPE <> "PROCEDURE":U OR
           hDBOPosto:FILE-NAME <> "frbo~\bofr021.p ":U THEN DO:
            RUN  frbo/bofr021.p PERSISTENT SET hDBOPosto.
    END.
    
    RUN openQueryStatic in hDBOPosto (input "Main":U) NO-ERROR.


   /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(hDBOTpMatl) OR
       hDBOTpMatl:TYPE <> "PROCEDURE":U OR
       hDBOTpMatl:FILE-NAME <> "frbo~\bofr026.p":U THEN DO:
        run "frbo/bofr026.p" persistent set hDBOTpMatl.
    END.
    
    RUN openQueryStatic IN hDBOTpMatl (INPUT "Main":U) NO-ERROR.

 


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
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
assign {&ttTable}.cod-posto = {&ttParent}.cod-posto.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

