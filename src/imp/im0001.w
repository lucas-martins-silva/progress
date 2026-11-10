&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-usuar-import NO-UNDO LIKE usuar-import
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
{include/i-prgvrs.i IM0001 2.00.00.015 } /*** "010015" 03/09/2025 17:29:55  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0001 MIM}
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
{include/i_dbvers.i} /*Include de Pr‚-Processadores*/
{utp/ut-glob.i}
{cxbo/bocx00485.i tt-usuar-siscomex}

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0001
&GLOBAL-DEFINE Version        2.00.00.015

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Geral, Siscomex

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

&GLOBAL-DEFINE ttTable        tt-usuar-import
&GLOBAL-DEFINE hDBOTable      bo-usar-import
&GLOBAL-DEFINE DBOTable       usuar-import

&GLOBAL-DEFINE page0KeyFields tt-usuar-import.cod-usuar
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    tt-usuar-import.des-layout-origin-gerc tt-usuar-import.log-permite-alter-cotac-despes tt-usuar-import.log-perm-pto-control-imp ~
                              tt-usuar-import.log-perm-pto-despes-imp tt-usuar-import.log-perm-pto-decla-imp tt-usuar-import.log-perm-tit-antecip 
&GLOBAL-DEFINE page2Fields    c-cod-cnpj-cpf c-format-certif-digital c-cod-arq-certif c-cod-chave-certif c-cod-senha-certif 

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE l-fn-antecip    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-cpf-numerico  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE d-cpf           AS DECIMAL     NO-UNDO.
DEFINE VARIABLE cFile           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE m-cripto        AS MEMPTR      NO-UNDO.
DEFINE VARIABLE m-cripto-arq    AS MEMPTR      NO-UNDO.
DEFINE VARIABLE m-cripto-chave  AS MEMPTR      NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx00485 AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.

ASSIGN l-fn-antecip = CAN-FIND(FIRST funcao
                               WHERE funcao.cd-funcao = "spp-imp-antecip":U
                                 AND funcao.ativo     = YES).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-usuar-import.cod-usuar 
&Scoped-define ENABLED-TABLES tt-usuar-import
&Scoped-define FIRST-ENABLED-TABLE tt-usuar-import
&Scoped-Define ENABLED-OBJECTS btFirst btPrev btNext btLast btGoTo btSearch ~
btAdd btCopy btUpdate btDelete btUndo btCancel btSave btQueryJoins ~
btReportsJoins btExit btHelp c-desc-usuar rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-usuar-import.cod-usuar 
&Scoped-define DISPLAYED-TABLES tt-usuar-import
&Scoped-define FIRST-DISPLAYED-TABLE tt-usuar-import
&Scoped-Define DISPLAYED-OBJECTS c-desc-usuar 

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

DEFINE VARIABLE c-desc-usuar AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Diret¢rio".

DEFINE VARIABLE c-lbl-acomp-embar AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 24 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-87
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 3.75.

DEFINE RECTANGLE RECT-88
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 3.25.

DEFINE VARIABLE tg-valida-dt-efetiva AS LOGICAL INITIAL no 
     LABEL "Manter ordem cronol¢gica do Itiner rio na Efetiva‡Æo dos Pontos" 
     VIEW-AS TOGGLE-BOX
     SIZE 47 BY .83 NO-UNDO.

DEFINE BUTTON bt-chav-cert-digital 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-xml-cert-digital 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-format-certif-digital AS CHARACTER FORMAT "X(5)":U 
     LABEL "Formato Certificado" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-arq-certif AS CHARACTER FORMAT "x(200)" 
     LABEL "Arquivo Certificado" 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-chave-certif AS CHARACTER FORMAT "x(200)" 
     LABEL "Chave Certificado" 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-cnpj-cpf AS CHARACTER FORMAT "X(19)":U 
     LABEL "CNPJ/CPF" 
     VIEW-AS FILL-IN 
     SIZE 20.43 BY .88 DROP-TARGET NO-UNDO.

DEFINE VARIABLE c-cod-senha-certif AS CHARACTER FORMAT "x(60)" 
     LABEL "Senha Certificado" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 6.08.


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
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-usuar-import.cod-usuar AT ROW 3.25 COL 20 COLON-ALIGNED
          LABEL "Usu rio":R17
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     c-desc-usuar AT ROW 3.25 COL 33.14 COLON-ALIGNED NO-LABEL
     rtKeys AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.57 BY 13.29
         FONT 1.

DEFINE FRAME fPage2
     c-cod-cnpj-cpf AT ROW 2.13 COL 23 COLON-ALIGNED HELP
          "CPF/CNPJ do representante legal no portal Siscomex" WIDGET-ID 96
     c-format-certif-digital AT ROW 3.13 COL 23 COLON-ALIGNED HELP
          "Indicador - Inteiro Certificado" WIDGET-ID 94
     bt-xml-cert-digital AT ROW 4.17 COL 66 HELP
          "Escolha o arquivo de chave do certificado" WIDGET-ID 74
     c-cod-arq-certif AT ROW 4.21 COL 23 COLON-ALIGNED WIDGET-ID 88 PASSWORD-FIELD 
     bt-chav-cert-digital AT ROW 5.17 COL 66 HELP
          "Escolha o arquivo de certificado" WIDGET-ID 76
     c-cod-chave-certif AT ROW 5.21 COL 23 COLON-ALIGNED WIDGET-ID 90 PASSWORD-FIELD 
     c-cod-senha-certif AT ROW 6.21 COL 23 COLON-ALIGNED WIDGET-ID 50 PASSWORD-FIELD 
     "Certificado" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 1.08 COL 3 WIDGET-ID 60
     RECT-40 AT ROW 1.42 COL 2 WIDGET-ID 54
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.43 ROW 6.17
         SIZE 87.43 BY 7.58 WIDGET-ID 200.

DEFINE FRAME fPage1
     tt-usuar-import.log-permite-alter-cotac-despes AT ROW 1.67 COL 4.57 WIDGET-ID 20
          LABEL "Permite altera‡Æo na cota‡Æo de despesas controladas":L60
          VIEW-AS TOGGLE-BOX
          SIZE 41 BY .71
     tt-usuar-import.log-perm-tit-antecip AT ROW 2.67 COL 4.57 HELP
          "" WIDGET-ID 12
          LABEL "Permite gerar T¡tulo de Antecipa‡Æo no APB"
          VIEW-AS TOGGLE-BOX
          SIZE 40 BY .83
     btFile AT ROW 3.58 COL 80 WIDGET-ID 34
     tt-usuar-import.des-layout-origin-gerc AT ROW 3.67 COL 20 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 58 BY .88
     tt-usuar-import.log-perm-pto-control-imp AT ROW 6.04 COL 4.43 HELP
          "Identifica se o usu rio tem permissÆo para alterar dados do Ponto de Controle no Acompanhamento" WIDGET-ID 4
          LABEL "Permite Alterar Ponto de Controle"
          VIEW-AS TOGGLE-BOX
          SIZE 35 BY .83
     tt-usuar-import.log-perm-pto-decla-imp AT ROW 6.04 COL 40 help
          "Identifica se o usu rio tem permissÆo para alterar dados das Declara‡äes/Comunica‡äes Acompanhamento" WIDGET-ID 6
          LABEL "Permite Alterar Ponto de Controle da Declara‡Æo/Comunica‡Æo"
          VIEW-AS TOGGLE-BOX
          SIZE 47 BY .83
     tt-usuar-import.log-perm-pto-despes-imp AT ROW 7.04 COL 4.43 HELP
          "Identifica se o usu rio tem permissÆo para alterar dados das Despesas no Acompanhamento" WIDGET-ID 8
          LABEL "Permite Alterar Ponto de Controle da Despesa"
          VIEW-AS TOGGLE-BOX
          SIZE 35 BY .83
     tg-valida-dt-efetiva AT ROW 7.04 COL 40 WIDGET-ID 14
     c-lbl-acomp-embar AT ROW 5 COL 4.57 NO-LABEL WIDGET-ID 10
     RECT-87 AT ROW 1.25 COL 1.86 WIDGET-ID 26
     RECT-88 AT ROW 5.25 COL 2 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.43 ROW 6.17
         SIZE 87.43 BY 7.67
         FONT 1 WIDGET-ID 300.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-usuar-import T "?" NO-UNDO mgcex usuar-import
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
         HEIGHT             = 13.33
         WIDTH              = 91.14
         MAX-HEIGHT         = 18.42
         MAX-WIDTH          = 125.72
         VIRTUAL-HEIGHT     = 18.42
         VIRTUAL-WIDTH      = 125.72
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
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN tt-usuar-import.cod-usuar IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN c-lbl-acomp-embar IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN tt-usuar-import.des-layout-origin-gerc IN FRAME fPage1
   ALIGN-R                                                              */
/* SETTINGS FOR TOGGLE-BOX tt-usuar-import.log-perm-pto-control-imp IN FRAME fPage1
   EXP-LABEL EXP-HELP                                                   */
/* SETTINGS FOR TOGGLE-BOX tt-usuar-import.log-perm-pto-decla-imp IN FRAME fPage1
   EXP-LABEL EXP-HELP                                                   */
/* SETTINGS FOR TOGGLE-BOX tt-usuar-import.log-perm-pto-despes-imp IN FRAME fPage1
   EXP-LABEL EXP-HELP                                                   */
/* SETTINGS FOR TOGGLE-BOX tt-usuar-import.log-perm-tit-antecip IN FRAME fPage1
   EXP-LABEL EXP-HELP                                                   */
/* SETTINGS FOR TOGGLE-BOX tt-usuar-import.log-permite-alter-cotac-despes IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage2
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


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-chav-cert-digital
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-chav-cert-digital wMaintenance
ON CHOOSE OF bt-chav-cert-digital IN FRAME fPage2
DO:
    def var l-ok  as logical no-undo.

    assign c-cod-chave-certif = replace(input frame fPage2 c-cod-chave-certif, "/", "~\").

    IF c-format-certif-digital:SCREEN-VALUE IN FRAME fPage2 = "PFX":U THEN 
        SYSTEM-DIALOG GET-FILE cFile
           FILTERS "*.pfx" "*.pfx",
                   "*.pem" "*.pem",      
                   "*.*" "*.*"
           DEFAULT-EXTENSION "pem":U
           INITIAL-DIR "modelos":U 
           MUST-EXIST
           USE-FILENAME
           UPDATE l-ok.
    ELSE
        SYSTEM-DIALOG GET-FILE cFile
           FILTERS "*.pem" "*.pem",      
                   "*.pfx" "*.pfx",
                   "*.*" "*.*"
           DEFAULT-EXTENSION "pfx":U
           INITIAL-DIR "modelos":U 
           MUST-EXIST
           USE-FILENAME
           UPDATE l-ok.

    if  l-ok = yes THEN DO:
        assign c-cod-chave-certif:screen-value in frame fPage2 = replace(cFile, "~\", "/").
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-xml-cert-digital
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-xml-cert-digital wMaintenance
ON CHOOSE OF bt-xml-cert-digital IN FRAME fPage2
DO:
  def var l-ok  as logical no-undo.

    assign c-cod-arq-certif = replace(input frame fPage2 c-cod-arq-certif, "/":U, "~\":U).

    IF c-format-certif-digital:SCREEN-VALUE IN FRAME fPage2 = "PEM":U THEN
        SYSTEM-DIALOG GET-FILE cFile
        FILTERS "*.pem" "*.pem",
                "*.pfx" "*.pfx",               
               "*.*" "*.*"
        DEFAULT-EXTENSION "pem":U
        INITIAL-DIR "modelos":U
        MUST-EXIST
        USE-FILENAME
        UPDATE l-ok.
    ELSE 
        SYSTEM-DIALOG GET-FILE cFile
        FILTERS "*.pfx" "*.pfx",               
                "*.pem" "*.pem",
                "*.*" "*.*"
        DEFAULT-EXTENSION "pem":U
        INITIAL-DIR "modelos":U 
        MUST-EXIST
        USE-FILENAME
        UPDATE l-ok.

    
    if  l-ok = yes THEN DO:
        assign c-cod-arq-certif:screen-value in frame {&frame-name}  = replace(cFile, "~\":U, "/":U).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
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


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wMaintenance
ON CHOOSE OF btFile IN FRAME fPage1
DO:
    DEFINE VARIABLE c-dir       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-cancelado AS LOGICAL   NO-UNDO.

    ASSIGN c-dir = replace(input frame fpage1 tt-usuar-import.des-layout-origin-gerc, "/", "~\").

    {utp/ut-liter.i "Selecione_o_diret¢rio"}
    RUN utp/ut-dir.p(INPUT RETURN-VALUE,
                     OUTPUT c-dir,
                     OUTPUT l-cancelado).

    IF NOT l-cancelado THEN DO:
        IF LENGTH (c-dir) > 3  and substr(c-dir, length(c-dir), 1) <> "~\" THEN DO:
            ASSIGN tt-usuar-import.des-layout-origin-gerc:screen-value = (c-dir + "~\").
        END.
        ELSE DO:
           ASSIGN tt-usuar-import.des-layout-origin-gerc:screen-value = c-dir.
        END.
    END.
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
    APPLY "LEAVE":U TO c-cod-cnpj-cpf IN FRAME fPage2.
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
     {method/zoomreposition.i &ProgramZoom="cxzoom/z01cx336.w"} 
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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME c-cod-cnpj-cpf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cnpj-cpf wMaintenance
ON ENTRY OF c-cod-cnpj-cpf IN FRAME fPage2 /* CNPJ/CPF */
DO:
    ASSIGN c-cod-cnpj-cpf:FORMAT IN FRAME fPage2 = "x(19)":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cnpj-cpf wMaintenance
ON LEAVE OF c-cod-cnpj-cpf IN FRAME fPage2 /* CNPJ/CPF */
DO:
    
    ASSIGN c-cod-cnpj-cpf:FORMAT IN FRAME fPage2 = "x(19)":U
           c-cod-cnpj-cpf:SCREEN-VALUE IN FRAME fPage2 = REPLACE(c-cod-cnpj-cpf:SCREEN-VALUE IN FRAME fPage2,'.','')
           c-cod-cnpj-cpf:SCREEN-VALUE IN FRAME fPage2 = REPLACE(c-cod-cnpj-cpf:SCREEN-VALUE IN FRAME fPage2,'/','')
           c-cod-cnpj-cpf:SCREEN-VALUE IN FRAME fPage2 = REPLACE(c-cod-cnpj-cpf:SCREEN-VALUE IN FRAME fPage2,'-','')
           d-cpf = DEC(c-cod-cnpj-cpf:SCREEN-VALUE IN FRAME fPage2) NO-ERROR.
    IF NOT ERROR-STATUS:ERROR THEN
        ASSIGN l-cpf-numerico = YES.
    ELSE
        ASSIGN l-cpf-numerico = NO.

    IF c-cod-cnpj-cpf:FORMAT IN FRAME fPage2 = "x(19)":U THEN
        IF LENGTH(c-cod-cnpj-cpf:SCREEN-VALUE IN FRAME fPage2) = 11 AND l-cpf-numerico THEN
            ASSIGN c-cod-cnpj-cpf:FORMAT IN FRAME fPage2 = param-global.formato-id-pessoal NO-ERROR.
        ELSE
            IF LENGTH(c-cod-cnpj-cpf:SCREEN-VALUE IN FRAME fPage2) = 14 THEN
                ASSIGN c-cod-cnpj-cpf:FORMAT IN FRAME fPage2 = param-global.formato-id-federal NO-ERROR.
                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME tt-usuar-import.cod-usuar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-usuar-import.cod-usuar wMaintenance
ON F5 OF tt-usuar-import.cod-usuar IN FRAME fpage0 /* Usu rio */
DO: 
    ASSIGN l-implanta = NO.
    {include/zoomvar.i &prog-zoom = unzoom/z01un178.w
                       &campo=tt-usuar-import.cod-usuar
                       &campozoom=cod_usuario
                       &campo2=c-desc-usuar
                       &campozoom2=nom_usuario
                       &frame = "fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-usuar-import.cod-usuar wMaintenance
ON LEAVE OF tt-usuar-import.cod-usuar IN FRAME fpage0 /* Usu rio */
DO:
    DEFINE VARIABLE c-desc AS CHARACTER  NO-UNDO.

    RUN returnNameUsuar IN {&hDBOTable} (INPUT INPUT FRAME fPage0 tt-usuar-import.cod-usuar,
                                         OUTPUT c-desc).

    ASSIGN  c-desc-usuar:SCREEN-VALUE IN FRAME fPage0 = c-desc.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-usuar-import.cod-usuar wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-usuar-import.cod-usuar IN FRAME fpage0 /* Usu rio */
DO:
  APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

tt-usuar-import.cod-usuar:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

{utp/ut-liter.i "Acompanhamento do Embarque/DI"}
ASSIGN c-lbl-acomp-embar:SCREEN-VALUE IN FRAME fPage1 = RETURN-VALUE.

{utp/ut-liter.i "Permite Alterar Ponto de Controle"}
ASSIGN tt-usuar-import.log-perm-pto-control-imp:LABEL IN FRAME fPage1 = RETURN-VALUE.
{utp/ut-liter.i "Permite Alterar Ponto de Controle da Despesa"}
ASSIGN tt-usuar-import.log-perm-pto-despes-imp:LABEL IN FRAME fPage1 = RETURN-VALUE.
{utp/ut-liter.i "Permite Alterar Ponto de Controle da Declara‡Æo/Comunica‡Æo"}
ASSIGN tt-usuar-import.log-perm-pto-decla-imp:LABEL IN FRAME fPage1 = RETURN-VALUE.

{utp/ut-liter.i "Permite gerar T¡tulo de Antecipa‡Æo no APB"}
ASSIGN tt-usuar-import.log-perm-tit-antecip:LABEL IN FRAME fPage1 = RETURN-VALUE.
{utp/ut-liter.i Manter_ordem_cronol¢gica_do_Itiner rio_na_Efetiva‡Æo_dos_Pontos * r}
ASSIGN tg-valida-dt-efetiva:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).
{utp/ut-liter.i Layout_Gerencial_Import * r}
ASSIGN tt-usuar-import.des-layout-origin-gerc:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).

{utp/ut-liter.i "Permite Alterar Pto Contr no Acomp do Embarque?"}
ASSIGN tt-usuar-import.log-perm-pto-control-imp:HELP IN FRAME fPage1 = RETURN-VALUE.
{utp/ut-liter.i "Permite Alterar Pto Contr das Despesas no Acomp do Embarque?"}
ASSIGN tt-usuar-import.log-perm-pto-despes-imp:HELP IN FRAME fPage1 = RETURN-VALUE.
{utp/ut-liter.i "Permite Alterar Pto Contr das Decl/Com no Acomp do Embarque?"}
ASSIGN tt-usuar-import.log-perm-pto-decla-imp:HELP IN FRAME fPage1 = RETURN-VALUE.
{utp/ut-liter.i "Permite gerar T¡tulo de Antecipa‡Æo no APB?"}
ASSIGN tt-usuar-import.log-perm-tit-antecip:HELP IN FRAME fPage1 = RETURN-VALUE.
{utp/ut-liter.i Manter_ordem_cronol¢gica_do_Itiner rio_na_Efetiva‡Æo_dos_Pontos? * r}
ASSIGN tg-valida-dt-efetiva:HELP IN FRAME fPage1 = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Informar_o_diret¢rio_do_Layout_Gerencial_de_Importa‡Æo"}
ASSIGN tt-usuar-import.des-layout-origin-gerc:HELP IN FRAME fPage1 = RETURN-VALUE.

FIND FIRST param-global NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateFields wMaintenance 
PROCEDURE afterCreateFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: <none> 
  Notes:       
------------------------------------------------------------------------------*/
  /* Esta l¢gica deve ser mantida at‚ que o inicial do campo seja ajustado no dicion rio */
  /* Atualmente esse campo est  sendo criado com o conte£do inicial igual a "no". */
  IF tt-usuar-import.des-layout-origin-gerc = "no":U THEN
     ASSIGN tt-usuar-import.des-layout-origin-gerc = "".

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose: Elimina‡Æo de handles utilizados    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  VALID-HANDLE(h-bocx00485) then do:
        DELETE PROCEDURE h-bocx00485.
        ASSIGN h-bocx00485 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisableFields wMaintenance 
PROCEDURE afterDisableFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DISABLE btFile WITH FRAME fPage1.
    RUN pi-verifica-fn-antecip (INPUT NO,
                                INPUT NO).

    ASSIGN tg-valida-dt-efetiva:SENSITIVE IN FRAME fPage1 = NO.

    /* Siscomex  */
    DISABLE bt-chav-cert-digital WITH FRAME fPage2.
    DISABLE bt-xml-cert-digital  WITH FRAME fPage2.

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
  /* Esta l¢gica deve ser mantida at‚ que o inicial do campo seja ajustado no dicion rio */
  /* Atualmente esse campo est  sendo criado com o conte£do inicial igual a "no". */
  IF tt-usuar-import.des-layout-origin-gerc = "no":U THEN
     ASSIGN tt-usuar-import.des-layout-origin-gerc:SCREEN-VALUE IN FRAME fPage1 = "".

  RUN pi-verifica-fn-antecip (INPUT NO,
                              INPUT NO).
  IF  AVAIL tt-usuar-import THEN 
      ASSIGN tg-valida-dt-efetiva:CHECKED IN FRAME fPage1 = tt-usuar-import.log-livre-1.

  APPLY "LEAVE":U TO tt-usuar-import.cod-usuar IN FRAME fPage0.

  /* Brasil */
  IF i-pais-impto-usuario = 1 THEN DO:
      RUN piBuscaUsuarSiscomex.
  END.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenance 
PROCEDURE afterEnableFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    ENABLE btFile WITH FRAME fPage1.

    RUN pi-verifica-fn-antecip (INPUT NO,
                                INPUT YES).

    ASSIGN tg-valida-dt-efetiva:SENSITIVE IN FRAME fPage1 = YES
           tt-usuar-import.des-layout-origin-gerc:SENSITIVE IN FRAME fPage1 = YES.

    /* Siscomex  */
    ENABLE bt-chav-cert-digital WITH FRAME fPage2.
    ENABLE bt-xml-cert-digital  WITH FRAME fPage2.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-verifica-fn-antecip (INPUT NO,
                                INPUT NO).

    IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
        HIDE FRAME fPage2.
    END.

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
    IF i-pais-impto-usuario = 1 THEN
        RUN piSalvaUsuarSiscomex IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenance 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose: Inicializa‡Æo de campos de tela    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN c-format-certif-digital:LIST-ITEMS in frame fPage2 = {cxinc/i03cx00485.i 03}.

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
    DEFINE VARIABLE i-cont        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l-erro-cpf    AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-cnpj-valido AS CHARACTER   NO-UNDO.
   
    ASSIGN INPUT FRAME fPage2 c-cod-cnpj-cpf.
    
    DO i-cont = 1 TO LENGTH(c-cod-cnpj-cpf):
        IF (ASC(SUBSTR(c-cod-cnpj-cpf,i-cont,1)) >= 48   AND       /*  48  = 0  */
            ASC(SUBSTR(c-cod-cnpj-cpf,i-cont,1)) <= 57)  OR        /*  57  = 9  */
           (ASC(SUBSTR(c-cod-cnpj-cpf,i-cont,1)) >= 45   AND       /*  45  = -    46  =  .   */
            ASC(SUBSTR(c-cod-cnpj-cpf,i-cont,1)) <= 47)  OR        /*  47  = /  */
           (ASC(SUBSTR(c-cod-cnpj-cpf,i-cont,1)) >= 65   AND       /*  65  = A  */
            ASC(SUBSTR(c-cod-cnpj-cpf,i-cont,1)) <= 90)  OR        /*  90  = Z  */
           (ASC(SUBSTR(c-cod-cnpj-cpf,i-cont,1)) >= 97   AND       /*  97  = a  */
            ASC(SUBSTR(c-cod-cnpj-cpf,i-cont,1)) <= 122) THEN      /*  122 = z  */
            ASSIGN c-cnpj-valido = c-cnpj-valido + substr(c-cod-cnpj-cpf,i-cont,1).
        ELSE
            ASSIGN l-erro-cpf = YES.
    END.
    
    IF l-erro-cpf THEN DO:
        {utp/ut-liter.i CNPJ/CPF_referente_a_integra‡Æo_Siscomex * }  
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 55900, 
                           INPUT RETURN-VALUE).
        APPLY "ENTRY":U TO c-cod-cnpj-cpf IN FRAME fPage2.
        RETURN "NOK":U.
    END.

    IF AVAIL tt-usuar-import THEN
        ASSIGN tt-usuar-import.log-livre-1                = tg-valida-dt-efetiva:CHECKED IN FRAME fPage1.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
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
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE c-cod-usuar LIKE {&ttTable}.cod-usuar NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-cod-usuar  AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 13 BY 0.88
        btGoToOK          AT ROW 2.63 COL 2.14 
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Usu rio de Importa‡Æo" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
        
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-cod-usuar.
        
        RUN goToKey IN {&hDBOTable} (INPUT c-cod-usuar).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Usu rio_de_Importa‡Æo" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-cod-usuar btGoToOK btGoToCancel 
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
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "cxbo/bocx336.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx336.p YES}
        {btb/btb008za.i2 cxbo/bocx336.p '' {&hDBOTable}}
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-bocx00485) OR
       h-bocx00485:TYPE <> "PROCEDURE":U OR
       h-bocx00485:FILE-NAME <> "cxbo/bocx00485.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx00485.p YES}
        {btb/btb008za.i2 cxbo/bocx00485.p '' h-bocx00485}
    END.
    
    RUN openQueryStatic IN h-bocx00485 (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-fn-antecip wMaintenance 
PROCEDURE pi-verifica-fn-antecip :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-hidden    AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pl-sensitive AS LOGICAL NO-UNDO.

    IF i-pais-impto-usuario <> 1
    OR NOT l-fn-antecip THEN
        ASSIGN tt-usuar-import.log-perm-tit-antecip:HIDDEN IN FRAME fPage1    = NOT pl-hidden
               tt-usuar-import.log-perm-tit-antecip:SENSITIVE IN FRAME fPage1 = NOT pl-sensitive.
    ELSE
        ASSIGN tt-usuar-import.log-perm-tit-antecip:HIDDEN IN FRAME fPage1    = pl-hidden
               tt-usuar-import.log-perm-tit-antecip:SENSITIVE IN FRAME fPage1 = pl-sensitive.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaUsuarSiscomex wMaintenance 
PROCEDURE piBuscaUsuarSiscomex :
/*------------------------------------------------------------------------------
  Purpose: Busca informa‡äes adicionais do Siscomex    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE mSenhaDecode     AS MEMPTR NO-UNDO.
    DEFINE VARIABLE mArqCertDecode   AS MEMPTR NO-UNDO.
    DEFINE VARIABLE mChaveCertDecode AS MEMPTR NO-UNDO.

    RUN goToKey IN h-bocx00485 (INPUT tt-usuar-import.cod-usuar).

    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getRecord IN h-bocx00485 (OUTPUT TABLE tt-usuar-siscomex).
    END.
    ELSE DO:
        RUN getDefaults IN h-bocx00485 (OUTPUT TABLE tt-usuar-siscomex).
    END.

    FOR FIRST tt-usuar-siscomex:
        IF tt-usuar-siscomex.cod-senha-certif <> "":U THEN
            ASSIGN mSenhaDecode = BASE64-DECODE(tt-usuar-siscomex.cod-senha-certif).
        ELSE 
            ASSIGN mSenhaDecode = ?.

        IF tt-usuar-siscomex.cod-chave-certif <> "":U THEN
            ASSIGN mChaveCertDecode = BASE64-DECODE(tt-usuar-siscomex.cod-chave-certif).
        ELSE 
            ASSIGN mChaveCertDecode = ?.

        IF tt-usuar-siscomex.cod-arq-certif <> "":U THEN
            ASSIGN mArqCertDecode = BASE64-DECODE(tt-usuar-siscomex.cod-arq-certif).
        ELSE 
            ASSIGN mArqCertDecode = ?.

        ASSIGN c-cod-cnpj-cpf:SCREEN-VALUE          IN FRAME fPage2 = ""
               c-cod-cnpj-cpf:FORMAT                IN FRAME fPage2 = "x(19)":U
               c-cod-cnpj-cpf:SCREEN-VALUE          IN FRAME fPage2 = tt-usuar-siscomex.cod-cnpj-cpf
               c-format-certif-digital:SCREEN-VALUE IN FRAME fPage2 = {cxinc/i03cx00485.i 04 tt-usuar-siscomex.idi-format-certif-digital} 
               c-cod-arq-certif:SCREEN-VALUE        IN FRAME fPage2 = IF STRING(mArqCertDecode) <> "?":U THEN STRING(mArqCertDecode) ELSE tt-usuar-siscomex.cod-arq-certif           
               c-cod-chave-certif:SCREEN-VALUE      IN FRAME fPage2 = IF STRING(mChaveCertDecode) <> "?":U THEN STRING(mChaveCertDecode) ELSE tt-usuar-siscomex.cod-chave-certif
               c-cod-senha-certif:SCREEN-VALUE      IN FRAME fPage2 = IF STRING(mSenhaDecode) <> "?":U THEN STRING(mSenhaDecode) ELSE tt-usuar-siscomex.cod-senha-certif.           

    END.
    
    APPLY "LEAVE":U TO c-cod-cnpj-cpf IN FRAME fPage2.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSalvaUsuarSiscomex wMaintenance 
PROCEDURE piSalvaUsuarSiscomex :
/*------------------------------------------------------------------------------
  Purpose: Salva informa‡äes adicionais do Siscomex    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-formato  AS CHARACTER   NO-UNDO.
    
    ASSIGN c-formato = c-format-certif-digital:SCREEN-VALUE IN FRAME fPage2.

    FIND FIRST tt-usuar-siscomex NO-ERROR.

    ASSIGN tt-usuar-siscomex.cod-usuar                 = tt-usuar-import.cod-usuar
           tt-usuar-siscomex.cod-cnpj-cpf              = c-cod-cnpj-cpf:SCREEN-VALUE  IN FRAME fPage2 
           tt-usuar-siscomex.idi-format-certif-digital = {cxinc/i03cx00485.i 06 c-formato}.
  
    IF c-cod-senha-certif:SCREEN-VALUE  IN FRAME fPage2 <> "":U AND
       c-cod-senha-certif:SCREEN-VALUE  IN FRAME fPage2 <> "?":U THEN DO:
        SET-SIZE (m-cripto)     = LENGTH(c-cod-senha-certif:SCREEN-VALUE IN FRAME fPage2) + 1.
        PUT-STRING(m-cripto, 1) = c-cod-senha-certif:SCREEN-VALUE  IN FRAME fPage2.
        ASSIGN tt-usuar-siscomex.cod-senha-certif           = BASE64-ENCODE(m-cripto).
        SET-SIZE(m-cripto) = 0.
    END.
    ELSE
        ASSIGN tt-usuar-siscomex.cod-senha-certif = "":U.

    IF c-cod-arq-certif:SCREEN-VALUE  IN FRAME fPage2 <> "":U AND
       c-cod-arq-certif:SCREEN-VALUE  IN FRAME fPage2 <> "?":U THEN DO:
        SET-SIZE (m-cripto-arq)     = LENGTH(c-cod-arq-certif:SCREEN-VALUE IN FRAME fPage2) + 1.
        PUT-STRING(m-cripto-arq, 1) = c-cod-arq-certif:SCREEN-VALUE  IN FRAME fPage2.
        ASSIGN tt-usuar-siscomex.cod-arq-certif           = BASE64-ENCODE(m-cripto-arq).
        SET-SIZE(m-cripto-arq) = 0.
    END.
    ELSE
        ASSIGN tt-usuar-siscomex.cod-arq-certif = "":U.

    IF c-cod-chave-certif:SCREEN-VALUE  IN FRAME fPage2 <> "":U AND
       c-cod-chave-certif:SCREEN-VALUE  IN FRAME fPage2 <> "?":U THEN DO:
        SET-SIZE (m-cripto-chave)     = LENGTH(c-cod-chave-certif:SCREEN-VALUE IN FRAME fPage2) + 1.
        PUT-STRING(m-cripto-chave, 1) = c-cod-chave-certif:SCREEN-VALUE  IN FRAME fPage2.
        ASSIGN tt-usuar-siscomex.cod-chave-certif           = BASE64-ENCODE(m-cripto-chave).
        SET-SIZE(m-cripto-chave) = 0.
    END.
    ELSE
        ASSIGN tt-usuar-siscomex.cod-chave-certif = "":U.

    IF i-pais-impto-usuario = 1 THEN
        RUN piEnviaUsuarSiscomex IN {&hDBOTable} (INPUT TABLE tt-usuar-siscomex).
                                                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

