&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex             PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-ordens-embarque NO-UNDO LIKE ordens-embarque
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
{include/i-prgvrs.i IM0100C 2.00.00.040 } /*** "010040" 29/06/2026 16:46:28 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0100c MIM}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM0100C
&GLOBAL-DEFINE Version        2.00.00.040
&GLOBAL-DEFINE DBOVersion       1.1

&GLOBAL-DEFINE Folder           NO
&GLOBAL-DEFINE InitialPage      0
&GLOBAL-DEFINE FolderLabels     

&GLOBAL-DEFINE ttParent         tt-embarque-imp
&GLOBAL-DEFINE hDBOParent       h-bocx220
&GLOBAL-DEFINE DBOParentTable   embarque-imp
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           tt-ordens-embarque
&GLOBAL-DEFINE hDBOSon1         h-bocx225e
&GLOBAL-DEFINE DBOSon1Table     ordens-embarque
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE page0Fields      tt-embarque-imp.cod-estabel ~
                                tt-embarque-imp.embarque ~
                                i-peso ~
                                i-quantidade ~
                                i-cubagem ~
                                i-classifica ~
                                btConfirm ~
                                btReload

&GLOBAL-DEFINE page0Browse      brSon1 brSon2 brSon3

&GLOBAL-DEFINE numRowsReturned  inumRowsReturned

&GLOBAL-DEFINE EXCLUDE-ApplyOffEnd
&GLOBAL-DEFINE ExcludeBtQueryJoins      YES
&GLOBAL-DEFINE ExcludeBtReportsJoins    YES

/* Include pre-processadores */
{cdp/cdcfgmat.i}

{cxbo/bocx225e.i tt-ordens-desemb}

/* Vari†veis de Sistema */
{utp/ut-glob.i}

/* Parameters Definitions ---                                           */
DEF INPUT PARAMETER p-cod-estabel   LIKE estabelec.cod-estabel   NO-UNDO.
DEF INPUT PARAMETER p-embarque      LIKE embarque-imp.embarque   NO-UNDO.
DEF INPUT PARAMETER p-usuario       LIKE param-re.usuario        NO-UNDO.
DEF INPUT PARAMETER p-nat-operacao  LIKE natur-oper.nat-operacao NO-UNDO.
DEF INPUT PARAMETER p-icms-diferido AS   LOGICAL                 NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx407     AS HANDLE      NO-UNDO.

DEF VAR h-boin245 AS HANDLE NO-UNDO.
DEF VAR h-boin292 AS HANDLE NO-UNDO.

DEF VAR c-it-codigo        LIKE ITEM.it-codigo           NO-UNDO.
DEF VAR c-desc-item          AS CHAR FORMAT "x(60)"      NO-UNDO.
DEF VAR c-un               LIKE ITEM.un                  NO-UNDO.
DEF VAR de-quantidade      LIKE prazo-compra.quantidade  NO-UNDO.

DEF VAR l-usuarionatureza    AS LOGICAL                  NO-UNDO.
DEF VAR inumRowsReturned     AS INTEGER                  NO-UNDO.
DEF VAR i-peso-ant           AS INTEGER                  NO-UNDO.
DEF VAR i-cubagem-ant        AS INTEGER                  NO-UNDO.
DEF VAR i-sequen             AS INTEGER                  NO-UNDO.

DEF VAR i-cdn-adicao-ant     AS INTEGER                  NO-UNDO.
DEF VAR i-classifica-ant     AS INTEGER                  NO-UNDO.
DEF VAR c-desc-classif       AS CHARACTER FORMAT "x(35)" NO-UNDO.
DEF VAR c-erro               AS CHARACTER                NO-UNDO.
DEF VAR c-tax-siscomex       AS CHARACTER                NO-UNDO.
DEF VAR de-qtde-acum       LIKE prazo-compra.quantidade  NO-UNDO.
DEF VAR de-qt-do-forn-acum LIKE prazo-compra.quantidade  NO-UNDO.
DEF VAR de-quantidade-acum LIKE prazo-compra.quantidade  NO-UNDO.

DEF VAR de-peso-bruto               AS DECIMAL FORMAT ">>>>>,>>>,>>9.9999999999" NO-UNDO.
DEF VAR de-peso-liquido             AS DECIMAL FORMAT ">>>>>,>>>,>>9.9999999999" NO-UNDO.
DEF VAR de-tot-peso-bruto           AS DECIMAL FORMAT ">>>>>,>>>,>>9.9999999999" NO-UNDO.
DEF VAR de-tot-peso-liquido         AS DECIMAL FORMAT ">>>>>,>>>,>>9.9999999999" NO-UNDO.
DEF VAR de-tot-cubagem              AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999"      NO-UNDO.
DEF VAR de-cubagem                  AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999"      NO-UNDO.
DEF VAR de-peso-bruto-unit-acum     AS DECIMAL FORMAT ">>>>>,>>>,>>9.9999999999" NO-UNDO.
DEF VAR de-peso-bruto-acum          AS DECIMAL FORMAT ">>>>>,>>>,>>9.9999999999" NO-UNDO.
DEF VAR de-peso-liquido-unit-acum   AS DECIMAL FORMAT ">>>>>,>>>,>>9.9999999999" NO-UNDO.
DEF VAR de-peso-liquido-acum        AS DECIMAL FORMAT ">>>>>,>>>,>>9.9999999999" NO-UNDO.

DEF VAR de-cubagem-unit-acum        AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEF VAR de-cubagem-tot-acum         AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEF VAR de-cubagem-acum             AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEF VAR de-peso-embal-acum          AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEF VAR h-boin046na                 AS HANDLE                                NO-UNDO.
DEF VAR h-bocx250                   AS HANDLE                                NO-UNDO.
DEF VAR iNrRegistro                 AS INTEGER                               NO-UNDO.
DEF VAR i-peso-aux                  AS INTEGER                               NO-UNDO.
DEF VAR i-cubagem-aux               AS INTEGER                               NO-UNDO.
DEF VAR l-atualiza-pesos            AS LOGICAL                               NO-UNDO.
DEF VAR l-tax-siscomex              AS LOGICAL                               NO-UNDO.
DEF VAR l-efetua-reload             AS LOGICAL                               NO-UNDO.
DEF VAR l-peso-bruto                AS LOGICAL INIT YES                      NO-UNDO.
DEF VAR l-peso-liquido              AS LOGICAL INIT YES                      NO-UNDO.
DEF VAR l-embalagem                 AS LOGICAL INIT YES                      NO-UNDO.
DEF VAR l-cubagem                   AS LOGICAL INIT YES                      NO-UNDO.
DEF VAR l-alterou-tx-siscomex       AS LOGICAL INIT NO                       NO-UNDO.

{imp/im0100.i1}

DEFINE BUFFER bf-tt-ordens-desemb      FOR  tt-ordens-desemb.

&if "{&bf_mat_versao_ems}" >= "2.062" &then
DEF VAR l-primeiro AS LOG NO-UNDO INIT YES.
&endif
/* Temp-tables                                                          */
{cxbo/bocx225.i tt-ordens-embarque-aux}
{include/boerrtab.i}
DEFINE TEMP-TABLE tt-ordens-desemb-acum NO-UNDO LIKE tt-ordens-desemb
    FIELD c-desc-classif AS CHAR FORMAT "x(35)".

DEFINE TEMP-TABLE tt-ordens-desemb-acum-adicao NO-UNDO LIKE tt-ordens-desemb-acum.

DEFINE TEMP-TABLE tt-ordens-desemb-acum-aux        NO-UNDO LIKE tt-ordens-desemb-acum.
DEFINE TEMP-TABLE tt-ordens-desemb-acum-adicao-aux NO-UNDO LIKE tt-ordens-desemb-acum-adicao.

DEFINE BUFFER bf-tt-ordens-desemb-acum FOR  tt-ordens-desemb-acum.
DEFINE BUFFER b-tt-ordens-desemb       FOR  tt-ordens-desemb.

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
&Scoped-define INTERNAL-TABLES tt-ordens-desemb tt-ordens-desemb-acum ~
tt-ordens-desemb-acum-adicao

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-ordens-desemb.numero-ordem tt-ordens-desemb.parcela tt-ordens-desemb.c-it-codigo tt-ordens-desemb.c-desc-item tt-ordens-desemb.c-class-fiscal tt-ordens-desemb.c-un tt-ordens-desemb.de-quantidade tt-ordens-desemb.de-peso-bruto &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN tt-ordens-desemb.de-peso-embal &endif tt-ordens-desemb.de-peso-liquido tt-ordens-desemb.de-cubagem tt-ordens-desemb.cdn-adicao tt-ordens-desemb.seq-item  
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 tt-ordens-desemb.de-peso-bruto ~
tt-ordens-desemb.de-peso-liquido ~
tt-ordens-desemb.de-cubagem ~
tt-ordens-desemb.cdn-adicao ~
tt-ordens-desemb.seq-item
&Scoped-define ENABLED-TABLES-IN-QUERY-brSon1 tt-ordens-desemb "Nr "Seq
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brSon1 tt-ordens-desemb
&Scoped-define SECOND-ENABLED-TABLE-IN-QUERY-brSon1 "Nr
&Scoped-define THIRD-ENABLED-TABLE-IN-QUERY-brSon1 "Seq
&Scoped-define SELF-NAME brSon1
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-ordens-desemb NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-ordens-desemb
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-ordens-desemb


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 tt-ordens-desemb-acum.c-class-fiscal tt-ordens-desemb-acum.c-un fnDescClassFiscal(tt-ordens-desemb-acum.c-class-fiscal) @ c-desc-classif tt-ordens-desemb-acum.de-quantidade tt-ordens-desemb-acum.de-peso-bruto &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN tt-ordens-desemb-acum.de-peso-embal &endif tt-ordens-desemb-acum.de-peso-liquido tt-ordens-desemb-acum.de-cubagem   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 tt-ordens-desemb-acum.de-peso-bruto ~
tt-ordens-desemb-acum.de-peso-liquido ~
tt-ordens-desemb-acum.de-cubagem   
&Scoped-define ENABLED-TABLES-IN-QUERY-brSon2 tt-ordens-desemb-acum
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brSon2 tt-ordens-desemb-acum
&Scoped-define SELF-NAME brSon2
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-ordens-desemb-acum NO-LOCK         BY tt-ordens-desemb-acum.c-class-fiscal
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb-acum NO-LOCK         BY tt-ordens-desemb-acum.c-class-fiscal.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-ordens-desemb-acum
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-ordens-desemb-acum


/* Definitions for BROWSE brSon3                                        */
&Scoped-define FIELDS-IN-QUERY-brSon3 tt-ordens-desemb-acum-adicao.cdn-adicao tt-ordens-desemb-acum-adicao.c-class-fiscal tt-ordens-desemb-acum-adicao.c-un fnDescClassFiscal(tt-ordens-desemb-acum-adicao.c-class-fiscal) @ c-desc-classif tt-ordens-desemb-acum-adicao.de-quantidade tt-ordens-desemb-acum-adicao.de-peso-bruto &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN tt-ordens-desemb-acum-adicao.de-peso-embal &endif tt-ordens-desemb-acum-adicao.de-peso-liquido tt-ordens-desemb-acum-adicao.de-cubagem   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon3 tt-ordens-desemb-acum-adicao.de-peso-bruto ~
tt-ordens-desemb-acum-adicao.de-peso-liquido ~
tt-ordens-desemb-acum-adicao.de-cubagem   
&Scoped-define ENABLED-TABLES-IN-QUERY-brSon3 tt-ordens-desemb-acum-adicao
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brSon3 tt-ordens-desemb-acum-adicao
&Scoped-define SELF-NAME brSon3
&Scoped-define QUERY-STRING-brSon3 FOR EACH tt-ordens-desemb-acum-adicao NO-LOCK BY tt-ordens-desemb-acum-adicao.cdn-adicao
&Scoped-define OPEN-QUERY-brSon3 OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb-acum-adicao NO-LOCK BY tt-ordens-desemb-acum-adicao.cdn-adicao.
&Scoped-define TABLES-IN-QUERY-brSon3 tt-ordens-desemb-acum-adicao
&Scoped-define FIRST-TABLE-IN-QUERY-brSon3 tt-ordens-desemb-acum-adicao


/* Definitions for FRAME fPage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage0 ~
    ~{&OPEN-QUERY-brSon1}~
    ~{&OPEN-QUERY-brSon2}~
    ~{&OPEN-QUERY-brSon3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque 
&Scoped-define ENABLED-TABLES tt-embarque-imp
&Scoped-define FIRST-ENABLED-TABLE tt-embarque-imp
&Scoped-Define ENABLED-OBJECTS i-peso-cubagem i-peso i-cubagem i-quantidade ~
i-classifica brSon1 brSon2 vl-tot-peso-bruto vl-tot-peso-liq vl-tot-cubagem ~
btConfirm btReload btExit btHelp RECT-1 RECT-2 rtParent rtToolBar brSon3 
&Scoped-Define DISPLAYED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque 
&Scoped-define DISPLAYED-TABLES tt-embarque-imp
&Scoped-define FIRST-DISPLAYED-TABLE tt-embarque-imp
&Scoped-Define DISPLAYED-OBJECTS i-peso-cubagem i-peso i-cubagem ~
i-quantidade i-classifica vl-tot-peso-bruto vl-tot-peso-liq vl-tot-cubagem 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCubagem wMasterDetail 
FUNCTION fnCubagem RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescClassFiscal wMasterDetail 
FUNCTION fnDescClassFiscal RETURNS CHARACTER
  ( c-class-fiscal AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescricao wMasterDetail 
FUNCTION fnDescricao RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnItem wMasterDetail 
FUNCTION fnItem RETURNS CHARACTER
  ( INPUT p-numero-ordem AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPesoBruto wMasterDetail 
FUNCTION fnPesoBruto RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPesoLiquido wMasterDetail 
FUNCTION fnPesoLiquido RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnQuantidade wMasterDetail 
FUNCTION fnQuantidade RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUn wMasterDetail 
FUNCTION fnUn RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUnidade wMasterDetail 
FUNCTION fnUnidade RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btConfirm 
     IMAGE-UP FILE "image~\im-sav":U
     IMAGE-INSENSITIVE FILE "image~\ii-sav":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Confirma alteraá‰es nos itens"
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image~\im-exi":U
     IMAGE-INSENSITIVE FILE "image~\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image~\im-hel":U
     IMAGE-INSENSITIVE FILE "image~\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReload 
     IMAGE-UP FILE "image~\im-undo":U
     IMAGE-INSENSITIVE FILE "image~\ii-undo":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Recarrega informaá‰es do item"
     FONT 4.

DEFINE VARIABLE vl-tot-cubagem AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99999":U INITIAL 0 
     LABEL "Cubagem Total" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE vl-tot-peso-bruto AS DECIMAL FORMAT ">>>>>>,>>>,>>9.9999999999":U INITIAL 0 
     LABEL "Peso Bruto Total" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE vl-tot-peso-liq AS DECIMAL FORMAT ">>>>>>,>>>,>>9.9999999999":U INITIAL 0 
     LABEL "Peso L°quido Total" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE i-classifica AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Por Item", 1,
"Por Class Fiscal", 2,
"Por Adiá‰es do Embarque", 3
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE i-cubagem AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cubagem Unit†rio", 1,
"Cubagem Total", 2
     SIZE 33 BY 1.08 NO-UNDO.

DEFINE VARIABLE i-peso AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Peso Unit†rio", 1,
"Peso Total", 2
     SIZE 40 BY 1.08 NO-UNDO.

DEFINE VARIABLE i-peso-cubagem AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Peso/Cubagem Total", 1,
"Peso/Cubagem Unit†rio", 2
     SIZE 60 BY 1.08 NO-UNDO.

DEFINE VARIABLE i-quantidade AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Qtde Unidade Interna", 1,
"Qtde Unidade Externa", 2
     SIZE 42 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.5.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-ordens-desemb SCROLLING.

DEFINE QUERY brSon2 FOR 
      tt-ordens-desemb-acum SCROLLING.

DEFINE QUERY brSon3 FOR 
      tt-ordens-desemb-acum-adicao SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 NO-LOCK DISPLAY
      tt-ordens-desemb.numero-ordem FORMAT "zzzzz9,99":U
      tt-ordens-desemb.parcela FORMAT ">>>>9":U
      tt-ordens-desemb.c-it-codigo LABEL "Item"
      tt-ordens-desemb.c-desc-item LABEL "Descriá∆o"
      tt-ordens-desemb.c-class-fiscal LABEL "Class Fiscal" FORMAT "9999.99.99":U
      tt-ordens-desemb.c-un LABEL "Un"
      tt-ordens-desemb.de-quantidade FORMAT ">>>>>,>>9.9999":U LABEL "Quantidade"
      tt-ordens-desemb.de-peso-bruto LABEL "Peso Bruto"
      &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
      tt-ordens-desemb.de-peso-embal LABEL "Peso Embalagem" FORMAT ">>>,>>>,>>9.9999":U
      &endif
      tt-ordens-desemb.de-peso-liquido LABEL "Peso L°quido"
      tt-ordens-desemb.de-cubagem FORMAT ">>>>>,>>>,>>9.99999":U COLUMN-LABEL "Cubagem"
      tt-ordens-desemb.cdn-adicao
      tt-ordens-desemb.seq-item
  ENABLE
      tt-ordens-desemb.de-peso-bruto HELP "Peso Bruto"
      tt-ordens-desemb.de-peso-liquido HELP "Peso L°quido"
      tt-ordens-desemb.de-cubagem HELP "Cubagem"
      tt-ordens-desemb.cdn-adicao HELP "Nr.Adiá∆o"
      tt-ordens-desemb.seq-item HELP "Seq. Item Adiá∆o"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89.43 BY 8.25
         FONT 2 ROW-HEIGHT-CHARS .54.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _FREEFORM
  QUERY brSon2 NO-LOCK DISPLAY
      tt-ordens-desemb-acum.c-class-fiscal FORMAT "9999.99.99":U
      tt-ordens-desemb-acum.c-un LABEL "Un"
      fnDescClassFiscal(tt-ordens-desemb-acum.c-class-fiscal) @ c-desc-classif LABEL "Descriá∆o" FORMAT "x(35)"
      tt-ordens-desemb-acum.de-quantidade FORMAT ">>>>>>,>>9.9999":U LABEL "Quantidade"
      tt-ordens-desemb-acum.de-peso-bruto FORMAT ">>>,>>>,>>9.9999":U LABEL "Peso Bruto"
      &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
      tt-ordens-desemb-acum.de-peso-embal FORMAT ">>>,>>>,>>9.9999":U LABEL "Peso Embalagem"
      &endif
      tt-ordens-desemb-acum.de-peso-liquido LABEL "Peso L°quido"
      tt-ordens-desemb-acum.de-cubagem FORMAT ">>>>>,>>>,>>9.99999":U COLUMN-LABEL "Cubagem"
  ENABLE
      tt-ordens-desemb-acum.de-peso-bruto HELP "Peso Bruto"
      tt-ordens-desemb-acum.de-peso-liquido HELP "Peso L°quido"
      tt-ordens-desemb-acum.de-cubagem HELP "Cubagem"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89.43 BY 8.25
         FONT 2 ROW-HEIGHT-CHARS .54.

DEFINE BROWSE brSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon3 wMasterDetail _FREEFORM
  QUERY brSon3 NO-LOCK DISPLAY
      tt-ordens-desemb-acum-adicao.cdn-adicao
      tt-ordens-desemb-acum-adicao.c-class-fiscal FORMAT "9999.99.99":U
      tt-ordens-desemb-acum-adicao.c-un LABEL "Un"
      fnDescClassFiscal(tt-ordens-desemb-acum-adicao.c-class-fiscal) @ c-desc-classif LABEL "Descriá∆o" FORMAT "x(35)"
      tt-ordens-desemb-acum-adicao.de-quantidade FORMAT ">>>>>>,>>9.9999":U LABEL "Quantidade"
      tt-ordens-desemb-acum-adicao.de-peso-bruto FORMAT ">>>,>>>,>>9.9999":U LABEL "Peso Bruto"
      &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
      tt-ordens-desemb-acum-adicao.de-peso-embal FORMAT ">>>,>>>,>>9.9999":U LABEL "Peso Embalagem"
      &endif
      tt-ordens-desemb-acum-adicao.de-peso-liquido LABEL "Peso L°quido"
      tt-ordens-desemb-acum-adicao.de-cubagem FORMAT ">>>>>,>>>,>>9.99999":U COLUMN-LABEL "Cubagem"
  ENABLE
      tt-ordens-desemb-acum-adicao.de-peso-bruto HELP "Peso Bruto"
      tt-ordens-desemb-acum-adicao.de-peso-liquido HELP "Peso L°quido"
      tt-ordens-desemb-acum-adicao.de-cubagem HELP "Cubagem"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89.43 BY 8.25
         FONT 2 ROW-HEIGHT-CHARS .54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     i-peso-cubagem AT ROW 4.83 COL 20 NO-LABEL
     tt-embarque-imp.cod-estabel AT ROW 3 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-embarque-imp.embarque AT ROW 3 COL 50 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     i-peso AT ROW 4.83 COL 4 HELP
          "Informar Peso Unit†rio ou Peso Total" NO-LABEL
     i-cubagem AT ROW 4.83 COL 50 HELP
          "Informar Cubagem Unit†rio ou Cubagem Total" NO-LABEL
     i-quantidade AT ROW 6.63 COL 3 HELP
          "Visualizar a quantidade na unidade interna/externa" NO-LABEL
     i-classifica AT ROW 6.63 COL 43 HELP
          "Visualizar por Item, Class Fiscal ou Adiá‰es do Embarque" NO-LABEL
     brSon1 AT ROW 8 COL 1.57
     brSon2 AT ROW 8 COL 1.57
     vl-tot-peso-bruto AT ROW 16.46 COL 14 COLON-ALIGNED
     vl-tot-peso-liq AT ROW 16.46 COL 43.57 COLON-ALIGNED
     vl-tot-cubagem AT ROW 16.46 COL 70.86 COLON-ALIGNED
     btConfirm AT ROW 1.13 COL 1.57 HELP
          "Confirma as alteraá‰es"
     btReload AT ROW 1.13 COL 5.57 HELP
          "Recarrega informaá‰es dos itens"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     brSon3 AT ROW 8 COL 1.57
     "  Informa:" VIEW-AS TEXT
          SIZE 7 BY .75 AT ROW 4.25 COL 39
     " Visualiza:" VIEW-AS TEXT
          SIZE 7 BY .75 AT ROW 5.96 COL 39
     RECT-1 AT ROW 4.5 COL 1
     RECT-2 AT ROW 6.25 COL 1
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 16.58
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-embarque-imp T "?" NO-UNDO mgcex embarque-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-ordens-embarque T "?" NO-UNDO mgcex ordens-embarque
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
         HEIGHT             = 16.54
         WIDTH              = 90.57
         MAX-HEIGHT         = 30.58
         MAX-WIDTH          = 164.57
         VIRTUAL-HEIGHT     = 30.58
         VIRTUAL-WIDTH      = 164.57
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
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB brSon1 i-classifica fPage0 */
/* BROWSE-TAB brSon2 brSon1 fPage0 */
/* BROWSE-TAB brSon3 rtToolBar fPage0 */
ASSIGN 
       vl-tot-cubagem:READ-ONLY IN FRAME fPage0        = TRUE.

ASSIGN 
       vl-tot-peso-bruto:READ-ONLY IN FRAME fPage0        = TRUE.

ASSIGN 
       vl-tot-peso-liq:READ-ONLY IN FRAME fPage0        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb-acum NO-LOCK
        BY tt-ordens-desemb-acum.c-class-fiscal.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brSon2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon3
/* Query rebuild information for BROWSE brSon3
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-desemb-acum-adicao NO-LOCK BY tt-ordens-desemb-acum-adicao.cdn-adicao.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brSon3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
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
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON ROW-DISPLAY OF brSon1 IN FRAME fPage0
DO:
    IF  i-peso-cubagem:SCREEN-VALUE IN FRAME fPage0 = '2' THEN /* unitario */
        ASSIGN tt-ordens-desemb.de-peso-bruto  :FORMAT IN BROWSE brSon1 = '>>>,>>>,>>9.9999999999'
               tt-ordens-desemb.de-peso-liquido:FORMAT IN BROWSE brSon1 = '>>>,>>>,>>9.9999999999'.
    ELSE
        ASSIGN tt-ordens-desemb.de-peso-bruto  :FORMAT IN BROWSE brSon1 = '>>>,>>>,>>9.99999'
               tt-ordens-desemb.de-peso-liquido:FORMAT IN BROWSE brSon1 = '>>>,>>>,>>9.99999'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON VALUE-CHANGED OF brSon1 IN FRAME fPage0
DO:
  IF NOT AVAIL tt-ordens-desemb THEN DO:
      FIND FIRST tt-ordens-desemb EXCLUSIVE-LOCK NO-ERROR.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon2
&Scoped-define SELF-NAME brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon2 wMasterDetail
ON ROW-DISPLAY OF brSon2 IN FRAME fPage0
DO:
    IF  i-peso-cubagem:SCREEN-VALUE IN FRAME fPage0 = '2' THEN /* unitario */
        ASSIGN tt-ordens-desemb-acum.de-peso-bruto  :FORMAT IN BROWSE brSon2 = '>,>>>,>>>,>>9.9999999999'
               tt-ordens-desemb-acum.de-peso-liquido:FORMAT IN BROWSE brSon2 = '>,>>>,>>>,>>9.9999999999'.
    ELSE
        ASSIGN tt-ordens-desemb-acum.de-peso-bruto  :FORMAT IN BROWSE brSon2 = '>,>>>,>>>,>>9.99999'
               tt-ordens-desemb-acum.de-peso-liquido:FORMAT IN BROWSE brSon2 = '>,>>>,>>>,>>9.99999'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon2 wMasterDetail
ON VALUE-CHANGED OF brSon2 IN FRAME fPage0
DO:
  IF NOT AVAIL tt-ordens-desemb-acum THEN DO:
      FIND FIRST tt-ordens-desemb-acum EXCLUSIVE-LOCK NO-ERROR.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon3
&Scoped-define SELF-NAME brSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon3 wMasterDetail
ON ROW-DISPLAY OF brSon3 IN FRAME fPage0
DO:
    IF  i-peso-cubagem:SCREEN-VALUE IN FRAME fPage0 = '2' THEN /* unitario */
        ASSIGN tt-ordens-desemb-acum-adicao.de-peso-bruto  :FORMAT IN BROWSE brSon3 = '>,>>>,>>>,>>9.9999999999'
               tt-ordens-desemb-acum-adicao.de-peso-liquido:FORMAT IN BROWSE brSon3 = '>,>>>,>>>,>>9.9999999999'.
    ELSE
        ASSIGN tt-ordens-desemb-acum-adicao.de-peso-bruto  :FORMAT IN BROWSE brSon3 = '>,>>>,>>>,>>9.99999'
               tt-ordens-desemb-acum-adicao.de-peso-liquido:FORMAT IN BROWSE brSon3 = '>,>>>,>>>,>>9.99999'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon3 wMasterDetail
ON VALUE-CHANGED OF brSon3 IN FRAME fPage0
DO:
  IF NOT AVAIL tt-ordens-desemb-acum-adicao THEN DO:
      FIND FIRST tt-ordens-desemb-acum-adicao EXCLUSIVE-LOCK NO-ERROR.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConfirm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfirm wMasterDetail
ON CHOOSE OF btConfirm IN FRAME fPage0
DO:
    APPLY "entry":U TO i-classifica.
    APPLY "LEAVE":U TO tt-ordens-desemb.cdn-adicao IN BROWSE brSon1.

    /*IF  l-tax-siscomex THEN DO:
        IF  CAN-FIND(FIRST b-tt-ordens-desemb
                     WHERE b-tt-ordens-desemb.cdn-adicao = 0)
        AND CAN-FIND(FIRST tt-ordens-desemb
                     WHERE tt-ordens-desemb.cdn-adicao <> 0) THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 33778,
                               INPUT "").
            RETURN NO-APPLY.
        END.
    END.*/

    RUN validapesoliq.

    IF  l-alterou-tx-siscomex THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 33798,
                           INPUT "").
    END.
    
    IF  INPUT FRAME fPage0 i-classifica <> 1 THEN DO:
        RUN updateOrdensDesemb2 IN THIS-PROCEDURE.

        &if "{&bf_mat_versao_ems}" < "2.062" &then
            ASSIGN i-peso    = 2
                   i-cubagem = 2. // Total
        &endif
    END.

    IF tt-ordens-desemb.seq-item > 0
    AND tt-ordens-desemb.cdn-adicao <= 0 THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Nr_Adicao" *}
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 265,
                           INPUT RETURN-VALUE).
        RETURN NO-APPLY.
    END.
    
    RUN updateOrdensEmbarque IN THIS-PROCEDURE.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btReload
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReload wMasterDetail
ON CHOOSE OF btReload IN FRAME fPage0
DO:

    RUN imp/im0100f.w (INPUT-OUTPUT l-peso-bruto,
                       INPUT-OUTPUT l-peso-liquido,
                       INPUT-OUTPUT l-cubagem,
                       OUTPUT       l-efetua-reload).

    IF  NOT l-efetua-reload THEN
        RETURN NO-APPLY.
    
    RUN createOrdensDesemb IN THIS-PROCEDURE (INPUT YES,
                                              INPUT l-peso-bruto,
                                              INPUT l-peso-liquido,
                                              INPUT l-cubagem).

    IF INPUT FRAME fPage0 i-classifica = 1 THEN DO:
        {&OPEN-QUERY-brSon1}
        APPLY "VALUE-CHANGED":U TO BROWSE brSon1.
        &if "{&bf_mat_versao_ems}" < "2.062" &then
            ASSIGN i-peso       = 1
                   i-cubagem    = 1. // Unit†rio
        &endif
    END.
    ELSE DO:
        ASSIGN i-peso   :SCREEN-VALUE IN FRAME fPage0 = "2"
               i-cubagem:SCREEN-VALUE IN FRAME fPage0 = "2" // Total
               i-peso-ant    = 1
               i-cubagem-ant = 1. // Unit†rio
        RUN updatePesos   IN THIS-PROCEDURE.
        RUN updateCubagem IN THIS-PROCEDURE.
        RUN createOrdensDesembAcum IN THIS-PROCEDURE.

        IF  INPUT FRAME fPage0 i-classifica = 2 THEN DO:
            {&OPEN-QUERY-brSon2}
            APPLY "VALUE-CHANGED":U TO BROWSE brSon2.
        END.
        ELSE DO:
            {&OPEN-QUERY-brSon3}
            APPLY "VALUE-CHANGED":U TO BROWSE brSon3.
        END.
    END.

    ASSIGN i-quantidade = 1.

    &IF "{&bf_mat_versao_ems}" < "2.062" &THEN
    DISP i-peso
         i-quantidade 
         i-cubagem WITH FRAME fPage0.
    &endif

    ASSIGN  de-tot-peso-bruto   = 0
            de-tot-peso-liquido = 0
            de-tot-cubagem      = 0.
    
    RUN CalculaTotais IN THIS-PROCEDURE.
  
    &if "{&bf_mat_versao_ems}" >= "2.062" &then
    {&OPEN-QUERY-brSon1}
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-classifica
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-classifica wMasterDetail
ON VALUE-CHANGED OF i-classifica IN FRAME fPage0
DO:
    &if "{&bf_mat_versao_ems}" < "2.062" &then
        ASSIGN i-classifica-ant = i-classifica
               INPUT FRAME fPage0 i-classifica.
        DO WITH FRAME fPage0:
            IF i-classifica <> 1 THEN DO:
                ASSIGN brSon1:HIDDEN = YES.
                
                IF i-classifica = 2 THEN DO:
                   ASSIGN brSon2:HIDDEN = NO
                          brSon3:HIDDEN = YES.
                   ENABLE brSon2.
                END.
                ELSE DO:
                   ASSIGN brSon2:HIDDEN = YES
                          brSon3:HIDDEN = NO.
                   ENABLE brSon3.
                END.
                
                DISABLE i-peso i-cubagem.

                RUN validapesoliq.
                
                IF i-peso = 1 THEN DO:
                    ASSIGN i-peso-aux = 1
                           i-peso-ant = 1
                           i-peso:SCREEN-VALUE = "2".
                    RUN updatePesos IN THIS-PROCEDURE.
                END.
                ELSE
                    ASSIGN i-peso-aux = 2.
                IF i-cubagem = 1 /* Unit†rio */ THEN DO:
                    ASSIGN i-cubagem-aux = 1
                           i-cubagem-ant = 1
                           i-cubagem:SCREEN-VALUE = "2". // Total
                    RUN updateCubagem IN THIS-PROCEDURE.
                END.
                ELSE
                    ASSIGN i-cubagem-aux = 2. // Total
                RUN createOrdensDesembAcum IN THIS-PROCEDURE.
                IF  i-classifica = 2 THEN DO:
                    {&OPEN-QUERY-brSon2}
                    APPLY "VALUE-CHANGED":U TO BROWSE brSon2.
                END.
                ELSE DO:
                    {&OPEN-QUERY-brSon3}
                    APPLY "VALUE-CHANGED":U TO BROWSE brSon3.
                END.
                
            END.
            ELSE DO:
                &IF "{&bf_mat_versao_ems}" < "2.062" &THEN
                ENABLE i-peso i-cubagem.
                &endif
                ASSIGN brSon1:HIDDEN = NO
                       brSon2:HIDDEN = YES
                       brSon3:HIDDEN = YES.

                RUN validapesoliq.
                
                RUN updateOrdensDesemb2 IN THIS-PROCEDURE.
                IF  i-peso-aux = 1 THEN DO:
                    ASSIGN i-peso:SCREEN-VALUE = "1"
                           i-peso-ant = 2.
                    RUN updatePesos IN THIS-PROCEDURE.
                END.
                IF  i-cubagem-aux = 1 /* Unit†rio */ THEN DO:
                    ASSIGN i-cubagem:SCREEN-VALUE = "1" // Unit†rio
                           i-cubagem-ant = 2. // Total
                    RUN updateCubagem IN THIS-PROCEDURE.
                END.
                {&OPEN-QUERY-brSon1}  
                APPLY "VALUE-CHANGED":U TO BROWSE brSon1.    
                
            END.
        END.
        ASSIGN de-tot-peso-bruto   = 0
               de-tot-peso-liquido = 0
               de-tot-cubagem      = 0.
        RUN CalculaTotais IN THIS-PROCEDURE.
    &ELSE
        ASSIGN i-classifica-ant = i-classifica
               INPUT FRAME fPage0 i-classifica.
               
        DO WITH FRAME fPage0:
            RUN validapesoliq.

            RUN updateOrdensDesemb2 IN THIS-PROCEDURE.
            
            IF i-classifica <> 1 THEN DO:
                ASSIGN brSon1:HIDDEN = YES.

                IF  i-classifica = 2 THEN DO:
                    ASSIGN brSon2:HIDDEN = NO
                           brSon3:HIDDEN = YES.
                    ENABLE brSon2.
                END.
                ELSE DO:
                    ASSIGN brSon2:HIDDEN = YES
                           brSon3:HIDDEN = NO.
                   ENABLE brSon3.
                END.
                
                DISABLE i-peso-cubagem.

                RUN createOrdensDesembAcum IN THIS-PROCEDURE.
                IF  i-classifica = 2 THEN DO:
                    {&OPEN-QUERY-brSon2}
                    APPLY "VALUE-CHANGED":U TO BROWSE brSon2.
                END.
                ELSE DO:
                    {&OPEN-QUERY-brSon3}
                    APPLY "VALUE-CHANGED":U TO BROWSE brSon3.
                END.
            END.
            ELSE DO:
                ENABLE i-peso-cubagem.
                ASSIGN brSon1:HIDDEN = NO
                       brSon2:HIDDEN = YES
                       brSon3:HIDDEN = YES.
                    
                IF  i-peso-cubagem = 2 /* Unit†rio */ THEN DO:
                    FOR EACH tt-ordens-desemb:
                        // Como estava selecionado por valor unit†rio, e estava em outra visualizaá∆o (acumulada por classificaá∆o ou adiciá∆o),
                        // o campo "de-cubagem" foi atualizado para o valor total (para acumular corretamente), ent∆o agora precisa retornar o "de-cubagem" para o valor unit†rio.
                        ASSIGN tt-ordens-desemb.de-cubagem = tt-ordens-desemb.val-cub-unit.
                    END.
                END.
    
                {&OPEN-QUERY-brSon1}  
                APPLY "VALUE-CHANGED":U TO BROWSE brSon1.    
            END.
        END.
        ASSIGN de-tot-peso-bruto   = 0
               de-tot-peso-liquido = 0
               de-tot-cubagem      = 0.
        RUN CalculaTotais IN THIS-PROCEDURE.
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cubagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cubagem wMasterDetail
ON VALUE-CHANGED OF i-cubagem IN FRAME fPage0
DO:
    ASSIGN i-cubagem-ant = i-cubagem
           INPUT FRAME fPage0 i-cubagem.
           
    IF INPUT FRAME fPage0 i-classifica = 1 THEN DO:
        RUN updateCubagem IN THIS-PROCEDURE.

        {&OPEN-QUERY-brSon1}  
        APPLY "VALUE-CHANGED":U TO BROWSE brSon1.    
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-peso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-peso wMasterDetail
ON VALUE-CHANGED OF i-peso IN FRAME fPage0
DO:
    ASSIGN i-peso-ant = i-peso
           INPUT FRAME fPage0 i-peso.
    IF INPUT FRAME fPage0 i-classifica = 1 THEN DO:
        RUN updatePesos IN THIS-PROCEDURE.
        {&OPEN-QUERY-brSon1}  
        APPLY "VALUE-CHANGED":U TO BROWSE brSon1.    
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-peso-cubagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-peso-cubagem wMasterDetail
ON VALUE-CHANGED OF i-peso-cubagem IN FRAME fPage0
DO:
   IF INPUT FRAME fPage0 i-peso-cubagem = 1 THEN /* Peso/Cubagem Total */
      ASSIGN i-peso    = 2   /* 2 -> Total */
             i-cubagem = 2.  // Total
   ELSE /* Peso/Cubagem Unit†rio */
      ASSIGN i-peso    = 1 /* 1 -> Unit†rio */
             i-cubagem = 1 . // Unit†rio

    ASSIGN i-peso-cubagem = INPUT FRAME fPage0 i-peso-cubagem.

    ASSIGN i-peso-ant    = i-peso
           i-cubagem-ant = i-cubagem.
           
    IF INPUT FRAME fPage0 i-classifica = 1 THEN DO:
        RUN updatePesosTotal IN THIS-PROCEDURE.
        RUN updateCubagemTotal IN THIS-PROCEDURE.
        {&OPEN-QUERY-brSon1}  
        APPLY "VALUE-CHANGED":U TO BROWSE brSon1.    
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-quantidade wMasterDetail
ON VALUE-CHANGED OF i-quantidade IN FRAME fPage0
DO:
    ASSIGN INPUT FRAME fPage0 i-quantidade.        
    RUN updateQtdeUnidade IN THIS-PROCEDURE.
    IF INPUT FRAME fPage0 i-classifica = 1 /* Por Item */ THEN DO:
        {&OPEN-QUERY-brSon1}  
        APPLY "VALUE-CHANGED":U TO BROWSE brSon1.    
    END.
    ELSE DO: /* Por Class Fiscal */
        {&OPEN-QUERY-brSon2}  
        APPLY "VALUE-CHANGED":U TO BROWSE brSon2.    
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*--- L¢gica para inicializaá∆o do programam ---*/
ON 'leave':U OF tt-ordens-desemb.de-peso-bruto IN BROWSE brSon1 DO:
    ASSIGN de-tot-peso-bruto   = 0
           de-tot-peso-liquido = 0
           de-tot-cubagem      = 0.
    IF i-peso = 2 THEN
        ASSIGN tt-ordens-desemb.de-peso-bruto = DEC(tt-ordens-desemb.de-peso-bruto:SCREEN-VALUE IN BROWSE brSon1).
    IF i-peso = 1 THEN 
        ASSIGN tt-ordens-desemb.de-peso-bruto-unit = DEC(tt-ordens-desemb.de-peso-bruto:SCREEN-VALUE IN BROWSE brSon1).
        
    RUN CalculaTotais IN THIS-PROCEDURE.
    RETURN.
END.

ON 'leave':U OF tt-ordens-desemb-acum.de-peso-bruto IN BROWSE brSon2 DO:
    ASSIGN de-tot-peso-bruto   = 0
           de-tot-peso-liquido = 0
           de-tot-cubagem      = 0
           tt-ordens-desemb-acum.de-peso-bruto = DEC(tt-ordens-desemb-acum.de-peso-bruto:SCREEN-VALUE IN BROWSE brSon2).
    RUN CalculaTotais IN THIS-PROCEDURE.
    RETURN.
END.

ON 'leave':U OF tt-ordens-desemb.de-peso-liquido IN BROWSE brSon1 DO:
    ASSIGN de-tot-peso-bruto   = 0
           de-tot-peso-liquido = 0
           de-tot-cubagem      = 0.
    IF i-peso = 2 THEN
        ASSIGN tt-ordens-desemb.de-peso-liquido = DEC(tt-ordens-desemb.de-peso-liquido:SCREEN-VALUE IN BROWSE brSon1).
    IF i-peso = 1 THEN
        ASSIGN tt-ordens-desemb.de-peso-liquido-unit = DEC(tt-ordens-desemb.de-peso-liquido:SCREEN-VALUE IN BROWSE brSon1).
    RUN CalculaTotais IN THIS-PROCEDURE.
    RETURN.
END.

ON 'leave':U OF tt-ordens-desemb-acum.de-peso-liquido IN BROWSE brSon2 DO:
    ASSIGN de-tot-peso-bruto   = 0
           de-tot-peso-liquido = 0
           de-tot-cubagem      = 0
           tt-ordens-desemb-acum.de-peso-liquido = DEC(tt-ordens-desemb-acum.de-peso-liquido:SCREEN-VALUE IN BROWSE brSon2).
    RUN CalculaTotais IN THIS-PROCEDURE.
    RETURN.
END.

ON 'leave':U OF tt-ordens-desemb.de-cubagem IN BROWSE brSon1 DO:
    ASSIGN de-tot-peso-bruto   = 0
           de-tot-peso-liquido = 0
           de-tot-cubagem      = 0.
    
    // Atualiza a informaá∆o com o que est† em tela
    ASSIGN INPUT BROWSE brSon1 tt-ordens-desemb.de-cubagem.
    
    // Joga a informaá∆o de tela para o respectivo campo da tabela, conforme ele foi informado em tela (campo Informa)
    IF  i-cubagem = 1 /* Unit†rio */ THEN
        ASSIGN tt-ordens-desemb.val-cub-unit = tt-ordens-desemb.de-cubagem.
    ELSE IF i-cubagem = 2 /* Total */ THEN DO:
        ASSIGN tt-ordens-desemb.val-cub-tot = tt-ordens-desemb.de-cubagem.
    END.
    
    RUN CalculaTotais IN THIS-PROCEDURE.
    RETURN.
END.

ON 'leave':U OF tt-ordens-desemb-acum.de-cubagem IN BROWSE brSon2 DO:
    ASSIGN de-tot-peso-bruto   = 0
           de-tot-peso-liquido = 0
           de-tot-cubagem      = 0.
           
    // Atualiza a informaá∆o com o que est† em tela
    ASSIGN INPUT BROWSE brSon2 tt-ordens-desemb-acum.de-cubagem.
    
    RUN CalculaTotais IN THIS-PROCEDURE.
    RETURN.
END.

ON ENTRY OF tt-ordens-desemb.cdn-adicao IN BROWSE brSon1
DO:
   ASSIGN i-cdn-adicao-ant = INPUT BROWSE brSon1 tt-ordens-desemb.cdn-adicao.
END.

ON LEAVE OF tt-ordens-desemb.cdn-adicao IN BROWSE brSon1
DO:
    BROWSE brson1:FETCH-SELECTED-ROW(1).
    brSon1:FETCH-SELECTED-ROW(brSon1:FOCUSED-ROW IN FRAME fPage0) IN FRAME fPage0 NO-ERROR.

    FIND FIRST param-imp NO-LOCK
      WHERE param-imp.cod-estabel = p-cod-estabel NO-ERROR.

    IF  (NOT l-fn-imp-adicao-un OR
         &IF '{&bf_mat_versao_ems}' < '2.07' &THEN
             SUBSTR(param-imp.char-1,105,1) = '0'
         &ELSE
             NOT param-imp.log-tax-siscomex
         &ENDIF) AND 

        CAN-FIND(FIRST b-tt-ordens-desemb
                     WHERE rowid(b-tt-ordens-desemb) <> rowid(tt-ordens-desemb)
                       AND b-tt-ordens-desemb.cdn-adicao = INPUT BROWSE brSon1 tt-ordens-desemb.cdn-adicao
                       AND b-tt-ordens-desemb.cdn-adicao <> 0
                       AND b-tt-ordens-desemb.c-un <> tt-ordens-desemb.c-un) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-un AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "UN" *}
        ASSIGN c-lbl-liter-un = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-unidade-de-medida AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Unidade_de_Medida" *}
        ASSIGN c-lbl-liter-unidade-de-medida = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 33557,
                           INPUT c-lbl-liter-un + "~~" +
                                 c-lbl-liter-unidade-de-medida).
        RETURN NO-APPLY.
    END.
    
    IF  CAN-FIND(FIRST b-tt-ordens-desemb
                     WHERE rowid(b-tt-ordens-desemb) <> rowid(tt-ordens-desemb)
                       AND b-tt-ordens-desemb.cdn-adicao = INPUT BROWSE brSon1 tt-ordens-desemb.cdn-adicao
                       AND b-tt-ordens-desemb.cdn-adicao <> 0
                       AND b-tt-ordens-desemb.c-class-fiscal <> tt-ordens-desemb.c-class-fiscal) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-classificacao AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Classificaá∆o" *}
        ASSIGN c-lbl-liter-classificacao = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-classificacao-fiscal AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Classificaá∆o_Fiscal" *}
        ASSIGN c-lbl-liter-classificacao-fiscal = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 33557,
                           INPUT c-lbl-liter-classificacao + "~~" +
                                 c-lbl-liter-classificacao-fiscal).
        RETURN NO-APPLY.
    END.

    IF  i-cdn-adicao-ant <> INPUT BROWSE brSon1 tt-ordens-desemb.cdn-adicao THEN DO:
        FIND FIRST b-tt-ordens-desemb 
             WHERE rowid(b-tt-ordens-desemb) <> rowid(tt-ordens-desemb)
               AND b-tt-ordens-desemb.cdn-adicao = INPUT BROWSE brSon1 tt-ordens-desemb.cdn-adicao EXCLUSIVE-LOCK NO-ERROR.
        IF  AVAIL b-tt-ordens-desemb THEN
            ASSIGN tt-ordens-desemb.de-taxa-siscomex = b-tt-ordens-desemb.de-taxa-siscomex.
        ELSE DO:
            IF  tt-ordens-desemb.de-taxa-siscomex <> 0 THEN
                ASSIGN l-alterou-tx-siscomex = YES.
            
            ASSIGN tt-ordens-desemb.de-taxa-siscomex = 0.
        END.
    END.
END.

&IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
   IF i-peso-cubagem = 1 /* Total */ THEN
      ASSIGN i-peso    = 2
             i-cubagem = 2. // Total
   ELSE
      ASSIGN i-peso    = 1
             i-cubagem = 1. // Unit†rio
&endif

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
    
    IF VALID-HANDLE(h-boin245) THEN DO:
        DELETE PROCEDURE h-boin245.
        ASSIGN h-boin245 = ?.
    END.

    IF VALID-HANDLE(h-boin292) THEN DO:
        DELETE PROCEDURE h-boin292.
        ASSIGN h-boin292 = ?.
    END.

    IF VALID-HANDLE(h-boin046na) THEN DO:
        DELETE PROCEDURE h-boin046na.
        ASSIGN h-boin046na = ?.
    END.
    
    IF VALID-HANDLE(h-bocx250) THEN DO:
        DELETE PROCEDURE h-bocx250.
        ASSIGN h-bocx250 = ?.
    END.

    IF VALID-HANDLE(h-bocx407) THEN DO:
        DELETE PROCEDURE h-bocx407.
        ASSIGN h-bocx407 = ?.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterinitializeinterface wMasterDetail 
PROCEDURE afterinitializeinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN brSon1:HIDDEN IN FRAME fPage0 = NO
           brSon2:HIDDEN IN FRAME fPage0 = YES
           brSon3:HIDDEN IN FRAME fPage0 = YES
           brSon1:NUM-LOCKED-COLUMNS IN FRAME fPage0 = 3
           brSon2:NUM-LOCKED-COLUMNS IN FRAME fPage0 = 2
           brSon3:NUM-LOCKED-COLUMNS IN FRAME fPage0 = 2.

    ENABLE i-peso
           i-quantidade 
           i-cubagem
           i-classifica
           btConfirm
           btReload
           brSon1
           WITH FRAME fPage0.

    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        ASSIGN i-peso:HIDDEN IN FRAME fPage0 = TRUE
               i-cubagem:HIDDEN IN FRAME fPage0 = TRUE.
            
        ENABLE i-peso-cubagem
               WITH FRAME fPage0.
    &ELSE
        ASSIGN i-peso-cubagem:HIDDEN IN FRAME fPage0 = TRUE.
    &ENDIF
    
    RUN findCodigo IN h-bocx250 (INPUT p-cod-estabel, OUTPUT c-erro).
    &IF "{&bf_mat_versao_ems}" >= "2.07" &THEN
        RUN getLogField IN h-bocx250 (INPUT "log-tax-siscomex",
                                      OUTPUT l-tax-siscomex).
    &ELSE
        RUN getCharField IN h-bocx250 (INPUT "char-1",
                                       OUTPUT c-tax-siscomex).
        ASSIGN l-tax-siscomex = IF INT(SUBSTR(c-tax-siscomex, 105, 1)) = 1 THEN YES ELSE NO.
    &ENDIF
    
    IF  NOT l-tax-siscomex THEN
        i-classifica:DELETE("Por Adiá‰es do Embarque") IN FRAME fPage0.
    
    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
     IF  i-pais-impto-usuario <> 1 THEN DO:
                i-classifica:DELETE("Por Adiá‰es do Embarque") IN FRAME fPage0 NO-ERROR.
         ASSIGN tt-ordens-desemb.cdn-adicao:VISIBLE IN BROWSE brSon1 = NO.
     END.
    &ENDIF
    
    RUN CalculaTotais IN THIS-PROCEDURE.

    {&OPEN-QUERY-brSon1}

    RUN pi-verifica-integracao-di.

    IF  AVAIL tt-embarque-imp THEN DO:
        /* Quando o embarque j† est† encerrado, n∆o pode alterar nada em tela */
        IF  tt-embarque-imp.situacao = 2 /* Encerrado */ THEN DO:
            DISABLE btConfirm
                    btReload
                WITH FRAME fPage0.

            ASSIGN tt-ordens-desemb.de-peso-bruto:READ-ONLY               IN BROWSE brSon1 = YES
                   tt-ordens-desemb.de-peso-liquido:READ-ONLY             IN BROWSE brSon1 = YES
                   tt-ordens-desemb.de-cubagem:READ-ONLY                  IN BROWSE brSon1 = YES
                   tt-ordens-desemb.cdn-adicao:READ-ONLY                  IN BROWSE brSon1 = YES
                   tt-ordens-desemb.seq-item:READ-ONLY                    IN BROWSE brSon1 = YES

                   tt-ordens-desemb-acum.de-peso-bruto:READ-ONLY          IN BROWSE brSon2 = YES
                   tt-ordens-desemb-acum.de-peso-liquido:READ-ONLY        IN BROWSE brSon2 = YES
                   tt-ordens-desemb-acum.de-cubagem:READ-ONLY             IN BROWSE brSon2 = YES

                   tt-ordens-desemb-acum-adicao.de-peso-bruto:READ-ONLY   IN BROWSE brSon3 = YES
                   tt-ordens-desemb-acum-adicao.de-peso-liquido:READ-ONLY IN BROWSE brSon3 = YES
                   tt-ordens-desemb-acum-adicao.de-cubagem:READ-ONLY      IN BROWSE brSon3 = YES.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyOffEnd wMasterDetail 
PROCEDURE applyOffEnd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CalculaTotais wMasterDetail 
PROCEDURE CalculaTotais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 IF INPUT FRAME fPage0 i-classifica = 1 THEN DO:
    FOR EACH bf-tt-ordens-desemb EXCLUSIVE-LOCK:
       /* Peso Embal */
       &IF "{&bf_mat_versao_ems}" >= "2.062"  &THEN
            ASSIGN bf-tt-ordens-desemb.de-peso-embal = bf-tt-ordens-desemb.de-peso-bruto - bf-tt-ordens-desemb.de-peso-liquido.
       &ENDIF
       
        IF INPUT FRAME fPage0 i-peso = 1 THEN
            ASSIGN  de-tot-peso-bruto   = de-tot-peso-bruto   + bf-tt-ordens-desemb.de-peso-bruto-unit   &if "{&bf_mat_versao_ems}" < "2.062" &then * bf-tt-ordens-desemb.quantidade &endif
                    de-tot-peso-liquido = de-tot-peso-liquido + bf-tt-ordens-desemb.de-peso-liquido-unit &if "{&bf_mat_versao_ems}" < "2.062" &then * bf-tt-ordens-desemb.quantidade &endif.
        ELSE
            ASSIGN  de-tot-peso-bruto   = de-tot-peso-bruto   + bf-tt-ordens-desemb.de-peso-bruto
                    de-tot-peso-liquido = de-tot-peso-liquido + bf-tt-ordens-desemb.de-peso-liquido.

        IF  INPUT FRAME fPage0 i-cubagem = 1 /* Unit†rio */ THEN
            ASSIGN de-tot-cubagem       = de-tot-cubagem      + bf-tt-ordens-desemb.val-cub-unit.   
        ELSE
            ASSIGN de-tot-cubagem       = de-tot-cubagem      + bf-tt-ordens-desemb.val-cub-tot.
    END.
 END.
 ELSE DO:
    FOR EACH bf-tt-ordens-desemb-acum EXCLUSIVE-LOCK:
        /* Peso Embal */
        &IF "{&bf_mat_versao_ems}" >= "2.062"  &THEN
             ASSIGN bf-tt-ordens-desemb-acum.de-peso-embal = bf-tt-ordens-desemb-acum.de-peso-bruto - bf-tt-ordens-desemb-acum.de-peso-liquido.
        &ENDIF
        ASSIGN  de-tot-peso-bruto   = de-tot-peso-bruto   + bf-tt-ordens-desemb-acum.de-peso-bruto
                de-tot-peso-liquido = de-tot-peso-liquido + bf-tt-ordens-desemb-acum.de-peso-liquido
                de-tot-cubagem      = de-tot-cubagem      + bf-tt-ordens-desemb-acum.de-cubagem.  
    END.
 END.
   
 ASSIGN vl-tot-peso-bruto:SCREEN-VALUE IN FRAME fPage0 = string(de-tot-peso-bruto)   
        vl-tot-peso-liq  :SCREEN-VALUE IN FRAME fPage0 = string(de-tot-peso-liquido) 
        vl-tot-cubagem   :SCREEN-VALUE IN FRAME fPage0 = string(de-tot-cubagem).
 
 RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE countNumOrdensEmbarque wMasterDetail 
PROCEDURE countNumOrdensEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN inumRowsReturned = 0.
    RUN countNumOrdensEmbarque IN {&hDBOSon1} (INPUT tt-embarque-imp.cod-estabel,
                                               INPUT tt-embarque-imp.embarque,
                                               OUTPUT inumRowsReturned).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createOrdensDesemb wMasterDetail 
PROCEDURE createOrdensDesemb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER p-recarrega      AS LOGICAL NO-UNDO.
    DEF INPUT PARAMETER p-peso-bruto     AS LOGICAL NO-UNDO.
    DEF INPUT PARAMETER p-peso-liquid    AS LOGICAL NO-UNDO.
    DEF INPUT PARAMETER p-cubagem        AS LOGICAL NO-UNDO.
    
    RUN loadOrdensDesemb IN {&hDBOSon1} (INPUT TABLE tt-ordens-embarque,
                                         INPUT "",
                                         INPUT "",
                                         INPUT p-recarrega,
                                         INPUT p-icms-diferido,
                                         INPUT (i-peso = 2),
                                         INPUT p-recarrega, /* II   */
                                         INPUT p-recarrega, /* ipi  */
                                         INPUT p-recarrega, /* icms */
                                         INPUT p-recarrega, /* pis  */
                                         INPUT p-recarrega, /* cof  */
                                         INPUT p-recarrega, /* IBS UF  */
                                         INPUT p-recarrega, /* IBS Mun */
                                         INPUT p-recarrega, /* CBS  */
                                         INPUT p-recarrega, /* IS */
                                         INPUT p-peso-bruto,
                                         INPUT p-peso-liquid,
                                         INPUT p-cubagem,
                                         OUTPUT TABLE tt-ordens-desemb,
                                         OUTPUT TABLE tt-bo-erro).

     &if "{&bf_mat_versao_ems}" >= "2.062" &then
        IF  l-primeiro THEN DO:
            FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK:
                IF  INPUT FRAME fpage0 i-cubagem = 2 THEN /* Total */
                    ASSIGN tt-ordens-desemb.de-cubagem = tt-ordens-desemb.val-cub-tot.
                ELSE /* Unit†rio */
                    ASSIGN tt-ordens-desemb.de-cubagem = tt-ordens-desemb.val-cub-unit.
            END.
        END.
        ELSE DO:
            IF  p-peso-liquid THEN DO:
                FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK:
                    IF  INPUT FRAME fpage0 i-peso-cubagem = 1 THEN /* Total */
                        ASSIGN tt-ordens-desemb.de-peso-liquido = tt-ordens-desemb.de-peso-liquido-unit * tt-ordens-desemb.quantidade
                               tt-ordens-desemb.de-cubagem      = tt-ordens-desemb.val-cub-tot.
                    ELSE /* Unit†rio */
                        ASSIGN tt-ordens-desemb.de-peso-liquido = tt-ordens-desemb.de-peso-liquido-unit
                               tt-ordens-desemb.de-cubagem      = tt-ordens-desemb.val-cub-unit.
                END.
            END.
        END.
        
        ASSIGN l-primeiro = NO.
    &endif

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createOrdensDesembAcum wMasterDetail 
PROCEDURE createOrdensDesembAcum :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Criaá∆o da tt-ordens-desemb-acum (tt-ordens-desemb acumulada por classificaá∆o fiscal e unidade)*/
    EMPTY TEMP-TABLE tt-ordens-desemb-acum.
    EMPTY TEMP-TABLE tt-ordens-desemb-acum-adicao.

    FIND FIRST param-imp NO-LOCK
        WHERE  param-imp.cod-estabel = p-cod-estabel NO-ERROR.

    IF  i-classifica = 3 THEN DO:
        IF NOT l-fn-imp-adicao-un OR
           &IF '{&bf_mat_versao_ems}' < '2.07' &THEN
               SUBSTR(param-imp.char-1,105,1) = '0'
           &ELSE
               NOT param-imp.log-tax-siscomex
           &ENDIF THEN DO:
            {imp/im0100c.i "BY tt-ordens-desemb.cdn-adicao"
                           "FIRST-OF(tt-ordens-desemb.cdn-adicao) OR"
                           "LAST-OF(tt-ordens-desemb.cdn-adicao) OR"}

            FOR EACH tt-ordens-desemb-acum EXCLUSIVE-LOCK:
                CREATE tt-ordens-desemb-acum-adicao.
                BUFFER-COPY tt-ordens-desemb-acum TO tt-ordens-desemb-acum-adicao.
            END.
        END.
        ELSE DO:
            {imp/im0100c.i1}
        END.
    END.
    ELSE DO:
        {imp/im0100c.i}
    END.
    
    EMPTY TEMP-TABLE tt-ordens-desemb-acum-aux.
    FOR EACH tt-ordens-desemb-acum EXCLUSIVE-LOCK:
        CREATE tt-ordens-desemb-acum-aux.
        BUFFER-COPY tt-ordens-desemb-acum TO tt-ordens-desemb-acum-aux.
    END.

    IF l-fn-imp-adicao-un OR
      &IF '{&bf_mat_versao_ems}' < '2.07' &THEN
          SUBSTR(param-imp.char-1,105,1) = '1'
      &ELSE
          param-imp.log-tax-siscomex
      &ENDIF THEN DO:
        EMPTY TEMP-TABLE tt-ordens-desemb-acum-adicao-aux.
        FOR EACH tt-ordens-desemb-acum-adicao EXCLUSIVE-LOCK:
            CREATE tt-ordens-desemb-acum-adicao-aux.
            BUFFER-COPY tt-ordens-desemb-acum-adicao TO tt-ordens-desemb-acum-adicao-aux.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteOrdensDesemb wMasterDetail 
PROCEDURE deleteOrdensDesemb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK:
        DELETE tt-ordens-desemb.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR c-return AS CHAR NO-UNDO.
    
    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "cxbo/bocx220.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx220.p YES}
        {btb/btb008za.i2 cxbo/bocx220.p '' {&hDBOParent}} 
    END.
    
    RUN setConstraint1 IN {&hDBOParent} NO-ERROR.
    RUN openQuery      IN {&hDBOParent} (INPUT 1) NO-ERROR.
    RUN findPk_Codigo  IN {&hDBOParent} (INPUT p-cod-estabel,
                                         INPUT p-embarque,
                                         OUTPUT c-return).
    IF c-return = "" THEN
        RUN getRowid IN {&hDBOParent} (OUTPUT gr-embarque-imp).
    
    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "cxbo/bocx225e.p":U THEN DO:
        RUN cxbo/bocx225e.p PERSISTENT SET {&hDBOSon1}.
    END.

    IF NOT VALID-HANDLE(h-boin046na) OR
       h-boin046na:TYPE <> "PROCEDURE":U OR
       h-boin046na:FILE-NAME <> "inbo/boin046na.p":U THEN DO:
        RUN inbo/boin046na.p PERSISTENT SET h-boin046na.
        RUN openQueryStatic IN h-boin046na (INPUT "Main":U).
    END.
    
    IF  NOT VALID-HANDLE(h-bocx250) OR
        h-bocx250:TYPE <> "PROCEDURE":U OR
        h-bocx250:FILE-NAME <> "cxbo/bocx250.p":U THEN DO:
        RUN cxbo/bocx250.p PERSISTENT SET h-bocx250.
        RUN openQuery IN h-bocx250 (INPUT "1":U).
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    RUN countNumOrdensEmbarque IN THIS-PROCEDURE.

    RUN deleteOrdensDesemb IN THIS-PROCEDURE.

    IF VALID-HANDLE({&hDBOSon1}) THEN DO:
        RUN setConstraint2  IN {&hDBOSon1} (INPUT tt-embarque-imp.cod-estabel,
                                            INPUT tt-embarque-imp.embarque).
        RUN openQuery       IN {&hDBOSon1} (INPUT 2) NO-ERROR.
        RUN findFirst       IN {&hDBOSon1}.
        RUN serverSendRows  IN {&hDBOSon1} (input  ?,                      
                                            input  ?,                     
                                            input  NO,                      
                                            input  0,     
                                            output iNrRegistro,
                                            output table {&ttSon1}).
                
        RUN createOrdensDesemb IN THIS-PROCEDURE (INPUT NO,
                                                  INPUT NO,
                                                  INPUT NO,
                                                  INPUT NO).

        {&OPEN-QUERY-brSon1}
        APPLY "VALUE-CHANGED":U TO BROWSE brSon1.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-integracao-di wMasterDetail 
PROCEDURE pi-verifica-integracao-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE l-retorno AS LOGICAL  INITIAL NO NO-UNDO.

IF NOT VALID-HANDLE(h-bocx407) THEN
    RUN cxbo\bocx407.p PERSISTENT SET h-bocx407.

RUN pi-valida-integracao-di IN h-bocx407(INPUT INPUT FRAME fPage0 tt-embarque-imp.embarque,
                                         INPUT INPUT FRAME fPage0 tt-embarque-imp.cod-estabel,
                                         OUTPUT l-retorno).
IF l-retorno THEN DO:

    DISABLE btConfirm
            btReload WITH FRAME fPage0.      

    ASSIGN tt-ordens-desemb-acum-adicao.de-peso-bruto  :READ-ONLY IN BROWSE brSon3 = YES
           tt-ordens-desemb-acum-adicao.de-peso-liquido:READ-ONLY IN BROWSE brSon3 = YES
           tt-ordens-desemb-acum-adicao.de-cubagem     :READ-ONLY IN BROWSE brSon3 = YES
           tt-ordens-desemb.de-peso-bruto              :READ-ONLY IN BROWSE brSon1 = YES
           tt-ordens-desemb.de-peso-liquido            :READ-ONLY IN BROWSE brSon1 = YES
           tt-ordens-desemb.de-cubagem                 :READ-ONLY IN BROWSE brSon1 = YES
           tt-ordens-desemb.cdn-adicao                 :READ-ONLY IN BROWSE brSon1 = YES
           tt-ordens-desemb.seq-item                   :READ-ONLY IN BROWSE brSon1 = YES
           tt-ordens-desemb-acum.de-peso-bruto         :READ-ONLY IN BROWSE brSon2 = YES
           tt-ordens-desemb-acum.de-peso-liquido       :READ-ONLY IN BROWSE brSon2 = YES
           tt-ordens-desemb-acum.de-cubagem            :READ-ONLY IN BROWSE brSon2 = YES.

END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateCubagem wMasterDetail 
PROCEDURE updateCubagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN  de-tot-cubagem = 0.

    FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK:
        IF  i-cubagem-ant = 2 /* Total */ THEN 
            ASSIGN tt-ordens-desemb.val-cub-tot  = tt-ordens-desemb.de-cubagem.
                   
        IF  i-cubagem-ant = 1 /* Unit†rio */ THEN 
            ASSIGN tt-ordens-desemb.val-cub-unit = tt-ordens-desemb.de-cubagem.
    END.
    
    ASSIGN i-cubagem-ant = 0.

    FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK:
        IF INPUT FRAME fPage0 i-cubagem = 2 /* Total */ THEN
            ASSIGN tt-ordens-desemb.de-cubagem = tt-ordens-desemb.val-cub-tot.
        ELSE
            ASSIGN tt-ordens-desemb.de-cubagem = tt-ordens-desemb.val-cub-unit.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateCubagemTotal wMasterDetail 
PROCEDURE updateCubagemTotal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if "{&bf_mat_versao_ems}" >= "2.062" &then
        ASSIGN  de-tot-cubagem = 0.
    
        FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK:
            IF  i-cubagem-ant = 2 /* Total */ THEN 
                ASSIGN tt-ordens-desemb.de-cubagem =  tt-ordens-desemb.val-cub-tot.
            ELSE IF  i-cubagem-ant = 1 /* Unit†rio */ THEN 
                ASSIGN tt-ordens-desemb.de-cubagem = tt-ordens-desemb.val-cub-unit.
        END.
        
        ASSIGN i-cubagem-ant = 0.
    &endif

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateOrdensDesemb wMasterDetail 
PROCEDURE updateOrdensDesemb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN  de-tot-peso-bruto   = 0
            de-tot-peso-liquido = 0
            de-tot-cubagem      = 0.

    FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK:
        IF  i-peso-ant = 2 THEN 
            ASSIGN tt-ordens-desemb.de-peso-bruto-unit   = tt-ordens-desemb.de-peso-bruto   / tt-ordens-desemb.quantidade
                   tt-ordens-desemb.de-peso-liquido-unit = tt-ordens-desemb.de-peso-liquido / tt-ordens-desemb.quantidade.
        
        IF  i-peso-ant = 1 THEN 
            ASSIGN  tt-ordens-desemb.de-peso-bruto-unit   = tt-ordens-desemb.de-peso-bruto
                    tt-ordens-desemb.de-peso-liquido-unit = tt-ordens-desemb.de-peso-liquido.

        IF  i-cubagem-ant = 2 /* Total */ THEN 
            ASSIGN tt-ordens-desemb.val-cub-tot = tt-ordens-desemb.de-cubagem.
                   
        IF  i-cubagem-ant = 1 /* Unit†rio */ THEN 
            ASSIGN tt-ordens-desemb.val-cub-unit = tt-ordens-desemb.de-cubagem .
    END.
    
    ASSIGN i-peso-ant    = 0
           i-cubagem-ant = 0.

    FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK:
        IF INPUT FRAME fPage0 i-cubagem = 2 /* Total */ THEN
            ASSIGN tt-ordens-desemb.de-cubagem = tt-ordens-desemb.val-cub-tot.
        ELSE
            ASSIGN tt-ordens-desemb.de-cubagem = tt-ordens-desemb.val-cub-unit.
        
        IF INPUT FRAME fPage0 i-quantidade = 1 THEN /* interna */
            ASSIGN tt-ordens-desemb.de-quantidade = tt-ordens-desemb.quantidade
                   tt-ordens-desemb.c-un          = tt-ordens-desemb.c-un-item.
        ELSE                    /* fornecedor */
            ASSIGN tt-ordens-desemb.de-quantidade = tt-ordens-desemb.qt-do-forn
                   tt-ordens-desemb.c-un          = tt-ordens-desemb.c-un-fornec.
    
        IF INPUT FRAME fPage0 i-peso = 1 THEN 
            ASSIGN tt-ordens-desemb.de-peso-bruto   = tt-ordens-desemb.de-peso-bruto-unit
                   tt-ordens-desemb.de-peso-liquido = tt-ordens-desemb.de-peso-liquido-unit.
        ELSE 
            ASSIGN tt-ordens-desemb.de-peso-bruto   = tt-ordens-desemb.de-peso-bruto-unit   * tt-ordens-desemb.quantidade
                   tt-ordens-desemb.de-peso-liquido = tt-ordens-desemb.de-peso-liquido-unit * tt-ordens-desemb.quantidade.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateOrdensDesemb2 wMasterDetail 
PROCEDURE updateOrdensDesemb2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE de-diferenca-peso-bruto   AS DECIMAL FORMAT ">>>>>,>>>,>>9.9999999999"   NO-UNDO.
DEFINE VARIABLE de-diferenca-peso-liq     AS DECIMAL FORMAT ">>>>>,>>>,>>9.9999999999"   NO-UNDO.
DEFINE VARIABLE de-diferenca-cubagem      AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999"        NO-UNDO.
DEFINE VARIABLE de-tot-peso-bruto-rateado AS DECIMAL FORMAT ">>>>>,>>>,>>9.9999999999"   NO-UNDO.
DEFINE VARIABLE de-tot-peso-liq-rateado   AS DECIMAL FORMAT ">>>>>,>>>,>>9.9999999999"   NO-UNDO.
DEFINE VARIABLE de-tot-cubagem-rateado    AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999"        NO-UNDO.

  ASSIGN l-atualiza-pesos = NO.
  FOR EACH tt-ordens-desemb-acum-aux EXCLUSIVE-LOCK:
      IF CAN-FIND(FIRST  tt-ordens-desemb-acum
                  WHERE  tt-ordens-desemb-acum.cdn-adicao       = tt-ordens-desemb-acum-aux.cdn-adicao
                    AND  tt-ordens-desemb-acum.c-class-fiscal   = tt-ordens-desemb-acum-aux.c-class-fiscal
                    AND  tt-ordens-desemb-acum.c-un             = tt-ordens-desemb-acum-aux.c-un
                    AND (tt-ordens-desemb-acum.de-peso-bruto   <> tt-ordens-desemb-acum-aux.de-peso-bruto
                     OR  tt-ordens-desemb-acum.de-peso-liquido <> tt-ordens-desemb-acum-aux.de-peso-liquido
                     OR  tt-ordens-desemb-acum.de-cubagem      <> tt-ordens-desemb-acum-aux.de-cubagem)) THEN DO:
          ASSIGN l-atualiza-pesos = YES.
          LEAVE.
      END.
  END.
  /*IF l-fn-imp-adicao-un 
  AND NOT l-atualiza-pesos THEN
      FOR EACH tt-ordens-desemb-acum-adicao-aux EXCLUSIVE-LOCK:
          IF CAN-FIND(FIRST  tt-ordens-desemb-acum-adicao
                      WHERE  tt-ordens-desemb-acum-adicao.cdn-adicao       = tt-ordens-desemb-acum-adicao-aux.cdn-adicao
                        AND  tt-ordens-desemb-acum-adicao.c-class-fiscal   = tt-ordens-desemb-acum-adicao-aux.c-class-fiscal
                        AND  tt-ordens-desemb-acum-adicao.c-un             = tt-ordens-desemb-acum-adicao-aux.c-un
                        AND (tt-ordens-desemb-acum-adicao.de-peso-bruto   <> tt-ordens-desemb-acum-adicao-aux.de-peso-bruto
                         OR  tt-ordens-desemb-acum-adicao.de-peso-liquido <> tt-ordens-desemb-acum-adicao-aux.de-peso-liquido
                         OR  tt-ordens-desemb-acum-adicao.de-cubagem      <> tt-ordens-desemb-acum-adicao-aux.de-cubagem)) THEN DO:
              ASSIGN l-atualiza-pesos = YES.
              LEAVE.
          END.
      END.*/
  
  FOR EACH tt-ordens-desemb-acum EXCLUSIVE-LOCK:

      ASSIGN de-tot-peso-bruto-rateado = 0
             de-tot-peso-liq-rateado   = 0
             de-tot-cubagem-rateado    = 0.

      FOR EACH bf-tt-ordens-desemb EXCLUSIVE-LOCK
         WHERE /*bf-tt-ordens-desemb.cdn-adicao     = tt-ordens-desemb-acum.cdn-adicao
           AND*/ bf-tt-ordens-desemb.c-class-fiscal = tt-ordens-desemb-acum.c-class-fiscal
           AND bf-tt-ordens-desemb.c-un           = tt-ordens-desemb-acum.c-un:

          /* Quando informado o total, truncar em 5 casas que eh o tamanho da ordens embarque por causa de problemas de arredondamento */
          IF l-atualiza-pesos AND i-classifica = 2 THEN
              ASSIGN bf-tt-ordens-desemb.de-peso-bruto   = truncate((tt-ordens-desemb-acum.de-peso-bruto   * bf-tt-ordens-desemb.de-quantidade ) / tt-ordens-desemb-acum.de-quantidade, 5)
                     bf-tt-ordens-desemb.de-peso-liquido = truncate((tt-ordens-desemb-acum.de-peso-liquido * bf-tt-ordens-desemb.de-quantidade ) / tt-ordens-desemb-acum.de-quantidade, 5)
                     bf-tt-ordens-desemb.de-cubagem      = truncate((tt-ordens-desemb-acum.de-cubagem      * bf-tt-ordens-desemb.de-quantidade ) / tt-ordens-desemb-acum.de-quantidade, 5)
                     de-tot-peso-bruto-rateado           = truncate(de-tot-peso-bruto-rateado + bf-tt-ordens-desemb.de-peso-bruto, 5)  
                     de-tot-peso-liq-rateado             = truncate(de-tot-peso-liq-rateado   + bf-tt-ordens-desemb.de-peso-liquido, 5)
                     de-tot-cubagem-rateado              = truncate(de-tot-cubagem-rateado    + bf-tt-ordens-desemb.de-cubagem, 5).
          ELSE
              IF l-atualiza-pesos THEN
                  ASSIGN bf-tt-ordens-desemb.de-peso-bruto   = (tt-ordens-desemb-acum.de-peso-bruto   * bf-tt-ordens-desemb.de-quantidade ) / tt-ordens-desemb-acum.de-quantidade
                         bf-tt-ordens-desemb.de-peso-liquido = (tt-ordens-desemb-acum.de-peso-liquido * bf-tt-ordens-desemb.de-quantidade ) / tt-ordens-desemb-acum.de-quantidade
                         bf-tt-ordens-desemb.de-cubagem      = (tt-ordens-desemb-acum.de-cubagem      * bf-tt-ordens-desemb.de-quantidade ) / tt-ordens-desemb-acum.de-quantidade
                         de-tot-peso-bruto-rateado           = de-tot-peso-bruto-rateado + bf-tt-ordens-desemb.de-peso-bruto
                         de-tot-peso-liq-rateado             = de-tot-peso-liq-rateado   + bf-tt-ordens-desemb.de-peso-liquido
                         de-tot-cubagem-rateado              = de-tot-cubagem-rateado    + bf-tt-ordens-desemb.de-cubagem.
      END.

      /* Quando informado o total, truncar em 5 casas que eh o tamanho da ordens embarque por causa de problemas de arredondamento */  
      /* problema ocorre principalmente quando tem-se dizimas ex.: 3,33333333333 - chamado TQNSIM */
      IF l-atualiza-pesos AND i-classifica = 2 THEN 
          IF de-tot-peso-bruto-rateado <> tt-ordens-desemb-acum.de-peso-bruto   OR 
             de-tot-peso-liq-rateado   <> tt-ordens-desemb-acum.de-peso-liquido OR 
             de-tot-cubagem-rateado    <> tt-ordens-desemb-acum.de-cubagem THEN DO:
              
              ASSIGN de-diferenca-peso-bruto = truncate(tt-ordens-desemb-acum.de-peso-bruto   - de-tot-peso-bruto-rateado ,5)
                     de-diferenca-peso-liq   = truncate(tt-ordens-desemb-acum.de-peso-liquido - de-tot-peso-liq-rateado, 5)
                     de-diferenca-cubagem    = truncate(tt-ordens-desemb-acum.de-cubagem      - de-tot-cubagem-rateado, 5).
              
              IF de-diferenca-peso-bruto >= -0.00009 AND  de-diferenca-peso-bruto <= 0.00009 THEN DO:
                  REPEAT WHILE de-diferenca-peso-bruto <> 0:
                       FOR EACH bf-tt-ordens-desemb EXCLUSIVE-LOCK
                          WHERE bf-tt-ordens-desemb.c-class-fiscal = tt-ordens-desemb-acum.c-class-fiscal
                            AND bf-tt-ordens-desemb.c-un           = tt-ordens-desemb-acum.c-un
                             BY bf-tt-ordens-desemb.de-peso-bruto: 
    
                           IF de-diferenca-peso-bruto > 0 THEN
                               ASSIGN bf-tt-ordens-desemb.de-peso-bruto   = bf-tt-ordens-desemb.de-peso-bruto  + 0.00001
                                      de-diferenca-peso-bruto             = de-diferenca-peso-bruto - 0.00001.
                           ELSE
                               ASSIGN bf-tt-ordens-desemb.de-peso-bruto   = bf-tt-ordens-desemb.de-peso-bruto  - 0.00001
                                      de-diferenca-peso-bruto             = de-diferenca-peso-bruto + 0.00001.
    
                           LEAVE.     
                       END.
                  END.
              END.
              ELSE DO:
                  FIND LAST bf-tt-ordens-desemb
                      WHERE bf-tt-ordens-desemb.c-class-fiscal = tt-ordens-desemb-acum.c-class-fiscal
                        AND bf-tt-ordens-desemb.c-un           = tt-ordens-desemb-acum.c-un EXCLUSIVE-LOCK NO-ERROR.
    
                  IF AVAIL bf-tt-ordens-desemb THEN
                      ASSIGN bf-tt-ordens-desemb.de-peso-bruto   = bf-tt-ordens-desemb.de-peso-bruto   + de-diferenca-peso-bruto.
              END.

              IF de-diferenca-peso-liq >= -0.00009 AND de-diferenca-peso-liq <= 0.00009 THEN DO:
                  REPEAT WHILE de-diferenca-peso-liq <> 0:
                       FOR EACH bf-tt-ordens-desemb EXCLUSIVE-LOCK
                          WHERE bf-tt-ordens-desemb.c-class-fiscal = tt-ordens-desemb-acum.c-class-fiscal
                            AND bf-tt-ordens-desemb.c-un           = tt-ordens-desemb-acum.c-un
                             BY bf-tt-ordens-desemb.de-peso-liquido: 
    
                           IF de-diferenca-peso-liq > 0 THEN
                               ASSIGN bf-tt-ordens-desemb.de-peso-liquido = bf-tt-ordens-desemb.de-peso-liquido  + 0.00001
                                      de-diferenca-peso-liq               = de-diferenca-peso-liq - 0.00001.
                           ELSE
                               ASSIGN bf-tt-ordens-desemb.de-peso-liquido = bf-tt-ordens-desemb.de-peso-liquido   - 0.00001
                                      de-diferenca-peso-liq               = de-diferenca-peso-liq + 0.00001.
    
                           LEAVE.
                       END.
                  END.
              END.
              ELSE DO:
                  FIND LAST bf-tt-ordens-desemb
                      WHERE bf-tt-ordens-desemb.c-class-fiscal = tt-ordens-desemb-acum.c-class-fiscal
                        AND bf-tt-ordens-desemb.c-un           = tt-ordens-desemb-acum.c-un EXCLUSIVE-LOCK NO-ERROR.
    
                  IF AVAIL bf-tt-ordens-desemb THEN
                      ASSIGN  bf-tt-ordens-desemb.de-peso-liquido = bf-tt-ordens-desemb.de-peso-liquido + de-diferenca-peso-liq.
              END.
              
              IF de-diferenca-cubagem >= 0.00009 AND de-diferenca-cubagem <= 0.00009 THEN DO:
                  REPEAT WHILE de-diferenca-cubagem <> 0:
                       FOR EACH bf-tt-ordens-desemb EXCLUSIVE-LOCK
                          WHERE bf-tt-ordens-desemb.c-class-fiscal = tt-ordens-desemb-acum.c-class-fiscal
                            AND bf-tt-ordens-desemb.c-un           = tt-ordens-desemb-acum.c-un
                             BY bf-tt-ordens-desemb.de-cubagem: 
    
                           IF de-diferenca-cubagem > 0 THEN
                               ASSIGN bf-tt-ordens-desemb.de-cubagem = bf-tt-ordens-desemb.de-cubagem   + 0.00001
                                      de-diferenca-cubagem           = de-diferenca-cubagem - 0.00001.
                           ELSE
                               ASSIGN bf-tt-ordens-desemb.de-cubagem = bf-tt-ordens-desemb.de-cubagem   - 0.00001
                                      de-diferenca-cubagem           = de-diferenca-cubagem + 0.00001.
    
                           LEAVE.
                       END.
                  END.
              END.
              ELSE DO:
                  FIND LAST bf-tt-ordens-desemb
                      WHERE bf-tt-ordens-desemb.c-class-fiscal = tt-ordens-desemb-acum.c-class-fiscal
                        AND bf-tt-ordens-desemb.c-un           = tt-ordens-desemb-acum.c-un EXCLUSIVE-LOCK NO-ERROR.
    
                  IF AVAIL bf-tt-ordens-desemb THEN
                      ASSIGN bf-tt-ordens-desemb.de-cubagem      = bf-tt-ordens-desemb.de-cubagem      + de-diferenca-cubagem.

              END.
          END.
      ELSE
          IF l-atualiza-pesos THEN
              IF de-tot-peso-bruto-rateado <> tt-ordens-desemb-acum.de-peso-bruto   OR 
                 de-tot-peso-liq-rateado   <> tt-ordens-desemb-acum.de-peso-liquido OR 
                 de-tot-cubagem-rateado    <> tt-ordens-desemb-acum.de-cubagem THEN DO:
                  
                  ASSIGN de-diferenca-peso-bruto = tt-ordens-desemb-acum.de-peso-bruto   - de-tot-peso-bruto-rateado
                         de-diferenca-peso-liq   = tt-ordens-desemb-acum.de-peso-liquido - de-tot-peso-liq-rateado
                         de-diferenca-cubagem    = tt-ordens-desemb-acum.de-cubagem      - de-tot-cubagem-rateado.
    
                  
                  FIND LAST bf-tt-ordens-desemb
                      WHERE bf-tt-ordens-desemb.c-class-fiscal = tt-ordens-desemb-acum.c-class-fiscal
                        AND bf-tt-ordens-desemb.c-un           = tt-ordens-desemb-acum.c-un EXCLUSIVE-LOCK NO-ERROR.
    
                  IF AVAIL bf-tt-ordens-desemb THEN
                      ASSIGN bf-tt-ordens-desemb.de-peso-bruto   = bf-tt-ordens-desemb.de-peso-bruto   + de-diferenca-peso-bruto
                             bf-tt-ordens-desemb.de-peso-liquido = bf-tt-ordens-desemb.de-peso-liquido + de-diferenca-peso-liq
                             bf-tt-ordens-desemb.de-cubagem      = bf-tt-ordens-desemb.de-cubagem      + de-diferenca-cubagem.
              END.
  END.
  
  FIND FIRST param-imp NO-LOCK
      WHERE param-imp.cod-estabel = p-cod-estabel NO-ERROR.

  IF l-fn-imp-adicao-un OR 
      &IF '{&bf_mat_versao_ems}' < '2.07' &THEN
          SUBSTR(param-imp.char-1,105,1) = '1'
      &ELSE
          param-imp.log-tax-siscomex
      &ENDIF THEN
      IF i-classifica     = 3
      OR i-classifica-ant = 3 THEN DO:
          
          FOR EACH tt-ordens-desemb-acum-adicao EXCLUSIVE-LOCK:
              IF NOT CAN-FIND(FIRST tt-ordens-desemb-acum-adicao-aux
                             WHERE  tt-ordens-desemb-acum-adicao-aux.cdn-adicao       = tt-ordens-desemb-acum-adicao.cdn-adicao
                               AND  tt-ordens-desemb-acum-adicao-aux.c-class-fiscal   = tt-ordens-desemb-acum-adicao.c-class-fiscal
                               AND  tt-ordens-desemb-acum-adicao-aux.c-un             = tt-ordens-desemb-acum-adicao.c-un
                               AND (tt-ordens-desemb-acum-adicao-aux.de-peso-bruto   <> tt-ordens-desemb-acum-adicao.de-peso-bruto
                                OR  tt-ordens-desemb-acum-adicao-aux.de-peso-liquido <> tt-ordens-desemb-acum-adicao.de-peso-liquido
                                OR  tt-ordens-desemb-acum-adicao-aux.de-cubagem      <> tt-ordens-desemb-acum-adicao.de-cubagem)) THEN NEXT.
              
              FOR EACH bf-tt-ordens-desemb EXCLUSIVE-LOCK
                 WHERE bf-tt-ordens-desemb.cdn-adicao     = tt-ordens-desemb-acum-adicao.cdn-adicao
                   AND bf-tt-ordens-desemb.c-class-fiscal = tt-ordens-desemb-acum-adicao.c-class-fiscal:
    
                  FIND FIRST item 
                      WHERE item.it-codigo = bf-tt-ordens-desemb.c-it-codigo NO-LOCK NO-ERROR.
                  FIND FIRST classif-fisc 
                      WHERE classif-fisc.class-fiscal = item.class-fiscal NO-LOCK NO-ERROR.

                  IF bf-tt-ordens-desemb.c-un <> classif-fisc.unidade THEN
                      ASSIGN bf-tt-ordens-desemb.de-peso-bruto   = (tt-ordens-desemb-acum-adicao.de-peso-bruto   * bf-tt-ordens-desemb.de-quantidade ) / (tt-ordens-desemb-acum-adicao.de-quantidade * item.fator-conver) 
                             bf-tt-ordens-desemb.de-peso-liquido = (tt-ordens-desemb-acum-adicao.de-peso-liquido * bf-tt-ordens-desemb.de-quantidade ) / (tt-ordens-desemb-acum-adicao.de-quantidade * item.fator-conver) 
                             bf-tt-ordens-desemb.de-cubagem      = (tt-ordens-desemb-acum-adicao.de-cubagem      * bf-tt-ordens-desemb.de-quantidade ) / (tt-ordens-desemb-acum-adicao.de-quantidade * item.fator-conver). 
                  ELSE
                      ASSIGN bf-tt-ordens-desemb.de-peso-bruto   = (tt-ordens-desemb-acum-adicao.de-peso-bruto   * bf-tt-ordens-desemb.de-quantidade ) /  tt-ordens-desemb-acum-adicao.de-quantidade 
                             bf-tt-ordens-desemb.de-peso-liquido = (tt-ordens-desemb-acum-adicao.de-peso-liquido * bf-tt-ordens-desemb.de-quantidade ) /  tt-ordens-desemb-acum-adicao.de-quantidade 
                             bf-tt-ordens-desemb.de-cubagem      = (tt-ordens-desemb-acum-adicao.de-cubagem      * bf-tt-ordens-desemb.de-quantidade ) /  tt-ordens-desemb-acum-adicao.de-quantidade.
              END.
          END.
      END.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateOrdensEmbarque wMasterDetail 
PROCEDURE updateOrdensEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Definicao de Buffer */
    DEFINE BUFFER b-tt-ordens-desemb FOR tt-ordens-desemb.

    RUN updateOrdensEmbarque IN h-bocx225e (INPUT  TABLE tt-ordens-desemb,
                                            INPUT  i-peso,
                                            INPUT  i-cubagem,
                                            INPUT  "",
                                            OUTPUT TABLE tt-bo-erro).

    FOR EACH b-tt-ordens-desemb EXCLUSIVE-LOCK:
        IF  i-cubagem = 2 /* Total */ THEN
            ASSIGN b-tt-ordens-desemb.de-cubagem = b-tt-ordens-desemb.val-cub-tot.
        IF  i-cubagem = 1 /* Unit†rio */ THEN
            ASSIGN b-tt-ordens-desemb.de-cubagem = b-tt-ordens-desemb.val-cub-unit.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updatePesos wMasterDetail 
PROCEDURE updatePesos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN  de-tot-peso-bruto   = 0
            de-tot-peso-liquido = 0.
    
    FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK:

        IF  i-peso-ant = 2 THEN 
            ASSIGN tt-ordens-desemb.de-peso-bruto-unit   = tt-ordens-desemb.de-peso-bruto   / tt-ordens-desemb.quantidade
                   tt-ordens-desemb.de-peso-liquido-unit = tt-ordens-desemb.de-peso-liquido / tt-ordens-desemb.quantidade.
        
        IF  i-peso-ant = 1 THEN 
            ASSIGN tt-ordens-desemb.de-peso-bruto-unit   = tt-ordens-desemb.de-peso-bruto   * tt-ordens-desemb.quantidade
                   tt-ordens-desemb.de-peso-liquido-unit = tt-ordens-desemb.de-peso-liquido * tt-ordens-desemb.quantidade.
    END.

    ASSIGN i-peso-ant    = 0.

    FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK:
        IF INPUT FRAME fPage0 i-peso = 1 THEN 
            ASSIGN tt-ordens-desemb.de-peso-bruto   = tt-ordens-desemb.de-peso-bruto-unit
                   tt-ordens-desemb.de-peso-liquido = tt-ordens-desemb.de-peso-liquido-unit.
        ELSE 
            ASSIGN tt-ordens-desemb.de-peso-bruto   = tt-ordens-desemb.de-peso-bruto-unit   * tt-ordens-desemb.quantidade
                   tt-ordens-desemb.de-peso-liquido = tt-ordens-desemb.de-peso-liquido-unit * tt-ordens-desemb.quantidade.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updatePesosTotal wMasterDetail 
PROCEDURE updatePesosTotal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if "{&bf_mat_versao_ems}" >= "2.062" &then
        ASSIGN  de-tot-peso-bruto   = 0
                de-tot-peso-liquido = 0.
        
        FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK:
    
            IF  i-peso-ant = 2 THEN 
                ASSIGN tt-ordens-desemb.de-peso-bruto-unit   = tt-ordens-desemb.de-peso-bruto   * tt-ordens-desemb.quantidade
                       tt-ordens-desemb.de-peso-liquido-unit = tt-ordens-desemb.de-peso-liquido * tt-ordens-desemb.quantidade.
            ELSE IF i-peso-ant = 1 THEN 
                ASSIGN  tt-ordens-desemb.de-peso-bruto-unit   = tt-ordens-desemb.de-peso-bruto   / tt-ordens-desemb.quantidade
                        tt-ordens-desemb.de-peso-liquido-unit = tt-ordens-desemb.de-peso-liquido / tt-ordens-desemb.quantidade.
        END.
    
        ASSIGN i-peso-ant    = 0.
    
        FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK:
            ASSIGN tt-ordens-desemb.de-peso-bruto   = tt-ordens-desemb.de-peso-bruto-unit
                   tt-ordens-desemb.de-peso-liquido = tt-ordens-desemb.de-peso-liquido-unit
                   tt-ordens-desemb.de-peso-embal   = tt-ordens-desemb.de-peso-bruto - tt-ordens-desemb.de-peso-liquido.
        END.
    &endif

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateQtdeUnidade wMasterDetail 
PROCEDURE updateQtdeUnidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH tt-ordens-desemb EXCLUSIVE-LOCK:
        IF i-quantidade = 1 THEN /* interna */
            ASSIGN tt-ordens-desemb.de-quantidade = tt-ordens-desemb.quantidade
                   tt-ordens-desemb.c-un          = tt-ordens-desemb.c-un-item.
        ELSE                    /* fornecedor */
            ASSIGN tt-ordens-desemb.de-quantidade = tt-ordens-desemb.qt-do-forn
                   tt-ordens-desemb.c-un          = tt-ordens-desemb.c-un-fornec.
    END.

    IF INPUT FRAME fPage0 i-classifica = 2 THEN
        FOR EACH tt-ordens-desemb-acum EXCLUSIVE-LOCK:
            IF i-quantidade = 1 THEN /* interna */
                ASSIGN tt-ordens-desemb-acum.de-quantidade = tt-ordens-desemb-acum.quantidade
                       tt-ordens-desemb-acum.c-un          = tt-ordens-desemb-acum.c-un-item.
            ELSE                    /* fornecedor */
                ASSIGN tt-ordens-desemb-acum.de-quantidade = tt-ordens-desemb-acum.qt-do-forn
                       tt-ordens-desemb-acum.c-un          = tt-ordens-desemb-acum.c-un-fornec.
        END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validapesoliq wMasterDetail 
PROCEDURE validapesoliq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    CASE i-classifica:
        WHEN 1 THEN DO:
            IF CAN-FIND (FIRST tt-ordens-desemb
                         WHERE tt-ordens-desemb.de-peso-bruto < tt-ordens-desemb.de-peso-liquido) THEN DO:
    
                   /* Inicio -- Projeto Internacional */
                   {utp/ut-liter.i "Peso_bruto_est†_menor_que_peso_l°quido" *}
                   RUN utp/ut-msgs.p (INPUT "show":U,
                                      INPUT 27979,
                                      INPUT RETURN-VALUE).
                   RETURN NO-APPLY.
            END.
        END.
        WHEN 2 THEN DO:

            IF CAN-FIND (FIRST tt-ordens-desemb-acum
                         WHERE tt-ordens-desemb-acum.de-peso-bruto < tt-ordens-desemb-acum.de-peso-liquido) THEN DO:
    
                   /* Inicio -- Projeto Internacional */
                   {utp/ut-liter.i "Peso_bruto_est†_menor_que_peso_l°quido" *}
                   RUN utp/ut-msgs.p (INPUT "show":U,
                                      INPUT 27979,
                                      INPUT RETURN-VALUE).
        
                   RETURN NO-APPLY.
            END.

        END.
        WHEN 3 THEN DO:
            IF CAN-FIND (FIRST tt-ordens-desemb-acum-adicao
                         WHERE tt-ordens-desemb-acum-adicao.de-peso-bruto < tt-ordens-desemb-acum-adicao.de-peso-liquido) THEN DO:
            
                   /* Inicio -- Projeto Internacional */
                   {utp/ut-liter.i "Peso_bruto_est†_menor_que_peso_l°quido" *}
                   RUN utp/ut-msgs.p (INPUT "show":U,
                                      INPUT 27979,
                                      INPUT RETURN-VALUE).
                   RETURN NO-APPLY.
            END.
        END.
    END CASE.

    RETURN "OK".
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCubagem wMasterDetail 
FUNCTION fnCubagem RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF i-cubagem = 2 /* Total */ THEN
      ASSIGN de-cubagem = de-cubagem * tt-ordens-embarque.quantidade.

  RETURN de-cubagem.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescClassFiscal wMasterDetail 
FUNCTION fnDescClassFiscal RETURNS CHARACTER
  ( c-class-fiscal AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF VALID-HANDLE(h-boin046na) THEN DO:
      RUN goToKey IN h-boin046na (INPUT c-class-fiscal).
      IF RETURN-VALUE = "OK":U THEN
          RUN getCharField IN h-boin046na (INPUT "descricao",
                                           OUTPUT c-desc-classif).
  END.

  RETURN c-desc-classif.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescricao wMasterDetail 
FUNCTION fnDescricao RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN c-desc-item.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnItem wMasterDetail 
FUNCTION fnItem RETURNS CHARACTER
  ( INPUT p-numero-ordem AS INTEGER ) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/

    RETURN c-it-codigo.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPesoBruto wMasterDetail 
FUNCTION fnPesoBruto RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF i-peso = 2 THEN
      ASSIGN de-peso-bruto = de-peso-bruto * tt-ordens-embarque.quantidade.

  RETURN de-peso-bruto.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPesoLiquido wMasterDetail 
FUNCTION fnPesoLiquido RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF i-peso = 2 THEN
      ASSIGN de-peso-liquido = de-peso-liquido * tt-ordens-embarque.quantidade.

  RETURN de-peso-liquido.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnQuantidade wMasterDetail 
FUNCTION fnQuantidade RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    IF i-quantidade = 1 THEN /* Unidade Interna */
        RETURN tt-ordens-embarque.quantidade.
    ELSE /* 2 - Unidade Fornecedor */ 
        RETURN tt-ordens-embarque.qt-do-forn.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUn wMasterDetail 
FUNCTION fnUn RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN c-un.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUnidade wMasterDetail 
FUNCTION fnUnidade RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN c-un.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

