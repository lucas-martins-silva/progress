&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decl-hist-embarq-imp NO-UNDO LIKE decl-hist-embarq-imp
       field cod-pto-contr like historico-embarque.cod-pto-contr
       field r-rowid as rowid
       index codigo  cod-estabel
       embarque
       cod-itiner
       sequencia
       de-codigo
       r-rowid.
DEFINE TEMP-TABLE tt-desp-embarque NO-UNDO LIKE desp-embarque
       field r-rowid as rowid
       index codigo cod-estabel
       embarque
       cod-itiner
       cod-pto-contr
       cod-desp
       cod-emitente-desp
       r-rowid.
DEFINE TEMP-TABLE tt-historico-embarque NO-UNDO LIKE historico-embarque
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-historico-embarque2 NO-UNDO LIKE historico-embarque
       field r-rowid as rowid
       index codigo cod-estabel
       embarque
       cod-itiner
       sequencia
       r-rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0055 2.00.00.094 } /*** "010094" 24/11/2025 11:30:28 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0055 MIM}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/boerrtab.i}
CREATE WIDGET-POOL.

{include/i_dbvers.i} /*Include de PrÇ-Processadores*/
{utp/ut-glob.i}

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar validaá∆o produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
&endif

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM0055
&GLOBAL-DEFINE Version        2.00.00.094
&GLOBAL-DEFINE DBOVersion       1.1

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FramesHandle     STRING(FRAME fPage1:HANDLE)
&GLOBAL-DEFINE FolderLabels     Ptos Contr, Despesas, Comunic.

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddSon1          YES
&GLOBAL-DEFINE UpdateSon1       YES
&GLOBAL-DEFINE DeleteSon1       YES

&GLOBAL-DEFINE AddSon2          YES
&GLOBAL-DEFINE UpdateSon2       YES
&GLOBAL-DEFINE DeleteSon2       YES

&GLOBAL-DEFINE AddSon3          YES
&GLOBAL-DEFINE UpdateSon3       YES
&GLOBAL-DEFINE DeleteSon3       YES

&GLOBAL-DEFINE ttParent         tt-historico-embarque
&GLOBAL-DEFINE hDBOParent       h-bocx230
&GLOBAL-DEFINE DBOParentTable   historico-embarque

&GLOBAL-DEFINE ttSon1           tt-historico-embarque2
&GLOBAL-DEFINE hDBOSon1         h-bocx2302
&GLOBAL-DEFINE DBOSon1Table     historico-embarque

&GLOBAL-DEFINE ttSon2           tt-desp-embarque
&GLOBAL-DEFINE hDBOSon2         h-bocx310
&GLOBAL-DEFINE DBOSon2Table     desp-embarque

&GLOBAL-DEFINE ttSon3           tt-decl-hist-embarq-imp
&GLOBAL-DEFINE hDBOSon3         h-bocx280
&GLOBAL-DEFINE DBOSon3Table     decl-hist-embarq-imp
&GLOBAL-DEFINE DBOSon3Destroy   YES

&GLOBAL-DEFINE page0Fields      tt-historico-embarque.cod-estabel ~
                                tt-historico-embarque.embarque ~
                                tt-historico-embarque.cod-itiner ~
                                fill-in-1 ~
                                fill-in-2 ~
                                fill-in-3 ~
                                fill-in-4 ~
                                fill-in-5 ~
                                i-pto-despch ~
                                i-pto-chegad ~
                                i-dias-total

&GLOBAL-DEFINE page1Widgets btn-muda-sequencia btn-modifica-ptos btn-cancela-ptos btn-confirma-ptos
&GLOBAL-DEFINE page2Widgets btn-modifica-desp btn-cancela-desp btn-confirma-desp btn-filter-desp
&GLOBAL-DEFINE page3Widgets btn-modifica-decl btn-cancela-decl btn-confirma-decl btn-filter-decl

&GLOBAL-DEFINE page1Browse brSon1  
&GLOBAL-DEFINE VALUE-CHANGED1 YES
   
&GLOBAL-DEFINE page2Browse brSon2    
&GLOBAL-DEFINE VALUE-CHANGED2 YES 

&GLOBAL-DEFINE page3Browse brSon3    
&GLOBAL-DEFINE VALUE-CHANGED3 YES

&GLOBAL-DEFINE EXCLUDE-applyOffEnd
&GLOBAL-DEFINE EXCLUDE-applyEnd

&GLOBAL-DEFINE NumRowsReturned  99999

/* Parameters Definitions ---                                           */
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE  NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE  NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}   AS HANDLE  NO-UNDO.
DEFINE VARIABLE {&hDBOSon3}   AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx115     AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx110     AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx1102    AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx220     AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx2303    AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx407     AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx384     AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx336     AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-boar0138    AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-boad098     AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-boun005     AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx250     AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx225e    AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-cdapi050    AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx095     AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx010     AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx250na   AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx225     AS HANDLE  NO-UNDO.

DEFINE VARIABLE cDiferenca               AS INTEGER                            NO-UNDO.
DEFINE VARIABLE cDescricao               AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE c-cod-uf                 AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE l-integra-di             AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE c-embarque               LIKE historico-embarque.embarque      NO-UNDO.
DEFINE VARIABLE c-cod-estabel            LIKE historico-embarque.cod-estabel   NO-UNDO.
DEFINE VARIABLE i-cod-itiner             LIKE historico-embarque.cod-itiner    NO-UNDO.
DEFINE VARIABLE i-sequen                 LIKE historico-embarque.sequencia     NO-UNDO.
DEFINE VARIABLE i-pto-contr              LIKE historico-embarque.cod-pto-contr NO-UNDO.
DEFINE VARIABLE r-chave                  AS ROWID                              NO-UNDO.
DEFINE VARIABLE l-historico              AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE c-cod-estabel-imp        AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE c-embarque-imp           LIKE historico-embarque.embarque      NO-UNDO.
DEFINE VARIABLE c-return                 AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE r-historico-embarque     AS ROWID                              NO-UNDO.
DEFINE VARIABLE r-rowid-embarque         AS ROWID                              NO-UNDO.
DEFINE VARIABLE l-desabilita-btdespesa   AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE l-seq-nac                AS INTEGER                            NO-UNDO.
DEFINE VARIABLE l-passou                 AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE c-cod-estabel-historico  AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE c-embarque-historico     LIKE historico-embarque.embarque      NO-UNDO.
DEFINE VARIABLE i-seq-nacionaliz         LIKE historico-embarque.sequencia     NO-UNDO.
DEFINE VARIABLE l-criar                  AS LOGICAL                            NO-UNDO.

DEFINE VARIABLE i-pto-desp-ini LIKE historico-embarque.cod-pto-contr INIT 0     NO-UNDO.
DEFINE VARIABLE i-pto-desp-fim LIKE historico-embarque.cod-pto-contr INIT 99999 NO-UNDO.
DEFINE VARIABLE i-pto-decl-ini LIKE historico-embarque.cod-pto-contr INIT 0     NO-UNDO.
DEFINE VARIABLE i-pto-decl-fim LIKE historico-embarque.cod-pto-contr INIT 99999 NO-UNDO.

DEFINE VARIABLE c-nr-ato-concessorio AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nr-ato-atual       AS CHARACTER   NO-UNDO.

&IF "{&DBOParentTable}":U <> "":U &THEN
    &GLOBAL-DEFINE rTable gr-{&DBOParentTable}
    DEFINE NEW GLOBAL SHARED VARIABLE gr-{&DBOParentTable} AS ROWID   NO-UNDO.
&ENDIF
DEFINE NEW GLOBAL SHARED VARIABLE gr-embarque-imp          AS ROWID   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gl-im0044                AS LOGICAL NO-UNDO.

/* New Shared Variable Definitions ---                                       */
def new shared var c-acao as char  no-undo.
def new shared var r-row  as rowid no-undo.
def new shared var r-row-hist as rowid no-undo.

{cxbo/bocx351.i tt-licenciam-import-oc}

/* flexibilizaá∆o */
DEFINE VARIABLE i-modificacao            AS INTEGER                          NO-UNDO. /* 1: Alterando sequàncias || 2: Modificando */
DEFINE VARIABLE log-perm-pto-control-imp AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE log-perm-pto-despes-imp  AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE log-perm-pto-decla-imp   AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE i-linha-browse           AS INTEGER                          NO-UNDO.
DEFINE VARIABLE l-possui-di              AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE i-pto-ant                AS INTEGER                          NO-UNDO.
DEFINE VARIABLE c-desc-pto               LIKE historico-embarque.descricao   NO-UNDO.
DEFINE VARIABLE c-desc-desp              LIKE desp-imp.descricao             NO-UNDO.
DEFINE VARIABLE i-seq-pto                AS INTEGER                          NO-UNDO.
DEFINE VARIABLE c-desc-emit-desp         LIKE emitente.nome-abrev            NO-UNDO.
DEFINE VARIABLE c-desc-moeda             LIKE moeda.descricao                NO-UNDO.
DEFINE VARIABLE l-tax-siscomex           AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE i-desp-siscomex          AS INTEGER                          NO-UNDO.
DEFINE VARIABLE r-desp-emb               AS ROWID                            NO-UNDO.
DEFINE VARIABLE l-st-zera-taxa           AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE i-desp-ant               AS INTEGER                          NO-UNDO.
DEFINE VARIABLE i-decl-ant               AS INTEGER                          NO-UNDO.
DEFINE VARIABLE l-possui-decl-emitida    AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE l-calc-desp-itiner       AS LOGICAL                          NO-UNDO.
{cxbo/bocx230.i tt-historico-embarque-bo}
{cxbo/bocx310.i tt-desp-embarque-bo}
{cxbo/bocx280.i tt-decl-hist-embarq-imp-bo}

{cxbo/bocx310a.i tt-desp-embarque-im3101}
{cxbo/bocx220h.i tt-selecao-embarque-im3101}
{cxbo/bocx310a.i tt-desp-embarque-aux-im3101}

DEFINE TEMP-TABLE tt-campo-erro NO-UNDO
    FIELD campo       AS CHARACTER.

DEFINE BUFFER bf-tt-historico-embarque2 FOR tt-historico-embarque2.

/* LABELS */
DEFINE VARIABLE c-lbl-pto-contr     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-cadastra-pto  AS CHARACTER   NO-UNDO.

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
&Scoped-define INTERNAL-TABLES {&ttSon1} {&ttSon2} {&ttSon3}

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 {&ttSon1}.sequencia {&ttSon1}.cod-pto-contr {&ttSon1}.descricao {&ttSon1}.dt-previsao {&ttSon1}.dt-ult-previsao {&ttSon1}.dt-efetiva fnDiferenca(input {&ttSon1}.dt-efetiva) @ cDiferenca {&ttSon1}.id-meio-transp {&ttSon1}.nr-dias fnIntegrDi({&ttSon1}.cod-pto-contr) @ l-integra-di {&ttSon1}.log-1 fnUF({&ttSon1}.cod-pto-contr, {&ttSon1}.cod-estabel, {&ttSon1}.embarque, {&ttSon1}.cod-itiner) @ c-cod-uf   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 {&ttSon1}.sequencia   {&ttSon1}.cod-pto-contr   {&ttSon1}.descricao   {&ttSon1}.dt-efetiva   {&ttSon1}.nr-dias   {&ttSon1}.log-1   
&Scoped-define ENABLED-TABLES-IN-QUERY-brSon1 {&ttSon1}
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brSon1 {&ttSon1}
&Scoped-define SELF-NAME brSon1
&Scoped-define QUERY-STRING-brSon1 FOR EACH {&ttSon1} NO-LOCK     BY {&ttSon1}.sequencia
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME} FOR EACH {&ttSon1} NO-LOCK     BY {&ttSon1}.sequencia.
&Scoped-define TABLES-IN-QUERY-brSon1 {&ttSon1}
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 {&ttSon1}


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 {&ttSon2}.cod-pto-contr fnDescricao({&ttSon2}.cod-pto-contr, {&ttSon2}.cod-estabel, {&ttSon2}.embarque, {&ttSon2}.cod-itiner) @ c-desc-pto {&ttSon2}.cod-desp fnDescDesp({&ttSon2}.cod-desp) @ c-desc-desp {&ttSon2}.cod-emitente-desp fnNomeAbrev({&ttSon2}.cod-emitente-desp) @ c-desc-emit-desp {&ttSon2}.cod-cond-pag {&ttSon2}.mo-codigo fnMoeda({&ttSon2}.mo-codigo) @ c-desc-moeda {&ttSon2}.val-desp {&ttSon2}.cod-incoterm-rat   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 {&ttSon2}.cod-pto-contr ~
{&ttSon2}.cod-desp ~
{&ttSon2}.cod-emitente-desp ~
{&ttSon2}.cod-cond-pag ~
{&ttSon2}.mo-codigo ~
{&ttSon2}.val-desp ~
{&ttSon2}.cod-incoterm-rat   
&Scoped-define ENABLED-TABLES-IN-QUERY-brSon2 {&ttSon2}
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brSon2 {&ttSon2}
&Scoped-define SELF-NAME brSon2
&Scoped-define QUERY-STRING-brSon2 FOR EACH {&ttSon2} NO-LOCK
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY {&SELF-NAME} FOR EACH {&ttSon2} NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon2 {&ttSon2}
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 {&ttSon2}


/* Definitions for BROWSE brSon3                                        */
&Scoped-define FIELDS-IN-QUERY-brSon3 {&ttSon3}.sequencia {&ttSon3}.cod-pto-contr fnDescricao({&ttSon3}.cod-pto-contr, {&ttSon3}.cod-estabel, {&ttSon3}.embarque, {&ttSon3}.cod-itiner) @ c-desc-pto {&ttSon3}.de-codigo {&ttSon3}.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon3 {&ttSon3}.cod-pto-contr   {&ttSon3}.de-codigo   {&ttSon3}.descricao   
&Scoped-define ENABLED-TABLES-IN-QUERY-brSon3 {&ttSon3}
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brSon3 {&ttSon3}
&Scoped-define SELF-NAME brSon3
&Scoped-define QUERY-STRING-brSon3 FOR EACH {&ttSon3} NO-LOCK
&Scoped-define OPEN-QUERY-brSon3 OPEN QUERY {&SELF-NAME} FOR EACH {&ttSon3} NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon3 {&ttSon3}
&Scoped-define FIRST-TABLE-IN-QUERY-brSon3 {&ttSon3}


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brSon3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-historico-embarque.cod-estabel ~
tt-historico-embarque.embarque tt-historico-embarque.cod-itiner 
&Scoped-define ENABLED-TABLES tt-historico-embarque
&Scoped-define FIRST-ENABLED-TABLE tt-historico-embarque
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch bt-vincula-drb bt-calc-desp-itiner btLoad ~
btQueryJoins btReportsJoins btExit btHelp FILL-IN-1 i-pto-despch ~
c-desc-pto-despch FILL-IN-2 FILL-IN-3 FILL-IN-4 FILL-IN-5 i-pto-chegad ~
c-desc-pto-chegad i-dias-total c-ato-concessorio 
&Scoped-Define DISPLAYED-FIELDS tt-historico-embarque.cod-estabel ~
tt-historico-embarque.embarque tt-historico-embarque.cod-itiner 
&Scoped-define DISPLAYED-TABLES tt-historico-embarque
&Scoped-define FIRST-DISPLAYED-TABLE tt-historico-embarque
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 i-pto-despch c-desc-pto-despch ~
FILL-IN-2 FILL-IN-3 FILL-IN-4 FILL-IN-5 i-pto-chegad c-desc-pto-chegad ~
i-dias-total c-ato-concessorio 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescDesp wMasterDetail 
FUNCTION fnDescDesp RETURNS CHARACTER
  (input pcod-desp as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescricao wMasterDetail 
FUNCTION fnDescricao RETURNS CHARACTER
  (input pcod-pto-contr AS INTEGER,
   input pcod-estabel   AS CHARACTER,
   input pembarque      AS CHARACTER, 
   input pcod-itiner    AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDiferenca wMasterDetail 
FUNCTION fnDiferenca RETURNS INTEGER
  (input dt-efetiva as date)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnIntegrDi wMasterDetail 
FUNCTION fnIntegrDi RETURNS LOGICAL
  ( pCodPtoControl AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMoeda wMasterDetail 
FUNCTION fnMoeda RETURNS CHARACTER
  (input pmo-codigo as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNomeAbrev wMasterDetail 
FUNCTION fnNomeAbrev RETURNS CHARACTER
  (input pcod-emitente-desp as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPtoSeq wMasterDetail 
FUNCTION fnPtoSeq RETURNS INTEGER
  ( INPUT p-cod-est AS CHAR,
    INPUT p-embarque AS CHAR,
    INPUT p-cod-itiner AS INT,
    input p-seq as int ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSeqPto wMasterDetail 
FUNCTION fnSeqPto RETURNS INTEGER
  (input pcod-estabel   AS CHARACTER,
   input pembarque      AS CHARACTER, 
   input pcod-itiner    AS INTEGER,
   input pcod-pto-contr AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUF wMasterDetail 
FUNCTION fnUF RETURNS CHARACTER
  (input pcod-pto-contr AS INTEGER,
   input pcod-estabel   AS CHARACTER,
   input pembarque      AS CHARACTER, 
   input pcod-itiner    AS INTEGER)  FORWARD.

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
DEFINE BUTTON bt-calc-desp-itiner 
     IMAGE-UP FILE "image/im-calc.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-calc.bmp":U
     LABEL "Calcula Despesas Itiner†rio" 
     SIZE 4 BY 1.25 TOOLTIP "Calcula Despesas Itiner†rio"
     FONT 4.

DEFINE BUTTON bt-vincula-drb 
     IMAGE-UP FILE "image/conecta.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-conecta.bmp":U
     LABEL "Vincula Drawback" 
     SIZE 4 BY 1.25 TOOLTIP "Vincula Drawback"
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
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

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btLoad 
     IMAGE-UP FILE "image\im-carga":U
     IMAGE-INSENSITIVE FILE "image\ii-carga":U
     LABEL "Load" 
     SIZE 4 BY 1.25 TOOLTIP "LI's Relacionados"
     FONT 4.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

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

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE c-ato-concessorio AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ato Concess¢rio" 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-pto-chegad AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-pto-despch AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Ponto Embarque" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Ponto Nacionalizaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE i-dias-total AS DECIMAL FORMAT ">,>>9.99":U INITIAL 0 
     LABEL "Dias de Transporte Total" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-pto-chegad AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Ponto Chegada/Encerramento" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-pto-despch AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Ponto Despacho" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 7.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAddSon1 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon1 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btn-cancela-ptos 
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btn-confirma-ptos 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btn-efetiva 
     IMAGE-UP FILE "image\im-edl":U
     IMAGE-INSENSITIVE FILE "image\ii-edl":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btn-modifica-ptos 
     IMAGE-UP FILE "image/im-clr.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-clr.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btn-muda-sequencia 
     IMAGE-UP FILE "image/im-seqni":U
     IMAGE-INSENSITIVE FILE "image/ii-seqhi":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUpdateSon1 
     LABEL "Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btAddSon2 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon2 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btn-cancela-desp 
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btn-confirma-desp 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btn-filter-desp 
     IMAGE-UP FILE "image/filt-u95.bmp":U
     IMAGE-INSENSITIVE FILE "image/filt-i95.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btn-modifica-desp 
     IMAGE-UP FILE "image/im-clr.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-clr.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNotaComplementar 
     LABEL "NF Complementar" 
     SIZE 15 BY 1 TOOLTIP "Geraá∆o NF Complementar".

DEFINE BUTTON btUpdateSon2 
     LABEL "Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btAddSon3 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon3 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btn-cancela-decl 
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btn-confirma-decl 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btn-filter-decl 
     IMAGE-UP FILE "image/filt-u95.bmp":U
     IMAGE-INSENSITIVE FILE "image/filt-i95.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btn-modifica-decl 
     IMAGE-UP FILE "image/im-clr.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-clr.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUpdateSon3 
     LABEL "Modificar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      {&ttSon1} SCROLLING.

DEFINE QUERY brSon2 FOR 
      {&ttSon2} SCROLLING.

DEFINE QUERY brSon3 FOR 
      {&ttSon3} SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 NO-LOCK DISPLAY
      {&ttSon1}.sequencia FORMAT ">>9":U
      {&ttSon1}.cod-pto-contr FORMAT ">>,>>9":U
      {&ttSon1}.descricao
      {&ttSon1}.dt-previsao FORMAT "99/99/9999":U
      {&ttSon1}.dt-ult-previsao FORMAT "99/99/9999":U
      {&ttSon1}.dt-efetiva FORMAT "99/99/9999":U
      fnDiferenca(input {&ttSon1}.dt-efetiva) @ cDiferenca COLUMN-LABEL "Diferenáa" FORMAT "->>>>>9":U
      {&ttSon1}.id-meio-transp FORMAT "X(20)":U
      {&ttSon1}.nr-dias
      fnIntegrDi({&ttSon1}.cod-pto-contr) @ l-integra-di COLUMN-LABEL "Integrou DI" WIDTH 20 FORMAT "Sim/N∆o"
      {&ttSon1}.log-1 FORMAT "Sim/N∆o" COLUMN-LABEL "Recalcula Dt Ult Prev"
      fnUF({&ttSon1}.cod-pto-contr, {&ttSon1}.cod-estabel, {&ttSon1}.embarque, {&ttSon1}.cod-itiner) @ c-cod-uf  FORMAT "x(04)":U COLUMN-LABEL "UF":U
ENABLE 
    {&ttSon1}.sequencia
    {&ttSon1}.cod-pto-contr
    {&ttSon1}.descricao
    {&ttSon1}.dt-efetiva
    {&ttSon1}.nr-dias
    {&ttSon1}.log-1
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78 BY 7.75
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _FREEFORM
  QUERY brSon2 NO-LOCK DISPLAY
      {&ttSon2}.cod-pto-contr
      fnDescricao({&ttSon2}.cod-pto-contr, {&ttSon2}.cod-estabel, {&ttSon2}.embarque, {&ttSon2}.cod-itiner) @ c-desc-pto  
      {&ttSon2}.cod-desp FORMAT ">>,>>9":U
      fnDescDesp({&ttSon2}.cod-desp) @ c-desc-desp
      {&ttSon2}.cod-emitente-desp FORMAT ">>>>>>>>9":U
      fnNomeAbrev({&ttSon2}.cod-emitente-desp) @ c-desc-emit-desp
      {&ttSon2}.cod-cond-pag FORMAT ">>>9":U
      {&ttSon2}.mo-codigo FORMAT ">9":U
      fnMoeda({&ttSon2}.mo-codigo) @ c-desc-moeda  COLUMN-LABEL "Descriá∆o"
      {&ttSon2}.val-desp FORMAT ">>>>>,>>>,>>9.99999":U
      {&ttSon2}.cod-incoterm-rat
ENABLE 
      {&ttSon2}.cod-pto-contr
      {&ttSon2}.cod-desp
      {&ttSon2}.cod-emitente-desp
      {&ttSon2}.cod-cond-pag
      {&ttSon2}.mo-codigo
      {&ttSon2}.val-desp
      {&ttSon2}.cod-incoterm-rat
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78 BY 7.75
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE brSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon3 wMasterDetail _FREEFORM
  QUERY brSon3 NO-LOCK DISPLAY
      {&ttSon3}.sequencia FORMAT ">>9":U
{&ttSon3}.cod-pto-contr
fnDescricao({&ttSon3}.cod-pto-contr, {&ttSon3}.cod-estabel, {&ttSon3}.embarque, {&ttSon3}.cod-itiner) @ c-desc-pto
{&ttSon3}.de-codigo FORMAT ">>,>>9":U
{&ttSon3}.descricao
ENABLE 
    {&ttSon3}.cod-pto-contr
    {&ttSon3}.de-codigo
    {&ttSon3}.descricao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78 BY 7.75
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage3
     brSon3 AT ROW 1.13 COL 2.14 WIDGET-ID 200
     btn-filter-decl AT ROW 1.29 COL 80.43 WIDGET-ID 2
     btn-modifica-decl AT ROW 2.54 COL 80.43
     btn-cancela-decl AT ROW 3.79 COL 80.43
     btn-confirma-decl AT ROW 5.04 COL 80.43
     btAddSon3 AT ROW 8.92 COL 1.86
     btUpdateSon3 AT ROW 8.92 COL 11.86
     btDeleteSon3 AT ROW 8.92 COL 21.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 11.88
         SIZE 84.43 BY 9.5
         FONT 1.

DEFINE FRAME fPage0
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
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     bt-vincula-drb AT ROW 1.13 COL 62.57 HELP
          "Vincula Drawback ao Embarque" WIDGET-ID 12
     bt-calc-desp-itiner AT ROW 1.13 COL 66.72 HELP
          "Calcula Despesas Itiner†rio" WIDGET-ID 10
     btLoad AT ROW 1.13 COL 70.86 HELP
          "LI's Relacionados"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-historico-embarque.cod-estabel AT ROW 2.83 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-historico-embarque.embarque AT ROW 3.75 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     tt-historico-embarque.cod-itiner AT ROW 4.67 COL 35.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .88
     FILL-IN-1 AT ROW 4.67 COL 42 COLON-ALIGNED NO-LABEL
     i-pto-despch AT ROW 5.58 COL 35.14 COLON-ALIGNED WIDGET-ID 2
     c-desc-pto-despch AT ROW 5.58 COL 42 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     FILL-IN-2 AT ROW 6.5 COL 35.14 COLON-ALIGNED
     FILL-IN-3 AT ROW 6.5 COL 42 COLON-ALIGNED NO-LABEL
     FILL-IN-4 AT ROW 7.42 COL 35.14 COLON-ALIGNED
     FILL-IN-5 AT ROW 7.42 COL 42 COLON-ALIGNED NO-LABEL
     i-pto-chegad AT ROW 8.33 COL 35.14 COLON-ALIGNED WIDGET-ID 4
     c-desc-pto-chegad AT ROW 8.33 COL 42 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     i-dias-total AT ROW 9.25 COL 35.14 COLON-ALIGNED
     c-ato-concessorio AT ROW 9.25 COL 54.57 COLON-ALIGNED WIDGET-ID 14
     rtParent AT ROW 2.75 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 20.42
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.25 COL 2
     btn-efetiva AT ROW 1.38 COL 80.57
     btn-muda-sequencia AT ROW 2.63 COL 80.57
     btn-modifica-ptos AT ROW 3.88 COL 80.57
     btn-cancela-ptos AT ROW 5.13 COL 80.57
     btn-confirma-ptos AT ROW 6.38 COL 80.57
     btAddSon1 AT ROW 9.13 COL 2.14
     btUpdateSon1 AT ROW 9.13 COL 12.29
     btDeleteSon1 AT ROW 9.13 COL 22.43
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 11.88
         SIZE 84.43 BY 9.5
         FONT 1.

DEFINE FRAME fPage2
     brSon2 AT ROW 1.13 COL 2.14 WIDGET-ID 100
     btn-filter-desp AT ROW 1.29 COL 80.43 WIDGET-ID 2
     btn-modifica-desp AT ROW 2.54 COL 80.43
     btn-cancela-desp AT ROW 3.79 COL 80.43
     btn-confirma-desp AT ROW 5.04 COL 80.43
     btAddSon2 AT ROW 8.92 COL 1.86
     btUpdateSon2 AT ROW 8.92 COL 11.86
     btDeleteSon2 AT ROW 8.92 COL 21.86
     btNotaComplementar AT ROW 8.92 COL 31.86 WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 11.88
         SIZE 84.43 BY 9.5
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-decl-hist-embarq-imp T "?" NO-UNDO mgcex decl-hist-embarq-imp
      ADDITIONAL-FIELDS:
          field cod-pto-contr like historico-embarque.cod-pto-contr
          field r-rowid as rowid
          index codigo  cod-estabel
          embarque
          cod-itiner
          sequencia
          de-codigo
          r-rowid
      END-FIELDS.
      TABLE: tt-desp-embarque T "?" NO-UNDO mgcex desp-embarque
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
          index codigo cod-estabel
          embarque
          cod-itiner
          cod-pto-contr
          cod-desp
          cod-emitente-desp
          r-rowid
      END-FIELDS.
      TABLE: tt-historico-embarque T "?" NO-UNDO mgcex historico-embarque
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-historico-embarque2 T "?" NO-UNDO mgcex historico-embarque
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
          index codigo cod-estabel
          embarque
          cod-itiner
          sequencia
          r-rowid
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
         HEIGHT             = 20.54
         WIDTH              = 90
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
ASSIGN 
       bt-calc-desp-itiner:HIDDEN IN FRAME fPage0           = TRUE.

ASSIGN 
       bt-vincula-drb:HIDDEN IN FRAME fPage0           = TRUE.

ASSIGN 
       c-ato-concessorio:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
/* SETTINGS FOR BUTTON btNotaComplementar IN FRAME fPage2
   NO-ENABLE                                                            */
ASSIGN 
       btNotaComplementar:HIDDEN IN FRAME fPage2           = TRUE.

/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brSon3 1 fPage3 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH {&ttSon1} NO-LOCK
    BY {&ttSon1}.sequencia.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-historico-embarque2.sequencia|yes"
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH {&ttSon2} NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brSon2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon3
/* Query rebuild information for BROWSE brSon3
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH {&ttSon3} NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brSon3 */
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


&Scoped-define BROWSE-NAME brSon1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON MOUSE-SELECT-CLICK OF brSon1 IN FRAME fPage1
DO:
  /*
  RUN pi-valida-integracao-di.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON VALUE-CHANGED OF brSon1 IN FRAME fPage1
DO:
    IF AVAIL {&ttSon1} THEN DO:
        /* Se estiver modificando os registros */
        IF i-modificacao <> 0 THEN DO:
            IF i-modificacao = 2 /* btn Modificaá∆o de ptos de controle */ THEN DO:
                SELF:SELECT-ROW(i-linha-browse) NO-ERROR. /* Impede que a linha do browse seja alterada durante a modificaá∆o. */
                RETURN.
            END.
            ASSIGN i-linha-browse = brSon1:FOCUSED-ROW.
        END.
    
        RUN pi-verifica-decl-emitida IN h-bocx230 (INPUT {&ttSon1}.cod-estabel,
                                                   INPUT {&ttSon1}.embarque,
                                                   INPUT {&ttSon1}.cod-itiner,
                                                   INPUT {&ttSon1}.sequencia,
                                                   OUTPUT l-possui-decl-emitida).
    
        /* Habilita ou desabilita o bot∆o "efetivar" */
        ASSIGN btn-efetiva:SENSITIVE IN FRAME fPage1 = IF (log-perm-pto-control-imp 
                                                      AND tt-historico-embarque2.dt-efetiva = ?
                                                      AND i-modificacao = 0) AND
                                                      ((l-possui-di AND tt-historico-embarque2.sequencia < i-seq-nacionaliz) OR
                                                      NOT l-possui-di)THEN YES ELSE NO.
        
        /* Habilita ou desabilita o  bot∆o "modificar" */
        IF AVAIL tt-historico-embarque AND AVAIL tt-historico-embarque2 AND i-modificacao = 0 THEN DO:
            IF NOT l-possui-di AND log-perm-pto-control-imp AND tt-historico-embarque2.dt-efetiva = ? THEN DO:
                ASSIGN btn-modifica-ptos:SENSITIVE IN FRAME fPage1  = YES.
            END.
            ELSE DO:
                ASSIGN btn-modifica-ptos:SENSITIVE IN FRAME fPage1  = NO
                btn-muda-sequencia:SENSITIVE IN FRAME fPage1 = IF NOT l-possui-di AND log-perm-pto-control-imp THEN YES ELSE NO.
            END.
        END.
    
        IF (l-possui-di AND tt-historico-embarque2.sequencia >= i-seq-nacionaliz) THEN DO:
            DISABLE btAddSon1 btUpdateSon1 btDeleteSon1 btn-muda-sequencia WITH FRAME fPage1.
        END.
        ELSE DO:
            ENABLE btAddSon1 btUpdateSon1 btDeleteSon1 WITH FRAME fPage1.
            ASSIGN btn-muda-sequencia:SENSITIVE IN FRAME fPage1 = IF log-perm-pto-control-imp AND i-modificacao = 0 THEN YES ELSE NO.
        END.
    
        IF NOT log-perm-pto-control-imp OR l-possui-decl-emitida THEN
            DISABLE btn-modifica-ptos btn-muda-sequencia WITH FRAME fPage1.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon2
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon2 wMasterDetail
ON VALUE-CHANGED OF brSon2 IN FRAME fPage2
DO:
    /* Se estiver modificando os registros */
    IF i-modificacao <> 0 THEN DO:
        IF i-modificacao = 3 /* btn Modificaá∆o de despesa */ THEN DO:
            SELF:SELECT-ROW(i-linha-browse) NO-ERROR. /* Impede que a linha do browse seja alterada durante a modificaá∆o. */
            RETURN.
        END.
    END.
    
    /* Habilita ou desabilita o  bot∆o "modificar" */
    IF AVAIL tt-historico-embarque AND i-modificacao = 0 THEN DO:
        IF NOT l-possui-di AND log-perm-pto-despes-imp AND CAN-FIND(FIRST historico-embarque
                                                                    WHERE historico-embarque.cod-estabel   = tt-historico-embarque.cod-estabel
                                                                      AND historico-embarque.embarque      = tt-historico-embarque.embarque 
                                                                      AND historico-embarque.cod-itiner    = tt-historico-embarque.cod-itiner
                                                                      AND historico-embarque.cod-pto-contr = tt-desp-embarque.cod-pto-contr
                                                                      AND historico-embarque.dt-efetiva    = ?) THEN
            ASSIGN btn-modifica-desp:SENSITIVE IN FRAME fPage2 = YES.
        ELSE
            ASSIGN btn-modifica-desp:SENSITIVE IN FRAME fPage2 = NO.
    END.
    
    ASSIGN btUpdateSon2:SENSITIVE IN FRAME fPage2 = NOT l-possui-di AND AVAIL {&ttSon2}
           btDeleteSon2:SENSITIVE IN FRAME fPage2 = NOT l-possui-di AND AVAIL {&ttSon2}.

    IF CAN-FIND(FIRST desp-embarque
                WHERE desp-embarque.cod-estabel       = {&ttSon2}.cod-estabel
                  AND desp-embarque.embarque          = {&ttSon2}.embarque
                  AND desp-embarque.cod-itiner        = {&ttSon2}.cod-itiner 
                  AND desp-embarque.cod-pto-contr     = {&ttSon2}.cod-pto-contr
                  AND desp-embarque.cod-desp          = {&ttSon2}.cod-desp
                  AND desp-embarque.cod-emitente-desp = {&ttSon2}.cod-emitente-desp
                  AND desp-embarque.log-prorate-efetd ) 
       AND i-pais-impto-usuario <> 1 THEN
        DISABLE btUpdateSon2 WITH FRAME fPage2.
        
    IF i-pais-impto-usuario <> 1 THEN DO:
        RUN piNotaComplementar.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon3
&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME brSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon3 wMasterDetail
ON VALUE-CHANGED OF brSon3 IN FRAME fPage3
DO:
    IF AVAIL {&ttSon3} THEN DO:
        /* Se estiver modificando os registros */
        IF i-modificacao <> 0 THEN DO:
            IF i-modificacao = 4 /* btn Modificaá∆o de declaraá∆o */ THEN DO:
                SELF:SELECT-ROW(i-linha-browse) NO-ERROR. /* Impede que a linha do browse seja alterada durante a modificaá∆o. */
                RETURN.
            END.
        END.
        
        /* Habilita ou desabilita o  bot∆o "modificar" */
        IF AVAIL {&ttParent} AND i-modificacao = 0 THEN DO:
            IF NOT l-possui-di AND NOT {&ttSon3}.decl-emitida AND log-perm-pto-decla-imp AND 
                CAN-FIND(FIRST historico-embarque
                         WHERE historico-embarque.cod-estabel = {&ttParent}.cod-estabel
                           AND historico-embarque.embarque    = {&ttParent}.embarque 
                           AND historico-embarque.cod-itiner  = {&ttParent}.cod-itiner
                           AND historico-embarque.sequencia   = {&ttSon3}.sequencia
                           AND historico-embarque.dt-efetiva  = ?) THEN DO:
                ASSIGN btn-modifica-decl:SENSITIVE IN FRAME fPage3 = YES.
            END.
            ELSE DO:
                ASSIGN btn-modifica-decl:SENSITIVE IN FRAME fPage3 = NO.
            END.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME bt-calc-desp-itiner
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-calc-desp-itiner wMasterDetail
ON CHOOSE OF bt-calc-desp-itiner IN FRAME fPage0 /* Calcula Despesas Itiner†rio */
DO:

    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 55462,
                       INPUT "").
    IF RETURN-VALUE = "YES" THEN DO:
        RUN pi-seta-recalculo   IN h-bocx225 (INPUT YES).
        RUN piCalculaDespItiner IN h-bocx225 (INPUT INPUT FRAME fPage0 tt-historico-embarque.cod-estabel, 
                                              INPUT INPUT FRAME fPage0 tt-historico-embarque.embarque).

        /* ATUALIZA O BROWSE COM OS REGISTROS ATUAIS */
        RUN bringParent IN THIS-PROCEDURE.
        RUN openQueriesSon IN THIS-PROCEDURE.
        RUN afterDisplayFields IN THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-vincula-drb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-vincula-drb wMasterDetail
ON CHOOSE OF bt-vincula-drb IN FRAME fPage0 /* Vincula Drawback */
DO:

    IF AVAIL tt-historico-embarque THEN DO:

        RUN getAtoConcessorioEmbarque IN h-bocx225 (input tt-historico-embarque.cod-estabel,
                                                    INPUT tt-historico-embarque.embarque,
                                                    OUTPUT c-nr-ato-concessorio).

        RUN imp/im0045ac.w (INPUT c-nr-ato-concessorio,
                            input tt-historico-embarque.cod-estabel,
                            INPUT tt-historico-embarque.embarque,
                            OUTPUT c-nr-ato-atual).

        RUN AtualizaEmbarqueAtoConcessorio in h-bocx225 (input tt-historico-embarque.cod-estabel,
                                                         input tt-historico-embarque.embarque,
                                                         input c-nr-ato-atual).

        RUN afterDisplayFields IN THIS-PROCEDURE.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="imp/im0055a.w"
                           &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btAddSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon2 wMasterDetail
ON CHOOSE OF btAddSon2 IN FRAME fPage2 /* Incluir */
DO:
    ASSIGN c-acao = "ADD":U
           r-row-hist = tt-historico-embarque.r-rowid.
    RUN imp/im0055dd.w (input tt-historico-embarque.r-rowid, input THIS-PROCEDURE, input 2).
    
    /*RUN initializeDBOs IN THIS-PROCEDURE.*/ /* Perde a instÉncia das handles ao adicionar, por isso Ç necess†rio reinstanciar */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btAddSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon3 wMasterDetail
ON CHOOSE OF btAddSon3 IN FRAME fPage3 /* Incluir */
DO:
    ASSIGN c-acao = "ADD":U.
    RUN imp/im0055dm.w (input {&ttParent}.r-rowid, input THIS-PROCEDURE, input 3).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMasterDetail
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:
    ASSIGN c-embarque    = tt-historico-embarque2.embarque
           c-cod-estabel = tt-historico-embarque2.cod-estabel
           i-cod-itiner  = tt-historico-embarque2.cod-itiner
           i-sequen      = tt-historico-embarque2.sequencia
           i-pto-contr   = tt-historico-embarque2.cod-pto-contr.


    /* Recalcular datas de £ltima previs∆o */
    RUN setRecalcula IN h-bocx2302 (INPUT tt-historico-embarque2.log-1).
    
    {masterdetail/deleteson.i &PageNumber="1"}
    
    
    /* reposiciona o registro */
    DEFINE VARIABLE cStatus AS CHARACTER NO-UNDO.
    DEFINE VARIABLE rGoTo   AS ROWID NO-UNDO.
    RUN findEmbarque IN {&hDBOParent} (INPUT tt-historico-embarque.cod-estabel, 
                                       INPUT tt-historico-embarque.embarque,
                                       OUTPUT cStatus).
    
    RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
    /* fim - reposiciona o registro */
   
    RUN atualsitemb IN h-bocx220 (INPUT tt-historico-embarque.cod-estabel,
                                  INPUT tt-historico-embarque.embarque).    
    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDeleteSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon2 wMasterDetail
ON CHOOSE OF btDeleteSon2 IN FRAME fPage2 /* Eliminar */
DO:
    if  avail tt-desp-embarque then do:
        assign r-desp-emb = tt-desp-embarque.r-rowid.
        
        &IF DEFINED(bf_mat_versao_ems) &THEN
        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.04" &THEN
        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
            IF tt-desp-embarque.log-forma-preco-compra THEN DO:
        &ELSE
            IF SUBSTRING(tt-desp-embarque.char-1,4,1) = "1" THEN DO:
        &ENDIF
        &ENDIF
                CREATE tt-bo-erro.
                ASSIGN tt-bo-erro.errorsubtype = "Question".
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 31454,
                                   INPUT "").
             
                IF  RETURN-VALUE = "NO" THEN DO:
                    SESSION:SET-WAIT-STATE("":U).
                    RETURN NO-APPLY.
                END.
                ELSE DO:
                    ASSIGN l-st-zera-taxa = NO.
                    IF  l-tax-siscomex AND i-desp-siscomex = tt-desp-embarque.cod-desp THEN DO:
                        RUN utp/ut-msgs.p (INPUT "show":U,
                                           INPUT 33679,
                                           INPUT "").
                        IF  RETURN-VALUE = "NO" THEN
                            RETURN NO-APPLY.
                        
                        ASSIGN l-st-zera-taxa = YES.
                    END.
                    
                    RUN validateDelete in {&hDBOSon2} (input-output r-desp-emb, 
                                                        output table tt-bo-erro).
                    if  can-find(first tt-bo-erro) then do:
                        IF  NOT VALID-HANDLE(hShowMsg) THEN
                            RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
                        
                        RUN showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).
                    end.
                    else do:
                        IF l-st-zera-taxa THEN
                           RUN pi-zerar-taxa-siscomex IN h-bocx225e (INPUT tt-historico-embarque.cod-estabel,
                                                                     INPUT tt-historico-embarque.embarque).
                
                        
                        RUN pi-siscoserv-ativo IN h-cdapi050.
                        IF RETURN-VALUE = "OK":U THEN
                            RUN pi-apaga-despes-import-sis IN h-cdapi050 (INPUT tt-desp-embarque.cod-estabel,
                                                                          INPUT tt-desp-embarque.embarque,
                                                                          INPUT tt-desp-embarque.cod-itiner,
                                                                          INPUT tt-desp-embarque.cod-pto-contr,
                                                                          INPUT tt-desp-embarque.cod-desp,
                                                                          INPUT tt-desp-embarque.cod-emitente-desp).
                
                        CREATE tt-bo-erro.
                        ASSIGN tt-bo-erro.errorsubtype = "WARNING".
                        RUN utp/ut-msgs.p (INPUT "show":U,
                                           INPUT 31453,
                                           INPUT "").
                    end.
                END.
        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.04" &THEN
            END.
            ELSE DO:
        &ENDIF
        &ENDIF
            &if "{&bf_mat_versao_ems}":U >= "2.06":U &then
                FIND FIRST item-doc-est-cex
                     WHERE item-doc-est-cex.cod-estabel  = tt-desp-embarque.cod-estabel
                       AND item-doc-est-cex.embarque     = tt-desp-embarque.embarque   
                       AND item-doc-est-cex.cod-desp     = tt-desp-embarque.cod-desp NO-LOCK NO-ERROR.
            &else   
                FIND FIRST item-doc-est-cex
                     WHERE TRIM(SUBSTR(item-doc-est-cex.char-1,13,3)) = tt-desp-embarque.cod-estabel
                       AND TRIM(SUBSTR(item-doc-est-cex.char-1,1,12)) = tt-desp-embarque.embarque   
                       AND item-doc-est-cex.cod-desp                  = tt-desp-embarque.cod-desp NO-LOCK NO-ERROR.
            &endif 
             
            IF  AVAIL item-doc-est-cex THEN DO:
                RUN utp/ut-msgs.p (input "Show":U, 
                                   input 33661, 
                                   input item-doc-est-cex.nro-docto    + "~~" + 
                                         item-doc-est-cex.serie-docto  + "~~" + 
                                         item-doc-est-cex.nat-operacao + "~~" + 
                                         STRING(item-doc-est-cex.cod-emitente)).
            END.
            ELSE DO:
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Despesa" *}
                RUN utp/ut-msgs.p (input "Show":U, input 550, input RETURN-VALUE).
            END.
            if  return-value = "yes" then do:
                 
                ASSIGN l-st-zera-taxa = NO.
                IF  l-tax-siscomex AND i-desp-siscomex = tt-desp-embarque.cod-desp THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show":U,
                                       INPUT 33679,
                                       INPUT "").
                    IF  RETURN-VALUE = "NO" THEN
                        RETURN NO-APPLY.
                     
                    ASSIGN l-st-zera-taxa = YES.
                END.
                 
                RUN validateDelete in {&hDBOSon2} (input-output r-desp-emb, 
                                                   output table tt-bo-erro).
                if  can-find(first tt-bo-erro) then do:
                    IF NOT VALID-HANDLE(hShowMsg) THEN
                        RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
                     RUN showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).
                end.
                else do:
                    IF l-st-zera-taxa THEN
                        RUN pi-zerar-taxa-siscomex IN h-bocx225e (INPUT tt-historico-embarque.cod-estabel,
                                                                  INPUT tt-historico-embarque.embarque).
                     
                    RUN pi-siscoserv-ativo IN h-cdapi050.
                    IF RETURN-VALUE = "OK":U THEN
                        RUN pi-apaga-despes-import-sis IN h-cdapi050 (INPUT  tt-desp-embarque.cod-estabel,
                                                                      INPUT  tt-desp-embarque.embarque,
                                                                      INPUT  tt-desp-embarque.cod-itiner,
                                                                      INPUT  tt-desp-embarque.cod-pto-contr,
                                                                      INPUT  tt-desp-embarque.cod-desp,
                                                                      INPUT  tt-desp-embarque.cod-emitente-desp).
                end.  
            end.
        &IF DEFINED(bf_mat_versao_ems) &THEN
        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.04" &THEN
        END.
        &ENDIF
        &ENDIF
    end.

    RUN openQueriesSon IN THIS-PROCEDURE.
    APPLY "entry":U TO brSon2 IN FRAME fPage2.

    IF  NUM-RESULTS("brSon2":U) > 0 THEN
        BROWSE brSon2:SELECT-FOCUSED-ROW() NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btDeleteSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon3 wMasterDetail
ON CHOOSE OF btDeleteSon3 IN FRAME fPage3 /* Eliminar */
DO:
    def var r-decl-hist-embarq-imp as rowid no-undo.

    if avail {&ttSon3} then do:
        assign r-decl-hist-embarq-imp = {&ttSon3}.r-rowid.
        
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Declaraá∆o" *}
        RUN utp/ut-msgs.p (input "Show", input 550, input RETURN-VALUE).
        if return-value = "yes" then do:
            RUN validateDelete in {&HdboSon3} (input-output r-decl-hist-embarq-imp, 
                                                output table rowErrors).
            if can-find(first rowErrors) then do:
                IF NOT VALID-HANDLE(hShowMsg) THEN
                    RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
                RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
            end.
            RUN openQueriesSon IN THIS-PROCEDURE.
            APPLY "entry":U TO brSon3 IN FRAME fPage3.
            IF  NUM-RESULTS("brSon3":U) > 0 THEN
                BROWSE brSon3:SELECT-FOCUSED-ROW() NO-ERROR.
        end.
    end.
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


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMasterDetail
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMasterDetail
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMasterDetail
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLoad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLoad wMasterDetail
ON CHOOSE OF btLoad IN FRAME fPage0 /* Load */
do:
        
    &if "{&bf_mat_versao_ems}":U >= "2.062":U &then

    if  valid-handle (h-bocx220) then
        run rowidEmbarque in h-bocx220 (input tt-historico-embarque.cod-estabel,
                                        input tt-historico-embarque.embarque,  
                                        output r-rowid-embarque).

    run imp/im0041.w (input ?,
                      input r-rowid-embarque,
                      input yes).
    &endif

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btn-cancela-decl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-cancela-decl wMasterDetail
ON CHOOSE OF btn-cancela-decl IN FRAME fPage3
DO:
    RUN enableDisableWidgets IN THIS-PROCEDURE.
    ASSIGN btn-confirma-decl:SENSITIVE IN FRAME fPage3 = NO
           btn-cancela-decl:SENSITIVE IN FRAME fPage3 = NO
           i-modificacao = 0.
           
    RUN openQueriesSon IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btn-cancela-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-cancela-desp wMasterDetail
ON CHOOSE OF btn-cancela-desp IN FRAME fPage2
DO:
    RUN enableDisableWidgets IN THIS-PROCEDURE.

    ASSIGN btn-confirma-desp:SENSITIVE IN FRAME fPage2 = NO
           btn-cancela-desp:SENSITIVE IN FRAME fPage2 = NO
           i-modificacao = 0.
           
    RUN openQueriesSon IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btn-cancela-ptos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-cancela-ptos wMasterDetail
ON CHOOSE OF btn-cancela-ptos IN FRAME fPage1
DO:
    RUN enableDisableWidgets IN THIS-PROCEDURE.

    ASSIGN btn-confirma-ptos:SENSITIVE IN FRAME fPage1 = NO
           btn-cancela-ptos:SENSITIVE IN FRAME fPage1 = NO
           i-modificacao = 0.
           
    RUN openQueriesSon IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btn-confirma-decl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-confirma-decl wMasterDetail
ON CHOOSE OF btn-confirma-decl IN FRAME fPage3
DO:
    FIND CURRENT {&ttSon3} NO-LOCK NO-ERROR.

    EMPTY TEMP-TABLE {&ttSon3}-bo.
    EMPTY TEMP-TABLE tt-bo-erro. 

    CREATE {&ttSon3}-bo.
    BUFFER-COPY {&ttSon3} TO {&ttSon3}-bo.

    RUN pi-valida-decl-acomp IN h-bocx280(INPUT TABLE {&ttSon3}-bo,
                                          OUTPUT TABLE tt-bo-erro APPEND). 
    
    IF NOT CAN-FIND(FIRST tt-bo-erro) THEN DO:
        FOR FIRST {&ttSon3}-bo: END.
        RUN validateUpdate IN h-bocx280 (INPUT TABLE {&ttSon3}-bo,
                                         INPUT {&ttSon3}-bo.r-rowid,
                                         OUTPUT TABLE tt-bo-erro APPEND).
    END.

    /* Se ocorrerem erros, exibe em tela */
    IF CAN-FIND(FIRST tt-bo-erro) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN
           RUN utp/showmessage.w PERSISTENT SET hShowMsg.
        RUN showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).
        WAIT-FOR CLOSE OF hShowMsg FOCUS CURRENT-WINDOW.
        IF VALID-HANDLE(hShowMsg) THEN
            DELETE PROCEDURE hShowMsg.
        APPLY "ROW-ENTRY":U TO BROWSE brSon3.
        RUN getFieldErrors IN h-bocx280 (OUTPUT TABLE tt-campo-erro).
        RUN focusBrowseField IN THIS-PROCEDURE (INPUT TABLE tt-campo-erro,
                                                INPUT 3).
        RETURN NO-APPLY.
    END.

    RUN enableDisableWidgets IN THIS-PROCEDURE.
    ASSIGN btn-confirma-decl:SENSITIVE IN FRAME fPage3 = NO
           btn-cancela-decl:SENSITIVE IN FRAME fPage3 = NO.
    RUN openQueriesSon IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btn-confirma-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-confirma-desp wMasterDetail
ON CHOOSE OF btn-confirma-desp IN FRAME fPage2
DO:
    FIND CURRENT tt-desp-embarque NO-LOCK NO-ERROR.

    EMPTY TEMP-TABLE tt-desp-embarque-bo.
    EMPTY TEMP-TABLE tt-bo-erro. 

    CREATE tt-desp-embarque-bo.
    BUFFER-COPY tt-desp-embarque TO tt-desp-embarque-bo.

    RUN pi-valida-despesa-acomp IN h-bocx310 (INPUT TABLE tt-desp-embarque-bo,
                                              INPUT i-desp-ant, /*validaá∆o para o internacional*/
                                              OUTPUT TABLE tt-bo-erro APPEND).

    IF NOT CAN-FIND(FIRST tt-bo-erro) THEN DO:
        RUN validateUpdate IN h-bocx310 (INPUT TABLE tt-desp-embarque-bo,
                                         INPUT tt-desp-embarque-bo.r-rowid,
                                         OUTPUT TABLE tt-bo-erro APPEND).
    END.

    /* Se ocorrerem erros, exibe em tela */
    IF CAN-FIND(FIRST tt-bo-erro) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN
           RUN utp/showmessage.w PERSISTENT SET hShowMsg.
        RUN showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).
        WAIT-FOR CLOSE OF hShowMsg FOCUS CURRENT-WINDOW.
        IF VALID-HANDLE(hShowMsg) THEN
            DELETE PROCEDURE hShowMsg.
        APPLY "ROW-ENTRY":U TO BROWSE brSon2.
        RUN getFieldErrors IN h-bocx310 (OUTPUT TABLE tt-campo-erro).
        RUN focusBrowseField IN THIS-PROCEDURE (INPUT TABLE tt-campo-erro,
                                                INPUT 2).
        RETURN NO-APPLY.
    END.
  
    ASSIGN btn-confirma-desp:SENSITIVE IN FRAME fPage2 = NO
           btn-cancela-desp:SENSITIVE IN FRAME fPage2 = NO.

    RUN enableDisableWidgets IN THIS-PROCEDURE.
    RUN openQueriesSon IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btn-confirma-ptos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-confirma-ptos wMasterDetail
ON CHOOSE OF btn-confirma-ptos IN FRAME fPage1
DO:
    EMPTY TEMP-TABLE tt-bo-erro.
    EMPTY TEMP-TABLE tt-historico-embarque-bo.

    IF i-modificacao = 2 /* Modificaá∆o de registros */ THEN DO:
        IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
            IF  VALID-HANDLE(h-boar0138) THEN DO:
                RUN validaIm0055a IN h-boar0138(INPUT tt-historico-embarque2.cod-pto-contr:screen-value in BROWSE brSon1,
                                                INPUT tt-historico-embarque.cod-itiner:screen-value in frame fpage0,
                                                INPUT tt-historico-embarque.cod-estabel:screen-value in frame fpage0,
                                                INPUT tt-historico-embarque.embarque:screen-value in frame fpage0,
                                                INPUT tt-historico-embarque2.sequencia:screen-value in BROWSE brSon1,
                                                INPUT ROWID(tt-historico-embarque)).
            END.
        END.
        
        FIND CURRENT tt-historico-embarque2 NO-ERROR.
        IF AVAIL tt-historico-embarque2 THEN DO:
            RUN setRecalcula   IN h-bocx230 (INPUT tt-historico-embarque2.log-1).

            /* Criaá∆o da tt auxiliar passada para a BO para ser efetivada. */
            CREATE tt-historico-embarque-bo.
            BUFFER-COPY tt-historico-embarque2 TO tt-historico-embarque-bo.

            /* Licenciamento Importacao */
            &if '{&bf_mat_versao_ems}' >= '2.062':U  &then
                IF tt-historico-embarque2.dt-efetiva <> ? THEN DO:
                    run piValidaEfetivacaoEmbarque in THIS-PROCEDURE (INPUT TABLE tt-historico-embarque-bo).
                    if  return-value = "NOK":U then
                        return no-apply.
                END.
            &endif
            /* Efetiva o ponto de controle */
            RUN validateupdate IN h-bocx230 (INPUT TABLE tt-historico-embarque-bo,
                                             INPUT tt-historico-embarque-bo.r-rowid,
                                             OUTPUT TABLE tt-bo-erro).
        END.
    END.
    ELSE IF i-modificacao = 1 /* Alteraá∆o de sequàncias */ THEN DO:
        APPLY "ENTRY":U TO FRAME fPage0. /* retira foco */

        /* Validaá∆o de sequància duplicada no browse */
        FOR EACH tt-historico-embarque2:
            IF CAN-FIND(FIRST bf-tt-historico-embarque2
                        WHERE bf-tt-historico-embarque2.cod-estabel = tt-historico-embarque2.cod-estabel
                          AND bf-tt-historico-embarque2.embarque    = tt-historico-embarque2.embarque
                          AND bf-tt-historico-embarque2.cod-itiner  = tt-historico-embarque2.cod-itiner 
                          AND bf-tt-historico-embarque2.sequencia   = tt-historico-embarque2.sequencia
                          AND bf-tt-historico-embarque2.r-rowid    <> tt-historico-embarque2.r-rowid
                          AND NOT CAN-FIND(FIRST tt-bo-erro
                                           WHERE tt-bo-erro.cd-erro = 51975)) THEN DO:
                RUN utp/ut-msgs.p (INPUT "msg":U,
                                   INPUT 51975,
                                   INPUT ?).
                CREATE tt-bo-erro.
                ASSIGN tt-bo-erro.i-sequen     = 1
                       tt-bo-erro.cd-erro      = 51975
                       tt-bo-erro.mensagem     = RETURN-VALUE.

                RUN utp/ut-msgs.p (INPUT "HELP":U,
                                   INPUT 51975,
                                   INPUT STRING(tt-historico-embarque2.sequencia)).
                ASSIGN tt-bo-erro.errorhelp = RETURN-VALUE.
            END.
            IF NOT CAN-FIND(FIRST tt-bo-erro) THEN DO:
                IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
                    IF  VALID-HANDLE(h-boar0138) THEN DO:
                        RUN validaIm0055a IN h-boar0138(INPUT tt-historico-embarque2.cod-pto-contr,
                                                        INPUT INT(tt-historico-embarque.cod-itiner:screen-value in frame fpage0),
                                                        INPUT tt-historico-embarque.cod-estabel:screen-value in frame fpage0,
                                                        INPUT tt-historico-embarque.embarque:screen-value in frame fpage0,
                                                        INPUT tt-historico-embarque2.sequencia,
                                                        INPUT ROWID(tt-historico-embarque)).
                    END.
                END.
                CREATE tt-historico-embarque-bo.
                BUFFER-COPY tt-historico-embarque2 TO tt-historico-embarque-bo.
            END.
        END.

        IF NOT CAN-FIND(FIRST tt-bo-erro) THEN DO:
            RUN cxbo/bocx230a.p PERSISTENT SET h-bocx230.
            
            /* Efetiva o ponto de controle */
            RUN setRecalcula   IN h-bocx230 (INPUT YES).

            RUN validateUpdateAcomp IN h-bocx230 (INPUT TABLE tt-historico-embarque-bo,
                                                  INPUT ?,
                                                  OUTPUT TABLE tt-bo-erro).
        END.
    END.

    /* Se ocorrerem erros, exibe em tela */
    IF CAN-FIND(FIRST tt-bo-erro) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN
           RUN utp/showmessage.w PERSISTENT SET hShowMsg.
        RUN showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).
        WAIT-FOR CLOSE OF hShowMsg FOCUS CURRENT-WINDOW.
        IF VALID-HANDLE(hShowMsg) THEN
            DELETE PROCEDURE hShowMsg.
        
        APPLY "ROW-ENTRY":U TO BROWSE brSon1.
        IF i-modificacao = 1 /* alterar sequencias */ THEN DO:
            APPLY "LEAVE":U TO tt-historico-embarque2.sequencia IN BROWSE brSon1.
            APPLY "ENTRY":U TO tt-historico-embarque2.sequencia IN BROWSE brSon1.
        END.                                                                     
        ELSE IF i-modificacao = 2 /*modificar*/ THEN DO:
            RUN getFieldErrors IN h-bocx230 (OUTPUT TABLE tt-campo-erro).
            RUN focusBrowseField IN THIS-PROCEDURE (INPUT TABLE tt-campo-erro,
                                                    INPUT 1).
        END.
    END.
    ELSE DO:
        ASSIGN tt-historico-embarque2.sequencia:READ-ONLY IN BROWSE brSon1 = YES
               btn-confirma-ptos:SENSITIVE IN FRAME fPage1 = NO
               btn-cancela-ptos:SENSITIVE IN FRAME fPage1 = NO.
    
        RUN bringParent IN THIS-PROCEDURE.
        RUN openQueriesSon IN THIS-PROCEDURE.
        RUN afterDisplayFields IN THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-efetiva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-efetiva wMasterDetail
ON CHOOSE OF btn-efetiva IN FRAME fPage1
DO:
    efetiva_ponto:
    DO TRANS ON ERROR  UNDO efetiva_ponto, LEAVE efetiva_ponto
             ON ENDKEY UNDO efetiva_ponto, LEAVE efetiva_ponto
             ON STOP   UNDO efetiva_ponto, LEAVE efetiva_ponto:
        IF NOT AVAIL tt-historico-embarque2 THEN LEAVE efetiva_ponto.

        EMPTY TEMP-TABLE tt-historico-embarque-bo.
        EMPTY TEMP-TABLE tt-bo-erro.

        /* Criaá∆o da tt auxiliar passada para a BO para ser efetivada. */
        CREATE tt-historico-embarque-bo.
        BUFFER-COPY tt-historico-embarque2 TO tt-historico-embarque-bo.
        ASSIGN tt-historico-embarque-bo.dt-efetiva  = TODAY.

        /* Licenciamento Importacao */
        &if '{&bf_mat_versao_ems}' >= '2.062':U  &then
            run piValidaEfetivacaoEmbarque in THIS-PROCEDURE (INPUT TABLE tt-historico-embarque-bo).
            if  return-value = "NOK":U then
                return no-apply.
        &endif

        /* Efetiva o ponto de controle */
        RUN setRecalcula   IN h-bocx230 (INPUT tt-historico-embarque2.log-1).

        RUN validateupdate IN h-bocx230 (INPUT TABLE tt-historico-embarque-bo,
                                         INPUT tt-historico-embarque-bo.r-rowid,
                                         OUTPUT TABLE tt-bo-erro).

        /* Se ocorrerem erros, exibe em tela */
        IF CAN-FIND(FIRST tt-bo-erro) THEN DO:
            IF NOT VALID-HANDLE(hShowMsg) THEN
               RUN utp/showmessage.w PERSISTENT SET hShowMsg.
            RUN showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).
            WAIT-FOR CLOSE OF hShowMsg FOCUS CURRENT-WINDOW.
            IF VALID-HANDLE(hShowMsg) THEN
                DELETE PROCEDURE hShowMsg.
            UNDO efetiva_ponto, RETURN NO-APPLY.
        END.
        ELSE DO: /* Sen∆o ocorrer erro, copia o registro para a temp-table em tela */
            BUFFER-COPY tt-historico-embarque-bo TO tt-historico-embarque2.
        END.
    END.

    /* ATUALIZA O BROWSE COM OS REGISTROS ATUAIS */
    RUN bringParent IN THIS-PROCEDURE.
    RUN openQueriesSon IN THIS-PROCEDURE.
    RUN afterDisplayFields IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btn-filter-decl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-filter-decl wMasterDetail
ON CHOOSE OF btn-filter-decl IN FRAME fPage3
DO:
    RUN showFilter(INPUT 3).
    RUN openQueryDeclEmbarque IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btn-filter-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-filter-desp wMasterDetail
ON CHOOSE OF btn-filter-desp IN FRAME fPage2
DO:
    RUN showFilter(INPUT 2).
    RUN openQueryDespEmbarque IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btn-modifica-decl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-modifica-decl wMasterDetail
ON CHOOSE OF btn-modifica-decl IN FRAME fPage3
DO:
    /* Habilita campos para modificaá∆o */
    ASSIGN brSon3:READ-ONLY IN FRAME fPage3 = NO.

    /* Cancela as demais ediá‰es */
    CASE i-modificacao:
        WHEN 2 THEN DO:
            APPLY "CHOOSE":U TO btn-cancela-ptos IN FRAME fPage1.
        END.
        WHEN 3 THEN DO:
            APPLY "CHOOSE":U TO btn-cancela-desp IN FRAME fPage2.
        END.
    END CASE.

    ASSIGN i-modificacao = 4 /* Modificaá∆o de declaraá∆o */
           SELF:SENSITIVE IN FRAME fPage3 = NO
           btn-confirma-decl:SENSITIVE IN FRAME fPage3 = YES
           btn-cancela-decl:SENSITIVE IN FRAME fPage3 = YES
           btn-filter-decl:SENSITIVE IN FRAME fPage3 = NO
           i-linha-browse = brSon3:FOCUSED-ROW.

    {&ttSon3}.cod-pto-contr:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in BROWSE brSon3.
    {&ttSon3}.de-codigo:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in BROWSE brSon3.
    APPLY "ENTRY":U TO {&ttSon3}.cod-pto-contr IN BROWSE brSon3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btn-modifica-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-modifica-desp wMasterDetail
ON CHOOSE OF btn-modifica-desp IN FRAME fPage2
DO:
    /* Habilita campos para modificaá∆o */
    ASSIGN brSon2:READ-ONLY IN FRAME fPage2 = NO.

    /* Cancela as demais ediá‰es */
    CASE i-modificacao:
        WHEN 2 THEN DO:
            APPLY "CHOOSE":U TO btn-cancela-ptos IN FRAME fPage1.
        END.
        WHEN 4 THEN DO:
            APPLY "CHOOSE":U TO btn-cancela-decl IN FRAME fPage3.
        END.
    END CASE.

    ASSIGN i-modificacao = 3 /* Modificaá∆o de despesa */
           SELF:SENSITIVE IN FRAME fPage2 = NO
           btn-confirma-desp:SENSITIVE IN FRAME fPage2 = YES
           btn-cancela-desp:SENSITIVE IN FRAME fPage2 = YES
           btn-filter-desp:SENSITIVE IN FRAME fPage2 = NO
           i-linha-browse = brSon2:FOCUSED-ROW.

    tt-desp-embarque.cod-pto-contr:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in BROWSE brSon2.
    tt-desp-embarque.cod-desp:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in BROWSE brSon2.
    tt-desp-embarque.cod-emitente-desp:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in BROWSE brSon2.
    tt-desp-embarque.cod-cond-pag:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in BROWSE brSon2.
    tt-desp-embarque.mo-codigo:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in BROWSE brSon2.
    APPLY "ENTRY":U TO tt-desp-embarque.cod-pto-contr IN BROWSE brSon2.

    IF i-pais-impto-usuario <> 1 AND
       CAN-FIND(FIRST desp-embarque
                WHERE desp-embarque.cod-estabel       = {&ttSon2}.cod-estabel
                  AND desp-embarque.embarque          = {&ttSon2}.embarque
                  AND desp-embarque.cod-itiner        = {&ttSon2}.cod-itiner 
                  AND desp-embarque.cod-pto-contr     = {&ttSon2}.cod-pto-contr
                  AND desp-embarque.cod-desp          = {&ttSon2}.cod-desp
                  AND desp-embarque.cod-emitente-desp = {&ttSon2}.cod-emitente-desp
                  AND desp-embarque.log-prorate-efetd) THEN
        ASSIGN tt-desp-embarque.cod-desp:READ-ONLY IN BROWSE brSon2 = YES.
    ELSE
        ASSIGN tt-desp-embarque.cod-desp:READ-ONLY IN BROWSE brSon2 = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btn-modifica-ptos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-modifica-ptos wMasterDetail
ON CHOOSE OF btn-modifica-ptos IN FRAME fPage1
DO:
    /* Habilita campos para modificaá∆o */
    ASSIGN brSon1:READ-ONLY IN FRAME fPage1 = NO
           tt-historico-embarque2.cod-pto-contr:READ-ONLY IN BROWSE brSon1 = NO
           tt-historico-embarque2.descricao:READ-ONLY IN BROWSE brSon1 = NO
           tt-historico-embarque2.dt-efetiva:READ-ONLY IN BROWSE brSon1 = NO
           tt-historico-embarque2.nr-dias:READ-ONLY IN BROWSE brSon1 = NO
           tt-historico-embarque2.log-1:READ-ONLY IN BROWSE brSon1 = NO
           tt-historico-embarque2.sequencia:READ-ONLY IN BROWSE brSon1 = YES. /* Desabilita ediá∆o  da sequencia*/.
                                                                                          
    /* Cancela as demais ediá‰es */                                                                              
    CASE i-modificacao:
        WHEN 3 THEN DO:
            APPLY "CHOOSE":U TO btn-cancela-desp IN FRAME fPage2.
        END.
        WHEN 4 THEN DO:
            APPLY "CHOOSE":U TO btn-cancela-decl IN FRAME fPage3.
        END.
    END CASE.

    ASSIGN i-modificacao = 2 /* Modificaá∆o de pontos de controle */
           SELF:SENSITIVE IN FRAME fPage1 = NO
           btn-muda-sequencia:SENSITIVE IN FRAME fPage1 = NO
           btn-efetiva:SENSITIVE IN FRAME fPage1 = NO
           btn-confirma-ptos:SENSITIVE IN FRAME fPage1 = YES
           btn-cancela-ptos:SENSITIVE IN FRAME fPage1 = YES
           i-linha-browse = brSon1:FOCUSED-ROW.

    tt-historico-embarque2.cod-pto-contr:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in BROWSE brSon1.
    APPLY "ENTRY":U TO tt-historico-embarque2.cod-pto-contr IN BROWSE brSon1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-muda-sequencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-muda-sequencia wMasterDetail
ON CHOOSE OF btn-muda-sequencia IN FRAME fPage1
DO:
    ASSIGN i-modificacao = 1
           i-linha-browse = brSon1:FOCUSED-ROW
           tt-historico-embarque2.sequencia:READ-ONLY IN BROWSE brSon1 = NO /* Habilita ediá∆o */
           btn-confirma-ptos:SENSITIVE IN FRAME fPage1 = YES
           btn-cancela-ptos:SENSITIVE IN FRAME fPage1  = YES
           btn-efetiva:SENSITIVE IN FRAME fPage1  = NO
           btn-modifica-ptos:SENSITIVE IN FRAME fPage1 = NO
           SELF:SENSITIVE IN FRAME fPage1 = NO.

    /* Desabilita campos para modificaá∆o */
    ASSIGN brSon1:READ-ONLY IN FRAME fPage1 = NO
           tt-historico-embarque2.cod-pto-contr:READ-ONLY IN BROWSE brSon1 = YES
           tt-historico-embarque2.descricao:READ-ONLY IN BROWSE brSon1 = YES
           tt-historico-embarque2.dt-efetiva:READ-ONLY IN BROWSE brSon1 = YES
           tt-historico-embarque2.nr-dias:READ-ONLY IN BROWSE brSon1 = YES
           tt-historico-embarque2.log-1:READ-ONLY IN BROWSE brSon1 = YES.

    APPLY "ENTRY":U TO tt-historico-embarque2.sequencia IN BROWSE brSon1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:

    DEFINE VARIABLE cReturn AS CHARACTER NO-UNDO.
    def var ttrowid as rowid no-undo.
        
    for each RowErrors:
        delete RowErrors.
    end.
            
    assign ttrowid = {&ttParent}.r-rowid.
            
    RUN findNext2 IN {&hDBOParent} (OUTPUT cReturn).
    
    IF cReturn = "":U THEN DO:
        RUN getCurrent IN {&hDBOParent} (OUTPUT TABLE {&ttParent}).
        RUN displayFields IN THIS-PROCEDURE.
    END.
    ELSE DO:
         run utp/ut-msgs.p (input "msg",
                            input 7999,
                            input "").
         create RowErrors.
         assign RowErrors.errornumber   = 7999
                RowErrors.errordescription  = return-value.
         RUN findRowid in {&hDBOParent} (input ttrowid).
         if cReturn = "" then 
            RUN setCurrent in {&hDBOParent}.
    END.
    IF CAN-FIND(FIRST RowErrors) THEN DO:
         disable btLast btNext with frame fPage0.
         IF NOT VALID-HANDLE(hShowMsg) THEN
             RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
         ELSE
             DELETE PROCEDURE hShowMsg.
         
         RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
          
         LEAVE.
    END.
    enable btFirst btPrev with frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btNotaComplementar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNotaComplementar wMasterDetail
ON CHOOSE OF btNotaComplementar IN FRAME fPage2 /* NF Complementar */
DO:
    DEFINE VARIABLE h-bocx310a AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-im3101   AS HANDLE NO-UNDO.

    IF AVAIL {&ttSon2} THEN DO:
        SESSION:SET-WAIT-STATE("general":U).
        
        EMPTY TEMP-TABLE tt-selecao-embarque-im3101. 
        EMPTY TEMP-TABLE tt-desp-embarque-im3101.
        EMPTY TEMP-TABLE tt-desp-embarque-aux-im3101.
        
        CREATE tt-selecao-embarque-im3101.
        ASSIGN tt-selecao-embarque-im3101.cod-estabel = {&ttSon2}.cod-estabel
               tt-selecao-embarque-im3101.embarque    = {&ttSon2}.embarque
               tt-selecao-embarque-im3101.cod-itiner  = {&ttSon2}.cod-itiner.
        
        //Conforme l¢gica de seleá∆o de embarque no IM3101
        RUN cxbo/bocx310a.p PERSISTEN SET h-bocx310a.
        RUN piRetornaSelecaoDespesa IN h-bocx310a  (INPUT  NO,     
                                                    INPUT  {&ttSon2}.cod-emitente-desp,         
                                                    INPUT  0,       //C¢d. Gasto Ini               
                                                    INPUT  99999,   //C¢d. Gasto Fim               
                                                    INPUT  {&ttSon2}.cod-emitente-desp,            
                                                    INPUT  {&ttSon2}.cod-emitente-desp,            
                                                    INPUT  0,       //Pto. Controle Ini               
                                                    INPUT  99999,   //Pto. Controle Fim               
                                                    INPUT  TABLE tt-selecao-embarque-im3101, 
                                                    OUTPUT TABLE tt-desp-embarque-im3101).
        
        FOR EACH tt-desp-embarque-im3101:
        
           IF  tt-desp-embarque-im3101.cod-estabel       = {&ttSon2}.cod-estabel
           AND tt-desp-embarque-im3101.embarque          = {&ttSon2}.embarque
           AND tt-desp-embarque-im3101.cod-itiner        = {&ttSon2}.cod-itiner
           AND tt-desp-embarque-im3101.cod-pto-contr     = {&ttSon2}.cod-pto-contr
           AND tt-desp-embarque-im3101.cod-desp          = {&ttSon2}.cod-desp
           AND tt-desp-embarque-im3101.cod-emitente-desp = {&ttSon2}.cod-emitente-desp
           THEN
              ASSIGN tt-desp-embarque-im3101.selecionado = TRUE.
              
           IF NOT CAN-FIND(FIRST tt-desp-embarque-aux-im3101
                           WHERE tt-desp-embarque-aux-im3101.cod-estabel       = tt-desp-embarque-im3101.cod-estabel      
                           AND   tt-desp-embarque-aux-im3101.embarque          = tt-desp-embarque-im3101.embarque         
                           AND   tt-desp-embarque-aux-im3101.cod-itiner        = tt-desp-embarque-im3101.cod-itiner       
                           AND   tt-desp-embarque-aux-im3101.cod-pto-contr     = tt-desp-embarque-im3101.cod-pto-contr    
                           AND   tt-desp-embarque-aux-im3101.cod-desp          = tt-desp-embarque-im3101.cod-desp         
                           AND   tt-desp-embarque-aux-im3101.cod-emitente-desp = tt-desp-embarque-im3101.cod-emitente-desp) THEN DO:
                CREATE tt-desp-embarque-aux-im3101.
                BUFFER-COPY tt-desp-embarque-im3101 to tt-desp-embarque-aux-im3101 NO-ERROR.
           END.                     
        END.

        RUN imp/im3101.w PERSISTEN SET h-im3101.
        RUN initializeInterface IN h-im3101 NO-ERROR.
        
        RUN piSetaEmbarque        IN h-im3101(INPUT {&ttSon2}.embarque).
        RUN piSetaEstabelecimento IN h-im3101(INPUT {&ttSon2}.cod-estabel).
        RUN piSetaEmitente        IN h-im3101(INPUT {&ttSon2}.cod-emitente-desp). 
        RUN piSetaDespesa         IN h-im3101(INPUT TABLE tt-desp-embarque-im3101,
                                              INPUT TABLE tt-desp-embarque-aux-im3101).
        
        //Ajusta cotaá∆o moeda
        RUN piCotacaoMoeda IN h-im3101.
        
        SESSION:SET-WAIT-STATE("":U).
        WAIT-FOR CLOSE OF h-im3101 FOCUS h-im3101.
        
        APPLY "VALUE-CHANGED":U TO brSon2 IN FRAME fPage2.
    END.
    
    FINALLY:
        IF  VALID-HANDLE (h-bocx310a) THEN DO:
            DELETE PROCEDURE h-bocx310a.
            ASSIGN h-bocx310a = ?.
        END.    
    
        IF  VALID-HANDLE(h-im3101) THEN DO:
            DELETE PROCEDURE h-im3101.
            ASSIGN h-im3101 = ?.
        END.
    END FINALLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    DEFINE VARIABLE cReturn AS CHARACTER NO-UNDO.
    def var ttrowid as rowid no-undo.
    
    for each RowErrors:
        delete RowErrors.
    end.
    
    assign ttrowid = {&ttParent}.r-rowid.
    RUN findPrev2 IN {&hDBOParent} (OUTPUT cReturn).

    IF cReturn = "":U THEN DO:
        RUN getCurrent IN {&hDBOParent} (OUTPUT TABLE {&ttParent}).
        RUN displayFields IN THIS-PROCEDURE.
    END.
    ELSE DO:
         run utp/ut-msgs.p (input "msg",
                            input 7998,
                            input "").
         create RowErrors.
         assign RowErrors.errornumber   = 7998
                RowErrors.errordescription  = return-value.
         RUN findRowid in {&hDBOParent} (input ttrowid).
         if cReturn = "" then 
            RUN setCurrent in {&hDBOParent}.
    END.
    
    IF CAN-FIND(FIRST RowErrors) THEN DO:
         disable btPrev btFirst with frame fPage0.
         IF NOT VALID-HANDLE(hShowMsg) THEN
             RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
         ELSE
             DELETE PROCEDURE hShowMsg.
         
         RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
          
         LEAVE.
    END.
    
    enable btLast btNext with frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMasterDetail
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="cxzoom/z10cx230.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="imp/im0055a.w"
                              &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btUpdateSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon2 wMasterDetail
ON CHOOSE OF btUpdateSon2 IN FRAME fPage2 /* Alterar */
DO:
    IF AVAIL tt-desp-embarque THEN DO:

        FOR FIRST tt-historico-embarque2 NO-LOCK 
            WHERE tt-historico-embarque2.cod-estabel   = tt-historico-embarque.cod-estabel  
              and tt-historico-embarque2.embarque      = tt-historico-embarque.embarque     
              and tt-historico-embarque2.cod-itiner    = tt-historico-embarque.cod-itiner   
              and tt-historico-embarque2.cod-pto-contr = tt-desp-embarque.cod-pto-contr:
            assign r-row  = tt-desp-embarque.r-rowid
                   r-row-hist = tt-historico-embarque2.r-rowid
                   c-acao = "UPDATE":U.
        END.

        RUN imp/im0055dd.w (input r-row-hist, input THIS-PROCEDURE, input 2).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btUpdateSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon3 wMasterDetail
ON CHOOSE OF btUpdateSon3 IN FRAME fPage3 /* Modificar */
DO:
    assign r-row  = {&ttSon3}.r-rowid
           c-acao = "UPDATE":U.
    RUN imp/im0055dm.w (input {&ttParent}.r-rowid, input THIS-PROCEDURE, input 3).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME tt-historico-embarque.cod-itiner
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-historico-embarque.cod-itiner wMasterDetail
ON LEAVE OF tt-historico-embarque.cod-itiner IN FRAME fPage0 /* C¢digo Itiner†rio */
DO:
    def var cStatus as char no-undo.

    {method/referencefields.i 
    &HandleDBOLeave="h-bocx115"
    &FindMethod="findCodigo"
    &KeyValue1="integer(tt-historico-embarque.cod-itiner:SCREEN-VALUE IN FRAME fPage0)"
    &FieldName1="descricao"
    &FieldScreen1="fill-in-1"
    &Frame1="fPage0"}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-historico-embarque.embarque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-historico-embarque.embarque wMasterDetail
ON LEAVE OF tt-historico-embarque.embarque IN FRAME fPage0 /* Embarque */
DO:
    def var cStatus as char no-undo.

    RUN findCh_embarque IN h-bocx220 (INPUT tt-historico-embarque.cod-estabel:SCREEN-VALUE IN FRAME fPage0,
                                      INPUT tt-historico-embarque.embarque:SCREEN-VALUE IN FRAME fPage0,
                                      OUTPUT cStatus).
    
    if cStatus = "" then do:
        RUN getIntField in h-bocx220 (input "cdn-pto-embarq", output fill-in-2).
        RUN getIntField in h-bocx220 (input "cdn-pto-desembar", output fill-in-4).
        RUN getIntField in h-bocx220 (input "cdn-pto-despch", output i-pto-despch).
        RUN getIntField in h-bocx220 (input "cdn-pto-chegad", output i-pto-chegad).
    end.

    disp fill-in-2
         fill-in-4
         i-pto-despch    
         i-pto-chegad
         with frame fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-2 wMasterDetail
ON LEAVE OF FILL-IN-2 IN FRAME fPage0 /* Ponto Embarque */
DO:
    def var c-return as char no-undo.

    RUN findCh-itiner IN h-bocx2303 (INPUT tt-historico-embarque.cod-estabel:SCREEN-VALUE IN FRAME fPage0, 
                                     INPUT tt-historico-embarque.embarque:SCREEN-VALUE IN FRAME fPage0,    
                                     INPUT tt-historico-embarque.cod-itiner:SCREEN-VALUE IN FRAME fPage0,
                                     INPUT integer(fill-in-2:SCREEN-VALUE IN FRAME fPage0), 
                                     OUTPUT c-return).
    IF c-return = "" THEN
        RUN getCharField IN h-bocx2303 (INPUT 'descricao',
                                        OUTPUT fill-in-3).

    DISP fill-in-3 
         with frame fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-3 wMasterDetail
ON LEAVE OF FILL-IN-3 IN FRAME fPage0
DO:
  /*{method/referencefields.i 
 *    &HandleDBOLeave="h-bocx115"
 *    &FindMethod="findCodigo"
 *    &KeyValue1="integer(tt-historico-proc-imp.cod-itiner:SCREEN-VALUE IN FRAME fPage0)"
 *    &FieldName1="pto-desembarque"
 *    &FieldScreen1="fill-in-4"
 *    &Frame1="fPage0"}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-4 wMasterDetail
ON LEAVE OF FILL-IN-4 IN FRAME fPage0 /* Ponto Nacionalizaá∆o */
DO:

    def var c-return as char no-undo.

    RUN findCh-itiner IN h-bocx2303 (INPUT tt-historico-embarque.cod-estabel:SCREEN-VALUE IN FRAME fPage0, 
                                     INPUT tt-historico-embarque.embarque:SCREEN-VALUE IN FRAME fPage0,    
                                     INPUT tt-historico-embarque.cod-itiner:SCREEN-VALUE IN FRAME fPage0,
                                     INPUT integer(fill-in-4:SCREEN-VALUE IN FRAME fPage0), 
                                     OUTPUT c-return).
    IF c-return = "" THEN
        RUN getCharField IN h-bocx2303 (INPUT 'descricao',
                                        OUTPUT fill-in-5).

    DISP fill-in-5 
         with frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-pto-chegad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-pto-chegad wMasterDetail
ON LEAVE OF i-pto-chegad IN FRAME fPage0 /* Ponto Chegada/Encerramento */
DO:
    DEF VAR c-return AS CHAR NO-UNDO.

    RUN findCh-itiner IN h-bocx2303 (INPUT tt-historico-embarque.cod-estabel:SCREEN-VALUE IN FRAME fPage0, 
                                     INPUT tt-historico-embarque.embarque:SCREEN-VALUE IN FRAME fPage0,    
                                     INPUT tt-historico-embarque.cod-itiner:SCREEN-VALUE IN FRAME fPage0,
                                     INPUT INTEGER(i-pto-chegad:SCREEN-VALUE IN FRAME fPage0), 
                                     OUTPUT c-return).
    IF c-return = "" THEN
        RUN getCharField IN h-bocx2303 (INPUT 'descricao',
                                        OUTPUT c-desc-pto-chegad).

    DISP c-desc-pto-chegad 
         with frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-pto-despch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-pto-despch wMasterDetail
ON LEAVE OF i-pto-despch IN FRAME fPage0 /* Ponto Despacho */
DO:
    DEF VAR c-return AS CHAR NO-UNDO.

    RUN findCh-itiner IN h-bocx2303 (INPUT tt-historico-embarque.cod-estabel:SCREEN-VALUE IN FRAME fPage0, 
                                     INPUT tt-historico-embarque.embarque:SCREEN-VALUE IN FRAME fPage0,    
                                     INPUT tt-historico-embarque.cod-itiner:SCREEN-VALUE IN FRAME fPage0,
                                     INPUT INTEGER(i-pto-despch:SCREEN-VALUE IN FRAME fPage0), 
                                     OUTPUT c-return).
    IF c-return = "" THEN
        RUN getCharField IN h-bocx2303 (INPUT 'descricao',
                                        OUTPUT c-desc-pto-despch).

    DISP c-desc-pto-despch 
         with frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/* ***************************  Main Block  *************************** */
{utp/ut-liter.i "Altera Ponto de Controle"}
ASSIGN btn-modifica-ptos:TOOLTIP IN FRAME fPage1 = RETURN-VALUE.
{utp/ut-liter.i "Cancela Alteraá∆o Ponto de Controle"}
ASSIGN btn-cancela-ptos:TOOLTIP IN FRAME fPage1 = RETURN-VALUE.
{utp/ut-liter.i "Salva Ponto de Controle"}
ASSIGN btn-confirma-ptos:TOOLTIP IN FRAME fPage1 = RETURN-VALUE.
{utp/ut-liter.i "Efetiva Automaticamente Ponto de Controle"}
ASSIGN btn-efetiva:TOOLTIP IN FRAME fPage1 = RETURN-VALUE.
{utp/ut-liter.i "Altera Sequàncias"}
ASSIGN btn-muda-sequencia:TOOLTIP IN FRAME fPage1 = RETURN-VALUE.
{utp/ut-liter.i "Altera Despesas"}
ASSIGN btn-modifica-desp:TOOLTIP IN FRAME fPage2 = RETURN-VALUE.
{utp/ut-liter.i "Altera Declaraá∆o/Comunicaá∆o"}
ASSIGN btn-modifica-decl:TOOLTIP IN FRAME fPage3 = RETURN-VALUE.
{utp/ut-liter.i "Cancela Alteraá∆o de Despesas"}
ASSIGN btn-cancela-desp:TOOLTIP IN FRAME fPage2 = RETURN-VALUE.
{utp/ut-liter.i "Cancela Alteraá∆o de Declaraá∆o/Comunicaá∆o"}
ASSIGN btn-cancela-decl:TOOLTIP IN FRAME fPage3 = RETURN-VALUE.
{utp/ut-liter.i "Salva Despesa"}
ASSIGN btn-confirma-desp:TOOLTIP IN FRAME fPage2 = RETURN-VALUE.
{utp/ut-liter.i "Salva Declaraá∆o/Comunicaá∆o"}
ASSIGN btn-confirma-decl:TOOLTIP IN FRAME fPage3 = RETURN-VALUE.

{utp/ut-liter.i "Ponto de controle"}
ASSIGN c-lbl-pto-contr = RETURN-VALUE.
{utp/ut-liter.i "Caso confirme, o registro ser† criado no Cadastro de Pontos de Controle com este C¢digo e esta Descriá∆o."}
ASSIGN c-lbl-cadastra-pto = RETURN-VALUE.

/*****
**  ZOOMS - F5 || DB CLICK 
******************************/

/* Zoom pto controle - acompanhamento processo fpage1 */
ON  "F5", mouse-select-dblclick OF {&ttSon1}.cod-pto-contr IN BROWSE brSon1
DO:
    {method/zoomfields.i 
         &ProgramZoom="cxzoom/z10cx110.w"
         &FieldZoom1="cod-pto-contr"
         &FieldScreen1="{&ttSon1}.cod-pto-contr"
         &browse1=brSon1
         &FieldZoom2="descricao"
         &FieldScreen2="{&ttSon1}.descricao"
         &browse2=brSon1}
END.

/* Zoom pto controle - despesas fpage2 */
ON  "F5", mouse-select-dblclick OF {&ttSon2}.cod-pto-contr IN BROWSE brSon2
DO: 

    IF CAN-FIND(FIRST desp-embarque
                WHERE desp-embarque.cod-estabel       = {&ttSon2}.cod-estabel
                  AND desp-embarque.embarque          = {&ttSon2}.embarque
                  AND desp-embarque.cod-itiner        = {&ttSon2}.cod-itiner 
                  AND desp-embarque.cod-pto-contr     = {&ttSon2}.cod-pto-contr
                  AND desp-embarque.cod-desp          = {&ttSon2}.cod-desp
                  AND desp-embarque.cod-emitente-desp = {&ttSon2}.cod-emitente-desp
                  AND  NOT desp-embarque.log-prorate-efetd) 
       AND i-pais-impto-usuario <> 1 THEN DO:

        {method/zoomfields.i &ProgramZoom="cxzoom/z01cx310.w"
                         &FieldZoom1="cod-pto-contr"
                         &FieldScreen1="{&ttSon2}.cod-pto-contr"
                         &browse1=brSon2
                         &RunMethod="RUN setaVariable IN hProgramZoom (INPUT tt-historico-embarque.r-rowid)."
                         &EnableImplant="no"}
        WAIT-FOR "CLOSE":U OF hProgramZoom.
        APPLY "LEAVE":U TO {&ttSon2}.cod-pto-contr IN BROWSE brSon2.
    END.
END.

/* Zoom cod despesa - despesas fpage2 */
ON  "F5", mouse-select-dblclick OF {&ttSon2}.cod-desp IN BROWSE brSon2
DO:
    {method/zoomfields.i 
         &ProgramZoom="cxzoom/z10cx095.w"
         &FieldZoom1="cod-desp"
         &FieldScreen1="{&ttSon2}.cod-desp"
         &browse1=brSon2
         &FieldZoom2="descricao"
         &FieldScreen2="c-desc-desp"
         &browse2=brSon2}
END.

/* Zoom cod emitente despesa - despesas fpage2 */
ON  "F5", mouse-select-dblclick OF {&ttSon2}.cod-emitente-desp IN BROWSE brSon2
DO:
    {method/zoomfields.i 
         &ProgramZoom="adzoom/z10ad098.w"
         &FieldZoom1="cod-emitente"
         &FieldScreen1="{&ttSon2}.cod-emitente-desp"
         &browse1=brSon2
         &FieldZoom2="nome-abrev"
         &FieldScreen2="c-desc-emit-desp"
         &browse2=brSon2}
END.

/* Zoom cod cond pagto - despesas fpage2 */
ON  "F5", mouse-select-dblclick OF {&ttSon2}.cod-cond-pag IN BROWSE brSon2
DO:
    {method/zoomfields.i 
         &ProgramZoom="adzoom/z10ad039.w"
         &FieldZoom1="cod-cond-pag"
         &FieldScreen1="{&ttSon2}.cod-cond-pag"
         &browse1=brSon2}
END.

/* Zoom moeda - despesas fpage2 */
ON  "F5", mouse-select-dblclick OF {&ttSon2}.mo-codigo IN BROWSE brSon2
DO:
    {method/zoomfields.i 
         &ProgramZoom="unzoom/z10un005.w"
         &FieldZoom1="mo-codigo"
         &FieldScreen1="{&ttSon2}.mo-codigo"
         &browse1=brSon2
         &FieldZoom2="descricao"
         &FieldScreen2="c-desc-moeda"
         &browse2=brSon2}
END.

/* Zoom pto controle - declaraá‰es fpage3 */
ON  "F5", mouse-select-dblclick OF {&ttSon3}.cod-pto-contr IN BROWSE brSon3
DO:
    {method/zoomfields.i &ProgramZoom="cxzoom/z01cx310.w"
                     &FieldZoom1="cod-pto-contr"
                     &FieldScreen1="{&ttSon3}.cod-pto-contr"
                     &browse1=brSon3
                     &RunMethod="RUN setaVariable IN hProgramZoom (INPUT tt-historico-embarque.r-rowid)."
                     &EnableImplant="no"}
    WAIT-FOR "CLOSE":U OF hProgramZoom.
    APPLY "LEAVE":U TO {&ttSon3}.cod-pto-contr IN BROWSE brSon3.
END.

/* Zoom cod decl. - comunic. fpage3 */
ON  "F5", mouse-select-dblclick OF {&ttSon3}.de-codigo IN BROWSE brSon3
DO:
    {method/zoomfields.i 
         &ProgramZoom="cxzoom/z01cx010.w"
         &FieldZoom1="de-codigo"
         &FieldScreen1="{&ttSon3}.de-codigo"
         &browse1=brSon3
         &FieldZoom2="descricao"
         &FieldScreen2="{&ttSon3}.descricao"
         &browse2=brSon3}
END.

/*****
**  LEAVE/ENTRY DOS CAMPOS
******************************/
/* Entry c¢digo despesa - despesas fpage2 */
ON 'ENTRY':U OF {&ttSon2}.cod-desp IN BROWSE brSon2
DO:
    ASSIGN i-desp-ant = INTEGER({&ttSon2}.cod-desp:SCREEN-VALUE IN BROWSE brSon2).
END.

ON 'ENTRY':U OF {&ttSon1}.cod-pto-contr IN BROWSE brSon1
DO:
    IF i-pto-ant = 0 THEN
        ASSIGN i-pto-ant = INTEGER({&ttSon1}.cod-pto-contr:SCREEN-VALUE IN BROWSE brSon1).  
END.

/* Leave pto controle - acompanhamento processo fpage1 */
ON  "LEAVE" OF {&ttSon1}.cod-pto-contr IN BROWSE brSon1
DO: 
    RUN findCodigo IN h-bocx110 (INPUT {&ttSon1}.cod-pto-contr:SCREEN-VALUE IN BROWSE brSon1,
                                 OUTPUT c-return).
    IF c-return <> "":U AND INT({&ttSon1}.cod-pto-contr:SCREEN-VALUE IN BROWSE brSon1) <> 0 AND INT({&ttSon1}.cod-pto-contr:SCREEN-VALUE IN BROWSE brSon1) <> i-pto-ant THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 54562,
                           INPUT c-lbl-pto-contr + "~~"  + c-lbl-cadastra-pto).
        IF RETURN-VALUE <> "yes":U THEN DO:
            ASSIGN {&ttSon1}.cod-pto-contr:SCREEN-VALUE IN BROWSE brSon1 = STRING(i-pto-ant).
            RETURN NO-APPLY.
        END.
        ELSE
            ASSIGN {&ttSon1}.descricao:SCREEN-VALUE IN BROWSE brSon1 = ""
                   {&ttSon1}.descricao.
    END.
    ELSE DO:
        IF TRIM({&ttSon1}.descricao:SCREEN-VALUE IN BROWSE brSon1) = "":U OR 
            INT({&ttSon1}.cod-pto-contr:SCREEN-VALUE IN BROWSE brSon1) <> i-pto-ant THEN DO:
            RUN retornaDescricao IN h-bocx110 (INPUT {&ttSon1}.cod-pto-contr:SCREEN-VALUE IN BROWSE brSon1,
                                               OUTPUT c-return).
            ASSIGN {&ttSon1}.descricao:SCREEN-VALUE IN BROWSE brSon1 = c-return
                   {&ttSon1}.descricao
                   i-pto-ant = INT({&ttSon1}.cod-pto-contr:SCREEN-VALUE IN BROWSE brSon1).

            RUN getCharField IN h-bocx110 (INPUT "cod-uf":U, OUTPUT c-cod-uf). 

            ASSIGN OVERLAY({&ttSon1}.char-1,1,2) = c-cod-uf.

            DISP c-cod-uf WITH BROWSE brSon1.
            
        END.
    END.
END.

/* Leave pto controle - despesas fpage2 */
ON  "LEAVE" OF {&ttSon2}.cod-pto-contr IN BROWSE brSon2
DO:
    ASSIGN c-desc-pto = fnDescricao(INPUT INTEGER({&ttSon2}.cod-pto-contr:SCREEN-VALUE IN BROWSE brSon2),
                                    INPUT {&ttSon2}.cod-estabel,
                                    INPUT {&ttSon2}.embarque,
                                    INPUT {&ttSon2}.cod-itiner).
    DISPLAY c-desc-pto WITH BROWSE brSon2.
END.

/* Leave codigo despesa - despesas fpage2 */
ON  "LEAVE" OF {&ttSon2}.cod-desp IN BROWSE brSon2
DO:
    ASSIGN c-desc-desp = fnDescDesp(INPUT INTEGER({&ttSon2}.cod-desp:SCREEN-VALUE IN BROWSE brSon2)).
        
    DISPLAY c-desc-desp WITH BROWSE brSon2.
END.

/* Leave c¢digo da emitente despesa - despesas fpage2 */
ON  "LEAVE" OF {&ttSon2}.cod-emitente-desp IN BROWSE brSon2
DO:
    RUN findEmitente IN h-boad098 (INPUT {&ttSon2}.cod-emitente-desp:SCREEN-VALUE IN BROWSE brSon2,
                                   OUTPUT c-return).
    IF c-return = "":U THEN DO:
        RUN getCharField IN h-boad098 (INPUT "nome-abrev":U,
                                       OUTPUT c-desc-emit-desp).
        DISPLAY c-desc-emit-desp WITH BROWSE brSon2.
    END.
END.

/* Leave c¢digo da moeda - despesas fpage2 */
ON  "LEAVE" OF {&ttSon2}.mo-codigo IN BROWSE brSon2
DO:
    RUN findCodigo IN h-boun005 (INPUT {&ttSon2}.mo-codigo:SCREEN-VALUE IN BROWSE brSon2,
                                 OUTPUT c-return).
    IF c-return = "":U THEN DO:
        RUN getCharField IN h-boun005 (INPUT "descricao":U,
                                       OUTPUT c-desc-moeda).
        DISPLAY c-desc-moeda WITH BROWSE brSon2.
    END.
END.

/* Leave pto controle - declaraá‰es fpage3 */
ON  "LEAVE" OF {&ttSon3}.cod-pto-contr IN BROWSE brSon3
DO:
    ASSIGN c-desc-pto = fnDescricao(INPUT INTEGER({&ttSon3}.cod-pto-contr:SCREEN-VALUE IN BROWSE brSon3),
                                    INPUT {&ttSon3}.cod-estabel,
                                    INPUT {&ttSon3}.embarque,
                                    INPUT {&ttSon3}.cod-itiner).
    ASSIGN {&ttSon3}.sequencia = fnSeqPto(INPUT {&ttSon3}.cod-estabel,
                                          INPUT {&ttSon3}.embarque,
                                          INPUT {&ttSon3}.cod-itiner,
                                          INPUT INT({&ttSon3}.cod-pto-contr:SCREEN-VALUE IN BROWSE brSon3)).
    DISPLAY c-desc-pto {&ttSon3}.sequencia WITH BROWSE brSon3.
END.

/* Entry c¢digo declaraá∆o - comunic fpage3 */
ON 'ENTRY':U OF {&ttSon3}.de-codigo IN BROWSE brSon3
DO:
    ASSIGN i-decl-ant = INTEGER({&ttSon3}.de-codigo:SCREEN-VALUE IN BROWSE brSon3).
END.

/* Leave c¢digo declaraá∆o - comunic fpage3 */
ON  "LEAVE" OF {&ttSon3}.de-codigo IN BROWSE brSon3
DO:
    IF TRIM({&ttSon3}.descricao:SCREEN-VALUE IN BROWSE brSon3) = "":U OR 
        INT({&ttSon3}.de-codigo:SCREEN-VALUE IN BROWSE brSon3) <> i-decl-ant THEN DO:
        RUN findPk_de_codigo IN h-bocx010 (INPUT INT({&ttSon3}.de-codigo:SCREEN-VALUE IN BROWSE brSon3),
                                           OUTPUT c-return).
        IF c-return = "":U THEN DO:
            RUN getCharField IN h-bocx010 (INPUT "descricao":U,
                                           OUTPUT {&ttSon3}.descricao).
            DISPLAY {&ttSon3}.descricao WITH BROWSE brSon3.
        END.
    END.
END.

/*--- L¢gica para inicializaá∆o do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterChangePage wMasterDetail 
PROCEDURE afterChangePage :
/*------------------------------------------------------------------------------
  Purpose: Executada ap¢s a troca de p†gina. (folder)    
  Parameters:  
  Notes:   Habilita e desabilita os widgets em tela. Se o usu†rio estava modificando
           algum registro no browse e n∆o salvou reabre a querie para trazer o valores atualizados.
------------------------------------------------------------------------------*/
    IF i-modificacao <> 0 THEN DO:
        RUN openQueriesSon IN THIS-PROCEDURE.
        RUN enableDisableWidgets IN THIS-PROCEDURE.
    END.
                                                     
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMasterDetail 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF VALID-HANDLE({&hDBOParent}) THEN DO:
        delete procedure {&hDBOParent}.
    END.                             

    IF VALID-HANDLE({&hDBOSon1}) THEN DO:
        delete procedure {&hDBOSon1}.
    END.
    
    IF VALID-HANDLE({&hDBOSon2}) THEN DO:
        delete procedure {&hDBOSon2}.
    END.

    IF VALID-HANDLE({&hDBOSon3}) THEN DO:
        delete procedure {&hDBOSon3}.
    END.

    IF VALID-HANDLE(h-bocx115) THEN DO:
       delete procedure h-bocx115.
    END.
    
    IF VALID-HANDLE(h-bocx110) THEN DO:
          delete procedure h-bocx110.
    END.
    
    IF VALID-HANDLE(h-bocx1102) THEN DO:
          delete procedure h-bocx1102.
    END.
    
    IF VALID-HANDLE(h-bocx2302) THEN DO: 
        delete procedure h-bocx2302.
    END.
    
    IF VALID-HANDLE(h-bocx2303) THEN DO:
        delete procedure h-bocx2303.
    END.
    
    IF VALID-HANDLE(h-bocx220) THEN DO:
        delete procedure h-bocx220.
    END.
    
    IF VALID-HANDLE(h-bocx407) THEN DO: 
          delete procedure h-bocx407.
    END.
    
    IF VALID-HANDLE(h-bocx384) THEN DO: 
        delete procedure h-bocx384.
    END.

    IF VALID-HANDLE(h-boar0138) THEN DO:
        DELETE PROCEDURE h-boar0138.
        ASSIGN h-boar0138 = ?.
    END.

    IF VALID-HANDLE(h-boad098) THEN DO:
        DELETE PROCEDURE h-boad098.
        ASSIGN h-boad098 = ?.
    END.

    IF VALID-HANDLE(h-boun005) THEN DO:
        DELETE PROCEDURE h-boun005.
        ASSIGN h-boun005 =  ?.
    END.

    IF VALID-HANDLE(h-bocx250) THEN DO:
        DELETE PROCEDURE h-bocx250.
        ASSIGN h-bocx250 = ?.
    END.

    IF VALID-HANDLE(h-bocx225e) THEN DO:
        DELETE PROCEDURE h-bocx225e.
        ASSIGN h-bocx225e = ?.
    END.

    IF VALID-HANDLE(h-cdapi050) THEN DO:
        DELETE PROCEDURE h-cdapi050.
        ASSIGN h-cdapi050 = ?.
    END.

    IF VALID-HANDLE(h-bocx095) THEN DO:
        DELETE PROCEDURE h-bocx095.
        ASSIGN h-bocx095 = ?.
    END.

    IF VALID-HANDLE(h-bocx010) THEN DO:
        DELETE PROCEDURE h-bocx010.
        ASSIGN h-bocx010 = ?.
    END.

    IF VALID-HANDLE(h-bocx250na) THEN DO:
        RUN destroy IN h-bocx250na.
        ASSIGN h-bocx250na = ?.
    END.

    IF VALID-HANDLE(h-bocx225) THEN DO:
        DELETE PROCEDURE h-bocx225.
        ASSIGN h-bocx225 = ?.
    END.

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
    /*RUN setFolder IN hFolder (INPUT 1).*/
    IF AVAIL tt-historico-embarque THEN DO:

       IF i-pais-impto-usuario <> 1 THEN DO:
       
           FIND FIRST param-imp 
                WHERE param-imp.cod-estabel = tt-historico-embarque.cod-estabel NO-LOCK NO-ERROR. 
           IF AVAIL param-imp
               AND SUBSTRING(param-imp.char-1,249,1) = "S":U THEN DO:
               
               ASSIGN bt-vincula-drb:HIDDEN       IN FRAME fPage0 = NO
                      bt-vincula-drb:SENSITIVE    IN FRAME fPage0 = YES
                      c-ato-concessorio:HIDDEN    IN FRAME fPage0 = NO
                      c-ato-concessorio:SENSITIVE IN FRAME fPage0 = NO.

               IF i-pais-impto-usuario <> 1 /* Brasil*/ THEN DO:
                   {utp/ut-liter.i DIT *}
                   ASSIGN c-ato-concessorio:LABEL IN FRAME fPage0 = RETURN-VALUE.
               END.               

               ASSIGN c-nr-ato-concessorio = "".

               IF AVAIL tt-historico-embarque THEN
                   RUN getAtoConcessorioEmbarque IN h-bocx225 (input tt-historico-embarque.cod-estabel,
                                                               INPUT tt-historico-embarque.embarque,
                                                               OUTPUT c-nr-ato-concessorio).

               ASSIGN c-ato-concessorio:SCREEN-VALUE IN FRAME fPage0 = c-nr-ato-concessorio. 

           END.
           ELSE
               ASSIGN bt-vincula-drb   :HIDDEN IN FRAME fPage0 = YES
                      c-ato-concessorio:HIDDEN IN FRAME fPage0 = YES.
                      
           
           {utp/ut-liter.i NF_Complementar *}
           ASSIGN btNotaComplementar:LABEL IN FRAME fPage2 = RETURN-VALUE.
           {utp/ut-liter.i Geraá∆o_NF_Complementar *}
           ASSIGN btNotaComplementar:TOOLTIP IN FRAME fPage2 = RETURN-VALUE.
       END.

       /* 
       ** Inclus∆o do c¢digo abaixo para que os registros sejam posicionados de 
       ** acordo com o programa im0045, im055, im0555 e im0545
       */

       IF NOT gl-im0044 THEN DO:
            IF c-embarque-imp = c-embarque-historico THEN
                /*Busca os registros do programa im0045 e im0545
                  e armazena nas vari†veis passadas como parÉmetro*/
                RUN trazembarque IN h-bocx220 (INPUT gr-embarque-imp,
                                               OUTPUT c-cod-estabel-imp,
                                               OUTPUT c-embarque-imp).
             
             IF c-embarque-imp <> "" AND 
                c-embarque-imp <> c-embarque-historico THEN 
                ASSIGN c-embarque-historico    = c-embarque-imp
                       c-cod-estabel-historico = c-cod-estabel-imp.
    
             ELSE DO:
                IF c-embarque-imp = "" AND
                   c-embarque-imp <> tt-historico-embarque.embarque AND
                   c-embarque-imp <> c-embarque-historico THEN .
    
                ELSE
                    ASSIGN  c-cod-estabel-historico = tt-historico-embarque.cod-estabel
                            c-embarque-historico    = tt-historico-embarque.embarque.
             END.
             IF c-embarque-historico <> c-embarque-imp THEN DO:
                RUN rowidembarque IN h-bocx220 (INPUT c-cod-estabel-historico,
                                                INPUT c-embarque-historico,
                                                OUTPUT gr-embarque-imp).
                ASSIGN c-cod-estabel-imp = c-cod-estabel-historico
                       c-embarque-imp    = c-embarque-historico.
             END.
    
             IF c-embarque-historico <> tt-historico-embarque.embarque THEN DO:
                ASSIGN tt-historico-embarque.embarque    = c-embarque-historico
                       tt-historico-embarque.cod-estabel = c-cod-estabel-historico.
                RUN displayFields IN THIS-PROCEDURE.
             END.
         END.
         
         /* Fim do tratamento para posicionamento dos registros */

         run calcularDiasAcompanhamentoHistEmb in h-bocx230 (input tt-historico-embarque.cod-estabel,
                                                             input tt-historico-embarque.embarque,  
                                                             output i-dias-total,
                                                             output table tt-bo-erro).
         disp i-dias-total
             with frame fPage0.
        
         APPLY "LEAVE":U TO tt-historico-embarque.embarque   IN FRAME fPage0.
         APPLY "LEAVE":U TO tt-historico-embarque.cod-itiner IN FRAME fPage0.
         APPLY "LEAVE":U TO fill-in-2 IN FRAME fPage0.
         APPLY "LEAVE":U TO fill-in-4 IN FRAME fPage0.
         APPLY "LEAVE":U TO i-pto-despch IN FRAME fPage0.
         APPLY "LEAVE":U TO i-pto-chegad IN FRAME fPage0.

         IF  VALID-HANDLE(h-bocx250) THEN DO:
             RUN findCodigo IN h-bocx250 (INPUT tt-historico-embarque.cod-estabel, OUTPUT c-return).

             IF  c-return <> "" THEN DO:
                 RUN utp/ut-msgs.p (INPUT "show":U,INPUT 17567, INPUT c-return).
             END.
             ELSE DO:
                &IF "{&bf_mat_versao_ems}" >= "2.07" &THEN
                    RUN getLogField IN h-bocx250 (INPUT "log-tax-siscomex",
                                                  OUTPUT l-tax-siscomex).
                    RUN getIntField IN h-bocx250 (INPUT "cdn-despes-siscomex",
                                                  OUTPUT i-desp-siscomex).
                &ELSE
                    RUN getCharField IN h-bocx250 (INPUT "char-1",
                                                   OUTPUT c-tax-siscomex).
                    ASSIGN l-tax-siscomex  = IF INT(SUBSTR(c-tax-siscomex, 105, 1)) = 1 THEN YES ELSE NO
                           i-desp-siscomex = INT(SUBSTR(c-tax-siscomex, 91, 5)).
                &ENDIF
             END.
         END.
    
         RUN pi-valida-integracao-di IN h-bocx407 (INPUT tt-historico-embarque.embarque,
                                                  INPUT tt-historico-embarque.cod-estabel,
                                                  OUTPUT l-possui-di).

         RUN openQueryStatic IN h-bocx336 (INPUT "Main":U).
         RUN goToKey IN h-bocx336 (INPUT c-seg-usuario).

         IF RETURN-VALUE = "OK":U THEN DO:
             RUN GetLogField IN h-bocx336(INPUT "log-perm-pto-control-imp":U, OUTPUT log-perm-pto-control-imp).
             RUN GetLogField IN h-bocx336(INPUT "log-perm-pto-despes-imp":U,  OUTPUT log-perm-pto-despes-imp).
             RUN GetLogField IN h-bocx336(INPUT "log-perm-pto-decla-imp":U,   OUTPUT log-perm-pto-decla-imp).
         END.

         ASSIGN i-pto-desp-ini = 0
                i-pto-desp-fim = 99999
                i-pto-decl-ini = 0
                i-pto-decl-fim = 99999.

         RUN enableDisableWidgets.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Criaá∆o da procedure para que sejam trazidos os registros atualizados no 
 browser que carrega as informaá‰es referentes aos pontos de controle do embarque
------------------------------------------------------------------------------*/
    {utp/ut-liter.i Relacionar *}

    IF NOT l-historico THEN
        RUN getRowid IN {&hDBOParent} (OUTPUT r-historico-embarque).
    RUN repositionRecord IN THIS-PROCEDURE (INPUT r-historico-embarque).

    IF c-return = ""  THEN DO:
        RUN getCurrent IN {&hDBOParent} (OUTPUT TABLE {&ttParent}).
        RUN displayFields IN THIS-PROCEDURE.
    END.
    

    &if "{&bf_mat_versao_ems}" >= "2.062" &then
        IF AVAIL tt-historico-embarque THEN DO:
            ENABLE btLoad WITH FRAME fpage0.
        END.
        ELSE DO:
            DISABLE btLoad WITH FRAME fpage0.
        END.

    &else
        ASSIGN btLoad:HIDDEN IN FRAME fPage0 = TRUE.
    &endif
    
    IF CAN-FIND(FIRST desp-embarque
            WHERE desp-embarque.cod-estabel       = {&ttSon2}.cod-estabel
              AND desp-embarque.embarque          = {&ttSon2}.embarque
              AND desp-embarque.cod-itiner        = {&ttSon2}.cod-itiner 
              AND desp-embarque.cod-pto-contr     = {&ttSon2}.cod-pto-contr
              AND desp-embarque.cod-desp          = {&ttSon2}.cod-desp
              AND desp-embarque.cod-emitente-desp = {&ttSon2}.cod-emitente-desp
              AND desp-embarque.log-prorate-efetd) 
       AND i-pais-impto-usuario <> 1 THEN
    DISABLE btUpdateSon2 WITH FRAME fPage2.
    
    IF i-pais-impto-usuario <> 1 THEN DO:
        ASSIGN btNotaComplementar:HIDDEN IN FRAME fPage2 = FALSE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyEnd wMasterDetail 
PROCEDURE applyEnd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyOffEnd wMasterDetail 
PROCEDURE applyOffEnd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayFields wMasterDetail 
PROCEDURE beforeDisplayFields :
ASSIGN l-passou = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bringParent wMasterDetail 
PROCEDURE bringParent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/  
    if avail tt-historico-embarque then do:
        RUN findChEmbarque IN {&hDBOParent} ( INPUT tt-historico-embarque.cod-estabel, 
                                              INPUT tt-historico-embarque.embarque, 
                                              INPUT tt-historico-embarque.cod-itiner,
                                              OUTPUT c-return).
        RUN getCurrent IN {&hDBOParent} (OUTPUT TABLE tt-historico-embarque).
        FIND FIRST tt-historico-embarque NO-ERROR.

        DISPLAY {&page0Fields} WITH FRAME fPage0.
        RUN afterDisplayFields IN THIS-PROCEDURE.
    end.
    
    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableDisableWidgets wMasterDetail 
PROCEDURE enableDisableWidgets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Retira o focus dos browses para que seja poss°vel desabilitar a ediá∆o (READ-ONLY) */
    APPLY "ROW-LEAVE":U TO {&page1Browse} IN FRAME fPage1.
    APPLY "ROW-LEAVE":U TO {&page2Browse} IN FRAME fPage2.
    APPLY "ROW-LEAVE":U TO {&page3Browse} IN FRAME fPage3.
    APPLY "LEAVE":U TO {&page1Browse} IN FRAME fPage1.
    APPLY "LEAVE":U TO {&page2Browse} IN FRAME fPage2.
    APPLY "LEAVE":U TO {&page3Browse} IN FRAME fPage3.
    APPLY "ENTRY":U TO {&WINDOW-NAME}.

    ASSIGN btn-muda-sequencia:SENSITIVE IN FRAME fPage1 = NO
           btn-modifica-ptos:SENSITIVE IN FRAME fPage1  = NO
           btn-cancela-ptos:SENSITIVE IN FRAME fPage1   = NO
           btn-confirma-ptos:SENSITIVE IN FRAME fPage1  = NO
           btn-modifica-desp:SENSITIVE IN FRAME fPage2  = NO
           btn-cancela-desp:SENSITIVE IN FRAME fPage2   = NO
           btn-confirma-desp:SENSITIVE IN FRAME fPage2  = NO
           btn-modifica-decl:SENSITIVE IN FRAME fPage3  = NO
           btn-cancela-decl:SENSITIVE IN FRAME fPage3   = NO
           btn-confirma-decl:SENSITIVE IN FRAME fPage3  = NO
           btn-filter-desp:SENSITIVE IN FRAME fPage2    = YES
           btn-filter-decl:SENSITIVE IN FRAME fPage3    = YES
           i-modificacao = 0
           i-pto-ant = 0
           i-desp-ant = 0
           brSon1:READ-ONLY IN FRAME fPage1 = YES /* Desabilita a ediá∆o do browse */
           brSon2:READ-ONLY IN FRAME fPage2 = YES /* Desabilita a ediá∆o do browse */
           brSon3:READ-ONLY IN FRAME fPage3 = YES /* Desabilita a ediá∆o do browse */ NO-ERROR.
    
    IF VALID-HANDLE(h-bocx250na) THEN
        RUN get-param-calc-desp-itiner IN h-bocx250na (INPUT tt-historico-embarque.cod-estabel,
                                                       OUTPUT l-calc-desp-itiner).

    IF CAN-FIND(FIRST funcao
                WHERE funcao.cd-funcao = "spp-calcula-despes-itiner"
                AND   funcao.ativo)
        AND l-calc-desp-itiner THEN
        ASSIGN bt-calc-desp-itiner:HIDDEN IN FRAME fPage0 = NO
               bt-calc-desp-itiner:SENSITIVE IN FRAME fPage0 = YES.
    ELSE
        ASSIGN bt-calc-desp-itiner:HIDDEN IN FRAME fPage0 = YES.


    APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1.
    APPLY "VALUE-CHANGED":U TO brSon2 IN FRAME fPage2.
    APPLY "VALUE-CHANGED":U TO brSon3 IN FRAME fPage3.

    tt-historico-embarque2.cod-pto-contr:LOAD-MOUSE-POINTER("") in BROWSE brSon1.
    tt-desp-embarque.cod-pto-contr:LOAD-MOUSE-POINTER("") in BROWSE brSon2.
    tt-desp-embarque.cod-emitente-desp:LOAD-MOUSE-POINTER("") in BROWSE brSon2.
    tt-desp-embarque.cod-desp:LOAD-MOUSE-POINTER("") in BROWSE brSon2.
    tt-desp-embarque.cod-cond-pag:LOAD-MOUSE-POINTER("") in BROWSE brSon2.
    tt-desp-embarque.mo-codigo:LOAD-MOUSE-POINTER("") in BROWSE brSon2.
    tt-decl-hist-embarq-imp.cod-pto-contr:LOAD-MOUSE-POINTER("") in BROWSE brSon3.
    tt-decl-hist-embarq-imp.de-codigo:LOAD-MOUSE-POINTER("") in BROWSE brSon3.
                        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE focusBrowseField wMasterDetail 
PROCEDURE focusBrowseField :
/*------------------------------------------------------------------------------
  Purpose: Aplica foco no campo com erro    
  Parameters:  (input) (temp-table) tt-campo-erro: Campos em que ocorreram erros.
               (input) (integer) pi-page-number: N£mero do folder
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-campo-erro.
    DEFINE INPUT PARAMETER pi-page-number AS INTEGER NO-UNDO.

    FOR FIRST tt-campo-erro:
        CASE pi-page-number:
            WHEN 1 THEN DO:
                CASE tt-campo-erro.campo:
                    WHEN "sequencia":U THEN
                        APPLY "ENTRY":U TO {&ttSon1}.sequencia IN BROWSE brSon1.
                    WHEN "descricao":U THEN
                        APPLY "ENTRY":U TO {&ttSon1}.descricao IN BROWSE brSon1.
                    WHEN "cod-pto-contr":U THEN
                        APPLY "ENTRY":U TO {&ttSon1}.cod-pto-contr IN BROWSE brSon1.
                    WHEN "dt-previsao":U THEN
                        APPLY "ENTRY":U TO {&ttSon1}.dt-previsao IN BROWSE brSon1.
                    WHEN "dt-efetiva":U THEN
                        APPLY "ENTRY":U TO {&ttSon1}.dt-efetiva IN BROWSE brSon1.
                    WHEN "nr-dias":U THEN
                        APPLY "ENTRY":U TO {&ttSon1}.nr-dias IN BROWSE brSon1.
                    OTHERWISE
                        APPLY "ENTRY":U TO {&ttSon1}.cod-pto-contr IN BROWSE brSon1.
                END CASE.
            END.
            WHEN 2 THEN DO:
                CASE tt-campo-erro.campo:
                    WHEN "cod-pto-contr":U THEN
                        APPLY "ENTRY":U TO {&ttSon2}.cod-pto-contr IN BROWSE brSon2.
                    WHEN "cod-emitente-desp":U THEN
                        APPLY "ENTRY":U TO {&ttSon2}.cod-emitente-desp IN BROWSE brSon2.
                    WHEN "cod-desp":U THEN
                        APPLY "ENTRY":U TO {&ttSon2}.cod-desp IN BROWSE brSon2.
                    WHEN "val-desp":U THEN
                        APPLY "ENTRY":U TO {&ttSon2}.val-desp IN BROWSE brSon2.
                    WHEN "mo-codigo":U THEN
                        APPLY "ENTRY":U TO {&ttSon2}.mo-codigo IN BROWSE brSon2.
                    OTHERWISE
                        APPLY "ENTRY":U TO {&ttSon2}.cod-pto-contr IN BROWSE brSon2.
                END CASE.
            END.
            WHEN 3 THEN DO:
                CASE tt-campo-erro.campo:
                    WHEN "sequencia":U THEN DO:
                        /* Aplica foco no ponto de controle pois o campo "sequància" n∆o est† habilitado e muda de acordo com o c¢digo do ponto */
                        APPLY "ENTRY":U TO {&ttSon3}.cod-pto-contr IN BROWSE brSon3. 
                    END.
                    WHEN "cod-pto-contr":U THEN
                        APPLY "ENTRY":U TO {&ttSon3}.cod-pto-contr IN BROWSE brSon3.
                    WHEN "de-codigo":U THEN
                        APPLY "ENTRY":U TO {&ttSon3}.de-codigo IN BROWSE brSon3.
                    WHEN "descricao":U THEN
                        APPLY "ENTRY":U TO {&ttSon3}.descricao IN BROWSE brSon3.
                    OTHERWISE
                        APPLY "ENTRY":U TO {&ttSon3}.cod-pto-contr IN BROWSE brSon3.
                END CASE.
            END.
        END CASE.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
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
         SIZE 32 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE cStatus AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE ccod-estabel like historico-embarque.cod-estabel NO-UNDO.
    DEFINE VARIABLE iembarque like historico-embarque.embarque NO-UNDO.
    
    &IF DEFINED(bf-mat-comex) &THEN
        DEFINE FRAME fGoToRecord
        ccod-estabel AT ROW 1.21 COL 15 COLON-ALIGNED
        iembarque AT ROW 2.21 COL 15 COLON-ALIGNED
        btGoToOK      AT ROW 3.60 COL 3.14
        btGoToCancel  AT ROW 3.60 COL 14
        rtGoToButton  AT ROW 3.35 COL 2
        WITH width 50
             VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE FONT 1 TITLE "V† Para Hist¢rico Embarque"
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    &ELSE
        DEFINE FRAME fGoToRecord
            ccod-estabel AT ROW 1.21 COL 15 COLON-ALIGNED
            iembarque AT ROW 2.21 COL 15 COLON-ALIGNED
            btGoToOK      AT ROW 3.60 COL 2.14
            btGoToCancel  AT ROW 3.60 COL 13
            rtGoToButton  AT ROW 3.35 COL 1
            WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
                 THREE-D SCROLLABLE FONT 1 TITLE "V† Para Hist¢rico Embarque"
                 DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    &ENDIF

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Hist¢rico_Embarque"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN ccod-estabel iembarque.
        
        &IF DEFINED(DBOVersion) <> 0 &THEN
           RUN findEmbarque IN {&hDBOParent} (INPUT ccod-estabel, 
                                              INPUT iembarque,
                                              OUTPUT cStatus).
           IF cStatus <> "":U THEN DO:
              /* Inicio -- Projeto Internacional*/
              {utp/ut-liter.i "Hist¢rico_Embarque" *}
              RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                 INPUT 2, 
                                 INPUT RETURN-VALUE).
              
              RETURN NO-APPLY.
           END.
        &ENDIF
        
        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    assign ccod-estabel:width = 4
           iembarque:width = 12.
    
    ENABLE ccod-estabel iembarque btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    IF NOT VALID-HANDLE({&hDBOParent}) THEN DO:
       RUN cxbo/bocx230a.p persistent set h-bocx230.
    END.

    IF NOT VALID-HANDLE({&hDBOSon1}) THEN DO:
       RUN cxbo/bocx230a.p persistent set {&hDBOSon1}.
    END.

    IF NOT VALID-HANDLE({&hDBOSon2}) THEN
       RUN cxbo/bocx310.p persistent set {&hDBOSon2}.

    IF NOT VALID-HANDLE({&hDBOSon3}) THEN
       RUN cxbo/bocx280.p persistent set {&hDBOSon3}.
    
    IF NOT VALID-HANDLE(h-bocx2303) THEN
        RUN cxbo/bocx230.p PERSISTENT SET h-bocx2303.

    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN {&hDBOParent} (INPUT 3).
    &ELSE
        RUN openQueryStatic IN {&hDBOParent} (INPUT "ccod-estabel":U).
    &ENDIF
    
    IF NOT VALID-HANDLE(h-bocx115) THEN
        RUN cxbo/bocx115.p persistent set h-bocx115.

    IF NOT VALID-HANDLE(h-bocx110) THEN
        RUN cxbo/bocx110.p persistent set h-bocx110.    

    IF NOT VALID-HANDLE(h-bocx220) THEN
       RUN cxbo/bocx220.p persistent set h-bocx220.

    IF NOT VALID-HANDLE(h-bocx336) THEN
        RUN cxbo/bocx336.p PERSISTENT SET h-bocx336.
    
    IF NOT VALID-HANDLE(h-bocx1102) THEN
        RUN cxbo/bocx110.p persistent set h-bocx1102.   
    
    IF NOT VALID-HANDLE(h-bocx407) THEN
        RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.

    IF NOT VALID-HANDLE(h-boad098) THEN
        RUN adbo/boad098.p PERSISTENT SET h-boad098.

    IF NOT VALID-HANDLE(h-boun005) THEN
        RUN unbo/boun005.p PERSISTENT SET h-boun005.

    IF NOT VALID-HANDLE(h-bocx250) THEN
        RUN cxbo/bocx250.p PERSISTENT SET h-bocx250.

    IF NOT VALID-HANDLE(h-bocx250na) THEN
        RUN cxbo/bocx250na.p PERSISTENT SET h-bocx250na.

    IF NOT VALID-HANDLE(h-bocx225e) THEN
        RUN cxbo/bocx225e.p persistent set h-bocx225e.

    IF NOT VALID-HANDLE(h-cdapi050) THEN
        RUN cdp/cdapi050.p PERSISTEN SET h-cdapi050.

    &IF '{&mgdis_version}' < '2.06f' &THEN
        /*Tecnica para implementar validaá∆o produto Estendido*/
        {cdp/cdapi558.i1}
    &endif.
    
    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
        IF  NOT VALID-HANDLE(h-boar0138) THEN
            RUN local/arg/boar0138.p PERSISTENT SET h-boar0138.
    END.

    IF NOT VALID-HANDLE(h-bocx095) THEN
        RUN cxbo/bocx095.p PERSISTENT SET h-bocx095.

    IF NOT VALID-HANDLE(h-bocx010) THEN
        RUN cxbo/bocx010.p PERSISTENT SET h-bocx010.

    IF NOT VALID-HANDLE(h-bocx225) THEN
        RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE cembarque    as char    NO-UNDO.
    DEFINE VARIABLE ccod-estabel as char    NO-UNDO.
    DEFINE VARIABLE icod-itiner  as integer NO-UNDO.

    IF AVAILABLE tt-historico-embarque THEN DO:
       ASSIGN ccod-estabel = tt-historico-embarque.cod-estabel
              cembarque    = tt-historico-embarque.embarque
              icod-itiner  = tt-historico-embarque.cod-itiner.

        /* A include "openqueriesson.i" n∆o foi utilizada pois existem campos edit†veis no browse que n∆o est∆o na tabela (historico-embarque)
        o que causava o erro de temp-tables incompat°veis. Foi necess†rio fazer o openQuery manualmente e ap¢s isso copiar os registros para a temp-table do browse */
        RUN openQueryHistoricoEmbarque IN THIS-PROCEDURE. 
       
        RUN openQueryDespEmbarque IN THIS-PROCEDURE.

        /* A include "openqueriesson.i" n∆o foi utilizada pois existem campos edit†veis no browse que n∆o est∆o na tabela (decl-hist-embarq-imp)
        o que causava o erro de temp-tables incompat°veis. Foi necess†rio fazer o openQuery manualmente e ap¢s isso copiar os registros para a temp-table do browse */
        RUN openQueryDeclEmbarque IN THIS-PROCEDURE.

    END.
    ELSE
        ASSIGN ccod-estabel = ?
               cembarque    = ?
               icod-itiner  = 0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDeclEmbarque wMasterDetail 
PROCEDURE openQueryDeclEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     Abrir a query para as delcaraá‰es. (brSon3)
  Parameters:  <none>
  Notes:      
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-pto AS INTEGER     NO-UNDO.
    
    FOR EACH {&ttSon3}:
        DELETE {&ttSon3}.
    END.
    FOR EACH tt-decl-hist-embarq-imp-bo:
        DELETE tt-decl-hist-embarq-imp-bo.
    END.

    /*--- Faz a ligaá∆o entre o DBO filho e o DBO pai, atravÇs do uso de uma
          restriá∆o (constraint) ---*/
    RUN setConstraint2 IN {&hDBOSon3} (INPUT {&ttParent}.r-rowid).
    
    /*--- Abre query do DBO filho ---*/
    RUN openQuery IN {&hDBOSon3} (INPUT 3).
    
    /*--- Posiciona DBO filho no primeiro registro, caso necess†rio ---*/
    IF iRepositionPageNumber = 0 THEN
        RUN findFirst IN {&hDBOSon3}.

    /*--- Retorna faixa de registro do DBO Filho ---*/
    RUN serverSendRows IN {&hDBOSon3} (INPUT ?,
                                       INPUT IF iRepositionPageNumber = 3 THEN STRING(rRepositionSon) ELSE ?,
                                       INPUT NO,
                                       INPUT ?,
                                       OUTPUT iRowsReturned,
                                       OUTPUT TABLE tt-decl-hist-embarq-imp-bo).
    FOR EACH tt-decl-hist-embarq-imp-bo:
        ASSIGN i-pto = fnPtoSeq({&ttSon3}-bo.cod-estabel, {&ttSon3}-bo.embarque, {&ttSon3}-bo.cod-itiner, {&ttSon3}-bo.sequencia).
        IF i-pto < i-pto-decl-ini THEN NEXT.
        IF i-pto > i-pto-decl-fim THEN NEXT.

        CREATE {&ttSon3}.
        BUFFER-COPY tt-decl-hist-embarq-imp-bo TO {&ttSon3}.
        ASSIGN {&ttSon3}.cod-estabel = {&ttParent}.cod-estabel
               {&ttSon3}.embarque = {&ttParent}.embarque
               {&ttSon3}.cod-itiner = {&ttParent}.cod-itiner.
        ASSIGN {&ttSon3}.cod-pto-contr = i-pto.
    END.
       
    /*--- Seta estado dos bot‰es relacionados ao browse da p†gina 3 ---*/
    IF AVAILABLE {&ttSon3} THEN
        ASSIGN 
            &IF "{&AddSon3}":U = "YES":U &THEN
               btAddSon3:SENSITIVE IN FRAME fPage3    = YES
            &ENDIF
            
            &IF "{&CopySon3}":U = "YES":U &THEN               
               btCopySon3:SENSITIVE IN FRAME fPage3   = YES
            &ENDIF
            
            &IF "{&UpdateSon3}":U = "YES":U &THEN               
               btUpdateSon3:SENSITIVE IN FRAME fPage3 = YES
            &ENDIF
            
            &IF "{&DeleteSon3}":U = "YES":U &THEN               
               btDeleteSon3:SENSITIVE IN FRAME fPage3 = YES
            &ENDIF
            
            &IF "{&DetailSon3}":U = "YES":U &THEN               
               btDetailSon3:SENSITIVE IN FRAME fPage3 = YES
            &ENDIF

            &IF "{&FormationSon3}":U = "YES":U &THEN               
               btFormationSon3:SENSITIVE IN FRAME fPage3 = YES
            &ENDIF
            .
    ELSE
        ASSIGN 
            &IF "{&AddSon3}":U = "YES":U &THEN
               btAddSon3:SENSITIVE IN FRAME fPage3    = AVAILABLE {&ttParent}
            &ENDIF
            
            &IF "{&CopySon3}":U = "YES":U &THEN
               btCopySon3:SENSITIVE IN FRAME fPage3   = NO
            &ENDIF
            
            &IF "{&UpdateSon3}":U = "YES":U &THEN
               btUpdateSon3:SENSITIVE IN FRAME fPage3 = NO
            &ENDIF
            
            &IF "{&DeleteSon3}":U = "YES":U &THEN
               btDeleteSon3:SENSITIVE IN FRAME fPage3 = NO
            &ENDIF
            
            &IF "{&DetailSon3}":U = "YES":U &THEN               
               btDetailSon3:SENSITIVE IN FRAME fPage3 = NO
            &ENDIF

            &IF "{&FormationSon3}":U = "YES":U &THEN               
               btFormationSon3:SENSITIVE IN FRAME fPage3 = AVAILABLE {&ttParent}
            &ENDIF
            .

    /*--- Abre a query associada ao browse da p†gina 3 ---*/
    {&OPEN-QUERY-{&page3browse}}
    APPLY "VALUE-CHANGED":U TO BROWSE {&page3browse}.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDespEmbarque wMasterDetail 
PROCEDURE openQueryDespEmbarque :
/*------------------------------------------------------------------------------
  Purpose: Abrir a query para o browse de despsas.    
  Parameters:  <none>
  Notes:   A abertura foi retirada da openQueriesSon pois ser† chamada individualmente
           durante a utilizaá∆o do filtro.    
------------------------------------------------------------------------------*/
    {masterdetail/OpenQueriesSon.i
        &Parent="tt-historico-embarque"
        &Query="despesa"
        &PageNumber="2"
        &QueryConstraint="6"
        &QueryNumber="6"
        &ConstraintParameters="tt-historico-embarque.r-rowid, i-pto-desp-ini, i-pto-desp-fim"}
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryHistoricoEmbarque wMasterDetail 
PROCEDURE openQueryHistoricoEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     Abrir a query para os ptos de controle . (brSon1)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH {&ttSon1}:
        DELETE {&ttSon1}.
    END.
    FOR EACH tt-historico-embarque-bo:
        DELETE tt-historico-embarque-bo.
    END.

    /*--- Faz a ligaá∆o entre o DBO filho e o DBO pai, atravÇs do uso de uma
          restriá∆o (constraint) ---*/
    RUN setConstraint4 IN {&hDBOSon1} (INPUT {&ttParent}.r-rowid,
                                       INPUT {&ttParent}.cod-estabel,
                                       INPUT {&ttParent}.cod-itiner,
                                       INPUT {&ttParent}.embarque).
    
    /*--- Abre query do DBO filho ---*/
    RUN openQuery IN {&hDBOSon1} (INPUT 4).
    
    /*--- Posiciona DBO filho no primeiro registro, caso necess†rio ---*/
    IF iRepositionPageNumber = 0 THEN
        RUN findFirst IN {&hDBOSon1}.
    
    /*--- Retorna faixa de registro do DBO Filho ---*/
    RUN serverSendRows IN {&hDBOSon1} (INPUT ?,
                                       INPUT IF iRepositionPageNumber = 1 THEN STRING(rRepositionSon) ELSE ?,
                                       INPUT NO,
                                       INPUT ?,
                                       OUTPUT iRowsReturned,
                                       OUTPUT TABLE tt-historico-embarque-bo).
    FOR EACH tt-historico-embarque-bo:
        IF tt-historico-embarque-bo.cod-pto-contr = INT(fill-in-4:SCREEN-VALUE IN FRAME fPage0) THEN
            ASSIGN i-seq-nacionaliz = tt-historico-embarque-bo.sequencia.
        CREATE {&ttSon1}.
        BUFFER-COPY tt-historico-embarque-bo TO {&ttSon1}.
    END.
       
    /*--- Seta estado dos bot‰es relacionados ao browse da p†gina 1 ---*/
    IF AVAILABLE {&ttSon1} THEN
        ASSIGN 
            &IF "{&AddSon1}":U = "YES":U &THEN
               btAddSon1:SENSITIVE IN FRAME fPage1    = YES
            &ENDIF
            
            &IF "{&CopySon1}":U = "YES":U &THEN               
               btCopySon1:SENSITIVE IN FRAME fPage1   = YES
            &ENDIF
            
            &IF "{&UpdateSon1}":U = "YES":U &THEN               
               btUpdateSon1:SENSITIVE IN FRAME fPage1 = YES
            &ENDIF
            
            &IF "{&DeleteSon1}":U = "YES":U &THEN               
               btDeleteSon1:SENSITIVE IN FRAME fPage1 = YES
            &ENDIF
            
            &IF "{&DetailSon1}":U = "YES":U &THEN               
               btDetailSon1:SENSITIVE IN FRAME fPage1 = YES
            &ENDIF

            &IF "{&FormationSon1}":U = "YES":U &THEN               
               btFormationSon1:SENSITIVE IN FRAME fPage1 = YES
            &ENDIF
            .
    ELSE
        ASSIGN 
            &IF "{&AddSon1}":U = "YES":U &THEN
               btAddSon1:SENSITIVE IN FRAME fPage1    = AVAILABLE {&ttParent}
            &ENDIF
            
            &IF "{&CopySon1}":U = "YES":U &THEN
               btCopySon1:SENSITIVE IN FRAME fPage1   = NO
            &ENDIF
            
            &IF "{&UpdateSon1}":U = "YES":U &THEN
               btUpdateSon1:SENSITIVE IN FRAME fPage1 = NO
            &ENDIF
            
            &IF "{&DeleteSon1}":U = "YES":U &THEN
               btDeleteSon1:SENSITIVE IN FRAME fPage1 = NO
            &ENDIF
            
            &IF "{&DetailSon1}":U = "YES":U &THEN               
               btDetailSon1:SENSITIVE IN FRAME fPage1 = NO
            &ENDIF

            &IF "{&FormationSon1}":U = "YES":U &THEN               
               btFormationSon1:SENSITIVE IN FRAME fPage1 = AVAILABLE {&ttParent}
            &ENDIF
            .

    /*--- Abre a query associada ao browse da p†gina 1 ---*/
    {&OPEN-QUERY-{&page1browse}}
    APPLY "VALUE-CHANGED":U TO BROWSE {&page1browse}.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-integracao-di wMasterDetail 
PROCEDURE pi-valida-integracao-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE p-l-integra AS LOGICAL INITIAL NO    NO-UNDO.
    
    
    ASSIGN p-l-integra = fnIntegrDi(INPUT INPUT BROWSE brSon1 tt-historico-embarque2.cod-pto-contr).
        
    IF p-l-integra THEN
        DISABLE btUpdateSon1
                btDeleteSon1 WITH FRAME fPage1.
    ELSE
        ENABLE btUpdateSon1
               btDeleteSon1 WITH FRAME fPage1.
    
    IF NOT VALID-HANDLE(h-bocx407) THEN
        RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.
    
    /* tijucas */
    IF NOT l-passou THEN DO:
    
        RUN retorna-seq-ponto-nacionaliz IN h-bocx407(INPUT INPUT FRAME fPage0 tt-historico-embarque.embarque,
                                                      INPUT INPUT FRAME fPage0 tt-historico-embarque.cod-estabel,
                                                      OUTPUT l-seq-nac).
        ASSIGN l-passou = YES.
    END.
    
    
    IF p-l-integra AND (l-seq-nac <= INPUT BROWSE brSon1 tt-historico-embarque2.sequencia) THEN
        DISABLE btAddSon1 WITH FRAME fPage1.
    ELSE
        ENABLE btAddSon1 WITH FRAME fPage1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piNotaComplementar wMasterDetail 
PROCEDURE piNotaComplementar :
/*------------------------------------------------------------------------------
  Purpose: Tratar bot∆o NF Complementar - Mercado Internacional
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE seq-pto-desembarque AS INTEGER NO-UNDO.
    
    ASSIGN btNotaComplementar:SENSITIVE IN FRAME fPage2 = FALSE.
    
    IF AVAIL {&ttSon2} THEN DO:

       /** Conforme l¢gica de listagem das despesas no IM3101 **/
    
       FOR FIRST embarque-imp NO-LOCK
           WHERE embarque-imp.cod-estabel = tt-historico-embarque.cod-estabel
             AND embarque-imp.embarque    = tt-historico-embarque.embarque:
       END.

       FOR FIRST historico-embarque WHERE
                 historico-embarque.cod-estabel   = tt-historico-embarque.cod-estabel AND
                 historico-embarque.embarque      = tt-historico-embarque.embarque    AND
                 historico-embarque.cod-itiner    = tt-historico-embarque.cod-itiner  AND
                 historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar   NO-LOCK:
       END.

       IF AVAIL historico-embarque THEN
           assign seq-pto-desembarque = historico-embarque.sequencia. /*Sequencia do ponto de Nacionalizaá∆o*/

       for each  historico-embarque no-lock
           where historico-embarque.cod-estabel   =  tt-historico-embarque.cod-estabel
           and   historico-embarque.embarque      =  tt-historico-embarque.embarque
           and   historico-embarque.cod-itiner    =  tt-historico-embarque.cod-itiner
           and   historico-embarque.sequencia     >  seq-pto-desembarque /*Depois do ponto de nacionalizaá∆o*/
           and   historico-embarque.cod-pto-contr = {&ttSon2}.cod-pto-contr
           and   historico-embarque.dt-efetiva   <> ?:     /*Despesas Efetivadas*/

           for each  desp-embarque no-lock
               where desp-embarque.cod-estabel       = historico-embarque.cod-estabel
               and   desp-embarque.embarque          = historico-embarque.embarque
               and   desp-embarque.cod-itiner        = historico-embarque.cod-itiner
               and   desp-embarque.cod-pto-contr     = historico-embarque.cod-pto-contr
               and   desp-embarque.cod-desp          = {&ttSon2}.cod-desp
               and  
               &if "{&bf_mat_versao_ems}" >= "2.04" and "{&bf_mat_versao_ems}" < "2.06" &then
                   desp-embarque.log-1 = no                       /*Despesa n∆o pode ser recebida*/
               &elseif "{&bf_mat_versao_ems}" >= "2.06" &then
                   desp-embarque.log-despes-ja-recbda = no        /*Despesa n∆o pode ser recebida*/
               &endif:
               
               /*Despesa deve incidir no valor de frete/seguro/embalagem/outras (pelo menos um dos campos tem que estar marcado)*/
               for first desp-imp no-lock
                   where desp-imp.cod-desp = desp-embarque.cod-desp:
               end.
               if avail desp-imp                              
                   and desp-imp.inc-val-frete       = yes
                   or  desp-imp.inc-val-seguro      = yes
                   or  desp-imp.inc-val-embal       = yes
                   or  desp-imp.inc-val-outras-desp = yes then do:  
                   ASSIGN btNotaComplementar:SENSITIVE IN FRAME fPage2 = TRUE.        
               end.
           end.           
       end.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaEfetivacaoEmbarque wMasterDetail 
PROCEDURE piValidaEfetivacaoEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM TABLE FOR tt-historico-embarque-bo.
    
    DEFINE VARIABLE iPtoEmbarque    AS INTEGER                    NO-UNDO.
    DEFINE VARIABLE iPtoDesembarque AS INTEGER                    NO-UNDO.
    DEFINE VARIABLE h-bocx351       AS HANDLE                     NO-UNDO.
    DEFINE VARIABLE cOrdensSemLI    AS CHARACTER                  NO-UNDO.
    DEFINE VARIABLE c-arquivo       AS CHARACTER   FORMAT "X(30)" NO-UNDO.

    FIND FIRST tt-historico-embarque-bo NO-ERROR.

    /* Licenciamento Importacao */
    IF NOT VALID-HANDLE(h-bocx351) THEN
        RUN cxbo/bocx351.p PERSISTENT SET h-bocx351.
    
    if  valid-handle (h-bocx220) then do:

        assign iPtoEmbarque    = 0
               iPtoDesembarque = 0.

        run findPk_codigo in h-bocx220 (input tt-historico-embarque-bo.cod-estabel,
                                        INPUT tt-historico-embarque-bo.embarque,
                                        output c-return).
        if  c-return = "":U then do:
            run getIntField in h-bocx220 (input "cdn-pto-embarq":U,
                                          output iPtoEmbarque).
            run getIntField in h-bocx220 (input "cdn-pto-desembar":U,
                                          output iPtoDesembarque).
        end.
    end.

    if  (    iPtoEmbarque = tt-historico-embarque-bo.cod-pto-contr
         and tt-historico-embarque-bo.dt-efetiva <> ?)
    or  (    iPtoDesembarque = tt-historico-embarque-bo.cod-pto-contr
         and tt-historico-embarque-bo.dt-efetiva <> ?) then do:
    
        if  valid-handle (h-bocx351) then do:
    
            assign cOrdensSemLI = "":U.
            
            run piRetornaLI in h-bocx351 (input 2,
                                          input yes,
                                          input ?,
                                          input tt-historico-embarque-bo.cod-estabel,
                                          input tt-historico-embarque-bo.embarque,
                                          input ?,
                                          input no,
                                          input yes,
                                          input 0,
                                          input 99999999,
                                          input " ":U,
                                          input "ZZZZZZZZZZZZZZZZ":U,
                                          input " ":U,
                                          input "ZZZZZZZZ":U,
                                          input " ":U,
                                          input "ZZZZZZZZZZZZZZZZZZZZ":U,
                                          output table tt-licenciam-import-oc). 
        end.
    
        bloco_LI:
        for each  tt-licenciam-import-oc
            where tt-licenciam-import-oc.licenca-import = "":U
            break by tt-licenciam-import-oc.numero-ordem
                  by tt-licenciam-import-oc.parcela:
    
            if  first-of (tt-licenciam-import-oc.numero-ordem) then do:
                if  cOrdensSemLI = "":U then
                    assign cOrdensSemLI = string(tt-licenciam-import-oc.numero-ordem).
                else
                    assign cOrdensSemLI = cOrdensSemLI + ", ":U + string(tt-licenciam-import-oc.numero-ordem).
                IF cOrdensSemLI <> "" THEN
                    LEAVE bloco_LI.
            end.
        end.
    
        if  cOrdensSemLi <> "":U then do:
            ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "IM9056RP":U + ".tmp":U.

            RUN imp/im9056rp.p (INPUT tt-historico-embarque-bo.cod-estabel,
                                INPUT tt-historico-embarque-bo.embarque,
                                INPUT TABLE tt-licenciam-import-oc).
        
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-embarque AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Embarque" *}
            ASSIGN c-lbl-liter-embarque = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-gentileza-consultar-arquivo AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Gentileza_consultar_arquivo" *}
            ASSIGN c-lbl-liter-gentileza-consultar-arquivo = TRIM(RETURN-VALUE).
            run utp/ut-msgs.p (input "Show":U,
                               input 30446,
                               input c-lbl-liter-embarque + "~~" + c-lbl-liter-gentileza-consultar-arquivo + " " + c-arquivo).
            if  return-value = "no":U then
                return "NOK":U.
        end.
    end.

    IF VALID-HANDLE(h-bocx351) THEN DO:
        DELETE PROCEDURE h-bocx351.
        ASSIGN h-bocx351 = ?.
    END.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaHistoricoEmbarque wMasterDetail 
PROCEDURE setaHistoricoEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM r-Rowid AS ROWID NO-UNDO.

ASSIGN r-historico-embarque = r-Rowid
       l-historico          = YES.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showFilter wMasterDetail 
PROCEDURE showFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM i-page AS INTEGER NO-UNDO.

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

    DEFINE IMAGE setaFirst
         FILENAME "image/im-fir.bmp":U
         SIZE 3 BY 1.
    
    DEFINE IMAGE setaLast
         FILENAME "image/im-las.bmp":U
         SIZE 3 BY 1.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.    
    DEFINE VARIABLE i-pto-ini LIKE historico-embarque.cod-pto-contr  NO-UNDO.  
    DEFINE VARIABLE i-pto-fim LIKE historico-embarque.cod-pto-contr NO-UNDO.
    
    DEFINE FRAME fAbreFiltro
        i-pto-ini AT ROW 1.8 COL 9 COLON-ALIGNED
        setaFirst AT ROW 1.8 COL 17 COLON-ALIGNED
        setaLast  AT ROW 1.8 COL 21 COLON-ALIGNED
        i-pto-fim AT ROW 1.8 COL 25 COLON-ALIGNED NO-LABEL
        btOK        AT ROW 3.6 COL 2.14
        btCancel    AT ROW 3.6 COL 13
        rtAbreFiltro    AT ROW 3.4 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Filtrar" FONT 1 WIDTH 35
             DEFAULT-BUTTON btOK CANCEL-BUTTON btCancel.

    ASSIGN i-pto-ini:SCREEN-VALUE IN FRAME fAbreFiltro = IF i-page = 2 THEN STRING(i-pto-desp-ini) ELSE STRING(i-pto-decl-ini)
           i-pto-fim:SCREEN-VALUE IN FRAME fAbreFiltro = IF i-page = 2 THEN STRING(i-pto-desp-fim) ELSE STRING(i-pto-decl-fim).

    ON "CHOOSE":U OF btOK IN FRAME fAbreFiltro DO:
        ASSIGN i-pto-ini
               i-pto-fim.
        IF i-page = 2 THEN DO:
            ASSIGN i-pto-desp-ini = i-pto-ini
                   i-pto-desp-fim = i-pto-fim.
        END.
        ELSE IF i-page = 3 THEN DO:
            ASSIGN i-pto-decl-ini = i-pto-ini
                   i-pto-decl-fim = i-pto-fim.
        END.
    END.
    
    ENABLE i-pto-ini
           i-pto-fim
           btOK btCancel 
        WITH FRAME fAbreFiltro.

    ASSIGN i-pto-ini:HEIGHT = 0.88
           i-pto-ini:WIDTH  = 7.
    {utp/ut-liter.i "Pto Contr"}
    ASSIGN i-pto-ini:LABEL     = TRIM(RETURN-VALUE).

    ASSIGN i-pto-fim:HEIGHT = 0.88
           i-pto-fim:WIDTH  = 7.
    
    WAIT-FOR "GO":U OF FRAME fAbreFiltro.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescDesp wMasterDetail 
FUNCTION fnDescDesp RETURNS CHARACTER
  (input pcod-desp as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var c-desc-desp as char no-undo.
  def var cReturn     as char no-undo.


    RUN findCodigo IN h-bocx095 (INPUT pcod-desp,
                                 OUTPUT cReturn).
    IF cReturn = "":U THEN 
        RUN getCharField IN h-bocx095 (INPUT "descricao":U,
                                       OUTPUT c-desc-desp).

    RETURN c-desc-desp. /* Function return value. */



END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescricao wMasterDetail 
FUNCTION fnDescricao RETURNS CHARACTER
  (input pcod-pto-contr AS INTEGER,
   input pcod-estabel   AS CHARACTER,
   input pembarque      AS CHARACTER, 
   input pcod-itiner    AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-descricao AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-return    AS CHARACTER NO-UNDO.

    RUN findCh-itiner IN h-bocx2303(INPUT pcod-estabel,  
                                    INPUT pembarque,  
                                    INPUT pcod-itiner,                                                 
                                    INPUT pcod-pto-contr,                                               
                                    OUTPUT c-return).
    IF TRIM(c-return) = "":U THEN
        RUN getCharField in h-bocx2303 (input "descricao":U, output c-descricao).

    IF TRIM(c-descricao) = "":U THEN DO:
        RUN findCodigo IN h-bocx1102 (INPUT pcod-pto-contr, OUTPUT c-return).
        IF TRIM(c-return) = "":U THEN
            RUN getCharField IN h-bocx1102 (INPUT "descricao":U, OUTPUT c-descricao).  
    END.                                                       
    

    RETURN c-descricao.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDiferenca wMasterDetail 
FUNCTION fnDiferenca RETURNS INTEGER
  (input dt-efetiva as date) :
  def var num-dif as integer no-undo.
  
  if dt-efetiva <> ? then 
     assign num-dif = dt-efetiva - tt-historico-embarque2.dt-previsao.
  else 
     assign num-dif = dt-ult-previsao - tt-historico-embarque2.dt-previsao.
  
  RETURN num-dif.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnIntegrDi wMasterDetail 
FUNCTION fnIntegrDi RETURNS LOGICAL
  ( pCodPtoControl AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF NOT VALID-HANDLE(h-bocx384) THEN
      RUN cxbo/bocx384.p PERSISTENT SET h-bocx384.

  RUN validaIntegraPtoDi IN h-bocx384 (INPUT INPUT FRAME fPage0 tt-historico-embarque.embarque,
                                       INPUT INPUT FRAME fPage0 tt-historico-embarque.cod-estabel,
                                       INPUT pCodPtoControl,
                                       OUTPUT l-integra-di).


  RETURN l-integra-di.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMoeda wMasterDetail 
FUNCTION fnMoeda RETURNS CHARACTER
  (input pmo-codigo as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var c-descricao as char no-undo.
  def var cReturn as char no-undo.
  RUN findCodigo in h-boun005 (input pmo-codigo, output cReturn).
  if  cReturn = "" then
      RUN getCharField in h-boun005 (input "descricao", output c-descricao).

  RETURN c-descricao.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNomeAbrev wMasterDetail 
FUNCTION fnNomeAbrev RETURNS CHARACTER
  (input pcod-emitente-desp as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var c-nomeab as char no-undo.
  def var cReturn as char no-undo.

  RUN findCodigo in h-boad098 (input pcod-emitente-desp, output cReturn).
  if  cReturn = "" then
      RUN getCharField in h-boad098 (input "nome-abrev", output c-nomeab).

  RETURN c-nomeab.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPtoSeq wMasterDetail 
FUNCTION fnPtoSeq RETURNS INTEGER
  ( INPUT p-cod-est AS CHAR,
    INPUT p-embarque AS CHAR,
    INPUT p-cod-itiner AS INT,
    input p-seq as int ):
/*------------------------------------------------------------------------------
  Purpose:  Retornar o c¢digo do ponto de controle de acordo com a sequencia do mesmo.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-pto AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-return    AS CHARACTER NO-UNDO.

    RUN findPto-Controle-por-sequencia IN h-bocx2303(INPUT p-cod-est,  
                                                     INPUT p-embarque,  
                                                     INPUT p-cod-itiner,                                                 
                                                     INPUT p-seq,                                               
                                                     OUTPUT c-return).

    IF TRIM(c-return) = "":U THEN
        RUN getIntField in h-bocx2303 (input "cod-pto-contr":U, output i-pto). 

    RETURN i-pto.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSeqPto wMasterDetail 
FUNCTION fnSeqPto RETURNS INTEGER
  (input pcod-estabel   AS CHARACTER,
   input pembarque      AS CHARACTER, 
   input pcod-itiner    AS INTEGER,
   input pcod-pto-contr AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-seq    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-return AS CHARACTER NO-UNDO.

    RUN findCh-itiner IN h-bocx2303(INPUT pcod-estabel,  
                                    INPUT pembarque,  
                                    INPUT pcod-itiner,                                                 
                                    INPUT pcod-pto-contr,                                               
                                    OUTPUT c-return).
    IF TRIM(c-return) = "":U THEN
        RUN getIntField in h-bocx2303 (input "sequencia":U, output i-seq).

    RETURN i-seq.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUF wMasterDetail 
FUNCTION fnUF RETURNS CHARACTER
  (input pcod-pto-contr AS INTEGER,
   input pcod-estabel   AS CHARACTER,
   input pembarque      AS CHARACTER, 
   input pcod-itiner    AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  Retorna UF do ponto de controle do Acompanhamento de Embarque
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-char-1    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-return    AS CHARACTER NO-UNDO.

    RUN findCh-itiner IN h-bocx2303(INPUT pcod-estabel,  
                                    INPUT pembarque,  
                                    INPUT pcod-itiner,                                                 
                                    INPUT pcod-pto-contr,                                               
                                    OUTPUT c-return).
    IF c-return = "":U THEN
       RUN getCharField in h-bocx2303 (input "char-1":U, output c-char-1).


    RETURN SUBSTRING(c-char-1,1,2).   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

