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
{include/i-prgvrs.i IM0663 2.00.00.009}  /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0663 MIM}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

{imp/im0663.i} /*definicao da temp-table tt-param*/

{include/boerrtab.i}


/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0663
&GLOBAL-DEFINE Version        2.00.00.009
&GLOBAL-DEFINE VersionLayout  1.00.000

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Sele‡Æo 2,Parƒmetro,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          YES
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page2Widgets      
&GLOBAL-DEFINE page4Widgets    
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution ~
                              lImprimeParametros

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page2Text           
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo

&GLOBAL-DEFINE page2Fields    cCodEstabelIni     cCodEstabelFim ~
                              cEmbarqueIni       cEmbarqueFim ~
                              cNomeFornecedorIni cNomeFornecedorFim ~
                              iPtoDesembarqueIni iPtoDesembarqueFim ~
                              cItemIni           cItemFim ~
                              cDescItemIni       cDescItemFim ~
                              dtDesembarqueIni   dtDesembarqueFim  
&GLOBAL-DEFINE page3Fields    cVeiculoIni        cVeiculoFin ~
                              dtEntradaIni       dtEntradaFin

&GLOBAL-DEFINE page4Fields    rsConsideraNacionalizacao
&GLOBAL-DEFINE page6Fields    cFile 

/* Parameters Definitions ----*/

def var raw-param        as raw no-undo.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.
def var hBoUn005           as handle  no-undo.

def var cMoCodigo          as char    no-undo.
def stream s-imp.

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

DEFINE VARIABLE cCodEstabelFim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cCodEstabelIni LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R7 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cDescItemFim AS CHARACTER FORMAT "X(36)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cDescItemIni AS CHARACTER FORMAT "X(36)" 
     LABEL "Descri‡Æo Item" 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cEmbarqueFim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 14.72 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cEmbarqueIni AS CHARACTER FORMAT "X(12)" 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cItemFim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cItemIni AS CHARACTER FORMAT "X(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cNomeFornecedorFim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cNomeFornecedorIni AS CHARACTER FORMAT "X(12)" 
     LABEL "Nome Fornec" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE DtDesembarqueFim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/2999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE DtDesembarqueIni AS DATE FORMAT "99/99/9999" INITIAL 01/01/1900 
     LABEL "Dt Nacionaliza‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE iPtoDesembarqueFim AS INTEGER FORMAT ">>,>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE iPtoDesembarqueIni AS INTEGER FORMAT ">>,>>9" INITIAL 0 
     LABEL "Pto Nacionaliza‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .88
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image~\im-fir":U
     SIZE 3 BY .96.

DEFINE IMAGE IMAGE-12
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE cVeiculoFin AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE cVeiculoIni AS CHARACTER FORMAT "X(12)":U 
     LABEL "Ve¡culo" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE dtEntradaFin AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE dtEntradaIni AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data de Entrada" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-21
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-opcao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Internos", 1,
"Fornecedor", 2
     SIZE 12 BY 2.5 NO-UNDO.

DEFINE VARIABLE rsConsideraNacionalizacao AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Nacionalizados", 1,
"NÆo Nacionalizados", 2,
"Todos", 3
     SIZE 18.43 BY 3.21 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42.86 BY 4.5.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43 BY 3.25.

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

DEFINE VARIABLE rs-colunas AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "80 Colunas", 1,
"132 Colunas", 2
     SIZE 24.57 BY .88 NO-UNDO.

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

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 2.79.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE lImprimeParametros AS LOGICAL INITIAL no 
     LABEL "Imprime Parƒmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.57 BY .83 NO-UNDO.


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

DEFINE FRAME fPage2
     cCodEstabelIni AT ROW 1.75 COL 13 COLON-ALIGNED
          LABEL "Estabelecimento":R7
          FONT 1
     cCodEstabelFim AT ROW 1.75 COL 52.29 COLON-ALIGNED NO-LABEL
          FONT 1
     cEmbarqueIni AT ROW 2.75 COL 13 COLON-ALIGNED
     cEmbarqueFim AT ROW 2.75 COL 52.29 COLON-ALIGNED NO-LABEL
     cNomeFornecedorIni AT ROW 3.75 COL 13 COLON-ALIGNED
     cNomeFornecedorFim AT ROW 3.75 COL 52.29 COLON-ALIGNED NO-LABEL
     iPtoDesembarqueIni AT ROW 4.75 COL 13 COLON-ALIGNED
     iPtoDesembarqueFim AT ROW 4.75 COL 52.29 COLON-ALIGNED NO-LABEL
     cItemIni AT ROW 5.75 COL 13 COLON-ALIGNED
     cItemFim AT ROW 5.75 COL 52.29 COLON-ALIGNED NO-LABEL
     cDescItemIni AT ROW 6.75 COL 13 COLON-ALIGNED
     cDescItemFim AT ROW 6.75 COL 52.29 COLON-ALIGNED NO-LABEL
     DtDesembarqueIni AT ROW 7.75 COL 13 COLON-ALIGNED
     DtDesembarqueFim AT ROW 7.75 COL 52.29 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 1.79 COL 47.43
     IMAGE-10 AT ROW 3.79 COL 50.86
     IMAGE-11 AT ROW 5.71 COL 47.43
     IMAGE-12 AT ROW 5.79 COL 50.86
     IMAGE-13 AT ROW 6.79 COL 47.43
     IMAGE-14 AT ROW 6.79 COL 50.86
     IMAGE-15 AT ROW 7.79 COL 47.43
     IMAGE-16 AT ROW 7.79 COL 50.86
     IMAGE-17 AT ROW 2.79 COL 47.43
     IMAGE-18 AT ROW 2.79 COL 50.86
     IMAGE-19 AT ROW 4.79 COL 47.57
     IMAGE-2 AT ROW 1.79 COL 50.86
     IMAGE-20 AT ROW 4.79 COL 51
     IMAGE-9 AT ROW 3.79 COL 47.43
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.29 ROW 2.79
         SIZE 85.72 BY 10.17
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btConfigImpr AT ROW 3.58 COL 43.29 HELP
          "Configura‡Æo da impressora"
     btFile AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     cFile AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.75 COL 3 HELP
          "Modo de Execu‡Æo" NO-LABEL
     lImprimeParametros AT ROW 7.83 COL 3.57
     rs-colunas AT ROW 9 COL 3.43 NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-10 AT ROW 7.46 COL 2.14
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.14 ROW 2.79
         SIZE 86.29 BY 10.17
         FONT 1.

DEFINE FRAME fPage4
     rsConsideraNacionalizacao AT ROW 2.54 COL 5.43 NO-LABEL
     rs-opcao AT ROW 7.5 COL 5.43 NO-LABEL
     " Considera Embarques" VIEW-AS TEXT
          SIZE 16.57 BY .54 AT ROW 1.79 COL 5.14
     " Imprime Unidade de Medida e Quantidade" VIEW-AS TEXT
          SIZE 30 BY .54 AT ROW 6.75 COL 5.14
     RECT-13 AT ROW 1.96 COL 3
     RECT-14 AT ROW 6.96 COL 3
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.14 ROW 2.79
         SIZE 86.43 BY 10.17
         FONT 1.

DEFINE FRAME fPage3
     cVeiculoIni AT ROW 2.5 COL 16 COLON-ALIGNED
     cVeiculoFin AT ROW 2.5 COL 44.29 COLON-ALIGNED NO-LABEL
     dtEntradaIni AT ROW 3.5 COL 16 COLON-ALIGNED
     dtEntradaFin AT ROW 3.5 COL 44.29 COLON-ALIGNED NO-LABEL
     IMAGE-21 AT ROW 2.5 COL 43
     IMAGE-22 AT ROW 2.5 COL 39.29
     IMAGE-23 AT ROW 3.5 COL 43
     IMAGE-24 AT ROW 3.5 COL 39.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.75
         SIZE 86 BY 10.25
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
         HEIGHT             = 16.96
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
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN cCodEstabelFim IN FRAME fPage2
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
/* SETTINGS FOR FILL-IN cCodEstabelIni IN FRAME fPage2
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FRAME fPage6
                                                                        */
/* SETTINGS FOR RADIO-SET rs-colunas IN FRAME fPage6
   NO-ENABLE                                                            */
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
        when "1" then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes.
        end.
        when "2" then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no.
        end.
        when "3" then do:
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


/*--- L¢gica para inicializa‡Æo do programam ---*/

{report/mainblock.i}

&IF "{&mguni_version}" >= "2.071" &THEN
    ASSIGN cCodEstabelFim = "ZZZZZ".
&ELSE
    ASSIGN cCodEstabelFim = "ZZZ".
&ENDIF

assign rs-colunas:screen-value in frame fPage6 = string(2).

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

FIND FIRST param-global NO-LOCK NO-ERROR.

&IF "{&bf_mat_versao_ems}" >= "2.062" &then
   IF NOT param-global.log-modul-eq THEN DO:
      RUN deleteFolder IN hFolder (INPUT 2).
      RUN SetFolder IN hFolder (INPUT 1).
   END.
&else
   RUN deleteFolder IN hFolder (INPUT 2).
   RUN SetFolder IN hFolder (INPUT 1).
&endif

assign rs-opcao:sensitive in frame fpage4 = true.

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

/*** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}

    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).

        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show", input 73, input "").
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.

    create tt-param.
    assign tt-param.usuario              = c-seg-usuario
           tt-param.destino              = input frame fPage6 rsDestiny
           tt-param.data-exec            = today
           tt-param.hora-exec            = time
           tt-param.cod-estabel-ini      = input frame fPage2 cCodEstabelIni
           tt-param.cod-estabel-fim      = input frame fPage2 cCodEstabelFim
           tt-param.embarque-ini         = input frame fPage2 cEmbarqueIni
           tt-param.embarque-fim         = input frame fPage2 cEmbarqueFim
           tt-param.nome-fornecedor-ini  = input frame fpage2 cNomeFornecedorIni
           tt-param.nome-fornecedor-fim  = input frame fpage2 cNomeFornecedorFim
           tt-param.pto-desembarque-ini  = input frame fPage2 iPtoDesembarqueIni
           tt-param.pto-desembarque-fim  = input frame fpage2 iPtoDesembarqueFim
           tt-param.it-codigo-ini        = input frame fpage2 cItemIni
           tt-param.it-codigo-fim        = input frame fpage2 cItemFim
           tt-param.desc-item-ini        = input frame fpage2 cDescItemIni
           tt-param.desc-item-fim        = input frame fpage2 cDescItemFim
           tt-param.data-desembarque-ini = input frame fPage2 dtDesembarqueIni
           tt-param.data-desembarque-fim = input frame fPage2 dtDesembarqueFim
           tt-param.i-considera-nacionalizacao = input frame fPage4 rsConsideraNacionalizacao
           tt-param.l-imprime-parametro  = input frame fPage6 lImprimeParametros
           tt-param.i-opcao              = input frame fPage4 rs-opcao.
           &if "{&bf_mat_versao_ems}" >= "2.062" &then
               ASSIGN
                   tt-param.veiculo-ini          = INPUT FRAME fPage3 cVeiculoIni
                   tt-param.veiculo-fim          = INPUT FRAME fPage3 cVeiculoFin
                   tt-param.data-entrada-ini     = INPUT FRAME fPage3 dtEntradaIni
                   tt-param.data-entrada-fim     = INPUT FRAME fPage3 dtEntradaFin.
           &endif


    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "".
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.

    /* Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */


    /* Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}

    SESSION:SET-WAIT-STATE("GENERAL":U).

    {report/rprun.i imp/im0663rp.p}

    {report/rpexc.i}

    SESSION:SET-WAIT-STATE("":U).

    {report/rptrm.i}
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

