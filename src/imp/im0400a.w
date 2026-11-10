&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decla-import NO-UNDO LIKE decla-import
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-despes-decla-import NO-UNDO LIKE despes-decla-import
       field r-Rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T********************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/
{include/i-prgvrs.i IM0400A 2.00.00.016 } /*** "010016" 07/11/2025 11:15:50 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0400A MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           IM0400A
&GLOBAL-DEFINE Version        2.00.00.016

&GLOBAL-DEFINE Folder            no
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-despes-decla-import
&GLOBAL-DEFINE hDBOTable         h-bocx406
&GLOBAL-DEFINE DBOTable          despes-decla-import

&GLOBAL-DEFINE ttParent          tt-decla-import
&GLOBAL-DEFINE DBOParentTable    decla-import

&GLOBAL-DEFINE page0KeyFields    tt-despes-decla-import.cdn-despes tt-despes-decla-import.cdn-emit-despes
&GLOBAL-DEFINE page0Fields       tt-despes-decla-import.cdn-cond-pagto tt-despes-decla-import.cdn-moed tt-despes-decla-import.val-cotac-despes-compltar tt-despes-decla-import.val-despes tt-despes-decla-import.cod-incoterm-rat tt-despes-decla-import.log-forma-preco-compra cb-tipo-incide-nf tt-despes-decla-import.log-incid-vmle tt-despes-decla-import.log-livre-1
&GLOBAL-DEFINE page0ParentFields tt-decla-import.num-di-ems tt-decla-import.cod-di-siscomex tt-decla-import.cod-estab tt-decla-import.dat-di tt-decla-import.num-seq-retif
&GLOBAL-DEFINE page1Fields       
 
/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE  NO-UNDO.
DEFINE VARIABLE wh-pesquisa  AS HANDLE NO-UNDO.
/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx110    AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-boad098na  AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-boad039na  AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx095    AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-boun005    AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx407    AS HANDLE  NO-UNDO.
DEFINE VARIABLE l-retorno    AS LOGICAL NO-UNDO.
DEFINE VARIABLE h-boad098    AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx310    AS HANDLE  NO-UNDO.

DEFINE VARIABLE i-cdn-despes-siscomex    AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-cdn-emit-siscomex      AS INTEGER   NO-UNDO.
DEFINE VARIABLE l-taxa-siscomex          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-return                 AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-incoterm-rat           AS LOGICAL   NO-UNDO.
DEFINE VARIABLE i-cod-emitente           AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-cod-estab              AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-embarque               AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-situacao-integ-desp    AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-char-param-imp         AS CHARACTER NO-UNDO.

{cdp/cdcfgmat.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-decla-import.num-di-ems ~
tt-decla-import.cod-di-siscomex tt-decla-import.num-seq-retif ~
tt-decla-import.cod-estab tt-decla-import.dat-di ~
tt-despes-decla-import.cdn-despes tt-despes-decla-import.cdn-emit-despes ~
tt-despes-decla-import.cdn-cond-pagto tt-despes-decla-import.cdn-moeda ~
tt-despes-decla-import.val-despes tt-despes-decla-import.cod-incoterm-rat ~
tt-despes-decla-import.val-cotac-despes-compltar ~
tt-despes-decla-import.log-forma-preco-compra ~
tt-despes-decla-import.log-incid-vmle tt-despes-decla-import.log-livre-1 
&Scoped-define ENABLED-TABLES tt-decla-import tt-despes-decla-import
&Scoped-define FIRST-ENABLED-TABLE tt-decla-import
&Scoped-define SECOND-ENABLED-TABLE tt-despes-decla-import
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar RECT-87 cb-tipo-incide-nf ~
btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-decla-import.num-di-ems ~
tt-decla-import.cod-di-siscomex tt-decla-import.num-seq-retif ~
tt-decla-import.cod-estab tt-decla-import.dat-di ~
tt-despes-decla-import.cdn-despes tt-despes-decla-import.cdn-emit-despes ~
tt-despes-decla-import.cdn-cond-pagto tt-despes-decla-import.cdn-moeda ~
tt-despes-decla-import.val-despes tt-despes-decla-import.cod-incoterm-rat ~
tt-despes-decla-import.val-cotac-despes-compltar ~
tt-despes-decla-import.log-forma-preco-compra ~
tt-despes-decla-import.log-incid-vmle tt-despes-decla-import.log-livre-1 
&Scoped-define DISPLAYED-TABLES tt-decla-import tt-despes-decla-import
&Scoped-define FIRST-DISPLAYED-TABLE tt-decla-import
&Scoped-define SECOND-DISPLAYED-TABLE tt-despes-decla-import
&Scoped-Define DISPLAYED-OBJECTS c-desc-despesa c-desc-fornecedor ~
c-desc-pagto c-desc-moeda cb-tipo-incide-nf 

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

DEFINE VARIABLE cb-tipo-incide-nf AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Incide Nota Fiscal" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 27 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-despesa AS CHARACTER FORMAT "x(40)":U 
     VIEW-AS FILL-IN 
     SIZE 37.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-fornecedor AS CHARACTER FORMAT "x(40)":U 
     VIEW-AS FILL-IN 
     SIZE 35.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-moeda AS CHARACTER FORMAT "x(40)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-pagto AS CHARACTER FORMAT "x(40)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-87
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 12.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     tt-decla-import.num-di-ems AT ROW 1.5 COL 26.86 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 7.57 BY .88
     tt-decla-import.cod-di-siscomex AT ROW 1.5 COL 46.86 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     tt-decla-import.num-seq-retif AT ROW 1.5 COL 68.29 COLON-ALIGNED NO-LABEL WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     tt-decla-import.cod-estab AT ROW 2.5 COL 26.86 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-decla-import.dat-di AT ROW 2.5 COL 46.86 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-despes-decla-import.cdn-despes AT ROW 5.25 COL 27 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     c-desc-despesa AT ROW 5.25 COL 39.14 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     tt-despes-decla-import.cdn-emit-despes AT ROW 6.25 COL 27 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-desc-fornecedor AT ROW 6.25 COL 41.14 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     tt-despes-decla-import.cdn-cond-pagto AT ROW 7.25 COL 27 COLON-ALIGNED WIDGET-ID 16
          LABEL "Condi‡Æo Pagamento"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-desc-pagto AT ROW 7.25 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     tt-despes-decla-import.cdn-moeda AT ROW 8.25 COL 27 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-desc-moeda AT ROW 8.25 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     tt-despes-decla-import.val-despes AT ROW 9.25 COL 27 COLON-ALIGNED WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tt-despes-decla-import.cod-incoterm-rat AT ROW 10.25 COL 27 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-despes-decla-import.val-cotac-despes-compltar AT ROW 11.25 COL 27 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 27 BY .88
     tt-despes-decla-import.log-forma-preco-compra AT ROW 12.25 COL 29 WIDGET-ID 46
          VIEW-AS TOGGLE-BOX
          SIZE 18 BY .88
     cb-tipo-incide-nf AT ROW 13.25 COL 27 COLON-ALIGNED WIDGET-ID 48
     tt-despes-decla-import.log-incid-vmle AT ROW 14.33 COL 29 WIDGET-ID 50
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .83
     tt-despes-decla-import.log-livre-1 AT ROW 15.33 COL 29 WIDGET-ID 50
          LABEL "AFRMM"
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .83
     btOK AT ROW 16.63 COL 2
     btSave AT ROW 16.63 COL 13
     btCancel AT ROW 16.63 COL 24
     btHelp AT ROW 16.63 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 16.38 COL 1
     RECT-87 AT ROW 4.25 COL 1 WIDGET-ID 14
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
      TABLE: tt-despes-decla-import T "?" NO-UNDO mgcex despes-decla-import
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
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-desc-despesa IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-fornecedor IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-moeda IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-pagto IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-despes-decla-import.cdn-cond-pagto IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX tt-despes-decla-import.log-livre-1 IN FRAME fPage0
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
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
ON CHOOSE OF btCancel IN FRAME fPage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fPage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fPage0 /* OK */
DO:
    
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN DO:
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fPage0 /* Salvar */
DO:
    
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-tipo-incide-nf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-incide-nf wMaintenanceNoNavigation
ON LEAVE OF cb-tipo-incide-nf IN FRAME fPage0 /* Tipo Incide Nota Fiscal */
DO:
  RUN pi-habilita-incide-vmle.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-despes-decla-import.cdn-cond-pagto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-decla-import.cdn-cond-pagto wMaintenanceNoNavigation
ON F5 OF tt-despes-decla-import.cdn-cond-pagto IN FRAME fPage0 /* Condi‡Æo Pagamento */
DO:
    {method/zoomfields.i &ProgramZoom="adzoom/z10ad039.w"
                         &FieldZoom1="cod-cond-pag"
                         &FieldScreen1="tt-despes-decla-import.cdn-cond-pagto"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao"
                         &FieldScreen2="c-desc-pagto"
                         &Frame2="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-decla-import.cdn-cond-pagto wMaintenanceNoNavigation
ON LEAVE OF tt-despes-decla-import.cdn-cond-pagto IN FRAME fPage0 /* Condi‡Æo Pagamento */
DO:
    RUN goToKey IN h-boad039na (INPUT tt-despes-decla-import.cdn-cond-pagto:SCREEN-VALUE IN FRAME fPage0).
    IF  RETURN-VALUE = "OK" THEN DO:
        RUN getCharField IN h-boad039na(INPUT 'descricao', OUTPUT c-desc-pagto).
    END.
    ELSE ASSIGN c-desc-pagto = "".
    
    DISP c-desc-pagto WITH FRAME fPage0.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-decla-import.cdn-cond-pagto wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-despes-decla-import.cdn-cond-pagto IN FRAME fPage0 /* Condi‡Æo Pagamento */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-despes-decla-import.cdn-despes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-decla-import.cdn-despes wMaintenanceNoNavigation
ON F5 OF tt-despes-decla-import.cdn-despes IN FRAME fPage0 /* Despesa */
DO:
    {method/zoomfields.i &ProgramZoom="cxzoom/z10cx095.w"
                         &FieldZoom1="cod-desp"
                         &FieldScreen1="tt-despes-decla-import.cdn-despes"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao"
                         &FieldScreen2="c-desc-despesa"
                         &Frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-decla-import.cdn-despes wMaintenanceNoNavigation
ON LEAVE OF tt-despes-decla-import.cdn-despes IN FRAME fPage0 /* Despesa */
DO:
    RUN goToFirstEmbarque IN h-bocx407 (INPUT tt-despes-decla-import.num-di-ems,
                                        INPUT tt-decla-import.cdd-siscomex-dts).

    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getCharField IN h-bocx407 (INPUT "cod-embarq":U, OUTPUT c-embarque).
        RUN getCharField IN h-bocx407 (INPUT "cod-estab":U, OUTPUT c-cod-estab).

        RUN findDespesa IN h-bocx310 (INPUT c-cod-estab,
                                      INPUT c-embarque,
                                      INPUT INTEGER(tt-despes-decla-import.cdn-despes:SCREEN-VALUE IN FRAME fPage0),
                                      OUTPUT c-return).

        IF c-return = "":U THEN DO:
            RUN getCharField IN h-bocx310 (INPUT "descricao":U,
                                           OUTPUT c-desc-despesa).
            DISPLAY c-desc-despesa WITH FRAME fPage0.
        END.
    END.
                          
    IF TRIM(c-desc-despesa) = "":U THEN DO:
        {method/referencefields.i &HandleDBOLeave="h-bocx095"
                                  &FindMethod="findCodigo"
                                  &KeyValue1="tt-despes-decla-import.cdn-despes:SCREEN-VALUE IN FRAME fPage0"
                                  &FieldName1="descricao"
                                  &FieldScreen1="c-desc-despesa"
                                  &Frame1="fPage0"}
    END.

    if  tt-despes-decla-import.cdn-despes:modified in frame fPage0 then do:
        run pi-habilita-incoterm-rateio in h-bocx310 (input input frame fPage0 tt-despes-decla-import.cdn-despes,  
                                                      input input frame fPage0 tt-decla-import.cod-estab,
                                                      output l-incoterm-rat).

        run openQuery    in h-bocx095 (input 1).
        run findCodigo   in h-bocx095 (input  input frame fPage0 tt-despes-decla-import.cdn-despes,
                                       output c-return).

        if  not l-incoterm-rat then do:
            assign tt-despes-decla-import.cod-incoterm-rat:screen-value in frame fPage0 = "".
            disable tt-despes-decla-import.cod-incoterm-rat with frame fPage0.
        end.
        else do:
            enable tt-despes-decla-import.cod-incoterm-rat with frame fPage0.
            if  c-return = "" then do:
                run getCharField in h-bocx095 (input  "cod-incoterm-rat":U,
                                               output tt-despes-decla-import.cod-incoterm-rat).
                assign tt-despes-decla-import.cod-incoterm-rat:screen-value in frame fPage0 = tt-despes-decla-import.cod-incoterm-rat.
            end.
            ELSE 
                assign tt-despes-decla-import.cod-incoterm-rat:screen-value in frame fPage0 = ""
                       tt-despes-decla-import.cdn-emit-despes:SCREEN-VALUE IN FRAME fPage0 = "".
        end.
        IF  c-return = "" THEN DO:
            run getIntField in h-bocx095 (input  "cod-emitente":U, 
                                          output i-cod-emitente).

            ASSIGN tt-despes-decla-import.cdn-emit-despes:SCREEN-VALUE IN FRAME fPage0 = string(i-cod-emitente).
            APPLY "leave" TO tt-despes-decla-import.cdn-emit-despes IN FRAME fPage0.
        END.
        ELSE
            ASSIGN tt-despes-decla-import.cdn-emit-despes:SCREEN-VALUE IN FRAME fPage0 = "".

        RUN getCharField IN h-bocx095 (INPUT "char-1":U, OUTPUT c-return).
        ASSIGN tt-despes-decla-import.log-livre-1:CHECKED IN FRAME fPage0 = IF SUBSTRING(c-return,44,1) = "1"  THEN YES ELSE NO.

        assign tt-despes-decla-import.cdn-despes:modified in frame fPage0 = no.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-decla-import.cdn-despes wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-despes-decla-import.cdn-despes IN FRAME fPage0 /* Despesa */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-despes-decla-import.cdn-emit-despes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-decla-import.cdn-emit-despes wMaintenanceNoNavigation
ON F5 OF tt-despes-decla-import.cdn-emit-despes IN FRAME fPage0 /* Fornec Despesa */
DO:
   {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
                      &campo="tt-despes-decla-import.cdn-emit-despes"
                      &campozoom="cod-emitente"
                      &frame="fPage0"
                      &campo2="c-desc-fornecedor"
                      &campozoom2="nome-abrev"
                      &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-decla-import.cdn-emit-despes wMaintenanceNoNavigation
ON LEAVE OF tt-despes-decla-import.cdn-emit-despes IN FRAME fPage0 /* Fornec Despesa */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-boad098"
      &FindMethod="findCodigo"
      &KeyValue1="tt-despes-decla-import.cdn-emit-despes:SCREEN-VALUE IN FRAME fPage0"
      &FieldName1="nome-abrev"
      &FieldScreen1="c-desc-fornecedor"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-decla-import.cdn-emit-despes wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-despes-decla-import.cdn-emit-despes IN FRAME fPage0 /* Fornec Despesa */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-despes-decla-import.cdn-moeda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-decla-import.cdn-moeda wMaintenanceNoNavigation
ON F5 OF tt-despes-decla-import.cdn-moeda IN FRAME fPage0 /* C¢digo Moeda */
DO:
    {include/zoomvar.i &prog-zoom=unzoom/z01un005.w
                           &campo=tt-despes-decla-import.cdn-moeda
                           &campozoom=mo-codigo
                           &frame=fpage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-decla-import.cdn-moeda wMaintenanceNoNavigation
ON LEAVE OF tt-despes-decla-import.cdn-moeda IN FRAME fPage0 /* C¢digo Moeda */
DO:
    {method/referencefields.i
        &HandleDBOLeave="h-boun005"
        &FindMethod="findCodigo"
        &KeyValue1="int(tt-despes-decla-import.cdn-moeda:SCREEN-VALUE IN FRAME fPage0)"
        &FieldName1="descricao"
        &FieldScreen1="c-desc-moeda"
        &Frame1="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-decla-import.cdn-moeda wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-despes-decla-import.cdn-moeda IN FRAME fPage0 /* C¢digo Moeda */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-despes-decla-import.val-despes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-decla-import.val-despes wMaintenanceNoNavigation
ON LEAVE OF tt-despes-decla-import.val-despes IN FRAME fPage0 /* Valor Despesa */
DO:
  RUN pi-valida-cot-desp-compl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
ASSIGN tt-decla-import.cod-di-siscomex:FORMAT IN FRAME fPage0 = "x(20)".

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

IF VALID-HANDLE(h-bocx110) THEN DO:
    DELETE PROCEDURE h-bocx110.
    ASSIGN h-bocx110 = ?.
END.

IF VALID-HANDLE(h-boad098na) THEN DO:
    DELETE PROCEDURE h-boad098na.
    ASSIGN h-boad098na = ?.
END.

IF VALID-HANDLE(h-boad039na) THEN DO:
    DELETE PROCEDURE h-boad039na.
    ASSIGN h-boad039na = ?.
END.

IF VALID-HANDLE(h-bocx095) THEN DO:
    DELETE PROCEDURE h-bocx095.
    ASSIGN h-bocx095 = ?.
END.

IF VALID-HANDLE(h-boun005) THEN DO:
    DELETE PROCEDURE h-boun005.
    ASSIGN h-boun005 = ?.
END.

IF VALID-HANDLE(h-bocx407) THEN DO:
    DELETE PROCEDURE h-bocx407.
    ASSIGN h-bocx407 = ?.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    IF  pcAction = "UPDATE" THEN DO:
        DISABLE tt-despes-decla-import.cdn-despes tt-despes-decla-import.cdn-emit-despes WITH FRAME fPage0.
        APPLY 'LEAVE' TO tt-despes-decla-import.cdn-cond-pagto  IN FRAME fPage0.
        APPLY 'LEAVE' TO tt-despes-decla-import.cdn-emit-despes IN FRAME fPage0.
        APPLY 'LEAVE' TO tt-despes-decla-import.cdn-desp        IN FRAME fPage0.
        APPLY 'LEAVE' TO tt-despes-decla-import.cdn-moeda       IN FRAME fPage0.

    END.

    RUN pi-trata-combos(YES).

    /*--- busca o codigo da despesa siscomex do parametro e desabilita os campos, exceto o valor ---*/
    RUN pi-busca-despes-siscomex IN h-bocx406(INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                              INPUT tt-decla-import.cdd-siscomex-dts,
                                              OUTPUT i-cdn-despes-siscomex, 
                                              OUTPUT i-cdn-emit-siscomex,
                                              OUTPUT l-taxa-siscomex).
    IF i-cdn-despes-siscomex = INPUT FRAME fPage0 tt-despes-decla-import.cdn-despes AND
       l-taxa-siscomex THEN DO:
        DISABLE tt-despes-decla-import.val-despes
            WITH FRAME fPage0.
    END.

    /*----------------------------------------------------------------------------------------------*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveFields wMaintenanceNoNavigation 
PROCEDURE afterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN pi-trata-combos(NO).

ASSIGN c-desc-despesa:screen-value in frame fPage0    = ""
       c-desc-fornecedor:screen-value in frame fPage0 = ""
       c-desc-pagto:screen-value in frame fPage0      = ""
       c-desc-moeda:screen-value in frame fPage0      = "".

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    IF NOT VALID-HANDLE(h-bocx110) THEN DO:
        RUN cxbo/bocx110.p PERSISTENT SET h-bocx110.
    END.

    IF NOT VALID-HANDLE (h-boad098na) THEN DO:
        RUN adbo/boad098na.p PERSISTENT SET h-boad098na.
        RUN openQueryStatic IN h-boad098na (INPUT "Main":U) NO-ERROR.
    END.

    IF NOT VALID-HANDLE (h-boad039na) THEN DO:
        RUN adbo/boad039na.p PERSISTENT SET h-boad039na.
        RUN openQueryStatic IN h-boad039na (INPUT "Main":U) NO-ERROR.
    END.

    IF NOT VALID-HANDLE (h-bocx095) THEN DO:
        RUN cxbo/bocx095.p PERSISTENT SET h-bocx095.
        RUN openQueryStatic IN h-bocx095 (INPUT "Main":U)   NO-ERROR.
    END.

    IF NOT VALID-HANDLE (h-bocx310) THEN DO:
        RUN cxbo/bocx310.p PERSISTENT SET h-bocx310.
        RUN openQueryStatic IN h-bocx310 (INPUT "Main":U)   NO-ERROR.
    END.
        
    IF NOT VALID-HANDLE (h-boad098) THEN DO:
        RUN adbo/boad098.p PERSISTENT SET h-boad098.
        RUN openQueryStatic IN h-boad098 (INPUT "Main":U)   NO-ERROR.
    END.

    IF NOT VALID-HANDLE (h-bocx407) THEN 
        RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.

    RUN openQueryStatic IN h-bocx407 (INPUT "Main":U)   NO-ERROR.
    
    IF NOT VALID-HANDLE (h-boun005) THEN DO:
        RUN unbo/boun005na.p PERSISTENT SET h-boun005.
        RUN openQueryStatic IN h-boun005 (INPUT "Main":U)   NO-ERROR.
    END.

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao001 = {cxinc/i01cx406.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN cb-tipo-incide-nf:LIST-ITEM-PAIRS         in frame fPage0 = cAuxTraducao001.
    &else
        ASSIGN cb-tipo-incide-nf:list-items              in frame fPage0 = {cxinc/i01cx406.i 03}.
    &endif


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-assign wMaintenanceNoNavigation 
PROCEDURE pi-assign :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    ASSIGN tt-despes-decla-import.num-di-ems                = tt-decla-import.num-di-ems
           tt-despes-decla-import.cdd-siscomex-dts          = tt-decla-import.cdd-siscomex-dts
           tt-despes-decla-import.cdn-cond-pagto            = INPUT FRAME fPage0 tt-despes-decla-import.cdn-cond-pagto
           tt-despes-decla-import.cdn-moed                  = INPUT FRAME fPage0 tt-despes-decla-import.cdn-moed
           tt-despes-decla-import.cdn-despes                = INPUT FRAME fPage0 tt-despes-decla-import.cdn-despes
           tt-despes-decla-import.cdn-emit-despes           = INPUT FRAME fPage0 tt-despes-decla-import.cdn-emit-despes
           tt-despes-decla-import.cod-incoterm-rat          = INPUT FRAME fPage0 tt-despes-decla-import.cod-incoterm-rat
           tt-despes-decla-import.log-forma-preco-compra    = INPUT FRAME fPage0 tt-despes-decla-import.log-forma-preco-compra
           tt-despes-decla-import.val-cotac-despes-compltar = INPUT FRAME fPage0 tt-despes-decla-import.val-cotac-despes-compltar
           tt-despes-decla-import.val-despes                = INPUT FRAME fPage0 tt-despes-decla-import.val-despes.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-incide-vmle wMaintenanceNoNavigation 
PROCEDURE pi-habilita-incide-vmle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN INPUT FRAME fPage0 cb-tipo-incide-nf 
           tt-despes-decla-import.idi-tip-incid-nf = {cxinc/i01cx406.i 06 cb-tipo-incide-nf}.

    IF tt-despes-decla-import.idi-tip-incid-nf <> 1 THEN
        DISABLE tt-despes-decla-import.log-incid-vmle WITH FRAME fPage0.
    ELSE
        ENABLE  tt-despes-decla-import.log-incid-vmle WITH FRAME fPage0.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-combos wMaintenanceNoNavigation 
PROCEDURE pi-trata-combos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pLogGravarMostrar AS LOGICAL NO-UNDO.
    DEF VAR pc-pto-control LIKE despes-decla-import.cdn-pto-control NO-UNDO.

    IF AVAIL tt-decla-import THEN
        IF pLogGravarMostrar THEN DO:
            ASSIGN cb-tipo-incide-nf:screen-value  in frame fPage0 = {cxinc/i01cx406.i 04 tt-despes-decla-import.idi-tip-incid-nf}.
        END.
        ELSE DO:
            ASSIGN INPUT FRAME fPage0 cb-tipo-incide-nf 
                   tt-despes-decla-import.idi-tip-incid-nf = {cxinc/i01cx406.i 06 cb-tipo-incide-nf}.
            RUN salvaPontoControle IN h-bocx406 (INPUT tt-despes-decla-import.idi-tip-incid-nf,
                                                 INPUT tt-despes-decla-import.num-di-ems,
                                                 INPUT tt-decla-import.cdd-siscomex-dts,
                                                 OUTPUT pc-pto-control).

            ASSIGN tt-despes-decla-import.cdn-pto-control = pc-pto-control.

        END.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-cot-desp-compl wMaintenanceNoNavigation 
PROCEDURE pi-valida-cot-desp-compl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF INPUT FRAME fPage0 tt-despes-decla-import.cdn-moed = 0 THEN
    ASSIGN tt-despes-decla-import.val-cotac-despes-compltar:SENSITIVE IN FRAME fPage0 = NO.
ELSE DO:
    ASSIGN l-retorno = NO.
    /*RUN pi-valida-ponto-controle-chegada IN h-bocx406 (INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                                       INPUT INPUT FRAME fPage0 tt-despes-decla-import.cdn-pto-control,
                                                       OUTPUT l-retorno).*/
    IF l-retorno THEN
        ASSIGN tt-despes-decla-import.val-cotac-despes-compltar:SENSITIVE IN FRAME fPage0 = YES.
    ELSE
        ASSIGN tt-despes-decla-import.val-cotac-despes-compltar:SENSITIVE IN FRAME fPage0 = NO.
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
    ASSIGN tt-despes-decla-import.num-di-ems = tt-decla-import.num-di-ems.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

