&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0017A 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0017a MIM}
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
&GLOBAL-DEFINE Program        IM0017A
&GLOBAL-DEFINE Version        2.00.00.005

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Pedido

&GLOBAL-DEFINE page0Widgets   btFiltro btQueryJoins btReportsJoins btExit btHelp
&GLOBAL-DEFINE page1Widgets   br-1 bt-marca-desmarca bt-m-todos bt-d-todos bt-detalhes

DEFINE TEMP-TABLE tt-pedido NO-UNDO
    FIELD marca           AS LOGICAL
    FIELD num-pedido      LIKE pedido-compr.num-pedido
    FIELD cod-emitente    LIKE pedido-compr.cod-emitente
    FIELD nome-abrev      LIKE emitente.nome-abrev
    FIELD data-pedido     LIKE pedido-compr.data-pedido
    FIELD nr-proc-imp     LIKE processo-imp.nr-proc-imp
    FIELD incoterm        AS CHARACTER
    FIELD cod-itiner      LIKE itinerario.cod-itiner
    FIELD desc-itiner     LIKE itinerario.descricao
    FIELD val-desp        LIKE despes-ped-compra.val-desp
    FIELD log-execucao-OK AS LOGICAL
    FIELD r-rowid         AS ROWID.

DEFINE TEMP-TABLE tt-param NO-UNDO
&IF "{&mguni_version}" >= "2.071" &THEN
    FIELD cod-estabel                    AS CHARACTER format "x(05)"
&ELSE
    FIELD cod-estabel                    AS CHARACTER FORMAT "x(03)"
&ENDIF
    FIELD num-pedido-ini                 AS INTEGER   FORMAT ">>>>>,>>9"
    FIELD num-pedido-fim                 AS INTEGER   FORMAT ">>>>>,>>9"
    FIELD data-pedido-ini                AS DATE      FORMAT "99/99/9999"
    FIELD data-pedido-fim                AS DATE      FORMAT "99/99/9999"
    FIELD via-transp-ini                 AS INTEGER   FORMAT "9"
    FIELD via-transp-fim                 AS INTEGER   FORMAT "9"
    FIELD cod-transp-ini                 AS INTEGER   FORMAT ">>,>>9"
    FIELD cod-transp-fim                 AS INTEGER   FORMAT ">>,>>9"
    FIELD cod-emitente-ini               AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cod-emitente-fim               AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD nr-proc-imp-ini                AS CHARACTER FORMAT "x(12)"
    FIELD nr-proc-imp-fim                AS CHARACTER FORMAT "x(12)"
    FIELD incoterm-ini                   AS CHARACTER FORMAT "x(03)"
    FIELD incoterm-fim                   AS CHARACTER FORMAT "x(03)"
    FIELD cod-itiner-ini                 AS INTEGER   FORMAT ">>,>>9"
    FIELD cod-itiner-fim                 AS INTEGER   FORMAT ">>,>>9"
    FIELD cod-despachante-ini            AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cod-despachante-fim            AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-despa-exter-import-ini     AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-despa-exter-import-fim     AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-corretor-cambio-import-ini AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-corretor-cambio-import-fim AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cod-agente-ini                 AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cod-agente-fim                 AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-segurad-import-ini         AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-segurad-import-fim         AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-corretor-import-ini        AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-corretor-import-fim        AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD it-codigo-ini                  AS CHARACTER FORMAT "x(16)"
    FIELD it-codigo-fim                  AS CHARACTER FORMAT "x(16)".

DEF TEMP-TABLE tt-embarque NO-UNDO
        FIELD embarque AS CHAR FORMAT "x(16)".

DEF TEMP-TABLE tt-embarque-aux NO-UNDO
        FIELD embarque AS CHAR FORMAT "x(16)".

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER h-im0017 AS HANDLE NO-UNDO.

/* Global Variable Definitions ---   */
DEFINE NEW GLOBAL SHARED VARIABLE gr-pedido-compr AS ROWID NO-UNDO.

/* Local Variable Definitions ---   */
DEFINE VARIABLE c-mensagem    AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-rows        AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-cod-estabel AS CHARACTER NO-UNDO.
DEFINE VARIABLE h-im0017b     AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bocx225     AS HANDLE    NO-UNDO.
DEFINE VARIABLE l-label1      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-label2      AS LOGICAL   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-pedido

/* Definitions for BROWSE br-1                                          */
&Scoped-define FIELDS-IN-QUERY-br-1 tt-pedido.num-pedido tt-pedido.cod-emitente tt-pedido.nome-abrev tt-pedido.data-pedido tt-pedido.nr-proc-imp tt-pedido.incoterm tt-pedido.cod-itiner tt-pedido.desc-itiner   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-1   
&Scoped-define SELF-NAME br-1
&Scoped-define QUERY-STRING-br-1 FOR EACH tt-pedido
&Scoped-define OPEN-QUERY-br-1 OPEN QUERY {&SELF-NAME} FOR EACH tt-pedido.
&Scoped-define TABLES-IN-QUERY-br-1 tt-pedido
&Scoped-define FIRST-TABLE-IN-QUERY-br-1 tt-pedido


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btFiltro btQueryJoins ~
btReportsJoins btExit btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM m_Seleciona_Pedidos LABEL "Seleciona &Pedidos"
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
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

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image/ii-ran.bmp":U
     IMAGE-INSENSITIVE FILE "image~\ii-joi":U
     LABEL "Sele‡Æo de Pedidos" 
     SIZE 4 BY 1.25 TOOLTIP "Seleciona Pedidos"
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image~\im-hel":U
     IMAGE-INSENSITIVE FILE "image~\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image~\im-joi":U
     IMAGE-INSENSITIVE FILE "image~\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image~\im-pri":U
     IMAGE-INSENSITIVE FILE "image~\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-d-todos 
     LABEL "&Desmarca Todos" 
     SIZE 13 BY 1.

DEFINE BUTTON bt-detalhes 
     LABEL "De&talhes" 
     SIZE 13 BY 1.

DEFINE BUTTON bt-m-todos 
     LABEL "&Marca Todos" 
     SIZE 13 BY 1.

DEFINE BUTTON bt-marca-desmarca 
     LABEL "Ma&rca" 
     SIZE 13 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-1 FOR 
      tt-pedido SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-1 wWindow _FREEFORM
  QUERY br-1 DISPLAY
      tt-pedido.num-pedido   COLUMN-LABEL "Pedido"       WIDTH 10 
tt-pedido.cod-emitente COLUMN-LABEL "Fornecedor"   WIDTH 10
tt-pedido.nome-abrev   COLUMN-LABEL "Nome Abrev"   WIDTH 20
tt-pedido.data-pedido  COLUMN-LABEL "Data Pedido"  WIDTH 10
tt-pedido.nr-proc-imp  COLUMN-LABEL "Processo Imp" WIDTH 12
tt-pedido.incoterm     COLUMN-LABEL "Incoterm"     WIDTH 08
tt-pedido.cod-itiner   COLUMN-LABEL "Itiner rio"   WIDTH 08
tt-pedido.desc-itiner  COLUMN-LABEL "Descri‡Æo"    WIDTH 40
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 83 BY 9.75
         FONT 1 ROW-HEIGHT-CHARS .45 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFiltro AT ROW 1.13 COL 70.72 HELP
          "Consultas relacionadas"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14.83
         FONT 1.

DEFINE FRAME fPage1
     br-1 AT ROW 1.25 COL 2
     bt-marca-desmarca AT ROW 11 COL 2
     bt-m-todos AT ROW 11 COL 15
     bt-d-todos AT ROW 11 COL 28
     bt-detalhes AT ROW 11 COL 41
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 85.43 BY 11.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 14.83
         WIDTH              = 89.72
         MAX-HEIGHT         = 18.29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 18.29
         VIRTUAL-WIDTH      = 146.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB br-1 1 fPage1 */
ASSIGN 
       br-1:NUM-LOCKED-COLUMNS IN FRAME fPage1     = 1.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-1
/* Query rebuild information for BROWSE br-1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-pedido.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-1 */
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

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  RUN pi-retorno IN h-im0017.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-1 wWindow
ON MOUSE-SELECT-DBLCLICK OF br-1 IN FRAME fPage1
DO:
    APPLY "CHOOSE":U  TO bt-marca-desmarca IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-1 wWindow
ON ROW-DISPLAY OF br-1 IN FRAME fPage1
DO:
    IF AVAIL tt-pedido THEN DO:

        IF tt-pedido.marca = YES THEN
          ASSIGN tt-pedido.num-pedido:FGCOLOR   IN BROWSE br-1 = 9
                 tt-pedido.cod-emitente:FGCOLOR IN BROWSE br-1 = 9
                 tt-pedido.nome-abrev:FGCOLOR   IN BROWSE br-1 = 9
                 tt-pedido.data-pedido:FGCOLOR  IN BROWSE br-1 = 9
                 tt-pedido.nr-proc-imp:FGCOLOR  IN BROWSE br-1 = 9
                 tt-pedido.incoterm:FGCOLOR     IN BROWSE br-1 = 9
                 tt-pedido.cod-itiner:FGCOLOR   IN BROWSE br-1 = 9
                 tt-pedido.desc-itiner:FGCOLOR  IN BROWSE br-1 = 9
                 tt-pedido.num-pedido:FONT      IN BROWSE br-1 = 6
                 tt-pedido.cod-emitente:FONT    IN BROWSE br-1 = 6
                 tt-pedido.nome-abrev:FONT      IN BROWSE br-1 = 6
                 tt-pedido.data-pedido:FONT     IN BROWSE br-1 = 6
                 tt-pedido.nr-proc-imp:FONT     IN BROWSE br-1 = 6
                 tt-pedido.incoterm:FONT        IN BROWSE br-1 = 6
                 tt-pedido.cod-itiner:FONT      IN BROWSE br-1 = 6
                 tt-pedido.desc-itiner:FONT     IN BROWSE br-1 = 6.
        ELSE
          ASSIGN tt-pedido.num-pedido:FGCOLOR   IN BROWSE br-1 = ?
                 tt-pedido.cod-emitente:FGCOLOR IN BROWSE br-1 = ?
                 tt-pedido.nome-abrev:FGCOLOR   IN BROWSE br-1 = ?
                 tt-pedido.data-pedido:FGCOLOR  IN BROWSE br-1 = ?
                 tt-pedido.nr-proc-imp:FGCOLOR  IN BROWSE br-1 = ?
                 tt-pedido.incoterm:FGCOLOR     IN BROWSE br-1 = ?
                 tt-pedido.cod-itiner:FGCOLOR   IN BROWSE br-1 = ?
                 tt-pedido.desc-itiner:FGCOLOR  IN BROWSE br-1 = ?
                 tt-pedido.num-pedido:FONT      IN BROWSE br-1 = ?
                 tt-pedido.cod-emitente:FONT    IN BROWSE br-1 = ?
                 tt-pedido.nome-abrev:FONT      IN BROWSE br-1 = ?
                 tt-pedido.data-pedido:FONT     IN BROWSE br-1 = ?
                 tt-pedido.nr-proc-imp:FONT     IN BROWSE br-1 = ?
                 tt-pedido.incoterm:FONT        IN BROWSE br-1 = ?
                 tt-pedido.cod-itiner:FONT      IN BROWSE br-1 = ?
                 tt-pedido.desc-itiner:FONT     IN BROWSE br-1 = ?.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-1 wWindow
ON VALUE-CHANGED OF br-1 IN FRAME fPage1
DO:
    DEFINE VARIABLE i-cont AS INTEGER NO-UNDO.
    
    ASSIGN l-label1 = NO
           l-label2 = NO.
    IF  br-1:NUM-SELECTED-ROWS IN FRAME fPage1 > 0 THEN DO: 
        DO i-cont = 1 TO br-1:NUM-SELECTED-ROWS IN FRAME fPage1:
            IF  br-1:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage1 THEN DO:

                GET CURRENT br-1.
                IF AVAIL tt-pedido then do:
                    IF  tt-pedido.marca = NO THEN
                        ASSIGN l-label1 = YES.
                    ELSE
                        ASSIGN l-label2 = YES.
                END.
            END.
        END.
        IF l-label1 AND l-label2 THEN 
            ASSIGN bt-marca-desmarca:LABEL     IN FRAME fPage1 = "Ma&rca"
                   bt-marca-desmarca:SENSITIVE IN FRAME fPage1 = NO.
        ELSE 
            IF l-label1 THEN
                ASSIGN bt-marca-desmarca:LABEL     IN FRAME fPage1 = "Ma&rca"
                   bt-marca-desmarca:SENSITIVE IN FRAME fPage1 = YES.
            ELSE 
                IF l-label2 then
                    ASSIGN bt-marca-desmarca:LABEL     IN FRAME fPage1 = "D&esmarca"
                           bt-marca-desmarca:SENSITIVE IN FRAME fPage1 = YES.
    END.
END.

/*
    IF NOT AVAIL tt-pedido then
        RETURN no-apply.
    
    IF tt-pedido.marca = YES THEN
        ASSIGN bt-marca:LABEL IN FRAME fPage1 = "Desma&rca".
    ELSE
        ASSIGN bt-marca:LABEL IN FRAME fPage1 = "Ma&rca".
    */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-d-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-d-todos wWindow
ON CHOOSE OF bt-d-todos IN FRAME fPage1 /* Desmarca Todos */
DO:
    FOR EACH tt-pedido
        WHERE tt-pedido.marca = YES:
        ASSIGN tt-pedido.marca = NO.
    END.
    {&OPEN-QUERY-br-1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-detalhes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-detalhes wWindow
ON CHOOSE OF bt-detalhes IN FRAME fPage1 /* Detalhes */
DO:
    IF NOT AVAIL tt-pedido THEN
        RETURN NO-APPLY.
    
    {&WINDOW-NAME}:SENSITIVE = NO.

    ASSIGN gr-pedido-compr = tt-pedido.r-rowid.
    RUN ccp/cc0509.w.

    {&WINDOW-NAME}:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-m-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-m-todos wWindow
ON CHOOSE OF bt-m-todos IN FRAME fPage1 /* Marca Todos */
DO:
    FOR EACH tt-pedido
        WHERE tt-pedido.marca = NO:
        ASSIGN tt-pedido.marca = YES.
    END.
    {&OPEN-QUERY-br-1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca-desmarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca-desmarca wWindow
ON CHOOSE OF bt-marca-desmarca IN FRAME fPage1 /* Marca */
DO:
    IF NOT AVAIL tt-pedido THEN
        RETURN NO-APPLY.

    IF  BROWSE br-1:NUM-SELECTED-ROWS <> 0 THEN DO:
        DO  i-rows = 1 TO br-1:NUM-SELECTED-ROWS IN FRAME fPage1:
    
            IF br-1:FETCH-SELECTED-ROW(i-rows)IN FRAME fPage1 THEN DO:
                GET CURRENT br-1.
            
                IF tt-pedido.marca = YES THEN  
                    ASSIGN tt-pedido.marca = NO.
                ELSE 
                    ASSIGN tt-pedido.marca = YES.   
                
                APPLY "row-display":U TO BROWSE br-1.
                br-1:REFRESH() IN FRAME fPage1.
            END.            
        END.
    END.                                         
    
    APPLY "value-changed":U TO  br-1 IN FRAME fPage1.
END.
                
/*
IF  BROWSE br-1:NUM-SELECTED-ROWS <> 0 THEN DO:
        DO  i-rows = 1 TO BROWSE br-1:NUM-SELECTED-ROWS:
    
            BROWSE br-1:FETCH-SELECTED-ROW(i-rows) NO-ERROR.
            GET CURRENT br-1.
            
            IF tt-pedido.marca = YES THEN  
                ASSIGN tt-pedido.marca = NO.
            ELSE 
                ASSIGN tt-pedido.marca = YES.   
            
            APPLY "row-display":U TO BROWSE br-1.
        END.
    END.                                         
    br-1:REFRESH().
    APPLY "value-changed":U TO BROWSE br-1.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    IF CAN-FIND(FIRST tt-pedido WHERE tt-pedido.marca = YES) THEN
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 30229,
                           INPUT "").
    
    IF NOT VALID-HANDLE(h-bocx225) THEN
        RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.

    FOR EACH tt-pedido
        WHERE tt-pedido.marca = YES:
        RUN procuraEmbarqueCompras IN h-bocx225 (INPUT tt-pedido.num-pedido,
                                                 INPUT ?,
                                                 INPUT ?,
                                                 OUTPUT TABLE tt-embarque).
        FOR EACH tt-embarque:
            FIND FIRST tt-embarque-aux
                WHERE tt-embarque-aux.embarque = tt-embarque.embarque NO-ERROR.
            IF NOT AVAIL tt-embarque-aux THEN
                CREATE tt-embarque-aux.
            ASSIGN tt-embarque-aux.embarque = tt-embarque.embarque.
        END.

    END.
    
    DELETE PROCEDURE h-bocx225.   
                
    FOR EACH tt-embarque-aux NO-LOCK:
        IF c-mensagem = "" THEN
            ASSIGN c-mensagem = tt-embarque-aux.embarque.
        ELSE
            ASSIGN c-mensagem = c-mensagem + ', ' + tt-embarque-aux.embarque.
    END.
    IF c-mensagem <> "" THEN 
        /* Inicio -- Projeto Internacional */
        DO:
        {utp/ut-liter.i "Despesas_do_Embarque" *}
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 28558,
                           INPUT c-mensagem + '~~' + RETURN-VALUE).
        END. 

    RUN setSelecao   IN h-im0017(INPUT TABLE tt-param).
    RUN setTempTable IN h-im0017 (INPUT TABLE tt-pedido,
                                  INPUT c-cod-estabel).

    RUN pi-retorno IN h-im0017.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro wWindow
ON CHOOSE OF btFiltro IN FRAME fpage0 /* Sele‡Æo de Pedidos */
DO:
  RUN pi-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Seleciona_Pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Seleciona_Pedidos wWindow
ON CHOOSE OF MENU-ITEM m_Seleciona_Pedidos /* Seleciona Pedidos */
DO:
  APPLY "CHOOSE":U TO btFiltro IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST tt-pedido NO-ERROR.
    IF NOT AVAIL tt-pedido THEN
        RUN pi-filtro.
    ELSE DO:
        {&OPEN-QUERY-br-1}
    END.                  

    APPLY "ENTRY" TO FRAME fPage1.

    RETURN "OK":U.    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-filtro wWindow 
PROCEDURE pi-filtro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

    IF  NOT VALID-HANDLE(h-im0017b) THEN
        RUN imp/im0017b.w PERSISTENT SET h-im0017b (INPUT THIS-PROCEDURE).

    RUN setSelecao          IN h-im0017b (INPUT TABLE tt-param).
    RUN inputPedidos        IN h-im0017b (INPUT TABLE tt-pedido).
    RUN initializeInterface IN h-im0017b.

    WAIT-FOR CLOSE OF h-im0017b FOCUS CURRENT-WINDOW.

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorno wWindow 
PROCEDURE pi-retorno :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&WINDOW-NAME}:SENSITIVE = YES.
    {&OPEN-QUERY-br-1}
    APPLY "ENTRY" to browse br-1.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSelecao wWindow 
PROCEDURE setSelecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER TABLE FOR tt-param.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTempTable wWindow 
PROCEDURE setTempTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER TABLE FOR tt-pedido.
    DEFINE INPUT PARAMETER pCod-estabel AS CHARACTER NO-UNDO.

    ASSIGN c-cod-estabel = pCod-estabel.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

