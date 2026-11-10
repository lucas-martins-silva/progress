&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mguni            PROGRESS
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0404 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0404 MAB}
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
&GLOBAL-DEFINE Program        AB0404
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o,Digitaá∆o,Impress∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          NO
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   
&GLOBAL-DEFINE page5Widgets   brDigita ~
                              btAdd ~
                              btUpdate ~
                              btDelete ~
                              btSave ~
                              btOpen
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    iEmpIni iEmpFim ~
                              cEqptoIni cEqptoFim ~
                              fiData tgAvisos
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field iEmpIni          like mab-eqpto.ep-codigo
    field iEmpFim          like mab-eqpto.ep-codigo
    field cEqptoIni        like mab-eqpto.cod-eqpto
    field cEqptoFim        like mab-eqpto.cod-eqpto
    field dtData           as date format "99/99/9999"
    FIELD lAvisos          AS LOGICAL.

define new shared temp-table tt-digita no-undo
    field ep-codigo        like mab-eqpto.ep-codigo
    field cod-eqpto        like mab-eqpto.cod-eqpto
    index id ep-codigo cod-eqpto.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.

/*** Inicio Projeto 118 - Seguranáa por Estabelecimento */

/* Valida os Modulo, para ver se tem Seguranáa por Estabelecimento */
{cdp/cdapi3003.i "MAB":U}
/* Definiá∆o das temp-table necessaria para tratar seguranáa por Estabelecimento */
{cdp/cdapi3003.i1}

/*** Final Projeto 118 - Seguranáa por Estabelecimento */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDigita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE brDigita                                      */
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.ep-codigo tt-digita.cod-eqpto   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita tt-digita.ep-codigo tt-digita.cod-eqpto   
&Scoped-define ENABLED-TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brDigita tt-digita
&Scoped-define SELF-NAME brDigita
&Scoped-define QUERY-STRING-brDigita FOR EACH tt-digita
&Scoped-define OPEN-QUERY-brDigita OPEN QUERY brDigita FOR EACH tt-digita.
&Scoped-define TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-brDigita tt-digita


/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-brDigita}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE cEqptoFim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE cEqptoIni AS CHARACTER FORMAT "x(16)" 
     LABEL "Equipamento":R14 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fiData AS DATE FORMAT "99/99/9999":U INITIAL 01/01/1800 
     LABEL "Data Movimentaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE iEmpFim LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 5 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE iEmpIni LIKE empresa.ep-codigo
     LABEL "Empresa":R9 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE tgAvisos AS LOGICAL INITIAL no 
     LABEL "Gerar Eventos de Aviso" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE BUTTON btAdd 
     LABEL "&Inserir" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btDelete 
     LABEL "&Retirar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btOpen 
     LABEL "Re&cuperar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btSave 
     LABEL "&Salvar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btUpdate 
     LABEL "A&lterar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image~\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDigita FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDigita wReport _FREEFORM
  QUERY brDigita DISPLAY
      tt-digita.ep-codigo
tt-digita.cod-eqpto
ENABLE
tt-digita.ep-codigo
tt-digita.cod-eqpto
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 82 BY 8.75
         BGCOLOR 15 FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 14.75 COL 2
     btCancel AT ROW 14.75 COL 13
     btHelp2 AT ROW 14.75 COL 80
     rtToolBar AT ROW 14.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 15
         FONT 1.

DEFINE FRAME fPage5
     brDigita AT ROW 1.25 COL 1
     btAdd AT ROW 10 COL 1
     btUpdate AT ROW 10 COL 16
     btDelete AT ROW 10 COL 31
     btSave AT ROW 10 COL 46
     btOpen AT ROW 10 COL 61
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage2
     iEmpIni AT ROW 2.5 COL 23
          LABEL "Empresa":R9
          FONT 1
     iEmpFim AT ROW 2.5 COL 54.57 NO-LABEL
          FONT 1
     cEqptoIni AT ROW 3.5 COL 15.57 COLON-ALIGNED HELP
          "C¢digo do Equipamento"
     cEqptoFim AT ROW 3.5 COL 52.57 COLON-ALIGNED HELP
          "C¢digo do Equipamento" NO-LABEL
     fiData AT ROW 4.5 COL 23.57 COLON-ALIGNED
     tgAvisos AT ROW 4.5 COL 44
     IMAGE-1 AT ROW 2.5 COL 35.86
     IMAGE-2 AT ROW 2.5 COL 51.29
     IMAGE-3 AT ROW 3.5 COL 35.86
     IMAGE-4 AT ROW 3.5 COL 51.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     btConfigImpr AT ROW 3.58 COL 43.29 HELP
          "Configuraá∆o da impressora"
     btFile AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     cFile AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.75 COL 3 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
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
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 15
         WIDTH              = 90
         MAX-HEIGHT         = 15
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 15
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{report/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN iEmpFim IN FRAME fPage2
   ALIGN-L LIKE = mguni.empresa.ep-codigo EXP-LABEL                     */
/* SETTINGS FOR FILL-IN iEmpIni IN FRAME fPage2
   ALIGN-L LIKE = mguni.empresa.ep-codigo EXP-LABEL                     */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brDigita 1 fPage5 */
/* SETTINGS FOR FRAME fPage6
                                                                        */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execuá∆o".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDigita
/* Query rebuild information for BROWSE brDigita
     _START_FREEFORM
OPEN QUERY brDigita FOR EACH tt-digita.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDigita */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDigita
&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON DEL OF brDigita IN FRAME fPage5
DO:
   apply 'choose' to btDelete in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON END-ERROR OF brDigita IN FRAME fPage5
ANYWHERE 
DO:
    if  brDigita:new-row in frame fPage5 then do:
        if  avail tt-digita then
            delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then. 
    end.                                                               
    else do:
        get current brDigita.
        display tt-digita.ep-codigo
                tt-digita.cod-eqpto with browse brDigita. 
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ENTER OF brDigita IN FRAME fPage5
ANYWHERE
DO:
  apply 'tab' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON INS OF brDigita IN FRAME fPage5
DO:
   apply 'choose' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-END OF brDigita IN FRAME fPage5
DO:
   apply 'entry' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-HOME OF brDigita IN FRAME fPage5
DO:
  apply 'entry' to btOpen in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-ENTRY OF brDigita IN FRAME fPage5
DO:
   /*:T trigger para inicializar campos da temp table de digitaá∆o */
   if  brDigita:new-row in frame fPage5 then do:
   &IF "{&mguni_version}" >= "2.071" &THEN
       assign tt-digita.ep-codigo:screen-value in browse brDigita = "".
   &else
       assign tt-digita.ep-codigo:screen-value in browse brDigita = "0".
   &endif
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-LEAVE OF brDigita IN FRAME fPage5
DO:
    /*:T ê aqui que a gravaá∆o da linha da temp-table Ç efetivada.
       PorÇm as validaá‰es dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment†rio */
    
    if brDigita:NEW-ROW in frame fPage5 then 
    do transaction on error undo, return no-apply:
        create tt-digita.
        assign input browse brDigita tt-digita.ep-codigo
               input browse brDigita tt-digita.cod-eqpto.

        brDigita:CREATE-RESULT-LIST-ENTRY() in frame fPage5.
    end.
    else do transaction on error undo, return no-apply:
        if avail tt-digita then
            assign input browse brDigita tt-digita.ep-codigo
                   input browse brDigita tt-digita.cod-eqpto.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wReport
ON CHOOSE OF btAdd IN FRAME fPage5 /* Inserir */
DO:
    assign btUpdate:SENSITIVE in frame fPage5 = yes
           btDelete:SENSITIVE in frame fPage5 = yes
           btSave:SENSITIVE   in frame fPage5 = yes.
    
    if num-results("brDigita":U) > 0 then
        brDigita:INSERT-ROW("after":U) in frame fPage5.
    else do transaction:
        create tt-digita.
        
        open query brDigita for each tt-digita.
        
        apply "entry":U to tt-digita.ep-codigo in browse brDigita. 
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wReport
ON CHOOSE OF btConfigImpr IN FRAME fPage6
DO:
   {report/rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wReport
ON CHOOSE OF btDelete IN FRAME fPage5 /* Retirar */
DO:
    if  brDigita:num-selected-rows > 0 then do on error undo, return no-apply:
        get current brDigita.
        delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then.
    end.
    
    if num-results("brDigita":U) = 0 then
        assign btUpdate:SENSITIVE in frame fPage5 = no
               btDelete:SENSITIVE in frame fPage5 = no
               btSave:SENSITIVE   in frame fPage5 = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wReport
ON CHOOSE OF btFile IN FRAME fPage6
DO:
    {report/rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wReport
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
   do  on error undo, return no-apply:
       /*** Projeto 118 - Seguranáa por Estabelecimento */
       IF  l-seg-ativa-modulo THEN
           RUN piValidaSegPorEstabel IN THIS-PROCEDURE.
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btOpen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOpen wReport
ON CHOOSE OF btOpen IN FRAME fPage5 /* Recuperar */
DO:
    {report/rprcd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wReport
ON CHOOSE OF btSave IN FRAME fPage5 /* Salvar */
DO:
   {report/rpsvd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wReport
ON CHOOSE OF btUpdate IN FRAME fPage5 /* Alterar */
DO:
   apply 'entry' to tt-digita.ep-codigo in browse brDigita. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage6
DO:
do  with frame fPage6:
    case self:screen-value:
        when "1":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes.
        end.
        when "2":U then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no.
        end.
        when "3":U then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage6
DO:
   {report/rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
ASSIGN iEmpIni = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF
       iEmpFim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF.

{report/mainblock.i}

{abp/abapi001.i2} /** Criaá∆o de Erros **/
{abp/ab9005.i}    /** Validaá∆o de parÉmetros **/

tt-digita.ep-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN BROWSE brDigita.
tt-digita.cod-eqpto:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN BROWSE brDigita.


/** Trigger para chamar Zoom de Equipamento **/
on f5 of tt-digita.ep-codigo in browse brDigita
or mouse-select-dblclick of tt-digita.ep-codigo in browse brDigita 
or f5 of tt-digita.cod-eqpto in browse brDigita
or mouse-select-dblclick of tt-digita.cod-eqpto in browse brDigita do:
   
   if  not avail tt-digita 
   and not brDigita:new-row in frame fPage5 then
       return no-apply.

   {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr007.w"
           &FieldZoom1="ep-codigo"
           &FieldScreen1="tt-digita.ep-codigo"
           &Browse1="brDigita"
           &FieldZoom2="cod-eqpto"
           &FieldScreen2="tt-digita.cod-eqpto"
           &Browse2="brDigita"}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wReport 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Override ap¢s fechar o programa 
------------------------------------------------------------------------------*/
/** Elimina aplicativo **/
{method/showmessage.i3}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override ap¢s criaá∆o da tela
------------------------------------------------------------------------------*/
assign fiData = today.
display fiData with frame fPage2.
              
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wReport 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override antes de inicializar a tela
------------------------------------------------------------------------------*/
    /** Valida se os par∆metros est∆o cadastrados **/
    {utp/ut-liter.i "Abastecimento"}
    run piValidaParametroModulo in this-procedure (input "17,18,19,21,22":U,
                                                   input trim(return-value)).
    if  return-value = "NOK":U then do:
        /** Instancia aplicativo **/
        {method/showmessage.i1}
        /** Mostra caixa com erros **/
        {method/showmessage.i2 &Modal="YES"}
        /** Limpa temp-tables de erros **/
        empty temp-table RowErrors.
        /** Elimina aplicativo **/
        {method/showmessage.i3}
        return "NOK":U.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     piExecute
  Parameters:  <none>
  Notes:       Executa o relat¢rio
------------------------------------------------------------------------------*/

define var r-tt-digita as rowid no-undo.

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
/*:T** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}
    
    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.
    
    /*:T Coloque aqui as validaá‰es da p†gina de Digitaá∆o, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p†gina e colocar
       o focus no campo com problemas */
    /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/
    
    for each tt-digita no-lock:
        assign r-tt-digita = rowid(tt-digita).
        
        /*:T Validaá∆o de duplicidade de registro na temp-table tt-digita */
        find first b-tt-digita 
            where  b-tt-digita.ep-codigo = tt-digita.ep-codigo 
            and    b-tt-digita.cod-eqpto = tt-digita.cod-eqpto
            and    rowid(b-tt-digita)    <> rowid(tt-digita) 
            no-lock no-error.
        if  avail b-tt-digita then do:
            reposition brDigita to rowid rowid(b-tt-digita).
            
            run utp/ut-msgs.p (input "SHOW":U, input 108, input "":U).
            apply "ENTRY":U to tt-digita.ep-codigo in browse brDigita.
            
            return error.
        end.
        
        /** Empresa em branco **/
   &IF "{&mguni_version}" >= "2.071" &THEN
        if  tt-digita.ep-codigo <= "" then do:
   &else
        if  tt-digita.ep-codigo <= 0 then do:
   &endif
            assign browse brDigita:CURRENT-COLUMN = tt-digita.ep-codigo:HANDLE in browse brDigita.
            
            reposition brDigita to rowid r-tt-digita.
           
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Empresa" *}
            run utp/ut-msgs.p (input "SHOW":U, input 3145, input RETURN-VALUE).
            apply "ENTRY":U to tt-digita.ep-codigo in browse brDigita.
            
            return error.
        end.
        /** Equipamento em branco **/
        if  tt-digita.cod-eqpto = "":U then do:
            assign browse brDigita:CURRENT-COLUMN = tt-digita.cod-eqpto:HANDLE in browse brDigita.
            
            reposition brDigita to rowid r-tt-digita.
           
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Equipamento" *}
            run utp/ut-msgs.p (input "SHOW":U, input 3145, input RETURN-VALUE).
            apply "ENTRY":U to tt-digita.cod-eqpto in browse brDigita.
            
            return error.
        end.
        /** Equipamento n∆o cadastrado **/
        if not can-find(first mab-eqpto
                        where mab-eqpto.ep-codigo = tt-digita.ep-codigo
                        and   mab-eqpto.cod-eqpto = tt-digita.cod-eqpto no-lock) then do:
            assign browse brDigita:CURRENT-COLUMN = tt-digita.ep-codigo:HANDLE in browse brDigita.
            
            reposition brDigita to rowid r-tt-digita.

            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-equipamento AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Equipamento" *}
            ASSIGN c-lbl-liter-equipamento = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-empresa AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Empresa" *}
            ASSIGN c-lbl-liter-empresa = TRIM(RETURN-VALUE).
            run utp/ut-msgs.p (input "SHOW":U, input 56, input c-lbl-liter-equipamento + ' ' + tt-digita.cod-eqpto + 
                                                               c-lbl-liter-empresa + ' '     + string(tt-digita.ep-codigo)).
            apply "ENTRY":U to tt-digita.ep-codigo in browse brDigita.
            
            return error.
        end.
        /** Equipamento n∆o motorizado **/
        if can-find(first mab-eqpto
                    where mab-eqpto.ep-codigo     = tt-digita.ep-codigo
                    and   mab-eqpto.cod-eqpto     = tt-digita.cod-eqpto 
                    and   mab-eqpto.idi-tip-eqpto = 2  no-lock) then do:
            assign browse brDigita:CURRENT-COLUMN = tt-digita.ep-codigo:HANDLE in browse brDigita.
            
            reposition brDigita to rowid r-tt-digita.

            run utp/ut-msgs.p (input "SHOW":U, input 28502, input tt-digita.cod-eqpto + '~~' + string(tt-digita.ep-codigo)).
            apply "ENTRY":U to tt-digita.ep-codigo in browse brDigita.
            
            return error.
        end.
        /** Equipamento desativado **/
        if can-find(first mab-eqpto
                    where mab-eqpto.ep-codigo     = tt-digita.ep-codigo
                    and   mab-eqpto.cod-eqpto     = tt-digita.cod-eqpto
                    and  (mab-eqpto.dat-situacao <> ?
                    and   mab-eqpto.dat-situacao <= today)) then do:
            assign browse brDigita:CURRENT-COLUMN = tt-digita.ep-codigo:HANDLE in browse brDigita.
            
            reposition brDigita to rowid r-tt-digita.

            run utp/ut-msgs.p (input "SHOW":U, input 26405, input "":U).
            apply "ENTRY":U to tt-digita.ep-codigo in browse brDigita.
            
            return error.
        end.
        
    end.
    
    
    /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
       problemas e colocar o focus no campo com problemas */    
    
    
    /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.iEmpIni         = input frame fPage2 iEmpIni
           tt-param.iEmpFim         = input frame fPage2 iEmpFim
           tt-param.cEqptoIni       = input frame fPage2 cEqptoIni
           tt-param.cEqptoFim       = input frame fPage2 cEqptoFim
           tt-param.dtData          = input frame fPage2 fiData
           tt-param.lAvisos         = input frame fPage2 tgAvisos.
    
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
       como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */
    
    
    
    /*:T Executar do programa RP.P que ir† criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i abp/ab0404rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.
&ELSE
/** Importaá∆o / Exportaá∆o **/
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaSegPorEstabel wReport 
PROCEDURE piValidaSegPorEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Valida Seguranáa por Estabelecimento
  
  Referente ao Projeto 118 - Seguranáa por Estabelecimento 
  
------------------------------------------------------------------------------*/
    /* Definicao de Variaveis */
    DEFINE VARIABLE i-cont-erro-seg   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-help-erro-seg   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFinalidade       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lTemRestricao     AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE lErroExecucao     AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE h_api_perm_estab  AS HANDLE    NO-UNDO.

    EMPTY TEMP-TABLE tt_log_erro.
    EMPTY TEMP-TABLE tt_estab_ems2.
    EMPTY TEMP-TABLE ttEmpEstabelSemSeg.


    /* Executa api de FinanØas */
    RUN prgint/utb/utb746za.py PERSISTENT SET h_api_perm_estab.
    RUN pi_retorna_estab_sem_permissao_ems2 IN h_api_perm_estab (OUTPUT TABLE tt_estab_ems2,
                                                                 OUTPUT TABLE tt_log_erro).
    /* Destroi handle */
    DELETE OBJECT h_api_perm_estab.

    FOR EACH tt_estab_ems2 NO-LOCK:
        FIND FIRST estabelec
             WHERE estabelec.cod-estabel = tt_estab_ems2.tta_cod_estab NO-LOCK NO-ERROR.
        IF  AVAIL estabelec THEN DO:
            CREATE ttEmpEstabelSemSeg.
            ASSIGN ttEmpEstabelSemSeg.ep-codigo   = estabelec.ep-codigo
                   ttEmpEstabelSemSeg.cod-estabel = estabelec.cod-estabel.
        END.
    END.

    /* Verifica se dentro da faixa de Empresa existe algum Estabelecimento no qual o usuario nao tem acesso */
    ASSIGN i-cont-erro-seg = 0
           c-help-erro-seg = ""
           lTemRestricao   = NO.
    FOR EACH ttEmpEstabelSemSeg
        WHERE ttEmpEstabelSemSeg.ep-codigo >= input frame fPage2 iEmpIni
        AND   ttEmpEstabelSemSeg.ep-codigo <= input frame fPage2 iEmpFim NO-LOCK
        BY ttEmpEstabelSemSeg.ep-codigo
        BY ttEmpEstabelSemSeg.cod-estabel:
        IF  i-cont-erro-seg <> 0 THEN DO:
            ASSIGN c-help-erro-seg = c-help-erro-seg + ", " + ttEmpEstabelSemSeg.cod-estabel.
        END.
        ELSE DO:
            ASSIGN c-help-erro-seg = c-help-erro-seg + ttEmpEstabelSemSeg.cod-estabel.
            assign i-cont-erro-seg = 1. 
        END.
        ASSIGN lTemRestricao = YES.
    END.

    {utp/ut-liter.i "Atualiza_%_Remonta_‡leo_Motor"}
    ASSIGN cFinalidade = RETURN-VALUE.
    EMPTY TEMP-TABLE RowErrors.
    /* Se houver algum Estabelecimento no qual o usuario nao tem acesso Ç exibido uma mensagem informando os Estabelecimentos com Restriá∆o */
    IF  lTemRestricao THEN DO:
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence = 1.
        ASSIGN RowErrors.ErrorNumber  = 52047.

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 52047,
                           INPUT cFinalidade + "~~" + c-help-erro-seg + "~~" + "").
        ASSIGN RowErrors.ErrorDescription  = RETURN-VALUE.

        RUN utp/ut-msgs.p (INPUT "help",
                           INPUT 52047,
                           INPUT cFinalidade + "~~" + c-help-erro-seg + "~~" + "").
        ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.

        ASSIGN RowErrors.ErrorType = "EMS":U.
        ASSIGN RowErrors.ErrorSubType = "ERROR":U.

        RUN piMostraErros IN THIS-PROCEDURE.

        run setFolder in hFolder (input 1).
        apply "ENTRY":U to iEmpIni in frame fPage2.
        RETURN ERROR.
    END.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraErros wReport 
PROCEDURE piMostraErros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Exibe Erro da temp-table RowErrors
------------------------------------------------------------------------------*/
    
    /** Instancia aplicativo **/
    {method/showmessage.i1}
    /** Mostra caixa com erros existes na RowErrors **/
    {method/showmessage.i2 &Modal="YES"}
    /*--- Destroi tela de mensagens de erros ---*/
    {method/showmessage.i3}

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



