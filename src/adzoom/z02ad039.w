&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-cond-pagto NO-UNDO LIKE mgadm.cond-pagto
       FIELD r-Rowid AS ROWID.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wZoom 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i Z02AD039 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i Z02AD039 MUT}
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
&GLOBAL-DEFINE Program           z02ad039
&GLOBAL-DEFINE Version           2.00.10.001
&GLOBAL-DEFINE DBOVersion        1.1

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Cond Pagto

&GLOBAL-DEFINE Range             YES
&GLOBAL-DEFINE FieldsRangePage1  mgadm.cond-pagto.cod-cond-pag
&GLOBAL-DEFINE FieldsAnyKeyPage1 No

&GLOBAL-DEFINE ttTable1          tt-cond-pagto
&GLOBAL-DEFINE hDBOTable1        h-boad039
&GLOBAL-DEFINE DBOTable1         cond-pagto

&GLOBAL-DEFINE page1Browse       brTable1

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Zoom

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTable1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-cond-pagto

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-cond-pagto.cod-cond-pag ~
tt-cond-pagto.descricao tt-cond-pagto.cod-vencto tt-cond-pagto.prazos[1] ~
tt-cond-pagto.prazos[2] tt-cond-pagto.prazos[3] tt-cond-pagto.prazos[4] ~
tt-cond-pagto.prazos[5] tt-cond-pagto.prazos[6] tt-cond-pagto.prazos[7] ~
tt-cond-pagto.prazos[8] tt-cond-pagto.prazos[9] tt-cond-pagto.prazos[10] ~
tt-cond-pagto.prazos[11] tt-cond-pagto.prazos[12] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define FIELD-PAIRS-IN-QUERY-brTable1
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-cond-pagto NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-cond-pagto
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-cond-pagto


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

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

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-cond-pagto SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-cond-pagto.cod-cond-pag
      tt-cond-pagto.descricao
      tt-cond-pagto.cod-vencto COLUMN-LABEL "Vecto"
      tt-cond-pagto.prazos[1] COLUMN-LABEL "Prazos Pagto[01]"
      tt-cond-pagto.prazos[2] COLUMN-LABEL "[02]"
      tt-cond-pagto.prazos[3] COLUMN-LABEL "[03]"
      tt-cond-pagto.prazos[4] COLUMN-LABEL "[04]"
      tt-cond-pagto.prazos[5] COLUMN-LABEL "[05]"
      tt-cond-pagto.prazos[6] COLUMN-LABEL "[06]"
      tt-cond-pagto.prazos[7] COLUMN-LABEL "[07]"
      tt-cond-pagto.prazos[8] COLUMN-LABEL "[08]"
      tt-cond-pagto.prazos[9] COLUMN-LABEL "[09]"
      tt-cond-pagto.prazos[10] COLUMN-LABEL "[10]"
      tt-cond-pagto.prazos[11] COLUMN-LABEL "[11]"
      tt-cond-pagto.prazos[12] COLUMN-LABEL "[12]"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.67
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
      TABLE: tt-cond-pagto T "?" NO-UNDO mgadm cond-pagto
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wZoom
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable1 1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-cond-pagto"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-cond-pagto.cod-cond-pag
     _FldNameList[2]   = Temp-Tables.tt-cond-pagto.descricao
     _FldNameList[3]   > Temp-Tables.tt-cond-pagto.cod-vencto
"tt-cond-pagto.cod-vencto" "Vecto" ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[4]   > Temp-Tables.tt-cond-pagto.prazos[1]
"tt-cond-pagto.prazos[1]" "Prazos Pagto[01]" ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[5]   > Temp-Tables.tt-cond-pagto.prazos[2]
"tt-cond-pagto.prazos[2]" "[02]" ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[6]   > Temp-Tables.tt-cond-pagto.prazos[3]
"tt-cond-pagto.prazos[3]" "[03]" ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[7]   > Temp-Tables.tt-cond-pagto.prazos[4]
"tt-cond-pagto.prazos[4]" "[04]" ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[8]   > Temp-Tables.tt-cond-pagto.prazos[5]
"tt-cond-pagto.prazos[5]" "[05]" ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[9]   > Temp-Tables.tt-cond-pagto.prazos[6]
"tt-cond-pagto.prazos[6]" "[06]" ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[10]   > Temp-Tables.tt-cond-pagto.prazos[7]
"tt-cond-pagto.prazos[7]" "[07]" ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[11]   > Temp-Tables.tt-cond-pagto.prazos[8]
"tt-cond-pagto.prazos[8]" "[08]" ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[12]   > Temp-Tables.tt-cond-pagto.prazos[9]
"tt-cond-pagto.prazos[9]" "[09]" ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[13]   > Temp-Tables.tt-cond-pagto.prazos[10]
"tt-cond-pagto.prazos[10]" "[10]" ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[14]   > Temp-Tables.tt-cond-pagto.prazos[11]
"tt-cond-pagto.prazos[11]" "[11]" ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[15]   > Temp-Tables.tt-cond-pagto.prazos[12]
"tt-cond-pagto.prazos[12]" "[12]" ? "integer" ? ? ? ? ? ? no ?
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wZoom 
/* ************************* Included-Libraries *********************** */

{zoom/zoom.i}

/* _UIB-CODE-BLOCK-END */
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
    RUN cdp/cd0404.w.
    RUN setConstraints IN THIS-PROCEDURE (INPUT 1).
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
    
    RETURN RETURN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brTable1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wZoom 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
{Zoom/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wZoom 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable1}) THEN DO:
        {btb/btb008za.i1 adbo/boad039.p YES}
        {btb/btb008za.i2 adbo/boad039.p '' {&hDBOTable1}} 
    END.
    
    RUN setConstraint2 IN {&hDBOTable1} (INPUT "0", INPUT "999") NO-ERROR.
       
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
    
    {zoom/OpenQueries.i &Query="ByCodigo"
                        &QueryNumber="2"
                        &PageNumber="1"}
    
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
  
    IF AVAILABLE {&ttTable1} THEN DO:
        CASE pcField:
            WHEN "cod-cond-pag":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-cond-pag).
            WHEN "descricao":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.descricao).
            WHEN "cod-vencto":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-vencto).
            WHEN "prazos[01]":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.prazos[01]).
            WHEN "prazos[02]":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.prazos[02]).
            WHEN "prazos[03]":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.prazos[03]).
            WHEN "prazos[04]":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.prazos[04]).
            WHEN "prazos[05]":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.prazos[05]).
            WHEN "prazos[06]":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.prazos[06]).
            WHEN "prazos[07]":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.prazos[07]).
            WHEN "prazos[08]":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.prazos[08]).
            WHEN "prazos[09]":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.prazos[09]).
            WHEN "prazos[10]":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.prazos[10]).
            WHEN "prazos[11]":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.prazos[11]).
            WHEN "prazos[12]":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.prazos[12]).
        END CASE.
    END.
    
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
    
    /*--- Seta constraints conforme n£mero da p gina ---*/
    CASE pPageNumber:
        WHEN 1 THEN
            /*--- Seta Constraints para o DBO Table1 ---*/
            RUN setConstraint2 IN {&hDBOTable1} (INPUT fnIniRangeIntPage(input 1, input 1),
                                                 INPUT fnEndRangeIntPage(input 1, input 1)).
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


