&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i AQ0506 2.00.00.003 } /*** 010003 ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0506 MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AQ0506
&GLOBAL-DEFINE Version        2.00.00.003
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o,Impress∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          NO
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2  

&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page6Widgets   rsDestiny btConfigImpr btFile rsExecution l-imp-param

&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo 

&GLOBAL-DEFINE page2Fields    c-cod-estab-ini   ~
                              c-cod-estab-fim   ~
                              i-num-carga-ini  ~
                              i-num-carga-fim  ~
                              d-data-alter-ini ~
                              d-data-alter-fim ~
                              d-data-trans-ini ~
                              d-data-trans-fim ~
                              c-cod-usuar-ini  ~
                              c-cod-usuar-fim

&GLOBAL-DEFINE page6Fields    cFile

/* Parameters Definitions ---                                           */

{aqp/AQ0506.i} /* tt-param - tt-digita - tt-raw-digita */

DEFINE BUFFER b-tt-digita FOR tt-digita.

/* Transfer Definitions */

DEFINE VARIABLE raw-param  AS RAW     NO-UNDO.
DEFINE VARIABLE l-ok       AS LOGICAL NO-UNDO.
DEFINE VARIABLE c-terminal AS CHAR    NO-UNDO.

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


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnData wReport 
FUNCTION fnData RETURNS DATE
  ( i AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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

DEFINE VARIABLE c-cod-estab-fim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estab-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-usuar-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-usuar-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Usu†rio" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE d-data-alter-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE d-data-alter-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Alteraá∆o" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE d-data-trans-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE d-data-trans-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Transaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-carga-fim AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-carga-ini AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Carga" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-40
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-41
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
     SIZE 42.86 BY .88
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
"Terminal", 3,
"Planilha", 4
     SIZE 45.86 BY 1.08
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
     SIZE 46.29 BY 1.71.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48.86 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.

DEFINE VARIABLE l-imp-param AS LOGICAL INITIAL yes 
     LABEL "Imprimir ParÉmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.86 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 13.58 COL 2
     btCancel AT ROW 13.58 COL 13
     btHelp2 AT ROW 13.58 COL 80
     rtToolBar AT ROW 13.33 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14.04
         FONT 1.

DEFINE FRAME fPage2
     c-cod-estab-ini AT ROW 2.13 COL 24 COLON-ALIGNED
     c-cod-estab-fim AT ROW 2.13 COL 46.86 COLON-ALIGNED NO-LABEL
     i-num-carga-ini AT ROW 3.13 COL 24 COLON-ALIGNED
     i-num-carga-fim AT ROW 3.13 COL 46.86 COLON-ALIGNED NO-LABEL
     d-data-alter-ini AT ROW 4.13 COL 24 COLON-ALIGNED
     d-data-alter-fim AT ROW 4.13 COL 46.86 COLON-ALIGNED NO-LABEL
     d-data-trans-ini AT ROW 5.13 COL 24 COLON-ALIGNED
     d-data-trans-fim AT ROW 5.13 COL 46.86 COLON-ALIGNED NO-LABEL
     c-cod-usuar-ini AT ROW 6.13 COL 24 COLON-ALIGNED
     c-cod-usuar-fim AT ROW 6.13 COL 46.86 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 2.13 COL 40.43
     IMAGE-2 AT ROW 2.17 COL 45.57
     IMAGE-3 AT ROW 3.13 COL 40.43
     IMAGE-4 AT ROW 3.17 COL 45.57
     IMAGE-5 AT ROW 4.13 COL 40.43
     IMAGE-6 AT ROW 4.17 COL 45.57
     IMAGE-7 AT ROW 5.13 COL 40.43
     IMAGE-8 AT ROW 5.17 COL 45.57
     IMAGE-40 AT ROW 6.13 COL 40.43
     IMAGE-41 AT ROW 6.17 COL 45.57
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 10.21
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 46.29 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 46.29 HELP
          "Configuraá∆o da impressora"
     rsExecution AT ROW 6.08 COL 2.86 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5.33 COL 1.14 COLON-ALIGNED NO-LABEL
     l-imp-param AT ROW 8.71 COL 3.14
     "Impress∆o de ParÉmetros" VIEW-AS TEXT
          SIZE 17.86 BY .67 AT ROW 7.88 COL 3.14
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.58 COL 2
     RECT-11 AT ROW 8.21 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
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
         HEIGHT             = 14.04
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
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-estab-fim IN FRAME fPage2
   NO-DISPLAY                                                           */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
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
   DO  ON ERROR UNDO, RETURN NO-APPLY:
       RUN piExecute.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage6
DO:
do with frame fPage6:

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
    ASSIGN d-data-alter-ini = fnData(1) 
           d-data-alter-fim = fnData(2)
           d-data-trans-ini = fnData(1) 
           d-data-trans-fim = fnData(2)
           rsDestiny        = 4
           rsDestiny  :SENSITIVE IN FRAME fPage6 = NO
           rsExecution:SENSITIVE IN FRAME fPage6 = NO.

    DISPLAY d-data-alter-ini
            d-data-alter-fim
            d-data-trans-ini
            d-data-trans-fim
            WITH FRAME fPage2.

    DISPLAY rsDestiny cFile
            WITH FRAME fPage6.

    APPLY 'VALUE-CHANGED' TO rsDestiny IN FRAME fPage6.  

    IF VALID-HANDLE(hFolder) THEN
        RUN setFolder IN hFolder (INPUT 1).
          
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaRowErrors wReport 
PROCEDURE criaRowErrors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
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
        
        /*--- Atualiza variâvel de sequ›ncia de erros ---*/
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
    DEFINE VARIABLE r-tt-digita AS ROWID NO-UNDO.

    /*:T** Relatorio ***/
    DO ON ERROR UNDO, RETURN ERROR ON STOP  UNDO, RETURN ERROR:
        {report/rpexa.i}

        /*15/02/2005 - tech1007 - Teste alterado pois RTF n∆o Ç mais opá∆o de Destino*/
        IF INPUT FRAME fPage6 rsDestiny   = 2 AND
           INPUT FRAME fPage6 rsExecution = 1 THEN DO:
            RUN utp/ut-vlarq.p (INPUT INPUT FRAME fPage6 cFile).
            
            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 73, INPUT "":U).
                APPLY "ENTRY":U TO cFile IN FRAME fPage6.
                RETURN ERROR.
            END.
        END.
        
        
        /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
           apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
           problemas e colocar o focus no campo com problemas */ 
        EMPTY TEMP-TABLE RowErrors NO-ERROR.
        
        IF INPUT FRAME fPage6 cFile = "" THEN DO:
            {utp/ut-liter.i Arquivo_de_sa°da *}
            RUN criaRowErrors IN THIS-PROCEDURE(INPUT 17677,
                                                INPUT RETURN-VALUE).
        END.
        ELSE IF LC(ENTRY(2,INPUT FRAME fPage6 cFile,".")) <> 'xml' THEN DO:
            RUN criaRowErrors IN THIS-PROCEDURE(INPUT 26426,
                                                INPUT '.XML':U).

        END.
        IF CAN-FIND (FIRST rowErrors) THEN DO:
            {method/showmessage.i1}
            /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
            {method/showmessage.i2}
            RETURN "NOK":U.
        END.
                                       
        /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
           para o programa RP.P */    
        CREATE tt-param.
        ASSIGN tt-param.usuario       = c-seg-usuario
               tt-param.destino       = INPUT FRAME fPage6 rsDestiny
               tt-param.data-exec     = TODAY
               tt-param.hora-exec     = TIME
               tt-param.cod-estab-ini = INPUT FRAME fPage2 c-cod-estab-ini
               tt-param.cod-estab-fim = INPUT FRAME fPage2 c-cod-estab-fim
               tt-param.num-carg-ini  = INPUT FRAME fPage2 i-num-carga-ini
               tt-param.num-carg-fim  = INPUT FRAME fPage2 i-num-carga-fim
               tt-param.dt-alter-ini  = INPUT FRAME fPage2 d-data-alter-ini
               tt-param.dt-alter-fim  = INPUT FRAME fPage2 d-data-alter-fim
               tt-param.dt-trans-ini  = INPUT FRAME fPage2 d-data-trans-ini
               tt-param.dt-trans-fim  = INPUT FRAME fPage2 d-data-trans-fim
               tt-param.cod-usuar-ini = INPUT FRAME fPage2 c-cod-usuar-ini
               tt-param.cod-usuar-fim = INPUT FRAME fPage2 c-cod-usuar-fim
               tt-param.imp-param     = l-imp-param:CHECKED IN FRAME fPage6.

        IF tt-param.destino = 1 THEN 
            ASSIGN tt-param.arquivo = "":U.
        ELSE IF tt-param.destino = 2 OR tt-param.destino = 4 THEN
            ASSIGN tt-param.arquivo = INPUT FRAME fPage6 cFile.
        ELSE 
            ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.
        
        /*:T Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
           como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */
        
        /*:T Executar do programa RP.P que ir† criar o relat¢rio */
        {report/rpexb.i}
        
        SESSION:SET-WAIT-STATE("GENERAL":U).
        
        {report/rprun.i aqp/aq0506rp.p}
        
        {report/rpexc.i}
        
        SESSION:SET-WAIT-STATE("":U).
        
        {report/rptrm.i}
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnData wReport 
FUNCTION fnData RETURNS DATE
  ( i AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dtAtual      AS INTEGER EXTENT 2 NO-UNDO.
    DEFINE VARIABLE mesAnt       AS INTEGER          NO-UNDO.
    DEFINE VARIABLE anoIni       AS INTEGER          NO-UNDO.
    DEFINE VARIABLE dtDataVigenc AS DATE    EXTENT 2 NO-UNDO.
    
    ASSIGN dtAtual[1] = MONTH(TODAY) /* mes corrente */
           dtAtual[2] = YEAR(TODAY)  /* ano corrente */
           mesant = dtAtual[1] - 1   /* mes anterior */
           anoini = dtAtual[2].      /* ano data inicial vigencia */
    
    /* Se for o mes um, atializa mes anterior com o mes 12*/
    IF dtAtual[1] = 1 THEN
        ASSIGN mesant = 12
               anoini  = dtAtual[2] - 1. /* ano anterior */
    
    ASSIGN dtDataVigenc[1] = DATE(mesant,1,anoini). /* Primeiro dia do mes */
           dtDataVigenc[2] = DATE(dtAtual[1],1,dtAtual[2]) - 1. /* ultimo dia do mes */
    
    RETURN dtDataVigenc[i].

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

