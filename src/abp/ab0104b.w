&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-consu-model NO-UNDO LIKE mab-consu-model
       field r-rowid as rowid.
DEFINE TEMP-TABLE TTmab-model NO-UNDO LIKE mab-model
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
{include/i-prgvrs.i AB0104B 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0104b MAB}
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
&GLOBAL-DEFINE Program           AB0104B
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       0

&GLOBAL-DEFINE FolderLabels      Consumo

&GLOBAL-DEFINE ttTable           TTmab-consu-model
&GLOBAL-DEFINE hDBOTable         hDBOConsuModel
&GLOBAL-DEFINE DBOTable          mab-consu-model

&GLOBAL-DEFINE ttParent          TTmab-model
&GLOBAL-DEFINE DBOParentTable    hDBOMfoModel

&GLOBAL-DEFINE page0KeyFields    TTmab-consu-model.cod-ativid ~
                                 TTmab-consu-model.cod-tip-mater ~
                                 TTmab-consu-model.val-consu-padr ~
                                 TTmab-consu-model.val-consu-sec ~
                                 TTmab-model.un cCodUnSec
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields TTmab-model.cod-model ~
                                 TTmab-model.des-model
                                  
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
DEFINE VARIABLE hDBOMfoModel  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOTpMatl    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOAtivid    AS HANDLE NO-UNDO.
DEFINE BUFFER bfMab-model FOR mab-model.

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
TTmab-consu-model.cod-ativid TTmab-consu-model.cod-tip-mater ~
TTmab-consu-model.val-consu-padr TTmab-consu-model.val-consu-sec 
&Scoped-define ENABLED-TABLES TTmab-model TTmab-consu-model
&Scoped-define FIRST-ENABLED-TABLE TTmab-model
&Scoped-define SECOND-ENABLED-TABLE TTmab-consu-model
&Scoped-define DISPLAYED-TABLES TTmab-model TTmab-consu-model
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-model
&Scoped-define SECOND-DISPLAYED-TABLE TTmab-consu-model
&Scoped-Define ENABLED-OBJECTS cDescAtiv cDescTpMatl btOK btSave btCancel ~
btHelp rtKeys rtKeys-2 rtToolBar 
&Scoped-Define DISPLAYED-FIELDS TTmab-model.cod-model TTmab-model.des-model ~
TTmab-consu-model.cod-ativid TTmab-consu-model.cod-tip-mater ~
TTmab-consu-model.val-consu-padr TTmab-model.un ~
TTmab-consu-model.val-consu-sec 
&Scoped-Define DISPLAYED-OBJECTS cDescAtiv cDescTpMatl cCodUnTpMaterial ~
cCodUnSec 

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

DEFINE VARIABLE cCodUnSec AS CHARACTER FORMAT "XX":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE cCodUnTpMaterial AS CHARACTER FORMAT "XX":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE cDescAtiv AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE cDescTpMatl AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.25.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 4.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     TTmab-model.cod-model AT ROW 1.13 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     TTmab-model.des-model AT ROW 1.13 COL 28 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 30 BY .88
     TTmab-consu-model.cod-ativid AT ROW 2.67 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     cDescAtiv AT ROW 2.67 COL 28 COLON-ALIGNED NO-LABEL
     TTmab-consu-model.cod-tip-mater AT ROW 3.67 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     cDescTpMatl AT ROW 3.67 COL 28 COLON-ALIGNED NO-LABEL
     cCodUnTpMaterial AT ROW 3.67 COL 58.43 COLON-ALIGNED NO-LABEL
     TTmab-consu-model.val-consu-padr AT ROW 4.67 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     TTmab-model.un AT ROW 4.67 COL 32.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-consu-model.val-consu-sec AT ROW 5.67 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     cCodUnSec AT ROW 5.67 COL 32.29 COLON-ALIGNED NO-LABEL
     btOK AT ROW 7.13 COL 2
     btSave AT ROW 7.13 COL 13
     btCancel AT ROW 7.13 COL 24
     btHelp AT ROW 7.13 COL 80
     rtKeys AT ROW 1 COL 1
     rtKeys-2 AT ROW 2.5 COL 1
     rtToolBar AT ROW 6.88 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 7.38
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: TTmab-consu-model T "?" NO-UNDO mgfro mab-consu-model
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: TTmab-model T "?" NO-UNDO mgfro mab-model
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
         TITLE              = "Consumo Padr∆o por Modelo X Atividade"
         HEIGHT             = 7.29
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
/* SETTINGS FOR FILL-IN cCodUnSec IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cCodUnTpMaterial IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN TTmab-model.un IN FRAME fpage0
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
ON END-ERROR OF wMaintenanceNoNavigation /* Consumo Padr∆o por Modelo X Atividade */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation /* Consumo Padr∆o por Modelo X Atividade */
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


&Scoped-define SELF-NAME TTmab-consu-model.cod-ativid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-consu-model.cod-ativid wMaintenanceNoNavigation
ON LEAVE OF TTmab-consu-model.cod-ativid IN FRAME fpage0 /* Atividade */
DO:
  {method/ReferenceFields.i
        &HandleDBOLeave="hDBOAtivid"
        &KeyValue1="input frame fPage0 TTmab-consu-model.cod-ativid"
        &FieldName1="des-ativid"
        &FieldScreen1="cDescAtiv"
        &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-consu-model.cod-ativid wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-consu-model.cod-ativid IN FRAME fpage0 /* Atividade */
OR F5 OF TTmab-consu-model.cod-ativid IN FRAME fPage0 DO:
     {method/zoomfields.i 
       &ProgramZoom="frzoom/z01fr001.w"
       &FieldZoom1="cod-ativid"
       &FieldScreen1="TTmab-consu-model.cod-ativid"
       &Frame1="fPage0"
       &FieldZoom2="des-ativid"
       &FieldScreen2="cDescAtiv"
       &Frame2="fPage0"
       &EnableImplant="yes"}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-consu-model.cod-tip-mater
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-consu-model.cod-tip-mater wMaintenanceNoNavigation
ON LEAVE OF TTmab-consu-model.cod-tip-mater IN FRAME fpage0 /* Tipo Material */
DO:
  {method/ReferenceFields.i
        &HandleDBOLeave="hDBOTpMatl"
        &KeyValue1="TTmab-consu-model.cod-tip-mater:SCREEN-VALUE IN FRAME fpage0"
        &FieldName1="des-tip-mater"
        &FieldScreen1="cDescTpMatl"
        &Frame1="fPage0"
        &FieldName2="un"
        &FieldScreen2="cCodUnTpMaterial"
        &Frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-consu-model.cod-tip-mater wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-consu-model.cod-tip-mater IN FRAME fpage0 /* Tipo Material */
OR F5 OF TTmab-consu-model.cod-tip-mater IN FRAME fPage0 DO:
     {method/zoomfields.i 
       &ProgramZoom="frzoom/z01fr026.w"
       &FieldZoom1="cod-tip-mater"
       &FieldScreen1="TTmab-consu-model.cod-tip-mater"
       &Frame1="fPage0"
       &FieldZoom2="des-tip-mater"
       &FieldScreen2="cDescTpMatl"
       &Frame2="fPage0"
       &FieldZoom3="un"
       &FieldScreen3="cCodUnTpMaterial"
       &Frame3="fPage0"       
       &EnableImplant="yes"}
       


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


TTmab-consu-model.cod-ativid:load-mouse-pointer ("image/lupa.cur")  in frame fPage0.
TTmab-consu-model.cod-tip-mater:load-mouse-pointer ("image/lupa.cur")  in frame fPage0.
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

IF VALID-HANDLE (hDBOTpMatl) THEN
       RUN destroy IN hDBOTpMatl.

IF VALID-HANDLE (hDBOAtivid) THEN
       RUN destroy IN hDBOAtivid.


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

FOR FIRST mab-ativid  FIELDS (des-ativid cod-ativid) WHERE 
    mab-ativid.cod-ativid = TTmab-consu-model.cod-ativid:SCREEN-VALUE IN FRAME fPage0 NO-LOCK:
    
    ASSIGN cDescAtiv:SCREEN-VALUE IN FRAME fPage0 = mab-ativid.des-ativid.
END.

FOR FIRST mab-tip-mater FIELDS (cod-tip-mater des-tip-mater un) WHERE 
    mab-tip-mater.cod-tip-mater  = TTmab-consu-model.cod-tip-mater:SCREEN-VALUE IN FRAME fPage0 NO-LOCK:
    
    ASSIGN cDescTpMatl:SCREEN-VALUE IN FRAME fPage0      =  mab-tip-mater.des-tip-mater
           cCodUntpMaterial:SCREEN-VALUE IN FRAME fPage0 =  mab-tip-mater.un.
END.

if pcAction = "UPDATE":U then do:   
      ASSIGN  TTmab-consu-model.val-consu-padr:SENSITIVE IN FRAME fPage0 = YES
              TTmab-consu-model.cod-tip-mater:SENSITIVE IN FRAME fPage0 = NO
               TTmab-consu-model.cod-ativid:SENSITIVE IN FRAME fPage0 = NO.      
        
      
end. 

IF  AVAIL TTmab-model THEN DO:
    ASSIGN TTmab-model.un:SCREEN-VALUE IN FRAME fPage0 = TTmab-model.un
           cCodUnSec:SCREEN-VALUE      IN FRAME fPage0 = SUBSTRING(TTmab-model.cod-livre-1, 1, 2).
END.
ASSIGN TTmab-model.un:SENSITIVE IN FRAME fPage0 = NO
       cCodUnSec:SENSITIVE      IN FRAME fPage0 = NO.      


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
    FOR FIRST mab-ativid FIELDS (des-ativid cod-ativid)
        WHERE mab-ativid.cod-ativid = TTmab-consu-model.cod-ativid:SCREEN-VALUE IN FRAME fPage0 NO-LOCK:
        ASSIGN cDescAtiv:SCREEN-VALUE IN FRAME fPage0 = mab-ativid.des-ativid.
    END.
    
    FOR FIRST mab-tip-mater FIELDS (cod-tip-mater des-tip-mater)
        WHERE mab-tip-mater.cod-tip-mater  = TTmab-consu-model.cod-tip-mater:SCREEN-VALUE IN FRAME fPage0 NO-LOCK:
        ASSIGN cDescTpMatl:SCREEN-VALUE IN FRAME fPage0 =  mab-tip-mater.des-tip-mater
            cCodUnTpMaterial:SCREEN-VALUE IN FRAME fPage0 = mab-tip-mater.un.
    END.

    IF  pcAction = "UPDATE":U THEN
        ASSIGN TTmab-consu-model.val-consu-padr:SENSITIVE IN FRAME fPage0 = YES
               TTmab-consu-model.cod-tip-mater:SENSITIVE  IN FRAME fPage0 = NO
               TTmab-consu-model.cod-ativid:SENSITIVE     IN FRAME fPage0 = NO.

    IF  AVAIL TTmab-model THEN DO:
        FIND FIRST bfMab-model
             WHERE bfMab-model.cod-model = TTmab-model.cod-model:SCREEN-VALUE IN FRAME fPage0 NO-LOCK NO-ERROR.
        IF  AVAIL bfMab-model AND bfMab-model.log-cont-sec THEN
            ASSIGN TTmab-consu-model.val-consu-sec:SENSITIVE IN FRAME fPage0 = YES.
        ELSE
            ASSIGN TTmab-consu-model.val-consu-sec:SENSITIVE IN FRAME fPage0 = NO.
    END.
    ASSIGN TTmab-model.un:SENSITIVE IN FRAME fPage0 = NO
           cCodUnSec:SENSITIVE      IN FRAME fPage0 = NO.

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
           {&hDBOTable}:FILE-NAME <> "frbo/bofr006.p ":U THEN DO:
            RUN  frbo/bofr006.p PERSISTENT SET {&hDBOTable}.
    END.
    
    RUN openQueryStatic in {&hDBOTable} (input "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE (hDBOMfoModel) OR 
           hDBOMfoModel:TYPE <> "PROCEDURE":U OR
           hDBOMfoModel:FILE-NAME <> "frbo/bofr016.p ":U THEN DO:
            RUN  frbo/bofr016.p PERSISTENT SET hDBOMfoModel.
    END.
    
    RUN openQueryStatic in hDBOMfoModel (input "Main":U) NO-ERROR.

     /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE (hDBOTpMatl) OR 
           hDBOTpMatl:TYPE <> "PROCEDURE":U OR
           hDBOTpMatl:FILE-NAME <> "frbo/bofr026.p":U THEN DO:
            RUN  frbo/bofr026.p PERSISTENT SET hDBOTpMatl.
    END.
    
    RUN openQueryStatic in hDBOTpMatl (input "Main":U) NO-ERROR.

       /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE (hDBOAtivid) OR 
           hDBOAtivid:TYPE <> "PROCEDURE":U OR
           hDBOAtivid:FILE-NAME <> "frbo/bofr001.p":U THEN DO:
            RUN  frbo/bofr001.p PERSISTENT SET hDBOAtivid.
    END.
    
    RUN openQueryStatic in hDBOAtivid (input "Main":U) NO-ERROR.

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

