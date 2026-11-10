&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movfro           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttRestdoEnsaio NO-UNDO LIKE mao-restdo-ensaio
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AO0602 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ao0602 MAO}
&ENDIF


/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program       AO0602
&GLOBAL-DEFINE Version       2.00.00.002

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Resultado

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         NO
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         NO
&GLOBAL-DEFINE Save           NO

&GLOBAL-DEFINE ttTable         ttRestdoEnsaio                     
&GLOBAL-DEFINE hDBOTable       hDBORestdoEnsaio      
&GLOBAL-DEFINE DBOTable        mao-restdo-ensaio
                                 
&GLOBAL-DEFINE page0KeyFields ttRestdoEnsaio.num-amostra-oleo ttRestdoEnsaio.cod-ensaio

&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    ttRestdoEnsaio.dat-restdo-ensaio ttRestdoEnsaio.des-val-max ttRestdoEnsaio.idi-estado-ensaio ttRestdoEnsaio.des-val-min ~
                              ttRestdoEnsaio.des-val-restdo ttRestdoEnsaio.num-tabela ttRestdoEnsaio.dsl-obs ~
                              ttRestdoEnsaio.cod-usuar-aprvdor
                              
&GLOBAL-DEFINE page2Fields    

/* Parameters Definitions ---                                           */


/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cCodModelo  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDescEvento AS CHARACTER FORMAT "X(30)"  NO-UNDO.
DEFINE VARIABLE cAmostraFisic AS char    NO-UNDO.
DEFINE VARIABLE iNumEvento AS INTEGER    NO-UNDO.

/* Global Variables ---                                                 */
define new global shared variable iEmpresa like mab-comptmento-eqpto.ep-codigo no-undo.
define new global shared variable cEqpto   like mab-comptmento-eqpto.cod-eqpto   no-undo.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOAmostra   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEnsaio    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOTabela    AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttRestdoEnsaio.num-amostra-oleo ~
ttRestdoEnsaio.cod-ensaio 
&Scoped-define ENABLED-TABLES ttRestdoEnsaio
&Scoped-define FIRST-ENABLED-TABLE ttRestdoEnsaio
&Scoped-Define ENABLED-OBJECTS rtKeys rtKeys-2 rtToolBar btFirst btPrev ~
btNext btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp ~
fiEstado fi-cod-amostra-fisic fiDescEnsaio fi-num-docto-event btDetalhe 
&Scoped-Define DISPLAYED-FIELDS ttRestdoEnsaio.num-amostra-oleo ~
ttRestdoEnsaio.cod-ensaio 
&Scoped-define DISPLAYED-TABLES ttRestdoEnsaio
&Scoped-define FIRST-DISPLAYED-TABLE ttRestdoEnsaio
&Scoped-Define DISPLAYED-OBJECTS fiEstado fi-cod-amostra-fisic fiDescEnsaio ~
fi-num-docto-event 

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
DEFINE BUTTON btDetalhe 
     IMAGE-UP FILE "image\im-det.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-det.bmp":U
     LABEL "Evento" 
     SIZE 4 BY .88.

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

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE fi-cod-amostra-fisic AS CHARACTER FORMAT "x(12)" 
     LABEL "N£mero Amostra":R17 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88.

DEFINE VARIABLE fi-num-docto-event AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Evento":R8 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiDescEnsaio AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 46.14 BY .88 NO-UNDO.

DEFINE VARIABLE fiEstado AS CHARACTER FORMAT "X(25)":U 
     VIEW-AS FILL-IN 
     SIZE 20.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.72 BY 2.25.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89.72 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 89.72 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE fiDescTabela AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiHora AS CHARACTER FORMAT "99:99:99" INITIAL "00:00:00" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fiTexto1 AS CHARACTER FORMAT "X(256)":U INITIAL "Estado" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE IMAGE IMAGE-23
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 66.86 BY 1.83.


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
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     ttRestdoEnsaio.num-amostra-oleo AT ROW 2.88 COL 10.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiEstado AT ROW 2.88 COL 20.57 COLON-ALIGNED NO-LABEL
     fi-cod-amostra-fisic AT ROW 2.88 COL 54.72 COLON-ALIGNED
     ttRestdoEnsaio.cod-ensaio AT ROW 3.88 COL 10.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescEnsaio AT ROW 3.88 COL 20.57 COLON-ALIGNED NO-LABEL
     fi-num-docto-event AT ROW 3.88 COL 74 COLON-ALIGNED
     btDetalhe AT ROW 3.88 COL 86
     rtKeys AT ROW 2.67 COL 1
     rtKeys-2 AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.88
         FONT 1.

DEFINE FRAME fPage1
     ttRestdoEnsaio.idi-estado-ensaio AT ROW 2.25 COL 17 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Pendente", 1,
"Aprovado", 2,
"Aprovado pelo Usu†rio", 3,
"Reprovado", 4
          SIZE 61 BY .71
     ttRestdoEnsaio.num-tabela AT ROW 3.58 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fiDescTabela AT ROW 3.58 COL 18.43 COLON-ALIGNED NO-LABEL
     ttRestdoEnsaio.des-val-min AT ROW 4.58 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 29 BY .88
     ttRestdoEnsaio.des-val-max AT ROW 4.58 COL 49.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 29 BY .88
     ttRestdoEnsaio.dat-restdo-ensaio AT ROW 5.58 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiHora AT ROW 5.58 COL 22.29 COLON-ALIGNED HELP
          "Hora Resultado Ensaio" NO-LABEL
     ttRestdoEnsaio.cod-usuar-aprvdor AT ROW 5.58 COL 65 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.86 BY .88
     ttRestdoEnsaio.des-val-restdo AT ROW 6.58 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 67 BY .88
     ttRestdoEnsaio.dsl-obs AT ROW 7.58 COL 14 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
          SIZE 67 BY 3.42
     fiTexto1 AT ROW 1.38 COL 15 NO-LABEL
     IMAGE-23 AT ROW 4.58 COL 49.14
     IMAGE-24 AT ROW 4.58 COL 42.72
     RECT-32 AT ROW 1.67 COL 14.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.38
         SIZE 84.43 BY 10.63
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttRestdoEnsaio T "?" NO-UNDO movfro mao-restdo-ensaio
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
         TITLE              = "Consulta Resultados dos Ensaios"
         HEIGHT             = 16.88
         WIDTH              = 90
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.21
         VIRTUAL-WIDTH      = 146.29
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
/* SETTINGS FOR FILL-IN ttRestdoEnsaio.cod-usuar-aprvdor IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiTexto1 IN FRAME fPage1
   ALIGN-L                                                              */
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
ON END-ERROR OF wMaintenance /* Consulta Resultados dos Ensaios */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance /* Consulta Resultados dos Ensaios */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDetalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhe wMaintenance
ON CHOOSE OF btDetalhe IN FRAME fpage0 /* Evento */
DO:
  DEFINE VARIABLE rEvento  AS ROWID  NO-UNDO.
  DEFINE VARIABLE hProgram AS HANDLE NO-UNDO.

  /** Busca Rowid do Movimento de Evento **/
  for first mab-movto-event fields(num-docto)
      where mab-movto-event.num-docto = input frame fPage0 fi-num-docto-event no-lock:
      assign rEvento = rowid(mab-movto-event).
  end.

  assign {&WINDOW-NAME}:sensitive = no.

  /*--- Seta cursor do mouse para espera ---*/
  SESSION:SET-WAIT-STATE("GENERAL":U).
  /*--- Executa programa de inclus∆o de filho ---*/
  RUN abp/ab0619.w PERSISTENT SET hProgram.

  /** Validaá∆o do Handle **/
  IF VALID-HANDLE(hProgram) AND
     hProgram:Type = "PROCEDURE":U AND
     hProgram:FILE-NAME = "abp/ab0619.w":U THEN do:
      /*--- Inicializa programa de inclus∆o de filho ---*/
      RUN initializeInterface IN hProgram.
      /*:T Reposiciona registro com base em um rowid */
      RUN repositionRecord IN hProgram (INPUT rEvento).
  end.
  /*--- Seta cursor do mouse para normal ---*/
  SESSION:SET-WAIT-STATE("":U).

  wait-for "CLOSE":U of hProgram.
  if valid-handle (hProgram) then
      delete procedure hProgram.

  assign {&WINDOW-NAME}:sensitive = yes.  
  apply "ENTRY":U to btDetalhe in frame fPage0.
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


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
     {method/zoomreposition.i &ProgramZoom="frzoom/z01fr106.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttRestdoEnsaio.cod-ensaio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttRestdoEnsaio.cod-ensaio wMaintenance
ON LEAVE OF ttRestdoEnsaio.cod-ensaio IN FRAME fpage0 /* Ensaio */
DO:
  
        {method/referencefields.i 
        &HandleDBOLeave="hDBOEnsaio"
        &KeyValue1="input frame fPage0 {&ttTable}.cod-ensaio"
        &FieldName1="des-ensaio"
        &FieldScreen1="fiDescEnsaio"
        &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttRestdoEnsaio.num-tabela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttRestdoEnsaio.num-tabela wMaintenance
ON LEAVE OF ttRestdoEnsaio.num-tabela IN FRAME fPage1 /* Tabela */
DO:
  {method/referencefields.i 
        &HandleDBOLeave="hDBOTabela"
        &KeyValue1="input frame fPage1 {&ttTable}.num-tabela"
        &FieldName1="des-tabela"
        &FieldScreen1="fiDescTabela"
        &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
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


/** Ensaio **/
if valid-handle(hDBOEnsaio) then
    run Destroy in hDBOEnsaio.

/**Tabela **/
if valid-handle(hDBOTabela) then
    run Destroy in hDBOTabela.

/***Amostra de oleo ***/
if valid-handle(hDBOAmostra) then
    run Destroy in hDBOAmostra.

{method/showmessage.i3}

return "OK":U.
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

DEFINE VARIABLE idi-estado AS INTEGER    NO-UNDO.


/**** Busca informaá‰es da amostra com base no registro corrente do resultado do Ensaio ***/
if avail {&ttTable} then do:
    
    ASSIGN fiHora:SCREEN-VALUE IN FRAME fPage1 = STRING({&ttTable}.hra-restdo-ensaio).
    
    run getValorCampos in {&hDBOTable} (input frame fPage0 {&ttTable}.num-amostra-oleo,
                                         output cAmostraFisic,
                                         output iNumEvento,  
                                         output idi-estado).

    assign fi-num-docto-event   = iNumEvento
           fi-cod-amostra-fisic = cAmostraFisic.
    disp   fi-num-docto-event  
           fi-cod-amostra-fisic with frame fPage0.


    
    /**** Habilitar oo bot∆o de consulta Detalhe do Evento ****/
    if fi-num-docto-event <> 0 then             
        assign btDetalhe:sensitive in frame fPage0 = yes.
    else                                                 
        assign btDetalhe:sensitive in frame fPage0 = no. 


    if idi-estado <> 0 THEN DO:
       /**** Descriá∆o do Estado da amostra ****/
       &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
           DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
           ASSIGN cAuxTraducao001 = {frinc/i00fr105.i 04 idi-estado}.
           run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                               INPUT "",
                               INPUT "").
           ASSIGN  fiEstado:screen-value in frame fPage0 = RETURN-VALUE.
       &else
           ASSIGN fiEstado:screen-value in frame fPage0 = {frinc/i00fr105.i 04 idi-estado}.
       &endif
    END.
    else
        assign fiEstado:screen-value in frame fPage0 = "":U.


/** Descriá‰es dos campos **/
apply "LEAVE":U to {&ttTable}.cod-ensaio      in frame fPage0. 
apply "LEAVE":U to {&ttTable}.num-tabela      in frame fPage1. 

/*campo observacao deve ficar enable e read-only.*/
ASSIGN {&ttTable}.dsl-obs:SENSITIVE IN FRAME fPage1 = YES
       {&ttTable}.dsl-obs:READ-ONLY IN FRAME fPage1 = YES.

end.

            
return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenance 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/** Label para os campos em tela **/
{utp/ut-liter.i "Faixa" * }
assign {&ttTable}.des-val-min:label in frame fPage1 = trim(return-value).
{utp/ut-liter.i "Resultado" * }
assign {&ttTable}.des-val-restdo:label in frame fPage1 = trim(return-value).
{utp/ut-liter.i "Estado" * }
assign fiTexto1 = trim(return-value).

disp fiTexto1 with frame fPage1.


return "OK":U.

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

    define var cnum-amostra-oleo LIKE {&ttTable}.num-amostra-oleo view-as  fill-in  size  10.00 BY 0.88 no-undo.
    define var ccod-ensaio       LIKE {&ttTable}.cod-ensaio view-as  fill-in  size  10.00 BY 0.88 no-undo.

    DEFINE FRAME fGoToRecord
        cnum-amostra-oleo AT ROW 1.21 COL 17.72 COLON-ALIGNED
        ccod-ensaio       at row 2.21 col 17.72 colon-aligned
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    run utp/ut-trfrrp.p (input frame fGoToRecord:handle).
    {utp/ut-liter.i V†_Para_Resultado_Ensaio *}
    assign frame fGoToRecord:title = return-value.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cnum-amostra-oleo ccod-ensaio.

        /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
        RUN goToKey IN {&hDBOTable} (INPUT cnum-amostra-oleo,
                                      input ccod-ensaio ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-liter.i Resultado_Ensaio}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT return-value ).

            RETURN NO-APPLY.
        END.

        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).

        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.

    ENABLE cnum-amostra-oleo ccod-ensaio  btGoToOK btGoToCancel 
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
       {&hDBOTable}:FILE-NAME <> "frbo/bofr106.p":U THEN DO:
        run frbo/bofr106.p persistent set {&hDBOTable}. 
    END.

   /* RUN setConstraintRowAmostra IN {&hDBOTable} (input pRowPai) NO-ERROR.*/
    RUN openQueryStatic         IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE(hDBOAmostra) OR
       hDBOAmostra:TYPE <> "PROCEDURE":U OR
       hDBOAmostra:FILE-NAME <> "frbo/bofr105.p":U THEN DO:
        run frbo/bofr105.p persistent set hDBOAmostra.
    END.
    
   
    /*--- DBO Ensaio ---*/
    IF NOT VALID-HANDLE(hDBOEnsaio) OR
       hDBOEnsaio:TYPE <> "PROCEDURE":U OR
       hDBOEnsaio:FILE-NAME <> "frbo/bofr103.p":U THEN DO:
        run frbo/bofr103.p persistent set  hDBOEnsaio.
    END.
    
    RUN openQueryStatic IN hDBOEnsaio (INPUT "Main":U) NO-ERROR.

    /*--- DBO Tabela ---*/
    IF NOT VALID-HANDLE(hDBOTabela) OR
       hDBOTabela:TYPE <> "PROCEDURE":U OR
       hDBOTabela:FILE-NAME <> "frbo/bofr102.p":U THEN DO:
        run frbo/bofr102.p persistent set  hDBOTabela.
    END.
    
    RUN openQueryStatic IN hDBOTabela (INPUT "Main":U) NO-ERROR.



    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

