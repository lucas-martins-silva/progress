&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-licenciam-import-oc NO-UNDO LIKE licenciam-import-oc
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-processo-imp NO-UNDO LIKE processo-imp
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0041 2.00.00.018 } /*** "010018" 07/11/2025 11:15:50  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0041 MIM}
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
&GLOBAL-DEFINE Program        IM0041
&GLOBAL-DEFINE Version        2.00.00.018

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Itens

&GLOBAL-DEFINE First          NO
&GLOBAL-DEFINE Prev           NO
&GLOBAL-DEFINE Next           NO
&GLOBAL-DEFINE Last           NO
&GLOBAL-DEFINE GoTo           NO
&GLOBAL-DEFINE Search         NO

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         NO
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         NO
&GLOBAL-DEFINE Save           NO
                                              
&GLOBAL-DEFINE ttTable        tt-embarque-imp
&GLOBAL-DEFINE hDBOTable      h-bocx220
&GLOBAL-DEFINE DBOTable       embarque-imp

&global-define ExcludeBtQueryJoins   yes
&global-define ExcludeBtReportsJoins yes
&global-define DBOVersion            1.1

/* Parameters Definitions ---                                           */
define input parameter rProcessoImp as rowid         no-undo.
define input parameter rEmbarqueImp as rowid         no-undo.
define input parameter lHabilita    as logical       no-undo.

/* Local Variable Definitions ---                                       */
define variable cSituacaoParcela  as character format "x(15)":U no-undo.
define variable cSituacao         as character format "x(15)":U no-undo.
define variable iSituacao         as integer                    no-undo.
define variable cDescItem         as character format "x(40)":U no-undo.
define variable cDescricao        as character format "x(40)":U no-undo.
define variable iExportaLi        as integer                    no-undo.
define variable lRecarrega        as logical                    no-undo.

/* Variaveis Selecao */
define variable iNumeroOrdemIni   like ordem-compra.numero-ordem                                         no-undo.
define variable iNumeroOrdemFim   like ordem-compra.numero-ordem          initial 99999999               no-undo.
define variable cItCodigoIni      like item.it-codigo                                                    no-undo.
define variable cItCodigoFim      like item.it-codigo                     initial "ZZZZZZZZZZZZZZZZ"     no-undo.
define variable cClassFiscalIni   like item.class-fiscal                                                 no-undo.
define variable cClassFiscalFim   like item.class-fiscal                  initial "999999999"            no-undo.
define variable cNrLiIni          like licenciam-import-oc.licenca-import                                no-undo.
define variable cNrLiFim          like licenciam-import-oc.licenca-import initial "ZZZZZZZZZZZZZZZZZZZZ" no-undo.
define variable lEliminadas       as   logical                                                           no-undo.
define variable lRecebidas        as   logical                                                           no-undo.
define variable lOk               as   logical                                                           no-undo.
define variable l-relac-di        as   logical                            initial no                     no-undo.

/* Local Variable Definitions (DBOs Handles) --- */
define variable {&hDBOTable} as handle no-undo.
define variable h-bocx140    as handle no-undo.
define variable h-bocx351    as handle no-undo.
define variable h-boin356    as handle no-undo.
define variable h-boin172    as handle no-undo.

/* Local Temp-tables Definitions --- */
{cxbo/bocx351.i tt-licenciam-import-oc-aux}
{cxbo/bocx351.i tt-li-recarrega}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTable

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-licenciam-import-oc

/* Definitions for BROWSE brTable                                       */
&Scoped-define FIELDS-IN-QUERY-brTable tt-licenciam-import-oc.numero-ordem tt-licenciam-import-oc.parcela tt-licenciam-import-oc.cod-livre-1 fn_situacao () @ cSituacaoParcela tt-licenciam-import-oc.cod-livre-2 tt-licenciam-import-oc.licenca-import tt-licenciam-import-oc.dat-livre-1 fn_desc_item() @ cDescItem   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable   
&Scoped-define SELF-NAME brTable
&Scoped-define OPEN-QUERY-brTable     /*--- Seta cursor do mouse para espera ---*/     session:set-wait-state("GENERAL":U).      if  input frame fPage0 rsOrdenacao = 1 then         open query {&SELF-NAME}             for each tt-licenciam-import-oc             by tt-licenciam-import-oc.cod-livre-2. /*class fiscal*/     else         if  input frame fPage0 rsOrdenacao = 2 then             open query {&SELF-NAME}                 for each tt-licenciam-import-oc                 by tt-licenciam-import-oc.cod-livre-1. /*item*/         else             if  input frame fPage0 rsOrdenacao = 3 then                 open query {&SELF-NAME}                     for each tt-licenciam-import-oc                     by tt-licenciam-import-oc.numero-ordem. /*ordem*/             else                 open query {&SELF-NAME}                     for each tt-licenciam-import-oc                     by tt-licenciam-import-oc.licenca-import. /*LI*/      if  not can-find (first tt-licenciam-import-oc) then         disable btAlterar with frame fPage1.     else         if  lHabilita then             enable btAlterar with frame fPage1.      /*--- Seta cursor do mouse para normal ---*/     session:set-wait-state("":U).
&Scoped-define TABLES-IN-QUERY-brTable tt-licenciam-import-oc
&Scoped-define FIRST-TABLE-IN-QUERY-brTable tt-licenciam-import-oc


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtKeys rtKeys-2 rtToolBar btRecarrega ~
btSelecao btExit btHelp rsOrdenacao 
&Scoped-Define DISPLAYED-OBJECTS cCodEstabel cEmbarque cNrProcImp ~
rsOrdenacao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn_desc_item wMaintenance 
FUNCTION fn_desc_item RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn_situacao wMaintenance 
FUNCTION fn_situacao RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miRecarrega    LABEL "&Recarrega"     ACCELERATOR "CTRL-R"
       RULE
       MENU-ITEM miSelecao      LABEL "&Sele‡Æo"       ACCELERATOR "CTRL-S"
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image~\im-exi":U
     IMAGE-INSENSITIVE FILE "image~\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image~\im-hel":U
     IMAGE-INSENSITIVE FILE "image~\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btRecarrega 
     IMAGE-UP FILE "image/im-undo.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-undo.bmp":U
     LABEL "Recarrega" 
     SIZE 4 BY 1.25 TOOLTIP "Recarrega".

DEFINE BUTTON btSelecao 
     IMAGE-UP FILE "image/im-ran.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-ran.bmp":U
     LABEL "Sele‡Æo do LI" 
     SIZE 4 BY 1.25 TOOLTIP "Sele‡Æo do LI".

DEFINE VARIABLE cCodEstabel LIKE estabelec.cod-estabel
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE cEmbarque AS CHARACTER FORMAT "X(16)":U 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE cNrProcImp AS CHARACTER FORMAT "X(16)":U 
     LABEL "Processo Importa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE rsOrdenacao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Classifica‡Æo Fiscal", 1,
"Item", 2,
"Ordem Compra", 3,
"Licenciamento Importa‡Æo", 4
     SIZE 70 BY 1.5 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.96.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.96.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAlterar 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable FOR 
      tt-licenciam-import-oc SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable wMaintenance _FREEFORM
  QUERY brTable NO-LOCK DISPLAY
      tt-licenciam-import-oc.numero-ordem COLUMN-LABEL "Ordem" FORMAT "zzzzz9,99":U width 10
      tt-licenciam-import-oc.parcela COLUMN-LABEL "Parc" FORMAT ">>>>9":U WIDTH 6
      tt-licenciam-import-oc.cod-livre-1 COLUMN-LABEL "Item" FORMAT "x(16)":U
            WIDTH 22
      fn_situacao () @ cSituacaoParcela COLUMN-LABEL "Situa‡Æo Parcela" FORMAT "x(15)":U
            WIDTH 15
      tt-licenciam-import-oc.cod-livre-2 COLUMN-LABEL "Class Fiscal" FORMAT "9999.99.99":U
            WIDTH 9
      tt-licenciam-import-oc.licenca-import COLUMN-LABEL "Nr LI" FORMAT "X(20)":U
            WIDTH 25
      tt-licenciam-import-oc.dat-livre-1 COLUMN-LABEL "Dt Restri‡Æo Embarq" FORMAT 99/99/9999
            WIDTH 15
      fn_desc_item() @ cDescItem COLUMN-LABEL "Descri‡Æo" FORMAT "x(60)":U
            WIDTH 65
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 83 BY 7.92
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btRecarrega AT ROW 1.13 COL 1.43 HELP
          "Recarrega"
     btSelecao AT ROW 1.13 COL 78.72 HELP
          "Sele‡Æo do LI"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     cCodEstabel AT ROW 3 COL 30.29 COLON-ALIGNED HELP
          "C¢digo do estabelecimento"
          LABEL "Estabelecimento"
     cEmbarque AT ROW 3 COL 55 COLON-ALIGNED
     cNrProcImp AT ROW 3 COL 55 COLON-ALIGNED
     rsOrdenacao AT ROW 5.13 COL 11.43 HELP
          "Ordena‡Æo das Informa‡äes" NO-LABEL
     "Ordena‡Æo das Informa‡äes" VIEW-AS TEXT
          SIZE 20 BY .54 AT ROW 4.5 COL 36
     rtKeys AT ROW 2.5 COL 1
     rtKeys-2 AT ROW 4.75 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     brTable AT ROW 1.33 COL 1.86
     btAlterar AT ROW 9.29 COL 1.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 8
         SIZE 84.43 BY 9.5
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-embarque-imp T "?" NO-UNDO mgcex embarque-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-licenciam-import-oc T "?" NO-UNDO mgcex licenciam-import-oc
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-processo-imp T "?" NO-UNDO mgcex processo-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}
{include/i_fclfrm.i fpage0}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN cCodEstabel IN FRAME fpage0
   NO-ENABLE LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-HELP EXP-SIZE */
/* SETTINGS FOR FILL-IN cEmbarque IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       cEmbarque:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FILL-IN cNrProcImp IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       cNrProcImp:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable 1 fPage1 */
ASSIGN 
       brTable:NUM-LOCKED-COLUMNS IN FRAME fPage1     = 3
       brTable:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       brTable:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable
/* Query rebuild information for BROWSE brTable
     _START_FREEFORM
    /*--- Seta cursor do mouse para espera ---*/
    session:set-wait-state("GENERAL":U).

    if  input frame fPage0 rsOrdenacao = 1 then
        open query {&SELF-NAME}
            for each tt-licenciam-import-oc
            by tt-licenciam-import-oc.cod-livre-2. /*class fiscal*/
    else
        if  input frame fPage0 rsOrdenacao = 2 then
            open query {&SELF-NAME}
                for each tt-licenciam-import-oc
                by tt-licenciam-import-oc.cod-livre-1. /*item*/
        else
            if  input frame fPage0 rsOrdenacao = 3 then
                open query {&SELF-NAME}
                    for each tt-licenciam-import-oc
                    by tt-licenciam-import-oc.numero-ordem. /*ordem*/
            else
                open query {&SELF-NAME}
                    for each tt-licenciam-import-oc
                    by tt-licenciam-import-oc.licenca-import. /*LI*/

    if  not can-find (first tt-licenciam-import-oc) then
        disable btAlterar with frame fPage1.
    else
        if  lHabilita then
            enable btAlterar with frame fPage1.

    /*--- Seta cursor do mouse para normal ---*/
    session:set-wait-state("":U).
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brTable */
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

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brTable
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brTable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTable wMaintenance
ON MOUSE-SELECT-DBLCLICK OF brTable IN FRAME fPage1
DO:
    if  lHabilita AND 
        NOT l-relac-di then
        apply "choose":U to btAlterar in frame fPage1.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTable wMaintenance
ON VALUE-CHANGED OF brTable IN FRAME fPage1
DO:
    status input fn_desc_item().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAlterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAlterar wMaintenance
ON CHOOSE OF btAlterar IN FRAME fPage1 /* Alterar */
DO:
    if  avail tt-licenciam-import-oc then do:

        FIND FIRST decla-import-ord 
                WHERE decla-import-ord.cod-embarq  = cEmbarque:SCREEN-VALUE IN FRAME fPage0
                AND   decla-import-ord.num-ordem   = tt-licenciam-import-oc.numero-ordem
                AND   decla-import-ord.num-parcela = tt-licenciam-import-oc.parcela
                AND   decla-import-ord.cod-estab   = cCodEstabel:SCREEN-VALUE IN FRAME fPage0 NO-LOCK NO-ERROR.
        IF AVAIL decla-import-ord THEN DO:
            IF CAN-FIND(FIRST decla-import-adic
                            WHERE decla-import-adic.num-di-ems       = decla-import-ord.num-di-ems                            
                            AND   decla-import-adic.num-adic         = decla-import-ord.num-adic
                            AND   decla-import-adic.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts) THEN DO:
                ASSIGN l-relac-di = YES.
            END.                
            ELSE
                ASSIGN l-relac-di = NO.               
        END.
        ELSE
            ASSIGN l-relac-di = NO.

        IF l-relac-di THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-alteracao-nao-permitida AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Altera‡Æo_nÆo_permitida" *}
            ASSIGN c-lbl-liter-alteracao-nao-permitida = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-ordem-vinculada-a-uma-declarac AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ordem_vinculada_a_uma_Declara‡Æo_de_Importa‡Æo._Para_alterar_o_Nr._LI_neste_caso,_deve_ser_utilizado_o_programa_Manuten‡Æo_Adi‡äes_(im0410)" *}
            ASSIGN c-lbl-liter-ordem-vinculada-a-uma-declarac = TRIM(RETURN-VALUE).
            RUN utp/ut-msgs.p (INPUT 'show':U,
                               INPUT 17006,
                               INPUT c-lbl-liter-alteracao-nao-permitida + '!' + '~~' + c-lbl-liter-ordem-vinculada-a-uma-declarac + '.').
        END.
        ELSE DO:

            run emptyRowErrors in h-bocx351.
            empty temp-table rowErrors.
    
            if  rProcessoImp <> ? then do:
    
                run piVerificaSituacaoPedido in h-bocx351 (input rProcessoImp).
                if  return-value = "NOK":U then do:
                
                    run getRowErrors in h-bocx351 (output table rowErrors).
    
                    if  can-find(first rowErrors) then do:
                        {method/showmessage.i1}
                        {method/showmessage.i2 &Modal="YES"}
                    end.
                    
                end.
            end.
    
            if  not can-find (first rowErrors) then do:
    
                empty temp-table tt-licenciam-import-oc-aux.
                create tt-licenciam-import-oc-aux.
                buffer-copy tt-licenciam-import-oc to tt-licenciam-import-oc-aux.
    
                wMaintenance:sensitive = no.
    
                run imp/im0041b.w (input-output table tt-licenciam-import-oc-aux,
                                   output iExportaLi,
                                   output lOk).
                wMaintenance:sensitive = yes.
                apply "entry" to {&WINDOW-NAME}.
    
                if  lOk then do:
                
                    if  iExportaLi = 1 then do:
                        
                        find first tt-licenciam-import-oc-aux no-error.
        
                        run piExportaLI in h-bocx351 (input tt-licenciam-import-oc-aux.cod-livre-2, /*class-fiscal*/
                                                      input tt-licenciam-import-oc-aux.licenca-import,
                                                      input tt-licenciam-import-oc-aux.dat-livre-1,
                                                      input table tt-licenciam-import-oc).
                    end.
    
                    run piCarregaBrowse in this-procedure.
                end.
            end.
            else
                return no-apply.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btRecarrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRecarrega wMaintenance
ON CHOOSE OF btRecarrega IN FRAME fpage0 /* Recarrega */
OR CHOOSE OF MENU-ITEM miRecarrega IN MENU mbMain DO:
 
    Recarrega:
    do  transaction on error undo, leave:
  
        empty temp-table tt-li-recarrega.
    
        run piSetalRecarrega in h-bocx351 (input yes).

        if  rProcessoImp <> ? then
            run piRetornaLi in h-bocx351 (input 1,  /*Processo Importacao*/
                                          input yes,
                                          input tt-processo-imp.num-pedido,
                                          input ?,  /*Estabelecimento*/
                                          input ?,  /*Embarque*/
                                          input ?,  /*Parcela*/
                                          input lEliminadas, /*Considera Parcelas Eliminadas*/
                                          input lRecebidas, /*Considera Parcelas Recebidas*/
                                          input iNumeroOrdemIni,
                                          input iNumeroOrdemFim,
                                          input cItCodigoIni,
                                          input cItCodigoFim,
                                          input cClassFiscalIni,
                                          input cClassFiscalFim,
                                          input cNrLiIni,
                                          input cNrLiFim,
                                          output table tt-li-recarrega).
        else 
            if  rEmbarqueImp <> ? then
                run piRetornaLi in h-bocx351 (input 2,  /*Embarque Importacao*/
                                              input yes,
                                              input ?,  /*Processo Importacao*/
                                              input tt-embarque-imp.cod-estabel,
                                              input tt-embarque-imp.embarque,
                                              input ?,  /*Parcela*/
                                              input lEliminadas, /*Considera Parcelas Eliminadas*/
                                              input lRecebidas, /*Considera Parcelas Recebidas*/
                                              input iNumeroOrdemIni,
                                              input iNumeroOrdemFim,
                                              input cItCodigoIni,
                                              input cItCodigoFim,
                                              input cClassFiscalIni,
                                              input cClassFiscalFim,
                                              input cNrLiIni,
                                              input cNrLiFim,
                                              output table tt-li-recarrega).
    
        assign lRecarrega = yes.

        for each tt-licenciam-import-oc:
    
            find first tt-li-recarrega
                where  tt-li-recarrega.numero-ordem = tt-licenciam-import-oc.numero-ordem
                and    tt-li-recarrega.parcela      = tt-licenciam-import-oc.parcela no-error.
            if  not avail tt-li-recarrega then do:
            
                if  tt-licenciam-import-oc.licenca-import <> "" then do:
    
                    run utp/ut-msgs.p (input "show":U,
                                       input 30444,
                                       input string(tt-licenciam-import-oc.parcela) + "~~" +
                                             string(tt-licenciam-import-oc.numero-ordem)).
                    if  return-value = "no" then do:
                        assign lRecarrega = no.
                        undo Recarrega, leave Recarrega.
                    end.
                end.

                run gotokey in h-bocx351 (input tt-licenciam-import-oc.numero-ordem,
                                          input tt-licenciam-import-oc.parcela).
                if  return-value = "OK":U then do:
        
                    empty temp-table tt-licenciam-import-oc-aux.

                    create tt-licenciam-import-oc-aux.
                    buffer-copy tt-licenciam-import-oc to tt-licenciam-import-oc-aux.
        
                    run emptyRowErrors in h-bocx351.
                    run emptyRowObject in h-bocx351.
                    run setRecord      in h-bocx351 (input table tt-licenciam-import-oc-aux).
                    run deleteRecord   in h-bocx351.
                    if  return-value = "NOK":U then do:
        
                        run getRowErrors in h-bocx351 (output table RowErrors).

                        for each  RowErrors 
                            where RowErrors.errorType = "INTERNAL":U:
                            delete RowErrors.
                        end.
            
                        if  can-find (first RowErrors) then do:
                            {method/showmessage.i1}
                            {method/showmessage.i2 &Modal="YES"}
                            undo Recarrega, leave Recarrega.
                        end.
                    end.
                end.
            end.
        end.
    end.

    if  lRecarrega then do:
        
        empty temp-table tt-licenciam-import-oc.
        for each tt-li-recarrega:
            create tt-licenciam-import-oc.
            buffer-copy tt-li-recarrega to tt-licenciam-import-oc.
        end.
    end.
        
    {&OPEN-QUERY-brTable}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSelecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelecao wMaintenance
ON CHOOSE OF btSelecao IN FRAME fpage0 /* Sele‡Æo do LI */
OR CHOOSE OF MENU-ITEM miSelecao IN MENU mbMain DO:
  
    wMaintenance:sensitive = no.
    run imp/im0041a.w (input-output iNumeroOrdemIni,  
                       input-output iNumeroOrdemFim, 
                       input-output cItCodigoIni,    
                       input-output cItCodigoFim,    
                       input-output cClassFiscalIni, 
                       input-output cClassFiscalFim, 
                       input-output cNrLiIni,        
                       input-output cNrLiFim,        
                       input-output lEliminadas,     
                       input-output lRecebidas,      
                       output       lOk).  
    wMaintenance:sensitive = yes.
    apply "entry" to {&WINDOW-NAME}.
    if  lOk then
        run piCarregaBrowse in this-procedure.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsOrdenacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsOrdenacao wMaintenance
ON VALUE-CHANGED OF rsOrdenacao IN FRAME fpage0
DO:
    {&OPEN-QUERY-brTable}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if  valid-handle (h-bocx351) then do:
        delete procedure h-bocx351.
        assign h-bocx351 = ?.
    end.

    if  valid-handle (h-boin356) then do:
        delete procedure h-boin356.
        assign h-boin356 = ?.
    end.

    if  valid-handle (h-boin172) then do:
        delete procedure h-boin172.
        assign h-boin172 = ?.
    end.

    if  valid-handle (h-bocx140) then do:
        delete procedure h-bocx140.
        assign h-bocx140 = ?.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    if  lHabilita then do:
        enable rsOrdenacao btRecarrega btSelecao with frame fPage0.
        enable brTable btAlterar with frame fPage1.
    end.
    else do:
        enable brTable with frame fPage1.
        enable rsOrdenacao btSelecao with frame fPage0.
        assign menu-item miRecarrega:sensitive in menu mbMain = no .
    end.

    if  rProcessoImp <> ? then do:

        assign cEmbarque:hidden  in frame fPage0 = yes
               cNrProcImp:hidden in frame fPage0 = no.

        run findRowid  in h-bocx140 (input rProcessoImp).
        run getCurrent in h-bocx140 (output table tt-processo-imp).

        find first tt-processo-imp no-error.
        if  avail tt-processo-imp then
            assign cCodEstabel = tt-processo-imp.cod-estabel
                   cNrProcImp  = tt-processo-imp.nr-proc-imp.
        
        display cCodEstabel cNrProcImp rsOrdenacao with frame fPage0.
    
    end.
    else
        if  rEmbarqueImp <> ? then do:
            
            run repositionRecord in this-procedure (input rEmbarqueImp).

            if  avail tt-embarque-imp then
                assign cCodEstabel = tt-embarque-imp.cod-estabel
                       cEmbarque   = tt-embarque-imp.embarque.

            assign cNrProcImp:hidden   in frame fPage0 = yes
                   cEmbarque:hidden    in frame fPage0 = no.

            display cCodEstabel cEmbarque rsOrdenacao with frame fPage0.
        end.

    run piCarregaBrowse in this-procedure.
    
    apply 'value-changed':U to browse brTable.
    apply 'entry':U to browse brTable.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO jÿ estÿ inicializado ---*/
    if  not valid-handle({&hDBOTable}) 
    or  {&hDBOTable}:type <> "PROCEDURE":U
    or  {&hDBOTable}:file-name <> "cxbo/bocx220.p":U then 
        run cxbo/bocx220.p persistent set h-bocx220.

    &if defined(DBOVersion) <> 0  &then
    run openQuery in {&hDBOTable} (input 1) no-error.
    &else
    run openQueryStatic in {&hDBOTable} (input "Main":U) no-error.
    &endif
    
    /*:T--- Verifica se o DBO jÿ estÿ inicializado ---*/
    if  not valid-handle(h-bocx140) 
    or  h-bocx140:type <> "PROCEDURE":U
    or  h-bocx140:file-name <> "cxbo/bocx140.p":U then 
        run cxbo/bocx140.p persistent set h-bocx140.

    &if defined(DBOVersion) <> 0  &then
    run openQuery in h-bocx140 (input 1) no-error.
    &else
    run openQueryStatic in h-bocx140 (input "Main":U) no-error.
    &endif

    /*:T--- Verifica se o DBO jÿ estÿ inicializado ---*/
    if  not valid-handle(h-bocx351) 
    or  h-bocx351:type      <> "PROCEDURE":U
    or  h-bocx351:file-name <> "cxbo/bocx351.p":U then 
        run cxbo/bocx351.p persistent set h-bocx351.

    run openQueryStatic in h-bocx351 (input "Main":U) no-error.
    
    /*:T--- Verifica se o DBO jÿ estÿ inicializado ---*/
    if  not valid-handle(h-boin172) 
    or  h-boin172:type      <> "PROCEDURE":U
    or  h-boin172:file-name <> "inbo/boin172.p":U then 
        run inbo/boin172.p persistent set h-boin172.

    run openQueryStatic in h-boin172 (input "Main":U) no-error.

        /*:T--- Verifica se o DBO jÿ estÿ inicializado ---*/
    if  not valid-handle(h-boin356) 
    or  h-boin356:type      <> "PROCEDURE":U
    or  h-boin356:file-name <> "inbo/boin356.p":U then 
        run inbo/boin356.p persistent set h-boin356.

    run openQueryStatic in h-boin356 (input "Main":U) no-error.


    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregaBrowse wMaintenance 
PROCEDURE piCarregaBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    run piSetalRecarrega in h-bocx351 (input no).

    if  rProcessoImp <> ? then
        run piRetornaLi in h-bocx351 (input 1,  /*Processo Importacao*/
                                      input yes,
                                      input tt-processo-imp.num-pedido,
                                      input ?,  /*Estabelecimento*/
                                      input ?,  /*Embarque*/
                                      input ?,  /*Parcela*/
                                      input lEliminadas, /*Considera Parcelas Eliminadas*/
                                      input lRecebidas, /*Considera Parcelas Recebidas*/
                                      input iNumeroOrdemIni,
                                      input iNumeroOrdemFim,
                                      input cItCodigoIni,
                                      input cItCodigoFim,
                                      input cClassFiscalIni,
                                      input cClassFiscalFim,
                                      input cNrLiIni,
                                      input cNrLiFim,
                                      output table tt-licenciam-import-oc).
    else 
        if  rEmbarqueImp <> ? then
            run piRetornaLi in h-bocx351 (input 2,  /*Embarque Importacao*/
                                          input yes,
                                          input ?,  /*Processo Importacao*/
                                          input tt-embarque-imp.cod-estabel,
                                          input tt-embarque-imp.embarque,
                                          input ?,  /*Parcela*/
                                          input lEliminadas, /*Considera Parcelas Eliminadas*/
                                          input lRecebidas, /*Considera Parcelas Recebidas*/
                                          input iNumeroOrdemIni,
                                          input iNumeroOrdemFim,
                                          input cItCodigoIni,
                                          input cItCodigoFim,
                                          input cClassFiscalIni,
                                          input cClassFiscalFim,
                                          input cNrLiIni,
                                          input cNrLiFim,
                                          output table tt-licenciam-import-oc).

    {&OPEN-QUERY-brTable}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn_desc_item wMaintenance 
FUNCTION fn_desc_item RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    assign cDescricao = "".

    if  avail tt-licenciam-import-oc then do:

        /* o c¢digo do item foi armazenado temporiamente no cod-livre-1 p/
           ser possivel a classificao do browse */
        run goToKey in h-boin172 (input tt-licenciam-import-oc.cod-livre-1). /*ordem-compra.it-codigo*/
        if  return-value = "OK":U then 
            run getCharField in h-boin172 (input "desc-item",
                                           output cDescricao).
    end.

    return cDescricao.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn_situacao wMaintenance 
FUNCTION fn_situacao RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    assign cSituacao = "".

    if  avail tt-licenciam-import-oc then do:

        run goToKey in h-boin356 (input tt-licenciam-import-oc.numero-ordem,
                                  input tt-licenciam-import-oc.parcela).
        if  return-value = "OK":U then do:

            run getIntField in h-boin356 (input "situacao":U,
                                          output iSituacao).


            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            assign cSituacao = {ininc/i02in274.i 04 iSituacao}.
            run utp/ut-liter.p (input replace(trim(cSituacao)," ","_"),
                                input "",
                                input "").
            assign cSituacao = return-value.
            &else
            assign cSituacao = {ininc/i02in274.i 04 iSituacao}.
            &endif
        end.
    end.

    return cSituacao.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


