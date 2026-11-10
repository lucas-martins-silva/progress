&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
          movfro           PROGRESS
*/
&Scoped-define WINDOW-NAME wFormation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttAmostraOleo NO-UNDO LIKE mao-amostra-oleo
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttEnsaio NO-UNDO LIKE mao-ensaio
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttRestdoEnsaio NO-UNDO LIKE mao-restdo-ensaio
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wFormation 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AO0301B 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ao0301b MAO}
&ENDIF


/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          AO0301B
&GLOBAL-DEFINE Version          2.00.00.001

&GLOBAL-DEFINE DelTarget        YES
&GLOBAL-DEFINE AddTarget        YES
&GLOBAL-DEFINE DelAllTarget     no
&GLOBAL-DEFINE AddAllTarget     no

&GLOBAL-DEFINE UpdateTarget     YES

&GLOBAL-DEFINE ttParent         ttAmostraOleo
&GLOBAL-DEFINE hDBOParent       hDBOAmostra
&GLOBAL-DEFINE DBOParentTable   mao-amostra-oleo

&GLOBAL-DEFINE ttSource         ttEnsaio
&GLOBAL-DEFINE hDBOSource       hDBOEnsaio
&GLOBAL-DEFINE DBOSourceTable   mao-ensaio

&GLOBAL-DEFINE ttTarget         ttRestdoEnsaio
&GLOBAL-DEFINE hDBOTarget       hDBORestdoEnsaio
&GLOBAL-DEFINE DBOTargetTable   mao-restdo-ensaio

&GLOBAL-DEFINE page0Fields      ttAmostraOleo.num-amostra-oleo ~
                                ttAmostraOleo.cod-amostra-fisic

&GLOBAL-DEFINE SourceBrowse      brSource
&GLOBAL-DEFINE TargetBrowse      brTarget

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cDescLog    AS CHARACTER format "x(10)" NO-UNDO.
DEFINE VARIABLE cDescricao  AS CHARACTER format "x(30)" NO-UNDO.
DEFINE VARIABLE HoraInv     AS DEC  NO-UNDO.
/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSource} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTarget} AS HANDLE NO-UNDO.


DEFINE VARIABLE c-lista AS CHARACTER  NO-UNDO.
DEFINE BUFFER b-target FOR {&ttTarget}.
DEFINE VARIABLE i-output AS INTEGER    NO-UNDO.
{abp/ab9000.i}  /** Procedure piFormataSegundoParaHora**/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Formation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSource

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttEnsaio ttRestdoEnsaio

/* Definitions for BROWSE brSource                                      */
&Scoped-define FIELDS-IN-QUERY-brSource ttEnsaio.cod-ensaio ~
ttEnsaio.des-ensaio 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSource 
&Scoped-define QUERY-STRING-brSource FOR EACH ttEnsaio NO-LOCK ~
    BY ttEnsaio.cod-ensaio
&Scoped-define OPEN-QUERY-brSource OPEN QUERY brSource FOR EACH ttEnsaio NO-LOCK ~
    BY ttEnsaio.cod-ensaio.
&Scoped-define TABLES-IN-QUERY-brSource ttEnsaio
&Scoped-define FIRST-TABLE-IN-QUERY-brSource ttEnsaio


/* Definitions for BROWSE brTarget                                      */
&Scoped-define FIELDS-IN-QUERY-brTarget ttRestdoEnsaio.cod-ensaio ~
fnPadrao (ttRestdoEnsaio.log-padrao) @ cDescLog ~
fnDescricao  ( ttRestdoEnsaio.cod-ensaio) @ cDescricao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTarget 
&Scoped-define QUERY-STRING-brTarget FOR EACH ttRestdoEnsaio NO-LOCK ~
    BY ttRestdoEnsaio.cod-ensaio
&Scoped-define OPEN-QUERY-brTarget OPEN QUERY brTarget FOR EACH ttRestdoEnsaio NO-LOCK ~
    BY ttRestdoEnsaio.cod-ensaio.
&Scoped-define TABLES-IN-QUERY-brTarget ttRestdoEnsaio
&Scoped-define FIRST-TABLE-IN-QUERY-brTarget ttRestdoEnsaio


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSource}~
    ~{&OPEN-QUERY-brTarget}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttAmostraOleo.num-amostra-oleo ~
ttAmostraOleo.cod-amostra-fisic 
&Scoped-define ENABLED-TABLES ttAmostraOleo
&Scoped-define FIRST-ENABLED-TABLE ttAmostraOleo
&Scoped-Define ENABLED-OBJECTS btOk btCancel btHelp RECT-1 RECT-2 rtParent 
&Scoped-Define DISPLAYED-FIELDS ttAmostraOleo.num-amostra-oleo ~
ttAmostraOleo.cod-amostra-fisic 
&Scoped-define DISPLAYED-TABLES ttAmostraOleo
&Scoped-define FIRST-DISPLAYED-TABLE ttAmostraOleo


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescricao wFormation 
FUNCTION fnDescricao RETURNS CHARACTER
  ( pCodEnsaio as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPadrao wFormation 
FUNCTION fnPadrao RETURNS CHARACTER
  ( pLogPadr as logical )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wFormation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel AUTO-END-KEY 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOk AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 11.25.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.25.

DEFINE BUTTON btAddTarget 
     IMAGE-UP FILE "image/next-au":U
     IMAGE-INSENSITIVE FILE "image/next-ai":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Inclui".

DEFINE BUTTON btDelTarget 
     IMAGE-UP FILE "image/prev-au":U
     IMAGE-INSENSITIVE FILE "image/prev-ai":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Retira".

DEFINE BUTTON btUpdateTarget 
     LABEL "A&lterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSource FOR 
      ttEnsaio SCROLLING.

DEFINE QUERY brTarget FOR 
      ttRestdoEnsaio SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSource wFormation _STRUCTURED
  QUERY brSource NO-LOCK DISPLAY
      ttEnsaio.cod-ensaio FORMAT "x(8)":U WIDTH 8
      ttEnsaio.des-ensaio FORMAT "x(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 32 BY 8
         FONT 2.

DEFINE BROWSE brTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTarget wFormation _STRUCTURED
  QUERY brTarget NO-LOCK DISPLAY
      ttRestdoEnsaio.cod-ensaio FORMAT "x(8)":U WIDTH 7.43
      fnPadrao (ttRestdoEnsaio.log-padrao) @ cDescLog COLUMN-LABEL "PadrÆo"
            WIDTH 6
      fnDescricao  ( ttRestdoEnsaio.cod-ensaio) @ cDescricao COLUMN-LABEL "Descri‡Æo"
            WIDTH 30
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 32 BY 8
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     ttAmostraOleo.num-amostra-oleo AT ROW 2 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttAmostraOleo.cod-amostra-fisic AT ROW 2 COL 51 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     btOk AT ROW 15.46 COL 2
     btCancel AT ROW 15.46 COL 13
     btHelp AT ROW 15.46 COL 80.29
     RECT-1 AT ROW 15.25 COL 1
     RECT-2 AT ROW 3.75 COL 1
     rtParent AT ROW 1.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 15.83
         FONT 1.

DEFINE FRAME fPage1
     brSource AT ROW 1.25 COL 2
     brTarget AT ROW 1.25 COL 52
     btAddTarget AT ROW 4.42 COL 39.57
     btDelTarget AT ROW 5.54 COL 39.57
     btUpdateTarget AT ROW 9.25 COL 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.71
         SIZE 84.43 BY 9.46
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Formation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttAmostraOleo T "?" NO-UNDO movfro mao-amostra-oleo
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttEnsaio T "?" NO-UNDO mgfro mao-ensaio
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttRestdoEnsaio T "?" NO-UNDO movfro mao-restdo-ensaio
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wFormation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 15.83
         WIDTH              = 90
         MAX-HEIGHT         = 21.21
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.21
         VIRTUAL-WIDTH      = 114.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wFormation 
/* ************************* Included-Libraries *********************** */

{formationnonavigation/formationnonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wFormation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSource 1 fPage1 */
/* BROWSE-TAB brTarget brSource fPage1 */
ASSIGN 
       brSource:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       brSource:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

ASSIGN 
       brTarget:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       brTarget:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wFormation)
THEN wFormation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSource
/* Query rebuild information for BROWSE brSource
     _TblList          = "Temp-Tables.ttEnsaio"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.ttEnsaio.cod-ensaio|yes"
     _FldNameList[1]   > Temp-Tables.ttEnsaio.cod-ensaio
"ttEnsaio.cod-ensaio" ? ? "character" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" ""
     _FldNameList[2]   = Temp-Tables.ttEnsaio.des-ensaio
     _Query            is OPENED
*/  /* BROWSE brSource */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTarget
/* Query rebuild information for BROWSE brTarget
     _TblList          = "Temp-Tables.ttRestdoEnsaio"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.ttRestdoEnsaio.cod-ensaio|yes"
     _FldNameList[1]   > Temp-Tables.ttRestdoEnsaio.cod-ensaio
"cod-ensaio" ? ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" ""
     _FldNameList[2]   > "_<CALC>"
"fnPadrao (ttRestdoEnsaio.log-padrao) @ cDescLog" "PadrÆo" ? ? ? ? ? ? ? ? no ? no no "6" yes no no "U" "" ""
     _FldNameList[3]   > "_<CALC>"
"fnDescricao  ( ttRestdoEnsaio.cod-ensaio) @ cDescricao" "Descri‡Æo" ? ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brTarget */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wFormation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wFormation wFormation
ON END-ERROR OF wFormation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wFormation wFormation
ON WINDOW-CLOSE OF wFormation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddTarget wFormation
ON CHOOSE OF btAddTarget IN FRAME fPage1
DO:

    {formationnonavigation/addtarget.i}  
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wFormation
ON CHOOSE OF btCancel IN FRAME fPage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDelTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelTarget wFormation
ON CHOOSE OF btDelTarget IN FRAME fPage1
DO:
    {formation/deltarget.i} 

   /* {formationnonavigation/deltarget.i} */
    run openQueries in this-procedure.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wFormation
ON CHOOSE OF btHelp IN FRAME fPage0 /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOk wFormation
ON CHOOSE OF btOk IN FRAME fPage0 /* OK */
DO:
  /*  {formationnonavigation/repositionson.i}*/

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateTarget wFormation
ON CHOOSE OF btUpdateTarget IN FRAME fPage1 /* Alterar */
DO:
    {formationnonavigation/updatetarget.i &ProgramTarget="aop/ao0301c.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSource
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wFormation 


/* ***************************  Main Block  *************************** */

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{formationnonavigation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wFormation 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO da tabela Pai j  est  inicializado ---*/
   /*****mao-amostra-oleo ****/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "frbo/bofr105.p":U THEN DO:

        RUN frbo/bofr105.p PERSISTENT SET {&hDBOParent}.
    END.
    
/*     RUN setConstraintMain IN {&hDBOParent} (input ) no-error.  */
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U).
    
    /*:T--- Verifica se o DBO da tabela Origem j  est  inicializado ---*/
    /*** mao-ensaio ***/
    IF NOT VALID-HANDLE({&hDBOSource}) OR
       {&hDBOSource}:TYPE <> "PROCEDURE":U OR
       {&hDBOSource}:FILE-NAME <> "frbo/bofr103.p":U THEN DO:
       RUN frbo/bofr103.p PERSISTENT SET {&hDBOSource}.
    END.
       
    /*:T--- Verifica se o DBO da tabela Forma‡Æo j  est  inicializado ---*/
    /*** mao-restdo-ensaio ***/
    IF NOT VALID-HANDLE({&hDBOTarget}) OR
       {&hDBOTarget}:TYPE <> "PROCEDURE":U OR
       {&hDBOTarget}:FILE-NAME <> "frbo/bofr106.p":U THEN DO:
       RUN frbo/bofr106.p PERSISTENT SET {&hDBOTarget}.
    END.    
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueries wFormation 
PROCEDURE openQueries :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers 
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    assign rRepositionTarget = ?.
    {formationnonavigation/openqueriestarget.i &Parent="Amostra"
                                               &Query="Amostra"} 

   run OpenQuerySource.                          


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQuerySource wFormation 
PROCEDURE OpenQuerySource :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   run buscaRegistros in {&hDBOSource}(output table ttEnsaio).
   FOR EACH {&ttSource}:
       IF CAN-FIND(FIRST {&ttTarget} WHERE 
                         {&ttTarget}.num-amostra-oleo =  {&ttParent}.num-amostra-oleo AND
                         {&ttTarget}.cod-ensaio       =  {&ttSource}.cod-ensaio) then do:
           DELETE  ttEnsaio.
       end.
   END.
   
    {&OPEN-QUERY-brSource}

    APPLY "VALUE-CHANGED":U TO BROWSE {&SourceBrowse}.
    
    /*--- Seta estado dos bot´es relacionados ao browse da p˜gina 1 ---*/
    IF AVAILABLE {&ttSource} THEN
       ASSIGN btAddTarget:SENSITIVE IN FRAME fPage1 = YES.
    ELSE
        ASSIGN btAddTarget:SENSITIVE IN FRAME fPage1 = NO.   
                   
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wFormation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela forma‡Æo ({&ttTarget}) com base 
               nos campos da tabela pai ({&ttParent}) e tabela origem ({&ttSource})
  Parameters:  
------------------------------------------------------------------------------*/

    assign {&ttTarget}.num-amostra-oleo                  = {&ttParent}.num-amostra-oleo 
           {&ttTarget}.cod-ensaio                        = {&ttSource}.cod-ensaio
           {&ttTarget}.num-tabela                        = {&ttSource}.num-tabela
           {&ttTarget}.dat-restdo-ensaio                 = ?
           {&ttTarget}.des-formato                       = {&ttSource}.des-formato 
           {&ttTarget}.des-val-max                       = {&ttSource}.des-val-max 
           {&ttTarget}.des-val-min                       = {&ttSource}.des-val-min 
           {&ttTarget}.des-val-restdo                    = "":U
           {&ttTarget}.dsl-obs                           = "":U
           {&ttTarget}.hra-restdo-ensaio                 = "000000":U
           {&tttarget}.idi-estado-ensaio                 = 1
           {&ttTarget}.log-padrao                        = no
           {&ttTarget}.val-dat-hora-invrtda              = 0.
         
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescricao wFormation 
FUNCTION fnDescricao RETURNS CHARACTER
  ( pCodEnsaio as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDEsc AS character format "x(30)"  NO-UNDO.

for first mao-ensaio 
    where mao-ensaio.cod-ensaio = pCodEnsaio no-lock:
end.
if avail mao-ensaio then do:
  RETURN mao-ensaio.des-ensaio.   /* Function return value. */
end.
else do:
    RETURN "".   /* Function return value. */
end.





  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPadrao wFormation 
FUNCTION fnPadrao RETURNS CHARACTER
  ( pLogPadr as logical ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDesc AS character format "x(10)"  NO-UNDO.
 if pLogPadr  then do:
    {utp/ut-liter.i Sim * }
    assign cDesc = trim(return-value).
end.
else do:
   {utp/ut-liter.i NÆo * }
   assign cDesc = trim(return-value).

end.
 
  RETURN cDesc.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

