&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decla-import-ord NO-UNDO LIKE decla-import-ord
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
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
{include/i-prgvrs.i IM0045 2.00.00.080 } /*** "010080" 27/11/2024 15:28:07 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0045 MIM}
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

{include/i_dbvers.i} /*Include de PrÇ-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar validaá∆o produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
&endif
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0045
&GLOBAL-DEFINE Version        2.00.00.080
&GLOBAL-DEFINE DBOVersion     1.1

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FramesHandle   STRING(FRAME fPage1:HANDLE) + ",":U + ~
                              STRING(FRAME fPage2:HANDLE) + ",":U + ~
                              STRING(FRAME fPage3:HANDLE)
                        
&GLOBAL-DEFINE FolderLabels   Embarque, Financ/Fiscal, Narrativa

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            YES
&GLOBAL-DEFINE Copy           YES
&GLOBAL-DEFINE Update         NO
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        tt-embarque-imp
&GLOBAL-DEFINE hDBOTable      h-bocx220
&GLOBAL-DEFINE DBOTable       embarque-imp

&GLOBAL-DEFINE page0KeyFields tt-embarque-imp.cod-estabel~
                              tt-embarque-imp.embarque 
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    tt-embarque-imp.cod-transportador~
                              tt-embarque-imp.cod-despachante~
                              cx-via-transporte~
                              tt-embarque-imp.cod-conhecto-master~
                              tt-embarque-imp.cod-conhecto-house~
                              tt-embarque-imp.cdn-corretor-cambio-import~
                              tt-embarque-imp.cdn-despa-exter-import~
                              tt-embarque-imp.cdn-segurad-import~
                              tt-embarque-imp.cdn-corretor-import~
                              tt-embarque-imp.cod-incoterm
&GLOBAL-DEFINE page2Fields    tt-embarque-imp.cod-banco~
                              tt-embarque-imp.carta-credito~
                              tt-embarque-imp.nr-rof~
                              tt-embarque-imp.declaracao-import~
                              tt-embarque-imp.data-DI~
                              c-nome-banco
&GLOBAL-DEFINE page3Fields    tt-embarque-imp.narrativa


/* Vari†veis de Sistema */
{utp/ut-glob.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF  VARIABLE {&hDBOTable}     AS HANDLE  NO-UNDO.

def var c-embarque    like embarque-imp.embarque    no-undo.
def var c-cod-estabel like embarque-imp.cod-estabel no-undo.

def var h-boad018              as handle  no-undo.
def var h-boad355              as handle  no-undo.
def var h-boad098              as handle  no-undo.
def var h-boad268              as handle  no-undo.
def var h-boin682              as handle  no-undo.
DEF VAR h-boin274              AS HANDLE  NO-UNDO.
def var h-bocx225              as handle  no-undo.
def var h-boad107              as handle  no-undo.
def var cErro                  as char    no-undo.
DEF var pcAction               AS CHAR    NO-UNDO.
def var r-chave                as rowid   no-undo.
def var c-return               as char    no-undo.
def var v-pagar                as char    no-undo.
def var v-receber              as char    no-undo.
def var l-modulo-mec           as logical no-undo.
DEF VAR l-modulo-07            AS LOGICAL NO-UNDO.
DEF VAR i-natureza             AS INT     NO-UNDO.
DEF VAR h-eq0502               AS HANDLE  NO-UNDO.
def var h-bocx404              as handle  no-undo.
def var iRowsReturned          as integer no-undo.
def var dt-data-aux            as date    no-undo.
DEF VAR l-encontrou-adic-itens AS LOGICAL NO-UNDO.
DEF VAR l-funcao-ifric         AS LOGICAL NO-UNDO.
{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

DEF VAR l-modul-eq             AS LOGICAL NO-UNDO.

DEF TEMP-TABLE tt-grp-embarq-selecao-2 NO-UNDO 
        FIELD sequencia AS INT LABEL "Seq"
        &IF "{&mguni_version}" >= "2.071" &THEN
            FIELD c-estabel AS CHAR FORMAT "x(5)" LABEL "Estab"
        &ELSE
            FIELD c-estabel AS CHAR FORMAT "x(3)" LABEL "Estab"
        &ENDIF
        FIELD nom-grp-embarq LIKE eq-grp-embarq.nom-grp-embarq
        FIELD des-grp-embarq AS CHAR FORMAT "x(20)" LABEL "Nome Grp Embarq"
        FIELD cod-canal-venda LIKE eq-grp-embarq.cod-canal-venda.
    
DEF TEMP-TABLE tt-grp-embarq-selecao-1 NO-UNDO 
        FIELD sequencia AS INT LABEL "Seq" 
        &IF "{&mguni_version}" >= "2.071" &THEN
            FIELD c-estabel AS CHAR FORMAT "x(5)" LABEL "Estab"
        &ELSE
            FIELD c-estabel AS CHAR FORMAT "x(3)" LABEL "Estab"
        &ENDIF
        FIELD nom-grp-embarq LIKE eq-grp-embarq.nom-grp-embarq
        FIELD des-grp-embarq AS CHAR FORMAT "x(20)" LABEL "Nome Grp Embarq"
        FIELD cod-canal-venda LIKE eq-grp-embarq.cod-canal-venda.
    
DEFINE TEMP-TABLE tt-selecao NO-UNDO
           FIELD cod-estabel-ini     AS CHAR
           FIELD cod-estabel-fim     AS CHAR
           FIELD cod-canal-venda-ini AS INT
           FIELD cod-canal-venda-fim AS INT
           FIELD nom-grp-embarq-ini  AS CHAR
           FIELD nom-grp-embarq-fim  AS CHAR
           FIELD l-estabelec-null    AS LOGICAL
           FIELD l-canal-null        AS LOGICAL.

{eqp/eq0502b.i}

DEFINE NEW GLOBAL SHARED VARIABLE gl-im0044      AS LOGICAL  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE   NO-UNDO.

/*def new global shared var l-add-ccp as logical   no-undo.
def new global shared var gr-pedido-compr as rowid   no-undo.
def new global shared var p-num-pedido as integer  no-undo.*/


def var c-desc-estabel as char    no-undo.
def var c-descricao    as char    no-undo.

DEF VAR pr-rowid       AS ROWID   no-undo.

DEF VAR h-bocx407      AS HANDLE  NO-UNDO.
DEF var h-bocx402      AS HANDLE  NO-UNDO.
DEF VAR wh-pesquisa    AS HANDLE  NO-UNDO.
DEF VAR h-bocx00477    AS HANDLE  NO-UNDO.

DEF VAR l-habilita     AS LOGICAL NO-UNDO.

ASSIGN l-funcao-ifric = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-ifric22":U AND funcao.ativo).

{cxbo/bocx00477.i tt-embarq-imp-internac}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque 
&Scoped-define ENABLED-TABLES tt-embarque-imp
&Scoped-define FIRST-ENABLED-TABLE tt-embarque-imp
&Scoped-Define ENABLED-OBJECTS RECT-2 rtToolBar btAdd btCopy btUpdate ~
btDelete btUndo btCancel btSave BtRelaciona btEmbVeiculo btPedido btFatura ~
btQueryJoins btReportsJoins btExit btHelp btFirst btPrev btNext btLast ~
btGoTo btSearch btpesoscubagem btPesosImpostos bt-gtos-aduana btimpostos 
&Scoped-Define DISPLAYED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque 
&Scoped-define DISPLAYED-TABLES tt-embarque-imp
&Scoped-define FIRST-DISPLAYED-TABLE tt-embarque-imp
&Scoped-Define DISPLAYED-OBJECTS fi-estabel-nome 

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
DEFINE BUTTON bt-gtos-aduana 
     LABEL "Sim. Gtos. Aduana" 
     SIZE 15 BY 1.

DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image\im-copy":U
     IMAGE-INSENSITIVE FILE "image\ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image\im-era":U
     IMAGE-INSENSITIVE FILE "image\ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btEmbVeiculo 
     IMAGE-UP FILE "image/im-carg.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Controle Containers".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFatura 
     IMAGE-UP FILE "image\im-pcust":U
     IMAGE-INSENSITIVE FILE "image\ii-pcust":U
     LABEL "Fatura" 
     SIZE 4 BY 1.25 TOOLTIP "Faturas do Embarque"
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btimpostos 
     LABEL "&Impostos" 
     SIZE 15 BY 1.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btOrdem 
     IMAGE-UP FILE "image\im-forma":U
     IMAGE-INSENSITIVE FILE "image\ii-forma":U
     LABEL "Ordem" 
     SIZE 4 BY 1.25 TOOLTIP "Ordens"
     FONT 4.

DEFINE BUTTON btPedido 
     IMAGE-UP FILE "image\im-pedido":U
     IMAGE-INSENSITIVE FILE "image\im-solcot":U
     LABEL "Pedido" 
     SIZE 4 BY 1.25 TOOLTIP "Pedidos"
     FONT 4.

DEFINE BUTTON btpesoscubagem 
     LABEL "&Peso e Cubagem" 
     SIZE 15 BY 1.

DEFINE BUTTON btPesosImpostos 
     LABEL "Pesos e Impostos" 
     SIZE 17 BY 1 TOOLTIP "Ajuste Pesos e Impostos dos Itens Embarcados".

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON BtRelaciona 
     IMAGE-UP FILE "image\im-carga.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-carga.bmp":U
     LABEL "LI's Relacionados" 
     SIZE 4 BY 1.25 TOOLTIP "LI's Relacionados".

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUndo 
     IMAGE-UP FILE "image\im-undo":U
     IMAGE-INSENSITIVE FILE "image\ii-undo":U
     LABEL "Undo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE fi-estabel-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE cx-via-transporte AS INTEGER FORMAT "->,>>>,>>9" INITIAL 1 
     LABEL "Via Transporte" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Rodovi†rio",1,
                     "Aerovi†rio",2,
                     "Mar°timo",3,
                     "Ferrovi†rio",4,
                     "Rodoferrovi†rio",5,
                     "Rodofluvial",6,
                     "Rodoaerovi†rio",7,
                     "Outros",8
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-fornecedor AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cdn-corretor-cambio-import AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cdn-corretor-import AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cdn-despa-exter-import AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cdn-segurad-import AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-despachante AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-transportador AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-fornecedor AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "C¢digo Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE cb-documento-import AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Documento Importaá∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE cb-natureza-cambial AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Natureza Cambial" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE c-cdn-emitente-saida-div AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-banco AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 26.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cdn-emitente-saida-div AS INTEGER FORMAT ">>,>>>,>>9":U INITIAL 0 
     LABEL "Fornecedor ISD" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-num-di-ems AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "DI EMS" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btAdd AT ROW 1.13 COL 26.14 HELP
          "Inclui nova ocorrància"
     btCopy AT ROW 1.13 COL 30.29 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btUpdate AT ROW 1.13 COL 34.29 HELP
          "Altera ocorrància corrente"
     btDelete AT ROW 1.13 COL 38.29 HELP
          "Elimina ocorrància corrente"
     btUndo AT ROW 1.13 COL 42.29 HELP
          "Desfaz alteraá‰es"
     btCancel AT ROW 1.13 COL 46.29 HELP
          "Cancela alteraá‰es"
     btSave AT ROW 1.13 COL 50.29 HELP
          "Confirma alteraá‰es"
     BtRelaciona AT ROW 1.13 COL 54.72 HELP
          "LI's Relacionados"
     btEmbVeiculo AT ROW 1.13 COL 58.57
     btOrdem AT ROW 1.13 COL 62.57 HELP
          "Ordens de Compra"
     btPedido AT ROW 1.13 COL 66.57 HELP
          "Pedidos de Compra"
     btFatura AT ROW 1.13 COL 70.57 HELP
          "Faturas do Embarque"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     btFirst AT ROW 1.17 COL 1.72 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.17 COL 5.72 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.17 COL 9.72 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.17 COL 13.72 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.17 COL 17.72 HELP
          "V† Para"
     btSearch AT ROW 1.17 COL 21.72 HELP
          "Pesquisa"
     tt-embarque-imp.cod-estabel AT ROW 2.75 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     fi-estabel-nome AT ROW 2.75 COL 35.43 COLON-ALIGNED NO-LABEL
     tt-embarque-imp.embarque AT ROW 3.75 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     btpesoscubagem AT ROW 14.46 COL 4
     btPesosImpostos AT ROW 14.46 COL 4
     bt-gtos-aduana AT ROW 14.46 COL 19
     btimpostos AT ROW 14.46 COL 19
     RECT-2 AT ROW 2.58 COL 1.29
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 15.25
         FONT 1.

DEFINE FRAME fPage2
     tt-embarque-imp.cod-banco AT ROW 1 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-nome-banco AT ROW 1 COL 33.14 COLON-ALIGNED NO-LABEL
     tt-embarque-imp.carta-credito AT ROW 1.96 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 24 BY .88
     tt-embarque-imp.nr-rof AT ROW 2.92 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 24 BY .88
     tt-embarque-imp.declaracao-import AT ROW 3.88 COL 28 COLON-ALIGNED HELP
          "N£mero Declaraá∆o de Importaá∆o SISCOMEX"
          LABEL "DI/DUIMP Siscomex":R25
          VIEW-AS FILL-IN 
          SIZE 24 BY .88
     fi-num-di-ems AT ROW 4.83 COL 28 COLON-ALIGNED HELP
          "N£mero Declaraá∆o de Importaá∆o"
     tt-embarque-imp.data-DI AT ROW 5.79 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     cb-natureza-cambial AT ROW 6.75 COL 28 COLON-ALIGNED
     fi-cdn-emitente-saida-div AT ROW 7.71 COL 28 COLON-ALIGNED WIDGET-ID 6
     cb-documento-import AT ROW 7.71 COL 28 COLON-ALIGNED WIDGET-ID 4
     c-cdn-emitente-saida-div AT ROW 7.71 COL 38.14 COLON-ALIGNED NO-LABEL WIDGET-ID 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.5
         SIZE 86.43 BY 7.75
         FONT 1.

DEFINE FRAME fPage1
     c-desc-fornecedor AT ROW 6.25 COL 26.72 COLON-ALIGNED NO-LABEL
     i-cod-fornecedor AT ROW 6.25 COL 16.57 COLON-ALIGNED
     tt-embarque-imp.cod-transportador AT ROW 1.25 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-transportador AT ROW 1.25 COL 26.72 COLON-ALIGNED NO-LABEL
     tt-embarque-imp.cod-despachante AT ROW 2.25 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-despachante AT ROW 2.25 COL 26.72 COLON-ALIGNED NO-LABEL
     cx-via-transporte AT ROW 3.25 COL 16.57 COLON-ALIGNED
     tt-embarque-imp.cod-conhecto-master AT ROW 4.25 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22.43 BY .88
     tt-embarque-imp.cod-conhecto-house AT ROW 5.25 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22.43 BY .88
     tt-embarque-imp.cdn-corretor-cambio-import AT ROW 1.25 COL 61.86 COLON-ALIGNED
          LABEL "Corretor CÉmbio":R31
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     fi-cdn-corretor-cambio-import AT ROW 1.25 COL 71 COLON-ALIGNED NO-LABEL
     tt-embarque-imp.cdn-despa-exter-import AT ROW 2.25 COL 61.86 COLON-ALIGNED
          LABEL "Despachante Exterior":R31
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     fi-cdn-despa-exter-import AT ROW 2.25 COL 71 COLON-ALIGNED NO-LABEL
     tt-embarque-imp.cdn-segurad-import AT ROW 3.25 COL 61.86 COLON-ALIGNED
          LABEL "Seguradora":R25
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     fi-cdn-segurad-import AT ROW 3.25 COL 71 COLON-ALIGNED NO-LABEL
     tt-embarque-imp.cdn-corretor-import AT ROW 4.25 COL 61.86 COLON-ALIGNED
          LABEL "Corretor de Seguro":R23
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     fi-cdn-corretor-import AT ROW 4.25 COL 71 COLON-ALIGNED NO-LABEL
     tt-embarque-imp.cod-incoterm AT ROW 5.25 COL 61.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.58
         SIZE 86.43 BY 7.46
         FONT 1.

DEFINE FRAME fPage3
     tt-embarque-imp.narrativa AT ROW 1.71 COL 10.14 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 72.86 BY 5.79
     "Narrativa:" VIEW-AS TEXT
          SIZE 7 BY .88 AT ROW 1.71 COL 2.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.58
         SIZE 86.43 BY 7.46
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-decla-import-ord T "?" NO-UNDO mgcex decla-import-ord
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-embarque-imp T "?" NO-UNDO mgcex embarque-imp
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
         HEIGHT             = 15.25
         WIDTH              = 90.43
         MAX-HEIGHT         = 16.63
         MAX-WIDTH          = 94.29
         VIRTUAL-HEIGHT     = 16.63
         VIRTUAL-WIDTH      = 94.29
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
  NOT-VISIBLE,                                                          */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON btOrdem IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estabel-nome IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* SETTINGS FOR FILL-IN tt-embarque-imp.cdn-corretor-cambio-import IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-embarque-imp.cdn-corretor-import IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-embarque-imp.cdn-despa-exter-import IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-embarque-imp.cdn-segurad-import IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fi-cdn-corretor-cambio-import IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cdn-corretor-import IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cdn-despa-exter-import IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cdn-segurad-import IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-despachante IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-transportador IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN c-cdn-emitente-saida-div IN FRAME fPage2
   NO-ENABLE                                                            */
ASSIGN 
       c-cdn-emitente-saida-div:HIDDEN IN FRAME fPage2           = TRUE.

/* SETTINGS FOR FILL-IN tt-embarque-imp.declaracao-import IN FRAME fPage2
   EXP-LABEL EXP-HELP                                                   */
ASSIGN 
       fi-cdn-emitente-saida-div:HIDDEN IN FRAME fPage2           = TRUE.

/* SETTINGS FOR FRAME fPage3
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
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
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


&Scoped-define SELF-NAME bt-gtos-aduana
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-gtos-aduana wMaintenance
ON CHOOSE OF bt-gtos-aduana IN FRAME fpage0 /* Sim. Gtos. Aduana */
DO:

    RUN local/arg/ar2047.w (INPUT tt-embarque-imp.cod-estabel:screen-value in frame fPage0,
                            INPUT tt-embarque-imp.embarque:screen-value in frame fPage0).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE.
    assign pcAction = "add".
    disable btOrdem btPedido btFatura btpesoscubagem btImpostos btEmbVeiculo with frame {&frame-name}.
    apply "entry" to tt-embarque-imp.cod-estabel in frame fpage0.    

    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN
        ASSIGN btImpostos:VISIBLE IN FRAME fpage0 = NO.

    IF  i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
        ASSIGN cb-documento-import:HIDDEN     IN FRAME fpage2 = YES.
    END.
    ELSE DO:
        ASSIGN cb-documento-import:HIDDEN     IN FRAME fpage2 = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN cancelRecord IN THIS-PROCEDURE.
    IF AVAIL tt-embarque-imp THEN DO:
        enable btOrdem btPedido btFatura btpesoscubagem btImpostos btRelaciona with frame {&FRAME-NAME}.
        /*IF l-modul-eq THEN*/
        ENABLE btEmbVeiculo with frame {&FRAME-NAME}.
    END.
    assign menu-item miRelaciona:sensitive in menu mbMain = YES.

    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN
        ASSIGN btImpostos:VISIBLE IN FRAME fpage0 = NO.

    IF  i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
        ASSIGN cb-documento-import:HIDDEN     IN FRAME fpage2 = YES.
    END.
    ELSE DO:
        ASSIGN cb-documento-import:HIDDEN     IN FRAME fpage2 = NO.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fpage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord IN THIS-PROCEDURE.
    assign pcAction = "copy".
    disable btOrdem btPedido btFatura btpesoscubagem btImpostos btEmbVeiculo with frame {&FRAME-NAME}.
    apply "entry" to tt-embarque-imp.cod-estabel in frame fpage0. 

    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN
        ASSIGN btImpostos:VISIBLE IN FRAME fpage0 = NO.

    IF  i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
        ASSIGN cb-documento-import:HIDDEN     IN FRAME fpage2 = YES.
    END.
    ELSE DO:
        ASSIGN cb-documento-import:HIDDEN     IN FRAME fpage2 = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:

    RUN findPk_codigo IN {&hDBOTable} (input string(tt-embarque-imp.cod-estabel:screen-value in frame fPage0),
                                       input string(tt-embarque-imp.embarque:screen-value in frame fPage0),
                                       output c-return).
    
    if c-return = "" then do:                                       
        RUN getRowid IN {&hDBOTable} (output r-chave).
        RUN repositionRecord IN THIS-PROCEDURE (input r-chave).                                
    end.
        
    RUN deleteRecord IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEmbVeiculo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEmbVeiculo wMaintenance
ON CHOOSE OF btEmbVeiculo IN FRAME fpage0
DO:
    /*IF NOT VALID-HANDLE(h-eq0502) THEN 
        run eqp/eq0502.w persistent set h-eq0502.
    
    RUN findPk_codigo IN {&hDBOTable} (input tt-embarque-imp.cod-estabel:screen-value in frame fPage0,
                                       input tt-embarque-imp.embarque:screen-value in frame fPage0,
                                       output c-return).
    if c-return = "" THEN                                       
        RUN getRowid IN {&hDBOTable} (output r-chave).
    
    EMPTY TEMP-TABLE tt-selecao-b NO-ERROR.
    CREATE tt-selecao-b.
    ASSIGN tt-selecao-b.l-nao-vinculado  = YES
           tt-selecao-b.cod-estabel-ini  = tt-embarque-imp.cod-estabel:screen-value in frame fPage0
           tt-selecao-b.cod-estabel-fim  = tt-embarque-imp.cod-estabel:screen-value in frame fPage0
           tt-selecao-b.embarque-ini     = tt-embarque-imp.embarque:screen-value    in frame fPage0
           tt-selecao-b.embarque-fim     = tt-embarque-imp.embarque:screen-value    in frame fPage0.

    RUN pi-seta-prog-origem   IN h-eq0502 (INPUT "im0045",
                                           INPUT r-chave).
    RUN pi-recebe-temp-tables IN h-eq0502 (INPUT TABLE tt-selecao-b,
                                           INPUT TABLE tt-eq-grp-embarq-target).
           
    RUN SetaValores IN h-eq0502 (INPUT YES,                         
                                 INPUT YES, 
                                 INPUT YES,
                                 INPUT YES,
                                 INPUT YES,
                                 INPUT 1,   
                                 INPUT tt-embarque-imp.cod-estabel:screen-value in frame fPage0, 
                                 INPUT tt-embarque-imp.cod-estabel:screen-value in frame fPage0, 
                                 INPUT "", 
                                 INPUT "ZZZZZZZZZZZZ", 
                                 INPUT &IF "{&ems_dbtype}":U = "MSS":U &THEN "01/01/1800":U &ELSE "01/01/0001":U &ENDIF,   
                                 INPUT "31/12/9999", 
                                 INPUT "",                                           
                                 INPUT "ZZZZZZZZZZZZ",                               
                                 INPUT "",                                           
                                 INPUT "ZZZZZZZZZZZZ",                               
                                 INPUT 0       ,                                     
                                 INPUT 99999999,                                     
                                 INPUT "",
                                 INPUT "ZZZZZZZZZZZZ",
                                 INPUT 0,                                            
                                 INPUT 999999999.99,                              
                                 INPUT 0,                                            
                                 INPUT 999999999.99, 
                                 INPUT TABLE tt-grp-embarq-selecao-1,    
                                 INPUT TABLE tt-grp-embarq-selecao-2,
                                 INPUT TABLE tt-selecao,
                                 INPUT yes).
    
    {&WINDOW-NAME}:SENSITIVE = NO.
    
    RUN InitializeInterface IN h-eq0502 NO-ERROR.
    IF RETURN-VALUE = "NOK":U THEN DO:
       {&WINDOW-NAME}:SENSITIVE = YES.
       RETURN NO-APPLY.
    END.

    RUN beforeDisplayFields IN h-eq0502 NO-ERROR.

    WAIT-FOR CLOSE OF h-eq0502 FOCUS CURRENT-WINDOW.
    {&WINDOW-NAME}:SENSITIVE = YES.

    IF VALID-HANDLE(h-eq0502) THEN
        DELETE PROCEDURE h-eq0502.
    ASSIGN h-eq0502 = ?.*/
    /*Conforme chamado A24686*/
    RUN findPk_codigo IN h-bocx220 (input string(tt-embarque-imp.cod-estabel:screen-value in frame fPage0),
                                    input string(tt-embarque-imp.embarque:screen-value    in frame fPage0),
                                    output c-return).
    if c-return = "" then do:                                       
        RUN getRowid IN {&hDBOTable} (output r-chave).
        RUN repositionRecord IN THIS-PROCEDURE (input r-chave).                                
    end. 

    RUN findEmbarque IN h-bocx225 (INPUT string(tt-embarque-imp.cod-estabel:screen-value in frame fPage0), 
                                   INPUT string(tt-embarque-imp.embarque:screen-value    in frame fPage0), 
                                   output cErro).

    IF cErro <> "":U THEN DO:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Ordens_Embarque" *}
       RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                          INPUT 2, 
                          INPUT RETURN-VALUE).

       RETURN NO-APPLY.
    END.
    else do:
        RUN imp/im0045h.w ( input string(tt-embarque-imp.cod-estabel:screen-value in frame fPage0), 
                            input string(tt-embarque-imp.embarque:screen-value in frame fPage0)).
    end.
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


&Scoped-define SELF-NAME btFatura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFatura wMaintenance
ON CHOOSE OF btFatura IN FRAME fpage0 /* Fatura */
DO:
    RUN findPk_codigo IN {&hDBOTable} (input string(tt-embarque-imp.cod-estabel:screen-value in frame fPage0),
                                       input string(tt-embarque-imp.embarque:screen-value in frame fPage0),
                                       output c-return).
    if c-return = "" then do:                                       
        RUN getRowid IN {&hDBOTable} (output r-chave).
        RUN repositionRecord IN THIS-PROCEDURE (input r-chave).                                
    end.                                                                                                       
    RUN imp/im0045d.w (input tt-embarque-imp.cod-estabel:screen-value in frame fPage0,
                       input tt-embarque-imp.embarque:screen-value in frame fPage0).
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


&Scoped-define SELF-NAME btimpostos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btimpostos wMaintenance
ON CHOOSE OF btimpostos IN FRAME fpage0 /* Impostos */
do:
    run imp/im0100d.w (input tt-embarque-imp.cod-estabel,
                       input tt-embarque-imp.embarque,
                       input "",
                       input "",
                       input no,
                       INPUT 1,
                       INPUT "").
end.

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


&Scoped-define SELF-NAME btOrdem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOrdem wMaintenance
ON CHOOSE OF btOrdem IN FRAME fpage0 /* Ordem */
DO:        
    RUN findPk_codigo IN {&hDBOTable} (input string(tt-embarque-imp.cod-estabel:screen-value in frame fPage0),
                                       input string(tt-embarque-imp.embarque:screen-value in frame fPage0),
                                       output c-return).
    if c-return = "" then do:                                       
        RUN getRowid IN {&hDBOTable} (output r-chave).
        RUN repositionRecord IN THIS-PROCEDURE (input r-chave).                                
    end.                                                                                                       
    RUN imp/im0045a.w (input string(tt-embarque-imp.cod-estabel:screen-value in frame fPage0), 
                       input string(tt-embarque-imp.embarque:screen-value in frame fPage0)).
    
    RUN piGetFornecedor IN THIS-PROCEDURE.
    RUN getRowid IN {&hDBOTable} (output r-chave).
    RUN repositionRecord IN THIS-PROCEDURE (input r-chave).                                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPedido wMaintenance
ON CHOOSE OF btPedido IN FRAME fpage0 /* Pedido */
DO:
    RUN findPk_codigo IN {&hDBOTable} (input string(tt-embarque-imp.cod-estabel:screen-value in frame fPage0),
                                       input string(tt-embarque-imp.embarque:screen-value in frame fPage0),
                                       output c-return).
    if c-return = "" then do:                                       
        RUN getRowid IN {&hDBOTable} (output r-chave).
        RUN repositionRecord IN THIS-PROCEDURE (input r-chave).                                
    end.                                                                                                       
    RUN imp/im0045c.w (input tt-embarque-imp.cod-estabel:screen-value in frame fPage0,
                       input tt-embarque-imp.embarque:screen-value in frame fPage0).

    RUN piGetFornecedor IN THIS-PROCEDURE.
    RUN getRowid IN {&hDBOTable} (output r-chave).
    RUN repositionRecord IN THIS-PROCEDURE (input r-chave).                                

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btpesoscubagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btpesoscubagem wMaintenance
ON CHOOSE OF btpesoscubagem IN FRAME fpage0 /* Peso e Cubagem */
do:
    run imp/im0100c.w (input tt-embarque-imp.cod-estabel,
                       input tt-embarque-imp.embarque,
                       input "",
                       input "",
                       input no).
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPesosImpostos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPesosImpostos wMaintenance
ON CHOOSE OF btPesosImpostos IN FRAME fpage0 /* Pesos e Impostos */
DO:
    RUN imp/im0100b.w (INPUT tt-embarque-imp.cod-estabel,
                       INPUT tt-embarque-imp.embarque,
                       INPUT "",
                       INPUT "",
                       INPUT NO).
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
        run imp/im0041.w persistent set h-im0041 (input ?, tt-embarque-imp.r-rowid, YES).
    
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

    APPLY 'LEAVE':U TO tt-embarque-imp.embarque.
    
    assign c-cod-estabel = tt-embarque-imp.cod-estabel:screen-value in frame fpage0
           c-embarque    = tt-embarque-imp.embarque:screen-value in frame fpage0.

    RUN pi-trata-combos(INPUT NO).
    /* Tratamento para datas invalidas Ex.: 31/02/2015  */
    assign dt-data-aux = input frame fPage2 tt-embarque-imp.data-di no-error.
    if error-status:error then do:
        apply 'leave':U to tt-embarque-imp.data-di.
        return no-apply.
    end.

    /*Caso a funá∆o do IFRIC esteja ativa e o despachante n∆o tenha sido informado 
    avisa o usu†rio que a informaá∆o ser† utilizada na vinculaá∆o das antecipaá‰es*/
    IF l-funcao-ifric THEN DO:
        RUN piValidaDespachanteIFRIC IN h-bocx220 (INPUT c-cod-estabel,
                                                   INPUT c-embarque,
                                                   INPUT input frame fPage1 tt-embarque-imp.cod-despachante,
                                                   OUTPUT TABLE RowErrors).
        if  can-find(first RowErrors) then do:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal=YES}
        end.
        IF  CAN-FIND(FIRST rowErrors 
                     WHERE rowErrors.errorSubType = "Error":U) THEN
            return no-apply.
    END.


    RUN saveRecord IN THIS-PROCEDURE.

    if return-value = "OK":U then do: 
        IF AVAIL tt-embarque-imp THEN
            ENABLE btRelaciona WITH FRAME {&FRAME-NAME}.
        assign menu-item miRelaciona:sensitive in menu mbMain = YES.
        IF (pcaction = "ADD" OR pcaction = "UPDATE") THEN DO:
            find first rowerrors no-error.
            if not avail rowerrors then do:
               run findCh_embarque in h-bocx220 (input c-cod-estabel, input c-embarque, output c-return). 
               IF pcaction = "ADD" THEN DO:
                  apply "choose":U to btCancel in frame fpage0.
                  apply "choose":U to btOrdem  in frame fpage0.
               END.
               IF pcaction = "UPDATE" THEN
                   IF AVAIL tt-embarque-imp THEN DO:
                       enable btOrdem btPedido btFatura btpesoscubagem btImpostos with frame {&FRAME-NAME}.
                       /*IF l-modul-eq THEN*/
                           ENABLE btEmbVeiculo with frame {&FRAME-NAME}.
                   END.
            end.
        END.
        IF (pcaction = "COPY") THEN DO:
            IF AVAIL tt-embarque-imp /*AND l-modul-eq*/ THEN
                ENABLE btEmbVeiculo with frame {&FRAME-NAME}.
        END.
    end.

    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN
        ASSIGN btImpostos:VISIBLE IN FRAME fpage0 = NO.

    IF  i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
        ASSIGN cb-documento-import:HIDDEN     IN FRAME fpage2 = YES.
    END.
    ELSE DO:
        ASSIGN cb-documento-import:HIDDEN     IN FRAME fpage2 = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="cxzoom/z10cx220.w"}
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
    assign pcAction = "update".
    RUN updateRecord IN THIS-PROCEDURE.
    disable btOrdem btPedido btFatura btpesoscubagem btimpostos btEmbVeiculo with frame {&FRAME-NAME}.

    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN
        ASSIGN btImpostos:VISIBLE IN FRAME fpage0 = NO.

    IF  i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
        ASSIGN cb-documento-import:HIDDEN     IN FRAME fpage2 = YES.
    END.
    ELSE DO:
        ASSIGN cb-documento-import:HIDDEN     IN FRAME fpage2 = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-embarque-imp.cdn-corretor-cambio-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cdn-corretor-cambio-import wMaintenance
ON F5 OF tt-embarque-imp.cdn-corretor-cambio-import IN FRAME fPage1 /* Corretor CÉmbio */
DO:
   {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="tt-embarque-imp.cdn-corretor-cambio-import"
     &campozoom="cod-emitente"
     &frame="fPage1"
     &campo2="fi-cdn-corretor-cambio-import"
     &campozoom2="nome-abrev"
     &frame2="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cdn-corretor-cambio-import wMaintenance
ON LEAVE OF tt-embarque-imp.cdn-corretor-cambio-import IN FRAME fPage1 /* Corretor CÉmbio */
DO:
    if  valid-handle(h-boad098)
    and input frame fPage1 tt-embarque-imp.cdn-corretor-cambio-import <> 0 then do:

        run findCodigo in h-boad098 (input input frame fpage1 tt-embarque-imp.cdn-corretor-cambio-import, output c-return).
        if c-return = "" then do:
            run getcharfield in h-boad098 (input "nome-abrev", output c-descricao).
            assign fi-cdn-corretor-cambio-import:screen-value in frame fpage1 = c-descricao.
        end.
        else assign fi-cdn-corretor-cambio-import:screen-value in frame fpage1 = ''.
    end.
    else
        assign fi-cdn-corretor-cambio-import:screen-value in frame fpage1 = ''.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cdn-corretor-cambio-import wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-embarque-imp.cdn-corretor-cambio-import IN FRAME fPage1 /* Corretor CÉmbio */
DO:
  apply "F5":U to self in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-embarque-imp.cdn-corretor-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cdn-corretor-import wMaintenance
ON F5 OF tt-embarque-imp.cdn-corretor-import IN FRAME fPage1 /* Corretor de Seguro */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="tt-embarque-imp.cdn-corretor-import"
     &campozoom="cod-emitente"
     &frame="fPage1"
     &campo2="fi-cdn-corretor-import"
     &campozoom2="nome-abrev"
     &frame2="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cdn-corretor-import wMaintenance
ON LEAVE OF tt-embarque-imp.cdn-corretor-import IN FRAME fPage1 /* Corretor de Seguro */
DO:
  if  valid-handle(h-boad098)
  and input frame fPage1 tt-embarque-imp.cdn-corretor-import <> 0 then do:
     run findCodigo in h-boad098 (input input frame fpage1 tt-embarque-imp.cdn-corretor-import, output c-return).
     if c-return = "" then do:
        run getcharfield in h-boad098 (input "nome-abrev", output c-descricao).
        assign fi-cdn-corretor-import:screen-value in frame fpage1 = c-descricao.
     end.
     else assign fi-cdn-corretor-import:screen-value in frame fpage1 = ''.
  end.
  else assign fi-cdn-corretor-import:screen-value in frame fpage1 = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cdn-corretor-import wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-embarque-imp.cdn-corretor-import IN FRAME fPage1 /* Corretor de Seguro */
DO:
  apply "F5":U to self in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-embarque-imp.cdn-despa-exter-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cdn-despa-exter-import wMaintenance
ON F5 OF tt-embarque-imp.cdn-despa-exter-import IN FRAME fPage1 /* Despachante Exterior */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="tt-embarque-imp.cdn-despa-exter-import"
     &campozoom="cod-emitente"
     &frame="fPage1"
     &campo2="fi-cdn-despa-exter-import"
     &campozoom2="nome-abrev"
     &frame2="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cdn-despa-exter-import wMaintenance
ON LEAVE OF tt-embarque-imp.cdn-despa-exter-import IN FRAME fPage1 /* Despachante Exterior */
DO:
   if  valid-handle(h-boad098)
   and input frame fPage1 tt-embarque-imp.cdn-despa-exter-import <> 0 then do:

      run findCodigo in h-boad098 (input input frame fpage1 tt-embarque-imp.cdn-despa-exter-import, output c-return).
      if c-return = "" then do:
          run getcharfield in h-boad098 (input "nome-abrev", output c-descricao).
          assign fi-cdn-despa-exter-import:screen-value in frame fpage1 = c-descricao.
      end.
      else assign fi-cdn-despa-exter-import:screen-value in frame fpage1 = ''.
   end.
   else assign fi-cdn-despa-exter-import:screen-value in frame fpage1 = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cdn-despa-exter-import wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-embarque-imp.cdn-despa-exter-import IN FRAME fPage1 /* Despachante Exterior */
DO:
  apply "F5":U to self in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-embarque-imp.cdn-segurad-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cdn-segurad-import wMaintenance
ON F5 OF tt-embarque-imp.cdn-segurad-import IN FRAME fPage1 /* Seguradora */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="tt-embarque-imp.cdn-segurad-import"
     &campozoom="cod-emitente"
     &frame="fPage1"
     &campo2="fi-cdn-segurad-import"
     &campozoom2="nome-abrev"
     &frame2="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cdn-segurad-import wMaintenance
ON LEAVE OF tt-embarque-imp.cdn-segurad-import IN FRAME fPage1 /* Seguradora */
DO:
  if  valid-handle(h-boad098)
  and input frame fPage1  tt-embarque-imp.cdn-segurad-import <> 0 then do:
     run findCodigo in h-boad098 (input input frame fpage1 tt-embarque-imp.cdn-segurad-import, output c-return).
     if c-return = "" then do:
        run getcharfield in h-boad098 (input "nome-abrev", output c-descricao).
        assign fi-cdn-segurad-import:screen-value in frame fpage1 = c-descricao.
     end.
     else assign fi-cdn-segurad-import:screen-value in frame fpage1 = ''.
  end.
  else assign fi-cdn-segurad-import:screen-value in frame fpage1 = ''.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cdn-segurad-import wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-embarque-imp.cdn-segurad-import IN FRAME fPage1 /* Seguradora */
DO:
  apply "F5":U to self in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tt-embarque-imp.cod-banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cod-banco wMaintenance
ON F5 OF tt-embarque-imp.cod-banco IN FRAME fPage2 /* Banco */
DO:
  {method/zoomfields.i 
     &ProgramZoom="adzoom/z10ad018.w"
     &FieldZoom1="cod-banco"
     &FieldScreen1="tt-embarque-imp.cod-banco"
     &Frame1="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cod-banco wMaintenance
ON LEAVE OF tt-embarque-imp.cod-banco IN FRAME fPage2 /* Banco */
DO:
      {method/referencefields.i 
      &HandleDBOLeave="h-boad018"
      &FindMethod="findCod_banco"
      &KeyValue1="integer(tt-embarque-imp.cod-banco:SCREEN-VALUE IN FRAME fPage2)"
      &FieldName1="nome-banco"
      &FieldScreen1="c-nome-banco"
      &Frame1="fPage2"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cod-banco wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-embarque-imp.cod-banco IN FRAME fPage2 /* Banco */
DO:
  apply "F5":U to self in frame fPage1.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-embarque-imp.cod-despachante
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cod-despachante wMaintenance
ON F5 OF tt-embarque-imp.cod-despachante IN FRAME fPage1 /* C¢digo Despachante */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="tt-embarque-imp.cod-despachante"
     &campozoom="cod-emitente"
     &frame="fPage1"
     &campo2="fi-despachante"
     &campozoom2="nome-abrev"
     &frame2="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cod-despachante wMaintenance
ON LEAVE OF tt-embarque-imp.cod-despachante IN FRAME fPage1 /* C¢digo Despachante */
DO:
    if  valid-handle(h-boad098)
    and avail tt-embarque-imp
    and input frame fPage1 tt-embarque-imp.cod-despachante <> 0 then do:
        run findCodigo in h-boad098 (input input frame fpage1 tt-embarque-imp.cod-despachante, output c-return).
        if  c-return = "" then do:
            run getcharfield in h-boad098 (input "nome-abrev", output c-descricao).
            assign fi-despachante:screen-value in frame fpage1 = c-descricao.
        end.
        else
            assign fi-despachante:screen-value in frame fpage1 = ''.
    end.
    else
        assign fi-despachante:screen-value in frame fpage1 = ''.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cod-despachante wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-embarque-imp.cod-despachante IN FRAME fPage1 /* C¢digo Despachante */
DO:
     apply "F5":U to self in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME tt-embarque-imp.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cod-estabel wMaintenance
ON F5 OF tt-embarque-imp.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    {method/zoomfields.i 
     &ProgramZoom="adzoom/z10ad107.w"
     &FieldZoom1="cod-estabel"
     &FieldScreen1="tt-embarque-imp.cod-estabel"
     &FieldZoom2="nome"
     &FieldScreen2="fi-estabel-nome"
     &Frame1="fPage0"
     &Frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cod-estabel wMaintenance
ON LEAVE OF tt-embarque-imp.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    
    if valid-handle(h-boad107) then do:
        run gotokey in h-boad107 (input input frame fpage0 tt-embarque-imp.cod-estabel).
        IF RETURN-VALUE = "OK":U THEN
            run getcharfield in h-boad107 (input "nome", output c-desc-estabel).
        ELSE
            ASSIGN c-desc-estabel = "".    
    end.
    assign fi-estabel-nome:screen-value in frame fpage0 = c-desc-estabel.

    run adbo/boad355.p persistent set h-boad355.
    run pi-verificar-produto in h-boad355 (output v-pagar, output v-receber).
    delete procedure h-boad355.

    /* Integraá∆o Modulo Importaá∆o */
    run inbo/boin682.p persistent set h-boin682.
    run openQueryStatic in h-boin682 ("Main").
    run getFirst in h-boin682.
    run getLogField in h-boin682 (input "modulo-mec", output l-modulo-mec).
    delete procedure h-boin682.
    assign h-boin682 = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cod-estabel wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-embarque-imp.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  apply "F5":U to self in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-embarque-imp.cod-incoterm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cod-incoterm wMaintenance
ON F5 OF tt-embarque-imp.cod-incoterm IN FRAME fPage1 /* Incoterm */
DO:
     {method/zoomfields.i 
     &ProgramZoom="cxzoom/z10cx025.w"
     &FieldZoom1="cod-incoterm"
     &FieldScreen1="tt-embarque-imp.cod-incoterm"
     &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cod-incoterm wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-embarque-imp.cod-incoterm IN FRAME fPage1 /* Incoterm */
DO:
  apply "F5":U to self in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-embarque-imp.cod-transportador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cod-transportador wMaintenance
ON F5 OF tt-embarque-imp.cod-transportador IN FRAME fPage1 /* C¢digo Transportador */
DO:
  {method/zoomfields.i 
     &ProgramZoom="adzoom/z10ad268.w"
     &FieldZoom1="cod-transp"
     &FieldScreen1="tt-embarque-imp.cod-transportador"
     &FRAME1="fPage1"
     &FieldZoom2="nome"
     &FieldScreen2="fi-transportador"
     &FRAME2="fPage1"}
     

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cod-transportador wMaintenance
ON LEAVE OF tt-embarque-imp.cod-transportador IN FRAME fPage1 /* C¢digo Transportador */
DO:
    if  avail tt-embarque-imp
    and input frame fPage1 tt-embarque-imp.cod-transportador <> 0 then do:
        if  valid-handle(h-boad268) then do:
            run gotokey in h-boad268 (input input frame fpage1 tt-embarque-imp.cod-transportador).
            if return-value = "OK":U then do:
                run getcharfield in h-boad268 (input "nome-abrev", output c-descricao).
                assign fi-transportador:screen-value in frame fpage1 = c-descricao.
            end.
            else assign fi-transportador:screen-value in frame fpage1 = ''.
        end.
    end.
    else
        assign fi-transportador:screen-value in frame fpage1 = ''.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cod-transportador wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-embarque-imp.cod-transportador IN FRAME fPage1 /* C¢digo Transportador */
DO:
  apply "F5":U to self in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tt-embarque-imp.declaracao-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.declaracao-import wMaintenance
ON LEAVE OF tt-embarque-imp.declaracao-import IN FRAME fPage2 /* DI Siscomex */
DO:
    /* retirado temporariamente pois ocasionava erro */
    /*IF  REPLACE(REPLACE(tt-embarque-imp.declaracao-import:SCREEN-VALUE IN FRAME fPage2,"/",""),"-","") <> "" 
    THEN ASSIGN tt-embarque-imp.declaracao-import:FORMAT IN FRAME fPage2 = "99/9999999-9".
    ELSE ASSIGN tt-embarque-imp.declaracao-import:FORMAT IN FRAME fPage2 = "X(20)".*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME tt-embarque-imp.embarque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.embarque wMaintenance
ON LEAVE OF tt-embarque-imp.embarque IN FRAME fpage0 /* Embarque */
DO:
    ASSIGN tt-embarque-imp.embarque:screen-value in frame fpage0 = TRIM(tt-embarque-imp.embarque:screen-value in frame fpage0).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME fi-cdn-emitente-saida-div
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cdn-emitente-saida-div wMaintenance
ON F5 OF fi-cdn-emitente-saida-div IN FRAME fPage2 /* Fornecedor ISD */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="fi-cdn-emitente-saida-div"
     &campozoom="cod-emitente"
     &frame="fPage2"
     &campo2="c-cdn-emitente-saida-div"
     &campozoom2="nome-abrev"
     &frame2="fPage2"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cdn-emitente-saida-div wMaintenance
ON LEAVE OF fi-cdn-emitente-saida-div IN FRAME fPage2 /* Fornecedor ISD */
DO:
  if  valid-handle(h-boad098)
  and input frame fPage2 fi-cdn-emitente-saida-div <> 0 then do:
     run findCodigo in h-boad098 (input input frame fpage2 fi-cdn-emitente-saida-div, output c-cdn-emitente-saida-div).
     if c-cdn-emitente-saida-div = "" then do:
        run getcharfield in h-boad098 (input "nome-abrev", output c-cdn-emitente-saida-div).
        assign c-cdn-emitente-saida-div:screen-value in frame fpage2 = c-cdn-emitente-saida-div.
     end.
     else assign c-cdn-emitente-saida-div:screen-value in frame fpage2 = ''.
  end.
  else assign c-cdn-emitente-saida-div:screen-value in frame fpage2 = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cdn-emitente-saida-div wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-cdn-emitente-saida-div IN FRAME fPage2 /* Fornecedor ISD */
DO:
  APPLY "F5":U TO SELF IN FRAME fPage2.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME i-cod-fornecedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-fornecedor wMaintenance
ON LEAVE OF i-cod-fornecedor IN FRAME fPage1 /* C¢digo Fornecedor */
DO:
     {method/ReferenceFields.i
      &HandleDBOLeave="h-boad098"
      &FindMethod="findCodigo"
      &KeyValue1="integer(i-cod-fornecedor:SCREEN-VALUE IN FRAME fPage1)"
      &FieldName1="nome-emit"
      &FieldScreen1="c-desc-fornecedor"
      &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/* ***************************  Main Block  *************************** */
    
    
/*--- L¢gica para inicializaá∆o do programam ---*/
  tt-embarque-imp.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage0.
  tt-embarque-imp.cod-transportador:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage1.
  tt-embarque-imp.cod-despachante:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage1.    
  tt-embarque-imp.cdn-corretor-cambio-import:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage1.
  tt-embarque-imp.cdn-despa-exter-import:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage1.
  tt-embarque-imp.cdn-segurad-import:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage1.
  tt-embarque-imp.cdn-corretor-import:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage1.
  tt-embarque-imp.cod-incoterm:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage1.
  tt-embarque-imp.cod-banco:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage2.
  IF i-pais-impto-usuario = 21 THEN
      fi-cdn-emitente-saida-div:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
        IN FRAME fPage2.

  &if "{&ems_dbtype}" <> "progress":U &then
      ASSIGN tt-embarque-imp.narrativa:MAX-CHARS IN FRAME fPage3 = 2000.
  &else
      ASSIGN tt-embarque-imp.narrativa:MAX-CHARS IN FRAME fPage3 = 31000.
  &endif
  
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
IF VALID-HANDLE(h-boad018) THEN DO:
    DELETE PROCEDURE h-boad018.
    ASSIGN h-boad018 = ?.
END.

IF VALID-HANDLE(h-boad355) THEN DO:
    DELETE PROCEDURE h-boad355.
    ASSIGN h-boad355 = ?.
END.

IF VALID-HANDLE(h-boad098) THEN DO:
    DELETE PROCEDURE h-boad098.
    ASSIGN h-boad098 = ?.
END.

IF VALID-HANDLE(h-boad268) THEN DO:
    DELETE PROCEDURE h-boad268.
    ASSIGN h-boad268 = ?.
END.

IF VALID-HANDLE(h-boin682) THEN DO:
    DELETE PROCEDURE h-boin682.
    ASSIGN h-boin682 = ?.
END.

IF VALID-HANDLE(h-boin274) THEN DO:
    DELETE PROCEDURE h-boin274.
    ASSIGN h-boin274 = ?.
END.

IF VALID-HANDLE(h-bocx407) THEN DO:
    DELETE PROCEDURE h-bocx407.
    ASSIGN h-bocx407 = ?.
END.

IF VALID-HANDLE(h-bocx402) THEN DO:
    DELETE PROCEDURE h-bocx402.
    ASSIGN h-bocx402 = ?.
END.

IF VALID-HANDLE(h-bocx404) THEN DO:
    DELETE PROCEDURE h-bocx404.
    ASSIGN h-bocx404 = ?.
END.

IF VALID-HANDLE(h-bocx225) THEN DO:
    DELETE PROCEDURE h-bocx225.
    ASSIGN h-bocx225 = ?.
END.

IF VALID-HANDLE(h-bocx00477) THEN DO:
    DELETE PROCEDURE h-bocx00477.
    ASSIGN h-bocx00477 = ?.
END.

IF l-funcao-ifric THEN DO:
    {method/showmessage.i3}
END.

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
    DISABLE cb-natureza-cambial fi-num-di-ems cb-documento-import WITH FRAME fPage2.

    IF i-pais-impto-usuario = 21 /* Equador */ THEN DO:
        DISABLE fi-cdn-emitente-saida-div WITH FRAME fPage2.
        DISABLE c-cdn-emitente-saida-div WITH FRAME fPage2.
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
    if avail tt-embarque-imp AND tt-embarque-imp.cod-via-transp <> 0 then DO:
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao001 = {adinc/i01ad268.i 04 tt-embarque-imp.cod-via-transp}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN cx-via-transporte:SCREEN-VALUE    in frame fPage1        = STRING({adinc/i01ad268.i 06 cAuxTraducao001}).
        &else
            DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao001 = {adinc/i01ad268.i 04 tt-embarque-imp.cod-via-transp}.
            ASSIGN cx-via-transporte:SCREEN-VALUE    in frame fPage1        = STRING({adinc/i01ad268.i 06 cAuxTraducao001}).
        &endif
    END.

    DISABLE btEmbVeiculo WITH FRAME fPage0.

    IF NOT AVAIL tt-embarque-imp THEN DO:

        DISABLE btrelaciona
                btembveiculo
                btordem
                btpedido
                btfatura
                btpesoscubagem
                btimpostos
                WITH FRAME fpage0.
    END.
    ELSE 
    
        ENABLE btrelaciona
                btembveiculo
                btordem
                btpedido
                btfatura
                btpesoscubagem
                btimpostos
                WITH FRAME fpage0.
        
    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN
        ASSIGN btImpostos:VISIBLE IN FRAME fpage0 = NO.

    IF  i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
        ASSIGN cb-documento-import:HIDDEN     IN FRAME fpage2 = YES.
    END.
    ELSE DO:
        ASSIGN cb-documento-import:HIDDEN     IN FRAME fpage2 = NO.
    END.
        
    IF AVAIL tt-embarque-imp THEN DO:
        /*--- Conforme IPP1 - Projeto 79 [ Vis∆o DI ] --------------------------*/
        &if '{&bf_mat_versao_ems}' >= '2.09' &then
        ASSIGN fi-num-di-ems:SCREEN-VALUE IN FRAME fPage2 = string(tt-embarque-imp.num-di-ems).
        &else
        ASSIGN fi-num-di-ems:SCREEN-VALUE IN FRAME fPage2 = string(tt-embarque-imp.int-2).
        &endif
        /*----------------------------------------------------------------------*/


        IF  tt-embarque-imp.situacao = 2 /* Encerrado */ THEN DO:
            DISABLE btUpdate
                    btDelete
                WITH FRAME fPage0.

            ASSIGN MENU-ITEM miUpdate:SENSITIVE IN MENU mbMain = NO
                   MENU-ITEM miDelete:SENSITIVE IN MENU mbMain = NO.
        END.
        ELSE DO:
            ENABLE btUpdate
                   btDelete
                WITH FRAME fPage0.

            ASSIGN MENU-ITEM miUpdate:SENSITIVE IN MENU mbMain = YES
                   MENU-ITEM miDelete:SENSITIVE IN MENU mbMain = YES.
        END.
    END. 

    IF i-pais-impto-usuario = 21 /* Equador */ THEN DO:
        ASSIGN fi-cdn-emitente-saida-div:HIDDEN IN FRAME fPage2 = NO
               fi-cdn-emitente-saida-div                        = 0
               c-cdn-emitente-saida-div:HIDDEN IN FRAME fPage2  = NO.

        RUN goToKey IN h-bocx00477 (INPUT tt-embarque-imp.cod-estabel, INPUT tt-embarque-imp.embarque).
        IF RETURN-VALUE = "OK":U THEN
            RUN getIntField IN h-bocx00477 (INPUT "cdn-emitente-saida-div", OUTPUT fi-cdn-emitente-saida-div).

        ASSIGN fi-cdn-emitente-saida-div:SCREEN-VALUE IN FRAME fPage2 = STRING(fi-cdn-emitente-saida-div).

        APPLY 'LEAVE' TO fi-cdn-emitente-saida-div IN FRAME fPage2.
    END.
    
    apply "leave" to tt-embarque-imp.cod-banco in frame fPage2.
    apply "leave" to tt-embarque-imp.cod-estabel in frame fPage0.
    apply "leave" to tt-embarque-imp.cod-transportador in frame fPage1.
    apply "leave" to tt-embarque-imp.cod-despachante in frame fPage1.
    apply "leave" to tt-embarque-imp.cdn-corretor-cambio-import in frame fPage1.
    apply "leave" to tt-embarque-imp.cdn-despa-exter-import in frame fPage1.
    apply "leave" to tt-embarque-imp.cdn-segurad-import in frame fPage1.
    apply "leave" to tt-embarque-imp.cdn-corretor-import in frame fPage1.

    RUN piGetFornecedor IN THIS-PROCEDURE.

    RUN pi-trata-combos(INPUT YES).

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
    /*--- Conforme IPP1 - Projeto 79 [ Vis∆o DI ] ---------------------------------------------------------*/
    /*---[ Caso tenham conte£do, indica que tem relacionamento ]-------------------------------------------*/

    IF VALID-HANDLE(h-bocx407) THEN DELETE PROCEDURE h-bocx407.
    RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.

    RUN buscaEmbRelac IN h-bocx407 (INPUT tt-embarque-imp.embarque, 
                                    INPUT tt-embarque-imp.cod-estabel,
                                    OUTPUT l-habilita).

    IF l-habilita THEN 
        ENABLE  tt-embarque-imp.declaracao-import tt-embarque-imp.data-DI WITH FRAME fPage2.
    ELSE DO: 
        IF cAction <> "COPY":U THEN
            DISABLE tt-embarque-imp.declaracao-import fi-num-di-ems tt-embarque-imp.data-DI WITH FRAME fPage2.
    END.
    /*-----------------------------------------------------------------------------------------------------*/

    enable btOrdem btPedido btFatura with frame fPage0.
    /*Funá∆o n∆o implementada*/
    IF AVAIL tt-embarque-imp /*AND l-modul-eq*/ THEN
        ENABLE btEmbVeiculo with frame fPage0.
    disable c-nome-banco with frame fPage2.
    IF cAction = "ADD":U OR cAction = "COPY":U OR cAction = "UPDATE":U THEN DO:
            DISABLE btRelaciona WITH FRAME {&FRAME-NAME}.
            assign menu-item miRelaciona:sensitive in menu mbMain = NO.
    END.
    IF cAction = "ADD":U or cAction = "COPY":U THEN DO:
       DISABLE btOrdem btPedido btFatura btEmbVeiculo WITH FRAME fPage0.
       ASSIGN fi-num-di-ems:SCREEN-VALUE IN FRAME fPage2                     = "0"
              tt-embarque-imp.declaracao-import:SCREEN-VALUE IN FRAME fPage2 = ""
              tt-embarque-imp.data-di:SCREEN-VALUE IN FRAME fPage2           = "".
    END.

    ENABLE cb-natureza-cambial cb-documento-import
        WITH FRAME fPage2.

    IF pcAction = "UPDATE":U THEN DO:
        RUN verificaRelacAdicItens IN h-bocx402(INPUT tt-embarque-imp.embarque,
                                                INPUT tt-embarque-imp.cod-estabel,
                                                OUTPUT l-encontrou-adic-itens).
        IF l-encontrou-adic-itens THEN
            DISABLE cb-natureza-cambial cb-documento-import WITH FRAME fPage2.
    END.

    IF i-pais-impto-usuario = 21 /* Equador */ THEN DO:
        ENABLE fi-cdn-emitente-saida-div WITH FRAME fPage2.        
    END.
    
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
/*assign c-nr-conhecimento:format in frame fPage1 = "x(15)".*/

    FIND FIRST param-global NO-LOCK NO-ERROR.
    IF AVAIL param-global AND param-global.log-modul-eq = yes THEN
        ASSIGN l-modul-eq = YES.


    IF AVAIL tt-embarque-imp THEN
        enable btrelaciona with frame {&FRAME-NAME}.

    ASSIGN btAdd:COL IN FRAME fPage0 = 25.86 
           btCopy:COL IN FRAME fPage0 = 30 
           btUpdate:COL IN FRAME fPage0 = 34 
           btDelete:COL IN FRAME fPage0 = 38 
           btUndo:COL IN FRAME fPage0 = 42 
           btCancel:COL IN FRAME fPage0 = 46 
           btSave:COL IN FRAME fPage0 = 50 
           btFirst:COL IN FRAME fPage0 = 1.72 
           btPrev:COL IN FRAME fPage0 = 5.72 
           btNext:COL IN FRAME fPage0 = 9.72 
           btLast:COL IN FRAME fPage0 = 13.72 
           btGoTo:COL IN FRAME fPage0 = 17.72 
           btSearch:COL IN FRAME fPage0 = 21.72
           BtRelaciona:COL IN FRAME fPage0 = 54.57
           btOrdem:COL IN FRAME fPage0 = 62.43 
           btPedido:COL IN FRAME fPage0 = 66.43 
           btFatura:COL IN FRAME fPage0 = 70.43 
           btQueryJoins:COL IN FRAME fPage0 = 74.86 
           btReportsJoins:COL IN FRAME fPage0 = 78.86 
           btExit:COL IN FRAME fPage0 = 82.86
           btHelp:COL IN FRAME fPage0 = 86.86.

    ASSIGN gl-im0044 = NO.
    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
        ASSIGN btImpostos:VISIBLE     IN FRAME fpage0 = NO
               bt-gtos-aduana:VISIBLE IN FRAME fpage0 = YES.
        ENABLE bt-gtos-aduana WITH FRAME fPage0.
    END.
    ELSE DO:
        ASSIGN btimpostos:VISIBLE     IN FRAME fpage0 = YES
               bt-gtos-aduana:VISIBLE IN FRAME fpage0 = NO.
    END.
    
    IF  i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
        ASSIGN cb-documento-import:HIDDEN     IN FRAME fpage2 = YES.
    END.
    ELSE DO:
        ASSIGN cb-documento-import:HIDDEN     IN FRAME fpage2 = NO.
    END.

    assign btpesoscubagem:visible  in frame fpage0 = true
           btPesosImpostos:visible in frame fpage0 = false.
    


    run adbo/boad355.p persistent set h-boad355.
    run pi-verificar-produto in h-boad355 (output v-pagar, output v-receber).
    delete procedure h-boad355.

    /* Integraá∆o Modulo Importaá∆o */
    run inbo/boin682.p persistent set h-boin682.
    run openQueryStatic in h-boin682 ("Main").
    run getFirst in h-boin682.
    run getLogField in h-boin682 (input "modulo-mec", output l-modulo-mec).
    delete procedure h-boin682.
    assign h-boin682 = ?.

    if  v-pagar <> "EMS 5" or
        v-receber <> "EMS 5" or
        not l-modulo-mec then do:
        RUN setfolder    IN hFolder (INPUT 1).
    end.

   
    /* Conforme FO 1516.901, o bot∆o "btEmbVe°culo" foi desabilitado
    atÇ que seja conclu°do o desenvolvimento da funcionalidade do m¢dulo de Embarques(Eq)
    a partir da 206B*/

    /*IF AVAIL tt-embarque-imp AND l-modul-eq THEN
        ENABLE btEmbVeiculo WITH FRAME fPage0.
    ELSE
        ASSIGN btEmbVeiculo:HIDDEN  IN FRAME fPage0 = YES
               btEmbVeiculo:TOOLTIP IN FRAME fPage0 = "".*/

    /*Conforme chamado A24686*/
    IF AVAIL tt-embarque-imp THEN
        ENABLE btEmbVeiculo WITH FRAME fPage0.
    
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
    if  avail tt-embarque-imp then do:
        assign tt-embarque-imp.cod-via-transp    = int(cx-via-transporte:SCREEN-VALUE IN FRAME fpage1)
               /* n∆o copia as posiá‰es referentes ao ve°culo de transporte */
               substr(tt-embarque-imp.char-1,1,20) = fill(" ",20).
       
          if cAction = "COPY" then               
           assign tt-embarque-imp.situacao          = 1
                  tt-embarque-imp.contabilizado     = no.

        /*--- Conforme IPP1 - Projeto 79 [ Vis∆o DI ] --------------------------*/
          &if '{&bf_mat_versao_ems}' >= '2.09' &then
          ASSIGN tt-embarque-imp.num-di-ems = INPUT FRAME fPage2 fi-num-di-ems.
          &else
          ASSIGN tt-embarque-imp.int-2 = INPUT FRAME fPage2 fi-num-di-ems.
          &endif
        /*----------------------------------------------------------------------*/
    end. /* if  avail tt-embarque-imp */
    
    run adbo/boad355.p persistent set h-boad355.
    run pi-verificar-produto in h-boad355 (output v-pagar, output v-receber).
    delete procedure h-boad355.
    
/* Integraá∆o Modulo Importaá∆o */
    run inbo/boin682.p persistent set h-boin682.
    run openQueryStatic in h-boin682 ("Main").
    run getFirst in h-boin682.
    run getLogField in h-boin682 (input "modulo-mec", output l-modulo-mec).
    delete procedure h-boin682.
    assign h-boin682 = ?.

    RUN pi-atualiza-pagto-ordens IN h-bocx404(INPUT tt-embarque-imp.embarque,
                                              INPUT tt-embarque-imp.cod-estabel,
                                              INPUT &if '{&bf_mat_versao_ems}' >= '2.09' &then tt-embarque-imp.idi-natur-cambial &else tt-embarque-imp.int-1 &endif).

    RUN pi-atualiza-pagamento-ord IN THIS-PROCEDURE (INPUT tt-embarque-imp.cod-estabel,
                                                     INPUT tt-embarque-imp.embarque,
                                                     INPUT &if '{&bf_mat_versao_ems}' >= '2.09' &then tt-embarque-imp.idi-natur-cambial &else tt-embarque-imp.int-1 &endif).

    IF i-pais-impto-usuario= 21 /* Equador */ THEN DO:
        ASSIGN fi-cdn-emitente-saida-div = INT(fi-cdn-emitente-saida-div:SCREEN-VALUE IN FRAME fPage2).

        EMPTY TEMP-TABLE tt-embarq-imp-internac.
        EMPTY TEMP-TABLE RowErrors.

        RUN goToKey IN h-bocx00477 (INPUT tt-embarque-imp.cod-estabel, INPUT tt-embarque-imp.embarque).
        IF RETURN-VALUE = "OK":U THEN
            RUN getRecord IN h-bocx00477 (OUTPUT TABLE tt-embarq-imp-internac).

        RUN emptyRowErrors IN h-bocx00477.

        FIND FIRST tt-embarq-imp-internac NO-LOCK
             WHERE tt-embarq-imp-internac.cod-estabel = tt-embarque-imp.cod-estabel
               AND tt-embarq-imp-internac.embarque    = tt-embarque-imp.embarque NO-ERROR.

        IF NOT AVAIL tt-embarq-imp-internac THEN DO:
            CREATE tt-embarq-imp-internac.
            ASSIGN tt-embarq-imp-internac.cod-estabel            = tt-embarque-imp.cod-estabel
                   tt-embarq-imp-internac.embarque               = tt-embarque-imp.embarque
                   tt-embarq-imp-internac.cdn-emitente-saida-div = fi-cdn-emitente-saida-div.

            RUN emptyRowErrors IN h-bocx00477.
            RUN setRecord IN h-bocx00477 (INPUT TABLE tt-embarq-imp-internac).
            RUN createRecord IN h-bocx00477.
        END.
        ELSE DO:
            ASSIGN tt-embarq-imp-internac.cdn-emitente-saida-div = fi-cdn-emitente-saida-div.

            RUN emptyRowErrors IN h-bocx00477.
            RUN setRecord IN h-bocx00477 (INPUT TABLE tt-embarq-imp-internac).
            RUN updateRecord IN h-bocx00477.
        END.

        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN h-bocx00477 (OUTPUT TABLE RowErrors).
            {method/showmessage.i1}
            /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
            {method/showmessage.i2}
            RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroyInterface wMaintenance 
PROCEDURE beforeDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if valid-handle(h-boad107) then
        DELETE PROCEDURE h-boad107.
    ASSIGN h-boad107 = ?.
    
    if valid-handle(h-boad098) then
        delete procedure h-boad098.
    ASSIGN h-boad098 = ?.

    if valid-handle(h-boad268) then
        DELETE PROCEDURE h-boad268.
    ASSIGN h-boad268 = ?.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenance 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao001 = {cxinc/i01cx403.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN cb-natureza-cambial:LIST-ITEM-PAIRS         in frame fPage2 = cAuxTraducao001.
    &else
        ASSIGN cb-natureza-cambial:list-items              in frame fPage2 = {cxinc/i01cx403.i 03}.
    &endif
    
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao002 = {cxinc/i01cx409.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao002).
        ASSIGN cb-documento-import:LIST-ITEM-PAIRS         in frame fPage2 = cAuxTraducao002.
    &else
        ASSIGN cb-documento-import:list-items              in frame fPage2 = {cxinc/i01cx409.i 03}.
    &endif
    
    IF i-pais-impto-usuario = 21 /* Equador */ THEN DO:
        ASSIGN fi-cdn-emitente-saida-div:HIDDEN IN FRAME fPage2 = NO
               c-cdn-emitente-saida-div:HIDDEN IN FRAME fPage2  = NO.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
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
         SIZE 35 BY 1.42
         BGCOLOR 7.

    DEFINE VARIABLE cStatus AS CHARACTER NO-UNDO.

    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

    DEFINE VARIABLE ccod-estabel LIKE tt-embarque-imp.cod-estabel NO-UNDO.
    DEFINE VARIABLE iembarque LIKE tt-embarque-imp.embarque NO-UNDO.

    DEFINE FRAME fGoToRecord
        ccod-estabel AT ROW 1.21 COL 15 COLON-ALIGNED
        iembarque    AT ROW 2.21 COL 15 COLON-ALIGNED
        btGoToOK      AT ROW 3.63 COL 2.14
        btGoToCancel  AT ROW 3.63 COL 13
        rtGoToButton  AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE FONT 1 TITLE "V† Para Embarque"
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Embarque"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN ccod-estabel iembarque.

        &IF DEFINED(DBOVersion) <> 0 &THEN
           RUN findPk_codigo IN {&hDBOTable} (INPUT ccod-estabel,
                                              input iembarque,
                                              OUTPUT cStatus).
           IF cStatus <> "":U THEN DO:
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Embarque" *}
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

    assign ccod-estabel:width = 6
           iembarque:width = 17.

    ENABLE ccod-estabel iembarque btGoToOK btGoToCancel 
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
    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) THEN DO:
       RUN adbo/boad018.p persistent set h-boad018.    
       RUN cxbo/bocx220.p persistent set h-bocx220.
       RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.
    END.

    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN {&hDBOTable} (INPUT 1).
    &ELSE
        RUN openQueryStatic IN {&hDBOTable} (INPUT "cod-estabel":U).
    &ENDIF

    IF AVAIL tt-embarque-imp THEN
        enable btOrdem btPedido btFatura btpesoscubagem btimpostos with frame fPage0.
    
    if not valid-handle(h-boad107) then
        run adbo/boad107na.p persistent set h-boad107.
    run openQueryStatic in h-boad107 (INPUT "Main").

    if not valid-handle(h-boad098) then
        run adbo/boad098.p persistent set h-boad098.

    IF NOT VALID-HANDLE(h-boin274) THEN
        RUN inbo/boin274.p PERSISTENT SET h-boin274.

    if not valid-handle(h-bocx402) then
        run cxbo/bocx402.p persistent set h-bocx402.
    
    if not valid-handle(h-boad268) then
        run adbo/boad268na.p persistent set h-boad268.
    RUN openQueryStatic in h-boad268 (input "Main").

    IF NOT VALID-HANDLE(h-bocx00477) AND i-pais-impto-usuario = 21 /* Equador */ THEN DO:
        RUN cxbo/bocx00477.p PERSISTENT SET h-bocx00477.
        RUN openQueryStatic IN h-bocx00477 (INPUT "Main":U) NO-ERROR.
    END.

    &IF '{&mgdis_version}' < '2.06f' &THEN
        /*Tecnica para implementar validaá∆o produto Estendido*/
        {cdp/cdapi558.i1}
    &endif
    IF NOT VALID-HANDLE(h-bocx404) then 
        RUN cxbo/bocx404.p persistent set h-bocx404. /* decla-import-ord */

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-pagamento-ord wMaintenance 
PROCEDURE pi-atualiza-pagamento-ord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM cEstabelec     LIKE estabelec.cod-estabel          NO-UNDO.
    DEFINE INPUT PARAM cEmbarque      LIKE decla-import-embarq.cod-embarq NO-UNDO.
    DEFINE INPUT PARAM iNaturezaCamb  AS INTEGER                          NO-UNDO.

    DEFINE VARIABLE i              AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-ult-prazo    AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-cod-ven-par  AS INTEGER NO-UNDO.
    DEFINE VARIABLE d-dt-ult-prazo AS DATE    NO-UNDO.
    DEFINE VARIABLE d-dt-embarque  AS DATE    NO-UNDO.

    FIND FIRST embarque-imp NO-LOCK
         WHERE embarque-imp.cod-estabel = cEstabelec 
           AND embarque-imp.embarque    = cEmbarque NO-ERROR.

    IF  AVAIL  embarque-imp THEN DO:
        FOR EACH decla-import-ord EXCLUSIVE-LOCK
           WHERE decla-import-ord.cod-embarq = embarque-imp.embarque
             AND decla-import-ord.cod-estab  = embarque-imp.cod-estabel:

            &if '{&bf_mat_versao_ems}' >= '2.09' &then
                if  iNaturezaCamb = 2 /* Sem Cobertura */ 
                then assign decla-import-ord.idi-ind-pagto = 4. /* Sem Cobertura */
                else
                    for first pedido-compr of ordem-compra no-lock:
                        if  pedido-compr.cod-cond-pag <> 0 then
                            for first cond-pagto no-lock
                                where cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag:
                                DO i = 1 TO 12:
                                   IF cond-pagto.prazos[i] <> 0 THEN ASSIGN i-ult-prazo   = cond-pagto.prazos[i]
                                                                            i-cod-ven-par = cond-pagto.cod-ven-par[i].
                                END. /* DO i = 1 TO 12: */
                                if i-ult-prazo <= 180 or i-cod-ven-par = 2 /* a vista */ or i-cod-ven-par = 3 /* antecipado */ 
                                then assign decla-import-ord.idi-ind-pagto = 1. /* AtÇ 180 dias */
                                else if i-ult-prazo >= 181 and i-ult-prazo <= 360 
                                     then assign decla-import-ord.idi-ind-pagto = 2. /* De 181 atÇ 360 dias */
                                     else if i-ult-prazo >= 361 then assign decla-import-ord.idi-ind-pagto = 3. /* Acima de 360 dias */
                            end. /* for first cond-pagto no-lock */
                        else 
                            for first cond-especif no-lock
                                where cond-especif.num-pedido = pedido-compr.num-pedido:
                                DO  i = 1 TO 12:
                                    IF cond-especif.data-pagto[i] <> ? THEN ASSIGN d-dt-ult-prazo = cond-especif.data-pagto[i].
                                END. /* DO i = 1 TO 12: */
    
                                for first  historico-embarque no-lock 
                                    where  historico-embarque.cod-estabel = cEstabelec
                                    and    historico-embarque.embarque    = cEmbarque:
        
                                    if  historico-embarque.dt-efetiva <> ? 
                                    then assign d-dt-embarque = historico-embarque.dt-efetiva.
                                    else assign d-dt-embarque = historico-embarque.dt-ult-previsao.
        
                                end. /* for first  historico-embarque no-lock */
        
                                if (d-dt-ult-prazo - d-dt-embarque) <= 180 
                                then assign decla-import-ord.idi-ind-pagto = 1. /* At? 180 dias */
                                else if (d-dt-ult-prazo - d-dt-embarque) >= 181 and (d-dt-ult-prazo - d-dt-embarque) <= 360
                                     then assign decla-import-ord.idi-ind-pagto = 2. /* De 181 at? 360 dias */
                                     else if (d-dt-ult-prazo - d-dt-embarque) >= 361 then assign decla-import-ord.idi-ind-pagto = 3. /* Acima de 360 dias */
                            end. /* for first cond-especif */
                    end. /* for first pedido-compr */
            &else
                if iNaturezaCamb = 2
                then assign decla-import-ord.idi-ind-pagto = 4. /* Sem Cobertura */
                else
                    for first pedido-compr of ordem-compra no-lock:
                        if  pedido-compr.cod-cond-pag <> 0 then
                            for first cond-pagto no-lock
                                where cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag:
                                DO i = 1 TO 12:
                                   IF cond-pagto.prazos[i] <> 0 THEN ASSIGN i-ult-prazo   = cond-pagto.prazos[i]
                                                                            i-cod-ven-par = cond-pagto.cod-ven-par[i].
                                END. /* DO i = 1 TO 12: */
                                if i-ult-prazo <= 180 or i-cod-ven-par = 2 /* ? vista */ or i-cod-ven-par = 3 /* antecipado */ 
                                then assign decla-import-ord.idi-ind-pagto = 1. /* At? 180 dias */
                                else if i-ult-prazo >= 181 and i-ult-prazo <= 360 
                                     then assign decla-import-ord.idi-ind-pagto = 2. /* De 181 at? 360 dias */
                                     else if i-ult-prazo >= 361 then assign decla-import-ord.idi-ind-pagto = 3. /* Acima de 360 dias */
                            end. /* for first cond-pagto no-lock */
                        else 
                            for first cond-especif no-lock
                                where cond-especif.num-pedido = pedido-compr.num-pedido:
                                DO  i = 1 TO 12:
                                    IF cond-especif.data-pagto[i] <> ? THEN ASSIGN d-dt-ult-prazo = cond-especif.data-pagto[i].
                                END. /* DO i = 1 TO 12: */
    
                                for first  historico-embarque no-lock 
                                    where  historico-embarque.cod-estabel = cEstabelec
                                    and    historico-embarque.embarque    = cEmbarque:
        
                                    if  historico-embarque.dt-efetiva <> ? 
                                    then assign d-dt-embarque = historico-embarque.dt-efetiva.
                                    else assign d-dt-embarque = historico-embarque.dt-ult-previsao.
        
                                end. /* for first  historico-embarque no-lock */
        
                                if (d-dt-ult-prazo - d-dt-embarque) <= 180 
                                then assign decla-import-ord.idi-ind-pagto = 1. /* At? 180 dias */
                                else if (d-dt-ult-prazo - d-dt-embarque) >= 181 and (d-dt-ult-prazo - d-dt-embarque) <= 360
                                     then assign decla-import-ord.idi-ind-pagto = 2. /* De 181 at? 360 dias */
                                     else if (d-dt-ult-prazo - d-dt-embarque) >= 361 then assign decla-import-ord.idi-ind-pagto = 3. /* Acima de 360 dias */
                            end. /* for first cond-especif */
                    end. /* for first pedido-compr */
            &endif
        END. /* for eahc decla-import-ord */
    END. /* if  avail  embarque-imp */
  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-combos wMaintenance 
PROCEDURE pi-trata-combos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pLogGravarMostrar AS LOGICAL NO-UNDO.

    IF AVAIL tt-embarque-imp THEN
        IF pLogGravarMostrar THEN DO:
            &if '{&bf_mat_versao_ems}' >= '2.09' &then
                IF tt-embarque-imp.idi-natur-cambial = 0 THEN
                    ASSIGN tt-embarque-imp.idi-natur-cambial = 1.

                ASSIGN cb-natureza-cambial:screen-value  in frame fPage2 = {cxinc/i01cx403.i 04 tt-embarque-imp.idi-natur-cambial}.
                       
            &else
                IF tt-embarque-imp.int-1 = 0 THEN
                    ASSIGN tt-embarque-imp.int-1 = 1.

                ASSIGN cb-natureza-cambial:screen-value  in frame fPage2 = {cxinc/i01cx403.i 04 tt-embarque-imp.int-1}.

            &endif

            IF string(substr(tt-embarque-imp.char-1,91,1)) = "" OR string(substr(tt-embarque-imp.char-1,91,1)) = "0" THEN
                ASSIGN substr(tt-embarque-imp.char-1,91,1) = "1".
            ELSE IF string(substr(tt-embarque-imp.char-1,91,1)) = "1" THEN
                ASSIGN substr(tt-embarque-imp.char-1,91,1) = "2".
            ELSE IF string(substr(tt-embarque-imp.char-1,91,1)) = "2" THEN
                ASSIGN substr(tt-embarque-imp.char-1,91,1) = "3".

            ASSIGN cb-documento-import:screen-value  in frame fPage2 = {cxinc/i01cx409.i 04 int(substr(tt-embarque-imp.char-1,91,1))}
                   substr(tt-embarque-imp.char-1,91,1) = cb-documento-import:screen-value  in frame fPage2.

        END.
        ELSE DO:
            &if '{&bf_mat_versao_ems}' >= '2.09' &then
                ASSIGN INPUT FRAME fPage2 cb-natureza-cambial
                       tt-embarque-imp.idi-natur-cambial = {cxinc/i01cx403.i 06 cb-natureza-cambial}.
                ASSIGN INPUT FRAME fPage2 cb-documento-import
                       substr(tt-embarque-imp.char-1,91,1) = STRING({cxinc/i01cx409.i 06 cb-documento-import}).
            &else
                ASSIGN INPUT FRAME fPage2 cb-natureza-cambial
                       tt-embarque-imp.int-1 = {cxinc/i01cx403.i 06 cb-natureza-cambial}.
                ASSIGN INPUT FRAME fPage2 cb-documento-import
                      substr(tt-embarque-imp.char-1,91,1) = STRING({cxinc/i01cx409.i 06 cb-documento-import}).
            &endif

            IF string(substr(tt-embarque-imp.char-1,91,1)) = "1" THEN
                OVERLAY(tt-embarque-imp.char-1,91,1) = "0".
            ELSE IF string(substr(tt-embarque-imp.char-1,91,1)) = "2" THEN
                OVERLAY(tt-embarque-imp.char-1,91,1) = "1".
            ELSE IF string(substr(tt-embarque-imp.char-1,91,1)) = "3" THEN
                OVERLAY(tt-embarque-imp.char-1,91,1) = "2".
        END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGetFornecedor wMaintenance 
PROCEDURE piGetFornecedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     DEF VAR c-return-ordens-emb AS CHAR NO-UNDO.
     DEF VAR c-return-ordem-compr AS CHAR NO-UNDO.
     DEF VAR i-numero-ordem       LIKE ordem-compra.numero-ordem NO-UNDO.
     DEF VAR i-cod-emitente       LIKE ordem-compra.cod-emitente NO-UNDO.
    
     ASSIGN i-cod-emitente = 0.
     IF AVAIL tt-embarque-imp THEN DO:
         RUN findEmbarque IN h-bocx225 (INPUT tt-embarque-imp.cod-estabel,
                                        INPUT tt-embarque-imp.embarque,
                                        OUTPUT c-return-ordens-emb).
         IF c-return-ordens-emb = "" THEN DO:
             RUN getintfield IN h-bocx225 ("numero-ordem", OUTPUT i-numero-ordem).
    
             RUN findOrdem IN h-boin274 (INPUT i-numero-ordem,
                                         OUTPUT c-return-ordem-compr).
             IF c-return-ordem-compr = "" THEN
                 RUN getintfield IN h-boin274 ("cod-emitente":U, OUTPUT i-cod-emitente).
             
         END.
     END.
     ASSIGN i-cod-fornecedor:SCREEN-VALUE IN FRAME fpage1 = STRING(i-cod-emitente).

     APPLY "Leave":U TO i-cod-fornecedor IN FRAME fPage1.

     RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

