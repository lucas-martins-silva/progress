&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation 


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-internac-impto-faixa NO-UNDO LIKE internac-impto-faixa
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-param-imp NO-UNDO LIKE param-imp
       FIELD r-Rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0007B 2.00.00.003 } /*** 010003 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0007b MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           im0007b
&GLOBAL-DEFINE Version           2.00.00.001

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-internac-impto-faixa
&GLOBAL-DEFINE hDBOTable         h-bocx00454
&GLOBAL-DEFINE DBOTable          internac-impto-faixa

&GLOBAL-DEFINE ttParent          tt-param-imp
&GLOBAL-DEFINE DBOParentTable    h-bocx250na

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       tt-internac-impto-faixa.cdn-moed-base-impto tt-internac-impto-faixa.cdn-moed-impto tt-internac-impto-faixa.val-final-base tt-internac-impto-faixa.val-inicial-base tt-internac-impto-faixa.val-max-impto
&GLOBAL-DEFINE page0ParentFields tt-param-imp.cod-estabel
&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad107     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boun005na     AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-param-imp.cod-estabel ~
tt-internac-impto-faixa.cdn-moed-base-impto ~
tt-internac-impto-faixa.val-inicial-base ~
tt-internac-impto-faixa.val-final-base ~
tt-internac-impto-faixa.cdn-moed-impto ~
tt-internac-impto-faixa.val-max-impto 
&Scoped-define ENABLED-TABLES tt-param-imp tt-internac-impto-faixa
&Scoped-define FIRST-ENABLED-TABLE tt-param-imp
&Scoped-define SECOND-ENABLED-TABLE tt-internac-impto-faixa
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar rtKeys-2 btOK btSave ~
btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-param-imp.cod-estabel ~
tt-internac-impto-faixa.cdn-moed-base-impto ~
tt-internac-impto-faixa.val-inicial-base ~
tt-internac-impto-faixa.val-final-base ~
tt-internac-impto-faixa.cdn-moed-impto ~
tt-internac-impto-faixa.val-max-impto 
&Scoped-define DISPLAYED-TABLES tt-param-imp tt-internac-impto-faixa
&Scoped-define FIRST-DISPLAYED-TABLE tt-param-imp
&Scoped-define SECOND-DISPLAYED-TABLE tt-internac-impto-faixa
&Scoped-Define DISPLAYED-OBJECTS c-desc-estabel c-desc-moed-base ~
c-desc-moed-impto 

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

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-moed-base AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-moed-impto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.92.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-param-imp.cod-estabel AT ROW 1.75 COL 26 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-estabel AT ROW 1.75 COL 32.29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     tt-internac-impto-faixa.cdn-moed-base-impto AT ROW 3.58 COL 26 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-moed-base AT ROW 3.58 COL 32.29 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     tt-internac-impto-faixa.val-inicial-base AT ROW 4.58 COL 26 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tt-internac-impto-faixa.val-final-base AT ROW 5.58 COL 26 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tt-internac-impto-faixa.cdn-moed-impto AT ROW 6.58 COL 26 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-moed-impto AT ROW 6.58 COL 32.29 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     tt-internac-impto-faixa.val-max-impto AT ROW 7.58 COL 26 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     btOK AT ROW 9.75 COL 2
     btSave AT ROW 9.75 COL 13
     btCancel AT ROW 9.75 COL 24
     btHelp AT ROW 9.75 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 9.5 COL 1
     rtKeys-2 AT ROW 3.33 COL 1 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 10.08
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-internac-impto-faixa T "?" NO-UNDO mgcex internac-impto-faixa
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-param-imp T "?" NO-UNDO mgcex param-imp
      ADDITIONAL-FIELDS:
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
         HEIGHT             = 10.13
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
/* SETTINGS FOR FILL-IN c-desc-estabel IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-moed-base IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-moed-impto IN FRAME fpage0
   NO-ENABLE                                                            */
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


&Scoped-define SELF-NAME tt-internac-impto-faixa.cdn-moed-base-impto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-internac-impto-faixa.cdn-moed-base-impto wMaintenanceNoNavigation
ON LEAVE OF tt-internac-impto-faixa.cdn-moed-base-impto IN FRAME fpage0 /* Moeda Base Imposto */
DO:
    {method/referencefields.i 
        &HandleDBOLeave="h-boun005na"
        &KeyValue1="tt-internac-impto-faixa.cdn-moed-base-impto:SCREEN-VALUE IN FRAME fPage0"
        &FieldName1="descricao"
        &FieldScreen1="c-desc-moed-base"
        &Frame1="fPage0"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-internac-impto-faixa.cdn-moed-impto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-internac-impto-faixa.cdn-moed-impto wMaintenanceNoNavigation
ON LEAVE OF tt-internac-impto-faixa.cdn-moed-impto IN FRAME fpage0 /* Moeda Imposto */
DO:
    {method/referencefields.i 
        &HandleDBOLeave="h-boun005na"
        &KeyValue1="tt-internac-impto-faixa.cdn-moed-impto:SCREEN-VALUE IN FRAME fPage0"
        &FieldName1="descricao"
        &FieldScreen1="c-desc-moed-impto"
        &Frame1="fPage0"}     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-param-imp.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-param-imp.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    {method/referencefields.i 
        &HandleDBOLeave="h-boad107"
        &FindMethod="findCodigo"
        &KeyValue1="tt-param-imp.cod-estabel:SCREEN-VALUE IN FRAME fPage0"
        &FieldName1="nome"
        &FieldScreen1="c-desc-estabel"
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DELETE PROCEDURE h-boad107.
ASSIGN h-boad107 = ?.

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

APPLY "LEAVE" TO tt-param-imp.cod-estabel                    IN FRAME fPage0.
APPLY "LEAVE" TO tt-internac-impto-faixa.cdn-moed-impto      IN FRAME fPage0.
APPLY "LEAVE" TO tt-internac-impto-faixa.cdn-moed-base-impto IN FRAME fPage0.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN adbo/boad107.p PERSISTENT SET h-boad107.

IF NOT VALID-HANDLE(h-boun005na) THEN DO:
    RUN unbo/boun005na.p PERSISTENT SET h-boun005na.
    RUN openQueryStatic IN h-boun005na ("Main":U).
END.

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
    
    ASSIGN tt-internac-impto-faixa.cod-estabel = tt-param-imp.cod-estabel.

    RUN getLastSeq IN {&hDBOTable} (INPUT  tt-internac-impto-faixa.cod-estabel,
                                    OUTPUT tt-internac-impto-faixa.num-sequencia).

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

