&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-preco-frete-coleta NO-UNDO LIKE preco-frete-coleta
       FIELD r-rowid AS rowid.
DEFINE TEMP-TABLE tt-preco-frete-coleta-aux NO-UNDO LIKE preco-frete-coleta
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0212 2.00.00.006 } /*** 010006 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i {1} MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        {1}
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE First         NO
&GLOBAL-DEFINE Prev          NO
&GLOBAL-DEFINE Next          NO
&GLOBAL-DEFINE Last          NO
&GLOBAL-DEFINE GoTo          NO
&GLOBAL-DEFINE Search        NO

&GLOBAL-DEFINE Add           NO 
&GLOBAL-DEFINE Copy          NO 
&GLOBAL-DEFINE Update        NO 
&GLOBAL-DEFINE Delete        NO 
&GLOBAL-DEFINE Undo          NO 
&GLOBAL-DEFINE Cancel        NO 
&GLOBAL-DEFINE Save          NO 

&GLOBAL-DEFINE ttTable        tt-preco-frete-coleta
&GLOBAL-DEFINE hDBOTable      h-boin00996
&GLOBAL-DEFINE DBOTable       preco-frete-coleta

&GLOBAL-DEFINE page0KeyFields fi_key
&GLOBAL-DEFINE page0Fields    fi_key  
&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins bt-selecao
&GLOBAL-DEFINE page1Widgets   bt-incluir bt-modificar bt-eliminar bt-copiar
&GLOBAL-DEFINE page1Browse    brTabPreco   
&GLOBAL-DEFINE page1Fields    fi_key_2 

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

DEFINE VARIABLE dt-dat-inic-vigenc LIKE preco-frete-coleta.dat-inic-vigenc NO-UNDO.
DEFINE VARIABLE dt-dat-fim-vigenc  LIKE preco-frete-coleta.dat-fim-vigenc  NO-UNDO.
DEFINE VARIABLE c-cod-estabel-ini  LIKE preco-frete-coleta.cod-estabel     NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim  LIKE preco-frete-coleta.cod-estabel     NO-UNDO.
DEFINE VARIABLE c-cod-rota-ini     LIKE preco-frete-coleta.cod-rota        NO-UNDO.
DEFINE VARIABLE c-cod-rota-fim     LIKE preco-frete-coleta.cod-rota        NO-UNDO.
DEFINE VARIABLE i-cod-transp-ini   LIKE preco-frete-coleta.cod-transp      NO-UNDO.
DEFINE VARIABLE i-cod-transp-fim   LIKE preco-frete-coleta.cod-transp      NO-UNDO.
DEFINE VARIABLE i-cdn-tip-veic-ini LIKE preco-frete-coleta.cdn-tip-veic    NO-UNDO.
DEFINE VARIABLE i-cdn-tip-veic-fim LIKE preco-frete-coleta.cdn-tip-veic    NO-UNDO.
DEFINE VARIABLE c-it-codigo-ini    LIKE preco-frete-coleta.it-codigo       NO-UNDO.
DEFINE VARIABLE c-it-codigo-fim    LIKE preco-frete-coleta.it-codigo       NO-UNDO.

/* Handles */
DEFINE VARIABLE h-boad268na         AS HANDLE    NO-UNDO. /* transporte */
DEFINE VARIABLE h-boad00509         AS HANDLE    NO-UNDO. /* tip-veic-transp */
DEFINE VARIABLE h-boin627           AS HANDLE    NO-UNDO. /* usuar-mater  */

DEFINE VARIABLE c-nome-abrev-transp AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-des-tip-veic      AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-consulta          AS LOGICAL   NO-UNDO.

DEFINE BUFFER bf{&ttTable} FOR {&ttTable}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTabPreco

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-preco-frete-coleta

/* Definitions for BROWSE brTabPreco                                    */
&Scoped-define FIELDS-IN-QUERY-brTabPreco tt-preco-frete-coleta.cod-estabel ~
tt-preco-frete-coleta.cod-rota tt-preco-frete-coleta.cod-transp ~
fn-nome-abrev-transp(tt-preco-frete-coleta.cod-transp) @ c-nome-abrev-transp ~
tt-preco-frete-coleta.cdn-tip-veic ~
fn-des-tip-veic(tt-preco-frete-coleta.cdn-tip-veic) @  c-des-tip-veic ~
tt-preco-frete-coleta.it-codigo tt-preco-frete-coleta.dat-inic-vigenc ~
tt-preco-frete-coleta.dat-fim-vigenc ~
tt-preco-frete-coleta.val-unit-frete-km ~
tt-preco-frete-coleta.val-unit-frete-quant ~
tt-preco-frete-coleta.val-fix-frete tt-preco-frete-coleta.val-unit-bonus-km ~
tt-preco-frete-coleta.val-unit-bonus-pto-col 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTabPreco 
&Scoped-define QUERY-STRING-brTabPreco FOR EACH tt-preco-frete-coleta NO-LOCK
&Scoped-define OPEN-QUERY-brTabPreco OPEN QUERY brTabPreco FOR EACH tt-preco-frete-coleta NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTabPreco tt-preco-frete-coleta
&Scoped-define FIRST-TABLE-IN-QUERY-brTabPreco tt-preco-frete-coleta


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTabPreco}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar bt-selecao btQueryJoins ~
btReportsJoins btExit btHelp fi_key 
&Scoped-Define DISPLAYED-OBJECTS fi_key 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-des-tip-veic wMaintenance 
FUNCTION fn-des-tip-veic RETURNS CHARACTER
  ( pi-tip-veic AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-nome-abrev-transp wMaintenance 
FUNCTION fn-nome-abrev-transp RETURNS CHARACTER
  ( pi-cod-transp AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile  
       MENU-ITEM miSelecao      LABEL "&Sele‡Æo" ACCELERATOR "CTRL-S"
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
DEFINE BUTTON bt-selecao 
     IMAGE-UP FILE "image/im-ran.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-ran.bmp":U
     LABEL "":L 
     SIZE 4 BY 1.25 TOOLTIP "Sele‡Æo".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image/im-joi":U
     IMAGE-INSENSITIVE FILE "image/ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image/im-pri":U
     IMAGE-INSENSITIVE FILE "image/ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE fi_key AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11.72 BY .67 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 120 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-copiar 
     LABEL "&Copiar" 
     SIZE 10 BY 1 TOOLTIP "Incluir".

DEFINE BUTTON bt-eliminar 
     LABEL "&Eliminar" 
     SIZE 10 BY 1 TOOLTIP "Eliminar".

DEFINE BUTTON bt-incluir 
     LABEL "&Incluir" 
     SIZE 10 BY 1 TOOLTIP "Incluir".

DEFINE BUTTON bt-modificar 
     LABEL "&Modificar" 
     SIZE 10 BY 1 TOOLTIP "Modificar".

DEFINE BUTTON bt-va-para 
     LABEL "&V  Para" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi_key_2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11.72 BY .67 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTabPreco FOR 
      tt-preco-frete-coleta SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTabPreco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTabPreco wMaintenance _STRUCTURED
  QUERY brTabPreco NO-LOCK DISPLAY
      tt-preco-frete-coleta.cod-estabel FORMAT "x(5)":U
      tt-preco-frete-coleta.cod-rota FORMAT "x(12)":U
      tt-preco-frete-coleta.cod-transp FORMAT ">>,>>9":U WIDTH 5.14
      fn-nome-abrev-transp(tt-preco-frete-coleta.cod-transp) @ c-nome-abrev-transp COLUMN-LABEL "Nome Abrev Transp" FORMAT "x(12)":U
            WIDTH 15
      tt-preco-frete-coleta.cdn-tip-veic COLUMN-LABEL "Tipo Veic" FORMAT ">9":U
            WIDTH 6.86
      fn-des-tip-veic(tt-preco-frete-coleta.cdn-tip-veic) @  c-des-tip-veic COLUMN-LABEL "Descri‡Æo Tipo Veic" FORMAT "x(60)":U
            WIDTH 20
      tt-preco-frete-coleta.it-codigo FORMAT "x(16)":U
      tt-preco-frete-coleta.dat-inic-vigenc COLUMN-LABEL "Inicio Vigˆncia" FORMAT "99/99/9999":U
            WIDTH 10.72
      tt-preco-frete-coleta.dat-fim-vigenc COLUMN-LABEL "Fim Vigˆncia" FORMAT "99/99/9999":U
            WIDTH 9.43
      tt-preco-frete-coleta.val-unit-frete-km COLUMN-LABEL "Pre‡o Unit KM" FORMAT ">>>>>,>>>,>>9.9999":U
            WIDTH 10.57
      tt-preco-frete-coleta.val-unit-frete-quant COLUMN-LABEL "Pre‡o Unit Qtde" FORMAT ">>>>>,>>>,>>9.9999":U
            WIDTH 11.43
      tt-preco-frete-coleta.val-fix-frete COLUMN-LABEL "Pre‡o Fixo" FORMAT ">>>>>,>>>,>>9.9999":U
            WIDTH 11.57
      tt-preco-frete-coleta.val-unit-bonus-km FORMAT ">>>>>,>>>,>>9.9999":U
            WIDTH 12.43
      tt-preco-frete-coleta.val-unit-bonus-pto-col FORMAT ">>>>>,>>>,>>9.9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 116 BY 13.75
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-selecao AT ROW 1.13 COL 1.43 HELP
          "Ocorrˆncia anterior"
     btQueryJoins AT ROW 1.13 COL 104.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 108.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 112.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 116.57 HELP
          "Ajuda"
     fi_key AT ROW 2.75 COL 76 COLON-ALIGNED NO-LABEL
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 120 BY 17.25
         FONT 1.

DEFINE FRAME fPage1
     brTabPreco AT ROW 1.25 COL 2
     bt-incluir AT ROW 15.08 COL 2
     bt-modificar AT ROW 15.08 COL 12.14
     bt-eliminar AT ROW 15.08 COL 22.29
     bt-copiar AT ROW 15.08 COL 32.29
     bt-va-para AT ROW 15.08 COL 42.29
     fi_key_2 AT ROW 15.21 COL 74 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 2.75
         SIZE 118 BY 15.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-preco-frete-coleta T "?" NO-UNDO mgind preco-frete-coleta
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS rowid
      END-FIELDS.
      TABLE: tt-preco-frete-coleta-aux T "?" NO-UNDO mgind preco-frete-coleta
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17.25
         WIDTH              = 120
         MAX-HEIGHT         = 17.25
         MAX-WIDTH          = 120.57
         VIRTUAL-HEIGHT     = 17.25
         VIRTUAL-WIDTH      = 120.57
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTabPreco 1 fPage1 */
/* SETTINGS FOR BROWSE brTabPreco IN FRAME fPage1
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTabPreco
/* Query rebuild information for BROWSE brTabPreco
     _TblList          = "Temp-Tables.tt-preco-frete-coleta"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-preco-frete-coleta.cod-estabel
     _FldNameList[2]   = Temp-Tables.tt-preco-frete-coleta.cod-rota
     _FldNameList[3]   > Temp-Tables.tt-preco-frete-coleta.cod-transp
"tt-preco-frete-coleta.cod-transp" ? ? "integer" ? ? ? ? ? ? no ? no no "5.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fn-nome-abrev-transp(tt-preco-frete-coleta.cod-transp) @ c-nome-abrev-transp" "Nome Abrev Transp" "x(12)" ? ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-preco-frete-coleta.cdn-tip-veic
"tt-preco-frete-coleta.cdn-tip-veic" "Tipo Veic" ">9" "integer" ? ? ? ? ? ? no ? no no "6.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fn-des-tip-veic(tt-preco-frete-coleta.cdn-tip-veic) @  c-des-tip-veic" "Descri‡Æo Tipo Veic" "x(60)" ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.tt-preco-frete-coleta.it-codigo
     _FldNameList[8]   > Temp-Tables.tt-preco-frete-coleta.dat-inic-vigenc
"tt-preco-frete-coleta.dat-inic-vigenc" "Inicio Vigˆncia" ? "date" ? ? ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-preco-frete-coleta.dat-fim-vigenc
"tt-preco-frete-coleta.dat-fim-vigenc" "Fim Vigˆncia" ? "date" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-preco-frete-coleta.val-unit-frete-km
"tt-preco-frete-coleta.val-unit-frete-km" "Pre‡o Unit KM" ? "decimal" ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-preco-frete-coleta.val-unit-frete-quant
"tt-preco-frete-coleta.val-unit-frete-quant" "Pre‡o Unit Qtde" ? "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tt-preco-frete-coleta.val-fix-frete
"tt-preco-frete-coleta.val-fix-frete" "Pre‡o Fixo" ? "decimal" ? ? ? ? ? ? no ? no no "11.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.tt-preco-frete-coleta.val-unit-bonus-km
"tt-preco-frete-coleta.val-unit-bonus-km" ? ? "decimal" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.tt-preco-frete-coleta.val-unit-bonus-pto-col
"tt-preco-frete-coleta.val-unit-bonus-pto-col" ? ? "decimal" ? ? ? ? ? ? no "B“nus Unit Pto Coleta" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brTabPreco */
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brTabPreco
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brTabPreco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTabPreco wMaintenance
ON MOUSE-SELECT-DBLCLICK OF brTabPreco IN FRAME fPage1
DO:
    IF NOT l-consulta THEN
        APPLY 'CHOOSE':U TO bt-modificar IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-copiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-copiar wMaintenance
ON CHOOSE OF bt-copiar IN FRAME fPage1 /* Copiar */
OR ALT-C OF {&WINDOW-NAME} ANYWHERE 
DO:
    IF NOT l-consulta THEN DO:    
        DEFINE VARIABLE pr-rowid AS ROWID NO-UNDO.

        IF AVAIL tt-preco-frete-coleta THEN DO:
            ASSIGN pr-rowid = tt-preco-frete-coleta.r-rowid.
            {&WINDOW-NAME}:SENSITIVE = NO.
            RUN aqp/aq0212b.w(INPUT-OUTPUT pr-rowid, INPUT "COPY":U).

            RUN pi-open-query IN THIS-PROCEDURE.
            
            FOR FIRST tt-preco-frete-coleta 
                WHERE tt-preco-frete-coleta.r-rowid = pr-rowid: 
                REPOSITION brTabPreco TO ROWID ROWID(tt-preco-frete-coleta) NO-ERROR.
            END.
            {&WINDOW-NAME}:SENSITIVE = YES.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-eliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar wMaintenance
ON CHOOSE OF bt-eliminar IN FRAME fPage1 /* Eliminar */
OR ALT-DEL OF {&WINDOW-NAME} ANYWHERE 
DO:
    IF NOT l-consulta THEN DO:
        DEFINE VARIABLE i-linha AS INTEGER INITIAL 0 NO-UNDO. 
    
        RUN utp/ut-msgs.p ( INPUT "show":U, INPUT 550, INPUT "" ).
        IF  RETURN-VALUE = "no":U THEN
            RETURN NO-APPLY.
    
        IF VALID-HANDLE(h-boin00996) AND AVAIL tt-preco-frete-coleta THEN DO:
            ASSIGN i-linha = brTabPreco:FOCUSED-ROW IN FRAME fPage1.
    
            EMPTY TEMP-TABLE RowErrors                 NO-ERROR.
            EMPTY TEMP-TABLE tt-preco-frete-coleta-aux NO-ERROR.
            
            RUN emptyRowErrors IN h-boin00996.
    
            CREATE tt-preco-frete-coleta-aux.
            BUFFER-COPY tt-preco-frete-coleta 
                    TO tt-preco-frete-coleta-aux NO-ERROR.
            
            FOR FIRST tt-preco-frete-coleta-aux:
                RUN repositionRecord IN h-boin00996(INPUT tt-preco-frete-coleta-aux.r-rowid).
                RUN deleteRecord     IN h-boin00996.
                RUN getRowErrors     IN h-boin00996 (OUTPUT TABLE RowErrors).
                IF CAN-FIND(FIRST RowErrors
                            WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
                    /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
                    {method/showmessage.i1}
                    {method/showmessage.i2 &Modal="Yes"}
                    {method/showmessage.i3}
                    RETURN NO-APPLY.
                END.
    
                RUN pi-open-query IN THIS-PROCEDURE.
    
                IF i-linha > NUM-RESULTS('brTabPreco':U) THEN
                    ASSIGN i-linha = NUM-RESULTS('brTabPreco':U).
    
                REPOSITION brTabPreco TO ROW i-linha NO-ERROR. 
            END.
        END. 
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir wMaintenance
ON CHOOSE OF bt-incluir IN FRAME fPage1 /* Incluir */
OR ALT-INS OF {&WINDOW-NAME} ANYWHERE 
DO:
    IF NOT l-consulta THEN DO:
        DEFINE VARIABLE pr-rowid AS ROWID NO-UNDO.
        
        {&WINDOW-NAME}:SENSITIVE = NO.
        RUN aqp/aq0212b.w(INPUT-OUTPUT pr-rowid, INPUT "ADD":U).
        IF RETURN-VALUE = 'OK' THEN DO:
            RUN pi-open-query IN THIS-PROCEDURE.
            FOR FIRST tt-preco-frete-coleta 
                WHERE tt-preco-frete-coleta.r-rowid = pr-rowid: 
                REPOSITION brTabPreco TO ROWID ROWID(tt-preco-frete-coleta) NO-ERROR.
            END.
        END.
        {&WINDOW-NAME}:SENSITIVE = YES.         
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-modificar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-modificar wMaintenance
ON CHOOSE OF bt-modificar IN FRAME fPage1 /* Modificar */
OR ALT-A OF {&WINDOW-NAME} ANYWHERE 
DO:
    IF NOT l-consulta THEN DO:    
        DEFINE VARIABLE pr-rowid AS ROWID NO-UNDO.
        
        IF AVAIL tt-preco-frete-coleta THEN DO:
            ASSIGN pr-rowid = tt-preco-frete-coleta.r-rowid.
            {&WINDOW-NAME}:SENSITIVE = NO.
            RUN aqp/aq0212b.w(INPUT-OUTPUT pr-rowid, INPUT "UPDATE":U).
            IF RETURN-VALUE = 'OK' THEN DO:
                RUN pi-open-query IN THIS-PROCEDURE.
                FOR FIRST tt-preco-frete-coleta 
                    WHERE tt-preco-frete-coleta.r-rowid = pr-rowid: 
                    REPOSITION brTabPreco TO ROWID ROWID(tt-preco-frete-coleta) NO-ERROR.
                END.
            END. 
            {&WINDOW-NAME}:SENSITIVE = YES.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-selecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-selecao wMaintenance
ON CHOOSE OF bt-selecao IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miSelecao IN MENU mbMain
DO:
    {&WINDOW-NAME}:SENSITIVE = NO.

    RUN aqp/aq0212a.w(INPUT-OUTPUT dt-dat-inic-vigenc,
                      INPUT-OUTPUT dt-dat-fim-vigenc,
                      INPUT-OUTPUT c-cod-estabel-ini,
                      INPUT-OUTPUT c-cod-estabel-fim,
                      INPUT-OUTPUT c-cod-rota-ini,
                      INPUT-OUTPUT c-cod-rota-fim,
                      INPUT-OUTPUT i-cod-transp-ini,
                      INPUT-OUTPUT i-cod-transp-fim,
                      INPUT-OUTPUT i-cdn-tip-veic-ini,
                      INPUT-OUTPUT i-cdn-tip-veic-fim,
                      INPUT-OUTPUT c-it-codigo-ini,
                      INPUT-OUTPUT c-it-codigo-fim).

    IF RETURN-VALUE = "OK" THEN
        RUN pi-open-query IN THIS-PROCEDURE.
        
    {&WINDOW-NAME}:SENSITIVE = YES.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-va-para
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-va-para wMaintenance
ON CHOOSE OF bt-va-para IN FRAME fPage1 /* V  Para */
OR ALT-T OF {&WINDOW-NAME} ANYWHERE 
DO:
    IF NOT l-consulta THEN
        RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMaintenance
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE({&hDBOTable}) THEN DO:
        DELETE PROCEDURE {&hDBOTable}.
        ASSIGN {&hDBOTable} = ?.
    END.

    /* Transporte */
    IF VALID-HANDLE(h-boad268na) THEN DO:
        DELETE PROCEDURE h-boad268na.
        ASSIGN h-boad268na = ?.
    END.

    /* tip-veic-transp */
    IF VALID-HANDLE(h-boad00509) THEN DO:
        DELETE PROCEDURE h-boad00509.
        ASSIGN h-boad00509 = ?.
    END.
    
    IF VALID-HANDLE(h-boin627) THEN DO:
        DELETE PROCEDURE h-boin627.
        ASSIGN h-boin627 = ?.
    END.     

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ENABLE btReportsJoins 
           btQueryJoins
           bt-selecao
           WITH FRAME fPage0.

    ENABLE bt-incluir 
           bt-modificar
           bt-eliminar
           bt-copiar
           bt-va-para
           brTabPreco
           WITH FRAME fPage1.

    RUN pi-inicializa-variaveis IN THIS-PROCEDURE.
    RUN pi-open-query           IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
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
    
    DEFINE VARIABLE pc-cod-estabel      LIKE {&ttTable}.cod-estabel      NO-UNDO.
    DEFINE VARIABLE pc-cod-rota         LIKE {&ttTable}.cod-rota         NO-UNDO.
    DEFINE VARIABLE pi-cod-transp       LIKE {&ttTable}.cod-transp       NO-UNDO. 
    DEFINE VARIABLE pi-cdn-tip-veic     LIKE {&ttTable}.cdn-tip-veic     NO-UNDO. 
    DEFINE VARIABLE pc-it-codigo        LIKE {&ttTable}.it-codigo        NO-UNDO. 
    DEFINE VARIABLE pdt-dat-inic-vigenc LIKE {&ttTable}.dat-inic-vigenc  NO-UNDO. 
    DEFINE VARIABLE iRowsReturned       AS INTEGER                       NO-UNDO.

    
    DEFINE FRAME fGoToRecord
         pc-cod-estabel      AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12.57 BY .78
         pc-cod-rota         AT ROW 2.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12.57 BY .78
         pi-cod-transp       AT ROW 3.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12.57 BY .78
         pi-cdn-tip-veic     AT ROW 4.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12.57 BY .78
         pc-it-codigo        AT ROW 5.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12.57 BY .78
         pdt-dat-inic-vigenc AT ROW 6.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12.57 BY .78
         btGoToOK          AT ROW 7.63 COL 2.14
         btGoToCancel      AT ROW 7.63 COL 13
         rtGoToButton      AT ROW 7.38 COL 1
         SPACE(0.28)
         WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
              THREE-D SCROLLABLE TITLE "V  Para Pre‡o Frete Coleta" FONT 1
              DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    /*tech1139 - FO 1338.917 - 10/07/2006  */
        RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
        {utp/ut-liter.i "V _Para_Pre‡o_Frete_Coleta"}
        ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    /*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN pc-cod-estabel      
               pc-cod-rota        
               pi-cod-transp      
               pi-cdn-tip-veic    
               pc-it-codigo       
               pdt-dat-inic-vigenc.

        
        IF VALID-HANDLE(h-boin00996) THEN DO:
            RUN openQueryStatic IN h-boin00996(INPUT "Main":U).
            RUN goToKey         IN h-boin00996(INPUT pc-cod-estabel,       
                                               INPUT pc-cod-rota,         
                                               INPUT pi-cod-transp,       
                                               INPUT pi-cdn-tip-veic,     
                                               INPUT pc-it-codigo,        
                                               INPUT pdt-dat-inic-vigenc).
                                               
            IF RETURN-VALUE = "OK" THEN DO:
                EMPTY TEMP-TABLE tt-preco-frete-coleta NO-ERROR.
                RUN getRecord IN h-boin00996 (OUTPUT TABLE tt-preco-frete-coleta).
                /*--- Abre a query associada ao browse da p gina {&PageNumber} ---*/
                {&OPEN-QUERY-brTabPreco}

                RUN pi-habilita-botoes IN THIS-PROCEDURE.
            END.
            ELSE DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Pre‡o_Frete_Coleta":U).
                RETURN NO-APPLY.
            END.
        END.
    END.
    
    ENABLE pc-cod-estabel     
           pc-cod-rota        
           pi-cod-transp      
           pi-cdn-tip-veic    
           pc-it-codigo       
           pdt-dat-inic-vigenc
           WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "inbo/boin00996.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00996.p YES}
        {btb/btb008za.i2 inbo/boin00996.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic   IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    /* transporte */
    IF NOT VALID-HANDLE(h-boad268na) THEN DO:
        RUN adbo/boad268na.p PERSISTENT SET h-boad268na.
        RUN openQueryStatic IN h-boad268na (INPUT "Main":U) NO-ERROR.
    END.


    /* tip-veic-transp */
    IF NOT VALID-HANDLE(h-boad00509) THEN DO:
        RUN adbo/boad00509.p PERSISTENT SET h-boad00509.
        RUN openQueryStatic IN h-boad00509 (INPUT "Main":U) NO-ERROR.
    END.

    /* usuar-mater */
    IF NOT VALID-HANDLE(h-boin627) THEN
        RUN inbo/boin627.p PERSISTENT SET h-boin627.
    RUN openQuery IN h-boin627 (INPUT 1) NO-ERROR.     
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-botoes wMaintenance 
PROCEDURE pi-habilita-botoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN l-consulta = '{1}':U = 'aq0412':U.
    
    IF l-consulta THEN DO:
        ASSIGN bt-incluir    :HIDDEN IN FRAME fPage1 = YES
               bt-modificar  :HIDDEN IN FRAME fPage1 = YES
               bt-eliminar   :HIDDEN IN FRAME fPage1 = YES
               bt-copiar     :HIDDEN IN FRAME fPage1 = YES
               bt-va-para    :HIDDEN IN FRAME fPage1 = YES.              
        RETURN "OK":U.
    END.

    ASSIGN bt-modificar:SENSITIVE IN FRAME fPage1 = NUM-RESULTS('brTabPreco':U) > 0
           bt-eliminar:SENSITIVE  IN FRAME fPage1 = NUM-RESULTS('brTabPreco':U) > 0
           bt-copiar:SENSITIVE    IN FRAME fPage1 = NUM-RESULTS('brTabPreco':U) > 0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-variaveis wMaintenance 
PROCEDURE pi-inicializa-variaveis :
/*------------------------------------------------------------------------------
  Purpose: Inicializar variaveis utilizadas como parametro para
           tela de sele‡Æo    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-retorno AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-char-1  AS CHARACTER NO-UNDO.


    ASSIGN dt-dat-inic-vigenc = DATE("01/01/":U + STRING(YEAR(TODAY))) 
           dt-dat-fim-vigenc  = DATE("31/12/":U + STRING(YEAR(TODAY))) 
           c-cod-estabel-fim  = FILL("Z":U,5)
           c-cod-rota-fim     = FILL("Z":U,12)
           i-cod-transp-fim   = INT(FILL("9":U,5))
           i-cdn-tip-veic-fim = INT(FILL("9":U,2))
           c-it-codigo-fim    = FILL("Z":U,16).
           
    IF VALID-HANDLE(h-boin627) THEN DO:
        RUN findUsuar_mater IN h-boin627 (INPUT c-seg-usuario, OUTPUT c-retorno).
      
        IF c-retorno = "" THEN DO:
            RUN getCharField IN h-boin627 (INPUT "char-1", OUTPUT c-char-1). 
            IF SUBSTR(c-char-1,16,5) <> "" THEN
                ASSIGN c-cod-estabel-ini = SUBSTR(c-char-1,16,5)
                       c-cod-estabel-fim = SUBSTR(c-char-1,16,5).
        END.
    END.
   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-open-query wMaintenance 
PROCEDURE pi-open-query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iRowsReturned AS INTEGER NO-UNDO.

    RUN setConstraintSelecao IN h-boin00996(INPUT dt-dat-inic-vigenc,
                                            INPUT dt-dat-fim-vigenc,
                                            INPUT c-cod-estabel-ini,
                                            INPUT c-cod-estabel-fim,
                                            INPUT c-cod-rota-ini,
                                            INPUT c-cod-rota-fim,
                                            INPUT i-cod-transp-ini,
                                            INPUT i-cod-transp-fim,
                                            INPUT i-cdn-tip-veic-ini,
                                            INPUT i-cdn-tip-veic-fim,
                                            INPUT c-it-codigo-ini,
                                            INPUT c-it-codigo-fim).

    RUN openQueryStatic IN h-boin00996 (INPUT "Selecao":U) NO-ERROR.
    
    EMPTY TEMP-TABLE tt-preco-frete-coleta NO-ERROR.

    RUN getBatchRecords IN h-boin00996 (INPUT ?,
                                        INPUT NO,
                                        INPUT 9999,
                                        OUTPUT iRowsReturned,
                                        OUTPUT TABLE tt-preco-frete-coleta).

    /*--- Abre a query associada ao browse da p gina {&PageNumber} ---*/
    {&OPEN-QUERY-brTabPreco}
    
    RUN pi-habilita-botoes IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-des-tip-veic wMaintenance 
FUNCTION fn-des-tip-veic RETURNS CHARACTER
  ( pi-tip-veic AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  retorna descricao do tipo de veiculo
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-des-tip-veic AS CHARACTER NO-UNDO.
    
    IF pi-tip-veic > 0 THEN DO:
        IF VALID-HANDLE(h-boad00509) THEN DO:
            RUN goToKey IN h-boad00509(INPUT pi-tip-veic) .
            IF RETURN-VALUE = "OK":U THEN
                RUN getCharField IN h-boad00509(INPUT "des-tip-veic":U, OUTPUT c-des-tip-veic) .
        END.
    END.    
    RETURN c-des-tip-veic.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-nome-abrev-transp wMaintenance 
FUNCTION fn-nome-abrev-transp RETURNS CHARACTER
  ( pi-cod-transp AS INT) :
/*------------------------------------------------------------------------------
  Purpose: retorna nome abreveado do transportador
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-nome-abrev AS CHARACTER NO-UNDO.
  
    IF pi-cod-transp > 0 THEN DO:
        IF VALID-HANDLE(h-boad268na) THEN DO:
            RUN goToKey IN h-boad268na(INPUT pi-cod-transp).
            IF RETURN-VALUE = "OK":U THEN
                RUN getCharField IN h-boad268na(INPUT "nome-abrev":U, OUTPUT c-nome-abrev).
        END.
    END.
    RETURN c-nome-abrev.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

