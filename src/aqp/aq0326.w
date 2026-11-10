&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T***************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/* Valida o sistema, pois ambientes UNIX (TTY) n’o possuem a classe Regex */
&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
    USING System.Text.RegularExpressions.*.
&ENDIF

{include/i-prgvrs.i AQ0326 2.00.00.011 } /*** "010011" ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aq0326 MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        aq0326
&GLOBAL-DEFINE Version        2.00.00.011
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Parƒmetros,Digita‡Æo,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets  
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   tg-envia-email-transp tg-envia-email-cc bt-diretorio-origem bt-diretorio-destino 
                              
&GLOBAL-DEFINE page5Widgets   brDigita ~
                              btAdd ~
                              btUpdate ~
                              btDelete ~
                              btSave ~
                              btOpen
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution ~
                              l-habilitaRtf ~
                              btModelRtf ~
                              tg-imp-param
&GLOBAL-DEFINE page7Widgets  
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      text-origem-arquivo text-destino-arquivo
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo text-rtf text-ModelRtf text-imp-param
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text     

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    c-cod-regiao-ini c-cod-regiao-fim c-cod-rota-ini c-cod-rota-fim i-cod-transp-ini i-cod-transp-fim
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    c-cod-estabel c-period cb-item c-origem c-destino c-email-cc c-remetente
&GLOBAL-DEFINE page5Fields    c-nome-transportador i-cod-transp c-email  
&GLOBAL-DEFINE page6Fields    cFile cModelRTF 
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    


{aqp/aq0326.i} /* Definicao temp-tables */

/* Parameters Definitions ---                                           */
DEFINE BUFFER b-tt-digita FOR tt-digita.

/* Transfer Definitions */

DEFINE VARIABLE raw-param AS RAW NO-UNDO.

DEFINE VARIABLE l-ok               AS LOGICAL   NO-UNDO. 
DEFINE VARIABLE c-arq-digita       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-terminal         AS CHARACTER NO-UNDO. 
DEFINE VARIABLE c-rtf              AS CHARACTER NO-UNDO. 
DEFINE VARIABLE c-arq-layout       AS CHARACTER NO-UNDO.      
DEFINE VARIABLE c-arq-temp         AS CHARACTER NO-UNDO. 
DEFINE VARIABLE c-modelo-default   AS CHARACTER NO-UNDO. 

DEFINE STREAM s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est  rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

{utp/ut-glob.i}

/* HANDLES */
DEFINE VARIABLE h-boad107na AS HANDLE NO-UNDO. /* estabelec          */
DEFINE VARIABLE h-boin01005 AS HANDLE NO-UNDO. /* nf-produt-propried */
DEFINE VARIABLE h-boin00983 AS HANDLE NO-UNDO. /* item-estab-rural   */
DEFINE VARIABLE h-boin00968 AS HANDLE NO-UNDO. /* param-aquis-rural  */
DEFINE VARIABLE h-boin627zm AS HANDLE NO-UNDO. /* usuar-mater        */
DEFINE VARIABLE h-boin287   AS HANDLE NO-UNDO. /* param-estoq        */
DEFINE VARIABLE h-bodi520   AS HANDLE NO-UNDO. /* param-nf-estab     */
DEFINE VARIABLE h-bodi00804 AS HANDLE NO-UNDO. /* param-gener        */
DEFINE VARIABLE h-boad268na AS HANDLE NO-UNDO. /* tranporte          */
DEFINE VARIABLE h-bofn017   AS HANDLE NO-UNDO. /* usuar-mestre       */

/* ZOOM SMART */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE VARIABLE c-cod-estabel-aux   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-ult-period-fech   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-it-codigo-aux     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-diretorio         AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-period-aux        AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-cod-transp-update AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-acao-digita       AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-transp-valido     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-tp-trans          AS CHARACTER NO-UNDO.

DEFINE TEMP-TABLE tt-param-transp NO-UNDO
    FIELD destino         AS INTEGER
    FIELD arquivo         AS CHARACTER FORMAT "x(35)":U
    FIELD usuario         AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec       AS DATE
    FIELD hora-exec       AS INTEGER
    FIELD classifica      AS INTEGER
    FIELD desc-classifica AS CHARACTER FORMAT "x(40)":U
    FIELD modelo          AS CHARACTER FORMAT "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo logico para verificar se o RTF foi habilitado*/
    FIELD l-habilitaRtf   AS LOGICAL
    FIELD regiao-ini      AS CHARACTER FORMAT "x(12)":U
    FIELD regiao-fim      AS CHARACTER FORMAT "x(12)":U
    FIELD rota-ini        AS CHARACTER FORMAT "x(12)":U
    FIELD rota-fim        AS CHARACTER FORMAT "x(12)":U
    FIELD grp-prod-ini    AS INTEGER
    FIELD grp-prod-fim    AS INTEGER
    FIELD prod-rural-ini  AS INTEGER
    FIELD prod-rural-fim  AS INTEGER
    FIELD cod-estabel     AS CHARACTER FORMAT "x(5)":U
    FIELD cod-periodo     AS CHARACTER FORMAT "99/9999"
    FIELD cod-serie       AS CHARACTER FORMAT "x(5)":U
    FIELD dt-emissao      AS DATE FORMAT "99/99/9999"
    FIELD it-codigo       AS CHARACTER FORMAT "X(16)":U
    FIELD nat-operacao    AS CHARACTER FORMAT "X(6)":U 
    FIELD cod-transp-ini  AS INTEGER
    FIELD cod-transp-fim  AS INTEGER
    FIELD cod-propried    AS CHARACTER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDigita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE brDigita                                      */
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.cod-transp tt-digita.descricao tt-digita.email /*   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita tt-digita.email*/   
&Scoped-define ENABLED-TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brDigita tt-digita
&Scoped-define SELF-NAME brDigita
&Scoped-define QUERY-STRING-brDigita FOR EACH tt-digita
&Scoped-define OPEN-QUERY-brDigita OPEN QUERY brDigita FOR EACH tt-digita.
&Scoped-define TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-brDigita tt-digita


/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-brDigita}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-13 btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE c-cod-regiao-fim LIKE regiao-abrangen.cod-regiao
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-cod-regiao-ini LIKE regiao-abrangen.cod-regiao
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-cod-rota-fim LIKE rota.cod-rota
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-rota-ini LIKE rota.cod-rota
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-transp-fim LIKE transpdor-coleta.cod-transp
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-transp-ini LIKE transpdor-coleta.cod-transp
     LABEL "Transportador" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON bt-diretorio-destino 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-diretorio-origem 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cb-item AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "x(5)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-destino AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-email-cc LIKE usuar-mater.e-mail
     LABEL "Endere‡o e-mail CC" 
     VIEW-AS FILL-IN 
     SIZE 54 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 45.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-origem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-period AS CHARACTER FORMAT "99/9999":U 
     LABEL "Per¡odo" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE c-remetente LIKE usuar-mater.e-mail
     LABEL "Remetente" 
     VIEW-AS FILL-IN 
     SIZE 54 BY .88 NO-UNDO.

DEFINE VARIABLE text-destino-arquivo AS CHARACTER FORMAT "X(256)":U INITIAL "Destino" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE VARIABLE text-origem-arquivo AS CHARACTER FORMAT "X(256)":U INITIAL "Origem" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.

DEFINE VARIABLE tg-envia-email-cc AS LOGICAL INITIAL no 
     LABEL "Envia e-mail CC" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-envia-email-transp AS LOGICAL INITIAL no 
     LABEL "Envia e-mail para Transportador" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.86 BY .83 NO-UNDO.

DEFINE BUTTON bt-can AUTO-END-KEY 
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "Ca&n" 
     SIZE 4 BY 1 TOOLTIP "Cancelar".

DEFINE BUTTON bt-sav 
     IMAGE-UP FILE "image/im-sav.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sav.bmp":U
     LABEL "&Sav" 
     SIZE 4 BY 1 TOOLTIP "Salvar".

DEFINE BUTTON btAdd 
     LABEL "Inserir" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btDelete 
     LABEL "Retirar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btOpen 
     LABEL "Recuperar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btUpdate 
     LABEL "Alterar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE VARIABLE c-email AS CHARACTER FORMAT "X(256)":U 
     LABEL "E-Mail" 
     VIEW-AS FILL-IN 
     SIZE 54.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-transportador AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.29 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-transp AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Tranportador" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image/im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btModelRtf 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE cModelRTF AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-imp-param AS CHARACTER FORMAT "X(256)":U INITIAL "Parƒmetros" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-ModelRtf AS CHARACTER FORMAT "X(256)":U INITIAL "Modelo:" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-rtf AS CHARACTER FORMAT "X(256)":U INITIAL "Rich Text Format(RTF)" 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.86 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.

DEFINE RECTANGLE rect-rtf
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 3.21.

DEFINE VARIABLE l-habilitaRtf AS LOGICAL INITIAL no 
     LABEL "RTF" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE tg-imp-param AS LOGICAL INITIAL yes 
     LABEL "Imprimir Parƒmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDigita FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDigita wReport _FREEFORM
  QUERY brDigita DISPLAY
      tt-digita.cod-transp COLUMN-LABEL "Transp"
        tt-digita.descricao  COLUMN-LABEL "Descri‡Æo" WIDTH 30
        tt-digita.email      COLUMN-LABEL "Email" WIDTH 30
       /* ENABLE
        tt-digita.email*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 84 BY 9.25
         BGCOLOR 15 FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.5 COL 1
     RECT-13 AT ROW 12.5 COL 20 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 .

DEFINE FRAME fPage4
     c-cod-estabel AT ROW 1.33 COL 15 COLON-ALIGNED HELP
          "C¢digo do estabelecimento"
     c-nome AT ROW 1.33 COL 23.14 COLON-ALIGNED NO-LABEL
     c-period AT ROW 2.33 COL 15 COLON-ALIGNED
     cb-item AT ROW 3.33 COL 15 COLON-ALIGNED 
     c-desc-item AT ROW 3.33 COL 31.29 COLON-ALIGNED NO-LABEL
     c-remetente AT ROW 4.33 COL 8.71 HELP
          "E-mail"
          LABEL "Remetente"
     tg-envia-email-transp AT ROW 5.29 COL 17.14
     tg-envia-email-cc AT ROW 6.08 COL 17.14
     c-email-cc AT ROW 7 COL 2.86 HELP
          "E-mail"
          LABEL "Endere‡o e-mail CC"
     c-origem AT ROW 8.88 COL 16 COLON-ALIGNED NO-LABEL
     bt-diretorio-origem AT ROW 8.79 COL 58 HELP
          "Escolha do nome do arquivo"
     c-destino AT ROW 11.5 COL 16 COLON-ALIGNED NO-LABEL
     bt-diretorio-destino AT ROW 11.46 COL 58 HELP
          "Escolha do nome do arquivo" 
     text-origem-arquivo AT ROW 8 COL 16.43 COLON-ALIGNED NO-LABEL
     text-destino-arquivo AT ROW 10.75 COL 16 COLON-ALIGNED NO-LABEL
     RECT-12 AT ROW 8.25 COL 17
     RECT-14 AT ROW 11 COL 17 
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.71
         FONT 1 .

DEFINE FRAME fPage2
     c-cod-regiao-ini AT ROW 2.25 COL 13.85 HELP
          "C¢digo RegiÆo"
          FONT 1
     c-cod-regiao-fim AT ROW 2.25 COL 54.14 HELP
          "C¢digo RegiÆo" NO-LABEL
          FONT 1
     c-cod-rota-ini AT ROW 3.29 COL 17.72 COLON-ALIGNED HELP
          "C¢digo da rota"
     c-cod-rota-fim AT ROW 3.25 COL 52.14 COLON-ALIGNED HELP
          "C¢digo da rota" NO-LABEL
     i-cod-transp-ini AT ROW 4.29 COL 17.72 COLON-ALIGNED HELP
          "C¢digo do transportador"
          LABEL "Transportador"
     i-cod-transp-fim AT ROW 4.25 COL 52.14 COLON-ALIGNED HELP
          "C¢digo do transportador" NO-LABEL
     IMAGE-1 AT ROW 2.29 COL 35.86
     IMAGE-2 AT ROW 2.29 COL 51.14
     IMAGE-3 AT ROW 3.25 COL 35.86 
     IMAGE-6 AT ROW 3.25 COL 51.14 
     IMAGE-7 AT ROW 4.25 COL 35.86 
     IMAGE-8 AT ROW 4.25 COL 51.14 
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.71
         FONT 1 .

DEFINE FRAME fPage6
     tg-imp-param AT ROW 9.67 COL 4
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configura‡Æo da impressora"
     l-habilitaRtf AT ROW 5.58 COL 3.14
     cModelRTF AT ROW 7.29 COL 3 HELP
          "Nome do arquivo de modelo" NO-LABEL
     btModelRtf AT ROW 7.29 COL 43 HELP
          "Escolha o arquivo de modelo"
     rsExecution AT ROW 12 COL 2.86 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-rtf AT ROW 5 COL 2 COLON-ALIGNED NO-LABEL
     text-ModelRtf AT ROW 6.54 COL 2 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 11.17 COL 2 COLON-ALIGNED NO-LABEL
     text-imp-param AT ROW 8.79 COL 1.86 COLON-ALIGNED NO-LABEL
     rect-rtf AT ROW 5.29 COL 2
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 11.5 COL 2
     RECT-10 AT ROW 9.04 COL 2 
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.71
         FONT 1 .

DEFINE FRAME fPage5
     brDigita AT ROW 1.25 COL 1
     btAdd AT ROW 10.58 COL 1
     btUpdate AT ROW 10.58 COL 16
     btDelete AT ROW 10.58 COL 31
     btSave AT ROW 10.58 COL 46
     btOpen AT ROW 10.58 COL 61
     i-cod-transp AT ROW 11.88 COL 11.86 COLON-ALIGNED
     c-nome-transportador AT ROW 11.88 COL 23.72 COLON-ALIGNED NO-LABEL
     c-email AT ROW 12.88 COL 11.86 COLON-ALIGNED 
     bt-sav AT ROW 12.79 COL 68.29 
     bt-can AT ROW 12.79 COL 72.14 
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.96
         FONT 1 .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 39.46
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 39.46
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{report/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
   Custom                                                               */
/* SETTINGS FOR FILL-IN c-cod-regiao-fim IN FRAME fPage2
   ALIGN-L LIKE = mgcad.regiao-abrangen.cod-regiao EXP-LABEL EXP-SIZE   */
/* SETTINGS FOR FILL-IN c-cod-regiao-ini IN FRAME fPage2
   ALIGN-L LIKE = mgcad.regiao-abrangen.cod-regiao EXP-SIZE             */
/* SETTINGS FOR FILL-IN c-cod-rota-fim IN FRAME fPage2
   LIKE = mgcad.rota.cod-rota EXP-LABEL EXP-SIZE                        */
/* SETTINGS FOR FILL-IN c-cod-rota-ini IN FRAME fPage2
   LIKE = mgcad.rota.cod-rota EXP-SIZE                                  */
/* SETTINGS FOR FILL-IN i-cod-transp-fim IN FRAME fPage2
   LIKE = mgcad.transpdor-coleta.cod-transp EXP-LABEL EXP-SIZE          */
/* SETTINGS FOR FILL-IN i-cod-transp-ini IN FRAME fPage2
   LIKE = mgcad.transpdor-coleta.cod-transp EXP-LABEL EXP-SIZE          */
/* SETTINGS FOR FRAME fPage4
   Custom                                                               */
/* SETTINGS FOR FILL-IN c-email-cc IN FRAME fPage4
   ALIGN-L LIKE = mgcad.usuar-mater.e-mail EXP-LABEL EXP-SIZE           */
/* SETTINGS FOR FILL-IN c-remetente IN FRAME fPage4
   ALIGN-L LIKE = mgcad.usuar-mater.e-mail EXP-LABEL EXP-SIZE           */
ASSIGN 
       text-destino-arquivo:PRIVATE-DATA IN FRAME fPage4     = 
                "Destino".

ASSIGN 
       text-origem-arquivo:PRIVATE-DATA IN FRAME fPage4     = 
                "Origem".

/* SETTINGS FOR FRAME fPage5
   Custom                                                               */
/* BROWSE-TAB brDigita 1 fPage5 */
/* SETTINGS FOR BUTTON bt-can IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-transportador IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       btModelRtf:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       cModelRTF:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-imp-param:PRIVATE-DATA IN FRAME fPage6     = 
                "Parƒmetros".

ASSIGN 
       text-ModelRtf:HIDDEN IN FRAME fPage6           = TRUE
       text-ModelRtf:PRIVATE-DATA IN FRAME fPage6     = 
                "Modelo:".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

ASSIGN 
       text-rtf:HIDDEN IN FRAME fPage6           = TRUE
       text-rtf:PRIVATE-DATA IN FRAME fPage6     = 
                "Rich Text Format(RTF)".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDigita
/* Query rebuild information for BROWSE brDigita
     _START_FREEFORM
OPEN QUERY brDigita FOR EACH tt-digita.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDigita */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDigita
&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON DEL OF brDigita IN FRAME fPage5
DO:
   apply 'choose' to btDelete in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON END-ERROR OF brDigita IN FRAME fPage5
ANYWHERE 
DO:
    if  brDigita:new-row in frame fPage5 then do:
        if  avail tt-digita then
            delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then. 
    end.                                                               
    else do:
        get current brDigita.
        display tt-digita.cod-transp
                tt-digita.descricao
                tt-digita.email with browse brDigita. 
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ENTER OF brDigita IN FRAME fPage5
ANYWHERE
DO:
  apply 'tab' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON INS OF brDigita IN FRAME fPage5
DO:
   apply 'choose' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-END OF brDigita IN FRAME fPage5
DO:
   apply 'entry' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-HOME OF brDigita IN FRAME fPage5
DO:
  apply 'entry' to btOpen in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-ENTRY OF brDigita IN FRAME fPage5
DO:
   /*:T trigger para inicializar campos da temp table de digita‡Æo */
   /*if  brDigita:new-row in frame fPage5 then do:
       assign tt-digita.exemplo:screen-value in browse brDigita = string(today, "99/99/9999":U).
   end.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-LEAVE OF brDigita IN FRAME fPage5
DO:
    /*:T  aqui que a grava‡Æo da linha da temp-table ‚ efetivada.
       Por‚m as valida‡äes dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment rio */
    
    if brDigita:NEW-ROW in frame fPage5 then 
    do transaction on error undo, return no-apply:
        create tt-digita.
        assign input browse brDigita tt-digita.email.
               

        brDigita:CREATE-RESULT-LIST-ENTRY() in frame fPage5.
    end.
    else do transaction on error undo, return no-apply:
        if avail tt-digita then
            assign input browse brDigita tt-digita.email.
                   
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-can
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-can wReport
ON CHOOSE OF bt-can IN FRAME fPage5 /* Can */
DO:
     RUN pi-controla-campos IN THIS-PROCEDURE(INPUT "desabilitar":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME bt-diretorio-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-diretorio-destino wReport
ON CHOOSE OF bt-diretorio-destino IN FRAME fPage4
DO:
    RUN pi-busca-diretorio IN THIS-PROCEDURE(OUTPUT c-diretorio).
    IF RETURN-VALUE = "OK" THEN
        ASSIGN c-destino:SCREEN-VALUE IN FRAME fPage4 = c-diretorio
               c-diretorio = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-diretorio-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-diretorio-origem wReport
ON CHOOSE OF bt-diretorio-origem IN FRAME fPage4
DO:
    RUN pi-busca-diretorio IN THIS-PROCEDURE(OUTPUT c-diretorio).
    IF RETURN-VALUE = "OK" THEN
        ASSIGN c-origem:SCREEN-VALUE IN FRAME fPage4 = c-diretorio
               c-diretorio = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME bt-sav
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sav wReport
ON CHOOSE OF bt-sav IN FRAME fPage5 /* Sav */
DO:
    RUN pi-atualiza-digitacao  IN THIS-PROCEDURE(INPUT c-acao-digita).  
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN pi-controla-botoes-dig IN THIS-PROCEDURE.
        RUN pi-controla-campos     IN THIS-PROCEDURE(INPUT "desabilitar":U).
    END.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wReport
ON CHOOSE OF btAdd IN FRAME fPage5 /* Inserir */
DO:
    ASSIGN c-acao-digita = "incluir".
    RUN pi-controla-campos IN THIS-PROCEDURE(INPUT c-acao-digita).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wReport
ON CHOOSE OF btConfigImpr IN FRAME fPage6
DO:
   {report/rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wReport
ON CHOOSE OF btDelete IN FRAME fPage5 /* Retirar */
DO:
    if  brDigita:num-selected-rows > 0 then do on error undo, return no-apply:
        get current brDigita.
        delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then.
    end.

    RUN pi-controla-botoes-dig IN THIS-PROCEDURE.
    RUN pi-controla-campos     IN THIS-PROCEDURE(INPUT "desabilitar":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wReport
ON CHOOSE OF btFile IN FRAME fPage6
DO:
    {report/rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wReport
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btModelRtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModelRtf wReport
ON CHOOSE OF btModelRtf IN FRAME fPage6
DO:
    def var cFile as char no-undo.
    def var l-ok  as logical no-undo.

    assign cModelRTF = replace(input frame {&frame-name} cModelRTF, "/", "~\").
    SYSTEM-DIALOG GET-FILE cFile
       FILTERS "*.rtf" "*.rtf",
               "*.*" "*.*"
       DEFAULT-EXTENSION "rtf"
       INITIAL-DIR "modelos" 
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then
        assign cModelRTF:screen-value in frame {&frame-name}  = replace(cFile, "~\", "/"). 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
   do  on error undo, return no-apply:
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btOpen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOpen wReport
ON CHOOSE OF btOpen IN FRAME fPage5 /* Recuperar */
DO:
    {report/rprcd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wReport
ON CHOOSE OF btSave IN FRAME fPage5 /* Salvar */
DO:
   {report/rpsvd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wReport
ON CHOOSE OF btUpdate IN FRAME fPage5 /* Alterar */
DO: 
    IF AVAIL tt-digita THEN DO:
        ASSIGN c-acao-digita = "alterar":U.
               i-cod-transp-update = tt-digita.cod-transp. /* guarada o codigo do transportador para poder posicinao na atualiza‡Æo */
        RUN pi-controla-campos IN THIS-PROCEDURE(INPUT c-acao-digita).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON LEAVE OF c-cod-estabel IN FRAME fPage4 /* Estabelecimento */
OR "ENTRY" OF c-cod-estabel DO:

    

    IF SELF:SCREEN-VALUE <> "" AND c-cod-estabel-aux <> SELF:SCREEN-VALUE  THEN DO:

        ASSIGN c-cod-estabel-aux = SELF:SCREEN-VALUE.
    
        IF VALID-HANDLE(h-boin00968) THEN DO:
            RUN goToKey IN h-boin00968(INPUT SELF:SCREEN-VALUE).
            IF RETURN-VALUE = "OK":U THEN DO:
                {method/ReferenceFields.i &HandleDBOLeave="h-boad107na"
                                          &KeyValue1="SELF:SCREEN-VALUE"
                                          &FieldName1="nome"
                                          &FieldScreen1="c-nome"
                                          &Frame1="fPage4"}
                                          
                                          
                RUN pi-carrega-cb-item       IN THIS-PROCEDURE(INPUT SELF:SCREEN-VALUE).
                RUN pi-busca-ult-period-fech IN THIS-PROCEDURE(INPUT SELF:SCREEN-VALUE).
                RUN pi-busca-dir-xml-estab-orig IN THIS-PROCEDURE(INPUT c-cod-estabel-aux).
                

            END.
            ELSE DO:
              ASSIGN c-nome:SCREEN-VALUE   IN FRAME fPage4 = ""
                     c-origem:SCREEN-VALUE IN FRAME fPage4 = "".
            END.
        END.
   END.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME fPage4 /* Estabelecimento */
OR 'F5' OF c-cod-estabel DO:

    ASSIGN l-implanta = NO.
                       
    {method/zoomfields.i &ProgramZoom="inzoom/z01in00968.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="c-cod-estabel"
                         &Frame1="fPage4"                         
                         &EnableImplant="NO"}                        
                       
                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-period
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-period wReport
ON LEAVE OF c-period IN FRAME fPage4 /* Per¡odo */
DO: 
    IF INT(REPLACE(SELF:SCREEN-VALUE,"/","")) > INT(c-ult-period-fech) THEN DO:

        {utp/ut-liter.i "Per¡odo informado deve ser menor ou igual ao £ltimo per¡odo fechado" *}      
        RUN utp/ut-msgs.p (INPUT "SHOW", 
                           INPUT 54806, /*Per¡odo inv lido!*/ 
                           INPUT RETURN-VALUE + "(" +  SUBSTR(c-ult-period-fech,1,2) + "/" + SUBSTR(c-ult-period-fech,3,4) + ")" ).

        ASSIGN SELF:SCREEN-VALUE = c-ult-period-fech. /* Se o periodo for inv lido, atualiza campo com o valor anterior */
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-item wReport
ON VALUE-CHANGED OF cb-item IN FRAME fPage4 /* Item */
DO:
    DEFINE VARIABLE c-descricao AS CHARACTER   NO-UNDO.

    IF SELF:SCREEN-VALUE <> "" AND c-it-codigo-aux <> SELF:SCREEN-VALUE THEN DO:
        IF VALID-HANDLE(h-boin00983) THEN DO:
           RUN findDescItem IN h-boin00983(INPUT SELF:SCREEN-VALUE, OUTPUT c-descricao).
    
           ASSIGN c-desc-item:SCREEN-VALUE IN FRAME fPage4 = c-descricao.
        END.

        EMPTY TEMP-TABLE tt-digita NO-ERROR.
       
    END.                      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME i-cod-transp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-transp wReport
ON LEAVE OF i-cod-transp IN FRAME fPage5 /* Tranportador */
OR "ENTRY" OF i-cod-transp DO:
    RUN getNomeEmail IN h-boad268na(INPUT INT(SELF:SCREEN-VALUE),
                                    OUTPUT c-nome-transportador,
                                    OUTPUT c-email).
  DISP c-nome-transportador c-email WITH FRAME fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-transp wReport
ON MOUSE-SELECT-DBLCLICK OF i-cod-transp IN FRAME fPage5 /* Tranportador */
OR 'F5' OF i-cod-transp DO:
    {method/zoomfields.i &ProgramZoom="adzoom/z10ad268.w"
                         &FieldZoom1="cod-transp"
                         &FieldScreen1="i-cod-transp"
                         &Frame1="fPage5"                        
                         &EnableImplant="NO"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME l-habilitaRtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-habilitaRtf wReport
ON VALUE-CHANGED OF l-habilitaRtf IN FRAME fPage6 /* RTF */
DO:
    &IF "{&RTF}":U = "YES":U &THEN
    RUN pi-habilitaRtf.  
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage6
DO:
do  with frame fPage6:
    case self:screen-value:
        when "1":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes
                   /*Alterado 15/02/2005 - tech1007 - Alterado para suportar adequadamente com a 
                     funcionalidade de RTF*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = NO
                   l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
                   l-habilitaRtf = NO
                   &endif
                   .
                   /*Fim alteracao 15/02/2005*/
        end.
        when "2":U then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   .
        end.
        when "3":U then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   .
            /*Alterado 15/02/2005 - tech1007 - Teste para funcionar corretamente no WebEnabler*/
            &IF "{&RTF}":U = "YES":U &THEN
            IF VALID-HANDLE(hWenController) THEN DO:
                ASSIGN l-habilitaRtf:sensitive  = NO
                       l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
                       l-habilitaRtf = NO.
            END.
            &endif
            /*Fim alteracao 15/02/2005*/
        END.
        /*Alterado 15/02/2005 - tech1007 - Condi‡Æo removida pois RTF nÆo ‚ mais um destino
        when "4":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes
                   text-ModelRtf:VISIBLE   = YES
                   rect-rtf:VISIBLE       = YES
                   blModelRtf:VISIBLE       = yes.
        end.
        Fim alteracao 15/02/2005*/
    end case.
end.
&IF "{&RTF}":U = "YES":U &THEN
RUN pi-habilitaRtf.  
&endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage6
DO:
   {report/rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME tg-envia-email-cc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-envia-email-cc wReport
ON VALUE-CHANGED OF tg-envia-email-cc IN FRAME fPage4 /* Envia e-mail CC */
DO:                                             
    RUN pi-habilita-email-cc  IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{report/mainblock.i}

c-cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage4.
i-cod-transp:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame fPage5.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wReport 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* estabelec */
    IF VALID-HANDLE(h-boad107na) THEN DO:
        DELETE PROCEDURE h-boad107na.
        ASSIGN h-boad107na = ?.          
    END.

    /* item-estab-rural */
    IF VALID-HANDLE(h-boin00983) THEN DO:
        DELETE PROCEDURE h-boin00983.
        ASSIGN h-boin00983 = ?.          
    END.

    /* param-aquis-rural */
    IF VALID-HANDLE(h-boin00968) THEN DO:
        DELETE PROCEDURE h-boin00968.
        ASSIGN h-boin00968 = ?.          
    END.

    /* usuar-mater */
    IF VALID-HANDLE (h-boin627zm) THEN DO: 
        DELETE PROCEDURE h-boin627zm .
        ASSIGN h-boin627zm = ?.
    END. 

    /* usuar-mater */
    IF VALID-HANDLE (h-boin287) THEN DO: 
        DELETE PROCEDURE h-boin287 .
        ASSIGN h-boin287 = ?.
    END.

    /* param-nf-estab */
    IF VALID-HANDLE (h-bodi520) THEN DO: 
        DELETE PROCEDURE h-bodi520 .
        ASSIGN h-bodi520 = ?.
    END.

    /* param-gener */
    IF VALID-HANDLE (h-bodi00804) THEN DO: 
        DELETE PROCEDURE h-bodi00804.
        ASSIGN h-bodi00804 = ?.
    END.

    /* nf-produt-propried */
    IF VALID-HANDLE (h-boin01005) THEN DO: 
        DELETE PROCEDURE h-boin01005.
        ASSIGN h-boin01005 = ?.
    END.

    /* transporte */
    IF VALID-HANDLE(h-boad268na) THEN DO:
        DELETE PROCEDURE h-boad268na.
        ASSIGN h-boad268na = ?.          
    END.

    /* usuar-mestre */
    IF VALID-HANDLE(h-bofn017) THEN DO:
        DELETE PROCEDURE h-bofn017.
        ASSIGN h-bofn017 = ?.          
    END.
    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN setProgramParent IN hFolder (INPUT THIS-PROCEDURE).

    ASSIGN c-cod-regiao-fim = FILL('Z':U, 12)
           c-cod-rota-fim   = FILL('Z':U, 12)
           i-cod-transp-fim = INT(FILL('9':U, 5))
           c-destino        = SESSION:TEMP-DIRECTORY.

    DISPLAY c-cod-regiao-fim
            c-cod-rota-fim  
            i-cod-transp-fim
            WITH FRAME fPage2.
    
    DISPLAY c-destino
        WITH FRAME fPage4.

    RUN initializeDBOs        IN THIS-PROCEDURE.
    RUN pi-busca-remetente    IN THIS-PROCEDURE.
    RUN pi-busca-estab-padrao IN THIS-PROCEDURE.    
    RUN pi-habilita-email-cc  IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changePage wReport 
PROCEDURE changePage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-num-folder AS INTEGER     NO-UNDO.

    RUN getCurrentFolder IN hfolder (OUTPUT i-num-folder).
    IF i-num-folder = 3 THEN DO: /* DIGITACAO */
        /* Se for a primeira vez que entrou no folder OU mudou algum campo de sele‡Æo ou parƒmetro, realiza a busca de transportadores */
        IF NOT AVAIL tt-param-transp
        OR (tt-param-transp.cod-estabel    <> c-cod-estabel:SCREEN-VALUE            IN FRAME fPage4 OR             
            tt-param-transp.it-codigo      <> cb-item:SCREEN-VALUE                  IN FRAME fPage4 OR       
            tt-param-transp.cod-periodo    <> REPLACE(c-period:SCREEN-VALUE         IN FRAME fPage4,"/","") OR
            tt-param-transp.regiao-ini     <> c-cod-regiao-ini:SCREEN-VALUE         IN FRAME fPage2 OR       
            tt-param-transp.regiao-fim     <> c-cod-regiao-fim:SCREEN-VALUE         IN FRAME fPage2 OR       
            tt-param-transp.rota-ini       <> c-cod-rota-ini:SCREEN-VALUE           IN FRAME fPage2 OR       
            tt-param-transp.rota-fim       <> c-cod-rota-fim:SCREEN-VALUE           IN FRAME fPage2 OR       
            tt-param-transp.cod-transp-ini <> INTEGER(i-cod-transp-ini:SCREEN-VALUE IN FRAME fPage2)OR       
            tt-param-transp.cod-transp-fim <> INTEGER(i-cod-transp-fim:SCREEN-VALUE IN FRAME fPage2)) THEN DO:
            EMPTY TEMP-TABLE tt-param-transp.
            CREATE tt-param-transp.
            ASSIGN tt-param-transp.cod-estabel    = c-cod-estabel:SCREEN-VALUE            IN FRAME fPage4 
                   tt-param-transp.it-codigo      = cb-item:SCREEN-VALUE                  IN FRAME fPage4 
                   tt-param-transp.cod-periodo    = REPLACE(c-period:SCREEN-VALUE         IN FRAME fPage4,"/","") 
                   tt-param-transp.regiao-ini     = c-cod-regiao-ini:SCREEN-VALUE         IN FRAME fPage2 
                   tt-param-transp.regiao-fim     = c-cod-regiao-fim:SCREEN-VALUE         IN FRAME fPage2  
                   tt-param-transp.rota-ini       = c-cod-rota-ini:SCREEN-VALUE           IN FRAME fPage2  
                   tt-param-transp.rota-fim       = c-cod-rota-fim:SCREEN-VALUE           IN FRAME fPage2  
                   tt-param-transp.cod-transp-ini = INTEGER(i-cod-transp-ini:SCREEN-VALUE IN FRAME fPage2)  
                   tt-param-transp.cod-transp-fim = INTEGER(i-cod-transp-fim:SCREEN-VALUE IN FRAME fPage2).
           
            RUN retornaListaTransportadoresNF IN h-boin01005(INPUT TABLE tt-param-transp, OUTPUT TABLE tt-digita).
            {&OPEN-QUERY-brDigita}
            RUN pi-controla-botoes-dig IN THIS-PROCEDURE.
            RUN pi-controla-campos     IN THIS-PROCEDURE(INPUT "desabilitar":U). /* Limpar possiveis valores dos campos e desabilita-los */
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wReport 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* estabelec */
    IF NOT VALID-HANDLE(h-boad107na) THEN
        RUN adbo/boad107na.p PERSISTENT SET h-boad107na.
    RUN openQueryStatic IN h-boad107na(INPUT "Main") NO-ERROR.

    /* item-estab-rural */
    IF NOT VALID-HANDLE(h-boin00983) THEN
        RUN inbo/boin00983.p PERSISTENT SET h-boin00983.
    RUN openQueryStatic IN h-boin00983(INPUT "Main") NO-ERROR.
    
    /* param-aquis-rural */
    IF NOT VALID-HANDLE(h-boin00968) THEN
        RUN inbo/boin00968.p PERSISTENT SET h-boin00968.
    RUN openQueryStatic IN h-boin00968(INPUT "Main") NO-ERROR.

    /* usuar-mater */
    IF NOT VALID-HANDLE(h-boin627zm) THEN 
        RUN inbo/boin627zm.p PERSISTENT SET h-boin627zm.
    RUN OpenQueryStatic IN h-boin627zm (INPUT "Default":U) NO-ERROR.
    
    /* usuar-mater */
    IF NOT VALID-HANDLE(h-boin287) THEN 
        RUN inbo/boin287.p PERSISTENT SET h-boin287.
    RUN OpenQueryStatic IN h-boin287 (INPUT "Main":U) NO-ERROR.  

    /* param-nf-estab */
    IF NOT VALID-HANDLE(h-bodi520) THEN 
        RUN dibo/bodi520.p PERSISTENT SET h-bodi520.
    RUN OpenQueryStatic IN h-bodi520 (INPUT "Main":U) NO-ERROR. 

    /* param-nf-estab */
    IF NOT VALID-HANDLE(h-bodi00804) THEN 
        RUN dibo/bodi00804.p PERSISTENT SET h-bodi00804.

    RUN setConstraintByChaveParam IN h-bodi00804 (INPUT "param-geral-tc":U, INPUT "dir-doctos-lidos":U) NO-ERROR.
    RUN OpenQueryStatic IN h-bodi00804 (INPUT "byChaveParam":U) NO-ERROR. 

    /* nf-produt-propried */
    IF NOT VALID-HANDLE(h-boin01005) THEN 
        RUN inbo/boin01005.p PERSISTENT SET h-boin01005.

    /* transporte */
    IF NOT VALID-HANDLE(h-boad268na) THEN
        RUN adbo/boad268na.p PERSISTENT SET h-boad268na.
    RUN OpenQueryStatic IN h-boad268na (INPUT "Main":U) NO-ERROR. 

    /* usuar-mestre */
    IF NOT VALID-HANDLE(h-bofn017) THEN
        RUN fnbo/bofn017.p PERSISTENT SET h-bofn017.
    RUN OpenQueryStatic IN h-bofn017 (INPUT "Main":U) NO-ERROR.
    RUN goToKey         IN h-bofn017 (INPUT c-seg-usuario ).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-digitacao wReport 
PROCEDURE pi-atualiza-digitacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-acao AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-params AS CHARACTER       NO-UNDO.
    DEFINE VARIABLE l-encontrou-nota AS LOGICAL NO-UNDO.

    CASE pc-acao:
        WHEN "incluir":U THEN DO:

            IF VALID-HANDLE(h-boin01005) THEN
                RUN canFindNotaTransp IN h-boin01005(INPUT INT(i-cod-transp:SCREEN-VALUE IN FRAME fPage5),
                                                     INPUT TABLE tt-param-transp,
                                                     OUTPUT l-encontrou-nota).  

            IF NOT l-encontrou-nota THEN DO:
                ASSIGN c-params = STRING(i-cod-transp:SCREEN-VALUE IN FRAME fPage5) + "~~" + 
                                         c-cod-estabel:SCREEN-VALUE IN FRAME fPage4 + "~~" + 
                                         cb-item:SCREEN-VALUE IN FRAME fPage4       + "~~" +
                                         SUBSTR(c-period:SCREEN-VALUE IN FRAME fPage4,1,2) + "/":U + 
                                         SUBSTR(c-period:SCREEN-VALUE IN FRAME fPage4,4,4).

                RUN utp/ut-msgs.p(INPUT "SHOW":U,
                                  INPUT "55150":U, /* Tranportador inv lido*/
                                  INPUT c-params).
                APPLY "ENTRY" TO i-cod-transp IN FRAME fPage5.
                RETURN NO-APPLY.
            END.

            IF CAN-FIND(FIRST tt-digita 
                        WHERE tt-digita.cod-transp = INTEGER(i-cod-transp:SCREEN-VALUE IN FRAME fPage5)) THEN DO:
                {utp/ut-liter.i "Transportador" * }
                RUN utp/ut-msgs.p(INPUT "SHOW":U,
                                  INPUT "8516":U, /* &1 j  informado(a).*/
                                  INPUT RETURN-VALUE).
                APPLY "ENTRY" TO i-cod-transp IN FRAME fPage5.
                RETURN NO-APPLY.
            END.

            {utp/ut-liter.i "do_Transportador" * }
            RUN pi-valida-email(INPUT INPUT FRAME fPage5 c-email, INPUT RETURN-VALUE).
            IF RETURN-VALUE = "NOK":U THEN DO:
                APPLY "ENTRY" TO c-email IN FRAME fPage5.
                RETURN NO-APPLY.
            END.

            CREATE tt-digita.
            ASSIGN tt-digita.cod-transp = INTEGER(i-cod-transp:SCREEN-VALUE IN FRAME fPage5)
                   tt-digita.descricao  = INPUT FRAME fPage5 c-nome-transportador
                   tt-digita.email      = INPUT FRAME fPage5 c-email.
                   
        END.
        WHEN "alterar":U THEN DO:
            FIND FIRST tt-digita WHERE tt-digita.cod-transp = i-cod-transp-update NO-ERROR.
            IF AVAIL tt-digita THEN DO:
                {utp/ut-liter.i "do_Transportador" * }
                RUN pi-valida-email(INPUT INPUT FRAME fPage5 c-email, INPUT RETURN-VALUE).
                IF RETURN-VALUE = "NOK":U THEN DO:
                    APPLY "ENTRY" TO c-email IN FRAME fPage5.
                    RETURN NO-APPLY.
                END.

                ASSIGN tt-digita.email = INPUT FRAME fPage5 c-email.
            END.
        END.
        OTHERWISE 
            RETURN NO-APPLY.
    END CASE.

    {&OPEN-QUERY-brDigita}
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-dir-xml-estab-orig wReport 
PROCEDURE pi-busca-dir-xml-estab-orig :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel AS CHARACTER NO-UNDO.

    ASSIGN c-origem = "".

    RUN cdp/cd0360b.p (INPUT pc-cod-estabel,
                       INPUT "NF-e":U,
                       OUTPUT c-tp-trans).

    IF c-tp-trans = "TC2":U OR c-tp-trans = "TPF":U THEN DO:
        IF VALID-HANDLE(h-bodi00804) THEN DO:
            RUN getCharField IN h-bodi00804(INPUT "cod-valor":U, OUTPUT c-origem).
            ASSIGN c-origem = c-origem + "\RECEIVED\":U.
        END.
    END.
    ELSE DO:
        IF VALID-HANDLE(h-bodi520) THEN DO:
            RUN goToKey IN h-bodi520(INPUT SELF:SCREEN-VALUE).
            IF RETURN-VALUE = "OK" THEN
                RUN getCharField IN h-bodi520(INPUT "cod-caminho-xml":U, OUTPUT c-origem).
        END.
    END.

    DISP c-origem WITH FRAME fPage4.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-diretorio wReport 
PROCEDURE pi-busca-diretorio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pc-diretorio AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-diretorio AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-cancelado AS LOGICAL   NO-UNDO.
   
    {&WINDOW-NAME}:SENSITIVE = NO.
    {utp/ut-liter.i Procurar_pasta * R}
    RUN utp/ut-dir.p (INPUT  RETURN-VALUE,
                      OUTPUT pc-diretorio,
                      OUTPUT l-cancelado).
    {&WINDOW-NAME}:SENSITIVE = YES.
    IF l-cancelado THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-estab-padrao wReport 
PROCEDURE pi-busca-estab-padrao :
/*------------------------------------------------------------------------------
  Purpose: BUSCAR E APRESENTAR NA TELA O ESTABELECIMENTO PADRÇO DO USUµRIO   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-char-1 AS CHARACTER NO-UNDO.

    IF VALID-HANDLE(h-boin627zm) THEN DO:
        RUN goTokey IN h-boin627zm(INPUT c-seg-usuario).
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getCharField IN h-boin627zm(INPUT "char-1":U, OUTPUT c-char-1).

            ASSIGN c-char-1 =  SUBSTRING(c-char-1,16,5).

            /* se nao encontrar estabelecimento padrao do usuario, busca estabelecimento padrao do estoque */
            IF c-char-1 = "" THEN DO:
                RUN openQueryStatic IN h-boin287(INPUT "Main":U).
                RUN getCharField    IN h-boin287(INPUT "estabel-pad":U, OUTPUT c-char-1).        
            END.

            ASSIGN c-cod-estabel:SCREEN-VALUE IN FRAME fPage4 = c-char-1.
            APPLY "LEAVE":U TO c-cod-estabel IN FRAME fPage4.
        END.
    END.         

    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-remetente wReport 
PROCEDURE pi-busca-remetente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-bofn017) THEN DO:
        RUN getCharField IN h-bofn017(INPUT "cod_e_mail_local":U, OUTPUT c-remetente).
        DISP c-remetente WITH FRAME fPage4.                                           
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-ult-period-fech wReport 
PROCEDURE pi-busca-ult-period-fech :
/*------------------------------------------------------------------------------
  Purpose:  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel AS CHARACTER NO-UNDO.

    IF VALID-HANDLE(h-boin00968) THEN DO:
        RUN goToKey IN h-boin00968(INPUT pc-cod-estabel) NO-ERROR.
        IF RETURN-VALUE = "OK":U THEN
            RUN getCharField IN h-boin00968(INPUT "cod-periodo":U, OUTPUT c-ult-period-fech) NO-ERROR.
    END.

    ASSIGN c-period:SCREEN-VALUE IN FRAME fPage4 = c-ult-period-fech.
          
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-cb-item wReport 
PROCEDURE pi-carrega-cb-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-list AS CHARACTER NO-UNDO.

    IF VALID-HANDLE(h-boin00983) THEN DO:
        RUN getListItemPairs IN h-boin00983(INPUT pc-cod-estabel, OUTPUT c-list).

        ASSIGN cb-item:LIST-ITEM-PAIRS IN FRAME fPage4 = c-list
               cb-item:SCREEN-VALUE    IN FRAME fPage4 = ENTRY (1,c-list).

        APPLY 'VALUE-CHANGED':U TO cb-item IN FRAME fPage4. 
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-controla-botoes-dig wReport 
PROCEDURE pi-controla-botoes-dig :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-habilitar AS LOGICAL     NO-UNDO.
                
    ASSIGN l-habilitar = NUM-RESULTS("brDigita":U) > 0.

    ASSIGN btUpdate:SENSITIVE IN FRAME fPage5 = l-habilitar
           btDelete:SENSITIVE IN FRAME fPage5 = l-habilitar
           btSave:SENSITIVE   IN FRAME fPage5 = l-habilitar.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-controla-campos wReport 
PROCEDURE pi-controla-campos :
/*------------------------------------------------------------------------------
  Purpose: Controlar a habilita‡Æo dos campos da aba digita‡Æo    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-acao AS CHARACTER NO-UNDO.
    
    ASSIGN c-nome-transportador:SENSITIVE IN FRAME fPage5 = FALSE.

    CASE pc-acao:
        WHEN "incluir" THEN DO:
            ASSIGN i-cod-transp:SENSITIVE IN FRAME fPage5 = TRUE  
                   c-email:SENSITIVE      IN FRAME fPage5 = TRUE       
                   bt-sav:SENSITIVE       IN FRAME fPage5 = TRUE        
                   bt-can:SENSITIVE       IN FRAME fPage5 = TRUE.
            APPLY "ENTRY":U TO i-cod-transp IN FRAME fPage5.
        END.
        WHEN "alterar" THEN DO:
            IF AVAIL tt-digita THEN DO:
                ASSIGN c-email:SENSITIVE                 IN FRAME fPage5 = TRUE       
                       bt-sav:SENSITIVE                  IN FRAME fPage5 = TRUE        
                       bt-can:SENSITIVE                  IN FRAME fPage5 = TRUE
                       i-cod-transp:SCREEN-VALUE         IN FRAME fPage5 = STRING(tt-digita.cod-transp)       
                       c-nome-transportador:SCREEN-VALUE IN FRAME fPage5 = STRING(tt-digita.descricao)
                       c-email:SCREEN-VALUE              IN FRAME fPage5 = STRING(tt-digita.email).
                APPLY "ENTRY":U TO c-email IN FRAME fPage5.
            END.
        END.
        WHEN "desabilitar" THEN DO:
            ASSIGN i-cod-transp:SENSITIVE IN FRAME fPage5 = FALSE    
                   c-email:SENSITIVE      IN FRAME fPage5 = FALSE         
                   bt-sav:SENSITIVE       IN FRAME fPage5 = FALSE          
                   bt-can:SENSITIVE       IN FRAME fPage5 = FALSE
                   i-cod-transp:SCREEN-VALUE         IN FRAME fPage5 = ""     
                   c-nome-transportador:SCREEN-VALUE IN FRAME fPage5 = ""
                   c-email:SCREEN-VALUE              IN FRAME fPage5 = "".
        END.
        OTHERWISE
            RETURN NO-APPLY.
    END CASE.
 
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-email-cc wReport 
PROCEDURE pi-habilita-email-cc :
/*------------------------------------------------------------------------------
  Purpose: Habilitar o campo e-mail cc e carregar com email do usu rio de 
           materiais    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE l-checked AS LOGICAL NO-UNDO.
    
    ASSIGN l-checked = tg-envia-email-cc:CHECKED IN FRAME fPage4.
           c-email-cc:SENSITIVE IN FRAME fPage4 = l-checked.
           
    IF NOT l-checked THEN 
        ASSIGN c-email-cc:SCREEN-VALUE IN FRAME fPage4 = "".
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-email wReport 
PROCEDURE pi-valida-email :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-email  AS CHAR    NO-UNDO.
    DEFINE INPUT  PARAMETER c-origem AS CHAR    NO-UNDO.

    DEFINE VARIABLE regexp   AS CLASS Regex NO-UNDO. 
    DEFINE VARIABLE l-valido AS LOGICAL     NO-UNDO.

/* Valida o sistema, pois ambientes UNIX (TTY) n’o possuem a classe Regex */ 
&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN    
    ASSIGN c-email = UPPER(c-email).

    regexp = NEW Regex("[_a-zA-Z\d\-\.]+@([_a-zA-Z\d\-]+(\.[_a-zA-Z\d\-]+)+)").

    ASSIGN l-valido = regexp:IsMatch(c-email).

    DELETE OBJECT regexp.

    IF NOT l-valido THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW", 
                           INPUT 55139, /* Endereço de do $1 e-mail inv lido!*/ 
                           INPUT c-origem). 
        RETURN "NOK":U.
    END. 
&ENDIF
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE r-tt-digita AS ROWID NO-UNDO.


/*:T** Relatorio ***/
DO ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    {report/rpexa.i}

    /*15/02/2005 - tech1007 - Teste alterado pois RTF nÆo ‚ mais op‡Æo de Destino*/
   IF INPUT FRAME fPage6 rsDestiny = 2 AND
       INPUT FRAME fPage6 rsExecution = 1 THEN DO:
        RUN utp/ut-vlarq.p (INPUT INPUT FRAME fPage6 cFile).
        
        IF RETURN-VALUE = "NOK":U THEN do:
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 73, INPUT "":U).
            APPLY "ENTRY":U to cFile in frame fPage6.
            RETURN error.
        END.
    END.
    
    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */

    /* Valida diretorio origem */
    ASSIGN FILE-INFO:FILENAME = INPUT FRAME fPage4 c-origem.
    IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 4715, /* O diret¢rio &1, nÆo existe! */
                           INPUT INPUT FRAME fPage4 c-origem ).
        APPLY "ENTRY":U TO c-origem IN FRAME fPage4.
        RETURN ERROR.
    END.

    /* Valida diretorio destino */
    ASSIGN FILE-INFO:FILENAME = INPUT FRAME fPage4 c-destino.
    IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 4715, /* O diret¢rio &1, nÆo existe! */
                           INPUT INPUT FRAME fPage4 c-destino ).
        APPLY "ENTRY":U TO c-destino IN FRAME fPage4.
        RETURN ERROR.
    END.

    /* SE ESTIVER MARCADO PARA ENVIAR E-MAIL PARA TRANSPORTADOR */
    IF tg-envia-email-transp:CHECKED IN FRAME fPage4 THEN DO:
        /* Valida e-mail CC*/
        IF tg-envia-email-cc:CHECKED IN FRAME fPage4 THEN DO:
            RUN pi-valida-email(INPUT c-email-cc:SCREEN-VALUE IN FRAME fPage4 ,INPUT "CC":U).
            IF RETURN-VALUE = "NOK":U THEN DO:
                APPLY "ENTRY":U TO c-email-cc IN FRAME fPage4.
                RETURN ERROR.
    
            END.
        END.
    
        /* Valida e-mail Remetente */
        {utp/ut-liter.i "Remetente" * }
        RUN pi-valida-email(INPUT c-remetente:SCREEN-VALUE IN FRAME fPage4 ,INPUT RETURN-VALUE).
        IF RETURN-VALUE = "NOK":U THEN DO:
            APPLY "ENTRY":U TO c-remetente IN FRAME fPage4.
            RETURN ERROR.
        END.
    END.

    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    
    CREATE tt-param.
    ASSIGN tt-param.usuario         = c-seg-usuario
           tt-param.destino         = INPUT FRAME fPage6 rsDestiny
           tt-param.data-exec       = TODAY
           tt-param.hora-exec       = TIME.
    
    IF tt-param.destino = 1 THEN 
        ASSIGN tt-param.arquivo = "":U.
    ELSE IF tt-param.destino = 2 THEN 
        ASSIGN tt-param.arquivo = input frame fPage6 cFile.
    ELSE 
        ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */

     ASSIGN tt-param.cod-estabel        = INPUT FRAME fPage4 c-cod-estabel        
            tt-param.cod-periodo        = INPUT FRAME fPage4 c-period             
            tt-param.it-codigo          = INPUT FRAME fPage4 cb-item              
            tt-param.envia-email-transp = tg-envia-email-transp:CHECKED IN FRAME fPage4
            tt-param.envia-email-cc     = tg-envia-email-cc:CHECKED IN FRAME fPage4    
            tt-param.email-cc           = INPUT FRAME fPage4 c-email-cc           
            tt-param.origem-xml         = INPUT FRAME fPage4 c-origem             
            tt-param.destino-xml        = INPUT FRAME fPage4 c-destino
            tt-param.cod-regiao-ini     = INPUT FRAME fPage2 c-cod-regiao-ini
            tt-param.cod-regiao-fim     = INPUT FRAME fPage2 c-cod-regiao-fim
            tt-param.cod-rota-ini       = INPUT FRAME fPage2 c-cod-rota-ini
            tt-param.cod-rota-fim       = INPUT FRAME fPage2 c-cod-rota-fim
            tt-param.cod-transp-ini     = INPUT FRAME fPage2 i-cod-transp-ini
            tt-param.cod-transp-fim     = INPUT FRAME fPage2 i-cod-transp-fim
            tt-param.tipo-integr        = c-tp-trans
            tt-param.remetente          = INPUT FRAME fPage4 c-remetente
            tt-param.nome-estabel       = INPUT FRAME fPage4 c-nome
            tt-param.desc-item          = INPUT FRAME fPage4 c-desc-item
            tt-param.imp-param          = tg-imp-param:CHECKED IN FRAME fPage6.

            
    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i aqp/aq0326rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

