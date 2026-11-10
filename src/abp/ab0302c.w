&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttApont NO-UNDO LIKE mab-abastec-lubrific
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttLubr NO-UNDO LIKE mab-item-lubrific
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
{include/i-prgvrs.i AB0302C 2.00.00.034 } /*** "010034" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0302c MAB}
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
&GLOBAL-DEFINE Program           AB0302C
&GLOBAL-DEFINE Version        2.00.00.034

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      P g. 1

&GLOBAL-DEFINE ttTable           ttLubr
&GLOBAL-DEFINE hDBOTable         hDBOLubr
&GLOBAL-DEFINE DBOTable          mab-item-lubrific

&GLOBAL-DEFINE ttParent          ttApont
&GLOBAL-DEFINE DBOParentTable    hDBOApont

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields ttApont.ep-codigo ttApont.cod-eqpto ~
                                 ttApont.dat-movto ttApont.num-docto ~
                                 ttApont.hra-final ttApont.hra-inicial
&GLOBAL-DEFINE page1Fields       ttLubr.cod-comptmento ttLubr.cod-evento ~
                                 ttLubr.cod-localiz ttLubr.cod-refer ~
                                 ttLubr.cd-tipo ttLubr.it-codigo ~
                                 ttLubr.lote ttLubr.val-mater-1 ~
                                 ttLubr.val-quant ttlubr.log-gera-amostra-oleo ~
                                 ttLubr.cod-amostra-fisic ttLubr.cod-causa fiConta fiSub


/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cCodModelo   AS CHARACTER                NO-UNDO.
define variable dePrecoMater like {&ttTable}.val-mater-1 no-undo.
define variable iTpPosto     as integer                  no-undo.
define variable iTpValor     as integer                  no-undo.
DEFINE VARIABLE l-mao-impl   AS LOGICAL INITIAL NO       NO-UNDO.
DEFINE VARIABLE l-msg-evento AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE c-desc       AS CHAR                     NO-UNDO.
DEFINE VARIABLE c-label      AS CHAR                     NO-UNDO.

/*unifica‡Æo de conceito - centro de custo e conta contabil*/
DEFINE VARIABLE cEmpresaEstab LIKE mab-comptmento-eqpto.ep-codigo NO-UNDO.
DEFINE VARIABLE cEstabEqpto   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE dDtMovimento  AS DATE                    NO-UNDO.

{cdp/cdunif001.i} /*vari veis unifica‡Æo de conceito*/

/** Zoom **/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE    NO-UNDO.

/* Global Variables ---                                                 */
define new global shared variable c-it-codigo   like saldo-estoq.it-codigo            no-undo.
define new global shared variable c-estab       like saldo-estoq.cod-estabel          no-undo.
define new global shared variable iEmpresa      like mab-comptmento-eqpto.ep-codigo   no-undo.
define new global shared variable cEqpto        like mab-comptmento-eqpto.cod-eqpto   no-undo.
define new global shared variable cTipoMaterial like mab-tip-mater-item.cod-tip-mater no-undo.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEqpto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOComp      AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOItem      AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEvento    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOManut     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOPosto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOCausaPadrao AS HANDLE NO-UNDO.

DEFINE VARIABLE c-msg-aux    AS CHARACTER NO-UNDO.

DEFINE BUFFER bfHistAtiv FOR mab-histor-ativid.
DEFINE BUFFER bfMabPosto FOR mab-posto.

{cdp/cdcfgman.i} /** Preprocessadores Custeio On-Line **/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttApont.num-docto ttApont.ep-codigo ~
ttApont.cod-eqpto ttApont.dat-movto ttApont.hra-inicial ttApont.hra-final 
&Scoped-define ENABLED-TABLES ttApont
&Scoped-define FIRST-ENABLED-TABLE ttApont
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar fiDescModelo btOK btSave ~
btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS ttApont.num-docto ttApont.ep-codigo ~
ttApont.cod-eqpto ttApont.dat-movto ttApont.hra-inicial ttApont.hra-final 
&Scoped-define DISPLAYED-TABLES ttApont
&Scoped-define FIRST-DISPLAYED-TABLE ttApont
&Scoped-Define DISPLAYED-OBJECTS fiDescModelo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU pop-item 
       MENU-ITEM miItem         LABEL "Pesquisa &Itens"
       RULE
       MENU-ITEM miMaterial     LABEL "Pesquisa Itens do &Tipo Material"
       RULE
       MENU-ITEM miSaldo        LABEL "Pesquisa Saldo Estoque".


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

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fiCodDeposLocaliz AS CHARACTER FORMAT "X(256)":U 
     LABEL "Dep¢sito Localiza‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE fiCodEstabelLocaliz AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estabelecimento Localiza‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE fiConta AS CHARACTER FORMAT "X(20)" 
     LABEL "Conta Lubrifica‡Æo":R18 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fiDeposito AS CHARACTER FORMAT "x(3)" 
     LABEL "Dep¢sito":R10 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescCausa AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 45.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescComp AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 40.43 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescEvento AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 40.43 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescItem AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 40.43 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescLocal AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 34.29 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescManut AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 40.43 BY .88 NO-UNDO.

DEFINE VARIABLE fiSub AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 1.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttApont.num-docto AT ROW 1.25 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttApont.ep-codigo AT ROW 2.25 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttApont.cod-eqpto AT ROW 3.25 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     fiDescModelo AT ROW 3.25 COL 41.57 COLON-ALIGNED HELP
          "Descri‡Æo Modelo Equipamento" NO-LABEL
     ttApont.dat-movto AT ROW 4.25 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttApont.hra-inicial AT ROW 4.25 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ttApont.hra-final AT ROW 4.25 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     btOK AT ROW 18.79 COL 2
     btSave AT ROW 18.79 COL 13
     btCancel AT ROW 18.79 COL 24
     btHelp AT ROW 18.79 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 18.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 19
         FONT 1.

DEFINE FRAME fPage1
     fiCodDeposLocaliz AT ROW 3.75 COL 74 COLON-ALIGNED WIDGET-ID 8
     fiCodEstabelLocaliz AT ROW 4.75 COL 74 COLON-ALIGNED WIDGET-ID 10
     ttLubr.cod-comptmento AT ROW 1.17 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     fiDescComp AT ROW 1.17 COL 32.57 COLON-ALIGNED HELP
          "Descri‡Æo do Compartimento" NO-LABEL
     ttLubr.it-codigo AT ROW 2.17 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     fiDescItem AT ROW 2.17 COL 32.57 COLON-ALIGNED NO-LABEL
     ttLubr.cod-refer AT ROW 3.17 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttLubr.lote AT ROW 3.17 COL 33.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     fiDeposito AT ROW 3.17 COL 67 COLON-ALIGNED HELP
          "C¢digo do dep¢sito"
     ttLubr.cod-localiz AT ROW 4.17 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     fiDescLocal AT ROW 4.17 COL 38.72 COLON-ALIGNED NO-LABEL
     ttLubr.cod-evento AT ROW 5.17 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     fiDescEvento AT ROW 5.17 COL 32.57 COLON-ALIGNED HELP
          "Descri‡Æo do Evento" NO-LABEL
     ttLubr.cod-causa AT ROW 6.17 COL 18 COLON-ALIGNED
          LABEL "Causa" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     fiDescCausa AT ROW 6.17 COL 27.43 COLON-ALIGNED HELP
          "Descri‡Æo do Evento" NO-LABEL WIDGET-ID 6
     ttLubr.cd-tipo AT ROW 7.17 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     fiDescManut AT ROW 7.17 COL 32.57 COLON-ALIGNED HELP
          "Descri‡Æo do Tipo de Manuten‡Æo" NO-LABEL
     ttLubr.val-quant AT ROW 8.17 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     ttLubr.val-mater-1 AT ROW 9.17 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     ttLubr.log-gera-amostra-oleo AT ROW 8.13 COL 46.72
          VIEW-AS TOGGLE-BOX
          SIZE 16 BY .71
     ttLubr.cod-amostra-fisic AT ROW 8.96 COL 55.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     fiConta AT ROW 10.17 COL 18 COLON-ALIGNED WIDGET-ID 2
     fiSub AT ROW 10.17 COL 38.29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     RECT-20 AT ROW 8.46 COL 44.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.71
         SIZE 84.43 BY 11.04
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttApont T "?" NO-UNDO movfro mab-abastec-lubrific
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttLubr T "?" NO-UNDO movfro mab-item-lubrific
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
         HEIGHT             = 19
         WIDTH              = 90
         MAX-HEIGHT         = 20.46
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 20.46
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
   Custom                                                               */
/* SETTINGS FOR FILL-IN ttLubr.cod-causa IN FRAME fPage1
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN fiCodDeposLocaliz IN FRAME fPage1
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fiCodDeposLocaliz:HIDDEN IN FRAME fPage1           = TRUE.

/* SETTINGS FOR FILL-IN fiCodEstabelLocaliz IN FRAME fPage1
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fiCodEstabelLocaliz:HIDDEN IN FRAME fPage1           = TRUE.

ASSIGN 
       ttLubr.it-codigo:POPUP-MENU IN FRAME fPage1       = MENU pop-item:HANDLE.

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
    run consisteLubrificacao in this-procedure.
    if return-value = "NOK":U then
        return no-apply.
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
    run consisteLubrificacao in this-procedure.
    if return-value = "NOK":U then
        return no-apply.
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttLubr.cd-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.cd-tipo wMaintenanceNoNavigation
ON F5 OF ttLubr.cd-tipo IN FRAME fPage1 /* Tipo Manuten‡Æo */
DO:
        {method/zoomfields.i 
           &ProgramZoom="mnzoom~\z01mn158.w"
           &FieldZoom1="cd-tipo"
           &FieldScreen1="{&ttTable}.cd-tipo"
           &Frame1="fPage1"
           &FieldZoom2="descricao"
           &FieldScreen2="fiDescManut"
           &Frame2="fPage1"
           &EnableImplant="YES"}     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.cd-tipo wMaintenanceNoNavigation
ON LEAVE OF ttLubr.cd-tipo IN FRAME fPage1 /* Tipo Manuten‡Æo */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOManut"
        &KeyValue1="{&ttTable}.cd-tipo:screen-value in frame fPage1"
        &FieldName1="descricao"
        &FieldScreen1="fiDescManut"
        &Frame1="fPage1"}     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.cd-tipo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttLubr.cd-tipo IN FRAME fPage1 /* Tipo Manuten‡Æo */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttLubr.cod-causa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.cod-causa wMaintenanceNoNavigation
ON F5 OF ttLubr.cod-causa IN FRAME fPage1 /* Causa */
DO:
    {method/zoomfields.i 
    &ProgramZoom="mnzoom~\z01mn082.w"
    &FieldZoom1="cd-causa-padr"
    &FieldScreen1="ttLubr.cod-causa"
    &Frame1="fPage1"
    &FieldZoom2="descricao"
    &FieldScreen2="fiDescCausa"
    &Frame2="fPage1"
    &EnableImplant="YES"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.cod-causa wMaintenanceNoNavigation
ON LEAVE OF ttLubr.cod-causa IN FRAME fPage1 /* Causa */
DO:
    {method/ReferenceFields.i
    &HandleDBOLeave="hDBOCausaPadrao"
    &KeyValue1="ttLubr.cod-causa:screen-value in frame fPage1"
    &FieldName1="descricao"
    &FieldScreen1="fiDescCausa"
    &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.cod-causa wMaintenanceNoNavigation
ON LEFT-MOUSE-DBLCLICK OF ttLubr.cod-causa IN FRAME fPage1 /* Causa */
DO:
    {method/zoomfields.i 
    &ProgramZoom="mnzoom~\z01mn082.w"
    &FieldZoom1="cd-causa-padr"
    &FieldScreen1="ttLubr.cod-causa"
    &Frame1="fPage1"
    &FieldZoom2="descricao"
    &FieldScreen2="fiDescCausa"
    &Frame2="fPage1"
    &EnableImplant="YES"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttLubr.cod-comptmento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.cod-comptmento wMaintenanceNoNavigation
ON F5 OF ttLubr.cod-comptmento IN FRAME fPage1 /* Compartimento */
DO:
    assign iEmpresa = {&ttParent}.ep-codigo
           cEqpto   = {&ttParent}.cod-eqpto.

        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr004.w"
           &FieldZoom1="cod-comptmento"
           &FieldScreen1="{&ttTable}.cod-comptmento"
           &Frame1="fPage1"
           &FieldZoom2="des-comptmento"
           &FieldScreen2="fiDescComp"
           &Frame2="fPage1"
           &EnableImplant="NO"}      
           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.cod-comptmento wMaintenanceNoNavigation
ON LEAVE OF ttLubr.cod-comptmento IN FRAME fPage1 /* Compartimento */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOComp"
        &KeyValue1="{&ttTable}.cod-comptmento:screen-value in frame fPage1"
        &FieldName1="des-comptmento"
        &FieldScreen1="fiDescComp"
        &Frame1="fPage1"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.cod-comptmento wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttLubr.cod-comptmento IN FRAME fPage1 /* Compartimento */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME ttApont.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.cod-eqpto wMaintenanceNoNavigation
ON LEAVE OF ttApont.cod-eqpto IN FRAME fpage0 /* Equipamento */
DO:
    run buscaModelo in this-procedure.
    {method\referenceFields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="cCodModelo"
        &FieldName1="des-model"
        &FieldScreen1="fiDescModelo"
        &Frame1="fPage0"}     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttLubr.cod-evento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.cod-evento wMaintenanceNoNavigation
ON ENTRY OF ttLubr.cod-evento IN FRAME fPage1 /* Evento */
DO:
    ASSIGN l-msg-evento = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.cod-evento wMaintenanceNoNavigation
ON F5 OF ttLubr.cod-evento IN FRAME fPage1 /* Evento */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr010.w"
           &FieldZoom1="cod-evento"
           &FieldScreen1="{&ttTable}.cod-evento"
           &Frame1="fPage1"
           &FieldZoom2="des-evento"
           &FieldScreen2="fiDescEvento"
           &Frame2="fPage1"
           &RunMethod="run setaFiltro in hProgramZoom (yes, yes, no, no , no, no)."     
           &EnableImplant="YES"}       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.cod-evento wMaintenanceNoNavigation
ON LEAVE OF ttLubr.cod-evento IN FRAME fPage1 /* Evento */
DO:
    {method/referenceFields.i
        &HandleDBOLeave="hDBOEvento"
        &KeyValue1="{&ttTable}.cod-evento:screen-value in frame fPage1"
        &FieldName1="des-evento"
        &FieldScreen1="fiDescEvento"
        &Frame1="fPage1"}    
        
        IF l-mao-impl AND pcAction = "ADD":U THEN DO:
            FIND FIRST mab-param WHERE mab-param.cdn-param = 40 NO-LOCK NO-ERROR.
            IF AVAIL mab-param AND mab-param.des-valor = {&ttTable}.cod-evento:screen-value in frame fPage1 THEN DO:
                ASSIGN {&ttTable}.log-gera-amostra-oleo:sensitive in frame fPage1 = YES.
                APPLY "value-changed":U TO {&ttTable}.log-gera-amostra-oleo IN FRAME fPage1.
            END.
            ELSE
                ASSIGN {&ttTable}.log-gera-amostra-oleo:sensitive in frame fPage1 = NO
                       {&ttTable}.cod-amostra-fisic:sensitive in frame fPage1     = NO.
        END. /*IF l-mao-impl THEN DO:*/
        ELSE
            ASSIGN {&ttTable}.log-gera-amostra-oleo:sensitive in frame fPage1 = NO
                   {&ttTable}.cod-amostra-fisic:sensitive in frame fPage1     = NO.

        FIND FIRST mab-param WHERE mab-param.cdn-param = 56 NO-LOCK NO-ERROR.
        IF AVAIL mab-param THEN DO:
            IF mab-param.des-valor = "1" THEN DO:
                FIND FIRST mab-param WHERE mab-param.cdn-param = 18 NO-LOCK NO-ERROR.
                IF AVAIL mab-param AND mab-param.des-valor = {&ttTable}.cod-evento:SCREEN-VALUE IN FRAME fPage1 THEN DO:
                    IF  {&ttTable}.cod-causa :SCREEN-VALUE IN FRAME fPage1 = "" THEN DO:
                        IF l-msg-evento = YES THEN
                            RUN utp/ut-msgs.p (INPUT 'SHOW':U,
                                               INPUT 54033,
                                               INPUT RETURN-VALUE).
                    END.
                END.
            END.
        END.
        ELSE DO:
            {utp/ut-liter.i "Exibe Mensagem de Advertˆncia sobre a importƒncia de preencher o Campo Causa (AB0302)"}
            ASSIGN c-desc = RETURN-VALUE.
            {utp/ut-liter.i "Exibe Mensagem de Advertˆncia Campo Causa (AB0302)"}
            ASSIGN c-label = RETURN-VALUE.

            CREATE mab-param.
            ASSIGN mab-param.cdn-param       = 56
                   mab-param.des-param       = c-desc
                   mab-param.des-label-param = c-label
                   mab-param.des-valor       = "1"
                   mab-param.cod-modulo      = "MAB".
        END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.cod-evento wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttLubr.cod-evento IN FRAME fPage1 /* Evento */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttLubr.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.cod-localiz wMaintenanceNoNavigation
ON F5 OF ttLubr.cod-localiz IN FRAME fPage1 /* Localiza‡Æo */
DO:
   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom="inzoom/z01in189.w"
                      &campo={&ttTable}.cod-localiz
                      &campozoom=cod-localiz
                      &frame=fPage1
                      &campo2=fiDescLocal
                      &campozoom2=descricao
                      &frame2=fPage1
                      &campo3=fiCodEstabelLocaliz
                      &campozoom3=cod-estabel
                      &frame3=fPage1
                      &campo4=fiCodDeposLocaliz
                      &campozoom4=cod-depos
                      &frame4=fPage1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.cod-localiz wMaintenanceNoNavigation
ON LEAVE OF ttLubr.cod-localiz IN FRAME fPage1 /* Localiza‡Æo */
DO:
  /** Busca a descri‡Æo da localiza‡Æo **/
  assign fiDescLocal = "".
  FIND FIRST bfMabPosto
       WHERE bfMabPosto.cod-posto = ttApont.cod-posto NO-LOCK NO-ERROR.
  IF  AVAIL bfMabPosto THEN DO:
      IF  {&ttTable}.cod-localiz:SENSITIVE IN FRAME fPage1 = TRUE THEN DO:
          IF  fiCodEstabelLocaliz:SCREEN-VALUE IN FRAME fPage1 <> "" AND fiCodEstabelLocaliz:SCREEN-VALUE IN FRAME fPage1 <> bfMabPosto.cod-estabel THEN DO:
              {utp/ut-liter.i "Estabelecimento_da_Localiza‡Æo"}
              ASSIGN c-msg-aux = RETURN-VALUE.
              {utp/ut-liter.i "Estabelecimento_do_Posto"}
              ASSIGN c-msg-aux = c-msg-aux + "~~" + RETURN-VALUE.
              RUN utp/ut-msgs.p (INPUT "show":U,
                                 INPUT 17399,
                                 INPUT c-msg-aux).
              RETURN NO-APPLY.
          END.
          IF  fiCodDeposLocaliz:SCREEN-VALUE IN FRAME fPage1 <> "" AND fiCodDeposLocaliz:SCREEN-VALUE IN FRAME fPage1 <> bfMabPosto.cod-depos THEN DO:
              {utp/ut-liter.i "Deposito_da_Localiza‡Æo"}
              ASSIGN c-msg-aux = RETURN-VALUE.
              {utp/ut-liter.i "Deposito_do_Posto"}
              ASSIGN c-msg-aux = c-msg-aux + "~~" + RETURN-VALUE.
              RUN utp/ut-msgs.p (INPUT "show":U,
                                 INPUT 17399,
                                 INPUT c-msg-aux).
              RETURN NO-APPLY.
          END.
      END.
      FOR FIRST localizacao FIELDS(descricao)
          WHERE localizacao.cod-estabel = bfMabPosto.cod-estabel
          AND   localizacao.cod-depos   = bfMabPosto.cod-depos
          AND   localizacao.cod-localiz = {&ttTable}.cod-localiz:SCREEN-VALUE IN FRAME fPage1 NO-LOCK:
          ASSIGN fiDescLocal = localizacao.descricao.
      END.
  END.
  display fiDescLocal with frame fPage1.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.cod-localiz wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttLubr.cod-localiz IN FRAME fPage1 /* Localiza‡Æo */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttLubr.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.cod-refer wMaintenanceNoNavigation
ON F5 OF ttLubr.cod-refer IN FRAME fPage1 /* Referˆncia Item */
DO:
   {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                    &campo={&ttTable}.cod-refer
                    &campozoom=cod-refer
                    &parametros="run pi-seta-inicial in wh-pesquisa
                    ({&tttable}.it-codigo:screen-value in frame fPage1)."}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.cod-refer wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttLubr.cod-refer IN FRAME fPage1 /* Referˆncia Item */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiConta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiConta wMaintenanceNoNavigation
ON ENTRY OF fiConta IN FRAME fPage1 /* Conta Lubrifica‡Æo */
DO:
    ASSIGN fiConta:FORMAT IN FRAME fPage1 = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiConta wMaintenanceNoNavigation
ON F5 OF fiConta IN FRAME fPage1 /* Conta Lubrifica‡Æo */
DO:
    IF NOT VALID-HANDLE(h_api_cta_ctbl) OR
        h_api_cta_ctbl:TYPE      <> "PROCEDURE":U OR
        h_api_cta_ctbl:FILE-NAME <> "prgint/utb/utb743za.py":U THEN DO:
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.    
    END.
    
    ASSIGN  cEmpresaEstab = INPUT FRAME fPage0 ttApont.ep-codigo
            dDtMovimento  = INPUT FRAME fPage0 ttApont.dat-movto.

    RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  cEmpresaEstab,       /* EMPRESA PADRÇO DO USUµRIO*/
                                                   INPUT  "CEP",               /* MODULO */                                                  
                                                   INPUT  "",                  /* PLANO DE CONTAS */
                                                   INPUT  v_cod_finalid,       /* FINALIDADES */
                                                   INPUT  dDtMovimento,        /* DATA TRANSACAO */
                                                   OUTPUT v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                   OUTPUT v_des_cta_ctbl,      /* DESCRICAO CONTA */
                                                   OUTPUT v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).  /* ERROS */
    
    IF v_cod_cta_ctbl <> "" THEN
                ASSIGN fiConta:SCREEN-VALUE IN FRAME fPage1 = v_cod_cta_ctbl.
    
    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.

    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        DELETE OBJECT h_api_cta_ctbl.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiConta wMaintenanceNoNavigation
ON LEAVE OF fiConta IN FRAME fPage1 /* Conta Lubrifica‡Æo */
DO:
    ASSIGN dDtMovimento  = INPUT FRAME fPage0 ttApont.dat-movto
           cEmpresaEstab = INPUT FRAME fPage0 ttApont.ep-codigo.

    {cdp/cdunif001a.i fiConta fiSub fPage1 dDtMovimento cEmpresaEstab cEstabEqpto}
        
    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiConta wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fiConta IN FRAME fPage1 /* Conta Lubrifica‡Æo */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiSub
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSub wMaintenanceNoNavigation
ON ENTRY OF fiSub IN FRAME fPage1
DO:
  ASSIGN fiSub:FORMAT IN FRAME fPage1 = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSub wMaintenanceNoNavigation
ON F5 OF fiSub IN FRAME fPage1
DO:

    IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    ASSIGN  cEmpresaEstab  = INPUT FRAME fPage0 ttApont.ep-codigo
            dDtMovimento   = INPUT FRAME fPage0 ttApont.dat-movto
            v_cod_cta_ctbl = INPUT FRAME fPage1 fiConta.
                        
    RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto( INPUT cEmpresaEstab,         /*Empresa*/
                                                   INPUT "",                    /*Estabelecimento */
                                                   INPUT YES,                   /*Considera Todos os Estabelecimentos ?*/
                                                   INPUT "",                    /*Unidade de Neg¢cio*/
                                                   INPUT "",                    /*Plano de Contas*/
                                                   INPUT v_cod_cta_ctbl,        /*C¢digo da Conta*/
                                                   INPUT "",                    /*C¢digo do Plano de Centro de Custo*/
                                                   INPUT dDtMovimento,          /*Data da Transa‡Æo*/
                                                   OUTPUT v_cod_ccusto,         /*C¢digo CCusto*/
                                                   OUTPUT v_des_ccusto,         /*Descri‡Æo CCusto*/
                                                   OUTPUT TABLE tt_log_erro ).  /*Erros*/

    ASSIGN fiSub:SCREEN-VALUE IN FRAME fPage1 = v_cod_ccusto.

    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.

    IF VALID-HANDLE(h_api_ccusto) THEN DO:
        DELETE OBJECT h_api_ccusto.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSub wMaintenanceNoNavigation
ON LEAVE OF fiSub IN FRAME fPage1
DO:
    IF fiSub:SCREEN-VALUE IN FRAME fPage1 <> "" THEN
        ASSIGN fiSub:FORMAT IN FRAME fPage1 = p_cod_format_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSub wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fiSub IN FRAME fPage1
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttLubr.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.it-codigo wMaintenanceNoNavigation
ON F5 OF ttLubr.it-codigo IN FRAME fPage1 /* Item */
DO:
  apply "CHOOSE":U to menu-item miMaterial in menu pop-item.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.it-codigo wMaintenanceNoNavigation
ON LEAVE OF ttLubr.it-codigo IN FRAME fPage1 /* Item */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOItem"
        &KeyValue1="{&tttable}.it-codigo:screen-value in frame fPage1"
        &FieldName1="desc-item"
        &FieldScreen1="fiDescItem"
        &Frame1="fPage1"}
        
    /** Verifica se item est  associado a um tipo de material **/
    if input frame fPage1 {&tttable}.it-codigo <> "" then do:
        run emptyRowErrors in {&hDBOTable}.
        run validaItem in {&hDBOTable} (input input frame fPage0 {&ttParent}.ep-codigo,
                                        input input frame fPage0 {&ttParent}.cod-eqpto,
                                        input input frame fPage1 {&ttTable}.cod-comptmento,
                                        input input frame fPage1 {&tttable}.it-codigo).
        if return-value = "NOK":U then do:
            run piMostraErros in this-procedure.
        end.
    end.
        
    /** Procedure que verifica atributos do item **/
    if iTpPosto = 1 then
        run piItem in this-procedure (input {&ttParent}.cod-posto,
                                      input pcAction).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.it-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttLubr.it-codigo IN FRAME fPage1 /* Item */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttLubr.log-gera-amostra-oleo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.log-gera-amostra-oleo wMaintenanceNoNavigation
ON VALUE-CHANGED OF ttLubr.log-gera-amostra-oleo IN FRAME fPage1 /* Gera Amostra àleo */
DO:
  IF ttLubr.log-gera-amostra-oleo:checked in frame fPage1 THEN
     ASSIGN ttLubr.cod-amostra-fisic:sensitive in frame fPage1 = YES.
  else
     ASSIGN ttLubr.cod-amostra-fisic:sensitive in frame fPage1 = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttLubr.lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.lote wMaintenanceNoNavigation
ON F5 OF ttLubr.lote IN FRAME fPage1 /* Lote */
DO:
  ASSIGN c-it-codigo = {&tttable}.it-codigo:screen-value IN FRAME fPage1
         c-estab     = "".

  {include/zoomvar.i
    &prog-zoom="inzoom/z02in403.w"
    &campo={&ttTable}.lote
    &campozoom=lote}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.lote wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttLubr.lote IN FRAME fPage1 /* Lote */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miItem wMaintenanceNoNavigation
ON CHOOSE OF MENU-ITEM miItem /* Pesquisa Itens */
DO:
        {method/zoomfields.i 
           &ProgramZoom="inzoom~\z20in172.w"
           &FieldZoom1="it-codigo"
           &FieldScreen1="{&tttable}.it-codigo"
           &Frame1="fPage1"
           &FieldZoom2="desc-item"
           &FieldScreen2="fiDescItem"
           &Frame2="fPage1"
           &EnableImplant="YES"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miMaterial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miMaterial wMaintenanceNoNavigation
ON CHOOSE OF MENU-ITEM miMaterial /* Pesquisa Itens do Tipo Material */
DO:
    assign cTipoMaterial = "".

    for first mab-comptmento-eqpto fields(cod-tip-mater)
        where mab-comptmento-eqpto.ep-codigo      = input frame fPage0 {&ttParent}.ep-codigo
        and   mab-comptmento-eqpto.cod-eqpto      = input frame fPage0 {&ttParent}.cod-eqpto 
        and   mab-comptmento-eqpto.cod-comptmento = input frame fPage1 {&ttTable}.cod-comptmento no-lock:
        assign cTipoMaterial = mab-comptmento-eqpto.cod-tip-mater.
    end.
    
        {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr027.w"
           &FieldZoom1="it-codigo"
           &FieldScreen1="{&tttable}.it-codigo"
           &Frame1="fPage1"
           &FieldZoom2="desc-item"
           &FieldScreen2="fiDescItem"
           &Frame2="fPage1"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miSaldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miSaldo wMaintenanceNoNavigation
ON CHOOSE OF MENU-ITEM miSaldo /* Pesquisa Saldo Estoque */
DO:
  {include/zoomvar.i
    &prog-zoom="inzoom/z01in403.w"
    &campo={&tttable}.it-codigo
    &campozoom=it-codigo
    &frame=fPage1
    &campo2=fiDescItem
    &campozoom2=desc-item
    &frame2=fPage1}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttLubr.val-quant
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubr.val-quant wMaintenanceNoNavigation
ON LEAVE OF ttLubr.val-quant IN FRAME fPage1 /* Quantidade */
DO:
    if ttApont.idi-integr = 1 then do:
       run piPrecoItem in this-procedure (ttApont.cod-posto).

       if return-value = "OK":U then do:
         assign ttLubr.val-mater-1 = input frame fPage1 ttLubr.val-quant * dePrecoMater.
         display ttLubr.val-mater-1  with frame fPage1.
       end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}


{&ttTable}.cod-comptmento:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in frame fPage1.
{&tttable}.it-codigo:load-mouse-pointer("image/rbm.cur":u)        in frame fPage1.
{&ttTable}.cod-refer:LOAD-MOUSE-POINTER("image~\lupa.cur":U)      in frame fPage1.
{&ttTable}.cod-localiz:LOAD-MOUSE-POINTER("image~\lupa.cur":U)    in frame fPage1.
{&ttTable}.lote:LOAD-MOUSE-POINTER("image~\lupa.cur":U)           in frame fPage1.
{&ttTable}.cod-evento:LOAD-MOUSE-POINTER("image~\lupa.cur":U)     in frame fPage1.
{&ttTable}.cd-tipo:LOAD-MOUSE-POINTER("image~\lupa.cur":U)        in frame fPage1.
{&ttTable}.cod-causa:LOAD-MOUSE-POINTER("image/lupa.cur":U)     in frame fPage1.
fiConta:LOAD-MOUSE-POINTER("image/lupa.cur":U)                    in frame fPage1.
fiSub:LOAD-MOUSE-POINTER("image/lupa.cur":U)                      in frame fPage1.

{abp\ab0302.i fPage1}  /** Procedure piItem **/
{abp/ab9001.i}   /** piConverteMoeda  **/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) finaliza‡Æo do programa
------------------------------------------------------------------------------*/
/** Equipamento **/
if valid-handle(hDBOEqpto) then
    run Destroy in hDBOEqpto.
/** Modelo **/
if valid-handle(hDBOModelo) then
    run Destroy in hDBOModelo.
/** Compartimento **/
if valid-handle(hDBOComp) then
    run Destroy in hDBOComp.
/** Item **/
if valid-handle(hDBOItem) then
    run Destroy in hDBOItem.
/** Evento **/
if valid-handle(hDBOEvento) then
    run Destroy in hDBOEvento.
/** Tipo Manuten‡Æo  **/
if valid-handle(hDBOManut) then
    run Destroy in hDBOManut.
/** Posto **/
if valid-handle(hDBOPosto) then
    run Destroy in hDBOPosto.
/** Causa **/
if valid-handle(hDBOCausaPadrao) then
    run Destroy in hDBOCausaPadrao.

{method/showmessage.i3}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     afterDisplayFields
  Parameters:  <none>
  Notes:       Override (ap¢s) mostrar campos em tela
------------------------------------------------------------------------------*/
    FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
        /* Busca Estabelecimento para utilizar no leave da conta contabil */
        FOR LAST  bfHistAtiv FIELDS(cod-ativid cc-codigo ct-codigo cod-unid-negoc cod-estabel)
            WHERE bfHistAtiv.ep-codigo = ttApont.ep-codigo
            AND   bfHistAtiv.cod-eqpto = ttApont.cod-eqpto
            AND   bfHistAtiv.dat-cadastro <= ttApont.dat-movto NO-LOCK:
            ASSIGN cEstabEqpto = bfHistAtiv.cod-estabel.
        END.
                                                              
        IF  mab-param.des-valor = "1" THEN DO:
            IF  pcAction = "ADD":U THEN DO:
                ASSIGN fiConta = {&ttParent}.cod-cta-ctbl-lubrific
                       fiSub   = {&ttParent}.cod-ccusto-lubrific.
            END.
            ELSE DO:
                ASSIGN fiConta:FORMAT IN FRAME fPage1 = "x(20)"
                       fiConta = {&ttTable}.cod-cta-ctbl
                       fiSub:FORMAT IN FRAME fPage1 = "x(20)"
                       fiSub   = {&ttTable}.cod-ccusto.
            END.
        END.
        DISPLAY fiConta fiSub WITH FRAME fPage1.

        APPLY "ENTRY":U TO fiConta               IN FRAME fPage1.
        APPLY "LEAVE":U TO fiConta               IN FRAME fPage1.
        APPLY "ENTRY":U TO fiSub                 IN FRAME fPage1.
        APPLY "LEAVE":U TO fiSub                 IN FRAME fPage1.
    END.

    /** Mostra C¢digo Dep¢sito em tela **/
    run buscaDeposito in this-procedure.
    
    /** Habilita / Desabilita campos em tela **/
    run piPosto in this-procedure.
    
    /** Descri‡äes dos campos **/
    apply "LEAVE":U to {&ttParent}.cod-eqpto     in frame fPage0.
    apply "LEAVE":U to {&tttable}.it-codigo      in frame fPage1.
    apply "LEAVE":U to {&ttTable}.cod-evento     in frame fPage1.
    apply "LEAVE":U to {&ttTable}.cd-tipo        in frame fPage1.
    apply "LEAVE":U to {&ttTable}.cod-comptmento in frame fPage1.
    apply "LEAVE":U to {&ttTable}.cod-localiz    in frame fPage1.
    apply "LEAVE":U to {&ttTable}.cod-causa      in frame fPage1.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) inicializa‡Æo de tela
------------------------------------------------------------------------------*/
    /** Busca o tipo de valor do material **/
    for first mab-param fields(des-valor)
        where mab-param.cdn-param = 10 no-lock:
        assign iTpValor = int(mab-param.des-valor).
    end.

    /** Verifica se posto ‚ pr¢prio ou de terceiro **/
    run buscaTipoPosto in {&hDBOTable} (input  {&ttParent}.cod-posto,
                                        output iTpPosto).

    if pcAction = "UPDATE":U then do:
        if (iTpValor = 2 or iTpValor = 3) and
            iTpPosto = 1 then do:
            assign {&ttTable}.val-mater-1:sensitive in frame fPage1 = no.
        end.
        /** Desabilita campos d chave prim ria **/
        assign {&ttTable}.cod-comptmento:sensitive in frame fPage1 = no
               {&tttable}.it-codigo:sensitive in frame fPage1      = no.
        apply "LEAVE":U to {&tttable}.it-codigo    in frame fPage1.

    end.
    /**Verifica se o mao esta implantado no sistema**/
    RUN cdp/cd9902.p (INPUT 6 ).
    IF RETURN-VALUE = "OK":U THEN
        ASSIGN l-mao-impl = YES.

    /**Habilita os campos na frame**/
    IF l-mao-impl = NO THEN DO:
       ASSIGN {&ttTable}.log-gera-amostra-oleo:SENSITIVE IN FRAME fpage1 = NO
              {&ttTable}.log-gera-amostra-oleo:HIDDEN IN FRAME fpage1    = YES
              {&ttTable}.cod-amostra-fisic:SENSITIVE IN FRAME fpage1     = NO
              {&ttTable}.cod-amostra-fisic:HIDDEN IN FRAME fpage1        = YES.
              HIDE rect-20 IN FRAME fPage1.
    end.
    else do:
       ASSIGN {&ttTable}.log-gera-amostra-oleo:HIDDEN IN FRAME fpage1 = no
              {&ttTable}.log-gera-amostra-oleo:SENSITIVE IN FRAME fpage1 = YES
              {&ttTable}.cod-amostra-fisic:HIDDEN IN FRAME fpage1     = no.
        apply "leave":U to {&ttTable}.cod-evento  in frame fPage1.
    end.

    EMPTY TEMP-TABLE tt_log_erro.
    
    IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.  
    IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
    
    ASSIGN dDtMovimento = INPUT FRAME fPage0 ttApont.dat-movto.
    
    RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT "",  /* EMPRESA EMS2 */
                                                   INPUT "",          /* PLANO CCUSTO */
                                                   INPUT dDtMovimento,               /* DATA DE TRANSACAO */
                                                   OUTPUT p_cod_format_ccusto,      /* FORMATO CCUSTO */
                                                   OUTPUT TABLE tt_log_erro). /* ERROS */
    
    
    RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT "",
                                                       INPUT "",
                                                       INPUT dDtMovimento,
                                                       OUTPUT p_cod_format_cta_ctbl,
                                                       OUTPUT TABLE tt_log_erro).
    
    IF VALID-HANDLE(h_api_ccusto) THEN DELETE OBJECT h_api_ccusto.
    IF VALID-HANDLE(h_api_ccusto) THEN DELETE OBJECT h_api_ccusto.
    
    ASSIGN fiConta:FORMAT IN FRAME fPage1 = p_cod_format_cta_ctbl
           fiSub:FORMAT IN FRAME fPage1   = p_cod_format_ccusto.
    
    
    assign v_cod_finalid = {adinc/i05ad049.i 4 1 }                       /* 1 - Consumo       */ 
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 3}  /* 3 - Ordem servi¯o */ 
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 5}. /* 5 - MÊo-de-obra   */ 
    
    APPLY "ENTRY":U TO fiConta               IN FRAME fPage1.
    APPLY "LEAVE":U TO fiConta               IN FRAME fPage1.
    APPLY "ENTRY":U TO fiSub                 IN FRAME fPage1.
    APPLY "LEAVE":U TO fiSub                 IN FRAME fPage1.
    APPLY "ENTRY":U TO ttLubr.cod-comptmento IN FRAME fPage1.

    FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
        IF mab-param.des-valor = "2" THEN DO:
            ASSIGN fiConta:SENSITIVE IN FRAME fPage1 = NO
                   fiSub:SENSITIVE   IN FRAME fPage1 = NO.
        END.
    END.
    IF NOT AVAIL mab-param THEN DO:
        ASSIGN fiConta:SENSITIVE IN FRAME fPage1 = NO
               fiSub:SENSITIVE   IN FRAME fPage1 = NO.
    END.

    IF pcAction = "ADD" THEN
        APPLY "ENTRY":U TO ttLubr.cod-comptmento IN FRAME fPage1.
    ELSE DO:
        APPLY "ENTRY":U TO ttLubr.cod-localiz IN FRAME fPage1.

        IF ttLubr.cod-localiz:SENSITIVE IN FRAME fPage1 = NO AND
           ttLubr.cod-evento:SENSITIVE IN FRAME fPage1 = YES THEN
            APPLY "ENTRY":U TO ttLubr.cod-evento IN FRAME fPage1.
    END.
        
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override (antes) inicializa‡Æo de tela
------------------------------------------------------------------------------*/
/** Inicializa‡Æo das DBOs **/
run initializeDBOs in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenanceNoNavigation 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     beforeSaveFields
  Parameters:  <none>
  Notes:       Override (antes) de salvar registro em tabela
------------------------------------------------------------------------------*/

    /** Busca Valores para Moedas Alternativas **/
    run piConverteMoeda in this-procedure (input  input frame fPage1 {&ttTable}.val-mater-1,
                                           output {&ttTable}.val-mater-2,
                                           output {&ttTable}.val-mater-3,
                                           input  {&ttParent}.dat-movto).
    
    /** Atualiza o campo hora invertida **/
    assign {&ttTable}.val-dat-hora-invrtda = {&ttParent}.val-dat-hora-invrtda.


    FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
        IF  mab-param.des-valor = "1" THEN DO:
            /** Atualiza os campos de conta e centro de custo **/
            ASSIGN {&ttTable}.cod-cta-ctbl = INPUT FRAME fPage1 fiConta
                   {&ttTable}.cod-ccusto   = INPUT FRAME fPage1 fiSub.
        END.
    END.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaDeposito wMaintenanceNoNavigation 
PROCEDURE buscaDeposito :
/*------------------------------------------------------------------------------
  Purpose:     buscaDeposito
  Parameters:  <none>
  Notes:       Busca o C¢digo do dep¢sito pelo posto do apontamento.
------------------------------------------------------------------------------*/
{method\referenceFields.i
    &HandleDBOLeave="hDBOPosto"
    &KeyValue1="{&ttParent}.cod-posto"
    &FieldName1="cod-depos"
    &FieldScreen1="fiDeposito"
    &Frame1="fPage1"}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaModelo wMaintenanceNoNavigation 
PROCEDURE buscaModelo :
/*------------------------------------------------------------------------------
  Purpose:     buscaModelo
  Parameters:  <none>
  Notes:       Busca o c¢digo do modelo no equipamento
------------------------------------------------------------------------------*/

{method\referenceFields.i
    &HandleDBOLeave="hDBOEqpto"
    &KeyValue1="input frame fPage0 {&ttParent}.ep-codigo"
    &KeyValue2="input frame fPage0 {&ttParent}.cod-eqpto"
    &FieldName1="cod-model"
    &Variable1="cCodModelo"}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consisteLubrificacao wMaintenanceNoNavigation 
PROCEDURE consisteLubrificacao :
/*------------------------------------------------------------------------------
  Purpose:     consisteLubrificacao
  Parameters:  <none>
  Notes:       Valida / consiste apontamento lubrifica‡Æo
------------------------------------------------------------------------------*/
define variable deTanque as decimal no-undo.

/** Grava Tipo de Material **/
run buscaTipoMaterial in {&hDBOTable} (input  input frame fPage0 {&ttParent}.ep-codigo,
                                       input  input frame fPage0 {&ttParent}.cod-eqpto,
                                       input  input frame fPage1 {&ttTable}.cod-comptmento,
                                       input  input frame fPage1 {&tttable}.it-codigo,
                                       output {&ttTable}.cod-tip-mater,
                                       output deTanque).
/** Verifica se quantidade est  maior que capacidade **/
if deTanque < input frame fPage1 {&ttTable}.val-quant then do:
    {utp/ut-liter.i "Compartimento"}
    run utp/ut-msgs.p (input "SHOW":U,
                       input 28612,
                       input return-value + '~~' + string(deTanque)).
    if return-value = "NO":U then do:
        apply "ENTRY":U to {&ttTable}.val-quant in frame fPage1.
        return "NOK":U.
    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa as BOs
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*--- DBO Equipamento ---*/
    IF NOT VALID-HANDLE(hDBOEqpto) OR
       hDBOEqpto:TYPE <> "PROCEDURE":U OR
       hDBOEqpto:FILE-NAME <> "frbo~\bofr007.p":U THEN DO:
        run frbo/bofr007.p persistent set  hDBOEqpto.
    END.
    
    RUN openQueryStatic IN hDBOEqpto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo~\bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

    /*--- DBO Compartimento ---*/
    IF NOT VALID-HANDLE(hDBOComp) OR
       hDBOComp:TYPE <> "PROCEDURE":U OR
       hDBOComp:FILE-NAME <> "frbo~\bofr003.p":U THEN DO:
        run frbo/bofr003.p persistent set  hDBOComp.
    END.
    
    RUN openQueryStatic IN hDBOComp (INPUT "Main":U) NO-ERROR.

    /*--- DBO Item ---*/
    IF NOT VALID-HANDLE(hDBOItem) OR
       hDBOItem:TYPE <> "PROCEDURE":U OR
       hDBOItem:FILE-NAME <> "inbo~\boin172.p":U THEN DO:
        run inbo/boin172.p persistent set  hDBOItem.
    END.
    
    RUN openQueryStatic IN hDBOItem (INPUT "Main":U) NO-ERROR.

    /*--- DBO Evento ---*/
    IF NOT VALID-HANDLE(hDBOEvento) OR
       hDBOEvento:TYPE <> "PROCEDURE":U OR
       hDBOEvento:FILE-NAME <> "frbo~\bofr010.p":U THEN DO:
        run frbo/bofr010.p persistent set  hDBOEvento.
    END.
    
    RUN openQueryStatic IN hDBOEvento (INPUT "Main":U) NO-ERROR.

    /*--- DBO Tipo Manuten‡Æo ---*/
    IF NOT VALID-HANDLE(hDBOManut) OR
       hDBOManut:TYPE <> "PROCEDURE":U OR
       hDBOManut:FILE-NAME <> "mnbo~\bomn158.p":U THEN DO:
        run mnbo/bomn158.p persistent set  hDBOManut.
    END.
    
    RUN openQueryStatic IN hDBOManut (INPUT "Default":U) NO-ERROR.

    /*--- DBO Posto  ---*/
    IF NOT VALID-HANDLE(hDBOPosto) OR
       hDBOPosto:TYPE <> "PROCEDURE":U OR
       hDBOPosto:FILE-NAME <> "frbo~\bofr021.p":U THEN DO:
        run frbo/bofr021.p persistent set  hDBOPosto.
    END.
    
    RUN openQueryStatic IN hDBOPosto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Causa ---*/
    IF NOT VALID-HANDLE(hDBOCausaPadrao) OR
      hDBOCausaPadrao:TYPE <> "PROCEDURE":U OR
      hDBOCausaPadrao:FILE-NAME <> "mnbo~\bomn082.p":U THEN DO:
       run mnbo/bomn082.p persistent set  hDBOCausaPadrao.
    END.

   RUN openQueryStatic IN  hDBOCausaPadrao (INPUT "Default":U) NO-ERROR.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraErros wMaintenanceNoNavigation 
PROCEDURE piMostraErros :
/*------------------------------------------------------------------------------
  Purpose:     piMostraErros
  Parameters:  <none>
  Notes:       Verifica a temp-table de erros da BO e mostra em tela as mensagens
------------------------------------------------------------------------------*/

empty temp-table RowErrors.
/** Instancia aplicativo **/
{method/showmessage.i1}
/** Busca erros na BO **/
run getRowErrors in {&hDBOTable} (output table RowErrors).
/** Mostra caixa com erros **/
{method/showmessage.i2 &Modal="YES"}
/** Limpa temp-tables de erros **/
run emptyRowErrors in {&hDBOTable}.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPosto wMaintenanceNoNavigation 
PROCEDURE piPosto :
/*------------------------------------------------------------------------------
  Purpose:     piPosto
  Parameters:  <none>
  Notes:       Verifica tipo de posto para habilitar em tela campos
               Obs: Se for de terceiro, deve-se gravar campos em branco,
                    Se for pr¢prio, deve-se deixar habilitado em tela para
                    o usu rio informar conforme item.
------------------------------------------------------------------------------*/
/** Verifica se posto ‚ pr¢prio ou de terceiro **/
run buscaTipoPosto in {&hDBOTable} (input  {&ttParent}.cod-posto,
                                    output iTpPosto).
case iTpPosto:
    /** Terceiro **/
    when 2 then do:
        assign {&ttTable}.cod-localiz = ""
               {&ttTable}.cod-localiz:sensitive in frame fPage1 = no
               {&ttTable}.cod-refer = ""
               {&ttTable}.cod-refer:sensitive in frame fPage1   = no
               {&ttTable}.lote = ""
               {&ttTable}.lote:sensitive in frame fPage1        = no
               {&ttTable}.val-mater-1 = if pcAction = "UPDATE":U 
                                        then {&ttTable}.val-mater-1
                                        else 0
               {&ttTable}.val-mater-1:sensitive in frame fPage1 = yes
               {&ttTable}.val-quant = if pcAction = "UPDATE":U 
                                      then {&ttTable}.val-quant
                                      else 0
               {&ttTable}.val-quant:sensitive in frame fPage1   = yes.
        display {&ttTable}.cod-localiz 
                {&ttTable}.cod-refer 
                {&ttTable}.lote 
                {&ttTable}.val-mater-1 
                {&ttTable}.val-quant
            with frame fPage1.
    end.
    /** Pr¢prio **/
    otherwise
        assign {&ttTable}.cod-localiz:sensitive in frame fPage1 = yes
               {&ttTable}.cod-refer:sensitive in frame fPage1   = yes
               {&ttTable}.lote:sensitive in frame fPage1        = yes
               {&ttTable}.val-mater-1:sensitive in frame fPage1 = yes
               {&ttTable}.val-quant:sensitive in frame fPage1   = yes.
end case.

return "OK":U.

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

assign {&ttTable}.num-docto   = {&ttParent}.num-docto
       {&ttTable}.ep-codigo   = {&ttParent}.ep-codigo
       {&ttTable}.cod-eqpto   = {&ttParent}.cod-eqpto.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

