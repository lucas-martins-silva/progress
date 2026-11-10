&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-motoris NO-UNDO LIKE mab-motoris
       field r-rowid as rowid.
DEFINE TEMP-TABLE TTmab-motoris-model NO-UNDO LIKE mab-motoris-model
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
{include/i-prgvrs.i AB0111B 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0111b MAB}
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
&GLOBAL-DEFINE Program          AB0111B
&GLOBAL-DEFINE Version          2.00.00.000

&GLOBAL-DEFINE Folder          NO
&GLOBAL-DEFINE InitialPage     0

&GLOBAL-DEFINE FolderLabels     Modelo

&GLOBAL-DEFINE ttTable          TTmab-motoris-model
&GLOBAL-DEFINE hDBOTable        hDBOMotorisModel
&GLOBAL-DEFINE DBOTable         mab-motoris-model

&GLOBAL-DEFINE ttParent         TTmab-motoris
&GLOBAL-DEFINE DBOParentTable   hDBOMotoris

&GLOBAL-DEFINE page0KeyFields  TTmab-motoris-model.cod-model ~    
&GLOBAL-DEFINE page0Fields     TTmab-motoris-model.dat-inicial ~
                               TTmab-motoris-model.dat-final

&GLOBAL-DEFINE page0ParentFields TTmab-motoris.ep-codigo TTmab-motoris.cod-estabel ~
                                 TTmab-motoris.cod-matr ~
                                 TTmab-motoris.nom-motoris 
                                
                                  
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
DEFINE VARIABLE  hDBOMotoris  AS HANDLE NO-UNDO.
DEFINE VARIABLE  hDBOModel    AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS TTmab-motoris.ep-codigo ~
TTmab-motoris.cod-estabel TTmab-motoris.cod-matr TTmab-motoris.nom-motoris ~
TTmab-motoris-model.cod-model TTmab-motoris-model.dat-inicial ~
TTmab-motoris-model.dat-final 
&Scoped-define ENABLED-TABLES TTmab-motoris TTmab-motoris-model
&Scoped-define FIRST-ENABLED-TABLE TTmab-motoris
&Scoped-define SECOND-ENABLED-TABLE TTmab-motoris-model
&Scoped-Define ENABLED-OBJECTS RECT-27 rtKeys rtKeys-2 rtToolBar ~
fiDesEmpresa fiDesEstab cDescModel btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS TTmab-motoris.ep-codigo ~
TTmab-motoris.cod-estabel TTmab-motoris.cod-matr TTmab-motoris.nom-motoris ~
TTmab-motoris-model.cod-model TTmab-motoris-model.dat-inicial ~
TTmab-motoris-model.dat-final 
&Scoped-define DISPLAYED-TABLES TTmab-motoris TTmab-motoris-model
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-motoris
&Scoped-define SECOND-DISPLAYED-TABLE TTmab-motoris-model
&Scoped-Define DISPLAYED-OBJECTS fiDesEmpresa fiDesEstab cDescModel 

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

DEFINE VARIABLE cDescModel AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE fiDesEmpresa AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE fiDesEstab AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40 BY 2.5.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.5.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 4.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     TTmab-motoris.ep-codigo AT ROW 1.25 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     fiDesEmpresa AT ROW 1.25 COL 31 COLON-ALIGNED NO-LABEL
     fiDesEstab AT ROW 2.17 COL 31 COLON-ALIGNED NO-LABEL
     TTmab-motoris.cod-estabel AT ROW 2.21 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     TTmab-motoris.cod-matr AT ROW 3.13 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-motoris.nom-motoris AT ROW 3.13 COL 32 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 40 BY .88
     TTmab-motoris-model.cod-model AT ROW 4.75 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cDescModel AT ROW 4.75 COL 30 COLON-ALIGNED NO-LABEL
     TTmab-motoris-model.dat-inicial AT ROW 6.58 COL 44.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-motoris-model.dat-final AT ROW 7.54 COL 44.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     btOK AT ROW 9.17 COL 2
     btSave AT ROW 9.17 COL 13
     btCancel AT ROW 9.17 COL 24
     btHelp AT ROW 9.17 COL 80
     "Per¡odo de Habilita‡Æo" VIEW-AS TEXT
          SIZE 17 BY .54 AT ROW 5.96 COL 24
     RECT-27 AT ROW 6.21 COL 22
     rtKeys AT ROW 1 COL 1
     rtKeys-2 AT ROW 4.5 COL 1
     rtToolBar AT ROW 8.92 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 9.38
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: TTmab-motoris T "?" NO-UNDO mgfro mab-motoris
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: TTmab-motoris-model T "?" NO-UNDO mgfro mab-motoris-model
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
         HEIGHT             = 9.75
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


&Scoped-define SELF-NAME TTmab-motoris.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-motoris.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF TTmab-motoris.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
       {include~/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=fiDesEstab
                   &where="estabelec.cod-estabel = input frame fPage0 {&ttParent}.cod-estabel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-motoris-model.cod-model
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-motoris-model.cod-model wMaintenanceNoNavigation
ON LEAVE OF TTmab-motoris-model.cod-model IN FRAME fpage0 /* Modelo */
DO:
   {method/ReferenceFields.i
        &HandleDBOLeave="hDBOModel"
        &KeyValue1="TTmab-motoris-model.cod-model:SCREEN-VALUE IN FRAME fpage0"
        &FieldName1="des-model"
        &FieldScreen1="cDescModel"
        &Frame1="fpage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-motoris-model.cod-model wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-motoris-model.cod-model IN FRAME fpage0 /* Modelo */
OR F5 OF TTmab-motoris-model.cod-model IN FRAME fPage0 DO:
   {method/zoomfields.i 
     &ProgramZoom="frzoom~\z01fr016.w"
     &FieldZoom1="cod-model"
     &FieldScreen1="TTmab-motoris-model.cod-model"
     &Frame1="fPage0"
     &FieldZoom2="des-model"
     &FieldScreen2="cDescModel"
     &Frame2="fPage0"
     &EnableImplant="yes"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-motoris.ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-motoris.ep-codigo wMaintenanceNoNavigation
ON LEAVE OF TTmab-motoris.ep-codigo IN FRAME fpage0 /* Empresa */
DO:
    {include~/leave.i &tabela=empresa
                   &atributo-ref=nome
                   &variavel-ref=fiDesEmpresa
                   &where="empresa.ep-codigo = input frame fPage0 {&ttParent}.ep-codigo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


TTmab-motoris-model.cod-model:load-mouse-pointer ("image/lupa.cur")  in frame fPage0.
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
IF VALID-HANDLE (hDBOMotoris) THEN
       RUN destroy IN hDBOMotoris.

IF VALID-HANDLE (hDBOModel) THEN
       RUN destroy IN hDBOModel.


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
 APPLY "LEAVE":U TO  {&ttParent}.ep-codigo IN FRAME fpage0.
 APPLY "LEAVE":U TO  {&ttParent}.cod-estabel IN FRAME fpage0.
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
 /*FOR FIRST ITEM FIELDS(it-codigo  desc-item)
       WHERE item.it-codigo = TTmab-tip-mater-item.it-codigo:SCREEN-VALUE IN FRAME fPage1 NO-LOCK:
       ASSIGN cDescItem:SCREEN-VALUE IN FRAME fPage1 = item.desc-item.
   END. 
  RETURN "OK":U.*/

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
           {&hDBOTable}:FILE-NAME <> "frbo~\bofr018.p ":U THEN DO:
            RUN  frbo~/bofr018.p PERSISTENT SET {&hDBOTable}.
    END.
    
    RUN openQueryStatic in {&hDBOTable} (input "Main":U) NO-ERROR.


    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE (hDBOMotoris) OR 
          hDBOMotoris:TYPE <> "PROCEDURE":U OR
          hDBOMotoris:FILE-NAME <> "frbo~\bofr017.p ":U THEN DO:
            RUN  frbo~/bofr017.p PERSISTENT SET hDBOMotoris.
    END.
    
    RUN openQueryStatic in hDBOMotoris (input "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE (hDBOModel) OR 
           hDBOModel:TYPE <> "PROCEDURE":U OR
           hDBOModel:FILE-NAME <> "frbo~\bofr016.p ":U THEN DO:
            RUN  frbo~/bofr016.p PERSISTENT SET hDBOModel.
    END.
    
    RUN openQueryStatic in hDBOModel (input "Main":U) NO-ERROR.

   


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

assign {&ttTable}.ep-codigo = {&ttParent}.ep-codigo.
       {&ttTable}.cod-estabel = {&ttParent}.cod-estabel.
       {&ttTable}.cod-matr = {&ttParent}.cod-matr.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

