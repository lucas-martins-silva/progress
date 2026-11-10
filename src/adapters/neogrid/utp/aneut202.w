&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i aneut202 1.01.00.002}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i aneut202 MUT}
&ENDIF



CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        Aneut202
&GLOBAL-DEFINE Version        2.01.000.00
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels  Parametros,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets rs-connect
&GLOBAL-DEFINE page5Widgets   
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
&GLOBAL-DEFINE page2Fields    
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
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

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

def stream s-imp.

DEF VAR l-crm AS LOG INIT NO.
DEF VAR l-b2b AS LOG INIT NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btOK btCancel btHelp2 rtToolBar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 c-Url c-Url-2 c-queuename c-queuename-2 ~
c-autorization c-autorization-2 de-maxMessage de-maxMessage-2 c-in c-in-2 ~
c-out c-out-2 c-pattern c-pattern-2 c-Manager c-Manager-2 c-mqname ~
c-mqname-2 

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

DEFINE VARIABLE c-autorization AS CHARACTER FORMAT "X(256)":U 
     LABEL "Authorization" 
     VIEW-AS FILL-IN 
     SIZE 26 BY .79 NO-UNDO.

DEFINE VARIABLE c-autorization-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .79 NO-UNDO.

DEFINE VARIABLE c-in AS CHARACTER FORMAT "X(256)":U 
     LABEL "In" 
     VIEW-AS FILL-IN 
     SIZE 26 BY .79 NO-UNDO.

DEFINE VARIABLE c-in-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .79 NO-UNDO.

DEFINE VARIABLE c-Manager AS CHARACTER FORMAT "X(256)":U 
     LABEL "Queue Manager" 
     VIEW-AS FILL-IN 
     SIZE 26 BY .79 NO-UNDO.

DEFINE VARIABLE c-Manager-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .79 NO-UNDO.

DEFINE VARIABLE c-mqname AS CHARACTER FORMAT "X(256)":U 
     LABEL "Queue Name:" 
     VIEW-AS FILL-IN 
     SIZE 26 BY .79 NO-UNDO.

DEFINE VARIABLE c-mqname-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .79 NO-UNDO.

DEFINE VARIABLE c-out AS CHARACTER FORMAT "X(256)":U 
     LABEL "Out" 
     VIEW-AS FILL-IN 
     SIZE 26 BY .79 NO-UNDO.

DEFINE VARIABLE c-out-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .79 NO-UNDO.

DEFINE VARIABLE c-pattern AS CHARACTER FORMAT "X(256)":U 
     LABEL "Pattern" 
     VIEW-AS FILL-IN 
     SIZE 26 BY .79 NO-UNDO.

DEFINE VARIABLE c-pattern-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .79 NO-UNDO.

DEFINE VARIABLE c-queuename AS CHARACTER FORMAT "X(256)":U 
     LABEL "Queue Name" 
     VIEW-AS FILL-IN 
     SIZE 26 BY .79 NO-UNDO.

DEFINE VARIABLE c-queuename-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .79 NO-UNDO.

DEFINE VARIABLE c-Url AS CHARACTER FORMAT "X(256)":U 
     LABEL "Host Name" 
     VIEW-AS FILL-IN 
     SIZE 26 BY .79 NO-UNDO.

DEFINE VARIABLE c-Url-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .79 NO-UNDO.

DEFINE VARIABLE de-maxMessage AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Max Size (MB)" 
     VIEW-AS FILL-IN 
     SIZE 7.86 BY .79 TOOLTIP "Max Message Mb" NO-UNDO.

DEFINE VARIABLE de-maxMessage-2 AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7.86 BY .79 TOOLTIP "Max Message Mb" NO-UNDO.

DEFINE VARIABLE rs-connect AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Http ", 1,
"File ", 2,
"MQ  ", 3
     SIZE 6 BY 10.96 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75 BY 11.96.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 39 BY 4.46.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 39 BY 3.75.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 39 BY 2.5.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28 BY 4.46.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28 BY 3.75.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28 BY 2.5.

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

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
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


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.96
         FONT 1.

DEFINE FRAME fPage4
     rs-connect AT ROW 2.17 COL 2.86 NO-LABEL
     c-Url AT ROW 2.25 COL 19.43 COLON-ALIGNED
     c-Url-2 AT ROW 2.25 COL 47 COLON-ALIGNED NO-LABEL
     c-queuename AT ROW 3.25 COL 19.43 COLON-ALIGNED
     c-queuename-2 AT ROW 3.25 COL 47 COLON-ALIGNED NO-LABEL
     c-autorization AT ROW 4.25 COL 19.43 COLON-ALIGNED
     c-autorization-2 AT ROW 4.25 COL 47 COLON-ALIGNED NO-LABEL
     de-maxMessage AT ROW 5.21 COL 19.43 COLON-ALIGNED HELP
          "Max Message Mb"
     de-maxMessage-2 AT ROW 5.25 COL 47 COLON-ALIGNED HELP
          "Max Message Mb" NO-LABEL
     c-in AT ROW 7 COL 19.43 COLON-ALIGNED
     c-in-2 AT ROW 7 COL 47 COLON-ALIGNED NO-LABEL
     c-out AT ROW 8 COL 19.43 COLON-ALIGNED
     c-out-2 AT ROW 8 COL 47 COLON-ALIGNED NO-LABEL
     c-pattern AT ROW 8.96 COL 19.43 COLON-ALIGNED
     c-pattern-2 AT ROW 8.96 COL 47 COLON-ALIGNED NO-LABEL
     c-Manager AT ROW 10.67 COL 19.43 COLON-ALIGNED
     c-Manager-2 AT ROW 10.67 COL 47 COLON-ALIGNED NO-LABEL
     c-mqname AT ROW 11.67 COL 19.43 COLON-ALIGNED
     c-mqname-2 AT ROW 11.67 COL 47 COLON-ALIGNED NO-LABEL
     RECT-13 AT ROW 1.5 COL 2
     RECT-14 AT ROW 2 COL 9
     RECT-15 AT ROW 6.54 COL 9
     RECT-16 AT ROW 10.42 COL 9
     RECT-17 AT ROW 2 COL 48
     RECT-18 AT ROW 6.54 COL 48
     RECT-19 AT ROW 10.42 COL 48
     " Connection Type" VIEW-AS TEXT
          SIZE 13 BY .54 AT ROW 1.29 COL 4
     "CRM" VIEW-AS TEXT
          SIZE 4 BY .54 AT ROW 1.29 COL 31.72
     "Business-to-Business" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 1.25 COL 54
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 12.96
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btFile AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.58 COL 43.29 HELP
          "Configura‡Æo da impressora"
     cFile AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.75 COL 3 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 12.71
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.96
         WIDTH              = 90
         MAX-HEIGHT         = 28.46
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.46
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
ASSIGN FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FILL-IN c-autorization IN FRAME fPage4
   1                                                                    */
/* SETTINGS FOR FILL-IN c-autorization-2 IN FRAME fPage4
   1                                                                    */
/* SETTINGS FOR FILL-IN c-in IN FRAME fPage4
   1                                                                    */
/* SETTINGS FOR FILL-IN c-in-2 IN FRAME fPage4
   1                                                                    */
/* SETTINGS FOR FILL-IN c-Manager IN FRAME fPage4
   1                                                                    */
/* SETTINGS FOR FILL-IN c-Manager-2 IN FRAME fPage4
   1                                                                    */
/* SETTINGS FOR FILL-IN c-mqname IN FRAME fPage4
   1                                                                    */
/* SETTINGS FOR FILL-IN c-mqname-2 IN FRAME fPage4
   1                                                                    */
/* SETTINGS FOR FILL-IN c-out IN FRAME fPage4
   1                                                                    */
/* SETTINGS FOR FILL-IN c-out-2 IN FRAME fPage4
   1                                                                    */
/* SETTINGS FOR FILL-IN c-pattern IN FRAME fPage4
   1                                                                    */
/* SETTINGS FOR FILL-IN c-pattern-2 IN FRAME fPage4
   1                                                                    */
/* SETTINGS FOR FILL-IN c-queuename IN FRAME fPage4
   1                                                                    */
/* SETTINGS FOR FILL-IN c-queuename-2 IN FRAME fPage4
   1                                                                    */
/* SETTINGS FOR FILL-IN c-Url IN FRAME fPage4
   1                                                                    */
/* SETTINGS FOR FILL-IN c-Url-2 IN FRAME fPage4
   1                                                                    */
/* SETTINGS FOR FILL-IN de-maxMessage IN FRAME fPage4
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN de-maxMessage-2 IN FRAME fPage4
   1                                                                    */
/* SETTINGS FOR FRAME fPage6
                                                                        */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

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
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME rs-connect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-connect wReport
ON VALUE-CHANGED OF rs-connect IN FRAME fPage4
DO:
 DO WITH FRAME fpage4:

   CASE INPUT rs-connect :
      WHEN 1  THEN DO:
          ENABLE c-url c-queuename c-autorization de-maxmessage
                 c-url-2 c-queuename-2 c-autorization-2 de-maxmessage-2.
          
          DISABLE c-in c-out c-pattern c-manager c-mqname c-in-2 c-out-2 c-pattern-2 c-manager-2 c-mqname-2.
      END.
       WHEN 2  THEN DO:
          ENABLE c-in c-out c-pattern c-in-2 c-out-2 c-pattern-2.

          DISABLE c-url c-queuename c-autorization c-manager c-mqname de-maxmessage
                  c-url-2 c-queuename-2 c-autorization-2 c-manager-2 c-mqname-2 de-maxmessage-2.
       END.
       WHEN 3 THEN DO:
          ENABLE c-manager c-mqname c-manager-2 c-mqname-2.

          DISABLE  c-url c-queuename c-autorization c-in c-out c-pattern de-maxmessage
                   c-url-2 c-queuename-2 c-autorization-2 c-in-2 c-out-2 c-pattern-2 de-maxmessage-2.
       END.
   END CASE.

 END.
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


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{report/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterinitializeinterface wReport 
PROCEDURE afterinitializeinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
    ASSIGN l-crm = YES.
    
    RUN utp/ut-neog.p.
    ASSIGN l-b2b = IF RETURN-VALUE = "NOK" THEN NO ELSE YES.

    FIND FIRST ngadapterparms NO-LOCK NO-ERROR.
    IF  AVAIL ngadapterparms THEN DO:
        IF  (NUM-ENTRIES(ngadapterparms.queuemanager,",") = 3
        OR   NUM-ENTRIES(ngadapterparms.char-1,",") = 3)
        AND (ENTRY(1,ngadapterparms.queuemanager,",") = "MQ"
        OR   ENTRY(1,ngadapterparms.char-1,",") = "MQ") THEN DO:

            ASSIGN rs-connect  = 3.

            IF l-crm AND ngadapterparms.queuemanager <> "" THEN
               ASSIGN c-manager   = ENTRY(2,ngadapterparms.queuemanager,",") 
                      c-mqName    = ENTRY(3,ngadapterparms.queuemanager,",").
            ELSE 
               ASSIGN c-manager   = ""
                      c-mqName    = "".


            IF l-b2b AND ngadapterparms.char-1 <> "" THEN
               ASSIGN c-manager-2 = ENTRY(2,ngadapterparms.char-1,",")
                      c-mqName-2  = ENTRY(3,ngadapterparms.char-1,",").
            ELSE 
               ASSIGN c-manager-2 = ""
                      c-mqName-2  = "".

            DISP rs-connect c-manager c-mqname c-manager-2 c-mqname-2 WITH FRAME fpage4.
        END.
        ELSE DO:
            IF  (NUM-ENTRIES(ngadapterparms.queuemanager,",") >= 3 
            OR   NUM-ENTRIES(ngadapterparms.char-1,",") >= 3)
            AND (ENTRY(1,ngadapterparms.queuemanager,",") = "HTTP"
            OR   ENTRY(1,ngadapterparms.char-1,",") = "HTTP") THEN DO:

                ASSIGN rs-connect       = 1.

                IF l-crm AND ngadapterparms.queuemanager <> "" THEN
                    ASSIGN c-url            = ENTRY(2,ngadapterparms.queuemanager,",") 
                           c-queuename      = ENTRY(3,ngadapterparms.queuemanager,",")
                           c-Autorization   = IF NUM-ENTRIES(ngadapterparms.queuemanager,",") = 4 
                                                 THEN ENTRY(4,ngadapterparms.queuemanager,",") 
                                                 ELSE ""
                           de-maxmessage    = INT(TRIM(STRING(INT(SUBSTR(ngadapterparms.queuename,6,5)),">>>>9"))).
                ELSE 
                    ASSIGN c-url            = ""
                           c-queuename      = ""
                           c-Autorization   = ""
                           de-maxmessage    = 0.

                IF l-b2b AND ngadapterparms.char-1 <> "" THEN
                    ASSIGN c-url-2          = ENTRY(2,ngadapterparms.char-1,",") 
                           c-queuename-2    = ENTRY(3,ngadapterparms.char-1,",")
                           c-Autorization-2 = IF NUM-ENTRIES(ngadapterparms.char-1,",") = 4 
                                                 THEN ENTRY(4,ngadapterparms.char-1,",") 
                                                 ELSE ""
                           de-maxmessage-2  =  INT(TRIM(STRING(INT(SUBSTR(ngadapterparms.queuename,6,5)),">>>>9"))).
                ELSE 
                    ASSIGN c-url-2          = "" 
                           c-queuename-2    = ""
                           c-Autorization-2 = ""
                           de-maxmessage-2  = 0.

                DISP rs-connect c-url c-queuename c-autorization de-maxmessage
                                c-url-2 c-queuename-2 c-autorization-2 de-maxmessage-2 WITH FRAME fpage4.
            END.
            ELSE DO:
                IF  (NUM-ENTRIES(ngadapterparms.queuemanager,",") = 4
                OR   NUM-ENTRIES(ngadapterparms.char-1,",") = 4)
                AND (ENTRY(1,ngadapterparms.queuemanager,",") = "FILE"
                OR   ENTRY(1,ngadapterparms.char-1,",") = "FILE") THEN DO:

                    ASSIGN rs-connect  = 2.

                    IF l-crm AND ngadapterparms.queuemanager <> "" THEN
                        ASSIGN c-in        = ENTRY(2,ngadapterparms.queuemanager,",") 
                               c-out       = ENTRY(3,ngadapterparms.queuemanager,",") 
                               c-pattern   = ENTRY(4,ngadapterparms.queuemanager,",").
                    ELSE 
                        ASSIGN c-in        = "" 
                               c-out       = "" 
                               c-pattern   = "".

                    IF l-b2b AND ngadapterparms.char-1 <> "" THEN
                        ASSIGN c-in-2      = ENTRY(2,ngadapterparms.char-1,",") 
                               c-out-2     = ENTRY(3,ngadapterparms.char-1,",") 
                               c-pattern-2 = ENTRY(4,ngadapterparms.char-1,",").
                    ELSE 
                        ASSIGN c-in-2      = "" 
                               c-out-2     = "" 
                               c-pattern-2 = "".

                    DISP rs-connect c-in c-out c-pattern 
                                    c-in-2 c-out-2 c-pattern-2 WITH FRAME fpage4.
                END.
            END.
        END. 
    END.
    
    APPLY "value-changed" TO rs-connect IN FRAME fpage4.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-saveNgParms wReport 
PROCEDURE pi-saveNgParms :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST ngadapterparms EXCLUSIVE-LOCK NO-ERROR.
    IF  NOT AVAIL ngadapterparms THEN DO:
        CREATE ngadapterparms.
        ASSIGN SUBSTR(ngadapterparms.queuename,1,10) = "0000500005".
    END.
    ASSIGN INPUT FRAME fpage4 {&List-1}.
    CASE INPUT FRAME fpage4 rs-connect :
        WHEN 1 THEN DO:
            ASSIGN ngadapterparms.queuemanager = 'HTTP,' + C-url   + ',' + c-queuename
                   ngadapterparms.char-1       = 'HTTP,' + C-url-2 + ',' + c-queuename-2.

            IF c-autorization <> "" 
                THEN ASSIGN ngadapterparms.queuemanager = ngadapterparms.queuemanager + "," + c-autorization.

            IF c-autorization-2 <> "" 
                THEN ASSIGN ngadapterparms.char-1 = ngadapterparms.char-1 + "," + c-autorization.

            ASSIGN SUBSTR(ngadapterparms.queuename,6,5) = STRING(de-maxMessage-2,"99999").

        END.
        WHEN 2 THEN DO:
            ASSIGN ngadapterparms.queuemanager = 'File,' + C-In   + ',' + c-Out   + ',' + c-pattern
                   ngadapterparms.char-1       = 'File,' + C-In-2 + ',' + c-Out-2 + ',' + c-pattern-2.   
        END.
        WHEN 3 THEN DO:
            ASSIGN ngadapterparms.queuemanager = 'MQ,' + C-manager   + ',' + c-MqName   + ','
                   ngadapterparms.char-1       = 'MQ,' + C-manager-2 + ',' + c-MqName-2 + ','.

        END.

    END CASE.

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
    
    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:

        run utp/ut-vlarq.p (input input frame fPage6 cFile).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.
    
    /*:T Coloque aqui as valida‡äes da p gina de Digita‡Æo, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p gina e colocar
       o focus no campo com problemas */
    /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/
    
    
    
    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */
    
    
    
    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time.
    
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    
    
    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    RUN pi-saveNGParms.
    
    {report/rprun.i adapters/neogrid/utp/aneut202rp.p}
    
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
    
    assign file-info:file-name = input frame fPage4 cInputFile.
    if  file-info:pathname = ? and
        input frame fPage7 rsExecution = 1 then do:
        run utp/ut-msgs.p (input "SHOW":U,
                           input 326,
                           input cInputFile).                               
        apply "ENTRY":U to cInputFile in frame fPage4.                
        return error.
    end. 
            
    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p gina 
       com problemas e colocar o focus no campo com problemas             */    
         
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage7 rsDestiny
           tt-param.todos           = input frame fPage7 rsAll
           tt-param.arq-entrada     = input frame fPage4 cInputFile
           tt-param.data-exec       = today
           tt-param.hora-exec       = time.

    if  tt-param.destino = 1 then
        assign tt-param.arq-destino = "":U.
    else
    if  tt-param.destino = 2 then 
        assign tt-param.arq-destino = input frame fPage7 cDestinyFile.
    else
        assign tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp":U.

    /*:T Coloque aqui a l¢gica de grava‡Æo dos parƒmtros e sele‡Æo na temp-table
       tt-param */ 

    {report/imexb.i}

    if  session:set-wait-state("GENERAL":U) then.

    {report/imrun.i xxp/xx9999rp.p}

    {report/imexc.i}

    if  session:set-wait-state("":U) then.
    
    {report/imtrm.i tt-param.arq-destino tt-param.destino}
    
end.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

