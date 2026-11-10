&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC1009 2.00.00.022 } /*** "010022" 28/02/2025 09:42:30  ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac1009 MAC}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessadores do Template de Relat¢rio                            */
/* Obs: Retirar o valor do preprocessador para as p ginas que nÆo existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA 
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGDIG 
&GLOBAL-DEFINE PGIMP f-pg-imp

/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */

define temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field data-orig        like cotas.dt-inicial
    field data-dest        like cotas.dt-final
    field data-fim-dest    like cotas.dt-final
    field percentual       as decimal format "->>9,99"
    field elimina          as logical
    field estabel-ini      like cotas.cod-estabel
    field estabel-fim      like cotas.cod-estabel
    field l-base-cota      as log 
    field l-canal          as log
    field l-gr-cli         as log
    field l-cliente        as log
    field l-regiao         as log
    field l-mic-reg        as log
    field l-repres         as log
    field i-destino        as int 
    field i-origem         as int. 


define temp-table tt-digita
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id is primary unique
        ordem.


/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

/* Local Variable Definitions ---                                       */

def var l-ok               as logical                          no-undo.
def var c-arq-digita       as char                             no-undo.
def var c-terminal         as char                             no-undo.
def var i-cont             as integer                          no-undo.
def var de-perc            like tt-param.percentual            no-undo.
def var c-processa         as char format "x(20)"              no-undo.

{cdp/cdcfgdis.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-pg-imp

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-7 RECT-9 rs-destino bt-config-impr ~
bt-arquivo c-arquivo rs-execucao 
&Scoped-Define DISPLAYED-OBJECTS rs-destino c-arquivo rs-execucao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-config-impr 
     IMAGE-UP FILE "image~\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-arquivo AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-destino2 AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Prevista", 1,
"Original", 2,
"Solicitada", 3
     SIZE 44 BY 1.08 NO-UNDO.
DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE da-dt-origem AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE de-percentual AS DECIMAL FORMAT "->>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE dt-dest-final AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE dt-dest-ini AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tit-2 AS CHARACTER FORMAT "X(25)":U INITIAL "Copiar N¡veis" 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-tit-3 AS CHARACTER FORMAT "X(25)":U INITIAL "Origem" 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE VARIABLE fi-tit-4 AS CHARACTER FORMAT "X(25)":U INITIAL "Destino" 
      VIEW-AS TEXT 
     SIZE 8.72 BY .67 NO-UNDO.

DEFINE VARIABLE rs-origem AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Prevista", 1,
"Original", 2,
"Solicitada", 3
     SIZE 12.57 BY 3.75 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 27 BY 6.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 17.14 BY 6.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 16.14 BY 6.

DEFINE VARIABLE l-elimina AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.

DEFINE VARIABLE tb-base-cota AS LOGICAL INITIAL yes 
     LABEL "Base Cotas" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83.

DEFINE VARIABLE tb-canal AS LOGICAL INITIAL yes 
     LABEL "Canal Venda" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83.

DEFINE VARIABLE tb-cliente AS LOGICAL INITIAL yes 
     LABEL "Cliente" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.57 BY .83.

DEFINE VARIABLE tb-gr-cli AS LOGICAL INITIAL yes 
     LABEL "Grupo Cliente" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.29 BY .83.

DEFINE VARIABLE tb-mic-reg AS LOGICAL INITIAL yes 
     LABEL "MicrorregiÆo" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.29 BY .83.

DEFINE VARIABLE tb-regiao AS LOGICAL INITIAL yes 
     LABEL "RegiÆo" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.43 BY .83.

DEFINE VARIABLE tb-repres AS LOGICAL INITIAL no 
     LABEL "Representante" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.57 BY .83 NO-UNDO.

DEFINE VARIABLE c-cod-estab-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estab-ini LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-15
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE IMAGE im-pg-imp
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-par
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 79 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 0  
     SIZE 78.72 BY .13
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL 
     SIZE 79 BY 11.38
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0  
     SIZE .43 BY 11.21
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0  
     SIZE .43 BY 11.17
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0  
     SIZE 78.72 BY .13
     BGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     bt-config-impr AT ROW 3.58 COL 43.29 HELP
          "Configura‡Æo da impressora"
     bt-arquivo AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     c-arquivo AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 5.75 COL 3 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 75.43 BY 10.

DEFINE FRAME f-pg-par
     da-dt-origem AT ROW 1.5 COL 16 COLON-ALIGNED HELP
          "Data Inicial Origem"
     dt-dest-ini AT ROW 1.5 COL 53 COLON-ALIGNED HELP
          "Data Inicial Destino"
     de-percentual AT ROW 2.5 COL 16 COLON-ALIGNED HELP
          "% da cota origem a ser considerado na c¢pia da cota destino"
     dt-dest-final AT ROW 2.5 COL 53 COLON-ALIGNED HELP
          "Data Final Destino"
     l-elimina AT ROW 3.5 COL 18
     tb-base-cota AT ROW 5.25 COL 10 HELP
          "Controla as cotas por canal de venda?"
     tb-canal AT ROW 6 COL 10 HELP
          "Controla as cotas por canal de venda?"
     rs-origem AT ROW 6 COL 39.29 NO-LABEL
     rs-destino2 AT ROW 6.04 COL 56.29 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Prevista", 1,
"Original", 2,
"Solicitada", 3
          SIZE 12.57 BY 3.75
     tb-gr-cli AT ROW 6.75 COL 10 HELP
          "Controla as cotas por cliente ?"
     tb-cliente AT ROW 7.5 COL 10 HELP
          "Controla as cotas por regiÆo?"
     tb-regiao AT ROW 8.25 COL 10 HELP
          "Controla as cotas por grupo de cliente?"
     tb-mic-reg AT ROW 9 COL 10 HELP
          "Controla as cotas por MicrorregiÆo?"
     tb-repres AT ROW 9.75 COL 10
     fi-tit-2 AT ROW 4.5 COL 12 COLON-ALIGNED NO-LABEL
     fi-tit-3 AT ROW 4.5 COL 38 COLON-ALIGNED NO-LABEL
     fi-tit-4 AT ROW 4.5 COL 56 COLON-ALIGNED NO-LABEL
     RECT-21 AT ROW 4.75 COL 8
     RECT-22 AT ROW 4.75 COL 36
     RECT-23 AT ROW 4.75 COL 54
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 77 BY 10.46.

DEFINE FRAME f-relat
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execu‡Æo do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Fechar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     im-pg-sel AT ROW 1.5 COL 2.14
     im-pg-par AT ROW 1.5 COL 17.86
     im-pg-imp AT ROW 1.5 COL 33.57
     rt-folder AT ROW 2.5 COL 2
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     RECT-6 AT ROW 13.75 COL 2.14
     RECT-1 AT ROW 14.29 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.08
         SIZE 81 BY 14.92
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-sel
     c-cod-estab-ini AT ROW 3 COL 24.57 COLON-ALIGNED
     c-cod-estab-fim AT ROW 3 COL 45.14 COLON-ALIGNED NO-LABEL
     IMAGE-15 AT ROW 3 COL 35
     IMAGE-16 AT ROW 3 COL 43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3.13
         SIZE 76.86 BY 10.33.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "C¢pia de Cotas"
         HEIGHT             = 15.08
         WIDTH              = 81.14
         MAX-HEIGHT         = 22.33
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22.33
         VIRTUAL-WIDTH      = 114.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-pg-imp
                                                                        */
/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Execu‡Æo".

/* SETTINGS FOR FRAME f-pg-par
                                                                        */
/* SETTINGS FOR FILL-IN fi-tit-2 IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fi-tit-2:HIDDEN IN FRAME f-pg-par           = TRUE.

/* SETTINGS FOR FILL-IN fi-tit-3 IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fi-tit-3:HIDDEN IN FRAME f-pg-par           = TRUE.

/* SETTINGS FOR FILL-IN fi-tit-4 IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fi-tit-4:HIDDEN IN FRAME f-pg-par           = TRUE.

/* SETTINGS FOR RECTANGLE RECT-21 IN FRAME f-pg-par
   NO-ENABLE                                                            */
ASSIGN 
       RECT-21:HIDDEN IN FRAME f-pg-par           = TRUE.

/* SETTINGS FOR RECTANGLE RECT-22 IN FRAME f-pg-par
   NO-ENABLE                                                            */
ASSIGN 
       RECT-22:HIDDEN IN FRAME f-pg-par           = TRUE.

/* SETTINGS FOR RECTANGLE RECT-23 IN FRAME f-pg-par
   NO-ENABLE                                                            */
ASSIGN 
       RECT-23:HIDDEN IN FRAME f-pg-par           = TRUE.

/* SETTINGS FOR RADIO-SET rs-destino IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       rs-destino2:HIDDEN IN FRAME f-pg-par           = TRUE.

/* SETTINGS FOR RADIO-SET rs-origem IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       rs-origem:HIDDEN IN FRAME f-pg-par           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tb-base-cota IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       tb-base-cota:HIDDEN IN FRAME f-pg-par           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tb-canal IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       tb-canal:HIDDEN IN FRAME f-pg-par           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tb-cliente IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       tb-cliente:HIDDEN IN FRAME f-pg-par           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tb-gr-cli IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       tb-gr-cli:HIDDEN IN FRAME f-pg-par           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tb-mic-reg IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       tb-mic-reg:HIDDEN IN FRAME f-pg-par           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tb-regiao IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       tb-regiao:HIDDEN IN FRAME f-pg-par           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tb-repres IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       tb-repres:HIDDEN IN FRAME f-pg-par           = TRUE.

/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-estab-fim IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                          */
/* SETTINGS FOR FILL-IN c-cod-estab-ini IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                          */
/* SETTINGS FOR FRAME f-relat
                                                                        */
ASSIGN 
       im-pg-imp:HIDDEN IN FRAME f-relat           = TRUE.

/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-left IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-right IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-top IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-imp
/* Query rebuild information for FRAME f-pg-imp
     _Query            is NOT OPENED
*/  /* FRAME f-pg-imp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-sel
/* Query rebuild information for FRAME f-pg-sel
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* C¢pia de Cotas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* C¢pia de Cotas */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda C-Win
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo C-Win
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    {include/i-rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar C-Win
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Fechar */
DO:
   apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-config-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr C-Win
ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:
   {include/i-rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar C-Win
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
   do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME c-cod-estab-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estab-ini C-Win
ON F5 OF c-cod-estab-ini IN FRAME f-pg-sel /* Estab */
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                     &campo=c-cod-estab-ini
                     &campozoom=cod-estabel
                     &frame={&FRAME-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estab-ini C-Win
ON LEAVE OF c-cod-estab-ini IN FRAME f-pg-sel /* Estab */
DO:
  /*********** Uso de Pre-processadores **************/
  &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */

      find par-cota no-lock
           where par-cota.cod-estabel = c-cod-estab-ini:screen-value in frame f-pg-sel no-error.
      if avail par-cota then do:
         assign c-cod-estab-fim:screen-value in frame f-pg-sel = par-cota.cod-estabel.
         if par-cota.log-impl-niveis = yes then do:
            assign tb-base-cota:sensitive in frame f-pg-par   = yes
                   tb-canal:sensitive in frame f-pg-par       = yes
                   tb-gr-cli:sensitive in frame f-pg-par      = yes
                   tb-cliente:sensitive in frame f-pg-par     = yes
                   tb-regiao:sensitive in frame f-pg-par      = yes
                   tb-mic-reg:sensitive in frame f-pg-par     = yes
                   tb-repres:sensitive in frame f-pg-par      = yes.
            if par-cota.Cont-canal-venda = no then
               assign tb-canal:sensitive in frame f-pg-par    = no
                      tb-canal:checked in frame f-pg-par      = no.
            if par-cota.cont-gr-cli = no then
               assign tb-gr-cli:sensitive in frame f-pg-par   = no
                      tb-gr-cli:checked in frame f-pg-par     = no.
            if par-cota.cont-cliente = no then
               assign tb-cliente:sensitive in frame f-pg-par  = no
                      tb-cliente:sensitive in frame f-pg-par  = no.
            if par-cota.cont-ab-reg = no then
               assign tb-regiao:sensitive in frame f-pg-par   = no
                      tb-regiao:checked in frame f-pg-par     = no.
            if par-cota.cont-mic-reg = no then
               assign tb-mic-reg:sensitive in frame f-pg-par  = no
                      tb-mic-reg:checked in frame f-pg-par    = no. 
         end.
         else
            assign tb-base-cota:sensitive in frame f-pg-par = no
                   tb-canal:sensitive in frame f-pg-par     = no
                   tb-gr-cli:sensitive in frame f-pg-par    = no
                   tb-cliente:sensitive in frame f-pg-par   = no
                   tb-regiao:sensitive in frame f-pg-par    = no
                   tb-mic-reg:sensitive in frame f-pg-par   = no
                   tb-repres:sensitive in frame f-pg-par    = no

                   tb-base-cota:checked in frame f-pg-par = no
                   tb-canal:checked in frame f-pg-par     = no
                   tb-gr-cli:checked in frame f-pg-par    = no
                   tb-cliente:checked in frame f-pg-par   = no
                   tb-regiao:checked in frame f-pg-par    = no
                   tb-mic-reg:checked in frame f-pg-par   = no
                   tb-repres:checked in frame f-pg-par    = no. 
      end.
      else 
            assign tb-base-cota:sensitive in frame f-pg-par   = yes
                   tb-canal:sensitive in frame f-pg-par       = yes
                   tb-gr-cli:sensitive in frame f-pg-par      = yes
                   tb-cliente:sensitive in frame f-pg-par     = yes
                   tb-regiao:sensitive in frame f-pg-par      = yes
                   tb-mic-reg:sensitive in frame f-pg-par     = yes
                   tb-repres:sensitive in frame f-pg-par      = yes.      

  &ENDIF    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estab-ini C-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-estab-ini IN FRAME f-pg-sel /* Estab */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME da-dt-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-dt-origem C-Win
ON LEAVE OF da-dt-origem IN FRAME f-pg-par
DO:
  /*********** Uso de Pre-processadores **************/
  &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */

    if input frame f-pg-par da-dt-origem = 
       input frame f-pg-par dt-dest-ini then

       assign de-percentual:screen-value in frame f-pg-par = "0" 
              dt-dest-final:screen-value in frame f-pg-par = ?
              l-elimina:checked          in frame f-pg-par = no
              de-percentual:sensitive    in frame f-pg-par = no
              dt-dest-final:sensitive    in frame f-pg-par = no
              l-elimina:sensitive        in frame f-pg-par = no 
              rs-destino2:sensitive      in frame f-pg-par = yes
              rs-origem:sensitive        in frame f-pg-par = yes.
    else
       assign rs-destino2:sensitive      in frame f-pg-par = no
              rs-destino2:screen-value   in frame f-pg-par = "1"
              rs-origem:sensitive        in frame f-pg-par = no
              rs-origem:screen-value     in frame f-pg-par = "1"
            /*  dt-dest-final:screen-value in frame f-pg-par = string(today)*/
              de-percentual:sensitive    in frame f-pg-par = yes
              dt-dest-final:sensitive    in frame f-pg-par = yes
              l-elimina:sensitive        in frame f-pg-par = yes .
  &endif

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dt-dest-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dt-dest-ini C-Win
ON LEAVE OF dt-dest-ini IN FRAME f-pg-par
DO:
  /*********** Uso de Pre-processadores **************/
  &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */

    if input frame f-pg-par da-dt-origem = 
       input frame f-pg-par dt-dest-ini then

       assign de-percentual:screen-value in frame f-pg-par = "0" 
              dt-dest-final:screen-value in frame f-pg-par = ?
              l-elimina:checked          in frame f-pg-par = no
              de-percentual:sensitive    in frame f-pg-par = no
              dt-dest-final:sensitive    in frame f-pg-par = no
              l-elimina:sensitive        in frame f-pg-par = no 
              rs-destino2:sensitive      in frame f-pg-par = yes
              rs-origem:sensitive        in frame f-pg-par = yes.
    else
       assign rs-destino2:sensitive      in frame f-pg-par = no
              rs-destino2:screen-value   in frame f-pg-par = "1"
              rs-origem:sensitive        in frame f-pg-par = no
              rs-origem:screen-value     in frame f-pg-par = "1"              
/*              dt-dest-final:screen-value in frame f-pg-par = string(today)*/
              de-percentual:sensitive    in frame f-pg-par = yes
              dt-dest-final:sensitive    in frame f-pg-par = yes
              l-elimina:sensitive        in frame f-pg-par = yes. 
  &endif

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-imp C-Win
ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-par
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-par C-Win
ON MOUSE-SELECT-CLICK OF im-pg-par IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel C-Win
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino C-Win
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp
DO:
do  with frame f-pg-imp:
    case self:screen-value:
        when "1" then do:
            assign c-arquivo:sensitive    = no
                   bt-arquivo:visible     = no
                   bt-config-impr:visible = yes.
        end.
        when "2" then do:
            assign c-arquivo:sensitive     = yes
                   bt-arquivo:visible      = yes
                   bt-config-impr:visible  = no.
        end.
        when "3" then do:
            assign c-arquivo:sensitive     = no
                   bt-arquivo:visible      = no
                   bt-config-impr:visible  = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao C-Win
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "AC1009" "2.00.00.022"} /* 28/02/2025 09:42:30 */

/* inicializa‡äes do template de relat¢rio */
{include/i-rpini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

{include/i-rplbl.i}

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    assign dt-dest-ini = today
           dt-dest-final = today.

    RUN enable_UI.

    find first para-ped no-lock no-error.
    if substring(para-ped.char-1,1,3)  = "yes" then do:
       find par-cota no-lock
            where par-cota.cod-estabel = para-ped.estab-padrao no-error.
       if avail par-cota then 
          assign c-cod-estab-ini:screen-value in frame f-pg-sel = par-cota.cod-estabel
                 c-cod-estab-fim:screen-value in frame f-pg-sel = par-cota.cod-estabel
                 c-cod-estab-ini:sensitive    in frame f-pg-sel = no
                 c-cod-estab-fim:sensitive    in frame f-pg-sel = no.                     
    end.


    if c-cod-estab-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.    

    {utp/ut-liter.i Estabelecimento * L}
    assign c-cod-estab-ini:label in frame f-pg-sel = trim(return-value).

    {utp/ut-liter.i Data_Inicial_Origem * L}
    assign da-dt-origem:label in frame f-pg-par = trim(return-value).

    {utp/ut-liter.i Data_Inicial_Destino * L}
    assign dt-dest-ini:label in frame f-pg-par = trim(return-value).

    {utp/ut-liter.i Data_Final_Destino * L}
    assign dt-dest-final:label in frame f-pg-par = trim(return-value).

    {utp/ut-liter.i %_C¢pia_Cotas * L}
    assign de-percentual:label in frame f-pg-par = trim(return-value).

    {utp/ut-liter.i Elimina_registros_existentes * L}
    assign l-elimina:label in frame f-pg-par = trim(return-value).

    run pi-mostra-campos.

    {include/i-rpmbl.i}

    apply "leave" to c-cod-estab-ini in frame f-pg-sel.
    apply "entry" to c-cod-estab-ini in frame f-pg-sel.

    {acp/ac9900.i}      /* Verifica se o m¢dulo est  implantado */

    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

&IF "{&mguni_version}" >= "2.071" &THEN
ASSIGN c-cod-estab-fim:SCREEN-VALUE IN FRAME f-pg-sel = "ZZZZZ".
&ELSE
ASSIGN c-cod-estab-fim:SCREEN-VALUE IN FRAME f-pg-sel = "ZZZ".
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects C-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available C-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE im-pg-sel im-pg-par im-pg-imp bt-executar bt-cancelar bt-ajuda 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY rs-destino c-arquivo rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  ENABLE RECT-7 RECT-9 rs-destino bt-config-impr bt-arquivo c-arquivo 
         rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  DISPLAY da-dt-origem dt-dest-ini de-percentual dt-dest-final l-elimina 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  ENABLE da-dt-origem dt-dest-ini de-percentual dt-dest-final l-elimina 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  DISPLAY c-cod-estab-ini c-cod-estab-fim 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  ENABLE IMAGE-15 IMAGE-16 c-cod-estab-ini c-cod-estab-fim 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit C-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.

   RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-copia C-Win 
PROCEDURE pi-copia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*run pi-validate.
 * 
 * assign i-cont = 0
 *        de-perc = 0 .
 * 
 * for each base-cota exclusive-lock use-index periodo
 *     where base-cota.dt-inicial = tt-param.data-dest:
 *     
 *     for each cotas exclusive-lock
 *         where cotas.cod-estabel = base-cota.cod-estabel
 *         and   cotas.cd-produto  = base-cota.cd-produto
 *         and   cotas.dt-inicial  = base-cota.dt-inicial
 *         and   (cotas.qt-pedida <> 0 or cotas.qt-faturada <> 0):
 *         if tt-param.elimina then
 *            delete cotas.
 *         assign i-cont = i-cont + 1.
 *     end.    
 *     if tt-param.elimina then 
 *        delete base-cota.
 * end.
 * 
 * assign de-perc  =  1 + (input frame f-pg-par de-percentual) / 100.
 *      
 * run utp/ut-perc.p persistent set h-ut-perc.
 * {utp/ut-liter.i Criando_Arquivo... *}
 * run pi-inicializar in h-ut-perc (input RETURN-VALUE, input i-cont + 4).
 * main-block:
 * do  on error  undo main-block, leave main-block
 *     on endkey undo main-block, leave main-block
 *     on stop   undo main-block, leave main-block:
 * 
 *     for each cotas no-lock use-index periodo
 *         where cotas.dt-inicial = input frame f-pg-par da-dt-origem
 *         break by cotas.cod-estabel
 *               by cotas.cd-produto
 *               by cotas.dt-inicial:
 * 
 *         run pi-acompanhar in h-ut-perc.        
 * 
 *         find b-cotas exclusive-lock 
 *              where b-cotas.cod-estabel     = cotas.cod-estabel
 *              and   b-cotas.cod-canal-venda = cotas.cod-canal-venda
 *              and   b-cotas.cod-gr-cli      = cotas.cod-gr-cli
 *              and   b-cotas.nome-ab-reg     = cotas.nome-ab-reg
 *              and   b-cotas.nome-mic-reg    = cotas.nome-mic-reg
 *              and   b-cotas.cod-rep         = cotas.cod-rep
 *              and   b-cotas.cd-produto      = cotas.cd-produto
 *              and   b-cotas.dt-inicial      = input frame f-pg-par dt-dest-ini no-error.
 * 
 *         if not avail b-cotas then do:
 *            create b-cotas.
 *            assign b-cotas.cod-estabel     = cotas.cod-estabel
 *                   b-cotas.cod-canal-venda = cotas.cod-canal-venda
 *                   b-cotas.cod-gr-cli      = cotas.cod-gr-cli
 *                   b-cotas.nome-ab-reg     = cotas.nome-ab-reg
 *                   b-cotas.nome-mic-reg    = cotas.nome-mic-reg
 *                   b-cotas.cod-rep         = cotas.cod-rep 
 *                   b-cotas.cd-produto      = cotas.cd-produto
 *                   b-cotas.dt-inicial      = input frame f-pg-par dt-dest-ini.
 *         end.
 *         
 *         assign b-cotas.dt-final      = input frame f-pg-par dt-dest-final
 *                b-cotas.qt-prevista   = cotas.qt-prevista * de-perc
 *                b-cotas.vl-previsto   = cotas.vl-previsto * de-perc
 *                b-cotas.qt-original   = cotas.qt-original * de-perc
 *                b-cotas.vl-original   = cotas.vl-original * de-perc
 *                b-cotas.qt-solicitado = cotas.qt-solicitado * de-perc
 *                b-cotas.vl-solicitado = cotas.vl-solicitado * de-perc
 *                b-cotas.vl-medio-prev = cotas.vl-medio-prev.
 *         
 *         assign de-total-cota = de-total-cota + b-cotas.qt-prevista.       
 *         
 *         if last-of(cotas.cod-estabel) or
 *            last-of(cotas.cd-produto)  or
 *            last-of(cotas.dt-inicial)  then do:
 *            
 *            find base-cota exclusive-lock use-index periodo
 *                 where base-cota.cod-estabel = cotas.cod-estabel
 *                 and   base-cota.cd-produto  = cotas.cd-produto
 *                 and   base-cota.dt-inicial  = input frame f-pg-par dt-dest-ini no-error.
 *  
 *            if not avail base-cota then do:
 *               create base-cota.
 *               assign base-cota.cod-estabel = cotas.cod-estabel 
 *                      base-cota.cd-produto  = cotas.cd-produto
 *                      base-cota.dt-inicial  = input frame f-pg-par dt-dest-ini.
 *            end.
 *            assign base-cota.dt-final    = input frame f-pg-par dt-dest-final
 *                   base-cota.qt-prevista = de-total-cota
 *                   de-total-cota         = 0.
 *         end.          
 *     end.
 * end.
 * run pi-finalizar in h-ut-perc.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar C-Win 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

do  on error undo, return error
    on stop  undo, return error:     

    {include/i-rpexa.i}

    if  input frame f-pg-imp rs-destino = 2 then do:
        run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).
        if  return-value = "nok" then do:
            run utp/ut-msgs.p (input "show",
                               input 73,
                               input "").
            apply 'mouse-select-click' to im-pg-imp in frame f-relat.
            apply 'entry' to c-arquivo in frame f-pg-imp.                   
            return error.
        end.
    end.

    run pi-validate.
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame f-pg-imp rs-destino
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.data-orig       = input frame f-pg-par da-dt-origem
           tt-param.data-dest       = input frame f-pg-par dt-dest-ini
           tt-param.data-fim-dest   = input frame f-pg-par dt-dest-final
           tt-param.percentual      = input frame f-pg-par de-percentual                                                       
           tt-param.elimina         = input frame f-pg-par l-elimina
           tt-param.estabel-ini     = input frame f-pg-sel c-cod-estab-ini
           tt-param.estabel-fim     = input frame f-pg-sel c-cod-estab-fim
           tt-param.l-base-cota     = tb-base-cota:checked in frame f-pg-par
           tt-param.l-canal         = tb-canal:checked in frame f-pg-par
           tt-param.l-gr-cli        = tb-gr-cli:checked in frame f-pg-par
           tt-param.l-cliente       = tb-cliente:checked in frame f-pg-par
           tt-param.l-regiao        = tb-regiao:checked in frame f-pg-par
           tt-param.l-mic-reg       = tb-mic-reg:checked in frame f-pg-par
           tt-param.l-repres        = tb-repres:checked in frame f-pg-par
           tt-param.i-destino       = input frame f-pg-par rs-destino2
           tt-param.i-origem        = input frame f-pg-par rs-origem.

    if  tt-param.destino = 1 then           
        assign tt-param.arquivo = "".
    else
    if  tt-param.destino = 2 then 
        assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
    else
        assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".

    {include/i-rpexb.i}

    if  session:set-wait-state("general") then.

    {include/i-rprun.i acp/ac1009rp.p}

    {include/i-rpexc.i}

    if  session:set-wait-state("") then.

    {include/i-rptrm.i}

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-campos C-Win 
PROCEDURE pi-mostra-campos :
/*------------------------------------------------------------------------------
  Purpose: Usada na release 2.03 do dic.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*********** Uso de Pre-processadores **************/

    &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */
        assign rs-destino2:VISIBLE   in frame f-pg-par = yes
               rs-origem:visible     in frame f-pg-par = yes
               rect-23:visible       in frame f-pg-par = yes
               rect-22:visible       in frame f-pg-par = yes
               rect-21:visible       in frame f-pg-par = yes
               fi-tit-2:visible      in frame f-pg-par = yes.
        {utp/ut-liter.i Copiar_N¡veis MAC c}       
        assign fi-tit-2:screen-value in frame f-pg-par = trim(return-value)
               tb-base-cota:visible  in frame f-pg-par = yes  
               tb-canal:visible      in frame f-pg-par = yes
               tb-gr-cli:visible     in frame f-pg-par = yes
               tb-cliente:visible    in frame f-pg-par = yes
               tb-regiao:visible     in frame f-pg-par = yes
               tb-mic-reg:visible    in frame f-pg-par = yes
               tb-repres:visible     in frame f-pg-par = yes
               fi-tit-3:visible      in frame f-pg-par = yes
               fi-tit-4:visible      in frame f-pg-par = yes.
        {utp/ut-liter.i Origem MAC c}       
        assign fi-tit-3:screen-value in frame f-pg-par = trim(return-value).
        {utp/ut-liter.i Destino MAC c}       
        assign fi-tit-4:screen-value in frame f-pg-par = trim(return-value)
               tb-base-cota:sensitive in frame f-pg-par = yes
               tb-canal:sensitive in frame f-pg-par     = yes
               tb-gr-cli:sensitive in frame f-pg-par    = yes
               tb-cliente:sensitive in frame f-pg-par   = yes
               tb-regiao:sensitive in frame f-pg-par    = yes 
               tb-mic-reg:sensitive in frame f-pg-par   = yes 
               tb-repres:sensitive in frame f-pg-par    = yes.
        if avail par-cota then do:
            if par-cota.Cont-canal-venda = no then
               assign tb-canal:sensitive in frame f-pg-par    = no.
            if par-cota.cont-gr-cli = no then
               assign tb-gr-cli:sensitive in frame f-pg-par   = no.
            if par-cota.cont-cliente = no then
               assign tb-cliente:sensitive in frame f-pg-par  = no.
            if par-cota.cont-ab-reg = no then
               assign tb-regiao:sensitive in frame f-pg-par   = no.
            if par-cota.cont-mic-reg = no then
               assign tb-mic-reg:sensitive in frame f-pg-par  = no. 
        end.    
        else do:
            find first par-cota no-lock no-error. 
            assign c-cod-estab-fim:sensitive    in frame f-pg-sel = no
                   c-cod-estab-ini:screen-value in frame f-pg-sel = par-cota.cod-estabel
                   c-cod-estab-fim:screen-value in frame f-pg-sel = par-cota.cod-estabel.                     
        end.



    &endif 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina C-Win 
PROCEDURE pi-troca-pagina :
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate C-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-texto as char extent 3 no-undo. 

    if tb-base-cota:checked in frame f-pg-par = yes then do:

        find first base-cota no-lock use-index periodo 
             where base-cota.dt-inicial = input frame f-pg-par da-dt-origem no-error.
        if not avail base-cota then do:
           {utp/ut-liter.i Per¡odo_Base_Cota MAC R}
           run utp/ut-msgs.p (input "show",
                              input 707,
                              input return-value).
           apply 'mouse-select-click' to im-pg-par in frame f-relat.
           apply 'entry' to da-dt-origem in frame f-pg-par.                   
           return error.
        end.
    end.    


    if tb-canal:checked in frame f-pg-par = yes or
       tb-gr-cli:checked in frame f-pg-par = yes or
       tb-cliente:checked in frame f-pg-par = yes or
       tb-regiao:checked in frame f-pg-par = yes or
       tb-mic-reg:checked in frame f-pg-par = yes or
       tb-repres:checked in frame f-pg-par = yes then do:

        find first cotas no-lock use-index periodo 
             where cotas.dt-inicial = input frame f-pg-par da-dt-origem no-error.
        if not avail cotas then do:
           {utp/ut-liter.i Per¡odo_Cotas MAC R}
           run utp/ut-msgs.p (input "show",
                              input 707,
                              input return-value).
           apply 'mouse-select-click' to im-pg-par in frame f-relat.
           apply 'entry' to da-dt-origem in frame f-pg-par.                   
           return error.
        end.
    end.




    if input frame f-pg-par dt-dest-ini < 
       input frame f-pg-par da-dt-origem  then do:
       run utp/ut-msgs.p (input "show",
                          input 16068,
                          input "").
       apply 'mouse-select-click' to im-pg-par in frame f-relat.
       apply 'entry' to dt-dest-ini in frame f-pg-par.                   
       return error.
    end.

    if input frame f-pg-par de-percentual > 100 then do:
       run utp/ut-msgs.p (input "show",
                          input 5376,
                          input "").
       apply 'mouse-select-click' to im-pg-par in frame f-relat.
       apply 'entry' to de-percentual in frame f-pg-par.                   
       return error.
    end.

    if rs-origem:sensitive in frame f-pg-par = yes then 
       if input frame f-pg-par rs-origem  = input frame f-pg-par rs-destino2 then do:
          {utp/ut-liter.i Origem MAC c} c-texto[1] = trim(return-value).
          {utp/ut-liter.i Destino MAC c} c-texto[2] = trim(return-value).
          {utp/ut-liter.i Destino MAC c} c-texto[3] = trim(return-value).
          run utp/ut-msgs.p (input "show",
                             input 17031,
                             input c-texto[1] + "~~" + c-texto[2] + "~~" + c-texto[3]).
          apply 'mouse-select-click' to im-pg-par in frame f-relat.
          apply 'entry' to rs-origem in frame f-pg-par.                   
          return error.
       end. 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records C-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this Window, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed C-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

