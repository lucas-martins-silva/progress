&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-adiant-despes NO-UNDO LIKE adiant-despes
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-adiant-despes-lista NO-UNDO LIKE adiant-despes-lista
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-adiant-despes-lista-det NO-UNDO LIKE adiant-despes-lista-det
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-adiant-despes-parc NO-UNDO LIKE adiant-despes-parc
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.    
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0720D 2.00.00.004 } /*** 010004 ***/
{utp/ut-glob.i} 

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0720D MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           IM0720D
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Desp/Impto,Mercadoria

&GLOBAL-DEFINE ttTable           tt-adiant-despes-lista
&GLOBAL-DEFINE hDBOTable         h-bocx00444
&GLOBAL-DEFINE DBOTable          adiant-despes-lista

&GLOBAL-DEFINE ttParent          tt-adiant-despes
&GLOBAL-DEFINE DBOParentTable    h-bocx00442

&GLOBAL-DEFINE ttSon1           tt-ordens-embarque
&GLOBAL-DEFINE hDBOSon1         h-bocx225
&GLOBAL-DEFINE DBOSon1Table     ordens-embarque
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE ttSon2           tt-adiant-despes-lista-det-aux
&GLOBAL-DEFINE hDBOSon2         h-bocx00444
&GLOBAL-DEFINE DBOSon2Table     adiant-despes-list
&GLOBAL-DEFINE DBOSon2Destroy   YES

&GLOBAL-DEFINE page0KeyFields    tt-adiant-despes-lista.num-seq-lista
&GLOBAL-DEFINE page0Fields       tt-adiant-despes-lista.idi-lancto ~
                                 tt-adiant-despes-lista.idi-identif ~
                                 tt-adiant-despes-lista.desc-identif ~
                                 tt-adiant-despes-lista.idi-operac-antecip ~
                                 tt-adiant-despes-lista.cod-refer
&GLOBAL-DEFINE page0ParentFields tt-adiant-despes.cod-estabel ~
                                 tt-adiant-despes.dat-implant ~
                                 tt-adiant-despes.cdd-adiant ~
                                 tt-adiant-despes.cdn-emitente ~
                                 tt-adiant-despes.cdn-moeda ~
                                 tt-adiant-despes.val-adiant-moed
&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       tt-adiant-despes-lista.cod-embarq ~
                                 tt-adiant-despes-lista.num-di-ems
&GLOBAL-DEFINE page2Browse       browse-1 browse-2 

&GLOBAL-DEFINE mouse-select-dblclick1 YES
&GLOBAL-DEFINE ExcludebtSave  yes

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-return               AS   CHARACTER                          NO-UNDO.
DEFINE VARIABLE c-marcar               AS   CHARACTER                          NO-UNDO.
DEFINE VARIABLE c-desmarcar            AS   CHARACTER                          NO-UNDO.
DEFINE VARIABLE c-filtro               AS   CHARACTER                          NO-UNDO.
DEFINE VARIABLE c-liter                AS   CHARACTER                          NO-UNDO.
DEFINE VARIABLE i-cont                 AS   INTEGER                            NO-UNDO.
DEFINE VARIABLE l-usou-filtro          AS   LOGICAL                            NO-UNDO.
DEFINE VARIABLE c-nome-abrev           LIKE emitente.nome-abrev                NO-UNDO.
DEFINE VARIABLE c-desc-item            LIKE ITEM.desc-item                     NO-UNDO.
DEFINE VARIABLE c-cod-espec-docto      LIKE adiant-despes-parc.cod-espec-docto NO-UNDO.
DEFINE VARIABLE c-cod-ser-docto        LIKE adiant-despes-parc.cod-ser-docto   NO-UNDO.
DEFINE VARIABLE c-cod-refer            LIKE adiant-despes-parc.cod-refer       NO-UNDO.
DEFINE VARIABLE d-preco-liquido        LIKE cotacao-item.preco-fornec          NO-UNDO.
DEFINE VARIABLE c-observacao           LIKE adiant-despes-lista.observacao     NO-UNDO.
DEFINE VARIABLE c-nr-proc-imp-ini      LIKE processo-imp.nr-proc-imp           NO-UNDO. 
DEFINE VARIABLE c-nr-proc-imp-fim      LIKE processo-imp.nr-proc-imp           NO-UNDO. 
DEFINE VARIABLE i-num-pedido-ini       LIKE pedido-compr.num-pedido            NO-UNDO. 
DEFINE VARIABLE i-num-pedido-fim       LIKE pedido-compr.num-pedido            NO-UNDO. 
DEFINE VARIABLE i-numero-ordem-ini     LIKE ordem-compra.numero-ordem          NO-UNDO. 
DEFINE VARIABLE i-numero-ordem-fim     LIKE ordem-compra.numero-ordem          NO-UNDO. 
DEFINE VARIABLE i-parcela-ini          LIKE prazo-compra.parcela               NO-UNDO. 
DEFINE VARIABLE i-parcela-fim          LIKE prazo-compra.parcela               NO-UNDO. 
DEFINE VARIABLE i-cod-emitente-ini     LIKE emitente.cod-emitente              NO-UNDO. 
DEFINE VARIABLE i-cod-emitente-fim     LIKE emitente.cod-emitente              NO-UNDO. 
DEFINE VARIABLE c-nome-abrev-ini       LIKE emitente.nome-abrev                NO-UNDO. 
DEFINE VARIABLE c-nome-abrev-fim       LIKE emitente.nome-abrev                NO-UNDO. 

DEFINE VARIABLE c-nr-proc-imp-ini-filtro2  LIKE processo-imp.nr-proc-imp           NO-UNDO. 
DEFINE VARIABLE c-nr-proc-imp-fim-filtro2  LIKE processo-imp.nr-proc-imp           NO-UNDO. 
DEFINE VARIABLE i-num-pedido-ini-filtro2   LIKE pedido-compr.num-pedido            NO-UNDO. 
DEFINE VARIABLE i-num-pedido-fim-filtro2   LIKE pedido-compr.num-pedido            NO-UNDO. 
DEFINE VARIABLE i-numero-ordem-ini-filtro2 LIKE ordem-compra.numero-ordem          NO-UNDO. 
DEFINE VARIABLE i-numero-ordem-fim-filtro2 LIKE ordem-compra.numero-ordem          NO-UNDO. 
DEFINE VARIABLE i-parcela-ini-filtro2      LIKE prazo-compra.parcela               NO-UNDO. 
DEFINE VARIABLE i-parcela-fim-filtro2      LIKE prazo-compra.parcela               NO-UNDO. 
DEFINE VARIABLE i-cod-emitente-ini-filtro2 LIKE emitente.cod-emitente              NO-UNDO. 
DEFINE VARIABLE i-cod-emitente-fim-filtro2 LIKE emitente.cod-emitente              NO-UNDO. 
DEFINE VARIABLE c-nome-abrev-ini-filtro2   LIKE emitente.nome-abrev                NO-UNDO. 
DEFINE VARIABLE c-nome-abrev-fim-filtro2   LIKE emitente.nome-abrev                NO-UNDO. 

DEFINE VARIABLE c-cod-refer-ini        LIKE adiant-despes-parc.cod-refer       NO-UNDO. 
DEFINE VARIABLE c-cod-refer-fim        LIKE adiant-despes-parc.cod-refer       NO-UNDO. 
DEFINE VARIABLE c-cod-espec-docto-ini  LIKE adiant-despes-parc.cod-espec-docto NO-UNDO. 
DEFINE VARIABLE c-cod-espec-docto-fim  LIKE adiant-despes-parc.cod-espec-docto NO-UNDO. 
DEFINE VARIABLE c-cod-ser-docto-ini    LIKE adiant-despes-parc.cod-ser-docto   NO-UNDO. 
DEFINE VARIABLE c-cod-ser-docto-fim    LIKE adiant-despes-parc.cod-ser-docto   NO-UNDO. 
DEFINE VARIABLE c-cod-tit-ap-ini       LIKE adiant-despes-parc.cod-tit-ap      NO-UNDO. 
DEFINE VARIABLE c-cod-tit-ap-fim       LIKE adiant-despes-parc.cod-tit-ap      NO-UNDO. 
DEFINE VARIABLE c-cod-parcela-ini      LIKE adiant-despes-parc.cod-parcela     NO-UNDO. 
DEFINE VARIABLE c-cod-parcela-fim      LIKE adiant-despes-parc.cod-parcela     NO-UNDO. 
DEFINE VARIABLE dt-dat-emissao-ini     LIKE adiant-despes-parc.dat-emissao     NO-UNDO. 
DEFINE VARIABLE dt-dat-emissao-fim     LIKE adiant-despes-parc.dat-emissao     NO-UNDO. 
DEFINE VARIABLE dt-dat-vencto-ini      LIKE adiant-despes-parc.dat-vencto      NO-UNDO. 
DEFINE VARIABLE dt-dat-vencto-fim      LIKE adiant-despes-parc.dat-vencto      NO-UNDO. 
DEFINE VARIABLE de-val-adiant-moed-ini LIKE adiant-despes-parc.val-adiant-moed NO-UNDO. 
DEFINE VARIABLE de-val-adiant-moed-fim LIKE adiant-despes-parc.val-adiant-moed NO-UNDO. 

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx00442   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx00443   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx00446   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx00447   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boad107     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boad098     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boun005     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin172     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx220     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx383     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx250     AS HANDLE      NO-UNDO.
DEFINE VARIABLE wh-pesquisa   AS HANDLE      NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/*temp-table do primeiro browser*/
DEFINE TEMP-TABLE tt-ordens-embarque NO-UNDO LIKE ordens-embarque
    FIELD cod-emitente LIKE ordem-compra.cod-emitente
    FIELD it-codigo    LIKE ordem-compra.it-codigo
    FIELD num-pedido   LIKE ordem-compra.num-pedido
    FIELD mo-codigo    LIKE cotacao-item.mo-codigo
    FIELD preco-unit   LIKE cotacao-item.preco-unit
    FIELD preco-total  AS   DECIMAL FORMAT ">>>>>,>>>,>>9.99999":U
    FIELD marca        AS   CHARACTER
    FIELD r-rowid      AS ROWID.

DEFINE TEMP-TABLE tt-ordens-embarque-aux NO-UNDO LIKE tt-ordens-embarque.

/*temp-table do segundo browser*/
DEFINE TEMP-TABLE tt-adiant-despes-lista-det-aux NO-UNDO LIKE adiant-despes-lista-det
    FIELD cod-refer         LIKE adiant-despes-parc.cod-refer      
    FIELD cod-parcela       LIKE adiant-despes-parc.cod-parcela    
    FIELD cod-espec-docto   LIKE adiant-despes-parc.cod-espec-docto
    FIELD cod-ser-docto     LIKE adiant-despes-parc.cod-ser-docto  
    FIELD cod-tit-ap        LIKE adiant-despes-parc.cod-tit-ap     
    FIELD val-adiant-moed   LIKE adiant-despes-parc.val-adiant-moed
    FIELD dat-emissao       LIKE adiant-despes-parc.dat-emissao    
    FIELD dat-vencto        LIKE adiant-despes-parc.dat-vencto     
    FIELD num-pedido        LIKE ordem-compra.num-pedido
    FIELD parcela           LIKE ordens-embarque.parcela
    FIELD cod-emitente      LIKE ordem-compra.cod-emitente
    FIELD it-codigo         LIKE ordem-compra.it-codigo
    FIELD observacao        LIKE adiant-despes-lista.observacao
    FIELD marca             AS   CHARACTER
    FIELD r-rowid           AS   ROWID.

DEFINE TEMP-TABLE tt-adiant-despes-lista-det-aux2 NO-UNDO LIKE tt-adiant-despes-lista-det-aux.

DEFINE TEMP-TABLE tt-adiant-despes-lista-det-fil NO-UNDO LIKE tt-adiant-despes-lista-det-aux.

{cxbo/bocx00443.i tt-adiant-despes-parc-retorno}

DEFINE BUFFER bf-tt-ordens-embarque FOR tt-ordens-embarque.
DEFINE BUFFER bf-adiant-despes-lista-det-aux FOR tt-adiant-despes-lista-det-aux.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME browse-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ordens-embarque ~
tt-adiant-despes-lista-det-aux

/* Definitions for BROWSE browse-1                                      */
&Scoped-define FIELDS-IN-QUERY-browse-1 tt-ordens-embarque.marca tt-ordens-embarque.embarque tt-ordens-embarque.nr-proc-imp tt-ordens-embarque.num-pedido tt-ordens-embarque.numero-ordem tt-ordens-embarque.parcela tt-ordens-embarque.preco-total tt-ordens-embarque.preco-unit tt-ordens-embarque.quantidade tt-ordens-embarque.cod-emitente fnNomeAbrev(tt-ordens-embarque.cod-emitente) @ c-nome-abrev tt-ordens-embarque.it-codigo fnDescItem(tt-ordens-embarque.it-codigo) @ c-desc-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-browse-1   
&Scoped-define SELF-NAME browse-1
&Scoped-define QUERY-STRING-browse-1 FOR EACH tt-ordens-embarque
&Scoped-define OPEN-QUERY-browse-1 OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-embarque.
&Scoped-define TABLES-IN-QUERY-browse-1 tt-ordens-embarque
&Scoped-define FIRST-TABLE-IN-QUERY-browse-1 tt-ordens-embarque


/* Definitions for BROWSE browse-2                                      */
&Scoped-define FIELDS-IN-QUERY-browse-2 tt-adiant-despes-lista-det-aux.marca tt-adiant-despes-lista-det-aux.num-seq-det tt-adiant-despes-lista-det-aux.cod-refer tt-adiant-despes-lista-det-aux.cod-parcela tt-adiant-despes-lista-det-aux.cod-espec-docto tt-adiant-despes-lista-det-aux.cod-ser-docto tt-adiant-despes-lista-det-aux.cod-tit-ap tt-adiant-despes-lista-det-aux.val-adiant-moed tt-adiant-despes-lista-det-aux.dat-emissao tt-adiant-despes-lista-det-aux.dat-vencto tt-adiant-despes-lista-det-aux.nr-proc-imp tt-adiant-despes-lista-det-aux.num-pedido tt-adiant-despes-lista-det-aux.numero-ordem tt-adiant-despes-lista-det-aux.parcela tt-adiant-despes-lista-det-aux.cod-emitente fnNomeAbrev(tt-adiant-despes-lista-det-aux.cod-emitente) @ c-nome-abrev tt-adiant-despes-lista-det-aux.it-codigo fnDescItem(tt-adiant-despes-lista-det-aux.it-codigo) @ c-desc-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-browse-2 tt-adiant-despes-lista-det-aux.cod-espec-docto ~
tt-adiant-despes-lista-det-aux.cod-ser-docto ~
tt-adiant-despes-lista-det-aux.cod-tit-ap ~
tt-adiant-despes-lista-det-aux.dat-emissao ~
tt-adiant-despes-lista-det-aux.dat-vencto   
&Scoped-define ENABLED-TABLES-IN-QUERY-browse-2 ~
tt-adiant-despes-lista-det-aux
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-browse-2 tt-adiant-despes-lista-det-aux
&Scoped-define SELF-NAME browse-2
&Scoped-define QUERY-STRING-browse-2 FOR EACH tt-adiant-despes-lista-det-aux
&Scoped-define OPEN-QUERY-browse-2 OPEN QUERY {&SELF-NAME} FOR EACH tt-adiant-despes-lista-det-aux.
&Scoped-define TABLES-IN-QUERY-browse-2 tt-adiant-despes-lista-det-aux
&Scoped-define FIRST-TABLE-IN-QUERY-browse-2 tt-adiant-despes-lista-det-aux


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-browse-1}~
    ~{&OPEN-QUERY-browse-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-adiant-despes.cod-estabel ~
tt-adiant-despes.dat-implant tt-adiant-despes.cdd-adiant ~
tt-adiant-despes.cdn-emitente tt-adiant-despes.cdn-moeda ~
tt-adiant-despes.val-adiant-moed tt-adiant-despes-lista.num-seq-lista ~
tt-adiant-despes-lista.idi-lancto tt-adiant-despes-lista.desc-identif ~
tt-adiant-despes-lista.idi-identif tt-adiant-despes-lista.cod-refer ~
tt-adiant-despes-lista.idi-operac-antecip 
&Scoped-define ENABLED-TABLES tt-adiant-despes tt-adiant-despes-lista
&Scoped-define FIRST-ENABLED-TABLE tt-adiant-despes
&Scoped-define SECOND-ENABLED-TABLE tt-adiant-despes-lista
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar RECT-1 RECT-2 RECT-3 ~
c-desc-estabel c-desc-emitente c-desc-moeda btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-adiant-despes.cod-estabel ~
tt-adiant-despes.dat-implant tt-adiant-despes.cdd-adiant ~
tt-adiant-despes.cdn-emitente tt-adiant-despes.cdn-moeda ~
tt-adiant-despes.val-adiant-moed tt-adiant-despes-lista.num-seq-lista ~
tt-adiant-despes-lista.idi-lancto tt-adiant-despes-lista.desc-identif ~
tt-adiant-despes-lista.idi-identif tt-adiant-despes-lista.cod-refer ~
tt-adiant-despes-lista.idi-operac-antecip 
&Scoped-define DISPLAYED-TABLES tt-adiant-despes tt-adiant-despes-lista
&Scoped-define FIRST-DISPLAYED-TABLE tt-adiant-despes
&Scoped-define SECOND-DISPLAYED-TABLE tt-adiant-despes-lista
&Scoped-Define DISPLAYED-OBJECTS c-desc-estabel c-desc-emitente ~
c-desc-moeda 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem wMaintenanceNoNavigation 
FUNCTION fnDescItem RETURNS CHARACTER
  ( INPUT pc-it-codigo AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNomeAbrev wMaintenanceNoNavigation 
FUNCTION fnNomeAbrev RETURNS CHARACTER
  ( INPUT pi-cod-emitente AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

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

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-desc-emitente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-moeda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 1.21.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 1.21.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 18.92.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON bt-desv 
     IMAGE-UP FILE "image/iu-up.bmp":U
     LABEL "Button 7" 
     SIZE 4 BY 1.25 TOOLTIP "Desvincula".

DEFINE BUTTON bt-desv-all 
     IMAGE-UP FILE "image/iu-uu.bmp":U
     LABEL "Button 8" 
     SIZE 4 BY 1.25 TOOLTIP "Desvincula Todos".

DEFINE BUTTON bt-ent 
     IMAGE-UP FILE "image/im-enter.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-enter.bmp":U
     LABEL "Button 11" 
     SIZE 4 BY 1 TOOLTIP "Confirma Embarque".

DEFINE BUTTON bt-filtro 
     IMAGE-UP FILE "image/im-fil.bmp":U
     LABEL "Button 6" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro".

DEFINE BUTTON bt-filtro2 
     IMAGE-UP FILE "image/im-fil.bmp":U
     LABEL "Button 9" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro".

DEFINE BUTTON bt-marca1 
     LABEL "Marca Todos" 
     SIZE 14 BY 1.

DEFINE BUTTON bt-marca2 
     LABEL "Marca Todos" 
     SIZE 14 BY 1.

DEFINE BUTTON bt-observa 
     IMAGE-UP FILE "image/im-hist.bmp":U
     LABEL "Button 10" 
     SIZE 4 BY 1.21 TOOLTIP "Observa‡Æo".

DEFINE BUTTON bt-vinc 
     IMAGE-UP FILE "image/iu-down.bmp":U
     LABEL "Button 3" 
     SIZE 4 BY 1.25 TOOLTIP "Vincula".

DEFINE BUTTON bt-vinc-all 
     IMAGE-UP FILE "image/iu-dd.bmp":U
     LABEL "Button 5" 
     SIZE 4 BY 1.25 TOOLTIP "Vincula Todos".

DEFINE BUTTON bt-vinc-parc 
     IMAGE-UP FILE "image/im-alteraitem.bmp":U
     LABEL "Button 4" 
     SIZE 4 BY 1.25 TOOLTIP "Vincula Parcial".

DEFINE VARIABLE c-di-siscomex AS CHARACTER FORMAT "X(256)":U 
     LABEL "DI Siscomex" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-tot-vinculado AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Total Vinculado" 
     VIEW-AS FILL-IN 
     SIZE 21.86 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY browse-1 FOR 
      tt-ordens-embarque SCROLLING.

DEFINE QUERY browse-2 FOR 
      tt-adiant-despes-lista-det-aux SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE browse-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS browse-1 wMaintenanceNoNavigation _FREEFORM
  QUERY browse-1 DISPLAY
      tt-ordens-embarque.marca FORMAT "x(5)":U COLUMN-LABEL " * "       
    tt-ordens-embarque.embarque FORMAT "x(16)":U
    tt-ordens-embarque.nr-proc-imp FORMAT "X(12)":U
    tt-ordens-embarque.num-pedido FORMAT ">>>>>,>>9":U
    tt-ordens-embarque.numero-ordem FORMAT "zzzzz9,99":U
    tt-ordens-embarque.parcela FORMAT ">>>>9":U
    tt-ordens-embarque.preco-total FORMAT "->>>,>>>,>>>,>>>,>>9.99":U COLUMN-LABEL "Pre‡o Total"
    tt-ordens-embarque.preco-unit  FORMAT "->>>,>>>,>>>,>>>,>>9.99":U COLUMN-LABEL "Pre‡o Unit"
    tt-ordens-embarque.quantidade 
    tt-ordens-embarque.cod-emitente FORMAT ">>>>>>>>9":U
    fnNomeAbrev(tt-ordens-embarque.cod-emitente) @ c-nome-abrev FORMAT "X(12)":U COLUMN-LABEL "Nome Abreviado"
    tt-ordens-embarque.it-codigo FORMAT "X(16)":U
    fnDescItem(tt-ordens-embarque.it-codigo) @ c-desc-item FORMAT "X(60)":U COLUMN-LABEL "Descri‡Æo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 75 BY 4.5
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE browse-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS browse-2 wMaintenanceNoNavigation _FREEFORM
  QUERY browse-2 DISPLAY
      tt-adiant-despes-lista-det-aux.marca FORMAT "x(5)":U COLUMN-LABEL " * "       
      tt-adiant-despes-lista-det-aux.num-seq-det 
      tt-adiant-despes-lista-det-aux.cod-refer FORMAT "x(12)":U
      tt-adiant-despes-lista-det-aux.cod-parcela FORMAT "x(02)":U
      tt-adiant-despes-lista-det-aux.cod-espec-docto FORMAT "x(3)":U COLUMN-LABEL "Esp‚cie"
      tt-adiant-despes-lista-det-aux.cod-ser-docto FORMAT "x(5)":U COLUMN-LABEL "S‚rie"
      tt-adiant-despes-lista-det-aux.cod-tit-ap FORMAT "x(16)":U COLUMN-LABEL "T¡tulo"
      tt-adiant-despes-lista-det-aux.val-adiant-moed FORMAT "->>>,>>>,>>>,>>>,>>9.99":U COLUMN-LABEL "Valor Adiantamento"
      tt-adiant-despes-lista-det-aux.dat-emissao FORMAT "99/99/9999":U
      tt-adiant-despes-lista-det-aux.dat-vencto FORMAT "99/99/9999":U
      tt-adiant-despes-lista-det-aux.nr-proc-imp FORMAT "X(12)":U
      tt-adiant-despes-lista-det-aux.num-pedido FORMAT ">>>>>,>>9":U
      tt-adiant-despes-lista-det-aux.numero-ordem FORMAT "zzzzz9,99":U
      tt-adiant-despes-lista-det-aux.parcela FORMAT ">>>>9":U
      tt-adiant-despes-lista-det-aux.cod-emitente FORMAT ">>>>>>>>9":U
      fnNomeAbrev(tt-adiant-despes-lista-det-aux.cod-emitente) @ c-nome-abrev FORMAT "X(12)":U COLUMN-LABEL "Nome Abreviado"
      tt-adiant-despes-lista-det-aux.it-codigo FORMAT "X(16)":U
      fnDescItem(tt-adiant-despes-lista-det-aux.it-codigo) @ c-desc-item FORMAT "X(60)":U COLUMN-LABEL "Descri‡Æo"
ENABLE
      tt-adiant-despes-lista-det-aux.cod-espec-docto HELP "Esp‚cie"
      tt-adiant-despes-lista-det-aux.cod-ser-docto HELP "S‚rie"
      tt-adiant-despes-lista-det-aux.cod-tit-ap HELP "T¡tulo"
      tt-adiant-despes-lista-det-aux.dat-emissao HELP "Data EmissÆo"
      tt-adiant-despes-lista-det-aux.dat-vencto HELP "Data Vencto"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 75 BY 4.5
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-adiant-despes.cod-estabel AT ROW 1.25 COL 15 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-estabel AT ROW 1.25 COL 21.29 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     tt-adiant-despes.dat-implant AT ROW 1.25 COL 72 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-adiant-despes.cdd-adiant AT ROW 2.25 COL 15 COLON-ALIGNED WIDGET-ID 2
          LABEL "Adiantamento"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tt-adiant-despes.cdn-emitente AT ROW 3.25 COL 15 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-desc-emitente AT ROW 3.25 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     tt-adiant-despes.cdn-moeda AT ROW 4.25 COL 15 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 3 BY .88
     c-desc-moeda AT ROW 4.25 COL 18.29 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     tt-adiant-despes.val-adiant-moed AT ROW 4.25 COL 64.29 COLON-ALIGNED WIDGET-ID 12
          LABEL "Valor Adiantamento"
          VIEW-AS FILL-IN 
          SIZE 17.57 BY .79
     tt-adiant-despes-lista.num-seq-lista AT ROW 5.5 COL 15 COLON-ALIGNED WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-adiant-despes-lista.idi-lancto AT ROW 5.5 COL 69.57 NO-LABEL WIDGET-ID 32
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Manual", 1,
"Autom tico", 2
          SIZE 19.72 BY .71
     tt-adiant-despes-lista.desc-identif AT ROW 6.67 COL 57 COLON-ALIGNED NO-LABEL WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 30 BY .88
     tt-adiant-despes-lista.idi-identif AT ROW 6.75 COL 7.29 NO-LABEL WIDGET-ID 26
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Despesa", 1,
"Mercadoria", 2,
"Imposto", 3,
"Outros", 4
          SIZE 51 BY .71
     tt-adiant-despes-lista.cod-refer AT ROW 7.92 COL 75 COLON-ALIGNED WIDGET-ID 48
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-adiant-despes-lista.idi-operac-antecip AT ROW 8 COL 7.57 NO-LABEL WIDGET-ID 36
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Gera Nova Antecipa‡Æo", 1,
"Atualiza Antecipa‡Æo", 2,
"Adiciona na Antecipa‡Æo", 3
          SIZE 58.43 BY .71
     btOK AT ROW 24.46 COL 2
     btSave AT ROW 24.46 COL 13
     btCancel AT ROW 24.46 COL 24
     btHelp AT ROW 24.46 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 24.21 COL 1
     RECT-1 AT ROW 7.75 COL 4 WIDGET-ID 50
     RECT-2 AT ROW 6.5 COL 4 WIDGET-ID 52
     RECT-3 AT ROW 5.29 COL 1 WIDGET-ID 54
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 24.83
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     de-tot-vinculado AT ROW 13 COL 54.14 COLON-ALIGNED WIDGET-ID 32
     tt-adiant-despes-lista.cod-embarq AT ROW 1.17 COL 10 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     bt-ent AT ROW 1.13 COL 30.14 WIDGET-ID 30
     tt-adiant-despes-lista.num-di-ems AT ROW 1.17 COL 40.43 COLON-ALIGNED WIDGET-ID 26
          LABEL "DI EMS"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-di-siscomex AT ROW 1.08 COL 60.86 COLON-ALIGNED WIDGET-ID 28
     browse-1 AT ROW 2.46 COL 3 WIDGET-ID 200
     bt-marca1 AT ROW 6.96 COL 3 WIDGET-ID 4
     bt-vinc AT ROW 2.46 COL 80 WIDGET-ID 8
     bt-vinc-parc AT ROW 3.71 COL 80 WIDGET-ID 10
     bt-vinc-all AT ROW 4.96 COL 80 WIDGET-ID 12
     bt-filtro AT ROW 6.21 COL 80 WIDGET-ID 14
     browse-2 AT ROW 8.17 COL 3 WIDGET-ID 300
     bt-marca2 AT ROW 12.71 COL 3 WIDGET-ID 6
     bt-desv AT ROW 8.13 COL 80 WIDGET-ID 16
     bt-desv-all AT ROW 9.38 COL 80 WIDGET-ID 18
     bt-filtro2 AT ROW 10.63 COL 80 WIDGET-ID 20
     bt-observa AT ROW 11.88 COL 80 WIDGET-ID 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 10.25
         SIZE 84.43 BY 13.46
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 10.25
         SIZE 84.43 BY 13.46
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-adiant-despes T "?" NO-UNDO mgcex adiant-despes
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-adiant-despes-lista T "?" NO-UNDO mgcex adiant-despes-lista
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-adiant-despes-lista-det T "?" NO-UNDO mgcex adiant-despes-lista-det
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-adiant-despes-parc T "?" NO-UNDO mgcex adiant-despes-parc
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 25.08
         WIDTH              = 90
         MAX-HEIGHT         = 38.46
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.46
         VIRTUAL-WIDTH      = 182.86
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-adiant-despes.cdd-adiant IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-adiant-despes.val-adiant-moed IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FRAME fPage2
   Custom                                                               */
/* BROWSE-TAB browse-1 c-di-siscomex fPage2 */
/* BROWSE-TAB browse-2 bt-filtro fPage2 */
/* SETTINGS FOR FILL-IN tt-adiant-despes-lista.num-di-ems IN FRAME fPage2
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE browse-1
/* Query rebuild information for BROWSE browse-1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-embarque.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE browse-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE browse-2
/* Query rebuild information for BROWSE browse-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-adiant-despes-lista-det-aux.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE browse-2 */
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

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME browse-1
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME browse-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL browse-1 wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF browse-1 IN FRAME fPage2
DO:
    IF AVAIL tt-ordens-embarque THEN DO:
        IF tt-ordens-embarque.marca = "*":U THEN DO:
            ASSIGN tt-ordens-embarque.marca = "".
        END.
        ELSE
            ASSIGN tt-ordens-embarque.marca = "*":U.
            
        DISP tt-ordens-embarque.marca WITH BROWSE browse-1.
       
    END.
    
    RUN pi-atualiza-botoes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME browse-2
&Scoped-define SELF-NAME browse-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL browse-2 wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF browse-2 IN FRAME fPage2
DO:
    IF AVAIL tt-adiant-despes-lista-det-aux THEN DO:
        IF tt-adiant-despes-lista-det-aux.marca = "*":U THEN DO:
            ASSIGN tt-adiant-despes-lista-det-aux.marca = "".
        END.
        ELSE
            ASSIGN tt-adiant-despes-lista-det-aux.marca = "*":U.
            
        DISP tt-adiant-despes-lista-det-aux.marca WITH BROWSE browse-2.
       
    END.
    
    RUN pi-atualiza-botoes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL browse-2 wMaintenanceNoNavigation
ON ROW-LEAVE OF browse-2 IN FRAME fPage2
DO:
  ASSIGN INPUT BROWSE browse-2 tt-adiant-despes-lista-det-aux.dat-vencto
         INPUT BROWSE browse-2 tt-adiant-despes-lista-det-aux.cod-espec-docto
         INPUT BROWSE browse-2 tt-adiant-despes-lista-det-aux.cod-tit-ap
         INPUT BROWSE browse-2 tt-adiant-despes-lista-det-aux.dat-emissao
         INPUT BROWSE browse-2 tt-adiant-despes-lista-det-aux.dat-vencto.

  FOR FIRST tt-adiant-despes-lista-det-fil
      WHERE tt-adiant-despes-lista-det-fil.cod-estabel   = tt-adiant-despes-lista-det-aux.cod-estabel
        AND tt-adiant-despes-lista-det-fil.cdd-adiant    = tt-adiant-despes-lista-det-aux.cdd-adiant
        AND tt-adiant-despes-lista-det-fil.cod-refer     = tt-adiant-despes-lista-det-aux.cod-refer
        AND tt-adiant-despes-lista-det-fil.num-seq-lista = tt-adiant-despes-lista-det-aux.num-seq-lista:

    ASSIGN tt-adiant-despes-lista-det-fil.dat-vencto      = tt-adiant-despes-lista-det-aux.dat-vencto
           tt-adiant-despes-lista-det-fil.cod-espec-docto = tt-adiant-despes-lista-det-aux.cod-espec-docto
           tt-adiant-despes-lista-det-fil.cod-tit-ap      = tt-adiant-despes-lista-det-aux.cod-tit-ap
           tt-adiant-despes-lista-det-fil.dat-emissao     = tt-adiant-despes-lista-det-aux.dat-emissao
           tt-adiant-despes-lista-det-fil.dat-vencto      = tt-adiant-despes-lista-det-aux.dat-vencto.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desv wMaintenanceNoNavigation
ON CHOOSE OF bt-desv IN FRAME fPage2 /* Button 7 */
DO:
    IF NOT CAN-FIND(FIRST tt-adiant-despes-lista-det-aux
                    WHERE tt-adiant-despes-lista-det-aux.marca <> "") THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 35921,
                           INPUT "").
    END.
    ELSE
        RUN pi-desvincula.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desv-all
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desv-all wMaintenanceNoNavigation
ON CHOOSE OF bt-desv-all IN FRAME fPage2 /* Button 8 */
DO:
    IF NOT CAN-FIND(FIRST tt-adiant-despes-lista-det-aux
                    WHERE tt-adiant-despes-lista-det-aux.marca <> "") THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 35921,
                           INPUT "").
    END.
    ELSE
        RUN pi-desvincula.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ent wMaintenanceNoNavigation
ON CHOOSE OF bt-ent IN FRAME fPage2 /* Button 11 */
DO:
   RUN findPk_codigo IN h-bocx220 (INPUT tt-adiant-despes.cod-estabel,
                                   INPUT INPUT FRAME fPage2 tt-adiant-despes-lista.cod-embarq,
                                   OUTPUT c-return).
   IF c-return <> "":U THEN DO:
      {utp/ut-liter.i Embarque *}
      RUN utp/ut-msgs.p (INPUT "show":U,
                         INPUT 2,
                         INPUT RETURN-VALUE).
   END.
   ELSE DO:
       RUN goToKeyEmbarque IN h-bocx00446 (INPUT tt-adiant-despes.cod-estabel,
                                           INPUT tt-adiant-despes.cdd-adiant,
                                           INPUT INPUT FRAME fPage2 tt-adiant-despes-lista.cod-embarq).
       IF RETURN-VALUE <> "OK":U THEN DO:
           /*verifica se o embarque est  vinculado ao adiantamento*/
           {utp/ut-liter.i Embarque * r}
           ASSIGN c-liter = TRIM(RETURN-VALUE).
           {utp/ut-liter.i Adiantamento * r}
           RUN utp/ut-msgs.p (INPUT "show":U,
                              INPUT 8691,
                              INPUT c-liter + "~~" + TRIM(RETURN-VALUE)).
       END.
       ELSE DO:
           RUN getIntField IN h-bocx00446 (INPUT "num-di-ems":U, OUTPUT tt-adiant-despes-lista.num-di-ems).
           DISP tt-adiant-despes-lista.num-di-ems WITH FRAME fpage2.
           RUN goToKeyCustom IN h-bocx383 (INPUT INPUT FRAME fPage2 tt-adiant-despes-lista.num-di-ems).
           IF RETURN-VALUE = "OK":U THEN DO:
               RUN getCharField IN h-bocx383 (INPUT "cod-di-siscomex", OUTPUT c-di-siscomex).
           END.
           DISP c-di-siscomex WITH FRAME fPage2.

           RUN pi-cria-tt-ordens-embarque (INPUT INPUT FRAME fPage2 tt-adiant-despes-lista.cod-embarq).

       END.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtro wMaintenanceNoNavigation
ON CHOOSE OF bt-filtro IN FRAME fPage2 /* Button 6 */
DO:
  RUN imp/im0720pr.w (INPUT NO,
                      INPUT-OUTPUT c-nr-proc-imp-ini,      
                      INPUT-OUTPUT c-nr-proc-imp-fim,      
                      INPUT-OUTPUT i-num-pedido-ini,       
                      INPUT-OUTPUT i-num-pedido-fim,       
                      INPUT-OUTPUT i-numero-ordem-ini,     
                      INPUT-OUTPUT i-numero-ordem-fim,     
                      INPUT-OUTPUT i-parcela-ini,          
                      INPUT-OUTPUT i-parcela-fim,          
                      INPUT-OUTPUT i-cod-emitente-ini,     
                      INPUT-OUTPUT i-cod-emitente-fim,     
                      INPUT-OUTPUT c-nome-abrev-ini,       
                      INPUT-OUTPUT c-nome-abrev-fim,       
                      INPUT-OUTPUT c-cod-refer-ini,        
                      INPUT-OUTPUT c-cod-refer-fim,        
                      INPUT-OUTPUT c-cod-espec-docto-ini,  
                      INPUT-OUTPUT c-cod-espec-docto-fim,  
                      INPUT-OUTPUT c-cod-ser-docto-ini,    
                      INPUT-OUTPUT c-cod-ser-docto-fim,    
                      INPUT-OUTPUT c-cod-tit-ap-ini,       
                      INPUT-OUTPUT c-cod-tit-ap-fim,       
                      INPUT-OUTPUT c-cod-parcela-ini,      
                      INPUT-OUTPUT c-cod-parcela-fim,      
                      INPUT-OUTPUT dt-dat-emissao-ini,     
                      INPUT-OUTPUT dt-dat-emissao-fim,     
                      INPUT-OUTPUT dt-dat-vencto-ini,      
                      INPUT-OUTPUT dt-dat-vencto-fim,      
                      INPUT-OUTPUT de-val-adiant-moed-ini, 
                      INPUT-OUTPUT de-val-adiant-moed-fim, 
                      OUTPUT       l-usou-filtro).

  IF l-usou-filtro THEN DO:
      RUN piCriaBrowserOrdens IN h-bocx00444 (INPUT c-nr-proc-imp-ini,      
                                              INPUT c-nr-proc-imp-fim,      
                                              INPUT i-num-pedido-ini,       
                                              INPUT i-num-pedido-fim,       
                                              INPUT i-numero-ordem-ini,     
                                              INPUT i-numero-ordem-fim,     
                                              INPUT i-parcela-ini,          
                                              INPUT i-parcela-fim,          
                                              INPUT i-cod-emitente-ini,     
                                              INPUT i-cod-emitente-fim,     
                                              INPUT c-nome-abrev-ini,       
                                              INPUT c-nome-abrev-fim,       
                                              INPUT  TABLE tt-ordens-embarque-aux,
                                              OUTPUT TABLE tt-ordens-embarque).

      {&OPEN-QUERY-browse-1}
  END.
  ASSIGN l-usou-filtro = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtro2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtro2 wMaintenanceNoNavigation
ON CHOOSE OF bt-filtro2 IN FRAME fPage2 /* Button 9 */
DO:

  RUN imp/im0720pr.w (INPUT YES,
                      INPUT-OUTPUT c-nr-proc-imp-ini-filtro2,      
                      INPUT-OUTPUT c-nr-proc-imp-fim-filtro2,      
                      INPUT-OUTPUT i-num-pedido-ini-filtro2,       
                      INPUT-OUTPUT i-num-pedido-fim-filtro2,       
                      INPUT-OUTPUT i-numero-ordem-ini-filtro2,     
                      INPUT-OUTPUT i-numero-ordem-fim-filtro2,     
                      INPUT-OUTPUT i-parcela-ini-filtro2,          
                      INPUT-OUTPUT i-parcela-fim-filtro2,          
                      INPUT-OUTPUT i-cod-emitente-ini-filtro2,     
                      INPUT-OUTPUT i-cod-emitente-fim-filtro2,     
                      INPUT-OUTPUT c-nome-abrev-ini-filtro2,       
                      INPUT-OUTPUT c-nome-abrev-fim-filtro2,       
                      INPUT-OUTPUT c-cod-refer-ini,        
                      INPUT-OUTPUT c-cod-refer-fim,        
                      INPUT-OUTPUT c-cod-espec-docto-ini,  
                      INPUT-OUTPUT c-cod-espec-docto-fim,  
                      INPUT-OUTPUT c-cod-ser-docto-ini,    
                      INPUT-OUTPUT c-cod-ser-docto-fim,    
                      INPUT-OUTPUT c-cod-tit-ap-ini,       
                      INPUT-OUTPUT c-cod-tit-ap-fim,       
                      INPUT-OUTPUT c-cod-parcela-ini,      
                      INPUT-OUTPUT c-cod-parcela-fim,      
                      INPUT-OUTPUT dt-dat-emissao-ini,     
                      INPUT-OUTPUT dt-dat-emissao-fim,     
                      INPUT-OUTPUT dt-dat-vencto-ini,      
                      INPUT-OUTPUT dt-dat-vencto-fim,      
                      INPUT-OUTPUT de-val-adiant-moed-ini, 
                      INPUT-OUTPUT de-val-adiant-moed-fim, 
                      OUTPUT       l-usou-filtro).

   IF l-usou-filtro THEN DO:

      RUN piCriaBrowserAntecipacao IN h-bocx00444 (INPUT c-nr-proc-imp-ini-filtro2,      
                                                   INPUT c-nr-proc-imp-fim-filtro2,      
                                                   INPUT i-num-pedido-ini-filtro2,       
                                                   INPUT i-num-pedido-fim-filtro2,       
                                                   INPUT i-numero-ordem-ini-filtro2,     
                                                   INPUT i-numero-ordem-fim-filtro2,     
                                                   INPUT i-parcela-ini-filtro2,          
                                                   INPUT i-parcela-fim-filtro2,          
                                                   INPUT i-cod-emitente-ini-filtro2,     
                                                   INPUT i-cod-emitente-fim-filtro2,     
                                                   INPUT c-nome-abrev-ini-filtro2,       
                                                   INPUT c-nome-abrev-fim-filtro2,       
                                                   INPUT c-cod-refer-ini,        
                                                   INPUT c-cod-refer-fim,        
                                                   INPUT c-cod-espec-docto-ini,  
                                                   INPUT c-cod-espec-docto-fim,  
                                                   INPUT c-cod-ser-docto-ini,    
                                                   INPUT c-cod-ser-docto-fim,    
                                                   INPUT c-cod-tit-ap-ini,       
                                                   INPUT c-cod-tit-ap-fim,       
                                                   INPUT c-cod-parcela-ini,      
                                                   INPUT c-cod-parcela-fim,      
                                                   INPUT dt-dat-emissao-ini,     
                                                   INPUT dt-dat-emissao-fim,     
                                                   INPUT dt-dat-vencto-ini,      
                                                   INPUT dt-dat-vencto-fim,      
                                                   INPUT de-val-adiant-moed-ini, 
                                                   INPUT de-val-adiant-moed-fim, 
                                                   INPUT  TABLE tt-adiant-despes-lista-det-fil,
                                                   OUTPUT TABLE tt-adiant-despes-lista-det-aux).

      {&OPEN-QUERY-browse-2}
  END.
  ASSIGN l-usou-filtro = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca1 wMaintenanceNoNavigation
ON CHOOSE OF bt-marca1 IN FRAME fPage2 /* Marca Todos */
DO:
    IF bt-marca1:LABEL IN FRAME fPage2 = c-marcar  THEN
       ASSIGN c-filtro = "".
    ELSE
       ASSIGN c-filtro = "*":U.

   FOR EACH tt-ordens-embarque
      WHERE tt-ordens-embarque.marca = c-filtro:

      IF c-filtro = "" THEN
          ASSIGN tt-ordens-embarque.marca = "*":U.
      ELSE          
          ASSIGN tt-ordens-embarque.marca = "":U.
   END.
   {&OPEN-QUERY-browse-1}

    RUN pi-atualiza-botoes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca2 wMaintenanceNoNavigation
ON CHOOSE OF bt-marca2 IN FRAME fPage2 /* Marca Todos */
DO:
   IF bt-marca2:LABEL IN FRAME fPage2 = c-marcar  THEN
       ASSIGN c-filtro = "".
   ELSE
       ASSIGN c-filtro = "*":U.

   FOR EACH tt-adiant-despes-lista-det-aux
      WHERE tt-adiant-despes-lista-det-aux.marca = c-filtro:

      IF c-filtro = "" THEN
          ASSIGN tt-adiant-despes-lista-det-aux.marca = "*":U.
      ELSE          
          ASSIGN tt-adiant-despes-lista-det-aux.marca = "":U.
   END.
   {&OPEN-QUERY-browse-2}

    RUN pi-atualiza-botoes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-observa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-observa wMaintenanceNoNavigation
ON CHOOSE OF bt-observa IN FRAME fPage2 /* Button 10 */
DO:
    if browse-2:num-selected-rows in frame fPage2 = 0 then do:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 35921,
                           INPUT "").
    end.
    ELSE DO:
        IF browse-2:num-selected-rows in frame fPage2 > 1 then do: 
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 51921,
                               INPUT "").
        END.
    END.

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

    DEFINE VARIABLE h-prog1 AS HANDLE     NO-UNDO.

    EMPTY TEMP-TABLE tt-adiant-despes-lista-det-aux2.
    CREATE tt-adiant-despes-lista-det-aux2.
    BUFFER-COPY tt-adiant-despes-lista-det-aux TO tt-adiant-despes-lista-det-aux2.

    RUN imp/im0720d1.w PERSISTENT SET h-prog1 (INPUT TABLE tt-adiant-despes-lista-det-aux2,
                                               INPUT THIS-PROCEDURE).

    RUN initializeinterface IN h-prog1.
    WAIT-FOR CLOSE OF h-prog1 FOCUS CURRENT-WINDOW.

    {&WINDOW-NAME}:SENSITIVE = YES.
    APPLY "ENTRY":U TO {&WINDOW-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-vinc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-vinc wMaintenanceNoNavigation
ON CHOOSE OF bt-vinc IN FRAME fPage2 /* Button 3 */
DO:
    IF NOT CAN-FIND(FIRST tt-ordens-embarque
                    WHERE tt-ordens-embarque.marca <> "") THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 35921,
                           INPUT "").
    END.
    ELSE
        RUN pi-vincula.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-vinc-all
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-vinc-all wMaintenanceNoNavigation
ON CHOOSE OF bt-vinc-all IN FRAME fPage2 /* Button 5 */
DO:
    IF NOT CAN-FIND(FIRST tt-ordens-embarque
                    WHERE tt-ordens-embarque.marca <> "") THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 35921,
                           INPUT "").
    END.
    ELSE
        RUN pi-vincula.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    SAVE_block:
    DO TRANS ON ERROR UNDO SAVE_block, LEAVE SAVE_block:
        IF CAN-FIND(FIRST tt-adiant-despes-lista-det-aux) THEN
            RUN piCriaAdiantDespesParcLista IN THIS-PROCEDURE.

        IF  CAN-FIND(FIRST RowErrors
                     WHERE RowErrors.ErrorType <> "INTERNAL":U ) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal=YES}
            IF  CAN-FIND(FIRST RowErrors
                         WHERE RowErrors.ErrorType    <> "INTERNAL":U
                         AND   RowErrors.ErrorSubType  = "ERROR":U    ) THEN
                UNDO,LEAVE.
        END.

        IF  RETURN-VALUE = "OK":U 
        AND NOT CAN-FIND(FIRST RowErrors 
                         WHERE RowErrors.ErrorSubType <> "INTERNAL":U) THEN DO:
            RUN piAtualizaValorAdiantamento in h-bocx00442 (INPUT tt-adiant-despes.cod-estabel,
                                                            INPUT tt-adiant-despes.cdd-adiant). 
            RUN bringParent   IN phCaller.
            RUN DisplayFields IN phCaller.
            APPLY "CLOSE":U TO THIS-PROCEDURE.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-adiant-despes.cdn-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes.cdn-emitente wMaintenanceNoNavigation
ON LEAVE OF tt-adiant-despes.cdn-emitente IN FRAME fpage0 /* Emitente */
DO:
      {method/ReferenceFields.i
          &HandleDBOLeave="h-boad098"
          &FindMethod="findCodigo"
          &KeyValue1="integer(tt-adiant-despes.cdn-emitente:SCREEN-VALUE IN FRAME fPage0)"
          &FieldName1="nome-emit"
          &FieldScreen1="c-desc-emitente"
          &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-adiant-despes.cdn-moeda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes.cdn-moeda wMaintenanceNoNavigation
ON LEAVE OF tt-adiant-despes.cdn-moeda IN FRAME fpage0 /* C¢digo Moeda */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-boun005"
      &FindMethod="findCodigo"
      &KeyValue1="integer(tt-adiant-despes.cdn-moeda:SCREEN-VALUE IN FRAME fPage0)"
      &FieldName1="descricao"
      &FieldScreen1="c-desc-moeda"
      &Frame1="fPage0"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-adiant-despes.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-adiant-despes.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    {method/referencefields.i 
        &HandleDBOLeave="h-boad107"
        &FindMethod="findCodigo"
        &KeyValue1="tt-adiant-despes.cod-estabel:SCREEN-VALUE IN FRAME fPage0"
        &FieldName1="nome"
        &FieldScreen1="c-desc-estabel"
        &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-adiant-despes-lista.idi-identif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes-lista.idi-identif wMaintenanceNoNavigation
ON VALUE-CHANGED OF tt-adiant-despes-lista.idi-identif IN FRAME fpage0
DO:
  IF INPUT FRAME {&FRAME-NAME} tt-adiant-despes-lista.idi-identif = 4 THEN
      ASSIGN tt-adiant-despes-lista.desc-identif:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  ELSE
      ASSIGN tt-adiant-despes-lista.desc-identif:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

  IF INPUT FRAME {&FRAME-NAME} tt-adiant-despes-lista.idi-identif <> 2 THEN DO:
      RUN setEnabled IN hFolder (1,YES). /*habilita o folder das despesas/impostos*/
      RUN setEnabled IN hFolder (2, NO). /*desabilita o folder da mercadoria*/

  END.
  ELSE DO:
      RUN setEnabled IN hFolder (2,YES). /*habilita o folder da mercadoria*/
      RUN setEnabled IN hFolder (1, NO). /*desabilita o folder das despesas/impostos*/

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-adiant-despes-lista.idi-operac-antecip
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes-lista.idi-operac-antecip wMaintenanceNoNavigation
ON VALUE-CHANGED OF tt-adiant-despes-lista.idi-operac-antecip IN FRAME fpage0
DO:
  IF INPUT FRAME {&FRAME-NAME} tt-adiant-despes-lista.idi-operac-antecip = 1 THEN
      ASSIGN tt-adiant-despes-lista.cod-refer:SENSITIVE    IN FRAME {&FRAME-NAME} = NO
             tt-adiant-despes-lista.cod-refer:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U.
  ELSE
      ASSIGN tt-adiant-despes-lista.cod-refer:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME browse-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-adiant-despes-lista.cod-embarq:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.
tt-adiant-despes-lista.cod-refer:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-adiant-despes-lista-det-aux.cod-espec-docto:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN BROWSE browse-2.
tt-adiant-despes-lista-det-aux.cod-ser-docto:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN BROWSE browse-2.

/* Zoom Esp‚cie frame2 */
ON  "F5", mouse-select-dblclick OF tt-adiant-despes-lista-det-aux.cod-espec-docto IN BROWSE browse-2
DO:
     {include/zoomvar.i 
        &prog-zoom=adzoom/z01ad103.w
        &campo=tt-adiant-despes-lista-det-aux.cod-espec-docto
        &campozoom=cod-esp
        &browse=browse-2}
        
END.

/* Zoom S‚rie frame2 */
ON  "F5", mouse-select-dblclick OF tt-adiant-despes-lista-det-aux.cod-ser-docto IN BROWSE browse-2
DO:
    {include/zoomvar.i 
        &prog-zoom=dizoom/z01di182.w
        &campo=tt-adiant-despes-lista-det-aux.cod-ser-docto
        &campozoom=serie
        &browse="browse-2"}
         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     Elimina os handles instanciados no programa
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(h-boad098) THEN DO:
        DELETE PROCEDURE h-boad098.
        ASSIGN h-boad098 = ?.
    END.

    IF VALID-HANDLE(h-boad107) THEN DO:
        DELETE PROCEDURE h-boad107.
        ASSIGN h-boad107 = ?.
    END.

    IF VALID-HANDLE(h-boun005) THEN DO:
        DELETE PROCEDURE h-boun005.
        ASSIGN h-boun005 = ?.
    END.

    IF VALID-HANDLE(h-bocx383) THEN DO:
        DELETE PROCEDURE h-bocx383.
        ASSIGN h-bocx383 = ?.
    END.

    IF VALID-HANDLE(h-bocx220) THEN DO:
        DELETE PROCEDURE h-bocx220.
        ASSIGN h-bocx220 = ?.
    END.

    IF VALID-HANDLE(h-bocx250) THEN DO:
        DELETE PROCEDURE h-bocx250.
        ASSIGN h-bocx250 = ?.
    END.

    IF VALID-HANDLE(h-bocx00443) THEN DO:
        DELETE PROCEDURE h-bocx00443.
        ASSIGN h-bocx00443 = ?.
    END.

    IF VALID-HANDLE(h-bocx00442) THEN DO:
        DELETE PROCEDURE h-bocx00442.
        ASSIGN h-bocx00442 = ?.
    END.

    IF VALID-HANDLE(h-bocx00446) THEN DO:
        DELETE PROCEDURE h-bocx00446.
        ASSIGN h-bocx00446 = ?.
    END.

    IF VALID-HANDLE(h-bocx00447) THEN DO:
        DELETE PROCEDURE h-bocx00447.
        ASSIGN h-bocx00447 = ?.
    END.

    IF VALID-HANDLE(h-boin172) THEN DO:
        DELETE PROCEDURE h-boin172.
        ASSIGN h-boin172 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     Realizar o controle dos campos que deverÆo ficar habilitados em tela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF pcAction = "ADD":U THEN
        ASSIGN tt-adiant-despes-lista.idi-lancto:SENSITIVE  IN FRAME fPage0 = NO
               tt-adiant-despes-lista.num-di-ems:SENSITIVE  IN FRAME fPage2 = NO
               bt-ent:SENSITIVE IN FRAME fPage2 = YES.
    ELSE
        ASSIGN bt-ent:SENSITIVE IN FRAME fPage2 = NO
               tt-adiant-despes-lista.num-seq-lista:SENSITIVE IN FRAME fPage0 = NO.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     Realiza inicializa‡Æo dos campos e informa‡äes de tela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-des-sigla AS CHARACTER   NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx00444) OR
       h-bocx00444:TYPE <> "PROCEDURE":U OR
       h-bocx00444:FILE-NAME <> "cxbo/bocx00444.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx00444.p YES}
        {btb/btb008za.i2 cxbo/bocx00444.p '' h-bocx00444} 
    END.
    RUN openQueryStatic IN h-bocx00444 (INPUT "Main":U).

    IF NOT VALID-HANDLE(h-bocx00442) THEN DO:
       RUN cxbo/bocx00442.p PERSISTENT SET h-bocx00442.
    END.
    RUN openQueryStatic IN h-bocx00442 (INPUT "Main":U).

    IF NOT VALID-HANDLE(h-bocx00446) THEN DO:
       RUN cxbo/bocx00446.p PERSISTENT SET h-bocx00446.
    END.
    RUN openQueryStatic IN h-bocx00446 (INPUT "Main":U).

    IF NOT VALID-HANDLE(h-boin172) THEN
        RUN inbo/boin172.p PERSISTENT SET h-boin172.
    RUN openQueryStatic IN h-boin172 (INPUT "Main":U).

    IF NOT VALID-HANDLE(h-bocx00443) THEN 
       RUN cxbo/bocx00443.p PERSISTENT SET h-bocx00443.
    RUN openQueryStatic IN h-bocx00443 (INPUT "Main":U).

    IF NOT VALID-HANDLE(h-bocx00447) THEN 
       RUN cxbo/bocx00447.p PERSISTENT SET h-bocx00447.

    IF NOT VALID-HANDLE(h-boad098) THEN
        RUN adbo/boad098.p PERSISTENT SET h-boad098.

    IF NOT VALID-HANDLE(h-boun005) THEN
        RUN unbo/boun005.p PERSISTENT SET h-boun005.

    IF NOT VALID-HANDLE(h-boad107) THEN
        RUN adbo/boad107.p PERSISTENT SET h-boad107.

    IF NOT VALID-HANDLE(h-bocx383) THEN
        RUN cxbo/bocx383.p PERSISTENT SET h-bocx383.
    RUN openQueryStatic IN h-bocx383 (INPUT "Main":U).

    IF NOT VALID-HANDLE(h-bocx220) THEN
        RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.

    IF NOT VALID-HANDLE(h-bocx250) THEN
        RUN cxbo/bocx250.p PERSISTENT SET h-bocx250.

    {utp/ut-liter.i "Marca_Todos" *}
    ASSIGN c-marcar = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Desmarca_Todos" *}
    ASSIGN c-desmarcar = TRIM(RETURN-VALUE).

    ASSIGN bt-marca1:LABEL IN FRAME fpage2 = c-marcar
           bt-marca2:LABEL IN FRAME fpage2 = c-marcar.

    APPLY "leave":U TO tt-adiant-despes.cod-estabel  IN FRAME fPage0.
    APPLY "leave":U TO tt-adiant-despes.cdn-emitente IN FRAME fPage0.
    APPLY "leave":U TO tt-adiant-despes.cdn-moeda    IN FRAME fPage0.

    APPLY "value-changed":U TO tt-adiant-despes-lista.idi-identif.
    APPLY "value-changed":U TO tt-adiant-despes-lista.idi-operac-antecip.

    IF pcAction = "ADD":U THEN DO:
        RUN getNextSeq  IN h-bocx00444 (INPUT tt-adiant-despes.cod-estabel,
                                        INPUT tt-adiant-despes.cdd-adiant,
                                        OUTPUT tt-adiant-despes-lista.num-seq-lista).
    END.
    ELSE
        IF pcAction = "UPDATE":U THEN DO:
            RUN pi-cria-tt-ordens-embarque (INPUT INPUT FRAME fPage2 tt-adiant-despes-lista.cod-embarq).
        END.

    DISP tt-adiant-despes-lista.num-seq-lista
        WITH FRAME fPage0.

    RUN findCodigo IN h-boun005 (INPUT tt-adiant-despes.cdn-moeda, OUTPUT c-return).
    IF c-return = "" THEN 
        RUN getCharField IN h-boun005 (INPUT "sigla":U, OUTPUT c-des-sigla).
    {utp/ut-liter.i Total_Vinculado * R}
    ASSIGN de-tot-vinculado:LABEL IN FRAME fPage2 = TRIM(RETURN-VALUE) + "(" + c-des-sigla + ")".

    ENABLE browse-1 browse-2 WITH FRAME fPage2.

    RUN pi-inicializa-filtro.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-botoes wMaintenanceNoNavigation 
PROCEDURE pi-atualiza-botoes :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza estado e label dos botäes
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN bt-marca1:LABEL IN FRAME fPage2 = IF CAN-FIND(FIRST tt-ordens-embarque
                                                         WHERE tt-ordens-embarque.marca = "":U) 
                                              THEN c-marcar 
                                              ELSE 
                                              IF NOT AVAIL tt-ordens-embarque
                                                 THEN c-marcar
                                              ELSE c-desmarcar
           bt-marca2:LABEL IN FRAME fPage2 = IF CAN-FIND(FIRST tt-adiant-despes-lista-det-aux
                                                         WHERE tt-adiant-despes-lista-det-aux.marca = "":U) 
                                              THEN c-marcar 
                                              ELSE 
                                              IF NOT AVAIL tt-adiant-despes-lista-det-aux
                                                 THEN c-marcar
                                              ELSE c-desmarcar
           bt-marca1:SENSITIVE IN FRAME fPage2 = CAN-FIND(FIRST tt-ordens-embarque)
           bt-marca2:SENSITIVE IN FRAME fPage2 = CAN-FIND(FIRST tt-adiant-despes-lista-det-aux).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-valor-total wMaintenanceNoNavigation 
PROCEDURE pi-atualiza-valor-total :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza o valor total no campo "Total Vinculado"
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN de-tot-vinculado = 0.

    FOR EACH tt-adiant-despes-lista-det-aux:
        ASSIGN de-tot-vinculado = de-tot-vinculado + tt-adiant-despes-lista-det-aux.val-adiant-moed.
    END.

    IF de-tot-vinculado < 0 THEN
        ASSIGN de-tot-vinculado = 0.

    DISP de-tot-vinculado 
        WITH FRAME fPage2.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-antecipacao wMaintenanceNoNavigation 
PROCEDURE pi-cria-antecipacao :
/*------------------------------------------------------------------------------
  Purpose:     Realiza a cria‡Æo da antecipa‡Æo para os registros selecionados no browser
  Parameters:  pl-cria-unica-referencia: identifica se todos os registros irÆo gerar uma unica antecipa‡Æo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-cria-unica-referencia AS LOGICAL NO-UNDO.

    DEFINE VARIABLE i-cont-seq     AS   INTEGER                        NO-UNDO.
    DEFINE VARIABLE c-cod-parcela  LIKE adiant-despes-parc.cod-parcela NO-UNDO.
    DEFINE VARIABLE c-cod-parcela-aux  LIKE adiant-despes-parc.cod-parcela NO-UNDO.
    DEFINE VARIABLE i-parcela AS INTEGER     NO-UNDO.

    IF INPUT FRAME fPage0 tt-adiant-despes-lista.idi-operac-antecip = 1 THEN DO:
        RUN findCodigo IN h-bocx250 (INPUT  tt-adiant-despes.cod-estabel,
                                     OUTPUT c-return).
        IF c-return = "" THEN DO:
            RUN getCharField IN h-bocx250 (INPUT "cod-espec-antecip", OUTPUT c-cod-espec-docto).
            RUN getCharField IN h-bocx250 (INPUT "cod-ser-antecip",   OUTPUT c-cod-ser-docto).
        END.
    END.

    IF INPUT FRAME fPage0 tt-adiant-despes-lista.idi-operac-antecip = 1  THEN DO:
        IF pl-cria-unica-referencia  THEN DO:
            RUN picriaReferencia    IN h-bocx00443 (INPUT  tt-adiant-despes.cod-estabel, 
                                                    OUTPUT c-cod-refer).
        END.
    END.
    ELSE DO:
         RUN goToKeyAdiant IN h-bocx00443 (INPUT tt-adiant-despes.cod-estabel,
                                           INPUT tt-adiant-despes.cdd-adiant,
                                           INPUT INPUT FRAME fPage0 tt-adiant-despes-lista.cod-refer).
         IF RETURN-VALUE <> "OK":U THEN
            RETURN NO-APPLY.

         RUN getCurrent IN h-bocx00443 (OUTPUT TABLE tt-adiant-despes-parc-retorno).

         FOR FIRST tt-adiant-despes-parc-retorno:
         END.
    END.

    ASSIGN i-cont-seq = 0
           i-parcela  = 1.
    FOR EACH tt-ordens-embarque 
       WHERE tt-ordens-embarque.marca <> "":

       IF CAN-FIND(FIRST tt-ordens-embarque
                   WHERE tt-ordens-embarque.mo-codigo <> tt-adiant-despes.cdn-moeda) THEN DO:
           RUN utp/ut-msgs.p (INPUT "show":U,
                              INPUT 55028,
                              INPUT tt-adiant-despes.cdn-moeda).
            NEXT.
       END.

       IF  NOT pl-cria-unica-referencia 
       AND INPUT FRAME fPage0 tt-adiant-despes-lista.idi-operac-antecip = 1 THEN
            RUN picriaReferencia    IN h-bocx00443 (INPUT  tt-ordens-embarque.cod-estabel, 
                                                    OUTPUT c-cod-refer).

       ASSIGN i-cont-seq = 1.

       FOR LAST tt-adiant-despes-lista-det-aux
          WHERE tt-adiant-despes-lista-det-aux.cod-estabel   = tt-adiant-despes.cod-estabel
            AND tt-adiant-despes-lista-det-aux.cdd-adiant    = tt-adiant-despes.cdd-adiant
            AND tt-adiant-despes-lista-det-aux.num-seq-lista = INPUT FRAME fPage0 tt-adiant-despes-lista.num-seq-lista:
           ASSIGN i-cont-seq = i-cont-seq + tt-adiant-despes-lista-det-aux.num-seq-det.
       END.

       IF NOT CAN-FIND(FIRST tt-adiant-despes-lista-det-aux
                       WHERE tt-adiant-despes-lista-det-aux.cod-estabel   = tt-adiant-despes.cod-estabel
                         AND tt-adiant-despes-lista-det-aux.cdd-adiant    = tt-adiant-despes.cdd-adiant
                         AND tt-adiant-despes-lista-det-aux.num-seq-lista = INPUT FRAME fPage0 tt-adiant-despes-lista.num-seq-lista
                         AND tt-adiant-despes-lista-det-aux.num-seq-det   = i-cont-seq) THEN DO:

           CREATE tt-adiant-despes-lista-det-aux.
           /*chave da tabela adiant-despes-lista-det*/
           ASSIGN tt-adiant-despes-lista-det-aux.cod-estabel       = tt-adiant-despes.cod-estabel
                  tt-adiant-despes-lista-det-aux.cdd-adiant        = tt-adiant-despes.cdd-adiant
                  tt-adiant-despes-lista-det-aux.num-seq-lista     = INPUT FRAME fPage0 tt-adiant-despes-lista.num-seq-lista
                  tt-adiant-despes-lista-det-aux.num-seq-det       = i-cont-seq.

       END.
       
       /*campos para tabela adiant-despes-parc*/
       ASSIGN tt-adiant-despes-lista-det-aux.cod-refer        = IF AVAIL tt-adiant-despes-parc-retorno THEN tt-adiant-despes-parc-retorno.cod-refer       ELSE c-cod-refer
              tt-adiant-despes-lista-det-aux.cod-espec-docto  = IF AVAIL tt-adiant-despes-parc-retorno THEN tt-adiant-despes-parc-retorno.cod-espec-docto ELSE c-cod-espec-docto
              tt-adiant-despes-lista-det-aux.cod-ser-docto    = IF AVAIL tt-adiant-despes-parc-retorno THEN tt-adiant-despes-parc-retorno.cod-ser-docto   ELSE c-cod-ser-docto  
              tt-adiant-despes-lista-det-aux.cod-tit-ap       = IF AVAIL tt-adiant-despes-parc-retorno THEN tt-adiant-despes-parc-retorno.cod-tit-ap      ELSE SUBSTRING(STRING(tt-adiant-despes.cdd-adiant),1,16).
        
        FOR LAST bf-adiant-despes-lista-det-aux
           WHERE bf-adiant-despes-lista-det-aux.cod-espec-docto = tt-adiant-despes-lista-det-aux.cod-espec-docto
             AND bf-adiant-despes-lista-det-aux.cod-ser-docto   = tt-adiant-despes-lista-det-aux.cod-ser-docto  
             AND bf-adiant-despes-lista-det-aux.cod-tit-ap      = tt-adiant-despes-lista-det-aux.cod-tit-ap     
             AND bf-adiant-despes-lista-det-aux.cod-parcela     <> "":
       END.
       IF NOT AVAIL bf-adiant-despes-lista-det-aux THEN
           ASSIGN c-cod-parcela-aux = "01":U.
       ELSE
           ASSIGN c-cod-parcela-aux = bf-adiant-despes-lista-det-aux.cod-parcela.

       RUN buscaParcelaAtual IN h-bocx00443 (INPUT tt-adiant-despes-lista-det-aux.cod-espec-docto, 
                                             INPUT tt-adiant-despes-lista-det-aux.cod-ser-docto,
                                             INPUT tt-adiant-despes-lista-det-aux.cod-tit-ap,
                                             INPUT tt-adiant-despes.cdn-emitente,
                                             OUTPUT c-cod-parcela).

       IF  INPUT FRAME fPage0 tt-adiant-despes-lista.idi-operac-antecip = 1 THEN DO:
           IF NOT pl-cria-unica-referencia THEN DO:
               /*verifica ultimo registro vinculado no browser para atualizar a numeracao da parcela*/
               IF AVAIL bf-adiant-despes-lista-det-aux
               AND bf-adiant-despes-lista-det-aux.cod-parcela > c-cod-parcela THEN
                    ASSIGN c-cod-parcela = bf-adiant-despes-lista-det-aux.cod-parcela.

               IF INT(c-cod-parcela) < 9 THEN DO:
                   ASSIGN tt-adiant-despes-lista-det-aux.cod-parcela = "0":U + STRING(INT(c-cod-parcela) + 1).
               END.
               ELSE DO:
                   ASSIGN tt-adiant-despes-lista-det-aux.cod-parcela = STRING(INT(c-cod-parcela) + 1).
               END.
           END.
           ELSE DO:
               /*mesma referencia, cria com informa‡Æo da parcela igual para realizar somat¢ria depois*/
               IF INT(tt-adiant-despes-lista-det-aux.cod-parcela) < 9 THEN DO:
                   IF AVAIL bf-adiant-despes-lista-det-aux
                   AND bf-adiant-despes-lista-det-aux.cod-parcela > c-cod-parcela THEN
                        ASSIGN c-cod-parcela = bf-adiant-despes-lista-det-aux.cod-parcela.
                   IF INT(c-cod-parcela) < 9 THEN DO:
                       ASSIGN tt-adiant-despes-lista-det-aux.cod-parcela = "0":U + STRING(INT(c-cod-parcela) + i-parcela).
                   END.
                   ELSE DO:
                       ASSIGN tt-adiant-despes-lista-det-aux.cod-parcela = STRING(INT(c-cod-parcela) + i-parcela).
                   END.
               END.
               ELSE DO:
                   ASSIGN tt-adiant-despes-lista-det-aux.cod-parcela = tt-adiant-despes-lista-det-aux.cod-parcela + string(1). /*era + 1*/
               END.
           END.
       END.
       ELSE DO:
            ASSIGN tt-adiant-despes-lista-det-aux.cod-parcela = tt-adiant-despes-parc-retorno.cod-parcela.
       END.

       ASSIGN tt-adiant-despes-lista-det-aux.dat-emissao      = IF AVAIL tt-adiant-despes-parc-retorno THEN tt-adiant-despes-parc-retorno.dat-emissao     ELSE TODAY
              tt-adiant-despes-lista-det-aux.dat-vencto       = IF AVAIL tt-adiant-despes-parc-retorno THEN tt-adiant-despes-parc-retorno.dat-vencto      ELSE ?
              tt-adiant-despes-lista-det-aux.val-adiant-moed  = tt-ordens-embarque.preco-total
              tt-adiant-despes-lista-det-aux.nr-proc-imp      = tt-ordens-embarque.nr-proc-imp
              tt-adiant-despes-lista-det-aux.num-pedido       = tt-ordens-embarque.num-pedido
              tt-adiant-despes-lista-det-aux.numero-ordem     = tt-ordens-embarque.numero-ordem
              tt-adiant-despes-lista-det-aux.parcela          = tt-ordens-embarque.parcela
              tt-adiant-despes-lista-det-aux.cod-embarq       = INPUT FRAME fPage2 tt-adiant-despes-lista.cod-embarq
              tt-adiant-despes-lista-det-aux.num-di-ems       = INPUT FRAME fPage2 tt-adiant-despes-lista.num-di-ems
              tt-adiant-despes-lista-det-aux.cod-emitente     = tt-ordens-embarque.cod-emitente
              tt-adiant-despes-lista-det-aux.it-codigo        = tt-ordens-embarque.it-codigo.

        {&open-query-browse-2}
        DELETE tt-ordens-embarque.
   END.

   {&open-query-browse-1}

   FOR EACH tt-adiant-despes-lista-det-aux:
        CREATE tt-adiant-despes-lista-det-fil.
        BUFFER-COPY tt-adiant-despes-lista-det-aux TO tt-adiant-despes-lista-det-fil.
    END.

   RUN pi-trata-botoes-laterais.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-ordens-embarque wMaintenanceNoNavigation 
PROCEDURE pi-cria-tt-ordens-embarque :
/*------------------------------------------------------------------------------
  Purpose:     Carrega os registros no browser das mercadorias a serem vinculadas
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-embarq  LIKE adiant-despes-lista.cod-embarq NO-UNDO.
    
    DEFINE VARIABLE l-existe AS LOGICAL     NO-UNDO.

    FOR EACH tt-ordens-embarque:
        DELETE tt-ordens-embarque.
    END.

    FOR EACH ordens-embarque NO-LOCK
        WHERE ordens-embarque.cod-estabel = tt-adiant-despes.cod-estabel
          AND ordens-embarque.embarque    = pc-cod-embarq:

        RUN piVerificaOrdensEmbarque IN h-bocx00447 (INPUT ordens-embarque.cod-estabel, 
                                                     INPUT ordens-embarque.embarque,    
                                                     INPUT ordens-embarque.nr-proc-imp, 
                                                     INPUT ordens-embarque.numero-ordem,
                                                     INPUT ordens-embarque.parcela,     
                                                     OUTPUT l-existe).

        IF CAN-FIND(FIRST tt-adiant-despes-lista-det-aux
                    WHERE tt-adiant-despes-lista-det-aux.cod-estabel  = ordens-embarque.cod-estabel
                      AND tt-adiant-despes-lista-det-aux.cod-embarq   = ordens-embarque.embarque
                      AND tt-adiant-despes-lista-det-aux.numero-ordem = ordens-embarque.numero-ordem
                      AND tt-adiant-despes-lista-det-aux.parcela      = ordens-embarque.parcela) 
        OR l-existe THEN NEXT.

        IF NOT CAN-FIND(FIRST tt-ordens-embarque
                        WHERE tt-ordens-embarque.cod-estabel  = ordens-embarque.cod-estabel
                          AND tt-ordens-embarque.embarque     = ordens-embarque.embarque
                          AND tt-ordens-embarque.numero-ordem = ordens-embarque.numero-ordem
                          AND tt-ordens-embarque.parcela      = ordens-embarque.parcela) THEN DO:
            CREATE tt-ordens-embarque.
            BUFFER-COPY ordens-embarque TO tt-ordens-embarque.
            ASSIGN tt-ordens-embarque.marca = "":U.

            FOR FIRST prazo-compra field (quantidade)
                 WHERE prazo-compra.numero-ordem = ordens-embarque.numero-ordem
                   AND prazo-compra.parcela      = ordens-embarque.parcela NO-LOCK:
                ASSIGN tt-ordens-embarque.quantidade   = prazo-compra.quantidade.
            END.


            FOR FIRST ordem-compra
                WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK:
                
                ASSIGN tt-ordens-embarque.cod-emitente = ordem-compra.cod-emitente
                       tt-ordens-embarque.it-codigo    = ordem-compra.it-codigo
                       tt-ordens-embarque.num-pedido   = ordem-compra.num-pedido.

                 FOR FIRST cotacao-item
                     WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                       AND cotacao-item.it-codigo    = ordem-compra.it-codigo
                       AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                       AND cotacao-item.cot-aprovada NO-LOCK:

                     RUN ccp/ccapi341.p (INPUT  cotacao-item.numero-ordem,
                                         INPUT  cotacao-item.cod-emitente,
                                         INPUT  cotacao-item.seq-cotac,
                                         INPUT  cotacao-item.it-codigo,
                                         OUTPUT d-preco-liquido).

                     ASSIGN tt-ordens-embarque.mo-codigo   = cotacao-item.mo-codigo
                            tt-ordens-embarque.preco-unit  = d-preco-liquido
                            tt-ordens-embarque.preco-total = tt-ordens-embarque.quantidade * d-preco-liquido. /*mesmo calculo do oc0201, por‚m desconsiderando despesas de importa‡Æo*/
                 END.
            END.
        END.
    END.

    {&open-query-browse-1}

    RUN pi-trata-botoes-laterais.


    IF CAN-FIND(FIRST tt-ordens-embarque) THEN
        ASSIGN bt-vinc:SENSITIVE      IN FRAME fPage2 = YES
               bt-vinc-all:SENSITIVE  IN FRAME fPage2 = YES
               bt-vinc-parc:SENSITIVE IN FRAME fPage2 = YES
               bt-filtro:SENSITIVE    IN FRAME fPage2 = YES
               bt-marca1:SENSITIVE    IN FRAME fPage2 = YES.
    ELSE
        ASSIGN bt-vinc:SENSITIVE      IN FRAME fPage2 = NO
               bt-vinc-all:SENSITIVE  IN FRAME fPage2 = NO
               bt-vinc-parc:SENSITIVE IN FRAME fPage2 = NO
               bt-filtro:SENSITIVE    IN FRAME fPage2 = NO
               bt-marca1:SENSITIVE    IN FRAME fPage2 = NO.

    FOR EACH tt-ordens-embarque:
        CREATE tt-ordens-embarque-aux.
        BUFFER-COPY tt-ordens-embarque TO tt-ordens-embarque-aux.
    END.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desvincula wMaintenanceNoNavigation 
PROCEDURE pi-desvincula :
/*------------------------------------------------------------------------------
  Purpose:     Realiza a desvincula‡Æo do registro que foi vinculado no browser 
               de valor de mercadorias vinculadas
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE de-vl-saldo     LIKE adiant-despes-lista.val-adiant-moed NO-UNDO.

    FOR EACH tt-adiant-despes-lista-det-aux
       WHERE tt-adiant-despes-lista-det-aux.marca <> "":

        IF pcAction = "ADD":U THEN DO:
            DELETE tt-adiant-despes-lista-det-aux.
            RUN pi-cria-tt-ordens-embarque (INPUT INPUT FRAME fPage2 tt-adiant-despes-lista.cod-embarq).
        END.
        ELSE
            IF pcAction = "UPDATE":U THEN DO:
                /*elimina‡Æo da tabela adiant-despes-lista-det, cont‚m os dados da compra do embarque*/
                RUN openQueryStatic IN h-bocx00447 (INPUT "Main":U).
                RUN goTokey         IN h-bocx00447 (INPUT tt-adiant-despes-lista-det-aux.cod-estabel,
                                                    INPUT tt-adiant-despes-lista-det-aux.cdd-adiant,
                                                    INPUT tt-adiant-despes-lista-det-aux.num-seq-lista,
                                                    INPUT tt-adiant-despes-lista-det-aux.num-seq-det).
                IF RETURN-VALUE = "NOK":U THEN NEXT.
        
                RUN deleteRecord IN h-bocx00447.
                IF RETURN-VALUE = "NOK":U THEN DO:
                    RUN getRowErrors IN h-bocx00447 (OUTPUT TABLE RowErrors).
                    RETURN "NOK":U.
                END.
                
                /*se nÆo encontrou nenhum erro, realiza a elimina‡Æo da tabela adiant-despes-lista,
                que ‚ a tabela pai da adiant-despes-lista-det*/
                IF NOT CAN-FIND(FIRST RowErrors
                                WHERE RowErrors.ErrorSubType <> "INTERNAL":U) THEN DO:
                    RUN openQueryStatic IN h-bocx00444 (INPUT "Main":U).
                    RUN goTokey         IN h-bocx00444 (INPUT tt-adiant-despes-lista-det-aux.cod-estabel,
                                                        INPUT tt-adiant-despes-lista-det-aux.cdd-adiant,
                                                        INPUT tt-adiant-despes-lista-det-aux.num-seq-lista).
        
                    IF RETURN-VALUE = "NOK":U THEN NEXT.
            
                    RUN deleteRecord IN h-bocx00444.
                    IF RETURN-VALUE = "NOK":U THEN DO:
                        RUN getRowErrors IN h-bocx00444 (OUTPUT TABLE RowErrors).
                        RETURN "NOK":U.
                    END.
        
                    /*elimina‡Æo/atualiza‡Æo do registro da tabela adiant-despes-parc*/
                    IF NOT CAN-FIND(FIRST RowErrors
                                    WHERE RowErrors.ErrorSubType <> "INTERNAL":U) THEN DO:
                        RUN openQueryStatic IN h-bocx00443 (INPUT "Main":U).
                        RUN goTokey         IN h-bocx00443 (INPUT tt-adiant-despes-lista-det-aux.cod-estabel,
                                                            INPUT tt-adiant-despes-lista-det-aux.cdd-adiant,
                                                            INPUT tt-adiant-despes-lista-det-aux.cod-refer).
                        IF RETURN-VALUE = "NOK":U THEN NEXT.
        
                        RUN piVerificaValorParcela IN h-bocx00443 (INPUT  tt-adiant-despes-lista-det-aux.cod-estabel,
                                                                   INPUT  tt-adiant-despes-lista-det-aux.cdd-adiant,
                                                                   INPUT  tt-adiant-despes-lista-det-aux.cod-refer,
                                                                   OUTPUT de-vl-saldo).
                        IF de-vl-saldo = 0 THEN DO:
                            RUN deleteRecord IN h-bocx00443.
                            IF RETURN-VALUE = "NOK":U THEN DO:
                                RUN getRowErrors IN h-bocx00443 (OUTPUT TABLE RowErrors).
                                RETURN "NOK":U.
                            END.
                        END.
                    END.
                END.
                
                IF NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType <> "INTERNAL":U) THEN DO:
                    RUN piAtualizaValorAdiantamento IN h-bocx00442 (INPUT tt-adiant-despes-lista-det-aux.cod-estabel,
                                                                    INPUT tt-adiant-despes-lista-det-aux.cdd-adiant).
                    DELETE tt-adiant-despes-lista-det-aux. 
                    RUN pi-cria-tt-ordens-embarque (INPUT INPUT FRAME fPage2 tt-adiant-despes-lista.cod-embarq).
                END.
            END.
    END.

    {&open-query-browse-2}

    RUN pi-atualiza-valor-total.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-filtro wMaintenanceNoNavigation 
PROCEDURE pi-inicializa-filtro :
/*------------------------------------------------------------------------------
  Purpose:     Coloca as variaveis utilizadas no filtro em seu estado inicial 
  Parameters:  <none>
  Notes:       Utilizado para abertura dos filtros dos browsers de ordens e de
               antecipacoes
------------------------------------------------------------------------------*/
    
    ASSIGN c-nr-proc-imp-ini                = "":U
           c-nr-proc-imp-fim                = "ZZZZZZZZZZZZ":U
           i-num-pedido-ini                 = 0
           i-num-pedido-fim                 = 99999999
           i-numero-ordem-ini               = 0
           i-numero-ordem-fim               = 99999999
           i-parcela-ini                    = 0
           i-parcela-fim                    = 99999
           i-cod-emitente-ini               = 0
           i-cod-emitente-fim               = 999999999
           c-nome-abrev-ini                 = "":U
           c-nome-abrev-fim                 = "ZZZZZZZZZZZZ":U
           c-nr-proc-imp-ini-filtro2        = "":U
           c-nr-proc-imp-fim-filtro2        = "ZZZZZZZZZZZZ":U
           i-num-pedido-ini-filtro2         = 0
           i-num-pedido-fim-filtro2         = 99999999
           i-numero-ordem-ini-filtro2       = 0
           i-numero-ordem-fim-filtro2       = 99999999
           i-parcela-ini-filtro2            = 0
           i-parcela-fim-filtro2            = 99999
           i-cod-emitente-ini-filtro2       = 0
           i-cod-emitente-fim-filtro2       = 999999999
           c-nome-abrev-ini-filtro2         = "":U
           c-nome-abrev-fim-filtro2         = "ZZZZZZZZZZZZ":U
           c-cod-refer-ini                  = "":U          
           c-cod-refer-fim                  = "ZZZZZZZZZZ":U
           c-cod-espec-docto-ini            = "":U   
           c-cod-espec-docto-fim            = "ZZZ":U
           c-cod-ser-docto-ini              = "":U     
           c-cod-ser-docto-fim              = "ZZZZZ":U
           c-cod-tit-ap-ini                 = "":U                  
           c-cod-tit-ap-fim                 = "ZZZZZZZZZZZZZZZZ":U  
           c-cod-parcela-ini                = "":U
           c-cod-parcela-fim                = "ZZ":U
           dt-dat-emissao-ini               = 01/01/1800 
           dt-dat-emissao-fim               = 12/31/9999 
           dt-dat-vencto-ini                = 01/01/1800 
           dt-dat-vencto-fim                = 12/31/9999 
           de-val-adiant-moed-ini           = 0.00               
           de-val-adiant-moed-fim           = 999999999999999.99.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-observacao wMaintenanceNoNavigation 
PROCEDURE pi-recebe-observacao :
/*------------------------------------------------------------------------------
  Purpose:     Recebe a informa‡Æo da observa‡Æo para atualizar na tabela adiant-despes-lista
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER TABLE FOR tt-adiant-despes-lista-det-aux2.

    FOR FIRST tt-adiant-despes-lista-det-aux2:
    END.
    FOR FIRST tt-adiant-despes-lista-det-aux
        WHERE tt-adiant-despes-lista-det-aux.cod-estabel   = tt-adiant-despes-lista-det-aux2.cod-estabel
          AND tt-adiant-despes-lista-det-aux.cdd-adiant    = tt-adiant-despes-lista-det-aux2.cdd-adiant
          AND tt-adiant-despes-lista-det-aux.cod-refer     = tt-adiant-despes-lista-det-aux2.cod-refer
          AND tt-adiant-despes-lista-det-aux.num-seq-lista = tt-adiant-despes-lista-det-aux2.num-seq-lista:
        ASSIGN tt-adiant-despes-lista-det-aux.observacao   = tt-adiant-despes-lista-det-aux2.observacao.
    END.

    FOR FIRST tt-adiant-despes-lista-det-fil
        WHERE tt-adiant-despes-lista-det-fil.cod-estabel   = tt-adiant-despes-lista-det-aux.cod-estabel
          AND tt-adiant-despes-lista-det-fil.cdd-adiant    = tt-adiant-despes-lista-det-aux.cdd-adiant
          AND tt-adiant-despes-lista-det-fil.cod-refer     = tt-adiant-despes-lista-det-aux.cod-refer
          AND tt-adiant-despes-lista-det-fil.num-seq-lista = tt-adiant-despes-lista-det-aux.num-seq-lista:
        ASSIGN tt-adiant-despes-lista-det-fil.observacao = tt-adiant-despes-lista-det-aux.observacao.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-botoes-laterais wMaintenanceNoNavigation 
PROCEDURE pi-trata-botoes-laterais :
/*------------------------------------------------------------------------------
  Purpose:     Realiza tratamento do estado dos botäes laterais dos browsers
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF CAN-FIND(FIRST tt-ordens-embarque) THEN
        ASSIGN bt-vinc:SENSITIVE      IN FRAME fPage2 = YES
               bt-vinc-all:SENSITIVE  IN FRAME fPage2 = YES
               bt-vinc-parc:SENSITIVE IN FRAME fPage2 = YES
               bt-filtro:SENSITIVE    IN FRAME fPage2 = YES
               bt-marca1:SENSITIVE    IN FRAME fPage2 = YES.
    ELSE
        ASSIGN bt-vinc:SENSITIVE      IN FRAME fPage2 = NO
               bt-vinc-all:SENSITIVE  IN FRAME fPage2 = NO
               bt-vinc-parc:SENSITIVE IN FRAME fPage2 = NO
               bt-filtro:SENSITIVE    IN FRAME fPage2 = NO
               bt-marca1:SENSITIVE    IN FRAME fPage2 = NO.

    IF CAN-FIND(FIRST tt-adiant-despes-lista-det-aux) THEN DO:
        ASSIGN bt-desv:SENSITIVE      IN FRAME fPage2 = YES
               bt-desv-all:SENSITIVE  IN FRAME fPage2 = YES
               bt-filtro2:SENSITIVE   IN FRAME fPage2 = YES
               bt-marca2:SENSITIVE    IN FRAME fPage2 = YES
               bt-observa:SENSITIVE   IN FRAME fPage2 = YES
               tt-adiant-despes-lista.cod-embarq:SENSITIVE IN FRAME fPage2 = NO
               bt-ent:SENSITIVE IN FRAME fPage2   = NO
               tt-adiant-despes-lista.idi-operac-antecip:SENSITIVE IN FRAME fPage0 = NO
               tt-adiant-despes-lista.idi-identif:SENSITIVE IN FRAME fPage0 = NO.
    END.
    ELSE DO:
        ASSIGN bt-desv:SENSITIVE      IN FRAME fPage2 = NO
               bt-desv-all:SENSITIVE  IN FRAME fPage2 = NO
               bt-filtro2:SENSITIVE   IN FRAME fPage2 = NO
               bt-marca2:SENSITIVE    IN FRAME fPage2 = NO
               bt-observa:SENSITIVE   IN FRAME fPage2 = NO
               tt-adiant-despes-lista.cod-embarq:SENSITIVE IN FRAME fPage2 = YES
               bt-ent:SENSITIVE IN FRAME fPage2   = YES
               tt-adiant-despes-lista.idi-operac-antecip:SENSITIVE IN FRAME fPage0 = YES
               tt-adiant-despes-lista.idi-identif:SENSITIVE IN FRAME fPage0 = YES.
    END.

    IF  INPUT FRAME fPage0 tt-adiant-despes-lista.cod-refer  <> ""
    AND CAN-FIND(FIRST tt-adiant-despes-lista-det-aux
                 WHERE tt-adiant-despes-lista-det-aux.cod-refer = INPUT FRAME fPage0 tt-adiant-despes-lista.cod-refer)  THEN
        ASSIGN tt-adiant-despes-lista.cod-refer:SENSITIVE IN FRAME fPage0 = NO.

    RETURN "OK":U.                                                                                    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vincula wMaintenanceNoNavigation 
PROCEDURE pi-vincula :
/*------------------------------------------------------------------------------
  Purpose:     Realiza tratamento para vincula‡Æo do registro no segundo browser
               sem criar os dados no banco
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF INPUT FRAME fPage0 tt-adiant-despes-lista.idi-operac-antecip = 1 THEN DO: /*Gerar uma nova antecipa‡Æo*/
        {utp/ut-liter.i Deseja_gerar_uma_£nica_antecipa‡Æo/referˆncia? * r}
        ASSIGN c-liter = TRIM(RETURN-VALUE).
        {utp/ut-liter.i Foram_selecionados_mais_de_um_registro_para_gera‡Æo_de_antecipa‡Æo. * r}
        ASSIGN i-cont = 0.
        FOR EACH tt-ordens-embarque
            WHERE tt-ordens-embarque.marca <> "":
            ASSIGN i-cont = i-cont + 1.
        END.
        IF i-cont > 1 THEN DO: 
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 32699,
                               INPUT c-liter + "~~" + TRIM(RETURN-VALUE) + c-liter).
        END.
        IF RETURN-VALUE = "yes":U THEN
            RUN pi-cria-antecipacao (INPUT YES). /*cria todos os registros no browser com uma unica referencia, mesmo t¡tulo, esp‚cie, s‚rie e parcela. No final acumula os valores*/
        ELSE
            RUN pi-cria-antecipacao (INPUT NO).
    END.
    ELSE DO:
        IF INPUT FRAME fPage0 tt-adiant-despes-lista.cod-refer = "":U THEN DO:
            {utp/ut-liter.i Referˆncia * R}
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 265,
                               INPUT TRIM(RETURN-VALUE)).
            APPLY "entry":U TO tt-adiant-despes-lista.cod-refer IN FRAME fPage0.
        END.
        ELSE DO:
            RUN goToKeyAdiant IN h-bocx00443 (INPUT tt-adiant-despes.cod-estabel,
                                              INPUT tt-adiant-despes.cdd-adiant,
                                              INPUT INPUT FRAME fPage0 tt-adiant-despes-lista.cod-refer).
            IF RETURN-VALUE <> "OK":U THEN DO:
                {utp/ut-liter.i Referˆncia * R}
                ASSIGN c-liter = TRIM(RETURN-VALUE).
                {utp/ut-liter.i Adiantamento * R}
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 19254,
                                   INPUT c-liter + "~~" + TRIM(RETURN-VALUE) + " ":U + string(tt-adiant-despes.cdd-adiant)).
                APPLY "entry":U TO tt-adiant-despes-lista.cod-refer IN FRAME fPage0.
            END.
        END.
        RUN pi-cria-antecipacao (INPUT YES).
        /*cria registro para uma antecipa‡Æo j  existente*/
    END.
    RUN pi-atualiza-valor-total.

    browse-2:FETCH-SELECTED-ROW(1) IN FRAME fPage2.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaAdiantDespesParcLista wMaintenanceNoNavigation 
PROCEDURE piCriaAdiantDespesParcLista :
/*------------------------------------------------------------------------------
  Purpose:     Realizar a cria‡Æo dos registros nas tabelas para efetiva‡Æo no banco
  Parameters:  <none>
  Notes:       Cria‡Æo das tabelas adiant-despes-lista-det, adiant-despes-lista 
               e adiant-despes-parc.
------------------------------------------------------------------------------*/

    DEFINE VARIABLE de-val-adiant       LIKE adiant-despes-parc.val-adiant      NO-UNDO.
    DEFINE VARIABLE de-val-adiant-moed  LIKE adiant-despes-parc.val-adiant-moed NO-UNDO.
    DEFINE VARIABLE de-val-adiant-orig  LIKE adiant-despes-parc.val-adiant-orig NO-UNDO.
    DEFINE VARIABLE de-total            LIKE adiant-despes-parc.val-adiant-moed NO-UNDO.
    
    EMPTY TEMP-TABLE tt-adiant-despes-lista-det.
    EMPTY TEMP-TABLE tt-adiant-despes-lista.
    EMPTY TEMP-TABLE tt-adiant-despes-parc.

    ASSIGN de-val-adiant = 0.
    FOR EACH tt-adiant-despes-lista-det-aux:
        
        /*criacao da tabela adiant-despes-lista-det, tabela filha da adiant-despes-lista*/
        CREATE tt-adiant-despes-lista-det.
        ASSIGN tt-adiant-despes-lista-det.cod-estabel       = tt-adiant-despes-lista-det-aux.cod-estabel      
               tt-adiant-despes-lista-det.cdd-adiant        = tt-adiant-despes-lista-det-aux.cdd-adiant       
               tt-adiant-despes-lista-det.num-seq-lista     = tt-adiant-despes-lista-det-aux.num-seq-lista    
               tt-adiant-despes-lista-det.num-seq-det       = tt-adiant-despes-lista-det-aux.num-seq-det
               tt-adiant-despes-lista-det.cod-embarq        = tt-adiant-despes-lista-det-aux.cod-embarq       
               tt-adiant-despes-lista-det.num-di-ems        = tt-adiant-despes-lista-det-aux.num-di-ems       
               tt-adiant-despes-lista-det.cod-emitente-desp = tt-adiant-despes-lista-det-aux.cod-emitente /*armazena emitente da ordem de compra*/
               tt-adiant-despes-lista-det.cod-desp          = dec(tt-adiant-despes-lista-det-aux.parcela) /*armazena parcela*/        
               tt-adiant-despes-lista-det.val-desp          = tt-adiant-despes-lista-det-aux.val-adiant-moed /*armazena preco total*/
               tt-adiant-despes-lista-det.desc-det          = "":U
               tt-adiant-despes-lista-det.nr-proc-imp       = tt-adiant-despes-lista-det-aux.nr-proc-imp
               tt-adiant-despes-lista-det.numero-ordem      = tt-adiant-despes-lista-det-aux.numero-ordem.

        RUN openQueryStatic IN h-bocx00447 (INPUT "Main":U) NO-ERROR.       
        RUN emptyRowErrors  IN h-bocx00447.
        RUN emptyRowObject  IN h-bocx00447.
        RUN setRecord       IN h-bocx00447 (INPUT TABLE tt-adiant-despes-lista-det).
        RUN createRecord    IN h-bocx00447.
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN h-bocx00447 (OUTPUT TABLE RowErrors).
            RETURN "NOK":U.
        END.
        DELETE tt-adiant-despes-lista-det.
        
        /*criacao da tabela adiant-despes-lista, somente realiza a cria‡Æo se a tabela adiant-despes-lista-det foi criada com sucesso*/
        IF NOT CAN-FIND(FIRST tt-adiant-despes-lista
                        WHERE tt-adiant-despes-lista.cod-estabel   = tt-adiant-despes-lista-det-aux.cod-estabel
                          AND tt-adiant-despes-lista.cdd-adiant    = tt-adiant-despes-lista-det-aux.cdd-adiant
                          AND tt-adiant-despes-lista.num-seq-lista = tt-adiant-despes-lista-det-aux.num-seq-lista) THEN DO:

            CREATE tt-adiant-despes-lista.
            ASSIGN tt-adiant-despes-lista.cod-estabel           = tt-adiant-despes-lista-det-aux.cod-estabel  
                   tt-adiant-despes-lista.cdd-adiant            = tt-adiant-despes-lista-det-aux.cdd-adiant       
                   tt-adiant-despes-lista.num-seq-lista         = tt-adiant-despes-lista-det-aux.num-seq-lista    

                   tt-adiant-despes-lista.cdn-emitente          = tt-adiant-despes.cdn-emitente
                   tt-adiant-despes-lista.cdn-moeda             = tt-adiant-despes.cdn-moeda
                   tt-adiant-despes-lista.num-di-ems            = tt-adiant-despes-lista-det-aux.num-di-ems
                   tt-adiant-despes-lista.cod-embarq            = tt-adiant-despes-lista-det-aux.cod-embarq       
                   
                   tt-adiant-despes-lista.cod-refer             = tt-adiant-despes-lista-det-aux.cod-refer
                   tt-adiant-despes-lista.dat-emissao           = TODAY
                   tt-adiant-despes-lista.dat-implant           = TODAY
                   tt-adiant-despes-lista.dat-prev-pagto        = TODAY
                   tt-adiant-despes-lista.dat-vencto            = ?
                   tt-adiant-despes-lista.desc-identif          = INPUT FRAME fPage0 tt-adiant-despes-lista.desc-identif       
                   tt-adiant-despes-lista.dias-vencto           = 0
                   tt-adiant-despes-lista.idi-identif           = INPUT FRAME fPage0 tt-adiant-despes-lista.idi-identif        
                   tt-adiant-despes-lista.idi-informa           = 1
                   tt-adiant-despes-lista.idi-lancto            = INPUT FRAME fPage0 tt-adiant-despes-lista.idi-lancto         
                   tt-adiant-despes-lista.idi-operac-antecip    = INPUT FRAME fPage0 tt-adiant-despes-lista.idi-operac-antecip
                   tt-adiant-despes-lista.observacao            = tt-adiant-despes-lista-det-aux.observacao.
        END.
                   
        ASSIGN tt-adiant-despes-lista.val-adiant-moed       = tt-adiant-despes-lista.val-adiant-moed  + tt-adiant-despes-lista-det-aux.val-adiant-moed.

        IF tt-adiant-despes.cdn-moeda <> 0 THEN DO:
            RUN cdp/cd0812.p (INPUT tt-adiant-despes.cdn-moeda,
                              INPUT 0,
                              INPUT tt-adiant-despes-lista-det-aux.val-adiant-moed,
                              INPUT tt-adiant-despes-lista.dat-implant,
                              OUTPUT de-val-adiant).
        END.
        ASSIGN tt-adiant-despes-lista.val-adiant            = tt-adiant-despes-lista.val-adiant       + de-val-adiant
               tt-adiant-despes-lista.val-previs            = tt-adiant-despes-lista.val-previs       + de-val-adiant
               tt-adiant-despes-lista.val-realzdo-moed      = 0  /*valores somente atualizados atrav‚s da cria‡Æo da tabela adiant-despes-movto*/
               tt-adiant-despes-lista.val-realzdo           = 0. /*valores somente atualizados atrav‚s da cria‡Æo da tabela adiant-despes-movto*/

        /*cria‡Æo/atualiza‡Æo da tabela adiant-despes-parc, somente realiza a cria‡Æo se a tabela adiant-despes-lista foi criada com sucesso*/
        IF NOT CAN-FIND(FIRST RowErrors 
                        WHERE RowErrors.ErrorSubType <> "INTERNAL":U) THEN DO:

            IF NOT CAN-FIND(FIRST tt-adiant-despes-parc
                            WHERE tt-adiant-despes-parc.cod-estabel = tt-adiant-despes-lista-det-aux.cod-estabel
                              AND tt-adiant-despes-parc.cdd-adiant  = tt-adiant-despes-lista-det-aux.cdd-adiant
                              AND tt-adiant-despes-parc.cod-refer   = tt-adiant-despes-lista-det-aux.cod-refer) THEN DO:
                CREATE tt-adiant-despes-parc.
                ASSIGN tt-adiant-despes-parc.cod-estabel      = tt-adiant-despes-lista-det-aux.cod-estabel
                       tt-adiant-despes-parc.cdd-adiant       = tt-adiant-despes-lista-det-aux.cdd-adiant
                       tt-adiant-despes-parc.cod-refer        = tt-adiant-despes-lista-det-aux.cod-refer
                       tt-adiant-despes-parc.cod-parcela      = tt-adiant-despes-lista-det-aux.cod-parcela
                       tt-adiant-despes-parc.cod-espec-docto  = tt-adiant-despes-lista-det-aux.cod-espec-docto
                       tt-adiant-despes-parc.cod-ser-docto    = tt-adiant-despes-lista-det-aux.cod-ser-docto
                       tt-adiant-despes-parc.cod-tit-ap       = tt-adiant-despes-lista-det-aux.cod-tit-ap
                       tt-adiant-despes-parc.idi-valor        = 2 /*1 - Manual; 2 - Autom tico : Se for parcial, precisa enviar "manual"*/
                       tt-adiant-despes-parc.cdn-emitente     = tt-adiant-despes.cdn-emitente
                       tt-adiant-despes-parc.cdn-moeda        = tt-adiant-despes.cdn-moeda
                       tt-adiant-despes-parc.log-gerou-tit-ap = NO    
                       tt-adiant-despes-parc.dat-prev-pagto   = TODAY 
                       tt-adiant-despes-parc.dat-emissao      = TODAY.
            END.

            /*cria‡Æo da referencia*/
            IF INPUT FRAME fPage0 tt-adiant-despes-lista.idi-operac-antecip = 1 THEN DO:
                ASSIGN tt-adiant-despes-parc.val-adiant-moed  = tt-adiant-despes-parc.val-adiant-moed + tt-adiant-despes-lista-det-aux.val-adiant-moed
                       tt-adiant-despes-parc.val-adiant-orig  = tt-adiant-despes-parc.val-adiant-orig + tt-adiant-despes-lista-det-aux.val-adiant-moed
                       tt-adiant-despes-parc.val-adiant       = tt-adiant-despes-parc.val-adiant      + tt-adiant-despes-lista-det-aux.val-adiant-moed.
                
                IF tt-adiant-despes.cdn-moeda <> 0 THEN DO:
                    RUN cdp/cd0812.p (INPUT tt-adiant-despes.cdn-moeda,
                                      INPUT 0,
                                      INPUT tt-adiant-despes-parc.val-adiant-moed,
                                      INPUT tt-adiant-despes.dat-implant,
                                      OUTPUT tt-adiant-despes-parc.val-adiant).
                END.
            END.
            ELSE DO:
                /*adiciona ou atualiza*/
                RUN goToKeyAdiant IN h-bocx00443 (INPUT tt-adiant-despes-parc.cod-estabel,
                                                  INPUT tt-adiant-despes-parc.cdd-adiant,
                                                  INPUT tt-adiant-despes-parc.cod-refer).
                IF RETURN-VALUE = "OK":U THEN DO:
                    RUN getDecField IN h-bocx00443 (INPUT "val-adiant":U,      OUTPUT de-val-adiant).
                    RUN getDecField IN h-bocx00443 (INPUT "val-adiant-moed":U, OUTPUT de-val-adiant-moed).
                    RUN getDecField IN h-bocx00443 (INPUT "val-adiant-orig":U, OUTPUT de-val-adiant-orig).
    
                    IF INPUT FRAME fPage0 tt-adiant-despes-lista.idi-operac-antecip = 2 THEN DO: /*atualiza a antecipa‡Æo*/
                        ASSIGN tt-adiant-despes-parc.val-adiant-moed  = tt-adiant-despes-parc.val-adiant-moed + tt-adiant-despes-lista-det-aux.val-adiant-moed
                               tt-adiant-despes-parc.val-adiant       = tt-adiant-despes-parc.val-adiant      + tt-adiant-despes-lista-det-aux.val-adiant-moed
                               tt-adiant-despes-parc.val-adiant-orig  = de-val-adiant-orig.
    
                         IF tt-adiant-despes.cdn-moeda <> 0 THEN DO:
                            RUN cdp/cd0812.p (INPUT tt-adiant-despes.cdn-moeda,
                                              INPUT 0,
                                              INPUT tt-adiant-despes-parc.val-adiant-moed,
                                              INPUT tt-adiant-despes.dat-implant,
                                              OUTPUT tt-adiant-despes-parc.val-adiant).
                         END.
                    END.
                    ELSE DO: /*adiciona ao valor da antecipa‡Æo*/
                        ASSIGN tt-adiant-despes-parc.val-adiant-moed  = tt-adiant-despes-parc.val-adiant-moed + tt-adiant-despes-lista-det-aux.val-adiant-moed
                               tt-adiant-despes-parc.val-adiant       = tt-adiant-despes-parc.val-adiant      + tt-adiant-despes-lista-det-aux.val-adiant-moed.
    
                        IF tt-adiant-despes.cdn-moeda <> 0 THEN DO:
                            RUN cdp/cd0812.p (INPUT tt-adiant-despes.cdn-moeda,
                                              INPUT 0,
                                              INPUT tt-adiant-despes-parc.val-adiant-moed,
                                              INPUT tt-adiant-despes.dat-implant,
                                              OUTPUT tt-adiant-despes-parc.val-adiant).
                         END.
                    END.
                END.
            END.
        END.

    END. /*for each tt-adiant-despes-lista-det-aux*/

    /*realiza cria‡Æo da adiant-despes-lista*/
    FOR EACH tt-adiant-despes-lista:
        RUN openQueryStatic IN h-bocx00444 (INPUT "Main":U) NO-ERROR.       
        RUN emptyRowErrors  IN h-bocx00444.
        RUN emptyRowObject  IN h-bocx00444.
        RUN setRecord       IN h-bocx00444 (INPUT TABLE tt-adiant-despes-lista).
        RUN createRecord    IN h-bocx00444.
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN h-bocx00444 (OUTPUT TABLE RowErrors).
            RETURN "NOK":U.
        END.     
        DELETE tt-adiant-despes-lista.
    END.

    FOR EACH tt-adiant-despes-parc:
        /*na parcela que verifica o tipo, se gera nova, adiciona ou atualiza:
          tratamento nos campos de valores devido ao tipo de operacao, se cria, adiciona ou atualiza a referˆncia*/
        IF INPUT FRAME fPage0 tt-adiant-despes-lista.idi-operac-antecip = 1 THEN DO: /*cria nova referˆncia*/
            RUN openQueryStatic IN h-bocx00443 (INPUT "Main":U) NO-ERROR.       
            RUN emptyRowErrors  IN h-bocx00443.
            RUN emptyRowObject  IN h-bocx00443.
            RUN setRecord       IN h-bocx00443 (INPUT TABLE tt-adiant-despes-parc).
            RUN createRecord    IN h-bocx00443.
            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN getRowErrors IN h-bocx00443 (OUTPUT TABLE RowErrors).
                RETURN "NOK":U.
            END.        
            DELETE tt-adiant-despes-parc.
        END.
        ELSE DO:
            IF INPUT FRAME fPage0 tt-adiant-despes-lista.idi-operac-antecip = 3 THEN DO: /*atualiza a antecipa‡Æo*/
                RUN goToKeyAdiant IN h-bocx00443 (INPUT tt-adiant-despes-parc.cod-estabel,
                                                  INPUT tt-adiant-despes-parc.cdd-adiant,
                                                  INPUT tt-adiant-despes-parc.cod-refer).
                IF RETURN-VALUE = "OK":U THEN DO:
                    RUN getDecField IN h-bocx00443 (INPUT "val-adiant":U,      OUTPUT de-val-adiant).
                    RUN getDecField IN h-bocx00443 (INPUT "val-adiant-moed":U, OUTPUT de-val-adiant-moed).
                    ASSIGN tt-adiant-despes-parc.val-adiant-moed = tt-adiant-despes-parc.val-adiant-moed + de-val-adiant-moed
                           tt-adiant-despes-parc.val-adiant      = tt-adiant-despes-parc.val-adiant      + de-val-adiant.
                END.
            END.
            RUN piSetaValidacao IN h-bocx00443 (INPUT YES).
            RUN emptyRowErrors  IN h-bocx00443.
            RUN emptyRowObject  IN h-bocx00443.
            RUN setRecord       IN h-bocx00443 (INPUT TABLE tt-adiant-despes-parc).
            RUN updateRecord    IN h-bocx00443.
            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN getRowErrors IN h-bocx00443 (OUTPUT TABLE RowErrors).
                RETURN "NOK":U.
            END.
            DELETE tt-adiant-despes-parc.
        END.
    END.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/

    ASSIGN {&ttTable}.cod-estabel  = {&ttParent}.cod-estabel
           {&ttTable}.cdd-adiant   = {&ttParent}.cdd-adiant
           {&ttTable}.cdn-emitente = {&ttParent}.cdn-emitente
           {&ttTable}.cdn-moeda    = {&ttParent}.cdn-moeda.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem wMaintenanceNoNavigation 
FUNCTION fnDescItem RETURNS CHARACTER
  ( INPUT pc-it-codigo AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Retornar a descri‡Æo do item
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-desc-item AS CHARACTER NO-UNDO.

  ASSIGN c-desc-item = "".

  RUN goToKey IN h-boin172 (INPUT pc-it-codigo).
  IF RETURN-VALUE = "OK":U THEN
     RUN getCharField in h-boin172 (INPUT "desc-item":U, OUTPUT c-desc-item).

  RETURN c-desc-item.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNomeAbrev wMaintenanceNoNavigation 
FUNCTION fnNomeAbrev RETURNS CHARACTER
  ( INPUT pi-cod-emitente AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  ASSIGN c-nome-abrev = "".

  RUN findCodigo IN h-boad098(INPUT pi-cod-emitente, OUTPUT c-return).
  IF c-return = "" THEN
      RUN getCharField IN h-boad098 (INPUT "nome-abrev":U, OUTPUT c-nome-abrev).

  RETURN c-nome-abrev.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

