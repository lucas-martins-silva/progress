&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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
{include/i-prgvrs.i IM0200 2.00.00.013 } /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0200 MIM}
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

{imp/im0200.i5}
{cdp/cdcfgmat.i} /* Pre processador Integra‡Æo Magnus */

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

/* Defini‡Æo de Pr‚-Processadores */

{include/i_dbvers.i} /*Include de Pr‚-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar valida‡Æo produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
    {cdp/cdapi558.i1}
&endif

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-pg-imp

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rs-destino bt-arquivo bt-config-impr bt-email ~
c-arquivo rs-execucao ltraduz lparam RECT-10 RECT-7 RECT-9 
&Scoped-Define DISPLAYED-OBJECTS rs-destino c-arquivo rs-execucao ltraduz ~
lparam rs-execucao-2 

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

&IF DEFINED(bf-mat-comex) &THEN
    DEFINE BUTTON bt-email 
         IMAGE-UP FILE "image~\im-mens":U
         LABEL "" 
         SIZE 4 BY 1.
&ENDIF

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

DEFINE VARIABLE text-modo-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Parƒmetros de ImpressÆo" 
      VIEW-AS TEXT 
     SIZE 22.43 BY .63 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3,
"Envia E-mail", 4
     SIZE 44 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92 NO-UNDO.

DEFINE VARIABLE rs-execucao-2 AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "80 Colunas", 1,
"132 Colunas", 2
     SIZE 27.72 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 3.21.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 3.13.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE lparam AS LOGICAL INITIAL no 
     LABEL "Imprime P gina de Parƒmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.43 BY .83 NO-UNDO.

DEFINE VARIABLE ltraduz AS LOGICAL INITIAL no 
     LABEL "Traduz Relat¢rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.14 BY .83 NO-UNDO.

DEFINE VARIABLE l-dataefetiva AS LOGICAL INITIAL no 
     LABEL "Considera Data Efetiva" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.86 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-reemite AS LOGICAL INITIAL no 
     LABEL "Reemite Declara‡äes/Comunica‡äes" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE cdecl-fim AS INTEGER FORMAT ">>>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .88 NO-UNDO.

DEFINE VARIABLE cdecl-ini AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Declara‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .88 NO-UNDO.

DEFINE VARIABLE cembarque-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ"
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE cembarque-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE citiner-fim AS INTEGER FORMAT ">>>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .88 NO-UNDO.

DEFINE VARIABLE citiner-ini AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Itiner rio" 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .88 NO-UNDO.

DEFINE VARIABLE cnr-proc-imp-fim AS CHARACTER FORMAT "X(15)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE cnr-proc-imp-ini AS CHARACTER FORMAT "X(15)":U 
     LABEL "Processo" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE cpto-contr-fim AS INTEGER FORMAT ">>>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .88 NO-UNDO.

DEFINE VARIABLE cpto-contr-ini AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Ponto de Controle" 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .88 NO-UNDO.

DEFINE VARIABLE ddata-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE ddata-ini AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

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

DEFINE FRAME f-relat
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execu‡Æo do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Fechar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     RECT-1 AT ROW 14.29 COL 2
     RECT-6 AT ROW 13.75 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder AT ROW 2.5 COL 2
     im-pg-imp AT ROW 1.5 COL 33.57
     im-pg-par AT ROW 1.5 COL 17.86
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15
         FONT 1
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-sel
     cnr-proc-imp-ini AT ROW 1.25 COL 14 COLON-ALIGNED
     cnr-proc-imp-fim AT ROW 1.25 COL 48 COLON-ALIGNED NO-LABEL
     cembarque-ini AT ROW 2.25 COL 14 COLON-ALIGNED
     cembarque-fim AT ROW 2.25 COL 48 COLON-ALIGNED NO-LABEL
     cdecl-ini AT ROW 3.25 COL 14 COLON-ALIGNED
     cdecl-fim AT ROW 3.25 COL 48 COLON-ALIGNED NO-LABEL
     citiner-ini AT ROW 4.25 COL 14 COLON-ALIGNED
     citiner-fim AT ROW 4.29 COL 47.86 COLON-ALIGNED NO-LABEL
     ddata-ini AT ROW 5.25 COL 14 COLON-ALIGNED
     ddata-fim AT ROW 5.25 COL 47.72 COLON-ALIGNED NO-LABEL
     cpto-contr-ini AT ROW 6.25 COL 14 COLON-ALIGNED
     cpto-contr-fim AT ROW 6.25 COL 47.72 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 1.25 COL 32.86
     IMAGE-10 AT ROW 5.29 COL 46.43
     IMAGE-11 AT ROW 6.29 COL 32.86
     IMAGE-12 AT ROW 6.21 COL 46.43
     IMAGE-2 AT ROW 1.25 COL 46.43
     IMAGE-3 AT ROW 2.29 COL 32.86
     IMAGE-4 AT ROW 2.29 COL 46.43
     IMAGE-5 AT ROW 3.29 COL 32.86
     IMAGE-6 AT ROW 3.29 COL 46.43
     IMAGE-7 AT ROW 4.29 COL 32.86
     IMAGE-8 AT ROW 4.29 COL 46.43
     IMAGE-9 AT ROW 5.29 COL 32.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 76.86 BY 10.62
         FONT 1.

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     bt-arquivo AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     bt-config-impr AT ROW 3.58 COL 43.29 HELP
          "Configura‡Æo da impressora"
     &IF DEFINED(bf-mat-comex) &THEN     
         bt-email AT ROW 3.58 COL 43.29 HELP
               "Informe e-mail do remetente"
     &ENDIF          
     c-arquivo AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 6.08 COL 2.86 HELP
          "Modo de Execu‡Æo" NO-LABEL
     ltraduz AT ROW 8.38 COL 2.86
     lparam AT ROW 9.29 COL 2.86
     rs-execucao-2 AT ROW 10.04 COL 2.86 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5.33 COL 1.14 COLON-ALIGNED NO-LABEL
     text-modo-2 AT ROW 7.67 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-10 AT ROW 7.96 COL 2
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.63 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 73.72 BY 10.29
         FONT 1.

DEFINE FRAME f-pg-par
     l-reemite AT ROW 1.29 COL 3.29
     l-dataefetiva AT ROW 2.79 COL 3.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 75 BY 10.


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
/* SETTINGS FOR FRAME f-pg-imp
                                                                        */
/* SETTINGS FOR RADIO-SET rs-execucao-2 IN FRAME f-pg-imp
   NO-ENABLE                                                            */
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

/* SETTINGS FOR FILL-IN text-modo-2 IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-modo-2:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Parƒmetros de ImpressÆo".

/* SETTINGS FOR FRAME f-pg-par
                                                                        */
/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
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


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino w-relat
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp
/**************  ATEN€ÇO  ********************************/
/** Esta trigger esta customizada dentro do Main Block. **/
/*********************************************************/
DO:
  /*do  with frame f-pg-imp:
 *     case self:screen-value:
 *         when "1" then do:
 *             assign c-arquivo:sensitive    = no
 *                    bt-arquivo:visible     = no
 *                    bt-config-impr:visible = yes.
 *         end.
 *         when "2" then do:        
 *             assign c-arquivo:sensitive     = yes
 *                    bt-arquivo:visible      = yes
 *                    bt-config-impr:visible  = no.
 *         end.
 *         when "3" then do:
 *             assign c-arquivo:sensitive     = no
 *                    bt-arquivo:visible      = no
 *                    bt-config-impr:visible  = no.
 *         end.
 *     end case.    
 *   end.*/
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


&Scoped-define SELF-NAME rs-execucao-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao-2 w-relat
ON VALUE-CHANGED OF rs-execucao-2 IN FRAME f-pg-imp
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

{utp/ut9000.i "IM0200" "2.00.00.011"}

/* inicializa‡äes do template de relat¢rio */
{include/i-rpini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

{include/i-rplbl.i}

/** Trigger customizada para utilizar **
 ** a op‡Æo e-mail no EMS e no Magnus **/   
ON "VALUE-CHANGED" OF rs-destino IN FRAME f-pg-imp DO:
   CASE rs-destino:SCREEN-VALUE IN FRAME f-pg-imp:
      WHEN "1" THEN DO:
           ASSIGN c-arquivo                                = c-imp-old
                  c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp = c-imp-old
                  c-arquivo:SENSITIVE IN FRAME f-pg-imp    = NO
                  c-arquivo:VISIBLE IN FRAME f-pg-imp      = YES
                  bt-arquivo:VISIBLE IN FRAME f-pg-imp     = NO
                  bt-config-impr:VISIBLE IN FRAME f-pg-imp = YES.
           &IF DEFINED(bf-mat-comex) &THEN
               ASSIGN bt-email:VISIBLE IN FRAME f-pg-imp   = NO.
           &ENDIF
      END.            
      WHEN "2" THEN DO:
           ASSIGN c-arquivo = IF rs-execucao = 1 
                              THEN c-arq-old
                              ELSE c-arq-old-batch
                  c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp = c-arquivo
                  c-arquivo:SENSITIVE IN FRAME f-pg-imp    = YES
                  c-arquivo:VISIBLE IN FRAME f-pg-imp      = YES
                  bt-arquivo:VISIBLE IN FRAME f-pg-imp     = YES
                  bt-config-impr:VISIBLE IN FRAME f-pg-imp = NO.
           &IF DEFINED(bf-mat-comex) &THEN
               ASSIGN bt-email:VISIBLE IN FRAME f-pg-imp   = NO.
           &ENDIF
      END.            
      WHEN "3" THEN DO:
           ASSIGN c-arquivo                                = ""
                  c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp = c-arquivo
                  c-arquivo:VISIBLE IN FRAME f-pg-imp      = NO
                  bt-arquivo:VISIBLE IN FRAME f-pg-imp     = NO
                  bt-config-impr:VISIBLE IN FRAME f-pg-imp = NO.
           &IF DEFINED(bf-mat-comex) &THEN
               ASSIGN bt-email:VISIBLE IN FRAME f-pg-imp   = NO.
           &ENDIF
      END.
      WHEN "4" THEN DO:
           ASSIGN bt-arquivo:VISIBLE IN FRAME f-pg-imp     = NO
                  bt-config-impr:VISIBLE IN FRAME f-pg-imp = NO.                   
           &IF DEFINED(bf-mat-comex) &THEN
               ASSIGN c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp = c-imp-old
                      c-arquivo:SENSITIVE IN FRAME f-pg-imp = YES 
                      c-arquivo:VISIBLE IN FRAME f-pg-imp   = YES
                      bt-email:VISIBLE IN FRAME f-pg-imp    = YES
                      bt-email:SENSITIVE IN FRAME f-pg-imp  = NO.
           &ELSE
               ASSIGN c-arquivo:VISIBLE IN FRAME f-pg-imp  = NO
                      c-arquivo = STRING(session:temp-directory).
           &ENDIF
      END.
   END CASE.    
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.

    {include/i-rpmbl.i}

    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

&IF DEFINED(bf-mat-comex) &THEN
    ASSIGN l-dataefetiva:VISIBLE IN FRAME f-pg-par = NO.
&ELSE
    If can-find(FIRST funcao where funcao.cd-funcao = "spp-caraiba-fo897776" and funcao.ativo = yes)  then
        ASSIGN l-dataefetiva:VISIBLE IN FRAME f-pg-par = YES.
    ELSE
        ASSIGN l-dataefetiva:VISIBLE IN FRAME f-pg-par = NO.
&ENDIF


ASSIGN c-arquivo:VISIBLE IN FRAME f-pg-imp  = NO
       bt-arquivo:VISIBLE IN FRAME f-pg-imp = NO
       bt-config-impr:VISIBLE IN FRAME f-pg-imp = NO.

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
  ENABLE bt-executar bt-cancelar bt-ajuda im-pg-imp im-pg-par im-pg-sel 
      WITH FRAME f-relat IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY cnr-proc-imp-ini cnr-proc-imp-fim cembarque-ini cembarque-fim 
          cdecl-ini cdecl-fim citiner-ini citiner-fim ddata-ini ddata-fim 
          cpto-contr-ini cpto-contr-fim 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  ENABLE cnr-proc-imp-ini cnr-proc-imp-fim cembarque-ini cembarque-fim 
         cdecl-ini cdecl-fim citiner-ini citiner-fim ddata-ini ddata-fim 
         cpto-contr-ini cpto-contr-fim IMAGE-1 IMAGE-10 IMAGE-11 IMAGE-12 
         IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 IMAGE-9 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  DISPLAY rs-destino c-arquivo rs-execucao ltraduz lparam rs-execucao-2 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  ENABLE rs-destino bt-arquivo bt-config-impr c-arquivo rs-execucao ltraduz 
         lparam RECT-10 RECT-7 RECT-9 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  DISPLAY l-reemite l-dataefetiva 
      WITH FRAME f-pg-par IN WINDOW w-relat.
  ENABLE l-reemite l-dataefetiva 
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
define var r-tt-digita as rowid no-undo.

do on error undo, return error on stop  undo, return error:
    {include/i-rpexa.i}

    if input frame f-pg-imp rs-destino = 2 and
       input frame f-pg-imp rs-execucao = 1 then do:
        run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).

       if return-value = "NOK":U then do:
          run utp/ut-msgs.p (input "show", input 73, input "").

          apply "MOUSE-SELECT-CLICK":U to im-pg-imp in frame f-relat.
          apply "ENTRY":U to c-arquivo in frame f-pg-imp.
          return error.
       end.
    end.

    /* Coloque aqui as valida‡äes da p gina de Digita‡Æo, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p gina e colocar
       o focus no campo com problemas */
    /*browse br-digita:SET-REPOSITIONED-ROW (browse br-digita:DOWN, "ALWAYS":U).*/

/*    for each tt-digita no-lock:
 *         assign r-tt-digita = rowid(tt-digita).
 *         
 *         /* Valida‡Æo de duplicidade de registro na temp-table tt-digita */
 *         find first b-tt-digita where b-tt-digita.ordem = tt-digita.ordem and 
 *                                      rowid(b-tt-digita) <> rowid(tt-digita) no-lock no-error.
 *         if avail b-tt-digita then do:
 *             apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
 *             reposition br-digita to rowid rowid(b-tt-digita).
 *             
 *             run utp/ut-msgs.p (input "show", input 108, input "").
 *             apply "ENTRY":U to tt-digita.ordem in browse br-digita.
 *             
 *             return error.
 *         end.
 *         
 *         /* As demais valida‡äes devem ser feitas aqui */
 *         if tt-digita.ordem <= 0 then do:
 *             assign browse br-digita:CURRENT-COLUMN = tt-digita.ordem:HANDLE in browse br-digita.
 *             
 *             apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
 *             reposition br-digita to rowid r-tt-digita.
 *             
 *             run utp/ut-msgs.p (input "show", input 99999, input "").
 *             apply "ENTRY":U to tt-digita.ordem in browse br-digita.
 *             
 *             return error.
 *         end.
 *         
 *     end.*/


    /* Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */

    /* Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */

    create tt-param.
    assign tt-param.usuario       = c-seg-usuario
           tt-param.destino       = input frame f-pg-imp rs-destino
           tt-param.data-exec     = today
           tt-param.hora-exec     = time
           tt-param.c-proc-ini    = input frame f-pg-sel cnr-proc-imp-ini
           tt-param.c-proc-fim    = input frame f-pg-sel cnr-proc-imp-fim
           tt-param.c-emb-ini     = input frame f-pg-sel cembarque-ini
           tt-param.c-emb-fim     = input frame f-pg-sel cembarque-fim
           tt-param.i-decl-ini    = input frame f-pg-sel cdecl-ini
           tt-param.i-decl-fim    = input frame f-pg-sel cdecl-fim
           tt-param.i-itiner-ini  = input frame f-pg-sel citiner-ini
           tt-param.i-itiner-fim  = input frame f-pg-sel citiner-fim
           tt-param.da-data-ini   = input frame f-pg-sel ddata-ini
           tt-param.da-data-fim   = input frame f-pg-sel ddata-fim
           tt-param.i-pto-con-ini = input frame f-pg-sel cpto-contr-ini
           tt-param.i-pto-con-fim = input frame f-pg-sel cpto-contr-fim
           tt-param.l-traduz      = input frame f-pg-imp ltraduz
           tt-param.l-reemite     = input frame f-pg-par l-reemite
           tt-param.l-imprime     = input frame f-pg-imp lparam
           tt-param.diretorio     = session:temp-directory.

    &IF DEFINED(bf-mat-comex) &THEN
        ASSIGN tt-param.l-dataefetiva = NO.
    &else
        If can-find(FIRST funcao where funcao.cd-funcao = "spp-caraiba-fo897776" and funcao.ativo = yes)  then
            ASSIGN tt-param.l-dataefetiva = INPUT FRAME f-pg-par l-dataefetiva.
        ELSE
            ASSIGN tt-param.l-dataefetiva = NO.
    &ENDIF
    
    assign tt-param.c-endmail = " ".

    if tt-param.destino = 1 then 
       assign tt-param.arquivo = "".
    else 
    if tt-param.destino = 1 then 
       assign tt-param.arquivo = "".
    else 
    if tt-param.destino = 2 OR tt-param.destino = 4 then 
        assign tt-param.arquivo = c-programa-mg97 + ".tmp".
    ELSE DO:
        assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".
        if tt-param.destino = 3 then 
           assign tt-param.arquivo   = session:temp-directory + c-programa-mg97 + ".tmp".

    END.

    /*******
    if tt-param.destino = 2 then 
        assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
    else DO:
        /*altera‡Æo realizada mas nao surtiu efeito*/
        IF input frame f-pg-imp rs-execucao = 1 THEN
           assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".
        ELSE
           assign tt-param.arquivo   = /*session:temp-directory +*/ c-programa-mg97 + ".tmp".
        /***********/    
        if tt-param.destino = 3 then 
           assign tt-param.arquivo   = session:temp-directory + c-programa-mg97 + ".tmp".
    END.
    ******/

    &IF DEFINED(bf-mat-comex) &THEN
        if tt-param.destino = 4 then
           assign tt-param.c-endmail = input frame f-pg-imp c-arquivo
                  tt-param.arquivo   = STRING(session:temp-directory).
    &ENDIF

    if tt-param.destino = 4 then 
         assign tt-param.l-envia = yes.  
    else 
         assign tt-param.l-envia = no.        

    /* Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */



    /* Executar do programa RP.P que ir  criar o relat¢rio */
    {include/i-rpexb.i}

    SESSION:SET-WAIT-STATE("general":U).

    {include/i-rprun.i imp/im0200rp.p}

    {include/i-rpexc.i}

    SESSION:SET-WAIT-STATE("":U).

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

