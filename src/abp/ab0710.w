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
{include/i-prgvrs.i AB0710 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0710 MAB}
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

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0710
&GLOBAL-DEFINE Version        2.00.00.000
&GLOBAL-DEFINE VersionLayout  001

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   ParÉmetro,Log

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          NO
&GLOBAL-DEFINE PGLOG          YES

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   btInputFolder /*btInputFolder-2*/ t-diretorio
&GLOBAL-DEFINE page5Widgets   
&GLOBAL-DEFINE page6Widgets   
&GLOBAL-DEFINE page7Widgets   rsAll ~
                              rsDestiny ~
                              btConfigImprDest ~
                              btDestinyFile ~
                              rsExecution
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      text-entrada text-entrada-2
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      
&GLOBAL-DEFINE page7Text      text-imprime text-destino text-modo
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    cInputFolder cInputFolder-2
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    
&GLOBAL-DEFINE page7Fields    cDestinyFile
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */

{abp/ab0710.i}

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

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

DEFINE BUTTON btInputFolder 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cInputFile AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 256
     SIZE 2 BY .88
     BGCOLOR 15 FONT 1.

DEFINE VARIABLE cInputFolder AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 71 BY .88 NO-UNDO.

DEFINE VARIABLE cInputFolder-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 71 BY .88 NO-UNDO.

DEFINE VARIABLE text-entrada AS CHARACTER FORMAT "X(256)":U INITIAL "Diret¢rio de Entrada" 
      VIEW-AS TEXT 
     SIZE 14.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-entrada-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Diret¢rio Padr∆o" 
      VIEW-AS TEXT 
     SIZE 19 BY .63
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79 BY 2.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79 BY 2.

DEFINE VARIABLE t-diretorio AS LOGICAL INITIAL no 
     LABEL "Informa diret¢rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE BUTTON btConfigImprDest 
     IMAGE-UP FILE "image/im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btDestinyFile 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
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

DEFINE VARIABLE text-imprime AS CHARACTER FORMAT "X(256)":U INITIAL "Imprime" 
      VIEW-AS TEXT 
     SIZE 9 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .63
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
     SIZE 46.14 BY 2.96.


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
         FONT 1.

DEFINE FRAME fPage4
     cInputFolder-2 AT ROW 2.5 COL 1 COLON-ALIGNED NO-LABEL
     cInputFile AT ROW 5.75 COL 45 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     t-diretorio AT ROW 7.29 COL 4
     cInputFolder AT ROW 9.75 COL 1 COLON-ALIGNED NO-LABEL
     btInputFolder AT ROW 9.75 COL 75 HELP
          "Escolha do nome do arquivo"
     text-entrada-2 AT ROW 1.5 COL 4 NO-LABEL
     text-entrada AT ROW 8.75 COL 4.14 NO-LABEL
     RECT-12 AT ROW 9 COL 2
     RECT-13 AT ROW 1.75 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage7
     rsAll AT ROW 2.25 COL 3.14 NO-LABEL
     rsDestiny AT ROW 4.5 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     btConfigImprDest AT ROW 5.71 COL 43.14 HELP
          "Configuraá∆o da impressora"
     btDestinyFile AT ROW 5.71 COL 43.14 HELP
          "Escolha do nome do arquivo"
     cDestinyFile AT ROW 5.75 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 7.88 COL 3.14 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-imprime AT ROW 1.5 COL 2 COLON-ALIGNED NO-LABEL
     text-destino AT ROW 3.75 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 7.13 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-11 AT ROW 1.75 COL 2
     rect-8 AT ROW 7.42 COL 2
     rect-rtf-2 AT ROW 4.04 COL 2
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
       FRAME fPage7:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR EDITOR cInputFile IN FRAME fPage4
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       cInputFile:HIDDEN IN FRAME fPage4           = TRUE.

/* SETTINGS FOR FILL-IN text-entrada IN FRAME fPage4
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-entrada:PRIVATE-DATA IN FRAME fPage4     = 
                "Diret¢rio de Entrada".

/* SETTINGS FOR FILL-IN text-entrada-2 IN FRAME fPage4
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-entrada-2:PRIVATE-DATA IN FRAME fPage4     = 
                "Diret¢rio Padr∆o".

/* SETTINGS FOR FRAME fPage7
                                                                        */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage7     = 
                "Destino".

ASSIGN 
       text-imprime:PRIVATE-DATA IN FRAME fPage7     = 
                "Imprime".

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
&Scoped-define SELF-NAME btInputFolder
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInputFolder wReport
ON CHOOSE OF btInputFolder IN FRAME fPage4
DO:
    DEFINE VARIABLE l-cancelado AS LOGICAL    NO-UNDO.
    {utp/ut-liter.i Diret¢rio_de_Exportaá∆o *}
    run utp/ut-dir.p (input RETURN-VALUE,
                      output cInputFolder,
                      output l-cancelado).

    ASSIGN cInputFolder = REPLACE(cInputFolder,"/","/").

    IF l-cancelado = NO THEN
        DISP cInputFolder WITH FRAME fPage4.

    APPLY "leave":U TO cInputFolder IN FRAME fPage4.
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


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage7
DO:
do  with frame fPage7:
    case self:screen-value:
        when "1":U then do:
            assign cDestinyFile:sensitive     = no
                   cDestinyFile:visible       = yes
                   btDestinyFile:visible      = no
                   btConfigImprDest:visible   = yes.
        end.
        when "2":U then do:
            assign cDestinyFile:sensitive     = yes
                   cDestinyFile:visible       = yes
                   btDestinyFile:visible      = yes
                   btConfigImprDest:visible   = no.
        end.
        when "3":U then do:
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME t-diretorio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-diretorio wReport
ON VALUE-CHANGED OF t-diretorio IN FRAME fPage4 /* Informa diret¢rio */
DO:
  ASSIGN t-diretorio.
  IF t-diretorio = YES THEN DO:
     ASSIGN cInputFolder:SENSITIVE IN FRAME fPage4   = YES
            btInputFolder:SENSITIVE IN FRAME fPage4  = YES.
  END.
  ELSE DO:
        ASSIGN cInputFolder:SENSITIVE IN FRAME fPage4 = NO
               btInputFolder:SENSITIVE IN FRAME fPage4 = NO
               cInputFolder:SCREEN-VALUE IN FRAME fPage4 = "".
  END.


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
/*Alterado 17/02/2005 - tech1007 - Foi criado essa procedure para que seja realizado a inicializaá∆o
  correta dos componentes do RTF quando executado em ambiente local e no WebEnabler.*/
 DEFINE VARIABLE c-catalogo AS CHARACTER  NO-UNDO.

for first mab-param-integr
    where mab-param-integr.cdn-param = 10 no-lock:
end.
if not avail mab-param-integr then return. 

DEFINE VARIABLE verifica-perc-eqpto AS CHARACTER  NO-UNDO.
FOR FIRST catal_docto_anexo
    WHERE cod_catal_docto_anexo = trim(entry(5,mab-param-integr.des-valor))
    AND   trim(entry(1,mab-param-integr.des-valor)) = "sim":
        ASSIGN verifica-perc-eqpto = mab-param-integr.des-valor.
        ASSIGN cInputFolder-2 = catal_docto_anexo.cod_path_catal + "~\INP".
        ASSIGN cInputFolder-2:SCREEN-VALUE IN FRAME fPage4 = catal_docto_anexo.cod_path_catal + "~\INP".
END.

IF verifica-perc-eqpto = "" THEN DO:
    {utp/ut-liter.i "N∆o_foi_possivel_abrir_o_programa_AB0710 ~~~~Verifique_se_a_opá∆o_percurso_equipamento_do_programa_AB0116_est†_marcada"}
    run utp/ut-msgs.p (input "show",
                       input 17006,
                       input RETURN-VALUE + ".").
    return "NOK":U.
END.


ASSIGN cInputFolder:SENSITIVE IN FRAME fPage4    = NO
       btInputFolder:SENSITIVE IN FRAME fPage4   = NO
       /*btInputFolder-2:SENSITIVE IN FRAME fPage4 = NO*/
       cInputFolder-2:SENSITIVE IN FRAME fPage4  = NO
       cInputFolder:SCREEN-VALUE IN FRAME fPage4 = "".
       


&IF "{&RTF}":U = "YES":U &THEN
IF VALID-HANDLE(hWenController) THEN DO:
    ASSIGN l-habilitaRtf:sensitive IN FRAME fPage6 = NO
           l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
           l-habilitaRtf = NO.
           
END.
 RUN pi-habilitaRtf.
&endif


/*Fim alteracao 17/02/2005*/
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
    assign file-info:file-name = input frame fPage4 cInputFolder.
    IF t-diretorio = YES THEN DO:
    if  file-info:pathname = ? and
        input frame fPage7 rsExecution = 1 then do:
        run utp/ut-msgs.p (input "SHOW":U,
                           input 326,
                           input cInputFolder).
        apply "ENTRY":U to cInputFolder in frame fPage4.
        return error.
    END.
    END.


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
    if  tt-param.destino = 2 THEN
        assign tt-param.arq-destino = input frame fPage7 cDestinyFile.
    else
        assign tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp":U. 

    /*:T Coloque aqui a l¢gica de gravaá∆o dos parÉmtros e seleá∆o na temp-table
       tt-param */ 

    IF t-diretorio = YES THEN
    ASSIGN tt-param.inputFolder = INPUT FRAME fPage4 cInputFolder.
    ELSE
        ASSIGN tt-param.inputFolder = INPUT FRAME fPage4 cInputFolder-2.



    {report/imexb.i}

    if  session:set-wait-state("GENERAL":U) then.

    {report/imrun.i abp/ab0710rp.p}

    {report/imexc.i}

    if  session:set-wait-state("":U) then.

    {report/imtrm.i tt-param.arq-destino tt-param.destino}

end.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

