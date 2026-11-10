&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-af-historico-alteracao NO-UNDO LIKE af-historico-alteracao
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0602 2.00.00.019 } /*** 010019 ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AF0602 MAF}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AF0602
&GLOBAL-DEFINE Version        2.00.00.019

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Hist¢rico

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btExport btCancel btHelp2 rb-selecao cb-tabelas cb-campos rd-ordenacao ~
                              dt-data-ini dt-data-fim hr-hora-ini hr-hora-fim ~
                              c-usuario-ini c-usuario-fim br-table1 c-compare

/* Parameters Definitions ---                                           */
{cdp/cdcfgmat.i}
/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-desc-tabela LIKE af-historico-alteracao.nome-tabela   NO-UNDO.
DEFINE VARIABLE c-desc-campo LIKE af-historico-alteracao.campo   NO-UNDO.
DEFINE VARIABLE c-chave AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-boaf024 AS HANDLE      NO-UNDO.
DEFINE TEMP-TABLE bktt-af-historico-alteracao NO-UNDO LIKE tt-af-historico-alteracao.
DEFINE VARIABLE i-tipo-ordenacao AS INTEGER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-table1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-af-historico-alteracao

/* Definitions for BROWSE br-table1                                     */
&Scoped-define FIELDS-IN-QUERY-br-table1 tt-af-historico-alteracao.seq tt-af-historico-alteracao.chave tt-af-historico-alteracao.nome-tabela fn-retorna-descricao(INPUT "tabela":U, INPUT tt-af-historico-alteracao.nome-tabela, INPUT "") @ c-desc-tabela tt-af-historico-alteracao.campo fn-retorna-descricao(INPUT "campo":U, INPUT tt-af-historico-alteracao.nome-tabela, INPUT tt-af-historico-alteracao.campo) @ c-desc-campo fn-traduz-valor(INPUT tt-af-historico-alteracao.vl-anterior) @ tt-af-historico-alteracao.vl-anterior fn-traduz-valor(INPUT tt-af-historico-alteracao.vl-novo) @ tt-af-historico-alteracao.vl-novo tt-af-historico-alteracao.usuar-alter tt-af-historico-alteracao.dt-alter tt-af-historico-alteracao.hora-alter   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table1   
&Scoped-define SELF-NAME br-table1
&Scoped-define OPEN-QUERY-br-table1 CASE i-tipo-ordenacao:     WHEN 1 THEN DO:         OPEN QUERY {&SELF-NAME} FOR EACH tt-af-historico-alteracao NO-LOCK             BY tt-af-historico-alteracao.nome-tabela             BY tt-af-historico-alteracao.campo INDEXED-REPOSITION.     END.     WHEN 2 THEN DO:         OPEN QUERY {&SELF-NAME} FOR EACH tt-af-historico-alteracao NO-LOCK             BY tt-af-historico-alteracao.dt-alter             BY tt-af-historico-alteracao.hora-alter INDEXED-REPOSITION.     END.     WHEN 3 THEN DO:         OPEN QUERY {&SELF-NAME} FOR EACH tt-af-historico-alteracao NO-LOCK             BY tt-af-historico-alteracao.usuar-alter INDEXED-REPOSITION.     END. END CASE.
&Scoped-define TABLES-IN-QUERY-br-table1 tt-af-historico-alteracao
&Scoped-define FIRST-TABLE-IN-QUERY-br-table1 tt-af-historico-alteracao


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-table1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-55 RECT-56 ~
RECT-57 IMAGE-36 IMAGE-37 IMAGE-38 IMAGE-39 RECT-58 IMAGE-40 IMAGE-41 ~
btCheck1 btQueryJoins btReportsJoins btExit btHelp rb-selecao rd-ordenacao ~
cb-tabelas cb-campos btn-filtro btn-Clear dt-data-ini dt-data-fim ~
c-usuario-ini c-usuario-fim hr-hora-ini hr-hora-fim br-table1 btChave ~
c-compare btExport btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS rb-selecao rd-ordenacao cb-tabelas ~
cb-campos dt-data-ini dt-data-fim c-usuario-ini c-usuario-fim hr-hora-ini ~
hr-hora-fim c-compare 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-retorna-descricao wWindow 
FUNCTION fn-retorna-descricao RETURNS CHARACTER
  (INPUT c-tipo AS CHAR, INPUT c-tabela AS CHAR, INPUT c-campo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-traduz-valor wWindow 
FUNCTION fn-traduz-valor RETURNS CHARACTER
  (INPUT c-valor AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
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
DEFINE BUTTON btCancel 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btChave 
     LABEL "Visualizar Chave" 
     SIZE 13 BY 1.13.

DEFINE BUTTON btCheck1 
     IMAGE-UP FILE "image/im-relo.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExport 
     LABEL "Exportar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btn-Clear 
     LABEL "Limpar Filtro" 
     SIZE 11 BY 1.

DEFINE BUTTON btn-filtro 
     LABEL "Filtro" 
     SIZE 11 BY 1.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image/im-joi":U
     IMAGE-INSENSITIVE FILE "image/ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image/im-pri":U
     IMAGE-INSENSITIVE FILE "image/ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE cb-campos AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 23.29 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tabelas AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 26 BY 1 NO-UNDO.

DEFINE VARIABLE c-compare AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 86 BY 2.5 NO-UNDO.

DEFINE VARIABLE c-usuario-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-usuario-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usu†rio" 
     VIEW-AS FILL-IN 
     SIZE 15.14 BY .88 NO-UNDO.

DEFINE VARIABLE dt-data-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE dt-data-ini AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE hr-hora-fim AS CHARACTER FORMAT "99:99:99":U INITIAL "99:99:99" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE hr-hora-ini AS CHARACTER FORMAT "99:99:99":U INITIAL "99:99:99" 
     LABEL "Hora" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-36
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-37
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-38
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-39
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-40
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-41
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE VARIABLE rb-selecao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todas as tabelas", 1,
"Tabela espec°fica", 2
     SIZE 22 BY 1.5 NO-UNDO.

DEFINE VARIABLE rd-ordenacao AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Tabela/Campo", 1,
"Data/Hora", 2,
"Usu†rio", 3
     SIZE 15 BY 2.25 NO-UNDO.

DEFINE RECTANGLE RECT-55
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 52 BY 4.21.

DEFINE RECTANGLE RECT-56
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32 BY 4.21.

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 2.75.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 2.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table1 FOR 
      tt-af-historico-alteracao SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table1 wWindow _FREEFORM
  QUERY br-table1 NO-LOCK DISPLAY
      tt-af-historico-alteracao.seq FORMAT ">>>>>>>>9":U 
          WIDTH 5
      tt-af-historico-alteracao.chave FORMAT "x(80)":U
          WIDTH 20
      tt-af-historico-alteracao.nome-tabela COLUMN-LABEL "Tabela" FORMAT "x(50)":U      
          WIDTH 20
      fn-retorna-descricao(INPUT "tabela":U, INPUT tt-af-historico-alteracao.nome-tabela, INPUT "") @ c-desc-tabela COLUMN-LABEL "Desc Tabela" FORMAT "x(50)":U
          WIDTH 20
      tt-af-historico-alteracao.campo FORMAT "x(50)":U
          WIDTH 20
      fn-retorna-descricao(INPUT "campo":U, INPUT tt-af-historico-alteracao.nome-tabela, INPUT tt-af-historico-alteracao.campo) @ c-desc-campo COLUMN-LABEL "Desc Campo" FORMAT "x(50)":U
          WIDTH 20
      fn-traduz-valor(INPUT tt-af-historico-alteracao.vl-anterior) @  tt-af-historico-alteracao.vl-anterior COLUMN-LABEL "Valor Antigo" FORMAT "x(2000)":U
          WIDTH 20
      fn-traduz-valor(INPUT tt-af-historico-alteracao.vl-novo) @ tt-af-historico-alteracao.vl-novo COLUMN-LABEL "Valor Novo" FORMAT "x(2000)":U
          WIDTH 20
      tt-af-historico-alteracao.usuar-alter COLUMN-LABEL "Usu†rio" FORMAT "x(12)":U
          WIDTH 12
      tt-af-historico-alteracao.dt-alter COLUMN-LABEL "Data" FORMAT "99/99/9999":U
          WIDTH 10
      tt-af-historico-alteracao.hora-alter COLUMN-LABEL "Hora" FORMAT "x(8)":U
          WIDTH 8
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 86 BY 5.75
         FONT 1 ROW-HEIGHT-CHARS .6 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btCheck1 AT ROW 1.13 COL 70.57
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     rb-selecao AT ROW 3.5 COL 4 NO-LABEL
     rd-ordenacao AT ROW 3.5 COL 57 NO-LABEL
     cb-tabelas AT ROW 5.17 COL 2 COLON-ALIGNED NO-LABEL
     cb-campos AT ROW 5.17 COL 28.72 COLON-ALIGNED NO-LABEL
     btn-filtro AT ROW 6.08 COL 31.72
     btn-Clear AT ROW 6.08 COL 43.14
     dt-data-ini AT ROW 7.96 COL 6.57 COLON-ALIGNED
     dt-data-fim AT ROW 7.96 COL 27 COLON-ALIGNED NO-LABEL
     c-usuario-ini AT ROW 8.58 COL 48.86 COLON-ALIGNED
     c-usuario-fim AT ROW 8.58 COL 71 COLON-ALIGNED NO-LABEL
     hr-hora-ini AT ROW 8.96 COL 6.57 COLON-ALIGNED
     hr-hora-fim AT ROW 9 COL 27 COLON-ALIGNED NO-LABEL
     br-table1 AT ROW 10.5 COL 3
     btChave AT ROW 16.25 COL 76
     c-compare AT ROW 17.5 COL 3 NO-LABEL
     btExport AT ROW 20.71 COL 2
     btCancel AT ROW 20.71 COL 13
     btHelp2 AT ROW 20.71 COL 80
     "Seleá∆o" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 2.75 COL 4
     "Data/Hora" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 7.25 COL 4
     "Ordenaá∆o" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 2.75 COL 58
     "Usu†rio" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 7.25 COL 45
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 20.5 COL 1
     RECT-55 AT ROW 3.04 COL 3
     RECT-56 AT ROW 3.04 COL 56
     RECT-57 AT ROW 7.5 COL 3
     IMAGE-36 AT ROW 7.96 COL 21
     IMAGE-37 AT ROW 7.96 COL 25.29
     IMAGE-38 AT ROW 8.96 COL 21
     IMAGE-39 AT ROW 8.96 COL 25.29
     RECT-58 AT ROW 7.5 COL 44
     IMAGE-40 AT ROW 8.58 COL 66.29
     IMAGE-41 AT ROW 8.58 COL 69.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 21.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-af-historico-alteracao T "?" NO-UNDO emsdca af-historico-alteracao
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 21.25
         WIDTH              = 90
         MAX-HEIGHT         = 21.25
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 21.25
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB br-table1 hr-hora-fim fpage0 */
ASSIGN 
       c-compare:READ-ONLY IN FRAME fpage0        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table1
/* Query rebuild information for BROWSE br-table1
     _START_FREEFORM
CASE i-tipo-ordenacao:
    WHEN 1 THEN DO:
        OPEN QUERY {&SELF-NAME} FOR EACH tt-af-historico-alteracao NO-LOCK
            BY tt-af-historico-alteracao.nome-tabela
            BY tt-af-historico-alteracao.campo INDEXED-REPOSITION.
    END.
    WHEN 2 THEN DO:
        OPEN QUERY {&SELF-NAME} FOR EACH tt-af-historico-alteracao NO-LOCK
            BY tt-af-historico-alteracao.dt-alter
            BY tt-af-historico-alteracao.hora-alter INDEXED-REPOSITION.
    END.
    WHEN 3 THEN DO:
        OPEN QUERY {&SELF-NAME} FOR EACH tt-af-historico-alteracao NO-LOCK
            BY tt-af-historico-alteracao.usuar-alter INDEXED-REPOSITION.
    END.
END CASE.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-table1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
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
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-table1
&Scoped-define SELF-NAME br-table1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table1 wWindow
ON VALUE-CHANGED OF br-table1 IN FRAME fpage0
DO:  
  ASSIGN c-compare:SCREEN-VALUE = "Valor antigo: " + fn-traduz-valor(INPUT tt-af-historico-alteracao.vl-anterior) + chr(13) +
                                  "Valor novo: " + fn-traduz-valor(INPUT tt-af-historico-alteracao.vl-novo).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btChave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btChave wWindow
ON CHOOSE OF btChave IN FRAME fpage0 /* Visualizar Chave */
DO:
   IF AVAIL tt-af-historico-alteracao THEN
        RUN pi-abre-filtro (INPUT FALSE, INPUT tt-af-historico-alteracao.nome-tabela).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCheck1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck1 wWindow
ON CHOOSE OF btCheck1 IN FRAME fpage0
DO:
    DEFINE VARIABLE cTabela AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cCampo AS CHARACTER   NO-UNDO.
    IF rb-selecao:SCREEN-VALUE IN FRAME fpage0 = '1' THEN
        ASSIGN cTabela = ""
               cCampo = "Todos".
    ELSE
        ASSIGN cTabela = ENTRY(LOOKUP(cb-tabelas:SCREEN-VALUE IN FRAME fpage0,
                            cb-tabelas:LIST-ITEM-PAIRS),cb-tabelas:LIST-ITEM-PAIRS)
               cCampo = ENTRY(LOOKUP(cb-campos:SCREEN-VALUE IN FRAME fpage0,
                            cb-campos:LIST-ITEM-PAIRS),cb-campos:LIST-ITEM-PAIRS).
    
   ASSIGN c-compare:SCREEN-VALUE IN FRAME fpage0 = ""
          i-tipo-ordenacao = INPUT FRAME fpage0 rd-ordenacao.

   RUN setConstraintFiltro IN h-boaf024 (INPUT cTabela, 
                                         INPUT cCampo,
                                         INPUT c-chave,
                                         INPUT hr-hora-ini:SCREEN-VALUE IN FRAME fpage0,
                                         INPUT hr-hora-fim:SCREEN-VALUE IN FRAME fpage0,
                                         INPUT c-usuario-ini:SCREEN-VALUE IN FRAME fpage0,
                                         INPUT c-usuario-fim:SCREEN-VALUE IN FRAME fpage0,
                                         INPUT INPUT FRAME fpage0 dt-data-ini,
                                         INPUT INPUT FRAME fpage0 dt-data-fim,
                                         INPUT i-tipo-ordenacao).

   EMPTY TEMP-TABLE tt-af-historico-alteracao.
   EMPTY TEMP-TABLE bktt-af-historico-alteracao.

   RUN pi-processa-query IN h-boaf024 (OUTPUT TABLE tt-af-historico-alteracao) NO-ERROR.

   FOR EACH tt-af-historico-alteracao NO-LOCK:
       CREATE bktt-af-historico-alteracao.
       BUFFER-COPY tt-af-historico-alteracao TO bktt-af-historico-alteracao.
   END.

   {&OPEN-QUERY-br-Table1}
   IF AVAIL tt-af-historico-alteracao THEN
        APPLY "VALUE-CHANGED":U TO br-table1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExport wWindow
ON CHOOSE OF btExport IN FRAME fpage0 /* Exportar */
DO:
  RUN pi-exporta-dados.
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


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-Clear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-Clear wWindow
ON CHOOSE OF btn-Clear IN FRAME fpage0 /* Limpar Filtro */
DO:
  ASSIGN c-chave = "".
  APPLY "CHOOSE":U TO btCheck1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-filtro wWindow
ON CHOOSE OF btn-filtro IN FRAME fpage0 /* Filtro */
DO:
  RUN pi-abre-filtro (INPUT TRUE, INPUT ENTRY(LOOKUP(cb-tabelas:SCREEN-VALUE IN FRAME fpage0,
        cb-tabelas:LIST-ITEM-PAIRS),cb-tabelas:LIST-ITEM-PAIRS)).
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


&Scoped-define SELF-NAME cb-tabelas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tabelas wWindow
ON VALUE-CHANGED OF cb-tabelas IN FRAME fpage0
DO:   
    RUN pi-carrega-campos (INPUT ENTRY(LOOKUP(cb-tabelas:SCREEN-VALUE IN FRAME fpage0,
        cb-tabelas:LIST-ITEM-PAIRS),cb-tabelas:LIST-ITEM-PAIRS)).
    ASSIGN c-chave = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME hr-hora-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hr-hora-fim wWindow
ON LEAVE OF hr-hora-fim IN FRAME fpage0
DO:
  DEFINE VARIABLE c-valor AS CHARACTER   NO-UNDO.
  ASSIGN c-valor = REPLACE(TRIM(hr-hora-fim:SCREEN-VALUE IN FRAME fpage0),":","")
         hr-hora-fim:SCREEN-VALUE IN FRAME fpage0 = TRIM(c-valor) + FILL("0", 10 - LENGTH(TRIM(c-valor))).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME hr-hora-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hr-hora-ini wWindow
ON LEAVE OF hr-hora-ini IN FRAME fpage0 /* Hora */
DO:
  IF LENGTH(hr-hora-ini:SCREEN-VALUE IN FRAME fpage0) < 8 THEN DO:
      DEFINE VARIABLE c-valor AS CHARACTER   NO-UNDO.
      ASSIGN c-valor = REPLACE(TRIM(hr-hora-ini:SCREEN-VALUE IN FRAME fpage0),":","").
      ASSIGN hr-hora-ini:SCREEN-VALUE IN FRAME fpage0 = TRIM(c-valor) + FILL("0", 10 - LENGTH(TRIM(c-valor))).
  END.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rb-selecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rb-selecao wWindow
ON VALUE-CHANGED OF rb-selecao IN FRAME fpage0
DO:
    DEFINE VARIABLE c-tabela AS CHARACTER   NO-UNDO.
    ASSIGN c-tabela = ENTRY(2,cb-tabelas:LIST-ITEM-PAIRS)
           cb-tabelas:SCREEN-VALUE IN FRAME fpage0 = c-tabela
           c-chave = "".

    IF rb-selecao:SCREEN-VALUE = '1' THEN DO:
        RUN pi-habilita-compenentes(INPUT FALSE).
        ASSIGN cb-campos:LIST-ITEM-PAIRS IN FRAME fpage0 = "Todos,Todos"
               cb-campos:SCREEN-VALUE IN FRAME fpage0 = "Todos".
    END.
    ELSE DO:
        RUN pi-habilita-compenentes(INPUT TRUE).
        RUN pi-carrega-campos(INPUT c-tabela).
    END.
RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rd-ordenacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rd-ordenacao wWindow
ON VALUE-CHANGED OF rd-ordenacao IN FRAME fpage0
DO:
  APPLY "CHOOSE":U TO btCheck1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-boaf024) THEN DO:
        DELETE PROCEDURE h-boaf024.
        ASSIGN h-boaf024 = ?.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN initializeDBOs.
RUN pi-carrega-tabelas.
RUN pi-carrega-campos (INPUT "").

RUN pi-habilita-compenentes (INPUT FALSE).

ENABLE btCheck1
       btChave
    WITH FRAME fpage0.

/*DISABLE c-compare
    WITH FRAME fpage0.*/

ASSIGN hr-hora-ini:SCREEN-VALUE = "000000"
       hr-hora-fim:SCREEN-VALUE = "235959" NO-ERROR.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT VALID-HANDLE(h-boaf024) THEN DO:
    RUN afbo/boaf024.p PERSISTEN SET h-boaf024.
END.

RUN openQueryStatic IN h-boaf024 (INPUT "Main":U).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-abre-filtro wWindow 
PROCEDURE pi-abre-filtro :
/*------------------------------------------------------------------------------
  Purpose:     Chama os eventos Semelhante ao GotoRecord para abrir o filtro dinÉmicamente
  Parameters:  pHabilita -> Para mostrar ou n∆o os campos habilitados para ediá∆o
               pTabela   -> O nome da tabela.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pHabilita AS LOGICAL NO-UNDO.
DEFINE INPUT PARAMETER pTabela AS CHARACTER NO-UNDO.

CASE pTabela:
    WHEN "param-af":U THEN
        RUN pi-abre-filtro-param (INPUT pHabilita).
    WHEN "af-versao-avaliacao":U THEN
        RUN pi-abre-filtro-versao (INPUT pHabilita).
    WHEN "af-periodo-aval":U THEN
        RUN pi-abre-filtro-ano (INPUT pHabilita).
END CASE.
      
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-abre-filtro-ano wWindow 
PROCEDURE pi-abre-filtro-ano :
/*------------------------------------------------------------------------------
  Purpose:     Evento Semelhante ao GotoRecord para abrir o filtro dinÉmicamente
  Parameters:  pHabilita -> Para mostrar ou n∆o os campos habilitados para ediá∆o
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pHabilita AS LOGICAL NO-UNDO.
    DEFINE BUTTON btCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtAbreFiltro
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 35 BY 1.42
         BGCOLOR 7.   
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.    
    DEFINE VARIABLE i-campo-filtro AS INTEGER FORMAT '9999' NO-UNDO.
    
    DEFINE FRAME fAbreFiltro
        i-campo-filtro  AT ROW 1.8 COL 14 COLON-ALIGNED
        btOK        AT ROW 3.6 COL 2.14
        btCancel    AT ROW 3.6 COL 13
        rtAbreFiltro    AT ROW 3.4 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Filtrar campos por ano avaliaá∆o" FONT 1
             DEFAULT-BUTTON btOK CANCEL-BUTTON btCancel.

        run pi_aplica_facelift_thin in h-facelift (input frame fAbreFiltro:HANDLE).

    IF pHabilita THEN
        ASSIGN i-campo-filtro:SCREEN-VALUE IN FRAME fAbreFiltro = c-chave.
    ELSE DO:
        IF AVAIL tt-af-historico-alteracao THEN
            ASSIGN i-campo-filtro:SCREEN-VALUE IN FRAME fAbreFiltro = tt-af-historico-alteracao.chave.
    END.        


    ON "CHOOSE":U OF btOK IN FRAME fAbreFiltro DO:

        ASSIGN i-campo-filtro
               c-chave = STRING(i-campo-filtro).

        IF pHabilita THEN
            APPLY "CHOOSE":U TO btCheck1 IN FRAME fPage0.
    END.
    
    ENABLE i-campo-filtro
           btOK btCancel 
        WITH FRAME fAbreFiltro.

    ASSIGN i-campo-filtro:HEIGHT    = 0.88
       i-campo-filtro:WIDTH     = 7
       i-campo-filtro:LABEL     = "Ano avaliaá∆o".
    
    IF NOT pHabilita THEN
        DISABLE i-campo-filtro
                btOK 
            WITH FRAME fAbreFiltro.
    
    WAIT-FOR "GO":U OF FRAME fAbreFiltro.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-abre-filtro-param wWindow 
PROCEDURE pi-abre-filtro-param :
/*------------------------------------------------------------------------------
  Purpose:     Evento Semelhante ao GotoRecord para abrir o filtro dinÉmicamente
  Parameters:  pHabilita -> Para mostrar ou n∆o os campos habilitados para ediá∆o
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pHabilita AS LOGICAL NO-UNDO.

    DEFINE BUTTON btCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtAbreFiltro
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 35 BY 1.42
         BGCOLOR 7.   
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.    
    DEFINE VARIABLE i-campo-filtro AS INTEGER FORMAT '>>>9' NO-UNDO.
    
    DEFINE FRAME fAbreFiltro
        i-campo-filtro  AT ROW 1.8 COL 14 COLON-ALIGNED
        btOK        AT ROW 3.6 COL 2.14
        btCancel    AT ROW 3.6 COL 13
        rtAbreFiltro    AT ROW 3.4 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Filtrar campos por parÉmetro." FONT 1
             DEFAULT-BUTTON btOK CANCEL-BUTTON btCancel.

        run pi_aplica_facelift_thin in h-facelift (input frame fAbreFiltro:HANDLE).
        
    IF pHabilita THEN
        ASSIGN i-campo-filtro:SCREEN-VALUE IN FRAME fAbreFiltro = c-chave.
    ELSE DO:
        IF AVAIL tt-af-historico-alteracao THEN
            ASSIGN i-campo-filtro:SCREEN-VALUE IN FRAME fAbreFiltro = tt-af-historico-alteracao.chave.
    END.        


    ON "CHOOSE":U OF btOK IN FRAME fAbreFiltro DO:

        ASSIGN i-campo-filtro
               c-chave = STRING(i-campo-filtro).

        IF pHabilita THEN
            APPLY "CHOOSE":U TO btCheck1 IN FRAME fPage0.
    END.
    
    ENABLE i-campo-filtro
           btOK btCancel 
        WITH FRAME fAbreFiltro.

    ASSIGN i-campo-filtro:HEIGHT    = 0.88
       i-campo-filtro:WIDTH     = 7
       i-campo-filtro:LABEL     = "ParÉmetro".
    
    IF NOT pHabilita THEN
        DISABLE i-campo-filtro
                btOK 
            WITH FRAME fAbreFiltro.
    
    WAIT-FOR "GO":U OF FRAME fAbreFiltro.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-abre-filtro-versao wWindow 
PROCEDURE pi-abre-filtro-versao :
/*------------------------------------------------------------------------------
  Purpose:     Evento Semelhante ao GotoRecord para abrir o filtro dinÉmicamente
  Parameters:  pHabilita -> Para mostrar ou n∆o os campos habilitados para ediá∆o
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pHabilita AS LOGICAL NO-UNDO.
    DEFINE BUTTON btCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtAbreFiltro
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 35 BY 1.42
         BGCOLOR 7.
   
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.    
    DEFINE VARIABLE i-campo-filtro AS INTEGER FORMAT '>>>>9' NO-UNDO.
    
    DEFINE FRAME fAbreFiltro
        i-campo-filtro  AT ROW 1.8 COL 14 COLON-ALIGNED
        btOK        AT ROW 3.6 COL 2.14
        btCancel    AT ROW 3.6 COL 13
        rtAbreFiltro    AT ROW 3.4 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Filtrar campos por vers∆o" FONT 1
             DEFAULT-BUTTON btOK CANCEL-BUTTON btCancel.

        run pi_aplica_facelift_thin in h-facelift (input frame fAbreFiltro:HANDLE).

    IF pHabilita THEN
        ASSIGN i-campo-filtro:SCREEN-VALUE IN FRAME fAbreFiltro = c-chave.
    ELSE DO:
        IF AVAIL tt-af-historico-alteracao THEN
            ASSIGN i-campo-filtro:SCREEN-VALUE IN FRAME fAbreFiltro = tt-af-historico-alteracao.chave.
    END.        


    ON "CHOOSE":U OF btOK IN FRAME fAbreFiltro DO:

        ASSIGN i-campo-filtro
               c-chave = STRING(i-campo-filtro).

        IF pHabilita THEN
            APPLY "CHOOSE":U TO btCheck1 IN FRAME fPage0.
    END.
    
    ENABLE i-campo-filtro
           btOK btCancel 
        WITH FRAME fAbreFiltro.

    ASSIGN i-campo-filtro:HEIGHT    = 0.88
       i-campo-filtro:WIDTH     = 7
       i-campo-filtro:LABEL     = "Vers∆o".
    
    IF NOT pHabilita THEN
        DISABLE i-campo-filtro
                btOK 
            WITH FRAME fAbreFiltro.
    
    WAIT-FOR "GO":U OF FRAME fAbreFiltro.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-campos wWindow 
PROCEDURE pi-carrega-campos :
/*------------------------------------------------------------------------------
  Purpose:     Monta o combobox para os campos das tabelas.
  Parameters:  pTabela -> Nome da Tabela para filtrar
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pTabela AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-campos AS CHARACTER INIT "Todos,Todos"  NO-UNDO.

FIND FIRST dictdb._file NO-LOCK
    WHERE dictdb._file._file-name = pTabela NO-ERROR.

IF AVAIL dictdb._file THEN DO:
    FOR EACH dictdb._field NO-LOCK 
        WHERE dictdb._field._file-recid = RECID(dictdb._file)
         AND   dictdb._field._field-name <> "char-1":U 
         AND   dictdb._field._field-name <> "char-2":U
         AND   dictdb._field._field-name <> "log-1":U
         AND   dictdb._field._field-name <> "log-2":U
         AND   dictdb._field._field-name <> "dec-1":U
         AND   dictdb._field._field-name <> "dec-2":U
         AND   dictdb._field._field-name <> "int-1":U
         AND   dictdb._field._field-name <> "int-2":U
         AND   dictdb._field._field-name <> "data-1":U
         AND   dictdb._field._field-name <> "data-2":U
        BY dictdb._field._field-name:        
        ASSIGN c-campos = c-campos + "," + fn-retorna-descricao(INPUT "campo":U, INPUT pTabela, INPUT dictdb._field._field-name) + "," + dictdb._field._field-name.        
    END.
END.

ASSIGN cb-campos:LIST-ITEM-PAIRS IN FRAME fpage0 = c-campos
       cb-campos:SCREEN-VALUE IN FRAME fpage0 = "Todos".

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-tabelas wWindow 
PROCEDURE pi-carrega-tabelas :
/*------------------------------------------------------------------------------
  Purpose:     Monta o combobox para as tabelas.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-campos AS CHARACTER   NO-UNDO.

/*Pega o Label da tablea Param-af para montar o combo*/
ASSIGN c-campos = fn-retorna-descricao(INPUT "tabela":U, INPUT "param-af":U, "") + ",param-af":U.

/*Pega o Label da tablea af-periodo-aval para montar o combo*/
ASSIGN c-campos = c-campos + "," + fn-retorna-descricao(INPUT "tabela":U, INPUT "af-periodo-aval":U, "") + ",af-periodo-aval":U.

/*Pega o Label da tablea af-versao-avaliacao para montar o combo*/
ASSIGN c-campos = c-campos + "," + fn-retorna-descricao(INPUT "tabela":U, INPUT "af-versao-avaliacao":U, "") + ",af-versao-avaliacao":U
       cb-tabelas:LIST-ITEM-PAIRS IN FRAME fpage0 = c-campos
       cb-tabelas:SCREEN-VALUE IN FRAME fpage0 = "param-af".


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executa-tela wWindow 
PROCEDURE pi-executa-tela :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para ser chamada por outros programas para setar os valores
                iniciais
  Parameters:  pc-tabela - Tabela para filtro.
               pc-chave - Chave da tabela.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pc-tabela AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pc-chave AS CHARACTER NO-UNDO.
/*Posiciona na tabela selecionada
  Seta o valor no campo chave.*/
ASSIGN cb-tabelas:SCREEN-VALUE IN FRAME fpage0 = pc-tabela
       c-chave = pc-chave 
       rb-selecao:SCREEN-VALUE IN FRAME fpage0 = "2":U.
/*Carrega o combo de campos*/
RUN pi-carrega-campos(INPUT pc-tabela).
/*Habilita os combos de tabelas e campos*/
RUN pi-habilita-compenentes(INPUT TRUE).
/*Executa o bot∆o para carregar a query*/
APPLY "CHOOSE":U TO btCheck1 IN FRAME fpage0.

RETURN "OK":U.                        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exporta-dados wWindow 
PROCEDURE pi-exporta-dados :
/*------------------------------------------------------------------------------
  Purpose:     Exporta dos dados da Temp-Table
  Parameters:  <none>
  Notes:       session:temp-directory + "af0602.csv":U
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-cabecalho     AS CHARACTER INITIAL ""     NO-UNDO.
DEFINE VARIABLE c-separador     AS CHARACTER  INITIAL ";":U NO-UNDO.
/*Traduá‰es*/
{utp/ut-liter.i Seq * L}
ASSIGN c-cabecalho = c-cabecalho + TRIM(RETURN-VALUE) + c-separador.
{utp/ut-liter.i Chave * L}
ASSIGN c-cabecalho = c-cabecalho + TRIM(RETURN-VALUE) + c-separador.
{utp/ut-liter.i Tabela * L}
ASSIGN c-cabecalho = c-cabecalho + TRIM(RETURN-VALUE) + c-separador.
{utp/ut-liter.i Desc_Tabela * L}
ASSIGN c-cabecalho = c-cabecalho + TRIM(RETURN-VALUE) + c-separador.
{utp/ut-liter.i Campo * L}
ASSIGN c-cabecalho = c-cabecalho + TRIM(RETURN-VALUE) + c-separador.
{utp/ut-liter.i Desc_Campo * L}
ASSIGN c-cabecalho = c-cabecalho + TRIM(RETURN-VALUE) + c-separador.
{utp/ut-liter.i Valor_Antigo * L}
ASSIGN c-cabecalho = c-cabecalho + TRIM(RETURN-VALUE) + c-separador.
{utp/ut-liter.i Valor_Novo * L}
ASSIGN c-cabecalho = c-cabecalho + TRIM(RETURN-VALUE) + c-separador.
{utp/ut-liter.i Usu†rio * L}
ASSIGN c-cabecalho = c-cabecalho + TRIM(RETURN-VALUE) + c-separador.
{utp/ut-liter.i Data * L}
ASSIGN c-cabecalho = c-cabecalho + TRIM(RETURN-VALUE) + c-separador.
{utp/ut-liter.i Hora * L}
ASSIGN c-cabecalho = c-cabecalho + TRIM(RETURN-VALUE) + c-separador.
{utp/ut-liter.i Progr_Alterado * L}
ASSIGN c-cabecalho = c-cabecalho + TRIM(RETURN-VALUE) + c-separador.
{utp/ut-liter.i Empresa * L}
ASSIGN c-cabecalho = c-cabecalho + TRIM(RETURN-VALUE).

CASE i-tipo-ordenacao:
    WHEN 1 THEN
        RUN pi-exporta-por-campos(INPUT c-cabecalho).
    WHEN 2 THEN
        RUN pi-exporta-por-data(INPUT c-cabecalho).
    WHEN 3 THEN
        RUN pi-exporta-por-usuario(INPUT c-cabecalho).
END CASE.

{utp/ut-liter.i dos_dados_para_o_arquivo * L}
RUN utp/ut-msgs.p (input "SHOW":U, input 8620, input RETURN-VALUE + " " + STRING(session:temp-directory + "af0602.csv":U)).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exporta-por-campos wWindow 
PROCEDURE pi-exporta-por-campos :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para exportar os dados por nome da tabela e campo
  Parameters:  c-cabecalho -> cabeáalho do arquivo
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-cabecalho AS CHARACTER   NO-UNDO.
OUTPUT TO VALUE (session:temp-directory + "af0602.csv":U) Convert Target "ISO8859-1":U.
    PUT c-cabecalho FORMAT "x(200)":U SKIP.
    FOR EACH bktt-af-historico-alteracao NO-LOCK
        BY bktt-af-historico-alteracao.nome-tabela
        BY bktt-af-historico-alteracao.campo:
        PUT    bktt-af-historico-alteracao.Seq FORMAT ">>>>>>>>9":U ";":U
               bktt-af-historico-alteracao.chave FORMAT "x(80)":U ";":U   
               bktt-af-historico-alteracao.nome-tabela FORMAT "x(50)":U ";":U
               fn-retorna-descricao("tabela":U,bktt-af-historico-alteracao.nome-tabela, "") FORMAT "x(50)":U ";":U
               bktt-af-historico-alteracao.campo FORMAT "x(50)":U ";":U 
               fn-retorna-descricao("campo":U,bktt-af-historico-alteracao.nome-tabela, bktt-af-historico-alteracao.campo) FORMAT "x(50)":U ";":U
               replace(bktt-af-historico-alteracao.vl-anterior,CHR(10)," ":U) FORMAT "x(2000)":U ";":U 
               replace(bktt-af-historico-alteracao.vl-novo,CHR(10)," ":U) FORMAT "x(2000)":U ";":U
               bktt-af-historico-alteracao.usuar-alter FORMAT "x(12)":U ";":U 
               bktt-af-historico-alteracao.dt-alter FORMAT "99/99/99":U ";":U
               bktt-af-historico-alteracao.hora-alter FORMAT "x(8)":U ";":U 
               bktt-af-historico-alteracao.prog-alter FORMAT "x(30)":U ";":U
               bktt-af-historico-alteracao.ep-codigo FORMAT "x(3)":U SKIP.
    END.       
OUTPUT CLOSE.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exporta-por-data wWindow 
PROCEDURE pi-exporta-por-data :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para exportar os dados por data e hora
  Parameters:  c-cabecalho -> cabeáalho do arquivo
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-cabecalho AS CHARACTER   NO-UNDO.
OUTPUT TO VALUE (session:temp-directory + "af0602.csv":U) Convert Target "ISO8859-1":U.
    PUT c-cabecalho FORMAT "x(200)":U SKIP.
    FOR EACH bktt-af-historico-alteracao NO-LOCK
        BY bktt-af-historico-alteracao.dt-alter
        BY bktt-af-historico-alteracao.hora-alter:
        PUT    bktt-af-historico-alteracao.Seq FORMAT ">>>>>>>>9":U ";":U
               bktt-af-historico-alteracao.chave FORMAT "x(80)":U ";":U   
               bktt-af-historico-alteracao.nome-tabela FORMAT "x(50)":U ";":U
               fn-retorna-descricao("tabela":U,bktt-af-historico-alteracao.nome-tabela, "") FORMAT "x(50)":U ";":U
               bktt-af-historico-alteracao.campo FORMAT "x(50)":U ";":U 
               fn-retorna-descricao("campo":U,bktt-af-historico-alteracao.nome-tabela, bktt-af-historico-alteracao.campo) FORMAT "x(50)":U ";":U
               replace(bktt-af-historico-alteracao.vl-anterior,CHR(10)," ":U) FORMAT "x(2000)":U ";":U 
               replace(bktt-af-historico-alteracao.vl-novo,CHR(10)," ":U) FORMAT "x(2000)":U ";":U
               bktt-af-historico-alteracao.usuar-alter FORMAT "x(12)":U ";":U 
               bktt-af-historico-alteracao.dt-alter FORMAT "99/99/99":U ";":U
               bktt-af-historico-alteracao.hora-alter FORMAT "x(8)":U ";":U 
               bktt-af-historico-alteracao.prog-alter FORMAT "x(30)":U ";":U
               bktt-af-historico-alteracao.ep-codigo FORMAT "x(3)":U SKIP.
    END.       
OUTPUT CLOSE.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exporta-por-usuario wWindow 
PROCEDURE pi-exporta-por-usuario :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para exportar os dados por usu†rio
  Parameters:  c-cabecalho -> cabeáalho do arquivo
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-cabecalho AS CHARACTER   NO-UNDO.

OUTPUT TO VALUE (session:temp-directory + "af0602.csv":U) Convert Target "ISO8859-1":U.
    PUT c-cabecalho FORMAT "x(200)":U SKIP.
    FOR EACH bktt-af-historico-alteracao NO-LOCK
        BY bktt-af-historico-alteracao.usuar-alter:
        PUT    bktt-af-historico-alteracao.Seq FORMAT ">>>>>>>>9":U ";":U
               bktt-af-historico-alteracao.chave FORMAT "x(80)":U ";":U   
               bktt-af-historico-alteracao.nome-tabela FORMAT "x(50)":U ";":U
               fn-retorna-descricao("tabela":U,bktt-af-historico-alteracao.nome-tabela, "") FORMAT "x(50)":U ";":U
               bktt-af-historico-alteracao.campo FORMAT "x(50)":U ";":U 
               fn-retorna-descricao("campo":U,bktt-af-historico-alteracao.nome-tabela, bktt-af-historico-alteracao.campo) FORMAT "x(50)":U ";":U
               replace(bktt-af-historico-alteracao.vl-anterior,CHR(10)," ":U) FORMAT "x(2000)":U ";":U 
               replace(bktt-af-historico-alteracao.vl-novo,CHR(10)," ":U) FORMAT "x(2000)":U ";":U
               bktt-af-historico-alteracao.usuar-alter FORMAT "x(12)":U ";":U 
               bktt-af-historico-alteracao.dt-alter FORMAT "99/99/99":U ";":U
               bktt-af-historico-alteracao.hora-alter FORMAT "x(8)":U ";":U 
               bktt-af-historico-alteracao.prog-alter FORMAT "x(30)":U ";":U
               bktt-af-historico-alteracao.ep-codigo FORMAT "x(3)":U SKIP.
    END.       
OUTPUT CLOSE.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-compenentes wWindow 
PROCEDURE pi-habilita-compenentes :
/*------------------------------------------------------------------------------
  Purpose:     Habilita os componentes da tela
  Parameters:  pHabilita -> Para habilitar ou n∆o os componentes
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pHabilita AS LOGICAL NO-UNDO.

IF pHabilita THEN
    ENABLE btn-filtro
           btn-Clear
            cb-tabelas
            cb-campos
        WITH FRAME fpage0.
ELSE
    DISABLE btn-filtro
            btn-Clear
            cb-tabelas
            cb-campos
        WITH FRAME fpage0.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-retorna-descricao wWindow 
FUNCTION fn-retorna-descricao RETURNS CHARACTER
  (INPUT c-tipo AS CHAR, INPUT c-tabela AS CHAR, INPUT c-campo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Retornar a descriá∆o das tabelas ou do dos campos de uma tabela espec°fica
    Notes:  c-tipo - Se Ç tabela ou n∆o
            c-tabela - Nome da tabela para buscar a descriá∆o
            c-campo - Nome do campo para buscar a descriá∆o
------------------------------------------------------------------------------*/
IF c-tipo = 'tabela':U THEN DO:    
    run utp/ut-table.p (INPUT "emsdca", INPUT c-tabela, INPUT 01).
    RETURN RETURN-VALUE.
END.
ELSE DO:
    /*Retira a posiá∆o do Index, sen∆o n∆o encontra a descriá∆o.*/
    IF INDEX(TRIM(c-campo),'[') > 0 THEN
        ASSIGN c-campo =  SUBSTR(TRIM(c-campo),1,(INDEX(TRIM(c-campo),'[') - 1)).
    /*As includes n∆o funcionam, ent∆o temos que fazer o c¢digo na m∆o.*/    
    FIND first dictdb._file NO-LOCK
        WHERE dictdb._file._file-name = c-tabela NO-ERROR.
    IF  NOT AVAIL dictdb._file THEN
        RETURN "ERRO: Tabela " + c-tabela + " n∆o encontrada".         

    FIND dictdb._field NO-LOCK
        WHERE dictdb._field._file-recid = RECID(dictdb._file)
        AND   dictdb._field._field-name = c-campo NO-ERROR.
    IF  NOT AVAIL dictdb._field THEN
        RETURN "ERRO: Campo " + c-campo + " n∆o encontrado".
    ELSE DO:
        IF _field._label = ? THEN
            RETURN c-campo.
        ELSE
            RETURN _field._label.
    END.
END.

RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-traduz-valor wWindow 
FUNCTION fn-traduz-valor RETURNS CHARACTER
  (INPUT c-valor AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Traduzir os campos l¢gicos
    Notes:  
------------------------------------------------------------------------------*/
  CASE c-valor:
      WHEN "yes":U THEN
          RETURN "Sim".
      WHEN "no":U THEN
          RETURN "N∆o".
      OTHERWISE
          RETURN c-valor.
  END CASE.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

