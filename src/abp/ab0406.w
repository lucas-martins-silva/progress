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
{include/i-prgvrs.i AB0406 2.00.00.002}  /*** 010002 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0406 MAB}
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
&GLOBAL-DEFINE Program        AB0406
&GLOBAL-DEFINE Version        2.00.00.002
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o,ParÉmetro,Impress∆o

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
&GLOBAL-DEFINE page4Widgets   lVencido lVencer
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
&GLOBAL-DEFINE page4Text      text-entrada
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    fiDataIni fiDataFim ~
                              fiDoctoIni fiDoctoFim ~
                              fiEmpIni fiEmpFim ~
                              fiEqptoIni fiEqptoFim ~
                              fiEventoIni fiEventoFim ~
                              fiSubIni fiSubFim
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */

{abp/abapi006.i1} /** tt-param **/

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    index id ordem.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def var l-ok               as logical no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-temp         as char    no-undo.

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

DEFINE VARIABLE fiDataFim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiDataIni AS DATE FORMAT "99/99/9999" INITIAL 01/01/1800 
     LABEL "Data":R10 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiDoctoFim AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiDoctoIni AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Documento":R11 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEmpFim LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 5 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEmpIni LIKE empresa.ep-codigo
     LABEL "Empresa":R9 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEqptoFim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEqptoIni AS CHARACTER FORMAT "x(16)" 
     LABEL "Equipamento":R14 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEventoFim AS CHARACTER FORMAT "x(08)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEventoIni AS CHARACTER FORMAT "x(08)" 
     LABEL "Evento":R8 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiSubFim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiSubIni AS CHARACTER FORMAT "x(8)" 
     LABEL "Sub Sistema":R14 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiUnidNegocFim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiUnidNegocIni AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE text-entrada AS CHARACTER FORMAT "X(256)":U INITIAL "Eliminar" 
      VIEW-AS TEXT 
     SIZE 6.86 BY .63
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 3.

DEFINE VARIABLE lVencer AS LOGICAL INITIAL yes 
     LABEL "Eventos a vencer" 
     VIEW-AS TOGGLE-BOX
     SIZE 43 BY .83 NO-UNDO.

DEFINE VARIABLE lVencido AS LOGICAL INITIAL yes 
     LABEL "Eventos vencidos e n∆o executados" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY 1.08
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
     btOK AT ROW 14.75 COL 2
     btCancel AT ROW 14.75 COL 13
     btHelp2 AT ROW 14.75 COL 80
     rtToolBar AT ROW 14.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 15
         FONT 1.

DEFINE FRAME fPage4
     lVencido AT ROW 3.5 COL 11
     lVencer AT ROW 4.75 COL 11
     text-entrada AT ROW 2.75 COL 11.14 NO-LABEL
     RECT-12 AT ROW 3 COL 9
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
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
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage2
     fiDataIni AT ROW 2.5 COL 19.28
     fiDataFim AT ROW 2.5 COL 49 NO-LABEL
     fiDoctoIni AT ROW 3.5 COL 12.43 HELP
          "Documento relacionado ao evento apontado para equipamento"
     fiDoctoFim AT ROW 3.5 COL 49 HELP
          "Documento relacionado ao evento apontado para equipamento" NO-LABEL
     fiEmpIni AT ROW 4.5 COL 23.29 HELP
          "C¢digo da empresa"
          LABEL "Empresa":R9
          FONT 1
     fiEmpFim AT ROW 4.5 COL 49 HELP
          "C¢digo da empresa" NO-LABEL
          FONT 1
     fiEqptoIni AT ROW 5.5 COL 6.86 HELP
          "C¢digo do Equipamento"
     fiEqptoFim AT ROW 5.5 COL 49 HELP
          "C¢digo do Equipamento" NO-LABEL
     fiEventoIni AT ROW 6.5 COL 17.29 HELP
          "C¢digo do evento programado"
     fiEventoFim AT ROW 6.5 COL 49 HELP
          "C¢digo do evento programado" NO-LABEL
     fiSubIni AT ROW 7.5 COL 13.29 HELP
          "C¢digo Sub-Sistema"
     fiSubFim AT ROW 7.5 COL 49 HELP
          "C¢digo Sub-Sistema" NO-LABEL
     fiUnidNegocIni AT ROW 8.5 COL 28.86 COLON-ALIGNED HELP
          "Codigo Unidade Neg¢cio"
     fiUnidNegocFim AT ROW 8.5 COL 47 COLON-ALIGNED HELP
          "Codigo Unidade Neg¢cio" NO-LABEL
     IMAGE-1 AT ROW 2.5 COL 35.86
     IMAGE-10 AT ROW 4.5 COL 46
     IMAGE-11 AT ROW 5.5 COL 35.86
     IMAGE-12 AT ROW 5.5 COL 46
     IMAGE-13 AT ROW 6.5 COL 35.86
     IMAGE-14 AT ROW 6.5 COL 46
     IMAGE-15 AT ROW 7.5 COL 35.86
     IMAGE-16 AT ROW 7.5 COL 46
     IMAGE-2 AT ROW 2.5 COL 46
     IMAGE-7 AT ROW 3.5 COL 35.86
     IMAGE-8 AT ROW 3.5 COL 46
     IMAGE-9 AT ROW 4.5 COL 35.86
     IMAGE-17 AT ROW 8.5 COL 35.86
     IMAGE-18 AT ROW 8.5 COL 46
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
/* SETTINGS FOR FILL-IN fiDataFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiDataIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiDoctoFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiDoctoIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiEmpFim IN FRAME fPage2
   ALIGN-L LIKE = ems2cad.empresa.ep-codigo EXP-LABEL                   */
/* SETTINGS FOR FILL-IN fiEmpIni IN FRAME fPage2
   ALIGN-L LIKE = ems2cad.empresa.ep-codigo EXP-LABEL                   */
/* SETTINGS FOR FILL-IN fiEqptoFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiEqptoIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiEventoFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiEventoIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiSubFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiSubIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FILL-IN text-entrada IN FRAME fPage4
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
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

ASSIGN  fiEmpIni = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF
        fiEmpFim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF.

{report/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override do mÇtodo de inicializaá∆o da tela (ap¢s)
------------------------------------------------------------------------------*/

{utp/ut-liter.i "Data"}
assign fiDataIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Documento"}
assign fiDoctoIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Empresa"}
assign fiEmpIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Equipamento"}
assign fiEqptoIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Evento"}
assign fiEventoIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Sub Sistema"}
assign fiSubIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Eventos vencidos e n∆o executados"}
assign lVencido:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Eventos a vencer"}
assign lVencer:label in frame fPage4 = trim(return-value)
       fiDataIni = today.

display fiDataIni with frame fPage2.

ASSIGN fiUnidNegocIni:VISIBLE   IN FRAME fPage2 = l-usa-unid-negoc
       fiUnidNegocIni:SENSITIVE IN FRAME fPage2 = l-usa-unid-negoc
       fiUnidNegocFim:VISIBLE   IN FRAME fPage2 = l-usa-unid-negoc
       fiUnidNegocFim:SENSITIVE IN FRAME fPage2 = l-usa-unid-negoc
       IMAGE-17:VISIBLE         IN FRAME fPage2 = l-usa-unid-negoc
       IMAGE-18:VISIBLE         IN FRAME fPage2 = l-usa-unid-negoc.

IF l-usa-unid-negoc THEN DO:
    {utp/ut-liter.i Unidade_Neg¢cio}
    ASSIGN fiUnidNegocIni:LABEL        IN FRAME fPage2 = TRIM(RETURN-VALUE)
           fiUnidNegocFim:SCREEN-VALUE IN FRAME fPage2 = fiUnidNegocFim.
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

    /** Data Final n∆o pode ser menor que inicial **/
    if input frame fPage2 fiDataFim < input frame fPage2 fiDataIni then do:
        run utp/ut-msgs.p (input "show":U, input 5360, input "":U).
        run setFolder in hFolder (input 1).
        apply "ENTRY":U to fiDataFim in frame fPage2.
        return error.
    end.
    
    
    /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.dataIni         = input frame fPage2 fiDataIni
           tt-param.dataFim         = input frame fPage2 fiDataFim
           tt-param.docIni          = input frame fPage2 fiDoctoIni
           tt-param.docFim          = input frame fPage2 fiDoctoFim
           tt-param.empIni          = input frame fPage2 fiEmpIni
           tt-param.empFim          = input frame fPage2 fiEmpFim
           tt-param.eqptoIni        = input frame fPage2 fiEqptoIni
           tt-param.eqptoFim        = input frame fPage2 fiEqptoFim
           tt-param.eventIni        = input frame fPage2 fiEventoIni
           tt-param.eventFim        = input frame fPage2 fiEventoFim
           tt-param.subIni          = input frame fPage2 fiSubIni
           tt-param.subFim          = input frame fPage2 fiSubFim
           tt-param.lVencido        = lVencido:checked in frame fPage4
           tt-param.lVencer         = lVencer:checked in frame fPage4
           tt-param.iAcao           = 2.  /** eliminaá∆o **/
    
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN DO:
            ASSIGN tt-param.unidNegocIni = input frame fPage2 fiUnidNegocIni
                   tt-param.unidNegocFim = input frame fPage2 fiUnidNegocFim.
        END.
    &ENDIF

    /*:T Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
       como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */
    
    
    
    /*:T Executar do programa RP.P que ir† criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i abp/ab0406rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.
&ELSE
/*:T** Importacao/Exportacao ***/
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

