&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-param NO-UNDO LIKE mab-param
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0101 2.00.00.009 } /*** "010009" 31/03/2025 10:17:08  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0101 MAB}
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
&GLOBAL-DEFINE Program        AB0101
&GLOBAL-DEFINE Version        2.00.00.009

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   ParÉmetros, M¢dulos

&GLOBAL-DEFINE page0Widgets    btQueryJoins btReportsJoins btExit btHelp btImprimir
                              

&GLOBAL-DEFINE page1Widgets   brParam
&GLOBAL-DEFINE page2Widgets   brModulos
  
{abp/ab0101.i} /* definiá∆o da temp-table ttParam */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE hDBOParam      AS HANDLE                     NO-UNDO.
DEFINE VARIABLE hDBOEqpto      AS HANDLE                     NO-UNDO.
DEFINE VARIABLE cValor         AS CHARACTER FORMAT "x(20)":U NO-UNDO.
DEFINE VARIABLE lok            AS LOGICAL                    NO-UNDO.
DEFINE VARIABLE c-valor-browse AS CHARACTER FORMAT "x(35)":U NO-UNDO.
DEFINE VARIABLE c-format-log   AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE iNrEqptoReal   AS INTEGER                    NO-UNDO.

DEFINE BUFFER b-ttParam   FOR ttParam.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brModulos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttModulos ttParam

/* Definitions for BROWSE brModulos                                     */
&Scoped-define FIELDS-IN-QUERY-brModulos ttModulos.cdn-modulo ttModulos.des-modulo ttModulos.log-ativo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brModulos ttModulos.log-ativo   
&Scoped-define ENABLED-TABLES-IN-QUERY-brModulos ttModulos
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brModulos ttModulos
&Scoped-define SELF-NAME brModulos
&Scoped-define QUERY-STRING-brModulos FOR EACH ttModulos NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brModulos OPEN QUERY {&SELF-NAME} FOR EACH ttModulos NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brModulos ttModulos
&Scoped-define FIRST-TABLE-IN-QUERY-brModulos ttModulos


/* Definitions for BROWSE brParam                                       */
&Scoped-define FIELDS-IN-QUERY-brParam ttParam.cdn-param ttParam.des-label-param fnValor(ttParam.des-valor, ttParam.cdn-param) @ c-valor-browse   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brParam   
&Scoped-define SELF-NAME brParam
&Scoped-define QUERY-STRING-brParam FOR EACH ttParam NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brParam OPEN QUERY {&SELF-NAME} FOR EACH ttParam NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brParam ttParam
&Scoped-define FIRST-TABLE-IN-QUERY-brParam ttParam


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brParam}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brModulos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 rtToolBar-2 btImprimir btQueryJoins ~
btReportsJoins btExit btHelp fi-maximo-eqptos fi-eqptos-cadastrados 
&Scoped-Define DISPLAYED-OBJECTS fi-maximo-eqptos fi-eqptos-cadastrados 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnValor wWindow 
FUNCTION fnValor RETURNS CHARACTER
  ( p-valor     AS CHAR,
    p-cdn-param AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miImprimir     LABEL "&Imprimir"      ACCELERATOR "CTRL-P"
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
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

DEFINE BUTTON btImprimir 
     IMAGE-UP FILE "image/im-prigr.bmp":U
     LABEL "Impress∆o" 
     SIZE 4 BY 1.25 TOOLTIP "Impress∆o".

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

DEFINE VARIABLE fi-eqptos-cadastrados AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Equipamentos Cadastrados" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-maximo-eqptos AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "M†ximo Equipamentos Controlados" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 1.25.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAltera 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btAlteraPag2 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brModulos FOR 
      ttModulos SCROLLING.

DEFINE QUERY brParam FOR 
      ttParam SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brModulos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brModulos wWindow _FREEFORM
  QUERY brModulos DISPLAY
      ttModulos.cdn-modulo LABEL "C¢digo"
    ttModulos.des-modulo LABEL "Descriá∆o"
    ttModulos.log-ativo  LABEL "Implantado"
    ENABLE
    ttModulos.log-ativo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 82 BY 9.21
         FONT 2.

DEFINE BROWSE brParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brParam wWindow _FREEFORM
  QUERY brParam DISPLAY
      ttParam.cdn-param LABEL "C¢digo":U WIDTH 08
      ttParam.des-label-param  FORMAT "x(80)":U LABEL "Descriá∆o":U  WIDTH 35
      fnValor(ttParam.des-valor, ttParam.cdn-param) @ c-valor-browse FORMAT "x(35)":U LABEL "Valor":U  WIDTH 30
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.21
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btImprimir AT ROW 1.13 COL 69.72 HELP
          "Impress∆o"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     fi-maximo-eqptos AT ROW 2.67 COL 27.29 COLON-ALIGNED
     fi-eqptos-cadastrados AT ROW 2.67 COL 69.14 COLON-ALIGNED
     RECT-1 AT ROW 2.5 COL 1.57
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 15.54
         FONT 1.

DEFINE FRAME fPage1
     brParam AT ROW 1 COL 2
     btAltera AT ROW 10.21 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5.5
         SIZE 84.43 BY 10.5
         FONT 1.

DEFINE FRAME fPage2
     brModulos AT ROW 1 COL 2
     btAlteraPag2 AT ROW 10.21 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5.5
         SIZE 84.43 BY 10.5
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: TTmab-param T "?" NO-UNDO mgfro mab-param
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
         HEIGHT             = 15.5
         WIDTH              = 90.43
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.21
         VIRTUAL-WIDTH      = 146.29
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

{utp/ut-glob.i}
{btb/btb008za.i0}
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
/* BROWSE-TAB brParam 1 fPage1 */
ASSIGN 
       brParam:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       brParam:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brModulos 1 fPage2 */
ASSIGN 
       brModulos:COLUMN-RESIZABLE IN FRAME fPage2       = TRUE
       brModulos:COLUMN-MOVABLE IN FRAME fPage2         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brModulos
/* Query rebuild information for BROWSE brModulos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttModulos NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brModulos */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brParam
/* Query rebuild information for BROWSE brParam
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttParam NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brParam */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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


&Scoped-define BROWSE-NAME brModulos
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME brModulos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brModulos wWindow
ON ROW-DISPLAY OF brModulos IN FRAME fPage2
DO:
    ASSIGN ttModulos.log-ativo:FORMAT IN BROWSE brModulos = c-format-log.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brModulos wWindow
ON ROW-LEAVE OF brModulos IN FRAME fPage2
DO:
    FIND FIRST funcao
         WHERE funcao.cd-funcao = ttModulos.cd-funcao EXCLUSIVE-LOCK NO-ERROR.
    IF  AVAIL funcao THEN DO:
        ttModulos.log-ativo = INPUT BROWSE brModulos ttModulos.log-ativo.
        IF  funcao.ativo <> ttModulos.log-ativo THEN DO:
            ASSIGN funcao.ativo = ttModulos.log-ativo.
        END.
    END.
    ELSE DO:
        ttModulos.log-ativo = INPUT BROWSE brModulos ttModulos.log-ativo.
        IF  ttModulos.log-ativo THEN DO:
            CREATE funcao.
            ASSIGN funcao.cd-funcao = ttModulos.cd-funcao
                   funcao.ativo = ttModulos.log-ativo.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brParam
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brParam wWindow
ON MOUSE-SELECT-DBLCLICK OF brParam IN FRAME fPage1
DO:
    IF ttparam.cdn-param <> 35 THEN   
        apply "choose":U to btAltera in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brParam wWindow
ON VALUE-CHANGED OF brParam IN FRAME fPage1
DO:
    IF brParam:NUM-SELECTED-ROWS in frame fPage1 > 0 THEN
        ENABLE  btAltera WITH FRAME fPage1.
    ELSE DISABLE btAltera WITH FRAME fPage1.

    IF ttparam.cdn-param = 35 THEN DISABLE btAltera WITH FRAME fPage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAltera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAltera wWindow
ON CHOOSE OF btAltera IN FRAME fPage1 /* Alterar */
DO:
    DEFINE VARIABLE iCdParam AS INTEGER    NO-UNDO.

    get current brParam.

    IF brParam:NUM-SELECTED-ROWS > 0 THEN DO ON ERROR UNDO, RETURN NO-APPLY:
        find ttParam
            where ttParam.cdn-param = int(ttParam.cdn-param:screen-value in browse brParam) no-error.
        IF AVAIL ttParam THEN do:
            ASSIGN iCdParam = ttParam.cdn-param .

            RUN piAlterar in this-procedure.
                
            if lOK then
                run openQueryBrowse in this-procedure.
            find first b-ttParam
                 where b-ttParam.cdn-param = iCdParam no-lock no-error.
            if  avail b-ttParam then do:
                reposition brParam to rowid rowid(b-ttParam).
            end.
        end.
    end.

    apply "Entry":U to btAltera in FRAME fPage1.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btAlteraPag2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAlteraPag2 wWindow
ON CHOOSE OF btAlteraPag2 IN FRAME fPage2 /* Alterar */
DO:
    APPLY "ENTRY":U TO ttModulos.log-ativo IN BROWSE brModulos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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


&Scoped-define SELF-NAME btImprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImprimir wWindow
ON CHOOSE OF btImprimir IN FRAME fpage0 /* Impress∆o */
OR CHOOSE OF MENU-ITEM miImprimir IN MENU smFile DO:
    RUN piImprimir IN THIS-PROCEDURE.
    APPLY "ENTRY":U TO btImprimir IN FRAME fPage0.
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


&Scoped-define BROWSE-NAME brModulos
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterChangePage wWindow 
PROCEDURE afterChangePage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-nr-pag AS INTEGER NO-UNDO.

    RUN getCurrentFolder IN hFolder (OUTPUT i-nr-pag).
    IF  i-nr-pag = 2 THEN
        brModulos:select-row(1) IN FRAME fPage2.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF VALID-HANDLE(hDBOParam)
     THEN RUN destroy in hDBOParam.
     
       
    
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
    DEFINE VARIABLE cRetorno AS CHARACTER NO-UNDO.
    DEFINE BUFFER bf-mab-param FOR mab-param.
    
    IF  brParam:NUM-SELECTED-ROWS in frame fPage1 > 0 THEN DO:
        enable  btAltera with frame fPage1.
    END.
   
    ELSE DO:
        disable btAltera with frame fPage1.
    END.
     
    {utp/ut-liter.i "C¢digo"}
    assign ttParam.cdn-param:label in BROWSE brParam = return-value.
    {utp/ut-liter.i "Descriá∆o"}
    assign ttParam.des-label-param:label in  BROWSE brParam = return-value.
    {utp/ut-liter.i "Valor"}
    assign c-valor-browse:label in  BROWSE brParam = return-value.
    
    FOR FIRST bf-mab-param
        WHERE bf-mab-param.cdn-param = 1 NO-LOCK:
        IF  bf-mab-param.num-livre-1 = 0 THEN DO:
            /*--- Seta cursor do mouse para espera ---*/
            session:SET-WAIT-STATE("GENERAL":U).
            {&window-name}:sensitive = no.
    
            /*--- Visualizacao da Janela ---*/
            VIEW wWindow.
    
            RUN abp/ab0101c.w (OUTPUT cRetorno).
    
            IF  cRetorno = "NOK":U THEN DO:
                RETURN "NOK":U.
            END.
            ELSE DO:
                /*--- Seta cursor do mouse para espera ---*/
                session:SET-WAIT-STATE("":U).
                {&window-name}:sensitive = YES.
                ASSIGN fi-maximo-eqptos = bf-mab-param.num-livre-1.
                DISP fi-maximo-eqptos WITH FRAME fPage0.
            END.
        END.
        ELSE DO:
            ASSIGN fi-maximo-eqptos = bf-mab-param.num-livre-1.
            DISP fi-maximo-eqptos WITH FRAME fPage0.
        END.
    END.
    
    ASSIGN fi-eqptos-cadastrados = iNrEqptoReal.
    DISPLAY fi-eqptos-cadastrados WITH FRAME fPage0.

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
    {utp/ut-liter.i Sim/N∆o *}
    ASSIGN c-format-log = RETURN-VALUE.
  
    IF  NOT VALID-HANDLE(hDBOParam) OR
        hDBOParam:TYPE <> "PROCEDURE":U OR
        hDBOParam:FILE-NAME <> "frbo/bofr019.p":U THEN DO:
        RUN frbo/bofr019.p PERSISTENT SET  hDBOParam.
    END.
    RUN OpenQueryStatic IN hDBOParam (INPUT "Main":U).

    IF  NOT VALID-HANDLE(hDBOEqpto) OR
        hDBOParam:TYPE <> "PROCEDURE":U OR
        hDBOParam:FILE-NAME <> "frbo/bofr007.p":U THEN DO:
        RUN frbo/bofr007.p PERSISTENT SET  hDBOEqpto.
    END.
    RUN OpenQueryStatic IN hDBOEqpto (INPUT "Main":U).
    RUN calcEqptoCadastrados IN hDBOEqpto (OUTPUT iNrEqptoReal).

    RUN getFirst in hDBOParam.
    run openQueryBrowse in this-procedure.
   
      
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getOk wWindow 
PROCEDURE getOk :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define INPUT parameter pOk as logical no-undo.

assign lOk = pOk.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryBrowse wWindow 
PROCEDURE openQueryBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN abp/ab0101a.p (OUTPUT TABLE ttParam,
                   OUTPUT TABLE ttModulos).
OPEN QUERY brParam FOR EACH ttParam.
    IF brParam:NUM-SELECTED-ROWS in frame fPage1 > 0 THEN
         enable  btAltera with frame fPage1.
    ELSE disable btAltera with frame fPage1.

{&OPEN-QUERY-brModulos}
IF  AVAIL ttModulos THEN
    ASSIGN btAlteraPag2:SENSITIVE IN FRAME fPage2 = YES.
ELSE
    ASSIGN btAlteraPag2:SENSITIVE IN FRAME fPage2 = NO.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAlterar wWindow 
PROCEDURE piAlterar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hProgram          AS HANDLE NO-UNDO.

    /*--- Seta cursor do mouse para espera ---*/
    SESSION:SET-WAIT-STATE("GENERAL":U).
    {&WINDOW-NAME}:SENSITIVE = NO.
   
    /*--- Executa programa de consulta ---*/
    RUN abp/ab0101b.w PERSISTENT SET hProgram (INPUT ttParam.cdn-param,
                                               INPUT ttParam.des-label-param, 
                                               INPUT THIS-PROCEDURE,
                                               INPUT-OUTPUT cValor).
    
    /** Validaá∆o do Handle **/
    IF  VALID-HANDLE(hProgram) AND
        hProgram:TYPE = "PROCEDURE":U AND
        hProgram:FILE-NAME = "abp/ab0101b.w":U THEN DO:
        /*--- Inicializa programa de alteraá∆o dos parÉmetros ---*/
        RUN initializeInterface IN hProgram. 
    END.
    
    /** Espera pelo fechamento do programa **/
    WAIT-FOR "CLOSE":U of hProgram.
    IF  VALID-HANDLE(hProgram) THEN
        DELETE PROCEDURE hProgram.
    
    /*--- Seta cursor do mouse para espera ---*/
    SESSION:SET-WAIT-STATE("":U).
    {&WINDOW-NAME}:SENSITIVE = YES.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimir wWindow 
PROCEDURE piImprimir :
/*------------------------------------------------------------------------------
  Purpose:     piImprimir
  Parameters:  <none>
  Notes:       Chama tela de impress∆o de relat¢rio
------------------------------------------------------------------------------*/
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN abp/ab0101d.w (INPUT fi-maximo-eqptos:SCREEN-VALUE      IN FRAME fPage0,
                       INPUT fi-eqptos-cadastrados:SCREEN-VALUE IN FRAME fPage0,
                       INPUT TABLE ttParam,
                       INPUT TABLE ttModulos).

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnValor wWindow 
FUNCTION fnValor RETURNS CHARACTER
  ( p-valor     AS CHAR,
    p-cdn-param AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  retorna o valor ao browse.
    Notes:  fnValor(ttParam.des-valor, ttParam.cdn-param) @ c-valor-browse FORMAT "x(35)":U LABEL "Valor":U  WIDTH 30
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-retorno AS CHARACTER FORMAT "X(35)":U NO-UNDO.
  
  IF p-cdn-param = 43 OR p-cdn-param = 44 OR p-cdn-param = 47 OR p-cdn-param = 48 OR p-cdn-param = 51 or p-cdn-param = 52 or p-cdn-param = 53 or p-cdn-param = 55 or p-cdn-param = 56 OR p-cdn-param = 57 OR p-cdn-param = 58 THEN DO:
      {utp/ut-liter.i Sim/N∆o *}
      ASSIGN c-retorno = ENTRY (INT(TRIM(p-valor)), trim(RETURN-VALUE) , "/":U ).
  END.
  else
      ASSIGN c-retorno = p-valor.

  IF p-cdn-param = 54 THEN DO:
      DEFINE VARIABLE cAuxTraducao054 AS CHARACTER NO-UNDO.
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
          ASSIGN cAuxTraducao054 = "Permite Sem Avisar, Avisa e Permite, N∆o Permite".
          RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao054).
      &else 
          ASSIGN cAuxTraducao054 = "Permite Sem Avisar, Avisa e Permite, N∆o Permite".
      &endif 
      ASSIGN c-retorno = TRIM(ENTRY(INT(p-valor),cAuxTraducao054,",")).
  END.

  RETURN c-retorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

