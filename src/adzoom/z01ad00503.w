&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-transpdor-veic NO-UNDO LIKE transpdor-veic
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-transpdor-veic-2 NO-UNDO LIKE transpdor-veic
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
{include/i-prgvrs.i Z01AD00503 2.00.10.007 } /*** 0101007 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i z01ad00503 MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           z01ad00503
&GLOBAL-DEFINE Version        2.00.10.005

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Placa,Transportador

&GLOBAL-DEFINE Range             YES

&GLOBAL-DEFINE FieldsRangePage1  mgadm.transpdor-veic.cod-placa
&GLOBAL-DEFINE FieldsRangePage2  mgadm.transpdor-veic.cod-transp
&GLOBAL-DEFINE FieldsAnyKeyPage1 NO
&GLOBAL-DEFINE FieldsAnyKeyPage2 NO

&GLOBAL-DEFINE ttTable1          tt-transpdor-veic
&GLOBAL-DEFINE hDBOTable1        h-boad00503
&GLOBAL-DEFINE DBOTable1         transpdor-veic

&GLOBAL-DEFINE ttTable2          tt-transpdor-veic-2
&GLOBAL-DEFINE hDBOTable2        h-boad00503-2
&GLOBAL-DEFINE DBOTable2         transpdor-veic

&GLOBAL-DEFINE page1Browse       brTable1
&GLOBAL-DEFINE page2Browse       brTable2

&GLOBAL-DEFINE NumRowsReturned  100000

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
&Scoped-define INTERNAL-TABLES tt-transpdor-veic tt-transpdor-veic-2

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-transpdor-veic.cod-placa ~
tt-transpdor-veic.cod-transp tt-transpdor-veic.cod-uf ~
tt-transpdor-veic.cod-inter-veic 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-transpdor-veic NO-LOCK ~
    BY tt-transpdor-veic.cod-placa
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-transpdor-veic NO-LOCK ~
    BY tt-transpdor-veic.cod-placa.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-transpdor-veic
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-transpdor-veic


/* Definitions for BROWSE brTable2                                      */
&Scoped-define FIELDS-IN-QUERY-brTable2 tt-transpdor-veic-2.cod-transp ~
tt-transpdor-veic-2.cod-placa tt-transpdor-veic-2.cod-uf ~
tt-transpdor-veic-2.cod-inter-veic 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable2 
&Scoped-define QUERY-STRING-brTable2 FOR EACH tt-transpdor-veic-2 NO-LOCK
&Scoped-define OPEN-QUERY-brTable2 OPEN QUERY brTable2 FOR EACH tt-transpdor-veic-2 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable2 tt-transpdor-veic-2
&Scoped-define FIRST-TABLE-IN-QUERY-brTable2 tt-transpdor-veic-2


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brTable2}

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

DEFINE BUTTON btImplant2 
     LABEL "Implantar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-transpdor-veic SCROLLING.

DEFINE QUERY brTable2 FOR 
      tt-transpdor-veic-2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-transpdor-veic.cod-placa FORMAT "x(10)":U WIDTH 13
      tt-transpdor-veic.cod-transp COLUMN-LABEL "Transp" FORMAT ">>,>>9":U
            WIDTH 15
      tt-transpdor-veic.cod-uf COLUMN-LABEL "UF" FORMAT "x(2)":U
            WIDTH 12
      tt-transpdor-veic.cod-inter-veic COLUMN-LABEL "Veiculo" FORMAT "x(15)":U
            WIDTH 36
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.67
         FONT 2.

DEFINE BROWSE brTable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable2 wZoom _STRUCTURED
  QUERY brTable2 NO-LOCK DISPLAY
      tt-transpdor-veic-2.cod-transp COLUMN-LABEL "Transp" FORMAT ">>,>>9":U
            WIDTH 15
      tt-transpdor-veic-2.cod-placa FORMAT "x(10)":U WIDTH 13
      tt-transpdor-veic-2.cod-uf COLUMN-LABEL "UF" FORMAT "x(2)":U
            WIDTH 12
      tt-transpdor-veic-2.cod-inter-veic COLUMN-LABEL "Veiculo" FORMAT "x(15)":U
            WIDTH 36
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.67
         FONT 2 FIT-LAST-COLUMN.


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
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     brTable2 AT ROW 2.33 COL 2
     btImplant2 AT ROW 13 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brTable1 AT ROW 2.33 COL 2
     btImplant1 AT ROW 13 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-transpdor-veic T "?" NO-UNDO mgadm transpdor-veic
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-transpdor-veic-2 T "?" NO-UNDO mgadm transpdor-veic
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
     _TblList          = "Temp-Tables.tt-transpdor-veic"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-transpdor-veic.cod-placa|yes"
     _FldNameList[1]   > Temp-Tables.tt-transpdor-veic.cod-placa
"cod-placa" ? ? "character" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-transpdor-veic.cod-transp
"cod-transp" "Transp" ? "integer" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-transpdor-veic.cod-uf
"cod-uf" "UF" ? "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-transpdor-veic.cod-inter-veic
"cod-inter-veic" "Veiculo" ? "character" ? ? ? ? ? ? no ? no no "36" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable2
/* Query rebuild information for BROWSE brTable2
     _TblList          = "Temp-Tables.tt-transpdor-veic-2"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-transpdor-veic-2.cod-transp
"cod-transp" "Transp" ? "integer" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-transpdor-veic-2.cod-placa
"cod-placa" ? ? "character" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-transpdor-veic-2.cod-uf
"cod-uf" "UF" ? "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-transpdor-veic-2.cod-inter-veic
"cod-inter-veic" "Veiculo" ? "character" ? ? ? ? ? ? no ? no no "36" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
    RUN cdp/cd0402.r.
    /*--- Atualiza browse ---*/
    RUN openQueries IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btImplant2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant2 wZoom
ON CHOOSE OF btImplant2 IN FRAME fPage2 /* Implantar */
DO:
    RUN cdp/cd0402.r.
    /*--- Atualiza browse ---*/
    RUN openQueries IN THIS-PROCEDURE.
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
{zoom/mainblock.i}
/* Sobrescrita das triggers para evitar erro de rolagem
   do browse em Oracle */
ON OFF-END OF brTable1 IN FRAME fPage1
OR END OF brTable1 IN FRAME fPage1
OR HOME OF brTable1 IN FRAME fPage1
OR OFF-HOME OF brTable1 IN FRAME fPage1
DO:
END.

ON OFF-END OF brTable2 IN FRAME fPage2
OR END OF brTable2 IN FRAME fPage2
OR HOME OF brTable2 IN FRAME fPage2
OR OFF-HOME OF brTable2 IN FRAME fPage2
DO:
END.

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
       {&hDBOTable1}:FILE-NAME <> "adbo/boad00503.p":U THEN DO:
       
        {btb/btb008za.i1 adbo/boad00503.p YES}
        {btb/btb008za.i2 adbo/boad00503.p '' {&hDBOTable1}} 
    END.
  
   RUN setConstraintRangeByCodPlaca IN {&hDBOTable1} (INPUT '',
                                                      INPUT 'ZZZZZZZZZZ').   
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable2}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "adbo/boad00503.p":U THEN DO:
       
        {btb/btb008za.i1 adbo/boad00503.p YES}
        {btb/btb008za.i2 adbo/boad00503.p '' {&hDBOTable2}} 
    END.

    RUN setConstraintRangeByTransp IN {&hDBOTable2} (INPUT 0, INPUT 99999).
   

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
    
    {zoom/openqueries.i &Query="RangeByCodPlaca"
                        &PageNumber="1"}
    
    {zoom/openqueries.i &Query="RangeByTransp"
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
        WHEN "cod-transp":U THEN
            ASSIGN pcFieldValue = STRING({&ttTable1}.cod-transp).
        WHEN "cod-placa":U THEN
            ASSIGN pcFieldValue = STRING({&ttTable1}.cod-placa).
        WHEN "cod-uf":U THEN
            ASSIGN pcFieldValue = STRING({&ttTable1}.cod-uf).
        WHEN "cod-inter-veic":U THEN
            ASSIGN pcFieldValue = STRING({&ttTable1}.cod-inter-veic).
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
        WHEN "cod-transp":U THEN
            ASSIGN pcFieldValue = STRING({&ttTable2}.cod-transp).
        WHEN "cod-placa":U THEN
            ASSIGN pcFieldValue = STRING({&ttTable2}.cod-placa).
        WHEN "cod-uf":U THEN
            ASSIGN pcFieldValue = STRING({&ttTable2}.cod-uf).
        WHEN "cod-inter-veic":U THEN
            ASSIGN pcFieldValue = STRING({&ttTable2}.cod-inter-veic).
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
            RUN setConstraintRangeByCodPlaca IN {&hDBOTable1} (INPUT fnIniRangeCharPage(INPUT 1, INPUT 1),
                                                               INPUT fnEndRangeCharPage(INPUT 1, INPUT 1)).        
        WHEN 2 THEN
            /*:T--- Seta Constraints para o DBO Table2 ---*/
            RUN setConstraintRangeByTransp IN {&hDBOTable2} (INPUT fnIniRangeIntPage(INPUT 2, INPUT 1),
                                                             INPUT fnEndRangeIntPage(INPUT 2, INPUT 1)).
                                                              
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

