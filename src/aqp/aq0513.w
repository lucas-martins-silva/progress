&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0513 2.00.00.000 } /*** 010000 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0513 MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AQ0513
&GLOBAL-DEFINE Version        2.00.00.000
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Parƒmetro,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2

&GLOBAL-DEFINE page2Widgets   

&GLOBAL-DEFINE page4Widgets  
&GLOBAL-DEFINE page5Widgets   

&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution 
                         


&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo

  
&GLOBAL-DEFINE page2Fields    fi-cod-rota-ini ~
                              fi-cod-rota-end ~
                              fi-cdn-grp-produt-ini  ~
                              fi-cdn-grp-produt-fim  ~
                              fi-cdn-produt-rural-ini  ~
                              fi-cdn-produt-rural-fim  


 
&GLOBAL-DEFINE page4Fields    fi-cod-estabel ~
                              fi-period ~
                              cb-item
                             

&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile 



/* Parameters Definitions ---                                           */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino              AS INTEGER
    FIELD execucao             AS INTEGER
    FIELD arquivo              AS CHAR format "x(35)":U
    FIELD usuario              AS CHAR format "x(12)":U
    FIELD data-exec            AS DATE
    FIELD hora-exec            AS INTEGER
    FIELD cod-rota-ini         AS CHARACTER
    FIELD cod-rota-fim         AS CHARACTER
    FIELD cdn-grp-produt-ini   AS INTEGER 
    FIELD cdn-grp-produt-fim   AS INTEGER 
    FIELD cdn-produt-rural-ini AS INTEGER 
    FIELD cdn-produt-rural-fim AS INTEGER 
    FIELD cod-estabel          AS CHARACTER
    FIELD period               AS CHARACTER FORMAT "99/9999"
    FIELD it-codigo            AS CHARACTER.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD id AS INTEGER. 

/* Transfer Definitions */

DEFINE VARIABLE raw-param AS RAW NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
   FIELD raw-digita AS RAW.

DEFINE VARIABLE l-ok             AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-arq-digita     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-terminal       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-rtf            AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-arq-layout     AS CHARACTER NO-UNDO.      
DEFINE VARIABLE c-arq-temp       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-modelo-default AS CHARACTER NO-UNDO.

def stream s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est  rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

{utp/ut-glob.i}

/* HANDLES */
DEFINE VARIABLE h-boad107na AS HANDLE NO-UNDO. /* estabelec         */
DEFINE VARIABLE h-boin00983 AS HANDLE NO-UNDO. /* item-estab-rural  */
DEFINE VARIABLE h-boin00968 AS HANDLE NO-UNDO. /* param-aquis-rural */
DEFINE VARIABLE h-boin627zm AS HANDLE NO-UNDO. /* usuar-mater       */
DEFINE VARIABLE h-boin287   AS HANDLE NO-UNDO. /* param-estoq        */

/* ZOOM SMART */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE VARIABLE c-cod-estabel-aux AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-it-codigo-aux   AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-seq-digita      AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-diretorio       AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-seq-digita wReport 
FUNCTION fn-seq-digita RETURNS INTEGER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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

DEFINE VARIABLE fi-cdn-grp-produt-fim AS INTEGER FORMAT ">>>>>9":U INITIAL 999999
     VIEW-AS FILL-IN 
     SIZE 9 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-cdn-grp-produt-ini AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "Grupo Produtor" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-cdn-produt-rural-fim AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-cdn-produt-rural-ini AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Produtor" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-cod-rota-end AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-cod-rota-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Rota" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE cb-item AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE fi-period AS CHARACTER FORMAT "99/9999":U 
     LABEL "Per¡odo" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image/im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 43.86 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 6.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 6.86 BY .63
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
     SIZE 27.86 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49.86 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 1.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.92
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 46.86 HELP
          "Escolha do nome do arquivo"
     rsExecution AT ROW 5.96 COL 2.86 HELP
          "Modo de Execu‡Æo" NO-LABEL
     btConfigImpr AT ROW 3.5 COL 47 HELP
          "Configura‡Æo da impressora"
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5.21 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.46 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     fi-cod-estabel AT ROW 3 COL 15 COLON-ALIGNED
     fi-nome AT ROW 3 COL 23.14 COLON-ALIGNED NO-LABEL
     fi-period AT ROW 4 COL 15 COLON-ALIGNED
     cb-item AT ROW 5 COL 15 COLON-ALIGNED
     fi-desc-item AT ROW 5 COL 31.29 COLON-ALIGNED NO-LABEL WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     fi-cod-rota-ini AT ROW 2.96 COL 18.43
     fi-cod-rota-end AT ROW 2.96 COL 49.29 NO-LABEL
     fi-cdn-grp-produt-ini AT ROW 3.96 COL 11.43
     fi-cdn-grp-produt-fim AT ROW 3.96 COL 49.29 NO-LABEL
     fi-cdn-produt-rural-ini AT ROW 4.96 COL 16
     fi-cdn-produt-rural-fim AT ROW 4.96 COL 49.43 NO-LABEL
     IMAGE-1 AT ROW 2.96 COL 37.72
     IMAGE-2 AT ROW 2.96 COL 46.29
     IMAGE-5 AT ROW 3.96 COL 37.72 WIDGET-ID 14
     IMAGE-6 AT ROW 3.96 COL 46.29 WIDGET-ID 16
     IMAGE-7 AT ROW 4.96 COL 37.72 WIDGET-ID 22
     IMAGE-8 AT ROW 4.96 COL 46.29 WIDGET-ID 24
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.96
         FONT 1 WIDGET-ID 100.


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
         HEIGHT             = 16.92
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

{report/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,                                                          */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN fi-cdn-grp-produt-fim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-cdn-grp-produt-ini IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-cdn-produt-rural-fim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-cdn-produt-rural-ini IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-cod-rota-end IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-cod-rota-ini IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN text-destino:PRIVATE-DATA IN FRAME fPage6  = "Destino".

ASSIGN text-modo:PRIVATE-DATA IN FRAME fPage6     = "Execu‡Æo".

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
&Scoped-define SELF-NAME cb-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-item wReport
ON VALUE-CHANGED OF cb-item IN FRAME fPage4 /* Item */
DO:
    DEFINE VARIABLE c-desc-item AS CHARACTER   NO-UNDO.

    IF SELF:SCREEN-VALUE <> "" AND c-it-codigo-aux <> SELF:SCREEN-VALUE THEN DO:
        IF VALID-HANDLE(h-boin00983) THEN DO:
           RUN findDescItem IN h-boin00983(INPUT SELF:SCREEN-VALUE, OUTPUT c-desc-item).
    
           ASSIGN fi-desc-item:SCREEN-VALUE IN FRAME fPage4 = c-desc-item.
        END.

        EMPTY TEMP-TABLE tt-digita NO-ERROR.
        ASSIGN i-seq-digita = 0.
        {&OPEN-QUERY-brDigita}
       
    END.                      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel wReport
ON LEAVE OF fi-cod-estabel IN FRAME fPage4 /* Estabelecimento */
OR "ENTRY" OF fi-cod-estabel DO:

    IF SELF:SCREEN-VALUE <> "" AND c-cod-estabel-aux <> SELF:SCREEN-VALUE  THEN DO:
        ASSIGN c-cod-estabel-aux = SELF:SCREEN-VALUE.
    
        IF VALID-HANDLE(h-boin00968) THEN DO:
            RUN goToKey IN h-boin00968(INPUT SELF:SCREEN-VALUE).
            IF RETURN-VALUE = "OK":U THEN DO:
                {method/ReferenceFields.i &HandleDBOLeave="h-boad107na"
                                          &KeyValue1="SELF:SCREEN-VALUE"
                                          &FieldName1="nome"
                                          &FieldScreen1="fi-nome"
                                          &Frame1="fPage4"}
                                          
                                          
                RUN pi-carrega-cb-item       IN THIS-PROCEDURE(INPUT SELF:SCREEN-VALUE).
                RUN pi-busca-ult-period-fech IN THIS-PROCEDURE(INPUT SELF:SCREEN-VALUE).                          
            END.
            ELSE
              ASSIGN fi-nome:SCREEN-VALUE IN FRAME fPage4 = "".
        END.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-estabel IN FRAME fPage4 /* Estabelecimento */
OR 'F5' OF fi-cod-estabel DO:

    ASSIGN l-implanta = NO.
                       
    {method/zoomfields.i &ProgramZoom="inzoom/z01in00968.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="fi-cod-estabel"
                         &Frame1="fPage4"                         
                         &EnableImplant="NO"}                        
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
        /*Alterado 15/02/2005 - tech1007 - Condi‡Æo removida pois RTF nÆo ‚ mais um destino
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
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

fi-cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U)IN FRAME fPage4.
{report/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wReport 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* estabelec */
    IF VALID-HANDLE(h-boad107na) THEN DO:
        DELETE PROCEDURE h-boad107na.
        ASSIGN h-boad107na = ?.          
    END.

    /* item-estab-rural */
    IF VALID-HANDLE(h-boin00983) THEN DO:
        DELETE PROCEDURE h-boin00983.
        ASSIGN h-boin00983 = ?.          
    END.

    /* param-aquis-rural */
    IF VALID-HANDLE(h-boin00968) THEN DO:
        DELETE PROCEDURE h-boin00968.
        ASSIGN h-boin00968 = ?.          
    END.

    /* usuar-mater */
    IF VALID-HANDLE (h-boin627zm) THEN DO: 
        DELETE PROCEDURE h-boin627zm .
        ASSIGN h-boin627zm = ?.
    END. 

    /* usuar-mater */
    IF VALID-HANDLE (h-boin287) THEN DO: 
        DELETE PROCEDURE h-boin287 .
        ASSIGN h-boin287 = ?.
    END.

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*Alterado 17/02/2005 - tech1007 - Foi criado essa procedure para que seja realizado a inicializa‡Æo
  correta dos componentes do RTF quando executado em ambiente local e no WebEnabler.*/

/*Fim alteracao 17/02/2005*/

    RUN initializeDBOs IN THIS-PROCEDURE.

    /*ASSIGN rsDestiny:SCREEN-VALUE IN FRAME fPage6 = '3'
           rsDestiny:SENSITIVE    IN FRAME fPage6 = NO
           rsExecution:SENSITIVE  IN FRAME fPage6 = NO.

    APPLY 'VALUE-CHANGED' TO rsDestiny IN FRAME fPage6.

    RUN setFolder IN hFolder (INPUT 1).*/

    RUN pi-busca-estab-padrao IN THIS-PROCEDURE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wReport 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* estabelec */
    IF NOT VALID-HANDLE(h-boad107na) THEN
        RUN adbo/boad107na.p PERSISTENT SET h-boad107na.
    RUN openQueryStatic IN h-boad107na(INPUT "Main") NO-ERROR.

    /* item-estab-rural */
    IF NOT VALID-HANDLE(h-boin00983) THEN
        RUN inbo/boin00983.p PERSISTENT SET h-boin00983.
    RUN openQueryStatic IN h-boin00983(INPUT "Main") NO-ERROR.
    
    /* param-aquis-rural */
    IF NOT VALID-HANDLE(h-boin00968) THEN
        RUN inbo/boin00968.p PERSISTENT SET h-boin00968.
    RUN openQueryStatic IN h-boin00968(INPUT "Main") NO-ERROR.

    /* usuar-mater */
    IF NOT VALID-HANDLE(h-boin627zm) THEN 
        RUN inbo/boin627zm.p PERSISTENT SET h-boin627zm.
    RUN OpenQueryStatic IN h-boin627zm (INPUT "Default":U) NO-ERROR.
    
    /* usuar-mater */
    IF NOT VALID-HANDLE(h-boin287) THEN 
        RUN inbo/boin287.p PERSISTENT SET h-boin287.
    RUN OpenQueryStatic IN h-boin287 (INPUT "Main":U) NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-estab-padrao wReport 
PROCEDURE pi-busca-estab-padrao :
/*------------------------------------------------------------------------------
  Purpose: BUSCAR E APRESENTAR NA TELA O ESTABELECIMENTO PADRÇO DO USUµRIO   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-char-1 AS CHARACTER NO-UNDO.

    IF VALID-HANDLE(h-boin627zm) THEN DO:
        RUN goTokey IN h-boin627zm(INPUT c-seg-usuario).
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getCharField IN h-boin627zm(INPUT "char-1":U, OUTPUT c-char-1).

            ASSIGN c-char-1 =  SUBSTRING(c-char-1,16,5).
            /* se nao encontrar estabelecimento padrao do usuario, busca estabelecimento padrao do estoque */
            IF c-char-1 = "" THEN DO:
                RUN openQueryStatic IN h-boin287(INPUT "Main":U).
                RUN getCharField    IN h-boin287(INPUT "estabel-pad":U, OUTPUT c-char-1).        
            END.

            ASSIGN fi-cod-estabel:SCREEN-VALUE IN FRAME fPage4 = c-char-1.
            APPLY "LEAVE":U TO fi-cod-estabel IN FRAME fPage4.
        END.
    END.         

    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-ult-period-fech wReport 
PROCEDURE pi-busca-ult-period-fech :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-cod-periodo AS CHARACTER   NO-UNDO.

    IF VALID-HANDLE(h-boin00968) THEN DO:
        RUN goToKey IN h-boin00968(INPUT pc-cod-estabel) NO-ERROR.
        IF RETURN-VALUE = "OK":U THEN
            RUN getCharField IN h-boin00968(INPUT "cod-periodo":U, OUTPUT c-cod-periodo) NO-ERROR.
    END.
    
    /* CASO NAO TENHA PERIDO FECHADO, SUGERE O PERIODO ATUAL */
    IF c-cod-periodo = "" THEN
        ASSIGN c-cod-periodo = STRING(MONTH(TODAY), "99") + STRING(YEAR(TODAY), "9999").

    ASSIGN fi-period:SCREEN-VALUE IN FRAME fPage4 = c-cod-periodo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-cb-item wReport 
PROCEDURE pi-carrega-cb-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-list AS CHARACTER NO-UNDO.

    IF VALID-HANDLE(h-boin00983) THEN DO:
        RUN getListItemPairs IN h-boin00983(INPUT pc-cod-estabel, OUTPUT c-list).

        ASSIGN cb-item:LIST-ITEM-PAIRS IN FRAME fPage4 = c-list
               cb-item:SCREEN-VALUE    IN FRAME fPage4 = ENTRY (1,c-list).

        APPLY 'VALUE-CHANGED':U TO cb-item IN FRAME fPage4. 
    END.
    RETURN "OK":U.
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
    DEFINE VARIABLE i-tipo-result AS INTEGER     NO-UNDO.

    /*:T** Relatorio ***/
    do on error undo, return error on stop  undo, return error:
        {report/rpexa.i}

        /*:T Coloque aqui as valida‡äes da p gina de Digita‡Æo, lembrando que elas devem
           apresentar uma mensagem de erro cadastrada, posicionar nesta p gina e colocar
           o focus no campo com problemas */
  

        IF INPUT FRAME fPage4 fi-cod-estabel = "" THEN DO:
            {utp/ut-liter.i Estabelecimento * }
            RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                               INPUT 265,  /* & deve ser informado*/
                               INPUT RETURN-VALUE).
            RETURN ERROR.
        END.
        ELSE IF INPUT FRAME fPage4 fi-period = "" THEN DO:
            {utp/ut-liter.i Per¡odo * }
            RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                               INPUT 265,  /* & deve ser informado*/
                               INPUT RETURN-VALUE).
            RETURN ERROR.
        END.
        ELSE IF INPUT FRAME fPage4 cb-item = "" THEN DO:
            {utp/ut-liter.i Item * }
            RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                               INPUT 265,  /* & deve ser informado*/
                               INPUT RETURN-VALUE).
            RETURN ERROR.
        END.  
        /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
           apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
           problemas e colocar o focus no campo com problemas */
        
        /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
           para o programa RP.P */
        
        create tt-param.
        assign tt-param.usuario               = c-seg-usuario
               tt-param.destino               = INPUT FRAME fPage6 rsDestiny
               tt-param.data-exec             = TODAY
               tt-param.hora-exec             = TIME
               tt-param.cod-rota-ini          = INPUT FRAME fPage2 fi-cod-rota-ini          
               tt-param.cod-rota-fim          = INPUT FRAME fPage2 fi-cod-rota-end        
               tt-param.cdn-grp-produt-ini    = INPUT FRAME fPage2 fi-cdn-grp-produt-ini  
               tt-param.cdn-grp-produt-fim    = INPUT FRAME fPage2 fi-cdn-grp-produt-fim  
               tt-param.cdn-produt-rural-ini  = INPUT FRAME fPage2 fi-cdn-produt-rural-ini
               tt-param.cdn-produt-rural-fim  = INPUT FRAME fPage2 fi-cdn-produt-rural-fim
               tt-param.arquivo               = INPUT FRAME fPage6 cFile
               tt-param.cod-estabel           = INPUT FRAME fPage4 fi-cod-estabel
               tt-param.period                = REPLACE(INPUT FRAME fPage4 fi-period, "/","")
               tt-param.it-codigo             = INPUT FRAME fPage4 cb-item 
               tt-param.execucao              = INPUT FRAME fPage6 rsExecution.

        IF tt-param.arquivo = "" THEN
            ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + "/AQ0513.lst". 

        /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
           como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
        
        /*:T Executar do programa RP.P que ir  criar o relat¢rio */
        {report/rpexb.i}
        
        SESSION:SET-WAIT-STATE("GENERAL":U).        
        {report/rprun.i aqp/aq0513rp.p}   
        {report/rpexc.i}
        SESSION:SET-WAIT-STATE("":U).        
        {report/rptrm.i}
    end.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-seq-digita wReport 
FUNCTION fn-seq-digita RETURNS INTEGER ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
     
    ASSIGN i-seq-digita = i-seq-digita + 1.

   RETURN  i-seq-digita.              
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

