&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i AB0401 2.00.00.004 } /*** "010004" 31/03/2025 10:17:08  ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0401 MAB}
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
&GLOBAL-DEFINE Program        AB0401
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
&GLOBAL-DEFINE page4Widgets   rsConsiste ~
                              tgFicha
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
&GLOBAL-DEFINE page2Fields    fiDataFim  fiDataIni ~
                              fiEmpFim   fiEmpIni ~
                              fiEqptoFim fiEqptoIni ~
                              fiEstabFim fiEstabIni ~
                              fiTagFim   fiTagIni ~
                              fiCCIni    fiCCFim ~
                              fiPostoIni fiPostoFim
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */

{abp/abapi001.i} /** Temp-Table parƒmetros API **/

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
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

/*** Inicio Projeto 118 - Seguran‡a por Estabelecimento */

/* Valida os Modulo, para ver se tem Seguran‡a por Estabelecimento */
{cdp/cdapi3003.i "MAB":U}
/* Defini‡Æo das temp-table necessaria para tratar seguran‡a por Estabelecimento */
{cdp/cdapi3003.i1}

/*** Final Projeto 118 - Seguran‡a por Estabelecimento */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-22 IMAGE-23 rtToolBar btOK btCancel ~
btHelp2 

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

DEFINE IMAGE IMAGE-22
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fiCCFim AS CHARACTER FORMAT "x(20)" INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fiCCIni AS CHARACTER FORMAT "x(20)" 
     LABEL "Centro Custo Eqpto":R4 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fiDataFim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiDataIni AS DATE FORMAT "99/99/9999" INITIAL 01/01/001 
     LABEL "Data Movimento":R17 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiEmpFim LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiEmpIni LIKE empresa.ep-codigo
     LABEL "Empresa":R9 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiEqptoFim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE fiEqptoIni AS CHARACTER FORMAT "x(16)" 
     LABEL "Equipamento":R14 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE fiEstabFim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fiEstabIni LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R15 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fiPostoFim AS CHARACTER FORMAT "X(256)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88.

DEFINE VARIABLE fiPostoIni AS CHARACTER FORMAT "X(256)":U 
     LABEL "Posto" 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .88.

DEFINE VARIABLE fiTagFim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE fiTagIni AS CHARACTER FORMAT "x(16)" 
     LABEL "Tag":R4 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE fiUnidNegocFim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiUnidNegocIni AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-51
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-52
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-53
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-54
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-55
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-56
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE rsConsiste AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Somente com Problemas", 1,
"Todos", 2
     SIZE 22 BY 2 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 2.5.

DEFINE VARIABLE tgFicha AS LOGICAL INITIAL yes 
     LABEL "Consistir Fichas com problemas anteriores a data escolhida" 
     VIEW-AS TOGGLE-BOX
     SIZE 43 BY .83 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
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
     btOK AT ROW 14.5 COL 2
     btCancel AT ROW 14.5 COL 13
     btHelp2 AT ROW 14.5 COL 80
     IMAGE-22 AT ROW 7.21 COL 38.43
     IMAGE-23 AT ROW 7.21 COL 43
     rtToolBar AT ROW 14.29 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 15
         FONT 1.

DEFINE FRAME fPage2
     fiDataIni AT ROW 2.25 COL 26 COLON-ALIGNED HELP
          "Data do movimento inicial"
     fiDataFim AT ROW 2.25 COL 48 COLON-ALIGNED HELP
          "Data do movimento final" NO-LABEL
     fiEstabIni AT ROW 3.25 COL 29 COLON-ALIGNED HELP
          "C¢digo do estabelecimento"
          LABEL "Estabelecimento":R15
     fiEstabFim AT ROW 3.25 COL 48 COLON-ALIGNED HELP
          "C¢digo do estabelecimento" NO-LABEL
     fiEmpIni AT ROW 4.25 COL 31 COLON-ALIGNED HELP
          "C¢digo da empresa"
          LABEL "Empresa":R9
     fiEmpFim AT ROW 4.25 COL 48 COLON-ALIGNED HELP
          "C¢digo da empresa" NO-LABEL
     fiEqptoIni AT ROW 5.25 COL 18 COLON-ALIGNED HELP
          "C¢digo do Equipamento inicial"
     fiEqptoFim AT ROW 5.25 COL 48 COLON-ALIGNED HELP
          "C¢digo do Equipamento final" NO-LABEL
     fiTagIni AT ROW 6.25 COL 18 COLON-ALIGNED HELP
          "Localiza‡Æo Funcional - TAG inicial"
     fiTagFim AT ROW 6.25 COL 48 COLON-ALIGNED HELP
          "Localiza‡Æo Funcional - TAG final" NO-LABEL
     fiCCIni AT ROW 7.25 COL 16 COLON-ALIGNED HELP
          "Localiza‡Æo Funcional - TAG inicial"
     fiCCFim AT ROW 7.25 COL 48 COLON-ALIGNED HELP
          "Centro Custo Eqpto" NO-LABEL
     fiPostoIni AT ROW 8.25 COL 25.86 COLON-ALIGNED
     fiPostoFim AT ROW 8.25 COL 48.14 COLON-ALIGNED NO-LABEL
     fiUnidNegocIni AT ROW 9.25 COL 31 COLON-ALIGNED HELP
          "C¢digo Unidade Neg¢cio"
     fiUnidNegocFim AT ROW 9.25 COL 48.14 COLON-ALIGNED HELP
          "C¢digo Unidade Neg¢cio" NO-LABEL
     IMAGE-1 AT ROW 2.25 COL 38
     IMAGE-10 AT ROW 6.25 COL 47
     IMAGE-2 AT ROW 2.25 COL 47
     IMAGE-3 AT ROW 3.25 COL 38
     IMAGE-4 AT ROW 3.25 COL 47
     IMAGE-5 AT ROW 4.25 COL 38
     IMAGE-51 AT ROW 7.25 COL 47
     IMAGE-52 AT ROW 7.25 COL 38
     IMAGE-6 AT ROW 4.25 COL 47
     IMAGE-7 AT ROW 5.25 COL 38
     IMAGE-8 AT ROW 5.25 COL 47
     IMAGE-9 AT ROW 6.25 COL 38
     IMAGE-53 AT ROW 8.25 COL 38
     IMAGE-54 AT ROW 8.25 COL 47
     IMAGE-55 AT ROW 9.25 COL 38
     IMAGE-56 AT ROW 9.25 COL 47
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage4
     rsConsiste AT ROW 3 COL 16 NO-LABEL
     tgFicha AT ROW 5.5 COL 8
     "Consistir Apontamentos" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 2.5 COL 9.29
     RECT-13 AT ROW 2.75 COL 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btFile AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.58 COL 43.29 HELP
          "Configura‡Æo da impressora"
     cFile AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.75 COL 3 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
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
         HEIGHT             = 15
         WIDTH              = 90
         MAX-HEIGHT         = 15
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 15
         VIRTUAL-WIDTH      = 90
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
/* SETTINGS FOR FILL-IN fiEmpFim IN FRAME fPage2
   LIKE = ems2cad.empresa.ep-codigo EXP-LABEL EXP-SIZE                  */
/* SETTINGS FOR FILL-IN fiEmpIni IN FRAME fPage2
   LIKE = ems2cad.empresa.ep-codigo EXP-LABEL                           */
/* SETTINGS FOR FILL-IN fiEstabFim IN FRAME fPage2
   LIKE = ems2cad.estabelec.cod-estabel EXP-LABEL EXP-SIZE              */
/* SETTINGS FOR FILL-IN fiEstabIni IN FRAME fPage2
   LIKE = ems2cad.estabelec.cod-estabel EXP-LABEL EXP-SIZE              */
/* SETTINGS FOR FRAME fPage4
                                                                        */
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
    IF INPUT FRAME fPage2 fiDataFim > TODAY THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 5229,
                           INPUT STRING(TODAY,"99/99/9999")).
        APPLY "ENTRY":U TO fiDataFim IN FRAME fPage2.
        RETURN NO-APPLY.
    END.
    ELSE DO:
        do on error undo, return no-apply:
            /*** Projeto 118 - Seguran‡a por Estabelecimento */
            IF  l-seg-ativa-modulo THEN
                RUN piValidaSegPorEstabel IN THIS-PROCEDURE.
            run piExecute.
        END.
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

ASSIGN fiEstabFim =  &IF "{&mguni_version}" >= "2.071" &THEN "ZZZZZ":U &ELSE "ZZZ":U &ENDIF
       fiEmpIni   =  &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF
       fiEmpFim   =  &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF.

{report/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) inicializa‡Æo da tela
------------------------------------------------------------------------------*/
{utp/ut-liter.i "Empresa"}
assign fiEmpIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Equipamento"}
assign fiEqptoIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Data Movimento"}
assign fiDataIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Estabelecimento"}
assign fiEstabIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Tag"}
assign fiTagIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Centro Custo Eqpto"}
assign fiCCIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Consistir Fichas com problemas anteriores a data escolhida"}
assign tgFicha:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Posto"}
assign fiPostoIni:label in frame fPage2 = trim(return-value).

/** Data Movimento Inicial **/
assign fiDataIni = today - 2
       fiDataFim = today.
display fiDataIni 
        fiDataFim
    with frame fPage2.

ASSIGN fiUnidNegocIni:VISIBLE   IN FRAME fPage2 = l-usa-unid-negoc
       fiUnidNegocIni:SENSITIVE IN FRAME fPage2 = l-usa-unid-negoc
       fiUnidNegocFim:VISIBLE   IN FRAME fPage2 = l-usa-unid-negoc
       fiUnidNegocFim:SENSITIVE IN FRAME fPage2 = l-usa-unid-negoc
       IMAGE-55:VISIBLE         IN FRAME fPage2 = l-usa-unid-negoc
       IMAGE-56:VISIBLE         IN FRAME fPage2 = l-usa-unid-negoc.

IF l-usa-unid-negoc THEN DO:
    {utp/ut-liter.i "Unidade_Neg¢cio"}
    ASSIGN fiUnidNegocIni:LABEL        IN FRAME fPage2 = TRIM(RETURN-VALUE)
           fiUnidNegocFim:SCREEN-VALUE IN FRAME fPage2 = fiUnidNegocFim.
END.

/** Valida Fechamento do M‚dio **/
FOR FIRST mab-param
    WHERE mab-param.cdn-param = 58 NO-LOCK:
    IF  mab-param.des-valor = "1" THEN DO:
        ASSIGN tgFicha:SCREEN-VALUE IN FRAME fPage4 = "NO"
               tgFicha:SENSITIVE    IN FRAME fPage4 = FALSE.
    END.
END.

return "OK":U.
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

DEFINE VARIABLE r-tt-digita         AS ROWID     NO-UNDO.
DEFINE VARIABLE hMabAbastecLubrific AS HANDLE    NO-UNDO.
DEFINE VARIABLE dDatFimPerFech      AS DATE      NO-UNDO.
DEFINE VARIABLE cErroDataAbastec    AS CHARACTER NO-UNDO.


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

    if input frame fPage2 fiDataIni < (today - 30) then do:
        run utp/ut-msgs.p (input "show":U, input 28688, input "":U).
        if return-value = "NO":U then do:
            return no-apply.
        end.
    end.   
    
    /** Valida Fechamento do M‚dio **/
    FOR FIRST mab-param
        WHERE mab-param.cdn-param = 58 NO-LOCK:
        IF  mab-param.des-valor = "1" THEN DO:
        
            IF NOT VALID-HANDLE(hMabAbastecLubrific) THEN
                RUN frbo/bofr055.p PERSISTENT SET hMabAbastecLubrific. 
        
            RUN piBuscaDataMedioFechado IN hMabAbastecLubrific (INPUT "",
                                                                OUTPUT dDatFimPerFech).
                                                           
            IF VALID-HANDLE(hMabAbastecLubrific) THEN
                RUN destroy IN hMabAbastecLubrific.
                
            IF  INPUT FRAME fPage2 fiDataIni <= dDatFimPerFech THEN DO:
                {utp/ut-liter.i Data_de_Abastecimento_Inv lida}
                ASSIGN cErroDataAbastec = RETURN-VALUE + "~~".
                {utp/ut-liter.i Data_de_Abastecimento_deve_ser_maior_que_fechamento_do_m‚dio_calculado}
                ASSIGN cErroDataAbastec = cErroDataAbastec + RETURN-VALUE.
                ASSIGN cErroDataAbastec = cErroDataAbastec + chR(10).
                {utp/ut-liter.i éltimo_M‚dio_Fechado}
                ASSIGN cErroDataAbastec = cErroDataAbastec + RETURN-VALUE + ": " + STRING(dDatFimPerFech).
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 17006, INPUT cErroDataAbastec).
                                            
                RETURN NO-APPLY.
            END.
        END.
    END.    
    

    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */

    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.iConsiste       = input frame fPage4 rsConsiste
           tt-param.descConsiste    = entry((tt-param.iConsiste - 1) * 2 + 1, 
                                            rsConsiste:radio-buttons in frame fPage4)
           tt-param.dataIni         = input frame fPage2 fiDataIni
           tt-param.dataFim         = input frame fPage2 fiDataFim
           tt-param.iEmpIni         = input frame fPage2 fiEmpIni
           tt-param.iEmpFim         = input frame fPage2 fiEmpFim
           tt-param.cEstabIni       = input frame fPage2 fiEstabIni
           tt-param.cEstabFim       = input frame fPage2 fiEstabFim
           tt-param.cEqptoIni       = input frame fPage2 fiEqptoIni
           tt-param.cEqptoFim       = input frame fPage2 fiEqptoFim
           tt-param.cTagIni         = input frame fPage2 fiTagIni
           tt-param.cTagFim         = input frame fPage2 fiTagFim
           tt-param.cCCini          = input frame fPage2 fiCCIni
           tt-param.cCCfim          = input frame fPage2 fiCCFim
           tt-param.cPostoIni       = input frame fPage2 fiPostoIni
           tt-param.cPostoFim       = input frame fPage2 fiPostoFim
           tt-param.lFicha          = tgFicha:checked in frame fPage4
           tt-param.num-docto       = ?
           tt-param.tipo-liberacao  = 1.  /** Normal **/

    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN DO:
            ASSIGN tt-param.cUnidNegocIni = input frame fPage2 fiUnidNegocIni
                   tt-param.cUnidNegocFim = input frame fPage2 fiUnidNegocFim.
        END.
    &ENDIF

    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */



    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}

    SESSION:SET-WAIT-STATE("GENERAL":U).

    {report/rprun.i abp/ab0401rp.p}

    {report/rpexc.i}

    SESSION:SET-WAIT-STATE("":U).

    {report/rptrm.i}
end.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaSegPorEstabel wReport 
PROCEDURE piValidaSegPorEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Valida Seguran‡a por Estabelecimento
  
  Referente ao Projeto 118 - Seguran‡a por Estabelecimento 
  
------------------------------------------------------------------------------*/
    /* Definicao de Variaveis */
    DEFINE VARIABLE i-cont-erro-seg   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-help-erro-seg   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFinalidade       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lTemRestricao     AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE lErroExecucao     AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE h_api_perm_estab  AS HANDLE    NO-UNDO.

    EMPTY TEMP-TABLE tt_log_erro.
    EMPTY TEMP-TABLE tt_estab_ems2.
    EMPTY TEMP-TABLE ttEmpEstabelSemSeg.


    /* Executa api de Finan¯as */
    RUN prgint/utb/utb746za.py PERSISTENT SET h_api_perm_estab.
    RUN pi_retorna_estab_sem_permissao_ems2 IN h_api_perm_estab (OUTPUT TABLE tt_estab_ems2,
                                                                 OUTPUT TABLE tt_log_erro).
    /* Destroi handle */
    DELETE OBJECT h_api_perm_estab.

    FOR EACH tt_estab_ems2 NO-LOCK:
        FIND FIRST estabelec
             WHERE estabelec.cod-estabel = tt_estab_ems2.tta_cod_estab NO-LOCK NO-ERROR.
        IF  AVAIL estabelec THEN DO:
            CREATE ttEmpEstabelSemSeg.
            ASSIGN ttEmpEstabelSemSeg.ep-codigo   = estabelec.ep-codigo
                   ttEmpEstabelSemSeg.cod-estabel = estabelec.cod-estabel.
        END.
    END.

    /* Verifica se dentro da faixa de Empresa existe algum Estabelecimento no qual o usuario nao tem acesso */
    ASSIGN i-cont-erro-seg = 0
           c-help-erro-seg = ""
           lTemRestricao   = NO.
    FOR EACH ttEmpEstabelSemSeg
        WHERE ttEmpEstabelSemSeg.ep-codigo >= input frame fPage2 fiEmpIni
        AND   ttEmpEstabelSemSeg.ep-codigo <= input frame fPage2 fiEmpFim
        AND   ttEmpEstabelSemSeg.cod-estabel >= input frame fPage2 fiEstabIni
        AND   ttEmpEstabelSemSeg.cod-estabel <= input frame fPage2 fiEstabFim NO-LOCK
        BY ttEmpEstabelSemSeg.ep-codigo
        BY ttEmpEstabelSemSeg.cod-estabel:
        IF  i-cont-erro-seg <> 0 THEN DO:
            ASSIGN c-help-erro-seg = c-help-erro-seg + ", " + ttEmpEstabelSemSeg.cod-estabel.
        END.
        ELSE DO:
            ASSIGN c-help-erro-seg = c-help-erro-seg + ttEmpEstabelSemSeg.cod-estabel.
            assign i-cont-erro-seg = 1. 
        END.
        ASSIGN lTemRestricao = YES.
    END.

    /* Se houver algum Estabelecimento no qual o usuario nao tem acesso ‚ exibido uma mensagem informando os Estabelecimentos com Restri‡Æo */
    {utp/ut-liter.i "Consiste_/_Atualiza_Apontamentos"}
    ASSIGN cFinalidade = RETURN-VALUE.
    EMPTY TEMP-TABLE RowErrors.
    IF  lTemRestricao THEN DO:
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence = 1.
        ASSIGN RowErrors.ErrorNumber  = 52047.

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 52047,
                           INPUT cFinalidade + "~~" + c-help-erro-seg + "~~" + "").
        ASSIGN RowErrors.ErrorDescription  = RETURN-VALUE.

        RUN utp/ut-msgs.p (INPUT "help",
                           INPUT 52047,
                           INPUT cFinalidade + "~~" + c-help-erro-seg + "~~" + "").
        ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.

        ASSIGN RowErrors.ErrorType = "EMS":U.
        ASSIGN RowErrors.ErrorSubType = "ERROR":U.

        RUN piMostraErros IN THIS-PROCEDURE.

        run setFolder in hFolder (input 1).
        apply "ENTRY":U to fiDataIni in frame fPage2.
        RETURN ERROR.
    END.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraErros wReport 
PROCEDURE piMostraErros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Exibe Erro da temp-table RowErrors
------------------------------------------------------------------------------*/
    
    /** Instancia aplicativo **/
    {method/showmessage.i1}
    /** Mostra caixa com erros existes na RowErrors **/
    {method/showmessage.i2 &Modal="YES"}
    /*--- Destroi tela de mensagens de erros ---*/
    {method/showmessage.i3}

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



