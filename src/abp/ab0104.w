&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-consu-model NO-UNDO LIKE mab-consu-model
       field r-rowid as rowid.
DEFINE TEMP-TABLE TTmab-model NO-UNDO LIKE mab-model
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttmab-model-especialid NO-UNDO LIKE mab-model-especialid
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttmmv-tempo-padr NO-UNDO LIKE mmv-tempo-padr
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0104 2.00.00.006 } /*** "010006" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0104 MAB}
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
&GLOBAL-DEFINE Program          AB0104
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels    Consumo,Tempo Padr, Especialid

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        YES
&GLOBAL-DEFINE CopyParent       YES
&GLOBAL-DEFINE UpdateParent     YES
&GLOBAL-DEFINE DeleteParent     YES

&GLOBAL-DEFINE AddSon1          YES
&GLOBAL-DEFINE CopySon1         NO
&GLOBAL-DEFINE UpdateSon1       YES
&GLOBAL-DEFINE DeleteSon1       YES

&GLOBAL-DEFINE AddSon2          YES
&GLOBAL-DEFINE CopySon2         NO
&GLOBAL-DEFINE UpdateSon2       YES
&GLOBAL-DEFINE DeleteSon2       YES

&GLOBAL-DEFINE AddSon3          YES
&GLOBAL-DEFINE CopySon3         NO
&GLOBAL-DEFINE UpdateSon3       YES
&GLOBAL-DEFINE DeleteSon3       YES

&GLOBAL-DEFINE ttParent         TTmab-model
&GLOBAL-DEFINE hDBOParent       hDBOModelo
&GLOBAL-DEFINE DBOParentTable   mab-model
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           TTmab-consu-model
&GLOBAL-DEFINE hDBOSon1         hDBOConsuModel
&GLOBAL-DEFINE DBOSon1Table     mab-consu-model
&GLOBAL-DEFINE DBOSon1Destroy   YES
      
&GLOBAL-DEFINE ttSon2           ttmmv-tempo-padr
&GLOBAL-DEFINE hDBOSon2         hDBOTempoPadr
&GLOBAL-DEFINE DBOSon2Table     mmv-tempo-padr
&GLOBAL-DEFINE DBOSon2Destroy   YES

&GLOBAL-DEFINE ttSon3           ttmab-model-especialid
&GLOBAL-DEFINE hDBOSon3         hDBOEspecModel
&GLOBAL-DEFINE DBOSon3Table     mab-model-especialid
&GLOBAL-DEFINE DBOSon3Destroy   YES

&GLOBAL-DEFINE page0Fields      TTmab-model.cod-model TTmab-model.des-model ~
                                TTmab-model.cod-marca cDescMarca ~
                                TTmab-model.un cDescUnid TTmab-model.log-integr-agro ~
                                TTmab-model.log-cont-sec TTmab-model.idi-tip-model
                                 

&GLOBAL-DEFINE page1Browse      brSon1    
&GLOBAL-DEFINE page2Browse      brSon2    
&GLOBAL-DEFINE page3Browse      brSon3    
/* Parameters Definitions ---                                           */

DEFINE VARIABLE cDescAtiv    AS CHARACTER FORMAT "x(40)" NO-UNDO.
DEFINE VARIABLE cDescTpmatr  AS CHARACTER FORMAT "x(40)" NO-UNDO.
DEFINE VARIABLE cDescEvento  AS CHARACTER FORMAT "x(40)" NO-UNDO.
DEFINE VARIABLE cDescSubSist AS CHARACTER FORMAT "x(40)" NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon3}   AS HANDLE NO-UNDO.

DEFINE VARIABLE hDBOAtiv      AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOTpMat     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEvento    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOSubSist   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOMfoMarca  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOUnid      AS HANDLE NO-UNDO.

DEFINE VARIABLE c-tipo-espec    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-desc-espec    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-desc-evento   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-desc-sub-sist AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-tipo-tempo    AS CHARACTER NO-UNDO.

DEFINE VARIABLE c-cod-evento-ini      AS CHARACTER INITIAL ""         NO-UNDO.
DEFINE VARIABLE c-cod-evento-fim      AS CHARACTER INITIAL "ZZZZZZZZ" NO-UNDO.
DEFINE VARIABLE c-cod-sub-sistema-ini AS CHARACTER INITIAL ""         NO-UNDO.
DEFINE VARIABLE c-cod-sub-sistema-fim AS CHARACTER INITIAL "ZZZZZZZZ" NO-UNDO.
DEFINE VARIABLE c-tp-especial-ini     AS CHARACTER INITIAL ""         NO-UNDO.
DEFINE VARIABLE c-tp-especial-fim     AS CHARACTER INITIAL "ZZZZZZZZ" NO-UNDO.
DEFINE VARIABLE c-botao               AS CHARACTER NO-UNDO.

DEFINE BUFFER bf-mi-espec FOR mi-espec.

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
&Scoped-define INTERNAL-TABLES TTmab-consu-model ttmmv-tempo-padr ~
ttmab-model-especialid

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 TTmab-consu-model.cod-ativid ~
getDesAtivid (TTmab-consu-model.cod-ativid) @ cDescAtiv ~
TTmab-consu-model.cod-tip-mater ~
getTpMatr (TTmab-consu-model.cod-tip-mater) @ cDescTpmatr ~
TTmab-consu-model.val-consu-padr TTmab-consu-model.val-consu-sec 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH TTmab-consu-model NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH TTmab-consu-model NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 TTmab-consu-model
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 TTmab-consu-model


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 ttmmv-tempo-padr.cod-evento ~
getDescEvento (ttmmv-tempo-padr.cod-evento) @ cDescEvento ~
ttmmv-tempo-padr.cod-sub-sist ~
getDescSubSist  (ttmmv-tempo-padr.cod-sub-sist ) @ cDescSubSist ~
ttmmv-tempo-padr.val-tempo-padr 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH ttmmv-tempo-padr NO-LOCK
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH ttmmv-tempo-padr NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon2 ttmmv-tempo-padr
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 ttmmv-tempo-padr


/* Definitions for BROWSE brSon3                                        */
&Scoped-define FIELDS-IN-QUERY-brSon3 ttmab-model-especialid.cod-evento ~
fnDescEvento(ttmab-model-especialid.cod-evento) @ c-desc-evento ~
ttmab-model-especialid.cod-sub-sist ~
fnDescSubSist(ttmab-model-especialid.cod-sub-sist) @ c-desc-sub-sist ~
ttmab-model-especialid.tp-especial ~
fnDescEspec(ttmab-model-especialid.tp-especial) @ c-desc-espec ~
fnTipoEspec(ttmab-model-especialid.tipo-espec) @ c-tipo-espec ~
ttmab-model-especialid.tempo ~
fnTipoTempo(ttmab-model-especialid.tipo-tempo) @ c-tipo-tempo ~
ttmab-model-especialid.nr-homens ttmab-model-especialid.log-gera-espec-om 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon3 
&Scoped-define QUERY-STRING-brSon3 FOR EACH ttmab-model-especialid NO-LOCK ~
    BY ttmab-model-especialid.cod-evento ~
       BY ttmab-model-especialid.cod-sub-sist ~
        BY ttmab-model-especialid.tp-especial
&Scoped-define OPEN-QUERY-brSon3 OPEN QUERY brSon3 FOR EACH ttmab-model-especialid NO-LOCK ~
    BY ttmab-model-especialid.cod-evento ~
       BY ttmab-model-especialid.cod-sub-sist ~
        BY ttmab-model-especialid.tp-especial.
&Scoped-define TABLES-IN-QUERY-brSon3 ttmab-model-especialid
&Scoped-define FIRST-TABLE-IN-QUERY-brSon3 ttmab-model-especialid


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brSon3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS TTmab-model.cod-model TTmab-model.des-model ~
TTmab-model.cod-marca TTmab-model.un TTmab-model.log-integr-agro ~
TTmab-model.log-cont-sec TTmab-model.idi-tip-model 
&Scoped-define ENABLED-TABLES TTmab-model
&Scoped-define FIRST-ENABLED-TABLE TTmab-model
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar RECT-2 btFirst btPrev ~
btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btcopia ~
btQueryJoins btReportsJoins btExit btHelp cDescMarca cDescUnid cCodUnSec ~
cDescUnidSec 
&Scoped-Define DISPLAYED-FIELDS TTmab-model.cod-model TTmab-model.des-model ~
TTmab-model.cod-marca TTmab-model.un TTmab-model.log-integr-agro ~
TTmab-model.log-cont-sec TTmab-model.idi-tip-model 
&Scoped-define DISPLAYED-TABLES TTmab-model
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-model
&Scoped-Define DISPLAYED-OBJECTS cDescMarca cDescUnid cCodUnSec ~
cDescUnidSec 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescEspec wMasterDetail 
FUNCTION fnDescEspec RETURNS CHARACTER
    ( cTpEspecial AS CHARACTER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescEvento wMasterDetail 
FUNCTION fnDescEvento RETURNS CHARACTER
    ( cCodEvento AS CHARACTER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescSubSist wMasterDetail 
FUNCTION fnDescSubSist RETURNS CHARACTER
    ( cCodSubSist AS CHARACTER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTipoEspec wMasterDetail 
FUNCTION fnTipoEspec RETURNS CHARACTER
    ( input iTipoEspec as integer /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTipoTempo wMasterDetail 
FUNCTION fnTipoTempo RETURNS CHARACTER
    ( iTipoTempo  as INTEGER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCtrlLeitura wMasterDetail 
FUNCTION getCtrlLeitura RETURNS CHARACTER
  ( iParam as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDesAtivid wMasterDetail 
FUNCTION getDesAtivid RETURNS CHARACTER
  ( pCodAtiv as CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDescEvento wMasterDetail 
FUNCTION getDescEvento RETURNS CHARACTER
  ( pCodEvento AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDescItem wMasterDetail 
FUNCTION getDescItem RETURNS CHARACTER
  ( pCodAtiv as CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDescSubSist wMasterDetail 
FUNCTION getDescSubSist RETURNS CHARACTER
      ( pCodSubSistema AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTpMatr wMasterDetail 
FUNCTION getTpMatr RETURNS CHARACTER
  ( pCodMatr as CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "P&r¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
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
       MENU-ITEM miAvancada     LABEL "C¢pia Ava&náada" ACCELERATOR "CTRL-D"
       RULE
       MENU-ITEM miQueryJoins   LABEL "C&onsultas"    
       MENU-ITEM miReportsJoins LABEL "Rela&t¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "Aj&uda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btcopia 
     IMAGE-UP FILE "image/copy-au.bmp":U
     IMAGE-INSENSITIVE FILE "image/copy-ai.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "C¢pia Avanáada".

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image\im-copy":U
     IMAGE-INSENSITIVE FILE "image\ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image\im-era":U
     IMAGE-INSENSITIVE FILE "image\ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE cCodUnSec AS CHARACTER FORMAT "XX":U 
     LABEL "Unidade Secund†ria" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE cDescMarca AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE cDescUnid AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE cDescUnidSec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 1.58.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.08.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAddSon1 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon1 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon1 
     LABEL "A&lterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btAddSon2 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon2 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon2 
     LABEL "A&lterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btAddSon3 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon3 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btSelecao3 
     LABEL "&Seleá∆o" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon3 
     LABEL "A&lterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      TTmab-consu-model SCROLLING.

DEFINE QUERY brSon2 FOR 
      ttmmv-tempo-padr SCROLLING.

DEFINE QUERY brSon3 FOR 
      ttmab-model-especialid
    FIELDS(ttmab-model-especialid.cod-evento
      ttmab-model-especialid.cod-sub-sist
      ttmab-model-especialid.tp-especial
      ttmab-model-especialid.tipo-espec
      ttmab-model-especialid.tempo
      ttmab-model-especialid.tipo-tempo
      ttmab-model-especialid.nr-homens
      ttmab-model-especialid.log-gera-espec-om) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      TTmab-consu-model.cod-ativid FORMAT "x(8)":U WIDTH 10
      getDesAtivid (TTmab-consu-model.cod-ativid) @ cDescAtiv COLUMN-LABEL "Descriá∆o"
            WIDTH 30
      TTmab-consu-model.cod-tip-mater FORMAT "x(8)":U WIDTH 10
      getTpMatr (TTmab-consu-model.cod-tip-mater) @ cDescTpmatr COLUMN-LABEL "Descriá∆o"
            WIDTH 30
      TTmab-consu-model.val-consu-padr COLUMN-LABEL "Consumo" FORMAT ">>>,>>9.99":U
            WIDTH 12
      TTmab-consu-model.val-consu-sec FORMAT ">>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 6.25
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _STRUCTURED
  QUERY brSon2 NO-LOCK DISPLAY
      ttmmv-tempo-padr.cod-evento FORMAT "x(08)":U WIDTH 10
      getDescEvento (ttmmv-tempo-padr.cod-evento) @ cDescEvento COLUMN-LABEL "Descriá∆o"
            WIDTH 30
      ttmmv-tempo-padr.cod-sub-sist FORMAT "x(8)":U WIDTH 10
      getDescSubSist  (ttmmv-tempo-padr.cod-sub-sist ) @ cDescSubSist COLUMN-LABEL "Descriá∆o"
            WIDTH 30
      ttmmv-tempo-padr.val-tempo-padr FORMAT ">>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 6.25
         FONT 2.

DEFINE BROWSE brSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon3 wMasterDetail _STRUCTURED
  QUERY brSon3 NO-LOCK DISPLAY
      ttmab-model-especialid.cod-evento FORMAT "x(08)":U
      fnDescEvento(ttmab-model-especialid.cod-evento) @ c-desc-evento COLUMN-LABEL "Descriá∆o Evento" FORMAT "x(30)":U
            WIDTH 20
      ttmab-model-especialid.cod-sub-sist FORMAT "x(8)":U
      fnDescSubSist(ttmab-model-especialid.cod-sub-sist) @ c-desc-sub-sist COLUMN-LABEL "Descriá∆o Sub-Sistema" FORMAT "x(30)":U
            WIDTH 20
      ttmab-model-especialid.tp-especial FORMAT "x(8)":U
      fnDescEspec(ttmab-model-especialid.tp-especial) @ c-desc-espec COLUMN-LABEL "Descriá∆o Especialidade" FORMAT "x(40)":U
            WIDTH 30
      fnTipoEspec(ttmab-model-especialid.tipo-espec) @ c-tipo-espec COLUMN-LABEL "Tipo Especialidade" FORMAT "x(12)":U
      ttmab-model-especialid.tempo COLUMN-LABEL "Tempo" FORMAT "->>>>>,>>9.9999":U
            WIDTH 11
      fnTipoTempo(ttmab-model-especialid.tipo-tempo) @ c-tipo-tempo COLUMN-LABEL "Tipo Tempo" FORMAT "x(12)":U
            WIDTH 9.29
      ttmab-model-especialid.nr-homens FORMAT ">>9":U
      ttmab-model-especialid.log-gera-espec-om FORMAT "Sim/N∆o":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 6.25
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
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrància"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrància corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrància corrente"
     btcopia AT ROW 1.13 COL 47 HELP
          "C¢pia Avanáada"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     TTmab-model.cod-model AT ROW 2.83 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-model.des-model AT ROW 2.83 COL 31.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 40 BY .88
     TTmab-model.cod-marca AT ROW 3.83 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cDescMarca AT ROW 3.83 COL 31.57 COLON-ALIGNED NO-LABEL
     TTmab-model.un AT ROW 4.83 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     cDescUnid AT ROW 4.83 COL 26.57 COLON-ALIGNED NO-LABEL
     TTmab-model.log-integr-agro AT ROW 4.83 COL 50.43
          VIEW-AS TOGGLE-BOX
          SIZE 26.72 BY .71
     TTmab-model.log-cont-sec AT ROW 5.79 COL 23
          LABEL "Utiliza Contador Secund†rio":L30
          VIEW-AS TOGGLE-BOX
          SIZE 23 BY .71
     TTmab-model.idi-tip-model AT ROW 6.46 COL 56.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Equipamento", 1,
"Componente", 2
          SIZE 31 BY .71
     cCodUnSec AT ROW 6.58 COL 21 COLON-ALIGNED
     cDescUnidSec AT ROW 6.58 COL 26.57 COLON-ALIGNED NO-LABEL
     "Tipo Modelo" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 5.75 COL 51.72
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
     RECT-2 AT ROW 5.92 COL 50.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage3
     brSon3 AT ROW 1.25 COL 2
     btAddSon3 AT ROW 7.54 COL 2
     btUpdateSon3 AT ROW 7.54 COL 12
     btDeleteSon3 AT ROW 7.54 COL 22
     btSelecao3 AT ROW 7.54 COL 32 WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 9.25
         SIZE 84.43 BY 7.75
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.25 COL 2
     btAddSon1 AT ROW 7.54 COL 2
     btUpdateSon1 AT ROW 7.54 COL 12
     btDeleteSon1 AT ROW 7.54 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 9.25
         SIZE 84.43 BY 7.75
         FONT 1.

DEFINE FRAME fPage2
     brSon2 AT ROW 1.25 COL 2
     btAddSon2 AT ROW 7.54 COL 2
     btUpdateSon2 AT ROW 7.54 COL 12
     btDeleteSon2 AT ROW 7.54 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 9.25
         SIZE 84.43 BY 7.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: TTmab-consu-model T "?" NO-UNDO mgfro mab-consu-model
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: TTmab-model T "?" NO-UNDO mgfro mab-model
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttmab-model-especialid T "?" NO-UNDO mgfro mab-model-especialid
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttmmv-tempo-padr T "?" NO-UNDO mgfro mmv-tempo-padr
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
         TITLE              = "Manutená∆o de Modelos de Equipamentos"
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
       FRAME fPage2:FRAME = FRAME fPage0:HANDLE
       FRAME fPage3:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR TOGGLE-BOX TTmab-model.log-cont-sec IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
ASSIGN 
       brSon1:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       brSon1:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
ASSIGN 
       brSon2:COLUMN-RESIZABLE IN FRAME fPage2       = TRUE
       brSon2:COLUMN-MOVABLE IN FRAME fPage2         = TRUE.

/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brSon3 1 fPage3 */
ASSIGN 
       brSon3:COLUMN-RESIZABLE IN FRAME fPage3       = TRUE
       brSon3:COLUMN-MOVABLE IN FRAME fPage3         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.TTmab-consu-model"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.TTmab-consu-model.cod-ativid
"TTmab-consu-model.cod-ativid" ? ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"getDesAtivid (TTmab-consu-model.cod-ativid) @ cDescAtiv" "Descriá∆o" ? ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.TTmab-consu-model.cod-tip-mater
"TTmab-consu-model.cod-tip-mater" ? ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"getTpMatr (TTmab-consu-model.cod-tip-mater) @ cDescTpmatr" "Descriá∆o" ? ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.TTmab-consu-model.val-consu-padr
"TTmab-consu-model.val-consu-padr" "Consumo" ? "decimal" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.TTmab-consu-model.val-consu-sec
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.ttmmv-tempo-padr"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.ttmmv-tempo-padr.cod-evento
"ttmmv-tempo-padr.cod-evento" ? ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"getDescEvento (ttmmv-tempo-padr.cod-evento) @ cDescEvento" "Descriá∆o" ? ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ttmmv-tempo-padr.cod-sub-sist
"ttmmv-tempo-padr.cod-sub-sist" ? ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"getDescSubSist  (ttmmv-tempo-padr.cod-sub-sist ) @ cDescSubSist" "Descriá∆o" ? ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.ttmmv-tempo-padr.val-tempo-padr
     _Query            is OPENED
*/  /* BROWSE brSon2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon3
/* Query rebuild information for BROWSE brSon3
     _TblList          = "Temp-Tables.ttmab-model-especialid"
     _Options          = "NO-LOCK"
     _TblOptList       = "USED"
     _OrdList          = "Temp-Tables.ttmab-model-especialid.cod-evento|yes,Temp-Tables.ttmab-model-especialid.cod-sub-sist|yes,Temp-Tables.ttmab-model-especialid.tp-especial|yes"
     _FldNameList[1]   = Temp-Tables.ttmab-model-especialid.cod-evento
     _FldNameList[2]   > "_<CALC>"
"fnDescEvento(ttmab-model-especialid.cod-evento) @ c-desc-evento" "Descriá∆o Evento" "x(30)" ? ? ? ? ? ? ? no "Descriá∆o Evento" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.ttmab-model-especialid.cod-sub-sist
     _FldNameList[4]   > "_<CALC>"
"fnDescSubSist(ttmab-model-especialid.cod-sub-sist) @ c-desc-sub-sist" "Descriá∆o Sub-Sistema" "x(30)" ? ? ? ? ? ? ? no "Descriá∆o Sub-Sistema" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.ttmab-model-especialid.tp-especial
     _FldNameList[6]   > "_<CALC>"
"fnDescEspec(ttmab-model-especialid.tp-especial) @ c-desc-espec" "Descriá∆o Especialidade" "x(40)" ? ? ? ? ? ? ? no "Descriá∆o Especialidade" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fnTipoEspec(ttmab-model-especialid.tipo-espec) @ c-tipo-espec" "Tipo Especialidade" "x(12)" ? ? ? ? ? ? ? no "Tipo de Especialidade para o c†lculo" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttmab-model-especialid.tempo
"tempo" "Tempo" ? "decimal" ? ? ? ? ? ? no ? no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"fnTipoTempo(ttmab-model-especialid.tipo-tempo) @ c-tipo-tempo" "Tipo Tempo" "x(12)" ? ? ? ? ? ? ? no "Tipo de Tempo da Especialidade" no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   = Temp-Tables.ttmab-model-especialid.nr-homens
     _FldNameList[11]   = Temp-Tables.ttmab-model-especialid.log-gera-espec-om
     _Query            is OPENED
*/  /* BROWSE brSon3 */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail /* Manutená∆o de Modelos de Equipamentos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail /* Manutená∆o de Modelos de Equipamentos */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMasterDetail
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd IN MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE (INPUT "abp/ab0104a.w":U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="abp/ab0104b.w"
                           &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btAddSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon2 wMasterDetail
ON CHOOSE OF btAddSon2 IN FRAME fPage2 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="abp/ab0104d.w"
                           &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btAddSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon3 wMasterDetail
ON CHOOSE OF btAddSon3 IN FRAME fPage3 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="abp/ab0104f.w"
                           &PageNumber="3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btcopia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btcopia wMasterDetail
ON CHOOSE OF btcopia IN FRAME fPage0
OR CHOOSE OF MENU-ITEM miAvancada IN MENU mbMain DO:
  RUN piCopiaTempo IN THIS-PROCEDURE.
  apply "ENTRY":U to btcopia in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMasterDetail
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord (INPUT "abp/ab0104a.w":U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMasterDetail
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMasterDetail
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDeleteSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon2 wMasterDetail
ON CHOOSE OF btDeleteSon2 IN FRAME fPage2 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="2"}

    run repositionRecordSon in this-procedure (input ?, input 3).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btDeleteSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon3 wMasterDetail
ON CHOOSE OF btDeleteSon3 IN FRAME fPage3 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="3"}
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
    {method/zoomreposition.i &ProgramZoom="frzoom\z01fr016.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btSelecao3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelecao3 wMasterDetail
ON CHOOSE OF btSelecao3 IN FRAME fPage3 /* Seleá∆o */
DO:
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

    ASSIGN c-botao = "".

    RUN abp/ab0104g.w (INPUT-OUTPUT c-cod-evento-ini,
                       INPUT-OUTPUT c-cod-evento-fim,
                       INPUT-OUTPUT c-cod-sub-sistema-ini,
                       INPUT-OUTPUT c-cod-sub-sistema-fim,
                       INPUT-OUTPUT c-tp-especial-ini,
                       INPUT-OUTPUT c-tp-especial-fim,
                       INPUT-OUTPUT c-botao).

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    IF  c-botao = "OK":U THEN DO:
        RUN openQueriesSon IN THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMasterDetail
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE (INPUT "abp/ab0104a.w":U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="abp/ab0104b.w"
                              &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btUpdateSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon2 wMasterDetail
ON CHOOSE OF btUpdateSon2 IN FRAME fPage2 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="abp/ab0104d.w"
                              &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btUpdateSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon3 wMasterDetail
ON CHOOSE OF btUpdateSon3 IN FRAME fPage3 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="abp/ab0104f.w"
                              &PageNumber="3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME cCodUnSec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cCodUnSec wMasterDetail
ON LEAVE OF cCodUnSec IN FRAME fPage0 /* Unidade Secund†ria */
DO:
    {method\referenceFields.i
           &HandleDBOLeave="hDBOUnid"
           &KeyValue1="cCodUnSec:screen-value in frame fPage0"
           &FieldName1="descricao"
           &FieldScreen1="cDescUnidSec"
           &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-model.cod-marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-model.cod-marca wMasterDetail
ON LEAVE OF TTmab-model.cod-marca IN FRAME fPage0 /* Marca */
DO:
  {method/ReferenceFields.i
        &HandleDBOLeave="hDBOMfoMarca"
        &KeyValue1="TTmab-model.cod-marca:SCREEN-VALUE IN FRAME fpage0"
        &FieldName1="nom-marca"
        &FieldScreen1="cDescMarca"
        &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-model.un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-model.un wMasterDetail
ON LEAVE OF TTmab-model.un IN FRAME fPage0 /* Unidade */
DO:
    {method\referenceFields.i
           &HandleDBOLeave="hDBOUnid"
           &KeyValue1="TTmab-model.un:screen-value in frame fPage0"
           &FieldName1="descricao"
           &FieldScreen1="cDescUnid"
           &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{masterdetail/mainblock.i}

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

IF VALID-HANDLE (hDBOAtiv) THEN
       RUN destroy IN hDBOAtiv.


IF VALID-HANDLE (hDBOTpMat) THEN
       RUN destroy IN hDBOTpMat.


IF VALID-HANDLE (hDBOEvento) THEN
       RUN destroy IN hDBOEvento.

IF VALID-HANDLE (hDBOSubSist) THEN
       RUN destroy IN hDBOsubSist.


IF VALID-HANDLE (hDBOTempoPadr) THEN
       RUN destroy IN hDBOTempoPadr.


IF VALID-HANDLE (hDBOMfoMarca) THEN   
       RUN destroy IN hDBOMfoMarca.


IF VALID-HANDLE (hDBOUnid) THEN   
       RUN destroy IN hDBOUnid.


IF VALID-HANDLE (hDBOEspecModel) THEN   
       RUN destroy IN hDBOEspecModel.

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
     IF  CAN-FIND (FIRST TTmab-model
                   WHERE TTmab-model.idi-tip-model <> 1 ) THEN DO:
         ASSIGN btAddSon1:SENSITIVE IN FRAME fPage1 = NO
                btUpdateSon1:SENSITIVE IN FRAME fPage1 = NO
                btDeleteSon1:SENSITIVE IN FRAME fPage1 = NO.
     END.
     IF  TTmab-model.cod-model:SCREEN-VALUE IN FRAME fPage0 <> "" THEN DO:
         ASSIGN btAddSon1:SENSITIVE IN FRAME fPage1 = YES.
     END.
     ELSE DO:
         ASSIGN btAddSon1:SENSITIVE IN FRAME fPage1 = NO.
     END.

     IF  AVAIL ttmab-model-especialid THEN
         ASSIGN btSelecao3:SENSITIVE   IN FRAME fPage3 = YES.
     ELSE
         ASSIGN btSelecao3:SENSITIVE   IN FRAME fPage3 = NO.

     ASSIGN btcopia:SENSITIVE IN FRAME fPage0 = YES.

     FIND FIRST param-global NO-LOCK NO-ERROR.
     &IF  DEFINED (bf_man_206) &THEN
          IF  param-global.ind-int-agro = YES THEN
              ASSIGN TTmab-model.log-integr-agro:SENSITIVE IN FRAME fPage0 = NO
                     TTmab-model.log-integr-agro:HIDDEN    IN FRAME fPage0 = NO.
          ELSE
              ASSIGN TTmab-model.log-integr-agro:SENSITIVE IN FRAME fPage0 = NO
                     TTmab-model.log-integr-agro:HIDDEN    IN FRAME fPage0 = YES.
     &ELSE
          IF  SUBSTRING(param-global.char-2,21,1) = "1":U THEN
              ASSIGN TTmab-model.log-integr-agro:SENSITIVE IN FRAME fPage0 = NO
                     TTmab-model.log-integr-agro:HIDDEN    IN FRAME fPage0 = NO.
          ELSE
              ASSIGN TTmab-model.log-integr-agro:SENSITIVE IN FRAME fPage0 = NO
                     TTmab-model.log-integr-agro:HIDDEN    IN FRAME fPage0 = YES.
     &ENDIF
     
     APPLY "LEAVE":U TO TTmab-model.cod-marca.
     APPLY "LEAVE":U TO TTmab-model.un.
     APPLY "LEAVE":U TO cCodUnSec.
     IF  AVAIL TTmab-model AND SUBSTRING(TTmab-model.cod-livre-1, 1, 2) <> "" THEN DO:
         ASSIGN cCodUnSec:SCREEN-VALUE IN FRAME fPage0 = SUBSTRING(TTmab-model.cod-livre-1, 1, 2).
         APPLY "LEAVE":U         TO cCodUnSec               IN FRAME fPage0.
     END.
     ELSE
         ASSIGN cCodUnSec:SCREEN-VALUE    IN FRAME fPage0 = ""
                cDescUnidSec:SCREEN-VALUE IN FRAME fPage0 = "".

     /* Inicializa as variaveis utilizadas na pesquisa de especialidades da pagina 3. */
     ASSIGN c-cod-evento-ini      = ""
            c-cod-evento-fim      = "ZZZZZZZZ"
            c-cod-sub-sistema-ini = ""
            c-cod-sub-sistema-fim = "ZZZZZZZZ"
            c-tp-especial-ini     = ""
            c-tp-especial-fim     = "ZZZZZZZZ".
     
     RETURN "OK":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMasterDetail 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF TTmab-model.cod-model:SCREEN-VALUE IN FRAME fPage0 <> "" THEN DO:
    ASSIGN btAddSon1:SENSITIVE IN FRAME fPage1 = YES.
END.
ELSE DO:
    ASSIGN btAddSon1:SENSITIVE IN FRAME fPage1 = NO.
END.

    
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override ap¢s iniciar o programa 
------------------------------------------------------------------------------*/
{utp/ut-liter.i "Descriá∆o"}
assign cDescEvento:label in browse brSon2  = trim(return-value)
       cDescSubSist:label in browse brSon2 = trim(return-value)
       cDescAtiv:label in browse brSon1    = trim(return-value)
       cDescTpmatr:label in browse brSon1  = trim(return-value).

return "OK":U.

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
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

    DEFINE VARIABLE  cCodModelo LIKE  {&ttParent}.cod-model
           VIEW-AS FILL-IN SIZE 14.00 BY 0.88 NO-UNDO.

    
    DEFINE FRAME fGoToRecord
        cCodModelo         AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Modelo" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Modelo"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cCodModelo .
        
        /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT cCodModelo ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Modelo" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cCodModelo  btGoToOK  btGoToCancel 
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
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "frbo/bofr016.p":U THEN DO:
        RUN  frbo/bofr016.p PERSISTENT SET  {&hDBOParent}.
    END.
 
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.

    
      /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "frbo/bofr006.p":U THEN DO:
        RUN frbo/bofr006.p PERSISTENT SET {&hDBOSon1}.
    END.
    RUN openQueryStatic IN {&hDBOSon1} (INPUT "Main":U) NO-ERROR.

      /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE(hDBOAtiv) OR
       hDBOAtiv:TYPE <> "PROCEDURE":U OR
       hDBOAtiv:FILE-NAME <> "frbo/bofr001.p":U THEN DO:
        RUN frbo/bofr001.p PERSISTENT SET hDBOAtiv.
    END.
    RUN openQueryStatic IN hDBOAtiv (INPUT "Main":U) NO-ERROR.

   /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE(hDBOTpMat) OR
       hDBOTpMat:TYPE <> "PROCEDURE":U OR
       hDBOTpMat:FILE-NAME <> "frbo/bofr026.p":U THEN DO:
        RUN frbo/bofr026.p PERSISTENT SET hDBOTpMat.
    END.
    RUN openQueryStatic IN hDBOTpMat (INPUT "Main":U) NO-ERROR.

    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE(hDBOEvento) OR
       hDBOEvento:TYPE <> "PROCEDURE":U OR
       hDBOEvento:FILE-NAME <> "frbo/bofr010.p":U THEN DO:
        RUN frbo/bofr010.p PERSISTENT SET hDBOEvento.
    END.
    RUN openQueryStatic IN hDBOEvento (INPUT "Main":U) NO-ERROR.

    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE(hDBOSubSist) OR
       hDBOSubSist:TYPE <> "PROCEDURE":U OR
       hDBOSubSist:FILE-NAME <> "frbo/bofr025.p":U THEN DO:
        RUN frbo/bofr025.p PERSISTENT SET hDBOSubSist.
    END.
    RUN openQueryStatic IN hDBOSubSist (INPUT "Main":U) NO-ERROR.

    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon2}) OR
       {&hDBOSon2}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon2}:FILE-NAME <> "frbo/bofr078.p":U THEN DO:
        RUN frbo/bofr078.p PERSISTENT SET {&hDBOSon2}.
    END.
    RUN openQueryStatic IN {&hDBOSon2} (INPUT "Main":U) NO-ERROR.
  
    IF  NOT VALID-HANDLE(hDBOMfoMarca) OR
        hDBOMfoMarca:TYPE <> "PROCEDURE":U OR
        hDBOMfoMarca:FILE-NAME <> "frbo/bofr015.p":U THEN DO:
        RUN frbo/bofr015.p PERSISTENT SET  hDBOMfoMarca.
    END.
    RUN openQueryStatic IN hDBOMfoMarca (INPUT "Main":U) NO-ERROR.
    
    IF  NOT VALID-HANDLE(hDBOUnid) OR
        hDBOUnid:TYPE <> "PROCEDURE":U OR
        hDBOUnid:FILE-NAME <> "inbo/boin417.p":U THEN DO:
        RUN inbo/boin417.p PERSISTENT SET  hDBOUnid.
    END.
    RUN openQueryStatic IN hDBOUnid (INPUT "Main":U) NO-ERROR.

    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon3}) OR
       {&hDBOSon3}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon3}:FILE-NAME <> "frbo/bofr00155.p":U THEN DO:
        RUN frbo/bofr00155.p PERSISTENT SET {&hDBOSon3}.
    END.
    RUN openQueryStatic IN {&hDBOSon3} (INPUT "Main":U) NO-ERROR.

    
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

    {masterdetail/openqueriesson.i &Parent="Mfo-Modelo"
                                   &Query="Mfo-Modelo"
                                   &PageNumber="1"}
    
    {masterdetail/openqueriesson.i &Parent="Modelo"
                                   &Query="Modelo"
                                   &PageNumber="2"}
                                   
    RUN setConstraintSelecao IN {&hDBOSon3} (INPUT c-cod-evento-ini,
                                             INPUT c-cod-evento-fim,
                                             INPUT c-cod-sub-sistema-ini,
                                             INPUT c-cod-sub-sistema-fim,
                                             INPUT c-tp-especial-ini,
                                             INPUT c-tp-especial-fim).

    {masterdetail/openqueriesson.i &Parent="EspecEvento"
                                   &Query="EspecEvento"
                                   &PageNumber="3"}
                                   

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCopiaTempo wMasterDetail 
PROCEDURE piCopiaTempo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define variable hModel     as handle    no-undo.
define variable ccodModel  as character no-undo.
       
for first mab-model
    where mab-model.cod-model = INPUT FRAME Fpage0 TTmab-model.cod-model no-lock:
    
    assign ccodModel = mab-model.cod-model.
                   
    if ccodModel  = ""  then return "NOK":U.
    
    /*--- Seta cursor do mouse para espera ---*/
    SESSION:SET-WAIT-STATE("GENERAL":U).
    assign {&window-name}:sensitive = no.
    
    /*--- Executa programa de inclus∆o de filho ---*/
    Run abp/ab0104e.w PERSISTENT SET hModel.
     
    IF VALID-HANDLE(hModel)
    AND hModel:Type = "PROCEDURE":U 
    AND hModel:FILE-NAME = "abp/ab0104e.w":U THEN
         /*--- Inicializa programa de inclus∆o de filho ---*/
        Run initializeInterface IN hModel.
    
    run setaModelo in hModel (input ROWID(mab-model)).
     
    /*--- Seta cursor do mouse para normal ---*/
    SESSION:SET-WAIT-STATE("":U).
    wait-for "CLOSE":U of hModel.
    assign {&window-name}:sensitive = yes.
     
    if valid-handle(hModel) then
        delete procedure hModel.
    
      
END.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInformaEventoSelecionado wMasterDetail 
PROCEDURE piInformaEventoSelecionado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE OUTPUT PARAMETER pCodEvento     LIKE ttmmv-tempo-padr.cod-evento     NO-UNDO.
   DEFINE OUTPUT PARAMETER pSubSist       LIKE ttmmv-tempo-padr.cod-sub-sist   NO-UNDO.
   DEFINE OUTPUT PARAMETER pTempoPadrao   LIKE ttmmv-tempo-padr.val-tempo-padr NO-UNDO.

   IF (NUM-RESULTS ("brSon2":U) > 0) THEN
       ASSIGN pCodEvento   = ttmmv-tempo-padr.cod-evento:SCREEN-VALUE IN BROWSE brSon2
              pSubSist     = ttmmv-tempo-padr.cod-sub-sist:SCREEN-VALUE IN BROWSE brSon2
              pTempoPadrao = dec(ttmmv-tempo-padr.val-tempo-padr:SCREEN-VALUE IN BROWSE brSon2).
   ELSE
       RETURN "NOK":U.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescEspec wMasterDetail 
FUNCTION fnDescEspec RETURNS CHARACTER
    ( cTpEspecial AS CHARACTER /* parameter-definitions */ ) :
  /*------------------------------------------------------------------------------
    Purpose:  
      Notes:  
  ------------------------------------------------------------------------------*/
    FIND FIRST bf-mi-espec
         WHERE bf-mi-espec.tp-especial = cTpEspecial NO-LOCK NO-ERROR.
    IF  AVAIL bf-mi-espec THEN
        RETURN bf-mi-espec.descricao.
    ELSE RETURN "".
      
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescEvento wMasterDetail 
FUNCTION fnDescEvento RETURNS CHARACTER
    ( cCodEvento AS CHARACTER /* parameter-definitions */ ) :
  /*------------------------------------------------------------------------------
    Purpose:  
      Notes:  
  ------------------------------------------------------------------------------*/
    FIND FIRST mab-event
         WHERE mab-event.cod-evento = cCodEvento NO-LOCK NO-ERROR.
    IF  AVAIL mab-event THEN
        RETURN mab-event.des-evento.
    ELSE RETURN "".
      
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescSubSist wMasterDetail 
FUNCTION fnDescSubSist RETURNS CHARACTER
    ( cCodSubSist AS CHARACTER /* parameter-definitions */ ) :
  /*------------------------------------------------------------------------------
    Purpose:  
      Notes:  
  ------------------------------------------------------------------------------*/
    FIND FIRST mab-sub-sist
         WHERE mab-sub-sist.cod-sub-sist = cCodSubSist NO-LOCK NO-ERROR.
    IF  AVAIL mab-sub-sist THEN
        RETURN mab-sub-sist.des-sub-sist.
    ELSE RETURN "".
      
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTipoEspec wMasterDetail 
FUNCTION fnTipoEspec RETURNS CHARACTER
    ( input iTipoEspec as integer /* parameter-definitions */ ) :
  /*------------------------------------------------------------------------------
    Purpose:  
      Notes:  
  ------------------------------------------------------------------------------*/
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        RUN utp/ut-liter.p (trim({ininc/i01in421.i 04 iTipoEspec}), "*", ""). 
        RETURN RETURN-VALUE.   /* Function return value. */                   
      &else
        RETURN {ininc/i01in421.i 04 iTipoEspec}.   /* Function return value. */
      &ENDIF
      
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTipoTempo wMasterDetail 
FUNCTION fnTipoTempo RETURNS CHARACTER
    ( iTipoTempo  as INTEGER /* parameter-definitions */ ) :
  /*------------------------------------------------------------------------------
    Purpose:  
      Notes:  
  ------------------------------------------------------------------------------*/
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        RUN utp/ut-liter.p (trim({ininc/i02in421.i 4 iTipoTempo}), "*", ""). 
        RETURN RETURN-VALUE.                                                 
      &else
        RETURN {ininc/i02in421.i 4 iTipoTempo}.   /* Function return value. */
      &ENDIF
      
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCtrlLeitura wMasterDetail 
FUNCTION getCtrlLeitura RETURNS CHARACTER
  ( iParam as int ) :
    
    case iParam:
        when 1 then
            return "N∆o".
        when 2 then
            return "Sim".
        
    end case.
  RETURN "OK":U.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDesAtivid wMasterDetail 
FUNCTION getDesAtivid RETURNS CHARACTER
  ( pCodAtiv as CHAR) :
    
    def var cDesc as char FORMAT "x(40)" no-undo.

    run goToKey in hDBOAtiv     (input pCodAtiv).
    run getCharField in hDBOAtiv (input "des-ativid":u,
                                  output cDesc).
  RETURN cDesc.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDescEvento wMasterDetail 
FUNCTION getDescEvento RETURNS CHARACTER
  ( pCodEvento AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDesc AS CHARACTER FORMAT "x(30)" NO-UNDO.

  run goToKey in hDBOEvento      (input pCodEvento).
  run getCharField in hDBOEvento (input "des-evento":u,
                                  output cDesc).

  RETURN cDesc.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDescItem wMasterDetail 
FUNCTION getDescItem RETURNS CHARACTER
  ( pCodAtiv as CHAR) :
    
    def var cDesc as char FORMAT "x(40)" no-undo.

    run goToKey in hDBOAtiv     (input pCodAtiv).
    run getCharField in hDBOAtiv (input "des-ativid":u,
                                  output cDesc).
  RETURN cDesc.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDescSubSist wMasterDetail 
FUNCTION getDescSubSist RETURNS CHARACTER
      ( pCodSubSistema AS CHAR ) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/
      DEFINE VARIABLE cDesc AS CHARACTER FORMAT "x(30)" NO-UNDO.

      run goToKey in hDBOSubSist  (input pCodSubSistema).
      run getCharField in hDBOSubSist (input "des-sub-sist":u,
                                          output cDesc).

      RETURN cDesc.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTpMatr wMasterDetail 
FUNCTION getTpMatr RETURNS CHARACTER
  ( pCodMatr as CHAR) :
    
    def var cDesc as char no-undo.

    run goToKey in hDBOTpMat     (input pCodMatr).
    run getCharField in hDBOTpMat (input "des-tip-mater":u,
                                   output cDesc).
  RETURN cDesc.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

