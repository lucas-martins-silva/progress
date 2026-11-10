&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i IM0680 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im0680 MIM}
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

{include/i_dbvers.i} /*Include de Pr‚-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar valida‡Æo produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
    {cdp/cdapi558.i1}
&endif
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0680
&GLOBAL-DEFINE Version        2.00.00.003
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
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution

&GLOBAL-DEFINE page6Text      text-Destino text-modo 

&GLOBAL-DEFINE page2Fields    fiCodEstabelIni fiCodEstabelFim ~
                              fiNrProcImpIni fiNrProcImpFim

&GLOBAL-DEFINE page4Fields    tgEnviaDoctoDespachante fiArquivoCopia   rsSeleciona ~
                              tgLayoutPadImp          fiLayoutPadImp   btLayoutPadImp ~
                              tgSobrepor              fiDirDestino     btDirDestino ~
                              rsOrientacao            tgItensLi        tgEmbEncerrados
&GLOBAL-DEFINE page6Fields    cFile


/* Parameters Definitions ---                                           */
{imp/im9100.i}


/*define buffer b-tt-digita for tt-digita.*/

DEFINE VARIABLE raw-param  AS RAW NO-UNDO.

DEFINE VARIABLE l-ok         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-terminal   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-arq-layout AS CHARACTER NO-UNDO.      
DEFINE VARIABLE c-arq-temp   AS CHARACTER NO-UNDO.

DEFINE STREAM s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est  rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

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

DEFINE VARIABLE fiCodEstabelFim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiCodEstabelIni LIKE estabelec.cod-estabel
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEmbarqueFim AS CHARACTER FORMAT "X(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fiEmbarqueIni AS CHARACTER FORMAT "X(12)" 
     LABEL "Embarque":R10 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fiNrProcImpFim AS CHARACTER FORMAT "X(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fiNrProcImpIni AS CHARACTER FORMAT "X(12)" 
     LABEL "Processo Importa‡Æo":R23 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-67
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-68
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-71
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-72
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON btDirDestino 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Escolha do diret¢rio".

DEFINE BUTTON btLayoutPadImp 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Escolha do diret¢rio".

DEFINE VARIABLE fiArquivoCopia AS CHARACTER FORMAT "X(100)":U 
     LABEL "Envia C¢pia Para" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .88 NO-UNDO.

DEFINE VARIABLE fiDirDestino AS CHARACTER FORMAT "X(60)":U 
     LABEL "Diret¢rio" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .88 NO-UNDO.

DEFINE VARIABLE fiLayoutPadImp AS CHARACTER FORMAT "X(60)":U 
     LABEL "Layout PadrÆo" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .88 NO-UNDO.

DEFINE VARIABLE rsOrientacao AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Retrato", 0,
"Paisagem", 1
     SIZE 12 BY 1.75 NO-UNDO.

DEFINE VARIABLE rsSeleciona AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Processo Importa‡Æo", 1,
"Embarque", 2
     SIZE 33 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 2.5.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 2.5.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 2.5.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 19 BY 3.25.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 3.25.

DEFINE VARIABLE tgEmbEncerrados AS LOGICAL INITIAL no 
     LABEL "Considera Embarques Encerrados" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.

DEFINE VARIABLE tgEnviaDoctoDespachante AS LOGICAL INITIAL no 
     LABEL "Envia Docto para o Despachante" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83
     FONT 1 NO-UNDO.

DEFINE VARIABLE tgItensLi AS LOGICAL INITIAL no 
     LABEL "Somente itens que necessitam de Licenciamento de Importa‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 48 BY .83 NO-UNDO.

DEFINE VARIABLE tgLayoutPadImp AS LOGICAL INITIAL yes 
     LABEL "Utiliza Layout PadrÆo dos Parƒmetros de Importa‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 39 BY .83
     FONT 1 NO-UNDO.

DEFINE VARIABLE tgSobrepor AS LOGICAL INITIAL yes 
     LABEL "Sobrepor Arquivos j  Existentes?" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

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
     SIZE 27.86 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.83.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.


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
         FONT 1.

DEFINE FRAME fPage2
     fiCodEstabelIni AT ROW 3.5 COL 17.28 HELP
          "C¢digo do estabelecimento"
          LABEL "Estab"
          FONT 1
     fiCodEstabelFim AT ROW 3.5 COL 56 HELP
          "C¢digo do estabelecimento" NO-LABEL
          FONT 1
     fiNrProcImpIni AT ROW 4.5 COL 20 COLON-ALIGNED HELP
          "Processo Importa‡Æo"
     fiNrProcImpFim AT ROW 4.5 COL 54 COLON-ALIGNED HELP
          "Processo Importa‡Æo" NO-LABEL
     fiEmbarqueIni AT ROW 5.5 COL 20 COLON-ALIGNED HELP
          "Informe C¢digo do Embarque"
     fiEmbarqueFim AT ROW 5.5 COL 54 COLON-ALIGNED HELP
          "Informe C¢digo do Embarque" NO-LABEL
     IMAGE-1 AT ROW 3.5 COL 37
     IMAGE-2 AT ROW 3.5 COL 51
     IMAGE-67 AT ROW 4.5 COL 37
     IMAGE-68 AT ROW 5.5 COL 37
     IMAGE-71 AT ROW 4.5 COL 51
     IMAGE-72 AT ROW 5.5 COL 51
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.96
         FONT 1.

DEFINE FRAME fPage4
     tgItensLi AT ROW 2 COL 5
     rsOrientacao AT ROW 2.25 COL 66 NO-LABEL
     tgEmbEncerrados AT ROW 2.75 COL 5
     rsSeleciona AT ROW 3.71 COL 15 NO-LABEL
     tgEnviaDoctoDespachante AT ROW 5.5 COL 17
     fiArquivoCopia AT ROW 6.5 COL 15 COLON-ALIGNED
     tgLayoutPadImp AT ROW 8.5 COL 17
     fiLayoutPadImp AT ROW 9.5 COL 15 COLON-ALIGNED
     btLayoutPadImp AT ROW 9.5 COL 66 HELP
          "Escolha do nome do arquivo"
     tgSobrepor AT ROW 11.5 COL 17
     fiDirDestino AT ROW 12.5 COL 15 COLON-ALIGNED
     btDirDestino AT ROW 12.5 COL 66 HELP
          "Escolha do nome do arquivo"
     "Seleciona por:" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 3.75 COL 5
     "ImpressÆo" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 1.25 COL 5
          FONT 1
     "Destino" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 11 COL 5
     "Layout Original" VIEW-AS TEXT
          SIZE 11 BY .54 AT ROW 8 COL 5
          FONT 1
     "Envio E-Mail" VIEW-AS TEXT
          SIZE 10 BY .67 AT ROW 5 COL 5
          FONT 1
     "Orienta‡Æo" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 1.25 COL 66
     RECT-11 AT ROW 5.25 COL 3
     RECT-12 AT ROW 8.25 COL 3
     RECT-13 AT ROW 11.25 COL 3
     RECT-15 AT ROW 1.5 COL 64
     RECT-17 AT ROW 1.5 COL 3
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.96
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configura‡Æo da impressora"
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 6 COL 2.86 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.75 COL 1 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5.25 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 2 COL 2.14
     RECT-9 AT ROW 5.5 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.21
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
/* SETTINGS FOR FILL-IN fiCodEstabelFim IN FRAME fPage2
   ALIGN-L LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE        */
/* SETTINGS FOR FILL-IN fiCodEstabelIni IN FRAME fPage2
   ALIGN-L LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE        */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR BUTTON btLayoutPadImp IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiLayoutPadImp IN FRAME fPage4
   NO-ENABLE                                                            */
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btDirDestino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDirDestino wReport
ON CHOOSE OF btDirDestino IN FRAME fPage4
DO:
    {utp/ut-liter.i Escolha_um_diret¢rio}
    RUN utp/ut-dir.p (INPUT RETURN-VALUE,
                      OUTPUT fiDirDestino,
                      OUTPUT l-ok). /* se cancelado = yes */
    IF NOT l-ok THEN
        DISP fiDirDestino WITH FRAME fPage4.

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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btLayoutPadImp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLayoutPadImp wReport
ON CHOOSE OF btLayoutPadImp IN FRAME fPage4
DO:
    {utp/ut-liter.i Escolha_um_diret¢rio}
    RUN utp/ut-dir.p (INPUT RETURN-VALUE,
                      OUTPUT fiLayoutPadImp,
                      OUTPUT l-ok). /* se cancelado = yes */
    IF NOT l-ok THEN
        DISP fiLayoutPadImp WITH FRAME fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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
   {report/rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME rsSeleciona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsSeleciona wReport
ON VALUE-CHANGED OF rsSeleciona IN FRAME fPage4
DO:
    IF INPUT FRAME fPage4 rsSeleciona = 1 THEN
        ASSIGN fiNrProcImpIni:SENSITIVE    IN FRAME fPage2 = YES
               fiNrProcImpFim:SENSITIVE    IN FRAME fPage2 = YES
               fiNrProcImpIni:SCREEN-VALUE IN FRAME fPage2 = ""
               fiNrProcImpFim:SCREEN-VALUE IN FRAME fPage2 = "ZZZZZZZZZZZZ"
               fiEmbarqueIni:SENSITIVE     IN FRAME fPage2 = NO
               fiEmbarqueFim:SENSITIVE     IN FRAME fPage2 = NO
               fiEmbarqueIni:SCREEN-VALUE  IN FRAME fPage2 = ""
               fiEmbarqueFim:SCREEN-VALUE  IN FRAME fPage2 = "".
               
    ELSE
        ASSIGN fiNrProcImpIni:SENSITIVE    IN FRAME fPage2 = NO
               fiNrProcImpFim:SENSITIVE    IN FRAME fPage2 = NO
               fiNrProcImpIni:SCREEN-VALUE IN FRAME fPage2 = ""
               fiNrProcImpFim:SCREEN-VALUE IN FRAME fPage2 = ""
               fiEmbarqueIni:SENSITIVE     IN FRAME fPage2 = YES
               fiEmbarqueFim:SENSITIVE     IN FRAME fPage2 = YES
               fiEmbarqueIni:SCREEN-VALUE  IN FRAME fPage2 = ""
               fiEmbarqueFim:SCREEN-VALUE  IN FRAME fPage2 = "ZZZZZZZZZZZZ".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tgLayoutPadImp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgLayoutPadImp wReport
ON VALUE-CHANGED OF tgLayoutPadImp IN FRAME fPage4 /* Utiliza Layout PadrÆo dos Parƒmetros de Importa‡Æo */
DO:
    IF  tgLayoutPadImp:CHECKED IN FRAME fPage4 THEN
        ASSIGN fiLayoutPadImp:SCREEN-VALUE IN FRAME fPage4 = ""
               fiLayoutPadImp:SENSITIVE    IN FRAME fPage4 = NO
               btLayoutPadImp:SENSITIVE    IN FRAME fPage4 = NO.
    ELSE
        ASSIGN fiLayoutPadImp:SENSITIVE    IN FRAME fPage4 = YES
               btLayoutPadImp:SENSITIVE    IN FRAME fPage4 = YES.

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
&IF "{&mguni_version}" >= "2.071" &THEN
    ASSIGN fiCodEstabelFim:SCREEN-VALUE IN FRAME fPage2 = "ZZZZZ".
&ELSE
    ASSIGN fiCodEstabelFim:SCREEN-VALUE IN FRAME fPage2 = "ZZZ".     
&ENDIF

    APPLY "VALUE-CHANGED" TO rsSeleciona    IN FRAME fPage4.
    APPLY "VALUE-CHANGED" TO tgLayoutPadImp IN FRAME fPage4.
    
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

    DO ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
        {report/rpexa.i}

        IF  INPUT FRAME fPage6 rsDestiny = 2 
        AND INPUT FRAME fPage6 rsExecution = 1 THEN DO:
            RUN utp/ut-vlarq.p (INPUT INPUT FRAME fPage6 cFile).

            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U, 
                                   INPUT 73, 
                                   INPUT "":U).
                APPLY "ENTRY":U TO cFile IN FRAME fPage6.
                RETURN ERROR.
            END.
        END.

        IF NOT tgLayoutPadImp:CHECKED IN FRAME fPage4 THEN DO:
            ASSIGN FILE-INFO:FILE-NAME = fiLayoutPadImp:SCREEN-VALUE IN FRAME fPage4.
            IF  FILE-INFO:PATHNAME = ? 
            OR  SEARCH(fiLayoutPadImp:SCREEN-VALUE IN FRAME fPage4) <> ? THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 4715,
                                   INPUT fiLayoutPadImp:SCREEN-VALUE IN FRAME fPage4).
                
                RUN setFolder IN hFolder (INPUT 2).
                APPLY "ENTRY" TO fiLayoutPadImp IN FRAME fPage4.
                RETURN NO-APPLY.
            END.
        END.

        ASSIGN FILE-INFO:FILE-NAME = fiDirDestino:SCREEN-VALUE IN FRAME fPage4.
        IF  FILE-INFO:PATHNAME = ? 
        OR  SEARCH(fiDirDestino:SCREEN-VALUE IN FRAME fPage4) <> ? THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 4715,
                               INPUT fiDirDestino:SCREEN-VALUE IN FRAME fPage4).
            
            RUN setFolder IN hFolder (INPUT 2).
            APPLY "ENTRY" TO fiDirDestino IN FRAME fPage4.
            RETURN NO-APPLY.
        END. 

        CREATE  tt-param.
        ASSIGN  tt-param.usuario                = c-seg-usuario
                tt-param.destino                = INPUT FRAME fPage6 rsDestiny
                tt-param.data-exec              = TODAY
                tt-param.hora-exec              = TIME
                tt-param.cCodEstabelIni         = INPUT FRAME fPage2 fiCodEstabelIni       
                tt-param.cCodEstabelFim         = INPUT FRAME fPage2 fiCodEstabelFim       
                tt-param.cNrProcImpIni          = INPUT FRAME fPage2 fiNrProcImpIni       
                tt-param.cNrProcImpFim          = INPUT FRAME fPage2 fiNrProcImpFim       
                tt-param.cEmbarqueIni           = INPUT FRAME fPage2 fiEmbarqueIni          
                tt-param.cEmbarqueFim           = INPUT FRAME fPage2 fiEmbarqueFim          
                tt-param.lItensLi               = INPUT FRAME fPage4 tgItensLi
                tt-param.lEmbEncerrados         = INPUT FRAME fPage4 tgEmbEncerrados
                tt-param.iSeleciona             = INPUT FRAME fPage4 rsSeleciona
                tt-param.iOrientacao            = INPUT FRAME fPage4 rsOrientacao            
                tt-param.lEnviaDoctoDespachante = INPUT FRAME fPage4 tgEnviaDoctoDespachante
                tt-param.cArquivoCopia          = INPUT FRAME fPage4 fiArquivoCopia         
                tt-param.lLayoutPadImp          = INPUT FRAME fPage4 tgLayoutPadImp
                tt-param.cLayoutPadImp          = INPUT FRAME fPage4 fiLayoutPadImp
                tt-param.lSobrepor              = INPUT FRAME fPage4 tgSobrepor              
                tt-param.cDirDestino            = INPUT FRAME fPage4 fiDirDestino           
                tt-param.indDocto               = 2.

        IF tt-param.destino = 1 THEN 
            ASSIGN tt-param.arquivo = "":U.
        ELSE 
            IF  tt-param.destino = 2 THEN 
                ASSIGN tt-param.arquivo = input frame fPage6 cFile.
            ELSE 
                ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.


        /*:T Executar do programa RP.P que ir  criar o relat¢rio */
        {report/rpexb.i}

        SESSION:SET-WAIT-STATE("GENERAL":U).

        {report/rprun.i imp/im0680rp.p}

        {report/rpexc.i}

        SESSION:SET-WAIT-STATE("":U).

        {report/rptrm.i}
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

