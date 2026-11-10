&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            MSS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-repres NO-UNDO LIKE repres
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-repres-1 NO-UNDO LIKE repres
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-repres-2 NO-UNDO LIKE repres
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wZoom 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i Z02AD229 2.00.00.002}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i Z02AD229 MCD}
&ENDIF

CREATE WIDGET-POOL.

{include/i_prdvers.i} /* Include de versao de banco de dados */

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           Z02AD229
&GLOBAL-DEFINE Version           2.00.00.002
&GLOBAL-DEFINE DBOVersion        1.1

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      C¢digo,Abrevia‡Æo,CNPJ

&GLOBAL-DEFINE Range             NO


&GLOBAL-DEFINE FieldsAnyKeyPage1 NO 
&GLOBAL-DEFINE FieldsAnyKeyPage2 NO 
&GLOBAL-DEFINE FieldsAnyKeyPage3 NO

&GLOBAL-DEFINE ttTable1          tt-repres
&GLOBAL-DEFINE hDBOTable1        h-boad229
&GLOBAL-DEFINE DBOTable1         repres
&GLOBAL-DEFINE ttTable2          tt-repres-1
&GLOBAL-DEFINE hDBOTable2        h-boad229-1
&GLOBAL-DEFINE DBOTable2         repres
&GLOBAL-DEFINE ttTable3          tt-repres-2
&GLOBAL-DEFINE hDBOTable3        h-boad229-2
&GLOBAL-DEFINE DBOTable3         repres

&GLOBAL-DEFINE page1Browse brTable1
&GLOBAL-DEFINE page2Browse brTable2     
&GLOBAL-DEFINE page3Browse brTable3

&GLOBAL-DEFINE OFF-END1               YES
&GLOBAL-DEFINE OFF-END2               YES
&GLOBAL-DEFINE OFF-END3               YES
&GLOBAL-DEFINE EXCLUDE-applyHome
&GLOBAL-DEFINE EXCLUDE-applyOffEnd
&GLOBAL-DEFINE EXCLUDE-applyEnd
&GLOBAL-DEFINE EXCLUDE-applyOffHome

&GLOBAL-DEFINE NumRowsReturned   99999




/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1}      AS HANDLE    NO-UNDO.
DEFINE VARIABLE {&hDBOTable2}      AS HANDLE    NO-UNDO.
DEFINE VARIABLE {&hDBOTable3}      AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-natureza         AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-natureza-1       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-natureza-2       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cnpj             AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cnpj-1           AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cnpj-2           AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-ident-intermed   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-ident-intermed-1 AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-ident-intermed-2 AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-form1 LIKE param-global.formato-id-pessoal.
DEFINE VARIABLE c-form2 LIKE param-global.formato-id-pessoal.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Zoom
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTable1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-repres tt-repres-1 tt-repres-2

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-repres.cod-rep ~
tt-repres.nome-abrev fnIdentIntermed() @ c-ident-intermed tt-repres.nome ~
fnNatureza() @ c-natureza tt-repres.nome-ab-reg tt-repres.endereco ~
tt-repres.bairro tt-repres.cep tt-repres.cidade tt-repres.estado ~
tt-repres.pais fnCnpj() @ c-cnpj tt-repres.inscr-est ~
tt-repres.ins-municipal 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-repres NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-repres NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-repres
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-repres


/* Definitions for BROWSE brTable2                                      */
&Scoped-define FIELDS-IN-QUERY-brTable2 tt-repres-1.nome-abrev ~
tt-repres-1.cod-rep fnIdentIntermed1() @ c-ident-intermed-1 ~
tt-repres-1.nome fnNatureza1() @ c-natureza-1 tt-repres-1.nome-ab-reg ~
tt-repres-1.endereco tt-repres-1.bairro tt-repres-1.cep tt-repres-1.cidade ~
tt-repres-1.estado tt-repres-1.pais fnCnpj1() @ c-cnpj-1 ~
tt-repres-1.inscr-est tt-repres-1.ins-municipal 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable2 
&Scoped-define QUERY-STRING-brTable2 FOR EACH tt-repres-1 NO-LOCK ~
    BY tt-repres-1.nome-abrev INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brTable2 OPEN QUERY brTable2 FOR EACH tt-repres-1 NO-LOCK ~
    BY tt-repres-1.nome-abrev INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brTable2 tt-repres-1
&Scoped-define FIRST-TABLE-IN-QUERY-brTable2 tt-repres-1


/* Definitions for BROWSE brTable3                                      */
&Scoped-define FIELDS-IN-QUERY-brTable3 fnCnpj2() @ c-cnpj-2 ~
tt-repres-2.cod-rep tt-repres-2.nome-abrev ~
fnIdentIntermed2() @ c-ident-intermed-2 tt-repres-2.nome ~
fnNatureza2() @ c-natureza-2 tt-repres-2.nome-ab-reg tt-repres-2.endereco ~
tt-repres-2.bairro tt-repres-2.cep tt-repres-2.cidade tt-repres-2.estado ~
tt-repres-2.pais tt-repres-2.inscr-est tt-repres-2.ins-municipal 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable3 
&Scoped-define QUERY-STRING-brTable3 FOR EACH tt-repres-2 NO-LOCK ~
    BY tt-repres-2.cgc INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brTable3 OPEN QUERY brTable3 FOR EACH tt-repres-2 NO-LOCK ~
    BY tt-repres-2.cgc INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brTable3 tt-repres-2
&Scoped-define FIRST-TABLE-IN-QUERY-brTable3 tt-repres-2


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brTable2}

/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brTable3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCnpj wZoom 
FUNCTION fnCnpj RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCnpj1 wZoom 
FUNCTION fnCnpj1 RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCnpj2 wZoom 
FUNCTION fnCnpj2 RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnIdentIntermed wZoom 
FUNCTION fnIdentIntermed RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnIdentIntermed1 wZoom 
FUNCTION fnIdentIntermed1 RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnIdentIntermed2 wZoom 
FUNCTION fnIdentIntermed2 RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNatureza wZoom 
FUNCTION fnNatureza RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNatureza1 wZoom 
FUNCTION fnNatureza1 RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNatureza2 wZoom 
FUNCTION fnNatureza2 RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wZoom AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btCheck-1 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE i-cod-rep-fim AS INTEGER FORMAT ">>>>9" INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-rep-ini AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "C¢digo Repres" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-26
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-27
     FILENAME "image\im-fir":U
     SIZE 4 BY .88.

DEFINE BUTTON btCheck-2 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant2 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-nome-abrev-fim AS CHARACTER FORMAT "x(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Nome Abrev" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-30
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-31
     FILENAME "image\im-fir":U
     SIZE 4 BY .88.

DEFINE BUTTON btCheck-3 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant3 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-cgc-fim AS CHARACTER FORMAT "X(19)" INITIAL "ZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE c-cgc-ini AS CHARACTER FORMAT "X(19)" 
     LABEL "CNPJ Repres" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-32
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-33
     FILENAME "image\im-fir":U
     SIZE 4 BY .88.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-repres SCROLLING.

DEFINE QUERY brTable2 FOR 
      tt-repres-1 SCROLLING.

DEFINE QUERY brTable3 FOR 
      tt-repres-2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-repres.cod-rep FORMAT ">>>>9":U WIDTH 7
      tt-repres.nome-abrev FORMAT "x(12)":U WIDTH 15
      fnIdentIntermed() @ c-ident-intermed COLUMN-LABEL "Ident no Intermed" FORMAT "x(60)":U
            WIDTH 40
      tt-repres.nome FORMAT "x(80)":U WIDTH 60
      fnNatureza() @ c-natureza COLUMN-LABEL "Natureza" FORMAT "x(20)":U
      tt-repres.nome-ab-reg FORMAT "x(12)":U WIDTH 14
      tt-repres.endereco FORMAT "x(40)":U WIDTH 42
      tt-repres.bairro FORMAT "x(30)":U WIDTH 32
      tt-repres.cep FORMAT "x(12)":U WIDTH 14
      tt-repres.cidade FORMAT "x(50)":U WIDTH 52
      tt-repres.estado FORMAT "x(004)":U WIDTH 5
      tt-repres.pais FORMAT "x(20)":U WIDTH 22
      fnCnpj() @ c-cnpj COLUMN-LABEL "CNPJ" FORMAT "x(18)":U WIDTH 22
      tt-repres.inscr-est COLUMN-LABEL "Inscr Estadual" FORMAT "x(19)":U
            WIDTH 21
      tt-repres.ins-municipal COLUMN-LABEL "Inscr Municipal" FORMAT "X(19)":U
            WIDTH 21
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.67
         FONT 2.

DEFINE BROWSE brTable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable2 wZoom _STRUCTURED
  QUERY brTable2 NO-LOCK DISPLAY
      tt-repres-1.nome-abrev FORMAT "x(12)":U WIDTH 15
      tt-repres-1.cod-rep FORMAT ">>>>9":U WIDTH 7
      fnIdentIntermed1() @ c-ident-intermed-1 COLUMN-LABEL "Ident no Intermed" FORMAT "x(60)":U
            WIDTH 40
      tt-repres-1.nome FORMAT "x(80)":U WIDTH 60
      fnNatureza1() @ c-natureza-1 COLUMN-LABEL "Natureza" FORMAT "x(20)":U
      tt-repres-1.nome-ab-reg FORMAT "x(12)":U WIDTH 14
      tt-repres-1.endereco FORMAT "x(40)":U WIDTH 42
      tt-repres-1.bairro FORMAT "x(30)":U WIDTH 32
      tt-repres-1.cep FORMAT "x(12)":U WIDTH 14
      tt-repres-1.cidade FORMAT "x(50)":U WIDTH 52
      tt-repres-1.estado FORMAT "x(4)":U
      tt-repres-1.pais FORMAT "x(20)":U WIDTH 22
      fnCnpj1() @ c-cnpj-1 COLUMN-LABEL "CNPJ" FORMAT "x(18)":U
            WIDTH 22
      tt-repres-1.inscr-est COLUMN-LABEL "Inscr Estadual" FORMAT "x(19)":U
            WIDTH 21
      tt-repres-1.ins-municipal COLUMN-LABEL "Inscr Municipal" FORMAT "X(19)":U
            WIDTH 21
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.67
         FONT 2.

DEFINE BROWSE brTable3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable3 wZoom _STRUCTURED
  QUERY brTable3 NO-LOCK DISPLAY
      fnCnpj2() @ c-cnpj-2 COLUMN-LABEL "CNPJ" FORMAT "x(18)":U
            WIDTH 22
      tt-repres-2.cod-rep FORMAT ">>>>9":U WIDTH 7
      tt-repres-2.nome-abrev FORMAT "x(12)":U WIDTH 15
      fnIdentIntermed2() @ c-ident-intermed-2 COLUMN-LABEL "Ident no Intermed" FORMAT "x(60)":U
            WIDTH 40
      tt-repres-2.nome FORMAT "x(80)":U WIDTH 60
      fnNatureza2() @ c-natureza-2 COLUMN-LABEL "Natureza" FORMAT "x(20)":U
      tt-repres-2.nome-ab-reg FORMAT "x(12)":U WIDTH 14
      tt-repres-2.endereco FORMAT "x(40)":U WIDTH 42
      tt-repres-2.bairro FORMAT "x(30)":U WIDTH 32
      tt-repres-2.cep FORMAT "x(12)":U WIDTH 14
      tt-repres-2.cidade FORMAT "x(50)":U WIDTH 52
      tt-repres-2.estado FORMAT "x(4)":U WIDTH 5
      tt-repres-2.pais FORMAT "x(20)":U WIDTH 22
      tt-repres-2.inscr-est COLUMN-LABEL "Inscr Estadual" FORMAT "x(19)":U
            WIDTH 21
      tt-repres-2.ins-municipal COLUMN-LABEL "Inscr Municipal" FORMAT "X(19)":U
            WIDTH 21
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.67
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.71 COL 2
     btCancel AT ROW 16.71 COL 13
     btHelp AT ROW 16.71 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.98
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     btCheck-2 AT ROW 1.13 COL 78.72 WIDGET-ID 2
     c-nome-abrev-ini AT ROW 1.25 COL 12.29 COLON-ALIGNED HELP
          "Nome Abrev Inicial do Representante" WIDGET-ID 12
     c-nome-abrev-fim AT ROW 1.25 COL 49.29 COLON-ALIGNED HELP
          "Nome Abrev Final do Representante" NO-LABEL WIDGET-ID 4
     brTable2 AT ROW 2.33 COL 2
     btImplant2 AT ROW 13 COL 2
     IMAGE-30 AT ROW 1.25 COL 47.86 WIDGET-ID 8
     IMAGE-31 AT ROW 1.25 COL 26.86 WIDGET-ID 10
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     btCheck-1 AT ROW 1.13 COL 78.72 WIDGET-ID 2
     i-cod-rep-ini AT ROW 1.25 COL 14 COLON-ALIGNED HELP
          "C¢digo Inicial do Representante" WIDGET-ID 12
     i-cod-rep-fim AT ROW 1.25 COL 49.29 COLON-ALIGNED HELP
          "C¢digo Final do Representante" NO-LABEL WIDGET-ID 4
     brTable1 AT ROW 2.33 COL 2
     btImplant1 AT ROW 13 COL 2
     IMAGE-26 AT ROW 1.25 COL 47.86 WIDGET-ID 8
     IMAGE-27 AT ROW 1.25 COL 27.43 WIDGET-ID 10
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage3
     btCheck-3 AT ROW 1.13 COL 78.72 WIDGET-ID 2
     c-cgc-ini AT ROW 1.25 COL 10.86 COLON-ALIGNED HELP
          "CNPJ Inicial do Representante" WIDGET-ID 12
     c-cgc-fim AT ROW 1.25 COL 49.29 COLON-ALIGNED HELP
          "CNPJ Final do Representante" NO-LABEL WIDGET-ID 4
     brTable3 AT ROW 2.33 COL 2
     btImplant3 AT ROW 13 COL 2
     IMAGE-32 AT ROW 1.25 COL 47.86 WIDGET-ID 8
     IMAGE-33 AT ROW 1.25 COL 32.29 WIDGET-ID 10
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1 WIDGET-ID 200.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-repres T "?" NO-UNDO mgcad repres
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-repres-1 T "?" NO-UNDO mgcad repres
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-repres-2 T "?" NO-UNDO mgcad repres
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wZoom ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wZoom 
/* ************************* Included-Libraries *********************** */

{zoom/zoom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wZoom
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable1 i-cod-rep-fim fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brTable2 c-nome-abrev-fim fPage2 */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brTable3 c-cgc-fim fPage3 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-repres"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-repres.cod-rep
"cod-rep" ? ? "integer" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-repres.nome-abrev
"nome-abrev" ? ? "character" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fnIdentIntermed() @ c-ident-intermed" "Ident no Intermed" "x(60)" ? ? ? ? ? ? ? no "Indentifica‡Æo no Intermediador" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-repres.nome
"nome" ? ? "character" ? ? ? ? ? ? no ? no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fnNatureza() @ c-natureza" "Natureza" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-repres.nome-ab-reg
"nome-ab-reg" ? ? "character" ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-repres.endereco
"endereco" ? ? "character" ? ? ? ? ? ? no ? no no "42" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-repres.bairro
"bairro" ? "x(30)" "character" ? ? ? ? ? ? no ? no no "32" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-repres.cep
"cep" ? ? "character" ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-repres.cidade
"cidade" ? ? "character" ? ? ? ? ? ? no ? no no "52" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-repres.estado
"estado" ? ? "character" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tt-repres.pais
"pais" ? ? "character" ? ? ? ? ? ? no ? no no "22" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"fnCnpj() @ c-cnpj" "CNPJ" "x(18)" ? ? ? ? ? ? ? no "N£mero do CGC no minist‚rio da fazenda" no no "22" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.tt-repres.inscr-est
"inscr-est" "Inscr Estadual" ? "character" ? ? ? ? ? ? no ? no no "21" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.tt-repres.ins-municipal
"ins-municipal" "Inscr Municipal" ? "character" ? ? ? ? ? ? no ? no no "21" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable2
/* Query rebuild information for BROWSE brTable2
     _TblList          = "Temp-Tables.tt-repres-1"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tt-repres-1.nome-abrev|yes"
     _FldNameList[1]   > Temp-Tables.tt-repres-1.nome-abrev
"nome-abrev" ? ? "character" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-repres-1.cod-rep
"cod-rep" ? ? "integer" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fnIdentIntermed1() @ c-ident-intermed-1" "Ident no Intermed" "x(60)" ? ? ? ? ? ? ? no "Indentifica‡Æo no Intermediador" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-repres-1.nome
"nome" ? ? "character" ? ? ? ? ? ? no ? no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fnNatureza1() @ c-natureza-1" "Natureza" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-repres-1.nome-ab-reg
"nome-ab-reg" ? ? "character" ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-repres-1.endereco
"endereco" ? ? "character" ? ? ? ? ? ? no ? no no "42" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-repres-1.bairro
"bairro" ? "x(30)" "character" ? ? ? ? ? ? no ? no no "32" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-repres-1.cep
"cep" ? ? "character" ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-repres-1.cidade
"cidade" ? ? "character" ? ? ? ? ? ? no ? no no "52" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-repres-1.estado
"estado" ? "x(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tt-repres-1.pais
"pais" ? ? "character" ? ? ? ? ? ? no ? no no "22" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"fnCnpj1() @ c-cnpj-1" "CNPJ" "x(18)" ? ? ? ? ? ? ? no "N£mero do CGC no minist‚rio da fazenda" no no "22" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.tt-repres-1.inscr-est
"inscr-est" "Inscr Estadual" ? "character" ? ? ? ? ? ? no ? no no "21" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.tt-repres-1.ins-municipal
"ins-municipal" "Inscr Municipal" ? "character" ? ? ? ? ? ? no ? no no "21" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brTable2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable3
/* Query rebuild information for BROWSE brTable3
     _TblList          = "Temp-Tables.tt-repres-2"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tt-repres-2.cgc|yes"
     _FldNameList[1]   > "_<CALC>"
"fnCnpj2() @ c-cnpj-2" "CNPJ" "x(18)" ? ? ? ? ? ? ? no "N£mero do CGC no minist‚rio da fazenda" no no "22" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-repres-2.cod-rep
"cod-rep" ? ? "integer" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-repres-2.nome-abrev
"nome-abrev" ? ? "character" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fnIdentIntermed2() @ c-ident-intermed-2" "Ident no Intermed" "x(60)" ? ? ? ? ? ? ? no "Identifica‡Æo no Intermediador" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-repres-2.nome
"nome" ? ? "character" ? ? ? ? ? ? no ? no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fnNatureza2() @ c-natureza-2" "Natureza" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-repres-2.nome-ab-reg
"nome-ab-reg" ? ? "character" ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-repres-2.endereco
"endereco" ? ? "character" ? ? ? ? ? ? no ? no no "42" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-repres-2.bairro
"bairro" ? "x(30)" "character" ? ? ? ? ? ? no ? no no "32" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-repres-2.cep
"cep" ? ? "character" ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-repres-2.cidade
"cidade" ? ? "character" ? ? ? ? ? ? no ? no no "52" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tt-repres-2.estado
"estado" ? "x(4)" "character" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.tt-repres-2.pais
"pais" ? ? "character" ? ? ? ? ? ? no ? no no "22" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.tt-repres-2.inscr-est
"inscr-est" "Inscr Estadual" ? "character" ? ? ? ? ? ? no ? no no "21" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.tt-repres-2.ins-municipal
"ins-municipal" "Inscr Municipal" ? "character" ? ? ? ? ? ? no ? no no "21" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brTable3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wZoom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wZoom wZoom
ON END-ERROR OF wZoom
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wZoom wZoom
ON WINDOW-CLOSE OF wZoom
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wZoom
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btCheck-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck-1 wZoom
ON CHOOSE OF btCheck-1 IN FRAME fPage1
DO:
  RUN setConstraints IN THIS-PROCEDURE (INPUT 1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btCheck-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck-2 wZoom
ON CHOOSE OF btCheck-2 IN FRAME fPage2
DO:
  RUN setConstraints IN THIS-PROCEDURE (INPUT 2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btCheck-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck-3 wZoom
ON CHOOSE OF btCheck-3 IN FRAME fPage3
DO:
  RUN setConstraints IN THIS-PROCEDURE (INPUT 3).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wZoom
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btImplant1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant1 wZoom
ON CHOOSE OF btImplant1 IN FRAME fPage1 /* Implantar */
DO:
/*    {zoom/implant.i &ProgramImplant="<ProgramName>"
                    &PageNumber="1"}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btImplant2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant2 wZoom
ON CHOOSE OF btImplant2 IN FRAME fPage2 /* Implantar */
DO:
    /*{zoom/implant.i &ProgramImplant="<ProgramName>"
                    &PageNumber="2"}                 */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btImplant3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant3 wZoom
ON CHOOSE OF btImplant3 IN FRAME fPage3 /* Implantar */
DO:
    /*{zoom/implant.i &ProgramImplant="<ProgramName>"
                    &PageNumber="2"}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wZoom
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    RUN returnValues IN THIS-PROCEDURE.
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brTable1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wZoom 


/* ***************************  Main Block  *************************** */

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{zoom/mainblock.i}

ASSIGN i-cod-rep-ini:SENSITIVE       IN FRAME fPage1 = YES
       i-cod-rep-fim:SENSITIVE       IN FRAME fPage1 = YES
       c-nome-abrev-ini:SENSITIVE    IN FRAME fPage2 = YES
       c-nome-abrev-fim:SENSITIVE    IN FRAME fPage2 = YES
       c-cgc-ini:SENSITIVE           IN FRAME fPage3 = YES
       c-cgc-fim:SENSITIVE           IN FRAME fPage3 = YES
       btCheck-1:SENSITIVE IN FRAME fPage1 = YES
       btCheck-2:SENSITIVE IN FRAME fPage2 = YES
       btCheck-3:SENSITIVE IN FRAME fPage3 = YES
       i-cod-rep-fim:SCREEN-VALUE   IN FRAME fPage1 = "99999"
       c-nome-abrev-fim:SCREEN-VALUE   IN FRAME fPage2 = "ZZZZZZZZZZZZ"
       c-cgc-fim:SCREEN-VALUE   IN FRAME fPage3 = "ZZZZZZZZZZZZZZZZZZZ"
       .

FIND FIRST param-global.

IF AVAIL param-global THEN DO:
    ASSIGN c-form1 = param-global.formato-id-pessoal
           c-form2 = param-global.formato-id-federal.
END.

IF c-form1 = "" THEN
   ASSIGN c-form1 = "X(11)".
IF c-form2 = "" THEN
   ASSIGN c-form2 = "X(14)".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wZoom 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
APPLY "ENTRY":U TO brTable1 IN FRAME fPage1.
APPLY "ENTRY":U TO brTable2 IN FRAME fPage2.
APPLY "ENTRY":U TO brTable3 IN FRAME fPage3.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyEnd wZoom 
PROCEDURE applyEnd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyHome wZoom 
PROCEDURE applyHome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyOffEnd wZoom 
PROCEDURE applyOffEnd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyOffHome wZoom 
PROCEDURE applyOffHome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wZoom 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable1}) OR
       {&hDBOTable1}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable1}:FILE-NAME <> "adbo/boad229.p":U THEN DO:
       
        {btb/btb008za.i1 adbo/boad229.p YES}
        {btb/btb008za.i2 adbo/boad229.p '' {&hDBOTable1}} 
    END.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable2}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "adbo/boad229.p":U THEN DO:
       
        {btb/btb008za.i1 adbo/boad229.p YES}
        {btb/btb008za.i2 adbo/boad229.p '' {&hDBOTable2}} 
    END.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable3}) OR
       {&hDBOTable3}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable3}:FILE-NAME <> "adbo/boad229.p":U THEN DO:
       
        {btb/btb008za.i1 adbo/boad229.p YES}
        {btb/btb008za.i2 adbo/boad229.p '' {&hDBOTable3}} 
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueries wZoom 
PROCEDURE openQueries :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    {zoom/openqueries.i &Query="6"
                        &PageNumber="1"
                        &QueryNumber="6"}
    
    {zoom/openqueries.i &Query="7"
                        &PageNumber="2"
                        &QueryNumber="7"}
    
    {zoom/openqueries.i &Query="8"
                        &PageNumber="3"
                        &QueryNumber="8"}    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage1 wZoom 
PROCEDURE returnFieldsPage1 :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 1
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
                
    IF AVAILABLE {&ttTable1} THEN DO:
        CASE pcField:
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nome-abrev).
            WHEN "cgc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cgc).
            WHEN "nome":U THEN
                ASSIGN pcFieldValue = &IF '{&product_version}' >= '12.1.W' &THEN 
                                            IF STRING({&ttTable1}.nom-usuar-interm) <> "" THEN 
                                                    STRING({&ttTable1}.nom-usuar-interm)
                                            ELSE 
                                                    STRING({&ttTable1}.nome)
                                      &ELSE
                                            IF TRIM(SUBSTRING({&ttTable1}.char-1,13,60)) <> "" THEN 
                                                    TRIM(SUBSTRING({&ttTable1}.char-1,13,60))
                                            ELSE 
                                                    STRING({&ttTable1}.nome)
                                      &ENDIF.

                END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage2 wZoom 
PROCEDURE returnFieldsPage2 :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 2
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable2} THEN DO:
        CASE pcField:
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.nome-abrev).
            WHEN "cgc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cgc).
            WHEN "nome":U THEN
                ASSIGN pcFieldValue = &IF '{&product_version}' >= '12.1.W' &THEN 
                                            IF STRING({&ttTable2}.nom-usuar-interm) <> "" THEN 
                                                    STRING({&ttTable2}.nom-usuar-interm)
                                            ELSE 
                                                    STRING({&ttTable2}.nome)
                                      &ELSE
                                            IF TRIM(SUBSTRING({&ttTable2}.char-1,13,60)) <> "" THEN 
                                                    TRIM(SUBSTRING({&ttTable2}.char-1,13,60))
                                            ELSE 
                                                    STRING({&ttTable2}.nome)
                                      &ENDIF.
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage3 wZoom 
PROCEDURE returnFieldsPage3 :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 3
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable3} THEN DO:
        CASE pcField:
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.nome-abrev).
            WHEN "cgc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.cgc).
            WHEN "nome":U THEN
                ASSIGN pcFieldValue = &IF '{&product_version}' >= '12.1.W' &THEN 
                                            IF STRING({&ttTable3}.nom-usuar-interm) <> "" THEN 
                                                    STRING({&ttTable3}.nom-usuar-interm)
                                            ELSE 
                                                    STRING({&ttTable3}.nome)
                                      &ELSE
                                            IF TRIM(SUBSTRING({&ttTable3}.char-1,13,60)) <> "" THEN 
                                                    TRIM(SUBSTRING({&ttTable3}.char-1,13,60))
                                            ELSE 
                                                    STRING({&ttTable3}.nome)
                                      &ENDIF.
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraints wZoom 
PROCEDURE setConstraints :
/*:T------------------------------------------------------------------------------
  Purpose:     Seta constraints e atualiza o browse, conforme n£mero da p gina
               passado como parƒmetro
  Parameters:  recebe n£mero da p gina
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    
    /*:T--- Seta constraints conforme n£mero da p gina ---*/
    CASE pPageNumber:
        WHEN 1 THEN
            /*:T--- Seta Constraints para o DBO Table1 ---*/
            RUN setConstraint6 IN {&hDBOTable1} (INPUT INPUT FRAME fPage1 i-cod-rep-ini,
                                                 INPUT INPUT FRAME fPage1 i-cod-rep-fim).
        
        WHEN 2 THEN
            /*:T--- Seta Constraints para o DBO Table2 ---*/
            RUN setConstraint7 IN {&hDBOTable2} (INPUT INPUT FRAME fPage2 c-nome-abrev-ini,
                                                 INPUT INPUT FRAME fPage2 c-nome-abrev-fim).
        WHEN 3 THEN
            /*:T--- Seta Constraints para o DBO Table3 ---*/
            RUN setConstraint8 IN {&hDBOTable3} (INPUT INPUT FRAME fPage3 c-cgc-ini,
                                                 INPUT INPUT FRAME fPage3 c-cgc-fim).
    END CASE.
    
    /*:T--- Seta vari vel iConstraintPageNumber com o n£mero da p gina atual 
          Esta vari vel ‚ utilizada no m‚todo openQueries ---*/
    ASSIGN iConstraintPageNumber = pPageNumber.
    
    /*:T--- Atualiza browse ---*/
    RUN openQueries IN THIS-PROCEDURE.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCnpj wZoom 
FUNCTION fnCnpj RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    ASSIGN c-cnpj = IF tt-repres.natureza = 2 THEN 
                        STRING(tt-repres.cgc,c-form2)
                    ELSE
                        STRING(tt-repres.cgc,c-form1).

    RETURN c-cnpj.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCnpj1 wZoom 
FUNCTION fnCnpj1 RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    ASSIGN c-cnpj-1 = IF tt-repres-1.natureza = 2 THEN 
                        STRING(tt-repres-1.cgc,c-form2)
                      ELSE
                        STRING(tt-repres-1.cgc,c-form1).

    RETURN c-cnpj-1.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCnpj2 wZoom 
FUNCTION fnCnpj2 RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    ASSIGN c-cnpj-2 = IF tt-repres-2.natureza = 2 THEN 
                        STRING(tt-repres-2.cgc,c-form2)
                      ELSE
                        STRING(tt-repres-2.cgc,c-form1).

    RETURN c-cnpj-2.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnIdentIntermed wZoom 
FUNCTION fnIdentIntermed RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    ASSIGN c-ident-intermed = &IF '{&product_version}' >= '12.1.W' &THEN 
                                    STRING(tt-repres.nom-usuar-interm)
                              &ELSE
                                    TRIM(SUBSTRING(tt-repres.char-1,13,60))
                              &ENDIF.

    RETURN c-ident-intermed.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnIdentIntermed1 wZoom 
FUNCTION fnIdentIntermed1 RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    ASSIGN c-ident-intermed-1 = &IF '{&product_version}' >= '12.1.W' &THEN
                                    STRING(tt-repres-1.nom-usuar-interm)
                              &ELSE
                                    TRIM(SUBSTRING(tt-repres-1.char-1,13,60))
                              &ENDIF.

    RETURN c-ident-intermed-1.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnIdentIntermed2 wZoom 
FUNCTION fnIdentIntermed2 RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    ASSIGN c-ident-intermed-2 = &IF '{&product_version}' >= '12.1.W' &THEN
                                    STRING(tt-repres-2.nom-usuar-interm)
                              &ELSE
                                    TRIM(SUBSTRING(tt-repres-2.char-1,13,60))
                              &ENDIF.

    RETURN c-ident-intermed-2.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNatureza wZoom 
FUNCTION fnNatureza RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    ASSIGN c-natureza = {adinc/i03ad098.i 04 tt-repres.natureza}.

    RETURN c-natureza.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNatureza1 wZoom 
FUNCTION fnNatureza1 RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    ASSIGN c-natureza-1 = {adinc/i03ad098.i 04 tt-repres-1.natureza}.

    RETURN c-natureza-1.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNatureza2 wZoom 
FUNCTION fnNatureza2 RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    ASSIGN c-natureza-2 = {adinc/i03ad098.i 04 tt-repres-2.natureza}.

    RETURN c-natureza-2.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

