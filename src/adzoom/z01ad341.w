&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movadm           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-contrato-imp NO-UNDO LIKE contrato-imp
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-contrato-imp2 NO-UNDO LIKE contrato-imp
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
{include/i-prgvrs.i Z01AD341 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i z01ad341 MUT}
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
&GLOBAL-DEFINE Program           Z01AD341
&GLOBAL-DEFINE Version           2.00.00.005

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Referˆncia,Contrato

&GLOBAL-DEFINE Range             YES
&GLOBAL-DEFINE FieldNames        
&GLOBAL-DEFINE FieldsRangePage1  movadm.contrato-imp.cod-estabel,movadm.contrato-imp.referencia,movadm.contrato-imp.dt-referencia
&GLOBAL-DEFINE FieldsRangePage2  movadm.contrato-imp.nr-contrato,movadm.contrato-imp.dt-contrato
&GLOBAL-DEFINE FieldsAnyKeyPage1 NO,NO,NO
&GLOBAL-DEFINE FieldsAnyKeyPage2 NO,NO

&GLOBAL-DEFINE ttTable1          tt-contrato-imp
&GLOBAL-DEFINE hDBOTable1        hDBOboad341
&GLOBAL-DEFINE DBOTable1         contrato-imp

&GLOBAL-DEFINE ttTable2          tt-contrato-imp2
&GLOBAL-DEFINE hDBOTable2        hDBOboad341-2
&GLOBAL-DEFINE DBOTable2         contrato-imp

&GLOBAL-DEFINE page1Browse       brTable1
&GLOBAL-DEFINE page2Browse       brTable2

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF VAR V-DATA-FIM AS DATE NO-UNDO.

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
&Scoped-define INTERNAL-TABLES tt-contrato-imp tt-contrato-imp2

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-contrato-imp.cod-estabel ~
tt-contrato-imp.referencia tt-contrato-imp.dt-referencia 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-contrato-imp NO-LOCK ~
    BY tt-contrato-imp.cod-estabel ~
       BY tt-contrato-imp.referencia ~
        BY tt-contrato-imp.dt-referencia
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-contrato-imp NO-LOCK ~
    BY tt-contrato-imp.cod-estabel ~
       BY tt-contrato-imp.referencia ~
        BY tt-contrato-imp.dt-referencia.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-contrato-imp
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-contrato-imp


/* Definitions for BROWSE brTable2                                      */
&Scoped-define FIELDS-IN-QUERY-brTable2 tt-contrato-imp2.nr-contrato ~
tt-contrato-imp2.dt-contrato 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable2 
&Scoped-define QUERY-STRING-brTable2 FOR EACH tt-contrato-imp2 NO-LOCK ~
    BY tt-contrato-imp2.nr-contrato ~
       BY tt-contrato-imp2.dt-contrato
&Scoped-define OPEN-QUERY-brTable2 OPEN QUERY brTable2 FOR EACH tt-contrato-imp2 NO-LOCK ~
    BY tt-contrato-imp2.nr-contrato ~
       BY tt-contrato-imp2.dt-contrato.
&Scoped-define TABLES-IN-QUERY-brTable2 tt-contrato-imp2
&Scoped-define FIRST-TABLE-IN-QUERY-brTable2 tt-contrato-imp2


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
      tt-contrato-imp SCROLLING.

DEFINE QUERY brTable2 FOR 
      tt-contrato-imp2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 DISPLAY
      tt-contrato-imp.cod-estabel FORMAT "x(3)":U
      tt-contrato-imp.referencia FORMAT "x(10)":U
      tt-contrato-imp.dt-referencia FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8
         FONT 2.

DEFINE BROWSE brTable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable2 wZoom _STRUCTURED
  QUERY brTable2 DISPLAY
      tt-contrato-imp2.nr-contrato FORMAT "X(15)":U
      tt-contrato-imp2.dt-contrato FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8
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
     brTable1 AT ROW 4.92 COL 2.14
     btImplant1 AT ROW 13 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.

DEFINE FRAME fPage2
     brTable2 AT ROW 4.96 COL 1.86
     btImplant2 AT ROW 13 COL 2
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
      TABLE: tt-contrato-imp T "?" NO-UNDO movadm contrato-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-contrato-imp2 T "?" NO-UNDO movadm contrato-imp
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
     _TblList          = "Temp-Tables.tt-contrato-imp"
     _OrdList          = "Temp-Tables.tt-contrato-imp.cod-estabel|yes,Temp-Tables.tt-contrato-imp.referencia|yes,Temp-Tables.tt-contrato-imp.dt-referencia|yes"
     _FldNameList[1]   = Temp-Tables.tt-contrato-imp.cod-estabel
     _FldNameList[2]   = Temp-Tables.tt-contrato-imp.referencia
     _FldNameList[3]   = Temp-Tables.tt-contrato-imp.dt-referencia
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable2
/* Query rebuild information for BROWSE brTable2
     _TblList          = "Temp-Tables.tt-contrato-imp2"
     _OrdList          = "Temp-Tables.tt-contrato-imp2.nr-contrato|yes,Temp-Tables.tt-contrato-imp2.dt-contrato|yes"
     _FldNameList[1]   = Temp-Tables.tt-contrato-imp2.nr-contrato
     _FldNameList[2]   = Temp-Tables.tt-contrato-imp2.dt-contrato
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
    {zoom/implant.i &ProgramImplant="ecp/ec0001.w"
                    &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btImplant2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant2 wZoom
ON CHOOSE OF btImplant2 IN FRAME fPage2 /* Implantar */
DO:
    {zoom/implant.i &ProgramImplant="ecp/ec0001.w"
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

/*--- L¢gica para inicializa‡Æo do programam ---*/
{zoom/mainblock.i}

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
        {btb/btb008za.i1 adbo\boad341.p "YES"}
        {btb/btb008za.i2 adbo\boad341.p '' {&hDBOTable1}} 
    END.

    ASSIGN V-DATA-FIM = 12/31/9999.

    RUN setConstraintReferencia IN {&hDBOTable1} (INPUT "",
                                                  INPUT "ZZZZZZZZZZZZZZZZZZZZ",
                                                  INPUT "",
                                                  INPUT "ZZZZZZZZZZZZZZZZZZZZ",
                                                  INPUT date("01/01/1001"),
                                                  INPUT V-DATA-FIM).

    RUN openQueryStatic IN {&hDBOTable1} (INPUT "Referencia":U).

    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable2}) THEN DO:
        {btb/btb008za.i1 adbo\boad341.p "YES"}
        {btb/btb008za.i2 adbo\boad341.p '' {&hDBOTable2}} 
    END.

    RUN setConstraintContrato IN {&hDBOTable2} (INPUT "",
                                                INPUT "ZZZZZZZZZZZZZZZZZZZZ",
                                                INPUT date("01/01/1001"),
                                                INPUT V-DATA-FIM).

    RUN openQueryStatic IN {&hDBOTable2} (INPUT "Contrato":U).    

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

    {zoom/openqueries.i &Query="Referencia"
                        &PageNumber="1"}

    {zoom/openqueries.i &Query="Contrato"
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

    IF AVAILABLE {&ttTable1} THEN DO:
        CASE pcField:
            WHEN "cod-estabel":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-estabel).
            WHEN "referencia":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.referencia).
            WHEN "dt-referencia":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.dt-referencia).
        END CASE.
    END.

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

    IF AVAILABLE {&ttTable2} THEN DO:
        CASE pcField:
            WHEN "nr-contrato":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.nr-contrato).
            WHEN "dt-contrato":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.dt-contrato).
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
            RUN setConstraintReferencia IN {&hDBOTable1} (INPUT fnIniRangeCharPage(INPUT 1,1),
                                                          INPUT fnEndRangeCharPage(INPUT 1,1),
                                                          INPUT fnIniRangeCharPage(INPUT 1,2),
                                                          INPUT fnEndRangeCharPage(INPUT 1,2),
                                                          INPUT fnIniRangeDatePage(INPUT 1,3),
                                                          INPUT fnEndRangeDatePage(INPUT 1,3)).

        WHEN 2 THEN
            /*--- Seta Constraints para o DBO Table2 ---*/
            RUN setConstraintContrato IN {&hDBOTable2} (INPUT fnIniRangeCharPage(INPUT 2,1),
                                                        INPUT fnEndRangeCharPage(INPUT 2,1),
                                                        INPUT fnIniRangeDatePage(INPUT 2,2),
                                                        INPUT fnEndRangeDatePage(INPUT 2,2)).
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

