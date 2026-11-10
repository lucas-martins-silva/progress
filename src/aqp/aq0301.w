&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-carg-rural NO-UNDO LIKE carg-rural
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-estabelec NO-UNDO LIKE estabelec
       FIELD r-rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0301 2.00.00.028 } /*** 010028 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0301 MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          AQ0301
&GLOBAL-DEFINE Version        2.00.00.028

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Cargas

&GLOBAL-DEFINE First            NO
&GLOBAL-DEFINE Prev             NO
&GLOBAL-DEFINE Next             NO
&GLOBAL-DEFINE Last             NO
&GLOBAL-DEFINE GoTo             NO
&GLOBAL-DEFINE Search           NO

&GLOBAL-DEFINE AddParent        NO
&GLOBAL-DEFINE CopyParent       NO
&GLOBAL-DEFINE UpdateParent     NO
&GLOBAL-DEFINE DeleteParent     NO

&GLOBAL-DEFINE AddSon1          YES
&GLOBAL-DEFINE CopySon1         NO
&GLOBAL-DEFINE UpdateSon1       YES
&GLOBAL-DEFINE DeleteSon1       YES

&GLOBAL-DEFINE ttParent         tt-estabelec
&GLOBAL-DEFINE hDBOParent       h-boad107na
&GLOBAL-DEFINE DBOParentTable   estabelec
&GLOBAL-DEFINE DBOParentDestroy YES
  
&GLOBAL-DEFINE ttSon1           tt-carg-rural
&GLOBAL-DEFINE hDBOSon1         h-boin00961
&GLOBAL-DEFINE DBOSon1Table     carg-rural
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE page0Fields      tt-estabelec.cod-estabel tt-estabelec.nome

&GLOBAL-DEFINE page1Browse      brSon1           

DEFINE BUFFER bf-tt-carg-rural FOR tt-carg-rural.

/* Parameters Definitions ---                                           */

/* Shared Variable Definitions ---                                      */   


/* Local Variable Definitions ---                                       */
DEFINE VARIABLE p-tg-todos          AS LOGICAL INITIAL NO  NO-UNDO.
DEFINE VARIABLE p-tg-Iniciada       AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE p-tg-em-descarg     AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE p-tg-desc-concl     AS LOGICAL INITIAL NO  NO-UNDO.
DEFINE VARIABLE p-tg-estoq-atual    AS LOGICAL INITIAL NO  NO-UNDO.
DEFINE VARIABLE p-tg-Encerrada      AS LOGICAL INITIAL NO  NO-UNDO.
DEFINE VARIABLE p-tg-Reaberta       AS LOGICAL INITIAL NO  NO-UNDO.
DEFINE VARIABLE p-dt-trans          AS DATE    INITIAL TODAY NO-UNDO.

DEFINE VARIABLE pl-ok               AS LOGICAL   NO-UNDO.
DEFINE VARIABLE iStatus             AS INTEGER   NO-UNDO.
DEFINE VARIABLE l-enable            AS LOGICAL   NO-UNDO.

DEFINE VARIABLE p-cod-estabel       AS CHARACTER NO-UNDO.
DEFINE VARIABLE p-num-carga-ini     AS INTEGER   NO-UNDO.
DEFINE VARIABLE p-num-carga-fim     AS INTEGER   INITIAL 999999999 NO-UNDO.
DEFINE VARIABLE p-carga-ini         AS CHARACTER NO-UNDO.
DEFINE VARIABLE p-carga-fim         AS CHARACTER INITIAL "ZZZZZZZZZZZZZZZ" NO-UNDO.
DEFINE VARIABLE p-item-ini          AS CHARACTER NO-UNDO.
DEFINE VARIABLE p-item-fim          AS CHARACTER INITIAL "ZZZZZZZZZZZZ" NO-UNDO.
DEFINE VARIABLE p-dt-trans-ini      AS DATE INITIAL TODAY NO-UNDO.
DEFINE VARIABLE p-dt-trans-fim      AS DATE INITIAL TODAY NO-UNDO.
DEFINE VARIABLE p-placa-ini         AS CHARACTER NO-UNDO.
DEFINE VARIABLE p-placa-fim         AS CHARACTER INITIAL "ZZZZZZZZZZZZ" NO-UNDO.
DEFINE VARIABLE p-cod-rota-ini      AS CHARACTER NO-UNDO.
DEFINE VARIABLE p-cod-rota-fim      AS CHARACTER INITIAL "ZZZZZZZZZZZZ" NO-UNDO.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00965   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00981   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00982   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00983   AS HANDLE NO-UNDO. /* item-estab-rural */
DEFINE VARIABLE h-boin172na   AS HANDLE NO-UNDO. /* item */            
DEFINE VARIABLE h-boin417     AS HANDLE NO-UNDO. /* tab-unidade  */
DEFINE VARIABLE h-boin627     AS HANDLE NO-UNDO. /* usuar-mater  */



DEFINE NEW GLOBAL SHARED VARIABLE v_num-carg-aq0306  AS INTEGER NO-UNDO.
DEFINE NEW        SHARED VARIABLE v_num-carg-aq0301a AS INTEGER INITIAL ? NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_num-carg-aq0305  AS INTEGER NO-UNDO.


/* Seguranca por estabelecimento */
{cdp/cd0031.i}

DEFINE TEMP-TABLE tt-notas-geradas NO-UNDO
    FIELD cod-emitente LIKE produt-carg.cdn-produt-rural
    FIELD nro-docto    LIKE produt-carg.nro-docto
    FIELD serie-docto  LIKE produt-carg.serie-docto.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-carg-rural

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-carg-rural.num-carg tt-carg-rural.cod-carga tt-carg-rural.cod-placa tt-carg-rural.it-codigo tt-carg-rural.dat-trans fn-situacao(tt-carg-rural.cdn-sit) tt-carg-rural.qtd-peso-brut tt-carg-rural.qtd-peso-tara tt-carg-rural.qtd-peso-liq tt-carg-rural.cod-rota   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define SELF-NAME brSon1
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-carg-rural NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME}     FOR EACH tt-carg-rural NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-carg-rural
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-carg-rural


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-estabelec.cod-estabel tt-estabelec.nome 
&Scoped-define ENABLED-TABLES tt-estabelec
&Scoped-define FIRST-ENABLED-TABLE tt-estabelec
&Scoped-Define ENABLED-OBJECTS rtToolBar rtParent btSelecao btRefresh ~
btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-estabelec.cod-estabel tt-estabelec.nome 
&Scoped-define DISPLAYED-TABLES tt-estabelec
&Scoped-define FIRST-DISPLAYED-TABLE tt-estabelec
&Scoped-Define DISPLAYED-OBJECTS d-dt-trans 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-situacao wMasterDetail 
FUNCTION fn-situacao RETURNS CHARACTER
  ( iCdn-sit AS INTEGER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn_habilitaPesagem wMasterDetail 
FUNCTION fn_habilitaPesagem RETURNS LOGICAL
  ( c-cod-estabel AS CHAR, c-it-codigo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
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
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btRefresh 
     IMAGE-UP FILE "image/toolbar/im-relo.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-relo.bmp":U
     LABEL "Recarregar" 
     SIZE 4 BY 1.25 TOOLTIP "Recarregar".

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSelecao 
     IMAGE-UP FILE "image/im-ran.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-ran.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE d-dt-trans AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Transa‡Æo" 
      VIEW-AS TEXT 
     SIZE 11.72 BY .67 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 112.72 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 112.72 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAddSon1 
     LABEL "Incluir" 
     SIZE 10 BY 1 TOOLTIP "Incluir".

DEFINE BUTTON btDeleteSon1 
     LABEL "Eliminar" 
     SIZE 10 BY 1 TOOLTIP "Eliminar".

DEFINE BUTTON btEncerrar 
     LABEL "Encerrar" 
     SIZE 10 BY 1.

DEFINE BUTTON btEstoque 
     LABEL "Estoque" 
     SIZE 10 BY 1 TOOLTIP "Atualizar".

DEFINE BUTTON btLiberCarg 
     LABEL "Liber. Carga" 
     SIZE 10 BY 1 TOOLTIP "Controle Qualidade".

DEFINE BUTTON btPesagens 
     LABEL "Pesagens" 
     SIZE 10 BY 1 TOOLTIP "Pesagens".

DEFINE BUTTON btProdutores 
     LABEL "Produtores" 
     SIZE 10 BY 1 TOOLTIP "Produtores".

DEFINE BUTTON btUpdateSon1 
     LABEL "Alterar" 
     SIZE 10 BY 1 TOOLTIP "Alterar".

DEFINE BUTTON btVaPara 
     LABEL "V -Para" 
     SIZE 10 BY 1 TOOLTIP "V  Para".

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-carg-rural SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 NO-LOCK DISPLAY
      tt-carg-rural.num-carg COLUMN-LABEL "Carga" FORMAT ">>>,>>>,>>9":U
            WIDTH 11.43
      tt-carg-rural.cod-carga FORMAT "x(15)":U COLUMN-LABEL "C¢digo" WIDTH 9
      tt-carg-rural.cod-placa FORMAT "x(10)":U WIDTH 9
      tt-carg-rural.it-codigo FORMAT "x(16)":U WIDTH 13
      tt-carg-rural.dat-trans COLUMN-LABEL "Data Trans." FORMAT "99/99/9999":U
      fn-situacao(tt-carg-rural.cdn-sit) COLUMN-LABEL "Situa‡Æo" FORMAT "x(30)":U
            WIDTH 13.57
      tt-carg-rural.qtd-peso-brut FORMAT ">>>>,>>>,>>9.9999":U
            WIDTH 12
      tt-carg-rural.qtd-peso-tara COLUMN-LABEL "Tara" FORMAT ">>>>,>>>,>>9.9999":U
            WIDTH 12
      tt-carg-rural.qtd-peso-liq COLUMN-LABEL "Peso L¡quido" FORMAT ">>>>,>>>,>>9.9999":U
            WIDTH 12
      tt-carg-rural.cod-rota FORMAT "x(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 107 BY 9.13
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btSelecao AT ROW 1.13 COL 1.29 WIDGET-ID 42
     btRefresh AT ROW 1.13 COL 5.43 WIDGET-ID 40
     btQueryJoins AT ROW 1.13 COL 97 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 101 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 105 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 109 HELP
          "Ajuda"
     tt-estabelec.cod-estabel AT ROW 3.5 COL 14 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-estabelec.nome AT ROW 3.5 COL 24.14 COLON-ALIGNED NO-LABEL WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 50 BY .88
     d-dt-trans AT ROW 3.5 COL 92 COLON-ALIGNED WIDGET-ID 38
     rtToolBar AT ROW 1 COL 1
     rtParent AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 112.72 BY 17.67
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     btAddSon1 AT ROW 10.33 COL 2
     btUpdateSon1 AT ROW 10.33 COL 12
     btDeleteSon1 AT ROW 10.33 COL 22
     btVaPara AT ROW 10.33 COL 32 WIDGET-ID 2
     btProdutores AT ROW 10.33 COL 42 WIDGET-ID 4
     btEstoque AT ROW 10.33 COL 52 WIDGET-ID 12
     btLiberCarg AT ROW 10.33 COL 62 WIDGET-ID 6
     btPesagens AT ROW 10.33 COL 72 WIDGET-ID 10
     btEncerrar AT ROW 10.33 COL 82
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 6.38
         SIZE 109 BY 10.63
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
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
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMasterDetail ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17.67
         WIDTH              = 112.72
         MAX-HEIGHT         = 17.67
         MAX-WIDTH          = 140.43
         VIRTUAL-HEIGHT     = 17.67
         VIRTUAL-WIDTH      = 140.43
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMasterDetail 
/* ************************* Included-Libraries *********************** */

{masterdetail/masterdetail.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMasterDetail
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN d-dt-trans IN FRAME fPage0
   NO-ENABLE                                                            */
ASSIGN 
       d-dt-trans:READ-ONLY IN FRAME fPage0        = TRUE.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME}
    FOR EACH tt-carg-rural NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
    DEFINE VARIABLE h-prog-desp AS HANDLE  NO-UNDO.
    DEFINE VARIABLE i-num-carg  AS INTEGER NO-UNDO.
    
    SESSION:SET-WAIT-STATE("general":U).
    RUN aqp/aq0301a.w PERSISTENT SET h-prog-desp (INPUT ?,
                                                  INPUT tt-estabelec.r-rowid,
                                                  INPUT "Add":U,
                                                  INPUT THIS-PROCEDURE,
                                                  INPUT 0,
                                                  INPUT p-dt-trans).
                                                  
    IF VALID-HANDLE(h-prog-desp) THEN DO:
        RUN initializeInterface IN h-prog-desp.
        SESSION:SET-WAIT-STATE("":U).         
        WAIT-FOR CLOSE OF h-prog-desp FOCUS CURRENT-WINDOW.
    END.
    
    IF v_num-carg-aq0301a <> ? THEN DO:            
        RUN openQueriesSon IN THIS-PROCEDURE.        
        FOR FIRST tt-carg-rural 
            WHERE tt-carg-rural.num-carg = v_num-carg-aq0301a:    
            REPOSITION brSon1 TO ROWID ROWID(tt-carg-rural) NO-ERROR.                             
        END. 
        APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1. 
        ASSIGN v_num-carg-aq0301a = ?.
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMasterDetail
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:
    
    {masterdetail/deleteson.i &PageNumber="1"} 
                                                
     APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEncerrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEncerrar wMasterDetail
ON CHOOSE OF btEncerrar IN FRAME fPage1 /* Encerrar */
DO: 
    DEFINE VARIABLE i-num-carg AS INTEGER NO-UNDO.
    DEFINE VARIABLE l-per-fech AS LOGICAL NO-UNDO.
    DEFINE VARIABLE c-msg  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-msg2 AS CHARACTER   NO-UNDO.
    
    IF AVAIL tt-carg-rural THEN DO:
    
        ASSIGN i-num-carg = tt-carg-rural.num-carg.
        
        IF tt-carg-rural.cdn-sit = 4 
        OR tt-carg-rural.cdn-sit = 6 THEN DO:

        
            RUN utp/ut-msgs.p (INPUT 'SHOW':U, 
                               INPUT 54702, /* Confirma encerramento da carga &1 */
                               INPUT tt-carg-rural.num-carg).
    
            IF RETURN-VALUE = 'YES':U THEN DO:
            
                /* Atualiza quantidade aferida e coletada na tabela carg-rural */
                RUN atualizaQtdEncerramento IN {&hDBOSon1}(INPUT tt-carg-rural.num-carg).
            
                RUN emptyRowErrors IN {&hDBOSon1}.
                RUN encerrarCarga  IN {&hDBOSon1}(INPUT tt-carg-rural.num-carg).
                RUN getRowErrors   IN {&hDBOSon1}(OUTPUT TABLE RowErrors).
                IF CAN-FIND(FIRST RowErrors
                             WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
                    RUN aqp/aq0301rp.p(INPUT 1,
                                       INPUT tt-carg-rural.num-carg,
                                       INPUT TABLE tt-carg-rural, 
                                       INPUT TABLE RowErrors).
                    RETURN NO-APPLY.
                END.
                
                RUN openQueriesSon IN THIS-PROCEDURE.
                
                FOR FIRST tt-carg-rural 
                    WHERE tt-carg-rural.num-carg = i-num-carg:        
                    REPOSITION brSon1 TO ROWID ROWID(tt-carg-rural) NO-ERROR.
                    brSon1:SELECT-FOCUSED-ROW ( ).
                    APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1. 
                END.
            END.
        END.    
        ELSE IF tt-carg-rural.cdn-sit = 5 THEN DO:
             
            RUN verificaPeriodoFechado IN {&hDBOSon1} (INPUT  tt-carg-rural.cod-estabel,
                                                       INPUT  tt-carg-rural.dat-trans,
                                                       OUTPUT l-per-fech).

            IF l-per-fech THEN DO:
    
                {utp/ut-liter.i  Incluir/Reabrir_carga *}
                ASSIGN c-msg = RETURN-VALUE.
        
                {utp/ut-liter.i  per¡odo_fechado *}
                ASSIGN c-msg2 = RETURN-VALUE.

                RUN utp/ut-msgs.p (INPUT 'SHOW':U, 
                                   INPUT 54818, 
                                   INPUT c-msg + "~~" + c-msg2).

                RETURN NO-APPLY.

            END.
            ELSE DO:                
                RUN utp/ut-msgs.p (INPUT 'SHOW':U, 
                                   INPUT 54708, /* Confirma reabertura da carga &1 */
                                   INPUT tt-carg-rural.num-carg).
                
                IF RETURN-VALUE = 'YES':U THEN DO:
                    EMPTY TEMP-TABLE tt-notas-geradas NO-ERROR.
                    RUN emptyRowErrors IN {&hDBOSon1}.                
                    RUN validaReaberturaCarga IN {&hDBOSon1}(INPUT tt-carg-rural.num-carg).
                    IF RETURN-VALUE = "NOK" THEN DO:              
                        RUN getRowErrors IN {&hDBOSon1}(OUTPUT TABLE RowErrors).                
                        RUN aqp/aq0301rp.p(INPUT 2,
                                           INPUT tt-carg-rural.num-carg,
                                           INPUT TABLE tt-carg-rural, 
                                           INPUT TABLE RowErrors).
                        RETURN NO-APPLY.
                    END.
                    ELSE DO:                  
                        RUN reabrirCarga   IN {&hDBOSon1}(INPUT tt-carg-rural.num-carg).
                        RUN getRowErrors   IN {&hDBOSon1}(OUTPUT TABLE RowErrors).
                        IF CAN-FIND(FIRST RowErrors
                                    WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
                            RUN aqp/aq0301rp.p(INPUT 2,
                                               INPUT TABLE tt-carg-rural, 
                                               INPUT TABLE RowErrors).
                            RETURN NO-APPLY.
                        END.               
                        RUN openQueriesSon IN THIS-PROCEDURE.
                        FOR FIRST tt-carg-rural 
                            WHERE tt-carg-rural.num-carg = i-num-carg:        
                            REPOSITION brSon1 TO ROWID ROWID(tt-carg-rural) NO-ERROR.
                            brSon1:SELECT-FOCUSED-ROW ( ).
                            APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1. 
                        END.
                    END.    
                END.
            END.    
        END.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEstoque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEstoque wMasterDetail
ON CHOOSE OF btEstoque IN FRAME fPage1 /* Estoque */
DO:
   DEFINE VARIABLE h-prog-desp AS HANDLE NO-UNDO.       

    IF AVAIL tt-carg-rural THEN
        ASSIGN v_num-carg-aq0306 = tt-carg-rural.num-carg.

    {&WINDOW-NAME}:SENSITIVE = NO.  
    SESSION:SET-WAIT-STATE("general":U).
    
    RUN aqp/aq0306.w PERSISTENT SET h-prog-desp.      


    IF VALID-HANDLE(h-prog-desp) THEN DO:
        RUN initializeInterface IN h-prog-desp.
         
        SESSION:SET-WAIT-STATE("":U).
         
        WAIT-FOR CLOSE OF h-prog-desp FOCUS CURRENT-WINDOW.
    END.
    RUN openQueriesSon IN THIS-PROCEDURE.
    FOR FIRST tt-carg-rural 
        WHERE tt-carg-rural.num-carg = v_num-carg-aq0306:        
        REPOSITION brSon1 TO ROWID ROWID(tt-carg-rural) NO-ERROR.
        brSon1:SELECT-FOCUSED-ROW ( ) NO-ERROR.
        APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1. 
    END.     
    ASSIGN v_num-carg-aq0306 = ?.
    
    {&WINDOW-NAME}:SENSITIVE = YES.  
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btLiberCarg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLiberCarg wMasterDetail
ON CHOOSE OF btLiberCarg IN FRAME fPage1 /* Liber. Carga */
DO: 
    DEFINE VARIABLE h-prog-desp AS HANDLE    NO-UNDO.
    
    IF  AVAIL tt-carg-rural THEN DO:
        {&WINDOW-NAME}:SENSITIVE = NO.  
        SESSION:SET-WAIT-STATE("general":U).
        
        ASSIGN v_num-carg-aq0305 = tt-carg-rural.num-carg.
        
        RUN aqp/aq0305.w PERSISTENT SET h-prog-desp.
        IF VALID-HANDLE(h-prog-desp) THEN DO:            
            RUN initializeInterface IN h-prog-desp.         
            SESSION:SET-WAIT-STATE("":U).
            WAIT-FOR CLOSE OF h-prog-desp FOCUS CURRENT-WINDOW.
        END.
        
        RUN openQueriesSon IN THIS-PROCEDURE.
        FOR FIRST tt-carg-rural 
            WHERE tt-carg-rural.num-carg = v_num-carg-aq0305:        
            REPOSITION brSon1 TO ROWID ROWID(tt-carg-rural) NO-ERROR.
            brSon1:SELECT-FOCUSED-ROW ( ) NO-ERROR.
            APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1. 
        END. 
        
        ASSIGN v_num-carg-aq0305 = ?.
        {&WINDOW-NAME}:SENSITIVE = YES.  
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPesagens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPesagens wMasterDetail
ON CHOOSE OF btPesagens IN FRAME fPage1 /* Pesagens */
DO:
    DEFINE VARIABLE i-num-carg aS INTEGER NO-UNDO. 
  
    IF AVAIL tt-carg-rural THEN DO:
        {&WINDOW-NAME}:SENSITIVE = NO.
        ASSIGN i-num-carg = tt-carg-rural.num-carg.        
        RUN aqp/aq0301d.w(INPUT tt-carg-rural.num-carg).        
        IF RETURN-VALUE = "OK" THEN DO:
            RUN openQueriesSon IN THIS-PROCEDURE.
            FOR FIRST tt-carg-rural 
                WHERE tt-carg-rural.num-carg = i-num-carg:        
                REPOSITION brSon1 TO ROWID ROWID(tt-carg-rural) NO-ERROR.
                brSon1:SELECT-FOCUSED-ROW ( ).
                APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1. 
            END.
        END.
        {&WINDOW-NAME}:SENSITIVE = YES.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btProdutores
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btProdutores wMasterDetail
ON CHOOSE OF btProdutores IN FRAME fPage1 /* Produtores */
DO:
    DEFINE VARIABLE h-prog-desp AS HANDLE NO-UNDO.       
      
    SESSION:SET-WAIT-STATE("general":U).
    {&WINDOW-NAME}:SENSITIVE = FALSE.
    RUN aqp/aq0302.w PERSISTENT SET h-prog-desp (INPUT tt-carg-rural.num-carg).      


    IF VALID-HANDLE(h-prog-desp) THEN DO:
        RUN initializeInterface IN h-prog-desp.
         
        SESSION:SET-WAIT-STATE("":U).
         
        WAIT-FOR CLOSE OF h-prog-desp FOCUS CURRENT-WINDOW.
    END.
    {&WINDOW-NAME}:SENSITIVE = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMasterDetail
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btRefresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRefresh wMasterDetail
ON CHOOSE OF btRefresh IN FRAME fPage0 /* Recarregar */
DO:    
    DEFINE VARIABLE i-num-carg aS INTEGER NO-UNDO. 
    IF AVAIL tt-carg-rural THEN DO:
        ASSIGN i-num-carg = tt-carg-rural.num-carg.   
        RUN openQueriesSon IN THIS-PROCEDURE.
        FOR FIRST tt-carg-rural 
            WHERE tt-carg-rural.num-carg = i-num-carg:        
            REPOSITION brSon1 TO ROWID ROWID(tt-carg-rural) NO-ERROR.
            brSon1:SELECT-FOCUSED-ROW( ) IN FRAME fPage1.
            APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1. 
        END.
    END.            
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMasterDetail
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSelecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelecao wMasterDetail
ON CHOOSE OF btSelecao IN FRAME fPage0
DO:
    DEFINE VARIABLE rGoTo             AS ROWID     NO-UNDO.
    DEFINE VARIABLE c-cod-estabel-old AS CHARACTER NO-UNDO.

    {&WINDOW-NAME}:SENSITIVE = FALSE.

    ASSIGN c-cod-estabel-old = p-cod-estabel.
    
    RUN aqp/aq0301b.w (INPUT-OUTPUT p-tg-todos,         
                       INPUT-OUTPUT p-tg-Iniciada,      
                       INPUT-OUTPUT p-tg-em-descarg,    
                       INPUT-OUTPUT p-tg-desc-concl,    
                       INPUT-OUTPUT p-tg-estoq-atual,   
                       INPUT-OUTPUT p-tg-Encerrada,     
                       INPUT-OUTPUT p-tg-Reaberta,
                       INPUT-OUTPUT p-dt-trans,         
                       INPUT-OUTPUT p-cod-estabel,  
                       INPUT-OUTPUT p-num-carga-ini,
                       INPUT-OUTPUT p-num-carga-fim,
                       INPUT-OUTPUT p-carga-ini,    
                       INPUT-OUTPUT p-carga-fim ,   
                       INPUT-OUTPUT p-item-ini ,    
                       INPUT-OUTPUT p-item-fim ,    
                       INPUT-OUTPUT p-dt-trans-ini, 
                       INPUT-OUTPUT p-dt-trans-fim, 
                       INPUT-OUTPUT p-placa-ini,    
                       INPUT-OUTPUT p-placa-fim,  
                       INPUT-OUTPUT p-cod-rota-ini,    
                       INPUT-OUTPUT p-cod-rota-fim,
                       INPUT-OUTPUT pl-ok).
                       
    {&WINDOW-NAME}:SENSITIVE = TRUE.

    IF p-cod-estabel <> c-cod-estabel-old THEN DO:
        /*:T Posiciona query, do DBO, atrav²s dos valores do ­ndice œnico */
        RUN goToKey IN {&hDBOParent} (INPUT p-cod-estabel).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "estabelec":U).
            RETURN NO-APPLY.
        END.
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
    END.

    RUN afterDisplayFields IN THIS-PROCEDURE. 
    RUN openQueriesSon IN THIS-PROCEDURE. 

    APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Alterar */
DO:
    DEFINE VARIABLE h-prog-desp AS HANDLE  NO-UNDO.
    DEFINE VARIABLE i-num-carg  AS INTEGER NO-UNDO.    
    IF AVAIL tt-carg-rural THEN DO:    
        ASSIGN i-num-carg = tt-carg-rural.num-carg.    
    
        SESSION:SET-WAIT-STATE("general":U).
        RUN aqp/aq0301a.w PERSISTENT SET h-prog-desp (INPUT tt-carg-rural.r-rowid,
                                                      INPUT tt-estabelec.r-rowid,
                                                      INPUT "Update":U,
                                                      INPUT THIS-PROCEDURE,
                                                      INPUT 0,
                                                      INPUT p-dt-trans).
      
        IF VALID-HANDLE(h-prog-desp) THEN DO:
            RUN initializeInterface IN h-prog-desp.
             
            SESSION:SET-WAIT-STATE("":U).
             
            WAIT-FOR CLOSE OF h-prog-desp FOCUS CURRENT-WINDOW.
        END.

        RUN openQueriesSon IN THIS-PROCEDURE.    
        FOR FIRST tt-carg-rural 
            WHERE tt-carg-rural.num-carg = i-num-carg:        
            REPOSITION brSon1 TO ROWID ROWID(tt-carg-rural) NO-ERROR.
            brSon1:SELECT-FOCUSED-ROW ( ).
            APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1. 
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btVaPara
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVaPara wMasterDetail
ON CHOOSE OF btVaPara IN FRAME fPage1 /* V -Para */
DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMasterDetail
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{masterdetail/mainblock.i}

/* Sobrescrita de triggers para evitar erro de temp-table duplicada */
ON OFF-END OF brSon1 IN FRAME fPage1
DO:
END.

ON OFF-HOME OF brSon1 IN FRAME fPage1
DO:
END.
    
ASSIGN btSelecao:SENSITIVE IN FRAME fPage0 = YES
       btRefresh:SENSITIVE IN FRAME fPage0 = YES
       btAddSon1:SENSITIVE IN FRAME fPage1 = YES.

ON VALUE-CHANGED OF brSon1 IN FRAME fPage1
DO: 
    {masterdetail/valuechanged.i &PageNumber="1"}
    DEFINE VARIABLE l-pesagem-pendente AS LOGICAL NO-UNDO.    

    {utp/ut-liter.i Encerrar *}
    ASSIGN btEncerrar:LABEL    IN FRAME fPage1 = RETURN-VALUE.
          
    
    IF AVAILABLE tt-carg-rural THEN DO:
        IF tt-carg-rural.cdn-sit = 5 THEN DO:
            {utp/ut-liter.i Reabrir *}
            ASSIGN btEncerrar:LABEL IN FRAME fPage1 = RETURN-VALUE.
        END.
        
        ASSIGN btEstoque:TOOLTIP IN FRAME fPage1 = "".
        
        IF tt-carg-rural.cdn-sit = 3 THEN DO:
            {utp/ut-liter.i Atualizar *}
            ASSIGN btEstoque:TOOLTIP IN FRAME fPage1 = RETURN-VALUE.
        END.
        
        IF tt-carg-rural.cdn-sit = 4 OR tt-carg-rural.cdn-sit = 6 THEN DO:
            {utp/ut-liter.i Desatualizar *}
            ASSIGN btEstoque:TOOLTIP IN FRAME fPage1 = RETURN-VALUE.
        END. 
        IF VALID-HANDLE(h-boin00981) THEN
            RUN verificarPesagensPendentes IN h-boin00981(INPUT tt-carg-rural.num-carg, OUTPUT l-pesagem-pendente).      
        /* {ininc/i01in00961.i}
            val1 Iniciada            val5 Carga Encerrada
            val2 Em descarga         val6 Carga Reaberta
            val3 Descarga Conclu¡da  val7 Gerado Fiscal Parcial
            val4 Estoque Atualizado  val8 Gerado Fiscal Todos */
        ASSIGN btVaPara:SENSITIVE     IN FRAME fPage1 = AVAIL tt-carg-rural
               btLiberCarg:SENSITIVE  IN FRAME fPage1 = AVAIL tt-carg-rural
               btDeleteSon1:SENSITIVE IN FRAME fPage1 = AVAIL tt-carg-rural  AND tt-carg-rural.cdn-sit <= 3    
               btUpdateSon1:SENSITIVE IN FRAME fPage1 = AVAIL tt-carg-rural  AND tt-carg-rural.cdn-sit <> 5 
               btProdutores:SENSITIVE IN FRAME fPage1 = AVAIL tt-carg-rural  AND tt-carg-rural.cdn-sit <> 5
               btEstoque:SENSITIVE    IN FRAME fPage1 = AVAIL tt-carg-rural  AND (tt-carg-rural.cdn-sit = 3 OR 
                                                                                  tt-carg-rural.cdn-sit = 4 OR 
                                                                                  tt-carg-rural.cdn-sit = 6) 
                                                                             AND NOT l-pesagem-pendente
               btEncerrar:SENSITIVE   IN FRAME fPage1 = AVAIL tt-carg-rural  AND tt-carg-rural.cdn-sit >= 4 AND tt-carg-rural.cdn-sit <= 6
               btPesagens:SENSITIVE   IN FRAME fPage1 = AVAIL tt-carg-rural  AND fn_habilitaPesagem(tt-carg-rural.cod-estabel, tt-carg-rural.it-codigo).        
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMasterDetail 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE({&hDBOParent}) AND
        {&hDBOParent}:TYPE = "PROCEDURE":U AND
        {&hDBOParent}:FILE-NAME = "adbo/boad107na.p":U THEN DO:
        DELETE PROCEDURE {&hDBOParent}.
        ASSIGN {&hDBOParent} = ?.
    END.

    IF VALID-HANDLE({&hDBOSon1}) AND
        {&hDBOSon1}:TYPE = "PROCEDURE":U AND
        {&hDBOSon1}:FILE-NAME = "inbo/boin00961.p":U THEN DO:
        DELETE PROCEDURE {&hDBOSon1}.
        ASSIGN {&hDBOSon1} = ?.
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

    IF VALID-HANDLE(h-boin00982) AND
        h-boin00982:TYPE = "PROCEDURE":U AND
        h-boin00982:FILE-NAME = "inbo/boin00982.p":U THEN DO:
        DELETE PROCEDURE h-boin00982.
        ASSIGN h-boin00982 = ?.
    END.
    IF VALID-HANDLE(h-boin00983) AND
        h-boin00983:TYPE = "PROCEDURE":U AND
        h-boin00983:FILE-NAME = "inbo/boin00983.p":U THEN DO:
        DELETE PROCEDURE h-boin00983.
        ASSIGN h-boin00983 = ?.
    END.

    IF VALID-HANDLE(h-boin172na) AND
        h-boin172na:TYPE = "PROCEDURE":U AND
        h-boin172na:FILE-NAME = "inbo/boin172na.p":U THEN DO:
        DELETE PROCEDURE h-boin172na.
        ASSIGN h-boin172na = ?.
    END.


    IF VALID-HANDLE(h-boin417) AND
        h-boin417:TYPE = "PROCEDURE":U AND
        h-boin417:FILE-NAME = "inbo/boin417.p":U THEN DO:
        DELETE PROCEDURE h-boin417.
        ASSIGN h-boin417 = ?.
    END.
 
     IF VALID-HANDLE(h-boin627) AND
        h-boin627:TYPE = "PROCEDURE":U AND
        h-boin627:FILE-NAME = "inbo/boin627.p":U THEN DO:
        DELETE PROCEDURE h-boin627.
        ASSIGN h-boin627 = ?.
    END. 


    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN d-dt-trans:SCREEN-VALUE IN FRAME fPage0 = STRING(p-dt-trans).
    IF AVAILABLE tt-carg-rural THEN DO:
      ASSIGN btPesagens:SENSITIVE IN FRAME fPage1 = fn_habilitaPesagem(tt-carg-rural.cod-estabel, tt-carg-rural.it-codigo).
    END.
    
    APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1.

    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-char-1  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-retorno AS CHARACTER NO-UNDO.    
     
    FIND FIRST param-estoq NO-LOCK NO-ERROR.
    IF AVAILABLE param-estoq THEN 
        ASSIGN p-cod-estabel = param-estoq.estabel-pad.

    IF VALID-HANDLE(h-boin627) THEN DO:
        RUN findUsuar_mater IN h-boin627 (INPUT c-seg-usuario, OUTPUT c-retorno).
      
        IF c-retorno = "" THEN DO:
            RUN getCharField IN h-boin627 (INPUT "char-1", OUTPUT c-char-1). 
            IF SUBSTR(c-char-1,16,5) <> "" THEN
                ASSIGN p-cod-estabel = SUBSTR(c-char-1,16,5).
        END.
    END.
       
    RUN goToKey IN {&hDBOParent} (INPUT p-cod-estabel).

    /*:T Posiciona query, do DBO, atrav²s dos valores do ­ndice œnico */
    RUN goToKey IN {&hDBOParent} (INPUT p-cod-estabel).
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "estabelec":U).
        
        RETURN NO-APPLY.
    END.
        
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
    
    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

    DEFINE VARIABLE i-num-carg  LIKE {&ttSon1}.num-carg LABEL "Carga" NO-UNDO. 
    DEFINE VARIABLE c-cod-placa LIKE {&ttSon1}.cod-placa NO-UNDO. 
    
    DEFINE FRAME fGoToRecord
        i-num-carg AT ROW 1.80 COL 10.00 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12.57 BY .78
        c-cod-placa AT ROW 1.80 COL 35.00 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12.57 BY .78
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Carga" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
    {utp/ut-liter.i "V _Para_Carga"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */
                                         
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-num-carg .
        
        IF i-num-carg > 0 THEN DO:
            FIND FIRST tt-carg-rural NO-LOCK 
                 WHERE tt-carg-rural.num-carg = (INPUT i-num-carg) NO-ERROR.
            IF AVAILABLE tt-carg-rural THEN
               REPOSITION brSon1 TO ROWID ROWID(tt-carg-rural) NO-ERROR.
            ELSE DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Carga":U).           
                RETURN NO-APPLY.
            END.
            
            APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1.
        END.

        ASSIGN c-cod-placa.
       
            IF c-cod-placa <> "" THEN DO:
            FIND FIRST tt-carg-rural NO-LOCK 
                 WHERE tt-carg-rural.cod-placa = (INPUT c-cod-placa) NO-ERROR.
            IF AVAILABLE tt-carg-rural THEN
               REPOSITION brSon1 TO ROWID ROWID(tt-carg-rural) NO-ERROR.
            ELSE DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Placa":U).           
                RETURN NO-APPLY.
            END.
            
            APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1.
        END.
          
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE i-num-carg btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
                  
    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "adbo/boad107na.p":U THEN DO:
            
        {btb/btb008za.i1 adbo/boad107na.p YES}
        {btb/btb008za.i2 adbo/boad107na.p '' {&hDBOParent}}                       
    END.

    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.   
        
    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "inbo/boin00961.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00961.p YES}
        {btb/btb008za.i2 inbo/boin00961.p '' {&hDBOSon1}} 
    END.

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
    
    RUN openQueryStatic IN h-boin00981 (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00982) OR 
        h-boin00982:TYPE <> "PROCEDURE":U OR
        h-boin00982:FILE-NAME <> "inbo/boin00982.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00982.p YES}
        {btb/btb008za.i2 inbo/boin00982.p ''  h-boin00982} 
    END.
    
    RUN openQueryStatic IN h-boin00982 (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00983) OR 
        h-boin00983:TYPE <> "PROCEDURE":U OR
        h-boin00983:FILE-NAME <> "inbo/boin00983.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00983.p YES}
        {btb/btb008za.i2 inbo/boin00983.p ''  h-boin00983} 
    END.
    
    RUN openQueryStatic IN h-boin00983 (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin172na) OR 
        h-boin172na:TYPE <> "PROCEDURE":U OR
        h-boin172na:FILE-NAME <> "inbo/boin172na.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin172na.p YES}
        {btb/btb008za.i2 inbo/boin172na.p ''  h-boin172na} 
    END.
    
    RUN openQueryStatic IN h-boin172na (INPUT "Main":U) NO-ERROR.

        /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin417) OR 
        h-boin417:TYPE <> "PROCEDURE":U OR
        h-boin417:FILE-NAME <> "inbo/boin417.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin417.p YES}
        {btb/btb008za.i2 inbo/boin417.p ''  h-boin417} 
    END.
    
    RUN openQueryStatic IN h-boin417 (INPUT "Main":U) NO-ERROR.
  
    IF NOT VALID-HANDLE(h-boin627) THEN
        RUN inbo/boin627.p PERSISTENT SET h-boin627.

    RUN openQuery IN h-boin627 (INPUT 1) NO-ERROR.  
       
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iRowsReturned AS INTEGER NO-UNDO.
    
    IF VALID-HANDLE({&hDBOSon1}) THEN DO:

        RUN setConstraintControleCargas IN {&hDBOSon1} (INPUT p-cod-estabel,
                                                        INPUT p-num-carga-ini,      
                                                        INPUT p-num-carga-fim,
                                                        INPUT p-carga-ini,      
                                                        INPUT p-carga-fim,      
                                                        INPUT p-item-ini,       
                                                        INPUT p-item-fim,       
                                                        INPUT p-dt-trans-ini,   
                                                        INPUT p-dt-trans-fim,   
                                                        INPUT p-placa-ini,      
                                                        INPUT p-placa-fim,  
                                                        INPUT p-cod-rota-ini,      
                                                        INPUT p-cod-rota-fim, 
                                                        INPUT p-tg-Iniciada,       
                                                        INPUT p-tg-em-descarg,     
                                                        INPUT p-tg-desc-concl,     
                                                        INPUT p-tg-estoq-atual,    
                                                        INPUT p-tg-Encerrada,      
                                                        INPUT p-tg-Reaberta) NO-ERROR. 
                                                         
        RUN openQueryStatic IN {&hDBOSon1}(INPUT "ControleCargas":U).    
        RUN getBatchRecords IN {&hDBOSon1} (INPUT ?,
                                            INPUT NO,
                                            INPUT 99999,
                                            OUTPUT iRowsReturned,
                                            OUTPUT TABLE tt-carg-rural).
        /*--- Abre a query associada ao browse da p gina {&PageNumber} ---*/  
        {&OPEN-QUERY-brSon1}
                                                                            
        IF AVAILABLE tt-carg-rural THEN         
            ASSIGN btVaPara:SENSITIVE IN FRAME fPage1 = YES 
                   btProdutores:SENSITIVE IN FRAME fPage1 = YES
                   btEstoque:SENSITIVE IN FRAME fPage1 = YES                
                   btLiberCarg:SENSITIVE IN FRAME fPage1 = YES
                   btPesagens:SENSITIVE IN FRAME fPage1 = YES. 
        ELSE
            ASSIGN btVaPara:SENSITIVE IN FRAME fPage1 = NO 
                   btProdutores:SENSITIVE IN FRAME fPage1 = NO
                   btEstoque:SENSITIVE IN FRAME fPage1 = NO                
                   btLiberCarg:SENSITIVE IN FRAME fPage1 = NO
                   btPesagens:SENSITIVE IN FRAME fPage1 = NO. 
    END.     
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-situacao wMasterDetail 
FUNCTION fn-situacao RETURNS CHARACTER
  ( iCdn-sit AS INTEGER ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
   RETURN {ininc/i01in00961.i 04 iCdn-sit}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn_habilitaPesagem wMasterDetail 
FUNCTION fn_habilitaPesagem RETURNS LOGICAL
  ( c-cod-estabel AS CHAR, c-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-idi-tip-aferic AS INTEGER     NO-UNDO.       

    IF VALID-HANDLE(h-boin172na) AND VALID-HANDLE(h-boin00983) THEN DO:
         /* item */
        RUN goToKey IN h-boin172na (INPUT tt-carg-rural.it-codigo).
        IF RETURN-VALUE = 'OK':U THEN DO:
            /*item-estab-rural*/
            RUN goToKey IN h-boin00983 (INPUT tt-carg-rural.it-codigo, INPUT tt-carg-rural.cod-estabel).
            IF RETURN-VALUE = 'OK':U THEN 
                RUN getIntField IN h-boin00983 (INPUT 'idi-tip-aferic':U, OUTPUT i-idi-tip-aferic).           
        END.
    END.
    
    RETURN i-idi-tip-aferic = 1. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

