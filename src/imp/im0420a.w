 &ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decla-imp-embal NO-UNDO LIKE decla-import-embal
       field r-Rowid as ROWID.
DEFINE TEMP-TABLE tt-decla-imp-embal-aux NO-UNDO LIKE decla-import-embal
       field r-Rowid as ROWID.
DEFINE TEMP-TABLE tt-decla-import NO-UNDO LIKE decla-import
       field r-Rowid as ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0420A 2.00.00.021 } /*** "010021" 07/11/2025 11:15:52 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0420 MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           IM0420A
&GLOBAL-DEFINE Version        2.00.00.021

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Principal, Principal II, Observa‡Æo

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2

&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets  
 
&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields       cb-carac-oper cb-mod-desp cb-tipo-declaracao tt-decla-import.cdn-consign tt-decla-import.log-fundap ~
                                 cb-via-transporte cb-docto-carg cb-tipo-conhecto cb-ind-utiliz tt-decla-import.cod-conhecto-house tt-decla-import.cod-identif ~
                                 tt-decla-import.cod-natur-operac fi-cod-despachante
&GLOBAL-DEFINE page2Fields       
&GLOBAL-DEFINE page3Fields       c-cdn-mensagem tt-decla-import.cod-inf-compltar

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO. 

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl        AS HANDLE  NO-UNDO.
DEFINE VARIABLE wh-pesquisa      AS HANDLE NO-UNDO.
DEFINE VARIABLE l-zoom           AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-return  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont    AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-boin245    AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx386    AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx391    AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boad098    AS HANDLE      NO-UNDO.

DEFINE VARIABLE i-reg-retornados AS INTEGER     NO-UNDO.

DEFINE VARIABLE h-bocx383 AS HANDLE.

/* Vari veis do z01di040 */
{cdp/cd9098.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brEmbalagem

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-decla-imp-embal

/* Definitions for BROWSE brEmbalagem                                   */
&Scoped-define FIELDS-IN-QUERY-brEmbalagem tt-decla-imp-embal.qtd-vol-embal tt-decla-imp-embal.cod-sig-embal   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brEmbalagem tt-decla-imp-embal.qtd-vol-embal ~
  tt-decla-imp-embal.cod-sig-embal   
&Scoped-define ENABLED-TABLES-IN-QUERY-brEmbalagem tt-decla-imp-embal
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brEmbalagem tt-decla-imp-embal
&Scoped-define SELF-NAME brEmbalagem
&Scoped-define QUERY-STRING-brEmbalagem FOR EACH tt-decla-imp-embal NO-LOCK
&Scoped-define OPEN-QUERY-brEmbalagem OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-imp-embal NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brEmbalagem tt-decla-imp-embal
&Scoped-define FIRST-TABLE-IN-QUERY-brEmbalagem tt-decla-imp-embal


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brEmbalagem}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar btQueryJoins ~
btReportsJoins btExit btHelp btOK btSave btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

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

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

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

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE cb-carac-oper AS CHARACTER FORMAT "X(256)":U 
     LABEL "Caracter¡stica Opera‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 28.86 BY 1 NO-UNDO.

DEFINE VARIABLE cb-docto-carg AS CHARACTER FORMAT "X(256)":U 
     LABEL "Doc. Chegada Carga" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 27.29 BY 1 NO-UNDO.

DEFINE VARIABLE cb-ind-utiliz AS CHARACTER FORMAT "X(256)":U 
     LABEL "Indicativo Utiliza‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 24.43 BY 1 NO-UNDO.

DEFINE VARIABLE cb-mod-desp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Modalidade Despacho" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 29.14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-conhecto AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 22.29 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-declaracao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Declara‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 53.86 BY 1 NO-UNDO.

DEFINE VARIABLE cb-via-transporte AS CHARACTER FORMAT "X(256)":U 
     LABEL "Via Transporte" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 22.29 BY 1 NO-UNDO.

DEFINE VARIABLE c-des-nat-operacao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev-desp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-despachante AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Despachante" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-87
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 3.5.

DEFINE RECTANGLE RECT-88
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 4.5.

DEFINE RECTANGLE RECT-89
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 2.67.

DEFINE BUTTON btAddEmbalagem 
     IMAGE-UP FILE "image/im-add.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-add.bmp":U
     LABEL "Adiciona Processo Vinculado" 
     SIZE 4 BY 1.25 TOOLTIP "Adiciona Processo Vinculado"
     FONT 4.

DEFINE BUTTON btCanEmbalagem 
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "Save" 
     SIZE 4 BY 1.25 TOOLTIP "Cancela InclusÆo Processo Vinculado"
     FONT 4.

DEFINE BUTTON btDelEmbalagem 
     IMAGE-UP FILE "image/im-era.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-era.bmp":U
     LABEL "Excluir" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSaveEmbalagem 
     IMAGE-UP FILE "image/im-sav":U
     IMAGE-INSENSITIVE FILE "image/ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25 TOOLTIP "Salva Processo Vinculado"
     FONT 4.

DEFINE RECTANGLE RECT-85
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 7.58.

DEFINE VARIABLE c-cdn-mensagem AS INTEGER FORMAT "9999" INITIAL 0 
     LABEL "Mensagem" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-mensagem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-86
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 11.33.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brEmbalagem FOR 
      tt-decla-imp-embal SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brEmbalagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brEmbalagem wWindow _FREEFORM
  QUERY brEmbalagem NO-LOCK DISPLAY
      tt-decla-imp-embal.qtd-vol-embal FORMAT ">>>,>>9":U
      tt-decla-imp-embal.cod-sig-embal FORMAT "!xx":U
      ENABLE
          tt-decla-imp-embal.qtd-vol-embal 
          tt-decla-imp-embal.cod-sig-embal
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 45 BY 6
         FONT 1 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


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
     btOK AT ROW 16.75 COL 2
     btSave AT ROW 16.75 COL 13 WIDGET-ID 2
     btCancel AT ROW 16.75 COL 24
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     cb-tipo-declaracao AT ROW 1.58 COL 18.86 COLON-ALIGNED WIDGET-ID 4
     cb-carac-oper AT ROW 2.58 COL 18.86 COLON-ALIGNED WIDGET-ID 30
     tt-decla-import.cdn-consign AT ROW 2.58 COL 62.57 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cb-mod-desp AT ROW 3.58 COL 18.86 COLON-ALIGNED WIDGET-ID 18
     tt-decla-import.log-fundap AT ROW 3.58 COL 65 WIDGET-ID 14
          VIEW-AS TOGGLE-BOX
          SIZE 11.86 BY .88
     cb-via-transporte AT ROW 5.42 COL 18.86 COLON-ALIGNED WIDGET-ID 46
     cb-docto-carg AT ROW 6.42 COL 18.86 COLON-ALIGNED WIDGET-ID 6
     tt-decla-import.cod-identif AT ROW 6.42 COL 56.57 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 24.43 BY .88
     cb-tipo-conhecto AT ROW 7.42 COL 18.86 COLON-ALIGNED WIDGET-ID 24
     cb-ind-utiliz AT ROW 7.42 COL 56.57 COLON-ALIGNED WIDGET-ID 44
     tt-decla-import.cod-conhecto-house AT ROW 8.42 COL 18.86 COLON-ALIGNED WIDGET-ID 48
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     tt-decla-import.cod-natur-operac AT ROW 10.29 COL 17.14 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-des-nat-operacao AT ROW 10.29 COL 27.14 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     fi-cod-despachante AT ROW 11.29 COL 17.14 COLON-ALIGNED WIDGET-ID 50
     c-nome-abrev-desp AT ROW 11.29 COL 27.14 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     "Fornecedor" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 1.08 COL 3.86 WIDGET-ID 34
     "Gerais" VIEW-AS TEXT
          SIZE 6.14 BY .54 AT ROW 9.71 COL 3.86 WIDGET-ID 42
     "Transporte" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 4.92 COL 3.86 WIDGET-ID 38
     RECT-87 AT ROW 1.33 COL 2 WIDGET-ID 32
     RECT-88 AT ROW 5.17 COL 2 WIDGET-ID 36
     RECT-89 AT ROW 9.88 COL 2 WIDGET-ID 40
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     brEmbalagem AT ROW 2.21 COL 6 WIDGET-ID 1000
     btAddEmbalagem AT ROW 2.63 COL 53 HELP
          "Confirma altera‡äes" WIDGET-ID 34
     btCanEmbalagem AT ROW 3.83 COL 53 HELP
          "Confirma altera‡äes" WIDGET-ID 36
     btSaveEmbalagem AT ROW 5.04 COL 53 HELP
          "Confirma altera‡äes" WIDGET-ID 40
     btDelEmbalagem AT ROW 6.25 COL 53 HELP
          "Confirma altera‡äes" WIDGET-ID 38
     "Embalagem" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.25 COL 4.86 WIDGET-ID 42
     RECT-85 AT ROW 1.5 COL 2 WIDGET-ID 32
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fPage3
     c-cdn-mensagem AT ROW 2.21 COL 10 COLON-ALIGNED HELP
          "C¢digo - Num‚rico Mensagem" WIDGET-ID 2
     c-desc-mensagem AT ROW 2.21 COL 20.14 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     tt-decla-import.cod-inf-compltar AT ROW 3.5 COL 4 NO-LABEL WIDGET-ID 44
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 79 BY 8.75
     "Informa‡äes Complementares" VIEW-AS TEXT
          SIZE 23 BY .54 AT ROW 1.25 COL 4 WIDGET-ID 48
     RECT-86 AT ROW 1.17 COL 2 WIDGET-ID 46
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1 WIDGET-ID 1100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-decla-imp-embal T "?" NO-UNDO mgcex decla-import-embal
      ADDITIONAL-FIELDS:
          field r-Rowid as ROWID
      END-FIELDS.
      TABLE: tt-decla-imp-embal-aux T "?" NO-UNDO mgcex decla-import-embal
      ADDITIONAL-FIELDS:
          field r-Rowid as ROWID
      END-FIELDS.
      TABLE: tt-decla-import T "?" NO-UNDO mgcex decla-import
      ADDITIONAL-FIELDS:
          field r-Rowid as ROWID
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
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
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brEmbalagem RECT-85 fPage2 */
/* SETTINGS FOR FRAME fPage3
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brEmbalagem
/* Query rebuild information for BROWSE brEmbalagem
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-imp-embal NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brEmbalagem */
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


&Scoped-define BROWSE-NAME brEmbalagem
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME brEmbalagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brEmbalagem wWindow
ON END-ERROR OF brEmbalagem IN FRAME fPage2
DO:
    if  brEmbalagem:new-row in frame {&frame-name} then do:
        if  avail tt-decla-imp-embal then
            delete tt-decla-imp-embal.
        if  brEmbalagem:delete-current-row() in frame {&frame-name} then. 
    end.                                                               
    else do:
       get current brEmbalagem.
       DISPLAY tt-decla-imp-embal.qtd-vol-embal         
               tt-decla-imp-embal.cod-sig-embal with browse brEmbalagem. 
    end.
    return no-apply.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brEmbalagem wWindow
ON INS OF brEmbalagem IN FRAME fPage2
DO:
  apply 'choose':U to btAddEmbalagem in frame fPage2. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brEmbalagem wWindow
ON OFF-END OF brEmbalagem IN FRAME fPage2
DO:
  apply 'entry':U to btSaveEmbalagem in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brEmbalagem wWindow
ON ROW-LEAVE OF brEmbalagem IN FRAME fPage2
DO:
    if  l-zoom = yes /* NÆo executar a row-leave ao executar o zoom */ then
    return no-apply.

    do  transaction on error undo, return no-apply:
        if  brEmbalagem:new-row in frame fPage2 then
            IF NOT CAN-FIND (FIRST tt-decla-imp-embal
                             WHERE tt-decla-imp-embal.num-di-ems       = tt-decla-import.num-di-ems
                             AND   tt-decla-imp-embal.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
                             AND   tt-decla-imp-embal.cod-sig-embal    = input browse brEmbalagem tt-decla-imp-embal.cod-sig-embal) THEN DO:
                create tt-decla-imp-embal.
                assign tt-decla-imp-embal.num-di-ems       = tt-decla-import.num-di-ems
                       tt-decla-imp-embal.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
                       input browse brEmbalagem tt-decla-imp-embal.qtd-vol-embal
                       INPUT browse brEmbalagem tt-decla-imp-embal.cod-sig-embal  .        
            END.
    end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddEmbalagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddEmbalagem wWindow
ON CHOOSE OF btAddEmbalagem IN FRAME fPage2 /* Adiciona Processo Vinculado */
DO:
  RUN pi-add-embalagem.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btCanEmbalagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCanEmbalagem wWindow
ON CHOOSE OF btCanEmbalagem IN FRAME fPage2 /* Save */
DO:
  RUN pi-canc-embalagem.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelEmbalagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelEmbalagem wWindow
ON CHOOSE OF btDelEmbalagem IN FRAME fPage2 /* Excluir */
DO:
  RUN pi-exclui-embalagem.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    RUN pi-trata-combos  (INPUT NO).
    RUN pi-valida-dados.
    IF RETURN-VALUE = "OK":U THEN DO:
        IF NOT VALID-HANDLE (h-bocx383) THEN RUN getDBOParentHandle IN phcaller (OUTPUT h-bocx383).

        RUN pi-cria-tab-ocor IN h-bocx383 (INPUT TABLE tt-decla-import,
                                           INPUT TABLE tt-decla-imp-embal,
                                           INPUT c-seg-usuario).
    END.
        
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN pi-seta-parametros-di IN phCaller (INPUT TABLE tt-decla-import,
                                               INPUT TABLE tt-decla-imp-embal).
        
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wWindow
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btSaveEmbalagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSaveEmbalagem wWindow
ON CHOOSE OF btSaveEmbalagem IN FRAME fPage2 /* Save */
DO:
  RUN pi-salva-embalagem.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME c-cdn-mensagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cdn-mensagem wWindow
ON F5 OF c-cdn-mensagem IN FRAME fPage3 /* Mensagem */
DO:
    {method/zoomfields.i &ProgramZoom="cxzoom/z10cx100.w"
                             &FieldZoom1="cdn-mensagem"
                             &FieldScreen1="c-cdn-mensagem"
                             &frame1="fPage3"
                             &EnableImplant="YES"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cdn-mensagem wWindow
ON LEAVE OF c-cdn-mensagem IN FRAME fPage3 /* Mensagem */
DO:
    {method/referencefields.i   
        &HandleDBOLeave="h-bocx391"
        &KeyValue1="c-cdn-mensagem:screen-value in frame fPage3"
        &FieldName1="des-mensagem"
        &FieldScreen1="c-desc-mensagem"
        &Frame1="fPage3"
        &FieldName2="dsl-conteudo"
        &FieldScreen2="tt-decla-import.cod-inf-compltar"
        &Frame2="fPage3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cdn-mensagem wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cdn-mensagem IN FRAME fPage3 /* Mensagem */
DO:
  APPLY 'f5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME cb-carac-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-carac-oper wWindow
ON VALUE-CHANGED OF cb-carac-oper IN FRAME fPage1 /* Caracter¡stica Opera‡Æo */
DO:
    RUN pi-trata-operacao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-decla-import.cdn-consign
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cdn-consign wWindow
ON F5 OF tt-decla-import.cdn-consign IN FRAME fPage1 /* Cod Consignat rio */
DO:
    &if defined(bf-mat-comex) &then
        assign l-implanta = no.
    &else
        assign l-implanta = yes.
    &endif

    {include/zoomvar.i
        &prog-zoom="adzoom/z03ad098.w"
        &campo="tt-decla-import.cdn-consign"
        &campozoom="cod-emitente"
        &frame="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cdn-consign wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-decla-import.cdn-consign IN FRAME fPage1 /* Cod Consignat rio */
DO:
  APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-decla-import.cod-natur-operac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cod-natur-operac wWindow
ON F5 OF tt-decla-import.cod-natur-operac IN FRAME fPage1 /* Natureza Opera‡Æo */
DO:
    {method/ZoomFields.i
             &ProgramZoom="inzoom/z04in245.w"
             &FieldZoom1="nat-operacao"
             &FieldScreen1="tt-decla-import.cod-natur-operac"
             &Frame1="fpage1"
             &FieldZoom2="denominacao"
             &FieldScreen2="c-des-nat-operacao"
             &Frame2="fpage1"
             &EnableImplant="no"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cod-natur-operac wWindow
ON LEAVE OF tt-decla-import.cod-natur-operac IN FRAME fPage1 /* Natureza Opera‡Æo */
DO:
    assign input frame fpage1 tt-decla-import.cod-natur-operac.
    
    run findNatureza in h-boin245 (input tt-decla-import.cod-natur-operac,
                                   output c-return).
    if c-return = "":U then
        run getCharfield in h-boin245 (input "denominacao":U,output c-des-nat-operacao).
    else 
        assign c-des-nat-operacao = "":U.
    
    disp c-des-nat-operacao with frame fpage1.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cod-natur-operac wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-decla-import.cod-natur-operac IN FRAME fPage1 /* Natureza Opera‡Æo */
DO:
    APPLY 'F5':U TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-despachante
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-despachante wWindow
ON F5 OF fi-cod-despachante IN FRAME fPage1 /* Despachante */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
                       &campo="fi-cod-despachante"
                       &campozoom="cod-emitente"
                       &frame="fPage1"
                       &campo2="c-nome-abrev-desp"
                       &campozoom2="nome-abrev"
                       &frame2="fPage1"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-despachante wWindow
ON LEAVE OF fi-cod-despachante IN FRAME fPage1 /* Despachante */
DO:
    IF  VALID-HANDLE(h-boad098)
    AND AVAIL tt-decla-import
    AND INPUT FRAME fPage1 fi-cod-despachante <> 0 THEN DO:

        RUN goToKey IN h-boad098 (INPUT INPUT FRAME fpage1 fi-cod-despachante).
        IF  RETURN-VALUE = "OK":U THEN DO:
            RUN getCharField IN h-boad098(INPUT "nome-abrev":U, OUTPUT c-return).

            ASSIGN c-nome-abrev-desp:SCREEN-VALUE IN FRAME fpage1 = c-return.
        END.
        ELSE DO:
            ASSIGN c-nome-abrev-desp:SCREEN-VALUE IN FRAME fpage1 = "":U.
        END.
    END.
    ELSE DO:
        ASSIGN c-nome-abrev-desp:SCREEN-VALUE IN FRAME fpage1 = "":U.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-despachante wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-despachante IN FRAME fPage1 /* Despachante */
DO:
    APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
tt-decla-import.cdn-consign:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage1.
tt-decla-import.cod-natur-operac:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage1.
fi-cod-despachante:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage1.

{window/mainblock.i}

on  'F5', mouse-select-dblclick of tt-decla-imp-embal.cod-sig-embal in browse brEmbalagem do:

    if  num-results("brEmbalagem") > 0 then do:
        assign i-filtro = 1
               l-zoom   = yes.

        {include/zoomvar.i &prog-zoom="dizoom/z01di040.w"
                           &campo=tt-decla-imp-embal.cod-sig-embal
                           &campozoom=sigla-emb
                           &browse=brEmbalagem}
        assign l-zoom = no.
    end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF VALID-HANDLE(h-boin245) THEN DO:
    DELETE PROCEDURE h-boin245.
    ASSIGN h-boin245 = ?.
END.

IF VALID-HANDLE(h-bocx386) THEN DO:
    DELETE PROCEDURE h-bocx386.
    ASSIGN h-bocx386 = ?.
END.

IF VALID-HANDLE(h-bocx391) THEN DO:
    DELETE PROCEDURE h-bocx391.
    ASSIGN h-bocx391 = ?.
END.

IF VALID-HANDLE(h-boad098) THEN DO:
    DELETE PROCEDURE h-boad098.
    ASSIGN h-boad098 = ?.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wWindow 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT CAN-FIND(FIRST tt-decla-imp-embal) THEN
    ENABLE btAddEmbalagem WITH FRAME fPage2.
ELSE
    ENABLE btAddEmbalagem 
           btDelEmbalagem WITH FRAME fPage2.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wWindow 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF pcAction = "UPDATE":U THEN
    ASSIGN cb-tipo-declaracao:SENSITIVE IN FRAME fPage1 = NO.


IF NOT CAN-FIND(FIRST tt-decla-imp-embal) THEN
    ENABLE btAddEmbalagem WITH FRAME fPage2.
ELSE
    ENABLE btAddEmbalagem 
           btDelEmbalagem WITH FRAME fPage2.

ENABLE brEmbalagem WITH FRAME fPage2.



RETURN "OK":U.
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
    ENABLE cb-carac-oper cb-mod-desp cb-tipo-declaracao tt-decla-import.cdn-consign tt-decla-import.log-fundap ~
           cb-via-transporte cb-docto-carg cb-tipo-conhecto cb-ind-utiliz tt-decla-import.cod-conhecto-house tt-decla-import.cod-identif ~
           tt-decla-import.cod-natur-operac fi-cod-despachante
        WITH FRAME fPage1.
    
    IF NOT CAN-FIND(FIRST tt-decla-imp-embal) THEN
        ENABLE btAddEmbalagem WITH FRAME fPage2.
    ELSE
        ENABLE btAddEmbalagem 
               btDelEmbalagem WITH FRAME fPage2.
    
    ENABLE brEmbalagem WITH FRAME fPage2.
    ENABLE c-cdn-mensagem tt-decla-import.cod-inf-compltar
        WITH FRAME fPage3.


    RUN pi-trata-combos(INPUT YES).
    
    RUN pi-retorna-dados-tab-ocor IN h-bocx383 (INPUT c-seg-usuario,
                                                OUTPUT TABLE tt-decla-import,
                                                OUTPUT TABLE tt-decla-imp-embal).
    
    IF NOT CAN-FIND(FIRST tt-decla-import) THEN
        CREATE tt-decla-import.
    ELSE 
        FOR FIRST tt-decla-import: END.
    
    IF pcAction = "ADD":U THEN DO:
        RUN geraUltimaSeqDi IN h-bocx383 (OUTPUT tt-decla-import.num-di-ems).
        ASSIGN tt-decla-import.num-seq-retif = 0.           
    END.
    
    RUN pi-trata-combos(INPUT YES).
    
    ASSIGN fi-cod-despachante:SCREEN-VALUE IN FRAME fPage1 = SUBSTRING(tt-decla-import.cod-livre-1,3,9).
    APPLY 'LEAVE':U TO fi-cod-despachante IN FRAME fPage1.
    
    DISP tt-decla-import.cdn-consign
         tt-decla-import.log-fundap
         tt-decla-import.cod-identif
         tt-decla-import.cod-conhecto-house
         tt-decla-import.cod-natur-operac WITH FRAME fPage1.
    
    APPLY 'LEAVE':U TO tt-decla-import.cod-natur-operac IN FRAME fPage1.
    
    FOR EACH tt-decla-imp-embal:
        IF NOT CAN-FIND(FIRST tt-decla-imp-embal-aux
                        WHERE tt-decla-imp-embal-aux.num-di-ems       = tt-decla-import.num-di-ems
                        AND   tt-decla-imp-embal-aux.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
                        AND   tt-decla-imp-embal-aux.cod-sig-embal    = tt-decla-imp-embal.cod-sig-embal) THEN DO:
            CREATE tt-decla-imp-embal-aux.
            ASSIGN tt-decla-imp-embal-aux.num-di-ems       = tt-decla-import.num-di-ems
                   tt-decla-imp-embal-aux.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
                   tt-decla-imp-embal-aux.cod-sig-embal    = tt-decla-imp-embal.cod-sig-embal
                   tt-decla-imp-embal-aux.qtd-vol-embal    = tt-decla-imp-embal.qtd-vol-embal.
        END.
    END.
    
    ASSIGN tt-decla-imp-embal.cod-sig-embal          :READ-ONLY IN BROWSE brEmbalagem = YES
           tt-decla-imp-embal.qtd-vol-embal          :READ-ONLY IN BROWSE brEmbalagem = YES.
    
    {&OPEN-QUERY-brEmbalagem}
    
    RUN pi-trata-operacao.
    HIDE btSave IN FRAME fPage0.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN inicia-bos.
    
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.

    /*PASTA PRINCIPAL*/
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then        
        ASSIGN cAuxTraducao001 = {cxinc/i02cx383.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN cb-tipo-declaracao:LIST-ITEM-PAIRS in frame fPage1 = cAuxTraducao001
			   cAuxTraducao001 = ""
			   cAuxTraducao001 = {cxinc/i03cx383.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN cb-carac-oper:LIST-ITEM-PAIRS      in frame fPage1 = cAuxTraducao001
			   cAuxTraducao001 = ""
			   cAuxTraducao001 = {cxinc/i04cx383.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN cb-mod-desp:LIST-ITEM-PAIRS        in frame fPage1 = cAuxTraducao001
			   cAuxTraducao001 = ""
			   cAuxTraducao001 = {adinc/i01ad268.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN cb-via-transporte:LIST-ITEM-PAIRS  in frame fPage1 = cAuxTraducao001
			   cAuxTraducao001 = ""
			   cAuxTraducao001 = {cxinc/i06cx383.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN cb-docto-carg:LIST-ITEM-PAIRS      in frame fPage1 = cAuxTraducao001
			   cAuxTraducao001 = ""
			   cAuxTraducao001 = {cxinc/i07cx383.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN cb-tipo-conhecto:LIST-ITEM-PAIRS   in frame fPage1 = cAuxTraducao001
			   cAuxTraducao001 = ""
			   cAuxTraducao001 = {cxinc/i08cx383.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN cb-ind-utiliz:LIST-ITEM-PAIRS      in frame fPage1 = cAuxTraducao001.
    &else
        ASSIGN cb-tipo-declaracao:list-items      in frame fPage1 = {cxinc/i02cx383.i 03}.
		ASSIGN cb-carac-oper:list-items           in frame fPage1 = {cxinc/i03cx383.i 03}.
		ASSIGN cb-mod-desp:list-items             in frame fPage1 = {cxinc/i04cx383.i 03}.
        ASSIGN cb-via-transporte:list-items       in frame fPage1 = {adinc/i01ad268.i 03}.
        ASSIGN cb-docto-carg:list-items           in frame fPage1 = {cxinc/i06cx383.i 03}.
        ASSIGN cb-tipo-conhecto:list-items        in frame fPage1 = {cxinc/i07cx383.i 03}.
        ASSIGN cb-ind-utiliz:list-items           in frame fPage1 = {cxinc/i08cx383.i 03}.
    &endif
    /*FIM PASTA PRINCIPAL*/

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicia-bos wWindow 
PROCEDURE inicia-bos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT VALID-HANDLE (h-bocx383) THEN RUN getDBOParentHandle IN phcaller (OUTPUT h-bocx383).
IF NOT VALID-HANDLE (h-boin245) THEN RUN inbo/boin245.p PERSISTENT SET h-boin245.
IF NOT VALID-HANDLE (h-bocx386) THEN RUN cxbo/bocx386.p PERSISTENT SET h-bocx386.
IF NOT VALID-HANDLE (h-bocx391) THEN RUN cxbo/bocx391.p PERSISTENT SET h-bocx391.
IF NOT VALID-HANDLE (h-boad098) THEN RUN adbo/boad098na.p PERSISTENT SET h-boad098.

RUN openQueryStatic IN h-bocx391 (INPUT 'Main':U).
RUN openQueryStatic IN h-boad098 (INPUT 'Main':U).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add-embalagem wWindow 
PROCEDURE pi-add-embalagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DISABLE btAddEmbalagem 
        btDelEmbalagem WITH FRAME fPage2.

ENABLE btCanEmbalagem 
       btSaveEmbalagem WITH FRAME fPage2.

ASSIGN tt-decla-imp-embal.cod-sig-embal          :READ-ONLY IN BROWSE brEmbalagem = NO
       tt-decla-imp-embal.qtd-vol-embal          :READ-ONLY IN BROWSE brEmbalagem = NO.

if  num-results("brEmbalagem") > 0 then do:
    find last tt-decla-imp-embal no-error.
    if  avail tt-decla-imp-embal then
        reposition brEmbalagem to rowid rowid(tt-decla-imp-embal) no-error.
    brEmbalagem:insert-row("after") in frame fPage2.
end.
else do trans:
    create tt-decla-imp-embal.
    open query brEmbalagem for each tt-decla-imp-embal.
    apply "entry":U to tt-decla-imp-embal.qtd-vol-embal in browse brEmbalagem. 
end.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-assign wWindow 
PROCEDURE pi-assign :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN INPUT FRAME fPage1 tt-decla-import.cdn-consign
           INPUT FRAME fPage1 tt-decla-import.log-fundap
           INPUT FRAME fPage1 tt-decla-import.cod-identif
           INPUT FRAME fPage1 tt-decla-import.cod-conhecto-house
           INPUT FRAME fPage1 tt-decla-import.cod-natur-operac
           INPUT FRAME fPage1 fi-cod-despachante.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-embalagens wWindow 
PROCEDURE pi-busca-embalagens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH tt-decla-imp-embal:
    DELETE tt-decla-imp-embal.
END.
IF AVAIL tt-decla-import THEN DO:
    FOR EACH tt-decla-imp-embal-aux:
        CREATE tt-decla-imp-embal.
        BUFFER-COPY tt-decla-imp-embal-aux TO tt-decla-imp-embal.
    END.
    
    {&OPEN-QUERY-brEmbalagem}
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-canc-embalagem wWindow 
PROCEDURE pi-canc-embalagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN pi-busca-embalagens.

ASSIGN tt-decla-imp-embal.cod-sig-embal          :READ-ONLY IN BROWSE brEmbalagem = YES
       tt-decla-imp-embal.qtd-vol-embal          :READ-ONLY IN BROWSE brEmbalagem = YES.

IF NOT CAN-FIND(FIRST tt-decla-imp-embal) THEN DO:
    ENABLE btAddEmbalagem WITH FRAME fPage2.
    DISABLE btCanEmbalagem btDelEmbalagem btSaveEmbalagem WITH FRAME fPage2.
END.
ELSE DO:
    ENABLE  btAddEmbalagem btDelEmbalagem WITH FRAME fPage2.
    DISABLE btCanEmbalagem btSaveEmbalagem    WITH FRAME fPage2.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exclui-embalagem wWindow 
PROCEDURE pi-exclui-embalagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF AVAIL tt-decla-imp-embal THEN DO:
    DO  i-cont = 1 TO brEmbalagem:NUM-SELECTED-ROWS IN FRAME fPage2:
        IF  brEmbalagem:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage2 THEN DO:  
            FOR FIRST tt-decla-imp-embal-aux OF tt-decla-imp-embal-aux:
                DELETE tt-decla-imp-embal-aux.
            END.
            DELETE tt-decla-imp-embal.
        END.
    END.
END.

{&OPEN-QUERY-brEmbalagem}

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva-embalagem wWindow 
PROCEDURE pi-salva-embalagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT CAN-FIND(FIRST tt-decla-imp-embal-aux
                    WHERE tt-decla-imp-embal-aux.num-di-ems       = tt-decla-import.num-di-ems
                    AND   tt-decla-imp-embal-aux.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
                    AND   tt-decla-imp-embal-aux.cod-sig-embal    = INPUT BROWSE brEmbalagem tt-decla-imp-embal.cod-sig-embal) THEN DO:
        CREATE tt-decla-imp-embal-aux.
        ASSIGN tt-decla-imp-embal-aux.num-di-ems       = tt-decla-import.num-di-ems
               tt-decla-imp-embal-aux.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
               tt-decla-imp-embal-aux.cod-sig-embal    = INPUT BROWSE brEmbalagem tt-decla-imp-embal.cod-sig-embal
               tt-decla-imp-embal-aux.qtd-vol-embal    = INPUT BROWSE brEmbalagem tt-decla-imp-embal.qtd-vol-embal. 
        DISABLE btCanEmbalagem 
                btSaveEmbalagem WITH FRAME fPage2.       
        ENABLE btAddEmbalagem 
               btDelEmbalagem WITH FRAME fPage2.  
        RUN pi-busca-embalagens.
        APPLY 'entry':U TO btAddEmbalagem IN FRAME fPage2.
    END.
    ELSE DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Embalagem_Declara‡Æo_Importa‡Æo" *}
        RUN utp/ut-msgs.p (INPUT 'show':U,
                        INPUT 1,
                        INPUT RETURN-VALUE).
    END.

    ASSIGN tt-decla-imp-embal.cod-sig-embal          :READ-ONLY IN BROWSE brEmbalagem = YES
           tt-decla-imp-embal.qtd-vol-embal          :READ-ONLY IN BROWSE brEmbalagem = YES.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-combos wWindow 
PROCEDURE pi-trata-combos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pLogGravarMostrar AS LOGICAL NO-UNDO.

    IF AVAIL tt-decla-import THEN
        IF pLogGravarMostrar THEN DO:
            ASSIGN cb-tipo-declaracao:screen-value  in frame fPage1 = {cxinc/i02cx383.i 04 tt-decla-import.idi-tip-decla-import}      
                   cb-carac-oper     :screen-value  in frame fPage1 = {cxinc/i03cx383.i 04 tt-decla-import.idi-caract-operac}  
                   cb-mod-desp       :screen-value  in frame fPage1 = {cxinc/i04cx383.i 04 tt-decla-import.idi-modalid-despch}
                   cb-via-transporte :screen-value  in frame fPage1 = {adinc/i01ad268.i 04 tt-decla-import.idi-via-transp-di}      
                   cb-docto-carg     :screen-value  in frame fPage1 = {cxinc/i06cx383.i 04 tt-decla-import.idi-docto-carg}  
                   cb-tipo-conhecto  :screen-value  in frame fPage1 = {cxinc/i07cx383.i 04 tt-decla-import.idi-tip-conhecto}
                   cb-ind-utiliz     :screen-value  in frame fPage1 = {cxinc/i08cx383.i 04 tt-decla-import.idi-ind-utiliz}.
        END.
        ELSE DO:
            ASSIGN INPUT FRAME fPage1 cb-tipo-declaracao
                   INPUT FRAME fPage1 cb-carac-oper
                   INPUT FRAME fPage1 cb-mod-desp
                   INPUT FRAME fPage1 cb-via-transporte
                   INPUT FRAME fPage1 cb-docto-carg    
                   INPUT FRAME fPage1 cb-tipo-conhecto 
                   INPUT FRAME fPage1 cb-ind-utiliz    
                   tt-decla-import.idi-tip-decla-import = {cxinc/i02cx383.i 06 cb-tipo-declaracao}
                   tt-decla-import.idi-caract-operac    = {cxinc/i03cx383.i 06 cb-carac-oper}
                   tt-decla-import.idi-modalid-despch   = {cxinc/i04cx383.i 06 cb-mod-desp}
                   tt-decla-import.idi-via-transp-di    = {adinc/i01ad268.i 06 cb-via-transporte}  
                   tt-decla-import.idi-docto-carg       = {cxinc/i06cx383.i 06 cb-docto-carg}       
                   tt-decla-import.idi-tip-conhecto     = {cxinc/i07cx383.i 06 cb-tipo-conhecto}         
                   tt-decla-import.idi-ind-utiliz       = {cxinc/i08cx383.i 06 cb-ind-utiliz}.

            RUN pi-trata-transporte.
            RUN pi-assign.
        END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-operacao wWindow 
PROCEDURE pi-trata-operacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-carac-oper AS INTEGER     NO-UNDO.

    ASSIGN INPUT FRAME fPage1 cb-carac-oper 
           i-carac-oper = {cxinc/i03cx383.i 06 cb-carac-oper}.

    IF i-carac-oper = 1 
        AND pcAction <> '' THEN DO:
        ASSIGN tt-decla-import.cdn-consign:SENSITIVE IN FRAME fPage1    = NO
               tt-decla-import.cdn-consign:SCREEN-VALUE IN FRAME fPage1 = "".        

        APPLY 'LEAVE':U TO tt-decla-import.cdn-consign IN FRAME fPage1.
    END.
    ELSE DO:
        IF pcAction <> '' THEN
            ASSIGN tt-decla-import.cdn-consign:SENSITIVE IN FRAME fPage1 = YES.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-transporte wWindow 
PROCEDURE pi-trata-transporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-via-transp AS INTEGER     NO-UNDO.
           
    ASSIGN i-via-transp = {cxinc/i03cx383.i 06 cb-carac-oper}.

    CASE i-via-transp:

        WHEN 1 THEN
            ASSIGN tt-decla-import.cdn-via-transp-di = 7
                   tt-decla-import.log-multimod      = NO.

        WHEN 2 THEN
            ASSIGN tt-decla-import.cdn-via-transp-di = 4
                   tt-decla-import.log-multimod      = YES.

        WHEN 3 THEN
            ASSIGN tt-decla-import.cdn-via-transp-di = 1
                   tt-decla-import.log-multimod      = NO.

        WHEN 4 THEN
            ASSIGN tt-decla-import.cdn-via-transp-di = 6
                   tt-decla-import.log-multimod      = NO.

        WHEN 5 THEN
            ASSIGN tt-decla-import.cdn-via-transp-di = 6
                   tt-decla-import.log-multimod      = YES.

        WHEN 6 THEN
            ASSIGN tt-decla-import.cdn-via-transp-di = 2
                   tt-decla-import.log-multimod      = YES.

        WHEN 7 THEN
            ASSIGN tt-decla-import.cdn-via-transp-di = 7
                   tt-decla-import.log-multimod      = YES.

        WHEN 8 THEN
            ASSIGN tt-decla-import.cdn-via-transp-di = 11
                   tt-decla-import.log-multimod      = NO.
               
    END CASE.

              
              
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-dados wWindow 
PROCEDURE pi-valida-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN INPUT FRAME fPage1 tt-decla-import.cod-natur-operac
       INPUT FRAME fPage1 tt-decla-import.cdn-consign
       INPUT FRAME fPage1 fi-cod-despachante
       INPUT FRAME fPage3 tt-decla-import.cod-inf-compltar.

IF tt-decla-import.cod-natur-operac <> "":U THEN DO:
    run findNatureza in h-boin245 (input tt-decla-import.cod-natur-operac,
                                   output c-return).
    IF c-return <> "":U THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Natureza_de_Opera‡Æo" *}
        RUN utp/ut-msgs.p (INPUT 'show':U,
                        INPUT 2,
                        INPUT RETURN-VALUE).
        RETURN "NOK":U.
    END.
END.

IF STRING(tt-decla-import.cdn-consign) <> "":U THEN DO:
    RUN openQueryStatic IN h-boad098 (INPUT 'Main':U).
    RUN goToKey         IN h-boad098 (INPUT tt-decla-import.cdn-consign).
    IF RETURN-VALUE = "NOK":U THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Consignat rio" *}
        RUN utp/ut-msgs.p (INPUT 'show':U,
                        INPUT 2,
                        INPUT RETURN-VALUE).
        RETURN "NOK":U.
    END.
END.    

IF fi-cod-despachante:SCREEN-VALUE IN FRAME fPage1 <> "0":U THEN DO:
    RUN openQueryStatic IN h-boad098 (INPUT 'Main':U).
    RUN goToKey         IN h-boad098 (INPUT INT(fi-cod-despachante:SCREEN-VALUE IN FRAME fPage1)).
    IF RETURN-VALUE = "NOK":U THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Despachante" *}
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 2,
                           INPUT RETURN-VALUE).
        RETURN "NOK":U.
    END.
END.  
ASSIGN OVERLAY(tt-decla-import.cod-livre-1,3,9) = fi-cod-despachante:SCREEN-VALUE IN FRAME fPage1.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wWindow 
PROCEDURE saveParentFields :
/*------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

