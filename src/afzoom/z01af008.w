&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emsdca           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-af-contr-indice NO-UNDO LIKE af-contr-indice
       field r-rowid as rowid
       .



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wZoom 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i Z01AF008 2.00.00.001 } /*** 010001 ***/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           Z01AF008
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Öndices

&GLOBAL-DEFINE Range             NO

&GLOBAL-DEFINE FieldsRangePage1  c-cod-estabel-ini c-cod-estabel-fim

&GLOBAL-DEFINE ttTable1          tt-af-contr-indice
&GLOBAL-DEFINE hDBOTable1        h-boaf008
&GLOBAL-DEFINE DBOTable1         af-contr-indice

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
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTable1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-af-contr-indice

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-af-contr-indice.cod-estabel ~
tt-af-contr-indice.dt-indice tt-af-contr-indice.cod-emitente ~
tt-af-contr-indice.it-codigo tt-af-contr-indice.nr-controle ~
tt-af-contr-indice.indice 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-af-contr-indice NO-LOCK ~
    BY tt-af-contr-indice.cod-estabel ~
       BY tt-af-contr-indice.dt-indice ~
        BY tt-af-contr-indice.cod-emitente ~
         BY tt-af-contr-indice.it-codigo ~
          BY tt-af-contr-indice.nr-controle
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-af-contr-indice NO-LOCK ~
    BY tt-af-contr-indice.cod-estabel ~
       BY tt-af-contr-indice.dt-indice ~
        BY tt-af-contr-indice.cod-emitente ~
         BY tt-af-contr-indice.it-codigo ~
          BY tt-af-contr-indice.nr-controle.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-af-contr-indice
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-af-contr-indice


/* Definitions for FRAME fPage1                                         */

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

DEFINE BUTTON btquery1 
     IMAGE-UP FILE "image/im-sav":U
     IMAGE-INSENSITIVE FILE "image/ii-sav":U
     LABEL "Save" 
     SIZE 5 BY 1.25
     FONT 4.

DEFINE VARIABLE c-cod-estabel-fim AS CHARACTER FORMAT "X(5)" INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6.5 BY .88.

DEFINE VARIABLE c-cod-estabel-ini AS CHARACTER FORMAT "X(5)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6.57 BY .88.

DEFINE VARIABLE c-dt-indice-fim AS CHARACTER FORMAT "99/9999" INITIAL "01/0001" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE c-dt-indice-ini AS CHARACTER FORMAT "99/9999" INITIAL "01/0001" 
     LABEL "Data Öndice" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE c-it-codigo-fim AS CHARACTER FORMAT "x(16)" INITIAL "zzzzzzzzzzzzzzzz" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE c-it-codigo-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE i-cod-emitente-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-cod-emitente-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE VARIABLE i-nr-controle-fim AS INTEGER FORMAT ">>>>>9" INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE i-nr-controle-ini AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "N£mero Controle" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-af-contr-indice SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-af-contr-indice.cod-estabel FORMAT "X(5)":U WIDTH 4.43
      tt-af-contr-indice.dt-indice FORMAT "99/99/9999":U WIDTH 12.43
      tt-af-contr-indice.cod-emitente FORMAT ">>>>>>>>9":U WIDTH 12.43
      tt-af-contr-indice.it-codigo FORMAT "x(16)":U WIDTH 18.43
      tt-af-contr-indice.nr-controle FORMAT ">>>>>9":U WIDTH 12.43
      tt-af-contr-indice.indice FORMAT "->>9.9999":U WIDTH 11.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 79 BY 7.75
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
     c-cod-estabel-ini AT ROW 1.5 COL 16.43 COLON-ALIGNED HELP
          "C¢digo do estabelecimento"
     c-cod-estabel-fim AT ROW 1.5 COL 32 COLON-ALIGNED HELP
          "C¢digo do estabelecimento" NO-LABEL
     c-dt-indice-ini AT ROW 1.5 COL 55 COLON-ALIGNED HELP
          "Data do ¡ndice"
     c-dt-indice-fim AT ROW 1.5 COL 73 COLON-ALIGNED HELP
          "Data do ¡ndice" NO-LABEL
     i-cod-emitente-ini AT ROW 2.5 COL 12 COLON-ALIGNED HELP
          "C¢digo do fornecedor"
     i-cod-emitente-fim AT ROW 2.5 COL 32 COLON-ALIGNED HELP
          "C¢digo do fornecedor" NO-LABEL
     i-nr-controle-ini AT ROW 2.5 COL 57 COLON-ALIGNED HELP
          "N£mero do ponto de controle"
     i-nr-controle-fim AT ROW 2.5 COL 73 COLON-ALIGNED HELP
          "N£mero do ponto de controle" NO-LABEL
     c-it-codigo-ini AT ROW 3.5 COL 7 COLON-ALIGNED HELP
          "C¢digo do Item"
     c-it-codigo-fim AT ROW 3.5 COL 32 COLON-ALIGNED HELP
          "C¢digo do Item" NO-LABEL
     btquery1 AT ROW 3.5 COL 77 HELP
          "Confirma altera‡äes"
     brTable1 AT ROW 4.75 COL 3
     btImplant1 AT ROW 12.75 COL 3
     IMAGE-17 AT ROW 1.5 COL 30
     IMAGE-18 AT ROW 1.5 COL 26
     IMAGE-19 AT ROW 3.5 COL 30
     IMAGE-20 AT ROW 3.5 COL 26
     IMAGE-21 AT ROW 2.5 COL 71
     IMAGE-22 AT ROW 2.5 COL 67
     IMAGE-23 AT ROW 1.5 COL 71
     IMAGE-24 AT ROW 1.5 COL 67
     IMAGE-25 AT ROW 2.5 COL 30
     IMAGE-26 AT ROW 2.5 COL 26
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.46
         SIZE 84.43 BY 13.04
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-af-contr-indice T "?" NO-UNDO emsdca af-contr-indice
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
/* BROWSE-TAB brTable1 btquery1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-af-contr-indice"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-af-contr-indice.cod-estabel|yes,Temp-Tables.tt-af-contr-indice.dt-indice|yes,Temp-Tables.tt-af-contr-indice.cod-emitente|yes,Temp-Tables.tt-af-contr-indice.it-codigo|yes,Temp-Tables.tt-af-contr-indice.nr-controle|yes"
     _FldNameList[1]   > Temp-Tables.tt-af-contr-indice.cod-estabel
"tt-af-contr-indice.cod-estabel" ? ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-af-contr-indice.dt-indice
"tt-af-contr-indice.dt-indice" ? ? "date" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-af-contr-indice.cod-emitente
"tt-af-contr-indice.cod-emitente" ? ? "integer" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-af-contr-indice.it-codigo
"tt-af-contr-indice.it-codigo" ? ? "character" ? ? ? ? ? ? no ? no no "18.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-af-contr-indice.nr-controle
"tt-af-contr-indice.nr-controle" ? ? "integer" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-af-contr-indice.indice
"tt-af-contr-indice.indice" ? ? "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
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
    {zoom/Implant.i &ProgramImplant="afp/af0301.w"
                    &PageNumber="1"}
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btquery1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btquery1 wZoom
ON CHOOSE OF btquery1 IN FRAME fPage1 /* Save */
do:

  RUN setConstraints (input 1 ).
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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


    ENABLE c-cod-estabel-ini c-cod-estabel-fim
           i-cod-emitente-ini i-cod-emitente-fim
           c-it-codigo-ini c-it-codigo-fim
           i-nr-controle-ini i-nr-controle-fim
           c-dt-indice-ini c-dt-indice-fim  btQuery1 WITH FRAME fPage1.


    do with frame fpage1:
            assign c-dt-indice-ini:screen-value = string(month(today),"99") + "/" + 
                                                  string(year(today),"9999")
                   c-dt-indice-fim:screen-value = string(month(today),"99") + "/" + 
                                                  string(year(today),"9999")
                   c-cod-estabel-fim:screen-value = "ZZZZZ"
                   i-cod-emitente-fim:screen-value = "999999999"
                   c-it-codigo-fim:screen-value = "ZZZZZZZZZZZZZZZZ"
                   i-nr-controle-fim:screen-value = "999999".
    end.



    RETURN "OK".


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
       {&hDBOTable1}:FILE-NAME <> "afbo/boaf008.p":U THEN DO:
               
        {btb/btb008za.i1 afbo/boaf008.p YES}
        {btb/btb008za.i2 afbo/boaf008.p '' {&hDBOTable1}} 
    END.
    
    RUN setConstraintChave IN {&hDBOTable1} (input "",
                                             input "",
                                             input 0,
                                             input 0,
                                             input "",
                                             input "",
                                             input 0,
                                             input 0,
                                             input 01/01/0001,
                                             input 01/01/0001) NO-ERROR.
    
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
    
    {zoom/OpenQueries.i &Query="Chave"
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
            WHEN "cod-emitente":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-emitente).
            WHEN "it-codigo":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.it-codigo).
            WHEN "nr-controle":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nr-controle).
            WHEN "dt-indice":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.dt-indice).
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
    def var da-dt-indice-ini as date no-undo.
    def var da-dt-indice-fim as date no-undo.
    
    /*:T--- Seta constraints conforme n£mero da p gina ---*/
    CASE pPageNumber:
        WHEN 1 THEN do:
           run setPeriodo in h-boaf008 (input input frame fpage1 c-dt-indice-ini).
           run getDataPeriodo in h-boaf008 (output da-dt-indice-ini).
           run setPeriodo in h-boaf008 (input input frame fpage1 c-dt-indice-fim).
           run getDataPeriodo in h-boaf008 (output da-dt-indice-fim).
            /*:T--- Seta Constraints para o DBO Table1 ---*/
           RUN setConstraintChave IN {&hDBOTable1} (INPUT frame fpage1 c-cod-estabel-ini,
                                                    INPUT frame fpage1 c-cod-estabel-fim,
                                                    INPUT frame fpage1 i-cod-emitente-ini,
                                                    INPUT frame fpage1 i-cod-emitente-fim,
                                                    INPUT frame fpage1 c-it-codigo-ini,
                                                    INPUT frame fpage1 c-it-codigo-fim,
                                                    INPUT frame fpage1 i-nr-controle-ini,
                                                    INPUT frame fpage1 i-nr-controle-fim,
                                                    INPUT da-dt-indice-ini,
                                                    INPUT da-dt-indice-fim).
        end.
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

