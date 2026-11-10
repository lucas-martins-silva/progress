&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttEixo NO-UNDO LIKE mab-configur-eixo
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
{include/i-prgvrs.i AB0138G 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0138g MAB}
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
&GLOBAL-DEFINE Program           AB0138G
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Pag. 1

&GLOBAL-DEFINE ttTable           ttEixo
&GLOBAL-DEFINE hDBOTable         hDBOEixo
&GLOBAL-DEFINE DBOTable          mab-configur-eixo

&GLOBAL-DEFINE ttParent          ttEqpto
&GLOBAL-DEFINE DBOParentTable    hDBOEqpto

&GLOBAL-DEFINE page0KeyFields    ttEixo.num-eixo
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields ttEqpto.ep-codigo ttEqpto.cod-eqpto
&GLOBAL-DEFINE page1Fields       ttEixo.val-percent-suspen

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
ttEixo.num-eixo 
&Scoped-define ENABLED-TABLES ttEqpto ttEixo
&Scoped-define FIRST-ENABLED-TABLE ttEqpto
&Scoped-define SECOND-ENABLED-TABLE ttEixo
&Scoped-Define ENABLED-OBJECTS fiDescModelo btOK btSave btCancel btHelp ~
rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttEqpto.ep-codigo ttEqpto.cod-eqpto ~
ttEixo.num-eixo 
&Scoped-define DISPLAYED-TABLES ttEqpto ttEixo
&Scoped-define FIRST-DISPLAYED-TABLE ttEqpto
&Scoped-define SECOND-DISPLAYED-TABLE ttEixo
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
     SIZE 90 BY 3.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE rsDuplo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Simples", 1,
"Duplo", 2
     SIZE 28 BY 1 NO-UNDO.

DEFINE VARIABLE rsTracao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Direcional", 1,
"Tra‡Æo", 2
     SIZE 27 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 37 BY 1.75.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 37 BY 1.75.


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
     ttEixo.num-eixo AT ROW 3.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     btOK AT ROW 13.63 COL 2
     btSave AT ROW 13.63 COL 13
     btCancel AT ROW 13.63 COL 24
     btHelp AT ROW 13.63 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 13.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14
         FONT 1.

DEFINE FRAME fPage1
     ttEixo.val-percent-suspen AT ROW 2 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     rsTracao AT ROW 3.75 COL 22 NO-LABEL
     rsDuplo AT ROW 5.5 COL 22 NO-LABEL
     RECT-1 AT ROW 3.25 COL 18
     RECT-2 AT ROW 5 COL 18
     "Tipo Eixo" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 3 COL 20
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 5.7
         SIZE 84.43 BY 6.92
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttEixo T "?" NO-UNDO mgfro mab-configur-eixo
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
         HEIGHT             = 14
         WIDTH              = 90
         MAX-HEIGHT         = 14
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 14
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

ASSIGN XXTABVALXX = FRAME fPage1:MOVE-AFTER-TAB-ITEM (ttEixo.num-eixo:HANDLE IN FRAME fpage0)
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

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
apply "LEAVE":U to ttEqpto.cod-eqpto in frame fPage0.

/** Mostra Tipo de Eixo **/
run piEixo in this-procedure.

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
assign rsTracao:sensitive in frame fPage1 = yes
       rsDuplo:sensitive in frame fPage1 = yes.

/** Mostra Tipo de Eixo **/
run piEixo in this-procedure.
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
  Notes:       Override (antes) de salvar campos na tabela.
------------------------------------------------------------------------------*/
assign ttEixo.log-eixo-tracao = if input frame fPage1 rsTracao = 1
                                then no
                                else yes
       ttEixo.log-eixo-dpl    = if input frame fPage1 rsDuplo = 1
                                then no
                                else yes.

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

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEixo wMaintenanceNoNavigation 
PROCEDURE piEixo :
/*------------------------------------------------------------------------------
  Purpose:     piEixo
  Parameters:  <none>
  Notes:       Mostra em tela os valores dos tipos de eixo.
------------------------------------------------------------------------------*/
/** Busca dados em tabela **/
if pcAction <> "ADD":U then
    assign rsTracao = if ttEixo.log-eixo-tracao
                      then 2
                      else 1
           rsDuplo  = if ttEixo.log-eixo-dpl
                      then 2
                      else 1.
else
    /** Valor inicial **/
    assign rsTracao = 1
           rsDuplo  = 1.

/** Mostra na tela **/    
display rsTracao
        rsDuplo
    with frame fPage1.


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
    apply "ENTRY":U to {&ttTable}.num-eixo in frame fPage0.
else 
    apply "ENTRY":U to {&ttTable}.val-percent-suspen in frame fPage1.

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

