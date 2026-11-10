&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i IM0401 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0401 MIM}
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
{include/boerrtab.i}

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0401
&GLOBAL-DEFINE Version        2.00.00.001

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

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2

&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution

&GLOBAL-DEFINE page6Text      text-destino text-modo

&GLOBAL-DEFINE page2Fields    c-cod-estabel-ini ~
                              c-cod-estabel-fim ~
                              c-embarque-ini ~
                              c-embarque-fim ~
                              c-di-siscomex-ini ~
                              c-di-siscomex-fim ~
                              dt-nacionalizacao-ini ~
                              dt-nacionalizacao-fim ~
                              i-emitente-ini ~
                              i-emitente-fim ~
                              c-serie-ini ~
                              c-serie-fim ~
                              c-docto-ini ~
                              c-docto-fim ~
                              c-nat-operacao-ini ~
                              c-nat-operacao-fim ~
                              dt-emis-ini ~
                              dt-emis-fim


&GLOBAL-DEFINE page4Fields  tg-somente-ce-atual ~
                            tg-detalha-nfc ~
                            tg-somente-nfc-ce-atual ~
                            tg-detalha-item ~
                            tg-despesas-item ~
                            tg-detalha-despesa ~
                            tg-detalha-duplicatas ~
                            tg-detalha-itinerario


&GLOBAL-DEFINE page6Fields  rsDestiny ~
                            cfile ~
                            btFile~
                            btConfigImpr ~
                            rsExecution ~
                            text-destino ~
                            text-modo ~
                            tg-imprime-param

/* Parameters Definitions ---                                           */

{imp/im0401.i} /* tt-param variaveis e buffers*/

/* Transfer Definitions */
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

DEFINE BUFFER b-tt-digita           FOR tt-digita.

DEFINE VARIABLE raw-param  AS RAW         NO-UNDO.

/* Variÿveis para execu‡Æo de zooms */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gr-simula-item AS ROWID  NO-UNDO.

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

DEFINE VARIABLE c-cod-estabel-fim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-di-siscomex-fim AS CHARACTER FORMAT "X(13)":U INITIAL "ZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-di-siscomex-ini AS CHARACTER FORMAT "X(13)":U 
     LABEL "DI SISCOMEX" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-docto-fim AS CHARACTER FORMAT "X(16)":U INITIAL "9999999999999999" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE c-docto-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE c-embarque-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-embarque-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-nat-operacao-fim AS CHARACTER FORMAT "X(6)":U INITIAL "999ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-nat-operacao-ini AS CHARACTER FORMAT "X(6)":U 
     LABEL "Nat Opera‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie-fim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE dt-emis-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE dt-emis-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data de EmissÆo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE dt-nacionalizacao-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE dt-nacionalizacao-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data de Nacionaliza‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE i-emitente-fim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-emitente-ini AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-31
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-32
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-33
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-34
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-35
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-36
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-37
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-38
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-39
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-40
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-43
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-44
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-49
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-50
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-51
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-52
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 3.5.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 3.63.

DEFINE VARIABLE tg-despesas-item AS LOGICAL INITIAL no 
     LABEL "Despesas dos Itens" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tg-detalha-despesa AS LOGICAL INITIAL no 
     LABEL "Despesas" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tg-detalha-duplicatas AS LOGICAL INITIAL no 
     LABEL "Duplicatas" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE tg-detalha-item AS LOGICAL INITIAL no 
     LABEL "Itens da Nota" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE VARIABLE tg-detalha-itinerario AS LOGICAL INITIAL no 
     LABEL "Detalhes do Itiner rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-detalha-nfc AS LOGICAL INITIAL no 
     LABEL "Detalha NF Complementar" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE VARIABLE tg-somente-ce-atual AS LOGICAL INITIAL no 
     LABEL "Considera somente Notas Fiscais Atualizadas no Estoque" 
     VIEW-AS TOGGLE-BOX
     SIZE 43 BY .83 NO-UNDO.

DEFINE VARIABLE tg-somente-nfc-ce-atual AS LOGICAL INITIAL no 
     LABEL "Considera Somente NF Complementar Atualizadas no Estoque" 
     VIEW-AS TOGGLE-BOX
     SIZE 47 BY .83 NO-UNDO.

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
     SIZE 30.72 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE tg-imprime-param AS LOGICAL INITIAL yes 
     LABEL "Imprimir P gina de Parƒmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage2
     c-cod-estabel-ini AT ROW 1.75 COL 18 COLON-ALIGNED
     c-cod-estabel-fim AT ROW 1.75 COL 50 COLON-ALIGNED NO-LABEL
     c-embarque-ini AT ROW 2.75 COL 18 COLON-ALIGNED
     c-embarque-fim AT ROW 2.75 COL 50 COLON-ALIGNED NO-LABEL
     c-di-siscomex-ini AT ROW 3.75 COL 18 COLON-ALIGNED
     c-di-siscomex-fim AT ROW 3.75 COL 50 COLON-ALIGNED NO-LABEL
     dt-nacionalizacao-ini AT ROW 4.75 COL 18 COLON-ALIGNED
     dt-nacionalizacao-fim AT ROW 4.75 COL 50 COLON-ALIGNED NO-LABEL
     i-emitente-ini AT ROW 5.75 COL 18 COLON-ALIGNED
     i-emitente-fim AT ROW 5.75 COL 50 COLON-ALIGNED NO-LABEL
     c-serie-ini AT ROW 6.75 COL 18 COLON-ALIGNED
     c-serie-fim AT ROW 6.75 COL 50 COLON-ALIGNED NO-LABEL
     c-docto-ini AT ROW 7.75 COL 18 COLON-ALIGNED
     c-docto-fim AT ROW 7.75 COL 50 COLON-ALIGNED NO-LABEL
     c-nat-operacao-ini AT ROW 8.75 COL 18 COLON-ALIGNED
     c-nat-operacao-fim AT ROW 8.75 COL 50 COLON-ALIGNED NO-LABEL
     dt-emis-ini AT ROW 9.75 COL 18 COLON-ALIGNED
     dt-emis-fim AT ROW 9.75 COL 50 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 1.75 COL 43
     IMAGE-2 AT ROW 1.75 COL 48
     IMAGE-31 AT ROW 2.75 COL 43
     IMAGE-32 AT ROW 2.75 COL 48
     IMAGE-33 AT ROW 4.75 COL 43
     IMAGE-34 AT ROW 4.75 COL 48
     IMAGE-35 AT ROW 5.75 COL 43
     IMAGE-36 AT ROW 5.75 COL 48
     IMAGE-37 AT ROW 6.75 COL 43
     IMAGE-38 AT ROW 6.75 COL 48
     IMAGE-39 AT ROW 7.75 COL 43
     IMAGE-40 AT ROW 7.75 COL 48
     IMAGE-43 AT ROW 9.75 COL 43
     IMAGE-44 AT ROW 9.75 COL 48
     IMAGE-49 AT ROW 8.75 COL 43
     IMAGE-50 AT ROW 8.75 COL 48
     IMAGE-51 AT ROW 3.75 COL 43
     IMAGE-52 AT ROW 3.75 COL 48
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 10.96
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
     rsExecution AT ROW 5.75 COL 3.29 HELP
          "Modo de Execu‡Æo" NO-LABEL
     tg-imprime-param AT ROW 8.5 COL 4
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.86 COLON-ALIGNED NO-LABEL
     "Parƒmetros de ImpressÆo" VIEW-AS TEXT
          SIZE 18 BY .54 AT ROW 7.33 COL 4
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
     RECT-8 AT ROW 7.58 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.71
         FONT 1.

DEFINE FRAME fPage4
     tg-detalha-despesa AT ROW 2.5 COL 10
     tg-detalha-item AT ROW 2.5 COL 42
     tg-detalha-duplicatas AT ROW 3.33 COL 10
     tg-despesas-item AT ROW 3.38 COL 44
     tg-detalha-itinerario AT ROW 4.21 COL 10
     tg-somente-ce-atual AT ROW 6.17 COL 10
     tg-detalha-nfc AT ROW 7.08 COL 10
     tg-somente-nfc-ce-atual AT ROW 8 COL 14
     "Imprime" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 1.75 COL 8
     RECT-11 AT ROW 2 COL 6
     RECT-12 AT ROW 5.63 COL 6.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.71
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
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.29
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
/* SETTINGS FOR FRAME fPage4
                                                                        */
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME tg-despesas-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-despesas-item wReport
ON VALUE-CHANGED OF tg-despesas-item IN FRAME fPage4 /* Despesas dos Itens */
DO:
    IF tg-detalha-item:CHECKED IN FRAME fPage4 THEN
        ASSIGN tg-despesas-item:SENSITIVE IN FRAME fPage4 = YES.
    ELSE
        ASSIGN tg-despesas-item:SENSITIVE IN FRAME fPage4 = NO
               tg-despesas-item:CHECKED   IN FRAME fpage4 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-detalha-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-detalha-item wReport
ON VALUE-CHANGED OF tg-detalha-item IN FRAME fPage4 /* Itens da Nota */
DO:
  IF tg-detalha-item:CHECKED IN FRAME fPage4 THEN
        ASSIGN tg-despesas-item:SENSITIVE IN FRAME fPage4 = YES.
    ELSE
        ASSIGN tg-despesas-item:SENSITIVE IN FRAME fPage4 = NO
               tg-despesas-item:CHECKED   IN FRAME fPage4 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-detalha-nfc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-detalha-nfc wReport
ON VALUE-CHANGED OF tg-detalha-nfc IN FRAME fPage4 /* Detalha NF Complementar */
DO:
  IF tg-detalha-nfc:CHECKED IN FRAME fpage4 THEN
      ASSIGN tg-somente-nfc-ce-atual:SENSITIVE IN FRAME fpage4 = YES.
  ELSE 
      ASSIGN tg-somente-nfc-ce-atual:SENSITIVE IN FRAME fpage4 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


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

    IF  VALID-HANDLE(h-boun005) THEN DO:
        DELETE PROCEDURE h-boun005.
        ASSIGN h-boun005 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterenablefields wReport 
PROCEDURE afterenablefields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DISABLE cFile      WITH FRAME fPage6.   
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterinitializeinterface wReport 
PROCEDURE afterinitializeinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN tg-somente-nfc-ce-atual:SENSITIVE  IN FRAME fPage4 = NO
           tg-despesas-item:SENSITIVE         IN FRAME fPage4 = NO.

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

    DEFINE VARIABLE r-tt-digita AS ROWID NO-UNDO.

    DO ON ERROR UNDO, RETURN ERROR ON STOP  UNDO, RETURN ERROR:
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

        CREATE tt-param.
        ASSIGN tt-param.usuario         = c-seg-usuario
               tt-param.destino         = input frame fPage6 rsDestiny
               tt-param.data-exec       = today
               tt-param.hora-exec       = time.

        IF tt-param.destino = 1 THEN 
            ASSIGN tt-param.arquivo = "":U.
        ELSE 
            IF tt-param.destino = 2 THEN 
                ASSIGN tt-param.arquivo = INPUT FRAME fPage6 cFile.
            ELSE 
                ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.

        ASSIGN tt-param.c-cod-estabel-ini      = INPUT FRAME fpage2 c-cod-estabel-ini
               tt-param.c-cod-estabel-fim      = INPUT FRAME fpage2 c-cod-estabel-fim
               tt-param.c-embarque-ini         = INPUT FRAME fpage2 c-embarque-ini
               tt-param.c-di-siscomex-ini      = INPUT FRAME fpage2 c-di-siscomex-ini
               tt-param.c-di-siscomex-fim      = INPUT FRAME fpage2 c-di-siscomex-fim
               tt-param.c-embarque-fim         = INPUT FRAME fpage2 c-embarque-fim
               tt-param.dt-nacionalizacao-ini  = date(INPUT FRAME fpage2 dt-nacionalizacao-ini)
               tt-param.dt-nacionalizacao-fim  = date(INPUT FRAME fpage2 dt-nacionalizacao-fim)
               tt-param.i-emitente-ini         = int(INPUT FRAME fpage2 i-emitente-ini)
               tt-param.i-emitente-fim         = int(INPUT FRAME fpage2 i-emitente-fim)
               tt-param.c-serie-ini            = INPUT FRAME fpage2 c-serie-ini
               tt-param.c-serie-fim            = INPUT FRAME fpage2 c-serie-fim
               tt-param.c-docto-ini            = INPUT FRAME fpage2 c-docto-ini
               tt-param.c-docto-fim            = INPUT FRAME fpage2 c-docto-fim
               tt-param.c-nat-operacao-ini     = INPUT FRAME fpage2 c-nat-operacao-ini
               tt-param.c-nat-operacao-fim     = INPUT FRAME fpage2 c-nat-operacao-fim
               tt-param.dt-emis-ini            = date(INPUT FRAME fpage2 dt-emis-ini)
               tt-param.dt-emis-fim            = date(INPUT FRAME fpage2 dt-emis-fim)
               tt-param.l-despesa              = IF tg-detalha-despesa:CHECKED      IN FRAME fPage4 THEN YES ELSE NO
               tt-param.l-duplicatas           = IF tg-detalha-duplicatas:CHECKED   IN FRAME fPage4 THEN YES ELSE NO
               tt-param.l-itinerario           = IF tg-detalha-itinerario:CHECKED   IN FRAME fPage4 THEN YES ELSE NO
               tt-param.l-item                 = IF tg-detalha-item:CHECKED         IN FRAME fPage4 THEN YES ELSE NO
               tt-param.l-despesas-item        = IF tg-despesas-item:CHECKED        IN FRAME fPage4 THEN YES ELSE NO
               tt-param.l-somente-ce-atual     = IF tg-somente-ce-atual:CHECKED     IN FRAME fpage4 THEN YES ELSE NO
               tt-param.l-detalha-nfc          = IF tg-detalha-nfc:CHECKED          IN FRAME fPage4 THEN YES ELSE NO
               tt-param.l-somente-nfc-ce-atual = IF tg-somente-nfc-ce-atual:CHECKED IN FRAME fPage4 THEN YES ELSE NO
               tt-param.l-imprime-param        = IF tg-imprime-param:CHECKED        IN FRAME fPage6 THEN YES ELSE NO.

        /*:T Executar do programa RP.P que ir  criar o relat¢rio */
        {report/rpexb.i}

        SESSION:SET-WAIT-STATE("GENERAL":U).

        {report/rprun.i imp/im0401rp.p}

        {report/rpexc.i}

        SESSION:SET-WAIT-STATE("":U).

        {report/rptrm.i}
    END.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

