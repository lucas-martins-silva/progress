&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-mab-programac-event NO-UNDO LIKE mab-programac-event
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
{include/i-prgvrs.i AB0602E 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0602e MAB}
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
&GLOBAL-DEFINE Program        AB0602E
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Sequencial,Alternados

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            no
&GLOBAL-DEFINE Copy           no
&GLOBAL-DEFINE Update         no
&GLOBAL-DEFINE Delete         no
&GLOBAL-DEFINE Undo           no
&GLOBAL-DEFINE Cancel         no
&GLOBAL-DEFINE Save           no

&GLOBAL-DEFINE ttTable        tt-mab-programac-event
&GLOBAL-DEFINE hDBOTable      hDBOProgramac
&GLOBAL-DEFINE DBOTable       mab-programac-event

&GLOBAL-DEFINE page0KeyFields   tt-mab-programac-event.ep-codigo ~
                                tt-mab-programac-event.cod-eqpto ~
                                tt-mab-programac-event.cod-evento
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields      tt-mab-programac-event.dat-final ~
                                tt-mab-programac-event.dat-inicial ~
                                tt-mab-programac-event.num-dia ~
                                tt-mab-programac-event.cod-dia-mes-vencto ~
                                tt-mab-programac-event.num-parcela
&GLOBAL-DEFINE page2Fields      tg-parc-altern fi-dia-base ~
                                tg-jan tg-fev tg-mar tg-abr tg-maio tg-jun ~
                                tg-jul tg-ago tg-set tg-out tg-nov  tg-dez    







/* Parameters Definitions ---              */

define input param pRowid as rowid no-undo.                 

/* Local Variable Definitions ---                                       */
define new global shared variable iEmpresa like   mab-programac-event.ep-codigo no-undo.
define new global shared variable cEqpto   like   mab-programac-event.cod-eqpto no-undo.
DEFINE VARIABLE cDescEqpto                 AS CHARACTER  NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEvento    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEqpto     AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-mab-programac-event.ep-codigo ~
tt-mab-programac-event.cod-eqpto tt-mab-programac-event.cod-evento 
&Scoped-define ENABLED-TABLES tt-mab-programac-event
&Scoped-define FIRST-ENABLED-TABLE tt-mab-programac-event
&Scoped-Define ENABLED-OBJECTS btFirst btPrev btNext btLast btGoTo btSearch ~
btQueryJoins btReportsJoins btExit btHelp c-desc-modelo c-desc-evento ~
rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-mab-programac-event.ep-codigo ~
tt-mab-programac-event.cod-eqpto tt-mab-programac-event.cod-evento 
&Scoped-define DISPLAYED-TABLES tt-mab-programac-event
&Scoped-define FIRST-DISPLAYED-TABLE tt-mab-programac-event
&Scoped-Define DISPLAYED-OBJECTS c-desc-modelo c-desc-evento 

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

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE c-desc-evento AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-modelo AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 39 BY 1.29.

DEFINE VARIABLE fi-dia-base AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Dia Base Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 56 BY 4.25.

DEFINE VARIABLE tg-abr AS LOGICAL INITIAL no 
     LABEL "Abril" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-ago AS LOGICAL INITIAL no 
     LABEL "Agosto" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dez AS LOGICAL INITIAL no 
     LABEL "Dezembro" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-fev AS LOGICAL INITIAL no 
     LABEL "Fevereiro" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-jan AS LOGICAL INITIAL no 
     LABEL "Janeiro" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-jul AS LOGICAL INITIAL no 
     LABEL "Julho" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-jun AS LOGICAL INITIAL no 
     LABEL "Junho" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-maio AS LOGICAL INITIAL no 
     LABEL "Maio" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-mar AS LOGICAL INITIAL no 
     LABEL "Mar‡o" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-nov AS LOGICAL INITIAL no 
     LABEL "Novembro" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-out AS LOGICAL INITIAL no 
     LABEL "Outubro" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-parc-altern AS LOGICAL INITIAL no 
     LABEL "Parcelas Alternadas" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-set AS LOGICAL INITIAL no 
     LABEL "Setembro" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.


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
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-mab-programac-event.ep-codigo AT ROW 3 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     tt-mab-programac-event.cod-eqpto AT ROW 4 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     c-desc-modelo AT ROW 4 COL 46 COLON-ALIGNED NO-LABEL
     tt-mab-programac-event.cod-evento AT ROW 5 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     c-desc-evento AT ROW 5 COL 37 COLON-ALIGNED NO-LABEL
     rtKeys AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 15.29
         FONT 1.

DEFINE FRAME fPage2
     tg-parc-altern AT ROW 1.5 COL 17.14
     fi-dia-base AT ROW 2.5 COL 15.14 COLON-ALIGNED
     tg-jan AT ROW 4.42 COL 21.43
     tg-abr AT ROW 4.42 COL 33.86
     tg-jul AT ROW 4.42 COL 45.57
     tg-out AT ROW 4.42 COL 57.57
     tg-fev AT ROW 5.67 COL 21.43
     tg-maio AT ROW 5.67 COL 33.86
     tg-ago AT ROW 5.67 COL 45.57
     tg-nov AT ROW 5.67 COL 57.57
     tg-mar AT ROW 6.88 COL 21.43
     tg-jun AT ROW 6.88 COL 33.86
     tg-set AT ROW 6.88 COL 45.57
     tg-dez AT ROW 6.88 COL 57.57
     RECT-3 AT ROW 3.83 COL 17
     "Meses" VIEW-AS TEXT
          SIZE 6.14 BY .75 AT ROW 3.54 COL 18.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.46
         SIZE 84.43 BY 7.92
         FONT 1.

DEFINE FRAME fPage1
     tt-mab-programac-event.cod-dia-mes-vencto AT ROW 1.42 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-mab-programac-event.dat-inicial AT ROW 2.75 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-mab-programac-event.dat-final AT ROW 2.75 COL 45.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-mab-programac-event.num-dia AT ROW 3.88 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-mab-programac-event.num-parcela AT ROW 4.88 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     RECT-2 AT ROW 2.5 COL 21
     "Validade" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 2.25 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.5
         SIZE 84.43 BY 7.88
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-mab-programac-event T "?" NO-UNDO mgfro mab-programac-event
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
         HEIGHT             = 15.29
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FRAME fPage2
                                                                        */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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
     assign iEmpresa = INPUT FRAME fPage0 tt-mab-programac-event.ep-codigo
            cEqpto   = INPUT FRAME fPage0 tt-mab-programac-event.cod-eqpto.
    {method/zoomreposition.i &ProgramZoom="frzoom\z01fr022.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-mab-programac-event.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-programac-event.cod-eqpto wMaintenance
ON LEAVE OF tt-mab-programac-event.cod-eqpto IN FRAME fpage0 /* Equipamento */
DO:
   def var cRet as CHAR FORMAT "x(08)" no-undo.
 /**Busca c¢digo do modelo **/
    run goToKey IN hDBOEqpto      (input FRAME fPage0 tt-mab-programac-event.ep-codigo,
                                   input FRAME fPage0 tt-mab-programac-event.cod-eqpto).
    run getCharField in hDBOEqpto (input "cod-model":u,
                                   output cRet). 

    /*** Busca descri‡Æo do modelo ***/

    {method\referenceFields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="cRet"
        &FieldName1="des-model"
        &FieldScreen1="c-desc-modelo"
        &Frame1="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-mab-programac-event.cod-evento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-programac-event.cod-evento wMaintenance
ON LEAVE OF tt-mab-programac-event.cod-evento IN FRAME fpage0 /* Evento */
DO:
      {method\referenceFields.i
        &HandleDBOLeave="hDBOEvento"
        &KeyValue1="tt-mab-programac-event.cod-evento:screen-value in frame fPage0"
        &FieldName1="des-evento"
        &FieldScreen1="c-desc-evento"
        &Frame1="fPage0"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tg-parc-altern
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-parc-altern wMaintenance
ON VALUE-CHANGED OF tg-parc-altern IN FRAME fPage2 /* Parcelas Alternadas */
DO:
  
        ASSIGN fi-dia-base:SENSITIVE IN FRAME fPage2 = NO
               tg-jan:SENSITIVE IN FRAME fPage2 = NO
               tg-fev:SENSITIVE IN FRAME fPage2 = NO
               tg-mar:SENSITIVE IN FRAME fPage2 = NO
               tg-abr:SENSITIVE IN FRAME fPage2 = NO
               tg-maio:SENSITIVE IN FRAME fPage2 = NO
               tg-jun:SENSITIVE IN FRAME fPage2 = NO
               tg-jul:SENSITIVE IN FRAME fPage2 = NO
               tg-ago:SENSITIVE IN FRAME fPage2 = NO
               tg-set:SENSITIVE IN FRAME fPage2 = NO
               tg-out:SENSITIVE IN FRAME fPage2 = NO
               tg-nov:SENSITIVE IN FRAME fPage2 = NO
               tg-dez:SENSITIVE IN FRAME fPage2 = NO
               tt-mab-programac-event.cod-dia-mes-vencto:SENSITIVE IN FRAME fPage1 = no
               tt-mab-programac-event.num-parcela:SENSITIVE IN FRAME fPage1 = no.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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
/** Modelo **/
if valid-handle(hDBOModelo) then
    run destroy in hDBOModelo.

/** Evento **/
if valid-handle(hDBOEvento) then
    run destroy in hDBOEvento.

/** Equipamento **/
if valid-handle(hDBOEqpto) then
    run destroy in hDBOEqpto.


RETURN "Ok":U.
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
/** Descri‡äes de campos **/
apply "LEAVE":U to tt-mab-programac-event.cod-eqpto in frame fPage0.
apply "LEAVE":U to tt-mab-programac-event.cod-evento in frame fPage0.
APPLY "value-changed":U TO tg-parc-altern IN FRAME fPage2.
ASSIGN tg-parc-altern:CHECKED IN FRAME fPage2 = tt-mab-programac-event.log-livre-1
       fi-dia-base:SCREEN-VALUE IN FRAME fPage2 = STRING(tt-mab-programac-event.num-livre-1).

IF tt-mab-programac-event.cod-livre-1 <> "":U THEN
       /*Meses - sao gravados no campo livre  - cada posicao equivale a um mˆs*/
    ASSIGN tg-jan:CHECKED IN FRAME fPage2  = IF substring(tt-mab-programac-event.cod-livre-1,1,1) = "s":U THEN YES ELSE NO
           tg-fev:CHECKED IN FRAME fPage2  = IF substring(tt-mab-programac-event.cod-livre-1,2,1) = "s":U THEN YES ELSE NO
           tg-mar:CHECKED IN FRAME fPage2  = IF substring(tt-mab-programac-event.cod-livre-1,3,1) = "s":U THEN YES ELSE NO
           tg-abr:CHECKED IN FRAME fPage2  = IF substring(tt-mab-programac-event.cod-livre-1,4,1) = "s":U THEN YES ELSE NO
           tg-maio:CHECKED IN FRAME fPage2 = IF substring(tt-mab-programac-event.cod-livre-1,5,1) = "s":U THEN YES ELSE NO
           tg-jun:CHECKED IN FRAME fPage2  = IF substring(tt-mab-programac-event.cod-livre-1,6,1) = "s":U THEN YES ELSE NO
           tg-jul:CHECKED IN FRAME fPage2  = IF substring(tt-mab-programac-event.cod-livre-1,7,1) = "s":U THEN YES ELSE NO
           tg-ago:CHECKED IN FRAME fPage2  = IF substring(tt-mab-programac-event.cod-livre-1,8,1) = "s":U THEN YES ELSE NO
           tg-set:CHECKED IN FRAME fPage2  = IF substring(tt-mab-programac-event.cod-livre-1,9,1) = "s":U THEN YES ELSE NO
           tg-out:CHECKED IN FRAME fPage2  = IF substring(tt-mab-programac-event.cod-livre-1,10,1) = "s":U THEN YES ELSE NO
           tg-nov:CHECKED IN FRAME fPage2  = IF substring(tt-mab-programac-event.cod-livre-1,11,1) = "s":U THEN YES ELSE NO
           tg-dez:CHECKED IN FRAME fPage2  = IF substring(tt-mab-programac-event.cod-livre-1,12,1) = "s":U THEN YES ELSE NO NO-ERROR.

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

if pRowid <> ? then do:
    /*:T Reposiciona registro com base no rowid do browse do programa AB0138 */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT pRowid).
end.



Return "OK":U.
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
    
    DEFINE VARIABLE iep-codigo LIKE {&ttTable}.ep-codigo  VIEW-AS FILL-IN SIZE 05.00 BY 0.88 NO-UNDO.
    DEFINE VARIABLE ccod-eqpto LIKE {&ttTable}.cod-eqpto  VIEW-AS FILL-IN SIZE 16.00 BY 0.88 NO-UNDO.
    DEFINE VARIABLE ccod-evento LIKE {&ttTable}.cod-evento  VIEW-AS FILL-IN SIZE 12.00 BY 0.88 NO-UNDO.

    
    DEFINE FRAME fGoToRecord
        iep-codigo   AT ROW 1.21 COL 17.72 COLON-ALIGNED
        ccod-eqpto   AT ROW 2.21 COL 17.72 COLON-ALIGNED
        ccod-evento  AT ROW 3.21 COL 17.72 COLON-ALIGNED 
        btGoToOK          AT ROW 4.63 COL 2.14
        btGoToCancel      AT ROW 4.63 COL 13
        rtGoToButton      AT ROW 4.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Programa‡Æo de Eventos" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Programa‡Æo_de_Eventos"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN iep-codigo ccod-eqpto ccod-evento.
        
        RUN goToKey IN {&hDBOTable} (INPUT iep-codigo , INPUT ccod-eqpto, input ccod-evento).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "mab-programac-event":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE iep-codigo ccod-eqpto ccod-evento btGoToOK btGoToCancel 
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
      {&hDBOTable}:FILE-NAME <> "frbo~\bofr022.p":U THEN DO:
        run frbo/bofr022.p persistent set {&hDBOTable}.
    END.
   
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
 
    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo~\bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

    /*--- DBO Evento ---*/
    IF NOT VALID-HANDLE(hDBOEvento) OR
       hDBOEvento:TYPE <> "PROCEDURE":U OR
       hDBOEvento:FILE-NAME <> "frbo~\bofr010.p":U THEN DO:
        run frbo/bofr010.p persistent set  hDBOEvento.
    END.
    
    RUN openQueryStatic IN hDBOEvento (INPUT "Main":U) NO-ERROR.



     /*--- DBO Equipto ---*/
    IF NOT VALID-HANDLE(hDBOEqpto) OR
       hDBOEqpto:TYPE <> "PROCEDURE":U OR
       hDBOEqpto:FILE-NAME <> "frbo~\bofr007.p":U THEN DO:
        run frbo/bofr007.p persistent set  hDBOEqpto.
    END.
    
    RUN openQueryStatic IN hDBOEqpto (INPUT "Main":U) NO-ERROR.





return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

