&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i IM0016 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im0016 MIM}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

{include/i_dbvers.i} /*Include de Pr‚-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar validação produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
    {cdp/cdapi558.i1}
&endif
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0016
&GLOBAL-DEFINE Version        2.00.00.005
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
&GLOBAL-DEFINE page4Widgets   cb-Recalcula ~
                              rs-gera
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
&GLOBAL-DEFINE page2Fields    cIniItem cFimItem ~
                              cIniEstabel cFimEstabel ~
                              cIniComprador cFimComprador ~
                              iIniOrdem iFimOrdem ~
                              dIniDtEmissao dFimDtEmissao ~
                              cIniFamilia cFimFamilia ~
                              iIniFornec iFimFornec ~
                              cIniNomeAbrev cFimNomeAbrev ~
                              cIniContrCompras cFimContrCompras ~
                              cIniProcCompras cFimProcCompras
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */

define temp-table tt-param no-undo
    field destino             as integer
    field arquivo             as char format "x(35)"
    field usuario             as char format "x(12)"
    field data-exec           as date
    field hora-exec           as integer
    field c-ini-item          as char
    field c-fim-item          as char
    field c-ini-estabel       as char
    field c-fim-estabel       as char
    field c-ini-comprador     as char
    field c-fim-comprador     as char
    field i-ini-ordem         as int
    field i-fim-ordem         as int
    field d-ini-dt-emissao    as date
    field d-fim-dt-emissao    as date
    field c-ini-familia       as char
    field c-fim-familia       as char
    field i-ini-fornec        as int
    field i-fim-fornec        as int
    field c-ini-nome-abrev    as char
    field c-fim-nome-abrev    as char
    field i-ini-contr-compras as int
    field i-fim-contr-compras as int
    field i-ini-proc-compras  as int
    field i-fim-proc-compras  as int
    field i-gera              as int  /* 1 - Gera Despesas | 2 - Gera Somente Dados Obrigat¢rios */
    field l-recalcula         as log.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
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

def stream s-imp.

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
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE cFimComprador AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cFimContrCompras AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cFimEstabel LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cFimFamilia AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cFimItem AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cFimNomeAbrev AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cFimProcCompras AS INTEGER FORMAT "999,999":U INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cIniComprador AS CHARACTER FORMAT "X(12)":U 
     LABEL "Comprador" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cIniContrCompras AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Contrato Compras" 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cIniEstabel LIKE estabelec.cod-estabel
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cIniFamilia AS CHARACTER FORMAT "X(8)":U 
     LABEL "Fam¡lia" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cIniItem AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cIniNomeAbrev AS CHARACTER FORMAT "X(12)":U 
     LABEL "Nome Abrev" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cIniProcCompras AS INTEGER FORMAT "999,999":U INITIAL 0 
     LABEL "Processo Compras" 
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE dFimDtEmissao AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE dIniDtEmissao AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data EmissÆo" 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE iFimFornec AS INTEGER FORMAT "zzzzzzzz9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE iFimOrdem AS INTEGER FORMAT "zzzzz9,99":U INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE iIniFornec AS INTEGER FORMAT "zzzzzzzz9":U INITIAL 0 
     LABEL "Fornecedor Material" 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE iIniOrdem AS INTEGER FORMAT "zzzzz9,99":U INITIAL 0 
     LABEL "Ordem" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .88
     FONT 1 NO-UNDO.

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

DEFINE IMAGE IMAGE-21
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
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

DEFINE VARIABLE rs-gera AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Gera Despesas", 1,
"Gera Somente Dados Obrigat¢rios", 2
     SIZE 27 BY 2.75 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33 BY 5.5.

DEFINE VARIABLE cb-Recalcula AS LOGICAL INITIAL no 
     LABEL "Recalcula Aprova‡Æo de Compra" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY 1.08
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
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage2
     cIniItem AT ROW 1.5 COL 16 COLON-ALIGNED
     cFimItem AT ROW 1.5 COL 50.57 COLON-ALIGNED NO-LABEL
     cIniEstabel AT ROW 2.5 COL 16 COLON-ALIGNED HELP
          "C¢digo do estabelecimento"
          LABEL "Estab"
          FONT 1
     cFimEstabel AT ROW 2.5 COL 50.57 COLON-ALIGNED HELP
          "C¢digo do estabelecimento" NO-LABEL
          FONT 1
     cIniComprador AT ROW 3.5 COL 16 COLON-ALIGNED
     cFimComprador AT ROW 3.5 COL 50.57 COLON-ALIGNED NO-LABEL
     iIniOrdem AT ROW 4.5 COL 16 COLON-ALIGNED
     iFimOrdem AT ROW 4.5 COL 50.57 COLON-ALIGNED NO-LABEL
     dIniDtEmissao AT ROW 5.5 COL 16 COLON-ALIGNED
     dFimDtEmissao AT ROW 5.5 COL 50.57 COLON-ALIGNED NO-LABEL
     cIniFamilia AT ROW 6.5 COL 16 COLON-ALIGNED
     cFimFamilia AT ROW 6.5 COL 50.57 COLON-ALIGNED NO-LABEL
     iIniFornec AT ROW 7.5 COL 26.43 RIGHT-ALIGNED
     iFimFornec AT ROW 7.5 COL 61 RIGHT-ALIGNED NO-LABEL
     cIniNomeAbrev AT ROW 8.5 COL 16 COLON-ALIGNED
     cFimNomeAbrev AT ROW 8.5 COL 50.57 COLON-ALIGNED NO-LABEL
     cIniContrCompras AT ROW 9.5 COL 16 COLON-ALIGNED
     cFimContrCompras AT ROW 9.5 COL 50.57 COLON-ALIGNED NO-LABEL
     cIniProcCompras AT ROW 10.5 COL 16 COLON-ALIGNED
     cFimProcCompras AT ROW 10.5 COL 50.57 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 1.5 COL 35.14
     IMAGE-10 AT ROW 4.5 COL 49.86
     IMAGE-11 AT ROW 5.5 COL 35.14
     IMAGE-12 AT ROW 5.5 COL 49.86
     IMAGE-13 AT ROW 6.5 COL 35.14
     IMAGE-14 AT ROW 6.5 COL 49.86
     IMAGE-15 AT ROW 7.5 COL 35.14
     IMAGE-16 AT ROW 7.5 COL 49.86
     IMAGE-17 AT ROW 8.5 COL 35.14
     IMAGE-18 AT ROW 8.5 COL 49.86
     IMAGE-19 AT ROW 9.5 COL 35.14
     IMAGE-2 AT ROW 1.5 COL 49.86
     IMAGE-20 AT ROW 9.5 COL 49.86
     IMAGE-21 AT ROW 10.5 COL 35.14
     IMAGE-22 AT ROW 10.5 COL 49.86
     IMAGE-3 AT ROW 2.5 COL 35.14
     IMAGE-4 AT ROW 2.5 COL 49.86
     IMAGE-5 AT ROW 1.5 COL 35.14
     IMAGE-6 AT ROW 1.5 COL 49.86
     IMAGE-7 AT ROW 3.5 COL 35.14
     IMAGE-8 AT ROW 3.5 COL 49.86
     IMAGE-9 AT ROW 4.5 COL 35.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 11.71
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btConfigImpr AT ROW 3.58 COL 43.29 HELP
          "Configura‡Æo da impressora"
     btFile AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
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
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 11.71
         FONT 1.

DEFINE FRAME fPage4
     rs-gera AT ROW 3 COL 8 NO-LABEL
     cb-Recalcula AT ROW 6.25 COL 8
     RECT-13 AT ROW 2.5 COL 5
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 11.71
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
         MAX-HEIGHT         = 28.08
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.08
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
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN cFimEstabel IN FRAME fPage2
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
/* SETTINGS FOR FILL-IN cIniEstabel IN FRAME fPage2
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
/* SETTINGS FOR FILL-IN iFimFornec IN FRAME fPage2
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN iIniFornec IN FRAME fPage2
   ALIGN-R                                                              */
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
   do  on error undo, return no-apply:
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME rs-gera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-gera wReport
ON VALUE-CHANGED OF rs-gera IN FRAME fPage4
DO:
    assign frame fPage4 rs-gera.
    if  rs-gera = 1 then
        assign cb-Recalcula:sensitive in frame fPage4 = yes.
    else
        assign cb-Recalcula:sensitive in frame fPage4 = no
               cb-Recalcula:checked in frame fPage4 = no.

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
        when "1" then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes.
        end.
        when "2" then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no.
        end.
        when "3" then do:
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


/*--- L¢gica para inicializa‡Æo do programam ---*/
{report/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wReport 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.071" &THEN
    ASSIGN cFimEstabel:SCREEN-VALUE IN FRAME fPage2 = "ZZZZZ".
&ELSE
    ASSIGN cFimEstabel:SCREEN-VALUE IN FRAME fPage2 = "ZZZ". 
&ENDIF

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

/*** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}

    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).

        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show", input 73, input "").
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.

    /* Coloque aqui as valida‡äes da p gina de Digita‡Æo, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p gina e colocar
       o focus no campo com problemas */


    /* Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */



    /* Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */

    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.c-ini-item          = input frame fPage2 cIniItem        
           tt-param.c-fim-item          = input frame fPage2 cFimItem        
           tt-param.c-ini-estabel       = input frame fPage2 cIniEstabel     
           tt-param.c-fim-estabel       = input frame fPage2 cFimEstabel     
           tt-param.c-ini-comprador     = input frame fPage2 cIniComprador   
           tt-param.c-fim-comprador     = input frame fPage2 cFimComprador   
           tt-param.i-ini-ordem         = input frame fPage2 iIniOrdem       
           tt-param.i-fim-ordem         = input frame fPage2 iFimOrdem       
           tt-param.d-ini-dt-emissao    = input frame fPage2 dIniDtEmissao   
           tt-param.d-fim-dt-emissao    = input frame fPage2 dFimDtEmissao   
           tt-param.c-ini-familia       = input frame fPage2 cIniFamilia     
           tt-param.c-fim-familia       = input frame fPage2 cFimFamilia     
           tt-param.i-ini-fornec        = input frame fPage2 iIniFornec      
           tt-param.i-fim-fornec        = input frame fPage2 iFimFornec      
           tt-param.c-ini-nome-abrev    = input frame fPage2 cIniNomeAbrev   
           tt-param.c-fim-nome-abrev    = input frame fPage2 cFimNomeAbrev   
           tt-param.i-ini-contr-compras = input frame fPage2 cIniContrCompras
           tt-param.i-fim-contr-compras = input frame fPage2 cFimContrCompras
           tt-param.i-ini-proc-compras  = input frame fPage2 cIniProcCompras 
           tt-param.i-fim-proc-compras  = input frame fPage2 cFimProcCompras 
           tt-param.i-gera              = input frame fPage4 rs-gera
           tt-param.l-recalcula         = input frame fPage4 cb-recalcula.


    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "".
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.

    /* Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */



    /* Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}

    SESSION:SET-WAIT-STATE("GENERAL":U).

    {report/rprun.i imp/im0016rp.p}

    {report/rpexc.i}

    SESSION:SET-WAIT-STATE("":U).

    {report/rptrm.i}
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

