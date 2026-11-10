&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-produt-pto-coleta NO-UNDO LIKE produt-pto-coleta
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-produt-rural NO-UNDO LIKE produt-rural
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-pto-coleta NO-UNDO LIKE pto-coleta
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
{include/i-prgvrs.i AQ0207C 2.00.00.017 } /*** 010017 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AQ0207C MAQ}
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
&GLOBAL-DEFINE Program           AQ0207C
&GLOBAL-DEFINE Version        2.00.00.017

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-pto-coleta
&GLOBAL-DEFINE hDBOTable         hDBOPto-coleta
&GLOBAL-DEFINE DBOTable          pto-coleta

&GLOBAL-DEFINE ttParent          tt-produt-rural
&GLOBAL-DEFINE hDBOParentTable   hDBOProdut-rural
&GLOBAL-DEFINE DBOParentTable    produt-rural

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-produt-rural.cdn-produt-rural
&GLOBAL-DEFINE page1Fields       tt-pto-coleta.cod-pto-coleta tt-pto-coleta.des-pto-coleta ~
                                 tt-pto-coleta.cod-propried tt-pto-coleta.cod-regiao ~
                                 tt-pto-coleta.val-media tt-pto-coleta.qtd-distan-km ~
                                 tt-pto-coleta.cod-un ~
                                 tt-pto-coleta.val-latitude tt-pto-coleta.val-longitude ~
                                 tt-pto-coleta.des-obs c-cod-externo tt-pto-coleta.log-livre-1

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOParentTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00990  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin122    AS HANDLE NO-UNDO.   
DEFINE VARIABLE h-boin417na  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00980  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00977  AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-text      AS HANDLE NO-UNDO.

DEFINE VARIABLE l-log-livre-1 LIKE tt-pto-coleta.log-livre-1 NO-UNDO. /*pto-coleta desativado*/

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

DEFINE VARIABLE c-cod-externo LIKE produt-pto-coleta.cod-externo
     LABEL "C¢digo Externo" 
     VIEW-AS FILL-IN 
     SIZE 15.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-propried AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-regiao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-un AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.72 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-produt-rural.cdn-produt-rural AT ROW 1.75 COL 18 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     c-desc-produtor AT ROW 1.75 COL 27.57 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     btOK AT ROW 16.63 COL 2
     btSave AT ROW 16.63 COL 13
     btCancel AT ROW 16.63 COL 24
     btHelp AT ROW 16.63 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 16.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fpage1
     tt-pto-coleta.cod-pto-coleta AT ROW 1.5 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.29 BY .88
     tt-pto-coleta.des-pto-coleta AT ROW 1.5 COL 32.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 38.86 BY .88
     tt-pto-coleta.cod-propried AT ROW 2.54 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.29 BY .88
     c-desc-propried AT ROW 2.54 COL 32.29 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     tt-pto-coleta.cod-regiao AT ROW 3.58 COL 12.72 COLON-ALIGNED WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-desc-regiao AT ROW 3.58 COL 25.57 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     tt-pto-coleta.val-media AT ROW 4.58 COL 12.72 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 15.29 BY .88
     tt-pto-coleta.cod-un AT ROW 4.58 COL 41 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .88
     c-desc-un AT ROW 4.58 COL 46.57 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     tt-pto-coleta.qtd-distan-km AT ROW 5.58 COL 13 COLON-ALIGNED WIDGET-ID 12
          LABEL "Distƒncia KM"
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     tt-pto-coleta.val-latitude AT ROW 6.58 COL 12.86 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 11.14 BY .88
     tt-pto-coleta.val-longitude AT ROW 6.58 COL 41 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .88
     c-cod-externo AT ROW 7.58 COL 12.86 COLON-ALIGNED HELP
          "C¢digo Externo" WIDGET-ID 38
          LABEL "C¢digo Externo"
     tt-pto-coleta.log-livre-1 AT ROW 8.58 COL 14.86 HELP
          "" WIDGET-ID 40
          LABEL "Ativo"
          VIEW-AS TOGGLE-BOX
          SIZE 20.14 BY .83
     tt-pto-coleta.des-obs AT ROW 9.58 COL 14.86 NO-LABEL WIDGET-ID 20
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 66.29 BY 3.21
     "Observa‡Æo:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 9.58 COL 5.72 WIDGET-ID 30
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 12.08
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-produt-pto-coleta T "?" NO-UNDO mgind produt-pto-coleta
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-produt-rural T "?" NO-UNDO mgind produt-rural
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-pto-coleta T "?" NO-UNDO mgind pto-coleta
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
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 18.33
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 18.33
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
ASSIGN FRAME fpage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fpage1
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-externo IN FRAME fpage1
   LIKE = mgind.produt-pto-coleta.cod-externo EXP-LABEL EXP-SIZE        */
/* SETTINGS FOR TOGGLE-BOX tt-pto-coleta.log-livre-1 IN FRAME fpage1
   EXP-LABEL EXP-HELP                                                   */
/* SETTINGS FOR FILL-IN tt-pto-coleta.qtd-distan-km IN FRAME fpage1
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage1
/* Query rebuild information for FRAME fpage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage1 */
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


&Scoped-define FRAME-NAME fpage1
&Scoped-define SELF-NAME tt-pto-coleta.cod-propried
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-propried wMaintenanceNoNavigation
ON F5 OF tt-pto-coleta.cod-propried IN FRAME fpage1 /* Propriedade */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z01in00980.w"
                       &FieldZoom1="cod-propried"
                       &FieldScreen1="tt-pto-coleta.cod-propried"
                       &Frame1="fpage1"
                       &FieldZoom2="des-propried"
                       &FieldScreen2="c-desc-propried"
                       &Frame2="fpage1"
                       &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-propried wMaintenanceNoNavigation
ON LEAVE OF tt-pto-coleta.cod-propried IN FRAME fpage1 /* Propriedade */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-boin00980"
      &KeyValue1="tt-pto-coleta.cod-propried:SCREEN-VALUE IN FRAME fPage1"
      &FieldName1="des-propried"
      &FieldScreen1="c-desc-propried"
      &Frame1="fPage1"}
      
     RUN pi-busca-regiao-propriedade IN THIS-PROCEDURE.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-propried wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-pto-coleta.cod-propried IN FRAME fpage1 /* Propriedade */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-pto-coleta.cod-regiao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-regiao wMaintenanceNoNavigation
ON F5 OF tt-pto-coleta.cod-regiao IN FRAME fpage1 /* RegiÆo */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z01in00977.w"
                       &FieldZoom1="cod-regiao"
                       &FieldScreen1="tt-pto-coleta.cod-regiao"
                       &Frame1="fpage1"
                       &FieldZoom2="nom-regiao"
                       &FieldScreen2="c-desc-regiao"
                       &Frame2="fpage1"
                       &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-regiao wMaintenanceNoNavigation
ON LEAVE OF tt-pto-coleta.cod-regiao IN FRAME fpage1 /* RegiÆo */
DO:
   
    {method/referencefields.i 
      &HandleDBOLeave="h-boin00977"
      &KeyValue1="tt-pto-coleta.cod-regiao:SCREEN-VALUE IN FRAME fPage1"
      &FieldName1="nom-regiao"
      &FieldScreen1="c-desc-regiao"
      &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-regiao wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-pto-coleta.cod-regiao IN FRAME fpage1 /* RegiÆo */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-pto-coleta.cod-un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-un wMaintenanceNoNavigation
ON F5 OF tt-pto-coleta.cod-un IN FRAME fpage1 /* UN */
DO:
    ASSIGN l-implanta = NO.
    {include/zoomvar.i &prog-zoom="inzoom/z01in417.w"
                       &campo=tt-pto-coleta.cod-un
                       &campozoom=un
                       &FRAME="fpage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-un wMaintenanceNoNavigation
ON LEAVE OF tt-pto-coleta.cod-un IN FRAME fpage1 /* UN */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-boin417na"
      &KeyValue1="tt-pto-coleta.cod-un:SCREEN-VALUE IN FRAME fPage1"
      &FieldName1="descricao"
      &FieldScreen1="c-desc-un"
      &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-un wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-pto-coleta.cod-un IN FRAME fpage1 /* UN */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-pto-coleta.cod-propried:LOAD-MOUSE-POINTER("image/lupa.cur":U)     in frame fPage1.
tt-pto-coleta.cod-regiao:LOAD-MOUSE-POINTER("image/lupa.cur":U)       in frame fPage1.
tt-pto-coleta.cod-un:LOAD-MOUSE-POINTER("image/lupa.cur":U)           in frame fPage1.

{utp/ut-liter.i "Distƒncia_KM" *}
ASSIGN wh-text = tt-pto-coleta.qtd-distan-km:SIDE-LABEL-HANDLE
       wh-text:SCREEN-VALUE = RETURN-VALUE
       tt-pto-coleta.qtd-distan-km:COLUMN IN FRAME fpage1 = 14.86
       wh-text:COL = tt-pto-coleta.qtd-distan-km:COLUMN IN FRAME fpage1 - wh-text:WIDTH.

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
    IF VALID-HANDLE(h-boin122) THEN DO:
       DELETE PROCEDURE h-boin122.
       ASSIGN h-boin122 = ?.
    END.

    IF VALID-HANDLE(h-boin417na) THEN DO:
       DELETE PROCEDURE h-boin417na.
       ASSIGN h-boin417na = ?.
    END.

    IF VALID-HANDLE(h-boin00980) THEN DO:
       DELETE PROCEDURE h-boin00980.
       ASSIGN h-boin00980 = ?.
    END.

    IF VALID-HANDLE(h-boin00977) THEN DO:
       DELETE PROCEDURE h-boin00977.
       ASSIGN h-boin00977 = ?.
    END.
    
    IF VALID-HANDLE(h-boin00990) THEN DO:
       DELETE PROCEDURE h-boin00990.
       ASSIGN h-boin00990 = ?.
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
    DEF VAR c-ret AS CHAR NO-UNDO.

    IF pcAction = "ADD":U THEN 
        ASSIGN tt-pto-coleta.log-livre-1:CHECKED IN FRAME fPage1 = YES.

    APPLY "LEAVE" TO tt-produt-rural.cdn-produt-rural IN FRAME fPage0.
    APPLY "LEAVE" TO tt-pto-coleta.cod-propried       IN FRAME fpage1.
    APPLY "LEAVE" TO tt-pto-coleta.cod-regiao         IN FRAME fpage1.
    APPLY "LEAVE" TO tt-pto-coleta.cod-un             IN FRAME fpage1.
    
    IF AVAIL {&ttParent}   AND
       AVAIL tt-pto-coleta AND
       VALID-HANDLE(h-boin00990) THEN DO:

        RUN gotokey IN h-boin00990(INPUT {&ttParent}.cdn-produt-rural,
                                   INPUT tt-pto-coleta.cod-pto-coleta:SCREEN-VALUE IN FRAME fPage1,
                                   INPUT tt-pto-coleta.cod-propried:SCREEN-VALUE IN FRAME fPage1).
        
        IF RETURN-VALUE = "OK" THEN
            RUN getCharField IN h-boin00990 (INPUT "cod-externo":U, OUTPUT c-ret).
        
        ASSIGN c-cod-externo:SCREEN-VALUE IN FRAME fpage1 = c-ret
               l-log-livre-1                              = tt-pto-coleta.log-livre-1. /*confere desativação para disparar processo caso mude o flag*/
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

    IF pcAction = "ADD" THEN
        ASSIGN tt-pto-coleta.cod-pto-coleta:sensitive in frame fPage1 = YES
               tt-pto-coleta.des-pto-coleta:sensitive in frame fPage1 = YES
               tt-pto-coleta.log-livre-1:checked      in frame fPage1 = YES.
    
    IF pcAction = "UPDATE" THEN
        assign tt-pto-coleta.cod-pto-coleta:sensitive in frame fPage1 = NO      
               tt-pto-coleta.cod-propried:sensitive in frame fPage1 = NO.

    ASSIGN tt-pto-coleta.cod-regiao:sensitive     in frame fPage1 = NO.

               
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

    DEFINE VARIABLE h-aqapi005 AS HANDLE  NO-UNDO.
    DEFINE VARIABLE rRowid     AS ROWID   NO-UNDO.
    DEFINE VARIABLE iSituacao  AS INTEGER NO-UNDO.

    RUN aqp/aqapi005.p PERSISTENT SET h-aqapi005.
    
    IF l-log-livre-1 <> tt-pto-coleta.log-livre-1 THEN DO:

        IF VALID-HANDLE ({&hDBOTable}) THEN
            RUN getRowid IN {&hDBOTable} (OUTPUT rRowid).

            IF NOT tt-pto-coleta.log-livre-1 THEN DO: /*desativou pto-coleta*/

                RUN piInicial IN h-aqapi005 (INPUT  "desativar":U,
                                             INPUT  "pontoDeColeta":U,
                                             INPUT  rRowid,
                                             OUTPUT iSituacao,
                                             INPUT-OUTPUT TABLE rowErrors).

                IF RETURN-VALUE = "NOK":U THEN /*ocorreu algum erro e não desativou os cadastros*/

                    RUN piInicial IN h-aqapi005 (INPUT  "ativar":U,
                                                 INPUT  "pontoDeColeta":U,
                                                 INPUT  rRowid,
                                                 OUTPUT iSituacao,
                                                 INPUT-OUTPUT TABLE rowErrors).

            END.

    END.

    IF  h-aqapi005 <> ? THEN DO:
        DELETE PROCEDURE h-aqapi005.
        ASSIGN h-aqapi005 = ?.    
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenanceNoNavigation 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
       CONSTRAINT PARA CRIA€ÇO DO RELACIONAMENTO PRODUT-PTO-COLETA.
       ESSE RELACIONAMENTO SERA CRIADO NO METODO afterCreateRecord OU 
       ATUALIZADO PELO METODO afterUpdateRecord DO BOIN00966 
     */
    RUN setConstraintProdutPtoColeta IN {&hDBOTable}(INPUT {&ttParent}.cdn-produt-rural, 
                                                     INPUT c-cod-externo:SCREEN-VALUE IN FRAME fPage1, 
                                                     INPUT YES ).
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
       {&hDBOTable}:FILE-NAME <> "inbo/boin00966.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00966.p YES}
        {btb/btb008za.i2 inbo/boin00966.p '' {&hDBOTable}} 
    END.

    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    IF  NOT VALID-HANDLE(h-boin122) THEN
        run inbo/boin122.p persistent set h-boin122.
    RUN openQueryStatic IN h-boin122 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-boin417na) THEN DO:
       {btb/btb008za.i1 inbo/boin417na.p}
       {btb/btb008za.i2 inbo/boin417na.p '' h-boin417na} 
    END.
    RUN openQueryStatic IN h-boin417na (INPUT "Main":U).

    IF NOT VALID-HANDLE(h-boin00980) THEN DO:
       {btb/btb008za.i1 inbo/boin00980.p}
       {btb/btb008za.i2 inbo/boin00980.p '' h-boin00980} 
    END.
    RUN openQueryStatic IN h-boin00980 (INPUT "Main":U).

    IF NOT VALID-HANDLE(h-boin00977) THEN DO:
       {btb/btb008za.i1 inbo/boin00977.p}
       {btb/btb008za.i2 inbo/boin00977.p '' h-boin00977} 
    END.
    RUN openQueryStatic IN h-boin00977 (INPUT "Main":U).

    IF NOT VALID-HANDLE(h-boin00990) THEN DO:
       {btb/btb008za.i1 inbo/boin00990.p}
       {btb/btb008za.i2 inbo/boin00990.p '' h-boin00990} 
    END.
    RUN openQueryStatic IN h-boin00990 (INPUT "Main":U).
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-regiao-propriedade wMaintenanceNoNavigation 
PROCEDURE pi-busca-regiao-propriedade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-cod-regiao AS CHARACTER NO-UNDO.

    IF VALID-HANDLE(h-boin00980) THEN DO:
        RUN goTokey IN h-boin00980(INPUT tt-pto-coleta.cod-propried:SCREEN-VALUE IN FRAME fPage1).
        IF RETURN-VALUE = "OK" THEN
            RUN getcharfield IN  h-boin00980(INPUT 'cod-regiao', OUTPUT c-cod-regiao).
    
        ASSIGN tt-pto-coleta.cod-regiao:SCREEN-VALUE IN FRAME fPage1 = c-cod-regiao.
    
        {method/referencefields.i 
                      &HandleDBOLeave="h-boin00977"
                      &KeyValue1="trim(tt-pto-coleta.cod-regiao:SCREEN-VALUE IN FRAME fPage1)"
                      &FieldName1="nom-regiao"
                      &FieldScreen1="c-desc-regiao"
                      &Frame1="fPage1"}
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

