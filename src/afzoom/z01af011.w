&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emscda           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttAf-variavel NO-UNDO LIKE af-variavel
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttAf-variavel1 NO-UNDO LIKE af-variavel
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wZoom 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i Z01AF011 2.00.00.002 } /*** 010002 ***/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           Z01AF011
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels     C¢digo,Descri‡Æo

&GLOBAL-DEFINE Range             YES

&GLOBAL-DEFINE FieldsRangePage1  mgind.af-variavel.cod-variavel
&GLOBAL-DEFINE FieldsRangePage2  mgind.af-variavel.descricao

&GLOBAL-DEFINE FieldsAnyKeyPage1 YES
&GLOBAL-DEFINE FieldsAnyKeyPage2 YES


&GLOBAL-DEFINE ttTable1          ttAf-variavel
&GLOBAL-DEFINE hDBOTable1        hDBOaf011
&GLOBAL-DEFINE DBOTable1         af-variavel

&GLOBAL-DEFINE ttTable2          ttAf-variavel1
&GLOBAL-DEFINE hDBOTable2        hDBOaf0111
&GLOBAL-DEFINE DBOTable2         af-variavel

&GLOBAL-DEFINE page1Browse       brTable1
&GLOBAL-DEFINE page2Browse       brTable2

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable2} AS HANDLE NO-UNDO.

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
&Scoped-define INTERNAL-TABLES ttAf-variavel ttAf-variavel1

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 ttAf-variavel.cod-variavel ~
ttAf-variavel.descricao ttAf-variavel.padrao ttAf-variavel.log-especifico ~
ttAf-variavel.programa ttAf-variavel.dt-implantacao ttAf-variavel.dt-alter ~
ttAf-variavel.hora-alter ttAf-variavel.usuar-alter ttAf-variavel.narrativa 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH ttAf-variavel NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH ttAf-variavel NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 ttAf-variavel
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 ttAf-variavel


/* Definitions for BROWSE brTable2                                      */
&Scoped-define FIELDS-IN-QUERY-brTable2 ttAf-variavel1.descricao ~
ttAf-variavel1.cod-variavel ttAf-variavel1.padrao ~
ttAf-variavel1.log-especifico ttAf-variavel1.programa ~
ttAf-variavel1.dt-implantacao ttAf-variavel1.dt-alter ~
ttAf-variavel1.hora-alter ttAf-variavel1.usuar-alter ~
ttAf-variavel1.narrativa 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable2 
&Scoped-define QUERY-STRING-brTable2 FOR EACH ttAf-variavel1 NO-LOCK ~
    BY ttAf-variavel1.descricao
&Scoped-define OPEN-QUERY-brTable2 OPEN QUERY brTable2 FOR EACH ttAf-variavel1 NO-LOCK ~
    BY ttAf-variavel1.descricao.
&Scoped-define TABLES-IN-QUERY-brTable2 ttAf-variavel1
&Scoped-define FIRST-TABLE-IN-QUERY-brTable2 ttAf-variavel1


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brTable2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btOK btCancel btHelp rtToolBar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
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

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE BUTTON btImplant2 
     LABEL "Implantar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      ttAf-variavel SCROLLING.

DEFINE QUERY brTable2 FOR 
      ttAf-variavel1 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      ttAf-variavel.cod-variavel FORMAT "X(8)":U
      ttAf-variavel.descricao FORMAT "x(50)":U
      ttAf-variavel.padrao FORMAT "Sim/NÆo":U
      ttAf-variavel.log-especifico FORMAT "Sim/NÆo":U
      ttAf-variavel.programa FORMAT "x(60)":U
      ttAf-variavel.dt-implantacao FORMAT "99/99/9999":U
      ttAf-variavel.dt-alter FORMAT "99/99/9999":U
      ttAf-variavel.hora-alter FORMAT "X(8)":U
      ttAf-variavel.usuar-alter FORMAT "X(12)":U
      ttAf-variavel.narrativa FORMAT "x(200)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.67
         FONT 2.

DEFINE BROWSE brTable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable2 wZoom _STRUCTURED
  QUERY brTable2 NO-LOCK DISPLAY
      ttAf-variavel1.descricao FORMAT "x(50)":U
      ttAf-variavel1.cod-variavel FORMAT "X(8)":U
      ttAf-variavel1.padrao FORMAT "Sim/NÆo":U
      ttAf-variavel1.log-especifico FORMAT "Sim/NÆo":U
      ttAf-variavel1.programa FORMAT "x(60)":U
      ttAf-variavel1.dt-implantacao FORMAT "99/99/9999":U
      ttAf-variavel1.dt-alter FORMAT "99/99/9999":U
      ttAf-variavel1.hora-alter FORMAT "X(8)":U
      ttAf-variavel1.usuar-alter FORMAT "X(12)":U
      ttAf-variavel1.narrativa FORMAT "x(200)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.75
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.71 COL 2
     btCancel AT ROW 16.71 COL 13
     btHelp AT ROW 16.71 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.98
         FONT 1.

DEFINE FRAME fPage2
     brTable2 AT ROW 2.25 COL 2
     btImplant2 AT ROW 13 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.

DEFINE FRAME fPage1
     brTable1 AT ROW 2.33 COL 2
     btImplant1 AT ROW 13 COL 2
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
      TABLE: ttAf-variavel T "?" NO-UNDO emscda af-variavel
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttAf-variavel1 T "?" NO-UNDO emscda af-variavel
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
         HEIGHT             = 17
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable1 1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brTable2 1 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.ttAf-variavel"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttAf-variavel.cod-variavel
     _FldNameList[2]   = Temp-Tables.ttAf-variavel.descricao
     _FldNameList[3]   = Temp-Tables.ttAf-variavel.padrao
     _FldNameList[4]   = Temp-Tables.ttAf-variavel.log-especifico
     _FldNameList[5]   = Temp-Tables.ttAf-variavel.programa
     _FldNameList[6]   = Temp-Tables.ttAf-variavel.dt-implantacao
     _FldNameList[7]   = Temp-Tables.ttAf-variavel.dt-alter
     _FldNameList[8]   = Temp-Tables.ttAf-variavel.hora-alter
     _FldNameList[9]   = Temp-Tables.ttAf-variavel.usuar-alter
     _FldNameList[10]   > Temp-Tables.ttAf-variavel.narrativa
"ttAf-variavel.narrativa" ? "x(200)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable2
/* Query rebuild information for BROWSE brTable2
     _TblList          = "Temp-Tables.ttAf-variavel1"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.ttAf-variavel1.descricao|yes"
     _FldNameList[1]   = Temp-Tables.ttAf-variavel1.descricao
     _FldNameList[2]   = Temp-Tables.ttAf-variavel1.cod-variavel
     _FldNameList[3]   = Temp-Tables.ttAf-variavel1.padrao
     _FldNameList[4]   = Temp-Tables.ttAf-variavel1.log-especifico
     _FldNameList[5]   = Temp-Tables.ttAf-variavel1.programa
     _FldNameList[6]   = Temp-Tables.ttAf-variavel1.dt-implantacao
     _FldNameList[7]   = Temp-Tables.ttAf-variavel1.dt-alter
     _FldNameList[8]   = Temp-Tables.ttAf-variavel1.hora-alter
     _FldNameList[9]   = Temp-Tables.ttAf-variavel1.usuar-alter
     _FldNameList[10]   > Temp-Tables.ttAf-variavel1.narrativa
"ttAf-variavel1.narrativa" ? "x(200)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brTable2 */
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
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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
    {zoom/Implant.i &ProgramImplant="afp/af0107.w"
                    &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btImplant2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant2 wZoom
ON CHOOSE OF btImplant2 IN FRAME fPage2 /* Implantar */
DO:
    {zoom/Implant.i &ProgramImplant="afp/af0107.w"
                    &PageNumber="2"}
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


&Scoped-define BROWSE-NAME brTable1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wZoom 


/* ***************************  Main Block  *************************** */

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{Zoom/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
       {&hDBOTable1}:FILE-NAME <> "afbo/boaf011.p":U THEN DO:
       
        {btb/btb008za.i1 afbo/boaf011.p YES}
        {btb/btb008za.i2 afbo/boaf011.p '' {&hDBOTable1}} 
    END.
    
    RUN setConstraintCodVariavel IN {&hDBOTable1} (INPUT "", INPUT "ZZZZZZZZ") NO-ERROR.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable2}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "afbo/boaf011.p":U THEN DO:
       
        {btb/btb008za.i1 afbo/boaf011.p YES}
        {btb/btb008za.i2 afbo/boaf011.p '' {&hDBOTable2}} 
    END.
    
    RUN setConstraintDescricao IN {&hDBOTable2} (INPUT "", INPUT "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ") NO-ERROR.
    
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
    
    {zoom/OpenQueries.i &Query="CodVar"
                        &PageNumber="1"}
    
    {zoom/OpenQueries.i &Query="Desc"
                        &PageNumber="2"}
    
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
            WHEN "cod-variavel":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-variavel).
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage2 wZoom 
PROCEDURE returnFieldsPage2 :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 2
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable2} THEN DO:
        CASE pcField:
            WHEN "descricao":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.descricao).
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
        WHEN 1 THEN
            /*:T--- Seta Constraints para o DBO Table1 ---*/
            RUN setConstraintCodVariavel IN {&hDBOTable1} (INPUT fnIniRangeCharPage(INPUT 1, INPUT 1),
                                                           INPUT fnEndRangeCharPage(INPUT 1, INPUT 1)).
        
        WHEN 2 THEN
            /*:T--- Seta Constraints para o DBO Table2 ---*/
            RUN setConstraintDescricao IN {&hDBOTable2} (INPUT fnIniRangeCharPage(INPUT 2, INPUT 1),
                                                         INPUT fnEndRangeCharPage(INPUT 2, INPUT 1)).
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

