&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-carg-rural NO-UNDO LIKE carg-rural
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-liber-carg NO-UNDO LIKE liber-carg
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-pesagem NO-UNDO LIKE pesagem
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-produt-carg NO-UNDO LIKE produt-carg
       FIELD r-rowid AS rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0410 2.00.00.008 } /*** 010008 ***/

{include/i_prdvers.i} /* Vers∆o Produto */

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0410 MAQ }
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program         AQ0410
&GLOBAL-DEFINE Version        2.00.00.008

&GLOBAL-DEFINE Folder          YES
&GLOBAL-DEFINE InitialPage     1

&GLOBAL-DEFINE FolderLabels    Carga I,Carga II,Lib. Carga,Produtores,Pesagem

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         NO
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         NO
&GLOBAL-DEFINE Save           NO

&GLOBAL-DEFINE ttTable        tt-carg-rural
&GLOBAL-DEFINE hDBOTable      h-boin00961
&GLOBAL-DEFINE DBOTable       carg-rural

&GLOBAL-DEFINE ttSon3         tt-liber-carg
&GLOBAL-DEFINE hDBOSon3       h-boin00982
&GLOBAL-DEFINE DBOSon3Table   liber-carg
&GLOBAL-DEFINE DBOSon3Destroy YES

&GLOBAL-DEFINE ttSon4         tt-produt-carg
&GLOBAL-DEFINE hDBOSon4       h-boin00965
&GLOBAL-DEFINE DBOSon4Table   produt-carg
&GLOBAL-DEFINE DBOSon4Destroy YES


&GLOBAL-DEFINE ttSon5         tt-pesagem
&GLOBAL-DEFINE hDBOSon5       h-boin00981
&GLOBAL-DEFINE DBOSon5Table   pesagem
&GLOBAL-DEFINE DBOSon5Destroy YES


&GLOBAL-DEFINE page0KeyFields tt-carg-rural.num-carg 
&GLOBAL-DEFINE page0Fields    tt-carg-rural.cod-estabel ~
                              c-nome-estabel

&GLOBAL-DEFINE page1Fields    tt-carg-rural.cod-carg ~
                              tt-carg-rural.cod-placa ~
                              tt-carg-rural.cod-uf ~
                              tt-carg-rural.dat-trans ~
                              tt-carg-rural.cod-inter-veic ~
                              tt-carg-rural.qti-comptmento ~
                              tt-carg-rural.dat-entr ~
                              tt-carg-rural.hra-entr ~
                              tt-carg-rural.cod-transp ~
                              c-nome-transp ~
                              tt-carg-rural.nom-motorista ~
                              tt-carg-rural.val-hodom-inicial ~
                              tt-carg-rural.val-hodom-final ~
                              d-km-rodados ~
                              tt-carg-rural.it-codigo ~
                              c-desc-item ~
                              tt-carg-rural.cod-refer ~
                              c-desc-refer ~
                              tt-carg-rural.cod-rota ~
                              c-desc-rota ~
                              tt-carg-rural.cod-usuario ~
                              c-nome-usuar ~
                              c-situacao


&GLOBAL-DEFINE page2Fields    tt-carg-rural.val-densidade ~
                              tt-carg-rural.qtd-aferid ~
                              tt-carg-rural.qtd-coleta ~
                              d-diferenca ~
                              tt-carg-rural.val-frete

&GLOBAL-DEFINE page3Fields    fi-hidden-liber
&GLOBAL-DEFINE page3Browse    brLiberCarg
&GLOBAL-DEFINE page3Widgets   bt-roteiro

&GLOBAL-DEFINE page4Fields    fi-hidden-produt
&GLOBAL-DEFINE page4Browse    brProdutCarg
&GLOBAL-DEFINE page4Widgets   bt-produt-coletiv

&GLOBAL-DEFINE page5Fields    tt-carg-rural.qtd-peso-brut ~
                              tt-carg-rural.qtd-peso-tara ~
                              tt-carg-rural.qtd-peso-liq
 
 
 

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE i-idi-tip-aferic       AS INTEGER     NO-UNDO.

DEFINE VARIABLE c-liber-brw            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-aprov-brw            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-motiv-nao-coleta-brw AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nao-coleta-brw       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-situacao-brw         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-rej-brw         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nome-abrev-brw       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-qtd-total-brw        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-habilita-nc          AS LOGICAL     NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE gr-ficha-cq   AS ROWID NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod-estabel AS CHARACTER INITIAL ? NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_num-carg    AS INTEGER   INITIAL ? NO-UNDO.


/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO. /* Carga */
DEFINE VARIABLE {&hDBOSon3}  AS HANDLE NO-UNDO. /* Liber Carg */
DEFINE VARIABLE {&hDBOSon4}  AS HANDLE NO-UNDO. /* Produt Carg */
DEFINE VARIABLE h-boad107na  AS HANDLE NO-UNDO. /* Estabelec */
DEFINE VARIABLE h-boad268na  AS HANDLE NO-UNDO. /* Transporte */
DEFINE VARIABLE h-boin172na  AS HANDLE NO-UNDO. /* Item */
DEFINE VARIABLE h-boin377na  AS HANDLE NO-UNDO. /* Referencia */
DEFINE VARIABLE h-boin00975  AS HANDLE NO-UNDO. /* Rota  */
DEFINE VARIABLE h-bofn017    AS HANDLE NO-UNDO. /* Usuario */
DEFINE VARIABLE h-boin124a   AS HANDLE NO-UNDO. /* Ficha-cq */
DEFINE VARIABLE h-boin01004  AS HANDLE NO-UNDO. /* Motivo nao Coleta  */
DEFINE VARIABLE h-boin00966  AS HANDLE NO-UNDO. /* Pto Coleta  */
DEFINE VARIABLE h-boin00981  AS HANDLE NO-UNDO. /* Pesagem  */
DEFINE VARIABLE h-boin00983  AS HANDLE NO-UNDO. /* item Estab Rural  */
DEFINE VARIABLE h-boin01009  AS HANDLE NO-UNDO. /* Nao Conformidade */
DEFINE VARIABLE h-boin047    AS HANDLE NO-UNDO. /* Codigo Rejeicao */
DEFINE VARIABLE h-boad098    AS HANDLE NO-UNDO. /* emitente     */

&IF "{&product_version}" < "12.1.C":U &THEN /* 12.1.13 */
DEFINE VARIABLE c-observacao AS CHARACTER NO-UNDO.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brLiberCarg

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-liber-carg tt-pesagem tt-produt-carg

/* Definitions for BROWSE brLiberCarg                                   */
&Scoped-define FIELDS-IN-QUERY-brLiberCarg tt-liber-carg.cdn-compart fn-liberacao(tt-liber-carg.idi-autoriz-descarga) @ c-liber-brw fn-aprov(tt-liber-carg.idi-aprov) @ c-aprov-brw tt-liber-carg.val-quant tt-liber-carg.val-peso-liq tt-liber-carg.cod-depos tt-liber-carg.lote tt-liber-carg.dt-vali-lote &IF "{&product_version}" >= "12.1.C":U &THEN /* 12.1.13 */ tt-liber-carg.nr-ficha &ELSE tt-liber-carg.num-livre-1 &ENDIF tt-liber-carg.codigo-rejei fn-desc-rejei(tt-liber-carg.codigo-rejei) @ c-desc-rej-brw &IF "{&product_version}" >= "12.1.C":U &THEN /* 12.1.13 */ tt-liber-carg.cod-obs &ELSE SUBSTR(tt-liber-carg.cod-livre-1, 1, 100) @ c-observacao &ENDIF   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brLiberCarg   
&Scoped-define SELF-NAME brLiberCarg
&Scoped-define QUERY-STRING-brLiberCarg FOR EACH tt-liber-carg NO-LOCK
&Scoped-define OPEN-QUERY-brLiberCarg OPEN QUERY {&SELF-NAME} FOR EACH tt-liber-carg NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brLiberCarg tt-liber-carg
&Scoped-define FIRST-TABLE-IN-QUERY-brLiberCarg tt-liber-carg


/* Definitions for BROWSE brPesagem                                     */
&Scoped-define FIELDS-IN-QUERY-brPesagem ~
fn-situacao(INPUT {&ttSon5}.num-carg, INPUT {&ttSon5}.cdn-pesagem) @ c-situacao-brw ~
tt-pesagem.cdn-pesagem tt-pesagem.val-peso-balan tt-pesagem.val-peso-aferid ~
tt-pesagem.val-quant 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brPesagem 
&Scoped-define QUERY-STRING-brPesagem FOR EACH tt-pesagem NO-LOCK
&Scoped-define OPEN-QUERY-brPesagem OPEN QUERY brPesagem FOR EACH tt-pesagem NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brPesagem tt-pesagem
&Scoped-define FIRST-TABLE-IN-QUERY-brPesagem tt-pesagem


/* Definitions for BROWSE brProdutCarg                                  */
&Scoped-define FIELDS-IN-QUERY-brProdutCarg tt-produt-carg.cdn-produt-respons fn-nome-abrev(tt-produt-carg.cdn-produt-respons) @ c-nome-abrev-brw tt-produt-carg.cod-pto-coleta tt-produt-carg.cdn-repos tt-produt-carg.cdn-compart fn-qtd-total(tt-produt-carg.num-carg, tt-produt-carg.cod-pto-coleta, tt-produt-carg.cdn-compart, tt-produt-carg.cdn-repos) @ d-qtd-total-brw tt-produt-carg.val-temperat tt-produt-carg.cod-amostra tt-produt-carg.cod-lacre tt-produt-carg.cod-propried fn-motiv-nao-coleta(INPUT {&ttSon4}.cdn-motiv-nao-coleta) @ c-motiv-nao-coleta-brw fn-idi-nao-colta(INPUT {&ttSon4}.idi-nao-coleta) @ c-nao-coleta-brw tt-produt-carg.qtd-medid-regua tt-produt-carg.dat-coleta tt-produt-carg.hra-coleta   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brProdutCarg   
&Scoped-define SELF-NAME brProdutCarg
&Scoped-define QUERY-STRING-brProdutCarg FOR EACH tt-produt-carg NO-LOCK
&Scoped-define OPEN-QUERY-brProdutCarg OPEN QUERY {&SELF-NAME} FOR EACH tt-produt-carg NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brProdutCarg tt-produt-carg
&Scoped-define FIRST-TABLE-IN-QUERY-brProdutCarg tt-produt-carg


/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brLiberCarg}

/* Definitions for FRAME fPage4                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage4 ~
    ~{&OPEN-QUERY-brProdutCarg}

/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-brPesagem}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-carg-rural.num-carg ~
tt-carg-rural.cod-estabel 
&Scoped-define ENABLED-TABLES tt-carg-rural
&Scoped-define FIRST-ENABLED-TABLE tt-carg-rural
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btFirst btPrev btNext ~
btLast btGoTo btSearch bt-nao-coleta btQueryJoins btReportsJoins btExit ~
btHelp c-nome-estabel 
&Scoped-Define DISPLAYED-FIELDS tt-carg-rural.num-carg ~
tt-carg-rural.cod-estabel 
&Scoped-define DISPLAYED-TABLES tt-carg-rural
&Scoped-define FIRST-DISPLAYED-TABLE tt-carg-rural
&Scoped-Define DISPLAYED-OBJECTS c-nome-estabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-aprov wMaintenance 
FUNCTION fn-aprov RETURNS CHARACTER
  ( i-idi-aprov AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-des-rota wMaintenance 
FUNCTION fn-des-rota RETURNS CHARACTER
(c-cod-rota AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-item wMaintenance 
FUNCTION fn-desc-item RETURNS CHARACTER
    (c-it-codigo AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-refer wMaintenance 
FUNCTION fn-desc-refer RETURNS CHARACTER
   (c-cod-refer AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-rejei wMaintenance 
FUNCTION fn-desc-rejei RETURNS CHARACTER
  ( i-cod-rejei AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-idi-nao-colta wMaintenance 
FUNCTION fn-idi-nao-colta RETURNS CHARACTER
  ( i-idi-nao-coleta AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-liberacao wMaintenance 
FUNCTION fn-liberacao RETURNS CHARACTER
  ( idi-autoriz-descarga AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-motiv-nao-coleta wMaintenance 
FUNCTION fn-motiv-nao-coleta RETURNS CHARACTER
  ( i-cdn-motiv-nao-coleta AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-nome-abrev wMaintenance 
FUNCTION fn-nome-abrev RETURNS CHARACTER
  ( i-cdn-produt-rural AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-nome-estabel wMaintenance 
FUNCTION fn-nome-estabel RETURNS CHARACTER
   (c-cod-estabel AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-nome-transp wMaintenance 
FUNCTION fn-nome-transp RETURNS CHARACTER
 (i-cod-transp AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-nome-usuar wMaintenance 
FUNCTION fn-nome-usuar RETURNS CHARACTER
  (c-cod-usuar AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-qtd-total wMaintenance 
FUNCTION fn-qtd-total RETURNS DECIMAL
  ( iNumCarg AS INTEGER, cPtoColeta AS CHARACTER, pCdnCompart AS INTEGER,  pCdnRepos AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-situacao wMaintenance 
FUNCTION fn-situacao RETURNS CHARACTER
  ( i-num-carg AS INT, INPUT i-cdn-pesagem AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"         ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"         ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"          ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"           ACCELERATOR "CTRL-END"
       RULE                                               
       MENU-ITEM miGoTo         LABEL "&V† Para"          ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"         ACCELERATOR "CTRL-F5"
       MENU-ITEM miNC           LABEL "&N∆o Conformidade" ACCELERATOR "CTRL-N"
       RULE
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"             ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-nao-coleta 
     IMAGE-UP FILE "image/im-solcot.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-solcot.bmp":U
     LABEL "Search" 
     SIZE 4 BY 1.25 TOOLTIP "N∆o Conformidade".

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

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE c-nome-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-refer AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-rota AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-transp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-usuar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .88 NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Situaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 15.86 BY .88 NO-UNDO.

DEFINE VARIABLE d-km-rodados AS DECIMAL FORMAT ">,>>>,>>9.999":U INITIAL 0 
     LABEL "KM Rodados" 
     VIEW-AS FILL-IN 
     SIZE 15.86 BY .88 NO-UNDO.

DEFINE VARIABLE d-diferenca AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Diferenáa" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE BUTTON bt-roteiro 
     LABEL "Roteiro" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-hidden-liber AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE BUTTON bt-produt-coletiv 
     LABEL "Coletivo" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-hidden-produt AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 6.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brLiberCarg FOR 
      tt-liber-carg SCROLLING.

DEFINE QUERY brPesagem FOR 
      tt-pesagem SCROLLING.

DEFINE QUERY brProdutCarg FOR 
      tt-produt-carg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brLiberCarg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brLiberCarg wMaintenance _FREEFORM
  QUERY brLiberCarg NO-LOCK DISPLAY
      tt-liber-carg.cdn-compart COLUMN-LABEL "Compart" FORMAT ">>9":U WIDTH 6
      fn-liberacao(tt-liber-carg.idi-autoriz-descarga) @ c-liber-brw COLUMN-LABEL "Liberaá∆o" FORMAT "x(20)":U  WIDTH 12
      fn-aprov(tt-liber-carg.idi-aprov) @ c-aprov-brw COLUMN-LABEL "An†lise" FORMAT "x(12)":U WIDTH 10                  
      tt-liber-carg.val-quant FORMAT ">>>>,>>>,>>9.9999":U WIDTH 9.43 COLUMN-LABEL "Quantidade"
      tt-liber-carg.val-peso-liq FORMAT ">>>>,>>>,>>9.9999":U WIDTH 13.43
      tt-liber-carg.cod-depos FORMAT "x(3)":U WIDTH 5 COLUMN-LABEL "Dep"  
      tt-liber-carg.lote FORMAT "x(40)":U WIDTH 12.86
      tt-liber-carg.dt-vali-lote FORMAT "99/99/9999":U COLUMN-LABEL "Valid Lote"
      &IF "{&product_version}" >= "12.1.C":U &THEN /* 12.1.13 */
      tt-liber-carg.nr-ficha COLUMN-LABEL "Roteiro" FORMAT ">>>>,>>9":U WIDTH 7.72
      &ELSE
      tt-liber-carg.num-livre-1 COLUMN-LABEL "Roteiro" FORMAT ">>>>,>>9":U WIDTH 7.72
      &ENDIF      
      tt-liber-carg.codigo-rejei FORMAT ">>9":U
      fn-desc-rejei(tt-liber-carg.codigo-rejei) @ c-desc-rej-brw COLUMN-LABEL 'Desc Rejeiá∆o' FORMAT "x(30)" WIDTH 20
      &IF "{&product_version}" >= "12.1.C":U &THEN /* 12.1.13 */
      tt-liber-carg.cod-obs FORMAT "X(2000)":U COLUMN-LABEL 'Observaá∆o' WIDTH 20
      &ELSE
      SUBSTR(tt-liber-carg.cod-livre-1, 1, 100) @ c-observacao COLUMN-LABEL 'Observaá∆o' FORMAT "x(100)" WIDTH 20
      &ENDIF
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 81.86 BY 10.71 FIT-LAST-COLUMN.

DEFINE BROWSE brPesagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brPesagem wMaintenance _STRUCTURED
  QUERY brPesagem NO-LOCK DISPLAY
      fn-situacao(INPUT {&ttSon5}.num-carg, INPUT {&ttSon5}.cdn-pesagem) @ c-situacao-brw COLUMN-LABEL "Situaá∆o" FORMAT "x(10)":U
            WIDTH 16.43
      tt-pesagem.cdn-pesagem COLUMN-LABEL "Seq" FORMAT ">>>,>>9":U
      tt-pesagem.val-peso-balan COLUMN-LABEL "Pesagem" FORMAT ">>>>,>>>,>>9.9999":U
            WIDTH 12.86
      tt-pesagem.val-peso-aferid COLUMN-LABEL "Peso" FORMAT ">>>>,>>>,>>9.9999":U
      tt-pesagem.val-quant FORMAT ">>>>,>>>,>>9.9999":U WIDTH 20.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 77.43 BY 5.08 FIT-LAST-COLUMN.

DEFINE BROWSE brProdutCarg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brProdutCarg wMaintenance _FREEFORM
  QUERY brProdutCarg NO-LOCK DISPLAY
      tt-produt-carg.cdn-produt-respons COLUMN-LABEL "Produtor" FORMAT ">>>,>>>,>>9":U
      fn-nome-abrev(tt-produt-carg.cdn-produt-respons) @ c-nome-abrev-brw COLUMN-LABEL "Nome" FORMAT "x(40)":U WIDTH 20
      tt-produt-carg.cod-pto-coleta FORMAT "x(12)":U
      tt-produt-carg.cdn-repos FORMAT ">>>,>>9":U
      tt-produt-carg.cdn-compart COLUMN-LABEL "Comp." FORMAT ">>9":U
      fn-qtd-total(tt-produt-carg.num-carg, tt-produt-carg.cod-pto-coleta, tt-produt-carg.cdn-compart, tt-produt-carg.cdn-repos) @  d-qtd-total-brw COLUMN-LABEL "Quantidade" FORMAT ">>>>,>>>,>>9.9999":U
      tt-produt-carg.val-temperat FORMAT "->,>>9.9999":U
      tt-produt-carg.cod-amostra FORMAT "x(20)":U WIDTH 17
      tt-produt-carg.cod-lacre FORMAT "x(20)":U WIDTH 17
      tt-produt-carg.cod-propried FORMAT "x(30)":U WIDTH 17 COLUMN-LABEL "Propriedade"
      fn-motiv-nao-coleta(INPUT {&ttSon4}.cdn-motiv-nao-coleta) @ c-motiv-nao-coleta-brw COLUMN-LABEL "N∆o Coleta" FORMAT "x(80)" WIDTH 20
      fn-idi-nao-colta(INPUT {&ttSon4}.idi-nao-coleta) @ c-nao-coleta-brw COLUMN-LABEL "Indicador NC"  FORMAT "x(20)" WIDTH 20
      tt-produt-carg.qtd-medid-regua COLUMN-LABEL "Medida RÇgua" FORMAT ">>>,>>9.9999":U
      tt-produt-carg.dat-coleta COLUMN-LABEL "Data Coleta" FORMAT "99/99/9999":U
      tt-produt-carg.hra-coleta COLUMN-LABEL "Hora Coleta" FORMAT "99:99:99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82.86 BY 10.71 FIT-LAST-COLUMN.


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
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     bt-nao-coleta AT ROW 1.13 COL 70.57 HELP
          "Pesquisa"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-carg-rural.num-carg AT ROW 3.42 COL 14 COLON-ALIGNED
          LABEL "Carga"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-carg-rural.cod-estabel AT ROW 3.42 COL 38.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-nome-estabel AT ROW 3.42 COL 45.43 COLON-ALIGNED NO-LABEL
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.08
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     brProdutCarg AT ROW 1.38 COL 2.14
     bt-produt-coletiv AT ROW 12.21 COL 1.86
     fi-hidden-produt AT ROW 12.25 COL 63 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.42
         SIZE 84.43 BY 12.33.

DEFINE FRAME fPage2
     tt-carg-rural.val-densidade AT ROW 3.25 COL 14.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-carg-rural.qtd-aferid AT ROW 4.25 COL 14.14 COLON-ALIGNED
          LABEL "Qtde Aferida"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tt-carg-rural.qtd-coleta AT ROW 5.25 COL 14.14 COLON-ALIGNED
          LABEL "Qtde Coletada"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     d-diferenca AT ROW 6.25 COL 14.14 COLON-ALIGNED
     tt-carg-rural.val-frete AT ROW 7.25 COL 14.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .79
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.38
         SIZE 84.43 BY 12.13
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tt-carg-rural.cod-carga AT ROW 1.21 COL 13 COLON-ALIGNED
          LABEL "C¢digo"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-carg-rural.cod-placa AT ROW 1.21 COL 43.72 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     tt-carg-rural.cod-uf AT ROW 1.21 COL 75.57 COLON-ALIGNED
          LABEL "UF"
          VIEW-AS FILL-IN 
          SIZE 6.14 BY .88
     tt-carg-rural.dat-trans AT ROW 2.21 COL 13 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-carg-rural.cod-inter-veic AT ROW 2.21 COL 43.72 COLON-ALIGNED
          LABEL "Ve°culo"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .88
     tt-carg-rural.qti-comptmento AT ROW 2.38 COL 75.57 COLON-ALIGNED
          LABEL "Compartimentos"
          VIEW-AS FILL-IN 
          SIZE 6.14 BY .88
     tt-carg-rural.dat-entr AT ROW 3.21 COL 13 COLON-ALIGNED
          LABEL "Data Carga"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-carg-rural.hra-entr AT ROW 3.21 COL 43.72 COLON-ALIGNED
          LABEL "Hora" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-carg-rural.cod-transp AT ROW 4.21 COL 13 COLON-ALIGNED
          LABEL "Transportador"
          VIEW-AS FILL-IN 
          SIZE 8.14 BY .88
     c-nome-transp AT ROW 4.21 COL 21.29 COLON-ALIGNED NO-LABEL
     tt-carg-rural.nom-motorista AT ROW 5.21 COL 13 COLON-ALIGNED
          LABEL "Motorista"
          VIEW-AS FILL-IN 
          SIZE 69 BY .88
     tt-carg-rural.val-hodom-inicial AT ROW 6.21 COL 13 COLON-ALIGNED
          LABEL "KM Inicial"
          VIEW-AS FILL-IN 
          SIZE 15.86 BY .88
     tt-carg-rural.val-hodom-final AT ROW 6.21 COL 39.86 COLON-ALIGNED
          LABEL "KM Final"
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .88
     d-km-rodados AT ROW 7.21 COL 13 COLON-ALIGNED
     tt-carg-rural.it-codigo AT ROW 8.21 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.86 BY .88
     c-desc-item AT ROW 8.21 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     tt-carg-rural.cod-refer AT ROW 9.21 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.86 BY .88
     c-desc-refer AT ROW 9.21 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     tt-carg-rural.cod-rota AT ROW 10.21 COL 13 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 15.86 BY .88
     c-desc-rota AT ROW 10.21 COL 29 COLON-ALIGNED NO-LABEL
     tt-carg-rural.cod-usuario AT ROW 11.25 COL 13 COLON-ALIGNED
          LABEL "Usu†rio"
          VIEW-AS FILL-IN 
          SIZE 15.86 BY .88
     c-nome-usuar AT ROW 11.25 COL 29 COLON-ALIGNED NO-LABEL
     c-situacao AT ROW 12.25 COL 13 COLON-ALIGNED
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.38
         SIZE 84.43 BY 12.38
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage3
     brLiberCarg AT ROW 1.29 COL 2.14
     bt-roteiro AT ROW 12.13 COL 2 WIDGET-ID 2
     fi-hidden-liber AT ROW 12 COL 67 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.72 ROW 6.42
         SIZE 84.29 BY 12.33.

DEFINE FRAME fPage5
     brPesagem AT ROW 2.42 COL 80 RIGHT-ALIGNED WIDGET-ID 200
     tt-carg-rural.qtd-peso-brut AT ROW 8.96 COL 12.29 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     tt-carg-rural.qtd-peso-tara AT ROW 9.96 COL 12.29 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     tt-carg-rural.qtd-peso-liq AT ROW 10.96 COL 12.29 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     "Aferiá∆o" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 1.67 COL 3.72
     RECT-1 AT ROW 2 COL 2 WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.86 ROW 6.42
         SIZE 84 BY 12.25.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-carg-rural T "?" NO-UNDO movind carg-rural
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
      TABLE: tt-liber-carg T "?" NO-UNDO movind liber-carg
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
      TABLE: tt-pesagem T "?" NO-UNDO movind pesagem
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
      TABLE: tt-produt-carg T "?" NO-UNDO movind produt-carg
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS rowid
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
         HEIGHT             = 18.08
         WIDTH              = 90
         MAX-HEIGHT         = 38.63
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.63
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
  NOT-VISIBLE,                                                          */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-carg-rural.num-carg IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN tt-carg-rural.cod-carga IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-carg-rural.cod-inter-veic IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-carg-rural.cod-transp IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-carg-rural.cod-uf IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-carg-rural.cod-usuario IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-carg-rural.dat-entr IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-carg-rural.hra-entr IN FRAME fPage1
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN tt-carg-rural.nom-motorista IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-carg-rural.qti-comptmento IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-carg-rural.val-hodom-final IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-carg-rural.val-hodom-inicial IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN tt-carg-rural.qtd-aferid IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-carg-rural.qtd-coleta IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brLiberCarg 1 fPage3 */
ASSIGN 
       fi-hidden-liber:HIDDEN IN FRAME fPage3           = TRUE.

/* SETTINGS FOR FRAME fPage4
                                                                        */
/* BROWSE-TAB brProdutCarg 1 fPage4 */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brPesagem RECT-1 fPage5 */
/* SETTINGS FOR BROWSE brPesagem IN FRAME fPage5
   ALIGN-R                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brLiberCarg
/* Query rebuild information for BROWSE brLiberCarg
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-liber-carg NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brLiberCarg */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brPesagem
/* Query rebuild information for BROWSE brPesagem
     _TblList          = "Temp-Tables.tt-pesagem"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > "_<CALC>"
"fn-situacao(INPUT {&ttSon5}.num-carg, INPUT {&ttSon5}.cdn-pesagem) @ c-situacao-brw" "Situaá∆o" "x(10)" ? ? ? ? ? ? ? no ? no no "16.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-pesagem.cdn-pesagem
"tt-pesagem.cdn-pesagem" "Seq" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-pesagem.val-peso-balan
"tt-pesagem.val-peso-balan" "Pesagem" ? "decimal" ? ? ? ? ? ? no ? no no "12.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-pesagem.val-peso-aferid
"tt-pesagem.val-peso-aferid" "Peso" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-pesagem.val-quant
"tt-pesagem.val-quant" ? ? "decimal" ? ? ? ? ? ? no ? no no "20.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brPesagem */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brProdutCarg
/* Query rebuild information for BROWSE brProdutCarg
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-produt-carg NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brProdutCarg */
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


&Scoped-define BROWSE-NAME brLiberCarg
&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME brLiberCarg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLiberCarg wMaintenance
ON VALUE-CHANGED OF brLiberCarg IN FRAME fPage3
DO:
  
    IF AVAIL tt-liber-carg THEN DO:
        &IF "{&product_version}" >= "12.1.C":U &THEN /* 12.1.13 */
            ASSIGN bt-roteiro:SENSITIVE IN FRAME fPage3 = tt-liber-carg.nr-ficha > 0.
        &ELSE
            ASSIGN bt-roteiro:SENSITIVE IN FRAME fPage3 = tt-liber-carg.num-livre-1 > 0.
        &ENDIF
    END.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brProdutCarg
&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME brProdutCarg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brProdutCarg wMaintenance
ON VALUE-CHANGED OF brProdutCarg IN FRAME fPage4
DO:
    DEFINE VARIABLE l-log-pto-coleta-coletiv AS LOGICAL NO-UNDO.

    IF AVAIL {&ttSon4} AND VALID-HANDLE(h-boin00966) THEN DO:
        RUN goToKey IN h-boin00966(INPUT {&ttSon4}.cod-pto-coleta) NO-ERROR.
        IF RETURN-VALUE = "OK":U THEN 
            RUN getLogField IN h-boin00966(INPUT "log-pto-coleta-coletiv", OUTPUT l-log-pto-coleta-coletiv) NO-ERROR.
    END.

    ASSIGN bt-produt-coletiv:SENSITIVE IN FRAME fPage4 = l-log-pto-coleta-coletiv AND {&ttSon4}.idi-nao-coleta = 0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-nao-coleta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nao-coleta wMaintenance
ON CHOOSE OF bt-nao-coleta IN FRAME fpage0 /* Search */ 
OR CHOOSE OF MENU-ITEM miNC IN MENU mbMain 
DO:
    IF AVAIL {&ttTable} AND l-habilita-nc THEN DO:
        ASSIGN v_cod-estabel = {&ttTable}.cod-estabel
               v_num-carg    = {&ttTable}.num-carg.

        {&WINDOW-NAME}:SENSITIVE = NO.
        RUN aqp/aq0418.w.
        {&WINDOW-NAME}:SENSITIVE = YES.
        
        ASSIGN v_cod-estabel = ?
               v_num-carg    = ?.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME bt-produt-coletiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-produt-coletiv wMaintenance
ON CHOOSE OF bt-produt-coletiv IN FRAME fPage4 /* Coletivo */
DO:
    {&WINDOW-NAME}:SENSITIVE = NO.
    REPOSITION brProdutCarg TO ROW brProdutCarg:FOCUSED-ROW IN FRAME fPage4 NO-ERROR.
    RUN aqp/aq0410a.w(INPUT {&hDBOTable}, INPUT {&ttSon4}.cdn-identif).
    {&WINDOW-NAME}:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME bt-roteiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-roteiro wMaintenance
ON CHOOSE OF bt-roteiro IN FRAME fPage3 /* Roteiro */
DO:     
    IF AVAIL {&ttSon3} AND VALID-HANDLE(h-boin124a) THEN DO:
        REPOSITION brLiberCarg TO ROW brLiberCarg:FOCUSED-ROW IN FRAME fPage3 NO-ERROR.

        RUN goToKey IN h-boin124a(INPUT {&ttSon3}.nr-ficha) NO-ERROR.
        IF RETURN-VALUE = "OK" THEN
            RUN getRowId IN h-boin124a(OUTPUT gr-ficha-cq) NO-ERROR.

        RUN cqp/cq0301.w.

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
    {method/zoomreposition.i &ProgramZoom="inzoom/z02in00961.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMaintenance
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brLiberCarg
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
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
    IF VALID-HANDLE (h-boad107na) THEN DO:
       DELETE PROCEDURE h-boad107na.
       ASSIGN h-boad107na = ?.           
    END.
    
    IF VALID-HANDLE (h-boad268na) THEN DO:
       DELETE PROCEDURE h-boad268na.
       ASSIGN h-boad268na = ?.           
    END.

    IF VALID-HANDLE (h-boin172na) THEN DO:
       DELETE PROCEDURE h-boin172na.
       ASSIGN h-boin172na = ?.           
    END.

    IF VALID-HANDLE (h-boin377na) THEN DO:
       DELETE PROCEDURE h-boin377na.
       ASSIGN h-boin377na = ?.           
    END.

    IF VALID-HANDLE (h-boin00975) THEN DO:
       DELETE PROCEDURE h-boin00975.
       ASSIGN h-boin00975 = ?.           
    END.

    IF VALID-HANDLE (h-bofn017) THEN DO:
       DELETE PROCEDURE h-bofn017.
       ASSIGN h-bofn017 = ?.           
    END.  

    IF VALID-HANDLE (h-boin124a) THEN DO:
       DELETE PROCEDURE h-boin124a.
       ASSIGN h-boin124a = ?.           
    END.  

    IF VALID-HANDLE (h-boin01004) THEN DO:
       DELETE PROCEDURE h-boin01004.
       ASSIGN h-boin01004 = ?.           
    END. 

    IF VALID-HANDLE (h-boin00966) THEN DO:
       DELETE PROCEDURE h-boin00966.
       ASSIGN h-boin00966 = ?.           
    END.
    
    IF VALID-HANDLE (h-boin00983) THEN DO:
       DELETE PROCEDURE h-boin00983.
       ASSIGN h-boin00983 = ?.           
    END.
    
    IF VALID-HANDLE (h-boin01009) THEN DO:
       DELETE PROCEDURE h-boin01009 .
       ASSIGN h-boin01009  = ?.           
    END. 

    IF VALID-HANDLE (h-boin047) THEN DO:
       DELETE PROCEDURE h-boin047 .
       ASSIGN h-boin047  = ?.           
    END.

    IF VALID-HANDLE(h-boad098) THEN DO:
        DELETE PROCEDURE h-boad098.
        ASSIGN h-boad098 = ?.
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

    ASSIGN fi-hidden-liber:HIDDEN  IN FRAME fPage3 = YES
           fi-hidden-produt:HIDDEN IN FRAME fPage4 = YES.           

    IF AVAIL {&ttTable} THEN DO:
        ASSIGN c-nome-estabel = fn-nome-estabel(INPUT {&ttTable}.cod-estabel)
               c-desc-rota    = fn-des-rota(INPUT {&ttTable}.cod-rota)
               c-nome-transp  = fn-nome-transp(INPUT {&ttTable}.cod-transp)
               c-desc-item    = fn-desc-item(INPUT {&ttTable}.it-codigo)
               c-desc-refer   = fn-desc-refer(INPUT {&ttTable}.cod-refer)
               c-nome-usuar   = fn-nome-usuar(INPUT {&ttTable}.cod-usuario)
               c-situacao     = {ininc/i01in00961.i 04 {&ttTable}.cdn-sit}
               d-diferenca    = {&ttTable}.qtd-aferid - {&ttTable}.qtd-coleta
               d-km-rodados   = {&ttTable}.val-hodom-final - {&ttTable}.val-hodom-inicial.
               
        RUN pi-habilita-btn-nao-coleta IN THIS-PROCEDURE.
               
        DISPLAY c-nome-estabel WITH FRAME fPage0. 
        DISPLAY d-km-rodados
                c-nome-transp
                c-desc-item
                c-desc-refer
                c-desc-rota
                c-nome-usuar
                c-situacao
                WITH FRAME fPage1. 
        DISPLAY d-diferenca    WITH FRAME fPage2.         
    END.
    
    RUN pi-busca-liber-carg            IN THIS-PROCEDURE.
    RUN pi-busca-produtores            IN THIS-PROCEDURE.
    RUN pi-verifica-tipo-afericao-item IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK" THEN
        RUN pi-busca-pesagem IN THIS-PROCEDURE.



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

    ENABLE brLiberCarg 
           bt-roteiro 
           WITH FRAME fPage3.

    ENABLE brProdutCarg 
           WITH FRAME fPage4.

    ENABLE brPesagem 
           WITH FRAME fPage5.
           
    RUN pi-habilita-btn-nao-coleta IN THIS-PROCEDURE.

    APPLY 'VALUE-CHANGED' TO brLiberCarg IN FRAME fPage3.

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
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE i-num-carg LIKE {&ttTable}.num-carg
        VIEW-AS FILL-IN SIZE 14.00 BY 0.88 NO-UNDO.
    
    
    
    DEFINE FRAME fGoToRecord
        i-num-carg  AT ROW 1.7 COL 20 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Carga Rural" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Carga_Rural"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-num-carg.
        
        RUN goToKey IN {&hDBOTable} (INPUT i-num-carg).
        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-table.i mgind carg-rural 1}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE i-num-carg btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
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
  
    /* Carga */
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "inbo/boin00961.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00961.p YES}
        {btb/btb008za.i2 inbo/boin00961.p '' {&hDBOTable}}
    END.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    /*liber-carg*/
    IF NOT VALID-HANDLE({&hDBOSon3}) OR 
       {&hDBOSon3}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon3}:FILE-NAME <> "inbo/boin00982.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00982.p YES}
        {btb/btb008za.i2 inbo/boin00982.p '' {&hDBOSon3}} 
    END.

    /*produt-carg*/
    IF NOT VALID-HANDLE({&hDBOSon4}) OR 
       {&hDBOSon4}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon4}:FILE-NAME <> "inbo/boin00965.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00965.p YES}
        {btb/btb008za.i2 inbo/boin00965.p '' {&hDBOSon4}} 
    END.

    /* Estabelec  */
    IF NOT VALID-HANDLE(h-boad107na) THEN
        RUN adbo/boad107na.p PERSISTENT SET h-boad107na.
    RUN openQueryStatic IN h-boad107na (INPUT "Main":U) NO-ERROR.

    /* Transporte  */
    IF NOT VALID-HANDLE(h-boad268na) THEN
        RUN adbo/boad268na.p PERSISTENT SET h-boad268na.
    RUN openQueryStatic IN h-boad268na (INPUT "Main":U) NO-ERROR.
    
    /* Item  */
    IF NOT VALID-HANDLE(h-boin172na) THEN
        RUN inbo/boin172na.p PERSISTENT SET h-boin172na.
    RUN openQueryStatic IN h-boin172na (INPUT "Main":U) NO-ERROR.

    /* Referencia  */
    IF NOT VALID-HANDLE(h-boin377na) THEN
        RUN inbo/boin377na.p PERSISTENT SET h-boin377na.
    RUN openQueryStatic IN h-boin377na (INPUT "Main":U) NO-ERROR.
 
    /* Rota  */
    IF NOT VALID-HANDLE(h-boin00975) THEN
        RUN inbo/boin00975.p PERSISTENT SET h-boin00975.
    RUN openQueryStatic IN h-boin00975 (INPUT "Main":U) NO-ERROR.
    
    /* Usuario */   
    IF NOT VALID-HANDLE(h-bofn017) THEN
        RUN fnbo/bofn017.p PERSISTENT SET h-bofn017.
    RUN openQueryStatic IN h-bofn017 (INPUT "Main":U).

    /* Ficha-cq */   
    IF NOT VALID-HANDLE(h-boin124a) THEN
        RUN inbo/boin124a.p PERSISTENT SET h-boin124a.
    RUN openQueryStatic IN h-boin124a (INPUT "Main":U).

    /* Motivo Nao coleta */ 
    IF NOT VALID-HANDLE(h-boin01004) THEN
        RUN inbo/boin01004.p PERSISTENT SET h-boin01004.
    RUN openQueryStatic IN h-boin01004 (INPUT "Main":U).

    /* Pto Coleta */ 
    IF NOT VALID-HANDLE(h-boin00966) THEN
        RUN inbo/boin00966.p PERSISTENT SET h-boin00966.
    RUN openQueryStatic IN h-boin00966 (INPUT "Main":U).

    /* Pesagem */ 
    IF NOT VALID-HANDLE(h-boin00981) THEN
        RUN inbo/boin00981.p PERSISTENT SET h-boin00981.
    RUN openQueryStatic IN h-boin00981 (INPUT "Main":U).

    /* Item Estab Rural */ 
    IF NOT VALID-HANDLE(h-boin00983) THEN
        RUN inbo/boin00983.p PERSISTENT SET h-boin00983.
    RUN openQueryStatic IN h-boin00983 (INPUT "Main":U).
    
    /* Nao conformidade */
    IF NOT VALID-HANDLE(h-boin01009) THEN
        RUN inbo/boin01009.p PERSISTENT SET h-boin01009.
    RUN openQueryStatic IN h-boin01009 (INPUT "Main":U).    

    /* Nao conformidade */
    IF NOT VALID-HANDLE(h-boin047) THEN
        RUN inbo/boin047.p PERSISTENT SET h-boin047.
    RUN openQueryStatic IN h-boin047 (INPUT "Default":U).     
    
    /* Emitente */
    IF NOT VALID-HANDLE(h-boad098) THEN 
        RUN adbo/boad098.p PERSISTENT SET h-boad098.
    RUN openQueryStatic IN h-boad098(INPUT "Main") NO-ERROR. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-liber-carg wMaintenance 
PROCEDURE pi-busca-liber-carg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:   {&hDBOSon3} => boin00982 => liber-carg    
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iRowsReturned AS INTEGER     NO-UNDO.

    EMPTY TEMP-TABLE {&ttSon3} NO-ERROR.

    IF AVAIL {&ttTable} AND VALID-HANDLE({&hDBOSon3}) THEN DO:
        RUN setConstraintNumCarga IN {&hDBOSon3} (INPUT tt-carg-rural.num-carg).
        RUN emptyRowObject        IN {&hDBOSon3}.
        RUN openQueryStatic       IN {&hDBOSon3} (INPUT "NumCarg":U).
        RUN getBatchRecords       IN {&hDBOSon3} (INPUT ?,
                                                  INPUT NO,
                                                  INPUT 9999,
                                                  OUTPUT iRowsReturned,
                                                  OUTPUT TABLE {&ttSon3}).
       {&OPEN-QUERY-brLiberCarg}
    END.

    ASSIGN bt-roteiro:SENSITIVE IN FRAME fPage3 = CAN-FIND(FIRST {&ttSon3}).

    APPLY 'VALUE-CHANGED' TO brLiberCarg IN FRAME fPage3.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-pesagem wMaintenance 
PROCEDURE pi-busca-pesagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iRowsReturned AS INTEGER     NO-UNDO.

    EMPTY TEMP-TABLE {&ttSon5} NO-ERROR.

    IF AVAIL {&ttTable} AND VALID-HANDLE({&hDBOSon5}) THEN DO:

        RUN setConstraintNumCarg IN {&hDBOSon5} (INPUT {&ttTable}.num-carg, INPUT {&ttTable}.num-carg).
        RUN emptyRowObject       IN {&hDBOSon5}.
        RUN openQueryStatic      IN {&hDBOSon5} (INPUT "NumCarg":U).
        RUN getBatchRecords      IN {&hDBOSon5} (INPUT ?,
                                                 INPUT NO,
                                                 INPUT 9999,
                                                 OUTPUT iRowsReturned,
                                                 OUTPUT TABLE {&ttSon5}).
       {&OPEN-QUERY-brPesagem}

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-produtores wMaintenance 
PROCEDURE pi-busca-produtores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iRowsReturned AS INTEGER     NO-UNDO.

    EMPTY TEMP-TABLE {&ttSon4} NO-ERROR.

    IF AVAIL {&ttTable} AND VALID-HANDLE({&hDBOSon4}) THEN DO:
        RUN setConstraintCarga IN {&hDBOSon4} (INPUT tt-carg-rural.num-carg).
        RUN emptyRowObject     IN {&hDBOSon4}.
        RUN openQueryStatic    IN {&hDBOSon4} (INPUT "ProdutoresCarga":U). 
        RUN getBatchRecords    IN {&hDBOSon4} (INPUT ?,
                                               INPUT NO,
                                               INPUT 9999,
                                               OUTPUT iRowsReturned,
                                               OUTPUT TABLE {&ttSon4}).
       {&OPEN-QUERY-brProdutCarg}
       APPLY "VALUE-CHANGED" TO brProdutCarg IN FRAME fPage4.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-btn-nao-coleta wMaintenance 
PROCEDURE pi-habilita-btn-nao-coleta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT AVAIL {&ttTable} OR NOT VALID-HANDLE(h-boin01009) THEN
        ASSIGN bt-nao-coleta:SENSITIVE IN FRAME fPage0 = NO.
    ELSE DO:
        RUN can-find-naocfedade-by-carg IN h-boin01009(INPUT {&ttTable}.num-carg). 
        ASSIGN l-habilita-nc = RETURN-VALUE = "OK":U        
               bt-nao-coleta:SENSITIVE  IN FRAME fPage0 = l-habilita-nc
               MENU-ITEM miNC:SENSITIVE IN MENU smFile  = l-habilita-nc.
             
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-tipo-afericao-item wMaintenance 
PROCEDURE pi-verifica-tipo-afericao-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-boin00983) THEN DO:
        RUN gotoKey IN h-boin00983(INPUT {&ttTable}.it-codigo, INPUT {&ttTable}.cod-estabel).
        IF RETURN-VALUE = "OK" THEN DO:
            ASSIGN i-idi-tip-aferic = 0.
            RUN getIntField IN h-boin00983(INPUT "idi-tip-aferic":U, OUTPUT i-idi-tip-aferic).
        END.
    END.

    /* Habilita Folder Pesagem se o tipo de afericao do item for peso */
    RUN setEnabled IN hFolder (INPUT 5, INPUT i-idi-tip-aferic = 1).

    IF i-idi-tip-aferic <> 1 THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-aprov wMaintenance 
FUNCTION fn-aprov RETURNS CHARACTER
  ( i-idi-aprov AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN {ininc/i01in00982.i 04 i-idi-aprov}. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-des-rota wMaintenance 
FUNCTION fn-des-rota RETURNS CHARACTER
(c-cod-rota AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-des-rota AS CHARACTER NO-UNDO.   

    IF VALID-HANDLE(h-boin00975) THEN DO:
        RUN goToKey IN h-boin00975 (INPUT c-cod-rota).
        IF RETURN-VALUE = "OK":U THEN
            RUN getCharField IN h-boin00975(INPUT "des-rota":U, OUTPUT c-des-rota).
    END.
    
    RETURN c-des-rota.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-item wMaintenance 
FUNCTION fn-desc-item RETURNS CHARACTER
    (c-it-codigo AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-desc-item AS CHARACTER NO-UNDO.   
    
    IF VALID-HANDLE(h-boin172na) THEN DO:
        RUN goToKey IN h-boin172na (INPUT c-it-codigo).
        IF RETURN-VALUE = "OK":U THEN
            RUN getCharField IN h-boin172na(INPUT "desc-item":U, OUTPUT c-desc-item).
    END.
    
    RETURN c-desc-item.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-refer wMaintenance 
FUNCTION fn-desc-refer RETURNS CHARACTER
   (c-cod-refer AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-descricao AS CHARACTER NO-UNDO.   

    IF VALID-HANDLE(h-boin377na) THEN DO:
        RUN goToKey IN h-boin377na (INPUT c-cod-refer).
        IF RETURN-VALUE = "OK":U THEN
            RUN getCharField IN h-boin377na(INPUT "descricao":U, OUTPUT c-descricao).
    END.
    
    RETURN c-descricao.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-rejei wMaintenance 
FUNCTION fn-desc-rejei RETURNS CHARACTER
  ( i-cod-rejei AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-descricao AS CHARACTER   NO-UNDO.

    IF VALID-HANDLE(h-boin047) THEN DO:
        RUN goToKey IN h-boin047(INPUT i-cod-rejei) NO-ERROR.
        IF RETURN-VALUE = "OK" THEN
            RUN getCharField IN h-boin047(INPUT "descricao", OUTPUT c-descricao).
    END.

    RETURN c-descricao.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-idi-nao-colta wMaintenance 
FUNCTION fn-idi-nao-colta RETURNS CHARACTER
  ( i-idi-nao-coleta AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/      

  RETURN IF i-idi-nao-coleta > 0 THEN {ininc/i01in00965.i 04 i-idi-nao-coleta} ELSE "".  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-liberacao wMaintenance 
FUNCTION fn-liberacao RETURNS CHARACTER
  ( idi-autoriz-descarga AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-return AS CHARACTER   NO-UNDO.

    IF idi-autoriz-descarga > 0 THEN 
        ASSIGN c-return = {ininc/i02in00982.i 04 idi-autoriz-descarga}.    

  RETURN c-return.  /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-motiv-nao-coleta wMaintenance 
FUNCTION fn-motiv-nao-coleta RETURNS CHARACTER
  ( i-cdn-motiv-nao-coleta AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-des-motivo AS CHARACTER NO-UNDO.   
    
    IF VALID-HANDLE(h-boin01004) THEN DO:
        RUN goToKey IN h-boin01004 (INPUT i-cdn-motiv-nao-coleta).
        IF RETURN-VALUE = "OK":U THEN
            RUN getCharField IN h-boin01004(INPUT "des-motivo":U, OUTPUT c-des-motivo).
    END.
    
    RETURN c-des-motivo.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-nome-abrev wMaintenance 
FUNCTION fn-nome-abrev RETURNS CHARACTER
  ( i-cdn-produt-rural AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-nome-abrev AS CHARACTER NO-UNDO.

    IF VALID-HANDLE(h-boad098) THEN DO:   
        RUN findCodigo IN h-boad098(INPUT i-cdn-produt-rural, 
                                    OUTPUT c-nome-abrev).
        IF c-nome-abrev = "" THEN DO:        
            RUN goToKey      IN h-boad098(INPUT i-cdn-produt-rural) NO-ERROR.
            RUN getCharField IN h-boad098(INPUT "nome-abrev", OUTPUT c-nome-abrev).
        END.
    END.


  RETURN c-nome-abrev.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-nome-estabel wMaintenance 
FUNCTION fn-nome-estabel RETURNS CHARACTER
   (c-cod-estabel AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-nome AS CHARACTER NO-UNDO.   

    IF VALID-HANDLE(h-boad107na) THEN DO:
        RUN goToKey IN h-boad107na (INPUT c-cod-estabel).
        IF RETURN-VALUE = "OK":U THEN
            RUN getCharField IN h-boad107na(INPUT "nome":U, OUTPUT c-nome).
    END.
    
    RETURN c-nome.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-nome-transp wMaintenance 
FUNCTION fn-nome-transp RETURNS CHARACTER
 (i-cod-transp AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-nome AS CHARACTER NO-UNDO.   

    IF VALID-HANDLE(h-boad268na) THEN DO:
        RUN goToKey IN h-boad268na (INPUT i-cod-transp).
        IF RETURN-VALUE = "OK":U THEN
            RUN getCharField IN h-boad268na(INPUT "nome":U, OUTPUT c-nome).
    END.
    
    RETURN c-nome.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-nome-usuar wMaintenance 
FUNCTION fn-nome-usuar RETURNS CHARACTER
  (c-cod-usuar AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-nome-usuar AS CHARACTER NO-UNDO. 
    
    IF VALID-HANDLE(h-bofn017) THEN DO:
        RUN goTokey IN h-bofn017 (INPUT TRIM(c-cod-usuar)).
        IF RETURN-VALUE = "OK":U THEN        
            RUN getcharField IN h-bofn017 (INPUT "nom_usuario", OUTPUT c-nome-usuar).        
    END.
    
    RETURN c-nome-usuar. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-qtd-total wMaintenance 
FUNCTION fn-qtd-total RETURNS DECIMAL
  ( iNumCarg AS INTEGER, cPtoColeta AS CHARACTER, pCdnCompart AS INTEGER,  pCdnRepos AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE d-qtd-total AS DECIMAL NO-UNDO.

    RUN getQtdTotalPtoColeta IN {&hDBOSon4} (INPUT iNumCarg, 
                                             INPUT cPtoColeta, 
                                             INPUT pCdnCompart, 
                                             INPUT pCdnRepos,
                                             OUTPUT d-qtd-total).                
        
    RETURN d-qtd-total.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-situacao wMaintenance 
FUNCTION fn-situacao RETURNS CHARACTER
  ( i-num-carg AS INT, INPUT i-cdn-pesagem AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-idi-aprova AS INTEGER NO-UNDO.

    IF VALID-HANDLE({&hDBOSon3}) THEN DO:
        RUN buscaSituacaoPesagem IN {&hDBOSon3}(INPUT i-num-carg, 
                                                INPUT i-cdn-pesagem, 
                                                OUTPUT i-idi-aprova).

    END.

    RETURN IF i-idi-aprova > 0 THEN {ininc/i01in00982.i 04 i-idi-aprova} ELSE "".
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

