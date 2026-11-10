&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
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
{include/i-prgvrs.i AB0104A 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0104a MAB}
&ENDIF



CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AB0104A
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage      

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           TTmab-model
&GLOBAL-DEFINE hDBOTable         hDBOModel
&GLOBAL-DEFINE DBOTable          mab-model

&GLOBAL-DEFINE page0KeyFields    TTmab-model.cod-model
&GLOBAL-DEFINE page0Fields       TTmab-model.des-model TTmab-model.cod-marca ~
                                 TTmab-model.un TTmab-model.idi-tip-model ~
                                 TTmab-model.log-cont-sec cCodUnSec ~
                                 TTmab-model.log-integr-agro TTmab-model.val-consu-previs

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE l-achou     AS LOGICAL NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOMfoMarca  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOUnid      AS HANDLE NO-UNDO.

{cdp/cdcfgman.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE wMaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS TTmab-model.cod-model TTmab-model.des-model ~
TTmab-model.cod-marca TTmab-model.un TTmab-model.idi-tip-model ~
TTmab-model.log-cont-sec TTmab-model.val-consu-previs ~
TTmab-model.log-integr-agro 
&Scoped-define ENABLED-TABLES TTmab-model
&Scoped-define FIRST-ENABLED-TABLE TTmab-model
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 rtKeys rtKeys-2 rtToolBar ~
RECT-4 cDescMarca cDescUnid cCodUnSec cDescUnidSec btOK btSave btCancel ~
btHelp fi-implemento 
&Scoped-Define DISPLAYED-FIELDS TTmab-model.cod-model TTmab-model.des-model ~
TTmab-model.cod-marca TTmab-model.un TTmab-model.idi-tip-model ~
TTmab-model.log-cont-sec TTmab-model.val-consu-previs ~
TTmab-model.log-integr-agro 
&Scoped-define DISPLAYED-TABLES TTmab-model
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-model
&Scoped-Define DISPLAYED-OBJECTS cDescMarca cDescUnid cCodUnSec ~
cDescUnidSec fi-implemento 

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
     LABEL "Unidade Secund†ria" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE cDescMarca AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE cDescUnid AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE cDescUnidSec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-implemento AS CHARACTER FORMAT "X(30)":U INITIAL "Implemento" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 38 BY 1.58.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 38 BY 1.5.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 38 BY 1.58.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.25.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 10.96.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     TTmab-model.cod-model AT ROW 1.25 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-model.des-model AT ROW 2.63 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 45.57 BY .88
     TTmab-model.cod-marca AT ROW 3.63 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cDescMarca AT ROW 3.63 COL 29.57 COLON-ALIGNED NO-LABEL
     TTmab-model.un AT ROW 4.63 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     cDescUnid AT ROW 4.63 COL 24.57 COLON-ALIGNED NO-LABEL
     TTmab-model.idi-tip-model AT ROW 6.42 COL 27 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Equipamento", 1,
"Componente", 2
          SIZE 31 BY .71
     TTmab-model.log-cont-sec AT ROW 7.58 COL 21
          LABEL "Utiliza Contador Secund†rio":L30
          VIEW-AS TOGGLE-BOX
          SIZE 23 BY .71
     cCodUnSec AT ROW 8.38 COL 19 COLON-ALIGNED
     cDescUnidSec AT ROW 8.38 COL 24.57 COLON-ALIGNED NO-LABEL
     TTmab-model.val-consu-previs AT ROW 10 COL 35.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     TTmab-model.log-integr-agro AT ROW 11.96 COL 23.29
          VIEW-AS TOGGLE-BOX
          SIZE 26.72 BY .71
     btOK AT ROW 13.58 COL 2
     btSave AT ROW 13.58 COL 13
     btCancel AT ROW 13.58 COL 24
     btHelp AT ROW 13.58 COL 80
     fi-implemento AT ROW 9.42 COL 20.14 COLON-ALIGNED NO-LABEL
     "Tipo Modelo" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 5.71 COL 22.43
     RECT-2 AT ROW 5.88 COL 21
     RECT-3 AT ROW 11.5 COL 21
     rtKeys AT ROW 1 COL 1
     rtKeys-2 AT ROW 2.29 COL 1
     rtToolBar AT ROW 13.33 COL 1
     RECT-4 AT ROW 9.63 COL 21
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 13.79
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: wMaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
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
         TITLE              = "Manutená∆o dos Tipos de Modelo"
         HEIGHT             = 13.83
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
/* SETTINGS FOR TOGGLE-BOX TTmab-model.log-cont-sec IN FRAME fpage0
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation /* Manutená∆o dos Tipos de Modelo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation /* Manutená∆o dos Tipos de Modelo */
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


&Scoped-define SELF-NAME cCodUnSec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cCodUnSec wMaintenanceNoNavigation
ON F5 OF cCodUnSec IN FRAME fpage0 /* Unidade Secund†ria */
DO:
    ASSIGN l-implanta = NO.
    {include/zoomvar.i &prog-zoom="inzoom\z01in417.w"
                       &campo=cCodUnSec
                       &campozoom=un
                       &campo2=cDescUnidSec
                       &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cCodUnSec wMaintenanceNoNavigation
ON LEAVE OF cCodUnSec IN FRAME fpage0 /* Unidade Secund†ria */
DO:
    {method\referenceFields.i
           &HandleDBOLeave="hDBOUnid"
           &KeyValue1="cCodUnSec:screen-value in frame fPage0"
           &FieldName1="descricao"
           &FieldScreen1="cDescUnidSec"
           &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cCodUnSec wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF cCodUnSec IN FRAME fpage0 /* Unidade Secund†ria */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-model.cod-marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-model.cod-marca wMaintenanceNoNavigation
ON LEAVE OF TTmab-model.cod-marca IN FRAME fpage0 /* Marca */
DO:
  {method/ReferenceFields.i
        &HandleDBOLeave="hDBOMfoMarca"
        &KeyValue1="TTmab-model.cod-marca:SCREEN-VALUE IN FRAME fpage0"
        &FieldName1="nom-marca"
        &FieldScreen1="cDescMarca"
        &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-model.cod-marca wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-model.cod-marca IN FRAME fpage0 /* Marca */
OR F5 OF TTmab-model.cod-marca IN FRAME fPage0 DO:
   {method/zoomfields.i 
     &ProgramZoom="frzoom/z01fr015.w"
     &FieldZoom1="cod-marca"
     &FieldScreen1="TTmab-model.cod-marca"
     &Frame1="fPage0"
     &FieldZoom2="nom-marca"
     &FieldScreen2="cDescMarca"
     &Frame2="fPage0"
     &EnableImplant="yes"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-model.idi-tip-model
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-model.idi-tip-model wMaintenanceNoNavigation
ON VALUE-CHANGED OF TTmab-model.idi-tip-model IN FRAME fpage0
DO:
    ASSIGN TTmab-model.idi-tip-model.

    IF  TTmab-model.idi-tip-model = 1 THEN
        ASSIGN ttmab-model.val-consu-previs:SENSITIVE IN FRAME fPage0 = YES
               TTmab-model.log-cont-sec:SENSITIVE     IN FRAME fPage0 = YES.
    ELSE
        ASSIGN ttmab-model.val-consu-previs:SENSITIVE IN FRAME fPage0 = NO
               TTmab-model.log-cont-sec:CHECKED       IN FRAME fPage0 = NO
               TTmab-model.log-cont-sec:SENSITIVE     IN FRAME fPage0 = NO.
    APPLY "VALUE-CHANGED":U TO TTmab-model.log-cont-sec.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-model.log-cont-sec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-model.log-cont-sec wMaintenanceNoNavigation
ON VALUE-CHANGED OF TTmab-model.log-cont-sec IN FRAME fpage0 /* Utiliza Contador Secund†rio */
DO:
    IF  TTmab-model.log-cont-sec:CHECKED IN FRAME fPage0 = YES THEN
        ASSIGN cCodUnSec:SENSITIVE       IN FRAME fPage0 = YES.
    ELSE
        ASSIGN cCodUnSec:SCREEN-VALUE    IN FRAME fPage0 = ""
               cDescUnidSec:SCREEN-VALUE IN FRAME fPage0 = ""
               cCodUnSec:SENSITIVE       IN FRAME fPage0 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-model.un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-model.un wMaintenanceNoNavigation
ON F5 OF TTmab-model.un IN FRAME fpage0 /* Unidade */
DO:
    ASSIGN l-implanta = NO.
    {include/zoomvar.i &prog-zoom="inzoom\z01in417.w"
                       &campo=TTmab-model.un
                       &campozoom=un
                       &campo2=cDescUnid
                       &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-model.un wMaintenanceNoNavigation
ON LEAVE OF TTmab-model.un IN FRAME fpage0 /* Unidade */
DO:
   {method\referenceFields.i
              &HandleDBOLeave="hDBOUnid"
              &KeyValue1="TTmab-model.un:screen-value in frame fPage0"
              &FieldName1="descricao"
              &FieldScreen1="cDescUnid"
              &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-model.un wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-model.un IN FRAME fpage0 /* Unidade */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*--- L¢gica para inicializaá∆o do programam ---*/
{maintenancenonavigation/mainblock.i}

{&ttTable}.cod-marca:load-mouse-pointer ("image/lupa.cur") in frame fPage0.
{&ttTable}.un:load-mouse-pointer ("image/lupa.cur")        in frame fPage0.
cCodUnSec:load-mouse-pointer ("image/lupa.cur")            in frame fPage0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Override ap¢s fechar o programa
------------------------------------------------------------------------------*/
/** Marca **/
IF VALID-HANDLE(hDBOMfoMarca ) THEN
       RUN destroy IN hDBOMfoMarca .
/** Unidade **/
if valid-handle (hDBOUnid) then
     delete procedure hDBOUnid.
   
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     afterDisplayFields
  Parameters:  <none>
  Notes:       Override ap¢s mostrar campos em tela
------------------------------------------------------------------------------*/
{utp/ut-liter.i "Implemento" MAB}
ASSIGN fi-implemento:SCREEN-VALUE IN FRAME fPage0 = RETURN-VALUE.
    /** Descriá‰es **/
    APPLY "LEAVE":U TO {&ttTable}.cod-marca IN FRAME fPage0.
    APPLY "LEAVE":U TO {&ttTable}.un        IN FRAME fPage0.
    IF  AVAIL TTmab-model AND SUBSTRING(TTmab-model.cod-livre-1, 1, 2) <> "" THEN DO:
        ASSIGN cCodUnSec:SCREEN-VALUE IN FRAME fPage0 = SUBSTRING(TTmab-model.cod-livre-1, 1, 2).
        APPLY "VALUE-CHANGED":U TO {&ttTable}.log-cont-sec IN FRAME fPage0.
        APPLY "LEAVE":U         TO cCodUnSec               IN FRAME fPage0.
    END.

    find first param-global no-lock no-error.
    &IF  DEFINED (bf_man_206) &THEN
         IF  param-global.ind-int-agro = YES THEN
             ASSIGN {&ttTable}.log-integr-agro:SENSITIVE IN FRAME fPage0 = YES
                    {&ttTable}.log-integr-agro:HIDDEN    IN FRAME fPage0 = NO
                    RECT-3:HIDDEN                        IN FRAME fPage0 = NO.
         ELSE
             ASSIGN {&ttTable}.log-integr-agro:SENSITIVE IN FRAME fPage0 = NO
                    {&ttTable}.log-integr-agro:HIDDEN    IN FRAME fPage0 = YES
                    RECT-3:HIDDEN                        IN FRAME fPage0 = YES.
    &ELSE
         IF  SUBSTRING(param-global.char-2,21,1)= "1":U THEN
             ASSIGN {&ttTable}.log-integr-agro:SENSITIVE IN FRAME fPage0 = YES
                    {&ttTable}.log-integr-agro:HIDDEN    IN FRAME fPage0 = NO
                    RECT-3:HIDDEN                        IN FRAME fPage0 = NO.
         ELSE
             ASSIGN {&ttTable}.log-integr-agro:SENSITIVE IN FRAME fPage0 = NO
                    {&ttTable}.log-integr-agro:HIDDEN    IN FRAME fPage0 = YES
                    RECT-3:HIDDEN                        IN FRAME fPage0 = YES. 
    &ENDIF

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
    IF  AVAIL {&ttTable} THEN DO:
        FIND FIRST param-global NO-LOCK NO-ERROR.
        &IF  DEFINED (bf_man_206) &THEN
             IF  param-global.ind-int-agro = YES THEN
                 ASSIGN {&ttTable}.log-integr-agro:SENSITIVE IN FRAME fPage0 = YES
                        {&ttTable}.log-integr-agro:HIDDEN    IN FRAME fPage0 = NO
                        RECT-3:HIDDEN                        IN FRAME fPage0 = NO. 
             ELSE
                 ASSIGN {&ttTable}.log-integr-agro:SENSITIVE IN FRAME fPage0 = NO
                        {&ttTable}.log-integr-agro:HIDDEN    IN FRAME fPage0 = YES
                        RECT-3:HIDDEN                        IN FRAME fPage0 = YES.
        &ELSE
             IF  SUBSTRING(param-global.char-2,21,1)= "1":U THEN
                 ASSIGN {&ttTable}.log-integr-agro:SENSITIVE IN FRAME fPage0 = YES
                        {&ttTable}.log-integr-agro:HIDDEN    IN FRAME fPage0 = NO
                        RECT-3:HIDDEN                        IN FRAME fPage0 = NO.
             ELSE
                 ASSIGN {&ttTable}.log-integr-agro:SENSITIVE IN FRAME fPage0 = NO
                        {&ttTable}.log-integr-agro:HIDDEN    IN FRAME fPage0 = YES
                        RECT-3:HIDDEN                        IN FRAME fPage0 = YES.
          &ENDIF
    END.

    IF  TTmab-model.idi-tip-model = 1 THEN
        ASSIGN ttmab-model.val-consu-previs:SENSITIVE IN FRAME fPage0 = YES
               TTmab-model.log-cont-sec:SENSITIVE     IN FRAME fPage0 = YES.
    ELSE
        ASSIGN ttmab-model.val-consu-previs:SENSITIVE IN FRAME fPage0 = NO
               TTmab-model.log-cont-sec:SENSITIVE     IN FRAME fPage0 = NO.

    APPLY "VALUE-CHANGED":U TO TTmab-model.log-cont-sec.

    IF  pcAction = "UPDATE":U THEN DO:
        RUN piValidaLogSec IN hDBOModel (INPUT 1 /*1 = consulta por modelo*/,
                                         INPUT 0 /*0 = n∆o Ç utilizado este parametro para esta consulta*/,
                                         INPUT ttmab-model.cod-model).
        IF  RETURN-VALUE = "NOK":U THEN
            ASSIGN TTmab-model.log-cont-sec:SENSITIVE IN FRAME fPage0 = NO.
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
    ASSIGN SUBSTRING(TTmab-model.cod-livre-1, 1, 2) = cCodUnSec:SCREEN-VALUE IN FRAME fPage0.

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
IF NOT VALID-HANDLE(hDBOMfoMarca) OR 
         hDBOMfoMarca:TYPE <> "PROCEDURE":U OR
         hDBOMfoMarca:FILE-NAME <> "frbo/bofr015.p":U THEN DO:
        RUN frbo/bofr015.p PERSISTENT SET  hDBOMfoMarca.
END.
RUN openQueryStatic in   hDBOMfoMarca (input "Main":U) NO-ERROR.

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

