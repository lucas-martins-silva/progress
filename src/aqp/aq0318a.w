&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0318A 2.00.00.001 } /*** 010001 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0318a MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AQ0318a
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   tg-todos tg-todos-2 tg-dif-quantidade tg-problema-qualidade tg-nao-coleta tg-pendente tg-em-analise tg-resolvida ~
                              fi-estabelecimento fi-carga-ini fi-carga-fim fi-nao-conformidade-ini fi-nao-conformidade-fim fi-data-ini fi-data-fim
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF INPUT-OUTPUT PARAM p-dif-quantidade       AS LOG  NO-UNDO.
DEF INPUT-OUTPUT PARAM p-problema-qualidade   AS LOG  NO-UNDO.
DEF INPUT-OUTPUT PARAM p-nao-coleta           AS LOG  NO-UNDO.
DEF INPUT-OUTPUT PARAM p-pendente             AS LOG  NO-UNDO.
DEF INPUT-OUTPUT PARAM p-em-analise           AS LOG  NO-UNDO.
DEF INPUT-OUTPUT PARAM p-resolvida            AS LOG  NO-UNDO.
DEF INPUT-OUTPUT PARAM p-estabelecimento      AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM p-carga-ini            AS INT  NO-UNDO.
DEF INPUT-OUTPUT PARAM p-carga-fim            AS INT  NO-UNDO.
DEF INPUT-OUTPUT PARAM p-nao-conformidade-ini AS INT  NO-UNDO.
DEF INPUT-OUTPUT PARAM p-nao-conformidade-fim AS INT  NO-UNDO.
DEF INPUT-OUTPUT PARAM p-data-ini             AS DATE NO-UNDO.
DEF INPUT-OUTPUT PARAM p-data-fim             AS DATE NO-UNDO.

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
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 73.72 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fi-carga-fim AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-carga-ini AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Carga":U 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-data-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-data-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Trans":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabelecimento AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelecimento":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nao-conformidade-fim AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nao-conformidade-ini AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "NÆo Conformidade":U 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

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

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69 BY 4.75.

DEFINE RECTANGLE RECT-PARAM
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69 BY 5.67.

DEFINE RECTANGLE RECT-SELECAO
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69 BY 4.75.

DEFINE VARIABLE tg-dif-quantidade AS LOGICAL INITIAL no 
     LABEL "Dif. de Quantidade":U 
     VIEW-AS TOGGLE-BOX
     SIZE 16.14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-em-analise AS LOGICAL INITIAL no 
     LABEL "Em An lise":U 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-nao-coleta AS LOGICAL INITIAL no 
     LABEL "NÆo Coleta":U 
     VIEW-AS TOGGLE-BOX
     SIZE 18.14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-pendente AS LOGICAL INITIAL no 
     LABEL "Pendente":U 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-problema-qualidade AS LOGICAL INITIAL no 
     LABEL "Problema Qualidade":U 
     VIEW-AS TOGGLE-BOX
     SIZE 18.14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-resolvida AS LOGICAL INITIAL no 
     LABEL "Resolvida":U 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-todos AS LOGICAL INITIAL no 
     LABEL "Todos":U 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-todos-2 AS LOGICAL INITIAL no 
     LABEL "Todos":U 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 13.25 COL 2
     btCancel AT ROW 13.25 COL 13
     btHelp2 AT ROW 13.25 COL 61.86
     rtToolBar AT ROW 13.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 73.72 BY 13.75
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tg-todos AT ROW 2.75 COL 6.14 WIDGET-ID 8
     tg-todos-2 AT ROW 2.75 COL 34 WIDGET-ID 22
     tg-dif-quantidade AT ROW 3.75 COL 8.29 WIDGET-ID 10
     tg-pendente AT ROW 3.75 COL 36.72 WIDGET-ID 24
     tg-problema-qualidade AT ROW 4.75 COL 8.29 WIDGET-ID 12
     tg-em-analise AT ROW 4.75 COL 36.72 WIDGET-ID 26
     tg-nao-coleta AT ROW 5.75 COL 8.29 WIDGET-ID 14
     tg-resolvida AT ROW 5.75 COL 36.72 WIDGET-ID 28
     fi-estabelecimento AT ROW 7.5 COL 17 COLON-ALIGNED WIDGET-ID 30
     fi-carga-ini AT ROW 8.5 COL 17 COLON-ALIGNED WIDGET-ID 32
     fi-carga-fim AT ROW 8.5 COL 41.57 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     fi-nao-conformidade-ini AT ROW 9.5 COL 17 COLON-ALIGNED WIDGET-ID 38
     fi-nao-conformidade-fim AT ROW 9.5 COL 41.57 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     fi-data-ini AT ROW 10.5 COL 17 COLON-ALIGNED WIDGET-ID 42
     fi-data-fim AT ROW 10.5 COL 41.57 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     "Tipo NÆo Conformidade" VIEW-AS TEXT
          SIZE 17.29 BY 1.25 AT ROW 1.5 COL 6.14 WIDGET-ID 6
     "Situa‡Æo NÆo Conformidade" VIEW-AS TEXT
          SIZE 20 BY 1.25 AT ROW 1.5 COL 34 WIDGET-ID 18
     RECT-PARAM AT ROW 1.33 COL 1.86 WIDGET-ID 2
     RECT-2 AT ROW 7.25 COL 2 WIDGET-ID 4
     IMAGE-1 AT ROW 8.5 COL 35.86 WIDGET-ID 44
     IMAGE-2 AT ROW 8.5 COL 40.14 WIDGET-ID 46
     RECT-SELECAO AT ROW 7.25 COL 2 WIDGET-ID 52
     IMAGE-3 AT ROW 8.5 COL 35.86 WIDGET-ID 48
     IMAGE-4 AT ROW 8.5 COL 40.14 WIDGET-ID 50
     IMAGE-5 AT ROW 9.5 COL 35.86 WIDGET-ID 54
     IMAGE-6 AT ROW 9.5 COL 40.14 WIDGET-ID 56
     IMAGE-7 AT ROW 10.5 COL 35.86 WIDGET-ID 58
     IMAGE-8 AT ROW 10.5 COL 40.14 WIDGET-ID 60
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.14 ROW 1.25
         SIZE 71 BY 11.5
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
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 13.79
         WIDTH              = 73.43
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:

    ASSIGN p-estabelecimento      = fi-estabelecimento:SCREEN-VALUE IN FRAME fpage1
           p-carga-ini            = INT(fi-carga-ini:SCREEN-VALUE IN FRAME fpage1)    
           p-carga-fim            = INT(fi-carga-fim:SCREEN-VALUE IN FRAME fpage1)    
           p-nao-conformidade-ini = INT(fi-nao-conformidade-ini:SCREEN-VALUE IN FRAME fpage1)
           p-nao-conformidade-fim = INT(fi-nao-conformidade-fim:SCREEN-VALUE IN FRAME fpage1)
           p-data-ini             = DATE(fi-data-ini:SCREEN-VALUE IN FRAME fpage1)
           p-data-fim             = DATE(fi-data-fim:SCREEN-VALUE IN FRAME fpage1)
           p-dif-quantidade       = tg-dif-quantidade:CHECKED IN FRAME fpage1
           p-problema-qualidade   = tg-problema-qualidade:CHECKED IN FRAME fpage1
           p-nao-coleta           = tg-nao-coleta:CHECKED IN FRAME fpage1
           p-pendente             = tg-pendente:CHECKED IN FRAME fpage1
           p-em-analise           = tg-em-analise:CHECKED IN FRAME fpage1
           p-resolvida            = tg-resolvida:CHECKED IN FRAME fpage1.

    APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tg-dif-quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-dif-quantidade wWindow
ON VALUE-CHANGED OF tg-dif-quantidade IN FRAME fPage1 /* Dif. de Quantidade */
DO:
    RUN piVerificaToggle.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-em-analise
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-em-analise wWindow
ON VALUE-CHANGED OF tg-em-analise IN FRAME fPage1 /* Em An lise */
DO:

    RUN piVerificaToggle2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-nao-coleta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-nao-coleta wWindow
ON VALUE-CHANGED OF tg-nao-coleta IN FRAME fPage1 /* NÆo Coleta */
DO:

    RUN piVerificaToggle.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-pendente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-pendente wWindow
ON VALUE-CHANGED OF tg-pendente IN FRAME fPage1 /* Pendente */
DO:

    RUN piVerificaToggle2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-problema-qualidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-problema-qualidade wWindow
ON VALUE-CHANGED OF tg-problema-qualidade IN FRAME fPage1 /* Problema Qualidade */
DO:

    RUN piVerificaToggle.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-resolvida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-resolvida wWindow
ON VALUE-CHANGED OF tg-resolvida IN FRAME fPage1 /* Resolvida */
DO:

    RUN piVerificaToggle2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-todos wWindow
ON VALUE-CHANGED OF tg-todos IN FRAME fPage1 /* Todos */
DO:
  IF tg-todos:CHECKED IN FRAME fpage1 THEN DO:
      ASSIGN tg-dif-quantidade:CHECKED     IN FRAME fpage1 = YES
             tg-problema-qualidade:CHECKED IN FRAME fpage1 = YES
             tg-nao-coleta:CHECKED         IN FRAME fpage1 = YES.
  END.
  ELSE DO:
      ASSIGN tg-dif-quantidade:CHECKED     IN FRAME fpage1 = NO
             tg-problema-qualidade:CHECKED IN FRAME fpage1 = NO
             tg-nao-coleta:CHECKED         IN FRAME fpage1 = NO.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-todos-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-todos-2 wWindow
ON VALUE-CHANGED OF tg-todos-2 IN FRAME fPage1 /* Todos */
DO:
  IF tg-todos-2:CHECKED IN FRAME fpage1 THEN DO:
      ASSIGN tg-pendente:CHECKED   IN FRAME fpage1 = YES
             tg-em-analise:CHECKED IN FRAME fpage1 = YES
             tg-resolvida:CHECKED  IN FRAME fpage1 = YES.
  END.
  ELSE DO:
      ASSIGN tg-pendente:CHECKED   IN FRAME fpage1 = NO
             tg-em-analise:CHECKED IN FRAME fpage1 = NO
             tg-resolvida:CHECKED  IN FRAME fpage1 = NO.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose: Marcar todas as situa‡äes em tela    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF p-dif-quantidade THEN
        ASSIGN tg-dif-quantidade:CHECKED IN FRAME fpage1 = YES.
    IF p-problema-qualidade THEN
        ASSIGN tg-problema-qualidade:CHECKED IN FRAME fpage1 = YES.
    IF p-nao-coleta THEN
        ASSIGN tg-nao-coleta:CHECKED IN FRAME fpage1 = YES.

    RUN piVerificaToggle.

    IF p-pendente THEN
        ASSIGN tg-pendente:CHECKED IN FRAME fpage1 = YES.
    IF p-em-analise THEN
        ASSIGN tg-em-analise:CHECKED IN FRAME fpage1 = YES.
    IF p-resolvida THEN
        ASSIGN tg-resolvida:CHECKED IN FRAME fpage1 = YES.

    RUN piVerificaToggle2.


    ASSIGN fi-estabelecimento:SCREEN-VALUE IN FRAME fpage1      = p-estabelecimento
           fi-carga-ini:SCREEN-VALUE IN FRAME fpage1            = string(p-carga-ini)
           fi-carga-fim:SCREEN-VALUE IN FRAME fpage1            = string(p-carga-fim)
           fi-nao-conformidade-ini:SCREEN-VALUE IN FRAME fpage1 = string(p-nao-conformidade-ini)
           fi-nao-conformidade-fim:SCREEN-VALUE IN FRAME fpage1 = string(p-nao-conformidade-fim)
           fi-data-ini:SCREEN-VALUE IN FRAME fpage1             = string(p-data-ini)
           fi-data-fim:SCREEN-VALUE IN FRAME fpage1             = string(p-data-fim).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaToggle wWindow 
PROCEDURE piVerificaToggle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF tg-dif-quantidade:CHECKED IN FRAME fpage1 AND tg-problema-qualidade:CHECKED IN FRAME fpage1
        AND tg-nao-coleta:CHECKED IN FRAME fpage1 THEN
        tg-todos:CHECKED IN FRAME fpage1 = YES.
    ELSE
        tg-todos:CHECKED IN FRAME fpage1 = NO.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaToggle2 wWindow 
PROCEDURE piVerificaToggle2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF tg-pendente:CHECKED IN FRAME fpage1 
    AND tg-em-analise:CHECKED IN FRAME fpage1
    AND tg-resolvida:CHECKED IN FRAME fpage1 THEN
        ASSIGN tg-todos-2:CHECKED IN FRAME fpage1 = YES.
    ELSE
        ASSIGN tg-todos-2:CHECKED IN FRAME fpage1 = NO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

