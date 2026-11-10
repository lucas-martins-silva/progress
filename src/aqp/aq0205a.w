&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME wFormation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-produt-pto-coleta NO-UNDO LIKE produt-pto-coleta
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-produt-rural NO-UNDO LIKE produt-rural
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-propried-rural NO-UNDO LIKE propried-rural
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-pto-coleta NO-UNDO LIKE pto-coleta
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wFormation 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0205A 2.00.00.012 } /*** 010012 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0205A MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          AQ0205A
&GLOBAL-DEFINE Version        2.00.00.012

&GLOBAL-DEFINE DelTarget        NO
&GLOBAL-DEFINE AddTarget        NO
&GLOBAL-DEFINE DelAllTarget     NO
&GLOBAL-DEFINE AddAllTarget     NO

&GLOBAL-DEFINE UpdateTarget     NO

&GLOBAL-DEFINE ttParent         tt-pto-coleta
&GLOBAL-DEFINE hDBOParent       h-boin00966
&GLOBAL-DEFINE DBOParentTable   pto-coleta

&GLOBAL-DEFINE ttSource         tt-produt-rural
&GLOBAL-DEFINE hDBOSource       h-boin00962  
&GLOBAL-DEFINE DBOSourceTable   produt-rural   

&GLOBAL-DEFINE ttTarget         tt-propried-rural
&GLOBAL-DEFINE hDBOTarget       h-boin00984
&GLOBAL-DEFINE DBOTargetTable   propried-rural

&GLOBAL-DEFINE page0Fields      

&GLOBAL-DEFINE SourceBrowse      brSource
&GLOBAL-DEFINE TargetBrowse      brTarget

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO. 
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO. 

DEFINE VAR prTable  AS ROWID NO-UNDO.
DEFINE VAR pcAction AS CHAR  NO-UNDO.
DEFINE VARIABLE piSonPageNumber AS INTEGER    NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-boad098na       AS HANDLE                           NO-UNDO.
DEFINE VARIABLE h-boin00990       AS HANDLE                           NO-UNDO.
DEFINE VARIABLE h-boin00980aux    AS HANDLE                           NO-UNDO.
DEFINE VARIABLE h-boin00963       AS HANDLE                           NO-UNDO.
DEFINE VARIABLE ccod-emitente-src as char                             NO-UNDO.
DEFINE VARIABLE ccod-emitente-col as char                             NO-UNDO.
DEFINE VARIABLE c-cod-propried    as char                             NO-UNDO.
DEFINE VARIABLE cgrp-produt       AS CHAR                             NO-UNDO.
DEFINE VARIABLE c-pto-coleta      LIKE tt-pto-coleta.cod-pto-coleta   NO-UNDO.
DEFINE VARIABLE c-desc-pto-coleta LIKE tt-pto-coleta.cod-pto-coleta   NO-UNDO.

DEFINE VARIABLE p-cod-produt-rural-ini LIKE produt-rural.cdn-produt-rural                   NO-UNDO.
DEFINE VARIABLE p-cod-produt-rural-fim LIKE produt-rural.cdn-produt-rural INITIAL 999999999 NO-UNDO.
DEFINE VARIABLE p-cod-grp-produt-ini   LIKE grp-produt.cdn-grp-produt                       NO-UNDO.
DEFINE VARIABLE p-cod-grp-produt-fim   LIKE grp-produt.cdn-grp-produt     INITIAL 999999    NO-UNDO.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSource} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTarget} AS HANDLE NO-UNDO.

DEFINE BUFFER bftt-produt-pto-coleta-aux FOR tt-produt-pto-coleta.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Formation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brPtoColeta

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-produt-pto-coleta tt-produt-rural ~
tt-propried-rural

/* Definitions for BROWSE brPtoColeta                                   */
&Scoped-define FIELDS-IN-QUERY-brPtoColeta ~
tt-produt-pto-coleta.cdn-produt-rural ~
fnEmitente(input tt-produt-pto-coleta.cdn-produt-rural) @ ccod-emitente-col ~
tt-produt-pto-coleta.cod-propried ~
fnPropriedade(tt-produt-pto-coleta.cod-propried) @ c-cod-propried ~
tt-produt-pto-coleta.cod-pto-coleta tt-produt-pto-coleta.cod-externo ~
tt-produt-pto-coleta.log-respons 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brPtoColeta ~
tt-produt-pto-coleta.cod-externo 
&Scoped-define ENABLED-TABLES-IN-QUERY-brPtoColeta tt-produt-pto-coleta
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brPtoColeta tt-produt-pto-coleta
&Scoped-define QUERY-STRING-brPtoColeta FOR EACH tt-produt-pto-coleta NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brPtoColeta OPEN QUERY brPtoColeta FOR EACH tt-produt-pto-coleta NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brPtoColeta tt-produt-pto-coleta
&Scoped-define FIRST-TABLE-IN-QUERY-brPtoColeta tt-produt-pto-coleta


/* Definitions for BROWSE brSource                                      */
&Scoped-define FIELDS-IN-QUERY-brSource tt-produt-rural.cdn-produt-rural ~
fnEmitente(input tt-produt-rural.cdn-produt-rural) @ ccod-emitente-src ~
tt-produt-rural.cdn-grp-produt ~
fnGrpProdut(input tt-produt-rural.cdn-grp-produt) @ cgrp-produt 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSource 
&Scoped-define QUERY-STRING-brSource FOR EACH tt-produt-rural NO-LOCK
&Scoped-define OPEN-QUERY-brSource OPEN QUERY brSource FOR EACH tt-produt-rural NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSource tt-produt-rural
&Scoped-define FIRST-TABLE-IN-QUERY-brSource tt-produt-rural


/* Definitions for BROWSE brTarget                                      */
&Scoped-define FIELDS-IN-QUERY-brTarget tt-propried-rural.cod-propried ~
tt-propried-rural.des-propried 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTarget 
&Scoped-define QUERY-STRING-brTarget FOR EACH tt-propried-rural NO-LOCK
&Scoped-define OPEN-QUERY-brTarget OPEN QUERY brTarget FOR EACH tt-propried-rural NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTarget tt-propried-rural
&Scoped-define FIRST-TABLE-IN-QUERY-brTarget tt-propried-rural


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brPtoColeta}~
    ~{&OPEN-QUERY-brSource}~
    ~{&OPEN-QUERY-brTarget}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-pto-coleta.cod-pto-coleta ~
tt-pto-coleta.des-pto-coleta 
&Scoped-define ENABLED-TABLES tt-pto-coleta
&Scoped-define FIRST-ENABLED-TABLE tt-pto-coleta
&Scoped-Define ENABLED-OBJECTS rtParent RECT-2 RECT-1 btOk btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-pto-coleta.cod-pto-coleta ~
tt-pto-coleta.des-pto-coleta 
&Scoped-define DISPLAYED-TABLES tt-pto-coleta
&Scoped-define FIRST-DISPLAYED-TABLE tt-pto-coleta


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEmitente wFormation 
FUNCTION fnEmitente RETURNS CHARACTER
  ( input ccod-emitente as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnGrpProdut wFormation 
FUNCTION fnGrpProdut RETURNS CHARACTER
  ( input icodGrpProdut as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPropriedade wFormation 
FUNCTION fnPropriedade RETURNS CHARACTER
  ( input ccod-propried as CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wFormation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOk AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 127.57 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 127 BY 20.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 127 BY 2.25.

DEFINE BUTTON btAddTarget 
     IMAGE-UP FILE "image/im-abx1.bmp":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Inclui".

DEFINE BUTTON btDelTarget 
     IMAGE-UP FILE "image/im-acm1.bmp":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Elimina".

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image\im-ran":U
     LABEL "" 
     SIZE 5.57 BY 1.25 TOOLTIP "Filtro".

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brPtoColeta FOR 
      tt-produt-pto-coleta SCROLLING.

DEFINE QUERY brSource FOR 
      tt-produt-rural SCROLLING.

DEFINE QUERY brTarget FOR 
      tt-propried-rural SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brPtoColeta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brPtoColeta wFormation _STRUCTURED
  QUERY brPtoColeta NO-LOCK DISPLAY
      tt-produt-pto-coleta.cdn-produt-rural FORMAT ">>>,>>>,>>9":U
            WIDTH 11.43
      fnEmitente(input tt-produt-pto-coleta.cdn-produt-rural) @ ccod-emitente-col COLUMN-LABEL "Nome" FORMAT "X(256)":U
            WIDTH 26.43
      tt-produt-pto-coleta.cod-propried FORMAT "x(16)":U WIDTH 15.57
      fnPropriedade(tt-produt-pto-coleta.cod-propried) @ c-cod-propried COLUMN-LABEL "Descri‡Æo" FORMAT "X(60)":U
            WIDTH 28
      tt-produt-pto-coleta.cod-pto-coleta FORMAT "x(12)":U WIDTH 12
      tt-produt-pto-coleta.cod-externo FORMAT "x(14)":U WIDTH 9
      tt-produt-pto-coleta.log-respons COLUMN-LABEL "Respons vel" FORMAT "Sim/NÆo":U
            WIDTH 10.43
  ENABLE
      tt-produt-pto-coleta.cod-externo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 120 BY 8
         FONT 2
         TITLE "Produtores x Pontos de Coleta x Propriedades".

DEFINE BROWSE brSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSource wFormation _STRUCTURED
  QUERY brSource NO-LOCK DISPLAY
      tt-produt-rural.cdn-produt-rural FORMAT ">>>,>>>,>>9":U WIDTH 14.43
      fnEmitente(input tt-produt-rural.cdn-produt-rural) @ ccod-emitente-src COLUMN-LABEL "Nome" FORMAT "X(30)":U
            WIDTH 33.43
      tt-produt-rural.cdn-grp-produt FORMAT ">>>>>9":U
      fnGrpProdut(input tt-produt-rural.cdn-grp-produt) @ cgrp-produt COLUMN-LABEL "Descri‡Æo" FORMAT "X(60)":U
            WIDTH 30
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 52 BY 8
         FONT 2
         TITLE "Produtores".

DEFINE BROWSE brTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTarget wFormation _STRUCTURED
  QUERY brTarget NO-LOCK DISPLAY
      tt-propried-rural.cod-propried FORMAT "x(16)":U WIDTH 16
      tt-propried-rural.des-propried FORMAT "x(60)":U WIDTH 36.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 52 BY 8
         FONT 2
         TITLE "Propriedades".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     tt-pto-coleta.cod-pto-coleta AT ROW 1.75 COL 33.43 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-pto-coleta.des-pto-coleta AT ROW 1.75 COL 46.86 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 51 BY .88
     btOk AT ROW 23.96 COL 2.43
     btCancel AT ROW 23.96 COL 13.43
     btHelp AT ROW 23.96 COL 117
     rtParent AT ROW 1.25 COL 1.57
     RECT-2 AT ROW 3.63 COL 1.57
     RECT-1 AT ROW 23.75 COL 1.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 128 BY 24.38
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brSource AT ROW 1 COL 2
     brTarget AT ROW 1 COL 68
     btFiltro AT ROW 9.08 COL 2
     btDelTarget AT ROW 9.75 COL 49
     btAddTarget AT ROW 9.75 COL 65.14
     brPtoColeta AT ROW 11.25 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.71
         SIZE 122.43 BY 18.79
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Formation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-produt-pto-coleta T "?" NO-UNDO mgind produt-pto-coleta
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-produt-rural T "?" NO-UNDO mgind produt-rural
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-propried-rural T "?" NO-UNDO mgind propried-rural
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-pto-coleta T "?" NO-UNDO mgind pto-coleta
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wFormation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 24.38
         WIDTH              = 128
         MAX-HEIGHT         = 320
         MAX-WIDTH          = 320
         VIRTUAL-HEIGHT     = 320
         VIRTUAL-WIDTH      = 320
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wFormation 
/* ************************* Included-Libraries *********************** */

{formationnonavigation/formationnonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wFormation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSource 1 fPage1 */
/* BROWSE-TAB brTarget brSource fPage1 */
/* BROWSE-TAB brPtoColeta btAddTarget fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wFormation)
THEN wFormation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brPtoColeta
/* Query rebuild information for BROWSE brPtoColeta
     _TblList          = "Temp-Tables.tt-produt-pto-coleta"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-produt-pto-coleta.cdn-produt-rural
"cdn-produt-rural" ? ? "integer" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fnEmitente(input tt-produt-pto-coleta.cdn-produt-rural) @ ccod-emitente-col" "Nome" "X(256)" ? ? ? ? ? ? ? no ? no no "26.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-produt-pto-coleta.cod-propried
"cod-propried" ? "x(16)" "character" ? ? ? ? ? ? no ? no no "15.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fnPropriedade(tt-produt-pto-coleta.cod-propried) @ c-cod-propried" "Descri‡Æo" "X(60)" ? ? ? ? ? ? ? no ? no no "28" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-produt-pto-coleta.cod-pto-coleta
"cod-pto-coleta" ? ? "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-produt-pto-coleta.cod-externo
"cod-externo" ? ? "character" ? ? ? ? ? ? yes ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-produt-pto-coleta.log-respons
"log-respons" "Respons vel" ? "logical" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brPtoColeta */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSource
/* Query rebuild information for BROWSE brSource
     _TblList          = "Temp-Tables.tt-produt-rural"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-produt-rural.cdn-produt-rural
"tt-produt-rural.cdn-produt-rural" ? ? "integer" ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fnEmitente(input tt-produt-rural.cdn-produt-rural) @ ccod-emitente-src" "Nome" "X(30)" ? ? ? ? ? ? ? no ? no no "33.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.tt-produt-rural.cdn-grp-produt
     _FldNameList[4]   > "_<CALC>"
"fnGrpProdut(input tt-produt-rural.cdn-grp-produt) @ cgrp-produt" "Descri‡Æo" "X(60)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSource */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTarget
/* Query rebuild information for BROWSE brTarget
     _TblList          = "Temp-Tables.tt-propried-rural"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-propried-rural.cod-propried
"tt-propried-rural.cod-propried" ? ? "character" ? ? ? ? ? ? no ? no no "16" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-propried-rural.des-propried
"tt-propried-rural.des-propried" ? ? "character" ? ? ? ? ? ? no ? no no "36.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brTarget */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wFormation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wFormation wFormation
ON END-ERROR OF wFormation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wFormation wFormation
ON WINDOW-CLOSE OF wFormation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brPtoColeta
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brPtoColeta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPtoColeta wFormation
ON MOUSE-SELECT-DBLCLICK OF brPtoColeta IN FRAME fPage1 /* Produtores x Pontos de Coleta x Propriedades */
DO:

  IF AVAIL tt-produt-pto-coleta THEN DO:

      ASSIGN tt-produt-pto-coleta.log-respons = NOT tt-produt-pto-coleta.log-respons.
      {&OPEN-QUERY-brPtoColeta}

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPtoColeta wFormation
ON VALUE-CHANGED OF brPtoColeta IN FRAME fPage1 /* Produtores x Pontos de Coleta x Propriedades */
DO:
  IF BROWSE brPtoColeta:NUM-SELECTED-ROWS > 0 THEN 
       ASSIGN btDelTarget:SENSITIVE IN FRAME fpage1 = YES.
  ELSE
      ASSIGN btDelTarget:SENSITIVE IN FRAME fpage1 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSource
&Scoped-define SELF-NAME brSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSource wFormation
ON VALUE-CHANGED OF brSource IN FRAME fPage1 /* Produtores */
DO:
    IF brSource:NUM-SELECTED-ROWS IN FRAME fPage1 > 0 THEN DO:
        GET CURRENT brSource.
        RUN getAllPropriedRural IN {&hDBOTarget} (INPUT tt-produt-rural.cdn-produt-rural,
                                                  OUTPUT TABLE {&ttTarget}).
        {&OPEN-QUERY-brTarget} 
    END.

    APPLY "VALUE-CHANGED" TO BROWSE brTarget.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brTarget
&Scoped-define SELF-NAME brTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTarget wFormation
ON VALUE-CHANGED OF brTarget IN FRAME fPage1 /* Propriedades */
DO:
  IF BROWSE brSource:NUM-SELECTED-ROWS > 0 AND
     BROWSE brTarget:NUM-SELECTED-ROWS > 0 THEN DO:
      
      APPLY "VALUE-CHANGED" TO BROWSE brPtoColeta.

      ASSIGN btAddTarget:SENSITIVE IN FRAME fpage1 = YES.

  END.
  ELSE
      ASSIGN btAddTarget:SENSITIVE IN FRAME fpage1 = NO.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddTarget wFormation
ON CHOOSE OF btAddTarget IN FRAME fPage1
DO:
   
   IF BROWSE brSource:NUM-SELECTED-ROWS = 0 THEN 
       RETURN NO-APPLY.

   brSource:FETCH-SELECTED-ROW(1).
   GET CURRENT brSource.

   IF BROWSE brTarget:NUM-SELECTED-ROWS = 0 THEN 
       RETURN NO-APPLY.

   brTarget:FETCH-SELECTED-ROW(1).
   GET CURRENT brTarget.

   IF NOT CAN-FIND(FIRST bftt-produt-pto-coleta-aux 
                   WHERE bftt-produt-pto-coleta-aux.cdn-produt-rural = tt-produt-rural.cdn-produt-rural
                     AND bftt-produt-pto-coleta-aux.cod-propried     = tt-propried-rural.cod-propried  
                     AND bftt-produt-pto-coleta-aux.cod-pto-coleta   = tt-pto-coleta.cod-pto-coleta) THEN DO:
   
       CREATE tt-produt-pto-coleta.
       ASSIGN tt-produt-pto-coleta.cdn-produt-rural = tt-produt-rural.cdn-produt-rural
              tt-produt-pto-coleta.cod-propried     = tt-propried-rural.cod-propried
              tt-produt-pto-coleta.cod-pto-coleta   = tt-pto-coleta.cod-pto-coleta
              tt-produt-pto-coleta.cod-externo      = replace(replace(string(next-value(seq-cod-ext)), ".", ""), ",", "")
              tt-produt-pto-coleta.log-respons      = NO.
    
       {&OPEN-QUERY-brPtoColeta}

       ASSIGN btDelTarget:SENSITIVE IN FRAME fpage1 = YES. 

   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wFormation
ON CHOOSE OF btCancel IN FRAME fPage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDelTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelTarget wFormation
ON CHOOSE OF btDelTarget IN FRAME fPage1
DO:

   IF BROWSE brPtoColeta:NUM-SELECTED-ROWS = 0 THEN 
       RETURN NO-APPLY.

   brPtoColeta:FETCH-SELECTED-ROW(1).
   GET CURRENT brPtoColeta.

   DELETE tt-produt-pto-coleta.
   
   {&OPEN-QUERY-brPtoColeta}

   IF BROWSE brPtoColeta:NUM-SELECTED-ROWS = 0 THEN 
       ASSIGN btDelTarget:SENSITIVE IN FRAME fpage1 = NO.
  
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro wFormation
ON CHOOSE OF btFiltro IN FRAME fPage1
DO:
    RUN aqp/aq0205b.w (INPUT-OUTPUT p-cod-produt-rural-ini,
                       INPUT-OUTPUT p-cod-produt-rural-fim, 
                       INPUT-OUTPUT p-cod-grp-produt-ini,   
                       INPUT-OUTPUT p-cod-grp-produt-fim).

    RUN setConstraintFiltro IN h-boin00962(p-cod-produt-rural-ini,
                                           p-cod-produt-rural-fim,
                                           p-cod-grp-produt-ini,  
                                           p-cod-grp-produt-fim). 

    RUN openQueryFiltro IN h-boin00962 (OUTPUT TABLE tt-produt-rural).

    OPEN QUERY brSource
      FOR EACH tt-produt-rural NO-LOCK.
    
    RETURN "OK":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wFormation
ON CHOOSE OF btHelp IN FRAME fPage0 /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOk wFormation
ON CHOOSE OF btOk IN FRAME fPage0 /* OK */
DO:
    
    RUN criaProdutPtoColeta IN h-boin00990 (INPUT TABLE tt-produt-pto-coleta,
                                            OUTPUT TABLE RowErrors).
    IF CAN-FIND(FIRST RowErrors
                WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:            
        {method/showmessage.i1}
        {method/showmessage.i2}
        RETURN NO-APPLY.
    END.
    ELSE
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brPtoColeta
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wFormation 


/* ***************************  Main Block  *************************** */

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{formationnonavigation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestoyInterface wFormation 
PROCEDURE afterDestoyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-boad098na) THEN DO:
       DELETE PROCEDURE h-boad098na.
       ASSIGN h-boad098na = ?.
    END.

    IF VALID-HANDLE(h-boin00980aux) THEN DO:
       DELETE PROCEDURE h-boin00980aux.
       ASSIGN h-boin00980aux = ?.
    END.

    IF VALID-HANDLE(h-boin00990) THEN DO:
       DELETE PROCEDURE h-boin00990.
       ASSIGN h-boin00990 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wFormation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

      RUN repositionRecord IN {&hDBOParent} (INPUT prParent).
      
      RUN getCharField     IN {&hDBOParent} (input "cod-pto-coleta":U, output c-pto-coleta).
      RUN getCharField     IN {&hDBOParent} (input "des-pto-coleta":U, output c-desc-pto-coleta).

      ASSIGN tt-pto-coleta.cod-pto-coleta:SCREEN-VALUE IN FRAME fpage0 = c-pto-coleta
             tt-pto-coleta.des-pto-coleta:SCREEN-VALUE IN FRAME fpage0 = c-desc-pto-coleta.

      APPLY "VALUE-CHANGED" TO BROWSE brSource.
      APPLY "VALUE-CHANGED" TO BROWSE brTarget.

      ENABLE brPtoColeta btFiltro WITH FRAME fpage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wFormation 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO da tabela Pai j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "inbo/boin00966.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00966.p YES}
        {btb/btb008za.i2 inbo/boin00966.p '' {&hDBOParent}} 
    END.
    
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U).
    
    /*:T--- Verifica se o DBO da tabela Origem j  est  inicializado ---*/
    
    IF NOT VALID-HANDLE({&hDBOSource}) OR
       {&hDBOSource}:TYPE <> "PROCEDURE":U OR
       {&hDBOSource}:FILE-NAME <> "inbo/boin00962.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00962.p YES}
        {btb/btb008za.i2 inbo/boin00962.p '' {&hDBOSource}} 
    END.
                
    /*:T--- Verifica se o DBO da tabela Forma‡Æo j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTarget}) OR
       {&hDBOTarget}:TYPE <> "PROCEDURE":U OR
       {&hDBOTarget}:FILE-NAME <> "inbo/boin00980.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00980.p YES}
        {btb/btb008za.i2 inbo/boin00980.p '' {&hDBOTarget}} 
    END.    

    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-boad098na) THEN DO:
        {btb/btb008za.i1 adbo/boad098na.p}
        {btb/btb008za.i2 adbo/boad098na.p '' h-boad098na} 
    END.
    RUN openQueryStatic IN h-boad098na (INPUT "Main":U).

    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00980aux) THEN DO:
        {btb/btb008za.i1 inbo/boin00980.p}
        {btb/btb008za.i2 inbo/boin00980.p '' h-boin00980aux} 
    END.
    RUN openQueryStatic IN h-boin00980aux (INPUT "Main":U).

    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00990) THEN DO:
        {btb/btb008za.i1 inbo/boin00990.p}
        {btb/btb008za.i2 inbo/boin00990.p '' h-boin00990} 
    END.

    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00963) THEN DO:
        {btb/btb008za.i1 inbo/boin00963.p}
        {btb/btb008za.i2 inbo/boin00963.p '' h-boin00963} 
    END.
    RUN openQueryStatic IN h-boin00963 (INPUT "Main":U).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueries wFormation 
PROCEDURE openQueries :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers 
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*abre browse de produtores*/
    RUN getAllTableProdutorRural IN {&hDBOSource} (OUTPUT TABLE tt-produt-rural).
    {&OPEN-QUERY-brSource}   
    
    /*abre browse coletivo*/
    RUN setConstraintPtoColPropried IN h-boin00990 (INPUT tt-pto-coleta.cod-pto-coleta).
    RUN openQueryPtoColPropried IN h-boin00990 (OUTPUT TABLE tt-produt-pto-coleta).
    {&OPEN-QUERY-brPtoColeta}
    
    APPLY "VALUE-CHANGED" TO BROWSE brPtoColeta.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wFormation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela forma‡Æo ({&ttTarget}) com base 
               nos campos da tabela pai ({&ttParent}) e tabela origem ({&ttSource})
  Parameters:  
------------------------------------------------------------------------------*/
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEmitente wFormation 
FUNCTION fnEmitente RETURNS CHARACTER
  ( input ccod-emitente as integer ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var cnome-abrev as char no-undo.

  RUN GotoKey in h-boad098na (input ccod-emitente).

  RUN GetCharField in h-boad098na (input "nome-abrev", output cnome-abrev).

  RETURN cnome-abrev.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnGrpProdut wFormation 
FUNCTION fnGrpProdut RETURNS CHARACTER
  ( input icodGrpProdut as integer ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  def var cnome-grupo as char no-undo.

  RUN GotoKey in h-boin00963 (input icodGrpProdut).

  RUN GetCharField in h-boin00963 (input "des-grp-produt", output cnome-grupo).

  RETURN cnome-grupo.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPropriedade wFormation 
FUNCTION fnPropriedade RETURNS CHARACTER
  ( input ccod-propried as CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var cpropriedade as char no-undo.

  RUN GotoKey in h-boin00980aux (input ccod-propried).

  RUN GetCharField in h-boin00980aux (input "des-propried", output cpropriedade).

  RETURN cpropriedade.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

