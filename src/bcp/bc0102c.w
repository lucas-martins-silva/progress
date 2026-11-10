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
{include/i-prgvrs.i BC0102C 2.00.00.004}  /*** "010004" 14/08/2023 08:00:45  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC0102C MBC}
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
&GLOBAL-DEFINE Program        BC0102C
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 slTable slField

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER h-handleParam      AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piTipoAcao         AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER phDBOBcTpLayoutReg AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER phDBOBcTpLayoutTab AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER pCodTipoLayout     AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER pCodTipoLayoutReg  AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE iCont                     AS INTEGER   NO-UNDO.
DEFINE VARIABLE lMethod                   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cDesTable                 AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDesDataBase              AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTabela                   AS CHARACTER NO-UNDO.
DEFINE VARIABLE hBuffer                   AS HANDLE    NO-UNDO.
DEFINE VARIABLE hField                    AS HANDLE    NO-UNDO.
DEFINE VARIABLE cDesFields                AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE NO

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cSegmento slTable slField btOK btCancel ~
btHelp2 RECT-7 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS cSegmento slTable slField 

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

DEFINE VARIABLE cSegmento AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 71 BY 10.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 72 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE slField AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SORT SCROLLBAR-VERTICAL 
     SIZE 34 BY 8.5 NO-UNDO.

DEFINE VARIABLE slTable AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SORT SCROLLBAR-VERTICAL 
     SIZE 33 BY 8.5 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     cSegmento AT ROW 1.5 COL 16 COLON-ALIGNED
     slTable AT ROW 2.75 COL 3 NO-LABEL
     slField AT ROW 2.75 COL 38 NO-LABEL
     btOK AT ROW 11.96 COL 2
     btCancel AT ROW 11.96 COL 13
     btHelp2 AT ROW 11.96 COL 62
     RECT-7 AT ROW 1.25 COL 2
     rtToolBar AT ROW 11.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 72.86 BY 12.5
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
         HEIGHT             = 12.42
         WIDTH              = 72.86
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
{include/i_fnctrad.i}    

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
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
   IF INPUT FRAME fPage0 slField <> "":U THEN
      ASSIGN cDesFields = INPUT FRAME fPage0 slField. /* contem os campos selecionados */

   APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME slField
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL slField wWindow
ON MOUSE-SELECT-DBLCLICK OF slField IN FRAME fpage0
DO:
   APPLY "CHOOSE":U TO btOK IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME slTable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL slTable wWindow
ON VALUE-CHANGED OF slTable IN FRAME fpage0
DO:
   DEF VAR cItemField AS CHARACTER NO-UNDO.
   DEF VAR iExtent    AS INTEGER   NO-UNDO.

   IF INPUT FRAME fPage0 slTable <> "":U AND INPUT FRAME fPage0 slTable <> ? THEN DO:        
      &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
          ASSIGN slField:LIST-ITEM-pairs IN FRAME fPage0 = ?.
      &ELSE
          ASSIGN slField:LIST-ITEMS IN FRAME fPage0 = "":U.
      &ENDIF
      
      
      ASSIGN cTabela = ENTRY(LOOKUP(INPUT FRAME fPage0 slTable,cDesTable), cDesDatabase) + ".":U + INPUT FRAME fPage0 slTable NO-ERROR.

      IF NOT ERROR-STATUS:ERROR THEN DO:
         CREATE BUFFER hBuffer FOR TABLE cTabela NO-ERROR.
         IF NOT ERROR-STATUS:ERROR THEN DO:
            /* Monta o slField com os campos da Tabela selecionada */
            REPEAT iCont = 1 TO hBuffer:NUM-FIELDS:
                   hField = hBuffer:BUFFER-FIELD(iCont).

               /* Verifica se o campo eh um extent para criar N ocorrencias */
               IF hField:EXTENT > 0 THEN DO:
                  DO iExtent = 1 TO hField:EXTENT:
                     ASSIGN cItemField = hField:NAME + "[":U + STRING(iExtent) + "]":U + " (":U + hField:LABEL + ")":U.
                     &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
                         ASSIGN lMethod = slField:ADD-LAST(cItemField,cItemField) IN FRAME fPage0.
                     &ELSE
                         ASSIGN lMethod = slField:ADD-LAST(cItemField) IN FRAME fPage0.
                     &ENDIF
                  END.
               END.
               ELSE DO:
                  ASSIGN cItemField = hField:NAME + " (":U + hField:LABEL + ")":U.
                  &IF "{&FNC_MULTI_IDIOMA}" = "YES" &THEN
                     ASSIGN lMethod = slField:ADD-LAST(cItemField,cItemField) IN FRAME fPage0.
                  &ELSE
                     ASSIGN lMethod  = slField:ADD-LAST(cItemField) IN FRAME fPage0.
                  &ENDIF
               END.
            END.
            DELETE WIDGET hBuffer.
         END.
      END.  
   END.
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
         
   {utp/ut-liter.i Segmento MBC R}
   ASSIGN cSegmento:LABEL IN FRAME fPage0 = RETURN-VALUE.

   RUN goToKey IN phDBOBcTpLayoutReg (pCodTipoLayout,
                                      pCodTipoLayoutReg).

   RUN getCharField IN phDBOBcTpLayoutReg ("descricao":U,
                                           OUTPUT cSegmento).
    
   RUN returnTable  IN phDBOBcTpLayoutTab (pCodTipoLayout,
                                           pCodTipoLayoutReg,
                                           OUTPUT cDesTable,
                                           OUTPUT cDesDatabase).

   /* monta combo-box de Tipo Layout e posiciona no no item correspodente */
   DO iCont = 1 TO NUM-ENTRIES(cDesTable):
      ASSIGN lMethod = slTable:ADD-LAST(ENTRY(iCont,cDesTable)) IN FRAME fPage0.
   END.
   DISPLAY cSegmento WITH FRAME fPage0.
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
      RUN piAtualizaSelecionaCampo IN h-handleParam ( INPUT piTipoAcao,  /* A‡Æo selecionada */
                                                      INPUT cTabela,     /* comtem database.Table */
                                                      INPUT cDesFields). /* contem os campos selecionados */
      RUN piAtualizaReg IN h-handleParam.
      RUN piLibWindow IN h-handleParam.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
