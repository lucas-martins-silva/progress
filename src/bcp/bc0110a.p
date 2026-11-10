&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i BC0110A 2.00.00.008 } /*** "010008" 14/08/2023 08:00:46  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc0110a MBC}
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
&GLOBAL-DEFINE Program        BC0110A
&GLOBAL-DEFINE Version        2.00.00.008

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         No
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 BROWSE-Cabec BROWSE-Campos

/* Parameters Definitions ---                                           */
DEf INPUT PARAM h-handleParam AS HANDLE       NO-UNDO.
DEf INPUT PARAM h-handleSon   AS HANDLE       NO-UNDO.
DEF INPUT PARAM p-nr-trans    AS INTEGER      NO-UNDO.
DEF INPUT PARAM p-detalhe     AS CHARACTER    NO-UNDO.
DEF INPUT PARAM p-raw-trans   AS RAW          NO-UNDO.
DEF INPUT PARAM p-apaga-erro  AS LOGICAL      NO-UNDO.

DEF NEW GLOBAL SHARED VAR vAcessType    AS INTEGER  NO-UNDO. /* 1-Gravacao, 2-Consulta*/

/* Local Variable Definitions ---                                       */

DEF VAR h-bcapi017      AS HANDLE   NO-UNDO.
DEF VAR v-alterou-valor AS LOGICAL  NO-UNDO.

DEF TEMP-TABLE tt-cabec-campos NO-UNDO
    FIELD sequencia     AS INTEGER
    FIELD segmento      AS INTEGER
    FIELD descricao     AS CHARACTER COLUMN-LABEL "Segmento" FORMAT "X(40)"
    FIELD registro      AS INTEGER   COLUMN-LABEL "Registro" FORMAT ">>>>9"
    INDEX ch-codigo IS PRIMARY UNIQUE sequencia segmento registro.

{bcp/bcapi017.i}    /* tt-xml    */
{bcp/bcapi019.i}    /* tt-campos */
{cdp/cd0666.i}      /* tt-erro   */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME BROWSE-Cabec

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-cabec-campos tt-campos

/* Definitions for BROWSE BROWSE-Cabec                                  */
&Scoped-define FIELDS-IN-QUERY-BROWSE-Cabec tt-cabec-campos.descricao tt-cabec-campos.registro ""   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-Cabec   
&Scoped-define SELF-NAME BROWSE-Cabec
&Scoped-define OPEN-QUERY-BROWSE-Cabec OPEN QUERY {&SELF-NAME} FOR EACH tt-cabec-campos.
&Scoped-define TABLES-IN-QUERY-BROWSE-Cabec tt-cabec-campos
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-Cabec tt-cabec-campos


/* Definitions for BROWSE BROWSE-Campos                                 */
&Scoped-define FIELDS-IN-QUERY-BROWSE-Campos tt-campos.campo tt-campos.valor   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-Campos tt-campos.valor   
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-Campos tt-campos
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-Campos tt-campos
&Scoped-define SELF-NAME BROWSE-Campos
&Scoped-define OPEN-QUERY-BROWSE-Campos OPEN QUERY {&SELF-NAME}     FOR EACH tt-campos         WHERE tt-campos.segmento = tt-cabec-campos.segmento           AND tt-campos.registro = tt-cabec-campos.registro.
&Scoped-define TABLES-IN-QUERY-BROWSE-Campos tt-campos
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-Campos tt-campos


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-BROWSE-Cabec}~
    ~{&OPEN-QUERY-BROWSE-Campos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-Cabec BROWSE-Campos btOK btCancel ~
btHelp2 rtToolBar 

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

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 72 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-Cabec FOR 
      tt-cabec-campos SCROLLING.

DEFINE QUERY BROWSE-Campos FOR 
      tt-campos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-Cabec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-Cabec wWindow _FREEFORM
  QUERY BROWSE-Cabec DISPLAY
      tt-cabec-campos.descricao
      tt-cabec-campos.registro
      ""
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 70 BY 9
         FONT 1 ROW-HEIGHT-CHARS .6 EXPANDABLE.

DEFINE BROWSE BROWSE-Campos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-Campos wWindow _FREEFORM
  QUERY BROWSE-Campos DISPLAY
      tt-campos.campo
 tt-campos.valor
 ENABLE
 tt-campos.valor
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 70 BY 9
         FONT 1 ROW-HEIGHT-CHARS .7 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     BROWSE-Cabec AT ROW 1.25 COL 2
     BROWSE-Campos AT ROW 6.25 COL 2
     btOK AT ROW 15.71 COL 2
     btCancel AT ROW 15.71 COL 13
     btHelp2 AT ROW 15.71 COL 62
     rtToolBar AT ROW 15.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 73.29 BY 17
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
         HEIGHT             = 16.08
         WIDTH              = 72
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90.14
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90.14
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
/* BROWSE-TAB BROWSE-Cabec 1 fpage0 */
/* BROWSE-TAB BROWSE-Campos BROWSE-Cabec fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-Cabec
/* Query rebuild information for BROWSE BROWSE-Cabec
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-cabec-campos.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-Cabec */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-Campos
/* Query rebuild information for BROWSE BROWSE-Campos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME}
    FOR EACH tt-campos
        WHERE tt-campos.segmento = tt-cabec-campos.segmento
          AND tt-campos.registro = tt-cabec-campos.registro.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-Campos */
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
   IF VALID-HANDLE(h-handleParam) AND STRING(h-handleParam) <> "0" THEN
      RUN piLibWindow IN h-handleParam NO-ERROR. 
  
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-Cabec
&Scoped-define SELF-NAME BROWSE-Cabec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-Cabec wWindow
ON VALUE-CHANGED OF BROWSE-Cabec IN FRAME fpage0
DO:
   {&OPEN-QUERY-BROWSE-Campos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-Campos
&Scoped-define SELF-NAME BROWSE-Campos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-Campos wWindow
ON ROW-LEAVE OF BROWSE-Campos IN FRAME fpage0
DO:
   IF tt-campos.valor:SCREEN-VALUE IN BROWSE browse-campos <> tt-campos.valor THEN
      ASSIGN v-alterou-valor = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
   IF VALID-HANDLE(h-handleParam) AND STRING(h-handleParam) <> "0" THEN
      RUN piLibWindow IN h-handleParam NO-ERROR.  
      
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
   IF v-alterou-valor THEN DO:
      SESSION:SET-WAIT-STATE("general":U).
      RUN salvaTransacao.
      SESSION:SET-WAIT-STATE("":U).
   END.
    
   IF VALID-HANDLE(h-handleParam) AND STRING(h-handleParam) <> "0" THEN
      RUN piLibWindow IN h-handleParam NO-ERROR.  
      
   IF VALID-HANDLE(h-handleSon) AND STRING(h-handleSon) <> "0" THEN
      RUN pi-atualiza-dados IN h-handleSon (INPUT p-nr-trans,
                                            INPUT p-detalhe,
                                            INPUT p-raw-trans,
                                            INPUT p-apaga-erro) NO-ERROR.                                           
   APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-Cabec
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     Elimina handle de procedures persistentes
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF VALID-HANDLE(h-bcapi017) THEN
      DELETE PROCEDURE h-bcapi017.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     Le os dados da transa‡Æo e apresenta nos browsers
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF VALID-HANDLE(h-handleParam) AND STRING(h-handleParam) <> "0" THEN
      RUN piBloqWindow IN h-handleParam NO-ERROR.  

   RUN bcp/bcapi017.p PERSISTENT SET h-bcapi017.
    
   RUN obtemTTCampos IN h-bcapi017 (p-nr-trans, OUTPUT TABLE tt-campos, INPUT-OUTPUT TABLE tt-erro).
   IF RETURN-VALUE = "NOK":U THEN DO:
      RUN cdp/cd0666.w (INPUT TABLE tt-erro).
      RETURN "NOK":U.
   END.
   RUN preparaCabec.
   {&OPEN-QUERY-BROWSE-Cabec}
   {&OPEN-QUERY-BROWSE-Campos}
   IF vAcessType = 2 /*consulta*/ THEN DO:
      tt-campos.valor:READ-ONLY IN BROWSE BROWSE-Campos = YES.
      btOK:SENSITIVE IN FRAME fPage0 = NO.
   END.
   RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preparaCabec wWindow 
PROCEDURE preparaCabec :
/*------------------------------------------------------------------------------
  Purpose:     Monta tt-cabec-campos com base em tt-campos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   EMPTY TEMP-TABLE tt-cabec-campos.
   
   FOR EACH tt-campos BREAK BY tt-campos.segmento BY tt-campos.registro:
      IF FIRST-OF (tt-campos.registro) THEN DO:
         
         CREATE tt-cabec-campos.
         ASSIGN tt-cabec-campos.sequencia = tt-campos.sequencia
                tt-cabec-campos.segmento  = tt-campos.segmento
                tt-cabec-campos.registro  = tt-campos.registro.
                
         RUN obtemDescSegmento IN h-bcapi017 (tt-campos.segmento, OUTPUT tt-cabec-campos.descricao).
         IF RETURN-VALUE = "NOK":U THEN
            ASSIGN tt-cabec-campos.descricao = STRING(tt-campos.segmento).
      END.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvaTransacao wWindow 
PROCEDURE salvaTransacao :
/*------------------------------------------------------------------------------
  Purpose:     Salva tt-campos em bc-trans-filho
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   EMPTY TEMP-TABLE tt-xml.
   RUN geraXML IN h-bcapi017 (INPUT TABLE tt-campos, OUTPUT TABLE tt-xml).
    
   /* Atualiza dados da transa‡Æo. Cada tt-xml corresponde a um bc-trans-filho */
   FOR EACH tt-xml:
      FIND NEXT bc-trans-filho 
          WHERE bc-trans-filho.nr-trans = p-nr-trans EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAIL bc-trans-filho OR bc-trans-filho.num-layout-registro <> tt-xml.segmento
         OR bc-trans-filho.cod-aux[1] <> STRING(tt-xml.registro) THEN DO:
         RUN utp/ut-msgs.p ("show":U, 26022, STRING(p-nr-trans)).
         RETURN.
      END.
      ASSIGN bc-trans-filho.conteudo-trans = tt-xml.conteudo.
   END.
   
   /* atualiza estado da transa‡Æo */
   FIND bc-trans WHERE bc-trans.nr-trans = p-nr-trans EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAIL bc-trans THEN DO:
      {utp/ut-table.i mgcld bc-trans 1}
      RUN utp/ut-msgs.p ("show":U, 2, TRIM(RETURN-VALUE)).
   END.
   ASSIGN bc-trans.estado-trans = 1. /* Nova */
   /* define elimina‡Æo de erros */
   ASSIGN p-apaga-erro = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

