&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mgcld            PROGRESS
          mgdis            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttBcEmitenteEtiqueta NO-UNDO LIKE bc-emitente-etiqueta
       FIELD RowNum  AS INTEGER
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE ttBcExtEmbalagem NO-UNDO LIKE bc-ext-embalagem
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
{include/i-prgvrs.i BC0104B 2.00.00.004} /*** "010004" 09/10/2025 11:26:29 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc0104b MBC}
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
&GLOBAL-DEFINE Program           BC0104B
&GLOBAL-DEFINE Version           2.00.00.004

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           ttBcExtEmbalagem
&GLOBAL-DEFINE hDBOTable         hDBOBcExtEmbalagem
&GLOBAL-DEFINE DBOTable          Bc-Ext-Embalagem

&GLOBAL-DEFINE ttParent          ttBcEmitenteEtiqueta
&GLOBAL-DEFINE DBOParentTable    hDBOBcEmitenteEtiqueta

&GLOBAL-DEFINE page0KeyFields    ttBcExtEmbalagem.Sigla-Embalagem
&GLOBAL-DEFINE page0Fields       ttBcExtEmbalagem.Tipo-Etiq ~
                                 ttBcExtEmbalagem.Log-Ativo
&GLOBAL-DEFINE page0ParentFields ttBcEmitenteEtiqueta.Processo ~
                                 ttBcEmitenteEtiqueta.Nome-Abrev

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE                   VARIABLE wh-pesquisa    AS HANDLE NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOTipoEtiq  AS HANDLE NO-UNDO.

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
ttBcEmitenteEtiqueta.nome-abrev ttBcExtEmbalagem.sigla-embalagem ~
ttBcExtEmbalagem.tipo-etiq ttBcExtEmbalagem.log-ativo 
&Scoped-define ENABLED-TABLES ttBcEmitenteEtiqueta ttBcExtEmbalagem
&Scoped-define FIRST-ENABLED-TABLE ttBcEmitenteEtiqueta
&Scoped-define SECOND-ENABLED-TABLE ttBcExtEmbalagem
&Scoped-define DISPLAYED-TABLES ttBcEmitenteEtiqueta ttBcExtEmbalagem
&Scoped-define FIRST-DISPLAYED-TABLE ttBcEmitenteEtiqueta
&Scoped-define SECOND-DISPLAYED-TABLE ttBcExtEmbalagem
&Scoped-Define ENABLED-OBJECTS cNomeEmit cDesEmbalagem cTitulo btOK btSave ~
btCancel btHelp text-1 RECT-2 rtKeys rtKeys-2 rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttBcEmitenteEtiqueta.processo ~
ttBcEmitenteEtiqueta.nome-abrev ttBcExtEmbalagem.sigla-embalagem ~
ttBcExtEmbalagem.tipo-etiq ttBcExtEmbalagem.log-ativo 
&Scoped-Define DISPLAYED-OBJECTS cNomeEmit cDesEmbalagem cTitulo text-1 

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

DEFINE VARIABLE cDesEmbalagem LIKE embalag.descricao
     VIEW-AS FILL-IN 
     SIZE 47.72 BY .88 NO-UNDO.

DEFINE VARIABLE cNomeEmit LIKE emitente.nome-emit
     VIEW-AS FILL-IN 
     SIZE 40.14 BY .88 NO-UNDO.

DEFINE VARIABLE cTitulo LIKE tipo-etiqueta.titulo
     VIEW-AS FILL-IN 
     SIZE 49 BY .88 NO-UNDO.

DEFINE VARIABLE text-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45 BY 1.25.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 4.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.21.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttBcEmitenteEtiqueta.processo AT ROW 1.83 COL 27 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Entrada", 1,
"Sa¡da", 2
          SIZE 39 BY .75
     ttBcEmitenteEtiqueta.nome-abrev AT ROW 2.92 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     cNomeEmit AT ROW 2.92 COL 33.72 COLON-ALIGNED NO-LABEL
     ttBcExtEmbalagem.sigla-embalagem AT ROW 3.92 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     cDesEmbalagem AT ROW 3.92 COL 26.29 COLON-ALIGNED NO-LABEL
     ttBcExtEmbalagem.tipo-etiq AT ROW 5.42 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     cTitulo AT ROW 5.42 COL 26.29 COLON-ALIGNED NO-LABEL
     ttBcExtEmbalagem.log-ativo AT ROW 6.42 COL 23
          VIEW-AS TOGGLE-BOX
          SIZE 7 BY .88
     btOK AT ROW 7.75 COL 2
     btSave AT ROW 7.75 COL 13
     btCancel AT ROW 7.75 COL 24
     btHelp AT ROW 7.75 COL 80
     text-1 AT ROW 1.17 COL 23 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 1.5 COL 23
     rtKeys AT ROW 1 COL 1
     rtKeys-2 AT ROW 5.17 COL 1
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
      TABLE: ttBcExtEmbalagem T "?" NO-UNDO mgcld bc-ext-embalagem
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
         HEIGHT             = 8.21
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN cDesEmbalagem IN FRAME fpage0
   LIKE = mgdis.embalag.descricao EXP-SIZE                              */
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
    assign l-implanta  = yes.
    {include/zoom.i &prog-zoom=bcp/bc8203.w
                    &tabela=ttBcEmitenteEtiqueta
                    &atributo=nome-abrev}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttBcExtEmbalagem.sigla-embalagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttBcExtEmbalagem.sigla-embalagem wMaintenanceNoNavigation
ON LEAVE OF ttBcExtEmbalagem.sigla-embalagem IN FRAME fpage0 /* Embalagem */
DO:
    RUN pi-verifica-embalag (INPUT "",   /* Codigo da Embalagem              */
                             INPUT "",   /* Codigo da Embalagem              */
                             INPUT ttBcExtEmbalagem.sigla-embalagem:screen-value in frame {&FRAME-NAME},
                             INPUT ttBcExtEmbalagem.sigla-embalagem:screen-value in frame {&FRAME-NAME},
                             INPUT 5,    /* Tipo de Acesso 0=Currente ....   */
                             INPUT 2).   /* Record-Frase = 2 (nome abreviado)*/

    assign  cDesEmbalagem:screen-value in frame {&frame-name} = if  not avail ttReturnMessages THEN 
                                                                    string(ttEmbalag.Descricao)
                                                                else "":U. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttBcExtEmbalagem.sigla-embalagem wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttBcExtEmbalagem.sigla-embalagem IN FRAME fpage0 /* Embalagem */
OR F5 OF ttBcExtEmbalagem.sigla-embalagem DO:
    assign l-implanta  = yes.
    {include/zoomvar.i &prog-zoom=bcp/bc8217.w
                           &campo=ttBcExtEmbalagem.sigla-embalagem
                           &campozoom=sigla-emb
                           &FRAME=fpage0
                           &campo2=cDesEmbalagem
                           &campozoom2=descricao
                           &FRAME2=fpage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttBcExtEmbalagem.tipo-etiq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttBcExtEmbalagem.tipo-etiq wMaintenanceNoNavigation
ON LEAVE OF ttBcExtEmbalagem.tipo-etiq IN FRAME fpage0 /* Tipo Etiqueta */
DO:
    ASSIGN cTitulo:SCREEN-VALUE IN FRAME fpage0 = "".
    {method/referencefields.i &HandleDBOLeave="hDBOTipoEtiq"                                           
                              &KeyValue1="int(ttBcExtEmbalagem.Tipo-Etiq:SCREEN-VALUE IN FRAME fPage0)" 
                              &FieldName1="Titulo"                                                     
                              &FieldScreen1="cTitulo"                                                  
                              &Frame1="fPage0"}                                                        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttBcExtEmbalagem.tipo-etiq wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttBcExtEmbalagem.tipo-etiq IN FRAME fpage0 /* Tipo Etiqueta */
OR F5 OF ttBcExtEmbalagem.tipo-etiq DO:
    {method/zoomfields.i &ProgramZoom="clzoom/z02cl015.w"
                         &FieldZoom1="Tipo-Etiq"
                         &FieldScreen1="ttBcExtEmbalagem.Tipo-Etiq"
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

ttBcExtEmbalagem.Sigla-Embalagem:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
ttBcExtEmbalagem.Tipo-Etiq:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

{btb/btb008za.i1 clbo/bocl015.p YES}
{btb/btb008za.i2 clbo/bocl015.p '' hDBOTipoEtiq}
RUN openQueryStatic IN hDBOTipoEtiq(INPUT "MAIN":U) NO-ERROR.

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
    IF VALID-HANDLE(hDBOTipoEtiq) THEN RUN destroy IN hDBOTipoEtiq.

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
    {utp/ut-rtlbl.i Mgcld Bc-Emitente-Etiqueta Processo text-1}
    
    {utp/ut-liter.i Etiqueta MBC 1}
    ASSIGN ttBcExtEmbalagem.Tipo-Etiq:LABEL IN FRAME fpage0 = RETURN-VALUE.

    ASSIGN ttBcExtEmbalagem.Sigla-Embalagem:FORMAT IN FRAME fpage0 = "XXX":U.

    APPLY "LEAVE":U TO {&ttParent}.Nome-Abrev      IN FRAME fPage0.
    APPLY "LEAVE":U TO {&ttTable}.Sigla-Embalagem  IN FRAME fpage0.
    APPLY "LEAVE":U TO {&ttTable}.Tipo-Etiq        IN FRAME fPage0.                                                
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

    ASSIGN ttBcExtEmbalagem.Processo   = ttBcEmitenteEtiqueta.Processo
           ttBcExtEmbalagem.Nome-Abrev = ttBcEmitenteEtiqueta.Nome-Abrev.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

