&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mgdis            PROGRESS
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
{include/i-prgvrs.i AC0415 2.00.00.005 } /*** 010005 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac0415 MAC}
&ENDIF

/*------------------------------------------------------------------------

  File:                ac0415.w

  Description:         

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:             Datasul S/A 

  Created:            Datasul S/A

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

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


/* Temporary Table Definitions ---                                      */

define temp-table tt-param
    field destino              as integer
    field arquivo              as char
    field usuario              as char format "x(12)"
    field data-exec            as date
    field hora-exec            as integer
    field classifica           as integer
    field desc-classifica      as char format "x(40)"
    field cod-estab-ini        like cotas.cod-estabel
    field cod-estab-fim        like cotas.cod-estabel
    field cod-canal-venda-ini  like cotas.cod-canal-venda
    field cod-canal-venda-fim  like cotas.cod-canal-venda
    field cod-gr-cli-ini       like cotas.cod-gr-cli
    field cod-gr-cli-fim       like cotas.cod-gr-cli
    field nome-abrev-ini       like emitente.nome-abrev
    field nome-abrev-fim       like emitente.nome-abrev
    field nome-ab-reg-ini      like cotas.nome-ab-reg
    field nome-ab-reg-fim      like cotas.nome-ab-reg
    field nome-mic-reg-ini     like cotas.nome-mic-reg
    field nome-mic-reg-fim     like cotas.nome-mic-reg
    field cod-rep-ini          like cotas.cod-rep
    field cod-rep-fim          like cotas.cod-rep
    field cd-produto-ini       like cotas.cd-produto
    field cd-produto-fim       like cotas.cd-produto
    field dt-inicial           like cotas.dt-inicial.


/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

/* Local Variable Definitions ---                                       */

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var i-selec-zoom       as integer init 1  no-undo.

/* Include Pre-processadores */
{cdp/cdcfgdis.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-pg-imp

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cotas

/* Definitions for FRAME f-pg-par                                       */
&Scoped-define QUERY-STRING-f-pg-par FOR EACH cotas NO-LOCK
&Scoped-define OPEN-QUERY-f-pg-par OPEN QUERY f-pg-par FOR EACH cotas NO-LOCK.
&Scoped-define TABLES-IN-QUERY-f-pg-par cotas
&Scoped-define FIRST-TABLE-IN-QUERY-f-pg-par cotas


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-7 RECT-9 rs-destino bt-arquivo ~
bt-config-impr c-arquivo rs-execucao 
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

DEFINE VARIABLE da-dt-inicial AS DATE FORMAT "99/99/9999" INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Per¡odo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE c-cd-produto-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cd-produto-ini AS CHARACTER FORMAT "X(16)" 
     LABEL "Produto/Item" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE c-cod-estab-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estab-ini LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-ab-reg-fim AS CHARACTER FORMAT "X(12)" INITIAL "ZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-ab-reg-ini AS CHARACTER FORMAT "X(12)" 
     LABEL "Nome RegiÆo" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88.

DEFINE VARIABLE c-nome-abrev-fim AS CHARACTER FORMAT "X(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88.

DEFINE VARIABLE c-nome-abrev-ini AS CHARACTER FORMAT "X(12)" 
     LABEL "Cliente":R17 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88.

DEFINE VARIABLE c-nome-mic-reg-fim AS CHARACTER FORMAT "X(12)" INITIAL "ZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88.

DEFINE VARIABLE c-nome-mic-reg-ini AS CHARACTER FORMAT "X(12)" 
     LABEL "MicrorregiÆo" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88.

DEFINE VARIABLE i-cod-canal-venda-fim AS INTEGER FORMAT ">>9" INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-canal-venda-ini AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Canal Venda" 
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

DEFINE IMAGE IMAGE-11
     FILENAME "image~\im-las":U
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
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image~\im-fir":U
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

DEFINE IMAGE IMAGE-4
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar" 
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
     SIZE 79 BY 11.13
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

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY f-pg-par FOR 
      cotas SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     bt-arquivo AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     bt-config-impr AT ROW 3.58 COL 43.29 HELP
          "Configura‡Æo da impressora"
     c-arquivo AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 5.75 COL 3 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 3 ROW 3
         SIZE 76.86 BY 10.31.

DEFINE FRAME f-pg-sel
     c-cod-estab-ini AT ROW 1.5 COL 20 COLON-ALIGNED
     c-cod-estab-fim AT ROW 1.58 COL 48.86 COLON-ALIGNED NO-LABEL
     i-cod-canal-venda-ini AT ROW 2.5 COL 20 COLON-ALIGNED HELP
          "C¢digo do Canal de Venda"
     i-cod-canal-venda-fim AT ROW 2.5 COL 48.86 COLON-ALIGNED HELP
          "C¢digo do Canal de Venda" NO-LABEL
     i-cod-gr-cli-ini AT ROW 3.5 COL 20 COLON-ALIGNED HELP
          "Grupo de Cliente"
     i-cod-gr-cli-fim AT ROW 3.5 COL 48.86 COLON-ALIGNED HELP
          "Grupo de Cliente" NO-LABEL
     c-nome-abrev-ini AT ROW 4.5 COL 20 COLON-ALIGNED HELP
          "Nome abreviado do cliente/fornecedor"
     c-nome-abrev-fim AT ROW 4.5 COL 49 COLON-ALIGNED HELP
          "Nome abreviado do cliente/fornecedor" NO-LABEL
     c-nome-ab-reg-ini AT ROW 5.5 COL 20 COLON-ALIGNED HELP
          "Nome da regiÆo"
     c-nome-ab-reg-fim AT ROW 5.5 COL 48.86 COLON-ALIGNED HELP
          "Nome da RegiÆo" NO-LABEL
     c-nome-mic-reg-ini AT ROW 6.5 COL 20 COLON-ALIGNED HELP
          "Nome da MicrorregiÆo"
     c-nome-mic-reg-fim AT ROW 6.5 COL 48.86 COLON-ALIGNED HELP
          "Nome da MicrorregiÆo" NO-LABEL
     i-cod-rep-ini AT ROW 7.5 COL 20 COLON-ALIGNED HELP
          "C¢digo do Representante"
     i-cod-rep-fim AT ROW 7.5 COL 48.86 COLON-ALIGNED HELP
          "C¢digo do Representante" NO-LABEL
     c-cd-produto-ini AT ROW 8.5 COL 20 COLON-ALIGNED HELP
          "C¢digo do Produto/Item"
     c-cd-produto-fim AT ROW 8.5 COL 48.86 COLON-ALIGNED HELP
          "C¢digo do Produto/Item" NO-LABEL
     IMAGE-15 AT ROW 1.58 COL 39.57
     IMAGE-16 AT ROW 1.58 COL 47.29
     IMAGE-1 AT ROW 2.5 COL 39.57
     IMAGE-2 AT ROW 2.5 COL 47.29
     IMAGE-13 AT ROW 3.5 COL 39.57
     IMAGE-14 AT ROW 3.5 COL 47.29
     IMAGE-19 AT ROW 4.5 COL 39.57
     IMAGE-20 AT ROW 4.5 COL 47.29
     IMAGE-7 AT ROW 5.5 COL 39.57
     IMAGE-12 AT ROW 5.5 COL 47.29
     IMAGE-6 AT ROW 6.5 COL 39.57
     IMAGE-11 AT ROW 6.5 COL 47.29
     IMAGE-4 AT ROW 7.5 COL 39.57
     IMAGE-9 AT ROW 7.5 COL 47.29
     IMAGE-18 AT ROW 8.5 COL 39.57
     IMAGE-17 AT ROW 8.5 COL 47.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 3 ROW 3
         SIZE 76.86 BY 10.31.

DEFINE FRAME f-relat
     bt-executar AT ROW 14.5 COL 3 HELP
          "Dispara a execu‡Æo do relat¢rio"
     bt-cancelar AT ROW 14.5 COL 14 HELP
          "Cancelar"
     bt-ajuda AT ROW 14.5 COL 70 HELP
          "Ajuda"
     im-pg-sel AT ROW 1.5 COL 2.14
     im-pg-par AT ROW 1.5 COL 17.86
     im-pg-imp AT ROW 1.5 COL 33.57
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     rt-folder AT ROW 2.75 COL 2
     rt-folder-top AT ROW 2.75 COL 2
     RECT-6 AT ROW 13.75 COL 2.14
     RECT-1 AT ROW 14.25 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-par
     da-dt-inicial AT ROW 3 COL 22 COLON-ALIGNED HELP
          "Data inicial do Per¡odo das cotas"
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 77 BY 10.5.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-relat
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Altera‡äes Cotas Realizadas"
         HEIGHT             = 15.17
         WIDTH              = 81.29
         MAX-HEIGHT         = 23.17
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 23.17
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
/* REPARENT FRAME */
ASSIGN FRAME f-pg-par:FRAME = FRAME f-relat:HANDLE.

/* SETTINGS FOR FRAME f-pg-imp
   UNDERLINE                                                            */
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
/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-estab-fim IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel                                   */
/* SETTINGS FOR FILL-IN c-cod-estab-ini IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                          */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-par
/* Query rebuild information for FRAME f-pg-par
     _TblList          = "mgdis.cotas"
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* FRAME f-pg-par */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-sel
/* Query rebuild information for FRAME f-pg-sel
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Altera‡äes Cotas Realizadas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Altera‡äes Cotas Realizadas */
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
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Cancelar */
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
&Scoped-define SELF-NAME c-cd-produto-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-produto-ini C-Win
ON F5 OF c-cd-produto-ini IN FRAME f-pg-sel /* Produto/Item */
DO:
    run cdp/cd9019.w (input-output i-selec-zoom).

    if  i-selec-zoom = 1  then do:
        {include/zoomvar.i &prog-zoom=inzoom/z01in172.w
                           &campo=c-cd-produto-ini
                           &campozoom=it-codigo
                           &frame={&FRAME-NAME}}
    end.
    else do:
        /**************** USO DE PRE-PROCESSADOR *********************/
        &IF DEFINED (bf_dis_adm_cotas) &THEN
            {include/zoomvar.i &prog-zoom=dizoom/z01di292.w
                               &campo=c-cd-produto-ini
                               &campozoom=cod-produto-coml
                               &ExcludeVar=yes
                               &frame={&FRAME-NAME}}
        &ELSE
            {include/zoomvar.i &prog-zoom=inzoom/z01in360.w
                               &campo=c-cd-produto-ini
                               &campozoom=cd-produto
                               &ExcludeVar=yes
                               &frame={&FRAME-NAME}}
        &ENDIF
    end.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-produto-ini C-Win
ON MOUSE-SELECT-DBLCLICK OF c-cd-produto-ini IN FRAME f-pg-sel /* Produto/Item */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
ON MOUSE-SELECT-DBLCLICK OF c-cod-estab-ini IN FRAME f-pg-sel /* Estab */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nome-ab-reg-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-ab-reg-ini C-Win
ON F5 OF c-nome-ab-reg-ini IN FRAME f-pg-sel /* Nome RegiÆo */
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad218.w
                     &campo=c-nome-ab-reg-ini
                     &campozoom=nome-ab-reg
                     &frame={&FRAME-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-ab-reg-ini C-Win
ON MOUSE-SELECT-DBLCLICK OF c-nome-ab-reg-ini IN FRAME f-pg-sel /* Nome RegiÆo */
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


&Scoped-define SELF-NAME c-nome-mic-reg-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-mic-reg-ini C-Win
ON F5 OF c-nome-mic-reg-ini IN FRAME f-pg-sel /* MicrorregiÆo */
DO:
  {include/zoomvar.i &prog-zoom=dizoom/z01di107.w
                     &campo=c-nome-mic-reg-ini
                     &campozoom=nome-mic-reg
                     &frame={&FRAME-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-mic-reg-ini C-Win
ON MOUSE-SELECT-DBLCLICK OF c-nome-mic-reg-ini IN FRAME f-pg-sel /* MicrorregiÆo */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-canal-venda-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-canal-venda-ini C-Win
ON F5 OF i-cod-canal-venda-ini IN FRAME f-pg-sel /* Canal Venda */
DO:
  {include/zoomvar.i &prog-zoom=dizoom/z01di232.w
                     &campo=i-cod-canal-venda-ini
                     &campozoom=cod-canal-venda
                     &frame={&FRAME-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-canal-venda-ini C-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-canal-venda-ini IN FRAME f-pg-sel /* Canal Venda */
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

{utp/ut9000.i "AC0415" "2.00.00.004"}

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

    assign da-dt-inicial = (date(month(today),01,year(today))) - 1.

    RUN enable_UI.
    if c-cod-estab-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.    
    if i-cod-canal-venda-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.    
    if i-cod-gr-cli-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.
    if c-nome-abrev-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.
    if c-nome-ab-reg-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.    
    if c-nome-mic-reg-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.    
    if i-cod-rep-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.    
    if c-cd-produto-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.    

   {include/i-rpmbl.i}

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
  ENABLE RECT-7 RECT-9 rs-destino bt-arquivo bt-config-impr c-arquivo 
         rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}

  {&OPEN-QUERY-f-pg-par}
  GET FIRST f-pg-par.
  DISPLAY da-dt-inicial 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  ENABLE da-dt-inicial 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  DISPLAY c-cod-estab-ini c-cod-estab-fim i-cod-canal-venda-ini 
          i-cod-canal-venda-fim i-cod-gr-cli-ini i-cod-gr-cli-fim 
          c-nome-abrev-ini c-nome-abrev-fim c-nome-ab-reg-ini c-nome-ab-reg-fim 
          c-nome-mic-reg-ini c-nome-mic-reg-fim i-cod-rep-ini i-cod-rep-fim 
          c-cd-produto-ini c-cd-produto-fim 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  ENABLE IMAGE-15 IMAGE-16 IMAGE-1 IMAGE-2 IMAGE-13 IMAGE-14 IMAGE-19 IMAGE-20 
         IMAGE-7 IMAGE-12 IMAGE-6 IMAGE-11 IMAGE-4 IMAGE-9 IMAGE-18 IMAGE-17 
         c-cod-estab-ini c-cod-estab-fim i-cod-canal-venda-ini 
         i-cod-canal-venda-fim i-cod-gr-cli-ini i-cod-gr-cli-fim 
         c-nome-abrev-ini c-nome-abrev-fim c-nome-ab-reg-ini c-nome-ab-reg-fim 
         c-nome-mic-reg-ini c-nome-mic-reg-fim i-cod-rep-ini i-cod-rep-fim 
         c-cd-produto-ini c-cd-produto-fim 
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

    /* Coloque aqui as valida‡äes das outras p ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p gina 
       com problemas e colocar o focus no campo com problemas             */    

    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame f-pg-imp rs-destino
           tt-param.data-exec       = today
           tt-param.hora-exec       = time.

    if  tt-param.destino = 1 then           
        assign tt-param.arquivo = "".
    else
    if  tt-param.destino = 2 then 
        assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
    else
        assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".

    /* Coloque aqui a l¢gica de grava‡Æo dos parƒmtros e sele‡Æo na temp-table
       tt-param */ 

    assign tt-param.cod-estab-ini          = input frame f-pg-sel c-cod-estab-ini
           tt-param.cod-estab-fim          = input frame f-pg-sel c-cod-estab-fim
           tt-param.cod-canal-venda-ini    = input frame f-pg-sel i-cod-canal-venda-ini
           tt-param.cod-canal-venda-fim    = input frame f-pg-sel i-cod-canal-venda-fim
           tt-param.cod-gr-cli-ini         = input frame f-pg-sel i-cod-gr-cli-ini
           tt-param.cod-gr-cli-fim         = input frame f-pg-sel i-cod-gr-cli-fim
           tt-param.nome-abrev-ini         = input frame f-pg-sel c-nome-abrev-ini
           tt-param.nome-abrev-fim         = input frame f-pg-sel c-nome-abrev-fim
           tt-param.nome-ab-reg-ini        = input frame f-pg-sel c-nome-ab-reg-ini
           tt-param.nome-ab-reg-fim        = input frame f-pg-sel c-nome-ab-reg-fim
           tt-param.nome-mic-reg-ini       = input frame f-pg-sel c-nome-mic-reg-ini
           tt-param.nome-mic-reg-fim       = input frame f-pg-sel c-nome-mic-reg-fim
           tt-param.cod-rep-ini            = input frame f-pg-sel i-cod-rep-ini
           tt-param.cod-rep-fim            = input frame f-pg-sel i-cod-rep-fim
           tt-param.cd-produto-ini         = input frame f-pg-sel c-cd-produto-ini
           tt-param.cd-produto-fim         = input frame f-pg-sel c-cd-produto-fim
           tt-param.dt-inicial             = input frame f-pg-par da-dt-inicial.

    {include/i-rpexb.i}

    if  session:set-wait-state("general") then.

    {include/i-rprun.i acp/ac0415rp.p}

    {include/i-rpexc.i}

    if  session:set-wait-state("") then.

    {include/i-rptrm.i}

end.

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
  if input frame f-pg-sel c-cod-estab-fim < input frame f-pg-sel c-cod-estab-ini 
  then do:
     {utp/ut-field.i mgdis cotas cod-estabel 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to c-cod-estab-ini in frame f-pg-sel.
     return error.
  end. 

  if input frame f-pg-sel i-cod-canal-venda-fim < input frame f-pg-sel i-cod-canal-venda-ini 
  then do:
     {utp/ut-field.i mgdis cotas cod-canal-venda 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to i-cod-canal-venda-ini in frame f-pg-sel.
     return error.
  end. 

  if input frame f-pg-sel i-cod-gr-cli-fim < input frame f-pg-sel i-cod-gr-cli-ini 
  then do:
     {utp/ut-field.i mgdis cotas cod-gr-cli 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to i-cod-gr-cli-ini in frame f-pg-sel.
     return error.
  end. 

  if input frame f-pg-sel c-nome-abrev-fim < input frame f-pg-sel c-nome-abrev-ini 
  then do:
     {utp/ut-field.i mgdis cotas nome-abrev 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to c-nome-abrev-ini in frame f-pg-sel.
     return error.
  end.   

  if input frame f-pg-sel c-nome-ab-reg-fim < input frame f-pg-sel c-nome-ab-reg-ini 
  then do:
     {utp/ut-field.i mgdis cotas nome-ab-reg 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to c-nome-ab-reg-ini in frame f-pg-sel.
     return error.
  end. 

  if input frame f-pg-sel c-nome-mic-reg-fim < input frame f-pg-sel c-nome-mic-reg-ini 
  then do:
     {utp/ut-field.i mgdis cotas nome-mic-reg 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to c-nome-mic-reg-ini in frame f-pg-sel.
     return error.
  end. 

  if input frame f-pg-sel i-cod-rep-fim < input frame f-pg-sel i-cod-rep-ini 
  then do:
      {utp/ut-field.i mgdis cotas cod-rep 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to i-cod-rep-ini in frame f-pg-sel.
     return error.
  end. 

  if input frame f-pg-sel c-cd-produto-fim < input frame f-pg-sel c-cd-produto-ini 
  then do:
     {utp/ut-field.i mgdis cotas cd-produto 1} 
      run utp/ut-msgs.p (input "SHOW",
                         input 515,
                         input return-value).
     apply 'mouse-select-click' to im-pg-sel in frame f-relat.
     apply 'entry' to c-cd-produto-ini in frame f-pg-sel.
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "cotas"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

