&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcld            PROGRESS
*/
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
{include/i-prgvrs.i BC0102D 2.00.00.003}  /*** "010003" 14/08/2023 08:00:45  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC0102D MBC}
&ENDIF

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
&GLOBAL-DEFINE Program        BC0102D
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   
&GLOBAL-DEFINE ttTable        

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 

/* definicao dos parametros */
DEF INPUT PARAM h-handleParam    AS HANDLE    NO-UNDO.
DEF INPUT PARAM piTipoAcao       AS INTEGER   NO-UNDO.
DEF INPUT PARAM pTipoAcesso      AS CHARACTER NO-UNDO.
DEF INPUT PARAM pIndLeituraCampo AS INTEGER   NO-UNDO.
DEF INPUT PARAM pComplemento     AS CHARACTER NO-UNDO.

DEF VAR iTipoItem AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE NO

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cValorItem bt-carac-esp iPosInicial ~
cIdInicial cIdFinal edDescricao btOK btCancel btHelp2 fi-descricao RECT-8 ~
RECT-9 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS cValorItem iPosInicial cIdInicial cIdFinal ~
edDescricao fi-descricao 

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

DEFINE VARIABLE edDescricao AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 128 SCROLLBAR-VERTICAL
     SIZE 81 BY 4.5 NO-UNDO.

DEFINE VARIABLE cIdFinal LIKE bc-layout-registro-item.id-final
     VIEW-AS FILL-IN 
     SIZE 21.14 BY .88 NO-UNDO.

DEFINE VARIABLE cIdInicial LIKE bc-layout-registro-item.id-inicial
     VIEW-AS FILL-IN 
     SIZE 21.14 BY .88 NO-UNDO.

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

DEFINE VARIABLE iPosInicial LIKE bc-layout-registro-item.pos-inicial
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 4.33.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 5.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 84 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     cValorItem AT ROW 1.5 COL 21.14
     bt-carac-esp AT ROW 1.5 COL 62
     iPosInicial AT ROW 2.5 COL 20 COLON-ALIGNED
     i-caracter AT ROW 2.5 COL 64 COLON-ALIGNED NO-LABEL
     Bt-check AT ROW 2.5 COL 70.29
     bt-cancel AT ROW 2.5 COL 74.57
     cIdInicial AT ROW 3.5 COL 20 COLON-ALIGNED
     cIdFinal AT ROW 4.5 COL 20 COLON-ALIGNED
     edDescricao AT ROW 6.5 COL 3 NO-LABEL
     btOK AT ROW 11.71 COL 2
     btCancel AT ROW 11.71 COL 13
     btHelp2 AT ROW 11.71 COL 74
     fi-descricao AT ROW 5.75 COL 3 COLON-ALIGNED NO-LABEL
     RECT-8 AT ROW 1.25 COL 2
     RECT-9 AT ROW 6 COL 2
     rtToolBar AT ROW 11.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 84.72 BY 12.25
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
         TITLE              = "Inclui Item Estrututa"
         HEIGHT             = 12.25
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

/* SETTINGS FOR FILL-IN cIdFinal IN FRAME fpage0
   LIKE = mgcld.bc-layout-registro-item.id-final EXP-SIZE               */
/* SETTINGS FOR FILL-IN cIdInicial IN FRAME fpage0
   LIKE = mgcld.bc-layout-registro-item.id-inicial EXP-SIZE             */
/* SETTINGS FOR FILL-IN cValorItem IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN i-caracter IN FRAME fpage0
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       i-caracter:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FILL-IN iPosInicial IN FRAME fpage0
   LIKE = mgcld.bc-layout-registro-item.pos-inicial EXP-SIZE            */
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
          bt-cancel:VISIBLE IN FRAME fPage0 = YES.         
  
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
   IF INPUT FRAME fPage0 i-caracter = 0 OR INPUT FRAME fPage0 i-caracter > 225 THEN DO:     
      RUN utp/ut-msgs.p(INPUT "SHOW":U,
                        INPUT 25195,                                
                        INPUT "").                           
      APPLY 'ENTRY':U TO i-caracter.
      RETURN NO-APPLY. 
   END.
   ASSIGN cValorItem:SCREEN-VALUE IN FRAME fPage0 = cValorItem:SCREEN-VALUE IN FRAME fPage0 + CHR(INTEGER(INPUT FRAME fPAge0 i-caracter)). 
   DISABLE i-caracter
           bt-check
           bt-cancel WITH FRAME fPage0.
  
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

   ASSIGN INPUT FRAME fPage0 cValorItem
          INPUT FRAME fPage0 iPosInicial
          INPUT FRAME fPage0 cIdInicial
          INPUT FRAME fPage0 cIdFinal
          INPUT FRAME fPage0 edDescricao.

   IF iTipoItem > 2 THEN DO:
      ASSIGN iNum = INT(cValorItem) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
         {utp/ut-field.i mgcld bc-layout-registro-item valor-item 1}
         RUN utp/ut-msgs.p('SHOW':U,
                          36,
                          RETURN-VALUE).
         RETURN NO-APPLY.
      END.
      ASSIGN iPosInicial = 0.
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
   RUN verificaCaracterEspecial(cIdInicial, OUTPUT lErro).
   IF lErro THEN DO:
      RUN utp/ut-msgs.p("SHOW":U,
                        1100,
                        cIdInicial:LABEL + "~~" + cCaracter).
      
      APPLY 'ENTRY':U TO cIdInicial IN FRAME fPAge0.
      RETURN NO-APPLY.
   END.

   /* Verifica Utilizacao de Caracter Especial '|' */
   RUN verificaCaracterEspecial(cIdFinal, OUTPUT lErro).
   IF lErro THEN DO:
      RUN utp/ut-msgs.p("SHOW":U,
                        1100,
                        cIdFinal:LABEL + "~~" + cCaracter).
      
      APPLY 'ENTRY':U TO cIdFinal IN FRAME fPAge0.
      RETURN NO-APPLY.
   END.
   
   /* Verifica Utilizacao de Caracter Especial '|' */
   RUN verificaCaracterEspecial(edDescricao, OUTPUT lErro).
   IF lErro THEN DO:
      {utp/ut-liter.i Descri‡Æo}
      RUN utp/ut-msgs.p("SHOW":U,
                        1100,
                        RETURN-VALUE + "~~" + cCaracter).
      
      APPLY 'ENTRY':U TO edDescricao IN FRAME fPAge0.
      RETURN NO-APPLY.
   END.

   ASSIGN pComplemento = STRING(iTipoItem)   + '|':U +
                         cValorItem          + '|':U + 
                         STRING(iPosInicial) + '|':U + 
                         cIdInicial          + '|':U +  
                         cIdFinal            + '|':U +  
                         edDescricao.

   APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializa‡Æo do programam ---*/
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
   IF VALID-HANDLE(h-handleParam) THEN   
      RUN piBloqWindow IN h-handleParam.

   {utp/ut-liter.i Detalhamento_Campo * R}
   ASSIGN fi-descricao = RETURN-VALUE.
   
   ASSIGN iTipoItem   = INTEGER(ENTRY(1, pComplemento, '|':U))
          cValorItem  = ENTRY(2, pComplemento, '|':U)
          iPosInicial = INTEGER(ENTRY(3, pComplemento, '|':U))
          cIdInicial  = ENTRY(4, pComplemento, '|':U)
          cIdFinal    = ENTRY(5, pComplemento, '|':U)
          edDescricao = ENTRY(6, pComplemento, '|':U).
           
   ASSIGN pComplemento = "":U.
   CASE iTipoItem: 
      WHEN 2 THEN DO: 
         {utp/ut-liter.i Constante * L}  
         ENABLE iPosInicial bt-carac-esp WITH FRAME fPage0.
      END.
      WHEN 3 THEN DO: 
         {utp/ut-liter.i Qtde_Linhas * L} 
         ASSIGN bt-carac-esp:VISIBLE IN FRAME fPage0 = NO.
      END.
      WHEN 4 THEN DO: 
         {utp/ut-liter.i Qtde_Espa‡os * L}     
         ASSIGN bt-carac-esp:VISIBLE IN FRAME fPage0 = NO.
      END.
   END CASE.
    
   ASSIGN cValorItem:LABEL IN FRAME fPAge0 = RETURN-VALUE.
   ENABLE cValorItem 
          edDescricao
      WITH FRAME fPage0.

   IF pTipoAcesso = "VIEW":U THEN
      DISABLE ALL EXCEPT btOk
                         btCancel
                         btHelp2
         WITH FRAME fPage0.
   
   DISPLAY fi-descricao
           cValorItem  
           iPosInicial  
           cIdInicial 
           cIdFinal
           edDescricao
      WITH FRAME fPage0.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaCaracterEspecial wWindow 
PROCEDURE verificaCaracterEspecial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF INPUT PARAM pCampo AS CHARACTER NO-UNDO.
   DEF OUTPUT PARAM lErro AS LOGICAL   NO-UNDO.

   DEF VAR iNum AS INTEGER NO-UNDO.
                     
   DO iNum = 1 TO LENGTH(pCampo):
      IF INDEX(pCampo,'|':U) > 0 THEN DO:
         lErro = YES.
         RETURN.
      END.
   END.
   lErro = NO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
