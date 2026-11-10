&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-processo-imp NO-UNDO LIKE processo-imp
       field r-rowid as rowid
       .


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0040 2.00.00.056 } /*** "010056" 14/11/2023 11:37:07  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im0040 MIM}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

{include/i_dbvers.i} /*Include de Pr‚-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar validação produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
&endif
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0040
&GLOBAL-DEFINE Version        2.00.00.056
&GLOBAL-DEFINE DBOVersion     1.1

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FramesHandle   STRING(FRAME fPage1:HANDLE) + ",":U + ~
                              STRING(FRAME fPage2:HANDLE) + ",":U + ~
                              STRING(FRAME fPage3:HANDLE) + ",":U + ~
                              STRING(FRAME fPage4:HANDLE)
&GLOBAL-DEFINE FolderLabels   Processo,Financ/Fiscal, Mensagem, Narrativa

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

&GLOBAL-DEFINE ttTable        tt-processo-imp
&GLOBAL-DEFINE hDBOTable      h-bocx140
&GLOBAL-DEFINE DBOTable       processo-imp

&GLOBAL-DEFINE page0KeyFields tt-processo-imp.cod-estabel ~
                              tt-processo-imp.nr-proc-imp 
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    tt-processo-imp.cod-exportador ~
                              tt-processo-imp.num-pedido ~
                              tt-processo-imp.cod-fabricante ~
                              tt-processo-imp.dt-emissao ~
                              tt-processo-imp.cod-despachante ~
                              tt-processo-imp.cod-itiner ~
                              tt-processo-imp.cod-transportador ~
                              tt-processo-imp.cod-agente ~
                              tt-processo-imp.cod-idioma ~
                              tt-processo-imp.cdn-corretor-cambio-import ~
                              tt-processo-imp.cdn-despa-exter-import ~
                              tt-processo-imp.cdn-segurad-import ~
                              tt-processo-imp.cdn-corretor-import ~
                              combo-box-1
&GLOBAL-DEFINE page2Fields    tt-processo-imp.cod-banco ~
                              tt-processo-imp.carta-credito ~
                              tt-processo-imp.nr-rof ~
                              tt-processo-imp.cod-consignatario ~
                              tt-processo-imp.regime-import ~
                              tt-processo-imp.estab-fisc ~
                              c-dest-doc ~
                              c-nome-banco
&GLOBAL-DEFINE page3Fields    tt-processo-imp.cod-mensagem ~
                              tt-processo-imp.texto-mensag
&GLOBAL-DEFINE page4Fields    tt-processo-imp.narrativa

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */

def var h-bocx140 as handle no-undo.
def var h-bocx115 as handle no-undo.
def var h-boad018 as handle no-undo. 
def var h-boad098 as handle no-undo.
def var h-boad107 as handle no-undo.
def var h-bocx155 as handle no-undo. 
def var h-boad176 as handle no-undo.
def var h-boad268 as handle no-undo.
def var h-boin295 as handle no-undo.
def var h-bofn167 as handle no-undo.

def var c-lista       as char no-undo.
def var c-return      as char no-undo.
def var c-return1     as integer                   no-undo.
def var r-rowid       as rowid                     no-undo.
def var l-entry       as logical initial no        no-undo.
def var c-idiom-usuar as char format "x(12)"       no-undo.
def var i-num-pedido   like pedido-compr.num-pedido no-undo.
def var c-des-itiner   like itinerario.descricao  no-undo.
def var c-estabelec    like estabelec.nome        no-undo.
def var c-transp       like transporte.nome-abrev no-undo.
def var c-des-idioma   like idioma.des_idioma     no-undo.
def var i-cod-emitente like emitente.cod-emitente no-undo.
def var c-texto-mensag-1 as char format "x(76)" no-undo.
def var c-texto-mensag-2 as char format "x(76)" no-undo.
def var c-texto-mensag-3 as char format "x(76)" no-undo.
def var c-texto-mensag-4 as char format "x(76)" no-undo.
def var c-texto-mensag-5 as char format "x(76)" no-undo.
def var c-erro       as char                    no-undo.

&IF '{&mgdis_version}' >= '2.06f' &THEN
    def var h-bofn017 as handle no-undo.
    {fnbo/bofn017.i tt_usuar_mestre}
&ELSE
    def var h-boun178 as handle no-undo.
    {unbo/boun178.i tt_usuar_mestre}
&ENDIF

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */

/* Programa de pesquisa */
def new global shared var adm-broker-hdl  as handle no-undo.
def new global shared var l-add-ccp       as logical   no-undo.
def new global shared var gr-pedido-compr as rowid   no-undo.
def new global shared var p-num-pedido    as integer  no-undo.
def                   var wh-pesquisa     as handle no-undo.

DEF VAR pr-rowid AS ROWID NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-processo-imp.cod-estabel ~
tt-processo-imp.nr-proc-imp 
&Scoped-define ENABLED-TABLES tt-processo-imp
&Scoped-define FIRST-ENABLED-TABLE tt-processo-imp
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-1 btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave BtRelaciona btQueryJoins btReportsJoins btExit btHelp c-nome-estab 
&Scoped-Define DISPLAYED-FIELDS tt-processo-imp.cod-estabel ~
tt-processo-imp.nr-proc-imp 
&Scoped-define DISPLAYED-TABLES tt-processo-imp
&Scoped-define FIRST-DISPLAYED-TABLE tt-processo-imp
&Scoped-Define DISPLAYED-OBJECTS c-nome-estab 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

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
       MENU-ITEM miUndo         LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
       RULE
       MENU-ITEM miRelaciona    LABEL "&LI's Relacionados" ACCELERATOR "CTRL-L"
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
     IMAGE-UP FILE "image~\im-add":U
     IMAGE-INSENSITIVE FILE "image~\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image~\im-can":U
     IMAGE-INSENSITIVE FILE "image~\im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image~\im-copy":U
     IMAGE-INSENSITIVE FILE "image~\ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image~\im-era":U
     IMAGE-INSENSITIVE FILE "image~\ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image~\im-exi":U
     IMAGE-INSENSITIVE FILE "image~\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image~\im-fir":U
     IMAGE-INSENSITIVE FILE "image~\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image~\im-enter":U
     IMAGE-INSENSITIVE FILE "image~\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image~\im-hel":U
     IMAGE-INSENSITIVE FILE "image~\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image~\im-las":U
     IMAGE-INSENSITIVE FILE "image~\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image~\im-nex":U
     IMAGE-INSENSITIVE FILE "image~\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image~\im-pre":U
     IMAGE-INSENSITIVE FILE "image~\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image~\im-joi":U
     IMAGE-INSENSITIVE FILE "image~\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON BtRelaciona 
     IMAGE-UP FILE "image/im-carga.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-carga.bmp":U
     LABEL "LI's Relacionados" 
     SIZE 4 BY 1.25 TOOLTIP "LI's Relacionados".

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image~\im-pri":U
     IMAGE-INSENSITIVE FILE "image~\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image~\im-sav":U
     IMAGE-INSENSITIVE FILE "image~\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUndo 
     IMAGE-UP FILE "image~\im-undo":U
     IMAGE-INSENSITIVE FILE "image~\ii-undo":U
     LABEL "Undo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image~\im-mod":U
     IMAGE-INSENSITIVE FILE "image~\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE c-nome-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 94.86 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 95 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Via Transp" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-idioma AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-itiner AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-ag AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-corret-seg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-corretor AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-desp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-desp-ext AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-exp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-fab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-segur AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-transp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-dest-doc AS CHARACTER FORMAT "X(40)":U 
     LABEL "Destino da Documenta‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 28 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-banco AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 24.29 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrˆncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrˆncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrˆncia"
     btLast AT ROW 1.13 COL 13.57 HELP
          "éltima ocorrˆncia"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V  Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrˆncia"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrˆncia corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrˆncia corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrˆncia corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz altera‡äes"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela altera‡äes"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma altera‡äes"
     BtRelaciona AT ROW 1.13 COL 74.29 HELP
          "LI's Relacionados"
     btQueryJoins AT ROW 1.13 COL 79.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 83.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 87.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 91.72 HELP
          "Ajuda"
     tt-processo-imp.cod-estabel AT ROW 2.75 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-nome-estab AT ROW 2.75 COL 39 COLON-ALIGNED NO-LABEL
     tt-processo-imp.nr-proc-imp AT ROW 3.75 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     rtToolBar AT ROW 1 COL 1
     RECT-1 AT ROW 2.5 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 95.43 BY 15.5
         FONT 1.

DEFINE FRAME fPage1
     tt-processo-imp.num-pedido AT ROW 1.25 COL 16.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-processo-imp.cod-exportador AT ROW 2.25 COL 16.14 COLON-ALIGNED
          LABEL "Exportador/Fornecedor":R21
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     c-nome-exp AT ROW 2.25 COL 26.14 COLON-ALIGNED NO-LABEL
     tt-processo-imp.dt-emissao AT ROW 3.25 COL 16.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-processo-imp.cod-fabricante AT ROW 4.25 COL 16.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     c-nome-fab AT ROW 4.25 COL 26.14 COLON-ALIGNED NO-LABEL
     tt-processo-imp.cod-despachante AT ROW 5.25 COL 16.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     c-nome-desp AT ROW 5.25 COL 26.14 COLON-ALIGNED NO-LABEL
     tt-processo-imp.cod-transportador AT ROW 6.25 COL 16.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     c-nome-transp AT ROW 6.25 COL 26.14 COLON-ALIGNED NO-LABEL
     COMBO-BOX-1 AT ROW 7.25 COL 16.14 COLON-ALIGNED
     tt-processo-imp.cod-agente AT ROW 8.25 COL 16.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     c-nome-ag AT ROW 8.25 COL 26.14 COLON-ALIGNED NO-LABEL
     tt-processo-imp.cod-itiner AT ROW 2.25 COL 56 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-itiner AT ROW 2.25 COL 62 COLON-ALIGNED NO-LABEL
     tt-processo-imp.cod-idioma AT ROW 3.25 COL 56 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-desc-idioma AT ROW 3.25 COL 65.72 COLON-ALIGNED NO-LABEL
     tt-processo-imp.cdn-corretor-cambio-import AT ROW 4.25 COL 56 COLON-ALIGNED
          LABEL "Corretor Cƒmbio":R31
          VIEW-AS FILL-IN 
          SIZE 9.86 BY .88
     c-nome-corretor AT ROW 4.25 COL 65.72 COLON-ALIGNED NO-LABEL
     tt-processo-imp.cdn-despa-exter-import AT ROW 5.25 COL 56 COLON-ALIGNED
          LABEL "Despachante Exterior":R31
          VIEW-AS FILL-IN 
          SIZE 9.86 BY .88
     c-nome-desp-ext AT ROW 5.25 COL 65.72 COLON-ALIGNED NO-LABEL
     tt-processo-imp.cdn-segurad-import AT ROW 6.25 COL 56 COLON-ALIGNED
          LABEL "Seguradora":R25
          VIEW-AS FILL-IN 
          SIZE 9.86 BY .88
     c-nome-segur AT ROW 6.25 COL 65.72 COLON-ALIGNED NO-LABEL
     tt-processo-imp.cdn-corretor-import AT ROW 7.25 COL 56 COLON-ALIGNED
          LABEL "Corretor de Seguro":R23
          VIEW-AS FILL-IN 
          SIZE 9.86 BY .88
     c-nome-corret-seg AT ROW 7.25 COL 65.72 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 6.38
         SIZE 93 BY 9.58
         FONT 1.

DEFINE FRAME fPage4
     tt-processo-imp.narrativa AT ROW 1.17 COL 18.57 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 51 BY 6.42
     "Narrativa:" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 1.21 COL 11.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 6.38
         SIZE 90 BY 9.58
         FONT 1.

DEFINE FRAME fPage3
     tt-processo-imp.cod-mensagem AT ROW 1.21 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-processo-imp.texto-mensag AT ROW 2.25 COL 18 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 62.43 BY 7.17
     "Mensagem:" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 2.21 COL 9.72
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 6.38
         SIZE 90 BY 9.58
         FONT 1.

DEFINE FRAME fPage2
     tt-processo-imp.cod-banco AT ROW 1.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-nome-banco AT ROW 1.17 COL 41.14 COLON-ALIGNED NO-LABEL
     tt-processo-imp.carta-credito AT ROW 2.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     c-dest-doc AT ROW 3.17 COL 35 COLON-ALIGNED
     tt-processo-imp.nr-rof AT ROW 4.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     tt-processo-imp.cod-consignatario AT ROW 5.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-processo-imp.regime-import AT ROW 6.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-processo-imp.estab-fisc AT ROW 7.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 6.38
         SIZE 90 BY 9.58
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
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
         HEIGHT             = 15.63
         WIDTH              = 95.43
         MAX-HEIGHT         = 20.17
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 20.17
         VIRTUAL-WIDTH      = 114.29
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
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* SETTINGS FOR FILL-IN tt-processo-imp.cdn-corretor-cambio-import IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-processo-imp.cdn-corretor-import IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-processo-imp.cdn-despa-exter-import IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-processo-imp.cdn-segurad-import IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-processo-imp.cod-exportador IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR FRAME fPage4
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Options          = "SHARE-LOCK KEEP-EMPTY"
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
    
    RUN imp/im0040c.w (input {&hDBOTable},
                       output i-num-pedido).
    if i-num-pedido <> 0 then do:
        run pi-carregarProcessopedido(input i-num-pedido).
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
     RUN cancelRecord IN THIS-PROCEDURE.
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

    DEFINE VARIABLE r-proc-imp      AS ROWID      NO-UNDO.

    IF  AVAIL tt-processo-imp THEN DO:
        ASSIGN r-proc-imp = tt-processo-imp.r-rowid.
        IF CAN-FIND(FIRST historico-proc-imp WHERE
                    historico-proc-imp.cod-estabel = tt-processo-imp.cod-estabel AND
                    historico-proc-imp.nr-proc-imp = tt-processo-imp.nr-proc-imp AND
                    historico-proc-imp.dt-efetiva <> ?                           AND
                    tt-processo-imp.situacao      <> 4 )                         THEN DO:

             {utp/ut-table.i mgcex historico-proc-imp 1}
             RUN utp/ut-msgs.p (input "Show":U,
                                input 32330,
                                input STRING(tt-processo-imp.nr-proc-imp) + "~~" + RETURN-VALUE).
         END.
         ELSE DO:
              RUN utp/ut-msgs.p (input "Show":U, input 550, input "").
         END.
         IF RETURN-VALUE = "yes":U THEN DO:
             RUN BloqueiaEliminacao IN {&hDBOTable} (INPUT RETURN-VALUE).
             RUN validateDelete     IN {&hDBOTable} (INPUT-OUTPUT r-proc-imp,
                                                     OUTPUT TABLE rowErrors).
             IF  CAN-FIND(FIRST rowErrors) THEN DO:
                 {method/showmessage.i1}
                 {method/showmessage.i2 &Modal="yes"}
             END.
             ELSE
                 RUN repositionRecord IN THIS-PROCEDURE (INPUT r-proc-imp).
         END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define SELF-NAME BtRelaciona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtRelaciona wMaintenance
ON CHOOSE OF BtRelaciona IN FRAME fpage0 /* LI's Relacionados */
OR CHOOSE OF MENU-ITEM miRelaciona IN MENU mbMain DO:

    define variable h-im0041 as handle no-undo.

    if  not valid-handle (h-im0041) then
        run imp/im0041.w persistent set h-im0041 (INPUT tt-processo-imp.r-rowid, ?, YES).
    
    run initializeInterface in h-im0041.

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
    &if "{&bf_mat_versao_ems}":U >= "2.05":U &then
        if  tt-processo-imp.cod-itiner <> input frame fPage1 tt-processo-imp.cod-itiner then do:
            run errosPli in h-bocx140 (input tt-processo-imp.num-pedido,
                                       output table rowErrors).
            if  can-find (first rowErrors) then do:
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal="YES"}
            end.
        end.
    &endif
    
    RUN ValidateItiner IN {&hDBOTable} (INPUT tt-processo-imp.cod-estabel,
                                        INPUT tt-processo-imp.nr-proc-imp,
                                        INPUT INPUT FRAME fPage1 tt-processo-imp.cod-itiner,
                                        OUTPUT TABLE RowErrors).
    IF  CAN-FIND(FIRST RowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
    END.
    
    IF  NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubtype = "ERROR":U) THEN
        RUN saveRecord IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="cxzoom/z01cx140.w"}
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
    RUN updateRecord IN THIS-PROCEDURE.
    disable tt-processo-imp.cod-estabel
            tt-processo-imp.nr-proc-imp
            with frame fPage0.
    disable tt-processo-imp.cod-exportador
            tt-processo-imp.num-pedido
            with frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-processo-imp.cdn-corretor-cambio-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cdn-corretor-cambio-import wMaintenance
ON F5 OF tt-processo-imp.cdn-corretor-cambio-import IN FRAME fPage1 /* Corretor Cƒmbio */
DO:
   {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="tt-processo-imp.cdn-corretor-cambio-import"
     &campozoom="cod-emitente"
     &frame="fPage1"
     &campo2="c-nome-corretor"
     &campozoom2="nome-abrev"
     &frame2="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cdn-corretor-cambio-import wMaintenance
ON LEAVE OF tt-processo-imp.cdn-corretor-cambio-import IN FRAME fPage1 /* Corretor Cƒmbio */
DO:
    if  avail tt-processo-imp 
    and input frame fPage1 tt-processo-imp.cdn-corretor-cambio-import <> 0 then do:
          {method/referencefields.i 
           &HandleDBOLeave="h-boad098"
           &FindMethod="findemitente"
           &KeyValue1="int(tt-processo-imp.cdn-corretor-cambio-import:SCREEN-VALUE IN FRAME fPage1)"
           &FieldName1="nome-abrev" 
           &FieldScreen1="c-nome-corretor"
           &Frame1="fPage1"}  
   end.    
   else
       assign c-nome-corretor:screen-value in frame fPage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cdn-corretor-cambio-import wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-processo-imp.cdn-corretor-cambio-import IN FRAME fPage1 /* Corretor Cƒmbio */
DO:
  apply 'f5':U to self in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-processo-imp.cdn-corretor-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cdn-corretor-import wMaintenance
ON F5 OF tt-processo-imp.cdn-corretor-import IN FRAME fPage1 /* Corretor de Seguro */
DO:
   {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="tt-processo-imp.cdn-corretor-import"
     &campozoom="cod-emitente"
     &frame="fPage1"
     &campo2="c-nome-corret-seg"
     &campozoom2="nome-abrev"
     &frame2="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cdn-corretor-import wMaintenance
ON LEAVE OF tt-processo-imp.cdn-corretor-import IN FRAME fPage1 /* Corretor de Seguro */
DO:
     if  avail tt-processo-imp 
     and input frame fPage1 tt-processo-imp.cdn-corretor-import <> 0 then do:
          {method/referencefields.i 
           &HandleDBOLeave="h-boad098"
           &FindMethod="findemitente"
           &KeyValue1="int(tt-processo-imp.cdn-corretor-import:SCREEN-VALUE IN FRAME fPage1)"
           &FieldName1="nome-abrev" 
           &FieldScreen1="c-nome-corret-seg"
           &Frame1="fPage1"}  
   end.    
   else
       assign c-nome-corret-seg:screen-value in frame fPage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cdn-corretor-import wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-processo-imp.cdn-corretor-import IN FRAME fPage1 /* Corretor de Seguro */
DO:
  apply 'f5':U to self in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-processo-imp.cdn-despa-exter-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cdn-despa-exter-import wMaintenance
ON F5 OF tt-processo-imp.cdn-despa-exter-import IN FRAME fPage1 /* Despachante Exterior */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="tt-processo-imp.cdn-despa-exter-import"
     &campozoom="cod-emitente"
     &frame="fPage1"
     &campo2="c-nome-desp-ext"
     &campozoom2="nome-abrev"
     &frame2="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cdn-despa-exter-import wMaintenance
ON LEAVE OF tt-processo-imp.cdn-despa-exter-import IN FRAME fPage1 /* Despachante Exterior */
DO:
    if  avail tt-processo-imp 
    and input frame fPage1 tt-processo-imp.cdn-despa-exter-import <> 0 then do:
          {method/referencefields.i 
           &HandleDBOLeave="h-boad098"
           &FindMethod="findemitente"
           &KeyValue1="int(tt-processo-imp.cdn-despa-exter-import:SCREEN-VALUE IN FRAME fPage1)"
           &FieldName1="nome-abrev" 
           &FieldScreen1="c-nome-desp-ext"
           &Frame1="fPage1"}  
   end.    
   else
       assign c-nome-desp-ext:screen-value in frame fPage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cdn-despa-exter-import wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-processo-imp.cdn-despa-exter-import IN FRAME fPage1 /* Despachante Exterior */
DO:
  apply 'f5':U to self in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-processo-imp.cdn-segurad-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cdn-segurad-import wMaintenance
ON F5 OF tt-processo-imp.cdn-segurad-import IN FRAME fPage1 /* Seguradora */
DO:
   {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="tt-processo-imp.cdn-segurad-import"
     &campozoom="cod-emitente"
     &frame="fPage1"
     &campo2="c-nome-segur"
     &campozoom2="nome-abrev"
     &frame2="fPage1"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cdn-segurad-import wMaintenance
ON LEAVE OF tt-processo-imp.cdn-segurad-import IN FRAME fPage1 /* Seguradora */
DO:
    if  avail tt-processo-imp
    and input frame fPage1 tt-processo-imp.cdn-segurad-import <> 0 then do:
          {method/referencefields.i 
           &HandleDBOLeave="h-boad098"
           &FindMethod="findemitente"
           &KeyValue1="int(tt-processo-imp.cdn-segurad-import:SCREEN-VALUE IN FRAME fPage1)"
           &FieldName1="nome-abrev" 
           &FieldScreen1="c-nome-segur"
           &Frame1="fPage1"}  
   end.    
   else
       assign c-nome-segur:screen-value in frame fPage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cdn-segurad-import wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-processo-imp.cdn-segurad-import IN FRAME fPage1 /* Seguradora */
DO:
  apply 'f5':U to self in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-processo-imp.cod-agente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-agente wMaintenance
ON F5 OF tt-processo-imp.cod-agente IN FRAME fPage1 /* Agente Cargas */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="tt-processo-imp.cod-agente"
     &campozoom="cod-emitente"
     &frame="fPage1"
     &campo2="c-nome-ag"
     &campozoom2="nome-abrev"
     &frame2="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-agente wMaintenance
ON LEAVE OF tt-processo-imp.cod-agente IN FRAME fPage1 /* Agente Cargas */
DO:
    if  avail tt-processo-imp 
    and input frame fPage1 tt-processo-imp.cod-agente <> 0 then do:
       {method/referencefields.i 
           &HandleDBOLeave="h-boad098"
           &FindMethod="findemitente"
           &KeyValue1="int(tt-processo-imp.cod-agente:SCREEN-VALUE IN FRAME fPage1)"
           &FieldName1="nome-abrev" 
           &FieldScreen1="c-nome-ag"
           &Frame1="fPage1"}  
   end.
   else 
       assign c-nome-ag:screen-value in frame fPage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-agente wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-processo-imp.cod-agente IN FRAME fPage1 /* Agente Cargas */
DO:
    apply "F5":U to self in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tt-processo-imp.cod-banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-banco wMaintenance
ON F5 OF tt-processo-imp.cod-banco IN FRAME fPage2 /* Banco */
DO:
    {method/zoomfields.i 
     &ProgramZoom="adzoom/z10ad018.w"
     &FieldZoom1="cod-banco"
     &FieldScreen1="tt-processo-imp.cod-banco"
     &Frame1="fPage2"
     &FieldZoom2="nome-banco"
     &FieldScreen2="c-dest-doc"
     &Frame2="fPage2"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-banco wMaintenance
ON LEAVE OF tt-processo-imp.cod-banco IN FRAME fPage2 /* Banco */
DO:
      {method/referencefields.i 
      &HandleDBOLeave="h-boad018"
      &FindMethod="findCod_banco"
      &KeyValue1="integer(tt-processo-imp.cod-banco:SCREEN-VALUE IN FRAME fPage2)"
      &FieldName1="nome-banco"
      &FieldScreen1="c-nome-banco"
      &Frame1="fPage2"}
      
      display c-nome-banco:screen-value @ c-dest-doc with frame fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-banco wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-processo-imp.cod-banco IN FRAME fPage2 /* Banco */
DO:
    apply "F5":U to self in frame fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-processo-imp.cod-consignatario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-consignatario wMaintenance
ON F5 OF tt-processo-imp.cod-consignatario IN FRAME fPage2 /* C¢digo Consignat rio */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="tt-processo-imp.cod-consignatario"
     &campozoom="cod-emitente"
     &frame="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-consignatario wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-processo-imp.cod-consignatario IN FRAME fPage2 /* C¢digo Consignat rio */
DO:
    apply "F5":U to self in frame fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-processo-imp.cod-despachante
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-despachante wMaintenance
ON F5 OF tt-processo-imp.cod-despachante IN FRAME fPage1 /* C¢digo Despachante */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="tt-processo-imp.cod-despachante"
     &campozoom="cod-emitente"
     &frame="fPage1"
     &campo2="c-nome-desp"
     &campozoom2="nome-abrev"
     &frame2="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-despachante wMaintenance
ON LEAVE OF tt-processo-imp.cod-despachante IN FRAME fPage1 /* C¢digo Despachante */
DO:
   if  avail tt-processo-imp
   and input frame fPage1 tt-processo-imp.cod-despachante <> 0 then do:
         {method/referencefields.i 
           &HandleDBOLeave="h-boad098"
           &FindMethod="findemitente"
           &KeyValue1="int(tt-processo-imp.cod-despachante:SCREEN-VALUE IN FRAME fPage1)"
           &FieldName1="nome-abrev" 
           &FieldScreen1="c-nome-desp"
           &Frame1="fPage1"}  
   end.    
   else
       assign c-nome-desp:screen-value in frame fPage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-despachante wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-processo-imp.cod-despachante IN FRAME fPage1 /* C¢digo Despachante */
DO:
    apply "F5":U to self in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME tt-processo-imp.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-estabel wMaintenance
ON F5 OF tt-processo-imp.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
      if avail tt-processo-imp then do:
        {method/zoomfields.i 
             &ProgramZoom="adzoom/z10ad107.w"
             &FieldZoom1="cod-estabel"
             &FieldScreen1="tt-processo-imp.cod-estabel"
             &Frame1="fPage0"
             &FieldZoom2="nome"
             &FieldScreen2="c-nome-estab"
             &Frame2="fPage0"}  

      end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-estabel wMaintenance
ON LEAVE OF tt-processo-imp.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  if avail tt-processo-imp then do:
      
      run gotoKey in h-boad107 (input tt-processo-imp.cod-estabel:screen-value in frame fPage0).
                                  
      if return-value = "OK":U then do:
            run getcharfield in h-boad107 ("nome":U, output c-estabelec).
            assign c-nome-estab:screen-value in frame fPage0 = c-estabelec.
      end.
      else assign c-nome-estab:screen-value in frame fPage0 = "".
  end.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-estabel wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-processo-imp.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  apply 'f5':U to self in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-processo-imp.cod-exportador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-exportador wMaintenance
ON F5 OF tt-processo-imp.cod-exportador IN FRAME fPage1 /* Exportador/Fornecedor */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="tt-processo-imp.cod-exportador"
     &campozoom="cod-emitente"
     &frame="fPage1"
     &campo2="c-nome-exp"
     &campozoom2="nome-abrev"
     &frame2="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-exportador wMaintenance
ON LEAVE OF tt-processo-imp.cod-exportador IN FRAME fPage1 /* Exportador/Fornecedor */
DO:
    if  avail tt-processo-imp 
    and input frame fPage1 tt-processo-imp.cod-exportador <> 0 then do:

        {method/referencefields.i 
           &HandleDBOLeave="h-boad098"
           &FindMethod="findemitente"
           &KeyValue1="int(tt-processo-imp.cod-exportador:SCREEN-VALUE IN FRAME fPage1)"
           &FieldName1="nome-abrev" 
           &FieldScreen1="c-nome-exp"
           &Frame1="fPage1"}  
   end.    
   else
       assign c-nome-exp:screen-value in frame fPage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-exportador wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-processo-imp.cod-exportador IN FRAME fPage1 /* Exportador/Fornecedor */
DO:
    apply "F5":U to self in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-processo-imp.cod-fabricante
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-fabricante wMaintenance
ON F5 OF tt-processo-imp.cod-fabricante IN FRAME fPage1 /* C¢digo Fabricante */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="tt-processo-imp.cod-fabricante"
     &campozoom="cod-emitente"
     &frame="fPage1"
     &campo2="c-nome-fab"
     &campozoom2="nome-abrev"
     &frame2="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-fabricante wMaintenance
ON LEAVE OF tt-processo-imp.cod-fabricante IN FRAME fPage1 /* C¢digo Fabricante */
DO:
   if  avail tt-processo-imp 
   and input frame fPage1 tt-processo-imp.cod-fabricante <> 0 then do:

          {method/referencefields.i 
           &HandleDBOLeave="h-boad098"
           &FindMethod="findemitente"
           &KeyValue1="int(tt-processo-imp.cod-fabricante:SCREEN-VALUE IN FRAME fPage1)"
           &FieldName1="nome-abrev" 
           &FieldScreen1="c-nome-fab"
           &Frame1="fPage1"}  
   end.    
   else
       assign c-nome-fab:screen-value in frame fPage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-fabricante wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-processo-imp.cod-fabricante IN FRAME fPage1 /* C¢digo Fabricante */
DO:
    apply "F5":U to self in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-processo-imp.cod-idioma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-idioma wMaintenance
ON F5 OF tt-processo-imp.cod-idioma IN FRAME fPage1 /* Idioma */
DO:
    {method/zoomfields.i 
     &ProgramZoom="unzoom/z10un078.w"
     &FieldZoom1="cod_idioma"
     &FieldScreen1="tt-processo-imp.cod-idioma"
     &Frame1="fPage1"
     &FieldZoom2="des_idioma"
     &FieldScreen2="c-desc-idioma"
     &Frame2="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-idioma wMaintenance
ON LEAVE OF tt-processo-imp.cod-idioma IN FRAME fPage1 /* Idioma */
DO:
    assign c-des-idioma = "".
    if avail tt-processo-imp then do:
        run findIdioma_id in h-bofn167 (input tt-processo-imp.cod-idioma:screen-value in frame fPage1,
                                        output c-erro).
        if c-erro = "" then 
           run getcharfield in h-bofn167 ("des_idioma":U, output c-des-idioma).
        
        assign c-desc-idioma:screen-value in frame fPage1 = c-des-idioma.
    end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-idioma wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-processo-imp.cod-idioma IN FRAME fPage1 /* Idioma */
DO:
    apply "F5":U to self in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-processo-imp.cod-itiner
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-itiner wMaintenance
ON F5 OF tt-processo-imp.cod-itiner IN FRAME fPage1 /* C¢digo Itiner rio */
DO:
    {method/zoomfields.i 
     &ProgramZoom="cxzoom/z10cx115.w"
     &FieldZoom1="cod-itiner"
     &FieldScreen1="tt-processo-imp.cod-itiner"
     &Frame1="fPage1"
     &FieldZoom2="descricao"
     &FieldScreen2="c-desc-itiner"
     &Frame2="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-itiner wMaintenance
ON LEAVE OF tt-processo-imp.cod-itiner IN FRAME fPage1 /* C¢digo Itiner rio */
DO:
   if avail tt-processo-imp then do:
        run gotoKey in h-bocx115 (input int(tt-processo-imp.cod-itiner:screen-value in frame fPage1)).
                                  
        if return-value = "OK":U then do:
            run getcharfield in h-bocx115 ("descricao":U, output c-des-itiner).
            assign c-desc-itiner:screen-value in frame fPage1 = c-des-itiner.
        end.
        else assign c-desc-itiner:screen-value in frame fPage1 = "".
   end.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-itiner wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-processo-imp.cod-itiner IN FRAME fPage1 /* C¢digo Itiner rio */
DO:
    apply "F5":U to self in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME tt-processo-imp.cod-mensagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-mensagem wMaintenance
ON ENTRY OF tt-processo-imp.cod-mensagem IN FRAME fPage3 /* C¢digo Mensagem */
DO:
    if l-entry = yes 
    then do:
      apply "leave" to tt-processo-imp.cod-mensagem in frame fpage3.
    end.      
    else assign l-entry = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-mensagem wMaintenance
ON F5 OF tt-processo-imp.cod-mensagem IN FRAME fPage3 /* C¢digo Mensagem */
DO:
  /*  {method/zoomfields.i 
 *      &ProgramZoom="inzoom/z10in176.w"
 *      &FieldZoom1="cod-mensagem"
 *      &FieldScreen1="tt-processo-imp.cod-mensagem"
 *      &Frame1="fPage3"
 *      &FieldZoom2="texto-mensag"
 *      &FieldScreen2="tt-processo-imp.texto-mensag"
 *      &Frame2="fPage3"}  */
 run pi-mensagem in this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-mensagem wMaintenance
ON LEAVE OF tt-processo-imp.cod-mensagem IN FRAME fPage3 /* C¢digo Mensagem */
DO:
  &if defined(bf-mat-comex) &then
    if avail tt-processo-imp then do:
        run findCodigo in h-boad176 (input int(tt-processo-imp.cod-mensagem:screen-value in frame fPage3),
                                     output c-erro).
        if c-erro = "" then do:
            run getcharfield in h-boad176 ("texto-mensag[1]", output c-texto-mensag-1).
            run getcharfield in h-boad176 ("texto-mensag[2]", output c-texto-mensag-2).
            run getcharfield in h-boad176 ("texto-mensag[3]", output c-texto-mensag-3).            
            run getcharfield in h-boad176 ("texto-mensag[4]", output c-texto-mensag-4).
            run getcharfield in h-boad176 ("texto-mensag[5]", output c-texto-mensag-5).            
        end.
        
        assign tt-processo-imp.texto-mensag:screen-value in frame fPage3 = c-texto-mensag-1 + c-texto-mensag-2 + 
                                                                           c-texto-mensag-3 + c-texto-mensag-4 + 
                                                                           c-texto-mensag-5.
    end.    
  &else
  
    if avail tt-processo-imp then do:
      {method/referencefields.i 
       &HandleDBOLeave="h-boad176"
       &FindMethod="findCodigo"
       &KeyValue1="tt-processo-imp.cod-mensagem:SCREEN-VALUE IN FRAME fPage3"
       &FieldName1="texto-mensag"
       &FieldScreen1="texto-mensag"
       &Frame1="fPage3"}  
    end.
  &endif
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-mensagem wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-processo-imp.cod-mensagem IN FRAME fPage3 /* C¢digo Mensagem */
DO:
    apply "F5":U to self in frame fPage3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-processo-imp.cod-transportador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-transportador wMaintenance
ON F5 OF tt-processo-imp.cod-transportador IN FRAME fPage1 /* C¢digo Transportador */
DO:
    {method/zoomfields.i 
         &ProgramZoom="adzoom/z10ad268.w"
         &FieldZoom1="cod-transp"
         &FieldScreen1="tt-processo-imp.cod-transportador"
         &Frame1="fPage1"
         &FieldZoom2="nome-abrev"
         &FieldScreen2="c-nome-transp"
         &Frame2="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-transportador wMaintenance
ON LEAVE OF tt-processo-imp.cod-transportador IN FRAME fPage1 /* C¢digo Transportador */
DO:
    if  avail tt-processo-imp
    and input frame fPage1 tt-processo-imp.cod-transportador <> 0 then do:

        run gotoKey in h-boad268 (input tt-processo-imp.cod-transportador:screen-value in frame fPage1).
                                  
        if return-value = "OK":U then do:
            run getcharfield in h-boad268 ("nome-abrev":U, output c-transp).
            assign c-nome-transp:screen-value in frame fPage1 = c-transp.
        end.
        else assign c-nome-transp:screen-value in frame fPage1 = "".
   end. 
   else
       assign c-nome-transp:screen-value in frame fPage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-transportador wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-processo-imp.cod-transportador IN FRAME fPage1 /* C¢digo Transportador */
DO:
    apply "F5":U to self in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tt-processo-imp.estab-fisc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.estab-fisc wMaintenance
ON F5 OF tt-processo-imp.estab-fisc IN FRAME fPage2 /* Estabel Fiscal */
DO:
    {method/zoomfields.i 
     &ProgramZoom="adzoom/z10ad107.w"
     &FieldZoom1="cod-estabel"
     &FieldScreen1="tt-processo-imp.estab-fisc"
     &Frame1="fPage2"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.estab-fisc wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-processo-imp.estab-fisc IN FRAME fPage2 /* Estabel Fiscal */
DO:
    apply "F5":U to self in frame fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-processo-imp.num-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.num-pedido wMaintenance
ON F5 OF tt-processo-imp.num-pedido IN FRAME fPage1 /* Pedido */
DO:
    &scop framepar1 in frame fPage1
    assign c-lista = string(tt-processo-imp.cdn-corretor-cambio-import:handle {&framepar1}) + '|':U + 'cdn-corretor-cambio-import':U
                    + chr(10) + string(tt-processo-imp.cod-despachante:handle {&framepar1}) + '|':U + 'cdn-despa-import':U
                    + chr(10) + string(tt-processo-imp.cdn-despa-exter-import:handle {&framepar1}) + '|':U + 'cdn-despa-exter-import':U
                    + chr(10) + string(tt-processo-imp.cdn-segurad-import:handle {&framepar1}) + '|':U + 'cdn-segurad-import':U
                    + chr(10) + string(tt-processo-imp.cdn-corretor-import:handle {&framepar1}) + '|':U + 'cdn-corretor-import':U
                    + chr(10) + string(tt-processo-imp.num-pedido:handle {&framepar1}) + '|':U + 'num-pedido':U
                    .
    
     {include/zoomvar.i 
     &prog-zoom="inzoom/z12in295.w"
     &campo="tt-processo-imp.num-pedido"
     &campozoom="num-pedido"
     &Frame="fPage1"
     &campo2="tt-processo-imp.estab-fisc"
     &campozoom2="estab-fiscal"
     &Frame2="fPage2"          
     &campo3="tt-processo-imp.cod-exportador"
     &campozoom3="cod-emitente"
     &Frame3="fPage1"
     &campo4="tt-processo-imp.cod-fabricante"
     &campozoom4="cod-fabricante"
     &Frame4="fPage1"     
     &campo5="tt-processo-imp.cod-transportador"
     &campozoom5="transportador"
     &Frame5="fPage1"
     &campo6="tt-processo-imp.dt-emissao"
     &campozoom6="data-pedido"
     &Frame6="fPage1"
     &campo7="tt-processo-imp.cod-itiner"
     &campozoom7="itinerario"
     &Frame7="fPage1"
     &campo8="tt-processo-imp.cod-idioma"
     &campozoom8="cod-idioma"
     &Frame8="fPage1"
     &campo9="combo-box-1"
     &campozoom9="via-transporte"
     &Frame9="fPage1"
     &campo10="tt-processo-imp.cod-estabel"
     &campozoom10="cod-estabel"
     &Frame10="fPage0"
     &parametros="run pi-seta-atributos-chave in wh-pesquisa (c-lista)." }
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.num-pedido wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-processo-imp.num-pedido IN FRAME fPage1 /* Pedido */
DO:    
    apply "F5":U to self in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/* ***************************  Main Block  *************************** */

tt-processo-imp.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-processo-imp.cod-exportador:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-processo-imp.cod-fabricante:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-processo-imp.cod-despachante:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-processo-imp.cod-agente:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-processo-imp.cod-transportador:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-processo-imp.num-pedido:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-processo-imp.cod-itiner:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-processo-imp.cod-idioma:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-processo-imp.cdn-corretor-cambio-import:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-processo-imp.cdn-despa-exter-import:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-processo-imp.cdn-segurad-import:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-processo-imp.cdn-corretor-import:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-processo-imp.estab-fisc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.
tt-processo-imp.cod-banco:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.
tt-processo-imp.cod-consignatario:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.
tt-processo-imp.cod-mensagem:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage3.
assign  l-entry = no.


/*--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyinterface wMaintenance 
PROCEDURE afterDestroyinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(h-boad018) THEN DO:
       delete procedure h-boad018.
       assign h-boad018 = ?.
    end.
    
    IF VALID-HANDLE(h-bofn167) THEN DO:                                           
       delete procedure h-bofn167.
       assign h-bofn167 = ?.
    end.

    IF VALID-HANDLE(h-boad107) THEN DO:                                           
       delete procedure h-boad107.
       assign h-boad107 = ?.
    end.
    
    IF VALID-HANDLE(h-bocx115) THEN DO:                                           
       delete procedure h-bocx115.
       assign h-bocx115 = ?.
    end.

    IF VALID-HANDLE(h-boad268) THEN DO:                                           
       delete procedure h-boad268.
       assign h-boad268 = ?.
    end.
    
    IF VALID-HANDLE(h-boad098) THEN DO:                                           
       delete procedure h-boad098.
       assign h-boad098 = ?.
    end.
    
    IF VALID-HANDLE(h-boin295) THEN DO:
       delete procedure h-boin295.
       assign h-boin295 = ?.
    end.

    IF VALID-HANDLE(h-boad176) THEN DO:
       delete procedure h-boad176.
       assign h-boad176 = ?.
    end.

    IF VALID-HANDLE(h-bocx140) THEN DO:
       delete procedure h-bocx140.
       assign h-bocx140 = ?.
    end.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisableFields wMaintenance 
PROCEDURE afterDisableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    

    assign menu-item miRelaciona:sensitive in menu mbMain = YES .

    DISABLE btRelaciona WITH FRAME fpage0.
    
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
if  avail tt-processo-imp then do:
    disp tt-processo-imp.cod-estabel tt-processo-imp.nr-proc-imp   with frame fPage0.
    disp tt-processo-imp.cod-exportador tt-processo-imp.num-pedido with frame fPage1.

    if tt-processo-imp.via-transp <> 0 THEN
      ASSIGN combo-box-1:screen-value in frame fPage1 = {adinc/i01ad268.i 04 tt-processo-imp.via-transp}.
       
    assign c-dest-doc:screen-value in frame fPage2 = substr(tt-processo-imp.char-1,1,40).

    apply 'leave':U to tt-processo-imp.cod-estabel                in frame fPage0.
    apply 'leave':U to tt-processo-imp.cod-exportador             in frame fPage1.
    apply 'leave':U to tt-processo-imp.cod-fabricante             in frame fPage1.
    apply 'leave':U to tt-processo-imp.cod-despachante            in frame fPage1.
    apply 'leave':U to tt-processo-imp.cod-transportador          in frame fPage1.
    apply 'leave':U to tt-processo-imp.cod-agente                 in frame fPage1.
    apply 'leave':U to tt-processo-imp.cod-itiner                 in frame fPage1.
    apply 'leave':U to tt-processo-imp.cod-idioma                 in frame fPage1.
    apply 'leave':U to tt-processo-imp.cdn-corretor-cambio-import in frame fPage1.
    apply 'leave':U to tt-processo-imp.cdn-despa-exter-import     in frame fPage1.
    apply 'leave':U to tt-processo-imp.cdn-segurad-import         in frame fPage1.
    apply 'leave':U to tt-processo-imp.cdn-corretor-import        in frame fPage1.
    apply "leave":U to tt-processo-imp.cod-banco                  in frame fPage2.

    IF AVAIL tt-processo-imp THEN
        ENABLE btRelaciona WITH FRAME {&FRAME-NAME}.
    ELSE
        DISABLE btRelaciona WITH FRAME {&FRAME-NAME}.

    return "OK":U.

end.

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
    
    disable c-nome-banco with frame fPage2.

    IF cAction = "COPY":U or cAction = "ADD":U OR cAction = "UPDATE":U THEN DO:
        DISABLE btRelaciona WITH FRAME {&FRAME-NAME}.
        assign menu-item miRelaciona:sensitive in menu mbMain = NO.
    END.
    if cAction = "COPY":U or cAction = "ADD":U then do:
       enable tt-processo-imp.cod-estabel tt-processo-imp.nr-proc-imp   with frame fPage0.
       enable tt-processo-imp.cod-exportador tt-processo-imp.num-pedido with frame fPage1.
    end.
    else do: 
       display tt-processo-imp.cod-estabel tt-processo-imp.nr-proc-imp   with frame fPage0.
       display tt-processo-imp.cod-exportador tt-processo-imp.num-pedido with frame fPage1.
    end.

    ENABLE btRelaciona WITH FRAME fpage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterinitializeinterface wMaintenance 
PROCEDURE afterinitializeinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign lMultipleAdd = no.

    IF AVAIL tt-processo-imp THEN
        enable btrelaciona with frame {&FRAME-NAME}.

    if l-add-ccp = yes and gr-pedido-compr <> ? then do:
        assign l-add-ccp = no. 
        
        Run verificaPedidoprocesso in h-bocx140 (input p-num-pedido, output c-return1, output r-rowid).
        if c-return1 = 0 then do:
            RUN addRecord IN THIS-PROCEDURE.
            RUN openQueryStatic IN h-boin295 (INPUT "main":U).
            RUN repositionRecord IN h-boin295 (INPUT gr-pedido-compr).
            assign gr-pedido-compr = ?
                   c-return1 = 0.
            Run pi-carregarProcessopedido (input p-num-pedido).
        end. 
        else do:
           /*RUN openQueryStatic IN h-boin295 (INPUT "main":U).*/
           RUN repositionRecord IN this-procedure (INPUT r-rowid).
           assign gr-pedido-compr = ?
                  c-return1 = 0.
        end.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveFields wMaintenance 
PROCEDURE afterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN tt-processo-imp.cod-estabel = tt-processo-imp.cod-estabel:SCREEN-VALUE IN FRAME fPage0
           tt-processo-imp.nr-proc-imp = tt-processo-imp.nr-proc-imp:SCREEN-VALUE IN FRAME fPage0
           tt-processo-imp.cod-exportador = integer(tt-processo-imp.cod-exportador:SCREEN-VALUE IN FRAME fPage1)
           tt-processo-imp.num-pedido = integer(tt-processo-imp.num-pedido:SCREEN-VALUE IN FRAME fPage1).
 
    ASSIGN tt-processo-imp.via-transp = {adinc/i01ad268.i 06 combo-box-1}
           SUBSTR(tt-processo-imp.char-1,1,40) = c-dest-doc:SCREEN-VALUE IN FRAME fPage2.           
 
   /*assign l-add-ccp = no.*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeinitializeinterface wMaintenance 
PROCEDURE beforeinitializeinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN COMBO-BOX-1:LIST-ITEMS IN FRAME fPage1 = {adinc/i01ad268.i 03}.

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
&IF '{&mgdis_version}' >= '2.06f' &THEN
    run fnbo/bofn017.p persistent set h-bofn017.
    run goTokey in h-bofn017 (input v_cod_usuar_corren).
    IF RETURN-VALUE = "OK" THEN DO:
        run getCurrent in h-bofn017 (output table tt_usuar_mestre).
        find first tt_usuar_mestre no-error.
        if   avail tt_usuar_mestre then
            assign c-idiom-usuar = tt_usuar_mestre.cod_idiom_orig.
   end.
    delete procedure h-bofn017.
&ELSE
    run unbo/boun178.p persistent set h-boun178.
    run findSrmstr_id in h-boun178 (input v_cod_usuar_corren, output c-return).
    if  c-return = "" then do:
        run getCurrent in h-boun178 (output table tt_usuar_mestre).
        find first tt_usuar_mestre no-error.
        if   avail tt_usuar_mestre then
            assign c-idiom-usuar = tt_usuar_mestre.cod_idiom_orig.
    end.
    delete procedure h-boun178.
&ENDIF

run pi-recebe-idioma in h-bocx140 (input c-idiom-usuar).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
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
         SIZE 35 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE cStatus AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE ccod-estabel LIKE tt-processo-imp.cod-estabel VIEW-AS FILL-IN SIZE 05 BY 0.88  NO-UNDO.
    DEFINE VARIABLE cnr-proc-imp LIKE tt-processo-imp.nr-proc-imp VIEW-AS FILL-IN SIZE 13 BY 0.88 NO-UNDO.
   
    DEFINE FRAME fGoToRecord
        ccod-estabel  AT ROW 1.21 COL 18 COLON-ALIGNED
        cnr-proc-imp  AT ROW 2.21 COL 18 COLON-ALIGNED
        btGoToOK      AT ROW 3.63 COL 2.14
        btGoToCancel  AT ROW 3.63 COL 13
        rtGoToButton  AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE FONT 1 TITLE "V  Para Processo Imp"
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Processo_Imp"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN ccod-estabel cnr-proc-imp.
        
        &IF DEFINED(DBOVersion) <> 0 &THEN
           RUN findprocessoImp IN {&hDBOTable} (INPUT ccod-estabel,
                                                 input cnr-proc-imp,
                                                 OUTPUT cStatus).
           IF cStatus <> "":U THEN DO:
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Processo_Importa‡Æo" *}
              RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                 INPUT 2, 
                                 INPUT RETURN-VALUE).
              
              RETURN NO-APPLY.
           END.
        &ENDIF
        
        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    assign ccod-estabel:width = 4.


    ENABLE ccod-estabel cnr-proc-imp btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
    END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) THEN DO:
       RUN cxbo/bocx140.p persistent set h-bocx140.
    END.
    
    IF NOT VALID-HANDLE(h-boad018) THEN DO:
       RUN adbo/boad018.p persistent set h-boad018.
    END.

    IF NOT VALID-HANDLE(h-boad176) THEN DO:
       RUN adbo/boad176.p persistent set h-boad176.
    END.
    
    IF NOT VALID-HANDLE(h-boad098) THEN DO:
       RUN adbo/boad098na.p persistent set h-boad098.
    END.

    IF NOT VALID-HANDLE(h-boad268) THEN DO:
       RUN adbo/boad268na.p persistent set h-boad268.
    END.

    IF NOT VALID-HANDLE(h-boad107) THEN DO:
       RUN adbo/boad107na.p persistent set h-boad107.
    END.

    IF NOT VALID-HANDLE(h-bocx115) THEN DO:
       RUN cxbo/bocx115na.p persistent set h-bocx115.
    END.

    IF NOT VALID-HANDLE(h-bofn167) THEN DO:
       RUN fnbo/bofn167.p persistent set h-bofn167.
    END.

    IF NOT VALID-HANDLE(h-boin295) THEN DO:
       RUN inbo/boin295.p persistent set h-boin295.
    END.

    IF NOT VALID-HANDLE(h-bocx155) THEN DO:
       RUN cxbo/bocx155.p persistent set h-bocx155.
    END.
    
    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN {&hDBOTable} (INPUT 1).
    &ELSE
        RUN openQueryStatic IN {&hDBOTable} (INPUT "cod-estabel":U).
    &ENDIF  
      
    RUN openQueryStatic IN h-boad268 (INPUT "Main":U).
    RUN openQueryStatic IN h-bocx115 (INPUT "Main":U).
    RUN openQueryStatic IN h-boad107 (INPUT "Main":U).    

    &IF '{&mgdis_version}' < '2.06f' &THEN
        /*Tecnica para implementar valida‡Æo produto Estendido*/
        {cdp/cdapi558.i1}
    &endif
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carregarProcessopedido wMaintenance 
PROCEDURE pi-carregarProcessopedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-num-pedido like pedido-compr.num-pedido no-undo.
    
    def var i-via-transporte as integer no-undo.

    run findNumero in h-boin295(input p-num-pedido,output c-return).
    if  c-return = "":U then do:

        run getIntfield  in h-boin295(input "num-pedido":U,output tt-processo-imp.num-pedido).
        run getCharfield in h-boin295(input "end-entrega":U,output tt-processo-imp.estab-fisc).
        run getIntfield  in h-boin295(input "cod-emitente":U,output tt-processo-imp.cod-exportador).
        run getIntfield  in h-boin295(input "cod-emitente":U,output tt-processo-imp.cod-fabricante).
        run getIntfield  in h-boin295(input "cod-transp":U,output tt-processo-imp.cod-transportador).
        run getIntfield  in h-boin295(input "via-transp":U,output i-via-transporte).
        run getDatefield in h-boin295(input "data-pedido":U,output tt-processo-imp.dt-emissao).

        ASSIGN combo-box-1 = {adinc/i01ad268.i 04 i-via-transporte}.
        
        &if defined(bf-mat-comex) &then            
           run getCharfield  in h-boin295(input "end-entrega":U,output tt-processo-imp.cod-estabel).        
        &else 
           run getCharfield  in h-boin295(input "cod-estabel":U,output tt-processo-imp.cod-estabel).
        &endif                
        
        run findPk-emitente in h-bocx155(input tt-processo-imp.cod-exportador,output c-return).
        if c-return = "" then do:
            run getIntfield  in h-bocx155(input "cod-itiner-imp":U,output tt-processo-imp.cod-itiner).
            run getIntfield  in h-bocx155(input "cdn-despa-import":U,output tt-processo-imp.cod-despachante).
            run getIntfield  in h-bocx155(input "cdn-corretor-cambio-import":U,output tt-processo-imp.cdn-corretor-cambio-import).
            run getIntfield  in h-bocx155(input "cdn-corretor-import":U,output tt-processo-imp.cdn-corretor-import).
            run getIntfield  in h-bocx155(input "cdn-despa-exter-import":U,output tt-processo-imp.cdn-despa-exter-import).
            run getIntfield  in h-bocx155(input "cdn-segurad-import":U,output tt-processo-imp.cdn-segurad-import).
            run getCharfield in h-bocx155(input "cod-idioma":U,output tt-processo-imp.cod-idioma).
        end.
        
        {cdp~/cd2508.i} /*Fun‡Æo EMS2-COMEX-MEXICO*/

        IF l-EMS2-IMP-MEXICO THEN DO:
            /* -----   InclusÆo Chamada UPC   ----- */
            IF c-nom-prog-upc-mg97 <> "":U AND c-nom-prog-upc-mg97 <> ? THEN DO:
                RUN VALUE(c-nom-prog-upc-mg97) (INPUT "SugereCodTransp",
                                                INPUT "",
                                                INPUT THIS-PROCEDURE,
                                                INPUT FRAME {&FRAME-NAME}:HANDLE,
                                                INPUT STRING(tt-processo-imp.cod-itiner),     
                                                INPUT ?).
            END.
            IF RETURN-VALUE <> "OK":U THEN
               ASSIGN tt-processo-imp.cod-transportador = int(RETURN-VALUE).
        END.
        disp tt-processo-imp.estab-fisc
             with frame fPage2.            

        disp tt-processo-imp.num-pedido
             tt-processo-imp.cod-exportador
             tt-processo-imp.cod-fabricante
             tt-processo-imp.cod-transportador
             tt-processo-imp.cod-itiner
             tt-processo-imp.cod-idioma
             tt-processo-imp.dt-emissao
             tt-processo-imp.cod-despachante
             tt-processo-imp.cdn-corretor-cambio-import
             tt-processo-imp.cdn-despa-exter-import
             tt-processo-imp.cdn-segurad-import
             tt-processo-imp.cdn-corretor-import
             combo-box-1 
             with frame fPage1.

        disp tt-processo-imp.cod-estabel 
             with frame fPage0.

        apply 'leave':U to tt-processo-imp.cod-estabel                in frame fPage0.
        apply 'leave':U to tt-processo-imp.cod-exportador             in frame fPage1.
        apply 'leave':U to tt-processo-imp.cod-fabricante             in frame fPage1.
        apply 'leave':U to tt-processo-imp.cod-despachante            in frame fPage1.
        apply 'leave':U to tt-processo-imp.cod-transportador          in frame fPage1.
        apply 'leave':U to tt-processo-imp.cod-itiner                 in frame fPage1.
        apply 'leave':U to tt-processo-imp.cod-idioma                 in frame fPage1.
        apply 'leave':U to tt-processo-imp.cdn-corretor-cambio-import in frame fPage1.
        apply 'leave':U to tt-processo-imp.cdn-despa-exter-import     in frame fPage1.
        apply 'leave':U to tt-processo-imp.cdn-segurad-import         in frame fPage1.
        apply 'leave':U to tt-processo-imp.cdn-corretor-import        in frame fPage1.
        apply "leave":U to tt-processo-imp.cod-banco                  in frame fPage2.

    end.    
               
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-IncluiPedido wMaintenance 
PROCEDURE pi-IncluiPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-num-pedido like tt-processo-imp.num-pedido no-undo.
    
    if  p-num-pedido <> 0 then do:
        run addRecord IN THIS-PROCEDURE.
        run pi-carregarProcessopedido in this-procedure (input p-num-pedido).

    end.

 return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mensagem wMaintenance 
PROCEDURE pi-mensagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{include/zoomvar.i &prog-zoom=adzoom/z01ad176.w
                        &campo="tt-processo-imp.cod-mensagem"
                        &campozoom="cod-mensagem"
                        &frame="fPage3"}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

