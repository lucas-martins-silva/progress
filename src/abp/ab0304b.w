&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movfro           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-viagem NO-UNDO LIKE mab-viagem
       field r-rowid as rowid.
DEFINE TEMP-TABLE TTmab-viagem-implto NO-UNDO LIKE mab-viagem-implto
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
{include/i-prgvrs.i AB0304B 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0304b MAB}
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
&GLOBAL-DEFINE Program          AB0304B
&GLOBAL-DEFINE Version          2.00.00.001

&GLOBAL-DEFINE Folder          NO
&GLOBAL-DEFINE InitialPage     0

&GLOBAL-DEFINE FolderLabels     

&GLOBAL-DEFINE ttTable          TTmab-viagem-implto
&GLOBAL-DEFINE hDBOTable        hDBOViagemImpl
&GLOBAL-DEFINE DBOTable         mab-viagem-implto

&GLOBAL-DEFINE ttParent         TTmab-viagem
&GLOBAL-DEFINE DBOParentTable   hDBOViagem

&GLOBAL-DEFINE page0KeyFields  TTmab-viagem-implto.ep-codigo ~
                               TTmab-viagem-implto.cod-eqpto
&GLOBAL-DEFINE page0Fields     

&GLOBAL-DEFINE page0ParentFields TTmab-viagem.num-viagem
                                
                                  
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
DEFINE VARIABLE  hDBOViagem   AS HANDLE NO-UNDO.
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
&Scoped-Define ENABLED-FIELDS TTmab-viagem.num-viagem ~
TTmab-viagem-implto.ep-codigo TTmab-viagem-implto.cod-eqpto 
&Scoped-define ENABLED-TABLES TTmab-viagem TTmab-viagem-implto
&Scoped-define FIRST-ENABLED-TABLE TTmab-viagem
&Scoped-define SECOND-ENABLED-TABLE TTmab-viagem-implto
&Scoped-define DISPLAYED-TABLES TTmab-viagem TTmab-viagem-implto
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-viagem
&Scoped-define SECOND-DISPLAYED-TABLE TTmab-viagem-implto
&Scoped-Define ENABLED-OBJECTS cDescEmp cDescEqpto btOK btSave btCancel ~
btHelp rtKeys rtKeys-2 rtToolBar 
&Scoped-Define DISPLAYED-FIELDS TTmab-viagem.num-viagem ~
TTmab-viagem-implto.ep-codigo TTmab-viagem-implto.cod-eqpto 
&Scoped-Define DISPLAYED-OBJECTS cDescEmp cDescEqpto 

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

DEFINE VARIABLE cDescEmp AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE cDescEqpto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.5.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     TTmab-viagem.num-viagem AT ROW 2 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-viagem-implto.ep-codigo AT ROW 3.79 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cDescEmp AT ROW 3.79 COL 31 COLON-ALIGNED NO-LABEL
     TTmab-viagem-implto.cod-eqpto AT ROW 4.75 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     cDescEqpto AT ROW 4.75 COL 37 COLON-ALIGNED NO-LABEL
     btOK AT ROW 6.79 COL 2
     btSave AT ROW 6.79 COL 13
     btCancel AT ROW 6.79 COL 24
     btHelp AT ROW 6.79 COL 80
     rtKeys AT ROW 1 COL 1
     rtKeys-2 AT ROW 3.5 COL 1
     rtToolBar AT ROW 6.54 COL 1
     "Documento Viagem:" VIEW-AS TEXT
          SIZE 14 BY .54 AT ROW 2.17 COL 8.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 7.21
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: TTmab-viagem T "?" NO-UNDO movfro mab-viagem
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: TTmab-viagem-implto T "?" NO-UNDO movfro mab-viagem-implto
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
         TITLE              = "Manuten‡Æo dos Implemetos do Controle de Viagem"
         HEIGHT             = 7.17
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
ON END-ERROR OF wMaintenanceNoNavigation /* Manuten‡Æo dos Implemetos do Controle de Viagem */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation /* Manuten‡Æo dos Implemetos do Controle de Viagem */
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


&Scoped-define SELF-NAME TTmab-viagem-implto.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem-implto.cod-eqpto wMaintenanceNoNavigation
ON F5 OF TTmab-viagem-implto.cod-eqpto IN FRAME fpage0 /* Equipamento */
DO:
  {method/ZoomFields.i
           &ProgramZoom="frzoom~\z01fr007.w"
           &FieldZoom1="cod-eqpto"
           &FieldScreen1=" TTmab-viagem-implto.cod-eqpto"
           &Frame1="fPage0"
           &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem-implto.cod-eqpto wMaintenanceNoNavigation
ON LEAVE OF TTmab-viagem-implto.cod-eqpto IN FRAME fpage0 /* Equipamento */
DO:
  FOR FIRST mab-eqpto FIELDS (ep-codigo cod-eqpto cod-model)
         WHERE mab-eqpto.ep-codigo = INPUT FRAME fPage0 TTmab-viagem-implto.ep-codigo  
         AND   mab-eqpto.cod-eqpto = INPUT FRAME fPage0 TTmab-viagem-implto.cod-eqpto, 
         EACH mab-model FIELDS (cod-model des-model)
              WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:
              ASSIGN cDescEqpto = mab-model.des-model.
              DISP cDescEqpto WITH FRAME fPage0.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem-implto.cod-eqpto wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-viagem-implto.cod-eqpto IN FRAME fpage0 /* Equipamento */
DO:
   apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-viagem-implto.ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem-implto.ep-codigo wMaintenanceNoNavigation
ON F5 OF TTmab-viagem-implto.ep-codigo IN FRAME fpage0 /* Empresa */
DO:
   {method/ZoomFields.i
           &ProgramZoom="frzoom~\z01fr007.w"
           &FieldZoom1="ep-codigo"
           &FieldScreen1="TTmab-viagem-implto.ep-codigo"
           &Frame1="fPage0"
           &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem-implto.ep-codigo wMaintenanceNoNavigation
ON LEAVE OF TTmab-viagem-implto.ep-codigo IN FRAME fpage0 /* Empresa */
DO:
  FOR FIRST empresa FIELDS (ep-codigo nome) 
               WHERE empresa.ep-codigo = INPUT FRAME fPage0 TTmab-viagem-implto.ep-codigo NO-lock:
              ASSIGN cDescEmp = empresa.nome.
              
                DISP cDescEmp WITH FRAME fPage0.
END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem-implto.ep-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-viagem-implto.ep-codigo IN FRAME fpage0 /* Empresa */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


TTmab-viagem-implto.ep-codigo:load-mouse-pointer ("image/lupa.cur")  in frame fPage0.
TTmab-viagem-implto.cod-eqpto:load-mouse-pointer ("image/lupa.cur")  in frame fPage0.
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
IF VALID-HANDLE (hDBOViagem) THEN
       RUN destroy IN hDBOViagem.

IF VALID-HANDLE (hDBOModel) THEN
       RUN destroy IN hDBOModel.


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
 FOR FIRST mab-eqpto FIELDS (ep-codigo cod-eqpto cod-model)
         WHERE mab-eqpto.ep-codigo = INPUT FRAME fPage0 TTmab-viagem-implto.ep-codigo
         AND   mab-eqpto.cod-eqpto = INPUT FRAME fPage0 TTmab-viagem-implto.cod-eqpto,
         EACH mab-model FIELDS (cod-model des-model)
              WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:
              ASSIGN cDescEqpto = mab-model.des-model.
              DISP cDescEqpto WITH FRAME fPage0.
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
           {&hDBOTable}:FILE-NAME <> "frbo~\bofr065.p ":U THEN DO:
            RUN  frbo/bofr065.p PERSISTENT SET {&hDBOTable}.
    END.
    
    RUN openQueryStatic in {&hDBOTable} (input "Main":U) NO-ERROR.


    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE (hDBOViagem) OR 
         hDBOViagem:TYPE <> "PROCEDURE":U OR
         hDBOViagem:FILE-NAME <> "frbo~\bofr064.p ":U THEN DO:
            RUN  frbo/bofr064.p PERSISTENT SET hDBOViagem.
    END.
    
    RUN openQueryStatic in hDBOViagem (input "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE (hDBOModel) OR 
           hDBOModel:TYPE <> "PROCEDURE":U OR
           hDBOModel:FILE-NAME <> "frbo~\bofr016.p ":U THEN DO:
            RUN  frbo/bofr016.p PERSISTENT SET hDBOModel.
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

assign {&ttTable}.num-viagem = {&ttParent}.num-viagem.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

