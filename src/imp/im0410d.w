&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decla-import NO-UNDO LIKE decla-import
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-adic NO-UNDO LIKE decla-import-adic
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-adic-itens NO-UNDO LIKE decla-import-adic-itens
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-despes-adic NO-UNDO LIKE despes-adic
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-despes-adic-aux NO-UNDO LIKE despes-adic
       field r-Rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0410D 2.00.00.020 } /*** "010020" 07/11/2025 11:15:51 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0410D MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           IM0410D
&GLOBAL-DEFINE Version        2.00.00.020

&GLOBAL-DEFINE Folder            no
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-despes-adic
&GLOBAL-DEFINE hDBOTable         h-bocx390
&GLOBAL-DEFINE DBOTable          despes-adic

&GLOBAL-DEFINE ttParent          tt-decla-import-adic
&GLOBAL-DEFINE DBOParentTable    h-bocx403

&GLOBAL-DEFINE page0KeyFields    tt-decla-import-adic.num-di-ems c_cod-di-siscomex i_num-seq-retif tt-decla-import-adic.num-adic c_cod-estab d_dat-di tt-despes-adic.cdn-despes tt-despes-adic.cdn-emit-despes
&GLOBAL-DEFINE page0Fields       tt-despes-adic.cdn-cond-pag tt-despes-adic.cdn-moeda tt-despes-adic.val-despes tt-despes-adic.cod-incoterm-rat tt-despes-adic.val-cotac-despes-compltar tt-despes-adic.log-forma-preco-compra tt-despes-adic.log-incid-vmle
&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEF VAR i-num-linha-browse AS INTEGER NO-UNDO.
DEF VAR i-nr-registro      AS INTEGER NO-UNDO.
DEF VAR vRowid-Auxiliar      AS ROWID   NO-UNDO.
def new global shared var adm-broker-hdl as handle no-undo.
def var wh-pesquisa as handle  no-undo.
def var iRowsReturned as integer no-undo.
DEF VAR cStatus AS CHAR NO-UNDO.
DEF VAR i-tp-despesa AS INTEGER NO-UNDO.
DEF VAR rRowid AS ROWID NO-UNDO.

DEF VAR l-utz-taxa-siscomex AS LOGICAL   NO-UNDO.
DEF VAR i-cod-desp          AS INTEGER   NO-UNDO.
DEF VAR i-cod-emitente-desp AS INTEGER   NO-UNDO.
DEF VAR i-cod-fornec-padrao AS INTEGER   NO-UNDO.
DEF VAR c-return            AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-estab AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-embarque  AS CHARACTER   NO-UNDO.
DEF VAR l-encontrou         AS LOGICAL NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad098     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boun005     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad039na   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx095     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx383     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx383a    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx407     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx310     AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-despes-adic.cdn-despes ~
tt-despes-adic.cdn-emit-despes tt-despes-adic.cdn-cond-pag ~
tt-despes-adic.cdn-moeda tt-despes-adic.val-despes ~
tt-despes-adic.cod-incoterm-rat tt-despes-adic.val-cotac-despes-compltar ~
tt-despes-adic.log-forma-preco-compra tt-despes-adic.log-incid-vmle 
&Scoped-define ENABLED-TABLES tt-despes-adic
&Scoped-define FIRST-ENABLED-TABLE tt-despes-adic
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar RECT-3 c-desc-despesa ~
c-nome-fornec c-desc-cond-pag c-desc-moeda btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-decla-import-adic.num-di-ems ~
tt-decla-import-adic.num-adic tt-despes-adic.cdn-despes ~
tt-despes-adic.cdn-emit-despes tt-despes-adic.cdn-cond-pag ~
tt-despes-adic.cdn-moeda tt-despes-adic.val-despes ~
tt-despes-adic.cod-incoterm-rat tt-despes-adic.val-cotac-despes-compltar ~
tt-despes-adic.log-forma-preco-compra tt-despes-adic.log-incid-vmle 
&Scoped-define DISPLAYED-TABLES tt-decla-import-adic tt-despes-adic
&Scoped-define FIRST-DISPLAYED-TABLE tt-decla-import-adic
&Scoped-define SECOND-DISPLAYED-TABLE tt-despes-adic
&Scoped-Define DISPLAYED-OBJECTS c_cod-di-siscomex i_num-seq-retif ~
c_cod-estab d_dat-di c-registro c-desc-despesa c-nome-fornec ~
c-desc-cond-pag c-desc-moeda 

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

DEFINE VARIABLE c-desc-cond-pag AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-despesa AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-moeda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-fornec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-registro AS CHARACTER FORMAT "X(256)":U 
     LABEL "Registro" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE c_cod-di-siscomex AS CHARACTER FORMAT "x(13)" 
     LABEL "DI Siscomex" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE c_cod-estab AS CHARACTER FORMAT "x(5)" 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE d_dat-di AS DATE FORMAT "99/99/9999" 
     LABEL "Data DI" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE VARIABLE i_num-seq-retif AS INTEGER FORMAT "99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 11.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-decla-import-adic.num-di-ems AT ROW 1.25 COL 8 COLON-ALIGNED WIDGET-ID 102
          LABEL "DI EMS"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c_cod-di-siscomex AT ROW 1.25 COL 36.72 COLON-ALIGNED WIDGET-ID 94
     i_num-seq-retif AT ROW 1.25 COL 51.86 COLON-ALIGNED NO-LABEL WIDGET-ID 104
     tt-decla-import-adic.num-adic AT ROW 1.25 COL 71.29 COLON-ALIGNED WIDGET-ID 100
          LABEL "Adi‡Æo"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .88
     c_cod-estab AT ROW 2.25 COL 8 COLON-ALIGNED WIDGET-ID 96
     d_dat-di AT ROW 2.25 COL 36.72 COLON-ALIGNED WIDGET-ID 98
     c-registro AT ROW 2.25 COL 71 COLON-ALIGNED WIDGET-ID 20
     tt-despes-adic.cdn-despes AT ROW 5.25 COL 25 COLON-ALIGNED WIDGET-ID 12
          LABEL "Despesa"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     c-desc-despesa AT ROW 5.25 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     tt-despes-adic.cdn-emit-despes AT ROW 6.25 COL 25 COLON-ALIGNED WIDGET-ID 30
          LABEL "Fornec Despesa"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-nome-fornec AT ROW 6.25 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     tt-despes-adic.cdn-cond-pag AT ROW 7.25 COL 25 COLON-ALIGNED WIDGET-ID 14
          LABEL "Condi‡Æo Pagamento"
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     c-desc-cond-pag AT ROW 7.25 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     tt-despes-adic.cdn-moeda AT ROW 8.25 COL 25 COLON-ALIGNED WIDGET-ID 18
          LABEL "Moeda"
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     c-desc-moeda AT ROW 8.25 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 106
     tt-despes-adic.val-despes AT ROW 9.25 COL 25 COLON-ALIGNED WIDGET-ID 22
          LABEL "Valor Despesa"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tt-despes-adic.cod-incoterm-rat AT ROW 10.25 COL 25 COLON-ALIGNED WIDGET-ID 24
          LABEL "Incoterm de Rateio"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-despes-adic.val-cotac-despes-compltar AT ROW 11.25 COL 25 COLON-ALIGNED WIDGET-ID 26
          LABEL "CotacÆo Desp Compl"
          VIEW-AS FILL-IN 
          SIZE 27 BY .88
     tt-despes-adic.log-forma-preco-compra AT ROW 12.25 COL 27 WIDGET-ID 34
          LABEL "Forma Pre‡o Compra"
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .88
     tt-despes-adic.log-incid-vmle AT ROW 13.25 COL 27 WIDGET-ID 36
          VIEW-AS TOGGLE-BOX
          SIZE 12.29 BY .88
     btOK AT ROW 16.63 COL 2
     btSave AT ROW 16.63 COL 13
     btCancel AT ROW 16.63 COL 24
     btHelp AT ROW 16.63 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 16.38 COL 1
     RECT-3 AT ROW 4.25 COL 7 WIDGET-ID 108
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-decla-import T "?" NO-UNDO mgcex decla-import
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-adic T "?" NO-UNDO mgcex decla-import-adic
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-adic-itens T "?" NO-UNDO mgcex decla-import-adic-itens
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-despes-adic T "?" NO-UNDO mgcex despes-adic
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-despes-adic-aux T "?" NO-UNDO mgcex despes-adic
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
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
         HEIGHT             = 17
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
/* SETTINGS FOR FILL-IN c-registro IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-despes-adic.cdn-cond-pag IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-despes-adic.cdn-despes IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-despes-adic.cdn-emit-despes IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-despes-adic.cdn-moeda IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-despes-adic.cod-incoterm-rat IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN c_cod-di-siscomex IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c_cod-estab IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d_dat-di IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i_num-seq-retif IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tt-despes-adic.log-forma-preco-compra IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.num-adic IN FRAME fpage0
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.num-di-ems IN FRAME fpage0
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN tt-despes-adic.val-cotac-despes-compltar IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-despes-adic.val-despes IN FRAME fpage0
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
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    ASSIGN vRowid-Auxiliar = tt-despes-adic.r-Rowid.
    RUN saveRecord IN THIS-PROCEDURE.

    RUN repositionRecord IN {&hDBOTable} (INPUT vRowid-Auxiliar).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-despes-adic.cdn-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-adic.cdn-cond-pag wMaintenanceNoNavigation
ON F5 OF tt-despes-adic.cdn-cond-pag IN FRAME fpage0 /* Condi‡Æo Pagamento */
DO:
    {method/zoomfields.i &ProgramZoom="adzoom/z10ad039.w"
                         &FieldZoom1="cod-cond-pag"
                         &FieldScreen1="tt-despes-adic.cdn-cond-pag"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao"
                         &FieldScreen2="c-desc-cond-pag"
                         &Frame2="fPage0"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-adic.cdn-cond-pag wMaintenanceNoNavigation
ON LEAVE OF tt-despes-adic.cdn-cond-pag IN FRAME fpage0 /* Condi‡Æo Pagamento */
DO:
    RUN goToKey IN h-boad039na (INPUT tt-despes-adic.cdn-cond-pag:SCREEN-VALUE IN FRAME fPage0).
    IF  RETURN-VALUE = "OK" THEN DO:
        RUN getCharField IN h-boad039na(INPUT 'descricao', OUTPUT c-desc-cond-pag).
    END.
    ELSE ASSIGN c-desc-cond-pag = "".
    
    DISP c-desc-cond-pag WITH FRAME fPage0.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-adic.cdn-cond-pag wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-despes-adic.cdn-cond-pag IN FRAME fpage0 /* Condi‡Æo Pagamento */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-despes-adic.cdn-despes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-adic.cdn-despes wMaintenanceNoNavigation
ON F5 OF tt-despes-adic.cdn-despes IN FRAME fpage0 /* Despesa */
DO:
    {method/zoomfields.i &ProgramZoom="cxzoom/z10cx095.w"
                         &FieldZoom1="cod-desp"
                         &FieldScreen1="tt-despes-adic.cdn-despes"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao"
                         &FieldScreen2="c-desc-despesa"
                         &Frame2="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-adic.cdn-despes wMaintenanceNoNavigation
ON LEAVE OF tt-despes-adic.cdn-despes IN FRAME fpage0 /* Despesa */
DO: 
    RUN goToFirstEmbarque IN h-bocx407 (INPUT tt-despes-adic.num-di-ems,
                                        INPUT tt-despes-adic.cdd-siscomex-dts).

    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getCharField IN h-bocx407 (INPUT "cod-embarq":U, OUTPUT c-embarque).
        RUN getCharField IN h-bocx407 (INPUT "cod-estab":U, OUTPUT c-cod-estab).

        RUN findDespesa IN h-bocx310 (INPUT c-cod-estab,
                                      INPUT c-embarque,
                                      INPUT INTEGER(tt-despes-adic.cdn-despes:SCREEN-VALUE IN FRAME fPage0),
                                      OUTPUT c-return).

        IF c-return = "":U THEN DO:
            RUN getCharField IN h-bocx310 (INPUT "descricao":U,
                                           OUTPUT c-desc-despesa).
        END.
    END.

        IF VALID-HANDLE(h-bocx095) THEN
            RUN retornaDescDespesa IN h-bocx095 (INPUT INTEGER(tt-despes-adic.cdn-despes:SCREEN-VALUE IN FRAME fPage0), 
                                                 output c-desc-despesa).
    DISP c-desc-despesa WITH FRAME fPage0.

    RUN findCodigo IN h-bocx095 (INPUT INPUT FRAME fPage0 tt-despes-adic.cdn-despes, OUTPUT c-return).

    IF c-return = "" THEN DO:
        RUN getIntField IN h-bocx095 (INPUT "cod-emitente", OUTPUT i-cod-fornec-padrao).

        IF i-cod-fornec-padrao <> 0 THEN DO:

            ASSIGN tt-despes-adic.cdn-emit-despes:SCREEN-VALUE IN FRAME fPage0 = string(i-cod-fornec-padrao).
                
            {method/referencefields.i
                    &HandleDBOLeave="h-boad098"
                    &FindMethod="findCodigo"
                    &KeyValue1="int(tt-despes-adic.cdn-emit-despes:SCREEN-VALUE IN FRAME fPage0)"
                    &FieldName1="nome-abrev"
                    &FieldScreen1="c-nome-fornec"
                    &Frame1="fPage0"}
        END.
        ELSE
            ASSIGN tt-despes-adic.cdn-emit-despes:SCREEN-VALUE IN FRAME fPage0 = string(0)
                   c-nome-fornec:SCREEN-VALUE IN FRAME fPage0 = "".
        
    END.
    ELSE
        ASSIGN tt-despes-adic.cdn-emit-despes:SCREEN-VALUE IN FRAME fPage0 = string(0)
               c-nome-fornec:SCREEN-VALUE IN FRAME fPage0 = "".

    IF  NOT l-encontrou
    AND l-utz-taxa-siscomex
    AND i-cod-desp = INPUT FRAME fPage0 tt-despes-adic.cdn-despes THEN DO:
        DISABLE tt-despes-adic.cdn-cond-pag
                tt-despes-adic.cdn-moeda
                tt-despes-adic.cod-incoterm-rat
                tt-despes-adic.val-cotac-despes-compltar
                tt-despes-adic.log-forma-preco-compra
                tt-despes-adic.log-incid-vmle
            WITH FRAME fPage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-adic.cdn-despes wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-despes-adic.cdn-despes IN FRAME fpage0 /* Despesa */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-despes-adic.cdn-emit-despes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-adic.cdn-emit-despes wMaintenanceNoNavigation
ON F5 OF tt-despes-adic.cdn-emit-despes IN FRAME fpage0 /* Fornec Despesa */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
                      &campo="tt-despes-adic.cdn-emit-despes"
                      &campozoom="cod-emitente"
                      &frame="fPage0"
                      &campo2="c-nome-fornec"
                      &campozoom2="nome-abrev"
                      &Frame2="fPage0"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-adic.cdn-emit-despes wMaintenanceNoNavigation
ON LEAVE OF tt-despes-adic.cdn-emit-despes IN FRAME fpage0 /* Fornec Despesa */
DO:
     {method/referencefields.i 
        &HandleDBOLeave="h-boad098"
        &FindMethod="findCodigo"
        &KeyValue1="int(tt-despes-adic.cdn-emit-despes:SCREEN-VALUE IN FRAME fPage0)"
        &FieldName1="nome-abrev"
        &FieldScreen1="c-nome-fornec"
        &Frame1="fPage0"}  
     
    IF tt-despes-adic.cdn-emit-despes:SCREEN-VALUE IN FRAME fPage0 = "0" THEN
        ASSIGN c-nome-fornec:SCREEN-VALUE IN FRAME fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-adic.cdn-emit-despes wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-despes-adic.cdn-emit-despes IN FRAME fpage0 /* Fornec Despesa */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-despes-adic.cdn-moeda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-adic.cdn-moeda wMaintenanceNoNavigation
ON F5 OF tt-despes-adic.cdn-moeda IN FRAME fpage0 /* Moeda */
DO:
    {include/zoomvar.i &prog-zoom=unzoom/z01un005.w
                       &campo=tt-despes-adic.cdn-moeda
                       &campozoom=mo-codigo
                       &frame=fpage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-adic.cdn-moeda wMaintenanceNoNavigation
ON LEAVE OF tt-despes-adic.cdn-moeda IN FRAME fpage0 /* Moeda */
DO:
    {method/referencefields.i &HandleDBOLeave="h-boun005"
                              &FindMethod="findCodigo"
                              &KeyValue1="int(tt-despes-adic.cdn-moeda:SCREEN-VALUE IN FRAME fPage0)"
                              &FieldName1="descricao"
                              &FieldScreen1="c-desc-moeda"
                              &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-adic.cdn-moeda wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-despes-adic.cdn-moeda IN FRAME fpage0 /* Moeda */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

if tt-despes-adic.cdn-despes:load-mouse-pointer ("image/lupa.cur") in frame fPage0 then.
if tt-despes-adic.cdn-emit-despes:load-mouse-pointer ("image/lupa.cur") in frame fPage0 then.
if tt-despes-adic.cdn-cond-pag:load-mouse-pointer ("image/lupa.cur") in frame fPage0 then.
if tt-despes-adic.cdn-moeda:load-mouse-pointer ("image/lupa.cur") in frame fPage0 then.

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
    
    IF VALID-HANDLE(h-boad098) THEN DO:
        DELETE PROCEDURE h-boad098.
        ASSIGN h-boad098 = ?.
    END.

    IF VALID-HANDLE(h-boun005) THEN DO:
        DELETE PROCEDURE h-boun005.
        ASSIGN h-boun005 = ?.
    END.

    IF VALID-HANDLE(h-boad039na) THEN DO:
        DELETE PROCEDURE h-boad039na.
        ASSIGN h-boad039na = ?.
    END.

    IF VALID-HANDLE(h-bocx095) THEN DO:
        DELETE PROCEDURE h-bocx095.
        ASSIGN h-bocx095 = ?.
    END.

    IF VALID-HANDLE(h-bocx383) THEN DO:
        DELETE PROCEDURE h-bocx383.
        ASSIGN h-bocx383 = ?.
    END.
    
    IF VALID-HANDLE(h-bocx407) THEN DO:
        DELETE PROCEDURE h-bocx407.
        ASSIGN h-bocx407 = ?.
    END.

    IF VALID-HANDLE(h-bocx310) THEN DO:
        DELETE PROCEDURE h-bocx310.
        ASSIGN h-bocx310 = ?.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    run piContaRegistro in {&hDBOTable} (input tt-despes-adic.num-di-ems,
                                         input tt-despes-adic.num-adic,
                                         input tt-despes-adic.cdd-siscomex-dts,
                                         output i-nr-registro).
    assign c-registro:screen-value in frame fPage0 = string(i-num-linha-browse) + "/" + string(i-nr-registro).

    apply 'leave' to tt-despes-adic.cdn-cond-pag    in frame fPage0.
    apply 'leave' to tt-despes-adic.cdn-despes      in frame fPage0.
    apply 'leave' to tt-despes-adic.cdn-emit-despes in frame fPage0.
    apply 'leave' to tt-despes-adic.cdn-moeda       in frame fPage0.

    ASSIGN rRowid = tt-despes-adic.r-Rowid.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DISABLE tt-decla-import-adic.num-di-ems 
            c_cod-di-siscomex 
            i_num-seq-retif 
            tt-decla-import-adic.num-adic 
            c_cod-estab 
            d_dat-di 
        WITH FRAME fPage0.

    FIND FIRST decla-import NO-LOCK
            WHERE decla-import.num-di-ems       = INPUT FRAME fPage0 tt-decla-import-adic.num-di-ems
            AND   decla-import.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts
            NO-ERROR.
    FIND FIRST param-imp NO-LOCK
            WHERE param-imp.cod-estabel = decla-import.cod-estab NO-ERROR.

    /* verificar param */
    ASSIGN l-utz-taxa-siscomex = param-imp.log-tax-siscomex
           i-cod-desp          = param-imp.cdn-despes-siscomex
           i-cod-emitente-desp = param-imp.cdn-emit-siscomex.
    
    RUN pi-verifica-docto. /* verifica se h  nota gerada para esta DI. Se houver desabilita todos os campos da tela. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    /*RUN setConstraintByNumDIEMS IN {&hDBOTable} (INPUT tt-decla-import-adic.num-di-ems, INPUT tt-decla-import-adic.num-adic).
    RUN openQueryStatic         IN {&hDBOTable} (INPUT 'ByNumDIEMS':U).*/
    
    run piContaRegistro in {&hDBOTable} (input tt-decla-import-adic.num-di-ems,
                                         input tt-decla-import-adic.num-adic, 
                                         input tt-decla-import-adic.cdd-siscomex-dts,
                                         output i-nr-registro).
    assign c-registro:screen-value in frame fPage0 = string(i-num-linha-browse) + "/" + string(i-nr-registro).

    RUN piRetornaDadosDI IN {&hDBOTable} (INPUT tt-decla-import-adic.num-di-ems,
                                          INPUT tt-decla-import-adic.cdd-siscomex-dts,
                                          OUTPUT c_cod-di-siscomex, 
                                          OUTPUT i_num-seq-retif,  
                                          OUTPUT c_cod-estab,      
                                          OUTPUT d_dat-di).        

    DISP c_cod-di-siscomex i_num-seq-retif c_cod-estab d_dat-di WITH FRAME fPage0.
    
    IF  pcAction = 'ADD' THEN 
        ASSIGN c-registro:VISIBLE IN FRAME fPage0 = NO. 
    ELSE 
        ASSIGN c-registro:VISIBLE IN FRAME fPage0 = YES. 

    APPLY 'ENTRY' TO tt-despes-adic.cdn-despes IN FRAME fPage0.
    RUN pi-verifica-docto. /* verifica se h  nota gerada para esta DI. Se houver desabilita todos os campos da tela. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    IF RETURN-VALUE = "NOK":U THEN RUN emptyRowErrors IN {&hDBOTable}.

    IF NOT VALID-HANDLE (h-boad098) THEN RUN adbo/boad098.p PERSISTENT SET h-boad098. /* emitente */
    RUN openQueryStatic IN h-boad098 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE (h-boad039na) THEN RUN adbo/boad039na.p PERSISTENT SET h-boad039na. /* cond-pagto */
    RUN openQueryStatic IN h-boad039na (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE (h-bocx095) THEN RUN cxbo/bocx095.p PERSISTENT SET h-bocx095. /* despesa */
    RUN openQueryStatic IN h-bocx095 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE (h-boun005) THEN RUN unbo/boun005na.p persistent set h-boun005. /* moeda */
    RUN openQueryStatic IN h-boun005 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE (h-bocx310) THEN RUN cxbo/bocx310.p persistent set h-bocx310.
    RUN openQueryStatic IN h-bocx310 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE (h-bocx407) THEN RUN cxbo/bocx407.p persistent set h-bocx407.
    RUN openQueryStatic IN h-bocx407 (INPUT "Main":U) NO-ERROR.

    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-linha-browse wMaintenanceNoNavigation 
PROCEDURE pi-seta-linha-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-num-linha-browse AS INTEGER   NO-UNDO.

assign i-num-linha-browse = p-num-linha-browse.

return "ok":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-docto wMaintenanceNoNavigation 
PROCEDURE pi-verifica-docto :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    IF  NOT VALID-HANDLE(h-bocx383a) THEN
        RUN cxbo/bocx383a.p PERSISTENT SET h-bocx383a.
    
    RUN piDoctoRecebimento IN h-bocx383a(INPUT c_cod-di-siscomex, OUTPUT l-encontrou).

    IF  l-encontrou THEN DO:
        DISABLE tt-despes-adic.cdn-cond-pag 
                tt-despes-adic.cdn-moeda 
                tt-despes-adic.val-despes 
                tt-despes-adic.cod-incoterm-rat 
                tt-despes-adic.val-cotac-despes-compltar 
                tt-despes-adic.log-forma-preco-compra 
                tt-despes-adic.log-incid-vmle
            WITH FRAME fPage0.
    END.

    IF VALID-HANDLE (h-bocx383a) THEN DO: 
        DELETE PROCEDURE h-bocx383a.
        ASSIGN h-bocx383a = ?.
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

    RUN findCodigo in h-bocx095 (input INPUT FRAME fPage0 tt-despes-adic.cdn-despes, output cStatus).
    
    if cStatus = "" then RUN getIntField in h-bocx095 (input "tipo":U, output i-tp-despesa).
    
    ASSIGN tt-despes-adic.num-di-ems       = tt-decla-import-adic.num-di-ems
           tt-despes-adic.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts
           tt-despes-adic.num-adic         = tt-decla-import-adic.num-adic
           tt-despes-adic.idi-despes       = i-tp-despesa
           tt-despes-adic.idi-orig-despes  = 1 /* Adi‡Æo */.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

