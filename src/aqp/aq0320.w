&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
          mgmov            PROGRESS
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
{include/i-prgvrs.i AQ0320 2.00.00.013 } /*** 010013 ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0320 MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AQ0320
&GLOBAL-DEFINE Version        2.00.00.013
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   ParÉmetro,Digitaá∆o,Impress∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2

&GLOBAL-DEFINE page4Widgets   
                              
&GLOBAL-DEFINE page5Widgets   brDigita ~
                              btAdd ~
                              btUpdate ~
                              btDelete ~
                              btSave ~
                              btOpen

&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution ~
                              l-habilitaRtf ~
                              btModelRtf

&GLOBAL-DEFINE page0Text      

&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo text-rtf text-ModelRtf

&GLOBAL-DEFINE page4Fields    c-cod-estabel rd-acao
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile cModelRTF

/* Parameters Definitions ---                                           */
{aqp/aq0320.i} /* Definicao temp-table*/
define buffer b-tt-digita for tt-digita.


/* Transfer Definitions */
def var raw-param        as raw no-undo.


def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-rtf              as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.

def stream s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est† rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

/*BO's*/
DEFINE VARIABLE h-boad107na AS HANDLE NO-UNDO.  /* estabelec            */
DEFINE VARIABLE h-boin627   AS HANDLE NO-UNDO.  /* usuar-mater          */
DEFINE VARIABLE h-boin00968 AS HANDLE NO-UNDO.  /* param-aquis-rural    */
DEFINE VARIABLE h-boin00999 AS HANDLE NO-UNDO.  /* fechto-produt-period */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDigita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE brDigita                                      */
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.cod-estabel tt-digita.nomeest tt-digita.cod-period   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita tt-digita.cod-estabel   
&Scoped-define ENABLED-TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brDigita tt-digita
&Scoped-define SELF-NAME brDigita
&Scoped-define QUERY-STRING-brDigita FOR EACH tt-digita
&Scoped-define OPEN-QUERY-brDigita OPEN QUERY brDigita FOR EACH tt-digita.
&Scoped-define TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-brDigita tt-digita


/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-brDigita}

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

DEFINE VARIABLE c-cod-estabel LIKE item-estab-rural.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-period LIKE fechto-produt-period.cod-period
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-estabel LIKE estabelec.nome
     VIEW-AS FILL-IN 
     SIZE 41.14 BY .88 NO-UNDO.

DEFINE VARIABLE rd-acao AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Fechar", 1,
"Reabrir", 2
     SIZE 12 BY 3 NO-UNDO.

DEFINE BUTTON btAdd 
     LABEL "Inserir" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btDelete 
     LABEL "Retirar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btOpen 
     LABEL "Recuperar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btUpdate 
     LABEL "Alterar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btModelRtf 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE cModelRTF AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-ModelRtf AS CHARACTER FORMAT "X(256)":U INITIAL "Modelo:" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-rtf AS CHARACTER FORMAT "X(256)":U INITIAL "Rich Text Format(RTF)" 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

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

DEFINE RECTANGLE rect-rtf
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 3.21.

DEFINE VARIABLE l-habilitaRtf AS LOGICAL INITIAL no 
     LABEL "RTF" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDigita FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDigita wReport _FREEFORM
  QUERY brDigita DISPLAY
      tt-digita.cod-estabel  
tt-digita.nomeest WIDTH 58 FORMAT "X(40)" LABEL "Descriá∆o"
tt-digita.cod-period    WIDTH 10 FORMAT "99/9999"
ENABLE
tt-digita.cod-estabel
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 82 BY 11.5
         BGCOLOR 15 FONT 1 FIT-LAST-COLUMN.


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

DEFINE FRAME fPage5
     brDigita AT ROW 1.25 COL 1
     btAdd AT ROW 12.88 COL 1
     btUpdate AT ROW 12.88 COL 16
     btDelete AT ROW 12.88 COL 31
     btSave AT ROW 12.88 COL 46
     btOpen AT ROW 12.88 COL 61
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.96
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     c-cod-estabel AT ROW 3.63 COL 16.14 COLON-ALIGNED HELP
          "C¢digo do estabelecimento" WIDGET-ID 2
     c-nome-estabel AT ROW 3.63 COL 25.43 COLON-ALIGNED HELP
          "Nome Estabelecimento" NO-LABEL WIDGET-ID 4
     c-cod-period AT ROW 4.63 COL 16.14 COLON-ALIGNED HELP
          "Informe o Periodo" WIDGET-ID 6
     rd-acao AT ROW 7 COL 18 NO-LABEL WIDGET-ID 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.96
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configuraá∆o da impressora"
     l-habilitaRtf AT ROW 5.58 COL 3.14
     cModelRTF AT ROW 7.29 COL 3 HELP
          "Nome do arquivo de modelo" NO-LABEL
     btModelRtf AT ROW 7.29 COL 43 HELP
          "Escolha o arquivo de modelo"
     rsExecution AT ROW 9.5 COL 2.86 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-rtf AT ROW 5 COL 2 COLON-ALIGNED NO-LABEL
     text-ModelRtf AT ROW 6.54 COL 2 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 8.75 COL 1.14 COLON-ALIGNED NO-LABEL
     rect-rtf AT ROW 5.29 COL 2
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 9 COL 2
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
ASSIGN FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME fPage4
   LIKE = mgcad.item-estab-rural.cod-estabel EXP-SIZE                   */
/* SETTINGS FOR FILL-IN c-cod-period IN FRAME fPage4
   LIKE = mgmov.fechto-produt-period.cod-period EXP-SIZE                */
/* SETTINGS FOR FILL-IN c-nome-estabel IN FRAME fPage4
   LIKE = mgcad.estabelec.nome EXP-LABEL EXP-SIZE                       */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brDigita 1 fPage5 */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       btModelRtf:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       cModelRTF:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-ModelRtf:HIDDEN IN FRAME fPage6           = TRUE
       text-ModelRtf:PRIVATE-DATA IN FRAME fPage6     = 
                "Modelo:".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execuá∆o".

ASSIGN 
       text-rtf:HIDDEN IN FRAME fPage6           = TRUE
       text-rtf:PRIVATE-DATA IN FRAME fPage6     = 
                "Rich Text Format(RTF)".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDigita
/* Query rebuild information for BROWSE brDigita
     _START_FREEFORM
OPEN QUERY brDigita FOR EACH tt-digita.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDigita */
&ANALYZE-RESUME

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


&Scoped-define BROWSE-NAME brDigita
&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON DEL OF brDigita IN FRAME fPage5
DO:
   apply 'choose' to btDelete in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON END-ERROR OF brDigita IN FRAME fPage5
ANYWHERE 
DO:
    if  brDigita:new-row in frame fPage5 then do:
        if  avail tt-digita then
            delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then. 
    end.                                                               
    else do:
        get current brDigita.
        display tt-digita.cod-estabel
                tt-digita.nomeest
                tt-digita.cod-period with browse brDigita.
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ENTER OF brDigita IN FRAME fPage5
ANYWHERE
DO:
  apply 'tab' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON INS OF brDigita IN FRAME fPage5
DO:
   apply 'choose' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-END OF brDigita IN FRAME fPage5
DO:
   apply 'entry' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-HOME OF brDigita IN FRAME fPage5
DO:
  apply 'entry' to btOpen in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-LEAVE OF brDigita IN FRAME fPage5
DO:
    /*:T ê aqui que a gravaá∆o da linha da temp-table Ç efetivada.
       PorÇm as validaá‰es dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment†rio */
    
    if brDigita:NEW-ROW in frame fPage5 then 
    do transaction on error undo, return no-apply:
        create tt-digita.
        assign input browse brDigita tt-digita.cod-estabel
               input browse brDigita tt-digita.nomeest
               input browse brDigita tt-digita.cod-period.

        brDigita:CREATE-RESULT-LIST-ENTRY() in frame fPage5.
    end.
    else do transaction on error undo, return no-apply:
        if avail tt-digita then
            assign input browse brDigita tt-digita.cod-estabel
                   input browse brDigita tt-digita.nomeest
                   input browse brDigita tt-digita.cod-period.
    end.

    IF AVAIL tt-digita THEN DO:
        /*nome-estabel*/
        RUN goToKey IN h-boad107na(INPUT tt-digita.cod-estabel).
        
        IF RETURN-VALUE = "OK":U THEN
            RUN getCharField IN h-boad107na(INPUT 'nome', OUTPUT c-nome-estabel).
        
        IF RETURN-VALUE = "OK":U THEN
            ASSIGN tt-digita.nomeest = c-nome-estabel.
        ELSE
            ASSIGN tt-digita.nomeest = "".
        
        /*cod-period*/
        RUN piBuscarPeriodo IN THIS-PROCEDURE (INPUT  tt-digita.cod-estabel,
                                               OUTPUT c-cod-period).
        ASSIGN tt-digita.cod-period = c-cod-period.
  
        display tt-digita.cod-estabel 
                tt-digita.nomeest
                tt-digita.cod-period  with browse brDigita.
    END.

    IF CAN-FIND(FIRST tt-digita) THEN /*teste para n„o mesclar fechamento e reabertura na aba Digitaá∆o*/
        ASSIGN rd-acao:SENSITIVE IN FRAME fPage4 = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wReport
ON CHOOSE OF btAdd IN FRAME fPage5 /* Inserir */
DO:
    assign btUpdate:SENSITIVE in frame fPage5 = yes
           btDelete:SENSITIVE in frame fPage5 = yes
           btSave:SENSITIVE   in frame fPage5 = yes.
    
    if num-results("brDigita":U) > 0 then
        brDigita:INSERT-ROW("after":U) in frame fPage5.
    else do transaction:
        create tt-digita.
        
        open query brDigita for each tt-digita.
        
        apply "entry":U to tt-digita.cod-estabel in browse brDigita. 
    end.
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


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wReport
ON CHOOSE OF btDelete IN FRAME fPage5 /* Retirar */
DO:
    if  brDigita:num-selected-rows > 0 then do on error undo, return no-apply:
        get current brDigita.
        delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then.
    end.
    
    if num-results("brDigita":U) = 0 then
        assign btUpdate:SENSITIVE in frame fPage5 = no
               btDelete:SENSITIVE in frame fPage5 = no
               btSave:SENSITIVE   in frame fPage5 = no
               rd-acao:SENSITIVE  in frame fPage4 = yes.
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


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btModelRtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModelRtf wReport
ON CHOOSE OF btModelRtf IN FRAME fPage6
DO:
    def var cFile as char no-undo.
    def var l-ok  as logical no-undo.

    assign cModelRTF = replace(input frame {&frame-name} cModelRTF, "/", "~\").
    SYSTEM-DIALOG GET-FILE cFile
       FILTERS "*.rtf" "*.rtf",
               "*.*" "*.*"
       DEFAULT-EXTENSION "rtf"
       INITIAL-DIR "modelos" 
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then
        assign cModelRTF:screen-value in frame {&frame-name}  = replace(cFile, "~\", "/"). 

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


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btOpen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOpen wReport
ON CHOOSE OF btOpen IN FRAME fPage5 /* Recuperar */
DO:
    {report/rprcd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wReport
ON CHOOSE OF btSave IN FRAME fPage5 /* Salvar */
DO:
   {report/rpsvd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wReport
ON CHOOSE OF btUpdate IN FRAME fPage5 /* Alterar */
DO:
   apply 'entry' to tt-digita.cod-estabel in browse brDigita. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON LEAVE OF c-cod-estabel IN FRAME fPage4 /* Estabelecimento */
DO:
  {method/ReferenceFields.i &HandleDBOLeave="h-boad107na"
                            &KeyValue1="c-cod-estabel:SCREEN-VALUE IN FRAME fPage4"
                            &FieldName1="nome"
                            &FieldScreen1="c-nome-estabel"
                            &Frame1="fPage4"}
                            
  RUN piBuscarPeriodo IN THIS-PROCEDURE (INPUT  INPUT FRAME fPage4 c-cod-estabel:SCREEN-VALUE,
                                         OUTPUT c-cod-period).
  ASSIGN c-cod-period:SCREEN-VALUE IN FRAME fPage4 = c-cod-period.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME fPage4 /* Estabelecimento */
OR F5 OF c-cod-estabel IN FRAME fPage4
DO:
    {method/zoomfields.i &ProgramZoom="inzoom/z01in00983.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="c-cod-estabel"
                         &Frame1="fPage4"
                         &EnableImplant="NO"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME l-habilitaRtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-habilitaRtf wReport
ON VALUE-CHANGED OF l-habilitaRtf IN FRAME fPage6 /* RTF */
DO:
    &IF "{&RTF}":U = "YES":U &THEN
    RUN pi-habilitaRtf.  
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME rd-acao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rd-acao wReport
ON VALUE-CHANGED OF rd-acao IN FRAME fPage4
DO:
  
    RUN piBuscarPeriodo IN THIS-PROCEDURE (INPUT  INPUT FRAME fPage4 c-cod-estabel:SCREEN-VALUE,
                                           OUTPUT c-cod-period).
    ASSIGN c-cod-period:SCREEN-VALUE IN FRAME fPage4 = c-cod-period.

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


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{report/mainblock.i}

tt-digita.cod-estabel:load-mouse-pointer("image/lupa.cur") in browse brDigita.
c-cod-estabel:load-mouse-pointer("image/lupa.cur") in FRAME fPage4.

ON MOUSE-SELECT-DBLCLICK OF tt-digita.cod-estabel IN BROWSE brDigita
OR F5 OF tt-digita.cod-estabel IN BROWSE brDigita
DO:
    {method/zoomfields.i &ProgramZoom="inzoom/z01in00983.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="tt-digita.cod-estabel"
                         &BROWSE1="brDigita"
                         &EnableImplant="NO"} 
END.

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

  /** item-estab-rural **/
  IF  VALID-HANDLE(h-boin627) THEN DO:
      DELETE PROCEDURE h-boin627.
      ASSIGN h-boin627 = ?.
  END.

  /** Estabelec **/
  IF  VALID-HANDLE(h-boad107na) THEN DO:
      DELETE PROCEDURE h-boad107na.
      ASSIGN h-boad107na = ?.
  END.

  /** param-aquis-rural **/
  IF  VALID-HANDLE(h-boin00968) THEN DO:
      DELETE PROCEDURE h-boin00968.
      ASSIGN h-boin00968 = ?.
  END.

  /** fechto-produt-period **/
  IF  VALID-HANDLE(h-boin00999) THEN DO:
      DELETE PROCEDURE h-boin00999.
      ASSIGN h-boin00999 = ?.
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
/*Alterado 17/02/2005 - tech1007 - Foi criado essa procedure para que seja realizado a inicializaá∆o
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

    DEFINE VARIABLE c-return AS CHARACTER   NO-UNDO.

    RUN findUsuar_mater IN h-boin627 (INPUT c-seg-usuario, OUTPUT c-return).
    IF c-return = "" THEN DO:
        RUN getCharField IN h-boin627 (INPUT 'char-1', OUTPUT c-return).
         ASSIGN c-return = SUBSTR(c-return,16,5). /* estab usuar */
    END.

    ASSIGN c-cod-estabel:SCREEN-VALUE IN FRAME fPage4 = c-return.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wReport 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN initializeDBOs IN THIS-PROCEDURE.

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
  /** item-estab-rural  **/
  IF NOT VALID-HANDLE(h-boin627) THEN
      RUN inbo/boin627.p PERSISTENT SET h-boin627.
  
  RUN openqueryStatic IN h-boin627(INPUT "Main") NO-ERROR.

  /** Estabelec **/
  IF NOT VALID-HANDLE(h-boad107na) THEN
      RUN adbo/boad107na.p PERSISTENT SET h-boad107na.

  RUN openQueryStatic IN h-boad107na (INPUT "Main":U) NO-ERROR.

  /** param-aquis-rural **/
  IF NOT VALID-HANDLE(h-boin00968) THEN
      RUN inbo/boin00968.p PERSISTENT SET h-boin00968.

  RUN openQueryStatic IN h-boin00968 (INPUT "Main":U) NO-ERROR.

  /** fechto-produt-period **/
  IF NOT VALID-HANDLE(h-boin00999) THEN
      RUN inbo/boin00999.p PERSISTENT SET h-boin00999.

  RUN setConstraintEstabel IN h-boin00999 (INPUT INPUT FRAME fPage4 c-cod-estabel) NO-ERROR.
  RUN openQueryStatic      IN h-boin00999 (INPUT "Estabel":U) NO-ERROR.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscarPeriodo wReport 
PROCEDURE piBuscarPeriodo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAM p-cod-estabel LIKE item-estab-rural.cod-estabel    NO-UNDO.
    DEFINE OUTPUT PARAM p-cod-period  LIKE fechto-produt-period.cod-period NO-UNDO.

    IF  VALID-HANDLE(h-boin00968) THEN DO:
        
        RUN goToKey IN h-boin00968 (INPUT p-cod-estabel).
        IF RETURN-VALUE = "OK":U THEN DO:
        
            RUN getCharField IN h-boin00968 (INPUT  "cod-periodo",
                                             OUTPUT c-cod-period).

            IF INPUT FRAME fPage4 rd-acao = 1 THEN DO: /*fechar*/    
                IF c-cod-period <> "" THEN DO:   /*ao fechar per°odo, busca £ltimo per°odo fechado, e ir† fechar o pr¢ximo*/
                    ASSIGN p-cod-period = IF INT(SUBSTRING(c-cod-period,1,2)) < 9 
                                              THEN "0" + STRING(INT(SUBSTRING(c-cod-period,1,2)) + 1) + SUBSTRING(c-cod-period,3,4)
                                          ELSE IF INT(SUBSTRING(c-cod-period,1,2)) < 12 
                                              THEN STRING(INT(SUBSTRING(c-cod-period,1,2)) + 1) + SUBSTRING(c-cod-period,3,4)    
                                          ELSE "01" +  STRING(INT(SUBSTRING(c-cod-period,3,4)) + 1).
                END.
                ELSE DO: /*caso n∆o encontre (primeira execuá∆o) ir† verificar a £ltima fechto*/

                    RUN setConstraintEstabel IN h-boin00999 (INPUT p-cod-estabel) NO-ERROR.
                    RUN openQueryStatic      IN h-boin00999 (INPUT "Estabel":U) NO-ERROR.    
                    RUN getLast IN h-boin00999.
                    
                    IF RETURN-VALUE = "OK":U THEN DO:
                        
                        RUN getCharField IN h-boin00999 (INPUT  "cod-period",
                                                         OUTPUT p-cod-period).

                    END.

                END.
            END.

            IF INPUT FRAME fPage4 rd-acao = 2 THEN DO: /*reabrir*/  
                IF c-cod-period <> "" THEN DO:      /*encontrou period fechado no aq0101*/      
                    ASSIGN p-cod-period = c-cod-period.
                END.
                ELSE DO:
                    ASSIGN p-cod-period = "".
                END.

            END.
        END.

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
    /*verifica se esta reabrindo estabelecimento padrao do usuario*/
    DEFINE VARIABLE c-return AS CHARACTER   NO-UNDO.
    
    IF INPUT FRAME fPage4 rd-acao = 2 THEN DO: 
        RUN findUsuar_mater IN h-boin627 (INPUT c-seg-usuario, OUTPUT c-return).
        IF c-return = "" THEN DO:
            RUN getCharField IN h-boin627 (INPUT 'char-1', OUTPUT c-return).
            ASSIGN c-return = SUBSTR(c-return,16,5). /* estab usuar */
        END.
        
        IF CAN-FIND(FIRST tt-digita) THEN DO:
            IF CAN-FIND(FIRST tt-digita WHERE tt-digita.cod-estabel <> c-return) THEN DO:
                run utp/ut-msgs.p (INPUT "SHOW":U, INPUT 54922, INPUT "").  
                IF RETURN-VALUE = "NO":U THEN DO: /*caso usu·rio responda que n„o, cancela o processo*/
                    APPLY "ENTRY":U TO tt-digita.cod-estabel IN BROWSE brDigita.
                    RETURN "NOK":U.
                END.
            END.
        END.
        ELSE DO:
            IF c-cod-estabel:SCREEN-VALUE IN FRAME fPage4 <> c-return THEN DO:
                run utp/ut-msgs.p (INPUT "SHOW":U, INPUT 54922, INPUT "").
                IF RETURN-VALUE = "NO":U THEN DO: /*caso usu·rio responda que n„o, cancela o processo*/
                    APPLY "ENTRY":U TO c-cod-estabel IN FRAME fPage4.
                    RETURN "NOK":U.
                END.
            END.
        END.
    END.
    /**************************************************************/



define var r-tt-digita as rowid no-undo.

/*:T** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}

    /*15/02/2005 - tech1007 - Teste alterado pois RTF n∆o Ç mais opá∆o de Destino*/
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
    
    /*:T Coloque aqui as validaá‰es da p†gina de Digitaá∆o, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p†gina e colocar
       o focus no campo com problemas */
    /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/
    
    for each tt-digita no-lock:
        assign r-tt-digita = rowid(tt-digita).
        
        /*:T Validaá∆o de duplicidade de registro na temp-table tt-digita */
        find first b-tt-digita 
            where b-tt-digita.cod-estabel = tt-digita.cod-estabel
              and rowid(b-tt-digita) <> rowid(tt-digita) 
            no-lock no-error.
        if  avail b-tt-digita then do:
            reposition brDigita to rowid rowid(b-tt-digita).
            
            run utp/ut-msgs.p (input "SHOW":U, input 108, input "":U).
            apply "ENTRY":U to tt-digita.cod-estabel in browse brDigita.
            
            return error.
        end.
        
        IF  tt-digita.cod-estabel = "" THEN DO:
            ASSIGN BROWSE brDigita:CURRENT-COLUMN = tt-digita.cod-estabel:HANDLE IN BROWSE brDigita.
            
            REPOSITION brDigita TO ROWID r-tt-digita.
           
            {utp/ut-liter.i "Estabelecimento" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17677, INPUT RETURN-VALUE).
            APPLY "ENTRY":U TO tt-digita.cod-estabel IN BROWSE brDigita.
            
            RETURN ERROR.
        END.
        ELSE DO:
           RUN goToKey IN h-boad107na (INPUT tt-digita.cod-estabel).
            IF RETURN-VALUE = "NOK":U THEN DO:
                reposition brDigita to rowid r-tt-digita.
                {utp/ut-liter.i Estabelecimento *}
                run utp/ut-msgs.p (input "SHOW":U, input 2, input RETURN-VALUE).
                apply "ENTRY":U to tt-digita.cod-estabel in browse brDigita.
                RETURN ERROR.
            END.
        END.

        IF  tt-digita.cod-period = "" THEN DO:
            ASSIGN BROWSE brDigita:CURRENT-COLUMN = tt-digita.cod-estabel:HANDLE IN BROWSE brDigita.
            
            REPOSITION brDigita TO ROWID r-tt-digita.
           
            {utp/ut-liter.i "Per°odo" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17677, INPUT RETURN-VALUE).
            APPLY "ENTRY":U TO tt-digita.cod-estabel IN BROWSE brDigita.
            
            RETURN ERROR.
        END.

    end.
        /*:T As demais validaá‰es devem ser feitas aqui */
    FIND FIRST tt-digita NO-ERROR.    
    IF NOT AVAIL tt-digita THEN DO: /*s¢ testar† a tela caso n∆o tenha tt-digita*/
        IF  c-cod-estabel:SCREEN-VALUE IN FRAME fPage4 = "" THEN DO:
            {utp/ut-liter.i "Estabelecimento" *}
            run utp/ut-msgs.p (input "SHOW":U, input 17677, input RETURN-VALUE).
            APPLY "ENTRY":U TO c-cod-estabel IN FRAME fPage4.
            return error.
        END. 
        ELSE DO:
            RUN goToKey IN h-boad107na (INPUT c-cod-estabel:SCREEN-VALUE IN FRAME fPage4).
            IF RETURN-VALUE = "NOK":U THEN DO:
                {utp/ut-liter.i Estabelecimento *}
                run utp/ut-msgs.p (input "SHOW":U, input 2, input RETURN-VALUE).
                APPLY "ENTRY":U TO c-cod-estabel IN FRAME fPage4.
                return error.
            END.
        END.
        IF  c-cod-period:SCREEN-VALUE IN FRAME fPage4 = "" THEN DO:
            {utp/ut-liter.i "Per°odo" *}
            run utp/ut-msgs.p (input "SHOW":U, input 17677, input RETURN-VALUE).
            APPLY "ENTRY":U TO c-cod-estabel IN FRAME fPage4.
            return error.
        END. 
    END.
    
    /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
       problemas e colocar o focus no campo com problemas */
        
    
    
    /*Ser† poss°vel consultar o per°odo fechado nos ParÉmetros de Aquisiá∆o Rural (AQ0101). 
        Caso n∆o exista parÉmetro aquisiá∆o rural para o estabelecimento em que se est† tentando
         fechar o per°odo, deve mostrar mensagem de erro 
         "N∆o foi encontrado ParÉmetro Aquisiá∆o Rural (AQ0101) 
         para o estabelecimento <c¢digo_estabelecimento_informado_em_tela>", 
         e n∆o permitir executar o programa. 
         Essa validaá∆o deve ser feita ao clicar no bot∆o executar. */    
    
    
    /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.cod-estabel     = INPUT FRAME fPage4 c-cod-estabel
           tt-param.cod-period      = INPUT FRAME fPage4 c-cod-period
           tt-param.acao            = INPUT FRAME fPage4 rd-acao
           
           .
    
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
        then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
       como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */
    
    
    
    /*:T Executar do programa RP.P que ir† criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i aqp/aq0320rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

