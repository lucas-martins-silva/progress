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
{include/i-prgvrs.i IM0450 2.00.00.001 } /*** 010001 ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0450 MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0450
&GLOBAL-DEFINE Version        2.00.00.001
&GLOBAL-DEFINE VersionLayout  001

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Layout,ParÉmetro,Impress∆o

&GLOBAL-DEFINE PGLAY          YES
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          NO
&GLOBAL-DEFINE PGLOG          YES

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk btIntegra btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   edLayout btEdit
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   btInputFile
&GLOBAL-DEFINE page5Widgets   
&GLOBAL-DEFINE page6Widgets   
&GLOBAL-DEFINE page7Widgets   rsAll rsDestiny btConfigImprDest btDestinyFile rsExecution
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      text-entrada
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      
&GLOBAL-DEFINE page7Text      text-destino text-modo
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    inum-di-ems cInputFile c-usuario c-banco-access
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    
&GLOBAL-DEFINE page7Fields    cDestinyFile
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */
{imp/im0450.i} /* Definiá∆o temp-table tt-param */

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */
DEF VAR raw-param        AS RAW NO-UNDO.
DEF TEMP-TABLE tt-raw-digita
   FIELD raw-digita      AS RAW.

DEF VAR l-ok                             AS LOGICAL             NO-UNDO.
DEF VAR c-arq-digita                     AS CHAR                NO-UNDO.
DEF VAR c-terminal                       AS CHAR                NO-UNDO.
DEF VAR c-rtf                            AS CHAR                NO-UNDO.
DEF VAR c-arq-layout                     AS CHAR                NO-UNDO.      
DEF VAR c-arq-temp                       AS CHAR                NO-UNDO.
DEF VAR c-modelo-default                 AS CHAR                NO-UNDO.
DEF VAR h-boin292                        AS HANDLE              NO-UNDO.
DEF VAR positions                        AS CHAR FORMAT "x(20)" NO-UNDO.
DEF VAR cBarra                           AS CHAR FORMAT "x"     NO-UNDO.
DEF VAR found                            AS INT                 NO-UNDO.
DEF VAR loop                             AS INT                 NO-UNDO.
DEF VAR start                            AS INT                 NO-UNDO.
DEF VAR i-position                       AS INT                 NO-UNDO.
DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE              NO-UNDO.

def stream s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est† rodando no WebEnabler*/
DEF SHARED VAR hWenController AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btIntegra btCancel btHelp2 

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

DEFINE BUTTON btIntegra 
     LABEL "Integraá∆o" 
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
     SIZE 82.14 BY 11.42
     FONT 2 NO-UNDO.

DEFINE BUTTON btInputFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cInputFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE c-banco-access AS CHARACTER FORMAT "x(40)":U 
     LABEL "Banco Access" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-usuario AS CHARACTER FORMAT "x(40)":U 
     VIEW-AS FILL-IN 
     SIZE 31.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-usuario AS CHARACTER FORMAT "x(20)":U 
     LABEL "Usu†rio Recebimento" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE inum-di-ems AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Nr.DI EMS" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88 NO-UNDO.

DEFINE VARIABLE text-entrada AS CHARACTER FORMAT "X(256)":U INITIAL "Arquivo Siscomex:" 
      VIEW-AS TEXT 
     SIZE 13 BY .88
     FONT 1 NO-UNDO.

DEFINE BUTTON btConfigImprDest 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btDestinyFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cDestinyFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsAll AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Rejeitados", 2
     SIZE .14 BY .79
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

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47.14 BY 1.71.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 2.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btIntegra AT ROW 16.75 COL 12.14 WIDGET-ID 2
     btCancel AT ROW 16.75 COL 22.29
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     inum-di-ems AT ROW 4.25 COL 25 COLON-ALIGNED HELP
          "N£mero Declaraá∆o de Importaá∆o EMS" WIDGET-ID 2
     cInputFile AT ROW 5.25 COL 27 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btInputFile AT ROW 5.25 COL 67 HELP
          "Escolha do nome do arquivo"
     c-usuario AT ROW 6.25 COL 25 COLON-ALIGNED HELP
          "Usu†rio Recebimento" WIDGET-ID 4
     c-nome-usuario AT ROW 6.25 COL 37.14 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     c-banco-access AT ROW 7.25 COL 25 COLON-ALIGNED HELP
          "Banco Access" WIDGET-ID 8
     text-entrada AT ROW 5.25 COL 14 NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 5.14 ROW 2.79
         SIZE 83.29 BY 12.71
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage7
     rsDestiny AT ROW 2.42 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     btConfigImprDest AT ROW 3.58 COL 43.29 HELP
          "Configuraá∆o da impressora"
     btDestinyFile AT ROW 3.63 COL 43.29 HELP
          "Escolha do nome do arquivo"
     cDestinyFile AT ROW 3.67 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.79 COL 3.14 HELP
          "Modo de Execuá∆o" NO-LABEL
     rsAll AT ROW 5.96 COL 41 NO-LABEL
     text-destino AT ROW 1.67 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5.04 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-10 AT ROW 5.33 COL 2
     RECT-8 AT ROW 1.96 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 5.14 ROW 2.79
         SIZE 83.29 BY 12.71
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fPage1
     edLayout AT ROW 1.08 COL 1.43 NO-LABEL
     btEdit AT ROW 12.5 COL 1 HELP
          "Dispara a Impress∆o do Layout"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 5.14 ROW 2.79
         SIZE 83.29 BY 12.71
         FONT 1 WIDGET-ID 100.


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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage7:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage1
                                                                        */
ASSIGN 
       edLayout:RETURN-INSERTED IN FRAME fPage1  = TRUE
       edLayout:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FILL-IN text-entrada IN FRAME fPage4
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-entrada:PRIVATE-DATA IN FRAME fPage4     = 
                "Arquivo Siscomex:".

/* SETTINGS FOR FRAME fPage7
                                                                        */
ASSIGN 
       rsAll:HIDDEN IN FRAME fPage7           = TRUE.

ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage7     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage7     = 
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage7
/* Query rebuild information for FRAME fPage7
     _Query            is NOT OPENED
*/  /* FRAME fPage7 */
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


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME btConfigImprDest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImprDest wReport
ON CHOOSE OF btConfigImprDest IN FRAME fPage7
DO:
   {report/imimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDestinyFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDestinyFile wReport
ON CHOOSE OF btDestinyFile IN FRAME fPage7
DO:
    {report/imarq.i cDestinyFile fPage7}
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


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btIntegra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIntegra wReport
ON CHOOSE OF btIntegra IN FRAME fpage0 /* Integraá∆o */
DO:
    DEF VARIABLE comm-line AS CHARACTER FORMAT "x(70)".
    DEF VARIABLE v-caminho AS CHARACTER FORMAT "x(70)".
    DEF VARIABLE v-docto AS CHARACTER FORMAT "x(70)".
    DEF VARIABLE i AS INTEGER NO-UNDO.    

    ASSIGN INPUT FRAME fpage4 cInputFile
           INPUT FRAME fpage4 c-banco-access.
   
    do on error undo, return no-apply:
       run piverificabanco.
    end.
  
    v-caminho = PROPATH.
    repeat i = 1 to 10:
        v-docto = ENTRY(i,v-caminho) + '~\imp~\im0450ac.exe' no-error.
        assign file-info:file-name = v-docto.
        if file-info:pathname <> ? then do:        
           ASSIGN comm-line = v-docto.
           leave.
        end.
    END.
    ASSIGN comm-line = comm-line + " " + cInputFile + " " + c-banco-access.
    OS-COMMAND SILENT VALUE (comm-line).
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
&Scoped-define SELF-NAME c-usuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-usuario wReport
ON F5 OF c-usuario IN FRAME fPage4 /* Usu†rio Recebimento */
DO:
    {include/zoomvar.i &prog-zoom="inZoom/z01in292.w"
                       &campo=c-usuario
                       &campozoom=usuario
                       &campo2=c-nome-usuario
                       &campozoom=nome
                       &FRAME="fPage4"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-usuario wReport
ON LEAVE OF c-usuario IN FRAME fPage4 /* Usu†rio Recebimento */
DO:
    /*VALIDAÄ«O USUµRIO*/ 
    RUN gotokey IN h-boin292 (INPUT INPUT FRAME fpage4 c-usuario).
    IF  RETURN-VALUE = "OK" THEN DO:
        RUN getcharField IN h-boin292 (INPUT "nome", OUTPUT c-nome-usuario).
        DISP c-nome-usuario WITH FRAME fpage4.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-usuario wReport
ON MOUSE-SELECT-DBLCLICK OF c-usuario IN FRAME fPage4 /* Usu†rio Recebimento */
DO:
    APPLY 'F5' TO SELF.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME inum-di-ems
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL inum-di-ems wReport
ON F5 OF inum-di-ems IN FRAME fPage4 /* Nr.DI EMS */
DO:
    {method/zoomfields.i &ProgramZoom="cxzoom/z01cx400.w"
                         &FieldZoom1="num-di-ems"
                         &FieldScreen1="inum-di-ems"
                         &Frame1="fPage4"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL inum-di-ems wReport
ON MOUSE-SELECT-DBLCLICK OF inum-di-ems IN FRAME fPage4 /* Nr.DI EMS */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage7
DO:
do  with frame fPage7:
    case self:screen-value:
        when "1" then do:
            assign cDestinyFile:sensitive     = no
                   cDestinyFile:visible       = yes
                   btDestinyFile:visible      = no
                   btConfigImprDest:visible   = yes.
        end.
        when "2" then do:
            assign cDestinyFile:sensitive     = yes
                   cDestinyFile:visible       = yes
                   btDestinyFile:visible      = yes
                   btConfigImprDest:visible   = no.
        end.
        when "3" then do:
            assign cDestinyFile:sensitive     = no
                   cDestinyFile:visible       = no
                   btDestinyFile:visible      = no
                   btConfigImprDest:visible   = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage7
DO:
   {report/imrse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

inum-di-ems:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage4.
c-usuario:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage4.

{report/mainblock.i}

ON "~\" OF cInputFile IN FRAME fPage4 DO:
    APPLY "/" TO cInputFile IN FRAME fPage4.
    RETURN NO-APPLY.
END.

ON "~\" OF c-banco-access IN FRAME fPage4 DO:
    APPLY "/" TO c-banco-access IN FRAME fPage4.
    RETURN NO-APPLY.
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
    IF VALID-HANDLE(h-boin292) THEN DO:
        DELETE PROCEDURE h-boin292.
        ASSIGN h-boin292 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    /*---[ Verifica se o DBO j† est† inicializado ]---*/
    IF  NOT VALID-HANDLE(h-boin292) THEN RUN inbo/boin292.p PERSISTENT SET h-boin292. /* usu†rio */
    RUN openQueryStatic IN h-boin292 (INPUT "Main":U) NO-ERROR.
    
    /*---[ Seta primeira tela ]---*/
    RUN setFolder IN hFolder (INPUT 2).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

DEF VAR c-arq-conv AS CHAR NO-UNDO.

do  on error undo, return error
    on stop  undo, return error:     
    
    {report/rpexa.i}

    ASSIGN input frame fPage4 cInputFile.

    DO  loop = 1 TO 2:
        positions = "".
        cBarra = SUBSTRING("~\/",loop,1).
        start  = 1.
        found  = INDEX(cInputFile,cBarra,start).
        DO  WHILE found > 0:
            positions = positions + STRING(found).
            start     = found + 1.
            found     = INDEX(cInputFile,cBarra,start).
        END. /* DO  WHILE found > 0: */
    END. /* DO  loop = 1 TO 2: */

    assign c-arq-aux = input frame fpage4 cInputFile
           c-arq-aux = replace(c-arq-aux, "/":U, "~\":U).

    if  r-index(c-arq-aux, "~\":U) > 0 then do:
        assign file-info:file-name = substring(c-arq-aux,1,r-index(c-arq-aux, "~\":U)).
        if  file-info:pathname = ? 
        or substr(file-info:file-type,1,1) <> "D":U then do:
            run utp/ut-msgs.p (input "show":U, input 19375, input cInputFile).
            apply "ENTRY":U to cInputFile in frame fPage4.
            return error.
        end.
    end.
    assign file-info:file-name = c-arq-aux.

    /*---[ VALIDAÄ«O DI ]-------------------------------------------------------------*/ 
    IF  NOT CAN-FIND(FIRST decla-import
                     WHERE decla-import.num-di-ems = INPUT FRAME fpage4 inum-di-ems) THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Declaraá∆o_de_Importaá∆o" *}
        RUN utp/ut-msgs.p (INPUT "show", INPUT 2, INPUT RETURN-VALUE).
        APPLY "ENTRY":U TO inum-di-ems IN FRAME fPage4.
        RETURN ERROR.
    END. /* IF  NOT CAN-FIND(FIRST decla-import */

    /*---[ VALIDAÄ«O USUµRIO ]--------------------------------------------------------*/ 
    RUN gotokey IN h-boin292 (INPUT INPUT FRAME fpage4 c-usuario).
    IF  RETURN-VALUE <> "OK" THEN DO:
        run utp/ut-msgs.p (input "show", input 6110, input "").
        apply "ENTRY":U to c-usuario in frame fPage4.
        return error.
    END. /* IF  RETURN-VALUE <> "OK" THEN DO: */

    CREATE tt-param.
    ASSIGN tt-param.destino      = INPUT FRAME fPage7 rsDestiny
           tt-param.arq-entrada  = INPUT FRAME fPage4 cInputFile
           tt-param.data-exec    = TODAY
           tt-param.hora-exec    = TIME
           tt-param.usuario      = INPUT FRAME fPage4 c-usuario
           tt-param.nome-usuario = INPUT FRAME fPage4 c-nome-usuario
           tt-param.banco-access = INPUT FRAME fPage4 c-banco-access
           tt-param.num-di-ems   = INPUT FRAME fPage4 inum-di-ems.
    
    if  tt-param.destino = 1 
    then assign tt-param.arq-destino = "".
    else if  tt-param.destino = 2 
         then assign tt-param.arq-destino = input frame fPage7 cDestinyFile.
         else assign tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    IF  tt-param.arq-destino <> "" THEN ASSIGN tt-param.arq-destino = REPLACE(tt-param.arq-destino, "\":U, "~/":U).
    
    {report/imexb.i}
    
    if  session:set-wait-state("GENERAL":U) then.

    {report/imrun.i imp/im0450rp.p}

    {report/imexc.i}

    if  session:set-wait-state("") then.

    {report/imtrm.i tt-param.arq-destino tt-param.destino}

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piverificabanco wReport 
PROCEDURE piverificabanco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Implementado a verificaá∆o do banco de dados Access. */

IF SEARCH(c-banco-access) = ? THEN DO:
   run utp/ut-msgs.p (input "show":U,
                      input 19377,
                      input c-banco-access).
   apply "ENTRY":U to c-banco-access in frame fPage4.
   return error.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

