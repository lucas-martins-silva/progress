&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind            PROGRESS 
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-produt-carg NO-UNDO LIKE produt-carg
       FIELD r-rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0410A 2.00.00.006 } /*** 010006 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aq0410a MAQ }
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        aq0410a
&GLOBAL-DEFINE Version        2.00.00.006

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE First          NO
&GLOBAL-DEFINE Prev           NO
&GLOBAL-DEFINE Next           NO
&GLOBAL-DEFINE Last           NO
&GLOBAL-DEFINE GoTo           NO
&GLOBAL-DEFINE Search         NO
                         
&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         NO
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         NO
&GLOBAL-DEFINE Save           NO

&GLOBAL-DEFINE ttTable        tt-produt-carg
&GLOBAL-DEFINE hDBOTable      h-boin00965
&GLOBAL-DEFINE DBOTable       produt-carg



&GLOBAL-DEFINE page0KeyFields i-num-carg ~
                              c-cod-carga ~
                              c-cod-pto-coleta ~
                              c-des-pto-coleta
&GLOBAL-DEFINE page0Browse    brProdutCarg
&GLOBAL-DEFINE page0Fields    d-qtd-coletiva


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-nome-brw    AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-respons-brw AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-logico      AS CHARACTER  EXTENT 2 NO-UNDO.


/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO. /* produt carg  */
DEFINE VARIABLE h-boin00966  AS HANDLE NO-UNDO. /* ponto coleta */
DEFINE VARIABLE h-boad098    AS HANDLE NO-UNDO. /* emitente     */

DEFINE INPUT PARAMETER h-boin00961    AS HANDLE NO-UNDO.

DEFINE INPUT PARAMETER pi-cdn-identif AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brProdutCarg

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-produt-carg

/* Definitions for BROWSE brProdutCarg                                  */
&Scoped-define FIELDS-IN-QUERY-brProdutCarg tt-produt-carg.cdn-produt-rural ~
fn-nome({&ttTable}.cdn-produt-rural) @  c-nome-brw tt-produt-carg.cdn-repos ~
tt-produt-carg.qtd-coleta ~
fn-respons(INPUT {&ttTable}.cdn-produt-rural,  INPUT {&ttTable}.cdn-produt-respons) @ c-respons-brw 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brProdutCarg 
&Scoped-define QUERY-STRING-brProdutCarg FOR EACH tt-produt-carg NO-LOCK
&Scoped-define OPEN-QUERY-brProdutCarg OPEN QUERY brProdutCarg FOR EACH tt-produt-carg NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brProdutCarg tt-produt-carg
&Scoped-define FIRST-TABLE-IN-QUERY-brProdutCarg tt-produt-carg


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brProdutCarg}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btQueryJoins btReportsJoins ~
btExit btHelp c-cod-pto-coleta c-des-pto-coleta i-num-carg c-cod-carga ~
brProdutCarg d-qtd-coletiva 
&Scoped-Define DISPLAYED-OBJECTS c-cod-pto-coleta c-des-pto-coleta ~
i-num-carg c-cod-carga d-qtd-coletiva 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-nome wMaintenance 
FUNCTION fn-nome RETURNS CHARACTER
  ( i-cdn-produt-rural AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-respons wMaintenance 
FUNCTION fn-respons RETURNS CHARACTER
  ( i-cdn-produt-rural AS INT, i-cdn-produt-respons AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE c-cod-carga AS CHARACTER FORMAT "X(15)":U INITIAL "0" 
     LABEL "C¢digo" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-pto-coleta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ponto Coleta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-pto-coleta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45.29 BY .88 NO-UNDO.

DEFINE VARIABLE d-qtd-coletiva AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtd Coletiva" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-carg AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Carga" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brProdutCarg FOR 
      tt-produt-carg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brProdutCarg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brProdutCarg wMaintenance _STRUCTURED
  QUERY brProdutCarg NO-LOCK DISPLAY
      tt-produt-carg.cdn-produt-rural COLUMN-LABEL "Produtor" FORMAT ">>>,>>>,>>9":U
            WIDTH 8.43
      fn-nome({&ttTable}.cdn-produt-rural) @  c-nome-brw COLUMN-LABEL "Nome" FORMAT "x(40)":U
            WIDTH 37.29
      tt-produt-carg.cdn-repos FORMAT ">>>,>>9":U
      tt-produt-carg.qtd-coleta COLUMN-LABEL "Quantidade" FORMAT ">>>>,>>>,>>9.9999":U
            WIDTH 13.57
      fn-respons(INPUT {&ttTable}.cdn-produt-rural,  INPUT {&ttTable}.cdn-produt-respons) @ c-respons-brw COLUMN-LABEL "Respons vel" FORMAT "x(3)":U
            WIDTH 15.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS NO-COLUMN-SCROLLING SEPARATORS SIZE 86 BY 10.5
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     c-cod-pto-coleta AT ROW 3.04 COL 16 COLON-ALIGNED
     c-des-pto-coleta AT ROW 3.04 COL 27.72 COLON-ALIGNED NO-LABEL
     i-num-carg AT ROW 4.04 COL 16 COLON-ALIGNED
     c-cod-carga AT ROW 4.04 COL 62.86 COLON-ALIGNED
     brProdutCarg AT ROW 5.75 COL 3 WIDGET-ID 200
     d-qtd-coletiva AT ROW 16.5 COL 75 COLON-ALIGNED
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-produt-carg T "?" NO-UNDO movind produt-carg
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 38.63
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.63
         VIRTUAL-WIDTH      = 182.86
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,                                                          */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brProdutCarg c-cod-carga fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brProdutCarg
/* Query rebuild information for BROWSE brProdutCarg
     _TblList          = "Temp-Tables.tt-produt-carg"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-produt-carg.cdn-produt-rural
"cdn-produt-rural" "Produtor" ? "integer" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fn-nome({&ttTable}.cdn-produt-rural) @  c-nome-brw" "Nome" "x(40)" ? ? ? ? ? ? ? no ? no no "37.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.tt-produt-carg.cdn-repos
     _FldNameList[4]   > Temp-Tables.tt-produt-carg.qtd-coleta
"qtd-coleta" "Quantidade" ? "decimal" ? ? ? ? ? ? no ? no no "13.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fn-respons(INPUT {&ttTable}.cdn-produt-rural,  INPUT {&ttTable}.cdn-produt-respons) @ c-respons-brw" "Respons vel" "x(3)" ? ? ? ? ? ? ? no ? no no "15.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brProdutCarg */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brProdutCarg
&Scoped-define SELF-NAME brProdutCarg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brProdutCarg wMaintenance
ON ROW-DISPLAY OF brProdutCarg IN FRAME fpage0
DO:
  
    ASSIGN d-qtd-coletiva = d-qtd-coletiva + {&ttTable}.qtd-coleta.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMaintenance
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-boin00966) AND
        h-boin00966:TYPE = "PROCEDURE":U AND
        h-boin00966:FILE-NAME = "inbo/boin00966.p":U THEN DO:
        DELETE PROCEDURE h-boin00966.
        ASSIGN h-boin00966 = ?.
    END.

    IF VALID-HANDLE(h-boad098) AND
        h-boad098:TYPE = "PROCEDURE":U AND
        h-boad098:FILE-NAME = "adbo/boad098.p":U THEN DO:
        DELETE PROCEDURE h-boad098.
        ASSIGN h-boad098 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cdn-produt-respons AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-cdn-compart        AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-cdn-repos          AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-pto-coleta         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iRowsReturned        AS INTEGER   NO-UNDO.
    
    ASSIGN MENU-ITEM miReportsJoins:SENSITIVE IN MENU smFile  = NO
           MENU-ITEM miQueryJoins:SENSITIVE   IN MENU smFile  = NO.

    {utp/ut-liter.i Sim * }
    ASSIGN c-logico[1] = RETURN-VALUE.
    {utp/ut-liter.i NÆo * }
    ASSIGN c-logico[2] = RETURN-VALUE.

    
    IF VALID-HANDLE(h-boin00961) THEN DO:                                       
        RUN getIntField  IN h-boin00961(INPUT "num-carg",  OUTPUT i-num-carg)  NO-ERROR.
        RUN getCharField IN h-boin00961(INPUT "cod-carga", OUTPUT c-cod-carga) NO-ERROR.
    END.

    IF VALID-HANDLE({&hDBOTable}) THEN DO:
        RUN goToKey IN {&hDBOTable}(INPUT pi-cdn-identif) NO-ERROR.
        IF RETURN-VALUE = "OK" THEN DO:
             RUN getIntField  IN {&hDBOTable}(INPUT "cdn-produt-respons", OUTPUT i-cdn-produt-respons ) NO-ERROR.
             RUN getIntField  IN {&hDBOTable}(INPUT "cdn-compart",        OUTPUT i-cdn-compart        ) NO-ERROR.
             RUN getIntField  IN {&hDBOTable}(INPUT "cdn-repos",          OUTPUT i-cdn-repos          ) NO-ERROR.
             RUN getCharField IN {&hDBOTable}(INPUT "cod-pto-coleta",     OUTPUT c-cod-pto-coleta     )  NO-ERROR.

             RUN setConstraintColetiva IN {&hDBOTable} (INPUT i-num-carg,
                                                        INPUT c-cod-pto-coleta,
                                                        INPUT i-cdn-produt-respons,
                                                        INPUT i-cdn-compart,
                                                        INPUT i-cdn-repos) NO-ERROR.

             EMPTY TEMP-TABLE {&ttTable} NO-ERROR.
             RUN emptyRowObject  IN {&hDBOTable}.
             RUN openQueryStatic IN {&hDBOTable}(INPUT "Coletiva":U) NO-ERROR.       
             RUN getBatchRecords IN {&hDBOTable} (INPUT ?,
                                                  INPUT NO,
                                                  INPUT 9999,
                                                  OUTPUT iRowsReturned,
                                                  OUTPUT TABLE {&ttTable}).
        END.
    END.

    IF VALID-HANDLE(h-boin00966) THEN DO:
        RUN goToKey IN h-boin00966(INPUT c-cod-pto-coleta) NO-ERROR.
        IF RETURN-VALUE = "OK" THEN
            RUN getCharField IN h-boin00966 (INPUT "des-pto-coleta", OUTPUT c-des-pto-coleta)NO-ERROR.
    END.


    ENABLE brProdutCarg WITH FRAME fPage0.
    
    {&OPEN-QUERY-brProdutCarg}

    DISP i-num-carg
         c-cod-carga 
         c-cod-pto-coleta
         c-des-pto-coleta
         d-qtd-coletiva
         WITH FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /* produt carg */
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "inbo/boin00965.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00965. YES}
        {btb/btb008za.i2 inbo/boin00965. '' {&hDBOTable}}
    END.

    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    /* ponto coleta */
    IF NOT VALID-HANDLE(h-boin00966) THEN 
        RUN inbo/boin00966.p PERSISTENT SET h-boin00966.
    RUN openQueryStatic IN h-boin00966(INPUT "Main") NO-ERROR.

    /* Emitente */
    IF NOT VALID-HANDLE(h-boad098) THEN 
        RUN adbo/boad098.p PERSISTENT SET h-boad098.
    RUN openQueryStatic IN h-boad098(INPUT "Main") NO-ERROR. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-nome wMaintenance 
FUNCTION fn-nome RETURNS CHARACTER
  ( i-cdn-produt-rural AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-nome-abrev AS CHARACTER NO-UNDO.

    IF VALID-HANDLE(h-boad098) THEN DO:   
        RUN findCodigo IN h-boad098(INPUT i-cdn-produt-rural, 
                                    OUTPUT c-nome-abrev).
        IF c-nome-abrev = "" THEN DO:        
            RUN goToKey      IN h-boad098(INPUT i-cdn-produt-rural) NO-ERROR.
            RUN getCharField IN h-boad098(INPUT "nome-abrev", OUTPUT c-nome-abrev).
        END.
    END.

    RETURN c-nome-abrev.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-respons wMaintenance 
FUNCTION fn-respons RETURNS CHARACTER
  ( i-cdn-produt-rural AS INT, i-cdn-produt-respons AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN IF  i-cdn-produt-rural = i-cdn-produt-respons THEN c-logico[1] ELSE c-logico[2].   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

