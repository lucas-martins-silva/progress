&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttOleo NO-UNDO LIKE mab-comptmento-eqpto
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
{include/i-prgvrs.i AB0138C1 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0138c1 MAB}
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
&GLOBAL-DEFINE Program           AB0138C1
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Pag. 1

&GLOBAL-DEFINE ttTable           ttOleo
&GLOBAL-DEFINE hDBOTable         hDBOOleo
&GLOBAL-DEFINE DBOTable          mab-comptmento-eqpto

&GLOBAL-DEFINE page0KeyFields    ttOleo.cod-comptmento

&GLOBAL-DEFINE page1Fields       {&ttTable}.cod-sub-sist {&ttTable}.dat-inicial {&ttTable}.cod-tip-mater ~
                                 {&tttable}.idi-remonta {&ttTable}.qtd-capac ~
                                 {&ttTable}.val-perc-remon {&ttTable}.val-km-inicial
                                 

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTablePai      AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cCodModelo AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iTipo      AS INTEGER    NO-UNDO.
DEFINE VARIABLE lMotor     AS LOGICAL    NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEqpto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOComp      AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOMater     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOSist      AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttOleo.ep-codigo ttOleo.cod-eqpto ~
ttOleo.cod-comptmento 
&Scoped-define ENABLED-TABLES ttOleo
&Scoped-define FIRST-ENABLED-TABLE ttOleo
&Scoped-Define ENABLED-OBJECTS fiDescModelo fiDescComp btOK btSave btCancel ~
btHelp rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttOleo.ep-codigo ttOleo.cod-eqpto ~
ttOleo.cod-comptmento 
&Scoped-define DISPLAYED-TABLES ttOleo
&Scoped-define FIRST-DISPLAYED-TABLE ttOleo
&Scoped-Define DISPLAYED-OBJECTS fiDescModelo fiDescComp 

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

DEFINE VARIABLE fiDescComp AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 28 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fi-tipo-remonta AS CHARACTER FORMAT "X(30)":U INITIAL "Tipo Remonta" 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE fiDescMaterial AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescSistema AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fiUNMater AS CHARACTER FORMAT "XX":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiUnModel AS CHARACTER FORMAT "xx" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 33 BY 1.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttOleo.ep-codigo AT ROW 1.25 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttOleo.cod-eqpto AT ROW 2.25 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     fiDescModelo AT ROW 2.25 COL 40.57 COLON-ALIGNED HELP
          "Descriá∆o Modelo Equipamento" NO-LABEL
     ttOleo.cod-comptmento AT ROW 3.25 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fiDescComp AT ROW 3.25 COL 33.57 COLON-ALIGNED HELP
          "Descriá∆o do Compartimento" NO-LABEL
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
         FONT 1.

DEFINE FRAME fPage1
     fi-tipo-remonta AT ROW 7.08 COL 20.29 COLON-ALIGNED NO-LABEL
     fiUNMater AT ROW 4 COL 29.57 COLON-ALIGNED NO-LABEL
     ttOleo.dat-inicial AT ROW 2 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttOleo.cod-tip-mater AT ROW 3 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescMaterial AT ROW 3 COL 29.57 COLON-ALIGNED HELP
          "Descriá∆o Tipo Material" NO-LABEL
     ttOleo.qtd-capac AT ROW 4 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttOleo.val-km-inicial AT ROW 5 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiUnModel AT ROW 5 COL 29.57 COLON-ALIGNED HELP
          "Unidade do contador do equipamento" NO-LABEL
     ttOleo.cod-sub-sist AT ROW 6 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescSistema AT ROW 6 COL 29.57 COLON-ALIGNED HELP
          "Descriá∆o do SubSistema" NO-LABEL
     ttOleo.idi-remonta AT ROW 7.67 COL 25.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Normal", 1,
"Anormal", 2
          SIZE 25.43 BY .88
     ttOleo.val-perc-remon AT ROW 9 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     RECT-1 AT ROW 7.38 COL 21
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 5.7
         SIZE 84.43 BY 9.92
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttOleo T "?" NO-UNDO mgfro mab-comptmento-eqpto
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
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
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
   FRAME-NAME Custom                                                    */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fPage1:MOVE-AFTER-TAB-ITEM (fiDescComp:HANDLE IN FRAME fpage0)
       XXTABVALXX = FRAME fPage1:MOVE-BEFORE-TAB-ITEM (btOK:HANDLE IN FRAME fpage0)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
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


&Scoped-define SELF-NAME ttOleo.cod-comptmento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttOleo.cod-comptmento wMaintenanceNoNavigation
ON F5 OF ttOleo.cod-comptmento IN FRAME fpage0 /* Compartimento */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr003.w"
           &FieldZoom1="cod-comptmento"
           &FieldScreen1="ttOleo.cod-comptmento"
           &Frame1="fPage0"
           &FieldZoom2="des-comptmento"
           &FieldScreen2="fiDescComp"
           &Frame2="fPage0"
           &EnableImplant="YES"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttOleo.cod-comptmento wMaintenanceNoNavigation
ON LEAVE OF ttOleo.cod-comptmento IN FRAME fpage0 /* Compartimento */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOComp"
        &KeyValue1="ttOleo.cod-comptmento:screen-value in frame fPage0"
        &FieldName1="des-comptmento"
        &FieldScreen1="fiDescComp"
        &Frame1="fPage0"}
        
    /** Validaá‰es para campos de tela conforme registro de compartimento **/
    run piLeaveCompartimento in this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttOleo.cod-comptmento wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttOleo.cod-comptmento IN FRAME fpage0 /* Compartimento */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttOleo.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttOleo.cod-eqpto wMaintenanceNoNavigation
ON LEAVE OF ttOleo.cod-eqpto IN FRAME fpage0 /* Equipamento */
DO:
    run buscaModelo in this-procedure.
    {method\referenceFields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="cCodModelo"
        &FieldName1="des-model"
        &FieldScreen1="fiDescModelo"
        &Frame1="fPage0"
        &FieldName2="un"
        &FieldScreen2="fiUnModel"
        &Frame2="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttOleo.cod-sub-sist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttOleo.cod-sub-sist wMaintenanceNoNavigation
ON F5 OF ttOleo.cod-sub-sist IN FRAME fPage1 /* Sub-Sistema */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr025.w"
           &FieldZoom1="cod-sub-sist"
           &FieldScreen1="ttOleo.cod-sub-sist"
           &Frame1="fPage1"
           &FieldZoom2="des-sub-sist"
           &FieldScreen2="fiDescSistema"
           &Frame2="fPage1"
           &EnableImplant="YES"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttOleo.cod-sub-sist wMaintenanceNoNavigation
ON LEAVE OF ttOleo.cod-sub-sist IN FRAME fPage1 /* Sub-Sistema */
DO:
    {method\referenceFields.i
            &HandleDBOLeave="hDBOSist"
            &KeyValue1="ttOleo.cod-sub-sist:screen-value in frame fPage1"
            &FieldName1="des-sub-sist"
            &FieldScreen1="fiDescSistema"
            &Frame1="fPage1"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttOleo.cod-sub-sist wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttOleo.cod-sub-sist IN FRAME fPage1 /* Sub-Sistema */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttOleo.cod-tip-mater
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttOleo.cod-tip-mater wMaintenanceNoNavigation
ON F5 OF ttOleo.cod-tip-mater IN FRAME fPage1 /* Tipo Material */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr026.w"
           &FieldZoom1="cod-tip-mater"
           &FieldScreen1="ttOleo.cod-tip-mater"
           &Frame1="fPage1"
           &FieldZoom2="des-tip-mater"
           &FieldScreen2="fiDescMaterial"
           &Frame2="fPage1"
           &FieldZoom3="un"
           &FieldScreen3="fiUNMater"
           &Frame3="fPage1"           
           &EnableImplant="YES"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttOleo.cod-tip-mater wMaintenanceNoNavigation
ON LEAVE OF ttOleo.cod-tip-mater IN FRAME fPage1 /* Tipo Material */
DO:
    {method\referenceFields.i
            &HandleDBOLeave="hDBOMater"
            &KeyValue1="ttOleo.cod-tip-mater:screen-value in frame fPage1"
            &FieldName1="des-tip-mater"
            &FieldScreen1="fiDescMaterial"
            &Frame1="fPage1"
            &FieldName2="un"
            &FieldScreen2="fiUNMater"
            &Frame2="fPage1"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttOleo.cod-tip-mater wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttOleo.cod-tip-mater IN FRAME fPage1 /* Tipo Material */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenancenonavigation/mainblock.i}

{&ttTable}.cod-comptmento:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in frame fPage0.
{&ttTable}.cod-tip-mater:LOAD-MOUSE-POINTER("image~\lupa.cur":U)  in frame fPage1.
{&ttTable}.cod-sub-sist:LOAD-MOUSE-POINTER("image~\lupa.cur":U)   in frame fPage1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) finalizaá∆o do programa
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
/** Tipo Material **/
if valid-handle(hDBOMater) then
    run Destroy in hDBOMater.
/** Sub Sistema **/
if valid-handle(hDBOSist) then
    run Destroy in hDBOSist.

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
/** Descriá‰es dos campos **/
apply "LEAVE":U to ttOleo.cod-eqpto      in frame fPage0.
apply "LEAVE":U to ttOleo.cod-comptmento in frame fPage0.
apply "LEAVE":U to ttOleo.cod-tip-mater  in frame fPage1.
apply "LEAVE":U to ttOleo.cod-sub-sist   in frame fPage1.

{utp/ut-liter.i "Tipo Remonta" MAB}
ASSIGN fi-tipo-remonta:SCREEN-VALUE IN FRAME fPage1 = RETURN-VALUE.
{utp/ut-liter.i "Remonta" MAB}
ASSIGN {&ttTable}.val-perc-remon:LABEL IN FRAME fPage1 = "% " + RETURN-VALUE.

/** Seta foco no campo correto **/
run piFocoInicial in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     afterEnableFields
  Parameters:  <none>
  Notes:       Override ap¢s Habilitar campos em tela
------------------------------------------------------------------------------*/
/** Busca C¢digo da empresa e do equipamento **/
if prTablePai <> ? then do:
    for first mab-eqpto fields(ep-codigo cod-eqpto dat-inicial)
        where rowid(mab-eqpto) = prTablePai no-lock:
        assign ttOleo.ep-codigo   = mab-eqpto.ep-codigo
               ttOleo.cod-eqpto   = mab-eqpto.cod-eqpto
               ttOleo.dat-inicial = if pcAction = "UPDATE":U 
                                    then ttOleo.dat-inicial 
                                    else mab-eqpto.dat-inicial
               ttOleo.ep-codigo:sensitive in frame fPage0 = no
               ttOleo.cod-eqpto:sensitive in frame fPage0 = no.
        display ttOleo.ep-codigo
                ttOleo.cod-eqpto  
            with frame fPage0.
        display ttOleo.dat-inicial
            with frame fPage1.
     
        apply "LEAVE" to ttOleo.cod-eqpto IN FRAME fpage0.

    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) inicializaá∆o da tela 
------------------------------------------------------------------------------*/
{utp/ut-liter.i "Tipo Remonta" MAB}
ASSIGN fi-tipo-remonta:SCREEN-VALUE IN FRAME fPage1 = RETURN-VALUE.
{utp/ut-liter.i "Remonta" MAB}
ASSIGN {&ttTable}.val-perc-remon:LABEL IN FRAME fPage1 = "% " + RETURN-VALUE.

/** Seta foco no campo correto **/
run piFocoInicial in this-procedure.

if pcAction = "UPDATE":U then
    /** Validaá‰es para campos de tela conforme registro de compartimento **/
    run piLeaveCompartimento in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override (antes) inicializaá∆o da tela
------------------------------------------------------------------------------*/


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
    &KeyValue1="ttOleo.ep-codigo"
    &KeyValue2="ttOleo.cod-eqpto"
    &FieldName1="cod-model"
    &Variable1="cCodModelo"}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
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

    /*--- DBO Tipo Material  ---*/
    IF NOT VALID-HANDLE(hDBOMater) OR
       hDBOMater:TYPE <> "PROCEDURE":U OR
       hDBOMater:FILE-NAME <> "frbo~\bofr026.p":U THEN DO:
        run frbo/bofr026.p persistent set  hDBOMater.
    END.
    
    RUN openQueryStatic IN hDBOMater (INPUT "Main":U) NO-ERROR.

    /*--- DBO Sub Sistema ---*/
    IF NOT VALID-HANDLE(hDBOSist) OR
       hDBOSist:TYPE <> "PROCEDURE":U OR
       hDBOSist:FILE-NAME <> "frbo~\bofr025.p":U THEN DO:
        run frbo/bofr025.p persistent set  hDBOSist.
    END.
    
    RUN openQueryStatic IN hDBOSist (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piFocoInicial wMaintenanceNoNavigation 
PROCEDURE piFocoInicial :
/*------------------------------------------------------------------------------
  Purpose:     piFocoInicial
  Parameters:  <none>
  Notes:       Coloca cursor no primeiro campo da tela habilitado
------------------------------------------------------------------------------*/

if pcAction = "ADD":U  or
   pcAction = "COPY":U then
    apply "ENTRY":U to ttOleo.cod-comptmento in frame fPage0.
else 
    apply "ENTRY":U to ttOleo.qtd-capac in frame fPage1.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLeaveCompartimento wMaintenanceNoNavigation 
PROCEDURE piLeaveCompartimento :
/*------------------------------------------------------------------------------
  Purpose:     piLeaveCompartimento
  Parameters:  <none>
  Notes:       Validaá‰es para campos conforme registro de compartimento
------------------------------------------------------------------------------*/

run buscaCamposCompartimento in {&hDBOTable} (input  ttOleo.cod-comptmento:screen-value in frame fPage0,
                                              output iTipo,
                                              output lMotor).
if return-value = "OK":U then do:
    /** Sugest∆o de valor para capacidade quando compartimento for Filtro (1) **/
    /** Verifica compartimento para habilitar remonta **/
    if iTipo = 1 then do:
        assign ttOleo.qtd-capac = if pcAction <> "UPDATE":U 
                                  then 1
                                  else ttOleo.qtd-capac
               ttOleo.idi-remonta:sensitive in frame fPage1 = yes.
        disp ttOleo.qtd-capac
             ttOleo.idi-remonta
            with frame fPage1.
    end.
    else do:
        assign ttOleo.qtd-capac   = if pcAction <> "UPDATE":U 
                                    then 0
                                    else ttOleo.qtd-capac
               ttOleo.idi-remonta = 1
               ttOleo.idi-remonta:sensitive in frame fPage1 = no.
        disp ttOleo.qtd-capac
             ttOleo.idi-remonta
            with frame fPage1.
    end.
    /** Verifica se Compartimento = Motor (yes) **/
    if lMotor then
        assign ttOleo.val-perc-remon:sensitive in frame fPage1 = yes.
    else do:
        assign ttOleo.val-perc-remon:sensitive in frame fPage1 = no
               ttOleo.val-perc-remon = 0.
        display ttOleo.val-perc-remon
            with frame fPage1.
    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

