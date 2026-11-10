&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-cot-ordem NO-UNDO LIKE mgcex.cot-ordem
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-desp-cot-ordem NO-UNDO LIKE mgcex.desp-cot-ordem
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
{include/i-prgvrs.i IM0015AD 2.00.00.007} /*** "010007" 21/03/2025 09:24:35  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0015AD MIM}
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
&GLOBAL-DEFINE Program           IM0015AD
&GLOBAL-DEFINE Version           2.00.00.007
&GLOBAL-DEFINE DBOVersion        1.1

&GLOBAL-DEFINE InitialPage       0

&GLOBAL-DEFINE ttTable           tt-desp-cot-ordem
&GLOBAL-DEFINE hDBOTable         h-bocx305
&GLOBAL-DEFINE DBOTable          desp-cot-ordem

&GLOBAL-DEFINE ttParent          tt-cot-ordem
&GLOBAL-DEFINE DBOParentTable    cot-ordem

&GLOBAL-DEFINE page0KeyFields    tt-desp-cot-ordem.cod-desp
&GLOBAL-DEFINE page0Fields       tt-desp-cot-ordem.cod-emitente-desp ~
                                 tt-desp-cot-ordem.nr-tab ~
                                 tt-desp-cot-ordem.mo-codigo
&GLOBAL-DEFINE page0ParentFields 
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

def var h-boun005 as handle no-undo.
def var h-bocx075 as handle no-undo.
def var h-bocx095 as handle no-undo.
def var wh-pesquisa     as handle no-undo.
def new global shared var adm-broker-hdl as handle no-undo.
def var c-return  as char   no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-desp-cot-ordem.cod-emitente-desp ~
tt-desp-cot-ordem.nr-tab tt-desp-cot-ordem.cod-desp ~
tt-desp-cot-ordem.mo-codigo 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-emitente-desp ~{&FP2}cod-emitente-desp ~{&FP3}~
 ~{&FP1}nr-tab ~{&FP2}nr-tab ~{&FP3}~
 ~{&FP1}cod-desp ~{&FP2}cod-desp ~{&FP3}~
 ~{&FP1}mo-codigo ~{&FP2}mo-codigo ~{&FP3}
&Scoped-define ENABLED-TABLES tt-desp-cot-ordem
&Scoped-define FIRST-ENABLED-TABLE tt-desp-cot-ordem
&Scoped-Define ENABLED-OBJECTS rtKeys c-moeda rtToolBar btOK btCancel ~
btsave btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-desp-cot-ordem.cod-emitente-desp ~
tt-desp-cot-ordem.nr-tab tt-desp-cot-ordem.cod-desp ~
tt-desp-cot-ordem.mo-codigo 
&Scoped-Define DISPLAYED-OBJECTS c-desc-emitente c-desc-tab c-desc-despesa ~
c-moeda 

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

DEFINE BUTTON btsave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-desc-despesa AS CHARACTER FORMAT "X(30)" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-emitente AS CHARACTER FORMAT "X(10)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tab AS CHARACTER FORMAT "X(30)" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 4.71.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-desp-cot-ordem.cod-emitente-desp AT ROW 1.25 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-desc-emitente AT ROW 1.25 COL 45.29 COLON-ALIGNED NO-LABEL
     tt-desp-cot-ordem.nr-tab AT ROW 2.25 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-desc-tab AT ROW 2.25 COL 45.43 COLON-ALIGNED NO-LABEL
     tt-desp-cot-ordem.cod-desp AT ROW 3.25 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-desc-despesa AT ROW 3.25 COL 42.43 COLON-ALIGNED NO-LABEL
     tt-desp-cot-ordem.mo-codigo AT ROW 4.25 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-moeda AT ROW 4.25 COL 40 COLON-ALIGNED NO-LABEL
     btOK AT ROW 5.92 COL 2
     btCancel AT ROW 5.92 COL 13
     btsave AT ROW 5.92 COL 24
     btHelp AT ROW 5.92 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 5.71 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 6.21
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-cot-ordem T "?" NO-UNDO mgcex cot-ordem
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-desp-cot-ordem T "?" NO-UNDO mgcex desp-cot-ordem
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
         HEIGHT             = 6.17
         WIDTH              = 90
         MAX-HEIGHT         = 16.33
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 16.33
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
ASSIGN 
       btsave:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-despesa IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-emitente IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-tab IN FRAME fpage0
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
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
    assign tt-cot-ordem.r-rowid = prParent.
    assign tt-desp-cot-ordem.cod-agrup  = tt-cot-ordem.cod-agrup
           tt-desp-cot-ordem.mapa-ordem = tt-cot-ordem.mapa-ordem.
    assign frame fPage0
           tt-desp-cot-ordem.cod-emitente-desp
           tt-desp-cot-ordem.nr-tab
           tt-desp-cot-ordem.cod-desp
           tt-desp-cot-ordem.mo-codigo.
    RUN validateCreateChave in h-bocx305 (input table tt-desp-cot-ordem,
                                          output table RowErrors).
    IF CAN-FIND(FIRST RowErrors) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN
            RUN utp/showmessage.w PERSISTENT SET hShowMsg.
        ELSE
            DELETE PROCEDURE hShowMsg.
        RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
        LEAVE.
    END.
    ELSE DO:
         RUN imp/im0015bd.w (input pcAction,
                             input tt-cot-ordem.mapa-ordem,
                             input tt-cot-ordem.cod-agrup,
                             input tt-desp-cot-ordem.cod-emitente-desp,
                             input tt-desp-cot-ordem.nr-tab,
                             input tt-desp-cot-ordem.cod-desp,
                             input tt-desp-cot-ordem.mo-codigo,
                             input prTable).
    END.
    
    RUN OpenQueriesSon in phCaller.
    
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btsave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btsave wMaintenanceNoNavigation
ON CHOOSE OF btsave IN FRAME fpage0 /* Salvar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-desp-cot-ordem.cod-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-cot-ordem.cod-desp wMaintenanceNoNavigation
ON F5 OF tt-desp-cot-ordem.cod-desp IN FRAME fpage0 /* C¢digo Despesa */
DO:
   {method/zoomfields.i 
     &ProgramZoom="cxzoom/z10cx095.w"
     &FieldZoom1="cod-desp"
     &FieldScreen1="tt-desp-cot-ordem.cod-desp"
     &Frame1="fpage0"
     &FieldZoom2="descricao"
     &FieldScreen2="c-desc-despesa"
     &Frame2="fpage0"} 
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-cot-ordem.cod-desp wMaintenanceNoNavigation
ON LEAVE OF tt-desp-cot-ordem.cod-desp IN FRAME fpage0 /* C¢digo Despesa */
DO:
    assign input frame fPage0 tt-desp-cot-ordem.cod-desp.
    
    {method/referencefields.i
    &HandleDBOLeave="h-bocx095"
    &FindMethod="findCodigo"
    &KeyValue1="tt-desp-cot-ordem.cod-desp"
    &FieldName1="descricao"
    &FieldScreen1="c-desc-despesa"
    &Frame1="fPage0"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-cot-ordem.cod-desp wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-desp-cot-ordem.cod-desp IN FRAME fpage0 /* C¢digo Despesa */
DO:
    apply "F5":U to self in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-desp-cot-ordem.cod-emitente-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-cot-ordem.cod-emitente-desp wMaintenanceNoNavigation
ON F5 OF tt-desp-cot-ordem.cod-emitente-desp IN FRAME fpage0 /* Fornec Despesa */
DO:
     {method/zoomfields.i 
     &ProgramZoom="adzoom/z10ad098.w"
     &FieldZoom1="cod-emitente"
     &FieldScreen1="tt-desp-cot-ordem.cod-emitente-desp"
     &Frame1="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-cot-ordem.cod-emitente-desp wMaintenanceNoNavigation
ON LEAVE OF tt-desp-cot-ordem.cod-emitente-desp IN FRAME fpage0 /* Fornec Despesa */
DO:
    def var c-nome-abrev like emitente.nome-abrev no-undo.
    def var h-boad098 as handle no-undo.
    
    assign input frame {&frame-name} tt-desp-cot-ordem.cod-emitente-desp.
    run adbo/boad098.p persistent set h-boad098.        
    run findCodigo in h-boad098(input tt-desp-cot-ordem.cod-emitente-desp, output c-return).
    if c-return = "" then do:
       run getCharfield in h-boad098(input "nome-abrev", output c-nome-abrev).
       assign c-desc-emitente:screen-value = c-nome-abrev.
    end.
    delete procedure h-boad098.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-cot-ordem.cod-emitente-desp wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-desp-cot-ordem.cod-emitente-desp IN FRAME fpage0 /* Fornec Despesa */
DO:
    apply "F5":U to self in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-desp-cot-ordem.mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-cot-ordem.mo-codigo wMaintenanceNoNavigation
ON F5 OF tt-desp-cot-ordem.mo-codigo IN FRAME fpage0 /* Moeda */
DO:
    {include/zoomvar.i 
     &prog-zoom="unzoom/z01un005.w"
     &campo="tt-desp-cot-ordem.mo-codigo"
     &campozoom="mo-codigo"
     &frame="fPage0"}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-cot-ordem.mo-codigo wMaintenanceNoNavigation
ON LEAVE OF tt-desp-cot-ordem.mo-codigo IN FRAME fpage0 /* Moeda */
DO:
    assign input frame fPage0 tt-desp-cot-ordem.mo-codigo.
    
    {method/referencefields.i
    &HandleDBOLeave="h-boun005"
    &FindMethod="findCodigo"
    &KeyValue1="tt-desp-cot-ordem.mo-codigo"
    &FieldName1="descricao"
    &FieldScreen1="c-moeda"
    &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-cot-ordem.mo-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-desp-cot-ordem.mo-codigo IN FRAME fpage0 /* Moeda */
DO:
    apply "F5":U to self in frame fPage0.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-desp-cot-ordem.nr-tab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-cot-ordem.nr-tab wMaintenanceNoNavigation
ON F5 OF tt-desp-cot-ordem.nr-tab IN FRAME fpage0 /* Tabela */
DO:
     {method/zoomfields.i 
     &ProgramZoom="cxzoom/z10cx075.w"
     &FieldZoom1="nr-tab"
     &FieldScreen1="tt-desp-cot-ordem.nr-tab"
     &Frame1="fPage0"
     &FieldZoom2="descricao"
     &FieldScreen2="c-desc-tab"
     &Frame2="fpage0"}       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-cot-ordem.nr-tab wMaintenanceNoNavigation
ON LEAVE OF tt-desp-cot-ordem.nr-tab IN FRAME fpage0 /* Tabela */
DO:
    assign input frame fPage0 tt-desp-cot-ordem.nr-tab.
    
    {method/referencefields.i
    &HandleDBOLeave="h-bocx075"
    &FindMethod="findCodigo-2"
    &KeyValue1="tt-desp-cot-ordem.nr-tab"
    &FieldName1="descricao"
    &FieldScreen1="c-desc-tab"
    &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-cot-ordem.nr-tab wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-desp-cot-ordem.nr-tab IN FRAME fpage0 /* Tabela */
DO:
    apply "F5":U to self in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
    tt-desp-cot-ordem.cod-emitente-desp:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage0.
    tt-desp-cot-ordem.cod-desp:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage0.
    tt-desp-cot-ordem.nr-tab:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage0.
    tt-desp-cot-ordem.mo-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U)
    IN FRAME fPage0.
{maintenancenonavigation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyinterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if valid-handle(h-boun005) then
        delete procedure h-boun005.
    
    if valid-handle(h-bocx095) then
        delete procedure h-bocx075.
            
    if valid-handle(h-bocx095) then
        delete procedure h-bocx095.    
        
    RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    def var i-cod-desp like desp-imp.cod-desp no-undo.
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) THEN DO:
        RUN cxbo/bocx305.p persistent set h-bocx305.
    END.
    
    RUN unbo/boun005.p persistent set h-boun005.
    RUN cxbo/bocx075.p persistent set h-bocx075.
    RUN cxbo/bocx095.p persistent set h-bocx095.

    RETURN "OK":U.
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

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


