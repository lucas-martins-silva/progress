&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decla-import NO-UNDO LIKE decla-import
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-adic NO-UNDO LIKE decla-import-adic
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-adic-itens NO-UNDO LIKE decla-import-adic-itens
       field r-Rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0410C 2.00.00.029 } /*** "010029" 15/07/2026 13:37:33 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0410C MEX}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           IM0410C
&GLOBAL-DEFINE Version        2.00.00.029

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Item,Impostos,Impostos 2

&GLOBAL-DEFINE ttTable           tt-decla-import-adic-itens
&GLOBAL-DEFINE hDBOTable         h-bocx402
&GLOBAL-DEFINE DBOTable          decla-import-adic-itens

&GLOBAL-DEFINE ttParent          tt-decla-import-adic
&GLOBAL-DEFINE DBOParentTable    h-bocx403

&GLOBAL-DEFINE page0KeyFields    tt-decla-import-adic-itens.num-di-ems c_cod-di-siscomex i_num-seq-retif tt-decla-import-adic-itens.num-adic tt-decla-import-adic-itens.num-seq c_cod-estab d_dat-di 
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields       tt-decla-import-adic-itens.cod-item tt-decla-import-adic-itens.dsl-especif d-valor-unit-item
&GLOBAL-DEFINE page2Fields       cb-idi-tributac-impto-import tt-decla-import-adic-itens.val-aliq-ii ~
                                 cb-suspens-impto-import cb-suspens-icms cb-suspens-pis cb-suspens-cofins ~
                                 tt-decla-import-adic-itens.val-perc-reduc-impto-import tt-decla-import-adic-itens.val-base-ii d-valor-impostos-ii cb-idi-tributac-ipi tt-decla-import-adic-itens.val-aliq-ipi cb-suspens-ipi-import tt-decla-import-adic-itens.val-perc-reduc-ipi tt-decla-import-adic-itens.val-unit-ipi tt-decla-import-adic-itens.val-base-ipi d-valor-impostos-ipi cb-idi-tributac-icms tt-decla-import-adic-itens.val-aliq-icms tt-decla-import-adic-itens.val-perc-reduc-icms tt-decla-import-adic-itens.val-base-icms d-valor-impostos-icms cb-idi-tributac-pis tt-decla-import-adic-itens.val-aliq-pis tt-decla-import-adic-itens.val-perc-reduc-pis tt-decla-import-adic-itens.val-unit-pis tt-decla-import-adic-itens.val-base-pis d-valor-impostos-pis cb-idi-tributac-cofins tt-decla-import-adic-itens.val-aliq-cofins tt-decla-import-adic-itens.val-perc-reduc-cofins tt-decla-import-adic-itens.val-unit-cofins tt-decla-import-adic-itens.val-base-cofins d-valor-impostos-cofins ~
                                 label-fcp label-fcp-st label-icms label-icms-compl label-icms-st ~
                                 de-val-aliq-fcp tt-decla-import-adic-itens.val-base-fcp tt-decla-import-adic-itens.val-fcp ~
                                 de-val-aliq-fcp-substto tt-decla-import-adic-itens.val-base-fcp-substto tt-decla-import-adic-itens.val-fcp-substto ~
                                 tt-decla-import-adic-itens.val-base-icms-substto tt-decla-import-adic-itens.val-icms-substto ~
                                 tt-decla-import-adic-itens.val-base-icms-compltar tt-decla-import-adic-itens.val-icms-compltar 
&GLOBAL-DEFINE page3Fields       label-tributac-2 label-aliq-2 label-reduc-2 label-base-calc-2 label-valor-2 ~
                                 label-cst label-class-trib label-ibsuf label-IBSMun label-cbs ~
                                 label-aliq-reg label-base-calc-reg label-valor-reg ~
                                 label-cst-reg label-class-trib-reg label-IS 
/*cb-idi-tributac-is de-val-aliq-is de-val-aliq-espec-is de-qtde-is c-un-trib-is de-base-is de-valor-impostos-is c-class-trib-is c-cst-is*/
/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEF VAR c-return AS CHAR NO-UNDO.
DEF VAR c-descItem-aux AS CHAR FORMAT 'x(40)' NO-UNDO.
DEF VAR i-num-linha-browse AS INTEGER NO-UNDO.
DEF VAR i-nr-registro AS INTEGER NO-UNDO.
DEF VAR rRowid AS ROWID NO-UNDO.
DEF VAR d-val-unit-vucv LIKE decla-import-adic-itens.val-vucv NO-UNDO.

DEF VAR l-encontrou AS LOGICAL NO-UNDO.

DEFINE VARIABLE i-trib-ibsuf  AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE i-trib-ibsmun AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE i-trib-cbs    AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE l-nt2024002   AS LOGICAL           NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002":U AND funcao.ativo).

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin172na  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx390    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx383a   AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-decla-import-adic-itens.num-di-ems ~
tt-decla-import-adic-itens.num-adic tt-decla-import-adic-itens.num-seq 
&Scoped-define ENABLED-TABLES tt-decla-import-adic-itens
&Scoped-define FIRST-ENABLED-TABLE tt-decla-import-adic-itens
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar c_cod-di-siscomex ~
i_num-seq-retif c_cod-estab d_dat-di c-registro btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-decla-import-adic-itens.num-di-ems ~
tt-decla-import-adic-itens.num-adic tt-decla-import-adic-itens.num-seq 
&Scoped-define DISPLAYED-TABLES tt-decla-import-adic-itens
&Scoped-define FIRST-DISPLAYED-TABLE tt-decla-import-adic-itens
&Scoped-Define DISPLAYED-OBJECTS c_cod-di-siscomex i_num-seq-retif ~
c_cod-estab d_dat-di c-registro 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-nex 
     IMAGE-UP FILE "image/im-nex":U
     IMAGE-INSENSITIVE FILE "image/ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.

DEFINE BUTTON bt-pre 
     IMAGE-UP FILE "image/im-pre":U
     IMAGE-INSENSITIVE FILE "image/ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.

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

DEFINE VARIABLE c-registro AS CHARACTER FORMAT "X(256)":U 
     LABEL "Registro" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c_cod-di-siscomex AS CHARACTER FORMAT "x(13)" 
     LABEL "DI SISCOMEX" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE c_cod-estab AS CHARACTER FORMAT "x(5)" 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE d_dat-di AS DATE FORMAT "99/99/9999" 
     LABEL "Data DI" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE VARIABLE i_num-seq-retif AS INTEGER FORMAT "99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE d-valor-unit-item LIKE tt-decla-import-adic-itens.val-vucv
     LABEL "Vl Unit" 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88 NO-UNDO.

DEFINE VARIABLE d-valor-vucv-item LIKE tt-decla-import-adic-itens.val-vucv
     LABEL "VUCV" 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88 NO-UNDO.

DEFINE VARIABLE label-especif AS CHARACTER FORMAT "X(256)":U INITIAL "Especifica‡Æo:" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 10.25.

DEFINE VARIABLE cb-idi-tributac-cofins AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-icms AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-impto-import AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-ipi AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-pis AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE cb-suspens-cofins AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Sim","NÆo" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE cb-suspens-icms AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Sim","NÆo" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE cb-suspens-impto-import AS CHARACTER FORMAT "X(256)":U INITIAL "NÆo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Sim","NÆo" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE cb-suspens-ipi-import AS CHARACTER FORMAT "X(256)":U INITIAL "NÆo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Sim","NÆo" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE cb-suspens-pis AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Sim","NÆo" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE d-valor-impostos-cofins AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE d-valor-impostos-icms AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE d-valor-impostos-ii AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE d-valor-impostos-ipi AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE d-valor-impostos-pis AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE de-val-aliq-fcp AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-aliq-fcp-substto AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE label-aliq AS CHARACTER FORMAT "X(256)":U INITIAL "Al¡quota" 
      VIEW-AS TEXT 
     SIZE 7.09 BY .67 NO-UNDO.

DEFINE VARIABLE label-base-calc AS CHARACTER FORMAT "X(256)":U INITIAL "Base C lculo" 
      VIEW-AS TEXT 
     SIZE 9.57 BY .67 NO-UNDO.

DEFINE VARIABLE label-cofins AS CHARACTER FORMAT "X(256)":U INITIAL "COFINS" 
      VIEW-AS TEXT 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE label-fcp AS CHARACTER FORMAT "X(256)":U INITIAL "FCP" 
      VIEW-AS TEXT 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE label-fcp-st AS CHARACTER FORMAT "X(256)":U INITIAL "FCP ST" 
      VIEW-AS TEXT 
     SIZE 6.57 BY .88 NO-UNDO.

DEFINE VARIABLE label-icms AS CHARACTER FORMAT "X(256)":U INITIAL "ICMS" 
      VIEW-AS TEXT 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE label-icms-compl AS CHARACTER FORMAT "X(256)":U INITIAL "ICMS Compl" 
      VIEW-AS TEXT 
     SIZE 9.57 BY .88 NO-UNDO.

DEFINE VARIABLE label-icms-st AS CHARACTER FORMAT "X(256)":U INITIAL "ICMS ST" 
      VIEW-AS TEXT 
     SIZE 6.57 BY .88 NO-UNDO.

DEFINE VARIABLE label-ii AS CHARACTER FORMAT "X(256)":U INITIAL "II" 
      VIEW-AS TEXT 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE label-ipi AS CHARACTER FORMAT "X(256)":U INITIAL "IPI" 
      VIEW-AS TEXT 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE label-pis AS CHARACTER FORMAT "X(256)":U INITIAL "PIS" 
      VIEW-AS TEXT 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE label-reduc AS CHARACTER FORMAT "X(256)":U INITIAL "Redu‡Æo" 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE label-susp AS CHARACTER FORMAT "X(256)":U INITIAL "Suspenso" 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE label-tributac AS CHARACTER FORMAT "X(256)":U INITIAL "Tributa‡Æo" 
      VIEW-AS TEXT 
     SIZE 8.43 BY .67 NO-UNDO.

DEFINE VARIABLE label-valor AS CHARACTER FORMAT "X(256)":U INITIAL "Valor" 
      VIEW-AS TEXT 
     SIZE 4.29 BY .67 NO-UNDO.

DEFINE VARIABLE label-vl-unit AS CHARACTER FORMAT "X(256)":U INITIAL "Vl. Unit. Imp." 
      VIEW-AS TEXT 
     SIZE 9.43 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.29 BY 10.5.

DEFINE VARIABLE cb-idi-tributac-cbs AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-ibsmun AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-ibsuf AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-is AS CHARACTER FORMAT "X(256)" 
     LABEL "Tributa‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-class-trib-cbs AS CHARACTER FORMAT "X(09)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-class-trib-ibsmun AS CHARACTER FORMAT "X(09)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-class-trib-ibsuf AS CHARACTER FORMAT "X(09)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-class-trib-is AS CHARACTER FORMAT "X(09)":U 
     LABEL "Class Trib" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-class-trib-reg-cbs AS CHARACTER FORMAT "X(09)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-class-trib-reg-ibsmun AS CHARACTER FORMAT "X(09)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-class-trib-reg-ibsuf AS CHARACTER FORMAT "X(09)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-cbs AS CHARACTER FORMAT "X(03)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-ibsmun AS CHARACTER FORMAT "X(03)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-ibsuf AS CHARACTER FORMAT "X(03)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-is AS CHARACTER FORMAT "X(03)":U 
     LABEL "CST" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-reg-cbs AS CHARACTER FORMAT "X(03)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-reg-ibsmun AS CHARACTER FORMAT "X(03)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-reg-ibsuf AS CHARACTER FORMAT "X(03)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-trib-is AS CHARACTER FORMAT "X(09)":U 
     LABEL "Un Tribut vel" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE de-base-cbs AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE de-base-ibsmun AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE de-base-ibsuf AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE de-base-is AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     LABEL "Base C lculo" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE de-base-reg-cbs AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE de-base-reg-ibsmun AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE de-base-reg-ibsuf AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE de-perc-reduc-cbs AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-perc-reduc-ibsmun AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-perc-reduc-ibsuf AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-qtde-is AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Qtde Tribut vel" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-val-aliq-cbs AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-val-aliq-espec-is AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Aliq Espec Un" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-val-aliq-ibsmun AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-val-aliq-ibsuf AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-val-aliq-is AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Al¡quota" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-val-aliq-reg-cbs AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-val-aliq-reg-ibsmun AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-val-aliq-reg-ibsuf AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-valor-impostos-cbs AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE de-valor-impostos-ibsmun AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-impostos-ibsuf AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-impostos-is AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     LABEL "Valor" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-impostos-reg-cbs AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE de-valor-impostos-reg-ibsmun AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-impostos-reg-ibsuf AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE label-aliq-2 AS CHARACTER FORMAT "X(20)":U INITIAL "Al¡quota" 
      VIEW-AS TEXT 
     SIZE 6.43 BY .67 NO-UNDO.

DEFINE VARIABLE label-aliq-reg AS CHARACTER FORMAT "X(20)":U INITIAL "Al¡quota" 
      VIEW-AS TEXT 
     SIZE 5.86 BY .67 NO-UNDO.

DEFINE VARIABLE label-base-calc-2 AS CHARACTER FORMAT "X(20)":U INITIAL "Base C lculo" 
      VIEW-AS TEXT 
     SIZE 9.29 BY .67 NO-UNDO.

DEFINE VARIABLE label-base-calc-reg AS CHARACTER FORMAT "X(20)":U INITIAL "Base C lculo" 
      VIEW-AS TEXT 
     SIZE 9.29 BY .67 NO-UNDO.

DEFINE VARIABLE label-CBS AS CHARACTER FORMAT "X(256)":U INITIAL "CBS" 
      VIEW-AS TEXT 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE label-class-trib AS CHARACTER FORMAT "X(10)":U INITIAL "Class Trib" 
      VIEW-AS TEXT 
     SIZE 7.29 BY .67 NO-UNDO.

DEFINE VARIABLE label-class-trib-reg AS CHARACTER FORMAT "X(10)":U INITIAL "Class Trib" 
      VIEW-AS TEXT 
     SIZE 7.14 BY .67 NO-UNDO.

DEFINE VARIABLE label-cst AS CHARACTER FORMAT "X(5)":U INITIAL "CST" 
      VIEW-AS TEXT 
     SIZE 3 BY .67 NO-UNDO.

DEFINE VARIABLE label-cst-reg AS CHARACTER FORMAT "X(5)":U INITIAL "CST" 
      VIEW-AS TEXT 
     SIZE 3 BY .67 NO-UNDO.

DEFINE VARIABLE label-IBSMun AS CHARACTER FORMAT "X(256)":U INITIAL "IBS Mun" 
      VIEW-AS TEXT 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE label-IBSUF AS CHARACTER FORMAT "X(256)":U INITIAL "IBS UF" 
      VIEW-AS TEXT 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE label-IS AS CHARACTER FORMAT "X(256)":U INITIAL "IS" 
      VIEW-AS TEXT 
     SIZE 2 BY .88 NO-UNDO.

DEFINE VARIABLE label-reduc-2 AS CHARACTER FORMAT "X(20)":U INITIAL "Redu‡Æo" 
      VIEW-AS TEXT 
     SIZE 6.86 BY .67 NO-UNDO.

DEFINE VARIABLE label-tributac-2 AS CHARACTER FORMAT "X(20)":U INITIAL "Tributa‡Æo" 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE VARIABLE label-valor-2 AS CHARACTER FORMAT "X(20)":U INITIAL "Valor" 
      VIEW-AS TEXT 
     SIZE 4.14 BY .67 NO-UNDO.

DEFINE VARIABLE label-valor-reg AS CHARACTER FORMAT "X(20)":U INITIAL "Valor" 
      VIEW-AS TEXT 
     SIZE 4 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61.57 BY 5.5.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 9.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-decla-import-adic-itens.num-di-ems AT ROW 1.25 COL 5.86 COLON-ALIGNED WIDGET-ID 102
          LABEL "DI EMS"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c_cod-di-siscomex AT ROW 1.25 COL 31.43 COLON-ALIGNED WIDGET-ID 94
     i_num-seq-retif AT ROW 1.25 COL 46.57 COLON-ALIGNED NO-LABEL WIDGET-ID 104
     tt-decla-import-adic-itens.num-adic AT ROW 1.25 COL 62 COLON-ALIGNED WIDGET-ID 100
          LABEL "Adi‡Æo" FORMAT "999"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-decla-import-adic-itens.num-seq AT ROW 1.25 COL 76 COLON-ALIGNED WIDGET-ID 90
          LABEL "Seq" FORMAT "->,>>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c_cod-estab AT ROW 2.25 COL 5.86 COLON-ALIGNED WIDGET-ID 96
     d_dat-di AT ROW 2.25 COL 31.43 COLON-ALIGNED WIDGET-ID 98
     c-registro AT ROW 2.25 COL 76 COLON-ALIGNED WIDGET-ID 92
     btOK AT ROW 19.83 COL 2
     btSave AT ROW 19.83 COL 13
     btCancel AT ROW 19.83 COL 24
     bt-pre AT ROW 19.83 COL 52 HELP
          "Ocorrˆncia anterior" WIDGET-ID 88
     bt-nex AT ROW 19.83 COL 56.43 HELP
          "Pr¢xima ocorrˆncia" WIDGET-ID 86
     btHelp AT ROW 19.83 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 19.58 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 96.72 BY 20.13
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage3
     cb-idi-tributac-ibsuf AT ROW 2.21 COL 10.57 COLON-ALIGNED HELP
          "C¢digo de tributa‡Æo do IBS UF" NO-LABEL WIDGET-ID 286
     cb-idi-tributac-ibsmun AT ROW 2.21 COL 27.72 COLON-ALIGNED HELP
          "C¢digo de tributa‡Æo do IBS UF" NO-LABEL WIDGET-ID 370
     cb-idi-tributac-cbs AT ROW 2.21 COL 45 COLON-ALIGNED HELP
          "C¢digo de Tributa‡Æo CBS" NO-LABEL WIDGET-ID 284
     cb-idi-tributac-is AT ROW 2.25 COL 75 COLON-ALIGNED HELP
          "C¢digo de Tributa‡Æo CBS" WIDGET-ID 398
     de-val-aliq-ibsuf AT ROW 3.21 COL 10.57 COLON-ALIGNED NO-LABEL WIDGET-ID 302
     de-val-aliq-ibsmun AT ROW 3.21 COL 27.72 COLON-ALIGNED NO-LABEL WIDGET-ID 374
     de-val-aliq-cbs AT ROW 3.21 COL 45 COLON-ALIGNED NO-LABEL WIDGET-ID 300
     de-val-aliq-is AT ROW 3.25 COL 75 COLON-ALIGNED WIDGET-ID 400
     de-perc-reduc-ibsuf AT ROW 4.21 COL 10.57 COLON-ALIGNED NO-LABEL WIDGET-ID 298
     de-perc-reduc-ibsmun AT ROW 4.21 COL 27.72 COLON-ALIGNED NO-LABEL WIDGET-ID 372
     de-perc-reduc-cbs AT ROW 4.21 COL 45 COLON-ALIGNED NO-LABEL WIDGET-ID 296
     de-val-aliq-espec-is AT ROW 4.25 COL 75 COLON-ALIGNED WIDGET-ID 402
     de-base-ibsuf AT ROW 5.21 COL 10.57 COLON-ALIGNED NO-LABEL WIDGET-ID 294
     de-base-ibsmun AT ROW 5.21 COL 27.72 COLON-ALIGNED NO-LABEL WIDGET-ID 380
     de-base-cbs AT ROW 5.21 COL 45 COLON-ALIGNED NO-LABEL WIDGET-ID 292
     de-qtde-is AT ROW 5.25 COL 75 COLON-ALIGNED WIDGET-ID 404
     de-valor-impostos-ibsuf AT ROW 6.21 COL 10.57 COLON-ALIGNED HELP
          "Valor IBS UF" NO-LABEL WIDGET-ID 308
     de-valor-impostos-ibsmun AT ROW 6.21 COL 27.72 COLON-ALIGNED HELP
          "Valor IBS UF" NO-LABEL WIDGET-ID 382
     de-valor-impostos-cbs AT ROW 6.21 COL 45 COLON-ALIGNED HELP
          "Valor CBS" NO-LABEL WIDGET-ID 306
     c-un-trib-is AT ROW 6.25 COL 75 COLON-ALIGNED WIDGET-ID 406
     c-class-trib-ibsuf AT ROW 7.21 COL 10.57 COLON-ALIGNED NO-LABEL WIDGET-ID 278
     c-class-trib-ibsmun AT ROW 7.21 COL 27.72 COLON-ALIGNED NO-LABEL WIDGET-ID 376
     c-class-trib-cbs AT ROW 7.21 COL 45 COLON-ALIGNED NO-LABEL WIDGET-ID 276
     de-base-is AT ROW 7.25 COL 75 COLON-ALIGNED WIDGET-ID 408
     c-cst-ibsuf AT ROW 8.21 COL 10.57 COLON-ALIGNED NO-LABEL WIDGET-ID 282
     c-cst-ibsmun AT ROW 8.21 COL 27.72 COLON-ALIGNED NO-LABEL WIDGET-ID 378
     c-cst-cbs AT ROW 8.21 COL 45 COLON-ALIGNED NO-LABEL WIDGET-ID 280
     de-valor-impostos-is AT ROW 8.25 COL 75 COLON-ALIGNED HELP
          "Valor IBS UF" WIDGET-ID 410
     c-class-trib-is AT ROW 9.25 COL 75 COLON-ALIGNED WIDGET-ID 412
     de-val-aliq-reg-ibsuf AT ROW 9.75 COL 10.57 COLON-ALIGNED NO-LABEL WIDGET-ID 334
     de-val-aliq-reg-ibsmun AT ROW 9.75 COL 27.72 COLON-ALIGNED NO-LABEL WIDGET-ID 390
     de-val-aliq-reg-cbs AT ROW 9.75 COL 45 COLON-ALIGNED NO-LABEL WIDGET-ID 336
     c-cst-is AT ROW 10.25 COL 75 COLON-ALIGNED WIDGET-ID 414
     de-base-reg-ibsuf AT ROW 10.75 COL 10.57 COLON-ALIGNED NO-LABEL WIDGET-ID 338
     de-base-reg-ibsmun AT ROW 10.75 COL 27.72 COLON-ALIGNED NO-LABEL WIDGET-ID 388
     de-base-reg-cbs AT ROW 10.75 COL 45 COLON-ALIGNED NO-LABEL WIDGET-ID 340
     de-valor-impostos-reg-ibsuf AT ROW 11.75 COL 10.57 COLON-ALIGNED HELP
          "Valor IBS UF" NO-LABEL WIDGET-ID 342
     de-valor-impostos-reg-ibsmun AT ROW 11.75 COL 27.72 COLON-ALIGNED HELP
          "Valor IBS UF" NO-LABEL WIDGET-ID 392
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.57 ROW 4.71
         SIZE 94.43 BY 14.33
         FONT 1 WIDGET-ID 700.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage3
     de-valor-impostos-reg-cbs AT ROW 11.75 COL 45 COLON-ALIGNED HELP
          "Valor CBS" NO-LABEL WIDGET-ID 344
     c-class-trib-reg-ibsuf AT ROW 12.75 COL 10.57 COLON-ALIGNED NO-LABEL WIDGET-ID 346
     c-class-trib-reg-ibsmun AT ROW 12.75 COL 27.72 COLON-ALIGNED NO-LABEL WIDGET-ID 384
     c-class-trib-reg-cbs AT ROW 12.75 COL 45 COLON-ALIGNED NO-LABEL WIDGET-ID 348
     c-cst-reg-ibsuf AT ROW 13.75 COL 10.57 COLON-ALIGNED NO-LABEL WIDGET-ID 350
     c-cst-reg-ibsmun AT ROW 13.75 COL 27.72 COLON-ALIGNED NO-LABEL WIDGET-ID 386
     c-cst-reg-cbs AT ROW 13.75 COL 45 COLON-ALIGNED NO-LABEL WIDGET-ID 352
     label-IBSUF AT ROW 1.25 COL 12.57 NO-LABEL WIDGET-ID 320
     label-IBSMun AT ROW 1.25 COL 29.72 NO-LABEL WIDGET-ID 368
     label-CBS AT ROW 1.25 COL 47 NO-LABEL WIDGET-ID 314
     label-IS AT ROW 1.25 COL 65 NO-LABEL WIDGET-ID 396
     label-tributac-2 AT ROW 2.38 COL 2.43 COLON-ALIGNED NO-LABEL WIDGET-ID 326
     label-aliq-2 AT ROW 3.38 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 310
     label-reduc-2 AT ROW 4.38 COL 3.57 COLON-ALIGNED NO-LABEL WIDGET-ID 322
     label-base-calc-2 AT ROW 5.38 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 312
     label-valor-2 AT ROW 6.38 COL 6.29 COLON-ALIGNED NO-LABEL WIDGET-ID 328
     label-class-trib AT ROW 7.38 COL 3.14 COLON-ALIGNED NO-LABEL WIDGET-ID 316
     label-cst AT ROW 8.38 COL 6.86 COLON-ALIGNED NO-LABEL WIDGET-ID 318
     label-aliq-reg AT ROW 9.92 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 354
     label-base-calc-reg AT ROW 10.92 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 356
     label-valor-reg AT ROW 11.92 COL 6.29 COLON-ALIGNED NO-LABEL WIDGET-ID 358
     label-class-trib-reg AT ROW 12.92 COL 3.14 COLON-ALIGNED NO-LABEL WIDGET-ID 360
     label-cst-reg AT ROW 13.92 COL 6.86 COLON-ALIGNED NO-LABEL WIDGET-ID 362
     "Tributa‡Æo Regular" VIEW-AS TEXT
          SIZE 14 BY .54 AT ROW 9.13 COL 3.72 WIDGET-ID 366
     RECT-28 AT ROW 9.42 COL 2.43 WIDGET-ID 364
     RECT-29 AT ROW 2 COL 65 WIDGET-ID 394
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.57 ROW 4.71
         SIZE 94.43 BY 14.33
         FONT 1 WIDGET-ID 700.

DEFINE FRAME fPage2
     cb-idi-tributac-impto-import AT ROW 2.5 COL 8 COLON-ALIGNED HELP
          "Informar a Tributa‡Æo do Imposto de Importa‡Æo" NO-LABEL WIDGET-ID 86
     tt-decla-import-adic-itens.val-aliq-ii AT ROW 2.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 14 FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     cb-suspens-impto-import AT ROW 2.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 130
     tt-decla-import-adic-itens.val-perc-reduc-impto-import AT ROW 2.5 COL 36.43 COLON-ALIGNED NO-LABEL WIDGET-ID 30 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-decla-import-adic-itens.val-base-ii AT ROW 2.5 COL 51.72 COLON-ALIGNED NO-LABEL WIDGET-ID 94
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     d-valor-impostos-ii AT ROW 2.5 COL 66.57 COLON-ALIGNED HELP
          "Valor II" NO-LABEL WIDGET-ID 110
     cb-idi-tributac-ipi AT ROW 3.5 COL 8 COLON-ALIGNED HELP
          "C¢digo de tributa‡Æo do IPI" NO-LABEL WIDGET-ID 88
     tt-decla-import-adic-itens.val-aliq-ipi AT ROW 3.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 18 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     cb-suspens-ipi-import AT ROW 3.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 132
     tt-decla-import-adic-itens.val-perc-reduc-ipi AT ROW 3.5 COL 36.43 COLON-ALIGNED NO-LABEL WIDGET-ID 36 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-decla-import-adic-itens.val-unit-ipi AT ROW 3.5 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 136
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-decla-import-adic-itens.val-base-ipi AT ROW 3.5 COL 51.72 COLON-ALIGNED NO-LABEL WIDGET-ID 98
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     d-valor-impostos-ipi AT ROW 3.5 COL 66.57 COLON-ALIGNED HELP
          "Valor IPI" NO-LABEL WIDGET-ID 112
     cb-idi-tributac-icms AT ROW 4.5 COL 8 COLON-ALIGNED HELP
          "C¢digo de tributa‡Æo do ICMS" NO-LABEL WIDGET-ID 126
     tt-decla-import-adic-itens.val-aliq-icms AT ROW 4.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 10 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     cb-suspens-icms AT ROW 4.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 140
     tt-decla-import-adic-itens.val-perc-reduc-icms AT ROW 4.5 COL 36.43 COLON-ALIGNED NO-LABEL WIDGET-ID 40 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-decla-import-adic-itens.val-base-icms AT ROW 4.5 COL 51.72 COLON-ALIGNED NO-LABEL WIDGET-ID 102
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     d-valor-impostos-icms AT ROW 4.5 COL 66.72 COLON-ALIGNED HELP
          "Valor ICMS" NO-LABEL WIDGET-ID 114
     cb-idi-tributac-pis AT ROW 5.5 COL 8 COLON-ALIGNED HELP
          "C¢digo de Tributa‡Æo PIS" NO-LABEL WIDGET-ID 128
     tt-decla-import-adic-itens.val-aliq-pis AT ROW 5.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 22 FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     cb-suspens-pis AT ROW 5.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 142
     tt-decla-import-adic-itens.val-perc-reduc-pis AT ROW 5.5 COL 36.43 COLON-ALIGNED NO-LABEL WIDGET-ID 34 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-decla-import-adic-itens.val-unit-pis AT ROW 5.5 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 84
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 4.7
         SIZE 88 BY 14.35
         FONT 1 WIDGET-ID 600.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage2
     tt-decla-import-adic-itens.val-base-pis AT ROW 5.5 COL 51.72 COLON-ALIGNED NO-LABEL WIDGET-ID 96
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     d-valor-impostos-pis AT ROW 5.5 COL 66.57 COLON-ALIGNED HELP
          "Valor PIS" NO-LABEL WIDGET-ID 116
     cb-idi-tributac-cofins AT ROW 6.5 COL 8 COLON-ALIGNED HELP
          "C¢digo de Tributa‡Æo COFINS" NO-LABEL WIDGET-ID 124
     tt-decla-import-adic-itens.val-aliq-cofins AT ROW 6.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 26 FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     cb-suspens-cofins AT ROW 6.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 144
     tt-decla-import-adic-itens.val-perc-reduc-cofins AT ROW 6.5 COL 36.43 COLON-ALIGNED NO-LABEL WIDGET-ID 38 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-decla-import-adic-itens.val-unit-cofins AT ROW 6.5 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 138
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-decla-import-adic-itens.val-base-cofins AT ROW 6.5 COL 51.72 COLON-ALIGNED NO-LABEL WIDGET-ID 100
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     d-valor-impostos-cofins AT ROW 6.5 COL 66.57 COLON-ALIGNED HELP
          "Valor Cofins" NO-LABEL WIDGET-ID 106
     de-val-aliq-fcp AT ROW 7.5 COL 21 COLON-ALIGNED HELP
          "Al¡quota Fundo de Combate … Pobreza" NO-LABEL WIDGET-ID 154
     tt-decla-import-adic-itens.val-base-fcp AT ROW 7.5 COL 51.72 COLON-ALIGNED NO-LABEL WIDGET-ID 158
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tt-decla-import-adic-itens.val-fcp AT ROW 7.5 COL 66.57 COLON-ALIGNED NO-LABEL WIDGET-ID 164
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     de-val-aliq-fcp-substto AT ROW 8.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 156
     tt-decla-import-adic-itens.val-base-fcp-substto AT ROW 8.5 COL 51.72 COLON-ALIGNED NO-LABEL WIDGET-ID 160
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tt-decla-import-adic-itens.val-fcp-substto AT ROW 8.5 COL 66.57 COLON-ALIGNED NO-LABEL WIDGET-ID 166
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     tt-decla-import-adic-itens.val-base-icms-substto AT ROW 9.5 COL 51.72 COLON-ALIGNED NO-LABEL WIDGET-ID 134
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tt-decla-import-adic-itens.val-icms-substto AT ROW 9.5 COL 66.57 COLON-ALIGNED NO-LABEL WIDGET-ID 170
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     tt-decla-import-adic-itens.val-base-icms-compltar AT ROW 10.5 COL 51.72 COLON-ALIGNED NO-LABEL WIDGET-ID 162
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tt-decla-import-adic-itens.val-icms-compltar AT ROW 10.5 COL 66.57 COLON-ALIGNED NO-LABEL WIDGET-ID 168
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     label-tributac AT ROW 1.5 COL 9.86 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     label-aliq AT ROW 1.5 COL 21.29 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     label-susp AT ROW 1.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     label-reduc AT ROW 1.5 COL 36.43 COLON-ALIGNED NO-LABEL WIDGET-ID 68
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 4.7
         SIZE 88 BY 14.35
         FONT 1 WIDGET-ID 600.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage2
     label-vl-unit AT ROW 1.5 COL 43.14 COLON-ALIGNED NO-LABEL WIDGET-ID 92
     label-base-calc AT ROW 1.5 COL 54.14 COLON-ALIGNED NO-LABEL WIDGET-ID 118
     label-valor AT ROW 1.5 COL 71.86 COLON-ALIGNED NO-LABEL WIDGET-ID 120
     label-ii AT ROW 2.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     label-ipi AT ROW 3.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     label-icms AT ROW 4.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     label-pis AT ROW 5.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 78
     label-cofins AT ROW 6.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 80
     label-fcp AT ROW 7.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 146
     label-fcp-st AT ROW 8.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 148
     label-icms-st AT ROW 9.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 152
     label-icms-compl AT ROW 10.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 150
     RECT-21 AT ROW 1.25 COL 2 WIDGET-ID 122
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 4.7
         SIZE 88 BY 14.35
         FONT 1 WIDGET-ID 600.

DEFINE FRAME fPage1
     tt-decla-import-adic-itens.cod-item AT ROW 1.5 COL 11.86 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     c-desc-item AT ROW 1.5 COL 30.14 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     d-valor-unit-item AT ROW 2.5 COL 11.86 COLON-ALIGNED HELP
          "Valor Unit rio na Condi‡Æo de Venda" WIDGET-ID 12
          LABEL "Vl Unit"
     d-valor-vucv-item AT ROW 2.5 COL 36.29 COLON-ALIGNED HELP
          "Valor Unit rio na Condi‡Æo de Venda" WIDGET-ID 14
          LABEL "VUCV"
     tt-decla-import-adic-itens.dsl-especif AT ROW 3.5 COL 13.86 NO-LABEL WIDGET-ID 8
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 68.14 BY 7.5
     label-especif AT ROW 3.5 COL 1.57 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     RECT-27 AT ROW 1.25 COL 2 WIDGET-ID 10
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 4.7
         SIZE 88 BY 14.35
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-decla-import T "?" NO-UNDO mgcex decla-import
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-adic T "?" NO-UNDO mgcex decla-import-adic
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-adic-itens T "?" NO-UNDO mgcex decla-import-adic-itens
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
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
         HEIGHT             = 20.17
         WIDTH              = 96.86
         MAX-HEIGHT         = 21.08
         MAX-WIDTH          = 107.14
         VIRTUAL-HEIGHT     = 21.08
         VIRTUAL-WIDTH      = 107.14
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
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON bt-nex IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-pre IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic-itens.num-adic IN FRAME fpage0
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN tt-decla-import-adic-itens.num-di-ems IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic-itens.num-seq IN FRAME fpage0
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic-itens.cod-item IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-valor-unit-item IN FRAME fPage1
   LIKE = Temp-Tables.tt-decla-import-adic-itens.val-vucv EXP-LABEL EXP-SIZE */
/* SETTINGS FOR FILL-IN d-valor-vucv-item IN FRAME fPage1
   LIKE = Temp-Tables.tt-decla-import-adic-itens.val-vucv EXP-LABEL EXP-SIZE */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN label-aliq IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-base-calc IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-cofins IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-fcp IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-fcp-st IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-icms IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-icms-compl IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-icms-st IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-ii IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-ipi IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-pis IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-reduc IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-susp IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-tributac IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-valor IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-vl-unit IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic-itens.val-aliq-cofins IN FRAME fPage2
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic-itens.val-aliq-icms IN FRAME fPage2
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic-itens.val-aliq-ii IN FRAME fPage2
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic-itens.val-aliq-ipi IN FRAME fPage2
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic-itens.val-aliq-pis IN FRAME fPage2
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic-itens.val-perc-reduc-cofins IN FRAME fPage2
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic-itens.val-perc-reduc-icms IN FRAME fPage2
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic-itens.val-perc-reduc-impto-import IN FRAME fPage2
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic-itens.val-perc-reduc-ipi IN FRAME fPage2
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic-itens.val-perc-reduc-pis IN FRAME fPage2
   EXP-FORMAT                                                           */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR FILL-IN c-class-trib-cbs IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-class-trib-ibsmun IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-class-trib-ibsuf IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-class-trib-is IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-class-trib-reg-cbs IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-class-trib-reg-ibsmun IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-class-trib-reg-ibsuf IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cst-cbs IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cst-ibsmun IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cst-ibsuf IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cst-is IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cst-reg-cbs IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cst-reg-ibsmun IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cst-reg-ibsuf IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-trib-is IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-idi-tributac-cbs IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-idi-tributac-ibsmun IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-idi-tributac-ibsuf IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-idi-tributac-is IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-base-cbs IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-base-ibsmun IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-base-ibsuf IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-base-is IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-base-reg-cbs IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-base-reg-ibsmun IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-base-reg-ibsuf IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-perc-reduc-cbs IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-perc-reduc-ibsmun IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-perc-reduc-ibsuf IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-qtde-is IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-aliq-cbs IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-aliq-espec-is IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-aliq-ibsmun IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-aliq-ibsuf IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-aliq-is IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-aliq-reg-cbs IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-aliq-reg-ibsmun IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-aliq-reg-ibsuf IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-impostos-cbs IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-impostos-ibsmun IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-impostos-ibsuf IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-impostos-is IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-impostos-reg-cbs IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-impostos-reg-ibsmun IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-impostos-reg-ibsuf IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-aliq-2 IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-aliq-reg IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-base-calc-2 IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-base-calc-reg IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-CBS IN FRAME fPage3
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN label-class-trib IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-class-trib-reg IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-cst IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-cst-reg IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-IBSMun IN FRAME fPage3
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN label-IBSUF IN FRAME fPage3
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN label-IS IN FRAME fPage3
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN label-reduc-2 IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-tributac-2 IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-valor-2 IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-valor-reg IN FRAME fPage3
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
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


&Scoped-define SELF-NAME bt-nex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nex wMaintenanceNoNavigation
ON CHOOSE OF bt-nex IN FRAME fpage0 /* Next */
DO:
    EMPTY TEMP-TABLE tt-decla-import-adic-itens NO-ERROR.

    assign i-num-linha-browse = i-num-linha-browse + 1.
    if bt-pre:sensitive in frame fPage0 = no then assign bt-pre:sensitive in frame fPage0 = yes.

    RUN repositionRecord IN {&hDBOTable} (INPUT rRowid).
    RUN getNext   IN {&hDBOTable}.
    RUN getRecord IN {&hDBOTable} (OUTPUT TABLE tt-decla-import-adic-itens).
    find first tt-decla-import-adic-itens no-lock no-error.

    run DisplayFields IN THIS-PROCEDURE.
    
    if  i-num-linha-browse = i-nr-registro then do:
        RUN getLast IN {&hDBOTable}.
        assign bt-nex:sensitive in frame fPage0 = no.
    end.

    RETURN "ok".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-pre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pre wMaintenanceNoNavigation
ON CHOOSE OF bt-pre IN FRAME fpage0 /* Prev */
DO:
    EMPTY TEMP-TABLE tt-decla-import-adic-itens NO-ERROR.

    assign i-num-linha-browse = i-num-linha-browse - 1.
    if bt-nex:sensitive in frame fPage0 = no then assign bt-nex:sensitive in frame fPage0 = yes.
    
    RUN repositionRecord IN {&hDBOTable} (INPUT rRowid).
    RUN getPrev   IN {&hDBOTable}.
    RUN getRecord IN {&hDBOTable} (OUTPUT TABLE tt-decla-import-adic-itens).
    find first tt-decla-import-adic-itens no-lock no-error.
    
    RUN DisplayFields IN THIS-PROCEDURE.
    
    if  i-num-linha-browse = 1 then do:
        RUN getFirst IN {&hDBOTable}.
        assign bt-pre:sensitive in frame fPage0 = no.
    end.

    RETURN "ok".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN APPLY "CLOSE":U TO THIS-PROCEDURE.
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-decla-import-adic-itens.cod-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic-itens.cod-item wMaintenanceNoNavigation
ON LEAVE OF tt-decla-import-adic-itens.cod-item IN FRAME fPage1 /* Item */
DO:
    run findCodigo in h-boin172na (input tt-decla-import-adic-itens.cod-item:screen-value in frame fPage1, output c-return).
    if  c-return = "" then do:
        run getCharField in h-boin172na (input "desc-item", output c-descItem-aux).
        assign c-desc-item:screen-value in frame fPage1 = c-descItem-aux.
    end. /* if c-return ... */
    else assign c-desc-item:screen-value in frame fPage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

{maintenancenonavigation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    run piContaRegistro in {&hDBOTable} (input tt-decla-import-adic-itens.num-di-ems,
                                         input tt-decla-import-adic-itens.cdd-siscomex-dts,
                                         input tt-decla-import-adic-itens.num-adic, output i-nr-registro).
    assign c-registro:screen-value in frame fPage0 = string(i-num-linha-browse) + "/" + string(i-nr-registro).

    ASSIGN d-val-unit-vucv = decimal(substring(tt-decla-import-adic-itens.cod-livre-1,4,20)) / 100000000.
    ASSIGN d-valor-unit-item                              = d-val-unit-vucv
           d-valor-unit-item:SCREEN-VALUE IN FRAME fPage1 = string(d-val-unit-vucv)
           d-valor-vucv-item:SCREEN-VALUE IN FRAME fPage1 = string(tt-decla-import-adic-itens.val-vucv-me[1]).

    APPLY 'leave' TO tt-decla-import-adic-itens.cod-item IN FRAME fPage1.

    ASSIGN rRowid = tt-decla-import-adic-itens.r-Rowid.

    RUN pi-trata-combos.
    RUN pi-busca-valor-impostos.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    DISABLE tt-decla-import-adic-itens.num-di-ems c_cod-di-siscomex i_num-seq-retif tt-decla-import-adic-itens.num-adic tt-decla-import-adic-itens.num-seq c_cod-estab d_dat-di WITH FRAME fPage0.
    RUN pi-verifica-docto. /* verifica se h  nota gerada para esta DI. Se houver desabilita todos os campos da tela. */
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    IF NOT l-nt2024002 THEN
        RUN DeleteFolder IN hFolder (INPUT 3).
    ELSE DO:
        DISABLE cb-idi-tributac-ibsuf cb-idi-tributac-ibsmun cb-idi-tributac-cbs cb-idi-tributac-is WITH FRAME fPage3.  
    END.

    RUN SetFolder IN hFolder (INPUT 1).
    
    RUN setConstraintByAdicao IN {&hDBOTable} (INPUT tt-decla-import-adic-itens.num-di-ems, 
                                               INPUT tt-decla-import-adic-itens.num-adic,
                                               INPUT tt-decla-import-adic-itens.cdd-siscomex-dts).
    RUN openQueryStatic       IN {&hDBOTable} (INPUT 'ByAdicao':U).
    
    run piContaRegistro in {&hDBOTable} (input tt-decla-import-adic-itens.num-di-ems,
                                         input tt-decla-import-adic-itens.cdd-siscomex-dts,
                                         input tt-decla-import-adic-itens.num-adic, output i-nr-registro).
    assign c-registro:screen-value in frame fPage0 = string(i-num-linha-browse) + "/" + string(i-nr-registro).
    
    RUN piRetornaDadosDI IN h-bocx390 (INPUT tt-decla-import-adic.num-di-ems,
                                       INPUT tt-decla-import-adic.cdd-siscomex-dts,
                                       OUTPUT c_cod-di-siscomex, 
                                       OUTPUT i_num-seq-retif,  
                                       OUTPUT c_cod-estab,      
                                       OUTPUT d_dat-di).  

    DISP c_cod-di-siscomex i_num-seq-retif c_cod-estab d_dat-di WITH FRAME fPage0.

    if i-num-linha-browse = 1 and i-nr-registro = 1 
    then disable btSave bt-nex bt-pre with frame fPage0.
    else  enable btSave bt-nex bt-pre with frame fPage0.

    DISABLE tt-decla-import-adic-itens.cod-item WITH FRAME fPage1.
    
    DISPLAY label-especif WITH FRAME fPage1.

    DISP label-tributac label-aliq label-susp label-reduc label-vl-unit label-base-calc label-valor label-ii label-ipi label-icms label-pis label-cofins WITH FRAME fPage2.

    RUN pi-trata-combos.
    RUN pi-busca-valor-impostos.
    RUN pi-verifica-docto. /* verifica se h  nota gerada para esta DI. Se houver desabilita todos os campos da tela. */

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao004 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao005 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao006 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao007 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao008 AS CHARACTER NO-UNDO.

        /* Impto-Import */
        ASSIGN cAuxTraducao003 = {cxinc/i01cx402.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao003).
        ASSIGN cb-idi-tributac-impto-import:LIST-ITEM-PAIRS in frame fPage2 = cAuxTraducao003.

        /* IPI */
        ASSIGN cAuxTraducao004 = {cxinc/i01cx402.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao004).
        ASSIGN cb-idi-tributac-ipi:LIST-ITEM-PAIRS in frame fPage2 = cAuxTraducao004.

        /* ICMS */
        ASSIGN cAuxTraducao005 = {cxinc/i02cx402.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao005).
        ASSIGN cb-idi-tributac-icms:LIST-ITEM-PAIRS in frame fPage2 = cAuxTraducao005.

        /* PIS */
        ASSIGN cAuxTraducao006 = {cxinc/i01cx402.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao006).
        ASSIGN cb-idi-tributac-pis:LIST-ITEM-PAIRS in frame fPage2 = cAuxTraducao006.

        /* COFINS */
        ASSIGN cAuxTraducao007 = {cxinc/i01cx402.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao007).
        ASSIGN cb-idi-tributac-cofins:LIST-ITEM-PAIRS in frame fPage2 = cAuxTraducao007.
    &else
        ASSIGN cb-idi-tributac-impto-import:LIST-ITEMS in frame fPage2 = {cxinc/i01cx402.i 03}
               cb-idi-tributac-ipi:LIST-ITEMS          in frame fPage2 = {cxinc/i01cx402.i 03}
               cb-idi-tributac-icms:LIST-ITEMS         in frame fPage2 = {cxinc/i02cx402.i 03}
               cb-idi-tributac-pis:LIST-ITEMS          in frame fPage2 = {cxinc/i01cx402.i 03}
               cb-idi-tributac-cofins:LIST-ITEMS       in frame fPage2 = {cxinc/i01cx402.i 03}.
    &endif

    ASSIGN cb-idi-tributac-ibsuf:LIST-ITEMS  IN FRAME fPage3 = {diinc/i01di628.i 03}
           cb-idi-tributac-ibsmun:LIST-ITEMS IN FRAME fPage3 = {diinc/i01di628.i 03}
           cb-idi-tributac-cbs:LIST-ITEMS    IN FRAME fPage3 = {diinc/i01di628.i 03}
           cb-idi-tributac-is:LIST-ITEMS    IN FRAME fPage3 = {diinc/i01di628.i 03}.  
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    IF NOT VALID-HANDLE (h-boin172na) THEN RUN inbo/boin172na.p PERSISTENT SET h-boin172na. /* itens */
    RUN openQueryStatic IN h-boin172na (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE (h-bocx390) THEN RUN cxbo/bocx390.p PERSISTENT SET h-bocx390. /* despesas */
    RUN openQueryStatic IN h-bocx390 (INPUT "Main":U) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-valor-impostos wMaintenanceNoNavigation 
PROCEDURE pi-busca-valor-impostos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*  valores do combo-box de tributa‡Æo:
        0 - tributado
        1 - Isento
        2 - Outros
        3 - Reduzido
    */
    
    ASSIGN INPUT FRAME fPage2 cb-idi-tributac-impto-import
           INPUT FRAME fPage2 cb-idi-tributac-ipi
           INPUT FRAME fPage2 cb-idi-tributac-pis
           INPUT FRAME fPage2 cb-idi-tributac-cofins
           INPUT FRAME fPage2 cb-idi-tributac-icms
           
           INPUT FRAME fPage2 cb-suspens-impto-import
           INPUT FRAME fPage2 cb-suspens-ipi-import 
           INPUT FRAME fPage2 cb-suspens-pis 
           INPUT FRAME fPage2 cb-suspens-cofins
           INPUT FRAME fPage2 cb-suspens-icms.

    
    /* busca valor do II */
    IF cb-suspens-impto-import <> 'Sim' THEN
        IF {cxinc/i01cx402.i 06 cb-idi-tributac-impto-import} = 1 OR 
           {cxinc/i01cx402.i 06 cb-idi-tributac-impto-import} = 2 OR
           {cxinc/i01cx402.i 06 cb-idi-tributac-impto-import} = 4 THEN
            ASSIGN d-valor-impostos-ii = tt-decla-import-adic-itens.val-ii-db-cr.
        ELSE 
            ASSIGN d-valor-impostos-ii = tt-decla-import-adic-itens.val-ii-outras.
    ELSE
        ASSIGN d-valor-impostos-ii = tt-decla-import-adic-itens.val-ii-nao-tribut.
    /* fim - busca valor do II */

    /* busca valor do IPI */
    IF cb-suspens-ipi-import <> 'Sim' THEN
        IF {cxinc/i01cx402.i 06 cb-idi-tributac-ipi} = 1 OR 
           {cxinc/i01cx402.i 06 cb-idi-tributac-ipi} = 2 OR
           {cxinc/i01cx402.i 06 cb-idi-tributac-ipi} = 4 THEN
            ASSIGN d-valor-impostos-ipi = tt-decla-import-adic-itens.val-ipi-db-cr.
        ELSE 
            ASSIGN d-valor-impostos-ipi = tt-decla-import-adic-itens.val-ipi-outras.
    ELSE
        ASSIGN d-valor-impostos-ipi = tt-decla-import-adic-itens.val-ipi-nao-tribut.
    /* fim - busca valor do IPI */

    /* busca valor do ICMS */
    IF cb-suspens-icms <> 'Sim' THEN
        IF {cxinc/i01cx402.i 06 cb-idi-tributac-icms} = 1 OR 
           {cxinc/i01cx402.i 06 cb-idi-tributac-icms} = 2 OR
           {cxinc/i01cx402.i 06 cb-idi-tributac-icms} = 4 THEN
            ASSIGN d-valor-impostos-icms = tt-decla-import-adic-itens.val-icms-db-cr.
        ELSE 
            ASSIGN d-valor-impostos-icms = tt-decla-import-adic-itens.val-icms-outras.
    ELSE
        ASSIGN d-valor-impostos-icms = tt-decla-import-adic-itens.val-icms-nao-tribut.
    /* fim - busca valor do ICMS */

    /* busca valor do PIS */
    IF cb-suspens-pis <> 'Sim' THEN
        IF {cxinc/i01cx402.i 06 cb-idi-tributac-pis} = 1 OR 
           {cxinc/i01cx402.i 06 cb-idi-tributac-pis} = 2 OR
           {cxinc/i01cx402.i 06 cb-idi-tributac-pis} = 4 THEN
            ASSIGN d-valor-impostos-pis = tt-decla-import-adic-itens.val-pis-db-cr.
        ELSE 
            ASSIGN d-valor-impostos-pis = tt-decla-import-adic-itens.val-pis-outras.
    ELSE
        ASSIGN d-valor-impostos-pis = tt-decla-import-adic-itens.val-pis-nao-tribut.
    /* fim - busca valor do PIS */

    /* busca valor do COFINS */
    IF cb-suspens-cofins <> 'Sim' THEN
        IF {cxinc/i01cx402.i 06 cb-idi-tributac-cofins} = 1 OR 
           {cxinc/i01cx402.i 06 cb-idi-tributac-cofins} = 2 OR
           {cxinc/i01cx402.i 06 cb-idi-tributac-cofins} = 4 THEN
            ASSIGN d-valor-impostos-cofins = tt-decla-import-adic-itens.val-cofins-db-cr.
        ELSE 
            ASSIGN d-valor-impostos-cofins = tt-decla-import-adic-itens.val-cofins-outras.
    ELSE
        ASSIGN d-valor-impostos-cofins = tt-decla-import-adic-itens.val-cofins-nao-tribut.
    /* fim - busca valor do COFINS */

    ASSIGN de-val-aliq-fcp         = tt-decla-import-adic-itens.val-aliq-fcp
           de-val-aliq-fcp-substto = tt-decla-import-adic-itens.val-aliq-fcp-substto.

    DISP d-valor-impostos-ii
         d-valor-impostos-ipi
         d-valor-impostos-icms
         d-valor-impostos-pis
         d-valor-impostos-cofins
         de-val-aliq-fcp        
         de-val-aliq-fcp-substto
        WITH FRAME fPage2.

    DISABLE cb-idi-tributac-impto-import tt-decla-import-adic-itens.val-aliq-ii
            cb-suspens-impto-import cb-suspens-icms cb-suspens-pis cb-suspens-cofins
            tt-decla-import-adic-itens.val-perc-reduc-impto-import tt-decla-import-adic-itens.val-base-ii 
            d-valor-impostos-ii cb-idi-tributac-ipi tt-decla-import-adic-itens.val-aliq-ipi cb-suspens-ipi-import 
            tt-decla-import-adic-itens.val-perc-reduc-ipi tt-decla-import-adic-itens.val-unit-ipi tt-decla-import-adic-itens.val-base-ipi 
            d-valor-impostos-ipi cb-idi-tributac-icms tt-decla-import-adic-itens.val-aliq-icms tt-decla-import-adic-itens.val-perc-reduc-icms 
            tt-decla-import-adic-itens.val-base-icms d-valor-impostos-icms cb-idi-tributac-pis tt-decla-import-adic-itens.val-aliq-pis 
            tt-decla-import-adic-itens.val-perc-reduc-pis tt-decla-import-adic-itens.val-unit-pis tt-decla-import-adic-itens.val-base-pis 
            d-valor-impostos-pis cb-idi-tributac-cofins tt-decla-import-adic-itens.val-aliq-cofins tt-decla-import-adic-itens.val-perc-reduc-cofins 
            tt-decla-import-adic-itens.val-unit-cofins tt-decla-import-adic-itens.val-base-cofins d-valor-impostos-cofins
            de-val-aliq-fcp tt-decla-import-adic-itens.val-base-fcp tt-decla-import-adic-itens.val-fcp
            de-val-aliq-fcp-substto tt-decla-import-adic-itens.val-base-fcp-substto tt-decla-import-adic-itens.val-fcp-substto
            tt-decla-import-adic-itens.val-base-icms-substto tt-decla-import-adic-itens.val-icms-substto
            tt-decla-import-adic-itens.val-base-icms-compltar tt-decla-import-adic-itens.val-icms-compltar
        WITH FRAME fPage2. 

    IF l-nt2024002 THEN DO:
        ASSIGN de-val-aliq-ibsuf        = 0
               de-val-aliq-ibsmun       = 0
               de-val-aliq-cbs          = 0
               de-perc-reduc-ibsuf      = 0
               de-perc-reduc-ibsmun     = 0
               de-perc-reduc-cbs        = 0
               de-base-ibsuf            = 0
               de-base-ibsmun           = 0
               de-base-cbs              = 0
               de-valor-impostos-ibsuf  = 0
               de-valor-impostos-ibsmun = 0
               de-valor-impostos-cbs    = 0
               c-cst-ibsuf              = ""
               c-cst-ibsmun             = ""
               c-cst-cbs                = ""
               c-class-trib-ibsuf       = ""
               c-class-trib-ibsmun      = ""
               c-class-trib-cbs         = ""
               i-trib-ibsuf             = 1
               i-trib-ibsmun            = 1
               i-trib-cbs               = 1
               de-val-aliq-reg-ibsuf        = 0
               de-val-aliq-reg-ibsmun       = 0
               de-val-aliq-reg-cbs          = 0
               de-base-reg-ibsuf            = 0
               de-base-reg-ibsmun           = 0
               de-base-reg-cbs              = 0
               de-valor-impostos-reg-ibsuf  = 0
               de-valor-impostos-reg-ibsmun = 0
               de-valor-impostos-reg-cbs    = 0
               c-cst-reg-ibsuf              = ""
               c-cst-reg-ibsmun             = ""
               c-cst-reg-cbs                = ""
               c-class-trib-reg-ibsuf       = ""
               c-class-trib-reg-ibsmun      = ""
               c-class-trib-reg-cbs         = "".
               
        FOR EACH decla-imp-adic-it-trib NO-LOCK
           WHERE decla-imp-adic-it-trib.num-di-ems       = tt-decla-import-adic-itens.num-di-ems
             AND decla-imp-adic-it-trib.num-adic         = tt-decla-import-adic-itens.num-adic
             AND decla-imp-adic-it-trib.cdd-siscomex-dts = tt-decla-import-adic-itens.cdd-siscomex-dts
             and decla-imp-adic-it-trib.num-seq          = tt-decla-import-adic-itens.num-seq:
            
            CASE decla-imp-adic-it-trib.nom-trib:
                WHEN "IBSUF":U THEN DO:
                    CASE decla-imp-adic-it-trib.cod-campo:
                        WHEN "COD-TRIB":U THEN
                            ASSIGN i-trib-ibsuf = int(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "ALIQUOTA":U THEN
                            ASSIGN de-val-aliq-ibsuf = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "ALIQ-RED":U THEN
                            ASSIGN de-perc-reduc-ibsuf = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "BASE":U THEN
                            ASSIGN de-base-ibsuf = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "VALOR":U OR 
                        WHEN "OUTROS":U THEN
                            ASSIGN de-valor-impostos-ibsuf = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "CST":U THEN
                            ASSIGN c-cst-ibsuf = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "C-CLASS-TRIB":U THEN
                            ASSIGN c-class-trib-ibsuf = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "ALIQ-EFETIVA-REG":U THEN
                            ASSIGN de-val-aliq-reg-ibsuf = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "BASE-REG":U THEN
                            ASSIGN de-base-reg-ibsuf = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "VALOR-REG":U THEN
                            ASSIGN de-valor-impostos-reg-ibsuf = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "CST-REG":U THEN
                            ASSIGN c-cst-reg-ibsuf = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "C-CLASS-TRIB-REG":U THEN
                            ASSIGN c-class-trib-reg-ibsuf = decla-imp-adic-it-trib.cod-conteudo.
                    END CASE.
                END.
                WHEN "IBSMUN":U THEN DO:
                    CASE decla-imp-adic-it-trib.cod-campo:
                        WHEN "COD-TRIB":U THEN
                            ASSIGN i-trib-ibsmun = int(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "ALIQUOTA":U THEN
                            ASSIGN de-val-aliq-ibsmun = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "ALIQ-RED":U THEN
                            ASSIGN de-perc-reduc-ibsmun = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "BASE":U THEN
                            ASSIGN de-base-ibsmun = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "VALOR":U OR 
                        WHEN "OUTROS":U THEN
                            ASSIGN de-valor-impostos-ibsmun = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "CST":U THEN
                            ASSIGN c-cst-ibsmun = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "C-CLASS-TRIB":U THEN
                            ASSIGN c-class-trib-ibsmun = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "ALIQ-EFETIVA-REG":U THEN
                            ASSIGN de-val-aliq-reg-ibsmun = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "BASE-REG":U THEN
                            ASSIGN de-base-reg-ibsmun = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "VALOR-REG":U THEN
                            ASSIGN de-valor-impostos-reg-ibsmun = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "CST-REG":U THEN
                            ASSIGN c-cst-reg-ibsmun = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "C-CLASS-TRIB-REG":U THEN
                            ASSIGN c-class-trib-reg-ibsmun = decla-imp-adic-it-trib.cod-conteudo.
                    END CASE.
                END.
                WHEN "CBS":U THEN DO:
                    CASE decla-imp-adic-it-trib.cod-campo:
                        WHEN "COD-TRIB":U THEN
                            ASSIGN i-trib-cbs = int(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "ALIQUOTA":U THEN
                            ASSIGN de-val-aliq-cbs = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "ALIQ-RED":U THEN
                            ASSIGN de-perc-reduc-cbs = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "BASE":U THEN
                            ASSIGN de-base-cbs = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "VALOR":U OR 
                        WHEN "OUTROS":U THEN
                            ASSIGN de-valor-impostos-cbs = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "CST":U THEN
                            ASSIGN c-cst-cbs = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "C-CLASS-TRIB":U THEN
                            ASSIGN c-class-trib-cbs = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "ALIQ-EFETIVA-REG":U THEN
                            ASSIGN de-val-aliq-reg-cbs = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "BASE-REG":U THEN
                            ASSIGN de-base-reg-cbs = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "VALOR-REG":U THEN
                            ASSIGN de-valor-impostos-reg-cbs = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "CST-REG":U THEN
                            ASSIGN c-cst-reg-cbs = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "C-CLASS-TRIB-REG":U THEN
                            ASSIGN c-class-trib-reg-cbs = decla-imp-adic-it-trib.cod-conteudo.
                    END CASE.
                END.
                WHEN "IS":U THEN DO:
                    CASE decla-imp-adic-it-trib.cod-campo:
                        WHEN "C-CLASS-TRIB":U THEN
                            ASSIGN c-class-trib-is = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "CST":U THEN
                            ASSIGN c-cst-is = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "COD-TRIB":U THEN DO:
                            ASSIGN cb-idi-tributac-is:SCREEN-VALUE IN FRAME fPage3 = {diinc/i01di628.i 04 INT(decla-imp-adic-it-trib.cod-conteudo)}.
                            IF cb-idi-tributac-is:SCREEN-VALUE IN FRAME fPage3 = ? OR cb-idi-tributac-is:SCREEN-VALUE IN FRAME fPage3 = "" THEN
                            DO:
                               ASSIGN cb-idi-tributac-is:SCREEN-VALUE IN FRAME fPage3 = "Tributado". 
                            END.
                        END.
                        WHEN "ALIQUOTA":U THEN
                            ASSIGN de-val-aliq-is = dec(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "ALIQ-ESPEC-UN":U THEN
                            ASSIGN de-val-aliq-espec-is = dec(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "QTDE-TRIBUT":U THEN
                            ASSIGN de-qtde-is = dec(decla-imp-adic-it-trib.cod-conteudo).  
                        WHEN "UN-TRIBUT":U THEN
                            ASSIGN c-un-trib-is = decla-imp-adic-it-trib.cod-conteudo.
                        WHEN "BASE":U THEN
                            ASSIGN de-base-is = DEC(decla-imp-adic-it-trib.cod-conteudo).
                        WHEN "VALOR":U OR 
                        WHEN "OUTROS":U THEN
                            ASSIGN de-valor-impostos-is = DEC(decla-imp-adic-it-trib.cod-conteudo).
                    END CASE.
                END.
            END CASE.
        END.
        
        ASSIGN cb-idi-tributac-ibsuf:SCREEN-VALUE  IN FRAME fPage3 = {diinc/i01di628.i 04 i-trib-ibsuf}
               cb-idi-tributac-ibsmun:SCREEN-VALUE IN FRAME fPage3 = {diinc/i01di628.i 04 i-trib-ibsuf}
               cb-idi-tributac-cbs:SCREEN-VALUE    IN FRAME fPage3 = {diinc/i01di628.i 04 i-trib-cbs}.
        
        DISP de-val-aliq-ibsuf           de-val-aliq-ibsmun           de-val-aliq-cbs            de-val-aliq-is
             de-perc-reduc-ibsuf         de-perc-reduc-ibsmun         de-perc-reduc-cbs          de-val-aliq-espec-is
             de-base-ibsuf               de-base-ibsmun               de-base-cbs                de-qtde-is
             de-valor-impostos-ibsuf     de-valor-impostos-ibsmun     de-valor-impostos-cbs      de-base-is
             c-cst-ibsuf                 c-cst-ibsmun                 c-cst-cbs                  de-valor-impostos-is
             c-class-trib-ibsuf          c-class-trib-ibsmun          c-class-trib-cbs           c-class-trib-is
             de-val-aliq-reg-ibsuf       de-val-aliq-reg-ibsmun       de-val-aliq-reg-cbs        c-cst-is
             de-base-reg-ibsuf           de-base-reg-ibsmun           de-base-reg-cbs            c-un-trib-is
             de-valor-impostos-reg-ibsuf de-valor-impostos-reg-ibsmun de-valor-impostos-reg-cbs
             c-cst-reg-ibsuf             c-cst-reg-ibsmun             c-cst-reg-cbs
             c-class-trib-reg-ibsuf      c-class-trib-reg-ibsmun      c-class-trib-reg-cbs WITH FRAME fPage3.
             
        DISABLE cb-idi-tributac-ibsuf cb-idi-tributac-ibsmun cb-idi-tributac-cbs cb-idi-tributac-is WITH FRAME fPage3.  
    END.
              
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-decla-imp-adic-it-trib wMaintenanceNoNavigation 
PROCEDURE pi-grava-decla-imp-adic-it-trib :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nom-trib      AS CHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-campo     AS CHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-conteudo  AS CHAR  NO-UNDO.

    FIND FIRST decla-imp-adic-it-trib
         WHERE decla-imp-adic-it-trib.num-di-ems       = tt-decla-import-adic-itens.num-di-ems
           AND decla-imp-adic-it-trib.num-adic         = tt-decla-import-adic-itens.num-adic
           AND decla-imp-adic-it-trib.cdd-siscomex-dts = tt-decla-import-adic-itens.cdd-siscomex-dts
           AND decla-imp-adic-it-trib.nom-trib         = p-nom-trib 
           AND decla-imp-adic-it-trib.cod-campo        = p-cod-campo EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAIL decla-imp-adic-it-trib THEN DO:
        CREATE decla-imp-adic-it-trib.
        ASSIGN decla-imp-adic-it-trib.num-di-ems       = tt-decla-import-adic-itens.num-di-ems
               decla-imp-adic-it-trib.num-adic         = tt-decla-import-adic-itens.num-adic
               decla-imp-adic-it-trib.cdd-siscomex-dts = tt-decla-import-adic-itens.cdd-siscomex-dts
               decla-imp-adic-it-trib.nom-trib         = p-nom-trib 
               decla-imp-adic-it-trib.cod-campo        = p-cod-campo.
    END.
    ASSIGN decla-imp-adic-it-trib.cod-conteudo = p-cod-conteudo.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-linha-browse wMaintenanceNoNavigation 
PROCEDURE pi-seta-linha-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-num-linha-browse AS INTEGER   NO-UNDO.

assign i-num-linha-browse = p-num-linha-browse.

return "ok":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-combos wMaintenanceNoNavigation 
PROCEDURE pi-trata-combos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN cb-idi-tributac-icms:screen-value         in frame fPage2 = {cxinc/i02cx402.i 04 tt-decla-import-adic.idi-tributac-icms}
           cb-idi-tributac-ipi:screen-value          in frame fPage2 = {cxinc/i01cx402.i 04 tt-decla-import-adic.idi-tributac-ipi}
           cb-idi-tributac-pis:screen-value          in frame fPage2 = {cxinc/i01cx402.i 04 tt-decla-import-adic.idi-tributac-pis}
           cb-idi-tributac-cofins:screen-value       in frame fPage2 = {cxinc/i01cx402.i 04 tt-decla-import-adic.idi-tributac-cofins}
           cb-idi-tributac-impto-import:screen-value in frame fPage2 = {cxinc/i01cx402.i 04 tt-decla-import-adic.idi-tributac-impto-import}
           cb-suspens-impto-import:screen-value      in frame fPage2 = if tt-decla-import-adic.log-suspens-impto-import then 'Sim' else 'NÆo'
           cb-suspens-ipi-import:screen-value        in frame fPage2 = if tt-decla-import-adic.log-suspens-ipi-import   then 'Sim' else 'NÆo'
           .
    &if '{&bf_mat_versao_ems}' >= '2.09' &then
        ASSIGN cb-suspens-icms:SCREEN-VALUE IN FRAME   fPage2 = IF tt-decla-import-adic.log-suspens-icms   THEN 'Sim' ELSE 'NÆo'
               cb-suspens-pis:SCREEN-VALUE IN FRAME    fPage2 = IF tt-decla-import-adic.log-suspens-pis    THEN 'Sim' ELSE 'NÆo'
               cb-suspens-cofins:SCREEN-VALUE IN FRAME fPage2 = IF tt-decla-import-adic.log-suspens-cofins THEN 'Sim' ELSE 'NÆo'.
    &else
        ASSIGN cb-suspens-icms:SCREEN-VALUE IN FRAME   fPage2 = IF SUBSTRING(tt-decla-import-adic.cod-livre-1,1,1) = '1' THEN 'Sim' ELSE 'NÆo'
               cb-suspens-pis:SCREEN-VALUE IN FRAME    fPage2 = IF SUBSTRING(tt-decla-import-adic.cod-livre-1,2,1) = '1' THEN 'Sim' ELSE 'NÆo'
               cb-suspens-cofins:SCREEN-VALUE IN FRAME fPage2 = IF SUBSTRING(tt-decla-import-adic.cod-livre-1,3,1) = '1' THEN 'Sim' ELSE 'NÆo'.
    &endif
    
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-docto wMaintenanceNoNavigation 
PROCEDURE pi-verifica-docto :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    IF  NOT VALID-HANDLE(h-bocx383a) THEN
        RUN cxbo/bocx383a.p PERSISTENT SET h-bocx383a.
    
    RUN piDoctoRecebimento IN h-bocx383a(INPUT c_cod-di-siscomex, OUTPUT l-encontrou).

    IF  l-encontrou THEN DO:
        DISABLE tt-decla-import-adic-itens.cod-item 
                tt-decla-import-adic-itens.dsl-especif 
                d-valor-unit-item
            WITH FRAME fPage1.
    END.

    IF VALID-HANDLE (h-bocx383a) THEN DO: 
        DELETE PROCEDURE h-bocx383a.
        ASSIGN h-bocx383a = ?.
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
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

