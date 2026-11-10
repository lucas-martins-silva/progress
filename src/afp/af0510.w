&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
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
{include/i-prgvrs.i AF0510 2.00.00.001 } /*** 010001 ***/
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
&GLOBAL-DEFINE Program        AF0510
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o,ParÉmetro,Impress∆o


&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGIMP          YES


&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page2Widgets   i-nr-versao-ini i-nr-versao-fim ~
                              c-descricao-ini c-descricao-fim ~
                              c-familia-ini c-familia-fim ~
                              c-item-ini c-item-fim ~
                              c-estabelecimento-ini c-estabelecimento-fim ~
                              i-fornecedor-ini i-fornecedor-fim ~
                              c-grp-avaliacao-ini c-grp-avaliacao-fim

&GLOBAL-DEFINE page4Widgets   r-ativa-desativa ~
                              l-familia-fornecedor ~
                              l-item-fornecedor ~
                              l-item-estabelecimento ~
                              l-grupo ~
                              l-ativa-desativa

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

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile

/* Parameters Definitions ---                                           */

{afp/af0510.i} /*  temp table */
{utp/ut-glob.i} 

/* Transfer Definitions */

def var raw-param        as raw no-undo.

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
&Scoped-Define ENABLED-OBJECTS btOK btCancel btHelp2 rtToolBar 

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
     SIZE 87 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE c-descricao-fim AS CHARACTER FORMAT "x(40)" INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-ini LIKE af-versao-avaliacao.desc-versao
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE c-estabelecimento-fim AS CHARACTER FORMAT "X(5)" INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-estabelecimento-ini LIKE af-item-contr-estab.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-familia-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE c-familia-ini LIKE af-familia-contr.fm-codigo
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE c-grp-avaliacao-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE c-grp-avaliacao-ini LIKE af-grp-avaliacao.cod-grp-avaliacao
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-ini LIKE af-item-contr.it-codigo
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE i-fornecedor-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE i-fornecedor-ini LIKE af-item-contr.cod-emitente
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-versao-fim AS INTEGER FORMAT ">>>>9" INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-versao-ini LIKE af-versao-avaliacao.nr-versao
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-65
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-67
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-69
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-72
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-74
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-79
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-83
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-84
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-85
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-86
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-87
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-88
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-89
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-90
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE r-ativa-desativa AS LOGICAL 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Ativa", yes,
"Desativa", no
     SIZE 18 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 5.33.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 1.75.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 1.75.

DEFINE VARIABLE l-ativa-desativa AS LOGICAL INITIAL yes 
     LABEL "Simula ativaá∆o/desativaá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 32.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-familia-fornecedor AS LOGICAL INITIAL no 
     LABEL "Fam°lia Avaliaá∆o Fornecedores" 
     VIEW-AS TOGGLE-BOX
     SIZE 35.57 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-grupo AS LOGICAL INITIAL no 
     LABEL "Grupo de Avaliaá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 56.57 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-item-estabelecimento AS LOGICAL INITIAL no 
     LABEL "Item x Estabelecimento Avaliaá∆o Fornecedores" 
     VIEW-AS TOGGLE-BOX
     SIZE 68.57 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-item-fornecedor AS LOGICAL INITIAL no 
     LABEL "Item Avaliaá∆o Fornecedores" 
     VIEW-AS TOGGLE-BOX
     SIZE 31.57 BY 1.08
     FONT 1 NO-UNDO.

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
     btHelp2 AT ROW 16.75 COL 76
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87.57 BY 17
         FONT 1.

DEFINE FRAME fPage2
     i-nr-versao-ini AT ROW 3.5 COL 29.86 COLON-ALIGNED HELP
          "N£mero da Vers∆o"
     i-nr-versao-fim AT ROW 3.5 COL 45 COLON-ALIGNED HELP
          "N£mero da vers∆o" NO-LABEL
     c-descricao-ini AT ROW 4.5 COL 8.86 COLON-ALIGNED HELP
          "Descriá∆o da Vers∆o"
     c-descricao-fim AT ROW 4.5 COL 45 COLON-ALIGNED HELP
          "Descriá∆o da Vers∆o" NO-LABEL
     c-familia-ini AT ROW 5.5 COL 26.86 COLON-ALIGNED HELP
          "C¢digo da fam°lia do material"
     c-familia-fim AT ROW 5.5 COL 45 COLON-ALIGNED HELP
          "C¢digo da fam°lia do material" NO-LABEL
     c-item-ini AT ROW 6.5 COL 18.86 COLON-ALIGNED HELP
          "C¢digo do Item"
     c-item-fim AT ROW 6.5 COL 45 COLON-ALIGNED HELP
          "C¢digo do Item" NO-LABEL
     c-estabelecimento-ini AT ROW 7.5 COL 29.86 COLON-ALIGNED HELP
          "C¢digo do estabelecimento"
     c-estabelecimento-fim AT ROW 7.5 COL 45 COLON-ALIGNED HELP
          "C¢digo do estabelecimento" NO-LABEL
     i-fornecedor-ini AT ROW 8.5 COL 26.86 COLON-ALIGNED HELP
          "C¢digo do fornecedor"
          LABEL "Fornecedor"
     i-fornecedor-fim AT ROW 8.5 COL 45 COLON-ALIGNED HELP
          "C¢digo do fornecedor" NO-LABEL
     c-grp-avaliacao-ini AT ROW 9.5 COL 26.86 COLON-ALIGNED HELP
          "C¢digo do grupo de avaliaá∆o"
     c-grp-avaliacao-fim AT ROW 9.5 COL 45 COLON-ALIGNED HELP
          "C¢digo do grupo de avaliaá∆o" NO-LABEL
     IMAGE-65 AT ROW 3.5 COL 39
     IMAGE-67 AT ROW 5.5 COL 39
     IMAGE-69 AT ROW 3.5 COL 43
     IMAGE-72 AT ROW 4.5 COL 39
     IMAGE-74 AT ROW 4.5 COL 43
     IMAGE-79 AT ROW 5.5 COL 43
     IMAGE-83 AT ROW 6.5 COL 39
     IMAGE-84 AT ROW 6.5 COL 43
     IMAGE-85 AT ROW 7.5 COL 39
     IMAGE-86 AT ROW 7.5 COL 43
     IMAGE-87 AT ROW 8.5 COL 39
     IMAGE-88 AT ROW 8.5 COL 43
     IMAGE-89 AT ROW 9.5 COL 39
     IMAGE-90 AT ROW 9.5 COL 43
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 83.43 BY 12.71
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     btConfigImpr AT ROW 3.58 COL 43.29 HELP
          "Configuraá∆o da impressora"
     btFile AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     cFile AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.75 COL 3 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 83.43 BY 12.71
         FONT 1.

DEFINE FRAME fPage4
     r-ativa-desativa AT ROW 1.63 COL 4.43 NO-LABEL
     l-familia-fornecedor AT ROW 3.79 COL 4.43
     l-item-fornecedor AT ROW 4.79 COL 4.43
     l-item-estabelecimento AT ROW 5.79 COL 4.43
     l-grupo AT ROW 6.79 COL 4.43
     l-ativa-desativa AT ROW 9.42 COL 4.43
     "Considera" VIEW-AS TEXT
          SIZE 6.86 BY .54 AT ROW 3.13 COL 6.14
     RECT-24 AT ROW 3.42 COL 3
     RECT-25 AT ROW 9 COL 3
     RECT-26 AT ROW 1.29 COL 3
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 83.43 BY 12.71
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
         HEIGHT             = 17
         WIDTH              = 87.57
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

{report~/report.i}

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
   NOT-VISIBLE FRAME-NAME Custom                                        */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fPage4:MOVE-AFTER-TAB-ITEM (btHelp2:HANDLE IN FRAME fpage0)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN c-descricao-ini IN FRAME fPage2
   LIKE = mgcad.af-versao-avaliacao.desc-versao EXP-SIZE                */
/* SETTINGS FOR FILL-IN c-estabelecimento-ini IN FRAME fPage2
   LIKE = mgcad.af-item-contr-estab.cod-estabel EXP-SIZE                */
/* SETTINGS FOR FILL-IN c-familia-ini IN FRAME fPage2
   LIKE = mgcad.af-familia-contr.fm-codigo EXP-SIZE                     */
/* SETTINGS FOR FILL-IN c-grp-avaliacao-ini IN FRAME fPage2
   LIKE = mgcad.af-grp-avaliacao.cod-grp-avaliacao EXP-SIZE             */
/* SETTINGS FOR FILL-IN c-item-ini IN FRAME fPage2
   LIKE = mgcad.af-item-contr.it-codigo EXP-SIZE                        */
/* SETTINGS FOR FILL-IN i-fornecedor-ini IN FRAME fPage2
   LIKE = mgcad.af-item-contr.cod-emitente EXP-LABEL EXP-HELP EXP-SIZE  */
/* SETTINGS FOR FILL-IN i-nr-versao-ini IN FRAME fPage2
   LIKE = mgcad.af-versao-avaliacao.nr-versao EXP-SIZE                  */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FRAME fPage6
                                                                        */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execuá∆o".

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


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{report/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*define var r-tt-digita as rowid no-undo.*/

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

    /*:T Coloque aqui as validaá‰es da p†gina de Digitaá∆o, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p†gina e colocar
       o focus no campo com problemas */
    /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/
   

    /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
       problemas e colocar o focus no campo com problemas */
 
    /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
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

    /*:T Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
       como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */

         ASSIGN tt-param.i-nr-versao-ini        = INPUT FRAME fPage2 i-nr-versao-ini
                tt-param.i-nr-versao-fim        = INPUT FRAME fPage2 i-nr-versao-fim
                tt-param.c-descricao-ini        = INPUT FRAME fPage2 c-descricao-ini
                tt-param.c-descricao-fim        = INPUT FRAME fPage2 c-descricao-fim
                tt-param.c-familia-ini          = INPUT FRAME fPage2 c-familia-ini
                tt-param.c-familia-fim          = INPUT FRAME fPage2 c-familia-fim
                tt-param.c-item-ini             = INPUT FRAME fPage2 c-item-ini
                tt-param.c-item-fim             = INPUT FRAME fPage2 c-item-fim
                tt-param.c-estabelecimento-ini  = INPUT FRAME fPage2 c-estabelecimento-ini
                tt-param.c-estabelecimento-fim  = INPUT FRAME fPage2 c-estabelecimento-fim
                tt-param.i-fornecedor-ini       = INPUT FRAME fPage2 i-fornecedor-ini
                tt-param.i-fornecedor-fim       = INPUT FRAME fPage2 i-fornecedor-fim
                tt-param.c-grp-avaliacao-ini    = INPUT FRAME fPage2 c-grp-avaliacao-ini
                tt-param.c-grp-avaliacao-fim    = INPUT FRAME fPage2 c-grp-avaliacao-fim
                tt-param.l-familia-fornecedor   = INPUT FRAME fPage4 l-familia-fornecedor:CHECKED
                tt-param.l-item-fornecedor      = INPUT FRAME fPage4 l-item-fornecedor:CHECKED
                tt-param.l-item-estabelecimento = INPUT FRAME fPage4 l-item-estabelecimento:CHECKED
                tt-param.l-grupo                = INPUT FRAME fPage4 l-grupo:CHECKED
                tt-param.l-ativa-desativa       = INPUT FRAME fPage4 l-ativa-desativa:CHECKED
                tt-param.r-ativa-desativa       = INPUT FRAME fPage4 r-ativa-desativa.


    /*:T Executar do programa RP.P que ir† criar o relat¢rio */
    {report/rpexb.i}

    SESSION:SET-WAIT-STATE("GENERAL":U).

    {report/rprun.i afp/af0510rp.p}

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

    /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p†gina 
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

    /*:T Coloque aqui a l¢gica de gravaá∆o dos parÉmtros e seleá∆o na temp-table
       tt-param */        

         ASSIGN tt-param.i-nr-versao-ini        = INPUT FRAME fPage2 i-nr-versao-ini
                tt-param.i-nr-versao-fim        = INPUT FRAME fPage2 i-nr-versao-fim
                tt-param.c-descricao-ini        = INPUT FRAME fPage2 c-descricao-ini
                tt-param.c-descricao-fim        = INPUT FRAME fPage2 c-descricao-fim
                tt-param.c-familia-ini          = INPUT FRAME fPage2 c-familia-ini
                tt-param.c-familia-fim          = INPUT FRAME fPage2 c-familia-fim
                tt-param.c-item-ini             = INPUT FRAME fPage2 c-item-ini
                tt-param.c-item-fim             = INPUT FRAME fPage2 c-item-fim
                tt-param.c-estabelecimento-ini  = INPUT FRAME fPage2 c-estabelecimento-ini
                tt-param.c-estabelecimento-fim  = INPUT FRAME fPage2 c-estabelecimento-fim
                tt-param.i-fornecedor-ini       = INPUT FRAME fPage2 i-fornecedor-ini
                tt-param.i-fornecedor-fim       = INPUT FRAME fPage2 i-fornecedor-fim
                tt-param.c-grp-avaliacao-ini    = INPUT FRAME fPage2 c-grp-avaliacao-ini
                tt-param.c-grp-avaliacao-fim    = INPUT FRAME fPage2 c-grp-avaliacao-fim
                tt-param.l-familia-fornecedor   = INPUT FRAME fPage4 l-familia-fornecedor:CHECKED
                tt-param.l-item-fornecedor      = INPUT FRAME fPage4 l-item-fornecedor:CHECKED
                tt-param.l-item-estabelecimento = INPUT FRAME fPage4 l-item-estabelecimento:CHECKED
                tt-param.l-grupo                = INPUT FRAME fPage4 l-grupo:CHECKED
                tt-param.l-ativa-desativa       = INPUT FRAME fPage4 l-ativa-desativa:CHECKED
                tt-param.r-ativa-desativa       = INPUT FRAME fPage4 r-ativa-desativa.

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

