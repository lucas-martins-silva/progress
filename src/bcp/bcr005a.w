&Scoped-define WINDOW-NAME C-Win

/*------------------------------------------------------------------------
File.............: bcr005a.w
Description......: Relat¢rio de Coletores
Input Parameters : 
Output Parameters: 
Author...........: DATASUL S.A.
Created..........: 02/09/98 - 16:47 - bc
OBS..............: Este fonte foi gerado pelo Data Viewer
------------------------------------------------------------------------*/

CREATE WIDGET-POOL. 

/* ***************************  Definitions  ************************** */

/* Preprocessadores do Template de Relat¢rio                            */

&GLOBAL-DEFINE PGSEL f-pg-sel 
&GLOBAL-DEFINE PGPAR f-pg-par 
&GLOBAL-DEFINE PGIMP f-pg-imp 

/* Include Com as Vari†veis Globais */
{include/i_fnctrad.i}
/*** In°cio ut-glob.i Definiá∆o de vari†veis globais ***/ 

&IF defined(GLOBALS) &THEN 

&ELSE
     &glob GLOBALS OK 

   DEF NEW GLOBAL SHARED VAR i-ep-codigo-usuario  LIKE empresa.ep-codigo  NO-UNDO.
   DEF NEW GLOBAL SHARED VAR l-implanta           AS LOGICAL    INIT NO.
   DEF NEW GLOBAL SHARED VAR c-seg-usuario        AS CHAR FORMAT "x(12)"  NO-UNDO.
   DEF NEW GLOBAL SHARED VAR i-num-ped-exec-rpw   AS INTEGER              NO-UNDO.   
   DEF VAR rw-log-exec                            AS ROWID                NO-UNDO.
   DEF NEW GLOBAL SHARED VAR i-pais-impto-usuario AS INTEGER FORMAT ">>9" NO-UNDO.
   DEF NEW GLOBAL SHARED VAR l-rpc AS LOGICAL NO-UNDO.
   DEF NEW GLOBAL SHARED TEMP-TABLE tt-servid-rpc-aplicat NO-UNDO
      FIELD tta-cod-aplicat-dtsul LIKE aplicat_dtsul.cod_aplicat_dtsul
      FIELD tta-hdl-servid-rpc    AS   HANDLE.
   DEF VAR c-erro-rpc AS CHARACTER FORMAT "x(60)" INITIAL " " NO-UNDO.
   DEF VAR c-erro-aux AS CHARACTER FORMAT "x(60)" INITIAL " " NO-UNDO.
   DEF NEW GLOBAL SHARED VAR r-registro-atual AS ROWID        NO-UNDO.
   DEF NEW GLOBAL SHARED VAR c-arquivo-log    AS CHAR  FORMAT "x(60)"NO-UNDO.
     
   /* Vari†veis Padr∆o DWB / Datasul HR */
   DEF NEW GLOBAL SHARED VAR i-num-ped              AS INTEGER                  NO-UNDO.         
   DEF NEW GLOBAL SHARED VAR v_cdn_empres_usuar   LIKE empresa.ep-codigo        NO-UNDO.
   DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren   LIKE usuar_mestre.cod_usuario NO-UNDO.
   DEF NEW GLOBAL SHARED VAR h_prog_segur_estab     AS HANDLE                   NO-UNDO.
   DEF NEW GLOBAL SHARED VAR v_cod_grp_usuar_lst    AS CHAR                     NO-UNDO.
   DEF NEW GLOBAL SHARED VAR v_num_tip_aces_usuar   AS INT                      NO-UNDO.     
&ENDIF

/*** Fim ut-glob.i Definiá∆o de vari†veis globais ***/ 

/* Parameters Definitions ---                                           */ 

/* Temporary Table Definitions ---                                      */ 

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita AS RAW.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino              AS INTEGER
    FIELD arquivo              AS CHAR
    FIELD usuario              AS CHAR
    FIELD data-exec            AS DATE
    FIELD hora-exec            AS INTEGER
    FIELD parametro            AS LOGICAL
    FIELD formato              AS INTEGER
    FIELD v_num_tip_aces_usuar AS INTEGER
    FIELD ep-codigo         LIKE empresa.ep-codigo
    FIELD c-id-coletor-ini LIKE bc-coletor.id-coletor
    FIELD c-id-coletor-fim LIKE bc-coletor.id-coletor.

/* Transfer Definitions */
DEF VAR raw-param        AS RAW NO-UNDO.

/* Local Variable Definitions ---                                       */ 

DEF VAR l-ok                 AS LOGICAL NO-UNDO. 
DEF VAR c-arq-digita         AS CHAR    NO-UNDO. 
DEF VAR c-terminal           AS CHAR    NO-UNDO. 
DEF VAR v-cod-pg-mouse-selec AS CHAR    NO-UNDO. 
DEF VAR v-cod-prog-i-rprun   AS CHAR    NO-UNDO. 
DEF VAR v-cod-prog-gerado    AS CHAR    NO-UNDO. 

/****************** Definiáao de ParÉmetros do Relat¢rio *********************/ 

/****************** Definiáao de Vari†veis de Seleá∆o do Relat¢rio *********************/ 

DEF NEW SHARED VAR c-id-coletor-ini LIKE bc-coletor.id-coletor FORMAT "x(8)" INITIAL "" NO-UNDO.
DEF NEW SHARED VAR c-id-coletor-fim LIKE bc-coletor.id-coletor FORMAT "x(8)" INITIAL "ZZZZZZZZ" NO-UNDO.

/* ********************  Preprocessor Definitions  ******************** */ 

/* ***********************  Control Definitions  ********************** */ 

DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO. 
DEFINE NEW GLOBAL SHARED VARIABLE h-facelift AS HANDLE NO-UNDO.
IF NOT VALID-HANDLE(h-facelift) THEN RUN btb/btb901zo.p PERSISTENT SET h-facelift.
&IF "{&product_version}" >= "12.1.X.2307" &THEN
   IF LOOKUP("pi_altera_folder", h-facelift:INTERNAL-ENTRIES) = 0 AND
       LOG-MANAGER:LOGFILE-NAME <> ? THEN DO:
       LOG-MANAGER:WRITE-MESSAGE("****** Programa btb/btb901zo.p desatualizado ******","Facelift").
   END.
&ENDIF
/* ****** Editado automaticamente para o projeto de facelift ****** */

DEFINE BUTTON bt-arquivo 
IMAGE-UP FILE "image~\im-sea":U
IMAGE-INSENSITIVE FILE "image~\ii-sea":U
LABEL " "
SIZE 4 BY 1.

DEFINE BUTTON bt-config-impr 
IMAGE-UP FILE "image~\im-cfprt":U
LABEL " "
SIZE 4 BY 1.

DEFINE IMAGE IMAGE-1
FILENAME "image~\im-fir":U
SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
FILENAME "image~\im-las":U
SIZE 3 BY .88.

DEFINE IMAGE im-pg-imp
FILENAME "image~\im-fldup":U
SIZE 15.72 BY 1.19.

DEFINE IMAGE im-pg-par
FILENAME "image~\im-fldup":U
SIZE 15.72 BY 1.19.

DEFINE IMAGE im-pg-sel
FILENAME "image~\im-fldup":U
SIZE 15.72 BY 1.19.

DEFINE VARIABLE c-arquivo AS CHARACTER 
VIEW-AS EDITOR MAX-CHARS 256 
SIZE 40 BY 1.00 
BGCOLOR 15  FONT 2 NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL "Destino"
VIEW-AS TEXT 
SIZE 8.57 BY .62 NO-UNDO. 

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o"
VIEW-AS TEXT 
SIZE 10.86 BY .62 NO-UNDO.

DEFINE VARIABLE text-parametro AS CHARACTER FORMAT "X(256)":U INITIAL "ParÉmetros de Impress∆o"
VIEW-AS TEXT 
SIZE 24.72 BY .62 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 3 
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

DEFINE VARIABLE tb-parametro AS LOGICAL INITIAL NO 
LABEL "Imprimir P†gina de ParÉmetros"
VIEW-AS TOGGLE-BOX 
SIZE 32 BY .83 
NO-UNDO.

DEFINE VARIABLE rs-formato AS INTEGER INITIAL 2 
VIEW-AS RADIO-SET HORIZONTAL 
RADIO-BUTTONS 
"80 colunas", 1,
"132 colunas", 2
SIZE 32 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-7 
EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
SIZE 46.29 BY 2.92. 

DEFINE RECTANGLE RECT-9 
EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
SIZE 46.29 BY 1.69.

DEFINE RECTANGLE RECT-10 
EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
SIZE 46.29 BY 2.79.

DEFINE VARIABLE l-param-1 AS LOGICAL INITIAL NO 
LABEL "ParÉmetro 1"
VIEW-AS TOGGLE-BOX 
SIZE 44 BY 1.08 NO-UNDO. 

DEFINE BUTTON bt-ajuda 
LABEL "Ajuda"
SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
LABEL "Fechar"
SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
LABEL "Executar"
SIZE 10 BY 1.

DEFINE RECTANGLE RECT-1
EDGE-PIXELS 2 GRAPHIC-EDGE 
SIZE 79 BY 1.42 
BGCOLOR 7 . 

DEFINE RECTANGLE RECT-6
EDGE-PIXELS 0
SIZE 78.72 BY .12
BGCOLOR 7.

DEFINE RECTANGLE rt-folder
EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL
SIZE 79 BY 11.38
FGCOLOR 0.

DEFINE RECTANGLE rt-folder-left
EDGE-PIXELS 0
SIZE .43 BY 11.19
BGCOLOR 15.

DEFINE RECTANGLE rt-folder-right
EDGE-PIXELS 0
SIZE .43 BY 11.15
BGCOLOR 7.

DEFINE RECTANGLE rt-folder-top
EDGE-PIXELS 0
SIZE 78.72 BY .12
BGCOLOR 15 .

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
    bt-executar AT ROW 14.54 COL 3 HELP
"Dispara a execuá∆o do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
"Fechar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
"Ajuda"
     im-pg-sel AT ROW 1.5 COL 2.14
     im-pg-par AT ROW 1.5 COL 17.86
     im-pg-imp AT ROW 1.5 COL 33.58
     rt-folder AT ROW 2.5 COL 2
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.65 COL 80.43
     RECT-6 AT ROW 13.73 COL 2.14
     RECT-1 AT ROW 14.31 COL 2
     WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
     SIDE-LABELS NO-UNDERLINE THREE-D
     AT COL 1 ROW 1
     SIZE 81 BY 15
     DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-imp
    text-destino AT ROW 1.62 COL 3.86 NO-LABEL
    rs-destino AT ROW 2.38 COL 3.29 HELP
    "Destino de Impress∆o do Relat¢rio" NO-LABEL
    bt-arquivo AT ROW 3.58 COL 43.29 HELP
    "Escolha do nome do arquivo"
     bt-config-impr AT ROW 3.58 COL 43.29 HELP
    "Configuraá∆o da impressora"
     c-arquivo AT ROW 3.56 COL 3.29 HELP
    "Nome do arquivo de destino do relat¢rio" NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     rs-execucao AT ROW 5.77 COL 3 HELP
    "Modo de Execuá∆o" NO-LABEL
     tb-parametro AT ROW 7.92 COL 3.2
     rs-formato AT ROW 9 COL 3 HELP
    "Formato de Impress∆o" NO-LABEL
     text-parametro AT ROW 7.17 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.31 COL 2.14
     RECT-10 AT ROW 7.46 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
    SIDE-LABELS NO-UNDERLINE THREE-D
    AT COL 3 ROW 3
    SIZE 73.72 BY 10.

DEFINE FRAME f-pg-sel
   c-id-coletor-ini LABEL "Coletor"
     AT ROW 1 COL 13 COLON-ALIGNED
     VIEW-AS FILL-IN 
     SIZE 9 BY .88
     FONT 1

   c-id-coletor-fim NO-LABEL
     AT ROW 1 COL 32 COLON-ALIGNED
     VIEW-AS FILL-IN 
     SIZE 9 BY .88
     FONT 1

   IMAGE-1 AT ROW 01.00 COL 25
   IMAGE-2 AT ROW 01.00 COL 30
   WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
   SIDE-LABELS NO-UNDERLINE THREE-D
   AT COL 3 ROW 2.85
   SIZE 76.86 BY 10.62.

DEFINE FRAME f-pg-par

   WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
   SIDE-LABELS NO-UNDERLINE THREE-D
   AT COL 3 ROW 3
   SIZE 75 BY 10.

/* *************************  Create Window  ************************** */

CREATE WINDOW C-Win ASSIGN
   HIDDEN             = YES
   TITLE              = "Relat¢rio de Coletores - bcr005a"
   HEIGHT             = 15
   WIDTH              = 81.14
   MAX-HEIGHT         = 22.35
   MAX-WIDTH          = 114.29
   VIRTUAL-HEIGHT     = 22.35
   VIRTUAL-WIDTH      = 114.29
   RESIZE             = YES
   SCROLL-BARS        = NO
   STATUS-AREA        = YES
   BGCOLOR            = ?
   FGCOLOR            = ?
   KEEP-FRAME-Z-ORDER = YES
   THREE-D            = YES
   MESSAGE-AREA       = NO
   SENSITIVE          = YES.

/* ***************  Runtime Attributes and UIB Settings  ************** */

ASSIGN FRAME f-pg-imp:FRAME = FRAME f-relat:HANDLE
       FRAME f-pg-par:FRAME = FRAME f-relat:HANDLE
       FRAME f-pg-sel:FRAME = FRAME f-relat:HANDLE.

{utp/ut-liter.i Destino *}
ASSIGN text-destino:screen-value   IN FRAME f-pg-imp = RETURN-VALUE.
{utp/ut-liter.i Execuá∆o *}
ASSIGN text-modo:screen-value      IN FRAME f-pg-imp = RETURN-VALUE.
{utp/ut-liter.i ParÉmetros_de_Impress∆o *}
ASSIGN text-parametro:screen-value IN FRAME f-pg-imp = RETURN-VALUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = NO.

/* ************************* Included-Libraries *********************** */

&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCR005A 2.00.00.007} /*** "010007" 30/08/2024 09:32:50 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BCR005A MBC}
&ENDIF



/***********************  DEFINITIONS  ***********************************/

&glob SYSTEM-VARS yes

DEF VAR c-programa-mg97       AS CHAR FORMAT "x(08)" NO-UNDO.
DEF VAR c-versao-mg97         AS CHAR FORMAT "x(08)" NO-UNDO.
DEF VAR c-modulo-mg97         AS CHAR FORMAT "x(08)" NO-UNDO.
DEF VAR c-titulo-prog-mg97    AS CHAR FORMAT "x(08)" NO-UNDO.
DEF VAR i-num-topico-hlp-mg97 AS INTEGER             NO-UNDO.
DEF VAR c-nom-manual-hlp-mg97 AS CHAR FORMAT "x(06)" NO-UNDO.
DEF VAR i-ctrl-tab-page       AS INTEGER             NO-UNDO.
DEF VAR i-ctrl-tab-folder     AS INTEGER             NO-UNDO.
DEF VAR lDisableUPC           AS LOGICAL             NO-UNDO.

&IF DEFINED(PGIMP) &THEN
    &Scoped-Define FRAME-NAME 
&ENDIF

&IF DEFINED(PGLOG) &THEN
    &Scoped-Define FRAME-NAME 
&ENDIF

&IF DEFINED(adm-containr) = 0 &THEN
&GLOB adm-containr yes

&IF DEFINED(adm-attribute-dlg) = 0 &THEN
&SCOP adm-attribute-dlg adm/support/contnrd.w
&ENDIF

&IF DEFINED(adm-attribute-list) = 0 &THEN
&SCOP adm-attribute-list Layout,Hide-on-Init
&ENDIF

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 

/* ************************* Included-Libraries *********************** */
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 

/* ***************************  Definitions  ************************** */

DEF VAR c-nom-prog-upc-mg97  AS CHAR FORMAT "x(50)" NO-UNDO.
DEF VAR c-nom-prog-appc-mg97 AS CHAR FORMAT "x(50)" NO-UNDO.
DEF VAR c-nom-prog-dpc-mg97  AS CHAR FORMAT "x(50)" NO-UNDO.
DEF VAR c-ctrl-tab           AS CHAR                NO-UNDO.
DEF VAR h-ctrl-tab           AS HANDLE              NO-UNDO.
DEF VAR wh-entry-field       AS WIDGET-HANDLE       NO-UNDO.

&IF DEFINED (adm-smart) = 0 &THEN
&GLOBAL adm-smart

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
&ANALYZE-RESUME
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */
&IF DEFINED (adm-attribut) = 0 &THEN
&GLOB adm-attribut yes

&GLOB      adm-version ADM1.1

&IF INT(ENTRY(1,PROVERSION,".")) >= 8 &THEN
  &GLOB    ADM-DATA      ADM-DATA
  &GLOB    UNLESS-HIDDEN UNLESS-HIDDEN
&ELSE
  &GLOB    ADM-DATA      PRIVATE-DATA
  &GLOB    UNLESS-HIDDEN 
&ENDIF

DEFINE VAR adm-object-hdl       AS HANDLE NO-UNDO.
DEFINE VAR adm-query-opened        AS LOGICAL NO-UNDO INIT NO.
DEFINE VAR adm-row-avail-state     AS LOGICAL NO-UNDO INIT ?.
DEFINE VAR adm-initial-lock        AS CHARACTER NO-UNDO INIT "NO-LOCK":U.
DEFINE VAR adm-new-record          AS LOGICAL NO-UNDO INIT NO.
DEFINE VAR adm-updating-record     AS LOGICAL NO-UNDO INIT NO.
DEFINE VAR adm-check-modified-all  AS LOGICAL NO-UNDO INIT NO.

DEFINE NEW GLOBAL SHARED VAR adm-broker-hdl    AS HANDLE  NO-UNDO.

&ENDIF
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 

/* ***************************  Main Block  *************************** */

&IF "{&ADM-CONTAINER}":U NE "":U &THEN
  &IF "{&ADM-CONTAINER}":U = "FRAME":U OR "{&ADM-CONTAINER}":U = "DIALOG-BOX":U 
  &THEN
    ASSIGN adm-object-hdl = FRAME {&FRAME-NAME}:HANDLE. 
  &ELSEIF "{&ADM-CONTAINER}":U = "WINDOW":U &THEN
    ASSIGN adm-object-hdl    =   {&window-name}.
  &ELSE
    ASSIGN adm-object-hdl    = ?.
  &ENDIF
&ELSE
  &IF "{&FRAME-NAME}":U NE "":U &THEN
      adm-object-hdl = FRAME {&FRAME-NAME}:HANDLE.
  &ENDIF
&ENDIF

&IF  DEFINED(adm-containr) <> 0 &THEN   
    &IF DEFINED(PGIMP) = 0 AND DEFINED(PGLOG) = 0 &THEN
        RUN pi-trad-widgets (INPUT FRAME {&frame-name}:handle).
    &ENDIF
&ENDIF

&IF DEFINED(adm-viewer) <> 0 &THEN 
    RUN pi-trad-widgets (INPUT FRAME {&frame-name}:handle).
&ENDIF       

&IF DEFINED(adm-browser) <> 0 &THEN 
    RUN pi-trad-widgets (INPUT FRAME {&frame-name}:handle).
&ENDIF       

&IF "{&PROCEDURE-TYPE}":U NE "ADM-Broker":U &THEN
RUN get-attribute IN adm-broker-hdl ('TYPE':U) NO-ERROR.
IF RETURN-VALUE NE "ADM-Broker":U THEN 
DO: 
    RUN adm/objects/broker.p PERSISTENT SET adm-broker-hdl. 
    RUN set-broker-owner IN adm-broker-hdl (THIS-PROCEDURE).
END.
&ENDIF


THIS-PROCEDURE:{&ADM-DATA} = 
     '{&ADM-VERSION}~`':U +
     '{&PROCEDURE-TYPE}~`':U +
     '{&ADM-CONTAINER}~`':U +
   &IF DEFINED (adm-open-query) NE 0 &THEN
     'YES~`':U +
   &ELSE
     'NO ~`':U +
   &ENDIF
     '{&EXTERNAL-TABLES}~`':U +
     '{&INTERNAL-TABLES}~`':U +
   &IF DEFINED(adm-browser) NE 0 &THEN  
     '{&ENABLED-TABLES-IN-QUERY-{&BROWSE-NAME}}~`':U +
   &ELSE
     '{&ENABLED-TABLES}~`':U +
   &ENDIF
     (IF adm-object-hdl = ? THEN "":U ELSE STRING(adm-object-hdl))
        + "~`":U +
   &IF DEFINED(ADM-ATTRIBUTE-LIST) NE 0 &THEN
     '{&ADM-ATTRIBUTE-LIST}~`':U + 
   &ELSE 
     '?~`':U +
   &ENDIF
   &IF "{&User-Supported-Links}":U NE "":U &THEN
     '{&ADM-SUPPORTED-LINKS},{&User-Supported-Links}~`':U +
   &ELSE
     '{&ADM-SUPPORTED-LINKS}~`':U +
   &ENDIF
     '{&ADM-DISPATCH-QUALIFIER}~`':U +
     '~`~`~`~`~`~`~`~`~`~`~`':U +
     IF THIS-PROCEDURE:{&ADM-DATA} = "":U OR THIS-PROCEDURE:{&ADM-DATA} = ? 
         THEN "^^":U 
     ELSE "^":U + ENTRY(2, THIS-PROCEDURE:{&ADM-DATA}, "^":U) + 
          "^":U + ENTRY(3, THIS-PROCEDURE:{&ADM-DATA}, "^":U).

&IF "{&LAYOUT-VARIABLE}" eq "" &THEN
  &Scoped-define EXCLUDE-adm-apply-layout YES
&ENDIF

&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-adm-apply-entry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-apply-entry Method-Library 
PROCEDURE adm-apply-entry :
   DEFINE VAR c_Handle AS CHAR NO-UNDO.
   
   ASSIGN c_Handle = "".
   RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE, 
                                          INPUT 'TABLEIO-SOURCE':U,
                                          OUTPUT c_Handle ).
   IF c_Handle <> "" THEN                                       
      RUN broker-apply-entry IN adm-broker-hdl (THIS-PROCEDURE) NO-ERROR.
  
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-apply-layout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-apply-layout Method-Library 
PROCEDURE adm-apply-layout :
   DEFINE VARIABLE layout-name AS CHARACTER NO-UNDO.
  
   RUN get-attribute ('Layout':U).
   layout-name = IF RETURN-VALUE EQ ? THEN "":U ELSE RETURN-VALUE.
  
   IF layout-name EQ "":U THEN DO:
      RUN get-attribute IN THIS-PROCEDURE ('Default-Layout':U).
      layout-name = IF RETURN-VALUE EQ ? THEN "":U ELSE RETURN-VALUE.
      IF layout-name EQ "":U THEN layout-name = "Master Layout":U.
   END.
  
   IF {&LAYOUT-VARIABLE} NE layout-name THEN DO:
      IF {&LAYOUT-VARIABLE} NE "Master Layout":U THEN
         RUN {&LAYOUT-VARIABLE}s ("Master Layout":U).
         
      IF layout-name NE "Master Layout":U THEN
         RUN {&LAYOUT-VARIABLE}s (layout-name).
         
      RUN dispatch ('display-fields':U).
   END.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-destroy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-destroy Method-Library 
PROCEDURE adm-destroy :
   RUN broker-destroy IN adm-broker-hdl (THIS-PROCEDURE) NO-ERROR.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-disable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-disable Method-Library 
PROCEDURE adm-disable :
   &IF "{&FRAME-NAME}":U NE "":U &THEN
      DISABLE {&ENABLED-OBJECTS} WITH FRAME {&FRAME-NAME}.
      RUN dispatch ('disable-fields':U).  
   &ENDIF                              

   /* EPC Disable do Container */
   &IF  DEFINED(adm-containr) <> 0 &THEN
      IF c-nom-prog-dpc-mg97 <> "" AND c-nom-prog-dpc-mg97 <> ? THEN DO:
         &IF DEFINED(PGIMP) <> 0 &THEN   
            RUN value(c-nom-prog-dpc-mg97) (INPUT "DISABLE", 
                                            INPUT "CONTAINER",
                                            INPUT THIS-PROCEDURE,
                                            INPUT FRAME f-relat:handle,
                                            INPUT "",
                                            INPUT ?).    
         &ELSEIF DEFINED(PGLOG) <> 0 &THEN   
            RUN value(c-nom-prog-dpc-mg97) (INPUT "DISABLE", 
                                            INPUT "CONTAINER",
                                            INPUT THIS-PROCEDURE,
                                            INPUT FRAME f-import:handle,
                                            INPUT "",
                                            INPUT ?).    
         &ELSE
            RUN value(c-nom-prog-dpc-mg97) (INPUT "DISABLE", 
                                            INPUT "CONTAINER",
                                            INPUT THIS-PROCEDURE,
                                            INPUT FRAME {&FRAME-NAME}:handle,
                                            INPUT "",
                                            INPUT ?).    
         &ENDIF
      END.

      IF c-nom-prog-appc-mg97 <> "" AND c-nom-prog-appc-mg97 <> ? THEN DO:                     
         &IF DEFINED(PGIMP) <> 0 &THEN   
            RUN value(c-nom-prog-appc-mg97) (INPUT "DISABLE", 
                                             INPUT "CONTAINER",
                                             INPUT THIS-PROCEDURE,
                                             INPUT FRAME f-relat:handle,
                                             INPUT "",
                                             INPUT ?).    
         &ELSEIF DEFINED(PGLOG) <> 0 &THEN   
            RUN value(c-nom-prog-appc-mg97) (INPUT "DISABLE", 
                                             INPUT "CONTAINER",
                                             INPUT THIS-PROCEDURE,
                                             INPUT FRAME f-import:handle,
                                             INPUT "",
                                             INPUT ?).    
         &ELSE
            RUN value(c-nom-prog-appc-mg97) (INPUT "DISABLE", 
                                             INPUT "CONTAINER",
                                             INPUT THIS-PROCEDURE,
                                             INPUT FRAME {&FRAME-NAME}:handle,
                                             INPUT "",
                                             INPUT ?).    
         &ENDIF 
      END.                                       

      IF c-nom-prog-upc-mg97 <> "" AND c-nom-prog-upc-mg97 <> ? THEN DO:
      
         &IF DEFINED(PGIMP) <> 0 &THEN   
            RUN value(c-nom-prog-upc-mg97) (INPUT "DISABLE", 
                                            INPUT "CONTAINER",
                                            INPUT THIS-PROCEDURE,
                                            INPUT FRAME f-relat:handle,
                                            INPUT "",
                                            INPUT ?).    
         &ELSEIF DEFINED(PGLOG) <> 0 &THEN   
            RUN value(c-nom-prog-upc-mg97) (INPUT "DISABLE", 
                                            INPUT "CONTAINER",
                                            INPUT THIS-PROCEDURE,
                                            INPUT FRAME f-import:handle,
                                            INPUT "",
                                            INPUT ?).    
         &ELSE
            RUN value(c-nom-prog-upc-mg97) (INPUT "DISABLE", 
                                            INPUT "CONTAINER",
                                            INPUT THIS-PROCEDURE,
                                            INPUT FRAME {&FRAME-NAME}:handle,
                                            INPUT "",
                                            INPUT ?).    
         &ENDIF
      END.
   &ENDIF

   RUN set-attribute-list ('ENABLED=no':U).

   RETURN.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-edit-attribute-list) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-edit-attribute-list Method-Library 
PROCEDURE adm-edit-attribute-list :
   &IF "{&adm-attribute-dlg}":U NE "":U &THEN
      RUN {&adm-attribute-dlg} (INPUT THIS-PROCEDURE).
   &ELSE
      MESSAGE "There is no attribute list dialog for this object.":U
         VIEW-AS ALERT-BOX WARNING.
   &ENDIF
          
   RETURN. 
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-enable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-enable Method-Library 
PROCEDURE adm-enable :
     
   &IF "{&FRAME-NAME}":U NE "":U &THEN
      ENABLE {&UNLESS-HIDDEN} {&ENABLED-OBJECTS} WITH FRAME {&FRAME-NAME}.

      RUN enable_UI IN THIS-PROCEDURE NO-ERROR.
   &ENDIF                          

   &IF  DEFINED(adm-containr) <> 0 &THEN
      IF  c-nom-prog-dpc-mg97 <> ""
      AND c-nom-prog-dpc-mg97 <> ? THEN DO:
      
         &IF DEFINED(PGIMP) <> 0 &THEN   
             RUN value(c-nom-prog-dpc-mg97) (INPUT 'ENABLE', 
                                             INPUT 'CONTAINER',
                                             INPUT THIS-PROCEDURE,
                                             INPUT FRAME f-relat:handle,
                                             INPUT "",
                                             INPUT ?).    
         &ELSEIF DEFINED(PGLOG) <> 0 &THEN   
             RUN value(c-nom-prog-dpc-mg97) (INPUT 'ENABLE', 
                                             INPUT 'CONTAINER',
                                             INPUT THIS-PROCEDURE,
                                             INPUT FRAME f-import:handle,
                                             INPUT "",
                                             INPUT ?).    
         &ELSE
             RUN value(c-nom-prog-dpc-mg97) (INPUT 'ENABLE', 
                                             INPUT 'CONTAINER',
                                             INPUT THIS-PROCEDURE,
                                             INPUT FRAME {&FRAME-NAME}:handle,
                                             INPUT "",
                                             INPUT ?).    
         &ENDIF
      
      END.
      
      IF  c-nom-prog-appc-mg97 <> ""
      AND c-nom-prog-appc-mg97 <> ? THEN DO:           
          
         &IF DEFINED(PGIMP) <> 0 &THEN   
             RUN value(c-nom-prog-appc-mg97) (INPUT 'ENABLE', 
                                              INPUT 'CONTAINER',
                                              INPUT THIS-PROCEDURE,
                                              INPUT FRAME f-relat:handle,
                                              INPUT "",
                                              INPUT ?).    
         &ELSEIF DEFINED(PGLOG) <> 0 &THEN   
             RUN value(c-nom-prog-appc-mg97) (INPUT 'ENABLE', 
                                              INPUT 'CONTAINER',
                                              INPUT THIS-PROCEDURE,
                                              INPUT FRAME f-import:handle,
                                              INPUT "",
                                              INPUT ?).    
         &ELSE
             RUN value(c-nom-prog-appc-mg97) (INPUT 'ENABLE', 
                                              INPUT 'CONTAINER',
                                              INPUT THIS-PROCEDURE,
                                              INPUT FRAME {&FRAME-NAME}:handle,
                                              INPUT "",
                                              INPUT ?).    
         &ENDIF
      
      END.                                       
      
      IF  c-nom-prog-upc-mg97 <> ""
      AND c-nom-prog-upc-mg97 <> ? THEN DO:
      
         &IF DEFINED(PGIMP) <> 0 &THEN   
             RUN value(c-nom-prog-upc-mg97) (INPUT 'ENABLE', 
                                             INPUT 'CONTAINER',
                                             INPUT THIS-PROCEDURE,
                                             INPUT FRAME f-relat:handle,
                                             INPUT "",
                                             INPUT ?).    
         &ELSEIF DEFINED(PGLOG) <> 0 &THEN   
             RUN value(c-nom-prog-upc-mg97) (INPUT 'ENABLE', 
                                             INPUT 'CONTAINER',
                                             INPUT THIS-PROCEDURE,
                                             INPUT FRAME f-import:handle,
                                             INPUT "",
                                             INPUT ?).    
         &ELSE
             RUN value(c-nom-prog-upc-mg97) (INPUT 'ENABLE', 
                                             INPUT 'CONTAINER',
                                             INPUT THIS-PROCEDURE,
                                             INPUT FRAME {&FRAME-NAME}:handle,
                                             INPUT "",
                                             INPUT ?).    
         &ENDIF
      
      END.
   &ENDIF
         
   RUN set-attribute-list ('ENABLED=yes':U).

   RETURN.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-exit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-exit Method-Library 
PROCEDURE adm-exit :
   RUN notify ('exit':U).
   RETURN.  
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-hide) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-hide Method-Library 
PROCEDURE adm-hide :
   RUN broker-hide IN adm-broker-hdl (THIS-PROCEDURE) NO-ERROR.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-initialize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-initialize Method-Library 
PROCEDURE adm-initialize :
   RUN broker-initialize IN adm-broker-hdl (THIS-PROCEDURE) NO-ERROR.
   &IF DEFINED(PGS-QG1) = 0 &THEN 
      &IF "{&frame-name}" <> "" &THEN
         IF FRAME {&frame-name}:scrollable THEN
            ASSIGN FRAME {&frame-name}:virtual-width-chars  = FRAME {&frame-name}:width-chars
                   FRAME {&frame-name}:virtual-height-chars = FRAME {&frame-name}:height-chars.
      &ENDIF             
   &ENDIF 
   DEF VAR c_Aux-var AS CHAR NO-UNDO.
   RUN get-link-handle IN adm-broker-hdl (INPUT  THIS-PROCEDURE,
                                          INPUT  "CONTAINER-SOURCE",
                                          OUTPUT c_Aux-var).    
   RUN set-attribute-list ('W-Container-Source = ' + string(c_Aux-var)).                                         

   RUN What-is-the-Page IN adm-broker-hdl (INPUT THIS-PROCEDURE).
   RUN set-attribute-list ('W-Page = ' + RETURN-VALUE).
   
   &IF  DEFINED(adm-containr) <> 0 &THEN
      IF  c-nom-prog-dpc-mg97 <> "" AND c-nom-prog-dpc-mg97 <> ? THEN DO:      
         &IF DEFINED(PGIMP) <> 0 &THEN   
            RUN value(c-nom-prog-dpc-mg97) (INPUT 'INITIALIZE', 
                                            INPUT 'CONTAINER',
                                            INPUT THIS-PROCEDURE,
                                            INPUT FRAME f-relat:handle,
                                            INPUT "",
                                            INPUT ?).    
         &ELSEIF DEFINED(PGLOG) <> 0 &THEN   
            RUN value(c-nom-prog-dpc-mg97) (INPUT 'INITIALIZE', 
                                            INPUT 'CONTAINER',
                                            INPUT THIS-PROCEDURE,
                                            INPUT FRAME f-import:handle,
                                            INPUT "",
                                            INPUT ?).    
         &ELSE
            RUN value(c-nom-prog-dpc-mg97) (INPUT 'INITIALIZE', 
                                            INPUT 'CONTAINER',
                                            INPUT THIS-PROCEDURE,
                                            INPUT FRAME {&FRAME-NAME}:handle,
                                            INPUT "",
                                            INPUT ?).    
         &ENDIF      
      END.
      
      IF c-nom-prog-appc-mg97 <> "" AND c-nom-prog-appc-mg97 <> ? THEN DO:                     
         &IF DEFINED(PGIMP) <> 0 &THEN   
            RUN value(c-nom-prog-appc-mg97) (INPUT 'INITIALIZE', 
                                             INPUT 'CONTAINER',
                                             INPUT THIS-PROCEDURE,
                                             INPUT FRAME f-relat:handle,
                                             INPUT "",
                                             INPUT ?).    
         &ELSEIF DEFINED(PGLOG) <> 0 &THEN   
            RUN value(c-nom-prog-appc-mg97) (INPUT 'INITIALIZE', 
                                             INPUT 'CONTAINER',
                                             INPUT THIS-PROCEDURE,
                                             INPUT FRAME f-import:handle,
                                             INPUT "",
                                             INPUT ?).    
         &ELSE
            RUN value(c-nom-prog-appc-mg97) (INPUT 'INITIALIZE', 
                                             INPUT 'CONTAINER',
                                             INPUT THIS-PROCEDURE,
                                             INPUT FRAME {&FRAME-NAME}:handle,
                                             INPUT "",
                                             INPUT ?).    
         &ENDIF      
      END.                                       
      
      IF c-nom-prog-upc-mg97 <> "" AND c-nom-prog-upc-mg97 <> ? THEN DO:
         &IF DEFINED(PGIMP) <> 0 &THEN   
            RUN value(c-nom-prog-upc-mg97) (INPUT 'INITIALIZE', 
                                            INPUT 'CONTAINER',
                                            INPUT THIS-PROCEDURE,
                                            INPUT FRAME f-relat:handle,
                                            INPUT "",
                                            INPUT ?).    
         &ELSEIF DEFINED(PGLOG) <> 0 &THEN   
            RUN value(c-nom-prog-upc-mg97) (INPUT 'INITIALIZE',
                                            INPUT 'CONTAINER',
                                            INPUT THIS-PROCEDURE,
                                            INPUT FRAME f-import:handle,
                                            INPUT "",
                                            INPUT ?).    
         &ELSE
            RUN value(c-nom-prog-upc-mg97) (INPUT 'INITIALIZE', 
                                            INPUT 'CONTAINER',
                                            INPUT THIS-PROCEDURE,
                                            INPUT FRAME {&FRAME-NAME}:handle,
                                            INPUT "",
                                            INPUT ?).    
         &ENDIF      
      END.
   &ENDIF
   &IF  DEFINED(adm-viewer) <> 0 &THEN 
      DEF VAR c-container  AS CHAR    NO-UNDO.

      RUN Who-Is-The-Container IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                  OUTPUT c-container).
      IF VALID-HANDLE(WIDGET-HANDLE(c-container)) THEN DO:
         RUN pi-retorna-dpc IN WIDGET-HANDLE(c-container).
         IF RETURN-VALUE <> "" AND RETURN-VALUE <> ? THEN DO:                  
            ASSIGN c-nom-prog-dpc-mg97 = RETURN-VALUE.
            
            RUN value(c-nom-prog-dpc-mg97) (INPUT 'INITIALIZE', 
                                            INPUT 'VIEWER',
                                            INPUT THIS-PROCEDURE,
                                            INPUT FRAME {&FRAME-NAME}:handle,
                                            INPUT '{&FIRST-EXTERNAL-TABLE}',
                                            &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                               INPUT ?).
                                            &ELSE
                                               INPUT (IF AVAIL {&FIRST-EXTERNAL-TABLE} THEN ROWID({&FIRST-EXTERNAL-TABLE}) ELSE ?)).    
                                            &ENDIF                                 
         END.                                       
         ELSE
            ASSIGN c-nom-prog-dpc-mg97 = "".      

         RUN pi-retorna-appc IN WIDGET-HANDLE(c-container).
         
         IF RETURN-VALUE <> "" AND RETURN-VALUE <> ? THEN DO:                  
            ASSIGN c-nom-prog-appc-mg97 = RETURN-VALUE.
            
            RUN value(c-nom-prog-appc-mg97) (INPUT 'INITIALIZE', 
                                             INPUT 'VIEWER',
                                             INPUT THIS-PROCEDURE,
                                             INPUT FRAME {&FRAME-NAME}:handle,
                                             INPUT '{&FIRST-EXTERNAL-TABLE}',
                                             &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                                INPUT ?).
                                             &ELSE
                                                INPUT (IF AVAIL {&FIRST-EXTERNAL-TABLE} THEN ROWID({&FIRST-EXTERNAL-TABLE}) ELSE ?)).    
                                             &ENDIF                                 
         END.                                       
         ELSE
            ASSIGN c-nom-prog-appc-mg97 = "".             

         RUN pi-retorna-upc IN WIDGET-HANDLE(c-container).
         
         IF RETURN-VALUE <> "" AND RETURN-VALUE <> ? THEN DO:                  
            ASSIGN c-nom-prog-upc-mg97 = RETURN-VALUE.
            
            RUN value(c-nom-prog-upc-mg97) (INPUT 'INITIALIZE', 
                                            INPUT 'VIEWER',
                                            INPUT THIS-PROCEDURE,
                                            INPUT FRAME {&FRAME-NAME}:handle,
                                            INPUT '{&FIRST-EXTERNAL-TABLE}',
                                            &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                               INPUT ?).
                                            &ELSE
                                               INPUT (IF AVAIL {&FIRST-EXTERNAL-TABLE} THEN ROWID({&FIRST-EXTERNAL-TABLE}) ELSE ?)).    
                                            &ENDIF                                 
         END.                                       
         ELSE
            ASSIGN c-nom-prog-upc-mg97 = "".             
      END.
   &ENDIF

   &IF  DEFINED(adm-containr) <> 0 &THEN
      RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                             INPUT 'page':U,
                                             OUTPUT c-ctrl-tab).
                                             
      ASSIGN h-ctrl-tab = IF c-ctrl-tab <> "" THEN WIDGET-HANDLE(c-ctrl-tab) ELSE ?.        
   &ENDIF
    
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-show-errors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-show-errors Method-Library 
PROCEDURE adm-show-errors :

   DEFINE VARIABLE cntr AS INTEGER   NO-UNDO.

   DO cntr = 1 TO ERROR-STATUS:NUM-MESSAGES:
      MESSAGE ERROR-STATUS:GET-MESSAGE(cntr).
   END.

   RETURN.

END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-UIB-mode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-UIB-mode Method-Library 
PROCEDURE adm-UIB-mode :
   RUN broker-UIB-mode IN adm-broker-hdl (THIS-PROCEDURE) NO-ERROR.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-view) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-view Method-Library 
PROCEDURE adm-view :
  
   RUN broker-view IN adm-broker-hdl (THIS-PROCEDURE) NO-ERROR.
  
   ASSIGN THIS-PROCEDURE:PRIVATE-DATA = "OK". 
  
   &IF DEFINED(adm-viewer) <> 0 &THEN
      ASSIGN wh-entry-field = FRAME {&frame-name}:handle
             wh-entry-field = wh-entry-field:FIRST-CHILD
             wh-entry-field = wh-entry-field:FIRST-CHILD.
      DO WHILE(VALID-HANDLE(wh-entry-field)):
         IF wh-entry-field:SENSITIVE = YES AND wh-entry-field:TYPE <> 'rectangle' THEN DO:
            APPLY 'entry' TO wh-entry-field.
            LEAVE.
         END.
         ELSE
            ASSIGN wh-entry-field = wh-entry-field:NEXT-SIBLING.    
      END.
   &ENDIF
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dispatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dispatch Method-Library 
PROCEDURE dispatch :
   DEFINE INPUT PARAMETER p-method-name    AS CHARACTER NO-UNDO.
   
   RUN broker-dispatch IN adm-broker-hdl (THIS-PROCEDURE, p-method-name) NO-ERROR.
   
   IF RETURN-VALUE = "ADM-ERROR":U THEN
      RETURN "ADM-ERROR":U.
 
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-attribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-attribute Method-Library 
PROCEDURE get-attribute :
                
   DEFINE INPUT PARAMETER p-attr-name    AS CHARACTER NO-UNDO.
  
   RUN broker-get-attribute IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT p-attr-name) NO-ERROR.
  
   RETURN RETURN-VALUE.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-attribute-list) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-attribute-list Method-Library 
PROCEDURE get-attribute-list :
                
   DEFINE OUTPUT PARAMETER p-attr-list AS CHARACTER NO-UNDO.

   RUN broker-get-attribute-list IN adm-broker-hdl (INPUT THIS-PROCEDURE, 
                                                    INPUT ?,
                                                    OUTPUT p-attr-list) NO-ERROR.
        
   RETURN.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-new-state) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE new-state Method-Library 
PROCEDURE new-state :

   DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

   RUN broker-new-state IN adm-broker-hdl (THIS-PROCEDURE, p-state) NO-ERROR.

   RETURN.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-notify) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE notify Method-Library 
PROCEDURE notify :
   DEFINE INPUT PARAMETER p-method AS CHARACTER NO-UNDO.

   RUN broker-notify IN adm-broker-hdl (THIS-PROCEDURE, p-method) NO-ERROR.
   IF RETURN-VALUE = "ADM-ERROR":U THEN 
      RETURN "ADM-ERROR":U.  

   RETURN.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-trad-widgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trad-widgets Method-Library 
PROCEDURE pi-trad-widgets :

   DEFINE INPUT PARAM p-wh-frame AS WIDGET-HANDLE NO-UNDO.
  
   DEFINE VAR wh-child     AS WIDGET-HANDLE NO-UNDO. 
   DEFINE VAR c-aux        AS CHAR          NO-UNDO.
   DEFINE VAR i-aux        AS INTEGER       NO-UNDO.  
   DEFINE VAR c-contexto   AS CHAR          NO-UNDO INIT "".
  
   ASSIGN p-wh-frame:BGCOLOR = ?
          p-wh-frame:FONT    = 1
          p-wh-frame = p-wh-frame:FIRST-CHILD
          wh-child   = p-wh-frame:FIRST-CHILD.
          
   DO WHILE VALID-HANDLE(wh-child):
      CASE wh-child:TYPE:
         WHEN "RADIO-SET" THEN DO:
            IF wh-child:TABLE <> ? THEN DO:
               ASSIGN c-aux = wh-child:RADIO-BUTTONS.
               
               IF wh-child:PRIVATE-DATA <> "" AND wh-child:PRIVATE-DATA <> ? THEN 
                  ASSIGN c-contexto = wh-child:PRIVATE-DATA. 
               ELSE
                  ASSIGN c-contexto = "*".
                    
               DO i-aux = 1 TO NUM-ENTRIES(wh-child:RADIO-BUTTONS):
                  IF (i-aux MOD 2) <> 0 THEN DO:
                     ASSIGN ENTRY(i-aux, c-aux) = REPLACE(ENTRY(i-aux, wh-child:RADIO-BUTTONS), CHR(32), "_").
                  END.
               END.                                              
               ASSIGN wh-child:RADIO-BUTTONS = c-aux.
            END.
         END.
         WHEN "BUTTON" THEN DO:
            IF wh-child:LABEL <> ? AND wh-child:LABEL <> "" THEN DO:
               ASSIGN wh-child:LABEL = TRIM(REPLACE(wh-child:LABEL, CHR(32), "_")).
            END. 
            IF wh-child:HELP <> "" AND wh-child:HELP <> ? THEN DO:
               ASSIGN wh-child:HELP = REPLACE(wh-child:HELP, CHR(32), "_")
                      wh-child:TOOLTIP = TRIM(REPLACE(wh-child:HELP, CHR(32), "_")).
            END.                       
         END.
      END CASE.
      ASSIGN wh-child = wh-child:NEXT-SIBLING.
   END.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-attribute-list) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-attribute-list Method-Library 
PROCEDURE set-attribute-list :
                
   DEFINE INPUT PARAMETER p-attr-list    AS CHARACTER NO-UNDO.

   RUN broker-set-attribute-list IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT p-attr-list) NO-ERROR.
  
   RETURN.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-position) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-position Method-Library 
PROCEDURE set-position :
  
   DEFINE INPUT PARAMETER p-row    AS DECIMAL NO-UNDO.
   DEFINE INPUT PARAMETER p-col    AS DECIMAL NO-UNDO.

   IF VALID-HANDLE(adm-object-hdl) THEN DO:     
      &IF "{&ADM-CONTAINER}":U NE "":U &THEN
         DEFINE VARIABLE parent-hdl AS HANDLE NO-UNDO.
         
         IF adm-object-hdl:TYPE = "WINDOW":U THEN DO:
            IF p-row = 0 THEN p-row = (SESSION:HEIGHT-CHARS - adm-object-hdl:HEIGHT-CHARS) / 2.
            IF p-col = 0 THEN p-col = (SESSION:WIDTH-CHARS - adm-object-hdl:WIDTH-CHARS) / 2.
         END.
         ELSE
            IF adm-object-hdl:TYPE = "DIALOG-BOX":U THEN DO:
               parent-hdl = adm-object-hdl:PARENT.
               IF p-row = 0 THEN p-row = ((SESSION:HEIGHT-CHARS - adm-object-hdl:HEIGHT-CHARS) / 2) - parent-hdl:ROW.
               IF p-col = 0 THEN p-col = ((SESSION:WIDTH-CHARS - adm-object-hdl:WIDTH-CHARS) / 2) - parent-hdl:COL.
         END.
         IF p-row GE 0 AND p-row < 1 THEN p-row = 1.
         IF p-col GE 0 AND p-col < 1 THEN p-col = 1.
      &ENDIF
      ASSIGN adm-object-hdl:ROW    =   p-row 
             adm-object-hdl:COLUMN =   p-col.
   END.  
   RETURN.    
END PROCEDURE.
&ENDIF

&ANALYZE-RESUME

&ENDIF
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 

/* ***************************  Main Block  *************************** */

RUN set-attribute-list ('CURRENT-PAGE=0,ADM-OBJECT-HANDLE=':U +
    STRING(adm-object-hdl)). 

PAUSE 0 BEFORE-HIDE.

ON  CTRL-TAB ANYWHERE DO:
    IF  VALID-HANDLE(h-ctrl-tab) THEN DO:
        RUN get-attribute IN h-ctrl-tab('folder-labels':U).
        ASSIGN i-ctrl-tab-folder = NUM-ENTRIES(RETURN-VALUE,'|':U).
        RUN get-attribute('current-page':U).
        ASSIGN i-ctrl-tab-page = int(RETURN-VALUE) + 1.
        IF  i-ctrl-tab-page > i-ctrl-tab-folder THEN
            RUN select-page(1).
        ELSE 
            RUN select-page(i-ctrl-tab-page).
    END.
END.

ON  SHIFT-CTRL-TAB ANYWHERE DO:
    IF  VALID-HANDLE(h-ctrl-tab) THEN DO:
        RUN get-attribute IN h-ctrl-tab('folder-labels':U).
        ASSIGN i-ctrl-tab-folder = NUM-ENTRIES(RETURN-VALUE,'|':U).
        RUN get-attribute('current-page':U).
        ASSIGN i-ctrl-tab-page = int(RETURN-VALUE) - 1.
        IF  i-ctrl-tab-page < 1 THEN
            RUN select-page(i-ctrl-tab-folder).
        ELSE
            RUN select-page(i-ctrl-tab-page).
    END.
END.

&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-adm-change-page) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-change-page Method-Library 
PROCEDURE adm-change-page :

  RUN broker-change-page IN adm-broker-hdl (INPUT THIS-PROCEDURE) NO-ERROR.
  
  END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-delete-page) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE delete-page Method-Library 
PROCEDURE delete-page :
  
   DEFINE INPUT PARAMETER p-page# AS INTEGER NO-UNDO.
  
   RUN broker-delete-page IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT p-page#).
  
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-object) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-object Method-Library 
PROCEDURE init-object :
   DEFINE INPUT PARAMETER  p-proc-name   AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER  p-parent-hdl  AS HANDLE    NO-UNDO.
   DEFINE INPUT PARAMETER  p-attr-list   AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER p-proc-hdl    AS HANDLE    NO-UNDO.

   RUN broker-init-object IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT p-proc-name, INPUT p-parent-hdl,
                                             INPUT p-attr-list, OUTPUT p-proc-hdl) NO-ERROR.
   RETURN.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-pages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-pages Method-Library 
PROCEDURE init-pages :

   DEFINE INPUT PARAMETER p-page-list      AS CHARACTER NO-UNDO.  

   RUN broker-init-pages IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                            INPUT p-page-list) NO-ERROR.      
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-retorna-appc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-appc Method-Library 
PROCEDURE pi-retorna-appc :

   RETURN c-nom-prog-appc-mg97.

END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-retorna-dpc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-dpc Method-Library 
PROCEDURE pi-retorna-dpc :
   RETURN c-nom-prog-dpc-mg97.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-retorna-upc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-upc Method-Library 
PROCEDURE pi-retorna-upc :
   RETURN c-nom-prog-upc-mg97.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-retorna-vars-hlp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-vars-hlp Method-Library 
PROCEDURE pi-retorna-vars-hlp :

   DEFINE OUTPUT PARAMETER p-num-topico-hlp AS INTEGER NO-UNDO.
   DEFINE OUTPUT PARAMETER p-nom-manual-hlp AS CHAR FORMAT 'x(06)' NO-UNDO.

   ASSIGN p-num-topico-hlp = i-num-topico-hlp-mg97
          p-nom-manual-hlp = c-nom-manual-hlp-mg97.

END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-select-page) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE select-page Method-Library 
PROCEDURE select-page :

   DEFINE INPUT PARAMETER p-page#     AS INTEGER   NO-UNDO.

   RUN broker-select-page IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                             INPUT p-page#) NO-ERROR.
    
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-view-page) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE view-page Method-Library 
PROCEDURE view-page :

   DEFINE INPUT PARAMETER p-page#      AS INTEGER   NO-UNDO.

   RUN broker-view-page IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                           INPUT p-page#).
       
END PROCEDURE.
&ENDIF

&ANALYZE-RESUME

&ENDIF

&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS

/* ***************************  Definitions  ************************** */
DEFINE VARIABLE wh-pesquisa             AS HANDLE               NO-UNDO.
DEFINE VARIABLE c-arq-old               AS CHAR                 NO-UNDO.
DEFINE VARIABLE c-arq-old-batch         AS CHAR                 NO-UNDO.

DEFINE VARIABLE c-imp-old               AS CHAR                 NO-UNDO.

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB 
/* ************************* Included-Libraries *********************** */

ASSIGN FRAME f-relat:visible = NO
       FRAME f-relat:font = 1.
&IF "{&PGSEL}" <> "" &THEN
    ASSIGN FRAME f-pg-sel:visible = NO
           FRAME f-pg-sel:font = 1.
&ENDIF
&IF "{&PGCLA}" <> "" &THEN
    ASSIGN FRAME f-pg-cla:visible = NO
           FRAME f-pg-cla:font = 1.
&ENDIF
&IF "{&PGPAR}" <> "" &THEN
    ASSIGN FRAME f-pg-par:visible = NO
           FRAME f-pg-par:font = 1.
&ENDIF
&IF "{&PGDIG}" <> "" &THEN
    ASSIGN FRAME f-pg-dig:visible = NO
           FRAME f-pg-dig:font = 1.
&ENDIF
&IF "{&PGIMP}" <> "" &THEN
    ASSIGN FRAME f-pg-imp:visible = NO
           FRAME f-pg-imp:font = 1.
&ENDIF
&if "{&botao}" <> "no" &then

    &if "{&pgsel}" <> "" &then
    ON  GO OF FRAME {&pgsel} ANYWHERE DO:    
        IF  SELF:type <> "editor" 
            OR (SELF:type = "editor" 
            AND keyfunction(LASTKEY) <> "RETURN") THEN DO: 
            APPLY "choose" TO bt-executar IN FRAME f-relat.
        END.
      END.              
    &endif  

    &if "{&pgcla}" <> "" &then
    ON  GO OF FRAME {&pgcla} ANYWHERE DO:    
        IF  SELF:type <> "editor" 
        OR (SELF:type = "editor" 
        AND keyfunction(LASTKEY) <> "RETURN") THEN DO: 
            APPLY "choose" TO bt-executar IN FRAME f-relat.
        END.
      END.              
    &endif  
    
    &if "{&pgpar}" <> "" &then
    ON  GO OF FRAME {&pgpar} ANYWHERE DO:    
        IF  SELF:type <> "editor" 
        OR (SELF:type = "editor" 
        AND keyfunction(LASTKEY) <> "RETURN") THEN DO: 
            APPLY "choose" TO bt-executar IN FRAME f-relat.
        END.
      END.              
    &endif  
    
    &if "{&pgdig}" <> "" &then
    ON  GO OF FRAME {&pgdig} ANYWHERE DO:    
        IF  SELF:type <> "editor" 
        OR (SELF:type = "editor" 
        AND keyfunction(LASTKEY) <> "RETURN") THEN DO: 
            APPLY "choose" TO bt-executar IN FRAME f-relat.
        END.
      END.              
    &endif  
    
    &if "{&pgimp}" <> "" &then
    ON  GO OF FRAME {&pgimp} ANYWHERE DO:    
        IF  SELF:type <> "editor" 
        OR (SELF:type = "editor" 
        AND keyfunction(LASTKEY) <> "RETURN") THEN DO: 
            APPLY "choose" TO bt-executar IN FRAME f-relat.
        END.
      END.              
    &endif  
&endif
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 

/* ***************************  Main Block  *************************** */

&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-state Include 
PROCEDURE pi-trata-state :
   DEFINE INPUT PARAMETER p-issuer-hdl   AS HANDLE NO-UNDO.
   DEFINE INPUT PARAMETER p-state        AS CHAR   NO-UNDO.
  
   CASE ENTRY(1, p-state, '|'):
   END.
END PROCEDURE.

&ANALYZE-RESUME


/* ************************  Control Triggers  ************************ */

ON WINDOW-CLOSE OF C-Win
DO:
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

ON CHOOSE OF bt-ajuda IN FRAME f-relat DO:
   &IF DEFINED(SYSTEM-VARS) <> 0 &THEN
   
      DEF VAR c-nom-manual-hlp-aux   AS CHAR NO-UNDO.
   
      ASSIGN c-nom-manual-hlp-aux = SEARCH(c-nom-manual-hlp-mg97).
       
      IF c-nom-manual-hlp-aux <> ? THEN DO: 
         IF i-num-topico-hlp-mg97 <> 0 THEN 
            SYSTEM-HELP c-nom-manual-hlp-aux CONTEXT i-num-topico-hlp-mg97.
         ELSE
            SYSTEM-HELP c-nom-manual-hlp-aux CONTENTS.
      END.
      ELSE DO:
         DEFINE VARIABLE c-lbl-liter-arquivo AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Arquivo" *}
         ASSIGN c-lbl-liter-arquivo = TRIM(RETURN-VALUE).
         DEFINE VARIABLE c-lbl-liter-hlp-de-help-nao-encontrado AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "hlp_de_Help_n∆o_encontrado" *}
         ASSIGN c-lbl-liter-hlp-de-help-nao-encontrado = TRIM(RETURN-VALUE).
         MESSAGE c-lbl-liter-arquivo + '  ' ENTRY(1, c-nom-manual-hlp-mg97, '.') '.' + c-lbl-liter-hlp-de-help-nao-encontrado VIEW-AS ALERT-BOX ERROR.
      END.    
   &ENDIF
END.

ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp DO:
   DEF VAR c-arq-conv  AS CHAR NO-UNDO.

   ASSIGN c-arq-conv = REPLACE(INPUT FRAME f-pg-imp c-arquivo, "/", "~\").
   SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.lst" "*.lst",
               "*.*" "*.*"
       ASK-OVERWRITE 
       DEFAULT-EXTENSION "lst"
       INITIAL-DIR "spool" 
       SAVE-AS
       USE-FILENAME
       UPDATE l-ok.
   IF  l-ok = YES THEN DO:
      ASSIGN c-arquivo = REPLACE(c-arq-conv, "~\", "/"). 
      DISPLAY c-arquivo
         WITH FRAME f-pg-imp.
   END.
END.

ON CHOOSE OF bt-cancelar IN FRAME f-relat
DO:
   APPLY "close" TO THIS-PROCEDURE.
END.

ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp DO:
   /*** In°cio i-rpimp.i ***/
   DEF VAR c-arquivo-temp AS CHAR NO-UNDO.
   DEF VAR c-impressora AS CHAR NO-UNDO.
   DEF VAR c-arq AS CHAR NO-UNDO.
   DEF VAR c-layout AS CHAR NO-UNDO.
   DEF VAR c-ant AS CHAR NO-UNDO.

   ASSIGN c-ant = c-arquivo:screen-value IN FRAME f-pg-imp
          c-arquivo-temp =  REPLACE(c-arquivo:screen-value IN FRAME f-pg-imp,":",",").
          
   IF c-arquivo:screen-value IN FRAME f-pg-imp <> "" THEN DO:
      IF NUM-ENTRIES(c-arquivo-temp) = 4 THEN
         ASSIGN c-impressora = ENTRY(1,c-arquivo-temp)
                c-layout     = ENTRY(2,c-arquivo-temp)
                c-arq        = ENTRY(3,c-arquivo-temp) + ":" + entry(4,c-arquivo-temp).
                
      IF NUM-ENTRIES(c-arquivo-temp) = 3 THEN
         ASSIGN c-impressora = ENTRY(1,c-arquivo-temp)
                c-layout     = ENTRY(2,c-arquivo-temp)
                c-arq        = ENTRY(3,c-arquivo-temp).
                
      IF NUM-ENTRIES(c-arquivo-temp) = 2 THEN
         ASSIGN c-impressora = ENTRY(1,c-arquivo-temp)
                c-layout     = ENTRY(2,c-arquivo-temp)
                c-arq        = "".
   END.         

   RUN utp/ut-impr.w (INPUT-OUTPUT c-impressora, INPUT-OUTPUT c-layout, INPUT-OUTPUT c-arq).

   IF c-arq = "" THEN
      ASSIGN c-arquivo = c-impressora + ":" + c-layout.
   ELSE
      ASSIGN c-arquivo = c-impressora + ":" + c-layout + ":" + c-arq.  

   IF c-arquivo = ":" THEN
      ASSIGN c-arquivo = c-ant.

   ASSIGN c-imp-old = c-arquivo.
  
   DISP c-arquivo
      WITH FRAME f-pg-imp.

   /*** Fim i-rpimp.i ***/
END.

ON CHOOSE OF bt-executar IN FRAME f-relat DO:
   DO  ON ERROR UNDO, RETURN NO-APPLY:
      RUN pi-executar.
   END.
END.

ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat DO:
   {utp/ut-liter.i 80_Colunas *}
   rs-formato:DISABLE(ENTRY(1,rs-formato:RADIO-BUTTONS IN FRAME f-pg-imp)) IN FRAME f-pg-imp.
   RUN pi-troca-pagina.
END.

ON MOUSE-SELECT-CLICK OF im-pg-par IN FRAME f-relat DO:
   RUN pi-troca-pagina.
END.

ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat DO:
   RUN pi-troca-pagina.
END.

ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp DO:
   DO WITH FRAME f-pg-imp:
      CASE SELF:SCREEN-VALUE:
         WHEN "1" THEN DO:
            ASSIGN c-arquivo:SENSITIVE    = NO
                   bt-arquivo:VISIBLE     = NO
                   bt-config-impr:VISIBLE = YES.
         END.
         WHEN "2" THEN DO:
            ASSIGN c-arquivo:SENSITIVE     = YES
                   bt-arquivo:VISIBLE      = YES
                   bt-config-impr:VISIBLE  = NO.
         END.
         WHEN "3" THEN DO:
            ASSIGN c-arquivo:SENSITIVE     = NO
                   bt-arquivo:VISIBLE      = NO
                   bt-config-impr:VISIBLE  = NO.
         END.
      END CASE.
   END.
END.

ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp DO:
   IF INPUT FRAME f-pg-imp rs-execucao = 2 THEN DO:
      ASSIGN c-arquivo
             c-arq-old-batch = c-arquivo.
             
      IF INDEX(c-arquivo,"spool/") <> 0 THEN DO:
         ASSIGN c-arquivo = REPLACE(c-arquivo,"spool/","").
         DISP c-arquivo
            WITH FRAME f-pg-imp.
      END.
      IF INPUT FRAME f-pg-imp rs-destino = 3 THEN DO:
         ASSIGN rs-destino:SCREEN-VALUE IN FRAME f-pg-imp = "2".
         APPLY "value-changed" TO rs-destino IN FRAME f-pg-imp.
      END.
      IF rs-destino:DISABLE(c-terminal) IN FRAME f-pg-imp THEN.
   END.
   ELSE DO:
      ASSIGN c-arquivo = c-arq-old-batch.
      DISP c-arquivo
         WITH FRAME f-pg-imp.
      IF rs-destino:ENABLE(c-terminal) IN FRAME f-pg-imp THEN.
   END.
END.

/* ***************************  Main Block  *************************** */

ASSIGN CURRENT-WINDOW             = {&WINDOW-NAME}
   THIS-PROCEDURE:CURRENT-WINDOW  = {&WINDOW-NAME}.
RUN pi_aplica_facelift_thin IN h-facelift ( INPUT FRAME f-relat:handle ).
/* ******* Editado automaticamente para o projeto de facelift ******* */

    ASSIGN v-cod-prog-gerado = "bcr005a".
DEF VAR v-Ltr                 AS CHAR NO-UNDO.
DEF VAR v-Ltr1                AS CHAR NO-UNDO.

&IF  DEFINED(SYSTEM-VARS) = 0 &THEN 

DEF VAR c-programa-mg97       AS CHAR FORMAT "x(08)" NO-UNDO.
DEF VAR c-versao-mg97         AS CHAR FORMAT "x(08)" NO-UNDO.
DEF VAR c-modulo-mg97         AS CHAR FORMAT "x(08)" NO-UNDO.
DEF VAR c-titulo-prog-mg97    AS CHAR FORMAT "x(08)" NO-UNDO.
DEF VAR i-num-topico-hlp-mg97 AS INTEGER NO-UNDO.
DEF VAR c-nom-manual-hlp-mg97 AS CHAR FORMAT "x(06)" NO-UNDO.


&ENDIF

IF v-cod-prog-gerado = ' ' OR  v-cod-prog-gerado = '' THEN DO:

   {utp/ut-liter.i A_chamada_do_include_UT9000.I_est†__sem_os_parÉmetros_necess†rios, *}
   ASSIGN v-Ltr = RETURN-VALUE.
   {utp/ut-liter.i ou_em_local_incorreto._Vocà_deve_editar_o_programa_e_ *}
   ASSIGN v-Ltr1 = RETURN-VALUE.
   {utp/ut-liter.i verificar_o_nome_do_programa_chamado *}
   MESSAGE v-Ltr SKIP
           v-Ltr1 SKIP
           RETURN-VALUE
      VIEW-AS ALERT-BOX ERROR.
   QUIT.
END.
ELSE DO:
   ASSIGN c-programa-mg97 = CAPS(v-cod-prog-gerado)
          c-versao-mg97   = '1.00.00.000'.
          
   FIND FIRST prog_dtsul NO-LOCK
        WHERE prog_dtsul.cod_prog_dtsul = c-programa-mg97 NO-ERROR.
   IF AVAIL prog_dtsul THEN DO:
      ASSIGN c-titulo-prog-mg97    = prog_dtsul.des_prog_dtsul
             c-nom-prog-upc-mg97   = prog_dtsul.nom_prog_upc
             c-nom-prog-appc-mg97  = prog_dtsul.nom_prog_appc
             c-nom-prog-dpc-mg97   = prog_dtsul.nom_prog_dpc
             i-num-topico-hlp-mg97 = prog_dtsul.num_topico.
       
      IF (c-nom-prog-upc-mg97 <> "") THEN DO:
         RUN men/verifyDisableUPC.p (OUTPUT lDisableUPC).
         IF lDisableUPC THEN
            ASSIGN c-nom-prog-upc-mg97 = "".
      END. 
        
      FIND FIRST procedimento NO-LOCK
           WHERE procedimento.cod_proced = prog_dtsul.cod_proced NO-ERROR.
      IF AVAIL procedimento THEN DO:
         FIND FIRST modul_dtsul NO-LOCK
              WHERE modul_dtsul.cod_modul_dtsul = procedimento.cod_modul_dtsul NO-ERROR. 
         IF AVAIL modul_dtsul THEN DO:
            ASSIGN c-modulo-mg97         = CAPS(modul_dtsul.nom_modul_dtsul_menu)
                   c-nom-manual-hlp-mg97 = "dochlp~/" + string(modul_dtsul.num_manual_documen, "999999") + ".hlp".
         END.
      END.
   END.                                                      
   ELSE DO:
      ASSIGN c-titulo-prog-mg97    = CAPS(c-programa-mg97)
             c-nom-prog-upc-mg97   = ""
             c-nom-prog-appc-mg97  = ""
             i-num-topico-hlp-mg97 = 0
             c-nom-manual-hlp-mg97 = "dochlp~/000000.hlp".
   END.                 
     
   RUN utp/ut-liter.p (INPUT REPLACE(c-titulo-prog-mg97," ","_"),"*","").
   ASSIGN c-titulo-prog-mg97 = RETURN-VALUE.

   &IF "{&WINDOW-NAME}" <> "" AND "{&WINDOW-NAME}" <> "CURRENT-WINDOW" &THEN 
      ASSIGN {&WINDOW-NAME}:TITLE = c-titulo-prog-mg97  
                                    + " - " 
                                    + c-programa-mg97 
                                    + " - " 
                                    + c-versao-mg97.
   &ELSE
      ASSIGN FRAME {&FRAME-NAME}:title = c-titulo-prog-mg97  
                                         + " - " 
                                         + c-programa-mg97 
                                         + " - " 
                                         + c-versao-mg97.
   &ENDIF
   RUN men/men901za.p (INPUT c-programa-mg97).
   
   IF RETURN-VALUE = "2012" THEN DO:
      {utp/ut-liter.i Usu†rio_sem_permiss∆o_para_acessar_o_programa *}
      MESSAGE RETURN-VALUE
         VIEW-AS ALERT-BOX  ERROR. 
   END.                       

   IF RETURN-VALUE = "2014" THEN DO:
      {utp/ut-liter.i Programa_n∆o_cadastrado_no_menu *}
      MESSAGE RETURN-VALUE
         VIEW-AS ALERT-BOX ERROR. 
   END.

   RUN btb/btb918za.p (INPUT YES).
END.

/*inicializaá‰es do template de relat¢rio */

ASSIGN {&window-name}:VIRTUAL-WIDTH-CHARS  = {&window-name}:WIDTH-CHARS
       {&window-name}:VIRTUAL-HEIGHT-CHARS = {&window-name}:HEIGHT-CHARS
       {&window-name}:MIN-WIDTH-CHARS      = {&window-name}:WIDTH-CHARS
       {&window-name}:MAX-WIDTH-CHARS      = {&window-name}:WIDTH-CHARS
       {&window-name}:MIN-HEIGHT-CHARS     = {&window-name}:HEIGHT-CHARS
       {&window-name}:MAX-HEIGHT-CHARS     = {&window-name}:HEIGHT-CHARS.
       
&IF  "{&PGIMP}" <> "" &THEN
    ASSIGN c-arquivo = "spool~/" + c-programa-mg97 + ".lst"   
           c-arq-old = "spool~/" + c-programa-mg97 + ".lst".
    ASSIGN c-terminal = "Terminal".
&ENDIF

ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

DEF VAR wh-label-sel     AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-label-cla     AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-label-par     AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-label-dig     AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-label-imp     AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-group         AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-child         AS WIDGET-HANDLE NO-UNDO.
DEF VAR c-list-folders   AS CHAR          NO-UNDO.
DEF VAR i-current-folder AS INTEGER       NO-UNDO.
DEF VAR i-new-folder     AS INTEGER       NO-UNDO.
DEF VAR c-aux            AS CHAR NO-UNDO.
DEF VAR i-aux            AS INTEGER NO-UNDO.

ON  CLOSE OF THIS-PROCEDURE DO:
/* i-logfin.i */
    RUN disable_ui.
END.

&if "{&PGIMP}" <> "" &then
  ON "LEAVE" OF C-ARQUIVO IN FRAME F-PG-IMP DO:
    ASSIGN c-arq-old = c-arquivo:screen-value.
  END.  

  ON "ENTER" OF C-ARQUIVO IN FRAME F-PG-IMP OR
     "RETURN" OF C-ARQUIVO IN FRAME F-PG-IMP OR
     "CTRL-ENTER" OF C-ARQUIVO IN FRAME F-PG-IMP OR
     "CTRL-J" OF C-ARQUIVO IN FRAME F-PG-IMP OR
     "CTRL-Z" OF C-ARQUIVO IN FRAME F-PG-IMP DO:
    RETURN NO-APPLY.
  END.  

  ON "~\" OF C-ARQUIVO IN FRAME F-PG-IMP DO:
    APPLY "/" TO C-ARQUIVO IN FRAME F-PG-IMP.
    RETURN NO-APPLY.       
  END.


  ON  "VALUE-CHANGED" OF RS-DESTINO IN FRAME F-PG-IMP DO:
    DO  WITH FRAME f-pg-imp:
      CASE SELF:screen-value:
          WHEN "1" THEN DO:
              ASSIGN c-arquivo:screen-value = c-imp-old.
              ASSIGN c-arquivo:sensitive    = NO 
                     c-arquivo:visible      = YES              
                     bt-arquivo:visible     = NO
                     bt-config-impr:visible = YES.
               IF c-imp-old = "" THEN
                     RUN pi-impres-pad.
          END.
          WHEN "2" THEN DO:                             
              ASSIGN c-arquivo:screen-value        = c-arq-old.          
              ASSIGN c-arquivo:sensitive     = YES
                     c-arquivo:visible       = YES              
                     bt-arquivo:visible      = YES
                     bt-config-impr:visible  = NO.
          END.
          WHEN "3" THEN DO:                        
              ASSIGN c-arquivo:screen-value = "".
              ASSIGN c-arquivo:sensitive     = NO    
                     c-arquivo:visible       = NO
                     bt-arquivo:visible      = NO
                     bt-config-impr:visible  = NO.
          END.
      END CASE.
    END.
  END.
&endif

/********************************************
** HELP FRAME
********************************************/
ON HELP OF FRAME F-RELAT DO:
    {include/ajuda.i}
END.

&IF "{&PGSEL}" &THEN 
ON HELP OF FRAME F-PG-SEL DO:
    {include/ajuda.i}
END.
&ENDIF

&IF "{&PGCLA}" &THEN 
ON HELP OF FRAME F-PG-CLA DO:
    {include/ajuda.i}
END.
&ENDIF

&IF "{&PGPAR}" &THEN 
ON HELP OF FRAME F-PG-PAR DO:
    {include/ajuda.i}
END.
&ENDIF

&IF "{&PGDIG}" &THEN 
ON HELP OF FRAME F-PG-DIG DO:
    {include/ajuda.i}
END.
&ENDIF

&IF "{&PGIMP}" &THEN 
ON HELP OF FRAME F-PG-IMP DO:
    {include/ajuda.i}
END.
&ENDIF

/********************************************************** 
** Traduá∆o p†gina seleá∆o - frame f-pg-sel
**********************************************************/
&if "{&PGSEL}" <> "" &then
    {utp/ut-liter.i Seleá∆o *}
    CREATE TEXT wh-label-sel
        ASSIGN FRAME        = FRAME f-relat:handle
               FORMAT       = "x(07)"
               FONT         = 1
               SCREEN-VALUE = RETURN-VALUE
               WIDTH        = 8
               ROW          = 1.8
               COL          = im-pg-sel:col IN FRAME f-relat + 1.86
               VISIBLE      = YES
         TRIGGERS:
             ON MOUSE-SELECT-CLICK
                APPLY "mouse-select-click" TO im-pg-sel IN FRAME f-relat.           
         END TRIGGERS.                   
&endif

/********************************************************** 
** Traduá∆o p†gina classificaá∆o - frame f-pg-cla
**********************************************************/
&if "{&PGCLA}" <> "" &then
    {utp/ut-liter.i Classificaá∆o *}
    CREATE TEXT wh-label-cla
        ASSIGN FRAME        = FRAME f-relat:handle
               FORMAT       = "x(13)"
               FONT         = 1
               SCREEN-VALUE = RETURN-VALUE
               WIDTH        = 13
               ROW          = 1.8
               COL          = im-pg-cla:col IN FRAME f-relat + 1.7
               VISIBLE      = YES
         TRIGGERS:
             ON MOUSE-SELECT-CLICK
                APPLY "mouse-select-click" TO im-pg-cla IN FRAME f-relat.           
         END TRIGGERS.       
&endif

/********************************************************** 
** Traduá∆o p†gina par≥metros - frame f-pg-par
**********************************************************/
&if "{&PGPAR}" <> "" &then
    {utp/ut-liter.i ParÉmetros *}
    CREATE TEXT wh-label-par
        ASSIGN FRAME        = FRAME f-relat:handle
               FORMAT       = "x(10)"
               FONT         = 1
               SCREEN-VALUE = RETURN-VALUE
               WIDTH        = 11
               ROW          = 1.8
               COL          = im-pg-par:col IN FRAME f-relat + 1.7
               VISIBLE      = YES
         TRIGGERS:
             ON MOUSE-SELECT-CLICK
                APPLY "mouse-select-click" TO im-pg-par IN FRAME f-relat.           
         END TRIGGERS.
&endif
/********************************************************** 
** Traduá∆o p†gina digitaá∆o - frame f-pg-dig
**********************************************************/
&if "{&PGDIG}" <> "" &then
    {utp/ut-liter.i Digitaá∆o *}
    CREATE TEXT wh-label-dig
        ASSIGN FRAME        = FRAME f-relat:handle
               FORMAT       = "x(09)"
               FONT         = 1
               SCREEN-VALUE = RETURN-VALUE
               WIDTH        = 10
               ROW          = 1.8
               COL          = im-pg-dig:col IN FRAME f-relat + 1.7
               VISIBLE      = YES
         TRIGGERS:
             ON MOUSE-SELECT-CLICK
                APPLY "mouse-select-click" TO im-pg-dig IN FRAME f-relat.           
         END TRIGGERS.
&endif

/********************************************************** 
** Traduá∆o p†gina impressá∆o - frame f-pg-imp
**********************************************************/
&if "{&PGIMP}" <> "" &then
    {utp/ut-liter.i Impress∆o *}
    CREATE TEXT wh-label-imp
        ASSIGN FRAME        = FRAME f-relat:handle
               FORMAT       = "x(09)"
               FONT         = 1
               SCREEN-VALUE = RETURN-VALUE
               WIDTH        = 10
               ROW          = 1.8
               COL          = im-pg-imp:col IN FRAME f-relat + 1.7
               VISIBLE      = YES
         TRIGGERS:
             ON MOUSE-SELECT-CLICK
                APPLY "mouse-select-click" TO im-pg-imp IN FRAME f-relat.           
         END TRIGGERS.                         
&endif

/********************************************************** 
** Troca de p†gina por CTRL-TAB e SHIFT-CTRL-TAB
**********************************************************/

&IF "{&PGSEL}" <> "" &THEN 
    ASSIGN c-list-folders = c-list-folders + "im-pg-sel,".
&ENDIF
&IF "{&PGCLA}" <> "" &THEN 
    ASSIGN c-list-folders = c-list-folders + "im-pg-cla,".
&ENDIF
&IF "{&PGPAR}" <> "" &THEN 
    ASSIGN c-list-folders = c-list-folders + "im-pg-par,".
&ENDIF
&IF "{&PGDIG}" <> "" &THEN 
    ASSIGN c-list-folders = c-list-folders + "im-pg-dig,".
&ENDIF
&IF "{&PGIMP}" <> "" &THEN
    ASSIGN c-list-folders = c-list-folders + "im-pg-imp".
&ENDIF

IF  SUBSTRING(c-list-folders,LENGTH(c-list-folders)) = "," THEN 
    ASSIGN c-list-folders = SUBSTRING(c-list-folders,1,LENGTH(c-list-folders) - 1 ).

ON  CTRL-TAB ANYWHERE DO:
    IF  i-current-folder = NUM-ENTRIES(c-list-folders,",") THEN
        ASSIGN i-new-folder = 1.
    ELSE 
        ASSIGN i-new-folder = i-current-folder + 1.   
    &IF "{&PGSEL}" &THEN  
        IF  ENTRY(i-new-folder,c-list-folders,",") = "im-pg-sel" THEN
            APPLY 'MOUSE-SELECT-CLICK' TO im-pg-sel IN FRAME f-relat.
    &ENDIF
    &IF "{&PGCLA}" &THEN  
        IF  ENTRY(i-new-folder,c-list-folders,",") = "im-pg-cla" THEN
            APPLY 'MOUSE-SELECT-CLICK' TO im-pg-cla IN FRAME f-relat.
    &ENDIF    
    &IF "{&PGPAR}" &THEN  
        IF  ENTRY(i-new-folder,c-list-folders,",") = "im-pg-par" THEN
            APPLY 'MOUSE-SELECT-CLICK' TO im-pg-par IN FRAME f-relat.
    &ENDIF    
    &IF "{&PGDIG}" &THEN  
        IF  ENTRY(i-new-folder,c-list-folders,",") = "im-pg-dig" THEN
            APPLY 'MOUSE-SELECT-CLICK' TO im-pg-dig IN FRAME f-relat.
    &ENDIF    
    &IF "{&PGIMP}" &THEN  
        IF  ENTRY(i-new-folder,c-list-folders,",") = "im-pg-imp" THEN
            APPLY 'MOUSE-SELECT-CLICK' TO im-pg-imp IN FRAME f-relat.
    &ENDIF    
END.

ON  SHIFT-CTRL-TAB ANYWHERE DO:
    IF  i-current-folder = 1 THEN
        ASSIGN i-new-folder = NUM-ENTRIES(c-list-folders,",").
    ELSE 
        ASSIGN i-new-folder = i-current-folder - 1.
    &IF "{&PGSEL}" &THEN  
        IF  ENTRY(i-new-folder,c-list-folders,",") = "im-pg-sel" THEN
            APPLY 'MOUSE-SELECT-CLICK' TO im-pg-sel IN FRAME f-relat.
    &ENDIF
    &IF "{&PGCLA}" &THEN  
        IF  ENTRY(i-new-folder,c-list-folders,",") = "im-pg-cla" THEN
            APPLY 'MOUSE-SELECT-CLICK' TO im-pg-cla IN FRAME f-relat.
    &ENDIF    
    &IF "{&PGPAR}" &THEN  
        IF  ENTRY(i-new-folder,c-list-folders,",") = "im-pg-par" THEN
            APPLY 'MOUSE-SELECT-CLICK' TO im-pg-par IN FRAME f-relat.
    &ENDIF    
    &IF "{&PGDIG}" &THEN  
        IF  ENTRY(i-new-folder,c-list-folders,",") = "im-pg-dig" THEN
            APPLY 'MOUSE-SELECT-CLICK' TO im-pg-dig IN FRAME f-relat.
    &ENDIF    
    &IF "{&PGIMP}" &THEN  
        IF  ENTRY(i-new-folder,c-list-folders,",") = "im-pg-imp" THEN
            APPLY 'MOUSE-SELECT-CLICK' TO im-pg-imp IN FRAME f-relat.
    &ENDIF    
END.

/********************************************************** 
** Procedure de troca de p†gina por CTRL-TAB 
**********************************************************/
PROCEDURE pi-first-child:
&IF "{&product_version}" >= "12.1.X.2307" &THEN
    {include/i-rpfch.i relDtv}
&ELSE
/* **** Editado automaticamente para o projeto de facelift **** */
        
    DEFINE INPUT PARAMETER wh-entry-folder AS WIDGET-HANDLE.
    
    ASSIGN wh-entry-folder = wh-entry-folder:FIRST-CHILD
           wh-entry-folder = wh-entry-folder:FIRST-CHILD.
    DO  WHILE(VALID-HANDLE(wh-entry-folder)):
        IF  wh-entry-folder:SENSITIVE = YES 
        AND wh-entry-folder:TYPE <> 'rectangle' 
        AND wh-entry-folder:TYPE <> 'image'
        AND wh-entry-folder:TYPE <> 'browse' THEN DO:
            APPLY 'entry' TO wh-entry-folder.
            LEAVE.
        END.
        ELSE
            ASSIGN wh-entry-folder = wh-entry-folder:NEXT-SIBLING.    
    END.
    
&ENDIF
END.

/* i-rplbl */
&if "{&PGIMP}" <> "" &then

PROCEDURE pi-impres-pad:

   DO WITH FRAME f-pg-imp:
      FIND FIRST layout_impres_padr NO-LOCK
           WHERE layout_impres_padr.cod_usuario = c-seg-usuario
             AND layout_impres_padr.cod_proced = c-programa-mg97  USE-INDEX lytmprsp_id /*cl_default_procedure_user of layout_impres_padr*/ NO-ERROR.
      IF NOT AVAIL layout_impres_padr THEN DO:
      FIND FIRST layout_impres_padr NO-LOCK
           WHERE layout_impres_padr.cod_usuario = "*"
             AND layout_impres_padr.cod_proced = c-programa-mg97  USE-INDEX lytmprsp_id /*cl_default_procedure of layout_impres_padr*/ NO-ERROR.
      IF AVAIL layout_impres_padr THEN DO:
         FIND FIRST imprsor_usuar NO-LOCK
              WHERE imprsor_usuar.nom_impressora = layout_impres_padr.nom_impressora
                AND imprsor_usuar.cod_usuario = string(c-seg-usuario) USE-INDEX imprsrsr_id /*cl_layout_current_user of imprsor_usuar*/ NO-ERROR.
      END /* if */.
      IF NOT AVAIL imprsor_usuar THEN DO:
         FIND FIRST layout_impres_padr NO-LOCK
              WHERE layout_impres_padr.cod_usuario = c-seg-usuario
                AND layout_impres_padr.cod_proced = "*" USE-INDEX lytmprsp_id /*cl_default_user of layout_impres_padr*/ NO-ERROR.
         END /* if */.
      END /* if */.
      IF AVAIL layout_impres_padr THEN DO:
         ASSIGN c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp = layout_impres_padr.nom_impressora
                                                         + ":"
                                                         + layout_impres_padr.cod_layout_impres.
      END /* if */.
      ELSE DO:
         c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp = "".
      END /* else */.
   END /* do dflt */.
END.
/*pi-impres-pad */
&endif

/* define procedure externa para execucao do programa de visualizacao do relatorio */

PROCEDURE WinExec EXTERNAL "kernel32.dll":
   DEF INPUT  PARAM prg_name                          AS CHARACTER.
   DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.

PAUSE 0 BEFORE-HIDE.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

   RUN enable_UI.

   rs-formato:DISABLE(ENTRY(1,rs-formato:RADIO-BUTTONS IN FRAME f-pg-imp)) IN FRAME f-pg-imp.

   ASSIGN v-cod-pg-mouse-selec = "im-pg-sel".

   APPLY 'value-changed' TO rs-destino IN FRAME f-pg-imp.

   IF v-cod-pg-mouse-selec = 'im-pg-sel' THEN
      APPLY 'mouse-select-click' TO im-pg-sel IN FRAME f-relat.

   IF v-cod-pg-mouse-selec = 'im-pg-par' THEN
      APPLY 'mouse-select-click' TO im-pg-par IN FRAME f-relat.

   IF v-cod-pg-mouse-selec = "im-pg-imp" THEN
      APPLY 'mouse-select-click' TO im-pg-imp IN FRAME f-relat.

   IF im-pg-sel:SENSITIVE IN FRAME f-relat = NO THEN DO:
      {utp/ut-liter.i Seleá∆o *}
      RUN pi-muda-cor-label-folder(INPUT RETURN-VALUE).
   END.
   
   IF im-pg-par:sensitive IN FRAME f-relat = NO THEN DO:
      {utp/ut-liter.i ParÉmetros *}
      RUN pi-muda-cor-label-folder(INPUT RETURN-VALUE).
   END.
   &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
      IF SEARCH("utp/ut-trcampos.p") <> ? OR Search("utp/ut-trcampos.r") <> ? THEN
         RUN utp/ut-trcampos.p.
   &endif

   IF NOT THIS-PROCEDURE:PERSISTENT THEN
      WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.
/* **********************  Internal Procedures  *********************** */

PROCEDURE adm-row-available :
   /* Define variables needed by this internal procedure.             */
   DEFINE VARIABLE tbl-list           AS CHARACTER INIT "":U NO-UNDO.
   DEFINE VARIABLE rowid-list         AS CHARACTER NO-UNDO.
   DEFINE VARIABLE row-avail-cntr     AS INTEGER INIT 0 NO-UNDO.
   DEFINE VARIABLE row-avail-rowid    AS ROWID NO-UNDO.
   DEFINE VARIABLE row-avail-enabled  AS LOGICAL NO-UNDO.
   DEFINE VARIABLE link-handle        AS CHARACTER NO-UNDO.
   DEFINE VARIABLE record-source-hdl  AS HANDLE NO-UNDO.
   DEFINE VARIABLE different-row      AS LOGICAL NO-UNDO INIT NO.
   DEFINE VARIABLE key-name           AS CHARACTER INIT ? NO-UNDO.
   DEFINE VARIABLE key-value          AS CHARACTER INIT ? NO-UNDO.
 
   RUN check-modified IN THIS-PROCEDURE ('check':U) NO-ERROR.
  
   IF adm-updating-record THEN RETURN.

   RUN GET-ATTRIBUTE ('FIELDS-ENABLED':U).
   row-avail-enabled = IF RETURN-VALUE = "YES":U THEN YES ELSE NO.  
  
   RUN get-link-handle IN adm-broker-hdl (THIS-PROCEDURE, 'RECORD-SOURCE':U,
                                          OUTPUT link-handle) NO-ERROR.
   IF link-handle = "":U THEN     
      RETURN.
      
   ASSIGN record-source-hdl = WIDGET-HANDLE(ENTRY(1,link-handle)).
   IF NUM-ENTRIES(link-handle) > 1 THEN 
      MESSAGE "row-available in ":U THIS-PROCEDURE:FILE-NAME 
              "encountered more than one RECORD-SOURCE.":U SKIP
              "The first - ":U record-source-hdl:FILE-NAME " - will be used.":U
         VIEW-AS ALERT-BOX ERROR.
           
   RUN GET-ATTRIBUTE ('Key-Name':U).
   key-name = RETURN-VALUE.
   
   IF key-name NE ? THEN DO:
      RUN send-key IN record-source-hdl (INPUT key-name, OUTPUT key-value) NO-ERROR.
      IF key-value NE ? THEN
         RUN set-attribute-list (SUBSTITUTE ('Key-Value="&1"':U, key-value)).
   END.

   /* Process the newly available records (i.e. display fields, 
     open queries, and/or pass records on to any RECORD-TARGETS).    */
   IF VALID-HANDLE (adm-object-hdl) THEN
      RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
      
   &IF DEFINED(adm-open-query) NE 0 &THEN      
      IF key-name NE ? OR different-row THEN
         RUN dispatch IN THIS-PROCEDURE ('open-query':U).
      ELSE
         RUN notify IN THIS-PROCEDURE('row-available':U).
   &ELSE 
      RUN notify IN THIS-PROCEDURE ('row-available':U).
   &ENDIF
   
   &IF DEFINED(first-external-table) NE 0 &THEN 
      ASSIGN r-registro-atual = ROWID({&FIRST-EXTERNAL-TABLE}).
   &ENDIF
END PROCEDURE.

PROCEDURE disable_UI :
   IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
   THEN DELETE WIDGET C-Win.
   IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

PROCEDURE enable_UI :
   ENABLE bt-executar bt-cancelar bt-ajuda im-pg-imp im-pg-sel
   WITH FRAME f-relat IN WINDOW C-Win.
   
   DISPLAY  
   c-id-coletor-ini c-id-coletor-fim
   WITH FRAME f-pg-sel IN WINDOW C-Win.

   ENABLE IMAGE-1 IMAGE-2  
   c-id-coletor-ini c-id-coletor-fim
   WITH FRAME f-pg-sel IN WINDOW C-Win.
   
   DISPLAY rs-destino c-arquivo rs-execucao tb-parametro rs-formato
   WITH FRAME f-pg-imp IN WINDOW C-Win.
   ENABLE RECT-7 rs-destino bt-arquivo bt-config-impr c-arquivo RECT-9 rect-10 rs-execucao tb-parametro rs-formato
   WITH FRAME f-pg-imp IN WINDOW C-Win.
   
   DISPLAY 
   WITH FRAME f-pg-par IN WINDOW C-Win.

   ENABLE 
   WITH FRAME f-pg-par IN WINDOW C-Win.
   
   VIEW C-Win.
END PROCEDURE.

PROCEDURE local-exit :
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN.
END PROCEDURE.

PROCEDURE pi-executar :
   DO ON ERROR UNDO, RETURN ERROR
      ON STOP  UNDO, RETURN ERROR:

      /*** In°cio i-rpexa.i ***/
      DEF VAR c-arq-aux    AS CHAR NO-UNDO.
   
      &IF DEFINED(PGLOG) = 0 &THEN
         IF INPUT FRAME f-pg-imp rs-destino  = 2 AND INPUT FRAME f-pg-imp rs-execucao = 1 THEN DO:
                
            ASSIGN c-arq-aux = INPUT FRAME f-pg-imp c-arquivo
                   c-arq-aux = REPLACE(c-arq-aux, "/", "~\").
                   
            IF R-INDEX(c-arq-aux, "~\") > 0 THEN DO:       
               ASSIGN FILE-INFO:FILE-NAME = SUBSTRING(c-arq-aux,1,R-INDEX(c-arq-aux, "~\")).
               IF FILE-INFO:FULL-PATHNAME = ? OR NOT FILE-INFO:FILE-TYPE MATCHES "*D*" THEN DO:
                  RUN utp/ut-msgs.p (INPUT "show", 
                                     INPUT 5749, 
                                     INPUT "").
                  APPLY 'mouse-select-click' TO im-pg-imp IN FRAME f-relat.
                  APPLY 'entry' TO c-arquivo IN FRAME f-pg-imp.                   
                  RETURN ERROR.
               END.
            END.
         END.    
      &ELSE
         IF INPUT FRAME f-pg-log rs-destino  = 2 AND INPUT FRAME f-pg-log rs-execucao = 1 THEN DO:
       
            ASSIGN c-arq-aux = INPUT FRAME f-pg-log c-arquivo-destino
                   c-arq-aux = REPLACE(c-arq-aux, "/", "~\").
                   
            IF R-INDEX(c-arq-aux, "~\") > 0 THEN DO:       
               ASSIGN FILE-INFO:FILE-NAME = SUBSTRING(c-arq-aux,1,R-INDEX(c-arq-aux, "~\")).
               IF FILE-INFO:FULL-PATHNAME = ? OR NOT FILE-INFO:FILE-TYPE MATCHES "*D*" THEN DO:
                  RUN utp/ut-msgs.p (INPUT "show", 
                                     INPUT 5749, 
                                     INPUT "").
                  APPLY 'mouse-select-click' TO im-pg-log IN FRAME f-import.
                  APPLY 'entry' TO c-arquivo-destino IN FRAME f-pg-log.                   
                  RETURN ERROR.
               END.
            END.
         END.    
      &ENDIF
      /*** Fim i-rpexa.i ***/
      IF INPUT FRAME f-pg-imp rs-destino = 2 THEN DO:
         RUN utp/ut-vlarq.p (INPUT INPUT FRAME f-pg-imp c-arquivo).
         IF RETURN-VALUE = "nok" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 73,
                               INPUT "" ).
            APPLY "mouse-select-click" TO im-pg-imp IN FRAME f-relat.
            APPLY "entry" TO c-arquivo IN FRAME f-pg-imp.
            RETURN ERROR.
         END.
      END.
   
      /* Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p†gina
       com problemas e colocar o focus no campo com problemas             */ 
   
      IF v_cdn_empres_usuar <> ? THEN
         ASSIGN i-ep-codigo-usuario = v_cdn_empres_usuar.
   
      CREATE tt-param.
      ASSIGN tt-param.usuario              = c-seg-usuario
             tt-param.destino              = INPUT FRAME f-pg-imp rs-destino
             tt-param.data-exec            = TODAY
             tt-param.hora-exec            = TIME
             tt-param.parametro            = IF INPUT FRAME f-pg-imp tb-parametro = "yes" THEN YES ELSE NO
             tt-param.formato              = IF INPUT FRAME f-pg-imp rs-formato   = "1" THEN 1 ELSE 2
             tt-param.v_num_tip_aces_usuar = v_num_tip_aces_usuar
             tt-param.ep-codigo            = i-ep-codigo-usuario.
      IF tt-param.destino = 1 THEN
         ASSIGN tt-param.arquivo = "".
      ELSE
      IF tt-param.destino = 2 THEN
         ASSIGN tt-param.arquivo = INPUT FRAME f-pg-imp c-arquivo.
      ELSE
         ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp".
   
      ASSIGN tt-param.c-id-coletor-ini = INPUT FRAME f-pg-sel c-id-coletor-ini
             tt-param.c-id-coletor-fim = INPUT FRAME f-pg-sel c-id-coletor-fim
             tt-param.c-id-coletor-fim = INPUT FRAME f-pg-sel c-id-coletor-fim.
   
      /*** In°cio i-rpexb.i ***/
      DEF VAR c-impressora AS CHAR NO-UNDO.
      DEF VAR c-layout AS CHAR NO-UNDO.
   
      IF tt-param.destino = 1 THEN DO:
         ASSIGN tt-param.arquivo = INPUT FRAME f-pg-imp c-arquivo.
         
         IF NUM-ENTRIES(tt-param.arquivo,":") = 2 THEN DO:
            ASSIGN c-impressora = SUBSTRING(c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp,1,INDEX(c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp,":") - 1).
            ASSIGN c-layout = SUBSTRING(c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp,INDEX(c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp,":") + 1,LENGTH(c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp) - INDEX(c-arquivo:SCREEN-VALUE IN FRAME f-pg-imp,":")).
             
            FIND FIRST imprsor_usuar NO-LOCK
                 WHERE imprsor_usuar.nom_impressora = c-impressora
                   AND imprsor_usuar.cod_usuario = c-seg-usuario USE-INDEX imprsrsr_id NO-ERROR.
            IF NOT AVAIL imprsor_usuar THEN DO:
               {utp/ut-liter.i Erro_na_configuraá∆o_da_impressora *} 
               MESSAGE RETURN-VALUE
                  VIEW-AS ALERT-BOX ERROR.
               RETURN ERROR.
            END.       
            FIND FIRST layout_impres NO-LOCK
                 WHERE layout_impres.nom_impressora = c-impressora
                   AND layout_impres.cod_layout_impres = c-layout NO-ERROR.
            IF NOT AVAIL layout_impres THEN DO:
               {utp/ut-liter.i Erro_na_configuraá∆o_da_impressora *} 
               MESSAGE RETURN-VALUE
                  VIEW-AS ALERT-BOX ERROR.
               RETURN ERROR.
            END.       
         END.  
         ELSE DO:
            ASSIGN tt-param.arquivo = INPUT FRAME f-pg-imp c-arquivo.
            ASSIGN c-impressora = ENTRY(1,c-arquivo,":").
            ASSIGN c-layout = ENTRY(2,c-arquivo,":").
             
            FIND FIRST imprsor_usuar NO-LOCK
                 WHERE imprsor_usuar.nom_impressora = c-impressora
                   AND imprsor_usuar.cod_usuario = c-seg-usuario USE-INDEX imprsrsr_id NO-ERROR.
            IF NOT AVAIL imprsor_usuar THEN DO:
               {utp/ut-liter.i Erro_na_configuraá∆o_da_impressora *} 
               MESSAGE RETURN-VALUE
                  VIEW-AS ALERT-BOX ERROR.
               RETURN ERROR.
            END.       
            FIND FIRST layout_impres NO-LOCK
                 WHERE layout_impres.nom_impressora = c-impressora
                   AND layout_impres.cod_layout_impres = c-layout NO-ERROR.
            IF NOT AVAIL layout_impres THEN DO:
               {utp/ut-liter.i Erro_na_configuraá∆o_da_impressora *} 
               MESSAGE RETURN-VALUE
                  VIEW-AS ALERT-BOX ERROR.
               RETURN ERROR.
            END.       
         END.
      END.  
   
      /*** Fim i-rpexb.i ***/
   
      IF SESSION:SET-WAIT-STATE("general") THEN.
      ASSIGN v-cod-prog-i-rprun = "bcp/bcr0051.p".
      DEF VAR i-num-ped-exec-rpw AS INTEGER NO-UNDO.
     
      RAW-TRANSFER tt-param    TO raw-param.
   
      &IF "{&PGDIG}" <> "" &THEN
         EMPTY TEMP-TABLE tt-raw-digita.
         
         FOR EACH tt-digita:
            CREATE tt-raw-digita.
            RAW-TRANSFER tt-digita TO tt-raw-digita.raw-digita.
         END.  
      &ENDIF    

      IF rs-execucao:SCREEN-VALUE IN FRAME f-pg-imp = "2" THEN DO:
         RUN btb/btb911zb.p (INPUT c-programa-mg97,
                             INPUT v-cod-prog-i-rprun,
                             INPUT c-versao-mg97,
                             INPUT 97,
                             INPUT tt-param.arquivo,
                             INPUT tt-param.destino,
                             INPUT raw-param,
                             INPUT table tt-raw-digita,
                             OUTPUT i-num-ped-exec-rpw).
         IF i-num-ped-exec-rpw <> 0 THEN DO:
            {utp/ut-liter.i Criado_pedido_ *}
            ASSIGN v-Ltr = RETURN-VALUE.
            {utp/ut-liter.i _para_execuá∆o_batch *}
            MESSAGE v-Ltr i-num-ped-exec-rpw RETURN-VALUE
               VIEW-AS ALERT-BOX INFORMATION.
         END.
      END.                      
      ELSE DO:                                         
         RUN value(v-cod-prog-i-rprun) (INPUT raw-param,
                                        INPUT table tt-raw-digita).
      END.
      /* Include i-rpexc.i -> ainda n∆o possui c¢digo */

      IF SESSION:SET-WAIT-STATE("") THEN.
      DEF VAR c-key-value AS CHAR NO-UNDO.

      IF tt-param.destino = 3 THEN DO:
         GET-KEY-VALUE SECTION 'DATASUL_EMS2' KEY 'Show-Report-Program' VALUE c-key-value.
         IF c-key-value = "" OR  c-key-value = ?  THEN DO:
            GET-KEY-VALUE SECTION 'MAGNUS97' KEY 'Show-Report-Program' VALUE c-key-value.
            IF c-key-value = "" OR  c-key-value = ?  THEN DO:
               ASSIGN c-key-value = 'notepad.exe'.
               PUT-KEY-VALUE SECTION 'DATASUL_EMS2' KEY 'Show-Report-Program' VALUE c-key-value.
               PUT-KEY-VALUE SECTION 'MAGNUS97' KEY 'Show-Report-Program' VALUE c-key-value.
            END.
            ELSE DO:
               PUT-KEY-VALUE SECTION 'DATASUL_EMS2' KEY 'Show-Report-Program' VALUE c-key-value.
            END.
         END.
         IF SEARCH("utp/ut-showreport.r") <> ? OR SEARCH("utp/ut-showreport.p") <> ? THEN DO:
            RUN utp/ut-showreport.p (tt-param.arquivo).
         END.
         ELSE DO:
            RUN winexec (INPUT c-key-value + CHR(32) + tt-param.arquivo, INPUT 1).
         END.
         {&OPEN-QUERY-{&BROWSE-NAME}}
      END.
   END.
END PROCEDURE.

PROCEDURE pi-troca-pagina:
   &IF "{&product_version}" >= "12.1.X.2307" &THEN
      {include/i-rptrp.i}
   &ELSE
      /* ***** Editado automaticamente para o projeto de facelift ***** */
      IF SELF:move-to-top()  IN FRAME f-relat THEN.
      CASE SELF:name:
          WHEN "im-pg-sel" THEN DO WITH FRAME f-relat:
              &IF "{&PGSEL}" <> "" &THEN
                  VIEW FRAME {&PGSEL}.
                  RUN pi-first-child (INPUT FRAME {&PGSEL}:handle).
                  IF  im-pg-sel:load-image("image/im-fldup") THEN.
                  ASSIGN im-pg-sel:height = 1.20
                         im-pg-sel:row    = 1.50.
              &ENDIF
              &IF "{&PGCLA}" <> "" &THEN
                  HIDE FRAME {&PGCLA}.
                  IF  im-pg-cla:load-image("image/im-flddn") THEN.
                  IF  im-pg-cla:move-to-bottom() THEN.
                  ASSIGN im-pg-cla:height = 1
                         im-pg-cla:row    = 1.6.
              &ENDIF
              &IF "{&PGPAR}" <> "" &THEN
                  HIDE FRAME {&PGPAR}.
                  IF  im-pg-par:load-image("image/im-flddn") THEN.
                  IF  im-pg-par:move-to-bottom() THEN.
                  ASSIGN im-pg-par:height = 1
                         im-pg-par:row    = 1.6.
              &ENDIF
              &IF "{&PGDIG}" <> "" &THEN
                  HIDE FRAME {&PGDIG}.
                  IF  im-pg-dig:load-image("image/im-flddn") THEN.
                  IF  im-pg-dig:move-to-bottom() THEN.
                  ASSIGN im-pg-dig:height = 1
                         im-pg-dig:row    = 1.6.
              &ENDIF
              &IF "{&PGIMP}" <> "" &THEN
                  HIDE FRAME {&PGIMP}.
                  IF  im-pg-imp:load-image("image/im-flddn") THEN.
                  IF  im-pg-imp:move-to-bottom() THEN.
                  ASSIGN im-pg-imp:height = 1
                         im-pg-imp:row    = 1.6.
              &ENDIF
          END.
          WHEN "im-pg-cla" THEN DO WITH FRAME f-relat:
              &IF "{&PGSEL}" <> "" &THEN
                  HIDE FRAME {&PGSEL}.
                  IF  im-pg-sel:load-image("image/im-flddn") THEN.
                  IF  im-pg-sel:move-to-bottom() THEN.
                  ASSIGN im-pg-sel:height = 1
                         im-pg-sel:row    = 1.6.
              &ENDIF
              &IF "{&PGCLA}" <> "" &THEN
                  VIEW FRAME {&PGCLA}.
                  RUN pi-first-child (INPUT FRAME {&PGCLA}:handle).
                  IF  im-pg-cla:load-image("image/im-fldup") THEN.
                  ASSIGN im-pg-cla:height = 1.20
                         im-pg-cla:row    = 1.50.
              &ENDIF
              &IF "{&PGPAR}" <> "" &THEN
                  HIDE FRAME {&PGPAR}.
                  IF  im-pg-par:load-image("image/im-flddn") THEN.
                  IF  im-pg-par:move-to-bottom() THEN.
                  ASSIGN im-pg-par:height = 1
                         im-pg-par:row    = 1.6.
              &ENDIF
              &IF "{&PGDIG}" <> "" &THEN
                  HIDE FRAME {&PGDIG}.
                  IF  im-pg-dig:load-image("image/im-flddn") THEN.
                  IF  im-pg-dig:move-to-bottom() THEN.
                  ASSIGN im-pg-dig:height = 1
                         im-pg-dig:row    = 1.6.
              &ENDIF
              &IF "{&PGIMP}" <> "" &THEN
                  HIDE FRAME {&PGIMP}.
                  IF  im-pg-imp:load-image("image/im-flddn") THEN.
                  IF  im-pg-imp:move-to-bottom() THEN.
                  ASSIGN im-pg-imp:height = 1
                         im-pg-imp:row    = 1.6.
              &ENDIF
          END.
          WHEN "im-pg-par" THEN DO WITH FRAME f-relat:
              &IF "{&PGSEL}" <> "" &THEN
                  HIDE FRAME {&PGSEL}.
                  IF  im-pg-sel:load-image("image/im-flddn") THEN.
                  IF  im-pg-sel:move-to-bottom() THEN.
                  ASSIGN im-pg-sel:height = 1
                         im-pg-sel:row    = 1.6.
              &ENDIF
              &IF "{&PGCLA}" <> "" &THEN
                  HIDE FRAME {&PGCLA}.
                  IF  im-pg-cla:load-image("image/im-flddn") THEN.
                  IF  im-pg-cla:move-to-bottom() THEN.
                  ASSIGN im-pg-cla:height = 1
                         im-pg-cla:row    = 1.6.
              &ENDIF
              &IF "{&PGPAR}" <> "" &THEN
                  VIEW FRAME {&PGPAR}.
                  RUN pi-first-child (INPUT FRAME {&PGPAR}:handle).
                  IF  im-pg-par:load-image("image/im-fldup") THEN.
                  ASSIGN im-pg-par:height = 1.20
                         im-pg-par:row    = 1.5.
              &ENDIF
              &IF "{&PGDIG}" <> "" &THEN
                  HIDE FRAME {&PGDIG}.
                  IF  im-pg-dig:load-image("image/im-flddn") THEN.
                  IF  im-pg-dig:move-to-bottom() THEN.
                  ASSIGN im-pg-dig:height = 1
                         im-pg-dig:row    = 1.6.
              &ENDIF
              &IF "{&PGIMP}" <> "" &THEN
                  HIDE FRAME {&PGIMP}.
                  IF  im-pg-imp:load-image("image/im-flddn") THEN.
                  IF  im-pg-imp:move-to-bottom() THEN.
                  ASSIGN im-pg-imp:height = 1
                         im-pg-imp:row    = 1.6.
              &ENDIF
          END.
          WHEN "im-pg-dig" THEN DO WITH FRAME f-relat:
              &IF "{&PGSEL}" <> "" &THEN
                  HIDE FRAME {&PGSEL}.
                  IF  im-pg-sel:load-image("image/im-flddn") THEN.
                  IF  im-pg-sel:move-to-bottom() THEN.
                  ASSIGN im-pg-sel:height = 1
                         im-pg-sel:row    = 1.6.
              &ENDIF
              &IF "{&PGCLA}" <> "" &THEN
                  HIDE FRAME {&PGCLA}.
                  IF  im-pg-cla:load-image("image/im-flddn") THEN.
                  IF  im-pg-cla:move-to-bottom() THEN.
                  ASSIGN im-pg-cla:height = 1
                         im-pg-cla:row    = 1.6.
              &ENDIF
              &IF "{&PGPAR}" <> "" &THEN
                  HIDE FRAME {&PGPAR}.
                  IF  im-pg-par:load-image("image/im-flddn") THEN.
                  IF  im-pg-par:move-to-bottom() THEN.
                  ASSIGN im-pg-par:height = 1
                         im-pg-par:row    = 1.6.
              &ENDIF
              &IF "{&PGDIG}" <> "" &THEN
                  VIEW FRAME {&PGDIG}.
                  RUN pi-first-child (INPUT FRAME {&PGDIG}:handle).
                  IF  im-pg-dig:load-image("image/im-fldup") THEN.
                  ASSIGN im-pg-dig:height = 1.20
                         im-pg-dig:row    = 1.5.
              &ENDIF
              &IF "{&PGIMP}" <> "" &THEN
                  HIDE FRAME {&PGIMP}.
                  IF  im-pg-imp:load-image("image/im-flddn") THEN.
                  IF  im-pg-imp:move-to-bottom() THEN.
                  ASSIGN im-pg-imp:height = 1
                         im-pg-imp:row    = 1.6.
              &ENDIF
          END.
          WHEN "im-pg-imp" THEN DO WITH FRAME f-relat:
              &IF "{&PGSEL}" <> "" &THEN
                  HIDE FRAME {&PGSEL}.
                  IF  im-pg-sel:load-image("image/im-flddn") THEN.
                  IF  im-pg-sel:move-to-bottom() THEN.
                  ASSIGN im-pg-sel:height = 1
                         im-pg-sel:row    = 1.6.
              &ENDIF
              &IF "{&PGCLA}" <> "" &THEN
                  HIDE FRAME {&PGCLA}.
                  IF  im-pg-cla:load-image("image/im-flddn") THEN.
                  IF  im-pg-cla:move-to-bottom() THEN.
                  ASSIGN im-pg-cla:height = 1
                         im-pg-cla:row    = 1.6.
              &ENDIF
              &IF "{&PGPAR}" <> "" &THEN
                  HIDE FRAME {&PGPAR}.
                  IF  im-pg-par:load-image("image/im-flddn") THEN.
                  IF  im-pg-par:move-to-bottom() THEN.
                  ASSIGN im-pg-par:height = 1
                         im-pg-par:row    = 1.6.
              &ENDIF
              &IF "{&PGDIG}" <> "" &THEN
                  HIDE FRAME {&PGDIG}.
                  IF  im-pg-dig:load-image("image/im-flddn") THEN.
                  IF  im-pg-dig:move-to-bottom() THEN.
                  ASSIGN im-pg-dig:height = 1
                         im-pg-dig:row    = 1.6.
              &ENDIF
              &IF "{&PGIMP}" <> "" &THEN
                  VIEW FRAME {&PGIMP}.
                  RUN pi-first-child (INPUT FRAME {&PGIMP}:handle).
                  IF  im-pg-imp:load-image("image/im-fldup") THEN.
                  ASSIGN im-pg-imp:height = 1.20
                         im-pg-imp:row    = 1.5.
              &ENDIF
          END.
      END CASE.

      ASSIGN i-current-folder = LOOKUP(SELF:name,c-list-folders,",").
   &ENDIF
END PROCEDURE.

PROCEDURE send-records :
   /* Define variables needed by this internal procedure.               */ 
   DEFINE INPUT PARAMETER p-tbl-list AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER p-rowid-list AS CHARACTER NO-UNDO.
  
   DEFINE VARIABLE i            AS INTEGER   NO-UNDO.
   DEFINE VARIABLE link-handle  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE rowid-string AS CHARACTER NO-UNDO.
  
   DO i = 1 TO NUM-ENTRIES(p-tbl-list):
      IF i > 1 THEN p-rowid-list = p-rowid-list + ",":U. 
      CASE ENTRY(i, p-tbl-list):

         /* For each requested table, put it's ROWID in the output list.      */
         /* Deal with any unexpected table requests before closing.           */ 
      OTHERWISE DO:
         RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                INPUT "RECORD-SOURCE":U, OUTPUT link-handle) NO-ERROR.
         IF link-handle NE "":U THEN DO:
            IF NUM-ENTRIES(link-handle) > 1 THEN  
               MESSAGE "send-records in ":U THIS-PROCEDURE:FILE-NAME 
                       "encountered more than one RECORD-SOURCE.":U SKIP
                       "The first will be used.":U 
                  VIEW-AS ALERT-BOX ERROR.
                  
               RUN send-records IN WIDGET-HANDLE(ENTRY(1,link-handle)) (INPUT ENTRY(i, p-tbl-list),
                                                                        OUTPUT rowid-string).
                p-rowid-list = p-rowid-list + rowid-string.
            END.
            ELSE DO:
               MESSAGE "Requested table":U ENTRY(i, p-tbl-list) 
                       "does not match tables in send-records":U 
                       "in procedure":U THIS-PROCEDURE:FILE-NAME ".":U SKIP
                       "Check that objects are linked properly and that":U
                       "database qualification is consistent.":U
                  VIEW-AS ALERT-BOX ERROR.     
               RETURN ERROR.
            END.
         END.
      END CASE.        
   END.
END PROCEDURE.

PROCEDURE state-changed :
   DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
   DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
   RUN pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

PROCEDURE pi-muda-cor-label-folder:
   DEF INPUT PARAMETER p-cod-label AS CHAR.

   ASSIGN wh-group = FRAME f-relat:handle
          wh-group = wh-group:FIRST-CHILD.
          
   DO WHILE wh-group <> ?:
      DO  WHILE VALID-HANDLE(wh-group):
         ASSIGN wh-child = wh-group:FIRST-CHILD.
         DO  WHILE VALID-HANDLE(wh-child):
            IF wh-child:TYPE = "TEXT" THEN
               IF wh-child:SCREEN-VALUE = p-cod-label THEN
                  ASSIGN wh-child:FGCOLOR = 7.
            ASSIGN wh-child = wh-child:NEXT-SIBLING.
         END.
         ASSIGN wh-group = wh-group:NEXT-SIBLING.
      END.
   END.
END PROCEDURE

