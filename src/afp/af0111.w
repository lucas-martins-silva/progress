&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttaf-grp-avaliacao NO-UNDO LIKE af-grp-avaliacao
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttAf-grp-avaliacao-form NO-UNDO LIKE Af-grp-avaliacao-form
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttaf-item-contr-estab NO-UNDO LIKE af-item-contr-estab
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
************************************************a*******************************/
{include/i-prgvrs.i AF0111 2.00.00.010 } /*** "010010" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i af0111 AFP}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AF0111
&GLOBAL-DEFINE Version        2.00.00.010

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Principal,F¢rmula,Item,Narrativa

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            YES
&GLOBAL-DEFINE Copy           YES
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         YES
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        ttAf-grp-avaliacao
&GLOBAL-DEFINE hDBOTable      hDBboaf017
&GLOBAL-DEFINE DBOTable       Af-grp-avaliacao

&GLOBAL-DEFINE page0KeyFields ttAf-grp-avaliacao.cod-grp-avaliacao ttAf-grp-avaliacao.nr-versao
&GLOBAL-DEFINE page0Fields    ttAf-grp-avaliacao.des-grp-avaliacao 
&GLOBAL-DEFINE page1Fields    ttAf-grp-avaliacao.qualidade ttAf-grp-avaliacao.ativo ~
                              ttAf-grp-avaliacao.demerito ~
                              ttAf-grp-avaliacao.quantidade ~
                              ttAf-grp-avaliacao.preco ~
                              ttAf-grp-avaliacao.data-entrega ~
                              ttAf-grp-avaliacao.nr-dia-min ~
                              ttAf-grp-avaliacao.nr-dia-max ~
                              ttAf-grp-avaliacao.dt-implantacao ~
                              ttAf-grp-avaliacao.dt-alter ~
                              ttAf-grp-avaliacao.usuar-alter ~
                              ttAf-grp-avaliacao.hora-alter ~
                              ttAf-grp-avaliacao.log-considera-qtd-receb ~
                              ttAf-grp-avaliacao.pct-qtd-min ~
                              ttAf-grp-avaliacao.pct-qtd-max ~
                              ttAf-grp-avaliacao.log-considera-val-receb ~
                              ttAf-grp-avaliacao.pct-val-min ~
                              ttAf-grp-avaliacao.pct-val-max 
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page3Fields
&GLOBAL-DEFINE page4Fields    ttAf-grp-avaliacao.narrativa

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{utp/ut-glob.i}
DEFINE VARIABLE cDescEstab LIKE estabelec.nome     NO-UNDO.
DEFINE VARIABLE cDescItem  LIKE item.desc-item     NO-UNDO.
DEFINE VARIABLE cNomeEmite LIKE emitente.nome-emit NO-UNDO.
DEFINE VARIABLE iPerc      LIKE Af-grp-avaliacao-form.percentual NO-UNDO.

DEFINE VARIABLE c-desc          AS CHARACTER FORMAT "x(30)" NO-UNDO.
DEFINE VARIABLE c-desc-emitente AS CHARACTER FORMAT "x(30)" NO-UNDO.
DEFINE VARIABLE c-desc-item     AS CHARACTER FORMAT "x(30)" NO-UNDO.
DEFINE VARIABLE c-periodicidade AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE c-acao          AS CHARACTER                NO-UNDO.

DEFINE VARIABLE iSeq       AS INTEGER    NO-UNDO.
DEFINE VARIABLE iRetorno   AS INTEGER    NO-UNDO.

/*--- Vari†veis definidas para que se possa utilizar o zoom 
      feito em Smart Objects ---*/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.
/*-----------------------------------------------------------------*/


/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf001    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf006    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf007    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf018    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf022    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf023    AS HANDLE NO-UNDO.

DEFINE VARIABLE pCodGrpAvaliacao LIKE af-grp-avaliacao.cod-grp-avaliacao NO-UNDO.
DEFINE VARIABLE pCodEstabIni     LIKE af-item-contr-estab.cod-estabel  INITIAL "" NO-UNDO.
DEFINE VARIABLE pCodEstabFim     LIKE af-item-contr-estab.cod-estabel  INITIAL "ZZZZZ" NO-UNDO. 
DEFINE VARIABLE pCodItemIni      LIKE af-item-contr-estab.it-codigo    INITIAL "" NO-UNDO.
DEFINE VARIABLE pCodItemFim      LIKE af-item-contr-estab.it-codigo    INITIAL "ZZZZZZZZZZZZZZZZ" NO-UNDO. 
DEFINE VARIABLE pCodFornecIni    LIKE af-item-contr-estab.cod-emitente INITIAL 0 NO-UNDO.
DEFINE VARIABLE pCodFornecFim    LIKE af-item-contr-estab.cod-emitente INITIAL 999999999 NO-UNDO.
DEFINE VARIABLE pNrVersao        LIKE af-grp-avaliacao.nr-versao    NO-UNDO.
DEFINE VARIABLE l-usa-log        AS LOGICAL     NO-UNDO.

DEFINE VARIABLE c-cod-grp-resp LIKE af-controle.cod-grp-resp NO-UNDO.

DEF TEMP-TABLE ttAf-Item-Contr-Estab-Aux NO-UNDO LIKE ttAf-Item-Contr-Estab.

{afbo/boaf006.i bttAf-item-contr-estab}
{afbo/boaf018.i bttAf-grp-avaliacao-form}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brSon2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttAf-grp-avaliacao-form ~
ttAf-item-contr-estab

/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 ttAf-grp-avaliacao-form.seq ~
ttAf-grp-avaliacao-form.nr-controle ~
fn-desc(ttAf-grp-avaliacao-form.nr-controle) @ c-desc ~
ttAf-grp-avaliacao-form.percentual ttAf-grp-avaliacao-form.cod-grp-resp ~
ttAf-grp-avaliacao-form.log-per-variavel ~
fn_periodicidade() @ c-periodicidade ttAf-grp-avaliacao-form.dt-implantacao ~
ttAf-grp-avaliacao-form.dt-alter ttAf-grp-avaliacao-form.hora-alter ~
ttAf-grp-avaliacao-form.usuar-alter ttAf-grp-avaliacao-form.narrativa 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH ttAf-grp-avaliacao-form NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH ttAf-grp-avaliacao-form NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSon2 ttAf-grp-avaliacao-form
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 ttAf-grp-avaliacao-form


/* Definitions for BROWSE brSon3                                        */
&Scoped-define FIELDS-IN-QUERY-brSon3 ttAf-item-contr-estab.cod-estabel ~
ttAf-item-contr-estab.cod-emitente ~
fn-desc-fornec(ttAf-item-contr-estab.cod-emitente) @ c-desc-emitente ~
ttAf-item-contr-estab.nr-versao ttAf-item-contr-estab.it-codigo ~
fn-desc-item(ttAf-item-contr-estab.it-codigo) @ c-desc-item 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon3 
&Scoped-define QUERY-STRING-brSon3 FOR EACH ttAf-item-contr-estab NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brSon3 OPEN QUERY brSon3 FOR EACH ttAf-item-contr-estab NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSon3 ttAf-item-contr-estab
&Scoped-define FIRST-TABLE-IN-QUERY-brSon3 ttAf-item-contr-estab


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brSon3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttaf-grp-avaliacao.cod-grp-avaliacao ~
ttaf-grp-avaliacao.des-grp-avaliacao ttaf-grp-avaliacao.nr-versao 
&Scoped-define ENABLED-TABLES ttaf-grp-avaliacao
&Scoped-define FIRST-ENABLED-TABLE ttaf-grp-avaliacao
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave btImporta btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS ttaf-grp-avaliacao.cod-grp-avaliacao ~
ttaf-grp-avaliacao.des-grp-avaliacao ttaf-grp-avaliacao.nr-versao 
&Scoped-define DISPLAYED-TABLES ttaf-grp-avaliacao
&Scoped-define FIRST-DISPLAYED-TABLE ttaf-grp-avaliacao
&Scoped-Define DISPLAYED-OBJECTS desc-versao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc wMaintenance 
FUNCTION fn-desc RETURNS CHARACTER
  (i-controle AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-fornec wMaintenance 
FUNCTION fn-desc-fornec RETURNS CHARACTER
  ( i-codemitente AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-item wMaintenance 
FUNCTION fn-desc-item RETURNS CHARACTER
  ( c-item AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn_periodicidade wMaintenance 
FUNCTION fn_periodicidade RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miUndo         LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
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
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image/im-add":U
     IMAGE-INSENSITIVE FILE "image/ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image/im-can":U
     IMAGE-INSENSITIVE FILE "image/im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image/im-copy":U
     IMAGE-INSENSITIVE FILE "image/ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image/im-era":U
     IMAGE-INSENSITIVE FILE "image/ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image/im-fir":U
     IMAGE-INSENSITIVE FILE "image/ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image/im-enter":U
     IMAGE-INSENSITIVE FILE "image/ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btImporta 
     IMAGE-UP FILE "image/im-grava.bmp":U
     LABEL "Button 2" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image/im-las":U
     IMAGE-INSENSITIVE FILE "image/ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image/im-nex":U
     IMAGE-INSENSITIVE FILE "image/ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image/im-pre":U
     IMAGE-INSENSITIVE FILE "image/ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

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

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image/im-sav":U
     IMAGE-INSENSITIVE FILE "image/ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUndo 
     IMAGE-UP FILE "image/im-undo":U
     IMAGE-INSENSITIVE FILE "image/ii-undo":U
     LABEL "Undo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image/im-mod":U
     IMAGE-INSENSITIVE FILE "image/ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE desc-versao AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-42
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 2.75.

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 3.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 4.25.

DEFINE BUTTON btAddSon-2 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon-2 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon-2 
     LABEL "Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btAddSon 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btFiltro 
     LABEL "Filtro" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon2 FOR 
      ttAf-grp-avaliacao-form SCROLLING.

DEFINE QUERY brSon3 FOR 
      ttAf-item-contr-estab SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMaintenance _STRUCTURED
  QUERY brSon2 NO-LOCK DISPLAY
      ttAf-grp-avaliacao-form.seq FORMAT ">>>>9":U
      ttAf-grp-avaliacao-form.nr-controle FORMAT ">>>>>9":U WIDTH 12
      fn-desc(ttAf-grp-avaliacao-form.nr-controle) @ c-desc COLUMN-LABEL "Descriá∆o" FORMAT "x(30)":U
            WIDTH 30
      ttAf-grp-avaliacao-form.percentual FORMAT ">>9.99":U
      ttAf-grp-avaliacao-form.cod-grp-resp FORMAT "X(8)":U
      ttAf-grp-avaliacao-form.log-per-variavel FORMAT "Sim/N∆o":U
      fn_periodicidade() @ c-periodicidade COLUMN-LABEL "Periodicidade"
      ttAf-grp-avaliacao-form.dt-implantacao FORMAT "99/99/9999":U
      ttAf-grp-avaliacao-form.dt-alter FORMAT "99/99/9999":U
      ttAf-grp-avaliacao-form.hora-alter FORMAT "X(8)":U
      ttAf-grp-avaliacao-form.usuar-alter FORMAT "X(12)":U
      ttAf-grp-avaliacao-form.narrativa FORMAT "x(100)":U WIDTH 100
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.25
         FONT 2.

DEFINE BROWSE brSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon3 wMaintenance _STRUCTURED
  QUERY brSon3 NO-LOCK DISPLAY
      ttAf-item-contr-estab.cod-estabel COLUMN-LABEL "Estabelec" FORMAT "X(5)":U
            WIDTH 10
      ttAf-item-contr-estab.cod-emitente COLUMN-LABEL "Fornecedor" FORMAT ">>>>>>>>9":U
            WIDTH 10
      fn-desc-fornec(ttAf-item-contr-estab.cod-emitente) @ c-desc-emitente COLUMN-LABEL "Nome Fornecedor" FORMAT "x(30)":U
            WIDTH 24.29
      ttAf-item-contr-estab.nr-versao FORMAT ">>>>9":U WIDTH 6.43
      ttAf-item-contr-estab.it-codigo FORMAT "x(16)":U
      fn-desc-item(ttAf-item-contr-estab.it-codigo) @ c-desc-item COLUMN-LABEL "Descriá∆o" FORMAT "x(30)":U
            WIDTH 25
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.5
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 21.43 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrància"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrància corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrància corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz alteraá‰es"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela alteraá‰es"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma alteraá‰es"
     btImporta AT ROW 1.13 COL 64
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     ttaf-grp-avaliacao.cod-grp-avaliacao AT ROW 2.83 COL 17.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .88
     ttaf-grp-avaliacao.des-grp-avaliacao AT ROW 2.83 COL 31 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 51 BY .88
     ttaf-grp-avaliacao.nr-versao AT ROW 3.83 COL 17.43 COLON-ALIGNED
          LABEL "Vers∆o"
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .88
     desc-versao AT ROW 3.83 COL 31 COLON-ALIGNED NO-LABEL
     rtKeys AT ROW 2.5 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.67
         FONT 1.

DEFINE FRAME fPage4
     ttaf-grp-avaliacao.narrativa AT ROW 2 COL 10 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 69 BY 9
     "Narrativa:" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 2 COL 3
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.38
         SIZE 85.43 BY 11.75
         FONT 1.

DEFINE FRAME fPage3
     brSon3 AT ROW 1.75 COL 2
     btFiltro AT ROW 11.25 COL 74
     btAddSon AT ROW 11.29 COL 2
     btDeleteSon AT ROW 11.29 COL 12
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.38
         SIZE 85.43 BY 11.75
         FONT 1.

DEFINE FRAME fPage2
     brSon2 AT ROW 1.75 COL 2
     btAddSon-2 AT ROW 11 COL 2
     btUpdateSon-2 AT ROW 11 COL 12
     btDeleteSon-2 AT ROW 11 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.38
         SIZE 85.43 BY 11.75
         FONT 1.

DEFINE FRAME fPage1
     ttaf-grp-avaliacao.qualidade AT ROW 1.5 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 10.43 BY .71
     ttaf-grp-avaliacao.demerito AT ROW 1.5 COL 55 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     ttaf-grp-avaliacao.quantidade AT ROW 2.5 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 11.43 BY .71
     ttaf-grp-avaliacao.log-considera-qtd-receb AT ROW 2.5 COL 17
          VIEW-AS TOGGLE-BOX
          SIZE 28.57 BY .71
     ttaf-grp-avaliacao.pct-qtd-min AT ROW 2.5 COL 55 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     ttaf-grp-avaliacao.pct-qtd-max AT ROW 2.5 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     ttaf-grp-avaliacao.preco AT ROW 3.46 COL 4.86
          VIEW-AS TOGGLE-BOX
          SIZE 7.57 BY .71
     ttaf-grp-avaliacao.log-considera-val-receb AT ROW 3.5 COL 17
          VIEW-AS TOGGLE-BOX
          SIZE 29.72 BY .71
     ttaf-grp-avaliacao.pct-val-min AT ROW 3.5 COL 55 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     ttaf-grp-avaliacao.pct-val-max AT ROW 3.5 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     ttaf-grp-avaliacao.data-entrega AT ROW 4.5 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 12.57 BY .71
     ttaf-grp-avaliacao.nr-dia-min AT ROW 4.5 COL 55 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     ttaf-grp-avaliacao.nr-dia-max AT ROW 4.5 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     ttaf-grp-avaliacao.ativo AT ROW 6.75 COL 9
          VIEW-AS TOGGLE-BOX
          SIZE 13 BY .71
     ttaf-grp-avaliacao.dt-implantacao AT ROW 9.25 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     ttaf-grp-avaliacao.dt-alter AT ROW 9.25 COL 43.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     ttaf-grp-avaliacao.hora-alter AT ROW 10.25 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     ttaf-grp-avaliacao.usuar-alter AT ROW 10.25 COL 43.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     RECT-42 AT ROW 5.75 COL 2
     RECT-43 AT ROW 8.75 COL 2
     RECT-6 AT ROW 1.25 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.38
         SIZE 85.43 BY 11.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttaf-grp-avaliacao T "?" NO-UNDO emsdca af-grp-avaliacao
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttAf-grp-avaliacao-form T "?" NO-UNDO emsdca Af-grp-avaliacao-form
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttaf-item-contr-estab T "?" NO-UNDO emsdca af-item-contr-estab
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
         HEIGHT             = 17.67
         WIDTH              = 90
         MAX-HEIGHT         = 28.5
         MAX-WIDTH          = 182.43
         VIRTUAL-HEIGHT     = 28.5
         VIRTUAL-WIDTH      = 182.43
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN desc-versao IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ttaf-grp-avaliacao.nr-versao IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brSon3 1 fPage3 */
/* SETTINGS FOR FRAME fPage4
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.ttAf-grp-avaliacao-form"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.ttAf-grp-avaliacao-form.seq
     _FldNameList[2]   > Temp-Tables.ttAf-grp-avaliacao-form.nr-controle
"ttAf-grp-avaliacao-form.nr-controle" ? ? "integer" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fn-desc(ttAf-grp-avaliacao-form.nr-controle) @ c-desc" "Descriá∆o" "x(30)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.ttAf-grp-avaliacao-form.percentual
     _FldNameList[5]   = Temp-Tables.ttAf-grp-avaliacao-form.cod-grp-resp
     _FldNameList[6]   = Temp-Tables.ttAf-grp-avaliacao-form.log-per-variavel
     _FldNameList[7]   > "_<CALC>"
"fn_periodicidade() @ c-periodicidade" "Periodicidade" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = Temp-Tables.ttAf-grp-avaliacao-form.dt-implantacao
     _FldNameList[9]   = Temp-Tables.ttAf-grp-avaliacao-form.dt-alter
     _FldNameList[10]   = Temp-Tables.ttAf-grp-avaliacao-form.hora-alter
     _FldNameList[11]   = Temp-Tables.ttAf-grp-avaliacao-form.usuar-alter
     _FldNameList[12]   > Temp-Tables.ttAf-grp-avaliacao-form.narrativa
"ttAf-grp-avaliacao-form.narrativa" ? "x(100)" "character" ? ? ? ? ? ? no ? no no "100" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon3
/* Query rebuild information for BROWSE brSon3
     _TblList          = "Temp-Tables.ttAf-item-contr-estab"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.ttAf-item-contr-estab.cod-estabel
"ttAf-item-contr-estab.cod-estabel" "Estabelec" ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ttAf-item-contr-estab.cod-emitente
"ttAf-item-contr-estab.cod-emitente" "Fornecedor" ? "integer" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fn-desc-fornec(ttAf-item-contr-estab.cod-emitente) @ c-desc-emitente" "Nome Fornecedor" "x(30)" ? ? ? ? ? ? ? no ? no no "24.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttAf-item-contr-estab.nr-versao
"ttAf-item-contr-estab.nr-versao" ? ? "integer" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.ttAf-item-contr-estab.it-codigo
     _FldNameList[6]   > "_<CALC>"
"fn-desc-item(ttAf-item-contr-estab.it-codigo) @ c-desc-item" "Descriá∆o" "x(30)" ? ? ? ? ? ? ? no ? no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon3 */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
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


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:   
    RUN addRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btAddSon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon wMaintenance
ON CHOOSE OF btAddSon IN FRAME fPage3 /* Incluir */
DO:
   
    FOR EACH ttAf-Item-Contr-Estab-Aux:
        DELETE ttAf-Item-Contr-Estab-Aux.
    END.

  

    CREATE ttAf-Item-Contr-Estab-Aux.
    ASSIGN ttAf-Item-Contr-Estab-Aux.ep-codigo = ttAf-grp-avaliacao.ep-codigo.

    RUN afp/af0111b.w (INPUT-OUTPUT TABLE ttAf-Item-Contr-Estab-Aux,
                       INPUT THIS-PROCEDURE).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btAddSon-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon-2 wMaintenance
ON CHOOSE OF btAddSon-2 IN FRAME fPage2 /* Incluir */
DO:
    
    RUN afp/af0111a.w ( INPUT 1,
                        INPUT FRAME fPage0 ttAf-grp-avaliacao.cod-grp-avaliacao,
                        INPUT 0,
                        INPUT FRAME fPage0 ttAf-grp-avaliacao.nr-versao,
                        INPUT-OUTPUT TABLE ttAf-grp-avaliacao-form). 
   {&OPEN-QUERY-{&BROWSE-NAME}}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN cancelRecord IN THIS-PROCEDURE.
    DISABLE btAddSon-2
            btUpdateSon-2
            btDeleteSon-2 WITH FRAME fPage2.
    DISABLE btAddSon
            btDeleteSon WITH FRAME fPage3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fpage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:

    RUN copyRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btDeleteSon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon wMaintenance
ON CHOOSE OF btDeleteSon IN FRAME fPage3 /* Eliminar */
DO:
   
    IF AVAIL ttAf-item-contr-estab THEN DO:
        RUN piEliminaCodGrpAvaliacao IN h-boaf006 (INPUT ttAf-Item-Contr-Estab.cod-estabel,
                                                   INPUT ttAf-Item-Contr-Estab.it-codigo,
                                                   INPUT ttAf-Item-Contr-Estab.cod-emitente,
                                                   INPUT ttAf-grp-avaliacao.cod-grp-avaliacao,
                                                   INPUT ttAf-grp-avaliacao.nr-versao).
        DELETE ttAf-item-contr-estab.
        {&OPEN-QUERY-brSon3}
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDeleteSon-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon-2 wMaintenance
ON CHOOSE OF btDeleteSon-2 IN FRAME fPage2 /* Eliminar */
DO:
  IF ttAf-grp-avaliacao-form.nr-controle >= 1 AND ttAf-grp-avaliacao-form.nr-controle <= 4 THEN DO:
     /* Inicio -- Projeto Internacional */
     {utp/ut-liter.i "Ponto_de_Controle_dever_ser_eliminado_na_tela_principal" *}
     RUN utp/ut-msgs.p (INPUT "show",
                        INPUT  17567,
                        INPUT RETURN-VALUE + ".").
     RETURN.
  END. 
    
   IF AVAIL ttAf-grp-avaliacao-form THEN
      DELETE ttAf-grp-avaliacao-form.
   {&OPEN-QUERY-{&BROWSE-NAME}}    
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


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro wMaintenance
ON CHOOSE OF btFiltro IN FRAME fPage3 /* Filtro */
DO:
    
    RUN afp/af0111c.w ( INPUT pCodGrpAvaliacao,
                        INPUT-OUTPUT pCodEstabIni,  
                        INPUT-OUTPUT pCodEstabFim, 
                        INPUT-OUTPUT pCodItemIni,  
                        INPUT-OUTPUT pCodItemFim,  
                        INPUT-OUTPUT pCodFornecIni,
                        INPUT-OUTPUT pCodFornecFim).
   
    RUN setConstraintFiltroItem IN h-boaf006 (INPUT pCodGrpAvaliacao,
                                              INPUT pCodEstabIni,  
                                              INPUT pCodEstabFim,  
                                              INPUT pCodItemIni,   
                                              INPUT pCodItemFim,   
                                              INPUT pCodFornecIni, 
                                              INPUT pCodFornecFim,
                                              INPUT pNrVersao).

    RUN openQueryStatic IN h-boaf006 (INPUT "FiltroItem":U).
        
    RUN getBatchRecords IN h-boaf006 (INPUT ?,
                                      INPUT NO,
                                      INPUT 9999,
                                      OUTPUT iRetorno,
                                      OUTPUT TABLE ttAf-Item-Contr-Estab).

    {&OPEN-QUERY-brSon3}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fpage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btImporta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImporta wMaintenance
ON CHOOSE OF btImporta IN FRAME fpage0 /* Button 2 */
DO:
  
   RUN afp/af0111d.w (INPUT TABLE ttAf-item-contr-estab,
                      INPUT TABLE ttAf-Grp-Avaliacao,
                      INPUT TABLE ttAf-Grp-Avaliacao-Form,
                      INPUT FRAME fPage0 ttAf-grp-avaliacao.cod-grp-avaliacao,
                      INPUT FRAME fPage0 ttAf-grp-avaliacao.nr-versao).

   RUN afterDisplayFields IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fpage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:
    /* Como foi criado uma PI para o afterSaveFields, quando chega l† n∆o tem mais a vari†vel 'cAction' */
    ASSIGN c-acao = cAction.

    RUN saveRecord IN THIS-PROCEDURE.

    IF RETURN-VALUE <> "NOK":U THEN DO:
       DISABLE btAddSon-2
               btUpdateSon-2
               btDeleteSon-2 WITH FRAME fPage2.

       DISABLE btAddSon
               btDeleteSon WITH FRAME fPage3.

       IF  NOT VALID-HANDLE(h-boaf006)               OR
           h-boaf006:TYPE      <> "PROCEDURE":U      OR
           h-boaf006:FILE-NAME <> "afbo/boaf006.p":U THEN DO:
           RUN afbo/boaf006.p PERSISTENT SET h-boaf006.
       END.
       RUN pi-afterSaveFields.
    END.  

    RUN afterDisplayFields IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/ZoomReposition.i &ProgramZoom="afzoom~/z01af017.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fpage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    RUN undoRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    
    IF  l-usa-log THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 52824, INPUT "").
    END.

    RUN updateRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btUpdateSon-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon-2 wMaintenance
ON CHOOSE OF btUpdateSon-2 IN FRAME fPage2 /* Alterar */
DO:
   
   IF AVAIL ttAf-grp-avaliacao-form THEN DO:
     RUN afp/af0111a.w ( INPUT 2,
                         INPUT FRAME fPage0 ttAf-grp-avaliacao.cod-grp-avaliacao,
                         INPUT ttAf-grp-avaliacao-form.nr-controle,
                         INPUT FRAME fPage0 ttAf-grp-avaliacao.nr-versao,
                         INPUT-OUTPUT TABLE ttAf-grp-avaliacao-form).
     {&OPEN-QUERY-{&BROWSE-NAME}}
   END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME ttaf-grp-avaliacao.cod-grp-avaliacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-grp-avaliacao.cod-grp-avaliacao wMaintenance
ON LEAVE OF ttaf-grp-avaliacao.cod-grp-avaliacao IN FRAME fpage0 /* Grupo Avaliaá∆o */
DO:
  
    FOR EACH ttAf-grp-avaliacao-form:
         ASSIGN ttAf-grp-avaliacao-form.cod-grp-avaliacao = INPUT FRAME fPage0 ttAf-grp-avaliacao.cod-grp-avaliacao.         
     END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttaf-grp-avaliacao.data-entrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-grp-avaliacao.data-entrega wMaintenance
ON VALUE-CHANGED OF ttaf-grp-avaliacao.data-entrega IN FRAME fPage1 /* Data Entrega */
DO:
    IF ttAf-grp-avaliacao.data-entrega:CHECKED THEN DO:
       RUN piRetornaGrupoAvaliacao IN h-boaf001 (INPUT 4,
                                               OUTPUT c-cod-grp-resp).
       FIND ttAf-grp-avaliacao-form
           WHERE ttAf-grp-avaliacao-form.ep-codigo         = i-ep-codigo-usuario
           AND   ttAf-grp-avaliacao-form.cod-grp-avaliacao = INPUT FRAME fPage0 ttAf-grp-avaliacao.cod-grp-avaliacao
           AND   ttAf-grp-avaliacao-form.nr-versao         = INPUT FRAME fPage0 ttAf-grp-avaliacao.nr-versao
           AND   ttAf-grp-avaliacao-form.nr-controle       = 4
           NO-LOCK NO-ERROR.
       IF NOT AVAIL ttAf-grp-avaliacao-form THEN DO:
          FIND LAST ttAf-grp-avaliacao-form NO-LOCK NO-ERROR.
          IF AVAIL ttAf-grp-avaliacao-form THEN
             ASSIGN iSeq = ttAf-grp-avaliacao-form.seq + 10.
          ELSE 
             ASSIGN iSeq = 10.
          CREATE ttAf-grp-avaliacao-form.
          ASSIGN ttAf-grp-avaliacao-form.ep-codigo         = i-ep-codigo-usuario
                 ttAf-grp-avaliacao-form.cod-grp-avaliacao = INPUT FRAME fPage0 ttAf-grp-avaliacao.cod-grp-avaliacao
                 ttAf-grp-avaliacao-form.nr-versao         = INPUT FRAME fPage0 ttAf-grp-avaliacao.nr-versao
                 ttAf-grp-avaliacao-form.nr-controle       = 4
                 ttAf-grp-avaliacao-form.percentual        = 0
                 ttAf-grp-avaliacao-form.cod-grp-resp      = c-cod-grp-resp
                 ttAf-grp-avaliacao-form.seq               = iSeq 
                 ttAf-grp-avaliacao-form.narrativa         = "".
          {&OPEN-QUERY-{&BROWSE-NAME}}
       END.
    END.  
    ELSE DO:
       FIND ttAf-grp-avaliacao-form
           WHERE ttAf-grp-avaliacao-form.ep-codigo         = i-ep-codigo-usuario
           AND   ttAf-grp-avaliacao-form.cod-grp-avaliacao = INPUT FRAME fPage0 ttAf-grp-avaliacao.cod-grp-avaliacao
           AND   ttAf-grp-avaliacao-form.nr-versao         = INPUT FRAME fPage0 ttAf-grp-avaliacao.nr-versao
           AND   ttAf-grp-avaliacao-form.nr-controle       = 4
           NO-LOCK NO-ERROR.
       IF AVAIL ttAf-grp-avaliacao-form THEN DO:
          DELETE ttAf-grp-avaliacao-form.
          {&OPEN-QUERY-{&BROWSE-NAME}}
       END.
    END.  
    run piHabilitaCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttaf-grp-avaliacao.log-considera-qtd-receb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-grp-avaliacao.log-considera-qtd-receb wMaintenance
ON VALUE-CHANGED OF ttaf-grp-avaliacao.log-considera-qtd-receb IN FRAME fPage1 /* Considera variaá‰es qtd recebimento */
DO:
  run piHabilitaCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttaf-grp-avaliacao.log-considera-val-receb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-grp-avaliacao.log-considera-val-receb wMaintenance
ON VALUE-CHANGED OF ttaf-grp-avaliacao.log-considera-val-receb IN FRAME fPage1 /* Considera variaá‰es valor recebimento */
DO:
  run piHabilitaCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME ttaf-grp-avaliacao.nr-versao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-grp-avaliacao.nr-versao wMaintenance
ON F5 OF ttaf-grp-avaliacao.nr-versao IN FRAME fpage0 /* Vers∆o */
DO:
  {method/zoomfields.i &ProgramZoom="afzoom/z01af023.w"
                      &FieldZoom1="nr-versao"
                      &FieldScreen1="ttaf-grp-avaliacao.nr-versao"
                      &Frame1="fPage0"
                      &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-grp-avaliacao.nr-versao wMaintenance
ON LEAVE OF ttaf-grp-avaliacao.nr-versao IN FRAME fpage0 /* Vers∆o */
DO:
    {method/referenceFields.i
            &HandleDBOLeave="h-boaf023"
            &KeyValue1="ttaf-grp-avaliacao.nr-versao:screen-value in frame fpage0"
            &KeyValue2="v_cdn_empres_usuar"            
            &FieldName1="desc-versao"                        
            &FieldScreen1="desc-versao"
            &Frame1="fpage0"}
                
    FOR EACH ttAf-grp-avaliacao-form:
        ASSIGN ttAf-grp-avaliacao-form.nr-versao = INPUT FRAME fPage0 ttAf-grp-avaliacao.nr-versao.
    END.

    FOR EACH ttAf-Item-Contr-Estab-Aux :
        ASSIGN ttAf-Item-Contr-Estab-Aux.nr-versao = INPUT FRAME fPage0 ttAf-grp-avaliacao.nr-versao.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-grp-avaliacao.nr-versao wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttaf-grp-avaliacao.nr-versao IN FRAME fpage0 /* Vers∆o */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttaf-grp-avaliacao.preco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-grp-avaliacao.preco wMaintenance
ON VALUE-CHANGED OF ttaf-grp-avaliacao.preco IN FRAME fPage1 /* Preáo */
DO:
  IF ttAf-grp-avaliacao.preco:CHECKED THEN DO:
     RUN piRetornaGrupoAvaliacao IN h-boaf001 (INPUT 3,
                                               OUTPUT c-cod-grp-resp).

     FIND ttAf-grp-avaliacao-form
         WHERE ttAf-grp-avaliacao-form.ep-codigo         = i-ep-codigo-usuario
         AND   ttAf-grp-avaliacao-form.cod-grp-avaliacao = INPUT FRAME fPage0 ttAf-grp-avaliacao.cod-grp-avaliacao
         AND   ttAf-grp-avaliacao-form.nr-versao         = INPUT FRAME fPage0 ttAf-grp-avaliacao.nr-versao
         AND   ttAf-grp-avaliacao-form.nr-controle  = 3
         NO-LOCK NO-ERROR.
     IF NOT AVAIL ttAf-grp-avaliacao-form THEN DO:
        FIND LAST ttAf-grp-avaliacao-form NO-LOCK NO-ERROR.
        IF AVAIL ttAf-grp-avaliacao-form THEN
           ASSIGN iSeq = ttAf-grp-avaliacao-form.seq + 10.
        ELSE 
           ASSIGN iSeq = 10.
        CREATE ttAf-grp-avaliacao-form.
        ASSIGN ttAf-grp-avaliacao-form.ep-codigo         = i-ep-codigo-usuario
               ttAf-grp-avaliacao-form.cod-grp-avaliacao = INPUT FRAME fPage0 ttAf-grp-avaliacao.cod-grp-avaliacao
               ttAf-grp-avaliacao-form.nr-versao         = INPUT FRAME fPage0 ttAf-grp-avaliacao.nr-versao
               ttAf-grp-avaliacao-form.nr-controle       = 3
               ttAf-grp-avaliacao-form.percentual        = 0
               ttAf-grp-avaliacao-form.cod-grp-resp      = c-cod-grp-resp
               ttAf-grp-avaliacao-form.seq               = iSeq 
               ttAf-grp-avaliacao-form.narrativa         = "".
        {&OPEN-QUERY-{&BROWSE-NAME}}
     END.
  END.  
  ELSE DO:
     FIND ttAf-grp-avaliacao-form
         WHERE ttAf-grp-avaliacao-form.ep-codigo         = i-ep-codigo-usuario
         AND   ttAf-grp-avaliacao-form.cod-grp-avaliacao = INPUT FRAME fPage0 ttAf-grp-avaliacao.cod-grp-avaliacao
         AND   ttAf-grp-avaliacao-form.nr-versao         = INPUT FRAME fPage0 ttAf-grp-avaliacao.nr-versao
         AND   ttAf-grp-avaliacao-form.nr-controle       = 3
         NO-LOCK NO-ERROR.
     IF AVAIL ttAf-grp-avaliacao-form THEN DO:
        DELETE ttAf-grp-avaliacao-form.
        {&OPEN-QUERY-{&BROWSE-NAME}}
     END.
  END.   
  run piHabilitaCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttaf-grp-avaliacao.qualidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-grp-avaliacao.qualidade wMaintenance
ON VALUE-CHANGED OF ttaf-grp-avaliacao.qualidade IN FRAME fPage1 /* Qualidade */
DO:
  IF ttAf-grp-avaliacao.qualidade:CHECKED THEN DO:
     RUN piRetornaGrupoAvaliacao IN h-boaf001 (INPUT 1,
                                               OUTPUT c-cod-grp-resp).
     FIND ttAf-grp-avaliacao-form
         WHERE ttAf-grp-avaliacao-form.ep-codigo         = i-ep-codigo-usuario
         AND   ttAf-grp-avaliacao-form.cod-grp-avaliacao = INPUT FRAME fPage0 ttAf-grp-avaliacao.cod-grp-avaliacao
         AND   ttAf-grp-avaliacao-form.nr-controle       = 1
         AND   ttAf-grp-avaliacao-form.nr-versao         = INPUT FRAME fPage0 ttAf-grp-avaliacao.nr-versao
         NO-LOCK NO-ERROR.

     IF NOT AVAIL ttAf-grp-avaliacao-form THEN DO:
        
        FIND LAST ttAf-grp-avaliacao-form NO-LOCK NO-ERROR.
        IF AVAIL ttAf-grp-avaliacao-form THEN
           ASSIGN iSeq = ttAf-grp-avaliacao-form.seq + 10.
        ELSE 
           ASSIGN iSeq = 10.
        CREATE ttAf-grp-avaliacao-form.
        ASSIGN ttAf-grp-avaliacao-form.ep-codigo         = i-ep-codigo-usuario
               ttAf-grp-avaliacao-form.cod-grp-avaliacao = INPUT FRAME fPage0 ttAf-grp-avaliacao.cod-grp-avaliacao
               ttAf-grp-avaliacao-form.nr-versao         = INPUT FRAME fPage0 ttAf-grp-avaliacao.nr-versao
               ttAf-grp-avaliacao-form.nr-controle       = 1
               ttAf-grp-avaliacao-form.percentual        = 0
               ttAf-grp-avaliacao-form.cod-grp-resp      = c-cod-grp-resp
               ttAf-grp-avaliacao-form.seq               = iSeq 
               ttAf-grp-avaliacao-form.narrativa         = "".
        {&OPEN-QUERY-{&BROWSE-NAME}}
     END.
  END.
  ELSE DO:
      FIND ttAf-grp-avaliacao-form
          WHERE ttAf-grp-avaliacao-form.ep-codigo         = i-ep-codigo-usuario
          AND   ttAf-grp-avaliacao-form.cod-grp-avaliacao = INPUT FRAME fPage0 ttAf-grp-avaliacao.cod-grp-avaliacao
          AND   ttAf-grp-avaliacao-form.nr-versao         = INPUT FRAME fPage0 ttAf-grp-avaliacao.nr-versao
          AND   ttAf-grp-avaliacao-form.nr-controle  = 1
          NO-LOCK NO-ERROR.
      IF AVAIL ttAf-grp-avaliacao-form THEN DO:
         DELETE ttAf-grp-avaliacao-form.
      END.
  END.    
  run piHabilitaCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttaf-grp-avaliacao.quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttaf-grp-avaliacao.quantidade wMaintenance
ON VALUE-CHANGED OF ttaf-grp-avaliacao.quantidade IN FRAME fPage1 /* Quantidade */
DO:
  IF ttAf-grp-avaliacao.quantidade:CHECKED THEN DO:
     RUN piRetornaGrupoAvaliacao IN h-boaf001 (INPUT 2,
                                               OUTPUT c-cod-grp-resp).
     FIND ttAf-grp-avaliacao-form
         WHERE ttAf-grp-avaliacao-form.ep-codigo         = i-ep-codigo-usuario
         AND   ttAf-grp-avaliacao-form.cod-grp-avaliacao = INPUT FRAME fPage0 ttAf-grp-avaliacao.cod-grp-avaliacao
         AND   ttAf-grp-avaliacao-form.nr-versao         = INPUT FRAME fPage0 ttAf-grp-avaliacao.nr-versao
         AND   ttAf-grp-avaliacao-form.nr-controle       = 2
         NO-LOCK NO-ERROR.
     IF NOT AVAIL ttAf-grp-avaliacao-form THEN DO:
        FIND LAST ttAf-grp-avaliacao-form NO-LOCK NO-ERROR.
        IF AVAIL ttAf-grp-avaliacao-form THEN
           ASSIGN iSeq = ttAf-grp-avaliacao-form.seq + 10.
        ELSE 
           ASSIGN iSeq = 10.
        CREATE ttAf-grp-avaliacao-form.
        ASSIGN ttAf-grp-avaliacao-form.ep-codigo         = i-ep-codigo-usuario
               ttAf-grp-avaliacao-form.cod-grp-avaliacao = INPUT FRAME fPage0 ttAf-grp-avaliacao.cod-grp-avaliacao
               ttAf-grp-avaliacao-form.nr-versao         = INPUT FRAME fPage0 ttAf-grp-avaliacao.nr-versao
               ttAf-grp-avaliacao-form.nr-controle       = 2
               ttAf-grp-avaliacao-form.percentual        = 0
               ttAf-grp-avaliacao-form.cod-grp-resp      = c-cod-grp-resp
               ttAf-grp-avaliacao-form.seq               = iSeq 
               ttAf-grp-avaliacao-form.narrativa         = "".
        {&OPEN-QUERY-{&BROWSE-NAME}}
     END.
  END.
  ELSE DO:
     FIND ttAf-grp-avaliacao-form
         WHERE ttAf-grp-avaliacao-form.ep-codigo         = i-ep-codigo-usuario
         AND   ttAf-grp-avaliacao-form.cod-grp-avaliacao = INPUT FRAME fPage0 ttAf-grp-avaliacao.cod-grp-avaliacao
         AND   ttAf-grp-avaliacao-form.nr-versao         = INPUT FRAME fPage0 ttAf-grp-avaliacao.nr-versao
         AND   ttAf-grp-avaliacao-form.nr-controle  = 2
         NO-LOCK NO-ERROR.
     IF AVAIL ttAf-grp-avaliacao-form THEN DO:
        DELETE ttAf-grp-avaliacao-form.
        {&OPEN-QUERY-{&BROWSE-NAME}}
     END.
  END.    
  run piHabilitaCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brSon2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/MainBlock.i}

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
    
    IF  VALID-HANDLE (h-boaf001) THEN DO:
        DELETE procedure h-boaf001.
        ASSIGN h-boaf001 = ?.
    END.                                                               

    IF  VALID-HANDLE (h-boaf018) THEN DO:
        DELETE procedure h-boaf018.
        ASSIGN h-boaf018 = ?.
    END.

    IF  VALID-HANDLE (h-boaf006) THEN DO:
        DELETE procedure h-boaf006.
        ASSIGN h-boaf006 = ?.
    END.

    IF  VALID-HANDLE (h-boaf007) THEN DO:
        DELETE procedure h-boaf007.
        ASSIGN h-boaf007 = ?.
    END.

    IF  VALID-HANDLE (h-boaf022) THEN DO:
        DELETE procedure h-boaf022.
        ASSIGN h-boaf022 = ?.
    END.

    IF  VALID-HANDLE (h-boaf023) THEN DO:
        DELETE procedure h-boaf023.
        ASSIGN h-boaf023 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-desc-versao AS CHARACTER   NO-UNDO. 

    IF  AVAIL ttAf-grp-avaliacao THEN DO:
                        
        ASSIGN pCodGrpAvaliacao = ttaf-grp-avaliacao.cod-grp-avaliacao
               pNrVersao        = ttaf-grp-avaliacao.nr-versao.

        RUN setConstraintForm     IN h-boaf018 (INPUT ttAf-grp-avaliacao.cod-grp-avaliacao, INPUT ttAf-grp-avaliacao.nr-versao).
        RUN pi-retorna-temp-table IN h-boaf018 (OUTPUT TABLE ttAf-grp-avaliacao-form).
        
        {&OPEN-QUERY-{&BROWSE-NAME}}

        FOR EACH ttAf-Item-Contr-Estab:
            DELETE ttAf-Item-Contr-Estab.
        END.        

        IF INPUT FRAME fPage0 ttaf-grp-avaliacao.cod-grp-avaliacao <> "" THEN DO:            
            RUN setConstraintCodGrpAvaliacao IN h-boaf006 (INPUT ttaf-grp-avaliacao.cod-grp-avaliacao, INPUT ttaf-grp-avaliacao.nr-versao).
            RUN openQueryStatic IN h-boaf006 (INPUT "CodGrpAvaliacao":U).
            RUN getBatchRecords IN h-boaf006 (INPUT ?,
                                              INPUT NO,
                                              INPUT 9999,
                                              OUTPUT iRetorno,
                                              OUTPUT TABLE ttAf-Item-Contr-Estab).

            {&OPEN-QUERY-brSon3}
        END.
        {&OPEN-QUERY-brSon3}

        APPLY "LEAVE":U TO ttaf-grp-avaliacao.nr-versao IN FRAME fpage0.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenance 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ENABLE btAddSon-2
           btUpdateSon-2
           btDeleteSon-2 WITH FRAME fPage2.
    ENABLE btAddSon
           btDeleteSon
           btFiltro WITH FRAME fPage3.
    DISABLE ttAf-grp-avaliacao.dt-implantacao
            ttAf-grp-avaliacao.dt-alter
            ttAf-grp-avaliacao.hora-alter
            ttAf-grp-avaliacao.usuar-alter
            WITH FRAME fPage1.

    RUN piHabilitaCampos IN THIS-PROCEDURE.    

    RETURN "OK":U.

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
ENABLE btImporta WITH FRAME fPage0.
ENABLE brSon2 WITH FRAME fPage2.
ENABLE brSon3 WITH FRAME fPage3.
ENABLE btFiltro WITH FRAME fPage3.


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenance 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF AVAIL ttAf-grp-avaliacao THEN 
       ASSIGN ttAf-grp-avaliacao.ep-codigo = i-ep-codigo-usuario.
    RUN piRecebeFormula IN {&hDBOTable} (INPUT TABLE ttAf-grp-avaliacao-form).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
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
         SIZE 46 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE iCodGrpAvaliado  LIKE {&ttTable}.cod-grp-avaliacao  NO-UNDO.
    DEFINE VARIABLE iNrGrpVersao  LIKE {&ttTable}.nr-versao  NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        iCodGrpAvaliado   AT ROW 1.21 COL 17.72 COLON-ALIGNED
        iNrGrpVersao      AT ROW 2.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Grupo de Avaliaá∆o" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
    
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN iCodGrpAvaliado
               iNrGrpVersao.
        
        RUN goToKey IN {&hDBOTable} (INPUT i-ep-codigo-usuario, INPUT iCodGrpAvaliado, INPUT iNrGrpVersao ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Grupo_de_Avaliaá∆o" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE iCodGrpAvaliado btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord.    

    IF NOT l-usa-log THEN DO:    
        DISABLE iNrGrpVersao
            WITH FRAME fGoToRecord.        
        ASSIGN iNrGrpVersao:SCREEN-VALUE IN FRAME fGoToRecord = "0".
    END.
    ELSE
        ENABLE iNrGrpVersao
            WITH FRAME fGoToRecord.

    ASSIGN iCodGrpAvaliado:WIDTH   = 9
           iCodGrpAvaliado:HEIGHT  = .88
           iNrGrpVersao:WIDTH      = 9
           iNrGrpVersao:HEIGHT     = .88.

    WAIT-FOR "GO":U OF FRAME fGoToRecord.
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
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "afbo/boaf017.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf017.p YES}
        {btb/btb008za.i2 afbo/boaf017.p '' {&hDBOTable}}
    END.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    IF NOT VALID-HANDLE(h-boaf001) OR
       h-boaf001:TYPE <> "PROCEDURE":U OR
       h-boaf001:FILE-NAME <> "afbo/boaf001.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf001.p YES}
        {btb/btb008za.i2 afbo/boaf001.p '' h-boaf001}
    END.
    RUN openQueryStatic IN h-boaf001 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-boaf018) OR
       h-boaf018:TYPE <> "PROCEDURE":U OR
       h-boaf018:FILE-NAME <> "afbo/boaf018.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf018.p YES}
        {btb/btb008za.i2 afbo/boaf018.p '' h-boaf018}
    END.
    RUN openQueryStatic IN h-boaf018 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-boaf006) OR
       h-boaf006:TYPE <> "PROCEDURE":U OR
       h-boaf006:FILE-NAME <> "afbo/boaf006.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf006.p YES}
        {btb/btb008za.i2 afbo/boaf006.p '' h-boaf006}
    END.
    RUN openQueryStatic IN h-boaf006 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-boaf007) OR
       h-boaf007:TYPE <> "PROCEDURE":U OR
       h-boaf007:FILE-NAME <> "afbo/boaf007.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf007.p YES}
        {btb/btb008za.i2 afbo/boaf007.p '' h-boaf007}
    END.
    RUN openQueryStatic IN h-boaf007 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-boaf022) OR
       h-boaf022:TYPE <> "PROCEDURE":U OR
       h-boaf022:FILE-NAME <> "afbo/boaf022.p":U THEN DO:
       RUN afbo/boaf022.p persistent set  h-boaf022.
    END.

    RUN openQueryStatic IN h-boaf022 (INPUT "Main":U) NO-ERROR.

    RUN getLogField IN h-boaf022 ("log-usa-versao":U, OUTPUT l-usa-log).

    IF NOT VALID-HANDLE(h-boaf023) OR
       h-boaf023:TYPE <> "PROCEDURE":U OR
       h-boaf023:FILE-NAME <> "afbo/boaf023.p":U THEN DO:
       RUN afbo/boaf023.p persistent set  h-boaf023.
    END.
    
    RUN openQueryStatic IN h-boaf023 (INPUT "Main":U) NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-afterSaveFields wMaintenance 
PROCEDURE pi-afterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  c-acao = "COPY":U AND
        CAN-FIND(FIRST ttAf-item-contr-estab
                 WHERE ttAf-item-contr-estab.ativo) THEN DO:
        {utp/ut-liter.i "apenas_os_relacionamentos_(Item_x_Estab_x_Fornec)_ATIVOS_do_Grupo_de_origem" *}
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17475,
                           INPUT RETURN-VALUE).

        /* Se deseja copiar apenas os fornecedores ativos, ent∆o deve eliminar os inativos */
        IF  RETURN-VALUE = "YES":U THEN DO:
            FOR EACH  ttAf-item-contr-estab
                WHERE ttAf-item-contr-estab.ativo = NO:
                DELETE ttAf-item-contr-estab.
            END.
        END.
    END.

   
    FOR EACH ttAf-Item-Contr-Estab NO-LOCK:
        RUN piGravaCodGrpAvaliacao IN h-boaf006 (INPUT ttAf-Item-Contr-Estab.cod-estabel,
                                                 INPUT ttAf-Item-Contr-Estab.it-codigo,
                                                 INPUT ttAf-Item-Contr-Estab.cod-emitente,
                                                 INPUT ttAf-Item-Contr-Estab.nr-versao, 
                                                 INPUT ttAf-grp-avaliacao.cod-grp-avaliacao,                                 
                                                 INPUT ttAf-grp-avaliacao.nr-versao).
    END.

    RUN afp/af0111d.w (INPUT TABLE ttAf-item-contr-estab,
                       INPUT TABLE ttAf-Grp-Avaliacao,
                       INPUT TABLE ttAf-Grp-Avaliacao-Form,
                       INPUT FRAME fPage0 ttAf-grp-avaliacao.cod-grp-avaliacao,
                       INPUT FRAME fPage0 ttAf-grp-avaliacao.nr-versao).

    FOR EACH ttAf-Item-Contr-Estab:
        DELETE ttAf-Item-Contr-Estab.
    END.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piHabilitaCampos wMaintenance 
PROCEDURE piHabilitaCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT l-usa-log THEN DO:
    DISABLE ttaf-grp-avaliacao.nr-versao WITH FRAME fPage0.
    ASSIGN  ttaf-grp-avaliacao.nr-versao:SCREEN-VALUE IN FRAME fPage0 = "0".
    APPLY 'LEAVE':U TO nr-versao IN FRAME fpage0.
END.
ELSE DO:
    IF caction = "ADD":U THEN DO:
        ASSIGN desc-versao:SCREEN-VALUE IN FRAME fpage0 = "".
        ttaf-grp-avaliacao.nr-versao:load-mouse-pointer("image/lupa.cur":U) in frame fPage0.
    END.        
END.


IF input frame fpage1 ttAf-grp-avaliacao.qualidade:CHECKED THEN 
   ENABLE ttAf-grp-avaliacao.demerito WITH FRAME fPage1.
ELSE 
   DISABLE ttAf-grp-avaliacao.demerito WITH FRAME fPage1.

IF input frame fpage1 ttAf-grp-avaliacao.data-entrega:CHECKED THEN 
  ENABLE ttAf-grp-avaliacao.nr-dia-min
         ttAf-grp-avaliacao.nr-dia-max
         WITH FRAME fPage1.
ELSE 
  DISABLE ttAf-grp-avaliacao.nr-dia-min
          ttAf-grp-avaliacao.nr-dia-max
          WITH FRAME fPage1.

IF input frame fpage1 ttAf-grp-avaliacao.quantidade:CHECKED THEN DO:
  ENABLE ttAf-grp-avaliacao.log-considera-qtd-receb
         WITH FRAME fPage1.
  IF input frame fpage1 ttAf-grp-avaliacao.log-considera-qtd-receb:CHECKED then
       DISABLE ttAf-grp-avaliacao.pct-qtd-min
               ttAf-grp-avaliacao.pct-qtd-max
               with frame fpage1.
  else
       ENABLE ttAf-grp-avaliacao.pct-qtd-min
              ttAf-grp-avaliacao.pct-qtd-max
              with frame fpage1.
end.
ELSE 
  DISABLE ttAf-grp-avaliacao.log-considera-qtd-receb
          ttAf-grp-avaliacao.pct-qtd-min
          ttAf-grp-avaliacao.pct-qtd-max
          WITH FRAME fPage1.

IF input frame fpage1 ttAf-grp-avaliacao.preco:CHECKED THEN DO:
  ENABLE ttAf-grp-avaliacao.log-considera-val-receb
         WITH FRAME fPage1.
  IF input frame fpage1 ttAf-grp-avaliacao.log-considera-val-receb:CHECKED then
       DISABLE ttAf-grp-avaliacao.pct-val-min
               ttAf-grp-avaliacao.pct-val-max
               with frame fpage1.
  else
       ENABLE ttAf-grp-avaliacao.pct-val-min
              ttAf-grp-avaliacao.pct-val-max
              with frame fpage1.
end.
ELSE 
  DISABLE ttAf-grp-avaliacao.log-considera-val-receb
          ttAf-grp-avaliacao.pct-val-min
          ttAf-grp-avaliacao.pct-val-max
          WITH FRAME fPage1.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSalva wMaintenance 
PROCEDURE piSalva :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR ttAf-Item-Contr-Estab-Aux.
    
    FIND FIRST ttAf-Item-Contr-Estab-Aux NO-LOCK NO-ERROR.     
    
    FIND FIRST ttAf-Item-Contr-Estab WHERE ttAf-Item-Contr-Estab.ep-codigo    = i-ep-codigo-usuario
                                     AND   ttAf-Item-Contr-Estab.cod-estabel  = ttAf-Item-Contr-Estab-Aux.cod-estabel
                                     AND   ttAf-Item-Contr-Estab.it-codigo    = ttAf-Item-Contr-Estab-Aux.it-codigo
                                     AND   ttAf-Item-Contr-Estab.cod-emitente = ttAf-Item-Contr-Estab-Aux.cod-emitente 
                                     AND   ttAf-Item-Contr-Estab.nr-versao   = ttAf-Item-Contr-Estab-Aux.nr-versao
                                     NO-LOCK NO-ERROR.
    IF NOT AVAIL ttAf-Item-Contr-Estab THEN DO:
        CREATE ttAf-Item-Contr-Estab.    
        ASSIGN ttAf-Item-Contr-Estab.ep-codigo         = i-ep-codigo-usuario
               ttAf-Item-Contr-Estab.cod-estabel       = ttAf-Item-Contr-Estab-Aux.cod-estabel
               ttAf-Item-Contr-Estab.it-codigo         = ttAf-Item-Contr-Estab-Aux.it-codigo
               ttAf-Item-Contr-Estab.nr-versao         = ttAf-Item-Contr-Estab-Aux.nr-versao
               ttAf-Item-Contr-Estab.cod-emitente      = ttAf-Item-Contr-Estab-Aux.cod-emitente
               ttAf-Item-Contr-Estab.cod-grp-avaliacao = ttAf-grp-avaliacao.cod-grp-avaliacao.
        {&OPEN-QUERY-brSon3}
    END.
        
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSaveRecord wMaintenance 
PROCEDURE piSaveRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcod-estabel  LIKE Af-Item-Contr-Estab.cod-estabel.
DEFINE INPUT PARAMETER pit-codigo    LIKE Af-Item-Contr-Estab.it-codigo.
DEFINE INPUT PARAMETER pcod-emitente LIKE Af-Item-Contr-Estab.cod-emitente.


IF RETURN-VALUE = "OK":U THEN DO:
    CREATE ttAf-Item-Contr-Estab.    
    ASSIGN ttAf-Item-Contr-Estab.cod-estabel  = pcod-estabel
           ttAf-Item-Contr-Estab.it-codigo    = pit-codigo
           ttAf-Item-Contr-Estab.cod-emitente = pcod-emitente.

    {&OPEN-QUERY-brSon3}
END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc wMaintenance 
FUNCTION fn-desc RETURNS CHARACTER
  (i-controle AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RUN gotokey      IN h-boaf001 (INPUT i-controle).
  IF RETURN-VALUE = "ok" THEN
     RUN getcharfield IN h-boaf001 (INPUT "descricao",
                                    OUTPUT c-desc).
  ELSE c-desc = "".

  RETURN c-desc.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-fornec wMaintenance 
FUNCTION fn-desc-fornec RETURNS CHARACTER
  ( i-codemitente AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  RUN getNomeEmitente in h-boaf006 ( INPUT i-codemitente,
                                 OUTPUT c-desc-emitente ).
  RETURN c-desc-emitente.  /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-item wMaintenance 
FUNCTION fn-desc-item RETURNS CHARACTER
  ( c-item AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RUN getDescItem in h-boaf006 ( INPUT c-item,
                                 OUTPUT c-desc-item ).
  RETURN c-desc-item.  /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn_periodicidade wMaintenance 
FUNCTION fn_periodicidade RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

   RETURN {afinc/i01af017.i 04 ttAf-grp-avaliacao-form.ind-tipo-periodo}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

