&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttEstabelec1 NO-UNDO LIKE estabelec
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttEstabelec2 NO-UNDO LIKE estabelec
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wZoom 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i Z06AD107 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i z06ad107 MUT}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/* Template Liberado */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           Z06AD107

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Estabelecimento ,Nome

&GLOBAL-DEFINE Range             Yes

&GLOBAL-DEFINE FieldsRangePage1  
&GLOBAL-DEFINE FieldsRangePage2  
&GLOBAL-DEFINE FieldsAnyKeyPage1 
&GLOBAL-DEFINE FieldsAnyKeyPage2 

&GLOBAL-DEFINE ttTable1          ttEstabelec1
&GLOBAL-DEFINE hDBOTable1        h-EstabCod
&GLOBAL-DEFINE DBOTable1         Estabelec

&GLOBAL-DEFINE ttTable2          ttEstabelec2
&GLOBAL-DEFINE hDBOTable2        h-EstabNome
&GLOBAL-DEFINE DBOTable2         Estabelec

&GLOBAL-DEFINE page1Browse      br-cod-estab
&GLOBAL-DEFINE page2Browse      br-nome

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
&Scoped-define BROWSE-NAME br-cod-estab

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttEstabelec1 ttEstabelec2

/* Definitions for BROWSE br-cod-estab                                  */
&Scoped-define FIELDS-IN-QUERY-br-cod-estab ttEstabelec1.cod-estabel ~
ttEstabelec1.nome 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-cod-estab 
&Scoped-define QUERY-STRING-br-cod-estab FOR EACH ttEstabelec1 NO-LOCK
&Scoped-define OPEN-QUERY-br-cod-estab OPEN QUERY br-cod-estab FOR EACH ttEstabelec1 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-cod-estab ttEstabelec1
&Scoped-define FIRST-TABLE-IN-QUERY-br-cod-estab ttEstabelec1


/* Definitions for BROWSE br-nome                                       */
&Scoped-define FIELDS-IN-QUERY-br-nome ttEstabelec2.nome ~
ttEstabelec2.cod-estabel 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-nome 
&Scoped-define QUERY-STRING-br-nome FOR EACH ttEstabelec2 NO-LOCK
&Scoped-define OPEN-QUERY-br-nome OPEN QUERY br-nome FOR EACH ttEstabelec2 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-nome ttEstabelec2
&Scoped-define FIRST-TABLE-IN-QUERY-br-nome ttEstabelec2


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-cod-estab}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-br-nome}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wZoom AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btCheck 
     IMAGE-UP FILE "image~\im-chck1":U
     LABEL "Button 1" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant1 
     LABEL "&Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-fim-1 AS CHARACTER FORMAT "X(03)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-inic-1 AS CHARACTER FORMAT "X(03)":U 
     LABEL "C¢digo" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 4.14 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3.29 BY .88.

DEFINE BUTTON btCheck-2 
     IMAGE-UP FILE "image~\im-chck1":U
     LABEL "btcheck 2" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant2 
     LABEL "&Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-fim-2 AS CHARACTER FORMAT "X(25)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE fi-inic-2 AS CHARACTER FORMAT "X(25)":U 
     LABEL "Nome" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-3
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image~\im-las":U
     SIZE 3.29 BY .88.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-cod-estab FOR 
      ttEstabelec1 SCROLLING.

DEFINE QUERY br-nome FOR 
      ttEstabelec2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-cod-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-cod-estab wZoom _STRUCTURED
  QUERY br-cod-estab DISPLAY
&IF "{&mguni_version}" >= "2.071" &THEN
      ttEstabelec1.cod-estabel format "x(05)":U WIDTH 5
&ELSE
      ttEstabelec1.cod-estabel FORMAT "X(3)":U WIDTH 5
&ENDIF
      ttEstabelec1.nome FORMAT "X(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 82 BY 10.67
         FONT 2.

DEFINE BROWSE br-nome
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-nome wZoom _STRUCTURED
  QUERY br-nome DISPLAY
      ttEstabelec2.nome FORMAT "X(40)":U
&IF "{&mguni_version}" >= "2.071" &THEN
      ttEstabelec2.cod-estabel format "x(05)":U WIDTH 5
&ELSE
      ttEstabelec2.cod-estabel FORMAT "X(3)":U WIDTH 5
&ENDIF
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 82 BY 10.67
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

DEFINE FRAME fPage1
     btCheck AT ROW 1.21 COL 78.57
     fi-inic-1 AT ROW 1.25 COL 26 COLON-ALIGNED
     fi-fim-1 AT ROW 1.25 COL 43 COLON-ALIGNED NO-LABEL
     br-cod-estab AT ROW 2.33 COL 2
     btImplant1 AT ROW 13 COL 2
     IMAGE-1 AT ROW 1.25 COL 33.57
     IMAGE-2 AT ROW 1.25 COL 41.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.

DEFINE FRAME fPage2
     btCheck-2 AT ROW 1.21 COL 78.57
     fi-inic-2 AT ROW 1.25 COL 8.43 COLON-ALIGNED
     fi-fim-2 AT ROW 1.25 COL 45 COLON-ALIGNED NO-LABEL
     br-nome AT ROW 2.33 COL 2
     btImplant2 AT ROW 13 COL 2
     IMAGE-3 AT ROW 1.25 COL 38
     IMAGE-4 AT ROW 1.25 COL 43.43
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttEstabelec1 T "?" NO-UNDO mgadm estabelec
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttEstabelec2 T "?" NO-UNDO mgadm estabelec
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
/* BROWSE-TAB br-cod-estab fi-fim-1 fPage1 */
ASSIGN 
       br-cod-estab:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       br-cod-estab:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB br-nome fi-fim-2 fPage2 */
ASSIGN 
       br-nome:COLUMN-RESIZABLE IN FRAME fPage2       = TRUE
       br-nome:COLUMN-MOVABLE IN FRAME fPage2         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-cod-estab
/* Query rebuild information for BROWSE br-cod-estab
     _TblList          = "Temp-Tables.ttEstabelec1"
     _FldNameList[1]   > Temp-Tables.ttEstabelec1.cod-estabel
"cod-estabel" ? ? "character" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" ""
     _FldNameList[2]   = Temp-Tables.ttEstabelec1.nome
     _Query            is OPENED
*/  /* BROWSE br-cod-estab */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-nome
/* Query rebuild information for BROWSE br-nome
     _TblList          = "Temp-Tables.ttEstabelec2"
     _FldNameList[1]   = Temp-Tables.ttEstabelec2.nome
     _FldNameList[2]   > Temp-Tables.ttEstabelec2.cod-estabel
"cod-estabel" ? ? "character" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE br-nome */
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btCheck
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck wZoom
ON CHOOSE OF btCheck IN FRAME fPage1 /* Button 1 */
DO:
  run setConstraints in this-procedure(input 1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btCheck-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck-2 wZoom
ON CHOOSE OF btCheck-2 IN FRAME fPage2 /* btcheck 2 */
DO:
  run setConstraints in this-procedure(input 2).
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
    {zoom/implant.i &ProgramImplant="cdp/cd0609.w"
                    &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btImplant2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant2 wZoom
ON CHOOSE OF btImplant2 IN FRAME fPage2 /* Implantar */
DO:
    {zoom/implant.i &ProgramImplant="cdp/cd0602.w"
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


&Scoped-define BROWSE-NAME br-cod-estab
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wZoom 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
{zoom/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wZoom 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
disp fi-inic-1 fi-fim-1 btCheck with frame fPage1.
disp fi-inic-2 fi-fim-2  btCheck-2 with frame fPage2.

enable fi-inic-1 fi-fim-1 btCheck with frame fPage1.
enable fi-inic-2 fi-fim-2  btCheck-2 with frame fPage2.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wZoom 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable1})  THEN DO:
       run adbo/boad107na.p persistent set {&hDBOTable1}.

       RUN setConstraintFaixaEstabel IN {&hDBOTable1} (INPUT "",
                                                       INPUT "ZZZ").
   end.
   
   IF NOT VALID-HANDLE({&hDBOTable2}) then do:
      run adbo/boad107na.p persistent set {&hDBOTable2}.

      RUN setConstraintFaixaNome IN {&hDBOTable2} (INPUT "",
                                                   INPUT "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ").
   END.
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueries wZoom 
PROCEDURE openQueries :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza browsers
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    {zoom/openqueries.i &Query="FaixaEstabel"
                        &PageNumber="1"}
    
    {zoom/openqueries.i &Query="FaixaNome"
                        &PageNumber="2"}                                
        
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage1 wZoom 
PROCEDURE returnFieldsPage1 :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 1
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable1} THEN 
        CASE pcField:
            WHEN "cod-estabel":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-estabel).
            WHEN "nome":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nome).
        END CASE.

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage2 wZoom 
PROCEDURE returnFieldsPage2 :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 2
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable2} THEN 
        CASE pcField:
            WHEN "cod-estabel":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-estabel).
            WHEN "nome":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.nome).
        END CASE.

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraints wZoom 
PROCEDURE setConstraints :
/*------------------------------------------------------------------------------
  Purpose:     Seta constraints e atualiza o browse, conforme n£mero da p gina
               passado como parƒmetro
  Parameters:  recebe n£mero da p gina
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.

    CASE pPageNumber:
        WHEN 1 THEN
            /*--- Seta Constraints para o DBO Table1 ---*/
            RUN setConstraintFaixaEstabel IN {&hDBOTable1} (INPUT input frame fPage1 fi-inic-1,
                                                            INPUT input frame fPage1 fi-fim-1).
                                                    
        WHEN 2 THEN
            /*--- Seta Constraints para o DBO Table1 ---*/
            RUN setConstraintFaixaNome IN {&hDBOTable2} (INPUT input frame fPage2 fi-inic-2,
                                                         INPUT input frame fPage2 fi-fim-2).
    END CASE.    

    /*--- Seta vari vel iConstraintPageNumber com o n£mero da p gina atual 
          Esta vari vel ‚ utilizada no m‚todo openQueries ---*/
    ASSIGN iConstraintPageNumber = pPageNumber.
    
    /*--- Atualiza browse ---*/
    RUN openQueries IN THIS-PROCEDURE.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

