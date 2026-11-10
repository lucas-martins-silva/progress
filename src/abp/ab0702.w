&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          ems2cad          PROGRESS
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0702 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0702 MAB}
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

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0702
&GLOBAL-DEFINE Version        2.00.00.002
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    2
&GLOBAL-DEFINE FolderLabels   Layout,Seleá∆o,ParÉmetros,Log

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          YES
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          NO
&GLOBAL-DEFINE PGLOG          YES

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   brLayout ~
                              bt-verify ~
                              bt-rescue ~
                              bt-plus ~
                              bt-save ~
                              bt-layout
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   btInputFile ~
                              bt-edit
&GLOBAL-DEFINE page5Widgets   
&GLOBAL-DEFINE page6Widgets   
&GLOBAL-DEFINE page7Widgets   rsAll ~
                              rsDestiny ~
                              btConfigImprDest ~
                              btDestinyFile ~
                              rsExecution
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      text-entrada
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      
&GLOBAL-DEFINE page7Text      text-imprime text-destino text-modo
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page3Fields    fiEmpFim fiEmpIni ~
                              fiEstabFim fiEstabIni ~
                              fiGrupoFim fiGrupoIni ~
                              fiModeloFim fiModeloIni
&GLOBAL-DEFINE page4Fields    cInputFile fiDataIni
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields 
&GLOBAL-DEFINE page7Fields    cDestinyFile
&GLOBAL-DEFINE page8Fields    

{frbo/bofr089.i ttLayout} /* Temp-table mab-layout-import */
/***************************************************************************/
                                               /** Parameters Definitions **/

{cdp/cdcfgmnt.i}
{abp/abapi007.i}  /* Temp-table tt-param */

define new shared temp-table tt-digita no-undo like ttLayout.

define buffer b-tt-digita for tt-digita.

define temp-table ttLayoutAux no-undo like ttLayout.

/* Transfer Definitions */
def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.
/***************************************************************************/
                                                  /** Definiá∆o vari†veis **/

DEFINE VARIABLE l-ok           as logical              no-undo.
DEFINE VARIABLE c-arq-digita   as char                 no-undo.
DEFINE VARIABLE c-terminal     as char                 no-undo.
DEFINE VARIABLE c-arq-layout   as char                 no-undo.      
DEFINE VARIABLE c-arq-temp     as char                 no-undo.
DEFINE VARIABLE hDBOLayout      as handle               no-undo.
DEFINE VARIABLE c-inicio       as char    format ">>9" no-undo.
DEFINE VARIABLE i-rows         as integer              no-undo.
DEFINE VARIABLE i-sequencia    AS INTEGER              NO-UNDO.
def stream   s-imp.
define variable c-confirma as character no-undo.
/** Vari†veis e frames da pi-print-layout **/
{include/i-rpvar.i}
{include/i-rpcab.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brLayout

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttLayout

/* Definitions for BROWSE brLayout                                      */
&Scoped-define FIELDS-IN-QUERY-brLayout /** Mostra dados no browse **/ ttLayout.num-seq f-campo(ttLayout.nom-campo) @ ttLayout.nom-campo ttLayout.num-tam-campo ttLayout.num-pos-inicial ttLayout.num-pos-final ttLayout.cod-tip-dado ttLayout.qti-casas-dec ttLayout.log-mandatorio /***************************************************************************/ /** Deixa campo habilitado no browse **/   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brLayout ttLayout.num-tam-campo ttLayout.num-pos-inicial   
&Scoped-define ENABLED-TABLES-IN-QUERY-brLayout ttLayout
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brLayout ttLayout
&Scoped-define SELF-NAME brLayout
&Scoped-define QUERY-STRING-brLayout FOR EACH ttLayout.  IF AVAIL ttLayout THEN /***************************************************************************/
&Scoped-define OPEN-QUERY-brLayout OPEN QUERY brLayout FOR EACH ttLayout.  IF AVAIL ttLayout THEN /***************************************************************************/.
&Scoped-define TABLES-IN-QUERY-brLayout ttLayout
&Scoped-define FIRST-TABLE-IN-QUERY-brLayout ttLayout


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brLayout}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-campo wReport 
FUNCTION f-campo RETURNS CHARACTER
  (input p-campo as character) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-tamanho wReport 
FUNCTION f-tamanho RETURNS INTEGER
  (input p-inicio  as integer,
   input p-tamanho as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Fechar" 
     SIZE 10 BY 1 TOOLTIP "Fechar".

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1 TOOLTIP "Ajuda".

DEFINE BUTTON btOK 
     LABEL "&Executar" 
     SIZE 10 BY 1 TOOLTIP "Executar".

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON bt-layout 
     LABEL "Imprimir &Layout" 
     SIZE 15 BY 1 TOOLTIP "Imprimir Layout".

DEFINE BUTTON bt-Plus 
     LABEL "&Gerar Default" 
     SIZE 15 BY 1 TOOLTIP "Gerar Default".

DEFINE BUTTON bt-rescue 
     LABEL "&Recuperar" 
     SIZE 15 BY 1 TOOLTIP "Recuperar".

DEFINE BUTTON bt-save 
     LABEL "&Salvar" 
     SIZE 15 BY 1 TOOLTIP "Salvar".

DEFINE BUTTON bt-verify 
     LABEL "&Verificar" 
     SIZE 15 BY 1 TOOLTIP "Verificar".

DEFINE VARIABLE fiEmpFim LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 5 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEmpIni LIKE empresa.ep-codigo
     LABEL "Empresa":R9 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEstabFim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEstabIni LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R15 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiGrupoFim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiGrupoIni AS CHARACTER FORMAT "X(8)":U 
     LABEL "Grupo Equipamento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiModeloFim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiModeloIni AS CHARACTER FORMAT "X(8)":U 
     LABEL "Modelo Equipamento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON bt-edit 
     LABEL "E&ditar Arquivo" 
     SIZE 12 BY 1 TOOLTIP "Editar Arquivo".

DEFINE BUTTON btInputFile 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Escolher o Arquivo a ser importado".

DEFINE VARIABLE cInputFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE fiDataIni AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data Inicial" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE text-entrada AS CHARACTER FORMAT "X(256)":U INITIAL "Arquivo de Entrada" 
      VIEW-AS TEXT 
     SIZE 14.86 BY .63
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.

DEFINE BUTTON btConfigImprDest 
     IMAGE-UP FILE "image~\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btDestinyFile 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cDestinyFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-imprime AS CHARACTER FORMAT "X(256)":U INITIAL "Imprime" 
      VIEW-AS TEXT 
     SIZE 9 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsAll AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Rejeitados", 2
     SIZE 34 BY .79
     FONT 1 NO-UNDO.

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
     SIZE 27.72 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 1.71.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 1.71.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 2.92.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brLayout FOR 
      ttLayout SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brLayout wReport _FREEFORM
  QUERY brLayout DISPLAY
      /** Mostra dados no browse **/
ttLayout.num-seq            format "999"            width 3
f-campo(ttLayout.nom-campo) @ ttLayout.nom-campo    width 27  FORMAT 'x(60)'
ttLayout.num-tam-campo
ttLayout.num-pos-inicial                            width 5
ttLayout.num-pos-final      format ">>>>9"          width 6
ttLayout.cod-tip-dado                               width 7
ttLayout.qti-casas-dec                              width 6
ttLayout.log-mandatorio     format "sim/n∆o"        width 7

/***************************************************************************/
/** Deixa campo habilitado no browse **/
enable
ttLayout.num-tam-campo
ttLayout.num-pos-inicial
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 82 BY 8.71
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage3
     fiEmpIni AT ROW 1.5 COL 23.15 HELP
          "C¢digo da empresa"
          LABEL "Empresa":R9
          FONT 1
     fiEmpFim AT ROW 1.5 COL 55 HELP
          "C¢digo da empresa" NO-LABEL
          FONT 1
     fiEstabIni AT ROW 2.5 COL 16.57 HELP
          "C¢digo do estabelecimento"
          LABEL "Estabelecimento":R15
          FONT 1
     fiEstabFim AT ROW 2.5 COL 55 HELP
          "C¢digo do estabelecimento" NO-LABEL
          FONT 1
     fiGrupoIni AT ROW 3.5 COL 11.28
     fiGrupoFim AT ROW 3.5 COL 55 NO-LABEL
     fiModeloIni AT ROW 4.5 COL 10.43
     fiModeloFim AT ROW 4.5 COL 55 NO-LABEL
     IMAGE-1 AT ROW 1.5 COL 35.86
     IMAGE-2 AT ROW 1.5 COL 51.29
     IMAGE-3 AT ROW 2.5 COL 35.86
     IMAGE-4 AT ROW 2.5 COL 51.29
     IMAGE-5 AT ROW 3.5 COL 35.86
     IMAGE-6 AT ROW 3.5 COL 51.29
     IMAGE-7 AT ROW 4.5 COL 35.86
     IMAGE-8 AT ROW 4.5 COL 51.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage4
     fiDataIni AT ROW 2.5 COL 15 COLON-ALIGNED
     cInputFile AT ROW 9.79 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btInputFile AT ROW 9.79 COL 43.14 HELP
          "Escolher o Arquivo a ser importado"
     bt-edit AT ROW 9.5 COL 50.72
     text-entrada AT ROW 8.75 COL 4.14 NO-LABEL
     RECT-12 AT ROW 9 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage7
     rsAll AT ROW 2.25 COL 3.29 NO-LABEL
     rsDestiny AT ROW 4.5 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     btDestinyFile AT ROW 5.71 COL 43.29 HELP
          "Escolha do nome do arquivo"
     btConfigImprDest AT ROW 5.71 COL 43.29 HELP
          "Configuraá∆o da impressora"
     cDestinyFile AT ROW 5.75 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 7.88 COL 3.14 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-imprime AT ROW 1.46 COL 2 COLON-ALIGNED NO-LABEL
     text-destino AT ROW 3.75 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 7.13 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-10 AT ROW 7.42 COL 2
     RECT-11 AT ROW 1.75 COL 2
     RECT-8 AT ROW 4.04 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage2
     brLayout AT ROW 1.25 COL 1
     bt-save AT ROW 10 COL 1
     bt-verify AT ROW 10 COL 16
     bt-rescue AT ROW 10 COL 31
     bt-Plus AT ROW 10 COL 46
     bt-layout AT ROW 10 COL 61
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
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
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = no
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
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage7:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
   Custom                                                               */
/* BROWSE-TAB brLayout 1 fPage2 */
/* SETTINGS FOR BROWSE brLayout IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR FILL-IN fiEmpFim IN FRAME fPage3
   ALIGN-L LIKE = ems2cad.empresa.ep-codigo EXP-LABEL                   */
/* SETTINGS FOR FILL-IN fiEmpIni IN FRAME fPage3
   ALIGN-L LIKE = ems2cad.empresa.ep-codigo EXP-LABEL                   */
/* SETTINGS FOR FILL-IN fiEstabFim IN FRAME fPage3
   ALIGN-L LIKE = ems2cad.estabelec.cod-estabel EXP-LABEL EXP-SIZE      */
/* SETTINGS FOR FILL-IN fiEstabIni IN FRAME fPage3
   ALIGN-L LIKE = ems2cad.estabelec.cod-estabel EXP-LABEL EXP-SIZE      */
/* SETTINGS FOR FILL-IN fiGrupoFim IN FRAME fPage3
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiGrupoIni IN FRAME fPage3
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiModeloFim IN FRAME fPage3
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiModeloIni IN FRAME fPage3
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage4
   Custom                                                               */
/* SETTINGS FOR FILL-IN text-entrada IN FRAME fPage4
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-entrada:PRIVATE-DATA IN FRAME fPage4     = 
                "Arquivo de Entrada".

/* SETTINGS FOR FRAME fPage7
                                                                        */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage7     = 
                "Destino".

ASSIGN 
       text-imprime:PRIVATE-DATA IN FRAME fPage7     = 
                "Imprime".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage7     = 
                "Execuá∆o".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brLayout
/* Query rebuild information for BROWSE brLayout
     _START_FREEFORM
OPEN QUERY brLayout FOR EACH ttLayout.

IF AVAIL ttLayout THEN
/***************************************************************************/
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brLayout */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage7
/* Query rebuild information for FRAME fPage7
     _Query            is NOT OPENED
*/  /* FRAME fPage7 */
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


&Scoped-define BROWSE-NAME brLayout
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME brLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLayout wReport
ON END-ERROR OF brLayout IN FRAME fPage2
/** Retorna dados ao original **/
anywhere
DO:
define variable i-posicao as integer no-undo.
define variable i-tamanho as integer no-undo.
    /** Posiciona no registro atual **/
    get current brLayout.                        
    /** Busca pelas posiá‰es e tamanhos da tabela **/
    run findPosicao in hDBOLayout (input  ttLayout.cod-prog-import,
                                   input  ttLayout.nom-bd,
                                   input  ttLayout.nom-tabela,
                                   input  ttLayout.num-seq,
                                   output i-posicao).
    RUN ValidaTamanho IN hDBOLayout (INPUT  "AB0702":U,
                                     INPUT  ttLayout.num-seq,
                                     OUTPUT i-tamanho).
    /** Mostra em tela os valores originais **/
    assign ttLayout.num-pos-inicial = i-posicao
           ttLayout.num-pos-inicial:screen-value in browse brLayout = string(ttLayout.num-pos-inicial)
           ttLayout.num-tam-campo  = i-tamanho
           ttLayout.num-tam-campo:screen-value in browse brLayout  = string(ttLayout.num-tam-campo).
    RUN pi-validate-browse IN THIS-PROCEDURE.

    apply "leave":U to browse brLayout.
    APPLY "entry":U TO bt-save IN FRAME fPage2.

    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLayout wReport
ON ENTER OF brLayout IN FRAME fPage2
/** Atualiza a posiá∆o final **/
ANYWHERE   
DO:    
    apply 'row-leave':U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLayout wReport
ON OFF-END OF brLayout IN FRAME fPage2
/** Sai do browse ao final **/
DO:
  apply 'entry':U to bt-save in frame fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLayout wReport
ON OFF-HOME OF brLayout IN FRAME fPage2
/** Sai do browse ao in°cio **/
DO:
  apply 'entry':U to bt-save in frame fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLayout wReport
ON ROW-ENTRY OF brLayout IN FRAME fPage2
DO:
  IF NOT CAN-FIND(FIRST ttLayout) THEN DO:
      APPLY 'entry':U TO bt-plus IN FRAME fPage2.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLayout wReport
ON ROW-LEAVE OF brLayout IN FRAME fPage2
/** Atualiza dados da linha ao sair **/
ANYWHERE
DO:
  RUN pi-validate-browse IN THIS-PROCEDURE.
  IF RETURN-VALUE = "NOK":U THEN
      RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLayout wReport
ON TAB OF brLayout IN FRAME fPage2
ANYWHERE
DO:
  RUN pi-validate-browse IN THIS-PROCEDURE.
  IF RETURN-VALUE = "NOK":U THEN
      RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME bt-edit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-edit wReport
ON CHOOSE OF bt-edit IN FRAME fPage4 /* Editar Arquivo */
DO: /** Editar o arquivo selecionado **/
/*   OS-COMMAND SILENT "notepad.exe" VALUE(input frame fPage4 cInputFile). */
  {report/imtrm.i "input frame fPage4 cInputFile" 3}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-layout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-layout wReport
ON CHOOSE OF bt-layout IN FRAME fPage2 /* Imprimir Layout */
DO: /** Editar/Imprimir layout  do browse **/
    IF CAN-FIND(FIRST ttLayout) THEN
        run pi-print-layout IN THIS-PROCEDURE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-Plus
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-Plus wReport
ON CHOOSE OF bt-Plus IN FRAME fPage2 /* Gerar Default */
DO: /** Recupera o banco de dados original **/
    run utp/ut-msgs.p ("Show", 27252, "").
    assign c-confirma = return-value.
    if c-confirma = "yes":U then do:
        run createDefaultAB0702 in hDBOLayout.
        run pi-atualiza-browse in this-procedure (input yes).
    end.
    apply "display":U to browse brLayout.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-rescue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-rescue wReport
ON CHOOSE OF bt-rescue IN FRAME fPage2 /* Recuperar */
DO: /** Recupera a temp-table conforme BO **/
    IF CAN-FIND(FIRST ttLayout) THEN
        run pi-atualiza-browse in this-procedure (input yes).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-save wReport
ON CHOOSE OF bt-save IN FRAME fPage2 /* Salvar */
DO: 
    IF CAN-FIND(FIRST ttLayout) THEN DO:
        RUN pi-update-layout IN THIS-PROCEDURE.
        {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-verify
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-verify wReport
ON CHOOSE OF bt-verify IN FRAME fPage2 /* Verificar */
DO: /** Valida os campos do Browse **/
    IF CAN-FIND(FIRST ttLayout) THEN DO:
        run pi-validate-layout IN THIS-PROCEDURE (INPUT YES).
        {&Open-Query-{&Browse-Name}}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CHOOSE":U TO bt-save IN FRAME fPage2.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME btConfigImprDest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImprDest wReport
ON CHOOSE OF btConfigImprDest IN FRAME fPage7
DO:
   {report/imimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDestinyFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDestinyFile wReport
ON CHOOSE OF btDestinyFile IN FRAME fPage7
DO:
    {report/imarq.i cDestinyFile fPage7}
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btInputFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInputFile wReport
ON CHOOSE OF btInputFile IN FRAME fPage4
DO:
    {report/imarq.i cInputFile fPage4}
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


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage7
DO:
do  with frame fPage7:
    case self:screen-value:
        when "1" then do:
            assign cDestinyFile:sensitive     = no
                   cDestinyFile:visible       = yes
                   btDestinyFile:visible      = no
                   btConfigImprDest:visible   = yes.
        end.
        when "2" then do:
            assign cDestinyFile:sensitive     = yes
                   cDestinyFile:visible       = yes
                   btDestinyFile:visible      = yes
                   btConfigImprDest:visible   = no.
        end.
        when "3" then do:
            assign cDestinyFile:sensitive     = no
                   cDestinyFile:visible       = no
                   btDestinyFile:visible      = no
                   btConfigImprDest:visible   = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage7
DO:
   {report/imrse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*--- L¢gica para inicializaá∆o do programam ---*/

ASSIGN fiEmpIni = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF
       fiEmpFim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF.

ASSIGN fiEstabFim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZZZ":U &ELSE "ZZZ":U &ENDIF.

{report/mainblock.i}

{abp/abapi001.i2} /** Criaá∆o de Erros **/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wReport 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Destroy as handles existentes na mem¢ria.
------------------------------------------------------------------------------*/
/** Layout Import **/
if valid-handle (hDBOLayout) then
    delete procedure hDBOLayout.
/** Caixa de Mensagens **/
{method/showmessage.i3}

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override ap¢s a inicializaá∆o da tela
------------------------------------------------------------------------------*/
/** Layout **/
{utp/ut-liter.i "Seq."}
assign ttLayout.num-seq:label in browse brLayout = trim(return-value).
{utp/ut-liter.i "In°cio"}
assign ttLayout.num-pos-inicial:label in browse brLayout = trim(return-value).
{utp/ut-liter.i "TÇrmino"}
assign ttLayout.num-pos-final:label in browse brLayout = trim(return-value).
{utp/ut-liter.i "Conte£do"}
assign ttLayout.cod-tip-dado:label in browse brLayout = trim(return-value).
{utp/ut-liter.i "Decimais"}
assign ttLayout.qti-casas-dec:label in browse brLayout = trim(return-value).
{utp/ut-liter.i "Obrigat¢rio"}
assign ttLayout.log-mandatorio:label in browse brLayout = trim(return-value)
       c-arq-layout                                     = session:temp-directory + "layoutAB0702.tmp".
/** Seleá∆o **/
{utp/ut-liter.i "Empresa"}
assign fiEmpIni:label in frame fPage3 = trim(return-value).
{utp/ut-liter.i "Estabelecimento"}
assign fiEstabIni:label in frame fPage3 = trim(return-value).
{utp/ut-liter.i "Grupo Equipamento"}
assign fiGrupoIni:label in frame fPage3 = trim(return-value).
{utp/ut-liter.i "Modelo Equipamento"}
assign fiModeloIni:label in frame fPage3 = trim(return-value).
/** ParÉmetros **/
{utp/ut-liter.i "Data Inicial"}
assign fiDataIni:label in frame fPage4 = trim(return-value)
       fiDataIni                       = date(01,           /** Sempre primeiro dia **/
                                              month(today), /** Màs atual **/
                                              year(today)). /** Ano Atual **/
{utp/ut-liter.i "Editar Arquivo"}
assign bt-edit:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Arquivo Entrada"}
assign text-entrada = trim(return-value).
display text-entrada fiDataIni with frame fPage4.
/** LOG **/
assign rsAll = 2. /** Somente Rejeitados **/
display rsAll with frame fPage7.

/** Abre a Query do Browse **/
run pi-atualiza-browse in this-procedure (input yes).

run setFolder in hFolder (input 3).

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wReport 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override antes de inicializar a tela
------------------------------------------------------------------------------*/
/*:T--- Verifica se o DBO j† est† inicializado ---*/
IF NOT VALID-HANDLE(hDBOLayout) OR
   hDBOLayout:TYPE <> "PROCEDURE":U OR
   hDBOLayout:FILE-NAME <> "frbo~\bofr089.p":U THEN DO:
    run frbo/bofr089.p persistent set hDBOLayout.
END.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-browse wReport 
PROCEDURE pi-atualiza-browse :
/*------------------------------------------------------------------------------
  Purpose:    pi-atualiza-browse
  Parameters: entrada pBrowse yes = Atualiza browse
                              no  = cria temp-table auxilia
  Notes:      Atualiza os dados da temp-table de layout para mostrar na tela  
------------------------------------------------------------------------------*/
define input parameter pBrowse as logical no-undo.

/** Roda as restriá‰es na BO **/
run setConstraintPrograma in hDBOLayout (input "movfro":U,
                                         input "mab-movto-km-eqpto":U,
                                         input "AB0702":U).
/** Abre a query com as restriá‰es **/
run openQueryStatic in hDBOLayout (input "Programa":U).

if pBrowse then do:
    /** TempTable para o browse **/
    run getBatchRecords in hDBOLayout (input  ?,
                                       input  no,
                                       input  99,
                                       output i-rows,
                                       output table ttLayout).
    if can-find (first ttLayout) then do:
        {&OPEN-QUERY-{&BROWSE-NAME}}
    end.
end.
else
    /** TempTable para validaá‰es **/
    run getBatchRecords in hDBOLayout (input  ?,
                                       input  no,
                                       input  99,
                                       output i-rows,
                                       output table ttLayoutAux).
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-print-layout wReport 
PROCEDURE pi-print-layout :
/*------------------------------------------------------------------------------
  Purpose:     pi-print-layout
  Parameters:  <none>
  Notes:       Editar/Imprimir o arquivo do layout (dados do browse).
------------------------------------------------------------------------------*/
                                                        /** Forms and Frames **/
define variable c-campo as character                 no-undo.

define variable iSeq    as integer format ">999":U     no-undo.
define variable iTamanh as integer format ">>>>999":U  no-undo.
define variable iInicio as integer format ">>>>>999":U no-undo.
define variable iTermin as integer format ">>>>999":U  no-undo.
define variable cDad    as character format "x(10)":U  no-undo.
define variable deCampo as integer format ">>>>>>9":U  no-undo.
define variable lMand   like ttLayout.log-mandatorio   no-undo.

assign c-arq-layout = session:temp-directory + "layoutAB0702.tmp"
       c-programa   = "AB/0702"
       c-versao     = "2.00"
       c-revisao    = ".00.000".    

for first param-global fields(grupo) no-lock:
    assign c-empresa = param-global.grupo.
end.
{utp/ut-liter.i "Abastecimento"}    
assign c-sistema = trim(return-value).
{utp/ut-liter.i "Layout Importaá∆o Percurso Rodado" MAB R}
assign c-titulo-relat = trim(return-value).

form "|" ttLayout.num-seq     format ">999":U      "|"
     c-campo                  format "x(60)":U     "|"
     ttLayout.num-tam-campo   format ">>>>999":U   "|"
     ttLayout.num-pos-inicial format ">>>>>999":U  "|"
     ttLayout.num-pos-final   format ">>>>999":U   "|"
     ttLayout.cod-tip-dado    format "x(10)":U     "|"
     ttLayout.qti-casas-dec   format ">>>>>>9":U   "|"
     ttLayout.log-mandatorio                      " |"
     SKIP
     "|----------------------------------------------------------------------------------------------------------------------------------|"
    with width 132 no-attr-space no-box no-label down frame f-layout stream-io.

form "|" iSeq                  "|"
     c-campo  format "x(60)":U "|"
     iTamanh                   "|"  
     iInicio                   "|"
     iTermin                   "|"  
     cDad                      "|"
     deCampo                   "|"
     lMand                     "|"
     "|----------------------------------------------------------------------------------------------------------------------------------|"
    with width 132 no-attr-space no-box down frame f-main stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-main:HANDLE).


/*----------------------------------------------------------------------------*/
                                                                  /** Labels **/
{utp/ut-liter.i "Sim/N∆o"}
assign lMand:format in frame f-main = trim(return-value).
{utp/ut-liter.i "Seq."}
assign iSeq:label in frame f-main = trim(return-value).
{utp/ut-liter.i "Descriá∆o"}
assign c-campo:label in frame f-main = trim(return-value).
{utp/ut-liter.i "Tamanho"}
assign iTamanh:label in frame f-main = trim(return-value).
{utp/ut-liter.i "In°cio"}
assign iInicio:label in frame f-main = trim(return-value).
{utp/ut-liter.i "TÇrmino"}
assign iTermin:label in frame f-main = trim(return-value).
{utp/ut-liter.i "Tipo"}
assign cDad:label in frame f-main = trim(return-value).
{utp/ut-liter.i "Obr."}
assign lMand:label in frame f-main = trim(return-value).
{utp/ut-liter.i "Decimal"}
assign deCampo:label in frame f-main = trim(return-value).
/*----------------------------------------------------------------------------*/
                                                          /** Output Display **/
output to value(c-arq-layout) paged page-size 64 convert target "iso8859-1":U.

view frame f-cabec.

for each ttLayout:
    assign c-campo = f-campo(ttLayout.nom-campo) + "  (" + ttLayout.nom-campo + ")".
    if ttLayout.num-seq = 1 then do:
        display ttLayout.num-seq         @ iSeq
                c-campo
                ttLayout.num-tam-campo   @ iTamanh  
                ttLayout.num-pos-inicial @ iInicio  
                ttLayout.num-pos-final   @ iTermin  
                ttLayout.cod-tip-dado    @ cDad  
                ttLayout.qti-casas-dec   @ deCampo
                ttLayout.log-mandatorio  @ lMand 
              with frame f-main.
        down with frame f-main.
    end.
    else do:
        display ttLayout.num-seq     
                c-campo
                ttLayout.num-tam-campo
                ttLayout.num-pos-inicial
                ttLayout.num-pos-final
                ttLayout.cod-tip-dado
                ttLayout.qti-casas-dec
                ttLayout.log-mandatorio
              with frame f-layout.
        down with frame f-layout.
    end.
end.
view frame f-rodape.
output close.

/*----------------------------------------------------------------------------*/
                                                        /** Visualizar Dados **/
{report/imtrm.i c-arq-layout 3}

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-update-layout wReport 
PROCEDURE pi-update-layout :
/*------------------------------------------------------------------------------
  Purpose:     pi-update-layout
  Parameters:  <none>
  Notes:       Verifica se h† alteraá‰es na ttLayout e atualiza a base
------------------------------------------------------------------------------*/
define variable c-atualiza as character no-undo.
define variable l-atualiza as logical   no-undo.

/* Gera buffer da layout-import */
run pi-atualiza-browse in this-procedure (input no).

bloco_a:
/** Verifica se a Tabela Original foi modificada **/
for each ttLayout no-lock:
    IF CAN-FIND(first  ttLayoutAux 
                where (ttLayoutAux.cod-prog-import  = ttLayout.cod-prog-import 
                and    ttLayoutAux.nom-bd           = ttLayout.nom-bd          
                and    ttLayoutAux.nom-tabela       = ttLayout.nom-tabela         
                and    ttLayoutAux.num-seq          = ttLayout.num-seq)     
                and   (ttLayoutAux.num-pos-inicial <> ttLayout.num-pos-inicial       
                or     ttLayoutAux.num-tam-campo   <> ttLayout.num-tam-campo) no-lock) THEN DO:
        assign l-atualiza = yes.
        LEAVE bloco_a.
    END.
end.
/** Se foi modificada pergunta se deseja modifica-la **/
if l-atualiza then do:
    run utp/ut-msgs.p (input "SHOW":U,
                       input 27248,
                       input "":U).
    assign c-atualiza = return-value.  
    /** Atualiza os dados de tela em tabela **/
    if c-atualiza = "YES":U then
        run createLayout in hDBOLayout (input table ttLayout,
                                        input "ab0702":U,
                                        input "movfro":U,
                                        input "mab-movto-km-eqpto":U).
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate-browse wReport 
PROCEDURE pi-validate-browse :
/*------------------------------------------------------------------------------
  Purpose:     pi-validate-browse
  Parameters:  <none>
  Notes:       Valida se os dados n∆o est∆o sobrepostos 
------------------------------------------------------------------------------*/
define variable i-tamanho as integer no-undo.
define variable i-posicao as integer no-undo.

/** Cria tabela tempor†ria auxiliar para comparaá∆o **/
RUN pi-atualiza-browse IN THIS-PROCEDURE (INPUT NO).

FIND CURRENT ttLayout no-lock NO-ERROR.

ASSIGN ttLayout.num-tam-campo   = integer(ttLayout.num-tam-campo:SCREEN-VALUE  IN BROWSE brLayout)
       ttLayout.num-pos-inicial = integer(ttLayout.num-pos-inicial:SCREEN-VALUE IN BROWSE brLayout)
       ttLayout.num-pos-final   = integer(ttLayout.num-pos-final:SCREEN-VALUE  IN BROWSE brLayout).

FOR FIRST ttLayoutAux FIELDS(tamanho) 
    WHERE ttLayoutAux.num-seq         = ttLayout.num-seq 
    and   ttLayoutAux.cod-prog-import = ttLayout.cod-prog-import 
    and   ttLayoutAux.nom-bd          = ttLayout.nom-bd 
    and   ttLayoutAux.nom-tabela      = ttLayout.nom-tabela no-lock:

    run ValidaTamanho in hDBOLayout (INPUT  "AB0702":U,
                                     INPUT  ttLayoutAux.num-seq,
                                     OUTPUT i-tamanho).
    /** Verifica se campo Ç mandat¢rio **/
    IF ttLayout.log-mandatorio THEN DO:
        /** Verifica se tamanho est† correto **/
        IF ttLayout.num-tam-campo <= 0 OR ttLayout.num-tam-campo > i-tamanho THEN DO:
            RUN utp/ut-msgs.p (INPUT 'show':U,
                               INPUT 27515,
                               INPUT i-tamanho).
            ASSIGN ttLayout.num-tam-campo:SCREEN-VALUE  IN BROWSE brLayout = STRING(i-tamanho).
            APPLY 'entry':U TO ttLayout.num-tam-campo IN BROWSE brLayout.
            RETURN "NOK":U.
        END.
        ELSE
            /** Atualiza campo de posiá∆o final **/
            assign ttLayout.num-pos-final                                 = f-tamanho(ttLayout.num-pos-inicial, 
                                                                                      ttLayout.num-tam-campo)
                   ttLayout.num-pos-final:screen-value in browse brLayout = string(ttLayout.num-pos-final).
    END.
    ELSE
        /** Verifica se tamanho est† correto **/
        IF ttLayout.num-tam-campo < 0 OR ttLayout.num-tam-campo > i-tamanho THEN DO:
            RUN utp/ut-msgs.p (INPUT 'show':U,
                               INPUT 27515,
                               INPUT i-tamanho).
            ASSIGN ttLayout.num-tam-campo:SCREEN-VALUE  IN BROWSE brLayout = STRING(i-tamanho).
            APPLY 'entry':U TO ttLayout.num-tam-campo IN BROWSE brLayout.
            RETURN "NOK":U.
        END.
        ELSE DO:
            /** Verifica se tamanho Ç igual a zero **/
            IF ttLayout.num-tam-campo = 0 THEN
                /** Zera as posiá‰es **/
                ASSIGN ttLayout.num-pos-final                                   = 0
                       ttLayout.num-pos-inicial                                 = 0
                       ttLayout.num-pos-final:screen-value in browse brLayout   = string(0)
                       ttLayout.num-pos-inicial:screen-value in browse brLayout = string(0).
            ELSE
                /** Atualiza posiá∆o final **/
                assign ttLayout.num-pos-final                                 = f-tamanho(ttLayout.num-pos-inicial,
                                                                                          ttLayout.num-tam-campo)
                       ttLayout.num-pos-final:screen-value in browse brLayout = string(ttLayout.num-pos-final).
        END.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate-layout wReport 
PROCEDURE pi-validate-layout :
/*------------------------------------------------------------------------------
  Purpose:     pi-validate-layout
  Parameters:  <none>
  Notes:       Valida a temp-table ttLayout
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-log-mes AS LOGICAL NO-UNDO.

define buffer   b-ttLayout for ttLayout.
define variable i-posicao  as integer no-undo.
define variable i-tamanho  as integer no-undo.

/** Limpa a temp-table de erros **/
EMPTY TEMP-TABLE RowErrors.

ASSIGN i-sequencia = 0.

/** Verifica registros do layout **/
for each ttLayout no-lock:
    /** Procura pela posiá∆o no layout de importaá∆o **/ 
    run findPosicao in hDBOLayout (input  ttLayout.cod-prog-import,
                                   input  ttLayout.nom-bd,
                                   input  ttLayout.nom-tabela,
                                   input  ttLayout.num-seq,
                                   output i-posicao).
   /** Retorna tamanho m†ximo do campo **/
    run ValidaTamanho in hDBOLayout (INPUT  "AB0702":U,
                                     INPUT  ttLayout.num-seq,
                                     OUTPUT i-tamanho).
    /** Verifica se posiá∆o inicial Ç menor que 0 para obrigat¢rios **/
    if  ttLayout.num-pos-inicial <= 0 AND ttLayout.log-mandatorio THEN
        run piCriaErro (input 27246, input "EMS", input string(ttLayout.num-seq)).
    /** Verifica se posiá∆o inicial Ç menor que 0 para n∆o obrigat¢rios **/
    if  ttLayout.num-pos-inicial < 0 AND not(ttLayout.log-mandatorio) THEN
        run piCriaErro (input 27246, input "EMS", input string(ttLayout.num-seq)).
    /** Verifica se Ç mandat¢rio **/
    IF ttLayout.log-mandatorio THEN DO:
        /** Verifica se tamanho est† correto **/
        IF ttLayout.num-tam-campo <= 0 OR 
           ttLayout.num-tam-campo > i-tamanho THEN
            RUN piCriaErro (INPUT 27515, input "EMS", INPUT string(i-tamanho)).
        /** Verifica se h† posiá‰es duplicadas **/
        if can-find(FIRST b-ttLayout where 
                          b-ttLayout.num-pos-inicial <= ttLayout.num-pos-inicial and
                          b-ttLayout.num-pos-final  >= ttLayout.num-pos-inicial and 
                          rowid(b-ttLayout) <> rowid(ttLayout)) THEN
            run piCriaErro (input 27246, input "EMS", input string(ttLayout.num-seq)).
    END.
    ELSE DO:
        /** Verifica se tamanho est† correto **/
        IF ttLayout.num-tam-campo < 0 OR 
           ttLayout.num-tam-campo > i-tamanho THEN
            RUN piCriaErro (INPUT 27515, input "EMS", INPUT string(i-tamanho)).
        /** Verifica se h† posiá‰es duplicadas sem contar as com 0 **/
        if can-find(FIRST b-ttLayout where 
                          b-ttLayout.num-pos-inicial <= ttLayout.num-pos-inicial and
                          b-ttLayout.num-pos-final  >= ttLayout.num-pos-inicial and 
                          rowid(b-ttLayout) <> rowid(ttLayout))    and
                          (ttLayout.num-tam-campo <> 0) THEN
            run piCriaErro (input 27246, input "EMS", input string(ttLayout.num-seq)).
    END.
end.

/** Mostra tabela de erros **/
IF CAN-FIND(FIRST RowErrors) THEN DO:
    {method/showmessage.i1}
    {method/showmessage.i2 &Modal="YES"}
    EMPTY TEMP-TABLE RowErrors.
    RETURN "NOK":U.
END.
ELSE
    /** Mostra mensagem sem erros **/
    IF p-log-mes THEN
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 27516,
                           INPUT '').

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     Executa as validaá‰es padr‰es e chama o RP de importaá∆o.
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/

define var r-tt-digita as rowid no-undo.

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
/***************************************************************************/
                                                          /*** Relat¢rio ***/
&ELSE
/***************************************************************************/
                                              /*** Importaá∆o/Exportaá∆o ***/
do  on error undo, return error
    on stop  undo, return error:     

    {report/rpexa.i}
    /** Validaá∆o arquivo destino **/
    if  input frame fPage7 rsDestiny = 2 and
        input frame fPage7 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage7 cDestinyFile).
        if  return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "SHOW":U,
                               input 73,
                               input "").
            RUN setFolder IN hFolder (INPUT 3).
            apply "ENTRY":U to cDestinyFile in frame fPage7.                   
            return error.
        end.
    end.
    /** Validaá∆o do arquivo importaá∆o **/
    assign file-info:file-name = input frame fPage4 cInputFile.
    if  file-info:pathname = ? and
        input frame fPage7 rsExecution = 1 then do:
        run utp/ut-msgs.p (input "SHOW":U,
                           input 326,
                           input cInputFile).
        RUN setFolder IN hFolder (INPUT 2).
        apply "ENTRY":U to cInputFile in frame fPage4.                
        return error.
    end. 
    /** Validaá∆o da existància de layout **/
    IF NOT CAN-FIND(FIRST ttLayout) THEN DO:
        RUN setFolder IN hFolder (INPUT 1).
        APPLY "CHOOSE":U TO bt-plus IN FRAME fPage2.
        RETURN ERROR.
    END.


    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage7 rsDestiny
           tt-param.todos           = input frame fPage7 rsAll
           tt-param.execucao        = input frame fPage7 rsExecution
           tt-param.arq-entrada     = input frame fPage4 cInputFile
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.i-origem        = 1 /** Importaá∆o **/
           tt-param.dtInicial       = input frame fPage4 fiDataIni
           tt-param.empIni          = input frame fPage3 fiEmpIni
           tt-param.empFim          = input frame fPage3 fiEmpFim
           tt-param.estabIni        = input frame fPage3 fiEstabIni
           tt-param.estabFim        = input frame fPage3 fiEstabFim
           tt-param.grupoIni        = input frame fPage3 fiGrupoIni
           tt-param.grupoFim        = input frame fPage3 fiGrupoFim
           tt-param.modeloIni       = input frame fPage3 fiModeloIni
           tt-param.modeloFim       = input frame fPage3 fiModeloFim.

        &IF DEFINED(bf_mnt_ems206b) &THEN
            ASSIGN  tt-param.unidNegocIni    = ""
                    tt-param.unidNegocFim    = "ZZZZZZZZZZZZZZZZZZ".
        &ENDIF




    if  tt-param.destino = 1 then
        assign tt-param.arq-destino = "".
    else
    if  tt-param.destino = 2 then 
        assign tt-param.arq-destino = input frame fPage7 cDestinyFile.
    else
        assign tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp":U.

    /** Validaá∆o dos dados do Browse **/
    run pi-validate-layout IN THIS-PROCEDURE (INPUT NO).
    IF RETURN-VALUE = 'NOK':U THEN
        RETURN ERROR.

    /** Gravaá∆o da tt-digita **/
    EMPTY TEMP-TABLE tt-digita.
    for each ttLayout:
        create tt-digita.
        buffer-copy ttLayout to tt-digita.
    end.

    {report/imexb.i}

    if  session:set-wait-state("GENERAL":U) then.

    {report/imrun.i abp\ab0702rp.p}

    {report/imexc.i}

    if  session:set-wait-state("") then.

    {report/imtrm.i tt-param.arq-destino tt-param.destino}

end.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-campo wReport 
FUNCTION f-campo RETURNS CHARACTER
  (input p-campo as character):
/*------------------------------------------------------------------------------
  Purpose:  f-campo
    Notes:  Retorna um Label para o browse.
------------------------------------------------------------------------------*/
define variable c-campo as character format "x(40)" no-undo.

case p-campo:
    when "ep-codigo":U then do:
        {utp/ut-liter.i "Empresa"}
        assign c-campo = trim(return-value).
    end.
    when "cod-eqpto":U then do:
        {utp/ut-liter.i "Equipamento"}
        assign c-campo = trim(return-value).
    end.
    when "dat-movto":U then do:
        {utp/ut-liter.i "Data Movimento"}
        assign c-campo = trim(return-value) + " - (dd/mm/yyyy)":U.
    end.
    when "val-km-real":U then do:
        {utp/ut-liter.i "Percurso Rodado" MAB}
        assign c-campo = trim(return-value) + " - (99999999,9)":U.
    end.
end case.

  RETURN (c-campo).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-tamanho wReport 
FUNCTION f-tamanho RETURNS INTEGER
  (input p-inicio  as integer,
   input p-tamanho as integer) :
/*------------------------------------------------------------------------------
  Purpose:  f-tamanho
    Notes:  Atualiza o campo posiá∆o final no browse.
------------------------------------------------------------------------------*/
define variable i-termino as integer no-undo.

assign i-termino = (p-inicio + p-tamanho) - 1.

  RETURN i-termino.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

