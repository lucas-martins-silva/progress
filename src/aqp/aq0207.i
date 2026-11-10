&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-nota-promis-rural NO-UNDO LIKE nota-promis-rural
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-produt-rural NO-UNDO LIKE produt-rural
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-propried-rural NO-UNDO LIKE propried-rural
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-pto-coleta NO-UNDO LIKE pto-coleta
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-quant-fornec-produt NO-UNDO LIKE quant-fornec-produt
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-reposit NO-UNDO LIKE reposit
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0207 2.00.00.025 } /*** "010025" ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i {1} MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          {1}
&GLOBAL-DEFINE Version          2.00.00.025

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Produtor, Propriedades, Ptos Coleta, Reposit¢rios, NPR, Vol. Coleta

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        {2}
&GLOBAL-DEFINE CopyParent       NO
&GLOBAL-DEFINE UpdateParent     {2}
&GLOBAL-DEFINE DeleteParent     {2}

&GLOBAL-DEFINE AddSon1          NO
&GLOBAL-DEFINE CopySon1         NO
&GLOBAL-DEFINE UpdateSon1       NO
&GLOBAL-DEFINE DeleteSon1       NO

&GLOBAL-DEFINE AddSon2          {2}
&GLOBAL-DEFINE CopySon2         NO
&GLOBAL-DEFINE UpdateSon2       {2}
&GLOBAL-DEFINE DeleteSon2       {2}

&GLOBAL-DEFINE AddSon3          {2}
&GLOBAL-DEFINE CopySon3         NO
&GLOBAL-DEFINE UpdateSon3       {2}
&GLOBAL-DEFINE DeleteSon3       {2}

&GLOBAL-DEFINE AddSon4          {2}
&GLOBAL-DEFINE CopySon4         NO
&GLOBAL-DEFINE UpdateSon4       {2}
&GLOBAL-DEFINE DeleteSon4       {2}

&GLOBAL-DEFINE AddSon5          {2}
&GLOBAL-DEFINE CopySon5         NO
&GLOBAL-DEFINE UpdateSon5       {2}
&GLOBAL-DEFINE DeleteSon5       {2}

&GLOBAL-DEFINE AddSon6          {2}
&GLOBAL-DEFINE CopySon6         NO
&GLOBAL-DEFINE UpdateSon6       {2}
&GLOBAL-DEFINE DeleteSon6       {2}

&GLOBAL-DEFINE ttParent         tt-produt-rural
&GLOBAL-DEFINE hDBOParent       hDBOProdut-rural
&GLOBAL-DEFINE DBOParentTable   produt-rural
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon2           tt-propried-rural
&GLOBAL-DEFINE hDBOSon2         hDBOPropried-rural
&GLOBAL-DEFINE DBOSon2Table     propried-rural
&GLOBAL-DEFINE DBOSon2Destroy   YES

&GLOBAL-DEFINE ttSon3           tt-pto-coleta
&GLOBAL-DEFINE hDBOSon3         hDBOPto-coleta
&GLOBAL-DEFINE DBOSon3Table     pto-coleta
&GLOBAL-DEFINE DBOSon3Destroy   YES

&GLOBAL-DEFINE ttSon4           tt-reposit
&GLOBAL-DEFINE hDBOSon4         hDBOReposit
&GLOBAL-DEFINE DBOSon4Table     reposit
&GLOBAL-DEFINE DBOSon4Destroy   YES

&GLOBAL-DEFINE ttSon5           tt-nota-promis-rural
&GLOBAL-DEFINE hDBOSon5         hDBONota-promis-rural
&GLOBAL-DEFINE DBOSon5Table     nota-promis-rural
&GLOBAL-DEFINE DBOSon5Destroy   YES

&GLOBAL-DEFINE ttSon6           tt-quant-fornec-produt
&GLOBAL-DEFINE hDBOSon6         hDBOQuant-fornec-produt
&GLOBAL-DEFINE DBOSon6Table     quant-fornec-produt
&GLOBAL-DEFINE DBOSon6Destroy   YES

&GLOBAL-DEFINE page0Fields    tt-produt-rural.cdn-produt-rural ~
                              c-desc-produtor
&GLOBAL-DEFINE page1Fields    tt-produt-rural.cdn-grp-produt ~
                              tt-produt-rural.cod-cart-produt ~
                              tt-produt-rural.log-optan-incent ~
                              tt-produt-rural.cod-obs ~
                              tt-produt-rural.log-livre-1 ~
                              c-desc-grp-produtor

&GLOBAL-DEFINE page1Browse      
&GLOBAL-DEFINE page2Browse      brSon2
&GLOBAL-DEFINE page3Browse      brSon3
&GLOBAL-DEFINE page4Browse      brSon4
&GLOBAL-DEFINE page5Browse      brSon5
&GLOBAL-DEFINE page6Browse      brSon6  

&GLOBAL-DEFINE NumRowsReturned  100000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon3}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon4}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon5}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon6}   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00963   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00977   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00990   AS HANDLE NO-UNDO.

DEFINE VARIABLE c-regiao         LIKE pto-coleta.cod-regiao             NO-UNDO.
DEFINE VARIABLE c-cod-externo    LIKE produt-pto-coleta.cod-externo     NO-UNDO.
DEFINE VARIABLE c-cod-pto-coleta LIKE produt-pto-coleta.cod-pto-coleta  NO-UNDO.
DEFINE VARIABLE c-regiao-prop    AS CHARACTER                           NO-UNDO.
DEFINE VARIABlE l-consulta       AS LOGICAL                             NO-UNDO.

DEFINE VARIABLE h-aqapi005    AS HANDLE NO-UNDO.
DEFINE VARIABLE rRowid        AS ROWID   NO-UNDO.
DEFINE VARIABLE iSituacao     AS INTEGER NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE gr-produt-rural-aq0207 AS ROWID NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-propried-rural tt-pto-coleta tt-reposit ~
tt-nota-promis-rural tt-quant-fornec-produt

/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 tt-propried-rural.cod-propried ~
tt-propried-rural.des-propried tt-propried-rural.cod-regiao ~
fnRegiao(input fnRegiaoPropriedade(tt-propried-rural.cod-regiao)) @ c-regiao-prop ~
tt-propried-rural.log-livre-1 tt-propried-rural.cod-inscr-imob-rural ~
tt-propried-rural.cod-nrp tt-propried-rural.cod-entrega ~
tt-propried-rural.cod-rota-princ tt-propried-rural.log-propried-certif ~
tt-propried-rural.cod-orgao-sanit tt-propried-rural.log-entreg-pto-terc ~
fnCodExternoPropriedade(2, tt-propried-rural.cod-propried) @ c-cod-pto-coleta ~
fnCodExternoPropriedade(1, tt-propried-rural.cod-propried) @ c-cod-externo ~
tt-propried-rural.des-obs 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-propried-rural NO-LOCK
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH tt-propried-rural NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-propried-rural
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-propried-rural


/* Definitions for BROWSE brSon3                                        */
&Scoped-define FIELDS-IN-QUERY-brSon3 tt-pto-coleta.cod-pto-coleta ~
tt-pto-coleta.des-pto-coleta tt-pto-coleta.log-livre-1 ~
tt-pto-coleta.cod-propried ~
fnRegiaoPropriedade(tt-pto-coleta.cod-propried) @ tt-pto-coleta.cod-regiao ~
fnRegiao(input fnRegiaoPropriedade(tt-pto-coleta.cod-propried)) @ c-regiao ~
tt-pto-coleta.val-media tt-pto-coleta.cod-un tt-pto-coleta.qtd-distan-km ~
tt-pto-coleta.val-latitude tt-pto-coleta.val-longitude ~
tt-pto-coleta.des-obs ~
fnCodExterno( tt-pto-coleta.cod-pto-coleta, tt-pto-coleta.cod-propried) @ c-cod-externo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon3 
&Scoped-define QUERY-STRING-brSon3 FOR EACH tt-pto-coleta NO-LOCK
&Scoped-define OPEN-QUERY-brSon3 OPEN QUERY brSon3 FOR EACH tt-pto-coleta NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon3 tt-pto-coleta
&Scoped-define FIRST-TABLE-IN-QUERY-brSon3 tt-pto-coleta


/* Definitions for BROWSE brSon4                                        */
&Scoped-define FIELDS-IN-QUERY-brSon4 tt-reposit.cdn-repos ~
tt-reposit.des-reposit tt-reposit.cod-pto-coleta tt-reposit.log-livre-1 ~
tt-reposit.qtd-capac tt-reposit.cod-marca tt-reposit.cod-modelo ~
tt-reposit.cod-num-serie tt-reposit.cod-barras 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon4 
&Scoped-define QUERY-STRING-brSon4 FOR EACH tt-reposit NO-LOCK
&Scoped-define OPEN-QUERY-brSon4 OPEN QUERY brSon4 FOR EACH tt-reposit NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon4 tt-reposit
&Scoped-define FIRST-TABLE-IN-QUERY-brSon4 tt-reposit


/* Definitions for BROWSE brSon5                                        */
&Scoped-define FIELDS-IN-QUERY-brSon5 tt-nota-promis-rural.cod-num ~
tt-nota-promis-rural.dat-inic tt-nota-promis-rural.dat-fim ~
tt-nota-promis-rural.val-nota tt-nota-promis-rural.des-obs 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon5 
&Scoped-define QUERY-STRING-brSon5 FOR EACH tt-nota-promis-rural NO-LOCK
&Scoped-define OPEN-QUERY-brSon5 OPEN QUERY brSon5 FOR EACH tt-nota-promis-rural NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon5 tt-nota-promis-rural
&Scoped-define FIRST-TABLE-IN-QUERY-brSon5 tt-nota-promis-rural


/* Definitions for BROWSE brSon6                                        */
&Scoped-define FIELDS-IN-QUERY-brSon6 tt-quant-fornec-produt.it-codigo ~
tt-quant-fornec-produt.dat-inic tt-quant-fornec-produt.dat-fim ~
tt-quant-fornec-produt.qtd-fornec tt-quant-fornec-produt.cod-obs 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon6 
&Scoped-define QUERY-STRING-brSon6 FOR EACH tt-quant-fornec-produt NO-LOCK
&Scoped-define OPEN-QUERY-brSon6 OPEN QUERY brSon6 FOR EACH tt-quant-fornec-produt NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon6 tt-quant-fornec-produt
&Scoped-define FIRST-TABLE-IN-QUERY-brSon6 tt-quant-fornec-produt


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brSon3}

/* Definitions for FRAME fPage4                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage4 ~
    ~{&OPEN-QUERY-brSon4}

/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-brSon5}

/* Definitions for FRAME fPage6                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage6 ~
    ~{&OPEN-QUERY-brSon6}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-produt-rural.cdn-produt-rural 
&Scoped-define ENABLED-TABLES tt-produt-rural
&Scoped-define FIRST-ENABLED-TABLE tt-produt-rural
&Scoped-Define ENABLED-OBJECTS rtToolBar rtParent btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btUpdate btDelete btQueryJoins btReportsJoins ~
btExit btHelp c-desc-produtor 
&Scoped-Define DISPLAYED-FIELDS tt-produt-rural.cdn-produt-rural 
&Scoped-define DISPLAYED-TABLES tt-produt-rural
&Scoped-define FIRST-DISPLAYED-TABLE tt-produt-rural
&Scoped-Define DISPLAYED-OBJECTS c-desc-produtor 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCodExterno wMasterDetail 
FUNCTION fnCodExterno RETURNS CHARACTER
  (pc-cod-pto-coleta AS CHAR,  pc-cod-propried AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCodExternoPropriedade wMasterDetail 
FUNCTION fnCodExternoPropriedade RETURNS CHARACTER
  ( i-retorno AS INT, pc-cod-propried AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRegiao wMasterDetail 
FUNCTION fnRegiao RETURNS CHARACTER
  ( input ccod-regiao as CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRegiaoPropriedade wMasterDetail 
FUNCTION fnRegiaoPropriedade RETURNS CHARACTER
  ( pc-cod-propried AS CHAR )  FORWARD.

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
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
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
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Add" 
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

DEFINE VARIABLE c-desc-produtor AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE c-desc-grp-produtor AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.14 BY .88 NO-UNDO.

DEFINE BUTTON btAddSon2 
     LABEL "&Incluir" 
     SIZE 10 BY 1 TOOLTIP "Incluir".

DEFINE BUTTON btDeleteSon2 
     LABEL "&Eliminar" 
     SIZE 10 BY 1 TOOLTIP "Eliminar".

DEFINE BUTTON btDetalhar 
     LABEL "Detalhar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon2 
     LABEL "&Alterar" 
     SIZE 10 BY 1 TOOLTIP "Alterar".

DEFINE BUTTON btAddSon3 
     LABEL "&Incluir" 
     SIZE 10 BY 1 TOOLTIP "Incluir".

DEFINE BUTTON btDeleteSon3 
     LABEL "&Eliminar" 
     SIZE 10 BY 1 TOOLTIP "Eliminar".

DEFINE BUTTON btDetalhar2 
     LABEL "Detalhar" 
     SIZE 10 BY 1.

DEFINE BUTTON btMapaRota
     LABEL "&Mapa" 
     SIZE 10 BY 1 TOOLTIP "Eliminar".

DEFINE BUTTON btUpdateSon3 
     LABEL "&Alterar" 
     SIZE 10 BY 1 TOOLTIP "Alterar".

DEFINE BUTTON btAddSon4 
     LABEL "&Incluir" 
     SIZE 10 BY 1 TOOLTIP "Incluir".

DEFINE BUTTON btDeleteSon4 
     LABEL "&Eliminar" 
     SIZE 10 BY 1 TOOLTIP "Eliminar".

DEFINE BUTTON btUpdateSon4 
     LABEL "&Alterar" 
     SIZE 10 BY 1 TOOLTIP "Alterar".

DEFINE BUTTON btAddSon5 
     LABEL "&Incluir" 
     SIZE 10 BY 1 TOOLTIP "Incluir".

DEFINE BUTTON btDeleteSon5 
     LABEL "&Eliminar" 
     SIZE 10 BY 1 TOOLTIP "Eliminar".

DEFINE BUTTON btUpdateSon5 
     LABEL "&Alterar" 
     SIZE 10 BY 1 TOOLTIP "Alterar".

DEFINE BUTTON btAddSon6 
     LABEL "&Incluir" 
     SIZE 10 BY 1 TOOLTIP "Incluir".

DEFINE BUTTON btDeleteSon6 
     LABEL "&Eliminar" 
     SIZE 10 BY 1 TOOLTIP "Eliminar".

DEFINE BUTTON btUpdateSon6 
     LABEL "&Aterar" 
     SIZE 10 BY 1 TOOLTIP "Alterar".

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon2 FOR 
      tt-propried-rural SCROLLING.

DEFINE QUERY brSon3 FOR 
      tt-pto-coleta SCROLLING.

DEFINE QUERY brSon4 FOR 
      tt-reposit SCROLLING.

DEFINE QUERY brSon5 FOR 
      tt-nota-promis-rural SCROLLING.

DEFINE QUERY brSon6 FOR 
      tt-quant-fornec-produt SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _STRUCTURED
  QUERY brSon2 NO-LOCK DISPLAY
      tt-propried-rural.cod-propried FORMAT "x(16)":U
      tt-propried-rural.des-propried FORMAT "x(60)":U WIDTH 16
      tt-propried-rural.cod-regiao FORMAT "x(12)":U WIDTH 16
      fnRegiao(tt-propried-rural.cod-regiao) @ c-regiao-prop COLUMN-LABEL "Descri‡Æo" FORMAT "X(60)":U
            WIDTH 27.29
      tt-propried-rural.log-livre-1 COLUMN-LABEL "Ativo" FORMAT "Sim/NÆo":U
      tt-propried-rural.cod-inscr-imob-rural FORMAT "x(19)":U
      tt-propried-rural.cod-nrp FORMAT "x(20)":U
      tt-propried-rural.cod-entrega FORMAT "x(12)":U
      tt-propried-rural.cod-rota-princ FORMAT "x(12)":U
      tt-propried-rural.log-propried-certif FORMAT "Sim/NÆo":U
      tt-propried-rural.cod-orgao-sanit FORMAT "x(30)":U
      tt-propried-rural.log-entreg-pto-terc FORMAT "Sim/NÆo":U
            WIDTH 11.57
      fnCodExternoPropriedade(2, tt-propried-rural.cod-propried) @ c-cod-pto-coleta COLUMN-LABEL "Pto Coleta Entrega" FORMAT "X(12)":U
            WIDTH 15
      fnCodExternoPropriedade(1, tt-propried-rural.cod-propried) @ c-cod-externo COLUMN-LABEL "C¢d Externo" FORMAT "X(14)":U
      tt-propried-rural.des-obs FORMAT "x(60)":U WIDTH 40
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.33
         FONT 2.

DEFINE BROWSE brSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon3 wMasterDetail _STRUCTURED
  QUERY brSon3 NO-LOCK DISPLAY
      tt-pto-coleta.cod-pto-coleta FORMAT "x(12)":U
      tt-pto-coleta.des-pto-coleta FORMAT "x(40)":U
      tt-pto-coleta.log-livre-1 COLUMN-LABEL "Ativo" FORMAT "Sim/NÆo":U
      tt-pto-coleta.cod-propried FORMAT "x(16)":U WIDTH 10
      fnRegiaoPropriedade(tt-pto-coleta.cod-propried) @ tt-pto-coleta.cod-regiao COLUMN-LABEL "RegiÆo"
      fnRegiao(input fnRegiaoPropriedade(tt-pto-coleta.cod-propried)) @ c-regiao COLUMN-LABEL "Descri‡Æo" FORMAT "X(60)":U
      tt-pto-coleta.val-media FORMAT "->>,>>>,>>9.9999":U
      tt-pto-coleta.cod-un FORMAT "x(2)":U
      tt-pto-coleta.qtd-distan-km FORMAT ">>>,>>>,>>9.99":U
      tt-pto-coleta.val-latitude FORMAT "->>9.9999999":U
      tt-pto-coleta.val-longitude FORMAT "->>9.9999999":U
      tt-pto-coleta.des-obs FORMAT "x(60)":U
      fnCodExterno( tt-pto-coleta.cod-pto-coleta, tt-pto-coleta.cod-propried) @ c-cod-externo COLUMN-LABEL "C¢d Externo" FORMAT "x(14)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.33
         FONT 2.

DEFINE BROWSE brSon4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon4 wMasterDetail _STRUCTURED
  QUERY brSon4 NO-LOCK DISPLAY
      tt-reposit.cdn-repos FORMAT ">>>,>>9":U
      tt-reposit.des-reposit FORMAT "x(40)":U WIDTH 30.86
      tt-reposit.cod-pto-coleta FORMAT "x(12)":U WIDTH 14
      tt-reposit.log-livre-1 COLUMN-LABEL "Ativo" FORMAT "Sim/NÆo":U
      tt-reposit.qtd-capac FORMAT ">>>>,>>>,>>9.9999":U WIDTH 18
      tt-reposit.cod-marca FORMAT "x(40)":U
      tt-reposit.cod-modelo FORMAT "x(40)":U
      tt-reposit.cod-num-serie FORMAT "x(40)":U
      tt-reposit.cod-barras FORMAT "x(50)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.33
         FONT 2 FIT-LAST-COLUMN.

DEFINE BROWSE brSon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon5 wMasterDetail _STRUCTURED
  QUERY brSon5 NO-LOCK DISPLAY
      tt-nota-promis-rural.cod-num COLUMN-LABEL "NPR" FORMAT "x(16)":U
      tt-nota-promis-rural.dat-inic FORMAT "99/99/9999":U WIDTH 11.43
      tt-nota-promis-rural.dat-fim FORMAT "99/99/9999":U WIDTH 13.43
      tt-nota-promis-rural.val-nota FORMAT ">>>>,>>>,>>>,>>9.99":U
      tt-nota-promis-rural.des-obs FORMAT "x(60)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.33
         FONT 2.

DEFINE BROWSE brSon6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon6 wMasterDetail _STRUCTURED
  QUERY brSon6 NO-LOCK DISPLAY
      tt-quant-fornec-produt.it-codigo FORMAT "x(16)":U
      tt-quant-fornec-produt.dat-inic FORMAT "99/99/9999":U
      tt-quant-fornec-produt.dat-fim COLUMN-LABEL "Data Fim" FORMAT "99/99/9999":U
      tt-quant-fornec-produt.qtd-fornec FORMAT ">>>,>>>>,>>>,>>9.9999":U
      tt-quant-fornec-produt.cod-obs FORMAT "X(60)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.33
         FONT 2.


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
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrˆncia"
     btUpdate AT ROW 1.13 COL 35 HELP
          "Altera ocorrˆncia corrente"
     btDelete AT ROW 1.13 COL 39 HELP
          "Elimina ocorrˆncia corrente"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-produt-rural.cdn-produt-rural AT ROW 2.88 COL 21.86 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     c-desc-produtor AT ROW 2.88 COL 33.72 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     rtToolBar AT ROW 1 COL 1
     rtParent AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage3
     brSon3 AT ROW 1.17 COL 2
     btAddSon3 AT ROW 11.58 COL 2
     btUpdateSon3 AT ROW 11.58 COL 12
     btDeleteSon3 AT ROW 11.58 COL 22
     btDetalhar2 AT ROW 11.58 COL 64 WIDGET-ID 2
     btMapaRota AT ROW 11.58 COL 74.14 WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5.25
         SIZE 84.43 BY 11.75
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fPage4
     brSon4 AT ROW 1.17 COL 2
     btAddSon4 AT ROW 11.58 COL 2
     btUpdateSon4 AT ROW 11.58 COL 12
     btDeleteSon4 AT ROW 11.58 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5.25
         SIZE 84.43 BY 11.75
         FONT 1 WIDGET-ID 300.

DEFINE FRAME fPage1
     tt-produt-rural.cdn-grp-produt AT ROW 3.25 COL 24.14 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 7.57 BY .88
     c-desc-grp-produtor AT ROW 3.25 COL 31.86 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     tt-produt-rural.cod-cart-produt AT ROW 4.25 COL 24.14 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     tt-produt-rural.log-optan-incent AT ROW 5.25 COL 26.29 WIDGET-ID 10
          LABEL "Optante Programa Incentivo"
          VIEW-AS TOGGLE-BOX
          SIZE 23 BY .83
     tt-produt-rural.log-livre-1 AT ROW 6.25 COL 26.29 HELP
          "L¢gico Livre 1" WIDGET-ID 14
          LABEL "Ativo"
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .83
     tt-produt-rural.cod-obs AT ROW 7.25 COL 26.14 NO-LABEL WIDGET-ID 8
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 42.14 BY 4
     "Observa‡Æo:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 7.25 COL 17 WIDGET-ID 12
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5.25
         SIZE 84.43 BY 11.75
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage5
     brSon5 AT ROW 1.17 COL 2
     btAddSon5 AT ROW 11.58 COL 2
     btUpdateSon5 AT ROW 11.58 COL 12
     btDeleteSon5 AT ROW 11.58 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5.25
         SIZE 84.43 BY 11.75
         FONT 1 WIDGET-ID 400.

DEFINE FRAME fPage6
     brSon6 AT ROW 1.17 COL 2
     btAddSon6 AT ROW 11.58 COL 2
     btUpdateSon6 AT ROW 11.58 COL 12
     btDeleteSon6 AT ROW 11.58 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5.25
         SIZE 84.43 BY 11.75
         FONT 1 WIDGET-ID 500.

DEFINE FRAME fPage2
     brSon2 AT ROW 1.17 COL 2
     btAddSon2 AT ROW 11.58 COL 2
     btUpdateSon2 AT ROW 11.58 COL 12
     btDeleteSon2 AT ROW 11.58 COL 22
     btDetalhar AT ROW 11.58 COL 73.86 WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5.25
         SIZE 84.43 BY 11.75
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-nota-promis-rural T "?" NO-UNDO mgind nota-promis-rural
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-produt-rural T "?" NO-UNDO mgind produt-rural
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-propried-rural T "?" NO-UNDO mgind propried-rural
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-pto-coleta T "?" NO-UNDO mgind pto-coleta
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-quant-fornec-produt T "?" NO-UNDO movind quant-fornec-produt
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-reposit T "?" NO-UNDO mgind reposit
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
       FRAME fPage3:FRAME = FRAME fPage0:HANDLE
       FRAME fPage4:FRAME = FRAME fPage0:HANDLE
       FRAME fPage5:FRAME = FRAME fPage0:HANDLE
       FRAME fPage6:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR TOGGLE-BOX tt-produt-rural.log-livre-1 IN FRAME fPage1
   EXP-LABEL EXP-HELP                                                   */
/* SETTINGS FOR TOGGLE-BOX tt-produt-rural.log-optan-incent IN FRAME fPage1
   EXP-LABEL                                                            */
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

/* SETTINGS FOR FRAME fPage4
                                                                        */
/* BROWSE-TAB brSon4 1 fPage4 */
ASSIGN 
       brSon4:COLUMN-RESIZABLE IN FRAME fPage4       = TRUE
       brSon4:COLUMN-MOVABLE IN FRAME fPage4         = TRUE.

/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brSon5 1 fPage5 */
ASSIGN 
       brSon5:COLUMN-RESIZABLE IN FRAME fPage5       = TRUE
       brSon5:COLUMN-MOVABLE IN FRAME fPage5         = TRUE.

/* SETTINGS FOR FRAME fPage6
                                                                        */
/* BROWSE-TAB brSon6 1 fPage6 */
ASSIGN 
       brSon6:COLUMN-RESIZABLE IN FRAME fPage6       = TRUE
       brSon6:COLUMN-MOVABLE IN FRAME fPage6         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.tt-propried-rural"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-propried-rural.cod-propried
     _FldNameList[2]   > Temp-Tables.tt-propried-rural.des-propried
"des-propried" ? ? "character" ? ? ? ? ? ? no ? no no "16" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-propried-rural.cod-regiao
"cod-regiao" ? ? "character" ? ? ? ? ? ? no ? no no "16" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fnRegiao(input fnRegiaoPropriedade(tt-propried-rural.cod-regiao)) @ c-regiao-prop" "Descri‡Æo" "X(60)" ? ? ? ? ? ? ? no ? no no "27.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-propried-rural.log-livre-1
"log-livre-1" "Ativo" ? "logical" ? ? ? ? ? ? no "Indica se a propriedade est  ativa" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.tt-propried-rural.cod-inscr-imob-rural
     _FldNameList[7]   = Temp-Tables.tt-propried-rural.cod-nrp
     _FldNameList[8]   = Temp-Tables.tt-propried-rural.cod-entrega
     _FldNameList[9]   = Temp-Tables.tt-propried-rural.cod-rota-princ
     _FldNameList[10]   = Temp-Tables.tt-propried-rural.log-propried-certif
     _FldNameList[11]   = Temp-Tables.tt-propried-rural.cod-orgao-sanit
     _FldNameList[12]   > Temp-Tables.tt-propried-rural.log-entreg-pto-terc
"log-entreg-pto-terc" ? ? "logical" ? ? ? ? ? ? no "Propriedade entrega em ponto de terceiro" no no "11.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"fnCodExternoPropriedade(2, tt-propried-rural.cod-propried) @ c-cod-pto-coleta" "Pto Coleta Entrega" "X(12)" ? ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"fnCodExternoPropriedade(1, tt-propried-rural.cod-propried) @ c-cod-externo" "C¢d Externo" "X(14)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.tt-propried-rural.des-obs
"des-obs" ? "x(60)" "character" ? ? ? ? ? ? no ? no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon3
/* Query rebuild information for BROWSE brSon3
     _TblList          = "Temp-Tables.tt-pto-coleta"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-pto-coleta.cod-pto-coleta
     _FldNameList[2]   = Temp-Tables.tt-pto-coleta.des-pto-coleta
     _FldNameList[3]   > Temp-Tables.tt-pto-coleta.log-livre-1
"tt-pto-coleta.log-livre-1" "Ativo" ? "logical" ? ? ? ? ? ? no "Informa se o ponto de coleta est  ativo" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-pto-coleta.cod-propried
"tt-pto-coleta.cod-propried" ? ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fnRegiaoPropriedade(tt-pto-coleta.cod-propried) @ tt-pto-coleta.cod-regiao" "RegiÆo" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fnRegiao(input fnRegiaoPropriedade(tt-pto-coleta.cod-propried)) @ c-regiao" "Descri‡Æo" "X(60)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.tt-pto-coleta.val-media
     _FldNameList[8]   = Temp-Tables.tt-pto-coleta.cod-un
     _FldNameList[9]   = Temp-Tables.tt-pto-coleta.qtd-distan-km
     _FldNameList[10]   = Temp-Tables.tt-pto-coleta.val-latitude
     _FldNameList[11]   = Temp-Tables.tt-pto-coleta.val-longitude
     _FldNameList[12]   > Temp-Tables.tt-pto-coleta.des-obs
"tt-pto-coleta.des-obs" ? "x(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"fnCodExterno( tt-pto-coleta.cod-pto-coleta, tt-pto-coleta.cod-propried) @ c-cod-externo" "C¢d Externo" "x(14)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon4
/* Query rebuild information for BROWSE brSon4
     _TblList          = "Temp-Tables.tt-reposit"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-reposit.cdn-repos
     _FldNameList[2]   > Temp-Tables.tt-reposit.des-reposit
"tt-reposit.des-reposit" ? ? "character" ? ? ? ? ? ? no ? no no "30.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-reposit.cod-pto-coleta
"tt-reposit.cod-pto-coleta" ? ? "character" ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-reposit.log-livre-1
"tt-reposit.log-livre-1" "Ativo" ? "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-reposit.qtd-capac
"tt-reposit.qtd-capac" ? ? "decimal" ? ? ? ? ? ? no ? no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.tt-reposit.cod-marca
     _FldNameList[7]   = Temp-Tables.tt-reposit.cod-modelo
     _FldNameList[8]   = Temp-Tables.tt-reposit.cod-num-serie
     _FldNameList[9]   = Temp-Tables.tt-reposit.cod-barras
     _Query            is OPENED
*/  /* BROWSE brSon4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon5
/* Query rebuild information for BROWSE brSon5
     _TblList          = "Temp-Tables.tt-nota-promis-rural"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-nota-promis-rural.cod-num
"tt-nota-promis-rural.cod-num" "NPR" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-nota-promis-rural.dat-inic
"tt-nota-promis-rural.dat-inic" ? ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-nota-promis-rural.dat-fim
"tt-nota-promis-rural.dat-fim" ? ? "date" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.tt-nota-promis-rural.val-nota
     _FldNameList[5]   > Temp-Tables.tt-nota-promis-rural.des-obs
"tt-nota-promis-rural.des-obs" ? "x(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon6
/* Query rebuild information for BROWSE brSon6
     _TblList          = "Temp-Tables.tt-quant-fornec-produt"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-quant-fornec-produt.it-codigo
     _FldNameList[2]   = Temp-Tables.tt-quant-fornec-produt.dat-inic
     _FldNameList[3]   > Temp-Tables.tt-quant-fornec-produt.dat-fim
"tt-quant-fornec-produt.dat-fim" "Data Fim" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.tt-quant-fornec-produt.qtd-fornec
     _FldNameList[5]   > Temp-Tables.tt-quant-fornec-produt.cod-obs
"tt-quant-fornec-produt.cod-obs" ? "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon6 */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage5
/* Query rebuild information for FRAME fPage5
     _Query            is NOT OPENED
*/  /* FRAME fPage5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
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


&Scoped-define BROWSE-NAME brSon2
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon2 wMasterDetail
ON ROW-DISPLAY OF brSon2 IN FRAME fPage2
DO:
  IF AVAIL tt-propried-rural THEN DO:
        {utp/ut-liter.i Sim/NÆo *}
        ASSIGN tt-propried-rural.log-propried-certif:FORMAT IN BROWSE brSon2 = RETURN-VALUE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMasterDetail
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd IN MENU mbMain DO:
    IF NOT l-consulta THEN
        RUN addRecord IN THIS-PROCEDURE (INPUT "aqp/aq0207a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btAddSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon2 wMasterDetail
ON CHOOSE OF btAddSon2 IN FRAME fPage2 /* Incluir */
DO:

    DEF VAR r-rowid AS ROWID NO-UNDO.

    {masterdetail/addson.i &ProgramSon="aqp/aq0207b.w"
                           &PageNumber="2"}
                           
    WAIT-FOR "CLOSE":U OF hSonProgram.

    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOParent} (OUTPUT r-rowid).

    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowid).

    APPLY "VALUE-CHANGED" TO brSon2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btAddSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon3 wMasterDetail
ON CHOOSE OF btAddSon3 IN FRAME fPage3 /* Incluir */
DO:
                               
    DEF VAR r-rowid AS ROWID NO-UNDO.

    {masterdetail/addson.i &ProgramSon="aqp/aq0207c.w"
                           &PageNumber="3"}
                           
    WAIT-FOR "CLOSE":U OF hSonProgram.

    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOParent} (OUTPUT r-rowid).

    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowid).

    APPLY "VALUE-CHANGED" TO brSon3.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btAddSon4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon4 wMasterDetail
ON CHOOSE OF btAddSon4 IN FRAME fPage4 /* Incluir */
DO:
    
    DEF VAR r-rowid AS ROWID NO-UNDO.

    {masterdetail/addson.i &ProgramSon="aqp/aq0207d.w"
                           &PageNumber="4"}
                           
    WAIT-FOR "CLOSE":U OF hSonProgram.

    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOParent} (OUTPUT r-rowid).

    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowid).

    APPLY "VALUE-CHANGED" TO brSon4.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btAddSon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon5 wMasterDetail
ON CHOOSE OF btAddSon5 IN FRAME fPage5 /* Incluir */
DO:
    
    DEF VAR r-rowid AS ROWID NO-UNDO.

    {masterdetail/addson.i &ProgramSon="aqp/aq0208a.w"
                           &PageNumber="5"}
                           
    WAIT-FOR "CLOSE":U OF hSonProgram.

    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOParent} (OUTPUT r-rowid).

    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowid).

    APPLY "VALUE-CHANGED" TO brSon5.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btAddSon6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon6 wMasterDetail
ON CHOOSE OF btAddSon6 IN FRAME fPage6 /* Incluir */
DO:
  
    DEF VAR r-rowid AS ROWID NO-UNDO.

    {masterdetail/addson.i &ProgramSon="aqp/aq0207e.w"
                           &PageNumber="6"}
                         
   WAIT-FOR "CLOSE":U OF hSonProgram.

    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOParent} (OUTPUT r-rowid).

    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowid).

    APPLY "VALUE-CHANGED" TO brSon6.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMasterDetail
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    IF NOT l-consulta THEN
        RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDeleteSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon2 wMasterDetail
ON CHOOSE OF btDeleteSon2 IN FRAME fPage2 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="2"}
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btDeleteSon4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon4 wMasterDetail
ON CHOOSE OF btDeleteSon4 IN FRAME fPage4 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="4"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btDeleteSon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon5 wMasterDetail
ON CHOOSE OF btDeleteSon5 IN FRAME fPage5 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="5"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btDeleteSon6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon6 wMasterDetail
ON CHOOSE OF btDeleteSon6 IN FRAME fPage6 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="6"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDetalhar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhar wMasterDetail
ON CHOOSE OF btDetalhar IN FRAME fPage2 /* Detalhar */
DO:
   DEFINE VARIABLE c-cod-propried AS CHARACTER  INITIAL ? NO-UNDO.

    DEFINE VARIABLE h-prog-desp AS HANDLE NO-UNDO.

    IF CAN-FIND(FIRST tt-propried-rural) THEN DO:

       REPOSITION brSon2 TO ROW brSon2:FOCUSED-ROW IN FRAME fPage2 NO-ERROR.

       IF AVAIL tt-propried-rural THEN
           ASSIGN c-cod-propried = tt-propried-rural.cod-propried.

    END.       
    
    SESSION:SET-WAIT-STATE("general":U).
    RUN aqp/aq0409.w PERSISTENT SET h-prog-desp.
    IF VALID-HANDLE(h-prog-desp) THEN DO:
        RUN set-cod-propried IN h-prog-desp(INPUT c-cod-propried).
        RUN initializeInterface IN h-prog-desp.
        SESSION:SET-WAIT-STATE("":U).         
        WAIT-FOR CLOSE OF h-prog-desp FOCUS CURRENT-WINDOW.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btDetalhar2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhar2 wMasterDetail
ON CHOOSE OF btDetalhar2 IN FRAME fPage3 /* Detalhar */
DO:
   DEFINE VARIABLE c-cod-pto-coleta AS CHARACTER  INITIAL ? NO-UNDO.

    DEFINE VARIABLE h-prog-desp AS HANDLE NO-UNDO.

    IF CAN-FIND(FIRST tt-pto-coleta) THEN DO:
       REPOSITION brSon3 TO ROW brSon3:FOCUSED-ROW IN FRAME fPage3 NO-ERROR.
       IF AVAIL tt-pto-coleta THEN
           ASSIGN c-cod-pto-coleta = tt-pto-coleta.cod-pto-coleta.
    END.
    
    SESSION:SET-WAIT-STATE("general":U).
    RUN aqp/aq0405.w PERSISTENT SET h-prog-desp.
    IF VALID-HANDLE(h-prog-desp) THEN DO:
        RUN set-cod-pto-coleta  IN h-prog-desp(INPUT c-cod-pto-coleta).
        RUN initializeInterface IN h-prog-desp.
        SESSION:SET-WAIT-STATE("":U).         
        WAIT-FOR CLOSE OF h-prog-desp FOCUS CURRENT-WINDOW.
    END.
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


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btMapaRota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMapaRota wMasterDetail
ON CHOOSE OF btMapaRota IN FRAME fPage3 /* Mapa */
DO:

    IF VALID-HANDLE ({&hDBOSon3}) AND AVAIL tt-pto-coleta THEN DO:

        RUN emptyRowErrors IN ({&hDBOSon3}).

        RUN mostraMapa IN {&hDBOSon3}(INPUT tt-pto-coleta.cod-pto-coleta).

        IF RETURN-VALUE = "NOK":U THEN DO:

            RUN getRowErrors IN ({&hDBOSon3}) (OUTPUT TABLE RowErrors).

            FOR EACH RowErrors WHERE RowErrors.ErrorType = "INTERNAL":U EXCLUSIVE-LOCK:
                DELETE RowErrors.
            END.
            IF CAN-FIND (FIRST RowErrors) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal="YES"}

                EMPTY TEMP-TABLE RowErrors.

            END.
        END.

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
    {method/zoomreposition.i &ProgramZoom="inzoom/z01in00962.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMasterDetail
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    IF NOT l-consulta THEN
        RUN updateRecord IN THIS-PROCEDURE (INPUT "aqp/aq0207a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btUpdateSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon2 wMasterDetail
ON CHOOSE OF btUpdateSon2 IN FRAME fPage2 /* Alterar */
DO:
    
    DEF VAR r-rowid AS ROWID NO-UNDO.

    {masterdetail/updateson.i &ProgramSon="aqp/aq0207b.w"
                              &PageNumber="2"}
                           
    WAIT-FOR "CLOSE":U OF hSonProgram.

    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOParent} (OUTPUT r-rowid).

    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowid).

    APPLY "VALUE-CHANGED" TO brSon2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btUpdateSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon3 wMasterDetail
ON CHOOSE OF btUpdateSon3 IN FRAME fPage3 /* Alterar */
DO:
    DEF VAR r-rowid AS ROWID NO-UNDO.

    {masterdetail/updateson.i &ProgramSon="aqp/aq0207c.w"
                              &PageNumber="3"}
                           
    WAIT-FOR "CLOSE":U OF hSonProgram.

    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOParent} (OUTPUT r-rowid).

    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowid).

    APPLY "VALUE-CHANGED" TO brSon3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btUpdateSon4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon4 wMasterDetail
ON CHOOSE OF btUpdateSon4 IN FRAME fPage4 /* Alterar */
DO:
    DEF VAR r-rowid AS ROWID NO-UNDO.

    {masterdetail/updateson.i &ProgramSon="aqp/aq0207d.w"
                              &PageNumber="4"}
                           
    WAIT-FOR "CLOSE":U OF hSonProgram.

    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOParent} (OUTPUT r-rowid).

    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowid).

    APPLY "VALUE-CHANGED" TO brSon4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btUpdateSon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon5 wMasterDetail
ON CHOOSE OF btUpdateSon5 IN FRAME fPage5 /* Alterar */
DO:
    DEF VAR r-rowid AS ROWID NO-UNDO.

    {masterdetail/updateson.i &ProgramSon="aqp/aq0208a.w"
                           &PageNumber="5"}
                           
    WAIT-FOR "CLOSE":U OF hSonProgram.

    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOParent} (OUTPUT r-rowid).

    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowid).

    APPLY "VALUE-CHANGED" TO brSon5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btUpdateSon6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon6 wMasterDetail
ON CHOOSE OF btUpdateSon6 IN FRAME fPage6 /* Aterar */
DO:
   DEF VAR r-rowid AS ROWID NO-UNDO.

  {masterdetail/updateson.i &ProgramSon="aqp/aq0207e.w"
                            &PageNumber="6"}
                         
  WAIT-FOR "CLOSE":U OF hSonProgram.

  /*:T Retorna rowid do registro corrente do DBO */
  RUN getRowid IN {&hDBOParent} (OUTPUT r-rowid).

  /*:T Reposiciona registro com base em um rowid */
  RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowid).

  APPLY "VALUE-CHANGED" TO brSon6. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-produt-rural.cdn-grp-produt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-rural.cdn-grp-produt wMasterDetail
ON LEAVE OF tt-produt-rural.cdn-grp-produt IN FRAME fPage1 /* Grupo Produtor */
DO:
  {method/referenceFields.i
              &HandleDBOLeave="h-boin00963"
              &KeyValue1="tt-produt-rural.cdn-grp-produt:screen-value in frame fPage1"
              &FieldName1="des-grp-produt"
              &FieldScreen1="c-desc-grp-produtor"
              &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME tt-produt-rural.cdn-produt-rural
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-rural.cdn-produt-rural wMasterDetail
ON LEAVE OF tt-produt-rural.cdn-produt-rural IN FRAME fPage0 /* Produtor Rural */
DO:
    DEF VAR c-nome-emit  LIKE emitente.nome-emit NO-UNDO.
    DEF VAR c-return     AS CHAR   NO-UNDO.
    DEF VAR h-boad098    AS HANDLE NO-UNDO.

    ASSIGN c-desc-produtor:SCREEN-VALUE   = "":U.

    IF INPUT FRAME fpage0 tt-produt-rural.cdn-produt-rural <> 0 THEN DO:
        ASSIGN INPUT FRAME fpage0 tt-produt-rural.cdn-produt-rural.
        RUN adbo/boad098.p PERSISTENT SET h-boad098.        
        RUN findCodigo IN h-boad098(INPUT tt-produt-rural.cdn-produt-rural, OUTPUT c-return).
        IF c-return = "":U THEN DO:
            RUN getCharfield IN h-boad098(INPUT "nome-emit", OUTPUT c-nome-emit).
            ASSIGN c-desc-produtor:SCREEN-VALUE = c-nome-emit.
        END. 
        DELETE PROCEDURE h-boad098. 
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMasterDetail
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{masterdetail/mainblock.i}

/* Sobrescrita das triggers para evitar erro de rolagem
   do browse em Oracle */
ON OFF-END OF brSon2 IN FRAME fPage2
DO:
END.

ON OFF-HOME OF brSon2 IN FRAME fPage2
DO:
END.

/*desabilita btupdate caso propriedade esteja inativa*/
ON VALUE-CHANGED OF brSon3 IN FRAME fPage3
DO:

    IF VALID-HANDLE ({&hDBOSon2}) AND AVAIL tt-pto-coleta THEN DO:

        RUN goToKey IN {&hDBOSon2}(INPUT tt-pto-coleta.cod-propried).

        RUN getRowid IN {&hDBOSon2} (OUTPUT rRowid).

        RUN piInicial IN h-aqapi005 (INPUT  "consultar":U,
                                     INPUT  "propriedade":U,
                                     INPUT  rRowid,
                                     OUTPUT iSituacao,
                                     INPUT-OUTPUT TABLE rowErrors).

        ASSIGN btUpdateSon3:SENSITIVE IN FRAME fPage3 = iSituacao = 1.

    END.
    
    ASSIGN btMapaRota:SENSITIVE IN FRAME fPage3 = AVAIL tt-pto-coleta.

END.

/*desabilita btupdate caso produtor esteja inativo*/
ON VALUE-CHANGED OF brSon2 IN FRAME fPage2
DO:

    IF VALID-HANDLE ({&hDBOParent}) AND AVAIL tt-propried-rural THEN DO:

        RUN goToKey IN {&hDBOParent}(INPUT tt-propried-rural.cdn-produt-rural).

        RUN getRowid IN {&hDBOParent} (OUTPUT rRowid).

        RUN piInicial IN h-aqapi005 (INPUT  "consultar":U,
                                     INPUT  "produtor":U,
                                     INPUT  rRowid,
                                     OUTPUT iSituacao,
                                     INPUT-OUTPUT TABLE rowErrors).

        ASSIGN btUpdateSon2:SENSITIVE IN FRAME fPage2 = iSituacao = 1.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestoyInterface wMasterDetail 
PROCEDURE afterDestoyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(h-boin00963) THEN DO:
       DELETE PROCEDURE h-boin00963.
       ASSIGN h-boin00963 = ?.
    END.

    IF VALID-HANDLE(h-boin00977) THEN DO:
       DELETE PROCEDURE h-boin00977.
       ASSIGN h-boin00977 = ?.
    END.
 
    IF VALID-HANDLE(h-boin00990) THEN DO:
       DELETE PROCEDURE h-boin00990.
       ASSIGN h-boin00990 = ?.
    END. 

    IF VALID-HANDLE(h-aqapi005) THEN DO:
       DELETE PROCEDURE h-aqapi005.
       ASSIGN h-aqapi005 = ?.
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

    APPLY "LEAVE" TO tt-produt-rural.cdn-produt-rural IN FRAME fpage0.

    IF  AVAIL tt-produt-rural THEN DO:
        ASSIGN tt-produt-rural.cod-obs         :SCREEN-VALUE IN FRAME fPage1 = tt-produt-rural.cod-obs
               tt-produt-rural.cdn-grp-produt  :SCREEN-VALUE IN FRAME fPage1 = STRING(tt-produt-rural.cdn-grp-produt)
               tt-produt-rural.cod-cart-produt :SCREEN-VALUE IN FRAME fPage1 = tt-produt-rural.cod-cart-produt
               tt-produt-rural.log-optan-incent:CHECKED      IN FRAME fPage1 = tt-produt-rural.log-optan-incent
               tt-produt-rural.log-livre-1:CHECKED           IN FRAME fPage1 = tt-produt-rural.log-livre-1.
        APPLY "LEAVE" TO tt-produt-rural.cdn-grp-produt   IN FRAME fpage1.

    END.
    ELSE DO:
        EMPTY TEMP-TABLE tt-propried-rural.
        EMPTY TEMP-TABLE tt-pto-coleta.
        EMPTY TEMP-TABLE tt-nota-promis-rural.
        ASSIGN tt-produt-rural.cod-obs         :SCREEN-VALUE IN FRAME fPage1 = ""
               tt-produt-rural.cdn-grp-produt  :SCREEN-VALUE IN FRAME fPage1 = ""
               tt-produt-rural.cod-cart-produt :SCREEN-VALUE IN FRAME fPage1 = ""
               tt-produt-rural.log-optan-incent:CHECKED      IN FRAME fPage1 = NO
               tt-produt-rural.log-livre-1:CHECKED           IN FRAME fPage1 = NO.

        {&OPEN-QUERY-brSon2}
        {&OPEN-QUERY-brSon3}
        {&OPEN-QUERY-brSon4}
    END.

    APPLY "VALUE-CHANGED" TO brSon2 IN FRAME fPAGE2.
    APPLY "VALUE-CHANGED" TO brSon3 IN FRAME fPAGE3.
    APPLY "VALUE-CHANGED" TO brSon4 IN FRAME fPAGE4.

    RETURN "OK":U.

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

    IF AVAIL tt-produt-rural AND tt-produt-rural.cdn-produt-rural = ? THEN DO:
        RUN setEnabled IN hFolder (INPUT 2, INPUT FALSE).
        RUN setEnabled IN hFolder (INPUT 3, INPUT FALSE).
        RUN setEnabled IN hFolder (INPUT 4, INPUT FALSE).
    END.

    ASSIGN tt-produt-rural.cod-obs:SENSITIVE IN FRAME fPage1 = YES
           tt-produt-rural.cod-obs:READ-ONLY IN FRAME fpage1 = YES
           l-consulta = '{1}':U = 'aq0407':U.
           
    IF l-consulta THEN DO:
      ASSIGN btUpdate:HIDDEN              IN FRAME fPage0 = YES
             btAdd:HIDDEN                 IN FRAME fPage0 = YES
             btDelete:HIDDEN              IN FRAME fPage0 = YES
             btAddSon2:HIDDEN             IN FRAME fPage2 = YES
             btDeleteSon2:HIDDEN          IN FRAME fPage2 = YES
             btUpdateSon2:HIDDEN          IN FRAME fPage2 = YES
             btAddSon3:HIDDEN             IN FRAME fPage3 = YES
             btDeleteSon3:HIDDEN          IN FRAME fPage3 = YES
             btUpdateSon3:HIDDEN          IN FRAME fPage3 = YES
             btAddSon4:HIDDEN             IN FRAME fPage4 = YES
             btDeleteSon4:HIDDEN          IN FRAME fPage4 = YES
             btUpdateSon4:HIDDEN          IN FRAME fPage4 = YES
             btAddSon5:HIDDEN             IN FRAME fPage5 = YES
             btDeleteSon5:HIDDEN          IN FRAME fPage5 = YES
             btUpdateSon5:HIDDEN          IN FRAME fPage5 = YES
             btAddSon6:HIDDEN             IN FRAME fPage6 = YES
             btDeleteSon6:HIDDEN          IN FRAME fPage6 = YES
             btUpdateSon6:HIDDEN          IN FRAME fPage6 = YES
             MENU-ITEM miAdd:SENSITIVE    IN MENU smFile  = NO
             MENU-ITEM miDelete:SENSITIVE IN MENU smFile  = NO
             MENU-ITEM miUpdate:SENSITIVE IN MENU smFile  = NO.

      ENABLE btDetalhar  WITH FRAME fPage2.
      ENABLE btDetalhar2 WITH FRAME fPage3.

      ASSIGN btDetalhar:COL  IN FRAME fPage2 = 2
             btDetalhar2:COL IN FRAME fPage3 = 2.

    END.
    ELSE 
        ASSIGN btDetalhar:HIDDEN IN FRAME fPage2  = YES
               btDetalhar2:HIDDEN IN FRAME fPage3 = YES.
        
    IF gr-produt-rural-aq0207 <> ? THEN DO:    
         RUN repositionRecord IN THIS-PROCEDURE (INPUT gr-produt-rural-aq0207).
         ASSIGN gr-produt-rural-aq0207  = ?.
    
    END.
       
    RETURN "OK":U.

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
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE c-cdn-produt-rural LIKE {&ttParent}.cdn-produt-rural NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-cdn-produt-rural AT ROW 1.90 COL 25 COLON-ALIGNED VIEW-AS FILL-IN SIZE 17 BY .88
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Produtor"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */
                                         
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-cdn-produt-rural.
        
        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT c-cdn-produt-rural).
        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-liter.i Produtor *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-cdn-produt-rural btGoToOK btGoToCancel 
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
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "inbo/boin00962.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00962.p YES}
        {btb/btb008za.i2 inbo/boin00962.p '' {&hDBOParent}} 
    END.

    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon2}) OR 
       {&hDBOSon2}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon2}:FILE-NAME <> "inbo/boin00980.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00980.p YES}
        {btb/btb008za.i2 inbo/boin00980.p '' {&hDBOSon2}} 
    END.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon3}) OR
       {&hDBOSon3}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon3}:FILE-NAME <> "inbo/boin00966.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00966.p YES}
        {btb/btb008za.i2 inbo/boin00966.p '' {&hDBOSon3}} 
    END.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon4}) OR
       {&hDBOSon4}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon4}:FILE-NAME <> "inbo/boin00984.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00984.p YES}
        {btb/btb008za.i2 inbo/boin00984.p '' {&hDBOSon4}} 
    END.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon5}) OR
       {&hDBOSon5}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon5}:FILE-NAME <> "inbo/boin00964.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00964.p YES}
        {btb/btb008za.i2 inbo/boin00964.p '' {&hDBOSon5}} 
    END.
    
    IF NOT VALID-HANDLE(h-boin00963) OR
       h-boin00963:TYPE <> "PROCEDURE":U OR
       h-boin00963:FILE-NAME <> "inbo/boin00963.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00963.p YES}
        {btb/btb008za.i2 inbo/boin00963.p '' h-boin00963}
    END.
    
    RUN openQueryStatic IN h-boin00963 (INPUT "Main":U) NO-ERROR.
    
    IF NOT VALID-HANDLE(h-boin00977) OR
       h-boin00977:TYPE <> "PROCEDURE":U OR
       h-boin00977:FILE-NAME <> "inbo/boin00977.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00977.p YES}
        {btb/btb008za.i2 inbo/boin00977.p '' h-boin00977}
    END.
    
    RUN openQueryStatic IN h-boin00977 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE({&hDBOSon6}) OR
       {&hDBOSon6}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon6}:FILE-NAME <> "inbo/boin01003.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin01003.p YES}
        {btb/btb008za.i2 inbo/boin01003.p '' {&hDBOSon6}}
    END.
    
    RUN openQueryStatic IN {&hDBOSon6} (INPUT "Main":U) NO-ERROR.
 

    IF NOT VALID-HANDLE(h-boin00990) THEN
        RUN inbo/boin00990.p PERSISTENT SET h-boin00990.        
    RUN openQueryStatic IN h-boin00990 (INPUT "Main":U) NO-ERROR. 

    IF NOT VALID-HANDLE(h-aqapi005) THEN
        RUN aqp/aqapi005.p PERSISTENT SET h-aqapi005.

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
    
    {masterdetail/openqueriesson.i &Parent="Produtor"
                                   &Query="PropriedadeProdutor"
                                   &PageNumber="2"}
    
    {masterdetail/openqueriesson.i &Parent="Produtor"
                                   &Query="PtoColetaProdutor"
                                   &PageNumber="3"}
                                   
    {masterdetail/openqueriesson.i &Parent="Produtor"
                                   &Query="ReposProdutor"
                                   &PageNumber="4"}
                                                   
    {masterdetail/openqueriesson.i &Parent="Produtor"
                                   &Query="NPRProdutor"
                                   &PageNumber="5"}
    
    {masterdetail/openqueriesson.i &Parent="Produtor"
                                   &Query="VolProdutor"
                                   &PageNumber="6"}
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCodExterno wMasterDetail 
FUNCTION fnCodExterno RETURNS CHARACTER
  (pc-cod-pto-coleta AS CHAR,  pc-cod-propried AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE c-cod-externo AS CHARACTER   NO-UNDO.
   
    IF VALID-HANDLE(h-boin00990) THEN DO:
        RUN goToKey IN h-boin00990(INPUT input frame fpage0 tt-produt-rural.cdn-produt-rural, 
                                   INPUT pc-cod-pto-coleta,
                                   INPUT pc-cod-propried). 
                                   
        IF RETURN-VALUE = "OK":U THEN
            RUN getCharField IN h-boin00990(INPUT "cod-externo":U, OUTPUT c-cod-externo).
    END.
    RETURN c-cod-externo.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCodExternoPropriedade wMasterDetail 
FUNCTION fnCodExternoPropriedade RETURNS CHARACTER
  ( i-retorno AS INT, pc-cod-propried AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE c-cod-externo    AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-cod-pto-coleta AS CHARACTER   NO-UNDO.
   
    IF VALID-HANDLE(h-boin00990) THEN
        RUN findCodExternoProdutPtoColetivo IN h-boin00990(INPUT INPUT FRAME fpage0 tt-produt-rural.cdn-produt-rural,
                                                           INPUT pc-cod-propried,
                                                           OUTPUT c-cod-externo,
                                                           OUTPUT c-cod-pto-coleta). 
    
     IF i-retorno = 1 THEN 
         RETURN c-cod-externo.
     ELSE
         RETURN c-cod-pto-coleta.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRegiao wMasterDetail 
FUNCTION fnRegiao RETURNS CHARACTER
  ( input ccod-regiao as CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEF VAR cdesc-regiao AS CHAR NO-UNDO.
    
    IF VALID-HANDLE(h-boin00963) THEN DO:
        
        RUN GotoKey in h-boin00977 (input ccod-regiao).
        IF RETURN-VALUE = "OK":U THEN
            RUN GetCharField in h-boin00977 (input "nom-regiao":U, output cdesc-regiao).

    END.

    RETURN cdesc-regiao.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRegiaoPropriedade wMasterDetail 
FUNCTION fnRegiaoPropriedade RETURNS CHARACTER
  ( pc-cod-propried AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-cod-regiao AS CHARACTER   NO-UNDO.
    
    IF VALID-HANDLE({&hDBOSon2}) AND AVAIL tt-pto-coleta THEN DO:
        RUN goToKey IN {&hDBOSon2}(INPUT tt-pto-coleta.cod-propried).
        IF RETURN-VALUE = "OK":U THEN
            RUN getCharField IN {&hDBOSon2}(INPUT "cod-regiao":U, OUTPUT c-cod-regiao).
    END.
    
    RETURN c-cod-regiao.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

