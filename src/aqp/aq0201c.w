&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
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
{include/i-prgvrs.i AQ0201C 2.00.00.007 } /*** 010007 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aq0201c MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        aq0201c 
&GLOBAL-DEFINE Version        2.00.00.007

&GLOBAL-DEFINE WindowType     master/detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   cbAcao ~
                              fiReajuste ~
                              fiDatInic fiDatfim ~
                              brRegras btMarcar btHelp2 ~
                              btTodos btConfirmar btCancel ~
                              btAltVigenc btAplicReaj ~
                              btDesmarcar btNenhum tgGeraPlanilha 


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */



/* Local Variable Definitions (DBOs Handles) --- */

/* Zoom Smart */
{utp/ut-glob.i}

{aqp/aqapi001.i} /* temp-tables */

DEFINE VARIABLE h-boin00972 AS HANDLE NO-UNDO. /* regra-form-preco */
DEFINE VARIABLE h-boin172   AS HANDLE NO-UNDO. /* item */

DEFINE INPUT PARAMETER TABLE FOR tt-regra-form-preco.

DEFINE VARIABLE cTxt AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brRegras

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-regra-form-preco-custom

/* Definitions for BROWSE brRegras                                      */
&Scoped-define FIELDS-IN-QUERY-brRegras tt-regra-form-preco-custom.checkSum tt-regra-form-preco-custom.cod-regra tt-regra-form-preco-custom.cdn-seq fnDescTipo(tt-regra-form-preco-custom.cdn-tipo) tt-regra-form-preco-custom.it-codigo tt-regra-form-preco-custom.val-unit tt-regra-form-preco-custom.val-reaj tt-regra-form-preco-custom.val-faixa-inic tt-regra-form-preco-custom.val-faixa-fim tt-regra-form-preco-custom.dat-inic tt-regra-form-preco-custom.dat-fim fnDescAbrangen(tt-regra-form-preco-custom.cdn-abrangen) tt-regra-form-preco-custom.descricao fnDescItem(tt-regra-form-preco-custom.it-codigo)   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brRegras   
&Scoped-define SELF-NAME brRegras
&Scoped-define QUERY-STRING-brRegras FOR EACH tt-regra-form-preco-custom NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brRegras OPEN QUERY {&SELF-NAME} FOR EACH tt-regra-form-preco-custom NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brRegras tt-regra-form-preco-custom
&Scoped-define FIRST-TABLE-IN-QUERY-brRegras tt-regra-form-preco-custom


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brRegras}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-3 RECT-7 cbAcao ~
tgGeraPlanilha btAplicReaj fiReajuste rsTipoReaj btAltVigenc fiDatInic ~
fiDatFim brRegras btMarcar btDesmarcar btTodos btNenhum btHelp2 btConfirmar ~
btCancel 
&Scoped-Define DISPLAYED-OBJECTS cbAcao tgGeraPlanilha fiReajuste ~
rsTipoReaj fiDatInic fiDatFim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescAbrangen wWindow 
FUNCTION fnDescAbrangen RETURNS CHARACTER
  ( iCdnAbrangen AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem wWindow 
FUNCTION fnDescItem RETURNS CHARACTER
  ( cItCodigo AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescTipo wWindow 
FUNCTION fnDescTipo RETURNS CHARACTER
  ( iCdnTipo AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnFormataColunaChar wWindow 
FUNCTION fnFormataColunaChar RETURNS CHARACTER
  ( cCampo AS CHARACTER, iCdnAbrangen AS INTEGER, cValor AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnFormataColunaInt wWindow 
FUNCTION fnFormataColunaInt RETURNS CHARACTER
  ( cCampo AS CHARACTER, iCdnAbrangen AS INTEGER, iValor AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btAltVigenc 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btAplicReaj 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btConfirmar 
     LABEL "Confirmar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDesmarcar 
     LABEL "Desmarcar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btMarcar 
     LABEL "Marcar" 
     SIZE 10 BY 1.

DEFINE BUTTON btNenhum 
     LABEL "Nenhum" 
     SIZE 10 BY 1.

DEFINE BUTTON btTodos 
     LABEL "Todos" 
     SIZE 10 BY 1.

DEFINE VARIABLE cbAcao AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Selecione a A‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "",0,
                     "Reajustar regras",1,
                     "Copiar e reajustar regras",2
     DROP-DOWN-LIST
     SIZE 21 BY 1 NO-UNDO.

DEFINE VARIABLE fiDatFim AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE fiDatInic AS DATE FORMAT "99/99/9999" 
     LABEL "Vigˆncia das Regras" 
     VIEW-AS FILL-IN 
     SIZE 14.14 BY .88.

DEFINE VARIABLE fiReajuste AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Aplicar Reajuste" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE rsTipoReaj AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Percentual", 1,
"Valor", 2
     SIZE 24.14 BY .5 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 110 BY 3.67.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 110 BY 13.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 112 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tgGeraPlanilha AS LOGICAL INITIAL yes 
     LABEL "Gerar Planilha ao Confirmar" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brRegras FOR 
      tt-regra-form-preco-custom SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brRegras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brRegras wWindow _FREEFORM
  QUERY brRegras NO-LOCK DISPLAY
      tt-regra-form-preco-custom.checkSum FORMAT "X(1)" LABEL "" WIDTH 3
      tt-regra-form-preco-custom.cod-regra FORMAT "X(20)":U  WIDTH 12    
      tt-regra-form-preco-custom.cdn-seq  WIDTH 5 COLUMN-LABEL 'Seq'
      fnDescTipo(tt-regra-form-preco-custom.cdn-tipo) FORMAT "x(20)" COLUMN-LABEL 'Tipo' WIDTH 18
      tt-regra-form-preco-custom.it-codigo FORMAT "x(16)":U
      tt-regra-form-preco-custom.val-unit FORMAT "->>,>>>,>>9.9999":U COLUMN-LABEL 'Valor Atual' WIDTH 10
      tt-regra-form-preco-custom.val-reaj FORMAT "->>,>>>,>>9.9999":U COLUMN-LABEL 'Valor Reajustado' WIDTH 13
      tt-regra-form-preco-custom.val-faixa-inic FORMAT "->,>>>,>>9.9999":U WIDTH 10
      tt-regra-form-preco-custom.val-faixa-fim FORMAT "->,>>>,>>9.9999":U WIDTH 10
      tt-regra-form-preco-custom.dat-inic FORMAT "99/99/9999":U
      tt-regra-form-preco-custom.dat-fim FORMAT "99/99/9999":U
      fnDescAbrangen(tt-regra-form-preco-custom.cdn-abrangen) FORMAT "x(20)" COLUMN-LABEL 'Abrangˆncia' WIDTH 12
      tt-regra-form-preco-custom.descricao COLUMN-LABEL 'Descri‡Æo Regra' FORMAT "x(200)":U WIDTH 20
      fnDescItem(tt-regra-form-preco-custom.it-codigo) COLUMN-LABEL 'Descri‡Æo Item' FORMAT "x(200)":U WIDTH 20
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 108 BY 11.5
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     cbAcao AT ROW 1.33 COL 35.86 COLON-ALIGNED 
     tgGeraPlanilha AT ROW 1.38 COL 62.43
     fiReajuste AT ROW 2.42 COL 35.86 COLON-ALIGNED HELP
          "Para reajustar o valor, digite um percentual"
     btAplicReaj AT ROW 2.33 COL 47.86 
     rsTipoReaj AT ROW 2.54 COL 52.72 NO-LABEL
     fiDatInic AT ROW 3.46 COL 35.86 COLON-ALIGNED
     fiDatFim AT ROW 3.46 COL 56.72 COLON-ALIGNED NO-LABEL 
     btAltVigenc AT ROW 3.42 COL 71.72
     brRegras AT ROW 5.25 COL 3 
     btMarcar AT ROW 16.83 COL 3 
     btDesmarcar AT ROW 16.83 COL 13.14
     btTodos AT ROW 16.83 COL 23.29
     btNenhum AT ROW 16.83 COL 33.43 
     btHelp2 AT ROW 18.29 COL 101.86
     btConfirmar AT ROW 18.33 COL 2 
     btCancel AT ROW 18.33 COL 13 
     "at‚" VIEW-AS TEXT
          SIZE 3 BY .54 AT ROW 3.54 COL 54
     rtToolBar AT ROW 18.08 COL 1
     RECT-3 AT ROW 1.08 COL 2 
     RECT-7 AT ROW 5 COL 2 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 112.29 BY 18.67
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
         HEIGHT             = 18.67
         WIDTH              = 112.29
         MAX-HEIGHT         = 38.63
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.63
         VIRTUAL-WIDTH      = 182.86
         MAX-BUTTON         = no
         RESIZE             = no
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
/* BROWSE-TAB brRegras fiDatFim fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brRegras
/* Query rebuild information for BROWSE brRegras
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-regra-form-preco-custom NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brRegras */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brRegras
&Scoped-define SELF-NAME brRegras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brRegras wWindow
ON MOUSE-SELECT-DBLCLICK OF brRegras IN FRAME fpage0
DO:
    RUN piMarcarDesmarcar IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brRegras wWindow
ON ROW-DISPLAY OF brRegras IN FRAME fpage0
DO: 
    ASSIGN tt-regra-form-preco-custom.val-unit:BGCOLOR IN BROWSE brRegras = IF INPUT FRAME fpage0 cbAcao = 0 THEN ?  ELSE 14
           tt-regra-form-preco-custom.val-reaj:BGCOLOR IN BROWSE brRegras = IF INPUT FRAME fpage0 cbAcao = 0 THEN ?  ELSE 14
           tt-regra-form-preco-custom.dat-inic:BGCOLOR IN BROWSE brRegras = IF INPUT FRAME fpage0 cbAcao = 2 THEN 14 ELSE ?.
           tt-regra-form-preco-custom.dat-fim:BGCOLOR  IN BROWSE brRegras = IF INPUT FRAME fpage0 cbAcao = 2 THEN 14 ELSE ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brRegras wWindow
ON VALUE-CHANGED OF brRegras IN FRAME fpage0
DO:
    RUN piHabilitarBotao IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAltVigenc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAltVigenc wWindow
ON CHOOSE OF btAltVigenc IN FRAME fpage0
DO:
  RUN piCalcularCopiarReajuste IN THIS-PROCEDURE(INPUT YES) .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAplicReaj
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAplicReaj wWindow
ON CHOOSE OF btAplicReaj IN FRAME fpage0
DO:
  RUN piCalcularCopiarReajuste IN THIS-PROCEDURE(INPUT NO) .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN 'NOK':U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConfirmar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfirmar wWindow
ON CHOOSE OF btConfirmar IN FRAME fpage0 /* Confirmar */
DO:
    IF INPUT FRAME fPage0 cbAcao = 0 THEN DO:
        RUN utp/ut-msgs.p(INPUT "SHOW":U,
                          INPUT 54645, /* Selecione uma acao */
                          INPUT RETURN-VALUE).
        RETURN NO-APPLY.
    END.
    ELSE DO:
        {utp/ut-liter.i de_Valores_nas_regras_selecionadas * }
        ASSIGN cTxt = RETURN-VALUE.
    
        IF INPUT FRAME fPage0 cbAcao = 1 THEN
            {utp/ut-liter.i Reajuste * }
        ELSE DO: 
            {utp/ut-liter.i Reajuste/C¢pia * }
        END.

        ASSIGN cTxt = RETURN-VALUE + " " + cTxt.

        RUN utp/ut-msgs.p ( INPUT "show":U, INPUT 701, INPUT cTxt ).
        IF  RETURN-VALUE = "no":U THEN
            RETURN NO-APPLY.

        RUN piConfirmar IN THIS-PROCEDURE.

        IF RETURN-VALUE ='OK' THEN DO:
            APPLY "CLOSE":U TO THIS-PROCEDURE.
            RETURN 'OK':U.
        END.
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDesmarcar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesmarcar wWindow
ON CHOOSE OF btDesmarcar IN FRAME fpage0 /* Desmarcar */
DO:
  RUN piMarcarDesmarcar IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btMarcar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMarcar wWindow
ON CHOOSE OF btMarcar IN FRAME fpage0 /* Marcar */
DO:
    RUN piMarcarDesmarcar IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNenhum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNenhum wWindow
ON CHOOSE OF btNenhum IN FRAME fpage0 /* Nenhum */
DO:
    FOR EACH tt-regra-form-preco-custom:
        ASSIGN tt-regra-form-preco-custom.checkSum =  "".
    END.
   
   {&OPEN-QUERY-brRegras}

   RUN piHabilitarBotao IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btTodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btTodos wWindow
ON CHOOSE OF btTodos IN FRAME fpage0 /* Todos */
DO:
    FOR EACH tt-regra-form-preco-custom:
        ASSIGN tt-regra-form-preco-custom.checkSum =  "*".
    END.
   
   {&OPEN-QUERY-brRegras}

   RUN piHabilitarBotao IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cbAcao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cbAcao wWindow
ON VALUE-CHANGED OF cbAcao IN FRAME fpage0 /* Selecione a A‡Æo */
DO:
    ASSIGN fiDatInic:SENSITIVE    = SELF:SCREEN-VALUE = '2'
           fiDatFim:SENSITIVE     = SELF:SCREEN-VALUE = '2'
           btAltVigenc:SENSITIVE  = SELF:SCREEN-VALUE = '2'
           fiReajuste:SENSITIVE   = SELF:SCREEN-VALUE <> ?
           btaplicReaj:SENSITIVE  = SELF:SCREEN-VALUE =  '1'
           rsTipoReaj:SENSITIVE   = SELF:SCREEN-VALUE <> ?.

    IF CAN-FIND(FIRST tt-regra-form-preco-custom) THEN DO:
        {&OPEN-QUERY-brRegras}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME rsTipoReaj
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsTipoReaj wWindow
ON VALUE-CHANGED OF rsTipoReaj IN FRAME fpage0
DO:
    ASSIGN fiReajuste:FORMAT = IF INPUT FRAME fPage0 rsTipoReaj = 1 THEN "->>>,>>>,>>9.99" ELSE "->>>,>>>,>>9.9999".
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
    /* Item */
    IF VALID-HANDLE (h-boin172) THEN DO:
        DELETE PROCEDURE h-boin172.
        ASSIGN h-boin172 = ?.
    END.

    /* regra-form-preco */
    IF VALID-HANDLE (h-boin00972) THEN DO:
        DELETE PROCEDURE h-boin00972.
        ASSIGN h-boin00972 = ?.
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
                                                                                
   RUN initializeDBOs IN THIS-PROCEDURE.

   APPLY 'VALUE-CHANGED':U TO cbAcao IN FRAME fPage0.

   IF CAN-FIND(FIRST tt-regra-form-preco) THEN DO:

       FOR EACH tt-regra-form-preco:
           CREATE tt-regra-form-preco-custom.
           BUFFER-COPY tt-regra-form-preco TO tt-regra-form-preco-custom.
           ASSIGN tt-regra-form-preco-custom.checkSum = '*'.
       END.

       {&OPEN-QUERY-brRegras}

       RUN piHabilitarBotao IN THIS-PROCEDURE.

   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    /* ITEM */
    IF NOT VALID-HANDLE(h-boin172) THEN
        RUN inbo/boin172na.p PERSISTENT SET h-boin172.
    RUN openQueryStatic IN h-boin172(INPUT 'Main').


    /* REGRA-FORM-PRECO */
    IF NOT VALID-HANDLE(h-boin00972) THEN
        RUN inbo/boin00972.p  PERSISTENT SET h-boin00972.
    RUN openQueryStatic IN h-boin00972(INPUT 'Main').
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCalcularCopiarReajuste wWindow 
PROCEDURE piCalcularCopiarReajuste :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER lCopia AS LOGICAL NO-UNDO.

    FOR EACH tt-regra-form-preco-custom
       WHERE tt-regra-form-preco-custom.checkSum = "*":

        IF INPUT FRAME fPage0 rsTipoReaj = 1 THEN 
            ASSIGN tt-regra-form-preco-custom.val-reaj = tt-regra-form-preco-custom.val-unit +  
                                                        (tt-regra-form-preco-custom.val-unit * (INPUT FRAME fPage0 fiReajuste / 100)). 
        ELSE         
            ASSIGN tt-regra-form-preco-custom.val-reaj = tt-regra-form-preco-custom.val-unit + INPUT FRAME fPage0 fiReajuste.
          
        
        IF lCopia THEN
            ASSIGN tt-regra-form-preco-custom.dat-inic = INPUT FRAME fPage0 fiDatInic
                   tt-regra-form-preco-custom.dat-fim  = INPUT FRAME fPage0 fiDatFim.
    END.
    
    {&OPEN-QUERY-brRegras}

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piConfirmar wWindow 
PROCEDURE piConfirmar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN emptyRowErrors IN h-boin00972.
    EMPTY TEMP-TABLE rowErrors NO-ERROR.
    
    DEFINE VARIABLE lErro AS LOGICAL NO-UNDO.
        
    IF INPUT FRAME fPage0 cbAcao > 0 THEN DO:
        IF INPUT FRAME fPage0 cbAcao = 1 THEN DO:
            APPLY 'CHOOSE':U TO btAplicReaj IN FRAME fPage0.
            RUN aplicarReajuste IN h-boin00972(INPUT-OUTPUT TABLE tt-regra-form-preco-custom).
        END.
        ELSE DO:
            APPLY 'CHOOSE':U TO btAltVigenc IN FRAME fPage0.
            RUN copiarRegras IN h-boin00972(INPUT-OUTPUT TABLE tt-regra-form-preco-custom).
        END.

        IF RETURN-VALUE = "OK":U THEN DO:
            {&OPEN-QUERY-brRegras}
            IF tgGeraPlanilha:CHECKED IN FRAME fPage0 THEN DO:
                RUN aqp/aq0201ca.p(INPUT TABLE tt-regra-form-preco-custom, OUTPUT TABLE RowErrors).
                IF CAN-FIND(FIRST RowErrors) THEN 
                    ASSIGN lErro = YES.
            END.    
        END.
        ELSE DO:
            /** Retorna a temp-table rowErrors com os erros da transa?’o **/
            RUN getRowErrors IN h-boin00972 (OUTPUT TABLE RowErrors).
            IF CAN-FIND(FIRST RowErrors) THEN 
                ASSIGN lErro = YES.           
        END.
        
        IF lErro THEN DO:
            /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="Yes"}
            {method/showmessage.i3}

            {&OPEN-QUERY-brRegras}

            RETURN "NOK":U.
        END.        
    END.
    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piHabilitarBotao wWindow 
PROCEDURE piHabilitarBotao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    ASSIGN btMarcar:SENSITIVE    IN FRAME fPage0 = tt-regra-form-preco-custom.checksum = ""  AND AVAIL tt-regra-form-preco-custom
           btDesmarcar:SENSITIVE IN FRAME fPage0 = tt-regra-form-preco-custom.checksum = "*" AND AVAIL tt-regra-form-preco-custom
           btConfirmar:SENSITIVE IN FRAME fPage0 = CAN-FIND(FIRST tt-regra-form-preco-custom WHERE tt-regra-form-preco-custom.checksum = "*").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMarcarDesmarcar wWindow 
PROCEDURE piMarcarDesmarcar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF AVAIL tt-regra-form-preco-custom THEN DO:

        ASSIGN tt-regra-form-preco-custom.checkSum = IF tt-regra-form-preco-custom.checksum = "" THEN "*" ELSE "".
    
        brRegras:SELECT-FOCUSED-ROW() IN FRAME fPage0.
    
        DISP tt-regra-form-preco-custom.checkSum WITH BROWSE brRegras.

    END.

    RUN piHabilitarBotao IN THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescAbrangen wWindow 
FUNCTION fnDescAbrangen RETURNS CHARACTER
  ( iCdnAbrangen AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/  

  RETURN {ininc/i01in00972.i 04 iCdnAbrangen}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem wWindow 
FUNCTION fnDescItem RETURNS CHARACTER
  ( cItCodigo AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-descricao LIKE item.desc-item NO-UNDO.

    RUN goToKey in h-boin172 (INPUT cItCodigo).
    IF RETURN-VALUE = "Ok" then
        RUN getCharField in h-boin172 (INPUT "desc-item":U, OUTPUT c-descricao).

    RETURN c-descricao.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescTipo wWindow 
FUNCTION fnDescTipo RETURNS CHARACTER
  ( iCdnTipo AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN {ininc/i02in00972.i 04 iCdnTipo}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnFormataColunaChar wWindow 
FUNCTION fnFormataColunaChar RETURNS CHARACTER
  ( cCampo AS CHARACTER, iCdnAbrangen AS INTEGER, cValor AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEF VAR cReturn AS CHARACTER NO-UNDO.

    CASE iCdnAbrangen:
        WHEN 1 THEN ASSIGN cReturn = IF cCampo = 'cod-pto-coleta':U   THEN cValor ELSE "*".
        WHEN 2 THEN ASSIGN cReturn = IF cCampo = 'cdn-produt-rural':U THEN cValor ELSE "*".
        WHEN 3 THEN ASSIGN cReturn = IF cCampo = 'cdn-grp-produt':U   THEN cValor ELSE "*".
        WHEN 4 THEN ASSIGN cReturn = IF cCampo = 'cod-rota':U         THEN cValor ELSE "*".
        WHEN 5 THEN ASSIGN cReturn = IF cCampo = 'cod-regiao':U       THEN cValor ELSE "*". 
        WHEN 6 THEN ASSIGN cReturn = IF cCampo = 'cod-estabel':U      THEN cValor ELSE "*".
        OTHERWISE cReturn = "*".
    END CASE.
    
    RETURN cReturn.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnFormataColunaInt wWindow 
FUNCTION fnFormataColunaInt RETURNS CHARACTER
  ( cCampo AS CHARACTER, iCdnAbrangen AS INTEGER, iValor AS INT) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEF VAR cReturn AS CHARACTER NO-UNDO.

    CASE iCdnAbrangen:
        WHEN 1 THEN ASSIGN cReturn =  IF cCampo = 'cod-pto-coleta':U  THEN STRING(iValor) ELSE "*".
        WHEN 2 THEN ASSIGN cReturn = IF cCampo = 'cdn-produt-rural':U THEN STRING(iValor) ELSE "*".
        WHEN 3 THEN ASSIGN cReturn = IF cCampo = 'cdn-grp-produt':U   THEN STRING(iValor) ELSE "*".
        WHEN 4 THEN ASSIGN cReturn = IF cCampo = 'cod-rota':U         THEN STRING(iValor) ELSE "*".
        WHEN 5 THEN ASSIGN cReturn = IF cCampo = 'cod-regiao':U       THEN STRING(iValor) ELSE "*".
        WHEN 6 THEN ASSIGN cReturn = IF cCampo = 'cod-estabel':U      THEN STRING(iValor) ELSE "*".
        OTHERWISE cReturn = "*".
    END CASE.
    
    RETURN cReturn.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

