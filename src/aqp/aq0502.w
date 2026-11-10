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
{include/i-prgvrs.i AQ0502 2.00.00.006 } /*** 010006 ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0502 MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AQ0502
&GLOBAL-DEFINE Version        2.00.00.006
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o,ParÉmetros,Impress∆o

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

&GLOBAL-DEFINE page4Widgets  l-somente-pto-coletivo ~
                             l-somente-produt-respons ~
                             l-inativos

&GLOBAL-DEFINE page6Widgets   btConfigImpr ~
                              btFile ~
                              rsExecution ~
                              rsDestiny
     
&GLOBAL-DEFINE page2Text
&GLOBAL-DEFINE page4Text     
&GLOBAL-DEFINE page6Text      text-destino text-modo

   
&GLOBAL-DEFINE page2Fields  c-cod-pto-coleta-ini   ~
                            c-cod-pto-coleta-fim   ~
                            c-cod-propried-ini     ~
                            c-cod-propried-fim     ~
                            i-cdn-produt-rural-ini ~
                            i-cdn-produt-rural-fim ~
                            c-cod-rota-ini         ~
                            c-cod-rota-fim
                          

&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page6Fields    cFile

 

/* Parameters Definitions and Transfer Definitions ---*/

{aqp/aq0502.i} /* tt-param, tt-digita, tt-raw-digita */ 
    
DEFINE BUFFER b-tt-digita FOR tt-digita.

DEFINE VARIABLE raw-param          AS RAW       NO-UNDO.
DEFINE VARIABLE l-ok               AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-arq-digita       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-terminal         AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-rtf              AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-arq-layout       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-arq-temp         AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-modelo-default   AS CHARACTER NO-UNDO.

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

DEFINE VARIABLE c-cod-propried-fim LIKE propried-rural.cod-propried
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-propried-ini LIKE propried-rural.cod-propried
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-pto-coleta-fim LIKE pto-coleta.cod-pto-coleta
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-pto-coleta-ini LIKE pto-coleta.cod-pto-coleta
     LABEL "Ponto Coleta" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-rota-fim LIKE carg-rural.cod-rota
     VIEW-AS FILL-IN 
     SIZE 14.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-rota-ini LIKE carg-rural.cod-rota
     LABEL "Rota" 
     VIEW-AS FILL-IN 
     SIZE 14.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-produt-rural-fim LIKE propried-rural.cdn-produt-rural
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-produt-rural-ini LIKE propried-rural.cdn-produt-rural
     LABEL "Produtor" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE l-inativos AS LOGICAL INITIAL no 
     LABEL "Listar Inativos" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-somente-produt-respons AS LOGICAL INITIAL no 
     LABEL "Listar somente produtor respons†vel" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-somente-pto-coletivo AS LOGICAL INITIAL no 
     LABEL "Listar somente pontos coletivos" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY 1
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
     SIZE 44.86 BY .88
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
     SIZE 48.86 BY 1.08
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
     SIZE 51.86 BY 2.92.

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
         FONT 1 .

DEFINE FRAME fPage4
     l-somente-pto-coletivo AT ROW 3.25 COL 11
     l-somente-produt-respons AT ROW 4.25 COL 11
     l-inativos AT ROW 5.25 COL 11 
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.46
         FONT 1 .

DEFINE FRAME fPage2
     c-cod-pto-coleta-ini AT ROW 4.38 COL 22.86 COLON-ALIGNED HELP
          "C¢digo Ponto Coleta"
          LABEL "Ponto Coleta"
     c-cod-pto-coleta-fim AT ROW 4.38 COL 48 COLON-ALIGNED HELP
          "C¢digo Ponto Coleta" NO-LABEL 
     c-cod-propried-ini AT ROW 5.38 COL 22.86 COLON-ALIGNED HELP
          "C¢digo Propriedade"
     c-cod-propried-fim AT ROW 5.38 COL 48 COLON-ALIGNED HELP
          "C¢digo Propriedade" NO-LABEL
     i-cdn-produt-rural-ini AT ROW 6.38 COL 22.86 COLON-ALIGNED HELP
          "Produtor Rural"
          LABEL "Produtor"
     i-cdn-produt-rural-fim AT ROW 6.38 COL 48 COLON-ALIGNED HELP
          "Produtor Rural" NO-LABEL
     c-cod-rota-ini AT ROW 7.38 COL 22.86 COLON-ALIGNED HELP
          "C¢digo da rota"
          LABEL "Rota"
     c-cod-rota-fim AT ROW 7.38 COL 48 COLON-ALIGNED HELP
          "C¢digo da rota" NO-LABEL
     IMAGE-1 AT ROW 4.38 COL 40.14
     IMAGE-2 AT ROW 4.38 COL 46.86
     IMAGE-9 AT ROW 5.38 COL 40.14 
     IMAGE-10 AT ROW 5.38 COL 46.86 
     IMAGE-11 AT ROW 6.38 COL 40.14 
     IMAGE-12 AT ROW 6.38 COL 46.86 
     IMAGE-13 AT ROW 7.38 COL 40.14 
     IMAGE-14 AT ROW 7.38 COL 46.86 
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 84.43 BY 12.5
         FONT 1 .

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 48.72 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 49 HELP
          "Configuraá∆o da impressora"
     rsExecution AT ROW 9.5 COL 2.86 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 8.75 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 9 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1 .


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
  NOT-VISIBLE,                                                          */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-propried-fim IN FRAME fPage2
   LIKE = mgind.propried-rural.cod-propried EXP-LABEL EXP-SIZE          */
/* SETTINGS FOR FILL-IN c-cod-propried-ini IN FRAME fPage2
   LIKE = mgind.propried-rural.cod-propried EXP-SIZE                    */
/* SETTINGS FOR FILL-IN c-cod-pto-coleta-fim IN FRAME fPage2
   LIKE = mgind.pto-coleta.cod-pto-coleta EXP-LABEL EXP-SIZE            */
/* SETTINGS FOR FILL-IN c-cod-pto-coleta-ini IN FRAME fPage2
   LIKE = mgind.pto-coleta.cod-pto-coleta EXP-LABEL EXP-SIZE            */
/* SETTINGS FOR FILL-IN c-cod-rota-fim IN FRAME fPage2
   LIKE = movind.carg-rural.cod-rota EXP-LABEL EXP-SIZE                 */
/* SETTINGS FOR FILL-IN c-cod-rota-ini IN FRAME fPage2
   LIKE = movind.carg-rural.cod-rota EXP-LABEL EXP-SIZE                 */
/* SETTINGS FOR FILL-IN i-cdn-produt-rural-fim IN FRAME fPage2
   LIKE = mgind.propried-rural.cdn-produt-rural EXP-LABEL               */
/* SETTINGS FOR FILL-IN i-cdn-produt-rural-ini IN FRAME fPage2
   LIKE = mgind.propried-rural.cdn-produt-rural EXP-LABEL               */
/* SETTINGS FOR FRAME fPage4
                                                                        */
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
   DO ON ERROR UNDO, RETURN NO-APPLY:
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
    ASSIGN c-cod-pto-coleta-fim   = FILL("Z", 12)
           c-cod-propried-fim     = FILL("Z", 16)
           i-cdn-produt-rural-fim = INT(FILL("9", 9))
           c-cod-rota-fim         = FILL("Z", 12).

    DISPLAY c-cod-pto-coleta-fim 
            c-cod-propried-fim   
            i-cdn-produt-rural-fim
            c-cod-rota-fim  
            WITH FRAME fPage2.

    ASSIGN rsDestiny = 4
           rsDestiny:SENSITIVE IN FRAME fPage6 = NO
           btConfigImpr:SENSITIVE IN FRAME fPage6 = NO.

    DISPLAY rsDestiny btConfigImpr
            WITH FRAME fPage6.

    APPLY 'VALUE-CHANGED' TO rsDestiny IN FRAME fPage6.

    IF VALID-HANDLE(hFolder) THEN
        RUN setFolder IN hFolder (INPUT 1).


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
        
        CREATE tt-param.
        ASSIGN tt-param.destino                  = INPUT FRAME fPage6 rsDestiny             
               tt-param.usuario                  = c-seg-usuario
               tt-param.data-exec                = TODAY
               tt-param.hora-exec                = TIME
               tt-param.cod-pto-coleta-ini       = INPUT FRAME fPage2 c-cod-pto-coleta-ini  
               tt-param.cod-pto-coleta-fim       = INPUT FRAME fPage2 c-cod-pto-coleta-fim  
               tt-param.cod-propried-ini         = INPUT FRAME fPage2 c-cod-propried-ini    
               tt-param.cod-propried-fim         = INPUT FRAME fPage2 c-cod-propried-fim    
               tt-param.cdn-produt-rural-ini     = INPUT FRAME fPage2 i-cdn-produt-rural-ini
               tt-param.cdn-produt-rural-fim     = INPUT FRAME fPage2 i-cdn-produt-rural-fim
               tt-param.cod-rota-ini             = INPUT FRAME fPage2 c-cod-rota-ini        
               tt-param.cod-rota-fim             = INPUT FRAME fPage2 c-cod-rota-fim        
               tt-param.l-somente-pto-coletivo   = INPUT FRAME fPage4 l-somente-pto-coletivo
               tt-param.l-somente-produt-respons = INPUT FRAME fPage4 l-somente-produt-respons
               tt-param.l-inativos               = INPUT FRAME fPage4 l-inativos.
             
        IF tt-param.destino = 1 THEN 
            ASSIGN tt-param.arquivo = "":U.
        ELSE IF tt-param.destino = 2 THEN 
            ASSIGN tt-param.arquivo = INPUT FRAME fPage6 cFile.
        ELSE 
            ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.       

        {report/rpexb.i}
        
        SESSION:SET-WAIT-STATE("GENERAL":U).
        
        {report/rprun.i aqp/AQ0502rp.p}
        
        {report/rpexc.i}
        
        SESSION:SET-WAIT-STATE("":U).
        
        {report/rptrm.i}
        
        
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

