&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttAmostraOleo NO-UNDO LIKE mao-amostra-oleo
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttRestdoEnsaio NO-UNDO LIKE mao-restdo-ensaio
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AO0301 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ao0301 MAO}
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
&GLOBAL-DEFINE Program          AO0301
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Ensaios

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        YES
&GLOBAL-DEFINE CopyParent       YES
&GLOBAL-DEFINE UpdateParent     YES
&GLOBAL-DEFINE DeleteParent     YES

&GLOBAL-DEFINE AddSon1          no
&GLOBAL-DEFINE CopySon1         no
&GLOBAL-DEFINE UpdateSon1       no
&GLOBAL-DEFINE DeleteSon1       no

&GLOBAL-DEFINE AddSon2          no
&GLOBAL-DEFINE CopySon2         no
&GLOBAL-DEFINE UpdateSon2       no
&GLOBAL-DEFINE DeleteSon2       no

&GLOBAL-DEFINE ttParent          ttAmostraOleo
&GLOBAL-DEFINE hDBOParent        hAmostraOleo
&GLOBAL-DEFINE DBOParentTable    mao-amostra-oleo
&GLOBAL-DEFINE DBOParentDestroy  yes

&GLOBAL-DEFINE ttSon1            ttRestdoEnsaio
&GLOBAL-DEFINE hDBOSon1          hRestdoEnsaio
&GLOBAL-DEFINE DBOSon1Table      mao-restdo-ensaio
&GLOBAL-DEFINE DBOSon1Destroy    yes 

&GLOBAL-DEFINE ttSon2           
&GLOBAL-DEFINE hDBOSon2         
&GLOBAL-DEFINE DBOSon2Table     
&GLOBAL-DEFINE DBOSon2Destroy   

&GLOBAL-DEFINE page0Fields      ttAmostraOleo.ep-codigo ttAmostraOleo.num-docto ttAmostraOleo.cod-amostra-fisic ~
                                ttAmostraOleo.num-amostra-oleo ttAmostraOleo.cod-eqpto ~
                                ttAmostraOleo.cod-tip-mater ttAmostraOleo.cod-comptmento ~
                                ttAmostraOleo.dat-amostra ttAmostraOleo.val-quant ttAmostraOleo.hra-amostra   

&GLOBAL-DEFINE page1Browse      brSon1
&GLOBAL-DEFINE page2Browse      

/* Parameters Definitions ---                                           */
DEFINE VARIABLE cDescDocto   AS CHARACTER format "x(30)" NO-UNDO.
DEFINE VARIABLE cDescEqpto   AS CHARACTER format "x(30)" NO-UNDO.
DEFINE VARIABLE cDescMatl    AS CHARACTER format "x(30)" NO-UNDO.
DEFINE VARIABLE cDescCompto  AS CHARACTER format "x(30)" NO-UNDO.
DEFINE VARIABLE cDescEnsaio  AS CHARACTER format "x(30)" NO-UNDO.
DEFINE VARIABLE cDescEstado  AS CHARACTER format "x(30)" NO-UNDO. 
DEFINE VARIABLE cModel       AS CHARACTER format "x(30)" NO-UNDO.
DEFINE VARIABLE cMatl        AS CHARACTER format "x(30)" NO-UNDO.
DEFINE VARIABLE cCompto      AS CHARACTER format "x(30)" NO-UNDO.
/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEqpto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOTpMatl    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOCompto    AS HANDLE NO-UNDO.
DEFINE VARIABLE c-hora-browse AS CHARACTER  NO-UNDO.


/** Classifica‡Æo **/
def temp-table ttVisao no-undo
    field dimensao  as character
    field sequencia as integer
    index codigo is primary unique sequencia.

/*Versäes EMS MNT */
{cdp/cdcfgmnt.i}
/*Unidade de Neg¢cio*/
{cdp/cd9911.i}

/** Sele‡Æo **/
define temp-table ttSelecao no-undo
     /** Faixas **/
     field empresa-ini    like mab-eqpto.ep-codigo
     field empresa-fim    like mab-eqpto.ep-codigo
     field equipto-ini    like mab-eqpto.cod-eqpto
     field equipto-fim    like mab-eqpto.cod-eqpto
     field docto-ini      like mao-amostra-oleo.num-amostra-oleo
     field docto-fim      like mao-amostra-oleo.num-amostra-oleo
     field modelo-ini     like mab-eqpto.cod-model
     field modelo-fim     like mab-eqpto.cod-model
     field amostra-ini    like mao-amostra-oleo.cod-amostra-fisic 
     field amostra-fim    like mao-amostra-oleo.cod-amostra-fisic 
     field data-ini       like mao-amostra-oleo.dat-amostra
     field data-fim       like mao-amostra-oleo.dat-amostra
     field compto-ini     like mao-amostra-oleo.cod-comptmento
     field compto-fim     like mao-amostra-oleo.cod-comptmento
     field tp-mater-ini   like mao-amostra-oleo.cod-tip-mater
     field tp-mater-fim   like mao-amostra-oleo.cod-tip-mater
     field lubrific-ini   like mao-amostra-oleo.num-docto
     field lubrific-fim   like mao-amostra-oleo.num-docto
     field tag-ini        like mab-eqpto.cd-tag
     field tag-fim        like mab-eqpto.cd-tag
     field cc-ini         like mab-histor-ativid.cc-codigo
     field cc-fim         like mab-histor-ativid.cc-codigo
     /** Parƒmetros **/
     field lPadrao          as logical
     field lNPadrao         as logical
     field lData            as logical
     field lTexto           as logical
     field lNumerico        as logical
     field lTabela          as logical
     field lAprovado        as logical
     field lReprovado       as logical
     field lPendente        as logical
     field lAprovUsuar      as logical
     field lAmostAprovado   as logical
     field lAmostReprovado  as logical
     field lAmostPendente   as logical
     field lAmostAprovUsuar as logical
    &IF DEFINED(bf_mnt_ems206b) &THEN
     FIELD unid-negoc-ini   AS CHARACTER FORMAT "x(3)"
     FIELD unid-negoc-fim   AS CHARACTER FORMAT "x(3)"
    &ENDIF
    
    .

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
&Scoped-define INTERNAL-TABLES ttRestdoEnsaio

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 ttRestdoEnsaio.cod-ensaio ~
fnDescEnsaio  (ttRestdoEnsaio.cod-ensaio  ) @ cDescEnsaio ~
ttRestdoEnsaio.log-padrao ttRestdoEnsaio.num-tabela ~
ttRestdoEnsaio.des-val-min ttRestdoEnsaio.des-val-max ~
ttRestdoEnsaio.des-val-restdo ttRestdoEnsaio.dat-restdo-ensaio ~
ttRestdoEnsaio.hra-restdo-ensaio @ c-hora-browse ~
fnEstado (ttRestdoEnsaio.idi-estado-ensaio ) @ cDescEstado 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH ttRestdoEnsaio NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH ttRestdoEnsaio NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 ttRestdoEnsaio
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 ttRestdoEnsaio


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttAmostraOleo.num-docto ~
ttAmostraOleo.ep-codigo ttAmostraOleo.cod-eqpto ttAmostraOleo.cod-tip-mater ~
ttAmostraOleo.cod-comptmento ttAmostraOleo.num-amostra-oleo ~
ttAmostraOleo.dat-amostra ttAmostraOleo.hra-amostra ttAmostraOleo.val-quant ~
ttAmostraOleo.cod-amostra-fisic 
&Scoped-define ENABLED-TABLES ttAmostraOleo
&Scoped-define FIRST-ENABLED-TABLE ttAmostraOleo
&Scoped-Define ENABLED-OBJECTS fiDescEqpto btFirst btPrev btNext btLast ~
btGoTo btSearch btAdd btCopy btUpdate btDelete btQueryJoins btReportsJoins ~
btExit btHelp fiEstado fiDescMatl fiDescCompto btManutencao rtParent ~
rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttAmostraOleo.num-docto ~
ttAmostraOleo.ep-codigo ttAmostraOleo.cod-eqpto ttAmostraOleo.cod-tip-mater ~
ttAmostraOleo.cod-comptmento ttAmostraOleo.num-amostra-oleo ~
ttAmostraOleo.dat-amostra ttAmostraOleo.hra-amostra ttAmostraOleo.val-quant ~
ttAmostraOleo.cod-amostra-fisic 
&Scoped-define DISPLAYED-TABLES ttAmostraOleo
&Scoped-define FIRST-DISPLAYED-TABLE ttAmostraOleo
&Scoped-Define DISPLAYED-OBJECTS fiDescEqpto fiEstado fiDescMatl ~
fiDescCompto 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescEnsaio wMasterDetail 
FUNCTION fnDescEnsaio RETURNS CHARACTER
  ( pEnsaio as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEstado wMasterDetail 
FUNCTION fnEstado RETURNS CHARACTER
  ( pEstado as int )  FORWARD.

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
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       MENU-ITEM m_Gera         LABEL "&Manuten‡Æo_Ensaios" ACCELERATOR "CTRL-G"
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

DEFINE BUTTON btManutencao 
     IMAGE-UP FILE "image/im-gera.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-gera.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Manuten‡Æo dos Resultados do Ensaio"
     FONT 4.

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

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image/im-mod":U
     IMAGE-INSENSITIVE FILE "image/ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE fiDescCompto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescEqpto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescMatl AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE fiEstado AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btDeleteSon1 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btEnsaios 
     LABEL "&Ensaios" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      ttRestdoEnsaio SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      ttRestdoEnsaio.cod-ensaio FORMAT "x(8)":U WIDTH 8
      fnDescEnsaio  (ttRestdoEnsaio.cod-ensaio  ) @ cDescEnsaio COLUMN-LABEL "Descri‡Æo"
            WIDTH 30
      ttRestdoEnsaio.log-padrao FORMAT "Sim/NÆo":U WIDTH 9.86
      ttRestdoEnsaio.num-tabela FORMAT ">>>>9":U WIDTH 6
      ttRestdoEnsaio.des-val-min FORMAT "x(60)":U WIDTH 30
      ttRestdoEnsaio.des-val-max FORMAT "x(60)":U WIDTH 30
      ttRestdoEnsaio.des-val-restdo FORMAT "x(40)":U WIDTH 30
      ttRestdoEnsaio.dat-restdo-ensaio FORMAT "99/99/9999":U WIDTH 10
      ttRestdoEnsaio.hra-restdo-ensaio @ c-hora-browse COLUMN-LABEL "Hora"
            WIDTH 13.43
      fnEstado (ttRestdoEnsaio.idi-estado-ensaio ) @ cDescEstado COLUMN-LABEL "Estado"
            WIDTH 22
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 7
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     fiDescEqpto AT ROW 4 COL 33 COLON-ALIGNED NO-LABEL
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
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     ttAmostraOleo.num-docto AT ROW 6 COL 78 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiEstado AT ROW 3 COL 21.72 COLON-ALIGNED NO-LABEL
     ttAmostraOleo.ep-codigo AT ROW 4 COL 11.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttAmostraOleo.cod-eqpto AT ROW 4 COL 16.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     ttAmostraOleo.cod-tip-mater AT ROW 5 COL 11.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescMatl AT ROW 5 COL 22 COLON-ALIGNED NO-LABEL
     ttAmostraOleo.cod-comptmento AT ROW 6 COL 11.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescCompto AT ROW 6 COL 22 COLON-ALIGNED NO-LABEL
     ttAmostraOleo.num-amostra-oleo AT ROW 3 COL 11.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttAmostraOleo.dat-amostra AT ROW 4 COL 70.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttAmostraOleo.hra-amostra AT ROW 4 COL 80.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7.29 BY .88
     ttAmostraOleo.val-quant AT ROW 5 COL 78 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttAmostraOleo.cod-amostra-fisic AT ROW 3 COL 70.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.57 BY .88
     btManutencao AT ROW 1.13 COL 60.43 HELP
          "Elimina ocorrˆncia corrente"
     rtParent AT ROW 2.75 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.5 COL 2
     btEnsaios AT ROW 8.54 COL 2
     btDeleteSon1 AT ROW 8.54 COL 12
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 8.46
         SIZE 84.43 BY 8.83
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttAmostraOleo T "?" NO-UNDO movfro mao-amostra-oleo
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttRestdoEnsaio T "?" NO-UNDO movfro mao-restdo-ensaio
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
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
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
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
   FRAME-NAME Custom                                                    */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

/*ASSIGN XXTABVALXX = FRAME fPage1:MOVE-AFTER-TAB-ITEM (ttAmostraOleo.cod-amostra-fisic:HANDLE IN FRAME fPage0)
       XXTABVALXX = FRAME fPage1:MOVE-BEFORE-TAB-ITEM (btManutencao:HANDLE IN FRAME fPage0)*/
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
ASSIGN 
       brSon1:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       brSon1:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.ttRestdoEnsaio"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.ttRestdoEnsaio.cod-ensaio
"ttRestdoEnsaio.cod-ensaio" ? ? "character" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fnDescEnsaio  (ttRestdoEnsaio.cod-ensaio  ) @ cDescEnsaio" "Descri‡Æo" ? ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ttRestdoEnsaio.log-padrao
"ttRestdoEnsaio.log-padrao" ? ? "logical" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttRestdoEnsaio.num-tabela
"ttRestdoEnsaio.num-tabela" ? ? "integer" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ttRestdoEnsaio.des-val-min
"ttRestdoEnsaio.des-val-min" ? ? "character" ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttRestdoEnsaio.des-val-max
"ttRestdoEnsaio.des-val-max" ? ? "character" ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ttRestdoEnsaio.des-val-restdo
"ttRestdoEnsaio.des-val-restdo" ? ? "character" ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttRestdoEnsaio.dat-restdo-ensaio
"ttRestdoEnsaio.dat-restdo-ensaio" ? ? "date" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"ttRestdoEnsaio.hra-restdo-ensaio @ c-hora-browse" "Hora" ? ? ? ? ? ? ? ? no "Hora Resultado Ensaio" no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"fnEstado (ttRestdoEnsaio.idi-estado-ensaio ) @ cDescEstado" "Estado" ? ? ? ? ? ? ? ? no ? no no "22" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon1 */
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


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMasterDetail
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd IN MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE (INPUT "aop/ao0301a.w":U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMasterDetail
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord (INPUT "aop/ao0301a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMasterDetail
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:

    Eliminacao:
    do transaction on error undo ,return "NOK":U 
                   on stop  undo ,return "NOK":U:
    
        /** Elimina os registros da tabela filha **/
        run eliminaFilhos in {&hDBOParent} (input {&ttParent}.r-rowid).
        if return-value = "NOK":U then do:
            run piMostraErros in this-procedure.
            undo Eliminacao, return "NOK":U.
        end.
        else do:
            run openQueriesSon in this-procedure.
        end.
        /** Elimina o Pai **/
        run deleteRecord in this-procedure.
        if return-value = "NOK":U then do:
            run piMostraErros in this-procedure.
            undo Eliminacao, return "NOK":U.
        end.
    
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMasterDetail
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEnsaios
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEnsaios wMasterDetail
ON CHOOSE OF btEnsaios IN FRAME fPage1 /* Ensaios */
DO:
    RUN aop/ao0301b.w  (INPUT ?,
                        INPUT {&ttParent}.r-rowid,
                        INPUT "ADD":U,
                        INPUT {&hDBOParent},
                        INPUT 1).
    if return-value = "OK":U then do:
       run openQueriesSon in this-procedure.
    end.
    APPLY "entry":U TO {&self-name}.
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


&Scoped-define SELF-NAME btManutencao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btManutencao wMasterDetail
ON CHOOSE OF btManutencao IN FRAME fPage0
OR CHOOSE OF MENU-ITEM m_Gera IN MENU mbMain DO:
  RUN setaPrograma IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
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
    {method/zoomreposition.i &ProgramZoom="frzoom/z01fr105.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMasterDetail
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE (INPUT "aop/ao0301a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAmostraOleo.cod-comptmento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAmostraOleo.cod-comptmento wMasterDetail
ON LEAVE OF ttAmostraOleo.cod-comptmento IN FRAME fPage0 /* Compartimento */
DO:

       run buscaDescricaoCompto  IN {&hDBOParent} (input frame fPage0 {&ttParent}.cod-comptmento,
                                                   output cCompto).
      assign fiDescCompto:screen-value in frame fPage0 = cCompto.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAmostraOleo.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAmostraOleo.cod-eqpto wMasterDetail
ON LEAVE OF ttAmostraOleo.cod-eqpto IN FRAME fPage0 /* cod-eqpto */
DO:
      if input frame fPage0 {&ttParent}.ep-codigo <> &IF "{&mguni_version}" >= "2.071" &THEN "" &ELSE 0 &ENDIF
        and {&ttParent}.cod-eqpto:screen-value in frame fPage0 <> "":U  then do:
          run buscaDescricao  IN {&hDBOParent} (input frame fPage0 {&ttParent}.ep-codigo,
                                                input frame fPage0 {&ttParent}.cod-eqpto,
                                                output cModel).



         assign fiDescEqpto:screen-value in frame fPage0 = cModel.



       /*

          RUN goToKey      IN hDBOEqpto (input frame fPage0 {&ttParent}.ep-codigo,
                                         input frame fPage0 {&ttParent}.cod-eqpto).
          RUN getCharField IN hDBOEqpto (input "cod-model":U, output cModel).
         {method/referenceFields.i
                &HandleDBOLeave="hDBOModelo"
                &KeyValue1="cModel"
                &FieldName1="des-model"
                &FieldScreen1="fiDescEqpto"
                &Frame1="fPage0"}*/
      end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAmostraOleo.cod-tip-mater
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAmostraOleo.cod-tip-mater wMasterDetail
ON LEAVE OF ttAmostraOleo.cod-tip-mater IN FRAME fPage0 /* Tipo Material */
DO:
     run buscaDescricaoMatl  IN {&hDBOParent} (input frame fPage0 {&ttParent}.cod-tip-mater,
                                               output cMatl).
     assign fiDescMatl:screen-value in frame fPage0 = cMatl.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMasterDetail 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/** Modelo **/
if valid-handle(hDBOModelo) then
    run destroy in hDBOModelo.


/** Equipamento **/
if valid-handle(hDBOEqpto) then
    run destroy in hDBOEqpto.

/** Material **/
if valid-handle(hDBOTpMatl) then
    run destroy in hDBOTpMatl.

/** Compartimento **/
if valid-handle(hDBOCompto) then
    run destroy in hDBOCompto.




return "OK":U.

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
if avail {&ttParent} then do:
  /** Descri‡Æo dos Campos **/
   apply "LEAVE":U to {&ttParent}.cod-eqpto      in frame fPage0.
   apply "LEAVE":U to {&ttParent}.cod-comptmento in frame fPage0.
   apply "LEAVE":U to {&ttParent}.cod-tip-mater  in frame fPage0.
   assign fiEstado:screen-value in frame fPage0  = fnEstado({&ttparent}.idi-estado-amostra)
          btEnsaios:sensitive in frame fPage1    = yes
          btManutencao:sensitive in frame fPage0 = yes.
end.
else do:
     assign fiEstado:screen-value in frame fPage0     = "":U
            fiDescEqpto:screen-value in frame fPage0  = "":U
            fiDescMatl:screen-value in frame fPage0   = "":U
            fiDescCompto:screen-value in frame fPage0 = "":U
            btEnsaios:sensitive in frame fPage1       = NO
            btManutencao:sensitive in frame fPage0    = NO.
end.      

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{utp/ut-liter.i Data }
assign {&ttParent}.dat-amostra:label in frame fPage0 = trim(return-value).

{utp/ut-liter.i Equipamento }
assign {&ttParent}.ep-codigo:label in frame fPage0 = trim(return-value).

return "Ok":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
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
    
    define var cnum-amostra-oleo LIKE {&ttParent}.num-amostra-oleo 
               view-as  fill-in  size  10.00 BY 0.88 no-undo.

    DEFINE FRAME fGoToRecord
        cnum-amostra-oleo AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    run utp/ut-trfrrp.p (input frame fGoToRecord:handle).
    {utp/ut-liter.i V _Para_Amostra_de_àleo *}
    assign frame fGoToRecord:title = return-value.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cnum-amostra-oleo.
        
        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT cnum-amostra-oleo ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-liter.i "Amostra de àleo"}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT return-value ).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cnum-amostra-oleo  btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
   /*:T--- Verifica se o DBO j  est  inicializado ---*/               
   IF NOT VALID-HANDLE({&hDBOParent}) OR                              
      {&hDBOParent}:TYPE <> "PROCEDURE":U OR                          
      {&hDBOParent}:FILE-NAME <> "frbo/bofr105.p":U THEN DO:          
       run frbo/bofr105.p persistent set {&hDBOParent}.               
   END.                                                               
                                                                      
   RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.    
                                                                      
   /*:T--- Verifica se o DBO j  est   ---*/   
   IF NOT VALID-HANDLE({&hDBOSon1}) OR                                
      {&hDBOSon1}:TYPE <> "PROCEDURE":U OR                            
      {&hDBOSon1}:FILE-NAME <> "frbo/bofr106.p":U THEN DO:            
       run frbo/bofr106.p persistent set {&hDBOSon1}.                 
   END.       
   
/*:T--- Modelo ---*/   
   IF NOT VALID-HANDLE(hDBOModelo) OR                                
      hDBOModelo:TYPE <> "PROCEDURE":U OR                            
      hDBOModelo:FILE-NAME <> "frbo/bofr016.p":U THEN DO:            
       run frbo/bofr016.p persistent set hDBOModelo.                 
   END.        
/*:T--- Equipamento ---*/   
   IF NOT VALID-HANDLE(hDBOEqpto) OR                                
      hDBOEqpto:TYPE <> "PROCEDURE":U OR                            
      hDBOEqpto:FILE-NAME <> "frbo/bofr007.p":U THEN DO:            
       run frbo/bofr007.p persistent set hDBOEqpto.                 
   END.                                                                
    
 
/*:T--- Tipo de Material ---*/   
   IF NOT VALID-HANDLE(hDBOTpMatl) OR                                
      hDBOTpMatl:TYPE <> "PROCEDURE":U OR                            
      hDBOTpMatl:FILE-NAME <> "frbo/bofr026.p":U THEN DO:            
       run frbo/bofr026.p persistent set hDBOTpMatl.       
          
   END.        
/*:T--- Compartimento ---*/   
   IF NOT VALID-HANDLE(hDBOCompto) OR                                
      hDBOCompto:TYPE <> "PROCEDURE":U OR                            
      hDBOCompto:FILE-NAME <> "frbo/bofr003.p":U THEN DO:            
       run frbo/bofr003.p persistent set hDBOCompto.                 
   END.    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

{masterdetail/openqueriesson.i &Parent="Amostra"
                               &Query="Amostra"
                               &PageNumber="1"}

if num-results("brSon1":U) > 0 then
  assign btDeleteSon1:sensitive in frame fPage1 = yes.
else    
  assign btDeleteSon1:sensitive in frame fPage1 = no.

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraErros wMasterDetail 
PROCEDURE piMostraErros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/** Instancia aplicativo **/
{method/showmessage.i1}
/** Busca erros na BO **/
run getRowErrors in {&hDBOParent} (output table RowErrors).
/** Mostra caixa com erros **/
{method/showmessage.i2 &Modal="YES"}
/** Limpa temp-tables de erros **/
run emptyRowErrors in {&hDBOParent}.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaPrograma wMasterDetail 
PROCEDURE setaPrograma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hPrograma AS HANDLE     NO-UNDO.
 /***Limpa as temp-tables ***/
 EMPTY TEMP-TABLE ttSelecao.
 EMPTY TEMP-TABLE ttVisao.
    /*** Cria temp-table de sele‡Æo para gera‡Æo da consulta de MÆo-de-Obra ***/
create ttSelecao.
assign ttSelecao.empresa-ini     = input frame fPage0 {&ttParent}.ep-codigo 
       ttSelecao.empresa-fim     = input frame fPage0 {&ttParent}.ep-codigo 
       ttSelecao.equipto-ini     = input frame fPage0 {&ttParent}.cod-eqpto
       ttSelecao.equipto-fim     = input frame fPage0 {&ttParent}.cod-eqpto
       ttSelecao.docto-ini       = input frame fPage0 {&ttParent}.num-amostra-oleo
       ttSelecao.docto-fim       = input frame fPage0 {&ttParent}.num-amostra-oleo
       ttSelecao.modelo-ini      = ""
       ttSelecao.modelo-fim      = "ZZZZZZZZ"
       ttSelecao.amostra-ini     = input frame fPage0 {&ttParent}.cod-amostra-fisic
       ttSelecao.amostra-fim     = input frame fPage0 {&ttParent}.cod-amostra-fisic
       ttSelecao.data-ini        = input frame fPage0 {&ttParent}.dat-amostra
       ttSelecao.data-fim        = input frame fPage0 {&ttParent}.dat-amostra
       ttSelecao.compto-ini      = input frame fPage0 {&ttParent}.cod-comptmento
       ttSelecao.compto-fim      = input frame fPage0 {&ttParent}.cod-comptmento
       ttSelecao.tp-mater-ini    = input frame fPage0 {&ttParent}.cod-tip-mater 
       ttSelecao.tp-mater-fim    = input frame fPage0 {&ttParent}.cod-tip-mater 
       ttSelecao.lubrific-ini    = input frame fPage0 {&ttParent}.num-docto
       ttSelecao.lubrific-fim    = input frame fPage0 {&ttParent}.num-docto
       ttSelecao.tag-ini          = ""
       ttSelecao.tag-fim          = "ZZZZZZZZZZZZZZZZ"
       ttSelecao.cc-ini           = ""
       ttSelecao.cc-fim           = "ZZZZZZZZZZZZZZZZZZZZ"
       ttSelecao.lPadrao         = yes
       ttSelecao.lNPadrao        = yes
       ttSelecao.lData           = yes
       ttSelecao.lTexto          = yes
       ttSelecao.lNumerico       = yes
       ttSelecao.lTabela         = yes
       ttSelecao.lAprovado       = no 
       ttSelecao.lReprovado      = no 
       ttSelecao.lPendente       = yes
       ttSelecao.lAprovUsuar     = no 
       ttSelecao.lAmostAprovado  = no 
       ttSelecao.lAmostReprovado = no 
       ttSelecao.lAmostPendente  = yes
       ttSelecao.lAmostAprovUsuar = no.

&IF DEFINED(bf_mnt_ems206b) &THEN
    IF l-usa-unid-negoc THEN DO:
        ASSIGN ttSelecao.unid-negoc-ini = "":U
               ttSelecao.unid-negoc-fim = "ZZZ":U.
    END.
&ENDIF

/*** Cria temp-table de sele‡Æo para gera‡Æo das visäes ***/
create ttVisao.
{utp/ut-liter.i N£mero_Amostra * }
assign ttVisao.dimensao  = '08 ' + trim(return-value).
       ttVisao.sequencia = 1.
           
 
 /*--- Seta cursor do mouse para espera ---*/
 SESSION:SET-WAIT-STATE("GENERAL":U).
 assign {&window-name}:sensitive = no.
 /*--- Executa programa de inclusÆo de filho ---*/
 Run aop/ao0302.w PERSISTENT SET hPrograma.
 
 /* alterado por Valdir (tech264) novo m‚todo de teste do valid-handle */
 IF VALID-HANDLE(hPrograma) AND
    hPrograma:Type = "PROCEDURE":U AND
    hPrograma:FILE-NAME = "aop/ao0302.w":U THEN
     /*--- Inicializa programa de inclusÆo de filho ---*/
    Run initializeInterface IN hPrograma.
    run setaRegistros in hPrograma (input TABLE ttSelecao,
                                    INPUT TABLE ttVisao).
 
 /*--- Seta cursor do mouse para normal ---*/
 SESSION:SET-WAIT-STATE("":U).
 wait-for "CLOSE":U of hPrograma.
 assign {&window-name}:sensitive = yes.
 
 if valid-handle(hPrograma) then
     delete procedure hPrograma.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescEnsaio wMasterDetail 
FUNCTION fnDescEnsaio RETURNS CHARACTER
  ( pEnsaio as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDesc AS CHARACTER format "x(30)":U NO-UNDO.

if can-find (first mao-ensaio 
                   where mao-ensaio.cod-ensaio = pEnsaio ) then do:
  for  first mao-ensaio      fields (des-ensaio cod-ensaio )                      
          where mao-ensaio.cod-ensaio = pEnsaio no-lock:
  end.
  if avail mao-ensaio then do:
      assign cDesc = mao-ensaio.des-ensaio.
      RETURN cDesc.
  end.
  else do:
      RETURN "".   /* Function return value. */
  end.
end.
else do:
   RETURN "".   /* Function return value. */
end.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEstado wMasterDetail 
FUNCTION fnEstado RETURNS CHARACTER
  ( pEstado as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDesc AS CHARACTER format "x(30)" NO-UNDO.

RUN utp/ut-liter.p (trim({frinc/i00fr105.i 04 pEstado }), "*", "").
assign cDesc = RETURN-VALUE.

  RETURN cDesc.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

