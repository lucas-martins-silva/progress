&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-produt-rural NO-UNDO LIKE produt-rural
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
{include/i-prgvrs.i AQ0207A 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AQ0207A MAQ}
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
&GLOBAL-DEFINE Program           AQ0207A
&GLOBAL-DEFINE Version        2.00.00.010

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       0

&GLOBAL-DEFINE FolderLabels      Narrativa

&GLOBAL-DEFINE ttTable           tt-produt-rural
&GLOBAL-DEFINE hDBOTable         hDBOProdut-rural
&GLOBAL-DEFINE DBOTable          produt-rural

&GLOBAL-DEFINE page0KeyFields    tt-produt-rural.cdn-produt-rural
&GLOBAL-DEFINE page0Fields       tt-produt-rural.cdn-grp-produt ~
                                 tt-produt-rural.cod-cart-produt ~
                                 tt-produt-rural.log-optan-incent ~
                                 c-desc-produtor c-desc-grp-produtor ~
                                 tt-produt-rural.cod-obs~
                                 tt-produt-rural.log-livre-1
                        
&GLOBAL-DEFINE page1Fields       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00963  AS HANDLE NO-UNDO.

/*zoom smart*/
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE VARIABLE c-cod-produt-rural AS CHAR                          NO-UNDO.
DEFINE VARIABLE l-log-livre-1      LIKE tt-produt-rural.log-livre-1 NO-UNDO. /*produtor ativado*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-produt-rural.cdn-produt-rural ~
tt-produt-rural.cdn-grp-produt tt-produt-rural.cod-cart-produt ~
tt-produt-rural.log-optan-incent tt-produt-rural.log-livre-1 ~
tt-produt-rural.cod-obs 
&Scoped-define ENABLED-TABLES tt-produt-rural
&Scoped-define FIRST-ENABLED-TABLE tt-produt-rural
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar RECT-1 c-desc-produtor ~
c-desc-grp-produtor btSave btCancel btHelp btOK 
&Scoped-Define DISPLAYED-FIELDS tt-produt-rural.cdn-produt-rural ~
tt-produt-rural.cdn-grp-produt tt-produt-rural.cod-cart-produt ~
tt-produt-rural.log-optan-incent tt-produt-rural.log-livre-1 ~
tt-produt-rural.cod-obs 
&Scoped-define DISPLAYED-TABLES tt-produt-rural
&Scoped-define FIRST-DISPLAYED-TABLE tt-produt-rural
&Scoped-Define DISPLAYED-OBJECTS c-desc-produtor c-desc-grp-produtor 

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
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "&Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-desc-grp-produtor AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-produtor AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 45.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 8.25.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-produt-rural.cdn-produt-rural AT ROW 1.17 COL 13.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     c-desc-produtor AT ROW 1.17 COL 30.57 COLON-ALIGNED NO-LABEL
     tt-produt-rural.cdn-grp-produt AT ROW 2.46 COL 23.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-desc-grp-produtor AT ROW 2.46 COL 31.14 COLON-ALIGNED NO-LABEL
     tt-produt-rural.cod-cart-produt AT ROW 3.46 COL 23.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     tt-produt-rural.log-optan-incent AT ROW 4.42 COL 26 
          LABEL "Optante Programa Incentivo"
          VIEW-AS TOGGLE-BOX
          SIZE 23 BY .83
     tt-produt-rural.log-livre-1 AT ROW 5.42 COL 26 HELP
          "" WIDGET-ID 2
          LABEL "Ativo"
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .83
     tt-produt-rural.cod-obs AT ROW 6.42 COL 25.86 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 42.14 BY 4
     btSave AT ROW 10.92 COL 13
     btCancel AT ROW 10.92 COL 24
     btHelp AT ROW 10.92 COL 80
     btOK AT ROW 10.96 COL 2
     "Observa‡Æo:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 6.42 COL 16.72
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 10.71 COL 1
     RECT-1 AT ROW 2.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 11.42
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-produt-rural T "?" NO-UNDO mgind produt-rural
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
         HEIGHT             = 11.42
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
/* SETTINGS FOR TOGGLE-BOX tt-produt-rural.log-livre-1 IN FRAME fpage0
   EXP-LABEL EXP-HELP                                                   */
/* SETTINGS FOR TOGGLE-BOX tt-produt-rural.log-optan-incent IN FRAME fpage0
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
    
    RUN habDesProdutor IN THIS-PROCEDURE.

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

    RUN habDesProdutor IN THIS-PROCEDURE.
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-produt-rural.cdn-grp-produt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-rural.cdn-grp-produt wMaintenanceNoNavigation
ON F5 OF tt-produt-rural.cdn-grp-produt IN FRAME fpage0 /* Grupo Produtor */
DO:

  ASSIGN c-desc-grp-produtor = "".

  {method/ZoomFields.i
         &ProgramZoom="inzoom/z01in00963.w"
         &FieldZoom1="cdn-grp-produt"
         &FieldScreen1="tt-produt-rural.cdn-grp-produt"
         &Frame1="fPage0"
         &FieldZoom1="des-grp-produt"
         &FieldScreen1="c-desc-grp-produtor"
         &Frame1="fPage0"
         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-rural.cdn-grp-produt wMaintenanceNoNavigation
ON LEAVE OF tt-produt-rural.cdn-grp-produt IN FRAME fpage0 /* Grupo Produtor */
DO:
  {method/referenceFields.i
              &HandleDBOLeave="h-boin00963"
              &KeyValue1="tt-produt-rural.cdn-grp-produt:screen-value in frame fPage0"
              &FieldName1="des-grp-produt"
              &FieldScreen1="c-desc-grp-produtor"
              &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-rural.cdn-grp-produt wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-produt-rural.cdn-grp-produt IN FRAME fpage0 /* Grupo Produtor */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-produt-rural.cdn-produt-rural
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-rural.cdn-produt-rural wMaintenanceNoNavigation
ON F5 OF tt-produt-rural.cdn-produt-rural IN FRAME fpage0 /* Produtor Rural */
DO:
  /*--- Zoom Smart Object ---*/
    assign l-implanta = YES.  
    {include/zoomvar.i &prog-zoom="adzoom/z01ad098.w"
                       &campo=tt-produt-rural.cdn-produt-rural
                       &campozoom=cod-emitente
                       &campo2=c-desc-produtor
                       &campozoom2=nome-emit}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-rural.cdn-produt-rural wMaintenanceNoNavigation
ON LEAVE OF tt-produt-rural.cdn-produt-rural IN FRAME fpage0 /* Produtor Rural */
DO:
    def var c-nome-emit like emitente.nome-emit no-undo.
    DEF VAR c-return     AS CHAR   NO-UNDO.
    def var h-boad098    AS HANDLE NO-UNDO.
    
    assign input frame {&frame-name} tt-produt-rural.cdn-produt-rural.
    run adbo/boad098.p persistent set h-boad098.        
    run findCodigo in h-boad098(input tt-produt-rural.cdn-produt-rural, output c-return).
    if c-return = "" then do:
        run getCharfield in h-boad098(input "nome-emit", output c-nome-emit).
        assign c-desc-produtor:screen-value = c-nome-emit.
    end.
    delete procedure h-boad098.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-rural.cdn-produt-rural wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-produt-rural.cdn-produt-rural IN FRAME fpage0 /* Produtor Rural */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-produt-rural.cdn-produt-rural:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage0.
tt-produt-rural.cdn-grp-produt:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestoyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestoyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-boin00963) THEN DO:
       DELETE PROCEDURE h-boin00963.
       ASSIGN h-boin00963 = ?.
    END.
    
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

    IF pcAction <> "ADD" THEN DO:
        APPLY "LEAVE" TO tt-produt-rural.cdn-produt-rural IN FRAME fPage0.
        APPLY "LEAVE" TO tt-produt-rural.cdn-grp-produt   IN FRAME fpage0.
        ASSIGN l-log-livre-1 = tt-produt-rural.log-livre-1. /*confere desativação para disparar processo caso mude o flag*/
    END.
    ELSE
        ASSIGN tt-produt-rural.log-livre-1:CHECKED IN FRAME fPage0 = YES.

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

    IF pcAction <> "ADD" THEN
        assign tt-produt-rural.cdn-produt-rural:sensitive in frame fPage0 = NO.

    ASSIGN c-desc-produtor:sensitive in frame fPage0 = NO
           c-desc-grp-produtor:sensitive in frame fPage0 = NO.

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
    IF  pcAction = "ADD":U THEN DO:
        /*for‡a o foco no campo cod-produt-rural, qdo acao = add*/
        APPLY "entry":U TO tt-produt-rural.cdn-produt-rural IN FRAME fPage0. 
    END.
    ELSE
        APPLY "entry":U TO tt-produt-rural.cdn-grp-produt IN FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
      
    IF NOT VALID-HANDLE(h-boin00963) OR
       h-boin00963:TYPE <> "PROCEDURE":U OR
       h-boin00963:FILE-NAME <> "inbo/boin00963.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00963.p YES}
        {btb/btb008za.i2 inbo/boin00963.p '' h-boin00963}
    END.
    
    RUN openQueryStatic IN h-boin00963 (INPUT "Main":U) NO-ERROR.
    
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
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habDesProdutor wMaintenanceNoNavigation
PROCEDURE habDesProdutor :
/*:T------------------------------------------------------------------------------
  ------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-aqapi005 AS HANDLE  NO-UNDO.
    DEFINE VARIABLE rRowid     AS ROWID   NO-UNDO.
    DEFINE VARIABLE iSituacao  AS INTEGER NO-UNDO.

    RUN aqp/aqapi005.p PERSISTENT SET h-aqapi005.

    ASSIGN tt-produt-rural.log-livre-1 = tt-produt-rural.log-livre-1:CHECKED IN FRAME fPage0.

    IF l-log-livre-1 <> tt-produt-rural.log-livre-1 THEN DO:

        IF VALID-HANDLE ({&hDBOTable}) THEN DO:
            RUN goToKey IN {&hDBOTable} (INPUT tt-produt-rural.cdn-produt-rural).

            RUN getRowid IN {&hDBOTable} (OUTPUT rRowid).

            IF tt-produt-rural.log-livre-1 = FALSE THEN DO:

                RUN piInicial IN h-aqapi005 (INPUT  "desativar":U,
                                             INPUT  "produtor":U,
                                             INPUT  rRowid,
                                             OUTPUT iSituacao,
                                             INPUT-OUTPUT TABLE rowErrors).

                IF RETURN-VALUE = "NOK":U THEN /*ocorreu algum erro e não desativou os cadastros*/

                    RUN piInicial IN h-aqapi005 (INPUT  "ativar":U,
                                                 INPUT  "produtor":U,
                                                 INPUT  rRowid,
                                                 OUTPUT iSituacao,
                                                 INPUT-OUTPUT TABLE rowErrors).

            END.
        END.

    END.

    IF  h-aqapi005 <> ? THEN DO:
        DELETE PROCEDURE h-aqapi005.
        ASSIGN h-aqapi005 = ?.    
    END.
  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
