&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T********************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/
{include/i-prgvrs.i IM7000AA 2.00.00.000} /*** "010000" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM7000AA MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM7000AA
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 tb-rateio tb-rateio-desp-comp tb-calcula-impostos
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

DEF INPUT PARAM phCaller AS HANDLE NO-UNDO.
DEF INPUT PARAM i-num-di-ems        LIKE decla-import.num-di-ems        NO-UNDO.
DEF INPUT PARAM de-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts  NO-UNDO.
DEF INPUT PARAM i-num-seq-retif     LIKE decla-import.num-seq-retif     NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE l-rateio                   AS LOGICAL                        NO-UNDO.
DEFINE VARIABLE l-gera-relat               AS LOGICAL                        NO-UNDO.
DEFINE VARIABLE l-calcula-impostos         AS LOGICAL                        NO-UNDO.
DEFINE VARIABLE l-log-pend-rat             AS LOGICAL                        NO-UNDO.
DEFINE VARIABLE l-rateio-desp-comp         AS LOGICAL                        NO-UNDO.
DEFINE VARIABLE l-log-pend-despes-compltar AS LOGICAL                        NO-UNDO.
DEFINE VARIABLE l-regera-default-impostos  AS LOGICAL                        NO-UNDO.
DEFINE VARIABLE l-encontrou                AS LOGICAL                        NO-UNDO.
DEFINE VARIABLE log-imp-alterado           AS LOGICAL                        NO-UNDO.
DEFINE VARIABLE log-ignora-msg             AS LOGICAL INITIAL NO             NO-UNDO.
DEFINE VARIABLE h-bocx383                  AS HANDLE                         NO-UNDO.
DEFINE VARIABLE h-bocx383a                 AS HANDLE                         NO-UNDO.
DEFINE VARIABLE h-bocx403                  AS HANDLE                         NO-UNDO.
DEFINE VARIABLE c-lbl-liter                AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE c-cod-di-siscomex          LIKE decla-import.cod-di-siscomex NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btQueryJoins btReportsJoins btExit btHelp ~
rtToolBar-2 rtToolBar RECT-87 RECT-89 tb-rateio tb-rateio-desp-comp ~
tb-calcula-impostos btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS tb-rateio tb-rateio-desp-comp ~
tb-calcula-impostos rb-tipo-calculo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
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

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image/im-joi":U
     IMAGE-INSENSITIVE FILE "image/ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image/im-pri":U
     IMAGE-INSENSITIVE FILE "image/ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE rb-tipo-calculo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Considerar valores informados", 1,
"Desconsiderar valores informados", 2
     SIZE 39 BY 1.5 NO-UNDO.

DEFINE RECTANGLE RECT-87
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 6.75.

DEFINE RECTANGLE RECT-89
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53 BY 3.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 58 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 58 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE tb-calcula-impostos AS LOGICAL INITIAL no 
     LABEL "Calcular Impostos" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tb-rateio AS LOGICAL INITIAL no 
     LABEL "Rateia Valores Declaraá∆o de Importaá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .83 NO-UNDO.

DEFINE VARIABLE tb-rateio-desp-comp AS LOGICAL INITIAL no 
     LABEL "Rateia Despesas Complementares" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 42 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 46 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 50 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 54 HELP
          "Ajuda"
     tb-rateio AT ROW 3.71 COL 7
     tb-rateio-desp-comp AT ROW 4.5 COL 7
     tb-calcula-impostos AT ROW 6.5 COL 7
     rb-tipo-calculo AT ROW 7.5 COL 10.57 NO-LABEL
     btOK AT ROW 10.25 COL 2
     btCancel AT ROW 10.25 COL 13
     btHelp2 AT ROW 10.25 COL 48
     "C†lculo dos Impostos" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 5.63 COL 6
     "Rateio Valores Declaraá∆o de Importaá∆o" VIEW-AS TEXT
          SIZE 33 BY .54 AT ROW 2.75 COL 4
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 10.04 COL 1
     RECT-87 AT ROW 3 COL 2
     RECT-89 AT ROW 5.92 COL 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 58.57 BY 10.67
         FONT 1.


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
         HEIGHT             = 10.88
         WIDTH              = 58.57
         MAX-HEIGHT         = 35.79
         MAX-WIDTH          = 93.72
         VIRTUAL-HEIGHT     = 35.79
         VIRTUAL-WIDTH      = 93.72
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR RADIO-SET rb-tipo-calculo IN FRAME fpage0
   NO-ENABLE                                                            */
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


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
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
    ASSIGN l-rateio           = INPUT FRAME fPage0 tb-rateio
           l-calcula-impostos = INPUT FRAME fPage0 tb-calcula-impostos
           l-rateio-desp-comp = INPUT FRAME fPage0 tb-rateio-desp-comp
           rb-tipo-calculo    = INPUT FRAME fPage0 rb-tipo-calculo.

    EMPTY TEMP-TABLE RowErrors.

    IF  l-rateio THEN DO:
        IF  CAN-FIND(FIRST funcao 
                     WHERE funcao.cd-funcao = 'spp-imp-forma-preco-compr':U
                     AND   funcao.ativo) THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 56358, 
                               INPUT "").
            RETURN NO-APPLY.
        END. 
    END.
    
    /* Verifica se o calculo sera feito pelos valores default ou pelos valores informados pelo usuario no im410a */
    IF l-calcula-impostos AND rb-tipo-calculo = 2 AND NOT log-ignora-msg THEN DO:
        {utp/ut-liter.i "Confirma_a_execuá∆o_deste_bot∆o?" *}
        ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
        {utp/ut-liter.i "A_confirmaá∆o_ir†_fazer_com_que_o_sistema_busque_e_altere_os_valores_das_tributaá‰es_e_al°quotas_default_dos_impostos._Continua?" *}
        
        RUN utp/ut-msgs.p (INPUT 'show', INPUT 27100, c-lbl-liter + '~~' + TRIM(RETURN-VALUE)).
        IF  RETURN-VALUE = 'yes' THEN DO:
            ASSIGN l-regera-default-impostos = YES.
            RUN pi-seta-n-log-impostos IN h-bocx403 (INPUT i-num-di-ems,
                                                     INPUT de-cdd-siscomex-dts).
        END.
        ELSE
            RETURN "NOK":U.
    END.
    
   IF  CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
   END.

    RUN setaTipoGeracao.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME tb-calcula-impostos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-calcula-impostos wWindow
ON VALUE-CHANGED OF tb-calcula-impostos IN FRAME fpage0 /* Calcular Impostos */
DO:
  DEF VAR cb-calculo AS LOGICAL NO-UNDO.
  ASSIGN cb-calculo = logical(tb-calcula-impostos:SCREEN-VALUE IN FRAME fPage0).
  IF log-imp-alterado THEN
      IF cb-calculo THEN
          ENABLE rb-tipo-calculo WITH FRAME fPage0.
      ELSE
          DISABLE rb-tipo-calculo WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
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

IF VALID-HANDLE(h-bocx383) THEN DO:
    DELETE PROCEDURE h-bocx383.
    ASSIGN h-bocx383 = ?.
END.

IF VALID-HANDLE(h-bocx383a) THEN DO:
    DELETE PROCEDURE h-bocx383a.
    ASSIGN h-bocx383a = ?.
END.

IF VALID-HANDLE(h-bocx403) THEN DO:
    DELETE PROCEDURE h-bocx403.
    ASSIGN h-bocx403 = ?.
END.

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
ASSIGN l-rateio           = NO
       l-gera-relat       = NO
       l-calcula-impostos = NO
       l-rateio-desp-comp = NO.

IF NOT VALID-HANDLE (h-bocx383) THEN DO:
    RUN cxbo/bocx383.p PERSISTENT SET h-bocx383.
    RUN openQueryStatic IN h-bocx383(INPUT "Main":U).
END.

IF NOT VALID-HANDLE (h-bocx383a) THEN DO:
    RUN cxbo/bocx383a.p PERSISTENT SET h-bocx383a.
END.

IF NOT VALID-HANDLE (h-bocx403) THEN DO:
    RUN cxbo/bocx403.p PERSISTENT SET h-bocx403.
END.

RUN goToKey IN h-bocx383 (INPUT i-num-di-ems,
                          INPUT i-num-seq-retif,
                          INPUT de-cdd-siscomex-dts).
IF RETURN-VALUE = "OK":U THEN DO:
    RUN getLogField IN h-bocx383(INPUT "log-pend-rat":U,
                                 OUTPUT l-log-pend-rat).

    RUN getLogField IN h-bocx383(INPUT "log-pend-despes-compltar":U,
                                 OUTPUT l-log-pend-despes-compltar).

    RUN getCharField IN h-bocx383(INPUT "cod-di-siscomex":U,
                                  OUTPUT c-cod-di-siscomex).
END.
                                       
IF  VALID-HANDLE(h-bocx383a) THEN
    RUN piDoctoRecebimento IN h-bocx383a(INPUT c-cod-di-siscomex, OUTPUT l-encontrou).

IF l-encontrou THEN
    DISABLE tb-rateio WITH FRAME fPage0.
ELSE
    ENABLE tb-rateio WITH FRAME fPage0.
   
/*IF l-log-pend-despes-compltar THEN
    DISABLE tb-rateio-desp-comp WITH FRAME fPage0.
ELSE*/
    ENABLE tb-rateio-desp-comp WITH FRAME fPage0.

/* verifica se os impostos foram alterados */  
RUN log-imposto-alterado IN h-bocx383(INPUT  i-num-di-ems,
                                      INPUT  de-cdd-siscomex-dts,
                                      OUTPUT log-imp-alterado).


IF NOT log-imp-alterado THEN DO:
   ASSIGN rb-tipo-calculo = 2
          log-ignora-msg = YES.
   DISP rb-tipo-calculo WITH FRAME fPage0.
   DISABLE rb-tipo-calculo WITH FRAME fPage0.
   HIDE rb-tipo-calculo IN FRAME fPage0.
   
END.
ELSE DO:
    ASSIGN rb-tipo-calculo = 1.
    DISP   rb-tipo-calculo WITH FRAME fPage0.
END.
/* fim - verifica se os impostos foram alterados */


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-RowErrors wWindow 
PROCEDURE pi-cria-RowErrors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-ErrorNumber     AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-ErrorSubType    AS CHARACTER NO-UNDO.
    DEF INPUT PARAM p-ErrorParameters AS CHARACTER NO-UNDO.

    
    CREATE RowErrors.
    ASSIGN RowErrors.ErrorNumber     = p-ErrorNumber
           RowErrors.ErrorType       = "EMS"
           RowErrors.ErrorSubType    = p-ErrorSubType
           RowErrors.ErrorParameters = p-ErrorParameters.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaTipoGeracao wWindow 
PROCEDURE setaTipoGeracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN setaTipoGeracaoRateio IN phCaller (INPUT l-rateio,
                                       INPUT l-gera-relat,
                                       INPUT l-calcula-impostos,
                                       INPUT l-rateio-desp-comp,
                                       INPUT l-regera-default-impostos).
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

