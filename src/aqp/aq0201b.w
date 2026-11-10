&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-regra-form-preco NO-UNDO LIKE regra-form-preco
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0201B 2.00.00.013 } /*** "010013" 03/03/2025 09:11:42  ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aq0201b MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        aq0201b 
&GLOBAL-DEFINE Version        2.00.00.013

&GLOBAL-DEFINE WindowType     master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Regra ,Narrativa 

&GLOBAL-DEFINE page0Widgets   btOK btCancel btSalvar btHelp2
&GLOBAL-DEFINE page1Widgets   cb-abrangencia~
                              rs-regra-aplicacao~
                              cb-tipo-regra~
                              cb-item ~
                              fi-cdn-produt-rural~
                              IMAGE-3~
                              IMAGE-4~
                              IMAGE-5~
                              IMAGE-6
                            
&GLOBAL-DEFINE page2Widgets  ed-narrativa  

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE iCdnSeq AS INTEGER     NO-UNDO.
DEFINE VARIABLE lUpdate AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-list  AS CHARACTER   NO-UNDO.


/* Local Variable Definitions (DBOs Handles) --- */

/* Zoom Smart */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa    AS HANDLE      NO-UNDO.

DEFINE VARIABLE h-boin172na   AS HANDLE NO-UNDO.  /* item              */
DEFINE VARIABLE h-boad107na  AS HANDLE NO-UNDO.  /* estabelec         */
DEFINE VARIABLE h-boin00962  AS HANDLE NO-UNDO.  /* produt-rural      */
DEFINE VARIABLE h-boin00963  AS HANDLE NO-UNDO.  /* grp-produt        */
DEFINE VARIABLE h-boin00966  AS HANDLE NO-UNDO.  /* pto-coleta        */
DEFINE VARIABLE h-boin00972  AS HANDLE NO-UNDO.  /* regra-form-preco  */
DEFINE VARIABLE h-boin00975  AS HANDLE NO-UNDO.  /* rota-coleta       */
DEFINE VARIABLE h-boin00977  AS HANDLE NO-UNDO.  /* regiao-abrangen   */
DEFINE VARIABLE h-boin637    AS HANDLE NO-UNDO.  /* it-comp-exame     */
DEFINE VARIABLE h-boin00980  AS HANDLE NO-UNDO.  /* propried-rural    */
DEFINE VARIABLE h-boin00983  AS HANDLE NO-UNDO.  /* item-estab-rural   */
DEFINE VARIABLE h-boin627    AS HANDLE NO-UNDO.  /* item-estab-rural   */



{utp/ut-glob.i}

DEFINE INPUT PARAMETER pr-rowid   AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcItCodigo AS CHARACTER NO-UNDO.

{cdp/cd0031.i} /* seguranca por estabelecimento */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btSalvar btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnVigencia wWindow 
FUNCTION fnVigencia RETURNS DATE
  ( i AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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

DEFINE BUTTON btSalvar 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE cb-abrangencia AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 1 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEM-PAIRS "Ponto Coleta",1,
                     "Propriedade",2,
                     "Produtor",3,
                     "Grupo",4,
                     "Rota",5,
                     "Regi∆o",6,
                     "Estabelecimento",7,
                     "Todos",8
     DROP-DOWN-LIST
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE cb-item AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-regra AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 1 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEM-PAIRS "Preáo Base",1,
                     "Variaá∆o Qualidade",2,
                     "Variaá∆o Volume",3,
                     "Bìnus Fixo",4
     DROP-DOWN-LIST
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cdn-grp-produt AS CHARACTER FORMAT "X(6)" 
     LABEL "Grupo" 
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .88.

DEFINE VARIABLE fi-cdn-produt-rural AS CHARACTER FORMAT "x(9)":U 
     LABEL "Produtor" 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-des-grp-produt AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-des-pto-coleta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-des-rota AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-comp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 62 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-exame AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 62 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-grp-produtor AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-propried AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nom-regiao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.43 BY .88 NO-UNDO.

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

DEFINE VARIABLE rs-regra-aplicacao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Aplicar ao total", 1,
"Aplicar somente ao excedente", 2
     SIZE 40 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.14 BY 6.58.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.14 BY 1.33.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.14 BY 2.42.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.14 BY 2.5.

DEFINE VARIABLE ed-narrativa AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
     SIZE 80 BY 7.75 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 21.5 COL 2
     btSalvar AT ROW 21.5 COL 12.57
     btCancel AT ROW 21.5 COL 23.14
     btHelp2 AT ROW 21.5 COL 80
     rtToolBar AT ROW 21.29 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 21.83
         FONT 1.

DEFINE FRAME fPage2
     ed-narrativa AT ROW 1.75 COL 3 NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 84.43 BY 18.46
         FONT 1.

DEFINE FRAME fPage1
     tt-regra-form-preco.cod-regra AT ROW 1.21 COL 7.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 27 BY .88
     tt-regra-form-preco.descricao AT ROW 1.21 COL 34.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 45 BY .88
     tt-regra-form-preco.cdn-seq AT ROW 2.21 COL 7.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.14 BY .88
     cb-tipo-regra AT ROW 3.21 COL 7.72 COLON-ALIGNED
     cb-item AT ROW 4.25 COL 7.72 COLON-ALIGNED
     c-desc-item AT ROW 4.25 COL 26 COLON-ALIGNED NO-LABEL
     tt-regra-form-preco.dat-inic AT ROW 5.67 COL 21.72 COLON-ALIGNED
          LABEL "Data"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-regra-form-preco.dat-fim AT ROW 5.67 COL 47.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     cb-abrangencia AT ROW 7.5 COL 7.14 COLON-ALIGNED NO-LABEL
     tt-regra-form-preco.cod-pto-coleta AT ROW 8.5 COL 7.29 COLON-ALIGNED
          LABEL "Pto Coleta"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     fi-des-pto-coleta AT ROW 8.5 COL 20.43 COLON-ALIGNED NO-LABEL
     tt-regra-form-preco.cod-propried AT ROW 9.5 COL 7.29 COLON-ALIGNED
          LABEL "Propried"
          VIEW-AS FILL-IN 
          SIZE 16.57 BY .88
     fi-desc-propried AT ROW 9.5 COL 24 COLON-ALIGNED NO-LABEL
     fi-cdn-produt-rural AT ROW 10.5 COL 7.29 COLON-ALIGNED
     fi-desc-grp-produtor AT ROW 10.5 COL 17 COLON-ALIGNED NO-LABEL
     fi-cdn-grp-produt AT ROW 10.5 COL 44 COLON-ALIGNED HELP
          "C¢digo grupo"
     fi-des-grp-produt AT ROW 10.5 COL 51.72 COLON-ALIGNED NO-LABEL
     tt-regra-form-preco.cod-rota AT ROW 11.5 COL 7.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     fi-des-rota AT ROW 11.5 COL 20.43 COLON-ALIGNED NO-LABEL
     tt-regra-form-preco.cod-regiao AT ROW 11.5 COL 44 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     fi-nom-regiao AT ROW 11.5 COL 57 COLON-ALIGNED NO-LABEL
     tt-regra-form-preco.cod-estabel AT ROW 12.5 COL 7.43 COLON-ALIGNED
          LABEL "Estab"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     fi-nome-estab AT ROW 12.5 COL 14.57 COLON-ALIGNED NO-LABEL
     tt-regra-form-preco.val-faixa-inic AT ROW 14.38 COL 21.72 COLON-ALIGNED
          LABEL "Faixa"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-regra-form-preco.val-faixa-fim AT ROW 14.38 COL 47.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-regra-form-preco.val-unit AT ROW 15.38 COL 21.72 COLON-ALIGNED
          LABEL "Valor Unit"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     rs-regra-aplicacao AT ROW 15.42 COL 39.29 NO-LABEL
     tt-regra-form-preco.cod-exame AT ROW 17.29 COL 7.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     fi-desc-exame AT ROW 17.29 COL 18 COLON-ALIGNED NO-LABEL
     tt-regra-form-preco.cod-comp AT ROW 18.25 COL 7.72 COLON-ALIGNED
          LABEL "Comp"
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     fi-desc-comp AT ROW 18.25 COL 18 COLON-ALIGNED NO-LABEL
     "Controle de Qualidade" VIEW-AS TEXT
          SIZE 15.14 BY .54 AT ROW 16.63 COL 4
     "Valores" VIEW-AS TEXT
          SIZE 4.86 BY .54 AT ROW 13.83 COL 4.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.54
         SIZE 84.43 BY 18.46
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage1
     "Abrangància" VIEW-AS TEXT
          SIZE 8.86 BY .54 AT ROW 6.88 COL 4
     "Vigància" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 5.21 COL 4
     RECT-2 AT ROW 7.17 COL 1
     RECT-3 AT ROW 5.42 COL 1
     RECT-4 AT ROW 14.08 COL 1
     RECT-6 AT ROW 16.88 COL 1
     IMAGE-3 AT ROW 14.38 COL 36.86
     IMAGE-4 AT ROW 14.38 COL 46.86
     IMAGE-5 AT ROW 5.67 COL 36.86
     IMAGE-6 AT ROW 5.67 COL 46.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.54
         SIZE 84.43 BY 18.46
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-regra-form-preco T "?" NO-UNDO mgind regra-form-preco
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 21.83
         WIDTH              = 90
         MAX-HEIGHT         = 26.79
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 26.79
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN tt-regra-form-preco.cod-comp IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-regra-form-preco.cod-estabel IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-regra-form-preco.cod-propried IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-regra-form-preco.cod-pto-coleta IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-regra-form-preco.dat-inic IN FRAME fPage1
   EXP-LABEL                                                            */
ASSIGN 
       IMAGE-3:HIDDEN IN FRAME fPage1           = TRUE.

ASSIGN 
       IMAGE-4:HIDDEN IN FRAME fPage1           = TRUE.

ASSIGN 
       IMAGE-5:HIDDEN IN FRAME fPage1           = TRUE.

ASSIGN 
       IMAGE-6:HIDDEN IN FRAME fPage1           = TRUE.

/* SETTINGS FOR FILL-IN tt-regra-form-preco.val-faixa-fim IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-regra-form-preco.val-faixa-inic IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-regra-form-preco.val-unit IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage2
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN 'NOK':U.
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
    RUN piSaveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = 'OK' THEN DO:
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN RETURN-VALUE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSalvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSalvar wWindow
ON CHOOSE OF btSalvar IN FRAME fpage0 /* Salvar */
DO:                                   
    RUN piSaveRecord   IN THIS-PROCEDURE.
    IF RETURN-VALUE <> 'OK' THEN
        RETURN NO-APPLY.

    RUN piLimparCampos IN THIS-PROCEDURE.
    APPLY 'ENTRY' TO tt-regra-form-preco.cod-regra IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME cb-abrangencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-abrangencia wWindow
ON VALUE-CHANGED OF cb-abrangencia IN FRAME fPage1
DO:
    RUN piHabilitaCamposAbrangencia IN THIS-PROCEDURE(INPUT INT(SELF:SCREEN-VALUE)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-item wWindow
ON VALUE-CHANGED OF cb-item IN FRAME fPage1 /* Item */
DO: 
    DEFINE VARIABLE pDescItem    AS CHARACTER NO-UNDO.

    RUN goToKey IN h-boin172na (INPUT SELF:SCREEN-VALUE IN FRAME fPage1) NO-ERROR.

    IF RETURN-VALUE = "OK":U THEN DO:
        RUN findDescItem IN h-boin00983 (INPUT SELF:SCREEN-VALUE IN FRAME fPage1, OUTPUT pDescItem) NO-ERROR. 
        ASSIGN c-desc-item:SCREEN-VALUE IN FRAME fPage1 = pDescItem.                                          
    END.
    
    IF cb-abrangencia:SCREEN-VALUE IN FRAME fPage1 = "7"  THEN
        APPLY 'LEAVE' TO tt-regra-form-preco.cod-estabel IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-tipo-regra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-regra wWindow
ON VALUE-CHANGED OF cb-tipo-regra IN FRAME fPage1 /* Tipo */
DO:
    RUN piHabiltaCamposTipoRegra IN THIS-PROCEDURE(INPUT INT(SELF:SCREEN-VALUE)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-regra-form-preco.cod-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-comp wWindow
ON ENTRY OF tt-regra-form-preco.cod-comp IN FRAME fPage1 /* Comp */
DO:
    IF INT(SELF:SCREEN-VALUE) <> 0 THEN DO:
        APPLY 'LEAVE' TO SELF.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-comp wWindow
ON F5 OF tt-regra-form-preco.cod-comp IN FRAME fPage1 /* Comp */
DO:

{method/ZoomFields.i &ProgramZoom="inzoom/z01in637.w"
                         &FieldZoom1="cod-comp"
                         &FieldScreen1="tt-regra-form-preco.cod-comp"
                         &Frame1="fPage1"
                         &RunMethod="RUN setParams IN hProgramZoom (INPUT cb-item:screen-value, INPUT INT(tt-regra-form-preco.cod-exame:screen-value))."
                         &EnableImplant="YES"}



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-comp wWindow
ON LEAVE OF tt-regra-form-preco.cod-comp IN FRAME fPage1 /* Comp */
DO:                                                  
    DEFINE VARIABLE cDescComp AS CHARACTER   NO-UNDO.

    RUN gotokey IN h-boin637(INPUT cb-item:SCREEN-VALUE, 
                             INPUT INT(tt-regra-form-preco.cod-exame:SCREEN-VALUE), 
                             INPUT INT(tt-regra-form-preco.cod-comp:SCREEN-VALUE)).

    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getCharField IN h-boin637(INPUT 'descricao', OUTPUT cDescComp).
        ASSIGN fi-desc-comp:SCREEN-VALUE IN FRAME fPage1 = cDescComp.
    END.
    ELSE
        ASSIGN fi-desc-comp:SCREEN-VALUE IN FRAME fPage1 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-comp wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-regra-form-preco.cod-comp IN FRAME fPage1 /* Comp */
DO:
    APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-regra-form-preco.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-estabel wWindow
ON ENTRY OF tt-regra-form-preco.cod-estabel IN FRAME fPage1 /* Estab */
DO:
   APPLY 'LEAVE':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-estabel wWindow
ON F5 OF tt-regra-form-preco.cod-estabel IN FRAME fPage1 /* Estab */
DO:
   {method/zoomfields.i 
       &ProgramZoom="inzoom/z01in00983.w"
       &FieldZoom1="cod-estabel"
       &FieldScreen1="tt-regra-form-preco.cod-estabel"
       &Frame1="fPage1"
       &RunMethod="RUN setParams IN hProgramZoom (INPUT cb-item:screen-value)."
       &EnableImplant="YES"}                               
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-estabel wWindow
ON LEAVE OF tt-regra-form-preco.cod-estabel IN FRAME fPage1 /* Estab */
DO:
   
    IF VALID-HANDLE(h-boin00983) THEN DO:
        RUN goToKey IN h-boin00983(INPUT cb-item:SCREEN-VALUE, INPUT SELF:SCREEN-VALUE).
        IF RETURN-VALUE = "OK":U THEN DO:
            {method/ReferenceFields.i &HandleDBOLeave="h-boad107na"
                                      &KeyValue1="tt-regra-form-preco.cod-estabel:SCREEN-VALUE IN FRAME fPage1"
                                      &FieldName1="nome"
                                      &FieldScreen1="fi-nome-estab"
                                      &Frame1="fPage1"}
        END.
        ELSE 
            ASSIGN fi-nome-estab:SCREEN-VALUE IN FRAME fPage1 = "".       
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-estabel wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-regra-form-preco.cod-estabel IN FRAME fPage1 /* Estab */
DO:
   APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-regra-form-preco.cod-exame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-exame wWindow
ON ENTRY OF tt-regra-form-preco.cod-exame IN FRAME fPage1 /* Exame */
DO:
    IF INT(SELF:SCREEN-VALUE) <> 0 THEN DO:
        APPLY 'LEAVE':U TO SELF.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-exame wWindow
ON F5 OF tt-regra-form-preco.cod-exame IN FRAME fPage1 /* Exame */
DO:
    ASSIGN l-implanta = yes.  
    {include/zoomvar.i  &prog-zoom="inzoom/z01in164.w"
                        &campo=tt-regra-form-preco.cod-exame
                        &campozoom=cod-exame
                        &parametros="run pi-seta-inicial in wh-pesquisa (INPUT cb-item:SCREEN-VALUE)."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-exame wWindow
ON LEAVE OF tt-regra-form-preco.cod-exame IN FRAME fPage1 /* Exame */
DO:
        
    {include/leave.i &tabela=it-exame
                   &atributo-ref=descricao
                   &variavel-ref=fi-desc-exame
                   &where="it-exame.cod-exame = INT(tt-regra-form-preco.cod-exame:SCREEN-VALUE)AND it-exame.it-codigo = cb-item:SCREEN-VALUE"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-exame wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-regra-form-preco.cod-exame IN FRAME fPage1 /* Exame */
DO:
  APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-regra-form-preco.cod-propried
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-propried wWindow
ON LEAVE OF tt-regra-form-preco.cod-propried IN FRAME fPage1 /* Propried */
DO:
   {method/ReferenceFields.i 
          &HandleDBOLeave="h-boin00980"
          &KeyValue1="tt-regra-form-preco.cod-propried:SCREEN-VALUE IN FRAME fPage1"
          &FieldName1="des-propried"
          &FieldScreen1="fi-desc-propried"
          &Frame1="fPage1"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-propried wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-regra-form-preco.cod-propried IN FRAME fPage1 /* Propried */
OR 'F5' OF tt-regra-form-preco.cod-propried IN FRAME fPage1 DO:
   {method/zoomfields.i 
       &ProgramZoom="inzoom/z01in00980.w"
       &FieldZoom1="cod-propried"
       &FieldScreen1="tt-regra-form-preco.cod-propried"
       &Frame1="fPage1"
       &FieldZoom2="des-propried"
       &FieldScreen2="fi-desc-propried"
       &Frame2="fPage1"
       &EnableImplant="YES"} 
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-regra-form-preco.cod-pto-coleta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-pto-coleta wWindow
ON F5 OF tt-regra-form-preco.cod-pto-coleta IN FRAME fPage1 /* Pto Coleta */
DO:
    {method/zoomfields.i 
       &ProgramZoom="inzoom/z01in00966.w"
       &FieldZoom1="cod-pto-coleta"
       &FieldScreen1="tt-regra-form-preco.cod-pto-coleta"
       &Frame1="fPage1"
       &FieldZoom2="des-pto-coleta"
       &FieldScreen2="fi-des-pto-coleta"
       &Frame2="fPage1"
       &EnableImplant="YES"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-pto-coleta wWindow
ON LEAVE OF tt-regra-form-preco.cod-pto-coleta IN FRAME fPage1 /* Pto Coleta */
DO:    
     {method/ReferenceFields.i 
          &HandleDBOLeave="h-boin00966"
          &KeyValue1="tt-regra-form-preco.cod-pto-coleta:SCREEN-VALUE IN FRAME fPage1"
          &FieldName1="des-pto-coleta"
          &FieldScreen1="fi-des-pto-coleta"
          &Frame1="fPage1"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-pto-coleta wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-regra-form-preco.cod-pto-coleta IN FRAME fPage1 /* Pto Coleta */
DO:
  APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-regra-form-preco.cod-regiao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-regiao wWindow
ON F5 OF tt-regra-form-preco.cod-regiao IN FRAME fPage1 /* Regi∆o */
DO:
    {method/zoomfields.i 
           &ProgramZoom="inzoom/z01in00977.w"
           &FieldZoom1="cod-regiao"
           &FieldScreen1="tt-regra-form-preco.cod-regiao"
           &Frame1="fPage1"
           &FieldZoom2="nom-regiao"
           &FieldScreen2="fi-nom-regiao"
           &Frame2="fPage1"
           &EnableImplant="YES"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-regiao wWindow
ON LEAVE OF tt-regra-form-preco.cod-regiao IN FRAME fPage1 /* Regi∆o */
DO:
  
  {method/ReferenceFields.i 
              &HandleDBOLeave="h-boin00977"
              &KeyValue1="tt-regra-form-preco.cod-regiao:SCREEN-VALUE IN FRAME fPage1"
              &FieldName1="nom-regiao"
              &FieldScreen1="fi-nom-regiao"
              &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-regiao wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-regra-form-preco.cod-regiao IN FRAME fPage1 /* Regi∆o */
DO:
  APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-regra-form-preco.cod-regra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-regra wWindow
ON LEAVE OF tt-regra-form-preco.cod-regra IN FRAME fPage1 /* Regra */
DO: 
    RUN getSequenceByCodRegra IN h-boin00972 (INPUT SELF:SCREEN-VALUE, OUTPUT iCdnSeq).

    ASSIGN tt-regra-form-preco.cdn-seq:SCREEN-VALUE IN FRAME fPage1 = STRING(iCdnSeq).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-regra-form-preco.cod-rota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-rota wWindow
ON F5 OF tt-regra-form-preco.cod-rota IN FRAME fPage1 /* Rota */
DO:
    {method/zoomfields.i 
           &ProgramZoom="inzoom/z01in00975.w"
           &FieldZoom1="cod-rota"
           &FieldScreen1="tt-regra-form-preco.cod-rota"
           &Frame1="fPage1"
           &FieldZoom2="des-rota"
           &FieldScreen2="fi-des-rota"
           &Frame2="fPage1"
           &EnableImplant="YES"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-rota wWindow
ON LEAVE OF tt-regra-form-preco.cod-rota IN FRAME fPage1 /* Rota */
DO:
       {method/ReferenceFields.i 
              &HandleDBOLeave="h-boin00975"
              &KeyValue1="tt-regra-form-preco.cod-rota:SCREEN-VALUE IN FRAME fPage1"
              &FieldName1="des-rota"
              &FieldScreen1="fi-des-rota"
              &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-regra-form-preco.cod-rota wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-regra-form-preco.cod-rota IN FRAME fPage1 /* Rota */
DO:
  APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cdn-grp-produt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cdn-grp-produt wWindow
ON F5 OF fi-cdn-grp-produt IN FRAME fPage1 /* Grupo */
DO:
      {method/zoomfields.i 
           &ProgramZoom="inzoom/z01in00963.w"
           &FieldZoom1="cdn-grp-produt"
           &FieldScreen1="fi-cdn-grp-produt"
           &Frame1="fPage1"
           &FieldZoom2="des-grp-produt"
           &FieldScreen2="fi-des-grp-produt"
           &Frame2="fPage1"
           &EnableImplant="YES"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cdn-grp-produt wWindow
ON LEAVE OF fi-cdn-grp-produt IN FRAME fPage1 /* Grupo */
DO:

   DEFINE VARIABLE i-cdn-grp-rural AS INTEGER     NO-UNDO.

   ASSIGN i-cdn-grp-rural = INT(SELF:SCREEN-VALUE IN FRAME fPage1) NO-ERROR.
   IF ERROR-STATUS:ERROR THEN 
       ASSIGN i-cdn-grp-rural = 0.

  {method/ReferenceFields.i &HandleDBOLeave="h-boin00963"
                              &KeyValue1="i-cdn-grp-rural"
                              &FieldName1="des-grp-produt"
                              &FieldScreen1="fi-des-grp-produt"
                              &Frame1="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cdn-grp-produt wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cdn-grp-produt IN FRAME fPage1 /* Grupo */
DO:
  APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cdn-produt-rural
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cdn-produt-rural wWindow
ON ENTRY OF fi-cdn-produt-rural IN FRAME fPage1 /* Produtor */
DO:
    DEFINE VARIABLE i-cdn-produt-rural AS INTEGER     NO-UNDO.
    ASSIGN i-cdn-produt-rural = INT(SELF:SCREEN-VALUE IN FRAME fPage1) NO-ERROR.
    IF NOT ERROR-STATUS:ERROR THEN
        IF INT(SELF:SCREEN-VALUE) <> 0 THEN DO:
            APPLY 'LEAVE':U TO SELF.
        END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cdn-produt-rural wWindow
ON F5 OF fi-cdn-produt-rural IN FRAME fPage1 /* Produtor */
DO:
   {method/zoomfields.i 
           &ProgramZoom="inzoom/z01in00962.w"
           &FieldZoom1="cdn-produt-rural"
           &FieldScreen1="fi-cdn-produt-rural"
           &Frame1="fPage1"
           &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cdn-produt-rural wWindow
ON LEAVE OF fi-cdn-produt-rural IN FRAME fPage1 /* Produtor */
DO:
    DEFINE VARIABLE c-nome-abrev LIKE emitente.nome-abrev NO-UNDO.
    DEFINE VARIABLE c-return           AS CHARACTER NO-UNDO.
    DEFINE VARIABLE h-boad098          AS HANDLE    NO-UNDO.    
    DEFINE VARIABLE i-cdn-produt-rural AS INTEGER     NO-UNDO.
   
    IF VALID-HANDLE(h-boin00962) THEN DO:
                                         
        ASSIGN i-cdn-produt-rural = INT(SELF:SCREEN-VALUE IN FRAME fPage1) NO-ERROR.
        ASSIGN fi-desc-grp-produtor:SCREEN-VALUE = "".

        IF NOT ERROR-STATUS:ERROR THEN DO:
            RUN goToKey IN h-boin00962(INPUT i-cdn-produt-rural).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN adbo/boad098.p PERSISTENT SET h-boad098.        
                RUN findCodigo IN h-boad098(INPUT i-cdn-produt-rural, OUTPUT c-return).
                IF c-return = "" THEN DO:
                    RUN getCharfield in h-boad098(INPUT "nome-abrev":U, OUTPUT c-nome-abrev).
                END.
                DELETE PROCEDURE h-boad098.
            END.
        END.
        ASSIGN fi-desc-grp-produtor:SCREEN-VALUE = c-nome-abrev.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cdn-produt-rural wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cdn-produt-rural IN FRAME fPage1 /* Produtor */
DO:
  APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

/*--- Seta cursor do mouse para lupa, quando estiver posicionado
      sobre o fill-in ---*/
tt-regra-form-preco.cod-regiao:LOAD-MOUSE-POINTER("image/lupa.cur":U)    IN FRAME fPage1.
tt-regra-form-preco.cod-exame:LOAD-MOUSE-POINTER("image/lupa.cur":U)     IN FRAME fPage1.
tt-regra-form-preco.cod-comp:LOAD-MOUSE-POINTER("image/lupa.cur":U)      IN FRAME fPage1.
tt-regra-form-preco.cod-rota:LOAD-MOUSE-POINTER("image/lupa.cur":U)      IN FRAME fPage1.
tt-regra-form-preco.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPage1.
tt-regra-form-preco.cod-pto-coleta:LOAD-MOUSE-POINTER("image/lupa.cur":U)IN FRAME fPage1.
fi-cdn-produt-rural:LOAD-MOUSE-POINTER("image/lupa.cur":U)               IN FRAME fPage1.
fi-cdn-grp-produt:LOAD-MOUSE-POINTER("image/lupa.cur":U)                 IN FRAME fPage1.
tt-regra-form-preco.cod-propried:LOAD-MOUSE-POINTER("image/lupa.cur":U)                   IN FRAME fPage1.


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
    IF VALID-HANDLE (h-boin172na) THEN DO:
        DELETE PROCEDURE h-boin172na.
        ASSIGN h-boin172na = ?.
    END.
    
    /* regra-form-preco  */
    IF VALID-HANDLE (h-boin00972) THEN DO:
        DELETE PROCEDURE h-boin00972.
        ASSIGN h-boin00972 = ?.
    END.
    
    /* regiao-abrangen   */ 
    IF VALID-HANDLE (h-boin00977) THEN DO: 
        DELETE PROCEDURE h-boin00977 .
        ASSIGN h-boin00977 = ?.
    END.

    /* pto-coleta   */ 
    IF VALID-HANDLE (h-boin00966) THEN DO: 
        DELETE PROCEDURE h-boin00966 .
        ASSIGN h-boin00966 = ?.
    END.

    /* rota-coleta   */ 
    IF VALID-HANDLE (h-boin00975) THEN DO: 
        DELETE PROCEDURE h-boin00975 .
        ASSIGN h-boin00966 = ?.
    END.

    /* grp-produt   */ 
    IF VALID-HANDLE (h-boin00963) THEN DO: 
        DELETE PROCEDURE h-boin00963 .
        ASSIGN h-boin00963 = ?.
    END.

    /* produt-rural   */ 
    IF VALID-HANDLE (h-boin00962) THEN DO: 
        DELETE PROCEDURE h-boin00962 .
        ASSIGN h-boin00962= ?.
    END.

    /** Estabelec **/
    IF  VALID-HANDLE(h-boad107na) THEN DO:
        DELETE PROCEDURE h-boad107na.
        ASSIGN h-boad107na = ?.
    END. 
    
    /** it-comp-exame**/
    IF  VALID-HANDLE(h-boin637) THEN DO:
        DELETE PROCEDURE h-boin637.
        ASSIGN h-boin637 = ?.
    END.

    /** propried-rural**/
    IF  VALID-HANDLE(h-boin00980) THEN DO:
        DELETE PROCEDURE h-boin00980.
        ASSIGN h-boin00980 = ?.
    END.

    /** item-estab-rural **/
    IF  VALID-HANDLE(h-boin00983) THEN DO:
        DELETE PROCEDURE h-boin00983.
        ASSIGN h-boin00983 = ?.
    END.

    /** uaur-mater **/
    IF  VALID-HANDLE(h-boin627) THEN DO:
        DELETE PROCEDURE h-boin627.
        ASSIGN h-boin627 = ?.
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
    DEFINE VARIABLE c-return         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE lDesabilitaValor AS LOGICAL NO-UNDO.

    RUN initializeDBOs IN THIS-PROCEDURE.
    ASSIGN lUpdate = pr-rowid <> ?.

    RUN findUsuar_mater IN h-boin627 (INPUT c-seg-usuario, OUTPUT c-return).
    IF c-return = "" THEN DO:
        RUN getCharField IN h-boin627 (INPUT 'char-1', OUTPUT c-return).
         ASSIGN c-return = SUBSTR(c-return,16,5). /* estab usuar */
    END.

    RUN getListItems IN h-boin00983(INPUT c-return, OUTPUT c-list).
    IF c-list <> "" THEN DO:
        ASSIGN cb-item:LIST-ITEMS IN FRAME fPage1   = c-list
               cb-item:SCREEN-VALUE IN FRAME fPage1 = ENTRY (1,c-list).
    END.

    /* Atualiza campos de tela com valores passados por parametro */
    IF lUpdate THEN DO:
       DISABLE tt-regra-form-preco.cod-regra WITH FRAME fPage1.
       RUN repositionRecord IN h-boin00972 (INPUT pr-rowid).
       IF RETURN-VALUE = 'OK' THEN
           RUN getRecord IN h-boin00972 (OUTPUT TABLE tt-regra-form-preco).

       FIND FIRST tt-regra-form-preco 
            WHERE tt-regra-form-preco.r-rowid = pr-rowid NO-LOCK NO-ERROR.

       IF AVAIL tt-regra-form-preco THEN DO:
           ASSIGN tt-regra-form-preco.cod-regra:SCREEN-VALUE      IN FRAME fPage1 = tt-regra-form-preco.cod-regra        
                  tt-regra-form-preco.cdn-seq:SCREEN-VALUE        IN FRAME fPage1 = STRING(tt-regra-form-preco.cdn-seq)          
                  cb-tipo-regra:SCREEN-VALUE                      IN FRAME fPage1 = STRING(tt-regra-form-preco.cdn-tipo)         
                  tt-regra-form-preco.descricao:SCREEN-VALUE      IN FRAME fPage1 = tt-regra-form-preco.descricao        
                  cb-item:SCREEN-VALUE                            IN FRAME fPage1 = tt-regra-form-preco.it-codigo        
                  tt-regra-form-preco.dat-inic:SCREEN-VALUE       IN FRAME fPage1 = STRING(tt-regra-form-preco.dat-inic)
                  cb-abrangencia:SCREEN-VALUE                     IN FRAME fPage1 = STRING(tt-regra-form-preco.cdn-abrangen)
                  tt-regra-form-preco.dat-fim:SCREEN-VALUE        IN FRAME fPage1 = STRING(tt-regra-form-preco.dat-fim)          
                  tt-regra-form-preco.val-unit:SCREEN-VALUE       IN FRAME fPage1 = STRING(tt-regra-form-preco.val-unit)                
                  tt-regra-form-preco.cod-exame:SCREEN-VALUE      IN FRAME fPage1 = STRING(tt-regra-form-preco.cod-exame) 
                  tt-regra-form-preco.cod-comp:SCREEN-VALUE       IN FRAME fPage1 = STRING(tt-regra-form-preco.cod-comp)
                  rs-regra-aplicacao:SCREEN-VALUE                 IN FRAME fPage1 = STRING(tt-regra-form-preco.cdn-aplic) 
                  tt-regra-form-preco.val-faixa-inic:SCREEN-VALUE IN FRAME fPage1 = STRING(tt-regra-form-preco.val-faixa-inic) 
                  tt-regra-form-preco.val-faixa-fim:SCREEN-VALUE  IN FRAME fPage1 = STRING(tt-regra-form-preco.val-faixa-fim) 
                  ed-narrativa:SCREEN-VALUE                       IN FRAME fPage2 = STRING(tt-regra-form-preco.des-narrat).

            RUN DesabilitaValUnit IN h-boin00972 (OUTPUT lDesabilitaValor).
       END.
    END.
    ELSE DO:
        ENABLE tt-regra-form-preco.cod-regra WITH FRAME fPage1.
        ASSIGN tt-regra-form-preco.val-unit:SCREEN-VALUE       IN FRAME fPage1 = '0'
               tt-regra-form-preco.val-faixa-inic:SCREEN-VALUE IN FRAME fPage1 = '0'
               tt-regra-form-preco.val-faixa-fim:SCREEN-VALUE  IN FRAME fPage1 = '0'
               tt-regra-form-preco.dat-inic:SCREEN-VALUE       IN FRAME fPage1 = STRING(fnVigencia(1))
               tt-regra-form-preco.dat-fim:SCREEN-VALUE        IN FRAME fPage1 = STRING(fnVigencia(2))
               tt-regra-form-preco.cod-exame:SCREEN-VALUE      IN FRAME fPage1 = '0'
               tt-regra-form-preco.cod-comp:SCREEN-VALUE       IN FRAME fPage1 = '0'
               cb-item:SCREEN-VALUE                            IN FRAME fPage1 = pcItCodigo.
    END.

    APPLY 'VALUE-CHANGED':U TO cb-item IN FRAME fPage1. 

    IF NOT lUpdate THEN DO:
        ENABLE tt-regra-form-preco.cod-estabel WITH FRAME fPage1. 
    END.

    ENABLE tt-regra-form-preco.descricao
           cb-item
           tt-regra-form-preco.dat-inic
           tt-regra-form-preco.dat-fim
           tt-regra-form-preco.val-unit
           WITH FRAME fPage1. 

    IF lUpdate = YES AND lDesabilitaValor = YES THEN 
      DISABLE  tt-regra-form-preco.val-unit
           WITH FRAME fPage1. 
    
    /*Aplica regra para habilitar campos conforme abrangencia*/
    APPLY 'VALUE-CHANGED':U TO cb-abrangencia IN FRAME fPage1. 
    
        
    /*Aplica regra para habilitar campos conforme tipo*/
    APPLY 'VALUE-CHANGED':U TO cb-tipo-regra IN FRAME fPage1. 

    IF lUpdate THEN
        ASSIGN btSalvar:SENSITIVE IN FRAME fPage0 = NO.

    RETURN "OK":U.
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
    /* item */ 
    IF NOT VALID-HANDLE( h-boin172na) THEN 
        RUN inbo/boin172na.p PERSISTENT SET h-boin172na.

    RUN OpenQueryStatic IN h-boin172na (INPUT "Main":U) NO-ERROR.
    
    /* regra-form-preco */ 
    IF NOT VALID-HANDLE(h-boin00972) THEN 
        RUN inbo/boin00972.p PERSISTENT SET h-boin00972.

    RUN OpenQueryStatic IN h-boin00972 (INPUT "Main":U) NO-ERROR.

    /* regiao-abrangen */ 
    IF NOT VALID-HANDLE(h-boin00977) THEN 
        RUN inbo/boin00977.p PERSISTENT SET h-boin00977.

    RUN OpenQueryStatic IN h-boin00977 (INPUT "Main":U) NO-ERROR.
   
    /* pto-coleta   */ 
    IF NOT VALID-HANDLE(h-boin00966) THEN 
        RUN inbo/boin00966.p PERSISTENT SET h-boin00966.

    RUN OpenQueryStatic IN h-boin00966 (INPUT "Main":U) NO-ERROR.

    /* rota-coleta   */ 
    IF NOT VALID-HANDLE(h-boin00975) THEN 
        RUN inbo/boin00975.p PERSISTENT SET h-boin00975.

    RUN OpenQueryStatic IN h-boin00975 (INPUT "Main":U) NO-ERROR.

    /* grp-produt   */ 
    IF NOT VALID-HANDLE(h-boin00963) THEN 
        RUN inbo/boin00963.p PERSISTENT SET h-boin00963.

    RUN OpenQueryStatic IN h-boin00963 (INPUT "Main":U) NO-ERROR.

    /* produt-rural   */ 
    IF NOT VALID-HANDLE(h-boin00962) THEN 
        RUN inbo/boin00962.p PERSISTENT SET h-boin00962.

    RUN OpenQueryStatic IN h-boin00962 (INPUT "Main":U) NO-ERROR.

    /** Estabelec **/
    IF NOT VALID-HANDLE(h-boad107na) THEN
        RUN adbo/boad107na.p PERSISTENT SET h-boad107na.

    RUN openQueryStatic IN h-boad107na (INPUT "Main":U) NO-ERROR.
    
    /** it-comp-exame **/
    IF NOT VALID-HANDLE(h-boin637) THEN
        RUN inbo/boin637.p PERSISTENT SET h-boin637.

    RUN openqueryStatic IN h-boin637(INPUT "Main") NO-ERROR.

    /** propried-rural  **/
    IF NOT VALID-HANDLE(h-boin00980) THEN
        RUN inbo/boin00980.p PERSISTENT SET h-boin00980.

    RUN openqueryStatic IN h-boin00980(INPUT "Main") NO-ERROR.

    /** item-estab-rural  **/
    IF NOT VALID-HANDLE(h-boin00983) THEN
        RUN inbo/boin00983.p PERSISTENT SET h-boin00983.

    RUN openqueryStatic IN h-boin00983(INPUT "Main") NO-ERROR.

    /** usuar-mater **/
    IF NOT VALID-HANDLE(h-boin627) THEN
        RUN inbo/boin627.p PERSISTENT SET h-boin627.

    RUN openquery IN h-boin627(INPUT 1) NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piHabilitaCamposAbrangencia wWindow 
PROCEDURE piHabilitaCamposAbrangencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
    1 - Ponto Coleta
    2-  Propriedade
    3 - Produtor   
    4 - Grupo      
    5 - Rota       
    6 - Regi∆o     
    7 - Estabelecimento
    8 - Todos           
  
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piCdnAbrangen AS INTEGER NO-UNDO.
   
    IF NOT lUpdate THEN DO:
        ASSIGN tt-regra-form-preco.cod-pto-coleta:SENSITIVE    IN FRAME fPage1 = piCdnAbrangen = 1  /* Ponto Coleta */
               tt-regra-form-preco.cod-propried:SENSITIVE      IN FRAME fPage1 = piCdnAbrangen = 2  /* Propriedade */
               fi-cdn-produt-rural:SENSITIVE                   IN FRAME fPage1 = piCdnAbrangen = 3  /* Produtor */
               fi-cdn-grp-produt:SENSITIVE                     IN FRAME fPage1 = piCdnAbrangen = 4  /* Grupo */
               tt-regra-form-preco.cod-rota:SENSITIVE          IN FRAME fPage1 = piCdnAbrangen = 5  /* Rota */ 
               tt-regra-form-preco.cod-regiao:SENSITIVE        IN FRAME fPage1 = piCdnAbrangen = 6  /* Regi∆o */
               tt-regra-form-preco.cod-estabel:SENSITIVE       IN FRAME fPage1 = piCdnAbrangen = 7  /* Estabelecimento */.
    END.
    ELSE DO:
        ASSIGN cb-abrangencia:SENSITIVE                         IN FRAME fPage1 = NO 
               tt-regra-form-preco.cod-pto-coleta:SENSITIVE     IN FRAME fPage1 = NO 
               tt-regra-form-preco.cod-propried:SENSITIVE       IN FRAME fPage1 = NO 
               fi-cdn-produt-rural:SENSITIVE                    IN FRAME fPage1 = NO 
               fi-cdn-grp-produt:SENSITIVE                      IN FRAME fPage1 = NO 
               tt-regra-form-preco.cod-rota:SENSITIVE           IN FRAME fPage1 = NO 
               tt-regra-form-preco.cod-regiao:SENSITIVE         IN FRAME fPage1 = NO 
               tt-regra-form-preco.cod-estabel:SENSITIVE        IN FRAME fPage1 = NO.
    END.

    ASSIGN tt-regra-form-preco.cod-estabel:SCREEN-VALUE    IN FRAME fPage1 = "*":U  
           tt-regra-form-preco.cod-pto-coleta:SCREEN-VALUE IN FRAME fPage1 = "*":U 
           tt-regra-form-preco.cod-propried:SCREEN-VALUE   IN FRAME fPage1 = "*":U 
           tt-regra-form-preco.cod-rota:SCREEN-VALUE       IN FRAME fPage1 = "*":U
           fi-cdn-produt-rural:SCREEN-VALUE                IN FRAME fPage1 = "*":U  
           fi-cdn-grp-produt:SCREEN-VALUE                  IN FRAME fPage1 = "*":U 
           tt-regra-form-preco.cod-regiao:SCREEN-VALUE     IN FRAME fPage1 = "*":U
           fi-des-pto-coleta:SCREEN-VALUE                  IN FRAME fPage1 = "":U
           fi-desc-grp-produtor:SCREEN-VALUE               IN FRAME fPage1 = "":U
           fi-des-grp-produt:SCREEN-VALUE                  IN FRAME fPage1 = "":U
           fi-des-rota:SCREEN-VALUE                        IN FRAME fPage1 = "":U
           fi-nom-regiao:SCREEN-VALUE                      IN FRAME fPage1 = "":U
           fi-nome-estab:SCREEN-VALUE                      IN FRAME fPage1 = "":U
           fi-desc-propried:SCREEN-VALUE                   IN FRAME fPage1 = "":U.

    CASE piCdnAbrangen:
        WHEN 1 THEN DO:
            IF lUpdate THEN DO:
                ASSIGN tt-regra-form-preco.cod-pto-coleta:SCREEN-VALUE IN FRAME fPage1 = tt-regra-form-preco.cod-pto-coleta. 
                APPLY 'LEAVE':U TO tt-regra-form-preco.cod-pto-coleta  IN FRAME fPage1.
            END.
            ELSE ASSIGN tt-regra-form-preco.cod-pto-coleta:SCREEN-VALUE IN FRAME fPage1 = "":U.            
        END.
        WHEN 2 THEN DO:
            IF lUpdate THEN DO:
                ASSIGN tt-regra-form-preco.cod-propried:SCREEN-VALUE IN FRAME fPage1 = tt-regra-form-preco.cod-propried. 
                APPLY 'LEAVE':U TO tt-regra-form-preco.cod-propried  IN FRAME fPage1.
            END.
            ELSE ASSIGN tt-regra-form-preco.cod-propried:SCREEN-VALUE IN FRAME fPage1 = "":U.            
        END.
        WHEN 3 THEN DO: 
            IF lUpdate THEN DO:
                ASSIGN fi-cdn-produt-rural:SCREEN-VALUE IN FRAME fPage1 = STRING(tt-regra-form-preco.cdn-produt-rural). 
                APPLY 'LEAVE':U TO fi-cdn-produt-rural  IN FRAME fPage1.
            END.
            ELSE ASSIGN fi-cdn-produt-rural:SCREEN-VALUE IN FRAME fPage1 = "":U.            
        END.
        WHEN 4 THEN DO: 
            IF lUpdate THEN DO:
                ASSIGN fi-cdn-grp-produt:SCREEN-VALUE IN FRAME fPage1 = STRING(tt-regra-form-preco.cdn-grp-produt). 
                APPLY 'LEAVE':U TO fi-cdn-grp-produt  IN FRAME fPage1.
            END.
            ELSE ASSIGN fi-cdn-grp-produt:SCREEN-VALUE IN FRAME fPage1 = "":U. 
        END.
        WHEN 5 THEN DO: 
            IF lUpdate THEN DO:
                ASSIGN tt-regra-form-preco.cod-rota:SCREEN-VALUE IN FRAME fPage1 = tt-regra-form-preco.cod-rota.
                APPLY 'LEAVE':U TO tt-regra-form-preco.cod-rota  IN FRAME fPage1.
            END.
            ELSE ASSIGN tt-regra-form-preco.cod-rota:SCREEN-VALUE IN FRAME fPage1 = "":U.
        END.
        WHEN 6 THEN DO:
            IF lUpdate THEN DO:
                ASSIGN tt-regra-form-preco.cod-regiao:SCREEN-VALUE IN FRAME fPage1 = tt-regra-form-preco.cod-regiao.
                APPLY 'LEAVE':U TO tt-regra-form-preco.cod-regiao  IN FRAME fPage1.
            END.
            ELSE ASSIGN tt-regra-form-preco.cod-regiao:SCREEN-VALUE IN FRAME fPage1 = "":U.
        END.
        WHEN 7 THEN DO:
             IF lUpdate THEN DO:
                ASSIGN tt-regra-form-preco.cod-estabel:SCREEN-VALUE IN FRAME fPage1 = tt-regra-form-preco.cod-estabel.
                APPLY 'LEAVE':U TO tt-regra-form-preco.cod-estabel  IN FRAME fPage1.
             END.
             ELSE ASSIGN tt-regra-form-preco.cod-estabel:SCREEN-VALUE IN FRAME fPage1 = "":U.
        END.
    END CASE.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piHabiltaCamposTipoRegra wWindow 
PROCEDURE piHabiltaCamposTipoRegra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  piCdnTipo: 1 - Preáo Base
                     2 - Variaá∆o Qualidade
                     3 - Variaá∆o Volume
                     4 - Bìnus Fixo
                     
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piCdnTipo AS INTEGER NO-UNDO.

    ASSIGN tt-regra-form-preco.cod-exame:SENSITIVE      IN FRAME fPage1 = piCdnTipo = 2
           tt-regra-form-preco.cod-comp:SENSITIVE       IN FRAME fPage1 = piCdnTipo = 2
           rs-regra-aplicacao:SENSITIVE                 IN FRAME fPage1 = piCdnTipo = 3
           tt-regra-form-preco.val-faixa-inic:SENSITIVE IN FRAME fPage1 = piCdnTipo = 2 OR piCdnTipo = 3
           tt-regra-form-preco.val-faixa-fim:SENSITIVE  IN FRAME fPage1 = piCdnTipo = 2 OR piCdnTipo = 3.
    
    IF lUpdate THEN DO:
        IF piCdnTipo = 2 THEN DO:
            APPLY 'LEAVE':U TO tt-regra-form-preco.cod-exame IN FRAME fPage1.
            APPLY 'LEAVE':U TO tt-regra-form-preco.cod-comp  IN FRAME fPage1.        
        END.
    END.
    
    IF piCdnTipo = 1 OR piCdnTipo = 4 THEN DO:
        ASSIGN tt-regra-form-preco.val-faixa-inic:SCREEN-VALUE IN FRAME fPage1 = '0'
               tt-regra-form-preco.val-faixa-fim:SCREEN-VALUE  IN FRAME fPage1 = '0'.
    END.

    IF piCdnTipo <> 2 THEN DO:
        ASSIGN tt-regra-form-preco.cod-exame:SCREEN-VALUE IN FRAME fPage1 = '0'
               tt-regra-form-preco.cod-comp:SCREEN-VALUE  IN FRAME fPage1 = '0'
               fi-desc-exame:SCREEN-VALUE                 IN FRAME fPage1 = "":U
               fi-desc-comp:SCREEN-VALUE                  IN FRAME fPage1 = "":U.
    END.   
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLimparCampos wWindow 
PROCEDURE piLimparCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN tt-regra-form-preco.cod-regra:SCREEN-VALUE      IN FRAME fPage1 = ""
           tt-regra-form-preco.descricao:SCREEN-VALUE      IN FRAME fPage1 = ""
           tt-regra-form-preco.cdn-seq:SCREEN-VALUE        IN FRAME fPage1 = ""           
           cb-abrangencia:SCREEN-VALUE                     IN FRAME fPage1 = "1"
           cb-tipo-regra:SCREEN-VALUE                      IN FRAME fPage1 = "1"
           rs-regra-aplicacao:SCREEN-VALUE                 IN FRAME fPage1 = "1"
           tt-regra-form-preco.val-faixa-inic:SCREEN-VALUE IN FRAME fPage1 = "0"
           tt-regra-form-preco.val-faixa-fim:SCREEN-VALUE  IN FRAME fPage1 = "0"
           tt-regra-form-preco.val-unit:SCREEN-VALUE       IN FRAME fPage1 = "0"
           tt-regra-form-preco.cod-exame:SCREEN-VALUE      IN FRAME fPage1 = "0"
           tt-regra-form-preco.cod-comp:SCREEN-VALUE       IN FRAME fPage1 = "0".

    APPLY 'VALUE-CHANGED' TO cb-item        IN FRAME fPage1.
    APPLY 'VALUE-CHANGED' TO cb-tipo-regra  IN FRAME fPage1.
    APPLY 'VALUE-CHANGED' TO cb-abrangencia IN FRAME fPage1.

    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSaveRecord wWindow 
PROCEDURE piSaveRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     DEFINE VARIABLE c-cod-usuar-criac LIKE regra-form-preco.cod-usuar-criac NO-UNDO.
     DEFINE VARIABLE da-dat-criac      LIKE regra-form-preco.dat-criac       NO-UNDO.

     FOR FIRST tt-regra-form-preco:
         ASSIGN c-cod-usuar-criac = tt-regra-form-preco.cod-usuar-criac
                da-dat-criac      = tt-regra-form-preco.dat-criac.
     END.   

     EMPTY TEMP-TABLE tt-regra-form-preco NO-ERROR.

     CREATE tt-regra-form-preco.

     ASSIGN tt-regra-form-preco.cod-regra        =  INPUT FRAME fPage1 tt-regra-form-preco.cod-regra
            tt-regra-form-preco.cdn-seq          =  INPUT FRAME fPage1 tt-regra-form-preco.cdn-seq
            tt-regra-form-preco.cdn-tipo         =  INPUT FRAME fPage1 cb-tipo-regra
            tt-regra-form-preco.descricao        =  INPUT FRAME fPage1 tt-regra-form-preco.descricao
            tt-regra-form-preco.it-codigo        =  INPUT FRAME fPage1 cb-item
            tt-regra-form-preco.dat-inic         =  INPUT FRAME fPage1 tt-regra-form-preco.dat-inic
            tt-regra-form-preco.cdn-abrangen     =  INPUT FRAME fPage1 cb-abrangencia            
            tt-regra-form-preco.dat-fim          =  INPUT FRAME fPage1 tt-regra-form-preco.dat-fim
            tt-regra-form-preco.val-unit         =  INPUT FRAME fPage1 tt-regra-form-preco.val-unit
            tt-regra-form-preco.des-narrat       =  INPUT FRAME fPage2 ed-narrativa.
 
     CASE tt-regra-form-preco.cdn-abrangen:
         WHEN 1 THEN ASSIGN tt-regra-form-preco.cod-pto-coleta   =  INPUT FRAME fPage1 tt-regra-form-preco.cod-pto-coleta. /* Ponto Coleta */
         WHEN 2 THEN ASSIGN tt-regra-form-preco.cod-propried     =  INPUT FRAME fPage1 tt-regra-form-preco.cod-propried. /* Propriedade */
         WHEN 3 THEN ASSIGN tt-regra-form-preco.cdn-produt-rural =  INT(INPUT FRAME fPage1 fi-cdn-produt-rural). /* Produtor */
         WHEN 4 THEN ASSIGN tt-regra-form-preco.cdn-grp-produt   =  INT(INPUT FRAME fPage1 fi-cdn-grp-produt). /* Grupo */
         WHEN 5 THEN ASSIGN tt-regra-form-preco.cod-rota         =  INPUT FRAME fPage1 tt-regra-form-preco.cod-rota. /* Rota */
         WHEN 6 THEN ASSIGN tt-regra-form-preco.cod-regiao       =  INPUT FRAME fPage1 tt-regra-form-preco.cod-regiao. /* Regi∆o */
         WHEN 7 THEN ASSIGN tt-regra-form-preco.cod-estabel      =  INPUT FRAME fPage1 tt-regra-form-preco.cod-estabel. /* Estabelec*/
     END CASE.

     IF  tt-regra-form-preco.cdn-tipo = 2 OR tt-regra-form-preco.cdn-tipo = 3 THEN DO:
         IF  tt-regra-form-preco.cdn-tipo = 2 THEN DO: /* Variacao Qualidade */
             ASSIGN tt-regra-form-preco.cod-exame  =  INPUT FRAME fPage1 tt-regra-form-preco.cod-exame 
                    tt-regra-form-preco.cod-comp   =  INPUT FRAME fPage1 tt-regra-form-preco.cod-comp. 
         END.
    
         IF  tt-regra-form-preco.cdn-tipo = 3 THEN DO: /* Variacao Volume */
             ASSIGN tt-regra-form-preco.cdn-aplic =  INPUT FRAME fPage1 rs-regra-aplicacao.
         END.

         ASSIGN tt-regra-form-preco.val-faixa-inic =  INPUT FRAME fPage1 tt-regra-form-preco.val-faixa-inic
                tt-regra-form-preco.val-faixa-fim  =  INPUT FRAME fPage1 tt-regra-form-preco.val-faixa-fim.
     END.


    RUN emptyRowErrors IN h-boin00972.
    RUN emptyRowObject IN h-boin00972.

    RUN validaExameExterno IN h-boin00972 (INPUT tt-regra-form-preco.cod-exame,
                                           INPUT tt-regra-form-preco.cdn-tipo).

    IF RETURN-VALUE = "OK" THEN DO:
      IF lUpdate THEN DO:
          ASSIGN tt-regra-form-preco.cod-usuar-alter  = v_cod_usuar_corren
                 tt-regra-form-preco.dat-alter        = TODAY 
                 tt-regra-form-preco.r-Rowid          = pr-rowid
                 tt-regra-form-preco.cod-usuar-criac  = c-cod-usuar-criac
                 tt-regra-form-preco.dat-criac        = da-dat-criac.
      
          RUN setRecord      IN h-boin00972(INPUT TABLE tt-regra-form-preco).
      
          RUN updateRecord IN h-boin00972.
      END.
      ELSE DO:
          ASSIGN tt-regra-form-preco.cod-usuar-criac  = v_cod_usuar_corren
                 tt-regra-form-preco.dat-criac        = TODAY.
      
          RUN setRecord      IN h-boin00972(INPUT TABLE tt-regra-form-preco).
      
          RUN createRecord   IN h-boin00972.
      END.
    END.

    IF RETURN-VALUE = "NOK":U THEN DO:
        /** Retorna a temp-table rowErrors com os erros da transa?ío **/
        RUN getRowErrors IN h-boin00972 (OUTPUT TABLE RowErrors).
           
        /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="Yes"}
        {method/showmessage.i3}
        RETURN "NOK":U.
    END.
    
    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnVigencia wWindow 
FUNCTION fnVigencia RETURNS DATE
  ( i AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dtAtual      AS INTEGER EXTENT 2 NO-UNDO.
    DEFINE VARIABLE mesAnt       AS INTEGER          NO-UNDO.
    DEFINE VARIABLE anoIni       AS INTEGER          NO-UNDO.
    DEFINE VARIABLE dtDataVigenc AS DATE    EXTENT 2 NO-UNDO.
    
    ASSIGN dtAtual[1] = MONTH(TODAY) /* mes corrente */
           dtAtual[2] = YEAR(TODAY)  /* ano corrente */
           mesant = dtAtual[1] - 1   /* mes anterior */
           anoini = dtAtual[2].      /* ano data inicial vigencia */
    
    /* Se for o mes um, atializa mes anterior com o mes 12*/
    IF dtAtual[1] = 1 THEN
        ASSIGN mesant = 12
               anoini  = dtAtual[2] - 1. /* ano anterior */
    
    ASSIGN dtDataVigenc[1] = DATE(mesant,1,anoini). /* Primeiro dia do mes */
           dtDataVigenc[2] = DATE(dtAtual[1],1,dtAtual[2]) - 1. /* ultimo dia do mes */
    
    RETURN dtDataVigenc[i].

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

