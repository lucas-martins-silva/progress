&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0601D 2.00.00.001 } /*** 010001 ***/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AF0601D
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btHelp2
&GLOBAL-DEFINE page1Widgets   br-notas  br-notas1 c-narrativa


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


{afbo/boaf009.i tt-af-contr-indice-mov}

def input param p-cod-estabel  like af-contr-indice.cod-estabel       no-undo.
DEF INPUT PARAM p-ano-avaliacao    LIKE af-periodo-aval.ano-avaliacao NO-UNDO.
DEF INPUT PARAM p-des-periodo-aval LIKE af-periodo-aval.des-periodo-aval[1] NO-UNDO.
def input param p-dt-indice-ini    like af-contr-indice.dt-indice     no-undo.
def input param p-dt-indice-fim    like af-contr-indice.dt-indice     no-undo.
def input param p-cod-emitente like af-contr-indice.cod-emitente  no-undo.
def input param p-nome-abrev   like emitente.nome-abrev           no-undo.
def input param p-it-codigo    like af-contr-indice.it-codigo     no-undo.
def input param p-desc-item    like item.desc-item                no-undo.
def input param p-nr-controle  like af-contr-indice.nr-controle   no-undo.
def input param p-descricao    like af-controle.descricao         no-undo.
def input param p-indice       as   dec                           no-undo.
def input param p-percentual   as   dec                           no-undo.
def input param p-nota         as   dec                           no-undo.
def input param p-narrativa    as   char                          no-undo.

def buffer b-tt-af-contr-indice-mov for tt-af-contr-indice-mov.
def var h-boaf009 as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-notas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-af-contr-indice-mov ~
b-tt-af-contr-indice-mov

/* Definitions for BROWSE br-notas                                      */
&Scoped-define FIELDS-IN-QUERY-br-notas tt-af-contr-indice-mov.dt-movto tt-af-contr-indice-mov.num-pedido tt-af-contr-indice-mov.numero-ordem tt-af-contr-indice-mov.parcela tt-af-contr-indice-mov.preco-unit-ord tt-af-contr-indice-mov.pct-erro tt-af-contr-indice-mov.qtd-parcela tt-af-contr-indice-mov.un tt-af-contr-indice-mov.dt-implantacao tt-af-contr-indice-mov.dt-alter tt-af-contr-indice-mov.usuar-alter tt-af-contr-indice-mov.hora-alter   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-notas   
&Scoped-define SELF-NAME br-notas
&Scoped-define QUERY-STRING-br-notas FOR EACH tt-af-contr-indice-mov                            WHERE tt-af-contr-indice-mov.tipo-trans = 1                               by tt-af-contr-indice-mov.dt-movto
&Scoped-define OPEN-QUERY-br-notas OPEN QUERY {&SELF-NAME} FOR EACH tt-af-contr-indice-mov                            WHERE tt-af-contr-indice-mov.tipo-trans = 1                               by tt-af-contr-indice-mov.dt-movto.
&Scoped-define TABLES-IN-QUERY-br-notas tt-af-contr-indice-mov
&Scoped-define FIRST-TABLE-IN-QUERY-br-notas tt-af-contr-indice-mov


/* Definitions for BROWSE br-notas1                                     */
&Scoped-define FIELDS-IN-QUERY-br-notas1 b-tt-af-contr-indice-mov.dt-movto b-tt-af-contr-indice-mov.serie-docto b-tt-af-contr-indice-mov.nro-docto b-tt-af-contr-indice-mov.nat-operacao b-tt-af-contr-indice-mov.sequencia b-tt-af-contr-indice-mov.preco-unit-rec b-tt-af-contr-indice-mov.qtd-rec b-tt-af-contr-indice-mov.un   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-notas1   
&Scoped-define SELF-NAME br-notas1
&Scoped-define QUERY-STRING-br-notas1 FOR EACH b-tt-af-contr-indice-mov                            WHERE b-tt-af-contr-indice-mov.tipo-trans = 2                              and b-tt-af-contr-indice-mov.numero-ordem = tt-af-contr-indice-mov.numero-ordem                              and b-tt-af-contr-indice-mov.parcela = tt-af-contr-indice-mov.parcela                               by b-tt-af-contr-indice-mov.dt-movto
&Scoped-define OPEN-QUERY-br-notas1 OPEN QUERY {&SELF-NAME} FOR EACH b-tt-af-contr-indice-mov                            WHERE b-tt-af-contr-indice-mov.tipo-trans = 2                              and b-tt-af-contr-indice-mov.numero-ordem = tt-af-contr-indice-mov.numero-ordem                              and b-tt-af-contr-indice-mov.parcela = tt-af-contr-indice-mov.parcela                               by b-tt-af-contr-indice-mov.dt-movto.
&Scoped-define TABLES-IN-QUERY-br-notas1 b-tt-af-contr-indice-mov
&Scoped-define FIRST-TABLE-IN-QUERY-br-notas1 b-tt-af-contr-indice-mov


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-notas}~
    ~{&OPEN-QUERY-br-notas1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btHelp btQueryJoins btReportsJoins btExit ~
btHelp2 rtToolBar rtToolBar-2 

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

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 93 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 93 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE c-narrativa AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 91 BY 2.5
     FONT 2 NO-UNDO.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "X(5)" 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-dt-indice-fim AS CHARACTER FORMAT "99/9999":U INITIAL "010001" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-dt-indice-ini AS CHARACTER FORMAT "99/9999":U INITIAL "010001" 
     LABEL "Data Öndice" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE de-indice AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Öndice" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FGCOLOR 9 .

DEFINE VARIABLE de-nota AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Nota" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FGCOLOR 12 .

DEFINE VARIABLE de-percentual AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Perc." 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE i-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 9.5.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 93 BY 3.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 9.5.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 93 BY 2.75.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-notas FOR 
      tt-af-contr-indice-mov SCROLLING.

DEFINE QUERY br-notas1 FOR 
      b-tt-af-contr-indice-mov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-notas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-notas wWindow _FREEFORM
  QUERY br-notas DISPLAY
      tt-af-contr-indice-mov.dt-movto 
        tt-af-contr-indice-mov.num-pedido
        tt-af-contr-indice-mov.numero-ordem
        tt-af-contr-indice-mov.parcela
        tt-af-contr-indice-mov.preco-unit-ord
        tt-af-contr-indice-mov.pct-erro
        tt-af-contr-indice-mov.qtd-parcela column-label "Quantidade" format ">>>>,>>>,>>9.99"
        tt-af-contr-indice-mov.un
        tt-af-contr-indice-mov.dt-implantacao
        tt-af-contr-indice-mov.dt-alter
        tt-af-contr-indice-mov.usuar-alter
        tt-af-contr-indice-mov.hora-alter
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN NO-ROW-MARKERS SEPARATORS SIZE 43 BY 9
         FONT 1
         TITLE "Parcelas" ROW-HEIGHT-CHARS .5.

DEFINE BROWSE br-notas1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-notas1 wWindow _FREEFORM
  QUERY br-notas1 DISPLAY
      b-tt-af-contr-indice-mov.dt-movto      
        b-tt-af-contr-indice-mov.serie-docto
        b-tt-af-contr-indice-mov.nro-docto format "x(8)"
        b-tt-af-contr-indice-mov.nat-operacao
        b-tt-af-contr-indice-mov.sequencia
        b-tt-af-contr-indice-mov.preco-unit-rec
        b-tt-af-contr-indice-mov.qtd-rec column-label "Quantidade" format ">>>>,>>>,>>9.99"
        b-tt-af-contr-indice-mov.un
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN NO-ROW-MARKERS SEPARATORS NO-SCROLLBAR-VERTICAL SIZE 46 BY 9
         FONT 1
         TITLE "Recebimentos" ROW-HEIGHT-CHARS .5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 18.75 COL 2
     btCancel AT ROW 18.75 COL 13
     btHelp AT ROW 1.13 COL 89.29 HELP
          "Ajuda"
     btQueryJoins AT ROW 1.13 COL 77.29 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 81.29 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 85.29 HELP
          "Sair"
     btHelp2 AT ROW 18.71 COL 82.86
     rtToolBar AT ROW 18.5 COL 1
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 93.29 BY 18.96
         FONT 1.

DEFINE FRAME fPage1
     c-narrativa AT ROW 13.75 COL 2 NO-LABEL
     c-nome-abrev AT ROW 1.5 COL 59 COLON-ALIGNED NO-LABEL
     c-cod-estabel AT ROW 1.5 COL 6 COLON-ALIGNED HELP
          "C¢digo do estabelecimento"
     i-cod-emitente AT ROW 1.5 COL 49 COLON-ALIGNED HELP
          "C¢digo do fornecedor"
     c-dt-indice-ini AT ROW 1.5 COL 21 COLON-ALIGNED
     br-notas AT ROW 4.25 COL 2
     br-notas1 AT ROW 4.25 COL 48
     c-it-codigo AT ROW 2.5 COL 6 COLON-ALIGNED
     c-desc-item AT ROW 2.5 COL 22 COLON-ALIGNED NO-LABEL
     de-nota AT ROW 2.5 COL 82 COLON-ALIGNED HELP
          "C¢digo do fornecedor"
     de-indice AT ROW 1.5 COL 82 COLON-ALIGNED HELP
          "C¢digo do fornecedor"
     de-percentual AT ROW 2.5 COL 68 COLON-ALIGNED HELP
          "C¢digo do fornecedor"
     c-dt-indice-fim AT ROW 1.5 COL 30 COLON-ALIGNED NO-LABEL
     RECT-18 AT ROW 4 COL 47
     RECT-19 AT ROW 13.5 COL 1
     RECT-21 AT ROW 4 COL 1
     RECT-26 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.75
         SIZE 93 BY 15.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta Movimentos Pre‡o"
         HEIGHT             = 19.17
         WIDTH              = 93.29
         MAX-HEIGHT         = 19.17
         MAX-WIDTH          = 113.72
         VIRTUAL-HEIGHT     = 19.17
         VIRTUAL-WIDTH      = 113.72
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fPage1:MOVE-BEFORE-TAB-ITEM (btOK:HANDLE IN FRAME fpage0)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR BUTTON btCancel IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       btCancel:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR BUTTON btOK IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       btOK:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* BROWSE-TAB br-notas c-dt-indice-ini fPage1 */
/* BROWSE-TAB br-notas1 br-notas fPage1 */
ASSIGN 
       br-notas:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       br-notas:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

ASSIGN 
       br-notas1:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       br-notas1:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-dt-indice-fim IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-dt-indice-ini IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-codigo IN FRAME fPage1
   NO-ENABLE                                                            */
ASSIGN 
       c-narrativa:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN c-nome-abrev IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-indice IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-nota IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-percentual IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-emitente IN FRAME fPage1
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-notas
/* Query rebuild information for BROWSE br-notas
     _START_FREEFORM

OPEN QUERY {&SELF-NAME} FOR EACH tt-af-contr-indice-mov
                           WHERE tt-af-contr-indice-mov.tipo-trans = 1
                              by tt-af-contr-indice-mov.dt-movto.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-notas */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-notas1
/* Query rebuild information for BROWSE br-notas1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH b-tt-af-contr-indice-mov
                           WHERE b-tt-af-contr-indice-mov.tipo-trans = 2
                             and b-tt-af-contr-indice-mov.numero-ordem = tt-af-contr-indice-mov.numero-ordem
                             and b-tt-af-contr-indice-mov.parcela = tt-af-contr-indice-mov.parcela
                              by b-tt-af-contr-indice-mov.dt-movto.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-notas1 */
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

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Consulta Movimentos Pre‡o */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Consulta Movimentos Pre‡o */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-notas
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-notas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-notas wWindow
ON ROW-DISPLAY OF br-notas IN FRAME fPage1 /* Parcelas */
DO:
  if not tt-af-contr-indice-mov.correto then
     assign tt-af-contr-indice-mov.dt-movto:bgcolor     in browse {&browse-name} = 11     
            tt-af-contr-indice-mov.numero-ordem:bgcolor in browse {&browse-name} = 11 
            tt-af-contr-indice-mov.parcela:bgcolor      in browse {&browse-name} = 11      
            tt-af-contr-indice-mov.qtd-parcela:bgcolor  in browse {&browse-name} = 11
            tt-af-contr-indice-mov.pct-erro:bgcolor     in browse {&browse-name} = 11
            tt-af-contr-indice-mov.preco-unit-ord:bgcolor     in browse {&browse-name} = 11
            tt-af-contr-indice-mov.pct-erro:bgcolor     in browse {&browse-name} = 11
            tt-af-contr-indice-mov.dt-implantacao:bgcolor     in browse {&browse-name} = 11
            tt-af-contr-indice-mov.dt-alter:bgcolor     in browse {&browse-name} = 11
            tt-af-contr-indice-mov.usuar-alter:bgcolor     in browse {&browse-name} = 11
            tt-af-contr-indice-mov.hora-alter:bgcolor     in browse {&browse-name} = 11
            tt-af-contr-indice-mov.num-pedido:bgcolor     in browse {&browse-name} = 11
            tt-af-contr-indice-mov.un:bgcolor     in browse {&browse-name} = 11.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-notas wWindow
ON VALUE-CHANGED OF br-notas IN FRAME fPage1 /* Parcelas */
DO:
    {&OPEN-QUERY-br-notas1}  

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
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/MainBlock.i}

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


    IF VALID-HANDLE(h-boaf009) THEN
        RUN destroy IN h-boaf009.


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
def var i-nro-rows as int no-undo.

disp p-cod-estabel  @ c-cod-estabel 
     string(month(p-dt-indice-ini),"99") + string(year(p-dt-indice-ini)) @ c-dt-indice-ini
     string(month(p-dt-indice-fim),"99") + string(year(p-dt-indice-fim)) @ c-dt-indice-fim
     p-cod-emitente @ i-cod-emitente
     p-nome-abrev   @ c-nome-abrev
     p-it-codigo    @ c-it-codigo
     p-desc-item    @ c-desc-item
     p-indice       @ de-indice
     p-percentual   @ de-percentual
     p-nota         @ de-nota
     with frame fpage1.

    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-boaf009) THEN DO:
        run afbo/boaf009.p persistent set h-boaf009.
    END.

    RUN setConstraintChave IN h-boaf009 (input p-cod-estabel,
                                         input p-cod-estabel,
                                         input p-cod-emitente,
                                         input p-cod-emitente,
                                         input p-it-codigo,
                                         input p-it-codigo,
                                         input p-nr-controle,
                                         input p-nr-controle,
                                         input p-dt-indice-ini,
                                         input p-dt-indice-fim) NO-ERROR.

    RUN openQueryStatic IN h-boaf009 (INPUT "Chave":U) NO-ERROR.
    
    RUN getFirst        IN h-boaf009.
    RUN getBatchRecords IN h-boaf009 (INPUT ?,
                                      INPUT no,
                                      INPUT ?,
                                      output i-nro-rows,
                                      OUTPUT TABLE tt-af-contr-indice-mov).
    
    assign c-narrativa = p-narrativa.
    disp c-narrativa
         with frame fpage1.

    {&OPEN-QUERY-br-notas}
    {&OPEN-QUERY-br-notas1}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

