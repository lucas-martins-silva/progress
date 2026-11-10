&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttEqpto NO-UNDO LIKE mab-eqpto
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttProg NO-UNDO LIKE mab-programac-event
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
{include/i-prgvrs.i AB0138E 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0138e MAB}
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
&GLOBAL-DEFINE Program           AB0138E
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Seqencial, Alternado

&GLOBAL-DEFINE ttTable           ttProg
&GLOBAL-DEFINE hDBOTable         hDBOProg
&GLOBAL-DEFINE DBOTable          mab-programac-event

&GLOBAL-DEFINE ttParent          ttEqpto
&GLOBAL-DEFINE DBOParentTable    hDBOEqpto

&GLOBAL-DEFINE page0KeyFields    ttProg.cod-evento
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields ttEqpto.ep-codigo ttEqpto.cod-eqpto
&GLOBAL-DEFINE page1Fields       ttProg.cod-dia-mes-vencto ttProg.dat-inicial ~
                                 ttProg.dat-final ttProg.num-dia ~
                                 ttProg.num-parcela
&GLOBAL-DEFINE page2Fields       tg-parc-altern fi-dia-base ~
                                 tg-jan tg-fev tg-mar tg-abr tg-maio tg-jun ~
                                 tg-jul tg-ago tg-set tg-out tg-nov  tg-dez


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
DEFINE VARIABLE hDBOEvento    AS HANDLE NO-UNDO.

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
ttProg.cod-evento 
&Scoped-define ENABLED-TABLES ttEqpto ttProg
&Scoped-define FIRST-ENABLED-TABLE ttEqpto
&Scoped-define SECOND-ENABLED-TABLE ttProg
&Scoped-Define ENABLED-OBJECTS fiDescModelo fiDescEvento btOK btSave ~
btCancel btHelp rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttEqpto.ep-codigo ttEqpto.cod-eqpto ~
ttProg.cod-evento 
&Scoped-define DISPLAYED-TABLES ttEqpto ttProg
&Scoped-define FIRST-DISPLAYED-TABLE ttEqpto
&Scoped-define SECOND-DISPLAYED-TABLE ttProg
&Scoped-Define DISPLAYED-OBJECTS fiDescModelo fiDescEvento 

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

DEFINE VARIABLE fiDescEvento AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

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

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 44 BY 1.75.

DEFINE VARIABLE fi-dia-base AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Dia Base Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 56 BY 4.25.

DEFINE VARIABLE tg-abr AS LOGICAL INITIAL no 
     LABEL "Abril" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-ago AS LOGICAL INITIAL no 
     LABEL "Agosto" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dez AS LOGICAL INITIAL no 
     LABEL "Dezembro" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-fev AS LOGICAL INITIAL no 
     LABEL "Fevereiro" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-jan AS LOGICAL INITIAL no 
     LABEL "Janeiro" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-jul AS LOGICAL INITIAL no 
     LABEL "Julho" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-jun AS LOGICAL INITIAL no 
     LABEL "Junho" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-maio AS LOGICAL INITIAL no 
     LABEL "Maio" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mar AS LOGICAL INITIAL no 
     LABEL "Mar‡o" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-nov AS LOGICAL INITIAL no 
     LABEL "Novembro" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-out AS LOGICAL INITIAL no 
     LABEL "Outubro" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-parc-altern AS LOGICAL INITIAL no 
     LABEL "Parcelas Alternadas" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-set AS LOGICAL INITIAL no 
     LABEL "Setembro" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.


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
     ttProg.cod-evento AT ROW 3.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fiDescEvento AT ROW 3.25 COL 36.57 COLON-ALIGNED HELP
          "Descri‡Æo do Evento" NO-LABEL
     btOK AT ROW 14.63 COL 2
     btSave AT ROW 14.63 COL 13
     btCancel AT ROW 14.63 COL 24
     btHelp AT ROW 14.63 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 14.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 15
         FONT 1.

DEFINE FRAME fPage1
     ttProg.cod-dia-mes-vencto AT ROW 2.25 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     ttProg.dat-inicial AT ROW 4 COL 32.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttProg.dat-final AT ROW 4 COL 52 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttProg.num-dia AT ROW 5.5 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     ttProg.num-parcela AT ROW 6.5 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     RECT-1 AT ROW 3.5 COL 24
     "Validade" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 3.29 COL 25.43
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 5.7
         SIZE 84.43 BY 7.92
         FONT 1.

DEFINE FRAME fPage2
     tg-parc-altern AT ROW 1.5 COL 17.14
     fi-dia-base AT ROW 2.5 COL 15.14 COLON-ALIGNED
     tg-jan AT ROW 4.42 COL 21.43
     tg-abr AT ROW 4.42 COL 33.86
     tg-jul AT ROW 4.42 COL 45.57
     tg-out AT ROW 4.42 COL 57.57
     tg-fev AT ROW 5.67 COL 21.43
     tg-maio AT ROW 5.67 COL 33.86
     tg-ago AT ROW 5.67 COL 45.57
     tg-nov AT ROW 5.67 COL 57.57
     tg-mar AT ROW 6.88 COL 21.43
     tg-jun AT ROW 6.88 COL 33.86
     tg-set AT ROW 6.88 COL 45.57
     tg-dez AT ROW 6.88 COL 57.57
     RECT-3 AT ROW 3.83 COL 17
     "Meses" VIEW-AS TEXT
          SIZE 6.14 BY .75 AT ROW 3.54 COL 18.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 5.7
         SIZE 84.43 BY 7.92
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
      TABLE: ttProg T "?" NO-UNDO mgfro mab-programac-event
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
         HEIGHT             = 15
         WIDTH              = 90
         MAX-HEIGHT         = 15
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 15
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fPage1:MOVE-AFTER-TAB-ITEM (fiDescEvento:HANDLE IN FRAME fpage0)
       XXTABVALXX = FRAME fPage1:MOVE-BEFORE-TAB-ITEM (btOK:HANDLE IN FRAME fpage0)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FRAME fPage2
                                                                        */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttProg.cod-dia-mes-vencto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttProg.cod-dia-mes-vencto wMaintenanceNoNavigation
ON LEAVE OF ttProg.cod-dia-mes-vencto IN FRAME fPage1 /* Dia Mˆs Vencimento */
DO:
  run consisteDiaMes in {&hDBOTable} (input input frame fPage1 ttProg.cod-dia-mes-vencto).
  if return-value = "NOK":U then do:
    /** Instancia aplicativo **/
    {method/showmessage.i1}
    /** Busca erros na BO **/
    run getRowErrors in {&hDBOTable} (output table RowErrors).
    /** Mostra caixa com erros **/
    {method/showmessage.i2 &Modal="YES"}
    /** Limpa temp-tables de erros **/
    run emptyRowErrors in {&hDBOTable}.
    return no-apply.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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


&Scoped-define SELF-NAME ttProg.cod-evento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttProg.cod-evento wMaintenanceNoNavigation
ON F5 OF ttProg.cod-evento IN FRAME fpage0 /* Evento */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr010.w"
           &FieldZoom1="cod-evento"
           &FieldScreen1="ttProg.cod-evento"
           &Frame1="fPage0"
           &FieldZoom2="des-evento"
           &FieldScreen2="fiDescEvento"
           &Frame2="fPage0"
           &EnableImplant="YES"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttProg.cod-evento wMaintenanceNoNavigation
ON LEAVE OF ttProg.cod-evento IN FRAME fpage0 /* Evento */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOEvento"
        &KeyValue1="ttProg.cod-evento:screen-value in frame fPage0"
        &FieldName1="des-evento"
        &FieldScreen1="fiDescEvento"
        &Frame1="fPage0"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttProg.cod-evento wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttProg.cod-evento IN FRAME fpage0 /* Evento */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tg-parc-altern
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-parc-altern wMaintenanceNoNavigation
ON VALUE-CHANGED OF tg-parc-altern IN FRAME fPage2 /* Parcelas Alternadas */
DO:
    /*habilita e desabilita determinados campos conforme o toggle Parcelas Alternadas*/
    IF tg-parc-altern:CHECKED IN FRAME fPage2 THEN
        ASSIGN fi-dia-base:SENSITIVE IN FRAME fPage2 = YES
               tg-jan:SENSITIVE IN FRAME fPage2 = YES
               tg-fev:SENSITIVE IN FRAME fPage2 = YES
               tg-mar:SENSITIVE IN FRAME fPage2 = YES
               tg-abr:SENSITIVE IN FRAME fPage2 = YES
               tg-maio:SENSITIVE IN FRAME fPage2 = YES
               tg-jun:SENSITIVE IN FRAME fPage2 = YES
               tg-jul:SENSITIVE IN FRAME fPage2 = YES
               tg-ago:SENSITIVE IN FRAME fPage2 = YES
               tg-set:SENSITIVE IN FRAME fPage2 = YES
               tg-out:SENSITIVE IN FRAME fPage2 = YES
               tg-nov:SENSITIVE IN FRAME fPage2 = YES
               tg-dez:SENSITIVE IN FRAME fPage2 = YES
               ttProg.cod-dia-mes-vencto:SENSITIVE IN FRAME fPage1 = NO
               ttProg.num-parcela:SENSITIVE IN FRAME fPage1 = NO.

    ELSE
        ASSIGN fi-dia-base:SENSITIVE IN FRAME fPage2 = NO
               tg-jan:SENSITIVE IN FRAME fPage2 = NO
               tg-fev:SENSITIVE IN FRAME fPage2 = NO
               tg-mar:SENSITIVE IN FRAME fPage2 = NO
               tg-abr:SENSITIVE IN FRAME fPage2 = NO
               tg-maio:SENSITIVE IN FRAME fPage2 = NO
               tg-jun:SENSITIVE IN FRAME fPage2 = NO
               tg-jul:SENSITIVE IN FRAME fPage2 = NO
               tg-ago:SENSITIVE IN FRAME fPage2 = NO
               tg-set:SENSITIVE IN FRAME fPage2 = NO
               tg-out:SENSITIVE IN FRAME fPage2 = NO
               tg-nov:SENSITIVE IN FRAME fPage2 = NO
               tg-dez:SENSITIVE IN FRAME fPage2 = NO
               ttProg.cod-dia-mes-vencto:SENSITIVE IN FRAME fPage1 = YES
               ttProg.num-parcela:SENSITIVE IN FRAME fPage1 = YES.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

{&ttTable}.cod-evento:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in frame fPage0.

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

/** Evento **/
if valid-handle(hDBOEvento) then
    run Destroy in hDBOEvento.

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
apply "LEAVE":U to ttProg.cod-evento in frame fPage0.

IF AVAIL ttProg THEN DO:

    ASSIGN tg-parc-altern:CHECKED IN FRAME fPage2 = ttProg.log-livre-1
           fi-dia-base:SCREEN-VALUE IN FRAME fPage2 = STRING(ttProg.num-livre-1).

    IF ttProg.cod-livre-1 <> "":U THEN
           /*Meses - sao gravados no campo livre da seguinte forma: 1,s,2,n,3,s,4,n, e assim por diante.*/
        ASSIGN tg-jan:CHECKED IN FRAME fPage2  = IF substring(ttProg.cod-livre-1,1,1)  = "s":U THEN YES ELSE NO
               tg-fev:CHECKED IN FRAME fPage2  = IF substring(ttProg.cod-livre-1,2,1)  = "s":U THEN YES ELSE NO
               tg-mar:CHECKED IN FRAME fPage2  = IF substring(ttProg.cod-livre-1,3,1)  = "s":U THEN YES ELSE NO
               tg-abr:CHECKED IN FRAME fPage2  = IF substring(ttProg.cod-livre-1,4,1)  = "s":U THEN YES ELSE NO
               tg-maio:CHECKED IN FRAME fPage2 = IF substring(ttProg.cod-livre-1,5,1)  = "s":U THEN YES ELSE NO
               tg-jun:CHECKED IN FRAME fPage2  = IF substring(ttProg.cod-livre-1,6,1)  = "s":U THEN YES ELSE NO
               tg-jul:CHECKED IN FRAME fPage2  = IF substring(ttProg.cod-livre-1,7,1)  = "s":U THEN YES ELSE NO
               tg-ago:CHECKED IN FRAME fPage2  = IF substring(ttProg.cod-livre-1,8,1)  = "s":U THEN YES ELSE NO
               tg-set:CHECKED IN FRAME fPage2  = IF substring(ttProg.cod-livre-1,9,1)  = "s":U THEN YES ELSE NO
               tg-out:CHECKED IN FRAME fPage2  = IF substring(ttProg.cod-livre-1,10,1) = "s":U THEN YES ELSE NO
               tg-nov:CHECKED IN FRAME fPage2  = IF substring(ttProg.cod-livre-1,11,1) = "s":U THEN YES ELSE NO
               tg-dez:CHECKED IN FRAME fPage2  = IF substring(ttProg.cod-livre-1,12,1) = "s":U THEN YES ELSE NO NO-ERROR.
END.

/** Busca data atual para Dia/Mes **/
IF pcAction = "ADD":U THEN
    run piDiaMes in this-procedure.

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

APPLY "value-changed":U TO tg-parc-altern IN FRAME fPage2.

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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF AVAIL ttProg THEN DO:

    IF tg-parc-altern:CHECKED IN FRAME fPage2 THEN
        ASSIGN ttProg.log-livre-1 = YES
               ttProg.num-livre-1 = int(fi-dia-base:SCREEN-VALUE IN FRAME fPage2) 
               /*Meses - sao gravados no campo livre da seguinte forma: 1,s,2,n,3,s,4,n, e assim por diante.*/
               ttProg.cod-livre-1 =     (IF tg-jan:CHECKED IN FRAME fPage2  THEN "s":U ELSE "n":U) + 
                                        (IF tg-fev:CHECKED IN FRAME fPage2  THEN "s":U ELSE "n":U) + 
                                        (IF tg-mar:CHECKED IN FRAME fPage2  THEN "s":U ELSE "n":U) + 
                                        (IF tg-abr:CHECKED IN FRAME fPage2  THEN "s":U ELSE "n":U) + 
                                        (IF tg-maio:CHECKED IN FRAME fPage2 THEN "s":U ELSE "n":U) + 
                                        (IF tg-jun:CHECKED IN FRAME fPage2  THEN "s":U ELSE "n":U) + 
                                        (IF tg-jul:CHECKED IN FRAME fPage2  THEN "s":U ELSE "n":U) + 
                                        (IF tg-ago:CHECKED IN FRAME fPage2  THEN "s":U ELSE "n":U) + 
                                        (IF tg-set:CHECKED IN FRAME fPage2  THEN "s":U ELSE "n":U) + 
                                        (IF tg-out:CHECKED IN FRAME fPage2  THEN "s":U ELSE "n":U) + 
                                        (IF tg-nov:CHECKED IN FRAME fPage2  THEN "s":U ELSE "n":U) + 
                                        (IF tg-dez:CHECKED IN FRAME fPage2  THEN "s":U ELSE "n":U)
               /*Zera os valores dos campos que vÆo ficar desabilitados*/
               ttProg.cod-dia-mes-vencto:SCREEN-VALUE IN FRAME fPage1 = "00/00":U
               ttProg.num-parcela:SCREEN-VALUE IN FRAME fPage1        = "0".
    ELSE
        ASSIGN ttProg.log-livre-1 = NO
               ttProg.num-livre-1 = 0
               ttProg.cod-livre-1 = "":U.

END.


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

    /*--- DBO Evento ---*/
    IF NOT VALID-HANDLE(hDBOEvento) OR
       hDBOEvento:TYPE <> "PROCEDURE":U OR
       hDBOEvento:FILE-NAME <> "frbo~\bofr010.p":U THEN DO:
        run frbo/bofr010.p persistent set  hDBOEvento.
    END.
    
    RUN openQueryStatic IN hDBOEvento (INPUT "Main":U) NO-ERROR.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDiaMes wMaintenanceNoNavigation 
PROCEDURE piDiaMes :
/*------------------------------------------------------------------------------
  Purpose:     piDiaMes
  Parameters:  <none>
  Notes:       Busca a data atual com dia e mˆs para mostrar em tela.
------------------------------------------------------------------------------*/
DEFINE VARIABLE iDia AS INTEGER    NO-UNDO.
DEFINE VARIABLE iMes AS INTEGER    NO-UNDO.

/** Somente se for inclu¡do registros **/
if pcAction = "ADD":U then do:
    assign iDia = day(today)
           iMes = month(today)
           ttProg.cod-dia-mes-vencto = string(iDia,"99") + string(iMes,"99").
    
    display ttProg.cod-dia-mes-vencto
        with frame fPage1.
end.

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
    apply "ENTRY":U to {&ttTable}.cod-evento in frame fPage0.
else 
    apply "ENTRY":U to {&ttTable}.cod-dia-mes-vencto in frame fPage1.

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

