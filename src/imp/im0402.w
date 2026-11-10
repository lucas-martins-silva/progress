&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
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
{include/i-prgvrs.i IM0402 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0402 MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0402
&GLOBAL-DEFINE Version        2.00.00.001
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

&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution

&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo text-param-impressao

&GLOBAL-DEFINE page2Fields    cCodEstabIni cCodEstabFim cCodEmbarqIni cCodEmbarqFim iNumDiEmsIni iNumDiEmsFim cCodDiSiscomexIni cCodDiSiscomexFim
&GLOBAL-DEFINE page4Fields    rs-tipo
&GLOBAL-DEFINE page6Fields    cFile lImprimeParametros
/* Parameters Definitions ---                                           */


/* Variables */
def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-rtf              as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.
def var raw-param          as raw     no-undo.

def stream s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est  rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

{imp/im0402.i}

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

DEFINE VARIABLE cCodDiSiscomexFim LIKE decla-import.cod-di-siscomex
     VIEW-AS FILL-IN 
     SIZE 18 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cCodDiSiscomexIni LIKE decla-import.cod-di-siscomex
     VIEW-AS FILL-IN 
     SIZE 18 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cCodEmbarqFim LIKE decla-import-ord.cod-embarq
     VIEW-AS FILL-IN 
     SIZE 22 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cCodEmbarqIni LIKE decla-import-ord.cod-embarq
     VIEW-AS FILL-IN 
     SIZE 22 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cCodEstabFim LIKE decla-import.cod-estab
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cCodEstabIni LIKE decla-import.cod-estab
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE iNumDiEmsFim LIKE decla-import.num-di-ems
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE iNumDiEmsIni LIKE decla-import.num-di-ems
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-tipo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Embarque", 1,
"Declara‡Æo de Importa‡Æo", 2
     SIZE 26 BY 2 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
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

DEFINE VARIABLE text-param-impressao AS CHARACTER FORMAT "X(256)":U INITIAL "Parƒmetros de ImpressÆo" 
      VIEW-AS TEXT 
     SIZE 22 BY .67 NO-UNDO.

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

DEFINE RECTANGLE RECT-90
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46 BY 1.5.

DEFINE VARIABLE lImprimeParametros AS LOGICAL INITIAL no 
     LABEL "Imprimir P gina de Parƒmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     rs-tipo AT ROW 1.5 COL 3 NO-LABEL WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     cCodEstabIni AT ROW 1.5 COL 22 HELP
          "C¢digo do estabelecimento."
          FONT 1
     cCodEstabFim AT ROW 1.5 COL 48 HELP
          "C¢digo do estabelecimento." NO-LABEL
          FONT 1
     cCodEmbarqIni AT ROW 2.5 COL 12.28 HELP
          "C¢digo Embarque" WIDGET-ID 4
          FONT 1
     cCodEmbarqFim AT ROW 2.5 COL 48 HELP
          "C¢digo Embarque" NO-LABEL WIDGET-ID 2
          FONT 1
     iNumDiEmsIni AT ROW 3.5 COL 7.43 HELP
          "N£mero Declara‡Æo de Importa‡Æo EMS" WIDGET-ID 20
          FONT 1
     iNumDiEmsFim AT ROW 3.5 COL 48 HELP
          "N£mero Declara‡Æo de Importa‡Æo EMS" NO-LABEL WIDGET-ID 18
          FONT 1
     cCodDiSiscomexIni AT ROW 4.5 COL 14.71 HELP
          "C¢digo DI Siscomex" WIDGET-ID 12
          FONT 1
     cCodDiSiscomexFim AT ROW 4.5 COL 48 HELP
          "C¢digo DI Siscomex" NO-LABEL WIDGET-ID 10
          FONT 1
     IMAGE-1 AT ROW 1.5 COL 41.86
     IMAGE-2 AT ROW 1.5 COL 45
     IMAGE-3 AT ROW 2.5 COL 41.86 WIDGET-ID 6
     IMAGE-4 AT ROW 2.5 COL 45 WIDGET-ID 8
     IMAGE-5 AT ROW 4.5 COL 41.86 WIDGET-ID 14
     IMAGE-6 AT ROW 4.5 COL 45 WIDGET-ID 16
     IMAGE-7 AT ROW 3.5 COL 41.86 WIDGET-ID 22
     IMAGE-8 AT ROW 3.5 COL 45 WIDGET-ID 24
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage6
     lImprimeParametros AT ROW 7.67 COL 3 WIDGET-ID 4
     text-param-impressao AT ROW 7 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configura‡Æo da impressora"
     rsExecution AT ROW 5.75 COL 2.86 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.25 COL 2
     RECT-90 AT ROW 7.25 COL 2 WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1 WIDGET-ID 100.


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
         HEIGHT             = 17
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
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN cCodDiSiscomexFim IN FRAME fPage2
   ALIGN-L LIKE = mgcex.decla-import.cod-di-siscomex EXP-SIZE           */
/* SETTINGS FOR FILL-IN cCodDiSiscomexIni IN FRAME fPage2
   ALIGN-L LIKE = mgcex.decla-import.cod-di-siscomex EXP-SIZE           */
/* SETTINGS FOR FILL-IN cCodEmbarqFim IN FRAME fPage2
   ALIGN-L LIKE = mgcex.decla-import-ord.cod-embarq EXP-SIZE            */
/* SETTINGS FOR FILL-IN cCodEmbarqIni IN FRAME fPage2
   ALIGN-L LIKE = mgcex.decla-import-ord.cod-embarq EXP-SIZE            */
/* SETTINGS FOR FILL-IN cCodEstabFim IN FRAME fPage2
   ALIGN-L LIKE = mgcex.decla-import.cod-estab EXP-SIZE                 */
/* SETTINGS FOR FILL-IN cCodEstabIni IN FRAME fPage2
   ALIGN-L LIKE = mgcex.decla-import.cod-estab EXP-SIZE                 */
/* SETTINGS FOR FILL-IN iNumDiEmsFim IN FRAME fPage2
   ALIGN-L LIKE = mgcex.decla-import.num-di-ems EXP-SIZE                */
/* SETTINGS FOR FILL-IN iNumDiEmsIni IN FRAME fPage2
   ALIGN-L LIKE = mgcex.decla-import.num-di-ems EXP-SIZE                */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

ASSIGN 
       text-param-impressao:PRIVATE-DATA IN FRAME fPage6     = 
                "Parƒmetros de ImpressÆo".

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
&Scoped-define SELF-NAME rs-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo wReport
ON VALUE-CHANGED OF rs-tipo IN FRAME fPage4
DO:
    RUN pi-habilita-selecao.
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
    &IF "{&RTF}":U = "YES":U &THEN
    IF VALID-HANDLE(hWenController) THEN DO:
        ASSIGN l-habilitaRtf:sensitive IN FRAME fPage6 = NO
               l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
               l-habilitaRtf = NO.
               
    END.
    RUN pi-habilitaRtf.
    &endif
    /*Fim alteracao 17/02/2005*/

    ASSIGN cCodEstabFim:SCREEN-VALUE IN FRAME fPage2 = "ZZZZZ":U 
           cCodEmbarqFim:SCREEN-VALUE IN FRAME fPage2 =  "ZZZZZZZZZZZZZZZZ":U
           iNumDiEmsFim:SCREEN-VALUE IN FRAME fPage2 = "999999999":U
           cCodDiSiscomexFim:SCREEN-VALUE IN FRAME fPage2 = "ZZZZZZZZZZZZZ":U
           rs-tipo:SCREEN-VALUE IN FRAME fPage4 = "1":U.

    RUN pi-habilita-selecao.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-selecao wReport 
PROCEDURE pi-habilita-selecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN cCodEstabIni     :SENSITIVE IN FRAME fPage2 = IF INPUT FRAME fPage4 rs-tipo = 1 THEN YES ELSE NO
           cCodEstabFim     :SENSITIVE IN FRAME fPage2 = IF INPUT FRAME fPage4 rs-tipo = 1 THEN YES ELSE NO
           cCodEmbarqIni    :SENSITIVE IN FRAME fPage2 = IF INPUT FRAME fPage4 rs-tipo = 1 THEN YES ELSE NO
           cCodEmbarqFim    :SENSITIVE IN FRAME fPage2 = IF INPUT FRAME fPage4 rs-tipo = 1 THEN YES ELSE NO
           iNumDiEmsIni     :SENSITIVE IN FRAME fPage2 = IF INPUT FRAME fPage4 rs-tipo = 1 THEN NO ELSE YES
           iNumDiEmsFim     :SENSITIVE IN FRAME fPage2 = IF INPUT FRAME fPage4 rs-tipo = 1 THEN NO ELSE YES
           cCodDiSiscomexIni:SENSITIVE IN FRAME fPage2 = IF INPUT FRAME fPage4 rs-tipo = 1 THEN NO ELSE YES
           cCodDiSiscomexFim:SENSITIVE IN FRAME fPage2 = IF INPUT FRAME fPage4 rs-tipo = 1 THEN NO ELSE YES.
                  
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
    define var r-tt-digita as rowid no-undo.
    
    &IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
    /*:T** Relatorio ***/
    do on error undo, return error on stop  undo, return error:
        {report/rpexa.i}
    
        /*15/02/2005 - tech1007 - Teste alterado pois RTF nÆo ‚ mais op‡Æo de Destino*/
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
               tt-param.hora-exec       = TIME
               tt-param.execucao        = INPUT FRAME fPage6 rsExecution
               &IF "{&RTF}":U = "YES":U &THEN
                    tt-param.modelo          = INPUT FRAME fPage6 cModelRTF
                    tt-param.l-habilitaRtf   = INPUT FRAME fPage6 l-habilitaRtf
               &endif
               tt-param.cCodEstabIni       = INPUT FRAME fPage2 cCodEstabIni     
               tt-param.cCodEstabFim       = INPUT FRAME fPage2 cCodEstabFim     
               tt-param.cCodEmbarqIni      = INPUT FRAME fPage2 cCodEmbarqIni    
               tt-param.cCodEmbarqFim      = INPUT FRAME fPage2 cCodEmbarqFim    
               tt-param.iNumDiEmsIni       = INPUT FRAME fPage2 iNumDiEmsIni     
               tt-param.iNumDiEmsFim       = INPUT FRAME fPage2 iNumDiEmsFim     
               tt-param.cCodDiSiscomexIni  = INPUT FRAME fPage2 cCodDiSiscomexIni
               tt-param.cCodDiSiscomexFim  = INPUT FRAME fPage2 cCodDiSiscomexFim
               tt-param.iTipoRelat         = INPUT FRAME fPage4 rs-tipo
               tt-param.lImprimeParametros = INPUT FRAME fPage6 lImprimeParametros
               .
        
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
        
        {report/rprun.i imp/im0402rp.p}
        
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
        if  tt-param.destino = 2 THEN
            assign tt-param.arq-destino = input frame fPage7 cDestinyFile.
        else
            assign tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
        /*:T Coloque aqui a l¢gica de grava‡Æo dos parƒmtros e sele‡Æo na temp-table
           tt-param */ 
    
        {report/imexb.i}
    
        if  session:set-wait-state("GENERAL":U) then.
    
        {report/imrun.i imp/im0402rp.p}
    
        {report/imexc.i}
    
        if  session:set-wait-state("":U) then.
        
        {report/imtrm.i tt-param.arq-destino tt-param.destino}
        
    end.
    &ENDIF
      
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

