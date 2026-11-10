&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-carg-rural NO-UNDO LIKE carg-rural
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-produt-carg NO-UNDO LIKE produt-carg
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-produt-carg-aux NO-UNDO LIKE produt-carg
       field cod-rota as char
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-produt-carg-coletivo NO-UNDO LIKE produt-carg
       FIELD r-rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0302A 2.00.00.017 } /*** "010017" ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0302A MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AQ0302A
&GLOBAL-DEFINE Version        2.00.00.017

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-produt-carg
&GLOBAL-DEFINE hDBOTable         h-boin00965
&GLOBAL-DEFINE DBOTable          produt-carg

&GLOBAL-DEFINE ttParent          tt-carg-rural
&GLOBAL-DEFINE DBOParentTable    carg-rural

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-carg-rural.num-carg tt-carg-rural.cod-carga tt-carg-rural.cod-placa
&GLOBAL-DEFINE page1Fields       tt-produt-carg.cod-pto-coleta tt-produt-carg.cdn-produt-rural ~
                                 tt-produt-carg.cdn-compart tt-produt-carg.qtd-coleta ~
                                 tt-produt-carg.val-temperat cb-nao-coleta ~
                                 tt-produt-carg.cod-lacre tt-produt-carg.cod-amostra tt-produt-carg.cdn-repos
     

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Shared Variable Definitions ---                                      */
DEFINE SHARED VARIABLE v_cdn-identif AS INTEGER NO-UNDO.
DEFINE SHARED VARIABLE v_l-fraciona   AS LOGICAL           NO-UNDO.
/* Local Variable Definitions ---                                       */
DEFINE VARIABLE l-log-pto-coleta-coletiv AS LOGICAL   NO-UNDO.
DEFINE VARIABLE i-cdn-produt-respons     AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-cod-propried           AS CHARACTER   NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad098     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00961   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00962   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00965-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00966   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00984   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00990   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin01004   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-aqapi005    AS HANDLE NO-UNDO.

DEFINE VARIABLE i-motivo-nao-coleta AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-texto             AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-carg-rural.num-carg ~
tt-carg-rural.cod-carga tt-carg-rural.cod-placa 
&Scoped-define ENABLED-TABLES tt-carg-rural
&Scoped-define FIRST-ENABLED-TABLE tt-carg-rural
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-carg-rural.num-carg ~
tt-carg-rural.cod-carga tt-carg-rural.cod-placa 
&Scoped-define DISPLAYED-TABLES tt-carg-rural
&Scoped-define FIRST-DISPLAYED-TABLE tt-carg-rural


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

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON bt-obs 
     IMAGE-UP FILE "image/im-respl.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-respl.bmp":U
     LABEL "&Obs" 
     SIZE 4.86 BY 1.42 TOOLTIP "Observa‡äes".

DEFINE VARIABLE cb-nao-coleta AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "NÆo Coleta" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "         0" 
     DROP-DOWN-LIST
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE c-des-pto-coleta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-repos AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-emit AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-carg-rural.num-carg AT ROW 1.75 COL 10 COLON-ALIGNED
          LABEL "Carga"
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     tt-carg-rural.cod-carga AT ROW 1.75 COL 37 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .79
     tt-carg-rural.cod-placa AT ROW 1.75 COL 69 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     btOK AT ROW 16.63 COL 2
     btSave AT ROW 16.63 COL 13
     btCancel AT ROW 16.63 COL 24
     btHelp AT ROW 16.63 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 16.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.96
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tt-produt-carg.cod-pto-coleta AT ROW 2.25 COL 20 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     tt-produt-carg.cdn-repos AT ROW 3.38 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     tt-produt-carg.cdn-produt-rural AT ROW 4.5 COL 20 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     tt-produt-carg.qtd-coleta AT ROW 5.5 COL 20 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     cb-nao-coleta AT ROW 5.46 COL 48 COLON-ALIGNED WIDGET-ID 32
     tt-produt-carg.cdn-compart AT ROW 6.5 COL 20 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-produt-carg.val-temperat AT ROW 7.5 COL 20 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-des-pto-coleta AT ROW 2.25 COL 32.72 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     c-des-repos AT ROW 3.38 COL 32.72 COLON-ALIGNED NO-LABEL
     c-nome-emit AT ROW 4.5 COL 32.72 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     tt-produt-carg.cod-amostra AT ROW 8.46 COL 20 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .88
     tt-produt-carg.cod-lacre AT ROW 9.46 COL 20 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .88
     bt-obs AT ROW 6.54 COL 70
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.71
         SIZE 84.43 BY 11.04
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-carg-rural T "?" NO-UNDO movind carg-rural
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
      TABLE: tt-produt-carg T "?" NO-UNDO movind produt-carg
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
      TABLE: tt-produt-carg-aux T "?" NO-UNDO movind produt-carg
      ADDITIONAL-FIELDS:
          field cod-rota as char
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-produt-carg-coletivo T "?" NO-UNDO movind produt-carg
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
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
         HEIGHT             = 16.96
         WIDTH              = 90
         MAX-HEIGHT         = 39.46
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 39.46
         VIRTUAL-WIDTH      = 182.86
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-carg-rural.num-carg IN FRAME fpage0
   EXP-LABEL                                                            */
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
  ASSIGN v_cdn-identif = ?.
  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-obs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-obs wMaintenanceNoNavigation
ON CHOOSE OF bt-obs IN FRAME fPage1 /* Obs */
DO:          
    RUN aqp/aq0302b.w (INPUT-OUTPUT c-texto). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    ASSIGN v_cdn-identif = ?.
     
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
    IF {&ttParent}.cdn-sit = 6 THEN /* reaberta */
        RUN pi-chama-aq0302b IN THIS-PROCEDURE.

    RUN atualizaCodPropried.
    RUN pi-verifica-inativos.

    IF CAN-FIND(FIRST RowErrors
                WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:            
        {method/showmessage.i1}
        {method/showmessage.i2}
        RETURN NO-APPLY.
    END. 

    EMPTY TEMP-TABLE rowErrors.
   
    IF l-log-pto-coleta-coletiv THEN
        RUN saveRecordColetivo IN THIS-PROCEDURE.
    ELSE
        RUN saveRecord IN THIS-PROCEDURE.
                                          
    
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    ELSE
        ASSIGN v_cdn-identif = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    IF {&ttParent}.cdn-sit = 6 THEN /* reaberta */
        RUN pi-chama-aq0302b IN THIS-PROCEDURE.

    RUN pi-verifica-inativos.
    IF CAN-FIND(FIRST RowErrors
                WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:            
        {method/showmessage.i1}
        {method/showmessage.i2}
        RETURN NO-APPLY.
    END. 

    EMPTY TEMP-TABLE rowErrors.

    IF l-log-pto-coleta-coletiv THEN DO:
        RUN saveRecordColetivo  IN THIS-PROCEDURE.
        IF RETURN-VALUE = "OK" THEN
            RUN limpaCamposColetivo IN THIS-PROCEDURE.
    END.    
    ELSE
        RUN saveRecord IN THIS-PROCEDURE.

    IF RETURN-VALUE <> "OK":U THEN      
        ASSIGN v_cdn-identif = ?.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME cb-nao-coleta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-nao-coleta wMaintenanceNoNavigation
ON VALUE-CHANGED OF cb-nao-coleta IN FRAME fPage1 /* NÆo Coleta */
DO:
    IF INTEGER(SELF:SCREEN-VALUE  IN FRAME fPage1) = ? THEN
        ASSIGN i-motivo-nao-coleta = 0.
    ELSE 
        ASSIGN i-motivo-nao-coleta = INTEGER(SELF:SCREEN-VALUE  IN FRAME fPage1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-produt-carg.cdn-produt-rural
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-carg.cdn-produt-rural wMaintenanceNoNavigation
ON LEAVE OF tt-produt-carg.cdn-produt-rural IN FRAME fPage1 /* Produtor Rural */
DO:                         
    DEFINE VARIABLE p-nome-abrev AS CHARACTER NO-UNDO.

    RUN goToKey IN h-boin00962(INPUT INPUT FRAME fPage1 tt-produt-carg.cdn-produt-rural).
    IF RETURN-VALUE = 'OK' THEN DO:
        RUN findCodigo IN h-boad098(INPUT tt-produt-carg.cdn-produt-rural:SCREEN-VALUE IN FRAME fPage1, 
                                    OUTPUT p-nome-abrev).
        IF p-nome-abrev = "" THEN DO:        
            RUN goToKey      IN h-boad098(INPUT tt-produt-carg.cdn-produt-rural:SCREEN-VALUE IN FRAME fPage1) NO-ERROR.
            RUN getCharField IN h-boad098(INPUT "nome-emit", OUTPUT p-nome-abrev).
        END.

        ASSIGN c-nome-emit:SCREEN-VALUE IN FRAME fPage1 = p-nome-abrev.    
    END.
    ELSE
         ASSIGN c-nome-emit:SCREEN-VALUE IN FRAME fPage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-carg.cdn-produt-rural wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-produt-carg.cdn-produt-rural IN FRAME fPage1 /* Produtor Rural */
OR F5 OF tt-produt-carg.cdn-produt-rural IN FRAME fPage1
DO:
    {method/zoomfields.i &ProgramZoom="inzoom/z01in00990.w"
                         &FieldZoom1="cdn-produt-rural"
                         &FieldScreen1="tt-produt-carg.cdn-produt-rural"
                         &Frame1="fPage1"                          
                         &EnableImplant="YES"
                         &runMethod = "RUN setParams IN hProgramZoom (INPUT INPUT FRAME fPage1 tt-produt-carg.cod-pto-coleta)."
                         }   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-produt-carg.cdn-repos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-carg.cdn-repos wMaintenanceNoNavigation
ON LEAVE OF tt-produt-carg.cdn-repos IN FRAME fPage1 /* Reposit¢rio */
DO:  
     RUN findDescReposit IN h-boin00984(INPUT INPUT FRAME fPage1 tt-produt-carg.cod-pto-coleta,
                                        INPUT INPUT FRAME fPage1 tt-produt-carg.cdn-repos,
                                        OUTPUT c-des-repos).

     DISP c-des-repos WITH FRAME fPage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-carg.cdn-repos wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-produt-carg.cdn-repos IN FRAME fPage1 /* Reposit¢rio */
OR F5 OF tt-produt-carg.cdn-repos DO:
    {method/ZoomFields.i &ProgramZoom="inzoom/z01in00984.w"
                         &FieldZoom1="cdn-repos"
                         &FieldScreen1="tt-produt-carg.cdn-repos"
                         &Frame1="fPage1"
                         &FieldZoom2="des-reposit"
                         &FieldScreen2="c-des-repos"
                         &Frame2="fPage1"
                         &RunMethod="RUN setaPontoColeta IN hProgramZoom (INPUT INPUT FRAME fPage1 tt-produt-carg.cod-pto-coleta)."
                         &EnableImplant="NO"}

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-produt-carg.cod-pto-coleta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-carg.cod-pto-coleta wMaintenanceNoNavigation
ON LEAVE OF tt-produt-carg.cod-pto-coleta IN FRAME fPage1 /* Ponto Coleta */
DO:
    DEFINE VARIABLE pDesPtoColeta AS CHARACTER NO-UNDO.
     
    RUN goToKey IN h-boin00966 (INPUT tt-produt-carg.cod-pto-coleta:SCREEN-VALUE IN FRAME fPage1) NO-ERROR.

    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getCharField IN h-boin00966 (INPUT "des-pto-coleta":U, 
                                         OUTPUT pDesPtoColeta) NO-ERROR. 

        RUN getLogField  IN h-boin00966 (INPUT "log-pto-coleta-coletiv":U, 
                                         OUTPUT l-log-pto-coleta-coletiv) NO-ERROR.
        
        ASSIGN c-des-pto-coleta:SCREEN-VALUE IN FRAME fPage1 = pDesPtoColeta.

    END.
    ELSE 
        ASSIGN c-des-pto-coleta:SCREEN-VALUE IN FRAME fPage1 = ""
               l-log-pto-coleta-coletiv                      = NO.

    ASSIGN tt-produt-carg.cdn-produt-rural:SENSITIVE IN FRAME fPage1 = NOT l-log-pto-coleta-coletiv.

    RUN findResponsavel IN h-boin00990 (INPUT tt-produt-carg.cod-pto-coleta:SCREEN-VALUE IN FRAME fPage1, 
                                        OUTPUT i-cdn-produt-respons).
    IF RETURN-VALUE = 'OK':U THEN DO:
        ASSIGN tt-produt-carg.cdn-produt-rural:SCREEN-VALUE IN FRAME fPage1 = STRING(i-cdn-produt-respons).
        APPLY 'LEAVE':U TO tt-produt-carg.cdn-produt-rural IN FRAME fPage1.
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-carg.cod-pto-coleta wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-produt-carg.cod-pto-coleta IN FRAME fPage1 /* Ponto Coleta */
OR F5 OF tt-produt-carg.cod-pto-coleta IN FRAME fPage1
DO:
    {method/zoomfields.i &ProgramZoom="inzoom/z01in00966.w"
                         &FieldZoom1="cod-pto-coleta"
                         &FieldScreen1="tt-produt-carg.cod-pto-coleta"
                         &Frame1="fPage1"                          
                         &FieldZoom2="des-pto-coleta"
                         &FieldScreen2="c-des-pto-coleta"
                         &Frame2="fPage1"
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-produt-carg.qtd-coleta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-carg.qtd-coleta wMaintenanceNoNavigation
ON LEAVE OF tt-produt-carg.qtd-coleta IN FRAME fPage1 /* Quantidade Coletada */
DO:
    IF INT(SELF:SCREEN-VALUE) = 0 THEN
        ASSIGN tt-produt-carg.val-temperat:SENSITIVE    IN FRAME fPage1 = NO
               tt-produt-carg.cod-amostra:SENSITIVE     IN FRAME fPage1 = NO
               tt-produt-carg.cod-lacre:SENSITIVE       IN FRAME fPage1 = NO
               tt-produt-carg.cdn-compart:SENSITIVE     IN FRAME fPage1 = NO
               tt-produt-carg.val-temperat:SCREEN-VALUE IN FRAME fPage1 = "0"
               tt-produt-carg.cdn-compart:SCREEN-VALUE  IN FRAME fPage1 = "0"
               tt-produt-carg.cod-amostra:SCREEN-VALUE  IN FRAME fPage1 = ""
               tt-produt-carg.cod-lacre:SCREEN-VALUE    IN FRAME fPage1 = "".
    ELSE 
        ASSIGN tt-produt-carg.val-temperat:SENSITIVE IN FRAME fPage1 = YES   
               tt-produt-carg.cod-amostra:SENSITIVE  IN FRAME fPage1 = YES 
               tt-produt-carg.cod-lacre:SENSITIVE    IN FRAME fPage1 = YES
               tt-produt-carg.cdn-compart:SENSITIVE  IN FRAME fPage1 = YES.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-produt-carg.cod-pto-coleta:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPage1.
tt-produt-carg.cdn-produt-rural:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-produt-carg.cdn-repos:LOAD-MOUSE-POINTER("image/lupa.cur":U)        IN FRAME fPage1.

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

    IF VALID-HANDLE(h-boin00961) AND
        h-boin00961:TYPE = "PROCEDURE":U AND
        h-boin00961:FILE-NAME = "inbo/boin00961.p":U THEN DO:
        DELETE PROCEDURE h-boin00961.
        ASSIGN h-boin00961 = ?.
    END.

    IF VALID-HANDLE({&hDBOTable}) AND
        {&hDBOTable}:TYPE = "PROCEDURE":U AND
        {&hDBOTable}:FILE-NAME = "inbo/boin00965.p":U THEN DO:
        DELETE PROCEDURE {&hDBOTable}.
        ASSIGN {&hDBOTable} = ?.
    END.

    IF VALID-HANDLE(h-boin00965-2) AND
        h-boin00965-2:TYPE = "PROCEDURE":U AND
        h-boin00965-2:FILE-NAME = "inbo/boin00965.p":U THEN DO:
        DELETE PROCEDURE h-boin00965-2.
        ASSIGN h-boin00965-2 = ?.
    END.

    IF VALID-HANDLE(h-boin00966) AND
        h-boin00966:TYPE = "PROCEDURE":U AND
        h-boin00966:FILE-NAME = "inbo/boin00966.p":U THEN DO:
        DELETE PROCEDURE h-boin00966.
        ASSIGN h-boin00966 = ?.
    END.

    IF VALID-HANDLE(h-boin00962) AND
        h-boin00962:TYPE = "PROCEDURE":U AND
        h-boin00962:FILE-NAME = "inbo/boin00962.p":U THEN DO:
        DELETE PROCEDURE h-boin00962.
        ASSIGN h-boin00962 = ?.
    END.

    IF VALID-HANDLE(h-boad098) AND
        h-boad098:TYPE = "PROCEDURE":U AND
        h-boad098:FILE-NAME = "adbo/boad098.p":U THEN DO:
        DELETE PROCEDURE h-boad098.
        ASSIGN h-boad098 = ?.
    END.

    IF VALID-HANDLE(h-boin00984) AND
        h-boin00984:TYPE = "PROCEDURE":U AND
        h-boin00984:FILE-NAME = "inbo/boin00984.p":U THEN DO:
        DELETE PROCEDURE h-boin00984.
        ASSIGN h-boin00984 = ?.
    END.
    
    IF VALID-HANDLE(h-boin01004) AND
        h-boin01004:TYPE = "PROCEDURE":U AND
        h-boin01004:FILE-NAME = "inbo/boin01004.p":U THEN DO:
        DELETE PROCEDURE h-boin01004.
        ASSIGN h-boin01004 = ?.
    END.    

    IF VALID-HANDLE(h-aqapi005) AND
        h-aqapi005:TYPE = "PROCEDURE":U AND
        h-aqapi005:FILE-NAME = "aqp/aqapi005.p":U THEN DO:
        DELETE PROCEDURE h-aqapi005.
        ASSIGN h-aqapi005 = ?.
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
    DEFINE VARIABLE c-list AS CHARACTER NO-UNDO.

    IF VALID-HANDLE(h-boin01004) THEN DO:
        RUN getList IN h-boin01004(OUTPUT c-list).
        ASSIGN cb-nao-coleta:LIST-ITEM-PAIRS IN FRAME fPage1 = c-list.
    END.
    
    IF NOT v_l-fraciona THEN
        ASSIGN tt-produt-carg.qtd-coleta:FORMAT IN FRAME fPage1 = ">>>,>>>,>>9":U.
        
    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    IF pcAction = "Update":U THEN
        ASSIGN tt-produt-carg.cod-pto-coleta:SENSITIVE   IN FRAME fPage1 = NO
               tt-produt-carg.cdn-produt-rural:SENSITIVE IN FRAME fPage1 = NO
               tt-produt-carg.cdn-repos:SENSITIVE        IN FRAME fPage1 = NO.

    APPLY "LEAVE" TO tt-produt-carg.qtd-coleta IN FRAME fPage1.

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
    ASSIGN bt-obs:SENSITIVE IN FRAME fPage1 = YES.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayFields wMaintenanceNoNavigation 
PROCEDURE beforeDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {utp/ut-liter.i Quantidade * R }
    ASSIGN tt-produt-carg.qtd-coleta:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Lacre * R }
    ASSIGN tt-produt-carg.cod-lacre:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).             
    {utp/ut-liter.i Amostra * R }
    ASSIGN tt-produt-carg.cod-amostra:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).
    
    RETURN "OK":U. 
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
    IF NOT l-log-pto-coleta-coletiv  THEN DO:
        IF INTEGER(cb-nao-coleta:SCREEN-VALUE IN FRAME fPage1) > 0 THEN 
             ASSIGN {&ttTable}.cdn-motiv-nao-coleta = INTEGER(cb-nao-coleta:SCREEN-VALUE IN FRAME fPage1)
                    {&ttTable}.idi-nao-coleta       = 1. /* Pendente */
         ELSE
             ASSIGN {&ttTable}.cdn-motiv-nao-coleta = 0
                    {&ttTable}.idi-nao-coleta       = 0. /* NAO TEM MOTIVO DE NAO COLETA */
   END.
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

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00961) OR
       h-boin00961:TYPE <> "PROCEDURE":U OR
       h-boin00961:FILE-NAME <> "inbo/boin00961.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00961.p YES}
        {btb/btb008za.i2 inbo/boin00961.p '' h-boin00961} 
    END.
    
    RUN openQueryStatic IN h-boin00961 (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR 
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "inbo/boin00965.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00965.p YES}
        {btb/btb008za.i2 inbo/boin00965.p '' {&hDBOTable}} 
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00965-2) OR
       h-boin00965-2:TYPE <> "PROCEDURE":U OR
       h-boin00965-2:FILE-NAME <> "inbo/boin00965.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00965.p YES}
        {btb/btb008za.i2 inbo/boin00965.p '' h-boin00965-2} 
    END.
    
    RUN openQueryStatic IN h-boin00965-2 (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00966) OR 
       h-boin00966:TYPE <> "PROCEDURE":U OR
       h-boin00966:FILE-NAME <> "inbo/boin00966.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00966.p YES}
        {btb/btb008za.i2 inbo/boin00966.p '' h-boin00966} 
    END.
    
    RUN openQueryStatic IN h-boin00966 (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00962) OR 
       h-boin00962:TYPE <> "PROCEDURE":U OR
       h-boin00962:FILE-NAME <> "inbo/boin00962.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00962.p YES}
        {btb/btb008za.i2 inbo/boin00962.p '' h-boin00962} 
    END.
    
    RUN openQueryStatic IN h-boin00962 (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boad098) OR 
       h-boad098:TYPE <> "PROCEDURE":U OR
       h-boad098:FILE-NAME <> "adbo/boad098.p":U THEN DO:

        {btb/btb008za.i1 adbo/boad098.p YES}
        {btb/btb008za.i2 adbo/boad098.p '' h-boad098} 
    END.
    
    RUN openQueryStatic IN h-boad098 (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00990) OR 
       h-boin00990:TYPE <> "PROCEDURE":U OR
       h-boin00990:FILE-NAME <> "inbo/boin00990.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00990.p YES}
        {btb/btb008za.i2 inbo/boin00990.p '' h-boin00990} 
    END.
    
    RUN openQueryStatic IN h-boin00990 (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00984) OR 
       h-boin00984:TYPE <> "PROCEDURE":U OR
       h-boin00984:FILE-NAME <> "inbo/boin00984.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00984.p YES}
        {btb/btb008za.i2 inbo/boin00984.p '' h-boin00984} 
    END.
    
    RUN openQueryStatic IN h-boin00984 (INPUT "Main":U) NO-ERROR.
    
     /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-boin01004) OR 
       h-boin01004:TYPE <> "PROCEDURE":U OR
       h-boin01004:FILE-NAME <> "inbo/boin01004.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin01004.p YES}
        {btb/btb008za.i2 inbo/boin01004.p '' h-boin01004} 
    END.
    
    RUN openQueryStatic IN h-boin01004 (INPUT "Main":U) NO-ERROR.    


     /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-aqapi005) OR 
       h-aqapi005:TYPE <> "PROCEDURE":U OR
       h-aqapi005:FILE-NAME <> "aqp/aqapi005.p":U THEN DO:

        {btb/btb008za.i1 aqp/aqapi005.p YES}
        {btb/btb008za.i2 aqp/aqapi005.p '' h-aqapi005} 
    END.
    
    RUN openQueryStatic IN h-aqapi005 (INPUT "Main":U) NO-ERROR.    


    RETURN "OK":U.     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE limpaCamposColetivo wMaintenanceNoNavigation 
PROCEDURE limpaCamposColetivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN tt-produt-carg.cod-pto-coleta         = ""
           tt-produt-carg.cdn-repos              = 0
           tt-produt-carg.cdn-produt-rural       = 0 
           tt-produt-carg.cdn-compart            = 0
           tt-produt-carg.qtd-coleta             = 0
           tt-produt-carg.val-temperat           = 0
           tt-produt-carg.cod-amostra            = ""
           tt-produt-carg.cod-lacre              = "".
           
    DISPLAY tt-produt-carg.cod-pto-coleta        
            tt-produt-carg.cdn-repos             
            tt-produt-carg.cdn-produt-rural      
            tt-produt-carg.cdn-compart           
            tt-produt-carg.qtd-coleta            
            tt-produt-carg.val-temperat          
            tt-produt-carg.cod-amostra           
            tt-produt-carg.cod-lacre WITH FRAME fPage1. 
             
    APPLY "LEAVE" TO tt-produt-carg.cdn-repos        IN FRAME fPage1.        
    APPLY "LEAVE" TO tt-produt-carg.cod-pto-coleta   IN FRAME fPage1.
    APPLY "LEAVE" TO tt-produt-carg.cdn-produt-rural IN FRAME fPage1.     
    APPLY "ENTRY" TO tt-produt-carg.cod-pto-coleta   IN FRAME fPage1.
     
    RETURN 'OK'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-chama-aq0302b wMaintenanceNoNavigation 
PROCEDURE pi-chama-aq0302b :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-texto AS CHARACTER   NO-UNDO.
    
    DO WHILE c-texto = "":       
        RUN aqp/aq0302b.w (INPUT-OUTPUT c-texto).
    END.                                     

    IF l-log-pto-coleta-coletiv THEN
        RUN setConstraintTexto IN h-boin00965-2 (INPUT c-texto).
    ELSE 
        RUN setConstraintTexto IN h-boin00965 (INPUT c-texto).

    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-inativos wMaintenanceNoNavigation 
PROCEDURE pi-verifica-inativos :
/*------------------------------------------------------------------------------
  Purpose:  Consulta de cadastros inativos - Processo.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i-status    AS INTEGER   NO-UNDO. /* 0-Inativo / 1-Ativo */
  DEFINE VARIABLE i-seq       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE r-ptoColeta AS ROWID     NO-UNDO. 
  DEFINE VARIABLE c-ptoColeta AS CHARACTER NO-UNDO.
  DEFINE VARIABLE r-reposit   AS ROWID     NO-UNDO. 
  DEFINE VARIABLE i-reposit   AS INTEGER   NO-UNDO.

  EMPTY TEMP-TABLE rowErrors.

  /* -- An lise: Ponto de Coleta -- */  
  ASSIGN c-ptoColeta = tt-produt-carg.cod-pto-coleta:SCREEN-VALUE IN FRAME fPage1.

  RUN goToKey IN h-boin00966 (INPUT c-ptoColeta) NO-ERROR.
  IF RETURN-VALUE = "OK":U THEN DO:

    RUN getRowid IN h-boin00966 (OUTPUT r-ptoColeta).
    
    RUN piInicial IN h-aqapi005 (INPUT "Consultar":U,     /* A‡Æo     */
                                 INPUT "PontoDeColeta":U, /* Cadastro */ 
                                 INPUT r-ptoColeta,       /* Tabela   */
                                OUTPUT i-status,          /* Status   */
                          INPUT-OUTPUT TABLE rowErrors).

    IF i-status = 0 /* Inativo*/ THEN DO:

      FIND LAST rowErrors NO-ERROR.
      IF AVAIL rowErrors THEN
        ASSIGN i-seq = rowErrors.errorSequence + 1.
      ELSE 
        ASSIGN i-seq = 1.

      {utp/ut-liter.i Ponto_de_Coleta }
      RUN utp/ut-msgs.p (INPUT "msg":U,
                         INPUT 469,
                         INPUT RETURN-VALUE + " " + c-ptoColeta).

      CREATE rowErrors.
      ASSIGN rowErrors.errorSequence    = i-seq
             rowErrors.errorNumber      = 469
             rowErrors.errorDescription = RETURN-VALUE
             rowErrors.errorHelp        = RETURN-VALUE
             RowErrors.ErrorType        = "EMS":U
             RowErrors.ErrorSubType     = "ERROR":U.
    END.
  END.

  /* -- An lise: reposit -- */  
  ASSIGN i-reposit = INT(tt-produt-carg.cdn-repos:SCREEN-VALUE IN FRAME fPage1).

  RUN goToKey  IN h-boin00984 (INPUT i-reposit,
                               INPUT c-PtoColeta).
  IF RETURN-VALUE = "OK":U THEN DO:

    RUN getRowid IN h-boin00984 (OUTPUT r-reposit).
    
    RUN piInicial IN h-aqapi005 (INPUT "Consultar":U,     /* A‡Æo     */
                                 INPUT "Repositorio":U,   /* Cadastro */ 
                                 INPUT r-reposit,         /* Tabela   */
                                OUTPUT i-status,          /* Status   */
                          INPUT-OUTPUT TABLE rowErrors).

    IF i-status = 0 /* Inativo*/ THEN DO:

      FIND LAST rowErrors NO-ERROR.
      IF AVAIL rowErrors THEN
        ASSIGN i-seq = rowErrors.errorSequence + 1.
      ELSE 
        ASSIGN i-seq = 1.

      {utp/ut-liter.i Reposit¢rio }
      RUN utp/ut-msgs.p (INPUT "msg":U,
                         INPUT 469,
                         INPUT RETURN-VALUE + " " + STRING(i-reposit)).

      CREATE rowErrors.
      ASSIGN rowErrors.errorSequence    = i-seq
             rowErrors.errorNumber      = 469
             rowErrors.errorDescription = RETURN-VALUE
             rowErrors.errorHelp        = RETURN-VALUE
             RowErrors.ErrorType        = "EMS":U
             RowErrors.ErrorSubType     = "ERROR":U.
    END.
  END.

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
    
    DEFINE VARIABLE i-cdn-identif AS INTEGER NO-UNDO.
        
    RUN getCreateSequence IN {&hDBOTable} (OUTPUT i-cdn-identif).
        
    ASSIGN v_cdn-identif = i-cdn-identif. 

    ASSIGN {&ttTable}.cdn-identif        = i-cdn-identif
           {&ttTable}.num-carg           = {&ttParent}.num-carg
           {&ttTable}.cod-estabel        = {&ttParent}.cod-estabel
           {&ttTable}.dat-trans          = {&ttParent}.dat-trans
           {&ttTable}.it-codigo          = {&ttParent}.it-codigo
           {&ttTable}.cdn-produt-respons = INTEGER(tt-produt-carg.cdn-produt-rural:SCREEN-VALUE IN FRAME fPage1)
           {&ttTable}.des-obs            = c-texto.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaCodPropried wMaintenanceNoNavigation 
PROCEDURE atualizaCodPropried :
/*:T------------------------------------------------------------------------------
 Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN findPropried IN h-boin00990 (INPUT INPUT FRAME fpage1 tt-produt-carg.cdn-produt-rural,
                                     INPUT INPUT FRAME fpage1 tt-produt-carg.cod-pto-coleta  ,
                                     OUTPUT c-cod-propried).

    IF tt-produt-carg.cod-propried = '' THEN
        ASSIGN tt-produt-carg.cod-propried = c-cod-propried.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveRecordColetivo wMaintenanceNoNavigation 
PROCEDURE saveRecordColetivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE h-prog-desp AS HANDLE NO-UNDO. 
    
   EMPTY TEMP-TABLE tt-produt-carg-aux NO-ERROR.
   RUN emptyRowErrors IN h-boin00965-2.

   
   CREATE tt-produt-carg-aux.
   ASSIGN tt-produt-carg-aux.cdn-identif    = ?
          tt-produt-carg-aux.num-carg       = {&ttParent}.num-carg
          tt-produt-carg-aux.cod-estabel    = {&ttParent}.cod-estabel
          tt-produt-carg-aux.cod-pto-coleta = INPUT FRAME fpage1 tt-produt-carg.cod-pto-coleta
          tt-produt-carg-aux.dat-trans      = {&ttParent}.dat-trans
          tt-produt-carg-aux.it-codigo      = {&ttParent}.it-codigo
          tt-produt-carg-aux.cdn-compart    = INPUT FRAME fpage1 tt-produt-carg.cdn-compart
          tt-produt-carg-aux.cdn-repos      = INPUT FRAME fpage1 tt-produt-carg.cdn-repos
          tt-produt-carg-aux.cod-propried   =  tt-produt-carg.cod-propried
          tt-produt-carg-aux.des-obs        = c-texto.


   IF  INPUT FRAME fpage1 tt-produt-carg.qtd-coleta > 0 
   AND INPUT FRAME fpage1 tt-produt-carg.cdn-compart = 0 
   AND i-motivo-nao-coleta = 0 THEN DO:

        {utp/ut-liter.i Compartimento}
        RUN utp/ut-msgs.p(INPUT 'SHOW':U,
                          INPUT 36,
                          INPUT RETURN-VALUE).
        APPLY "ENTRY":U TO tt-produt-carg.qtd-coleta IN FRAME fPage1.
        RETURN NO-APPLY.   

   END.
         

   IF INPUT FRAME fpage1 tt-produt-carg.qtd-coleta = 0 THEN DO:
       ASSIGN tt-produt-carg-aux.cdn-motiv-nao-coleta =  i-motivo-nao-coleta
              tt-produt-carg-aux.idi-nao-coleta       = 1. /* NAO TEM MOTIVO DE NAO COLETA */

       RUN createProdutCargNaoColeta IN h-boin00965-2(INPUT TABLE tt-produt-carg-aux, 
                                                      OUTPUT tt-produt-carg-aux.cdn-identif).
   END.                                                                                      
   ELSE DO:
       ASSIGN tt-produt-carg-aux.cod-rota           = {&ttParent}.cod-rota
              tt-produt-carg-aux.val-temperat       = INPUT FRAME fpage1 tt-produt-carg.val-temperat
              tt-produt-carg-aux.cod-amostra        = INPUT FRAME fpage1 tt-produt-carg.cod-amostra
              tt-produt-carg-aux.cod-lacre          = INPUT FRAME fpage1 tt-produt-carg.cod-lacre
              tt-produt-carg-aux.cdn-repos          = INPUT FRAME fpage1 tt-produt-carg.cdn-repos
              tt-produt-carg-aux.cdn-produt-respons = i-cdn-produt-respons
              tt-produt-carg-aux.qtd-coleta         = INPUT FRAME fpage1 tt-produt-carg.qtd-coleta.

       IF INTEGER(cb-nao-coleta:SCREEN-VALUE IN FRAME fPage1) > 0 THEN DO:

            ASSIGN tt-produt-carg-aux.cdn-motiv-nao-coleta = i-motivo-nao-coleta
                   tt-produt-carg-aux.idi-nao-coleta       = 1. /* NAO TEM MOTIVO DE NAO COLETA */ 

       END.


       RUN createProdutCargCol IN h-boin00965-2 (INPUT TABLE tt-produt-carg-aux, OUTPUT tt-produt-carg-aux.cdn-identif).
       IF RETURN-VALUE = 'OK':U THEN DO:
           IF RETURN-VALUE = "OK" THEN DO:
                RUN aqp/aq0302c.w PERSISTENT SET h-prog-desp (INPUT tt-produt-carg-aux.qtd-coleta,
                                                              INPUT tt-produt-carg-aux.num-carg, 
                                                              INPUT tt-produt-carg-aux.cod-pto-coleta, 
                                                              INPUT-OUTPUT tt-produt-carg-aux.cdn-identif).   
    
               IF VALID-HANDLE(h-prog-desp) THEN DO:
                   RUN initializeInterface IN h-prog-desp.
                   SESSION:SET-WAIT-STATE("":U).          
                   WAIT-FOR CLOSE OF h-prog-desp FOCUS CURRENT-WINDOW.
               END.  
           END.
       END.
   END.

    EMPTY TEMP-TABLE rowErrors NO-ERROR.
    RUN getRowErrors IN h-boin00965-2 (OUTPUT TABLE RowErrors).  
    IF CAN-FIND(FIRST RowErrors
                WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:            
        {method/showmessage.i1}
        {method/showmessage.i2}
        RETURN NO-APPLY.
    END. 

    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

