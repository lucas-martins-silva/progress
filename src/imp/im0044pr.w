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
{include/i-prgvrs.i IM0044PR 2.00.00.009}  /*** "010009" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0044pr MIM}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessadores do Template de Relat¢rio                            */
/* Obs: Retirar o valor do preprocessador para as p ginas que nÆo existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA f-pg-cla
&GLOBAL-DEFINE PGPAR 
&GLOBAL-DEFINE PGDIG 
&GLOBAL-DEFINE PGIMP 

/* Parameters Definitions ---                                           */

DEFINE INPUT-OUTPUT PARAMETER v-cod-estab-f           AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-cod-estab-i           AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-cod-proces-imp-f      AS CHARACTER    nO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-cod-proces-imp-i      AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-cod-fornec-f          AS INTEGER      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-cod-fornec-i          AS INTEGER      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-num-ped-compra-f      AS INTEGER      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-num-ped-compra-i      AS INTEGER      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-num-ordem-compra-f    AS INTEGER      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-num-ordem-compra-i    AS INTEGER      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-cod-incoterm-f        AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-cod-incoterm-i        AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-cod-item-f            AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-cod-item-i            AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-dat-embarq-f          AS DATE         NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-dat-embarq-i          AS DATE         NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-cod-itinerario-i      AS INTEGER      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-cod-itinerario-f      AS INTEGER      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-rs-classif            AS INTEGER      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-sit-emb               AS INTEGER      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-cod-placa-f           AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-cod-placa-i           AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-dat-entreg-f          AS DATE         NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-dat-entreg-i          AS DATE         NO-UNDO.
DEFINE OUTPUT       PARAMETER v-cria                  AS LOGICAL      NO-UNDO.

/* Local Variable Definitions ---                                       */
def var wh-label-sel     as widget-handle no-undo.
def var wh-label-cla     as widget-handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-pg-cla

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS v-cod-placa-ini v-cod-placa-fim ~
v-dat-entreg-ini v-dat-entreg-fim IMAGE-19 IMAGE-20 IMAGE-21 IMAGE-22 ~
RECT-22 
&Scoped-Define DISPLAYED-OBJECTS v-cod-placa-ini v-cod-placa-fim ~
v-dat-entreg-ini v-dat-entreg-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-relat AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE v-cod-placa-fim AS CHARACTER FORMAT "X(20)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 22.14 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-placa-ini AS CHARACTER FORMAT "X(20)":U 
     LABEL "Ve¡culo" 
     VIEW-AS FILL-IN 
     SIZE 22.14 BY .88 NO-UNDO.

DEFINE VARIABLE v-dat-entreg-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE v-dat-entreg-ini AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data de Entrada" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-19
     FILENAME "IMAGE~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "IMAGE~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "IMAGE~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "IMAGE~\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 70 BY 3.25.

DEFINE VARIABLE v-cod-estab-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-estab-ini LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R7 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-fornec-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-fornec-ini AS INTEGER FORMAT "->>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-incoterm-fim AS CHARACTER FORMAT "X(3)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-incoterm-ini AS CHARACTER FORMAT "X(3)" 
     LABEL "Incoterm" 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-item-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 21.72 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-item-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-itinerario-fim AS INTEGER FORMAT ">>,>>9" INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 8.72 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-itinerario-ini AS INTEGER FORMAT ">>,>>9" INITIAL 0 
     LABEL "Itiner rio" 
     VIEW-AS FILL-IN 
     SIZE 8.72 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-proces-imp-fim AS CHARACTER FORMAT "X(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-proces-imp-ini AS CHARACTER FORMAT "X(12)" 
     LABEL "Processo Importa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .88 NO-UNDO.

DEFINE VARIABLE v-dat-embarq-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE v-dat-embarq-ini AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data Embarque" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE v-num-ordem-compra-fim AS INTEGER FORMAT ">>>>>9,99":U INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .88 NO-UNDO.

DEFINE VARIABLE v-num-ordem-compra-ini AS INTEGER FORMAT ">>>>>9,99":U INITIAL 0 
     LABEL "Ordem Compra" 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .88 NO-UNDO.

DEFINE VARIABLE v-num-ped-compra-fim AS INTEGER FORMAT ">>>>>,>>9":U INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 12.72 BY .88 NO-UNDO.

DEFINE VARIABLE v-num-ped-compra-ini AS INTEGER FORMAT ">>>>>,>>9":U INITIAL 0 
     LABEL "Pedido Compra" 
     VIEW-AS FILL-IN 
     SIZE 12.72 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-23
     FILENAME "IMAGE~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "IMAGE~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "IMAGE~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "IMAGE~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-27
     FILENAME "IMAGE~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "IMAGE~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "IMAGE~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "IMAGE~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-31
     FILENAME "IMAGE~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-32
     FILENAME "IMAGE~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-33
     FILENAME "IMAGE~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-34
     FILENAME "IMAGE~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-35
     FILENAME "IMAGE~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-36
     FILENAME "IMAGE~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-37
     FILENAME "IMAGE~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-38
     FILENAME "IMAGE~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-39
     FILENAME "IMAGE~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-40
     FILENAME "IMAGE~\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-classif AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Ordem       ", 1,
"Item        ", 2,
"Data Entrega", 3,
"Item/Data Entrega", 4
     SIZE 52.14 BY .71 NO-UNDO.

DEFINE VARIABLE rs-sit-emb AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "NÆo Encerradas", 1,
"Encerrados    ", 2,
"Todos         ", 3
     SIZE 46 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 70 BY 8.5.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 70 BY 3.04.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 70 BY 1.5.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 70 BY 1.5.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE selecao-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Sele‡Æo 2" 
      VIEW-AS TEXT 
     SIZE 13 BY .83 NO-UNDO.

DEFINE IMAGE im-pg-cla
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 74 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 0  
     SIZE 73.14 BY .13
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL 
     SIZE 74 BY 16.75
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0  
     SIZE .57 BY 16.71
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0  
     SIZE .57 BY 16.58
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0  
     SIZE 73.72 BY .13
     BGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     bt-executar AT ROW 19.71 COL 3 HELP
          "Dispara a execu‡Æo do relat¢rio"
     bt-cancelar AT ROW 19.71 COL 14 HELP
          "Fechar"
     bt-ajuda AT ROW 19.71 COL 64.86 HELP
          "Ajuda"
     selecao-2 AT ROW 1.67 COL 17.72 COLON-ALIGNED NO-LABEL
     "Sele‡Æo 1" VIEW-AS TEXT
          SIZE 13 BY .83 AT ROW 1.67 COL 4
     im-pg-cla AT ROW 1.5 COL 17.86
     RECT-1 AT ROW 19.46 COL 2
     RECT-6 AT ROW 19.25 COL 2.14
     rt-folder AT ROW 2.5 COL 2
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.67 COL 74.86
     rt-folder-top AT ROW 2.54 COL 2.14
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 75.86 BY 20.17
         FONT 1
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-sel
     v-cod-estab-ini AT ROW 2.5 COL 16.57 COLON-ALIGNED
          LABEL "Estabelecimento":R7
     v-cod-estab-fim AT ROW 2.5 COL 42.29 COLON-ALIGNED NO-LABEL
     v-cod-proces-imp-ini AT ROW 3.5 COL 16.57 COLON-ALIGNED HELP
          "Processo de importa‡Æo inicial"
     v-cod-proces-imp-fim AT ROW 3.5 COL 42.29 COLON-ALIGNED HELP
          "Processo de importa‡Æo final" NO-LABEL
     v-cod-fornec-ini AT ROW 4.5 COL 16.57 COLON-ALIGNED HELP
          "C¢digo fornecedor inicial"
     v-cod-fornec-fim AT ROW 4.5 COL 42.29 COLON-ALIGNED HELP
          "C¢digo fornecedor final" NO-LABEL
     v-num-ped-compra-ini AT ROW 5.5 COL 16.57 COLON-ALIGNED HELP
          "Pedido de compra inicial"
     v-num-ped-compra-fim AT ROW 5.5 COL 42.29 COLON-ALIGNED HELP
          "Pedido de compra final" NO-LABEL
     v-num-ordem-compra-ini AT ROW 6.5 COL 16.57 COLON-ALIGNED HELP
          "Ordem compra inicial"
     v-num-ordem-compra-fim AT ROW 6.5 COL 42.29 COLON-ALIGNED HELP
          "Ordem compra inicial" NO-LABEL
     v-cod-incoterm-ini AT ROW 7.5 COL 16.57 COLON-ALIGNED HELP
          "Codigo incoterm inicial"
     v-cod-incoterm-fim AT ROW 7.5 COL 42.29 COLON-ALIGNED HELP
          "Codigo incoterm final" NO-LABEL
     v-cod-item-ini AT ROW 8.5 COL 16.57 COLON-ALIGNED HELP
          "Codigo do item inicial"
     v-cod-item-fim AT ROW 8.5 COL 42.29 COLON-ALIGNED HELP
          "Codigo do item inicial" NO-LABEL
     v-dat-embarq-ini AT ROW 11.08 COL 16.57 COLON-ALIGNED HELP
          "Data de embarque inicial"
     v-dat-embarq-fim AT ROW 11.08 COL 42.29 COLON-ALIGNED HELP
          "Data de embarque inicial" NO-LABEL
     v-cod-itinerario-ini AT ROW 12.08 COL 16.57 COLON-ALIGNED HELP
          "C¢digo do itiner rio inicial"
     v-cod-itinerario-fim AT ROW 12.08 COL 42.29 COLON-ALIGNED HELP
          "C¢digo do itiner rio inicial" NO-LABEL
     rs-classif AT ROW 14.33 COL 11.86 HELP
          "Classifica a apresenta‡Æo no browse" NO-LABEL
     rs-sit-emb AT ROW 16.17 COL 11.72 HELP
          "Classifica a apresenta‡Æo no browse" NO-LABEL
     "Situa‡Æo de Embarques/Previsäes" VIEW-AS TEXT
          SIZE 25.29 BY .67 AT ROW 15.38 COL 3.72
     "Classifica‡Æo das Ordens" VIEW-AS TEXT
          SIZE 19.29 BY .67 AT ROW 13.54 COL 3.72
     "Sele‡Æo para Ordens e Embarques/Previsäes" VIEW-AS TEXT
          SIZE 33.29 BY .67 AT ROW 1.21 COL 4.29
     "Sele‡Æo Exclusiva para Embarques/Previs" VIEW-AS TEXT
          SIZE 31 BY .75 AT ROW 10.08 COL 4
     IMAGE-23 AT ROW 2.5 COL 35.72
     IMAGE-24 AT ROW 6.5 COL 40
     IMAGE-25 AT ROW 7.5 COL 35.72
     IMAGE-26 AT ROW 7.5 COL 40
     IMAGE-27 AT ROW 8.5 COL 35.72
     IMAGE-28 AT ROW 8.5 COL 40
     IMAGE-29 AT ROW 11.08 COL 35.86
     IMAGE-30 AT ROW 12.08 COL 40
     IMAGE-31 AT ROW 12.08 COL 35.86
     IMAGE-32 AT ROW 11.08 COL 40
     IMAGE-33 AT ROW 2.5 COL 40
     IMAGE-34 AT ROW 3.5 COL 35.72
     IMAGE-35 AT ROW 3.5 COL 40
     IMAGE-36 AT ROW 4.5 COL 35.72
     IMAGE-37 AT ROW 4.5 COL 40
     IMAGE-38 AT ROW 5.5 COL 35.72
     IMAGE-39 AT ROW 5.5 COL 40
     IMAGE-40 AT ROW 6.5 COL 35.72
     RECT-17 AT ROW 1.5 COL 2
     RECT-19 AT ROW 10.38 COL 2
     RECT-20 AT ROW 13.79 COL 2
     RECT-21 AT ROW 15.67 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.83
         SIZE 72.72 BY 16.42
         FONT 1.

DEFINE FRAME f-pg-cla
     v-cod-placa-ini AT ROW 2.25 COL 13 COLON-ALIGNED
     v-cod-placa-fim AT ROW 2.21 COL 43.72 COLON-ALIGNED NO-LABEL
     v-dat-entreg-ini AT ROW 3.21 COL 13 COLON-ALIGNED
     v-dat-entreg-fim AT ROW 3.21 COL 43.72 COLON-ALIGNED NO-LABEL
     "Sele‡Æo Embarque / Ve¡culo" VIEW-AS TEXT
          SIZE 21.14 BY .54 AT ROW 1.25 COL 3.14
     IMAGE-19 AT ROW 2.21 COL 37.72
     IMAGE-20 AT ROW 2.21 COL 42
     IMAGE-21 AT ROW 3.21 COL 37.72
     IMAGE-22 AT ROW 3.21 COL 42
     RECT-22 AT ROW 1.54 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.83
         SIZE 72.29 BY 16.29
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
         TITLE              = ""
         HEIGHT             = 20.33
         WIDTH              = 75.43
         MAX-HEIGHT         = 22.33
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22.33
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
/* REPARENT FRAME */
ASSIGN FRAME f-pg-cla:FRAME = FRAME f-relat:HANDLE
       FRAME f-pg-sel:FRAME = FRAME f-relat:HANDLE.

/* SETTINGS FOR FRAME f-pg-cla
   Custom                                                               */
/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FILL-IN v-cod-estab-fim IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
/* SETTINGS FOR FILL-IN v-cod-estab-ini IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
/* SETTINGS FOR FRAME f-relat
   Custom                                                               */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME f-pg-cla:MOVE-AFTER-TAB-ITEM (bt-ajuda:HANDLE IN FRAME f-relat)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR IMAGE im-pg-cla IN FRAME f-relat
   NO-ENABLE                                                            */
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
/* SETTINGS FOR FILL-IN selecao-2 IN FRAME f-relat
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
ON END-ERROR OF w-relat
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON WINDOW-CLOSE OF w-relat
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
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar w-relat
ON CHOOSE OF bt-executar IN FRAME f-relat /* OK */
DO:
    ASSIGN  v-cod-estab-f           = INPUT FRAME f-pg-sel v-cod-estab-fim
            v-cod-estab-i           = INPUT FRAME f-pg-sel v-cod-estab-ini
            v-cod-proces-imp-f      = INPUT FRAME f-pg-sel v-cod-proces-imp-fim
            v-cod-proces-imp-i      = INPUT FRAME f-pg-sel v-cod-proces-imp-ini
            v-cod-fornec-f          = INPUT FRAME f-pg-sel v-cod-fornec-fim
            v-cod-fornec-i          = INPUT FRAME f-pg-sel v-cod-fornec-ini
            v-num-ped-compra-f      = INPUT FRAME f-pg-sel v-num-ped-compra-fim
            v-num-ped-compra-i      = INPUT FRAME f-pg-sel v-num-ped-compra-ini
            v-num-ordem-compra-f    = INPUT FRAME f-pg-sel v-num-ordem-compra-fim
            v-num-ordem-compra-i    = INPUT FRAME f-pg-sel v-num-ordem-compra-ini
            v-cod-incoterm-f        = INPUT FRAME f-pg-sel v-cod-incoterm-fim
            v-cod-incoterm-i        = INPUT FRAME f-pg-sel v-cod-incoterm-ini
            v-cod-item-f            = INPUT FRAME f-pg-sel v-cod-item-fim
            v-cod-item-i            = INPUT FRAME f-pg-sel v-cod-item-ini
            v-dat-embarq-f          = INPUT FRAME f-pg-sel v-dat-embarq-fim
            v-dat-embarq-i          = INPUT FRAME f-pg-sel v-dat-embarq-ini
            v-cod-itinerario-i      = INPUT FRAME f-pg-sel v-cod-itinerario-ini
            v-cod-itinerario-f      = INPUT FRAME f-pg-sel v-cod-itinerario-fim
            v-rs-classif            = INPUT FRAME f-pg-sel rs-classif
            v-sit-emb               = INPUT FRAME f-pg-sel rs-sit-emb
            v-cod-placa-f           = INPUT FRAME f-pg-cla v-cod-placa-fim 
            v-cod-placa-i           = INPUT FRAME f-pg-cla v-cod-placa-ini 
            v-dat-entreg-f          = INPUT FRAME f-pg-cla v-dat-entreg-fim
            v-dat-entreg-i          = INPUT FRAME f-pg-cla v-dat-entreg-ini
            v-cria                  = YES. 

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-cla
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-cla w-relat
ON MOUSE-SELECT-CLICK OF im-pg-cla IN FRAME f-relat
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


&Scoped-define FRAME-NAME f-pg-cla
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-relat 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.
RUN pi_aplica_facelift_thin IN h-facelift ( INPUT FRAME f-relat:handle ).
/* ******* Editado automaticamente para o projeto de facelift ******* */

{utp/ut9000.i "IM0044PR" "2.00.00.009"}

do with frame f-relat:
    &IF "{&PGSEL}" <> "" &THEN
        if  im-pg-sel:load-image("image/im-fldup") then.
        assign im-pg-sel:height = 1.20
               im-pg-sel:row    = 1.50.
    &ENDIF
    &IF "{&PGCLA}" <> "" &THEN
        if  im-pg-cla:load-image("image/im-flddn") then.
        if  im-pg-cla:move-to-bottom() then.
        assign im-pg-cla:height = 1
               im-pg-cla:row    = 1.6.
    &ENDIF
end.

run pi-habilita-pag-2 in this-procedure.

run pi_aplica_facelift_thin in h-facelift ( input frame f-relat:handle ).
run pi_aplica_facelift_thin in h-facelift ( input frame f-pg-sel:handle ).
run pi_aplica_facelift_thin in h-facelift ( input frame f-pg-cla:handle ).

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.


/************************************************************************************/
/************************************************************************************/
/* Parte da include {include/i-rplbl.i} que faz a troca de folder no Smart - inicio */
/************************************************************************************/
/************************************************************************************/
def var c-list-folders   as char no-undo.
def var i-current-folder as int  no-undo.
ASSIGN i-current-folder = 1.

/**********************************************************
** Troca de pÿgina por CTRL-TAB e SHIFT-CTRL-TAB
**********************************************************/
&if "{&PGSEL}" <> "" &then
    assign c-list-folders = c-list-folders + "im-pg-sel,":U.
&endif

&if "{&PGCLA}" <> "" &then
    assign c-list-folders = c-list-folders + "im-pg-cla,":U.
&endif

if  substring(c-list-folders, length(c-list-folders)) = "," then
    assign c-list-folders = substring(c-list-folders, 1, length(c-list-folders) - 1).

on  CTRL-TAB,SHIFT-CTRL-TAB anywhere do:
    def var h_handle  as handle no-undo.
    def var c_imagem  as char   no-undo.
    def var l_direita as log    no-undo.
    l_direita = last-event:label = 'CTRL-TAB':U.

    block1:
    repeat:
        if  l_direita then
            assign i-current-folder = if i-current-folder = num-entries(c-list-folders) then 1 else i-current-folder + 1.
        else
            assign i-current-folder = if i-current-folder = 1 then num-entries(c-list-folders) else i-current-folder - 1.

        assign c_imagem = entry(i-current-folder, c-list-folders)
               h_handle = frame f-relat:first-child
               h_handle = h_handle:first-child.

        do  while valid-handle(h_handle):
            if  h_handle:type = 'image':U and
                h_handle:name = c_imagem  then do:
                if  h_handle:sensitive = no then next block1.
                apply 'mouse-select-click':U to h_handle.
                leave block1.
            end.
            h_handle = h_handle:next-sibling.
        end.
    end.
end.

/**********************************************************
** Procedure de troca de pÿgina por CTRL-TAB
**********************************************************/
procedure pi-first-child:
&IF "{&product_version}" >= "12.1.X.2307" &THEN
    {include/i-rpfch.i relDtv}
&ELSE
/* **** Editado automaticamente para o projeto de facelift **** */
    def input param wh-entry-folder as widget-handle.

    assign wh-entry-folder = wh-entry-folder:first-child
           wh-entry-folder = wh-entry-folder:first-child.

    do  while(valid-handle(wh-entry-folder)):
        if  wh-entry-folder:sensitive = yes       and
            wh-entry-folder:type <> 'rectangle':U and
            wh-entry-folder:type <> 'image':U     and
            wh-entry-folder:type <> 'browse':U    then do:
            apply 'entry':U to wh-entry-folder.
            leave.
        end.
        else
            assign wh-entry-folder = wh-entry-folder:next-sibling.
    end.
&ENDIF
end.                                         
/************************************************************************************/
/************************************************************************************/
/* Parte da include {include/i-rplbl.i} que faz a troca de folder no Smart - final  */
/************************************************************************************/
/************************************************************************************/

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.

    RUN dispatch ('initialize':U).
    IF RETURN-VALUE = 'ADM-ERROR':U THEN RETURN.

    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

PROCEDURE WinExec  EXTERNAL  "kernel32.dll":
  DEF INPUT PARAM prg_name      AS CHARACTER.
  DEF INPUT PARAM prg_style     AS SHORT.
END PROCEDURE.

&IF "{&mguni_version}" >= "2.071" &THEN
    ASSIGN v-cod-estab-fim:SCREEN-VALUE IN FRAME f-pg-sel = "ZZZZZ".
&ELSE
    ASSIGN v-cod-estab-fim:SCREEN-VALUE IN FRAME f-pg-sel = "ZZZ".
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
  DISPLAY selecao-2 
      WITH FRAME f-relat IN WINDOW w-relat.
  ENABLE bt-executar bt-cancelar bt-ajuda im-pg-sel 
      WITH FRAME f-relat IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY v-cod-placa-ini v-cod-placa-fim v-dat-entreg-ini v-dat-entreg-fim 
      WITH FRAME f-pg-cla IN WINDOW w-relat.
  ENABLE v-cod-placa-ini v-cod-placa-fim v-dat-entreg-ini v-dat-entreg-fim 
         IMAGE-19 IMAGE-20 IMAGE-21 IMAGE-22 RECT-22 
      WITH FRAME f-pg-cla IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-cla}
  DISPLAY v-cod-estab-ini v-cod-estab-fim v-cod-proces-imp-ini 
          v-cod-proces-imp-fim v-cod-fornec-ini v-cod-fornec-fim 
          v-num-ped-compra-ini v-num-ped-compra-fim v-num-ordem-compra-ini 
          v-num-ordem-compra-fim v-cod-incoterm-ini v-cod-incoterm-fim 
          v-cod-item-ini v-cod-item-fim v-dat-embarq-ini v-dat-embarq-fim 
          v-cod-itinerario-ini v-cod-itinerario-fim rs-classif rs-sit-emb 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  ENABLE IMAGE-23 IMAGE-24 IMAGE-25 IMAGE-26 IMAGE-27 IMAGE-28 IMAGE-29 
         IMAGE-30 IMAGE-31 IMAGE-32 IMAGE-33 IMAGE-34 IMAGE-35 IMAGE-36 
         IMAGE-37 IMAGE-38 IMAGE-39 IMAGE-40 RECT-17 RECT-19 RECT-20 RECT-21 
         v-cod-estab-ini v-cod-estab-fim v-cod-proces-imp-ini 
         v-cod-proces-imp-fim v-cod-fornec-ini v-cod-fornec-fim 
         v-num-ped-compra-ini v-num-ped-compra-fim v-num-ordem-compra-ini 
         v-num-ordem-compra-fim v-cod-incoterm-ini v-cod-incoterm-fim 
         v-cod-item-ini v-cod-item-fim v-dat-embarq-ini v-dat-embarq-fim 
         v-cod-itinerario-ini v-cod-itinerario-fim rs-classif rs-sit-emb 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
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

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-relat 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

{utp/ut9000.i "IM0044PR" "2.00.00.009"}

   assign v-cod-estab-fim        = v-cod-estab-f           
          v-cod-estab-ini        = v-cod-estab-i           
          v-cod-proces-imp-fim   = v-cod-proces-imp-f      
          v-cod-proces-imp-ini   = v-cod-proces-imp-i      
          v-cod-fornec-fim       = v-cod-fornec-f          
          v-cod-fornec-ini       = v-cod-fornec-i          
          v-num-ped-compra-fim   = v-num-ped-compra-f      
          v-num-ped-compra-ini   = v-num-ped-compra-i      
          v-num-ordem-compra-fim = v-num-ordem-compra-f    
          v-num-ordem-compra-ini = v-num-ordem-compra-i    
          v-cod-incoterm-fim     = v-cod-incoterm-f        
          v-cod-incoterm-ini     = v-cod-incoterm-i        
          v-cod-item-fim         = v-cod-item-f            
          v-cod-item-ini         = v-cod-item-i            
          v-dat-embarq-fim       = v-dat-embarq-f          
          v-dat-embarq-ini       = v-dat-embarq-i          
          v-cod-itinerario-ini   = v-cod-itinerario-i      
          v-cod-itinerario-fim   = v-cod-itinerario-f      
          rs-classif             = v-rs-classif
          rs-sit-emb             = v-sit-emb
          v-cod-placa-fim        = v-cod-placa-f  
          v-cod-placa-ini        = v-cod-placa-i  
          v-dat-entreg-fim       = v-dat-entreg-f
          v-dat-entreg-ini       = v-dat-entreg-i. 

    DISPLAY v-cod-estab-fim       
            v-cod-estab-ini       
            v-cod-proces-imp-fim  
            v-cod-proces-imp-ini  
            v-cod-fornec-fim      
            v-cod-fornec-ini      
            v-num-ped-compra-fim  
            v-num-ped-compra-ini  
            v-num-ordem-compra-fim
            v-num-ordem-compra-ini
            v-cod-incoterm-fim    
            v-cod-incoterm-ini    
            v-cod-item-fim        
            v-cod-item-ini        
            v-dat-embarq-fim      
            v-dat-embarq-ini      
            v-cod-itinerario-ini  
            v-cod-itinerario-fim  
            rs-classif            
            rs-sit-emb            
            WITH FRAME f-pg-sel.
    
    DISPLAY v-cod-placa-fim
            v-cod-placa-ini
            v-dat-entreg-fim
            v-dat-entreg-ini
            WITH FRAME f-pg-cla.
    

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  apply "entry" to v-cod-estab-ini in frame f-pg-sel.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-pag-2 w-relat 
PROCEDURE pi-habilita-pag-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    find first param-global no-lock no-error.
    if avail param-global and param-global.log-modul-eq = yes then do:
            assign im-pg-cla:hidden in frame f-relat = NO
                   selecao-2:blank  in frame f-relat = NO.
            enable im-pg-cla with frame f-relat.    
    end.
    else do: 
         assign im-pg-cla:hidden in frame f-relat = yes
                selecao-2:blank  in frame f-relat = yes.
         disable im-pg-cla with frame f-relat.  
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina w-relat 
PROCEDURE pi-troca-pagina :
/* *** Editado automaticamente para o projeto de facelift *** */
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
    def input param p-issuer-hdl as handle no-undo.
    def input param p-state      as char   no-undo.

    run pi-trata-state (p-issuer-hdl, p-state).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

