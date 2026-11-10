&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mgcex            PROGRESS
          mguni            PROGRESS
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-despes-ped-compra NO-UNDO LIKE despes-ped-compra
       Field r-rowid as rowid.
DEFINE TEMP-TABLE tt-pedido-compr NO-UNDO LIKE pedido-compr
       Field r-rowid as rowid
       Field rowNum  as int.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0300A 2.00.00.011 } /*** "010011" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0300a MIM}
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
&GLOBAL-DEFINE Program           IM0300A
&GLOBAL-DEFINE Version        2.00.00.010

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-despes-ped-compra
&GLOBAL-DEFINE hDBOTable         h-bocx341
&GLOBAL-DEFINE DBOTable          despes-ped-compra

&GLOBAL-DEFINE ttParent          tt-pedido-compr
&GLOBAL-DEFINE DBOParentTable    pedido-compr

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-pedido-compr.num-pedido ~
                                 tt-pedido-compr.data-pedido ~
                                 tt-pedido-compr.cod-emitente
&GLOBAL-DEFINE page1Fields       tt-despes-ped-compra.cod-desp ~
                                 tt-despes-ped-compra.cod-emitente ~
                                 tt-despes-ped-compra.mo-codigo ~
                                 tt-despes-ped-compra.cod-cond-pag ~
                                 tt-despes-ped-compra.cod-pto-contr ~
                                 tt-despes-ped-compra.tp-despesa ~
                                 tt-despes-ped-compra.cod-incoterm-rat ~
                                 tt-despes-ped-compra.val-desp

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---    */
DEFINE VARIABLE c-cgc                  AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE c-retorno              AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE i-tipo                 AS INTEGER                            NO-UNDO.
DEFINE VARIABLE l-imposto              AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE i-tipo-alteracao       AS INTEGER INITIAL 1                  NO-UNDO.
DEFINE VARIABLE i-sequencia            LIKE despes-ped-compra.sequencia      NO-UNDO.
DEFINE VARIABLE cod-cond-pag-ant       LIKE despes-ped-compra.cod-cond-pag   NO-UNDO.
DEFINE VARIABLE cod-pto-contr-ant      LIKE despes-ped-compra.cod-pto-contr  NO-UNDO.
DEFINE VARIABLE tp-despesa-ant         LIKE despes-ped-compra.tp-despesa     NO-UNDO.
DEFINE VARIABLE de-val-desp-ant        LIKE despes-ped-compra.val-desp       NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE h-boad039      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad098      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad259      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx095      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx110      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx115      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx140      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx155      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx250      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx341      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin295desc  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boun005      AS HANDLE NO-UNDO.


/*--- Vari veis definidas para que se possa utilizar o zoom feito em Smart Objects ---*/
DEFINE NEW GLOBAL SHARED VARIABLE is-cod-itiner  AS INTEGER NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE  NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE  NO-UNDO.

{include/boerrtab.i} /* DefinicÆo tt-bo-erro */

DEFINE TEMP-TABLE tt-despesas NO-UNDO
    FIELD cod-desp          LIKE desp-imp.cod-desp
    FIELD val-desp          LIKE despes-ped-compra.val-desp
    FIELD mo-codigo         LIKE despes-ped-compra.mo-codigo
    FIELD cod-emitente-desp LIKE despes-ped-compra.cod-emitente-desp
    FIELD cod-cond-pag      LIKE despes-ped-compra.cod-cond-pag
    FIELD cod-pto-contr     LIKE despes-ped-compra.cod-pto-contr
    FIELD cod-incoterm-rat  LIKE despes-ped-compra.cod-incoterm-rat
    FIELD tp-despesa        LIKE despes-ped-compra.tp-despesa.

DEFINE TEMP-TABLE tt-pedidos NO-UNDO
    FIELD num-pedido          LIKE despes-ped-compra.num-pedido.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-pedido-compr.num-pedido ~
tt-pedido-compr.data-pedido tt-pedido-compr.cod-emitente 
&Scoped-define DISPLAYED-TABLES tt-pedido-compr
&Scoped-define FIRST-DISPLAYED-TABLE tt-pedido-compr
&Scoped-Define DISPLAYED-OBJECTS cb-situacao c-nome-abrev cb-natureza ~
c-nr-proc-imp c-incoterm i-cod-itiner c-desc-itiner 

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

DEFINE VARIABLE cb-natureza AS CHARACTER FORMAT "X(256)":U 
     LABEL "Natureza" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE cb-situacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Situa‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-itiner AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE c-incoterm AS CHARACTER FORMAT "X(03)":U 
     LABEL "Incoterm" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-proc-imp AS CHARACTER FORMAT "X(12)":U 
     LABEL "Processo Imp" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-itiner AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Itiner rio" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE c-desc-cond-pagto LIKE cond-pagto.descricao
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-desp AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-emit AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-moeda LIKE moeda.descricao
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-pto-contr LIKE pto-contr.descricao
     VIEW-AS FILL-IN 
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tipo-despesa LIKE desp-imp.descricao
     VIEW-AS FILL-IN 
     SIZE 33 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-pedido-compr.num-pedido AT ROW 1.5 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-pedido-compr.data-pedido AT ROW 1.5 COL 39 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cb-situacao AT ROW 1.5 COL 67 COLON-ALIGNED
     tt-pedido-compr.cod-emitente AT ROW 2.5 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-nome-abrev AT ROW 2.5 COL 28 COLON-ALIGNED NO-LABEL
     cb-natureza AT ROW 2.5 COL 67 COLON-ALIGNED
     c-nr-proc-imp AT ROW 3.5 COL 18 COLON-ALIGNED
     c-incoterm AT ROW 3.5 COL 36 COLON-ALIGNED
     i-cod-itiner AT ROW 3.5 COL 44
     c-desc-itiner AT ROW 3.5 COL 57 COLON-ALIGNED NO-LABEL
     btOK AT ROW 14.25 COL 2
     btSave AT ROW 14.25 COL 13
     btCancel AT ROW 14.25 COL 24
     btHelp AT ROW 14.25 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 14 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14.5
         FONT 1.

DEFINE FRAME fPage1
     tt-despes-ped-compra.cod-desp AT ROW 1.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-desp AT ROW 1.5 COL 36 COLON-ALIGNED NO-LABEL
     tt-despes-ped-compra.cod-emitente-desp AT ROW 2.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-desc-emit AT ROW 2.5 COL 40 COLON-ALIGNED NO-LABEL
     tt-despes-ped-compra.mo-codigo AT ROW 3.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3 BY .88
     c-desc-moeda AT ROW 3.5 COL 33 COLON-ALIGNED HELP
          "" NO-LABEL
     tt-despes-ped-compra.cod-cond-pag AT ROW 4.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-desc-cond-pagto AT ROW 4.5 COL 35 COLON-ALIGNED HELP
          "" NO-LABEL
     tt-despes-ped-compra.cod-pto-contr AT ROW 5.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-pto-contr AT ROW 5.5 COL 36 COLON-ALIGNED HELP
          "" NO-LABEL
     tt-despes-ped-compra.tp-despesa AT ROW 6.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     c-desc-tipo-despesa AT ROW 6.5 COL 34 COLON-ALIGNED HELP
          "" NO-LABEL
     tt-despes-ped-compra.cod-incoterm-rat AT ROW 7.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     tt-despes-ped-compra.val-desp AT ROW 8.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5
         SIZE 84.43 BY 8.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-despes-ped-compra T "?" NO-UNDO mgcex despes-ped-compra
      ADDITIONAL-FIELDS:
          Field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-pedido-compr T "?" NO-UNDO movind pedido-compr
      ADDITIONAL-FIELDS:
          Field r-rowid as rowid
          Field rowNum  as int
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
         HEIGHT             = 14.5
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-desc-itiner IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-incoterm IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-abrev IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nr-proc-imp IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-natureza IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-situacao IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-pedido-compr.cod-emitente IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-pedido-compr.data-pedido IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-itiner IN FRAME fpage0
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN tt-pedido-compr.num-pedido IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN c-desc-cond-pagto IN FRAME fPage1
   NO-ENABLE LIKE = mgadm.cond-pagto.descricao EXP-SIZE                 */
/* SETTINGS FOR FILL-IN c-desc-desp IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-emit IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-moeda IN FRAME fPage1
   NO-ENABLE LIKE = mguni.moeda.descricao EXP-LABEL EXP-SIZE            */
/* SETTINGS FOR FILL-IN c-desc-pto-contr IN FRAME fPage1
   NO-ENABLE LIKE = mgcex.pto-contr.descricao EXP-LABEL EXP-SIZE        */
/* SETTINGS FOR FILL-IN c-desc-tipo-despesa IN FRAME fPage1
   NO-ENABLE LIKE = mgcex.desp-imp.descricao EXP-LABEL EXP-SIZE         */
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
    RUN pi-valida (INPUT 1).
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN pi-valida (INPUT 2).
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        IF  VALID-HANDLE(phCaller) THEN
            RUN openQueriesSon IN phCaller NO-ERROR.
    END.
    ELSE 
        APPLY "entry":U TO tt-despes-ped-compra.cod-desp IN FRAME fPage1.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN pi-valida (INPUT 1).
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN
        RUN pi-valida (INPUT 2).
    APPLY "entry":U TO tt-despes-ped-compra.cod-desp IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-despes-ped-compra.cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-ped-compra.cod-cond-pag wMaintenanceNoNavigation
ON F5 OF tt-despes-ped-compra.cod-cond-pag IN FRAME fPage1 /* Condi‡Æo Pagamento */
DO:
    {include/zoomvar.i &prog-zoom = adzoom/z01ad039.w
                       &campo=tt-despes-ped-compra.cod-cond-pag
                       &campozoom=cod-cond-pag
                       &campo2=c-desc-cond-pagto
                       &campozoom2=descricao
                       &FRAME = "fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-ped-compra.cod-cond-pag wMaintenanceNoNavigation
ON LEAVE OF tt-despes-ped-compra.cod-cond-pag IN FRAME fPage1 /* Condi‡Æo Pagamento */
DO:
    RUN findCodigo IN h-boad039 (INPUT  INT(tt-despes-ped-compra.cod-cond-pag:SCREEN-VALUE IN FRAME fPage1),
                                 OUTPUT c-retorno).
    IF c-retorno = "":U THEN
        RUN getCharField IN h-boad039 (INPUT  "descricao":U,
                                       OUTPUT c-desc-cond-pagto).
    ELSE 
        ASSIGN c-desc-cond-pagto = "":U.

    ASSIGN c-desc-cond-pagto:SCREEN-VALUE IN FRAME fPage1 = c-desc-cond-pagto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-ped-compra.cod-cond-pag wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-despes-ped-compra.cod-cond-pag IN FRAME fPage1 /* Condi‡Æo Pagamento */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-despes-ped-compra.cod-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-ped-compra.cod-desp wMaintenanceNoNavigation
ON F5 OF tt-despes-ped-compra.cod-desp IN FRAME fPage1 /* C¢digo Despesa */
DO:
    {include/zoomvar.i &prog-zoom = cxzoom/z01cx095.w
                       &campo=tt-despes-ped-compra.cod-desp
                       &campozoom=cod-desp
                       &campo2=c-desc-desp
                       &campozoom2=descricao
                       &FRAME = "fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-ped-compra.cod-desp wMaintenanceNoNavigation
ON LEAVE OF tt-despes-ped-compra.cod-desp IN FRAME fPage1 /* C¢digo Despesa */
DO:
    RUN retornaDescDespesa IN h-bocx095 (INPUT  INT(tt-despes-ped-compra.cod-desp:SCREEN-VALUE IN FRAME fPage1),
                                         OUTPUT c-desc-desp).

    ASSIGN c-desc-desp:SCREEN-VALUE IN FRAME fPage1 = c-desc-desp.    
    
    RUN findCodigo  IN h-bocx095 (INPUT  tt-despes-ped-compra.cod-desp:SCREEN-VALUE IN FRAME fPage1,
                                  OUTPUT c-retorno).
    IF c-retorno = "":U THEN DO:
        IF pcAction = "ADD":U THEN DO:

            RUN getIntField  IN h-bocx095 (INPUT "cod-emitente":U, OUTPUT tt-despes-ped-compra.cod-emitente-desp).

            RUN getIntField  IN h-bocx095 (INPUT "tp-despesa":U, OUTPUT tt-despes-ped-compra.tp-despesa).

            RUN getCharField IN h-bocx095 (INPUT "cod-incoterm-rat":U, OUTPUT tt-despes-ped-compra.cod-incoterm-rat).
            
            DISP tt-despes-ped-compra.cod-emitente-desp 
                 tt-despes-ped-compra.tp-despesa 
                 tt-despes-ped-compra.cod-incoterm-rat WITH FRAME fPage1.
            
            APPLY "LEAVE":U TO tt-despes-ped-compra.cod-emitente-desp IN FRAME fPage1.
            APPLY "LEAVE":U TO tt-despes-ped-compra.tp-despesa        IN FRAME fPage1.
        END.
        RUN pi-incoterm.
        IF l-imposto THEN DO:
            ASSIGN tt-despes-ped-compra.val-desp:SENSITIVE    IN FRAME fPage1 = NO
                   tt-despes-ped-compra.val-desp:SCREEN-VALUE IN FRAME fPage1 = STRING(0).
            RUN utp/ut-msgs.p (INPUT "Show":U, INPUT 32051,"":U).
        END.
        ELSE
            ASSIGN tt-despes-ped-compra.val-desp:SENSITIVE IN FRAME fPage1 = YES.
    END.                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-ped-compra.cod-desp wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-despes-ped-compra.cod-desp IN FRAME fPage1 /* C¢digo Despesa */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-despes-ped-compra.cod-emitente-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-ped-compra.cod-emitente-desp wMaintenanceNoNavigation
ON F5 OF tt-despes-ped-compra.cod-emitente-desp IN FRAME fPage1 /* Fornec Despesa */
DO:
    {include/zoomvar.i &prog-zoom = adzoom/z03ad098.w
                       &campo=tt-despes-ped-compra.cod-emitente-desp
                       &campozoom=cod-emitente
                       &campo2=c-desc-emit
                       &campozoom2=nome-abrev
                       &FRAME = "fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-ped-compra.cod-emitente-desp wMaintenanceNoNavigation
ON LEAVE OF tt-despes-ped-compra.cod-emitente-desp IN FRAME fPage1 /* Fornec Despesa */
DO:
    RUN getDescCgcEmitente  IN h-boin295desc (INPUT  INT(tt-despes-ped-compra.cod-emitente-desp:SCREEN-VALUE IN FRAME fPage1),
                                              OUTPUT c-desc-emit,
                                              OUTPUT c-cgc).
    ASSIGN c-desc-emit:SCREEN-VALUE IN FRAME fPage1 = c-desc-emit.

    IF pcAction = "ADD":U THEN DO:
        RUN findCodigo  IN h-boad098 (INPUT  tt-despes-ped-compra.cod-emitente-desp:SCREEN-VALUE IN FRAME fPage1,
                                      OUTPUT c-retorno).
        IF c-retorno = "":U THEN DO:

            IF tt-despes-ped-compra.tp-despesa:SCREEN-VALUE IN FRAME fpage1 = "0":U THEN
                RUN getIntField IN h-boad098 (INPUT "tp-desp-padrao":U, OUTPUT tt-despes-ped-compra.tp-despesa).

            RUN getIntField IN h-boad098 (INPUT "cod-cond-pag":U, OUTPUT tt-despes-ped-compra.cod-cond-pag).
        END.

        RUN findPk-emitente IN h-bocx155 (INPUT tt-despes-ped-compra.cod-emitente-desp:SCREEN-VALUE IN FRAME fPage1,
                                          OUTPUT c-retorno).
        IF c-retorno = "":U THEN
            RUN getCharField IN h-bocx155 (INPUT "cod-pto-contr":U,
                                           OUTPUT tt-despes-ped-compra.cod-pto-contr).
        
        DISP tt-despes-ped-compra.cod-cond-pag 
             tt-despes-ped-compra.cod-pto-contr
             tt-despes-ped-compra.tp-despesa
             WITH FRAME fPage1.
            
        APPLY "LEAVE":U TO tt-despes-ped-compra.cod-cond-pag  IN FRAME fPage1.
        APPLY "LEAVE":U TO tt-despes-ped-compra.cod-pto-contr IN FRAME fPage1.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-ped-compra.cod-emitente-desp wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-despes-ped-compra.cod-emitente-desp IN FRAME fPage1 /* Fornec Despesa */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-despes-ped-compra.cod-incoterm-rat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-ped-compra.cod-incoterm-rat wMaintenanceNoNavigation
ON F5 OF tt-despes-ped-compra.cod-incoterm-rat IN FRAME fPage1 /* Incoterm de Rateio */
DO:
   {method/zoomfields.i &ProgramZoom  = "cxzoom/z10cx025.w"
                                        &FieldZoom1   = cod-incoterm
                                        &FieldScreen1 = tt-despes-ped-compra.cod-incoterm
                                        &Frame1       = fPage1}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-ped-compra.cod-incoterm-rat wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-despes-ped-compra.cod-incoterm-rat IN FRAME fPage1 /* Incoterm de Rateio */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-despes-ped-compra.cod-pto-contr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-ped-compra.cod-pto-contr wMaintenanceNoNavigation
ON F5 OF tt-despes-ped-compra.cod-pto-contr IN FRAME fPage1 /* Ponto Controle */
DO:
    {include/zoomvar.i &prog-zoom = cxzoom/z01cx120.w
                       &campo=tt-despes-ped-compra.cod-pto-contr
                       &campozoom=cod-pto-contr
                       &FRAME = "fPage1"} 
                       
    WAIT-FOR CLOSE OF wh-pesquisa.
    APPLY "leave":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-ped-compra.cod-pto-contr wMaintenanceNoNavigation
ON LEAVE OF tt-despes-ped-compra.cod-pto-contr IN FRAME fPage1 /* Ponto Controle */
DO:
    RUN retornaDescricao IN h-bocx110 (INPUT  tt-despes-ped-compra.cod-pto-contr:SCREEN-VALUE IN FRAME fPage1,
                                       OUTPUT c-desc-pto-contr).

    ASSIGN c-desc-pto-contr:SCREEN-VALUE IN FRAME fPage1 = c-desc-pto-contr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-ped-compra.cod-pto-contr wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-despes-ped-compra.cod-pto-contr IN FRAME fPage1 /* Ponto Controle */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-despes-ped-compra.mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-ped-compra.mo-codigo wMaintenanceNoNavigation
ON F5 OF tt-despes-ped-compra.mo-codigo IN FRAME fPage1 /* C¢digo Moeda */
DO:
    {include/zoomvar.i &prog-zoom = adzoom/z01ad178.w
                       &campo=tt-despes-ped-compra.mo-codigo
                       &campozoom=mo-codigo
                       &campo2=c-desc-moeda
                       &campozoom2=descricao
                       &FRAME = "fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-ped-compra.mo-codigo wMaintenanceNoNavigation
ON LEAVE OF tt-despes-ped-compra.mo-codigo IN FRAME fPage1 /* C¢digo Moeda */
DO:
    RUN findCodigo IN h-boun005 (INPUT  INT(tt-despes-ped-compra.mo-codigo:SCREEN-VALUE IN FRAME fPage1),
                                 OUTPUT c-retorno).
    IF c-retorno = "":U THEN
        RUN getCharField IN h-boun005(INPUT  "descricao":U, OUTPUT c-desc-moeda).
    ELSE
        ASSIGN c-desc-moeda = "":U.

    ASSIGN c-desc-moeda:SCREEN-VALUE IN FRAME fPage1 = c-desc-moeda.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-ped-compra.mo-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-despes-ped-compra.mo-codigo IN FRAME fPage1 /* C¢digo Moeda */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-despes-ped-compra.tp-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-ped-compra.tp-despesa wMaintenanceNoNavigation
ON F5 OF tt-despes-ped-compra.tp-despesa IN FRAME fPage1 /* Tipo Despesa */
DO:
    {include/zoomvar.i &prog-zoom = adzoom/z01ad259.w
                       &campo=tt-despes-ped-compra.tp-despesa
                       &campozoom=tp-codigo
                       &campo2=c-desc-tipo-despesa
                       &campozoom2=descricao
                       &FRAME = "fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-ped-compra.tp-despesa wMaintenanceNoNavigation
ON LEAVE OF tt-despes-ped-compra.tp-despesa IN FRAME fPage1 /* Tipo Despesa */
DO:
    RUN findCodigo IN h-boad259 (INPUT  tt-despes-ped-compra.tp-despesa:SCREEN-VALUE IN FRAME fPage1,
                                 OUTPUT c-retorno).
    IF c-retorno = "":U THEN
        RUN getCharField IN h-boad259 (INPUT  "descricao":U, OUTPUT c-desc-tipo-despesa).
    ELSE
        ASSIGN c-desc-tipo-despesa = "":U.
    
    ASSIGN c-desc-tipo-despesa:SCREEN-VALUE IN FRAME fPage1 = c-desc-tipo-despesa.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-ped-compra.tp-despesa wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-despes-ped-compra.tp-despesa IN FRAME fPage1 /* Tipo Despesa */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-despes-ped-compra.cod-desp:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-despes-ped-compra.cod-emitente-desp:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-despes-ped-compra.mo-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-despes-ped-compra.cod-cond-pag:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-despes-ped-compra.cod-pto-contr:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-despes-ped-compra.tp-despesa:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-despes-ped-compra.cod-incoterm:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.

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
    IF  VALID-HANDLE(h-boin295desc) THEN DO:
        DELETE PROCEDURE h-boin295desc.
        ASSIGN h-boin295desc = ?.
    END.

    IF  VALID-HANDLE(h-bocx140) THEN DO:
        DELETE PROCEDURE h-bocx140.
        ASSIGN h-bocx140 = ?.
    END.

    IF  VALID-HANDLE(h-bocx115) THEN DO:
        DELETE PROCEDURE h-bocx115.
        ASSIGN h-bocx115 = ?.
    END.

    IF  VALID-HANDLE(h-bocx095) THEN DO:
        DELETE PROCEDURE h-bocx095.
        ASSIGN h-bocx095 = ?.
    END.

    IF  VALID-HANDLE(h-boun005) THEN DO:
        DELETE PROCEDURE h-boun005.
        ASSIGN h-boun005 = ?.
    END.

    IF  VALID-HANDLE(h-boad039) THEN DO:
        DELETE PROCEDURE h-boad039.
        ASSIGN h-boad039 = ?.
    END.                           

    IF  VALID-HANDLE(h-bocx110) THEN DO:
        DELETE PROCEDURE h-bocx110.
        ASSIGN h-bocx110 = ?.
    END.

    IF  VALID-HANDLE(h-boad259) THEN DO:
        DELETE PROCEDURE h-boad259.
        ASSIGN h-boad259 = ?.
    END.

    IF  VALID-HANDLE(h-boad098) THEN DO:
        DELETE PROCEDURE h-boad098.
        ASSIGN h-boad098 = ?.
    END.

    IF  VALID-HANDLE(h-bocx155) THEN DO:
        DELETE PROCEDURE h-bocx155.
        ASSIGN h-bocx155 = ?.
    END.

    IF  VALID-HANDLE(h-bocx250) THEN DO:
        DELETE PROCEDURE h-bocx250.
        ASSIGN h-bocx250 = ?.
    END.

    IF VALID-HANDLE (hShowMsg) THEN DO:
        DELETE PROCEDURE hShowMsg.
        ASSIGN hShowMsg = ?.
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
    RUN retornaDescDespesa IN h-bocx095 (INPUT  INT(tt-despes-ped-compra.cod-desp:SCREEN-VALUE IN FRAME fPage1),
                                         OUTPUT c-desc-desp).

    RUN getDescCgcEmitente  IN h-boin295desc (INPUT  INT(tt-despes-ped-compra.cod-emitente-desp:SCREEN-VALUE IN FRAME fPage1),
                                              OUTPUT c-desc-emit,
                                              OUTPUT c-cgc).

    RUN findCodigo IN h-boun005 (INPUT  INT(tt-despes-ped-compra.mo-codigo:SCREEN-VALUE IN FRAME fPage1),
                                 OUTPUT c-retorno).
    IF c-retorno = "":U THEN
        RUN getCharField IN h-boun005(INPUT "descricao":U, OUTPUT c-desc-moeda).
    ELSE
        ASSIGN c-desc-moeda = "":U.

    RUN findCodigo IN h-boad039 (INPUT  INT(tt-despes-ped-compra.cod-cond-pag:SCREEN-VALUE IN FRAME fPage1),
                                 OUTPUT c-retorno).
    IF c-retorno = "":U THEN
        RUN getCharField IN h-boad039 (INPUT "descricao":U, OUTPUT c-desc-cond-pagto).
    ELSE 
        ASSIGN c-desc-cond-pagto = "":U.

    RUN retornaDescricao IN h-bocx110 (INPUT  tt-despes-ped-compra.cod-pto-contr:SCREEN-VALUE IN FRAME fPage1,
                                       OUTPUT c-desc-pto-contr).

    RUN findCodigo IN h-boad259 (INPUT  tt-despes-ped-compra.tp-despesa:SCREEN-VALUE IN FRAME fPage1,
                                 OUTPUT c-retorno).
    IF c-retorno = "":U THEN
        RUN getCharField IN h-boad259 (INPUT "descricao":U, OUTPUT c-desc-tipo-despesa).
    ELSE
        ASSIGN c-desc-tipo-despesa = "":U.
    
    DISP c-desc-desp
         c-desc-emit
         c-desc-moeda
         c-desc-cond-pagto
         c-desc-pto-contr
         c-desc-tipo-despesa
         WITH FRAME fpage1.
    
    ASSIGN cod-cond-pag-ant  = INPUT FRAME fPage1 tt-despes-ped-compra.cod-cond-pag
           cod-pto-contr-ant = INPUT FRAME fPage1 tt-despes-ped-compra.cod-pto-contr
           tp-despesa-ant    = INPUT FRAME fPage1 tt-despes-ped-compra.tp-despesa
           de-val-desp-ant   = INPUT FRAME fPage1 tt-despes-ped-compra.val-desp.

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
    ASSIGN tt-despes-ped-compra.cod-incoterm-rat:SENSITIVE IN FRAME fPage1 = NO.

    IF pcAction = "ADD":U THEN DO:

        ASSIGN tt-despes-ped-compra.cod-desp:SENSITIVE IN FRAME fPage1 = YES
               tt-despes-ped-compra.cod-emitente-desp:SENSITIVE IN FRAME fPage1 = YES
               tt-despes-ped-compra.mo-codigo:SENSITIVE IN FRAME fPage1 = YES.

        APPLY "entry":U TO tt-despes-ped-compra.cod-desp IN FRAME fPage1.
    END.
    ELSE
        IF pcAction = "UPDATE":U THEN DO:

            ASSIGN tt-despes-ped-compra.cod-desp:SENSITIVE IN FRAME fPage1 = NO
                   tt-despes-ped-compra.cod-emitente-desp:SENSITIVE IN FRAME fPage1 = NO
                   tt-despes-ped-compra.mo-codigo:SENSITIVE IN FRAME fPage1 = NO.

            RUN pi-incoterm.

            APPLY "entry":U TO tt-despes-ped-compra.cod-cond-pag IN FRAME fPage1.

            IF l-imposto THEN
                ASSIGN tt-despes-ped-compra.val-desp:SENSITIVE IN FRAME fPage1 = NO.
            ELSE
                ASSIGN tt-despes-ped-compra.val-desp:SENSITIVE IN FRAME fPage1 = YES.
        END.

    ASSIGN cb-situacao:SCREEN-VALUE IN FRAME fPage0 = {ininc/i02in295.i 04 tt-pedido-compr.situacao}
           cb-natureza:SCREEN-VALUE IN FRAME fPage0 = {ininc/i01in295.i 04 tt-pedido-compr.natureza}.

    RUN getDescCgcEmitente IN h-boin295desc(INPUT  tt-pedido-compr.cod-emitente,
                                            OUTPUT c-nome-abrev,
                                            OUTPUT c-cgc).

    RUN findPedido IN h-bocx140(INPUT tt-pedido-compr.num-pedido, OUTPUT c-retorno).

    IF c-retorno = "":U THEN DO:
        RUN getCharfield IN h-bocx140(INPUT "nr-proc-imp":U, OUTPUT c-nr-proc-imp).
        RUN getIntfield  IN h-bocx140(INPUT "cod-itiner":U,  OUTPUT i-cod-itiner).
    END.
    ELSE
        ASSIGN c-nr-proc-imp = "":U
               i-cod-itiner  = 0.

     /* Grava Itiner rio para inicializa‡Æo da Pesquisa do Ponto de Controle */
    ASSIGN is-cod-itiner = i-cod-itiner.

    RUN findCodigo IN h-bocx115(INPUT  i-cod-itiner, OUTPUT c-retorno).

    IF c-retorno = "":U THEN
        RUN getCharField IN h-bocx115 (INPUT  "descricao":U, OUTPUT c-desc-itiner).
    ELSE
        ASSIGN c-desc-itiner = "":U.

    RUN getIncoterm IN h-bocx341 (INPUT tt-pedido-compr.num-pedido, OUTPUT c-incoterm).

    DISP c-nome-abrev 
         c-nr-proc-imp 
         c-incoterm
         i-cod-itiner 
         c-desc-itiner 
         WITH FRAME fPage0.

    RUN validateProcessoImp IN h-bocx341 (INPUT YES).

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
    ASSIGN cb-situacao:LIST-ITEMS IN FRAME fPage0 = {ininc/i02in295.i 03}
           cb-natureza:LIST-ITEMS IN FRAME fPage0 = {ininc/i01in295.i 03}.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
    IF  NOT VALID-HANDLE(h-boad039) THEN
        RUN adbo/boad039.p PERSISTENT SET h-boad039.         /*BO cond-pagto*/
    
    IF  NOT VALID-HANDLE(h-boad098) THEN
        RUN adbo/boad098.p PERSISTENT SET h-boad098.         /*BO emitente*/
    
    IF  NOT VALID-HANDLE(h-boad259) THEN
        RUN adbo/boad259.p PERSISTENT SET h-boad259.         /*BO tipo-rec-desp*/

    IF  NOT VALID-HANDLE(h-bocx095) THEN
        RUN cxbo/bocx095.p PERSISTENT SET h-bocx095.         /*BO desp-imp*/

    IF  NOT VALID-HANDLE(h-bocx110) THEN
        RUN cxbo/bocx110.p PERSISTENT SET h-bocx110.         /*BO pto-contr*/

    IF  NOT VALID-HANDLE(h-bocx115) THEN
        RUN cxbo/bocx115.p PERSISTENT SET h-bocx115.         /*BO itinerario*/

    IF  NOT VALID-HANDLE(h-bocx140) THEN
        RUN cxbo/bocx140.p PERSISTENT SET h-bocx140.         /*BO processo-imp*/
    
    IF  NOT VALID-HANDLE(h-bocx155) THEN
        RUN cxbo/bocx155.p PERSISTENT SET h-bocx155.         /*BO emitente-cex*/

    IF  NOT VALID-HANDLE(h-bocx250) THEN
        RUN cxbo/bocx250.p PERSISTENT SET h-bocx250.         /*BO param-imp*/
    
    IF  NOT VALID-HANDLE(h-boin295desc) THEN
        RUN inbo/boin295desc.p PERSISTENT SET h-boin295desc. /*BO pedido-compr*/
    
    IF  NOT VALID-HANDLE(h-boun005) THEN
        RUN unbo/boun005.p PERSISTENT SET h-boun005.         /*BO moeda*/

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-incoterm wMaintenanceNoNavigation 
PROCEDURE pi-incoterm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN findCodigo  IN h-bocx095 (INPUT  tt-despes-ped-compra.cod-desp:SCREEN-VALUE IN FRAME fPage1,
                                  OUTPUT c-retorno).
    
    RUN getIntField  IN h-bocx095 (INPUT "tipo":U, OUTPUT i-tipo).

    RUN retornaDespesaImposto IN h-bocx341 (INPUT  tt-pedido-compr.num-pedido,
                                            INPUT  tt-despes-ped-compra.cod-desp:SCREEN-VALUE IN FRAME fPage1,
                                            INPUT  "":U,
                                            INPUT  "":U,
                                            INPUT  1,
                                            OUTPUT l-imposto).

    IF (i-tipo <> 1  /*Valor Fixo            */
    AND i-tipo <> 2  /*Valor Informado       */
    AND i-tipo <> 4  /*Taxa sobre Distancia  */
    AND i-tipo <> 5  /*Taxa sobre Dias       */
    AND i-tipo <> 7  /*Adicional sobre Valor */
    AND i-tipo <> 8) /*Formula               */
    OR (l-imposto = YES) THEN 
        ASSIGN tt-despes-ped-compra.cod-incoterm-rat:SENSITIVE IN FRAME fPage1    = NO
               tt-despes-ped-compra.cod-incoterm-rat:SCREEN-VALUE IN FRAME fPage1 = "":U.
    ELSE
        ASSIGN tt-despes-ped-compra.cod-incoterm-rat:SENSITIVE IN FRAME fPage1 = YES.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida wMaintenanceNoNavigation 
PROCEDURE pi-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFlag AS INTEGER NO-UNDO.
    
    IF pFlag = 1 THEN DO:
        EMPTY TEMP-TABLE tt-despesas.
        EMPTY TEMP-TABLE tt-pedidos.
    
        IF pcAction = "ADD":U THEN DO:
            RUN sugereSeqDespesa IN h-bocx341 (INPUT  tt-pedido-compr.num-pedido, OUTPUT i-sequencia).
            ASSIGN tt-despes-ped-compra.sequencia      = i-sequencia
                   tt-despes-ped-compra.log-despes-ped = YES. //Despesa criada no pedido
        END.
        CREATE tt-despesas.
        ASSIGN tt-despesas.cod-desp          = INPUT FRAME fPage1 tt-despes-ped-compra.cod-desp
               tt-despesas.val-desp          = INPUT FRAME fPage1 tt-despes-ped-compra.val-desp
               tt-despesas.mo-codigo         = INPUT FRAME fPage1 tt-despes-ped-compra.mo-codigo
               tt-despesas.cod-emitente-desp = INPUT FRAME fPage1 tt-despes-ped-compra.cod-emitente-desp
               tt-despesas.cod-cond-pag      = INPUT FRAME fPage1 tt-despes-ped-compra.cod-cond-pag
               tt-despesas.cod-pto-contr     = INPUT FRAME fPage1 tt-despes-ped-compra.cod-pto-contr
               tt-despesas.cod-incoterm-rat  = INPUT FRAME fPage1 tt-despes-ped-compra.cod-incoterm-rat
               tt-despesas.tp-despesa        = INPUT FRAME fPage1 tt-despes-ped-compra.tp-despesa.
        
        CREATE tt-pedidos.
        ASSIGN tt-pedidos.num-pedido = INPUT FRAME fPage0 tt-pedido-compr.num-pedido.
    END.
    ELSE DO:
        IF pFlag = 2 THEN DO:
            IF pcAction = "ADD":U THEN DO:
                RUN atualizaDespesasOrdem IN h-bocx341 (INPUT 1,
                                                        INPUT ?,
                                                        INPUT ?,
                                                        INPUT ?,
                                                        INPUT ?,
                                                        INPUT TABLE tt-despesas,
                                                        INPUT TABLE tt-pedidos).

                RUN getTtBoErro IN h-bocx341 (OUTPUT TABLE tt-bo-erro).

                /* Substitui mensagem de erro da im0091, para um alerta. Avisando que a despesa nao foi rateada */
                FOR FIRST tt-bo-erro EXCLUSIVE-LOCK:

                    ASSIGN tt-bo-erro.parametros = INPUT FRAME fPage1 tt-despes-ped-compra.cod-desp + " - ":U + INPUT FRAME fPage1 c-desc-desp
                                                 + "~~":U + tt-bo-erro.mensagem.

                    RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 56803, INPUT tt-bo-erro.parametros).

                    ASSIGN  tt-bo-erro.mensagem     = RETURN-VALUE
                            tt-bo-erro.cd-erro      = 56803
                            tt-bo-erro.errorsubtype = "WARNING":U.

                    IF NOT VALID-HANDLE(hShowMsg) THEN
                        RUN utp/showmessage.w PERSISTENT SET hShowMsg.
                     
                    RUN setModal IN hShowMsg (INPUT YES) NO-ERROR.
                    RUN showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).
                END.
            END.
            ELSE
                IF   pcAction = "UPDATE":U                                                       
                AND (cod-cond-pag-ant  <> INPUT FRAME fPage1 tt-despes-ped-compra.cod-cond-pag    OR
                     cod-pto-contr-ant <> INPUT FRAME fPage1 tt-despes-ped-compra.cod-pto-contr   OR
                     tp-despesa-ant    <> INPUT FRAME fPage1 tt-despes-ped-compra.tp-despesa      OR
                     de-val-desp-ant   <> INPUT FRAME fPage1 tt-despes-ped-compra.val-desp) THEN DO:

                    RUN imp/im0300b.w (OUTPUT i-tipo-alteracao).
                    RUN atualizaDespesasOrdem IN h-bocx341 (INPUT 2,
                                                            INPUT i-tipo-alteracao,
                                                            INPUT cod-cond-pag-ant,
                                                            INPUT cod-pto-contr-ant,
                                                            INPUT tp-despesa-ant,
                                                            INPUT TABLE tt-despesas,
                                                            INPUT TABLE tt-pedidos).
                END.
        END.    
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
    ASSIGN tt-despes-ped-compra.num-pedido = tt-pedido-compr.num-pedido.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

