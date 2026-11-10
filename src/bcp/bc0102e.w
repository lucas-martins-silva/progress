&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcld            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttBcLayoutRegistroItem NO-UNDO LIKE bc-layout-registro-item.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0102E 2.00.00.005}  /*** "010005" 14/08/2023 08:00:45  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC0102E MBC}
&ENDIF

&ANALYZE-RESUME
/* Connected Databases 
          mgcld            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        BC0102E
&GLOBAL-DEFINE Version        2.00.00.005

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   
&GLOBAL-DEFINE ttTable        ttBcLayoutRegistroItem   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 

/* definicao dos parametros */
DEF INPUT PARAM h-handleParam     AS HANDLE    NO-UNDO.
DEF INPUT PARAM piTipoAcao        AS INTEGER   NO-UNDO.
DEF INPUT PARAM pTipoAcesso       AS CHARACTER NO-UNDO.
DEF INPUT PARAM pCodTipoLayout    AS INTEGER   NO-UNDO.
DEF INPUT PARAM pIndLeituraCampo  AS INTEGER   NO-UNDO.
DEF INPUT PARAM pComplemento      AS CHARACTER NO-UNDO.


DEFINE VARIABLE c-control-etiq AS CHARACTER VIEW-AS SELECTION-LIST
       INNER-CHARS 2 INNER-LINES 1 SORT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE NO

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttBcLayoutRegistroItem.formato ~
ttBcLayoutRegistroItem.pos-inicial ttBcLayoutRegistroItem.num-decimais ~
ttBcLayoutRegistroItem.id-inicial ttBcLayoutRegistroItem.id-final 
&Scoped-define ENABLED-TABLES ttBcLayoutRegistroItem
&Scoped-define FIRST-ENABLED-TABLE ttBcLayoutRegistroItem
&Scoped-define DISPLAYED-TABLES ttBcLayoutRegistroItem
&Scoped-define FIRST-DISPLAYED-TABLE ttBcLayoutRegistroItem
&Scoped-Define ENABLED-OBJECTS cValorItem bt-carac-esp cbTipoDado ~
cValorCampo tgTrataDec edDescricao btOK btCancel btHelp2 fi-descricao ~
RECT-8 RECT-9 rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttBcLayoutRegistroItem.formato ~
ttBcLayoutRegistroItem.pos-inicial ttBcLayoutRegistroItem.num-decimais ~
ttBcLayoutRegistroItem.id-inicial ttBcLayoutRegistroItem.id-final 
&Scoped-Define DISPLAYED-OBJECTS cValorItem cbTipoDado cValorCampo ~
tgTrataDec edDescricao fi-descricao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancel 
     IMAGE-UP FILE "image\im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-can.bmp":U
     LABEL "" 
     SIZE 4.14 BY 1 TOOLTIP "Cancela".

DEFINE BUTTON bt-carac-esp 
     LABEL "Caracter Especial" 
     SIZE 17 BY .88 TOOLTIP "Caracter Especial".

DEFINE BUTTON Bt-check 
     IMAGE-UP FILE "image\im-chck1.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-chck1.bmp":U
     LABEL "" 
     SIZE 4.14 BY 1 TOOLTIP "Confirma"
     BGCOLOR 8 .

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE cbTipoDado AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 21 BY 1 NO-UNDO.

DEFINE VARIABLE edDescricao AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 128 SCROLLBAR-VERTICAL
     SIZE 81 BY 4.5 NO-UNDO.

DEFINE VARIABLE cValorCampo AS CHARACTER FORMAT "X(100)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE cValorItem AS CHARACTER FORMAT "X(100)" 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .67 NO-UNDO.

DEFINE VARIABLE i-caracter AS INTEGER FORMAT ">>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 TOOLTIP "Caracter" NO-UNDO.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 8.33.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 5.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 84 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tgTrataDec AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     cValorItem AT ROW 1.5 COL 21.14
     bt-carac-esp AT ROW 1.5 COL 62
     cbTipoDado AT ROW 2.5 COL 20 COLON-ALIGNED
     i-caracter AT ROW 2.5 COL 64 COLON-ALIGNED NO-LABEL
     Bt-check AT ROW 2.5 COL 70.29
     bt-cancel AT ROW 2.5 COL 74.57
     cValorCampo AT ROW 3.5 COL 20 COLON-ALIGNED
     ttBcLayoutRegistroItem.formato AT ROW 4.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22.57 BY .88
     ttBcLayoutRegistroItem.pos-inicial AT ROW 5.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tgTrataDec AT ROW 6.5 COL 22
     ttBcLayoutRegistroItem.num-decimais AT ROW 6.5 COL 48 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     ttBcLayoutRegistroItem.id-inicial AT ROW 7.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 32 BY .88
     ttBcLayoutRegistroItem.id-final AT ROW 8.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 32 BY .88
     edDescricao AT ROW 10.5 COL 3 NO-LABEL
     btOK AT ROW 15.71 COL 2
     btCancel AT ROW 15.71 COL 13
     btHelp2 AT ROW 15.71 COL 74
     fi-descricao AT ROW 9.75 COL 3 COLON-ALIGNED NO-LABEL
     RECT-8 AT ROW 1.25 COL 2
     RECT-9 AT ROW 10 COL 2
     rtToolBar AT ROW 15.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 84.72 BY 16.17
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttBcLayoutRegistroItem T "?" NO-UNDO mgcld bc-layout-registro-item
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Inclui Item Estrututa"
         HEIGHT             = 16.29
         WIDTH              = 84.72
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
         RESIZE             = YES
         SCROLL-BARS        = NO
         STATUS-AREA        = YES
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = YES
         THREE-D            = YES
         MESSAGE-AREA       = NO
         SENSITIVE          = YES.
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
/* SETTINGS FOR BUTTON bt-cancel IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       bt-cancel:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR BUTTON Bt-check IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       Bt-check:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FILL-IN cValorItem IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN i-caracter IN FRAME fpage0
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       i-caracter:HIDDEN IN FRAME fpage0           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = YES.

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
ON END-ERROR OF wWindow /* Inclui Item Estrututa */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
   /* This case occurs when the user presses the "Esc" key.
      In a persistently run window, just ignore this.  If we did not, the
      application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Inclui Item Estrututa */
DO:
   /* This event will close the window and terminate the procedure.  */
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancel wWindow
ON CHOOSE OF bt-cancel IN FRAME fpage0
DO:
   DISABLE i-caracter
           bt-check
           bt-cancel
      WITH FRAME fPage0.
  
   ASSIGN i-caracter:VISIBLE IN FRAME fPage0 = NO
          bt-check:VISIBLE IN FRAME fPage0   = NO
          bt-cancel:VISIBLE IN FRAME fPage0  = NO. 
   
   ENABLE cValorItem WITH FRAME fPage0. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-carac-esp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-carac-esp wWindow
ON CHOOSE OF bt-carac-esp IN FRAME fpage0 /* Caracter Especial */
DO:
   ASSIGN i-caracter:VISIBLE IN FRAME fPage0 = YES
          bt-check:VISIBLE IN FRAME fPage0   = YES
          bt-cancel:VISIBLE IN FRAME fPage0  = YES.         
  
   ENABLE i-caracter
          bt-check
          bt-cancel
      WITH FRAME fPage0.
  
   DISABLE cValorItem WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Bt-check
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-check wWindow
ON CHOOSE OF Bt-check IN FRAME fpage0
DO:
   IF INPUT FRAME fPage0 i-caracter = 0 OR INPUT FRAME fPage0 i-caracter > 225 then do:     
      RUN utp/ut-msgs.p("SHOW":U,
                        25195,                                
                        "").                           
     
      APPLY 'ENTRY':U TO i-caracter.
      RETURN NO-APPLY. 
   END.
   ASSIGN cValorItem:SCREEN-VALUE IN FRAME fPage0 = cValorItem:SCREEN-VALUE IN FRAME fPage0 + CHR(INT(INPUT FRAME fPAge0 i-caracter)). 
   DISABLE i-caracter
           bt-check
           bt-cancel
      WITH FRAME fPage0.
   
   ASSIGN i-caracter:VISIBLE IN FRAME fPage0 = NO
          bt-check:VISIBLE IN FRAME fPage0   = NO
          bt-cancel:VISIBLE IN FRAME fPage0  = NO.           
  ENABLE cValorItem WITH FRAME fPage0.
  APPLY 'ENTRY':U TO cValorItem.
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
   DEF VAR iNum      AS INTEGER   NO-UNDO.
   DEF VAR lErro     AS LOGICAL   NO-UNDO.
   DEF VAR cCaracter AS CHARACTER NO-UNDO.
   
   {utp/ut-liter.i Caracter_Especial * R}
   cCaracter = RETURN-VALUE + ' "|" ':U.
   
   IF pTipoAcesso = "UPDATE":U THEN DO:
      ASSIGN INPUT FRAME fPage0 cbTipoDado
             INPUT FRAME fPage0 cValorItem
             INPUT FRAME fPage0 cValorCampo
             INPUT FRAME fPage0 {&ttTable}.formato
             INPUT FRAME fPage0 {&ttTable}.pos-inicial
             INPUT FRAME fPage0 {&ttTable}.num-decimais
             INPUT FRAME fPage0 {&ttTable}.id-inicial
             INPUT FRAME fPage0 {&ttTable}.id-final
             INPUT FRAME fPage0 edDescricao.
      
      IF pCodTipoLayout = 3 THEN DO:
         IF tgtrataDec:CHECKED IN FRAME fPage0 = YES THEN
            ASSIGN {&ttTable}.num-decimais = 1.
         
         IF NOT tgtrataDec:CHECKED IN FRAME fPage0 = YES THEN
            ASSIGN {&ttTable}.num-decimais = 0.
      END.
      /* Verifica Utilizacao de Caracter Especial '|' */
      RUN verificaCaracterEspecial(cValorItem, OUTPUT lErro).
      IF lErro THEN DO:
         RUN utp/ut-msgs.p("SHOW":U,
                           1100,
                           cValorItem:LABEL + "~~" + cCaracter).
         
         APPLY 'ENTRY':U TO cValorItem IN FRAME fPAge0.
         RETURN NO-APPLY.
      END.
      
      /* Verifica Utilizacao de Caracter Especial '|' */
      RUN verificaCaracterEspecial( cValorCampo,
                                    OUTPUT lErro).
      IF lErro THEN DO:
         RUN utp/ut-msgs.p("SHOW":U,
                           1100,
                           cValorCampo:LABEL + "~~" + cCaracter).
         
         APPLY 'ENTRY':U TO cValorCampo IN FRAME fPAge0.
         RETURN NO-APPLY.
      END.
   
      /* Verifica Utilizacao de Caracter Especial '|' */
      RUN verificaCaracterEspecial({&ttTable}.formato, OUTPUT lErro).
      IF lErro THEN DO:
         RUN utp/ut-msgs.p("SHOW":U,
                           1100,
                           {&ttTable}.formato:LABEL + "~~" + cCaracter).
         
         APPLY 'ENTRY':U TO {&ttTable}.formato IN FRAME fPAge0.
         RETURN NO-APPLY.
      END.
      
      /* Verifica Utilizacao de Caracter Especial '|' */
      RUN verificaCaracterEspecial( {&ttTable}.id-inicial,
                                    OUTPUT lErro).
      IF lErro THEN DO:
         RUN utp/ut-msgs.p("SHOW":U,
                           1100,
                           {&ttTable}.id-inicial:LABEL + "~~" + cCaracter).
         
         APPLY 'ENTRY':U TO {&ttTable}.id-inicial IN FRAME fPAge0.
         RETURN NO-APPLY.
      END.
      
      /* Verifica Utilizacao de Caracter Especial '|' */
      RUN verificaCaracterEspecial( {&ttTable}.id-final,  
                                    OUTPUT lErro).
      IF lErro THEN DO:
         RUN utp/ut-msgs.p("SHOW":U,
                           1100,
                           {&ttTable}.id-final:LABEL + "~~" + cCaracter).
         
         APPLY 'ENTRY':U TO {&ttTable}.id-final IN FRAME fPAge0.
         RETURN NO-APPLY.
      END.
      
      /* Verifica Utilizacao de Caracter Especial '|' */
      RUN verificaCaracterEspecial(edDescricao, OUTPUT lErro).
      IF lErro THEN DO:
         {utp/ut-liter.i Descriá∆o} 
         RUN utp/ut-msgs.p("SHOW":U,
                           1100,
                           RETURN-VALUE + "~~" + cCaracter).
         
         APPLY 'ENTRY':U TO edDescricao IN FRAME fPAge0.
         RETURN NO-APPLY.
      END.
           
      IF {&ttTable}.tipo-item = 3 OR {&ttTable}.tipo-item = 4 THEN DO:
         ASSIGN iNum = INTEGER(cValorItem) NO-ERROR.
         IF ERROR-STATUS:ERROR THEN DO:
            {utp/ut-field.i mgcld bc-layout-registro-item valor-item 1}
            RUN utp/ut-msgs.p('SHOW':U,
                              36,
                              RETURN-VALUE).
            
            RETURN NO-APPLY.
         END.
         ASSIGN {&ttTable}.pos-inicial = 0.
      END.
    
      IF pIndLeituraCampo < 4 AND {&ttTable}.tipo-item > 0 AND  pCodTipoLayout <> 3 THEN DO:
         ASSIGN {&ttTable}.id-inicial = "":U 
                {&ttTable}.id-final   = "":U.
      END.
      ASSIGN pComplemento = STRING({&ttTable}.tipo-item)    + '|':U +
                            cbTipoDado                      + '|':U +
                            cValorItem                      + '|':U +
                            {&ttTable}.formato              + '|':U +
                            STRING({&ttTable}.pos-inicial)  + '|':U +
                            STRING({&ttTable}.num-decimais) + '|':U +
                            {&ttTable}.id-inicial           + '|':U +
                            {&ttTable}.id-final             + '|':U +
                            cValorCampo                     + '|':U +
                            edDescricao.
   END.
   APPLY "CLOSE":U TO THIS-PROCEDURE.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cbTipoDado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cbTipoDado wWindow
ON VALUE-CHANGED OF cbTipoDado IN FRAME fpage0
DO:
   IF pCodTipoLayout <> 3 THEN DO:
      IF pTipoAcesso = "UPDATE":U THEN DO:
         IF INPUT FRAME fPage0 cbTipoDado = "DECIMAL":U THEN
            ENABLE tgTrataDec WITH FRAME fPage0.
         ELSE DO:
            ASSIGN tgTrataDec:CHECKED IN FRAME fPAge0 = NO.
            DISABLE tgTrataDec WITH FRAME fPage0.
         END.
         APPLY "VALUE-CHANGED":U TO tgTrataDec IN FRAME fPage0.
      END.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tgTrataDec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgTrataDec wWindow
ON VALUE-CHANGED OF tgTrataDec IN FRAME fpage0
DO:
   IF pCodTipoLayout <> 3 THEN DO:
      IF pTipoAcesso = "UPDATE":U THEN DO:
         ASSIGN INPUT FRAME fPage0 tgTrataDec.
        
         IF tgTrataDec THEN
            ENABLE {&ttTable}.num-decimais WITH FRAME fPage0.
         ELSE DO:
            ASSIGN {&ttTable}.num-decimais:SCREEN-VALUE IN FRAME fPage0 = "":U.
            DISABLE {&ttTable}.num-decimais WITH FRAME fPage0.
         END.
      END.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializaá∆o do programam ---*/
{window/MainBlock.i}

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
   DEF VAR cTipoItem AS CHARACTER NO-UNDO.

   IF VALID-HANDLE(h-handleParam) THEN   
      RUN piBloqWindow IN h-handleParam.
   
   /* decompoe as informacoes recebidas - pComplemento */
   ASSIGN {&ttTable}.tipo-item    = INTEGER(ENTRY(1,pComplemento,'|':U))
          cbTipoDado              = ENTRY(2,pComplemento,'|':U)
          cValorItem              = ENTRY(3,pComplemento,'|':U)
          {&ttTable}.formato      = ENTRY(4,pComplemento,'|':U)
          {&ttTable}.pos-inicial  = INTEGER(ENTRY(5,pComplemento,'|':U))
          {&ttTable}.num-decimais = INTEGER(ENTRY(6,pComplemento,'|':U))
          {&ttTable}.id-inicial   = ENTRY(7,pComplemento,'|':U)
          {&ttTable}.id-final     = ENTRY(8,pComplemento,'|':U)
          cValorCampo             = ENTRY(9,pComplemento,'|':U)
          edDescricao             = ENTRY(10,pComplemento,'|':U).
   
   ASSIGN bt-carac-esp:VISIBLE IN FRAME fPage0 = NO.
   
   {utp/ut-liter.i Trata_Decimais * R}
   ASSIGN tgTrataDec:LABEL IN FRAME fPage0 = RETURN-VALUE.
   
   {utp/ut-field.i mgcld bc-layout-registro-item tipo-dado 1}
   ASSIGN cbTipoDado:LABEL IN FRAME fPage0 = RETURN-VALUE.
   
   {utp/ut-liter.i Detalhamento_Item * R}
   ASSIGN fi-descricao = RETURN-VALUE.
   
   /* Monta Help para Nota de Sa°da */                          
   IF pCodTipoLayout = 1 THEN DO:
      {utp/ut-liter.i Efetua_Multiplicaá∆o_dos_dados_na_Sa°da * R}
      ASSIGN tgTrataDec:HELP IN FRAME fPage0 = RETURN-VALUE.
      
      {utp/ut-liter.i N£mero_de_Decimais_para_Multiplicaá∆o  * R}
      ASSIGN {&ttTable}.num-decimais:HELP IN FRAME fPage0 = RETURN-VALUE.
   END.
   ELSE DO:
      {utp/ut-liter.i Efetua_Divis∆o_dos_dados_na_Entrada * R}
      ASSIGN tgTrataDec:HELP IN FRAME fPage0 = RETURN-VALUE.
      
      {utp/ut-liter.i N£mero_de_Decimais_para_Divis∆o * R}
      ASSIGN {&ttTable}.num-decimais:HELP IN FRAME fPage0 = RETURN-VALUE.
   END.
   
   /* Busca Label do Campo */ 
   RUN retornaLabelTipoItem ({&ttTable}.tipo-item, OUTPUT cTipoItem).
   ASSIGN cValorItem:LABEL IN FRAME fPage0 = cTipoItem.
   
   {utp/ut-liter.i Valor * L}
   ASSIGN cValorCampo:LABEL IN FRAME fPage0 = RETURN-VALUE.
   
   ASSIGN pComplemento = "":U.
   CASE {&ttTable}.tipo-item: 
      WHEN 0 THEN DO: /* Segmento */
          {utp/ut-liter.i Identificador_Inicial * L}
          ASSIGN {&ttTable}.id-inicial:LABEL IN FRAME fPage0 = TRIM(RETURN-VALUE).
          {utp/ut-liter.i Identificador_Final * L}
          ASSIGN {&ttTable}.id-Final:LABEL IN FRAME fPage0 = TRIM(RETURN-VALUE).
      END.
      WHEN 1 THEN DO: /* campo */
          ENABLE {&ttTable}.pos-inicial 
                 {&ttTable}.formato WITH FRAME fPage0.
      END.
      WHEN 2 THEN DO: /* Constante */
          ASSIGN bt-carac-esp:VISIBLE IN FRAME fPage0 = YES.
          ENABLE cValorItem
                 {&ttTable}.pos-inicial 
                 bt-carac-esp WITH FRAME fPage0.
      END.
      WHEN 3 THEN DO: /* Nova Linha */
          ENABLE cValorItem WITH FRAME fPage0.
      END.
      WHEN 4 THEN DO: /* Espaco */
          ENABLE cValorItem WITH FRAME fPage0.
      END.
      WHEN 5 THEN DO: /* Auxiliar */
          ENABLE cValorItem
                 cbTipoDado
                 {&ttTable}.formato
                 {&ttTable}.pos-inicial WITH FRAME fPage0.
      END.
      WHEN 6 THEN DO: /* Campo Fixo */
          ASSIGN bt-carac-esp:VISIBLE IN FRAME fPage0 = NO.
          ENABLE cbTipoDado
                 cValorItem
                 {&ttTable}.formato
                 {&ttTable}.pos-inicial 
                 cValorCampo WITH FRAME fPage0.
      END.
   END CASE.
   IF pCodTipoLayout = 3 THEN DO: 
      {utp/ut-liter.i "T°tulo"}
      ASSIGN {&ttTable}.id-inicial:LABEL IN FRAME fPage0 = TRIM(RETURN-VALUE).
      
      {utp/ut-liter.i "T°tulo Coluna"}
      ASSIGN {&ttTable}.id-Final:LABEL IN FRAME fPage0 = TRIM(RETURN-VALUE). 
      ENABLE {&ttTable}.id-inicial {&ttTable}.id-Final WITH FRAME fPage0.
      
      IF {&ttTable}.num-decimais = 1 THEN DO: 
         ASSIGN tgtrataDec:CHECKED IN FRAME fPage0 = YES. 
      END.
      ELSE DO:
          ASSIGN tgtrataDec:CHECKED IN FRAME fPage0 = NO. 
      END.
      {utp/ut-liter.i "Permite Alteraá∆o?"}
      ASSIGN tgTrataDec:VISIBLE IN FRAME fPage0 = YES
             tgtrataDec:LABEL IN FRAME Fpage0 = TRIM(RETURN-VALUE)
             tgtrataDec:SENSITIVE IN FRAME Fpage0 = YES.
      
      ASSIGN {&ttTable}.num-decimais:VISIBLE IN FRAME fPage0 = NO.
      
      DISABLE {&ttTable}.pos-inicial 
              {&ttTable}.formato WITH FRAME fPage0.
      
      DISPLAY {&ttTable}.id-inicial   
              {&ttTable}.id-final WITH FRAME fPage0.
   END.
   ENABLE edDescricao WITH FRAME fPage0.
                 
   IF (pIndLeituraCampo = 4 OR pIndLeituraCampo = 5) OR {&ttTable}.tipo-item = 0 THEN
       ENABLE {&ttTable}.id-inicial {&ttTable}.id-final WITH FRAME fPage0.
       
   IF pTipoAcesso = "VIEW":U THEN
      DISABLE ALL EXCEPT btOk
                         btCancel
                         btHelp2
         WITH FRAME fPage0.
   
   DISPLAY cbTipoDado              
           cValorItem   
           cValorCampo
           edDescricao
           fi-descricao
           {&ttTable}.formato      
           {&ttTable}.pos-inicial  
           {&ttTable}.id-inicial   
           {&ttTable}.id-final
      WITH FRAME fPage0.
           
   IF pCodTipoLayout <> 3 THEN DO:
      DISPLAY {&ttTable}.num-decimais  WITH FRAME fPage0.
      ASSIGN tgTrataDec:CHECKED IN FRAME fPage0 = ({&ttTable}.num-decimais > 0).
      APPLY "VALUE-CHANGED":U TO cbTipoDado IN FRAME fPage0.
   END.         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /* cria ttTable apenas para utilizar os campos na tela */
   CREATE {&ttTable}.

   /* inicializa cbTipoDado */
   cbTipoDado:LIST-ITEMS IN FRAME fPage0 = "CHARACTER,INTEGER,DECIMAL,DATE,LOGICAL":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface w-window 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
   IF VALID-HANDLE(h-handleParam) THEN DO:
      RUN piAtualizaConsLinEsp IN h-handleParam(INPUT piTipoAcao,
                                                INPUT pComplemento).
      RUN piAtualizaReg IN h-handleParam.
      RUN piLibWindow IN h-handleParam.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaLabelTipoItem wWindow 
PROCEDURE retornaLabelTipoItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF INPUT PARAM pTipoItem AS INTEGER   NO-UNDO.
   DEF OUTPUT PARAM pretorno AS CHARACTER NO-UNDO.

   CASE pTipoItem:
      WHEN 0 THEN DO:
         {utp/ut-liter.i Segmento     * L}
      END.
      WHEN 1 THEN DO:
         {utp/ut-liter.i Campo        * L}
      END.
      WHEN 2 THEN DO:
         {utp/ut-liter.i Constante    * L}
      END.
      WHEN 3 THEN DO:
         {utp/ut-liter.i Qtde_Linhas  * L}
      END.
      WHEN 4 THEN DO:
         {utp/ut-liter.i Qtde_Espaáos * L}
      END.
      WHEN 5 THEN DO:
         {utp/ut-liter.i Auxiliar     * L}
      END.
      WHEN 6 THEN DO:
         {utp/ut-liter.i Campo_Fixo   * L}
      END.
      OTHERWISE DO:
         ASSIGN pRetorno = "":U.
         RETURN.
      END.
   END CASE.
   ASSIGN pRetorno = TRIM(RETURN-VALUE).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaCaracterEspecial wWindow 
PROCEDURE verificaCaracterEspecial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF INPUT PARAM pCampo AS CHARACTER NO-UNDO.
   DEF OUTPUT PARAM lErro AS LOGICAL   NO-UNDO.

   DEF VAR iNum AS INT NO-UNDO.
                     
   DO iNum = 1 TO LENGTH(pCampo):
      IF INDEX(pCampo,'|':U) > 0 THEN DO:
         ASSIGN lErro = YES.
         RETURN.
      END.
   END.
   ASSIGN lErro = NO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
