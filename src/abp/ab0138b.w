&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttCombustivel NO-UNDO LIKE mab-histor-combust
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttEqpto NO-UNDO LIKE mab-eqpto
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
{include/i-prgvrs.i AB0138B 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0138b MAB}
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
&GLOBAL-DEFINE Program           AB0138B
&GLOBAL-DEFINE Version           2.00.00.001

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Combust¡veis

&GLOBAL-DEFINE ttTable           ttCombustivel
&GLOBAL-DEFINE hDBOTable         hDBOCombustivel
&GLOBAL-DEFINE DBOTable          mab-histor-combust

&GLOBAL-DEFINE ttParent          ttEqpto
&GLOBAL-DEFINE DBOParentTable    hDBOEqpto

&GLOBAL-DEFINE page0KeyFields    ttCombustivel.dat-inicial
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields ttEqpto.ep-codigo ttEqpto.cod-eqpto
&GLOBAL-DEFINE page1Fields       ttCombustivel.cod-tip-mater ttCombustivel.val-capac-tanque ~
                                 ttCombustivel.idi-tip-consu ttCombustivel.val-consu-padr ~
                                 ttCombustivel.dat-desativ rsTipConsuSec fiValConsuSec

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOMaterial  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttEqpto.ep-codigo ttEqpto.cod-eqpto ~
ttCombustivel.dat-inicial 
&Scoped-define ENABLED-TABLES ttEqpto ttCombustivel
&Scoped-define FIRST-ENABLED-TABLE ttEqpto
&Scoped-define SECOND-ENABLED-TABLE ttCombustivel
&Scoped-Define ENABLED-OBJECTS fiDescModelo btOK btSave btCancel btHelp ~
rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttEqpto.ep-codigo ttEqpto.cod-eqpto ~
ttCombustivel.dat-inicial 
&Scoped-define DISPLAYED-TABLES ttEqpto ttCombustivel
&Scoped-define FIRST-DISPLAYED-TABLE ttEqpto
&Scoped-define SECOND-DISPLAYED-TABLE ttCombustivel
&Scoped-Define DISPLAYED-OBJECTS fiDescModelo 

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

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fiDescConsumo AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescConsuSec AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescMaterial AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fiTexto AS CHARACTER FORMAT "X(256)":U INITIAL "Consumo" 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE VARIABLE fiTextoSec AS CHARACTER FORMAT "X(256)":U INITIAL "Consumo Secund rio" 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

DEFINE VARIABLE fiValConsuSec AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "Consumo Secund rio" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE rsTipConsuSec AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Sem Consumo", 1,
"Percurso/Qtd", 2,
"Qtd/Percurso", 3
     SIZE 14 BY 2.5.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 63 BY 3.29.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 63 BY 3.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fiDescModelo AT ROW 2.25 COL 43.57 COLON-ALIGNED HELP
          "Descri‡Æo Modelo Equipamento" NO-LABEL
     ttEqpto.ep-codigo AT ROW 1.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttEqpto.cod-eqpto AT ROW 2.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     ttCombustivel.dat-inicial AT ROW 3.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     btOK AT ROW 17.88 COL 2
     btSave AT ROW 17.88 COL 13
     btCancel AT ROW 17.88 COL 24
     btHelp AT ROW 17.88 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 17.63 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.08
         FONT 1.

DEFINE FRAME fPage1
     ttCombustivel.cod-tip-mater AT ROW 1.38 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fiDescMaterial AT ROW 1.38 COL 26.57 COLON-ALIGNED HELP
          "Descri‡Æo Tipo Material" NO-LABEL
     ttCombustivel.val-capac-tanque AT ROW 2.38 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ttCombustivel.idi-tip-consu AT ROW 4 COL 22 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Sem Consumo", 1,
"Percurso/Qtd", 2,
"Qtd/Percurso", 3
          SIZE 14 BY 2.5
     fiTexto AT ROW 3.29 COL 20 COLON-ALIGNED NO-LABEL
     ttCombustivel.val-consu-padr AT ROW 5.63 COL 50.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fiDescConsumo AT ROW 5.63 COL 59.14 COLON-ALIGNED NO-LABEL
     rsTipConsuSec AT ROW 7.63 COL 22 NO-LABEL
     fiValConsuSec AT ROW 9.25 COL 50.72 COLON-ALIGNED
     fiDescConsuSec AT ROW 9.25 COL 59.14 COLON-ALIGNED NO-LABEL
     ttCombustivel.dat-desativ AT ROW 10.58 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiTextoSec AT ROW 6.83 COL 20 COLON-ALIGNED NO-LABEL
     RECT-14 AT ROW 3.46 COL 20
     RECT-20 AT ROW 7.13 COL 20
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5.96
         SIZE 84.43 BY 10.92
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttCombustivel T "?" NO-UNDO mgfro mab-histor-combust
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttEqpto T "?" NO-UNDO mgfro mab-eqpto
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
         HEIGHT             = 18.08
         WIDTH              = 90
         MAX-HEIGHT         = 18.5
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 18.5
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

ASSIGN XXTABVALXX = FRAME fPage1:MOVE-AFTER-TAB-ITEM (btHelp:HANDLE IN FRAME fpage0)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* SETTINGS FOR FILL-IN fiValConsuSec IN FRAME fPage1
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR RADIO-SET rsTipConsuSec IN FRAME fPage1
   NO-DISPLAY NO-ENABLE                                                 */
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


&Scoped-define SELF-NAME ttEqpto.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-eqpto wMaintenanceNoNavigation
ON LEAVE OF ttEqpto.cod-eqpto IN FRAME fpage0 /* Equipamento */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="ttEqpto.cod-model"
        &FieldName1="des-model"
        &FieldScreen1="fiDescModelo"
        &Frame1="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttCombustivel.cod-tip-mater
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttCombustivel.cod-tip-mater wMaintenanceNoNavigation
ON F5 OF ttCombustivel.cod-tip-mater IN FRAME fPage1 /* Tipo Material */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr026.w"
           &FieldZoom1="cod-tip-mater"
           &FieldScreen1="ttCombustivel.cod-tip-mater"
           &Frame1="fPage1"
           &FieldZoom2="des-tip-mater"
           &FieldScreen2="fiDescMaterial"
           &Frame2="fPage1"
           &EnableImplant="YES"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttCombustivel.cod-tip-mater wMaintenanceNoNavigation
ON LEAVE OF ttCombustivel.cod-tip-mater IN FRAME fPage1 /* Tipo Material */
DO:
    {method\referenceFields.i
            &HandleDBOLeave="hDBOMaterial"
            &KeyValue1="ttCombustivel.cod-tip-mater:screen-value in frame fPage1"
            &FieldName1="des-tip-mater"
            &FieldScreen1="fiDescMaterial"
            &Frame1="fPage1"}
    /** Descri‡Æo Consumo PadrÆo **/
    apply "VALUE-CHANGED":U to ttCombustivel.idi-tip-consu in frame fPage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttCombustivel.cod-tip-mater wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttCombustivel.cod-tip-mater IN FRAME fPage1 /* Tipo Material */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttCombustivel.idi-tip-consu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttCombustivel.idi-tip-consu wMaintenanceNoNavigation
ON LEAVE OF ttCombustivel.idi-tip-consu IN FRAME fPage1
DO:
  apply "VALUE-CHANGED":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttCombustivel.idi-tip-consu wMaintenanceNoNavigation
ON VALUE-CHANGED OF ttCombustivel.idi-tip-consu IN FRAME fPage1
DO:
  run piLeaveTipoConsumo in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsTipConsuSec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsTipConsuSec wMaintenanceNoNavigation
ON LEAVE OF rsTipConsuSec IN FRAME fPage1
DO:
    APPLY "VALUE-CHANGED":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsTipConsuSec wMaintenanceNoNavigation
ON VALUE-CHANGED OF rsTipConsuSec IN FRAME fPage1
DO:
    RUN piLeaveTipoConsumoSec IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

ttCombustivel.cod-tip-mater:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame fPage1.

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
/** DBO Material **/
if valid-handle (hDBOMaterial) then
    run destroy in hDBOMaterial.

/** DBO Modelo **/
if valid-handle (hDBOModelo) then
    run destroy in hDBOModelo.
              
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     afterDisplayFields
  Parameters:  <none>
  Notes:       Override (ap¢s) display campos em tela
------------------------------------------------------------------------------*/
    /** Descri‡äes de campos **/
    APPLY "LEAVE":U         TO ttEqpto.cod-eqpto           IN FRAME fPage0.
    APPLY "LEAVE":U         TO ttCombustivel.cod-tip-mater IN FRAME fPage1.
    APPLY "VALUE-CHANGED":U TO ttCombustivel.idi-tip-consu IN FRAME fPage1.
    
    IF  pcAction = "ADD":U OR pcAction = "COPY":U THEN DO:
        /** Coloca a data de in¡cio igual a data de controle do eqpto **/
        RUN buscaDataInicio IN {&hDBOTable} (INPUT  ttEqpto.ep-codigo,
                                             INPUT  ttEqpto.cod-eqpto,
                                             OUTPUT ttCombustivel.dat-inicial).
        DISPLAY ttCombustivel.dat-inicial
            WITH FRAME fPage0.
        /** Data de desativa‡Æo deve ser em branco para combust¡veis ativos **/
        ASSIGN ttCombustivel.dat-desativ = ?.
        DISPLAY ttCombustivel.dat-desativ
            WITH FRAME fPage1.
    END.
    
    /** Seta foco no campo correto **/
    RUN piFocoInicial IN THIS-PROCEDURE.
    
    IF  pcAction = "UPDATE":U THEN DO:
        ASSIGN rsTipConsuSec:SCREEN-VALUE IN FRAME fPage1 = IF  ttCombustivel.num-livre-1 > 0 THEN STRING(ttCombustivel.num-livre-1) ELSE "1"
               fiValConsuSec:SCREEN-VALUE IN FRAME fPage1 = STRING(ttCombustivel.val-livre-1).
    END.
    APPLY "VALUE-CHANGED":U TO rsTipConsuSec IN FRAME fPage1.

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
    IF  AVAIL ttEqpto THEN DO:
        IF  ttEqpto.log-cont-sec THEN
            ASSIGN rsTipConsuSec:SENSITIVE IN FRAME fPage1 = YES
                   fiValConsuSec:SENSITIVE IN FRAME fPage1 = NO.
        ELSE
            ASSIGN rsTipConsuSec:SENSITIVE IN FRAME fPage1 = NO
                   fiValConsuSec:SENSITIVE IN FRAME fPage1 = NO
                   fiValConsuSec:SCREEN-VALUE  IN FRAME fPage1 = "0,0"
                   fiDescConsuSec:SCREEN-VALUE IN FRAME fPage1 = "".
    END.
    
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
    /** Seta foco no campo correto **/
    RUN piFocoInicial IN THIS-PROCEDURE.
    
    {utp/ut-liter.i "Consumo"}
    ASSIGN fiTexto:SCREEN-VALUE IN FRAME fPage1 = RETURN-VALUE.
    
    {utp/ut-liter.i Consumo_Secund rio *}
    ASSIGN fiTextoSec:SCREEN-VALUE IN FRAME fPage1 = RETURN-VALUE.
    
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
    ASSIGN ttCombustivel.num-livre-1 = INPUT FRAME fPage1 rsTipConsuSec
           ttCombustivel.val-livre-1 = INPUT FRAME fPage1 fiValConsuSec.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override (antes) da inicializa‡Æo de tela
------------------------------------------------------------------------------*/
/** Inicializa as BOs das chaves estrangeiras **/
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
  Notes:       Override antes de salvar dados em tabela 
------------------------------------------------------------------------------*/
/** Verifica se existe hist¢rico de combust¡vel ativo com consumo **/
if input frame fPage1 {&tttable}.idi-tip-consu > 1 and
   pcAction <> "UPDATE":U then do:
    run buscaHistorico in {&hDBOTable} (input {&ttParent}.ep-codigo,
                                        input {&ttParent}.cod-eqpto).
    /** Existe hist¢rico **/
    if return-value = "NOK":U then do:
        /** Pergunta se deseja cadastrar **/
        run utp/ut-msgs.p (input "SHOW":U,
                           input 28564,
                           input '').
        /** NÆo cadastra **/
        if return-value = "NO":U then
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
  Purpose:     initializeDBOs
  Parameters:  <none>
  Notes:       Inicializa as BOs para chaves estrangeiras
------------------------------------------------------------------------------*/

    /*--- DBO Material ---*/
    IF NOT VALID-HANDLE(hDBOMaterial) OR
       hDBOMaterial:TYPE <> "PROCEDURE":U OR
       hDBOMaterial:FILE-NAME <> "frbo/bofr026.p":U THEN DO:
        run frbo/bofr026.p persistent set  hDBOMaterial.
    END.
    
    RUN openQueryStatic IN hDBOMaterial (INPUT "Main":U) NO-ERROR.

    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo/bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

    return "OK":U.

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
    apply "ENTRY":U to ttCombustivel.dat-inicial in frame fPage0.
else 
    apply "ENTRY":U to ttCombustivel.cod-tip-mater in frame fPage1.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLeaveTipoConsumo wMaintenanceNoNavigation 
PROCEDURE piLeaveTipoConsumo :
/*------------------------------------------------------------------------------
  Purpose:     piLeaveTipoConsumo
  Parameters:  <none>
  Notes:       Leave do campo de Tipo de consumo.
------------------------------------------------------------------------------*/

case input frame fPage1 ttCombustivel.idi-tip-consu:
    when 1 then do:    /** Sem consumo **/
        assign ttCombustivel.val-consu-padr:sensitive in frame fPage1 = no
               fiDescConsumo:screen-value in frame fPage1             = ""
               ttCombustivel.val-consu-padr                           = 0.
        display ttCombustivel.val-consu-padr
            with frame fPage1.
    end.
    when 2 or when 3 then do: /** 2 = KM-Hora/Qtd **/    /** 3 = Qtd/KM-Hora **/
        assign ttCombustivel.val-consu-padr:sensitive in frame fPage1 = yes.
        run buscaDescricaoConsumo in {&hDBOTable} (input  ttEqpto.cod-model,
                                                   input  ttCombustivel.cod-tip-mater:screen-value in frame fPage1,
                                                   input  input frame fPage1 ttCombustivel.idi-tip-consu,
                                                   output fiDescConsumo).
        display fiDescConsumo
            with frame fPage1.
    end.
end case.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLeaveTipoConsumoSec wMaintenanceNoNavigation 
PROCEDURE piLeaveTipoConsumoSec :
/*------------------------------------------------------------------------------
  Purpose:     piLeaveTipoConsumo
  Parameters:  <none>
  Notes:       Leave do campo de Tipo de consumo.
------------------------------------------------------------------------------*/
    CASE INPUT FRAME fPage1 rsTipConsuSec:
        WHEN 1 THEN DO: /** Sem consumo **/
            ASSIGN fiValConsuSec:SENSITIVE      IN FRAME fPage1 = NO
                   fiDescConsuSec:SCREEN-VALUE  IN FRAME fPage1 = ""
                   fiValConsuSec                                = 0.
            DISPLAY fiValConsuSec WITH FRAME fPage1.
        END.
        WHEN 2 OR WHEN 3 THEN DO: /** 2 = KM-Hora/Qtd **/    /** 3 = Qtd/KM-Hora **/
            ASSIGN fiValConsuSec:SENSITIVE      IN FRAME fPage1 = YES.
            RUN buscaDescricaoConsumoSec IN {&hDBOTable} (INPUT  ttEqpto.cod-model,
                                                          INPUT  ttCombustivel.cod-tip-mater:SCREEN-VALUE IN FRAME fPage1,
                                                          INPUT  INPUT FRAME fPage1 rsTipConsuSec,
                                                          OUTPUT fiDescConsuSec).
            DISPLAY fiDescConsuSec WITH FRAME fPage1.
        END.
    END CASE.
    
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

    ASSIGN {&ttTable}.ep-codigo = {&ttParent}.ep-codigo
           {&ttTable}.cod-eqpto = {&ttParent}.cod-eqpto.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

