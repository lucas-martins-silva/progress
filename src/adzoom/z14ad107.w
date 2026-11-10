&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-estabelec NO-UNDO LIKE estabelec
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-estabelec2 NO-UNDO LIKE estabelec
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
{include/i-prgvrs.i Z14AD107 2.00.00.003 } /*** 010003 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           z14ad107
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      C¢digo,Descri‡Æo

&GLOBAL-DEFINE Range             YES

&GLOBAL-DEFINE FieldsRangePage1  
&GLOBAL-DEFINE FieldsRangePage2  
&GLOBAL-DEFINE FieldsAnyKeyPage1 
&GLOBAL-DEFINE FieldsAnyKeyPage2 

&GLOBAL-DEFINE ttTable1          tt-estabelec
&GLOBAL-DEFINE hDBOTable1        h-estabCod
&GLOBAL-DEFINE DBOTable1         estabelec

&GLOBAL-DEFINE ttTable2          tt-estabelec2
&GLOBAL-DEFINE hDBOTable2        h-estabNome
&GLOBAL-DEFINE DBOTable2         estabelec

&GLOBAL-DEFINE page1Browse      br-cod-estabel
&GLOBAL-DEFINE page2Browse      br-nome

/* Parameters Definitions ---                                           */
DEFINE VARIABLE c-cod-estab-ped AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-cod-emitente  AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-it-codigo     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-refer     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-fm-codigo     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-fm-cod-com    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-nome-mic-reg  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-nome-ab-reg   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cidade        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-estado        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-pais          AS CHARACTER NO-UNDO.

DEFINE VARIABLE criteria  AS CHARACTER NO-UNDO.
DEFINE VARIABLE criteria2 AS CHARACTER NO-UNDO.

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
&Scoped-define BROWSE-NAME br-cod-estabel

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-estabelec tt-estabelec2

/* Definitions for BROWSE br-cod-estabel                                */
&Scoped-define FIELDS-IN-QUERY-br-cod-estabel tt-estabelec.cod-estabel ~
tt-estabelec.nome tt-estabelec.cidade tt-estabelec.estado 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-cod-estabel 
&Scoped-define QUERY-STRING-br-cod-estabel FOR EACH tt-estabelec NO-LOCK
&Scoped-define OPEN-QUERY-br-cod-estabel OPEN QUERY br-cod-estabel FOR EACH tt-estabelec NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-cod-estabel tt-estabelec
&Scoped-define FIRST-TABLE-IN-QUERY-br-cod-estabel tt-estabelec


/* Definitions for BROWSE br-nome                                       */
&Scoped-define FIELDS-IN-QUERY-br-nome tt-estabelec2.nome ~
tt-estabelec2.cod-estabel tt-estabelec2.cidade tt-estabelec2.estado 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-nome 
&Scoped-define QUERY-STRING-br-nome FOR EACH tt-estabelec2 NO-LOCK
&Scoped-define OPEN-QUERY-br-nome OPEN QUERY br-nome FOR EACH tt-estabelec2 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-nome tt-estabelec2
&Scoped-define FIRST-TABLE-IN-QUERY-br-nome tt-estabelec2


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-cod-estabel}

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

DEFINE BUTTON btCheck 
     IMAGE-UP FILE "image~\im-chck1":U
     LABEL "Button 1" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
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
     LABEL "Implantar" 
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
DEFINE QUERY br-cod-estabel FOR 
      tt-estabelec SCROLLING.

DEFINE QUERY br-nome FOR 
      tt-estabelec2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-cod-estabel wZoom _STRUCTURED
  QUERY br-cod-estabel NO-LOCK DISPLAY
      tt-estabelec.cod-estabel FORMAT "x(5)":U
      tt-estabelec.nome FORMAT "X(40)":U
      tt-estabelec.cidade FORMAT "x(50)":U
      tt-estabelec.estado FORMAT "x(4)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.67
         FONT 2.

DEFINE BROWSE br-nome
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-nome wZoom _STRUCTURED
  QUERY br-nome NO-LOCK DISPLAY
      tt-estabelec2.nome FORMAT "X(40)":U
      tt-estabelec2.cod-estabel FORMAT "x(5)":U
      tt-estabelec2.cidade FORMAT "x(50)":U
      tt-estabelec2.estado FORMAT "x(4)":U
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
     btCheck AT ROW 1.21 COL 78.57
     fi-inic-1 AT ROW 1.25 COL 26 COLON-ALIGNED
     fi-fim-1 AT ROW 1.25 COL 43 COLON-ALIGNED NO-LABEL
     br-cod-estabel AT ROW 2.33 COL 2
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
      TABLE: tt-estabelec T "?" NO-UNDO mgadm estabelec
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-estabelec2 T "?" NO-UNDO mgadm estabelec
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
/* BROWSE-TAB br-cod-estabel 1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB br-nome 1 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-cod-estabel
/* Query rebuild information for BROWSE br-cod-estabel
     _TblList          = "Temp-Tables.tt-estabelec"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-estabelec.cod-estabel
     _FldNameList[2]   = Temp-Tables.tt-estabelec.nome
     _FldNameList[3]   = Temp-Tables.tt-estabelec.cidade
     _FldNameList[4]   = Temp-Tables.tt-estabelec.estado
     _Query            is OPENED
*/  /* BROWSE br-cod-estabel */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-nome
/* Query rebuild information for BROWSE br-nome
     _TblList          = "Temp-Tables.tt-estabelec2"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-estabelec2.nome
     _FldNameList[2]   = Temp-Tables.tt-estabelec2.cod-estabel
     _FldNameList[3]   = Temp-Tables.tt-estabelec2.cidade
     _FldNameList[4]   = Temp-Tables.tt-estabelec2.estado
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
    /*{zoom/implant.i &ProgramImplant="<ProgramName>"
                    &PageNumber="1"}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btImplant2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant2 wZoom
ON CHOOSE OF btImplant2 IN FRAME fPage2 /* Implantar */
DO:
  /*  {zoom/implant.i &ProgramImplant="<ProgramName>"
                    &PageNumber="2"}*/
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


&Scoped-define BROWSE-NAME br-cod-estabel
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

       RUN setConstraintFaixaEstabelByCentralVendas IN {&hDBOTable1} (INPUT "",
                                                                      INPUT "ZZZ",
                                                                      INPUT i-cod-emitente,
                                                                      INPUT c-it-codigo,
                                                                      INPUT c-cod-refer,
                                                                      INPUT c-fm-codigo,
                                                                      INPUT c-fm-cod-com,
                                                                      INPUT c-nome-mic-reg,
                                                                      INPUT c-nome-ab-reg,
                                                                      INPUT c-cidade,
                                                                      INPUT c-estado,
                                                                      INPUT c-pais).
    END.
   
    IF NOT VALID-HANDLE({&hDBOTable2}) then do:
       run adbo/boad107na.p persistent set {&hDBOTable2}.
      
       RUN setConstraintFaixaNomeAtendByCentralVendas IN {&hDBOTable2} (INPUT "",
                                                                        INPUT "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ",
                                                                        INPUT i-cod-emitente,
                                                                        INPUT c-it-codigo,
                                                                        INPUT c-cod-refer,
                                                                        INPUT c-fm-codigo,
                                                                        INPUT c-fm-cod-com,
                                                                        INPUT c-nome-mic-reg,
                                                                        INPUT c-nome-ab-reg,
                                                                        INPUT c-cidade,
                                                                        INPUT c-estado,
                                                                        INPUT c-pais).
    END.
    
    RUN openQueries IN THIS-PROCEDURE.
    
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

    CASE iConstraintPageNumber:
        WHEN 0 THEN DO:
            RUN openQueryFaixaEstabelAtendByCentralVendas IN {&hDBOTable1} (OUTPUT TABLE tt-estabelec).
            RUN openQueryFaixaNomeAtendByCentralVendas IN {&hDBOTable2} (OUTPUT TABLE tt-estabelec2).

            IF NOT CAN-FIND(FIRST tt-estabelec
                            WHERE tt-estabelec.cod-estabel = c-cod-estab-ped) THEN
                FOR FIRST estabelec
                    WHERE estabelec.cod-estabel = c-cod-estab-ped NO-LOCK:
                    CREATE tt-estabelec.
                    BUFFER-COPY estabelec TO tt-estabelec.
                    CREATE tt-estabelec2.
                    BUFFER-COPY estabelec TO tt-estabelec2.
                END.

            OPEN QUERY br-cod-estabel FOR EACH tt-estabelec BY tt-estabelec.cod-estabel.
            OPEN QUERY br-nome        FOR EACH tt-estabelec2 BY tt-estabelec2.nome.
        END.
        WHEN 1 THEN DO:
            RUN openQueryFaixaEstabelAtendByCentralVendas IN {&hDBOTable1} (OUTPUT TABLE tt-estabelec).

            IF NOT CAN-FIND(FIRST tt-estabelec
                            WHERE tt-estabelec.cod-estabel = c-cod-estab-ped) THEN
                FOR FIRST estabelec
                    WHERE estabelec.cod-estabel = c-cod-estab-ped NO-LOCK:
                    CREATE tt-estabelec.
                    BUFFER-COPY estabelec TO tt-estabelec.
                END.

            OPEN QUERY br-cod-estabel FOR EACH tt-estabelec BY tt-estabelec.cod-estabel.
        END.
        WHEN 2 THEN DO:
            RUN openQueryFaixaNomeAtendByCentralVendas IN {&hDBOTable2} (OUTPUT TABLE tt-estabelec2).
            IF NOT CAN-FIND(FIRST tt-estabelec
                            WHERE tt-estabelec.cod-estabel = c-cod-estab-ped) THEN
                FOR FIRST estabelec
                    WHERE estabelec.cod-estabel = c-cod-estab-ped NO-LOCK:
                    CREATE tt-estabelec2.
                    BUFFER-COPY estabelec TO tt-estabelec2.
                END.
            OPEN QUERY br-nome FOR EACH tt-estabelec2 BY tt-estabelec2.nome.
        END.
    END CASE.

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
            RUN setConstraintFaixaEstabelByCentralVendas IN {&hDBOTable1} (INPUT input frame fPage1 fi-inic-1,
                                                                           INPUT input frame fPage1 fi-fim-1,
                                                                           INPUT i-cod-emitente,
                                                                           INPUT c-it-codigo,
                                                                           INPUT c-cod-refer,
                                                                           INPUT c-fm-codigo,
                                                                           INPUT c-fm-cod-com,
                                                                           INPUT c-nome-mic-reg,
                                                                           INPUT c-nome-ab-reg,
                                                                           INPUT c-cidade,
                                                                           INPUT c-estado,
                                                                           INPUT c-pais).
                                                    
        WHEN 2 THEN
            /*--- Seta Constraints para o DBO Table1 ---*/
            RUN setConstraintFaixaNomeAtendByCentralVendas IN {&hDBOTable2} (INPUT input frame fPage2 fi-inic-2,
                                                                             INPUT input frame fPage2 fi-fim-2,
                                                                             INPUT i-cod-emitente,
                                                                             INPUT c-it-codigo,
                                                                             INPUT c-cod-refer,
                                                                             INPUT c-fm-codigo,
                                                                             INPUT c-fm-cod-com,
                                                                             INPUT c-nome-mic-reg,
                                                                             INPUT c-nome-ab-reg,
                                                                             INPUT c-cidade,
                                                                             INPUT c-estado,
                                                                             INPUT c-pais). 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraints wZoom 
PROCEDURE pi-seta-estab:
    DEFINE INPUT PARAMETER pcod-estab-ped AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente  AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pfm-codigo     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pfm-cod-com    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pnome-mic-reg  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pnome-ab-reg   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcidade        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pestado        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER ppais          AS CHARACTER NO-UNDO.

    ASSIGN c-cod-estab-ped = pcod-estab-ped
           i-cod-emitente  = pcod-emitente
           c-it-codigo     = pit-codigo
           c-cod-refer     = pcod-refer
           c-fm-codigo     = pfm-codigo
           c-fm-cod-com    = pfm-cod-com
           c-nome-mic-reg  = pnome-mic-reg
           c-nome-ab-reg   = pnome-ab-reg
           c-cidade        = pcidade
           c-estado        = pestado
           c-pais          = ppais.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
