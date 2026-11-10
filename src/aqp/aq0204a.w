&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME wFormation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-pto-coleta NO-UNDO LIKE pto-coleta
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-pto-rota-coleta NO-UNDO LIKE pto-rota-coleta
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-rota-coleta NO-UNDO LIKE rota-coleta
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
{include/i-prgvrs.i AQ0204A 2.00.00.011 } /*** 010011 ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0204A MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          AQ0204A
&GLOBAL-DEFINE Version        2.00.00.011

&GLOBAL-DEFINE First            NO
&GLOBAL-DEFINE Prev             NO
&GLOBAL-DEFINE Next             NO
&GLOBAL-DEFINE Last             NO
&GLOBAL-DEFINE GoTo             NO
&GLOBAL-DEFINE Search           NO

&GLOBAL-DEFINE DelTarget        NO
&GLOBAL-DEFINE AddTarget        NO
&GLOBAL-DEFINE DelAllTarget     NO
&GLOBAL-DEFINE AddAllTarget     NO

&GLOBAL-DEFINE UpdateTarget     NO

&GLOBAL-DEFINE ttParent         tt-rota-coleta
&GLOBAL-DEFINE hDBOParent       h-boin00975
&GLOBAL-DEFINE DBOParentTable   rota-coleta

&GLOBAL-DEFINE ttSource         tt-pto-coleta
&GLOBAL-DEFINE hDBOSource       h-boin00966
&GLOBAL-DEFINE DBOSourceTable   pto-coleta

&GLOBAL-DEFINE ttTarget         tt-pto-rota-coleta
&GLOBAL-DEFINE hDBOTarget       h-boin00976
&GLOBAL-DEFINE DBOTargetTable   pto-rota-coleta

&GLOBAL-DEFINE page0Fields      

&GLOBAL-DEFINE SourceBrowse     brSource
&GLOBAL-DEFINE TargetBrowse     brTarget

/* Parameters Definitions ---                                           */
DEF INPUT PARAM pc-i-cod-rota   LIKE rota-coleta.cod-rota NO-UNDO.

/* Local Variable Definitions ---                                       */
def VARIABLE c-cod-filtro-ini like pto-coleta.cod-pto-coleta                                                     no-undo.
def VARIABLE c-cod-filtro-fim like pto-coleta.cod-pto-coleta  INITIAL "ZZZZZZZZZZZZ"                             no-undo.   
def VARIABLE c-des-filtro-ini like pto-coleta.des-pto-coleta                                                     no-undo.
def VARIABLE c-des-filtro-fim like pto-coleta.des-pto-coleta  INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" no-undo.
def VARIABLE i-cod-regiao-ini LIKE regiao-abrangen.cod-regiao                                                    NO-UNDO.
def VARIABLE i-cod-regiao-fim LIKE regiao-abrangen.cod-regiao INITIAL "ZZZZZZZZZZZZ"                             NO-UNDO.
def VARIABLE c-regiao         LIKE regiao-abrangen.cod-regiao                                                    NO-UNDO.

DEF VARIABLE c-desc-pto-coleta-tgt                AS CHAR NO-UNDO.
DEF VARIABLE l-filtro                             AS LOG  NO-UNDO.
DEFINE VARIABLE c-lbl-liter-movimentacao-invalida AS CHARACTER NO-UNDO.




/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSource}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTarget}   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00976-seq AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00977     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00966-aux AS HANDLE NO-UNDO.

DEFINE BUFFER bf{&ttTarget}    FOR {&ttTarget}.
DEFINE BUFFER bf{&ttSource}    FOR {&ttSource}.
DEFINE BUFFER bfaux{&ttTarget} FOR {&ttTarget}.

DEFINE TEMP-TABLE tt-pto-coleta-aux        NO-UNDO 
    LIKE tt-pto-coleta.
DEFINE TEMP-TABLE tt-pto-rota-coleta-aux   NO-UNDO 
    LIKE tt-pto-rota-coleta.
DEFINE TEMP-TABLE tt-pto-rota-coleta-atual NO-UNDO 
    LIKE tt-pto-rota-coleta.

DEFINE TEMP-TABLE RowErrors-aux NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Formation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSource

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-pto-coleta tt-pto-rota-coleta

/* Definitions for BROWSE brSource                                      */
&Scoped-define FIELDS-IN-QUERY-brSource tt-pto-coleta.cod-pto-coleta ~
tt-pto-coleta.des-pto-coleta tt-pto-coleta.cod-regiao ~
fnRegiao(input tt-pto-coleta.cod-regiao) @ c-regiao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSource 
&Scoped-define QUERY-STRING-brSource FOR EACH tt-pto-coleta WHERE tt-pto-coleta.log-livre-1 NO-LOCK
&Scoped-define OPEN-QUERY-brSource OPEN QUERY brSource FOR EACH tt-pto-coleta WHERE tt-pto-coleta.log-livre-1 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSource tt-pto-coleta
&Scoped-define FIRST-TABLE-IN-QUERY-brSource tt-pto-coleta


/* Definitions for BROWSE brTarget                                      */
&Scoped-define FIELDS-IN-QUERY-brTarget tt-pto-rota-coleta.cdn-seq ~
tt-pto-rota-coleta.cod-pto-coleta ~
fnDescPtoColeta(input tt-pto-rota-coleta.cod-pto-coleta) @ c-desc-pto-coleta-tgt 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTarget 
&Scoped-define QUERY-STRING-brTarget FOR EACH tt-pto-rota-coleta NO-LOCK ~
    BY tt-pto-rota-coleta.cdn-seq INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brTarget OPEN QUERY brTarget FOR EACH tt-pto-rota-coleta NO-LOCK ~
    BY tt-pto-rota-coleta.cdn-seq INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brTarget tt-pto-rota-coleta
&Scoped-define FIRST-TABLE-IN-QUERY-brTarget tt-pto-rota-coleta


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSource}~
    ~{&OPEN-QUERY-brTarget}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-rota-coleta.cod-rota 
&Scoped-define ENABLED-TABLES tt-rota-coleta
&Scoped-define FIRST-ENABLED-TABLE tt-rota-coleta
&Scoped-Define ENABLED-OBJECTS rtToolBar rtParent btQueryJoins ~
btReportsJoins btExit btHelp c-desc-rota 
&Scoped-Define DISPLAYED-FIELDS tt-rota-coleta.cod-rota 
&Scoped-define DISPLAYED-TABLES tt-rota-coleta
&Scoped-define FIRST-DISPLAYED-TABLE tt-rota-coleta
&Scoped-Define DISPLAYED-OBJECTS c-desc-rota 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescPtoColeta wFormation 
FUNCTION fnDescPtoColeta RETURNS CHARACTER
  ( input ccod-ptocoleta as CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRegiao wFormation 
FUNCTION fnRegiao RETURNS CHARACTER
  ( input ccod-regiao as CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wFormation AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


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

DEFINE VARIABLE c-desc-rota AS CHARACTER FORMAT "X(50)" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 100 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 100 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAddAllTarget 
     IMAGE-UP FILE "image\add-all":U
     IMAGE-INSENSITIVE FILE "image\ii-add-all":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Inclui Todos".

DEFINE BUTTON btAddTarget 
     IMAGE-UP FILE "image/next-au":U
     IMAGE-INSENSITIVE FILE "image/next-ai":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Inclui".

DEFINE BUTTON btDelAllTarget 
     IMAGE-UP FILE "image\del-all":U
     IMAGE-INSENSITIVE FILE "image\ii-del-all":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Retira Todos".

DEFINE BUTTON btDelTarget 
     IMAGE-UP FILE "image/prev-au":U
     IMAGE-INSENSITIVE FILE "image/prev-ai":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Retira".

DEFINE BUTTON btDown 
     IMAGE-UP FILE "image/im-abx1.bmp":U
     LABEL "D" 
     SIZE 3.57 BY 1 TOOLTIP "Mover para Baixo".

DEFINE BUTTON BtFiltro 
     IMAGE-UP FILE "image\im-ran":U
     LABEL "Filtro" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro"
     FONT 4.

DEFINE BUTTON btUp 
     IMAGE-UP FILE "image/im-acm1.bmp":U
     LABEL "U" 
     SIZE 3.57 BY 1 TOOLTIP "Mover para Cima".

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSource FOR 
      tt-pto-coleta SCROLLING.

DEFINE QUERY brTarget FOR 
      tt-pto-rota-coleta SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSource wFormation _STRUCTURED
  QUERY brSource NO-LOCK DISPLAY
      tt-pto-coleta.cod-pto-coleta FORMAT "x(12)":U WIDTH 12
      tt-pto-coleta.des-pto-coleta FORMAT "x(40)":U WIDTH 43
      tt-pto-coleta.cod-regiao FORMAT "x(12)":U
      fnRegiao(input tt-pto-coleta.cod-regiao) @ c-regiao COLUMN-LABEL "Descriá∆o" FORMAT "X(60)":U
            WIDTH 60
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 42 BY 13.75
         FONT 2.

DEFINE BROWSE brTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTarget wFormation _STRUCTURED
  QUERY brTarget NO-LOCK DISPLAY
      tt-pto-rota-coleta.cdn-seq FORMAT ">>>>>9":U
      tt-pto-rota-coleta.cod-pto-coleta FORMAT "x(12)":U WIDTH 14
      fnDescPtoColeta(input tt-pto-rota-coleta.cod-pto-coleta) @ c-desc-pto-coleta-tgt COLUMN-LABEL "Descriá∆o" FORMAT "X(40)":U
            WIDTH 43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 42 BY 13.75
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btQueryJoins AT ROW 1.13 COL 84.14 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 88.14 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 92.14 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 96.14 HELP
          "Ajuda"
     tt-rota-coleta.cod-rota AT ROW 3.38 COL 21 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     c-desc-rota AT ROW 3.38 COL 36.43 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     rtToolBar AT ROW 1 COL 1
     rtParent AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 100.29 BY 20.17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brSource AT ROW 1.5 COL 2
     brTarget AT ROW 1.5 COL 54.72
     btAddAllTarget AT ROW 6.46 COL 45.86
     btAddTarget AT ROW 7.63 COL 45.86
     btDelTarget AT ROW 8.75 COL 45.86
     btDelAllTarget AT ROW 9.88 COL 45.86
     BtFiltro AT ROW 15.33 COL 1.86 WIDGET-ID 6
     btUp AT ROW 15.42 COL 54.57 HELP
          "Mover para Cima" WIDGET-ID 4
     btDown AT ROW 15.42 COL 58.29 HELP
          "Mover para Baixo" WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5.25
         SIZE 97.43 BY 15.75
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Formation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-pto-coleta T "?" NO-UNDO mgind pto-coleta
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-pto-rota-coleta T "?" NO-UNDO mgind pto-rota-coleta
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-rota-coleta T "?" NO-UNDO mgind rota-coleta
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
         HEIGHT             = 20.17
         WIDTH              = 100.29
         MAX-HEIGHT         = 22.42
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22.42
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wFormation 
/* ************************* Included-Libraries *********************** */

{formation/formation.i}

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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wFormation)
THEN wFormation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSource
/* Query rebuild information for BROWSE brSource
     _TblList          = "Temp-Tables.tt-pto-coleta"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-pto-coleta.cod-pto-coleta
"tt-pto-coleta.cod-pto-coleta" ? ? "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-pto-coleta.des-pto-coleta
"tt-pto-coleta.des-pto-coleta" ? ? "character" ? ? ? ? ? ? no ? no no "43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.tt-pto-coleta.cod-regiao
     _FldNameList[4]   > "_<CALC>"
"fnRegiao(input tt-pto-coleta.cod-regiao) @ c-regiao" "Descriá∆o" "X(60)" ? ? ? ? ? ? ? no ? no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSource */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTarget
/* Query rebuild information for BROWSE brTarget
     _TblList          = "Temp-Tables.tt-pto-rota-coleta"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tt-pto-rota-coleta.cdn-seq|yes"
     _FldNameList[1]   = Temp-Tables.tt-pto-rota-coleta.cdn-seq
     _FldNameList[2]   > Temp-Tables.tt-pto-rota-coleta.cod-pto-coleta
"tt-pto-rota-coleta.cod-pto-coleta" ? ? "character" ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fnDescPtoColeta(input tt-pto-rota-coleta.cod-pto-coleta) @ c-desc-pto-coleta-tgt" "Descriá∆o" "X(40)" ? ? ? ? ? ? ? no ? no no "43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddAllTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddAllTarget wFormation
ON CHOOSE OF btAddAllTarget IN FRAME fPage1
DO:
    DEF VAR l-erro-rota AS LOG                   NO-UNDO.
    DEF VAR i-seq       LIKE {&ttTarget}.cdn-seq NO-UNDO.

    FOR EACH {&ttSource}:

        ASSIGN i-seq = 0.
        RUN getLastSequenceByRota IN {&hDBOTarget}(INPUT {&ttParent}.cod-rota:SCREEN-VALUE IN FRAME fpage0, OUTPUT i-seq).

        CREATE {&ttTarget}-aux.
        ASSIGN {&ttTarget}-aux.cod-rota       = {&ttParent}.cod-rota:SCREEN-VALUE IN FRAME fpage0
               {&ttTarget}-aux.cdn-seq        = i-seq  
               {&ttTarget}-aux.cod-pto-coleta = {&ttSource}.cod-pto-coleta.
               
        ASSIGN i-seq = i-seq + 1.

        /*--- Transfere temp-table {&ttTarget} para o DBO ---*/
        RUN setRecord      IN {&hDBOTarget} (INPUT TABLE {&ttTarget}-aux).
        RUN emptyRowErrors IN {&hDBOTarget}.
        RUN createRecord   IN {&hDBOTarget}.
        
        DELETE {&ttTarget}-aux.

        IF RETURN-VALUE = "NOK":U THEN DO:
           /** Retorna a temp-table rowErrors com os erros da transa?ío **/
           RUN getRowErrors IN {&hDBOTarget} (OUTPUT TABLE RowErrors).

           /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
           {method/showmessage.i1}
           {method/showmessage.i2 &Modal="Yes"}
           {method/showmessage.i3}
           RETURN "NOK":U.

        END.
        ELSE DO:

            RUN atualizaRotaPrincipal IN {&hDBOTarget} (INPUT "ADD":U,
                                                        INPUT {&ttParent}.cod-rota:SCREEN-VALUE IN FRAME fpage0,
                                                        INPUT {&ttSource}.cod-pto-coleta,
                                                        OUTPUT TABLE rowErrors).
        
            DELETE {&ttSource}.
            
        END.                   
        
    END.
    
    RUN piAtualizaBrowse.
    
    RUN piEnableDisableButtons.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddTarget wFormation
ON CHOOSE OF btAddTarget IN FRAME fPage1
DO:
   
   IF AVAIL {&ttSource} THEN DO:
   
       DEF VAR l-erro-rota AS LOG                   NO-UNDO.
       DEF VAR i-seq       LIKE {&ttTarget}.cdn-seq NO-UNDO.

       RUN getLastSequenceByRota IN {&hDBOTarget}(INPUT {&ttParent}.cod-rota:SCREEN-VALUE IN FRAME fpage0, OUTPUT i-seq).

       CREATE {&ttTarget}-aux.
       ASSIGN {&ttTarget}-aux.cod-rota       = {&ttParent}.cod-rota:SCREEN-VALUE IN FRAME fpage0
              {&ttTarget}-aux.cdn-seq        = i-seq  
              {&ttTarget}-aux.cod-pto-coleta = {&ttSource}.cod-pto-coleta.
    
       /*--- Transfere temp-table {&ttTarget} para o DBO ---*/
       RUN setRecord      IN {&hDBOTarget} (INPUT TABLE {&ttTarget}-aux).
       RUN emptyRowErrors IN {&hDBOTarget}.
       RUN createRecord   IN {&hDBOTarget}.
       
       DELETE {&ttTarget}-aux.
    
       IF RETURN-VALUE = "NOK":U THEN DO:
           /** Retorna a temp-table rowErrors com os erros da transa?ío **/
           RUN getRowErrors IN {&hDBOTarget} (OUTPUT TABLE RowErrors).
           
           /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
           {method/showmessage.i1}
           {method/showmessage.i2 &Modal="Yes"}
           {method/showmessage.i3}
           RETURN "NOK":U.
       END.
       ELSE DO:
    
           RUN atualizaRotaPrincipal IN {&hDBOTarget} (INPUT "ADD":U,
                                                       INPUT {&ttParent}.cod-rota:SCREEN-VALUE IN FRAME fpage0,
                                                       INPUT {&ttSource}.cod-pto-coleta,
                                                       OUTPUT TABLE rowErrors).
    
           DELETE {&ttSource}.
    
           RUN piAtualizaBrowse.
    
           RUN piEnableDisableButtons.
           
       END.

   END.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelAllTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelAllTarget wFormation
ON CHOOSE OF btDelAllTarget IN FRAME fPage1
DO:
   /* {formation/delalltarget.i} */  

   DEF VAR l-erro-rota AS LOG NO-UNDO.
   DEF VAR l-erro      AS LOG NO-UNDO.

   EMPTY TEMP-TABLE rowerrors-aux.
   FOR EACH {&ttTarget}:

       EMPTY TEMP-TABLE tt-pto-coleta-aux.

       RUN getTablePtoColeta IN {&hDBOSource} (INPUT {&ttTarget}.cod-pto-coleta,
                                               OUTPUT TABLE tt-pto-coleta-aux).

       FIND FIRST tt-pto-coleta-aux NO-LOCK NO-ERROR.
       IF NOT AVAIL tt-pto-coleta-aux THEN
           NEXT.

       CREATE {&ttSource}.
       BUFFER-COPY tt-pto-coleta-aux TO {&ttSource}.

       IF AVAIL {&ttTarget} THEN DO:
            SESSION:SET-WAIT-STATE("GENERAL":U).
        
            RUN emptyRowErrors   IN {&hDBOTarget}.
            RUN repositionRecord IN {&hDBOTarget} (INPUT {&ttTarget}.r-Rowid).    
            RUN deleteRecord     IN {&hDBOTarget}.
        
            IF  RETURN-VALUE = "NOK":U THEN DO:
                RUN getRowErrors IN {&hDBOTarget} (OUTPUT TABLE RowErrors).

               IF NOT CAN-FIND(FIRST RowErrors
                               WHERE RowErrors.ErrorType = "INTERNAL":U) THEN DO:
                   
                   /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
                   {method/showmessage.i1}
                   {method/showmessage.i2 &Modal="Yes"}
                   {method/showmessage.i3}
                   RETURN "NOK":U.

               END.
            END.
            
            RUN atualizaRotaPrincipal IN {&hDBOTarget} (INPUT "DEL":U,
                                                        INPUT {&ttParent}.cod-rota:SCREEN-VALUE IN FRAME fpage0,
                                                        INPUT {&ttSource}.cod-pto-coleta,
                                                        OUTPUT TABLE rowerrors-aux APPEND).

            /*--- Elimina a linha corrente do browse filho ---*/
            DELETE {&ttTarget}.
            
            SESSION:SET-WAIT-STATE("":U).

       END.

   END.

   FOR EACH rowerrors-aux:
        CREATE rowerrors.
        BUFFER-COPY rowerrors-aux TO rowErrors.
   END.

   /** Elimina todos os erros internos da BO (Navegaá∆o) **/
   for each RowErrors
       where RowErrors.ErrorType = "INTERNAL":U exclusive-lock:
       delete RowErrors.
   end.

   IF CAN-FIND (FIRST RowErrors WHERE 
                      RowErrors.ErrorSubType = "INFORMATION":U) THEN DO:
       {method/showmessage.i1}
       {method/showmessage.i2 &modal="yes"}
   END.

   RUN piAtualizaBrowse.
   
   RUN piEnableDisableButtons.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelTarget wFormation
ON CHOOSE OF btDelTarget IN FRAME fPage1
DO:
    /*{formation/deltarget.i} */  

   DEF VAR l-trocou-rota AS LOG NO-UNDO.

   IF BROWSE brTarget:NUM-SELECTED-ROWS <> 0 THEN DO:       
      BROWSE brTarget:FETCH-SELECTED-ROW(1) NO-ERROR.   
       GET CURRENT brTarget.
    
       EMPTY TEMP-TABLE tt-pto-coleta-aux.

       RUN getTablePtoColeta IN {&hDBOSource} (INPUT {&ttTarget}.cod-pto-coleta,
                                               OUTPUT TABLE tt-pto-coleta-aux).
    
       FIND FIRST tt-pto-coleta-aux NO-LOCK NO-ERROR.
       IF NOT AVAIL tt-pto-coleta-aux THEN
           NEXT.

       CREATE {&ttSource}.
       BUFFER-COPY tt-pto-coleta-aux TO {&ttSource}.

       IF AVAIL {&ttTarget} THEN DO:
            SESSION:SET-WAIT-STATE("GENERAL":U).
        
            RUN emptyRowErrors   IN {&hDBOTarget}.
            RUN repositionRecord IN {&hDBOTarget} (INPUT {&ttTarget}.r-Rowid).    
            RUN deleteRecord     IN {&hDBOTarget}.
            
            IF  RETURN-VALUE = "NOK":U THEN DO:
               RUN getRowErrors IN {&hDBOTarget} (OUTPUT TABLE RowErrors).

               IF NOT CAN-FIND(FIRST RowErrors
                               WHERE RowErrors.ErrorType = "INTERNAL":U) THEN DO:
                   /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
                   {method/showmessage.i1}
                   {method/showmessage.i2 &Modal="Yes"}
                   {method/showmessage.i3}
                   RETURN "NOK":U.
               END.

            END.

            /* ORGANIZA SEQUENCIAS */
            RUN sortSequence IN {&hDBOTarget}(INPUT {&ttParent}.cod-rota:SCREEN-VALUE IN FRAME fpage0).
            
            RUN emptyRowErrors   IN {&hDBOTarget}.
            RUN atualizaRotaPrincipal IN {&hDBOTarget} (INPUT "DEL":U,
                                                        INPUT {&ttParent}.cod-rota:SCREEN-VALUE IN FRAME fpage0,
                                                        INPUT {&ttTarget}.cod-pto-coleta,
                                                        OUTPUT TABLE RowErrors).

            IF CAN-FIND (FIRST RowErrors WHERE 
                               RowErrors.ErrorSubType = "INFORMATION":U) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2 &modal="yes"}
            END.


            /*--- Elimina a linha corrente do browse filho ---*/
            DELETE {&ttTarget}.
            brTarget:DELETE-CURRENT-ROW() IN FRAME fPage1.

            SESSION:SET-WAIT-STATE("":U).
       END.
       
   END.
        
   RUN piAtualizaBrowse.
   
   RUN piEnableDisableButtons.

    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDown wFormation
ON CHOOSE OF btDown IN FRAME fPage1 /* D */
DO:

    DEF VAR r-rowid-dest AS ROWID NO-UNDO.
    DEF VAR r-rowid-orig AS ROWID NO-UNDO.
    DEF VAR i-cod-seq-orig LIKE tt-pto-rota-coleta.cdn-seq NO-UNDO.
    DEF VAR i-cod-seq-dest LIKE tt-pto-rota-coleta.cdn-seq NO-UNDO.

    IF AVAIL tt-pto-rota-coleta THEN DO:
        BROWSE brTarget:FETCH-SELECTED-ROW(1) NO-ERROR.
        ASSIGN r-rowid-orig   = tt-pto-rota-coleta.r-rowid
               i-cod-seq-orig = tt-pto-rota-coleta.cdn-seq.
    END.

    GET NEXT brTarget.
    IF AVAIL tt-pto-rota-coleta THEN DO:

       brTarget:SELECT-NEXT-ROW() NO-ERROR.
       BROWSE brTarget:FETCH-SELECTED-ROW(1) NO-ERROR.
       ASSIGN r-rowid-dest   = tt-pto-rota-coleta.r-rowid
              i-cod-seq-dest = tt-pto-rota-coleta.cdn-seq.
       
    END.
    ELSE DO:         
        run utp~\ut-msgs(INPUT "Show":u,
                         INPUT 17006,
                         INPUT c-lbl-liter-movimentacao-invalida + "!" + "~~" + c-lbl-liter-movimentacao-invalida + ".").
        
        RUN pi-reposiciona-tt-pto-rota-coleta IN THIS-PROCEDURE(INPUT r-rowid-orig).

        RETURN "nok":u.
    END.

    /*Altera Sequencia Origem*/
    find FIRST bfaux{&ttTarget} NO-LOCK
         where bfaux{&ttTarget}.r-rowid = r-rowid-orig NO-ERROR.

    IF AVAIL bfaux{&ttTarget} THEN DO:

        empty temp-table tt-pto-rota-coleta-atual.
        RUN emptyRowErrors IN {&hDBOTarget}.
        RUN gotokey IN {&hDBOTarget}(INPUT bfaux{&ttTarget}.cod-rota, 
                                     INPUT bfaux{&ttTarget}.cod-pto-coleta,
                                     INPUT bfaux{&ttTarget}.cdn-seq). 

        buffer-copy bfaux{&ttTarget} to tt-pto-rota-coleta-atual
        ASSIGN tt-pto-rota-coleta-atual.cdn-seq = i-cod-seq-dest.
        RUN setRecord    IN {&hDBOTarget}(INPUT TABLE tt-pto-rota-coleta-atual).
        RUN updateRecord IN {&hDBOTarget}.
        
    END.

    /*Altera Sequencia Dest*/
    find first bfaux{&ttTarget} NO-LOCK
         where bfaux{&ttTarget}.r-rowid = r-rowid-dest NO-ERROR.
    IF AVAIL bfaux{&ttTarget} THEN DO:

        empty temp-table tt-pto-rota-coleta-atual.
        RUN emptyRowErrors IN {&hDBOTarget}.
        RUN gotokey IN {&hDBOTarget}(INPUT bfaux{&ttTarget}.cod-rota, 
                                     INPUT bfaux{&ttTarget}.cod-pto-coleta,
                                     INPUT bfaux{&ttTarget}.cdn-seq). 
        
        buffer-copy bfaux{&ttTarget} to tt-pto-rota-coleta-atual
        ASSIGN tt-pto-rota-coleta-atual.cdn-seq = i-cod-seq-orig.
        RUN setRecord    IN {&hDBOTarget}(INPUT TABLE tt-pto-rota-coleta-atual).
        RUN updateRecord IN {&hDBOTarget}.
        
    END.

    RUN piAtualizaBrowse.

    RUN pi-reposiciona-tt-pto-rota-coleta IN THIS-PROCEDURE(INPUT r-rowid-orig).
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wFormation
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME BtFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtFiltro wFormation
ON CHOOSE OF BtFiltro IN FRAME fPage1 /* Filtro */
DO:
  RUN aqp/aq0204b.w (INPUT-OUTPUT c-cod-filtro-ini,
                     INPUT-OUTPUT c-cod-filtro-fim, 
                     INPUT-OUTPUT c-des-filtro-ini, 
                     INPUT-OUTPUT c-des-filtro-fim,
                     INPUT-OUTPUT i-cod-regiao-ini, 
                     INPUT-OUTPUT i-cod-regiao-fim).

  RUN setConstraintPtoColFiltro IN h-boin00966-aux(INPUT c-cod-filtro-ini,  
                                                   INPUT c-cod-filtro-fim,  
                                                   INPUT c-des-filtro-ini,  
                                                   INPUT c-des-filtro-fim,
                                                   INPUT i-cod-regiao-ini,
                                                   INPUT i-cod-regiao-fim). 

  RUN openQueryPtoColFiltro IN h-boin00966-aux (OUTPUT TABLE tt-pto-coleta).

  OPEN QUERY brSource
    FOR EACH tt-pto-coleta NO-LOCK.

  ASSIGN l-filtro = YES.
  RUN piAtualizaBrowse.
  ASSIGN l-filtro = NO.

  RUN piEnableDisableButtons.

  RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wFormation
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wFormation
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wFormation
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUp wFormation
ON CHOOSE OF btUp IN FRAME fPage1 /* U */
DO: 

    DEF VAR r-rowid-dest AS ROWID NO-UNDO.
    DEF VAR r-rowid-orig AS ROWID NO-UNDO.
    DEF VAR i-cod-seq-orig LIKE tt-pto-rota-coleta.cdn-seq NO-UNDO.
    DEF VAR i-cod-seq-dest LIKE tt-pto-rota-coleta.cdn-seq NO-UNDO.

    IF AVAIL tt-pto-rota-coleta THEN DO:
        BROWSE brTarget:FETCH-SELECTED-ROW(1) NO-ERROR.
        ASSIGN r-rowid-orig   = tt-pto-rota-coleta.r-rowid
               i-cod-seq-orig = tt-pto-rota-coleta.cdn-seq.
    END.

    GET PREV brTarget.
    IF AVAIL tt-pto-rota-coleta THEN DO:

       brTarget:SELECT-PREV-ROW() NO-ERROR.
       BROWSE brTarget:FETCH-SELECTED-ROW(1) NO-ERROR.
       ASSIGN r-rowid-dest   = tt-pto-rota-coleta.r-rowid
              i-cod-seq-dest = tt-pto-rota-coleta.cdn-seq.
       
    END.
    ELSE DO:
        run utp~\ut-msgs(INPUT "Show":u,
                         INPUT 17006,
                         INPUT c-lbl-liter-movimentacao-invalida + "!" + "~~" + c-lbl-liter-movimentacao-invalida + ".").

        RUN pi-reposiciona-tt-pto-rota-coleta IN THIS-PROCEDURE(INPUT r-rowid-orig).
        return "nok":u.
    END.

    /*Altera Sequencia Origem*/
    find FIRST bfaux{&ttTarget} NO-LOCK
         where bfaux{&ttTarget}.r-rowid = r-rowid-orig NO-ERROR.

    IF AVAIL bfaux{&ttTarget} THEN DO:

        empty temp-table tt-pto-rota-coleta-atual.
        RUN emptyRowErrors IN {&hDBOTarget}.
        RUN gotokey IN {&hDBOTarget}(INPUT bfaux{&ttTarget}.cod-rota, 
                                     INPUT bfaux{&ttTarget}.cod-pto-coleta,
                                     INPUT bfaux{&ttTarget}.cdn-seq). 

        buffer-copy bfaux{&ttTarget} to tt-pto-rota-coleta-atual
        ASSIGN tt-pto-rota-coleta-atual.cdn-seq = i-cod-seq-dest.
        RUN setRecord    IN {&hDBOTarget}(INPUT TABLE tt-pto-rota-coleta-atual).
        RUN updateRecord IN {&hDBOTarget}.
        
    END.
    
    /*Altera Sequencia Dest*/
    find first bfaux{&ttTarget} NO-LOCK
         where bfaux{&ttTarget}.r-rowid = r-rowid-dest NO-ERROR.
    IF AVAIL bfaux{&ttTarget} THEN DO:

        empty temp-table tt-pto-rota-coleta-atual.
        RUN emptyRowErrors IN {&hDBOTarget}.
        RUN gotokey IN {&hDBOTarget}(INPUT bfaux{&ttTarget}.cod-rota, 
                                     INPUT bfaux{&ttTarget}.cod-pto-coleta,
                                     INPUT bfaux{&ttTarget}.cdn-seq). 
        
        buffer-copy bfaux{&ttTarget} to tt-pto-rota-coleta-atual
        ASSIGN tt-pto-rota-coleta-atual.cdn-seq = i-cod-seq-orig.
        RUN setRecord    IN {&hDBOTarget}(INPUT TABLE tt-pto-rota-coleta-atual).
        RUN updateRecord IN {&hDBOTarget}.
        
    END.

    RUN piAtualizaBrowse.

    RUN pi-reposiciona-tt-pto-rota-coleta IN THIS-PROCEDURE(INPUT r-rowid-orig).
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME tt-rota-coleta.cod-rota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rota-coleta.cod-rota wFormation
ON LEAVE OF tt-rota-coleta.cod-rota IN FRAME fPage0 /* Rota */
DO:
    {include/leave.i &tabela=rota-coleta
                    &atributo-ref=des-rota
                    &variavel-ref=c-desc-rota
                    &where="rota-coleta.cod-rota = tt-rota-coleta.cod-rota"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wFormation
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSource
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wFormation 


/* ***************************  Main Block  *************************** */

/*:T--- L¢gica para inicializaá∆o do programam ---*/
{formation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wFormation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-boin00976-seq) THEN DO:
       DELETE PROCEDURE h-boin00976-seq.
       ASSIGN h-boin00976-seq = ?.
    END.

    IF VALID-HANDLE(h-boin00966-aux) THEN DO:
       DELETE PROCEDURE h-boin00966-aux.
       ASSIGN h-boin00966-aux = ?.
    END.

    IF VALID-HANDLE(h-boin00977) THEN DO:
       DELETE PROCEDURE h-boin00977.
       ASSIGN h-boin00977 = ?.
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

    ASSIGN tt-rota-coleta.cod-rota:SCREEN-VALUE IN FRAME fpage0 = STRING(tt-rota-coleta.cod-rota).
    APPLY "leave" TO tt-rota-coleta.cod-rota IN FRAME fpage0.

    RUN piAtualizaBrowse.
    RUN piEnableDisableButtons.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wFormation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE rCodRota AS ROWID NO-UNDO.

    /*:T Posiciona query, do DBO, atrav?s dos valores do ≠ndice único */
    RUN goToKey IN {&hDBOParent} (INPUT pc-i-cod-rota).

    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOParent} (OUTPUT rCodRota).

    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rCodRota).

    ASSIGN tt-rota-coleta.cod-rota:SCREEN-VALUE IN FRAME fpage0 = STRING(pc-i-cod-rota).   
    
    {utp/ut-liter.i "Movimentaá∆o_Inv†lida" *}
    ASSIGN c-lbl-liter-movimentacao-invalida = TRIM(RETURN-VALUE).    
    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wFormation 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE i-cod-rota LIKE {&ttParent}.cod-rota NO-UNDO
        VIEW-AS FILL-IN SIZE 18 BY 0.88.
    
    DEFINE FRAME fGoToRecord
        i-cod-rota  AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Transportador" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Transportador"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-cod-rota.
        
        /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT i-cod-rota ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Transportador":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE i-cod-rota btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
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
    
    /*:T--- Verifica se o DBO da tabela Pai j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "inbo/boin00975.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00975.p YES}
        {btb/btb008za.i2 inbo/boin00975.p '' {&hDBOParent}} 
    END.
    
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main").

    /*:T--- Verifica se o DBO da tabela Origem j† est† inicializado ---*/
    
    IF NOT VALID-HANDLE({&hDBOSource}) OR
       {&hDBOSource}:TYPE <> "PROCEDURE":U OR
       {&hDBOSource}:FILE-NAME <> "inbo/boin00966.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00966.p YES}
        {btb/btb008za.i2 inbo/boin00966.p '' {&hDBOSource}} 
    END.
                
    /*:T--- Verifica se o DBO da tabela Formaá∆o j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTarget}) OR
       {&hDBOTarget}:TYPE <> "PROCEDURE":U OR
       {&hDBOTarget}:FILE-NAME <> "inbo/boin00976.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00976.p YES}
        {btb/btb008za.i2 inbo/boin00976.p '' {&hDBOTarget}} 
    END.

    IF NOT VALID-HANDLE(h-boin00976-seq) THEN
         RUN inbo/boin00976.p PERSISTENT SET h-boin00976-seq.
    
    RUN openQueryStatic IN h-boin00976-seq (INPUT "Main").

    IF NOT VALID-HANDLE(h-boin00977) THEN
         RUN inbo/boin00977.p PERSISTENT SET h-boin00977.
    
    RUN openQueryStatic IN h-boin00977 (INPUT "Main").

    IF NOT VALID-HANDLE(h-boin00966-aux) THEN
         RUN inbo/boin00966.p PERSISTENT SET h-boin00966-aux.

    RUN openQueryStatic IN h-boin00966-aux (INPUT "Main").
    
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
    
    {formation/openqueriestarget.i &Parent="Rota"
                                   &Query="ByRota"}    
                                      
    RUN setConstraintPtoColFiltro IN h-boin00966 (INPUT c-cod-filtro-ini,  
                                                  INPUT c-cod-filtro-fim,  
                                                  INPUT c-des-filtro-ini,  
                                                  INPUT c-des-filtro-fim,
                                                  INPUT i-cod-regiao-ini,
                                                  INPUT i-cod-regiao-fim). 

    RUN openQueryPtoColFiltro IN h-boin00966 (OUTPUT TABLE tt-pto-coleta).

    {&OPEN-QUERY-brSource}
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reposiciona-tt-pto-rota-coleta wFormation 
PROCEDURE pi-reposiciona-tt-pto-rota-coleta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prw-id AS ROWID NO-UNDO.   

    FIND FIRST tt-pto-rota-coleta
         WHERE tt-pto-rota-coleta.r-rowid = prw-id NO-ERROR.
    IF NOT AVAIL tt-pto-rota-coleta THEN
        RETURN "OK":U.
    
    REPOSITION brTarget to rowid rowid(tt-pto-rota-coleta).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaBrowse wFormation 
PROCEDURE piAtualizaBrowse :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela formaá∆o ({&ttTarget}) com base 
               nos campos da tabela pai ({&ttParent}) e tabela origem ({&ttSource})
  Parameters:  
------------------------------------------------------------------------------*/

    /*Quando chama pelo bot∆o filtro n∆o abre a query*/
    IF NOT l-filtro THEN
        RUN openQueries.

    FOR EACH bf{&ttTarget} NO-LOCK
       WHERE bf{&ttTarget}.cod-rota = tt-rota-coleta.cod-rota:SCREEN-VALUE IN FRAME fpage0:


        FIND FIRST bf{&ttSource} EXCLUSIVE-LOCK
             WHERE bf{&ttSource}.cod-pto-coleta = bf{&ttTarget}.cod-pto-coleta NO-ERROR.
        IF AVAIL bf{&ttSource} THEN
            DELETE bf{&ttSource}.

    END.

    {&OPEN-QUERY-brSource}
    {&OPEN-QUERY-brTarget}
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEnableDisableButtons wFormation 
PROCEDURE piEnableDisableButtons :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*regra de habilitaá∆o de programas*/
    IF CAN-FIND(FIRST {&ttSource}) THEN DO:
        ENABLE btAddAllTarget
               btAddTarget               
               btFiltro
            WITH FRAME fpage1.        
    END.
    ELSE
        DISABLE btAddAllTarget
               btAddTarget
            WITH FRAME fpage1.

    IF CAN-FIND(FIRST {&ttTarget}) THEN DO:
        ENABLE btDelAllTarget
               btDelTarget  
               btUp
               btDown
            WITH FRAME fpage1.        
    END.
    ELSE
        DISABLE btDelAllTarget
                btDelTarget
                btUp
                btDown
            WITH FRAME fpage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wFormation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela formaá∆o ({&ttTarget}) com base 
               nos campos da tabela pai ({&ttParent}) e tabela origem ({&ttSource})
  Parameters:  
------------------------------------------------------------------------------*/
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescPtoColeta wFormation 
FUNCTION fnDescPtoColeta RETURNS CHARACTER
  ( input ccod-ptocoleta as CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var cdesc-ptocoleta as char no-undo.

  RUN GotoKey in h-boin00966-aux (input ccod-ptocoleta).

  RUN GetCharField in h-boin00966-aux (input "des-pto-coleta", output cdesc-ptocoleta).

  RETURN cdesc-ptocoleta.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRegiao wFormation 
FUNCTION fnRegiao RETURNS CHARACTER
  ( input ccod-regiao as CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var cdesc-regiao as char no-undo.

  RUN GotoKey in h-boin00977 (input ccod-regiao).

  RUN GetCharField in h-boin00977 (input "nom-regiao", output cdesc-regiao).

  RETURN cdesc-regiao.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

