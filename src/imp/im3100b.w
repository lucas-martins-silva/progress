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
{include/i-prgvrs.i IM3100B 2.00.00.004} /* 13/08/2025 08:31:03 */

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM3100B MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM3100B
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE page0Widgets   c-decla-import da-data-di i-aduana ~
                              btOK btCancel btHelp2 c-cod-chave-operacao

{inbo/boin01066.i tt-docto-estoq-internac}

DEF  INPUT PARAM p-decla-import AS CHAR FORMAT "x(20)" NO-UNDO.
DEF  INPUT PARAM p-dat-import   AS DATE NO-UNDO.
DEF OUTPUT PARAM p-ok           AS LOG  NO-UNDO.
DEF OUTPUT PARAM TABLE FOR tt-docto-estoq-internac.
DEFINE VARIABLE c-decl-imp-aduana-aux AS CHAR NO-UNDO.

DEF VAR h-bocx00456  AS HANDLE NO-UNDO.
DEF VAR h-bocl202192 AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-1 da-data-di i-aduana ~
c-desc-aduana i-agente c-desc-agente i-dig-verifica i-num-sec ~
c-cod-chave-operacao btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS da-data-di i-aduana c-desc-aduana i-agente ~
c-desc-agente i-dig-verifica i-num-sec c-decla-import c-cod-chave-operacao 

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

DEFINE VARIABLE c-cod-chave-operacao AS CHARACTER FORMAT "X(6)":U 
     LABEL "Chave de Opera‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-decla-import AS CHARACTER FORMAT "X(20)":U 
     LABEL "Declara‡Æo Importa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-aduana AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-agente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-di AS DATE FORMAT "99/99/9999":U 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-aduana AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Aduana" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE i-agente AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Agente" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE i-dig-verifica AS INTEGER FORMAT "9":U INITIAL 0 
     LABEL "Dig Ver" 
     VIEW-AS FILL-IN 
     SIZE 2.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-sec AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "N£m Sequencia" 
     VIEW-AS FILL-IN 
     SIZE 7.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 6.71.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     da-data-di AT ROW 1.63 COL 24 COLON-ALIGNED WIDGET-ID 4
     i-aduana AT ROW 2.63 COL 24 COLON-ALIGNED WIDGET-ID 10
     c-desc-aduana AT ROW 2.63 COL 30.29 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     i-agente AT ROW 3.63 COL 24 COLON-ALIGNED WIDGET-ID 14
     c-desc-agente AT ROW 3.63 COL 30.29 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     i-dig-verifica AT ROW 4.63 COL 24 COLON-ALIGNED WIDGET-ID 20
     i-num-sec AT ROW 4.63 COL 40.14 COLON-ALIGNED WIDGET-ID 18
     c-decla-import AT ROW 5.63 COL 24 COLON-ALIGNED WIDGET-ID 2
     c-cod-chave-operacao AT ROW 6.63 COL 24 COLON-ALIGNED WIDGET-ID 22
     btOK AT ROW 8.04 COL 2
     btCancel AT ROW 8.04 COL 13
     btHelp2 AT ROW 8.04 COL 80
     rtToolBar AT ROW 7.83 COL 1
     RECT-1 AT ROW 1.04 COL 1 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 8.38
         FONT 1 WIDGET-ID 100.


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
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 8.38
         WIDTH              = 90
         MAX-HEIGHT         = 40.71
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 40.71
         VIRTUAL-WIDTH      = 182.86
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
/* SETTINGS FOR FILL-IN c-decla-import IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       c-desc-agente:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       i-agente:HIDDEN IN FRAME fpage0           = TRUE.

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
    EMPTY TEMP-TABLE tt-docto-estoq-internac.

    /* Valida‡äes */
    
    IF  i-num-sec:SCREEN-VALUE IN FRAME fPage0 = "" 
    OR  i-num-sec:SCREEN-VALUE IN FRAME fPage0 = "?" THEN DO:
        {utp/ut-liter.i "N£mero_Sequˆncia" *}
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 265,
                           input TRIM(RETURN-VALUE)). 
        APPLY "entry" TO i-num-sec IN FRAME fPage0.
        RETURN NO-APPLY.
    END.

    IF  i-dig-verifica:SCREEN-VALUE IN FRAME fPage0 = "" 
    OR  i-dig-verifica:SCREEN-VALUE IN FRAME fPage0 = "?" THEN DO:
        {utp/ut-liter.i "D¡gito_verificador" *}
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 265,
                           input TRIM(RETURN-VALUE)). 
        APPLY "entry" TO i-dig-verifica IN FRAME fPage0.
        RETURN NO-APPLY.
    END.

    IF  c-decla-import:SCREEN-VALUE IN FRAME fPage0 = "" 
    OR  c-decla-import:SCREEN-VALUE IN FRAME fPage0 = "?"
    OR  c-decla-import = ? THEN DO:
        {utp/ut-liter.i "Declara‡Æo_Importa‡Æo" *}
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 265,
                           input TRIM(RETURN-VALUE)). 
        APPLY "entry" TO c-decla-import IN FRAME fPage0.
        RETURN NO-APPLY.
    END.

    IF  da-data-di:SCREEN-VALUE IN FRAME fPage0 = "" 
    OR  da-data-di:SCREEN-VALUE IN FRAME fPage0 = ? THEN DO:
        {utp/ut-liter.i "Data" *}
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 265,
                           input TRIM(RETURN-VALUE)). 
        APPLY "entry" TO da-data-di IN FRAME fPage0.
        RETURN NO-APPLY.
    END.

    RUN goToKey IN h-bocx00456 (INPUT INT(i-aduana:SCREEN-VALUE IN FRAME fPage0)).
    IF  RETURN-VALUE <> "OK":U THEN DO:
        {utp/ut-liter.i "Aduana" *}
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 2,
                           input TRIM(RETURN-VALUE)). 
        APPLY "entry" TO i-aduana IN FRAME fPage0.
        RETURN NO-APPLY.
    END.

    IF  i-pais-impto-usuario = 4 /* Mexico */ THEN DO:
        RUN goToKey IN h-bocl202192 (INPUT INT(i-agente:SCREEN-VALUE IN FRAME fPage0)).
        IF  RETURN-VALUE <> "OK":U THEN DO:
            {utp/ut-liter.i "Agente" *}
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 2,
                               input TRIM(RETURN-VALUE)). /*265 - &1 deve ser informado(a). ~~ &1 deve ser informado(a).*/
            APPLY "entry" TO i-agente IN FRAME fPage0.
            RETURN NO-APPLY.
        END.
        
        IF c-cod-chave-operacao:INPUT-VALUE = "" OR
           c-cod-chave-operacao:INPUT-VALUE = ? THEN DO:
            {utp/ut-liter.i "Chave_de_Opera‡Æo" *}
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 265,
                               INPUT TRIM(RETURN-VALUE)).
            APPLY "entry" TO c-cod-chave-operacao IN FRAME fPage0.
            RETURN NO-APPLY.
        END.
    END.
    /* Fim Valida‡äes */
    
    /* Cria registro */
    DO  WITH FRAME fPage0:
        CREATE tt-docto-estoq-internac.
        ASSIGN tt-docto-estoq-internac.declaracao-import = c-decla-import:SCREEN-VALUE
               tt-docto-estoq-internac.data-di           = INPUT da-data-di
               tt-docto-estoq-internac.cdn-aduana        = INPUT i-aduana
               tt-docto-estoq-internac.cod-despch        = STRING(INPUT i-num-sec)
               tt-docto-estoq-internac.cod-verfdor       = STRING(INPUT i-dig-verifica)
               tt-docto-estoq-internac.cod-chave-operacao = c-cod-chave-operacao:INPUT-VALUE.
        
        IF  i-pais-impto-usuario = 4 /* Mexico */ THEN
            ASSIGN tt-docto-estoq-internac.cdn-agent = INPUT i-agente.
    END.
    
    ASSIGN p-ok = YES.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-data-di
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-data-di wWindow
ON LEAVE OF da-data-di IN FRAME fpage0 /* Data */
DO:
    RUN pi-concat-decl-imp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-aduana
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-aduana wWindow
ON F5 OF i-aduana IN FRAME fpage0 /* Aduana */
DO:
    {method/zoomfields.i &ProgramZoom="cxzoom/z01cx00456.w"
                       &FieldZoom1="cdn-aduana"
                       &FieldScreen1="i-aduana"
                       &Frame1="fPage0"
                       &FieldZoom2="des-aduana"
                       &FieldScreen2="c-desc-aduana"
                       &Frame2="fPage0"
                       &RunMethod=" " 
                       &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-aduana wWindow
ON LEAVE OF i-aduana IN FRAME fpage0 /* Aduana */
DO:
    {method/ReferenceFields.i &HandleDBOLeave="h-bocx00456"
                              &KeyValue1="i-aduana:SCREEN-VALUE IN FRAME fPage0"
                              &FieldName1="des-aduana"
                              &FieldScreen1="c-desc-aduana"
                              &Frame1="fPage0"}
                    
    RUN pi-concat-decl-imp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-aduana wWindow
ON MOUSE-SELECT-DBLCLICK OF i-aduana IN FRAME fpage0 /* Aduana */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-agente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-agente wWindow
ON F5 OF i-agente IN FRAME fpage0 /* Agente */
DO:
    {method/zoomfields.i &ProgramZoom="cl2zoom/z01cl202192.w"
                         &FieldZoom1="cdn-agent"
                         &FieldScreen1="i-agente"
                         &Frame1="fPage0"
                         &FieldZoom2="nom-agent"
                         &FieldScreen2="c-desc-agente"
                         &Frame2="fPage0"
                         &RunMethod=" " 
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-agente wWindow
ON LEAVE OF i-agente IN FRAME fpage0 /* Agente */
DO:
    {method/ReferenceFields.i &HandleDBOLeave="h-bocl202192"
                              &KeyValue1="i-agente:SCREEN-VALUE IN FRAME fPage0"
                              &FieldName1="nom-agent"
                              &FieldScreen1="c-desc-agente"
                              &Frame1="fPage0"}
                               
    RUN pi-concat-decl-imp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-agente wWindow
ON MOUSE-SELECT-DBLCLICK OF i-agente IN FRAME fpage0 /* Agente */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-dig-verifica
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-dig-verifica wWindow
ON LEAVE OF i-dig-verifica IN FRAME fpage0 /* Dig Ver */
DO:
    RUN pi-concat-decl-imp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-num-sec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-num-sec wWindow
ON LEAVE OF i-num-sec IN FRAME fpage0 /* N£m Sequencia */
DO:
    RUN pi-concat-decl-imp.
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

    RUN destroy IN h-bocx00456.
    
    IF  VALID-HANDLE(h-bocl202192) THEN
        RUN destroy IN h-bocl202192.

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
    
    /* BO recinto-aduana */
    RUN cxbo/bocx00456.p PERSISTENT SET h-bocx00456.
    RUN openQueryStatic IN h-bocx00456 (INPUT "Main":U).

    DO WITH FRAME fPage0:
                /* Carrega campos com o parametro p-decla-import */
        ASSIGN da-data-di:SCREEN-VALUE   = STRING(p-dat-import)
               i-num-sec:SCREEN-VALUE IN FRAME fPage0 = SUBSTR(p-decla-import,10,6)
               i-dig-verifica:SCREEN-VALUE IN FRAME fPage0 = SUBSTR(p-decla-import,9,1)
               i-aduana:SCREEN-VALUE IN FRAME fPage0 = SUBSTR(p-decla-import,3,2)
               i-agente:SCREEN-VALUE IN FRAME fPage0 = SUBSTR(p-decla-import,5,4).   

        CASE i-pais-impto-usuario:
            WHEN 2 THEN DO: /* Argentina */
                ASSIGN i-aduana:SCREEN-VALUE = SUBSTR(c-decla-import,3,3).
            END.
            WHEN 4 THEN DO: /* M‚xico */
                ASSIGN i-agente:HIDDEN      = NO
                       i-agente:SENSITIVE   = YES
                       i-agente:FORMAT      = "zzz9"
                       c-desc-agente:HIDDEN = NO
                       i-num-sec:SENSITIVE  = YES
                       i-dig-verifica:SENSITIVE = YES
                       c-decla-import:SENSITIVE = NO.

                /* BO Agente */
                RUN cl2bo/bocl202192.p PERSISTENT SET h-bocl202192.
                RUN openQueryStatic IN h-bocl202192 (INPUT "Main":U).
            END.
        END CASE.
    END.

    i-aduana:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
    i-agente:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

    EMPTY TEMP-TABLE tt-docto-estoq-internac.
    
     APPLY "LEAVE" TO i-aduana IN FRAME fPage0.
     APPLY "LEAVE" TO i-agente IN FRAME fPage0.   

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-concat-decl-imp wWindow 
PROCEDURE pi-concat-decl-imp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
       
       
        
        ASSIGN c-decl-imp-aduana-aux =  SUBSTRING(string(YEAR(INPUT FRAME fPage0 da-data-di)),3,2) +
                                        STRING(INPUT FRAME fPage0 i-aduana,"99")   +
                                        STRING(INPUT FRAME fPage0 i-agente,"9999") +
                                        STRING(INPUT FRAME fPage0 i-dig-verifica)  +
                                        STRING(INPUT FRAME fPage0 i-num-sec,"999999")

               c-decla-import :SCREEN-VALUE IN FRAME fPage0 = c-decl-imp-aduana-aux.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

