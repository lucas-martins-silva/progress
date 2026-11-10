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
{include/i-prgvrs.i AC0410 2.00.00.017 } /*** 010017 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac0410 MAC}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessadores do Template de Relat¢rio                            */
/* Obs: Retirar o valor do preprocessador para as p†ginas que n∆o existirem  */

&GLOBAL-DEFINE PGLAY f-pg-lay
&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGLOG f-pg-log

/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */

{acp/ac0410.i}    


/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

/* Local Variable Definitions ---                                       */

def var l-ok               as logical no-undo.
def var c-arq-term         as char    no-undo.

{include/i-imdef.i}

/* Local Variable Definitions ---                                       */

def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var i-selec-zoom       as integer init 1  no-undo.
def var i-dia              as int     no-undo.
def var i-dia2             as int     no-undo.
def var i-mes              as int     no-undo.
def var i-ano              as int     no-undo.
DEF VAR vrs-layout         AS INT     NO-UNDO.

/** Definiá∆o Pre-processador **/
{cdp/cdcfgdis.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-import

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS im-pg-lay im-pg-sel im-pg-par im-pg-log ~
bt-executar bt-cancelar bt-ajuda 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE IMAGE im-pg-lay
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-log
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

DEFINE BUTTON bt-alter 
     LABEL "Alterar Layout" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-editar 
     LABEL "Editar Layout" 
     SIZE 16 BY 1.

DEFINE VARIABLE ed-layout AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 76 BY 9
     FONT 2 NO-UNDO.

DEFINE BUTTON bt-arquivo-destino 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-config-impr-destino 
     IMAGE-UP FILE "image~\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-arquivo-destino AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92 NO-UNDO.

DEFINE VARIABLE rs-todos AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Rejeitados", 2
     SIZE 34 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 1.71.

DEFINE VARIABLE c-arquivo-entrada AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE l-imprime AS LOGICAL INITIAL no 
     LABEL "Imprime Layout" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE VARIABLE c-cod-estab-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estab-ini LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev-fim AS CHARACTER FORMAT "X(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88.

DEFINE VARIABLE c-nome-abrev-ini AS CHARACTER FORMAT "X(12)" 
     LABEL "Cliente":R17 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88.

DEFINE VARIABLE da-dt-final AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-inicial AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Per°odo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-canal-venda-fim AS INTEGER FORMAT ">>9" INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-canal-venda-ini AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Cod Canal Venda" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88.

DEFINE VARIABLE i-cod-gr-cli-fim AS INTEGER FORMAT ">>>9" INITIAL 9999 
     VIEW-AS FILL-IN 
     SIZE 5.50 BY .88.

DEFINE VARIABLE i-cod-gr-cli-ini AS INTEGER FORMAT ">>>9" INITIAL 0 
     LABEL "Grupo Cliente" 
     VIEW-AS FILL-IN 
     SIZE 5.50 BY .88.

DEFINE VARIABLE i-cod-rep-fim AS INTEGER FORMAT ">>>>9" INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-rep-ini AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Representante" 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-import
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execuá∆o do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Cancelar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     rt-folder AT ROW 2.5 COL 2
     RECT-1 AT ROW 14.29 COL 2
     RECT-6 AT ROW 13.75 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     im-pg-lay AT ROW 1.5 COL 2.14
     im-pg-sel AT ROW 1.5 COL 17.86
     im-pg-par AT ROW 1.5 COL 33.57
     im-pg-log AT ROW 1.5 COL 49.29
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-left AT ROW 2.54 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.21
         SIZE 81 BY 14.96
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-lay
     ed-layout AT ROW 1.25 COL 1 NO-LABEL
     bt-editar AT ROW 10.5 COL 2 HELP
          "Dispara a Impress∆o do Layout"
     bt-alter AT ROW 10.5 COL 19
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 76.86 BY 10.88.

DEFINE FRAME f-pg-log
     rs-destino AT ROW 2 COL 4.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     c-arquivo-destino AT ROW 3.25 COL 4 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     bt-arquivo-destino AT ROW 3.25 COL 44 HELP
          "Escolha do nome do arquivo"
     bt-config-impr-destino AT ROW 3.25 COL 44 HELP
          "Configuraá∆o da impressora"
     rs-execucao AT ROW 5.38 COL 4.14 HELP
          "Modo de Execuá∆o" NO-LABEL
     rs-todos AT ROW 7.25 COL 4 NO-LABEL
     text-destino AT ROW 1.25 COL 4.86 NO-LABEL
     text-modo AT ROW 4.63 COL 4.14 NO-LABEL
     RECT-7 AT ROW 1.54 COL 3
     RECT-9 AT ROW 4.92 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 76.29 BY 10.75.

DEFINE FRAME f-pg-par
     l-imprime AT ROW 3.96 COL 26
     c-arquivo-entrada AT ROW 8.25 COL 31 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 76.57 BY 10.63.

DEFINE FRAME f-pg-sel
     c-cod-estab-ini AT ROW 3.25 COL 23 COLON-ALIGNED HELP
          ""
     c-cod-estab-fim AT ROW 3.25 COL 51 COLON-ALIGNED HELP
          "" NO-LABEL
     i-cod-canal-venda-ini AT ROW 4.25 COL 23 COLON-ALIGNED HELP
          "Codigo do Canal de Venda"
     i-cod-canal-venda-fim AT ROW 4.25 COL 51 COLON-ALIGNED HELP
          "C¢digo do Canal de Venda" NO-LABEL
     i-cod-gr-cli-ini AT ROW 5.25 COL 23 COLON-ALIGNED HELP
          "C¢digo do Grupo de Clientes"
     i-cod-gr-cli-fim AT ROW 5.25 COL 51 COLON-ALIGNED HELP
          "C¢digo do Grupo de Clientes" NO-LABEL
     c-nome-abrev-ini AT ROW 6.25 COL 23 COLON-ALIGNED HELP
          "Nome abreviado do cliente/fornecedor"
     c-nome-abrev-fim AT ROW 6.25 COL 51 COLON-ALIGNED HELP
          "Nome abreviado do cliente/fornecedor" NO-LABEL
     i-cod-rep-ini AT ROW 7.25 COL 23 COLON-ALIGNED HELP
          "C¢digo do Representante"
     i-cod-rep-fim AT ROW 7.25 COL 51 COLON-ALIGNED HELP
          "C¢digo do Representante" NO-LABEL
     da-dt-inicial AT ROW 8.25 COL 23 COLON-ALIGNED HELP
          "Data inicial do Per°odo das cotas"
     da-dt-final AT ROW 8.25 COL 51 COLON-ALIGNED HELP
          "Data final do Per°odo das cotas" NO-LABEL
     IMAGE-29 AT ROW 8.25 COL 42
     IMAGE-30 AT ROW 8.25 COL 50
     IMAGE-15 AT ROW 3.25 COL 42
     IMAGE-16 AT ROW 3.25 COL 50
     IMAGE-1 AT ROW 4.25 COL 42
     IMAGE-2 AT ROW 4.25 COL 50
     IMAGE-13 AT ROW 5.25 COL 42
     IMAGE-14 AT ROW 5.25 COL 50
     IMAGE-19 AT ROW 6.25 COL 42
     IMAGE-20 AT ROW 6.25 COL 50
     IMAGE-4 AT ROW 7.25 COL 42
     IMAGE-9 AT ROW 7.25 COL 50
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3.04
         SIZE 76.86 BY 10.83.


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
         TITLE              = "Calculo de Cotas"
         HEIGHT             = 15.17
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
{include/w-impor.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-import
   FRAME-NAME                                                           */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-import
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-import
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder IN FRAME f-import
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-left IN FRAME f-import
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-right IN FRAME f-import
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-top IN FRAME f-import
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-pg-lay
                                                                        */
ASSIGN 
       ed-layout:RETURN-INSERTED IN FRAME f-pg-lay  = TRUE
       ed-layout:READ-ONLY IN FRAME f-pg-lay        = TRUE.

/* SETTINGS FOR FRAME f-pg-log
                                                                        */
/* SETTINGS FOR RADIO-SET rs-todos IN FRAME f-pg-log
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-log
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-log     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-log
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-log     = 
                "Execuá∆o".

/* SETTINGS FOR FRAME f-pg-par
                                                                        */
/* SETTINGS FOR EDITOR c-arquivo-entrada IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-estab-fim IN FRAME f-pg-sel
   NO-ENABLE LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                */
/* SETTINGS FOR FILL-IN c-cod-estab-ini IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                          */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-log
/* Query rebuild information for FRAME f-pg-log
     _Query            is NOT OPENED
*/  /* FRAME f-pg-log */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-sel
/* Query rebuild information for FRAME f-pg-sel
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Calculo de Cotas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Calculo de Cotas */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda C-Win
ON CHOOSE OF bt-ajuda IN FRAME f-import /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-lay
&Scoped-define SELF-NAME bt-alter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-alter C-Win
ON CHOOSE OF bt-alter IN FRAME f-pg-lay /* Alterar Layout */
DO:
    def var c-arquivo-conv  as char no-undo.

    IF vrs-layout = 1 THEN
        assign c-arquivo-conv = "loac0410.001".
    ELSE
        assign c-arquivo-conv = "loac0410.002".
    SYSTEM-DIALOG GET-FILE c-arquivo-conv
       FILTERS "*.*" "*.*"
       DEFAULT-EXTENSION "*.*"
       INITIAL-DIR "layout" 
       USE-FILENAME
       UPDATE l-ok.

    if  search(c-arquivo-conv) <> ? then do:
        if  ed-layout:read-file(c-arquivo-conv) in frame f-pg-lay then.
    end.
    else do:
        run utp/ut-msgs.p (input "show",
                           input 2870,
                           input "").     
        return.                   
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-log
&Scoped-define SELF-NAME bt-arquivo-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo-destino C-Win
ON CHOOSE OF bt-arquivo-destino IN FRAME f-pg-log
DO:
    {include/i-imarq.i c-arquivo-destino f-pg-log}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-import
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar C-Win
ON CHOOSE OF bt-cancelar IN FRAME f-import /* Cancelar */
DO:
   apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-log
&Scoped-define SELF-NAME bt-config-impr-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr-destino C-Win
ON CHOOSE OF bt-config-impr-destino IN FRAME f-pg-log
DO:
   {include/i-imimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-lay
&Scoped-define SELF-NAME bt-editar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-editar C-Win
ON CHOOSE OF bt-editar IN FRAME f-pg-lay /* Editar Layout */
DO:                                    
    IF vrs-layout = 1 THEN
        assign c-arq-temp = "loac0410.001".
    ELSE
        assign c-arq-temp = "loac0410.002".
    def var c-linha as char format "x(132)" no-undo.
    input stream s-imp from value(search(c-arq-layout)) no-echo.
    output to value(c-arq-temp) .
    repeat:
    import stream s-imp unformatted c-linha.
    if  c-linha <> "" then
    put c-linha skip.
    else
        put " " skip.
    end.
    output close.
    input stream s-imp close.    
    {include/i-imtrm.i c-arq-temp 3}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-import
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar C-Win
ON CHOOSE OF bt-executar IN FRAME f-import /* Executar */
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
  {include/zoomvar.i &prog-zoom=dizoom/z01di307.w
                     &campo=c-cod-estab-ini
                     &campozoom=cod-estabel
                     &frame={&FRAME-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estab-ini C-Win
ON LEAVE OF c-cod-estab-ini IN FRAME f-pg-sel /* Estab */
DO:
  assign c-cod-estab-fim:screen-value = self:screen-value.
  find first par-cota no-lock where 
             par-cota.cod-estabel = self:screen-value no-error.
  if not avail par-cota then do:
     {utp/ut-table.i mgdis par-cota 1}
     run utp/ut-msgs.p (input "show",
                        input 2,
                        input return-value).
     return no-apply.
  end.  
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


&Scoped-define SELF-NAME c-nome-abrev-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-abrev-ini C-Win
ON F5 OF c-nome-abrev-ini IN FRAME f-pg-sel /* Cliente */
DO:

  {include/zoomvar.i &prog-zoom=adzoom/z02ad098.w
                     &campo=c-nome-abrev-ini
                     &campozoom=nome-abrev
                     &frame={&FRAME-NAME}}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-abrev-ini C-Win
ON MOUSE-SELECT-DBLCLICK OF c-nome-abrev-ini IN FRAME f-pg-sel /* Cliente */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-canal-venda-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-canal-venda-ini C-Win
ON F5 OF i-cod-canal-venda-ini IN FRAME f-pg-sel /* Cod Canal Venda */
DO:
  {include/zoomvar.i &prog-zoom=dizoom/z01di232.w
                     &campo=i-cod-canal-venda-ini
                     &campozoom=cod-canal-venda
                     &frame={&FRAME-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-canal-venda-ini C-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-canal-venda-ini IN FRAME f-pg-sel /* Cod Canal Venda */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-gr-cli-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-gr-cli-ini C-Win
ON F5 OF i-cod-gr-cli-ini IN FRAME f-pg-sel /* Grupo Cliente */
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad129.w
                     &campo=i-cod-gr-cli-ini
                     &campozoom=cod-gr-cli
                     &frame={&FRAME-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-gr-cli-ini C-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-gr-cli-ini IN FRAME f-pg-sel /* Grupo Cliente */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-rep-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-rep-ini C-Win
ON F5 OF i-cod-rep-ini IN FRAME f-pg-sel /* Representante */
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad229.w
                     &campo=i-cod-rep-ini
                     &campozoom=cod-rep
                     &frame={&FRAME-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-rep-ini C-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-rep-ini IN FRAME f-pg-sel /* Representante */
DO:
  apply "F5" to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-import
&Scoped-define SELF-NAME im-pg-lay
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-lay C-Win
ON MOUSE-SELECT-CLICK OF im-pg-lay IN FRAME f-import
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-log
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-log C-Win
ON MOUSE-SELECT-CLICK OF im-pg-log IN FRAME f-import
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-par
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-par C-Win
ON MOUSE-SELECT-CLICK OF im-pg-par IN FRAME f-import
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel C-Win
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-import
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-log
&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino C-Win
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-log
DO:
do  with frame f-pg-log:
    case self:screen-value:
        when "1" then do:
            assign c-arquivo-destino:sensitive     = no
                   bt-arquivo-destino:visible      = no
                   bt-config-impr-destino:visible  = yes.
        end.
        when "2" then do:
            assign c-arquivo-destino:sensitive     = yes
                   bt-arquivo-destino:visible      = yes
                   bt-config-impr-destino:visible  = no.
        end.
        when "3" then do:
            assign c-arquivo-destino:sensitive     = no
                   bt-arquivo-destino:visible      = no
                   bt-config-impr-destino:visible  = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao C-Win
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-log
DO:
   {include/i-imrse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-import
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "AC0410" "2.00.00.016"}

/* inicializaá‰es do template de importaá∆o */
{include/i-imini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

{include/i-imlbl.i}

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:



    /* L¢gica para tratar a data, considerando ano bisexto */

    assign i-dia2 = day(today).
           i-mes  = if month(today) - 1 > 0 then month(today) - 1 else 12.
           i-ano  = if month(today) - 1 > 0 then year(today) else year(today) - 1.
           i-dia  = if i-dia2 < 29 then i-dia2
                    else
                       if  i-mes = 02 then
                           if  i-dia2 > 28 then
                               if  i-ano / 4 = 0 then 29
                               else 28
                           else i-dia2
                       else
                           if  i-mes = 04
                           or  i-mes = 06
                           or  i-mes = 09
                           or  i-mes = 11 then
                               if i-dia2 > 30 then 30
                               else i-dia2
                           else i-dia2.

    assign da-dt-inicial                              = date(i-mes,i-dia,i-ano)
           rs-todos:hidden in frame f-pg-log          = yes
           c-arquivo-entrada:hidden in frame f-pg-par = yes.

    if c-cod-estab-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.    
    if i-cod-canal-venda-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.    
    if i-cod-gr-cli-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.
    if c-nome-abrev-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.
    if i-cod-rep-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.    

    RUN enable_UI.

    {include/i-immbl.i}

    &if '{&BF_DIS_VERSAO_EMS}' >= '2.042' &then
        {include/i-imvrf.i &programa=ac0410 &versao-layout=001}
        ASSIGN vrs-layout = 1.
    &else
        if i-pais-impto-usuario = 1 THEN do:
            {include/i-imvrf.i &programa=ac0410 &versao-layout=001}
            ASSIGN vrs-layout = 1.
        end.        
        else do:
            {include/i-imvrf.i &programa=ac0410 &versao-layout=002}    
            ASSIGN vrs-layout = 2.
        end.   
    &endif

    /* trata estabelecimento */ 
    find first para-ped no-lock no-error.
    if substring(para-ped.char-1,1,3) = "sim" then do:
       assign c-cod-estab-ini:screen-value in frame f-pg-sel = para-ped.estab-padrao
              c-cod-estab-fim:screen-value in frame f-pg-sel = para-ped.estab-padrao
              c-cod-estab-ini:sensitive in frame f-pg-sel    = no  
              c-cod-estab-fim:sensitive in frame f-pg-sel    = no .
       find first par-cota no-lock where 
                  par-cota.cod-estabel = para-ped.estab-padrao no-error.
    end.
    else do:
       find first par-cota no-lock no-error.
       if avail par-cota then
            assign c-cod-estab-ini:screen-value in frame f-pg-sel  = par-cota.cod-estabel
                   c-cod-estab-fim:screen-value in frame f-pg-sel  = par-cota.cod-estabel.
    end.



    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.

END.

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
  ENABLE im-pg-lay im-pg-sel im-pg-par im-pg-log bt-executar bt-cancelar 
         bt-ajuda 
      WITH FRAME f-import IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-import}
  DISPLAY ed-layout 
      WITH FRAME f-pg-lay IN WINDOW C-Win.
  ENABLE ed-layout bt-editar bt-alter 
      WITH FRAME f-pg-lay IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-lay}
  DISPLAY rs-destino c-arquivo-destino rs-execucao 
      WITH FRAME f-pg-log IN WINDOW C-Win.
  ENABLE RECT-7 RECT-9 rs-destino c-arquivo-destino bt-arquivo-destino 
         bt-config-impr-destino rs-execucao 
      WITH FRAME f-pg-log IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-log}
  DISPLAY l-imprime 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  ENABLE l-imprime 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  DISPLAY c-cod-estab-ini c-cod-estab-fim i-cod-canal-venda-ini 
          i-cod-canal-venda-fim i-cod-gr-cli-ini i-cod-gr-cli-fim 
          c-nome-abrev-ini c-nome-abrev-fim i-cod-rep-ini i-cod-rep-fim 
          da-dt-inicial da-dt-final 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  ENABLE IMAGE-29 IMAGE-30 IMAGE-15 IMAGE-16 IMAGE-1 IMAGE-2 IMAGE-13 IMAGE-14 
         IMAGE-19 IMAGE-20 IMAGE-4 IMAGE-9 c-cod-estab-ini 
         i-cod-canal-venda-ini i-cod-canal-venda-fim i-cod-gr-cli-ini 
         i-cod-gr-cli-fim c-nome-abrev-ini c-nome-abrev-fim i-cod-rep-ini 
         i-cod-rep-fim da-dt-inicial da-dt-final 
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

    if  input frame f-pg-log rs-destino = 2 then do:
        run utp/ut-vlarq.p (input input frame f-pg-log c-arquivo-destino).
        if  return-value = "nok" then do:
            run utp/ut-msgs.p (input "show",
                               input 73,
                               input "").
            apply 'mouse-select-click' to im-pg-log in frame f-import.
            apply 'entry' to c-arquivo-destino in frame f-pg-log.                   
            return error.
        end.
    end.

    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame f-pg-log rs-destino
           tt-param.arq-entrada     = input frame f-pg-par c-arquivo-entrada
           tt-param.data-exec       = today
           tt-param.hora-exec       = time.

    if  tt-param.destino = 1 then
        assign tt-param.arq-destino = "".
    else
    if  tt-param.destino = 2 then 
        assign tt-param.arq-destino = input frame f-pg-log c-arquivo-destino.
    else
        assign tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp".

    /* Coloque aqui a l¢gica de gravaá∆o dos parÉmtros e seleá∆o na temp-table
       tt-param */ 

    assign tt-param.cod-estab-ini          = input frame f-pg-sel c-cod-estab-ini
           tt-param.cod-estab-fim          = input frame f-pg-sel c-cod-estab-fim
           tt-param.cod-canal-venda-ini    = input frame f-pg-sel i-cod-canal-venda-ini
           tt-param.cod-canal-venda-fim    = input frame f-pg-sel i-cod-canal-venda-fim
           tt-param.cod-gr-cli-ini         = input frame f-pg-sel i-cod-gr-cli-ini
           tt-param.cod-gr-cli-fim         = input frame f-pg-sel i-cod-gr-cli-fim
           tt-param.nome-abrev-ini         = input frame f-pg-sel c-nome-abrev-ini
           tt-param.nome-abrev-fim         = input frame f-pg-sel c-nome-abrev-fim
           tt-param.cod-rep-ini            = input frame f-pg-sel i-cod-rep-ini
           tt-param.cod-rep-fim            = input frame f-pg-sel i-cod-rep-fim
           tt-param.dt-inicial             = input frame f-pg-sel da-dt-inicial
           tt-param.dt-final               = input frame f-pg-sel da-dt-final
           tt-param.texto                  = input frame f-pg-lay ed-layout
           tt-param.imprime                = input frame f-pg-par l-imprime.

    {include/i-imexb.i}

    if  session:set-wait-state("general") then.


    {include/i-imrun.i acp/ac0410rp.p}

    {include/i-imexc.i}

    if  session:set-wait-state("") then.

    {include/i-imtrm.i tt-param.arq-destino tt-param.destino}

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina C-Win 
PROCEDURE pi-troca-pagina :
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P†gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-imtrp.i}

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
  if input frame f-pg-sel c-cod-estab-fim < input frame f-pg-sel c-cod-estab-ini 
  then do:
     {utp/ut-field.i mgdis cotas cod-estabel 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-import.
     apply 'entry' to c-cod-estab-ini in frame f-pg-sel.
     return error.
  end. 

  if input frame f-pg-sel i-cod-canal-venda-fim < input frame f-pg-sel i-cod-canal-venda-ini 
  then do:
     {utp/ut-field.i mgdis cotas cod-canal-venda 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-import.
     apply 'entry' to i-cod-canal-venda-ini in frame f-pg-sel.
     return error.
  end. 

  if input frame f-pg-sel i-cod-gr-cli-fim < input frame f-pg-sel i-cod-gr-cli-ini 
  then do:
     {utp/ut-field.i mgdis cotas cod-gr-cli 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-import.
     apply 'entry' to i-cod-gr-cli-ini in frame f-pg-sel.
     return error.
  end. 

  if input frame f-pg-sel c-nome-abrev-fim < input frame f-pg-sel c-nome-abrev-ini 
  then do:
     {utp/ut-field.i mgdis cotas nome-abrev 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-import.
     apply 'entry' to c-nome-abrev-ini in frame f-pg-sel.
     return error.
  end.   

  if input frame f-pg-sel i-cod-rep-fim < input frame f-pg-sel i-cod-rep-ini 
  then do:
      {utp/ut-field.i mgdis cotas cod-rep 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-import.
     apply 'entry' to i-cod-rep-ini in frame f-pg-sel.
     return error.
  end. 

  /*****  Uso de pre-processador ******/
  /* 2.03 do dicion†rio */
  &if defined (bf_dis_adm_cotas) &then   
    if (input frame f-pg-sel i-cod-rep-fim = ?  or
        input frame f-pg-sel i-cod-rep-ini = ?) and
        par-cota.log-impl-niveis           = yes          
    then do:
       {utp/ut-field.i mgdis cotas cod-rep 1}
       run utp/ut-msgs.p (input "show",input 7972,input return-value + "~~" + "?").
       apply 'mouse-select-click' to im-pg-sel in frame f-import.
       apply 'entry' to i-cod-rep-fim in frame f-pg-sel.
       return error.
    end.   
  &endif

  if input frame f-pg-sel da-dt-final < input frame f-pg-sel da-dt-inicial 
  then do:
     {utp/ut-liter.i Per°odo MAC c} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-import.
     apply 'entry' to da-dt-inicial in frame f-pg-sel.
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

