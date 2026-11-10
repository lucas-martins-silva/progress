&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-relat 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0504 2.00.00.009 } /*** 010009 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac0504 MAC}
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

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA 
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGDIG 
&GLOBAL-DEFINE PGIMP 

{cdp/cdcfgdis.i} /*include para prÇ-processadores*/

/* Definiá∆o tt-param */
{acp/ac0504.i}  

{include/i_fnctrad.i} /* Multi-Idiomas*/

/* Transfer Definitions */

def var raw-param as raw  no-undo.
DEF VAR cLista    AS CHAR NO-UNDO. 

def temp-table tt-raw-digita
   field raw-digita      as raw.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-pg-par

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-11 rs-chave rs-tipo-2 rs-tipo ~
cb-tip-graf 
&Scoped-Define DISPLAYED-OBJECTS rs-chave rs-tipo-2 rs-tipo cb-tip-graf 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-relat AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE cb-tip-graf AS CHARACTER FORMAT "X(26)":U INITIAL "Pizza 2D" 
     LABEL "Gr†fico" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Pizza 2D","Pizza 3D","Barra 2D","Barra 3D","Linha","µrea 2D","Scatter 2D","Polar","Tape","µrea 3D","Lin/Log","Box-whisker","True 3D Scatter" 
     DROP-DOWN-LIST
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE texto-1 AS CHARACTER FORMAT "X(26)":U INITIAL "Cotas por:" 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE VARIABLE texto-2 AS CHARACTER FORMAT "X(26)":U INITIAL "Tipo Cota:" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE rs-chave AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Estabelecimento", 1,
"Canal Venda", 2,
"Grupo Cliente", 3,
"Cliente", 4,
"Regi∆o", 5,
"Microrregi∆o", 6,
"Representante", 7,
"Produto/Item", 8
     SIZE 23 BY 8 NO-UNDO.

DEFINE VARIABLE rs-tipo AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Cota Prevista", 1,
"Cota Pedida", 2,
"Cota Faturada", 3,
"Cota Pedida Cancelada", 4,
"Cota Faturada Cancelada", 5,
"Cota Pedida Suspensa", 6
     SIZE 28 BY 6.25 NO-UNDO.

DEFINE VARIABLE rs-tipo-2 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Cota Prevista", 1,
"Cota Realizada Pedida", 2,
"Cota Realizada Faturada", 3,
"Cota Pedida Cancelada", 4,
"Cota Faturada Cancelada", 5,
"Cota Pedida Suspensa", 6,
"Cota Pedida Reprovada", 7
     SIZE 28 BY 6.25 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34 BY 7.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28 BY 9.

DEFINE VARIABLE fi-cd-produto-fim AS CHARACTER FORMAT "X(16)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE fi-cd-produto-ini AS CHARACTER FORMAT "X(16)" 
     LABEL "Produto/Item" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE fi-cod-canal-venda-fim AS INTEGER FORMAT ">>9" INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88.

DEFINE VARIABLE fi-cod-canal-venda-ini AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Canal Venda" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88.

DEFINE VARIABLE fi-cod-estabel-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel-ini LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-gr-cli-fim AS INTEGER FORMAT ">>>9" INITIAL 9999 
     VIEW-AS FILL-IN 
     SIZE 5.50 BY .88.

DEFINE VARIABLE fi-cod-gr-cli-ini AS INTEGER FORMAT ">>>9" INITIAL 0 
     LABEL "Grupo Cliente" 
     VIEW-AS FILL-IN 
     SIZE 5.50 BY .88.

DEFINE VARIABLE fi-cod-rep-fim AS INTEGER FORMAT ">>>>9" INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88.

DEFINE VARIABLE fi-cod-rep-ini AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Representante" 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88.

DEFINE VARIABLE fi-data-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/2100 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE fi-data-ini AS DATE FORMAT "99/99/9999" 
     LABEL "Per°odo" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE fi-nome-ab-reg-fim AS CHARACTER FORMAT "X(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88.

DEFINE VARIABLE fi-nome-ab-reg-ini AS CHARACTER FORMAT "X(12)" 
     LABEL "Regi∆o" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88.

DEFINE VARIABLE fi-nome-abrev-fim AS CHARACTER FORMAT "x(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88.

DEFINE VARIABLE fi-nome-abrev-ini AS CHARACTER FORMAT "x(12)" 
     LABEL "Cliente":R9 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88.

DEFINE VARIABLE fi-nome-mic-reg-fim AS CHARACTER FORMAT "X(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88.

DEFINE VARIABLE fi-nome-mic-reg-ini AS CHARACTER FORMAT "X(8)" 
     LABEL "Microrregi∆o" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image~\im-las":U
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

DEFINE IMAGE IMAGE-17
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image~\im-las":U
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

DEFINE IMAGE IMAGE-9
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "&Gr†fico" 
     SIZE 10 BY 1.

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

DEFINE FRAME f-relat
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execuá∆o do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Fechar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     RECT-1 AT ROW 14.29 COL 2
     rt-folder-right AT ROW 2.67 COL 80.43
     RECT-6 AT ROW 13.75 COL 2.14
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder AT ROW 2.5 COL 2
     im-pg-par AT ROW 1.5 COL 18
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15.

DEFINE FRAME f-pg-par
     rs-chave AT ROW 2.25 COL 4 NO-LABEL
     rs-tipo-2 AT ROW 2.25 COL 41 NO-LABEL
     rs-tipo AT ROW 2.25 COL 41 NO-LABEL
     cb-tip-graf AT ROW 9.5 COL 37 COLON-ALIGNED
     texto-1 AT ROW 1.5 COL 4 COLON-ALIGNED NO-LABEL
     texto-2 AT ROW 1.5 COL 41 COLON-ALIGNED NO-LABEL
     RECT-10 AT ROW 1.75 COL 39
     RECT-11 AT ROW 1.75 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 75 BY 10.21.

DEFINE FRAME f-pg-sel
     fi-cod-estabel-ini AT ROW 1.75 COL 21 COLON-ALIGNED
     fi-cod-estabel-fim AT ROW 1.75 COL 52 COLON-ALIGNED NO-LABEL
     fi-cod-canal-venda-ini AT ROW 2.75 COL 21 COLON-ALIGNED HELP
          "C¢digo do canal de venda"
     fi-cod-canal-venda-fim AT ROW 2.75 COL 52 COLON-ALIGNED HELP
          "C¢digo do canal de venda" NO-LABEL
     fi-cod-gr-cli-ini AT ROW 3.75 COL 21 COLON-ALIGNED HELP
          "Grupo do cliente"
     fi-cod-gr-cli-fim AT ROW 3.75 COL 52 COLON-ALIGNED HELP
          "Grupo do cliente" NO-LABEL
     fi-nome-abrev-ini AT ROW 4.75 COL 21 COLON-ALIGNED HELP
          "Nome abreviado do cliente"
     fi-nome-abrev-fim AT ROW 4.75 COL 52 COLON-ALIGNED HELP
          "Nome abreviado do cliente" NO-LABEL
     fi-nome-ab-reg-ini AT ROW 5.75 COL 21 COLON-ALIGNED HELP
          "Nome da regi∆o"
     fi-nome-ab-reg-fim AT ROW 5.75 COL 52 COLON-ALIGNED HELP
          "Nome da regi∆o" NO-LABEL
     fi-nome-mic-reg-ini AT ROW 6.75 COL 21 COLON-ALIGNED HELP
          "Nome da Microrregi∆o"
     fi-nome-mic-reg-fim AT ROW 6.75 COL 52 COLON-ALIGNED HELP
          "Nome da Microrregi∆o" NO-LABEL
     fi-cod-rep-ini AT ROW 7.75 COL 21 COLON-ALIGNED HELP
          "C¢digo do representante"
     fi-cod-rep-fim AT ROW 7.75 COL 52 COLON-ALIGNED HELP
          "C¢digo do representante" NO-LABEL
     fi-cd-produto-ini AT ROW 8.75 COL 21 COLON-ALIGNED HELP
          "C¢digo do produto ou item"
     fi-cd-produto-fim AT ROW 8.75 COL 52 COLON-ALIGNED HELP
          "C¢digo do produto ou item" NO-LABEL
     fi-data-ini AT ROW 9.75 COL 21 COLON-ALIGNED HELP
          "Data inicial do per°odo das cotas"
     fi-data-fim AT ROW 9.75 COL 52 COLON-ALIGNED HELP
          "Data inicial do per°odo das cotas" NO-LABEL
     IMAGE-1 AT ROW 8.75 COL 41
     IMAGE-10 AT ROW 7.75 COL 50
     IMAGE-11 AT ROW 5.75 COL 41
     IMAGE-12 AT ROW 5.75 COL 50
     IMAGE-13 AT ROW 6.75 COL 41
     IMAGE-14 AT ROW 6.75 COL 50
     IMAGE-15 AT ROW 9.75 COL 41
     IMAGE-16 AT ROW 9.75 COL 50
     IMAGE-17 AT ROW 4.75 COL 41
     IMAGE-18 AT ROW 4.75 COL 50
     IMAGE-2 AT ROW 8.75 COL 50
     IMAGE-3 AT ROW 2.75 COL 41
     IMAGE-4 AT ROW 2.75 COL 50
     IMAGE-5 AT ROW 1.75 COL 41
     IMAGE-6 AT ROW 1.75 COL 50
     IMAGE-7 AT ROW 3.75 COL 41
     IMAGE-8 AT ROW 3.75 COL 50
     IMAGE-9 AT ROW 7.75 COL 41
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 76.86 BY 10.62.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-relat ASSIGN
         HIDDEN             = YES
         TITLE              = "<Title>"
         HEIGHT             = 15
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-relat 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-relat
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-pg-par
                                                                        */
/* SETTINGS FOR FILL-IN texto-1 IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN texto-2 IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FILL-IN fi-cod-estabel-fim IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel                                   */
/* SETTINGS FOR FILL-IN fi-cod-estabel-ini IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel                                   */
/* SETTINGS FOR FRAME f-relat
                                                                        */
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
THEN w-relat:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-sel
/* Query rebuild information for FRAME f-pg-sel
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON END-ERROR OF w-relat /* <Title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON WINDOW-CLOSE OF w-relat /* <Title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-relat
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-relat
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Fechar */
DO:
   apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar w-relat
ON CHOOSE OF bt-executar IN FRAME f-relat /* Gr†fico */
DO:
   do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-par
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-par w-relat
ON MOUSE-SELECT-CLICK OF im-pg-par IN FRAME f-relat
DO:
    run pi-troca-pagina.



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel w-relat
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-relat 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "AC0504" "2.00.00.008"}

/* inicializaá‰es do template de relat¢rio */
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

    RUN enable_UI.

    /************************************************************ 
    *  PrÇ-Processador para o m¢dulo de Administraá∆o de Cotas
    ************************************************************/

    &if defined (bf_dis_adm_cotas) &then
        assign rs-tipo:hidden in frame {&frame-name}    = yes
               rs-tipo-2:hidden in frame {&frame-name}  = no.
    &else
        assign rs-tipo:hidden in frame {&frame-name}    = no
               rs-tipo-2:hidden in frame {&frame-name}  = yes.
    &endif

    apply "mouse-select-click" to im-pg-sel in frame f-relat.
    assign fi-data-ini:screen-value in frame f-pg-sel = string(today).
    {utp/ut-liter.i Cotas_por MAC c}
    assign texto-1:screen-value in frame f-pg-par = trim(return-value).
    {utp/ut-liter.i Tipo_Cota MAC c}
    assign texto-2:screen-value in frame f-pg-par = trim(return-value).

    find first par-cota no-lock no-error.

if par-cota.Cont-canal-venda = no then
    if rs-chave:disable(entry(3, rs-chave:radio-buttons in frame f-pg-par)) in frame f-pg-par then.  
if par-cota.Cont-gr-cli = no then
    if rs-chave:disable(entry(5, rs-chave:radio-buttons in frame f-pg-par)) in frame f-pg-par then.  
if par-cota.Cont-cliente = no then
    if rs-chave:disable(entry(7, rs-chave:radio-buttons in frame f-pg-par)) in frame f-pg-par then.  
if par-cota.Cont-ab-reg = no then
    if rs-chave:disable(entry(9, rs-chave:radio-buttons in frame f-pg-par)) in frame f-pg-par then.  
if par-cota.Cont-mic-reg = no then
    if rs-chave:disable(entry(11, rs-chave:radio-buttons in frame f-pg-par)) in frame f-pg-par then.  
if par-cota.Cont-produto = no then
    if rs-chave:disable(entry(15, rs-chave:radio-buttons in frame f-pg-par)) in frame f-pg-par then.  

    &IF "{&fnc_multi_idioma}" = "yes" &THEN
        ASSIGN cLista = "Pizza 2D,Pizza 3D,Barra 2D,Barra 3D,Linha,µrea 2D,Scatter 2D,Polar,Tape,µrea 3D,Lin/Log,Box-whisker,True 3D Scatter".
        RUN utp/ut-lstit.p (INPUT-OUTPUT cLista).
        ASSIGN cb-tip-graf:LIST-ITEM-PAIRS IN FRAME f-pg-par = cLista
               cb-tip-graf:SCREEN-VALUE    IN FRAME f-pg-par = ENTRY(1,cLista,",").
    &ENDIF

    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

&IF "{&mguni_version}" >= "2.071" &THEN
ASSIGN fi-cod-estabel-fim:SCREEN-VALUE IN FRAME f-pg-sel = "ZZZZZ".
&ELSE
ASSIGN fi-cod-estabel-fim:SCREEN-VALUE IN FRAME f-pg-sel = "ZZZ".
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-relat  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-relat  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-relat  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
  THEN DELETE WIDGET w-relat.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-relat  _DEFAULT-ENABLE
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
  ENABLE im-pg-par im-pg-sel bt-executar bt-cancelar bt-ajuda 
      WITH FRAME f-relat IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY fi-cod-estabel-ini fi-cod-estabel-fim fi-cod-canal-venda-ini 
          fi-cod-canal-venda-fim fi-cod-gr-cli-ini fi-cod-gr-cli-fim 
          fi-nome-abrev-ini fi-nome-abrev-fim fi-nome-ab-reg-ini 
          fi-nome-ab-reg-fim fi-nome-mic-reg-ini fi-nome-mic-reg-fim 
          fi-cod-rep-ini fi-cod-rep-fim fi-cd-produto-ini fi-cd-produto-fim 
          fi-data-ini fi-data-fim 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  ENABLE IMAGE-1 IMAGE-10 IMAGE-11 IMAGE-12 IMAGE-13 IMAGE-14 IMAGE-15 IMAGE-16 
         IMAGE-17 IMAGE-18 IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-5 IMAGE-6 IMAGE-7 
         IMAGE-8 IMAGE-9 fi-cod-estabel-ini fi-cod-estabel-fim 
         fi-cod-canal-venda-ini fi-cod-canal-venda-fim fi-cod-gr-cli-ini 
         fi-cod-gr-cli-fim fi-nome-abrev-ini fi-nome-abrev-fim 
         fi-nome-ab-reg-ini fi-nome-ab-reg-fim fi-nome-mic-reg-ini 
         fi-nome-mic-reg-fim fi-cod-rep-ini fi-cod-rep-fim fi-cd-produto-ini 
         fi-cd-produto-fim fi-data-ini fi-data-fim 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  DISPLAY rs-chave rs-tipo-2 rs-tipo cb-tip-graf 
      WITH FRAME f-pg-par IN WINDOW w-relat.
  ENABLE RECT-10 RECT-11 rs-chave rs-tipo-2 rs-tipo cb-tip-graf 
      WITH FRAME f-pg-par IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  VIEW w-relat.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-relat 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar w-relat 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

do on error undo, return error on stop  undo, return error:

                                                                                                            

    /* Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
       problemas e colocar o focus no campo com problemas */

    run pi-validate.    

    /* Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
       para o programa RP.P */

    create tt-param.
    assign tt-param.cod-estab-ini       = input frame f-pg-sel fi-cod-estabel-ini
           tt-param.cod-estab-fim       = input frame f-pg-sel fi-cod-estabel-fim
           tt-param.cod-canal-venda-ini = input frame f-pg-sel fi-cod-canal-venda-ini
           tt-param.cod-canal-venda-fim = input frame f-pg-sel fi-cod-canal-venda-fim
           tt-param.cod-gr-cli-ini      = input frame f-pg-sel fi-cod-gr-cli-ini
           tt-param.cod-gr-cli-fim      = input frame f-pg-sel fi-cod-gr-cli-fim
           tt-param.nome-abrev-ini      = input frame f-pg-sel fi-nome-abrev-ini
           tt-param.nome-abrev-fim      = input frame f-pg-sel fi-nome-abrev-fim
           tt-param.nome-ab-reg-ini     = input frame f-pg-sel fi-nome-ab-reg-ini
           tt-param.nome-ab-reg-fim     = input frame f-pg-sel fi-nome-ab-reg-fim
           tt-param.nome-mic-reg-ini    = input frame f-pg-sel fi-nome-mic-reg-ini  
           tt-param.nome-mic-reg-fim    = input frame f-pg-sel fi-nome-mic-reg-fim  
           tt-param.cod-rep-ini         = input frame f-pg-sel fi-cod-rep-ini
           tt-param.cod-rep-fim         = input frame f-pg-sel fi-cod-rep-fim
           tt-param.cd-produto-ini      = input frame f-pg-sel fi-cd-produto-ini
           tt-param.cd-produto-fim      = input frame f-pg-sel fi-cd-produto-fim
           tt-param.dt-inicial          = input frame f-pg-sel fi-data-ini
           tt-param.dt-final            = input frame f-pg-sel fi-data-fim
           tt-param.i-chave             = input frame f-pg-par rs-chave.

    &IF "{&fnc_multi_idioma}" = "yes" &THEN
        IF lookup(input frame f-pg-par cb-tip-graf,cb-tip-graf:LIST-ITEM-PAIRS,",") MOD 2 <> 0 THEN
            ASSIGN  tt-param.i-grafico = (lookup(input frame f-pg-par cb-tip-graf,cb-tip-graf:LIST-ITEM-PAIRS,",") + 1) / 2.
        ELSE
            ASSIGN  tt-param.i-grafico = lookup(input frame f-pg-par cb-tip-graf,cb-tip-graf:LIST-ITEM-PAIRS,",") / 2.
    &ELSE
        ASSIGN  tt-param.i-grafico = lookup(input frame f-pg-par cb-tip-graf,cb-tip-graf:list-items).
    &ENDIF                               

   /************************************************************ 
   *  PrÇ-Processador para o m¢dulo de Administraá∆o de Cotas
   ************************************************************/

    &if defined (bf_dis_adm_cotas) &then
        assign  tt-param.i-tipo              = input frame f-pg-par rs-tipo-2.
    &else
        assign  tt-param.i-tipo              = input frame f-pg-par rs-tipo.
    &endif

    /* Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
       como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */

    SESSION:SET-WAIT-STATE("general":U).

    raw-transfer tt-param    to raw-param.


    run acp/ac0504rp.p (input raw-param). 

    SESSION:SET-WAIT-STATE("":U).

end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina w-relat 
PROCEDURE pi-troca-pagina :
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P†gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate w-relat 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  if input frame f-pg-sel fi-cod-estabel-fim < input frame f-pg-sel fi-cod-estabel-ini 
  then do:
     {utp/ut-field.i mgdis cotas cod-estabel 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to fi-cod-estabel-ini in frame f-pg-sel.
     return error.
  end. 

  if input frame f-pg-sel fi-cod-canal-venda-fim < input frame f-pg-sel fi-cod-canal-venda-ini 
  then do:
     {utp/ut-field.i mgdis cotas cod-canal-venda 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to fi-cod-canal-venda-ini in frame f-pg-sel.
     return error.
  end. 

  if input frame f-pg-sel fi-cod-gr-cli-fim < input frame f-pg-sel fi-cod-gr-cli-ini 
  then do:
     {utp/ut-field.i mgdis cotas cod-gr-cli 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to fi-cod-gr-cli-ini in frame f-pg-sel.
     return error.
  end. 

  if input frame f-pg-sel fi-nome-abrev-fim < input frame f-pg-sel fi-nome-abrev-ini 
  then do:
     {utp/ut-field.i mgdis cotas nome-abrev 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to fi-nome-abrev-ini in frame f-pg-sel.
     return error.
  end.   

  if input frame f-pg-sel fi-nome-ab-reg-fim < input frame f-pg-sel fi-nome-ab-reg-ini 
  then do:
     {utp/ut-field.i mgdis cotas nome-ab-reg 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to fi-nome-ab-reg-ini in frame f-pg-sel.
     return error.
  end. 

  if input frame f-pg-sel fi-nome-mic-reg-fim < input frame f-pg-sel fi-nome-mic-reg-ini 
  then do:
     {utp/ut-field.i mgdis cotas nome-mic-reg 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to fi-nome-mic-reg-ini in frame f-pg-sel.
     return error.
  end. 

  if input frame f-pg-sel fi-cod-rep-fim < input frame f-pg-sel fi-cod-rep-ini 
  then do:
      {utp/ut-field.i mgdis cotas cod-rep 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to fi-cod-rep-ini in frame f-pg-sel.
     return error.
  end. 

  if input frame f-pg-sel fi-cd-produto-fim < input frame f-pg-sel fi-cd-produto-ini 
  then do:
     {utp/ut-field.i mgdis cotas cd-produto 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to fi-cd-produto-ini in frame f-pg-sel.
     return error.
  end. 

  if input frame f-pg-sel fi-data-fim < input frame f-pg-sel fi-data-ini 
  then do:
     {utp/ut-liter.i Per°odo MAC C} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to fi-data-ini in frame f-pg-sel.
     return error.
  end. 



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-relat  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-relat 
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

