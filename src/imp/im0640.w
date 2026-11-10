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
{include/i-prgvrs.i IM0640 2.00.00.012 } /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0640 MIM}
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

{include/i_dbvers.i} /*Include de PrÇ-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar validaá∆o produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
    {cdp/cdapi558.i1}
&endif
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0640
&GLOBAL-DEFINE Version        2.00.00.012
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o,Classificaá∆o,ParÉmetro,Impress∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          YES 
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

&GLOBAL-DEFINE page6Text      text-destino text-modo text-param 

&GLOBAL-DEFINE page2Fields    fi-cod-estabel-ini fi-cod-estabel-fim ~
                              fi-nr-proc-imp-ini fi-nr-proc-imp-fim ~
                              fi-fornecedor-ini  fi-fornecedor-fim ~
                              fi-dt-prevista-ini fi-dt-prevista-fim
&GLOBAL-DEFINE page3Fields    rsClassif
&GLOBAL-DEFINE page4Fields    tg-envia-docto-fornecedor fi-arquivo-copia ~
                              tg-layout-pad-fornec      fi-layout-pad-fornec bt-layout-pad-fornec ~
                              tg-sobrepor               fi-dir-destino       bt-dir-destino ~
                              rs-orientacao             tg-traducao
&GLOBAL-DEFINE page6Fields    cFile tg-imprime-param


/* Parameters Definitions ---                                           */
{imp/imapi009.i3}
{imp/im0640.i}


/*define buffer b-tt-digita for tt-digita.*/

DEFINE VARIABLE raw-param  AS RAW NO-UNDO.

DEFINE VARIABLE l-ok       AS LOGICAL   NO-UNDO.
/*DEFINE VARIABLE c-arq-digita       as char    no-undo.*/
DEFINE VARIABLE c-terminal   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-arq-layout AS CHARACTER NO-UNDO.      
DEFINE VARIABLE c-arq-temp   AS CHARACTER NO-UNDO.

DEFINE STREAM s-imp.

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

DEFINE VARIABLE fi-cod-estabel-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel-ini LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R7 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-dt-prevista-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-prevista-ini AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data Prevista Embarque" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-embarque-fim AS CHARACTER FORMAT "X(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-embarque-ini AS CHARACTER FORMAT "X(16)" 
     LABEL "Embarque":R10 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-fornecedor-fim AS INTEGER FORMAT ">>,>>>,>>9":U INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-fornecedor-ini AS INTEGER FORMAT ">>,>>>,>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-proc-imp-fim AS CHARACTER FORMAT "X(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-proc-imp-ini AS CHARACTER FORMAT "X(12)" 
     LABEL "Processo Importaá∆o":R23 
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

DEFINE IMAGE IMAGE-69
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-70
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-71
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-72
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-73
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-74
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rsClassif AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Processo", 1,
"Embarque", 2
     SIZE 17.86 BY 2
     FONT 1 NO-UNDO.

DEFINE BUTTON bt-dir-destino 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Escolha do nome do arquivo".

DEFINE BUTTON bt-layout-pad-fornec 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Escolha do nome do arquivo".

DEFINE VARIABLE fi-arquivo-copia AS CHARACTER FORMAT "X(100)":U 
     LABEL "Copia para" 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dir-destino AS CHARACTER FORMAT "X(60)":U 
     LABEL "Diret¢rio" 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE fi-layout-pad-fornec AS CHARACTER FORMAT "X(60)":U 
     LABEL "Layout Padr∆o" 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE rs-orientacao AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Retrato", 0,
"Paisagem", 1
     SIZE 12 BY 1.75 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59 BY 3.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59 BY 3.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59 BY 3.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 19 BY 6.71.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 19 BY 3.

DEFINE VARIABLE tg-envia-docto-Fornecedor AS LOGICAL INITIAL no 
     LABEL "Envia Docto para Fornecedor" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83
     FONT 1 NO-UNDO.

DEFINE VARIABLE tg-layout-pad-fornec AS LOGICAL INITIAL yes 
     LABEL "Utiliza Layout Padr∆o do Fornecedor" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .83
     FONT 1 NO-UNDO.

DEFINE VARIABLE tg-sobrepor AS LOGICAL INITIAL yes 
     LABEL "Sobrepor Arquivos j† Existentes?" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

DEFINE VARIABLE tg-traducao AS LOGICAL INITIAL no 
     LABEL "Traduzir Relat¢rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

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

DEFINE VARIABLE text-param AS CHARACTER FORMAT "X(256)":U INITIAL " ParÉmetros de Impress∆o" 
      VIEW-AS TEXT 
     SIZE 18 BY .63
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

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.14 BY 2.42.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.14 BY 2.83.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.14 BY 1.71.

DEFINE VARIABLE tg-imprime-param AS LOGICAL INITIAL no 
     LABEL "Imprime P†gina de ParÉmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .88 NO-UNDO.


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
     fi-cod-estabel-ini AT ROW 3.5 COL 13.14 HELP
          ""
          LABEL "Estabelecimento":R7
          FONT 1
     fi-cod-estabel-fim AT ROW 3.5 COL 55 
 NO-LABEL
          FONT 1
     fi-nr-proc-imp-ini AT ROW 4.5 COL 17 COLON-ALIGNED
     fi-nr-proc-imp-fim AT ROW 4.5 COL 53 COLON-ALIGNED NO-LABEL
     fi-embarque-ini AT ROW 5.5 COL 17 COLON-ALIGNED HELP
          "Informe C¢digo do Embarque"
     fi-embarque-fim AT ROW 5.5 COL 53 COLON-ALIGNED HELP
          "Informe C¢digo do Embarque" NO-LABEL
     fi-fornecedor-ini AT ROW 6.5 COL 17 COLON-ALIGNED
     fi-fornecedor-fim AT ROW 6.5 COL 53 COLON-ALIGNED NO-LABEL
     fi-dt-prevista-ini AT ROW 7.5 COL 17 COLON-ALIGNED
     fi-dt-prevista-fim AT ROW 7.5 COL 53 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 3.5 COL 37
     IMAGE-2 AT ROW 3.5 COL 51
     IMAGE-67 AT ROW 4.5 COL 37
     IMAGE-68 AT ROW 5.5 COL 37
     IMAGE-69 AT ROW 6.5 COL 37
     IMAGE-70 AT ROW 7.5 COL 37
     IMAGE-71 AT ROW 4.5 COL 51
     IMAGE-72 AT ROW 5.5 COL 51
     IMAGE-73 AT ROW 6.5 COL 51
     IMAGE-74 AT ROW 7.5 COL 51
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.21
         FONT 1.

DEFINE FRAME fPage3
     rsClassif AT ROW 2.25 COL 7 HELP
          "Classificaá∆o para emiss∆o do relat¢rio" NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.21
         FONT 1.

DEFINE FRAME fPage4
     tg-envia-docto-Fornecedor AT ROW 2.5 COL 15
     fi-arquivo-copia AT ROW 3.75 COL 13 COLON-ALIGNED
     rs-orientacao AT ROW 4.5 COL 66 NO-LABEL
     tg-layout-pad-fornec AT ROW 6.25 COL 15
     fi-layout-pad-fornec AT ROW 7.5 COL 13 COLON-ALIGNED
     bt-layout-pad-fornec AT ROW 7.5 COL 57 HELP
          "Escolha do nome do arquivo"
     tg-sobrepor AT ROW 10 COL 15
     tg-traducao AT ROW 10.5 COL 66
     fi-dir-destino AT ROW 11.25 COL 13 COLON-ALIGNED
     bt-dir-destino AT ROW 11.25 COL 57 HELP
          "Escolha do nome do arquivo"
     "Destino" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 9.25 COL 5
     "Layout" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 5.5 COL 5
          FONT 1
     "Orientaá∆o" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.75 COL 66
     "Traduá∆o" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 9.25 COL 66
     "Envio E-Mail" VIEW-AS TEXT
          SIZE 11 BY .67 AT ROW 1.75 COL 5
          FONT 1
     RECT-11 AT ROW 2.04 COL 3
     RECT-12 AT ROW 5.75 COL 3
     RECT-13 AT ROW 9.5 COL 3
     RECT-15 AT ROW 2.04 COL 64
     RECT-16 AT ROW 9.5 COL 64
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.21
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
     rsExecution AT ROW 6 COL 2.86 HELP
          "Modo de Execuá∆o" NO-LABEL
     tg-imprime-param AT ROW 8.75 COL 3
     text-destino AT ROW 1.75 COL 1 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5.25 COL 1.14 COLON-ALIGNED NO-LABEL
     text-param AT ROW 7.75 COL 1 COLON-ALIGNED NO-LABEL
     RECT-10 AT ROW 8 COL 2
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
         MAX-HEIGHT         = 38.08
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.08
         VIRTUAL-WIDTH      = 182.86
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
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN fi-cod-estabel-fim IN FRAME fPage2
   ALIGN-L LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE        */
/* SETTINGS FOR FILL-IN fi-cod-estabel-ini IN FRAME fPage2
   ALIGN-L LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE        */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR BUTTON bt-layout-pad-fornec IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-layout-pad-fornec IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage6
                                                                        */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execuá∆o".

ASSIGN 
       text-param:PRIVATE-DATA IN FRAME fPage6     = 
                "ParÉmetros de Impress∆o".

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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME bt-dir-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-dir-destino wReport
ON CHOOSE OF bt-dir-destino IN FRAME fPage4
DO:
    {utp/ut-liter.i Escolha_um_diret¢rio}
    RUN utp/ut-dir.p (INPUT RETURN-VALUE,
                      OUTPUT fi-dir-destino,
                      OUTPUT l-ok). /* se cancelado = yes */
    IF NOT l-ok THEN
        DISP fi-dir-destino WITH FRAME fPage4.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-layout-pad-fornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-layout-pad-fornec wReport
ON CHOOSE OF bt-layout-pad-fornec IN FRAME fPage4
DO:
    {utp/ut-liter.i Escolha_um_diret¢rio}
    RUN utp/ut-dir.p (INPUT RETURN-VALUE,
                      OUTPUT fi-layout-pad-fornec,
                      OUTPUT l-ok). /* se cancelado = yes */
    IF NOT l-ok THEN
        DISP fi-layout-pad-fornec WITH FRAME fPage4.
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


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME rsClassif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsClassif wReport
ON VALUE-CHANGED OF rsClassif IN FRAME fPage3
DO:
    IF INPUT FRAME fPage3 rsClassif = 1 THEN
        ASSIGN fi-embarque-ini:SCREEN-VALUE IN FRAME fPage2 = ""
               fi-embarque-fim:SCREEN-VALUE IN FRAME fPage2 = ""
               fi-embarque-ini:SENSITIVE IN FRAME fPage2 = NO
               fi-embarque-fim:SENSITIVE IN FRAME fPage2 = NO.
    ELSE
        ASSIGN fi-embarque-ini:SENSITIVE IN FRAME fPage2 = YES
               fi-embarque-fim:SENSITIVE IN FRAME fPage2 = YES
               fi-embarque-fim:SCREEN-VALUE IN FRAME fPage2 = "ZZZZZZZZZZZZZZZZ".

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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME tg-layout-pad-fornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-layout-pad-fornec wReport
ON VALUE-CHANGED OF tg-layout-pad-fornec IN FRAME fPage4 /* Utiliza Layout Padr∆o do Fornecedor */
DO:
    IF  tg-layout-pad-fornec:CHECKED IN FRAME fPage4 THEN
        ASSIGN fi-layout-pad-fornec:SCREEN-VALUE IN FRAME fPage4 = ""
               fi-layout-pad-fornec:SENSITIVE    IN FRAME fPage4 = NO
               bt-layout-pad-fornec:SENSITIVE   IN FRAME fPage4 = NO.
    ELSE
        ASSIGN fi-layout-pad-fornec:SENSITIVE    IN FRAME fPage4 = YES
               bt-layout-pad-fornec:SENSITIVE   IN FRAME fPage4 = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
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
    APPLY "VALUE-CHANGED" TO tg-layout-pad-fornec IN FRAME fPage4.

    {utp/ut-liter.i Estabelecimento * R}
    assign fi-cod-estabel-ini:LABEL IN FRAME fPage2 = TRIM(RETURN-VALUE).

    &IF "{&mguni_version}" >= "2.071" &THEN
        ASSIGN fi-cod-estabel-fim:SCREEN-VALUE IN FRAME fPage2 = "ZZZZZ".
    &ELSE
        ASSIGN fi-cod-estabel-fim:SCREEN-VALUE IN FRAME fPage2 = "ZZZ".
    &ENDIF


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

        /*15/02/2005 - tech1007 - Teste alterado pois RTF n∆o Ç mais opá∆o de Destino*/
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

        IF  NOT tg-layout-pad-fornec:CHECKED IN FRAME fPage4 THEN DO:

            ASSIGN FILE-INFO:FILE-NAME = INPUT FRAME fPage4 fi-layout-pad-fornec.

           IF  FILE-INFO:PATHNAME = ? 
           OR  SEARCH(INPUT FRAME fPage4 fi-layout-pad-fornec) <> ? THEN DO:

                RUN utp/ut-msgs.p (INPUT "show",                                  
                                   INPUT 4715,                                    
                                   INPUT INPUT FRAME fPage4 fi-layout-pad-fornec).                                     
                RUN SetFolder IN hFolder (INPUT 3).
                APPLY "ENTRY":U TO fi-layout-pad-fornec IN FRAME fPage4.         
                RETURN ERROR.                                                     
            END.                                                                  
        END.

        ASSIGN FILE-INFO:FILE-NAME = INPUT FRAME fPage4 fi-dir-destino.

        IF  FILE-INFO:PATHNAME = ? 
        OR  SEARCH(INPUT FRAME fPage4 fi-dir-destino) <> ? THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",                                  
                               INPUT 4715,                                    
                               INPUT INPUT FRAME fPage4 fi-dir-destino).
            RUN SetFolder IN hFolder (INPUT 3).
            APPLY "ENTRY":U TO fi-dir-destino IN FRAME fPage4.
            RETURN ERROR.                                                     
        END.                                                                  

        /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
           para o programa RP.P */

        CREATE tt-param.
        ASSIGN tt-param.usuario                  = c-seg-usuario
               tt-param.destino                  = INPUT FRAME fPage6 rsDestiny
               tt-param.data-exec                = TODAY
               tt-param.hora-exec                = TIME
               tt-param.classifica               = INPUT FRAME fPage3 rsClassif
               tt-param.desc-classifica          = ENTRY((tt-param.classifica - 1) * 2 + 1, 
                                                          rsClassif:RADIO-BUTTONS IN FRAME fPage3)
               tt-param.c-cod-estabel-ini        = INPUT FRAME fPage2 fi-cod-estabel-ini       
               tt-param.c-cod-estabel-fim        = INPUT FRAME fPage2 fi-cod-estabel-fim       
               tt-param.c-nr-proc-imp-ini        = INPUT FRAME fPage2 fi-nr-proc-imp-ini       
               tt-param.c-nr-proc-imp-fim        = INPUT FRAME fPage2 fi-nr-proc-imp-fim       
               tt-param.c-embarque-ini           = INPUT FRAME fPage2 fi-embarque-ini          
               tt-param.c-embarque-fim           = INPUT FRAME fPage2 fi-embarque-fim          
               tt-param.i-fornecedor-ini         = INPUT FRAME fPage2 fi-fornecedor-ini        
               tt-param.i-fornecedor-fim         = INPUT FRAME fPage2 fi-fornecedor-fim        
               tt-param.dt-prevista-ini          = INPUT FRAME fPage2 fi-dt-prevista-ini         
               tt-param.dt-prevista-fim          = INPUT FRAME fPage2 fi-dt-prevista-fim         
               tt-param.l-envia-docto-fornecedor = INPUT FRAME fPage4 tg-envia-docto-fornecedor
               tt-param.c-arquivo-copia          = INPUT FRAME fPage4 fi-arquivo-copia         
               tt-param.l-layout-pad-fornec      = INPUT FRAME fPage4 tg-layout-pad-fornec     
               tt-param.c-layout-pad-fornec      = INPUT FRAME fPage4 fi-layout-pad-fornec     
               tt-param.l-sobrepor               = INPUT FRAME fPage4 tg-sobrepor              
               tt-param.c-dir-destino            = INPUT FRAME fPage4 fi-dir-destino           
               tt-param.i-orientacao             = INPUT FRAME fPage4 rs-orientacao            
               tt-param.l-traducao               = INPUT FRAME fPage4 tg-traducao              
               tt-param.l-imprime-param          = INPUT FRAME fPage6 tg-imprime-param.         


        IF tt-param.destino = 1 THEN 
            ASSIGN tt-param.arquivo = "":U.
        ELSE 
            IF  tt-param.destino = 2 THEN 
                ASSIGN tt-param.arquivo = input frame fPage6 cFile.
            ELSE 
                ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.


        /*:T Executar do programa RP.P que ir† criar o relat¢rio */
        {report/rpexb.i}

        SESSION:SET-WAIT-STATE("GENERAL":U).

        {report/rprun.i imp/im0640rp.p}

        {report/rpexc.i}

        SESSION:SET-WAIT-STATE("":U).

        {report/rptrm.i}
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

