&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-usuar-mater NO-UNDO LIKE usuar-mater
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0310 2.00.00.002 } /*** 010002 ***/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          AF0310
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE Folder           no  

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        no
&GLOBAL-DEFINE CopyParent       no
&GLOBAL-DEFINE UpdateParent     no
&GLOBAL-DEFINE DeleteParent     no

&GLOBAL-DEFINE AddSon1          no
&GLOBAL-DEFINE CopySon1         no
&GLOBAL-DEFINE UpdateSon1       YES
&GLOBAL-DEFINE DeleteSon1       no

{afbo/boaf008.i tt-af-contr-indice}
{afbo/boaf008.i3 tt-af-contr-indice-aux} 
{afbo/boaf008.i3 tt-af-contr-indice-aux2}

&GLOBAL-DEFINE ttParent         tt-usuar-mater
&GLOBAL-DEFINE hDBOParent       h-boin627
&GLOBAL-DEFINE DBOParentTable   usuar-mater
&GLOBAL-DEFINE DBOParentDestroy yes

&GLOBAL-DEFINE ttSon1           tt-af-contr-indice
&GLOBAL-DEFINE hDBOSon1         h-boaf008
&GLOBAL-DEFINE DBOSon1Table     tt-af-contr-indice-aux
&GLOBAL-DEFINE DBOSon1Destroy   yes

&GLOBAL-DEFINE page0Fields      tt-usuar-mater.cod-usuario ~
                                tt-usuar-mater.nome-usuar

&GLOBAL-DEFINE page1Browse brSon1    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable l-ok             as logical                  no-undo.
define variable i-ano            as integer                  no-undo.
define variable c-periodo        as character format "x(10)" no-undo.
define variable h-boaf016        as handle                   no-undo.
define variable l-consulta       as logical                  no-undo.
define variable l-validou        as logical                  no-undo.
define variable c-periodo-indice as character                no-undo.
define variable dt-data-indice   as date format "99/99/9999" no-undo.
DEFINE VARIABLE c-desc-item      LIKE item.desc-item         NO-UNDO.

DEFINE VARIABLE r-rowid-pos      AS ROWID      NO-UNDO.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa   AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
{afbo/boaf008.i2}  /* tt-filtro */

/* Valida‡Æo licen‡a MAF */


/* &scoped-define MOUSE-SELECT-DBLCLICK1 YES  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-af-contr-indice-aux

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-af-contr-indice-aux.cod-estabel tt-af-contr-indice-aux.cod-emitente tt-af-contr-indice-aux.it-codigo tt-af-contr-indice-aux.nr-controle tt-af-contr-indice-aux.nome-controle fn_data_indice () @ dt-data-indice fn_periodo() @ c-periodo-indice tt-af-contr-indice-aux.indice tt-af-contr-indice-aux.percentual tt-af-contr-indice-aux.nota fn_desc_item () @ c-desc-item tt-af-contr-indice-aux.usuar-alter tt-af-contr-indice-aux.dt-implantacao tt-af-contr-indice-aux.dt-alter tt-af-contr-indice-aux.hora-alter   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define SELF-NAME brSon1
&Scoped-define OPEN-QUERY-brSon1     if  tt-filtro.classif = 1 then         open query {&SELF-NAME}             for each tt-af-contr-indice-aux             no-lock by tt-af-contr-indice-aux.cod-emitente                     by tt-af-contr-indice-aux.cod-estabel                     by tt-af-contr-indice-aux.it-codigo                     by tt-af-contr-indice-aux.nr-controle                     by tt-af-contr-indice-aux.dt-indice.     else         if  tt-filtro.classif = 2 then             open query {&SELF-NAME}                 for each tt-af-contr-indice-aux                 no-lock by tt-af-contr-indice-aux.it-codigo                         by tt-af-contr-indice-aux.cod-emitente                         by tt-af-contr-indice-aux.cod-estabel                         by tt-af-contr-indice-aux.nr-controle                         by tt-af-contr-indice-aux.dt-indice.         else             if  tt-filtro.classif = 3 then                 open query {&SELF-NAME}                     for each tt-af-contr-indice-aux                     no-lock by tt-af-contr-indice-aux.nr-controle                             by tt-af-contr-indice-aux.it-codigo                             by tt-af-contr-indice-aux.cod-emitente                             by tt-af-contr-indice-aux.cod-estabel                             by tt-af-contr-indice-aux.dt-indice.             else                 open query {&SELF-NAME}                     for each tt-af-contr-indice-aux                     no-lock by tt-af-contr-indice-aux.dt-indice                             by tt-af-contr-indice-aux.cod-emitente                             by tt-af-contr-indice-aux.cod-estabel                             by tt-af-contr-indice-aux.it-codigo                             by tt-af-contr-indice-aux.nr-controle.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-af-contr-indice-aux
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-af-contr-indice-aux


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-usuar-mater.cod-usuario ~
tt-usuar-mater.nome-usuar 
&Scoped-define ENABLED-TABLES tt-usuar-mater
&Scoped-define FIRST-ENABLED-TABLE tt-usuar-mater
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btFiltro btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-usuar-mater.cod-usuario ~
tt-usuar-mater.nome-usuar 
&Scoped-define DISPLAYED-TABLES tt-usuar-mater
&Scoped-define FIRST-DISPLAYED-TABLE tt-usuar-mater


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn_data_indice wMasterDetail 
FUNCTION fn_data_indice RETURNS DATE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn_desc_item wMasterDetail 
FUNCTION fn_desc_item RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn_periodo wMasterDetail 
FUNCTION fn_periodo RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miFiltro       LABEL "&Filtro"        ACCELERATOR "CTRL-F6"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image/im-param.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro".

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image/im-fir":U
     IMAGE-INSENSITIVE FILE "image/ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image/im-enter":U
     IMAGE-INSENSITIVE FILE "image/ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image/im-las":U
     IMAGE-INSENSITIVE FILE "image/ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image/im-nex":U
     IMAGE-INSENSITIVE FILE "image/ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image/im-pre":U
     IMAGE-INSENSITIVE FILE "image/ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image/im-joi":U
     IMAGE-INSENSITIVE FILE "image/ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image/im-pri":U
     IMAGE-INSENSITIVE FILE "image/ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btNarrativa 
     LABEL "&Narrativas" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon1 
     LABEL "&Aponta" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-af-contr-indice-aux SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 NO-LOCK DISPLAY
      tt-af-contr-indice-aux.cod-estabel FORMAT "X(5)":U
      tt-af-contr-indice-aux.cod-emitente FORMAT ">>>>>>>>9":U
      tt-af-contr-indice-aux.it-codigo FORMAT "x(16)":U
      tt-af-contr-indice-aux.nr-controle FORMAT ">>>>>9":U column-label "Contr."
      tt-af-contr-indice-aux.nome-controle FORMAT "x(30)":U
      fn_data_indice () @ dt-data-indice FORMAT "99/99/9999":U column-label "Dt Öndice"
      fn_periodo() @ c-periodo-indice format "99/9999":U column-label "Per¡odo"
      tt-af-contr-indice-aux.indice FORMAT "->>9.9999":U
      tt-af-contr-indice-aux.percentual FORMAT ">>9.99":U
      tt-af-contr-indice-aux.nota FORMAT "->>9.9999":U
      fn_desc_item () @ c-desc-item COLUMN-LABEL "Descri‡Æo do Item"
      tt-af-contr-indice-aux.usuar-alter FORMAT "X(12)":U
      tt-af-contr-indice-aux.dt-implantacao FORMAT "99/99/9999":U
      tt-af-contr-indice-aux.dt-alter FORMAT "99/99/9999":U
      tt-af-contr-indice-aux.hora-alter FORMAT "X(8)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88.57 BY 9.83
         FONT 2 ROW-HEIGHT-CHARS .63.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrˆncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrˆncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrˆncia"
     btLast AT ROW 1.13 COL 13.57 HELP
          "éltima ocorrˆncia"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V  Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btFiltro AT ROW 1.13 COL 70.86
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-usuar-mater.cod-usuario AT ROW 3.42 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.29 BY .88
     tt-usuar-mater.nome-usuar AT ROW 3.42 COL 26.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 54.43 BY .88
     rtParent AT ROW 2.75 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 16
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 1.43
     btUpdateSon1 AT ROW 11.25 COL 2
     btNarrativa AT ROW 11.25 COL 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 5.25
         SIZE 90 BY 11.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-usuar-mater T "?" NO-UNDO mgind usuar-mater
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMasterDetail ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16
         WIDTH              = 90.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90.14
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90.14
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMasterDetail 
/* ************************* Included-Libraries *********************** */

{masterdetail/masterdetail.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMasterDetail
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
ASSIGN 
       brSon1:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       brSon1:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
    if  tt-filtro.classif = 1 then
        open query {&SELF-NAME}
            for each tt-af-contr-indice-aux
            no-lock by tt-af-contr-indice-aux.cod-emitente
                    by tt-af-contr-indice-aux.cod-estabel
                    by tt-af-contr-indice-aux.it-codigo
                    by tt-af-contr-indice-aux.nr-controle
                    by tt-af-contr-indice-aux.dt-indice.
    else
        if  tt-filtro.classif = 2 then
            open query {&SELF-NAME}
                for each tt-af-contr-indice-aux
                no-lock by tt-af-contr-indice-aux.it-codigo
                        by tt-af-contr-indice-aux.cod-emitente
                        by tt-af-contr-indice-aux.cod-estabel
                        by tt-af-contr-indice-aux.nr-controle
                        by tt-af-contr-indice-aux.dt-indice.
        else
            if  tt-filtro.classif = 3 then
                open query {&SELF-NAME}
                    for each tt-af-contr-indice-aux
                    no-lock by tt-af-contr-indice-aux.nr-controle
                            by tt-af-contr-indice-aux.it-codigo
                            by tt-af-contr-indice-aux.cod-emitente
                            by tt-af-contr-indice-aux.cod-estabel
                            by tt-af-contr-indice-aux.dt-indice.
            else
                open query {&SELF-NAME}
                    for each tt-af-contr-indice-aux
                    no-lock by tt-af-contr-indice-aux.dt-indice
                            by tt-af-contr-indice-aux.cod-emitente
                            by tt-af-contr-indice-aux.cod-estabel
                            by tt-af-contr-indice-aux.it-codigo
                            by tt-af-contr-indice-aux.nr-controle.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON MOUSE-SELECT-DBLCLICK OF brSon1 IN FRAME fPage1
DO:
  /* 
   if  avail tt-af-contr-indice-aux then do:

        empty temp-table tt-af-contr-indice-aux2.
        create tt-af-contr-indice-aux2.
        buffer-copy tt-af-contr-indice-aux to tt-af-contr-indice-aux2.

        run afp/af0310a.w (input table tt-af-contr-indice-aux2,
                           output l-ok).
        if  l-ok then
            run openQueriesSon in this-procedure.
    end.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro wMasterDetail
ON CHOOSE OF btFiltro IN FRAME fPage0
OR CHOOSE OF MENU-ITEM miFiltro IN MENU mbMain DO:
    run afp/af0310c.w (input-output table tt-filtro,
                       output l-ok).
    if  l-ok then
        run openQueriesSon in this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMasterDetail
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMasterDetail
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMasterDetail
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btNarrativa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNarrativa wMasterDetail
ON CHOOSE OF btNarrativa IN FRAME fPage1 /* Narrativas */
DO:
    IF  AVAIL tt-af-contr-indice-aux THEN DO:
        RUN afp/af0310b1.w (INPUT tt-af-contr-indice-aux.ep-codigo,
                            INPUT tt-af-contr-indice-aux.it-codigo,
                            INPUT tt-af-contr-indice-aux.cod-emitente,
                            INPUT tt-af-contr-indice-aux.cod-estabel,
                            INPUT tt-af-contr-indice-aux.nr-controle).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMasterDetail
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMasterDetail
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    /*{method/ZoomReposition.i &ProgramZoom="inzoom/z01in627.w"}*/
    {include/zoomvarReposition.i &prog-zoom="inzoom/z01in627.w"
                                 &campo="tt-usuar-mater.cod-usuario"
                                 &campozoom="cod-usuario"
                                 &FindMethod="goToKey"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Aponta */
DO:
    if  avail tt-af-contr-indice-aux then do:

        empty temp-table tt-af-contr-indice-aux2.
        create tt-af-contr-indice-aux2.
        buffer-copy tt-af-contr-indice-aux to tt-af-contr-indice-aux2.

        run afp/af0310a.w (input table tt-af-contr-indice-aux2,
                           output l-ok).
        if  l-ok then
            run openQueriesSon in this-procedure.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{masterdetail/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMasterDetail 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  valid-handle(h-boaf016) then do:
        delete procedure h-boaf016.
        assign h-boaf016 = ?.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /********* VALIDA USUARIO/SENHA *********/
    if  input frame fPage0 tt-usuar-mater.cod-usuario = c-seg-usuario then do:

        if  not l-validou then do:

            assign l-validou = yes.
            /*--- Visualizacao da Janela ---*/
            view wMasterDetail.
        
            /*--- valida senha do usu¨rio logado no sistema ---*/
            run btb/btb910zz.p (input c-seg-usuario, input no).
        
            /*--- caso a senha n’o seja informada corretamente 
                  os campos ficar’o desabilidatos ---*/
            if  return-value = "NOK":U then 
                assign l-consulta = yes.
            else
                assign l-consulta = no.
        end.
    end.
    else
        assign l-consulta = yes
               l-validou  = no.
    
    if  l-consulta then
        disable btUpdateSon1 with frame fPage1.
    else
        enable btUpdateSon1 with frame fPage1.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign btFiltro:sensitive    in frame fPage0 = yes
           btNarrativa:sensitive in frame fPage1 = yes.

    IF  VALID-HANDLE({&hDBOParent}) THEN DO:
        RUN goToKey IN {&hDBOParent} (INPUT c-seg-usuario).

        IF  RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Usu rio" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            RETURN "NOK":U.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT r-rowid-pos).
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowid-pos).
    END.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMasterDetail 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  not avail tt-filtro then do:

        create tt-filtro.

        /*:T--- Verifica se o DBO j  est  inicializado ---*/
        if  not valid-handle(h-boaf016) 
        or  h-boaf016:type <> "PROCEDURE":U 
        or  h-boaf016:file-name <> "afbo/boaf016.p":U
        or  h-boaf016:file-name <> "afbo/boaf016.r":U then
            run afbo/boaf016.p persistent set h-boaf016.
    
        run openQueryStatic in h-boaf016 (input "Main":U).

        run retornaFaixaPeriodos in h-boaf016 (input today,
                                               output i-ano,
                                               output c-periodo).

        assign tt-filtro.ano-ini     = string(i-ano)
               tt-filtro.periodo-ini = c-periodo
               tt-filtro.ano-fim     = string(i-ano)
               tt-filtro.periodo-fim = c-periodo.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 40 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE cCodUsuario LIKE {&ttParent}.cod-usuario NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        cCodUsuario       AT ROW 1.80 COL 14.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Usu rio" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
    
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cCodUsuario.
        
        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT cCodUsuario ).
        IF  RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Usu rio" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cCodUsuario btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    if  not valid-handle({&hDBOParent}) 
    or  {&hDBOParent}:type <> "PROCEDURE":U 
    or  {&hDBOParent}:file-name <> "inbo/boin627na.p":U 
    or  {&hDBOParent}:file-name <> "inbo/boin627na.r":U then
        run inbo/boin627na.p persistent set {&hDBOParent}.

    run openQueryStatic in {&hDBOParent} (input "Main":U) no-error.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    if  not valid-handle({&hDBOSon1}) 
    or  {&hDBOSon1}:type <> "PROCEDURE":U 
    or  {&hDBOSon1}:file-name <> "afbo/boaf008.p":U
    or  {&hDBOSon1}:file-name <> "afbo/boaf008.r":U then
        run afbo/boaf008.p persistent set {&hDBOSon1}.

    run openQueryStatic in {&hDBOSon1} (input "Main":U) no-error.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    find first tt-filtro no-error.
    if  avail tt-usuar-mater then
        run getIndicesUsuario in h-boaf008 (input tt-usuar-mater.cod-usuario,
                                            input table tt-filtro,
                                            output table tt-af-contr-indice-aux).
    {&OPEN-QUERY-brSon1}
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn_data_indice wMasterDetail 
FUNCTION fn_data_indice RETURNS DATE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    if  tt-af-contr-indice-aux.log-per-variavel then
        return tt-af-contr-indice-aux.dt-indice.
    else 
        return ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn_desc_item wMasterDetail 
FUNCTION fn_desc_item RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FIND ITEM WHERE ITEM.it-codigo = tt-af-contr-indice-aux.it-codigo NO-LOCK NO-ERROR.
  IF AVAIL ITEM THEN
      ASSIGN c-desc-item = ITEM.desc-item.
  ELSE 
      ASSIGN c-desc-item = "".

  RETURN c-desc-item.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn_periodo wMasterDetail 
FUNCTION fn_periodo RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    if  not tt-af-contr-indice-aux.log-per-variavel then
        return string(month(tt-af-contr-indice-aux.dt-indice),"99") +
               string(year(tt-af-contr-indice-aux.dt-indice),"9999").
    else 
        return "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

