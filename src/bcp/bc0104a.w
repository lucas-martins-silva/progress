&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mgcld            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttBcEmitenteEtiqueta NO-UNDO LIKE bc-emitente-etiqueta
       FIELD RowNum  AS INTEGER
       FIELD r-Rowid AS ROWID.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0104A 2.00.00.004} /*** "010004" 09/10/2025 11:26:27 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc0104a MBC}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           BC0104A
&GLOBAL-DEFINE Version           2.00.00.004

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           ttBcEmitenteEtiqueta
&GLOBAL-DEFINE hDBOTable         hDBOBcEmitenteEtiqueta
&GLOBAL-DEFINE DBOTable          Bc-Emitente-Etiqueta

&GLOBAL-DEFINE page0KeyFields    ttBcEmitenteEtiqueta.processo ~
                                 ttBcEmitenteEtiqueta.Nome-Abrev
&GLOBAL-DEFINE page0Fields       ttBcEmitenteEtiqueta.Tipo-Etiq ~
                                 ttBcEmitenteEtiqueta.Ind-Geracao

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa    AS HANDLE NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOTipoEtiq  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEmitente  AS HANDLE NO-UNDO.

{bcp/bcproxy.i2}    /* Defini‡äes das procedures para integra‡Æo com o Magnus i.00 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttBcEmitenteEtiqueta.processo ~
ttBcEmitenteEtiqueta.nome-abrev ttBcEmitenteEtiqueta.ind-geracao ~
ttBcEmitenteEtiqueta.tipo-etiq 
&Scoped-define ENABLED-TABLES ttBcEmitenteEtiqueta
&Scoped-define FIRST-ENABLED-TABLE ttBcEmitenteEtiqueta
&Scoped-define DISPLAYED-TABLES ttBcEmitenteEtiqueta
&Scoped-define FIRST-DISPLAYED-TABLE ttBcEmitenteEtiqueta
&Scoped-Define ENABLED-OBJECTS cNomeEmit cTitulo btOK btSave btCancel ~
btHelp text-1 text-2 RECT-1 RECT-2 RECT-3 rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttBcEmitenteEtiqueta.processo ~
ttBcEmitenteEtiqueta.nome-abrev ttBcEmitenteEtiqueta.ind-geracao ~
ttBcEmitenteEtiqueta.tipo-etiq 
&Scoped-Define DISPLAYED-OBJECTS cNomeEmit cTitulo text-1 text-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE cNomeEmit LIKE emitente.nome-emit
     VIEW-AS FILL-IN 
     SIZE 42.14 BY .88 NO-UNDO.

DEFINE VARIABLE cTitulo LIKE tipo-etiqueta.titulo
     VIEW-AS FILL-IN 
     SIZE 49.43 BY .88 NO-UNDO.

DEFINE VARIABLE text-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

DEFINE VARIABLE text-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.08.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45 BY 1.25.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45 BY 1.25.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.08.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttBcEmitenteEtiqueta.processo AT ROW 1.83 COL 28 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Entrada", 1,
"Sa¡da", 2
          SIZE 36 BY .75
     ttBcEmitenteEtiqueta.nome-abrev AT ROW 3 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     cNomeEmit AT ROW 3 COL 33.72 COLON-ALIGNED NO-LABEL
     ttBcEmitenteEtiqueta.ind-geracao AT ROW 5 COL 24 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Nota Fiscal", 1,
"Embalagem", 2,
"Ambos", 3
          SIZE 38 BY .88
     ttBcEmitenteEtiqueta.tipo-etiq AT ROW 6.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     cTitulo AT ROW 6.25 COL 26.29 COLON-ALIGNED NO-LABEL
     btOK AT ROW 7.75 COL 2
     btSave AT ROW 7.75 COL 13
     btCancel AT ROW 7.75 COL 24
     btHelp AT ROW 7.75 COL 80
     text-1 AT ROW 1.25 COL 23 COLON-ALIGNED NO-LABEL
     text-2 AT ROW 4.5 COL 23 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 4.25 COL 1
     RECT-2 AT ROW 1.5 COL 23
     RECT-3 AT ROW 4.75 COL 23
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 7.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 8.21
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttBcEmitenteEtiqueta T "?" NO-UNDO mgcld bc-emitente-etiqueta
      ADDITIONAL-FIELDS:
          FIELD RowNum  AS INTEGER
          FIELD r-Rowid AS ROWID
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
         HEIGHT             = 8.25
         WIDTH              = 90
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.29
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
/* SETTINGS FOR FILL-IN cNomeEmit IN FRAME fpage0
   LIKE = mgadm.emitente.nome-emit EXP-SIZE                             */
/* SETTINGS FOR FILL-IN cTitulo IN FRAME fpage0
   LIKE = mgcld.tipo-etiqueta.titulo EXP-SIZE                           */
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
ON END-ERROR OF wMaintenanceNoNavigation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  /* IF THIS-PROCEDURE:PERSISTENT THEN */ RETURN NO-APPLY.
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


&Scoped-define SELF-NAME ttBcEmitenteEtiqueta.ind-geracao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttBcEmitenteEtiqueta.ind-geracao wMaintenanceNoNavigation
ON VALUE-CHANGED OF ttBcEmitenteEtiqueta.ind-geracao IN FRAME fpage0
DO:
    ASSIGN ERROR-STATUS:ERROR = NO.
    ASSIGN INPUT FRAME fpage0 {&tttable}.ind-geracao NO-ERROR.
    IF ERROR-STATUS:ERROR = NO THEN DO:
       IF {&tttable}.ind-geracao <> 2 THEN DO:
           ENABLE {&ttTable}.Tipo-Etiq WITH FRAME fpage0.
       END.
       ELSE DO:
           ASSIGN {&ttTable}.Tipo-Etiq = 0.
           DISPLAY {&ttTable}.Tipo-Etiq WITH FRAME fpage0.
           DISABLE {&ttTable}.Tipo-Etiq WITH FRAME fpage0.
       END.
       APPLY "LEAVE":U TO {&ttTable}.Tipo-Etiq IN FRAME fpage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttBcEmitenteEtiqueta.nome-abrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttBcEmitenteEtiqueta.nome-abrev wMaintenanceNoNavigation
ON LEAVE OF ttBcEmitenteEtiqueta.nome-abrev IN FRAME fpage0 /* Nome Abrev */
DO:
    run pi-verifica-emitente ( input ttBcEmitenteEtiqueta.Nome-Abrev:screen-value in frame {&FRAME-NAME},
                               input ttBcEmitenteEtiqueta.Nome-Abrev:screen-value in frame {&FRAME-NAME},
                               input 0,    /* Codigo do Emitente               */
                               input 0,    /* Codigo do Emitente               */
                               input 5,    /* Tipo de Acesso 0=Currente ....   */
                               input 2).   /* Record-Frase = 2 (nome abreviado)*/

    
    assign  cNomeEmit:screen-value in frame {&frame-name} = if  not avail ttReturnMessages THEN 
                                                                string(ttEmitente.Nome-Emit)
                                                            else "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttBcEmitenteEtiqueta.nome-abrev wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttBcEmitenteEtiqueta.nome-abrev IN FRAME fpage0 /* Nome Abrev */
OR F5 OF ttBcEmitenteEtiqueta.Nome-Abrev DO:
    {include/zoomvar.i &prog-zoom=bcp/bc8203.w
                       &campo=ttBcEmitenteEtiqueta.nome-abrev
                       &campozoom=nome-abrev
                       &FRAME=fpage0
                       &campo2=cNomeEmit
                       &campozoom2=Nome-Emit
                       &FRAME2=fpage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttBcEmitenteEtiqueta.processo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttBcEmitenteEtiqueta.processo wMaintenanceNoNavigation
ON VALUE-CHANGED OF ttBcEmitenteEtiqueta.processo IN FRAME fpage0
DO:
  ASSIGN ERROR-STATUS:ERROR = NO.
  ASSIGN INPUT FRAME fpage0 {&ttTable}.Processo NO-ERROR.
  IF ERROR-STATUS:ERROR = NO THEN DO:
     IF {&ttTable}.Processo = 1 THEN DO:
         ASSIGN  {&tttable}.ind-geracao = 1.
         DISPLAY {&tttable}.ind-geracao WITH FRAME fpage0.
         DISABLE {&tttable}.ind-geracao WITH FRAME fpage0.
     END.
     ELSE DO:
         ENABLE {&tttable}.ind-geracao WITH FRAME fpage0.
     END.
     APPLY "VALUE-CHANGED":U TO {&tttable}.ind-geracao IN FRAME fpage0.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttBcEmitenteEtiqueta.tipo-etiq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttBcEmitenteEtiqueta.tipo-etiq wMaintenanceNoNavigation
ON LEAVE OF ttBcEmitenteEtiqueta.tipo-etiq IN FRAME fpage0 /* Tipo Etiqueta */
DO:
     ASSIGN cTitulo:SCREEN-VALUE IN FRAME fpage0 = "".
     {method/referencefields.i &HandleDBOLeave="hDBOTipoEtiq"                                           
                               &KeyValue1="int(ttBcEmitenteEtiqueta.Tipo-Etiq:SCREEN-VALUE IN FRAME fPage0)" 
                               &FieldName1="Titulo"                                                     
                               &FieldScreen1="cTitulo"                                                  
                               &Frame1="fPage0"}                                                        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttBcEmitenteEtiqueta.tipo-etiq wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttBcEmitenteEtiqueta.tipo-etiq IN FRAME fpage0 /* Tipo Etiqueta */
OR F5 OF ttBcEmitenteEtiqueta.tipo-etiq DO:
    {method/zoomfields.i &ProgramZoom="clzoom/z02cl015.w"
                         &FieldZoom1="Tipo-Etiq"
                         &FieldScreen1="ttBcEmitenteEtiqueta.Tipo-Etiq"
                         &Frame1="fPage0"
                         &FieldZoom2="Titulo"
                         &FieldScreen2="cTitulo"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

ttBcEmitenteEtiqueta.Nome-Abrev:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
ttBcEmitenteEtiqueta.Tipo-Etiq:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

{btb/btb008za.i1 clbo/bocl015.p YES}
{btb/btb008za.i2 clbo/bocl015.p '' hDBOTipoEtiq}
RUN openQueryStatic IN hDBOTipoEtiq(INPUT "MAIN":U) NO-ERROR.

{utp/ut-rtlbl.i Mgcld Bc-Emitente-Etiqueta Processo text-1}
{utp/ut-rtlbl.i Mgcld Bc-Emitente-Etiqueta Ind-Geracao text-2}

{utp/ut-liter.i Etiqueta_Para MBC 1}
ASSIGN text-2:SCREEN-VALUE IN FRAME fpage0 = " " + RETURN-VALUE
       text-2 = " " + RETURN-VALUE
       text-2:WIDTH IN FRAME fpage0 = LENGTH(RETURN-VALUE) + 3.

{utp/ut-liter.i Etiqueta MBC 1}
ASSIGN ttBcEmitenteEtiqueta.Tipo-Etiq:LABEL IN FRAME fpage0 = RETURN-VALUE.

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
    
    &IF DEFINED(DBOVersion) <> 0 &THEN
        IF VALID-HANDLE (hDBOEmitente) THEN DELETE PROCEDURE hDBOEmitente.
    &ELSE
        IF VALID-HANDLE(hDBOEmitente) THEN RUN destroy IN hDBOEmitente.
    &ENDIF
    
    IF VALID-HANDLE(hDBOTipoEtiq) THEN RUN destroy IN hDBOTipoEtiq.
    
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
    APPLY "LEAVE":U         TO {&ttTable}.Nome-Abrev  IN FRAME fPage0.
    APPLY "VALUE-CHANGED":U TO {&ttTable}.Processo    IN FRAME fPage0.
    APPLY "VALUE-CHANGED":U TO {&tttable}.ind-geracao IN FRAME fPage0.
    APPLY "LEAVE":U         TO {&ttTable}.Tipo-Etiq   IN FRAME fPage0.
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
     IF {&ttTable}.Processo = 1 THEN DO:
         ASSIGN  {&tttable}.ind-geracao = 1.
         DISPLAY {&tttable}.ind-geracao WITH FRAME fpage0.
         DISABLE {&tttable}.ind-geracao WITH FRAME fpage0.
     END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

