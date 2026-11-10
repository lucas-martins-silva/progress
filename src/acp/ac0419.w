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
{include/i-prgvrs.i AC0419 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac0419 MAC}
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

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AC0419
&GLOBAL-DEFINE Version        2.00.00.004
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

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   l-imp-resumo ~
                              rs-classif ~
                              text-leitura
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
&GLOBAL-DEFINE page2Fields    c-estabelec-fim ~
                              c-estabelec-ini ~
                              c-item-fim ~
                              c-item-ini ~
                              c-prod-fim ~
                              c-prod-ini ~
                              c-nota-fim ~
                              c-nota-ini ~
                              c-representante-fim ~
                              c-representante-ini ~
                              c-serie-fim ~
                              c-serie-ini ~
                              d-data-nota-fim ~
                              d-data-nota-ini
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields     
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */

 {acp/ac0419.i} /*Defini‡Æo da temp-table tt-param*/

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

DEFINE VARIABLE c-estabelec-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-estabelec-ini LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-item-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-nota-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-nota-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Nota Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-prod-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-prod-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Produto" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-representante-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-representante-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Representante" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie-fim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE d-data-nota-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE d-data-nota-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt Emiss Nota" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE text-leitura AS CHARACTER FORMAT "X(256)":U INITIAL "Formas de Leitura" 
      VIEW-AS TEXT 
     SIZE 14 BY .67
     FONT 1 NO-UNDO.

DEFINE VARIABLE rs-classif AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Item", 1,
"Produto", 2,
"Ambos", 3
     SIZE 22 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 72 BY 2.42.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 72 BY 4.5.

DEFINE VARIABLE l-imp-resumo AS LOGICAL INITIAL no 
     LABEL "Imprime Resumo" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY 1.08
     FONT 1 NO-UNDO.

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

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL "Destino" 
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
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage2
     c-estabelec-ini AT ROW 2.92 COL 16.72 COLON-ALIGNED
          FONT 1
     c-estabelec-fim AT ROW 2.92 COL 53 COLON-ALIGNED NO-LABEL
          FONT 1
     c-serie-ini AT ROW 3.92 COL 16.72 COLON-ALIGNED
     c-serie-fim AT ROW 3.92 COL 53 COLON-ALIGNED NO-LABEL
     c-nota-ini AT ROW 4.92 COL 16.72 COLON-ALIGNED
     c-nota-fim AT ROW 4.92 COL 53 COLON-ALIGNED NO-LABEL
     d-data-nota-ini AT ROW 5.92 COL 16.72 COLON-ALIGNED
     d-data-nota-fim AT ROW 5.92 COL 53 COLON-ALIGNED NO-LABEL
     c-item-ini AT ROW 6.92 COL 16.72 COLON-ALIGNED
     c-item-fim AT ROW 6.92 COL 53 COLON-ALIGNED NO-LABEL
     c-prod-ini AT ROW 7.92 COL 16.72 COLON-ALIGNED
     c-prod-fim AT ROW 7.92 COL 53 COLON-ALIGNED NO-LABEL
     c-representante-ini AT ROW 8.92 COL 16.72 COLON-ALIGNED
     c-representante-fim AT ROW 8.92 COL 53 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 2.92 COL 36.72
     IMAGE-10 AT ROW 8.92 COL 52.14
     IMAGE-11 AT ROW 5.92 COL 52.14
     IMAGE-12 AT ROW 6.92 COL 52.14
     IMAGE-13 AT ROW 4.92 COL 52.14
     IMAGE-14 AT ROW 3.92 COL 52.14
     IMAGE-17 AT ROW 7.92 COL 52.14
     IMAGE-18 AT ROW 7.92 COL 36.72
     IMAGE-2 AT ROW 2.92 COL 52.14
     IMAGE-5 AT ROW 8.92 COL 36.72
     IMAGE-6 AT ROW 6.92 COL 36.72
     IMAGE-7 AT ROW 5.92 COL 36.72
     IMAGE-8 AT ROW 3.92 COL 36.72
     IMAGE-9 AT ROW 4.92 COL 36.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 10.46
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
     text-destino AT ROW 1.63 COL 1 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.81
         SIZE 76.86 BY 10.15
         FONT 1.

DEFINE FRAME fPage4
     l-imp-resumo AT ROW 3.25 COL 30
     rs-classif AT ROW 6 COL 30 NO-LABEL
     text-leitura AT ROW 5 COL 2 COLON-ALIGNED NO-LABEL
     RECT-13 AT ROW 2.5 COL 3
     RECT-14 AT ROW 5.25 COL 3
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.81
         SIZE 76.86 BY 10.15
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
/* SETTINGS FOR FILL-IN c-estabelec-fim IN FRAME fPage2
   LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                          */
/* SETTINGS FOR FILL-IN c-estabelec-ini IN FRAME fPage2
   LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                          */
/* SETTINGS FOR FRAME fPage4
                                                                        */
ASSIGN 
       text-leitura:PRIVATE-DATA IN FRAME fPage4     = 
                "Formas de Leitura".

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
     _Options          = "no-LOCK KEEP-EMPTY"
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
&Scoped-define SELF-NAME rs-classif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-classif wReport
ON VALUE-CHANGED OF rs-classif IN FRAME fPage4
DO:
        case self:screen-value:
            when "1":U then do: /* Item */
                assign 
                       c-item-ini:screen-value in frame fPage2 = "" 
                       c-item-fim:screen-value in frame fPage2 = "ZZZZZZZZZZZZZZZZ"
                       c-prod-ini:screen-value in frame fPage2 = "" 
                       c-prod-fim:screen-value in frame fPage2 = "ZZZZZZZZZZZZZZZZ"
                       c-item-ini:sensitive in frame fPage2 = yes
                       c-item-fim:sensitive in frame fPage2 = yes
                       c-prod-ini:sensitive in frame fPage2 = no
                       c-prod-fim:sensitive in frame fPage2 = no.
                run setFolder in hFolder(INPUT 1).                            
                apply "ENTRY":U to c-item-ini in frame fPage2.
            end.
            when "2":U then do: /* Produto */
                assign 
                       c-item-ini:screen-value in frame fPage2 = "" 
                       c-item-fim:screen-value in frame fPage2 = "ZZZZZZZZZZZZZZZZ"
                       c-prod-ini:screen-value in frame fPage2 = "" 
                       c-prod-fim:screen-value in frame fPage2 = "ZZZZZZZZZZZZZZZZ"
                       c-item-ini:sensitive in frame fPage2 = no
                       c-item-fim:sensitive in frame fPage2 = no
                       c-prod-ini:sensitive in frame fPage2 = yes
                       c-prod-fim:sensitive in frame fPage2 = yes.
                run setFolder in hFolder(INPUT 1).            
                apply "ENTRY":U to c-prod-ini in frame fPage2.

            end.
            when "3":U then do: /* Ambos */
                assign 
                       c-item-ini:screen-value in frame fPage2 = "" 
                       c-item-fim:screen-value in frame fPage2 = "ZZZZZZZZZZZZZZZZ"
                       c-prod-ini:screen-value in frame fPage2 = "" 
                       c-prod-fim:screen-value in frame fPage2 = "ZZZZZZZZZZZZZZZZ"
                       c-item-ini:sensitive in frame fPage2 = yes
                       c-item-fim:sensitive in frame fPage2 = yes
                       c-prod-ini:sensitive in frame fPage2 = yes
                       c-prod-fim:sensitive in frame fPage2 = yes.
                run setFolder in hFolder(INPUT 1).            
                apply "ENTRY":U to c-item-ini in frame fPage2.

            end.
        end case.
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

/*Valores iniciais das datas inicial e final da nota */

ASSIGN d-data-nota-ini = date(01, 01, year(today)).
ASSIGN d-data-nota-fim = TODAY.

IF CAN-FIND(FIRST est-prod-coml) THEN
   ASSIGN rs-classif = 2.  /* Por Produto */        
ELSE
   ASSIGN rs-classif = 1.  /* Por Item */        

DISP d-data-nota-ini 
     d-data-nota-fim WITH FRAME fpage2.

&IF "{&mguni_version}" >= "2.071" &THEN
ASSIGN c-estabelec-fim:SCREEN-VALUE IN FRAME fPage2 = "ZZZZZ".
&ELSE
ASSIGN c-estabelec-fim:SCREEN-VALUE IN FRAME fPage2 = "ZZZ".
&ENDIF

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
       IF CAN-FIND(FIRST produto-coml) THEN
           ASSIGN c-item-ini:sensitive in frame fPage2 = no
                  c-item-fim:sensitive in frame fPage2 = no
                  c-prod-ini:sensitive in frame fPage2 = yes
                  c-prod-fim:sensitive in frame fPage2 = yes.
       ELSE
           ASSIGN c-item-ini:sensitive in frame fPage2 = yes
                  c-item-fim:sensitive in frame fPage2 = yes
                  c-prod-ini:sensitive in frame fPage2 = no
                  c-prod-fim:sensitive in frame fPage2 = no.



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

    for each tt-digita no-lock:
        assign r-tt-digita = rowid(tt-digita).

        /*:T Valida‡Æo de duplicidade de registro na temp-table tt-digita */
        /*find first b-tt-digita 
            where b-tt-digita.ordem = tt-digita.ordem 
              and rowid(b-tt-digita) <> rowid(tt-digita) 
            no-lock no-error.
        if  avail b-tt-digita then do:
            reposition brDigita to rowid rowid(b-tt-digita).

            run utp/ut-msgs.p (input "SHOW":U, input 108, input "":U).
            apply "ENTRY":U to tt-digita.ordem in browse brDigita.

            return error.
        end.*/

        /*:T As demais valida‡äes devem ser feitas aqui */
        /*if  tt-digita.ordem <= 0 then do:
            assign browse brDigita:CURRENT-COLUMN = tt-digita.ordem:HANDLE in browse brDigita.

            reposition brDigita to rowid r-tt-digita.

            run utp/ut-msgs.p (input "SHOW":U, input 99999, input "":U).
            apply "ENTRY":U to tt-digita.ordem in browse brDigita.

            return error.
        end.*/

    end.


    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */



    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */

    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.classificacao   = input frame fPage4 rs-classif
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

    ASSIGN  tt-param.cod-estabel-ini  = INPUT FRAME fPage2 c-estabelec-ini 
            tt-param.cod-estabel-fim  = INPUT FRAME fPage2 c-estabelec-fim          
            tt-param.serie-ini        = INPUT FRAME fPage2 c-serie-ini
            tt-param.serie-fim        = INPUT FRAME fPage2 c-serie-fim
            tt-param.nr-nota-fis-ini  = INPUT FRAME fPage2 c-nota-ini
            tt-param.nr-nota-fis-fim  = INPUT FRAME fPage2 c-nota-fim
            tt-param.dt-emis-nota-ini = INPUT FRAME fPage2 d-data-nota-ini 
            tt-param.dt-emis-nota-fim = INPUT FRAME fPage2 d-data-nota-fim
            tt-param.it-codigo-ini    = INPUT FRAME fPage2 c-item-ini
            tt-param.it-codigo-fim    = INPUT FRAME fPage2 c-item-fim
            tt-param.it-prod-ini      = INPUT FRAME fPage2 c-prod-ini
            tt-param.it-prod-fim      = INPUT FRAME fPage2 c-prod-fim
            tt-param.no-ab-reppri-ini = INPUT FRAME fPage2 c-representante-ini
            tt-param.no-ab-reppri-fim = INPUT FRAME fPage2 c-representante-fim
            tt-param.classificacao    = INPUT FRAME fPage4 rs-classif
            tt-param.imp-resumo       = INPUT FRAME fPage4 l-imp-resumo.

    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}

    SESSION:SET-WAIT-STATE("GENERAL":U).

    {report/rprun.i acp/ac0419rp.p}

    {report/rpexc.i}

    SESSION:SET-WAIT-STATE("":U).

    {report/rptrm.i}
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

