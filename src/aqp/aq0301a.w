&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind            PROGRESS
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-carg-rural NO-UNDO LIKE carg-rural
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-estabelec NO-UNDO LIKE estabelec
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-pesagem NO-UNDO LIKE pesagem
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-pesagem-aux NO-UNDO LIKE pesagem
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttCargRuralAux NO-UNDO LIKE carg-rural
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
{include/i-prgvrs.i AQ0301A 2.00.00.016 } /*** "010016" 03/03/2025 09:11:43  ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0301A MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AQ0301A
&GLOBAL-DEFINE Version        2.00.00.016

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Carga

&GLOBAL-DEFINE ttTable           tt-carg-rural
&GLOBAL-DEFINE hDBOTable         h-boin00961
&GLOBAL-DEFINE DBOTable          carg-rural

&GLOBAL-DEFINE ttParent          tt-estabelec
&GLOBAL-DEFINE DBOParentTable    h-boad107na

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-estabelec.cod-estabel tt-estabelec.nome

&GLOBAL-DEFINE page1Fields       tt-carg-rural.cod-carga tt-carg-rural.dat-trans tt-carg-rural.cod-placa tt-carg-rural.cod-uf ~
                                 tt-carg-rural.cod-inter-veic tt-carg-rural.qti-comptmento tt-carg-rural.cod-transp ~
                                 tt-carg-rural.nom-motorista tt-carg-rural.val-hodom-inicial ~
                                 tt-carg-rural.val-hodom-final ~
                                 tt-carg-rural.cod-refer tt-carg-rural.cod-rota cb-item
   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER pDtTrans        AS DATE      NO-UNDO.

/* Shared Variable Definitions ---                                      */
DEFINE SHARED VARIABLE v_num-carg-aq0301a AS INTEGER NO-UNDO.
/* Local Variable Definitions ---                                       */
DEFINE VARIABLE pNumCarg        AS INTEGER NO-UNDO.
DEFINE VARIABLE pTipoConEst     AS INTEGER NO-UNDO.
DEFINE VARIABLE lPesagem        AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE i-cdn-pesagem   AS INTEGER NO-UNDO.   

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad107na   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bodi702     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad268na   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin172na   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00975   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin377na   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00965   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00981   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00961-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00983   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00982   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad00503   AS HANDLE NO-UNDO.

/** Zoom **/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brPesagens

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-pesagem

/* Definitions for BROWSE brPesagens                                    */
&Scoped-define FIELDS-IN-QUERY-brPesagens tt-pesagem.cdn-pesagem ~
tt-pesagem.val-peso-balan tt-pesagem.val-peso-aferid tt-pesagem.val-quant 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brPesagens 
&Scoped-define QUERY-STRING-brPesagens FOR EACH tt-pesagem NO-LOCK
&Scoped-define OPEN-QUERY-brPesagens OPEN QUERY brPesagens FOR EACH tt-pesagem NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brPesagens tt-pesagem
&Scoped-define FIRST-TABLE-IN-QUERY-brPesagens tt-pesagem


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brPesagens}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-estabelec.cod-estabel tt-estabelec.nome 
&Scoped-define ENABLED-TABLES tt-estabelec
&Scoped-define FIRST-ENABLED-TABLE tt-estabelec
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-estabelec.cod-estabel tt-estabelec.nome 
&Scoped-define DISPLAYED-TABLES tt-estabelec
&Scoped-define FIRST-DISPLAYED-TABLE tt-estabelec


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

DEFINE BUTTON bt-can AUTO-END-KEY 
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "Ca&n" 
     SIZE 4 BY 1.25 TOOLTIP "Cancelar".

DEFINE BUTTON bt-sav 
     IMAGE-UP FILE "image/im-sav.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sav.bmp":U
     LABEL "&Sav" 
     SIZE 4 BY 1.25 TOOLTIP "Salvar".

DEFINE VARIABLE cb-item AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS COMBO-BOX INNER-LINES 5     
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-refer AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-rota AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-transp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY .88 NO-UNDO.

DEFINE VARIABLE d-data-time AS DATETIME FORMAT "99/99/9999 HH:MM:SS":U 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

DEFINE VARIABLE d-val-hodom-total AS DECIMAL FORMAT ">,>>>,>>9.999":U INITIAL 0 
     LABEL "Km Rodados" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-peso AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Peso" 
     VIEW-AS FILL-IN 
     SIZE 15.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 62 BY 6.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 21 BY 6.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brPesagens FOR 
      tt-pesagem SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brPesagens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brPesagens wMaintenanceNoNavigation _STRUCTURED
  QUERY brPesagens NO-LOCK DISPLAY
      tt-pesagem.cdn-pesagem COLUMN-LABEL "Seq" FORMAT ">>>,>>9":U
      tt-pesagem.val-peso-balan COLUMN-LABEL "Pesagem" FORMAT ">>>>,>>>,>>9.9999":U
      tt-pesagem.val-peso-aferid COLUMN-LABEL "Peso" FORMAT ">>>>,>>>,>>9.9999":U
      tt-pesagem.val-quant COLUMN-LABEL "Quantidade" FORMAT ">>>>,>>>,>>9.9999":U
            WIDTH 21.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 59 BY 4.96
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-estabelec.cod-estabel AT ROW 1.75 COL 16 COLON-ALIGNED WIDGET-ID 54
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-estabelec.nome AT ROW 1.75 COL 26.14 COLON-ALIGNED NO-LABEL WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 50 BY .88
     btOK AT ROW 24.25 COL 2
     btSave AT ROW 24.25 COL 13
     btCancel AT ROW 24.25 COL 24
     btHelp AT ROW 24.25 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 24 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 25.04
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tt-carg-rural.num-carg AT ROW 1.5 COL 16 COLON-ALIGNED WIDGET-ID 72
          LABEL "Carga"
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     tt-carg-rural.cod-carga AT ROW 1.5 COL 44 COLON-ALIGNED WIDGET-ID 56
          LABEL "C¢digo"
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     tt-carg-rural.dat-trans AT ROW 2.5 COL 16 COLON-ALIGNED WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     tt-carg-rural.cod-placa AT ROW 3.5 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     tt-carg-rural.cod-uf AT ROW 3.5 COL 44 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     tt-carg-rural.cod-inter-veic AT ROW 4.5 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     tt-carg-rural.qti-comptmento AT ROW 4.5 COL 44 COLON-ALIGNED WIDGET-ID 74
          VIEW-AS FILL-IN 
          SIZE 6.14 BY .88
     tt-carg-rural.cod-transp AT ROW 5.5 COL 16 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-desc-transp AT ROW 5.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 78
     tt-carg-rural.nom-motorista AT ROW 6.5 COL 16 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 53 BY .88
     tt-carg-rural.val-hodom-inicial AT ROW 7.5 COL 16 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     tt-carg-rural.val-hodom-final AT ROW 7.5 COL 70 RIGHT-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     d-val-hodom-total AT ROW 8.5 COL 16 COLON-ALIGNED WIDGET-ID 76
     cb-item AT ROW 9.5 COL 16 COLON-ALIGNED
     c-desc-item AT ROW 9.5 COL 34.14 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     tt-carg-rural.cod-refer AT ROW 10.5 COL 16 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-desc-refer AT ROW 10.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 80
     tt-carg-rural.cod-rota AT ROW 11.5 COL 16 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-desc-rota AT ROW 11.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     brPesagens AT ROW 13.63 COL 3.29 WIDGET-ID 200
     fi-peso AT ROW 13.67 COL 67 COLON-ALIGNED WIDGET-ID 90
     bt-can AT ROW 14.67 COL 76.14 WIDGET-ID 28
     bt-sav AT ROW 14.67 COL 80.14 WIDGET-ID 30
     d-data-time AT ROW 1.5 COL 66 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     "Aferi‡Æo" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 12.75 COL 36 WIDGET-ID 86
     RECT-1 AT ROW 13 COL 1 WIDGET-ID 84
     RECT-2 AT ROW 13 COL 64 WIDGET-ID 88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.71
         SIZE 84.43 BY 18.79
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-carg-rural T "?" NO-UNDO movind carg-rural
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
      TABLE: tt-estabelec T "?" NO-UNDO mgind estabelec
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
      TABLE: tt-pesagem T "?" NO-UNDO movind pesagem
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
      TABLE: tt-pesagem-aux T "?" NO-UNDO movind pesagem
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttCargRuralAux T "?" NO-UNDO movind carg-rural
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
         HEIGHT             = 25.04
         WIDTH              = 90
         MAX-HEIGHT         = 26.92
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 26.92
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brPesagens c-desc-rota fPage1 */
/* SETTINGS FOR BUTTON bt-can IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-data-time IN FRAME fPage1
   NO-ENABLE                                                            */
ASSIGN 
       d-data-time:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN d-val-hodom-total IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-carg-rural.num-carg IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-carg-rural.val-hodom-final IN FRAME fPage1
   ALIGN-R                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brPesagens
/* Query rebuild information for BROWSE brPesagens
     _TblList          = "Temp-Tables.tt-pesagem"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-pesagem.cdn-pesagem
"tt-pesagem.cdn-pesagem" "Seq" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-pesagem.val-peso-balan
"tt-pesagem.val-peso-balan" "Pesagem" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-pesagem.val-peso-aferid
"tt-pesagem.val-peso-aferid" "Peso" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-pesagem.val-quant
"tt-pesagem.val-quant" "Quantidade" ? "decimal" ? ? ? ? ? ? no ? no no "21.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brPesagens */
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-can
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-can wMaintenanceNoNavigation
ON CHOOSE OF bt-can IN FRAME fPage1 /* Can */
DO:
    IF AVAIL tt-pesagem THEN DO:
        ASSIGN tt-pesagem.val-peso-balan = 0
               fi-peso = 0.
               
        ASSIGN tt-carg-rural.qtd-peso-brut  = 0
               tt-carg-rural.qtd-peso-tara  = 0.    
        DISP fi-peso WITH FRAME fPage1.
        {&OPEN-QUERY-brPesagens}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sav
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sav wMaintenanceNoNavigation
ON CHOOSE OF bt-sav IN FRAME fPage1 /* Sav */
DO:
    DEFINE VARIABLE p-cdn-pesagem AS INTEGER NO-UNDO.

    IF INPUT FRAME fPage1 fi-peso > 0 THEN DO:
        RUN getCreateSequence IN h-boin00981 (INPUT INPUT FRAME fPage1 tt-carg-rural.num-carg,
                                              OUTPUT p-cdn-pesagem).

        EMPTY TEMP-TABLE tt-pesagem NO-ERROR.

        CREATE tt-pesagem.
        ASSIGN tt-pesagem.num-carg       = INPUT FRAME fPage1 tt-carg-rural.num-carg
               tt-pesagem.cdn-pesagem    = p-cdn-pesagem
               tt-pesagem.val-peso-balan = INPUT FRAME fPage1 fi-peso.
               
        ASSIGN tt-carg-rural.qtd-peso-brut  = tt-pesagem.val-peso-balan
               tt-carg-rural.qtd-peso-tara  = tt-pesagem.val-peso-balan.
                
        {&OPEN-QUERY-brPesagens}
   END.                         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:   
    IF pcAction = "Add":U  THEN DO:
        RUN deletePesagem IN h-boin00981 (INPUT tt-carg-rural.num-carg:SCREEN-VALUE IN FRAME fPage1).
        RUN deleteLiberCarg IN h-boin00982 (INPUT tt-carg-rural.num-carg:SCREEN-VALUE IN FRAME fPage1). 
    END.   
        
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
    IF RETURN-VALUE = "OK":U THEN DO:
        EMPTY TEMP-TABLE tt-pesagem NO-ERROR.
        {&OPEN-QUERY-brPesagens}
        ASSIGN fi-peso = 0.    
        DISP fi-peso WITH FRAME fPage1.
    END.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME cb-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-item wMaintenanceNoNavigation
ON VALUE-CHANGED OF cb-item IN FRAME fPage1 /* Item */
DO: 
    DEFINE VARIABLE pDescItem    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE p-tip-aferic AS INTEGER NO-UNDO.
    
    RUN goToKey IN h-boin172na (INPUT SELF:SCREEN-VALUE IN FRAME fPage1) NO-ERROR.    
    IF RETURN-VALUE = "OK":U THEN DO:
    
        RUN findDescItem IN h-boin00983 (INPUT SELF:SCREEN-VALUE IN FRAME fPage1, OUTPUT pDescItem) NO-ERROR. 

        ASSIGN c-desc-item:SCREEN-VALUE IN FRAME fPage1 = pDescItem. 

        IF pcAction = "Add":U THEN DO:
            RUN goToKey IN h-boin00983 (INPUT SELF:SCREEN-VALUE IN FRAME fPage1,
                                        INPUT tt-estabelec.cod-estabel) NO-ERROR.
                                        
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN getIntField IN h-boin00983 (INPUT "idi-tip-aferic":U, OUTPUT p-tip-aferic) NO-ERROR. 

                ASSIGN brPesagens:SENSITIVE IN FRAME fPage1 = p-tip-aferic = 1
                       bt-can:SENSITIVE     IN FRAME fPage1 = p-tip-aferic = 1
                       bt-sav:SENSITIVE     IN FRAME fPage1 = p-tip-aferic = 1
                       fi-peso:SENSITIVE    IN FRAME fPage1 = p-tip-aferic = 1.
            END.
        END.  
        
        RUN getIntField IN h-boin172na (INPUT "tipo-con-est":U, OUTPUT pTipoConEst) NO-ERROR.
        
        IF pTipoConEst = 4 THEN DO:
            ASSIGN tt-carg-rural.cod-refer:SENSITIVE IN FRAME fPage1 = YES.
            APPLY "ENTRY" TO tt-carg-rural.cod-refer IN FRAME fPage1.
            RETURN NO-APPLY.
        END.    
        ELSE DO: 
            ASSIGN tt-carg-rural.cod-refer:SCREEN-VALUE IN FRAME fPage1 = "".            
            ASSIGN tt-carg-rural.cod-refer:SENSITIVE IN FRAME fPage1 = NO.           
        END. 
       
    END.
    ELSE DO:      
       ASSIGN c-desc-item:SCREEN-VALUE IN FRAME fPage1 = ""
              tt-carg-rural.cod-refer:SCREEN-VALUE IN FRAME fPage1 = "".
       ASSIGN tt-carg-rural.cod-refer:SENSITIVE IN FRAME fPage1 = NO.                       
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-carg-rural.cod-placa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-carg-rural.cod-placa wMaintenanceNoNavigation
ON LEAVE OF tt-carg-rural.cod-placa IN FRAME fPage1 /* Placa */
DO:
    DEFINE VARIABLE c-cod-inter-veic AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-cod-transp     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-nome     AS CHARACTER NO-UNDO. 
    DEFINE VARIABLE c-cod-uf         AS CHARACTER NO-UNDO.


    RUN setConstraintByCodPlaca IN h-boad00503(INPUT tt-carg-rural.cod-placa:SCREEN-VALUE IN FRAME fPage1).
    RUN openQueryStatic IN h-boad00503 (INPUT "ByCodPlaca":U) NO-ERROR.
    
    RUN getCharField IN h-boad00503 (INPUT "cod-inter-veic":U, OUTPUT c-cod-inter-veic) NO-ERROR. 
    RUN getCharField IN h-boad00503 (INPUT "cod-uf":U,         OUTPUT c-cod-uf) NO-ERROR. 
    RUN getIntField  IN h-boad00503 (INPUT "cod-transp":U,     OUTPUT c-cod-transp) NO-ERROR.

    RUN goToKey      IN h-boad268na (INPUT c-cod-transp).
    IF RETURN-VALUE = 'OK':U THEN 
        RUN getCharField IN h-boad268na (INPUT 'nome':U, OUTPUT c-nome).

    ASSIGN tt-carg-rural.cod-uf:SCREEN-VALUE             IN FRAME fPage1 = c-cod-uf
           tt-carg-rural.cod-transp:SCREEN-VALUE         IN FRAME fPage1 = STRING(c-cod-transp)
           c-desc-transp:SCREEN-VALUE                    IN FRAME fPage1 = c-nome
           tt-carg-rural.cod-inter-veic:SCREEN-VALUE     IN FRAME fPage1 = c-cod-inter-veic.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-carg-rural.cod-placa wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-carg-rural.cod-placa IN FRAME fPage1 /* Placa */
OR F5 OF tt-carg-rural.cod-placa IN FRAME fPage1
DO:
    {method/zoomfields.i &ProgramZoom="adzoom/z01ad00503.w"
                         &FieldZoom1="cod-placa"
                         &FieldScreen1="tt-carg-rural.cod-placa"
                         &Frame1="fPage1"                          
                         &FieldZoom2="cod-inter-veic"
                         &FieldScreen2="tt-carg-rural.cod-inter-veic"
                         &Frame2="fPage1"
                         &FieldZoom3="cod-placa"
                         &FieldScreen3="tt-carg-rural.cod-placa"
                         &Frame3="fPage1"                         
                         &EnableImplant="YES"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-carg-rural.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-carg-rural.cod-refer wMaintenanceNoNavigation
ON LEAVE OF tt-carg-rural.cod-refer IN FRAME fPage1 /* Referˆncia */
DO:            
     {method/referencefields.i 
          &HandleDBOLeave="h-boin377na"         
          &KeyValue1="SELF:SCREEN-VALUE IN FRAME fPage1"
          &FieldName1="descricao"
          &FieldScreen1="c-desc-refer"
          &Frame1="fPage1"}        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-carg-rural.cod-refer wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-carg-rural.cod-refer IN FRAME fPage1 /* Referˆncia */
OR F5 OF tt-carg-rural.cod-refer IN FRAME fPage1
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                       &campo=tt-carg-rural.cod-refer
                       &campozoom=cod-refer
                       &campo2=c-desc-refer
                       &campozoom2=descricao
                       &parametros="run pi-seta-inicial in wh-pesquisa(cb-item:screen-value in frame fPage1)."}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-carg-rural.cod-rota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-carg-rural.cod-rota wMaintenanceNoNavigation
ON LEAVE OF tt-carg-rural.cod-rota IN FRAME fPage1 /* Rota */
DO:         
    DEFINE VARIABLE pDescRota AS CHARACTER NO-UNDO.
     
    RUN goToKey IN h-boin00975 (INPUT tt-carg-rural.cod-rota:SCREEN-VALUE IN FRAME fPage1) NO-ERROR.

    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getCharField IN h-boin00975 (INPUT "des-rota":U, OUTPUT pDescRota) NO-ERROR. 

        ASSIGN c-desc-rota:SCREEN-VALUE IN FRAME fPage1 = pDescRota.
    END.
    ELSE ASSIGN c-desc-rota:SCREEN-VALUE IN FRAME fPage1 = "".   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-carg-rural.cod-rota wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-carg-rural.cod-rota IN FRAME fPage1 /* Rota */
OR F5 OF tt-carg-rural.cod-rota IN FRAME fPage1
DO:
    {method/zoomfields.i &ProgramZoom="inzoom/z01in00975.w"
                         &FieldZoom1="cod-rota"
                         &FieldScreen1="tt-carg-rural.cod-rota"
                         &Frame1="fPage1"  
                         &FieldZoom2="des-rota"
                         &FieldScreen2="c-desc-rota"
                         &Frame2="fPage1"                        
                         &EnableImplant="YES"}  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-carg-rural.qti-comptmento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-carg-rural.qti-comptmento wMaintenanceNoNavigation
ON LEAVE OF tt-carg-rural.qti-comptmento IN FRAME fPage1 /* Qtd Compartimento */
DO:
    IF pcAction = "Add":U AND tt-carg-rural.qti-comptmento:SCREEN-VALUE IN FRAME fPage1 = "0" THEN
        ASSIGN tt-carg-rural.qti-comptmento:SCREEN-VALUE IN FRAME fPage1 = "1".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-carg-rural.val-hodom-final
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-carg-rural.val-hodom-final wMaintenanceNoNavigation
ON LEAVE OF tt-carg-rural.val-hodom-final IN FRAME fPage1 /* Valor Hod“metro Final */
DO:
   IF DECIMAL(tt-carg-rural.val-hodom-final:SCREEN-VALUE IN FRAME fPage1) <
      DECIMAL(tt-carg-rural.val-hodom-inicial:SCREEN-VALUE IN FRAME fPage1) THEN DO:
        ASSIGN d-val-hodom-total:SCREEN-VALUE IN FRAME fPage1 = '0'.
   END.
   ELSE 
       ASSIGN d-val-hodom-total:SCREEN-VALUE IN FRAME fPage1 = STRING(DECIMAL(tt-carg-rural.val-hodom-final:SCREEN-VALUE IN FRAME fPage1) -
                                                                      DECIMAL(tt-carg-rural.val-hodom-inicial:SCREEN-VALUE IN FRAME fPage1)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brPesagens
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-carg-rural.cod-placa:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-carg-rural.cod-inter-veic:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-carg-rural.cod-transp:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-carg-rural.cod-refer:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-carg-rural.cod-rota:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.

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

    IF VALID-HANDLE(h-boad107na) AND
        h-boad107na:TYPE = "PROCEDURE":U AND
        h-boad107na:FILE-NAME = "adbo/boad107na.p":U THEN DO:
        DELETE PROCEDURE h-boad107na.
        ASSIGN h-boad107na = ?.
    END.

    IF VALID-HANDLE({&hDBOTable}) AND
        {&hDBOTable}:TYPE = "PROCEDURE":U AND
        {&hDBOTable}:FILE-NAME = "inbo/boin00961.p":U THEN DO:
        DELETE PROCEDURE {&hDBOTable}.
        ASSIGN {&hDBOTable} = ?.
    END.

    IF VALID-HANDLE(h-bodi702) AND
        h-bodi702:TYPE = "PROCEDURE":U AND
        h-bodi702:FILE-NAME = "dibo/bodi702.p":U THEN DO:
        DELETE PROCEDURE h-bodi702.
        ASSIGN h-bodi702 = ?.
    END.

    IF VALID-HANDLE(h-boad268na) AND
        h-boad268na:TYPE = "PROCEDURE":U AND
        h-boad268na:FILE-NAME = "adbo/boad268na.p":U THEN DO:
        DELETE PROCEDURE h-boad268na.
        ASSIGN h-boad268na = ?.
    END.

    IF VALID-HANDLE(h-boin172na) AND
        h-boin172na:TYPE = "PROCEDURE":U AND
        h-boin172na:FILE-NAME = "inbo/boin172na.p":U THEN DO:
        DELETE PROCEDURE h-boin172na.
        ASSIGN h-boin172na = ?.
    END.

    IF VALID-HANDLE(h-boin377na) AND
        h-boin377na:TYPE = "PROCEDURE":U AND
        h-boin377na:FILE-NAME = "inbo/boin377na.p":U THEN DO:
        DELETE PROCEDURE h-boin377na.
        ASSIGN h-boin377na = ?.
    END.

    IF VALID-HANDLE(h-boin00975) AND
        h-boin00975:TYPE = "PROCEDURE":U AND
        h-boin00975:FILE-NAME = "inbo/boin00975.p":U THEN DO:
        DELETE PROCEDURE h-boin00975.
        ASSIGN h-boin00975 = ?.
    END.

    IF VALID-HANDLE(h-boin00965) AND
        h-boin00965:TYPE = "PROCEDURE":U AND
        h-boin00965:FILE-NAME = "inbo/boin00965.p":U THEN DO:
        DELETE PROCEDURE h-boin00965.
        ASSIGN h-boin00965 = ?.
    END.

    IF VALID-HANDLE(h-boin00981) AND
        h-boin00981:TYPE = "PROCEDURE":U AND
        h-boin00981:FILE-NAME = "inbo/boin00981.p":U THEN DO:
        DELETE PROCEDURE h-boin00981.
        ASSIGN h-boin00981 = ?.
    END.

    IF VALID-HANDLE(h-boin00961-2) AND
        h-boin00961-2:TYPE = "PROCEDURE":U AND
        h-boin00961-2:FILE-NAME = "inbo/boin00961.p":U THEN DO:
        DELETE PROCEDURE h-boin00961-2.
        ASSIGN h-boin00961-2 = ?.
    END.

    IF VALID-HANDLE(h-boin00983) AND
        h-boin00983:TYPE = "PROCEDURE":U AND
        h-boin00983:FILE-NAME = "inbo/boin00983.p":U THEN DO:
        DELETE PROCEDURE h-boin00983.
        ASSIGN h-boin00983 = ?.
    END.

    IF VALID-HANDLE(h-boin00982) AND
        h-boin00982:TYPE = "PROCEDURE":U AND
        h-boin00982:FILE-NAME = "inbo/boin00982.p":U THEN DO:
        DELETE PROCEDURE h-boin00982.
        ASSIGN h-boin00982 = ?.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE pDescItem  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-list     AS CHARACTER   NO-UNDO.
    
    ASSIGN c-desc-transp:SCREEN-VALUE     IN FRAME fPage1 = ""
           d-val-hodom-total:SCREEN-VALUE IN FRAME fPage1 = ""
           c-desc-item:SCREEN-VALUE       IN FRAME fPage1 = ""
           c-desc-refer:SCREEN-VALUE      IN FRAME fPage1 = ""
           c-desc-rota:SCREEN-VALUE       IN FRAME fPage1 = "".
           
    RUN getListItems IN h-boin00983(INPUT tt-estabelec.cod-estabel, OUTPUT c-list).   
    IF c-list <> "" AND (cb-item:SCREEN-VALUE IN FRAME fPage1 = "" OR cb-item:SCREEN-VALUE IN FRAME fPage1 = ?)THEN DO:        
        ASSIGN cb-item:LIST-ITEMS IN FRAME fPage1   = c-list
               cb-item:SCREEN-VALUE IN FRAME fPage1 = ENTRY (1,c-list).
               
        APPLY 'VALUE-CHANGED':U TO cb-item IN FRAME fPage1. 
    END.
    
    IF pcAction = "Add":U THEN DO:
        RUN getCreateSequence IN {&hDBOTable} (OUTPUT pNumCarg).  
    
        ASSIGN tt-carg-rural.num-carg:SCREEN-VALUE  IN FRAME fPage1 = STRING(pNumCarg)
               tt-carg-rural.dat-trans:SCREEN-VALUE IN FRAME fPage1 = STRING(pDtTrans)
               tt-carg-rural.cod-carga:SCREEN-VALUE IN FRAME fPage1 = STRING(pNumCarg).
               
        IF tt-carg-rural.qti-comptmento:SCREEN-VALUE IN FRAME fPage1 = "0" THEN
            ASSIGN tt-carg-rural.qti-comptmento:SCREEN-VALUE IN FRAME fPage1 = "1".    
    END.   
    ELSE DO:
        IF AVAILABLE tt-carg-rural THEN 
            ASSIGN tt-carg-rural.num-carg:SCREEN-VALUE IN FRAME fPage1 = STRING(tt-carg-rural.num-carg).
            
        APPLY "LEAVE" TO tt-carg-rural.val-hodom-final IN FRAME fPage1.       
        APPLY "LEAVE" TO tt-carg-rural.cod-rota        IN FRAME fPage1.    
    
        ASSIGN cb-item:SCREEN-VALUE IN FRAME fPage1 = tt-carg-rural.it-codigo.
    
    END.
    
    APPLY 'VALUE-CHANGED':U TO cb-item IN FRAME fPage1. 
    
    
    
    IF pTipoConEst = 4 THEN /* REFERENCIA*/
        DISP tt-carg-rural.cod-refer WITH FRAME fPage1.
                             
    ASSIGN d-data-time:SCREEN-VALUE IN FRAME fPage1 = STRING(DATETIME(TODAY , MTIME)).  
    
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
    ASSIGN tt-carg-rural.cod-refer:SENSITIVE      IN FRAME fPage1 = pTipoConEst = 4
           pTipoConEst                                            = 0
           tt-carg-rural.cod-uf:SENSITIVE         IN FRAME fPage1 = NO
           tt-carg-rural.cod-transp:SENSITIVE     IN FRAME fPage1 = NO
           tt-carg-rural.cod-inter-veic:SENSITIVE IN FRAME fPage1 = NO
           c-desc-transp:SENSITIVE                IN FRAME fPage1 = NO
           tt-carg-rural.qti-comptmento:SENSITIVE IN FRAME fPage1 = pcAction = "Add":U
           cb-item:SENSITIVE                      IN FRAME fPage1 = pcAction = "Add":U.          
           
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

    RUN openQueriesPesagens IN THIS-PROCEDURE.
    
    APPLY "LEAVE":U TO tt-carg-rural.cod-placa IN FRAME fPage1.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayFields wMaintenanceNoNavigation 
PROCEDURE beforeDisplayFields :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    {utp/ut-liter.i Carga * R }
    ASSIGN tt-carg-rural.num-carg:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i UF * R }
    ASSIGN tt-carg-rural.cod-uf:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Veiculo * R }
    ASSIGN tt-carg-rural.cod-inter-veic:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Compartimentos * R }
    ASSIGN tt-carg-rural.qti-comptmento:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).   
    {utp/ut-liter.i Transportador * R }
    ASSIGN tt-carg-rural.cod-transp:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Motorista * R }
    ASSIGN tt-carg-rural.nom-motorista:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i KM_Inicial * R }
    ASSIGN tt-carg-rural.val-hodom-inicial:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i KM_Final * R }
    ASSIGN tt-carg-rural.val-hodom-final:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).
    
    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenanceNoNavigation 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    ASSIGN tt-carg-rural.dat-entr  = TODAY
           tt-carg-rural.hra-entr  = STRING(TIME,"HH:MM:SS")
           tt-carg-rural.it-codigo = cb-item:SCREEN-VALUE IN FRAME fPage1
           tt-carg-rural.cod-usuario = c-seg-usuario.
           
    IF pcAction = 'ADD' THEN
        ASSIGN v_num-carg-aq0301a = int(tt-carg-rural.num-carg:SCREEN-VALUE  IN FRAME fPage1).
        
    RETURN "OK".
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
    IF NOT VALID-HANDLE(h-boad107na) OR
        h-boad107na:TYPE <> "PROCEDURE":U OR
        h-boad107na:FILE-NAME <> "adbo/boad107na.p":U THEN DO:
            
        {btb/btb008za.i1 adbo/boad107na.p YES}
        {btb/btb008za.i2 adbo/boad107na.p '' h-boad107na}                       
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR 
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "inbo/boin00961.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00961.p YES}
        {btb/btb008za.i2 inbo/boin00961.p '' {&hDBOTable}} 
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

        /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-bodi702) OR 
        h-bodi702:TYPE <> "PROCEDURE":U OR
        h-bodi702:FILE-NAME <> "dibo/bodi702.p":U THEN DO:

        {btb/btb008za.i1 dibo/bodi702.p YES}
        {btb/btb008za.i2 dibo/bodi702.p '' h-bodi702} 
    END.
    
    RUN openQueryStatic IN h-bodi702 (INPUT "Main":U) NO-ERROR.

        /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boad268na) OR 
        h-boad268na:TYPE <> "PROCEDURE":U OR
        h-boad268na:FILE-NAME <> "adbo/boad268na.p":U THEN DO:

        {btb/btb008za.i1 adbo/boad268na.p YES}
        {btb/btb008za.i2 adbo/boad268na.p '' h-boad268na} 
    END.
    
    RUN openQueryStatic IN h-boad268na (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin172na) OR 
        h-boin172na:TYPE <> "PROCEDURE":U OR
        h-boin172na:FILE-NAME <> "inbo/boin172na.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin172na.p YES}
        {btb/btb008za.i2 inbo/boin172na.p '' h-boin172na} 
    END.
    
    RUN openQueryStatic IN h-boin172na (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin377na) OR 
        h-boin377na:TYPE <> "PROCEDURE":U OR
        h-boin377na:FILE-NAME <> "inbo/boin377na.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin377na.p YES}
        {btb/btb008za.i2 inbo/boin377na.p '' h-boin377na} 
    END.
    
    RUN openQueryStatic IN h-boin377na (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00975) OR 
        h-boin00975:TYPE <> "PROCEDURE":U OR
        h-boin00975:FILE-NAME <> "inbo/boin00975.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00975.p YES}
        {btb/btb008za.i2 inbo/boin00975.p '' h-boin00975} 
    END.
    
    RUN openQueryStatic IN h-boin00975 (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00965) OR 
        h-boin00965:TYPE <> "PROCEDURE":U OR
        h-boin00965:FILE-NAME <> "inbo/boin00965.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00965.p YES}
        {btb/btb008za.i2 inbo/boin00965.p ''  h-boin00965} 
    END.
    
    RUN openQueryStatic IN h-boin00965 (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00981) OR 
        h-boin00981:TYPE <> "PROCEDURE":U OR
        h-boin00981:FILE-NAME <> "inbo/boin00981.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00981.p YES}
        {btb/btb008za.i2 inbo/boin00981.p ''  h-boin00981} 
    END.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00961-2) OR 
        h-boin00961-2:TYPE <> "PROCEDURE":U OR
        h-boin00961-2:FILE-NAME <> "inbo/boin00961.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00961.p YES}
        {btb/btb008za.i2 inbo/boin00961.p '' h-boin00961-2} 
    END.
    
    RUN openQueryStatic IN h-boin00961-2 (INPUT "Main":U) NO-ERROR.

        /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00983) OR 
        h-boin00983:TYPE <> "PROCEDURE":U OR
        h-boin00983:FILE-NAME <> "inbo/boin00983.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00983.p YES}
        {btb/btb008za.i2 inbo/boin00983.p ''  h-boin00983} 
    END.
    
    RUN openQueryStatic IN h-boin00983 (INPUT "Main":U) NO-ERROR.

        /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00982) OR 
        h-boin00982:TYPE <> "PROCEDURE":U OR
        h-boin00982:FILE-NAME <> "inbo/boin00982.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00982.p YES}
        {btb/btb008za.i2 inbo/boin00982.p ''  h-boin00982} 
    END.
    
    RUN openQueryStatic IN h-boin00982 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-boad00503) OR 
        h-boad00503:TYPE <> "PROCEDURE":U OR
        h-boad00503:FILE-NAME <> "adbo/boad00503.p":U THEN DO:

        {btb/btb008za.i1 adbo/boad00503.p YES}
        {btb/btb008za.i2 adbo/boad00503.p ''  h-boad00503} 
    END.
    
    RUN openQueryStatic IN h-boad00503 (INPUT "Main":U) NO-ERROR.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesPesagens wMaintenanceNoNavigation 
PROCEDURE openQueriesPesagens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iRowsReturned AS INTEGER NO-UNDO.

    RUN setConstraintNumCarg IN h-boin00981 (INPUT INTEGER(tt-carg-rural.num-carg:SCREEN-VALUE IN FRAME fPage1), 
                                             INPUT INTEGER(tt-carg-rural.num-carg:SCREEN-VALUE IN FRAME fPage1)).   

    RUN openQueryStatic IN h-boin00981 (INPUT "NumCarg":U).
    
    RUN getBatchRecords IN h-boin00981 (INPUT ?,
                                        INPUT NO,
                                        INPUT 9999,
                                        OUTPUT iRowsReturned,
                                        OUTPUT TABLE tt-pesagem).
                                        
    /*--- Abre a query associada ao browse da p gina {&PageNumber} ---*/
    {&OPEN-QUERY-brPesagens}

    APPLY "VALUE-CHANGED":U TO BROWSE brPesagens.

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

    ASSIGN tt-carg-rural.num-carg       = pNumCarg
           tt-carg-rural.cod-estabel    = tt-estabelec.cod-estabel
           tt-carg-rural.cdn-sit        = 1.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

