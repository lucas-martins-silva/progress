&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decla-import NO-UNDO LIKE decla-import
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-duimp-docto NO-UNDO LIKE duimp-docto
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-duimp-siscomex NO-UNDO LIKE duimp-siscomex
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-siscomex-chave NO-UNDO LIKE siscomex-chave
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
{include/i-prgvrs.i IM7000A 2.00.00.002} /* 31/03/2026 17:41:31 */

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM7000A MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           IM7000A
&GLOBAL-DEFINE Version           2.00.00.002

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       0

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-duimp-docto
&GLOBAL-DEFINE hDBOTable         h-bocx00489
&GLOBAL-DEFINE DBOTable          duimp-docto

&GLOBAL-DEFINE ttParent          tt-decla-import
&GLOBAL-DEFINE DBOParentTable    decla-import

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields de-cod-duimp-dts c-cod-duimp-siscomex

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE l-result      AS LOGICAL NO-UNDO.
DEFINE VARIABLE iRowsReturned AS INTEGER NO-UNDO.
DEFINE VARIABLE i-tipo-docto  AS INTEGER NO-UNDO.
DEFINE VARIABLE i-campo       AS INTEGER NO-UNDO.
DEFINE VARIABLE i-aux         AS INTEGER NO-UNDO.
DEFINE VARIABLE c-formato     AS CHAR    NO-UNDO.
DEFINE VARIABLE c-label       AS CHAR    NO-UNDO.
DEFINE VARIABLE c-help        AS CHAR    NO-UNDO.
DEFINE VARIABLE i-seq-docto   AS INTEGER NO-UNDO.
DEFINE VARIABLE c-lista       AS CHAR    NO-UNDO.
DEFINE VARIABLE c-valor-inf   AS CHAR    NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx00499   AS HANDLE NO-UNDO.

/* Local Temp-Tables Definitions --- */
{cxbo/bocx00489.i tt-duimp-docto-aux}
{cxbo/bocx00489.i tt-duimp-docto-aux2}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar de-cod-duimp-dts ~
c-cod-duimp-siscomex cb-tipo-docto c-chave-lista cb-lista c-chave-1 ~
c-valor-1 c-chave-17 c-valor-17 c-chave-2 c-valor-2 c-chave-18 c-valor-18 ~
c-chave-3 c-valor-3 c-chave-19 c-valor-19 c-chave-4 c-valor-4 c-chave-20 ~
c-valor-20 c-chave-5 c-valor-5 c-chave-21 c-valor-21 c-chave-6 c-valor-6 ~
c-chave-22 c-valor-22 c-chave-7 c-valor-7 c-chave-23 c-valor-23 c-chave-8 ~
c-valor-8 c-chave-24 c-valor-24 c-chave-9 c-valor-9 c-chave-25 c-valor-25 ~
c-chave-10 c-valor-10 c-chave-26 c-valor-26 c-chave-11 c-valor-11 ~
c-chave-27 c-valor-27 c-chave-12 c-valor-12 c-chave-28 c-valor-28 ~
c-chave-13 c-valor-13 c-chave-29 c-valor-29 c-chave-14 c-valor-14 ~
c-chave-30 c-valor-30 c-chave-15 c-valor-15 c-chave-31 c-valor-31 ~
c-chave-16 c-valor-16 c-chave-32 c-valor-32 btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-OBJECTS de-cod-duimp-dts c-cod-duimp-siscomex ~
cb-tipo-docto c-chave-lista cb-lista c-chave-1 c-valor-1 c-chave-17 ~
c-valor-17 c-chave-2 c-valor-2 c-chave-18 c-valor-18 c-chave-3 c-valor-3 ~
c-chave-19 c-valor-19 c-chave-4 c-valor-4 c-chave-20 c-valor-20 c-chave-5 ~
c-valor-5 c-chave-21 c-valor-21 c-chave-6 c-valor-6 c-chave-22 c-valor-22 ~
c-chave-7 c-valor-7 c-chave-23 c-valor-23 c-chave-8 c-valor-8 c-chave-24 ~
c-valor-24 c-chave-9 c-valor-9 c-chave-25 c-valor-25 c-chave-10 c-valor-10 ~
c-chave-26 c-valor-26 c-chave-11 c-valor-11 c-chave-27 c-valor-27 ~
c-chave-12 c-valor-12 c-chave-28 c-valor-28 c-chave-13 c-valor-13 ~
c-chave-29 c-valor-29 c-chave-14 c-valor-14 c-chave-30 c-valor-30 ~
c-chave-15 c-valor-15 c-chave-31 c-valor-31 c-chave-16 c-valor-16 ~
c-chave-32 c-valor-32 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
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

DEFINE VARIABLE cb-lista AS INTEGER FORMAT ">>>9":U INITIAL 0 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "-",0
     DROP-DOWN-LIST
     SIZE 99 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-docto AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "Selecione um Documento",0
     DROP-DOWN-LIST
     SIZE 70 BY 1 NO-UNDO.

DEFINE VARIABLE c-chave-1 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-10 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-11 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-12 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-13 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-14 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-15 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-16 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-17 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-18 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-19 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-2 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-20 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-21 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-22 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-23 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-24 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-25 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-26 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-27 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-28 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-29 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-3 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-30 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-31 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-32 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-4 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-5 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-6 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-7 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-8 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-9 AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-chave-lista AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-duimp-siscomex AS CHARACTER FORMAT "x(15)" 
     LABEL "DUIMP Siscomex" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE c-valor-1 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-10 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-11 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-12 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-13 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-14 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-15 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-16 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-17 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-18 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-19 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-2 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-20 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-21 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-22 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-23 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-24 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-25 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-26 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-27 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-28 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-29 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-3 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-30 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-31 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-32 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-4 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-5 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-6 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-7 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-8 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-valor-9 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE de-cod-duimp-dts AS DECIMAL FORMAT ">>>>>>>>>>>>>>>9" INITIAL 0 
     LABEL "N£mero Interno DUIMP" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 115 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 115 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     de-cod-duimp-dts AT ROW 1.17 COL 21.14 COLON-ALIGNED WIDGET-ID 166
     c-cod-duimp-siscomex AT ROW 1.17 COL 76.14 COLON-ALIGNED WIDGET-ID 4
     cb-tipo-docto AT ROW 2.17 COL 21.14 COLON-ALIGNED WIDGET-ID 158
     c-chave-lista AT ROW 3.54 COL 2 NO-LABEL WIDGET-ID 154
     cb-lista AT ROW 3.54 COL 13.29 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     c-chave-1 AT ROW 4.54 COL 2 NO-LABEL WIDGET-ID 22
     c-valor-1 AT ROW 4.54 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     c-chave-17 AT ROW 4.54 COL 59.14 NO-LABEL WIDGET-ID 86
     c-valor-17 AT ROW 4.54 COL 82.43 COLON-ALIGNED NO-LABEL WIDGET-ID 88
     c-chave-2 AT ROW 5.54 COL 2 NO-LABEL WIDGET-ID 24
     c-valor-2 AT ROW 5.54 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     c-chave-18 AT ROW 5.54 COL 59.14 NO-LABEL WIDGET-ID 90
     c-valor-18 AT ROW 5.54 COL 82.43 COLON-ALIGNED NO-LABEL WIDGET-ID 122
     c-chave-3 AT ROW 6.54 COL 2 NO-LABEL WIDGET-ID 30
     c-valor-3 AT ROW 6.54 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     c-chave-19 AT ROW 6.54 COL 59.14 NO-LABEL WIDGET-ID 106
     c-valor-19 AT ROW 6.54 COL 82.43 COLON-ALIGNED NO-LABEL WIDGET-ID 138
     c-chave-4 AT ROW 7.54 COL 2 NO-LABEL WIDGET-ID 34
     c-valor-4 AT ROW 7.54 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     c-chave-20 AT ROW 7.54 COL 59.14 NO-LABEL WIDGET-ID 108
     c-valor-20 AT ROW 7.54 COL 82.43 COLON-ALIGNED NO-LABEL WIDGET-ID 140
     c-chave-5 AT ROW 8.54 COL 2 NO-LABEL WIDGET-ID 38
     c-valor-5 AT ROW 8.54 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     c-chave-21 AT ROW 8.54 COL 59.14 NO-LABEL WIDGET-ID 110
     c-valor-21 AT ROW 8.54 COL 82.43 COLON-ALIGNED NO-LABEL WIDGET-ID 142
     c-chave-6 AT ROW 9.54 COL 2 NO-LABEL WIDGET-ID 42
     c-valor-6 AT ROW 9.54 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     c-chave-22 AT ROW 9.54 COL 59.14 NO-LABEL WIDGET-ID 112
     c-valor-22 AT ROW 9.54 COL 82.43 COLON-ALIGNED NO-LABEL WIDGET-ID 144
     c-chave-7 AT ROW 10.54 COL 2 NO-LABEL WIDGET-ID 46
     c-valor-7 AT ROW 10.54 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     c-chave-23 AT ROW 10.54 COL 59.14 NO-LABEL WIDGET-ID 114
     c-valor-23 AT ROW 10.54 COL 82.43 COLON-ALIGNED NO-LABEL WIDGET-ID 146
     c-chave-8 AT ROW 11.54 COL 2 NO-LABEL WIDGET-ID 50
     c-valor-8 AT ROW 11.54 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     c-chave-24 AT ROW 11.54 COL 59.14 NO-LABEL WIDGET-ID 116
     c-valor-24 AT ROW 11.54 COL 82.43 COLON-ALIGNED NO-LABEL WIDGET-ID 148
     c-chave-9 AT ROW 12.54 COL 2 NO-LABEL WIDGET-ID 54
     c-valor-9 AT ROW 12.54 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     c-chave-25 AT ROW 12.54 COL 59.14 NO-LABEL WIDGET-ID 118
     c-valor-25 AT ROW 12.54 COL 82.43 COLON-ALIGNED NO-LABEL WIDGET-ID 150
     c-chave-10 AT ROW 13.54 COL 2 NO-LABEL WIDGET-ID 58
     c-valor-10 AT ROW 13.54 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     c-chave-26 AT ROW 13.54 COL 59.14 NO-LABEL WIDGET-ID 120
     c-valor-26 AT ROW 13.54 COL 82.43 COLON-ALIGNED NO-LABEL WIDGET-ID 152
     c-chave-11 AT ROW 14.54 COL 2 NO-LABEL WIDGET-ID 62
     c-valor-11 AT ROW 14.54 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     c-chave-27 AT ROW 14.54 COL 59.14 NO-LABEL WIDGET-ID 92
     c-valor-27 AT ROW 14.54 COL 82.43 COLON-ALIGNED NO-LABEL WIDGET-ID 124
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 115 BY 21.46
         FONT 1 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     c-chave-12 AT ROW 15.54 COL 2 NO-LABEL WIDGET-ID 66
     c-valor-12 AT ROW 15.54 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     c-chave-28 AT ROW 15.54 COL 59.14 NO-LABEL WIDGET-ID 94
     c-valor-28 AT ROW 15.54 COL 82.43 COLON-ALIGNED NO-LABEL WIDGET-ID 126
     c-chave-13 AT ROW 16.54 COL 2 NO-LABEL WIDGET-ID 70
     c-valor-13 AT ROW 16.54 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     c-chave-29 AT ROW 16.54 COL 59.14 NO-LABEL WIDGET-ID 96
     c-valor-29 AT ROW 16.54 COL 82.43 COLON-ALIGNED NO-LABEL WIDGET-ID 128
     c-chave-14 AT ROW 17.54 COL 2 NO-LABEL WIDGET-ID 74
     c-valor-14 AT ROW 17.54 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     c-chave-30 AT ROW 17.54 COL 59.14 NO-LABEL WIDGET-ID 98
     c-valor-30 AT ROW 17.54 COL 82.43 COLON-ALIGNED NO-LABEL WIDGET-ID 130
     c-chave-15 AT ROW 18.54 COL 2 NO-LABEL WIDGET-ID 78
     c-valor-15 AT ROW 18.54 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 80
     c-chave-31 AT ROW 18.54 COL 59.14 NO-LABEL WIDGET-ID 100
     c-valor-31 AT ROW 18.54 COL 82.43 COLON-ALIGNED NO-LABEL WIDGET-ID 132
     c-chave-16 AT ROW 19.54 COL 2 NO-LABEL WIDGET-ID 82
     c-valor-16 AT ROW 19.54 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 84
     c-chave-32 AT ROW 19.54 COL 59.14 NO-LABEL WIDGET-ID 102
     c-valor-32 AT ROW 19.54 COL 82.43 COLON-ALIGNED NO-LABEL WIDGET-ID 134
     btOK AT ROW 21.04 COL 2
     btSave AT ROW 21.04 COL 13
     btCancel AT ROW 21.04 COL 24
     btHelp AT ROW 21.04 COL 104.57
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 20.79 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 115 BY 21.46
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
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-duimp-docto T "?" NO-UNDO mgcex duimp-docto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-duimp-siscomex T "?" NO-UNDO mgcex duimp-siscomex
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-siscomex-chave T "?" NO-UNDO mgcex siscomex-chave
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
         TITLE              = "Manuten‡Æo de Documentos"
         HEIGHT             = 21.46
         WIDTH              = 115
         MAX-HEIGHT         = 21.46
         MAX-WIDTH          = 115
         VIRTUAL-HEIGHT     = 21.46
         VIRTUAL-WIDTH      = 115
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-chave-1 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-10 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-11 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-12 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-13 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-14 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-15 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-16 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-17 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-18 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-19 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-2 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-20 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-21 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-22 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-23 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-24 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-25 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-26 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-27 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-28 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-29 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-3 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-30 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-31 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-32 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-4 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-5 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-6 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-7 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-8 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-9 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-chave-lista IN FRAME fpage0
   ALIGN-L                                                              */
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation /* Manuten‡Æo de Documentos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation /* Manuten‡Æo de Documentos */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
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
    RUN piGravaRegistros IN THIS-PROCEDURE.
    
    IF RETURN-VALUE = "NOK":U 
    AND CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
        RETURN NO-APPLY.
    END.
    ELSE
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN piGravaRegistros IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK":U 
    AND CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
        RETURN NO-APPLY.
    END.
    ELSE DO:
        IF pcAction = "ADD":U THEN DO:
            ASSIGN cb-tipo-docto:SCREEN-VALUE IN FRAME fPage0 = STRING(0).
            APPLY "VALUE-CHANGED":U TO cb-tipo-docto.
        END.
        ELSE
            APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-tipo-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-docto wMaintenanceNoNavigation
ON VALUE-CHANGED OF cb-tipo-docto IN FRAME fpage0 /* Documento */
DO:
    RUN piInicializaCampos.
    ASSIGN i-tipo-docto = cb-tipo-docto:INPUT-VALUE.
    IF i-tipo-docto <> 0 THEN DO:
        RUN setConstraintByDocto  IN h-bocx00499 (INPUT i-tipo-docto).
        RUN openQueryStatic       IN h-bocx00499 (INPUT "ByDocto":U) NO-ERROR.
        RUN getBatchRecords       IN h-bocx00499 (INPUT  ?,
                                                  INPUT  NO,
                                                  INPUT  ?,
                                                  OUTPUT iRowsReturned,
                                                  OUTPUT TABLE tt-siscomex-chave).
        RUN piExibeChaves.
    END.
                                               
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-bocx00499) THEN
        RUN destroy IN h-bocx00499.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DO WITH FRAME fPage0:
        ASSIGN btHelp:COL = 104.57.
        IF pcAction = "ADD":U THEN DO:
            ENABLE cb-tipo-docto.
            ASSIGN cb-tipo-docto:SCREEN-VALUE = STRING(0).
            APPLY "VALUE-CHANGED":U TO cb-tipo-docto.
        END.
        ELSE DO:
            DISABLE cb-tipo-docto.
            ASSIGN cb-tipo-docto:SCREEN-VALUE = STRING(tt-duimp-docto.cod-tipo-docto).
            APPLY "VALUE-CHANGED":U TO cb-tipo-docto.
            RUN setConstraintTipoDocto  IN h-bocx00489 (INPUT tt-duimp-docto.cod-duimp-dts,
                                                        INPUT tt-duimp-docto.documento,
                                                        INPUT tt-duimp-docto.seq-docto,
                                                        INPUT tt-duimp-docto.cod-tipo-docto).
            RUN openQueryStatic         IN h-bocx00489 (INPUT "TipoDocto":U) NO-ERROR.
            RUN getBatchRecords         IN h-bocx00489 (INPUT  ?,
                                                        INPUT  NO,
                                                        INPUT  ?,
                                                        OUTPUT iRowsReturned,
                                                        OUTPUT TABLE tt-duimp-docto-aux).
            ASSIGN i-campo = 1.
            FOR EACH tt-siscomex-chave
                  BY tt-siscomex-chave.log-obrigatorio DESC
                  BY tt-siscomex-chave.cod-chave:
                
                FOR FIRST tt-duimp-docto-aux
                     WHERE tt-duimp-docto-aux.cod-chave = tt-siscomex-chave.cod-chave NO-LOCK:
               
                    IF tt-siscomex-chave.tipo-dado = "LISTA":U THEN DO:
                        ASSIGN cb-lista:SCREEN-VALUE = STRING(tt-duimp-docto-aux.valor).
                    END.
                    ELSE DO:
                        IF tt-siscomex-chave.tipo-dado = "NUMERO_REAL":U THEN DO:
                            ASSIGN tt-duimp-docto-aux.valor = TRIM(STRING(DECIMAL(TRIM(tt-duimp-docto-aux.valor)) / 100, ">>>>,>>>,>>>,>>9.99")).
                        END.
                        CASE i-campo:
                            WHEN 1 THEN DO:
                                ASSIGN c-valor-1:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 2 THEN DO:
                                ASSIGN c-valor-2:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 3 THEN DO:
                                ASSIGN c-valor-3:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 4 THEN DO:
                                ASSIGN c-valor-4:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 5 THEN DO:
                                ASSIGN c-valor-5:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 6 THEN DO:
                                ASSIGN c-valor-6:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 7 THEN DO:
                                ASSIGN c-valor-7:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 8 THEN DO:
                                ASSIGN c-valor-8:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 9 THEN DO:
                                ASSIGN c-valor-9:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 10 THEN DO:
                                ASSIGN c-valor-10:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 11 THEN DO:
                                ASSIGN c-valor-11:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 12 THEN DO:
                                ASSIGN c-valor-12:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 13 THEN DO:
                                ASSIGN c-valor-13:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 14 THEN DO:
                                ASSIGN c-valor-14:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 15 THEN DO:
                                ASSIGN c-valor-15:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 16 THEN DO:
                                ASSIGN c-valor-16:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 17 THEN DO:
                                ASSIGN c-valor-17:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 18 THEN DO:
                                ASSIGN c-valor-18:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 19 THEN DO:
                                ASSIGN c-valor-19:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 20 THEN DO:
                                ASSIGN c-valor-20:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 21 THEN DO:
                                ASSIGN c-valor-21:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 22 THEN DO:
                                ASSIGN c-valor-22:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 23 THEN DO:
                                ASSIGN c-valor-23:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 24 THEN DO:
                                ASSIGN c-valor-24:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 25 THEN DO:
                                ASSIGN c-valor-25:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 26 THEN DO:
                                ASSIGN c-valor-26:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 27 THEN DO:
                                ASSIGN c-valor-27:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 28 THEN DO:
                                ASSIGN c-valor-28:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 29 THEN DO:
                                ASSIGN c-valor-29:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 30 THEN DO:
                                ASSIGN c-valor-30:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 31 THEN DO:
                                ASSIGN c-valor-31:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                            WHEN 32 THEN DO:
                                ASSIGN c-valor-32:SCREEN-VALUE = tt-duimp-docto-aux.valor.
                            END.
                        END CASE.
                    END.
                END.
                ASSIGN i-campo = i-campo + 1.
            END.
        END.
    END.
    
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

    DO WITH FRAME fPage0:
        for first duimp-siscomex
        where rowid(duimp-siscomex)  = prParent no-lock:
            assign de-cod-duimp-dts = duimp-siscomex.cod-duimp-dts
                   c-cod-duimp-siscomex = duimp-siscomex.cod-duimp-siscomex.
        end.
        
        disp de-cod-duimp-dts
             c-cod-duimp-siscomex .
        
        FOR EACH siscomex-tipo-docto NO-LOCK,
        FIRST siscomex-chave NO-LOCK
        WHERE siscomex-chave.cod-tip-docto = siscomex-tipo-docto.cod-tipo-docto:
            ASSIGN l-result = cb-tipo-docto:ADD-LAST(STRING(siscomex-tipo-docto.cod-tipo-docto) 
                                                     + "-" + siscomex-tipo-docto.descricao, 
                                                     siscomex-tipo-docto.cod-tipo-docto).
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF  NOT VALID-HANDLE(h-bocx00499) 
    OR  h-bocx00499:TYPE <> "PROCEDURE":U 
    OR  h-bocx00499:FILE-NAME <> "cxbo/bocx00499.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx00499.p YES}
        {btb/btb008za.i2 cxbo/bocx00499.p '' h-bocx00499}
    END.    

    IF  NOT VALID-HANDLE({&hDBOTable}) 
    OR  {&hDBOTable}:TYPE <> "PROCEDURE":U 
    OR  {&hDBOTable}:FILE-NAME <> "cxbo/bocx00489.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx00489.p YES}
        {btb/btb008za.i2 cxbo/bocx00489.p '' {&hDBOTable}}
    END.    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaRowErrors wMaintenanceNoNavigation 
PROCEDURE piCriaRowErrors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM i-cod-msg AS INTEGER NO-UNDO.
    DEF INPUT PARAM c-param   AS CHAR    NO-UNDO.

    RUN utp/ut-msgs.p(INPUT "msg":U, INPUT i-cod-msg, INPUT c-param).
    CREATE RowErrors.
    ASSIGN RowErrors.ErrorNumber      = i-cod-msg
           RowErrors.ErrorType        = "EMS":U
           RowErrors.ErrorSubType     = "ERROR":U
           RowErrors.ErrorDescription = RETURN-VALUE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExibeChaves wMaintenanceNoNavigation 
PROCEDURE piExibeChaves :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN i-campo = 1.
    FOR EACH tt-siscomex-chave
        BY tt-siscomex-chave.log-obrigatorio DESC
        BY tt-siscomex-chave.cod-chave:

        IF tt-siscomex-chave.tipo-dado = "LISTA":U THEN DO WITH FRAME fPage0:
            ASSIGN c-chave-lista:HIDDEN = NO
                   cb-lista:HIDDEN = NO
                   c-chave-lista:SCREEN-VALUE = TRIM(tt-siscomex-chave.descricao) + IF tt-siscomex-chave.log-obrigatorio THEN "*" ELSE ""
                   c-lista = "-,0" 
                   cb-lista:LIST-ITEM-PAIRS = c-lista.
            ASSIGN c-lista = REPLACE(tt-siscomex-chave.desc-dominio,",","").
            DO i-campo = 1 TO NUM-ENTRIES(tt-siscomex-chave.cod-dominio,"|"):
                ASSIGN l-result = cb-lista:ADD-LAST(ENTRY(i-campo,tt-siscomex-chave.cod-dominio,"|") + "-" + ENTRY(i-campo,c-lista,"|"),
                                                    INT(ENTRY(i-campo,tt-siscomex-chave.cod-dominio,"|"))).
            END.
            ENABLE cb-lista.
        END.
        ELSE 
        DO WITH FRAME fPage0:
            IF tt-siscomex-chave.mascara <> "" 
            AND NOT tt-siscomex-chave.mascara BEGINS "1E" THEN 
                ASSIGN c-formato = tt-siscomex-chave.mascara.
            ELSE 
                ASSIGN c-formato = "x(" + STRING(tt-siscomex-chave.tamanho-campo) + ")".

            ASSIGN c-label = TRIM(tt-siscomex-chave.descricao) + IF tt-siscomex-chave.log-obrigatorio THEN "*" ELSE "".
            IF tt-siscomex-chave.tipo-dado = "NUMERO_REAL":U THEN
                ASSIGN c-help = c-label + " - Formato 999.999.999.999,99"
                       c-formato = "x(19)".
            ELSE
                ASSIGN c-help = c-label + " - Formato " + c-formato.
            
            IF LENGTH(c-label) > 30 THEN
                ASSIGN c-label = SUBSTRING(c-label,1,27) + "...".
            
            CASE i-campo:
                WHEN 1 THEN DO:
                    {imp/im7000a.i 1}                    
                END.
                WHEN 2 THEN DO:
                    {imp/im7000a.i 2}                    
                END.
                WHEN 3 THEN DO:
                    {imp/im7000a.i 3}                    
                END.
                WHEN 4 THEN DO:
                    {imp/im7000a.i 4}                    
                END.
                WHEN 5 THEN DO:
                    {imp/im7000a.i 5}                    
                END.
                WHEN 6 THEN DO:
                    {imp/im7000a.i 6}                    
                END.
                WHEN 7 THEN DO:
                    {imp/im7000a.i 7}                    
                END.
                WHEN 8 THEN DO:
                    {imp/im7000a.i 8}                    
                END.
                WHEN 9 THEN DO:
                    {imp/im7000a.i 9}                    
                END.
                WHEN 10 THEN DO:
                    {imp/im7000a.i 10}                    
                END.
                WHEN 11 THEN DO:
                    {imp/im7000a.i 11}                    
                END.
                WHEN 12 THEN DO:
                    {imp/im7000a.i 12}                    
                END.
                WHEN 13 THEN DO:
                    {imp/im7000a.i 13}                    
                END.
                WHEN 14 THEN DO:
                    {imp/im7000a.i 14}                    
                END.
                WHEN 15 THEN DO:
                    {imp/im7000a.i 15}                    
                END.
                WHEN 16 THEN DO:
                    {imp/im7000a.i 16}                    
                END.
                WHEN 17 THEN DO:
                    {imp/im7000a.i 17}                    
                END.
                WHEN 18 THEN DO:
                    {imp/im7000a.i 18}                    
                END.
                WHEN 19 THEN DO:
                    {imp/im7000a.i 19}                    
                END.
                WHEN 20 THEN DO:
                    {imp/im7000a.i 20}                    
                END.
                WHEN 21 THEN DO:
                    {imp/im7000a.i 21}                    
                END.
                WHEN 22 THEN DO:
                    {imp/im7000a.i 22}                    
                END.
                WHEN 23 THEN DO:
                    {imp/im7000a.i 23}                    
                END.
                WHEN 24 THEN DO:
                    {imp/im7000a.i 24}                    
                END.
                WHEN 25 THEN DO:
                    {imp/im7000a.i 25}                    
                END.
                WHEN 26 THEN DO:
                    {imp/im7000a.i 26}                    
                END.
                WHEN 27 THEN DO:
                    {imp/im7000a.i 27}                    
                END.
                WHEN 28 THEN DO:
                    {imp/im7000a.i 28}                    
                END.
                WHEN 29 THEN DO:
                    {imp/im7000a.i 29}                    
                END.
                WHEN 30 THEN DO:
                    {imp/im7000a.i 30}                    
                END.
                WHEN 31 THEN DO:
                    {imp/im7000a.i 31}                    
                END.
                WHEN 32 THEN DO:
                    {imp/im7000a.i 32}                    
                END.
            END CASE.
        END.
        ASSIGN i-campo = i-campo + 1.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGravaRegistros wMaintenanceNoNavigation 
PROCEDURE piGravaRegistros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DO WITH FRAME fPage0:
        IF pcAction = "ADD":U THEN DO:
            RUN piProximaSeq IN h-bocx00489 (INPUT de-cod-duimp-dts, /* cod-duimp-dts */
                                             INPUT 1,                               /* documento */
                                             INPUT cb-tipo-docto:INPUT-VALUE IN FRAME {&Frame-name},       /* cod-tipo-docto */
                                             INPUT 1,                               /* cod-chave */
                                             OUTPUT i-seq-docto).
        END.
        ELSE DO:
            FIND FIRST tt-duimp-docto-aux NO-ERROR.
            IF AVAIL tt-duimp-docto-aux THEN 
                ASSIGN i-seq-docto = tt-duimp-docto-aux.seq-docto.
        END.
        EMPTY TEMP-TABLE RowErrors.
        ASSIGN i-campo = 1.
        FOR EACH tt-siscomex-chave
            BY tt-siscomex-chave.log-obrigatorio DESC
            BY tt-siscomex-chave.cod-chave
            ON ERROR UNDO, RETURN "NOK":U:
            
            IF tt-siscomex-chave.tipo-dado = "LISTA":U THEN DO:
                {imp/im7000a.i2 1 "lista"}
            END.
            ELSE 
            CASE i-campo:
                WHEN 1 THEN DO:
                    {imp/im7000a.i2 1}
                END.
                WHEN 2 THEN DO:
                    {imp/im7000a.i2 2}
                END.
                WHEN 3 THEN DO:
                    {imp/im7000a.i2 3}
                END.
                WHEN 4 THEN DO:
                    {imp/im7000a.i2 4}
                END.
                WHEN 5 THEN DO:
                    {imp/im7000a.i2 5}
                END.
                WHEN 6 THEN DO:
                    {imp/im7000a.i2 6}
                END.
                WHEN 7 THEN DO:
                    {imp/im7000a.i2 7}
                END.
                WHEN 8 THEN DO:
                    {imp/im7000a.i2 8}
                END.
                WHEN 9 THEN DO:
                    {imp/im7000a.i2 9}
                END.
                WHEN 10 THEN DO:
                    {imp/im7000a.i2 10}
                END.
                WHEN 11 THEN DO:
                    {imp/im7000a.i2 11}
                END.
                WHEN 12 THEN DO:
                    {imp/im7000a.i2 12}
                END.
                WHEN 13 THEN DO:
                    {imp/im7000a.i2 13}
                END.
                WHEN 14 THEN DO:
                    {imp/im7000a.i2 14}
                END.
                WHEN 15 THEN DO:
                    {imp/im7000a.i2 15}
                END.
                WHEN 16 THEN DO:
                    {imp/im7000a.i2 16}
                END.
                WHEN 17 THEN DO:
                    {imp/im7000a.i2 17}
                END.
                WHEN 18 THEN DO:
                    {imp/im7000a.i2 18}
                END.
                WHEN 19 THEN DO:
                    {imp/im7000a.i2 19}
                END.
                WHEN 20 THEN DO:
                    {imp/im7000a.i2 20}
                END.
                WHEN 21 THEN DO:
                    {imp/im7000a.i2 21}
                END.
                WHEN 22 THEN DO:
                    {imp/im7000a.i2 22}
                END.
                WHEN 23 THEN DO:
                    {imp/im7000a.i2 23}
                END.
                WHEN 24 THEN DO:
                    {imp/im7000a.i2 24}
                END.
                WHEN 25 THEN DO:
                    {imp/im7000a.i2 25}
                END.
                WHEN 26 THEN DO:
                    {imp/im7000a.i2 26}
                END.
                WHEN 27 THEN DO:
                    {imp/im7000a.i2 27}
                END.
                WHEN 28 THEN DO:
                    {imp/im7000a.i2 28}
                END.
                WHEN 29 THEN DO:
                    {imp/im7000a.i2 29}
                END.
                WHEN 30 THEN DO:
                    {imp/im7000a.i2 30}
                END.
                WHEN 31 THEN DO:
                    {imp/im7000a.i2 31}
                END.
                WHEN 32 THEN DO:
                    {imp/im7000a.i2 32}
                END.
            END CASE.
            ASSIGN i-campo = i-campo + 1.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInicializaCampos wMaintenanceNoNavigation 
PROCEDURE piInicializaCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DO WITH FRAME fPage0:
    
        ASSIGN c-chave-lista:SCREEN-VALUE = ""
               c-chave-lista:HIDDEN = YES
               cb-lista:SCREEN-VALUE = STRING(0)
               cb-lista:HIDDEN = YES.
        DISABLE cb-lista.
        {imp/im7000a.i1 1}
        {imp/im7000a.i1 2}
        {imp/im7000a.i1 3}
        {imp/im7000a.i1 4}
        {imp/im7000a.i1 5}
        {imp/im7000a.i1 6}
        {imp/im7000a.i1 7}
        {imp/im7000a.i1 8}
        {imp/im7000a.i1 9}
        {imp/im7000a.i1 10}
        {imp/im7000a.i1 11}
        {imp/im7000a.i1 12}
        {imp/im7000a.i1 13}
        {imp/im7000a.i1 14}
        {imp/im7000a.i1 15}
        {imp/im7000a.i1 16}
        {imp/im7000a.i1 17}
        {imp/im7000a.i1 18}
        {imp/im7000a.i1 19}
        {imp/im7000a.i1 20}
        {imp/im7000a.i1 21}
        {imp/im7000a.i1 22}
        {imp/im7000a.i1 23}
        {imp/im7000a.i1 24}
        {imp/im7000a.i1 25}
        {imp/im7000a.i1 26}
        {imp/im7000a.i1 27}
        {imp/im7000a.i1 28}
        {imp/im7000a.i1 29}
        {imp/im7000a.i1 30}
        {imp/im7000a.i1 31}
        {imp/im7000a.i1 32}
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaCriaDocto wMaintenanceNoNavigation 
PROCEDURE piValidaCriaDocto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN c-valor-inf = TRIM(REPLACE(REPLACE(REPLACE(tt-duimp-docto-aux2.valor,"/",""),"-",""),":",""))
           c-valor-inf = TRIM(REPLACE(REPLACE(c-valor-inf,",",""),".","")).
    IF tt-siscomex-chave.log-obrigatorio
    AND (c-valor-inf = "":U OR c-valor-inf = "0":U) THEN DO:
        RUN piCriaRowErrors (INPUT 17394, INPUT tt-siscomex-chave.descricao).
        RETURN "NOK":U.
    END.
    IF tt-siscomex-chave.tipo-dado = "NUMERO_INTEIRO":U 
    OR tt-siscomex-chave.tipo-dado = "NUMERO_REAL":U  THEN DO:
        ASSIGN tt-duimp-docto-aux2.valor = c-valor-inf.
        DO i-aux = 1 TO LENGTH(tt-duimp-docto-aux2.valor):
            IF ASC(SUBSTRING(tt-duimp-docto-aux2.valor,i-aux,1)) < 48
            OR ASC(SUBSTRING(tt-duimp-docto-aux2.valor,i-aux,1)) > 57 THEN DO:
                RUN piCriaRowErrors(INPUT 55317, INPUT tt-siscomex-chave.descricao + "~~Num‚rico").
                RETURN "NOK":U.
            END.
        END.
    END.
    
    IF c-valor-inf <> "" THEN DO:
        RUN emptyRowErrors  IN h-bocx00489.
        RUN emptyRowObject  IN h-bocx00489.
        RUN openQueryStatic IN h-bocx00489 (INPUT "Main":U).
        RUN goToKey         IN h-bocx00489 (INPUT tt-duimp-docto-aux2.cod-duimp-dts,
                                            INPUT tt-duimp-docto-aux2.documento,
                                            INPUT tt-duimp-docto-aux2.seq-docto,
                                            INPUT tt-duimp-docto-aux2.cod-tipo-docto,
                                            INPUT tt-duimp-docto-aux2.cod-chave).
        IF pcAction = "ADD":U 
        OR RETURN-VALUE = "NOK":U THEN DO:
            RUN setRecord      IN h-bocx00489 (INPUT TABLE tt-duimp-docto-aux2).
            RUN createRecord   IN h-bocx00489.
        END.
        ELSE DO:
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN setRecord      IN h-bocx00489 (INPUT TABLE tt-duimp-docto-aux2).
                RUN updateRecord   IN h-bocx00489.
            END.
        END.
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN h-bocx00489 (OUTPUT TABLE RowErrors APPEND).
            RETURN "NOK":U.
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
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

