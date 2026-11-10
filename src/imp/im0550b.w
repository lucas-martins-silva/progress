&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-historico-proc-imp NO-UNDO LIKE mgcex.historico-proc-imp
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-historico-proc-imp2 NO-UNDO LIKE mgcex.historico-proc-imp
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
{include/i-prgvrs.i IM0550B 2.00.00.005 } /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0550b MIM}
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
&GLOBAL-DEFINE Program           IM0550B
&GLOBAL-DEFINE Version        2.00.00.005
&GLOBAL-DEFINE DBOVersion        1.1

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FramesHandle      STRING(FRAME fPage1:HANDLE)
&GLOBAL-DEFINE FolderLabels      Itens

&GLOBAL-DEFINE ttTable           tt-historico-proc-imp2
&GLOBAL-DEFINE hDBOTable         h-bocx140a
&GLOBAL-DEFINE DBOTable          historico-proc-imp

&GLOBAL-DEFINE ttParent          tt-historico-proc-imp
&GLOBAL-DEFINE DBOParentTable    historico-proc-imp

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-historico-proc-imp.cod-estabel ~
                                 tt-historico-proc-imp.nr-proc-imp
&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       

/* Parameters Definitions ---                                           */
def input param pcAction     as char no-undo.
def input param prParent     as rowid no-undo.
def input param phCaller     as handle no-undo.
def input param piSonPageNumber as integer no-undo.
def input param prTable      as rowid no-undo.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
def var h-bocx150 as handle no-undo.
DEFINE TEMP-TABLE tt-ordens NO-UNDO like prazo-compra
    field r-rowid     as rowid
    field valor      as decimal format ">>>>>,>>>,>>9.9999"
    field num-pedido  like processo-imp.num-pedido.
def var cnr-proc-imp as char no-undo.
def var ccod-estabel as char no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ordens

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-ordens.it-codigo tt-ordens.quantidade tt-ordens.valor   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define FIELD-PAIRS-IN-QUERY-brSon1
&Scoped-define SELF-NAME brSon1
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-ordens
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-ordens


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-historico-proc-imp.cod-estabel ~
tt-historico-proc-imp.nr-proc-imp 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-estabel ~{&FP2}cod-estabel ~{&FP3}~
 ~{&FP1}nr-proc-imp ~{&FP2}nr-proc-imp ~{&FP3}
&Scoped-define ENABLED-TABLES tt-historico-proc-imp
&Scoped-define FIRST-ENABLED-TABLE tt-historico-proc-imp
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btOK btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-historico-proc-imp.cod-estabel ~
tt-historico-proc-imp.nr-proc-imp 

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
     SIZE 90 BY 2.29.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-ordens SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMaintenanceNoNavigation _FREEFORM
  QUERY brSon1 DISPLAY
      tt-ordens.it-codigo
      tt-ordens.quantidade COLUMN-LABEL "Qtde" FORMAT ">>>,>>>,>>9.9999"
      tt-ordens.valor COLUMN-LABEL "Valor Total" FORMAT ">>>>>,>>>,>>9.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 84.57 BY 5.96
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-historico-proc-imp.cod-estabel AT ROW 1.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-historico-proc-imp.nr-proc-imp AT ROW 2.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     btOK AT ROW 12.08 COL 2
     btSave AT ROW 12.08 COL 13
     btCancel AT ROW 12.08 COL 24
     btHelp AT ROW 12.08 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 11.88 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 12.46
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.86 ROW 4.67
         SIZE 87 BY 6.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-historico-proc-imp T "?" NO-UNDO mgcex historico-proc-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-historico-proc-imp2 T "?" NO-UNDO mgcex historico-proc-imp
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
         HEIGHT             = 12.46
         WIDTH              = 90
         MAX-HEIGHT         = 16.33
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 16.33
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON btCancel IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       btCancel:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR BUTTON btSave IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       btSave:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens NO-LOCK.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
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


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializaá∆o do programam ---*/
{maintenancenonavigation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) THEN DO:
       enable brSon1 with frame fPage1.
    END.

/* Foi dado um hidden nos bot‰es pois o programa Ç uma consulta,
 * n∆o foram eliminados pois a template faz referància a eles.*/
   assign btSave:hidden in frame fpage0 = yes.
   assign btCancel:hidden in frame fpage0 = yes.

    RUN cxbo/bocx140a.p persistent set h-bocx140a.
    RUN cxbo/bocx150.p persistent set h-bocx150.
        
    RUN OpenQueryBrSon1.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryBrSon1 wMaintenanceNoNavigation 
PROCEDURE OpenQueryBrSon1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN findRowid in h-bocx150 (input prParent).
    RUN getCharField in h-bocx150 (input "nr-proc-imp", output cnr-proc-imp).
    RUN getCharField in h-bocx150 (input "cod-estabel", output ccod-estabel).
      
    RUN setConstraint2 in h-bocx140a (input cnr-proc-imp,
                                      input ccod-estabel,
                                      input 2).
             
    RUN retornaTTOrdens in h-bocx140a (output table tt-ordens).
    RUN findFirst in h-bocx140a.
    {&OPEN-QUERY-brSon1}
    APPLY "VALUE-CHANGED":U TO BROWSE brSon1.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


