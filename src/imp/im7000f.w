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
{include/i-prgvrs.i IM7000F 2.00.00.002} /* 16/12/2024 18:44:04 */

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM7000F MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM7000F
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0

&GLOBAL-DEFINE page0Widgets   c-diretorio-json rd-opcao-json tg-somente-json bt-dir-json ~
                              btExecutar btCancel btHelp2

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAM pcod-duimp-dts LIKE duimp-siscomex.cod-duimp-dts NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-imapi020 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-acomp    AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-1 RECT-106 rd-opcao-json ~
tg-somente-json bt-dir-json c-diretorio-json btExecutar btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS rd-opcao-json tg-somente-json ~
c-diretorio-json 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-dir-json 
     IMAGE-UP FILE "image/im-sea.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sea.bmp":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExecutar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-diretorio-json AS CHARACTER FORMAT "X(2000)":U 
     LABEL "Gerar em" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE rd-opcao-json AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Dados Gerais da DUIMP", 1,
"Itens da DUIMP", 2
     SIZE 22 BY 2.25 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67 BY 2.75.

DEFINE RECTANGLE RECT-106
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 3.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 68 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-somente-json AS LOGICAL INITIAL no 
     LABEL "Somente gera JSON local" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.5 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     rd-opcao-json AT ROW 1.92 COL 24.14 NO-LABEL WIDGET-ID 10
     tg-somente-json AT ROW 5.5 COL 12 WIDGET-ID 18
     bt-dir-json AT ROW 6.54 COL 61.57 WIDGET-ID 8
     c-diretorio-json AT ROW 6.58 COL 9.57 COLON-ALIGNED WIDGET-ID 6
     btExecutar AT ROW 8.46 COL 2
     btCancel AT ROW 8.46 COL 13
     btHelp2 AT ROW 8.46 COL 58.14
     "JSON" VIEW-AS TEXT
          SIZE 4.57 BY .54 AT ROW 1.13 COL 16 WIDGET-ID 16
     rtToolBar AT ROW 8.25 COL 1
     RECT-1 AT ROW 5.13 COL 2 WIDGET-ID 2
     RECT-106 AT ROW 1.33 COL 11.57 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 68.86 BY 8.71
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
         HEIGHT             = 8.71
         WIDTH              = 68.86
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
   FRAME-NAME                                                           */
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


&Scoped-define SELF-NAME bt-dir-json
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-dir-json wWindow
ON CHOOSE OF bt-dir-json IN FRAME fpage0
DO:
    DEFINE VARIABLE lCancelouBuscaDir     AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cDiretorioSelecionado AS CHARACTER   NO-UNDO.

    {utp/ut-liter.i Selecionar_Diret¢rio}
    RUN utp/ut-dir.p (INPUT RETURN-VALUE,
                      OUTPUT cDiretorioSelecionado,
                      OUTPUT lCancelouBuscaDir). /* se cancelado = yes */

    IF  NOT lCancelouBuscaDir THEN DO:
        ASSIGN c-diretorio-json = cDiretorioSelecionado.
        DISPLAY c-diretorio-json WITH FRAME fpage0.
    END.
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


&Scoped-define SELF-NAME btExecutar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExecutar wWindow
ON CHOOSE OF btExecutar IN FRAME fpage0 /* Executar */
DO:
    IF NOT VALID-HANDLE(h-imapi020) THEN
        RUN imp/imapi020.p PERSISTENT SET h-imapi020.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    {utp/ut-liter.i "Integra‡Æo_DUIMP_Siscomex" *}
    RUN pi-inicializar  IN h-acomp (INPUT RETURN-VALUE).
    run pi-desabilita-cancela in h-acomp.

    IF input frame fpage0 rd-opcao-json = 1 then
        RUN executaEnvioSiscomex IN h-imapi020 (INPUT pcod-duimp-dts,
                                                INPUT INPUT FRAME fpage0 tg-somente-json,
                                                INPUT INPUT FRAME fPage0 c-diretorio-json).
    else
        RUN executaEnvioSiscomexItens IN h-imapi020 (INPUT pcod-duimp-dts,
                                                     INPUT INPUT FRAME fpage0 tg-somente-json,
                                                     INPUT INPUT FRAME fPage0 c-diretorio-json,
                                                     OUTPUT TABLE RowErrors).
                                                     
    IF CAN-FIND(FIRST RowErrors) THEN DO:
        {method/showmessage.i1}
        /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
        {method/showmessage.i2}
    END.

    RUN pi-finalizar IN h-acomp.
    
    

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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(h-imapi020) THEN DO:
        DELETE PROCEDURE h-imapi020.
        ASSIGN h-imapi020 = ?.
    END.                               
          
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN c-diretorio-json:SCREEN-VALUE IN FRAME fPage0 = SESSION:TEMP-DIRECTORY.
   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

