&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttAbast NO-UNDO LIKE mab-item-abastec
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttApont NO-UNDO LIKE mab-abastec-lubrific
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
{include/i-prgvrs.i AB0302B 2.00.00.027 } /*** "010027" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0302b MAB}
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
&GLOBAL-DEFINE Program           AB0302B
&GLOBAL-DEFINE Version        2.00.00.027

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      P g. 1

&GLOBAL-DEFINE ttTable           ttAbast
&GLOBAL-DEFINE hDBOTable         hDBOAbast
&GLOBAL-DEFINE DBOTable          mab-item-abastec

&GLOBAL-DEFINE ttParent          ttApont
&GLOBAL-DEFINE DBOParentTable    hDBOApont

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields ttApont.ep-codigo ttApont.cod-eqpto ~
                                 ttApont.dat-movto ttApont.num-docto ~
                                 ttApont.hra-final ttApont.hra-inicial
&GLOBAL-DEFINE page1Fields       ttAbast.cod-posto ttAbast.cod-bomba ~
                                 ttAbast.it-codigo ttAbast.cod-refer ~
                                 ttAbast.cod-localiz ttAbast.lote ~
                                 ttAbast.val-quant ttAbast.val-mater-1 ~
                                 fiConta fiSub

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cCodModelo   AS CHARACTER                NO-UNDO.
DEFINE VARIABLE dePrecoMater like {&ttTable}.val-mater-1 no-undo.
DEFINE VARIABLE iTpPosto     as integer                  no-undo.
DEFINE VARIABLE iTpValor     as integer                  no-undo.

/** Zoom **/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE    NO-UNDO.

/* Global Variables ---                                                 */
define new global shared variable c-it-codigo   like saldo-estoq.it-codigo            no-undo.
define new global shared variable c-estab       like saldo-estoq.cod-estabel          no-undo.
define new global shared variable cTipoMaterial like mab-tip-mater-item.cod-tip-mater no-undo.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEqpto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOPosto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOItem      AS HANDLE NO-UNDO.

{cdp~/cdcfgman.i} /** Preprocessadores Custeio On-Line **/

{cdp/cdunif001.i} /*vari veis unifica‡Æo de conceito*/
/*unifica‡Æo de conceito - centro de custo e conta contabil*/
DEFINE VARIABLE cEmpresaEstab AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cEstabEqpto   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dDtMovimento  AS DATE        NO-UNDO.

DEFINE VARIABLE c-msg-aux    AS CHARACTER NO-UNDO.

DEFINE BUFFER bfHistAtiv FOR mab-histor-ativid.
DEFINE BUFFER bfMabPosto FOR mab-posto.

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
       MENU-ITEM miSaldo        LABEL "Pesquisa &Saldo Estoque".


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
     LABEL "Conta Abastecimento":R20 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fiDeposito AS CHARACTER FORMAT "x(3)" 
     LABEL "Dep¢sito":R10 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescItem AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescLocal AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescPosto LIKE mab-posto.des-posto
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE fiSub AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.


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
     btOK AT ROW 17.67 COL 2
     btSave AT ROW 17.67 COL 13
     btCancel AT ROW 17.67 COL 24
     btHelp AT ROW 17.67 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 17.42 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.88
         FONT 1.

DEFINE FRAME fPage1
     ttAbast.cod-posto AT ROW 1.25 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     fiDescPosto AT ROW 1.25 COL 30.57 COLON-ALIGNED HELP
          "" NO-LABEL
     ttAbast.cod-bomba AT ROW 2.25 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     fiDeposito AT ROW 2.25 COL 67.57 COLON-ALIGNED HELP
          "C¢digo do dep¢sito"
     ttAbast.it-codigo AT ROW 3.25 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     fiDescItem AT ROW 3.25 COL 30.57 COLON-ALIGNED NO-LABEL
     ttAbast.cod-refer AT ROW 4.25 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiCodDeposLocaliz AT ROW 4.63 COL 73.72 COLON-ALIGNED WIDGET-ID 8
     ttAbast.cod-localiz AT ROW 5.25 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     fiDescLocal AT ROW 5.25 COL 36.43 COLON-ALIGNED NO-LABEL
     fiCodEstabelLocaliz AT ROW 5.63 COL 73.72 COLON-ALIGNED WIDGET-ID 10
     ttAbast.lote AT ROW 6.25 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 40 BY .88
     fiConta AT ROW 7.25 COL 16 COLON-ALIGNED WIDGET-ID 2
     fiSub AT ROW 7.25 COL 36.29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     ttAbast.val-quant AT ROW 8.25 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     ttAbast.val-mater-1 AT ROW 9.25 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.7
         SIZE 84.43 BY 9.92
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttAbast T "?" NO-UNDO movfro mab-item-abastec
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttApont T "?" NO-UNDO movfro mab-abastec-lubrific
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
         HEIGHT             = 17.88
         WIDTH              = 90
         MAX-HEIGHT         = 18.79
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 18.79
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
/* SETTINGS FOR FILL-IN fiCodDeposLocaliz IN FRAME fPage1
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fiCodDeposLocaliz:HIDDEN IN FRAME fPage1           = TRUE.

/* SETTINGS FOR FILL-IN fiCodEstabelLocaliz IN FRAME fPage1
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fiCodEstabelLocaliz:HIDDEN IN FRAME fPage1           = TRUE.

/* SETTINGS FOR FILL-IN fiDescPosto IN FRAME fPage1
   LIKE = mgfro.mab-posto.des-posto EXP-SIZE                            */
ASSIGN 
       ttAbast.it-codigo:POPUP-MENU IN FRAME fPage1       = MENU pop-item:HANDLE.

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
    run consisteAbastecimento in this-procedure.
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
    run consisteAbastecimento in this-procedure.
    if return-value = "NOK":U then
        return no-apply.
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttAbast.cod-bomba
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbast.cod-bomba wMaintenanceNoNavigation
ON F5 OF ttAbast.cod-bomba IN FRAME fPage1 /* Bomba */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr002.w"
           &FieldZoom1="cod-bomba"
           &FieldScreen1="{&ttTable}.cod-bomba"
           &Frame1="fPage1"
           &RunMethod="run setaPosto in hProgramZoom 
                       (input {&ttTable}.cod-posto:screen-value in frame fPage1)."}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbast.cod-bomba wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttAbast.cod-bomba IN FRAME fPage1 /* Bomba */
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
    {method~\referenceFields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="cCodModelo"
        &FieldName1="des-model"
        &FieldScreen1="fiDescModelo"
        &Frame1="fPage0"}     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttAbast.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbast.cod-localiz wMaintenanceNoNavigation
ON F5 OF ttAbast.cod-localiz IN FRAME fPage1 /* Localiza‡Æo */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbast.cod-localiz wMaintenanceNoNavigation
ON LEAVE OF ttAbast.cod-localiz IN FRAME fPage1 /* Localiza‡Æo */
DO:
  /** Busca a descri‡Æo da localiza‡Æo **/
  assign fiDescLocal = "".
  FIND FIRST bfMabPosto
       WHERE bfMabPosto.cod-posto = {&ttTable}.cod-posto:SCREEN-VALUE IN FRAME fPage1 NO-LOCK NO-ERROR.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbast.cod-localiz wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttAbast.cod-localiz IN FRAME fPage1 /* Localiza‡Æo */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAbast.cod-posto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbast.cod-posto wMaintenanceNoNavigation
ON F5 OF ttAbast.cod-posto IN FRAME fPage1 /* Posto */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr021.w"
           &FieldZoom1="cod-posto"
           &FieldScreen1="{&ttTable}.cod-posto"
           &Frame1="fPage1"
           &FieldZoom2="des-posto"
           &FieldScreen2="fiDescPosto"
           &Frame2="fPage1"
           &FieldZoom3="cod-depos"
           &FieldScreen3="fiDeposito"
           &Frame3="fPage1"
           &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbast.cod-posto wMaintenanceNoNavigation
ON LEAVE OF ttAbast.cod-posto IN FRAME fPage1 /* Posto */
DO:
    {method~\referenceFields.i
        &HandleDBOLeave="hDBOPosto"
        &KeyValue1="{&ttTable}.cod-posto:screen-value in frame fPage1"
        &FieldName1="des-posto"
        &FieldScreen1="fiDescPosto"
        &Frame1="fPage1"
        &FieldName2="cod-depos"
        &FieldScreen2="fiDeposito"
        &Frame2="fPage1"}
        
    /** Verifica tipo de posto para habilitar em tela bomba **/
    run piBomba in this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbast.cod-posto wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttAbast.cod-posto IN FRAME fPage1 /* Posto */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAbast.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbast.cod-refer wMaintenanceNoNavigation
ON F5 OF ttAbast.cod-refer IN FRAME fPage1 /* Referˆncia Item */
DO:
   {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                    &campo={&ttTable}.cod-refer
                    &campozoom=cod-refer
                    &parametros="run pi-seta-inicial in wh-pesquisa
                    ({&tttable}.it-codigo:screen-value in frame fPage1)."}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbast.cod-refer wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttAbast.cod-refer IN FRAME fPage1 /* Referˆncia Item */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiConta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiConta wMaintenanceNoNavigation
ON ENTRY OF fiConta IN FRAME fPage1 /* Conta Abastecimento */
DO:
    ASSIGN fiConta:FORMAT IN FRAME fPage1 = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiConta wMaintenanceNoNavigation
ON F5 OF fiConta IN FRAME fPage1 /* Conta Abastecimento */
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
ON LEAVE OF fiConta IN FRAME fPage1 /* Conta Abastecimento */
DO:
    ASSIGN dDtMovimento = INPUT FRAME fPage0 ttApont.dat-movto
           cEmpresaEstab = INPUT FRAME fPage0 ttApont.ep-codigo.
                                                
    {cdp/cdunif001a.i  fiConta fiSub fPage1 dDtMovimento cEmpresaEstab cEstabEqpto}

    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiConta wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fiConta IN FRAME fPage1 /* Conta Abastecimento */
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


&Scoped-define SELF-NAME ttAbast.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbast.it-codigo wMaintenanceNoNavigation
ON F5 OF ttAbast.it-codigo IN FRAME fPage1 /* Item */
DO:
  if iTpPosto = 1 then do:
      apply "CHOOSE":U to menu-item miMaterial in menu pop-item.
  end.
  else do: 
      apply "CHOOSE":U to menu-item miItem in menu pop-item.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbast.it-codigo wMaintenanceNoNavigation
ON LEAVE OF ttAbast.it-codigo IN FRAME fPage1 /* Item */
DO:
    {method~\referenceFields.i
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
                                        input input frame fPage1 {&ttTable}.cod-posto,
                                        input input frame fPage1 {&ttTable}.cod-bomba,
                                        input input frame fPage1 {&tttable}.it-codigo,
                                        input {&ttParent}.dat-movto).
        if return-value = "NOK":U then do:
            run piMostraErros in this-procedure.
        end.
    end.
        
    /** Procedure que verifica atributos do item **/
    if iTpPosto = 1 then
        run piItem in this-procedure (input input frame fPage1 {&ttTable}.cod-posto,
                                      input pcAction).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbast.it-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttAbast.it-codigo IN FRAME fPage1 /* Item */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAbast.lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbast.lote wMaintenanceNoNavigation
ON F5 OF ttAbast.lote IN FRAME fPage1 /* Lote */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbast.lote wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttAbast.lote IN FRAME fPage1 /* Lote */
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
           &EnableImplant="NO"}  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miMaterial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miMaterial wMaintenanceNoNavigation
ON CHOOSE OF MENU-ITEM miMaterial /* Pesquisa Itens do Tipo Material */
DO:
   assign cTipoMaterial = "".
    IF iTpPosto = 1 THEN DO:
        for first mab-bomba fields(cod-tip-mater)
            where mab-bomba.cod-posto = input frame fPage1 {&ttTable}.cod-posto
            and   mab-bomba.cod-bomba = input frame fPage1 {&ttTable}.cod-bomba no-lock:
            assign cTipoMaterial = mab-bomba.cod-tip-mater.
        end.
    END.
    ELSE DO: 
       FOR FIRST mab-histor-combust
            WHERE mab-histor-combust.ep-codigo = INPUT FRAME fpage0 {&ttParent}.ep-codigo
              AND mab-histor-combust.cod-eqpto = INPUT FRAME fpage0 {&ttParent}.cod-eqpto
              AND mab-histor-combust.dat-desativ = ?
              AND mab-histor-combust.idi-tip-consu > 1 NO-LOCK:
           ASSIGN cTipoMaterial = mab-histor-combust.cod-tip-mater.
        END.
    END.
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


&Scoped-define SELF-NAME ttAbast.val-quant
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAbast.val-quant wMaintenanceNoNavigation
ON LEAVE OF ttAbast.val-quant IN FRAME fPage1 /* Qtd Combust¡vel */
DO:     
  if ttApont.idi-integr = 1 then do:
     run piPrecoItem in this-procedure (input input frame fPage1 {&ttTable}.cod-posto).

     if return-value = "OK":U then do:
       assign {&ttTable}.val-mater-1 = input frame fPage1 {&ttTable}.val-quant * dePrecoMater.
       display {&ttTable}.val-mater-1  with frame fPage1.
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


{&ttTable}.cod-posto:LOAD-MOUSE-POINTER("image~\lupa.cur":U)   in frame fPage1.
{&ttTable}.cod-bomba:LOAD-MOUSE-POINTER("image~\lupa.cur":U)   in frame fPage1.
{&tttable}.it-codigo:load-mouse-pointer("image~/rbm.cur":u)   in frame fPage1.
{&ttTable}.cod-refer:LOAD-MOUSE-POINTER("image~\lupa.cur":U)   in frame fPage1.
{&ttTable}.cod-localiz:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in frame fPage1.
{&ttTable}.lote:LOAD-MOUSE-POINTER("image~\lupa.cur":U)        in frame fPage1.
fiConta:LOAD-MOUSE-POINTER("image/lupa.cur":U)              in frame fPage1.
fiSub:LOAD-MOUSE-POINTER("image/lupa.cur":U)                in frame fPage1.

{abp~\ab0302.i fPage1}  /** Procedure piItem **/
{abp~/ab9001.i}   /** piConverteMoeda  **/

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
/** Posto **/
if valid-handle(hDBOPosto) then
    run Destroy in hDBOPosto.
/** Item **/
if valid-handle(hDBOItem) then
    run Destroy in hDBOItem.

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
    APPLY "ENTRY":U TO fiConta IN FRAME fPage1.
    APPLY "ENTRY":U TO fiSub   IN FRAME fPage1.

    FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:

        /* Busca Estabelecimento para utilizar no leave da conta contabil */
        FOR LAST  bfHistAtiv FIELDS(cod-ativid cc-codigo ct-codigo cod-unid-negoc cod-estabel)
            WHERE bfHistAtiv.ep-codigo = ttApont.ep-codigo
            AND   bfHistAtiv.cod-eqpto = ttApont.cod-eqpto
            AND   bfHistAtiv.dat-cadastro <= ttApont.dat-movto NO-LOCK:
            ASSIGN cEstabEqpto = bfHistAtiv.cod-estabel.
        END.

        IF mab-param.des-valor = "1":U THEN DO:
            IF  pcAction = "ADD":U THEN DO:
                ASSIGN fiConta = {&ttParent}.ct-codigo
                       fiSub   = {&ttParent}.cc-codigo.
            END.
            ELSE DO:
                ASSIGN fiConta:FORMAT IN FRAME fPage1 = "x(20)"
                       fiConta = {&ttTable}.cod-cta-ctbl
                       fiSub:FORMAT IN FRAME fPage1 = "x(20)"
                       fiSub   = {&ttTable}.cod-ccusto.
            END.
        END.
    END.

    DISPLAY fiConta fiSub WITH FRAME fPage1.

    APPLY "ENTRY":U TO fiConta IN FRAME fPage1.
    APPLY "LEAVE":U TO fiConta IN FRAME fPage1.
    APPLY "ENTRY":U TO fiSub   IN FRAME fPage1.
    APPLY "LEAVE":U TO fiSub   IN FRAME fPage1.

    /** Posto Abastecimento **/
    RUN piPosto IN THIS-PROCEDURE.
    
    /** Descri‡äes dos campos **/
    APPLY "LEAVE":U TO {&ttParent}.cod-eqpto   IN FRAME fPage0.
    APPLY "LEAVE":U TO {&ttTable}.cod-posto    IN FRAME fPage1.
    APPLY "LEAVE":U TO {&ttTable}.cod-bomba    IN FRAME fPage1.
    APPLY "LEAVE":U TO {&tttable}.it-codigo    IN FRAME fPage1.
    APPLY "LEAVE":U TO {&ttTable}.cod-localiz  IN FRAME fPage1.
    
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

    EMPTY TEMP-TABLE tt_log_erro.
    
    IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.  
    IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
    
    ASSIGN dDtMovimento = INPUT FRAME fPage0 ttApont.dat-movto.
    
    RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT "",                    /* EMPRESA EMS2 */
                                                   INPUT "",                    /* PLANO CCUSTO */
                                                   INPUT dDtMovimento,          /* DATA DE TRANSACAO */
                                                   OUTPUT p_cod_format_ccusto,  /* FORMATO CCUSTO */
                                                   OUTPUT TABLE tt_log_erro).   /* ERROS */

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

    APPLY "ENTRY":U TO fiSub                IN FRAME fPage1.
    APPLY "LEAVE":U TO fisub                IN FRAME fPage1.
    APPLY "ENTRY":U TO fiConta              IN FRAME fPage1.
    APPLY "LEAVE":U TO fiConta              IN FRAME fPage1.

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


    if pcAction = "UPDATE":U then do:
        /** Desabilita campos da chave prim ria **/
        assign {&ttTable}.cod-posto:sensitive in frame fPage1 = no
               {&ttTable}.cod-bomba:sensitive in frame fPage1 = no
               {&tttable}.it-codigo:sensitive in frame fPage1 = no.

        apply "LEAVE":U to {&ttTable}.cod-posto    in frame fPage1.
        apply "LEAVE":U to {&ttTable}.cod-bomba    in frame fPage1.
        apply "LEAVE":U to {&tttable}.it-codigo    in frame fPage1.

    end.
    /** Busca o tipo de valor do material **/
    for first mab-param fields(des-valor)
        where mab-param.cdn-param = 10 no-lock:
        assign iTpValor = int(mab-param.des-valor).
    end.

    IF pcAction = "ADD" THEN DO:
        APPLY "ENTRY":U TO {&tttable}.cod-posto IN FRAME fPage1.
        APPLY "ENTRY":U TO {&tttable}.cod-posto IN FRAME fPage1.
    END.
    ELSE DO:
        APPLY "ENTRY":U TO {&tttable}.cod-bomba IN FRAME fPage1.

        IF {&tttable}.cod-bomba:SENSITIVE IN FRAME fPage1 = NO AND
           {&tttable}.cod-localiz:SENSITIVE IN FRAME fPage1 = YES THEN
            APPLY "ENTRY":U TO {&tttable}.cod-localiz IN FRAME fPage1.
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
        IF  mab-param.des-valor = "1":U THEN DO:
            /** Atualiza os campos de conta e centro de custo **/
            ASSIGN {&ttTable}.cod-cta-ctbl = INPUT FRAME fPage1 fiConta
                   {&ttTable}.cod-ccusto   = INPUT FRAME fPage1 fiSub.
        END.
    END.
    
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

{method~\referenceFields.i
    &HandleDBOLeave="hDBOEqpto"
    &KeyValue1="input frame fPage0 {&ttParent}.ep-codigo"
    &KeyValue2="input frame fPage0 {&ttParent}.cod-eqpto"
    &FieldName1="cod-model"
    &Variable1="cCodModelo"}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consisteAbastecimento wMaintenanceNoNavigation 
PROCEDURE consisteAbastecimento :
/*------------------------------------------------------------------------------
  Purpose:     consisteAbastecimento
  Parameters:  <none>
  Notes:       Valida‡äes / consistˆncias no registro
------------------------------------------------------------------------------*/
define variable deTanque as decimal no-undo.

/** Busca Tipo Material e Flag de Abastecimento Prim rio **/
run buscaTipoMaterial in {&hDBOTable} (input  {&ttParent}.ep-codigo,
                                       input  {&ttParent}.cod-eqpto,
                                       input  input frame fPage1 {&tttable}.it-codigo,
                                       input  {&ttParent}.dat-movto,
                                       output {&ttTable}.cod-tip-mater,
                                       output {&ttTable}.log-abastec-prim,
                                       output deTanque).
/** Verifica capacidade do tanque **/
if deTanque < input frame fPage1 {&ttTable}.val-quant then do:
    {utp~/ut-liter.i "Tanque"}
    run utp~/ut-msgs.p (input "SHOW":U,
                       input 28612,
                       input return-value + '~~' + string(deTanque)).
    /** Se usu rio nÆo concordar com a quantidade, desfaz **/
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
        run frbo~/bofr007.p persistent set  hDBOEqpto.
    END.
    
    RUN openQueryStatic IN hDBOEqpto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo~\bofr016.p":U THEN DO:
        run frbo~/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

    /*--- DBO Posto  ---*/
    IF NOT VALID-HANDLE(hDBOPosto) OR
       hDBOPosto:TYPE <> "PROCEDURE":U OR
       hDBOPosto:FILE-NAME <> "frbo~\bofr021.p":U THEN DO:
        run frbo~/bofr021.p persistent set  hDBOPosto.
    END.
    
    RUN openQueryStatic IN hDBOPosto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Item ---*/
    IF NOT VALID-HANDLE(hDBOItem) OR
       hDBOItem:TYPE <> "PROCEDURE":U OR
       hDBOItem:FILE-NAME <> "inbo~\boin172.p":U THEN DO:
        run inbo~/boin172.p persistent set  hDBOItem.
    END.
    
    RUN openQueryStatic IN hDBOItem (INPUT "Main":U) NO-ERROR.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBomba wMaintenanceNoNavigation 
PROCEDURE piBomba :
/*------------------------------------------------------------------------------
  Purpose:     piBomba
  Parameters:  <none>
  Notes:       Verifica tipo de posto para habilitar em tela bomba
               Obs: Se for de terceiro, deve-se gravar campo em branco,
                    Se for pr¢prio, deve-se deixar habilitado em tela para
                    o usuïrio informar.
------------------------------------------------------------------------------*/
/** Verifica se posto ‚ pr¢prio ou de terceiro **/
run buscaTipoPosto in {&hDBOTable} (input  {&ttTable}.cod-posto:screen-value in frame fPage1,
                                    output iTpPosto).

case iTpPosto:
    /** Terceiro **/
    when 2 then do:
        assign {&ttTable}.cod-bomba = ""
               {&ttTable}.cod-bomba:sensitive in frame fPage1   = no
               {&ttTable}.cod-localiz = ""
               {&ttTable}.cod-localiz:sensitive in frame fPage1 = no
               {&ttTable}.cod-refer = ""
               {&ttTable}.cod-refer:sensitive in frame fPage1   = no
               {&ttTable}.lote = ""
               {&ttTable}.lote:sensitive in frame fPage1        = no
               {&ttTable}.val-mater-1:sensitive in frame fPage1 = yes
               {&ttTable}.val-quant:sensitive in frame fPage1   = yes.
        if pcAction <> "UPDATE":U then do:
            assign {&ttTable}.val-mater-1 = 0
                   {&ttTable}.val-quant = 0.
        end.
        apply "LEAVE":U to {&ttTable}.cod-bomba in frame fPage1.
        display {&ttTable}.cod-bomba
                {&ttTable}.cod-localiz 
                {&ttTable}.cod-refer 
                {&ttTable}.lote 
                {&ttTable}.val-mater-1 
                {&ttTable}.val-quant
            with frame fPage1.
    end.
    /** Pr¢prio **/
    OTHERWISE DO:
                assign {&ttTable}.cod-bomba:sensitive in frame fPage1   = yes
               {&ttTable}.cod-localiz:sensitive in frame fPage1 = yes
               {&ttTable}.cod-refer:sensitive in frame fPage1   = yes
               {&ttTable}.lote:sensitive in frame fPage1        = YES
               {&ttTable}.val-quant:sensitive in frame fPage1   = yes.
               FOR FIRST mab-param WHERE mab-param.cdn-param = 10 NO-LOCK:
               END.
               IF mab-param.des-valor <> "1" THEN 
                   {&ttTable}.val-mater-1:sensitive in frame fPage1   = NO.
               ELSE 
                   {&ttTable}.val-mater-1:sensitive in frame fPage1   = YES.
    END.
end case.

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
  Notes:       Apresenta Posto Correto em tela
------------------------------------------------------------------------------*/

if pcAction = "ADD":U then do:
    assign {&ttTable}.cod-posto = {&ttParent}.cod-posto.
    display {&ttTable}.cod-posto
        with frame fPage1.
end.

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

assign {&ttTable}.num-docto            = {&ttParent}.num-docto
       {&ttTable}.ep-codigo            = {&ttParent}.ep-codigo
       {&ttTable}.cod-eqpto            = {&ttParent}.cod-eqpto.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

