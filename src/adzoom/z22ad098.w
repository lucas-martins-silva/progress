&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            ORACLE
*/
&Scoped-define WINDOW-NAME wZoom

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-emitente NO-UNDO LIKE emitente
       field r-rowid as rowid
       field rownum as int.
DEFINE TEMP-TABLE tt-emitente1 NO-UNDO LIKE emitente
       field r-rowid as rowid
       field rownum as int.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wZoom 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i Z22AD098 2.00.00.003 } /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i Z22AD098 MUT}
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
&GLOBAL-DEFINE Program           Z22AD098
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Emitente,Nome-Abrev

&GLOBAL-DEFINE Range             YES

&GLOBAL-DEFINE ttTable1          tt-emitente
&GLOBAL-DEFINE hDBOTable1        h-boad098q02a
&GLOBAL-DEFINE DBOTable1         DBOemitente

&GLOBAL-DEFINE ttTable2          tt-emitente1
&GLOBAL-DEFINE hDBOTable2        h-boad098q02b
&GLOBAL-DEFINE DBOTable2         emitente

&GLOBAL-DEFINE page1Browse       brtable1
&GLOBAL-DEFINE page2Browse       brtable2

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
&Scoped-define INTERNAL-TABLES tt-emitente tt-emitente1

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-emitente.cod-emitente ~
tt-emitente.nome-abrev tt-emitente.nome-emit tt-emitente.endereco ~
tt-emitente.bairro tt-emitente.cidade tt-emitente.estado tt-emitente.pais ~
tt-emitente.cod-gr-cli tt-emitente.nome-matriz 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-emitente NO-LOCK ~
    BY tt-emitente.cod-emitente.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-emitente
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-emitente


/* Definitions for BROWSE brTable2                                      */
&Scoped-define FIELDS-IN-QUERY-brTable2 tt-emitente1.nome-abrev ~
tt-emitente1.cod-emitente tt-emitente1.nome-emit tt-emitente1.endereco ~
tt-emitente1.bairro tt-emitente1.cidade tt-emitente1.estado ~
tt-emitente1.pais tt-emitente1.cod-gr-cli tt-emitente1.nome-matriz 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable2 
&Scoped-define OPEN-QUERY-brTable2 OPEN QUERY brTable2 FOR EACH tt-emitente1 NO-LOCK ~
    BY tt-emitente1.nome-abrev ~
    BY tt-emitente1.cod-emitente.
&Scoped-define TABLES-IN-QUERY-brTable2 tt-emitente1
&Scoped-define FIRST-TABLE-IN-QUERY-brTable2 tt-emitente1


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

DEFINE BUTTON btCheck1 
     IMAGE-UP FILE "image~\im-sav":U
     LABEL "" 
     SIZE 5.14 BY 1.

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE i-cod-emitente-fim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente-ini AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "C¢digo" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-18
     FILENAME "image~\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-19
     FILENAME "image~\ii-las":U
     SIZE 2.86 BY 1.

DEFINE BUTTON btCheck2 
     IMAGE-UP FILE "image~\im-sav":U
     LABEL "" 
     SIZE 5.14 BY 1.

DEFINE BUTTON btImplant2 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-nome-abrev-fim AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Nome Abreviado" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-24
     FILENAME "image~\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-25
     FILENAME "image~\ii-las":U
     SIZE 2.86 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-emitente SCROLLING.

DEFINE QUERY brTable2 FOR 
      tt-emitente1 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-emitente.cod-emitente FORMAT ">>>>>>>>9":U
      tt-emitente.nome-abrev FORMAT "X(12)":U
      tt-emitente.nome-emit FORMAT "X(40)":U
      tt-emitente.endereco FORMAT "X(40)":U
      tt-emitente.bairro FORMAT "X(30)":U
      tt-emitente.cidade FORMAT "X(50)":U
      tt-emitente.estado FORMAT "x(4)":U
      tt-emitente.pais FORMAT "X(20)":U
      tt-emitente.cod-gr-cli FORMAT ">9":U
      tt-emitente.nome-matriz FORMAT "x(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8
         FONT 2.

DEFINE BROWSE brTable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable2 wZoom _STRUCTURED
  QUERY brTable2 NO-LOCK DISPLAY
      tt-emitente1.nome-abrev FORMAT "X(12)":U
      tt-emitente1.cod-emitente FORMAT ">>>>>>>>9":U
      tt-emitente1.nome-emit FORMAT "X(40)":U
      tt-emitente1.endereco FORMAT "X(40)":U
      tt-emitente1.bairro FORMAT "X(30)":U
      tt-emitente1.cidade FORMAT "X(50)":U
      tt-emitente1.estado FORMAT "x(4)":U
      tt-emitente1.pais FORMAT "X(20)":U
      tt-emitente1.cod-gr-cli FORMAT ">9":U
      tt-emitente1.nome-matriz FORMAT "x(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 14.17 COL 2
     btCancel AT ROW 14.17 COL 13
     btHelp AT ROW 14.17 COL 80
     rtToolBar AT ROW 14 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14.42
         FONT 1.

DEFINE FRAME fPage1
     i-cod-emitente-ini AT ROW 1.25 COL 5.72 COLON-ALIGNED HELP
          "C¢digo do cliente/fornecedor"
     i-cod-emitente-fim AT ROW 1.25 COL 34.72 COLON-ALIGNED HELP
          "C¢digo do cliente/fornecedor" NO-LABEL
     btCheck1 AT ROW 1.25 COL 78.86
     brTable1 AT ROW 2.46 COL 2
     btImplant1 AT ROW 10.5 COL 2
     IMAGE-18 AT ROW 1.25 COL 24.29
     IMAGE-19 AT ROW 1.25 COL 32.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 10.63
         FONT 1.

DEFINE FRAME fPage2
     c-nome-abrev-ini AT ROW 1.25 COL 12.14 COLON-ALIGNED HELP
          "Nome abreviado do cliente/fornecedor"
     c-nome-abrev-fim AT ROW 1.25 COL 41 COLON-ALIGNED HELP
          "Nome abreviado do cliente/fornecedor" NO-LABEL
     btCheck2 AT ROW 1.25 COL 78.86
     brTable2 AT ROW 2.46 COL 2
     btImplant2 AT ROW 10.5 COL 2
     IMAGE-24 AT ROW 1.25 COL 30.72
     IMAGE-25 AT ROW 1.25 COL 38.72
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 10.63
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-emitente T "?" NO-UNDO mgadm emitente
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
          field rownum as int
      END-FIELDS.
      TABLE: tt-emitente1 T "?" NO-UNDO mgadm emitente
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
          field rownum as int
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
         HEIGHT             = 14.42
         WIDTH              = 90
         MAX-HEIGHT         = 27.96
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.96
         VIRTUAL-WIDTH      = 146.29
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
/* BROWSE-TAB brTable1 btCheck1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brTable2 btCheck2 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-emitente"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-emitente.cod-emitente|yes"
     _FldNameList[1]   = Temp-Tables.tt-emitente.cod-emitente
     _FldNameList[2]   = Temp-Tables.tt-emitente.nome-abrev
     _FldNameList[3]   = Temp-Tables.tt-emitente.nome-emit
     _FldNameList[4]   = Temp-Tables.tt-emitente.endereco
     _FldNameList[5]   = Temp-Tables.tt-emitente.bairro
     _FldNameList[6]   = Temp-Tables.tt-emitente.cidade
     _FldNameList[7]   = Temp-Tables.tt-emitente.estado
     _FldNameList[8]   = Temp-Tables.tt-emitente.pais
     _FldNameList[9]   = Temp-Tables.tt-emitente.cod-gr-cli
     _FldNameList[10]   = Temp-Tables.tt-emitente.nome-matriz
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable2
/* Query rebuild information for BROWSE brTable2
     _TblList          = "Temp-Tables.tt-emitente1"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-emitente1.nome-abrev|yes,Temp-Tables.tt-emitente1.cod-emitente|yes"
     _FldNameList[1]   = Temp-Tables.tt-emitente1.nome-abrev
     _FldNameList[2]   = Temp-Tables.tt-emitente1.cod-emitente
     _FldNameList[3]   = Temp-Tables.tt-emitente1.nome-emit
     _FldNameList[4]   = Temp-Tables.tt-emitente1.endereco
     _FldNameList[5]   = Temp-Tables.tt-emitente1.bairro
     _FldNameList[6]   = Temp-Tables.tt-emitente1.cidade
     _FldNameList[7]   = Temp-Tables.tt-emitente1.estado
     _FldNameList[8]   = Temp-Tables.tt-emitente1.pais
     _FldNameList[9]   = Temp-Tables.tt-emitente1.cod-gr-cli
     _FldNameList[10]   = Temp-Tables.tt-emitente1.nome-matriz
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btCheck1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck1 wZoom
ON CHOOSE OF btCheck1 IN FRAME fPage1
DO:
  RUN setConstraints IN THIS-PROCEDURE(input 1).
  apply 'entry' to brtable1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btCheck2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck2 wZoom
ON CHOOSE OF btCheck2 IN FRAME fPage2
DO:
  RUN setConstraints IN THIS-PROCEDURE(input 2).
  apply 'entry' to brtable2.
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
    /*{zoom/implant.i &ProgramImplant="cdp/cd0704.w"
                    &PageNumber="1"}*/
                    
    disable btImplant2 with frame fpage2.                    
    disable btImplant1 with frame fpage1.
    {&WINDOW-NAME}:SENSITIVE = NO.
    run cdp/cd0704.w.
    {&WINDOW-NAME}:SENSITIVE = YES.
    enable btImplant2 with frame fpage2.                    
    enable btImplant1 with frame fpage1.
    {zoom/openqueries.i &Query="ByCodigo"
                        &PageNumber="1"}
    
    {zoom/openqueries.i &Query="ByNome"
                        &PageNumber="2"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btImplant2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant2 wZoom
ON CHOOSE OF btImplant2 IN FRAME fPage2 /* Implantar */
DO:
    /*{zoom/implant.i &ProgramImplant="cdp/cd0704"
                    &PageNumber="2"}*/
                    
    disable btImplant2 with frame fpage2.                    
    disable btImplant1 with frame fpage1.
    {&WINDOW-NAME}:SENSITIVE = NO.
    run cdp/cd0704.w.
    {&WINDOW-NAME}:SENSITIVE = YES.
    enable btImplant2 with frame fpage2.                    
    enable btImplant1 with frame fpage1.
    {zoom/openqueries.i &Query="ByCodigo"
                        &PageNumber="1"}
    
    {zoom/openqueries.i &Query="ByNome"
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
{zoom/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wZoom 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
assign i-cod-emitente-ini:SCREEN-VALUE IN FRAME fpage1 = "0"
       i-cod-emitente-fim:SCREEN-VALUE IN FRAME fpage1 = "999999999"
       c-nome-abrev-ini:SCREEN-VALUE IN FRAME fpage2 = ""
       c-nome-abrev-fim:SCREEN-VALUE IN FRAME fpage2 = "ZZZZZZZZZZZZ".
    
    enable i-cod-emitente-ini
           i-cod-emitente-fim
           btCheck1
           with frame fpage1.    

    enable c-nome-abrev-ini
           c-nome-abrev-fim
           btCheck2
           with frame fpage2.      
    
    apply 'entry' to brtable1.
    APPLY 'entry' TO i-cod-emitente-ini.
    apply 'entry' to brtable2.       
    APPLY 'entry' TO c-nome-abrev-ini.
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wZoom 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable1}) THEN DO:
        {btb/btb008za.i1 adbo/boad098q02.p YES}
        {btb/btb008za.i2 adbo/boad098q02.p '' {&hDBOTable1}} 
    END.
    
/*     RUN setConstraint<Description> IN {&hDBOTable1} (<pamameters>) NO-ERROR. */
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable2}) THEN DO:
        {btb/btb008za.i1 adbo/boad098q02.p YES}
        {btb/btb008za.i2 adbo/boad098q02.p '' {&hDBOTable2}} 
    END.
    
/*     RUN setConstraint<Description> IN {&hDBOTable2} (<pamameters>) NO-ERROR. */
    
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
    
    {zoom/openqueries.i &Query="ByCodigo"
                        &PageNumber="1"}
    
    {zoom/openqueries.i &Query="ByNome"
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
            WHEN "cod-emitente":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-emitente).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nome-abrev).
            WHEN "nome-emit":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nome-emit).
            WHEN "bairro":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.endereco).
            WHEN "cidade":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cidade).
            WHEN "estado":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.estado).
            WHEN "pais":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.pais).
            WHEN "cod-gr-cli":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-gr-cli).
            WHEN "nome-matriz":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nome-matriz).
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
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.nome-abrev).
            WHEN "cod-emitente":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-emitente).
            WHEN "nome-emit":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.nome-emit).
            WHEN "bairro":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.endereco).
            WHEN "cidade":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cidade).
            WHEN "estado":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.estado).
            WHEN "pais":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.pais).
            WHEN "cod-gr-cli":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-gr-cli).
            WHEN "nome-matriz":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.nome-matriz).
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
            RUN setConstraintByCodigo IN {&hDBOTable1} 
                (INPUT i-cod-emitente-ini:SCREEN-VALUE IN FRAME fpage1,
                 INPUT i-cod-emitente-fim:SCREEN-VALUE IN FRAME fpage1).

        
        WHEN 2 THEN
            /*:T--- Seta Constraints para o DBO Table2 ---*/
            RUN setConstraintByNome IN {&hDBOTable2}
                (INPUT c-nome-abrev-ini:SCREEN-VALUE IN FRAME fpage2,
                 INPUT c-nome-abrev-fim:SCREEN-VALUE IN FRAME fpage2,
                 INPUT i-cod-emitente-ini:SCREEN-VALUE IN FRAME fpage1,
                 INPUT i-cod-emitente-fim:SCREEN-VALUE IN FRAME fpage1).       
                 
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

