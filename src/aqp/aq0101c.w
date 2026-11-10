&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-config-peso-qualid NO-UNDO LIKE config-peso-qualid
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-param-aquis-rural NO-UNDO LIKE param-aquis-rural
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-peso-period NO-UNDO LIKE peso-period
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-peso-period-aux NO-UNDO LIKE peso-period
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0101C 2.00.00.010 } /*** 010010 ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0101C MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AQ0101C
&GLOBAL-DEFINE Version        2.00.00.010

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-config-peso-qualid
&GLOBAL-DEFINE hDBOTable         h-boin01020
&GLOBAL-DEFINE DBOTable          tt-config-peso-qualid

&GLOBAL-DEFINE ttTable1          tt-peso-period
&GLOBAL-DEFINE hDBOTable1        h-boin01021
&GLOBAL-DEFINE DBOTable1         tt-peso-period

&GLOBAL-DEFINE ttParent          tt-param-aquis-rural
&GLOBAL-DEFINE DBOParentTable    h-boin00968

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields cb-item tt-config-peso-qualid.cod-exame~
                           tt-config-peso-qualid.cod-comp c-periodo-ini c-periodo-fim~
                           tt-config-peso-qualid.qtd-period      
&GLOBAL-DEFINE page0ParentFields tt-param-aquis-rural.cod-estabel
&GLOBAL-DEFINE page1Fields l-ativa-facelift      
&GLOBAL-DEFINE page0Widgets bt-periodos
&GLOBAL-DEFINE page1Widgets br-peso-period

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE  NO-UNDO. /* config-peso-qualid */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE  NO-UNDO. /* peso-period        */
DEFINE VARIABLE h-boin172na   AS HANDLE  NO-UNDO. /* item               */
DEFINE VARIABLE h-boin00983   AS HANDLE  NO-UNDO. /* item-estab-rural   */
DEFINE VARIABLE h-boad107na   AS HANDLE  NO-UNDO. /* estabelec          */
DEFINE VARIABLE h-boin114     AS HANDLE NO-UNDO.  /* exame              */
DEFINE VARIABLE h-boin637     AS HANDLE NO-UNDO.  /* it-comp-exame      */

/* Zoom Smart */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.

DEFINE VARIABLE i-qtd-period  AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-peso-period

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-peso-period

/* Definitions for BROWSE br-peso-period                                */
&Scoped-define FIELDS-IN-QUERY-br-peso-period ~
fnPeriodoDes(tt-peso-period.cdn-period) tt-peso-period.val-peso 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-peso-period ~
tt-peso-period.val-peso 
&Scoped-define ENABLED-TABLES-IN-QUERY-br-peso-period tt-peso-period
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-peso-period tt-peso-period
&Scoped-define QUERY-STRING-br-peso-period FOR EACH tt-peso-period NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-peso-period OPEN QUERY br-peso-period FOR EACH tt-peso-period NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-peso-period tt-peso-period
&Scoped-define FIRST-TABLE-IN-QUERY-br-peso-period tt-peso-period


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-peso-period}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-config-peso-qualid.cod-exame ~
tt-config-peso-qualid.cod-comp tt-config-peso-qualid.qtd-period 
&Scoped-define ENABLED-TABLES tt-config-peso-qualid
&Scoped-define FIRST-ENABLED-TABLE tt-config-peso-qualid
&Scoped-Define ENABLED-OBJECTS cb-item c-des-comp-exame c-periodo-ini ~
c-periodo-fim bt-periodos btOK btSave btCancel btHelp rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-param-aquis-rural.cod-estabel ~
tt-config-peso-qualid.cod-exame tt-config-peso-qualid.cod-comp ~
tt-config-peso-qualid.qtd-period 
&Scoped-define DISPLAYED-TABLES tt-param-aquis-rural tt-config-peso-qualid
&Scoped-define FIRST-DISPLAYED-TABLE tt-param-aquis-rural
&Scoped-define SECOND-DISPLAYED-TABLE tt-config-peso-qualid
&Scoped-Define DISPLAYED-OBJECTS cb-item c-desc-estabel c-desc-item ~
c-des-exame c-des-comp-exame c-periodo-ini c-periodo-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPeriodoDes wMaintenanceNoNavigation 
FUNCTION fnPeriodoDes RETURNS CHARACTER
  ( p-cdn-period AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-periodos 
     IMAGE-UP FILE "image\im-chck1":U
     LABEL "" 
     SIZE 4 BY 1.

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

DEFINE VARIABLE cb-item AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE c-des-comp-exame AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-exame AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-periodo-fim AS CHARACTER FORMAT "99/9999":U INITIAL "129999" 
     LABEL "AtÇ" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-periodo-ini AS CHARACTER FORMAT "99/9999":U 
     LABEL "V†lido de" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE l-ativa-facelift AS CHARACTER FORMAT "X(1)":U 
      VIEW-AS TEXT 
     SIZE 1 BY .67 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-peso-period FOR 
      tt-peso-period SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-peso-period
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-peso-period wMaintenanceNoNavigation _STRUCTURED
  QUERY br-peso-period NO-LOCK DISPLAY
      fnPeriodoDes(tt-peso-period.cdn-period) COLUMN-LABEL "Per°odo" FORMAT "X(20)":U
            WIDTH 28.43
      tt-peso-period.val-peso COLUMN-LABEL "% Peso" FORMAT ">>9.99":U
            WIDTH 24.29
  ENABLE
      tt-peso-period.val-peso
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 56.57 BY 6.5
         FONT 1 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     cb-item AT ROW 2.63 COL 17 COLON-ALIGNED WIDGET-ID 30
     tt-param-aquis-rural.cod-estabel AT ROW 1.63 COL 17.14 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-estabel AT ROW 1.63 COL 23.29 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     c-desc-item AT ROW 2.63 COL 35.29 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     tt-config-peso-qualid.cod-exame AT ROW 3.63 COL 17.14 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 6.57 BY .88
     c-des-exame AT ROW 3.63 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     tt-config-peso-qualid.cod-comp AT ROW 4.63 COL 17.14 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-des-comp-exame AT ROW 4.63 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     c-periodo-ini AT ROW 5.63 COL 17.14 COLON-ALIGNED WIDGET-ID 26
     c-periodo-fim AT ROW 5.63 COL 32.57 COLON-ALIGNED WIDGET-ID 28
     tt-config-peso-qualid.qtd-period AT ROW 6.75 COL 17.14 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     bt-periodos AT ROW 6.71 COL 24 WIDGET-ID 24
     btOK AT ROW 16.63 COL 2
     btSave AT ROW 16.63 COL 13
     btCancel AT ROW 16.63 COL 24
     btHelp AT ROW 16.63 COL 80
     rtToolBar AT ROW 16.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     br-peso-period AT ROW 1.42 COL 16 WIDGET-ID 200
     l-ativa-facelift AT ROW 3.33 COL 73 COLON-ALIGNED NO-LABEL WIDGET-ID 2 NO-TAB-STOP 
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 8.58
         SIZE 84.43 BY 7.42
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-config-peso-qualid T "?" NO-UNDO mgcad config-peso-qualid
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-param-aquis-rural T "?" NO-UNDO mgcad param-aquis-rural
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-peso-period T "?" NO-UNDO mgcad peso-period
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-peso-period-aux T "?" NO-UNDO mgcad peso-period
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
         HEIGHT             = 17.17
         WIDTH              = 90
         MAX-HEIGHT         = 39.42
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 39.42
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
   FRAME-NAME Custom                                                    */
ASSIGN 
       bt-periodos:AUTO-RESIZE IN FRAME fpage0      = TRUE.

/* SETTINGS FOR FILL-IN c-des-exame IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estabel IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-param-aquis-rural.cod-estabel IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB br-peso-period 1 fPage1 */
/* SETTINGS FOR FILL-IN l-ativa-facelift IN FRAME fPage1
   NO-ENABLE                                                            */
ASSIGN 
       l-ativa-facelift:HIDDEN IN FRAME fPage1           = TRUE
       l-ativa-facelift:READ-ONLY IN FRAME fPage1        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-peso-period
/* Query rebuild information for BROWSE br-peso-period
     _TblList          = "Temp-Tables.tt-peso-period"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ","
     _FldNameList[1]   > "_<CALC>"
"fnPeriodoDes(tt-peso-period.cdn-period)" "Per°odo" "X(20)" ? ? ? ? ? ? ? no ? no no "28.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-peso-period.val-peso
"tt-peso-period.val-peso" "% Peso" ? "decimal" ? ? ? ? ? ? yes ? no no "24.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-peso-period */
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


&Scoped-define SELF-NAME bt-periodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-periodos wMaintenanceNoNavigation
ON CHOOSE OF bt-periodos IN FRAME fpage0
DO:
  
  EMPTY TEMP-TABLE tt-peso-period.

  IF INPUT FRAME fPage0 tt-config-peso-qualid.qtd-period > 0 THEN DO:
      
      DO  i-qtd-period = 1 TO INPUT FRAME fPage0 tt-config-peso-qualid.qtd-period:
      
          CREATE tt-peso-period.
          ASSIGN tt-peso-period.cod-estabel = tt-param-aquis-rural.cod-estabel
                 tt-peso-period.it-codigo   = cb-item:SCREEN-VALUE IN FRAME fPage0
                 tt-peso-period.cod-exame   = INPUT FRAME fPage0 tt-config-peso-qualid.cod-exame
                 tt-peso-period.cod-comp    = INPUT FRAME fPage0 tt-config-peso-qualid.cod-comp
                 tt-peso-period.cdn-seq     = tt-config-peso-qualid.cdn-seq
                 tt-peso-period.cdn-period  = i-qtd-period
                 tt-peso-period.val-peso    = 0.  

      END.

      {&OPEN-QUERY-br-peso-period}
      
      ASSIGN br-peso-period:SENSITIVE IN FRAME fPage1 = CAN-FIND(FIRST tt-peso-period).

  END.
  ELSE DO:
      /*        &1 deve ser maior que zero.   */
      {utp/ut-liter.i "A_quantidade_de_per°odos" *}
      RUN utp/ut-msgs.p(INPUT "show":U,
                        INPUT 36,
                        INPUT RETURN-VALUE).

  END.
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
    RUN saveRecordCustom IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN saveRecordCustom IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-item wMaintenanceNoNavigation
ON VALUE-CHANGED OF cb-item IN FRAME fpage0 /* Item */
DO:
    DEFINE VARIABLE pDescItem    AS CHARACTER NO-UNDO.

    RUN goToKey IN h-boin172na (INPUT cb-item:SCREEN-VALUE IN FRAME fPage0) NO-ERROR.

    IF RETURN-VALUE = "OK":U THEN DO:
    
        RUN findDescItem IN h-boin00983 (INPUT SELF:SCREEN-VALUE IN FRAME fPage0, OUTPUT pDescItem) NO-ERROR. 
        ASSIGN c-desc-item:SCREEN-VALUE IN FRAME fPage0 = pDescItem.

    END.
    ELSE 
        ASSIGN c-desc-item:SCREEN-VALUE IN FRAME fPage0 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-config-peso-qualid.cod-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-config-peso-qualid.cod-comp wMaintenanceNoNavigation
ON LEAVE OF tt-config-peso-qualid.cod-comp IN FRAME fpage0 /* Componente */
OR ENTRY OF tt-config-peso-qualid.cod-comp IN FRAME fpage0 /* Componente */
DO:

    RUN gotokey IN h-boin637(INPUT cb-item:SCREEN-VALUE, 
                             INPUT INT(tt-config-peso-qualid.cod-exame:SCREEN-VALUE), 
                             INPUT INT(tt-config-peso-qualid.cod-comp:SCREEN-VALUE)).

    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getCharField IN h-boin637(INPUT 'descricao', OUTPUT c-des-comp-exame).
        ASSIGN c-des-comp-exame:SCREEN-VALUE IN FRAME fPage0 = c-des-comp-exame.
    END.
    ELSE
        ASSIGN c-des-comp-exame:SCREEN-VALUE IN FRAME fPage0 = "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-config-peso-qualid.cod-comp wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-config-peso-qualid.cod-comp IN FRAME fpage0 /* Componente */
OR F5 OF tt-config-peso-qualid.cod-comp IN FRAME fpage0 /* Componente */
DO:
  {method/ZoomFields.i &ProgramZoom="inzoom/z01in637.w"
                       &FieldZoom1="cod-comp"
                       &FieldScreen1="tt-config-peso-qualid.cod-comp"
                       &Frame1="fPage0"
                       &RunMethod="RUN setParams IN hProgramZoom (INPUT cb-item:screen-value, INPUT INT(tt-config-peso-qualid.cod-exame:screen-value))."
                       &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-param-aquis-rural.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-aquis-rural.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-param-aquis-rural.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  {METHOD/referencefields.i 
        &HandleDBOLeave="h-boad107na"
        &KeyValue1="input frame fpage0 tt-param-aquis-rural.cod-estabel"
        &FieldName1="nome"
        &FieldScreen1="c-desc-estabel"
        &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-config-peso-qualid.cod-exame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-config-peso-qualid.cod-exame wMaintenanceNoNavigation
ON LEAVE OF tt-config-peso-qualid.cod-exame IN FRAME fpage0 /* Exame */
OR ENTRY OF tt-config-peso-qualid.cod-exame IN FRAME fpage0 /* Exame */
DO:
    RUN goToKeyByExame IN h-boin114(INPUT tt-config-peso-qualid.cod-exame:SCREEN-VALUE).
    
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getCharField IN h-boin114(INPUT 'descricao', OUTPUT c-des-exame).
        ASSIGN c-des-exame:SCREEN-VALUE IN FRAME fPage0 = c-des-exame.
    END.
    ELSE
        ASSIGN c-des-exame:SCREEN-VALUE IN FRAME fPage0 = "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-config-peso-qualid.cod-exame wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-config-peso-qualid.cod-exame IN FRAME fpage0 /* Exame */
OR F5 OF tt-config-peso-qualid.cod-exame IN FRAME fpage0 /* Exame */
DO:
    ASSIGN l-implanta = NO.              
    {include/zoomvar.i  &prog-zoom="inzoom/z01in164.w"
                        &campo=tt-config-peso-qualid.cod-exame
                        &campozoom=cod-exame
                        &parametros="run pi-seta-inicial in wh-pesquisa (INPUT cb-item:SCREEN-VALUE)."}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-config-peso-qualid.qtd-period
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-config-peso-qualid.qtd-period wMaintenanceNoNavigation
ON LEAVE OF tt-config-peso-qualid.qtd-period IN FRAME fpage0 /* Qtde Per°odo */
DO:
  APPLY "CHOOSE":U TO bt-periodos IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-peso-period
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-config-peso-qualid.cod-exame:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-config-peso-qualid.cod-comp:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fPage0.

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

    DEFINE VARIABLE c-list AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-num-linhas AS INTEGER NO-UNDO.

    IF pcAction = "ADD":U THEN DO:

        /*item padr∆o do estabelecimento em tela*/
        RUN getListItems IN h-boin00983(INPUT tt-param-aquis-rural.cod-estabel, OUTPUT c-list).

        IF c-list <> "" THEN DO:
            ASSIGN cb-item:LIST-ITEMS IN FRAME fPage0   = c-list
                   cb-item:SCREEN-VALUE IN FRAME fPage0 = ENTRY (1,c-list) NO-ERROR.
        END.
        /*******************************************/

        ASSIGN c-periodo-ini:SCREEN-VALUE IN FRAME fPage0 = IF INT(MONTH(TODAY)) < 10 THEN
                                                                "0" + STRING(MONTH(TODAY)) + "/" + STRING(YEAR(TODAY))
                                                            ELSE
                                                                STRING(MONTH(TODAY)) + "/" + STRING(YEAR(TODAY))
                                                                    
               c-periodo-fim:SCREEN-VALUE IN FRAME fPage0 = "12/9999".
 
    END.
    ELSE DO:
     
        RUN getBatchRecords IN h-boin01020 (INPUT prTable,
                                            INPUT NO,
                                            INPUT 1,
                                            OUTPUT i-num-linhas,
                                            OUTPUT TABLE tt-config-peso-qualid).

        FOR FIRST tt-config-peso-qualid:

            ASSIGN c-list                                                       = tt-config-peso-qualid.it-codigo + ',' + tt-config-peso-qualid.it-codigo
                   cb-item:LIST-ITEM-PAIRS IN FRAME fPage0                      = c-list
                   cb-item:SCREEN-VALUE    IN FRAME fPage0                      = ENTRY (1,c-list)
                   tt-config-peso-qualid.cod-exame:SCREEN-VALUE IN FRAME fPage0 = STRING(tt-config-peso-qualid.cod-exame)
                   tt-config-peso-qualid.cod-comp:SCREEN-VALUE  IN FRAME fPage0 = STRING(tt-config-peso-qualid.cod-comp)

                   c-periodo-ini:SCREEN-VALUE                   IN FRAME fPage0 = IF INT(MONTH(tt-config-peso-qualid.dat-inic)) < 10
                                                                                  THEN           
                                                                                      "0"
                                                                                      + STRING(MONTH(tt-config-peso-qualid.dat-inic))
                                                                                      + "/" 
                                                                                      + STRING(YEAR(tt-config-peso-qualid.dat-inic))
                                                                                  ELSE  
                                                                                        STRING(MONTH(tt-config-peso-qualid.dat-inic))
                                                                                      + "/" 
                                                                                      + STRING(YEAR(tt-config-peso-qualid.dat-inic))

                   c-periodo-fim:SCREEN-VALUE                   IN FRAME fPage0 = IF INT(MONTH(tt-config-peso-qualid.dat-fim)) < 10
                                                                                  THEN
                                                                                      "0"
                                                                                      + STRING(MONTH(tt-config-peso-qualid.dat-fim)) 
                                                                                      + "/" 
                                                                                      + STRING(YEAR(tt-config-peso-qualid.dat-fim))
                                                                                  ELSE
                                                                                        STRING(MONTH(tt-config-peso-qualid.dat-fim)) 
                                                                                      + "/" 
                                                                                      + STRING(YEAR(tt-config-peso-qualid.dat-fim))


                   cb-item:SENSITIVE                         = NO
                   tt-config-peso-qualid.cod-exame:SENSITIVE = NO
                   tt-config-peso-qualid.cod-comp:SENSITIVE  = NO.

            RUN getTTByParent IN h-boin01021 (INPUT tt-param-aquis-rural.cod-estabel,
                                              INPUT tt-config-peso-qualid.it-codigo,
                                              INPUT tt-config-peso-qualid.cod-exame, 
                                              INPUT tt-config-peso-qualid.cod-comp,
                                              INPUT tt-config-peso-qualid.cdn-seq,
                                              OUTPUT TABLE tt-peso-period).

            {&OPEN-QUERY-br-peso-period}
            
            ASSIGN br-peso-period:SENSITIVE IN FRAME fPage1 = CAN-FIND(FIRST tt-peso-period).

        END.

    END.

    APPLY "LEAVE":U         TO tt-param-aquis-rural.cod-estabel  IN FRAME fPage0.       
    APPLY "LEAVE":U         TO tt-config-peso-qualid.cod-exame   IN FRAME fPage0.       
    APPLY "LEAVE":U         TO tt-config-peso-qualid.cod-comp    IN FRAME fPage0.
    APPLY "VALUE-CHANGED":U TO cb-item                           IN FRAME fPage0.

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

    ASSIGN bt-periodos:SENSITIVE                            IN FRAME fPage0 = YES.

    IF pcAction <> "ADD":U THEN
        ASSIGN cb-item:SENSITIVE                            IN FRAME fPage0 = NO 
               tt-config-peso-qualid.cod-exame:SENSITIVE    IN FRAME fPage0 = NO
               tt-config-peso-qualid.cod-comp:SENSITIVE     IN FRAME fPage0 = NO.

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
    ASSIGN tt-config-peso-qualid.cod-estabel = tt-param-aquis-rural.cod-estabel
           tt-config-peso-qualid.it-codigo   = cb-item:SCREEN-VALUE IN FRAME fPage0
           tt-config-peso-qualid.cod-exame   = INT(tt-config-peso-qualid.cod-exame:SCREEN-VALUE IN FRAME fPage0)
           tt-config-peso-qualid.cod-comp    = INT(tt-config-peso-qualid.cod-comp:SCREEN-VALUE IN FRAME fPage0)
           tt-config-peso-qualid.qtd-period  = INT(tt-config-peso-qualid.qtd-period:SCREEN-VALUE IN FRAME fPage0)
           tt-config-peso-qualid.dat-inic    = DATE("01/" + c-periodo-ini:SCREEN-VALUE IN FRAME fPage0)
           tt-config-peso-qualid.dat-fim     = IF INT(SUBSTRING(c-periodo-fim:SCREEN-VALUE,1,2)) < 9 
                                                   THEN DATE("01/0" + STRING(INT(SUBSTRING(c-periodo-fim:SCREEN-VALUE,1,2)) + 1) + "/" + SUBSTRING(c-periodo-fim:SCREEN-VALUE,4,4)) - 1   /* £ltimo dia do màs */
                                               ELSE IF INT(SUBSTRING(c-periodo-fim:SCREEN-VALUE,1,2)) < 12
                                                   THEN DATE("01/"  + STRING(INT(SUBSTRING(c-periodo-fim:SCREEN-VALUE,1,2)) + 1) + "/" + SUBSTRING(c-periodo-fim:SCREEN-VALUE,4,4)) - 1   /* digitado em tela  */
                                               ELSE
                                                   DATE("31/"  +                  "12"                                           + "/" + SUBSTRING(c-periodo-fim:SCREEN-VALUE,4,4))  
           .
    
    IF pcAction = "ADD":U THEN DO:

        FOR EACH tt-peso-period:
            ASSIGN tt-peso-period.it-codigo = tt-config-peso-qualid.it-codigo
                   tt-peso-period.cod-exame = INPUT FRAME fPage0 tt-config-peso-qualid.cod-exame
                   tt-peso-period.cod-comp  = INPUT FRAME fPage0 tt-config-peso-qualid.cod-comp.
        END.
     
        RUN buscaSequencia IN h-boin01020 (INPUT-OUTPUT TABLE tt-config-peso-qualid,
                                           INPUT-OUTPUT TABLE tt-peso-period). 
    
    END.

    FOR FIRST tt-config-peso-qualid: END.

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

/*config-peso-qualid*/
IF NOT VALID-HANDLE(h-boin01020) THEN DO: 
        {btb/btb008za.i1 inbo/boin01020.p}
        {btb/btb008za.i2 inbo/boin01020.p '' h-boin01020}
END.
RUN openQueryStatic IN h-boin01020 (INPUT "Main":U).
/*********************/

/*peso-period*/
IF NOT VALID-HANDLE(h-boin01021) THEN DO: 
        {btb/btb008za.i1 inbo/boin01021.p}
        {btb/btb008za.i2 inbo/boin01021.p '' h-boin01021}
END.
RUN openQueryStatic IN h-boin01021 (INPUT "Main":U).
/*************/

/*item*/
IF NOT VALID-HANDLE(h-boin172na) THEN DO: 
        {btb/btb008za.i1 inbo/boin172na.p}
        {btb/btb008za.i2 inbo/boin172na.p '' h-boin172na}
END.
RUN openQueryStatic IN h-boin172na (INPUT "Main":U).
/******/

/*item-estab-rural*/
IF NOT VALID-HANDLE(h-boin00983) THEN DO: 
        {btb/btb008za.i1 inbo/boin00983.p}
        {btb/btb008za.i2 inbo/boin00983.p '' h-boin00983}
END.
RUN openQueryStatic IN h-boin00983 (INPUT "Main":U).
/******************/

/*estabel*/
IF NOT VALID-HANDLE(h-boad107na) THEN DO: 
        {btb/btb008za.i1 adbo/boad107na.p}
        {btb/btb008za.i2 adbo/boad107na.p '' h-boad107na}
END.
RUN openQueryStatic IN h-boad107na (INPUT "Main":U).
/*********/

/*exame*/
IF NOT VALID-HANDLE(h-boin114) THEN
    RUN inbo/boin114.p PERSISTENT SET h-boin114.
RUN openqueryStatic IN h-boin114(INPUT "Main") NO-ERROR.
/*******/

/*it-comp-exame*/
IF NOT VALID-HANDLE(h-boin637) THEN
    RUN inbo/boin637.p PERSISTENT SET h-boin637.
RUN openqueryStatic IN h-boin637(INPUT "Main") NO-ERROR.
/***************/


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
  Notes:       Este mÇtodo somente Ç executado quando a vari†vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveRecordCustom wMaintenanceNoNavigation 
PROCEDURE saveRecordCustom :
/*------------------------------------------------------------------------------
  Purpose: Salvar os registros pai e filho, mostrar msg de erro quando houver
  Notes:   Retorna status "NOK" em caso de erro.    
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-retorno AS CHARACTER NO-UNDO.

    IF VALID-HANDLE(h-boin01020) AND VALID-HANDLE(h-boin01021) THEN DO:

        RUN emptyRowErrors IN h-boin01020.
        RUN emptyRowErrors IN h-boin01021.

    END.
    ELSE 
        RETURN "NOK":U.

    IF pcAction = "ADD":U THEN DO:
        DO TRANS:

            RUN validateSomaPesos IN h-boin01021 (INPUT TABLE tt-peso-period). /*A soma dever† ser 100%*/
            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 6155,
                                   INPUT "").
                APPLY "ENTRY":U TO tt-peso-period.val-peso IN BROWSE br-peso-period.
                UNDO,LEAVE.
            END.

            RUN saveRecord IN THIS-PROCEDURE. /*Salva registro pai de forma padr∆o pelo Template*/
            IF RETURN-VALUE = "OK":U THEN DO:

                RUN emptyRowErrors IN h-boin01021.
        
                FOR EACH tt-peso-period:
        
                    EMPTY TEMP-TABLE tt-peso-period-aux.    
                    BUFFER-COPY tt-peso-period TO tt-peso-period-aux.
        
                    RUN emptyRowObject IN h-boin01021.
                    RUN setRecord      IN h-boin01021 (INPUT TABLE tt-peso-period-aux).
                    RUN createRecord   IN h-boin01021.
                    ASSIGN c-retorno = RETURN-VALUE.    
                    IF RETURN-VALUE = "NOK":U THEN DO:
                        RUN getRowErrors   IN h-boin01021 (OUTPUT TABLE RowErrors).
                        IF CAN-FIND(FIRST RowErrors
                                    WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                            /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
                            {method/showmessage.i1}
                            {method/showmessage.i2 &Modal="Yes"}
                            {method/showmessage.i3}
                            UNDO,LEAVE.
                         END.
                    END.
        
                    DELETE tt-peso-period.
        
                END.
        
            END.
        
        END.
    END.
    ELSE DO:
        DO TRANS:
            RUN beforeSaveFields IN THIS-PROCEDURE.
            RUN validateSomaPesos IN h-boin01021 (INPUT TABLE tt-peso-period). /*A soma dever† ser 100%*/
                ASSIGN c-retorno = RETURN-VALUE.
                IF RETURN-VALUE = "NOK":U THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show":U,
                                       INPUT 6155,
                                       INPUT "").
                    UNDO,LEAVE.
            
                END.
            
            RUN updateRecordCustom IN h-boin01020 (INPUT TABLE tt-config-peso-qualid).
            
            ASSIGN c-retorno = RETURN-VALUE.
            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN getRowErrors   IN h-boin01020 (OUTPUT TABLE RowErrors).
                IF CAN-FIND(FIRST RowErrors
                            WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                    /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
                    {method/showmessage.i1}
                    {method/showmessage.i2 &Modal="Yes"}
                    {method/showmessage.i3}
                    UNDO,LEAVE.
                END.
            END.
            ELSE DO:

                RUN emptyRowErrors IN h-boin01021.
        
                FOR EACH tt-peso-period:
        
                    EMPTY TEMP-TABLE tt-peso-period-aux.    
                    BUFFER-COPY tt-peso-period TO tt-peso-period-aux.
        
                    RUN emptyRowObject IN h-boin01021.
                    RUN setRecord      IN h-boin01021 (INPUT TABLE tt-peso-period-aux).
                    RUN createRecord   IN h-boin01021.
                    ASSIGN c-retorno = RETURN-VALUE.    
                    IF RETURN-VALUE = "NOK":U THEN DO:
                        RUN getRowErrors   IN h-boin01021 (OUTPUT TABLE RowErrors).
                        IF CAN-FIND(FIRST RowErrors
                                    WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                            /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
                            {method/showmessage.i1}
                            {method/showmessage.i2 &Modal="Yes"}
                            {method/showmessage.i3}
                            UNDO,LEAVE.
                         END.
                    END.
        
                    DELETE tt-peso-period.
        
                END.

            END.

        END.
    END.

    {&OPEN-QUERY-br-peso-period}

RETURN c-retorno.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPeriodoDes wMaintenanceNoNavigation 
FUNCTION fnPeriodoDes RETURNS CHARACTER
  ( p-cdn-period AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
    IF p-cdn-period = 1 THEN DO:
        {utp/ut-liter.i "Atual" *}
        RETURN RETURN-VALUE.   /* Function return value. */
    END.
    ELSE DO:
        {utp/ut-liter.i "Atual" *}
        RETURN RETURN-VALUE + " - " + STRING(p-cdn-period - 1).   /* Function return value. */
    END.
        

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

