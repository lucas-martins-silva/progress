&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-tip-mater NO-UNDO LIKE mab-tip-mater
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
{include/i-prgvrs.i AB0102A 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0102a MAB}
&ENDIF



CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AB0102A
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder           NO
&GLOBAL-DEFINE InitialPage      

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           TTmab-tip-mater
&GLOBAL-DEFINE hDBOTable         hDBOTpMatl
&GLOBAL-DEFINE DBOTable          mab-tip-mater


&GLOBAL-DEFINE page0KeyFields   TTmab-tip-mater.cod-tip-mater 
                                
&GLOBAL-DEFINE page0Fields      TTmab-tip-mater.des-tip-mater ~
                                TTmab-tip-mater.un ~
                                TTmab-tip-mater.dat-livre-1 ~
                                TTmab-tip-mater.log-integr

&GLOBAL-DEFINE page1Fields       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}       AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOUnid          AS HANDLE NO-UNDO.


DEFINE VARIABLE l-achou     AS LOGICAL NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE wMaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS TTmab-tip-mater.cod-tip-mater ~
TTmab-tip-mater.des-tip-mater TTmab-tip-mater.un ~
TTmab-tip-mater.dat-livre-1 TTmab-tip-mater.log-integr 
&Scoped-define ENABLED-TABLES TTmab-tip-mater
&Scoped-define FIRST-ENABLED-TABLE TTmab-tip-mater
&Scoped-Define ENABLED-OBJECTS RECT-25 rtKeys rtToolBar cDescUnid btOK ~
btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS TTmab-tip-mater.cod-tip-mater ~
TTmab-tip-mater.des-tip-mater TTmab-tip-mater.un ~
TTmab-tip-mater.dat-livre-1 TTmab-tip-mater.log-integr 
&Scoped-define DISPLAYED-TABLES TTmab-tip-mater
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-tip-mater
&Scoped-Define DISPLAYED-OBJECTS cDescUnid 

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

DEFINE VARIABLE cDescUnid AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.5.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 6.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     TTmab-tip-mater.cod-tip-mater AT ROW 1.46 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     TTmab-tip-mater.des-tip-mater AT ROW 2.71 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 38 BY .88
     TTmab-tip-mater.un AT ROW 3.71 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     cDescUnid AT ROW 3.71 COL 27 COLON-ALIGNED NO-LABEL
     TTmab-tip-mater.dat-livre-1 AT ROW 4.63 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     TTmab-tip-mater.log-integr AT ROW 5.83 COL 21
          VIEW-AS TOGGLE-BOX
          SIZE 17.29 BY .71
     btOK AT ROW 7.46 COL 2
     btSave AT ROW 7.46 COL 13
     btCancel AT ROW 7.46 COL 24
     btHelp AT ROW 7.46 COL 80
     "Descri‡Æo:" VIEW-AS TEXT
          SIZE 7.29 BY .54 AT ROW 2.96 COL 13.29
     RECT-25 AT ROW 1 COL 1
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 7.17 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 7.63
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: wMaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: TTmab-tip-mater T "?" NO-UNDO mgfro mab-tip-mater
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
         TITLE              = "Manuten‡Æo dos Tipos de Material"
         HEIGHT             = 7.71
         WIDTH              = 90
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
ON END-ERROR OF wMaintenanceNoNavigation /* Manuten‡Æo dos Tipos de Material */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation /* Manuten‡Æo dos Tipos de Material */
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


&Scoped-define SELF-NAME TTmab-tip-mater.un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-tip-mater.un wMaintenanceNoNavigation
ON F5 OF TTmab-tip-mater.un IN FRAME fpage0 /* Unidade Medida */
DO:
    assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="inzoom\z01in417.w"
                     &campo=TTmab-tip-mater.un
                     &campozoom=un
                     &campo2=cDescUnid
                     &campozoom2=descricao}

    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-tip-mater.un wMaintenanceNoNavigation
ON LEAVE OF TTmab-tip-mater.un IN FRAME fpage0 /* Unidade Medida */
DO:
    {method\referenceFields.i
              &HandleDBOLeave="hDBOUnid"
              &KeyValue1="TTmab-tip-mater.un:screen-value in frame fPage0"
              &FieldName1="descricao"
              &FieldScreen1="cDescUnid"
              &Frame1="fPage0"}
              
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-tip-mater.un wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-tip-mater.un IN FRAME fpage0 /* Unidade Medida */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}
   TTmab-tip-mater.un:LOAD-MOUSE-POINTER("image~\lupa.cur":U)  in frame fPage0.

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
if valid-handle (hDBOUnid) then
     delete procedure hDBOUnid.

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
 if pcAction <> "ADD" then do:
        
    disp {&ttTable}.cod-tip-mater with frame fPage0.
    apply "leave" to {&ttTable}.cod-tip-mater        in frame fPage0.
    disp {&ttTable}.des-tip-mater   with frame fPage0.
    apply "leave" to {&ttTable}.des-tip-mater      in frame fPage0.

END.

IF INPUT FRAME fPage0 {&ttTable}.dat-livre-1 = ? THEN DO:
    ASSIGN {&ttTable}.dat-livre-1 = 01/01/1900.
    DISPLAY {&ttTable}.dat-livre-1 WITH FRAME fPage0.
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
  if pcAction = "ADD":U  then do:
    
     RUN emptyRowErrors IN {&hDBOTable}.
         if return-value = "OK":U then
            DISP TTmab-tip-mater.cod-tip-mater with  frame fPage0.
         else do:
              RUN getRowErrors IN {&hDBOTable} (OUTPUT TABLE RowErrors).
             {method/showmessage.i1}
             {method/showmessage.i2}
         end.
  end.

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
DEFINE VARIABLE c-livre-1 AS CHARACTER  NO-UNDO.

   if pcAction = "UPDATE":U  THEN DO:
      ASSIGN TTmab-tip-mater.cod-tip-mater:SENSITIVE IN FRAME fPage0 = NO
             TTmab-tip-mater.des-tip-mater:SENSITIVE IN FRAME fPage0 = YES.
   END.

   IF pcAction = "UPDATE":U OR pcAction = "COPY":U THEN DO:
       apply "leave" to TTmab-tip-mater.un in frame fPage0.
   END.

   DO WITH FRAME fPage0:
       IF pcAction = "ADD":U OR pcAction = "CREATE":U THEN DO:
           ASSIGN TTmab-tip-mater.dat-livre-1 = TODAY.
           DISP TTmab-tip-mater.dat-livre-1.
       END.
   END.
   {utp/ut-liter.i "In¡cio Integra‡Æo" *}
   ASSIGN TTmab-tip-mater.dat-livre-1:LABEL IN FRAME fPage0 = RETURN-VALUE.


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
IF NOT VALID-HANDLE({&hDBOTable}) OR 
         {&hDBOTable}:TYPE <> "PROCEDURE":U OR
         {&hDBOTable}:FILE-NAME <> "frbo~\bofr026.p":U THEN DO:
        RUN frbo/bofr026.p PERSISTENT SET  {&hDBOTable}.
END.
RUN openQueryStatic in   {&hDBOTable} (input "Main":U) NO-ERROR.

IF NOT VALID-HANDLE(hDBOUnid) OR 
         hDBOUnid:TYPE <> "PROCEDURE":U OR
         hDBOUnid:FILE-NAME <> "inbo/boin417.p":U THEN DO:
        RUN inbo/boin417.p PERSISTENT SET  hDBOUnid.
END.
RUN openQueryStatic in   hDBOUnid (input "Main":U) NO-ERROR.



     
RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

