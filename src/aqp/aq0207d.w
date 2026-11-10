&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-produt-rural NO-UNDO LIKE produt-rural
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-reposit NO-UNDO LIKE reposit
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
{include/i-prgvrs.i AQ0207D 2.00.00.011 } /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AQ0207D MAQ}
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
&GLOBAL-DEFINE Program           AQ0207D
&GLOBAL-DEFINE Version        2.00.00.011

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-reposit
&GLOBAL-DEFINE hDBOTable         hDBOReposit
&GLOBAL-DEFINE DBOTable          reposit

&GLOBAL-DEFINE ttParent          tt-produt-rural
&GLOBAL-DEFINE hDBOParentTable   hDBOProdut-rural
&GLOBAL-DEFINE DBOParentTable    produt-rural

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-produt-rural.cdn-produt-rural
&GLOBAL-DEFINE page1Fields       tt-reposit.cod-pto-coleta tt-reposit.cdn-repos ~
                                 tt-reposit.des-reposit tt-reposit.qtd-capac ~
                                 tt-reposit.cod-marca tt-reposit.cod-modelo tt-reposit.log-livre-1~
                                 tt-reposit.cod-num-serie tt-reposit.des-obs tt-reposit.cod-barras
                                 

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}       AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOParentTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00966        AS HANDLE NO-UNDO.

DEFINE VARIABLE wh-pesquisa  AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl       AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-produt-rural.cdn-produt-rural 
&Scoped-define ENABLED-TABLES tt-produt-rural
&Scoped-define FIRST-ENABLED-TABLE tt-produt-rural
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar c-desc-produtor btOK btSave ~
btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-produt-rural.cdn-produt-rural 
&Scoped-define DISPLAYED-TABLES tt-produt-rural
&Scoped-define FIRST-DISPLAYED-TABLE tt-produt-rural
&Scoped-Define DISPLAYED-OBJECTS c-desc-produtor 

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

DEFINE VARIABLE c-desc-produtor AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE c-des-pto-coleta AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-produt-rural.cdn-produt-rural AT ROW 1.75 COL 18 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     c-desc-produtor AT ROW 1.75 COL 27.57 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     btOK AT ROW 17.67 COL 2
     btSave AT ROW 17.67 COL 13
     btCancel AT ROW 17.67 COL 24
     btHelp AT ROW 17.67 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 17.42 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.46
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tt-reposit.cod-pto-coleta AT ROW 1.17 COL 23 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-des-pto-coleta AT ROW 1.17 COL 37.29 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     tt-reposit.cdn-repos AT ROW 2.17 COL 23 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tt-reposit.des-reposit AT ROW 3.17 COL 23 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 42 BY .88
     tt-reposit.qtd-capac AT ROW 4.17 COL 23 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 15.29 BY .88
     tt-reposit.cod-marca AT ROW 5.17 COL 23 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 42 BY .88
     tt-reposit.cod-modelo AT ROW 6.17 COL 23 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 42 BY .88
     tt-reposit.cod-num-serie AT ROW 7.17 COL 23 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 42 BY .88
     tt-reposit.cod-barras AT ROW 8.17 COL 23.14 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 42 BY .88
     tt-reposit.log-livre-1 AT ROW 9.17 COL 25.14 HELP
          "L¢gico Livre 1" WIDGET-ID 24
          LABEL "Ativo"
          VIEW-AS TOGGLE-BOX
          SIZE 19.86 BY .83
     tt-reposit.des-obs AT ROW 10.04 COL 25 NO-LABEL WIDGET-ID 14
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 55 BY 3.04
     "Observa‡Æo:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 10.04 COL 15.86 WIDGET-ID 16
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.71
         SIZE 84.43 BY 12.54
         FONT 1 WIDGET-ID 200.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-produt-rural T "?" NO-UNDO mgind produt-rural
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-reposit T "?" NO-UNDO mgind reposit
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
         HEIGHT             = 18.46
         WIDTH              = 90
         MAX-HEIGHT         = 18.46
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 18.46
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR TOGGLE-BOX tt-reposit.log-livre-1 IN FRAME fPage1
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
     _Options          = "SHARE-LOCK KEEP-EMPTY"
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


&Scoped-define SELF-NAME tt-produt-rural.cdn-produt-rural
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-rural.cdn-produt-rural wMaintenanceNoNavigation
ON LEAVE OF tt-produt-rural.cdn-produt-rural IN FRAME fpage0 /* Produtor Rural */
DO:
    def var c-nome-emit  like emitente.nome-emit no-undo.
    DEF VAR c-return     AS CHAR   NO-UNDO.
    def var h-boad098    AS HANDLE NO-UNDO.
    
    assign input frame {&frame-name} tt-produt-rural.cdn-produt-rural.
    run adbo/boad098.p persistent set h-boad098.        
    run findCodigo in h-boad098(input tt-produt-rural.cdn-produt-rural, output c-return).
    if c-return = "" then do:
        run getCharfield in h-boad098(input "nome-emit", output c-nome-emit).
        assign c-desc-produtor:screen-value = c-nome-emit.
    end.
    delete procedure h-boad098.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-reposit.cod-pto-coleta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-reposit.cod-pto-coleta wMaintenanceNoNavigation
ON F5 OF tt-reposit.cod-pto-coleta IN FRAME fPage1 /* Ponto Coleta */
DO:
     {method/zoomfields.i 
       &ProgramZoom="inzoom/z01in00966.w"
       &FieldZoom1="cod-pto-coleta"
       &FieldScreen1="tt-reposit.cod-pto-coleta"
       &Frame1="fPage1"
       &FieldZoom2="des-pto-coleta"
       &FieldScreen2="c-des-pto-coleta"
       &Frame2="fPage1"
       &EnableImplant="YES"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-reposit.cod-pto-coleta wMaintenanceNoNavigation
ON LEAVE OF tt-reposit.cod-pto-coleta IN FRAME fPage1 /* Ponto Coleta */
DO:
   {method/ReferenceFields.i 
          &HandleDBOLeave="h-boin00966"
          &KeyValue1="tt-reposit.cod-pto-coleta:SCREEN-VALUE IN FRAME fPage1"
          &FieldName1="des-pto-coleta"
          &FieldScreen1="c-des-pto-coleta"
          &Frame1="fPage1"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-reposit.cod-pto-coleta wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-reposit.cod-pto-coleta IN FRAME fPage1 /* Ponto Coleta */
DO:
   APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-reposit.cod-pto-coleta:LOAD-MOUSE-POINTER("image/lupa.cur":U)     in frame fPage1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestoyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestoyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
    IF VALID-HANDLE(h-boin00966) THEN DO:
       DELETE PROCEDURE h-boin00966.
       ASSIGN h-boin00966 = ?.
    END.
    
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

    APPLY "LEAVE" TO tt-produt-rural.cdn-produt-rural IN FRAME fPage0.
    APPLY "LEAVE" TO tt-reposit.cod-pto-coleta IN FRAME fpage1.

    IF pcAction = "ADD":U THEN
        ASSIGN tt-reposit.log-livre-1:CHECKED IN FRAME fPage1 = YES.

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

    IF pcAction = "ADD" THEN
        ASSIGN tt-reposit.cdn-repos:sensitive in frame fPage1 = YES.
    
    IF pcAction = "UPDATE" THEN
        assign tt-reposit.cdn-repos:sensitive in frame fPage1 = NO.

    RUN execValidacaoProdutorPtoColeta IN {&hDBOTable} (INPUT YES,
                                                        INPUT int(tt-produt-rural.cdn-produt-rural:SCREEN-VALUE IN FRAME fPage0)).
               
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
---------------------------------------------------------------------------*/


    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParentTable}) OR
       {&hDBOParentTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOParentTable}:FILE-NAME <> "inbo/boin00962.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00962.p YES}
        {btb/btb008za.i2 inbo/boin00962.p '' {&hDBOParentTable}} 
    END.
    
    RUN openQueryStatic IN {&hDBOParentTable} (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR 
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "inbo/boin00984.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00984.p YES}
        {btb/btb008za.i2 inbo/boin00984.p '' {&hDBOTable}} 
    END.

    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    IF  NOT VALID-HANDLE(h-boin00966) THEN
        run inbo/boin00966.p persistent set h-boin00966.
    RUN openQueryStatic IN h-boin00966 (INPUT "Main":U) NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

