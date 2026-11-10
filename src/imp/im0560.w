&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-cotacao-item NO-UNDO LIKE movind.cotacao-item
       field r-rowid as rowid
       .


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0560 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0560 MIM}
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
&GLOBAL-DEFINE Program        IM0560
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0

&GLOBAL-DEFINE FolderLabels   Importa‡Æo

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

&GLOBAL-DEFINE ttTable        tt-cotacao-item
&GLOBAL-DEFINE hDBOTable      hDBOCotacao-itemi
&GLOBAL-DEFINE DBOTable       cotacao-item

&GLOBAL-DEFINE page0KeyFields tt-cotacao-item.numero-ordem ~
                              tt-cotacao-item.cod-emitente ~
                              tt-cotacao-item.it-codigo ~
                              tt-cotacao-item.seq-cotac
&GLOBAL-DEFINE page0Fields    i-mapa-cotacao ~
                              c-cod-incoterm ~
                              i-cod-pto-contr ~
                              i-cod-fabricante ~
                              i-regime-import ~
                              c-class-fiscal ~
                              de-aliq-ii ~
                              de-aliq-ipi
                              
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}         AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEmitente         AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOCotacao-item-cex AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOPto-contr        AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOItem             AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOCotacao-item     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOOrdem-compra     AS HANDLE NO-UNDO.

def new global shared var gr-ordem-compra     as rowid no-undo.
def new global shared var gr-cotacao-item-cex as rowid no-undo.
def new global shared var gr-cotacao-item-i   as rowid no-undo. 
def new global shared var gc-opcao-im0060     as char  no-undo.

def new global shared var gi-numero-ordem-i   like ordem-compra.numero-ordem no-undo.
def new global shared var gi-cod-emitente-i   like emitente.cod-emitente     no-undo.
def new global shared var gc-it-codigo-i      like item.it-codigo            no-undo.
def new global shared var gi-seq-cotac-i      like cotacao-item.seq-cotac    no-undo.
def new global shared var gl-returnok         as   logical                   no-undo.
def new global shared var gc-char-1           like cotacao-item.char-1       no-undo.
def new global shared var gc-char-2           like cotacao-item.char-2       no-undo.

/* Vari veis */
def var i-mapa-cotacao-aux as integer no-undo.
def var i-tipo-contr       as integer no-undo.
def var i-numero-ordem     as integer no-undo.

/* Includes */
{cdp/cd4300.i3} 
{include/boerrtab.i}
{cdp/cdcfgmat.i}

/* Temp-tables */ 
{inbo/boin082i.i tt-cotacao-imp}   /* Defini‡Æo temp-table auxiliar (importa‡Æo)     */
{inbo/boin082.i tt-cotacao-item-i} /* Defini‡Æo temp-table auxiliar (importa‡Æo) */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-cotacao-item.numero-ordem ~
tt-cotacao-item.cod-emitente tt-cotacao-item.it-codigo ~
tt-cotacao-item.seq-cotac 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}numero-ordem ~{&FP2}numero-ordem ~{&FP3}~
 ~{&FP1}cod-emitente ~{&FP2}cod-emitente ~{&FP3}~
 ~{&FP1}it-codigo ~{&FP2}it-codigo ~{&FP3}~
 ~{&FP1}seq-cotac ~{&FP2}seq-cotac ~{&FP3}
&Scoped-define ENABLED-TABLES tt-cotacao-item
&Scoped-define FIRST-ENABLED-TABLE tt-cotacao-item
&Scoped-Define ENABLED-OBJECTS rtToolBar btFirst btPrev btNext btLast ~
btGoTo btSearch bt-desp-imp btQueryJoins btReportsJoins btExit btHelp ~
rtKeys c-nome-abrev1 l-cot-aprovada rtKeys-2 i-mapa-cotacao c-cod-incoterm ~
i-cod-pto-contr c-descricao i-cod-fabricante c-nome-abrev2 i-regime-import ~
c-class-fiscal de-aliq-ii de-aliq-ipi 
&Scoped-Define DISPLAYED-FIELDS tt-cotacao-item.numero-ordem ~
tt-cotacao-item.cod-emitente tt-cotacao-item.it-codigo ~
tt-cotacao-item.seq-cotac 
&Scoped-Define DISPLAYED-OBJECTS c-nome-abrev1 l-cot-aprovada ~
i-mapa-cotacao c-cod-incoterm i-cod-pto-contr c-descricao i-cod-fabricante ~
c-nome-abrev2 i-regime-import c-class-fiscal de-aliq-ii de-aliq-ipi 

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
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
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
DEFINE BUTTON bt-desp-imp 
     IMAGE-UP FILE "image~\im-orcto":U
     LABEL "Despesas de Importa‡Æo" 
     SIZE 4 BY 1.25 TOOLTIP "Despesas de Importa‡Æo".

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

DEFINE VARIABLE c-class-fiscal AS CHARACTER FORMAT "9999.99.99":U 
     LABEL "Classifica‡Æo Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-incoterm AS CHARACTER FORMAT "X(3)":U 
     LABEL "Incoterm" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev1 AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev2 AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-aliq-ii AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Al¡quota II" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE de-aliq-ipi AS DECIMAL FORMAT ">>9.99" INITIAL 10 
     LABEL "Al¡quota IPI":R15 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE i-cod-fabricante AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fabricante" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-pto-contr AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Ponto de Controle Base" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE i-mapa-cotacao AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Mapa de Cota‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE i-regime-import AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Regime Importa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 4.38.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 8.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE l-cot-aprovada AS LOGICAL INITIAL no 
     LABEL "Cota‡Æo Aprovada" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.43 BY .88 NO-UNDO.


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
     bt-desp-imp AT ROW 1.13 COL 69.72
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-cotacao-item.numero-ordem AT ROW 3.04 COL 38.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-cotacao-item.cod-emitente AT ROW 4.04 COL 38.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-nome-abrev1 AT ROW 4.04 COL 49.29 COLON-ALIGNED NO-LABEL
     tt-cotacao-item.it-codigo AT ROW 5.04 COL 38.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     tt-cotacao-item.seq-cotac AT ROW 6.04 COL 38.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     l-cot-aprovada AT ROW 6.04 COL 45.29
     i-mapa-cotacao AT ROW 7.29 COL 38.29 COLON-ALIGNED HELP
          "Mapa de cota‡Æo de despesas."
     c-cod-incoterm AT ROW 8.29 COL 38.29 COLON-ALIGNED HELP
          "Incoterm."
     i-cod-pto-contr AT ROW 9.29 COL 38.29 COLON-ALIGNED HELP
          "Ponto de controle base."
     c-descricao AT ROW 9.29 COL 45.29 COLON-ALIGNED NO-LABEL
     i-cod-fabricante AT ROW 10.29 COL 38.29 COLON-ALIGNED HELP
          "Fabricante do material no exterior."
     c-nome-abrev2 AT ROW 10.29 COL 49.29 COLON-ALIGNED NO-LABEL
     i-regime-import AT ROW 11.29 COL 38.29 COLON-ALIGNED HELP
          "Regime de importa‡Æo."
     c-class-fiscal AT ROW 12.29 COL 38.29 COLON-ALIGNED HELP
          "Classifica‡Æo fiscal do item."
     de-aliq-ii AT ROW 13.29 COL 38.29 COLON-ALIGNED HELP
          "Al¡quota do Imposto de Importa‡Æo."
     de-aliq-ipi AT ROW 14.29 COL 38.29 COLON-ALIGNED
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
     rtKeys-2 AT ROW 7.17 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14.92
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-cotacao-item T "?" NO-UNDO movind cotacao-item
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
         TITLE              = "Cota‡Æo do Item (Importa‡Æo)"
         HEIGHT             = 14.71
         WIDTH              = 90.43
         MAX-HEIGHT         = 20.17
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 20.17
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance /* Cota‡Æo do Item (Importa‡Æo) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance /* Cota‡Æo do Item (Importa‡Æo) */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desp-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desp-imp wMaintenance
ON CHOOSE OF bt-desp-imp IN FRAME fpage0 /* Despesas de Importa‡Æo */
DO:
    run findMapaCotacao in hDBOCotacao-item-cex (input tt-cotacao-item.numero-ordem,
                                                 input tt-cotacao-item.cod-emitente,
                                                 input tt-cotacao-item.it-codigo,
                                                 input tt-cotacao-item.seq-cotac,
                                                 input tt-cotacao-item.data-cotacao,
                                                 input i-mapa-cotacao).
    run getRowid in hDBOCotacao-item-cex (output gr-cotacao-item-cex).
    run imp/im0010.w.
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
/*
    {method/zoomreposition.i &ProgramZoom="<ProgramName>"}
*/    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-class-fiscal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-fiscal wMaintenance
ON LEAVE OF c-class-fiscal IN FRAME fpage0 /* Classifica‡Æo Fiscal */
DO:
    run geraAliquota in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-cotacao-item.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cotacao-item.cod-emitente wMaintenance
ON LEAVE OF tt-cotacao-item.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
    {method/ReferenceFields.i
        &HandleDBOLeave="hDBOEmitente"
        &KeyValue1="tt-cotacao-item.cod-emitente"
        &FieldName1="nome-abrev"
        &FieldScreen1="c-nome-abrev1"
        &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-fabricante
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-fabricante wMaintenance
ON LEAVE OF i-cod-fabricante IN FRAME fpage0 /* Fabricante */
DO:
    {method/ReferenceFields.i
        &HandleDBOLeave="hDBOEmitente"
        &KeyValue1="integer(i-cod-fabricante:screen-value in frame fPage0)"
        &FieldName1="nome-abrev"
        &FieldScreen1="c-nome-abrev2"
        &Frame1="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-pto-contr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-pto-contr wMaintenance
ON LEAVE OF i-cod-pto-contr IN FRAME fpage0 /* Ponto de Controle Base */
DO:
    {method/ReferenceFields.i
        &HandleDBOLeave="hDBOPto-contr"
        &KeyValue1="integer(i-cod-pto-contr:screen-value in frame fPage0)"
        &FieldName1="descricao"
        &FieldScreen1="c-descricao"
        &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-regime-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-regime-import wMaintenance
ON LEAVE OF i-regime-import IN FRAME fpage0 /* Regime Importa‡Æo */
DO:
    run geraAliquota in this-procedure.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*--- L¢gica para inicializa‡Æo do programam ---*/
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

    IF VALID-HANDLE(hDBOEmitente) THEN
        RUN destroy IN hDBOEmitente.
        
    IF VALID-HANDLE(hDBOCotacao-item-cex) THEN
        RUN destroy IN hDBOCotacao-item-cex.
        
    IF VALID-HANDLE(hDBOPto-contr) THEN
        RUN destroy IN hDBOPto-contr.

    IF VALID-HANDLE(hDBOItem) THEN
        RUN destroy IN hDBOItem.
        
    IF VALID-HANDLE(hDBOCotacao-item) THEN
        RUN destroy IN hDBOCotacao-item.        
        
    IF VALID-HANDLE(hDBOOrdem-compra) THEN
        RUN destroy IN hDBOOrdem-compra.                

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayfields wMaintenance 
PROCEDURE afterDisplayfields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if avail tt-cotacao-item then do:
    
        {ccp/cc9019.i50}
        {cdp/cd4300.i4 "yes" tt-cotacao-item.char-1}
        {ccp/cc9019.i51 "yes"}

        &if '{&bf_mat_versao_ems}' >= '2.062' &then
            {ocp/oc0201.i50}
            {ocp/oc0201.i51 "yes"}
        &else
            {ccp/cc0303.i50}
            {ccp/cc0303.i51 "yes"}
        &endif
        {cdp/cd4300.i4 "yes" tt-cotacao-item.char-2}
        
        assign l-cot-aprovada   = tt-cotacao-item.cot-aprovada
               i-mapa-cotacao   = i-mapa-cotacao-i50
               c-cod-incoterm   = c-cod-incoterm-i50
               i-cod-pto-contr  = i-cod-pto-contr-i50
               i-cod-fabricante = i-cod-fabricante-i50
               i-regime-import  = i-regime-import-i50
               c-class-fiscal   = c-class-fiscal-i50
               de-aliq-ii       = de-aliq-ii-i50
               de-aliq-ipi      = tt-cotacao-item.aliquota-ipi.
        
        disp l-cot-aprovada 
             i-mapa-cotacao
             c-cod-incoterm
             i-cod-pto-contr
             i-cod-fabricante
             i-regime-import
             c-class-fiscal
             de-aliq-ii
             de-aliq-ipi
             with frame fPage0.

        apply "leave":U to tt-cotacao-item.cod-emitente in frame fPage0.
        apply "leave":U to i-cod-fabricante             in frame fPage0.
        apply "leave":U to i-cod-pto-contr              in frame fPage0.
        
        if tt-cotacao-item.it-codigo <> "":U then do:
            {method/ReferenceFields.i
                &HandleDBOLeave="hDBOItem"
                &KeyValue1="tt-cotacao-item.it-codigo"
                &FieldName1="class-fiscal"
                &FieldScreen1="c-class-fiscal"
                &Frame1="fPage0"}
        end.

    end.    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
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
    
    DEFINE VARIABLE i-numero-ordem LIKE {&ttTable}.numero-ordem NO-UNDO.
    DEFINE VARIABLE i-cod-emitente LIKE {&ttTable}.cod-emitente NO-UNDO.
    DEFINE VARIABLE c-it-codigo    LIKE {&tttable}.it-codigo    NO-UNDO.
    DEFINE VARIABLE i-seq-cotac    LIKE {&ttTable}.seq-cotac    NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        i-numero-ordem    AT ROW 1.21 COL 17.72 COLON-ALIGNED
        i-cod-emitente    AT ROW 2.21 COL 17.72 COLON-ALIGNED
        c-it-codigo       AT ROW 3.21 COL 17.72 COLON-ALIGNED
        i-seq-cotac       AT ROW 4.21 COL 17.72 COLON-ALIGNED        
        btGoToOK          AT ROW 5.63 COL 2.14
        btGoToCancel      AT ROW 5.63 COL 13
        rtGoToButton      AT ROW 5.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Cota‡Æo do Item" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
        
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-numero-ordem
               i-cod-emitente
               c-it-codigo
               i-seq-cotac.
        
        RUN goToKey IN {&hDBOTable} (INPUT i-numero-ordem, 
                                     INPUT i-cod-emitente,
                                     INPUT c-it-codigo,
                                     INPUT i-seq-cotac).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Cota‡Æo_do_Item" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).            
            RETURN NO-APPLY.
        END.
        
        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE btGotoOK btGotoCancel i-numero-ordem i-cod-emitente c-it-codigo i-seq-cotac
        WITH FRAME fGoToRecord.
        
    assign i-numero-ordem:height = 0.88
           i-numero-ordem:width  = 10
           i-cod-emitente:height = 0.88
           i-cod-emitente:width  = 10
           c-it-codigo:height    = 0.88
           c-it-codigo:width     = 16
           i-seq-cotac:height    = 0.88
           i-seq-cotac:width     = 3.

    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
        {&hDBOTable}:TYPE <> "PROCEDURE":U OR
        {&hDBOTable}:FILE-NAME <> "inbo/boin082i.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin082i.p YES}
        {btb/btb008za.i2 inbo/boin082i.p '' {&hDBOTable}}
    END.
    
    /*
    ** OpenQuery Tabela principal
    */    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    /* 
    ** Instƒnciar BO campo de tabela estrangeira (emitente)
    */ 
    {btb/btb008za.i1 adbo/boad098na.p YES}
    {btb/btb008za.i2 adbo/boad098na.p '' hDBOEmitente}
    RUN openQueryStatic IN hDBOEmitente (INPUT "Main":U) NO-ERROR.
    
    /* 
    ** Instƒnciar BO campo de tabela estrangeira (cotacao-item-cex)
    */ 
    {btb/btb008za.i1 cxbo/bocx085na.p YES}
    {btb/btb008za.i2 cxbo/bocx085na.p '' hDBOCotacao-item-cex}
    RUN openQueryStatic IN hDBOCotacao-item-cex (INPUT "Main":U) NO-ERROR.
    
    /*
    ** Instƒnciar BO campo de tabela estrangeira (pto-contr)
    */
    {btb/btb008za.i1 cxbo/bocx110na.p YES}
    {btb/btb008za.i2 cxbo/bocx110na.p '' hDBOPto-contr}
    RUN openQueryStatic IN hDBOPto-contr (INPUT "Main":U) NO-ERROR.
    
    /*
    ** Instƒnciar BO campo de tabela estrangeira (item)
    */
    {btb/btb008za.i1 inbo/boin172na.p YES}
    {btb/btb008za.i2 inbo/boin172na.p '' hDBOItem}
    RUN openQueryStatic IN hDBOItem (INPUT "Main":U) NO-ERROR.    
    
    /*
    ** Posicionamento se chamado para modifica‡Æo
    */    
    if gr-cotacao-item-i <> ? then do:        
        run setConstraintRowid IN {&hDBOTable} (input gr-cotacao-item-i) no-error.
        RUN openQueryStatic IN {&hDBOTable} (INPUT "Rowid":U) NO-ERROR.
    end.
    else do:
        if gr-ordem-compra <> ? then do:
            /*
            ** Instƒnciar BO campo de tabela estrangeira (cotacao-item)
            */
            {btb/btb008za.i1 inbo/boin082.p YES}
            {btb/btb008za.i2 inbo/boin082.p '' hDBOCotacao-item}
            RUN openQueryStatic IN hDBOCotacao-Item (INPUT "Main":U) NO-ERROR.
            
            /*
            ** Instƒnciar BO campo de tabela estrangeira (ordem-compra)
            */
            {btb/btb008za.i1 inbo/boin274na.p YES}
            {btb/btb008za.i2 inbo/boin274na.p '' hDBOOrdem-compra}
            RUN openQueryStatic IN hDBOOrdem-compra (INPUT "Main":U) NO-ERROR.
            
            RUN findRowid IN hDBOOrdem-compra (input gr-ordem-compra).
            RUN getIntField IN hDBOOrdem-compra (input "numero-ordem":U,output i-numero-ordem).
            
            RUN gotoCotacaoAprovada IN hDBOCotacao-item (input i-numero-ordem).
            RUN getRowid IN hDBOCotacao-item (output gr-cotacao-item-i) no-error.
            run setConstraintRowid IN {&hDBOTable} (input gr-cotacao-item-i) no-error.
            RUN openQueryStatic IN {&hDBOTable} (INPUT "Rowid":U) NO-ERROR.
        end.
    end.
    
    assign gr-cotacao-item-i = ?
           gr-ordem-compra   = ?.           
    
    enable bt-desp-imp
        with frame fPage0.            
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


