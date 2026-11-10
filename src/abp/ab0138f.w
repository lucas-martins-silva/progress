&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttEqpto NO-UNDO LIKE mab-eqpto
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttPlano NO-UNDO LIKE mmv-eqpto-plano
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
{include/i-prgvrs.i AB0138F 2.00.00.003 } /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0138f MAB}
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
&GLOBAL-DEFINE Program           AB0138F
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Pag. 1

&GLOBAL-DEFINE ttTable           ttPlano
&GLOBAL-DEFINE hDBOTable         hDBOPlano
&GLOBAL-DEFINE DBOTable          mmv-eqpto-plano

&GLOBAL-DEFINE ttParent          ttEqpto
&GLOBAL-DEFINE DBOParentTable    hDBOEqpto

&GLOBAL-DEFINE page0KeyFields    ttPlano.cod-plano
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields ttEqpto.ep-codigo ttEqpto.cod-eqpto ~
                                 ttEqpto.cod-model
&GLOBAL-DEFINE page1Fields       ttPlano.dat-inicial ttPlano.dat-final ttPlano.val-km-inicial ttPlano.dat-atualiz

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cTpPlano AS CHARACTER NO-UNDO.
DEFINE VARIABLE lDataInvalida AS LOGICAL INITIAL NO NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOPlanoPrev    AS HANDLE NO-UNDO.

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
ttPlano.cod-plano ttEqpto.cod-model 
&Scoped-define ENABLED-TABLES ttEqpto ttPlano
&Scoped-define FIRST-ENABLED-TABLE ttEqpto
&Scoped-define SECOND-ENABLED-TABLE ttPlano
&Scoped-Define ENABLED-OBJECTS fiDescModelo btOK btSave btCancel btHelp ~
fiDescPlano rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttEqpto.ep-codigo ttEqpto.cod-eqpto ~
ttPlano.cod-plano ttEqpto.cod-model 
&Scoped-define DISPLAYED-TABLES ttEqpto ttPlano
&Scoped-define FIRST-DISPLAYED-TABLE ttEqpto
&Scoped-define SECOND-DISPLAYED-TABLE ttPlano
&Scoped-Define DISPLAYED-OBJECTS fiDescModelo fiDescPlano 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ultimoDiaMes wMaintenanceNoNavigation 
FUNCTION ultimoDiaMes RETURNS CHARACTER
  ( pMes AS INTEGER,
    pAno AS INTEGER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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

DEFINE VARIABLE fiDescPlano AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttEqpto.ep-codigo AT ROW 1.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttEqpto.cod-eqpto AT ROW 2.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     fiDescModelo AT ROW 2.25 COL 41 COLON-ALIGNED HELP
          "Descri‡Æo Modelo Equipamento" NO-LABEL
     ttPlano.cod-plano AT ROW 4.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     btOK AT ROW 12.71 COL 2
     btSave AT ROW 12.71 COL 13
     btCancel AT ROW 12.71 COL 24
     btHelp AT ROW 12.71 COL 80
     ttEqpto.cod-model AT ROW 3.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     fiDescPlano AT ROW 4.25 COL 37 COLON-ALIGNED HELP
          "Descri‡Æo Modelo Equipamento" NO-LABEL
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 12.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 13
         FONT 1.

DEFINE FRAME fPage1
     ttPlano.dat-inicial AT ROW 2.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttPlano.dat-final AT ROW 2.25 COL 43.29 COLON-ALIGNED
          LABEL "Validade":R12
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttPlano.val-km-inicial AT ROW 3.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ttPlano.dat-atualiz AT ROW 4.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.7
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
      TABLE: ttPlano T "?" NO-UNDO mgfro mmv-eqpto-plano
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
         HEIGHT             = 13
         WIDTH              = 90
         MAX-HEIGHT         = 13
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 13
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

ASSIGN XXTABVALXX = FRAME fPage1:MOVE-AFTER-TAB-ITEM (ttPlano.cod-plano:HANDLE IN FRAME fpage0)
       XXTABVALXX = FRAME fPage1:MOVE-BEFORE-TAB-ITEM (btOK:HANDLE IN FRAME fpage0)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN ttPlano.dat-final IN FRAME fPage1
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


&Scoped-define SELF-NAME ttPlano.cod-plano
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttPlano.cod-plano wMaintenanceNoNavigation
ON F5 OF ttPlano.cod-plano IN FRAME fpage0 /* Plano Manuten‡Æo */
DO:
        {method/zoomfields.i 
        &ProgramZoom="frzoom~\z01fr035.w"
        &FieldZoom1="cod-plano"
        &FieldScreen1="ttPlano.cod-plano"
        &Frame1="fPage0"
        &FieldZoom2="des-plano-manut"
        &FieldScreen2="fiDescPlano"
        &Frame2="fPage0"
        &EnableImplant="YES"
        &RunMethod="run piSetaModelo in hProgramZoom (input {&ttParent}.cod-model)."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttPlano.cod-plano wMaintenanceNoNavigation
ON LEAVE OF ttPlano.cod-plano IN FRAME fpage0 /* Plano Manuten‡Æo */
DO:
    {method/ReferenceFields.i
      &HandleDBOLeave="hDBOPlanoPrev"
      &KeyValue1="input frame fPage0 tteqpto.cod-model"
      &KeyValue2="input frame fPage0 ttPlano.cod-plano"
      &FieldName1="des-plano-manut"
      &FieldScreen1="fiDescPlano"
      &Frame1="fPage0"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttPlano.cod-plano wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttPlano.cod-plano IN FRAME fpage0 /* Plano Manuten‡Æo */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttPlano.dat-atualiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttPlano.dat-atualiz wMaintenanceNoNavigation
ON LEAVE OF ttPlano.dat-atualiz IN FRAME fPage1 /* éltima Baixa */
DO:
    ASSIGN lDataInvalida = NO.
    IF  ENTRY(2,SELF:SCREEN-VALUE,"/") >  "12" OR 
        ENTRY(2,SELF:SCREEN-VALUE,"/") <  "01" THEN DO:
        ASSIGN lDataInvalida = YES.
    END.

    IF  ENTRY(3,SELF:SCREEN-VALUE,"/") < "0001" OR ENTRY(3,SELF:SCREEN-VALUE,"/") > "9999" THEN DO:
        ASSIGN lDataInvalida = YES.
    END.

    IF  ENTRY(1,SELF:SCREEN-VALUE,"/") = "00" OR 
        ENTRY(1,SELF:SCREEN-VALUE,"/") > ultimoDiaMes(INT(ENTRY(2,SELF:SCREEN-VALUE,"/")),INT(ENTRY(3,SELF:SCREEN-VALUE,"/"))) THEN DO:
        ASSIGN lDataInvalida = YES.
    END.

    IF  lDataInvalida THEN DO:
        {utp/ut-liter.i "éltima_Baixa"}
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 29563, INPUT RETURN-VALUE).
        ASSIGN lDataInvalida = NO.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttPlano.dat-final
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttPlano.dat-final wMaintenanceNoNavigation
ON LEAVE OF ttPlano.dat-final IN FRAME fPage1 /* Validade */
DO:
    ASSIGN lDataInvalida = NO.
    IF  ENTRY(2,SELF:SCREEN-VALUE,"/") >  "12" OR 
        ENTRY(2,SELF:SCREEN-VALUE,"/") <  "01" THEN DO:
        ASSIGN lDataInvalida = YES.
    END.

    IF  ENTRY(3,SELF:SCREEN-VALUE,"/") < "0001" OR ENTRY(3,SELF:SCREEN-VALUE,"/") > "9999" THEN DO:
        ASSIGN lDataInvalida = YES.
    END.

    IF  ENTRY(1,SELF:SCREEN-VALUE,"/") = "00" OR 
        ENTRY(1,SELF:SCREEN-VALUE,"/") > ultimoDiaMes(INT(ENTRY(2,SELF:SCREEN-VALUE,"/")),INT(ENTRY(3,SELF:SCREEN-VALUE,"/"))) THEN DO:
        ASSIGN lDataInvalida = YES.
    END.

    IF  lDataInvalida THEN DO:
        {utp/ut-liter.i "Validade"}
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 29563, INPUT RETURN-VALUE).
        ASSIGN lDataInvalida = NO.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttPlano.dat-inicial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttPlano.dat-inicial wMaintenanceNoNavigation
ON LEAVE OF ttPlano.dat-inicial IN FRAME fPage1 /* Inicial */
DO:
    IF ttPlano.dat-atualiz  = ? THEN
        DISPLAY INPUT ttPlano.dat-inicial  @ ttPlano.dat-atualiz WITH FRAME fpage1.

    ASSIGN lDataInvalida = NO.
    IF  ENTRY(2,SELF:SCREEN-VALUE,"/") >  "12" OR 
        ENTRY(2,SELF:SCREEN-VALUE,"/") <  "01" THEN DO:
        ASSIGN lDataInvalida = YES.
    END.

    IF  ENTRY(3,SELF:SCREEN-VALUE,"/") < "0001" OR ENTRY(3,SELF:SCREEN-VALUE,"/") > "9999" THEN DO:
        ASSIGN lDataInvalida = YES.
    END.

    IF  ENTRY(1,SELF:SCREEN-VALUE,"/") = "00" OR 
        ENTRY(1,SELF:SCREEN-VALUE,"/") > ultimoDiaMes(INT(ENTRY(2,SELF:SCREEN-VALUE,"/")),INT(ENTRY(3,SELF:SCREEN-VALUE,"/"))) THEN DO:
        ASSIGN lDataInvalida = YES.
    END.

    IF  lDataInvalida THEN DO:
        {utp/ut-liter.i "Inicial"}
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 29563, INPUT RETURN-VALUE).
        ASSIGN lDataInvalida = NO.
        RETURN NO-APPLY.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

{&ttTable}.cod-plano:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in frame fPage0.

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

/** DBO Plano  **/
if valid-handle (hDBOPlanoPrev) then
    run destroy in hDBOPlanoPrev.

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
  Notes:       Override (ap¢s) display campos em tela
------------------------------------------------------------------------------*/
/** Descri‡äes de campos **/
apply "LEAVE":U to ttEqpto.cod-eqpto in frame fPage0.
apply "LEAVE":U to ttPlano.cod-plano in frame fPage0.

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

IF  pcAction = "ADD":U OR
    pcAction = "COPY":U THEN
    ASSIGN ttPlano.dat-final:SCREEN-VALUE IN FRAME fPage1 = "31/12/9999".

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

    IF NOT VALID-HANDLE(hDBOPlanoPrev) OR
       hDBOPlanoPrev:TYPE <> "PROCEDURE":U OR
       hDBOPlanoPrev:FILE-NAME <> "frbo~\bofr035.p":U THEN DO:
        run frbo/bofr035.p persistent set  hDBOPlanoPrev.
    END.
    
    RUN openQueryStatic IN hDBOPlanoPrev (INPUT "Main":U) NO-ERROR.
    
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
    apply "ENTRY":U to {&ttTable}.cod-plano in frame fPage0.
else
    apply "ENTRY":U to {&ttTable}.dat-inicial in frame fPage1.

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ultimoDiaMes wMaintenanceNoNavigation 
FUNCTION ultimoDiaMes RETURNS CHARACTER
  ( pMes AS INTEGER,
    pAno AS INTEGER /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Retornar Ultimo dia do M¼s
    Notes:  
------------------------------------------------------------------------------*/
    /* Resultado para verificar se ano bisexto */
    DEFINE VARIABLE dResult AS DECIMAL NO-UNDO. 

    /* Calculo para verificar se ano bisexto */
    ASSIGN dResult = (pAno) MOD 4.

    /* Verifica qual mes do ano */
    CASE pMes:
        /* Meses com 31 dias */
        WHEN 1  OR
        WHEN 3  OR
        WHEN 5  OR
        WHEN 7  OR 
        WHEN 8  OR
        WHEN 10 OR
        WHEN 12 THEN do:
            RETURN "31". 
        END.
        WHEN 2 THEN DO:
            /* Se ano ý bisexto Fevererio tem 29 dias */             
            IF dResult = 0 THEN
                RETURN "29". 
            ELSE
                RETURN "28".                
        END.
        OTHERWISE DO:
            /** SenÊo ßltimo dia do mes ý 30 **/
            RETURN "30". 
        END.
    END CASE.

  RETURN "0".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

