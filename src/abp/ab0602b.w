&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-mab-histor-combust NO-UNDO LIKE mab-histor-combust
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
{include/i-prgvrs.i AB0602B 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0602b MAB}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0602B
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Combust°veis

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

&GLOBAL-DEFINE ttTable        tt-mab-histor-combust
&GLOBAL-DEFINE hDBOTable      HDboCombust
&GLOBAL-DEFINE DBOTable       mab-histor-combust

&GLOBAL-DEFINE page0KeyFields tt-mab-histor-combust.ep-codigo tt-mab-histor-combust.cod-eqpto 
&GLOBAL-DEFINE page0Fields tt-mab-histor-combust.dat-inicial    
&GLOBAL-DEFINE page1Fields tt-mab-histor-combust.cod-tip-mater tt-mab-histor-combust.val-capac-tanque ~
                           tt-mab-histor-combust.idi-tip-consu  tt-mab-histor-combust.val-consu-padr ~
                           tt-mab-histor-combust.dat-desativ tt-mab-histor-combust.val-livre-1 rsTipoConsSec

   

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER pRowSon AS ROWID      NO-UNDO.
DEFINE INPUT  PARAMETER pRowPai AS ROWID      NO-UNDO.
DEFINE INPUT  PARAMETER pHandle AS HANDLE     NO-UNDO.




/* Local Variable Definitions ---                                       */

define new global shared variable iEmpresa like mab-histor-combust.ep-codigo no-undo.
define new global shared variable cEqpto   like mab-histor-combust.cod-eqpto   no-undo.
/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE  {&hDBOTable} AS HANDLE NO-UNDO.
define variable  hDBOEqpto    as handle no-undo.
define variable  cCodModelo   as char no-undo.
define variable  hDBOModelo   as handle no-undo.
define variable  hDBOMaterial as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-mab-histor-combust.ep-codigo ~
tt-mab-histor-combust.cod-eqpto tt-mab-histor-combust.dat-inicial 
&Scoped-define ENABLED-TABLES tt-mab-histor-combust
&Scoped-define FIRST-ENABLED-TABLE tt-mab-histor-combust
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp ~
c-desc-modelo 
&Scoped-Define DISPLAYED-FIELDS tt-mab-histor-combust.ep-codigo ~
tt-mab-histor-combust.cod-eqpto tt-mab-histor-combust.dat-inicial 
&Scoped-define DISPLAYED-TABLES tt-mab-histor-combust
&Scoped-define FIRST-DISPLAYED-TABLE tt-mab-histor-combust
&Scoped-Define DISPLAYED-OBJECTS c-desc-modelo 

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

DEFINE VARIABLE c-desc-cons-padrao AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 19.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cons-sec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 19.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tp-material AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE rsTipoConsSec AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Sem Consumo", 1,
"Percurso/Qtd", 2,
"Qtd/Percurso", 3
     SIZE 14 BY 2 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 2.75.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65.14 BY 2.79.


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
     tt-mab-histor-combust.ep-codigo AT ROW 2.96 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-mab-histor-combust.cod-eqpto AT ROW 3.96 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-desc-modelo AT ROW 3.96 COL 40 COLON-ALIGNED NO-LABEL
     tt-mab-histor-combust.dat-inicial AT ROW 4.96 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     rtKeys AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     tt-mab-histor-combust.cod-tip-mater AT ROW 1.17 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-desc-tp-material AT ROW 1.17 COL 28.57 COLON-ALIGNED NO-LABEL
     tt-mab-histor-combust.val-capac-tanque AT ROW 2.17 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-mab-histor-combust.idi-tip-consu AT ROW 3.88 COL 20.14 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Sem Consumo", 1,
"Km-Hora/Qtd", 2,
"Qtd/Km-Hora", 3
          SIZE 14 BY 2
     tt-mab-histor-combust.val-consu-padr AT ROW 4.96 COL 49.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     c-desc-cons-padrao AT ROW 4.96 COL 61.86 COLON-ALIGNED NO-LABEL
     rsTipoConsSec AT ROW 7.04 COL 20 NO-LABEL
     tt-mab-histor-combust.val-livre-1 AT ROW 7.96 COL 49.43 COLON-ALIGNED
          LABEL "Consumo Secund†rio" FORMAT "->>>>>>>>>>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     c-desc-cons-sec AT ROW 7.96 COL 61.86 COLON-ALIGNED NO-LABEL
     tt-mab-histor-combust.dat-desativ AT ROW 9.58 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     "Consumo Secund†rio" VIEW-AS TEXT
          SIZE 14.72 BY .54 AT ROW 6.25 COL 20.86
     "Consumo" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 3.17 COL 20.86
     RECT-6 AT ROW 3.38 COL 19
     RECT-7 AT ROW 6.54 COL 19
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.25
         SIZE 84.43 BY 9.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-mab-histor-combust T "?" NO-UNDO mgfro mab-histor-combust
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
         MAX-HEIGHT         = 21.21
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.21
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
/* SETTINGS FOR FILL-IN tt-mab-histor-combust.val-livre-1 IN FRAME fPage1
   EXP-LABEL EXP-FORMAT                                                 */
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
     assign iEmpresa = &IF "{&mguni_version}" >= "2.071" &THEN tt-mab-histor-combust.ep-codigo:SCREEN-VALUE IN FRAME fPage0 &else int(tt-mab-histor-combust.ep-codigo:SCREEN-VALUE IN FRAME fPage0) &ENDIF
            cEqpto   = tt-mab-histor-combust.cod-eqpto:SCREEN-VALUE IN FRAME fPage0.
    {method/zoomreposition.i &ProgramZoom="frzoom\z01fr014.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-mab-histor-combust.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-histor-combust.cod-eqpto wMaintenance
ON LEAVE OF tt-mab-histor-combust.cod-eqpto IN FRAME fpage0 /* Equipamento */
DO:
    def var cRet as CHAR FORMAT "x(08)" no-undo.
    /***Busca c¢digo do modelo***/

    run goToKey IN hDBOEqpto      (input FRAME fPage0 tt-mab-histor-combust.ep-codigo,
                                   input FRAME fPage0 tt-mab-histor-combust.cod-eqpto).
    run getCharField in hDBOEqpto (input "cod-model":u,
                                   output cRet). 

 /***Busca descriá∆o do Modelo ***/

     {method\referenceFields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="cRet"
        &FieldName1="des-model"
        &FieldScreen1="c-desc-modelo"
        &Frame1="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-mab-histor-combust.cod-tip-mater
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-histor-combust.cod-tip-mater wMaintenance
ON LEAVE OF tt-mab-histor-combust.cod-tip-mater IN FRAME fPage1 /* Tipo Material */
DO:
   {method\referenceFields.i
      &HandleDBOLeave="hDBOMaterial"
      &KeyValue1="tt-mab-histor-combust.cod-tip-mater:screen-value in frame fPage1"
      &FieldName1="des-tip-mater"
      &FieldScreen1="c-desc-tp-material"
      &Frame1="fPage1"}
     
    /** Descriá∆o Consumo Padr∆o **/
    apply "VALUE-CHANGED":U to tt-mab-histor-combust.idi-tip-consu in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-mab-histor-combust.idi-tip-consu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-histor-combust.idi-tip-consu wMaintenance
ON VALUE-CHANGED OF tt-mab-histor-combust.idi-tip-consu IN FRAME fPage1
DO:
   run piLeaveTipoConsumo in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsTipoConsSec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsTipoConsSec wMaintenance
ON VALUE-CHANGED OF rsTipoConsSec IN FRAME fPage1
DO:
    /*IF tipo 2 ou 3 THEN*/
/*          ASSIGN tt-mab-histor-combust.val-livre-1:SENSITIVE IN FRAME fPage1 = YES. */
    /*else*/
/*          ASSIGN tt-mab-histor-combust.val-livre-1:SENSITIVE IN FRAME fPage1 = NO. */
    RUN piLeaveTipoConsumoSec IN THIS-PROCEDURE.
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
/** Modelo **/
if valid-handle(hDBOModelo) then
    run destroy in hDBOModelo.



/** Equipamento **/
if valid-handle(hDBOEqpto) then
    run destroy in hDBOEqpto.




RETURN "OK":U.
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
apply "LEAVE":U         to tt-mab-histor-combust.cod-eqpto     in frame fPage0.
apply "LEAVE":U         to tt-mab-histor-combust.cod-tip-mater in frame fPage1.
apply "VALUE-CHANGED":U to tt-mab-histor-combust.idi-tip-consu in frame fPage1.

ASSIGN rsTipoConsSec:SCREEN-VALUE IN FRAME fPage1 = IF  tt-mab-histor-combust.num-livre-1 > 0 THEN STRING(tt-mab-histor-combust.num-livre-1) ELSE "1"
       tt-mab-histor-combust.val-livre-1:SCREEN-VALUE IN FRAME fPage1 = STRING(tt-mab-histor-combust.val-livre-1).
APPLY "VALUE-CHANGED":U TO rsTipoConsSec IN FRAME fPage1.


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
if pRowSon <> ? then do:
    /*:T Reposiciona registro com base no rowid do browse do programa AB0138 */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT pRowSon).
end.

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
    DEFINE VARIABLE cep-codigo   LIKE {&ttTable}.ep-codigo  VIEW-AS FILL-IN SIZE 05.00 BY 0.88 NO-UNDO.
    DEFINE VARIABLE ccod-eqpto   LIKE {&ttTable}.cod-eqpto  VIEW-AS FILL-IN SIZE 16.00 BY 0.88 NO-UNDO.
    DEFINE VARIABLE ddat-inicial LIKE {&ttTable}.dat-inicial  VIEW-AS FILL-IN SIZE 10.00 BY 0.88 NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        cep-codigo  AT ROW 1.21 COL 17.72 COLON-ALIGNED
        ccod-eqpto  AT ROW 2.21 COL 17.72 COLON-ALIGNED
        ddat-inicial  AT ROW 3.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 4.63 COL 2.14
        btGoToCancel      AT ROW 4.63 COL 13
        rtGoToButton      AT ROW 4.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Hist¢rico do Combust°vel" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Hist¢rico_do_Combust°vel"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cep-codigo ccod-eqpto.
        
        RUN goToKey IN {&hDBOTable} (INPUT cep-codigo , INPUT ccod-eqpto , INPUT  ddat-inicial ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "mab-histor-combust":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cep-codigo ccod-eqpto  ddat-inicial btGoToOK btGoToCancel 
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
       {&hDBOTable}:FILE-NAME <> "frbo~\bofr014.p":U THEN DO:
        run frbo/bofr014.p persistent set  {&hDBOTable}.
    END.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    
   /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo~\bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.


    /*--- DBO Material ---*/
    IF NOT VALID-HANDLE(hDBOMaterial) OR
       hDBOMaterial:TYPE <> "PROCEDURE":U OR
       hDBOMaterial:FILE-NAME <> "frbo~\bofr026.p":U THEN DO:
        run frbo/bofr026.p persistent set  hDBOMaterial.
    END.
    
    RUN openQueryStatic IN hDBOMaterial (INPUT "Main":U) NO-ERROR.

 

    /*--- DBO Equipamento ---*/
    IF NOT VALID-HANDLE(hDBOEqpto) OR
       hDBOEqpto:TYPE <> "PROCEDURE":U OR
       hDBOEqpto:FILE-NAME <> "frbo~\bofr007.p":U THEN DO:
        run frbo/bofr007.p persistent set  hDBOEqpto.
    END.
    
    RUN openQueryStatic IN hDBOEqpto (INPUT "Main":U) NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLeaveTipoConsumo wMaintenance 
PROCEDURE piLeaveTipoConsumo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def var cRet as CHAR FORMAT "x(08)" no-undo.
case input frame fPage1 tt-mab-histor-combust.idi-tip-consu:
    when 1 then do:    /** Sem consumo **/
    assign c-desc-cons-padrao:screen-value in frame fPage1                = ""
           tt-mab-histor-combust.val-consu-padr                           = 0.
        display tt-mab-histor-combust.val-consu-padr
            with frame fPage1.
    end.
    when 2 or when 3 then do: /** 2 = KM-Hora/Qtd **/    /** 3 = Qtd/KM-Hora **/



    /***Busca c¢digo do modelo***/

    run goToKey IN hDBOEqpto      (input FRAME fPage0 tt-mab-histor-combust.ep-codigo,
                                   input FRAME fPage0 tt-mab-histor-combust.cod-eqpto).
    run getCharField in hDBOEqpto (input "cod-model":u,
                                   output cRet). 
        
        run buscaDescricaoConsumo in {&hDBOTable} (input cRet,
                                                   input  tt-mab-histor-combust.cod-tip-mater:screen-value in frame fPage1,
                                                   input  input frame fPage1 tt-mab-histor-combust.idi-tip-consu,
                                                   output c-desc-cons-padrao).
        display c-desc-cons-padrao
            with frame fPage1.
    end.
end case.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLeaveTipoConsumoSec wMaintenance 
PROCEDURE piLeaveTipoConsumoSec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def var cRet as CHAR FORMAT "x(08)" no-undo.
case input frame fPage1 rsTipoConsSec:
    when 1 then do:    /** Sem consumo **/
    ASSIGN c-desc-cons-sec:screen-value in frame fPage1                   = ""
           tt-mab-histor-combust.val-livre-1                              = 0.
        display tt-mab-histor-combust.val-livre-1
            with frame fPage1.
    end.
    when 2 or when 3 then do: /** 2 = Percurso/Qtd **/    /** 3 = Qtd/Percurso **/



    /***Busca c¢digo do modelo***/

    run goToKey IN hDBOEqpto      (input FRAME fPage0 tt-mab-histor-combust.ep-codigo,
                                   input FRAME fPage0 tt-mab-histor-combust.cod-eqpto).
    run getCharField in hDBOEqpto (input "cod-model":u,
                                   output cRet). 
        
        run buscaDescricaoConsumoSec in {&hDBOTable} (input cRet,
                                                   input  tt-mab-histor-combust.cod-tip-mater:screen-value in frame fPage1,
                                                   input  input frame fPage1 rsTipoConsSec,
                                                   output c-desc-cons-sec).
        display c-desc-cons-sec
            with frame fPage1.
    end.
end case.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

