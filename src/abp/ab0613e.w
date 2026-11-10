&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
USING com.totvs.framework.utp.treelist.*.

{include/i-prgvrs.i AB0613E 2.00.00.008 } /*** "010008" 16/09/2024 11:31:24 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0613e MAB}
&ENDIF


/********************************************************************************
** Copyright DATasUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATasUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0613E
&GLOBAL-DEFINE Version        2.00.00.008

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         no

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btExpande btImprimir btRepos btRepos ~
                              btInclui btElimina btGrafico btExcel btTxt

/* Local Variable Definitions ---                                       */
define variable i-cont        as integer                  no-undo.
define variable iResult       as integer                  no-undo.
define variable iImage        as integer                  no-undo.
define variable iButtonTree   as integer                  no-undo.
define variable rVisao        as rowid                    no-undo.
define variable cCodPai       as character                no-undo.
define variable cCodPai2      as character                no-undo.
define variable hUTAPI011     as handle                   no-undo.

DEFINE VARIABLE oTreeList     AS CLASS TotvsTreeList      NO-UNDO. // Visao
DEFINE VARIABLE oTreeList-1   AS CLASS TotvsTreeList      NO-UNDO. // Visao
DEFINE VARIABLE oTreeList-2   AS CLASS TotvsTreeList      NO-UNDO. // Visao

/** Controles **/
define variable l-expande     as log init no              no-undo.
define variable l-ok          as log                      no-undo.
/** Pop-Menu **/
define variable pop-menu      as widget-handle            no-undo.
define variable exp-con       as widget-handle            no-undo.
define variable detalhe       as widget-handle            no-undo.
define variable regua         as widget-handle            no-undo.
/*** Window ***/
define variable dWinXC        as decimal                  no-undo.
define variable dWinYC        as decimal                  no-undo.
/** TXT e Excel **/
define variable cTituloTxt    as character format "x(256)" no-undo.
define variable cDescPai      as character format "x(256)" no-undo.
define variable i-cont2       as integer                   no-undo.
/** Classificaá∆o **/
def temp-table ttVisao no-undo
    field dimensao  as character
    field sequencia as integer
    index codigo is primary unique sequencia.
def temp-table ttVisao2 no-undo like ttVisao.
def temp-table ttVisao3 no-undo like ttVisao
    field seq-orig as integer.

/** Dados **/
def temp-table ttDados no-undo
    field sequencia         as   integer
    field cod-dimensao      as   character format "x(300)"
    field cod-oficial       as   character format "X(16)"
    field desc-dimensao     as   character format "x(32)"
    field cod-dimens-pai    as   character format "x(300)"
    field uso-real          as   decimal format ">>>,>>>,>>9.9"
    field uso-padrao        as   decimal format ">>>,>>>,>>9.9"
    field diferenca         as   decimal format "->>,>>>,>>9.9"
    field perc-desvio       as   decimal format "->>9.9"
    field un                as   character format "x(2)"
    field iPrazo            as   integer /** 1=Antes 2=Dentro 3=Ap¢s **/ 
    field iAntes            as   integer
    field iDentro           as   integer
    field iApos             as   integer
    field r-rowid           as   rowid
    field p-image           as   integer
    field seq-tree          as   integer
    field quantidade        as   decimal format ">>>,>>9.99"
    field valor             as   decimal format ">>>,>>9.99"
    index id is primary unique sequencia ascending
                               cod-dimensao ascending.

def temp-table ttDados2 no-undo
    field sequencia         as   integer
    field cod-dimensao      as   character format "x(300)"
    field cod-oficial       as   character format "X(16)"
    field desc-dimensao     as   character format "x(32)"
    field cod-dimens-pai    as   character format "x(300)"
    field iAntes            as   integer
    field iDentro           as   integer
    field iApos             as   integer
    field r-rowid           as   rowid
    field p-image           as   integer
    field seq-tree          as   integer
    index id is primary unique sequencia ascending
                               cod-dimensao ascending.

/** Definiá∆o dos parÉmetros ------------------------------**/
define input parameter table for ttVisao.
define input parameter table for ttDados.

define buffer bfttDados   for ttDados.
define buffer bfttDados2  for ttDados2.
define buffer bfVisao3    for ttVisao3.
{utp/utapi011.i} /** Gr†fico **/
{abp/ab0613.i}  /** Definiá∆o da temp-table de parÉmetros **/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btExpande btImprimir btGrafico ~
btExcel btTxt btQueryJoins btReportsJoins btExit btHelp btRepos btInclui ~
btElimina 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCampos wWindow 
FUNCTION fnCampos RETURNS CHARACTER
  ( pCampo as character,
    iTipo  as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnLabels wWindow 
FUNCTION fnLabels RETURNS CHARACTER
  ( pImage as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMes wWindow 
FUNCTION fnMes RETURNS CHARACTER
( iMes as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPrazo wWindow 
FUNCTION fnPrazo RETURNS CHARACTER
  ( iPrazo as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU miArquivo 
       MENU-ITEM miExpande      LABEL "&Expande/Contrai" ACCELERATOR "CTRL-E"
       RULE
       MENU-ITEM miImprimir     LABEL "&Imprimir"      ACCELERATOR "CTRL-J"
       MENU-ITEM miGrafico      LABEL "&Gr†fico"       ACCELERATOR "CTRL-G"
       MENU-ITEM miExcel        LABEL "E&xcel"         ACCELERATOR "CTRL-L"
       MENU-ITEM miTxt          LABEL "Texto"          ACCELERATOR "CTRL-T"
       RULE
       MENU-ITEM miQueryJoins   LABEL "C&onsultas"    
       MENU-ITEM miReportsJoins LABEL "Rela&t¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  miArquivo      LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "Aj&uda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btElimina 
     IMAGE-UP FILE "image\im-acm1":U
     IMAGE-INSENSITIVE FILE "image\ii-acm1":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Elimina"
     FONT 4.

DEFINE BUTTON btExcel 
     IMAGE-UP FILE "image\excel":U
     LABEL "Planilha" 
     SIZE 4 BY 1.25 TOOLTIP "Exportar para Excel".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExpande 
     IMAGE-UP FILE "image\im-crit":U
     IMAGE-INSENSITIVE FILE "image\ii-crit":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Expande / Contrai"
     FONT 4.

DEFINE BUTTON btGrafico 
     IMAGE-UP FILE "image/im-grf.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-grf.bmp":U
     LABEL "Gr†fico" 
     SIZE 4 BY 1.25 TOOLTIP "Gr†fico".

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btImprimir 
     IMAGE-UP FILE "image/im-prigr.bmp":U
     IMAGE-INSENSITIVE FILE "image/im-prigr.bmp":U
     LABEL "Impress∆o" 
     SIZE 4 BY 1.25 TOOLTIP "Impress∆o".

DEFINE BUTTON btInclui 
     IMAGE-UP FILE "image\im-adduni":U
     IMAGE-INSENSITIVE FILE "image\ii-adduni":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Inclui na Agenda"
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

DEFINE BUTTON btRepos 
     LABEL "" 
     SIZE 1 BY 17.25.

DEFINE BUTTON btTxt 
     IMAGE-UP FILE "image/mab-txt.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Exportar para TXT".

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btExpande AT ROW 1.13 COL 51
     btImprimir AT ROW 1.13 COL 55 HELP
          "Impress∆o"
     btGrafico AT ROW 1.13 COL 59 HELP
          "Gr†fico"
     btExcel AT ROW 1.13 COL 63
     btTxt AT ROW 1.13 COL 67
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     btRepos AT ROW 2.5 COL 65
     btInclui AT ROW 10.5 COL 82 HELP
          "Inclui na Agenda"
     btElimina AT ROW 10.5 COL 86 HELP
          "Elimina Agendamento"
     rtToolBar-2 AT ROW 1 COL 1
     SPACE(0.00) SKIP(17.25)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
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
         TITLE              = ""
         HEIGHT             = 19
         WIDTH              = 90
         MAX-HEIGHT         = 320
         MAX-WIDTH          = 320
         VIRTUAL-HEIGHT     = 320
         VIRTUAL-WIDTH      = 320
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{utp/ut-glob.i}
{btb/btb008za.i0}
{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Size-to-Fit                                               */
ASSIGN 
       FRAME fpage0:SCROLLABLE       = FALSE.

ASSIGN 
       btRepos:MOVABLE IN FRAME fpage0          = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-MAXIMIZED OF wWindow
DO:
    def var dXC    as dec    no-undo.
    def var dYC    as dec    no-undo.
    DEF VAR hlabel AS HANDLE NO-UNDO.
     
  
    assign /**--------------------------------- Tamanho da tela ----------------------------------------------**/
           dXC                                     = wWindow:width-chars  - dWinXC
           dYC                                     = wWindow:height-chars - dWinYC
           dWinXC                                  = wWindow:width-chars
           dWinYC                                  = wWindow:HEIGHT-CHARS
           /**-------------------------------- Tamanho dos frames --------------------------------------------**/
           frame fPage0:width-chars                = wWindow:width-chars
           frame fPage0:height-chars               = wWindow:height-chars
           /**--------------------------------- Objetos em tela ----------------------------------------------**/
           rtToolBar-2:width-chars in frame fPage0 = (rtToolBar-2:width-chars in frame fPage0 + dXC)
           btHelp:column in frame fPage0           = (btHelp:column in frame fPage0 + dXC)
           btExit:column in frame fPage0           = (btExit:column in frame fPage0 + dXC)
           btReportsJoins:column in frame fPage0   = (btReportsJoins:column in frame fPage0 + dXC)
           btQueryJoins:column in frame fPage0     = (btQueryJoins:column in frame fPage0 + dXC)
           btImprimir:column in frame fPage0       = (btImprimir:column in frame fPage0 + dXC)
           btGrafico:column in frame fPage0        = (btGrafico:column in frame fPage0 + dXC)
           btExcel:column in frame fPage0          = (btExcel:column in frame fPage0 + dXC)
           btTxt:column in frame fPage0            = (btTxt:column in frame fPage0 + dXC)
           btExpande:column in frame fPage0        = (btExpande:column in frame fPage0 + dXC)
           btInclui:column in frame fPage0         = (btInclui:column in frame fPage0 + dXC)
           btElimina:column in frame fPage0        = (btElimina:column in frame fPage0 + dXC)
           btInclui:row in frame fPage0            = (btInclui:row in frame fPage0 + (dYC / 2))
           btElimina:row in frame fPage0           = (btElimina:row in frame fPage0 + (dYC / 2))
           btRepos:height-chars in frame fPage0    = (btRepos:height-chars in frame fPage0 + dYC)
           btRepos:column in frame fPage0          = (btRepos:column in frame fPage0 + dXC)
           oTreeList:height                        = oTreeList:height    +  dYC 
           oTreeList-1:height                      = oTreeList-1:height  + (dYC / 2)
           oTreeList-2:ROW                         = oTreeList-2:row     + (dYC / 2)
           oTreeList-2:height                      = oTreeList-2:height  + (dYC / 2) 
           NO-ERROR.

    APPLY "END-MOVE":U TO btRepos in frame fPage0.
          
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-RESTORED OF wWindow
DO:
    def var dXC    as dec    no-undo.
    def var dYC    as dec    no-undo.
    DEF VAR hlabel AS HANDLE NO-UNDO.
   

    assign /**--------------------------------- Tamanho da tela ----------------------------------------------**/
           dXC                                     = dWinXC - wWindow:width-chars
           dYC                                     = dWinYC - wWindow:height-chars
           dWinXC                                  = wWindow:width-chars
           dWinYC                                  = wWindow:HEIGHT-CHARS
           /**--------------------------------- Objetos em tela ----------------------------------------------**/
           rtToolBar-2:width-chars in frame fPage0 = (rtToolBar-2:width-chars in frame fPage0 - dXC)
           btHelp:column in frame fPage0           = (btHelp:column in frame fPage0 - dXC)
           btExit:column in frame fPage0           = (btExit:column in frame fPage0 - dXC)
           btReportsJoins:column in frame fPage0   = (btReportsJoins:column in frame fPage0 - dXC)
           btQueryJoins:column in frame fPage0     = (btQueryJoins:column in frame fPage0 - dXC)
           btImprimir:column in frame fPage0       = (btImprimir:column in frame fPage0 - dXC)
           btGrafico:column in frame fPage0        = (btGrafico:column in frame fPage0 - dXC)
           btExcel:column in frame fPage0          = (btExcel:column in frame fPage0 - dXC)
           btTxt:column in frame fPage0            = (btTxt:column in frame fPage0 - dXC)
           btExpande:column in frame fPage0        = (btExpande:column in frame fPage0 - dXC)
           btElimina:column in frame fPage0        = (btElimina:column in frame fPage0 - dXC)
           btInclui:column in frame fPage0         = (btInclui:column in frame fPage0 - dXC)
           btInclui:row in frame fPage0            = (btInclui:row in frame fPage0 - (dYC / 2))
           btElimina:row in frame fPage0           = (btElimina:row in frame fPage0 - (dYC / 2))
           btRepos:height-chars in frame fPage0    = (btRepos:height-chars in frame fPage0 - dYC)
           btRepos:column in frame fPage0          = (btRepos:column in frame fPage0 - dXC)
           oTreeList:height                        = oTreeList:height    -  dYC 
           oTreeList-1:height                      = oTreeList-1:height  - (dYC / 2)
           oTreeList-2:ROW                         = oTreeList-2:row     - (dYC / 2)
           oTreeList-2:height                      = oTreeList-2:height  - (dYC / 2)
           /**-------------------------------- Tamanho dos frames --------------------------------------------**/
           frame fPage0:width-chars                = wWindow:width-chars
           frame fPage0:height-chars               = wWindow:HEIGHT-CHARS   NO-ERROR.

    apply "END-MOVE":U to btRepos in frame fPage0.

    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btElimina
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btElimina wWindow
ON CHOOSE OF btElimina IN FRAME fpage0
DO:
  run piElimina in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcel wWindow
ON CHOOSE OF btExcel IN FRAME fpage0 /* Planilha */
OR CHOOSE OF MENU-ITEM miExcel  IN MENU mbMain DO:
    if oTreeList:hasNode() then do:
        run piExcel in this-procedure.
    end.
    apply "ENTRY":U to btExcel in frame fPage0.
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


&Scoped-define SELF-NAME btExpande
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExpande wWindow
ON CHOOSE OF btExpande IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miExpande  IN MENU mbMain DO:
    /** Verifica se existem dados no tree-view **/
    IF  oTreeList:hasNode() THEN DO:
        /** Controla expansao **/
        assign l-expande = not l-expande.

        IF  l-expande   THEN    oTreeList:expandAll().
        ELSE                    oTreeList:collapseAll().
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGrafico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGrafico wWindow
ON CHOOSE OF btGrafico IN FRAME fpage0 /* Gr†fico */
OR CHOOSE OF MENU-ITEM miGrafico  IN MENU mbMain DO:
    if oTreeList:hasNode() then do:
        run piGrafico in this-procedure.
    end.
    apply "ENTRY":U to btImprimir in frame fPage0.
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


&Scoped-define SELF-NAME btImprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImprimir wWindow
ON CHOOSE OF btImprimir IN FRAME fpage0 /* Impress∆o */
OR CHOOSE OF MENU-ITEM miImprimir  IN MENU mbMain DO:
    if oTreeList:hasNode() then do:
        run piImprimir in this-procedure.
    end.
    apply "ENTRY":U to btImprimir in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btInclui
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInclui wWindow
ON CHOOSE OF btInclui IN FRAME fpage0
DO:
  run piInclui in this-procedure.
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


&Scoped-define SELF-NAME btRepos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRepos wWindow
ON END-MOVE OF btRepos IN FRAME fpage0
DO:

    if btRepos:column < 12 then
     assign btRepos:column = 12.
     
    if btRepos:column > frame fPage0:width - 13 then
       assign btRepos:column = frame fPage0:width - 13.
    
    assign oTreeList:Width    = btRepos:column - oTreeList:Col
           oTreeList-1:COL    = btRepos:column + btRepos:width
           oTreeList-1:Width  = frame fPage0:Width - btRepos:col
           oTreeList-2:Width  = oTreeList-1:Width
           oTreeList-2:Col    = oTreeList-1:Col no-error.
    
    assign btRepos:row in frame fPage0 = 2.5.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRepos wWindow
ON START-MOVE OF btRepos IN FRAME fpage0
DO:
  assign btRepos:row in frame fPage0 = 2.5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btTxt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btTxt wWindow
ON CHOOSE OF btTxt IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miTxt IN MENU mbMain DO:
    if oTreeList:hasNode() then do:
        run piTexto in this-procedure.
    end.
    apply "ENTRY":U to btTxt in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializaá∆o do programam ---*/
/** Include padr∆o do template **/
{window/mainblock.i}

btRepos:load-mouse-pointer ("image~\size.cur") in frame fPage0.

/** Procedure que manda mensagens para o sistema operacional **/
PROCEDURE SendMessageA EXTERNAL {&USER}:
    DEFINE INPUT  PARAMETER hwnd    AS {&HWND}.
    DEFINE INPUT  PARAMETER umsg    AS {&INT}.
    DEFINE INPUT  PARAMETER wparam  AS {&INT}.
    DEFINE INPUT  PARAMETER lparam  AS LONG.
    DEFINE RETURN PARAMETER iResult AS LONG.    
END.
PROCEDURE LockWindowUpdate EXTERNAL {&user} :
  DEFINE INPUT  PARAMETER hWndLock AS LONG.
END PROCEDURE.

/** define procedure externa para execucao do programa de visualizacao do txt **/
PROCEDURE WinExec EXTERNAL "kernel32.dll":
  DEF INPUT  PARAM prg_name                          AS CHARACTER.
  DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.

/** Criaá∆o do pop menu do tree-view **/
create menu pop-menu
    assign popup-only = true
           title = "POPUP":u.
create menu-item exp-con
    assign parent = pop-menu.
create menu-item regua
    assign parent  = pop-menu
           subtype = "RULE":u.

/** Trigger de choose do pop menu "Expande" **/
on choose of exp-con do:
    if  oTreeList:hasChildren(oTreeList:currentCode) then do:
        oTreeList:expandNode(oTreeList:currentCode, NOT oTreeList:getDataLog(oTreeList:currentCode,"lExpande")).
    end.
end.


{abp/abapi001.i2} /** Criaá∆o de Erros **/

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
/** Caixa de mensagens **/
{method/showmessage.i3}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Overide ap¢s inicializaá∆o da tela
------------------------------------------------------------------------------*/

/* -------------------------- */
/* Monta o Browse do TreeList */
/* -------------------------- */

oTreeList               =   NEW TOTVSTreeList().
oTreeList:parentFrame   =   FRAME   fpage0:HANDLE.
oTreeList:parentProg    =   THIS-PROCEDURE.

oTreeList:setSize(2.5, 1.29, 63.72, 17.25).

oTreeList:AddColumn("r-rowid"      , "character", 0, "x(256)", "", "", TRUE).
oTreeList:AddColumn("r-rowid-visao", "character", 0, "x(256)", "", "", TRUE).
oTreeList:AddColumn("p-image"      , "integer"  , 0, ">9"    , "", "", TRUE).

oTreeList:INITIALIZE().
oTreeList:emptyTreeList().

ASSIGN  oTreeList:browseTreeList:SEPARATORS         =   FALSE.

{utp/ut-liter.i Vis∆o *}
oTreeList:setColumnLabel("cEstrutura", RETURN-VALUE).
    
/* -------------------------- */
/* Monta o Browse do TreeList */
/* -------------------------- */

oTreeList-1               =   NEW TOTVSTreeList().
oTreeList-1:parentFrame   =   FRAME   fpage0:HANDLE.
oTreeList-1:parentProg    =   THIS-PROCEDURE.

oTreeList-1:setSize(2.5, 65.57, 25, 8).

oTreeList-1:AddColumn("r-rowid"      , "character", 0, "x(256)", "", "", TRUE).
oTreeList-1:AddColumn("r-rowid-visao", "character", 0, "x(256)", "", "", TRUE).
oTreeList-1:AddColumn("p-image"      , "integer"  , 0, ">9"    , "", "", TRUE).

oTreeList-1:INITIALIZE().
oTreeList-1:emptyTreeList().

ASSIGN  oTreeList-1:browseTreeList:FIT-LAST-COLUMN    =   TRUE.

oTreeList-1:setColumnLabel("cEstrutura", "").
    
/* -------------------------- */
/* Monta o Browse do TreeList */
/* -------------------------- */

oTreeList-2               =   NEW TOTVSTreeList().
oTreeList-2:parentFrame   =   FRAME   fpage0:HANDLE.
oTreeList-2:parentProg    =   THIS-PROCEDURE.

oTreeList-2:setSize(11.75, 65.57, 25, 8).

oTreeList-2:AddColumn("r-rowid"      , "character", 0, "x(256)", "", "", TRUE).
oTreeList-2:AddColumn("r-rowid-visao", "character", 0, "x(256)", "", "", TRUE).
oTreeList-2:AddColumn("p-image"      , "integer"  , 0, ">9"    , "", "", TRUE).

oTreeList-2:INITIALIZE().
oTreeList-2:emptyTreeList().

ASSIGN  oTreeList-2:browseTreeList:FIT-LAST-COLUMN    =   TRUE.

oTreeList-2:setColumnLabel("cEstrutura", "").

{utp/ut-liter.i "Dimens∆o"}
oTreeList-1:setColumnLabel("cEstrutura", RETURN-VALUE).
oTreeList-2:setColumnLabel("cEstrutura", RETURN-VALUE).

/** List View com todas as vis‰es **/
for each ttVisao no-lock:
    create ttVisao2.
    buffer-copy ttVisao to ttVisao2.
end.

run atualizaListView in this-procedure.
              
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaListView wWindow 
PROCEDURE atualizaListView :
/*------------------------------------------------------------------------------
  Purpose:     atualizaListView
  Parameters:  <none>
  Notes:       Atualiza o List View 1
------------------------------------------------------------------------------*/
/** Limpa o List-View **/
oTreeList-1:emptyTreeList().

/** Percorre Vis‰es N∆o selecionada e atualiza o list-view **/
for each ttVisao2:
    oTreeList-1:addNode("", STRING(ROWID(ttVisao2)), ttVisao2.dimensao).
    oTreeList-1:setData(    STRING(ROWID(ttVisao2)), "r-rowid-visao", STRING(ROWID(ttVisao2))).
end.

oTreeList-1:REFRESH().

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaListView2 wWindow 
PROCEDURE atualizaListView2 :
/*------------------------------------------------------------------------------
  Purpose:     atualizaListView
  Parameters:  <none>
  Notes:       Atualiza o List View 2
------------------------------------------------------------------------------*/
/** Limpa o List-View **/
oTreeList-2:emptyTreeList().

/** Percorre Vis‰es selecionadas e atualiza o list-view **/
for each ttVisao3:
    oTreeList-2:addNode("", STRING(ROWID(ttVisao3)), ttVisao3.dimensao).
    oTreeList-2:setData(    STRING(ROWID(ttVisao3)), "r-rowid-visao", STRING(ROWID(ttVisao3))).
end.

oTreeList-2:REFRESH().

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override antes de iniciar a tela
------------------------------------------------------------------------------*/
assign dWinXC                   = wWindow:width-chars
       dWinYC                   = wWindow:height-chars.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseEvent wWindow 
PROCEDURE browseEvent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE  INPUT   PARAMETER   cEvent  AS  CHARACTER   NO-UNDO.
    DEFINE  INPUT   PARAMETER   cNodeId AS  CHARACTER   NO-UNDO.

    IF  (cEvent =   "selected"  OR  cEvent  =   "value-changed")    AND cNodeId <>  ""  THEN    DO:
    END.

    RETURN  "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTreeView wWindow 
PROCEDURE criaTreeView :
/*------------------------------------------------------------------------------
  Purpose:     criaTreeView
  Parameters:  <none>
  Notes:       Cria as linhas do tree-view
------------------------------------------------------------------------------*/
DEFINE VARIABLE cAntes  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDentro AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cApos   AS CHARACTER  NO-UNDO.

/** Limpa o tree-view **/
oTreeList:emptyTreeList().

assign i-cont    = 0
       l-expande = no.

/** Label da quantidade de equipamentos **/
{utp/ut-liter.i "Antes Prazo"}
assign cAntes = return-value.
{utp/ut-liter.i "Dentro Prazo"}
assign cDentro = return-value.
{utp/ut-liter.i "Ap¢s Prazo"}
assign cApos = return-value.

run piAtualizar in this-procedure.

/** Busca os dados criados **/
for each  ttDados2 exclusive-lock
    by ttDados2.cod-dimensao:
  /** Conta sequàncias de linhas **/
  assign i-cont = i-cont + 1.
  assign ttDados2.seq-tree = i-cont.
  /** Inclui primeira linha **/
  if ttDados2.sequencia = 1 then do:
      oTreeList:addNode ("", "i" + string(i-cont), string(ttDados2.cod-oficial) + " - " + ttDados2.desc-dimensao 
                                                 + "   -   " + cAntes  + ":  " + string(ttDados2.iAntes)
                                                 + "   -   " + cDentro + ":  " + string(ttDados2.iDentro)
                                                 + "   -   " + cApos   + ":  " + string(ttDados2.iApos)).
     /** Guarda chave (rowid) da temp-table no tree-view **/
     oTreeList:setData("i" + STRING(i-cont), "p-image"           , ttDados2.p-image).
     oTreeList:setData("i" + STRING(i-cont), "r-rowid-visao"     , STRING(ROWID(ttDados2))).

     IF  ttDados2.r-rowid <>  ?   THEN
         oTreeList:setData("i" + STRING(i-cont), "r-rowid"       , STRING(ttDados2.r-rowid)).
  end.
  else do:
      /** Busca filhos da vis∆o escolhida **/
      find first bfttDados2 
           where bfttDados2.cod-dimensao = ttDados2.cod-dimens-pai no-lock no-error.
      if avail bfttDados2 then do:
          /** Inclui linhas das vis‰es filhas **/
          oTreeList:addNode("i" + string(bfttDados2.seq-tree), "i" + string(i-cont), string(ttDados2.cod-oficial) + " - " + ttDados2.desc-dimensao
                                + "   -   " + cAntes  + ":  " + string(ttDados2.iAntes)
                                + "   -   " + cDentro + ":  " + string(ttDados2.iDentro)
                                + "   -   " + cApos   + ":  " + string(ttDados2.iApos)). 
         /** Guarda chave (rowid) da temp-table no tree-view **/
          /** Guarda chave (rowid) da temp-table no tree-view **/
          oTreeList:setData("i" + STRING(i-cont), "p-image"           , ttDados2.p-image).
          oTreeList:setData("i" + STRING(i-cont), "r-rowid-visao"     , STRING(ROWID(ttDados2))).

          IF  ttDados2.r-rowid <>  ?   THEN
              oTreeList:setData("i" + STRING(i-cont), "r-rowid"       , STRING(ttDados2.r-rowid)).
      end.
  end.
end.

oTreeList:applyEntry().
oTreeList:REFRESH().

return "OK":U.

end PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimeVisao wWindow 
PROCEDURE imprimeVisao :
/*------------------------------------------------------------------------------
  Purpose:     imprimeVisao
  Parameters:  rRow    = Rowid da temp-table
               cCodPai = C¢digo Pai do registro
  Notes:       Cria os dados no excel para os n°veis acima da vis∆o escolhida
------------------------------------------------------------------------------*/
define input parameter rRow    as rowid     no-undo.
define input parameter cCodPai as character no-undo.

/** Verifica se existe n°vel acima para chamar recursivamente a procedure **/
if can-find(first bfttDados2
            where bfttDados2.cod-dimensao = cCodPai no-lock) then do:
    for first bfttDados2
        where bfttDados2.cod-dimensao = cCodPai no-lock:
        run imprimeVisao (input rowid(bfttDados2),
                          input bfttDados2.cod-dimens-pai).
    end.
end.
/** Busca os dados a serem impressos **/
for first bfttDados2
    where rowid(bfttDados2) = rRow no-lock:
end.
if avail bfttDados2 then do:
    /** Cria os dados na temp-table do excel **/
   {abp/ab0613.i2 bfttDados2.p-image}
   create tt-dados-ex.
   assign tt-dados-ex.celula-coluna        = 1
          tt-dados-ex.celula-linha         = i-cont2
          tt-dados-ex.celula-cor-interior  = 27
          tt-dados-ex.celula-fonte-cor     = 1
          tt-dados-ex.celula-fonte-negrito = yes
          tt-dados-ex.celula-valor         = trim(return-value) + ":" +  bfttDados2.cod-oficial + "-" + bfttDados2.desc-dimensao
          i-cont2                          = i-cont2 + 1.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimeVisaoTxt wWindow 
PROCEDURE imprimeVisaoTxt :
/*------------------------------------------------------------------------------
  Purpose:     imprimeVisao
  Parameters:  rRow    = Rowid da temp-table
               cCodPai = C¢digo Pai do registro
               cDelim  = Delimitador
  Notes:       Cria os dados no excel para os n°veis acima da vis∆o escolhida
------------------------------------------------------------------------------*/
define input parameter rRow          as rowid     no-undo.
define input parameter cCodPai       as character no-undo.
define input parameter cDelim        as character no-undo. 
  
/* /** Zera vari†veis **/  */
/* assign cDescPai   = ""  */
/*        cTituloTxt = "". */
/** Verifica se existem n°veis acima **/
if can-find(first bfttDados2
            where bfttDados2.cod-dimensao = cCodPai no-lock) then do:
    for first bfttDados2
        where bfttDados2.cod-dimensao = cCodPai no-lock:
        run imprimeVisaoTxt (input rowid(bfttDados2),
                             input bfttDados2.cod-dimens-pai,
                             input cDelim).
    end.
end.
/** Busca os dados **/
for first bfttDados2
    where rowid(bfttDados2) = rRow no-lock:
    {abp/ab0613.i2 bfttDados2.p-image}
    assign cTituloTxt = cTituloTxt + TRIM(RETURN-VALUE) + cDelim.
end.
if avail bfttDados2 then do:
    assign cDescPai  = trim(trim(cDescPai) + trim(bfttDados2.cod-oficial) + "-" + TRIM(bfttDados2.desc-dimensao) + cDelim).
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizar wWindow 
PROCEDURE piAtualizar :
/*------------------------------------------------------------------------------
  Purpose:     piAtualizar
  Parameters:  <none>
  Notes:       Cria a temp-table com os dados corretos
------------------------------------------------------------------------------*/
DEFINE VARIABLE iCont AS INTEGER    NO-UNDO.

/** Limpa temp-table antiga **/
empty temp-table ttDados2.

assign cCodPai  = ""
       cCodPai2 = "".

/** Verifica se apenas uma vis∆o foi selecionada **/
if not can-find(first ttVisao3
                where ttVisao3.sequencia > 1 no-lock) then do:
    for first ttVisao3 no-lock:
        for each  ttDados
            where ttDados.sequencia = ttVisao3.seq-orig no-lock:

            if ttdados.iAntes  = 0 and 
               ttdados.iDentro = 0 and 
               ttdados.iApos   = 0 then next.

            /** Busca registro **/
            find first ttDados2
                 where ttDados2.cod-dimensao  = ttDados.cod-oficial
                 and   ttDados2.sequencia     = ttVisao3.sequencia exclusive-lock no-error.
            /** Se n∆o estiver criado, cria registro **/
            if not avail ttDados2 then do:
               create ttDados2.
               buffer-copy ttDados except cod-dimensao sequencia cod-dimens-pai iAntes iDentro iApos to ttDados2
               assign ttDados2.cod-dimensao      = ttDados.cod-oficial
                      ttDados2.sequencia         = ttVisao3.sequencia  
                      ttDados2.cod-dimens-pai    = "".
            end.
            /** Acumula os prazos **/
            assign ttDados2.iAntes  = ttDados2.iAntes  + ttDados.iAntes
                   ttDados2.iDentro = ttDados2.iDentro + ttDados.iDentro
                   ttDados2.iApos   = ttDados2.iApos   + ttDados.iApos.
        end.
    end.
end.
/** Mais de uma vis∆o selecionada **/
else do:
    /** Busca a £ltima vis∆o do programa **/
    for last ttVisao no-lock:
        /** Busca os dados da £ltima vis∆o **/
        for each  ttDados 
            where ttDados.sequencia = ttVisao.sequencia no-lock:

            if ttdados.iAntes  = 0 and 
               ttdados.iDentro = 0 and 
               ttdados.iApos   = 0 then next.

            /** Inicializa vari†veis de controle **/
            assign cCodPai2 = "".
            /** Percorre as vis‰es selecionadas **/
            for each bfVisao3 no-lock:
                assign cCodPai  = ttDados.cod-dimens-pai.
                /** Verifica se vis∆o selecionada Ç £ltima vis∆o original **/
                if bfVisao3.seq-orig = ttVisao.sequencia then do:
                    /** Busca buffer dos dados **/
                    for first bfttDados
                        where bfttDados.cod-dimensao = ttDados.cod-dimensao
                        and   bfttDados.sequencia    = ttDados.sequencia no-lock:
                    end.
                end.
                else do:
                    /** Percorre dados atÇ chegar a vis∆o correta **/
                    do iCont = (ttDados.sequencia - 1) to bfVisao3.seq-orig by -1:
                        /** Busca buffer dos dados **/
                        for first bfttDados
                            where bfttDados.cod-dimensao = cCodPai 
                            and   bfttDados.sequencia    = iCont no-lock:
                            assign cCodPai = bfttDados.cod-dimens-pai.
                        end.
                    end.
                end.
                /** Busca registro **/
                if avail bfttDados then do:
                    find first ttDados2
                         where ttDados2.cod-dimensao  = (cCodPai2 + bfttDados.cod-oficial)
                         and   ttDados2.sequencia     = bfVisao3.sequencia exclusive-lock no-error.
                    /** Se n∆o estiver criado, cria registro **/
                    if not avail ttDados2 then do:
                       create ttDados2.
                       buffer-copy bfttDados except cod-dimensao sequencia cod-dimens-pai iAntes iDentro iApos to ttDados2
                       assign ttDados2.cod-dimensao      = (cCodPai2 + bfttDados.cod-oficial)
                              ttDados2.sequencia         = bfVisao3.sequencia  
                              ttDados2.cod-dimens-pai    = cCodPai2.
                    end.
                    /** Acumula os prazos **/
                    assign ttDados2.iAntes  = ttDados2.iAntes  + ttDados.iAntes
                           ttDados2.iDentro = ttDados2.iDentro + ttDados.iDentro
                           ttDados2.iApos   = ttDados2.iApos   + ttDados.iApos
                           cCodPai2         = ttDados2.cod-dimensao.  /** Guarda pai da vis∆o **/
                end.
            end.
        end.
    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piElimina wWindow 
PROCEDURE piElimina :
/*------------------------------------------------------------------------------
  Purpose:     piElimina
  Parameters:  <none>
  Notes:       Elimina a vis∆o seleciona
------------------------------------------------------------------------------*/
define variable cChave as character no-undo.
define variable iSeq   as integer   no-undo.

define buffer bfVisao3 for ttVisao3.

/** Verifica se existem vis‰es selecionada **/
if can-find(first ttVisao3 no-lock) then do:
    /** Busca Rowid **/
    assign cChave = oTreeList-2:getDataChar(oTreeList-2:currentCode, "r-rowid-visao")
           rVisao = to-rowid(cChave).
    /** Busca Registro **/
    for first ttVisao3
        where rowid(ttVisao3) = rVisao exclusive-lock:
        /** Verifica sequància original **/
        for first ttVisao
            where ttVisao.dimensao = ttVisao3.dimensao no-lock:
        end.
        /** Cria vis∆o n∆o selecionada **/
        create ttVisao2.
        buffer-copy ttVisao3 to ttVisao2
            assign ttVisao2.sequencia = ttVisao.sequencia
                   iSeq               = ttVisao3.sequencia.
        /** Elimina vis∆o selecionada **/
        delete ttVisao3.
        /** Renumera vis‰es posteriores a eliminada **/
        for each  bfVisao3
            where bfVisao3.sequencia > iSeq exclusive-lock:
            assign bfVisao3.sequencia = bfVisao3.sequencia - 1.
        end.
    end.
    /** Atualiza os list-views **/
    run atualizaListView  in this-procedure.
    run atualizaListView2 in this-procedure.
    /** Cria TreeView com vis‰es selecionadas **/
    run criaTreeView in this-procedure.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExcel wWindow 
PROCEDURE piExcel :
/*------------------------------------------------------------------------------
  Purpose:     piExcel
  Parameters:  <none>
  Notes:       Exporta os dados do programa para o Excel
------------------------------------------------------------------------------*/
define variable i-lin        as integer initial 1 no-undo.
define variable i-col        as integer initial 1 no-undo.
define variable rRowid       as rowid             no-undo.
define variable c-colunas    as character         no-undo.
define variable cDimensao    as character         no-undo.
define variable cDimensaoPai as character         no-undo.

/** Busca £ltima vis∆o **/
for last ttVisao3 no-lock:
end.

if not avail ttVisao3 then return "NOK":U.

/** Limpa temp-table Excel **/
empty temp-table tt-dados-ex.
/** Guarda rowid do tree-view **/
assign rRowid    = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao"))
       cDimensao = ""
       i-col     = 1
       i-lin     = 0 
       c-colunas = "".
/** Busca Registro **/
for first ttDados2
    where rowid(ttDados2) = rRowid no-lock:
    assign cDimensao     = if ttVisao3.sequencia = 1 
                           then ttDados2.cod-dimens-pai
                           else ttDados2.cod-dimensao
           cDimensaoPai  = ttDados2.cod-dimens-pai.
end.
if avail ttDados2 then do:
    /** Verifica se registro contÇm filhos **/
    if not can-find(first bfttDados2
                    where bfttDados2.cod-dimens-pai = ttDados2.cod-dimensao no-lock) then do:
        /** Se n∆o tiver, busca o pai do registro **/
        for first bfttDados2
            where bfttDados2.cod-dimensao = ttDados2.cod-dimens-pai no-lock:
            assign cDimensao     = bfttDados2.cod-dimensao
                   cDimensaoPai  = bfttDados2.cod-dimens-pai
                   rRowid        = rowid(bfttDados2).
        end.
    end.
end.

/** Encontra n£mero total de colunas **/
do i-col = 1 TO 5:
    /** Guarda t°tulos das colunas **/
    assign c-colunas = c-colunas + fnCampos(string(i-col),3).
    if i-col < 5 then
        assign c-colunas = c-colunas + ",".
end.

assign i-cont2 = 1.
/** Cria os c¢digos dos pais **/
if ttVisao3.sequencia <> 1 then
    run imprimeVisao (input rRowid,
                      input cDimensaoPai).

assign i-lin = i-cont2.
/** Percorre registros para criar dados no gr†fico **/
for each  ttDados2
    where ttDados2.cod-dimens-pai = cDimensao no-lock:
   /** In°cio contador de colunas do Browse**/
   do i-col = 1 to 5:
       /** Contador para linhas **/
       if i-lin = i-cont2 then do:
           create tt-dados-ex.
           assign tt-dados-ex.celula-coluna        = i-col
                  tt-dados-ex.celula-linha         = i-lin
                  tt-dados-ex.celula-cor-interior  = 10
                  tt-dados-ex.celula-fonte-cor     = 19
                  tt-dados-ex.celula-fonte-negrito = yes.
           assign tt-dados-ex.celula-valor         = if i-col = 1
                                                     then fnLabels(ttDados2.p-image)
                                                     else fnCampos(entry(i-col,c-colunas),1).
       end.
       /** Impress∆o da primeira linha de dados **/
       create tt-dados-ex.
       assign tt-dados-ex.celula-coluna = i-col
              tt-dados-ex.celula-linha  = i-lin + 1.
       assign tt-dados-ex.celula-valor  = fnCampos(entry(i-col,c-colunas),2).
   end. /** Colunas **/
   assign i-lin = i-lin + 1.
end.
     
/** Programa que gera o XLS **/
run abp/ab9003.p(input "ab0613":U,
                 input table tt-dados-ex).
if return-value = "NOK":U then .
   
return "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGrafico wWindow 
PROCEDURE piGrafico :
/*------------------------------------------------------------------------------
  Purpose:     piGrafico
  Parameters:  <none>
  Notes:       Cria o gr†fico do programa
------------------------------------------------------------------------------*/
define variable rRowid     as rowid     no-undo.
define variable cDimensao  as character no-undo.
define variable cCodigo    as character no-undo.
define variable cDescricao as character no-undo.
define variable deConsumo  as decimal   no-undo.
define variable lLinha     as logical   no-undo.
define variable iPai       as integer   no-undo.
/** T°tulos **/
DEFINE VARIABLE cTitGrafico AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTitLeft    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTitBottom  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTitLimHig  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTitDesp    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTitGanho   AS CHARACTER  NO-UNDO.
/** Contadores **/
DEFINE VARIABLE j     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iCont AS INTEGER    NO-UNDO.

/** Limpeza das temp-tables **/
EMPTY TEMP-TABLE tt-atributos.    
EMPTY TEMP-TABLE tt-points-2.
EMPTY TEMP-TABLE tt-sets.
EMPTY TEMP-TABLE tt-dados.
EMPTY TEMP-TABLE tt-ylabels.
EMPTY TEMP-TABLE tt-erros.
EMPTY TEMP-TABLE RowErrors.

/** Guarda rowid do tree-view **/
assign rRowid    = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao"))
       iImage    = 0
       iPai      = 0
       cDimensao = ""
       deConsumo = 0
       lLinha    = no.

/** Busca £ltima vis∆o **/
for last ttVisao3 no-lock:
end.

if not avail ttVisao3 then return "NOK":U.

/** Busca Registro **/
for first ttDados2
    where rowid(ttDados2) = rRowid no-lock:
    assign cDimensao  = if ttVisao3.sequencia = 1 
                        then ttDados2.cod-dimens-pai 
                        else ttDados2.cod-dimensao
           cCodigo    = ttDados2.cod-oficial
           iPai       = ttDados2.p-image
           cDescricao = ttDados2.desc-dimensao.
end.
if avail ttDados2 then do:
    /** Verifica se registro contÇm filhos **/
    if not can-find(first bfttDados2
                    where bfttDados2.cod-dimens-pai = cDimensao no-lock) then do:
        /** Se n∆o tiver, busca o pai do registro **/
        for first bfttDados2
            where bfttDados2.cod-dimensao = ttDados2.cod-dimens-pai no-lock:
            assign cDimensao  = bfttDados2.cod-dimensao
                   cCodigo    = bfttDados2.cod-oficial
                   iPai       = bfttDados2.p-image
                   cDescricao = bfttDados2.desc-dimensao.
        end.
    end.
    for first ttDados2
        where ttDados2.cod-dimens-pai = cDimensao no-lock:
        assign iImage = ttDados2.p-image.
    end.
end.

if cDimensao = "" and ttVisao3.sequencia <> 1 then return "NOK".
if iImage    = 0  then return "NOK".

/** Criaá∆o do t°tulo **/
{utp/ut-liter.i "Resumo Eventos Realizados"}
assign cTitGrafico = if ttVisao3.sequencia = 1 
                     then trim(return-value)
                     else trim(return-value) + " - " + fnLabels(iPai) + ": " + cCodigo + " - " + cDescricao.
{utp/ut-liter.i "Quantidade"}
assign cTitLeft   = trim(return-value)
       cTitBottom = fnLabels(iImage).

create tt-atributos.
assign tt-atributos.cod-versao-integracao = 003
       tt-atributos.NumGraph              = 1
       tt-atributos.GraphType             = 3
       tt-atributos.GraphTitle            = cTitGrafico
       tt-atributos.LeftTitle             = cTitLeft
       tt-atributos.LeftTitleStyle        = 1
       tt-atributos.BottomTitle           = cTitBottom
       tt-atributos.LegendPos             = 6
       tt-atributos.GridStyle             = 2
       tt-atributos.GridLineStyle         = 2
       tt-atributos.TitleFontSize         = 200
       tt-atributos.DataLabels            = 1
       tt-atributos.DataLabelsColor       = 0
       tt-atributos.DataLabelFormat       = "###,###,##0"
       tt-atributos.LegendPos             = 6
       j                                  = 0
       iCont                              = 0.

{utp/ut-liter.i "Antes Prazo"}
create tt-sets.
assign tt-sets.NumSet     = 1
       tt-sets.NumGraph   = 1
       tt-sets.LegendText = trim(return-value)
       tt-sets.ColorSet   = 8.
{utp/ut-liter.i "Dentro Prazo"}
create tt-sets.
assign tt-sets.NumSet     = 2
       tt-sets.NumGraph   = 1
       tt-sets.LegendText = trim(return-value)
       tt-sets.ColorSet   = 9.
{utp/ut-liter.i "Ap¢s Prazo"}
create tt-sets.
assign tt-sets.NumSet     = 3
       tt-sets.NumGraph   = 1
       tt-sets.LegendText = trim(return-value)
       tt-sets.ColorSet   = 0.


/** Percorre registros para criar dados no gr†fico **/
for each  ttDados2
    where ttDados2.cod-dimens-pai = cDimensao no-lock:
    /** Contador n£mero linhas/colunas **/
    assign j = j + 1.

    /** Criaá∆o dos pontos do Gr†fico **/
    create tt-points-2.
    assign tt-points-2.NumPoint  = j
           tt-points-2.NumGraph  = 1
           tt-points-2.LabelText = if ttDados2.p-image = 7   /** Data **/
                                   or ttDados2.p-image = 2   /** Equipamento **/
                                   then trim(ttDados2.cod-oficial)
                                   else trim(ttDados2.desc-dimensao).
    /** Criaá∆o dos dados do gr†fico **/
    create tt-dados.
    assign tt-dados.NumPoint  = j
           tt-dados.NumSet    = 1
           tt-dados.NumGraph  = 1
           tt-dados.GraphData = ttDados2.iAntes.

    create tt-dados.
    assign tt-dados.NumPoint  = j
           tt-dados.NumSet    = 2
           tt-dados.NumGraph  = 1
           tt-dados.GraphData = ttDados2.iDentro.

    create tt-dados.
    assign tt-dados.NumPoint  = j
           tt-dados.NumSet    = 3
           tt-dados.NumGraph  = 1
           tt-dados.GraphData = ttDados2.iApos
           iCont              = 1.
end.

if  iCont > 0 then do:
    /** Roda a API persistente **/
    run utp/utapi011.p persistent set hUTAPI011.
    /** Executa **/
    run pi-execute in hUTAPI011 (input table tt-atributos,
                                 input table tt-points-2,
                                 input table tt-sets,
                                 input table tt-dados,
                                 input table tt-ylabels,
                                 output table tt-erros).
    /** Criaá∆o de Erros **/
    for each tt-erros no-lock:
        run piCriaErro (input tt-erros.cod-erro,
                         input "EMS":U,
                         input "").
    end.
    /** Elimina API da mem¢ria **/
    delete procedure hUTAPI011 no-error.
end.
/** Mostra Erros **/
if can-find(first RowErrors) then do:
    /** Instancia aplicativo **/
    {method/showmessage.i1}
    /** Mostra caixa com erros **/
    {method/showmessage.i2 &Modal="YES"}
    /** Limpa temp-tables de erros **/
    empty temp-table RowErrors.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimir wWindow 
PROCEDURE piImprimir :
/*------------------------------------------------------------------------------
  Purpose:     piImprimir
  Parameters:  <none>
  Notes:       Chama tela de impress∆o passando vis∆o a ser impressa
------------------------------------------------------------------------------*/
define variable rRowid     as rowid     no-undo.
define variable iSequencia as integer   no-undo.
define variable cDimensao  as character no-undo.
define variable iUltimo    as integer   no-undo.

for last ttVisao3 no-lock:
    assign iUltimo = ttVisao3.sequencia.
end.

if not avail ttVisao3 then return "NOK":U.

/** Guarda rowid do tree-view **/
assign rRowid = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao")).

/* /** Busca Registro **/                                                            */
/* for first ttDados2                                                                */
/*     where rowid(ttDados2) = rRowid no-lock:                                       */
/*     assign cDimensao  = if ttVisao3.sequencia = 1                                 */
/*                         then ttDados2.cod-dimens-pai                              */
/*                         else ttDados2.cod-dimensao                                */
/*            cCodigo    = ttDados2.cod-oficial                                      */
/*            iPai       = ttDados2.p-image                                          */
/*            cDescricao = ttDados2.desc-dimensao.                                   */
/* end.                                                                              */
/* if avail ttDados2 then do:                                                        */
/*     /** Verifica se registro contÇm filhos **/                                    */
/*     if not can-find(first bfttDados2                                              */
/*                     where bfttDados2.cod-dimens-pai = cDimensao no-lock) then do: */
/*         /** Se n∆o tiver, busca o pai do registro **/                             */
/*         for first bfttDados2                                                      */
/*             where bfttDados2.cod-dimensao = ttDados2.cod-dimens-pai no-lock:      */
/*             assign cDimensao  = bfttDados2.cod-dimensao                           */
/*                    cCodigo    = bfttDados2.cod-oficial                            */
/*                    iPai       = bfttDados2.p-image                                */
/*                    cDescricao = bfttDados2.desc-dimensao.                         */
/*         end.                                                                      */
/*     end.                                                                          */
/*     for first ttDados2                                                            */
/*         where ttDados2.cod-dimens-pai = cDimensao no-lock:                        */
/*         assign iImage = ttDados2.p-image.                                         */
/*     end.                                                                          */
/* end.                                                                              */

/** Busca Registro **/
for first ttDados2
    where rowid(ttDados2) = rRowid no-lock:
    assign iSequencia = ttDados2.sequencia
           cDimensao  = ttDados2.cod-dimensao.
end.
if avail ttDados2 then do:
    assign {&window-name}:sensitive = no.
    run abp/ab0613f.w (input table ttDados2,
                       input iSequencia,
                       input cDimensao,
                       input iUltimo).
    assign {&window-name}:sensitive = yes.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInclui wWindow 
PROCEDURE piInclui :
/*------------------------------------------------------------------------------
  Purpose:     piInclui
  Parameters:  <none>
  Notes:       Inclui vis∆o selecionada
------------------------------------------------------------------------------*/
define variable cChave as character no-undo.

define buffer bfVisao3 for ttVisao3.
/** Verifica existància de Vis‰es n∆o selecionadas **/
if can-find(first ttVisao2 no-lock) then do:
    /** Busca rowid da vis∆o **/
    assign cChave = oTreeList-1:getDataChar(oTreeList-1:currentCode, "r-rowid-visao")
           rVisao = to-rowid(cChave).
    /** Busca registro da vis∆o **/
    for first ttVisao2
        where rowid(ttVisao2) = rVisao no-lock:
        /** Verifica £ltimo registro das vis‰es j† selecionadas **/
        for last bfVisao3 no-lock:
        end.
        /** Cria vis∆o selecionada **/
        create ttVisao3.
        buffer-copy ttVisao2 to ttVisao3
            /** Coloca vis∆o na sequància correta **/
            assign ttVisao3.sequencia = if avail bfVisao3 
                                           then bfVisao3.sequencia + 1
                                           else 1
                   ttVisao3.seq-orig  = ttVisao2.sequencia.
        /** Retira vis∆o das n∆o selecionadas **/
        delete ttVisao2.
    end.
    /** Atualiza os list-views **/
    run atualizaListView  in this-procedure.
    run atualizaListView2 in this-procedure.
    /** Cria o tree-view com os dados **/
    run criaTreeView in this-procedure.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTexto wWindow 
PROCEDURE piTexto :
/*------------------------------------------------------------------------------
  Purpose:     piTexto
  Parameters:  <none>
  Notes:       Exporta os dados da consulta para um arquivo texto
------------------------------------------------------------------------------*/
define variable rRowid       as rowid                     no-undo.
define variable cDimensao    as character                 no-undo.
define variable cDimensaoPai as character                 no-undo.
define variable cCaminho     as character format "x(300)" no-undo. /*Indica o caminho */
define variable cDelimitador as character format "x(01)"  no-undo. /*Indica o tipo de delimitador */
define variable lCabecalho   as logical   initial no      no-undo. /*Indica se gera cabeáalho */
define variable c-key-value  as character                 no-undo.

/** Busca £ltima vis∆o **/
for last ttVisao3 no-lock:
end.

if not avail ttVisao3 then return "NOK":U.

/** Guarda rowid do tree-view **/
assign rRowid       = TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao"))
       cDimensao    = "":U
       cDimensaoPai = "":U
       cTituloTxt   = "":U
       cDescPai     = "":U
       iImage       = 0.

/** Busca Registro **/
for first ttDados2
    where rowid(ttDados2) = rRowid no-lock:
    assign cDimensao     = if ttVisao3.sequencia = 1 
                           then ttDados2.cod-dimens-pai 
                           else ttDados2.cod-dimensao
           cDimensaoPai  = ttDados2.cod-dimens-pai.
end.
if avail ttDados2 then do:
    /** Verifica se registro contÇm filhos **/
    if not can-find(first bfttDados2
                    where bfttDados2.cod-dimens-pai = ttDados2.cod-dimensao no-lock) then do:
        /** Se n∆o tiver, busca o pai do registro **/
        for first bfttDados2
            where bfttDados2.cod-dimensao = ttDados2.cod-dimens-pai no-lock:
            assign cDimensao     = bfttDados2.cod-dimensao
                   cDimensaoPai  = bfttDados2.cod-dimens-pai
                   rRowid        = rowid(bfttDados2).
        end.
    end.
    /** Busca Filho **/
    for first bfttDados2 
        where bfttDados2.cod-dimens-pai = cDimensao no-lock:
        assign iImage = bfttDados2.p-image.
    end.
end.

/** Seta caminho e delimitador **/
ASSIGN cDelimitador = ";":U
       cCaminho     = session:temp-directory + c-programa-mg97 + ".txt":U.
/***Chamada do programa de parÉmetros para geraá∆o do arquivo em formato TXT***/
assign {&window-name}:sensitive = no.
run abp/ab0701.w(input-output cCaminho,
                 input-output lCabecalho,
                 input-output cDelimitador,
                 input-output l-ok).
assign {&window-name}:sensitive = yes.
/** Se confirmar **/
if l-ok then do:
    /** Busca N°veis superiores ao selecionado se existir ***/ 
    if ttVisao3.sequencia <> 1 then
        run imprimeVisaoTxt (input rRowid,
                             input cDimensaoPai,
                             input cDelimitador).
    /** Troca barras contr†rias pela correta **/
    assign cCaminho = replace(cCaminho, "/":U, "~\":U).
    /** Cria arquivo **/
    output to value(cCaminho) paged page-size 64 convert target "iso8859-1":U.
        /** Imprime cabeáalho se parametrizado **/
        if lCabecalho then do:
            put trim(trim(cTituloTxt)                        + 
                     fnLabels(iImage)         + cDelimitador + 
                     fnCampos("iAntes":U,1)   + cDelimitador + 
                     fnCampos("iDentro":U,1)  + cDelimitador + 
                     fnCampos("iApos":U,1))   format "x(600)" at 01.
        end.
        /** Imprime dados **/
        for each  bfttDados2 
            where bfttDados2.cod-dimens-pai = cDimensao no-lock:
            put trim(trim(cDescPai) + 
                     trim(bfttDados2.cod-oficial) + "-" + trim(bfttDados2.desc-dimensao) + cDelimitador + 
                     string(bfttDados2.iAntes,">,>>>,>>9")                               + cDelimitador + 
                     string(bfttDados2.iDentro,">,>>>,>>9")                              + cDelimitador + 
                     string(bfttDados2.iApos,">,>>>,>>9"))     format "x(600)" at 01.
        end.
    output close.
    /** Abertura do Arquivo **/
    RUN utp/ut-showreport.p (INPUT cCaminho).
end.       

return "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCampos wWindow 
FUNCTION fnCampos RETURNS CHARACTER
  ( pCampo as character,
    iTipo  as integer ) :
/*------------------------------------------------------------------------------
  Purpose:  fnCampos
    Notes:  Busca os t°tulos dos campos da temp-table
------------------------------------------------------------------------------*/
DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.

case iTipo:
    when 1 then do:
        case pCampo:
            when "cod-oficial":U then do:
                {utp/ut-liter.i "C¢digo"}
            end.
            when "desc-dimensao":U then do:
                {utp/ut-liter.i "Descriá∆o"}
            end.
            when "iAntes":U then do:
                {utp/ut-liter.i "Antes"}
            end.
            when "iDentro":U then do:
                {utp/ut-liter.i "Dentro"}
            end.
            when "iApos":U then do:
                {utp/ut-liter.i "Ap¢s"}
            end.
        end case.
        assign cRetorno = trim(return-value).
    end.
    when 2 then do:
        case pCampo:
            when "cod-oficial":U then do:
                assign cRetorno = ttDados2.cod-oficial.
            end.
            when "desc-dimensao":U then do:
                assign cRetorno = ttDados2.desc-dimensao.
            end.
            when "iAntes":U then do:
                assign cRetorno = string(ttDados2.iAntes,">,>>>,>>9").
            end.
            when "iDentro":U then do:
                assign cRetorno = string(ttDados2.iDentro,">,>>>,>>9").
            end.
            when "iApos":U then do:
                assign cRetorno = string(ttDados2.iApos,">,>>>,>>9").
            end.
        end case.
    end.
    when 3 then do:
        case pCampo:
            when "1":U then do:
                assign cRetorno = "cod-oficial":U.
            end.
            when "2":U then do:
                assign cRetorno = "desc-dimensao":U.
            end.
            when "3":U then do:
                assign cRetorno = "iAntes":U.
            end.
            when "4":U then do:
                assign cRetorno = "iDentro":U.
            end.
            when "5":U then do:
                assign cRetorno = "iApos":U.
            end.
        end case.        
    end.
end case.

  RETURN cRetorno.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnLabels wWindow 
FUNCTION fnLabels RETURNS CHARACTER
  ( pImage as int ) :
/*------------------------------------------------------------------------------
  Purpose:  fnLabels
    Notes:  Busca a label da imagem pasada
------------------------------------------------------------------------------*/

DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.

    /** T°tulo do browse **/
    {abp/ab0613.i2 pImage}

    assign cRetorno = trim(return-value).

  RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMes wWindow 
FUNCTION fnMes RETURNS CHARACTER
( iMes as int ) :
/*------------------------------------------------------------------------------
Purpose:  fnMes
  Notes:  Busca o Màs
------------------------------------------------------------------------------*/

DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.

assign cRetorno = "".

case iMes:
  when 1 then do:
      {utp/ut-liter.i Janeiro}
  end.
  when 2 then do:
      {utp/ut-liter.i Fevereiro}
  end.
  when 3 then do:
      {utp/ut-liter.i Maráo}
  end.
  when 4 then do:
      {utp/ut-liter.i Abril}
  end.
  when 5 then do:
      {utp/ut-liter.i Maio}
  end.
  when 6 then do:
      {utp/ut-liter.i Junho}
  end.
  when 7 then do:
      {utp/ut-liter.i Julho}
  end.
  when 8 then do:
      {utp/ut-liter.i Agosto}
  end.
  when 9 then do:
      {utp/ut-liter.i Setembro}
  end.
  when 10 then do:
      {utp/ut-liter.i Outubro}
  end.
  when 11 then do:
      {utp/ut-liter.i Novembro}
  end.
  when 12 then do:
      {utp/ut-liter.i Dezembro}
  end.
end case.

assign cRetorno = trim(return-value).

RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPrazo wWindow 
FUNCTION fnPrazo RETURNS CHARACTER
  ( iPrazo as int ) :
/*------------------------------------------------------------------------------
  Purpose:  fnPrazo
    Notes:  Busca descriá∆o do prazo
------------------------------------------------------------------------------*/

DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.

assign cRetorno = "".

case iPrazo:
    when 1 then do:
        {utp/ut-liter.i "Antes"}
    end.
    when 2 then do:
        {utp/ut-liter.i "Dentro"}
    end.
    when 3 then do:
        {utp/ut-liter.i "Ap¢s"}
    end.
end case.

assign cRetorno = trim(return-value).

  RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

