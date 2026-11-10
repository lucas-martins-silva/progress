&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI 
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          emscda           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-af-grp-resp-usuario NO-UNDO LIKE af-grp-resp-usuario
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-af-grp-responsavel NO-UNDO LIKE af-grp-responsavel
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-usuar-mater NO-UNDO LIKE usuar-mater
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0112 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AF0112
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE Folder         no

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            YES
&GLOBAL-DEFINE Copy           YES
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         YES
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        tt-af-grp-responsavel
&GLOBAL-DEFINE hDBOTable      h-boaf019
&GLOBAL-DEFINE DBOTable       af-grp-responsavel

&GLOBAL-DEFINE page0KeyFields tt-af-grp-responsavel.cod-grp-resp

&GLOBAL-DEFINE page0Fields tt-af-grp-responsavel.des-grp-resp

/* Local Variable Definitions ---                                       */
define variable c-nome-usuario as character format "x(40)":U no-undo.
define variable c-nome-usuar   as character format "x(40)":U no-undo.
define variable iNrRegistro    as integer                    no-undo.
define variable r-row          as rowid                      no-undo.

/* Local Variable Definitions (DBOs Handles) --- */
define variable {&hDBOTable} as handle no-undo.
define variable h-boaf020    as handle no-undo.
define variable h-boin627na  as handle no-undo.

{afbo/boaf020.i tt-af-grp-resp-usuario-aux}

{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brSource

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-usuar-mater tt-af-grp-resp-usuario

/* Definitions for BROWSE brSource                                      */
&Scoped-define FIELDS-IN-QUERY-brSource tt-usuar-mater.cod-usuario ~
tt-usuar-mater.nome-usuar 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSource 
&Scoped-define QUERY-STRING-brSource FOR EACH tt-usuar-mater NO-LOCK
&Scoped-define OPEN-QUERY-brSource OPEN QUERY brSource FOR EACH tt-usuar-mater NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSource tt-usuar-mater
&Scoped-define FIRST-TABLE-IN-QUERY-brSource tt-usuar-mater


/* Definitions for BROWSE brTarget                                      */
&Scoped-define FIELDS-IN-QUERY-brTarget tt-af-grp-resp-usuario.cod-usuario ~
tt-af-grp-resp-usuario.log-envia-email fn_nome_usuario() @ c-nome-usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTarget 
&Scoped-define QUERY-STRING-brTarget FOR EACH tt-af-grp-resp-usuario NO-LOCK
&Scoped-define OPEN-QUERY-brTarget OPEN QUERY brTarget FOR EACH tt-af-grp-resp-usuario NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTarget tt-af-grp-resp-usuario
&Scoped-define FIRST-TABLE-IN-QUERY-brTarget tt-af-grp-resp-usuario


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brSource}~
    ~{&OPEN-QUERY-brTarget}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-af-grp-responsavel.cod-grp-resp ~
tt-af-grp-responsavel.des-grp-resp 
&Scoped-define ENABLED-TABLES tt-af-grp-responsavel
&Scoped-define FIRST-ENABLED-TABLE tt-af-grp-responsavel
&Scoped-Define ENABLED-OBJECTS btFirst btPrev btNext btLast btGoTo btSearch ~
btAdd btCopy btUpdate btDelete btUndo btCancel btSave btQueryJoins ~
btReportsJoins btExit btHelp brSource brTarget btAddAllTarget btAddTarget ~
btDelTarget btDelAllTarget btUpdateTarget bt-filtro-usuario ~
c-filtro-usuario RECT-1 rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-af-grp-responsavel.cod-grp-resp ~
tt-af-grp-responsavel.des-grp-resp 
&Scoped-define DISPLAYED-TABLES tt-af-grp-responsavel
&Scoped-define FIRST-DISPLAYED-TABLE tt-af-grp-responsavel
&Scoped-Define DISPLAYED-OBJECTS c-filtro-usuario 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn_nome_usuario wMaintenance 
FUNCTION fn_nome_usuario RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miUndo         LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
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
DEFINE BUTTON bt-filtro-usuario 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "Button 1" 
     SIZE 4 BY 1.

DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image~\im-add":U
     IMAGE-INSENSITIVE FILE "image~\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btAddAllTarget 
     IMAGE-UP FILE "image~\add-all":U
     IMAGE-INSENSITIVE FILE "image~\ii-add-all":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Inclui Todos".

DEFINE BUTTON btAddTarget 
     IMAGE-UP FILE "image/next-au":U
     IMAGE-INSENSITIVE FILE "image/next-ai":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Inclui".

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image~\im-can":U
     IMAGE-INSENSITIVE FILE "image~\im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image~\im-copy":U
     IMAGE-INSENSITIVE FILE "image~\ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelAllTarget 
     IMAGE-UP FILE "image~\del-all":U
     IMAGE-INSENSITIVE FILE "image~\ii-del-all":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Retira Todos".

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image~\im-era":U
     IMAGE-INSENSITIVE FILE "image~\ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelTarget 
     IMAGE-UP FILE "image/prev-au":U
     IMAGE-INSENSITIVE FILE "image/prev-ai":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Retira".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image~\im-exi":U
     IMAGE-INSENSITIVE FILE "image~\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image~\im-fir":U
     IMAGE-INSENSITIVE FILE "image~\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image~\im-enter":U
     IMAGE-INSENSITIVE FILE "image~\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image~\im-hel":U
     IMAGE-INSENSITIVE FILE "image~\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image~\im-las":U
     IMAGE-INSENSITIVE FILE "image~\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image~\im-nex":U
     IMAGE-INSENSITIVE FILE "image~\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image~\im-pre":U
     IMAGE-INSENSITIVE FILE "image~\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image~\im-joi":U
     IMAGE-INSENSITIVE FILE "image~\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image~\im-pri":U
     IMAGE-INSENSITIVE FILE "image~\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image~\im-sav":U
     IMAGE-INSENSITIVE FILE "image~\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUndo 
     IMAGE-UP FILE "image~\im-undo":U
     IMAGE-INSENSITIVE FILE "image~\ii-undo":U
     LABEL "Undo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image~\im-mod":U
     IMAGE-INSENSITIVE FILE "image~\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdateTarget 
     LABEL "&Recebe E-mail?" 
     SIZE 12.72 BY 1.

DEFINE VARIABLE c-filtro-usuario AS CHARACTER FORMAT "X(12)":U 
     LABEL "Usu rio" 
     VIEW-AS FILL-IN 
     SIZE 14.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 12.75.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSource FOR 
      tt-usuar-mater SCROLLING.

DEFINE QUERY brTarget FOR 
      tt-af-grp-resp-usuario SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSource wMaintenance _STRUCTURED
  QUERY brSource NO-LOCK DISPLAY
      tt-usuar-mater.cod-usuario FORMAT "X(12)":U WIDTH 13
      tt-usuar-mater.nome-usuar COLUMN-LABEL "Nome Usu rio" FORMAT "X(40)":U
            WIDTH 40
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 37.57 BY 11
         FONT 1
         TITLE "Usu rio de Materiais" EXPANDABLE.

DEFINE BROWSE brTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTarget wMaintenance _STRUCTURED
  QUERY brTarget NO-LOCK DISPLAY
      tt-af-grp-resp-usuario.cod-usuario FORMAT "X(12)":U WIDTH 13
      tt-af-grp-resp-usuario.log-envia-email FORMAT "Sim/NÆo":U
            WIDTH 10
      fn_nome_usuario() @ c-nome-usuario COLUMN-LABEL "Nome Usu rio" FORMAT "x(40)":U
            WIDTH 30
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 37.57 BY 11
         FONT 1
         TITLE "Usu rio Respons vel pela Avalia‡Æo" EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrˆncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrˆncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrˆncia"
     btLast AT ROW 1.13 COL 13.57 HELP
          "éltima ocorrˆncia"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V  Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrˆncia"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrˆncia corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrˆncia corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrˆncia corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz altera‡äes"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela altera‡äes"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma altera‡äes"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-af-grp-responsavel.cod-grp-resp AT ROW 3.33 COL 21.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     tt-af-grp-responsavel.des-grp-resp AT ROW 3.33 COL 34.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 50 BY .88
     brSource AT ROW 5.5 COL 3.43
     brTarget AT ROW 5.5 COL 51
     btAddAllTarget AT ROW 8.75 COL 42.29
     btAddTarget AT ROW 9.92 COL 42.29
     btDelTarget AT ROW 11.04 COL 42.29
     btDelAllTarget AT ROW 12.17 COL 42.29
     btUpdateTarget AT ROW 16.5 COL 51
     bt-filtro-usuario AT ROW 16.54 COL 24
     c-filtro-usuario AT ROW 16.58 COL 7.43 COLON-ALIGNED
     RECT-1 AT ROW 4.96 COL 1
     rtKeys AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.71
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-af-grp-resp-usuario T "?" NO-UNDO emscda af-grp-resp-usuario
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-af-grp-responsavel T "?" NO-UNDO emscda af-grp-responsavel
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-usuar-mater T "?" NO-UNDO mgind usuar-mater
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
         HEIGHT             = 16.71
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brSource des-grp-resp fpage0 */
/* BROWSE-TAB brTarget brSource fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSource
/* Query rebuild information for BROWSE brSource
     _TblList          = "Temp-Tables.tt-usuar-mater"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-usuar-mater.cod-usuario
"tt-usuar-mater.cod-usuario" ? ? "character" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" ""
     _FldNameList[2]   > Temp-Tables.tt-usuar-mater.nome-usuar
"tt-usuar-mater.nome-usuar" "Nome Usu rio" ? "character" ? ? ? ? ? ? no ? no no "40" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brSource */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTarget
/* Query rebuild information for BROWSE brTarget
     _TblList          = "Temp-Tables.tt-af-grp-resp-usuario"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-af-grp-resp-usuario.cod-usuario
"tt-af-grp-resp-usuario.cod-usuario" ? ? "character" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" ""
     _FldNameList[2]   > Temp-Tables.tt-af-grp-resp-usuario.log-envia-email
"tt-af-grp-resp-usuario.log-envia-email" ? ? "logical" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" ""
     _FldNameList[3]   > "_<CALC>"
"fn_nome_usuario() @ c-nome-usuario" "Nome Usu rio" "x(40)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brTarget */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
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


&Scoped-define SELF-NAME bt-filtro-usuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtro-usuario wMaintenance
ON CHOOSE OF bt-filtro-usuario IN FRAME fpage0 /* Button 1 */
DO:
    
    find tt-usuar-mater 
        where tt-usuar-mater.cod-usuario = input frame fPage0 c-filtro-usuario no-error.
    if  avail tt-usuar-mater then do:

        assign r-row = rowid (tt-usuar-mater).
        reposition brSource to rowid r-row no-error.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddAllTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddAllTarget wMaintenance
ON CHOOSE OF btAddAllTarget IN FRAME fpage0
DO:
    empty temp-table RowErrors.

    for each tt-usuar-mater:

        if  not can-find (first tt-af-grp-resp-usuario
                          where tt-af-grp-resp-usuario.cod-usuario = tt-usuar-mater.cod-usuario) then do:
            run AddTarget in this-procedure.
            if  return-value = "NOK" then
                next.
        end.
    end.

    if  can-find(first RowErrors) then do:
        /*--- Inicializa tela de mensagens de erros ---*/
        {method/ShowMessage.i1}

        /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
        {method/ShowMessage.i2 &Modal="YES"}
    end.

    run OpenQueries in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddTarget wMaintenance
ON CHOOSE OF btAddTarget IN FRAME fpage0
DO:
    
  if  avail tt-usuar-mater then do:

      empty temp-table RowErrors.
      
      if  not can-find (first tt-af-grp-resp-usuario
                        where tt-af-grp-resp-usuario.cod-usuario = tt-usuar-mater.cod-usuario) then do:

          run AddTarget in this-procedure.
          if  return-value = "NOK" then do:
              /*--- Inicializa tela de mensagens de erros ---*/
              {method/ShowMessage.i1}
                
              /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
              {method/ShowMessage.i2 &Modal"Yes"}
              return no-apply.
          end.
      end.

      run OpenQueries in this-procedure.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN cancelRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fpage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelAllTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelAllTarget wMaintenance
ON CHOOSE OF btDelAllTarget IN FRAME fpage0
DO:
    run DelAllTarget in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelTarget wMaintenance
ON CHOOSE OF btDelTarget IN FRAME fpage0
DO:    
    if  avail tt-af-grp-resp-usuario then do:
        run DelTarget   in this-procedure.
        run OpenQueries in this-procedure.
    end. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fpage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fpage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:
    RUN saveRecord IN THIS-PROCEDURE.
    RUN cancelRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/ZoomReposition.i &ProgramZoom="afzoom/z01af019.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fpage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    RUN undoRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdateTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateTarget wMaintenance
ON CHOOSE OF btUpdateTarget IN FRAME fpage0 /* Recebe E-mail? */
DO:

    if  avail tt-af-grp-resp-usuario then do:

        /*--- Seta cursor do mouse para espera ---*/
        session:set-wait-state("GENERAL":U).

        /*--- Limpa temp-table RowErrors no DBO ---*/
        run emptyRowErrors in h-boaf020.

        /*--- Limpa temp-table auxiliar ---*/
        empty temp-table tt-af-grp-resp-usuario-aux.

        assign tt-af-grp-resp-usuario.log-envia-email = if  tt-af-grp-resp-usuario.log-envia-email then no
                                                        else yes.
    
        create tt-af-grp-resp-usuario-aux.
        buffer-copy  tt-af-grp-resp-usuario to  tt-af-grp-resp-usuario-aux.

        /*--- Reposiciona DBO filho atrav‚s do rowid do registro corrente selecionado ---*/
        run repositionRecord in h-boaf020 (input tt-af-grp-resp-usuario-aux.r-Rowid).

        /*--- Limpa a temp-table RowObject no DBO filho ---*/
        run emptyRowObject in h-boaf020.

        /*--- Transfere temp-table tt-af-grp-resp-usuario para o DBO ---*/
        run setRecord in h-boaf020 (input table tt-af-grp-resp-usuario-aux).
        
        /*--- Altera registro corrente do DBO filho ---*/
        run updateRecord in h-boaf020.
        if  return-value = "NOK":U then do:
    
            run getRowErrors in h-boaf020 (output table RowErrors).
    
            /*--- Inicializa tela de mensagens de erros ---*/
            {method/ShowMessage.i1}
    
            /*--- Descri‡Æo dos erros:
                  8: Query est  vazia 
                  10: Query est  posicionada no £ltimo registro ---*/
            if  can-find(first RowErrors 
                         where (RowErrors.ErrorType = "INTERNAL":U)
                         and   (RowErrors.ErrorNumber = 8)) then do:
                /*--- Seta estado dos botäes ---*/
                do  with frame fPage0:
                    assign btDelTarget:sensitive    = no
                           btDelAllTarget:sensitive = no
                           btUpdateTarget:sensitive = no.
                end.
            end.
    
            if  not can-find(first RowErrors
                             where (RowErrors.ErrorType = "INTERNAL":U) 
                             and   (RowErrors.ErrorNumber = 10)) then do:
    
                /*--- Seta cursor do mouse para normal ---*/
                session:set-wait-state("":U).
    
                /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
                {method/ShowMessage.i2 &Modal="yes"}
    
                return "NOK".
            end.
        end.

        browse brTarget:refresh().

        session:set-wait-state("":U).
    end.

    return "OK":U.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSource
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addTarget wMaintenance 
PROCEDURE addTarget :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*--- Seta cursor do mouse para espera ---*/
    session:set-wait-state("GENERAL":U).
    
    /*--- Limpa temp-table RowErrors no DBO ---*/
    run emptyRowErrors in h-boaf020.

    AddRecords:
    do transaction on error undo, leave:

        /*--- Cria novo registro para temp-table tt-af-grp-resp-usuario no DBO ---*/
        run newRecord in h-boaf020.
        
        /*--- Retorna registro da temp-table tt-af-grp-resp-usuario do DBO ---*/
        run getRecord in h-boaf020 (output table tt-af-grp-resp-usuario).
        
        /*--- Posiciona o registro ---*/
        find first tt-af-grp-resp-usuario no-error. 
        assign tt-af-grp-resp-usuario.log-envia-email =  yes.
                                                        
        /*--- Salva os Campos chaves da Temp-Table forma‡Æo ---*/
        run SaveParentFields in this-procedure.
        
        /*--- Transfere temp-table tt-af-grp-resp-usuario para o DBO ---*/
        run setRecord in h-boaf020 (input table tt-af-grp-resp-usuario).
        
        /*--- Cria um novo registro ---*/
        run createRecord in h-boaf020.
        
        /*--- Verifica ocorrˆncia de erros durante a grava‡Æo ---*/
        if  return-value = "NOK":U then do:
    
            /*--- Retorna temp-table RowErrors do DBO ---*/
            run getRowErrors in h-boaf020 (output table RowErrors).
                
            /*--- Inicializa tela de mensagens de erros ---*/
            {method/ShowMessage.i1}
                
            /*--- Seta cursor do mouse para normal ---*/
            session:set-wait-state("":U).
                
            /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
            {method/ShowMessage.i2 &Modal="YES"}
            
            undo AddRecords, leave AddRecords.
        end.
        else
            /*--- Elimina Janela de mensagens de erros ---*/
            {method/ShowMessage.i3}
    end.

    session:set-wait-state("":U).

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisableFields wMaintenance 
PROCEDURE afterDisableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    run openQueries in this-procedure.

    return "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    run openQueries in this-procedure.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenance 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    disable btAddTarget btAddAllTarget btDelTarget btDelAllTarget with frame fPage0.

    return "OK":U.
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
    enable brSource brTarget c-filtro-usuario bt-filtro-usuario with frame fPage0.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenance 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    assign tt-af-grp-responsavel.ep-codigo = i-ep-codigo-usuario.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE delAllTarget wMaintenance 
PROCEDURE delAllTarget :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*--- Seta cursor do mouse para espera ---*/
    session:set-wait-state("GENERAL":U).

    /*--- Limpa temp-table RowErrors no DBO ---*/
    run emptyRowErrors in h-boaf020.

    /*--- Posiciona DBO primeiro registro ---*/
    run getFirst in h-boaf020.

    /*--- Retorna faixa de registro do DBO ---*/
    run getBatchRecords in h-boaf020 (input ?,
                                      input no,
                                      input ?,
                                      output iNrRegistro,
                                      output table tt-af-grp-resp-usuario).

    /*--- Deleta os registros na tabela forma‡Æo ---*/
    DelRecords:
    do  transaction on error undo, leave:

        for each tt-af-grp-resp-usuario:          

            /*--- Reposiciona DBO filho atrav‚s do rowid do registro corrente selecionado ---*/
            run repositionRecord in h-boaf020 (input tt-af-grp-resp-usuario.r-Rowid).

            /*--- Elima registro corrente do DBO filho ---*/
            run deleteRecord in h-boaf020.
            if  return-value = "NOK":U then do:

                run getRowErrors in h-boaf020 (output table RowErrors).

                /*--- Inicializa tela de mensagens de erros ---*/
                {method/ShowMessage.i1}        

                /*--- Descri‡Æo dos erros:
                      8: Query est  vazia 
                      10: Query est  posicionada no £ltimo registro ---*/
                if  can-find(first RowErrors 
                             where (RowErrors.ErrorType   = "INTERNAL":U) 
                             and   (RowErrors.ErrorNumber = 8)) then do:

                    /*--- Seta estado dos botäes ---*/
                    do  with frame fPage0:
                        assign btDelTarget:sensitive    = no
                               btDelAllTarget:sensitive = no.
                    end.

                    /*--- Seta cursor do mouse para normal ---*/
                    session:set-wait-state("":U).

                    next.
                end.

                if  not can-find(first RowErrors
                                 where (RowErrors.ErrorType   = "INTERNAL":U) 
                                 and   (RowErrors.ErrorNumber = 10)) then do:

                    /*--- Seta cursor do mouse para normal ---*/
                    session:set-wait-state("":U).

                    /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
                    {method/ShowMessage.i2}

                    Undo DelRecords, leave DelRecords.
                end.
            end.
        end. /*--- For Each ---*/
    end. /*--- Transaction ---*/            

    run OpenQueries in this-procedure.

    session:set-wait-state("":U).

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE delTarget wMaintenance 
PROCEDURE delTarget :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*--- Seta cursor do mouse para espera ---*/
    session:set-wait-state("GENERAL":U).

    /*--- Limpa temp-table RowErrors no DBO ---*/
    run emptyRowErrors in h-boaf020.

    /*--- Reposiciona DBO filho atrav‚s do rowid do registro corrente selecionado ---*/
    run repositionRecord in h-boaf020 (input tt-af-grp-resp-usuario.r-Rowid).

    /*--- Elima registro corrente do DBO filho ---*/
    run deleteRecord in h-boaf020.
    if  return-value = "NOK":U then do:

        run getRowErrors in h-boaf020 (output table RowErrors).

        /*--- Inicializa tela de mensagens de erros ---*/
        {method/ShowMessage.i1}

        /*--- Descri‡Æo dos erros:
              8: Query est  vazia 
              10: Query est  posicionada no £ltimo registro ---*/
        if  can-find(first RowErrors 
                     where (RowErrors.ErrorType = "INTERNAL":U)
                     and   (RowErrors.ErrorNumber = 8)) then do:
            /*--- Seta estado dos botäes ---*/
            do  with frame fPage0:
                assign btDelTarget:sensitive    = no
                       btDelAllTarget:sensitive = no
                       btUpdateTarget:sensitive = no.
            end.
        end.

        if  not can-find(first RowErrors
                         where (RowErrors.ErrorType = "INTERNAL":U) 
                         and   (RowErrors.ErrorNumber = 10)) then do:

            /*--- Seta cursor do mouse para normal ---*/
            session:set-wait-state("":U).

            /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
            {method/ShowMessage.i2}

            return "NOK".
        end.
    end.

    /*--- Elimina a linha corrente do browse filho ---*/
    delete tt-af-grp-resp-usuario.
    brTarget:delete-current-row() in frame fPage0.

    if  num-results("brTarget":U) = 0 then
       apply 'UP':U to brTarget.

    session:set-wait-state("":U).

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecordsSource wMaintenance 
PROCEDURE getRecordsSource :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /*--- brSource ---*/
    if  valid-handle (h-boin627na) 
    and avail tt-af-grp-responsavel then do:

        run openQueryStatic in h-boin627na (input "Main":U).

        run getBatchRecords in h-boin627na (?,
                                            no,
                                            ?, 
                                            output iNrRegistro,
                                            output table tt-usuar-mater).

        for each tt-usuar-mater:

            if  can-find (first tt-af-grp-resp-usuario
                              where tt-af-grp-resp-usuario.ep-codigo    = tt-af-grp-responsavel.ep-codigo
                              and   tt-af-grp-resp-usuario.cod-grp-resp = tt-af-grp-responsavel.cod-grp-resp
                              and   tt-af-grp-resp-usuario.cod-usuario  = tt-usuar-mater.cod-usuario) then
                delete tt-usuar-mater.
        end.
    end.

    open query brSource for each tt-usuar-mater.
    
    return "OK":U.
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


    DEFINE RECTANGLE rtCodGrpResp
        EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
        SIZE 58 BY 2.30.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE cCodGrpResp LIKE {&ttTable}.cod-grp-resp 
        VIEW-AS FILL-IN SIZE 13 BY .88 NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        rtCodGrpResp      at row 1.08 col 1
        cCodGrpResp       AT ROW 1.73 COL 25 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Grupo Respons vel" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
    
    
    ON  "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cCodGrpResp.
        
        RUN goToKey IN {&hDBOTable} (INPUT cCodGrpResp).
        IF  RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Grupo_Respons vel" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 2,
                               INPUT RETURN-VALUE).
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cCodGrpResp btGoToOK btGoToCancel WITH FRAME fGoToRecord. 
    
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
    
    /*:T--- Tabela af-grp-responsavel ---*/                                                    
    if  not valid-handle({&hDBOTable})
    or  {&hDBOTable}:type      <> "PROCEDURE":U
    or  {&hDBOTable}:file-name <> "afbo/boaf019.p":U
    or  {&hDBOTable}:file-name <> "afbo/boaf019.r":U then do:
        run afbo/boaf019.p persistent set h-boaf019.
    end.
    
    run openQueryStatic in {&hDBOTable} (input "ByEmpresa":U) no-error.

    /*:T--- Tabela usuar-mater ---*/                                                    
    if  not valid-handle(h-boin627na)
    or  {&hDBOTable}:type      <> "PROCEDURE":U
    or  {&hDBOTable}:file-name <> "inbo/boin627na.p":U
    or  {&hDBOTable}:file-name <> "inbo/boin627na.r":U then
        run inbo/boin627na.p persistent set h-boin627na.

    /*:T--- Tabela gf-grp-resp-usuario ---*/                                                    
    if  not valid-handle(h-boaf020)
    or  {&hDBOTable}:type      <> "PROCEDURE":U
    or  {&hDBOTable}:file-name <> "afbo/boaf020.p":U
    or  {&hDBOTable}:file-name <> "afbo/boaf020.r":U then
        run afbo/boaf020.p persistent set h-boaf020.

    run openQueryStatic in h-boaf020 (input "Main":U) no-error.    

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueries wMaintenance 
PROCEDURE OpenQueries :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*--- brTarget ---*/

    /*--- Faz a liga‡Æo entre o DBO filho e o DBO pai ---*/
    run linkToGrupoResponsavel in h-boaf020 (input {&hDBOTable}).

    /*--- Abre query do DBO filho ---*/
    run openQueryStatic in h-boaf020 (input "ByGrupoResponsavel":U).

    /*--- Retorna faixa de registro do DBO Filho ---*/
    run getBatchRecords IN h-boaf020 (input ?,
                                      input no,
                                      input ?,
                                      output iNrRegistro,
                                      output table tt-af-grp-resp-usuario).

    /*--- Abre a query associada ao browse  ---*/
    {&OPEN-QUERY-brTarget}
    apply "VALUE-CHANGED":U to browse brTarget.

    /*--- Seta estado dos botäes relacionados ao browse ---*/
    if  avail tt-af-grp-resp-usuario then
        assign btUpdateTarget:sensitive in frame fPage0 = yes
               btDelTarget:sensitive    in frame fPage0 = yes
               btDelAllTarget:sensitive in frame fPage0 = yes.
    else
        assign btUpdateTarget:sensitive in frame fPage0 = no
               btDelTarget:sensitive    in frame fPage0 = no
               btDelAllTarget:sensitive in frame fPage0 = no.

    /*--- brSource ---*/
    run getRecordsSource.

    if  num-results("brSource":U) > 0 then
        enable btAddTarget btAddAllTarget with frame fPage0.
    else
        disable btAddTarget btAddAllTarget with frame fPage0.                               
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenance 
PROCEDURE saveParentFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign tt-af-grp-resp-usuario.ep-codigo    = i-ep-codigo-usuario
           tt-af-grp-resp-usuario.cod-grp-resp = tt-af-grp-responsavel.cod-grp-resp
           tt-af-grp-resp-usuario.cod-usuario  = tt-usuar-mater.cod-usuario.       

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn_nome_usuario wMaintenance 
FUNCTION fn_nome_usuario RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    if  valid-handle (h-boin627na) then do:

        run openQueryStatic in h-boin627na (input "Main":U).
        run goToKey         in h-boin627na (input tt-af-grp-resp-usuario.cod-usuario).
        if  return-value = "OK":U then do:

            run getCharField in h-boin627na (input  "nome-usuar":U,
                                                output c-nome-usuar).
        end.
    end.
    else 
        assign c-nome-usuar = "":U.
  
    return c-nome-usuar.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

