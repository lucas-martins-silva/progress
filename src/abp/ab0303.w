&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-movto-event NO-UNDO LIKE mab-movto-event
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
{include/i-prgvrs.i AB0303 2.00.00.013 } /*** 010013 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0303 MAB}
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
&GLOBAL-DEFINE Program        AB0303
&GLOBAL-DEFINE Version        2.00.00.013

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Evento

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

&GLOBAL-DEFINE ttTable        TTmab-movto-event
&GLOBAL-DEFINE hDBOTable      hDBOMovtoEvent
&GLOBAL-DEFINE DBOTable       mab-movto-event

&GLOBAL-DEFINE page0KeyFields TTmab-movto-event.num-docto
&GLOBAL-DEFINE page0Fields    TTmab-movto-event.cod-usuar ~ TTmab-movto-event.dat-inicial ~ TTmab-movto-event.hra-inicial
&GLOBAL-DEFINE page1Fields    TTmab-movto-event.ep-codigo ~
                              TTmab-movto-event.cod-eqpto ~
                              TTmab-movto-event.cod-evento ~
                              TTmab-movto-event.cod-ofici ~
                              TTmab-movto-event.cod-sub-sist ~
                              TTmab-movto-event.cd-tipo ~
                              TTmab-movto-event.dat-final ~
                              TTmab-movto-event.dsl-obs ~
                              TTmab-movto-event.val-km-aviso ~
                              TTmab-movto-event.hra-final ~
                              TTmab-movto-event.val-evento ~
                              TTmab-movto-event.cod-matr ~
                              TTmab-movto-event.num-parc-event ~
                              TTmab-movto-event.ep-codigo-matr ~
                              TTmab-movto-event.cod-estabel-matr ~
                              TTmab-movto-event.ct-despesa ~
                              TTmab-movto-event.cc-despesa ~
                              iDias

                                  
/* &GLOBAL-DEFINE page1Fields  */ 
/* &GLOBAL-DEFINE page2Fields  */

/* Parameters Definitions ---                                           */
DEFINE VARIABLE dDataAviso AS DATE FORMAT 99/99/9999       NO-UNDO.
DEFINE VARIABLE iValorFlag AS INTEGER                      NO-UNDO.
DEFINE VARIABLE cHora      AS CHARACTER  format "00:00:00" NO-UNDO.
DEFINE VARIABLE cHora-1    AS CHARACTER  format "00:00:00" NO-UNDO.
DEFINE VARIABLE cCodModelo AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iTpValor   AS INTEGER   NO-UNDO.
DEFINE VARIABLE cFConta    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFSub      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lControl   AS LOGICAL   NO-UNDO.
/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cCodGrpEqpto AS CHAR    NO-UNDO.
DEFINE VARIABLE iDoc         AS INTEGER NO-UNDO.
/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDOEmpEqpto    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEqpto      AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEvent      AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOTpManut    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOSubSist    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOOfic       AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOMotorista  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOGrpEvent   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOHistor     AS HANDLE NO-UNDO.
/* Variaveis utilizadas para validar eventos em duplicidadas.      
   Utilizada nas procedure verificaNumeracao */                    
DEFINE VARIABLE l-ValEventoDuplicados AS LOGICAL  NO-UNDO.  


{abp/ab9000.i} /** Procedures de convers∆o de tempo:
                   piFormataHoraParaSegundo
                   piFormataSegundoParaHora **/

{cdp/cdunif001.i} /*vari†veis unificaá∆o de conceito*/
/*unificaá∆o de conceito - centro de custo e conta contabil*/
DEFINE VARIABLE cEmpresaEstab  AS CHARACTER INIT ""  NO-UNDO.
DEFINE VARIABLE cUnidNegocUnif AS CHARACTER INIT ""  NO-UNDO.
DEFINE VARIABLE dDtMovimento   AS DATE        NO-UNDO.
/** Zoom **/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE    NO-UNDO.

&IF "{&mguni_version}" >= "2.071" &THEN
DEFINE VARIABLE iEmpresa LIKE empresa.ep-codigo    NO-UNDO.
&ELSE
DEFINE VARIABLE iEmpresa AS INTEGER    NO-UNDO.
&ENDIF
DEFINE VARIABLE cEquipto AS CHARACTER  NO-UNDO.

&IF DEFINED(bf_mnt_ems206b) &THEN
    {frbo/bofr133.i tt-unid-negoc-histor}
&ENDIF

DEFINE VARIABLE cMsgParam AS CHARACTER FORMAT "x(50)":U NO-UNDO.
DEFINE BUFFER bf-mnd-event-solicit FOR mnd-event-solicit.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS TTmab-movto-event.dat-inicial ~
TTmab-movto-event.hra-inicial TTmab-movto-event.num-docto ~
TTmab-movto-event.cod-usuar 
&Scoped-define ENABLED-TABLES TTmab-movto-event
&Scoped-define FIRST-ENABLED-TABLE TTmab-movto-event
&Scoped-Define ENABLED-OBJECTS btFirst btPrev btNext btLast btGoTo btSearch ~
btAdd btCopy btUpdate btDelete btUndo btCancel btSave btQueryJoins ~
btReportsJoins btExit btHelp rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS TTmab-movto-event.dat-inicial ~
TTmab-movto-event.hra-inicial TTmab-movto-event.num-docto ~
TTmab-movto-event.cod-usuar 
&Scoped-define DISPLAYED-TABLES TTmab-movto-event
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-movto-event


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

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btMatriz 
     IMAGE-UP FILE "image/im-negoc.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-negoc.bmp":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Matriz Unidade Neg¢cio".

DEFINE VARIABLE cDescEmp AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 45.14 BY .88 NO-UNDO.

DEFINE VARIABLE cDescEqpto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .88 NO-UNDO.

DEFINE VARIABLE cDescEvento AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE cDescMotorista AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30.57 BY .88 NO-UNDO.

DEFINE VARIABLE cDescOfic AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE cDescSubSist AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE cDescTpManut AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE cDescUn AS CHARACTER FORMAT "xx" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fi-cod-emitente AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-unid-negoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiExecucao AS CHARACTER FORMAT "X(20)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE fiObs AS CHARACTER FORMAT "X(20)":U INITIAL "Observaá‰es" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE iDias AS INTEGER FORMAT ">>>,>>9":U INITIAL 999999 
     LABEL "Dias" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 23 BY 2.83.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69.57 BY 2.79.

DEFINE RECTANGLE RECT-38
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48.43 BY 2.25.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35 BY 2.25.


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
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     TTmab-movto-event.dat-inicial AT ROW 2.96 COL 29.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-movto-event.hra-inicial AT ROW 2.96 COL 50.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-movto-event.num-docto AT ROW 2.96 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .79
     TTmab-movto-event.cod-usuar AT ROW 2.96 COL 75 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     "Hora:" VIEW-AS TEXT
          SIZE 4 BY .54 AT ROW 3.13 COL 48.72
     "Usuario:" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 3.13 COL 70.43
     rtKeys AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.5
         FONT 1.

DEFINE FRAME fPage1
     TTmab-movto-event.ep-codigo AT ROW 1.25 COL 10 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     cDescEmp AT ROW 1.25 COL 15 COLON-ALIGNED NO-LABEL
     TTmab-movto-event.cod-eqpto AT ROW 2.25 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     cDescEqpto AT ROW 2.25 COL 27.14 COLON-ALIGNED NO-LABEL
     fi-cod-unid-negoc AT ROW 2.25 COL 73.57 COLON-ALIGNED
     btMatriz AT ROW 2.21 COL 80.72
     TTmab-movto-event.ep-codigo-matr AT ROW 3.25 COL 10 COLON-ALIGNED
          LABEL "Motorista":R9
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     TTmab-movto-event.cod-estabel-matr AT ROW 3.25 COL 14.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-movto-event.cod-matr AT ROW 3.25 COL 19.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cDescMotorista AT ROW 3.25 COL 29.57 COLON-ALIGNED NO-LABEL
     TTmab-movto-event.cod-evento AT ROW 4.25 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cDescEvento AT ROW 4.25 COL 20 COLON-ALIGNED NO-LABEL
     TTmab-movto-event.val-evento AT ROW 5.25 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     TTmab-movto-event.num-parc-event AT ROW 5.25 COL 55 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-movto-event.cd-tipo AT ROW 6.25 COL 9.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cDescTpManut AT ROW 6.25 COL 20 COLON-ALIGNED NO-LABEL
     iDias AT ROW 6.21 COL 68.72 COLON-ALIGNED
     TTmab-movto-event.cod-sub-sist AT ROW 7.25 COL 9.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cDescSubSist AT ROW 7.25 COL 20 COLON-ALIGNED NO-LABEL
     TTmab-movto-event.val-km-aviso AT ROW 7.21 COL 68.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cDescUn AT ROW 7.21 COL 78.86 COLON-ALIGNED HELP
          "Unidade do contador do equipamento" NO-LABEL
     TTmab-movto-event.cod-ofici AT ROW 8.25 COL 9.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cDescOfic AT ROW 8.25 COL 20 COLON-ALIGNED NO-LABEL
     TTmab-movto-event.dsl-obs AT ROW 9.79 COL 12 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 800 SCROLLBAR-VERTICAL
          SIZE 66 BY 2.04
     TTmab-movto-event.ct-despesa AT ROW 12.67 COL 45.43 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     TTmab-movto-event.cc-despesa AT ROW 13.71 COL 45.43 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     fi-cod-emitente AT ROW 12.71 COL 72.86 COLON-ALIGNED
     fiObs AT ROW 9.13 COL 9.86 COLON-ALIGNED NO-LABEL
     TTmab-movto-event.dat-final AT ROW 12.96 COL 8.57 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-movto-event.hra-final AT ROW 12.96 COL 23.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiExecucao AT ROW 12.21 COL 1.57 COLON-ALIGNED NO-LABEL
     "Tipo Manut." VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 6.42 COL 3.43
     "Avisar Ap¢s" VIEW-AS TEXT
          SIZE 9.29 BY .54 AT ROW 5.38 COL 64.72
     "Data:" VIEW-AS TEXT
          SIZE 4 BY .54 AT ROW 13.04 COL 4.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.14 ROW 5.46
         SIZE 85.86 BY 13.79
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage1
     "Empresa:" VIEW-AS TEXT
          SIZE 6.57 BY .54 AT ROW 1.42 COL 5.29
     "Hora:" VIEW-AS TEXT
          SIZE 3.86 BY .54 AT ROW 13.08 COL 21.43
     RECT-2 AT ROW 5.67 COL 63.14
     RECT-3 AT ROW 9.38 COL 10
     RECT-4 AT ROW 12.5 COL 1.57
     RECT-38 AT ROW 12.5 COL 37
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.14 ROW 5.46
         SIZE 85.86 BY 13.79
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: TTmab-movto-event T "?" NO-UNDO movfro mab-movto-event
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
         TITLE              = "Apontamento de Eventos"
         HEIGHT             = 18.54
         WIDTH              = 90
         MAX-HEIGHT         = 37.46
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 37.46
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* SETTINGS FOR FILL-IN TTmab-movto-event.dat-final IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN TTmab-movto-event.ep-codigo-matr IN FRAME fPage1
   EXP-LABEL                                                            */
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance /* Apontamento de Eventos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance /* Apontamento de Eventos */
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
    RUN pi-limpa-tela IN THIS-PROCEDURE.
   RUN addRecord IN THIS-PROCEDURE.
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
    ASSIGN TTmab-movto-event.log-disparad = FALSE.
    assign TTmab-movto-event.dat-final:screen-value in frame fpage1 = "":U.
    ASSIGN TTmab-movto-event.hra-final:SCREEN-VALUE IN FRAME Fpage1 = "00:00:00":U. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    FIND FIRST bf-mnd-event-solicit                   
         WHERE bf-mnd-event-solicit.num-docto-event = INPUT FRAME fPage0 {&ttTable}.num-docto EXCLUSIVE-LOCK NO-ERROR.
    IF  AVAIL bf-mnd-event-solicit THEN DO:
        {utp/ut-liter.i "Apontamento_de_Evento" *}
        ASSIGN cMsgParam  = RETURN-VALUE.
        {utp/ut-liter.i "Solicitaá∆o_de_Pagamento" *}
        ASSIGN cMsgParam  = cMsgParam + "~~" + RETURN-VALUE + ", ".
        {utp/ut-liter.i "consultar solicitaá∆o: "}
        ASSIGN cMsgParam = cMsgParam + RETURN-VALUE + STRING(bf-mnd-event-solicit.num-docto).
        run utp/ut-msgs.p (INPUT "Show",
                           INPUT 17487,
                           INPUT cMsgParam).
        IF  RETURN-VALUE = "YES" THEN DO:
            DELETE bf-mnd-event-solicit.
        END.
        ELSE RETURN NO-APPLY.
    END.
    ELSE DO:
        RUN deleteRecord IN THIS-PROCEDURE.
    END.
    RUN afterDisplayFields IN THIS-PROCEDURE.
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btMatriz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMatriz wMaintenance
ON CHOOSE OF btMatriz IN FRAME fPage1
DO:
    /*--- Seta cursor do mouse para espera ---*/
    SESSION:SET-WAIT-STATE("GENERAL":U).

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

    /*--- Executa programa de manutená∆o de filho ---*/
    RUN abp/ab0302e.w (INPUT FRAME fPage1 {&ttTable}.ep-codigo,  
                       INPUT FRAME fPage1 {&ttTable}.cod-eqpto,  
                       INPUT FRAME fPage0 {&ttTable}.dat-inicial).

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    /*--- Seta cursor do mouse para normal ---*/
    SESSION:SET-WAIT-STATE("":U).

    APPLY "ENTRY":U TO btMatriz IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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
    IF cAction = "Update":U THEN 
       RUN saveRecord IN THIS-PROCEDURE.
    ELSE DO:
        APPLY "LEAVE":U to TTmab-movto-event.ct-despesa in frame fPage1.
        apply "LEAVE":U to TTmab-movto-event.num-docto in frame fPage0.
        IF RETURN-VALUE = "OK":U THEN DO:
           RUN verificaNumeracao IN THIS-PROCEDURE.
           IF RETURN-VALUE = "NOK":U THEN
               RETURN NO-APPLY.
           RUN saveRecord IN THIS-PROCEDURE.
        END.
    END.
   if return-value <> "OK":U then do:
       run habilitaCampos in this-procedure.  
    end.
    else do:
         disable {&ttTable}.ct-despesa      with frame fPage1.  
         disable {&ttTable}.cc-despesa      with frame fPage1.  
         disable fi-cod-emitente with frame fPage1.  
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="frzoom/z01fr059.w"}
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
    IF TTmab-movto-event.log-disparad = TRUE THEN DO:
         /* Inicio -- Projeto Internacional */
         {utp/ut-liter.i "Evento" *}
         run utp/ut-msgs.p (input "Show",
                            input 28420,
                            input RETURN-VALUE).
         RETURN "NOK":U.
       
    END.
    RUN updateRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME TTmab-movto-event.cc-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.cc-despesa wMaintenance
ON ENTRY OF TTmab-movto-event.cc-despesa IN FRAME fPage1 /* CC Despesa */
DO:
    ASSIGN {&ttTable}.cc-despesa:FORMAT IN FRAME fPage1 = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.cc-despesa wMaintenance
ON F5 OF TTmab-movto-event.cc-despesa IN FRAME fPage1 /* CC Despesa */
DO: 
    IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    ASSIGN  cEmpresaEstab  = STRING(INPUT FRAME fPage1 {&ttTable}.ep-codigo)
            dDtMovimento   = INPUT FRAME fPage0 {&ttTable}.dat-inicial
            v_cod_cta_ctbl = INPUT FRAME fPage1 {&ttTable}.ct-despesa
            cUnidNegocUnif = INPUT FRAME fPage1 fi-cod-unid-negoc.

    RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto( INPUT cEmpresaEstab,         /*Empresa*/
                                                   INPUT "",                    /*Estabelecimento */
                                                   INPUT YES,                   /*Considera Todos os Estabelecimentos ?*/
                                                   INPUT cUnidNegocUnif,        /*Unidade de Neg¢cio*/
                                                   INPUT "",                    /*Plano de Contas*/
                                                   INPUT v_cod_cta_ctbl,        /*C¢digo da Conta*/
                                                   INPUT "",                    /*C¢digo do Plano de Centro de Custo*/
                                                   INPUT dDtMovimento,          /*Data da Transaá∆o*/
                                                   OUTPUT v_cod_ccusto,         /*C¢digo CCusto*/
                                                   OUTPUT v_des_ccusto,         /*Descriá∆o CCusto*/
                                                   OUTPUT TABLE tt_log_erro ).  /*Erros*/

    ASSIGN {&ttTable}.cc-despesa:SCREEN-VALUE IN FRAME fPage1 = v_cod_ccusto.

    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.

    IF VALID-HANDLE(h_api_ccusto) THEN DO:
        DELETE OBJECT h_api_ccusto.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.cc-despesa wMaintenance
ON LEAVE OF TTmab-movto-event.cc-despesa IN FRAME fPage1 /* CC Despesa */
DO:
    IF {&ttTable}.cc-despesa:SCREEN-VALUE <> "" THEN
        ASSIGN {&ttTable}.cc-despesa:FORMAT IN FRAME fPage1 = p_cod_format_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.cc-despesa wMaintenance
ON MOUSE-SELECT-DBLCLICK OF TTmab-movto-event.cc-despesa IN FRAME fPage1 /* CC Despesa */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-movto-event.cd-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.cd-tipo wMaintenance
ON LEAVE OF TTmab-movto-event.cd-tipo IN FRAME fPage1 /* cd-tipo */
DO:
  
   {method/ReferenceFields.i
      &HandleDBOLeave="hDBOTpManut"
      &KeyValue1="input frame fPage1 TTmab-movto-event.cd-tipo"
      &FieldName1="descricao"
      &FieldScreen1="cDescTpManut"
      &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.cd-tipo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF TTmab-movto-event.cd-tipo IN FRAME fPage1 /* cd-tipo */
OR f5 OF TTmab-movto-event.cd-tipo IN FRAME fPage1 DO:

        {method/ZoomFields.i
           &ProgramZoom="mnzoom/z01mn158.w"
           &FieldZoom1="cd-tipo"
           &FieldScreen1=" TTmab-movto-event.cd-tipo"
           &Frame1="fPage1"
           &FieldZoom2="descricao"
           &FieldScreen2="cDescTpManut"
           &Frame2="fPage1"
           &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cDescUn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cDescUn wMaintenance
ON LEAVE OF cDescUn IN FRAME fPage1
DO:
  FOR FIRST mab-eqpto FIELDS (cod-eqpto ep-codigo cod-model)
    &IF "{&mguni_version}" >= "2.071" &THEN
      WHERE mab-eqpto.ep-codigo = TTmab-movto-event.ep-codigo:SCREEN-VALUE IN FRAME fPage1
    &ELSE
      WHERE mab-eqpto.ep-codigo = int(TTmab-movto-event.ep-codigo:SCREEN-VALUE IN FRAME fPage1)
    &ENDIF
      AND   mab-eqpto.cod-eqpto = TTmab-movto-event.cod-eqpto:SCREEN-VALUE IN FRAME fPage1 NO-LOCK,
      FIRST mab-model FIELDS (cod-model un) 
            WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:
            ASSIGN cDescUn  = mab-model.un.
            DISP cDescUn WITH FRAME fPage1.
      
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-movto-event.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.cod-eqpto wMaintenance
ON LEAVE OF TTmab-movto-event.cod-eqpto IN FRAME fPage1 /* Equipamento */
DO:
   run buscaModelo in this-procedure (input input frame fPage1 {&ttTable}.ep-codigo,
                                      input input frame fPage1 {&ttTable}.cod-eqpto).
    {method/referenceFields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="cCodModelo"
        &FieldName1="des-model"
        &FieldScreen1="cDescEqpto"
        &Frame1="fPage1"}
                         
 IF (c-nom-prog-upc-mg97 <> "":U) AND 
     (trim(cAction) = "ADD":U OR trim(cAction) = "COPY":U) then
   run value(c-nom-prog-upc-mg97) (input "leave-equipamento", 
                                   input "",
                                   input THIS-PROCEDURE,
                                   input FRAME fPage1:HANDLE,
                                   input "",
                                   input ?). 

 RUN piDescEvento IN THIS-PROCEDURE.

 IF l-usa-unid-negoc THEN DO:    
     /** Exibi/Habilita/Desabilita botao Matriz de Unidade Negocio **/
     RUN piValidaMatriz IN THIS-PROCEDURE.
 END.

 APPLY "LEAVE":U TO cDescUn IN FRAME fPage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.cod-eqpto wMaintenance
ON MOUSE-SELECT-DBLCLICK OF TTmab-movto-event.cod-eqpto IN FRAME fPage1 /* Equipamento */
OR f5 OF TTmab-movto-event.cod-eqpto IN FRAME fPage1 DO:

        {method/ZoomFields.i
           &ProgramZoom="frzoom/z01fr007.w"
           &FieldZoom1="cod-eqpto"
           &FieldScreen1="TTmab-movto-event.cod-eqpto"
           &Frame1="fPage1"
           &FieldZoom2="ep-codigo"
           &FieldScreen2="TTmab-movto-event.ep-codigo"
           &Frame2="fPage1"
           &EnableImplant="YES"}
     wait-for "CLOSE":U of hProgramZoom.
    apply "LEAVE":U to {&ttTable}.ep-codigo in frame fPage1. 
    apply "LEAVE":U to {&ttTable}.cod-eqpto in frame fPage1. 
    















END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-movto-event.cod-estabel-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.cod-estabel-matr wMaintenance
ON F5 OF TTmab-movto-event.cod-estabel-matr IN FRAME fPage1 /* cod-estabel-matr */
DO:
  APPLY "F5":U TO TTmab-movto-event.cod-matr IN FRAM fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.cod-estabel-matr wMaintenance
ON MOUSE-SELECT-DBLCLICK OF TTmab-movto-event.cod-estabel-matr IN FRAME fPage1 /* cod-estabel-matr */
DO:
  APPLY "F5":U TO TTmab-movto-event.cod-matr IN FRAM fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-movto-event.cod-evento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.cod-evento wMaintenance
ON LEAVE OF TTmab-movto-event.cod-evento IN FRAME fPage1 /* Evento */
DO:
   {method/ReferenceFields.i
      &HandleDBOLeave=" hDBOEvent"
      &KeyValue1="input frame fPage1 TTmab-movto-event.cod-evento"
      &FieldName1="des-evento"
      &FieldScreen1="cDescEvento"
      &Frame1="fPage1"}
    
     

       RUN verificaFlag IN  hDBOEvent (INPUT TTmab-movto-event.cod-evento:SCREEN-VALUE IN FRAME fPage1,
                                       OUTPUT iValorFlag).
        if cAction <> "":U then do:
          run pi-busca-conta in this-procedure.
        end.
        else do:
          assign {&ttTable}.ct-despesa:sensitive in frame fPage1    = no
                 {&ttTable}.cc-despesa:sensitive in frame fPage1 = no
                 fi-cod-emitente:sensitive in frame fPage1 = no.
        end.
       IF cAction = "ADD":U OR cAction = "Update":U THEN DO:
           IF iValorFlag = 1 THEN DO:
               ASSIGN TTmab-movto-event.val-evento:SENSITIVE IN FRAME fPage1 = NO
                      TTmab-movto-event.cod-sub-sist:SENSITIVE IN FRAME fPage1 = YES   
                      TTmab-movto-event.cd-tipo:SENSITIVE IN FRAME fPage1 = YES  
                      TTmab-movto-event.val-km-aviso:SENSITIVE IN FRAME fPage1 = YES     
                      iDias:SENSITIVE IN FRAME fPage1 = YES                            
                      TTmab-movto-event.val-km-aviso:SENSITIVE IN FRAME fPage1 = YES .
                  
               
               ASSIGN  TTmab-movto-event.val-evento = 0.
                       DISP TTmab-movto-event.val-evento WITH FRAME fPage1.
           END.
           ELSE DO:
               ASSIGN TTmab-movto-event.val-evento:SENSITIVE IN FRAME fPage1 = YES.
              
           END.
           RUN piDescEvento IN THIS-PROCEDURE.
       END.


       IF cAction = "ADD":U OR cAction = "Update":U THEN DO:
            APPLY "LEAVE":U TO {&ttTable}.cod-eqpto IN FRAME fPage1.
           IF iValorFlag = 2 OR iValorFlag = 3  THEN DO:

                ASSIGN  TTmab-movto-event.cod-sub-sist:SENSITIVE IN FRAME fPage1 = NO
                        TTmab-movto-event.cd-tipo:SENSITIVE IN FRAME fPage1 = NO
                        TTmab-movto-event.val-km-aviso:SENSITIVE IN FRAME fPage1 = NO
                        iDias:SENSITIVE IN FRAME fPage1 = NO.
                 APPLY "ENTRY":U TO TTmab-movto-event.val-evento IN FRAME fPage1.
                 APPLY "FOCUS":U TO TTmab-movto-event.val-evento IN FRAME fPage1.

                 ASSIGN TTmab-movto-event.cod-sub-sist:SCREEN-VALUE IN FRAME fPage1 = ""
                        TTmab-movto-event.cd-tipo:SCREEN-VALUE IN FRAME fPage1 = ""
                        cDescTpManut:SCREEN-VALUE IN FRAME fPage1 = ""
                        cDescSubSist:SCREEN-VALUE IN FRAME fPage1 = "".
                 RUN piDescEvento IN THIS-PROCEDURE.
                 RETURN NO-APPLY.
          END.
       END.

        IF cAction = "Update":U THEN DO:
            IF iValorFlag = 1 AND TTmab-movto-event.dat-final <> ? THEN DO:
             ASSIGN  TTmab-movto-event.ep-codigo:SENSITIVE IN FRAME fPage1 = NO
                     TTmab-movto-event.cod-eqpto:SENSITIVE IN FRAME fPage1 = NO
                     TTmab-movto-event.cod-evento:SENSITIVE IN FRAME fPage1 = NO
                     TTmab-movto-event.cod-ofici:SENSITIVE IN FRAME fPage1 = NO
                     TTmab-movto-event.cod-sub-sist:SENSITIVE IN FRAME fPage1 = NO
                     TTmab-movto-event.cd-tipo:SENSITIVE IN FRAME fPage1 = NO
                     TTmab-movto-event.dat-inicial:SENSITIVE IN FRAME fPage0 = NO
                     TTmab-movto-event.dat-final:SENSITIVE IN FRAME fPage1 = NO
                     TTmab-movto-event.dsl-obs:SENSITIVE IN FRAME fPage1 = NO
                     TTmab-movto-event.val-km-aviso:SENSITIVE IN FRAME fPage1 = NO
                     TTmab-movto-event.hra-final:SENSITIVE IN FRAME fPage1 = NO
                     TTmab-movto-event.hra-inicial:SENSITIVE IN FRAME fPage0 = NO
                     TTmab-movto-event.val-evento:SENSITIVE IN FRAME fPage1 = NO
                     iDias:SENSITIVE IN FRAME fPage1 = NO.
    
                     
                      /* Inicio -- Projeto Internacional */
                      {utp/ut-liter.i "Evento" *}
                      run utp/ut-msgs.p (input "Show",
                                         input 28421,
                                         input RETURN-VALUE).
                        return "NOK":U.
            END.
        END.
        
        
        IF cAction = "Update":U THEN DO:
            IF TTmab-movto-event.log-disparad = TRUE THEN DO:
                ASSIGN  TTmab-movto-event.ep-codigo:SENSITIVE IN FRAME fPage1 = NO
                         TTmab-movto-event.cod-eqpto:SENSITIVE IN FRAME fPage1 = NO
                         TTmab-movto-event.cod-evento:SENSITIVE IN FRAME fPage1 = NO
                         TTmab-movto-event.cod-ofici:SENSITIVE IN FRAME fPage1 = NO
                         TTmab-movto-event.cod-sub-sist:SENSITIVE IN FRAME fPage1 = NO
                         TTmab-movto-event.cd-tipo:SENSITIVE IN FRAME fPage1 = NO
                         TTmab-movto-event.dat-inicial:SENSITIVE IN FRAME fPage0 = NO
                         TTmab-movto-event.dat-final:SENSITIVE IN FRAME fPage1 = NO
                         TTmab-movto-event.dsl-obs:SENSITIVE IN FRAME fPage1 = NO
                         TTmab-movto-event.val-km-aviso:SENSITIVE IN FRAME fPage1 = NO
                         TTmab-movto-event.hra-final:SENSITIVE IN FRAME fPage1 = NO
                         TTmab-movto-event.hra-inicial:SENSITIVE IN FRAME fPage0 = NO
                         TTmab-movto-event.val-evento:SENSITIVE IN FRAME fPage1 = NO.

                        
                         /* Inicio -- Projeto Internacional */
                         {utp/ut-liter.i "Evento" *}
                         run utp/ut-msgs.p (input "Show",
                                            input 28420,
                                            input RETURN-VALUE).
                            return "NOK":U.
            END.
        END.
        IF iValorFlag = 2 OR iValorFlag = 3 THEN DO:
              APPLY "ENTRY":U TO TTmab-movto-event.val-evento IN FRAME fPage1.
              APPLY "FOCUS":U TO TTmab-movto-event.val-evento IN FRAME fPage1.
              RETURN NO-APPLY.


        END.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.cod-evento wMaintenance
ON MOUSE-SELECT-DBLCLICK OF TTmab-movto-event.cod-evento IN FRAME fPage1 /* Evento */
OR f5 OF TTmab-movto-event.cod-evento IN FRAME fPage1 DO:

        {method/ZoomFields.i
           &ProgramZoom="frzoom/z01fr010.w"
           &FieldZoom1="cod-evento"
           &FieldScreen1="TTmab-movto-event.cod-evento"
           &Frame1="fPage1"
           &FieldZoom2="des-evento"
           &FieldScreen2="cDescEvento"
           &Frame2="fPage1"
           &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-movto-event.cod-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.cod-matr wMaintenance
ON LEAVE OF TTmab-movto-event.cod-matr IN FRAME fPage1 /* cod-matr */
do:
    for first mab-param
        where mab-param.cdn-param = 52 no-lock:
        if mab-param.des-valor = "1":U then do:
            for first mab-motoris
                where mab-motoris.cod-matr = TTmab-movto-event.cod-matr:screen-value in frame fPage1 no-lock:
                assign TTmab-movto-event.ep-codigo-matr:screen-value in frame fPage1 = string(mab-motoris.ep-codigo)
                       TTmab-movto-event.cod-estabel-matr:screen-value in frame fPage1 = mab-motoris.cod-estabel.
            end.
            if not avail mab-motoris then do:
                assign TTmab-movto-event.ep-codigo-matr:screen-value in frame fPage1 = ""
                       TTmab-movto-event.cod-estabel-matr:screen-value in frame fPage1 = "".
            end.
        end.
    end.

    {method/ReferenceFields.i
        &HandleDBOLeave="hDBOMotorista"
        &KeyValue1="input frame fPage1 TTmab-movto-event.ep-codigo-matr"
        &KeyValue2="input frame fPage1 TTmab-movto-event.cod-estabel-matr"
        &KeyValue3="input frame fPage1 TTmab-movto-event.cod-matr"
        &FieldName1="nom-motoris"
        &FieldScreen1="cDescMotorista"
        &Frame1="fPage1"}
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.cod-matr wMaintenance
ON MOUSE-SELECT-DBLCLICK OF TTmab-movto-event.cod-matr IN FRAME fPage1 /* cod-matr */
OR f5 OF TTmab-movto-event.cod-matr IN FRAME fPage1 DO:

        {method/ZoomFields.i
           &ProgramZoom="frzoom/z01fr017.w"
           &FieldZoom1="cod-matr"
           &FieldScreen1="TTmab-movto-event.cod-matr"
           &Frame1="fPage1"
           &FieldZoom2="nom-motoris"
           &FieldScreen2="cDescMotorista"
           &Frame2="fPage1"
           &FieldZoom3="ep-codigo"
           &FieldScreen3="TTmab-movto-event.ep-codigo-matr"
           &Frame3="fPage1"           
           &FieldZoom4="cod-estabel"
           &FieldScreen4="TTmab-movto-event.cod-estabel-matr"
           &Frame4="fPage1"
           &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-movto-event.cod-ofici
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.cod-ofici wMaintenance
ON LEAVE OF TTmab-movto-event.cod-ofici IN FRAME fPage1 /* Oficina */
DO:

    
  {method/ReferenceFields.i
      &HandleDBOLeave="hDBOOfic"
      &KeyValue1="input frame fPage1 TTmab-movto-event.cod-ofici"
      &FieldName1="des-ofici"
      &FieldScreen1="cDescOfic"
      &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.cod-ofici wMaintenance
ON MOUSE-SELECT-DBLCLICK OF TTmab-movto-event.cod-ofici IN FRAME fPage1 /* Oficina */
OR f5 OF TTmab-movto-event.cod-ofici IN FRAME fPage1 DO:

        {method/ZoomFields.i
           &ProgramZoom="frzoom/z01fr033.w"
           &FieldZoom1="cod-ofici"
           &FieldScreen1=" TTmab-movto-event.cod-ofici"
           &Frame1="fPage1"
           &FieldZoom2="des-ofici"
           &FieldScreen2="cDescOfic"
           &Frame2="fPage1"
           &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-movto-event.cod-sub-sist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.cod-sub-sist wMaintenance
ON F5 OF TTmab-movto-event.cod-sub-sist IN FRAME fPage1 /* Sub-Sistema */
DO:
  {method/ZoomFields.i
           &ProgramZoom="frzoom/z01fr025.w"
           &FieldZoom1="cod-sub-sist"
           &FieldScreen1=" TTmab-movto-event.cod-sub-sist"
           &Frame1="fPage1"
           &FieldZoom2="des-sub-sist"
           &FieldScreen2="cDescSubSist"
           &Frame2="fPage1"
           &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.cod-sub-sist wMaintenance
ON LEAVE OF TTmab-movto-event.cod-sub-sist IN FRAME fPage1 /* Sub-Sistema */
DO:
    
      {method/ReferenceFields.i
          &HandleDBOLeave="hDBOSubSist"
          &KeyValue1="input frame fPage1 TTmab-movto-event.cod-sub-sist"
          &FieldName1="des-sub-sist"
          &FieldScreen1="cDescSubSist"
          &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.cod-sub-sist wMaintenance
ON MOUSE-SELECT-DBLCLICK OF TTmab-movto-event.cod-sub-sist IN FRAME fPage1 /* Sub-Sistema */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-movto-event.ct-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.ct-despesa wMaintenance
ON ENTRY OF TTmab-movto-event.ct-despesa IN FRAME fPage1 /* Conta Despesa */
DO:
  ASSIGN {&ttTable}.ct-despesa:FORMAT IN FRAME fPage1 = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.ct-despesa wMaintenance
ON F5 OF TTmab-movto-event.ct-despesa IN FRAME fPage1 /* Conta Despesa */
DO:
    IF NOT VALID-HANDLE(h_api_cta_ctbl) OR
        h_api_cta_ctbl:TYPE      <> "PROCEDURE":U OR
        h_api_cta_ctbl:FILE-NAME <> "prgint/utb/utb743za.py":U THEN DO:
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.    
    END.
    
    ASSIGN  cEmpresaEstab = INPUT FRAME fPage1 {&ttTable}.ep-codigo
            dDtMovimento  = INPUT FRAME fPage0 {&ttTable}.dat-inicial.

    RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  cEmpresaEstab,       /* EMPRESA PADR«O DO USUµRIO*/
                                                   INPUT  "CEP",               /* MODULO */                                                  
                                                   INPUT  "",                  /* PLANO DE CONTAS */
                                                   INPUT  v_cod_finalid,       /* FINALIDADES */
                                                   INPUT  dDtMovimento,        /* DATA TRANSACAO */
                                                   OUTPUT v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                   OUTPUT v_des_cta_ctbl,      /* DESCRICAO CONTA */
                                                   OUTPUT v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).  /* ERROS */
    
    IF v_cod_cta_ctbl <> "" THEN
		ASSIGN {&ttTable}.ct-despesa:SCREEN-VALUE IN FRAME fPage1 = v_cod_cta_ctbl.
    
    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.

    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        DELETE OBJECT h_api_cta_ctbl.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.ct-despesa wMaintenance
ON LEAVE OF TTmab-movto-event.ct-despesa IN FRAME fPage1 /* Conta Despesa */
DO:
    ASSIGN  cEmpresaEstab = INPUT FRAME fPage1 {&ttTable}.ep-codigo
            dDtMovimento  = INPUT FRAME fPage0 {&ttTable}.dat-inicial.
                                                
    IF {&ttTable}.ct-despesa:SCREEN-VALUE <> "" THEN DO:
        {cdp/cdunif001a.i  {&ttTable}.ct-despesa {&ttTable}.cc-despesa fPage1 dDtMovimento cEmpresaEstab """" }
    END.

    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.ct-despesa wMaintenance
ON MOUSE-SELECT-DBLCLICK OF TTmab-movto-event.ct-despesa IN FRAME fPage1 /* Conta Despesa */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME TTmab-movto-event.dat-inicial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.dat-inicial wMaintenance
ON LEAVE OF TTmab-movto-event.dat-inicial IN FRAME fpage0 /* Abertura */
DO:
    ASSIGN {&ttTable}.dat-inicial = DATE({&ttTable}.dat-inicial:SCREEN-VALUE IN FRAME fPage0).
    APPLY "LEAVE":U TO {&ttTable}.cod-eqpto IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME TTmab-movto-event.ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.ep-codigo wMaintenance
ON LEAVE OF TTmab-movto-event.ep-codigo IN FRAME fPage1 /* ep-codigo */
DO:
          FOR FIRST empresa FIELDS (ep-codigo nome) 
               WHERE empresa.ep-codigo = INPUT FRAME fPage1 TTmab-movto-event.ep-codigo NO-lock:
               ASSIGN cDescEmp = empresa.nome.
               
                DISP cDescEmp WITH FRAME fPage1.
                
          END.
           run buscaModelo in this-procedure (input input frame fPage1 {&ttTable}.ep-codigo,
                                              input input frame fPage1 {&ttTable}.cod-eqpto).
            {method/referenceFields.i
                &HandleDBOLeave="hDBOModelo"
                &KeyValue1="cCodModelo"
                &FieldName1="des-model"
                &FieldScreen1="cDescEqpto"
                &Frame1="fPage1"}
                
                RUN piDescEvento IN THIS-PROCEDURE.

          APPLY "LEAVE":U TO {&ttTable}.cod-eqpto IN FRAME fPage1.

 END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.ep-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF TTmab-movto-event.ep-codigo IN FRAME fPage1 /* ep-codigo */
OR f5 OF TTmab-movto-event.ep-codigo IN FRAME fPage1 DO:

     {method/ZoomFields.i
           &ProgramZoom="frzoom/z01fr007.w"
           &FieldZoom1="cod-eqpto"
           &FieldScreen1="TTmab-movto-event.cod-eqpto"
           &Frame1="fPage1"
           &FieldZoom2="ep-codigo"
           &FieldScreen2="TTmab-movto-event.ep-codigo"
           &Frame2="fPage1"
           &EnableImplant="YES"}
     wait-for "CLOSE":U of hProgramZoom.
    apply "LEAVE":U to {&ttTable}.ep-codigo in frame fPage1. 
    apply "LEAVE":U to {&ttTable}.cod-eqpto in frame fPage1. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-movto-event.ep-codigo-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.ep-codigo-matr wMaintenance
ON F5 OF TTmab-movto-event.ep-codigo-matr IN FRAME fPage1 /* Motorista */
DO:
  APPLY "F5":U TO TTmab-movto-event.cod-matr IN FRAM fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.ep-codigo-matr wMaintenance
ON MOUSE-SELECT-DBLCLICK OF TTmab-movto-event.ep-codigo-matr IN FRAME fPage1 /* Motorista */
DO:
  APPLY "F5":U TO TTmab-movto-event.cod-matr IN FRAM fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-cod-emitente IN FRAME fPage1 /* Emitente */
OR f5 OF fi-cod-emitente IN FRAME fPage1 DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad098.w"
                     &campo=fi-cod-emitente
                     &campozoom=cod-emitente
                     &FRAME=fPage1}

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-movto-event.hra-final
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.hra-final wMaintenance
ON LEAVE OF TTmab-movto-event.hra-final IN FRAME fPage1 /* hra-final */
DO:
    assign cHora = TTmab-movto-event.hra-final:screen-value in frame fPage1.
     run piFormataHorarioSeg (input-output cHora).
     if return-value = "NOK":U then do:
         apply "ENTRY":U to TTmab-movto-event.hra-final in frame fPage1.
         return no-apply.
     end.
     assign TTmab-movto-event.hra-final:screen-value in frame fPage1 = cHora.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.hra-final wMaintenance
ON RETURN OF TTmab-movto-event.hra-final IN FRAME fPage1 /* hra-final */
DO:
  APPLY "LEAVE":U TO SELF.
  APPLY "CHOOSE":U TO btsave IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME TTmab-movto-event.hra-inicial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.hra-inicial wMaintenance
ON LEAVE OF TTmab-movto-event.hra-inicial IN FRAME fpage0 /* hra-inicial */
DO:
   assign cHora-1 = TTmab-movto-event.hra-inicial:screen-value in frame fPage0.
     run piFormataHorarioSeg (input-output cHora-1).
     if return-value = "NOK":U then do:
         apply "ENTRY":U to TTmab-movto-event.hra-inicial in frame fPage0.
         return no-apply.
     end.
     assign TTmab-movto-event.hra-inicial:screen-value in frame fPage0 = cHora-1.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.hra-inicial wMaintenance
ON RETURN OF TTmab-movto-event.hra-inicial IN FRAME fpage0 /* hra-inicial */
DO:
  APPLY "LEAVE":U TO SELF.
  APPLY "CHOOSE":U TO btsave.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME iDias
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iDias wMaintenance
ON LEAVE OF iDias IN FRAME fPage1 /* Dias */
DO:
  RUN piDescEvento IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME TTmab-movto-event.num-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.num-docto wMaintenance
ON LEAVE OF TTmab-movto-event.num-docto IN FRAME fpage0 /* Documento */
DO:
  
  EMPTY TEMP-TABLE rowErrors.
  RUN emptyRowErrors IN {&hDBOTable}.

  RUN consisteResgistro  in {&hDBOTable} (INPUT INPUT FRAME fPage0 TTmab-movto-event.num-docto,
                                          INPUT INPUT FRAME fPage1 TTmab-movto-event.ep-codigo,
                                          INPUT INPUT FRAME fPage1 TTmab-movto-event.cod-eqpto,
                                          INPUT INPUT FRAME fPage1 TTmab-movto-event.cod-evento,
                                          INPUT INPUT FRAME fPage1 TTmab-movto-event.dat-final ).

  IF RETURN-VALUE = "NOK":U THEN DO:
    {method/showmessage.i1}
    run getRowErrors in {&hDBOTable} (output table RowErrors).
    {method/showmessage.i2 &Modal="YES"}
    run emptyRowErrors in {&hDBOTable}.
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Programaá∆o" *}
    run utp/ut-msgs.p (input "Show",
                          input 28423,
                          input RETURN-VALUE).
    IF RETURN-VALUE = "Yes":U THEN
       return "OK":U.
    ELSE
        RETURN "NOK":U.
  END.
  ELSE 
      RETURN "OK":U.

 
     

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME TTmab-movto-event.val-km-aviso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-movto-event.val-km-aviso wMaintenance
ON LEAVE OF TTmab-movto-event.val-km-aviso IN FRAME fPage1 /* Aviso */
DO:
  RUN piDescEvento IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/mainblock.i}




    TTmab-movto-event.ep-codigo:load-mouse-pointer ("image/lupa.cur") in frame fPage1.
    TTmab-movto-event.cod-eqpto:load-mouse-pointer ("image/lupa.cur") in frame fPage1.
    TTmab-movto-event.cod-evento:load-mouse-pointer ("image/lupa.cur") in frame fPage1.
    TTmab-movto-event.cod-ofici:load-mouse-pointer ("image/lupa.cur") in frame fPage1.
    TTmab-movto-event.cod-sub-sist:load-mouse-pointer ("image/lupa.cur") in frame fPage1.
    TTmab-movto-event.cd-tipo:load-mouse-pointer ("image/lupa.cur") in frame fPage1.
    TTmab-movto-event.cod-matr:load-mouse-pointer ("image/lupa.cur") in frame fPage1.
    TTmab-movto-event.ep-codigo-matr:load-mouse-pointer ("image/lupa.cur") in frame fPage1.
    TTmab-movto-event.cod-estabel-matr:load-mouse-pointer ("image/lupa.cur") in frame fPage1.
ASSIGN iDias = 999999.
DISP iDias WITH FRAME fPage1.

TTmab-movto-event.ct-despesa:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame                     fPage1.
TTmab-movto-event.cc-despesa:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame                  fPage1.
fi-cod-emitente:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame             fPage1.

/* roda o initialize DBOs para setar os valores dos handles 07/04/06*/
RUN initializeDBOs IN THIS-PROCEDURE.

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

IF VALID-HANDLE (hDOEmpEqpto) THEN
    RUN destroy IN hDOEmpEqpto.

IF VALID-HANDLE (hDBOEqpto) THEN
    RUN destroy IN hDBOEqpto.

IF VALID-HANDLE (hDBOEvent) THEN
    RUN destroy IN hDBOEvent.

IF VALID-HANDLE (hDBOTpManut) THEN
    RUN destroy IN hDBOTpManut.

IF VALID-HANDLE (hDBOSubSist) THEN
    RUN destroy IN hDBOSubSist.

IF VALID-HANDLE (hDBOOfic) THEN
    RUN destroy IN hDBOOfic.
    
if valid-handle(hDBOModelo) then
    run Destroy in hDBOModelo.

if valid-handle(hDBOMotorista) then
    run Destroy in hDBOMotorista.

/** Grupo de Evento **/
IF VALID-HANDLE (hDBOGrpEvent) THEN
    RUN destroy IN hDBOGrpEvent.

/** Historico **/
IF VALID-HANDLE(hDBOHistor) THEN
    RUN Destroy IN hDBOHistor.

{method/showmessage.i3}

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

if cAction <> "":U then do:
    assign {&ttTable}.dsl-obs:sensitive in frame fPage1            = yes 
           {&ttTable}.dsl-obs:read-only in frame fPage1            = no. 
end.
else do:
    assign {&ttTable}.dsl-obs:sensitive in frame fPage1            = yes
           {&ttTable}.dsl-obs:read-only in frame fPage1            = yes.   
end.

return "ok":U.
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
{utp/ut-liter.i "Trajeto" MAB}
ASSIGN {&ttTable}.val-km-aviso:LABEL IN FRAME fPage1 = RETURN-VALUE.
{utp/ut-liter.i Execuá∆o * }
ASSIGN fiExecucao:SCREEN-VALUE IN FRAME fPage1 = RETURN-VALUE.
{utp/ut-liter.i Observaá∆o * }
ASSIGN fiObs:SCREEN-VALUE IN FRAME fPage1 = RETURN-VALUE.
{utp/ut-liter.i Unidade_Neg¢cio * }
ASSIGN fi-cod-unid-negoc:LABEL IN FRAME fPage1 = RETURN-VALUE.


/**se existir um documento valido atualiza campos sen∆o joga branco para as descriá‰es***/
IF INPUT FRAME fPage0 TTmab-movto-event.num-docto <> 0 THEN DO:
   
    apply "LEAVE":U to TTmab-movto-event.ep-codigo     in frame fPage1.
    apply "LEAVE":U to TTmab-movto-event.cod-eqpto     in frame fPage1.
    apply "LEAVE":U to TTmab-movto-event.cod-evento    in frame fPage1.
    apply "LEAVE":U to TTmab-movto-event.cod-ofici     in frame fPage1.
    apply "LEAVE":U to TTmab-movto-event.cod-sub-sist  in frame fPage1.
    apply "LEAVE":U to TTmab-movto-event.cd-tipo       in frame fPage1.
    apply "LEAVE":U to TTmab-movto-event.cod-matr      in frame fPage1.
    apply "LEAVE":U to cDescUn in frame fPage1.
    ASSIGN iDias = TTmab-movto-event.dat-aviso - INPUT FRAME fPage0 TTmab-movto-event.dat-inicial.
    DISP iDias WITH FRAME fPage1.
    
    run pi-busca-conta in this-procedure.  
END.
ELSE DO:

    ASSIGN cDescEmp       = ""
           cDescEqpto     = ""
           cDescEvento    = ""
           cDescOfic      = ""
           cDescTpManut   = ""
           cDescSubSist   = ""
           cDescUn        = "" 
           cDescMotorista = "". 

      DISP cDescEmp      
           cDescEqpto    
           cDescEvento   
           cDescOfic     
           cDescTpManut  
           cDescSubSist  
           cDescUn 
           cDescMotorista      WITH FRAME fPage1.

END.

if cAction <> "":U then do:
    assign {&ttTable}.dsl-obs:sensitive in frame fPage1            = yes 
           {&ttTable}.dsl-obs:read-only in frame fPage1            = no. 
end.
else do:
    assign {&ttTable}.dsl-obs:sensitive in frame fPage1            = yes
           {&ttTable}.dsl-obs:read-only in frame fPage1            = yes.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN

       IF AVAIL {&ttTable} THEN
            ASSIGN fi-cod-unid-negoc:SCREEN-VALUE IN FRAME fPage1 = {&ttTable}.cod-unid-negoc.  

    &ENDIF
end.

/** Busca os formatos da conta e sub-conta **/
EMPTY TEMP-TABLE tt_log_erro.

ASSIGN  cEmpresaEstab = STRING({&ttTable}.ep-codigo:SCREEN-VALUE IN FRAME fPage1)
        dDtMovimento  = DATE({&ttTable}.dat-inicial:SCREEN-VALUE IN FRAME fPage0).

IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.  
IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT cEmpresaEstab,        /* EMPRESA EMS2 */
                                               INPUT "",                   /* PLANO CCUSTO */
                                               INPUT dDtMovimento,         /* DATA DE TRANSACAO */
                                               OUTPUT p_cod_format_ccusto, /* FORMATO CCUSTO */
                                               OUTPUT TABLE tt_log_erro).  /* ERROS */


RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT cEmpresaEstab,
                                                   INPUT "",
                                                   INPUT dDtMovimento,
                                                   OUTPUT p_cod_format_cta_ctbl,
                                                   OUTPUT TABLE tt_log_erro).

IF VALID-HANDLE(h_api_ccusto) THEN DELETE OBJECT h_api_ccusto.
IF VALID-HANDLE(h_api_cta_ctbl) THEN DELETE OBJECT h_api_cta_ctbl.

  /* tratamento de erros */
   IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
        {cdp/cdunif001b.i}
    END.

ASSIGN {&ttTable}.ct-despesa:FORMAT IN FRAME fPage1 = IF {&ttTable}.ct-despesa:SCREEN-VALUE = "" THEN "x(20)" ELSE p_cod_format_cta_ctbl
       {&ttTable}.cc-despesa:FORMAT IN FRAME fPage1 = IF {&ttTable}.cc-despesa:SCREEN-VALUE = "" THEN "x(20)" ELSE p_cod_format_ccusto  .

/** Habilita/Desabilita botao Matriz de Unidade Negocio **/
IF l-usa-unid-negoc THEN
    RUN piValidaMatriz IN THIS-PROCEDURE.

return "OK":U.
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

assign iEmpresa = input frame fPage1    {&ttTable}.ep-codigo
       cEquipto = input frame fPage1    {&ttTable}.cod-eqpto.
IF INPUT FRAME fPage0 TTmab-movto-event.num-docto <> 0 THEN DO:
    apply "LEAVE":U to TTmab-movto-event.ep-codigo     in frame fPage1.
    apply "LEAVE":U to TTmab-movto-event.cod-eqpto     in frame fPage1.
    apply "LEAVE":U to TTmab-movto-event.cod-evento    in frame fPage1.
    apply "LEAVE":U to TTmab-movto-event.cod-ofici     in frame fPage1.
    apply "LEAVE":U to TTmab-movto-event.cod-sub-sist  in frame fPage1.
    apply "LEAVE":U to TTmab-movto-event.cod-matr      in frame fPage1.
    apply "LEAVE":U to TTmab-movto-event.cd-tipo in frame fPage1.
    apply "LEAVE":U to cDescUn in frame fPage1.
END.
ELSE DO:
    ASSIGN cDescEmp       = ""
           cDescEqpto     = ""
           cDescEvento    = ""
           cDescOfic      = ""
           cDescTpManut   = ""
           cDescSubSist   = ""
           cDescUn        = "" 
           cDescMotorista = "".      
END.

IF AVAIL TTmab-movto-event THEN
/** Desabilita campos em tela que n∆o s∆o atualizados pelo usu†rio **/
disable TTmab-movto-event.cod-usuar
        TTmab-movto-event.num-docto
    with frame fPage0.


if cAction = "ADD":U  then do:
   ASSIGN iDias = 999999.
   DISP iDias WITH FRAME fPage1.
end.

if cAction = "ADD":U or cAction = "COPY":U then do:
    /** Busca pr¢ximo n£mero do documento automaticamente **/
    run buscaDocumento in {&hDBOTable} (output TTmab-movto-event.num-docto).
    /** Busca a hora atual **/
    run piFormataSegundoParaHora (input  time,
                                  output TTmab-movto-event.hra-inicial).
end.
/** Busca Usu†rio Corrente do EMS **/
assign TTmab-movto-event.cod-usuar = c-seg-usuario.

disp TTmab-movto-event.num-docto
     TTmab-movto-event.cod-usuar
     TTmab-movto-event.hra-inicial
     with frame fPage0.

/*Verifica valor do flag na tabela mab-evento*/
RUN verificaFlag IN  hDBOEvent (INPUT  TTmab-movto-event.cod-evento:SCREEN-VALUE IN FRAME fPage1,
                                OUTPUT iValorFlag).

/**Atualiza compos em funá∆o do tipo de evento***/
IF cAction = "ADD":U THEN DO:
   IF iValorFlag = 1 THEN DO:
       ASSIGN TTmab-movto-event.val-evento:SENSITIVE IN FRAME fPage1 = NO
              TTmab-movto-event.cod-sub-sist:SENSITIVE IN FRAME fPage1 = YES   
              TTmab-movto-event.cd-tipo:SENSITIVE IN FRAME fPage1 = YES  
              TTmab-movto-event.val-km-aviso:SENSITIVE IN FRAME fPage1 = YES     
              iDias:SENSITIVE IN FRAME fPage1 = YES
              TTmab-movto-event.val-km-aviso:SENSITIVE IN FRAME fPage1 = YES
              TTmab-movto-event.val-evento = 0.
       DISP TTmab-movto-event.val-evento WITH FRAME fPage1.
   END.
   ELSE DO:
       ASSIGN TTmab-movto-event.val-evento:SENSITIVE IN FRAME fPage1 = YES.
       APPLY "ENTRY":U TO TTmab-movto-event.val-evento IN FRAME fPage1.
       APPLY "FOCUS":U TO TTmab-movto-event.val-evento IN FRAME fPage1.
   END.
END.

IF cAction = "ADD":U OR cAction = "Update":U THEN DO:
   IF iValorFlag = 2 OR iValorFlag = 3  THEN DO:
       
    ASSIGN  TTmab-movto-event.cod-sub-sist:SENSITIVE IN FRAME fPage1 = NO
            TTmab-movto-event.cd-tipo:SENSITIVE IN FRAME fPage1 = NO
            TTmab-movto-event.val-km-aviso:SENSITIVE IN FRAME fPage1 = NO
            iDias:SENSITIVE IN FRAME fPage1 = NO.
     APPLY "ENTRY":U TO TTmab-movto-event.val-evento IN FRAME fPage1.
     APPLY "FOCUS":U TO TTmab-movto-event.val-evento IN FRAME fPage1.
     ASSIGN TTmab-movto-event.cod-sub-sist:SCREEN-VALUE IN FRAME fPage1 = "".
  END.
END.

IF cAction = "Update":U THEN DO:
    IF iValorFlag = 1 AND TTmab-movto-event.dat-final <> ? THEN DO:
       
     ASSIGN  TTmab-movto-event.ep-codigo:SENSITIVE IN FRAME fPage1 = NO
             TTmab-movto-event.cod-eqpto:SENSITIVE IN FRAME fPage1 = NO
             TTmab-movto-event.cod-evento:SENSITIVE IN FRAME fPage1 = NO
             TTmab-movto-event.cod-ofici:SENSITIVE IN FRAME fPage1 = NO
             TTmab-movto-event.cod-sub-sist:SENSITIVE IN FRAME fPage1 = NO
             TTmab-movto-event.cd-tipo:SENSITIVE IN FRAME fPage1 = NO
             TTmab-movto-event.dat-inicial:SENSITIVE IN FRAME fPage0 = NO
             TTmab-movto-event.dat-final:SENSITIVE IN FRAME fPage1 = NO
             TTmab-movto-event.dsl-obs:SENSITIVE IN FRAME fPage1 = NO
             TTmab-movto-event.val-km-aviso:SENSITIVE IN FRAME fPage1 = NO
             TTmab-movto-event.hra-final:SENSITIVE IN FRAME fPage1 = NO
             TTmab-movto-event.hra-inicial:SENSITIVE IN FRAME fPage0 = NO
             TTmab-movto-event.val-evento:SENSITIVE IN FRAME fPage1 = NO
             TTmab-movto-event.num-parc-event:SENSITIVE IN FRAME fPage1 = NO
             iDias:SENSITIVE IN FRAME fPage1 = NO.
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Evento" *}
              run utp/ut-msgs.p (input "Show",
                                 input 28421,
                                 input RETURN-VALUE).
                return "NOK":U.
    END.
END.

ASSIGN TTmab-movto-event.hra-final = "00:00:00".

/*Man. Mecanica*/
run cdp/cd9902.p (input 3).
if return-value = "NOK":U then
   assign TTmab-movto-event.cod-ofici:SENSITIVE IN FRAME fPage1 = NO.
else
   assign TTmab-movto-event.cod-ofici:SENSITIVE IN FRAME fPage1 = yes.

if cAction <> "":U then do:
    assign {&ttTable}.dsl-obs:sensitive in frame fPage1            = yes 
           {&ttTable}.dsl-obs:read-only in frame fPage1            = no. 
end.
else do:
    assign {&ttTable}.dsl-obs:sensitive in frame fPage1            = yes
           {&ttTable}.dsl-obs:read-only in frame fPage1            = yes. 
end.

for first mab-param
    where mab-param.cdn-param = 52 no-lock:
    if mab-param.des-valor = "1":U then do:
        assign TTmab-movto-event.ep-codigo-matr:sensitive in frame fPage1 = no
               TTmab-movto-event.cod-estabel-matr:sensitive in frame fPage1 = no.
    end.
    else do:
        assign TTmab-movto-event.ep-codigo-matr:sensitive in frame fPage1 = yes
               TTmab-movto-event.cod-estabel-matr:sensitive in frame fPage1 = yes.
    end.
end.

return "OK":U.

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

{utp/ut-liter.i "Conta"}
assign {&ttTable}.ct-despesa:label in frame fPage1 = trim(return-value).
{utp/ut-liter.i "Centro_Custo"}
assign {&ttTable}.cc-despesa:label in frame fPage1 = trim(return-value).
{utp/ut-liter.i "Emitente"}
assign fi-cod-emitente:label in frame fPage1 = trim(return-value).

if cAction <> "":U then do:
    assign {&ttTable}.dsl-obs:sensitive in frame fPage1            = yes 
           {&ttTable}.dsl-obs:read-only in frame fPage1            = no. 
end.
else do:
    assign {&ttTable}.dsl-obs:sensitive in frame fPage1            = yes
           {&ttTable}.dsl-obs:read-only in frame fPage1            = yes. 
end.

ASSIGN btMatriz:SENSITIVE        IN FRAME fPage1 = l-usa-unid-negoc
       btMatriz:VISIBLE          IN FRAME fPage1 = l-usa-unid-negoc
       fi-cod-unid-negoc:VISIBLE IN FRAME fPage1 = l-usa-unid-negoc.

/** Habilita/Desabilita botao Matriz de Unidade Negocio **/
IF l-usa-unid-negoc THEN
    RUN piValidaMatriz IN THIS-PROCEDURE.
ELSE
    ASSIGN btMatriz:TOOLTIP IN FRAME fPage1 = "":U.

/*a BO obriga a conta ter finalidade de consumo*/
{utp/ut-liter.i Consumo}
ASSIGN v_cod_finalid = RETURN-VALUE.

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


IF AVAIL TTmab-movto-event THEN DO:
    ASSIGN TTmab-movto-event.dat-aviso = INPUT FRAME fPage0 TTmab-movto-event.dat-inicial + INPUT FRAME fPage1 iDias
           {&ttTable}.num-livre-1 = INPUT FRAME fPage1 fi-cod-emitente.
    IF cAction = "COPY":U THEN
        ASSIGN TTmab-movto-event.num-docto-orig = 0.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN
            ASSIGN {&ttTable}.cod-unid-negoc = INPUT FRAME fPage1 fi-cod-unid-negoc.
    &ENDIF
END.


disable {&ttTable}.ct-despesa WITH FRAME fPage1.
disable {&ttTable}.cc-despesa WITH FRAME fPage1.
disable fi-cod-emitente WITH FRAME fPage1.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaModelo wMaintenance 
PROCEDURE buscaModelo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter pEmp   like mab-eqpto.ep-codigo no-undo.
define input parameter pEqpto like mab-eqpto.cod-eqpto no-undo.

{method/referenceFields.i
    &HandleDBOLeave="hDBOEqpto"
    &KeyValue1="pEmp"
    &KeyValue2="pEqpto"
    &FieldName1="cod-model"
    &Variable1="cCodModelo"}
    
 

return "OK":U.

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
    
   DEFINE VARIABLE  iNrDoc  LIKE  {&ttTable}.num-docto
           VIEW-AS FILL-IN SIZE 14.00 BY 0.88 NO-UNDO.
    {utp/ut-liter.i V† _Para_Movimento_do_Evento * }
    DEFINE FRAME fGoToRecord
        iNrDoc            AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE return-value FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Movimento_do_Evento"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN  iNrDoc.
        
        RUN goToKey IN {&hDBOTable} (INPUT  iNrDoc ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-liter.i Movimento_do_Evento * }
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT return-value ).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE  iNrDoc  btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilitaCampos wMaintenance 
PROCEDURE habilitaCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cGrupo like mab-grp-eqpto.cod-grp-eqpto  NO-UNDO.
run getCharField in hDBOEvent (input "cod-grp-event":U, output cGrupo).
/**busca o tipo de paramametro***/
run gotoKey in hDBOGrpEvent (input cGrupo).
run getIntField in hDBOGrpEvent (input "idi-tip":U, output iTpValor ).
    if iTpValor <>  5 then DO with frame fPage1:
       ASSIGN RECT-38:hidden in frame fPage1         = yes
              {&ttTable}.ct-despesa :hidden in frame fPage1         = yes    
              {&ttTable}.cc-despesa :hidden in frame fPage1      = yes
              fi-cod-emitente:hidden in frame fPage1 = yes.
      disable {&ttTable}.ct-despesa with frame fPage1. 
      disable {&ttTable}.cc-despesa with frame fPage1.
      disable fi-cod-emitente with frame fPage1.
     assign lControl = no.                                              
    end. 
    else do:
       ASSIGN RECT-38:hidden in frame fPage1         = no
              {&ttTable}.ct-despesa :hidden in frame fPage1         = no    
              {&ttTable}.cc-despesa :hidden in frame fPage1      = no
              fi-cod-emitente:hidden in frame fPage1 = NO
              lControl                               = yes.
      if cAction <> "":U then do:
        enable {&ttTable}.ct-despesa with frame fPage1. 
        enable {&ttTable}.cc-despesa with frame fPage1.   
        enable fi-cod-emitente with frame fPage1.
      end.
    end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicializaEventoAmostra wMaintenance 
PROCEDURE inicializaEventoAmostra :
/*------------------------------------------------------------------------------
  Purpose:     inicializaEventoAmostra
  Parameters:  entrada pEmp      = C¢digo da empresa
               entrada pEqpto    = C¢digo do Equipamento
               entrada pSub      = C¢digo do sub-sistema
               entrada pEvento   = C¢digo do Evento
               entrada pObs      = Observaá∆o da troca de OlÇo
               sa°da   pNumEvent = Numero do documento criado
  Notes:       Incializa as informaá‰es na inclus∆o de um registro.
------------------------------------------------------------------------------*/
define input parameter pEmp       like mab-eqpto.ep-codigo                no-undo.
define input parameter pEqpto     like mab-eqpto.cod-eqpto                no-undo.
define input parameter pSub       like mab-sub-sist.cod-sub-sist          no-undo.
define input parameter pEvento    like mab-event.cod-evento               no-undo.
define input parameter pTpManut   like mab-movto-event.cd-tipo            no-undo.
define input  parameter pObs      like mao-ensaio-padr.dsl-obs-nao-troca  NO-UNDO.
define output parameter pNumEvent like mab-movto-event.num-docto          NO-UNDO.


apply "CHOOSE":U to btAdd in frame fPage0.

assign {&ttTable}.ep-codigo    = pEmp
       {&ttTable}.cod-eqpto    = pEqpto
       {&ttTable}.cod-sub-sist = pSub
       {&ttTable}.cod-evento   = pEvento
       {&ttTable}.dsl-obs      = pObs
       {&ttTable}.dat-aviso    = today
       {&ttTable}.cd-tipo      = pTpManut.

display {&ttTable}.ep-codigo   
        {&ttTable}.cod-eqpto   
        {&ttTable}.cod-sub-sist
        {&ttTable}.cod-evento
        {&ttTable}.dsl-obs 
        {&ttTable}.cd-tipo with frame fPage1.

ASSIGN iDias = {&ttTable}.dat-aviso - INPUT FRAME fPage0 {&ttTable}.dat-inicial.
DISP iDias WITH FRAME fPage1.
run pi-busca-conta in this-procedure.

apply "LEAVE":U to {&ttTable}.ep-codigo    in frame fPage1.
apply "LEAVE":U to {&ttTable}.cod-eqpto    in frame fPage1.
apply "LEAVE":U to {&ttTable}.cod-sub-sist in frame fPage1.
apply "LEAVE":U to {&ttTable}.cod-evento   in frame fPage1.
apply "LEAVE":U to {&ttTable}.dsl-obs      in frame fPage1.
apply "LEAVE":U to {&ttTable}.cd-tipo      in frame fPage1.
apply "ENTRY":U to {&ttTable}.ep-codigo    in frame fPage1.
 /**** Grava o N£mero do Documento criado ****/
assign pNumEvent = input frame fPage0 {&ttTable}.num-docto.



return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicializaInclusao wMaintenance 
PROCEDURE inicializaInclusao :
/*------------------------------------------------------------------------------
  Purpose:     inicializaInclusao
  Parameters:  entrada pEmp    = C¢digo da empresa
               entrada pEqpto  = C¢digo do Equipamento
               entrada pSub    = C¢digo do sub-sistema
               entrada pEvento = C¢digo do Evento
               entrada pManut  = C¢digo Tipo Manutená∆o
  Notes:       Incializa as informaá‰es na inclus∆o de um registro.
------------------------------------------------------------------------------*/
define input parameter pEmp    like mab-eqpto.ep-codigo       no-undo.
define input parameter pEqpto  like mab-eqpto.cod-eqpto       no-undo.
define input parameter pSub    like mab-sub-sist.cod-sub-sist no-undo.
define input parameter pEvento like mab-event.cod-evento      no-undo.
define input parameter pManut  like mab-item-lubrific.cd-tipo no-undo.

apply "CHOOSE":U to btAdd in frame fPage0.

assign {&ttTable}.ep-codigo    = pEmp
       {&ttTable}.cod-eqpto    = pEqpto
       {&ttTable}.cod-sub-sist = pSub
       {&ttTable}.cod-evento   = pEvento
       {&ttTable}.cd-tipo      = pManut
       {&ttTable}.dat-aviso    = today.

display {&ttTable}.ep-codigo   
        {&ttTable}.cod-eqpto   
        {&ttTable}.cod-sub-sist
        {&ttTable}.cod-evento
        {&ttTable}.cd-tipo  with frame fPage1.

ASSIGN iDias = {&ttTable}.dat-aviso - INPUT FRAME fPage0 {&ttTable}.dat-inicial.
DISP iDias WITH FRAME fPage1.
run pi-busca-conta in this-procedure.

apply "LEAVE":U to {&ttTable}.ep-codigo    in frame fPage1.
apply "LEAVE":U to {&ttTable}.cod-eqpto    in frame fPage1.
apply "LEAVE":U to {&ttTable}.cod-sub-sist in frame fPage1.
apply "LEAVE":U to {&ttTable}.cod-evento   in frame fPage1.
apply "LEAVE":U to {&ttTable}.cd-tipo      in frame fPage1.
apply "ENTRY":U to {&ttTable}.ep-codigo    in frame fPage1.




return "OK":U.

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
       {&hDBOTable}:FILE-NAME <> "frbo/bofr059.p":U THEN DO:
        run "frbo/bofr059.p" persistent set {&hDBOTable}.
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.   


    /*:T--- Verifica se o DBO do Equipamento j† est† inicializado ---*/
    IF NOT VALID-HANDLE(hDBOEqpto) OR
       hDBOEqpto:TYPE <> "PROCEDURE":U OR
       hDBOEqpto:FILE-NAME <> "frbo/bofr007.p":U THEN DO:
        run "frbo/bofr007.p" persistent set hDBOEqpto.
    END.

    RUN openQueryStatic IN hDBOEqpto (INPUT "Main":U) NO-ERROR.

     /*:T--- Verifica se o DBO de Eventos j† est† inicializado ---*/
    IF NOT VALID-HANDLE(hDBOEvent) OR
       hDBOEvent:TYPE <> "PROCEDURE":U OR
       hDBOEvent:FILE-NAME <> "frbo/bofr010.p":U THEN DO:
        run "frbo/bofr010.p" persistent set hDBOEvent.
    END.
    
    RUN openQueryStatic IN hDBOEvent (INPUT "Main":U) NO-ERROR.

        /*:T--- Verifica se o DBO do Tipo de Manutená∆o j† est† inicializado ---*/
    IF NOT VALID-HANDLE(hDBOTpManut) OR
       hDBOTpManut:TYPE <> "PROCEDURE":U OR
       hDBOTpManut:FILE-NAME <> "mnbo/bomn158.p":U THEN DO:
        run "mnbo/bomn158.p" persistent set hDBOTpManut.
    END.
    
    RUN openQueryStatic IN hDBOTpManut (INPUT "Default":U) NO-ERROR.  

        /*:T--- Verifica se o DBO do Sub-Sistema j† est† inicializado ---*/
    IF NOT VALID-HANDLE(hDBOSubSist) OR
       hDBOSubSist:TYPE <> "PROCEDURE":U OR
       hDBOSubSist:FILE-NAME <> "frbo/bofr025.p":U THEN DO:
        run "frbo/bofr025.p" persistent set hDBOSubSist.
    END.
    
    RUN openQueryStatic IN hDBOSubSist (INPUT "Main":U) NO-ERROR.  


        /*:T--- Verifica se o DBO da Oficina j† est† inicializado ---*/
    IF NOT VALID-HANDLE(hDBOOfic) OR
       hDBOOfic:TYPE <> "PROCEDURE":U OR
       hDBOOfic:FILE-NAME <> "frbo/bofr033.p":U THEN DO:
        run "frbo/bofr033.p" persistent set hDBOOfic.
    END.
    
    RUN openQueryStatic IN hDBOOfic (INPUT "Main":U) NO-ERROR.  
     /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo/bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

 /*--- DBO Motorista ---*/
    IF NOT VALID-HANDLE(hDBOMotorista) OR
       hDBOMotorista:TYPE <> "PROCEDURE":U OR
       hDBOMotorista:FILE-NAME <> "frbo/bofr017.p":U THEN DO:
        run frbo/bofr017.p persistent set  hDBOMotorista.
    END.
    
    RUN openQueryStatic IN hDBOMotorista (INPUT "Main":U) NO-ERROR.


   /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE(hDBOGrpEvent) OR
       hDBOGrpEvent:TYPE <> "PROCEDURE":U OR
       hDBOGrpEvent:FILE-NAME <> "frbo/bofr012.p":U THEN DO:
        run "frbo/bofr012.p" persistent set hDBOGrpEvent.
    END.
    
    RUN openQueryStatic IN hDBOGrpEvent (INPUT "Main":U) NO-ERROR.

    /*:T--- BO de Historico Atividade ---*/
    IF NOT VALID-HANDLE(hDBOHistor) OR
       hDBOHistor:TYPE <> "PROCEDURE":U OR
       hDBOHistor:FILE-NAME <> "frbo/bofr013.p":U THEN DO:
        run frbo/bofr013.p persistent set hDBOHistor.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-conta wMaintenance 
PROCEDURE pi-busca-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE l-int-ap AS LOGICAL initial no   NO-UNDO.
DEFINE VARIABLE cConta   AS character format "x(20)" NO-UNDO.
   run habilitaCampos in this-procedure.
  if return-value <> "NOK":U and lControl then do:
       run getLogField in hDBOEvent (input "log-integr-ap":U, output l-int-ap).
        /**** Verifica se evento integra com Contas  a Pagar***/
       if l-int-ap then do:
          /****Busca os valores j† gravados****/
          if cAction <> "":U then do:
              enable {&ttTable}.ct-despesa   with frame fPage1.
              enable {&ttTable}.cc-despesa   with frame fPage1.
              enable fi-cod-emitente with frame fPage1.
              if cAction <> "ADD":U then do:
                  assign fi-cod-emitente:SCREEN-VALUE IN FRAME fPage1 = STRING({&ttTable}.num-livre-1).
              end.
              if {&ttTable}.ct-despesa:screen-value in frame fPage1  = "":U  then do:
                 /*** Se em branco busca conta do Evento***/
                 run getCharField in hDBOEvent (input "ct-despesa":U, output cConta).
                 assign {&ttTable}.ct-despesa:screen-value in frame fPage1 = trim(cConta).
              end.
              if {&ttTable}.cc-despesa:screen-value in frame fPage1   = "":U then do:
                  /*** E busca su-conta do Equipamento ****/
                   run gotokey in hDBOEqpto (input input frame fPage1 {&ttTable}.ep-codigo,
                                             input input frame fPage1 {&ttTable}.cod-eqpto).
                   if return-value <> "NOK":U then do:
                      run getCharField in hDBOEqpto (input "cc-codigo":U, output cConta).
                      assign {&ttTable}.cc-despesa:screen-value in frame fPage1 = trim(cConta).
                   end.
              end.
              if iEmpresa <> input frame fPage1    {&ttTable}.ep-codigo or
                  cEquipto  <> input frame fPage1    {&ttTable}.cod-eqpto then do:
                  assign  iEmpresa = input frame fPage1    {&ttTable}.ep-codigo 
                          cEquipto = input frame fPage1    {&ttTable}.cod-eqpto.
               /*** E busca su-conta do Equipamento ****/
                run gotokey in hDBOEqpto (input input frame fPage1 {&ttTable}.ep-codigo,
                                          input input frame fPage1 {&ttTable}.cod-eqpto).
                if return-value <> "NOK":U then do:
                   run getCharField in hDBOEqpto (input "cc-codigo":U, output cConta).
                   assign {&ttTable}.cc-despesa:screen-value in frame fPage1 = cConta.
                end.
             end.
          end.
          else do:
              assign fi-cod-emitente:SCREEN-VALUE IN FRAME fPage1 = STRING({&ttTable}.num-livre-1).
          end.
       end.
       /*** Sen∆o desabilita os campos e joga branco***/
       else do:
          disable {&ttTable}.ct-despesa with frame fPage1.
          disable {&ttTable}.cc-despesa with frame fPage1.
          disable fi-cod-emitente with frame fPage1.
          assign {&ttTable}.ct-despesa:screen-value in frame fPage1         = "":U  
                 {&ttTable}.cc-despesa:screen-value in frame fPage1      = "":U
                 fi-cod-emitente:screen-value in frame fPage1 = "0":U. 
       end.
    end.
    else do:
          disable {&ttTable}.ct-despesa      with frame fPage1.
          disable {&ttTable}.cc-despesa      with frame fPage1.
          disable fi-cod-emitente with frame fPage1.
          assign {&ttTable}.ct-despesa:screen-value in frame fPage1         = "":U  
                 {&ttTable}.cc-despesa:screen-value in frame fPage1      = "":U
                 fi-cod-emitente:screen-value in frame fPage1 = "0":U. 
    END.

    IF {&ttTable}.ct-despesa:SCREEN-VALUE <> "" AND p_cod_format_cta_ctbl <> "" THEN
       ASSIGN {&ttTable}.ct-despesa:FORMAT IN FRAME fPage1 = p_cod_format_cta_ctbl.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa-tela wMaintenance 
PROCEDURE pi-limpa-tela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN cDescEmp:SCREEN-VALUE IN FRAME fPage1    = "":U
       cdescEqpto:SCREEN-VALUE IN FRAME fPage1  = "":U
       fi-cod-emitente:screen-value in frame fPage1 = "0":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDescEvento wMaintenance 
PROCEDURE piDescEvento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cGerado         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEquipamento    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEvento         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cVencimentoDias AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cVencimentoKm   AS CHARACTER  NO-UNDO.

IF cAction <> "" THEN DO:
    if {&ttTable}.dsl-obs = "" then do:

        {utp/ut-liter.i "Apontamento criado manualmente:"}
        ASSIGN cGerado = TRIM(RETURN-VALUE).
        
        {utp/ut-liter.i "Equipamento"}
        ASSIGN cEquipamento = TRIM(RETURN-VALUE) + ": " + string({&ttTable}.ep-codigo:SCREEN-VALUE IN FRAME fPage1) + " - " + {&ttTable}.cod-eqpto:SCREEN-VALUE IN FRAME fPage1 + " - " + cDescEqpto:SCREEN-VALUE IN FRAME fPage1.
        
        {utp/ut-liter.i "Evento"}
        ASSIGN cEvento = TRIM(RETURN-VALUE) + ": " + STRING({&ttTable}.cod-evento:SCREEN-VALUE IN FRAME fPage1) + " - " + cDescEvento:SCREEN-VALUE IN FRAME fPage1.
    
        IF (INPUT FRAME fPage1 iDias <> 999999) AND (INPUT FRAME fPage1 {&ttTable}.val-km-aviso <> 999999) THEN DO:
            {utp/ut-liter.i "Vencimento"}
            assign cVencimentoKm = trim(return-value) + ": " + string(INPUT FRAME fPage1 {&ttTable}.val-km-aviso) + " " + cDescUn:SCREEN-VALUE IN FRAME fPage1
                   cVencimentoDias = trim(return-value) + ": " + STRING({&ttTable}.dat-inicial + INPUT FRAME fPage1 iDias,"99/99/9999")
                   {&ttTable}.dsl-obs = cGerado + chr(10) + cEquipamento + CHR(10) + cEvento + CHR(10) + cVencimentoDias + CHR(10) + cVencimentoKm.
        END.
        ELSE DO:
            IF INPUT FRAME fPage1 iDias <> 999999 THEN DO:
                {utp/ut-liter.i "Vencimento"}
                assign cVencimentoDias = trim(return-value) + ": " + STRING({&ttTable}.dat-inicial + INPUT FRAME fPage1 iDias,"99/99/9999")
                       {&ttTable}.dsl-obs = cGerado + chr(10) + cEquipamento + CHR(10) + cEvento + CHR(10) + cVencimentoDias.
            END.
            ELSE DO:
                IF INPUT FRAME fPage1 {&ttTable}.val-km-aviso <> 999999 THEN DO:
                    {utp/ut-liter.i "Vencimento"}
                    assign cVencimentoKm = trim(return-value) + ": " + string(INPUT FRAME fPage1 {&ttTable}.val-km-aviso) + " " + cDescUn:SCREEN-VALUE IN FRAME fPage1
                           {&ttTable}.dsl-obs = cGerado + chr(10) + cEquipamento + CHR(10) + cEvento + CHR(10) + cVencimentoKm.
                END.
            END.
        END.
        display {&ttTable}.dsl WITH FRAME fPage1.
    end.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piReposiciona wMaintenance 
PROCEDURE piReposiciona :
/*------------------------------------------------------------------------------
  Purpose:     piReposiciona
  Parameters:  entrada pDoc = N£mero do documento
  Notes:       Reposiciona o programa em um documento
------------------------------------------------------------------------------*/
define input parameter pDoc as integer no-undo.

define variable rGoTo as rowid no-undo.

RUN goTokey IN {&hDBOTable} (INPUT pDoc).

IF RETURN-VALUE = "OK":U THEN DO:
    /*:T Retorna rowid do registro corrente do DBO */
     RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
     
    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

END.
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaMatriz wMaintenance 
PROCEDURE piValidaMatriz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lTemMatriz AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE cUnidNegoc AS CHARACTER FORMAT "x(3)" NO-UNDO.

    &IF DEFINED(bf_mnt_ems206b) &THEN        
        RUN piRetornaUnidNegoc IN hDBOHistor (INPUT  INPUT FRAME fpage1 {&ttTable}.ep-codigo,
                                              INPUT  INPUT FRAME fpage1 {&ttTable}.cod-eqpto,
                                              INPUT  INPUT FRAME fpage0 {&ttTable}.dat-inicial,
                                              OUTPUT cUnidNegoc,
                                              OUTPUT lTemMatriz,
                                              OUTPUT TABLE tt-unid-negoc-histor).

        ASSIGN btMatriz:SENSITIVE IN FRAME fPage1 = lTemMatriz.

        IF cAction <> "":U AND cAction <> "UPDATE":U THEN
            ASSIGN fi-cod-unid-negoc:SCREEN-VALUE IN FRAME fPage1 = cUnidNegoc.        
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaEvento wMaintenance 
PROCEDURE setaEvento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE rGoto AS ROWID      NO-UNDO.
 /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        if return-value = "NOK":U then
            run getFirst in this-procedure.

RETURN "Ok":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaNumeracao wMaintenance 
PROCEDURE verificaNumeracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


        IF  AVAIL TTmab-movto-event THEN DO:

            ASSIGN l-ValEventoDuplicados = NO.   
            FIND FIRST mab-event
                 WHERE mab-event.cod-evento = TTmab-movto-event.cod-evento:SCREEN-VALUE IN FRAME fPage1
                   AND mab-event.log-integr-ap = YES NO-LOCK NO-ERROR.
            IF AVAIL mab-event AND mab-event.log-integr-ap THEN 
                /* Necessario para executar a procedure "consisteInclusaoDocto" */
                run validaEventoDuplicados in {&hDBOTable} (INPUT INPUT FRAME fPage0 TTmab-movto-event.dat-inicial,
                                                            INPUT INPUT FRAME fPage1 TTmab-movto-event.val-evento,
                                                            OUTPUT l-ValEventoDuplicados). 

            /** Verifica se j† existe movimento evento para equipamento **/
            run consisteInclusaoDocto in {&hDBOTable} (INPUT INPUT FRAME fPage1 TTmab-movto-event.ep-codigo,
                                                       input INPUT FRAME fPage1 TTmab-movto-event.cod-eqpto,
                                                       input INPUT FRAME fPage1 TTmab-movto-event.cod-evento,
                                                       INPUT INPUT FRAME fPage1 TTmab-movto-event.cod-sub-sist,
                                                       output iDoc).

            IF  return-value = "NOK":U then DO:                                                                                                    
                 IF  l-ValEventoDuplicados THEN DO:    
                     run utp/ut-msgs.p (INPUT "SHOW":U,
                                        INPUT 55408,
                                        INPUT TTmab-movto-event.cod-eqpto:SCREEN-VALUE IN FRAME fPage1 + '~~' + STRING(iDoc) + '~~' +
                                              TTmab-movto-event.cod-evento:SCREEN-VALUE IN FRAME fPage1  + '~~' + cDescEvento:SCREEN-VALUE  + '~~' +
                                              TTmab-movto-event.val-evento:SCREEN-VALUE IN FRAME fPage1  + '~~' +
                                              string(TTmab-movto-event.dat-aviso)).
                     RETURN "NOK":U.                                                                                                                
                 END.                                                                                                                               
                 ELSE DO:  
                     run utp/ut-msgs.p (INPUT "SHOW":U,                                                                                             
                                        INPUT 28493,                                                                                                
                                        INPUT TTmab-movto-event.cod-eqpto:SCREEN-VALUE IN FRAME fPage1 + '~~' + STRING(iDoc)).
                     IF  RETURN-VALUE = "NO":U THEN do:                                                                                             
                         RETURN "NOK":U.                                                                                                            
                     end.                                                                                                                           
                 END.
            END.
        END.
            /** Busca a numeraá∆o do Apontamento, pois pode ter sido 
                inclu°do um outro registro durante este erro **/
            run buscaDocumento in {&hDBOTable} (output TTmab-movto-event.num-docto).
            /** Mostra documento em tela **/
            display TTmab-movto-event.num-docto
                with frame fPage0.
            /* run piReposiciona in this-procedure (input TTmab-movto-event.num-docto).*/

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

