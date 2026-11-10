&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-posto NO-UNDO LIKE mab-posto
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
{include/i-prgvrs.i AB0118A 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0118a MAB}
&ENDIF



CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program            AB0118A
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       0

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           TTmab-posto
&GLOBAL-DEFINE hDBOTable         hDBOPosto
&GLOBAL-DEFINE DBOTable          mab-posto


&GLOBAL-DEFINE page0KeyFields   TTmab-posto.cod-posto
 
 &GLOBAL-DEFINE page0Fields     TTmab-posto.des-posto ~
                                TTmab-posto.cod-depos ~
                                TTmab-posto.cod-estabel ~
                                TTmab-posto.idi-posto ~
                                TTmab-posto.ep-codigo ~
                                TTmab-posto.cod-emitente


&GLOBAL-DEFINE page1Fields     

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}       AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEmitente       AS HANDLE     NO-UNDO.

DEFINE VARIABLE l-achou     AS LOGICAL NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE wMaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS TTmab-posto.cod-posto TTmab-posto.des-posto ~
TTmab-posto.ep-codigo TTmab-posto.cod-estabel TTmab-posto.cod-depos ~
TTmab-posto.idi-posto TTmab-posto.cod-emitente 
&Scoped-define ENABLED-TABLES TTmab-posto
&Scoped-define FIRST-ENABLED-TABLE TTmab-posto
&Scoped-define DISPLAYED-TABLES TTmab-posto
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-posto
&Scoped-Define ENABLED-OBJECTS cDescEmp cDescEstab cDescDep cDescFornec ~
btOK btSave btCancel btHelp fiTipo RECT-19 RECT-24 rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS TTmab-posto.cod-posto TTmab-posto.des-posto ~
TTmab-posto.ep-codigo TTmab-posto.cod-estabel TTmab-posto.cod-depos ~
TTmab-posto.idi-posto TTmab-posto.cod-emitente 
&Scoped-Define DISPLAYED-OBJECTS cDescEmp cDescEstab cDescDep cDescFornec ~
fiTipo 

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

DEFINE VARIABLE cDescDep AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE cDescEmp AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE cDescEstab AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE cDescFornec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE fiTipo AS CHARACTER FORMAT "X(256)":U INITIAL "Tipo Posto" 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 48 BY 1.5.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 7.5.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     TTmab-posto.cod-posto AT ROW 1.42 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-posto.des-posto AT ROW 2.71 COL 23.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 48.14 BY .88
     TTmab-posto.ep-codigo AT ROW 3.71 COL 23.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     cDescEmp AT ROW 3.71 COL 32 COLON-ALIGNED NO-LABEL
     TTmab-posto.cod-estabel AT ROW 4.75 COL 23.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     cDescEstab AT ROW 4.75 COL 32 COLON-ALIGNED NO-LABEL
     TTmab-posto.cod-depos AT ROW 5.75 COL 23.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     cDescDep AT ROW 5.75 COL 32 COLON-ALIGNED NO-LABEL
     TTmab-posto.idi-posto AT ROW 7.5 COL 29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Pr¢prio", 1,
"Terceiro", 2
          SIZE 34 BY .71
     TTmab-posto.cod-emitente AT ROW 8.79 COL 23.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     cDescFornec AT ROW 8.79 COL 32 COLON-ALIGNED NO-LABEL
     btOK AT ROW 10.29 COL 2
     btSave AT ROW 10.29 COL 13
     btCancel AT ROW 10.29 COL 24
     btHelp AT ROW 10.29 COL 80
     fiTipo AT ROW 6.75 COL 25 COLON-ALIGNED NO-LABEL
     RECT-19 AT ROW 7 COL 25.86
     RECT-24 AT ROW 2.5 COL 1
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 10.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 10.63
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: wMaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: TTmab-posto T "?" NO-UNDO mgfro mab-posto
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
         TITLE              = "Manuten‡Æo de Postos de Combust¡vel"
         HEIGHT             = 10.63
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
ON END-ERROR OF wMaintenanceNoNavigation /* Manuten‡Æo de Postos de Combust¡vel */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation /* Manuten‡Æo de Postos de Combust¡vel */
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


&Scoped-define SELF-NAME TTmab-posto.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-posto.cod-depos wMaintenanceNoNavigation
ON F5 OF TTmab-posto.cod-depos IN FRAME fpage0 /* Dep¢sito */
DO:
   assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                     &campo=TTmab-posto.cod-depos
                     &campozoom=cod-depos
                     &campo2=cDescDep
                     &campozoom2=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-posto.cod-depos wMaintenanceNoNavigation
ON LEAVE OF TTmab-posto.cod-depos IN FRAME fpage0 /* Dep¢sito */
DO:
    ASSIGN cDescDep:SCREEN-VALUE IN FRAME fPage0 = "":U.
    FOR FIRST deposito FIELDS(cod-depos  nome)
         WHERE deposito.cod-depos = TTmab-posto.cod-depos:SCREEN-VALUE IN FRAME fPage0 NO-LOCK:
         ASSIGN cDescDep:SCREEN-VALUE IN FRAME fPage0 = deposito.nome.
     END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-posto.cod-depos wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-posto.cod-depos IN FRAME fpage0 /* Dep¢sito */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-posto.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-posto.cod-emitente wMaintenanceNoNavigation
ON F5 OF TTmab-posto.cod-emitente IN FRAME fpage0 /* Emitente */
DO:
  assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="adzoom/z01ad098.w"
                     &campo=TTmab-posto.cod-emitente
                     &campozoom=cod-emitente
                     &campo2=cDescFornec
                     &campozoom2=nome-emit}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-posto.cod-emitente wMaintenanceNoNavigation
ON LEAVE OF TTmab-posto.cod-emitente IN FRAME fpage0 /* Emitente */
DO:
   {method/ReferenceFields.i
        &HandleDBOLeave="hDBOEmitente"
        &KeyValue1="TTmab-posto.cod-emitente:screen-value in frame fPage0"
        &FieldName1="cod-emitente"
        &FieldScreen1="cod-emitente"
        &Frame1="fPage0"
        &FieldName2="nome-emit"
        &FieldScreen2="cDescFornec"
        &Frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-posto.cod-emitente wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-posto.cod-emitente IN FRAME fpage0 /* Emitente */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-posto.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-posto.cod-estabel wMaintenanceNoNavigation
ON F5 OF TTmab-posto.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=TTmab-posto.cod-estabel
                     &campozoom=cod-estabel
                     &campo2=cDescEstab
                     &campozoom2=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-posto.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF TTmab-posto.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
   assign cDescEstab:SCREEN-VALUE IN FRAME fPage0 = "":U.
   FOR FIRST estabelec FIELDS(cod-estabel  nome)
       WHERE estabelec.cod-estabel = TTmab-posto.cod-estabel:SCREEN-VALUE IN FRAME fPage0 NO-LOCK:
       ASSIGN cDescEstab:SCREEN-VALUE IN FRAME fPage0 = estabelec.nome.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-posto.cod-estabel wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-posto.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-posto.ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-posto.ep-codigo wMaintenanceNoNavigation
ON F5 OF TTmab-posto.ep-codigo IN FRAME fpage0 /* Empresa */
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad101.w
                     &campo=TTmab-posto.ep-codigo
                     &campozoom=ep-codigo
                     &frame=fPage0}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-posto.ep-codigo wMaintenanceNoNavigation
ON LEAVE OF TTmab-posto.ep-codigo IN FRAME fpage0 /* Empresa */
DO:
  ASSIGN cDescEmp:SCREEN-VALUE IN FRAME fPage0 = "":U.
  FOR FIRST empresa FIELDS(ep-codigo  nome)
       WHERE empresa.ep-codigo = INPUT FRAME fPage0 TTmab-posto.ep-codigo NO-LOCK:
       ASSIGN cDescEmp:SCREEN-VALUE IN FRAME fPage0 = empresa.nome.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-posto.ep-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-posto.ep-codigo IN FRAME fpage0 /* Empresa */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-posto.idi-posto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-posto.idi-posto wMaintenanceNoNavigation
ON VALUE-CHANGED OF TTmab-posto.idi-posto IN FRAME fpage0
DO:
  CASE INPUT {&tttable}.idi-posto:
      WHEN 1 THEN DO:
          ASSIGN {&ttTable}.cod-emitente:SENSITIVE IN FRAME fPage0 = NO.
      END.
      WHEN 2  THEN DO:
           ASSIGN {&ttTable}.cod-emitente:SENSITIVE IN FRAME fPage0 = YES.
      END.
  END CASE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


TTmab-posto.cod-depos:load-mouse-pointer ("image/lupa.cur")  in frame fPage0.
TTmab-posto.cod-estabel:load-mouse-pointer ("image/lupa.cur") in frame fPage0.
TTmab-posto.cod-emitente:load-mouse-pointer ("image/lupa.cur") in frame fPage0.
TTmab-posto.ep-codigo:load-mouse-pointer ("image/lupa.cur") in frame fPage0.
/*--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

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
IF VALID-HANDLE(hDBOEmitente) THEN
       RUN destroy IN hDBOEmitente .

 

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
if pcAction <> "ADD" then do:
    disp {&ttTable}.cod-depos 
         {&ttTable}.cod-estabel 
         {&tttable}.idi-posto  
        with frame fPage0.
end.

apply "LEAVE":U to {&ttTable}.cod-depos    in frame fPage0.
apply "LEAVE":U to {&ttTable}.cod-estabel  in frame fPage0.
apply "LEAVE":U to {&ttTable}.cod-emitente in frame fPage0.
apply "LEAVE":U to {&ttTable}.ep-codigo    in frame fPage0.

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

if pcAction = "ADD":U  then do:
    RUN emptyRowErrors IN {&hDBOTable}.
    if return-value = "OK":U then
        DISP TTmab-posto.cod-posto with  frame fPage0.
    else do:
        RUN getRowErrors IN {&hDBOTable} (OUTPUT TABLE RowErrors).
        {method/showmessage.i1}
        {method/showmessage.i2}
    end.
end.

apply "VALUE-CHANGED":U to {&tttable}.idi-posto    in frame fPage0.
  
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
{utp/ut-liter.i "Tipo Posto"}
assign fiTipo:screen-value in frame fPage0 = trim(return-value).

if pcAction = "UPDATE":U  THEN DO:
    ASSIGN TTmab-posto.cod-depos:SENSITIVE IN FRAME fPage0 = YES
           TTmab-posto.cod-estabel:SENSITIVE IN FRAME fPage0 = YES
           TTmab-posto.idi-posto:SENSITIVE IN FRAME fPage0 = YES.
end.

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
IF NOT VALID-HANDLE({&hDBOTable}) OR 
         {&hDBOTable}:TYPE <> "PROCEDURE":U OR
         {&hDBOTable}:FILE-NAME <> "frbo~\bofr021.p":U THEN DO:
        RUN frbo/bofr021.p PERSISTENT SET  {&hDBOTable}.
END.
RUN openQueryStatic in   {&hDBOTable} (input "Main":U) NO-ERROR.


IF NOT VALID-HANDLE(hDBOEmitente) OR 
         hDBOEmitente:TYPE <> "PROCEDURE":U OR
         hDBOEmitente:FILE-NAME <> "adbo/boad098na.p":U THEN DO:
        RUN adbo/boad098na.p PERSISTENT SET  hDBOEmitente.
END.
RUN openQueryStatic in   hDBOEmitente (input "Main":U) NO-ERROR.


  


     
RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

