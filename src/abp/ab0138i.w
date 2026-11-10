&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttEqpto NO-UNDO LIKE mab-eqpto
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttMab-eqpto-caract NO-UNDO LIKE mab-eqpto-caract
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
{include/i-prgvrs.i AB0138I 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0138i MAB}
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
&GLOBAL-DEFINE Program           AB0138I
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE Folder            no
&GLOBAL-DEFINE InitialPage       

&GLOBAL-DEFINE FolderLabels      Pag. 1

&GLOBAL-DEFINE ttTable           ttMab-eqpto-caract
&GLOBAL-DEFINE hDBOTable         hDBOMab-eqpto-caract
&GLOBAL-DEFINE DBOTable          Mab-eqpto-caract

&GLOBAL-DEFINE ttParent          ttEqpto
&GLOBAL-DEFINE DBOParentTable    hDBOEqpto

&GLOBAL-DEFINE page0KeyFields    ttMab-eqpto-caract.cod-caract
&GLOBAL-DEFINE page0Fields       ttMab-eqpto-caract.des-arquivo ttMab-eqpto-caract.des-caract
&GLOBAL-DEFINE page0ParentFields ttEqpto.ep-codigo ttEqpto.cod-eqpto

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cFConta AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFSub   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-ok AS LOGICAL    NO-UNDO.
/** Zoom **/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE    NO-UNDO.
DEFINE VARIABLE cCatalogo   AS CHARACTER  NO-UNDO.
/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOMab-caract AS HANDLE NO-UNDO.

DEFINE VARIABLE hDBOModelo AS HANDLE NO-UNDO.

/** Vari veis Compartilhadas entre programas pais e filhos **/
define new global shared variable lAtividade as logical no-undo.

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
ttMab-eqpto-caract.cod-caract ttMab-eqpto-caract.des-caract ~
ttMab-eqpto-caract.des-arquivo 
&Scoped-define ENABLED-TABLES ttEqpto ttMab-eqpto-caract
&Scoped-define FIRST-ENABLED-TABLE ttEqpto
&Scoped-define SECOND-ENABLED-TABLE ttMab-eqpto-caract
&Scoped-define DISPLAYED-TABLES ttEqpto ttMab-eqpto-caract
&Scoped-define FIRST-DISPLAYED-TABLE ttEqpto
&Scoped-define SECOND-DISPLAYED-TABLE ttMab-eqpto-caract
&Scoped-Define ENABLED-OBJECTS fiDesCaract fiDescModelo btOK btSave ~
btCancel btHelp rtKeys rtKeys-2 rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttEqpto.ep-codigo ttEqpto.cod-eqpto ~
ttMab-eqpto-caract.cod-caract ttMab-eqpto-caract.des-caract ~
ttMab-eqpto-caract.des-arquivo 
&Scoped-Define DISPLAYED-OBJECTS fiDesCaract fiDescModelo 

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

DEFINE VARIABLE fiDesCaract AS CHARACTER FORMAT "x(30)":U 
     VIEW-AS FILL-IN 
     SIZE 38.72 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.5.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.21.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btDetalhe 
     IMAGE-UP FILE "image/im-consulta.bmp":U
     LABEL "Visualizar" 
     SIZE 4 BY 1 TOOLTIP "Visualizar".

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttEqpto.ep-codigo AT ROW 1.25 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttEqpto.cod-eqpto AT ROW 2.25 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     ttMab-eqpto-caract.cod-caract AT ROW 3.25 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttMab-eqpto-caract.des-caract AT ROW 4.75 COL 18 COLON-ALIGNED
          LABEL "Conte£do":R11
          VIEW-AS FILL-IN 
          SIZE 29 BY .88
     ttMab-eqpto-caract.des-arquivo AT ROW 5.75 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 51 BY .88
     fiDesCaract AT ROW 3.25 COL 30.43 COLON-ALIGNED NO-LABEL
     fiDescModelo AT ROW 2.25 COL 33.14 COLON-ALIGNED HELP
          "Descri‡Æo Modelo Equipamento" NO-LABEL
    btDetalhe AT row 5.75 COL 71  HELP
         "Visualizar"
     btOK AT ROW 8 COL 2
     btSave AT ROW 8 COL 13
     btCancel AT ROW 8 COL 24
     btHelp AT ROW 8 COL 80
     rtKeys AT ROW 1 COL 1
     rtKeys-2 AT ROW 4.5 COL 1
     rtToolBar AT ROW 7.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 8.42
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttEqpto T "?" NO-UNDO mgfro mab-eqpto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttMab-eqpto-caract T "?" NO-UNDO mgfro mab-eqpto-caract
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
         TITLE              = "Caracter¡sticas dos Equipamentos"
         HEIGHT             = 8.42
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN ttMab-eqpto-caract.des-caract IN FRAME fpage0
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation /* Caracter¡sticas dos Equipamentos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON RETURN OF wMaintenanceNoNavigation /* Caracter¡sticas dos Equipamentos */
DO:
  apply "CHOOSE":U to btOK in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation /* Caracter¡sticas dos Equipamentos */
DO:
  if lAtividade then return no-apply.
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fpage0
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fpage0 wMaintenanceNoNavigation
ON RETURN OF FRAME fpage0
DO:
  apply "CHOOSE":U to btOK in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btDetalhe        
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhe wMaintenanceNoNavigation
ON CHOOSE OF btDetalhe IN FRAME fPage0 /* Visualizar */
DO:
    DEFINE VARIABLE cPath     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cArquivo  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE l-ok      AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE iCont     AS INTEGER    NO-UNDO.

    /** Busca o caminho da cat logo dos parƒmetros da empresa da OM **/
    for first catal_docto_anexo fields(cod_path_catal)
        where catal_docto_anexo.cod_catal_docto_anexo = cCatalogo no-lock:
        assign cArquivo = replace(catal_docto_anexo.cod_path_catal, "/":U, "~\":U) + "~\*.*":U.
    end.

    /** Abre a caixa de di logo do Windows **/
    SYSTEM-DIALOG GET-FILE cArquivo
        FILTERS "*.*":U "*.*":U,
                "*.xls; *.doc":U "*.xls *.doc":U,
                "*.bmp; *.jpg; *.gif":U "*.bmp; *.jpg; *.gif":U
        DEFAULT-EXTENSION "bmp":U
        INITIAL-DIR "spool":U 
        USE-FILENAME
        UPDATE l-ok.
    /** Se confirmou a caixa, atualiza arquivo em tela **/
    if  l-ok = yes then do:
        assign cArquivo                   = replace(cArquivo, "~\":U, "/":U)
               iCont                      = num-entries(cArquivo,"/":U)
               {&ttTable}.des-arquivo     = entry(iCont,cArquivo,"/":U).
        display {&ttTable}.des-arquivo with frame fPage0.
        apply "LEAVE":U to {&ttTable}.des-arquivo in frame fPage0.
    end.

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
    IF RETURN-VALUE = "OK":U THEN do:
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


&Scoped-define SELF-NAME ttMab-eqpto-caract.cod-caract
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttMab-eqpto-caract.cod-caract wMaintenanceNoNavigation
ON f5 OF ttMab-eqpto-caract.cod-caract IN FRAME fpage0 /* Caracter¡stica */
DO:
    {method/zoomfields.i 
       &ProgramZoom="frzoom~\z01fr098.w"
       &FieldZoom1="cod-caract"
       &FieldScreen1="ttMab-eqpto-caract.cod-caract"
       &Frame1="fPage0"
       &FieldZoom2="des-caract"
       &FieldScreen2="fiDesCaract"
       &Frame2="fPage0"
       &EnableImplant="YES"}  
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttMab-eqpto-caract.cod-caract wMaintenanceNoNavigation
ON LEAVE OF ttMab-eqpto-caract.cod-caract IN FRAME fpage0 /* Caracter¡stica */
DO:
    {method\referenceFields.i
          &HandleDBOLeave="hDBOMab-caract"
          &KeyValue1="ttMab-eqpto-caract.cod-caract:screen-value in frame fPage0"
          &FieldName1="des-caract"
          &FieldScreen1="fiDesCaract"
          &Frame1="fPage0"}
          
    if input frame fpage0 ttMab-eqpto-caract.cod-caract <> "" then do:
         run buscaCatalogo in {&hDBOTable} (input input frame fPage0 ttMab-eqpto-caract.cod-caract,
                                            output l-ok).
         if l-ok  then do:
              assign ttMab-eqpto-caract.des-arquivo:sensitive in frame fPage0 = yes.
                     btDetalhe:sensitive in frame fPage0                      = yes.

              RUN getCharField IN hDBOMab-caract (INPUT  "cod-catal-docto-anexo",
                                                 OUTPUT cCatalogo).
                

          end.
          else do:
              assign ttMab-eqpto-caract.des-arquivo:sensitive in frame fPage0 = no
                     btDetalhe:sensitive in frame fPage0                      = no.
          end.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttMab-eqpto-caract.cod-caract wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttMab-eqpto-caract.cod-caract IN FRAME fpage0 /* Caracter¡stica */
DO:
  apply "F5":U to self.
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

{&ttTable}.cod-caract:LOAD-MOUSE-POINTER("image~\lupa.cur":U)     in frame fPage0.

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
/** DBO Caracter¡stica do Equipamento **/
if valid-handle (hDBOMab-caract) then
    run destroy in hDBOMab-caract.



if valid-handle (hDBOModelo) then
    run destroy in hDBOModelo.

              
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     afterDisplayFields
  Parameters:  <none>
  Notes:       Override (ap¢s) display campos em tela
------------------------------------------------------------------------------*/
/** Descri‡äes de campos **/
assign ttMab-eqpto-caract.des-arquivo:sensitive in frame fPage0 = no
       btDetalhe:sensitive in frame fPage0                      = no.

apply "LEAVE":U to {&ttParent}.cod-eqpto    in frame fPage0.
apply "LEAVE":U to ttMab-eqpto-caract.cod-caract in frame fpage0.

return "OK":U.

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

return "ok":u.
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

    /*--- DBO Caracter¡stica do Eqauipamento ---*/
    IF NOT VALID-HANDLE(hDBOMab-caract) OR
       hDBOMab-caract:TYPE <> "PROCEDURE":U OR
       hDBOMab-caract:FILE-NAME <> "frbo~\bofr098.p":U THEN DO:
        run frbo/bofr098.p persistent set  hDBOMab-caract.
    END.
    
    RUN openQueryStatic IN hDBOMab-caract (INPUT "Main":U) NO-ERROR.

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
       {&ttTable}.cod-eqpto = {&ttParent}.cod-eqpto.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

