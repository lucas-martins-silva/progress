&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
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
{include/i-prgvrs.i AF0601A 2.00.00.005 } /*** 010005 ***/
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
&GLOBAL-DEFINE Program        AF0601A
&GLOBAL-DEFINE Version        2.00.00.005

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btHelp2 bt-grafico bt-detalhe
&GLOBAL-DEFINE page1Widgets   br-notas  br-notas1 cb-classificacao c-narrativa 
                              


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


{afbo/boaf008.i1}
def input param table for tt-notas.
def input param p-cod-estabel      like af-contr-indice.cod-estabel.
DEF INPUT PARAM p-ano-avaliacao    LIKE af-periodo-aval.ano-avaliacao NO-UNDO.
DEF INPUT PARAM p-des-periodo-aval LIKE af-periodo-aval.des-periodo-aval[1] NO-UNDO.
def input param p-dt-indice-ini    like af-contr-indice.dt-indice     no-undo.
def input param p-dt-indice-fim    like af-contr-indice.dt-indice     no-undo.
def input param p-cod-emitente     like af-contr-indice.cod-emitente.
def input param p-nome-abrev       like tt-notas.nome-abrev.
def buffer b-tt-notas for tt-notas.

{utp/utapi001.i}
def var i-conta-points as dec no-undo.
def var i-classific    as int initial 3 no-undo.

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
&Scoped-define INTERNAL-TABLES tt-notas b-tt-notas

/* Definitions for BROWSE br-notas                                      */
&Scoped-define FIELDS-IN-QUERY-br-notas tt-notas.it-codigo tt-notas.nota tt-notas.desc-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-notas   
&Scoped-define SELF-NAME br-notas
&Scoped-define OPEN-QUERY-br-notas case i-classific:     when 1 then        OPEN QUERY {&SELF-NAME} FOR EACH tt-notas                                   WHERE tt-notas.tipo = "TI" and                                         tt-notas.cod-estabel = p-cod-estabel and                                         tt-notas.dt-indice-fim = p-dt-indice-fim and                                         tt-notas.cod-emitente = p-cod-emitente                                      by tt-notas.it-codigo.    when 2 then               OPEN QUERY {&SELF-NAME} FOR EACH tt-notas                                   WHERE tt-notas.tipo = "TI" and                                         tt-notas.cod-estabel = p-cod-estabel and                                         tt-notas.dt-indice-fim = p-dt-indice-fim and                                         tt-notas.cod-emitente = p-cod-emitente                                      by tt-notas.desc-item.    when 3 then               OPEN QUERY {&SELF-NAME} FOR EACH tt-notas                                   WHERE tt-notas.tipo = "TI" and                                         tt-notas.cod-estabel = p-cod-estabel and                                         tt-notas.dt-indice-fim = p-dt-indice-fim and                                         tt-notas.cod-emitente = p-cod-emitente                                      by tt-notas.nota .    when 4 then               OPEN QUERY {&SELF-NAME} FOR EACH tt-notas                                   WHERE tt-notas.tipo = "TI" and                                         tt-notas.cod-estabel = p-cod-estabel and                                         tt-notas.dt-indice-fim = p-dt-indice-fim and                                         tt-notas.cod-emitente = p-cod-emitente                                      by tt-notas.nota desc. end case.   apply 'value-changed' to br-notas in frame fpage1.
&Scoped-define TABLES-IN-QUERY-br-notas tt-notas
&Scoped-define FIRST-TABLE-IN-QUERY-br-notas tt-notas


/* Definitions for BROWSE br-notas1                                     */
&Scoped-define FIELDS-IN-QUERY-br-notas1 b-tt-notas.nr-controle b-tt-notas.descricao b-tt-notas.indice b-tt-notas.percentual b-tt-notas.nota string(month(b-tt-notas.dt-indice),"99") + "/" + STRING(YEAR(b-tt-notas.dt-indice),"9999")   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-notas1   
&Scoped-define SELF-NAME br-notas1
&Scoped-define QUERY-STRING-br-notas1 FOR EACH b-tt-notas                                    WHERE b-tt-notas.tipo = "DE" and                                          b-tt-notas.cod-estabel = tt-notas.cod-estabel and                                          b-tt-notas.dt-indice-fim = tt-notas.dt-indice-fim and                                          b-tt-notas.cod-emitente = tt-notas.cod-emitente and                                          b-tt-notas.it-codigo = tt-notas.it-codigo                                 by b-tt-notas.nr-controle.         GET FIRST br-notas1.        IF AVAIL b-tt-notas THEN           apply 'value-changed' to br-notas1 in frame fpage1
&Scoped-define OPEN-QUERY-br-notas1 OPEN QUERY {&SELF-NAME} FOR EACH b-tt-notas                                    WHERE b-tt-notas.tipo = "DE" and                                          b-tt-notas.cod-estabel = tt-notas.cod-estabel and                                          b-tt-notas.dt-indice-fim = tt-notas.dt-indice-fim and                                          b-tt-notas.cod-emitente = tt-notas.cod-emitente and                                          b-tt-notas.it-codigo = tt-notas.it-codigo                                 by b-tt-notas.nr-controle.         GET FIRST br-notas1.        IF AVAIL b-tt-notas THEN           apply 'value-changed' to br-notas1 in frame fpage1.
&Scoped-define TABLES-IN-QUERY-br-notas1 b-tt-notas
&Scoped-define FIRST-TABLE-IN-QUERY-br-notas1 b-tt-notas


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-notas}~
    ~{&OPEN-QUERY-br-notas1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btHelp btQueryJoins btReportsJoins btExit ~
btHelp2 bt-grafico bt-detalhe rtToolBar rtToolBar-2 

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
DEFINE BUTTON bt-detalhe DEFAULT 
     IMAGE-UP FILE "image/im-det.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-det.bmp":U
     LABEL "Movimentos (documentos) dos ¡ndices" 
     SIZE 6 BY 1.25 TOOLTIP "Movimentos (documentos) dos ¡ndices dos itens".

DEFINE BUTTON bt-grafico DEFAULT 
     IMAGE-UP FILE "image/im-grf.bmp":U
     LABEL "Gr fico dos itens" 
     SIZE 6 BY 1.25 TOOLTIP "Gr fico dos itens".

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
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE cb-classificacao AS CHARACTER FORMAT "X(256)":U INITIAL "Nota Ascendente" 
     LABEL "Classifica‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "C¢digo Item","Descri‡Æo Item","Nota Ascendente","Nota Descendente" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-narrativa AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 88 BY 3.75
     FONT 2 NO-UNDO.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "X(5)" 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-des-periodo-aval AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-dt-indice-fim AS CHARACTER FORMAT "99/9999":U INITIAL "010001" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-dt-indice-ini AS CHARACTER FORMAT "99/9999":U INITIAL "010001" 
     LABEL "Data Öndice" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nome Abrev" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE i-ano-avaliacao AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Per¡odo" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 6.25.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 6.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 30 BY 6.25.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-notas FOR 
      tt-notas SCROLLING.

DEFINE QUERY br-notas1 FOR 
      b-tt-notas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-notas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-notas wWindow _FREEFORM
  QUERY br-notas DISPLAY
      tt-notas.it-codigo
        tt-notas.nota
        tt-notas.desc-item
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN NO-ROW-MARKERS SEPARATORS SIZE 88 BY 5.75
         FONT 1
         TITLE "Itens" ROW-HEIGHT-CHARS .5.

DEFINE BROWSE br-notas1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-notas1 wWindow _FREEFORM
  QUERY br-notas1 DISPLAY
      b-tt-notas.nr-controle
b-tt-notas.descricao
b-tt-notas.indice
b-tt-notas.percentual
b-tt-notas.nota
string(month(b-tt-notas.dt-indice),"99") + "/" + STRING(YEAR(b-tt-notas.dt-indice),"9999") LABEL "Data Öndice"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN NO-ROW-MARKERS SEPARATORS SIZE 57 BY 5.75
         FONT 1
         TITLE "Öndices dos pontos de controle do item" ROW-HEIGHT-CHARS .5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 20.5 COL 2
     btCancel AT ROW 20.5 COL 24
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp2 AT ROW 20.46 COL 80
     bt-grafico AT ROW 1.13 COL 2
     bt-detalhe AT ROW 1.13 COL 8.72
     rtToolBar AT ROW 20.25 COL 1
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 20.75
         FONT 1.

DEFINE FRAME fPage1
     i-ano-avaliacao AT ROW 9.75 COL 69 COLON-ALIGNED
     c-des-periodo-aval AT ROW 9.75 COL 75 COLON-ALIGNED NO-LABEL
     c-narrativa AT ROW 14.25 COL 2 NO-LABEL
     c-nome-abrev AT ROW 11.75 COL 69 COLON-ALIGNED
     c-cod-estabel AT ROW 7.75 COL 69 COLON-ALIGNED HELP
          "C¢digo do estabelecimento"
     i-cod-emitente AT ROW 10.75 COL 69 COLON-ALIGNED HELP
          "C¢digo do fornecedor"
     c-dt-indice-ini AT ROW 8.75 COL 69 COLON-ALIGNED
     cb-classificacao AT ROW 12.75 COL 69 COLON-ALIGNED
     br-notas AT ROW 1.25 COL 2
     br-notas1 AT ROW 7.75 COL 2
     c-dt-indice-fim AT ROW 8.75 COL 77 COLON-ALIGNED NO-LABEL
     RECT-17 AT ROW 7.5 COL 1
     RECT-18 AT ROW 1.25 COL 1
     RECT-27 AT ROW 7.5 COL 60
     RECT-28 AT ROW 14 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.75
         SIZE 90 BY 17.5
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
         TITLE              = "Consulta de Notas"
         HEIGHT             = 20.75
         WIDTH              = 90.14
         MAX-HEIGHT         = 20.75
         MAX-WIDTH          = 92.43
         VIRTUAL-HEIGHT     = 20.75
         VIRTUAL-WIDTH      = 92.43
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
/* BROWSE-TAB br-notas cb-classificacao fPage1 */
/* BROWSE-TAB br-notas1 br-notas fPage1 */
ASSIGN 
       br-notas:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       br-notas:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

ASSIGN 
       br-notas1:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       br-notas1:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-periodo-aval IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-dt-indice-fim IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-dt-indice-ini IN FRAME fPage1
   NO-ENABLE                                                            */
ASSIGN 
       c-narrativa:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN c-nome-abrev IN FRAME fPage1
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
case i-classific:

   when 1 then
       OPEN QUERY {&SELF-NAME} FOR EACH tt-notas
                                  WHERE tt-notas.tipo = "TI" and
                                        tt-notas.cod-estabel = p-cod-estabel and
                                        tt-notas.dt-indice-fim = p-dt-indice-fim and
                                        tt-notas.cod-emitente = p-cod-emitente
                                     by tt-notas.it-codigo.
   when 2 then
              OPEN QUERY {&SELF-NAME} FOR EACH tt-notas
                                  WHERE tt-notas.tipo = "TI" and
                                        tt-notas.cod-estabel = p-cod-estabel and
                                        tt-notas.dt-indice-fim = p-dt-indice-fim and
                                        tt-notas.cod-emitente = p-cod-emitente
                                     by tt-notas.desc-item.
   when 3 then
              OPEN QUERY {&SELF-NAME} FOR EACH tt-notas
                                  WHERE tt-notas.tipo = "TI" and
                                        tt-notas.cod-estabel = p-cod-estabel and
                                        tt-notas.dt-indice-fim = p-dt-indice-fim and
                                        tt-notas.cod-emitente = p-cod-emitente
                                     by tt-notas.nota .
   when 4 then
              OPEN QUERY {&SELF-NAME} FOR EACH tt-notas
                                  WHERE tt-notas.tipo = "TI" and
                                        tt-notas.cod-estabel = p-cod-estabel and
                                        tt-notas.dt-indice-fim = p-dt-indice-fim and
                                        tt-notas.cod-emitente = p-cod-emitente
                                     by tt-notas.nota desc.
end case.

 apply 'value-changed' to br-notas in frame fpage1.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-notas */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-notas1
/* Query rebuild information for BROWSE br-notas1
     _START_FREEFORM

        OPEN QUERY {&SELF-NAME} FOR EACH b-tt-notas
                                   WHERE b-tt-notas.tipo = "DE" and
                                         b-tt-notas.cod-estabel = tt-notas.cod-estabel and
                                         b-tt-notas.dt-indice-fim = tt-notas.dt-indice-fim and
                                         b-tt-notas.cod-emitente = tt-notas.cod-emitente and
                                         b-tt-notas.it-codigo = tt-notas.it-codigo
                                by b-tt-notas.nr-controle.

       GET FIRST br-notas1.
       IF AVAIL b-tt-notas THEN
          apply 'value-changed' to br-notas1 in frame fpage1.
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
ON END-ERROR OF wWindow /* Consulta de Notas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Consulta de Notas */
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
ON VALUE-CHANGED OF br-notas IN FRAME fPage1 /* Itens */
DO:
    {&OPEN-QUERY-br-notas1}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-notas1
&Scoped-define SELF-NAME br-notas1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-notas1 wWindow
ON MOUSE-SELECT-DBLCLICK OF br-notas1 IN FRAME fPage1 /* Öndices dos pontos de controle do item */
DO:
  apply 'choose' to bt-detalhe in frame fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-notas1 wWindow
ON VALUE-CHANGED OF br-notas1 IN FRAME fPage1 /* Öndices dos pontos de controle do item */
DO:
  assign c-narrativa =  b-tt-notas.narrativa.
  disp c-narrativa 
       with frame fpage1.

  FOR FIRST af-controle FIELDS(padrao nr-controle)
      WHERE af-controle.ep-codigo = i-ep-codigo-usuario
      AND   af-controle.nr-controle = b-tt-notas.nr-controle
      NO-LOCK: END.
  IF AVAIL af-controle AND af-controle.padrao THEN
     ENABLE bt-detalhe WITH FRAME fPage0.
  ELSE DISABLE bt-detalhe WITH FRAME fPage0.


  IF AVAIL af-controle THEN /* UPC para ponto controle espec¡fico */
     RUN pi-upc (INPUT "habilita-detalhe":U, 
                 INPUT "",
                 INPUT ?,
                 INPUT ?,
                 INPUT STRING(af-controle.nr-controle),
                 INPUT ?).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-detalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-detalhe wWindow
ON CHOOSE OF bt-detalhe IN FRAME fpage0 /* Movimentos (documentos) dos ¡ndices */
DO:               
    if not avail tt-notas or
        not avail b-tt-notas then return.

    {&WINDOW-NAME}:SENSITIVE = NO.

    if b-tt-notas.nr-controle = 1 then
        run afp/af0601b.w (input tt-notas.cod-estabel,
                           input tt-notas.ano-avaliacao,
                           input tt-notas.des-periodo-aval,
                           input tt-notas.dt-indice-ini,
                           input tt-notas.dt-indice-fim,
                           input tt-notas.cod-emitente,
                           input tt-notas.nome-abrev,
                           input tt-notas.it-codigo,
                           input tt-notas.desc-item,
                           input b-tt-notas.nr-controle,
                           input b-tt-notas.descricao,
                           input b-tt-notas.indice,
                           input b-tt-notas.percentual,
                           input b-tt-notas.nota).

    else if b-tt-notas.nr-controle = 2 then
        run afp/af0601c.w (input tt-notas.cod-estabel,
                           input tt-notas.ano-avaliacao,
                           input tt-notas.des-periodo-aval,
                           input tt-notas.dt-indice-ini,
                           input tt-notas.dt-indice-fim,
                           input tt-notas.cod-emitente,
                           input tt-notas.nome-abrev,
                           input tt-notas.it-codigo,
                           input tt-notas.desc-item,
                           input b-tt-notas.nr-controle,
                           input b-tt-notas.descricao,
                           input b-tt-notas.indice,
                           input b-tt-notas.percentual,
                           input b-tt-notas.nota,
                           input b-tt-notas.narrativa).

    else if b-tt-notas.nr-controle = 3 then
        run afp/af0601d.w (input tt-notas.cod-estabel,
                           input tt-notas.ano-avaliacao,
                           input tt-notas.des-periodo-aval,
                           input tt-notas.dt-indice-ini,
                           input tt-notas.dt-indice-fim,
                           input tt-notas.cod-emitente,
                           input tt-notas.nome-abrev,
                           input tt-notas.it-codigo,
                           input tt-notas.desc-item,
                           input b-tt-notas.nr-controle,
                           input b-tt-notas.descricao,
                           input b-tt-notas.indice,
                           input b-tt-notas.percentual,
                           input b-tt-notas.nota,
                           input b-tt-notas.narrativa).
    else if b-tt-notas.nr-controle = 4 then
        run afp/af0601e.w (input tt-notas.cod-estabel,
                           input tt-notas.ano-avaliacao,
                           input tt-notas.des-periodo-aval,
                           input tt-notas.dt-indice-ini,
                           input tt-notas.dt-indice-fim,
                           input tt-notas.cod-emitente,
                           input tt-notas.nome-abrev,
                           input tt-notas.it-codigo,
                           input tt-notas.desc-item,
                           input b-tt-notas.nr-controle,
                           input b-tt-notas.descricao,
                           input b-tt-notas.indice,
                           input b-tt-notas.percentual,
                           input b-tt-notas.nota,
                           input b-tt-notas.narrativa).

    /* UPC - ponto controle especifico */
    IF AVAIL af-controle THEN
       RUN pi-upc (INPUT "ponto-especifico":U, 
                   INPUT "",
                   INPUT ?,
                   INPUT ?,
                   INPUT STRING(af-controle.nr-controle) + ";" + 
                         STRING(tt-notas.cod-estabel) + ";" + 
                         STRING(tt-notas.ano-avaliacao) + ";" + 
                         STRING(tt-notas.des-periodo-aval) + ";" + 
                         STRING(tt-notas.dt-indice-ini) + ";" + 
                         STRING(tt-notas.dt-indice-fim) + ";" +
                         STRING(tt-notas.cod-emitente) + ";" +
                         STRING(tt-notas.nome-abrev) + ";" +
                         STRING(tt-notas.it-codigo) + ";" +
                         STRING(tt-notas.desc-item) + ";" +
                         STRING(tt-notas.nr-controle) + ";" +
                         STRING(tt-notas.descricao) + ";" +
                         STRING(tt-notas.indice) + ";" +
                         STRING(tt-notas.percentual) + ";" +
                         STRING(tt-notas.nota) + ";" +
                         c-narrativa:SCREEN-VALUE IN FRAME fPage1,
                   INPUT ?).

    {&WINDOW-NAME}:SENSITIVE = YES.
    APPLY 'entry' TO {&WINDOW-NAME}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-grafico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-grafico wWindow
ON CHOOSE OF bt-grafico IN FRAME fpage0 /* Gr fico dos itens */
DO:              
   run pi-grafico.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME cb-classificacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-classificacao wWindow
ON VALUE-CHANGED OF cb-classificacao IN FRAME fPage1 /* Classifica‡Æo */
DO:
    assign input frame fPage1 cb-classificacao.
           
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        if lookup(cb-classificacao:screen-value,cb-classificacao:LIST-ITEM-PAIRS in frame fPage1,",") mod 2 <> 0 then 
            assign i-classific = (lookup(cb-classificacao:screen-value,cb-classificacao:LIST-ITEM-PAIRS in frame fPage1,",") + 1) / 2.
        else
            assign i-classific = lookup(cb-classificacao:screen-value, cb-classificacao:LIST-ITEM-PAIRS in frame fPage1,",") / 2.  
    &else
        assign i-classific = lookup(cb-classificacao:screen-value, cb-classificacao:LIST-ITEMS in frame fPage1,",").      
    &endif
    
    {&OPEN-QUERY-BR-NOTAS}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-notas
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayWidgets wWindow 
PROCEDURE afterDisplayWidgets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&OPEN-QUERY-BR-NOTAS}

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

    def var c-classific as char no-undo.
    
    assign c-classific = "C¢digo Item, Descri‡Æo Item, Nota Ascendente, Nota Descendente".

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        run utp/ut-lstit.p (input-output c-classific).
        assign cb-classificacao:list-item-pairs in frame fPage1 = c-classific
               cb-classificacao:screen-value in frame fPage1    = entry(3 * 2 /*Nota Ascendente*/, cb-classificacao:list-item-pairs in frame fPage1,",").
    &else
        assign cb-classificacao:list-items in frame fPage1   = ""
               cb-classificacao:list-items in frame fPage1   = c-classific
               cb-classificacao:screen-value in frame fPage1 = entry(3 /*Nota Ascendente*/, cb-classificacao:list-items in frame fPage1,",").
    &endif

    disp p-cod-estabel  @ c-cod-estabel 
         string(month(p-dt-indice-ini),"99") + string(year(p-dt-indice-ini)) @ c-dt-indice-ini
         string(month(p-dt-indice-fim),"99") + string(year(p-dt-indice-fim)) @ c-dt-indice-fim
         p-ano-avaliacao @ i-ano-avaliacao
         p-des-periodo-aval @ c-des-periodo-aval
         p-cod-emitente @ i-cod-emitente
         p-nome-abrev   @ c-nome-abrev
         with frame fpage1.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-dados-grafico wWindow 
PROCEDURE pi-cria-dados-grafico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-labeltext as char            no-undo.
def input param p-nota      like tt-notas.nota no-undo.

    assign i-conta-points = i-conta-points + 1.
    create tt-points.
    assign tt-points.numgraph  = 1
           tt-points.numpoint  = i-conta-points
           tt-points.labeltext = p-labeltext.
    create tt-dados.
    assign tt-dados.numgraph   = 1
           tt-dados.numpoint   = i-conta-points
           tt-dados.numset     = 1
           tt-dados.graphdata  = p-nota.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grafico wWindow 
PROCEDURE pi-grafico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var c-tit-graf        as char     no-undo.
    def var c-tit-Y           as char     no-undo.
    def var c-tit-X           as char     no-undo.
    def var c-labeltext       as char     no-undo.
    def var de-total          as dec      no-undo.
    def var r-notas           as rowid    no-undo.

    assign i-conta-points = 0.

    assign c-tit-x    = "Itens" 
           c-tit-graf = "Nota dos Itens - Per¡odo: " + string(input frame fpage1 c-dt-indice-fim,"99/9999") + 
                        "  Est: " + input frame fpage1 c-cod-estabel + 
                        "  Fornecedor:" + input frame fpage1 c-nome-abrev.
        
    
    assign c-tit-y = "Notas".

    /* Inicializa temp-tables -----------------------------------------------------*/
    for each tt-dados:      delete tt-dados.     end.
    for each tt-atributos:  delete tt-atributos. end.
    for each tt-points:     delete tt-points.    end.
    for each tt-sets:       delete tt-sets.      end.
    for each tt-erros:      delete tt-erros.     end.

    /* Configura o Gr fico --------------------------------------------------------*/

    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 1
           tt-atributos.graphtype             = 3
           tt-atributos.graphtitle            = c-tit-graf
           tt-atributos.lefttitle             = c-tit-y
           tt-atributos.lefttitlestyle        = 1
           tt-atributos.bottomtitle           = c-tit-x 
           tt-atributos.legendpos             = 1
           tt-atributos.gridstyle             = 1
           tt-atributos.gridlinestyle         = 0
           tt-atributos.DataLabels            = 1
           tt-atributos.DataLabelFormat       = ">>9.99"
           tt-atributos.TitleFontSize         =  10
           tt-atributos.LabelFontSize         =  10
           tt-atributos.LegendFontSize        =  10
           tt-atributos.OtherFontSize         =  10.
            
    create tt-sets.
    assign tt-sets.numgraph   = 1
           tt-sets.numset     = 1.
     

    
       if can-find (first tt-notas) then do:
          assign r-notas = rowid(tt-notas).
          get first br-notas.
       end.
       do while avail (tt-notas):
          assign c-labeltext = tt-notas.it-codigo.

          run pi-cria-dados-grafico (input c-labeltext,
                                     input tt-notas.nota).
          get next br-notas.
       end.
       find tt-notas where
            rowid(tt-notas) = r-notas no-error.
      
    
    /* Gera o Gr fico -------------------------------------------------------------*/
    run utp/utapi001.p(input table tt-atributos,
                       input table tt-points,
                       input table tt-sets,
                       input table tt-dados,
                       input table tt-ylabels,
                       output table tt-erros).
                      
    if return-value = "NOK" then
        for each tt-erros:
             run utp/ut-msgs.p (input "show",
                                input tt-erros.cod-erro,
                                input "").
        end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-upc wWindow 
PROCEDURE pi-upc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

    /* DPC */
    if  c-nom-prog-dpc-mg97 <> ""
    and c-nom-prog-dpc-mg97 <> ? then 
        run value(c-nom-prog-dpc-mg97) (input p-ind-event, 
                                        input p-ind-object,
                                        input THIS-PROCEDURE,
                                        input FRAME fPage1:HANDLE,
                                        input p-cod-table,
                                        input p-row-table).    
    /* APPC */
    if  c-nom-prog-appc-mg97 <> ""
    and c-nom-prog-appc-mg97 <> ? then
        run value(c-nom-prog-appc-mg97) (input p-ind-event, 
                                         input p-ind-object,
                                         input THIS-PROCEDURE,
                                         input FRAME fPage1:HANDLE,
                                         input p-cod-table,
                                         input p-row-table).    

    /* UPC */
    if  c-nom-prog-upc-mg97 <> ""
    and c-nom-prog-upc-mg97 <> ? then
        run value(c-nom-prog-upc-mg97) (input p-ind-event, 
                                        input p-ind-object,
                                        input THIS-PROCEDURE,
                                        input FRAME fPage1:HANDLE,
                                        input p-cod-table,
                                        input p-row-table).    
    if  return-value = "OK":U then
        return "OK":U.
    else
        return "NOK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

