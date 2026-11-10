&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-cadast-obra NO-UNDO LIKE cadast-obra
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-cadast-obra-2 NO-UNDO LIKE cadast-obra
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
{include/i-prgvrs.i Z01AD00544 2.00.00.004 } /*** "010004" ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i z01ad00544 CDP}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           z01ad00544
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      CNPJ,CNO

&GLOBAL-DEFINE Range             NO

&GLOBAL-DEFINE FieldsRangePage1  
&GLOBAL-DEFINE FieldsAnyKeyPage1 NO


&GLOBAL-DEFINE ttTable1          tt-cadast-obra
&GLOBAL-DEFINE hDBOTable1        h-boad00544
&GLOBAL-DEFINE DBOTable1         cadast-obra

&GLOBAL-DEFINE ttTable2          tt-cadast-obra-2
&GLOBAL-DEFINE hDBOTable2        h-boad00544-aux
&GLOBAL-DEFINE DBOTable2         cadast-obra


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
&Scoped-define INTERNAL-TABLES tt-cadast-obra tt-cadast-obra-2

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-cadast-obra.cdn-tipo ~
tt-cadast-obra.cod-obra fnIdiObra(tt-cadast-obra.idi-obra) ~
tt-cadast-obra.log-terceiro tt-cadast-obra.des-estab 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-cadast-obra ~
      WHERE tt-cadast-obra.cdn-tipo = 1 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-cadast-obra ~
      WHERE tt-cadast-obra.cdn-tipo = 1 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-cadast-obra
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-cadast-obra


/* Definitions for BROWSE brTable2                                      */
&Scoped-define FIELDS-IN-QUERY-brTable2 tt-cadast-obra-2.cdn-tipo ~
tt-cadast-obra-2.cod-obra fnIdiObra(tt-cadast-obra-2.idi-obra) ~
tt-cadast-obra-2.log-terceiro tt-cadast-obra-2.des-estab 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable2 
&Scoped-define QUERY-STRING-brTable2 FOR EACH tt-cadast-obra-2 ~
      WHERE tt-cadast-obra-2.cdn-tipo = 4 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brTable2 OPEN QUERY brTable2 FOR EACH tt-cadast-obra-2 ~
      WHERE tt-cadast-obra-2.cdn-tipo = 4 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brTable2 tt-cadast-obra-2
&Scoped-define FIRST-TABLE-IN-QUERY-brTable2 tt-cadast-obra-2


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


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnIdiObra wZoom 
FUNCTION fnIdiObra RETURNS CHARACTER
  ( i-idi-obra AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
     IMAGE-UP FILE "image/im-sav":U
     LABEL "btcheck 1" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-cod-emit-fim LIKE tt-cadast-obra.cod-obra
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-emit-ini LIKE tt-cadast-obra.cod-obra
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON btCheck2 
     IMAGE-UP FILE "image/im-sav":U
     LABEL "btcheck 2" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant2 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-cod-obra-fim LIKE tt-cadast-obra-2.cod-obra
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-obra-ini LIKE tt-cadast-obra-2.cod-obra
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-cadast-obra SCROLLING.

DEFINE QUERY brTable2 FOR 
      tt-cadast-obra-2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-cadast-obra.cdn-tipo FORMAT ">9":U
      tt-cadast-obra.cod-obra FORMAT "x(15)":U
      fnIdiObra(tt-cadast-obra.idi-obra) COLUMN-LABEL "Indicador de obra" FORMAT "x(30)":U
            WIDTH 26.29
      tt-cadast-obra.log-terceiro FORMAT "Sim/NÆo":U
      tt-cadast-obra.des-estab FORMAT "x(30)":U WIDTH 29.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.67
         FONT 2 FIT-LAST-COLUMN.

DEFINE BROWSE brTable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable2 wZoom _STRUCTURED
  QUERY brTable2 NO-LOCK DISPLAY
      tt-cadast-obra-2.cdn-tipo FORMAT ">9":U
      tt-cadast-obra-2.cod-obra FORMAT "x(15)":U
      fnIdiObra(tt-cadast-obra-2.idi-obra) COLUMN-LABEL "Indicador de Obra" FORMAT "x(30)":U
            WIDTH 26.29
      tt-cadast-obra-2.log-terceiro FORMAT "Sim/NÆo":U
      tt-cadast-obra-2.des-estab FORMAT "x(30)":U WIDTH 29.14
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
     btCheck2 AT ROW 1.21 COL 78.86
     c-cod-obra-ini AT ROW 1.25 COL 12 COLON-ALIGNED HELP
          "C¢digo Obra"
     c-cod-obra-fim AT ROW 1.25 COL 48.43 COLON-ALIGNED HELP
          "C¢digo Obra" NO-LABEL
     brTable2 AT ROW 2.33 COL 2 HELP
          ""
     btImplant2 AT ROW 13 COL 2
     IMAGE-9 AT ROW 1.25 COL 33
     IMAGE-10 AT ROW 1.25 COL 47
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     btCheck1 AT ROW 1.21 COL 78.86
     c-cod-emit-ini AT ROW 1.25 COL 11.86 COLON-ALIGNED HELP
          "C¢digo Obra" 
          LABEL "Emitente"
     c-cod-emit-fim AT ROW 1.25 COL 48.43 COLON-ALIGNED HELP
          "C¢digo Obra" NO-LABEL
     brTable1 AT ROW 2.33 COL 2 HELP
          ""
     btImplant1 AT ROW 13 COL 2
     IMAGE-5 AT ROW 1.25 COL 33
     IMAGE-6 AT ROW 1.25 COL 47
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
      TABLE: tt-cadast-obra T "?" NO-UNDO mgadm cadast-obra
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-cadast-obra-2 T "?" NO-UNDO mgadm cadast-obra
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
/* BROWSE-TAB brTable1 c-cod-emit-fim fPage1 */
/* SETTINGS FOR FILL-IN c-cod-emit-fim IN FRAME fPage1
   LIKE = Temp-Tables.tt-cadast-obra.cod-obra EXP-LABEL EXP-SIZE        */
/* SETTINGS FOR FILL-IN c-cod-emit-ini IN FRAME fPage1
   LIKE = Temp-Tables.tt-cadast-obra.cod-obra EXP-LABEL EXP-SIZE        */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brTable2 c-cod-obra-fim fPage2 */
/* SETTINGS FOR FILL-IN c-cod-obra-fim IN FRAME fPage2
   LIKE = Temp-Tables.tt-cadast-obra-2.cod-obra EXP-LABEL EXP-SIZE      */
/* SETTINGS FOR FILL-IN c-cod-obra-ini IN FRAME fPage2
   LIKE = Temp-Tables.tt-cadast-obra-2.cod-obra EXP-SIZE                */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-cadast-obra"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Temp-Tables.tt-cadast-obra.cdn-tipo = 1"
     _FldNameList[1]   = Temp-Tables.tt-cadast-obra.cdn-tipo
     _FldNameList[2]   = Temp-Tables.tt-cadast-obra.cod-obra
     _FldNameList[3]   > "_<CALC>"
"fnIdiObra(tt-cadast-obra.idi-obra)" "Indicador de obra" "x(30)" ? ? ? ? ? ? ? no ? no no "26.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.tt-cadast-obra.log-terceiro
     _FldNameList[5]   > Temp-Tables.tt-cadast-obra.des-estab
"des-estab" ? ? "character" ? ? ? ? ? ? no ? no no "29.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable2
/* Query rebuild information for BROWSE brTable2
     _TblList          = "Temp-Tables.tt-cadast-obra-2"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Temp-Tables.tt-cadast-obra-2.cdn-tipo = 4"
     _FldNameList[1]   = Temp-Tables.tt-cadast-obra-2.cdn-tipo
     _FldNameList[2]   = Temp-Tables.tt-cadast-obra-2.cod-obra
     _FldNameList[3]   > "_<CALC>"
"fnIdiObra(tt-cadast-obra-2.idi-obra)" "Indicador de Obra" "x(30)" ? ? ? ? ? ? ? no ? no no "26.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.tt-cadast-obra-2.log-terceiro
     _FldNameList[5]   > Temp-Tables.tt-cadast-obra-2.des-estab
"des-estab" ? ? "character" ? ? ? ? ? ? no ? no no "29.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON CHOOSE OF btCheck1 IN FRAME fPage1 /* btcheck 1 */
DO:
    run setConstraints in this-procedure (input 1).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btCheck2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck2 wZoom
ON CHOOSE OF btCheck2 IN FRAME fPage2 /* btcheck 2 */
DO:
    run setConstraints in this-procedure (input 2).  
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
    {zoom/implant.i &ProgramImplant="cdp/cd2023.w"
                    &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btImplant2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant2 wZoom
ON CHOOSE OF btImplant2 IN FRAME fPage2 /* Implantar */
DO:
    {zoom/implant.i &ProgramImplant="cdp/cd2023.w"
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
/* Sobrescrita das triggers para evitar erro de rolagem
do browse em Oracle */
ON OFF-END OF brTable1 IN FRAME fPage1
OR END OF brTable1 IN FRAME fPage1
OR HOME OF brTable1 IN FRAME fPage1
OR OFF-HOME OF brTable1 IN FRAME fPage1
DO:
END.

/* Sobrescrita das triggers para evitar erro de rolagem
do browse em Oracle */
ON OFF-END OF brTable2 IN FRAME fPage2
OR END OF brTable2 IN FRAME fPage2
OR HOME OF brTable2 IN FRAME fPage2
OR OFF-HOME OF brTable2 IN FRAME fPage2
DO:
END.


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

    DEFINE VARIABLE lExec4035 AS LOGICAL NO-UNDO.
    DEFINE VARIABLE i-cont    AS INTEGER NO-UNDO.

    ENABLE btCheck1 
           c-cod-emit-ini
           c-cod-emit-fim WITH FRAME fPage1. 

    ENABLE btCheck2 
           c-cod-obra-ini
           c-cod-obra-fim WITH FRAME fPage2.

    ASSIGN c-cod-emit-fim:SCREEN-VALUE IN FRAME fPage1 = "ZZZZZZZZZZZZZZZ"
           c-cod-obra-fim:SCREEN-VALUE IN FRAME fPage2 = "ZZZZZZZZZZZZZZZ". 

    APPLY "CHOOSE" TO btCheck1 IN FRAME fpage1.
    APPLY "CHOOSE" TO btCheck2 IN FRAME fpage2.  

    DEFINE VARIABLE ix    AS INTEGER   NO-UNDO INITIAL 2.
    DEFINE VARIABLE plist AS CHARACTER NO-UNDO FORMAT "x(70)".
    
    /*ao ser chamado pelo CD4035, desabilitar CNPJ*/
    ASSIGN lExec4035 = NO.
    DO  i-cont = 2 TO 15:
        IF  PROGRAM-NAME(i-cont) MATCHES "*cd4035.w*" THEN DO:
            ASSIGN lExec4035 = YES.
            LEAVE.
        END.
    END.
    IF lExec4035 THEN DO:
        RUN SetFolder  IN hFolder (INPUT 2).
        RUN SetEnabled IN hFolder (INPUT 1,
                                   INPUT FALSE).
    END.

RETURN "OK":U.

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
    IF NOT VALID-HANDLE({&hDBOTable1}) OR
       {&hDBOTable1}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable1}:FILE-NAME <> "adbo/boad00544":U THEN DO:
       
        {btb/btb008za.i1 adbo/boad00544.p YES}
        {btb/btb008za.i2 adbo/boad00544.p '' {&hDBOTable1}} 
    END.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable2}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "adbo/boad00544":U THEN DO:
       
        {btb/btb008za.i1 adbo/boad00544.p YES}
        {btb/btb008za.i2 adbo/boad00544.p '' {&hDBOTable2}} 
    END.
    
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

    {zoom/openqueries.i &Query="CNPJ"
                        &PageNumber="1"}


    {zoom/openqueries.i &Query="CNO"
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
            WHEN "cod-obra":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-obra).
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage2 wZoom 
PROCEDURE returnFieldsPage2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable2} THEN DO:
        CASE pcField:
            WHEN "cod-obra":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-obra).
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
            RUN setConstraint IN {&hDBOTable1} (INPUT c-cod-emit-ini:SCREEN-VALUE IN FRAME fPage1,
                                                INPUT c-cod-emit-fim:SCREEN-VALUE IN FRAME fPage1).
        
        WHEN 2 THEN
            /*:T--- Seta Constraints para o DBO Table2 ---*/
            RUN setConstraintCNO IN {&hDBOTable2} (INPUT c-cod-obra-ini:SCREEN-VALUE IN FRAME fPage2,
                                                      c-cod-obra-fim:SCREEN-VALUE IN FRAME fPage2).
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnIdiObra wZoom 
FUNCTION fnIdiObra RETURNS CHARACTER
  ( i-idi-obra AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE i-idi-obra:
      WHEN 0 THEN DO:
          {utp/ut-liter.i "Obra nÆo ‚ constru‡Æo civil":U *}
          RETURN RETURN-VALUE.  
      END.
      WHEN 1 THEN DO:
          {utp/ut-liter.i "Empreitada total":U *}
          RETURN RETURN-VALUE.  
      END.
      WHEN 2 THEN DO: 
          {utp/ut-liter.i "Empreitada parcial":U *}
          RETURN RETURN-VALUE.  
      END.
  END CASE.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

