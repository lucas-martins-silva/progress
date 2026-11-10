&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emsdca            PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttAf-item-contr-estab NO-UNDO LIKE af-item-contr-estab
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
{include/i-prgvrs.i Z01AF006 2.00.00.002 } /*** 010002 ***/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           Z01AF006
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Pto Con Est

&GLOBAL-DEFINE Range             YES

&GLOBAL-DEFINE FieldsAnyKeyPage1 YES,YES,YES,YES

&GLOBAL-DEFINE ttTable1          ttAf-item-contr-estab
&GLOBAL-DEFINE hDBOTable1        h-boaf006
&GLOBAL-DEFINE DBOTable1         ttAf-item-contr-estab

&GLOBAL-DEFINE page1Browse       brTable1

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf022 AS HANDLE      NO-UNDO.

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
&Scoped-define INTERNAL-TABLES ttAf-item-contr-estab

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 ttAf-item-contr-estab.cod-estabel ~
ttAf-item-contr-estab.it-codigo ttAf-item-contr-estab.cod-emitente ~
ttAf-item-contr-estab.nr-versao ttAf-item-contr-estab.quantidade ~
ttAf-item-contr-estab.qualidade ttAf-item-contr-estab.preco ~
ttAf-item-contr-estab.data-entrega ttAf-item-contr-estab.nr-dia-max ~
ttAf-item-contr-estab.nr-dia-min ttAf-item-contr-estab.demerito ~
ttAf-item-contr-estab.dt-implantacao ttAf-item-contr-estab.dt-alter ~
ttAf-item-contr-estab.hora-alter ttAf-item-contr-estab.usuar-alter 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH ttAf-item-contr-estab NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH ttAf-item-contr-estab NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 ttAf-item-contr-estab
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 ttAf-item-contr-estab


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

DEFINE BUTTON btCheck1 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "Button 1" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-cod-estabel-fim AS CHARACTER FORMAT "x(5)" INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-ini LIKE af-item-contr-estab.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo-ini LIKE af-item-contr.it-codigo
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente-ini LIKE af-familia-contr.cod-emitente
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE nr-versao-fim AS INTEGER FORMAT ">>>>9" INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE nr-versao-ini LIKE af-familia-contr.nr-versao
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-8
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      ttAf-item-contr-estab SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      ttAf-item-contr-estab.cod-estabel FORMAT "X(5)":U
      ttAf-item-contr-estab.it-codigo FORMAT "x(16)":U
      ttAf-item-contr-estab.cod-emitente FORMAT ">>>>>>>>9":U
      ttAf-item-contr-estab.nr-versao FORMAT ">>>>9":U
      ttAf-item-contr-estab.quantidade FORMAT "Sim/Nao":U
      ttAf-item-contr-estab.qualidade FORMAT "Sim/Nao":U
      ttAf-item-contr-estab.preco FORMAT "Sim/Nao":U
      ttAf-item-contr-estab.data-entrega FORMAT "Sim/Nao":U
      ttAf-item-contr-estab.nr-dia-max FORMAT ">>>>>9":U
      ttAf-item-contr-estab.nr-dia-min FORMAT ">>>>>9":U
      ttAf-item-contr-estab.demerito FORMAT ">>9.99":U
      ttAf-item-contr-estab.dt-implantacao FORMAT "99/99/9999":U
      ttAf-item-contr-estab.dt-alter FORMAT "99/99/9999":U
      ttAf-item-contr-estab.hora-alter FORMAT "X(8)":U
      ttAf-item-contr-estab.usuar-alter FORMAT "X(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 7.75
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
     btCheck1 AT ROW 1.17 COL 79
     c-cod-estabel-ini AT ROW 1.25 COL 26.14 COLON-ALIGNED HELP
          "C¢digo do estabelecimento"
     c-cod-estabel-fim AT ROW 1.25 COL 46 COLON-ALIGNED HELP
          "C¢digo da fam¡lia do material" NO-LABEL
     c-it-codigo-ini AT ROW 2.25 COL 15 COLON-ALIGNED HELP
          "C¢digo do Item"
     c-it-codigo-fim AT ROW 2.25 COL 45.86 COLON-ALIGNED HELP
          "C¢digo da fam¡lia do material" NO-LABEL
     i-cod-emitente-ini AT ROW 3.25 COL 23.14 COLON-ALIGNED HELP
          "C¢digo do fornecedor"
     i-cod-emitente-fim AT ROW 3.25 COL 46 COLON-ALIGNED HELP
          "C¢digo do fornecedor" NO-LABEL
     nr-versao-ini AT ROW 4.25 COL 26.14 COLON-ALIGNED HELP
          "N£mero da versÆo"
     nr-versao-fim AT ROW 4.25 COL 46 COLON-ALIGNED HELP
          "N£mero da versÆo" NO-LABEL
     brTable1 AT ROW 5.25 COL 2
     btImplant1 AT ROW 13 COL 2
     IMAGE-3 AT ROW 1.25 COL 35
     IMAGE-4 AT ROW 1.25 COL 44.14
     IMAGE-5 AT ROW 2.25 COL 35
     IMAGE-6 AT ROW 2.25 COL 44.14
     IMAGE-7 AT ROW 4.25 COL 35
     IMAGE-8 AT ROW 4.13 COL 44.14
     IMAGE-9 AT ROW 3.25 COL 34.86
     IMAGE-10 AT ROW 3.25 COL 44
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
   Temp-Tables and Buffers:
      TABLE: ttAf-item-contr-estab T "?" NO-UNDO emsdca af-item-contr-estab
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable1 nr-versao-fim fPage1 */
/* SETTINGS FOR FILL-IN c-cod-estabel-ini IN FRAME fPage1
   LIKE = emsdca.af-item-contr-estab.cod-estabel EXP-SIZE                */
/* SETTINGS FOR FILL-IN c-it-codigo-ini IN FRAME fPage1
   LIKE = emsdca.af-item-contr.it-codigo EXP-SIZE                        */
/* SETTINGS FOR FILL-IN i-cod-emitente-ini IN FRAME fPage1
   LIKE = emsdca.af-familia-contr.cod-emitente EXP-SIZE                  */
/* SETTINGS FOR FILL-IN nr-versao-ini IN FRAME fPage1
   LIKE = emsdca.af-familia-contr.nr-versao EXP-SIZE                     */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.ttAf-item-contr-estab"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttAf-item-contr-estab.cod-estabel
     _FldNameList[2]   = Temp-Tables.ttAf-item-contr-estab.it-codigo
     _FldNameList[3]   = Temp-Tables.ttAf-item-contr-estab.cod-emitente
     _FldNameList[4]   = Temp-Tables.ttAf-item-contr-estab.nr-versao
     _FldNameList[5]   = Temp-Tables.ttAf-item-contr-estab.quantidade
     _FldNameList[6]   = Temp-Tables.ttAf-item-contr-estab.qualidade
     _FldNameList[7]   = Temp-Tables.ttAf-item-contr-estab.preco
     _FldNameList[8]   = Temp-Tables.ttAf-item-contr-estab.data-entrega
     _FldNameList[9]   = Temp-Tables.ttAf-item-contr-estab.nr-dia-max
     _FldNameList[10]   = Temp-Tables.ttAf-item-contr-estab.nr-dia-min
     _FldNameList[11]   = Temp-Tables.ttAf-item-contr-estab.demerito
     _FldNameList[12]   = Temp-Tables.ttAf-item-contr-estab.dt-implantacao
     _FldNameList[13]   = Temp-Tables.ttAf-item-contr-estab.dt-alter
     _FldNameList[14]   = Temp-Tables.ttAf-item-contr-estab.hora-alter
     _FldNameList[15]   = Temp-Tables.ttAf-item-contr-estab.usuar-alter
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
ON CHOOSE OF btCheck1 IN FRAME fPage1 /* Button 1 */
DO:
  RUN setConstraints IN THIS-PROCEDURE (INPUT 1).
  APPLY 'entry' TO brTable1.
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
    /*{zoom/Implant.i &ProgramImplant="<ProgramName>"
                    &PageNumber="1"} */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wZoom 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE l-usa-versao AS LOGICAL     NO-UNDO.

ENABLE btCheck1
       c-cod-estabel-ini
       c-cod-estabel-fim
       i-cod-emitente-ini
       i-cod-emitente-fim
       c-it-codigo-ini
       c-it-codigo-fim
       nr-versao-ini
       nr-versao-fim
    WITH FRAME fpage1.

ASSIGN c-cod-estabel-ini:SCREEN-VALUE IN FRAME fpage1 = ""
       c-cod-estabel-fim:SCREEN-VALUE IN FRAME fpage1 = "ZZZZZ"
       i-cod-emitente-ini:SCREEN-VALUE IN FRAME fpage1 = "0"
       i-cod-emitente-fim:SCREEN-VALUE IN FRAME fpage1 = "999999999"
       c-it-codigo-ini:SCREEN-VALUE IN FRAME fpage1 = ""
       c-it-codigo-fim:SCREEN-VALUE IN FRAME fpage1 = "ZZZZZZZZZZZZZZZZ"
       nr-versao-ini:SCREEN-VALUE IN FRAME fpage1 = "0"
       nr-versao-fim:SCREEN-VALUE IN FRAME fpage1 = "99999".

RUN getLogField IN h-boaf022 (INPUT "log-usa-versao":U, OUTPUT l-usa-versao).
IF NOT l-usa-versao THEN
    DISABLE nr-versao-ini
            nr-versao-fim
        WITH FRAME fpage1.


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
       {&hDBOTable1}:FILE-NAME <> "afbo/boaf006.p":U THEN DO:
       
        {btb/btb008za.i1 afbo/boaf006.p YES}
        {btb/btb008za.i2 afbo/boaf006.p '' {&hDBOTable1}} 
    END.
    
    IF NOT VALID-HANDLE(h-boaf022) THEN DO:
        RUN afbo/boaf022.p PERSISTENT SET h-boaf022.
    END.

    RUN openQueryStatic IN h-boaf022 (INPUT "Main":U) NO-ERROR.

    RUN setConstraintEstItemContr IN {&hDBOTable1} ("","ZZZZZ","","ZZZZZZZZZZZZZZZZ",0,999999999,0,99999) NO-ERROR.

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
    
    {zoom/OpenQueries.i &Query="EstItemContr"
                        &PageNumber="1"}

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
            WHEN "cod-estabel":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-estabel).
            WHEN "it-codigo":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.it-codigo).
            WHEN "cod-emitente":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-emitente).
            WHEN "nr-versao":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nr-versao).
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
            RUN setConstraintEstItemContr IN {&hDBOTable1} (INPUT INPUT FRAME fpage1 c-cod-estabel-ini,
                                                            INPUT INPUT FRAME fpage1 c-cod-estabel-fim,
                                                            INPUT INPUT FRAME fpage1 c-it-codigo-ini,
                                                            INPUT INPUT FRAME fpage1 c-it-codigo-fim,
                                                            INPUT INPUT FRAME fpage1 i-cod-emitente-ini,
                                                            INPUT INPUT FRAME fpage1 i-cod-emitente-fim,
                                                            INPUT INPUT FRAME fpage1 nr-versao-ini,
                                                            INPUT INPUT FRAME fpage1 nr-versao-fim).


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

