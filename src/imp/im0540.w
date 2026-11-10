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
{include/i-prgvrs.i IM0540 2.00.00.025 } /*** "010025" 14/11/2023 11:37:08  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0540 MIM}
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
    /*Tecnica para implementar valida‡Æo produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
&endif
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0540
&GLOBAL-DEFINE Version        2.00.00.025
&GLOBAL-DEFINE DBOVersion     1.1

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FramesHandle   STRING(FRAME fPage1:HANDLE) + ",":U + ~
                              STRING(FRAME fPage2:HANDLE) + ",":U + ~
                              STRING(FRAME fPage3:HANDLE) + ",":U + ~
                              STRING(FRAME fPage4:HANDLE)

&GLOBAL-DEFINE FolderLabels   Processo, Financ/Fiscal, Mensagem, Narrativa

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

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
                              tt-processo-imp.cdn-despa-exter-import ~
                              tt-processo-imp.cdn-corretor-cambio-import ~
                              tt-processo-imp.cdn-segurad-import ~
                              tt-processo-imp.cdn-corretor-import ~
                              combo-box-1 cx-situacao                              

&GLOBAL-DEFINE page2Fields    tt-processo-imp.cod-banco ~
                              tt-processo-imp.carta-credito ~
                              c-dest-doc ~
                              tt-processo-imp.nr-rof ~
                              tt-processo-imp.cod-consignatario ~
                              tt-processo-imp.regime-import ~
                              tt-processo-imp.estab-fisc

&GLOBAL-DEFINE page3Fields    tt-processo-imp.cod-mensagem ~
                              tt-processo-imp.texto-mensag

&GLOBAL-DEFINE page4Fields    tt-processo-imp.narrativa

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var c-estabelec  like estabelec.nome        no-undo.
def var c-transp     like transporte.nome-abrev no-undo.
def var c-des-idioma like idioma.des_idioma     no-undo.
def var c-des-itiner like itinerario.descricao  no-undo.
def var c-erro       as char                    no-undo.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad098    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad268    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bofn167    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx115    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad107    AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa  AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-3 btFirst btPrev btNext ~
btLast btGoTo btSearch btrelaciona btQueryJoins btReportsJoins btExit ~
btHelp c-nome-estab 
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

DEFINE BUTTON btrelaciona 
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

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE c-nome-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 94 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 94 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Via Transp" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cx-situacao AS CHARACTER FORMAT "X(256)":U INITIAL "NÆo Embarcado" 
     LABEL "Situa‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "NÆo Embarcado","Embarcado Parcial","Embarcado Total","Encerrado" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-idioma AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-itiner AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-ag AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-corret-seg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-corretor AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-desp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-desp-ext AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-exp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-fab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-segur AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-transp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-dest-doc AS CHARACTER FORMAT "X(40)":U 
     LABEL "Destino da Documenta‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 29.86 BY .88 NO-UNDO.


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
     btrelaciona AT ROW 1.13 COL 73.43 HELP
          "LI's Relacionados"
     btQueryJoins AT ROW 1.13 COL 79 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 83 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 87 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 91 HELP
          "Ajuda"
     tt-processo-imp.cod-estabel AT ROW 2.75 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-nome-estab AT ROW 2.75 COL 39 COLON-ALIGNED NO-LABEL
     tt-processo-imp.nr-proc-imp AT ROW 3.75 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     rtToolBar AT ROW 1 COL 1
     RECT-3 AT ROW 2.58 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.14 ROW 1
         SIZE 94.14 BY 15.29
         FONT 1.

DEFINE FRAME fPage1
     tt-processo-imp.num-pedido AT ROW 1.13 COL 16.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-processo-imp.cod-exportador AT ROW 2.13 COL 16.72 COLON-ALIGNED
          LABEL "Exportador/Fornecedor":R21
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     c-nome-exp AT ROW 2.13 COL 27 COLON-ALIGNED NO-LABEL
     tt-processo-imp.dt-emissao AT ROW 3.13 COL 16.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-processo-imp.cod-fabricante AT ROW 4.13 COL 16.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     c-nome-fab AT ROW 4.13 COL 27 COLON-ALIGNED NO-LABEL
     tt-processo-imp.cod-despachante AT ROW 5.13 COL 16.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     c-nome-desp AT ROW 5.13 COL 27 COLON-ALIGNED NO-LABEL
     tt-processo-imp.cod-transportador AT ROW 6.13 COL 16.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     c-nome-transp AT ROW 6.13 COL 27 COLON-ALIGNED NO-LABEL
     COMBO-BOX-1 AT ROW 7.13 COL 16.72 COLON-ALIGNED
     tt-processo-imp.cod-agente AT ROW 8.13 COL 16.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     c-nome-ag AT ROW 8.13 COL 27 COLON-ALIGNED NO-LABEL
     tt-processo-imp.cod-itiner AT ROW 2.13 COL 55.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-itiner AT ROW 2.13 COL 61.86 COLON-ALIGNED NO-LABEL
     tt-processo-imp.cod-idioma AT ROW 3.13 COL 55.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-desc-idioma AT ROW 3.13 COL 67.14 COLON-ALIGNED NO-LABEL
     c-nome-corretor AT ROW 4.13 COL 67 COLON-ALIGNED NO-LABEL
     c-nome-desp-ext AT ROW 5.13 COL 67.14 COLON-ALIGNED NO-LABEL
     c-nome-segur AT ROW 6.13 COL 67.14 COLON-ALIGNED NO-LABEL
     c-nome-corret-seg AT ROW 7.13 COL 67.14 COLON-ALIGNED NO-LABEL
     cx-situacao AT ROW 9.04 COL 16.72 COLON-ALIGNED
     tt-processo-imp.cdn-corretor-cambio-import AT ROW 4.13 COL 55.72 COLON-ALIGNED
          LABEL "Corretor Cƒmbio":R31
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-processo-imp.cdn-corretor-import AT ROW 7.13 COL 55.72 COLON-ALIGNED
          LABEL "Corretor de Seguro":R23
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-processo-imp.cdn-despa-exter-import AT ROW 5.13 COL 55.72 COLON-ALIGNED
          LABEL "Despachante Exterior":R31
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-processo-imp.cdn-segurad-import AT ROW 6.13 COL 55.72 COLON-ALIGNED
          LABEL "Seguradora":R25
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 6.38
         SIZE 91 BY 9.17
         FONT 1.

DEFINE FRAME fPage2
     tt-processo-imp.cod-banco AT ROW 1.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
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
         SIZE 90 BY 9.15
         FONT 1.

DEFINE FRAME fPage3
     tt-processo-imp.cod-mensagem AT ROW 1.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-processo-imp.texto-mensag AT ROW 2.17 COL 37.14 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 30 BY 4
     "Mensagem:" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 2.25 COL 28.72
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 6.38
         SIZE 90 BY 9.15
         FONT 1.

DEFINE FRAME fPage4
     tt-processo-imp.narrativa AT ROW 1.17 COL 37.14 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 30 BY 4
     "Narrativa:" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 1.25 COL 30
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 6.38
         SIZE 90 BY 9.15
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
         HEIGHT             = 15.29
         WIDTH              = 94.14
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


&Scoped-define SELF-NAME btrelaciona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btrelaciona wMaintenance
ON CHOOSE OF btrelaciona IN FRAME fpage0 /* LI's Relacionados */
OR CHOOSE OF MENU-ITEM miRelaciona IN MENU mbMain DO:
    
    RUN imp/im0041.w (INPUT tt-processo-imp.r-rowid, ?, NO).
      
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


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="cxzoom/z01cx140.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-processo-imp.cdn-corretor-cambio-import
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


&Scoped-define SELF-NAME tt-processo-imp.cdn-corretor-import
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


&Scoped-define SELF-NAME tt-processo-imp.cdn-despa-exter-import
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


&Scoped-define SELF-NAME tt-processo-imp.cdn-segurad-import
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


&Scoped-define SELF-NAME tt-processo-imp.cod-agente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-agente wMaintenance
ON LEAVE OF tt-processo-imp.cod-agente IN FRAME fPage1 /* Agente Cargas */
DO:
   if avail tt-processo-imp then do:
       {method/referencefields.i 
           &HandleDBOLeave="h-boad098"
           &FindMethod="findemitente"
           &KeyValue1="int(tt-processo-imp.cod-agente:SCREEN-VALUE IN FRAME fPage1)"
           &FieldName1="nome-abrev" 
           &FieldScreen1="c-nome-ag"
           &Frame1="fPage1"}  

   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tt-processo-imp.cod-banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-banco wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-processo-imp.cod-banco IN FRAME fPage2 /* Banco */
DO:
    {method/zoomfields.i 
     &ProgramZoom="adzoom/z10ad018.w"
     &FieldZoom1="cod-banco"
     &FieldScreen1="tt-processo-imp.cod-banco"
     &Frame1="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-processo-imp.cod-despachante
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-despachante wMaintenance
ON LEAVE OF tt-processo-imp.cod-despachante IN FRAME fPage1 /* C¢digo Despachante */
DO:
   if avail tt-processo-imp then do:
         {method/referencefields.i 
           &HandleDBOLeave="h-boad098"
           &FindMethod="findemitente"
           &KeyValue1="int(tt-processo-imp.cod-despachante:SCREEN-VALUE IN FRAME fPage1)"
           &FieldName1="nome-abrev" 
           &FieldScreen1="c-nome-desp"
           &Frame1="fPage1"}  

   end.    
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
ON LEAVE OF tt-processo-imp.cod-exportador IN FRAME fPage1 /* Exportador/Fornecedor */
DO:
    if avail tt-processo-imp then do:
       {method/referencefields.i 
           &HandleDBOLeave="h-boad098"
           &FindMethod="findemitente"
           &KeyValue1="int(tt-processo-imp.cod-exportador:SCREEN-VALUE IN FRAME fPage1)"
           &FieldName1="nome-abrev" 
           &FieldScreen1="c-nome-exp"
           &Frame1="fPage1"}  

   end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-processo-imp.cod-fabricante
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-fabricante wMaintenance
ON LEAVE OF tt-processo-imp.cod-fabricante IN FRAME fPage1 /* C¢digo Fabricante */
DO:
   if avail tt-processo-imp then do:
          {method/referencefields.i 
           &HandleDBOLeave="h-boad098"
           &FindMethod="findemitente"
           &KeyValue1="int(tt-processo-imp.cod-fabricante:SCREEN-VALUE IN FRAME fPage1)"
           &FieldName1="nome-abrev" 
           &FieldScreen1="c-nome-fab"
           &Frame1="fPage1"}  
   end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-processo-imp.cod-idioma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-idioma wMaintenance
ON LEAVE OF tt-processo-imp.cod-idioma IN FRAME fPage1 /* Idioma */
DO:
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


&Scoped-define SELF-NAME tt-processo-imp.cod-itiner
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-itiner wMaintenance
ON LEAVE OF tt-processo-imp.cod-itiner IN FRAME fPage1 /* C¢digo Itiner rio */
DO:
   if avail tt-processo-imp then do:
        run gotoKey in h-bocx115 (input tt-processo-imp.cod-itiner:screen-value in frame fPage1).
                                  
        if return-value = "OK":U then do:
            run getcharfield in h-bocx115 ("descricao":U, output c-des-itiner).
            assign c-desc-itiner:screen-value in frame fPage1 = c-des-itiner.
        end.
        else assign c-desc-itiner:screen-value in frame fPage1 = "".
   end.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME tt-processo-imp.cod-mensagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-mensagem wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-processo-imp.cod-mensagem IN FRAME fPage3 /* C¢digo Mensagem */
DO:
   {method/zoomfields.i 
     &ProgramZoom="inzoom/z10in176.w"
     &FieldZoom1="cod-mensagem"
     &FieldScreen1="tt-processo-imp.cod-mensagem"
     &Frame1="fPage3"
     &FieldZoom2="texto-mensag"
     &FieldScreen2="tt-processo-imp.texto-mensag"
     &Frame2="fPage3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-processo-imp.cod-transportador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-processo-imp.cod-transportador wMaintenance
ON LEAVE OF tt-processo-imp.cod-transportador IN FRAME fPage1 /* C¢digo Transportador */
DO:
       if avail tt-processo-imp then do:
        run gotoKey in h-boad268 (input tt-processo-imp.cod-transportador:screen-value in frame fPage1).
                                  
        if return-value = "OK":U then do:
            run getcharfield in h-boad268 ("nome-abrev":U, output c-transp).
            assign c-nome-transp:screen-value in frame fPage1 = c-transp.
        end.
        else assign c-nome-transp:screen-value in frame fPage1 = "".
   end.         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
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
    
    IF VALID-HANDLE(h-bocx115) THEN DO:                                           
       delete procedure h-bocx115.
       assign h-bocx115 = ?.
    end.

    IF VALID-HANDLE(h-boad098) THEN DO:                                           
       delete procedure h-boad098.
       assign h-boad098 = ?.
    end.
    
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

    disp tt-processo-imp.cod-estabel
         tt-processo-imp.nr-proc-imp
         with frame fPage0.
    disp tt-processo-imp.cod-exportador
         tt-processo-imp.num-pedido
         with frame fPage1.
         
    assign c-dest-doc:screen-value in frame fPage2  = substr(tt-processo-imp.char-1,1,40)
           combo-box-1:screen-value in frame fPage1 = {adinc/i01ad268.i 04 tt-processo-imp.via-transp}.
           cx-situacao:screen-value in frame fPage1 = {cxinc/i01cx140.i 04 tt-processo-imp.situacao}.


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
 
    enable btrelaciona with frame {&FRAME-NAME}.

    return "OK":U.
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
    
    DEFINE VARIABLE ccod-estabel LIKE tt-processo-imp.cod-estabel VIEW-AS FILL-IN SIZE 05 BY 0.88 NO-UNDO.
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
              {utp/ut-liter.i "Processo_de_Importa‡Æo" *}
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
    
    IF NOT VALID-HANDLE(h-boad098) THEN DO:
       RUN adbo/boad098na.p persistent set h-boad098.
    END.

    IF NOT VALID-HANDLE(h-boad107) THEN DO:
       RUN adbo/boad107na.p persistent set h-boad107.
    END.

    IF NOT VALID-HANDLE(h-bocx115) THEN DO:
       RUN cxbo/bocx115na.p persistent set h-bocx115.
    END.

    IF NOT VALID-HANDLE(h-boad268) THEN DO:
       RUN adbo/boad268na.p persistent set h-boad268.
    END.
    
    IF NOT VALID-HANDLE(h-bofn167) THEN DO:
       RUN fnbo/bofn167.p persistent set h-bofn167.
    END.
    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN {&hDBOTable} (INPUT 1).
    &ELSE
        RUN openQueryStatic IN {&hDBOTable} (INPUT "cod-estabel":U).
    &ENDIF    
    
    RUN openQueryStatic IN h-boad107 (INPUT "Main":U).
    RUN openQueryStatic IN h-bocx115 (INPUT "Main":U).
    RUN openQueryStatic IN h-boad268 (INPUT "Main":U).

    &IF '{&mgdis_version}' < '2.06f' &THEN
        /*Tecnica para implementar valida‡Æo produto Estendido*/
        {cdp/cdapi558.i1}
    &endif
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

