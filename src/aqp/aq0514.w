&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
          mgmov            PROGRESS
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2016)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0514 2.00.00.000 } /*** 010000 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0514 MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AQ0514
&GLOBAL-DEFINE Version        2.00.00.000
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Classifica‡Æo,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          YES
&GLOBAL-DEFINE PGPAR          NO
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2

&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   rs-classif
&GLOBAL-DEFINE page4Widgets  
&GLOBAL-DEFINE page5Widgets   

&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution ~
                              l-imp-param 
                         


&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo

  
&GLOBAL-DEFINE page2Fields    d-data-ini d-data-fim  ~
                              i-cdn-produt-rural-ini i-cdn-produt-rural-fim ~
                              i-cdn-grp-produt-ini i-cdn-grp-produt-fim ~
                              c-cod-estabel-ini c-cod-estabel-fim ~
                              
                              
                              
&GLOBAL-DEFINE page3Fields    rs-classif 
 
&GLOBAL-DEFINE page4Fields    

&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile 



/* Parameters Definitions ---                                           */
{aqp/aq0514.i}



/* Transfer Definitions */
DEFINE VARIABLE raw-param AS RAW NO-UNDO.

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

/* ZOOM SMART */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

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

DEFINE VARIABLE c-cod-estabel-fim LIKE produt-carg.cod-estabel INITIAL "ZZZZZ"
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-ini LIKE produt-carg.cod-estabel INITIAL " "
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .88 NO-UNDO.

DEFINE VARIABLE d-data-fim LIKE produt-carg.dat-trans INITIAL 12/31/9999
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE d-data-ini LIKE produt-carg.dat-trans INITIAL TODAY
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-grp-produt-fim LIKE produt-rural.cdn-grp-produt INITIAL 999999
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-grp-produt-ini LIKE produt-rural.cdn-grp-produt INITIAL 0
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-produt-rural-fim LIKE produt-carg.cdn-produt-rural INITIAL 999999999
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-produt-rural-ini LIKE produt-carg.cdn-produt-rural INITIAL 0
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image/im-las":U
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

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-classif AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "1 - Por Produtor", 1,
"2 - Por Propriedade", 2,
"3 - Data de Transa‡Æo", 3
     SIZE 31 BY 4.5 NO-UNDO.

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
"Terminal", 3,
"Planilha", 4
     SIZE 46.86 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.86 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 1.71.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49.86 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 1.71.

DEFINE VARIABLE l-imp-param AS LOGICAL INITIAL yes 
     LABEL "Imprimir Parƒmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.86 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage3
     rs-classif AT ROW 3 COL 8.86 HELP
          "Classifica‡Æo para emissÆo do relat¢rio" NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.96
         FONT 1.

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.92
         FONT 1.

DEFINE FRAME fPage2
     d-data-ini AT ROW 3 COL 24.43 COLON-ALIGNED HELP
          "Data Transa‡Æo" WIDGET-ID 2
     d-data-fim AT ROW 3 COL 48.43 COLON-ALIGNED HELP
          "Data Transa‡Æo" NO-LABEL WIDGET-ID 4
     i-cdn-produt-rural-ini AT ROW 4 COL 21.57 COLON-ALIGNED HELP
          "Produtor Rural" WIDGET-ID 6
     i-cdn-produt-rural-fim AT ROW 4 COL 48.43 COLON-ALIGNED HELP
          "Produtor Rural" NO-LABEL WIDGET-ID 8
     i-cdn-grp-produt-ini AT ROW 5 COL 26.72 COLON-ALIGNED HELP
          "Grupo Produtor" WIDGET-ID 10
     i-cdn-grp-produt-fim AT ROW 5 COL 48.43 COLON-ALIGNED HELP
          "Grupo Produtor" NO-LABEL WIDGET-ID 12
     c-cod-estabel-ini AT ROW 6 COL 26.86 COLON-ALIGNED HELP
          "C¢digo do estabelecimento" WIDGET-ID 14
     c-cod-estabel-fim AT ROW 6 COL 48.43 COLON-ALIGNED HELP
          "C¢digo do estabelecimento" NO-LABEL WIDGET-ID 16
     IMAGE-1 AT ROW 3 COL 37.72
     IMAGE-2 AT ROW 3 COL 46.29
     IMAGE-5 AT ROW 4 COL 37.72
     IMAGE-6 AT ROW 4 COL 46.29
     IMAGE-7 AT ROW 5 COL 37.72
     IMAGE-8 AT ROW 5 COL 46.29
     IMAGE-9 AT ROW 5 COL 37.72
     IMAGE-10 AT ROW 5 COL 46.29
     IMAGE-11 AT ROW 6 COL 37.72
     IMAGE-12 AT ROW 6 COL 46.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.96
         FONT 1.

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
     l-imp-param AT ROW 8.71 COL 3.14
     "ImpressÆo de Parƒmetros" VIEW-AS TEXT
          SIZE 17.86 BY .67 AT ROW 7.88 COL 3.14
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.58 COL 2
     RECT-11 AT ROW 8.21 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.96
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
         TITLE              = "Relat¢rio de Cargas Rurais"
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
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-estabel-fim IN FRAME fPage2
   LIKE = mgmov.produt-carg.cod-estabel EXP-SIZE                        */
/* SETTINGS FOR FILL-IN c-cod-estabel-ini IN FRAME fPage2
   LIKE = mgmov.produt-carg.cod-estabel EXP-SIZE                        */
/* SETTINGS FOR FILL-IN d-data-fim IN FRAME fPage2
   LIKE = mgmov.produt-carg.dat-trans EXP-SIZE                          */
/* SETTINGS FOR FILL-IN d-data-ini IN FRAME fPage2
   LIKE = mgmov.produt-carg.dat-trans EXP-SIZE                          */
/* SETTINGS FOR FILL-IN i-cdn-grp-produt-fim IN FRAME fPage2
   LIKE = mgcad.produt-rural.cdn-grp-produt EXP-SIZE                    */
/* SETTINGS FOR FILL-IN i-cdn-grp-produt-ini IN FRAME fPage2
   LIKE = mgcad.produt-rural.cdn-grp-produt EXP-SIZE                    */
/* SETTINGS FOR FILL-IN i-cdn-produt-rural-fim IN FRAME fPage2
   LIKE = mgmov.produt-carg.cdn-produt-rural EXP-SIZE                   */
/* SETTINGS FOR FILL-IN i-cdn-produt-rural-ini IN FRAME fPage2
   LIKE = mgmov.produt-carg.cdn-produt-rural EXP-SIZE                   */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
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

ASSIGN rsExecution = int(rsExecution:SCREEN-VALUE IN FRAME fPage6).

IF  rsExecution = 2 THEN DO:
    IF  rsDestiny:SCREEN-VALUE IN FRAME fPage6 <> "1":U THEN
        ASSIGN cFile           = IF cFile:SCREEN-VALUE IN FRAME fPage6 = "":U THEN 
                                    IF cFile = "" THEN c-arq-old
                                      ELSE cFile
                                 ELSE cFile:SCREEN-VALUE IN FRAME fPage6
               c-arq-old       = cFile
               c-arq-old-batch = SUBSTRING(cFile, R-INDEX(cFile, "/":U) + 1) 
               cFile:SCREEN-VALUE IN FRAME fPage6 = c-arq-old-batch.

    APPLY "VALUE-CHANGED":U TO rsDestiny IN FRAME fPage6.

    ASSIGN cFile = cFile:SCREEN-VALUE IN FRAME fPage6.

    assign c-terminal = trim(c-terminal).
            
    rsDestiny:DISABLE(c-terminal) IN FRAME fPage6.

END.
ELSE DO:
    IF  rsDestiny:SCREEN-VALUE IN FRAME fPage6 <> "1":U THEN
        ASSIGN cFile           = IF cFile:SCREEN-VALUE IN FRAME fPage6 = "":U
                                 THEN cFile
                                 ELSE cFile:SCREEN-VALUE IN FRAME fPage6
               c-arq-old-batch = cFile.
    
    APPLY "VALUE-CHANGED":U TO rsDestiny IN FRAME fPage6.
    
    assign c-terminal = trim(c-terminal).
    
    rsDestiny:ENABLE(c-terminal) IN FRAME fPage6.

    ASSIGN cFile.
END.

/* end of rprse.i */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*Alterado 17/02/2005 - tech1007 - Foi criado essa procedure para que seja realizado a inicializa‡Æo
  correta dos componentes do RTF quando executado em ambiente local e no WebEnabler.*/

    ASSIGN rsDestiny                              = 4  
           rsDestiny:SENSITIVE    IN FRAME fPage6 = NO
           rsExecution:SENSITIVE  IN FRAME fPage6 = YES.

    DISPLAY rsDestiny
           WITH FRAME fPage6.
    APPLY 'VALUE-CHANGED' TO rsDestiny IN FRAME fPage6.

    RUN setFolder IN hFolder (INPUT 1).

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
    /*:T** Relatorio ***/
    do on error undo, return error on stop  undo, return error:
        {report/rpexa.i}

        /*:T Coloque aqui as valida»„es da pÿgina de Digita»’o, lembrando que elas devem
           apresentar uma mensagem de erro cadastrada, posicionar nesta pÿgina e colocar
           o focus no campo com problemas */
         
        /*:T Coloque aqui as valida»„es das outras pÿginas, lembrando que elas devem 
           apresentar uma mensagem de erro cadastrada, posicionar na pÿgina com 
           problemas e colocar o focus no campo com problemas */
        
        /*:T Aqui s’o gravados os campos da temp-table que serÿ passada como par³metro
           para o programa RP.P */
        
    CREATE tt-param.
    ASSIGN tt-param.usuario             = c-seg-usuario
           tt-param.destino               = INPUT FRAME fPage6 rsDestiny
           tt-param.data-exec             = TODAY
           tt-param.hora-exec             = TIME
           tt-param.d-data-ini            = INPUT FRAME fPage2 d-data-ini                   
           tt-param.d-data-fim            = INPUT FRAME fPage2 d-data-fim        
           tt-param.cdn-produt-rural-ini  = INPUT FRAME fPage2 i-cdn-produt-rural-ini
           tt-param.cdn-produt-rural-fim  = INPUT FRAME fPage2 i-cdn-produt-rural-fim
           tt-param.cdn-grp-produt-ini    = INPUT FRAME fPage2 i-cdn-grp-produt-ini  
           tt-param.cdn-grp-produt-fim    = INPUT FRAME fPage2 i-cdn-grp-produt-fim  
           tt-param.cod-estabel-ini       = INPUT FRAME fPage2 c-cod-estabel-ini
           tt-param.cod-estabel-fim       = INPUT FRAME fPage2 c-cod-estabel-fim
           tt-param.arquivo               = INPUT FRAME fPage6 cFile
           tt-param.execucao              = INPUT FRAME fPage6 rsExecution
           tt-param.imp-param             = l-imp-param:CHECKED IN FRAME fPage6
           tt-param.i-classif             = INPUT FRAME fPage3 rs-classif.
        IF tt-param.arquivo = "" THEN
            ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + "\AQ0514.lst". 


        /*:T Coloque aqui a l½gica de grava»’o dos demais campos que devem ser passados
           como par³metros para o programa RP.P, atrav²s da temp-table tt-param */
        
        
        /*:T Executar do programa RP.P que irÿ criar o relat½rio */
        {report/rpexb.i}
        
        SESSION:SET-WAIT-STATE("GENERAL":U).        
        {report/rprun.i aqp/aq0514rp.p}   
        {report/rpexc.i}
        SESSION:SET-WAIT-STATE("":U).        
        {report/rptrm.i}
    end.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME





