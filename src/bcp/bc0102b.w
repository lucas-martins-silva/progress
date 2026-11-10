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
{include/i-prgvrs.i BC0102B 2.00.00.007}  /*** "010007" 14/08/2023 08:00:45  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC0102B MBC}
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
&GLOBAL-DEFINE Program        BC0102B
&GLOBAL-DEFINE Version        2.00.00.007

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 slSegmento

/* Parameters Definitions ---                                           */
DEF INPUT PARAM h-handleParam      AS HANDLE     NO-UNDO.
DEF INPUT PARAM piTipoAcao         AS INTEGER    NO-UNDO.
DEF INPUT PARAM phDBOBcTpLayoutReg AS HANDLE     NO-UNDO.
DEF INPUT PARAM phDBOBcLayout      AS HANDLE     NO-UNDO.
DEF INPUT PARAM phDBOBcLayoutReg   AS HANDLE     NO-UNDO.
DEF INPUT PARAM chTVNodes          AS CHARACTER  NO-UNDO.

/* Local Variable Definitions ---                                       */
DEF VAR cLayout           AS CHARACTER FORMAT  "x(500)":U NO-UNDO.
DEF VAR cDescricao        AS CHARACTER FORMAT "x(1000)":U NO-UNDO.
DEF VAR iCont             AS INTEGER                      NO-UNDO.
DEF VAR lMethod           AS LOGICAL                      NO-UNDO.
DEF VAR iCodTipoLayout    AS INTEGER                      NO-UNDO.
DEF VAR iCodLayout        AS INTEGER                      NO-UNDO.
DEF VAR iCodTpLayoutReg   AS INTEGER                      NO-UNDO.
DEF VAR iIndOcorrencia    AS INTEGER                      NO-UNDO.
DEF VAR cDesTipoLayoutReg AS CHARACTER                    NO-UNDO.
DEF VAR lLogDatasul       AS LOGICAL                      NO-UNDO.
DEF VAR iNumVersao        AS INTEGER                      NO-UNDO.
DEF VAR chItem            AS COM-HANDLE                   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE NO

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS slSegmento btOK btCancel btHelp2 fiText ~
RECT-7 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS slSegmento fiText 

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

DEFINE VARIABLE fiText AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45 BY 10.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 46 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE slSegmento AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 43 BY 9 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     slSegmento AT ROW 2.25 COL 3 NO-LABEL
     btOK AT ROW 11.96 COL 2
     btCancel AT ROW 11.96 COL 13
     btHelp2 AT ROW 11.96 COL 36
     fiText AT ROW 1.25 COL 2 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.5 COL 2
     rtToolBar AT ROW 11.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 46.43 BY 12.5
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
         HEIGHT             = 12.46
         WIDTH              = 46.43
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
   IF INPUT FRAME fPage0 slSegmento <> "":U THEN DO:
      /* iCodTpLayoutReg -> retorna o Tipo de LAyout de Registro 
         cDesTipoLayoutReg -> Label para visualiza‡Æo 
         formato   : "Identificador - Descri‡Æo (SEGMENTO)" 
         Observa‡Æo: Ao criar um novo Segmento, o identificador eh "" */
      
      ASSIGN iCodTpLayoutReg   = INTEGER(ENTRY(1, INPUT FRAME fPage0 slSegmento,"-":U))
             cDesTipoLayoutReg = " - ":U + ENTRY(2, INPUT FRAME fPage0 slSegmento,"-":U)
                                 +  " (":U + TRIM(fiText:SCREEN-VALUE IN FRAME fPage0) + ")":U.

      /* posiciona no Tipo Layout Registro Selecionado */
      RUN goToKey IN phDBOBcTpLayoutReg (INPUT iCodTipoLayout,
                                         INPUT iCodTpLayoutReg).
                                         
      /* retorna o atributo ind-Ocorrencia */
      RUN getIntField IN phDBOBcTpLayoutReg (INPUT "ind-ocorrencia":U,
                                             OUTPUT iIndOcorrencia).
                                         
      RUN validaLayout IN phDBOBcLayoutReg (INPUT iCodLayout,
                                            INPUT iCodTpLayoutReg).
      IF RETURN-VALUE = "NOK" THEN DO:
         {utp/ut-liter.i Segmento * L}
         RUN utp/ut-msgs.p('SHOW':U,
                           8,
                           TRIM(RETURN-VALUE)).
         
         ASSIGN cDesTipoLayoutReg = ""
                iCodTpLayoutReg   = 0.
         
         RETURN NO-APPLY.        
      END.               
   END.
   APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME slSegmento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL slSegmento wWindow
ON MOUSE-SELECT-DBLCLICK OF slSegmento IN FRAME fpage0
DO:
   APPLY "CHOOSE":U TO btOK IN FRAME fPage0.
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
   ASSIGN fiText:SCREEN-VALUE IN FRAME fPage0 = RETURN-VALUE
          cDesTipoLayoutReg                   = "".
   
   /* monta combo-box de Tipo Layout e posiciona no no item correspodente */
   RUN getIntField IN phDBOBcLayout ( INPUT "cod-tipo-layout":U,
                                      OUTPUT iCodTipoLayout).

   RUN returnValues IN phDBOBcTpLayoutReg (INPUT iCodTipoLayout,
                                           OUTPUT cLayout, 
                                           OUTPUT cDescricao).

   RUN getKey IN phDBOBcLayout (OUTPUT iCodLayout,
                                OUTPUT lLogDatasul,
                                OUTPUT iNumVersao).

   DO iCont = 1 TO NUM-ENTRIES(cLayout):
      ASSIGN lMethod = slSegmento:ADD-LAST(ENTRY(iCont,cLayout) + " - ":U + ENTRY(iCont,cDescricao)) IN FRAME fPage0.
   END.
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
      RUN piAtualizaSegmento IN h-handleParam ( INPUT piTipoAcao,
                                                INPUT iCodTpLayoutReg,
                                                INPUT iIndOcorrencia,
                                                INPUT cDesTipoLayoutReg).
      RUN piAtualizaReg IN h-handleParam.
      RUN piLibWindow IN h-handleParam.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
