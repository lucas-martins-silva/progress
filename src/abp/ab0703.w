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
{include/i-prgvrs.i AB0703 2.00.00.001}  /*** 010001 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0703 MAB}
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
&GLOBAL-DEFINE Program        AB0703
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o,ParÉmetro,Impress∆o

&GLOBAL-DEFINE PGLAY          no
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          no
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          no
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          no

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   rsPercurso
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
&GLOBAL-DEFINE page4Text      fiValor
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    fiDataFim fiDataIni ~
                              fiEmpFim fiEmpIni ~
                              fiEqptoFim fiEqptoIni ~
                              fiEstabFim fiEstabIni ~
                              fiGrupoFim fiGrupoIni ~
                              fiModeloFim fiModeloIni
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    fiPercurso fiUN
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/** Zoom de smart **/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

{abp/abapi007.i} /** tt-param **/

define temp-table tt-digita no-undo
       field i-ordem as integer.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def var l-ok               as logical no-undo.
def var c-terminal         as char    no-undo.

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

DEFINE VARIABLE fiDataFim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiDataIni AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Per°odo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
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

DEFINE VARIABLE fiEqptoFim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEqptoIni AS CHARACTER FORMAT "X(16)":U 
     LABEL "Equipamento" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEstabFim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEstabIni LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R15 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiGrupoFim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiGrupoIni AS CHARACTER FORMAT "X(8)":U 
     LABEL "Grupo Equipamento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiModeloFim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiModeloIni AS CHARACTER FORMAT "X(8)":U 
     LABEL "Modelo Equipamento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
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

DEFINE IMAGE IMAGE-19
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE fiDescUN AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fiPercurso AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Percurso" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiUN AS CHARACTER FORMAT "X(2)":U 
     LABEL "Unidade" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fiValor AS CHARACTER FORMAT "X(40)":U INITIAL "Valor Percurso" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE rsPercurso AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Por Dia", 1,
"Total Per°odo", 2
     SIZE 16 BY 2 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 24 BY 3.25.

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
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage4
     fiPercurso AT ROW 2.5 COL 18 COLON-ALIGNED
     fiUN AT ROW 3.5 COL 18 COLON-ALIGNED
     fiDescUN AT ROW 3.5 COL 22.57 COLON-ALIGNED NO-LABEL
     rsPercurso AT ROW 5.5 COL 24 NO-LABEL
     fiValor AT ROW 4.58 COL 19.29 COLON-ALIGNED NO-LABEL
     RECT-13 AT ROW 4.75 COL 20
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     btFile AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.58 COL 43.29 HELP
          "Configuraá∆o da impressora"
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
     fiDataIni AT ROW 1.5 COL 23.57 COLON-ALIGNED
     fiDataFim AT ROW 1.5 COL 54 NO-LABEL
     fiEmpIni AT ROW 2.5 COL 28.57 COLON-ALIGNED HELP
          "C¢digo da empresa"
          LABEL "Empresa":R9
          FONT 1
     fiEmpFim AT ROW 2.5 COL 54 HELP
          "C¢digo da empresa" NO-LABEL
          FONT 1
     fiEstabIni AT ROW 3.5 COL 26.57 COLON-ALIGNED HELP
          "C¢digo do estabelecimento"
          LABEL "Estabelecimento":R15
          FONT 1
     fiEstabFim AT ROW 3.5 COL 54 HELP
          "C¢digo do estabelecimento" NO-LABEL
          FONT 1
     fiGrupoIni AT ROW 4.5 COL 23.57 COLON-ALIGNED
     fiGrupoFim AT ROW 4.5 COL 54 NO-LABEL
     fiModeloIni AT ROW 5.5 COL 23.57 COLON-ALIGNED
     fiModeloFim AT ROW 5.5 COL 54 NO-LABEL
     fiEqptoIni AT ROW 6.5 COL 17.57 COLON-ALIGNED
     fiEqptoFim AT ROW 6.5 COL 54 NO-LABEL
     fiUnidNegocIni AT ROW 7.5 COL 28.57 COLON-ALIGNED HELP
          "C¢digo Unidade Neg¢cio"
     fiUnidNegocFim AT ROW 7.5 COL 52 COLON-ALIGNED HELP
          "C¢digo Unidade Neg¢cio" NO-LABEL
     IMAGE-1 AT ROW 1.5 COL 35.86
     IMAGE-10 AT ROW 2.5 COL 51
     IMAGE-11 AT ROW 3.5 COL 35.86
     IMAGE-12 AT ROW 3.5 COL 51
     IMAGE-13 AT ROW 4.5 COL 35.86
     IMAGE-14 AT ROW 4.5 COL 51
     IMAGE-15 AT ROW 5.5 COL 35.86
     IMAGE-16 AT ROW 5.5 COL 51
     IMAGE-17 AT ROW 6.5 COL 35.86
     IMAGE-18 AT ROW 6.5 COL 51
     IMAGE-2 AT ROW 1.5 COL 51
     IMAGE-9 AT ROW 2.5 COL 35.86
     IMAGE-19 AT ROW 7.5 COL 35.86
     IMAGE-20 AT ROW 7.5 COL 51
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
/* SETTINGS FOR FILL-IN fiEmpFim IN FRAME fPage2
   ALIGN-L LIKE = ems2cad.empresa.ep-codigo EXP-LABEL                   */
/* SETTINGS FOR FILL-IN fiEmpIni IN FRAME fPage2
   LIKE = ems2cad.empresa.ep-codigo EXP-LABEL                           */
/* SETTINGS FOR FILL-IN fiEqptoFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiEstabFim IN FRAME fPage2
   ALIGN-L LIKE = ems2cad.estabelec.cod-estabel EXP-LABEL EXP-SIZE      */
/* SETTINGS FOR FILL-IN fiEstabIni IN FRAME fPage2
   LIKE = ems2cad.estabelec.cod-estabel EXP-LABEL EXP-SIZE              */
/* SETTINGS FOR FILL-IN fiGrupoFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiModeloFim IN FRAME fPage2
   ALIGN-L                                                              */
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME fiUN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiUN wReport
ON LEAVE OF fiUN IN FRAME fPage4 /* Unidade */
DO:
    {include/leave.i
             &tabela=tab-unidade
             &atributo-ref=descricao
             &variavel-ref=fiDescUN
             &where="tab-unidade.un = input frame fPage4 fiUN"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiUN wReport
ON MOUSE-SELECT-DBLCLICK OF fiUN IN FRAME fPage4 /* Unidade */
OR "F5":U OF fiUN IN FRAME fPage4 DO:
    assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="inzoom\z01in417.w"
                     &campo=fiUn
                     &campozoom=un
                     &campo2=fiDescUN
                     &campozoom2=descricao}  
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

ASSIGN fiEmpIni = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF
       fiEmpFim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF.

ASSIGN fiEstabFim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZZZ":U &ELSE "ZZZ":U &ENDIF.

{report/mainblock.i}

fiUN:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in frame fPage4.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override ap¢s iniciar o programa
------------------------------------------------------------------------------*/
{utp/ut-liter.i "Per°odo"}
assign fiDataIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Empresa"}
assign fiEmpIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Estabelecimento"}
assign fiEstabIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Grupo Equipamento"}
assign fiGrupoIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Modelo Equipamento"}
assign fiModeloIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Equipamento"}
assign fiEqptoIni:label in frame fPage2 = trim(return-value).
{utp/ut-liter.i "Percurso" MAB}
assign fiPercurso:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Unidade"}
assign fiUN:label in frame fPage4 = trim(return-value).
{utp/ut-liter.i "Valor Percurso" MAB}
assign fiValor   = trim(return-value)
       fiDataIni = today - 1
       fiDataFim = today - 1.
display fiValor with frame fPage4.
display fiDataIni fiDataFim with frame fPage2.

ASSIGN fiUnidNegocIni:VISIBLE   IN FRAME fPage2 = l-usa-unid-negoc
       fiUnidNegocIni:SENSITIVE IN FRAME fPage2 = l-usa-unid-negoc
       fiUnidNegocFim:VISIBLE   IN FRAME fPage2 = l-usa-unid-negoc
       fiUnidNegocFim:SENSITIVE IN FRAME fPage2 = l-usa-unid-negoc
       IMAGE-19:VISIBLE         IN FRAME fPage2 = l-usa-unid-negoc
       IMAGE-20:VISIBLE         IN FRAME fPage2 = l-usa-unid-negoc.

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

    /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
       problemas e colocar o focus no campo com problemas */
    /** Data Final n∆o pode ser menor que inicial **/
    if input frame fPage4 fiPercurso = 0 then do:
        run utp/ut-msgs.p (input "show":U, input 36, input fiPercurso:label in frame fPage4).
        run setFolder in hFolder (input 2).
        apply "ENTRY":U to fiPercurso in frame fPage4.
        return error.
    end.
    if not can-find(first tab-unidade 
                    where tab-unidade.un = input frame fPage4 fiUN no-lock) then do:
        run utp/ut-msgs.p (input "show":U, input 56, input fiUN:label in frame fPage4 + '~~' +
                                                           fiUN:label in frame fPage4).
        run setFolder in hFolder (input 2).
        apply "ENTRY":U to fiUN in frame fPage4.
        return error.
    end.

    /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
       para o programa RP.P */

    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.i-origem        = 2  /** Geraá∆o de Percurso **/
           tt-param.dtInicial       = input frame fPage2 fiDataIni
           tt-param.dtFinal         = input frame fPage2 fiDataFim
           tt-param.empIni          = input frame fPage2 fiEmpIni
           tt-param.empFim          = input frame fPage2 fiEmpFim
           tt-param.eqptoIni        = input frame fPage2 fiEqptoIni
           tt-param.eqptoFim        = input frame fPage2 fiEqptoFim
           tt-param.estabIni        = input frame fPage2 fiEstabIni
           tt-param.estabFim        = input frame fPage2 fiEstabFim
           tt-param.grupoIni        = input frame fPage2 fiGrupoIni
           tt-param.grupoFim        = input frame fPage2 fiGrupoFim
           tt-param.modeloIni       = input frame fPage2 fiModeloIni
           tt-param.modeloFim       = input frame fPage2 fiModeloFim
           tt-param.dePercurso      = input frame fPage4 fiPercurso
           tt-param.un              = input frame fPage4 fiUN
           tt-param.iTpPercurso     = input frame fPage4 rsPercurso.

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

    /*:T Executar do programa RP.P que ir† criar o relat¢rio */
    {report/rpexb.i}

    SESSION:SET-WAIT-STATE("GENERAL":U).

    {report/rprun.i abp\ab0703rp.p}

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

