&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 

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
{include/i-prgvrs.i AQ0329 2.00.00.001 } /*** "010001" ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* AQ0329:  Gera formul rio de coleta listando produtores por rota                */
/* MAQ:     Aquisi‡Æo de produtos rurais                                          */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0329 MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AQ0329
&GLOBAL-DEFINE Version        2.00.00.000
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Parƒmetro,Digita‡Æo,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO  
&GLOBAL-DEFINE PGSEL          YES 
&GLOBAL-DEFINE PGCLA          NO  
&GLOBAL-DEFINE PGPAR          YES 
&GLOBAL-DEFINE PGDIG          YES 
&GLOBAL-DEFINE PGIMP          YES 
&GLOBAL-DEFINE PGLOG          NO  

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page2Widgets   

&GLOBAL-DEFINE page4Widgets   

&GLOBAL-DEFINE page5Widgets   brDigita ~
                              btAdd ~
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
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo text-rtf text-ModelRtf

&GLOBAL-DEFINE page2Fields    c-cod-rota-ini c-cod-rota-fim
&GLOBAL-DEFINE page4Fields    c-cod-estabel dt-coleta c-motorista
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile cModelRTF

/* Parameters Definitions ---                                           */
{aqp/aq0329.i} /*temp-tables*/


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

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est  rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE VARIABLE h-boin00976 AS HANDLE NO-UNDO. /* pto-rota-coleta   */
DEFINE VARIABLE h-boad107na AS HANDLE NO-UNDO. /* estabelec         */
DEFINE VARIABLE h-boin00966 AS HANDLE NO-UNDO. /* pto-coleta        */
DEFINE VARIABLE h-aqapi005  AS HANDLE NO-UNDO. /* status pto-coleta */


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
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.cod-rota tt-digita.cod-pto-coleta tt-digita.des-pto-coleta tt-digita.nome-emit   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita tt-digita.cod-pto-coleta   
&Scoped-define ENABLED-TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brDigita tt-digita
&Scoped-define SELF-NAME brDigita
&Scoped-define QUERY-STRING-brDigita FOR EACH tt-digita
&Scoped-define OPEN-QUERY-brDigita OPEN QUERY brDigita FOR EACH tt-digita BY tt-digita.cod-rota BY tt-digita.cdn-seq BY tt-digita.cod-pto-coleta.
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

DEFINE VARIABLE c-cod-rota-fim LIKE pto-rota-coleta.cod-rota
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-cod-rota-ini LIKE pto-rota-coleta.cod-rota
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE c-cod-estabel LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE VARIABLE dt-coleta AS DATE FORMAT "99/99/9999"
     LABEL "Data"
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-motorista AS CHARACTER FORMAT "X(40)"
     LABEL "Motorista"
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE c-estabelec-nome LIKE estabelec.nome
     VIEW-AS FILL-IN 
     SIZE 58.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76 BY 2.25.

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

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
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
      tt-digita.cod-rota
      tt-digita.cod-pto-coleta
      tt-digita.des-pto-coleta
      tt-digita.nome-emit
    ENABLE
      tt-digita.cod-pto-coleta
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 84 BY 11.5
         BGCOLOR 15 FONT 1.


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
     c-cod-estabel AT ROW 3.17 COL 10.57 COLON-ALIGNED HELP
          "C¢digo do estabelecimento" WIDGET-ID 2
     c-estabelec-nome AT ROW 3.17 COL 19.86 COLON-ALIGNED HELP
          "Nome Estabelecimento" NO-LABEL WIDGET-ID 4
     dt-coleta AT ROW 4.17 COL 10.57 COLON-ALIGNED HELP
          "Data Coleta" WIDGET-ID 6
     c-motorista AT ROW 5.17 COL 10.57 COLON-ALIGNED HELP
          "Motorista" WIDGET-ID 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 11.71
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configura‡Æo da impressora"
     rsExecution AT ROW 9.5 COL 2.86 HELP
          "Modo de Execu‡Æo" NO-LABEL
     l-habilitaRtf AT ROW 5.58 COL 3.14
     cModelRTF AT ROW 7.29 COL 3 HELP
          "Nome do arquivo de modelo" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 8.75 COL 1.14 COLON-ALIGNED NO-LABEL
     btModelRtf AT ROW 7.29 COL 43 HELP
          "Escolha o arquivo de modelo"
     text-rtf AT ROW 5 COL 2 COLON-ALIGNED NO-LABEL
     text-ModelRtf AT ROW 6.54 COL 2 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 9 COL 2
     rect-rtf AT ROW 5.29 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage5
     brDigita AT ROW 1.25 COL 1
     btAdd AT ROW 12.83 COL 1
     btUpdate AT ROW 12.83 COL 16
     btDelete AT ROW 12.83 COL 31
     btSave AT ROW 12.83 COL 46
     btOpen AT ROW 12.83 COL 61
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.96
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     c-cod-rota-ini AT ROW 3.96 COL 14.29 HELP
          "C¢digo da rota"
          FONT 1
     c-cod-rota-fim AT ROW 3.96 COL 53 HELP
          "C¢digo da rota" NO-LABEL
          FONT 1
     IMAGE-1 AT ROW 3.96 COL 34.72
     IMAGE-2 AT ROW 3.96 COL 50
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 11.71
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
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-rota-fim IN FRAME fPage2
   ALIGN-L LIKE = pto-rota-coleta.cod-rota EXP-SIZE               */
/* SETTINGS FOR FILL-IN c-cod-rota-ini IN FRAME fPage2
   ALIGN-L LIKE = pto-rota-coleta.cod-rota EXP-SIZE               */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME fPage4
   LIKE = estabelec.cod-estabel EXP-SIZE                          */
/* SETTINGS FOR FILL-IN dt-coleta IN FRAME fPage4
   LIKE = layout-restdo-analis.cod-layout EXP-SIZE                */
/* SETTINGS FOR FILL-IN c-estabelec-nome IN FRAME fPage4
   LIKE = estabelec.nome EXP-LABEL EXP-SIZE                       */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brDigita 1 fPage5 */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       btModelRtf:HIDDEN IN FRAME fPage6           = TRUE.

/* SETTINGS FOR EDITOR cModelRTF IN FRAME fPage6
   NO-DISPLAY                                                           */
ASSIGN 
       cModelRTF:HIDDEN IN FRAME fPage6           = TRUE.

/* SETTINGS FOR TOGGLE-BOX l-habilitaRtf IN FRAME fPage6
   NO-DISPLAY                                                           */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-ModelRtf IN FRAME fPage6
   NO-DISPLAY                                                           */
ASSIGN 
       text-ModelRtf:HIDDEN IN FRAME fPage6           = TRUE
       text-ModelRtf:PRIVATE-DATA IN FRAME fPage6     = 
                "Modelo:".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

/* SETTINGS FOR FILL-IN text-rtf IN FRAME fPage6
   NO-DISPLAY                                                           */
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


&Scoped-define SELF-NAME fPage5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fPage5 wReport
ON ENTRY OF FRAME fPage5
DO:

  IF VALID-HANDLE( h-boin00976 ) THEN DO:

      RUN setConstraintCodigo IN h-boin00976 (INPUT c-cod-rota-ini:SCREEN-VALUE IN FRAME fPage2,
                                              INPUT c-cod-rota-fim:SCREEN-VALUE IN FRAME fPage2).

      RUN criaTTDigitaRota IN h-boin00976 (INPUT-OUTPUT TABLE tt-digita,
                                           INPUT 1, /* considera pto-coleta coletivos */
                                           INPUT c-cod-estabel:SCREEN-VALUE IN FRAME fPage4).
  END.

  {&OPEN-QUERY-brDigita} 

  if num-results("brDigita":U) > 0 then do:
      assign btDelete:SENSITIVE in frame fPage5 = yes
             btSave:SENSITIVE   in frame fPage5 = yes.

    for last tt-digita:
        reposition brDigita to rowid rowid(tt-digita).
    end.

  end.
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
        display tt-digita.cod-rota      
                tt-digita.cod-pto-coleta
                tt-digita.des-pto-coleta 
                tt-digita.nome-emit with browse brDigita.
    end.
    return no-apply.
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
ON ROW-ENTRY OF brDigita IN FRAME fPage5
DO:
   /*:T trigger para inicializar campos da temp table de digita‡Æo */
   if  brDigita:new-row in frame fPage5 then do:
       
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-LEAVE OF brDigita IN FRAME fPage5
DO:
    /*:T  aqui que a grava‡Æo da linha da temp-table ‚ efetivada.
       Por‚m as valida‡äes dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment rio */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/*&Scoped-define FRAME-NAME fPage4*/

&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wReport
ON CHOOSE OF btAdd IN FRAME fPage5 /* Inserir */
DO:
    assign btDelete:SENSITIVE in frame fPage5 = yes
           btSave:SENSITIVE   in frame fPage5 = yes.

    if num-results("brDigita":U) > 0 then do:
        
        for last tt-digita:
            reposition brDigita to rowid rowid(tt-digita).
        end.
        brDigita:INSERT-ROW("after":U) in frame fPage5.

    end.
    else do transaction:
        create tt-digita.
        
        open query brDigita for each tt-digita.
        
        apply "entry":U to tt-digita.cod-pto-coleta in browse brDigita. 
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
        assign btDelete:SENSITIVE in frame fPage5 = no
               btSave:SENSITIVE   in frame fPage5 = no.
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON LEAVE OF c-cod-estabel IN FRAME fPage4 /* Estab */
DO:
   {method/ReferenceFields.i &HandleDBOLeave="h-boad107na"
                             &KeyValue1="c-cod-estabel:SCREEN-VALUE IN FRAME fPage4"
                             &FieldName1="nome"
                             &FieldScreen1="c-estabelec-nome"
                             &Frame1="fPage4"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME fPage4 /* Estab */
OR F5 OF c-cod-estabel IN FRAME fPage4
DO:

    assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=c-cod-estabel
                       &campozoom=cod-estabel
                       &campo2=c-estabelec-nome
                       &campozoom2=nome}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME c-estabelec-nome
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estabelec-nome wReport
ON LEAVE OF c-estabelec-nome IN FRAME fPage4
DO:
    {method/ReferenceFields.i &HandleDBOLeave="h-boad107na"
                              &KeyValue1="c-cod-estabel:SCREEN-VALUE IN FRAME fPage4"
                              &FieldName1="nome"
                              &FieldScreen1="c-estabelec-nome"
                              &Frame1="fPage4"}
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

c-cod-estabel:load-mouse-pointer("image/lupa.cur") in frame fPage4.


ON 'LEAVE':U OF tt-digita.cod-pto-coleta IN BROWSE brDigita
DO:
    DEFINE VARIABLE rRowid     AS ROWID     NO-UNDO.
    DEFINE VARIABLE iStatus    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cPtoColeta AS CHARACTER NO-UNDO.

    ASSIGN cPtoColeta = tt-digita.cod-pto-coleta:SCREEN-VALUE IN BROWSE brDigita.

    RUN goToKey  IN h-boin00966 (INPUT cPtoColeta).
    IF RETURN-VALUE = "OK":U THEN DO:
    
      RUN getRowid IN h-boin00966 (OUTPUT rRowid).
    
      RUN piInicial IN h-aqapi005 (INPUT "Consultar":U,     /* A‡Æo     */
                                   INPUT "PontoDeColeta":U, /* Cadastro */ 
                                   INPUT rRowid,            /* Tabela   */
                                  OUTPUT iStatus,           /* Status   */
                            INPUT-OUTPUT TABLE rowErrors).
    
      IF iStatus = 0 /* Inativo*/ THEN DO:

        {utp/ut-liter.i Ponto_de_Coleta }
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 469,
                           INPUT RETURN-VALUE + " " + cPtoColeta).
      END.
    END.

    IF VALID-HANDLE( h-boin00976 ) THEN DO:
        IF NOT AVAIL tt-digita THEN CREATE tt-digita.

        RUN criaTTDigitaPtoCol IN h-boin00976 (INPUT tt-digita.cod-pto-coleta:SCREEN-VALUE IN BROWSE brDigita,
                                               1, /* considera pto-coleta coletivos */
                                               INPUT-OUTPUT TABLE tt-digita).
    END.

    {&OPEN-QUERY-brDigita}

    IF NUM-RESULTS("brDigita":U) > 0 THEN DO:
      ASSIGN btDelete:SENSITIVE IN FRAME fPage5 = YES
             btSave  :SENSITIVE IN FRAME fPage5 = YES.

      FOR LAST tt-digita:
         REPOSITION brDigita TO ROWID ROWID(tt-digita).
      END.
    END. 

    RETURN.

END.

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

ASSIGN dt-coleta = TODAY.
DISP dt-coleta WITH FRAME fPage4.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wReport 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE( h-boin00976 ) THEN 
        DELETE PROCEDURE h-boin00976.

    IF VALID-HANDLE(h-boad107na) THEN
        DELETE PROCEDURE h-boad107na.

    IF VALID-HANDLE(h-boin00966) THEN
    DELETE PROCEDURE h-boin00966.

    IF VALID-HANDLE(h-aqapi005) THEN
        DELETE PROCEDURE h-aqapi005.

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

/* pto-rota-coleta */    
IF NOT VALID-HANDLE( h-boin00976 ) THEN 
  RUN inbo/boin00976.p PERSISTENT SET h-boin00976.

RUN openQueryStatic IN h-boin00976 (INPUT "Main":U) NO-ERROR.

/** Estabelec **/
IF NOT VALID-HANDLE(h-boad107na) THEN
  RUN adbo/boad107na.p PERSISTENT SET h-boad107na.

RUN openQueryStatic IN h-boad107na (INPUT "Main":U) NO-ERROR.

/* Ponto de Coleta */
IF NOT VALID-HANDLE(h-boin00966) THEN
  RUN inbo/boin00966.p PERSISTENT SET h-boin00966.

RUN openQueryStatic IN h-boin00966 (INPUT "Main":U) NO-ERROR.

/* Status Ponto de Coleta */
IF NOT VALID-HANDLE(h-aqapi005) THEN
  RUN aqp/aqapi005.p PERSISTENT SET h-aqapi005.

RUN openQueryStatic IN h-aqapi005 (INPUT "Main":U) NO-ERROR.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaRowErrors wReport
PROCEDURE criaRowErrors:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-msg AS INTEGER                   NO-UNDO.
    DEFINE INPUT PARAMETER p-texto   AS CHARACTER FORMAT "X(255)" NO-UNDO.

    DEFINE VARIABLE iErrorSequence    AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cErrorSubType     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cErrorDescription AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cErrorHelp        AS CHARACTER  NO-UNDO.

    userCodeBlock:
    DO ON ERROR UNDO, LEAVE userCodeBlock
       ON STOP  UNDO, LEAVE userCodeBlock
       ON QUIT  UNDO, LEAVE userCodeBlock:

        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT p-num-msg,
                           INPUT p-texto).                       
        ASSIGN cErrorDescription = RETURN-VALUE.
        
        /** Busca o Tipo de Mensagem do EMS **/
        RUN utp/ut-msgs.p (INPUT "TYPE":U,
                           INPUT p-num-msg,
                           INPUT p-texto).
        CASE {uninc/i01un001.i 06 RETURN-VALUE}:
        WHEN 1 THEN
            ASSIGN cErrorSubType = "ERROR":U.
        WHEN 2 THEN
            ASSIGN cErrorSubType = "WARNING":U.
        WHEN 3 THEN
            ASSIGN cErrorSubType = "QUESTION":U.
        WHEN 4 THEN
            ASSIGN cErrorSubType = "INFORMATION":U.
        END CASE.
        
        /** Busca Help da Mensagem **/
        RUN utp/ut-msgs.p (INPUT "HELP":U,
                           INPUT p-num-msg,  
                           INPUT p-texto).   
        ASSIGN cErrorHelp = RETURN-VALUE.
        
        /*--- Atualiza variëvel de sequ¦ncia de erros ---*/
        IF CAN-FIND(LAST rowErrors) THEN DO:
            FIND LAST rowErrors NO-ERROR.
            ASSIGN iErrorSequence = rowErrors.ErrorSequence + 1.
        END.
        ELSE
            ASSIGN iErrorSequence = iErrorSequence + 1.
        
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorSequence    = iErrorSequence
               rowErrors.ErrorNumber      = p-num-msg
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = cErrorSubType
               rowErrors.ErrorDescription = cErrorDescription
               rowErrors.ErrorHelp        = cErrorHelp
               rowErrors.ErrorParameters  = p-texto.
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

define var r-tt-digita as rowid no-undo.

EMPTY TEMP-TABLE rowErrors NO-ERROR.

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
    
    FOR FIRST tt-digita NO-LOCK: END.

    IF NOT AVAIL tt-digita THEN DO:
        RUN criaRowErrors IN THIS-PROCEDURE(INPUT 16024,
                                            INPUT "":U).
        
        IF c-cod-estabel:SCREEN-VALUE IN FRAME fPage4 <> "" AND
           c-cod-rota-fim:SCREEN-VALUE IN FRAME fPage2 <> "" THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 16024,
                               INPUT "").
            RUN setFolder IN hFolder (INPUT 3).
            RETURN "NOK":U.
        END.
        

    END.

    for each tt-digita no-lock:
        assign r-tt-digita = rowid(tt-digita).
        
        /*:T As demais valida‡äes devem ser feitas aqui */
        
    end.
    
    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */
    IF  c-cod-estabel:SCREEN-VALUE IN FRAME fPage4 = "" THEN DO:
        {utp/ut-liter.i Estabelecimento *}
        RUN criaRowErrors IN THIS-PROCEDURE(INPUT 17677,
                                            INPUT RETURN-VALUE).
    END. 
    ELSE DO:
        RUN goToKey IN h-boad107na (INPUT c-cod-estabel:SCREEN-VALUE IN FRAME fPage4).
        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-liter.i Estabelecimento *}
        RUN criaRowErrors IN THIS-PROCEDURE(INPUT 2,
                                            INPUT RETURN-VALUE).
        END.
    END.

    IF INPUT FRAME fPage4 c-motorista = "" THEN DO:

        {utp/ut-liter.i Motorista *}

        RUN criaRowErrors IN THIS-PROCEDURE(INPUT 54,
                                            INPUT RETURN-VALUE).
    END.

    /**************************** Fim das valida‡äes da tela ******************************************/            
    IF CAN-FIND (FIRST rowErrors) THEN DO:
        {method/showmessage.i1}
        /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
        {method/showmessage.i2}
        
        RETURN "NOK":U.
    END.

   
    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario            = c-seg-usuario
           tt-param.destino            = input frame fPage6 rsDestiny
           tt-param.data-exec          = today
           tt-param.hora-exec          = time
           &IF "{&RTF}":U = "YES":U &THEN
           tt-param.modelo             = INPUT FRAME fPage6 cModelRTF
           tt-param.l-habilitaRtf      = INPUT FRAME fPage6 l-habilitaRtf
           &endif   
           tt-param.cod-estabel        = INPUT FRAME fPage4 c-cod-estabel:SCREEN-VALUE
           tt-param.dt-coleta          = DATE(INPUT FRAME fPage4 dt-coleta:SCREEN-VALUE)
           tt-param.c-motorista        = INPUT FRAME fPage4 c-motorista:SCREEN-VALUE
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
    
    {report/rprun.i aqp/aq0329rp.p}
    
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

    {report/imrun.i xxp/xx9999rp.p}

    {report/imexc.i}

    if  session:set-wait-state("":U) then.
    
    {report/imtrm.i tt-param.arq-destino tt-param.destino}
    
end.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

