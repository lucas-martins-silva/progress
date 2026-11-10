&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          ems2cad          PROGRESS
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
{include/i-prgvrs.i AB0707 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0707 MAB}
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
&GLOBAL-DEFINE Program        AB0707
&GLOBAL-DEFINE Version        2.00.00.000
&GLOBAL-DEFINE VersionLayout  1

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Funcion†rio, Motorista, Impress∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          no
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   brDigitaFunc ~
                              btAddFunc ~
                              btUpdateFunc ~
                              btDeleteFunc ~
                              btGerarFunc

&GLOBAL-DEFINE page5Widgets   brDigita ~
                              btAdd ~
                              btUpdate ~
                              btDelete ~
                              btGerar

&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution ~
                              l-habilitaRtf ~
                              blModelRtf
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo text-rtf text-ModelRtf
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile cModelRTF
&GLOBAL-DEFINE page7Fields   
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    field l-habilitaRtf    as LOG.


define temp-table tt-digita no-undo
    field ep-codigo        LIKE mab-motoris.ep-codigo
    field cod-estabel      LIKE mab-motoris.cod-estabel
    FIELD cod-matr         LIKE mab-motoris.cod-matr
    FIELD nom-motoris      LIKE mab-motoris.nom-motoris
    index id ep-codigo  
             cod-estabel
             cod-matr.   

define buffer b-tt-digita for tt-digita.

define NEW SHARED temp-table tt-digita-func no-undo
    field ep-codigo        LIKE mmv-func-ofici.ep-codigo
    field cod-estabel      LIKE mmv-func-ofici.cod-estabel
    FIELD cod-matr         LIKE mmv-func-ofici.cod-matr
    FIELD nom-func         LIKE mmv-func-ofici.nom-func
    index id ep-codigo  
             cod-estabel
             cod-matr.   

define buffer b-tt-digita-func for tt-digita-func.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-rtf              as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

def stream s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est† rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

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
&Scoped-define INTERNAL-TABLES tt-digita tt-digita-func

/* Definitions for BROWSE brDigita                                      */
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.ep-codigo tt-digita.cod-estabel tt-digita.cod-matr tt-digita.nom-motoris   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita tt-digita.ep-codigo tt-digita.cod-estabel tt-digita.cod-matr   
&Scoped-define ENABLED-TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brDigita tt-digita
&Scoped-define SELF-NAME brDigita
&Scoped-define QUERY-STRING-brDigita FOR EACH tt-digita
&Scoped-define OPEN-QUERY-brDigita OPEN QUERY brDigita FOR EACH tt-digita.
&Scoped-define TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-brDigita tt-digita


/* Definitions for BROWSE brDigitaFunc                                  */
&Scoped-define FIELDS-IN-QUERY-brDigitaFunc tt-digita-func.ep-codigo tt-digita-func.cod-estabel tt-digita-func.cod-matr tt-digita-func.nom-func   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigitaFunc tt-digita-func.ep-codigo tt-digita-func.cod-estabel tt-digita-func.cod-matr   
&Scoped-define ENABLED-TABLES-IN-QUERY-brDigitaFunc tt-digita-func
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brDigitaFunc tt-digita-func
&Scoped-define SELF-NAME brDigitaFunc
&Scoped-define QUERY-STRING-brDigitaFunc FOR EACH tt-digita-func
&Scoped-define OPEN-QUERY-brDigitaFunc OPEN QUERY brDigitaFunc FOR EACH tt-digita-func.
&Scoped-define TABLES-IN-QUERY-brDigitaFunc tt-digita-func
&Scoped-define FIRST-TABLE-IN-QUERY-brDigitaFunc tt-digita-func


/* Definitions for FRAME fPage4                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage4 ~
    ~{&OPEN-QUERY-brDigitaFunc}

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
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btAddFunc 
     LABEL "Inserir" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btDeleteFunc 
     LABEL "Retirar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btGerarFunc 
     LABEL "Gerar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btUpdateFunc 
     LABEL "Alterar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btAdd 
     LABEL "Inserir" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btDelete 
     LABEL "Retirar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btGerar 
     LABEL "Gerar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btUpdate 
     LABEL "Alterar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON blModelRtf 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

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

DEFINE VARIABLE cModelRTF AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-ModelRtf AS CHARACTER FORMAT "X(256)":U INITIAL "Modelo:" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-rtf AS CHARACTER FORMAT "X(256)":U INITIAL "Rich Text Format(RTF)" 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

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
     SIZE 27.86 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.14 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.14 BY 1.71.

DEFINE RECTANGLE rect-rtf
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.14 BY 3.21.

DEFINE VARIABLE l-habilitaRtf AS LOGICAL INITIAL no 
     LABEL "RTF" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDigita FOR 
      tt-digita SCROLLING.

DEFINE QUERY brDigitaFunc FOR 
      tt-digita-func SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDigita wReport _FREEFORM
  QUERY brDigita DISPLAY
      tt-digita.ep-codigo
tt-digita.cod-estabel
tt-digita.cod-matr
tt-digita.nom-motoris
ENABLE
tt-digita.ep-codigo
tt-digita.cod-estabel
tt-digita.cod-matr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 82 BY 8.75
         BGCOLOR 15 FONT 1.

DEFINE BROWSE brDigitaFunc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDigitaFunc wReport _FREEFORM
  QUERY brDigitaFunc DISPLAY
      tt-digita-func.ep-codigo
tt-digita-func.cod-estabel
tt-digita-func.cod-matr
tt-digita-func.nom-func
ENABLE
tt-digita-func.ep-codigo
tt-digita-func.cod-estabel
tt-digita-func.cod-matr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 82 BY 8.75
         BGCOLOR 15 FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.08
         FONT 1.

DEFINE FRAME fPage5
     brDigita AT ROW 1.25 COL 1
     btAdd AT ROW 10 COL 1
     btUpdate AT ROW 10 COL 16
     btDelete AT ROW 10 COL 31
     btGerar AT ROW 10 COL 46
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage4
     brDigitaFunc AT ROW 1.25 COL 1
     btAddFunc AT ROW 10.04 COL 1
     btUpdateFunc AT ROW 10.04 COL 16.14
     btDeleteFunc AT ROW 10.04 COL 31.29
     btGerarFunc AT ROW 10.04 COL 46.43
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configuraá∆o da impressora"
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     l-habilitaRtf AT ROW 5.58 COL 3.14
     cModelRTF AT ROW 7.29 COL 3 HELP
          "Nome do arquivo de modelo" NO-LABEL
     blModelRtf AT ROW 7.29 COL 43 HELP
          "Escolha o arquivo de modelo"
     rsExecution AT ROW 9.5 COL 2.86 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-rtf AT ROW 5 COL 2 COLON-ALIGNED NO-LABEL
     text-ModelRtf AT ROW 6.54 COL 2 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 8.75 COL 1.14 COLON-ALIGNED NO-LABEL
     rect-rtf AT ROW 5.29 COL 2
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 9 COL 2
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
         HEIGHT             = 17.08
         WIDTH              = 90
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.14
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.14
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

{report~/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* BROWSE-TAB brDigitaFunc 1 fPage4 */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brDigita 1 fPage5 */
/* SETTINGS FOR FRAME fPage6
                                                                        */
ASSIGN 
       blModelRtf:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       cModelRTF:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-ModelRtf:HIDDEN IN FRAME fPage6           = TRUE
       text-ModelRtf:PRIVATE-DATA IN FRAME fPage6     = 
                "Modelo:".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execuá∆o".

ASSIGN 
       text-rtf:HIDDEN IN FRAME fPage6           = TRUE
       text-rtf:PRIVATE-DATA IN FRAME fPage6     = 
                "Rich Text Format(RTF)".

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

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDigitaFunc
/* Query rebuild information for BROWSE brDigitaFunc
     _START_FREEFORM
OPEN QUERY brDigitaFunc FOR EACH tt-digita-func.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDigitaFunc */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
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


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME blModelRtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL blModelRtf wReport
ON CHOOSE OF blModelRtf IN FRAME fPage6
DO:
    def var cFile as char no-undo.
    def var l-ok  as logical no-undo.

    assign cModelRTF = replace(input frame {&frame-name} cModelRTF, "/", "~\").
    SYSTEM-DIALOG GET-FILE cFile
       FILTERS "*.rtf" "*.rtf",
               "*.*" "*.*"
       DEFAULT-EXTENSION "rtf"
       INITIAL-DIR "modelos" 
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then
        assign cModelRTF:screen-value in frame {&frame-name}  = replace(cFile, "~\", "/"). 

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
ON ROW-LEAVE OF brDigita IN FRAME fPage5
DO:
  ASSIGN INPUT BROWSE brdigita tt-digita.ep-codigo 
         INPUT BROWSE brdigita tt-digita.cod-estabel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDigitaFunc
&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME brDigitaFunc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigitaFunc wReport
ON DEL OF brDigitaFunc IN FRAME fPage4
DO:
   apply 'choose' to btDeletefunc in frame fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigitaFunc wReport
ON ENTER OF brDigitaFunc IN FRAME fPage4
ANYWHERE
DO:
  apply 'tab' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigitaFunc wReport
ON INS OF brDigitaFunc IN FRAME fPage4
DO:
   apply 'choose' to btAddFunc in frame fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigitaFunc wReport
ON OFF-END OF brDigitaFunc IN FRAME fPage4
DO:
   apply 'entry' to btAddFunc in frame fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wReport
ON CHOOSE OF btAdd IN FRAME fPage5 /* Inserir */
DO:
    assign btUpdate:SENSITIVE in frame fPage5 = yes
           btDelete:SENSITIVE in frame fPage5 = yes.
           
    if num-results("brDigita":U) > 0 then
        brDigita:INSERT-ROW("after":U) in frame fPage5.
    else do transaction:
        create tt-digita.
        ASSIGN tt-digita.ep-codigo = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF.
               
        open query brDigita for each tt-digita.
        
        apply "entry":U to tt-digita.ep-codigo in browse brDigita. 
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btAddFunc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddFunc wReport
ON CHOOSE OF btAddFunc IN FRAME fPage4 /* Inserir */
DO:
    assign btUpdateFunc:SENSITIVE in frame fPage4 = yes
           btDeleteFunc:SENSITIVE in frame fPage4 = yes.
           
    if num-results("brDigitaFunc":U) > 0 then
        brDigitaFunc:INSERT-ROW("after":U) in frame fPage4.
    else do transaction:
        create tt-digita-func.
        
        open query brDigitaFunc for each tt-digita-func.
               
        apply "entry":U to tt-digita-func.ep-codigo in browse brDigitaFunc.

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
               btDelete:SENSITIVE in frame fPage5 = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btDeleteFunc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteFunc wReport
ON CHOOSE OF btDeleteFunc IN FRAME fPage4 /* Retirar */
DO:
    if  brDigitaFunc:num-selected-rows > 0 then do on error undo, return no-apply:
        get current brDigitaFunc.
        delete tt-digita-func.
        if  brDigitaFunc:delete-current-row() in frame fPage4 then.
    end.
    
    if num-results("brDigitaFunc":U) = 0 then
        assign btUpdateFunc:SENSITIVE in frame fPage4 = no
               btDeleteFunc:SENSITIVE in frame fPage4 = no.
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


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btGerar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGerar wReport
ON CHOOSE OF btGerar IN FRAME fPage5 /* Gerar */
DO:
    FOR EACH mab-motoris WHERE mab-motoris.ep-codigo = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF
                           AND mab-motoris.cod-estabel = "" NO-LOCK:

        FOR FIRST tt-digita WHERE tt-digita.ep-codigo = mab-motoris.ep-codigo
                              AND tt-digita.cod-estabel = mab-motoris.cod-estabel
                              AND tt-digita.cod-matr    = mab-motoris.cod-matr NO-LOCK: 
        END.
        IF NOT AVAIL(tt-digita) THEN DO:
            CREATE tt-digita.
            ASSIGN tt-digita.ep-codigo   = mab-motoris.ep-codigo
                   tt-digita.cod-estabel = mab-motoris.cod-estabel
                   tt-digita.cod-matr    = mab-motoris.cod-matr
                   tt-digita.nom-motoris = mab-motoris.nom-motoris.
        END.
    END.

    {&OPEN-QUERY-brdigita}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btGerarFunc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGerarFunc wReport
ON CHOOSE OF btGerarFunc IN FRAME fPage4 /* Gerar */
DO:
    FOR EACH mmv-func-ofici WHERE mmv-func-ofici.cod-estabel = "" NO-LOCK:
        FOR FIRST tt-digita-func WHERE tt-digita-func.ep-codigo   = mmv-func-ofici.ep-codigo  
                                   AND tt-digita-func.cod-estabel = mmv-func-ofici.cod-estabel
                                   AND tt-digita-func.cod-matr    = mmv-func-ofici.cod-matr NO-LOCK:   
        END.
        IF NOT AVAIL(tt-digita-func) THEN DO:
            CREATE tt-digita-func.
            ASSIGN tt-digita-func.ep-codigo   = mmv-func-ofici.ep-codigo
                   tt-digita-func.cod-estabel = mmv-func-ofici.cod-estabel
                   tt-digita-func.cod-matr    = mmv-func-ofici.cod-matr
                   tt-digita-func.nom-func    = mmv-func-ofici.nom-func.
        END.
    END.

    {&OPEN-QUERY-brDigitaFunc}

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
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wReport
ON CHOOSE OF btUpdate IN FRAME fPage5 /* Alterar */
DO:
  APPLY "ENTRY":U TO tt-digita.ep-codigo IN BROWSE brDigita.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btUpdateFunc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateFunc wReport
ON CHOOSE OF btUpdateFunc IN FRAME fPage4 /* Alterar */
DO:
  APPLY "ENTRY":U TO tt-digita-func.cod-estabel IN BROWSE brDigitaFunc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME l-habilitaRtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-habilitaRtf wReport
ON VALUE-CHANGED OF l-habilitaRtf IN FRAME fPage6 /* RTF */
DO:
    &IF "{&RTF}":U = "YES":U &THEN
    RUN pi-habilitaRtf.  
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
                   btConfigImpr:visible  = yes
                   /*Alterado 15/02/2005 - tech1007 - Alterado para suportar adequadamente com a 
                     funcionalidade de RTF*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = NO
                   l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
                   l-habilitaRtf = NO
                   &endif
                   .
                   /*Fim alteracao 15/02/2005*/
        end.
        when "2":U then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   .
        end.
        when "3":U then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   .
            /*Alterado 15/02/2005 - tech1007 - Teste para funcionar corretamente no WebEnabler*/
            &IF "{&RTF}":U = "YES":U &THEN
            IF VALID-HANDLE(hWenController) THEN DO:
                ASSIGN l-habilitaRtf:sensitive  = NO
                       l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
                       l-habilitaRtf = NO.
            END.
            &endif
            /*Fim alteracao 15/02/2005*/
        END.
        /*Alterado 15/02/2005 - tech1007 - Condiá∆o removida pois RTF n∆o Ç mais um destino
        when "4":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes
                   text-ModelRtf:VISIBLE   = YES
                   rect-rtf:VISIBLE       = YES
                   blModelRtf:VISIBLE       = yes.
        end.
        Fim alteracao 15/02/2005*/
    end case.
end.
&IF "{&RTF}":U = "YES":U &THEN
RUN pi-habilitaRtf.  
&endif
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
&Scoped-define BROWSE-NAME brDigita
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{report/mainblock.i}
tt-digita-func.cod-estabel:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in BROWSE brDigitaFunc.

tt-digita.ep-codigo:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in BROWSE brDigita.
tt-digita.cod-estabel:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in BROWSE brDigita.

    ON 'F5':U OF tt-digita.ep-codigo IN BROWSE brDigita DO:
        {include/zoomvar.i 
                &prog-zoom=adzoom/z01ad101.w
                                &campo=tt-digita.ep-codigo
                                &campozoom=ep-codigo
                                &browse=brDigita}
                                
        ASSIGN tt-digita.ep-codigo.
    END.
     
    ON 'MOUSE-SELECT-DBLCLICK':U OF tt-digita.ep-codigo IN BROWSE brDigita DO:
        APPLY "F5":U TO tt-digita.ep-codigo IN BROWSE brDigita.
    END.

    ON 'F5':U OF tt-digita.cod-estabel IN BROWSE brDigita DO:
        {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                                &campo=tt-digita.cod-estabel
                                &campozoom=cod-estabel
                                &browse=brDigita}
        ASSIGN tt-digita.cod-estabel.
    END.
     
    ON 'MOUSE-SELECT-DBLCLICK':U OF tt-digita.cod-estabel IN BROWSE brDigita DO:
        APPLY "F5":U TO tt-digita.cod-estabel IN BROWSE brDigita.
    END.

    on "LEAVE" of tt-digita.cod-matr in browse brDigita DO:
         FIND FIRST mab-motoris  WHERE mab-motoris.ep-codigo = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF
                                   AND mab-motoris.cod-estabel = ""
                                   AND mab-motoris.cod-matr = INPUT BROWSE brDigita tt-digita.cod-matr NO-LOCK NO-ERROR.
         IF AVAIL mab-motoris THEN DO:
                DISP mab-motoris.nom-motoris @ tt-digita.nom-motoris WITH BROWSE brDigita.
         END.
    END.

    
    on "LEAVE" of tt-digita-func.cod-matr in browse brDigitaFunc DO:
         FIND FIRST mmv-func-ofici 
              WHERE mmv-func-ofici.ep-codigo = INPUT BROWSE brDigitaFunc tt-digita-func.ep-codigo
                AND mmv-func-ofici.cod-estabel = "":U
                AND mmv-func-ofici.cod-matr  = INPUT BROWSE brDigitaFunc tt-digita-func.cod-matr NO-LOCK NO-ERROR.
         IF AVAIL mmv-func-ofici THEN DO:
                DISP mmv-func-ofici.nom-func @ tt-digita-func.nom-func WITH BROWSE brDigitaFunc.
         END.
    END.

    ON 'MOUSE-SELECT-DBLCLICK':U of tt-digita-func.cod-estabel in browse brDigitaFunc DO:
        APPLY "F5":U TO tt-digita-func.cod-estabel IN BROWSE brDigitaFunc.
    END.

    ON 'F5':U of tt-digita-func.cod-estabel in browse brDigitaFunc DO:
       {include/zoomvar.i 
                &prog-zoom=adzoom/z01ad107.w
                                &campo=tt-digita-func.cod-estabel
                                &campozoom=cod-estabel
                                &browse=brDigitaFunc}

        ASSIGN tt-digita-func.cod-estabel.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*Alterado 17/02/2005 - tech1007 - Foi criado essa procedure para que seja realizado a inicializaá∆o
  correta dos componentes do RTF quando executado em ambiente local e no WebEnabler.*/
&IF "{&RTF}":U = "YES":U &THEN
IF VALID-HANDLE(hWenController) THEN DO:
    ASSIGN l-habilitaRtf:sensitive IN FRAME fPage6 = NO
           l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
           l-habilitaRtf = NO.
           
END.
RUN pi-habilitaRtf.
&endif
/*Fim alteracao 17/02/2005*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define var r-tt-digita as rowid no-undo.

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
/*:T** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}

    /*15/02/2005 - tech1007 - Teste alterado pois RTF n∆o Ç mais opá∆o de Destino*/
    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.
    
    /*16/02/2005 - tech1007 - Teste alterado para validar o modelo informado quando for RTF*/
    &IF "{&RTF}":U = "YES":U &THEN
    IF ( input frame fPage6 cModelRTF = "" AND
         input frame fPage6 l-habilitaRtf = YES ) OR
       ( SEARCH(INPUT FRAME fPage6 cModelRTF) = ? AND
         input frame fPage6 rsExecution = 1 AND
         input frame fPage6 l-habilitaRtf = YES )
         THEN DO:
        run utp/ut-msgs.p (input "show":U, input 73, input "":U).
        /*30/12/2004 - tech1007 - Evento removido pois causa problemas no WebEnabler*/
        /*apply "CHOOSE":U to blModelRtf in frame fPage6.*/
        return error.
    END.
    &endif
    
    /*:T Coloque aqui as validaá‰es da p†gina de Digitaá∆o, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p†gina e colocar
       o focus no campo com problemas */
    /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/
     /*
    for each tt-digita no-lock:
        assign r-tt-digita = rowid(tt-digita).
        
        /*:T Validaá∆o de duplicidade de registro na temp-table tt-digita */
        find first b-tt-digita 
            where b-tt-digita.ordem = tt-digita.ordem 
              and rowid(b-tt-digita) <> rowid(tt-digita) 
            no-lock no-error.
        if  avail b-tt-digita then do:
            reposition brDigita to rowid rowid(b-tt-digita).
            
            run utp/ut-msgs.p (input "SHOW":U, input 108, input "":U).
            apply "ENTRY":U to tt-digita.ordem in browse brDigita.
            
            return error.
        end.
        */
        /*:T As demais validaá‰es devem ser feitas aqui 
        if  tt-digita.ordem <= 0 then do:
            assign browse brDigita:CURRENT-COLUMN = tt-digita.ordem:HANDLE in browse brDigita.
            
            reposition brDigita to rowid r-tt-digita.
           
            run utp/ut-msgs.p (input "SHOW":U, input 99999, input "":U).
            apply "ENTRY":U to tt-digita.ordem in browse brDigita.
            
            return error.
        end.
             
    end.     */
    
    
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
           tt-param.classifica      = 0
           tt-param.desc-classifica = ""
           &IF "{&RTF}":U = "YES":U &THEN
           tt-param.modelo          = INPUT FRAME fPage6 cModelRTF
           tt-param.l-habilitaRtf    = INPUT FRAME fPage6 l-habilitaRtf
           &endif
           .
    
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
    
    {report/rprun.i abp/ab0707rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.
&ELSE
/*:T** Importacao/Exportacao ***/
do  on error undo, return error
    on stop  undo, return error:     

    {report/rpexa.i}

    if  input frame fPage7 rsDestiny = 2 and
        input frame fPage7 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage7 cDestinyFile).
        if  return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "SHOW":U,
                               input 73,
                               input "":U).
            apply "ENTRY":U to cDestinyFile in frame fPage7.                   
            return error.
        end.
    end.
    

    /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p†gina 
       com problemas e colocar o focus no campo com problemas             */    
         
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage7 rsDestiny
           tt-param.todos           = input frame fPage7 rsAll
           tt-param.arq-entrada     = ""
           tt-param.data-exec       = today
           tt-param.hora-exec       = time.

    if  tt-param.destino = 1 then
        assign tt-param.arq-destino = "":U.
    else
    if  tt-param.destino = 2 THEN
        assign tt-param.arq-destino = input frame fPage7 cDestinyFile.
    else
        assign tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp":U.

    /*:T Coloque aqui a l¢gica de gravaá∆o dos parÉmtros e seleá∆o na temp-table
       tt-param */ 

    {report/imexb.i}

    if  session:set-wait-state("GENERAL":U) then.

    {report/imrun.i abp/ab0707rp.p}

    {report/imexc.i}

    if  session:set-wait-state("":U) then.
    
    {report/imtrm.i tt-param.arq-destino tt-param.destino}
    
end.
&ENDIF

EMPTY TEMP-TABLE tt-digita.
EMPTY TEMP-TABLE tt-digita-func.
{&OPEN-QUERY-brDigita}
{&OPEN-QUERY-brDigitaFunc}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

