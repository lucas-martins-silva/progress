&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i IM3101D 2.00.00.003 } /*** 010003 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM3101D IMP}
&ENDIF

CREATE WIDGET-POOL.
{cdp/cdcfgmat.i} /* include preprocessadores magnus */
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM3101D
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Despesas

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   brDespesas brDespesasConf

/* Parameters Definitions ---                                           */

{cxbo/bocx310a.i tt-desp-embarque}
{cxbo/bocx310a.i tt-desp-embarque-aux}
{cxbo/bocx310a.i tt-desp-embarque-rateio}
{cxbo/bocx310.i  tt-desp-embarque-create}
{cxbo/bocx220h.i tt-selecao-embarque}
{cxbo/bocx225.i tt-ordens-embarque}
{cdp/cd0666.i}                    /* defini»’o da temp-table de erros */

DEF INPUT PARAM TABLE FOR tt-desp-embarque.
DEF INPUT PARAM TABLE FOR tt-selecao-embarque.
DEF INPUT PARAM TABLE FOR tt-desp-embarque-rateio.
DEF INPUT PARAM phCaller AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */

DEF VAR c-desp-desc LIKE desp-imp.descricao NO-UNDO.
DEFINE VARIABLE h-bocx095   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx310   AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-return    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp     AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-cod-desp-selec LIKE desp-imp.cod-desp NO-UNDO.
DEFINE VARIABLE l-desp-rat AS LOGICAL  INITIAL NO   NO-UNDO.
DEFINE VARIABLE c-desp-rat AS CHARACTER   NO-UNDO.
DEF VAR i-seq-erro            AS INT                        NO-UNDO INIT 0.
DEF VAR i-msg                 AS INT                        NO-UNDO.
DEF VAR c-msg                 AS CHAR                       NO-UNDO.
DEF VAR c-char                AS CHAR                       NO-UNDO.
{include/boerrtab.i} /* Definicao tt-bo-erro */
{imp/im0091.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDespesas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-desp-embarque tt-desp-embarque-aux

/* Definitions for BROWSE brDespesas                                    */
&Scoped-define FIELDS-IN-QUERY-brDespesas tt-desp-embarque.cod-desp fnDescricaoDespes(tt-desp-embarque.cod-desp) @ c-desp-desc tt-desp-embarque.val-desp   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDespesas   
&Scoped-define SELF-NAME brDespesas
&Scoped-define QUERY-STRING-brDespesas FOR EACH tt-desp-embarque NO-LOCK
&Scoped-define OPEN-QUERY-brDespesas OPEN QUERY {&SELF-NAME} FOR EACH tt-desp-embarque NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brDespesas tt-desp-embarque
&Scoped-define FIRST-TABLE-IN-QUERY-brDespesas tt-desp-embarque


/* Definitions for BROWSE brDespesasConf                                */
&Scoped-define FIELDS-IN-QUERY-brDespesasConf tt-desp-embarque-aux.embarque tt-desp-embarque-aux.cod-estabel tt-desp-embarque-aux.cod-emitente-desp tt-desp-embarque-aux.val-desp   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDespesasConf   
&Scoped-define SELF-NAME brDespesasConf
&Scoped-define QUERY-STRING-brDespesasConf FOR EACH tt-desp-embarque-aux NO-LOCK
&Scoped-define OPEN-QUERY-brDespesasConf OPEN QUERY {&SELF-NAME} FOR EACH tt-desp-embarque-aux NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brDespesasConf tt-desp-embarque-aux
&Scoped-define FIRST-TABLE-IN-QUERY-brDespesasConf tt-desp-embarque-aux


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brDespesas}~
    ~{&OPEN-QUERY-brDespesasConf}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescricaoDespes wWindow 
FUNCTION fnDescricaoDespes RETURNS CHARACTER
  ( p-cod-despes AS INT )  FORWARD.

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

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 5.25.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 5.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDespesas FOR 
      tt-desp-embarque SCROLLING.

DEFINE QUERY brDespesasConf FOR 
      tt-desp-embarque-aux SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDespesas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDespesas wWindow _FREEFORM
  QUERY brDespesas NO-LOCK DISPLAY
      tt-desp-embarque.cod-desp FORMAT ">>,>>9":U
      fnDescricaoDespes(tt-desp-embarque.cod-desp) @ c-desp-desc FORMAT "x(50)":U
      tt-desp-embarque.val-desp
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 80 BY 4.5
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE brDespesasConf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDespesasConf wWindow _FREEFORM
  QUERY brDespesasConf NO-LOCK DISPLAY
      tt-desp-embarque-aux.embarque FORMAT "X(16)":U      
      tt-desp-embarque-aux.cod-estabel FORMAT "x(5)":U
      tt-desp-embarque-aux.cod-emitente-desp FORMAT ">>>>>>>>9":U
      tt-desp-embarque-aux.val-desp FORMAT ">>>>>,>>>,>>9.99999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 80 BY 4.5
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 15.46 COL 2
     btCancel AT ROW 15.46 COL 13
     btHelp2 AT ROW 15.46 COL 80
     rtToolBar AT ROW 15.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 15.92
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brDespesas AT ROW 1.79 COL 3 WIDGET-ID 200
     brDespesasConf AT ROW 7.58 COL 3 WIDGET-ID 300
     RECT-1 AT ROW 1.42 COL 1.57 WIDGET-ID 2
     RECT-2 AT ROW 7.08 COL 1.57 WIDGET-ID 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 3
         SIZE 84.43 BY 11.83
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
         HEIGHT             = 16.04
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brDespesas RECT-2 fPage1 */
/* BROWSE-TAB brDespesasConf brDespesas fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDespesas
/* Query rebuild information for BROWSE brDespesas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-desp-embarque NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brDespesas */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDespesasConf
/* Query rebuild information for BROWSE brDespesasConf
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-desp-embarque-aux NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brDespesasConf */
&ANALYZE-RESUME

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


&Scoped-define BROWSE-NAME brDespesas
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brDespesas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDespesas wWindow
ON VALUE-CHANGED OF brDespesas IN FRAME fPage1
DO:
  ASSIGN i-cod-desp-selec = tt-desp-embarque.cod-desp.
  RUN pi-atualiza-browse-conf.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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
    RUN utp/ut-msgs.p (INPUT "show":u,
                       INPUT 55626,
                       INPUT "").
    IF RETURN-VALUE = "YES":U THEN DO:
        DO TRANS:
            IF CAN-FIND(FIRST tt-desp-embarque-rateio) THEN DO:
                RUN pi-confirma.
                IF RETURN-VALUE = "OK":U THEN DO:
                    RUN pi-seleciona-desp-rateio IN phCaller (INPUT TABLE tt-desp-embarque-rateio).
                    APPLY "CLOSE":U TO THIS-PROCEDURE.
                END.
                ELSE
                    UNDO, LEAVE.
            END.
            ELSE
                APPLY "CLOSE":U TO THIS-PROCEDURE.
        END.
    END.    
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
IF VALID-HANDLE(h-bocx095) THEN DO:
   delete procedure h-bocx095.
END.

IF VALID-HANDLE(h-bocx310) THEN DO:
   delete procedure h-bocx310.
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

{&OPEN-QUERY-brDespesas}

ASSIGN l-desp-rat = NO
       c-desp-rat = "".

FOR EACH tt-desp-embarque:    
    ASSIGN c-return = "".
    RUN findCodigo IN h-bocx310 (INPUT tt-desp-embarque.cod-estabel,
                                 INPUT tt-desp-embarque.embarque,
                                 INPUT tt-desp-embarque.cod-itiner,
                                 INPUT tt-desp-embarque.cod-pto-contr,
                                 INPUT tt-desp-embarque.cod-desp,
                                 OUTPUT c-return).            
    IF  c-return = "":U THEN
        run getLogField in h-bocx310 (input "log-prorate-efetd":U,output l-desp-rat). 
    
    IF  l-desp-rat THEN
        IF  c-desp-rat = "" THEN
            ASSIGN c-desp-rat = STRING(tt-desp-embarque.cod-desp).
        ELSE DO:
            IF  INDEX(c-desp-rat, STRING(tt-desp-embarque.cod-desp)) = 0 THEN
                ASSIGN c-desp-rat = c-desp-rat + ' , ' + STRING(tt-desp-embarque.cod-desp).
        END.
END.

IF  c-desp-rat = "" THEN
    RUN pi-rateia-despesas.
ELSE
    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 55627,
                       INPUT c-desp-rat).
    IF RETURN-VALUE = "YES":U THEN
        RUN pi-rateia-despesas.

RETURN "OK":U.

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
RUN cxbo/bocx095.p persistent set h-bocx095.
RUN cxbo/bocx310.p persistent set h-bocx310.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-browse-conf wWindow 
PROCEDURE pi-atualiza-browse-conf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE tt-desp-embarque-aux.

FOR EACH tt-desp-embarque-rateio
    WHERE tt-desp-embarque-rateio.cod-desp = i-cod-desp-selec:
    
    IF NOT CAN-FIND(FIRST tt-desp-embarque-aux 
                    WHERE tt-desp-embarque-aux.embarque    = tt-desp-embarque-rateio.embarque
                    AND   tt-desp-embarque-aux.cod-estabel = tt-desp-embarque-rateio.cod-estabel
                    AND   tt-desp-embarque-aux.cod-desp    = tt-desp-embarque-rateio.cod-desp) THEN DO:
        CREATE tt-desp-embarque-aux.
        BUFFER-COPY tt-desp-embarque-rateio TO tt-desp-embarque-aux.
    END.
    ELSE DO:
        FOR FIRST tt-desp-embarque-aux 
            WHERE tt-desp-embarque-aux.embarque    = tt-desp-embarque-rateio.embarque
            AND   tt-desp-embarque-aux.cod-estabel = tt-desp-embarque-rateio.cod-estabel
            AND   tt-desp-embarque-aux.cod-desp    = tt-desp-embarque-rateio.cod-desp:
            ASSIGN tt-desp-embarque-aux.val-desp = tt-desp-embarque-aux.val-desp + tt-desp-embarque-rateio.val-desp.
        END.
    END.
END.
{&OPEN-QUERY-brDespesasConf}
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-confirma wWindow 
PROCEDURE pi-confirma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var d-val-desp-ant     like desp-embarque.val-desp  NO-UNDO.

    FOR EACH tt-desp-embarque-rateio,
        FIRST tt-desp-embarque
        WHERE tt-desp-embarque.cod-desp = tt-desp-embarque-rateio.cod-desp:

        FOR FIRST desp-embarque NO-LOCK
            WHERE desp-embarque.embarque    = tt-desp-embarque.embarque
            AND   desp-embarque.cod-estabel = tt-desp-embarque.cod-estabel
            AND   desp-embarque.cod-desp    = tt-desp-embarque.cod-desp: END.

        EMPTY TEMP-TABLE tt-desp-embarque-create.
        CREATE tt-desp-embarque-create.
        ASSIGN tt-desp-embarque-create.embarque                 = tt-desp-embarque-rateio.embarque        
               tt-desp-embarque-create.cod-estabel              = tt-desp-embarque-rateio.cod-estabel     
               tt-desp-embarque-create.cod-itiner               = tt-desp-embarque-rateio.cod-itiner      
               tt-desp-embarque-create.cod-pto-contr            = tt-desp-embarque-rateio.cod-pto-contr   
               tt-desp-embarque-create.cod-desp                 = tt-desp-embarque-rateio.cod-desp        
               tt-desp-embarque-create.cod-emitente-desp        = tt-desp-embarque-rateio.cod-emitente-desp
               tt-desp-embarque-create.cod-cond-pag             = desp-embarque.cod-cond-pag
               tt-desp-embarque-create.cod-incoterm-rat         = desp-embarque.cod-incoterm-rat       
               tt-desp-embarque-create.data-implant             = desp-embarque.data-implant           
               tt-desp-embarque-create.log-cotac-atlzdo         = desp-embarque.log-cotac-atlzdo       
               tt-desp-embarque-create.log-despes-ja-recbda     = desp-embarque.log-despes-ja-recbda   
               tt-desp-embarque-create.log-forma-preco-compra   = desp-embarque.log-forma-preco-compra 
               tt-desp-embarque-create.mo-codigo                = desp-embarque.mo-codigo
               tt-desp-embarque-create.observacao               = desp-embarque.observacao
               tt-desp-embarque-create.val-desp                 = tt-desp-embarque-rateio.val-desp
               tt-desp-embarque-create.log-prorate-efetd        = TRUE.

        ASSIGN c-return = "".
        run findCodigo in h-bocx095 (input tt-desp-embarque-create.cod-desp,output c-return).
        if  c-return = "" then
            run getCharfield in h-bocx095 (input "descricao":U,output tt-desp-embarque-create.descricao). 

        ASSIGN c-return = "".
        RUN findCodigo IN h-bocx310 (INPUT tt-desp-embarque-create.cod-estabel,
                                     INPUT tt-desp-embarque-create.embarque,
                                     INPUT tt-desp-embarque-create.cod-itiner,
                                     INPUT tt-desp-embarque-create.cod-pto-contr,
                                     INPUT tt-desp-embarque-create.cod-desp,
                                     OUTPUT c-return).            
        IF c-return = "":U THEN DO:  
            ASSIGN tt-desp-embarque-create.r-rowid = ROWID(desp-embarque).
            RUN setaExecutaRateioInternacional IN h-bocx310.
            RUN validateUpdate    IN h-bocx310 (INPUT  TABLE tt-desp-embarque-create,
                                                INPUT  tt-desp-embarque-create.r-rowid,
                                                OUTPUT TABLE RowErrors).
        END.                                                                                     
        ELSE DO:
            RUN validateCreate IN h-bocx310 (INPUT TABLE tt-desp-embarque-create,
                                             OUTPUT TABLE RowErrors,
                                             OUTPUT tt-desp-embarque-create.r-rowid).
        END.
    END.

    IF CAN-FIND(FIRST RowErrors) THEN DO:

        IF NOT VALID-HANDLE(hShowMsg) THEN 
            RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
        
        RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
        LEAVE.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-erro wWindow 
PROCEDURE pi-gera-erro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN i-seq-erro = i-seq-erro + 1.
    RUN utp/ut-msgs.p (INPUT "msg":U,
                       INPUT i-msg,
                       INPUT c-msg).
    DO  TRANSACTION:
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = i-seq-erro
               tt-erro.cd-erro  = i-msg
               tt-erro.mensagem = RETURN-VALUE + c-char.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-rateia-despesas wWindow 
PROCEDURE pi-rateia-despesas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var h-im0091 as handle no-undo.

    IF NOT VALID-HANDLE(h-acomp) THEN
        run utp/ut-acomp.p persistent set h-acomp.

    {utp/ut-liter.i Rateando_Despesas *}
    run pi-inicializar in h-acomp(input RETURN-VALUE).

    /* Rateio das despesas informadas para o embarque */
    run imp/im0091.p persistent set h-im0091.

    FOR FIRST tt-selecao-embarque: END.
    run setaValorinicial in h-im0091 (input TODAY,
                                      input tt-selecao-embarque.cod-estabel).

    run rateioEmbarquesComplementar   in h-im0091 (input table tt-selecao-embarque,
                                                   input table tt-desp-embarque).

    run getTTdesp-rateio   in h-im0091 (output table tt-desp-rateio).
    run getTTbo-erro       in h-im0091 (output table tt-bo-erro).
    
    IF NOT CAN-FIND(FIRST tt-bo-erro) THEN DO:
        RUN piCriaDespEmbRateio IN h-im0091 (OUTPUT TABLE tt-desp-embarque-rateio).
        APPLY "VALUE-CHANGED" TO brDespesas IN FRAME fPage1.
    END.
    
    for each tt-bo-erro:
        assign i-msg = tt-bo-erro.cd-erro
               c-msg = tt-bo-erro.parametros
               c-char= "".
        run pi-gera-erro.
    end.

    IF VALID-HANDLE(h-acomp) THEN
        run pi-finalizar in h-acomp. 

    DELETE PROCEDURE h-im0091.

    IF CAN-FIND(FIRST tt-erro) THEN DO:
        run cdp/cd0666.w (input table tt-erro).
        RETURN "NOK":U.
    END.
    
    

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescricaoDespes wWindow 
FUNCTION fnDescricaoDespes RETURNS CHARACTER
  ( p-cod-despes AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  run findCodigo in h-bocx095 (input p-cod-despes,output c-return).
  if c-return = "" then
      run getCharfield in h-bocx095 (input "descricao":U,output c-desp-desc).  

  RETURN c-desp-desc.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

