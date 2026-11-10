&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movfro           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttAbast NO-UNDO LIKE mab-item-abastec
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttApont NO-UNDO LIKE mab-abastec-lubrific
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttApontAux NO-UNDO LIKE mab-abastec-lubrific
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0402 2.00.00.015 } /*** "010015" 11/01/2024 14:12:13  ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0402 MAB}
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
&GLOBAL-DEFINE Program        AB0402
&GLOBAL-DEFINE Version        2.00.00.015

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         no
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btFiltro btHistorico btModifica btPadrao btUsuario ~
                              brApont brItem

/* Local Variable Definitions --- */
define variable cDescErro       as character format 'x(50)'              no-undo.
define variable iRow            as integer                               no-undo.
define variable deParam14       as decimal                               no-undo.
define variable iTpConsumo      as integer                               no-undo.
define variable iTpConsumoSec   as integer                               no-undo.
define variable c-cod-livre-1   LIKE mab-model.cod-livre-1               no-undo.
define variable lUsaContadorSec LIKE mab-model.log-cont-sec              no-undo.
DEFINE VARIABLE iUsoReal        AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE iUsoRealSec     AS DECIMAL                               NO-UNDO.
/** Filtro **/                                                           
define variable dtDataIni as   date                                      no-undo.
define variable dtDataFim as   date                                      no-undo.
define variable iEmpIni   like mab-eqpto.ep-codigo                       no-undo.
define variable iEmpFim   like mab-eqpto.ep-codigo                       no-undo.
define variable cEqptoIni like mab-eqpto.cod-eqpto                       no-undo.
define variable cEqptoFim like mab-eqpto.cod-eqpto                       no-undo.
define variable cEstabIni like mab-histor-ativid.cod-estab               no-undo.
define variable cEstabFim like mab-histor-ativid.cod-estab               no-undo.
define variable cTagIni   like mab-histor-ativid.cd-tag                  no-undo.
define variable cTagFim   like mab-histor-ativid.cd-tag                  no-undo.
define variable cCCIni    like mab-histor-ativid.cc-codigo               no-undo.
define variable cCCFim    like mab-histor-ativid.cc-codigo               no-undo.
&IF DEFINED(bf_mnt_ems206b) &THEN
define variable cUnidNegocIni like mab-histor-ativid.cod-unid-negoc no-undo.
define variable cUnidNegocFim like mab-histor-ativid.cod-unid-negoc no-undo.
&ENDIF
define variable lOK       as   logical                                   no-undo.
/** Modifica **/                                                         
define variable deHodometro    like ttApont.val-hodom-horim              no-undo.
define variable deHodometroSec like ttApont.val-hodom-horim-sec          no-undo.
define variable dtMovimento    like ttApont.dat-movto                    no-undo.
define variable hrHorario      like ttApont.hra-inicial                  no-undo.
define variable tpAtividade    like ttApont.cod-ativid                   no-undo.
define variable c-cod-empresa  like empresa.ep-codigo                    no-undo.

/*Variaveis para atualiza‡Æo durablilidade/apontamento pneus*/
define variable cCodEqpto         like mab-abastec-lubrific.cod-eqpto    no-undo.
define variable cEmpCod           like mab-abastec-lubrific.ep-codigo    no-undo.
define variable DtDatMovto        like mab-abastec-lubrific.dat-movto    no-undo.
define variable c-valor-param53   like mab-param.des-valor               no-undo.
                                                                        
                                                                        
/* Variable Handles Definitions ---                                     */
DEFINE VARIABLE hDBOApont     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOAbast     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEqpto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOAtiv      AS HANDLE NO-UNDO.
DEFINE VARIABLE hAbapi002     AS HANDLE NO-UNDO.

/** Buffer **/
define buffer bfApont      for mab-abastec-lubrific.

/** Temp-Tables da API **/
{abp/abapi001.i}

/*Temp table para atualiza‡Æo durabilidade/apontamento peneus*/
define temp-table tt-param-pnp NO-UNDO LIKE tt-param.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brApont

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttApont ttAbast

/* Definitions for BROWSE brApont                                       */
&Scoped-define FIELDS-IN-QUERY-brApont ~
fnRetornaEmpresa (ttApont.ep-codigo) @ c-cod-empresa ttApont.cod-eqpto ~
ttApont.dat-movto ttApont.hra-inicial ttApont.num-docto ~
fnDescErro(ttApont.idi-consist) @ cDescErro 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brApont 
&Scoped-define QUERY-STRING-brApont FOR EACH ttApont NO-LOCK ~
    BY ttApont.ep-codigo ~
       BY ttApont.cod-eqpto
&Scoped-define OPEN-QUERY-brApont OPEN QUERY brApont FOR EACH ttApont NO-LOCK ~
    BY ttApont.ep-codigo ~
       BY ttApont.cod-eqpto.
&Scoped-define TABLES-IN-QUERY-brApont ttApont
&Scoped-define FIRST-TABLE-IN-QUERY-brApont ttApont


/* Definitions for BROWSE brItem                                        */
&Scoped-define FIELDS-IN-QUERY-brItem ttAbast.it-codigo ttAbast.val-quant 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brItem 
&Scoped-define QUERY-STRING-brItem FOR EACH ttAbast NO-LOCK ~
    BY ttAbast.it-codigo
&Scoped-define OPEN-QUERY-brItem OPEN QUERY brItem FOR EACH ttAbast NO-LOCK ~
    BY ttAbast.it-codigo.
&Scoped-define TABLES-IN-QUERY-brItem ttAbast
&Scoped-define FIRST-TABLE-IN-QUERY-brItem ttAbast


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brApont}~
    ~{&OPEN-QUERY-brItem}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttApont.cod-ativid 
&Scoped-define ENABLED-TABLES ttApont
&Scoped-define FIRST-ENABLED-TABLE ttApont
&Scoped-Define ENABLED-OBJECTS RECT-16 RECT-17 rtToolBar-2 btModifica ~
btFiltro btHistorico btPadrao btUsuario btQueryJoins btReportsJoins btExit ~
btHelp brApont fiModelo fiDescModelo brItem fiDescAtiv fiReal fiHodEqpto ~
fiUN1 fiMaximo fiHodSecEqpto fiUNSec fiMinimo fiAbastec fiPadEqpto ~
fiPercurso fiUN2 fiDocAnterior fiPadMod btApontamento fiDatDocAnt 
&Scoped-Define DISPLAYED-FIELDS ttApont.cod-ativid 
&Scoped-define DISPLAYED-TABLES ttApont
&Scoped-define FIRST-DISPLAYED-TABLE ttApont
&Scoped-Define DISPLAYED-OBJECTS fiModelo fiDescModelo fiDescAtiv fiReal ~
fiHodEqpto fiUN1 fiMaximo fiHodSecEqpto fiUNSec fiMinimo fiAbastec ~
fiPadEqpto fiPercurso fiUN2 fiDocAnterior fiPadMod fiDatDocAnt 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescErro wWindow 
FUNCTION fnDescErro RETURNS CHARACTER
  ( input iStatus as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRetornaEmpresa wWindow 
FUNCTION fnRetornaEmpresa RETURNS CHARACTER
  (pEmp &IF "{&mguni_version}" >= "2.071" &THEN AS CHARACTER &ELSE AS INT &ENDIF /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miModifica     LABEL "&Modificar"     ACCELERATOR "CTRL-A"
       MENU-ITEM miFiltro       LABEL "&Filtro"        ACCELERATOR "CTRL-F"
       MENU-ITEM miHistorico    LABEL "&Hist¢rico"     ACCELERATOR "CTRL-T"
       MENU-ITEM miPadrao       LABEL "Libera &PadrÆo" ACCELERATOR "CTRL-P"
       MENU-ITEM miUsuario      LABEL "Libera &Usu rio" ACCELERATOR "CTRL-U"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "Aj&uda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btApontamento 
     IMAGE-UP FILE "image/im-det.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta Apontamento".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image/im-fil.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-fil.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro".

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHistorico 
     IMAGE-UP FILE "image/im-hist.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-hist.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Hist¢rico Abastecimentos e Lubrifica‡äes".

DEFINE BUTTON btModifica 
     IMAGE-UP FILE "image/im-mod.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-mod.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Modificar".

DEFINE BUTTON btPadrao 
     IMAGE-UP FILE "image/im-tick.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-tick.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Liberar pelo PadrÆo".

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

DEFINE BUTTON btUsuario 
     IMAGE-UP FILE "image/im-edl.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-edl.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Liberar pelo Usu rio".

DEFINE VARIABLE fiAbastec AS DECIMAL FORMAT ">>>,>>9.99" INITIAL 0 
     LABEL "Qtde Abastecida":R18 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiDatDocAnt AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Apontamento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescAtiv AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fiDocAnterior AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Apontamento Ant." 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiHodEqpto AS DECIMAL FORMAT ">>>>>>9.9" INITIAL 0 
     LABEL "Contador":R23 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiHodSecEqpto AS DECIMAL FORMAT ">>>>>>9.9" INITIAL 0 
     LABEL "Contador Sec.":R20 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiMaximo AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "M ximo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiMinimo AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "M¡nimo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiModelo AS CHARACTER FORMAT "x(8)" 
     LABEL "Modelo":R8 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fiPadEqpto AS DECIMAL FORMAT ">>>>>9.99":U INITIAL 0 
     LABEL "PadrÆo Equipamento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiPadMod AS DECIMAL FORMAT ">>>>>9.99":U INITIAL 0 
     LABEL "PadrÆo Modelo/Ativ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiPercurso AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Percurso" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiReal AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     LABEL "Real":R18 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiUN1 AS CHARACTER FORMAT "xx":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fiUN2 AS CHARACTER FORMAT "xx":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fiUNSec AS CHARACTER FORMAT "xx":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27 BY 5.96.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 30 BY 6.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brApont FOR 
      ttApont SCROLLING.

DEFINE QUERY brItem FOR 
      ttAbast SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brApont
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brApont wWindow _STRUCTURED
  QUERY brApont NO-LOCK DISPLAY
      fnRetornaEmpresa (ttApont.ep-codigo) @ c-cod-empresa COLUMN-LABEL "Empresa"
      ttApont.cod-eqpto COLUMN-LABEL "Equipamento" FORMAT "x(16)":U
      ttApont.dat-movto COLUMN-LABEL "Data" FORMAT "99/99/9999":U
            WIDTH 11
      ttApont.hra-inicial COLUMN-LABEL "Hora" FORMAT "99:99:99":U
            WIDTH 10
      ttApont.num-docto FORMAT ">>>,>>>,>>9":U
      fnDescErro(ttApont.idi-consist) @ cDescErro COLUMN-LABEL "Descri��o do erro"
            WIDTH 36
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 7
         FONT 1
         TITLE "Erros Apontamentos" ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.

DEFINE BROWSE brItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brItem wWindow _STRUCTURED
  QUERY brItem NO-LOCK DISPLAY
      ttAbast.it-codigo FORMAT "x(16)":U
      ttAbast.val-quant COLUMN-LABEL "Quantidade" FORMAT ">>>,>>9.99":U
            WIDTH 14.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 30 BY 8.25
         FONT 1
         TITLE "Quantidades" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btModifica AT ROW 1.13 COL 2 HELP
          "Modificar"
     btFiltro AT ROW 1.13 COL 6 HELP
          "Filtro"
     btHistorico AT ROW 1.13 COL 10 HELP
          "Hist¢rico Abastecimentos e Lubrifica‡äes"
     btPadrao AT ROW 1.13 COL 14 HELP
          "Liberar pelo PadrÆo"
     btUsuario AT ROW 1.13 COL 18 HELP
          "Liberar pelo Usu rio"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     brApont AT ROW 2.5 COL 1.57
     fiModelo AT ROW 9.71 COL 9 COLON-ALIGNED HELP
          "C¢digo do Modelo"
     fiDescModelo AT ROW 9.71 COL 21.57 COLON-ALIGNED NO-LABEL
     brItem AT ROW 9.71 COL 60.43
     ttApont.cod-ativid AT ROW 10.71 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fiDescAtiv AT ROW 10.71 COL 21.57 COLON-ALIGNED HELP
          "Descri‡Æo da Atividade" NO-LABEL
     fiReal AT ROW 12.13 COL 16 COLON-ALIGNED HELP
          "Quantidade de Combust¡vel"
     fiHodEqpto AT ROW 12.13 COL 41.57 COLON-ALIGNED HELP
          "Valor Hod“metro/Hor¡metro do Equipamento"
     fiUN1 AT ROW 12.13 COL 52 COLON-ALIGNED NO-LABEL
     fiMaximo AT ROW 13.13 COL 16 COLON-ALIGNED
     fiHodSecEqpto AT ROW 13.13 COL 41.57 COLON-ALIGNED HELP
          "Valor Hod“metro/Hor¡metro do Equipamento"
     fiUNSec AT ROW 13.13 COL 52 COLON-ALIGNED NO-LABEL
     fiMinimo AT ROW 14.13 COL 16 COLON-ALIGNED
     fiAbastec AT ROW 14.13 COL 41.57 COLON-ALIGNED HELP
          "Quantidade de Combust¡vel"
     fiPadEqpto AT ROW 15.13 COL 16 COLON-ALIGNED
     fiPercurso AT ROW 15.13 COL 41.57 COLON-ALIGNED
     fiUN2 AT ROW 15.13 COL 52 COLON-ALIGNED NO-LABEL
     fiDocAnterior AT ROW 16.04 COL 41.57 COLON-ALIGNED
     fiPadMod AT ROW 16.13 COL 16 COLON-ALIGNED
     btApontamento AT ROW 16.38 COL 54.29 HELP
          "Consulta do Apontamento"
     fiDatDocAnt AT ROW 16.96 COL 41.57 COLON-ALIGNED
     "Consumo" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 11.71 COL 3
     "Valores" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 11.71 COL 32
     RECT-16 AT ROW 12 COL 2
     RECT-17 AT ROW 12 COL 29.57
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.08
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttAbast T "?" NO-UNDO movfro mab-item-abastec
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttApont T "?" NO-UNDO movfro mab-abastec-lubrific
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttApontAux T "?" NO-UNDO movfro mab-abastec-lubrific
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17.08
         WIDTH              = 90
         MAX-HEIGHT         = 32.25
         MAX-WIDTH          = 205.72
         VIRTUAL-HEIGHT     = 32.25
         VIRTUAL-WIDTH      = 205.72
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brApont btHelp fpage0 */
/* BROWSE-TAB brItem fiDescModelo fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brApont
/* Query rebuild information for BROWSE brApont
     _TblList          = "Temp-Tables.ttApont"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.ttApont.ep-codigo|yes,Temp-Tables.ttApont.cod-eqpto|yes"
     _FldNameList[1]   > "_<CALC>"
"fnRetornaEmpresa (ttApont.ep-codigo) @ c-cod-empresa" "Empresa" ? ? ? ? ? ? ? ? no "C¢digo da empresa do equipamento" no no ? yes no no "U" "" ""
     _FldNameList[2]   > Temp-Tables.ttApont.cod-eqpto
"ttApont.cod-eqpto" "Equipamento" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ttApont.dat-movto
"ttApont.dat-movto" "Data" ? "date" ? ? ? ? ? ? no ? no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttApont.hra-inicial
"ttApont.hra-inicial" "Hora" ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.ttApont.num-docto
     _FldNameList[6]   > "_<CALC>"
"fnDescErro(ttApont.idi-consist) @ cDescErro" "Descri��o do erro" ? ? ? ? ? ? ? ? no ? no no "36" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brApont */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brItem
/* Query rebuild information for BROWSE brItem
     _TblList          = "Temp-Tables.ttAbast"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.ttAbast.it-codigo|yes"
     _FldNameList[1]   = Temp-Tables.ttAbast.it-codigo
     _FldNameList[2]   > Temp-Tables.ttAbast.val-quant
"ttAbast.val-quant" "Quantidade" ? "decimal" ? ? ? ? ? ? no ? no no "14.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brItem */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /** Atualiza‡Æo da Remonta do Motor **/
  run piRemonta in this-procedure.

  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brApont
&Scoped-define SELF-NAME brApont
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brApont wWindow
ON VALUE-CHANGED OF brApont IN FRAME fpage0 /* Erros Apontamentos */
DO:
    /** Busca Regustros para mostrar em tela **/
    run piApontamento in this-procedure.
    /** Habilita / Desabilita Botäes em tela **/
    run piBotoes in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brItem
&Scoped-define SELF-NAME brItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brItem wWindow
ON VALUE-CHANGED OF brItem IN FRAME fpage0 /* Quantidades */
DO:
    /** Busca valores para campos em tela **/
    run piAbastecimento in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btApontamento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btApontamento wWindow
ON CHOOSE OF btApontamento IN FRAME fpage0
DO:
  /** Mostra Hist¢rico Consumo Equipamento **/
  run piConsultaApontamento in this-procedure.
  if return-value = "NOK":U then
      return no-apply.

  apply "ENTRY":U to btApontamento in frame fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    /** Atualiza‡Æo da Remonta do Motor **/
    run piRemonta in this-procedure.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro wWindow
ON CHOOSE OF btFiltro IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miFiltro IN MENU mbMain DO:
  assign {&window-name}:sensitive = no.
  /** Programa Filtro **/
  run abp/ab0402c.w (input-output dtDataIni,
                     input-output dtDataFim,
                     input-output iEmpIni  ,
                     input-output iEmpFim  ,
                     input-output cEqptoIni,
                     input-output cEqptoFim,
                     input-output cEstabIni,
                     input-output cEstabFim,
                     input-output cTagIni  ,
                     input-output cTagFim  ,
                     input-output cCCIni  ,
                     input-output cCCFim  ,
                &IF DEFINED(bf_mnt_ems206b) &THEN
                     input-output cUnidNegocIni,
                     input-output cUnidNegocFim,
                &ENDIF
                     output lOK).

  assign {&window-name}:sensitive = yes.

  /** Busca os registros **/
  if lOK then do:
      run buscaApontamentos in this-procedure.
  end.

  apply "ENTRY":U to brApont in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHistorico wWindow
ON CHOOSE OF btHistorico IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miHistorico IN MENU mbMain DO:
  /** Mostra Hist¢rico Consumo Equipamento **/
  run piHistorico in this-procedure.
  if return-value = "NOK":U then
      return no-apply.

  apply "ENTRY":U to btHistorico in frame fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btModifica
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModifica wWindow
ON CHOOSE OF btModifica IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miModifica IN MENU mbMain DO:
  /** Atualiza Campos **/
  run piModifica in this-procedure.
  
  apply "VALUE-CHANGED":U to browse brApont.
  if return-value = "NOK":U then
      return no-apply.

  apply "ENTRY":U to brApont in frame fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPadrao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPadrao wWindow
ON CHOOSE OF btPadrao IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miPadrao IN MENU mbMain DO:
    /** Libera Registro pelo PadrÆo **/
    DO TRANS:
        run piLibera in this-procedure (input 2).
        if return-value = "NOK":U THEN DO:
            UNDO, LEAVE.
        END.
        ELSE DO:
            /** Busca os registros **/
            run buscaApontamentos in this-procedure.
        END.
    END.
    
    apply "ENTRY":U to brApont in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUsuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUsuario wWindow
ON CHOOSE OF btUsuario IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miUsuario IN MENU mbMain DO:
  /** Libera registro pelo usu rio **/
  DO TRANS:
      run piLibera in this-procedure (input 3).
      if return-value = "NOK":U THEN DO:
         UNDO, LEAVE.
      END.
      ELSE DO:
          /** Busca os registros **/
          run buscaApontamentos in this-procedure.
      END.
  END.

  apply "ENTRY":U to brApont in frame fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttApont.cod-ativid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.cod-ativid wWindow
ON LEAVE OF ttApont.cod-ativid IN FRAME fpage0 /* Atividade */
DO:
    if can-find(first ttApont) then do:
        assign ttApont.cod-ativid:screen-value in frame fPage0 = ttApont.cod-ativid.
        {method\referenceFields.i
            &HandleDBOLeave="hDBOAtiv"
            &KeyValue1="ttApont.cod-ativid:screen-value in frame fPage0"
            &FieldName1="des-ativid"
            &FieldScreen1="fiDescAtiv"
            &Frame1="fPage0"}
    end.
    else 
        assign ttApont.cod-ativid:screen-value in frame fPage0 = ""
               fiDescAtiv:screen-value in frame fPage0         = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiModelo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiModelo wWindow
ON LEAVE OF fiModelo IN FRAME fpage0 /* Modelo */
DO:
    if can-find(first ttApont) then do:
        run buscaModelo in this-procedure.
        {method\referenceFields.i
            &HandleDBOLeave="hDBOModelo"
            &KeyValue1="fiModelo:screen-value in frame fPage0"
            &FieldName1="des-model"
            &FieldScreen1="fiDescModelo"
            &Frame1="fPage0"
            &FieldName2="un"
            &FieldScreen2="fiUN1"
            &Frame2="fPage0"
            &FieldName3="un"
            &FieldScreen3="fiUN2"
            &Frame3="fPage0"
            &FieldName4="cod-livre-1"
            &Variable1="c-cod-livre-1"}
            
            RUN goToKey      IN hDBOModelo (INPUT fiModelo:SCREEN-VALUE IN FRAME fPage0).
            RUN getCharField IN hDBOModelo (INPUT "cod-livre-1":U,
                                            OUTPUT c-cod-livre-1).
        ASSIGN fiUNSec:SCREEN-VALUE IN FRAME fPAge0 = SUBSTRING(c-cod-livre-1, 1, 2).    
        /*ttApont.cod-eqpto*/
    end.
    else 
        assign fiModelo:screen-value in frame fPage0     = ""
               fiDescModelo:screen-value in frame fPage0 = ""
               fiUN1:screen-value in frame fPage0        = ""
               fiUN2:screen-value in frame fPage0        = ""
               fiUNSec:SCREEN-VALUE IN FRAME fPAge0      = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brApont
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

{abp/ab9005.i}    /** Valida‡Æo de Parƒmetros **/
{abp/abapi001.i2} /** Cria‡Æo de Erros **/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) finaliza‡Æo do programa
------------------------------------------------------------------------------*/
/** Equipamento **/
if valid-handle(hDBOEqpto) then
    run Destroy in hDBOEqpto.
/** Modelo **/
if valid-handle(hDBOModelo) then
    run Destroy in hDBOModelo.
/** Atividade **/
if valid-handle(hDBOAtiv) then
    run Destroy in hDBOAtiv.
/** API **/
if valid-handle(hAbapi002) then
    delete procedure hAbapi002.
/**Apontamento**/
if valid-handle(hDBOApont) then
    delete procedure hDBOApont.
/**Abastacimento*/
if valid-handle(hDBOAbast) then
    delete procedure hDBOAbast.





{method/showmessage.i3}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) inicializa‡Æo de tela
------------------------------------------------------------------------------*/
{utp/ut-liter.i "Percurso" MAB}
ASSIGN fiPercurso:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Erros Apontamentos"}
ASSIGN brApont:TITLE IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Quantidades"}
ASSIGN brItem:TITLE IN FRAME fPage0 = RETURN-VALUE.

/** Busca os registros com erros para serem listados **/
run buscaApontamentos in this-procedure.



/** Busca Valores de m ximo e m¡nimo de consumo **/
for each  mab-param
    where mab-param.cdn-param = 14 no-lock:
    assign deParam14 = dec(mab-param.des-valor).
end.

/** Busca os parametros cadastrados ao consumo **/
run piPadrao in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override (antes) inicializa‡Æo de tela
------------------------------------------------------------------------------*/
/** Valida se os parÆmetros estÆo cadastrados **/
{utp/ut-liter.i "Abastecimento"}
run piValidaParametroModulo in this-procedure (input "14,19,20,21":U,
                                               input trim(return-value)).
if return-value = "NOK":U then do:
    /** Instancia aplicativo **/
    {method/showmessage.i1}
    /** Mostra caixa com erros **/
    {method/showmessage.i2 &Modal="YES"}
    /** Limpa temp-tables de erros **/
    empty temp-table RowErrors.
    /** Elimina aplicativo **/
    {method/showmessage.i3}
    return "NOK":U.
end.

assign dtDataIni = today - 30 
       dtDataFim = today
       &IF "{&mguni_version}" >= "2.071" &THEN
       iEmpIni   = ""
       iEmpFim   = "ZZZ"
       &ELSE
       iEmpIni   = 0
       iEmpFim   = 999
       &ENDIF
       cEqptoIni = ""
       cEqptoFim = "ZZZZZZZZZZZZZZZZ":U
       &IF "{&mguni_version}" >= "2.071" &THEN
       cEstabIni = "":U
       cEstabFim = "ZZZZZ":U
       &ELSE
       cEstabIni = "":U
       cEstabFim = "ZZZ":U
       &ENDIF
       cTagIni   = "":U
       cTagFim   = "ZZZZZZZZZZZZZZZZ":U
       cCCIni   = "":U
       cCCFim   = "ZZZZZZZZZZZZZZZZZZZZ":U
    &IF DEFINED(bf_mnt_ems206b) &THEN
       cUnidNegocIni = "":U
       cUnidNegocFim = "ZZZ":U
    &ENDIF
       .

/** Inicializa‡Æo das BOs **/
run initializeDBOs in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaApontamentos wWindow 
PROCEDURE buscaApontamentos :
/*------------------------------------------------------------------------------
  Purpose:     buscaApontamentos
  Parameters:  <none>
  Notes:       Busca os apontamentos que cont‚m erros para serem listados e 
               liberados conforme usu rio desejar
------------------------------------------------------------------------------*/
/** Limpeza das temp-tables **/
empty temp-table ttApont.
empty temp-table ttApontAux.

/** Busca Registros de Apontamentos **/
run setConstraintAtualizacao in hDBOApont (input dtDataIni,
                                           input dtDataFim,
                                           input cEqptoIni,
                                           input cEqptoFim,
                                           input iEmpIni,
                                           input iEmpFim) no-error.
run openQueryStatic in hDBOApont (input "Atualizacao":U) no-error.
run getBatchRecords in hDBOApont (input  ?,
                                  input  no,
                                  input  9999,
                                  output iRow,
                                  output table ttApontAux).
/** Filtra por Estabelecimento, TAG e Centro de custo e Unidade Negocio **/
for each ttApontAux:
    for last  mab-histor-ativid
        where mab-histor-ativid.ep-codigo     = ttApontAux.ep-codigo
        and   mab-histor-ativid.cod-eqpto     = ttApontAux.cod-eqpto
        and   mab-histor-ativid.dat-cadastro <= ttApontAux.dat-movto no-lock:

        /* Conforme IPP-Abastecimento do Projeto 493-Unidade de Neg¢cio 
           Estabelecimento, Centro de Custo e Unidade de Neg¢cio devem ser verificados
           contra a tabela de Abastecimento "mab-abastec-lubrific" */
        if ttApontAux.cod-estabel-matr < cEstabIni or
           ttApontAux.cod-estabel-matr > cEstabFim then leave.
        if ttApontAux.cc-codigo < cCCIni or
           ttApontAux.cc-codigo > cCCFim then leave.
        if mab-histor-ativid.cd-tag    < cTagIni or
           mab-histor-ativid.cd-tag    > cTagFim then leave.

        &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN
            IF ttApontAux.cod-unid-negoc < cUnidNegocIni OR
               ttApontAux.cod-unid-negoc > cUnidNegocFim THEN LEAVE.
        &ENDIF

        create ttApont.
        buffer-copy ttApontAux to ttApont.
    end.
end.

empty temp-table ttApontAux.

{&OPEN-QUERY-brApont}
apply "VALUE-CHANGED":U to browse brApont.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaModelo wWindow 
PROCEDURE buscaModelo :
/*------------------------------------------------------------------------------
  Purpose:     buscaModelo
  Parameters:  <none>
  Notes:       Busca o c¢digo do modelo no equipamento
------------------------------------------------------------------------------*/

{method\referenceFields.i
    &HandleDBOLeave="hDBOEqpto"
    &KeyValue1="ttApont.ep-codigo"
    &KeyValue2="ttApont.cod-eqpto"
    &FieldName1="cod-model"
    &FieldScreen1="fiModelo"
    &Frame1="fPage0"}
    
RUN goToKey IN hDBOEqpto (INPUT ttApont.ep-codigo,
                          INPUT ttApont.cod-eqpto).
RUN getLogField IN hDBOEqpto (INPUT "log-cont-sec":U,
                              OUTPUT lUsacontadorSec).

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     initializeDBOs
  Parameters:  <none>
  Notes:       Inicializa as DBOs necess rias no programa
------------------------------------------------------------------------------*/
    /*--- BO Apontamento ---*/
    IF NOT VALID-HANDLE(hDBOApont) OR
       hDBOApont:TYPE <> "PROCEDURE":U OR
       hDBOApont:FILE-NAME <> "frbo/bofr055.p":U THEN DO:
        run frbo/bofr055.p persistent set hDBOApont.
    END.

    /*--- BO Abastecimento  ---*/
    IF NOT VALID-HANDLE(hDBOAbast) OR 
       hDBOAbast:TYPE <> "PROCEDURE":U OR
       hDBOAbast:FILE-NAME <> "frbo/bofr057.p":U THEN DO:
        run frbo/bofr057.p persistent set hDBOAbast.
    END.

    /*--- DBO Equipamento ---*/
    IF NOT VALID-HANDLE(hDBOEqpto) OR
       hDBOEqpto:TYPE <> "PROCEDURE":U OR
       hDBOEqpto:FILE-NAME <> "frbo/bofr007.p":U THEN DO:
        run frbo/bofr007.p persistent set  hDBOEqpto.
    END.
    
    RUN openQueryStatic IN hDBOEqpto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo/bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

    /*--- DBO Atividade  ---*/
    IF NOT VALID-HANDLE(hDBOAtiv) OR
       hDBOAtiv:TYPE <> "PROCEDURE":U OR
       hDBOAtiv:FILE-NAME <> "frbo/bofr001.p":U THEN DO:
        run frbo/bofr001.p persistent set  hDBOAtiv.
    END.
    
    RUN openQueryStatic IN hDBOAtiv (INPUT "Main":U) NO-ERROR.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAbastecimento wWindow 
PROCEDURE piAbastecimento :
/*------------------------------------------------------------------------------
  Purpose:     piAbastecimento
  Parameters:  <none>
  Notes:       Busca campos para serem mostrados em tela de acordo com registros
               de apontamento de abastecimento.
------------------------------------------------------------------------------*/
define buffer bfAbast for ttAbast.

/** Campo Consumo Real **/
assign fiAbastec = 0.
if avail(ttAbast) then do:
    for each  bfAbast
        where bfAbast.log-abastec-prim no-lock:
        assign fiAbastec = fiAbastec + bfAbast.val-quant.
    end.
end.
display fiAbastec with frame fPage0.

/** Consumo PadrÆo Equipamento **/
run piPadrao in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAnterior wWindow 
PROCEDURE piAnterior :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p-doc AS INTEGER    NO-UNDO.
DEFINE INPUT  PARAMETER d-val-horim LIKE mab-abastec-lubrific.val-hodom-horim NO-UNDO.

ASSIGN fiDocAnterior = 0
       fiDatDocAnt   = ?.

IF p-doc <> ? THEN DO:
    FOR FIRST mab-abastec-lubrific WHERE mab-abastec-lubrific.num-docto = p-doc NO-LOCK:
        /** Verifica se existem apontamentos anteriores para equipamento por data **/
        IF CAN-FIND(LAST mab-item-abastec
                    WHERE mab-item-abastec.ep-codigo = mab-abastec-lubrific.ep-codigo           
                    AND   mab-item-abastec.cod-eqpto = mab-abastec-lubrific.cod-eqpto           
                    AND   mab-item-abastec.val-dat-hora-invrtda < mab-abastec-lubrific.val-dat-hora-invrtda
                    AND   mab-item-abastec.log-abastec-prim = YES NO-LOCK) THEN DO:
            
            FOR LAST mab-item-abastec
                WHERE mab-item-abastec.ep-codigo = mab-abastec-lubrific.ep-codigo           
                AND   mab-item-abastec.cod-eqpto = mab-abastec-lubrific.cod-eqpto           
                AND   mab-item-abastec.val-dat-hora-invrtda < mab-abastec-lubrific.val-dat-hora-invrtda
                AND   mab-item-abastec.log-abastec-prim = YES NO-LOCK:
            END.

            FIND FIRST bfApont 
                WHERE bfApont.num-docto = mab-item-abastec.num-docto NO-LOCK NO-ERROR.
            IF AVAIL bfApont THEN
                ASSIGN fiDocAnterior   = bfApont.num-docto
                       fiDatDocAnt   = bfApont.dat-movto
                       fiPercurso    = d-val-horim - bfApont.val-hodom-horim.
        END.
        ELSE DO:
            /*Colocado a valida‡Æo abaixo caso o hod“metro inicial seja maior que zero*/
            IF AVAILABLE mab-eqpto AND mab-eqpto.val-hodom-horim-inicial > 0 THEN
                 ASSIGN fiPercurso = mab-abastec-lubrific.val-hodom-horim - mab-eqpto.val-hodom-horim-inicial.
            ELSE ASSIGN fiPercurso = mab-abastec-lubrific.val-hodom-horim.

        END.
            
    END.
END.

DISP fiDocAnterior fiDatDocAnt fiPercurso with FRAME fpage0.
  
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piApontamento wWindow 
PROCEDURE piApontamento :
/*------------------------------------------------------------------------------
  Purpose:     piApontamento
  Parameters:  <none>
  Notes:       Busca valores para campos em tela conforme registros de
               apontamentos
------------------------------------------------------------------------------*/
empty temp-table ttAbast.

assign fiHodEqpto    = 0
       fiHodSecEqpto = 0.

if avail ttApont then do:

    for first mab-eqpto
        where mab-eqpto.ep-codigo = ttApont.ep-codigo 
        and   mab-eqpto.cod-eqpto = ttApont.cod-eqpto no-lock:
    end.            

    /*--- Faz a liga‡Æo entre o DBO filho e o DBO pai ---*/
    RUN setConstraintApontamento IN hDBOAbast (INPUT ttApont.num-docto).
    
    /*--- Abre query do DBO filho ---*/
    RUN openQueryStatic IN hDBOAbast (INPUT "ApontPrimario":U).
    
    /*--- Retorna faixa de registro do DBO Filho ---*/
    RUN getBatchRecords IN hDBOAbast (INPUT ?,
                                      INPUT NO,
                                      INPUT 40,
                                      OUTPUT iRow,
                                      OUTPUT TABLE ttAbast).
    assign fiHodEqpto    = ttApont.val-hodom-horim
           fiHodSecEqpto = ttApont.val-hodom-horim-sec.
           
    /** Busca o Apontamento anterior **/
    run piAnterior in THIS-PROCEDURE (INPUT ttApont.num-docto, INPUT ttApont.val-hodom-horim).
end.

DISPLAY fiHodEqpto fiPercurso
        fiHodSecEqpto fiPercurso WITH FRAME fPage0.

/** Campos em Tela **/
apply "LEAVE":U to ttApont.cod-ativid in frame fPage0.
apply "LEAVE":U to fiModelo in frame fPage0.

/*--- Abre a query associada ao browse ---*/
{&OPEN-QUERY-brItem}
APPLY "VALUE-CHANGED":U TO BROWSE brItem.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaFichas wWindow 
PROCEDURE piAtualizaFichas :
/*------------------------------------------------------------------------------
  Purpose:     piAtualizaFichas
  Parameters:  <none>
  Notes:       Atualiza as fichas posteriores a ficha alterada
------------------------------------------------------------------------------*/
/** Cria Faixa de parƒmetros **/
run piParametro in this-procedure (input 1,
                                   input ?).
/** Atualiza fichas **/
run abp/abapi001.p (input  table tt-param,
                    output table RowErrors,
                    output table ttDocLib).
/** Verifica erros **/
if can-find(first RowErrors) then do:
  run piMostraErros in this-procedure (2).
end.
/** Limpa temp-table **/
empty temp-table tt-param.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBotoes wWindow 
PROCEDURE piBotoes :
/*------------------------------------------------------------------------------
  Purpose:     piBotoes
  Parameters:  <none>
  Notes:       Habilita / Desabilita Botäes em tela
------------------------------------------------------------------------------*/
if avail(ttApont) then
    assign btModifica:sensitive in frame fPage0            = yes
           menu-item miModifica:sensitive in menu mbMain   = yes
           btHistorico:sensitive in frame fPage0           = yes 
           menu-item miHistorico:sensitive in menu mbMain  = yes
           btPadrao:sensitive in frame fPage0              = yes 
           menu-item miPadrao:sensitive in menu mbMain     = yes
           btUsuario:sensitive in frame fPage0             = yes 
           menu-item miUsuario:sensitive in menu mbMain    = yes
           btApontamento:sensitive in frame fPage0         = yes.
else
    assign btModifica:sensitive in frame fPage0            = no
           menu-item miModifica:sensitive in menu mbMain   = no
           btHistorico:sensitive in frame fPage0           = no 
           menu-item miHistorico:sensitive in menu mbMain  = no
           btPadrao:sensitive in frame fPage0              = no 
           menu-item miPadrao:sensitive in menu mbMain     = no
           btUsuario:sensitive in frame fPage0             = no 
           menu-item miUsuario:sensitive in menu mbMain    = no
           btApontamento:sensitive in frame fPage0         = no.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piConsultaApontamento wWindow 
PROCEDURE piConsultaApontamento :
/*------------------------------------------------------------------------------
  Purpose:     piConsultaApontamento
  Parameters:  <none>
  Notes:       Consulta o Apontamento anterior ao do browse
------------------------------------------------------------------------------*/
DEFINE VARIABLE h-program AS HANDLE     NO-UNDO.

assign {&WINDOW-NAME}:sensitive = no.

FOR first mab-abastec-lubrific 
    WHERE mab-abastec-lubrific.num-docto = INPUT FRAME fpage0 fiDocAnterior NO-LOCK:
      RUN abp/ab0611.w PERSISTENT SET h-program.
      /** Valida‡Æo do Handle **/
      RUN initializeInterface IN h-program.
      IF RETURN-VALUE = "OK":U THEN
       /*:T Reposiciona registro com base em um rowid */
          RUN repositionRecord IN h-program (INPUT ROWID(mab-abastec-lubrific)).
      WAIT-FOR "close":U oF h-Program.
END.
assign {&WINDOW-NAME}:sensitive = yes.

IF VALID-handle (h-program) THEN
    DELETE PROCEDURE h-program.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaTT-param-pnp wWindow 
PROCEDURE piCriaTT-param-pnp :
/*------------------------------------------------------------------------------
  Purpose: Atualiza‡Æo da durabilidade dos pneus, conforme abastecimentos.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF CAN-FIND (FIRST ttDocLib) THEN DO:

    FIND FIRST mab-abastec-lubrific
         WHERE mab-abastec-lubrific.num-docto = ttDocLib.num-docto NO-LOCK.
    IF AVAIL mab-abastec-lubrific THEN DO:
        ASSIGN cEmpCod    = mab-abastec-lubrific.ep-codigo
               cCodEqpto  = mab-abastec-lubrific.cod-eqpto
               dtDatMovto = mab-abastec-lubrific.dat-movto.
        
        CREATE tt-param-pnp.
        ASSIGN tt-param-pnp.usuario         = c-seg-usuario        
               tt-param-pnp.destino         = 1                    
               tt-param-pnp.arquivo         = ""                   
               tt-param-pnp.data-exec       = today                
               tt-param-pnp.hora-exec       = time                 
               tt-param-pnp.iConsiste       = 2                    
               tt-param-pnp.descConsiste    = "Todos":U            
               tt-param-pnp.iEmpIni         = cEmpCod
               tt-param-pnp.iEmpFim         = cEmpCod
               tt-param-pnp.cEqptoIni       = cCodEqpto
               tt-param-pnp.cEqptoFim       = cCodEqpto
               tt-param-pnp.num-docto       = ttDocLib.num-docto
               tt-param-pnp.lFicha          = yes                  
               tt-param-pnp.tipo-liberacao  = 1 /** Normal **/     
               tt-param-pnp.cCCini          = ""                   
               tt-param-pnp.cCCfim          = "ZZZZZZZZZZZZZZZZZZZZ"           
               tt-param-pnp.cPostoIni       = ""                   
               tt-param-pnp.cPostoFim       = "ZZZZZZZZ".

        for FIRST mab-param
            where mab-param.cdn-param = 53 no-lock:
            ASSIGN c-valor-param53 = mab-param.des-valor.
        END.
            
        for last  mab-histor-ativid fields(cod-estab cd-tag &IF DEFINED(bf_mnt_ems206b) &THEN cod-unid-negoc &ENDIF)
            where mab-histor-ativid.ep-codigo     = cEmpCod
            and   mab-histor-ativid.cod-eqpto     = cCodEqpto
            and   mab-histor-ativid.dat-cadastro <= dtDatMovto  no-lock:
            assign tt-param-pnp.cEstabIni       = mab-histor-ativid.cod-estab
                   tt-param-pnp.cEstabFim       = mab-histor-ativid.cod-estab
                   tt-param-pnp.cTagIni         = mab-histor-ativid.cd-tag
                   tt-param-pnp.cTagFim         = mab-histor-ativid.cd-tag.
            /* Altera‡Æo para atender o IPP-Abastecimento do Projeto 493-Unidade de Neg¢cio */
            &IF DEFINED(bf_mnt_ems206b) &THEN
                IF  l-usa-unid-negoc THEN
                    ASSIGN tt-param-pnp.cUnidNegocIni = mab-histor-ativid.cod-unid-negoc
                           tt-param-pnp.cUnidNegocFim = mab-histor-ativid.cod-unid-negoc.
            &ENDIF
        end.
        IF NOT AVAIL mab-histor-ativid OR c-valor-param53 = "1":U THEN DO:
            FOR LAST   mab-histor-ativid
                WHERE  mab-histor-ativid.ep-codigo = cEmpCod
                AND    mab-histor-ativid.cod-eqpto = cCodEqpto NO-LOCK:
                assign tt-param-pnp.cEstabIni       = mab-histor-ativid.cod-estab
                       tt-param-pnp.cEstabFim       = mab-histor-ativid.cod-estab
                       tt-param-pnp.cTagIni         = mab-histor-ativid.cd-tag
                       tt-param-pnp.cTagFim         = mab-histor-ativid.cd-tag.
                /* Altera‡Æo para atender o IPP-Abastecimento do Projeto 493-Unidade de Neg¢cio */
                &IF DEFINED(bf_mnt_ems206b) &THEN
                    IF  l-usa-unid-negoc THEN
                        ASSIGN tt-param-pnp.cUnidNegocIni = mab-histor-ativid.cod-unid-negoc
                               tt-param-pnp.cUnidNegocFim = mab-histor-ativid.cod-unid-negoc.
                &ENDIF
            END.
        END.
    END.
END.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piHistorico wWindow 
PROCEDURE piHistorico :
/*------------------------------------------------------------------------------
  Purpose:     piHistorico
  Parameters:  <none>
  Notes:       Mostra Hist¢rico do consumo do equipamento
------------------------------------------------------------------------------*/
DEFINE VARIABLE r-mab-eqpto AS ROWID   NO-UNDO.
DEFINE VARIABLE hProgram AS HANDLE     NO-UNDO.
ASSIGN r-mab-eqpto = ?.
IF AVAIL ttapont THEN DO:
    GET CURRENT brapont NO-LOCK.
    FOR first mab-eqpto 
        where mab-eqpto.ep-codigo = ttapont.ep-codigo
        AND mab-eqpto.cod-eqpto = ttapont.cod-eqpto NO-LOCK:
        ASSIGN r-mab-eqpto =  rowid(mab-eqpto).
    END.
END.
assign {&WINDOW-NAME}:sensitive = no.

/** Chama programa de hist¢rico da remonta **/
RUN abp/ab0618.w PERSISTENT SET hProgram.
                
  /** Valida‡Æo do Handle **/
  IF VALID-HANDLE(hProgram) AND
     hProgram:Type = "PROCEDURE":U AND
     hProgram:FILE-NAME = "abp/ab0618.w":U THEN do:
      /*--- Inicializa programa de consulta ---*/
      RUN initializeInterface IN hProgram.
      /*:T Reposiciona registro com base em um rowid */
      IF r-mab-eqpto <> ? THEN
         RUN repositionRecord IN hProgram (INPUT r-mab-eqpto).
      WAIT-FOR "close":U oF hProgram.
  end.

assign {&WINDOW-NAME}:sensitive = yes.
IF valid-handle(hprogram) THEN
    DELETE PROCEDURE hprogram.
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLibera wWindow 
PROCEDURE piLibera :
/*------------------------------------------------------------------------------
  Purpose:     piLibera
  Parameters:  pLibera = Tipo Libera‡Æo  
                         -> 2 = PadrÆo
                         -> 3 = Usu rio 
  Notes:       Libera o apontamento
------------------------------------------------------------------------------*/
define input parameter pLibera as integer no-undo.

DEFINE VARIABLE cEvento AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iDoc    AS INTEGER    NO-UNDO.

/**---------------------------------- C lculo -------------------------------------**/
run piParametro in THIS-PROCEDURE (input pLibera,
                                   input ttApont.num-docto).
/** Calcula Temp-Table de Documentos a serem liberados **/
run abp/abapi001.p (input  table tt-param,
                    output table RowErrors,
                    output table ttDocLib).
/** Erros da API de c lculo **/
if can-find(first RowErrors) then do:
    run piMostraErros in this-procedure (2).
    return "NOK":U.
end.

/**--------------------------------- Libera‡Æo ------------------------------------**/
/** Roda API libera‡Æo persistente **/
run abp/abapi002.p persistent set hAbapi002.
/** Inicializa‡Æo de BOs **/
run initializeHandle in hAbapi002.

for first ttDocLib
    where ttDocLib.num-docto = ttApont.num-docto no-lock:
    if pLibera = 2 then do:
        /** Verifica Quantidade Abastecida **/
        run piQuantidade in hAbapi002 (input ttApont.num-docto,
                                       input ttDocLib.tp-consumo,
                                       input input frame fPage0 fiAbastec,
                                       input ttDocLib.consumo-padrao).
        if return-value = "NOK":U then do:
            run piMostraErros in this-procedure (3).
            run finalizaHandle in hAbapi002.
            if valid-handle(hAbapi002) then delete procedure hAbapi002.
            return "NOK":U.
        end.
        /** Pergunta para liberar pelo padrÆo **/
        {utp/ut-liter.i "pelo consumo padrÆo"}
        run utp/ut-msgs.p (input "SHOW":U,
                           input 28489,
                           input string(ttApont.num-docto) + '~~' +
                                 fiAbastec:screen-value in frame fPage0 + '~~' +
                                 return-value).
        if return-value = "NO":U then do:
            run finalizaHandle in hAbapi002.
            if valid-handle(hAbapi002) then delete procedure hAbapi002.
            return "NOK":U.
        end.
        if c-nom-prog-upc-mg97 <> "" and 
           c-nom-prog-upc-mg97 <> ? then do:
            run value(c-nom-prog-upc-mg97) (input "after-libera-padrao":u, 
                                            input "Container":u,
                                            input THIS-PROCEDURE,
                                            input FRAME fpage0:HANDLE,
                                            input "mab-abastec-lubrific":u,
                                            input if avail mab-abastec-lubrific then rowid(mab-abastec-lubrific) else ?).
            if return-value = 'nok':u then
                return "NOK":U.
        END.
    end.
    else do:
        assign {&window-name}:sensitive = no.
        /** Programa Atualiza‡Æo **/
        run abp/ab0402b.w (input  ttApont.r-rowid,
                           input  ttDocLib.consumo-padrao,
                           input  ttDocLib.consumo-padrao-sec,
                           input  ttDocLib.qtd-abast,
                           input  input frame fPage0 fiUN1,
                           input  input frame fPage0 fiUNSec,
                           input  iTpConsumo,
                           INPUT  iTpConsumoSec,
                           OUTPUT iUsoReal,
                           OUTPUT iUsoRealSec,
                           output lOK).
        assign {&window-name}:sensitive = yes.
        IF lok = YES THEN DO:
            if c-nom-prog-upc-mg97 <> "" and 
               c-nom-prog-upc-mg97 <> ? then do:
                run value(c-nom-prog-upc-mg97) (input "after-libera-padrao":u, 
                                                input "Container":u,
                                                input THIS-PROCEDURE,
                                                input FRAME fpage0:HANDLE,
                                                input "mab-abastec-lubrific":u,
                                                input if avail mab-abastec-lubrific then rowid(mab-abastec-lubrific) else ?).
                if return-value = 'nok':u then
                    return "NOK":U.
            END.
        END.
        if not(lOK) then do:
            run finalizaHandle in hAbapi002.                           
            if valid-handle(hAbapi002) then delete procedure hAbapi002.
            return "NOK":U.
        end.
    end. /** else **/
end. /** for **/
/** Guarda tt para pneus na API **/
RUN piCriaTT-param-pnp IN THIS-PROCEDURE.
/** Guarda tt na API **/
run piRecebeTT in hAbapi002 (input table ttDocLib).
/**tt de parametros para pneus**/
RUN piRecebeTTParam IN hAbapi002 (INPUT TABLE tt-param-pnp).
if return-value = "NOK":U then do:
    run piMostraErros in this-procedure (3).
    run finalizaHandle in hAbapi002.                           
    if valid-handle(hAbapi002) then delete procedure hAbapi002.
    return "NOK":U.
end.
/** Libera‡Æo **/
run piLiberacao in hAbapi002 (input pLibera,
                              INPUT iUsoReal, 
                              INPUT iUsoRealSec).

IF RETURN-VALUE = "WARNING":U THEN DO:
    RUN piMostraErros IN THIS-PROCEDURE (3).
    IF  VALID-HANDLE(hAbapi002) THEN DO:
        RUN finalizaHandle IN hAbapi002.                           
        DELETE PROCEDURE hAbapi002.
    END.
    RETURN "NOK":U.
END.

/**---------------------------------- Evento -------------------------------------**/
/** Cria‡Æo de Eventos para Manuten‡Æo **/
for first ttDocLib:
    /** Contador parado ou Contador Secundario parado **/
    if ttDocLib.idi-consist = 4 or ttDocLib.idi-consist = 7 then do:
        run utp/ut-msgs.p (input "SHOW":U,
                           input 28491,
                           input ttApont.cod-eqpto).
        if return-value = "YES":U then do:
            /** Valida‡äes Parƒmetros **/
            run piValida in hAbapi002.
            if return-value <> "NOK":U then do:
                /** Cria ttEvento **/
                run piEvento in hAbapi002 (input  c-seg-usuario,
                                           output iDoc).
                if return-value = "DOC":U then do:
                    /** Pergunta para criar evento duplicado **/
                    run utp/ut-msgs.p (INPUT "SHOW":U,
                                       INPUT 28493,
                                       INPUT ttApont.cod-eqpto + '~~' + STRING(iDoc)).

                    if return-value = "NO":U then do:
                        if valid-handle(hAbapi002) then do:
                            run finalizaHandle in hAbapi002.
                            delete procedure hAbapi002.
                        end.
                    end.
                    else do:
                        /** Cria Evento **/
                        run piCriaEvento in hAbapi002.
                        if return-value = "NOK":U then
                            run piMostraErros in this-procedure (3).
                    end.
                end.
                else do:
                    /** Cria Evento **/
                    run piCriaEvento in hAbapi002.
                    if return-value = "NOK":U then
                        run piMostraErros in this-procedure (3).
                end.
            end.
            /** Erro na valida‡Æo inicial **/
            else
                run piMostraErros in this-procedure (3).            
        end.
    end.
end.

if valid-handle(hAbapi002) then do:
    run finalizaHandle in hAbapi002.
    delete procedure hAbapi002.
end.

empty temp-table ttDocLib.
empty temp-table tt-param.

/** Atualiza as outras fichas **/
run piAtualizaFichas in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piModifica wWindow 
PROCEDURE piModifica :
/*------------------------------------------------------------------------------
  Purpose:     piModifica
  Parameters:  <none>
  Notes:       Modifica campos (Hod“metro, Data e Hora)
------------------------------------------------------------------------------*/
define variable rReposition as rowid no-undo.

assign {&window-name}:sensitive = no.
/** Programa Atualiza‡Æo **/
run abp/ab0402a.w (input  ttApont.r-rowid,
                   input  input frame fPage0 fiUN1,
                   input  input frame fPage0 fiUNSec,
                   input  lUsaContadorSec,
                   output deHodometro,
                   output deHodometroSec,
                   output dtMovimento,
                   output hrHorario,
                   OUTPUT tpAtividade,
                   output lOK).

assign {&window-name}:sensitive = yes.

/** Atualiza Apontamento **/
if lOK then do:
  create ttApontAux.
  buffer-copy ttApont to ttApontAux
  assign ttApontAux.val-hodom-horim     = deHodometro
         ttApontAux.val-hodom-horim-sec = deHodometroSec
         ttApontAux.dat-movto           = dtMovimento
         ttApontAux.hra-inicial         = hrHorario
         ttApontAux.hra-final           = hrHorario
         ttApontAux.cod-ativid          = tpAtividade
         rReposition                    = ttApont.r-rowid.
  run repositionRecord in hDBOApont (input rReposition).
  /*--- Transfere temp-table ttApontAux para o DBO ---*/
  RUN setRecord IN hDBOApont (INPUT TABLE ttApontAux).
  empty temp-table ttApontAux.
  /** Salva Registro Alterado Validando dados **/
  RUN updateRecord IN hDBOApont.
  if return-value = "NOK":U then do:
      run piMostraErros in this-procedure (1).
      return "NOK":U.
  end.
  /** Atualiza as datas das tabelas filhas **/
  run atualizaDatas in hDBOApont (input rReposition).
  /** Atualiza‡Æo API001 **/
  run piParametro in this-procedure (input 1,
                                     input ttApont.num-docto).
  run abp/abapi001.p (input  table tt-param,
                      output table RowErrors,
                      output table ttDocLib).
  if can-find(first RowErrors) then do:
      run piMostraErros in this-procedure (2).
  end.
  empty temp-table tt-param.

  /** Atualiza as outras fichas **/
  run piAtualizaFichas in this-procedure.

  /** Busca os registros com erros para serem listados **/
  run buscaApontamentos in this-procedure.
  /** Reposiciona registro na linha modificada **/
  for first ttApont where ttApont.r-rowid = rReposition:
      reposition brApont to rowid rowid(ttApont).
  end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraErros wWindow 
PROCEDURE piMostraErros :
/*------------------------------------------------------------------------------
  Purpose:     piMostraErros
  Parameters:  pLocal = Local de onde pegar os erros
                        1 = BO
                        2 = Local
                        3 = API002
  Notes:       Verifica a temp-table de erros da BO e mostra em tela as mensagens
------------------------------------------------------------------------------*/

define input parameter pLocal as integer no-undo.

/** Instancia aplicativo **/
{method/showmessage.i1}
case pLocal:
    when 1 then
        /** Busca erros na BO **/
        run getRowErrors in hDBOApont (output table RowErrors).
  
    when 3 then
        /** Busca erros na API **/
        run getErros in hAbapi002 (output table RowErrors).
end case.
/** Mostra caixa com erros **/
{method/showmessage.i2 &Modal="YES"}
case pLocal:
    when 1 then
        /** Limpa temp-tables de erros **/
        run emptyRowErrors in hDBOApont.
   
    when 3 then
        /** Limpa temp-tables de erros **/
        run emptyErros in hAbapi002.  
end case.

empty temp-table RowErrors.
empty temp-table ttDocLib.
empty temp-table tt-param.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPadrao wWindow 
PROCEDURE piPadrao :
/*------------------------------------------------------------------------------
  Purpose:     piPadrao
  Parameters:  <none>
  Notes:       Busca Consumo PadrÆo do Equipamento e do Modelo
------------------------------------------------------------------------------*/
assign fiPadMod   = 0
       fiPadEqpto = 0
       fiReal     = 0
       fiMaximo   = 0
       fiMinimo   = 0.

if avail(ttAbast) then do:
    /** Busca Hist¢rico de Combust¡vel para apontamento **/
    for last  mab-histor-combust
        where mab-histor-combust.ep-codigo      = ttApont.ep-codigo
        and   mab-histor-combust.cod-eqpto      = ttApont.cod-eqpto
        and   mab-histor-combust.cod-tip-mater  = ttAbast.cod-tip-mater
        and   mab-histor-combust.dat-inicial   <= ttApont.dat-movto no-lock:
        assign iTpConsumo    = mab-histor-combust.idi-tip-consu
               iTpConsumoSec = mab-histor-combust.num-livre-1.
        /** Guarda tipo de consumo do equipamento 
            (1 - Sem Consumo
             2 - Km-Hora/Qtd
             3 - Qtd/Km-Hora) **/
        if iTpConsumo > 1 then do:
            /**PadrÆo Equipamento **/
            assign fiPadEqpto = mab-histor-combust.val-consu-padr.
            /** 2 - Km-Hora/Qtd **/
            if mab-histor-combust.idi-tip-consu = 2 then
                assign fiReal = ttApont.val-km-percur / fiAbastec.
            /** 3 - Qtd/Km-Hora **/
            else
                assign fiReal = fiAbastec / ttApont.val-km-percur.
        end.
        /** Verifica se consumo padrÆo est  no modelo **/
        for first mab-consu-model
            where mab-consu-model.cod-model     = fiModelo:screen-value in frame fPage0
            and   mab-consu-model.cod-ativid    = ttApont.cod-ativid
            and   mab-consu-model.cod-tip-mater = ttAbast.cod-tip-mater  no-lock:
            /** PadrÆo Modelo **/
            assign fiPadMod = mab-consu-model.val-consu-padr.
        end.
    end.
end.

/** Verifica M ximo e m¡nimo **/
if fiPadMod > 0 then
    assign fiMaximo = fiPadMod + (fiPadMod * deParam14 / 100)
           fiMinimo = fiPadMod - (fiPadMod * deParam14 / 100).
else 
    assign fiMaximo = fiPadEqpto + (fiPadEqpto * deParam14 / 100)
           fiMinimo = fiPadEqpto - (fiPadEqpto * deParam14 / 100).

if fiReal = ? then
    assign fiReal = 0.

display fiPadMod fiPadEqpto fiReal fiMaximo fiMinimo with frame fPage0.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piParametro wWindow 
PROCEDURE piParametro :
/*------------------------------------------------------------------------------
  Purpose:     piParametro
  Parameters:  pLibera = Tipo de Libera‡Æo
  Notes:       Cria a temp-table de parƒmetros para a atualiza‡Æo on-line
               (tt-param)
------------------------------------------------------------------------------*/
define input parameter pLibera as integer no-undo.
define input parameter pDoc    as integer no-undo.

empty temp-table tt-param.

create tt-param.
assign tt-param.usuario         = c-seg-usuario
       tt-param.destino         = 1
       tt-param.arquivo         = ""
       tt-param.data-exec       = today
       tt-param.hora-exec       = time
       tt-param.iConsiste       = 1
       tt-param.descConsiste    = "Somente com Problemas"
       tt-param.dataIni         = if ttApont.dat-movto > dtMovimento 
                                  then ttApont.dat-movto
                                  else dtMovimento
       tt-param.dataFim         = today
       tt-param.iEmpIni         = ttApont.ep-codigo
       tt-param.iEmpFim         = ttApont.ep-codigo
       tt-param.cEqptoIni       = ttApont.cod-eqpto
       tt-param.cEqptoFim       = ttApont.cod-eqpto
       tt-param.num-docto       = pDoc
       tt-param.lFicha          = yes
       tt-param.tipo-liberacao  = pLibera
       tt-param.cEstabIni       = ""
&IF "{&mguni_version}" >= "2.071" &THEN
       tt-param.cEstabFim       = "ZZZZZ"
&ELSE
       tt-param.cEstabFim       = "ZZZ"
&ENDIF
       tt-param.cTagIni         = ""
       tt-param.cTagFim         = "ZZZZZZZZZZZZZZZZ"
       tt-param.cCCIni          = ""
       tt-param.cCCFim          = "ZZZZZZZZZZZZZZZZZZZZ"
       tt-param.cPostoIni       = ttApont.cod-posto
       tt-param.cPostoFim       = ttApont.cod-posto
&IF DEFINED(bf_mnt_ems206b) &THEN
       tt-param.cUnidNegocIni   = ttApont.cod-unid-negoc
       tt-param.cUnidNegocFim   = ttApont.cod-unid-negoc
&ENDIF
       .

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRemonta wWindow 
PROCEDURE piRemonta :
/*------------------------------------------------------------------------------
  Purpose:     piRemonta
  Parameters:  <none>
  Notes:       Chama programa de atualiza‡Æo da remonta do motor 
------------------------------------------------------------------------------*/

/** Pergunta ao usu rio se deseja atualizar remonta **/
run utp/ut-msgs.p (input "show":U,
                   input 28545,
                   input "").

if return-value = "yes":U then do:
    assign {&WINDOW-NAME}:sensitive = no.
    run abp/ab0404.w.
    assign {&WINDOW-NAME}:sensitive = yes.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescErro wWindow 
FUNCTION fnDescErro RETURNS CHARACTER
  ( input iStatus as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
define variable cStatus as character format 'x(40)' no-undo.

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao001 = {frinc/i00fr055.i 04 iStatus}.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN  cStatus = RETURN-VALUE.
&else
    ASSIGN cStatus = {frinc/i00fr055.i 04 iStatus}.
&endif
  RETURN cStatus.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRetornaEmpresa wWindow 
FUNCTION fnRetornaEmpresa RETURNS CHARACTER
  (pEmp &IF "{&mguni_version}" >= "2.071" &THEN AS CHARACTER &ELSE AS INT &ENDIF /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  &IF "{&mguni_version}" >= "2.071" &THEN
      ASSIGN c-cod-empresa = pEmp.
  &ELSE
      ASSIGN c-cod-empresa = pEmp.
  &ENDIF
  
  RETURN STRING(c-cod-empresa).

END FUNCTION

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

