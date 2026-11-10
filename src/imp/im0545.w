&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-banco NO-UNDO LIKE banco
       field r-rowid as rowid.
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
{include/i-prgvrs.i IM0545 2.00.00.042 } /*** "010042" 07/06/2024 16:04:28  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0545 MIM}
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
{cdp/cdcfgmat.i} /* defini‡Æo pr‚-processador Magnus */
{cdp/cdcfgdis.i}
{include/i_dbvers.i} /*Include de Pr‚-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar valida‡Æo produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
&endif

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0545
&GLOBAL-DEFINE Version        2.00.00.042
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

&GLOBAL-DEFINE ttTable        tt-embarque-imp
&GLOBAL-DEFINE hDBOTable      h-bocx220
&GLOBAL-DEFINE DBOTable       embarque-imp

&GLOBAL-DEFINE page0KeyFields tt-embarque-imp.cod-estabel ~
                              tt-embarque-imp.embarque 
&GLOBAL-DEFINE page0Fields    
&IF DEFINED (bf_dis_versao_ems) &THEN
    &IF '{&bf_dis_versao_ems}' >= '2.05' &THEN
        &GLOBAL-DEFINE page1Fields    i-cod-despachante ~
                                      i-cod-transportador ~
                                      combo-box-1 ~
                                      c-nr-conhec-master ~
                                      c-nr-conhec-house ~
                                      tt-embarque-imp.contabilizado ~
                                      tt-embarque-imp.log-embarq-transf-draw ~
                                      tt-embarque-imp.cdn-despa-exter-import ~
                                      tt-embarque-imp.cdn-corretor-cambio-import ~
                                      tt-embarque-imp.cdn-segurad-import ~
                                      tt-embarque-imp.cdn-corretor-import ~
                                      tt-embarque-imp.cod-incoterm

    &ELSE
        &GLOBAL-DEFINE page1Fields    tt-embarque-imp.cod-estabel ~
                                      tt-embarque-imp.embarque ~
                                      i-cod-despachante ~
                                      i-cod-transportador ~
                                      combo-box-1 ~
                                      c-nr-conhecimento ~
                                      tt-embarque-imp.contabilizado ~
                                      tt-embarque-imp.log-embarq-transf-draw ~
                                      tt-embarque-imp.cdn-despa-exter-import ~
                                      tt-embarque-imp.cdn-corretor-cambio-import ~
                                      tt-embarque-imp.cdn-segurad-import ~
                                      tt-embarque-imp.cdn-corretor-import ~
                                      tt-embarque-imp.cod-incoterm

    &ENDIF
&ELSE
    &GLOBAL-DEFINE page1Fields    i-cod-despachante ~
                                  i-cod-transportador ~
                                  combo-box-1 ~
                                  c-nr-conhecimento ~
                                  tt-embarque-imp.contabilizado ~
                                  tt-embarque-imp.log-embarq-transf-draw ~
                                  tt-embarque-imp.cdn-despa-exter-import ~
                                  tt-embarque-imp.cdn-corretor-cambio-import ~
                                  tt-embarque-imp.cdn-segurad-import ~
                                  tt-embarque-imp.cdn-corretor-import ~
                                  tt-embarque-imp.cod-incoterm


&ENDIF
&IF DEFINED (bf_dis_versao_ems) &THEN
    &IF '{&bf_dis_versao_ems}' >= '2.05' &THEN
        &GLOBAL-DEFINE page2Fields    tt-embarque-imp.cod-banco ~
                                      tt-embarque-imp.carta-credito ~
                                      tt-embarque-imp.nr-rof ~
                                      tt-embarque-imp.declaracao-import ~
                                      tt-embarque-imp.data-DI ~
                                      c-nome-banco
    &ELSE
        &GLOBAL-DEFINE page2Fields    tt-embarque-imp.cod-banco ~
                                      tt-embarque-imp.carta-credito ~
                                      tt-embarque-imp.nr-rof ~
                                      tt-embarque-imp.declaracao-import ~
                                      tt-embarque-imp.data-DI ~
                                      tt-embarque-imp.licenca-import
    &ENDIF
&ELSE
    &GLOBAL-DEFINE page2Fields    tt-embarque-imp.cod-banco ~
                                  tt-embarque-imp.carta-credito ~
                                  tt-embarque-imp.nr-rof ~
                                  tt-embarque-imp.declaracao-import ~
                                  tt-embarque-imp.data-DI ~
                                  tt-embarque-imp.licenca-import
&ENDIF
&GLOBAL-DEFINE page3Fields    tt-embarque-imp.narrativa


/* Parameters Definitions ---                                           */
    
/* Local Variable Definitions ---                                       */
DEFINE VARIABLE v-pagar      AS CHAR   NO-UNDO.
DEFINE VARIABLE v-receber    AS CHAR   NO-UNDO.
DEFINE VARIABLE c-estabelec  AS CHAR   NO-UNDO.
DEFINE VARIABLE c-transp     AS CHAR   NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad018    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad355    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad098na  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad098    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad268    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad107    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-programa   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx225    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin274    AS HANDLE NO-UNDO.
DEFINE VARIABLE hIm0041      AS HANDLE NO-UNDO.
DEFINE VARIABLE hIm0545a     AS HANDLE NO-UNDO.
DEFINE VARIABLE hIm0545b     AS HANDLE NO-UNDO.
DEFINE VARIABLE hIm0545c     AS HANDLE NO-UNDO.
DEFINE VARIABLE hIm0545g     AS HANDLE NO-UNDO.
DEFINE VARIABLE hIm0545f     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-im0545h    AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE gl-im0044 AS LOGICAL NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque 
&Scoped-define ENABLED-TABLES tt-embarque-imp
&Scoped-define FIRST-ENABLED-TABLE tt-embarque-imp
&Scoped-Define ENABLED-OBJECTS RECT-4 rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btOrdem btItem btFatura btTitulo btRateio ~
btrelaciona btVeiculo btSaldoEmbarque btQueryJoins btReportsJoins btExit ~
btHelp c-nome-estab 
&Scoped-Define DISPLAYED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque 
&Scoped-define DISPLAYED-TABLES tt-embarque-imp
&Scoped-define FIRST-DISPLAYED-TABLE tt-embarque-imp
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
       MENU-ITEM miEmbalagem    LABEL "&Embalagem/Ve¡culo" ACCELERATOR "CTRL-E"
       MENU-ITEM miSaldoEmbarque LABEL "&Saldo a Nacionalizar"
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

DEFINE BUTTON btItem 
     IMAGE-UP FILE "image\im-item":U
     LABEL "Item" 
     SIZE 4 BY 1.25 TOOLTIP "Itens do Embarque"
     FONT 4.

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
     SIZE 4 BY 1.25 TOOLTIP "Ordens do Embarque"
     FONT 4.

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

DEFINE BUTTON btRateio 
     IMAGE-UP FILE "image\im-raneg":U
     LABEL "Button 1" 
     SIZE 4 BY 1.25 TOOLTIP "Notas Fiscais do Embarque".

DEFINE BUTTON btrelaciona 
     IMAGE-UP FILE "image/im-carga.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-carga.bmp":U
     LABEL "LI's Relacionados" 
     SIZE 4 BY 1.25 TOOLTIP "LI's Relacionados".

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSaldoEmbarque 
     IMAGE-UP FILE "image/im-f-erp.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Saldo a Nacionalizar".

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btTitulo 
     IMAGE-UP FILE "image\cmcac":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Titulos do Embarque".

DEFINE BUTTON btVeiculo 
     IMAGE-UP FILE "image\im-carg":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Embarque / Ve¡culo".

DEFINE VARIABLE c-nome-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)" 
     LABEL "Via Transporte" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-2 AS CHARACTER FORMAT "X(20)" INITIAL "NÆo Encerrado" 
     LABEL "Situa‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "NÆo Encerrado","Encerrado" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-fornecedor AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-corret-seg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-corretor AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-desp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-desp-ext AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-segur AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-transp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-conhec-house AS CHARACTER FORMAT "X(25)":U 
     LABEL "Conhecimento House" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-conhec-master AS CHARACTER FORMAT "X(25)":U 
     LABEL "Conhecimento Master" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-conhecimento AS CHARACTER FORMAT "X(18)" 
     LABEL "Conhecimento Transporte" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-despachante AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Despachante" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-fornecedor AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "C¢digo Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-transportador AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Transportador" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-banco AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.


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
     btOrdem AT ROW 1.13 COL 31 HELP
          "Ordens de Compra"
     btItem AT ROW 1.13 COL 35 HELP
          "Pedidos de Compra"
     btFatura AT ROW 1.13 COL 39 HELP
          "Faturas do Embarque"
     btTitulo AT ROW 1.13 COL 43
     btRateio AT ROW 1.13 COL 47.14
     btrelaciona AT ROW 1.13 COL 51.14 HELP
          "LI's Relacionados"
     btVeiculo AT ROW 1.13 COL 55.14
     btSaldoEmbarque AT ROW 1.13 COL 59 WIDGET-ID 2
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-embarque-imp.cod-estabel AT ROW 2.75 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-nome-estab AT ROW 2.75 COL 37.29 COLON-ALIGNED NO-LABEL
     tt-embarque-imp.embarque AT ROW 3.75 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     RECT-4 AT ROW 2.54 COL 1.14
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 13.92
         FONT 1.

DEFINE FRAME fPage2
     tt-embarque-imp.cod-banco AT ROW 1.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-nome-banco AT ROW 1.17 COL 41 COLON-ALIGNED NO-LABEL
     tt-embarque-imp.carta-credito AT ROW 2.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     tt-embarque-imp.nr-rof AT ROW 3.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     tt-embarque-imp.declaracao-import AT ROW 4.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31 BY .88
     tt-embarque-imp.data-DI AT ROW 5.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-embarque-imp.cod-incoterm AT ROW 6.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 4 ROW 6
         SIZE 84 BY 7.71
         FONT 1.

DEFINE FRAME fPage3
     tt-embarque-imp.narrativa AT ROW 1.5 COL 9.43 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 72.86 BY 5.79
     "Narrativa:" VIEW-AS TEXT
          SIZE 7.14 BY .88 AT ROW 1.5 COL 2.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 6
         SIZE 85 BY 7.75
         FONT 1.

DEFINE FRAME fPage1
     tt-embarque-imp.log-embarq-transf-draw AT ROW 7.25 COL 62.29
          LABEL "Transferˆncia Drawback"
          VIEW-AS TOGGLE-BOX
          SIZE 19.72 BY .83 TOOLTIP "Transferˆncia Drawback"
     c-desc-fornecedor AT ROW 7.25 COL 25.29 COLON-ALIGNED NO-LABEL
     i-cod-fornecedor AT ROW 7.25 COL 15 COLON-ALIGNED
     COMBO-BOX-1 AT ROW 3.25 COL 15 COLON-ALIGNED
     i-cod-transportador AT ROW 2.25 COL 15 COLON-ALIGNED
     c-nome-transp AT ROW 2.25 COL 25.29 COLON-ALIGNED NO-LABEL
     COMBO-BOX-2 AT ROW 1.25 COL 15 COLON-ALIGNED HELP
          "Situa‡Æo do processo de importa‡Æo"
     i-cod-despachante AT ROW 4.25 COL 15 COLON-ALIGNED
     c-nome-desp AT ROW 4.25 COL 25.29 COLON-ALIGNED NO-LABEL
     c-nr-conhecimento AT ROW 5.25 COL 18.29 COLON-ALIGNED
     c-nr-conhec-master AT ROW 5.25 COL 15 COLON-ALIGNED
     c-nr-conhec-house AT ROW 6.25 COL 15 COLON-ALIGNED
     tt-embarque-imp.contabilizado AT ROW 6.13 COL 62.29
          VIEW-AS TOGGLE-BOX
          SIZE 14 BY .83
     tt-embarque-imp.cdn-corretor-cambio-import AT ROW 1.25 COL 60.29 COLON-ALIGNED
          LABEL "Corretor Cƒmbio":R31
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-nome-corretor AT ROW 1.25 COL 70.43 COLON-ALIGNED NO-LABEL
     tt-embarque-imp.cdn-despa-exter-import AT ROW 2.25 COL 60.29 COLON-ALIGNED
          LABEL "Despachante Exterior":R31
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-nome-desp-ext AT ROW 2.25 COL 70.43 COLON-ALIGNED NO-LABEL
     tt-embarque-imp.cdn-segurad-import AT ROW 3.25 COL 60.29 COLON-ALIGNED
          LABEL "Seguradora":R25
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-nome-segur AT ROW 3.25 COL 70.43 COLON-ALIGNED NO-LABEL
     tt-embarque-imp.cdn-corretor-import AT ROW 4.25 COL 60.29 COLON-ALIGNED
          LABEL "Corretor de Seguro":R23
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-nome-corret-seg AT ROW 4.25 COL 70.43 COLON-ALIGNED NO-LABEL
     tt-embarque-imp.cod-incoterm AT ROW 5.25 COL 60.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 6
         SIZE 85 BY 7.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-banco T "?" NO-UNDO mgadm banco
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
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
         HEIGHT             = 14.38
         WIDTH              = 90.43
         MAX-HEIGHT         = 38.21
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.21
         VIRTUAL-WIDTH      = 182.86
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
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
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
/* SETTINGS FOR TOGGLE-BOX tt-embarque-imp.log-embarq-transf-draw IN FRAME fPage1
   EXP-LABEL                                                            */

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR EDITOR tt-embarque-imp.narrativa IN FRAME fPage3
   NO-ENABLE                                                            */
ASSIGN 
       tt-embarque-imp.narrativa:READ-ONLY IN FRAME fPage3        = TRUE.

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
  RUN imp/im0545c.w PERSISTENT SET hIm0545c ( input tt-embarque-imp.cod-estabel, 
                                              input tt-embarque-imp.embarque).
  run initializeInterface in hIm0545c no-error.

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


&Scoped-define SELF-NAME btItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btItem wMaintenance
ON CHOOSE OF btItem IN FRAME fpage0 /* Item */
DO:
  RUN imp/im0545b.w PERSISTENT SET hIm0545b ( input tt-embarque-imp.cod-estabel, 
                                              input tt-embarque-imp.embarque).
  run initializeInterface in hIm0545b no-error.

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


&Scoped-define SELF-NAME btOrdem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOrdem wMaintenance
ON CHOOSE OF btOrdem IN FRAME fpage0 /* Ordem */
DO:
    RUN imp/im0545a.w PERSISTENT SET hIm0545a ( input tt-embarque-imp.cod-estabel, 
                                                input tt-embarque-imp.embarque).
    
    run initializeInterface in hIm0545a no-error.


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


&Scoped-define SELF-NAME btRateio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRateio wMaintenance
ON CHOOSE OF btRateio IN FRAME fpage0 /* Button 1 */
DO:
    RUN imp/im0545g.w PERSISTENT SET hIm0545g ( input tt-embarque-imp.cod-estabel, 
                                                input tt-embarque-imp.embarque).
    run initializeInterface in hIm0545g no-error.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btrelaciona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btrelaciona wMaintenance
ON CHOOSE OF btrelaciona IN FRAME fpage0 /* LI's Relacionados */
OR CHOOSE OF MENU-ITEM miRelaciona IN MENU mbMain DO:
    RUN imp/im0041.w PERSISTENT SET hIm0041 ( input ?, INPUT tt-embarque-imp.r-rowid, INPUT NO).
    run initializeInterface in hIm0041 no-error.

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


&Scoped-define SELF-NAME btSaldoEmbarque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSaldoEmbarque wMaintenance
ON CHOOSE OF btSaldoEmbarque IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miSaldoEmbarque IN MENU mbMain DO:
    RUN imp/im0545h.w PERSISTENT SET h-im0545h.
    RUN initializeInterface in h-im0545h NO-ERROR.
    RUN repositionRecord IN h-im0545h(INPUT {&ttTable}.r-rowid).
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


&Scoped-define SELF-NAME btTitulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btTitulo wMaintenance
ON CHOOSE OF btTitulo IN FRAME fpage0
DO:

    RUN imp/im0545f.p PERSISTENT SET hIm0545f ( input tt-embarque-imp.r-rowid).
    run initializeInterface in hIm0545f no-error.

/*
  assign wMaintenance:Sensitive = no.
  disable btTitulo with frame fpage0.

  Run imp/im0545f.p (input tt-embarque-imp.r-rowid).

  enable btTitulo with frame fpage0.
  assign wMaintenance:sensitive = yes.
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btVeiculo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVeiculo wMaintenance
ON CHOOSE OF btVeiculo IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miEmbalagem IN MENU mbMain DO:

    run eqp/eq1002.w persistent set h-programa.
    
    run recebeEstabelecimentoEmbarque in h-programa (input input frame fPage0 tt-embarque-imp.cod-estabel,
                                                     input input frame fPage0 tt-embarque-imp.embarque).
    run initializeInterface in h-programa.
    
    {&WINDOW-NAME}:SENSITIVE = NO.

     RUN InitializeInterface IN h-programa NO-ERROR.
     IF RETURN-VALUE = "NOK":U THEN DO:
        {&WINDOW-NAME}:SENSITIVE = YES.
        RETURN NO-APPLY.
     END.
    
     RUN beforeDisplayFields IN h-programa NO-ERROR.
    
     WAIT-FOR CLOSE OF h-programa FOCUS CURRENT-WINDOW.
     {&WINDOW-NAME}:SENSITIVE = YES.
    
     IF VALID-HANDLE(h-programa) THEN
         DELETE PROCEDURE h-programa.
     ASSIGN h-programa = ?.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME c-nome-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-desp wMaintenance
ON LEAVE OF c-nome-desp IN FRAME fPage1
DO:
  if avail tt-embarque-imp then do:
          {method/referencefields.i 
           &HandleDBOLeave="h-boad098na"
           &FindMethod="findemitente"
           &KeyValue1="int(i-cod-despachante:SCREEN-VALUE IN FRAME fPage1)"
           &FieldName1="nome-abrev" 
           &FieldScreen1="c-nome-desp"
           &Frame1="fPage1"}  
   end.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-embarque-imp.cdn-corretor-cambio-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cdn-corretor-cambio-import wMaintenance
ON LEAVE OF tt-embarque-imp.cdn-corretor-cambio-import IN FRAME fPage1 /* Corretor Cƒmbio */
DO:
      if  avail tt-embarque-imp
      and input frame fPage1 tt-embarque-imp.cdn-corretor-cambio-import <> 0 then do:
          {method/referencefields.i 
           &HandleDBOLeave="h-boad098na"
           &FindMethod="findemitente"
           &KeyValue1="int(tt-embarque-imp.cdn-corretor-cambio-import:SCREEN-VALUE IN FRAME fPage1)"
           &FieldName1="nome-abrev" 
           &FieldScreen1="c-nome-corretor"
           &Frame1="fPage1"}  
      end.   
      else
          assign c-nome-corretor:screen-value in frame fPage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-embarque-imp.cdn-corretor-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cdn-corretor-import wMaintenance
ON LEAVE OF tt-embarque-imp.cdn-corretor-import IN FRAME fPage1 /* Corretor de Seguro */
DO:

    if  avail tt-embarque-imp
    and input frame fPage1 tt-embarque-imp.cdn-corretor-import <> 0 then do:
        {method/referencefields.i 
             &HandleDBOLeave="h-boad098na"
             &FindMethod="findemitente"
             &KeyValue1="int(tt-embarque-imp.cdn-corretor-import:SCREEN-VALUE IN FRAME fPage1)"
             &FieldName1="nome-abrev" 
             &FieldScreen1="c-nome-corret-seg"
             &Frame1="fPage1"}  
    end.   
    else
        assign c-nome-corret-seg:screen-value in frame fPage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-embarque-imp.cdn-despa-exter-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cdn-despa-exter-import wMaintenance
ON LEAVE OF tt-embarque-imp.cdn-despa-exter-import IN FRAME fPage1 /* Despachante Exterior */
DO:
      if  avail tt-embarque-imp
      and input frame fPage1 tt-embarque-imp.cdn-despa-exter-import <> 0 then do:
          {method/referencefields.i 
           &HandleDBOLeave="h-boad098na"
           &FindMethod="findemitente"
           &KeyValue1="int(tt-embarque-imp.cdn-despa-exter-import:SCREEN-VALUE IN FRAME fPage1)"
           &FieldName1="nome-abrev" 
           &FieldScreen1="c-nome-desp-ext"
           &Frame1="fPage1"}  
      end.   
      else
          assign c-nome-desp-ext:screen-value in frame fPage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-embarque-imp.cdn-segurad-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cdn-segurad-import wMaintenance
ON LEAVE OF tt-embarque-imp.cdn-segurad-import IN FRAME fPage1 /* Seguradora */
DO:
    if  avail tt-embarque-imp
    and input frame fPage1 tt-embarque-imp.cdn-segurad-import <> 0 then do:
          {method/referencefields.i 
           &HandleDBOLeave="h-boad098na"
           &FindMethod="findemitente"
           &KeyValue1="int(tt-embarque-imp.cdn-segurad-import:SCREEN-VALUE IN FRAME fPage1)"
           &FieldName1="nome-abrev" 
           &FieldScreen1="c-nome-segur"
           &Frame1="fPage1"}  
    end.   
    else
        assign c-nome-segur:screen-value in frame fPage1 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tt-embarque-imp.cod-banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cod-banco wMaintenance
ON LEAVE OF tt-embarque-imp.cod-banco IN FRAME fPage2 /* Banco */
DO:

&IF DEFINED (bf_dis_versao_ems) &THEN
    &IF '{&bf_dis_versao_ems}' >= '2.05' &THEN
      {method/referencefields.i 
          &HandleDBOLeave="h-boad018"
          &FindMethod="findCod_banco"
          &KeyValue1="integer(tt-embarque-imp.cod-banco:SCREEN-VALUE IN FRAME fPage2)"
          &FieldName1="nome-banco"
          &FieldScreen1="c-nome-banco"
          &Frame1="fPage2"}
    &ENDIF
&ENDIF

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cod-banco wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-embarque-imp.cod-banco IN FRAME fPage2 /* Banco */
DO:
    {method/zoomfields.i 
     &ProgramZoom="adzoom/z10ad018.w"
     &FieldZoom1="cod-banco"
     &FieldScreen1="tt-embarque-imp.cod-banco"
     &Frame1="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME tt-embarque-imp.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cod-estabel wMaintenance
ON LEAVE OF tt-embarque-imp.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  if avail tt-embarque-imp then do:
      
      run gotoKey in h-boad107 (input tt-embarque-imp.cod-estabel:screen-value in frame fPage0).
                                  
      if return-value = "OK":U then do:
            run getcharfield in h-boad107 ("nome":U, output c-estabelec).
            assign c-nome-estab:screen-value in frame fPage0 = c-estabelec.
      end.
      else assign c-nome-estab:screen-value in frame fPage0 = "".
  end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-embarque-imp.cod-incoterm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-embarque-imp.cod-incoterm wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-embarque-imp.cod-incoterm IN FRAME fPage1 /* Incoterm */
DO:
    {method/zoomfields.i 
     &ProgramZoom="cxzoom/z10cx025.w"
     &FieldZoom1="cod-incoterm"
     &FieldScreen1="tt-embarque-imp.cod-incoterm"
     &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-despachante
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-despachante wMaintenance
ON LEAVE OF i-cod-despachante IN FRAME fPage1 /* Despachante */
DO:
  if avail tt-embarque-imp then do:
          {method/referencefields.i 
           &HandleDBOLeave="h-boad098na"
           &FindMethod="findemitente"
           &KeyValue1="int(i-cod-despachante:SCREEN-VALUE IN FRAME fPage1)"
           &FieldName1="nome-abrev" 
           &FieldScreen1="c-nome-desp"
           &Frame1="fPage1"}  
   end.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-despachante wMaintenance
ON MOUSE-SELECT-DBLCLICK OF i-cod-despachante IN FRAME fPage1 /* Despachante */
DO:
     {method/zoomfields.i 
     &ProgramZoom="adzoom/z10ad098.w"
     &FieldZoom1="cod-emitente"
     &FieldScreen1="i-cod-despachante"
     &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define SELF-NAME i-cod-transportador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-transportador wMaintenance
ON LEAVE OF i-cod-transportador IN FRAME fPage1 /* Transportador */
DO:
  if avail tt-embarque-imp then do:
        run gotoKey in h-boad268 (input i-cod-transportador:screen-value in frame fPage1).
                                  
        if return-value = "OK":U then do:
            run getcharfield in h-boad268 ("nome-abrev":U, output c-transp).
            assign c-nome-transp:screen-value in frame fPage1 = c-transp.
        end.
        else assign c-nome-transp:screen-value in frame fPage1 = "".
   end.         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-transportador wMaintenance
ON MOUSE-SELECT-DBLCLICK OF i-cod-transportador IN FRAME fPage1 /* Transportador */
DO:
     {method/zoomfields.i 
     &ProgramZoom="adzoom/z10ad098.w"
     &FieldZoom1="cod-emitente"
     &FieldScreen1="i-cod-transportador"
     &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
  tt-embarque-imp.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage0.
  i-cod-transportador:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage1.
  i-cod-despachante:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage1.    
  tt-embarque-imp.cod-banco:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage2.
  tt-embarque-imp.cod-incoterm:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage1.

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
    IF VALID-HANDLE({&hDBOTable}) THEN DO:                                           
       delete procedure {&hDBOTable}.
       assign {&hDBOTable} = ?.
    end.

    IF VALID-HANDLE(h-boad107) THEN DO:                                           
       delete procedure h-boad107.
       assign h-boad107 = ?.
    end.

    IF VALID-HANDLE(h-boad268) THEN DO:                                           
       delete procedure h-boad268.
       assign h-boad268 = ?.
    end.
    
    IF VALID-HANDLE(h-boad018) THEN DO:                                           
       delete procedure h-boad018.
       assign h-boad018 = ?.
    end.

    IF VALID-HANDLE(h-boad098na) THEN DO:                                           
       delete procedure h-boad098na.
       assign h-boad098na = ?.
    end.
    IF VALID-HANDLE(h-boad098) THEN DO:                                           
       delete procedure h-boad098.
       assign h-boad098 = ?.
    end.

     IF VALID-HANDLE(h-boad355) THEN DO:                                           
       delete procedure h-boad355.
       assign h-boad355 = ?.
    end.

    IF VALID-HANDLE(hIm0545a) THEN DO:
        DELETE PROCEDURE hIm0545a.
        ASSIGN hIm0545a = ?.
    END.
    IF VALID-HANDLE(hIm0545b) THEN DO:
        DELETE PROCEDURE hIm0545b.
        ASSIGN hIm0545b = ?.
    END.
    IF VALID-HANDLE(hIm0545c) THEN DO:
        DELETE PROCEDURE hIm0545c.
        ASSIGN hIm0545c = ?.
    END.
    IF VALID-HANDLE(hIm0545g) THEN DO:
        DELETE PROCEDURE hIm0545g.
        ASSIGN hIm0545g = ?.
    END.
    IF VALID-HANDLE(hIm0545f) THEN DO:
        DELETE PROCEDURE hIm0545f.
        ASSIGN hIm0545f = ?.
    END.
    IF VALID-HANDLE(hIm0041) THEN DO:
        DELETE PROCEDURE hIm0041.
        ASSIGN hIm0041 = ?.
    END.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayfields wMaintenance 
PROCEDURE afterDisplayfields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
    enable tt-embarque-imp.narrativa with frame fPage3.

    IF AVAIL tt-embarque-imp THEN DO:

         IF i-pais-impto-usuario = 1 THEN         
            ASSIGN tt-embarque-imp.log-embarq-transf-draw:HIDDEN IN FRAME fPage1 = TRUE.
      
        ASSIGN combo-box-1:SCREEN-VALUE         IN FRAME fPage1 = {adinc/i01ad268.i 04 tt-embarque-imp.cod-via-transp}
               i-cod-transportador:SCREEN-VALUE IN FRAME fPage1 = STRING(tt-embarque-imp.cod-transportador)
               i-cod-despachante:SCREEN-VALUE   IN FRAME fPage1 = STRING(tt-embarque-imp.cod-despachante)
               combo-box-2:SCREEN-VALUE         IN FRAME fpage1 = {cxinc/i01cx220.i 04 tt-embarque-imp.situacao}.
        
        &IF DEFINED (bf_dis_versao_ems) &THEN
            &IF '{&bf_dis_versao_ems}' >= '2.05' &THEN
                ASSIGN c-nr-conhec-master:SCREEN-VALUE IN FRAME fpage1 = STRING(tt-embarque-imp.cod-conhecto-master)
                    c-nr-conhec-house:SCREEN-VALUE IN FRAME fpage1     = STRING(tt-embarque-imp.cod-conhecto-house).
                APPLY "leave" TO tt-embarque-imp.cod-banco IN FRAME fPage2.
            &ELSE
                ASSIGN c-nr-conhecimento:SCREEN-VALUE IN FRAME fpage1   = STRING(tt-embarque-imp.nr-conhecimento).
            &ENDIF
        &ELSE
            ASSIGN c-nr-conhecimento:SCREEN-VALUE IN FRAME fpage1   = STRING(tt-embarque-imp.nr-conhecimento).
        &ENDIF
    END.
    
    apply 'leave':U to tt-embarque-imp.cod-estabel                in frame fPage0.
    apply 'leave':U to i-cod-transportador                        in frame fPage1.
    apply 'leave':U to i-cod-despachante                          in frame fPage1.
    apply 'leave':U to tt-embarque-imp.cdn-corretor-cambio-import in frame fPage1.
    apply 'leave':U to tt-embarque-imp.cdn-despa-exter-import     in frame fPage1. 
    apply 'leave':U to tt-embarque-imp.cdn-segurad-import         in frame fPage1.
    apply 'leave':U to tt-embarque-imp.cdn-corretor-import        in frame fPage1.

    RUN piGetFornecedor IN THIS-PROCEDURE.
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

enable btrelaciona
       btSaldoEmbarque WITH FRAME {&FRAME-NAME}.

ASSIGN gl-im0044 = NO.
&IF DEFINED (bf_dis_versao_ems) &THEN
    &IF '{&bf_dis_versao_ems}' >= '2.05' &THEN
        ASSIGN c-nr-conhecimento:HIDDEN IN FRAME fPage1 = YES
               tt-embarque-imp.contabilizado:ROW IN FRAME fPage1 = 6.20.
        IF VALID-HANDLE (h-boad355) THEN
            RUN pi-verificar-produto IN h-boad355 (OUTPUT v-pagar, OUTPUT v-receber).
        IF (v-pagar <> "EMS 5") OR (v-receber <> "EMS 5") THEN DO:
            RUN SetFolder IN hFolder (INPUT 1).
        END.
        DELETE PROCEDURE h-boad355.
        ASSIGN h-boad355 = ?.
    &ELSE
        ASSIGN c-nr-conhec-master:HIDDEN IN FRAME fPage1 = YES
               c-nr-conhec-house:HIDDEN IN FRAME fPage1 = YES
               c-nome-banco:HIDDEN IN FRAME fPage2 = YES.
        RUN SetFolder IN hFolder (INPUT 1).
    &ENDIF
&ELSE
    ASSIGN c-nr-conhec-master:HIDDEN IN FRAME fPage1 = YES
           c-nr-conhec-house:HIDDEN IN FRAME fPage1 = YES
           c-nome-banco:HIDDEN IN FRAME fPage2 = YES.
       RUN SetFolder IN hFolder (INPUT 1).
&ENDIF

    FIND FIRST param-global NO-LOCK NO-ERROR.
      IF AVAIL param-global AND param-global.log-modul-eq THEN
           ENABLE btVeiculo WITH FRAME fPage0.
      ELSE ASSIGN btVeiculo:HIDDEN  IN FRAME fPage0 = YES
                  btVeiculo:TOOLTIP IN FRAME fPage0 = "".

RUN utp/ut-trcampos.p.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayFields wMaintenance 
PROCEDURE beforeDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
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
             THREE-D SCROLLABLE FONT 1 TITLE "V  Para Embarque"
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Embarque"}
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
    
    assign ccod-estabel:width = 4
           iembarque:WIDTH = 17.
    
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
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) THEN DO:
       RUN cxbo/bocx220.p persistent set h-bocx220.

       &IF DEFINED (bf_dis_versao_ems) &THEN
           &IF '{&bf_dis_versao_ems}' >= '2.05' &THEN
               RUN adbo/boad018.p persistent set h-boad018.
               RUN adbo/boad355.p PERSISTENT SET h-boad355.
           &ENDIF
       &ENDIF

        /*{btb/btb008za.i1 <DBOProgram>}
 *         {btb/btb008za.i2 <DBOProgram> '' {&hDBOTable}}*/
    END.

    IF NOT VALID-HANDLE(h-bocx225) THEN
        RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.

    IF NOT VALID-HANDLE(h-boin274) THEN
        RUN inbo/boin274.p PERSISTENT SET h-boin274.

    IF NOT VALID-HANDLE(h-boad098) THEN DO:
       RUN adbo/boad098.p persistent set h-boad098.
    END.

    IF NOT VALID-HANDLE(h-boad098na) THEN DO:
       RUN adbo/boad098na.p persistent set h-boad098na.
    END.

    IF NOT VALID-HANDLE(h-boad107) THEN DO:
       RUN adbo/boad107na.p persistent set h-boad107.
    END.

    IF NOT VALID-HANDLE(h-boad268) THEN DO:
       RUN adbo/boad268na.p persistent set h-boad268.
    END.
    
    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN {&hDBOTable} (INPUT 1).
    &ELSE
        RUN openQueryStatic IN {&hDBOTable} (INPUT "cod-estabel":U).
    &ENDIF

    RUN openQueryStatic IN h-boad107 (INPUT "Main":U).
    RUN openQueryStatic IN h-boad268 (INPUT "Main":U).

    enable btOrdem btItem btFatura btTitulo btRateio with frame fPage0.

    &IF '{&mgdis_version}' < '2.06f' &THEN
        /*Tecnica para implementar valida‡Æo produto Estendido*/
        {cdp/cdapi558.i1}
    &endif
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
     ASSIGN i-cod-fornecedor:SCREEN-VALUE IN FRAME fpage1 = STRING(i-cod-emitente).

     APPLY "Leave":U TO i-cod-fornecedor IN FRAME fPage1.

     RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

