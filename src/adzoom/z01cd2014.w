&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wZoom

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-periodo NO-UNDO 
        field cod-period as integer   format 99
        field des-period as character format 'x(18)'
        field r-rowid    as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wZoom 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i Z01CD2014 2.00.00.000 } /*** 000000 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i z01cd2014 MCD}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           z01cd2014
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels     Mˆs

&GLOBAL-DEFINE Range             NO

&GLOBAL-DEFINE FieldsRangePage1  NO
&GLOBAL-DEFINE FieldsRangePage2  NO

&GLOBAL-DEFINE FieldsAnyKeyPage1 NO
&GLOBAL-DEFINE FieldsAnyKeyPage2 NO


&GLOBAL-DEFINE ttTable1          tt-periodo
&GLOBAL-DEFINE hDBOTable1        h-bodi237-1
&GLOBAL-DEFINE DBOTable1         periodo

&GLOBAL-DEFINE ttTable2          tt-periodo
&GLOBAL-DEFINE hDBOTable2        h-bodi237-2
&GLOBAL-DEFINE DBOTable2         periodo

&GLOBAL-DEFINE page1Browse       brTable1
&GLOBAL-DEFINE page2Browse       

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
&Scoped-define INTERNAL-TABLES tt-periodo

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-periodo.cod-period ~
tt-periodo.des-period
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-periodo NO-LOCK 
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-periodo NO-LOCK .
&Scoped-define TABLES-IN-QUERY-brTable1 tt-periodo
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-periodo

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
     LABEL "Implant" 
     SIZE 10 BY 1.
     
DEFINE BUTTON btTodos
     LABEL "Todos" 
     TOOLTIP "Marca Todos os Per¡odos"
     SIZE 10 BY 1.

DEFINE BUTTON btNenhum 
     LABEL "Nenhum" 
     TOOLTIP "Desmarca Todos os Per¡odos"
     SIZE 10 BY 1.

DEFINE VARIABLE numCont AS INTEGER NO-UNDO.
     
DEFINE INPUT-OUTPUT PARAMETER pSelectedPeriod AS CHARACTER FORMAT "X(35)":U NO-UNDO.    
    
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-periodo SCROLLING.

&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-periodo.cod-period COLUMN-LABEL "Mˆs" width 8
      tt-periodo.des-period COLUMN-LABEL "Descri‡Æo" width 20
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 82 BY 11.80
         FONT 2.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 14.71 COL 2
     btCancel AT ROW 14.71 COL 13
     btHelp AT ROW 14.71 COL 80
     rtToolBar AT ROW 14.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.98
         FONT 1.

DEFINE FRAME fPage1
     brTable1 AT ROW 1.2 COL 2
     btTodos  AT ROW 13.1 COL 1.7
     btNenhum AT ROW 13.1 COL 12
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.

/* *********************** Procedure Settings ************************ */

/* *************************  CREATE Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wZoom ASSIGN
         HIDDEN             = YES
         TITLE              = "Pesquisa Período"
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

{adzoom/z01cd2014.i}

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
/* BROWSE-TAB brTable1 1 fPage1 */

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-periodo"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-periodo.cod-period
"tt-periodo.cod-period" "Mˆs" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-periodo.des-period
"tt-periodo.des-period" "Descri‡Æo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
     In a persistently run window, just ignore this.  IF we did not, the
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
&Scoped-define SELF-NAME btTodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btTodos wZoom
ON CHOOSE OF btTodos IN FRAME fPage1 /* Marcar Todos */
DO:
    IF not can-find(first tt-periodo) THEN
        return no-apply. 
           
    brTable1:deselect-rows().
    
    do numCont = 1 to brTable1:num-iterations:    
        brTable1:select-row(numCont).        
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btNenhum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNenhum wZoom
ON CHOOSE OF btNenhum IN FRAME fPage1 /* Marcar Todos */
DO:
    IF can-find( first tt-periodo)     and 
       brTable1:num-selected-rows > 0 THEN
       brTable1:deselect-rows().    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wZoom
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO: 

    ASSIGN pSelectedPeriod = ''.

    IF brTable1:num-selected-rows in frame fPage1 > 0 THEN DO:
            
        DO numCont = 1 TO brTable1:num-iterations:
                   
            IF brTable1:is-row-selected(numCont) THEN DO:
                            
                IF numCont                 > 1  AND 
                   LENGTH(pSelectedPeriod) > 0 THEN
                    ASSIGN 
                        pSelectedPeriod = pSelectedPeriod + ','.                      
                 ASSIGN 
                    pSelectedPeriod     = pSelectedPeriod + string(numCont, '99') .
            END.    
        END.        
    END.
            
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wZoom 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- VerIFica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable1}) OR
       {&hDBOTable1}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable1}:FILE-NAME <> "dibo/bodi237.p":U THEN DO:

       RUN dibo/bodi237.p PERSISTENT SET {&hDBOTable1}.
      
    END.
    
    
    /*:T--- VerIFica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable2}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "dibo/bodi237.p":U THEN DO:
        
       RUN dibo/bodi237.p PERSISTENT SET {&hDBOTable2}.
        
    END.
    
    /* CREATE dos Periodos para mostrar apenas no browse*/
    
    EMPTY TEMP-TABLE tt-periodo.
    
    CREATE tt-periodo.
    ASSIGN 
        tt-periodo.cod-period = 1
        tt-periodo.des-period = 'JANEIRO'.
        
    CREATE tt-periodo.
    ASSIGN 
        tt-periodo.cod-period = 2
        tt-periodo.des-period = 'FEVEREIRO'.
        
    CREATE tt-periodo.
    ASSIGN 
        tt-periodo.cod-period = 3
        tt-periodo.des-period = 'MAR€O'.
        
    CREATE tt-periodo.
    ASSIGN 
        tt-periodo.cod-period = 4
        tt-periodo.des-period = 'ABRIL'.

    CREATE tt-periodo.
    ASSIGN 
        tt-periodo.cod-period = 5
        tt-periodo.des-period = 'MAIO'.

    CREATE tt-periodo.
    ASSIGN 
        tt-periodo.cod-period = 6
        tt-periodo.des-period = 'JUNHO'.
        
    CREATE tt-periodo.
    ASSIGN 
        tt-periodo.cod-period = 7
        tt-periodo.des-period = 'JULHO'.

    CREATE tt-periodo.
    ASSIGN 
        tt-periodo.cod-period = 8
        tt-periodo.des-period = 'AGOSTO'.
        
    CREATE tt-periodo.
    ASSIGN 
        tt-periodo.cod-period = 9
        tt-periodo.des-period = 'SETEMBRO'.

    CREATE tt-periodo.
    ASSIGN 
        tt-periodo.cod-period = 10
        tt-periodo.des-period = 'OUTUBRO'.
        
    CREATE tt-periodo.
    ASSIGN 
        tt-periodo.cod-period = 11
        tt-periodo.des-period = 'NOVEMBRO'.
        
    CREATE tt-periodo.
    ASSIGN 
        tt-periodo.cod-period = 12
        tt-periodo.des-period = 'DEZEMBRO'.
		
    assign {&WINDOW-NAME}:title = {&WINDOW-NAME}:title + " - Pesquisa Per¡odo".
    
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
   
    {&OPEN-QUERY-brTable1}
    
    IF can-find(first tt-periodo) THEN 
        ENABLE btTodos btNenhum  with frame fPage1.
    
    /*Selecionar os periodos que vierem pr‚-informados no parametro pSelectedPeriod */            
    IF pSelectedPeriod <> ? and pSelectedPeriod <> "" THEN do:  
    
        do numCont = 1 to brTable1:num-iterations in frame fPage1:
                      
            IF lookup(string(numCont, '99'), pSelectedPeriod) <> 0 THEN do:
                brTable1:select-row(numCont) in frame fPage1. 
            END.
                        
        END.    
    END.    
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage1 wZoom 
PROCEDURE returnFieldsPage1:
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
           WHEN "cod-period":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-period).
           WHEN "des-period":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.des-period).
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
           WHEN "cod-period":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-period).
           WHEN "des-period":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.des-period).
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
        
    /*:T--- Atualiza browse ---*/
    RUN openQueries IN THIS-PROCEDURE.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

