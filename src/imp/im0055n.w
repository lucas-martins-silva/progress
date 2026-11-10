&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-antecip-import NO-UNDO LIKE antecip-import
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
       field r-Rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0055N 2.00.00.018 } /*** 010018 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0055N MIM}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{include/i_dbtype.i}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM0055N
&GLOBAL-DEFINE Version        2.00.00.018
&GLOBAL-DEFINE DBOVersion       1.1

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FramesHandle     STRING(FRAME fPage1:HANDLE)
&GLOBAL-DEFINE FolderLabels     Antecipa‡Æo

&GLOBAL-DEFINE ttParent         tt-embarque-imp
&GLOBAL-DEFINE hDBOParent       h-bocx220
&GLOBAL-DEFINE DBOParentTable   embarque-imp

&GLOBAL-DEFINE ttSon2           tt-antecip-import
&GLOBAL-DEFINE hDBOSon2         h-bocx00451
&GLOBAL-DEFINE DBOSon2Table     antecip-import

&GLOBAL-DEFINE page0Fields
&GLOBAL-DEFINE page1Widgets     brSon1 brSon2 btVincula btVinculaParc btVinculaTodas btFiltro ~
                                btDesvincula btDesvinculaTodas btFiltro
 
{cxbo/bocx00451.i tt-antecip-import-aux}
{cxbo/bocx00451.i1}

/* Parameters Definitions ---                                           */

DEFINE INPUT PARAM pcod-estabel    LIKE embarque-imp.cod-estabel    NO-UNDO.
DEFINE INPUT PARAM pembarque       LIKE embarque-imp.embarque       NO-UNDO.
DEFINE INPUT PARAM r-rowid         AS   ROWID                       NO-UNDO.
DEFINE INPUT PARAM phCaller        AS   HANDLE                      NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cNomeAbrev          AS CHARACTER               NO-UNDO.
DEFINE VARIABLE c-lb-acomp          AS CHARACTER               NO-UNDO.
DEFINE VARIABLE c-lb-id             AS CHARACTER               NO-UNDO.

/* Variav rias utilizadas pelo filtro de antecipa‡äes a vincular */
DEFINE VARIABLE c-cod-estabel-ini   LIKE estabelec.cod-estabel NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim   LIKE estabelec.cod-estabel NO-UNDO.
DEFINE VARIABLE i-cdn-emitente-ini  LIKE emitente.cod-emitente NO-UNDO.
DEFINE VARIABLE i-cdn-emitente-fim  LIKE emitente.cod-emitente NO-UNDO.
DEFINE VARIABLE d-dat-transacao-ini AS DATE                    NO-UNDO.
DEFINE VARIABLE d-dat-transacao-fim AS DATE                    NO-UNDO.
DEFINE VARIABLE c-cod-especie-ini   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE c-cod-especie-fim   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE c-cod-serie-ini     AS CHARACTER               NO-UNDO.
DEFINE VARIABLE c-cod-serie-fim     AS CHARACTER               NO-UNDO.
DEFINE VARIABLE c-cod-tit-ap-ini    AS CHARACTER               NO-UNDO.
DEFINE VARIABLE c-cod-tit-ap-fim    AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l-inicializacao     AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE l-ok                AS LOGICAL                 NO-UNDO. /*Verifica se filtro foi confirmado im0055n1*/
/* Variav rias utilizadas pelo filtro de antecipa‡äes vinculadas */
DEFINE VARIABLE c-cod-estabel-ini2   LIKE estabelec.cod-estabel INIT "":U              NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim2   LIKE estabelec.cod-estabel INIT "ZZZZZ":U         NO-UNDO.
DEFINE VARIABLE i-cdn-emitente-ini2  LIKE emitente.cod-emitente INIT 0                 NO-UNDO.
DEFINE VARIABLE i-cdn-emitente-fim2  LIKE emitente.cod-emitente INIT 999999999         NO-UNDO.
DEFINE VARIABLE d-dat-transacao-ini2 AS DATE                    INIT &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF NO-UNDO.
DEFINE VARIABLE d-dat-transacao-fim2 AS DATE                    INIT 12/12/9999        NO-UNDO.
DEFINE VARIABLE c-cod-especie-ini2   AS CHARACTER               INIT "":U              NO-UNDO.
DEFINE VARIABLE c-cod-especie-fim2   AS CHARACTER               INIT "ZZZ":U           NO-UNDO.
DEFINE VARIABLE c-cod-serie-ini2     AS CHARACTER               INIT "":U              NO-UNDO.
DEFINE VARIABLE c-cod-serie-fim2     AS CHARACTER               INIT "ZZZZZ":U         NO-UNDO.
DEFINE VARIABLE c-cod-tit-ap-ini2    AS CHARACTER               INIT "":U              NO-UNDO.
DEFINE VARIABLE c-cod-tit-ap-fim2    AS CHARACTER               INIT "ZZZZZZZZZZ":U    NO-UNDO.
DEFINE VARIABLE c-lb-mercadoria      AS CHARACTER                                      NO-UNDO.
DEFINE VARIABLE c-lb-despesa         AS CHARACTER                                      NO-UNDO.
DEFINE VARIABLE l-ok2                AS LOGICAL                                        NO-UNDO. 


/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx225         AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin274         AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boad098         AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boun005         AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx00451       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-acomp           AS HANDLE      NO-UNDO.

DEFINE BUFFER bftt_tit_ap_antecip_sdo_vinc  FOR tt_tit_ap_antecip_sdo_a_vincular.
DEFINE BUFFER bftt_tit_ap_antecip_sdo_vinc2 FOR tt_tit_ap_antecip_sdo_a_vincular.
DEFINE BUFFER bftt-antecip-import           FOR tt-antecip-import.
DEFINE BUFFER bftt-antecip-import2          FOR tt-antecip-import.

{utp/ut-liter.i "mercadoria"}
ASSIGN c-lb-mercadoria = RETURN-VALUE.

{utp/ut-liter.i "despesa"}
ASSIGN c-lb-despesa = RETURN-VALUE.

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
&Scoped-define INTERNAL-TABLES tt_tit_ap_antecip_sdo_a_vincular ~
tt-antecip-import

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt_tit_ap_antecip_sdo_a_vincular.tta_cod_estab tt_tit_ap_antecip_sdo_a_vincular.tta_cod_espec_docto tt_tit_ap_antecip_sdo_a_vincular.tta_cod_ser_docto tt_tit_ap_antecip_sdo_a_vincular.tta_cod_tit_ap tt_tit_ap_antecip_sdo_a_vincular.tta_cod_parcela tt_tit_ap_antecip_sdo_a_vincular.tta_cdn_fornecedor tt_tit_ap_antecip_sdo_a_vincular.tta_nom_abrev_fornec tt_tit_ap_antecip_sdo_a_vincular.tta_cod_indic_econ tt_tit_ap_antecip_sdo_a_vincular.tta_val_sdo_tit_ap tt_tit_ap_antecip_sdo_a_vincular.tta_val_sdo_vincular tt_tit_ap_antecip_sdo_a_vincular.tta_dat_transacao tt_tit_ap_antecip_sdo_a_vincular.ttv_val_cotac_indic_econ_inver   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define SELF-NAME brSon1
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt_tit_ap_antecip_sdo_a_vincular NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_ap_antecip_sdo_a_vincular NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt_tit_ap_antecip_sdo_a_vincular
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt_tit_ap_antecip_sdo_a_vincular


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 tt-antecip-import.cdd-id-antecip tt-antecip-import.cod-estab-ap tt-antecip-import.cod-refer-antecip-ap tt-antecip-import.cod-espec-docto-ap tt-antecip-import.cod-ser-docto-ap tt-antecip-import.cod-tit-ap tt-antecip-import.cod-parc-ap tt-antecip-import.cdn-emitente-ap fn-nome-abrev(tt-antecip-import.cdn-emitente-ap) @ cNomeAbrev tt-antecip-import.cod-moed-ap tt-antecip-import.val-vinc-embarq tt-antecip-import.dat-transacao tt-antecip-import.val-cotac-tit   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2   
&Scoped-define SELF-NAME brSon2
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-antecip-import NO-LOCK
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY {&SELF-NAME} FOR EACH tt-antecip-import NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-antecip-import
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-antecip-import


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}~
    ~{&OPEN-QUERY-brSon2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque tt-embarque-imp.cod-incoterm 
&Scoped-define ENABLED-TABLES tt-embarque-imp
&Scoped-define FIRST-ENABLED-TABLE tt-embarque-imp
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar btQueryJoins ~
btReportsJoins btExit btHelp i-cod-emit c-desc-emit 
&Scoped-Define DISPLAYED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque tt-embarque-imp.cod-incoterm 
&Scoped-define DISPLAYED-TABLES tt-embarque-imp
&Scoped-define FIRST-DISPLAYED-TABLE tt-embarque-imp
&Scoped-Define DISPLAYED-OBJECTS i-cod-emit c-desc-emit 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-nome-abrev wMasterDetail 
FUNCTION fn-nome-abrev RETURNS CHARACTER
  ( i-cod-emit AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-moeda wMasterDetail 
FUNCTION fn-desc-moeda RETURNS CHARACTER
  ( i-mo-codigo AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
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

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

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

DEFINE VARIABLE c-desc-emit AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emit AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 91 BY 2.38.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 91.14 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btDesvincula 
     IMAGE-UP FILE "image/im-acm1.bmp":U
     LABEL "":L 
     SIZE 4 BY 1.25 TOOLTIP "Desvincula Antecipa‡Æo".

DEFINE BUTTON btDesvinculaTodas 
     IMAGE-UP FILE "image/im-remall.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Desvincula Todas".

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image/im-fil.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro Antecipa‡äes a Vincular".

DEFINE BUTTON btFiltro2 
     IMAGE-UP FILE "image/im-fil.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro Antecipa‡äes Vinculadas".

DEFINE BUTTON btVincula 
     IMAGE-UP FILE "image/im-down2.bmp":U
     LABEL "":L 
     SIZE 4 BY 1.25 TOOLTIP "Vincula Antecipa‡Æo".

DEFINE BUTTON btVinculaParc 
     IMAGE-UP FILE "image/im-alteraitem.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Vincula Parcial".

DEFINE BUTTON btVinculaTodas 
     IMAGE-UP FILE "image/im-addall.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Vincula Todas".

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt_tit_ap_antecip_sdo_a_vincular SCROLLING.

DEFINE QUERY brSon2 FOR 
      tt-antecip-import SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 NO-LOCK DISPLAY
      tt_tit_ap_antecip_sdo_a_vincular.tta_cod_estab              COLUMN-LABEL "Estab"              FORMAT "x(5)":U WIDTH 7
  tt_tit_ap_antecip_sdo_a_vincular.tta_cod_espec_docto            COLUMN-LABEL "Esp‚cie"            FORMAT "x(3)":U WIDTH 5
  tt_tit_ap_antecip_sdo_a_vincular.tta_cod_ser_docto              COLUMN-LABEL "S‚rie"              FORMAT "x(5)":U WIDTH 7
  tt_tit_ap_antecip_sdo_a_vincular.tta_cod_tit_ap                 COLUMN-LABEL "T¡tulo"             FORMAT "x(10)":U WIDTH 14
  tt_tit_ap_antecip_sdo_a_vincular.tta_cod_parcela                COLUMN-LABEL "Parc"               FORMAT "x(2)":U WIDTH 4
  tt_tit_ap_antecip_sdo_a_vincular.tta_cdn_fornecedor             COLUMN-LABEL "Fornecedor"         FORMAT ">>>>>>>>9":U WIDTH 12
  tt_tit_ap_antecip_sdo_a_vincular.tta_nom_abrev_fornec           COLUMN-LABEL "Nome Abreviado"     FORMAT "x(15)":U WIDTH 18
  tt_tit_ap_antecip_sdo_a_vincular.tta_cod_indic_econ             COLUMN-LABEL "Moeda"              FORMAT "x(8)":U WIDTH 10
  tt_tit_ap_antecip_sdo_a_vincular.tta_val_sdo_tit_ap             COLUMN-LABEL "Valor Saldo T¡tulo" FORMAT "->>>,>>>,>>9.99":U WIDTH 15
  tt_tit_ap_antecip_sdo_a_vincular.tta_val_sdo_vincular           COLUMN-LABEL "Valor a Vincular"   FORMAT "->>>,>>>,>>9.99":U WIDTH 15
  tt_tit_ap_antecip_sdo_a_vincular.tta_dat_transacao              COLUMN-LABEL "Data Transa‡Æo"     FORMAT "99/99/9999":U  WIDTH 12
  tt_tit_ap_antecip_sdo_a_vincular.ttv_val_cotac_indic_econ_inver COLUMN-LABEL "Cota‡Æo T¡tulo"     FORMAT ">>>>,>>9.9999999999":U  WIDTH 20
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78 BY 6.29
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _FREEFORM
  QUERY brSon2 NO-LOCK DISPLAY
      tt-antecip-import.cdd-id-antecip           COLUMN-LABEL "ID"                 FORMAT ">>>,>>>,>>9" WIDTH 12
    tt-antecip-import.cod-estab-ap             COLUMN-LABEL "Estab"              FORMAT "x(5)":U WIDTH 7
    tt-antecip-import.cod-refer-antecip-ap     COLUMN-LABEL "Referˆncia"         FORMAT "x(10)":U WIDTH 14
    tt-antecip-import.cod-espec-docto-ap       COLUMN-LABEL "Esp‚cie"            FORMAT "x(3)":U WIDTH 5
    tt-antecip-import.cod-ser-docto-ap         COLUMN-LABEL "S‚rie"              FORMAT "x(5)":U WIDTH 7
    tt-antecip-import.cod-tit-ap               COLUMN-LABEL "T¡tulo"             FORMAT "x(10)":U WIDTH 14
    tt-antecip-import.cod-parc-ap              COLUMN-LABEL "Parc"               FORMAT "x(2)":U WIDTH 4
    tt-antecip-import.cdn-emitente-ap          COLUMN-LABEL "Fornecedor"         FORMAT ">>>>>>>>9":U WIDTH 12
    fn-nome-abrev(tt-antecip-import.cdn-emitente-ap) @ cNomeAbrev COLUMN-LABEL "Nome Abreviado" FORMAT "x(15)":U WIDTH 18
    tt-antecip-import.cod-moed-ap              COLUMN-LABEL "Moeda"              FORMAT "x(8)":U WIDTH 10
    tt-antecip-import.val-vinc-embarq          COLUMN-LABEL "Valor Vinculado"    FORMAT "->>>,>>>,>>9.99":U WIDTH 15
    tt-antecip-import.dat-transacao            COLUMN-LABEL "Data Transa‡Æo"     FORMAT "99/99/9999":U  WIDTH 12
    tt-antecip-import.val-cotac-tit            COLUMN-LABEL "Cota‡Æo T¡tulo"     FORMAT ">>>>,>>9.9999999999":U  WIDTH 20
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78 BY 6.29
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btQueryJoins AT ROW 1.13 COL 75.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 79.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 83.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 87.72 HELP
          "Ajuda"
     tt-embarque-imp.cod-estabel AT ROW 2.83 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     i-cod-emit AT ROW 2.83 COL 38.43 COLON-ALIGNED
     c-desc-emit AT ROW 2.83 COL 50.29 COLON-ALIGNED NO-LABEL
     tt-embarque-imp.embarque AT ROW 3.83 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     tt-embarque-imp.cod-incoterm AT ROW 3.83 COL 38.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.57 BY .88
     rtParent AT ROW 2.63 COL 1.14
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.57 BY 20.46
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.42 COL 2.57
     btVincula AT ROW 1.75 COL 83.29 HELP
          "Vincula"
     btVinculaParc AT ROW 3.38 COL 83.29 HELP
          "Vincula Parcial"
     btVinculaTodas AT ROW 4.96 COL 83.29 HELP
          "Vincula Todas"
     btFiltro AT ROW 6.5 COL 83.29 HELP
          "Filtro Antecipa‡äes a Vincular"
     brSon2 AT ROW 8.92 COL 2.57
     btDesvincula AT ROW 9.63 COL 83.43 HELP
          "Desvincula Antecipa‡Æo"
     btDesvinculaTodas AT ROW 11.13 COL 83.43 HELP
          "Desvincula Todas"
     btFiltro2 AT ROW 12.63 COL 83.43 HELP
          "Filtro Antecipa‡äes Vinculadas"
     "Antecipa‡äes Vinculadas" VIEW-AS TEXT
          SIZE 29 BY .54 AT ROW 8.25 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.46
         SIZE 87 BY 14.38
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-antecip-import T "?" NO-UNDO mgcex antecip-import
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-embarque-imp T "?" NO-UNDO mgcex embarque-imp
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
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
         HEIGHT             = 20.58
         WIDTH              = 91.29
         MAX-HEIGHT         = 38.21
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.21
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
/* BROWSE-TAB brSon1 TEXT-1 fPage1 */
/* BROWSE-TAB brSon2 btFiltro fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_ap_antecip_sdo_a_vincular NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-proc-ped-ent1.nr-sequencia|yes"
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-antecip-import NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-proc-ped-ent1.nr-sequencia|yes"
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RUN openQueriesSon IN phCaller.    
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
&Scoped-define SELF-NAME btDesvincula
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesvincula wMasterDetail
ON CHOOSE OF btDesvincula IN FRAME fPage1
DO:
    IF AVAIL tt-antecip-import THEN DO:
        IF NOT VALID-HANDLE(h-acomp) THEN DO:
            RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        END.
    
        {utp/ut-liter.i "Antecipa‡äes"}
        RUN pi-inicializar in h-acomp (INPUT RETURN-VALUE).
        {utp/ut-liter.i "Desvinculando_Antecipa‡Æo"}
        RUN pi-acompanhar  in h-acomp (INPUT TRIM(RETURN-VALUE)).

        RUN piDesvinculaAntecipacao IN THIS-PROCEDURE (INPUT tt-antecip-import.r-rowid).
        RUN pi-finalizar IN h-acomp.

        {utp/ut-liter.i Atualizando_Antecipa‡äes *}
        ASSIGN c-lb-acomp = TRIM(RETURN-VALUE).
        RUN openQueriesSon IN THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDesvinculaTodas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesvinculaTodas wMasterDetail
ON CHOOSE OF btDesvinculaTodas IN FRAME fPage1
DO:
    IF NOT VALID-HANDLE(h-acomp) THEN DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    END.

    {utp/ut-liter.i "Antecipa‡äes"}
    RUN pi-inicializar in h-acomp (INPUT RETURN-VALUE).
    {utp/ut-liter.i "Desvinculando_Antecipa‡äes"}
    ASSIGN c-lb-acomp = TRIM(RETURN-VALUE).
    {utp/ut-liter.i ID *}
    ASSIGN c-lb-id = TRIM(RETURN-VALUE).

    FOR EACH bftt-antecip-import2 NO-LOCK:
        RUN pi-acompanhar  in h-acomp (INPUT c-lb-acomp + " ":U + c-lb-id + ": ":U + STRING(bftt-antecip-import2.cdd-id-antecip)).
        RUN piDesvinculaAntecipacao IN THIS-PROCEDURE (INPUT bftt-antecip-import2.r-rowid).
    END.
    RUN pi-finalizar IN h-acomp.

    {utp/ut-liter.i Atualizando_Antecipa‡äes *}
    ASSIGN c-lb-acomp = TRIM(RETURN-VALUE).
    RUN openQueriesSon IN THIS-PROCEDURE.
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro wMasterDetail
ON CHOOSE OF btFiltro IN FRAME fPage1
DO:

  /*--- Seta cursor do mouse para espera ---*/
  SESSION:SET-WAIT-STATE("GENERAL":U).
  ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

  RUN imp/im0055n1.w (INPUT-OUTPUT c-cod-estabel-ini,  
                      INPUT-OUTPUT c-cod-estabel-fim,  
                      INPUT-OUTPUT i-cdn-emitente-ini, 
                      INPUT-OUTPUT i-cdn-emitente-fim, 
                      INPUT-OUTPUT d-dat-transacao-ini,
                      INPUT-OUTPUT d-dat-transacao-fim,
                      INPUT-OUTPUT c-cod-especie-ini,  
                      INPUT-OUTPUT c-cod-especie-fim,  
                      INPUT-OUTPUT c-cod-serie-ini,    
                      INPUT-OUTPUT c-cod-serie-fim,    
                      INPUT-OUTPUT c-cod-tit-ap-ini,   
                      INPUT-OUTPUT c-cod-tit-ap-fim,
                      OUTPUT l-ok).

  /*Variavel para controlar se filtro est  sendo executado na inicializa‡Æo do programa ou nÆo*/
  IF NOT l-inicializacao AND l-ok THEN DO:
      {utp/ut-liter.i "Buscando_antecipa‡äes_a_Vincular"}
      ASSIGN c-lb-acomp = TRIM(RETURN-VALUE).
      RUN pi-carrega-antecip-a-vincular IN THIS-PROCEDURE.
  END.
      
  /*--- Seta cursor do mouse para normal ---*/
  SESSION:SET-WAIT-STATE("":U). 
  ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFiltro2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro2 wMasterDetail
ON CHOOSE OF btFiltro2 IN FRAME fPage1
DO:
    /*--- Seta cursor do mouse para espera ---*/
    SESSION:SET-WAIT-STATE("GENERAL":U).
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    
    RUN imp/im0055n1.w (INPUT-OUTPUT c-cod-estabel-ini2,  
                        INPUT-OUTPUT c-cod-estabel-fim2,  
                        INPUT-OUTPUT i-cdn-emitente-ini2, 
                        INPUT-OUTPUT i-cdn-emitente-fim2, 
                        INPUT-OUTPUT d-dat-transacao-ini2,
                        INPUT-OUTPUT d-dat-transacao-fim2,
                        INPUT-OUTPUT c-cod-especie-ini2,  
                        INPUT-OUTPUT c-cod-especie-fim2,  
                        INPUT-OUTPUT c-cod-serie-ini2,    
                        INPUT-OUTPUT c-cod-serie-fim2,    
                        INPUT-OUTPUT c-cod-tit-ap-ini2,   
                        INPUT-OUTPUT c-cod-tit-ap-fim2,
                        OUTPUT l-ok2).
    
    /* Re-carrega os dados do browser se o usu rio confirmou o filtro. */
    IF l-ok2 THEN DO:
        {utp/ut-liter.i "Buscando_antecipa‡äes_vinculadas"}
        ASSIGN c-lb-acomp = TRIM(RETURN-VALUE).
        RUN pi-carrega-antecip-vinculadas IN THIS-PROCEDURE.
    END.
       
    /*--- Seta cursor do mouse para normal ---*/
    SESSION:SET-WAIT-STATE("":U). 
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btVincula
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVincula wMasterDetail
ON CHOOSE OF btVincula IN FRAME fPage1
DO:
    IF AVAIL tt_tit_ap_antecip_sdo_a_vincular THEN DO:
        IF NOT VALID-HANDLE(h-acomp) THEN DO:
            RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        END.
    
        {utp/ut-liter.i "Antecipa‡äes"}
        RUN pi-inicializar in h-acomp (INPUT RETURN-VALUE).
        {utp/ut-liter.i "Vinculando_Antecipa‡Æo"}
        RUN pi-acompanhar  in h-acomp (INPUT TRIM(RETURN-VALUE)).

        RUN piVinculaAntecipacao IN THIS-PROCEDURE (INPUT tt_tit_ap_antecip_sdo_a_vincular.ttv_rec_tit_ap,
                                                    INPUT tt_tit_ap_antecip_sdo_a_vincular.tta_val_sdo_vincular).
        RUN pi-finalizar IN h-acomp.

        IF CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorSubType = "ERROR":U ) then do:
            /** Instancia aplicativo **/
            {method/showmessage.i1}
            /** Mostra caixa com erros **/
            {method/showmessage.i2 &Modal="YES"}
            /** Limpa temp-tables de erros **/
            empty temp-table RowErrors.
        END.
        ELSE DO:
            {utp/ut-liter.i Atualizando_Antecipa‡äes *}
            ASSIGN c-lb-acomp = TRIM(RETURN-VALUE).
            RUN openQueriesSon IN THIS-PROCEDURE.    
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btVinculaParc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVinculaParc wMasterDetail
ON CHOOSE OF btVinculaParc IN FRAME fPage1
DO:
    DEFINE VARIABLE h-window AS HANDLE      NO-UNDO.
    ASSIGN h-window = CURRENT-WINDOW.
           h-window:SENSITIVE = NO.
    {utp/ut-liter.i Atualizando_Antecipa‡äes *}
    ASSIGN c-lb-acomp = TRIM(RETURN-VALUE).
    RUN imp/im0055n2.w (INPUT THIS-PROCEDURE,
                        INPUT tt_tit_ap_antecip_sdo_a_vincular.ttv_rec_tit_ap,
                        INPUT TABLE tt_tit_ap_antecip_sdo_a_vincular).
    ASSIGN h-window:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btVinculaTodas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVinculaTodas wMasterDetail
ON CHOOSE OF btVinculaTodas IN FRAME fPage1
DO:
    IF NOT VALID-HANDLE(h-acomp) THEN DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    END.

    {utp/ut-liter.i "Antecipa‡äes"}
    RUN pi-inicializar in h-acomp (INPUT RETURN-VALUE).
    {utp/ut-liter.i "Vinculando_Antecipa‡äes"}
    ASSIGN c-lb-acomp = TRIM(RETURN-VALUE).
    {utp/ut-liter.i T¡tulo *}
    ASSIGN c-lb-id = TRIM(RETURN-VALUE).

    FOR EACH bftt_tit_ap_antecip_sdo_vinc2 NO-LOCK:
        RUN pi-acompanhar  in h-acomp (INPUT c-lb-acomp + " ":U + c-lb-id + ": ":U + bftt_tit_ap_antecip_sdo_vinc2.tta_cod_tit_ap).
        RUN piVinculaAntecipacao IN THIS-PROCEDURE (INPUT bftt_tit_ap_antecip_sdo_vinc2.ttv_rec_tit_ap,
                                                    INPUT bftt_tit_ap_antecip_sdo_vinc2.tta_val_sdo_vincular).
        IF RETURN-VALUE <> "OK":U THEN LEAVE.
    END.

    RUN pi-finalizar IN h-acomp.

    IF CAN-FIND(FIRST RowErrors
                WHERE RowErrors.ErrorSubType = "ERROR":U ) then do:
        /** Instancia aplicativo **/
        {method/showmessage.i1}
        /** Mostra caixa com erros **/
        {method/showmessage.i2 &Modal="YES"}
        /** Limpa temp-tables de erros **/
        empty temp-table RowErrors.
    END.
    ELSE DO:
        {utp/ut-liter.i Atualizando_Antecipa‡äes *}
        ASSIGN c-lb-acomp = TRIM(RETURN-VALUE).
        RUN openQueriesSon IN THIS-PROCEDURE.    
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME i-cod-emit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emit wMasterDetail
ON LEAVE OF i-cod-emit IN FRAME fPage0 /* Fornecedor */
DO:
    {method/ReferenceFields.i
      &HandleDBOLeave="h-boad098"
      &FindMethod="findCodigo"
      &KeyValue1="integer(i-cod-emit:SCREEN-VALUE IN FRAME fPage0)"
      &FieldName1="nome-emit"
      &FieldScreen1="c-desc-emit"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMasterDetail 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose: Elimina‡Æo de handles utilizados pelo programa 
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-bocx220) THEN DO:
        DELETE PROCEDURE h-bocx220.
        ASSIGN h-bocx220 = ?.
    END.

    IF VALID-HANDLE(h-bocx225) THEN DO:
        DELETE PROCEDURE h-bocx225.
        ASSIGN h-bocx225 = ?.
    END.

    IF VALID-HANDLE(h-boin274) THEN DO:
        DELETE PROCEDURE h-boin274.
        ASSIGN h-boin274 = ?.
    END.

    IF VALID-HANDLE(h-boad098) THEN DO:
        DELETE PROCEDURE h-boad098.
        ASSIGN h-boad098 = ?.
    END.

    IF VALID-HANDLE(h-boun005) THEN DO:
        DELETE PROCEDURE h-boun005.
        ASSIGN h-boun005 = ?.
    END.

    IF VALID-HANDLE(h-bocx00451) THEN DO:
        DELETE PROCEDURE h-bocx00451.
        ASSIGN h-bocx00451 = ?.
    END.

    IF VALID-HANDLE(h-acomp) THEN DO:
        DELETE PROCEDURE h-acomp.
        ASSIGN h-acomp = ?.
    END.

    RUN openQueriesSon IN phCaller.

    {method/showmessage.i3}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose: Regras executadas ap¢s apresentar campos em tela   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN btFiltro :SENSITIVE IN FRAME fPage1 = YES
           btFiltro2:SENSITIVE IN FRAME fPage1 = YES.

    RETURN "OK":U.       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayFields wMasterDetail 
PROCEDURE beforeDisplayFields :
/*------------------------------------------------------------------------------
  Purpose: Carrega informa‡äes do cabe‡alho do programa e filtro inicial da tela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-cod-incoterm  AS CHARACTER   NO-UNDO.

    RUN pi-inicializa-filtro IN THIS-PROCEDURE.
    ASSIGN l-inicializacao = YES.
    APPLY "choose":U TO btFiltro IN FRAME fPage1.
    ASSIGN l-inicializacao = NO.

    RUN findRowid    in h-bocx220(INPUT r-rowid).
    RUN getCharField in h-bocx220(INPUT "cod-incoterm":U, OUTPUT c-cod-incoterm).

    ASSIGN tt-embarque-imp.cod-estabel :SCREEN-VALUE IN FRAME {&FRAME-NAME} = pcod-estabel
           tt-embarque-imp.embarque    :SCREEN-VALUE IN FRAME {&FRAME-NAME} = pembarque
           tt-embarque-imp.cod-incoterm:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-cod-incoterm.

    RUN pi-busca-fornecedor IN THIS-PROCEDURE.
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
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "cxbo/bocx220.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx220.p YES}
        {btb/btb008za.i2 cxbo/bocx220.p '' {&hDBOParent}} 
    END.
    RUN openQueryStatic IN {&hDBOParent} (INPUT "main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-bocx00451) THEN DO:
        RUN cxbo/bocx00451.p persistent set h-bocx00451.    
    END.

    IF NOT VALID-HANDLE(h-bocx225) THEN DO:
        RUN cxbo/bocx225.p persistent set h-bocx225.    
    END.
       
    IF NOT VALID-HANDLE(h-boin274) THEN DO:
        RUN inbo/boin274.p PERSISTENT SET h-boin274.
    END.

    IF NOT VALID-HANDLE(h-boad098) THEN DO:
        RUN adbo/boad098.p PERSISTENT SET h-boad098.
    END.

    IF NOT VALID-HANDLE(h-boun005) THEN DO:
        RUN unbo/boun005.p PERSISTENT SET h-boun005.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*------------------------------------------------------------------------------
  Purpose:    Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    RUN pi-carrega-antecip-a-vincular IN THIS-PROCEDURE.
    RUN pi-carrega-antecip-vinculadas IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-fornecedor wMasterDetail 
PROCEDURE pi-busca-fornecedor :
/*------------------------------------------------------------------------------
  Purpose: Busca o fornecedor para ser apresentado em tela    
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
     DEFINE VARIABLE c-return-ordens-emb  AS CHARACTER NO-UNDO.
     DEFINE VARIABLE c-return-ordem-compr AS CHARACTER NO-UNDO.
     DEFINE VARIABLE i-numero-ordem       LIKE ordem-compra.numero-ordem NO-UNDO.
     DEFINE VARIABLE i-cod-emitente       LIKE ordem-compra.cod-emitente NO-UNDO.
    
     ASSIGN i-cod-emitente = 0.

     RUN findEmbarque IN h-bocx225 (INPUT pcod-estabel,
                                    INPUT pembarque,
                                    OUTPUT c-return-ordens-emb).

     IF c-return-ordens-emb = "" THEN DO:
         RUN getintfield IN h-bocx225 ("numero-ordem":U, OUTPUT i-numero-ordem).

         RUN findOrdem IN h-boin274 (INPUT i-numero-ordem,
                                     OUTPUT c-return-ordem-compr).
         IF c-return-ordem-compr = "":U THEN DO:
             RUN getintfield IN h-boin274 ("cod-emitente":U, OUTPUT i-cod-emitente).
         END.     
     END.

     ASSIGN i-cod-emit:SCREEN-VALUE IN FRAME fpage0 = STRING(i-cod-emitente).

     APPLY "Leave":U TO i-cod-emit IN FRAME fPage0.

     RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-antecip-a-vincular wMasterDetail 
PROCEDURE pi-carrega-antecip-a-vincular :
/*------------------------------------------------------------------------------
  Purpose: Carrega as antecipa‡äes a vincular em tela     
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Browser com antecipa‡äes … vincular */
    IF NOT VALID-HANDLE(h-acomp) THEN DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    END.

    {utp/ut-liter.i "Antecipa‡äes"}
    RUN pi-inicializar in h-acomp (INPUT RETURN-VALUE).
    IF c-lb-acomp = "":U THEN DO:
       {utp/ut-liter.i "Buscando_antecipa‡äes_a_Vincular"}
       ASSIGN c-lb-acomp = TRIM(RETURN-VALUE).
    END.
    RUN pi-acompanhar  in h-acomp (INPUT c-lb-acomp).
    ASSIGN c-lb-acomp = "":U.

    EMPTY TEMP-TABLE tt-param-antecip.
    CREATE tt-param-antecip.
    ASSIGN tt-param-antecip.cod-estab-ini       = c-cod-estabel-ini     /* estabelecimento inicial*/    
           tt-param-antecip.cod-estab-fim       = c-cod-estabel-fim     /* estabelecimento final*/      
           tt-param-antecip.cdn-emitente-ini    = i-cdn-emitente-ini    /* fornecedor inicial*/         
           tt-param-antecip.cdn-emitente-fim    = i-cdn-emitente-fim    /* fornecedor final*/           
           tt-param-antecip.dat-transacao-ini   = d-dat-transacao-ini   /* data de transa‡Æo inicial*/  
           tt-param-antecip.dat-transacao-fim   = d-dat-transacao-fim   /* data de transa‡Æo final*/    
           tt-param-antecip.cod-espec-docto-ini = c-cod-especie-ini     /* esp‚cie inicial*/            
           tt-param-antecip.cod-espec-docto-fim = c-cod-especie-fim     /* esp‚cie final*/              
           tt-param-antecip.cod-ser-docto-ini   = c-cod-serie-ini       /* s‚rie inicial*/              
           tt-param-antecip.cod-ser-docto-fim   = c-cod-serie-fim       /* s‚rie final*/                
           tt-param-antecip.cod-tit-ap-ini      = c-cod-tit-ap-ini      /* t¡tulo inicial*/             
           tt-param-antecip.cod-tit-ap-fim      = c-cod-tit-ap-fim.     /* t¡tulo final*/               

    RUN piBuscaAntecipVincular IN h-bocx00451 (INPUT TABLE tt-param-antecip,
                                               OUTPUT TABLE tt_tit_ap_antecip_sdo_a_vincular).

    {utp/ut-liter.i "Carregando_antecipa‡äes_a_Vincular"}
    RUN pi-acompanhar in h-acomp (input RETURN-VALUE).
    {&OPEN-QUERY-brSon1}
    RUN pi-finalizar in h-acomp.

    IF AVAIL tt_tit_ap_antecip_sdo_a_vincular THEN DO:
        ASSIGN btVincula     :SENSITIVE IN FRAME fPage1 = YES
               btVinculaParc :SENSITIVE IN FRAME fPage1 = YES
               btVinculaTodas:SENSITIVE IN FRAME fPage1 = YES.

        ENABLE brSon1 WITH FRAME fPage1.
    END.
    ELSE DO:
        ASSIGN btVincula     :SENSITIVE IN FRAME fPage1 = NO
               btVinculaParc :SENSITIVE IN FRAME fPage1 = NO
               btVinculaTodas:SENSITIVE IN FRAME fPage1 = NO.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-antecip-vinculadas wMasterDetail 
PROCEDURE pi-carrega-antecip-vinculadas :
/*------------------------------------------------------------------------------
  Purpose: Carrega as antecipa‡äes vinculadas em tela     
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE rCurrentRow   AS ROWID       NO-UNDO.
    DEFINE VARIABLE iRowsReturned AS INTEGER     NO-UNDO.

    /* Browser com antecipa‡äes vinculadas */
    IF NOT VALID-HANDLE(h-acomp) THEN DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    END.

    {utp/ut-liter.i "Antecipa‡äes"}
    RUN pi-inicializar in h-acomp (INPUT RETURN-VALUE).
    IF c-lb-acomp = "":U THEN DO:
        {utp/ut-liter.i "Buscando_antecipa‡äes_vinculadas"}
        ASSIGN c-lb-acomp = TRIM(RETURN-VALUE).
    END.
    RUN pi-acompanhar  in h-acomp (INPUT c-lb-acomp).
    ASSIGN c-lb-acomp = "":U.

    EMPTY TEMP-TABLE tt-param-antecip.
    CREATE tt-param-antecip.
    ASSIGN tt-param-antecip.cod-estab-ini       = c-cod-estabel-ini2     /* estabelecimento inicial*/    
           tt-param-antecip.cod-estab-fim       = c-cod-estabel-fim2     /* estabelecimento final*/      
           tt-param-antecip.cdn-emitente-ini    = i-cdn-emitente-ini2    /* fornecedor inicial*/         
           tt-param-antecip.cdn-emitente-fim    = i-cdn-emitente-fim2    /* fornecedor final*/           
           tt-param-antecip.dat-transacao-ini   = d-dat-transacao-ini2   /* data de transa‡Æo inicial*/  
           tt-param-antecip.dat-transacao-fim   = d-dat-transacao-fim2   /* data de transa‡Æo final*/    
           tt-param-antecip.cod-espec-docto-ini = c-cod-especie-ini2     /* esp‚cie inicial*/            
           tt-param-antecip.cod-espec-docto-fim = c-cod-especie-fim2     /* esp‚cie final*/              
           tt-param-antecip.cod-ser-docto-ini   = c-cod-serie-ini2       /* s‚rie inicial*/              
           tt-param-antecip.cod-ser-docto-fim   = c-cod-serie-fim2       /* s‚rie final*/                
           tt-param-antecip.cod-tit-ap-ini      = c-cod-tit-ap-ini2      /* t¡tulo inicial*/             
           tt-param-antecip.cod-tit-ap-fim      = c-cod-tit-ap-fim2.     /* t¡tulo final*/               

    RUN setConstraintEmbarqueComFaixa IN h-bocx00451 (INPUT pembarque,
                                                      INPUT pcod-estabel,
                                                      INPUT TABLE tt-param-antecip).

    RUN openQueryStatic IN h-bocx00451 (INPUT "EmbarqueComFaixa":U) NO-ERROR.
    RUN getRowid in h-bocx00451( OUTPUT rCurrentRow ).
    RUN getBatchRecords IN h-bocx00451(INPUT rCurrentRow,
                                       INPUT NO,
                                       INPUT ?,
                                       OUTPUT iRowsReturned,
                                       OUTPUT TABLE tt-antecip-import ).

    {utp/ut-liter.i "Carregando_antecipa‡äes_vinculadas"}
    RUN pi-acompanhar in h-acomp (input RETURN-VALUE).
    {&OPEN-QUERY-brSon2}

    RUN pi-finalizar in h-acomp.

    IF AVAIL tt-antecip-import THEN DO:
        ASSIGN btDesvincula     :SENSITIVE IN FRAME fPage1 = YES
               btDesvinculaTodas:SENSITIVE IN FRAME fPage1 = YES.
                                                        
        ENABLE brSon2 WITH FRAME fPage1.                
    END.                                                
    ELSE DO:                               
        ASSIGN btDesvincula     :SENSITIVE IN FRAME fPage1 = NO
               btDesvinculaTodas:SENSITIVE IN FRAME fPage1 = NO.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-filtro wMasterDetail 
PROCEDURE pi-inicializa-filtro :
/*------------------------------------------------------------------------------
  Purpose:     Inicializar os parametros para abertura do filtro do browser
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN c-cod-estabel-ini    = "":U
           c-cod-estabel-fim    = "ZZZZZ":U
           i-cdn-emitente-ini   = 0
           i-cdn-emitente-fim   = 999999999
           d-dat-transacao-ini  = TODAY - 30 
           d-dat-transacao-fim  = TODAY
           c-cod-especie-ini    = "":U
           c-cod-especie-fim    = "ZZZ":U
           c-cod-serie-ini      = "":U
           c-cod-serie-fim      = "ZZZZZ":U
           c-cod-tit-ap-ini     = "":U
           c-cod-tit-ap-fim     = "ZZZZZZZZZZZZZZZZ":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDesvinculaAntecipacao wMasterDetail 
PROCEDURE piDesvinculaAntecipacao :
/*------------------------------------------------------------------------------
  Purpose:    Desvincula antecipa‡Æo ao embarque     
  Parameters: pr-rowid - Rowid da antecipa‡Æo que est  sendo desvinculada  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pr-rowid LIKE tt-antecip-import.r-rowid NO-UNDO.

    FOR FIRST bftt-antecip-import
        WHERE bftt-antecip-import.r-rowid = pr-rowid EXCLUSIVE-LOCK:
        RUN emptyRowErrors   IN h-bocx00451.
        RUN repositionRecord IN h-bocx00451 (INPUT bftt-antecip-import.r-rowid).
        RUN deleteRecord     IN h-bocx00451.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVinculaAntecipacao wMasterDetail 
PROCEDURE piVinculaAntecipacao :
/*------------------------------------------------------------------------------
  Purpose: Vincula antecipa‡Æo ao embarque     
  Parameters: pr-recid - Recid da antecipa‡Æo que est  sendo vinculada  
              pde-valor-a-vincular - valor da antecipa‡Æo que ser  vinculada ao
                                     embarque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pr-recid             LIKE tt_tit_ap_antecip_sdo_a_vincular.ttv_rec_tit_ap       NO-UNDO.
    DEFINE INPUT PARAMETER pde-valor-a-vincular LIKE tt_tit_ap_antecip_sdo_a_vincular.tta_val_sdo_vincular NO-UNDO.

    DEFINE VARIABLE i-nr-prox-antecip      LIKE antecip-import.cdd-id-antecip NO-UNDO.
    DEFINE VARIABLE l-continuar-vinculacao AS LOGICAL                         NO-UNDO.

    RUN emptyRowErrors  IN h-bocx00451.
    RUN emptyRowObject  IN h-bocx00451.

    FOR FIRST bftt_tit_ap_antecip_sdo_vinc
        WHERE bftt_tit_ap_antecip_sdo_vinc.ttv_rec_tit_ap = pr-recid EXCLUSIVE-LOCK:

        RUN goToKeyTituloEmb IN h-bocx00451 (INPUT bftt_tit_ap_antecip_sdo_vinc.tta_cod_estab, 
                                             INPUT bftt_tit_ap_antecip_sdo_vinc.tta_cod_espec_docto, 
                                             INPUT bftt_tit_ap_antecip_sdo_vinc.tta_cod_ser_docto, 
                                             INPUT bftt_tit_ap_antecip_sdo_vinc.tta_cod_tit_ap, 
                                             INPUT bftt_tit_ap_antecip_sdo_vinc.tta_cod_parcela, 
                                             INPUT bftt_tit_ap_antecip_sdo_vinc.tta_cdn_fornecedor, 
                                             INPUT tt-embarque-imp.cod-estabel,   
                                             INPUT tt-embarque-imp.embarque).
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getRecord IN h-bocx00451 (OUTPUT TABLE tt-antecip-import-aux).
            FOR FIRST tt-antecip-import-aux EXCLUSIVE-LOCK:
                ASSIGN tt-antecip-import-aux.val-vinc-embarq = tt-antecip-import-aux.val-vinc-embarq + pde-valor-a-vincular.
            END.
        
            RUN setRecord    IN h-bocx00451 (INPUT TABLE tt-antecip-import-aux).
            RUN piValidaMoedasDiferentes (OUTPUT l-continuar-vinculacao).
            IF l-continuar-vinculacao THEN
                RUN updateRecord IN h-bocx00451.
        
        END.
        ELSE DO:
            RUN piRetornaIdAntecip IN  h-bocx00451 (INPUT  tt-embarque-imp.cod-estabel,
                                                    INPUT  tt-embarque-imp.embarque,
                                                    OUTPUT i-nr-prox-antecip).
        
            CREATE tt-antecip-import-aux.
            ASSIGN tt-antecip-import-aux.cdd-id-antecip            = i-nr-prox-antecip 
                   tt-antecip-import-aux.cod-estabel               = tt-embarque-imp.cod-estabel
                   tt-antecip-import-aux.cod-embarq                = tt-embarque-imp.embarque
                   tt-antecip-import-aux.cod-estab-ap              = bftt_tit_ap_antecip_sdo_vinc.tta_cod_estab
                   tt-antecip-import-aux.cod-espec-docto-ap        = bftt_tit_ap_antecip_sdo_vinc.tta_cod_espec_docto          
                   tt-antecip-import-aux.cod-ser-docto-ap          = bftt_tit_ap_antecip_sdo_vinc.tta_cod_ser_docto            
                   tt-antecip-import-aux.cod-tit-ap                = bftt_tit_ap_antecip_sdo_vinc.tta_cod_tit_ap               
                   tt-antecip-import-aux.cod-parc-ap               = bftt_tit_ap_antecip_sdo_vinc.tta_cod_parcela              
                   tt-antecip-import-aux.cod-refer-antecip-ap      = bftt_tit_ap_antecip_sdo_vinc.tta_cod_refer                
                   tt-antecip-import-aux.cdn-emitente-ap           = bftt_tit_ap_antecip_sdo_vinc.tta_cdn_fornecedor           
                   tt-antecip-import-aux.nom-abrev-ap              = bftt_tit_ap_antecip_sdo_vinc.tta_nom_abrev_fornec         
                   tt-antecip-import-aux.cod-moed-ap               = bftt_tit_ap_antecip_sdo_vinc.tta_cod_indic_econ           
                   tt-antecip-import-aux.cod-empres-ap             = bftt_tit_ap_antecip_sdo_vinc.tta_cod_empresa              
                   tt-antecip-import-aux.cod-usuar-criac           = c-seg-usuario
                   tt-antecip-import-aux.dtm-criac                 = DATETIME(TODAY, MTIME)
                   tt-antecip-import-aux.dat-transacao             = bftt_tit_ap_antecip_sdo_vinc.tta_dat_transacao            
                   tt-antecip-import-aux.dat-emis                  = bftt_tit_ap_antecip_sdo_vinc.tta_dat_emis_docto           
                   tt-antecip-import-aux.val-vinc-embarq           = pde-valor-a-vincular
                   tt-antecip-import-aux.dat-vencto-tit            = bftt_tit_ap_antecip_sdo_vinc.tta_dat_vencto_tit_ap         
                   tt-antecip-import-aux.dat-prev-pagto            = bftt_tit_ap_antecip_sdo_vinc.tta_dat_prev_pagto            
                   tt-antecip-import-aux.dat-ult-pagto             = bftt_tit_ap_antecip_sdo_vinc.tta_dat_ult_pagto             
                   tt-antecip-import-aux.dat-ult-apurac-variac-val = bftt_tit_ap_antecip_sdo_vinc.tta_dat_ult_apurac_variac_val 
                   tt-antecip-import-aux.dat-liquidac-tit-ap       = bftt_tit_ap_antecip_sdo_vinc.tta_dat_liquidac_tit_ap       
                   tt-antecip-import-aux.val-sdo-tit-ap            = bftt_tit_ap_antecip_sdo_vinc.tta_val_sdo_tit_ap            
                   tt-antecip-import-aux.val-origin-tit-ap         = bftt_tit_ap_antecip_sdo_vinc.tta_val_origin_tit_ap         
                   tt-antecip-import-aux.val-entr-transf-estab     = bftt_tit_ap_antecip_sdo_vinc.tta_val_entr_transf_estab     
                   tt-antecip-import-aux.val-liber-pagto-orig-tot  = bftt_tit_ap_antecip_sdo_vinc.ttv_val_liber_pagto_orig_tot  
                   tt-antecip-import-aux.val-tot-pagto-tit-ap      = bftt_tit_ap_antecip_sdo_vinc.ttv_val_tot_pagto_tit_ap      
                   tt-antecip-import-aux.val-cotac-tit             = bftt_tit_ap_antecip_sdo_vinc.ttv_val_cotac_indic_econ_inver /*cota‡Æo da moeda - no EMS5 o conceito ‚ diferente do EMS2*/
                   tt-antecip-import-aux.val-cotac-tit-inver       = bftt_tit_ap_antecip_sdo_vinc.ttv_val_cotac_indic_econ_aux   /*cota‡Æo inversa da moeda - no EMS5 o conceito ‚ diferente do EMS2*/
                   tt-antecip-import-aux.val-origin-tit-ap-aux     = bftt_tit_ap_antecip_sdo_vinc.ttv_val_origin_tit_ap_aux   /*valor na moeda corrente*/  
                   tt-antecip-import-aux.val-sdo-tit-ap-aux        = bftt_tit_ap_antecip_sdo_vinc.ttv_val_sdo_tit_ap_aux.     /*valor na moeda corrente*/

            RUN setRecord    IN h-bocx00451 (INPUT TABLE tt-antecip-import-aux).

            RUN piValidaMoedasDiferentes (OUTPUT l-continuar-vinculacao).
            IF l-continuar-vinculacao THEN
                RUN createRecord IN h-bocx00451.
        END.
        DELETE tt-antecip-import-aux.
        RUN getRowErrors IN h-bocx00451 (OUTPUT TABLE RowErrors).

        IF CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorSubType = "ERROR":U ) then do:
            RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaMoedasDiferentes wMasterDetail 
PROCEDURE piValidaMoedasDiferentes :
/*------------------------------------------------------------------------------
  Purpose: Emite questionamento sobre continuar a vincula‡Æo quando a antecipa‡Æo 
           for para o fornecedor da mercadoria/despesa e possuir moeda diferente 
           da mercadoria/despesa.    
  Parameters: pl-continuar-vinculacao - indica se deve continuar com a vincula‡Æo 
              - (output) (logical)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM pl-continuar-vinculacao AS LOGICAL NO-UNDO.

    DEFINE VARIABLE i-tipo-fornec  AS INTEGER           NO-UNDO.
    DEFINE VARIABLE c-param-msg    AS CHARACTER         NO-UNDO.
    DEFINE VARIABLE i-mo-merc-desp LIKE moeda.mo-codigo NO-UNDO.
    DEFINE VARIABLE i-mo-antecip   LIKE moeda.mo-codigo NO-UNDO.
    
    IF VALID-HANDLE(h-bocx00451) THEN
        RUN piRetornaMoedasMercDespAntecip IN h-bocx00451 (OUTPUT i-tipo-fornec,
                                                           OUTPUT i-mo-merc-desp,
                                                           OUTPUT i-mo-antecip).

    IF i-tipo-fornec > 0 AND i-mo-merc-desp <> i-mo-antecip THEN DO:
        IF i-tipo-fornec = 1 THEN /*Mercadoria*/
            ASSIGN c-param-msg = c-lb-mercadoria.
        ELSE IF i-tipo-fornec = 2 THEN /*Despesa*/
            ASSIGN c-param-msg = c-lb-despesa.

        /*Texto: T¡tulo da antecipa‡Æo com moeda diferente da &1.
          Ajuda: A antecipa‡Æo de t¡tulo &2 e parcela &3 do fornecedor &4 
                 possui moeda &5 e a &1 possui a moeda &6. 
                 Deseja prosseguir com a vincula‡Æo? */
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 55849,
                           INPUT c-param-msg + "~~" +
                                 tt-antecip-import-aux.cod-tit-ap + "~~" +
                                 tt-antecip-import-aux.cod-parc-ap + "~~" + 
                                 fn-nome-abrev(tt-antecip-import-aux.cdn-emitente-ap) + "~~" +
                                 fn-desc-moeda(i-mo-antecip) + "~~" +
                                 fn-desc-moeda(i-mo-merc-desp)).
        ASSIGN pl-continuar-vinculacao = (RETURN-VALUE = "YES":U).
    END.
    ELSE
        ASSIGN pl-continuar-vinculacao = YES.

     RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowErrors wMasterDetail 
PROCEDURE getRowErrors :
/*------------------------------------------------------------------------------
  Purpose: Retorna a temp-table de erros do programa     
  Parameters: RowErrors - Temp-table de erros
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM TABLE FOR RowErrors.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-nome-abrev wMasterDetail 
FUNCTION fn-nome-abrev RETURNS CHARACTER
  ( i-cod-emit AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Retornar o nome abreviado do emitente  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-return     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-nome-abrev AS CHARACTER   NO-UNDO.

    RUN findCodigo IN h-boad098 (INPUT i-cod-emit,
                                 OUTPUT c-return).

    IF c-return = "":U THEN DO:
        RUN getCharField IN h-boad098 (INPUT "nome-abrev":U,
                                       OUTPUT c-nome-abrev).
        RETURN c-nome-abrev.
    END.
    ELSE DO:
        RETURN "":U.
    END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-moeda wMasterDetail 
FUNCTION fn-desc-moeda RETURNS CHARACTER
  ( i-mo-codigo AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Retornar a descri‡Æo da moeda
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-return     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-descricao  AS CHARACTER   NO-UNDO.

    run findCodigo in h-boun005 (INPUT i-mo-codigo, 
                                 output c-return).

    IF c-return = "":U THEN DO:
        RUN getCharField IN h-boun005 (INPUT "descricao":U,
                                       OUTPUT c-descricao).
        RETURN c-descricao.
    END.
    ELSE DO:
        RETURN "":U.
    END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
