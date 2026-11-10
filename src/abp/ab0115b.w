&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wFormation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-estabelec NO-UNDO LIKE estabelec
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-mab-usuar-estab NO-UNDO LIKE mab-usuar-estab
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-mab-usuar-frota NO-UNDO LIKE mab-usuar-frota
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
{include/i-prgvrs.i AB0115B 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0115b MAB}
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
&GLOBAL-DEFINE Program          AB0115B
&GLOBAL-DEFINE Version          2.00.00.000

&GLOBAL-DEFINE DelTarget        YES
&GLOBAL-DEFINE AddTarget        YES
&GLOBAL-DEFINE DelAllTarget     no
&GLOBAL-DEFINE AddAllTarget     no

&GLOBAL-DEFINE UpdateTarget     YES

&GLOBAL-DEFINE ttParent         tt-mab-usuar-frota
&GLOBAL-DEFINE hDBOParent       hDBOmab-usuar-frota
&GLOBAL-DEFINE DBOParentTable   mab-usuar-frota

&GLOBAL-DEFINE ttSource         tt-estabelec
&GLOBAL-DEFINE hDBOSource       hDBOestabelec
&GLOBAL-DEFINE DBOSourceTable   estabelec

&GLOBAL-DEFINE ttTarget         tt-mab-usuar-estab
&GLOBAL-DEFINE hDBOTarget       hDBOmab-usuar-estab
&GLOBAL-DEFINE DBOTargetTable   mab-usuar-estab

&GLOBAL-DEFINE page0Fields      tt-mab-usuar-frota.cod-usuar

&GLOBAL-DEFINE SourceBrowse      brSource
&GLOBAL-DEFINE TargetBrowse      brTarget

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE iRowid AS INT  NO-UNDO.
DEFINE VARIABLE c-cod-usuar  LIKE tt-mab-usuar-frota.cod-usuar.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSource} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTarget} AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-estabelec-aux NO-UNDO LIKE tt-estabelec.

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
&Scoped-define INTERNAL-TABLES tt-estabelec tt-mab-usuar-estab

/* Definitions for BROWSE brSource                                      */
&Scoped-define FIELDS-IN-QUERY-brSource tt-estabelec.cod-estabel ~
tt-estabelec.nome 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSource 
&Scoped-define QUERY-STRING-brSource FOR EACH tt-estabelec NO-LOCK ~
    BY tt-estabelec.cod-estabel
&Scoped-define OPEN-QUERY-brSource OPEN QUERY brSource FOR EACH tt-estabelec NO-LOCK ~
    BY tt-estabelec.cod-estabel.
&Scoped-define TABLES-IN-QUERY-brSource tt-estabelec
&Scoped-define FIRST-TABLE-IN-QUERY-brSource tt-estabelec


/* Definitions for BROWSE brTarget                                      */
&Scoped-define FIELDS-IN-QUERY-brTarget tt-mab-usuar-estab.cod-estabel ~
fnAprovacao(tt-mab-usuar-estab.idi-tip-usuar) ~
fnEstabelec(tt-mab-usuar-estab.cod-estabel) 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTarget 
&Scoped-define QUERY-STRING-brTarget FOR EACH tt-mab-usuar-estab NO-LOCK ~
    BY tt-mab-usuar-estab.cod-estabel
&Scoped-define OPEN-QUERY-brTarget OPEN QUERY brTarget FOR EACH tt-mab-usuar-estab NO-LOCK ~
    BY tt-mab-usuar-estab.cod-estabel.
&Scoped-define TABLES-IN-QUERY-brTarget tt-mab-usuar-estab
&Scoped-define FIRST-TABLE-IN-QUERY-brTarget tt-mab-usuar-estab


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSource}~
    ~{&OPEN-QUERY-brTarget}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 rtParent btOk btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-mab-usuar-frota.cod-usuar 
&Scoped-define DISPLAYED-TABLES tt-mab-usuar-frota
&Scoped-define FIRST-DISPLAYED-TABLE tt-mab-usuar-frota
&Scoped-Define DISPLAYED-OBJECTS fi-nom-usuar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnAprovacao wFormation 
FUNCTION fnAprovacao RETURNS CHARACTER
  ( p-idi-tip-usuar as INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEstabelec wFormation 
FUNCTION fnEstabelec RETURNS CHARACTER
  ( p-cod-estabel as CHAR )  FORWARD.

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

DEFINE VARIABLE fi-nom-usuar AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

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
      tt-estabelec SCROLLING.

DEFINE QUERY brTarget FOR 
      tt-mab-usuar-estab SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSource wFormation _STRUCTURED
  QUERY brSource NO-LOCK DISPLAY
      tt-estabelec.cod-estabel FORMAT "x(5)":U
      tt-estabelec.nome
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 32 BY 8
         FONT 2.

DEFINE BROWSE brTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTarget wFormation _STRUCTURED
  QUERY brTarget NO-LOCK DISPLAY
      tt-mab-usuar-estab.cod-estabel FORMAT "x(3)":U WIDTH 3.43
      fnAprovacao(tt-mab-usuar-estab.idi-tip-usuar) COLUMN-LABEL "Aprova‡Æo" FORMAT "x(09)":U
      fnEstabelec(tt-mab-usuar-estab.cod-estabel) COLUMN-LABEL "Nome" FORMAT "X(40)":U
            WIDTH 40
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 32 BY 8
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     tt-mab-usuar-frota.cod-usuar AT ROW 2.25 COL 20.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fi-nom-usuar AT ROW 2.25 COL 33.14 COLON-ALIGNED NO-LABEL
     btOk AT ROW 15.46 COL 2
     btCancel AT ROW 15.46 COL 13
     btHelp AT ROW 15.46 COL 80.29
     RECT-1 AT ROW 15.25 COL 1
     RECT-2 AT ROW 3.75 COL 1
     rtParent AT ROW 1.5 COL 1
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
      TABLE: tt-estabelec T "?" NO-UNDO mgadm estabelec
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-mab-usuar-estab T "?" NO-UNDO mgfro mab-usuar-estab
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-mab-usuar-frota T "?" NO-UNDO mgfro mab-usuar-frota
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
/* SETTINGS FOR FILL-IN tt-mab-usuar-frota.cod-usuar IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nom-usuar IN FRAME fPage0
   NO-ENABLE                                                            */
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
     _TblList          = "Temp-Tables.tt-estabelec"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-estabelec.cod-estabel|yes"
     _FldNameList[1]   > Temp-Tables.tt-estabelec.cod-estabel
"cod-estabel" ? "x(5)" "" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[2]   = Temp-Tables.tt-estabelec.nome
     _Query            is OPENED
*/  /* BROWSE brSource */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTarget
/* Query rebuild information for BROWSE brTarget
     _TblList          = "Temp-Tables.tt-mab-usuar-estab"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-mab-usuar-estab.cod-estabel|yes"
     _FldNameList[1]   > Temp-Tables.tt-mab-usuar-estab.cod-estabel
"cod-estabel" ? ? "character" ? ? ? ? ? ? no ? no no "3.43" yes no no "U" "" ""
     _FldNameList[2]   > "_<CALC>"
"fnAprovacao(tt-mab-usuar-estab.idi-tip-usuar)" "Aprova‡Æo" "x(09)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[3]   > "_<CALC>"
"fnEstabelec(tt-mab-usuar-estab.cod-estabel)" "Nome" "X(40)" ? ? ? ? ? ? ? no ? no no "40" yes no no "U" "" ""
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
   {formationnonavigation/repositionson.i}

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateTarget wFormation
ON CHOOSE OF btUpdateTarget IN FRAME fPage1 /* Alterar */
DO:
    
    ASSIGN c-cod-usuar = tt-mab-usuar-frota.cod-usuar:SCREEN-VALUE IN FRAME fPage0.
    {formationnonavigation/updatetarget.i &ProgramTarget="abp/ab0115c.w"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME tt-mab-usuar-frota.cod-usuar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-usuar-frota.cod-usuar wFormation
ON LEAVE OF tt-mab-usuar-frota.cod-usuar IN FRAME fPage0 /* Usu rio */
DO:
    {include/leave.i 
               &tabela=usuar_mestre
               &atributo-ref=nom_usuario
               &variavel-ref=fi-nom-usuar
               &where="usuar_mestre.cod_usuario = input frame fPage0 tt-mab-usuar-frota.cod-usuar"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSource
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wFormation 


/* ***************************  Main Block  *************************** */

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{formationnonavigation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wFormation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

APPLY "leave":U TO tt-mab-usuar-frota.cod-usuar IN FRAME fPage0.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wFormation 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    /*:T--- Verifica se o DBO da tabela Pai j  est  inicializado ---*/
   /*****mab-usuar-frota ****/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "frbo/bofr114.p":U THEN DO:

        RUN frbo/bofr114.p PERSISTENT SET {&hDBOParent}.
    END.

/*     IF l-ok THEN DO: */
        RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U).
/*         ASSIGN l-ok = NO. */
/*     END. */
    
    /*:T--- Verifica se o DBO da tabela Origem j  est  inicializado ---*/
    /*** estabelec ***/
    IF NOT VALID-HANDLE({&hDBOSource}) OR
       {&hDBOSource}:TYPE <> "PROCEDURE":U OR
       {&hDBOSource}:FILE-NAME <> "adbo/boad107na.p":U THEN DO:
       RUN adbo/boad107na.p PERSISTENT SET {&hDBOSource}.
    END.
       
    /*:T--- Verifica se o DBO da tabela Forma‡Æo j  est  inicializado ---*/
    /*** mab-usuar-estab ***/
    IF NOT VALID-HANDLE({&hDBOTarget}) OR
       {&hDBOTarget}:TYPE <> "PROCEDURE":U OR
       {&hDBOTarget}:FILE-NAME <> "frbo/bofr123.p":U THEN DO:
       RUN frbo/bofr123.p PERSISTENT SET {&hDBOTarget}.
    END.    

    ASSIGN c-cod-usuar = tt-mab-usuar-frota.cod-usuar:SCREEN-VALUE IN FRAME fPage0.

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

    IF c-cod-usuar <> "" THEN DO:
        /*tratamentos para reposicionar a query do pai*/
        ASSIGN tt-mab-usuar-frota.cod-usuar:SCREEN-VALUE IN FRAME fPage0 = c-cod-usuar
               tt-mab-usuar-frota.cod-usuar = c-cod-usuar.
        APPLY "leave":U TO tt-mab-usuar-frota.cod-usuar IN FRAME fPage0.
        RUN goToKey IN {&hDBOParent} (INPUT c-cod-usuar).
    END.

    assign rRepositionTarget = ?.
    {formationnonavigation/openqueriestarget.i &Parent="Usuar"
                                               &Query="Usuar"} 
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

    run setConstraintMain in hDBOestabelec no-error.
    run openQueryStatic in hDBOestabelec (INPUT "Main":U) no-error.
    run getBatchRecords in hDBOestabelec (input  ?,
                                          input  no,
                                          input  9999,
                                          output iRowid,
                                          output table tt-estabelec).
   FOR EACH {&ttSource}:
       IF CAN-FIND(FIRST {&ttTarget} WHERE 
                         {&ttTarget}.cod-estabel = {&ttSource}.cod-estabel) then do:
           DELETE  tt-estabelec.
       end.
   END.
   
    {&OPEN-QUERY-brSource}

    APPLY "VALUE-CHANGED":U TO BROWSE {&SourceBrowse}.
    
    /*--- Seta estado dos botäes relacionados ao browse da p gina 1 ---*/
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

    assign tt-mab-usuar-estab.cod-estabel   =  {&ttSource}.cod-estabel
           tt-mab-usuar-estab.cod-usuar     =  {&ttParent}.cod-usuar
           tt-mab-usuar-estab.idi-tip-usuar =  {&ttparent}.idi-tip-usuar.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnAprovacao wFormation 
FUNCTION fnAprovacao RETURNS CHARACTER
  ( p-idi-tip-usuar as INT ) :
/*------------------------------------------------------------------------------
  Purpose:  RETORNA A DESCRICAO DO NIVEL DE APROVACAO - NIVEL 1, NIVEL 2
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-retorno AS character format "x(10)"  NO-UNDO.

    IF p-idi-tip-usuar = 1 THEN DO:
        {utp/ut-liter.i N¡vel_1 *}
    END.
    ELSE DO:
        {utp/ut-liter.i N¡vel_2 *}
    END.
    
    RETURN RETURN-VALUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEstabelec wFormation 
FUNCTION fnEstabelec RETURNS CHARACTER
  ( p-cod-estabel as CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:   Retorna descricao do estabelecimento para o Browser Target
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-retorno AS character format "x(40)"  NO-UNDO.
    
    IF NOT CAN-FIND (FIRST tt-estabelec-aux NO-LOCK) THEN DO:
        run setConstraintMain in hDBOestabelec no-error.
        run openQueryStatic in hDBOestabelec (INPUT "Main":U) no-error.
        run getBatchRecords in hDBOestabelec (input  ?,
                                              input  no,
                                              input  9999,
                                              output iRowid,
                                              output table tt-estabelec-aux).
    END.

    FIND FIRST tt-estabelec-aux WHERE tt-estabelec-aux.cod-estabel = p-cod-estabel NO-LOCK NO-ERROR.
    IF AVAIL tt-estabelec-aux THEN
        ASSIGN c-retorno = tt-estabelec-aux.nome.
            
    RETURN c-retorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

