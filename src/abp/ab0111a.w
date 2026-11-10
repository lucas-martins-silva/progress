&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-motoris NO-UNDO LIKE mab-motoris
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
{include/i-prgvrs.i AB0111A 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0111a MAB}
&ENDIF



CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AB0111A
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder           NO
&GLOBAL-DEFINE InitialPage      

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           TTmab-motoris
&GLOBAL-DEFINE hDBOTable         hDBOMotoris
&GLOBAL-DEFINE DBOTable          mab-motoris


&GLOBAL-DEFINE page0KeyFields   TTmab-motoris.ep-codigo TTmab-motoris.cod-estabel TTmab-motoris.cod-matr 
                                
&GLOBAL-DEFINE page0Fields      TTmab-motoris.nom-motoris ~
                                TTmab-motoris.cod-estado ~
                                TTmab-motoris.cod-habilit ~
                                TTmab-motoris.cod-pais ~
                                TTmab-motoris.cod-orgao-emissor ~
                                fi-categoria


&GLOBAL-DEFINE page1Fields       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}       AS HANDLE NO-UNDO.
DEFINE VARIABLE iCodEpDest         LIKE empresa.ep-codigo NO-UNDO.
DEFINE VARIABLE iCodEpOrig         LIKE empresa.ep-codigo NO-UNDO.
DEFINE VARIABLE cCodEstabelDest    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCodEstabelOrig    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCodMotDest        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCodMotOrig        AS CHARACTER  NO-UNDO.


  /** Zoom **/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE wMaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS TTmab-motoris.ep-codigo ~
TTmab-motoris.cod-estabel TTmab-motoris.cod-matr TTmab-motoris.nom-motoris ~
TTmab-motoris.cod-habilit TTmab-motoris.cod-orgao-emissor ~
TTmab-motoris.cod-estado TTmab-motoris.cod-pais 
&Scoped-define ENABLED-TABLES TTmab-motoris
&Scoped-define FIRST-ENABLED-TABLE TTmab-motoris
&Scoped-Define ENABLED-OBJECTS RECT-1 rtKeys rtToolBar fiDesEmpresa ~
fiDesEstab fi-categoria btOK btSave btCancel btHelp fiTexto1 
&Scoped-Define DISPLAYED-FIELDS TTmab-motoris.ep-codigo ~
TTmab-motoris.cod-estabel TTmab-motoris.cod-matr TTmab-motoris.nom-motoris ~
TTmab-motoris.cod-habilit TTmab-motoris.cod-orgao-emissor ~
TTmab-motoris.cod-estado TTmab-motoris.cod-pais 
&Scoped-define DISPLAYED-TABLES TTmab-motoris
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-motoris
&Scoped-Define DISPLAYED-OBJECTS fiDesEmpresa fiDesEstab fi-categoria ~
fiTexto1 

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

DEFINE VARIABLE fi-categoria AS CHARACTER FORMAT "X(4)":U 
     LABEL "Categoria" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fiDesEmpresa AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .88 NO-UNDO.

DEFINE VARIABLE fiDesEstab AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .88 NO-UNDO.

DEFINE VARIABLE fiTexto1 AS CHARACTER FORMAT "X(256)":U INITIAL "Documenta‡Æo" 
      VIEW-AS TEXT 
     SIZE 12.14 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 3.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 3.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 89 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     TTmab-motoris.ep-codigo AT ROW 1.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     fiDesEmpresa AT ROW 1.25 COL 29 COLON-ALIGNED NO-LABEL
     TTmab-motoris.cod-estabel AT ROW 2.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     fiDesEstab AT ROW 2.25 COL 29 COLON-ALIGNED NO-LABEL
     TTmab-motoris.cod-matr AT ROW 3.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     TTmab-motoris.nom-motoris AT ROW 3.25 COL 32.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 30 BY .88
     TTmab-motoris.cod-habilit AT ROW 4.83 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     TTmab-motoris.cod-orgao-emissor AT ROW 4.83 COL 52 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fi-categoria AT ROW 4.83 COL 73.43 COLON-ALIGNED
     TTmab-motoris.cod-estado AT ROW 6.08 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-motoris.cod-pais AT ROW 6.08 COL 29.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     btOK AT ROW 7.92 COL 2
     btSave AT ROW 7.92 COL 13
     btCancel AT ROW 7.92 COL 24
     btHelp AT ROW 7.92 COL 79.57
     fiTexto1 AT ROW 4.25 COL 2.86 NO-LABEL
     RECT-1 AT ROW 4.5 COL 1
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 7.63 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 8.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: wMaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: TTmab-motoris T "?" NO-UNDO mgfro mab-motoris
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
         TITLE              = "Manuten‡Æo dos Motoristas"
         HEIGHT             = 8.04
         WIDTH              = 89.43
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
/* SETTINGS FOR FILL-IN fiTexto1 IN FRAME fpage0
   ALIGN-L                                                              */
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
ON END-ERROR OF wMaintenanceNoNavigation /* Manuten‡Æo dos Motoristas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation /* Manuten‡Æo dos Motoristas */
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
  
       if pcAction = "COPY":U then do:
           assign iCodEpDest = INPUT FRAME fPage0 {&ttTable}.ep-codigo
                  cCodEstabelDest = INPUT FRAME fPage0 {&ttTable}.cod-estabel
                  cCodMotDest = input frame fPage0 {&ttTable}.cod-matr.
       end.
       RUN saveRecord IN THIS-PROCEDURE.

       IF RETURN-VALUE = "OK":U THEN do:
           /** Faz a c¢pia das tabelas filhas para o plano criado **/
           if pcAction = "COPY":U then do:
               run copiaFilhos in {&hDBOTable} (input iCodEpDest,
                                                INPUT cCodEstabelDest,
                                                input cCodMotDest,
                                                INPUT iCodEpOrig,
                                                INPUT cCodEstabelOrig,
                                                INPUT cCodMotOrig).
               /** Mostra Erros **/
               if return-value = "NOK":U then
                   RETURN "NOK":U.
           END.
                   
           /** Fecha Programa **/
           APPLY "CLOSE":U TO THIS-PROCEDURE.
       end.  
   
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


&Scoped-define SELF-NAME TTmab-motoris.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-motoris.cod-estabel wMaintenanceNoNavigation
ON F5 OF TTmab-motoris.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
     assign l-implanta = yes.
    {include~/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                     &campo={&ttTable}.cod-estabel
                     &campozoom=cod-estabel
                     &frame=fPage0
                     &campo2=fiDesEstab
                     &campozoom2=nome
                     &frame2=fPage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-motoris.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF TTmab-motoris.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
   {include~/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=fiDesEstab
                   &where="estabelec.cod-estabel = input frame fPage0 {&ttTable}.cod-estabel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-motoris.cod-estabel wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-motoris.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-motoris.cod-estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-motoris.cod-estado wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-motoris.cod-estado IN FRAME fpage0 /* UF */
OR F5 OF {&ttTable}.cod-estado IN FRAME fPage0 DO:
   assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="unzoom/z01un007.w"
                     &campo2={&ttTable}.cod-estado
                     &campozoom2=estado
                     &campo={&ttTable}.cod-pais
                     &campozoom=pais}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-motoris.cod-pais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-motoris.cod-pais wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-motoris.cod-pais IN FRAME fpage0 /* Pa¡s */
OR F5 OF {&ttTable}.cod-pais IN FRAME fPage0 DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="unzoom/z01un007.w"
                     &campo2={&ttTable}.cod-estado
                     &campozoom2=estado
                     &campo={&ttTable}.cod-pais
                     &campozoom=pais}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-motoris.ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-motoris.ep-codigo wMaintenanceNoNavigation
ON F5 OF TTmab-motoris.ep-codigo IN FRAME fpage0 /* Empresa */
DO:
     assign l-implanta = yes.
    {include~/zoomvar.i &prog-zoom=adzoom/z01ad101.w
                     &campo={&ttTable}.ep-codigo
                     &campozoom=ep-codigo
                     &frame=fPage0
                     &campo2=fiDesEmpresa
                     &campozoom2=nome
                     &frame2=fPage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-motoris.ep-codigo wMaintenanceNoNavigation
ON LEAVE OF TTmab-motoris.ep-codigo IN FRAME fpage0 /* Empresa */
DO:
     {include~/leave.i &tabela=empresa
                   &atributo-ref=nome
                   &variavel-ref=fiDesEmpresa
                   &where="empresa.ep-codigo = input frame fPage0 {&ttTable}.ep-codigo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-motoris.ep-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-motoris.ep-codigo IN FRAME fpage0 /* Empresa */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}


{&ttTable}.cod-pais:LOAD-MOUSE-POINTER("image~\lupa.cur":U)   in frame fPage0.
{&ttTable}.cod-estado:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in frame fPage0.
{&ttTable}.ep-codigo:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in frame fPage0.
{&ttTable}.cod-estabel:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in frame fPage0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
APPLY "LEAVE":U TO {&ttTable}.ep-codigo IN FRAME fPage0.
APPLY "LEAVE":U TO {&ttTable}.cod-estabel IN FRAME fPage0.

&IF "{&mguni_version}" >= "2.071" &THEN
    IF INPUT FRAME fPage0 {&ttTable}.ep-codigo = "" AND 
&ELSE
    IF INPUT FRAME fPage0 {&ttTable}.ep-codigo = 0 AND 
&ENDIF
    INPUT FRAME fPage0 {&ttTable}.cod-estabel = "":U THEN 
    RUN setAtualizaTabelas IN {&hDBOTable} (INPUT YES).
ELSE
    RUN setAtualizaTabelas IN {&hDBOTable} (INPUT NO).


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
&IF "{&mguni_version}" >= "2.071    " &THEN
    IF INPUT FRAME fPage0 {&ttTable}.ep-codigo = "" THEN
&ELSE
    IF INPUT FRAME fPage0 {&ttTable}.ep-codigo = 0 THEN
&ENDIF
    ENABLE {&ttTable}.ep-codigo WITH FRAME fPage0.
IF INPUT FRAME fPage0 {&ttTable}.cod-estabel = "":U THEN
    ENABLE {&ttTable}.cod-estabel WITH FRAME fPage0.

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
  if pcAction = "COPY":U then do:
     assign iCodEpOrig = INPUT FRAME fPage0 {&ttTable}.ep-codigo
            cCodEstabelOrig = INPUT FRAME fPage0 {&ttTable}.cod-estabel
            cCodMotOrig = input frame fPage0 {&ttTable}.cod-matr.
  end.
{utp/ut-liter.i Documenta‡Æo * }
assign fiTexto1 = trim(return-value).
disp fiTexto1 with frame fPage0.

ASSIGN fi-categoria:SCREEN-VALUE IN FRAME fPage0 = SUBSTRING(TTmab-motoris.cod-livre-1,1,4).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenanceNoNavigation 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     antes de salvar os campos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN OVERLAY(TTmab-motoris.cod-livre-1,1,4) = fi-categoria:SCREEN-VALUE IN FRAME fPage0.

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
         {&hDBOTable}:FILE-NAME <> "frbo/bofr017.p":U THEN DO:
        RUN frbo/bofr017.p PERSISTENT SET  {&hDBOTable}.
END.
RUN openQueryStatic in   {&hDBOTable} (input "Main":U) NO-ERROR.

RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

