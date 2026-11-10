&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcld            PROGRESS
*/
&Scoped-define WINDOW-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0605 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0605 MBC}
&ENDIF




/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var c-lit-programa as char    no-undo.
def var c-prog         as char    no-undo.
def var l-ok           as logical no-undo.
def var c-lit-progtxt  as char    no-undo.
def var c-lit-todos    as char    no-undo.
def var c-lista        as char    no-undo.
def var i              as int     no-undo.
def var c-arq          as char    no-undo.
def var c-arquiv       as char    no-undo.
def var c-importacao   as char    no-undo.
def var h-acomp        as handle  no-undo.
def var c-imp-exp      as char    no-undo.
def var wh-pesquisa    as handle  no-undo.
DEF VAR i-num-versao   AS INT     NO-UNDO.
DEF VAR i-num-lay-reg  AS INT     NO-UNDO.
DEF VAR l-ignora       AS LOG     NO-UNDO.

DEF TEMP-TABLE tt-bc-layout NO-UNDO
    FIELD tabela      AS CHAR    FORMAT "x(50)"
    FIELD cod-layout  AS INTEGER 
    FIELD log-datasul AS LOGICAL
    FIELD num-versao  AS INTEGER
    FIELD conteudo    AS RAW.

DEF TEMP-TABLE tt-bc-layout-aux               NO-UNDO LIKE bc-layout.
DEF TEMP-TABLE tt-bc-layout-registro-aux      NO-UNDO LIKE bc-layout-registro.
DEF TEMP-TABLE tt-bc-layout-registro-item-aux NO-UNDO LIKE bc-layout-registro-item.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rs-imp-exp iIniCodLayout iEndCodLayout ~
lIniLogDatasul lEndLogDatasul iIniNumVersao iEndNumVersao rs-lay-exist ~
c-arquivo bt-arquivo bt-ok bt-cancelar bt-ajuda c-texto c-texto-2 c-texto-3 ~
IMAGE-10 IMAGE-11 IMAGE-12 IMAGE-7 IMAGE-8 IMAGE-9 RECT-1 RECT-12 RECT-13 ~
RECT-14 RECT-15 
&Scoped-Define DISPLAYED-OBJECTS rs-imp-exp iIniCodLayout iEndCodLayout ~
lIniLogDatasul lEndLogDatasul iIniNumVersao iEndNumVersao rs-lay-exist ~
c-arquivo c-texto c-texto-2 c-texto-3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image~\im-fold":U
     IMAGE-INSENSITIVE FILE "image~\ii-fold":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-arquivo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 52 BY .88 NO-UNDO.

DEFINE VARIABLE c-texto AS CHARACTER FORMAT "X(256)":U INITIAL "Tipo de Processo" 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

DEFINE VARIABLE c-texto-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Seleá∆o" 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE VARIABLE c-texto-3 AS CHARACTER FORMAT "X(256)":U INITIAL "Layout Existentes" 
      VIEW-AS TEXT 
     SIZE 18 BY .67 NO-UNDO.

DEFINE VARIABLE iEndCodLayout AS INTEGER FORMAT ">>>9" INITIAL 9999 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88 NO-UNDO.

DEFINE VARIABLE iEndNumVersao AS INTEGER FORMAT ">>>9" INITIAL 9999 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88 NO-UNDO.

DEFINE VARIABLE iIniCodLayout LIKE bc-layout.cod-layout
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88 NO-UNDO.

DEFINE VARIABLE iIniNumVersao LIKE bc-layout.num-versao
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88 NO-UNDO.

DEFINE VARIABLE lEndLogDatasul AS LOGICAL FORMAT "yes/no":U INITIAL YES 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE lIniLogDatasul AS LOGICAL FORMAT "yes/no":U INITIAL NO 
     LABEL "Datasul" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image~\im-las":U
     SIZE 3 BY .75.

DEFINE IMAGE IMAGE-11
     FILENAME "image~\im-fir":U
     SIZE 3 BY .75.

DEFINE IMAGE IMAGE-12
     FILENAME "image~\im-las":U
     SIZE 3 BY .75.

DEFINE IMAGE IMAGE-7
     FILENAME "image~\im-fir":U
     SIZE 3 BY .75.

DEFINE IMAGE IMAGE-8
     FILENAME "image~\im-las":U
     SIZE 3 BY .75.

DEFINE IMAGE IMAGE-9
     FILENAME "image~\im-fir":U
     SIZE 3 BY .75.

DEFINE VARIABLE rs-imp-exp AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Exportaá∆o", 1,
"Importaá∆o", 2
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE rs-lay-exist AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Ignorar", 1,
"Nova Vers∆o", 2,
"Sobrepor", 3
     SIZE 46 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 68 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68 BY 1.75.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68 BY 3.75.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68 BY 1.5.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68 BY 1.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     rs-imp-exp AT ROW 2 COL 4 NO-LABEL
     iIniCodLayout AT ROW 4 COL 11 COLON-ALIGNED
     iEndCodLayout AT ROW 4 COL 37 COLON-ALIGNED NO-LABEL
     lIniLogDatasul AT ROW 5 COL 11 COLON-ALIGNED
     lEndLogDatasul AT ROW 5 COL 37 COLON-ALIGNED NO-LABEL
     iIniNumVersao AT ROW 6 COL 11 COLON-ALIGNED
     iEndNumVersao AT ROW 6 COL 37 COLON-ALIGNED NO-LABEL
     rs-lay-exist AT ROW 8 COL 4 NO-LABEL
     c-arquivo AT ROW 9.75 COL 11 COLON-ALIGNED
     bt-arquivo AT ROW 9.75 COL 65 HELP
          "Configuraá∆o da impressora"
     bt-ok AT ROW 11.46 COL 3
     bt-cancelar AT ROW 11.46 COL 14
     bt-ajuda AT ROW 11.46 COL 59
     c-texto AT ROW 1.25 COL 2 COLON-ALIGNED NO-LABEL
     c-texto-2 AT ROW 3.25 COL 2 COLON-ALIGNED NO-LABEL
     c-texto-3 AT ROW 7.25 COL 2 COLON-ALIGNED NO-LABEL
     IMAGE-10 AT ROW 5 COL 36
     IMAGE-11 AT ROW 6 COL 27
     IMAGE-12 AT ROW 6 COL 36
     IMAGE-7 AT ROW 4 COL 27
     IMAGE-8 AT ROW 4 COL 36
     IMAGE-9 AT ROW 5 COL 27
     RECT-1 AT ROW 11.25 COL 2
     RECT-12 AT ROW 1.5 COL 2
     RECT-13 AT ROW 3.5 COL 2
     RECT-14 AT ROW 9.5 COL 2
     RECT-15 AT ROW 7.5 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 70.14 BY 11.83.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-livre ASSIGN
         HIDDEN             = YES
         TITLE              = "Exportaá∆o/Importaá∆o Layout Etiqueta 2D"
         HEIGHT             = 11.92
         WIDTH              = 70.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-livre 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-livre
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
                                                                        */
/* SETTINGS FOR FILL-IN iIniCodLayout IN FRAME f-cad
   LIKE = mgcld.bc-layout.cod-layout EXP-SIZE                           */
/* SETTINGS FOR FILL-IN iIniNumVersao IN FRAME f-cad
   LIKE = mgcld.bc-layout.num-versao EXP-SIZE                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* Exportaá∆o/Importaá∆o Layout Etiqueta 2D */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* Exportaá∆o/Importaá∆o Layout Etiqueta 2D */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-livre
ON CHOOSE OF bt-ajuda IN FRAME f-cad /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo w-livre
ON CHOOSE OF bt-arquivo IN FRAME f-cad
DO:
  
    {utp/ut-liter.i "Abrir Arquivo" * L}
    assign c-lit-programa = trim(return-value).
    SYSTEM-DIALOG GET-FILE c-prog
       FILTERS c-lit-progtxt "*.2d",
               c-lit-todos "*.*"
       DEFAULT-EXTENSION "*.2d"
       INITIAL-DIR replace(c-arquivo:screen-value in frame {&FRAME-NAME},"/","~\")
       RETURN-TO-START-DIR
       TITLE c-lit-programa
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then
        display c-prog @ c-arquivo with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-livre
ON CHOOSE OF bt-cancelar IN FRAME f-cad /* Cancelar */
DO:
  apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-livre
ON CHOOSE OF bt-ok IN FRAME f-cad /* OK */
DO:
    ASSIGN FILE-INFO:FILE-NAME = INPUT FRAME {&FRAME-NAME} c-arquivo.
/*    
    if rs-imp-exp:screen-value in frame {&FRAME-NAME} = "1" then do:
        if file-info:pathname = ? then do:
            run utp/ut-msgs.p ("show", 4715, c-arquivo:screen-value in frame {&FRAME-NAME}).
            apply "entry" to c-arquivo in frame {&FRAME-NAME}.
            return no-apply.
        end.
        else do:
            if not file-info:file-type matches "*D*" then do:
                run utp/ut-msgs.p ("show", 4715, c-arquivo:screen-value in frame {&FRAME-NAME}).
                apply "entry" to c-arquivo in frame {&FRAME-NAME}.
                return no-apply.
            end.
        end.
    end.
*/    
    IF rs-imp-exp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "2" THEN DO:
        IF FILE-INFO:PATHNAME = ? THEN DO:
            RUN utp/ut-msgs.p ("show", 73, "").
            APPLY "entry":U TO c-arquivo IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.
        ELSE DO:
            IF NOT FILE-INFO:FILE-TYPE MATCHES "*F*" THEN DO:
                RUN utp/ut-msgs.p ("show", 73, "").
                APPLY "entry" TO c-arquivo IN FRAME {&FRAME-NAME}.
                RETURN NO-APPLY.
            END.
        END.
    end.
    
    IF rs-imp-exp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1" THEN
        RUN pi-exportacao.
    ELSE
        RUN pi-importacao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-arquivo w-livre
ON RETURN OF c-arquivo IN FRAME f-cad /* Arquivo */
DO:

  apply "choose" to bt-ok in frame {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-imp-exp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-imp-exp w-livre
ON VALUE-CHANGED OF rs-imp-exp IN FRAME f-cad
DO:
{utp/ut-liter.i Arquivo * L}
assign iIniCodLayout :sensitive in frame {&FRAME-NAME} = (rs-imp-exp:screen-value in frame {&FRAME-NAME} = "1")
       iEndCodLayout :sensitive in frame {&FRAME-NAME} = (rs-imp-exp:screen-value in frame {&FRAME-NAME} = "1")
       lIniLogDatasul:sensitive in frame {&FRAME-NAME} = (rs-imp-exp:screen-value in frame {&FRAME-NAME} = "1")
       lEndLogDatasul:sensitive in frame {&FRAME-NAME} = (rs-imp-exp:screen-value in frame {&FRAME-NAME} = "1")
       iIniNumVersao :sensitive in frame {&FRAME-NAME} = (rs-imp-exp:screen-value in frame {&FRAME-NAME} = "1")
       iEndNumVersao :sensitive in frame {&FRAME-NAME} = (rs-imp-exp:screen-value in frame {&FRAME-NAME} = "1")
       rs-lay-exist  :sensitive in frame {&FRAME-NAME} = NOT(rs-imp-exp:screen-value in frame {&FRAME-NAME} = "1")
       bt-arquivo    :sensitive in frame {&FRAME-NAME} = NOT(rs-imp-exp:screen-value in frame {&FRAME-NAME} = "1")
       c-arquivo     :label     in frame {&FRAME-NAME} = trim(return-value).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-livre 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-livre  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-livre  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-livre  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
  THEN DELETE WIDGET w-livre.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-livre  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY rs-imp-exp iIniCodLayout iEndCodLayout lIniLogDatasul lEndLogDatasul 
          iIniNumVersao iEndNumVersao rs-lay-exist c-arquivo c-texto c-texto-2 
          c-texto-3 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE rs-imp-exp iIniCodLayout iEndCodLayout lIniLogDatasul lEndLogDatasul 
         iIniNumVersao iEndNumVersao rs-lay-exist c-arquivo bt-arquivo bt-ok 
         bt-cancelar bt-ajuda c-texto c-texto-2 c-texto-3 IMAGE-10 IMAGE-11 
         IMAGE-12 IMAGE-7 IMAGE-8 IMAGE-9 RECT-1 RECT-12 RECT-13 RECT-14 
         RECT-15 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-livre.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-livre 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-livre 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-livre 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
/*  run pi-before-initialize.*/

  {include/win-size.i}

{utp/ut9000.i "BC0605" "2.00.00.003"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  {utp/ut-rdset.i rs-imp-exp}
  
  {utp/ut-liter.i Datasul * L}
  assign lIniLogDatasul:label in frame {&FRAME-NAME} = trim(return-value).
  
  {utp/ut-liter.i "Sim/N∆o" * L}
  assign lIniLogDatasul:FORMAT in frame {&FRAME-NAME} = trim(return-value)
         lEndLogDatasul:FORMAT in frame {&FRAME-NAME} = trim(return-value).
  
  apply "value-changed":U to rs-imp-exp in frame {&FRAME-NAME}.
  
  {utp/ut-liter.i Layout * R}
  find first param-bc no-lock no-error.
  if avail param-bc then
      assign c-arquivo:screen-value in frame {&FRAME-NAME} = param-bc.nome-dir-etiq
                                                           + "/":U + TRIM(RETURN-VALUE) + ".2D":U.

    {utp/ut-liter.i Tipo_de_Processo * L}
    assign c-texto:screen-value in frame {&FRAME-NAME} = trim(return-value). 
        
    {utp/ut-liter.i "Definiá∆o Tipo Etiqueta" * L}
    assign c-lit-progtxt = trim(return-value) + " (*.2d)".
    
    {utp/ut-liter.i "Todos os arquivos" * L}
    assign c-lit-todos = trim(return-value) + " (*.*)".
    
    {utp/ut-liter.i Ignorar * L}
    ASSIGN c-lista = TRIM(RETURN-VALUE) + ',1,'.
    
    {utp/ut-liter.i Nova_Vers∆o * L}
    ASSIGN c-lista = c-lista + TRIM(RETURN-VALUE) + ',2,'.
    
    {utp/ut-liter.i Sobrepor * L}
    ASSIGN c-lista = c-lista + TRIM(RETURN-VALUE) + ',3'.
    
    ASSIGN rs-lay-exist:RADIO-BUTTONS IN FRAME {&FRAME-NAME} = c-lista.

/*  run pi-after-initialize.*/
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exportacao w-livre 
PROCEDURE pi-exportacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {utp/ut-liter.i Layout_Etiqueta_2D * L}
    ASSIGN c-arq     = ""
           c-arq     = TRIM(c-arquivo:SCREEN-VALUE IN FRAME {&FRAME-NAME})
           c-arq     = REPLACE(c-arq,"/","~\")
           c-imp-exp = TRIM(RETURN-VALUE)
           INPUT FRAME {&FRAME-NAME} iIniCodLayout
           INPUT FRAME {&FRAME-NAME} iEndCodLayout
           INPUT FRAME {&FRAME-NAME} lIniLogDatasul
           INPUT FRAME {&FRAME-NAME} lEndLogDatasul
           INPUT FRAME {&FRAME-NAME} iIniNumVersao
           INPUT FRAME {&FRAME-NAME} iEndNumVersao.

/*     IF SUBSTRING(c-arq,LENGTH(c-arq) - 2) <> ".2d" THEN DO: */
/*         RUN utp/ut-msgs.p ("show", 26426, ".2d").           */
/*         APPLY "entry" TO c-arquivo IN FRAME {&FRAME-NAME}.  */
/*         RETURN ERROR.                                       */
/*     END.                                                    */

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    {utp/ut-liter.i "Exportaá∆o Layout Etiquetas 2D" * L}
    RUN pi-inicializar IN h-acomp (TRIM(RETURN-VALUE)).

    FOR EACH tt-bc-layout:                   DELETE tt-bc-layout.                   END.
    FOR EACH tt-bc-layout-aux:               DELETE tt-bc-layout-aux.               END.
    FOR EACH tt-bc-layout-registro-aux:      DELETE tt-bc-layout-registro-aux.      END.
    FOR EACH tt-bc-layout-registro-item-aux: DELETE tt-bc-layout-registro-item-aux. END.

    DO ON STOP UNDO, LEAVE
       ON QUIT UNDO, LEAVE:
       
        FOR EACH bc-layout NO-LOCK
            WHERE bc-layout.cod-layout  >= iIniCodLayout
            AND   bc-layout.cod-layout  <= iEndCodLayout
            AND   bc-layout.log-datasul >= lIniLogDatasul
            AND   bc-layout.log-datasul <= lEndLogDatasul
            AND   bc-layout.num-versao  >= iIniNumVersao
            AND   bc-layout.num-versao  <= iEndNumVersao:
            
            RUN pi-acompanhar IN h-acomp (c-imp-exp + ": " + STRING(bc-layout.cod-layout)).
    
            CREATE tt-bc-layout.
            ASSIGN tt-bc-layout.tabela      = "bc-layout":U
                   tt-bc-layout.cod-layout  = bc-layout.cod-layout
                   tt-bc-layout.log-datasul = bc-layout.log-datasul
                   tt-bc-layout.num-versao  = bc-layout.num-versao.
            
            /* **** utilizacao de temp-table por problemas com ORACLE **** */
            /* ****   ao utilizar raw-transfer direto com o tabela    **** */
            CREATE tt-bc-layout-aux.
            BUFFER-COPY bc-layout TO tt-bc-layout-aux.
            RAW-TRANSFER tt-bc-layout-aux TO tt-bc-layout.conteudo.
            
            FOR  EACH bc-layout-registro NO-LOCK
                WHERE bc-layout-registro.cod-layout  = bc-layout.cod-layout
                AND   bc-layout-registro.log-datasul = bc-layout.log-datasul
                AND   bc-layout-registro.num-versao  = bc-layout.num-versao:
                
                CREATE tt-bc-layout.
                ASSIGN tt-bc-layout.tabela      = "bc-layout-registro":U
                       tt-bc-layout.cod-layout  = bc-layout-registro.cod-layout
                       tt-bc-layout.log-datasul = bc-layout-registro.log-datasul
                       tt-bc-layout.num-versao  = bc-layout-registro.num-versao.
                
                /* **** utilizacao de temp-table por problemas com ORACLE **** */
                /* ****   ao utilizar raw-transfer direto com o tabela    **** */
                CREATE tt-bc-layout-registro-aux.
                BUFFER-COPY bc-layout-registro TO tt-bc-layout-registro-aux.
                RAW-TRANSFER tt-bc-layout-registro-aux TO tt-bc-layout.conteudo.
                
                FOR  EACH bc-layout-registro-item NO-LOCK
                    WHERE bc-layout-registro-item.num-layout-registro  = bc-layout-registro.num-layout-registro:
                    
                    CREATE tt-bc-layout.
                    ASSIGN tt-bc-layout.tabela      = "bc-layout-registro-item":U
                           tt-bc-layout.cod-layout  = bc-layout-registro.cod-layout
                           tt-bc-layout.log-datasul = bc-layout-registro.log-datasul
                           tt-bc-layout.num-versao  = bc-layout-registro.num-versao.
                    
                    /* **** utilizacao de temp-table por problemas com ORACLE **** */
                    /* ****   ao utilizar raw-transfer direto com o tabela    **** */
                    CREATE tt-bc-layout-registro-item-aux.
                    BUFFER-COPY bc-layout-registro-item TO tt-bc-layout-registro-item-aux.
                    RAW-TRANSFER tt-bc-layout-registro-item-aux TO tt-bc-layout.conteudo.
                END.
            END.
        END.
        
        OUTPUT TO VALUE(c-arq).
        FOR EACH tt-bc-layout:
            EXPORT tt-bc-layout.
        END.
        OUTPUT CLOSE.
        
        RUN pi-finalizar IN h-acomp.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importacao w-livre 
PROCEDURE pi-importacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN c-arq = ""
           c-arq = TRIM(c-arquivo:SCREEN-VALUE IN FRAME {&FRAME-NAME})
           c-arq = REPLACE(c-arq,"/","~\")
           INPUT FRAME {&FRAME-NAME} rs-lay-exist.
           
/*     IF SUBSTRING(c-arq,LENGTH(c-arq) - 2) <> ".2d" THEN DO: */
/*         RUN utp/ut-msgs.p ("show", 26426, ".2d").           */
/*         APPLY "entry" TO c-arquivo IN FRAME {&FRAME-NAME}.  */
/*         RETURN ERROR.                                       */
/*     END.                                                    */

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    {utp/ut-liter.i "Importaá∆o Layout Etiquetas 2D" * L}
    RUN pi-inicializar IN h-acomp (TRIM(RETURN-VALUE)).

    {utp/ut-liter.i Etiqueta_2D * L}
    ASSIGN c-imp-exp = trim(RETURN-VALUE).

    FOR EACH tt-bc-layout:                   DELETE tt-bc-layout.                   END.
    FOR EACH tt-bc-layout-aux:               DELETE tt-bc-layout-aux.               END.
    FOR EACH tt-bc-layout-registro-aux:      DELETE tt-bc-layout-registro-aux.      END.
    FOR EACH tt-bc-layout-registro-item-aux: DELETE tt-bc-layout-registro-item-aux. END.

    INPUT FROM VALUE(c-arq).
    REPEAT:
        CREATE tt-bc-layout.
        IMPORT tt-bc-layout.
    END.
    
    DO ON STOP UNDO, LEAVE
       ON QUIT UNDO, LEAVE:
        
        bl-lay:       
        FOR EACH tt-bc-layout:
            CASE tt-bc-layout.tabela:
                WHEN "bc-layout":U THEN DO:
                    ASSIGN l-ignora = NO.
                    
                    RUN pi-acompanhar IN h-acomp (c-imp-exp + ": " + STRING(tt-bc-layout.cod-layout)).
                    
                    FIND bc-layout NO-LOCK
                        WHERE bc-layout.cod-layout  = tt-bc-layout.cod-layout
                        AND   bc-layout.log-datasul = tt-bc-layout.log-datasul
                        AND   bc-layout.num-versao  = tt-bc-layout.num-versao  NO-ERROR.
        
                    IF AVAIL bc-layout THEN DO:
                        CASE rs-lay-exist:
                            WHEN 1 THEN /* ignorar */ DO: 
                                ASSIGN l-ignora = YES.
                                NEXT bl-lay.
                            END.
                            WHEN 2 THEN /* nova versao */ DO:
                                FIND LAST bc-layout NO-LOCK
                                    WHERE bc-layout.cod-layout  = tt-bc-layout.cod-layout
                                    AND   bc-layout.log-datasul = tt-bc-layout.log-datasul NO-ERROR.
                                ASSIGN i-num-versao = bc-layout.num-versao + 1.
                                
                                CREATE tt-bc-layout-aux.
                                RAW-TRANSFER tt-bc-layout.conteudo TO tt-bc-layout-aux.
                                CREATE bc-layout.
                                BUFFER-COPY tt-bc-layout-aux TO bc-layout
                                    ASSIGN bc-layout.num-versao = i-num-versao.
                            END.
                            WHEN 3 THEN /* sobrepor */ DO:
                                FOR EACH bc-layout-registro EXCLUSIVE-LOCK
                                    WHERE bc-layout-registro.cod-layout  = bc-layout.cod-layout
                                    AND   bc-layout-registro.log-datasul = bc-layout.log-datasul
                                    AND   bc-layout-registro.num-versao  = bc-layout.num-versao:
                                    
                                    FOR EACH bc-layout-registro-item EXCLUSIVE-LOCK
                                        WHERE bc-layout-registro-item.num-layout-registro = bc-layout-registro.num-layout-registro:
                                        DELETE bc-layout-registro-item.
                                    END.
                                    DELETE bc-layout-registro.
                                END.
                                CREATE tt-bc-layout-aux.
                                RAW-TRANSFER tt-bc-layout.conteudo TO tt-bc-layout-aux.
                                BUFFER-COPY tt-bc-layout-aux TO bc-layout.
                                ASSIGN i-num-versao = bc-layout.num-versao.
                            END.
                        END CASE.
                    END.
                    ELSE DO:
                        CREATE tt-bc-layout-aux.
                        RAW-TRANSFER tt-bc-layout.conteudo TO tt-bc-layout-aux.
                        CREATE bc-layout.
                        BUFFER-COPY tt-bc-layout-aux TO bc-layout.
                        ASSIGN i-num-versao = bc-layout.num-versao.
                    END.
                END.
                WHEN "bc-layout-registro":U THEN DO:
                    IF l-ignora THEN NEXT bl-lay.
                    
                    FIND LAST bc-layout-registro NO-LOCK USE-INDEX ch-numero NO-ERROR.
                    ASSIGN i-num-lay-reg = bc-layout-registro.num-layout-registro + 1.
                    
                    CREATE tt-bc-layout-registro-aux.
                    RAW-TRANSFER tt-bc-layout.conteudo TO tt-bc-layout-registro-aux.
                    CREATE bc-layout-registro.
                    BUFFER-COPY tt-bc-layout-registro-aux TO bc-layout-registro
                        ASSIGN bc-layout-registro.num-versao          = i-num-versao
                               bc-layout-registro.num-layout-registro = i-num-lay-reg.

                    RUN pi-acompanhar IN h-acomp (c-imp-exp 
                                                 + ": " 
                                                 + STRING(tt-bc-layout.cod-layout)
                                                 + " - "
                                                 + STRING(bc-layout-registro.num-layout-registro)).
                               
                END.
                WHEN "bc-layout-registro-item":U THEN DO:
                    IF l-ignora THEN NEXT bl-lay.
                    
                    CREATE tt-bc-layout-registro-item-aux.
                    RAW-TRANSFER tt-bc-layout.conteudo TO tt-bc-layout-registro-item-aux.
                    CREATE bc-layout-registro-item.
                    BUFFER-COPY tt-bc-layout-registro-item-aux TO bc-layout-registro-item
                        ASSIGN bc-layout-registro-item.num-layout-registro = i-num-lay-reg.
                        
                    RUN pi-acompanhar IN h-acomp (c-imp-exp 
                                                 + ": " 
                                                 + STRING(tt-bc-layout.cod-layout)
                                                 + " - "
                                                 + STRING(bc-layout-registro-item.num-layout-registro) 
                                                 + " - "
                                                 + STRING(bc-layout-registro-item.sequencia)).
                END.                
            END CASE.
        END.
        RUN pi-finalizar IN h-acomp.
    END.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-livre  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this w-livre, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-livre 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  /*run pi-trata-state (p-issuer-hdl, p-state).*/
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

