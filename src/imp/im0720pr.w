&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0720PR 2.00.00.000 } /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0720PR MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0720pr
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   c-nr-proc-imp-ini c-nr-proc-imp-fim i-num-pedido-ini i-num-pedido-fim ~
                              i-numero-ordem-ini i-numero-ordem-fim i-parcela-ini i-parcela-fim ~
                              i-cod-emitente-ini i-cod-emitente-fim c-nome-abrev-ini c-nome-abrev-fim ~
                              c-cod-refer-ini c-cod-refer-fim c-cod-espec-docto-ini c-cod-espec-docto-fim ~
                              c-cod-ser-docto-ini c-cod-ser-docto-fim c-cod-tit-ap-ini c-cod-tit-ap-fim ~
                              c-cod-parcela-ini c-cod-parcela-fim dt-dat-emissao-ini dt-dat-emissao-fim ~
                              dt-dat-vencto-ini dt-dat-vencto-fim de-val-adiant-moed-ini de-val-adiant-moed-fim ~
                              btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER pl-habilita             AS LOGICAL                              NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-nr-proc-imp-ini      LIKE processo-imp.nr-proc-imp           NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-nr-proc-imp-fim      LIKE processo-imp.nr-proc-imp           NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pi-num-pedido-ini       LIKE pedido-compr.num-pedido            NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pi-num-pedido-fim       LIKE pedido-compr.num-pedido            NO-UNDO.  
DEFINE INPUT-OUTPUT PARAMETER pi-numero-ordem-ini     LIKE ordem-compra.numero-ordem          NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pi-numero-ordem-fim     LIKE ordem-compra.numero-ordem          NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pi-parcela-ini          LIKE prazo-compra.parcela               NO-UNDO. 
DEFINE INPUT-OUTPUT PARAMETER pi-parcela-fim          LIKE prazo-compra.parcela               NO-UNDO. 
DEFINE INPUT-OUTPUT PARAMETER pi-cod-emitente-ini     LIKE emitente.cod-emitente              NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pi-cod-emitente-fim     LIKE emitente.cod-emitente              NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-nome-abrev-ini       LIKE emitente.nome-abrev                NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-nome-abrev-fim       LIKE emitente.nome-abrev                NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-refer-ini        LIKE adiant-despes-parc.cod-refer       NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-refer-fim        LIKE adiant-despes-parc.cod-refer       NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-espec-docto-ini  LIKE adiant-despes-parc.cod-espec-docto NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-espec-docto-fim  LIKE adiant-despes-parc.cod-espec-docto NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-ser-docto-ini    LIKE adiant-despes-parc.cod-ser-docto   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-ser-docto-fim    LIKE adiant-despes-parc.cod-ser-docto   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-tit-ap-ini       LIKE adiant-despes-parc.cod-tit-ap      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-tit-ap-fim       LIKE adiant-despes-parc.cod-tit-ap      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-parcela-ini      LIKE adiant-despes-parc.cod-parcela     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-parcela-fim      LIKE adiant-despes-parc.cod-parcela     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pdt-dat-emissao-ini     LIKE adiant-despes-parc.dat-emissao     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pdt-dat-emissao-fim     LIKE adiant-despes-parc.dat-emissao     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pdt-dat-vencto-ini      LIKE adiant-despes-parc.dat-vencto      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pdt-dat-vencto-fim      LIKE adiant-despes-parc.dat-vencto      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pde-val-adiant-moed-ini LIKE adiant-despes-parc.val-adiant-moed NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pde-val-adiant-moed-fim LIKE adiant-despes-parc.val-adiant-moed NO-UNDO.
DEFINE OUTPUT       PARAMETER l-usou-filtro           AS   LOGICAL                            NO-UNDO.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-nr-proc-imp-ini c-nr-proc-imp-fim ~
i-num-pedido-ini i-num-pedido-fim i-numero-ordem-ini i-numero-ordem-fim ~
i-parcela-ini i-parcela-fim i-cod-emitente-ini i-cod-emitente-fim ~
c-nome-abrev-ini c-nome-abrev-fim c-cod-refer-ini c-cod-refer-fim ~
c-cod-espec-docto-ini c-cod-espec-docto-fim c-cod-ser-docto-ini ~
c-cod-ser-docto-fim c-cod-tit-ap-ini c-cod-tit-ap-fim c-cod-parcela-ini ~
c-cod-parcela-fim dt-dat-emissao-ini dt-dat-emissao-fim dt-dat-vencto-ini ~
dt-dat-vencto-fim de-val-adiant-moed-ini de-val-adiant-moed-fim btOK ~
btCancel btHelp2 btQueryJoins btReportsJoins btExit btHelp rtToolBar-2 ~
rtToolBar IMAGE-20 IMAGE-13 IMAGE-14 IMAGE-15 IMAGE-16 IMAGE-17 IMAGE-18 ~
IMAGE-19 IMAGE-21 IMAGE-22 IMAGE-23 IMAGE-24 IMAGE-25 IMAGE-26 IMAGE-27 ~
IMAGE-28 IMAGE-8 IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-5 IMAGE-6 IMAGE-7 ~
IMAGE-11 IMAGE-12 IMAGE-9 IMAGE-10 
&Scoped-Define DISPLAYED-OBJECTS c-nr-proc-imp-ini c-nr-proc-imp-fim ~
i-num-pedido-ini i-num-pedido-fim i-numero-ordem-ini i-numero-ordem-fim ~
i-parcela-ini i-parcela-fim i-cod-emitente-ini i-cod-emitente-fim ~
c-nome-abrev-ini c-nome-abrev-fim c-cod-refer-ini c-cod-refer-fim ~
c-cod-espec-docto-ini c-cod-espec-docto-fim c-cod-ser-docto-ini ~
c-cod-ser-docto-fim c-cod-tit-ap-ini c-cod-tit-ap-fim c-cod-parcela-ini ~
c-cod-parcela-fim dt-dat-emissao-ini dt-dat-emissao-fim dt-dat-vencto-ini ~
dt-dat-vencto-fim de-val-adiant-moed-ini de-val-adiant-moed-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

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

DEFINE VARIABLE c-cod-espec-docto-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-espec-docto-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-parcela-fim AS CHARACTER FORMAT "X(2)":U INITIAL "ZZ" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-parcela-ini AS CHARACTER FORMAT "X(2)":U 
     LABEL "Parcela" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-refer-fim AS CHARACTER FORMAT "X(10)" INITIAL "ZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-refer-ini AS CHARACTER FORMAT "X(10)" 
     LABEL "Referˆncia" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-ser-docto-fim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-ser-docto-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "S‚rie Documento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-tit-ap-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-tit-ap-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "T¡tulo" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Nome Abrev" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-proc-imp-fim AS CHARACTER FORMAT "X(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-nr-proc-imp-ini AS CHARACTER FORMAT "X(12)" 
     LABEL "Processo Importa‡Æo":R23 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE de-val-adiant-moed-fim AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.99":U INITIAL 999999999999999.99 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-adiant-moed-ini AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Adiantamento" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE dt-dat-emissao-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .88 NO-UNDO.

DEFINE VARIABLE dt-dat-emissao-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/1800 
     LABEL "Data EmissÆo" 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .88 NO-UNDO.

DEFINE VARIABLE dt-dat-vencto-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .88 NO-UNDO.

DEFINE VARIABLE dt-dat-vencto-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/1800 
     LABEL "Data Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-pedido-fim AS INTEGER FORMAT ">>>>>,>>9" INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE i-num-pedido-ini AS INTEGER FORMAT ">>>>>,>>9" INITIAL 0 
     LABEL "Pedido":R8 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE i-numero-ordem-fim AS INTEGER FORMAT "zzzzz9,99" INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE i-numero-ordem-ini AS INTEGER FORMAT "zzzzz9,99" INITIAL 0 
     LABEL "Ordem":R7 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE i-parcela-fim AS INTEGER FORMAT ">>>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE i-parcela-ini AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Parcela" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-27
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-nr-proc-imp-ini AT ROW 2.54 COL 7.86 WIDGET-ID 104
     c-nr-proc-imp-fim AT ROW 2.54 COL 48.72 NO-LABEL WIDGET-ID 102
     i-num-pedido-ini AT ROW 3.54 COL 24.29 HELP
          "N£mero do Pedido de Compra" WIDGET-ID 112
     i-num-pedido-fim AT ROW 3.54 COL 48.72 HELP
          "N£mero do Pedido de Compra" NO-LABEL WIDGET-ID 110
     i-numero-ordem-ini AT ROW 4.54 COL 24.72 WIDGET-ID 116
     i-numero-ordem-fim AT ROW 4.54 COL 48.72 NO-LABEL WIDGET-ID 114
     i-parcela-ini AT ROW 5.5 COL 31.72 COLON-ALIGNED WIDGET-ID 118
     i-parcela-fim AT ROW 5.54 COL 46.72 COLON-ALIGNED NO-LABEL WIDGET-ID 120
     i-cod-emitente-ini AT ROW 6.54 COL 23.14 HELP
          "C¢digo do Emitente" WIDGET-ID 108
     i-cod-emitente-fim AT ROW 6.54 COL 48.72 HELP
          "C¢digo do Emitente" NO-LABEL WIDGET-ID 106
     c-nome-abrev-ini AT ROW 7.54 COL 17.71 HELP
          "Nome Abreviado" WIDGET-ID 100
     c-nome-abrev-fim AT ROW 7.54 COL 48.72 HELP
          "Nome Abreviado" NO-LABEL WIDGET-ID 98
     c-cod-refer-ini AT ROW 8.54 COL 27.86 COLON-ALIGNED HELP
          "C¢digo da referˆncia Inicial" WIDGET-ID 54
     c-cod-refer-fim AT ROW 8.54 COL 46.57 COLON-ALIGNED HELP
          "C¢digo da referˆncia Final" NO-LABEL WIDGET-ID 52
     c-cod-espec-docto-ini AT ROW 9.54 COL 34.86 COLON-ALIGNED HELP
          "C¢digo da Esp‚cie do documento Inicial" WIDGET-ID 50
     c-cod-espec-docto-fim AT ROW 9.54 COL 46.57 COLON-ALIGNED HELP
          "C¢digo da Esp‚cie do Documento Final" NO-LABEL WIDGET-ID 48
     c-cod-ser-docto-ini AT ROW 10.54 COL 32.86 COLON-ALIGNED HELP
          "S‚rie do Documento Inicial" WIDGET-ID 58
     c-cod-ser-docto-fim AT ROW 10.54 COL 46.57 COLON-ALIGNED HELP
          "S‚rie do Documento Final" NO-LABEL WIDGET-ID 56
     c-cod-tit-ap-ini AT ROW 11.54 COL 21.86 COLON-ALIGNED HELP
          "Codigo do t¡tulo inicial" WIDGET-ID 46
     c-cod-tit-ap-fim AT ROW 11.54 COL 46.57 COLON-ALIGNED HELP
          "Codigo do t¡tulo final" NO-LABEL WIDGET-ID 60
     c-cod-parcela-ini AT ROW 12.54 COL 35.86 COLON-ALIGNED HELP
          "Parcela Inicial" WIDGET-ID 2
     c-cod-parcela-fim AT ROW 12.54 COL 46.57 COLON-ALIGNED HELP
          "Parcela Final" NO-LABEL WIDGET-ID 12
     dt-dat-emissao-ini AT ROW 13.54 COL 29.29 COLON-ALIGNED HELP
          "Data emissÆo inicial" WIDGET-ID 14
     dt-dat-emissao-fim AT ROW 13.54 COL 46.57 COLON-ALIGNED HELP
          "Data emissÆo final" NO-LABEL WIDGET-ID 20
     dt-dat-vencto-ini AT ROW 14.54 COL 29.29 COLON-ALIGNED HELP
          "Data vencimento inicial" WIDGET-ID 22
     dt-dat-vencto-fim AT ROW 14.54 COL 46.57 COLON-ALIGNED HELP
          "Data vencimento final" NO-LABEL WIDGET-ID 24
     de-val-adiant-moed-ini AT ROW 15.54 COL 20 COLON-ALIGNED HELP
          "Valor adiantamento Inicial" WIDGET-ID 38
     de-val-adiant-moed-fim AT ROW 15.54 COL 46.43 COLON-ALIGNED HELP
          "Valor adiantamento Final" NO-LABEL WIDGET-ID 40
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 16.54 COL 1
     IMAGE-20 AT ROW 11.5 COL 45.43 WIDGET-ID 62
     IMAGE-13 AT ROW 8.54 COL 41.14 WIDGET-ID 64
     IMAGE-14 AT ROW 8.54 COL 45.43 WIDGET-ID 66
     IMAGE-15 AT ROW 9.54 COL 41.14 WIDGET-ID 68
     IMAGE-16 AT ROW 9.54 COL 45.43 WIDGET-ID 70
     IMAGE-17 AT ROW 10.54 COL 41.14 WIDGET-ID 72
     IMAGE-18 AT ROW 10.54 COL 45.43 WIDGET-ID 74
     IMAGE-19 AT ROW 11.54 COL 41.14 WIDGET-ID 76
     IMAGE-21 AT ROW 12.54 COL 41.14 WIDGET-ID 8
     IMAGE-22 AT ROW 12.54 COL 45.43 WIDGET-ID 10
     IMAGE-23 AT ROW 13.54 COL 41.14 WIDGET-ID 16
     IMAGE-24 AT ROW 13.54 COL 45.43 WIDGET-ID 18
     IMAGE-25 AT ROW 14.54 COL 41.14 WIDGET-ID 26
     IMAGE-26 AT ROW 14.54 COL 45.43 WIDGET-ID 28
     IMAGE-27 AT ROW 15.54 COL 41.14 WIDGET-ID 42
     IMAGE-28 AT ROW 15.54 COL 45.43 WIDGET-ID 44
     IMAGE-8 AT ROW 5.5 COL 45.43 WIDGET-ID 78
     IMAGE-1 AT ROW 2.54 COL 41.14 WIDGET-ID 84
     IMAGE-2 AT ROW 2.54 COL 45.43 WIDGET-ID 86
     IMAGE-3 AT ROW 3.54 COL 41.14 WIDGET-ID 88
     IMAGE-4 AT ROW 3.54 COL 45.43 WIDGET-ID 90
     IMAGE-5 AT ROW 4.54 COL 41.14 WIDGET-ID 92
     IMAGE-6 AT ROW 4.54 COL 45.43 WIDGET-ID 94
     IMAGE-7 AT ROW 5.54 COL 41.14 WIDGET-ID 96
     IMAGE-11 AT ROW 7.54 COL 41.14 WIDGET-ID 80
     IMAGE-12 AT ROW 7.54 COL 45.43 WIDGET-ID 82
     IMAGE-9 AT ROW 6.54 COL 41.14 WIDGET-ID 122
     IMAGE-10 AT ROW 6.54 COL 45.43 WIDGET-ID 124
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN c-nome-abrev-fim IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-nome-abrev-ini IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-nr-proc-imp-fim IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-nr-proc-imp-ini IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN i-cod-emitente-fim IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN i-cod-emitente-ini IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN i-num-pedido-fim IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN i-num-pedido-ini IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN i-numero-ordem-fim IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN i-numero-ordem-ini IN FRAME fpage0
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

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
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    ASSIGN pc-nr-proc-imp-ini       = INPUT FRAME {&FRAME-NAME} c-nr-proc-imp-ini  
           pc-nr-proc-imp-fim       = INPUT FRAME {&FRAME-NAME} c-nr-proc-imp-fim  
           pi-num-pedido-ini        = INPUT FRAME {&FRAME-NAME} i-num-pedido-ini   
           pi-num-pedido-fim        = INPUT FRAME {&FRAME-NAME} i-num-pedido-fim   
           pi-numero-ordem-ini      = INPUT FRAME {&FRAME-NAME} i-numero-ordem-ini 
           pi-numero-ordem-fim      = INPUT FRAME {&FRAME-NAME} i-numero-ordem-fim 
           pi-parcela-ini           = INPUT FRAME {&FRAME-NAME} i-parcela-ini      
           pi-parcela-fim           = INPUT FRAME {&FRAME-NAME} i-parcela-fim      
           pi-cod-emitente-ini      = INPUT FRAME {&FRAME-NAME} i-cod-emitente-ini 
           pi-cod-emitente-fim      = INPUT FRAME {&FRAME-NAME} i-cod-emitente-fim 
           pc-nome-abrev-ini        = INPUT FRAME {&FRAME-NAME} c-nome-abrev-ini   
           pc-nome-abrev-fim        = INPUT FRAME {&FRAME-NAME} c-nome-abrev-fim   
           pc-cod-refer-ini         = INPUT FRAME {&FRAME-NAME} c-cod-refer-ini 
           pc-cod-refer-fim         = INPUT FRAME {&FRAME-NAME} c-cod-refer-fim 
           pc-cod-espec-docto-ini   = INPUT FRAME {&FRAME-NAME} c-cod-espec-docto-ini 
           pc-cod-espec-docto-fim   = INPUT FRAME {&FRAME-NAME} c-cod-espec-docto-fim 
           pc-cod-ser-docto-ini     = INPUT FRAME {&FRAME-NAME} c-cod-ser-docto-ini 
           pc-cod-ser-docto-fim     = INPUT FRAME {&FRAME-NAME} c-cod-ser-docto-fim 
           pc-cod-tit-ap-ini        = INPUT FRAME {&FRAME-NAME} c-cod-tit-ap-ini 
           pc-cod-tit-ap-fim        = INPUT FRAME {&FRAME-NAME} c-cod-tit-ap-fim 
           pc-cod-parcela-ini       = INPUT FRAME {&FRAME-NAME} c-cod-parcela-ini
           pc-cod-parcela-fim       = INPUT FRAME {&FRAME-NAME} c-cod-parcela-fim
           pdt-dat-emissao-ini      = INPUT FRAME {&FRAME-NAME} dt-dat-emissao-ini 
           pdt-dat-emissao-fim      = INPUT FRAME {&FRAME-NAME} dt-dat-emissao-fim 
           pdt-dat-vencto-ini       = INPUT FRAME {&FRAME-NAME} dt-dat-vencto-ini 
           pdt-dat-vencto-fim       = INPUT FRAME {&FRAME-NAME} dt-dat-vencto-fim 
           pde-val-adiant-moed-ini  = INPUT FRAME {&FRAME-NAME} de-val-adiant-moed-ini 
           pde-val-adiant-moed-fim  = INPUT FRAME {&FRAME-NAME} de-val-adiant-moed-fim 
           l-usou-filtro            = YES.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
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


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa as vari veis durante abertura do programa
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN c-nr-proc-imp-ini:SCREEN-VALUE      IN FRAME fPage0 = pc-nr-proc-imp-ini   
           c-nr-proc-imp-fim:SCREEN-VALUE      IN FRAME fPage0 = pc-nr-proc-imp-fim  
           i-num-pedido-ini:SCREEN-VALUE       IN FRAME fPage0 = string(pi-num-pedido-ini)   
           i-num-pedido-fim:SCREEN-VALUE       IN FRAME fPage0 = string(pi-num-pedido-fim)
           i-numero-ordem-ini:SCREEN-VALUE     IN FRAME fPage0 = string(pi-numero-ordem-ini) 
           i-numero-ordem-fim:SCREEN-VALUE     IN FRAME fPage0 = string(pi-numero-ordem-fim) 
           i-parcela-ini:SCREEN-VALUE          IN FRAME fPage0 = string(pi-parcela-ini)      
           i-parcela-fim:SCREEN-VALUE          IN FRAME fPage0 = string(pi-parcela-fim)      
           i-cod-emitente-ini:SCREEN-VALUE     IN FRAME fPage0 = string(pi-cod-emitente-ini) 
           i-cod-emitente-fim:SCREEN-VALUE     IN FRAME fPage0 = string(pi-cod-emitente-fim) 
           c-nome-abrev-ini:SCREEN-VALUE       IN FRAME fPage0 = pc-nome-abrev-ini   
           c-nome-abrev-fim:SCREEN-VALUE       IN FRAME fPage0 = pc-nome-abrev-fim   
           c-cod-refer-ini:SCREEN-VALUE        IN FRAME fPage0 = pc-cod-refer-ini        
           c-cod-refer-fim:SCREEN-VALUE        IN FRAME fPage0 = pc-cod-refer-fim        
           c-cod-espec-docto-ini:SCREEN-VALUE  IN FRAME fPage0 = pc-cod-espec-docto-ini  
           c-cod-espec-docto-fim:SCREEN-VALUE  IN FRAME fPage0 = pc-cod-espec-docto-fim  
           c-cod-ser-docto-ini:SCREEN-VALUE    IN FRAME fPage0 = pc-cod-ser-docto-ini    
           c-cod-ser-docto-fim:SCREEN-VALUE    IN FRAME fPage0 = pc-cod-ser-docto-fim    
           c-cod-tit-ap-ini:SCREEN-VALUE       IN FRAME fPage0 = pc-cod-tit-ap-ini       
           c-cod-tit-ap-fim:SCREEN-VALUE       IN FRAME fPage0 = pc-cod-tit-ap-fim       
           c-cod-parcela-ini:SCREEN-VALUE      IN FRAME fPage0 = pc-cod-parcela-ini      
           c-cod-parcela-fim:SCREEN-VALUE      IN FRAME fPage0 = pc-cod-parcela-fim      
           dt-dat-emissao-ini:SCREEN-VALUE     IN FRAME fPage0 = string(pdt-dat-emissao-ini)     
           dt-dat-emissao-fim:SCREEN-VALUE     IN FRAME fPage0 = string(pdt-dat-emissao-fim)     
           dt-dat-vencto-ini:SCREEN-VALUE      IN FRAME fPage0 = string(pdt-dat-vencto-ini)      
           dt-dat-vencto-fim:SCREEN-VALUE      IN FRAME fPage0 = string(pdt-dat-vencto-fim)      
           de-val-adiant-moed-ini:SCREEN-VALUE IN FRAME fPage0 = string(pde-val-adiant-moed-ini) 
           de-val-adiant-moed-fim:SCREEN-VALUE IN FRAME fPage0 = string(pde-val-adiant-moed-fim). 

    IF pl-habilita THEN DO:
        ENABLE c-nr-proc-imp-ini     
               c-nr-proc-imp-fim     
               i-num-pedido-ini      
               i-num-pedido-fim      
               i-numero-ordem-ini    
               i-numero-ordem-fim    
               i-parcela-ini         
               i-parcela-fim         
               i-cod-emitente-ini    
               i-cod-emitente-fim    
               c-nome-abrev-ini      
               c-nome-abrev-fim      
               c-cod-refer-ini       
               c-cod-refer-fim       
               c-cod-espec-docto-ini 
               c-cod-espec-docto-fim 
               c-cod-ser-docto-ini   
               c-cod-ser-docto-fim   
               c-cod-tit-ap-ini      
               c-cod-tit-ap-fim      
               c-cod-parcela-ini     
               c-cod-parcela-fim     
               dt-dat-emissao-ini    
               dt-dat-emissao-fim    
               dt-dat-vencto-ini     
               dt-dat-vencto-fim     
               de-val-adiant-moed-ini
               de-val-adiant-moed-fim WITH FRAME fPage0.
    END.
    ELSE DO:
        ASSIGN c-cod-refer-ini       :HIDDEN IN FRAME fPage0 = YES 
               c-cod-refer-fim       :HIDDEN IN FRAME fPage0 = YES 
               c-cod-espec-docto-ini :HIDDEN IN FRAME fPage0 = YES 
               c-cod-espec-docto-fim :HIDDEN IN FRAME fPage0 = YES 
               c-cod-ser-docto-ini   :HIDDEN IN FRAME fPage0 = YES 
               c-cod-ser-docto-fim   :HIDDEN IN FRAME fPage0 = YES 
               c-cod-tit-ap-ini      :HIDDEN IN FRAME fPage0 = YES 
               c-cod-tit-ap-fim      :HIDDEN IN FRAME fPage0 = YES 
               c-cod-parcela-ini     :HIDDEN IN FRAME fPage0 = YES 
               c-cod-parcela-fim     :HIDDEN IN FRAME fPage0 = YES 
               dt-dat-emissao-ini    :HIDDEN IN FRAME fPage0 = YES 
               dt-dat-emissao-fim    :HIDDEN IN FRAME fPage0 = YES 
               dt-dat-vencto-ini     :HIDDEN IN FRAME fPage0 = YES 
               dt-dat-vencto-fim     :HIDDEN IN FRAME fPage0 = YES 
               de-val-adiant-moed-ini:HIDDEN IN FRAME fPage0 = YES 
               de-val-adiant-moed-fim:HIDDEN IN FRAME fPage0 = YES
               IMAGE-13              :HIDDEN IN FRAME fPage0 = YES
               IMAGE-14              :HIDDEN IN FRAME fPage0 = YES
               IMAGE-15              :HIDDEN IN FRAME fPage0 = YES
               IMAGE-16              :HIDDEN IN FRAME fPage0 = YES
               IMAGE-17              :HIDDEN IN FRAME fPage0 = YES
               IMAGE-18              :HIDDEN IN FRAME fPage0 = YES
               IMAGE-19              :HIDDEN IN FRAME fPage0 = YES
               IMAGE-20              :HIDDEN IN FRAME fPage0 = YES
               IMAGE-21              :HIDDEN IN FRAME fPage0 = YES
               IMAGE-22              :HIDDEN IN FRAME fPage0 = YES
               IMAGE-23              :HIDDEN IN FRAME fPage0 = YES
               IMAGE-24              :HIDDEN IN FRAME fPage0 = YES
               IMAGE-25              :HIDDEN IN FRAME fPage0 = YES
               IMAGE-26              :HIDDEN IN FRAME fPage0 = YES
               IMAGE-27              :HIDDEN IN FRAME fPage0 = YES
               IMAGE-28              :HIDDEN IN FRAME fPage0 = YES.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

