&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-siscomex-acres-deduc NO-UNDO LIKE siscomex-acres-deduc
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-siscomex-inst-financ NO-UNDO LIKE siscomex-inst-financ
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0003 2.00.00.001}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM003 MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0003
&GLOBAL-DEFINE Version        2.00.00.040

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   A.D.V.A.,I.F., M.V.A.,M.I.S.C.C., T.D.

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp
                              
&GLOBAL-DEFINE page1Widgets   brAcresDeduc
&GLOBAL-DEFINE page2Widgets   brInstFinanc
&GLOBAL-DEFINE page3Widgets   brMetValAd
&GLOBAL-DEFINE page4Widgets   brMotSemCob
&GLOBAL-DEFINE page5Widgets   brTipoDocto

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brAcresDeduc

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES siscomex-acres-deduc siscomex-inst-financ ~
siscomex-metodo-val siscomex-motivo-sem-cob siscomex-tipo-docto

/* Definitions for BROWSE brAcresDeduc                                  */
&Scoped-define FIELDS-IN-QUERY-brAcresDeduc siscomex-acres-deduc.codigo ~
siscomex-acres-deduc.descricao siscomex-acres-deduc.id-tipo ~
siscomex-acres-deduc.ini-vigencia siscomex-acres-deduc.fim-vigencia 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brAcresDeduc 
&Scoped-define QUERY-STRING-brAcresDeduc FOR EACH siscomex-acres-deduc NO-LOCK ~
    BY siscomex-acres-deduc.codigo INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brAcresDeduc OPEN QUERY brAcresDeduc FOR EACH siscomex-acres-deduc NO-LOCK ~
    BY siscomex-acres-deduc.codigo INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brAcresDeduc siscomex-acres-deduc
&Scoped-define FIRST-TABLE-IN-QUERY-brAcresDeduc siscomex-acres-deduc


/* Definitions for BROWSE brInstFinanc                                  */
&Scoped-define FIELDS-IN-QUERY-brInstFinanc siscomex-inst-financ.codigo ~
siscomex-inst-financ.descricao siscomex-inst-financ.ini-vigencia ~
siscomex-inst-financ.fim-vigencia 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brInstFinanc 
&Scoped-define QUERY-STRING-brInstFinanc FOR EACH siscomex-inst-financ NO-LOCK ~
    BY siscomex-inst-financ.codigo INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brInstFinanc OPEN QUERY brInstFinanc FOR EACH siscomex-inst-financ NO-LOCK ~
    BY siscomex-inst-financ.codigo INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brInstFinanc siscomex-inst-financ
&Scoped-define FIRST-TABLE-IN-QUERY-brInstFinanc siscomex-inst-financ


/* Definitions for BROWSE brMetValAd                                    */
&Scoped-define FIELDS-IN-QUERY-brMetValAd siscomex-metodo-val.cod-met-val ~
siscomex-metodo-val.descricao siscomex-metodo-val.ini-vigencia ~
siscomex-metodo-val.fim-vigencia 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brMetValAd 
&Scoped-define QUERY-STRING-brMetValAd FOR EACH siscomex-metodo-val NO-LOCK ~
    BY siscomex-metodo-val.cod-met-val INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brMetValAd OPEN QUERY brMetValAd FOR EACH siscomex-metodo-val NO-LOCK ~
    BY siscomex-metodo-val.cod-met-val INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brMetValAd siscomex-metodo-val
&Scoped-define FIRST-TABLE-IN-QUERY-brMetValAd siscomex-metodo-val


/* Definitions for BROWSE brMotSemCob                                   */
&Scoped-define FIELDS-IN-QUERY-brMotSemCob siscomex-motivo-sem-cob.codigo ~
siscomex-motivo-sem-cob.descricao siscomex-motivo-sem-cob.ini-vigencia ~
siscomex-motivo-sem-cob.fim-vigencia 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brMotSemCob 
&Scoped-define QUERY-STRING-brMotSemCob FOR EACH siscomex-motivo-sem-cob NO-LOCK ~
    BY siscomex-motivo-sem-cob.codigo INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brMotSemCob OPEN QUERY brMotSemCob FOR EACH siscomex-motivo-sem-cob NO-LOCK ~
    BY siscomex-motivo-sem-cob.codigo INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brMotSemCob siscomex-motivo-sem-cob
&Scoped-define FIRST-TABLE-IN-QUERY-brMotSemCob siscomex-motivo-sem-cob


/* Definitions for BROWSE brTipoDocto                                   */
&Scoped-define FIELDS-IN-QUERY-brTipoDocto ~
siscomex-tipo-docto.cod-tipo-docto siscomex-tipo-docto.descricao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTipoDocto 
&Scoped-define QUERY-STRING-brTipoDocto FOR EACH siscomex-tipo-docto NO-LOCK ~
    BY siscomex-tipo-docto.cod-tipo-docto INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brTipoDocto OPEN QUERY brTipoDocto FOR EACH siscomex-tipo-docto NO-LOCK ~
    BY siscomex-tipo-docto.cod-tipo-docto INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brTipoDocto siscomex-tipo-docto
&Scoped-define FIRST-TABLE-IN-QUERY-brTipoDocto siscomex-tipo-docto


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brAcresDeduc}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brInstFinanc}

/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brMetValAd}

/* Definitions for FRAME fPage4                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage4 ~
    ~{&OPEN-QUERY-brMotSemCob}

/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-brTipoDocto}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar btQueryJoins ~
btReportsJoins btExit btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brAcresDeduc FOR 
      siscomex-acres-deduc SCROLLING.

DEFINE QUERY brInstFinanc FOR 
      siscomex-inst-financ SCROLLING.

DEFINE QUERY brMetValAd FOR 
      siscomex-metodo-val SCROLLING.

DEFINE QUERY brMotSemCob FOR 
      siscomex-motivo-sem-cob SCROLLING.

DEFINE QUERY brTipoDocto FOR 
      siscomex-tipo-docto SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brAcresDeduc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brAcresDeduc wWindow _STRUCTURED
  QUERY brAcresDeduc NO-LOCK DISPLAY
      siscomex-acres-deduc.codigo FORMAT ">9":U
      siscomex-acres-deduc.descricao FORMAT "x(60)":U
      siscomex-acres-deduc.id-tipo FORMAT ">9":U
      siscomex-acres-deduc.ini-vigencia FORMAT "99/99/9999":U
      siscomex-acres-deduc.fim-vigencia FORMAT "99/99/9999":U WIDTH 15.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE brInstFinanc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brInstFinanc wWindow _STRUCTURED
  QUERY brInstFinanc NO-LOCK DISPLAY
      siscomex-inst-financ.codigo FORMAT ">>9":U
      siscomex-inst-financ.descricao FORMAT "x(120)":U
      siscomex-inst-financ.ini-vigencia FORMAT "99/99/9999":U
      siscomex-inst-financ.fim-vigencia FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE brMetValAd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brMetValAd wWindow _STRUCTURED
  QUERY brMetValAd NO-LOCK DISPLAY
      siscomex-metodo-val.cod-met-val FORMAT ">>>>9":U
      siscomex-metodo-val.descricao FORMAT "x(60)":U
      siscomex-metodo-val.ini-vigencia FORMAT "99/99/9999":U
      siscomex-metodo-val.fim-vigencia FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE brMotSemCob
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brMotSemCob wWindow _STRUCTURED
  QUERY brMotSemCob NO-LOCK DISPLAY
      siscomex-motivo-sem-cob.codigo COLUMN-LABEL "C¢digo" FORMAT ">>>>9":U
      siscomex-motivo-sem-cob.descricao FORMAT "x(90)":U
      siscomex-motivo-sem-cob.ini-vigencia FORMAT "99/99/9999":U
      siscomex-motivo-sem-cob.fim-vigencia FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE brTipoDocto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTipoDocto wWindow _STRUCTURED
  QUERY brTipoDocto NO-LOCK DISPLAY
      siscomex-tipo-docto.cod-tipo-docto FORMAT ">>>>>>>9":U
      siscomex-tipo-docto.descricao FORMAT "x(90)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 16 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.46
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage5
     brTipoDocto AT ROW 2.54 COL 2.14 WIDGET-ID 700
     "Tipo Documento" VIEW-AS TEXT
          SIZE 15.86 BY .54 AT ROW 1.42 COL 2.14 WIDGET-ID 2
          FONT 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1 WIDGET-ID 800.

DEFINE FRAME fPage4
     brMotSemCob AT ROW 2.54 COL 2.14 WIDGET-ID 700
     "Motivo Importa‡Æo sem Cobran‡a Cambial" VIEW-AS TEXT
          SIZE 36.72 BY .54 AT ROW 1.42 COL 2.14 WIDGET-ID 2
          FONT 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1 WIDGET-ID 600.

DEFINE FRAME fPage3
     brMetValAd AT ROW 2.54 COL 2.14 WIDGET-ID 500
     "M‚todo Valora‡Æo Aduaneira" VIEW-AS TEXT
          SIZE 25.72 BY .54 AT ROW 1.42 COL 2.14 WIDGET-ID 2
          FONT 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1 WIDGET-ID 400.

DEFINE FRAME fPage2
     brInstFinanc AT ROW 2.54 COL 2.14 WIDGET-ID 300
     "Institui‡Æo Financiadora" VIEW-AS TEXT
          SIZE 20.43 BY .54 AT ROW 1.42 COL 2.14 WIDGET-ID 2
          FONT 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brAcresDeduc AT ROW 2.54 COL 2.14 WIDGET-ID 200
     "Acr‚scimo / Dedu‡Æo Valora‡Æo Aduaneira" VIEW-AS TEXT
          SIZE 36 BY .54 AT ROW 1.42 COL 2.14 WIDGET-ID 2
          FONT 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-siscomex-acres-deduc T "?" NO-UNDO mgcex siscomex-acres-deduc
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-siscomex-inst-financ T "?" NO-UNDO mgcex siscomex-inst-financ
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.46
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brAcresDeduc TEXT-1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brInstFinanc TEXT-2 fPage2 */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brMetValAd TEXT-3 fPage3 */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* BROWSE-TAB brMotSemCob TEXT-4 fPage4 */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brTipoDocto TEXT-5 fPage5 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brAcresDeduc
/* Query rebuild information for BROWSE brAcresDeduc
     _TblList          = "mgcex.siscomex-acres-deduc"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "mgcex.siscomex-acres-deduc.codigo|yes"
     _FldNameList[1]   = mgcex.siscomex-acres-deduc.codigo
     _FldNameList[2]   = mgcex.siscomex-acres-deduc.descricao
     _FldNameList[3]   = mgcex.siscomex-acres-deduc.id-tipo
     _FldNameList[4]   = mgcex.siscomex-acres-deduc.ini-vigencia
     _FldNameList[5]   > mgcex.siscomex-acres-deduc.fim-vigencia
"siscomex-acres-deduc.fim-vigencia" ? ? "date" ? ? ? ? ? ? no ? no no "15.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brAcresDeduc */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brInstFinanc
/* Query rebuild information for BROWSE brInstFinanc
     _TblList          = "mgcex.siscomex-inst-financ"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "mgcex.siscomex-inst-financ.codigo|yes"
     _FldNameList[1]   = mgcex.siscomex-inst-financ.codigo
     _FldNameList[2]   = mgcex.siscomex-inst-financ.descricao
     _FldNameList[3]   = mgcex.siscomex-inst-financ.ini-vigencia
     _FldNameList[4]   = mgcex.siscomex-inst-financ.fim-vigencia
     _Query            is OPENED
*/  /* BROWSE brInstFinanc */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brMetValAd
/* Query rebuild information for BROWSE brMetValAd
     _TblList          = "mgcex.siscomex-metodo-val"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "mgcex.siscomex-metodo-val.cod-met-val|yes"
     _FldNameList[1]   = mgcex.siscomex-metodo-val.cod-met-val
     _FldNameList[2]   = mgcex.siscomex-metodo-val.descricao
     _FldNameList[3]   = mgcex.siscomex-metodo-val.ini-vigencia
     _FldNameList[4]   = mgcex.siscomex-metodo-val.fim-vigencia
     _Query            is OPENED
*/  /* BROWSE brMetValAd */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brMotSemCob
/* Query rebuild information for BROWSE brMotSemCob
     _TblList          = "mgcex.siscomex-motivo-sem-cob"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "mgcex.siscomex-motivo-sem-cob.codigo|yes"
     _FldNameList[1]   > mgcex.siscomex-motivo-sem-cob.codigo
"siscomex-motivo-sem-cob.codigo" "C¢digo" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = mgcex.siscomex-motivo-sem-cob.descricao
     _FldNameList[3]   = mgcex.siscomex-motivo-sem-cob.ini-vigencia
     _FldNameList[4]   = mgcex.siscomex-motivo-sem-cob.fim-vigencia
     _Query            is OPENED
*/  /* BROWSE brMotSemCob */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTipoDocto
/* Query rebuild information for BROWSE brTipoDocto
     _TblList          = "mgcex.siscomex-tipo-docto"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "mgcex.siscomex-tipo-docto.cod-tipo-docto|yes"
     _FldNameList[1]   = mgcex.siscomex-tipo-docto.cod-tipo-docto
     _FldNameList[2]   = mgcex.siscomex-tipo-docto.descricao
     _Query            is OPENED
*/  /* BROWSE brTipoDocto */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage5
/* Query rebuild information for FRAME fPage5
     _Query            is NOT OPENED
*/  /* FRAME fPage5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
DO:
APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brAcresDeduc
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterChangepage wWindow 
PROCEDURE afterChangepage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iGetPage AS INTEGER     NO-UNDO.

    RUN GetCurrentFolder IN hFolder (OUTPUT iGetPage).
    
    CASE iGetPage:
        WHEN 1 THEN
            {&OPEN-QUERY-brAcresDeduc}
        WHEN 2 THEN
            {&OPEN-QUERY-brInstFinanc}
        WHEN 3 THEN
            {&OPEN-QUERY-brMetValAd}
        WHEN 4 THEN
            {&OPEN-QUERY-brMotSemCob}
        WHEN 5 THEN
            {&OPEN-QUERY-brTipoDocto}
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    {&OPEN-QUERY-brAcresDeduc}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

