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
{include/i-prgvrs.i AB0805 2.00.00.002} /* 16/05/2025 17:37:31 */
{utp/ut-glob.i}
{cdp/cdunif001.i} /*vari†veis unificaá∆o de conceito*/
{abp/ab9000.i} /** Formato de Contas e Hora **/
{abp/abapi016.i}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AB0805 MAB}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0805
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE page0Widgets   btOK btSave btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   rs-tipo dat-movto c-hr-inicial i-ep-codigo c-cod-eqpto ~
                              de-contador de-contador-sec c-ct-codigo c-cc-codigo c-posto ~
                              c-cod-ativid i-empresa-matr c-estabel-matr c-cod-matr ~
                              c-cod-evento c-cod-rota c-cod-compart 

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-cod-emitente LIKE item-doc-est.cod-emitente NO-UNDO.
DEFINE INPUT PARAMETER p-nro-docto    LIKE item-doc-est.nro-docto NO-UNDO.
DEFINE INPUT PARAMETER p-serie-docto  LIKE item-doc-est.serie-docto NO-UNDO.
DEFINE INPUT PARAMETER p-nat-operacao LIKE item-doc-est.nat-operacao NO-UNDO.
DEFINE INPUT PARAMETER p-sequencia    LIKE item-doc-est.sequencia NO-UNDO.
DEFINE INPUT PARAMETER p-it-codigo    LIKE item-doc-est.it-codigo NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-mab-item-abastec-lubrific.


/* Local Variable Definitions ---                                       */

/*************************************************************
** Definiá∆o vari†veis validaá‰es em tela
*************************************************************/
DEFINE VARIABLE cCodModelo     AS CHARACTER                NO-UNDO.
DEFINE VARIABLE cHora          AS CHARACTER format "99:99" NO-UNDO.

/************************************************************
** Definiá∆o dos handles 
************************************************************/
DEFINE VARIABLE hDBOEqpto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOPosto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOMoto      AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEvento    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOComp      AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOFicha     AS HANDLE NO-UNDO.
DEFINE VARIABLE hApiFrota     AS HANDLE NO-UNDO.
define variable h-abastec     as handle no-undo.

/***********************************************************
** Definiá∆o vari†veis utilizadas internamente 
***********************************************************/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.
DEFINE VARIABLE lLogContSec                      AS LOGICAL NO-UNDO.
DEFINE VARIABLE cUnModelSec                      AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-operacao                       AS INTEGER NO-UNDO.
DEFINE VARIABLE c-aux                            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lEqptoComAcesso                  AS LOGICAL NO-UNDO.
DEFINE VARIABLE cEstabEqpto                      AS CHARACTER NO-UNDO.

/***********************************************************
** Definiá∆o vari†veis globais
***********************************************************/
define new global shared variable iEmpresa like mab-comptmento-eqpto.ep-codigo no-undo.
define new global shared variable cEqpto   like mab-comptmento-eqpto.cod-eqpto no-undo.

/*unificaá∆o de conceito - centro de custo e conta contabil*/
DEFINE VARIABLE cEmpresaEstab AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dDtMovimento  AS DATE        NO-UNDO.

/***********************************************************
** Definiá∆o buffer
***********************************************************/
DEFINE BUFFER bf-mab-abastec-lubrific FOR mab-abastec-lubrific.
DEFINE BUFFER bfComp for mab-comptmento.
DEFINE BUFFER bfEvento for mab-event.
DEFINE BUFFER bfGrupo for mab-grp-event.
DEFINE BUFFER bf-item-frota for item.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btSave btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPosto wWindow 
FUNCTION fnPosto RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


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

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE c-cc-codigo AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-ativid AS CHARACTER FORMAT "X(8)":U 
     LABEL "Atividade" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-compart AS CHARACTER FORMAT "X(8)":U 
     LABEL "Compartimento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-eqpto AS CHARACTER FORMAT "X(16)":U 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-evento AS CHARACTER FORMAT "X(8)":U 
     LABEL "Evento Frota" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-matr AS CHARACTER FORMAT "X(10)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-rota AS CHARACTER FORMAT "X(12)":U 
     LABEL "Trajeto" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-ct-codigo AS CHARACTER FORMAT "X(20)":U 
     LABEL "Conta Equipamento" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-compart AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-eqpto AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-evento AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-posto AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE c-estabel-matr AS CHARACTER FORMAT "X(5)":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-hr-inicial AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-motorista AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-posto AS CHARACTER FORMAT "X(8)":U 
     LABEL "Posto" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-un AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-sec AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE dat-movto AS DATE FORMAT "99/99/9999":U 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE de-contador AS DECIMAL FORMAT ">,>>>,>>9.9":U INITIAL 0 
     LABEL "Contador" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE de-contador-sec AS DECIMAL FORMAT ">,>>>,>>9.9":U INITIAL 0 
     LABEL "Contador Secund†rio" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-empresa-matr AS CHARACTER FORMAT "X(3)":U INITIAL "0" 
     LABEL "Motorista" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-ep-codigo AS CHARACTER FORMAT "X(3)":U INITIAL "0" 
     LABEL "Equipamento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE rs-tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Abastecimento", 1,
"Lubrificaá∆o", 2,
"Outros", 3
     SIZE 40 BY .58 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46 BY 1.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 13.46 COL 2
     btSave AT ROW 13.46 COL 13
     btCancel AT ROW 13.46 COL 23.86 WIDGET-ID 2
     btHelp2 AT ROW 13.46 COL 80
     rtToolBar AT ROW 13.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 13.71
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fpage1
     rs-tipo AT ROW 1.75 COL 23 NO-LABEL WIDGET-ID 6
     dat-movto AT ROW 3.25 COL 14 COLON-ALIGNED WIDGET-ID 2
     c-hr-inicial AT ROW 3.25 COL 24.29 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     i-ep-codigo AT ROW 4.25 COL 14 COLON-ALIGNED WIDGET-ID 12
     c-cod-eqpto AT ROW 4.25 COL 19.29 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     c-desc-eqpto AT ROW 4.25 COL 35.57 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     de-contador AT ROW 5.25 COL 14 COLON-ALIGNED WIDGET-ID 22
     c-un AT ROW 5.25 COL 24.29 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     de-contador-sec AT ROW 5.25 COL 59.57 COLON-ALIGNED WIDGET-ID 26
     c-un-sec AT ROW 5.25 COL 69.86 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     c-ct-codigo AT ROW 6.25 COL 38.72 COLON-ALIGNED WIDGET-ID 32
     c-cc-codigo AT ROW 6.25 COL 59 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     c-posto AT ROW 7.25 COL 14 COLON-ALIGNED WIDGET-ID 36
     c-desc-posto AT ROW 7.25 COL 24.29 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     c-cod-ativid AT ROW 7.25 COL 67.57 COLON-ALIGNED WIDGET-ID 40
     i-empresa-matr AT ROW 8.25 COL 14 COLON-ALIGNED WIDGET-ID 42
     c-estabel-matr AT ROW 8.25 COL 19.43 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     c-cod-matr AT ROW 8.25 COL 24.86 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     c-nome-motorista AT ROW 8.25 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     c-cod-evento AT ROW 9.25 COL 14 COLON-ALIGNED WIDGET-ID 50
     c-desc-evento AT ROW 9.25 COL 24.43 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     c-cod-rota AT ROW 9.25 COL 65.57 COLON-ALIGNED WIDGET-ID 54
     c-cod-compart AT ROW 10.25 COL 14 COLON-ALIGNED WIDGET-ID 56
     c-desc-compart AT ROW 10.25 COL 24.43 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     RECT-3 AT ROW 1.25 COL 20 WIDGET-ID 14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 1.5
         SIZE 84.43 BY 11
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
         WIDTH              = 90
         MAX-HEIGHT         = 17.88
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17.88
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
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
ASSIGN FRAME fpage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fpage1
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage1
/* Query rebuild information for FRAME fpage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage1 */
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
   RUN pi-frota-destroy-handle.

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
    RUN pi-frota-destroy-handle.

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

    RUN piValidaValoresFrota.
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.

    RUN piSetaValoresFrota.

    RUN pi-frota-destroy-handle.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wWindow
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
DO:

    RUN piValidaValoresFrota.
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.

    RUN piSetaValoresFrota.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage1
&Scoped-define SELF-NAME c-cc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cc-codigo wWindow
ON ENTRY OF c-cc-codigo IN FRAME fpage1
DO:
    ASSIGN c-cc-codigo:FORMAT IN FRAME fpage1 = "x(20)".  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cc-codigo wWindow
ON F5 OF c-cc-codigo IN FRAME fpage1
DO:
    RUN pi-zoomCentroCusto IN THIS-PROCEDURE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cc-codigo wWindow
ON LEAVE OF c-cc-codigo IN FRAME fpage1
DO:
    IF c-cc-codigo:SCREEN-VALUE <> "" THEN
        ASSIGN c-cc-codigo:FORMAT IN FRAME fpage1 = p_cod_format_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cc-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cc-codigo IN FRAME fpage1
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-ativid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-ativid wWindow
ON F5 OF c-cod-ativid IN FRAME fpage1 /* Atividade */
DO:
    {method/zoomfields.i 
       &ProgramZoom="frzoom/z01fr001.w"
       &FieldZoom1="cod-ativid"
       &FieldScreen1="c-cod-ativid"
       &Frame1="fpage1"
       &EnableImplant="YES"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-ativid wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cod-ativid IN FRAME fpage1 /* Atividade */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-compart
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-compart wWindow
ON F5 OF c-cod-compart IN FRAME fpage1 /* Compartimento */
DO:
    assign iEmpresa = input frame fpage1 i-ep-codigo
           cEqpto   = input frame fpage1 c-cod-eqpto.

        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr004.w"
           &FieldZoom1="cod-comptmento"
           &FieldScreen1="c-cod-compart"
           &Frame1="fpage1"
           &FieldZoom2="des-comptmento"
           &FieldScreen2="c-desc-compart"
           &Frame2="fpage1"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-compart wWindow
ON LEAVE OF c-cod-compart IN FRAME fpage1 /* Compartimento */
DO:
    {method/referencefields.i
        &HandleDBOLeave="hDBOComp"
        &KeyValue1="c-cod-compart:screen-value in frame fpage1"
        &FieldName1="des-comptmento"
        &FieldScreen1="c-desc-compart"
        &Frame1="fpage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-compart wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cod-compart IN FRAME fpage1 /* Compartimento */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-eqpto wWindow
ON F5 OF c-cod-eqpto IN FRAME fpage1
DO:
    {method/zoomfields.i 
       &ProgramZoom="frzoom/z01fr007.w"
       &FieldZoom1="ep-codigo"
       &FieldScreen1="i-ep-codigo"
       &Frame1="fpage1"
       &FieldZoom2="cod-eqpto"
       &FieldScreen2="c-cod-eqpto"
       &Frame2="fpage1"
       &EnableImplant="YES"}
    wait-for "CLOSE":U of hProgramZoom.
    apply "LEAVE":U to self.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-eqpto wWindow
ON LEAVE OF c-cod-eqpto IN FRAME fpage1
DO:

    run piBuscaEstabelEqpto IN THIS-PROCEDURE (OUTPUT cEstabEqpto).
    
    run buscaModelo in this-procedure.
    
    {method/referencefields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="cCodModelo"
        &FieldName1="des-model"
        &FieldScreen1="c-desc-eqpto"
        &Frame1="fpage1"
        &FieldName2="un"
        &FieldScreen2="c-un"
        &Frame2="fpage1"}

    IF  i-operacao = 1 THEN
        RUN piAtividade.

    APPLY "leave":U TO c-posto IN FRAME fpage1.
    
    RUN piValidaContadorSec IN THIS-PROCEDURE. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-eqpto wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cod-eqpto IN FRAME fpage1
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-evento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-evento wWindow
ON F5 OF c-cod-evento IN FRAME fpage1 /* Evento Frota */
DO:
  /** Verifica como deve trazer o zoom de eventos **/
  case input frame fpage1 rs-tipo:
      /** Lubrificaá∆o (‡leo / Filtro) **/
      when 2 then do:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr010.w"
           &FieldZoom1="cod-evento"
           &FieldScreen1="c-cod-evento"
           &Frame1="fpage1"
           &FieldZoom2="des-evento"
           &FieldScreen2="c-desc-evento"
           &Frame2="fpage1"
           &RunMethod="run setaFiltro in hProgramZoom (yes, yes, no, no , no, no)."
           &EnableImplant="YES"}         
      end.                               
      /** Diversos (Custos) **/          
      otherwise do:                      
        {method/zoomfields.i             
           &ProgramZoom="frzoom/z01fr010.w" 
           &FieldZoom1="cod-evento"      
           &FieldScreen1="c-cod-evento"  
           &Frame1="fpage1"         
           &FieldZoom2="des-evento"      
           &FieldScreen2="c-desc-evento" 
           &Frame2="fpage1"         
           &RunMethod="run setaFiltro in hProgramZoom (no, no, no, no , yes, no)."
           &EnableImplant="YES"}         
      end.         
  end case.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-evento wWindow
ON LEAVE OF c-cod-evento IN FRAME fpage1 /* Evento Frota */
DO:
    {method/referencefields.i
        &HandleDBOLeave="hDBOEvento"
        &KeyValue1="c-cod-evento:screen-value in frame fpage1"
        &FieldName1="des-evento"
        &FieldScreen1="c-desc-evento"
        &Frame1="fpage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-evento wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cod-evento IN FRAME fpage1 /* Evento Frota */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-matr wWindow
ON F5 OF c-cod-matr IN FRAME fpage1
DO:
    {method/zoomfields.i 
       &ProgramZoom="frzoom/z01fr017.w"
       &FieldZoom1="ep-codigo"
       &FieldScreen1="i-empresa-matr"
       &Frame1="fpage1"
       &FieldZoom2="cod-estabel"
       &FieldScreen2="c-estabel-matr"
       &Frame2="fpage1"
       &FieldZoom3="cod-matr"
       &FieldScreen3="c-cod-matr"
       &Frame3="fpage1"
       &EnableImplant="YES"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-matr wWindow
ON LEAVE OF c-cod-matr IN FRAME fpage1
DO:

    {method/referencefields.i
        &HandleDBOLeave="hDBOMoto"
        &KeyValue1="i-empresa-matr:screen-value in frame fpage1"
        &KeyValue2="c-estabel-matr:screen-value in frame fpage1"
        &KeyValue3="c-cod-matr:screen-value in frame fpage1"
        &FieldName1="nom-motoris"
        &FieldScreen1="c-nome-motorista"
        &Frame1="fpage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-matr wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cod-matr IN FRAME fpage1
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-rota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-rota wWindow
ON F5 OF c-cod-rota IN FRAME fpage1 /* Trajeto */
DO:
    {method/zoomfields.i 
       &ProgramZoom="frzoom/z01fr028.w"
       &FieldZoom1="cod-rota"
       &FieldScreen1="c-cod-rota"
       &Frame1="fpage1"
       &EnableImplant="YES"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-rota wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cod-rota IN FRAME fpage1 /* Trajeto */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-codigo wWindow
ON ENTRY OF c-ct-codigo IN FRAME fpage1 /* Conta Equipamento */
DO:
    ASSIGN c-ct-codigo:FORMAT IN FRAME fpage1 = "x(20)".  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-codigo wWindow
ON F5 OF c-ct-codigo IN FRAME fpage1 /* Conta Equipamento */
DO:
    RUN pi-zoomConta IN THIS-PROCEDURE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-codigo wWindow
ON LEAVE OF c-ct-codigo IN FRAME fpage1 /* Conta Equipamento */
DO:
    ASSIGN  cEmpresaEstab = INPUT FRAME fpage1 i-ep-codigo
            dDtMovimento  = INPUT FRAME fpage1 dat-movto.

    IF dDtMovimento = ? THEN ASSIGN dDtMovimento = TODAY.
    
    {cdp/cdunif001a.i  c-ct-codigo c-cc-codigo fpage1 dDtMovimento cEmpresaEstab cEstabEqpto}
  
    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF c-ct-codigo IN FRAME fpage1 /* Conta Equipamento */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-estabel-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estabel-matr wWindow
ON F5 OF c-estabel-matr IN FRAME fpage1
DO:
    {method/zoomfields.i 
       &ProgramZoom="frzoom/z01fr017.w"
       &FieldZoom1="ep-codigo"
       &FieldScreen1="i-empresa-matr"
       &Frame1="fpage1"
       &FieldZoom2="cod-estabel"
       &FieldScreen2="c-estabel-matr"
       &Frame2="fpage1"
       &FieldZoom3="cod-matr"
       &FieldScreen3="c-cod-matr"
       &Frame3="fpage1"
       &EnableImplant="YES"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estabel-matr wWindow
ON LEAVE OF c-estabel-matr IN FRAME fpage1
DO:
    {method/referencefields.i
        &HandleDBOLeave="hDBOMoto"
        &KeyValue1="i-empresa-matr:screen-value in frame fpage1"
        &KeyValue2="c-estabel-matr:screen-value in frame fpage1"
        &KeyValue3="c-cod-matr:screen-value in frame fpage1"
        &FieldName1="nom-motoris"
        &FieldScreen1="c-nome-motorista"
        &Frame1="fpage1"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estabel-matr wWindow
ON MOUSE-SELECT-DBLCLICK OF c-estabel-matr IN FRAME fpage1
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-hr-inicial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hr-inicial wWindow
ON LEAVE OF c-hr-inicial IN FRAME fpage1
DO:
    /** Consiste o hor†rio **/
    assign cHora = c-hr-inicial:screen-value in frame fpage1.
    run piFormataHorarioMin (input-output cHora).
    if return-value = "NOK":U then do:
        apply "ENTRY":U to c-hr-inicial in frame fpage1.
        return no-apply.
    end.
    assign c-hr-inicial:screen-value in frame fpage1 = cHora.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-posto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-posto wWindow
ON F5 OF c-posto IN FRAME fpage1 /* Posto */
DO:
    {method/zoomfields.i 
       &ProgramZoom="frzoom/z01fr021.w"
       &FieldZoom1="cod-posto"
       &FieldScreen1="c-posto"
       &Frame1="fpage1"
       &FieldZoom2="des-posto"
       &FieldScreen2="c-desc-posto"
       &Frame2="fpage1"
       &EnableImplant="YES"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-posto wWindow
ON LEAVE OF c-posto IN FRAME fpage1 /* Posto */
DO:
    {method/referencefields.i
        &HandleDBOLeave="hDBOPosto"
        &KeyValue1="c-posto:screen-value in frame fpage1"
        &FieldName1="des-posto"
        &FieldScreen1="c-desc-posto"
        &Frame1="fpage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-posto wWindow
ON MOUSE-SELECT-DBLCLICK OF c-posto IN FRAME fpage1 /* Posto */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-empresa-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-empresa-matr wWindow
ON F5 OF i-empresa-matr IN FRAME fpage1 /* Motorista */
DO:
    {method/zoomfields.i 
       &ProgramZoom="frzoom/z01fr017.w"
       &FieldZoom1="ep-codigo"
       &FieldScreen1="i-empresa-matr"
       &Frame1="fpage1"
       &FieldZoom2="cod-estabel"
       &FieldScreen2="c-estabel-matr"
       &Frame2="fpage1"
       &FieldZoom3="cod-matr"
       &FieldScreen3="c-cod-matr"
       &Frame3="fpage1"
       &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-empresa-matr wWindow
ON LEAVE OF i-empresa-matr IN FRAME fpage1 /* Motorista */
DO:
    {method/referencefields.i
        &HandleDBOLeave="hDBOMoto"
        &KeyValue1="i-empresa-matr:screen-value in frame fpage1"
        &KeyValue2="c-estabel-matr:screen-value in frame fpage1"
        &KeyValue3="c-cod-matr:screen-value in frame fpage1"
        &FieldName1="nom-motoris"
        &FieldScreen1="c-nome-motorista"
        &Frame1="fpage1"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-empresa-matr wWindow
ON MOUSE-SELECT-DBLCLICK OF i-empresa-matr IN FRAME fpage1 /* Motorista */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ep-codigo wWindow
ON F5 OF i-ep-codigo IN FRAME fpage1 /* Equipamento */
DO:
    apply "F5":U to c-cod-eqpto in frame fpage1.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ep-codigo wWindow
ON LEAVE OF i-ep-codigo IN FRAME fpage1 /* Equipamento */
DO:

    APPLY "leave":U TO c-posto IN FRAME fpage1.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dat-movto wWindow
ON LEAVE OF dat-movto IN FRAME fpage1 /* Data Movimento */
DO:

   IF  i-operacao = 1 /* Inclus∆o */ THEN DO:
        RUN piAtividade IN THIS-PROCEDURE.
        /* A Variavel "cEstabEqpto" Ç utilizada no leave das contas */
        RUN piBuscaEstabelEqpto IN THIS-PROCEDURE (OUTPUT cEstabEqpto).
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ep-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF i-ep-codigo IN FRAME fpage1 /* Equipamento */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo wWindow
ON VALUE-CHANGED OF rs-tipo IN FRAME fpage1
DO:
    /** Habilita/Desabilita campos conforme escolha **/
    case input frame fpage1 rs-tipo:
        /** Abastecimento **/
        when 1 then do:
            assign c-cod-evento:sensitive in frame fpage1    = no
                   c-cod-compart:sensitive in frame fpage1   = no
                   de-contador:sensitive in frame fpage1     = YES
                   c-posto:sensitive in frame fpage1         = yes
                   i-empresa-matr:sensitive in frame fPage1  = yes
                   c-estabel-matr:SENSITIVE IN frame fPage1  = yes
                   c-cod-matr:sensitive in frame fpage1      = yes
                   c-cod-rota:sensitive in frame fpage1      = yes
                   c-cod-ativid:sensitive in frame fpage1    = yes
                   c-ct-codigo:sensitive in frame fPage1     = yes
                   c-cc-codigo:sensitive in frame fPage1     = yes
                   i-ep-codigo:sensitive in frame fPage1     = yes
                   c-cod-eqpto:sensitive in frame fPage1     = yes
                   c-cod-evento  = "":U
                   c-cod-compart = "":U.

            if c-posto:screen-value = "":U then do:
                assign c-posto = fnPosto().
                display c-posto with frame fpage1.
                apply "LEAVE":U to c-posto in frame fpage1.
            end.
    
            display c-cod-evento c-cod-compart with frame fpage1.
    
            apply "LEAVE":U to c-cod-evento  in frame fpage1.
            apply "LEAVE":U to c-cod-compart in frame fpage1.
            
            RUN buscaModelo in this-procedure.

            /** Verifica se Atividade, Motorista e Trajeto s∆o Modificados em tela **/
            run piParametros in this-procedure.
            RUN piValidaContadorSec in this-procedure.
            run piIntegracaoEMS in this-procedure.
        end.
        /** Lubrificaá∆o **/
        when 2 then do:
            assign c-cod-evento:sensitive in frame fpage1    = yes
                   c-cod-compart:sensitive in frame fpage1   = yes
                   de-contador:sensitive in frame fpage1     = YES
                   c-cod-rota:sensitive in frame fpage1      = yes
                   c-cod-ativid:sensitive in frame fpage1    = yes
                   c-posto:sensitive in frame fpage1         = yes
                   c-cod-matr:sensitive in frame fpage1      = YES
                   i-empresa-matr:sensitive in frame fPage1  = yes
                   c-estabel-matr:SENSITIVE IN frame fPage1  = yes
                   c-ct-codigo:sensitive in frame fPage1     = yes
                   c-cc-codigo:sensitive in frame fPage1     = yes
                   i-ep-codigo:sensitive in frame fPage1     = yes
                   c-cod-eqpto:sensitive in frame fPage1     = yes.
    
            if c-posto:screen-value = "":U then do:
                assign c-posto = fnPosto().
                display c-posto with frame fpage1.
                apply "LEAVE":U to c-posto in frame fpage1.
            end.
    
            IF i-operacao = 2 THEN
                ASSIGN c-cod-compart:sensitive in frame fpage1 = yes.

            RUN buscaModelo in this-procedure.

            /** Verifica se Atividade, Motorista e Trajeto s∆o Modificados em tela **/
            run piParametros in this-procedure.
            RUN piValidaContadorSec IN THIS-PROCEDURE. 
            run piIntegracaoEMS in this-procedure.
        end.
        /** Outros **/
        when 3 then do:
            assign c-cod-evento:sensitive in frame fpage1    = yes
                   c-cod-compart:sensitive in frame fpage1   = no
                   de-contador:sensitive in frame fpage1     = no
                   de-contador-sec:sensitive in frame fpage1 = no
                   c-posto:sensitive in frame fpage1         = no
                   i-empresa-matr:sensitive in frame fPage1  = no
                   c-estabel-matr:SENSITIVE IN frame fPage1  = no
                   c-cod-matr:sensitive in frame fpage1      = no
                   c-cod-rota:sensitive in frame fpage1      = no
                   c-cod-ativid:sensitive in frame fpage1    = no
                   c-ct-codigo:sensitive in frame fPage1     = no
                   c-cc-codigo:sensitive in frame fPage1     = no
                   i-ep-codigo:sensitive in frame fPage1     = yes
                   c-cod-eqpto:sensitive in frame fPage1     = yes.

            ASSIGN c-cod-compart    = "":U
                   de-contador      = 0
                   de-contador-sec  = 0
                   c-posto          = "":U
                   i-empresa-matr   = ""
                   c-estabel-matr   = ""
                   c-cod-matr       = "":U
                   c-cod-rota       = "":U
                   c-cod-ativid     = "":U
                   c-nome-motorista = ""
                   c-desc-compart   = ""
                   c-desc-posto     = ""
                   c-ct-codigo      = ""
                   c-cc-codigo      = "". 
    
            display c-cod-compart de-contador de-contador-sec
                    c-posto i-empresa-matr c-estabel-matr c-cod-matr 
                    c-cod-rota c-cod-ativid c-nome-motorista 
                    c-ct-codigo c-cc-codigo c-desc-compart c-desc-posto
                    with frame fpage1.
            
            RUN piValidaContadorSec IN THIS-PROCEDURE. 
        end.
    end case.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN c-hr-inicial = "0000".
    
    assign rs-tipo      = 1
           c-posto      = fnPosto()
           dat-movto    = TODAY
           c-hr-inicial = replace(string(time,"hh:mm":U),":":U,"":U).

    assign c-desc-eqpto:screen-value     in frame fpage1 = "":U
           c-nome-motorista:screen-value in frame fpage1 = "":U
           c-desc-evento:screen-value    in frame fpage1 = "":U
           c-desc-compart:screen-value   in frame fpage1 = "":U.
        
    i-ep-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fpage1.
    c-cod-eqpto:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fpage1.
    c-posto:LOAD-MOUSE-POINTER("image/lupa.cur":U)       IN FRAME fpage1.
    c-ct-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fpage1.
    c-cc-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fpage1.
    c-cod-matr:LOAD-MOUSE-POINTER("image/lupa.cur":U)    IN FRAME fpage1.
    c-cod-evento:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fpage1.
    c-cod-compart:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage1.
    c-cod-rota:LOAD-MOUSE-POINTER("image/lupa.cur":U)    IN FRAME fpage1.
    c-cod-ativid:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fpage1.
    i-empresa-matr:LOAD-MOUSE-POINT("image/lupa.cur":U)  IN FRAME fpage1.
    c-estabel-matr:LOAD-MOUSE-POINT("image/lupa.cur":U)  IN FRAME fpage1.
    
    assign v_cod_finalid = {adinc/i05ad049.i 4 1 }                       /* 1 - Consumo        */
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 3}  /* 3 - Ordem Serviáo  */
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 5}. /* 5 - M∆o de Obra    */
        
    /** Busca os formatos da conta e sub-conta **/
    EMPTY TEMP-TABLE tt_log_erro.    
    
    IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.  
    IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
    
    ASSIGN  cEmpresaEstab = i-ep-codigo-usuario
            dDtMovimento  = TODAY.
    
    IF dDtMovimento = ? THEN ASSIGN dDtMovimento = TODAY.
    
    RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT cEmpresaEstab,        /* EMPRESA EMS2 */
                                                   INPUT "",                   /* PLANO CCUSTO */
                                                   INPUT dDtMovimento,         /* DATA DE TRANSACAO */
                                                   OUTPUT p_cod_format_ccusto, /* FORMATO CCUSTO */
                                                   OUTPUT TABLE tt_log_erro).  /* ERROS */
    
    RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT cEmpresaEstab,
                                                       INPUT "",
                                                       INPUT dDtMovimento,
                                                       OUTPUT p_cod_format_cta_ctbl,
                                                       OUTPUT TABLE tt_log_erro).
    
    IF VALID-HANDLE(h_api_ccusto) THEN DELETE OBJECT h_api_ccusto.
    IF VALID-HANDLE(h_api_ccusto) THEN DELETE OBJECT h_api_ccusto.
    
    {cdp/cdunif001b.i}
    
    /** Inicializa Handles necess†rios **/
    run pi-frota-inicializa-handle in this-procedure.
    
    RUN abp/abapi016.p PERSISTENT SET hApiFrota.

    IF  NOT CAN-FIND(FIRST tt-mab-item-abastec-lubrific) THEN DO:
        RUN pi-dadosItemDocEst IN hApiFrota (INPUT p-cod-emitente,
                                             INPUT p-nro-docto,
                                             INPUT p-serie-docto,
                                             INPUT p-nat-operacao,
                                             INPUT p-sequencia).

        RUN pi-getTTdadosAbastLubrif IN hApiFrota (OUTPUT TABLE tt-mab-item-abastec-lubrific).
    END.

    FOR FIRST tt-mab-item-abastec-lubrific no-lock:
    
        ASSIGN rs-tipo         = tt-mab-item-abastec-lubrific.i-tipo
               dat-movto       = tt-mab-item-abastec-lubrific.dt-movimento
               c-hr-inicial    = tt-mab-item-abastec-lubrific.hr-inicial
               i-ep-codigo     = tt-mab-item-abastec-lubrific.ep-codigo
               c-cod-eqpto     = tt-mab-item-abastec-lubrific.cod-eqpto
               de-contador     = tt-mab-item-abastec-lubrific.contador
               de-contador-sec = tt-mab-item-abastec-lubrific.contador-sec
               c-posto         = tt-mab-item-abastec-lubrific.posto
               i-empresa-matr  = tt-mab-item-abastec-lubrific.empresa-matr
               c-estabel-matr  = tt-mab-item-abastec-lubrific.estabel-matr
               c-cod-matr      = tt-mab-item-abastec-lubrific.cod-matr
               c-cod-rota      = tt-mab-item-abastec-lubrific.cod-rota
               c-cod-ativid    = tt-mab-item-abastec-lubrific.cod-ativid
               c-ct-codigo     = tt-mab-item-abastec-lubrific.cod-cta-ctbl
               c-cc-codigo     = tt-mab-item-abastec-lubrific.cod-ccusto
               c-cod-evento    = tt-mab-item-abastec-lubrific.cod-evento
               c-cod-compart   = tt-mab-item-abastec-lubrific.cod-compart.

        IF c-hr-inicial = "" THEN
            ASSIGN c-hr-inicial = replace(string(TIME,"HH:MM"),":":U,"":U).
    END.
    
    if can-find(first mab-abastec-lubrific no-lock
                where mab-abastec-lubrific.serie        = p-serie-docto 
                and   mab-abastec-lubrific.nr-nota-fis  = p-nro-docto   
                and   mab-abastec-lubrific.cod-emitente = p-cod-emitente
                and   mab-abastec-lubrific.nat-operacao = p-nat-operacao
                and   mab-abastec-lubrific.sequencia    = p-sequencia)
    OR can-find(first mmv-movto-mater no-lock
                where mmv-movto-mater.serie-docto  = p-serie-docto 
                and   mmv-movto-mater.nro-docto    = p-nro-docto   
                and   mmv-movto-mater.cod-emitente = p-cod-emitente
                and   mmv-movto-mater.nat-operacao = p-nat-operacao
                and   mmv-movto-mater.sequencia    = p-sequencia) THEN
        ASSIGN i-operacao = 2. /* Alteraá∆o */
    ELSE
        ASSIGN i-operacao = 1. /* Inclus∆o */

    DISP rs-tipo dat-movto c-hr-inicial i-ep-codigo c-cod-eqpto de-contador    
         de-contador-sec c-posto i-empresa-matr c-estabel-matr c-cod-matr
         c-cod-rota c-cod-ativid c-ct-codigo c-cc-codigo c-cod-evento c-cod-compart
         WITH FRAME fPage1.

    apply "LEAVE":U to c-cod-eqpto     in frame fpage1.
    apply "LEAVE":U to c-posto         in frame fpage1.
    apply "LEAVE":U to c-cod-matr      in frame fpage1.
    apply "LEAVE":U to c-cod-evento    in frame fpage1.
    apply "LEAVE":U to c-cod-compart   in frame fpage1.
    apply "LEAVE":U to c-ct-codigo     in frame fpage1.         
    
    apply "VALUE-CHANGED":U to rs-tipo in frame fPage1.

    IF  i-operacao = 2 THEN DO:
        ASSIGN rs-tipo:SENSITIVE IN FRAME fPage1 = NO.
        apply "entry":U TO dat-movto in frame fpage1.
    END.
    ELSE
        apply "entry":U to rs-tipo in frame fpage1.

    DELETE OBJECT hApiFrota.    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-frota-inicializa-handle wWindow 
PROCEDURE pi-frota-inicializa-handle :
/*------------------------------------------------------------------------------
  Purpose:     pi-frota-inicializa-handle
  Parameters:  <none>
  Notes:       Inicializa os handles utilizados pelo folder frotas
------------------------------------------------------------------------------*/
    /*--- DBO Equipamento ---*/
    IF NOT VALID-HANDLE(hDBOEqpto) OR
       hDBOEqpto:TYPE <> "PROCEDURE":U OR
       hDBOEqpto:FILE-NAME <> "frbo/bofr007.p":U THEN DO:
        run frbo/bofr007.p persistent set  hDBOEqpto.
    END.
    
    RUN openQueryStatic IN hDBOEqpto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo/bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

    /*--- DBO Posto  ---*/
    IF NOT VALID-HANDLE(hDBOPosto) OR
       hDBOPosto:TYPE <> "PROCEDURE":U OR
       hDBOPosto:FILE-NAME <> "frbo/bofr021.p":U THEN DO:
        run frbo/bofr021.p persistent set  hDBOPosto.
    END.
    
    RUN openQueryStatic IN hDBOPosto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Motorista  ---*/
    IF NOT VALID-HANDLE(hDBOMoto) OR
       hDBOMoto:TYPE <> "PROCEDURE":U OR
       hDBOMoto:FILE-NAME <> "frbo/bofr017.p":U THEN DO:
        run frbo/bofr017.p persistent set  hDBOMoto.
    END.
    
    RUN openQueryStatic IN hDBOMoto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Evento ---*/
    IF NOT VALID-HANDLE(hDBOEvento) OR
       hDBOEvento:TYPE <> "PROCEDURE":U OR
       hDBOEvento:FILE-NAME <> "frbo/bofr010.p":U THEN DO:
        run frbo/bofr010.p persistent set  hDBOEvento.
    END.
    
    RUN openQueryStatic IN hDBOEvento (INPUT "Main":U) NO-ERROR.

    /*--- DBO Compartimento ---*/
    IF NOT VALID-HANDLE(hDBOComp) OR
       hDBOComp:TYPE <> "PROCEDURE":U OR
       hDBOComp:FILE-NAME <> "frbo/bofr003.p":U THEN DO:
        run frbo/bofr003.p persistent set  hDBOComp.
    END.
    
    RUN openQueryStatic IN hDBOComp (INPUT "Main":U) NO-ERROR.

    /*:T--- BO de Ficha Abatestecimento / Lubificaá∆o ---*/
    IF NOT VALID-HANDLE(hDBOFicha) OR
       hDBOFicha:TYPE <> "PROCEDURE":U OR
       hDBOFicha:FILE-NAME <> "frbo/bofr055.p":U THEN DO:
        run frbo/bofr055.p persistent set hDBOFicha.
    END.
    
    RUN openQueryStatic IN hDBOFicha (INPUT "Main":U) NO-ERROR.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-frota-destroy-handle wWindow 
PROCEDURE pi-frota-destroy-handle :
/*------------------------------------------------------------------------------
  Purpose:     pi-frota-destroy-handle
  Parameters:  <none>
  Notes:       Elimina handles da memΩria
------------------------------------------------------------------------------*/
    /** Equipamento **/
    if valid-handle(hDBOEqpto) then
        run Destroy in hDBOEqpto.
    /** Modelo **/
    if valid-handle(hDBOModelo) then
        run Destroy in hDBOModelo.
    /** Posto **/
    if valid-handle(hDBOPosto) then
        run Destroy in hDBOPosto.
    /** Motorista **/
    if valid-handle(hDBOMoto) then
        run Destroy in hDBOMoto.
    /** Evento **/
    if valid-handle(hDBOEvento) then
        run Destroy in hDBOEvento.
    /** Compartimento **/
    if valid-handle(hDBOComp) then
        run Destroy in hDBOComp.
    /** Ficha **/
    if valid-handle(hDBOFicha) then
        run Destroy in hDBOFicha.

    {method/showmessage.i3}

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoomCentroCusto wWindow 
PROCEDURE pi-zoomCentroCusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    ASSIGN  cEmpresaEstab = INPUT FRAME fpage1 i-ep-codigo
            dDtMovimento  = INPUT FRAME fpage1 dat-movto.

    IF dDtMovimento = ? THEN ASSIGN dDtMovimento = TODAY.

    RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto( INPUT cEmpresaEstab,         /*Empresa*/
                                                   INPUT "",                    /*Estabelecimento */
                                                   INPUT YES,                   /*Considera Todos os Estabelecimentos ?*/
                                                   INPUT "",                    /*Unidade de Neg¢cio*/
                                                   INPUT "",                    /*Plano de Contas*/
                                                   INPUT v_cod_cta_ctbl,        /*C¢digo da Conta*/
                                                   INPUT "",                    /*C¢digo do Plano de Centro de Custo*/
                                                   INPUT dDtMovimento,          /*Data da Transaá∆o*/
                                                   OUTPUT v_cod_ccusto,         /*C¢digo CCusto*/
                                                   OUTPUT v_des_ccusto,         /*Descriá∆o CCusto*/
                                                   OUTPUT TABLE tt_log_erro ).  /*Erros*/

    ASSIGN c-cc-codigo:SCREEN-VALUE IN FRAME fpage1 = v_cod_ccusto.

    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.

    IF VALID-HANDLE(h_api_ccusto) THEN DO:
        DELETE OBJECT h_api_ccusto.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoomConta wWindow 
PROCEDURE pi-zoomConta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h_api_cta_ctbl) OR
        h_api_cta_ctbl:TYPE      <> "PROCEDURE":U OR
        h_api_cta_ctbl:FILE-NAME <> "prgint/utb/utb743za.py":U THEN DO:
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.    
    END.
    
    ASSIGN  cEmpresaEstab = INPUT FRAME fpage1 i-ep-codigo
            dDtMovimento  = INPUT FRAME fpage1 dat-movto.

    IF dDtMovimento = ? THEN ASSIGN dDtMovimento = TODAY.

    RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  cEmpresaEstab,       /* EMPRESA PADR«O DO USUµRIO*/
                                                   INPUT  "CEP",               /* MODULO */                                                  
                                                   INPUT  "",                  /* PLANO DE CONTAS */
                                                   INPUT  v_cod_finalid,       /* FINALIDADES */
                                                   INPUT  dDtMovimento,        /* DATA TRANSACAO */
                                                   OUTPUT v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                   OUTPUT v_des_cta_ctbl,      /* DESCRICAO CONTA */
                                                   OUTPUT v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).  /* ERROS */
    
    IF v_cod_cta_ctbl <> "" THEN
		ASSIGN c-ct-codigo:SCREEN-VALUE IN FRAME fpage1 = v_cod_cta_ctbl.
    
    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.

    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        DELETE OBJECT h_api_cta_ctbl.
    END.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaModelo wWindow 
PROCEDURE buscaModelo :
/*------------------------------------------------------------------------------
  Purpose:     buscaModelo
  Parameters:  <none>
  Notes:       Busca o c¢digo do modelo no equipamento
------------------------------------------------------------------------------*/
    
    {method/referencefields.i
        &HandleDBOLeave="hDBOEqpto"
        &KeyValue1="input frame fpage1 i-ep-codigo"
        &KeyValue2="input frame fpage1 c-cod-eqpto"
        &FieldName1="cod-model"
        &Variable1="cCodModelo"}
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtividade wWindow 
PROCEDURE piAtividade:
/*------------------------------------------------------------------------------
  Purpose:     piAtividade
  Parameters:  <none>
  Notes:       Busca Atividade e Conta Corrente do historico Atividade do Eqpto
------------------------------------------------------------------------------*/
    define variable c-conta      as character no-undo.
    define variable c-sub        as character no-undo.
    define variable c-ativid     as character no-undo.
    define variable c-unid       as character no-undo.
    DEFINE VARIABLE c-conta-lub  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-ccusto-lub AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-hist-estab AS CHARACTER NO-UNDO.

    /** Busca Atividade e Conta Cont†bil do Hist¢rico Atividade Equipamento **/    
    run buscaAtividade in hDBOFicha (input  input frame fpage1 i-ep-codigo,
                                     input  input frame fpage1 c-cod-eqpto,
                                     input  input frame fpage1 dat-movto,
                                     output c-cod-ativid,
                                     output c-ct-codigo,
                                     output c-cc-codigo,
                                     output c-unid,
                                     OUTPUT c-conta-lub,
                                     OUTPUT c-ccusto-lub,
                                     OUTPUT c-hist-estab).
    
    FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
        IF mab-param.des-valor = "1":U THEN DO:
            IF INPUT FRAME fpage1 rs-tipo = "2" THEN DO:
                ASSIGN c-ct-codigo = c-conta-lub
                       c-cc-codigo = c-ccusto-lub.
            END.
        END.
    END.

    display c-ct-codigo c-cc-codigo c-cod-ativid
            with frame fpage1.
    
    apply "LEAVE":U to c-ct-codigo in frame fpage1.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaEstabelEqpto wWindow 
PROCEDURE piBuscaEstabelEqpto:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM cCodEstabelEqpto LIKE mab-histor-ativid.cod-estabel NO-UNDO.

    ASSIGN cEstabEqpto = "".
    FOR LAST mab-histor-ativid
       WHERE mab-histor-ativid.ep-codigo     = i-ep-codigo:SCREEN-VALUE IN FRAME fPage1
         AND mab-histor-ativid.cod-eqpto     = c-cod-eqpto:SCREEN-VALUE IN FRAME fPage1
         AND mab-histor-ativid.dat-cadastro <= date(dat-movto:SCREEN-VALUE IN FRAME fPage1) NO-LOCK:
         ASSIGN cCodEstabelEqpto = mab-histor-ativid.cod-estabel.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piParametros wWindow 
PROCEDURE piParametros :
/*------------------------------------------------------------------------------
  Purpose:     piParametros
  Parameters:  <none>
  Notes:       Busca ParÉmetros e habilita/desabilita campos em tela
------------------------------------------------------------------------------*/
    for each  mab-param fields(des-valor cdn-param)
        WHERE (mab-param.cdn-param >= 7 
        and    mab-param.cdn-param <= 9) 
        or     mab-param.cdn-param = 52 no-lock:
        case mab-param.cdn-param:
            /** Motorista **/
            when 7 then
                assign i-empresa-matr:sensitive in frame fpage1 = if mab-param.des-valor = "1":U then yes
                                                                   else no
                       c-estabel-matr:sensitive in frame fpage1 = if mab-param.des-valor = "1":U then yes
                                                                   else no
                       c-cod-matr:sensitive in frame fpage1 = if mab-param.des-valor = "1":U then yes
                                                                   else no.
            /** Atividade **/
            when 8 then
                assign c-cod-ativid:sensitive in frame fpage1 = if mab-param.des-valor = "1":U
                                                                     then no
                                                                     else yes.
            /** Trajeto **/
            when 9 then
                assign c-cod-rota:sensitive in frame fpage1 = if mab-param.des-valor = "1":U
                                                                   then yes
                                                                   else no.
            when 52 then
                if input frame fpage1 rs-tipo = 1 /* Abastecimento */
                AND mab-param.des-valor = "1":U then
                    assign i-empresa-matr:sensitive in frame fpage1 = no
                           c-estabel-matr:sensitive in frame fpage1 = no.                                                                   
        end case.
    end.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaContadorSec wWindow 
PROCEDURE piValidaContadorSec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN lLogContSec = NO.
    IF  cCodModelo <> "" THEN DO:
        RUN gotokey IN hDBOEqpto (INPUT FRAME fpage1 i-ep-codigo,
                                  INPUT FRAME fpage1 c-cod-eqpto).
        IF  RETURN-VALUE = "OK":U THEN DO:
            RUN getLogField   IN hDBOEqpto (INPUT "log-cont-sec":U,
                                            OUTPUT lLogContSec).
        END.
        IF  lLogContSec THEN DO:
            RUN gotokey IN hDBOModelo (INPUT cCodModelo).
            IF  RETURN-VALUE = "OK":U THEN DO:
                RUN getCharField  IN hDBOModelo (INPUT "cod-livre-1":U,
                                                 OUTPUT cUnModelSec).
                ASSIGN cUnModelSec = SUBSTRING(cUnModelSec, 1, 2).
            END.
        END.
    END.
    
    IF  lLogContSec THEN
        ASSIGN de-contador-sec:SENSITIVE IN FRAME fpage1 = YES
               c-un-sec:SCREEN-VALUE     IN FRAME fpage1 = cUnModelSec.
    ELSE
        ASSIGN de-contador-sec:SCREEN-VALUE IN FRAME fpage1 = "0,0"
               c-un-sec:SCREEN-VALUE        IN FRAME fpage1 = ""
               de-contador-sec:SENSITIVE    IN FRAME fpage1 = NO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaValoresFrota wWindow 
PROCEDURE piValidaValoresFrota:

    EMPTY TEMP-TABLE RowErrors.

    ASSIGN input frame fPage1 rs-tipo        
           input frame fPage1 dat-movto      
           input frame fPage1 c-hr-inicial   
           input frame fPage1 i-ep-codigo    
           input frame fPage1 c-cod-eqpto    
           input frame fPage1 de-contador    
           input frame fPage1 de-contador-sec
           input frame fPage1 c-posto        
           input frame fPage1 i-empresa-matr 
           input frame fPage1 c-estabel-matr 
           input frame fPage1 c-cod-matr     
           input frame fPage1 c-cod-rota     
           input frame fPage1 c-cod-ativid   
           input frame fPage1 c-ct-codigo    
           input frame fPage1 c-cc-codigo    
           input frame fPage1 c-cod-evento
           input frame fPage1 c-cod-compart.  

    CASE rs-tipo:
        WHEN 1 THEN DO: /* Abastecimento */
            RUN pi-validar-ficha.
            RUN pi-validar-abastec.
        END.                                    
        WHEN 2 THEN DO: /* Lubrificaá∆o */
            RUN pi-validar-ficha.
            RUN pi-validar-lubrif.
        END.
        WHEN 3 THEN DO: /* Outros */
            RUN pi-validar-outros.
        END.
        OTHERWISE  
            RETURN.
    END CASE.

    IF  CAN-FIND(FIRST RowErrors) THEN DO:
        FIND FIRST RowErrors NO-LOCK no-error.
        RUN utp/ut-msgs.p (input "SHOW":U,
                           input RowErrors.ErrorNumber,
                           input RowErrors.ErrorParameters).
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaValoresFrota wWindow 
PROCEDURE piSetaValoresFrota :

    /** Item deve ser debito direto e equipamento deve estar informado **/
    if can-find(first bf-item-frota  NO-LOCK
                where bf-item-frota.it-codigo  = p-it-codigo
                and   bf-item-frota.tipo-contr = 4) 
    and input frame fPage1 i-ep-codigo  > "" 
    and input frame fPage1 c-cod-eqpto <> "":U then do:

        FIND FIRST tt-mab-item-abastec-lubrific EXCLUSIVE-LOCK NO-ERROR.
        IF  NOT AVAIL tt-mab-item-abastec-lubrific THEN 
            CREATE tt-mab-item-abastec-lubrific.

        ASSIGN tt-mab-item-abastec-lubrific.i-tipo        = rs-tipo        
               tt-mab-item-abastec-lubrific.dt-movimento  = dat-movto      
               tt-mab-item-abastec-lubrific.hr-inicial    = c-hr-inicial   
               tt-mab-item-abastec-lubrific.ep-codigo     = i-ep-codigo    
               tt-mab-item-abastec-lubrific.cod-eqpto     = c-cod-eqpto    
               tt-mab-item-abastec-lubrific.contador      = de-contador    
               tt-mab-item-abastec-lubrific.contador-sec  = de-contador-sec
               tt-mab-item-abastec-lubrific.posto         = c-posto        
               tt-mab-item-abastec-lubrific.empresa-matr  = i-empresa-matr 
               tt-mab-item-abastec-lubrific.estabel-matr  = c-estabel-matr 
               tt-mab-item-abastec-lubrific.cod-matr      = c-cod-matr     
               tt-mab-item-abastec-lubrific.cod-rota      = c-cod-rota     
               tt-mab-item-abastec-lubrific.cod-ativid    = c-cod-ativid   
               tt-mab-item-abastec-lubrific.cod-cta-ctbl  = c-ct-codigo    
               tt-mab-item-abastec-lubrific.cod-ccusto    = c-cc-codigo    
               tt-mab-item-abastec-lubrific.cod-evento    = c-cod-evento
               tt-mab-item-abastec-lubrific.cod-compart   = c-cod-compart.
    end.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validar-ficha wWindow 
PROCEDURE pi-validar-ficha:    
    DEFINE VARIABLE cTexto AS CHARACTER  NO-UNDO.
    
    run piValidaParametroAbastecimento (input "7,9":U).
    if return-value = "NOK":U then
        return "NOK":U.

    /** Empresa em branco **/
    {utp/ut-liter.i "Empresa"}
    if i-ep-codigo = "" then do:
        run piCriaErro (3145, 'EMS':U, return-value).
    end.
    else do:
        /** Empresa nao cadastrada **/
        FOR FIRST empresa
            WHERE empresa.ep-codigo = i-ep-codigo NO-LOCK:
        END.
        IF NOT AVAIL empresa THEN DO:
            run piCriaErro (56, 'EMS':U, return-value).
        END.
    END.
    /** Codigo Equipamento em branco **/
    {utp/ut-liter.i "Equipamento"}
    ASSIGN c-aux = RETURN-VALUE.
    if c-cod-eqpto = "" then do:
        run piCriaErro (3145, 'EMS':U, c-aux).
    end.
    else do:
        for first mab-eqpto
            where mab-eqpto.ep-codigo = i-ep-codigo
            and   mab-eqpto.cod-eqpto = c-cod-eqpto no-lock:
            ASSIGN lEqptoComAcesso = YES.
        end.
        /** Equipamento nao cadastrado **/
        if  not avail mab-eqpto then do:
            {utp/ut-liter.i "Equipamento"}
            run piCriaErro (56, 'EMS':U, RETURN-VALUE).
        end.
    end.
    /** Data movimento nao informada **/
    if  dat-movto = ? then do:
        run piCriaErro (1090, 'EMS':U, "").
    end.
    else do:
        /** Data movimento nao pode ser maior que today **/
        If  dat-movto > TODAY then do:
            {utp/ut-liter.i "Data Apontamento nao pode ser maior que a data atual"}
            run piCriaErro (3141, 'EMS':U, RETURN-VALUE).
        End.

        IF  lEqptoComAcesso THEN DO:
            for first mab-eqpto fields(dat-situacao dat-inicial)
                where mab-eqpto.ep-codigo = i-ep-codigo
                and   mab-eqpto.cod-eqpto = c-cod-eqpto no-lock:

                /** Movimento maior que desativacao equipamento **/
                {utp/ut-liter.i "Movimento"}
                assign cTexto = return-value.
                IF  mab-eqpto.dat-situacao <> ? then do:

                    if dat-movto > mab-eqpto.dat-situacao then do:
                        {utp/ut-liter.i "Desativaá∆o_Equipamento"}
                        run piCriaErro (28448, 'EMS':U, cTexto + "~~" + string(dat-movto, "99/99/9999") + "~~" +
                                                        RETURN-VALUE + "~~" + string(mab-eqpto.dat-situacao,'99/99/9999')).
                    end.
                end.
                /** Movimento nao pode ser menor que controle equipamento **/
                if  dat-movto < mab-eqpto.dat-inicial then do:
                     {utp/ut-liter.i "Controle_Equipamento"}
                     run piCriaErro (28411, 'EMS':U, cTexto + "~~" + string(dat-movto, "99/99/9999") + "~~" +
                                                     RETURN-VALUE + "~~" + string(mab-eqpto.dat-inicial,'99/99/9999')).
                end.
            end.
        END.
    end.

    /** Hora de apontamento Inicial nao informada **/
    {utp/ut-liter.i "Inicial"}
    if  c-hr-inicial = "" then do:
        run piCriaErro (28447, 'EMS':U, RETURN-VALUE).
    end.
    else do:
        assign c-hr-inicial = trim(substr(c-hr-inicial,1,2) + substr(c-hr-inicial,3,2) + "00") no-error.
        /** Hora apontamento inicial fora dos horˇrios corretos **/
        if  int(substr(c-hr-inicial,3,2)) > 59 or
            int(substr(c-hr-inicial,1,2)) > 23 or 
            int(substr(c-hr-inicial,5,2)) > 59 then do:
            run piCriaErro (28446, 'EMS':U, RETURN-VALUE).
        end.
    end.

    /** Validacoes dos atributos restantes **/
    run validateApontamento in this-procedure.

    /*--- Verifica ocorrencia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaParametroAbastecimento wWindow 
procedure piValidaParametroAbastecimento:
    define input parameter pLista as character no-undo.
    
    define variable iCont as integer no-undo.
    
    {utp/ut-liter.i "Abastecimento"}
    do iCont = 1 to num-entries(pLista):
        if not can-find(first mab-param 
                        where mab-param.cdn-param = integer(entry(iCont,pLista)) no-lock) then do:
            /** Codigo deve estar cadastrado ou nao existe **/
            run piCriaErro (28474, 'EMS':U, RETURN-VALUE + "~~" + entry(iCont,pLista)).
        end.
        else do:
            /** Busca Parametros de Abastecimento **/
            for first mab-param fields(des-valor des-param cdn-param)
                where mab-param.cdn-param = integer(entry(iCont,pLista)) no-lock:
                /** Codigo deve estar cadastrado **/
                if mab-param.des-valor = "" then do:
                    run piCriaErro (28474, 'EMS':U, RETURN-VALUE + "~~" + string(mab-param.cdn-param) + "~~" + des-param).
                end.
            end.
        end.
    end.

    /*:T--- Verifica ocorrºncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateApontamento wWindow 
PROCEDURE validateApontamento :
/*------------------------------------------------------------------------------
  Purpose:     validateApontamento
  Parameters:  <none>
  Notes:       Validaá‰es de alteraá∆o/inclus∆o nos apontamentos
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cTexto      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cEstabelec  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-ep-codigo AS CHARACTER   NO-UNDO.
    
    /** Motorista **/
    for first mab-param
        where mab-param.cdn-param = 7 no-lock:
        if  mab-param.des-valor = "1" then do:
            /** Motorista n∆o cadastrado **/
            FOR first mab-motoris
                where mab-motoris.ep-codigo   = i-empresa-matr
                  AND mab-motoris.cod-estabel = c-estabel-matr
                  AND mab-motoris.cod-matr    = c-cod-matr no-lock:
            END.
            IF  NOT AVAIL mab-motoris THEN DO:
                {utp/ut-liter.i "Motorista"}
                run piCriaErro (56, 'EMS':U, return-value).
            end.
        end.
    end.
    
    /** Posto em branco **/
    {utp/ut-liter.i "Posto"}
    if c-posto = "" then do:
        run piCriaErro (3145, 'EMS':U, return-value).
    end.
    ELSE DO:
        FOR FIRST mab-posto
            WHERE mab-posto.cod-posto = c-posto NO-LOCK:
        END.
        IF  NOT AVAIL mab-posto THEN DO:
            {utp/ut-liter.i "Posto"}
            run piCriaErro (56, 'EMS':U, return-value).
        END.
    END.

    /** Atividade em branco **/
    IF CAN-FIND (mab-layout-import
          WHERE mab-layout-import.nom-campo = "cod-ativid":U
            AND mab-layout-import.num-tam-campo <> 0 NO-LOCK) THEN DO:
            {utp/ut-liter.i "Atividade"}
            FOR FIRST mab-layout-import:
                IF mab-layout-import.num-tam-campo <> 0 THEN DO:
                    if c-cod-ativid = "" then do:
                        run piCriaErro (3145, 'EMS':U, return-value).
                    END.
                    else do:
                        /** Atividade deve estar cadastrada **/
                        if not can-find(first mab-ativid
                                        where mab-ativid.cod-ativid = c-cod-ativid no-lock) then do:
                            run piCriaErro (56, 'EMS':U, return-value).
                        end.
                    end.
                END.
            END.
    END.
    for first mab-param fields(des-valor)
        where mab-param.cdn-param = 9 no-lock:
        {utp/ut-liter.i "Trajeto"}
        if mab-param.des-valor = "1" then do:
            /** Trajeto em branco **/
            IF  CAN-FIND (mab-layout-import
                          WHERE mab-layout-import.nom-campo = "cod-rota":U
                          AND mab-layout-import.num-tam-campo <> 0 NO-LOCK) THEN DO:
                if  c-cod-rota = "" then do:
                    run piCriaErro (3145, 'EMS':U, return-value).
                end.
                else do:
                    /** Trajeto deve estar cadastrado **/
                    if not can-find(first mab-trajeto
                                    where mab-trajeto.cod-rota = c-cod-rota no-lock) then do:
                        run piCriaErro (56, 'EMS':U, return-value).
                    END.
                end.
            end.
        end.
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validar-abastec wWindow 
PROCEDURE pi-validar-abastec:
    DEFINE VARIABLE cTexto             AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cEqpto             AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cEstabelec         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE deTanque           AS DECIMAL NO-UNDO.
    DEFINE VARIABLE v-cod-tip-mater    LIKE mab-tip-mater-item.cod-tip-mater NO-UNDO.
    DEFINE VARIABLE v-log-abastec-prim AS LOGICAL NO-UNDO.

    /* Guarda Equipamento */
    ASSIGN cEqpto = STRING(i-ep-codigo) + "-" + c-cod-eqpto.

    /** Validaá‰es de Criaá∆o **/
    if i-operacao = 1 then do:

        IF NOT VALID-HANDLE(h-abastec) THEN
            run frbo/bofr057.p persistent set h-abastec.
        
        RUN openQueryStatic IN h-abastec (INPUT "Main":U) NO-ERROR.

        /** Busca Tipo Material e Flag de Abastecimento Primˇrio **/
        run buscaTipoMaterial in h-abastec (input i-ep-codigo,
                                            input c-cod-eqpto,
                                            input p-it-codigo,
                                            input dat-movto,
                                            output v-cod-tip-mater,
                                            output v-log-abastec-prim,
                                            output deTanque).
         
        if valid-handle(h-abastec) then
            run Destroy in h-abastec.

        /*Verifica o relacionamento do item com o tipo de material*/
        IF NOT CAN-FIND(FIRST mab-tip-mater-item 
                         WHERE mab-tip-mater-item.it-codigo     = p-it-codigo 
                           AND mab-tip-mater-item.cod-tip-mater = v-cod-tip-mater) THEN DO:
            {utp/ut-liter.i "Relacionamento_Item_x_Tipo_de_Material_Inexistente"}
            run piCriaErro (17006, 'EMS':U, return-value).
        END.
    end.

    /** Validaá‰es de Criaá∆o e Alteraá∆o **/
    if  i-operacao = 1 or i-operacao = 2 then do:
         /** Item em branco **/
         {utp/ut-liter.i "Abastecimento"}
         if p-it-codigo = "" then do:
             run piCriaErro (33213, 'EMS':U, cEqpto + "~~" + c-posto + "~~" + v-cod-tip-mater + "~~" + "" + "~~" + RETURN-VALUE).
         end.
    END.
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validar-lubrif wWindow 
PROCEDURE pi-validar-lubrif:
    DEFINE VARIABLE cTexto AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cEqpto AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cEstabelec AS CHARACTER  NO-UNDO.

    /* Guarda Equipamento */
    ASSIGN cEqpto = STRING(i-ep-codigo) + "-" + c-cod-eqpto.

    /** Validaá‰es de Criaá∆o **/
    if i-operacao = 1 then do:
         /** C¢digo Compartimento em branco **/
         {utp/ut-liter.i "Compartimento"}
         if  c-cod-compart = "" then do:
             run piCriaErro (3145, 'EMS':U, return-value).
         end.
         else do:
             /** Compartimento n∆o cadastrado **/
             if not can-find(first mab-comptmento
                             where mab-comptmento.cod-comptmento = c-cod-compart no-lock)
                             then do:
                 run piCriaErro (56, 'EMS':U, return-value).
             end.
         end.
         /** Item em branco **/
         {utp/ut-liter.i "Item"}
         if  p-it-codigo = "" then do:
             run piCriaErro (33213, 'EMS':U, "cEqpto" + "~~" + "c-cod-posto" + "~~" + "v-cod-tip-mater" + "~~" + c-cod-compart + "~~" + c-cod-evento).
         end.
    END.

    /** Validaá‰es de Criaá∆o e Alteraá∆o **/
    if  i-operacao = 1 or i-operacao = 2 then do:
         /** C¢digo Evento em branco **/
         {utp/ut-liter.i "Evento"}
         if c-cod-evento = "" then do:
             run piCriaErro (3145, 'EMS':U, return-value).
         end.
         else do:
             /** Evento n∆o cadastrado **/
             if not can-find(first mab-event
                             where mab-event.cod-evento = c-cod-evento no-lock) then do:
                 run piCriaErro (56, 'EMS':U, return-value).
             end.
             else do:
                 /** Validaá‰es referentes aos eventos ‡leo / Filtro **/
                 run validaEvento in this-procedure.
             end.
         end.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEvento wWindow 
PROCEDURE validaEvento:
    
    /** Busca compartimento **/
    for first bfComp fields(idi-oleo-filtro)
        where bfComp.cod-comptmento = c-cod-compart no-lock:
        /** Busca evento **/
        for first bfEvento fields(cod-grp-event)
            where bfEvento.cod-evento = c-cod-evento no-lock:
            /** Busca grupo de evento atraves do evento **/
            for first bfGrupo fields(idi-tip cod-grp-event) of bfEvento no-lock:
                if bfGrupo.idi-tip <> bfComp.idi-oleo-filtro then do:
                    /** Tipo de evento Ç diferente do tipo de Compartimento **/
                    run piCriaErro (28469, 'EMS':U, c-cod-evento + "~~" + bfGrupo.cod-grp-event + "~~" + c-cod-compart).
                    return "NOK":U.
                end.
            end.
        end.
    end.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validar-outros wWindow 
PROCEDURE pi-validar-outros:

    DEFINE VARIABLE cTexto1 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cTexto2 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cTexto3 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cTexto4 AS CHARACTER NO-UNDO.
    
    /** Data Movto **/
    if  dat-movto = ? then do:
        /** Data deve ser informada **/
        {utp/ut-liter.i "Data de Movimento"}
        run piCriaErro (822, 'EMS':U, return-value).
    END.
    ELSE DO:
        if  dat-movto > today then do:
            /** Data n∆o pode ser maior que a data atual **/
            {utp/ut-liter.i "Data do Movimento maior que a data Atual do Sistema"}
            ctexto1 = RETURN-VALUE.
            {utp/ut-liter.i "A data do Movimento n∆o pode ser maior que a data atual do Sistema."}
            ctexto2 = RETURN-VALUE.
            run piCriaErro (25997, 'EMS':U, cTexto1 + "~~" + cTexto2).
        end.
    END.

    /** Empresa Equipamento **/
    IF NOT CAN-FIND(FIRST empresa 
                    WHERE empresa.ep-codigo = i-ep-codigo) THEN DO:
        /** Empresa do Equipamento n∆o cadastrada **/
        {utp/ut-liter.i "Empresa do Equipamento"}
        run piCriaErro (47, 'EMS':U, RETURN-VALUE).
    END.
    
    FIND FIRST mab-eqpto 
         WHERE mab-eqpto.ep-codigo = i-ep-codigo AND
               mab-eqpto.cod-eqpto = c-cod-eqpto NO-LOCK NO-ERROR.
    IF  AVAIL mab-eqpto THEN DO:
        IF  dat-movto < mab-eqpto.dat-situacao 
        AND mab-eqpto.dat-situacao <> ? THEN DO:
            /** Equipamento dever† estar ativo **/
            run piCriaErro (26405, 'EMS':U, RETURN-VALUE).
        END.
        IF mab-eqpto.dat-inicial > dat-movto THEN DO:
            /** Data in°cio equipamento deve ser menor que a data do movimento **/
            {utp/ut-liter.i "In°cio Controle Equipamento"}
            ASSIGN cTexto3 = return-value. 
            {utp/ut-liter.i "do Movimento"}
            ASSIGN cTexto4 = return-value. 
            run piCriaErro (29599, 'EMS':U, cTexto3 + "~~" + cTexto4).
        END.
    END.
    ELSE DO:
        /** Equipamento n∆o cadastrado **/
        {utp/ut-liter.i "Equipamento"}
        run piCriaErro (47, 'EMS':U, RETURN-VALUE).
    END.
    
    /*Evento*/
    IF  c-cod-evento <> "" THEN DO:
        FOR FIRST mab-event FIELDS(idi-valor)
            WHERE mab-event.cod-evento = c-cod-evento no-lock:
            IF mab-event.idi-valor <> 2 THEN DO:
                /** Tipo do valor do evento inv†lido **/
                {utp/ut-liter.i "Tipo do Valor do Evento Inv†lido"}
                ctexto3 = RETURN-VALUE.
                {utp/ut-liter.i "O Evento informado dever† ser do Tipo de Valor = Gera Despesa."}
                ctexto4 = RETURN-VALUE.
                run piCriaErro (25997, 'EMS':U, cTexto3 + "~~" + cTexto4).
            END.
        END.
        IF NOT AVAIL mab-event THEN DO:
            /** Evento deve estar cadastrado **/
            {utp/ut-liter.i "Evento"}
            run piCriaErro (47, 'EMS':U, RETURN-VALUE).
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piIntegracaoEMS wWindow 
PROCEDURE piIntegracaoEMS:
    DEFINE VARIABLE l-altera AS LOGICAL NO-UNDO.

    IF  i-operacao = 2 THEN DO: /* Atleraá∆o */

        /** Verifica integracao com EMS **/
        run buscaIntegracao in hDBOFicha.
        if return-value = "NOK":U then do:
            ASSIGN l-altera = NO.
            FOR FIRST mab-param fields(des-valor cdn-param)
                where mab-param.cdn-param = 44 no-lock:
                ASSIGN l-altera = if mab-param.des-valor = "1" 
                                  then yes
                                  else no.
            END.
            /** Desabilita Campos em tela para nao serem modificados **/
            ASSIGN i-ep-codigo:sensitive    in frame fPage1 = no
                   c-cod-eqpto:sensitive    in frame fPage1 = no
                   c-posto:sensitive        in frame fPage1 = no
                   c-cod-evento:sensitive   in frame fPage1 = no
                   c-cod-compart:sensitive  in frame fPage1 = no
                   c-cod-ativid:sensitive   in frame fPage1 = l-altera
                   c-cod-rota:sensitive     in frame fPage1 = l-altera
                   i-empresa-matr:sensitive in frame fPage1 = l-altera
                   c-estabel-matr:sensitive IN frame fPage1 = l-altera
                   c-cod-matr:sensitive     in frame fPage1 = l-altera.

            IF l-altera THEN DO:
                RUN piparametros IN THIS-PROCEDURE.
            END.

            if  input frame fpage1 rs-tipo = 2 /* Lubrificaá∆o */ THEN
                ASSIGN c-ct-codigo:SENSITIVE in frame fPage1 = no
                       c-cc-codigo:SENSITIVE in frame fPage1 = no.
        end.
    END.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{abp/abapi001.i2} /** piCriaErro **/

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPosto wWindow 
FUNCTION fnPosto RETURNS CHARACTER ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.
    
    if can-find(first mab-posto
                where mab-posto.cod-emitente = p-cod-emitente no-lock) then do:
        for first mab-posto fields(cod-posto)
            where mab-posto.cod-emitente = p-cod-emitente no-lock:
            assign cRetorno = mab-posto.cod-posto.
        end.
    end.
    else do:
        assign cRetorno = "":U.
    end.

    RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
