&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-eqpto-sub-sist NO-UNDO LIKE mab-eqpto-sub-sist
       field r-rowid as rowid.
DEFINE TEMP-TABLE TTmab-grp-eqpto NO-UNDO LIKE mab-grp-eqpto
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
{include/i-prgvrs.i AB0107B 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0107b MAB}
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
&GLOBAL-DEFINE Program            AB0107B
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       0

&GLOBAL-DEFINE FolderLabels     GrupXSub-Sist

&GLOBAL-DEFINE ttTable           TTmab-eqpto-sub-sist
&GLOBAL-DEFINE hDBOTable         hDBOGrpSubSist         
&GLOBAL-DEFINE DBOTable          mab-eqpto-sub-sist        

&GLOBAL-DEFINE ttParent          TTmab-grp-eqpto
&GLOBAL-DEFINE DBOParentTable    hDBOGrpEqpto

&GLOBAL-DEFINE page0KeyFields    TTmab-eqpto-sub-sist.cod-sub-sist   
&GLOBAL-DEFINE page0Fields       TTmab-eqpto-sub-sist.qti-max ~
                                 TTmab-eqpto-sub-sist.num-dias-antecip ~
                                 TTmab-eqpto-sub-sist.num-dias-estimad ~
                                 TTmab-eqpto-sub-sist.num-dias-gartia ~
                                 TTmab-eqpto-sub-sist.val-km-aviso ~
                                 TTmab-eqpto-sub-sist.val-km-hora-gartia ~
                                 TTmab-eqpto-sub-sist.val-uso-estimad
&GLOBAL-DEFINE page0ParentFields TTmab-grp-eqpto.cod-grp-eqpto ~
                                 TTmab-grp-eqpto.des-grp-eqpto 
                                  
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
DEFINE VARIABLE hDBOGrpEqpto    AS HANDLE NO-UNDO.
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
&Scoped-Define ENABLED-FIELDS TTmab-grp-eqpto.cod-grp-eqpto ~
TTmab-grp-eqpto.des-grp-eqpto TTmab-eqpto-sub-sist.cod-sub-sist ~
TTmab-eqpto-sub-sist.qti-max TTmab-eqpto-sub-sist.val-uso-estimad ~
TTmab-eqpto-sub-sist.val-km-aviso TTmab-eqpto-sub-sist.val-km-hora-gartia ~
TTmab-eqpto-sub-sist.num-dias-estimad TTmab-eqpto-sub-sist.num-dias-antecip ~
TTmab-eqpto-sub-sist.num-dias-gartia 
&Scoped-define ENABLED-TABLES TTmab-grp-eqpto TTmab-eqpto-sub-sist
&Scoped-define FIRST-ENABLED-TABLE TTmab-grp-eqpto
&Scoped-define SECOND-ENABLED-TABLE TTmab-eqpto-sub-sist
&Scoped-Define ENABLED-OBJECTS cDescSubSist btOK btSave btCancel btHelp ~
fi-durabilidade fi-antecipacao fi-estimado fi-garantia RECT-2 RECT-3 RECT-4 ~
RECT-5 rtKeys rtKeys-2 rtToolBar 
&Scoped-Define DISPLAYED-FIELDS TTmab-grp-eqpto.cod-grp-eqpto ~
TTmab-grp-eqpto.des-grp-eqpto TTmab-eqpto-sub-sist.cod-sub-sist ~
TTmab-eqpto-sub-sist.qti-max TTmab-eqpto-sub-sist.val-uso-estimad ~
TTmab-eqpto-sub-sist.val-km-aviso TTmab-eqpto-sub-sist.val-km-hora-gartia ~
TTmab-eqpto-sub-sist.num-dias-estimad TTmab-eqpto-sub-sist.num-dias-antecip ~
TTmab-eqpto-sub-sist.num-dias-gartia 
&Scoped-define DISPLAYED-TABLES TTmab-grp-eqpto TTmab-eqpto-sub-sist
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-grp-eqpto
&Scoped-define SECOND-DISPLAYED-TABLE TTmab-eqpto-sub-sist
&Scoped-Define DISPLAYED-OBJECTS cDescSubSist fi-durabilidade ~
fi-antecipacao fi-estimado fi-garantia 

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

DEFINE VARIABLE cDescSubSist AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE fi-antecipacao AS CHARACTER FORMAT "X(256)":U INITIAL "Antecipa‡Æo" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

DEFINE VARIABLE fi-durabilidade AS CHARACTER FORMAT "X(256)":U INITIAL "Durabilidade" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

DEFINE VARIABLE fi-estimado AS CHARACTER FORMAT "X(256)":U INITIAL "Uso Estimado" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE fi-garantia AS CHARACTER FORMAT "X(256)":U INITIAL "Garantia" 
      VIEW-AS TEXT 
     SIZE 6.43 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.83.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 24 BY 2.79.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 24 BY 2.79.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 24 BY 2.79.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.75.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     TTmab-grp-eqpto.cod-grp-eqpto AT ROW 1.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     TTmab-grp-eqpto.des-grp-eqpto AT ROW 2.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 38 BY .88
     TTmab-eqpto-sub-sist.cod-sub-sist AT ROW 4.33 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     cDescSubSist AT ROW 4.33 COL 28 COLON-ALIGNED NO-LABEL
     TTmab-eqpto-sub-sist.qti-max AT ROW 5.33 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     TTmab-eqpto-sub-sist.val-uso-estimad AT ROW 8 COL 22.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .79
     TTmab-eqpto-sub-sist.val-km-aviso AT ROW 8 COL 51 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .79
     TTmab-eqpto-sub-sist.val-km-hora-gartia AT ROW 8 COL 74.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .79
     TTmab-eqpto-sub-sist.num-dias-estimad AT ROW 9 COL 22.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .79
     TTmab-eqpto-sub-sist.num-dias-antecip AT ROW 9 COL 51.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .79
     TTmab-eqpto-sub-sist.num-dias-gartia AT ROW 9 COL 74.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.72 BY .79
     btOK AT ROW 11.04 COL 2
     btSave AT ROW 11.04 COL 13
     btCancel AT ROW 11.04 COL 24
     btHelp AT ROW 11.04 COL 80
     fi-durabilidade AT ROW 6.5 COL 3 NO-LABEL
     fi-antecipacao AT ROW 7.08 COL 38 COLON-ALIGNED NO-LABEL
     fi-estimado AT ROW 7.13 COL 11.14 COLON-ALIGNED NO-LABEL
     fi-garantia AT ROW 7.13 COL 64.57 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 6.83 COL 1
     RECT-3 AT ROW 7.42 COL 11.72
     RECT-4 AT ROW 7.42 COL 38.29
     RECT-5 AT ROW 7.42 COL 64.72
     rtKeys AT ROW 1 COL 1
     rtKeys-2 AT ROW 3.75 COL 1
     rtToolBar AT ROW 10.79 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 11.45
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: TTmab-eqpto-sub-sist T "?" NO-UNDO mgfro mab-eqpto-sub-sist
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: TTmab-grp-eqpto T "?" NO-UNDO mgfro mab-grp-eqpto
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
         HEIGHT             = 11.5
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
/* SETTINGS FOR FILL-IN fi-durabilidade IN FRAME fpage0
   ALIGN-L                                                              */
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


&Scoped-define SELF-NAME TTmab-eqpto-sub-sist.cod-sub-sist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-eqpto-sub-sist.cod-sub-sist wMaintenanceNoNavigation
ON LEAVE OF TTmab-eqpto-sub-sist.cod-sub-sist IN FRAME fpage0 /* Sub-Sistema */
DO:
  {method/ReferenceFields.i
        &HandleDBOLeave="hDBOSubSist"
        &KeyValue1="TTmab-eqpto-sub-sist.cod-sub-sist:SCREEN-VALUE IN FRAME fpage0"
        &FieldName1="des-sub-sist"
        &FieldScreen1="cDescSubSist"
        &Frame1="fpage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-eqpto-sub-sist.cod-sub-sist wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-eqpto-sub-sist.cod-sub-sist IN FRAME fpage0 /* Sub-Sistema */
OR F5 OF TTmab-eqpto-sub-sist.cod-sub-sist IN FRAME fPage0 DO:
     {method/zoomfields.i 
       &ProgramZoom="frzoom/z01fr025.w"
       &FieldZoom1="cod-sub-sist"
       &FieldScreen1="TTmab-eqpto-sub-sist.cod-sub-sist"
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


TTmab-eqpto-sub-sist.cod-sub-sist:load-mouse-pointer ("image/lupa.cur")  in frame fPage0.
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
IF VALID-HANDLE (hDBOGrpEqpto) THEN
       RUN destroy IN hDBOGrpEqpto.


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
FOR FIRST mab-sub-sist  FIELDS (des-sub-sist cod-sub-sist) WHERE 
    mab-sub-sist.cod-sub-sist = TTmab-eqpto-sub-sist.cod-sub-sist:SCREEN-VALUE IN FRAME fPage0 NO-LOCK:
    
    ASSIGN cDescSubSist:SCREEN-VALUE IN FRAME fPage0 = mab-sub-sist.des-sub-sist.
END.
 

IF pcAction = "Update":U THEN DO:
    ASSIGN  TTmab-eqpto-sub-sist.cod-sub-sist:SENSITIVE IN FRAME fPage0 = NO
            TTmab-eqpto-sub-sist.qti-max:SENSITIVE IN FRAME fPage0 = YES.
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
{utp/ut-liter.i Durabilidade}
ASSIGN fi-durabilidade:SCREEN-VALUE IN FRAME fpage0 = RETURN-VALUE.
{utp/ut-liter.i Uso_Estimado}
ASSIGN fi-estimado:SCREEN-VALUE IN FRAME fpage0 = RETURN-VALUE.
{utp/ut-liter.i Antecipa‡Æo}
ASSIGN fi-antecipacao:SCREEN-VALUE IN FRAME fpage0 = RETURN-VALUE.
{utp/ut-liter.i Garantia}
ASSIGN fi-garantia:SCREEN-VALUE IN FRAME fpage0 = RETURN-VALUE.
IF pcAction = "Update":U THEN DO:
    ASSIGN  TTmab-eqpto-sub-sist.cod-sub-sist:SENSITIVE IN FRAME fPage0 = NO
            TTmab-eqpto-sub-sist.qti-max:SENSITIVE IN FRAME fPage0 = YES.
END.

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
           {&hDBOTable}:FILE-NAME <> "frbo/bofr008.p ":U THEN DO:
            RUN  frbo/bofr008.p PERSISTENT SET {&hDBOTable}.
    END.
    
    RUN openQueryStatic in {&hDBOTable} (input "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE (hDBOGrpEqpto) OR 
           hDBOGrpEqpto:TYPE <> "PROCEDURE":U OR
           hDBOGrpEqpto:FILE-NAME <> "frbo/bofr011.p ":U THEN DO:
            RUN  frbo/bofr011.p PERSISTENT SET hDBOGrpEqpto.
    END.
    
    RUN openQueryStatic in hDBOGrpEqpto (input "Main":U) NO-ERROR.


   /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(hDBOSubSist) OR
       hDBOSubSist:TYPE <> "PROCEDURE":U OR
       hDBOSubSist:FILE-NAME <> "frbo/bofr025.p":U THEN DO:
        run "frbo/bofr025.p" persistent set hDBOSubSist.
    END.
    
    RUN openQueryStatic IN hDBOSubSist (INPUT "Main":U) NO-ERROR.

 


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
assign {&ttTable}.cod-grp-eqpto = {&ttParent}.cod-grp-eqpto.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

