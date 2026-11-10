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
{include/i-prgvrs.i AC1006 2.00.00.026 } /*** 010026 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac1006 MAC}
&ENDIF

/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

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

&GLOBAL-DEFINE PGLAY f-pg-lay
&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGLOG f-pg-log

/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */

define temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field arq-destino      as char
    field arq-entrada      as char format "x(40)"
    field exporta          as integer
    field desc-exporta     as char format "x(40)"
    field usuario          as char
    field data-exec        as date
    field hora-exec        as integer
    field cod-estab-ini    like cotas.cod-estabel
    field cod-estab-fim    like cotas.cod-estabel
    field produto-ini      like cotas.cd-produto
    field produto-fim      like cotas.cd-produto
    field data-ini         like cotas.dt-inicial
    field data-fim         like cotas.dt-inicial.


    {utp/utapi003.i} /* defini‡äes de temp-table usadas para transportar dados para */
                     /*   o excel. */
/* Transfer Definitions */
def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

/* Local Variable Definitions ---                                       */
def var ch-excel  as office.iface.excel.ExcelWrapper no-undo.
def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-term         as char    no-undo.
def var i-selec-zoom       as int init 1  no-undo.
def var c-empresa          as char.
def var i-cont-colun       as integer.
def var i-linha as integer init 1.
def var c-titulo-planilha  as character. 

/* Include pre-processador release 202 ou 203 */
{cdp/cdcfgdis.i}

/* Defini‡Æo de variaveis utilizadas para armazenar literais */

def var c-label-1          as character format "x(35)" no-undo.
def var c-label-2          as character format "x(35)" no-undo.
def var c-label-3          as character format "x(35)" no-undo.
def var c-label-4          as character format "x(35)" no-undo.
def var c-label-5          as character format "x(35)" no-undo.
def var c-label-6          as character format "x(35)" no-undo.


{include/i-imdef.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
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

DEFINE BUTTON bt-editar 
     LABEL "Editar Layout" 
     SIZE 20 BY 1.

DEFINE VARIABLE ed-layout AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 76 BY 9.25
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
     SIZE 47 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47 BY 1.71.

DEFINE BUTTON bt-arquivo-entrada 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-arquivo-entrada AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE text-entrada AS CHARACTER FORMAT "X(256)":U INITIAL "Arquivo de Sa¡da" 
      VIEW-AS TEXT 
     SIZE 16.86 BY .63 NO-UNDO.

DEFINE VARIABLE text-exporta AS CHARACTER FORMAT "X(256)":U INITIAL "Exporta para" 
      VIEW-AS TEXT 
     SIZE 13 BY .67 NO-UNDO.

DEFINE VARIABLE rs-exporta AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Arquivo", 1,
"Excel", 2
     SIZE 27 BY 1.5 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46 BY 3.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 2.

DEFINE VARIABLE c-cd-produto-fim AS CHARACTER FORMAT "X(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE c-cd-produto-ini AS CHARACTER FORMAT "X(16)" 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE c-cod-estab-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estab-ini LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-inicial-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE da-dt-inicial-ini AS DATE FORMAT "99/99/9999" INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

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


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-pg-lay
     ed-layout AT ROW 1 COL 1 NO-LABEL
     bt-editar AT ROW 10.38 COL 1 HELP
          "Dispara a ImpressÆo do Layout"
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 76.86 BY 10.46.

DEFINE FRAME f-import
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execu‡Æo do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Cancelar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     im-pg-lay AT ROW 1.5 COL 2.14
     im-pg-sel AT ROW 1.5 COL 17.86
     im-pg-par AT ROW 1.5 COL 33.57
     im-pg-log AT ROW 1.5 COL 49.29
     rt-folder AT ROW 2.5 COL 2
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     RECT-6 AT ROW 13.75 COL 2.14
     RECT-1 AT ROW 14.29 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-log
     rs-destino AT ROW 2 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     bt-config-impr-destino AT ROW 3.21 COL 43.29 HELP
          "Configura‡Æo da impressora"
     c-arquivo-destino AT ROW 3.25 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     bt-arquivo-destino AT ROW 3.25 COL 43 HELP
          "Escolha do nome do arquivo"
     rs-execucao AT ROW 5.38 COL 3.14 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.25 COL 3 NO-LABEL
     text-modo AT ROW 4.75 COL 1 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.54 COL 2
     RECT-9 AT ROW 4.92 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 76.29 BY 10.46.

DEFINE FRAME f-pg-par
     rs-exporta AT ROW 2.25 COL 6 NO-LABEL
     c-arquivo-entrada AT ROW 5.79 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     bt-arquivo-entrada AT ROW 5.79 COL 43.57 HELP
          "Escolha do nome do arquivo"
     text-exporta AT ROW 1.25 COL 2 COLON-ALIGNED NO-LABEL
     text-entrada AT ROW 4.75 COL 4.14 NO-LABEL
     RECT-12 AT ROW 1.5 COL 2
     RECT-8 AT ROW 5.08 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.88
         SIZE 76.43 BY 10.5.

DEFINE FRAME f-pg-sel
     c-cod-estab-ini AT ROW 2 COL 19 COLON-ALIGNED
     c-cod-estab-fim AT ROW 2 COL 47 COLON-ALIGNED NO-LABEL
     c-cd-produto-ini AT ROW 3 COL 19 COLON-ALIGNED HELP
          "C¢digo do Produto/Item"
     c-cd-produto-fim AT ROW 3 COL 47 COLON-ALIGNED HELP
          "C¢digo do Produto/Item" NO-LABEL
     da-dt-inicial-ini AT ROW 4 COL 19 COLON-ALIGNED HELP
          "Data inicial do Per¡odo das cotas"
     da-dt-inicial-fim AT ROW 4 COL 47 COLON-ALIGNED HELP
          "Data inicial do Per¡odo das cotas" NO-LABEL
     IMAGE-15 AT ROW 2 COL 39
     IMAGE-16 AT ROW 2 COL 45
     IMAGE-11 AT ROW 3 COL 39
     IMAGE-12 AT ROW 3 COL 45
     IMAGE-13 AT ROW 4 COL 39
     IMAGE-14 AT ROW 4 COL 45
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
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Exporta‡Æo de Base-Cota"
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
                                                                        */
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
/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-log
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-log     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-log
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-log     = 
                "Execu‡Æo".

/* SETTINGS FOR FRAME f-pg-par
                                                                        */
/* SETTINGS FOR FILL-IN text-entrada IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-entrada:PRIVATE-DATA IN FRAME f-pg-par     = 
                "Arquivo de Sa¡da".

ASSIGN 
       text-exporta:PRIVATE-DATA IN FRAME f-pg-par     = 
                "Exporta para".

/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-estab-fim IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                          */
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
ON END-ERROR OF C-Win /* Exporta‡Æo de Base-Cota */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Exporta‡Æo de Base-Cota */
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


&Scoped-define FRAME-NAME f-pg-log
&Scoped-define SELF-NAME bt-arquivo-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo-destino C-Win
ON CHOOSE OF bt-arquivo-destino IN FRAME f-pg-log
DO:
    {include/i-imarq.i c-arquivo-destino f-pg-log}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME bt-arquivo-entrada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo-entrada C-Win
ON CHOOSE OF bt-arquivo-entrada IN FRAME f-pg-par
DO:
    {include/i-imarq.i c-arquivo-entrada f-pg-par}
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
   {include/i-imedl.i}
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
&Scoped-define SELF-NAME c-cd-produto-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-produto-ini C-Win
ON F5 OF c-cd-produto-ini IN FRAME f-pg-sel
DO:
    run cdp/cd9019.w (input-output i-selec-zoom).

    if  i-selec-zoom = 1  then do:
        {include/zoomvar.i &prog-zoom=inzoom/z01in172.w
                           &campo=c-cd-produto-ini
                           &campozoom=it-codigo
                           &frame={&FRAME-NAME}}
    end.
    else do:
        /*****  Uso de pre-processador ******/
        &if defined (bf_dis_adm_cotas) &then
            {include/zoomvar.i &prog-zoom=dizoom/z01di292.w
                               &campo=c-cd-produto-ini
                               &campozoom=cod-produto-coml
                               &ExcludeVar=yes
                               &frame={&FRAME-NAME}}
        &else
            {include/zoomvar.i &prog-zoom=inzoom/z01in360.w
                               &campo=c-cd-produto-ini
                               &campozoom=cd-produto
                               &ExcludeVar=yes
                               &frame={&FRAME-NAME}}
        &endif
    end.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-produto-ini C-Win
ON MOUSE-SELECT-DBLCLICK OF c-cd-produto-ini IN FRAME f-pg-sel
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


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME rs-exporta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-exporta C-Win
ON VALUE-CHANGED OF rs-exporta IN FRAME f-pg-par
DO:
  if input frame f-pg-par rs-exporta = 1 then
     assign c-arquivo-entrada:sensitive in frame f-pg-par = yes
            bt-arquivo-entrada:sensitive in frame f-pg-par = yes.
  else 
     assign c-arquivo-entrada:sensitive in frame f-pg-par = no
            bt-arquivo-entrada:sensitive in frame f-pg-par = no.

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

{utp/ut9000.i "AC1006" "2.00.00.016"}

/* inicializa‡äes do template de importa‡Æo */
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

    RUN enable_UI.
    if c-cod-estab-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.    
    if c-cd-produto-ini:load-mouse-pointer ("image/lupa.cur") in frame f-pg-sel then.    

    {include/i-immbl.i}

    {include/i-imvrf.i &programa=ac1006 &versao-layout=001}

    {utp/ut-field.i mgdis cotas cod-estabel 1}
    assign c-cod-estab-ini:label in frame f-pg-sel = trim(return-value).

    {utp/ut-liter.i Produto/Item * R}
    assign c-cd-produto-ini:label in frame f-pg-sel = trim(return-value).

    {utp/ut-field.i mgdis cotas dt-inicial 1}
    assign da-dt-inicial-ini:label in frame f-pg-sel = trim(return-value).

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
  ENABLE im-pg-lay im-pg-sel im-pg-par im-pg-log bt-executar bt-cancelar 
         bt-ajuda 
      WITH FRAME f-import IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-import}
  DISPLAY c-cod-estab-ini c-cod-estab-fim c-cd-produto-ini c-cd-produto-fim 
          da-dt-inicial-ini da-dt-inicial-fim 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  ENABLE IMAGE-15 IMAGE-16 IMAGE-11 IMAGE-12 IMAGE-13 IMAGE-14 c-cod-estab-ini 
         c-cod-estab-fim c-cd-produto-ini c-cd-produto-fim da-dt-inicial-ini 
         da-dt-inicial-fim 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  DISPLAY rs-exporta c-arquivo-entrada text-exporta 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  ENABLE RECT-12 RECT-8 rs-exporta c-arquivo-entrada bt-arquivo-entrada 
         text-exporta 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  DISPLAY ed-layout 
      WITH FRAME f-pg-lay IN WINDOW C-Win.
  ENABLE ed-layout bt-editar 
      WITH FRAME f-pg-lay IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-lay}
  DISPLAY rs-destino c-arquivo-destino rs-execucao 
      WITH FRAME f-pg-log IN WINDOW C-Win.
  ENABLE RECT-7 RECT-9 rs-destino bt-config-impr-destino c-arquivo-destino 
         bt-arquivo-destino rs-execucao 
      WITH FRAME f-pg-log IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-log}
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

    if  input frame f-pg-par c-arquivo-entrada = "" and
        input frame f-pg-par rs-exporta = 1 then do:
        run utp/ut-msgs.p (input "show",
                           input 3335,
                           input c-arquivo-entrada).                               
        apply 'mouse-select-click' to im-pg-par in frame f-import.
        apply 'entry' to c-arquivo-entrada in frame f-pg-par.                
        return error.
    end. 


    /* Coloque aqui as valida‡äes das outras p ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p gina 
       com problemas e colocar o focus no campo com problemas             */    

    if input frame f-pg-sel c-cd-produto-fim < input frame f-pg-sel c-cd-produto-ini 
    then do:
       {utp/ut-liter.i Item_ou_Produto_Final * L}
       assign c-label-1 = return-value.
       {utp/ut-liter.i Item_ou_Produto_Inicial * L}
       assign c-label-2 = return-value.
       run utp/ut-msgs.p (input "show",input 209,input c-label-1 + "~~" + c-label-2).
       apply 'mouse-select-click' to im-pg-sel in frame f-import.
       apply 'entry' to c-cd-produto-fim in frame f-pg-sel.
       return error.
    end. 
    if input frame f-pg-sel da-dt-inicial-fim < input frame f-pg-sel da-dt-inicial-ini 
    then do:
       {utp/ut-liter.i Data_Final * L}
       assign c-label-3 = return-value.
       {utp/ut-liter.i Data_Inicial * L}
       assign c-label-4 = return-value.
       run utp/ut-msgs.p (input "show",input 209,input c-label-3 + "~~" + c-label-4).
       apply 'mouse-select-click' to im-pg-sel in frame f-import.
       apply 'entry' to da-dt-inicial-fim in frame f-pg-sel.
       return error.
    end. 
    if input frame f-pg-sel c-cod-estab-fim < input frame f-pg-sel c-cod-estab-ini 
    then do:
       {utp/ut-liter.i Estabelecimento_Final * L}
       assign c-label-5 = return-value.
       {utp/ut-liter.i Estabelecimento_Inicial * L}
       assign c-label-6 = return-value.
       run utp/ut-msgs.p (input "show",input 209,input c-label-5 + "~~" + c-label-6).
       apply 'mouse-select-click' to im-pg-sel in frame f-import.
       apply 'entry' to c-cod-estab-fim in frame f-pg-sel.
       return error.
    end. 

    if input frame f-pg-par rs-exporta = 2 then do:
       os-delete value(session:temp-directory + "ac1006.xls").
       if ERROR-STATUS:ERROR then.

       /* Se j  existir um arquivo excel criado, nÆo deixar  criar outro */
       assign FILE-INFO:FILE-NAME = session:temp-directory + "ac1006.xls".
       if FILE-INFO:FILE-TYPE <> ? then do:
          run utp/ut-msgs.p (input "show",input 18583,input "").
          return error.
       end.         
    end.     
    create tt-param.
    assign  tt-param.usuario       = c-seg-usuario
            tt-param.destino       = input frame f-pg-log rs-destino
            tt-param.arq-entrada   = input frame f-pg-par c-arquivo-entrada  
            tt-param.data-exec     = today
            tt-param.hora-exec     = time
            tt-param.cod-estab-ini = input frame f-pg-sel c-cod-estab-ini
            tt-param.cod-estab-fim = input frame f-pg-sel c-cod-estab-fim
            tt-param.produto-ini   = input frame f-pg-sel c-cd-produto-ini
            tt-param.produto-fim   = input frame f-pg-sel c-cd-produto-fim
            tt-param.data-ini      = input frame f-pg-sel da-dt-inicial-ini
            tt-param.data-fim      = input frame f-pg-sel da-dt-inicial-fim
            tt-param.exporta       = input frame f-pg-par rs-exporta
            tt-param.desc-exporta  = entry((tt-param.exporta - 1) * 2 + 1, 
                                             rs-exporta:radio-buttons in frame f-pg-par).

    if  tt-param.destino = 1 then
        assign tt-param.arq-destino = "".
    else
    if  tt-param.destino = 2 then 
        assign tt-param.arq-destino = input frame f-pg-log c-arquivo-destino.
    else
        assign tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp".

    IF tt-param.exporta = 1 THEN DO:

        /* Coloque aqui a l¢gica de grava‡Æo dos parƒmtros e sele‡Æo na temp-table
           tt-param */ 
        {include/i-imexb.i}
    
        if  session:set-wait-state("general") then.
    
        {include/i-imrun.i acp/ac1006rp.p}
    
        {include/i-imexc.i}
    
        if  session:set-wait-state("") then.
    
        {include/i-imtrm.i tt-param.arq-destino tt-param.destino}
    END.
    ELSE DO:
        {office/office.i Excel ch-excel}  

        FOR FIRST tt-param:
            ASSIGN tt-param.arquivo = session:temp-directory + "ac1006.tmp".
        END.
        
        if  search(replace(tt-param.arquivo, ".tmp", ".xls")) <> ? then
        os-delete value(replace(tt-param.arquivo, ".tmp", ".xls")).

        /* Se j  existir um arquivo excel criado, nÆo deixar  criar outro */
        assign file-info:file-name = replace(tt-param.arquivo, ".tmp", ".xls").

    

        if  file-info:file-type <> ? then do:
        run utp/ut-msgs.p (input "show",
                           input 18583,
                           input "").
        return "NOK":U.
        end.  
        
        run acp/ac1006rpe.p (INPUT TABLE tt-param).
        session:set-wait-state("":U).

        DELETE object ch-excel.

    END.
    
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

{include/i-imtrp.i}

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

