&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-af-versao-avaliacao NO-UNDO LIKE af-versao-avaliacao
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wZoom 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i Z01AF023 2.00.00.004 } /*** 010004 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i Z01AF023 AFP}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           Z01AF023
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      VersÆo

&GLOBAL-DEFINE Range             YES

&GLOBAL-DEFINE ttTable1          tt-af-versao-avaliacao
&GLOBAL-DEFINE hDBOTable1        h-boaf023
&GLOBAL-DEFINE DBOTable1         af-versao-avaliacao

&GLOBAL-DEFINE page1Browse       brTable1
  
/* Parameters Definitions ---                                           */
/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-desc-periodo AS CHARACTER   NO-UNDO.
/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1}  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf016      AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Zoom
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTable1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-af-versao-avaliacao

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-af-versao-avaliacao.nr-versao tt-af-versao-avaliacao.desc-versao tt-af-versao-avaliacao.ano-avaliacao fn-desc-periodo(tt-af-versao-avaliacao.ano-avaliacao ,tt-af-versao-avaliacao.nr-periodo) @ c-desc-periodo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1   
&Scoped-define SELF-NAME brTable1
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-af-versao-avaliacao NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY {&SELF-NAME} FOR EACH tt-af-versao-avaliacao NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-af-versao-avaliacao
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-af-versao-avaliacao


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-periodo wZoom 
FUNCTION fn-desc-periodo RETURNS CHARACTER
  ( p-ano-avaliacao AS INTEGER, p-numero-periodo AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wZoom AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btCheck1 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb-ano-fim AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 9.43 BY 1 NO-UNDO.

DEFINE VARIABLE cb-ano-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "In¡cio em" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 9.43 BY 1 NO-UNDO.

DEFINE VARIABLE cb-periodo-fim AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 17.72 BY 1 NO-UNDO.

DEFINE VARIABLE cb-periodo-ini AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 17.72 BY 1 NO-UNDO.

DEFINE VARIABLE desc-versao-fim AS CHARACTER FORMAT "X(40)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20.72 BY .79 NO-UNDO.

DEFINE VARIABLE desc-versao-ini AS CHARACTER FORMAT "X(40)":U 
     LABEL "Descri‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 20.72 BY .79 NO-UNDO.

DEFINE VARIABLE nr-versao-fim AS INTEGER FORMAT ">>>>9" INITIAL 9999 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE nr-versao-ini AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "VersÆo" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE IMAGE IMAGE-30
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-31
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-32
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-33
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-34
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-35
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-af-versao-avaliacao SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _FREEFORM
  QUERY brTable1 NO-LOCK DISPLAY
      tt-af-versao-avaliacao.nr-versao COLUMN-LABEL "VersÆo" FORMAT ">>>>9":U
            WIDTH 8
      tt-af-versao-avaliacao.desc-versao COLUMN-LABEL "Descri‡Æo" FORMAT "x(40)":U
            WIDTH 36
      tt-af-versao-avaliacao.ano-avaliacao COLUMN-LABEL "Ano in¡cio" FORMAT "9999":U
            WIDTH 11
      fn-desc-periodo(tt-af-versao-avaliacao.ano-avaliacao ,tt-af-versao-avaliacao.nr-periodo) @ c-desc-periodo COLUMN-LABEL "Per¡odo in¡cio" FORMAT "x(40)":U
            WIDTH 15
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.5
         FONT 2 ROW-HEIGHT-CHARS .46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.71 COL 2
     btCancel AT ROW 16.71 COL 13
     btHelp AT ROW 16.71 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.96
         FONT 1.

DEFINE FRAME fPage1
     nr-versao-ini AT ROW 1.25 COL 23.72 COLON-ALIGNED HELP
          "N£mero da VersÆo"
     nr-versao-fim AT ROW 1.25 COL 48.57 COLON-ALIGNED HELP
          "N£mero da VersÆo" NO-LABEL
     desc-versao-ini AT ROW 2.25 COL 14.57 COLON-ALIGNED
     desc-versao-fim AT ROW 2.25 COL 48.57 COLON-ALIGNED NO-LABEL
     cb-ano-ini AT ROW 3.25 COL 8 COLON-ALIGNED
     cb-periodo-ini AT ROW 3.25 COL 17.72 COLON-ALIGNED NO-LABEL
     cb-ano-fim AT ROW 3.25 COL 48.57 COLON-ALIGNED NO-LABEL
     cb-periodo-fim AT ROW 3.25 COL 58.29 COLON-ALIGNED NO-LABEL
     btCheck1 AT ROW 3.25 COL 79
     brTable1 AT ROW 4.5 COL 2
     btImplant1 AT ROW 13 COL 2
     IMAGE-30 AT ROW 1.25 COL 38.57
     IMAGE-31 AT ROW 1.25 COL 46.57
     IMAGE-32 AT ROW 2.25 COL 38.57
     IMAGE-33 AT ROW 2.25 COL 46.57
     IMAGE-34 AT ROW 3.25 COL 38.57
     IMAGE-35 AT ROW 3.21 COL 46.57
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-af-versao-avaliacao T "?" NO-UNDO emsdca af-versao-avaliacao
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wZoom ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.96
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wZoom 
/* ************************* Included-Libraries *********************** */

{zoom/zoom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wZoom
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable1 btCheck1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-af-versao-avaliacao NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brTable1 */
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

&Scoped-define SELF-NAME wZoom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wZoom wZoom
ON END-ERROR OF wZoom
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wZoom wZoom
ON WINDOW-CLOSE OF wZoom
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wZoom
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btCheck1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck1 wZoom
ON CHOOSE OF btCheck1 IN FRAME fPage1
DO:
  RUN setConstraints IN THIS-PROCEDURE(INPUT 1).
  APPLY 'entry' TO brtable1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wZoom
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btImplant1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant1 wZoom
ON CHOOSE OF btImplant1 IN FRAME fPage1 /* Implantar */
DO:
    {zoom/implant.i &ProgramImplant="afp/af0113.w"
                    &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wZoom
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    RUN returnValues IN THIS-PROCEDURE.
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME cb-ano-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano-fim wZoom
ON VALUE-CHANGED OF cb-ano-fim IN FRAME fPage1
DO:
  RUN pi-preenche-periodo-fim IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano-ini wZoom
ON VALUE-CHANGED OF cb-ano-ini IN FRAME fPage1 /* In¡cio em */
DO:
  RUN pi-preenche-periodo-ini IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTable1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wZoom 


/* ***************************  Main Block  *************************** */

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{zoom/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wZoom 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/  
    IF (VALID-HANDLE(h-boaf016) 
        AND h-boaf016:type = "PROCEDURE":U 
        AND h-boaf016:file-name = "afbo/boaf016.p":U ) THEN DO:
        DELETE PROCEDURE h-boaf016.
        ASSIGN h-boaf016 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wZoom 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i-primeiro-ano AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-ultimo-ano AS INTEGER   NO-UNDO.  
    
    RUN pi-primeiro-ultimo-ano IN h-boaf016 (OUTPUT i-primeiro-ano, OUTPUT i-ultimo-ano).        

    ASSIGN  nr-versao-ini:SCREEN-VALUE IN FRAME fpage1 = "0"
            nr-versao-fim:SCREEN-VALUE IN FRAME fpage1 = "99999"
            desc-versao-ini:SCREEN-VALUE IN FRAME fpage1 = ""
            desc-versao-fim:SCREEN-VALUE IN FRAME fpage1 = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
            cb-ano-ini:SCREEN-VALUE IN FRAME fPage1 = STRING(i-primeiro-ano)
            cb-ano-fim:SCREEN-VALUE IN FRAME fPage1 = STRING(i-ultimo-ano).

    ENABLE nr-versao-ini
           nr-versao-fim
           desc-versao-ini
           desc-versao-fim
           cb-ano-ini
           cb-ano-fim
           cb-periodo-ini
           cb-periodo-fim
           btCheck1
           btImplant1
           WITH FRAME fpage1.             
                    
    RUN pi-preenche-periodos IN THIS-PROCEDURE.

     RUN setConstraints IN THIS-PROCEDURE(INPUT 1).
     APPLY 'entry' TO brtable1.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wZoom 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*Include para carregar o Combo-Box de anos*/
    {afbo/boaf016.i2 "cb-ano-ini" "cb-ano-fim" "fpage1"}

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wZoom 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable1}) OR
       {&hDBOTable1}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable1}:FILE-NAME <> "afbo/boaf023":U THEN DO:
       
        {btb/btb008za.i1 afbo/boaf023.p YES}
        {btb/btb008za.i2 afbo/boaf023.p '' {&hDBOTable1}} 
    END.

    RUN openQueryStatic IN {&hDBOTable1} (INPUT "Versao":U) NO-ERROR.
    
    IF NOT VALID-HANDLE(h-boaf016) THEN DO:
        RUN afbo/boaf016.p persistent set h-boaf016.
    END.

    RUN openQueryStatic IN h-boaf016 (INPUT "Main":U) NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueries wZoom 
PROCEDURE openQueries :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    {zoom/openqueries.i &Query="Versao"
                        &PageNumber="1"}                                                                   
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-preenche-periodo-fim wZoom 
PROCEDURE pi-preenche-periodo-fim :
/*------------------------------------------------------------------------------
  Purpose:    Carrega o ComboBox Final do Per¡odo 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-periodo-desc AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-nr-periodo AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-periodo AS CHARACTER   NO-UNDO.

    /*Carrega o Combo-Box de Per¡odos*/
    {afbo/boaf016.i3 "INPUT FRAME fpage1 cb-ano-fim:SCREEN-VALUE" "cb-periodo-fim" "fpage1"}
   
    RUN pi-ultimo-periodo IN h-boaf016 (INPUT INT(INPUT FRAME fpage1 cb-ano-fim:SCREEN-VALUE), 
                                            OUTPUT i-nr-periodo).

    RUN goToKey IN h-boaf016 (INPUT cb-ano-fim:SCREEN-VALUE IN FRAME fPage1).

    ASSIGN c-periodo = "des-periodo-aval[" + STRING(i-nr-periodo) + "]".

    RUN getCharField IN h-boaf016 (INPUT c-periodo, OUTPUT c-periodo-desc).    

    ASSIGN cb-periodo-fim:SCREEN-VALUE IN FRAME fpage1 = c-periodo-desc.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-preenche-periodo-ini wZoom 
PROCEDURE pi-preenche-periodo-ini :
/*------------------------------------------------------------------------------
  Purpose:     Carrega o ComboBox Inicial do Per¡odo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE VARIABLE c-periodo AS CHARACTER   NO-UNDO.
    /*Carrega o Combo-Box de Per¡odos*/
    {afbo/boaf016.i3 "INPUT FRAME fpage1 cb-ano-ini:SCREEN-VALUE" "cb-periodo-ini" "fpage1"}
    
    RUN goToKey IN h-boaf016 (INPUT cb-ano-ini:SCREEN-VALUE IN FRAME fPage1).

    RUN getCharField IN h-boaf016 (INPUT "des-periodo-aval[1]", OUTPUT c-periodo).    

    ASSIGN cb-periodo-ini:SCREEN-VALUE IN FRAME fpage1 = c-periodo.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-preenche-periodos wZoom 
PROCEDURE pi-preenche-periodos :
/*------------------------------------------------------------------------------
  Purpose:     Procedure que chama as procedures que preenchem os ComboBox
                de per¡odo In¡cial e Final
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
    RUN pi-preenche-periodo-ini IN THIS-PROCEDURE.
    RUN pi-preenche-periodo-fim IN THIS-PROCEDURE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage1 wZoom 
PROCEDURE returnFieldsPage1 :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 1
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable1} THEN DO:
        CASE pcField:
            WHEN "nr-versao":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nr-versao).
            WHEN "desc-versao":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.desc-versao).
            WHEN "ano-avaliacao":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.ano-avaliacao).
            WHEN "nr-periodo":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nr-periodo).
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraints wZoom 
PROCEDURE setConstraints :
/*:T------------------------------------------------------------------------------
  Purpose:     Seta constraints e atualiza o browse, conforme n£mero da p gina
               passado como parƒmetro
  Parameters:  recebe n£mero da p gina
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    
    /*:T--- Seta constraints conforme n£mero da p gina ---*/
    CASE pPageNumber:
        WHEN 1 THEN DO:
        
            DEFINE VARIABLE i-periodo-ini AS INTEGER     NO-UNDO.
            DEFINE VARIABLE i-periodo-fim AS INTEGER     NO-UNDO.
            /*:T--- Seta Constraints para o DBO Table1 ---*/

            IF LOOKUP(cb-periodo-ini:SCREEN-VALUE IN FRAME fPage1,cb-periodo-ini:LIST-ITEM-PAIRS IN FRAME fPage1,",") mod 2 <> 0 THEN
                ASSIGN i-periodo-ini = (LOOKUP(cb-periodo-ini:SCREEN-VALUE IN FRAME fPage1,cb-periodo-ini:LIST-ITEM-PAIRS IN FRAME fPage1,",") + 1) / 2.
            ELSE
                ASSIGN i-periodo-ini = (LOOKUP(cb-periodo-ini:SCREEN-VALUE IN FRAME fPage1,cb-periodo-ini:LIST-ITEM-PAIRS IN FRAME fPage1,",")) / 2.

            IF LOOKUP(cb-periodo-fim:SCREEN-VALUE IN FRAME fPage1,cb-periodo-fim:LIST-ITEM-PAIRS IN FRAME fPage1,",") mod 2 <> 0 THEN
                ASSIGN i-periodo-fim = (LOOKUP(cb-periodo-fim:SCREEN-VALUE IN FRAME fPage1,cb-periodo-fim:LIST-ITEM-PAIRS IN FRAME fPage1,",") + 1) / 2.
            ELSE
                ASSIGN i-periodo-fim = (LOOKUP(cb-periodo-fim:SCREEN-VALUE IN FRAME fPage1,cb-periodo-fim:LIST-ITEM-PAIRS IN FRAME fPage1,",")) / 2.


            RUN setConstraintVersao IN {&hDBOTable1} (INPUT int(nr-versao-ini:SCREEN-VALUE IN FRAME fPage1),
                                                      INPUT int(nr-versao-fim:SCREEN-VALUE IN FRAME fPage1),
                                                      INPUT desc-versao-ini:SCREEN-VALUE IN FRAME fPage1,
                                                      INPUT desc-versao-fim:SCREEN-VALUE IN FRAME fPage1,
                                                      INPUT int(cb-ano-ini:SCREEN-VALUE IN FRAME fPage1),
                                                      INPUT int(cb-ano-fim:SCREEN-VALUE IN FRAME fPage1),
                                                      INPUT i-periodo-ini,
                                                      INPUT i-periodo-fim).
        END.
    END CASE.
    
    /*:T--- Seta vari vel iConstraintPageNumber com o n£mero da p gina atual 
          Esta vari vel ‚ utilizada no m‚todo openQueries ---*/
    ASSIGN iConstraintPageNumber = pPageNumber.
    
    /*:T--- Atualiza browse ---*/
    RUN openQueries IN THIS-PROCEDURE.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-periodo wZoom 
FUNCTION fn-desc-periodo RETURNS CHARACTER
  ( p-ano-avaliacao AS INTEGER, p-numero-periodo AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Preencher os combobox de per¡odo com a descri‡Æo na faixa de sele‡Æo.
    Notes:  
------------------------------------------------------------------------------*/    
    DEFINE VARIABLE c-periodo AS CHARACTER   NO-UNDO.    

    RUN goToKey IN h-boaf016 (INPUT p-ano-avaliacao).
        
    RUN getCharField IN h-boaf016 (INPUT "des-periodo-aval[" + STRING(p-numero-periodo) + "]", OUTPUT c-periodo).

    RETURN c-periodo.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

