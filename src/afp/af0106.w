&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-af-controle NO-UNDO LIKE af-controle
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-af-faixa-demerito1 NO-UNDO LIKE af-faixa-demerito
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-af-faixa-demerito2 NO-UNDO LIKE af-faixa-demerito
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
{include/i-prgvrs.i AF0106 2.00.00.004 } /*** "010004" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AF0106 MAF}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          AF0106
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Valor, Percentual

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddSon1          YES
&GLOBAL-DEFINE UpdateSon1       YES
&GLOBAL-DEFINE DeleteSon1       YES

&GLOBAL-DEFINE AddSon2          YES
&GLOBAL-DEFINE UpdateSon2       YES
&GLOBAL-DEFINE DeleteSon2       YES

&GLOBAL-DEFINE ttParent         tt-af-controle
&GLOBAL-DEFINE hDBOParent       h-boaf001
&GLOBAL-DEFINE DBOParentTable   af-controle
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           tt-af-faixa-demerito1
&GLOBAL-DEFINE hDBOSon1         h-boaf010-1
&GLOBAL-DEFINE DBOSon1Table     af-faixa-demerito
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE ttSon2           tt-af-faixa-demerito2
&GLOBAL-DEFINE hDBOSon2         h-boaf010-2
&GLOBAL-DEFINE DBOSon2Table     af-faixa-demerito
&GLOBAL-DEFINE DBOSon2Destroy   YES

&GLOBAL-DEFINE page0Fields      tt-af-controle.nr-controle tt-af-controle.descricao cb-versao

&GLOBAL-DEFINE page1Browse      brSon1 
&GLOBAL-DEFINE page2Browse      brSon2 

&GLOBAL-DEFINE page1Fields      BtAddSon1 btUpdateSon1 btDeleteSon1
&GLOBAL-DEFINE page2Fields      BtAddSon2 btUpdateSon2 btDeleteSon2

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE inr-versao LIKE af-versao-avaliacao.nr-versao   NO-UNDO.
DEFINE VARIABLE cdesc-versao LIKE af-versao-avaliacao.desc-versao   NO-UNDO.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf010-3   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf022 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boaf023 AS HANDLE      NO-UNDO.

{utp/ut-glob.i}

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
&Scoped-define INTERNAL-TABLES tt-af-faixa-demerito1 tt-af-faixa-demerito2

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-af-faixa-demerito1.seq-faixa ~
tt-af-faixa-demerito1.lim-inicial tt-af-faixa-demerito1.lim-final ~
tt-af-faixa-demerito1.demerito 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-af-faixa-demerito1 NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH tt-af-faixa-demerito1 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-af-faixa-demerito1
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-af-faixa-demerito1


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 tt-af-faixa-demerito2.seq-faixa ~
tt-af-faixa-demerito2.lim-inicial tt-af-faixa-demerito2.lim-final ~
tt-af-faixa-demerito2.demerito 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-af-faixa-demerito2 NO-LOCK
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH tt-af-faixa-demerito2 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-af-faixa-demerito2
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-af-faixa-demerito2


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Definitions for FRAME fpage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-af-controle.nr-controle ~
tt-af-controle.descricao 
&Scoped-define ENABLED-TABLES tt-af-controle
&Scoped-define FIRST-ENABLED-TABLE tt-af-controle
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp cb-versao 
&Scoped-Define DISPLAYED-FIELDS tt-af-controle.nr-controle ~
tt-af-controle.descricao 
&Scoped-define DISPLAYED-TABLES tt-af-controle
&Scoped-define FIRST-DISPLAYED-TABLE tt-af-controle
&Scoped-Define DISPLAYED-OBJECTS cb-versao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
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

DEFINE VARIABLE cb-versao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Vers∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 58.72 BY 1 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.08.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAddSon1 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon1 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon1 
     LABEL "Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btAddSon2 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon2 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon2 
     LABEL "Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-af-faixa-demerito1 SCROLLING.

DEFINE QUERY brSon2 FOR 
      tt-af-faixa-demerito2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      tt-af-faixa-demerito1.seq-faixa FORMAT ">>>9":U
      tt-af-faixa-demerito1.lim-inicial FORMAT "->>>,>>>,>>>,>>9.9999":U
      tt-af-faixa-demerito1.lim-final FORMAT "->>>,>>>,>>>,>>9.9999":U
      tt-af-faixa-demerito1.demerito COLUMN-LABEL "% DemÇrito" FORMAT ">>9.99":U
            WIDTH 12.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.04
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _STRUCTURED
  QUERY brSon2 NO-LOCK DISPLAY
      tt-af-faixa-demerito2.seq-faixa FORMAT ">>>9":U
      tt-af-faixa-demerito2.lim-inicial COLUMN-LABEL "% Limite Ini" FORMAT "->>>,>>>,>>>,>>9.9999":U
      tt-af-faixa-demerito2.lim-final COLUMN-LABEL "% Limite Final" FORMAT "->>>,>>>,>>>,>>9.9999":U
      tt-af-faixa-demerito2.demerito COLUMN-LABEL "% DemÇrito" FORMAT ">>9.99":U
            WIDTH 11.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.04
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-af-controle.nr-controle AT ROW 3.25 COL 17.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     tt-af-controle.descricao AT ROW 3.25 COL 27 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 49 BY .88
     cb-versao AT ROW 4.25 COL 17.29 COLON-ALIGNED
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.25 COL 2
     btAddSon1 AT ROW 10.42 COL 2
     btUpdateSon1 AT ROW 10.42 COL 12
     btDeleteSon1 AT ROW 10.42 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.25
         SIZE 84.43 BY 10.75
         FONT 1.

DEFINE FRAME fpage2
     brSon2 AT ROW 1.25 COL 2
     btAddSon2 AT ROW 10.42 COL 2
     btUpdateSon2 AT ROW 10.42 COL 12
     btDeleteSon2 AT ROW 10.42 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.25
         SIZE 84.43 BY 10.5
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-af-controle T "?" NO-UNDO emsdca af-controle
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-af-faixa-demerito1 T "?" NO-UNDO emsdca af-faixa-demerito
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-af-faixa-demerito2 T "?" NO-UNDO emsdca af-faixa-demerito
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
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 27.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.21
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
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE
       FRAME fpage2:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
/* SETTINGS FOR FRAME fpage2
                                                                        */
/* BROWSE-TAB brSon2 1 fpage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.tt-af-faixa-demerito1"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-af-faixa-demerito1.seq-faixa
     _FldNameList[2]   = Temp-Tables.tt-af-faixa-demerito1.lim-inicial
     _FldNameList[3]   = Temp-Tables.tt-af-faixa-demerito1.lim-final
     _FldNameList[4]   > Temp-Tables.tt-af-faixa-demerito1.demerito
"tt-af-faixa-demerito1.demerito" "% DemÇrito" ? "decimal" ? ? ? ? ? ? no ? no no "12.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.tt-af-faixa-demerito2"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-af-faixa-demerito2.seq-faixa
     _FldNameList[2]   > Temp-Tables.tt-af-faixa-demerito2.lim-inicial
"tt-af-faixa-demerito2.lim-inicial" "% Limite Ini" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-af-faixa-demerito2.lim-final
"tt-af-faixa-demerito2.lim-final" "% Limite Final" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-af-faixa-demerito2.demerito
"tt-af-faixa-demerito2.demerito" "% DemÇrito" ? "decimal" ? ? ? ? ? ? no ? no no "11.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon2 */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage2
/* Query rebuild information for FRAME fpage2
     _Query            is NOT OPENED
*/  /* FRAME fpage2 */
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:  
  RUN pi-versao-invalida.
  
  IF RETURN-VALUE = "NOK":U THEN
      RETURN "NOK":U.

    {masterdetail/AddSon.i &ProgramSon="afp/af0106a.w"
                       &PageNumber="1"}  
                       
    WAIT-FOR CLOSE OF hSonProgram.
    RUN pi-habilita-botoes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage2
&Scoped-define SELF-NAME btAddSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon2 wMasterDetail
ON CHOOSE OF btAddSon2 IN FRAME fpage2 /* Incluir */
DO:  
  RUN pi-versao-invalida.

  IF RETURN-VALUE = "NOK":U THEN
      RETURN "NOK":U.
    
    {masterdetail/AddSon.i &ProgramSon="afp/af0106a.w"
                       &PageNumber="2"}
                       
  WAIT-FOR CLOSE OF hSonProgram.
  RUN pi-habilita-botoes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMasterDetail
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:
    {masterdetail/DeleteSon.i &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage2
&Scoped-define SELF-NAME btDeleteSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon2 wMasterDetail
ON CHOOSE OF btDeleteSon2 IN FRAME fpage2 /* Eliminar */
DO:
    {masterdetail/DeleteSon.i &PageNumber="2"}
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
    {method/ZoomReposition.i &ProgramZoom="afzoom/z01af001.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Alterar */
DO:
    RUN pi-versao-invalida.

    IF RETURN-VALUE = "NOK":U THEN
      RETURN "NOK":U.
    
    {masterdetail/UpdateSon.i &ProgramSon="afp/af0106a.w"
                       &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage2
&Scoped-define SELF-NAME btUpdateSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon2 wMasterDetail
ON CHOOSE OF btUpdateSon2 IN FRAME fpage2 /* Alterar */
DO:
    RUN pi-versao-invalida.

    IF RETURN-VALUE = "NOK":U THEN
      RETURN "NOK":U.
    
    {masterdetail/UpdateSon.i &ProgramSon="afp/af0106a.w"
                       &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME cb-versao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-versao wMasterDetail
ON VALUE-CHANGED OF cb-versao IN FRAME fPage0 /* Vers∆o */
DO:
    IF entry(LOOKUP(cb-versao:SCREEN-VALUE IN FRAME fpage0,cb-versao:LIST-ITEM-PAIRS),
             cb-versao:LIST-ITEM-PAIRS) = "-1" THEN DO:

       DEFINE VARIABLE hProgram          AS HANDLE NO-UNDO.
        /*--- Seta cursor do mouse para espera ---*/
        SESSION:SET-WAIT-STATE("GENERAL":U).
        {&WINDOW-NAME}:SENSITIVE = NO.               

        RUN afp/af0106b.w PERSISTENT SET hProgram (INPUT THIS-PROCEDURE).
    
       /** Validaá∆o do Handle **/
       IF  VALID-HANDLE(hProgram) AND
           hProgram:TYPE = "PROCEDURE":U AND
           hProgram:FILE-NAME = "afp/af0106b.w":U THEN DO:
           /*--- Inicializa programa de alteraá∆o dos par≥metros ---*/
           RUN initializeInterface IN hProgram. 
       END.
        /** Espera pelo fechamento do programa **/
        WAIT-FOR "CLOSE":U of hProgram.

        IF cdesc-versao <> "" THEN
            RUN pi-valida-versao-existente (INPUT inr-versao, INPUT cdesc-versao).

        IF  VALID-HANDLE(hProgram) THEN DO:
            DELETE PROCEDURE hProgram.            
        END.
            
    END.
    ELSE DO:
        RUN openQueriesSon.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
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

    IF VALID-HANDLE(h-boaf010-3) THEN DO:
        DELETE PROCEDURE h-boaf010-3.
        ASSIGN h-boaf010-3 = ?.
    END.

    IF VALID-HANDLE (h-boaf022) THEN DO:
        DELETE PROCEDURE h-boaf022.
        ASSIGN h-boaf022 = ?.
    END.

    IF VALID-HANDLE (h-boaf022) THEN DO:
        DELETE PROCEDURE h-boaf022.
        ASSIGN h-boaf022 = ?.
    END.

    RETURN "OK":U.

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
IF NOT VALID-HANDLE(h-boaf022) THEN DO:
    RUN afbo/boaf022.p PERSISTENT SET h-boaf022.
    RUN openQueryStatic IN h-boaf022 (INPUT "Main":U) NO-ERROR.
END.

DEFINE VARIABLE l-usa-versao AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-usa-demerito AS LOGICAL     NO-UNDO.

RUN getLogField IN h-boaf022 (INPUT "log-usa-versao", OUTPUT l-usa-versao).
RUN getLogField IN h-boaf022 (INPUT "log-versao-demerito", OUTPUT l-usa-demerito).

IF l-usa-versao = FALSE OR l-usa-demerito = FALSE THEN DO:    
    DISABLE cb-versao
        WITH FRAME fpage0.

    IF NOT VALID-HANDLE(h-boaf023) THEN DO:
        RUN afbo/boaf023.p PERSISTENT SET h-boaf023.
        RUN openQueryStatic IN h-boaf023 (INPUT "Main":U) NO-ERROR.
    END.

    DEFINE VARIABLE  i-nr-versao  LIKE af-versao-avaliacao.nr-versao   NO-UNDO.

    RUN pi-retorna-menor-versao IN h-boaf023 (OUTPUT i-nr-versao).

    DEFINE VARIABLE  c-desc-versao  LIKE af-versao-avaliacao.desc-versao   NO-UNDO.

    RUN goToKey IN h-boaf023 (INPUT i-nr-versao, INPUT v_cdn_empres_usuar).
    
    IF RETURN-VALUE = "NOK":U THEN
         RETURN "NOK":U.

    RUN getCharField IN h-boaf023 (INPUT "desc-versao", OUTPUT c-desc-versao).
    ASSIGN  cb-versao:LIST-ITEM-PAIRS IN FRAME fpage0 = c-desc-versao + ',' + STRING(i-nr-versao).             

END.
ELSE DO:
    ENABLE cb-versao
        WITH FRAME fpage0.
     RUN pi-carrega-combobox.
END.

ASSIGN  cb-versao:SCREEN-VALUE IN FRAME fpage0 = ENTRY(2,cb-versao:LIST-ITEM-PAIRS).

RUN openQueriesSon.
RUN pi-habilita-botoes.

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

enable BtAddSon1 with frame fpage1.
enable BtAddSon2 with frame fpage2.
RUN pi-habilita-botoes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
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
         SIZE 30 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    define variable i-nr-controle like tt-af-controle.nr-controle.
    
    DEFINE FRAME fGoToRecord
        i-nr-controle     AT ROW 1.8 COL 14 COLON-ALIGNED
        btGoToOK        AT ROW 3.6 COL 2.14
        btGoToCancel    AT ROW 3.6 COL 13
        rtGoToButton    AT ROW 3.4 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Ponto de Controle" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
    


    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:

        ASSIGN i-nr-controle.

        RUN goToKey IN {&hDBOParent} (INPUT i-nr-controle).

        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Ponto_de_Controle" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            
            RETURN NO-APPLY.
        END.
        
        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE i-nr-controle
           btGoToOK btGoToCancel 
           WITH FRAME fGoToRecord. 

    ASSIGN i-nr-controle:HEIGHT    = 0.88
           i-nr-controle:WIDTH     = 7.

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

    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "afbo/boaf001.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf001.p YES}
        {btb/btb008za.i2 afbo/boaf001.p '' {&hDBOParent}} 
    END.
    
    RUN setConstraintNrControle IN {&hDBOParent} (input 2, input 4) NO-ERROR.
    RUN openQueryStatic IN {&hDBOParent} (INPUT "ByNrControle":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "afbo/boaf010.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf010.p YES}
        {btb/btb008za.i2 afbo/boaf010.p '' {&hDBOSon1}} 
    END.
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon2}) OR
       {&hDBOSon2}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon2}:FILE-NAME <> "afbo/boaf010.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf010.p YES}
        {btb/btb008za.i2 afbo/boaf010.p '' {&hDBOSon2}} 
    END.

    IF NOT VALID-HANDLE(h-boaf010-3) THEN DO:
        RUN afbo/boaf010.p PERSISTENT SET h-boaf010-3.
    END.

    IF NOT VALID-HANDLE (h-boaf022) THEN DO:
        RUN afbo/boaf022.p PERSISTEN SET h-boaf022.
    END.

    RUN openQueryStatic IN h-boaf022 (INPUT "Main":U) NO-ERROR. 

    IF NOT VALID-HANDLE (h-boaf023) THEN DO:
        RUN afbo/boaf023.p PERSISTEN SET h-boaf023.
    END.

    RUN openQueryStatic IN h-boaf023 (INPUT "Main":U) NO-ERROR. 
    
    RETURN "OK":U.
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
    def var i-rows as int no-undo.

    run setConstraintNrControleTipo in {&hDBOSon1} (input tt-af-controle.nr-controle,
                                                    input 1, INPUT DECIMAL(cb-versao:SCREEN-VALUE IN FRAME fpage0)).
    RUN openQueryStatic IN {&hDBOSon1} (INPUT "NrControleTipo":U) NO-ERROR.
    RUN getBatchRecords IN {&hDBOSon1} (INPUT ?, INPUT ?, INPUT ?, OUTPUT i-rows,
                                        OUTPUT TABLE tt-af-faixa-demerito1).
    {&OPEN-QUERY-brSon1}


    run setConstraintNrControleTipo in {&hDBOSon2} (input tt-af-controle.nr-controle,
                                                    input 2, INPUT DECIMAL(cb-versao:SCREEN-VALUE IN FRAME fpage0)).
    RUN openQueryStatic IN {&hDBOSon2} (INPUT "NrControleTipo":U) NO-ERROR.
    RUN getBatchRecords IN {&hDBOSon2} (INPUT ?, INPUT ?, INPUT ?, OUTPUT i-rows,
                                        OUTPUT TABLE tt-af-faixa-demerito2).
    {&OPEN-QUERY-brSon2}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-combobox wMasterDetail 
PROCEDURE pi-carrega-combobox :
/*------------------------------------------------------------------------------
  Purpose:     Carrega o Combo com as vers‰es
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/       
    IF NOT VALID-HANDLE (h-boaf010-3) THEN DO:
        RUN afbo/boaf010.p PERSISTEN SET h-boaf010-3.
    END.
    
    DEFINE VARIABLE c-versoes AS CHARACTER   NO-UNDO.

    RUN pi-retorna-versoes IN h-boaf010-3 (INPUT tt-af-controle.nr-controle, OUTPUT c-versoes).

    ASSIGN cb-versao:LIST-ITEM-PAIRS IN FRAME fpage0 = c-versoes.

    RUN openQueriesSon.
     
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-botoes wMasterDetail 
PROCEDURE pi-habilita-botoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF AVAIL tt-af-faixa-demerito1 THEN
        ENABLE btAddSon1 btUpdateSon1 btDeleteSon1 WITH FRAME fpage1.
    ELSE
        DISABLE btUpdateSon1 btDeleteSon1 WITH FRAME fpage1.
    
    IF AVAIL tt-af-faixa-demerito2 THEN
        ENABLE btAddSon2 btUpdateSon2 btDeleteSon2 WITH FRAME fpage2.
    ELSE
        DISABLE btUpdateSon2 btDeleteSon2 WITH FRAME fpage2.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-retorno wMasterDetail 
PROCEDURE pi-seta-retorno :
/*------------------------------------------------------------------------------
  Purpose:    Procedure para setar o n£mero e a descriá∆o da vers∆o 
              passados por parÉmetros
  Parameters: pnr-versao - N£mero da Vers∆o
              pdesc-versao - Descriá∆o da Vers∆o
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pnr-versao LIKE af-versao-avaliacao.nr-versao NO-UNDO.
DEFINE INPUT PARAMETER pdesc-versao LIKE af-versao-avaliacao.desc-versao.

    ASSIGN  inr-versao = pnr-versao
            cdesc-versao = pdesc-versao.    

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-versao wMasterDetail 
PROCEDURE pi-seta-versao :
/*------------------------------------------------------------------------------
  Purpose:    Procedure para retornar o n£mero e a descriá∆o da vers∆o 
              passados por parÉmetros
  Parameters: pnr-versao - N£mero da Vers∆o
              pdesc-versao - Descriá∆o da Vers∆o
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pnr-versao LIKE af-versao-avaliacao.nr-versao NO-UNDO.
DEFINE OUTPUT PARAMETER pdesc-versao LIKE af-versao-avaliacao.desc-versao NO-UNDO.

ASSIGN pnr-versao = DECIMAL(cb-versao:SCREEN-VALUE IN FRAME fpage0)
       pdesc-versao = ENTRY(LOOKUP(cb-versao:SCREEN-VALUE IN FRAME fpage0,cb-versao:LIST-ITEM-PAIRS) - 1,cb-versao:LIST-ITEM-PAIRS).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-versao-existente wMasterDetail 
PROCEDURE pi-valida-versao-existente :
/*------------------------------------------------------------------------------
  Purpose:    Procedure para verificar se j† a vers∆o selecionada no combo.
              Se j† existe emite a mensagem e n∆o deixa incluir, se n∆o existe 
              inclui a nova vers∆o no combo.
  Parameters: pnr-versao - N£mero da vers∆o
              pdesc-versao - Descriá∆o da vers∆o
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pnr-versao LIKE af-versao-avaliacao.nr-versao NO-UNDO.
DEFINE INPUT PARAMETER pdesc-versao LIKE af-versao-avaliacao.desc-versao NO-UNDO.

IF LOOKUP(STRING(pnr-versao), cb-versao:LIST-ITEM-PAIRS IN FRAME fpage0) > 0 THEN DO:    

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Vers∆o" *}
    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 1,
                       INPUT RETURN-VALUE).

END.
ELSE DO:
    
    ASSIGN  cb-versao:LIST-ITEM-PAIRS IN FRAME fpage0 = pdesc-versao + "," + STRING(pnr-versao) + "," + cb-versao:LIST-ITEM-PAIRS            
            cb-versao:SCREEN-VALUE IN FRAME fpage0 = ENTRY(2,cb-versao:LIST-ITEM-PAIRS).

    RUN openQueriesSon.

END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-versao-invalida wMasterDetail 
PROCEDURE pi-versao-invalida :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para verificar se a est† selecionada a opá∆o "Nova Vers∆o"
               Se estiver n∆o deixar incluir.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF cb-versao:SCREEN-VALUE IN FRAME fpage0 = "-1" OR
    cb-versao:SCREEN-VALUE IN FRAME fpage0 = ? THEN DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Vers∆o" *}
    RUN utp/ut-msgs.p (INPUT "show",
                   INPUT 44127,
                   INPUT RETURN-VALUE).
    RETURN "NOK":U.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

