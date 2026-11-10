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
{include/i-prgvrs.i AF0311 2.00.00.001}  /*** 010001 ***/
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
&GLOBAL-DEFINE Program        AF0311
&GLOBAL-DEFINE Version        2.00.00.001
&GLOBAL-DEFINE VersionLayout  001

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Layout,ParÉmetro,Log

&GLOBAL-DEFINE PGLAY          YES
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   edLayout ~
                              btEdit

&GLOBAL-DEFINE page4Widgets   btInputFile btInputFile-2

&GLOBAL-DEFINE page6Widgets   rsAll ~
                              rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution

&GLOBAL-DEFINE page4Text      text-entrada text-entrada-2
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-imprime text-destino text-exec

  
&GLOBAL-DEFINE page4Fields    cInputFile cInputFile-2 nr-periodo
&GLOBAL-DEFINE page6Fields    cFile
   

/* Parameters Definitions ---                                           */
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD execucao         AS INTEGER
    FIELD todos            AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(60)":U
    FIELD usuario          AS CHAR FORMAT "x(12)":U
    FIELD arq-entrada      AS CHAR FORMAT "x(60)":U
    FIELD arq-destino      AS CHAR FORMAT "x(60)":U
    FIELD arq-erro         AS CHAR FORMAT "x(60)":U
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD i-periodo        AS INTEGER.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

define buffer b-tt-digita for tt-digita.
  
/* Transfer Definitions */

DEF VAR raw-param        AS RAW NO-UNDO.

DEF TEMP-TABLE tt-raw-digita
   FIELD raw-digita      AS RAW.

DEF VAR l-ok               AS LOGICAL NO-UNDO.
DEF VAR c-arq-digita       AS CHAR    NO-UNDO.
DEF VAR c-terminal         AS CHAR    NO-UNDO.
DEF VAR c-rtf              AS CHAR    NO-UNDO.
DEF VAR c-arq-layout       AS CHAR    NO-UNDO.      
DEF VAR c-arq-temp         AS CHAR    NO-UNDO.
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.

DEF STREAM s-imp.

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

DEFINE BUTTON btEdit 
     LABEL "Editar Layout" 
     SIZE 20 BY 1
     FONT 1.

DEFINE VARIABLE edLayout AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 84 BY 11.5
     FONT 2 NO-UNDO.

DEFINE BUTTON btInputFile 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btInputFile-2 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cInputFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 50
     SIZE 40 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE cInputFile-2 AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE nr-periodo AS INTEGER FORMAT ">9":U INITIAL 1 
     LABEL "Nr Per°odos" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE text-entrada AS CHARACTER FORMAT "X(256)":U INITIAL "Arquivo de Entrada" 
      VIEW-AS TEXT 
     SIZE 14.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-entrada-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Arquivo de Registros Inconsistentes" 
      VIEW-AS TEXT 
     SIZE 25 BY .63
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.14 BY 2.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.14 BY 2.

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
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-exec AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-imprime AS CHARACTER FORMAT "X(256)":U INITIAL "Imprime" 
      VIEW-AS TEXT 
     SIZE 9 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsAll AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Rejeitados", 2
     SIZE 34 BY .79
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

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47 BY 1.71.

DEFINE RECTANGLE rect-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47 BY 1.71.

DEFINE RECTANGLE rect-rtf-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.14 BY 3.21.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.29 BY 17
         FONT 1.

DEFINE FRAME fPage6
     rsAll AT ROW 2.25 COL 3.14 NO-LABEL
     rsDestiny AT ROW 4.5 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     cFile AT ROW 5.75 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 5.71 COL 43.14 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 5.71 COL 43.14 HELP
          "Configuraá∆o da impressora"
     rsExecution AT ROW 8.25 COL 3.14 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-imprime AT ROW 1.5 COL 2 COLON-ALIGNED NO-LABEL
     text-destino AT ROW 3.75 COL 1.86 COLON-ALIGNED NO-LABEL
     text-exec AT ROW 7.5 COL 2 COLON-ALIGNED NO-LABEL
     RECT-11 AT ROW 1.75 COL 2
     rect-8 AT ROW 7.79 COL 2
     rect-rtf-2 AT ROW 4.04 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage4
     cInputFile AT ROW 3.92 COL 20.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btInputFile AT ROW 3.92 COL 60.14 HELP
          "Escolha do nome do arquivo"
     cInputFile-2 AT ROW 6.79 COL 20.14 HELP
          "Nome do arquivo para geraá∆o dos registros inconsistentes" NO-LABEL
     btInputFile-2 AT ROW 6.75 COL 60.14 HELP
          "Escolha do nome do arquivo"
     nr-periodo AT ROW 8.71 COL 28 COLON-ALIGNED
     text-entrada AT ROW 2.83 COL 21 NO-LABEL
     text-entrada-2 AT ROW 5.67 COL 21 NO-LABEL
     RECT-12 AT ROW 3.13 COL 19
     RECT-13 AT ROW 5.96 COL 19
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.83
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage1
     edLayout AT ROW 1.25 COL 1 NO-LABEL
     btEdit AT ROW 12.88 COL 1 HELP
          "Dispara a Impress∆o do Layout"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.96
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
         WIDTH              = 91.29
         MAX-HEIGHT         = 27.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.21
         VIRTUAL-WIDTH      = 146.29
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage1
                                                                        */
ASSIGN 
       edLayout:RETURN-INSERTED IN FRAME fPage1  = TRUE
       edLayout:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FRAME fPage4
   Custom                                                               */
/* SETTINGS FOR FILL-IN text-entrada IN FRAME fPage4
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-entrada:PRIVATE-DATA IN FRAME fPage4     = 
                "Arquivo de Entrada".

/* SETTINGS FOR FILL-IN text-entrada-2 IN FRAME fPage4
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-entrada-2:PRIVATE-DATA IN FRAME fPage4     = 
                "Arquivo de Registros Inconsistentes".

/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-exec:PRIVATE-DATA IN FRAME fPage6     = 
                "Execuá∆o".

ASSIGN 
       text-imprime:PRIVATE-DATA IN FRAME fPage6     = 
                "Imprime".

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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btEdit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEdit wReport
ON CHOOSE OF btEdit IN FRAME fPage1 /* Editar Layout */
DO:
   {report/imedl.i}
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
&Scoped-define SELF-NAME btInputFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInputFile wReport
ON CHOOSE OF btInputFile IN FRAME fPage4
DO:
    {report/imarq.i cInputFile fPage4}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btInputFile-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInputFile-2 wReport
ON CHOOSE OF btInputFile-2 IN FRAME fPage4
DO:
    {include/i-imarq.i cInputFile-2 fPage4}
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
            assign cFile:sensitive     = no
                   cFile:visible       = yes
                   btFile:visible      = no
                   btConfigImpr:visible   = yes.
        end.
        when "2":U then do:
            assign cFile:sensitive     = yes
                   cFile:visible       = yes
                   btFile:visible      = yes
                   btConfigImpr:visible   = no.
        end.
        when "3":U then do:
            assign cFile:sensitive     = no
                   cFile:visible       = no
                   btFile:visible      = no
                   btConfigImpr:visible   = no.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN cInputFile-2:SCREEN-VALUE IN FRAME fPage4 = replace(session:TEMP-DIRECTORY + "log.lst":U,"~\","/") .

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

DEFINE VAR r-tt-digita AS ROWID NO-UNDO.

&IF DEFINED(PGIMP) <> 0 &THEN
/*:T** Relatorio ***/ 
    DO ON ERROR UNDO, RETURN ERROR ON STOP  UNDO, RETURN ERROR:
        {report/rpexa.i}
    
        IF  INPUT FRAME fPage6 rsDestiny = 2 AND
            INPUT FRAME fPage6 rsExecution = 1 THEN DO:
            RUN utp/ut-vlarq.p (INPUT INPUT FRAME fPage6 cFile).
            IF  RETURN-VALUE = "NOK":U THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 73,
                                   INPUT "":U).
                APPLY "ENTRY":U TO cFile IN FRAME fPage6.                   
                RETURN ERROR.
            END.
        END.
        
        ASSIGN FILE-INFO:FILE-NAME = INPUT FRAME fPage4 cInputFile.
        IF  FILE-INFO:PATHNAME = ? AND
            INPUT FRAME fPage6 rsExecution = 1 THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 326,
                               INPUT INPUT FRAME fPage4 cInputFile).
            APPLY "ENTRY":U TO cInputFile IN FRAME fPage4.
            RETURN ERROR.
        END.

        /*
        ASSIGN FILE-INFO:FILE-NAME = INPUT FRAME fPage4 cInputFile-2.
        IF  FILE-INFO:PATHNAME = ? AND
            INPUT FRAME fPage6 rsExecution = 1 THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 5749,
                               INPUT INPUT FRAME fPage4 cInputFile-2).                               
            APPLY "ENTRY":U TO cInputFile-2 IN FRAME fPage4.                
            RETURN ERROR.
        END. 
         */
        /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
           para o programa RP.P */
        
        CREATE tt-param.
        ASSIGN tt-param.usuario         = c-seg-usuario
               tt-param.destino         = input frame fPage6 rsDestiny
               tt-param.todos           = INPUT FRAME fPage6 rsAll
               tt-param.data-exec       = TODAY
               tt-param.hora-exec       = TIME
               tt-param.arq-entrada     = INPUT FRAME fPage4 cInputFile
               tt-param.arq-erro        = INPUT FRAME fPage4 cInputFile-2
               tt-param.i-periodo       = INPUT FRAME fPage4 nr-periodo.

            if tt-param.destino = 1 
            then assign tt-param.arquivo = "".
            else if  tt-param.destino = 2 
                 then assign tt-param.arquivo = input frame fPage6 cFile.
                 else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".

        
        /*:T Executar do programa RP.P que ir† criar o relat¢rio */
        {report/rpexb.i}

        SESSION:SET-WAIT-STATE("general":U).
        
        {report/rprun.i afp/af0311rp.p}
        
        {report/rpexc.i}
        
        SESSION:SET-WAIT-STATE("":U).
        
        {report/rptrm.i}

        
    END.
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

