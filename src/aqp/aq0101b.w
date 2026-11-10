&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-event-aquis-rural NO-UNDO LIKE event-aquis-rural
       FIELD r-rowid as rowid.
DEFINE TEMP-TABLE tt-param-aquis-rural NO-UNDO LIKE param-aquis-rural
       FIELD r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0101B 2.00.00.009 } /*** "010009" 17/11/2023 16:12:11 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0101B MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AQ0101b
&GLOBAL-DEFINE Version        2.00.00.009

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Eventos

&GLOBAL-DEFINE ttTable           tt-event-aquis-rural
&GLOBAL-DEFINE hDBOTable         h-boin01006
&GLOBAL-DEFINE DBOTable          tt-event-aquis-rural

&GLOBAL-DEFINE ttParent          tt-param-aquis-rural
&GLOBAL-DEFINE DBOParentTable    h-boin00968

&GLOBAL-DEFINE page0KeyFields     
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-param-aquis-rural.cod-estabel
&GLOBAL-DEFINE page1Fields       cb-item tt-event-aquis-rural.cod-evento tt-event-aquis-rural.cod-exame ~
                                 tt-event-aquis-rural.cod-comp cb-cdn-tipo  

{include/i_fncrowid.i}

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-list AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR v_rec_event_financ AS
    &IF {&ROWID_READY} = YES &THEN 
        ROWID
    &ELSE 
        RECID FORMAT ">>>>>>9":U INITIAL ?
    &ENDIF
    NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}       AS HANDLE NO-UNDO.  /* event-aquis-rural */
DEFINE VARIABLE h-boad107na        AS HANDLE NO-UNDO.  /* estabelec         */
DEFINE VARIABLE h-boin172na        AS HANDLE NO-UNDO.  /* item              */
DEFINE VARIABLE h-boin00983        AS HANDLE NO-UNDO.  /* item-estab-rural  */
DEFINE VARIABLE h-boin114          AS HANDLE NO-UNDO.  /* exame             */
DEFINE VARIABLE h-boin050          AS HANDLE NO-UNDO.  /* it-comp-exame     */
DEFINE VARIABLE h-api-financ       AS HANDLE NO-UNDO.  /* event-financ      */
    

/* Zoom Smart */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar c-nome-estabel btOK btSave ~
btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-param-aquis-rural.cod-estabel 
&Scoped-define DISPLAYED-TABLES tt-param-aquis-rural
&Scoped-define FIRST-DISPLAYED-TABLE tt-param-aquis-rural
&Scoped-Define DISPLAYED-OBJECTS c-nome-estabel 

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

DEFINE VARIABLE c-nome-estabel LIKE estabelec.nome
     VIEW-AS FILL-IN 
     SIZE 46.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE cb-cdn-tipo AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 1 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "item1",1
     DROP-DOWN-LIST
     SIZE 24.43 BY 1 NO-UNDO.

DEFINE VARIABLE cb-item AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE c-des-comp-exame LIKE comp-exame.descricao
     VIEW-AS FILL-IN 
     SIZE 49.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-event-financ AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.6 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-exame LIKE exame.descricao
     VIEW-AS FILL-IN 
     SIZE 49.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item LIKE item.desc-item
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73 BY 3.75.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73 BY 3.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-param-aquis-rural.cod-estabel AT ROW 1.75 COL 20.86 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 8.72 BY .88
     c-nome-estabel AT ROW 1.75 COL 29.72 COLON-ALIGNED HELP
          "Nome Estabelecimento" NO-LABEL WIDGET-ID 4
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

DEFINE FRAME fPage1
     cb-item AT ROW 1.5 COL 11.57 COLON-ALIGNED WIDGET-ID 2
     c-desc-item AT ROW 1.5 COL 29.86 COLON-ALIGNED HELP
          "" NO-LABEL WIDGET-ID 4
     tt-event-aquis-rural.cod-evento AT ROW 4.42 COL 14.57 COLON-ALIGNED WIDGET-ID 14
          LABEL "C¢digo"
          VIEW-AS FILL-IN 
          SIZE 24.43 BY .88
     c-des-event-financ AT ROW 4.42 COL 39.14 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     cb-cdn-tipo AT ROW 5.46 COL 14.57 COLON-ALIGNED
     tt-event-aquis-rural.cod-exame AT ROW 8.75 COL 15 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     c-des-exame AT ROW 8.75 COL 27 COLON-ALIGNED HELP
          "" NO-LABEL WIDGET-ID 24
     tt-event-aquis-rural.cod-comp AT ROW 9.75 COL 15 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     c-des-comp-exame AT ROW 9.75 COL 27 COLON-ALIGNED HELP
          "" NO-LABEL WIDGET-ID 26
     "Evento Financeiro" VIEW-AS TEXT
          SIZE 13 BY .54 AT ROW 3.04 COL 10 WIDGET-ID 10
     "Controle de Qualidade" VIEW-AS TEXT
          SIZE 17 BY .54 AT ROW 7.54 COL 10 WIDGET-ID 12
     RECT-12 AT ROW 3.29 COL 6.72 WIDGET-ID 6
     RECT-13 AT ROW 7.79 COL 6.86 WIDGET-ID 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.43 ROW 4.71
         SIZE 84.43 BY 10.92
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-event-aquis-rural T "?" NO-UNDO mgind event-aquis-rural
      ADDITIONAL-FIELDS:
          FIELD r-rowid as rowid
      END-FIELDS.
      TABLE: tt-param-aquis-rural T "?" NO-UNDO mgind param-aquis-rural
      ADDITIONAL-FIELDS:
          FIELD r-rowid as rowid
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
         MAX-HEIGHT         = 39.42
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 39.42
         VIRTUAL-WIDTH      = 182.86
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
/* SETTINGS FOR FILL-IN c-nome-estabel IN FRAME fpage0
   LIKE = mgind.estabelec.nome EXP-LABEL EXP-SIZE                       */
/* SETTINGS FOR FILL-IN tt-param-aquis-rural.cod-estabel IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN c-des-comp-exame IN FRAME fPage1
   LIKE = mgind.comp-exame.descricao EXP-SIZE                           */
/* SETTINGS FOR FILL-IN c-des-exame IN FRAME fPage1
   LIKE = mgind.exame.descricao                                         */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME fPage1
   LIKE = mgind.item.desc-item EXP-SIZE                                 */
/* SETTINGS FOR FILL-IN tt-event-aquis-rural.cod-evento IN FRAME fPage1
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
    APPLY 'VALUE-CHANGED':U TO cb-cdn-tipo IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME cb-cdn-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cdn-tipo wMaintenanceNoNavigation
ON VALUE-CHANGED OF cb-cdn-tipo IN FRAME fPage1 /* Tipo */
DO:
  ASSIGN tt-event-aquis-rural.cod-exame:SENSITIVE IN FRAME fPage1 = INPUT FRAME fPage1 cb-cdn-tipo = 2  /*qualidade*/
         tt-event-aquis-rural.cod-comp:SENSITIVE  IN FRAME fPage1 = INPUT FRAME fPage1 cb-cdn-tipo = 2. /*qualidade*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-item wMaintenanceNoNavigation
ON VALUE-CHANGED OF cb-item IN FRAME fPage1 /* Item */
DO:
    DEFINE VARIABLE pDescItem    AS CHARACTER NO-UNDO.

    RUN goToKey IN h-boin172na (INPUT cb-item:SCREEN-VALUE IN FRAME fPage1) NO-ERROR.

    IF RETURN-VALUE = "OK":U THEN DO:
        RUN findDescItem IN h-boin00983 (INPUT SELF:SCREEN-VALUE IN FRAME fPage1, OUTPUT pDescItem) NO-ERROR. 
        ASSIGN c-desc-item:SCREEN-VALUE IN FRAME fPage1 = pDescItem.
    END.
    ELSE 
        ASSIGN c-desc-item:SCREEN-VALUE IN FRAME fPage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-event-aquis-rural.cod-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-event-aquis-rural.cod-comp wMaintenanceNoNavigation
ON LEAVE OF tt-event-aquis-rural.cod-comp IN FRAME fPage1 /* Componente */
OR ENTRY OF tt-event-aquis-rural.cod-comp IN FRAME fpage1 /* Componente Exame */
DO:
    DEFINE VARIABLE i-exame-versao AS INTEGER NO-UNDO.
    
    RUN goToKeyByExame IN h-boin114(INPUT tt-event-aquis-rural.cod-exame:SCREEN-VALUE).
    
    IF RETURN-VALUE = "OK":U THEN DO:
        
        RUN getIntField IN h-boin114(INPUT 'cdn-versao', OUTPUT i-exame-versao). /* buscar versão do exame para pk do componente*/
    
        RUN gotokey IN h-boin050(INPUT INT(tt-event-aquis-rural.cod-exame:SCREEN-VALUE IN FRAME fPage1), 
                                 INPUT INT(tt-event-aquis-rural.cod-comp:SCREEN-VALUE  IN FRAME fPage1), 
                                 INPUT i-exame-versao).

    END.

    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getCharField IN h-boin050(INPUT 'descricao', OUTPUT c-des-comp-exame).
        ASSIGN c-des-comp-exame:SCREEN-VALUE IN FRAME fPage1 = c-des-comp-exame.
    END.
    ELSE
        ASSIGN c-des-comp-exame:SCREEN-VALUE IN FRAME fPage1 = "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-event-aquis-rural.cod-comp wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-event-aquis-rural.cod-comp IN FRAME fPage1 /* Componente */
OR F5 OF tt-event-aquis-rural.cod-comp IN FRAME fpage1 /* Componente Exame */
DO:
  {method/ZoomFields.i &ProgramZoom="inzoom/z01in637.w"
                       &FieldZoom1="cod-comp"
                       &FieldScreen1="tt-event-aquis-rural.cod-comp"
                       &Frame1="fPage1"
                       &RunMethod="RUN setParams IN hProgramZoom (INPUT cb-item:screen-value, INPUT INT(tt-event-aquis-rural.cod-exame:screen-value))."
                       &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME tt-param-aquis-rural.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-param-aquis-rural.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  {method/ReferenceFields.i &HandleDBOLeave="h-boad107na"
                            &KeyValue1="tt-param-aquis-rural.cod-estabel"
                            &FieldName1="nome"
                            &FieldScreen1="c-nome-estabel"
                            &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-event-aquis-rural.cod-evento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-event-aquis-rural.cod-evento wMaintenanceNoNavigation
ON LEAVE OF tt-event-aquis-rural.cod-evento IN FRAME fPage1 /* C¢digo */
OR ENTRY OF tt-event-aquis-rural.cod-evento IN FRAME fpage1
DO:

    IF VALID-HANDLE(h-api-financ) THEN DO:
        
        RUN pi_retornar_dados_evento_financeiro IN h-api-financ (INPUT  tt-event-aquis-rural.cod-evento:SCREEN-VALUE IN FRAME fPage1,
                                                                 OUTPUT c-des-event-financ).
        
        ASSIGN c-des-event-financ:SCREEN-VALUE IN FRAME fPage1 = c-des-event-financ.

    END.
    ELSE 
        ASSIGN c-des-event-financ:SCREEN-VALUE IN FRAME fPage1 = "":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-event-aquis-rural.cod-evento wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-event-aquis-rural.cod-evento IN FRAME fPage1 /* C¢digo */
OR F5 OF tt-event-aquis-rural.cod-evento IN FRAME fpage1
DO:

    RUN prgfin/apb/apb060ka.p.

    IF v_rec_event_financ <> ? THEN DO:

        IF VALID-HANDLE (h-api-financ) THEN DO:

            RUN pi_retornar_dados_evento_financ_recid IN h-api-financ (INPUT  v_rec_event_financ,
                                                                       OUTPUT tt-event-aquis-rural.cod-evento,
                                                                       OUTPUT c-des-event-financ).

            DO WITH FRAME fPage1:

                ASSIGN tt-event-aquis-rural.cod-evento:SCREEN-VALUE = tt-event-aquis-rural.cod-evento
                       c-des-event-financ:SCREEN-VALUE              = c-des-event-financ.

            END.

        END.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-event-aquis-rural.cod-exame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-event-aquis-rural.cod-exame wMaintenanceNoNavigation
ON LEAVE OF tt-event-aquis-rural.cod-exame IN FRAME fPage1 /* Exame */
OR ENTRY OF tt-event-aquis-rural.cod-exame IN FRAME fpage1 /* Exame */
DO:
    RUN goToKeyByExame IN h-boin114(INPUT tt-event-aquis-rural.cod-exame:SCREEN-VALUE).
    
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getCharField IN h-boin114(INPUT 'descricao', OUTPUT c-des-exame).
        ASSIGN c-des-exame:SCREEN-VALUE IN FRAME fPage1 = c-des-exame.
    END.
    ELSE
        ASSIGN c-des-exame:SCREEN-VALUE IN FRAME fPage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-event-aquis-rural.cod-exame wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-event-aquis-rural.cod-exame IN FRAME fPage1 /* Exame */
OR F5 OF tt-event-aquis-rural.cod-exame IN FRAME fpage1 /* Exame */
DO:
    ASSIGN l-implanta = NO.              
    {include/zoomvar.i  &prog-zoom="inzoom/z01in164.w"
                        &campo=tt-event-aquis-rural.cod-exame
                        &campozoom=cod-exame
                        &parametros="run pi-seta-inicial in wh-pesquisa (INPUT cb-item:SCREEN-VALUE)."}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-event-aquis-rural.cod-exame:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fPage1.
tt-event-aquis-rural.cod-comp:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPage1.
tt-event-aquis-rural.cod-evento:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.

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
/* estabelec            */
IF VALID-HANDLE(h-boad107na) THEN DO:
    DELETE PROCEDURE h-boad107na.
    ASSIGN h-boad107na = ?.
END.

/* exame */
IF VALID-HANDLE (h-boin114) THEN DO:
    DELETE PROCEDURE h-boin114.
    ASSIGN h-boin114 = ?.
END.
    
/* comp-exame */
IF VALID-HANDLE (h-boin050) THEN DO:
    DELETE PROCEDURE h-boin050.
    ASSIGN h-boin050 = ?.
END.

/* item                 */
IF VALID-HANDLE(h-boin172na) THEN DO:
    DELETE PROCEDURE h-boin172na.
    ASSIGN h-boin172na = ?.
END.

/* item-estab-rural     */
IF VALID-HANDLE(h-boin00983) THEN DO:
    DELETE PROCEDURE h-boin00983.
    ASSIGN h-boin00983 = ?.
END.

/* event-financ         */
IF  VALID-HANDLE(h-api-financ) THEN DO:
    DELETE PROCEDUR h-api-financ.
    ASSIGN h-api-financ =?.
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
    /*item padrão do estabelecimento*/
    RUN getListItems IN h-boin00983(INPUT tt-param-aquis-rural.cod-estabel, OUTPUT c-list).
    IF c-list <> "" THEN DO:
        ASSIGN cb-item:LIST-ITEMS IN FRAME fPage1   = c-list
               cb-item:SCREEN-VALUE IN FRAME fPage1 = ENTRY (1,c-list).

        APPLY 'VALUE-CHANGED':U TO cb-item IN FRAME fPage1.
    END.
    /*******************************************/

    ASSIGN cb-cdn-tipo:LIST-ITEM-PAIRS IN FRAME fPage1 = {ininc/i01in01006.i  07}
           cb-cdn-tipo = INT(ENTRY(2,cb-cdn-tipo:LIST-ITEM-PAIRS IN FRAME fPage1)).

    DISP cb-cdn-tipo WITH FRAME fPage1.

    APPLY 'LEAVE':U         TO tt-param-aquis-rural.cod-estabel IN FRAME fPage0.
    APPLY 'VALUE-CHANGED':U TO cb-cdn-tipo                      IN FRAME fPage1.

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
    ASSIGN tt-event-aquis-rural.cod-estabel = tt-param-aquis-rural.cod-estabel
           tt-event-aquis-rural.it-codigo   = INPUT FRAME fPage1 cb-item
           tt-event-aquis-rural.cdn-tipo    = INPUT FRAME fPage1 cb-cdn-tipo.

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

/* estabelec            */
IF NOT VALID-HANDLE(h-boad107na) THEN DO: 
        {btb/btb008za.i1 adbo/boad107na.p}
        {btb/btb008za.i2 adbo/boad107na.p '' h-boad107na}
END.
RUN openQueryStatic IN h-boad107na (INPUT "Main":U).
/************************/

/* exame                */
IF NOT VALID-HANDLE(h-boin114) THEN
    RUN inbo/boin114.p PERSISTENT SET h-boin114.
/************************/

RUN openqueryStatic IN h-boin114(INPUT "Main") NO-ERROR.

/* it-comp-exame        */
IF NOT VALID-HANDLE(h-boin050) THEN
    RUN inbo/boin050.p PERSISTENT SET h-boin050.
/************************/

RUN openqueryStatic IN h-boin050(INPUT "Main") NO-ERROR.

/* item                 */
IF NOT VALID-HANDLE(h-boin172na) THEN DO: 
        {btb/btb008za.i1 inbo/boin172na.p}
        {btb/btb008za.i2 inbo/boin172na.p '' h-boin172na}
END.
RUN openQueryStatic IN h-boin172na (INPUT "Main":U).
/************************/
              
/* item-estab-rural     */
IF NOT VALID-HANDLE(h-boin00983) THEN DO:
        {btb/btb008za.i1 inbo/boin00983.p}
        {btb/btb008za.i2 inbo/boin00983.p '' h-boin00983}
END.
RUN openQueryStatic IN h-boin00983 (INPUT "Main":U).
/************************/
              
/* event-financ         */
IF  NOT VALID-HANDLE(h-api-financ) THEN
    RUN prgfin/apb/apb061za.p PERSISTENT SET h-api-financ NO-ERROR.
/************************/


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
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

