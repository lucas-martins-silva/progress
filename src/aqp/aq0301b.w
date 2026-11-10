&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0301B 2.00.00.006 } /*** 010006 ***/
/********************************************************************************
/*
 * Copyright (c) 2011, TOTVS S/A. Todos os direitos reservados.
 * 
 * Os Programas desta Aplica‡Æo (que incluem tanto o software quanto a sua
 * documenta‡Æo) cont‚m informa‡äes propriet rias da TOTVS S/A; eles sÆo
 * licenciados de acordo com um contrato de licença contendo restrições de uso e
 * confidencialidade, e sÆo tamb‚m protegidos pela Lei 9609/98 e 9610/98,
 * respectivamente Lei do Software e Lei dos Direitos Autorais. Engenharia
 * reversa, descompila‡Æo e desmontagem dos programas sÆo proibidos. Nenhuma
 * parte destes programas pode ser reproduzida ou transmitida de nenhuma forma e
 * por nenhum meio, eletr“nico ou mecƒnico, por motivo algum, sem a permissÆo
 * escrita da TOTVS S/A.
 */
*******************************************************************************/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0301b MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AQ0301B
&GLOBAL-DEFINE Version        2.00.00.006

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE page0Widgets   tg-todos tg-Iniciada tg-em-descarg tg-desc-concl tg-estoq-atual ~
                              tg-Encerrada tg-Reaberta ~
                              d-dt-trans btHelp btOK btCancel ~
                              c-cod-estabel i-num-carga-ini i-num-carga-fim c-carga-ini ~
                              c-carga-fim c-item-ini c-cod-rota-ini c-cod-rota-fim ~
                              c-item-fim d-dt-trans-ini ~
                              d-dt-trans-fim c-placa-ini ~
                              c-placa-fim c-lbl-sit~
                              btHelp btOK btCancel ~


/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAM p-tg-todos          AS LOGICAL NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-tg-Iniciada       AS LOGICAL NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-tg-em-descarg     AS LOGICAL NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-tg-desc-concl     AS LOGICAL NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-tg-estoq-atual    AS LOGICAL NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-tg-Encerrada      AS LOGICAL NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-tg-Reaberta       AS LOGICAL NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-dt-trans          AS DATE    NO-UNDO.


DEFINE INPUT-OUTPUT PARAM p-cod-estabel      LIKE docum-est.cod-estabel NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-num-carga-ini    AS   INTEGER               NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-num-carga-fim    AS   INTEGER               NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-carga-ini        AS   CHARACTER             NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-carga-fim        AS   CHARACTER             NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-item-ini         AS   CHARACTER             NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-item-fim         AS   CHARACTER             NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-dt-trans-ini     LIKE docum-est.dt-trans    NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-dt-trans-fim     LIKE docum-est.dt-trans    NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-placa-ini        AS   CHARACTER             NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-placa-fim        AS   CHARACTER             NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-cod-rota-ini     AS   CHARACTER             NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-cod-rota-fim     AS   CHARACTER             NO-UNDO.
DEFINE INPUT-OUTPUT PARAM pl-ok              AS   LOGICAL               NO-UNDO.

DEFINE VARIABLE h-boad098na    AS HANDLE      NO-UNDO.
DEFINE VARIABLE wh-pesquisa    AS HANDLE      NO-UNDO.
/* Local Variable Definitions (DBOs Handles) --- */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
{cdp/cdcfgmat.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-cod-estabel i-num-carga-ini ~
i-num-carga-fim c-carga-ini c-carga-fim c-item-ini c-item-fim ~
d-dt-trans-ini d-dt-trans-fim c-placa-ini c-placa-fim btOK btCancel btHelp ~
d-dt-trans tg-todos tg-Iniciada tg-em-descarg tg-desc-concl tg-estoq-atual ~
tg-Encerrada tg-Reaberta c-lbl-sit c-cod-rota-ini c-cod-rota-fim IMAGE-1 ~
IMAGE-10 IMAGE-11 IMAGE-12 IMAGE-2 IMAGE-7 IMAGE-8 IMAGE-9 rtToolBar ~
IMAGE-15 IMAGE-16 RECT-1 RECT-3 IMAGE-17 IMAGE-18 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estabel i-num-carga-ini ~
i-num-carga-fim c-carga-ini c-carga-fim c-item-ini c-item-fim ~
d-dt-trans-ini d-dt-trans-fim c-placa-ini c-placa-fim d-dt-trans tg-todos ~
tg-Iniciada tg-em-descarg tg-desc-concl tg-estoq-atual tg-Encerrada ~
tg-Reaberta c-lbl-sit c-cod-rota-ini c-cod-rota-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-carga-fim AS CHARACTER FORMAT "X(256)" INITIAL "ZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-carga-ini AS CHARACTER FORMAT "X(256)" 
     LABEL "C¢digo":R8 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "X(5)" 
     LABEL "Estabelecimento":R15 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-rota-fim AS CHARACTER FORMAT "x(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE c-cod-rota-ini AS CHARACTER FORMAT "x(12)" 
     LABEL "Rota":R7 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE c-item-fim AS CHARACTER FORMAT "X(256)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE c-item-ini AS CHARACTER FORMAT "X(256)" 
     LABEL "Item":R12 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE c-lbl-sit AS CHARACTER FORMAT "X(256)":U INITIAL "Situa‡Æo Documento" 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

DEFINE VARIABLE c-placa-fim AS CHARACTER FORMAT "x(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE c-placa-ini AS CHARACTER FORMAT "x(12)" 
     LABEL "Placa":R7 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE d-dt-trans AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Transa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE d-dt-trans-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88.

DEFINE VARIABLE d-dt-trans-ini AS DATE FORMAT "99/99/9999" INITIAL 01/01/1800 
     LABEL "Data Transa‡Æo":R17 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-carga-fim AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 17 BY .79 NO-UNDO.

DEFINE VARIABLE i-num-carga-ini AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Carga" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .79 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
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

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 5.75.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 7.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 78 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-desc-concl AS LOGICAL INITIAL no 
     LABEL "Descarga Concu¡da" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.

DEFINE VARIABLE tg-em-descarg AS LOGICAL INITIAL no 
     LABEL "Em Descarga" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .75 NO-UNDO.

DEFINE VARIABLE tg-Encerrada AS LOGICAL INITIAL no 
     LABEL "Carga Encerrada" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.

DEFINE VARIABLE tg-estoq-atual AS LOGICAL INITIAL no 
     LABEL "Estoque Atualizado" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .83 NO-UNDO.

DEFINE VARIABLE tg-Iniciada AS LOGICAL INITIAL no 
     LABEL "Iniciada" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE tg-Reaberta AS LOGICAL INITIAL no 
     LABEL "Carga Reaberta" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-todos AS LOGICAL INITIAL no 
     LABEL "Todos" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-cod-estabel AT ROW 7.75 COL 19 COLON-ALIGNED
     i-num-carga-ini AT ROW 8.75 COL 19 COLON-ALIGNED WIDGET-ID 2
     i-num-carga-fim AT ROW 8.75 COL 44.57 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     c-carga-ini AT ROW 9.75 COL 19 COLON-ALIGNED
     c-carga-fim AT ROW 9.75 COL 44.57 COLON-ALIGNED NO-LABEL
     c-item-ini AT ROW 10.75 COL 19 COLON-ALIGNED HELP
          "C¢digo do Item"
     c-item-fim AT ROW 10.75 COL 44.57 COLON-ALIGNED HELP
          "C¢digo do Item" NO-LABEL
     d-dt-trans-ini AT ROW 11.75 COL 19 COLON-ALIGNED
     d-dt-trans-fim AT ROW 11.75 COL 44.57 COLON-ALIGNED HELP
          "Data de transa‡Æo da nota fiscal" NO-LABEL
     c-placa-ini AT ROW 12.75 COL 19 COLON-ALIGNED
     c-placa-fim AT ROW 12.75 COL 44.57 COLON-ALIGNED NO-LABEL
     btOK AT ROW 15.83 COL 2
     btCancel AT ROW 15.83 COL 13
     btHelp AT ROW 15.83 COL 68.29
     d-dt-trans AT ROW 2.04 COL 42 COLON-ALIGNED WIDGET-ID 12
     tg-todos AT ROW 2.17 COL 5.57 WIDGET-ID 32
     tg-Iniciada AT ROW 3.13 COL 8 WIDGET-ID 22
     tg-em-descarg AT ROW 4.13 COL 8
     tg-desc-concl AT ROW 5.13 COL 8
     tg-estoq-atual AT ROW 6.13 COL 8
     tg-Encerrada AT ROW 3.04 COL 44 WIDGET-ID 16
     tg-Reaberta AT ROW 4.04 COL 44 WIDGET-ID 28
     c-lbl-sit AT ROW 1.25 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     c-cod-rota-ini AT ROW 13.75 COL 19 COLON-ALIGNED
     c-cod-rota-fim AT ROW 13.75 COL 44.57 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 11.75 COL 38.57
     IMAGE-10 AT ROW 10.75 COL 43.29
     IMAGE-11 AT ROW 12.75 COL 38.57
     IMAGE-12 AT ROW 12.75 COL 43.29
     IMAGE-2 AT ROW 11.75 COL 43.29
     IMAGE-7 AT ROW 9.75 COL 38.57
     IMAGE-8 AT ROW 9.75 COL 43.29
     IMAGE-9 AT ROW 10.75 COL 38.57
     rtToolBar AT ROW 15.58 COL 1
     IMAGE-15 AT ROW 8.75 COL 38.57 WIDGET-ID 4
     IMAGE-16 AT ROW 8.75 COL 43.29 WIDGET-ID 6
     RECT-1 AT ROW 1.5 COL 1 WIDGET-ID 10
     RECT-3 AT ROW 7.5 COL 1 WIDGET-ID 36
     IMAGE-17 AT ROW 13.75 COL 38.57 WIDGET-ID 42
     IMAGE-18 AT ROW 13.75 COL 43.29 WIDGET-ID 44
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 78.57 BY 16.04
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.25
         WIDTH              = 78.14
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
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


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:   
    IF INPUT FRAME fPage0 d-dt-trans > TODAY THEN DO:
        RUN utp/ut-msgs.p (INPUT 'SHOW':U,
                           INPUT 54724, /* Data inválida! */
                           INPUT ' ').
        RETURN NO-APPLY.    
    END.
    
    ASSIGN p-cod-estabel   = INPUT FRAME fPage0 c-cod-estabel
           p-num-carga-ini = INPUT FRAME fPage0 i-num-carga-ini 
           p-num-carga-fim = INPUT FRAME fPage0 i-num-carga-fim 
           p-carga-ini     = INPUT FRAME fPage0 c-carga-ini
           p-carga-fim     = INPUT FRAME fPage0 c-carga-fim
           p-item-ini      = INPUT FRAME fPage0 c-item-ini 
           p-item-fim      = INPUT FRAME fPage0 c-item-fim 
           p-dt-trans-ini  = INPUT FRAME fPage0 d-dt-trans-ini
           p-dt-trans-fim  = INPUT FRAME fPage0 d-dt-trans-fim
           p-placa-ini     = INPUT FRAME fPage0 c-placa-ini
           p-placa-fim     = INPUT FRAME fPage0 c-placa-fim
           p-cod-rota-ini  = INPUT FRAME fPage0 c-cod-rota-ini
           p-cod-rota-fim  = INPUT FRAME fPage0 c-cod-rota-fim
           
           p-tg-todos          = INPUT FRAME fPage0 tg-todos          
           p-tg-Iniciada       = INPUT FRAME fPage0 tg-Iniciada      
           p-tg-em-descarg     = INPUT FRAME fPage0 tg-em-descarg  
           p-tg-desc-concl     = INPUT FRAME fPage0 tg-desc-concl   
           p-tg-estoq-atual    = INPUT FRAME fPage0 tg-estoq-atual           
           p-tg-Encerrada      = INPUT FRAME fPage0 tg-Encerrada     
           p-tg-Reaberta       = INPUT FRAME fPage0 tg-Reaberta      
           p-dt-trans          = INPUT FRAME fPage0 d-dt-trans 
           pl-ok               = YES. 
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-desc-concl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-desc-concl wWindow
ON VALUE-CHANGED OF tg-desc-concl IN FRAME fpage0 /* Descarga Concu¡da */
DO:
  run marcaTodos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-em-descarg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-em-descarg wWindow
ON VALUE-CHANGED OF tg-em-descarg IN FRAME fpage0 /* Em Descarga */
DO:
  run marcaTodos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-Encerrada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-Encerrada wWindow
ON VALUE-CHANGED OF tg-Encerrada IN FRAME fpage0 /* Carga Encerrada */
DO:
  run marcaTodos.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-estoq-atual
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-estoq-atual wWindow
ON VALUE-CHANGED OF tg-estoq-atual IN FRAME fpage0 /* Estoque Atualizado */
DO:
  run marcaTodos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-Iniciada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-Iniciada wWindow
ON VALUE-CHANGED OF tg-Iniciada IN FRAME fpage0 /* Iniciada */
DO:
  run marcaTodos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-Reaberta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-Reaberta wWindow
ON VALUE-CHANGED OF tg-Reaberta IN FRAME fpage0 /* Carga Reaberta */
DO:
  run marcaTodos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-todos wWindow
ON VALUE-CHANGED OF tg-todos IN FRAME fpage0 /* Todos */
DO:
    ASSIGN tg-Iniciada       = tg-todos:CHECKED IN FRAME fPage0 
           tg-em-descarg   = tg-todos:CHECKED IN FRAME fPage0 
           tg-desc-concl    = tg-todos:CHECKED IN FRAME fPage0 
           tg-estoq-atual            = tg-todos:CHECKED IN FRAME fPage0 
           tg-Encerrada      = tg-todos:CHECKED IN FRAME fPage0 
           tg-Reaberta       = tg-todos:CHECKED IN FRAME fPage0.

    DISP tg-Iniciada      
         tg-em-descarg  
         tg-desc-concl   
         tg-estoq-atual           
         tg-Encerrada     
         tg-Reaberta      
         WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  Purpose: Atualiza‡Æo de dados de campos em tela    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    ASSIGN c-cod-estabel   = p-cod-estabel   
           i-num-carga-ini = p-num-carga-ini
           i-num-carga-fim = p-num-carga-fim
           c-carga-ini     = p-carga-ini     
           c-carga-fim     = p-carga-fim     
           c-item-ini      = p-item-ini      
           c-item-fim      = p-item-fim     
           d-dt-trans-ini  = p-dt-trans-ini
           d-dt-trans-fim  = p-dt-trans-fim
           c-placa-ini     = p-placa-ini     
           c-placa-fim     = p-placa-fim   
           c-cod-rota-ini  = p-cod-rota-ini    
           c-cod-rota-fim  = p-cod-rota-fim  
            
           tg-todos           =  p-tg-todos         
           tg-Iniciada        =  p-tg-Iniciada      
           tg-em-descarg      =  p-tg-em-descarg  
           tg-desc-concl      =  p-tg-desc-concl   
           tg-estoq-atual     =  p-tg-estoq-atual           
           tg-Encerrada       =  p-tg-Encerrada     
           tg-Reaberta        =  p-tg-Reaberta      
           d-dt-trans         =  p-dt-trans 
           pl-ok              =  NO.

    DISP c-cod-estabel  
         i-num-carga-ini
         i-num-carga-fim
         c-carga-ini    
         c-carga-fim    
         c-item-ini     
         c-item-fim     
         d-dt-trans-ini 
         d-dt-trans-fim 
         c-placa-ini    
         c-placa-fim  
         c-cod-rota-ini 
         c-cod-rota-fim 

         tg-todos         
         tg-Iniciada      
         tg-em-descarg  
         tg-desc-concl   
         tg-estoq-atual           
         tg-Encerrada     
         tg-Reaberta      
         d-dt-trans         
                  
                          

        WITH FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE marcaTodos wWindow 
PROCEDURE marcaTodos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    IF  tg-Iniciada:CHECKED IN FRAME fPage0      
        AND tg-em-descarg:CHECKED IN FRAME fPage0      
        AND tg-desc-concl:CHECKED IN FRAME fPage0      
        AND tg-estoq-atual:CHECKED IN FRAME fPage0      
        AND tg-Encerrada:CHECKED IN FRAME fPage0      
        AND tg-Reaberta:CHECKED IN FRAME fPage0 THEN 

        ASSIGN tg-todos:CHECKED IN FRAME fPage0 = YES.
    ELSE
        ASSIGN tg-todos:CHECKED IN FRAME fPage0 = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

