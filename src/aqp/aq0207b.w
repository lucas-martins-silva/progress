&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-produt-pto-coleta NO-UNDO LIKE produt-pto-coleta
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-produt-rural NO-UNDO LIKE produt-rural
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-propried-rural NO-UNDO LIKE propried-rural
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-pto-coleta NO-UNDO LIKE pto-coleta
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-reposit NO-UNDO LIKE reposit
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
{include/i-prgvrs.i AQ0207B 2.00.00.037 } /*** "010037" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AQ0207B MAQ}
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
&GLOBAL-DEFINE Program           AQ0207B
&GLOBAL-DEFINE Version        2.00.00.036

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Propriedade, Ponto Coleta, Reposit¢rio, Ponto Coletivo

&GLOBAL-DEFINE ttTable           tt-propried-rural
&GLOBAL-DEFINE hDBOTable         hDBOPropried-rural
&GLOBAL-DEFINE DBOTable          propried-rural

&GLOBAL-DEFINE ttParent          tt-produt-rural
&GLOBAL-DEFINE hDBOParentTable   hDBOProdut-rural
&GLOBAL-DEFINE DBOParentTable    produt-rural

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       tt-propried-rural.cod-propried
&GLOBAL-DEFINE page0ParentFields tt-produt-rural.cdn-produt-rural
&GLOBAL-DEFINE page1Fields       tt-propried-rural.des-propried tt-propried-rural.cod-entrega ~
                                 tt-propried-rural.cod-inscr-imob-rural tt-propried-rural.des-obs ~
                                 tt-propried-rural.cod-rota-princ tt-propried-rural.cod-orgao-sanit ~
                                 tt-propried-rural.log-entreg-pto-terc tt-propried-rural.log-propried-certif ~
                                 tt-propried-rural.cod-regiao tt-propried-rural.log-livre-1 ~
                                 tt-propried-rural.cod-nrp
&GLOBAL-DEFINE page2Fields       tt-pto-coleta.cod-pto-coleta tt-pto-coleta.des-pto-coleta ~
                                 tt-pto-coleta.des-obs ~
                                 tt-pto-coleta.val-media tt-pto-coleta.qtd-distan-km c-cod-externo ~
                                 tt-pto-coleta.cod-un ~
                                 tt-pto-coleta.val-latitude tt-pto-coleta.val-longitude                                  
&GLOBAL-DEFINE page3Fields       tt-reposit.cdn-repos tt-reposit.des-reposit tt-reposit.qtd-capac ~
                                 tt-reposit.cod-marca tt-reposit.cod-modelo tt-reposit.cod-num-serie ~
                                 tt-reposit.cod-barras tt-reposit.des-obs tt-reposit.cod-pto-coleta
&GLOBAL-DEFINE page4Fields       tt-produt-pto-coleta.cod-pto-coleta tt-produt-pto-coleta.cod-externo

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOParentTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00966  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin122    AS HANDLE NO-UNDO.   
DEFINE VARIABLE h-boin417na  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00990  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00977  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00975  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00984  AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-text      AS HANDLE NO-UNDO.

DEFINE VARIABLE multiploPtoColeta        AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE l-findPtoColeta          AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE l-findReposit            AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE l-findPtoColetivo        AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE l-erro-produt-pto-coleta AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE l-log-resp               AS LOGICAL               NO-UNDO.
DEFINE VARIABLE l-log-livre-1 LIKE tt-pto-coleta.log-livre-1      NO-UNDO. /*propriedade ativa*/

DEFINE VARIABLE wh-pesquisa  AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl       AS HANDLE NO-UNDO.

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
tt-propried-rural.cod-propried 
&Scoped-define ENABLED-TABLES tt-produt-rural tt-propried-rural
&Scoped-define FIRST-ENABLED-TABLE tt-produt-rural
&Scoped-define SECOND-ENABLED-TABLE tt-propried-rural
&Scoped-Define ENABLED-OBJECTS c-desc-produtor btSavePropried btCancel ~
btHelp btOKPropried rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-produt-rural.cdn-produt-rural ~
tt-propried-rural.cod-propried 
&Scoped-define DISPLAYED-TABLES tt-produt-rural tt-propried-rural
&Scoped-define FIRST-DISPLAYED-TABLE tt-produt-rural
&Scoped-define SECOND-DISPLAYED-TABLE tt-propried-rural
&Scoped-Define DISPLAYED-OBJECTS c-desc-produtor 

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

DEFINE BUTTON btOKPropried 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE BUTTON btSavePropried 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-desc-produtor AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE c-desc-regiao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-rota AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-externo LIKE produt-pto-coleta.cod-externo
     LABEL "C¢digo Externo" 
     VIEW-AS FILL-IN 
     SIZE 15.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-un AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-reposit-pto-coleta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-produt-pto-coleta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-produt-rural.cdn-produt-rural AT ROW 1.5 COL 18 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-desc-produtor AT ROW 1.5 COL 32.29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     tt-propried-rural.cod-propried AT ROW 2.5 COL 32.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     btOK AT ROW 17.38 COL 2
     btSavePropried AT ROW 17.38 COL 13 WIDGET-ID 6
     btSave AT ROW 17.38 COL 13
     btCancel AT ROW 17.38 COL 24
     btHelp AT ROW 17.38 COL 80
     btOKPropried AT ROW 17.38 COL 2 WIDGET-ID 8
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 17.13 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.83
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage3
     tt-reposit.cod-pto-coleta AT ROW 1.38 COL 23 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-desc-reposit-pto-coleta AT ROW 1.38 COL 37.43 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     tt-reposit.cdn-repos AT ROW 2.42 COL 23 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tt-reposit.des-reposit AT ROW 3.42 COL 23 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 42 BY .88
     tt-reposit.qtd-capac AT ROW 4.42 COL 23 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 15.29 BY .88
     tt-reposit.cod-marca AT ROW 5.42 COL 23 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 42 BY .88
     tt-reposit.cod-modelo AT ROW 6.42 COL 23 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 42 BY .88
     tt-reposit.cod-num-serie AT ROW 7.42 COL 23 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 42 BY .88
     tt-reposit.cod-barras AT ROW 8.46 COL 23 COLON-ALIGNED WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 42 BY .88
     tt-reposit.des-obs AT ROW 9.54 COL 25 NO-LABEL WIDGET-ID 14
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 55 BY 2.54
     "Observa‡Æo:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 9.67 COL 15.86 WIDGET-ID 16
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.92
         SIZE 84.43 BY 11.58
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     tt-produt-pto-coleta.cod-pto-coleta AT ROW 2.67 COL 17.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.29 BY .88
     c-desc-produt-pto-coleta AT ROW 2.67 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     tt-produt-pto-coleta.cod-externo AT ROW 3.67 COL 17.43 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 15.29 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.96
         SIZE 84.43 BY 10.54
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fpage2
     tt-pto-coleta.cod-pto-coleta AT ROW 1.5 COL 14.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.29 BY .88
     tt-pto-coleta.des-pto-coleta AT ROW 1.5 COL 33.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 38.86 BY .88
     tt-pto-coleta.val-media AT ROW 2.5 COL 14.29 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 14.72 BY .88
     tt-pto-coleta.cod-un AT ROW 2.5 COL 42.57 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .88
     c-desc-un AT ROW 2.5 COL 48.14 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     tt-pto-coleta.qtd-distan-km AT ROW 3.5 COL 17.72 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 12.29 BY .88
     c-cod-externo AT ROW 3.5 COL 42.57 COLON-ALIGNED HELP
          "C¢digo Externo" WIDGET-ID 38
          LABEL "C¢digo Externo"
     tt-pto-coleta.val-latitude AT ROW 4.5 COL 14.43 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 11.14 BY .88
     tt-pto-coleta.val-longitude AT ROW 4.5 COL 37.14 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .88
     tt-pto-coleta.des-obs AT ROW 5.58 COL 16.43 NO-LABEL WIDGET-ID 20
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 58.14 BY 3.42
     "Observa‡Æo:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 6.63 COL 7.14 WIDGET-ID 30
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5
         SIZE 84.43 BY 10.5
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tt-propried-rural.des-propried AT ROW 1.46 COL 21 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 47 BY .88
     tt-propried-rural.cod-inscr-imob-rural AT ROW 2.46 COL 21 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     tt-propried-rural.cod-entrega AT ROW 3.46 COL 21 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tt-propried-rural.cod-rota-princ AT ROW 4.46 COL 21 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     c-desc-rota AT ROW 4.46 COL 34.14 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     tt-propried-rural.cod-regiao AT ROW 5.46 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     c-desc-regiao AT ROW 5.46 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     tt-propried-rural.cod-orgao-sanit AT ROW 6.46 COL 21 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 28 BY .88
     tt-propried-rural.log-propried-certif AT ROW 6.5 COL 52 WIDGET-ID 22
          VIEW-AS TOGGLE-BOX
          SIZE 19.43 BY .83
     tt-propried-rural.cod-nrp AT ROW 7.5 COL 21 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     tt-propried-rural.log-livre-1 AT ROW 7.5 COL 52 HELP	  
          "" WIDGET-ID 28
          LABEL "Ativo"
          VIEW-AS TOGGLE-BOX
          SIZE 20.72 BY .83
     tt-propried-rural.log-entreg-pto-terc AT ROW 8.46 COL 23.29 WIDGET-ID 22
          LABEL "Entrega em ponto de coleta de terceiros"
          VIEW-AS TOGGLE-BOX
          SIZE 39.72 BY .83
     tt-propried-rural.des-obs AT ROW 9.46 COL 23 NO-LABEL WIDGET-ID 10
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 47 BY 2.5
     "Observa‡Æo:" VIEW-AS TEXT
          SIZE 8.72 BY .54 AT ROW 9.46 COL 13.72 WIDGET-ID 16
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5
         SIZE 84.43 BY 11.75
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-produt-pto-coleta T "?" NO-UNDO mgind produt-pto-coleta
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-produt-rural T "?" NO-UNDO mgind produt-rural
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-propried-rural T "?" NO-UNDO mgind propried-rural
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-pto-coleta T "?" NO-UNDO mgind pto-coleta
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-reposit T "?" NO-UNDO mgind reposit
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
         HEIGHT             = 17.83
         WIDTH              = 90
         MAX-HEIGHT         = 17.83
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17.83
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
       FRAME fpage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fPage3:MOVE-BEFORE-TAB-ITEM (tt-produt-rural.cdn-produt-rural:HANDLE IN FRAME fpage0)
       XXTABVALXX = FRAME fpage2:MOVE-BEFORE-TAB-ITEM (FRAME fPage3:HANDLE)
       XXTABVALXX = FRAME fPage1:MOVE-BEFORE-TAB-ITEM (FRAME fpage2:HANDLE)
       XXTABVALXX = FRAME fPage4:MOVE-BEFORE-TAB-ITEM (FRAME fPage1:HANDLE)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR BUTTON btOK IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       btOK:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR BUTTON btSave IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       btSave:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR TOGGLE-BOX tt-propried-rural.log-entreg-pto-terc IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX tt-propried-rural.log-livre-1 IN FRAME fPage1
   EXP-LABEL EXP-HELP                                                   */
/* SETTINGS FOR FRAME fpage2
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-externo IN FRAME fpage2
   LIKE = mgind.produt-pto-coleta.cod-externo EXP-LABEL EXP-SIZE        */
/* SETTINGS FOR FRAME fPage3
                                                                        */
ASSIGN 
       tt-reposit.cod-barras:DROP-TARGET IN FRAME fPage3      = TRUE.

/* SETTINGS FOR FRAME fPage4
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage2
/* Query rebuild information for FRAME fpage2
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
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
    APPLY "CHOOSE":U TO btSavePropried IN FRAME fpage0.
    IF RETURN-VALUE <> "NOK" THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOKPropried
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOKPropried wMaintenanceNoNavigation
ON CHOOSE OF btOKPropried IN FRAME fpage0 /* OK */
DO:
    APPLY "CHOOSE":U TO btSavePropried IN FRAME fpage0.
    IF RETURN-VALUE <> "NOK" THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    
    RETURN "OK":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSavePropried
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSavePropried wMaintenanceNoNavigation
ON CHOOSE OF btSavePropried IN FRAME fpage0 /* Salvar */
DO:

    DEF VAR i-folder AS INT NO-UNDO.

    RUN getCurrentFolder IN hFolder (OUTPUT i-folder).
    IF i-folder = 1 OR i-folder = 4 THEN DO:
        IF l-erro-produt-pto-coleta THEN DO:        
            RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.  
            RUN goToKey IN {&hDBOTable}(tt-propried-rural.cod-propried).
            ASSIGN l-erro-produt-pto-coleta = NO.
        END.       
    
        RUN saveRecord IN THIS-PROCEDURE.
        IF RETURN-VALUE = "NOK":U THEN
           RETURN "NOK":U.
       
       RUN afterSaveRecord IN THIS-PROCEDURE.
       IF RETURN-VALUE = "NOK":U THEN DO:
            IF l-erro-produt-pto-coleta THEN
                run setFolder in hFolder (input 4).
                
           RETURN "NOK":U.           
       END.   
       IF tt-propried-rural.log-entreg-pto-terc:screen-value in frame fPage1 = "Sim" THEN DO:
           run setEnabled in hFolder (input 2, input FALSE).
           run setEnabled in hFolder (input 3, input FALSE).
           run setEnabled in hFolder (input 4, input TRUE).
       END.
       ELSE DO:
           run setEnabled in hFolder (input 2, input TRUE).
           run setEnabled in hFolder (input 4, input FALSE).
       END.
       ASSIGN pcAction = "UPDATE":U
              tt-propried-rural.cod-propried:sensitive in frame fpage0 = NO.
       RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.  
       DEFINE BUFFER bf-propried-rural FOR propried-rural.
       RUN emptyRowErrors IN {&hDBOTable}.
       FIND FIRST bf-propried-rural WHERE bf-propried-rural.cod-propried = tt-propried-rural.cod-propried:screen-value in frame fpage0 NO-LOCK NO-ERROR.
       RUN repositionRecord IN {&hDBOTable}(INPUT ROWID(bf-propried-rural)).
       EMPTY TEMP-TABLE tt-propried-rural.
       
       IF RETURN-VALUE = "OK":U THEN DO:
           RUN getRecord IN {&hDBOTable}(OUTPUT TABLE tt-propried-rural).
           FIND FIRST tt-propried-rural NO-ERROR.

            IF tt-propried-rural.log-entreg-pto-terc:screen-value in frame fPage1 = "Sim" THEN
                run setFolder in hFolder (input 4).
            ELSE
                run setFolder in hFolder (input 2).
       END.
    END.

    IF i-folder = 2 THEN DO:

        /*Verifica se ‚ cria‡Æo ou modifica‡Æo*/
        IF tt-pto-coleta.cod-pto-coleta:sensitive in frame fpage2 = YES THEN
            ASSIGN pcAction = "ADD":U.
        ELSE
            ASSIGN pcAction = "UPDATE":U.

        RUN beforeSaveRecord IN THIS-PROCEDURE.
         IF RETURN-VALUE = "NOK":U THEN
           RETURN "NOK":U.
      
        RUN afterSaveRecord IN THIS-PROCEDURE.
        IF RETURN-VALUE = "NOK":U THEN
           RETURN "NOK":U.

        IF tt-propried-rural.log-entreg-pto-terc:screen-value in frame fPage1 = "Sim" THEN DO:
            run setEnabled in hFolder (input 2, input FALSE).
            run setEnabled in hFolder (input 3, input FALSE).
            run setEnabled in hFolder (input 4, input TRUE).
        END.
        ELSE DO:
            run setEnabled in hFolder (input 3, input TRUE).
            run setEnabled in hFolder (input 4, input FALSE).
        END.

        ASSIGN pcAction = "UPDATE":U
               tt-pto-coleta.cod-pto-coleta:sensitive in frame fpage2 = NO.
        RUN openQueryStatic IN h-boin00966 (INPUT "Main":U) NO-ERROR.  
        DEFINE BUFFER bf-pto-coleta FOR pto-coleta.
        RUN emptyRowErrors IN h-boin00966.
        FIND FIRST bf-pto-coleta WHERE bf-pto-coleta.cod-propried = {&ttTable}.cod-propried NO-LOCK NO-ERROR.
        RUN repositionRecord IN h-boin00966 (INPUT ROWID(bf-pto-coleta)).

        EMPTY TEMP-TABLE tt-pto-coleta.
        
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getRecord IN h-boin00966(OUTPUT TABLE tt-pto-coleta).
            FIND FIRST tt-pto-coleta NO-ERROR.
            run setFolder in hFolder (input 3).
            
        END.

        ASSIGN tt-reposit.cod-pto-coleta:SCREEN-VALUE IN FRAME fpage3 = tt-pto-coleta.cod-pto-coleta:SCREEN-VALUE in frame fpage2.
        APPLY "LEAVE" TO tt-reposit.cod-pto-coleta IN FRAME fpage3.
    END.

    IF i-folder = 3 THEN DO:

        /*Verifica se ‚ cria‡Æo ou modifica‡Æo*/
        IF tt-reposit.cdn-repos:sensitive in frame fpage3 = YES THEN
            ASSIGN pcAction = "ADD":U.
        ELSE
            ASSIGN pcAction = "UPDATE":U.

        RUN beforeSaveRecord IN THIS-PROCEDURE.
        IF RETURN-VALUE = "NOK":U THEN
           RETURN "NOK":U.
        
        RUN afterSaveRecord IN THIS-PROCEDURE.
        IF RETURN-VALUE = "NOK":U THEN
           RETURN "NOK":U.
           
        
        IF tt-propried-rural.log-entreg-pto-terc:screen-value in frame fPage1 = "Sim" THEN DO:
            run setEnabled in hFolder (input 2, input FALSE).
            run setEnabled in hFolder (input 3, input FALSE).
            run setEnabled in hFolder (input 4, input TRUE).
        END.
        ELSE DO:
            run setEnabled in hFolder (input 4, input FALSE).
        END.
        ASSIGN pcAction = "UPDATE":U
               tt-reposit.cdn-repos:sensitive in frame fpage3 = NO.
        RUN openQueryStatic IN h-boin00984 (INPUT "Main":U) NO-ERROR.  
        DEFINE BUFFER bf-reposit FOR reposit.
        RUN emptyRowErrors IN h-boin00984.
        FIND FIRST bf-reposit WHERE bf-reposit.cod-pto-coleta = tt-pto-coleta.cod-pto-coleta NO-LOCK NO-ERROR.
        RUN repositionRecord IN h-boin00984 (INPUT ROWID(bf-reposit)).

        EMPTY TEMP-TABLE tt-pto-coleta.
        
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getRecord IN h-boin00984(OUTPUT TABLE tt-reposit).
            FIND FIRST tt-reposit NO-ERROR.
        END.

    END.
    
    RETURN "OK":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-produt-rural.cdn-produt-rural
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-rural.cdn-produt-rural wMaintenanceNoNavigation
ON LEAVE OF tt-produt-rural.cdn-produt-rural IN FRAME fpage0 /* Produtor Rural */
DO:
    def var c-nome-abrev like emitente.nome-abrev no-undo.
    def var c-nome-emit  like emitente.nome-emit no-undo.
    DEF VAR c-return     AS CHAR   NO-UNDO.
    def var h-boad098    AS HANDLE NO-UNDO.
    
    assign input frame {&frame-name} tt-produt-rural.cdn-produt-rural.
    run adbo/boad098.p persistent set h-boad098.        
    run findCodigo in h-boad098(input tt-produt-rural.cdn-produt-rural, output c-return).
    if c-return = "" then do:
        run getCharfield in h-boad098(input "nome-abrev", output c-nome-abrev).
        run getCharfield in h-boad098(input "nome-emit", output c-nome-emit).
        assign c-desc-produtor:screen-value = c-nome-emit
               tt-propried-rural.nome-abrev = c-nome-abrev.
    end.
    delete procedure h-boad098.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-propried-rural.cod-entrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-propried-rural.cod-entrega wMaintenanceNoNavigation
ON F5 OF tt-propried-rural.cod-entrega IN FRAME fPage1 /* Cod Entrega */
DO:
  /*--- Zoom Smart Object ---*/
    {include/zoomvar.i &prog-zoom="dizoom/z01di102.w"
                       &campo=tt-propried-rural.cod-entrega
                       &campozoom=cod-entrega
                       &parametros="run pi-seta-inicial in wh-pesquisa (input tt-propried-rural.nome-abrev)."}     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-propried-rural.cod-entrega wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-propried-rural.cod-entrega IN FRAME fPage1 /* Cod Entrega */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage2
&Scoped-define SELF-NAME tt-pto-coleta.cod-pto-coleta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-pto-coleta wMaintenanceNoNavigation
ON LEAVE OF tt-pto-coleta.cod-pto-coleta IN FRAME fpage2 /* Ponto Coleta */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-boin00966"
      &KeyValue1="tt-pto-coleta.cod-pto-coleta:SCREEN-VALUE IN FRAME fpage2"
      &FieldName1="des-pto-coleta"
      &FieldScreen1="tt-pto-coleta.des-pto-coleta"
      &Frame1="fpage2"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME tt-produt-pto-coleta.cod-pto-coleta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-pto-coleta.cod-pto-coleta wMaintenanceNoNavigation
ON F5 OF tt-produt-pto-coleta.cod-pto-coleta IN FRAME fPage4 /* Ponto Coleta */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z01in00966.w"
                       &FieldZoom1="cod-pto-coleta"
                       &FieldScreen1="tt-produt-pto-coleta.cod-pto-coleta"
                       &Frame1="fpage4"
                       &FieldZoom2="des-pto-coleta"
                       &FieldScreen2="c-desc-produt-pto-coleta"
                       &Frame2="fpage4"
                       &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-pto-coleta.cod-pto-coleta wMaintenanceNoNavigation
ON LEAVE OF tt-produt-pto-coleta.cod-pto-coleta IN FRAME fPage4 /* Ponto Coleta */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-boin00966"
      &KeyValue1="tt-produt-pto-coleta.cod-pto-coleta:SCREEN-VALUE IN FRAME fpage4"
      &FieldName1="des-pto-coleta"
      &FieldScreen1="c-desc-produt-pto-coleta"
      &Frame1="fpage4"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-pto-coleta.cod-pto-coleta wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-produt-pto-coleta.cod-pto-coleta IN FRAME fPage4 /* Ponto Coleta */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME tt-reposit.cod-pto-coleta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-reposit.cod-pto-coleta wMaintenanceNoNavigation
ON LEAVE OF tt-reposit.cod-pto-coleta IN FRAME fPage3 /* Ponto Coleta */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-boin00966"
      &KeyValue1="tt-reposit.cod-pto-coleta:SCREEN-VALUE IN FRAME fpage3"
      &FieldName1="des-pto-coleta"
      &FieldScreen1="c-desc-reposit-pto-coleta"
      &Frame1="fpage3"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-propried-rural.cod-regiao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-propried-rural.cod-regiao wMaintenanceNoNavigation
ON LEAVE OF tt-propried-rural.cod-regiao IN FRAME fPage1 /* RegiÆo */
DO:
  {method/referencefields.i 
      &HandleDBOLeave="h-boin00977"
      &KeyValue1="tt-propried-rural.cod-regiao:SCREEN-VALUE IN FRAME fPage1"
      &FieldName1="nom-regiao"
      &FieldScreen1="c-desc-regiao"
      &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-propried-rural.cod-regiao wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-propried-rural.cod-regiao IN FRAME fPage1 /* RegiÆo */
OR "F5" OF tt-propried-rural.cod-regiao DO:
    {method/zoomfields.i &ProgramZoom="inzoom/z01in00977.w"
                       &FieldZoom1="cod-regiao"
                       &FieldScreen1="tt-propried-rural.cod-regiao"
                       &Frame1="fpage1"
                       &FieldZoom2="nom-regiao"
                       &FieldScreen2="c-desc-regiao"
                       &Frame2="fpage1"
                       &EnableImplant="yes"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-propried-rural.cod-rota-princ
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-propried-rural.cod-rota-princ wMaintenanceNoNavigation
ON F5 OF tt-propried-rural.cod-rota-princ IN FRAME fPage1 /* C¢digo Rota Principal */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z01in00975.w"
                       &FieldZoom1="cod-rota"
                       &FieldScreen1="tt-propried-rural.cod-rota-princ"
                       &Frame1="fpage1"
                       &FieldZoom2="des-rota"
                       &FieldScreen2="c-desc-rota"
                       &Frame2="fpage1"
                       &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-propried-rural.cod-rota-princ wMaintenanceNoNavigation
ON LEAVE OF tt-propried-rural.cod-rota-princ IN FRAME fPage1 /* C¢digo Rota Principal */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-boin00975"
      &KeyValue1="tt-propried-rural.cod-rota-princ:SCREEN-VALUE IN FRAME fpage1"
      &FieldName1="des-rota"
      &FieldScreen1="c-desc-rota"
      &Frame1="fpage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-propried-rural.cod-rota-princ wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-propried-rural.cod-rota-princ IN FRAME fPage1 /* C¢digo Rota Principal */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage2
&Scoped-define SELF-NAME tt-pto-coleta.cod-un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-un wMaintenanceNoNavigation
ON F5 OF tt-pto-coleta.cod-un IN FRAME fpage2 /* UN */
DO:
    ASSIGN l-implanta = NO.
    {include/zoomvar.i &prog-zoom="inzoom/z01in417.w"
                       &campo=tt-pto-coleta.cod-un
                       &campozoom=un
                       &FRAME="fpage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-un wMaintenanceNoNavigation
ON LEAVE OF tt-pto-coleta.cod-un IN FRAME fpage2 /* UN */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-boin417na"
      &KeyValue1="tt-pto-coleta.cod-un:SCREEN-VALUE IN FRAME fpage2"
      &FieldName1="descricao"
      &FieldScreen1="c-desc-un"
      &Frame1="fpage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-un wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-pto-coleta.cod-un IN FRAME fpage2 /* UN */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-propried-rural.log-entreg-pto-terc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-propried-rural.log-entreg-pto-terc wMaintenanceNoNavigation
ON VALUE-CHANGED OF tt-propried-rural.log-entreg-pto-terc IN FRAME fPage1 /* Entrega em ponto de coleta de terceiros */
DO:
    IF pcAction = "UPDATE" THEN DO:
        IF tt-propried-rural.log-entreg-pto-terc:screen-value in frame fPage1 = "Sim" THEN DO:
            run setEnabled in hFolder (input 2, input FALSE).
            run setEnabled in hFolder (input 3, input FALSE).
            run setEnabled in hFolder (input 4, input TRUE).
        END.
        ELSE DO:                        
            run utp/ut-msgs(INPUT "Show":u,
                             INPUT 54740,
                             INPUT "").
            if return-value = "yes" then do: 
                run setEnabled in hFolder (input 2, input FALSE).
                run setEnabled in hFolder (input 3, input FALSE).
                run setEnabled in hFolder (input 4, input FALSE).
            end.
            else do:
                ASSIGN tt-propried-rural.log-entreg-pto-terc:screen-value in frame fPage1 = "NÆo"
                       tt-propried-rural.log-entreg-pto-terc:checked in frame fPage1 = yes.
            end.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-propried-rural.cod-entrega:LOAD-MOUSE-POINTER("image/lupa.cur":U)       in frame fPage1.
tt-propried-rural.cod-rota-princ:LOAD-MOUSE-POINTER("image/lupa.cur":U)    in frame fPage1.
tt-propried-rural.cod-regiao:LOAD-MOUSE-POINTER("image/lupa.cur":U)        in frame fpage1.
tt-pto-coleta.cod-un:LOAD-MOUSE-POINTER("image/lupa.cur":U)                in frame fpage2.
tt-produt-pto-coleta.cod-pto-coleta:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fpage4.

{utp/ut-liter.i "Distƒncia_KM" *}
ASSIGN wh-text = tt-pto-coleta.qtd-distan-km:SIDE-LABEL-HANDLE
       wh-text:SCREEN-VALUE = RETURN-VALUE
       tt-pto-coleta.qtd-distan-km:COLUMN IN FRAME fpage2 = 16.29
       wh-text:COL = tt-pto-coleta.qtd-distan-km:COLUMN IN FRAME fpage2 - wh-text:WIDTH.

{utp/ut-liter.i "Cod_Endere‡o" *}
ASSIGN tt-propried-rural.cod-entrega:LABEL = RETURN-VALUE.

{utp/ut-liter.i "Rota_Principal" *}
ASSIGN tt-propried-rural.cod-rota-princ:LABEL = RETURN-VALUE.

{utp/ut-liter.i "Reg_àrgÆo_Sanit rio" *}
ASSIGN tt-propried-rural.cod-orgao-sanit:LABEL = RETURN-VALUE.

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
    IF VALID-HANDLE(h-boin122) THEN DO:
       DELETE PROCEDURE h-boin122.
       ASSIGN h-boin122 = ?.
    END.

    IF VALID-HANDLE(h-boin417na) THEN DO:
       DELETE PROCEDURE h-boin417na.
       ASSIGN h-boin417na = ?.
    END.

    IF VALID-HANDLE(h-boin00990) THEN DO:
       DELETE PROCEDURE h-boin00990.
       ASSIGN h-boin00990 = ?.
    END.

    IF VALID-HANDLE(h-boin00977) THEN DO:
       DELETE PROCEDURE h-boin00977.
       ASSIGN h-boin00977 = ?.
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

    DEF VAR c-ret AS CHAR NO-UNDO.

    IF pcAction = "ADD":U  THEN
        ASSIGN tt-propried-rural.log-livre-1:CHECKED IN FRAME fPage1 = TRUE.

    APPLY "LEAVE" TO tt-produt-rural.cdn-produt-rural IN FRAME fPage0.
    APPLY "LEAVE" TO tt-propried-rural.cod-rota-princ IN FRAME fPage1.
    APPLY "LEAVE" TO tt-propried-rural.cod-regiao IN FRAME fPage1.
    APPLY "LEAVE" TO tt-pto-coleta.cod-un IN FRAME fPage2.
    APPLY "LEAVE" TO tt-reposit.cod-pto-coleta IN FRAME fPage3.
    APPLY "LEAVE" TO tt-produt-pto-coleta.cod-pto-coleta IN FRAME fPage4.

    IF AVAIL tt-produt-rural     AND
       AVAIL tt-pto-coleta       AND
       AVAIL tt-propried-rural   AND
       VALID-HANDLE(h-boin00990) THEN DO:

        RUN gotokey IN h-boin00990(INPUT tt-produt-rural.cdn-produt-rural:SCREEN-VALUE IN FRAME fpage0,
                                   INPUT tt-pto-coleta.cod-pto-coleta:SCREEN-VALUE IN FRAME fPage2,
                                   INPUT tt-propried-rural.cod-propried:SCREEN-VALUE IN FRAME fPage0).
        
        IF RETURN-VALUE = "OK" THEN DO:
            RUN getCharField IN h-boin00990 (INPUT "cod-externo":U, OUTPUT c-ret).
            ASSIGN c-cod-externo:SCREEN-VALUE IN FRAME fpage2 = c-ret.
        END.

    END.
    
    ASSIGN l-log-livre-1 = tt-propried-rural.log-livre-1:CHECKED IN FRAME fPage1. /*confere desativação para disparar processo caso mude o flag*/
            

    

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
    
    ASSIGN tt-reposit.cod-pto-coleta:sensitive in frame fPage3 = NO.
        
    IF pcAction = "ADD" THEN
        ASSIGN tt-propried-rural.cod-propried:sensitive in frame fpage0 = YES.
    
    IF pcAction = "UPDATE" THEN
        assign tt-propried-rural.cod-propried:sensitive in frame fpage0 = NO.      
                
        IF l-findPtoColeta = TRUE THEN
            ASSIGN tt-pto-coleta.cod-pto-coleta:sensitive in frame fPage2 = NO. 
        IF l-findReposit = TRUE THEN
            ASSIGN tt-reposit.cdn-repos:sensitive in frame fPage3 = NO. 

    ASSIGN btSave:sensitive in frame fpage0 = NO.

    ASSIGN btSavePropried:SENSITIVE IN FRAME fpage0 = YES
           btOKPropried:SENSITIVE IN FRAME fpage0 = YES.

    btSavePropried:MOVE-TO-TOP().
    btOKPropried:MOVE-TO-TOP().

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

    IF pcAction = "ADD" THEN DO:
        run setEnabled in hFolder (input 2, input FALSE).
        run setEnabled in hFolder (input 3, input FALSE).
        run setEnabled in hFolder (input 4, input FALSE).
    END.
        
    IF pcAction = "UPDATE" THEN DO:
        IF tt-propried-rural.log-entreg-pto-terc = TRUE THEN DO:
            run setEnabled in hFolder (input 2, input FALSE).
            run setEnabled in hFolder (input 3, input FALSE).
            run setEnabled in hFolder (input 4, input TRUE).
        END.
        ELSE DO:
            run setEnabled in hFolder (input 2, input TRUE).
            run setEnabled in hFolder (input 3, input TRUE).
            run setEnabled in hFolder (input 4, input FALSE).
        END.

        IF l-findPtoColetivo AND tt-propried-rural.log-entreg-pto-terc = TRUE THEN DO:
            run setEnabled in hFolder (input 2, input FALSE).
            run setEnabled in hFolder (input 3, input FALSE).
        END.
        ELSE DO:
            run setEnabled in hFolder (input 2, input TRUE).
            run setEnabled in hFolder (input 3, input TRUE).
        END.
    END.

    APPLY 'ENTRY' TO tt-propried-rural.cod-propried IN FRAME fpage0.

    FRAME fpage1:MOVE-AFTER-TAB-ITEM(tt-propried-rural.cod-propried:HANDLE IN FRAME fPage0).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveRecord wMaintenanceNoNavigation 
PROCEDURE afterSaveRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE h-aqapi005 AS HANDLE  NO-UNDO.
    DEFINE VARIABLE rRowid     AS ROWID   NO-UNDO.
    DEFINE VARIABLE iSituacao  AS INTEGER NO-UNDO.

    IF  h-aqapi005 = ? THEN
        RUN aqp/aqapi005.p PERSISTENT SET h-aqapi005.
    
    IF l-log-livre-1 <> tt-propried-rural.log-livre-1 THEN DO:

        IF VALID-HANDLE ({&hDBOTable}) THEN
            RUN goToKey IN {&hDBOTable} (INPUT tt-propried-rural.cod-propried).

            RUN getRowid IN {&hDBOTable} (OUTPUT rRowid).

            IF NOT tt-propried-rural.log-livre-1 THEN DO:

                RUN piInicial IN h-aqapi005 (INPUT  "desativar":U,
                                             INPUT  "propriedade":U,
                                             INPUT  rRowid,
                                             OUTPUT iSituacao,
                                             INPUT-OUTPUT TABLE rowErrors).

                IF RETURN-VALUE = "NOK":U THEN /*ocorreu algum erro e não desativou os cadastros*/

                    RUN piInicial IN h-aqapi005 (INPUT  "ativar":U,
                                                 INPUT  "propriedade":U,
                                                 INPUT  rRowid,
                                                 OUTPUT iSituacao,
                                                 INPUT-OUTPUT TABLE rowErrors).

            END.

    END.

    IF  h-aqapi005 <> ? THEN DO:
        DELETE PROCEDURE h-aqapi005.
        ASSIGN h-aqapi005 = ?.    
    END.

    IF AVAIL tt-produt-pto-coleta THEN
        ASSIGN tt-produt-pto-coleta.log-livre-1 = TRUE.

    IF AVAIL tt-pto-coleta THEN
        ASSIGN tt-pto-coleta.log-livre-1 = TRUE.

    IF multiploPtoColeta = FALSE AND AVAIL tt-propried-rural AND tt-propried-rural.log-entreg-pto-terc = FALSE THEN DO:
        /*** Verifica se foi digitado ponto de coleta, para então salvar ***/
        IF tt-pto-coleta.cod-pto-coleta:SCREEN-VALUE IN FRAME fPage2 <> "" THEN DO:           

            /* Atualiza regiao da propriedade no ponto de coleta */
            ASSIGN tt-pto-coleta.cod-regiao = tt-propried-rural.cod-regiao.

            EMPTY TEMP-TABLE rowErrors.

            RUN setRecord IN h-boin00966(INPUT TABLE tt-pto-coleta).
            RUN emptyRowErrors IN h-boin00966.
            
            RUN createProdutPtoColeta IN THIS-PROCEDURE (INPUT YES).
            IF l-findPtoColeta = TRUE THEN DO:           
                RUN updateRecord IN h-boin00966.
            END.
            ELSE DO:
                RUN createRecord IN h-boin00966.
            END.
            
            IF RETURN-VALUE = "NOK":U THEN DO:
                /*Retorna os erros.*/
                RUN getRowErrors IN h-boin00966 (OUTPUT TABLE RowErrors).
                /*elimina erros internos*/
                FOR EACH RowErrors WHERE RowErrors.ErrorType = "INTERNAL":U EXCLUSIVE-LOCK:
                    DELETE RowErrors.
                END.
                IF CAN-FIND (FIRST RowErrors) THEN DO:
                    /** Instancia aplicativo **/
                    {method/showmessage.i1}
                    /** Mostra caixa com erros **/
                    {method/showmessage.i2 &Modal="YES"}
                    /** Limpa temp-tables de erros **/
                    empty temp-table RowErrors.
                    RETURN "NOK":U.
                END.
            END.

            
            IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
           
            IF tt-reposit.cdn-repos:SCREEN-VALUE IN FRAME fPage3 <> "0" THEN DO:
                RUN saveRepositorio IN THIS-PROCEDURE.
                IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
            END.
        END.
    END.
    ELSE IF AVAIL tt-propried-rural AND tt-propried-rural.log-entreg-pto-terc = TRUE THEN DO:
        /*** Verifica se foi digitado ponto coletivo, para então salvar ***/
        IF tt-produt-pto-coleta.cod-pto-coleta:SCREEN-VALUE IN FRAME fPage4 <> "" THEN DO:
            
            RUN createProdutPtoColeta IN THIS-PROCEDURE (INPUT NO). /* Criação/alteração da produt-pto-coleta (COLETIVO) */
            RUN getRowErrors IN h-boin00990 (OUTPUT TABLE RowErrors).
            FOR EACH RowErrors WHERE RowErrors.ErrorType = "INTERNAL":U :
                DELETE RowErrors.
            END.            
            IF CAN-FIND(FIRST RowErrors) THEN DO:
                {method/showmessage.i1}                    
                {method/showmessage.i2 &Modal="YES"}                    
                EMPTY TEMP-TABLE RowErrors NO-ERROR.            
                ASSIGN l-erro-produt-pto-coleta = YES.             
                RETURN "NOK":U.
            END.          
        END.
    END.

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

    /* Ponto de coleta */
    RUN findPtoColeta IN THIS-PROCEDURE.

    /* Ponto de coleta coletivo */
    RUN findPtoColetivo IN THIS-PROCEDURE.

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

    /* Ponto de coleta */
    RUN findPtoColeta IN THIS-PROCEDURE.
    
    RETURN "OK":U.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveRecord wMaintenanceNoNavigation 
PROCEDURE beforeSaveRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-msg1 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-msg2 AS CHARACTER NO-UNDO.

    IF multiploPtoColeta = FALSE AND AVAIL tt-propried-rural AND tt-propried-rural.log-entreg-pto-terc = FALSE THEN DO:
        /*** Verifica se foi digitado ponto de coleta, para então salvar ***/
        IF tt-pto-coleta.cod-pto-coleta:SCREEN-VALUE IN FRAME fPage2 <> "" THEN DO: 

            /*Atualiza status do pcAction*/
            IF tt-pto-coleta.cod-pto-coleta:sensitive in frame fpage2 = YES THEN
                ASSIGN pcAction = "ADD":U.
            ELSE
                ASSIGN pcAction = "UPDATE":U.

            RUN findPtoColeta IN THIS-PROCEDURE.
            
            /*Campos tabela ponto de coleta*/
            IF pcAction = "ADD":U THEN
                ASSIGN tt-pto-coleta.cod-pto-coleta = tt-pto-coleta.cod-pto-coleta:SCREEN-VALUE IN FRAME fPage2
                       tt-pto-coleta.cod-propried = tt-propried-rural.cod-propried:SCREEN-VALUE IN FRAME fPage0.

            ASSIGN tt-pto-coleta.des-pto-coleta = tt-pto-coleta.des-pto-coleta:SCREEN-VALUE IN FRAME fPage2                   
                   tt-pto-coleta.val-media = DECIMAL(tt-pto-coleta.val-media:SCREEN-VALUE IN FRAME fPage2)
                   tt-pto-coleta.qtd-distan-km = DECIMAL(tt-pto-coleta.qtd-distan-km:SCREEN-VALUE IN FRAME fPage2)
                   tt-pto-coleta.cod-un = tt-pto-coleta.cod-un:SCREEN-VALUE IN FRAME fPage2
                   tt-pto-coleta.val-latitude = DECIMAL(tt-pto-coleta.val-latitude:SCREEN-VALUE IN FRAME fPage2)
                   tt-pto-coleta.val-longitude = DECIMAL(tt-pto-coleta.val-longitude:SCREEN-VALUE IN FRAME fPage2)
                   tt-pto-coleta.des-obs = tt-pto-coleta.des-obs:SCREEN-VALUE IN FRAME fPage2
                   tt-pto-coleta.cod-regiao = tt-propried-rural.cod-regiao:SCREEN-VALUE IN FRAME fPage1.

            
            EMPTY TEMP-TABLE rowErrors.

            RUN setRecord IN h-boin00966(INPUT TABLE tt-pto-coleta).

            RUN emptyRowErrors IN h-boin00966.

            if l-findPtoColeta = FALSE then
               RUN validateRecord IN h-boin00966(input "CREATE":U).
            else
               RUN validateRecord IN h-boin00966(input "UPDATE":U).
            RUN getRowErrors IN h-boin00966(output table RowErrors).
            if can-find(first rowErrors) then do:
              {method/ShowMessage.i1}
              {method/ShowMessage.i2}
              RETURN "NOK":U.        
            end. 
            
            IF tt-reposit.cdn-repos:SCREEN-VALUE IN FRAME fPage3 <> "0" THEN DO:

                IF tt-reposit.cdn-repos:sensitive in frame fpage3 = YES THEN
                    ASSIGN pcAction = "ADD":U.
                ELSE
                    ASSIGN pcAction = "UPDATE":U.

                /*Campos tabela repositorio*/
                ASSIGN tt-reposit.cdn-repos      = int(tt-reposit.cdn-repos:SCREEN-VALUE IN FRAME fPage3)
                       tt-reposit.des-reposit    = tt-reposit.des-reposit:SCREEN-VALUE IN FRAME fPage3
                       tt-reposit.qtd-capac      = decimal(tt-reposit.qtd-capac:SCREEN-VALUE IN FRAME fPage3)
                       tt-reposit.cod-marca      = tt-reposit.cod-marca:SCREEN-VALUE IN FRAME fPage3
                       tt-reposit.cod-modelo     = tt-reposit.cod-modelo:SCREEN-VALUE IN FRAME fPage3
                       tt-reposit.cod-num-serie  = tt-reposit.cod-num-serie:SCREEN-VALUE IN FRAME fPage3
                       tt-reposit.cod-barras     = tt-reposit.cod-barras:SCREEN-VALUE IN FRAME fPage3
                       tt-reposit.des-obs        = tt-reposit.des-obs:SCREEN-VALUE IN FRAME fPage3
                       tt-reposit.cod-pto-coleta = tt-pto-coleta.cod-pto-coleta:SCREEN-VALUE IN FRAME fPage2
                       tt-reposit.log-livre-1    = YES. /*seta reposit como ativo*/

                EMPTY TEMP-TABLE rowErrors.

                RUN setRecord IN h-boin00984(INPUT TABLE tt-reposit).
                RUN emptyRowErrors IN h-boin00984.

                if l-findReposit = FALSE then
                    RUN validateRecord IN h-boin00984(input "CREATE":U).
                else
                    RUN validateRecord IN h-boin00984(input "UPDATE":U).

                RUN getRowErrors IN h-boin00984(output table RowErrors).
                if can-find(first rowErrors) then do:
                    {method/ShowMessage.i1}
                    {method/ShowMessage.i2}
                    RETURN "NOK":U.        
                end. 

                /*IF pcAction = "ADD":U AND tt-reposit.cdn-repos:sensitive in frame fpage3 = YES THEN
                    RUN createRecord IN h-boin00984.
                ELSE
                    RUN updateRecord IN h-boin00984.*/
                
            END.
        END.
        
        IF tt-pto-coleta.cod-pto-coleta:SCREEN-VALUE IN FRAME fPage2 = "" AND tt-reposit.cdn-repos:SCREEN-VALUE IN FRAME fPage3 <> "0" THEN DO: 
                        
            {utp/ut-liter.i Repositorio}
            ASSIGN c-msg1 = RETURN-VALUE.
            {utp/ut-liter.i Para_salvar_repositorio_‚_necess rio_cadastrar_ponto_de_coleta}
            ASSIGN c-msg2 = RETURN-VALUE.

            RUN utp/ut-msgs(INPUT "SHOW":U,
                            INPUT 54277,
                            INPUT c-msg1 + "~~" + c-msg2).

        END.
    END.
    ELSE IF AVAIL tt-propried-rural AND tt-propried-rural.log-entreg-pto-terc = TRUE THEN DO:
        /*** Verifica se foi digitado ponto coletivo, para então salvar ***/
        IF tt-produt-pto-coleta.cod-pto-coleta:SCREEN-VALUE IN FRAME fPage4 <> "" THEN DO:

            if pcAction = "ADD":U then
                RUN validateRecord IN h-boin00990(input "CREATE":U).
            else
                RUN validateRecord IN h-boin00990(input "UPDATE":U).
            RUN getRowErrors IN h-boin00990(output table RowErrors).
            if can-find(first rowErrors) then do:
                {method/ShowMessage.i1}
                {method/ShowMessage.i2}
                RETURN "NOK":U.        
            end. 
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createProdutPtoColeta wMaintenanceNoNavigation 
PROCEDURE createProdutPtoColeta :
/*:T------------------------------------------------------------------------------
  Purpose:     Cria registro na tabela produt-pto-coleta
  Parameters:  
  Notes:       produt-pto-col.log-respons = NO -> ponto coletivo
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM l-log-respons AS LOGICAL NO-UNDO.  
    
    DEFINE VARIABLE l-create   AS LOGICAL   NO-UNDO.    
    DEFINE VARIABLE c-cod-ext  AS CHARACTER NO-UNDO.    
    
    IF l-log-respons THEN DO:
        
        IF VALID-HANDLE(h-boin00966) THEN
            /* Para criacao/alteracao do ponto de coleta chama a procedure createProdutPtoColeta 
            somente como fachada para a chamada do procedure setConstraintProdutPtoColeta 
            A criação da tabela produt-pto-coleta está centralizada nos metodos de override da BOIN00966 
            */
            RUN setConstraintProdutPtoColeta IN h-boin00966(INPUT {&ttParent}.cdn-produt-rural, 
                                                            INPUT c-cod-externo:SCREEN-VALUE IN FRAME fPage2, 
                                                            INPUT YES ).

            RUN inativaPtoColetivo.
    END.
    ELSE DO:
        
        IF VALID-HANDLE(h-boin00990) THEN DO:
            RUN goToKey IN h-boin00990(INPUT {&ttParent}.cdn-produt-rural,                                   
                                       INPUT tt-produt-pto-coleta.cod-pto-coleta:SCREEN-VALUE IN FRAME fPage4,
                                       INPUT tt-propried-rural.cod-propried:SCREEN-VALUE IN FRAME fPage0).
                                    
            ASSIGN l-create = RETURN-VALUE = "NOK".
            
            EMPTY TEMP-TABLE tt-produt-pto-coleta.
            
            IF l-create THEN DO:        
                CREATE tt-produt-pto-coleta.
                ASSIGN tt-produt-pto-coleta.cdn-produt-rural = {&ttParent}.cdn-produt-rural
                       tt-produt-pto-coleta.cod-propried     = tt-propried-rural.cod-propried:SCREEN-VALUE IN FRAME fPage0
                       tt-produt-pto-coleta.cod-pto-coleta   = tt-produt-pto-coleta.cod-pto-coleta:SCREEN-VALUE IN FRAME fPage4
                       tt-produt-pto-coleta.log-respons      = NO.
            END.
            ELSE DO:
                RUN getRecord IN h-boin00990(OUTPUT TABLE tt-produt-pto-coleta).
                FIND FIRST tt-produt-pto-coleta NO-ERROR.        
            END.
            
            ASSIGN c-cod-ext = tt-produt-pto-coleta.cod-externo:SCREEN-VALUE IN FRAME fPage4
                   tt-produt-pto-coleta.log-livre-1 = TRUE.
                
            IF c-cod-ext = "" THEN
                REPEAT:
                    ASSIGN c-cod-ext = REPLACE(REPLACE(STRING(NEXT-VALUE(seq-cod-ext)), ".", ""), ",", "").
                    IF NOT CAN-FIND(FIRST produt-pto-coleta 
                                    WHERE produt-pto-coleta.cod-externo = c-cod-ext) THEN
                        LEAVE.
                END.        
            
            ASSIGN tt-produt-pto-coleta.cod-externo = c-cod-ext
                   tt-produt-pto-coleta.cod-externo:SCREEN-VALUE IN FRAME  fPage4 = tt-produt-pto-coleta.cod-externo.
            
            RUN setRecord IN h-boin00990(INPUT TABLE tt-produt-pto-coleta).
            
            RUN emptyRowErrors IN h-boin00990.        

            IF l-create THEN 
                RUN createRecord IN h-boin00990. 
            ELSE 
                RUN updateRecord IN h-boin00990.
            
            IF RETURN-VALUE = "OK":U THEN    
                RUN eliminaProdutPtoColeta IN h-boin00990(INPUT tt-produt-pto-coleta.cdn-produt-rural, 
                                                          INPUT tt-produt-pto-coleta.cod-propried, 
                                                          INPUT tt-produt-pto-coleta.cod-pto-coleta).
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPtoColeta wMaintenanceNoNavigation 
PROCEDURE findPtoColeta :
/*------------------------------------------------------------------------------
  Purpose:     Procura ponto de coleta relacionado a propriedade
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Ponto de coleta */
    IF pcAction = "UPDATE":U THEN DO WITH FRAME fPage2:
        IF NOT VALID-HANDLE(h-boin00966) THEN DO:
            RUN inbo/boin00966.p PERSISTENT SET h-boin00966.
            RUN openQueryStatic IN h-boin00966(INPUT "Main":U).
        END.
        DEFINE BUFFER bf-pto-coleta FOR pto-coleta.
        RUN emptyRowErrors IN h-boin00966.
        FIND FIRST bf-pto-coleta WHERE bf-pto-coleta.cod-propried = {&ttTable}.cod-propried NO-LOCK NO-ERROR.
        IF  AVAIL bf-pto-coleta AND 
           CAN-FIND (FIRST pto-coleta WHERE pto-coleta.cod-propried = {&ttTable}.cod-propried
                                        AND pto-coleta.cod-pto-coleta <> bf-pto-coleta.cod-pto-coleta) THEN DO:
            ASSIGN multiploPtoColeta = TRUE. /* achou mais de 1 ponto de coleta */
        END.
        RUN repositionRecord IN h-boin00966(INPUT ROWID(bf-pto-coleta)).
        EMPTY TEMP-TABLE tt-pto-coleta.
        IF RETURN-VALUE = "OK":U THEN DO:        
            RUN getRecord IN h-boin00966(OUTPUT TABLE tt-pto-coleta).
            FIND FIRST tt-pto-coleta NO-ERROR.            
            ASSIGN l-findPtoColeta = TRUE.
            RUN findRepositorio IN THIS-PROCEDURE.
        END.
        ELSE DO:
            RUN emptyRowErrors IN h-boin00966.
            CREATE tt-pto-coleta.
            ASSIGN l-findPtoColeta = FALSE.
            EMPTY TEMP-TABLE tt-reposit.
            CREATE tt-reposit.
        END.
    END.
    ELSE DO:
        EMPTY TEMP-TABLE tt-pto-coleta.
        CREATE tt-pto-coleta.
        EMPTY TEMP-TABLE tt-reposit.
        CREATE tt-reposit.
    END.

    RETURN "OK":U.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPtoColetivo wMaintenanceNoNavigation 
PROCEDURE findPtoColetivo :
/*:T------------------------------------------------------------------------------
  Purpose:     Procura ponto coletivo relacionado a propriedade
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    /* Ponto de coleta coletivo */
    IF pcAction = "UPDATE":U THEN DO WITH FRAME fPage4:
        IF NOT VALID-HANDLE(h-boin00990) THEN DO:
            RUN inbo/boin00990.p PERSISTENT SET h-boin00990.
            RUN openQueryStatic IN h-boin00990(INPUT "Main":U).
        END.
        DEFINE BUFFER bf-produt-pto-coleta FOR produt-pto-coleta.
        RUN emptyRowErrors IN h-boin00990.
        FIND FIRST bf-produt-pto-coleta WHERE bf-produt-pto-coleta.cod-propried = {&ttTable}.cod-propried 
                                          AND bf-produt-pto-coleta.cdn-produt-rural = {&ttParent}.cdn-produt-rural
                                          AND bf-produt-pto-coleta.log-respons = NO NO-LOCK NO-ERROR.

        RUN repositionRecord IN h-boin00990(INPUT ROWID(bf-produt-pto-coleta)).
		EMPTY TEMP-TABLE tt-produt-pto-coleta.
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getRecord IN h-boin00990(OUTPUT TABLE tt-produt-pto-coleta).
            FIND FIRST tt-produt-pto-coleta NO-ERROR.
            ASSIGN l-findPtoColetivo = TRUE.
        END.
        ELSE DO:
            RUN emptyRowErrors IN h-boin00990.
            CREATE tt-produt-pto-coleta.
            ASSIGN l-findPtoColetivo = FALSE.
        END.
    END.
    ELSE DO:
        EMPTY TEMP-TABLE tt-produt-pto-coleta.
        CREATE tt-produt-pto-coleta.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findRepositorio wMaintenanceNoNavigation 
PROCEDURE findRepositorio :
/*:T------------------------------------------------------------------------------
  Purpose:     Procura repositório relacionado ao ponto de coleta
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    IF pcAction = "UPDATE":U THEN DO WITH FRAME fPage3:
        IF NOT VALID-HANDLE(h-boin00984) THEN DO:
            RUN inbo/boin00984.p PERSISTENT SET h-boin00984.
            RUN openQueryStatic IN h-boin00984(INPUT "Main":U).
        END.

        DEFINE BUFFER bf-reposit FOR reposit.
        RUN emptyRowErrors IN h-boin00984.
        FIND FIRST bf-reposit WHERE bf-reposit.cod-pto-coleta = tt-pto-coleta.cod-pto-coleta NO-LOCK NO-ERROR.
        RUN repositionRecord IN h-boin00984(INPUT ROWID(bf-reposit)).
        EMPTY TEMP-TABLE tt-reposit.
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getRecord IN h-boin00984(OUTPUT TABLE tt-reposit).
            FIND FIRST tt-reposit NO-ERROR.
                        ASSIGN l-findReposit = TRUE.
        END.
        ELSE DO:
            RUN emptyRowErrors IN h-boin00984.
            CREATE tt-reposit.
            ASSIGN tt-reposit.cod-pto-coleta = tt-pto-coleta.cod-pto-coleta.
                        ASSIGN l-findReposit = FALSE.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inativaPtoColetivo wMaintenanceNoNavigation 
PROCEDURE inativaPtoColetivo :
/*:T------------------------------------------------------------------------------
  Purpose:     Deleta os pontos coletivos da propriedade
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUFFER bf-produt-pto-coleta FOR produt-pto-coleta.
    DEFINE VARIABLE h-aqapi005 AS HANDLE  NO-UNDO.
    DEFINE VARIABLE iSituacao  AS INTEGER NO-UNDO.

    IF  h-aqapi005 = ? THEN
        RUN aqp/aqapi005.p PERSISTENT SET h-aqapi005.

    FOR EACH bf-produt-pto-coleta WHERE bf-produt-pto-coleta.cod-propried = {&ttTable}.cod-propried 
                                    AND bf-produt-pto-coleta.cdn-produt-rural = {&ttParent}.cdn-produt-rural
                                    AND bf-produt-pto-coleta.log-respons = NO NO-LOCK:

        RUN piInicial IN h-aqapi005 (INPUT  "desativar":U,
                                     INPUT  "produtPtoColeta":U,
                                     INPUT  ROWID(bf-produt-pto-coleta),
                                     OUTPUT iSituacao,
                                     INPUT-OUTPUT TABLE rowErrors).

        EMPTY TEMP-TABLE tt-produt-pto-coleta.
        CREATE tt-produt-pto-coleta.
        ASSIGN tt-produt-pto-coleta.cod-pto-coleta:SCREEN-VALUE IN FRAME fpage4 = ""
               tt-produt-pto-coleta.cod-externo:SCREEN-VALUE IN FRAME fpage4 = ""
               c-desc-produt-pto-coleta:SCREEN-VALUE IN FRAME fpage4 = "".

    END.

    IF  h-aqapi005 <> ? THEN DO:
        DELETE PROCEDURE h-aqapi005.
        ASSIGN h-aqapi005 = ?.    
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
---------------------------------------------------------------------------*/

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParentTable}) OR
       {&hDBOParentTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOParentTable}:FILE-NAME <> "inbo/boin00962.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00962.p YES}
        {btb/btb008za.i2 inbo/boin00962.p '' {&hDBOParentTable}} 
    END.
    
    RUN openQueryStatic IN {&hDBOParentTable} (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR 
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "inbo/boin00980.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00980.p YES}
        {btb/btb008za.i2 inbo/boin00980.p '' {&hDBOTable}} 
    END.

    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    IF  NOT VALID-HANDLE(h-boin122) THEN
        run inbo/boin122.p persistent set h-boin122.
    RUN openQueryStatic IN h-boin122 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-boin417na) THEN DO:
       {btb/btb008za.i1 inbo/boin417na.p}
       {btb/btb008za.i2 inbo/boin417na.p '' h-boin417na} 
    END.
    RUN openQueryStatic IN h-boin417na (INPUT "Main":U).

    IF NOT VALID-HANDLE(h-boin00990) THEN DO:
       {btb/btb008za.i1 inbo/boin00990.p}
       {btb/btb008za.i2 inbo/boin00990.p '' h-boin00990} 
    END.
    RUN openQueryStatic IN h-boin00990 (INPUT "Main":U).

    IF NOT VALID-HANDLE(h-boin00977) THEN DO:
       {btb/btb008za.i1 inbo/boin00977.p}
       {btb/btb008za.i2 inbo/boin00977.p '' h-boin00977} 
    END.
    RUN openQueryStatic IN h-boin00977 (INPUT "Main":U).

    IF NOT VALID-HANDLE(h-boin00975) THEN DO:
       {btb/btb008za.i1 inbo/boin00975.p}
       {btb/btb008za.i2 inbo/boin00975.p '' h-boin00975} 
    END.
    RUN openQueryStatic IN h-boin00975 (INPUT "Main":U).
        
    IF NOT VALID-HANDLE(h-boin00966) THEN DO:
       {btb/btb008za.i1 inbo/boin00966.p}
       {btb/btb008za.i2 inbo/boin00966.p '' h-boin00966} 
    END.
    RUN openQueryStatic IN h-boin00966 (INPUT "Main":U).
        
    IF NOT VALID-HANDLE(h-boin00984) THEN DO:
       {btb/btb008za.i1 inbo/boin00984.p}
       {btb/btb008za.i2 inbo/boin00984.p '' h-boin00984} 
    END.
    RUN openQueryStatic IN h-boin00984 (INPUT "Main":U).

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

    ASSIGN {&ttTable}.cdn-produt-rural = {&ttParent}.cdn-produt-rural.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveRepositorio wMaintenanceNoNavigation 
PROCEDURE saveRepositorio :
/*:T------------------------------------------------------------------------------
  Purpose:     Procura reposit¢rio relacionado ao ponto de coleta
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE rowErrors.
    RUN setRecord IN h-boin00984(INPUT TABLE tt-reposit).
    RUN emptyRowErrors IN h-boin00984.
    
    IF l-findReposit = TRUE THEN DO:           
        RUN updateRecord IN h-boin00984.
    END.
    ELSE DO:
        RUN createRecord IN h-boin00984.
    END.
    
    IF RETURN-VALUE = "NOK":U THEN DO:
        /*Retorna os erros.*/
        RUN getRowErrors IN h-boin00984 (OUTPUT TABLE RowErrors).
        /*elimina erros internos*/
        FOR EACH RowErrors WHERE RowErrors.ErrorType = "INTERNAL":U EXCLUSIVE-LOCK:
            DELETE RowErrors.
        END.
        IF CAN-FIND (FIRST RowErrors) THEN DO:
            /** Instancia aplicativo **/
            {method/showmessage.i1}
            /** Mostra caixa com erros **/
            {method/showmessage.i2 &Modal="YES"}
            /** Limpa temp-tables de erros **/
            empty temp-table RowErrors.  
            RETURN "NOK":U.
        END.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

