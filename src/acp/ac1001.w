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
{include/i-prgvrs.i AC1001 2.00.00.014}  /*** 010014 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac1001 MAC}
&ENDIF

/*------------------------------------------------------------------------

  File:               ac1001.w

  Description:        Calculo do Rateio

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

/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */

define temp-table tt-param
    field destino             as integer
    field arquivo             as char
    field usuario             as char format "x(12)"
    field data-exec           as date
    field hora-exec           as integer
    field cod-estab-ini       like cotas.cod-estabel
    field cod-estab-fim       like cotas.cod-estabel
    field cod-canal-venda-ini like cotas.cod-canal-venda
    field cod-canal-venda-fim like cotas.cod-canal-venda
    field periodo-ini         like cotas.dt-inicial
    field periodo-fim         like cotas.dt-inicial
    FIELD ped-ini             AS DATE 
    FIELD ped-fim             AS DATE
    field cod-base-rat        as integer
    field desc-base-rat       as char format "x(40)"
    FIELD gera-base-rat       AS INTEGER
    field tg-deleta           as log
    field codigo              like tipo-baserat.codigo.


/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

/* Local Variable Definitions ---                                       */

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-label-1          as char    no-undo.
def var c-label-2          as char    no-undo.

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

DEFINE VARIABLE c-desc-cota-geral AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE fi-gera-base-rateio AS CHARACTER FORMAT "X(256)":U INITIAL "Gera‡Æo Base Rateio" 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

DEFINE VARIABLE i-codigo AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Tipo Base de Rateio" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE rs-cod-base-rat AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Cotas Realizadas", 1,
"Pedidos", 2,
"Faturamento", 3
     SIZE 24 BY 3.5 NO-UNDO.

DEFINE VARIABLE rs-gera-base-rateio AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Cliente", 1,
"Matriz", 2
     SIZE 12 BY 2.25 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 36 BY 4.25.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 37 BY 4.25.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75 BY 1.5.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 36 BY 3.

DEFINE VARIABLE tg-deleta AS LOGICAL INITIAL no 
     LABEL "Elimina Rateio Anterior?" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.

DEFINE VARIABLE c-cod-estab-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estab-ini LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE da-ped-fim AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE da-ped-ini AS DATE FORMAT "99/99/9999" INITIAL 07/03/03 
     LABEL "Dt Entrega":R12 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE da-periodo-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-periodo-ini AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Per¡odo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-canal-venda-fim AS INTEGER FORMAT ">>9" INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-canal-venda-ini AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Canal Venda" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3.72 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-27
     FILENAME "image~\im-las":U
     SIZE 3.72 BY .88.

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
         SIZE 76.43 BY 10.

DEFINE FRAME f-relat
     bt-executar AT ROW 14.25 COL 3 HELP
          "Dispara a execu‡Æo do relat¢rio"
     bt-cancelar AT ROW 14.25 COL 14 HELP
          "Fechar"
     bt-ajuda AT ROW 14.25 COL 70 HELP
          "Ajuda"
     RECT-1 AT ROW 14 COL 2
     RECT-6 AT ROW 13.75 COL 2.14
     rt-folder AT ROW 2.5 COL 2
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     im-pg-imp AT ROW 1.5 COL 33.57
     im-pg-par AT ROW 1.5 COL 17.86
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.04
         SIZE 81 BY 14.96
         FONT 1
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-par
     rs-cod-base-rat AT ROW 2 COL 7 HELP
          "Situa‡Æo" NO-LABEL
     tg-deleta AT ROW 3 COL 46
     i-codigo AT ROW 6.5 COL 26 COLON-ALIGNED HELP
          "Imforme o Tipo de Base de Rateio (Cen rio)"
     c-desc-cota-geral AT ROW 6.5 COL 30 COLON-ALIGNED NO-LABEL
     rs-gera-base-rateio AT ROW 8.75 COL 7 NO-LABEL
     fi-gera-base-rateio AT ROW 7.96 COL 1 COLON-ALIGNED NO-LABEL
     "Base de Rateio por" VIEW-AS TEXT
          SIZE 15 BY .67 AT ROW 1.21 COL 3
     RECT-11 AT ROW 1.5 COL 2
     RECT-18 AT ROW 1.5 COL 40
     RECT-19 AT ROW 6.25 COL 2
     RECT-20 AT ROW 8.25 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.75
         SIZE 77 BY 10.75
         FONT 1.

DEFINE FRAME f-pg-sel
     c-cod-estab-ini AT ROW 3.46 COL 20.86 COLON-ALIGNED
     c-cod-estab-fim AT ROW 3.54 COL 49.72 COLON-ALIGNED NO-LABEL
     i-cod-canal-venda-ini AT ROW 4.46 COL 20.86 COLON-ALIGNED HELP
          "Codigo do Canal de Venda"
     i-cod-canal-venda-fim AT ROW 4.46 COL 49.72 COLON-ALIGNED HELP
          "C¢digo do Canal de Venda" NO-LABEL
     da-periodo-ini AT ROW 5.46 COL 20.86 COLON-ALIGNED HELP
          "Per¡odo Inicial"
     da-periodo-fim AT ROW 5.46 COL 49.72 COLON-ALIGNED HELP
          "Per¡odo Final" NO-LABEL
     da-ped-ini AT ROW 6.5 COL 21 COLON-ALIGNED HELP
          "Data prevista para entrega do Pedido"
     da-ped-fim AT ROW 6.5 COL 50 COLON-ALIGNED HELP
          "Data prevista para entrega do Pedido" NO-LABEL
     IMAGE-1 AT ROW 5.5 COL 37.57
     IMAGE-2 AT ROW 5.5 COL 47.86
     IMAGE-22 AT ROW 4.46 COL 37.57
     IMAGE-23 AT ROW 3.46 COL 37.57
     IMAGE-24 AT ROW 3.46 COL 47.86
     IMAGE-25 AT ROW 4.46 COL 47.86
     IMAGE-26 AT ROW 6.5 COL 37.43
     IMAGE-27 AT ROW 6.5 COL 47.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.83
         SIZE 77.29 BY 10.88.


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
         TITLE              = "Calculo da Base de Rateio"
         HEIGHT             = 15.13
         WIDTH              = 81.86
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
         FONT               = 1
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
/* SETTINGS FOR FILL-IN c-desc-cota-geral IN FRAME f-pg-par
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-estab-fim IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                          */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-sel
/* Query rebuild information for FRAME f-pg-sel
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Calculo da Base de Rateio */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Calculo da Base de Rateio */
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
ON MOUSE-SELECT-DBLCLICK OF c-cod-estab-ini IN FRAME f-pg-sel /* Estab */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME i-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-codigo C-Win
ON F5 OF i-codigo IN FRAME f-pg-par /* Tipo Base de Rateio */
DO:
   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom=dizoom/z01di266.w
                      &campo=i-codigo
                      &campozoom=codigo
                      &frame={&FRAME-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-codigo C-Win
ON LEAVE OF i-codigo IN FRAME f-pg-par /* Tipo Base de Rateio */
DO:
  {include/leave.i &tabela=tipo-baserat
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-cota-geral
                   &where="tipo-baserat.codigo = input frame {&FRAME-NAME} i-codigo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-codigo C-Win
ON MOUSE-SELECT-DBLCLICK OF i-codigo IN FRAME f-pg-par /* Tipo Base de Rateio */
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


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME rs-cod-base-rat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-cod-base-rat C-Win
ON VALUE-CHANGED OF rs-cod-base-rat IN FRAME f-pg-par
DO:
  APPLY "MOUSE-SELECT-CLICK":U TO im-pg-sel IN FRAME f-relat.

  case self:screen-value:
      when "1" then do:
          {utp/ut-liter.i Per¡odo * L}
          ASSIGN da-periodo-ini:LABEL IN FRAME f-pg-sel = TRIM(RETURN-VALUE)
                 da-ped-ini:VISIBLE IN FRAME f-pg-sel = NO
                 da-ped-fim:VISIBLE IN FRAME f-pg-sel = NO
                 image-26:VISIBLE IN FRAME f-pg-sel = NO
                 image-27:VISIBLE IN FRAME f-pg-sel = NO.

      end.
      when "2" then do:
          ASSIGN da-ped-ini:VISIBLE IN FRAME f-pg-sel = YES
                 da-ped-fim:VISIBLE IN FRAME f-pg-sel = YES
                 image-26:VISIBLE IN FRAME f-pg-sel = YES
                 image-27:VISIBLE IN FRAME f-pg-sel = YES.
          {utp/ut-liter.i Dt_Implanta‡Æo * L}
          ASSIGN da-ped-ini:LABEL IN FRAME f-pg-sel = TRIM(RETURN-VALUE).
          IF AVAIL par-cota THEN              
             IF par-cota.tipo-data = 1 THEN DO:
                {utp/ut-liter.i Dt_EmissÆo * L}
                ASSIGN da-periodo-ini:LABEL IN FRAME f-pg-sel = TRIM(RETURN-VALUE).
             END.
             ELSE DO:
                {utp/ut-liter.i Dt_Entrega * L}
                ASSIGN da-periodo-ini:LABEL IN FRAME f-pg-sel = TRIM(RETURN-VALUE).
             END.

          run utp/ut-msgs.p (input "show", input 28286, input TRIM(da-ped-ini:LABEL)). 
      end.
      when "3" then do:
          {utp/ut-liter.i Dt_Emis_Nota * L}
          ASSIGN da-periodo-ini:LABEL IN FRAME f-pg-sel = TRIM(RETURN-VALUE)
                 da-ped-ini:VISIBLE IN FRAME f-pg-sel = NO
                 da-ped-fim:VISIBLE IN FRAME f-pg-sel = NO
                 image-26:VISIBLE IN FRAME f-pg-sel = NO
                 image-27:VISIBLE IN FRAME f-pg-sel = NO.


      end.

  end case.


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

{utp/ut9000.i "AC1001" "2.00.00.014"}

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

    RUN enable_UI.


    FIND FIRST par-cota NO-LOCK NO-ERROR.

    if i-codigo:load-mouse-pointer ('image/lupa.cur') in frame f-pg-par then.
    {include/i-rpmbl.i}
    {acp/ac9900.i}      /* Verifica se o m¢dulo est  implantado */

    APPLY "value-changed" TO rs-cod-base-rat IN FRAME f-pg-par.

    assign da-periodo-ini:SCREEN-VALUE IN FRAME f-pg-sel = 
                       STRING(date(if (month(today) - 1) > 0 then (month(today) - 1) else 12,
                       01,
                       if (month(today) - 1) > 0 then year(today) else year(today) - 1))
           da-periodo-fim:SCREEN-VALUE IN FRAME f-pg-sel = STRING((date(month(today),01,year(today))) - 1)
           da-ped-ini:SCREEN-VALUE IN FRAME f-pg-sel = 
                       STRING(date(if (month(today) - 1) > 0 then (month(today) - 1) else 12,
                       01,
                       if (month(today) - 1) > 0 then year(today) else year(today) - 1))
           da-ped-fim:SCREEN-VALUE IN FRAME f-pg-sel = STRING((date(month(today),01,year(today))) - 1).

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
  ENABLE im-pg-imp im-pg-par im-pg-sel bt-executar bt-cancelar bt-ajuda 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY rs-cod-base-rat tg-deleta i-codigo c-desc-cota-geral 
          rs-gera-base-rateio fi-gera-base-rateio 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  ENABLE RECT-11 RECT-18 RECT-19 RECT-20 rs-cod-base-rat tg-deleta i-codigo 
         rs-gera-base-rateio fi-gera-base-rateio 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  DISPLAY c-cod-estab-ini c-cod-estab-fim i-cod-canal-venda-ini 
          i-cod-canal-venda-fim da-periodo-ini da-periodo-fim da-ped-ini 
          da-ped-fim 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  ENABLE IMAGE-1 IMAGE-2 IMAGE-22 IMAGE-23 IMAGE-24 IMAGE-25 IMAGE-26 IMAGE-27 
         c-cod-estab-ini c-cod-estab-fim i-cod-canal-venda-ini 
         i-cod-canal-venda-fim da-periodo-ini da-periodo-fim da-ped-ini 
         da-ped-fim 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  DISPLAY rs-destino c-arquivo rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  ENABLE RECT-7 RECT-9 rs-destino bt-config-impr bt-arquivo c-arquivo 
         rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize C-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  &IF "{&bf_dis_versao_ems}" < "2.04" &THEN
        HIDE rs-gera-base-rateio IN FRAME f-pg-par.
        HIDE fi-gera-base-rateio IN FRAME f-pg-par.
        HIDE rect-20 IN FRAME f-pg-par.
    &else
        FIND FIRST para-ped NO-LOCK NO-ERROR.
        FIND FIRST par-cota WHERE par-cota.cod-estabel = para-ped.estab-padrao NO-LOCK NO-ERROR.
        IF AVAIL par-cota THEN DO:
            IF par-cota.cont-cliente THEN
                ENABLE rs-gera-base-rateio WITH FRAME f-pg-par.
            ELSE
                DISABLE rs-gera-base-rateio WITH FRAME f-pg-par.
        END.
        ELSE
            DISABLE rs-gera-base-rateio WITH FRAME f-pg-par.
    &ENDIF

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

    if input frame f-pg-sel c-cod-estab-fim < input frame f-pg-sel c-cod-estab-ini 
    then do:
       {utp/ut-liter.i Estabelecimento * L}
       assign c-label-1 = return-value.
       {utp/ut-liter.i Estabelecimento_Final * L}
       assign c-label-2 = return-value.
       run utp/ut-msgs.p (input "show",input 209,input c-label-1 + "~~" + c-label-2).
       apply 'mouse-select-click' to im-pg-sel in frame f-relat.
       apply 'entry' to c-cod-estab-fim in frame f-pg-sel.
       return error.
    end. 

    if input frame f-pg-sel i-cod-canal-venda-fim < input frame f-pg-sel i-cod-canal-venda-ini 
    then do:
       {utp/ut-liter.i Canal_Venda * L}
       assign c-label-1 = return-value.
       {utp/ut-liter.i Canal_Venda_Final * L}
       assign c-label-2 = return-value.
       run utp/ut-msgs.p (input "show",input 209,input c-label-1 + "~~" + c-label-2).
       apply 'mouse-select-click' to im-pg-sel in frame f-relat.
       apply 'entry' to i-cod-canal-venda-fim in frame f-pg-sel.
       return error.
    end. 

    if input frame f-pg-sel da-periodo-fim < input frame f-pg-sel da-periodo-ini 
    then do:
       {utp/ut-liter.i Per¡odo * L}
       assign c-label-1 = return-value.
       {utp/ut-liter.i Per¡odo_Final * L}
       assign c-label-2 = return-value.
       run utp/ut-msgs.p (input "show",input 209,input c-label-1 + "~~" + c-label-2).
       apply 'mouse-select-click' to im-pg-sel in frame f-relat.
       apply 'entry' to da-periodo-fim in frame f-pg-sel.
       return error.
    end. 


    if da-ped-ini:VISIBLE IN FRAME f-pg-sel = YES and
       input frame f-pg-sel da-ped-fim < input frame f-pg-sel da-ped-ini 
    then do:
       {utp/ut-liter.i Dt_Implanta‡Æo * L}
       assign c-label-1 = return-value.
       {utp/ut-liter.i Dt_Implant_Final * L}
       assign c-label-2 = return-value.
       run utp/ut-msgs.p (input "show",input 209,input c-label-1 + "~~" + c-label-2).
       apply 'mouse-select-click' to im-pg-sel in frame f-relat.
       apply 'entry' to da-ped-fim in frame f-pg-sel.
       return error.
    end. 

    find first para-ped no-lock no-error.
    if substring(para-ped.char-2, 1, 3) = "yes" then do:
       find par-cota no-lock
            where par-cota.cod-estabel = para-ped.estab-padrao no-error.
       if not avail par-cota then do:
          run utp/ut-msgs.p (input "show",
                             input 16994,
                             input "").
          return error.
       end.
    end.

    find tipo-baserat no-lock 
         where tipo-baserat.codigo = input frame f-pg-par i-codigo no-error.
    if not avail tipo-baserat then do:
       {utp/ut-liter.i Tipo_Base_Rateio * R}
       run utp/ut-msgs.p (input "show",
                          input 56,
                          input return-value).
       apply 'mouse-select-click' to im-pg-par in frame f-relat.
       apply 'entry' to i-codigo in frame f-pg-par.
       return error.
    end.


    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame f-pg-imp rs-destino
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.cod-base-rat    = input frame f-pg-par rs-cod-base-rat
           tt-param.desc-base-rat   = entry((tt-param.cod-base-rat - 1) * 2 + 1, 
                                            rs-cod-base-rat:radio-buttons in frame f-pg-par).

    &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
        FIND FIRST para-ped NO-LOCK NO-ERROR.
        FIND FIRST par-cota WHERE par-cota.cod-estabel = para-ped.estab-padrao NO-LOCK NO-ERROR.
        IF AVAIL par-cota THEN DO:
            IF par-cota.cont-cliente THEN
                ASSIGN tt-param.gera-base-rat = INPUT FRAME f-pg-par rs-gera-base-rateio.
        END.
    &ENDIF

    if  tt-param.destino = 1 then           
        assign tt-param.arquivo = "".
    else
    if  tt-param.destino = 2 then 
        assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
    else
        assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".

    /* Coloque aqui a l¢gica de grava‡Æo dos parƒmtros e sele‡Æo na temp-table
       tt-param */ 
    assign tt-param.periodo-ini         = input frame f-pg-sel da-periodo-ini
           tt-param.periodo-fim         = input frame f-pg-sel da-periodo-fim
           tt-param.ped-ini             = input frame f-pg-sel da-ped-ini
           tt-param.ped-fim             = input frame f-pg-sel da-ped-fim
           tt-param.cod-estab-ini       = input frame f-pg-sel c-cod-estab-ini
           tt-param.cod-estab-fim       = input frame f-pg-sel c-cod-estab-fim
           tt-param.cod-canal-venda-ini = input frame f-pg-sel i-cod-canal-venda-ini
           tt-param.cod-canal-venda-fim = input frame f-pg-sel i-cod-canal-venda-fim
           tt-param.tg-deleta           = tg-deleta:checked
           tt-param.codigo              = input frame f-pg-par i-codigo.

    {include/i-rpexb.i}

    if  session:set-wait-state("general") then.

    {include/i-rprun.i acp/ac1001rp.p}

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

