&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttAbast NO-UNDO LIKE mab-item-abastec
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttApontamento NO-UNDO LIKE mab-abastec-lubrific
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttApontamento-aux NO-UNDO LIKE mab-abastec-lubrific
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttLubrif NO-UNDO LIKE mab-item-lubrific
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
{include/i-prgvrs.i AB0302 2.00.00.026 } /*** 010026 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0302 MAB}
&ENDIF


/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          AB0302
&GLOBAL-DEFINE Version        2.00.00.026

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Combust°vel, ‡leo/Filtro

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


&GLOBAL-DEFINE ttParent         ttApontamento
&GLOBAL-DEFINE hDBOParent       hDBOApontamento
&GLOBAL-DEFINE DBOParentTable   mab-abastec-lubrific
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           ttAbast
&GLOBAL-DEFINE hDBOSon1         hDBOAbast
&GLOBAL-DEFINE DBOSon1Table     mab-item-abastec
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE ttSon2           ttLubrif
&GLOBAL-DEFINE hDBOSon2         hDBOLubrif
&GLOBAL-DEFINE DBOSon2Table     mab-item-lubrific
&GLOBAL-DEFINE DBOSon2Destroy   YES

&GLOBAL-DEFINE page0Fields      ttApontamento.ep-codigo ttApontamento.cod-eqpto ~
                                ttApontamento.dat-movto ttApontamento.num-docto ttApontamento.idi-integr ~
                                ttApontamento.cod-usuar ttApontamento.dat-livre-1 ttApontamento.dat-livre-2 ~
                                ttApontamento.cod-livre-1 ttApontamento.cod-posto fiDescPosto fiTipPosto

&GLOBAL-DEFINE page0Widgets     btIntegraXML

&GLOBAL-DEFINE page1Browse      brSon1
&GLOBAL-DEFINE page2Browse      brSon2

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cCodModelo  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDescricao  AS CHARACTER format "x(30)" NO-UNDO.
DEFINE VARIABLE cDescricao2 AS CHARACTER format "x(30)" NO-UNDO.
DEFINE VARIABLE cDescricao3 AS CHARACTER format "x(30)" NO-UNDO.
DEFINE VARIABLE inum-docto  AS INTEGER    NO-UNDO.

/*Parametros para atualizaá∆o durablidade/apontamento dos pneus*/
DEFINE VARIABLE param25 LIKE mab-param.des-valor INITIAL "0" NO-UNDO.
DEFINE VARIABLE param26 LIKE mab-param.des-valor INITIAL "0" NO-UNDO.
DEFINE VARIABLE param49 LIKE mab-param.des-valor INITIAL "0" NO-UNDO.
DEFINE VARIABLE iErro   AS INTEGER                           NO-UNDO.


DEFINE TEMP-TABLE RowErrorsAux NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.
/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEqpto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOPosto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOHistor    AS HANDLE NO-UNDO.
{abp/abapi001.i}  /** Temp-Tables da API de Atualizaá∆o (ABAPI001) **/
{pnp/pnapi002.i tt-param-aux} /**Definiá∆o da Temp-Table tt-param-aux para integrar com a pnapi002**/
&IF DEFINED(bf_mnt_ems206b) &THEN
    {frbo/bofr133.i tt-unid-negoc-histor}
&ENDIF


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
&Scoped-define INTERNAL-TABLES ttAbast ttLubrif

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 ttAbast.cod-posto ttAbast.cod-bomba ~
ttAbast.cod-tip-mater fnDescMaterial(ttAbast.cod-tip-mater) @ cDescricao ~
ttAbast.it-codigo ttAbast.cod-refer ttAbast.lote ttAbast.cod-localiz ~
ttAbast.val-quant ttAbast.val-mater-1 ttAbast.cod-cta-ctbl ~
ttAbast.cod-ccusto 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH ttAbast NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH ttAbast NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 ttAbast
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 ttAbast


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 ttLubrif.cod-comptmento ~
fnDescComp(ttLubrif.cod-comptmento) @ cDescricao2 ttLubrif.cod-tip-mater ~
ttLubrif.it-codigo fnDescMaterial(ttLubrif.cod-tip-mater) @ cDescricao ~
ttLubrif.cod-refer ttLubrif.lote ttLubrif.cod-localiz ttLubrif.cod-evento ~
fnDescEvento(ttLubrif.cod-evento) @ cDescricao3 ttLubrif.cd-tipo ~
ttLubrif.val-quant ttLubrif.val-mater-1 ttLubrif.cod-cta-ctbl ~
ttLubrif.cod-ccusto 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH ttLubrif NO-LOCK
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH ttLubrif NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon2 ttLubrif
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 ttLubrif


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttApontamento.num-docto ~
ttApontamento.dat-livre-1 ttApontamento.ep-codigo ttApontamento.cod-eqpto ~
ttApontamento.cod-usuar ttApontamento.cod-posto ttApontamento.dat-movto ~
ttApontamento.dat-livre-2 ttApontamento.cod-livre-1 ~
ttApontamento.idi-integr 
&Scoped-define ENABLED-TABLES ttApontamento
&Scoped-define FIRST-ENABLED-TABLE ttApontamento
&Scoped-Define ENABLED-OBJECTS RECT-27 RECT-31 RECT-32 rtParent rtToolBar ~
btFirst btPrev btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete ~
btIntegraXML btAtualizacao btQueryJoins btReportsJoins btExit btHelp ~
btMatriz fi-cod-unid-negoc fiDescModelo fiDescPosto fiTipPosto fiStatus ~
tg-rastreamento fiEstoque 
&Scoped-Define DISPLAYED-FIELDS ttApontamento.num-docto ~
ttApontamento.dat-livre-1 ttApontamento.ep-codigo ttApontamento.cod-eqpto ~
ttApontamento.cod-usuar ttApontamento.cod-posto ttApontamento.dat-movto ~
ttApontamento.dat-livre-2 ttApontamento.cod-livre-1 ~
ttApontamento.idi-integr 
&Scoped-define DISPLAYED-TABLES ttApontamento
&Scoped-define FIRST-DISPLAYED-TABLE ttApontamento
&Scoped-Define DISPLAYED-OBJECTS fi-cod-unid-negoc fiDescModelo fiDescPosto ~
fiTipPosto fiStatus tg-rastreamento fiEstoque 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescComp wMasterDetail 
FUNCTION fnDescComp RETURNS CHARACTER
  ( pComp as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescEvento wMasterDetail 
FUNCTION fnDescEvento RETURNS CHARACTER
  ( pEvento as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescMaterial wMasterDetail 
FUNCTION fnDescMaterial RETURNS CHARACTER
  ( pMaterial as char )  FORWARD.

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
       MENU-ITEM miSearch       LABEL "Pes&quisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "A&lterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miOnLine       LABEL "Atualizaá∆o On-&Line" ACCELERATOR "CTRL-O"
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
     IMAGE-UP FILE "image/im-add":U
     IMAGE-INSENSITIVE FILE "image/ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btAtualizacao 
     IMAGE-UP FILE "image/im-autom.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-autom.bmp":U
     LABEL "Atualizaá∆o On-Line" 
     SIZE 4 BY 1.25 TOOLTIP "Atualizaá∆o do Apontamento On-Line".

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image/im-copy":U
     IMAGE-INSENSITIVE FILE "image/ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image/im-era":U
     IMAGE-INSENSITIVE FILE "image/ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

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

DEFINE BUTTON btIntegraXML 
     IMAGE-UP FILE "image/im-exp.bmp":U
     IMAGE-INSENSITIVE FILE "image/im-exp.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Exportaá∆o XML".

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image/im-las":U
     IMAGE-INSENSITIVE FILE "image/ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btMatriz 
     IMAGE-UP FILE "image/im-negoc.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-negoc.bmp":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Matriz Unidade Neg¢cio".

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

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image/im-mod":U
     IMAGE-INSENSITIVE FILE "image/ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE fi-cod-unid-negoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescPosto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE fiEstoque AS CHARACTER FORMAT "X(15)":U INITIAL "Integraá∆o" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .67 NO-UNDO.

DEFINE VARIABLE fiStatus AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 44.43 BY .88 NO-UNDO.

DEFINE VARIABLE fiTipPosto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26 BY 1.25.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20.57 BY 2.67.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20.57 BY 2.67.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 6.08.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE tg-rastreamento AS LOGICAL INITIAL no 
     LABEL "Integra Rastreamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE BUTTON btAddSon1 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon1 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon1 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btAddSon2 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon2 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon2 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      ttAbast SCROLLING.

DEFINE QUERY brSon2 FOR 
      ttLubrif SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      ttAbast.cod-posto FORMAT "x(8)":U
      ttAbast.cod-bomba FORMAT "x(12)":U
      ttAbast.cod-tip-mater FORMAT "x(8)":U
      fnDescMaterial(ttAbast.cod-tip-mater) @ cDescricao COLUMN-LABEL "Descriá∆o" FORMAT "x(30)":U
            WIDTH 30
      ttAbast.it-codigo FORMAT "x(16)":U
      ttAbast.cod-refer FORMAT "x(8)":U
      ttAbast.lote FORMAT "x(40)":U
      ttAbast.cod-localiz FORMAT "x(20)":U
      ttAbast.val-quant FORMAT ">>>,>>9.99":U
      ttAbast.val-mater-1 FORMAT ">>>,>>>,>>9.9999":U
      ttAbast.cod-cta-ctbl FORMAT "x(20)":U WIDTH 15
      ttAbast.cod-ccusto COLUMN-LABEL "Centro Custo" FORMAT "x(20)":U
            WIDTH 15
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 5.25
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _STRUCTURED
  QUERY brSon2 NO-LOCK DISPLAY
      ttLubrif.cod-comptmento FORMAT "x(8)":U
      fnDescComp(ttLubrif.cod-comptmento) @ cDescricao2 COLUMN-LABEL "Descriá∆o" FORMAT "x(30)":U
            WIDTH 30
      ttLubrif.cod-tip-mater FORMAT "x(8)":U
      ttLubrif.it-codigo FORMAT "x(16)":U
      fnDescMaterial(ttLubrif.cod-tip-mater) @ cDescricao COLUMN-LABEL "Descriá∆o" FORMAT "x(30)":U
            WIDTH 30
      ttLubrif.cod-refer FORMAT "x(8)":U
      ttLubrif.lote FORMAT "x(40)":U
      ttLubrif.cod-localiz FORMAT "x(20)":U
      ttLubrif.cod-evento FORMAT "x(08)":U
      fnDescEvento(ttLubrif.cod-evento) @ cDescricao3 COLUMN-LABEL "Descriá∆o" FORMAT "x(30)":U
            WIDTH 30
      ttLubrif.cd-tipo FORMAT ">>,>>9":U
      ttLubrif.val-quant FORMAT ">,>>>,>>9.99":U
      ttLubrif.val-mater-1 FORMAT ">>>,>>>,>>9.9999":U
      ttLubrif.cod-cta-ctbl FORMAT "x(20)":U WIDTH 15
      ttLubrif.cod-ccusto COLUMN-LABEL "Centro Custo" FORMAT "x(20)":U
            WIDTH 15
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 5.25
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
     btIntegraXML AT ROW 1.13 COL 61.86
     btAtualizacao AT ROW 1.13 COL 70.86 HELP
          "Atualizaá∆o do Apontamento On-Line"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     btMatriz AT ROW 2.79 COL 65.14
     ttApontamento.num-docto AT ROW 2.83 COL 12.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     fi-cod-unid-negoc AT ROW 2.83 COL 58 COLON-ALIGNED
     ttApontamento.dat-livre-1 AT ROW 3.54 COL 75.29 COLON-ALIGNED
          LABEL "Data":R9
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     ttApontamento.ep-codigo AT ROW 3.83 COL 12.43 COLON-ALIGNED
          LABEL "Equipamento":R9
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttApontamento.cod-eqpto AT ROW 3.83 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     fiDescModelo AT ROW 3.83 COL 32.14 COLON-ALIGNED HELP
          "Descriá∆o Modelo Equipamento" NO-LABEL
     ttApontamento.cod-usuar AT ROW 4.54 COL 75.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     ttApontamento.cod-posto AT ROW 4.83 COL 12.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescPosto AT ROW 4.83 COL 22.57 COLON-ALIGNED NO-LABEL
     fiTipPosto AT ROW 4.83 COL 56.86 COLON-ALIGNED NO-LABEL
     ttApontamento.dat-movto AT ROW 5.83 COL 12.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiStatus AT ROW 5.83 COL 22.57 COLON-ALIGNED NO-LABEL
     ttApontamento.dat-livre-2 AT ROW 6.33 COL 75.29 COLON-ALIGNED
          LABEL "Data":R9
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     ttApontamento.cod-livre-1 AT ROW 7.33 COL 75.29 COLON-ALIGNED
          LABEL "Usu†rio":R9
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     tg-rastreamento AT ROW 7.5 COL 42
     ttApontamento.idi-integr AT ROW 7.58 COL 16.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Nao integrada", 1,
"Integrada", 2
          SIZE 23.14 BY .71
     fiEstoque AT ROW 6.92 COL 13.43 COLON-ALIGNED NO-LABEL
     "Alteraá∆o" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 5.67 COL 71.29
     "Criaá∆o" VIEW-AS TEXT
          SIZE 5.72 BY .54 AT ROW 2.75 COL 71.29
     RECT-27 AT ROW 7.25 COL 14.57
     RECT-31 AT ROW 3 COL 70
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.29 BY 16.25
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage0
     RECT-32 AT ROW 5.88 COL 70
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.29 BY 16.25
         FONT 1.

DEFINE FRAME fPage2
     brSon2 AT ROW 1 COL 2
     btAddSon2 AT ROW 6.25 COL 2
     btUpdateSon2 AT ROW 6.25 COL 12
     btDeleteSon2 AT ROW 6.25 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 10
         SIZE 84.43 BY 7
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1 COL 2
     btAddSon1 AT ROW 6.25 COL 2
     btUpdateSon1 AT ROW 6.25 COL 12
     btDeleteSon1 AT ROW 6.25 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 10
         SIZE 84.43 BY 7
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttAbast T "?" NO-UNDO movfro mab-item-abastec
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttApontamento T "?" NO-UNDO movfro mab-abastec-lubrific
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttLubrif T "?" NO-UNDO movfro mab-item-lubrific
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
         HEIGHT             = 16.25
         WIDTH              = 91.29
         MAX-HEIGHT         = 26.38
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 26.38
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
       FRAME fPage2:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN ttApontamento.cod-livre-1 IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttApontamento.dat-livre-1 IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttApontamento.dat-livre-2 IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttApontamento.ep-codigo IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.ttAbast"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttAbast.cod-posto
     _FldNameList[2]   = Temp-Tables.ttAbast.cod-bomba
     _FldNameList[3]   = Temp-Tables.ttAbast.cod-tip-mater
     _FldNameList[4]   > "_<CALC>"
"fnDescMaterial(ttAbast.cod-tip-mater) @ cDescricao" "Descriá∆o" "x(30)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.ttAbast.it-codigo
     _FldNameList[6]   = Temp-Tables.ttAbast.cod-refer
     _FldNameList[7]   = Temp-Tables.ttAbast.lote
     _FldNameList[8]   = Temp-Tables.ttAbast.cod-localiz
     _FldNameList[9]   = Temp-Tables.ttAbast.val-quant
     _FldNameList[10]   = Temp-Tables.ttAbast.val-mater-1
     _FldNameList[11]   > Temp-Tables.ttAbast.cod-cta-ctbl
"cod-cta-ctbl" ? ? "character" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.ttAbast.cod-ccusto
"cod-ccusto" "Centro Custo" ? "character" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.ttLubrif"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttLubrif.cod-comptmento
     _FldNameList[2]   > "_<CALC>"
"fnDescComp(ttLubrif.cod-comptmento) @ cDescricao2" "Descriá∆o" "x(30)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.ttLubrif.cod-tip-mater
     _FldNameList[4]   = Temp-Tables.ttLubrif.it-codigo
     _FldNameList[5]   > "_<CALC>"
"fnDescMaterial(ttLubrif.cod-tip-mater) @ cDescricao" "Descriá∆o" "x(30)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.ttLubrif.cod-refer
     _FldNameList[7]   = Temp-Tables.ttLubrif.lote
     _FldNameList[8]   = Temp-Tables.ttLubrif.cod-localiz
     _FldNameList[9]   = Temp-Tables.ttLubrif.cod-evento
     _FldNameList[10]   > "_<CALC>"
"fnDescEvento(ttLubrif.cod-evento) @ cDescricao3" "Descriá∆o" "x(30)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   = Temp-Tables.ttLubrif.cd-tipo
     _FldNameList[12]   = Temp-Tables.ttLubrif.val-quant
     _FldNameList[13]   = Temp-Tables.ttLubrif.val-mater-1
     _FldNameList[14]   > Temp-Tables.ttLubrif.cod-cta-ctbl
"cod-cta-ctbl" ? ? "character" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.ttLubrif.cod-ccusto
"cod-ccusto" "Centro Custo" ? "character" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMasterDetail
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd IN MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE (INPUT "abp/ab0302a.w":U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="abp/ab0302b.w"
                           &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btAddSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon2 wMasterDetail
ON CHOOSE OF btAddSon2 IN FRAME fPage2 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="abp/ab0302c.w"
                           &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btAtualizacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualizacao wMasterDetail
ON CHOOSE OF btAtualizacao IN FRAME fPage0 /* Atualizaá∆o On-Line */
OR CHOOSE OF MENU-ITEM miOnLine IN MENU mbMain DO:
   run piParametro in this-procedure.
   
   run abp/abapi001.p (input  table tt-param,
                       output table RowErrors,
                       output table ttDocLib).

   if can-find(first RowErrors) then do:
        /** Instancia aplicativo **/
        {method/showmessage.i1}
        /** Mostra caixa com erros **/
        {method/showmessage.i2 &Modal="YES"}
        /** Limpa temp-tables de erros **/
        empty temp-table RowErrors.
   end.

   /* Reposiciona registro com base em um rowid */
   RUN repositionRecord IN THIS-PROCEDURE (INPUT {&ttParent}.r-rowid).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMasterDetail
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord (INPUT "abp/ab0302a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMasterDetail
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    DO TRANSACTION ON STOP UNDO, RETURN "nok" ON ERROR UNDO, RETURN 'nok':
        BUFFER-COPY ttapontamento TO ttapontamento-aux.

        ASSIGN inum-docto = ttapontamento.num-docto.
    
        RUN deleteRecord IN THIS-PROCEDURE.
        RUN afterDelete  IN THIS-PROCEDURE.
    END.
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


&Scoped-define SELF-NAME btIntegraXML
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIntegraXML wMasterDetail
ON CHOOSE OF btIntegraXML IN FRAME fPage0
DO:
    /*--- Seta cursor do mouse para espera ---*/
    session:set-wait-state("GENERAL":U).
    assign {&window-name}:sensitive = no.
    
    /*--- Executa programa de manutená∆o de filho ---*/
    run abp/ab0302d.w (input input frame fPage0 ttApontamento.num-docto).
    
    assign {&window-name}:sensitive = yes.
    /*--- Seta cursor do mouse para normal ---*/
    session:set-wait-state("":U).     
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


&Scoped-define SELF-NAME btMatriz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMatriz wMasterDetail
ON CHOOSE OF btMatriz IN FRAME fPage0
DO:
    /*--- Seta cursor do mouse para espera ---*/
    SESSION:SET-WAIT-STATE("GENERAL":U).

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

    /*--- Executa programa de manutená∆o de filho ---*/
    RUN abp/ab0302e.w (INPUT INPUT FRAME fPage0 {&ttParent}.ep-codigo,
                       INPUT INPUT FRAME fPage0 {&ttParent}.cod-eqpto,
                       INPUT INPUT FRAME fPage0 {&ttParent}.dat-movto).

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    /*--- Seta cursor do mouse para normal ---*/
    SESSION:SET-WAIT-STATE("":U).

    APPLY "ENTRY":U TO btMatriz IN FRAME fPage0.
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
    {method/zoomreposition.i &ProgramZoom="frzoom/z01fr055.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMasterDetail
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:

    RUN updateRecord IN THIS-PROCEDURE (INPUT "abp/ab0302a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Alterar */
DO:

    {masterdetail/updateson.i &ProgramSon="abp/ab0302b.w"
                              &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btUpdateSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon2 wMasterDetail
ON CHOOSE OF btUpdateSon2 IN FRAME fPage2 /* Alterar */
DO:

    {masterdetail/updateson.i &ProgramSon="abp/ab0302c.w"
                              &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME ttApontamento.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApontamento.cod-eqpto wMasterDetail
ON LEAVE OF ttApontamento.cod-eqpto IN FRAME fPage0 /* cod-eqpto */
DO:
    
    IF AVAIL ttApontamento THEN DO:
        FOR FIRST mab-eqpto
            WHERE mab-eqpto.cod-eqpto = ttApontamento.cod-eqpto 
            AND   mab-eqpto.ep-codigo = ttApontamento.ep-codigo NO-LOCK:
            ASSIGN tg-rastreamento:CHECKED IN FRAME fPage0 = mab-eqpto.log-livre-1.
        END.
    END.
      
    run buscaModelo in this-procedure.
    {method/referenceFields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="cCodModelo"
        &FieldName1="des-model"
        &FieldScreen1="fiDescModelo"
        &Frame1="fPage0"}   
       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttApontamento.cod-posto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApontamento.cod-posto wMasterDetail
ON LEAVE OF ttApontamento.cod-posto IN FRAME fPage0 /* Posto */
DO:

    ASSIGN fiTipPosto = "".
    
    FOR FIRST mab-posto 
        WHERE mab-posto.cod-posto = INPUT FRAME fPage0 ttApontamento.cod-posto NO-LOCK:
        IF mab-posto.idi-posto = 1 THEN DO:

            {utp/ut-liter.i Pr¢prio *}
            ASSIGN fiTipPosto = RETURN-VALUE.

        END.

        ELSE DO:
            {utp/ut-liter.i Terceiro *}
            ASSIGN fiTipPosto = RETURN-VALUE.

        END.
    END.

    DISP fiTipPosto WITH FRAME fPage0.

    {method/referenceFields.i
        &HandleDBOLeave="hDBOPosto"
        &KeyValue1="input frame fPage0 {&ttParent}.cod-posto"
        &FieldName1="des-posto"
        &FieldScreen1="fiDescPosto"
        &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{masterdetail/mainblock.i}

{abp/ab9005.i}    /** Validaá∆o de ParÉmetros **/
{abp/abapi001.i2} /** Criaá∆o de Erros **/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDelete wMasterDetail 
PROCEDURE afterDelete :
/* Incluido para atualizar o hodometro do Uso Real no ab0138 */ 
    define buffer bfApont    for mab-abastec-lubrific.
    
    IF NOT CAN-FIND(FIRST ttApontamento
                    WHERE ttApontamento.num-docto = inum-docto) THEN
        FOR FIRST ttapontamento-aux WHERE ttapontamento-aux.num-docto = inum-docto NO-LOCK:
            /** Verifica se existem apontamentos anteriores para equipamento por data **/
            IF CAN-FIND(FIRST bfApont
                        WHERE bfApont.ep-codigo = ttapontamento-aux.ep-codigo           
                        AND   bfApont.cod-eqpto = ttapontamento-aux.cod-eqpto           
                        AND   bfApont.val-dat-hora-invrtda < ttapontamento-aux.val-dat-hora-invrtda)
                        THEN DO:
                FOR LAST  bfApont
                    WHERE bfApont.ep-codigo = ttapontamento-aux.ep-codigo           
                    AND   bfApont.cod-eqpto = ttapontamento-aux.cod-eqpto           
                    AND   bfApont.val-dat-hora-invrtda < ttapontamento-aux.val-dat-hora-invrtda
                    NO-LOCK:
                    FOR FIRST mmv-eqpto-plano FIELD (ep-codigo cod-eqpto val-km-real) 
                                              WHERE mmv-eqpto-plano.ep-codigo = bfapont.ep-codigo
                                              AND   mmv-eqpto-plano.cod-eqpto = bfapont.cod-eqpto
                                              EXCLUSIVE-LOCK:
                        ASSIGN mmv-eqpto-plano.val-km-real = bfapont.val-hodom-horim.
                    END.
                END.
            END.
        END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMasterDetail 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) finalizaá∆o do programa
------------------------------------------------------------------------------*/
/** Equipamento **/
if valid-handle(hDBOEqpto) then
    run Destroy in hDBOEqpto.
/** Modelo **/
if valid-handle(hDBOModelo) then
    run Destroy in hDBOModelo.
/** Posto **/
if valid-handle(hDBOPosto) then
    run Destroy in hDBOPosto.
/** Historico **/
IF VALID-HANDLE(hDBOHistor) THEN
    RUN Destroy IN hDBOHistor.
        
/** Caixa Mensagem de erro **/
{method/showmessage.i3}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     afterDisplayFields
  Parameters:  <none>
  Notes:       Override (ap¢s) mostrar campos em tela
------------------------------------------------------------------------------*/

/** Mostra Status da Consistància do Documento em tela **/
if avail {&ttParent} then DO:
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao001 = {frinc/i00fr055.i 04 {&ttparent}.idi-consist}.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN  fiStatus:screen-value in frame fPage0 = RETURN-VALUE.
    &else
        ASSIGN fiStatus:screen-value in frame fPage0 = {frinc/i00fr055.i 04 {&ttparent}.idi-consist}.
    &endif
END.
else 
    assign fiStatus:screen-value in frame fPage0 = "".

apply "LEAVE":U to ttApontamento.cod-posto  in frame fPage0.

run piBotoes in this-procedure.
if avail {&ttParent} then DO:
    &IF DEFINED(bf_mnt_ems206b) &THEN    
        IF l-usa-unid-negoc THEN DO:
            ASSIGN fi-cod-unid-negoc:SCREEN-VALUE IN FRAME fPage0 = {&ttParent}.cod-unid-negoc.
    
            /** Habilita/Desabilita botao Matriz de Unidade Negocio **/
            RUN piValidaMatriz IN THIS-PROCEDURE.
        END.
    &ELSE
        ASSIGN fi-cod-unid-negoc:SCREEN-VALUE IN FRAME fPage0 = {&ttParent}.cod_unid_negoc.
    &ENDIF
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
  Notes:       Override (ap¢s) inicializaá∆o de tela
------------------------------------------------------------------------------*/
/** Atualizaá∆o On-Line **/
assign btAtualizacao:hidden in frame fPage0 = yes.

{utp/ut-liter.i Integraá∆o *}
ASSIGN fiEstoque:SCREEN-VALUE IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i Data *}
ASSIGN ttApontamento.dat-livre-1:LABEL IN FRAME fPage0 = RETURN-VALUE.
ASSIGN ttApontamento.dat-livre-2:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i Usu†rio *}
ASSIGN ttApontamento.cod-livre-1:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i Equipamento *}
ASSIGN ttApontamento.ep-codigo:LABEL IN FRAME fPage0 = RETURN-VALUE.

if can-find(first mab-param /* parÉmetro 11 = Consiste Ficha */
            where mab-param.cdn-param = 11 no-lock) then do:
    for first mab-param fields(des-valor)
        where mab-param.cdn-param = 11 no-lock:
        if mab-param.des-valor <> '2' then do: /*1 - Online, 2 - Batch*/
            assign btAtualizacao:hidden    in frame fPage0 = no
                   btAtualizacao:sensitive in frame fPage0 = if avail {&ttParent} 
                                                             then yes
                                                             else no.
        end.
    end.    
end.
IF AVAIL ttApontamento THEN DO:
    FOR FIRST mab-eqpto
        WHERE mab-eqpto.cod-eqpto = ttApontamento.cod-eqpto 
        AND   mab-eqpto.ep-codigo = ttApontamento.ep-codigo NO-LOCK:
        ASSIGN tg-rastreamento:CHECKED IN FRAME fPage0 = mab-eqpto.log-livre-1.
    END.
END.

/** Verifica integraá∆o com rastreamento **/
for first mab-param-integr
    where mab-param-integr.cdn-param = 10 no-lock:
    {utp/ut-liter.i Sim}
    if entry(4,mab-param-integr.des-valor) = return-value then do:
        assign btIntegraXML:visible in frame fPage0      = yes
               btIntegraXML:sensitive in frame fPage0    = yes
               tg-rastreamento:visible in frame fPage0   = YES.
    end.
    else do:
        assign btIntegraXML:visible in frame fPage0      = no
               btIntegraXML:sensitive in frame fPage0    = NO
               tg-rastreamento:visible in frame fPage0   = NO.
    end.
end.

if not avail mab-param-integr then do:
    assign btIntegraXML:visible in frame fPage0      = no
           btIntegraXML:sensitive in frame fPage0    = no
           tg-rastreamento:visible in frame fPage0   = NO.
end.

ASSIGN btMatriz:SENSITIVE IN FRAME fPage0 = l-usa-unid-negoc
       btMatriz:VISIBLE   IN FRAME fPage0 = l-usa-unid-negoc.

&IF DEFINED(bf_mnt_ems206b) &THEN
    ASSIGN fi-cod-unid-negoc:VISIBLE IN FRAME fPage0 = l-usa-unid-negoc.
&ENDIF

/** Habilita/Desabilita botao Matriz de Unidade Negocio **/
IF l-usa-unid-negoc THEN
    RUN piValidaMatriz IN THIS-PROCEDURE.
ELSE
    ASSIGN btMatriz:TOOLTIP IN FRAME fPage0 = "":U.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMasterDetail 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override antes de inicializar a tela
------------------------------------------------------------------------------*/
/*Abastecimento*/  
run cdp/cd9902.p (input 1).
if return-value = "NOK":U then do:
   {utp/ut-liter.i "Abastecimento" * r}
   run piCriaErro in this-procedure (input 2082, 
                                     input "EMS":U,
                                     input return-value).
   run piMostraErros.
   return "NOK":U.
end.


/** Valida se os par∆metros est∆o cadastrados **/
{utp/ut-liter.i "Abastecimento"}
run piValidaParametroModulo in this-procedure (input "7,8,9,10,11":U,
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

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaModelo wMasterDetail 
PROCEDURE buscaModelo :
/*------------------------------------------------------------------------------
  Purpose:     buscaModelo
  Parameters:  <none>
  Notes:       Busca o c¢digo do modelo no equipamento
------------------------------------------------------------------------------*/

{method/referenceFields.i
    &HandleDBOLeave="hDBOEqpto"
    &KeyValue1="input frame fPage0 {&ttParent}.ep-codigo"
    &KeyValue2="input frame fPage0 {&ttParent}.cod-eqpto"
    &FieldName1="cod-model"
    &Variable1="cCodModelo"}

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
    
    DEFINE VARIABLE iDocumento LIKE {&ttParent}.num-docto NO-UNDO.
    
    {utp/ut-liter.i "V† Para Apontamento"}
    DEFINE FRAME fGoToRecord
        iDocumento       AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK         AT ROW 2.63 COL 2.14
        btGoToCancel     AT ROW 2.63 COL 13
        rtGoToButton     AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE return-value FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i " "}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN iDocumento.
        
        /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT iDocumento).
        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-liter.i "Aponatamento Abastecimento Lubrificaá∆o"}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT return-value).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE iDocumento btGoToOK btGoToCancel 
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
       {&hDBOParent}:FILE-NAME <> "frbo/bofr055.p":U THEN DO:
        run frbo/bofr055.p persistent set {&hDBOParent}.
    END.

    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "frbo/bofr057.p":U THEN DO:
        run frbo/bofr057.p persistent set {&hDBOSon1}.
    END.

    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon2}) OR
       {&hDBOSon2}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon2}:FILE-NAME <> "frbo/bofr058.p":U THEN DO:
        run frbo/bofr058.p persistent set {&hDBOSon2}.
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

    /*--- DBO Posto  ---*/
    IF NOT VALID-HANDLE(hDBOPosto) OR
       hDBOPosto:TYPE <> "PROCEDURE":U OR
       hDBOPosto:FILE-NAME <> "frbo/bofr021.p":U THEN DO:
        run frbo/bofr021.p persistent set  hDBOPosto.
    END.

    RUN openQueryStatic IN hDBOPosto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Historico Atividade  ---*/
    IF NOT VALID-HANDLE(hDBOHistor) OR
       hDBOHistor:TYPE <> "PROCEDURE":U OR
       hDBOHistor:FILE-NAME <> "frbo/bofr013.p":U THEN DO:
        run frbo/bofr013.p persistent set  hDBOHistor.
    END.

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

    {masterdetail/openqueriesson.i &Parent="Apontamento"
                                   &Query="Apontamento"
                                   &PageNumber="1"}
    
    {masterdetail/openqueriesson.i &Parent="Apontamento"
                                   &Query="Apontamento"
                                   &PageNumber="2"}
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBotoes wMasterDetail 
PROCEDURE piBotoes :
/*------------------------------------------------------------------------------
  Purpose:     piBotoes
  Parameters:  <none>
  Notes:       Habilita / Desabilita Bot‰es em tela
------------------------------------------------------------------------------*/
define buffer bfEqpto for mab-eqpto.

/** Mostra Bot∆o atualizaá∆o on-line em tela **/
if not(btAtualizacao:hidden in frame fPage0) then do:
    assign btAtualizacao:sensitive in frame fPage0 = if avail {&ttParent} 
                                                     then yes
                                                     else no.
end.
/** Descriá‰es dos campos **/
apply "LEAVE":U to {&ttParent}.cod-eqpto in frame fPage0.
/** Desabilita Bot‰es se apontamento est† integrado **/
if avail {&ttParent} then do:
    if {&ttparent}.idi-integr = 2 then do:
        assign btAddSon1:sensitive in frame fPage1    = no
               btUpdateSon1:sensitive in frame fPage1 = no
               btAddSon2:sensitive in frame fPage2    = no
               btUpdateSon2:sensitive in frame fPage2 = no.
    end.
    assign menu-item miOnLine:sensitive in menu mbMain = if not(btAtualizacao:hidden in frame fPage0) 
                                                         then yes
                                                         else no.
    /** Verifica tipo de equipamento **/
    for first bfEqpto fields(idi-tip-eqpto) 
        where bfEqpto.ep-codigo = {&ttParent}.ep-codigo
        and   bfEqpto.cod-eqpto = {&ttParent}.cod-eqpto no-lock:
        /** Se for n∆o motorizado, desabilita inclus∆o de abastecimento **/
        if bfEqpto.idi-tip-eqpto = 2 then do:
            run setFolder  in hFolder (2).
            run setEnabled in hFolder (1, false).
        end.
        ELSE DO:
            run setEnabled in hFolder (1, TRUE).
            run setFolder  in hFolder (1).
        END.
    end.
end.
else 
    assign menu-item miOnLine:sensitive in menu mbMain = no.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraErros wMasterDetail 
PROCEDURE piMostraErros :
/*------------------------------------------------------------------------------
  Purpose:     piMostraErros
  Parameters:  <none>
  Notes:       Verifica a temp-table de erros da BO e mostra em tela as mensagens
------------------------------------------------------------------------------*/

/** Instancia aplicativo **/
{method/showmessage.i1}
/** Mostra caixa com erros **/
{method/showmessage.i2 &Modal="YES"}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piParametro wMasterDetail 
PROCEDURE piParametro :
/*------------------------------------------------------------------------------
  Purpose:     piParametro
  Parameters:  <none>
  Notes:       Cria a temp-table de parÉmetros para a atualizaá∆o on-line
               (tt-param)
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-valor-param53 LIKE mab-param.des-valor NO-UNDO.

DEFINE BUFFER bf-mab-abastec-lubrific FOR mab-abastec-lubrific.

empty temp-table tt-param.

create tt-param.
assign tt-param.usuario         = c-seg-usuario
       tt-param.destino         = 1
       tt-param.arquivo         = ""
       tt-param.data-exec       = today
       tt-param.hora-exec       = time
       tt-param.iConsiste       = 2
       tt-param.descConsiste    = "Todos":U
       tt-param.iEmpIni         = {&ttparent}.ep-codigo
       tt-param.iEmpFim         = {&ttparent}.ep-codigo
       tt-param.cEqptoIni       = {&ttParent}.cod-eqpto
       tt-param.cEqptoFim       = {&ttParent}.cod-eqpto
       tt-param.num-docto       = {&ttParent}.num-docto
       tt-param.lFicha          = yes
       tt-param.tipo-liberacao  = 1 /** Normal **/
       tt-param.cCCini          = ""
       tt-param.cCCfim          = "ZZZZZZZZZZZZZZZZZZZZ"
       tt-param.cPostoIni       = ""
       tt-param.cPostoFim       = "ZZZZZZZZ"
       tt-param.cEstabIni       = ""    
       tt-param.cEstabFim       = "ZZZZZ"
       tt-param.cTagIni         = ""                 
       tt-param.cTagFim         = "ZZZZZZZZZZZZZZZZ".

&IF DEFINED(bf_mnt_ems206b) &THEN
    ASSIGN tt-param.cUnidNegocIni = {&ttParent}.cod-unid-negoc
           tt-param.cUnidNegocFim = {&ttParent}.cod-unid-negoc.
&ENDIF

for FIRST mab-param
    where mab-param.cdn-param = 53 no-lock:
    ASSIGN c-valor-param53 = mab-param.des-valor.
END.

/** Se parametrizado para consistir todas as fichas posteriores a validada, 
    retira chamada somente para o documento e coloca data final como atual **/
IF c-valor-param53 = "1":U THEN DO:
    ASSIGN tt-param.dataIni   = INPUT FRAME fPage0 ttApontamento.dat-movto
           tt-param.dataFim   = TODAY
           tt-param.num-docto = ?.
END.
ELSE DO:
    ASSIGN tt-param.dataIni   = INPUT FRAME fPage0 {&ttparent}.dat-movto
           tt-param.dataFim   = INPUT FRAME fPage0 {&ttparent}.dat-movto
           tt-param.num-docto = INPUT FRAME fPage0 {&ttparent}.num-docto.
END.


return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaMatriz wMasterDetail 
PROCEDURE piValidaMatriz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lTemMatriz AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE cUnidNegoc AS CHARACTER FORMAT "x(3)" NO-UNDO.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF AVAIL {&ttParent} THEN DO:
            RUN piRetornaUnidNegoc IN hDBOHistor (INPUT  {&ttParent}.ep-codigo,
                                                  INPUT  {&ttParent}.cod-eqpto,
                                                  INPUT  {&ttParent}.dat-movto,
                                                  OUTPUT cUnidNegoc,
                                                  OUTPUT lTemMatriz,
                                                  OUTPUT TABLE tt-unid-negoc-histor).

            IF lTemMatriz AND cUnidNegoc = INPUT FRAME fPage0 fi-cod-unid-negoc THEN
                ASSIGN btMatriz:SENSITIVE IN FRAME fPage0 = YES.
            ELSE
                ASSIGN btMatriz:SENSITIVE IN FRAME fPage0 = NO.
        END.
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescComp wMasterDetail 
FUNCTION fnDescComp RETURNS CHARACTER
  ( pComp as char ) :
/*------------------------------------------------------------------------------
  Purpose:  fnDescComp
    Notes:  Busca descriá∆o do campo Compartimento
------------------------------------------------------------------------------*/

DEFINE VARIABLE cDescComp AS CHARACTER format "x(30)" NO-UNDO.

define buffer bfComp for mab-comptmento.

for first bfComp fields(des-comptmento)
    where bfComp.cod-comptmento = pComp no-lock:
    assign cDescComp = bfComp.des-comptmento.
end.

  RETURN cDescComp.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescEvento wMasterDetail 
FUNCTION fnDescEvento RETURNS CHARACTER
  ( pEvento as char ) :
/*------------------------------------------------------------------------------
  Purpose:  fnDescEvento
    Notes:  Busca descriá∆o do campo Evento
------------------------------------------------------------------------------*/

DEFINE VARIABLE cDescEvento AS CHARACTER format "x(30)" NO-UNDO.

define buffer bfEvento for mab-event.

for first bfEvento fields(des-evento)
    where bfEvento.cod-evento = pEvento no-lock:
    assign cDescEvento = bfEvento.des-evento.
end.

  RETURN cDescEvento.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescMaterial wMasterDetail 
FUNCTION fnDescMaterial RETURNS CHARACTER
  ( pMaterial as char ) :
/*------------------------------------------------------------------------------
  Purpose:  fnDescMaterial
    Notes:  Busca descriá∆o do campo tipo de material
------------------------------------------------------------------------------*/

DEFINE VARIABLE cDescMat AS CHARACTER format "x(30)" NO-UNDO.

define buffer bfMat for mab-tip-mater.

for first bfMat fields(des-tip-mater)
    where bfMat.cod-tip-mater = pMaterial no-lock:
    assign cDescMat = bfMat.des-tip-mater.
end.

  RETURN cDescMat.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

