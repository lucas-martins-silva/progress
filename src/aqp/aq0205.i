&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-pto-coleta NO-UNDO LIKE pto-coleta
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
{include/i-prgvrs.i AQ0205 2.00.00.012 } /*** 010012 ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i {1} MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        {1}
&GLOBAL-DEFINE Version        2.00.00.009

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            {2}
&GLOBAL-DEFINE Copy           {2}
&GLOBAL-DEFINE Update         {2}
&GLOBAL-DEFINE Delete         {2}
&GLOBAL-DEFINE Undo           {2}
&GLOBAL-DEFINE Undo           {2}
&GLOBAL-DEFINE Cancel         {2}
&GLOBAL-DEFINE Save           {2}

&GLOBAL-DEFINE ttTable        tt-pto-coleta
&GLOBAL-DEFINE hDBOTable      h-boin00966
&GLOBAL-DEFINE DBOTable       pto-coleta

&GLOBAL-DEFINE page0KeyFields tt-pto-coleta.cod-pto-coleta 
&GLOBAL-DEFINE page0Fields    tt-pto-coleta.des-pto-coleta
&GLOBAL-DEFINE page1Fields    tt-pto-coleta.cod-propried tt-pto-coleta.cod-regiao ~
                              tt-pto-coleta.val-media tt-pto-coleta.qtd-distan-km tt-pto-coleta.cod-un tt-pto-coleta.frequencia ~
                              tt-pto-coleta.val-latitude tt-pto-coleta.val-longitude tt-pto-coleta.des-obs
&GLOBAL-DEFINE page2Fields    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin122    AS HANDLE NO-UNDO.   
DEFINE VARIABLE h-boin417na  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00980  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00977  AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-text      AS HANDLE NO-UNDO.

DEFINE VARIABLE wh-pesquisa  AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl       AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gr-pto-coleta-aq0205 AS ROWID  NO-UNDO.

DEFINE VARIABLE c-cod-pto-coleta AS CHARACTER  NO-UNDO.
DEFINE VARIABlE l-consulta       AS LOGICAL    NO-UNDO.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-pto-coleta.cod-pto-coleta ~
tt-pto-coleta.des-pto-coleta 
&Scoped-define ENABLED-TABLES tt-pto-coleta
&Scoped-define FIRST-ENABLED-TABLE tt-pto-coleta
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave btPtoColetaCol btRepositorio btQueryJoins btReportsJoins btExit ~
btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-pto-coleta.cod-pto-coleta ~
tt-pto-coleta.des-pto-coleta 
&Scoped-define DISPLAYED-TABLES tt-pto-coleta
&Scoped-define FIRST-DISPLAYED-TABLE tt-pto-coleta


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

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
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image/im-add":U
     IMAGE-INSENSITIVE FILE "image/ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image/im-can":U
     IMAGE-INSENSITIVE FILE "image/im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image/im-copy":U
     IMAGE-INSENSITIVE FILE "image/ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image/im-era":U
     IMAGE-INSENSITIVE FILE "image/ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image/im-fir":U
     IMAGE-INSENSITIVE FILE "image/ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image/im-enter":U
     IMAGE-INSENSITIVE FILE "image/ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image/im-las":U
     IMAGE-INSENSITIVE FILE "image/ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image/im-nex":U
     IMAGE-INSENSITIVE FILE "image/ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image/im-pre":U
     IMAGE-INSENSITIVE FILE "image/ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPtoColetaCol 
     IMAGE-UP FILE "image/im-grupo.bmp":U
     LABEL "Produtores do Ponto de Coleta" 
     SIZE 4 BY 1.25 TOOLTIP "Produtores do Ponto de Coleta".

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

DEFINE BUTTON btRepositorio 
     IMAGE-UP FILE "image/im-cone.bmp":U
     LABEL "Reposit¢rios" 
     SIZE 4 BY 1.25 TOOLTIP "Reposit¢rios".

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image/im-sav":U
     IMAGE-INSENSITIVE FILE "image/ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUndo 
     IMAGE-UP FILE "image/im-undo":U
     IMAGE-INSENSITIVE FILE "image/ii-undo":U
     LABEL "Undo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image/im-mod":U
     IMAGE-INSENSITIVE FILE "image/ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE c-desc-freq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-propried AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-regiao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-un AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.72 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrància"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrància corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrància corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz alteraá‰es"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela alteraá‰es"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma alteraá‰es"
     btPtoColetaCol AT ROW 1.13 COL 62.86 HELP
          "Pesquisa" WIDGET-ID 8
     btRepositorio AT ROW 1.13 COL 67.29 HELP
          "Pesquisa" WIDGET-ID 10
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-pto-coleta.cod-pto-coleta AT ROW 3.38 COL 19.14 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tt-pto-coleta.des-pto-coleta AT ROW 3.38 COL 33.57 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 38.86 BY .88
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tt-pto-coleta.cod-propried AT ROW 1.5 COL 12.72 COLON-ALIGNED WIDGET-ID 4 FORMAT "x(16)"
          VIEW-AS FILL-IN 
          SIZE 19.29 BY .88
     c-desc-propried AT ROW 1.5 COL 32.29 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     tt-pto-coleta.cod-regiao AT ROW 2.5 COL 12.72 COLON-ALIGNED WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-desc-regiao AT ROW 2.5 COL 25.57 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     tt-pto-coleta.val-media AT ROW 3.5 COL 12.72 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 14.29 BY .88
     tt-pto-coleta.cod-un AT ROW 3.5 COL 41 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .88
     c-desc-un AT ROW 3.5 COL 46.57 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     tt-pto-coleta.qtd-distan-km AT ROW 4.5 COL 17.43 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .88
     tt-pto-coleta.frequencia AT ROW 5.5 COL 12.86 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-desc-freq AT ROW 5.5 COL 18.14 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     tt-pto-coleta.val-latitude AT ROW 6.5 COL 12.86 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 11.14 BY .88
     tt-pto-coleta.val-longitude AT ROW 6.5 COL 35.72 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .88
     tt-pto-coleta.des-obs AT ROW 7.58 COL 14.86 NO-LABEL WIDGET-ID 20
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 66.29 BY 3.75
     "Observaá∆o:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 7.58 COL 5.57 WIDGET-ID 30
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.38
         SIZE 84.43 BY 11.63
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
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
  CREATE WINDOW wMaintenance ASSIGN
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
/* SETTINGS FOR FILL-IN tt-pto-coleta.cod-propried IN FRAME fPage1
   EXP-FORMAT                                                           */
ASSIGN 
       tt-pto-coleta.des-obs:READ-ONLY IN FRAME fPage1        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

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


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    IF NOT l-consulta THEN
        RUN addRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    IF NOT l-consulta THEN
        RUN cancelRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fpage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    IF NOT l-consulta THEN
        RUN copyRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    IF NOT l-consulta THEN
        RUN deleteRecord IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btPtoColetaCol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPtoColetaCol wMaintenance
ON CHOOSE OF btPtoColetaCol IN FRAME fpage0 /* Produtores do Ponto de Coleta */
DO:
    DO WITH FRAME fpage0:
        
        SESSION:SET-WAIT-STATE("general").
        ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
        
        IF AVAIL tt-pto-coleta THEN
            RUN aqp/aq0205a.w(INPUT tt-pto-coleta.r-rowid,
                              INPUT THIS-PROCEDURE).
        
        SESSION:SET-WAIT-STATE("").
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    END.
    
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


&Scoped-define SELF-NAME btRepositorio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRepositorio wMaintenance
ON CHOOSE OF btRepositorio IN FRAME fpage0 /* Reposit¢rios */
DO:
    DO WITH FRAME fpage0:

        ASSIGN gr-pto-coleta-aq0205 = tt-pto-coleta.r-rowid.
        
        SESSION:SET-WAIT-STATE("general").
        ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
        
        RUN aqp/aq0210.w.
        
        SESSION:SET-WAIT-STATE("").
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:
    IF NOT l-consulta THEN
        RUN saveRecord IN THIS-PROCEDURE.           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="inzoom/z01in00966.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fpage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    IF NOT l-consulta THEN
        RUN undoRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    IF NOT l-consulta THEN
        RUN updateRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-pto-coleta.cod-propried
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-propried wMaintenance
ON F5 OF tt-pto-coleta.cod-propried IN FRAME fPage1 /* Propriedade */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z01in00980.w"
                       &FieldZoom1="cod-propried"
                       &FieldScreen1="tt-pto-coleta.cod-propried"
                       &Frame1="fpage1"
                       &FieldZoom2="des-propried"
                       &FieldScreen2="c-desc-propried"
                       &Frame2="fpage1"
                       &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-propried wMaintenance
ON LEAVE OF tt-pto-coleta.cod-propried IN FRAME fPage1 /* Propriedade */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-boin00980"
      &KeyValue1="tt-pto-coleta.cod-propried:SCREEN-VALUE IN FRAME fPage1"
      &FieldName1="des-propried"
      &FieldScreen1="c-desc-propried"
      &Frame1="fPage1"}
      
      RUN pi-busca-regiao-propriedade IN THIS-PROCEDURE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-propried wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-pto-coleta.cod-propried IN FRAME fPage1 /* Propriedade */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-pto-coleta.cod-regiao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-regiao wMaintenance
ON F5 OF tt-pto-coleta.cod-regiao IN FRAME fPage1 /* Regi∆o */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z01in00977.w"
                       &FieldZoom1="cod-regiao"
                       &FieldScreen1="tt-pto-coleta.cod-regiao"
                       &Frame1="fpage1"
                       &FieldZoom2="nom-regiao"
                       &FieldScreen2="c-desc-regiao"
                       &Frame2="fpage1"
                       &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-regiao wMaintenance
ON LEAVE OF tt-pto-coleta.cod-regiao IN FRAME fPage1 /* Regi∆o */
DO:
   
    {method/referencefields.i 
      &HandleDBOLeave="h-boin00977"
      &KeyValue1="tt-pto-coleta.cod-regiao:SCREEN-VALUE IN FRAME fPage1"
      &FieldName1="nom-regiao"
      &FieldScreen1="c-desc-regiao"
      &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-regiao wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-pto-coleta.cod-regiao IN FRAME fPage1 /* Regi∆o */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-pto-coleta.cod-un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-un wMaintenance
ON F5 OF tt-pto-coleta.cod-un IN FRAME fPage1 /* UN */
DO:
    ASSIGN l-implanta = NO.
    {include/zoomvar.i &prog-zoom="inzoom/z01in417.w"
                       &campo=tt-pto-coleta.cod-un
                       &campozoom=un
                       &FRAME="fpage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-un wMaintenance
ON LEAVE OF tt-pto-coleta.cod-un IN FRAME fPage1 /* UN */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-boin417na"
      &KeyValue1="tt-pto-coleta.cod-un:SCREEN-VALUE IN FRAME fPage1"
      &FieldName1="descricao"
      &FieldScreen1="c-desc-un"
      &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.cod-un wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-pto-coleta.cod-un IN FRAME fPage1 /* UN */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-pto-coleta.frequencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.frequencia wMaintenance
ON F5 OF tt-pto-coleta.frequencia IN FRAME fPage1 /* Frequencia */
DO:
    /* Zoom Smart Object */
  {include/zoomvar.i &prog-zoom=adzoom/z01ad122.w
                     &campo=tt-pto-coleta.frequencia
                     &campozoom=cd-freq
                     &frame=fPage1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.frequencia wMaintenance
ON LEAVE OF tt-pto-coleta.frequencia IN FRAME fPage1 /* Frequencia */
DO:
  def var c-frequencia as char no-undo.

  run getDescFrequencia in h-boin122 ( input  input frame fPage1 tt-pto-coleta.frequencia,
                                         output c-frequencia ).
  assign c-desc-freq:screen-value in frame fPage1 = c-frequencia.        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pto-coleta.frequencia wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-pto-coleta.frequencia IN FRAME fPage1 /* Frequencia */
DO:
  APPLY "F5":U TO SELF.
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


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/mainblock.i}

tt-pto-coleta.cod-propried:LOAD-MOUSE-POINTER("image/lupa.cur":U)     in frame fPage1.
tt-pto-coleta.cod-regiao:LOAD-MOUSE-POINTER("image/lupa.cur":U)       in frame fPage1.
tt-pto-coleta.frequencia:LOAD-MOUSE-POINTER("image/lupa.cur":U)       in frame fPage1.
tt-pto-coleta.cod-un:LOAD-MOUSE-POINTER("image/lupa.cur":U)           in frame fPage1.

{utp/ut-liter.i "DistÉncia" *}
ASSIGN wh-text = tt-pto-coleta.qtd-distan-km:SIDE-LABEL-HANDLE
       wh-text:SCREEN-VALUE = RETURN-VALUE
       tt-pto-coleta.qtd-distan-km:COLUMN IN FRAME fpage1 = 14.72
       wh-text:COL = tt-pto-coleta.qtd-distan-km:COLUMN IN FRAME fpage1 - wh-text:WIDTH.

{utp/ut-liter.i "Unidade Medida" *}
ASSIGN tt-pto-coleta.cod-un:LABEL = RETURN-VALUE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestoyInterface wMaintenance 
PROCEDURE afterDestoyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-boin122) THEN DO:
       DELETE PROCEDURE h-boin122.
       ASSIGN h-boin122 = ?.
    END.

    IF VALID-HANDLE(h-boin417na) THEN DO:
       DELETE PROCEDURE h-boin417na.
       ASSIGN h-boin417na = ?.
    END.

    IF VALID-HANDLE(h-boin00980) THEN DO:
       DELETE PROCEDURE h-boin00980.
       ASSIGN h-boin00980 = ?.
    END.

    IF VALID-HANDLE(h-boin00977) THEN DO:
       DELETE PROCEDURE h-boin00977.
       ASSIGN h-boin00977 = ?.
    END.
        
    RETURN "OK":U.

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

    ASSIGN tt-pto-coleta.des-obs:READ-ONLY IN FRAME fpage1 = YES
           tt-pto-coleta.des-obs:SENSITIVE IN FRAME fpage1 = YES.

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

    APPLY "LEAVE" TO tt-pto-coleta.cod-propried IN FRAME fpage1.
    APPLY "LEAVE" TO tt-pto-coleta.cod-regiao IN FRAME fpage1.
    APPLY "LEAVE" TO tt-pto-coleta.cod-un IN FRAME fpage1.
    APPLY "LEAVE" TO tt-pto-coleta.frequencia IN FRAME fpage1.

    
    RUN pi-desabilita-botoes-consulta IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK" THEN
        IF AVAIL tt-pto-coleta THEN
            ENABLE btPtoColetaCol WITH FRAME fpage0. 
        ELSE
            DISABLE btPtoColetaCol WITH FRAME fpage0.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterEnableFields wMaintenance 
PROCEDURE AfterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN tt-pto-coleta.des-obs:READ-ONLY    IN FRAME fpage1 = NO
           tt-pto-coleta.cod-regiao:SENSITIVE IN FRAME fpage1 = NO. 
           
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
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

    ENABLE btPtoColetaCol btRepositorio WITH FRAME fpage0.

    RUN afterDisableFields.

    IF gr-pto-coleta-aq0205 <> ? THEN
        RUN repositionRecord IN THIS-PROCEDURE (input gr-pto-coleta-aq0205).

    IF c-cod-pto-coleta <> ? THEN DO:
        RUN goToKey          IN {&hDBOTable} (INPUT c-cod-pto-coleta).
        RUN getRowid         IN {&hDBOTable} (OUTPUT rGoTo).
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
    END.

    RUN pi-desabilita-botoes-consulta IN THIS-PROCEDURE.

    RETURN "OK":U.

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
    APPLY 'LEAVE':U TO tt-pto-coleta.cod-propried IN FRAME fPage1.              
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
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
    
    DEFINE VARIABLE c-cod-pto-coleta LIKE {&ttTable}.cod-pto-coleta NO-UNDO
        VIEW-AS FILL-IN SIZE 13 BY 0.88.
    
    DEFINE FRAME fGoToRecord
        c-cod-pto-coleta  AT ROW 1.81 COL 20.00 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Ponto Coleta" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Ponto_Coleta"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-cod-pto-coleta.
        
        RUN goToKey IN {&hDBOTable} (INPUT c-cod-pto-coleta).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Ponto Coleta":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-cod-pto-coleta btGoToOK btGoToCancel 
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
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "inbo/boin00966.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00966.p YES}
        {btb/btb008za.i2 inbo/boin00966.p '' {&hDBOTable}}
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    /*--- Verifica se o DBO jò estò inicializado ---*/
    IF  NOT VALID-HANDLE(h-boin122) THEN
        run inbo/boin122.p persistent set h-boin122.

    RUN openQueryStatic IN h-boin122 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-boin417na) THEN DO:
       {btb/btb008za.i1 inbo/boin417na.p}
       {btb/btb008za.i2 inbo/boin417na.p '' h-boin417na} 
    END.
    RUN openQueryStatic IN h-boin417na (INPUT "Main":U).

    IF NOT VALID-HANDLE(h-boin00980) THEN DO:
       {btb/btb008za.i1 inbo/boin00980.p}
       {btb/btb008za.i2 inbo/boin00980.p '' h-boin00980} 
    END.
    RUN openQueryStatic IN h-boin00980 (INPUT "Main":U).

    IF NOT VALID-HANDLE(h-boin00977) THEN DO:
       {btb/btb008za.i1 inbo/boin00977.p}
       {btb/btb008za.i2 inbo/boin00977.p '' h-boin00977} 
    END.
    RUN openQueryStatic IN h-boin00977 (INPUT "Main":U).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-regiao-propriedade wMaintenance 
PROCEDURE pi-busca-regiao-propriedade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-----------------------------------------------------------------------------*/
    DEFINE VARIABLE c-cod-regiao AS CHARACTER   NO-UNDO.
    

    IF VALID-HANDLE(h-boin00980) THEN DO:
        RUN goTokey IN h-boin00980(INPUT tt-pto-coleta.cod-propried:SCREEN-VALUE IN FRAME fPage1).
    
        IF RETURN-VALUE = "OK" THEN
            RUN getcharfield IN  h-boin00980(INPUT 'cod-regiao', OUTPUT c-cod-regiao).
    
        ASSIGN tt-pto-coleta.cod-regiao:SCREEN-VALUE IN FRAME fPage1 = c-cod-regiao.
    
        {method/referencefields.i 
                  &HandleDBOLeave="h-boin00977"
                  &KeyValue1="trim(tt-pto-coleta.cod-regiao:SCREEN-VALUE IN FRAME fPage1)"
                  &FieldName1="nom-regiao"
                  &FieldScreen1="c-desc-regiao"
                  &Frame1="fPage1"}
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desabilita-botoes-consulta wMaintenance 
PROCEDURE pi-desabilita-botoes-consulta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN l-consulta = '{1}':U = 'aq0405':U.
    
    IF l-consulta THEN DO:
        ASSIGN btUpdate:HIDDEN              IN FRAME fPage0 = YES
               btUndo:HIDDEN                IN FRAME fPage0 = YES
               btSave:HIDDEN                IN FRAME fPage0 = YES
               btCancel:HIDDEN              IN FRAME fPage0 = YES
               btAdd:HIDDEN                 IN FRAME fPage0 = YES
               btCopy:HIDDEN                IN FRAME fPage0 = YES
               btDelete:HIDDEN              IN FRAME fPage0 = YES
               btPtoColetaCol:HIDDEN        IN FRAME fPage0 = YES
               btRepositorio:HIDDEN         IN FRAME fPage0 = YES
               MENU-ITEM miAdd:SENSITIVE    IN MENU smFile  = NO
               MENU-ITEM miCopy:SENSITIVE   IN MENU smFile  = NO
               MENU-ITEM miUpdate:SENSITIVE IN MENU smFile  = NO
               MENU-ITEM miDelete:SENSITIVE IN MENU smFile  = NO
               MENU-ITEM miUndo:SENSITIVE   IN MENU smFile  = NO
               MENU-ITEM miCancel:SENSITIVE IN MENU smFile  = NO
               MENU-ITEM miSave:SENSITIVE   IN MENU smFile  = NO.
        RETURN 'NOK':U.
    END.

    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-cod-pto-coleta wMaintenance 
PROCEDURE set-cod-pto-coleta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-pto-coleta AS CHARACTER NO-UNDO.

    ASSIGN c-cod-pto-coleta = pc-cod-pto-coleta.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

