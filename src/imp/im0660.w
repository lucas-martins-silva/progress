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
{include/i-prgvrs.i IM0660 2.00.00.015 } /*** 010015 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0660 MIM}
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
  
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{include/i_dbvers.i} /*Include de Pr‚-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar valida‡Æo produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
    {cdp/cdapi558.i1}
&endif

/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */
{imp/im0660.i} /* tt-param */

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.
                    
/* Local Variable Definitions ---                                       */

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-pg-imp

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-7 RECT-9 rs-destino bt-arquivo ~
bt-config-impr c-arquivo rs-execucao limprime 
&Scoped-Define DISPLAYED-OBJECTS rs-destino c-arquivo rs-execucao limprime 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-relat AS WIDGET-HANDLE NO-UNDO.

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

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.14 BY 2.42.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE limprime AS LOGICAL INITIAL no 
     LABEL "Imprime P gina de Parƒmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .88 NO-UNDO.

DEFINE BUTTON bt-dir-destino 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-layout-pad-fornec 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-arquivo-copia AS CHARACTER FORMAT "X(100)":U 
     LABEL "Copia para" 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-dir-destino AS CHARACTER FORMAT "X(60)":U 
     LABEL "Diret¢rio" 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE c-layout-pad-fornec AS CHARACTER FORMAT "X(60)":U 
     LABEL "Layout PadrÆo" 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE rs-agrupar AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Por Fatura", 1,
"Por Embarque", 2
     SIZE 14 BY 1.75 NO-UNDO.

DEFINE VARIABLE rs-orientacao AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Retrato", 0,
"Paisagem", 1
     SIZE 12 BY 1.75 NO-UNDO.

DEFINE VARIABLE rs-traducao AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "NÆo Traduz", 1,
"Idioma Corret Camb", 2,
"Idioma Exportador", 3
     SIZE 17.14 BY 2.29 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54 BY 3.25.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54 BY 3.25.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54 BY 3.25.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 20 BY 3.25.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 20 BY 3.25.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 20 BY 3.25.

DEFINE VARIABLE l-envia-docto-corretor AS LOGICAL INITIAL no 
     LABEL "Envia Docto para Corretor Cƒmbio" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .83
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-envia-docto-exportador AS LOGICAL INITIAL no 
     LABEL "Envia Docto para Exportador" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-layout-pad-fornec AS LOGICAL INITIAL yes 
     LABEL "Utilizar Layout padrÆo do Corretor Cƒmbio" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .83
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-sobrepor AS LOGICAL INITIAL yes 
     LABEL "Sobrepor Arquivos j  Existentes?" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

DEFINE VARIABLE c-conhecto-house-fim AS CHARACTER FORMAT "X(25)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 26.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-conhecto-house-ini AS CHARACTER FORMAT "X(25)":U 
     LABEL "Conhecim House" 
     VIEW-AS FILL-IN 
     SIZE 26.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-conhecto-master-fim AS CHARACTER FORMAT "X(25)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 26.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-conhecto-master-ini AS CHARACTER FORMAT "X(25)":U 
     LABEL "Conhecim Master" 
     VIEW-AS FILL-IN 
     SIZE 26.86 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-embarque-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-embarque-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-estabel-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-estabel-ini LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R7 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE cnr-fat-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE cnr-fat-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Nr Fatura" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE ddata-vencto-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE ddata-vencto-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-51
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-52
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-53
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-54
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-55
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-56
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-57
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-58
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-59
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-60
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
     SIZE 79 BY 11.25
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
     bt-executar AT ROW 14.46 COL 3 HELP
          "Dispara a execu‡Æo do relat¢rio"
     bt-cancelar AT ROW 14.46 COL 14 HELP
          "Fechar"
     bt-ajuda AT ROW 14.46 COL 70.14 HELP
          "Ajuda"
     rt-folder-right AT ROW 2.67 COL 80.43
     RECT-1 AT ROW 14.21 COL 2
     rt-folder AT ROW 2.5 COL 2
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder-top AT ROW 2.54 COL 2.14
     RECT-6 AT ROW 13.75 COL 2.14
     im-pg-imp AT ROW 1.5 COL 33
     im-pg-par AT ROW 1.5 COL 17.72
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.25
         SIZE 81 BY 14.71
         FONT 1
         DEFAULT-BUTTON bt-executar.

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
     limprime AT ROW 8.17 COL 3
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-10 AT ROW 7.42 COL 2.14
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 73.72 BY 10
         FONT 1.

DEFINE FRAME f-pg-par
     l-envia-docto-exportador AT ROW 1.63 COL 13
     l-envia-docto-corretor AT ROW 2.5 COL 13
     c-arquivo-copia AT ROW 3.5 COL 11 COLON-ALIGNED
     l-layout-pad-fornec AT ROW 5.63 COL 13
     c-layout-pad-fornec AT ROW 6.63 COL 11 COLON-ALIGNED
     bt-layout-pad-fornec AT ROW 6.58 COL 51.72 HELP
          "Escolha do nome do arquivo"
     l-sobrepor AT ROW 9.08 COL 13
     c-dir-destino AT ROW 10.08 COL 11 COLON-ALIGNED
     bt-dir-destino AT ROW 10.04 COL 51.72 HELP
          "Escolha do nome do arquivo"
     rs-agrupar AT ROW 2.08 COL 58.57 NO-LABEL
     rs-orientacao AT ROW 5.5 COL 58.57 NO-LABEL
     rs-traducao AT ROW 8.79 COL 58.57 NO-LABEL
     "Envio E-Mail" VIEW-AS TEXT
          SIZE 11 BY .67 AT ROW 1 COL 4.72
          FONT 1
     "Layout" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 4.5 COL 5
          FONT 1
     "Destino" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 7.96 COL 5
     "Agrupar" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.04 COL 59.57
     "Orienta‡Æo" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 4.54 COL 59.72
     "Tradu‡Æo" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 7.96 COL 59.86
     RECT-11 AT ROW 1.29 COL 2
     RECT-12 AT ROW 4.75 COL 2
     RECT-13 AT ROW 8.21 COL 2
     RECT-14 AT ROW 1.29 COL 56.72
     RECT-15 AT ROW 4.75 COL 56.72
     RECT-16 AT ROW 8.21 COL 56.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.83
         SIZE 76.14 BY 10.54
         FONT 1.

DEFINE FRAME f-pg-sel
     ccod-estabel-ini AT ROW 1.25 COL 14.57 COLON-ALIGNED
          LABEL "Estabelecimento":R7
     ccod-estabel-fim AT ROW 1.25 COL 47.29 COLON-ALIGNED NO-LABEL
     ccod-embarque-ini AT ROW 2.25 COL 14.57 COLON-ALIGNED
     ccod-embarque-fim AT ROW 2.25 COL 47.29 COLON-ALIGNED NO-LABEL
     cnr-fat-ini AT ROW 3.25 COL 14.57 COLON-ALIGNED
     cnr-fat-fim AT ROW 3.25 COL 47.29 COLON-ALIGNED NO-LABEL
     ddata-vencto-ini AT ROW 4.25 COL 14.57 COLON-ALIGNED
     ddata-vencto-fim AT ROW 4.25 COL 47.29 COLON-ALIGNED NO-LABEL
     c-conhecto-master-ini AT ROW 5.25 COL 14.57 COLON-ALIGNED
     c-conhecto-master-fim AT ROW 5.25 COL 47.29 COLON-ALIGNED NO-LABEL
     c-conhecto-house-ini AT ROW 6.25 COL 14.57 COLON-ALIGNED
     c-conhecto-house-fim AT ROW 6.25 COL 47.29 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 1.25 COL 43.43
     IMAGE-2 AT ROW 1.25 COL 46.43
     IMAGE-51 AT ROW 2.25 COL 43.43
     IMAGE-52 AT ROW 2.25 COL 46.43
     IMAGE-53 AT ROW 3.25 COL 43.43
     IMAGE-54 AT ROW 3.25 COL 46.43
     IMAGE-55 AT ROW 4.25 COL 43.43
     IMAGE-56 AT ROW 4.25 COL 46.43
     IMAGE-57 AT ROW 5.25 COL 43.43
     IMAGE-58 AT ROW 5.25 COL 46.43
     IMAGE-59 AT ROW 6.25 COL 43.43
     IMAGE-60 AT ROW 6.25 COL 46.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.83
         SIZE 76.72 BY 10.04
         FONT 1.


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
         HEIGHT             = 15.04
         WIDTH              = 81
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
   Custom                                                               */
/* SETTINGS FOR BUTTON bt-layout-pad-fornec IN FRAME f-pg-par
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-layout-pad-fornec IN FRAME f-pg-par
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FILL-IN ccod-estabel-fim IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
/* SETTINGS FOR FILL-IN ccod-estabel-ini IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
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


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo w-relat
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    {include/i-rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-relat
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Fechar */
DO:
   apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-config-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr w-relat
ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:
   {include/i-rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME bt-dir-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-dir-destino w-relat
ON CHOOSE OF bt-dir-destino IN FRAME f-pg-par
DO:
    {utp/ut-liter.i Escolha_um_diret¢rio}
    run utp/ut-dir.p (input return-value,
                      output c-dir-destino,
                      output l-ok). /* se cancelado = yes */
    if  not l-ok then
        disp c-dir-destino with frame f-pg-par.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar w-relat
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
   do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME bt-layout-pad-fornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-layout-pad-fornec w-relat
ON CHOOSE OF bt-layout-pad-fornec IN FRAME f-pg-par
DO:
    {utp/ut-liter.i Escolha_um_diret¢rio}
    run utp/ut-dir.p (input return-value,
                      output c-layout-pad-fornec,
                      output l-ok). /* se cancelado = yes */
    if  not l-ok  then
        disp c-layout-pad-fornec with frame f-pg-par.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-imp w-relat
ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
DO:
    run pi-troca-pagina.
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
&Scoped-define SELF-NAME l-layout-pad-fornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-layout-pad-fornec w-relat
ON VALUE-CHANGED OF l-layout-pad-fornec IN FRAME f-pg-par /* Utilizar Layout padrÆo do Corretor Cƒmbio */
DO:
    if  l-layout-pad-fornec:checked in frame f-pg-par then do:
        assign c-layout-pad-fornec:screen-value in frame f-pg-par = "". 
        disable c-layout-pad-fornec
                bt-layout-pad-fornec with frame f-pg-par.
    end.
    else
        enable c-layout-pad-fornec
               bt-layout-pad-fornec with frame f-pg-par.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino w-relat
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao w-relat
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-relat 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "IM0660" "2.00.00.014"}

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
    ASSIGN ddata-vencto-ini = today
           ddata-vencto-fim = TODAY.
    RUN enable_UI.
  
    {include/i-rpmbl.i}
  
    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.

&IF "{&mguni_version}" >= "2.071" &THEN
    ASSIGN ccod-estabel-fim:SCREEN-VALUE IN FRAME f-pg-sel = "ZZZZZ".
&ELSE
    ASSIGN ccod-estabel-fim:SCREEN-VALUE IN FRAME f-pg-sel = "ZZZ".
&ENDIF
    
END.

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
  ENABLE im-pg-imp im-pg-par im-pg-sel bt-executar bt-cancelar bt-ajuda 
      WITH FRAME f-relat IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY l-envia-docto-exportador l-envia-docto-corretor c-arquivo-copia 
          l-layout-pad-fornec c-layout-pad-fornec l-sobrepor c-dir-destino 
          rs-agrupar rs-orientacao rs-traducao 
      WITH FRAME f-pg-par IN WINDOW w-relat.
  ENABLE l-envia-docto-exportador l-envia-docto-corretor c-arquivo-copia 
         l-layout-pad-fornec l-sobrepor c-dir-destino bt-dir-destino rs-agrupar 
         rs-orientacao rs-traducao RECT-11 RECT-12 RECT-13 RECT-14 RECT-15 
         RECT-16 
      WITH FRAME f-pg-par IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  DISPLAY ccod-estabel-ini ccod-estabel-fim ccod-embarque-ini ccod-embarque-fim 
          cnr-fat-ini cnr-fat-fim ddata-vencto-ini ddata-vencto-fim 
          c-conhecto-master-ini c-conhecto-master-fim c-conhecto-house-ini 
          c-conhecto-house-fim 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  ENABLE IMAGE-1 IMAGE-2 IMAGE-51 IMAGE-52 IMAGE-53 IMAGE-54 IMAGE-55 IMAGE-56 
         IMAGE-57 IMAGE-58 IMAGE-59 IMAGE-60 ccod-estabel-ini ccod-estabel-fim 
         ccod-embarque-ini ccod-embarque-fim cnr-fat-ini cnr-fat-fim 
         ddata-vencto-ini ddata-vencto-fim c-conhecto-master-ini 
         c-conhecto-master-fim c-conhecto-house-ini c-conhecto-house-fim 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  DISPLAY rs-destino c-arquivo rs-execucao limprime 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  ENABLE RECT-10 RECT-7 RECT-9 rs-destino bt-arquivo bt-config-impr c-arquivo 
         rs-execucao limprime 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
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
define var r-tt-digita as rowid no-undo.

do on error undo, return error on stop  undo, return error:
    {include/i-rpexa.i}
    
    if  input frame f-pg-imp rs-destino  = 2 
    and input frame f-pg-imp rs-execucao = 1 then do:

        run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).
        if  return-value = "NOK":U then do:

            run utp/ut-msgs.p (input "show",
                               input 73, input "").
            apply "MOUSE-SELECT-CLICK":U to im-pg-imp in frame f-relat.
            apply "ENTRY":U to c-arquivo in frame f-pg-imp.
            return error.
        end.
    end.

    if  not l-layout-pad-fornec:checked in frame f-pg-par then do:

        assign file-info:file-name = input frame f-pg-par c-layout-pad-fornec.

       if  file-info:pathname = ? 
       or  search(input frame f-pg-par c-layout-pad-fornec) <> ? then do:

            run utp/ut-msgs.p (input "show",                                  
                               input 4715,                                    
                               input input frame f-pg-par c-layout-pad-fornec).                                     
            apply "MOUSE-SELECT-CLICK":U to im-pg-par in frame f-relat.       
            apply "ENTRY":U to c-layout-pad-fornec in frame f-pg-par.         
            return error.                                                     
        end.                                                                  
    end.

    assign file-info:file-name = input frame f-pg-par c-dir-destino.

    if  file-info:pathname = ? 
    or  search(input frame f-pg-par c-dir-destino) <> ? then do:

        run utp/ut-msgs.p (input "show",                                  
                           input 4715,                                    
                           input input frame f-pg-par c-dir-destino).
        apply "MOUSE-SELECT-CLICK":U to im-pg-par in frame f-relat.       
        apply "ENTRY":U to c-dir-destino in frame f-pg-par.         
        return error.                                                     
    end.                                                                  

   /* Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    
    assign frame f-pg-sel ccod-estabel-ini      ccod-estabel-fim 
                          ccod-embarque-ini     ccod-embarque-fim 
                          cnr-fat-ini           cnr-fat-fim 
                          ddata-vencto-ini      ddata-vencto-fim
                          c-conhecto-master-ini c-conhecto-master-fim 
                          c-conhecto-house-ini  c-conhecto-house-fim.

    assign frame f-pg-par l-envia-docto-exportador 
                          l-envia-docto-corretor   
                          c-arquivo-copia          
                          l-layout-pad-fornec      
                          c-layout-pad-fornec      
                          l-sobrepor               
                          c-dir-destino              
                          rs-agrupar               
                          rs-orientacao            
                          rs-traducao.             
           
    assign frame f-pg-imp limprime.
    create tt-param.
    assign tt-param.usuario                  = c-seg-usuario
           tt-param.destino                  = input frame f-pg-imp rs-destino
           tt-param.data-exec                = today
           tt-param.hora-exec                = time.

    assign tt-param.cod-est-ini              = ccod-estabel-ini
           tt-param.cod-est-fim              = ccod-estabel-fim
           tt-param.c-emb-ini                = ccod-embarque-ini
           tt-param.c-emb-fim                = ccod-embarque-fim
           tt-param.nr-inv-ini               = cnr-fat-ini
           tt-param.nr-inv-fim               = cnr-fat-fim
           tt-param.dt-vencim-ini            = ddata-vencto-ini
           tt-param.dt-vencim-fim            = ddata-vencto-fim
           tt-param.c-master-ini             = c-conhecto-master-ini
           tt-param.c-master-fim             = c-conhecto-master-fim
           tt-param.c-house-ini              = c-conhecto-house-ini
           tt-param.c-house-fim              = c-conhecto-house-fim
           tt-param.l-impre                  = limprime
           tt-param.l-envia-docto-exportador = l-envia-docto-exportador 
           tt-param.l-envia-docto-corretor   = l-envia-docto-corretor   
           tt-param.c-arquivo-copia          = c-arquivo-copia          
           tt-param.l-layout-pad-fornec      = l-layout-pad-fornec      
           tt-param.c-layout-pad-fornec      = c-layout-pad-fornec      
           tt-param.l-sobrepor               = l-sobrepor               
           tt-param.c-dir-destino            = c-dir-destino              
           tt-param.i-agrupar                = rs-agrupar               
           tt-param.i-orientacao             = rs-orientacao            
           tt-param.i-traducao               = rs-traducao.             

    if  tt-param.destino = 1 then 
        assign tt-param.arquivo = "".
    else 
         if  tt-param.destino = 2 then
             assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
         else 
             assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".
    
    /* Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    
    
    /* Executar do programa RP.P que ir  criar o relat¢rio */
    {include/i-rpexb.i}
    
    session:set-wait-state("general":U).
    
    {include/i-rprun.i imp/im0660rp.p}
    
    {include/i-rpexc.i}
    
    session:set-wait-state("":U).
    
    {include/i-rptrm.i}
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina w-relat 
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

