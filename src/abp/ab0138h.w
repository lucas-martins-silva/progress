&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttEqpto NO-UNDO LIKE mab-eqpto
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttLayout NO-UNDO LIKE mpn-histor-layout-eixo
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
{include/i-prgvrs.i AB0138H 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0138h MAB}
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
&GLOBAL-DEFINE Program           AB0138H
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Pag. 1

&GLOBAL-DEFINE ttTable           ttLayout
&GLOBAL-DEFINE hDBOTable         hDBOLayoutEixo
&GLOBAL-DEFINE DBOTable          mpn-histor-layout-eixo

&GLOBAL-DEFINE ttParent          ttEqpto
&GLOBAL-DEFINE DBOParentTable    hDBOEqpto

&GLOBAL-DEFINE page0KeyFields    ttLayout.dat-inicial
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields ttEqpto.ep-codigo ttEqpto.cod-eqpto
&GLOBAL-DEFINE page1Fields       ttLayout.cod-layout

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOLayout    AS HANDLE NO-UNDO.

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
ttLayout.dat-inicial 
&Scoped-define ENABLED-TABLES ttEqpto ttLayout
&Scoped-define FIRST-ENABLED-TABLE ttEqpto
&Scoped-define SECOND-ENABLED-TABLE ttLayout
&Scoped-Define ENABLED-OBJECTS fiDescModelo btOK btSave btCancel btHelp ~
rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttEqpto.ep-codigo ttEqpto.cod-eqpto ~
ttLayout.dat-inicial 
&Scoped-define DISPLAYED-TABLES ttEqpto ttLayout
&Scoped-define FIRST-DISPLAYED-TABLE ttEqpto
&Scoped-define SECOND-DISPLAYED-TABLE ttLayout
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

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "x(50)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fiDescLayout AS CHARACTER FORMAT "x(50)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE tgEstepe AS LOGICAL INITIAL no 
     LABEL "Utiliza Estepe" 
     VIEW-AS TOGGLE-BOX
     SIZE 12 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttEqpto.ep-codigo AT ROW 1.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttEqpto.cod-eqpto AT ROW 2.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     fiDescModelo AT ROW 2.25 COL 41.57 COLON-ALIGNED HELP
          "Descri‡Æo Modelo Equipamento" NO-LABEL
     ttLayout.dat-inicial AT ROW 3.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     btOK AT ROW 11.63 COL 2
     btSave AT ROW 11.63 COL 13
     btCancel AT ROW 11.63 COL 24
     btHelp AT ROW 11.63 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 11.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 12
         FONT 1.

DEFINE FRAME fPage1
     fiDescLayout AT ROW 2.25 COL 27.5 COLON-ALIGNED HELP
          "Descri‡Æo Layout" NO-LABEL
     ttLayout.cod-layout AT ROW 2.25 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tgEstepe AT ROW 3.25 COL 24
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 5.7
         SIZE 84.43 BY 4.92
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttEqpto T "?" NO-UNDO mgfro mab-eqpto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttLayout T "?" NO-UNDO mgfro mpn-histor-layout-eixo
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
         HEIGHT             = 12
         WIDTH              = 90
         MAX-HEIGHT         = 12
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 12
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

ASSIGN XXTABVALXX = FRAME fPage1:MOVE-AFTER-TAB-ITEM (ttLayout.dat-inicial:HANDLE IN FRAME fpage0)
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
&Scoped-define SELF-NAME ttLayout.cod-layout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLayout.cod-layout wMaintenanceNoNavigation
ON F5 OF ttLayout.cod-layout IN FRAME fPage1 /* Layout */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr047.w"
           &FieldZoom1="cod-layout"
           &FieldScreen1="ttLayout.cod-layout"
           &Frame1="fPage1"
           &FieldZoom2="des-layout"
           &FieldScreen2="fiDescLayout"
           &Frame2="fPage1"
           &EnableImplant="YES"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLayout.cod-layout wMaintenanceNoNavigation
ON LEAVE OF ttLayout.cod-layout IN FRAME fPage1 /* Layout */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOLayout"
        &KeyValue1="ttLayout.cod-layout:screen-value in frame fPage1"
        &FieldName1="des-layout"
        &FieldScreen1="fiDescLayout"
        &Frame1="fPage1"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLayout.cod-layout wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttLayout.cod-layout IN FRAME fPage1 /* Layout */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

{&ttTable}.cod-layout:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in frame fPage1.

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
/** DBO Modelo **/
if valid-handle (hDBOModelo) then
    run destroy in hDBOModelo.
              
/** DBO Layout **/
if valid-handle (hDBOLayout) then
    run destroy in hDBOLayout.

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
apply "LEAVE":U         to ttEqpto.cod-eqpto           in frame fPage0.

/** Seta foco no campo correto **/
run piFocoInicial in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) inicializa‡Æo da tela
------------------------------------------------------------------------------*/
{utp/ut-liter.i "In¡cio Controle"}
assign ttLayout.dat-inicial:label in frame fPage0 = return-value
       tgEstepe:sensitive in frame fPage1 = yes.

/** Busca Dados da tabela **/
if pcAction <> "ADD":U then do:
    assign tgEstepe = ttLayout.log-usa-estepe.
    display tgestepe
        with frame fPage1.
end.

/** Seta foco no campo correto **/
run piFocoInicial in this-procedure.

return "OK":U.

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenanceNoNavigation 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     beforeSaveFields
  Parameters:  <none>
  Notes:       Override (antes) de slavar dados em tabela.
------------------------------------------------------------------------------*/
assign ttLayout.log-usa-estepe = if tgEstepe:checked in frame fPage1
                                 then yes
                                 else no.
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

    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo~\bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

    /*--- DBO Layout ---*/
    IF NOT VALID-HANDLE(hDBOLayout) OR
       hDBOLayout:TYPE <> "PROCEDURE":U OR
       hDBOLayout:FILE-NAME <> "frbo~\bofr047.p":U THEN DO:
        run frbo/bofr047.p persistent set  hDBOLayout.
    END.
    
    RUN openQueryStatic IN hDBOLayout (INPUT "Main":U) NO-ERROR.

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
    apply "ENTRY":U to {&ttTable}.dat-inicial in frame fPage0.
else 
    apply "ENTRY":U to {&ttTable}.cod-layout in frame fPage1.

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
assign {&ttTable}.ep-codigo = {&ttParent}.ep-codigo
       {&ttTable}.cod-eqpto   = {&ttParent}.cod-eqpto.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

