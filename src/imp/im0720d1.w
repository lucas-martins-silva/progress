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
{include/i-prgvrs.i IM0720D1 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0720D1 MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0720D1
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   c-observacao btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

{imp/im0720b.i}  /*Defini‡Æo das temp-tables tt_retorno_antecip_pef_pend e tt_log_erro*/

DEFINE TEMP-TABLE tt-adiant-despes-lista-det-aux2 NO-UNDO LIKE adiant-despes-lista-det
    FIELD cod-refer         LIKE adiant-despes-parc.cod-refer      
    FIELD cod-parcela       LIKE adiant-despes-parc.cod-parcela    
    FIELD cod-espec-docto   LIKE adiant-despes-parc.cod-espec-docto
    FIELD cod-ser-docto     LIKE adiant-despes-parc.cod-ser-docto  
    FIELD cod-tit-ap        LIKE adiant-despes-parc.cod-tit-ap     
    FIELD val-adiant-moed   LIKE adiant-despes-parc.val-adiant-moed
    FIELD dat-emissao       LIKE adiant-despes-parc.dat-emissao    
    FIELD dat-vencto        LIKE adiant-despes-parc.dat-vencto     
    FIELD num-pedido        LIKE ordem-compra.num-pedido
    FIELD parcela           LIKE ordens-embarque.parcela
    FIELD cod-emitente      LIKE ordem-compra.cod-emitente
    FIELD it-codigo         LIKE ordem-compra.it-codigo
    FIELD observacao        LIKE adiant-despes-lista.observacao
    FIELD marca             AS   CHARACTER
    FIELD r-rowid           AS ROWID.

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER TABLE FOR tt-adiant-despes-lista-det-aux2.
DEFINE INPUT PARAMETER ph-im0720d AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-boad104       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boad107       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boun005       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx00443     AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-1 RECT-2 ~
btQueryJoins btReportsJoins btExit btHelp c-cod-estabel c-desc-estabel ~
l-gerou-tit-apb cdd-adiant c-desc-situacao c-cod-refer c-cod-espec-docto ~
c-desc-espec dt-dat-emissao c-cod-ser-docto dt-dat-vencto c-cod-tit-ap ~
d-val-adiant-moed c-cod-parcela c-observacao btOK btCancel btHelp2 c-text 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estabel c-desc-estabel ~
l-gerou-tit-apb cdd-adiant c-desc-situacao c-cod-refer c-cod-espec-docto ~
c-desc-espec dt-dat-emissao c-cod-ser-docto dt-dat-vencto c-cod-tit-ap ~
d-val-adiant-moed c-cod-parcela c-observacao c-text 

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

DEFINE VARIABLE c-observacao AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 68 BY 5.38 NO-UNDO.

DEFINE VARIABLE c-cod-espec-docto AS CHARACTER FORMAT "x(3)" 
     LABEL "Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "x(5)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-parcela AS CHARACTER FORMAT "x(02)" 
     LABEL "Parcela" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-refer AS CHARACTER FORMAT "X(10)":U 
     LABEL "Referˆncia" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-ser-docto AS CHARACTER FORMAT "x(5)" 
     LABEL "S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-tit-ap AS CHARACTER FORMAT "x(16)" 
     LABEL "T¡tulo" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-espec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-situacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Situa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-text AS CHARACTER FORMAT "X(256)":U INITIAL "Observa‡Æo:" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

DEFINE VARIABLE cdd-adiant AS DECIMAL FORMAT ">>>>,>>>,>>>,>>>,>>9":U INITIAL 0 
     LABEL "Adiantamento" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-adiant-moed AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor Adiantamento" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE dt-dat-emissao AS DATE FORMAT "99/99/9999" 
     LABEL "Data EmissÆo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE dt-dat-vencto AS DATE FORMAT "99/99/9999" 
     LABEL "Data Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.25.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 10.71.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE l-gerou-tit-apb AS LOGICAL INITIAL no 
     LABEL "Gerou T¡tulo APB?" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     c-cod-estabel AT ROW 2.67 COL 13.14 COLON-ALIGNED WIDGET-ID 32
     c-desc-estabel AT ROW 2.67 COL 19.57 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     l-gerou-tit-apb AT ROW 2.67 COL 68.29 WIDGET-ID 22
     cdd-adiant AT ROW 3.67 COL 13 COLON-ALIGNED WIDGET-ID 18
     c-desc-situacao AT ROW 3.67 COL 66.29 COLON-ALIGNED WIDGET-ID 26
     c-cod-refer AT ROW 4.67 COL 13 COLON-ALIGNED WIDGET-ID 20
     c-cod-espec-docto AT ROW 5.96 COL 13 COLON-ALIGNED WIDGET-ID 38
     c-desc-espec AT ROW 5.96 COL 18.29 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     dt-dat-emissao AT ROW 5.96 COL 66 COLON-ALIGNED WIDGET-ID 50
     c-cod-ser-docto AT ROW 6.96 COL 13 COLON-ALIGNED WIDGET-ID 46
     dt-dat-vencto AT ROW 6.96 COL 66 COLON-ALIGNED WIDGET-ID 52
     c-cod-tit-ap AT ROW 7.96 COL 13 COLON-ALIGNED WIDGET-ID 48
     d-val-adiant-moed AT ROW 7.96 COL 66 COLON-ALIGNED WIDGET-ID 54
     c-cod-parcela AT ROW 8.96 COL 13 COLON-ALIGNED WIDGET-ID 44
     c-observacao AT ROW 10.17 COL 15.14 NO-LABEL WIDGET-ID 60
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     c-text AT ROW 10.21 COL 3.86 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 16.54 COL 1
     RECT-1 AT ROW 2.5 COL 1 WIDGET-ID 56
     RECT-2 AT ROW 5.79 COL 1 WIDGET-ID 58
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
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
         HEIGHT             = 17
         WIDTH              = 90
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

    IF  AVAIL tt-adiant-despes-lista-det-aux2 THEN
        ASSIGN tt-adiant-despes-lista-det-aux2.observacao = INPUT FRAME fPage0 c-observacao.

    RUN pi-recebe-observacao IN ph-im0720d (INPUT TABLE tt-adiant-despes-lista-det-aux2).

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


&Scoped-define SELF-NAME c-cod-espec-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-espec-docto wWindow
ON LEAVE OF c-cod-espec-docto IN FRAME fpage0 /* Esp‚cie */
DO:
    IF  LENGTH(SELF:SCREEN-VALUE) <> 2 OR
        ERROR-STATUS:ERROR THEN 
        ASSIGN SELF:FORMAT = "X(2)":U.
    ELSE
        ASSIGN SELF:FORMAT = "!(2)":U.

    {method/referencefields.i  
          &HandleDBOLeave="h-boad104"
          &FindMethod="findEspecie"
          &KeyValue1="c-cod-espec-docto:SCREEN-VALUE IN FRAME {&frame-name}"
          &FieldName1="descricao"
          &FieldScreen1="c-desc-espec"
          &Frame1="fPage0"}
          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wWindow
ON LEAVE OF c-cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
      {method/referencefields.i 
            &HandleDBOLeave="h-boad107"
            &FindMethod="findCodigo"
            &KeyValue1="c-cod-estabel:SCREEN-VALUE IN FRAME fPage0"
            &FieldName1="nome"
            &FieldScreen1="c-desc-estabel"
            &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-tit-ap
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-tit-ap wWindow
ON LEAVE OF c-cod-tit-ap IN FRAME fpage0 /* T¡tulo */
DO:
  RUN piSugereParcela IN THIS-PROCEDURE.
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
  Purpose:     Elimina os handle's instanciados na abertura do programa
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-boad104) THEN DO:
        DELETE PROCEDURE h-boad104.
        ASSIGN h-boad104 = ?.
    END.

    IF VALID-HANDLE(h-boad107) THEN DO:
        DELETE PROCEDURE h-boad107.
        ASSIGN h-boad107 = ?.
    END.

    IF VALID-HANDLE(h-boun005) THEN DO:
        DELETE PROCEDURE h-boun005.
        ASSIGN h-boun005 = ?.
    END.

    IF VALID-HANDLE(h-bocx00443) THEN DO:
        DELETE PROCEDURE h-bocx00443.
        ASSIGN h-bocx00443 = ?.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa os campos em tela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cod-emitente LIKE adiant-despes-parc.cdn-emitente NO-UNDO.

    {utp/ut-liter.i Observa‡Æo * r}                                                             
    ASSIGN c-text:SCREEN-VALUE IN FRAME fPage0 = TRIM(RETURN-VALUE).

    IF NOT VALID-HANDLE(h-boad104) THEN
        RUN adbo/boad104.p PERSISTENT SET h-boad104.

    IF NOT VALID-HANDLE(h-boad107) THEN
        RUN adbo/boad107.p PERSISTENT SET h-boad107.

    IF NOT VALID-HANDLE(h-boun005) THEN
        RUN unbo/boun005.p PERSISTENT SET h-boun005.

    IF NOT VALID-HANDLE(h-bocx00443) THEN
        RUN cxbo/bocx00443.p PERSISTENT SET h-bocx00443.
    RUN openQueryStatic IN h-bocx00443 (INPUT "Main":U).

    FIND FIRST tt-adiant-despes-lista-det-aux2 NO-ERROR.
    IF AVAIL tt-adiant-despes-lista-det-aux2 THEN DO:
        ASSIGN c-cod-estabel:SCREEN-VALUE     IN FRAME fPage0 = tt-adiant-despes-lista-det-aux2.cod-estabel
               cdd-adiant:SCREEN-VALUE        IN FRAME fPage0 = string(tt-adiant-despes-lista-det-aux2.cdd-adiant)
               c-cod-refer:SCREEN-VALUE       IN FRAME fPage0 = tt-adiant-despes-lista-det-aux2.cod-refer
               c-cod-espec-docto:SCREEN-VALUE IN FRAME fPage0 = tt-adiant-despes-lista-det-aux2.cod-espec-docto
               c-cod-ser-docto:SCREEN-VALUE   IN FRAME fPage0 = tt-adiant-despes-lista-det-aux2.cod-ser-docto
               c-cod-tit-ap:SCREEN-VALUE      IN FRAME fPage0 = tt-adiant-despes-lista-det-aux2.cod-tit-ap
               c-cod-parcela:SCREEN-VALUE     IN FRAME fPage0 = tt-adiant-despes-lista-det-aux2.cod-parcela
               dt-dat-emissao:SCREEN-VALUE    IN FRAME fPage0 = string(tt-adiant-despes-lista-det-aux2.dat-emissao)
               dt-dat-vencto:SCREEN-VALUE     IN FRAME fPage0 = string(tt-adiant-despes-lista-det-aux2.dat-vencto)
               d-val-adiant-moed:SCREEN-VALUE IN FRAME fPage0 = string(tt-adiant-despes-lista-det-aux2.val-adiant-moed)
               c-observacao:SCREEN-VALUE      IN FRAME fPage0 = tt-adiant-despes-lista-det-aux2.observacao.

        RUN goToKeyAdiant  IN h-bocx00443 (INPUT tt-adiant-despes-lista-det-aux2.cod-estabel,
                                           INPUT tt-adiant-despes-lista-det-aux2.cdd-adiant,
                                           INPUT tt-adiant-despes-lista-det-aux2.cod-refer).         
        IF RETURN-VALUE = "OK":U THEN
            RUN getIntField IN h-bocx00443 (INPUT "cdn-emitente":U, OUTPUT i-cod-emitente).

        RUN piRetornaSituacaoAPB IN h-bocx00443 (INPUT tt-adiant-despes-lista-det-aux2.cod-estabel,
                                                 INPUT tt-adiant-despes-lista-det-aux2.cod-refer,
                                                 INPUT i-cod-emitente,
                                                 OUTPUT c-desc-situacao,
                                                 OUTPUT l-gerou-tit-apb,
                                                 OUTPUT TABLE tt_retorno_antecip_pef_pend,
                                                 OUTPUT TABLE tt_log_erro).

        DISP c-desc-situacao
             l-gerou-tit-apb
            WITH FRAME fPage0.

    END.

    APPLY "leave":U TO c-cod-estabel IN FRAME fPage0.
    APPLY "leave":U TO c-cod-espec-docto IN FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

