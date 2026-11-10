&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0101B1 2.00.00.011 } /*** "010011" 08/12/2025 14:50:49  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0101b1 MIM}
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
&GLOBAL-DEFINE Program        IM0101B1
&GLOBAL-DEFINE Version        2.00.00.011

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 cEmbarqueIni cEmbarqueFim ~
                              lConsideraDesembarqueParcial dtNacionalizacaoIni dtNacionalizacaoFim ~
                              cContainerIni cContainerFim cProcessoIni cProcessoFim dtDiIni dtDiFim ~
                              cDiIni cDiFim iItinerarioIni iItinerarioFim iExportadorIni iExportadorFim ~
                              iLocalizacao dtChegadaIni dtChegadaFim cVeiculoTranspIni cVeiculoTranspFim ~
                              i-num-di-ems-ini i-num-di-ems-fim

{cdp/cdcfgmat.i}
{cdp/cdcfgcex.i}
{cxbo/bocx220h.i tt-selecao-embarque}

/* Parameters Definitions ---                                           */
&IF "{&mguni_version}" >= "2.071" &THEN
    define input        parameter c-cod-estabel            LIKE estabelec.cod-estabel      no-undo.     
&ELSE
    define input        parameter c-cod-estabel            as char format "x(03)"      no-undo.     
&ENDIF
DEFINE INPUT        PARAMETER i-tipo-geracao           AS INT                      NO-UNDO.
define input-output parameter c-embarque-ini           LIKE embarque-imp.embarque  no-undo. 
define input-output parameter c-embarque-fim           LIKE embarque-imp.embarque  no-undo. 
define input-output parameter pi-num-di-ems-ini        as int  format ">>>>>>>>9"  no-undo.    
define input-output parameter pi-num-di-ems-fim        as int  format ">>>>>>>>9"  NO-UNDO.  
define input-output parameter l-desembarque-parcial    as log                      no-undo. 
define input-output parameter dt-nacionalizacao-ini    as date format "99/99/9999" no-undo. 
define input-output parameter dt-nacionalizacao-fim    as date format "99/99/9999" no-undo. 
define input-output parameter c-container-ini          as char format "x(20)"      no-undo. 
define input-output parameter c-container-fim          as char format "x(20)"      no-undo. 
define input-output parameter c-processo-ini           as char format "x(12)"      no-undo. 
define input-output parameter c-processo-fim           as char format "x(12)"      no-undo. 
define input-output parameter c-declaracao-imp-ini     as char format "x(20)"      no-undo. 
define input-output parameter c-declaracao-imp-fim     as char format "x(20)"      no-undo. 
define input-output parameter dt-di-ini                as date format "99/99/9999" no-undo. 
define input-output parameter dt-di-fim                as date format "99/99/9999" no-undo. 
define input-output parameter i-itinerario-ini         as int  format ">>,>>9"     no-undo. 
define input-output parameter i-itinerario-fim         as int  format ">>,>>9"     no-undo. 
define input-output parameter i-exportador-ini         as int  format ">>>>>>>>9"  no-undo. 
define input-output parameter i-exportador-fim         as int  format ">>>>>>>>9"  no-undo. 
define input-output parameter i-localizacao            as int  format ">>,>>9"     no-undo. 
define input-output parameter dt-chegada-ini           as date format "99/99/9999" no-undo. 
define input-output parameter dt-chegada-fim           as date format "99/99/9999" no-undo. 
define input-output parameter c-veiculo-transp-ini     as char format "x(20)"      no-undo. 
define input-output parameter c-veiculo-transp-fim     as char format "x(20)"      no-undo. 
&if "{&bf_cex_versao_ems}" >= "2.062" &then
    &if "{&bf_mat_versao_ems}" >= "2.04" &then
        define input-output  parameter c-nr-conhecto-master-ini as char format "x(25)"  no-undo. 
        define input-output  parameter c-nr-conhecto-master-fim as char format "x(25)"  no-undo. 
        define input-output  parameter c-nr-conhecto-house-ini  as char format "x(25)"  no-undo. 
        define input-output  parameter c-nr-conhecto-house-fim  as char format "x(25)"  no-undo. 
    &endif
&else
    &if '{&bf_mat_versao_ems}' >= '2.05' &then
        define input-output  parameter c-nr-conhecto-master-ini as char format "x(25)"  no-undo. 
        define input-output  parameter c-nr-conhecto-master-fim as char format "x(25)"  no-undo. 
        define input-output  parameter c-nr-conhecto-house-ini  as char format "x(25)"  no-undo. 
        define input-output  parameter c-nr-conhecto-house-fim  as char format "x(25)"  no-undo. 
    &else
        define input-output  parameter c-nr-conhecto-ini        as char format "x(18)"  no-undo. 
        define input-output  parameter c-nr-conhecto-fim        as char format "x(18)"  no-undo.     
    &endif
&endif
define input  parameter table for tt-selecao-embarque. 
DEFINE INPUT PARAMETER i-num-di-ems-aux                 LIKE decla-import.num-di-ems NO-UNDO.
define output parameter l-ok                            as log                      no-undo. 

                        

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
&Scoped-Define ENABLED-OBJECTS cEmbarqueIni cEmbarqueFim ~
lConsideraDesembarqueParcial dtNacionalizacaoIni dtNacionalizacaoFim ~
cContainerIni cContainerFim cProcessoIni cProcessoFim cDiIni cDiFim dtDiIni ~
dtDiFim iItinerarioIni iItinerarioFim iExportadorIni iExportadorFim ~
iLocalizacao dtChegadaIni dtChegadaFim cVeiculoTranspIni cVeiculoTranspFim ~
cNrConhecimentoIni cNrConhecimentoFim cConhectoMasterIni cConhectoMasterFim ~
cConhectoHouseIni cConhectoHouseFim btOK btCancel btHelp2 IMAGE-1 IMAGE-10 ~
IMAGE-11 IMAGE-12 IMAGE-13 IMAGE-14 IMAGE-15 IMAGE-16 IMAGE-18 IMAGE-19 ~
IMAGE-20 IMAGE-21 IMAGE-22 IMAGE-23 IMAGE-24 IMAGE-25 IMAGE-26 IMAGE-27 ~
IMAGE-28 IMAGE-29 IMAGE-8 IMAGE-9 imageConhectoHouseFim ~
imageConhectoHouseIni RECT-1 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS cestabelecimento cEmbarqueIni cEmbarqueFim ~
lConsideraDesembarqueParcial dtNacionalizacaoIni dtNacionalizacaoFim ~
cContainerIni cContainerFim cProcessoIni cProcessoFim cDiIni cDiFim dtDiIni ~
dtDiFim iItinerarioIni iItinerarioFim iExportadorIni iExportadorFim ~
iLocalizacao dtChegadaIni dtChegadaFim cVeiculoTranspIni cVeiculoTranspFim ~
cNrConhecimentoIni cNrConhecimentoFim cConhectoMasterIni cConhectoMasterFim ~
cConhectoHouseIni cConhectoHouseFim i-num-di-ems-ini i-num-di-ems-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE cConhectoHouseFim AS CHARACTER FORMAT "X(25)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE cConhectoHouseIni AS CHARACTER FORMAT "X(25)":U 
     LABEL "Nr Conhecto House" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE cConhectoMasterFim AS CHARACTER FORMAT "X(25)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE cConhectoMasterIni AS CHARACTER FORMAT "X(25)":U 
     LABEL "Nr Conhecto Master" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE cContainerFim AS CHARACTER FORMAT "X(20)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE cContainerIni AS CHARACTER FORMAT "X(20)":U 
     LABEL "Container" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE cDiFim AS CHARACTER FORMAT "X(20)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE cDiIni AS CHARACTER FORMAT "X(20)":U 
     LABEL "DI/DUIMP Siscomex" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE cEmbarqueFim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE cEmbarqueIni AS CHARACTER FORMAT "X(16)":U 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE cestabelecimento LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R7 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE cNrConhecimentoFim AS CHARACTER FORMAT "X(18)":U INITIAL "ZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE cNrConhecimentoIni AS CHARACTER FORMAT "X(18)":U 
     LABEL "Nr Conhecimento" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE cProcessoFim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE cProcessoIni AS CHARACTER FORMAT "X(12)":U 
     LABEL "Processo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE cVeiculoTranspFim AS CHARACTER FORMAT "X(20)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE cVeiculoTranspIni AS CHARACTER FORMAT "X(20)":U 
     LABEL "Ve°culo Transportador" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE dtChegadaFim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE dtChegadaIni AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt Chegada" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE dtDiFim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE dtDiIni AS DATE FORMAT "99/99/9999":U 
     LABEL "Data DI" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE dtNacionalizacaoFim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE dtNacionalizacaoIni AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt Nacionalizaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-di-ems-fim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-di-ems-ini AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "DI/DUIMP EMS" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.
DEFINE VARIABLE iExportadorFim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE iExportadorIni AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Exportador" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE iItinerarioFim AS INTEGER FORMAT ">>,>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE iItinerarioIni AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Itiner†rio" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE iLocalizacao AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Localizaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-27
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE imageConhectoHouseFim
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE imageConhectoHouseIni
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 16.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE lConsideraDesembarqueParcial AS LOGICAL INITIAL no 
     LABEL "Considera Desembarque Parcial" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     cestabelecimento AT ROW 2.13 COL 17.86 COLON-ALIGNED
          LABEL "Estabelecimento":R7
     cEmbarqueIni AT ROW 3.13 COL 17.86 COLON-ALIGNED
     cEmbarqueFim AT ROW 3.13 COL 56.14 COLON-ALIGNED NO-LABEL
     lConsideraDesembarqueParcial AT ROW 4.13 COL 19.86
     dtNacionalizacaoIni AT ROW 5.13 COL 17.86 COLON-ALIGNED
     dtNacionalizacaoFim AT ROW 5.13 COL 56.14 COLON-ALIGNED NO-LABEL
     cContainerIni AT ROW 6.13 COL 17.86 COLON-ALIGNED
     cContainerFim AT ROW 6.13 COL 56.14 COLON-ALIGNED NO-LABEL
     cProcessoIni AT ROW 7.13 COL 17.86 COLON-ALIGNED
     cProcessoFim AT ROW 7.13 COL 56.14 COLON-ALIGNED NO-LABEL
     cDiIni AT ROW 8.13 COL 17.86 COLON-ALIGNED
     cDiFim AT ROW 8.13 COL 56.14 COLON-ALIGNED NO-LABEL
     dtDiIni AT ROW 9.13 COL 17.86 COLON-ALIGNED
     dtDiFim AT ROW 9.13 COL 56.14 COLON-ALIGNED NO-LABEL
     iItinerarioIni AT ROW 10.13 COL 17.86 COLON-ALIGNED
     iItinerarioFim AT ROW 10.13 COL 56.14 COLON-ALIGNED NO-LABEL
     iExportadorIni AT ROW 11.13 COL 17.86 COLON-ALIGNED
     iExportadorFim AT ROW 11.13 COL 56.14 COLON-ALIGNED NO-LABEL
     iLocalizacao AT ROW 12.13 COL 17.86 COLON-ALIGNED
     dtChegadaIni AT ROW 13.13 COL 17.86 COLON-ALIGNED
     dtChegadaFim AT ROW 13.13 COL 56.14 COLON-ALIGNED NO-LABEL
     cVeiculoTranspIni AT ROW 14.13 COL 17.86 COLON-ALIGNED
     cVeiculoTranspFim AT ROW 14.13 COL 56.14 COLON-ALIGNED NO-LABEL
     cNrConhecimentoIni AT ROW 15.13 COL 17.86 COLON-ALIGNED
     cNrConhecimentoFim AT ROW 15.13 COL 56.14 COLON-ALIGNED NO-LABEL
     cConhectoMasterIni AT ROW 15.13 COL 17.86 COLON-ALIGNED
     cConhectoMasterFim AT ROW 15.13 COL 56.14 COLON-ALIGNED NO-LABEL
     cConhectoHouseIni AT ROW 16.13 COL 17.86 COLON-ALIGNED
     cConhectoHouseFim AT ROW 16.13 COL 56.14 COLON-ALIGNED NO-LABEL
     btOK AT ROW 17.46 COL 2
     btCancel AT ROW 17.46 COL 13
     btHelp2 AT ROW 17.46 COL 80
     i-num-di-ems-ini AT ROW 3.13 COL 17.86 COLON-ALIGNED
     i-num-di-ems-fim AT ROW 3.13 COL 56.14 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 14.13 COL 46.57
     IMAGE-10 AT ROW 10.13 COL 46.57
     IMAGE-11 AT ROW 9.13 COL 46.57
     IMAGE-12 AT ROW 8.13 COL 46.57
     IMAGE-13 AT ROW 7.13 COL 46.57
     IMAGE-14 AT ROW 6.13 COL 46.57
     IMAGE-15 AT ROW 5.13 COL 46.57
     IMAGE-16 AT ROW 3.13 COL 46.57
     IMAGE-18 AT ROW 15.13 COL 46.57
     IMAGE-19 AT ROW 15.13 COL 55.14
     IMAGE-20 AT ROW 13.13 COL 55.14
     IMAGE-21 AT ROW 11.13 COL 55.14
     IMAGE-22 AT ROW 10.13 COL 55.14
     IMAGE-23 AT ROW 9.13 COL 55.14
     IMAGE-24 AT ROW 8.13 COL 55.14
     IMAGE-25 AT ROW 7.13 COL 55.14
     IMAGE-26 AT ROW 6.13 COL 55.14
     IMAGE-27 AT ROW 5.13 COL 55.14
     IMAGE-28 AT ROW 3.13 COL 55.14
     IMAGE-29 AT ROW 14.13 COL 55.14
     IMAGE-8 AT ROW 13.13 COL 46.57
     IMAGE-9 AT ROW 11.13 COL 46.57
     imageConhectoHouseFim AT ROW 16.13 COL 55.14
     imageConhectoHouseIni AT ROW 16.13 COL 46.57
     RECT-1 AT ROW 1.17 COL 1.43
     rtToolBar AT ROW 17.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.75
         FONT 1.


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
         HEIGHT             = 17.75
         WIDTH              = 90
         MAX-HEIGHT         = 18.46
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 18.46
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
/* SETTINGS FOR FILL-IN cestabelecimento IN FRAME fpage0
   NO-ENABLE LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE      */
/* SETTINGS FOR FILL-IN i-num-di-ems-fim IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       i-num-di-ems-fim:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FILL-IN i-num-di-ems-ini IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       i-num-di-ems-ini:HIDDEN IN FRAME fpage0           = TRUE.
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
    assign l-ok = no.
    apply "CLOSE":U to this-procedure.
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
    if  can-find (first  tt-selecao-embarque 
                   where tt-selecao-embarque.marca = "X":U) then do:
        run utp/ut-msgs.p (input "show":U,
                           input 29405,
                           input "").
        if  return-value = "NO" then do:
            apply "close":U to this-procedure.
            return no-apply.
        end.
    end.

    assign  c-embarque-ini           = input frame fPage0 cEmbarqueIni
            c-embarque-fim           = input frame fPage0 cEmbarqueFim
            pi-num-di-ems-ini        = INPUT FRAME fPage0 i-num-di-ems-ini
            pi-num-di-ems-fim        = INPUT FRAME fPage0 i-num-di-ems-fim
            l-desembarque-parcial    = input frame fPage0 lConsideraDesembarqueParcial
            dt-nacionalizacao-ini    = input frame fPage0 dtNacionalizacaoIni
            dt-nacionalizacao-fim    = input frame fPage0 dtNacionalizacaoFim
            c-container-ini          = input frame fPage0 cContainerIni
            c-container-fim          = input frame fPage0 cContainerFim
            c-processo-ini           = input frame fPage0 cProcessoIni
            c-processo-fim           = input frame fPage0 cProcessoFim
            c-declaracao-imp-ini     = input frame fPage0 cDiIni
            c-declaracao-imp-fim     = input frame fPage0 cDiFim
            dt-di-ini                = input frame fPage0 dtDiIni
            dt-di-fim                = input frame fPage0 dtDiFim
            i-itinerario-ini         = input frame fPage0 iItinerarioIni
            i-itinerario-fim         = input frame fPage0 iItinerarioFim
            i-exportador-ini         = input frame fPage0 iExportadorIni
            i-exportador-fim         = input frame fPage0 iExportadorFim
            i-localizacao            = input frame fPage0 iLocalizacao
            dt-chegada-ini           = input frame fPage0 dtChegadaIni
            dt-chegada-fim           = input frame fPage0 dtChegadaFim
            c-veiculo-transp-ini     = input frame fPage0 cVeiculoTranspIni
            c-veiculo-transp-fim     = input frame fPage0 cVeiculoTranspFim
            &if "{&bf_cex_versao_ems}" >= "2.062" &then
                &if "{&bf_mat_versao_ems}" >= "2.04" &then
                    c-nr-conhecto-master-ini = input frame fPage0 cConhectoMasterIni
                    c-nr-conhecto-master-fim = input frame fPage0 cConhectoMasterFim
                    c-nr-conhecto-house-ini  = input frame fPage0 cConhectoHouseIni
                    c-nr-conhecto-house-fim  = input frame fPage0 cConhectoHouseFim
                &endif
            &else
                &if '{&bf_mat_versao_ems}' >= '2.05' &then
                    c-nr-conhecto-master-ini = input frame fPage0 cConhectoMasterIni
                    c-nr-conhecto-master-fim = input frame fPage0 cConhectoMasterFim
                    c-nr-conhecto-house-ini  = input frame fPage0 cConhectoHouseIni
                    c-nr-conhecto-house-fim  = input frame fPage0 cConhectoHouseFim
                &else
                    c-nr-conhecto-ini        = input frame fPage0 cNrConhecimentoIni
                    c-nr-conhecto-fim        = input frame fPage0 cNrConhecimentoFim
                &endif
            &endif
            l-ok                     = yes.


    apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {utp/ut-liter.i Estabelecimento * L}
    assign cEstabelecimento:label in frame fPage0 = trim(return-value).            
    {utp/ut-liter.i Embarque * L}
    assign cEmbarqueIni:label in frame fPage0 = trim(return-value).   
    {utp/ut-liter.i DI/DUIMP_EMS * L}
    assign i-num-di-ems-ini:label in frame fPage0 = trim(return-value).
    {utp/ut-liter.i Considera_Desembarque_Parcial * L}
    assign lConsideraDesembarqueParcial:label in frame fPage0 = trim(return-value).
    {utp/ut-liter.i Dt_Nacionalizaá∆o * L}
    assign dtNacionalizacaoIni:label in frame fPage0 = trim(return-value).         
    {utp/ut-liter.i Container * L}
    assign cContainerIni:label in frame fPage0 = trim(return-value).               
    {utp/ut-liter.i Processo * L}
    assign cProcessoIni:label in frame fPage0 = trim(return-value).                
    {utp/ut-liter.i DI/DUIMP_Siscomex * L}
    assign cDiIni:label in frame fPage0 = trim(return-value).
    {utp/ut-liter.i Data_DI * L}
    assign dtDiIni:label in frame fPage0 = trim(return-value).
    {utp/ut-liter.i Itiner†rio * L}
    assign iItinerarioIni:label in frame fPage0 = trim(return-value).              
    {utp/ut-liter.i Exportador * L}
    assign iExportadorIni:label in frame fPage0 = trim(return-value).              
    {utp/ut-liter.i Localizaá∆o * L}
    assign iLocalizacao:label in frame fPage0 = trim(return-value).               
    {utp/ut-liter.i Dt_Chegada * L}
    assign dtChegadaIni:label in frame fPage0 = trim(return-value).                
    {utp/ut-liter.i Ve°culo_Transportador * L}
    assign cVeiculoTranspIni:label in frame fPage0 = trim(return-value).           
    
    assign cEstabelecimento             = c-cod-estabel
           cEmbarqueIni                 = c-embarque-ini        
           cEmbarqueFim                 = c-embarque-fim 
           i-num-di-ems-ini             = pi-num-di-ems-ini
           i-num-di-ems-fim             = pi-num-di-ems-fim
           lConsideraDesembarqueParcial = l-desembarque-parcial 
           dtNacionalizacaoIni          = dt-nacionalizacao-ini 
           dtNacionalizacaoFim          = dt-nacionalizacao-fim 
           cContainerIni                = c-container-ini       
           cContainerFim                = c-container-fim       
           cProcessoIni                 = c-processo-ini        
           cProcessoFim                 = c-processo-fim        
           cDiIni                       = c-declaracao-imp-ini  
           cDiFim                       = c-declaracao-imp-fim  
           dtDiIni                      = dt-di-ini             
           dtDiFim                      = dt-di-fim             
           iItinerarioIni               = i-itinerario-ini      
           iItinerarioFim               = i-itinerario-fim      
           iExportadorIni               = i-exportador-ini      
           iExportadorFim               = i-exportador-fim      
           iLocalizacao                 = i-localizacao         
           dtChegadaIni                 = dt-chegada-ini        
           dtChegadaFim                 = dt-chegada-fim        
           cVeiculoTranspIni            = c-veiculo-transp-ini  
           cVeiculoTranspFim            = c-veiculo-transp-fim.

    if i-num-di-ems-aux <> 0 then
        ASSIGN i-num-di-ems-ini = i-num-di-ems-aux  
               i-num-di-ems-fim = i-num-di-ems-aux.
    display {&page0Widgets} cEstabelecimento with frame fPage0.      

    &if "{&bf_cex_versao_ems}" >= "2.062" &then
        &if "{&bf_mat_versao_ems}" >= "2.04" &then
            {utp/ut-liter.i Nr_Conhecto_Master * L}
            assign cConhectoMasterIni:label in frame fPage0 = trim(return-value).
            {utp/ut-liter.i Nr_Conhecto_House * L}
            assign cConhectoHouseIni:label in frame fPage0 = trim(return-value).
    
            assign cNrConhecimentoIni:sensitive in frame fPage0 = no 
                   cNrConhecimentoIni:hidden    in frame fPage0 = yes
                   cNrConhecimentoFim:sensitive in frame fPage0 = no 
                   cNrConhecimentoFim:hidden    in frame fPage0 = yes
                   cConhectoMasterIni:sensitive in frame fPage0 = yes
                   cConhectoMasterFim:sensitive in frame fPage0 = yes
                   cConhectoHouseIni:sensitive  in frame fPage0 = yes
                   cConhectoHouseFim:sensitive  in frame fPage0 = yes
                   cConhectoMasterIni                           = c-nr-conhecto-master-ini  
                   cConhectoMasterFim                           = c-nr-conhecto-master-fim  
                   cConhectoHouseIni                            = c-nr-conhecto-house-ini   
                   cConhectoHouseFim                            = c-nr-conhecto-house-fim.
            display cConhectoMasterIni cConhectoMasterFim cConhectoHouseIni cConhectoHouseFim with frame fPage0.
        &endif
    &else
        &if '{&bf_mat_versao_ems}' >= '2.05' &then
            {utp/ut-liter.i Nr_Conhecto_Master * L}
            assign cConhectoMasterIni:label in frame fPage0 = trim(return-value).
            {utp/ut-liter.i Nr_Conhecto_House * L}
            assign cConhectoHouseIni:label in frame fPage0 = trim(return-value).
    
            assign cNrConhecimentoIni:sensitive in frame fPage0 = no 
                   cNrConhecimentoIni:hidden    in frame fPage0 = yes
                   cNrConhecimentoFim:sensitive in frame fPage0 = no 
                   cNrConhecimentoFim:hidden    in frame fPage0 = yes
                   cConhectoMasterIni:sensitive in frame fPage0 = yes
                   cConhectoMasterFim:sensitive in frame fPage0 = yes
                   cConhectoHouseIni:sensitive  in frame fPage0 = yes
                   cConhectoHouseFim:sensitive  in frame fPage0 = yes
                   cConhectoMasterIni                           = c-nr-conhecto-master-ini  
                   cConhectoMasterFim                           = c-nr-conhecto-master-fim  
                   cConhectoHouseIni                            = c-nr-conhecto-house-ini   
                   cConhectoHouseFim                            = c-nr-conhecto-house-fim.
            display cConhectoMasterIni cConhectoMasterFim cConhectoHouseIni cConhectoHouseFim with frame fPage0.
        &else
    
            {utp/ut-liter.i Nr_Conhecimento * L}
            assign cNrConhecimentoIni:label in frame fPage0 = trim(return-value).
    
            assign cNrConhecimentoIni:sensitive in frame fPage0 = yes 
                   cNrConhecimentoFim:sensitive in frame fPage0 = yes 
                   cConhectoMasterIni:sensitive in frame fPage0 = no 
                   cConhectoMasterIni:hidden    in frame fPage0 = yes
                   cConhectoMasterFim:sensitive in frame fPage0 = no 
                   cConhectoMasterFim:hidden    in frame fPage0 = yes
                   cConhectoHouseIni:sensitive  in frame fPage0 = no  
                   cConhectoHouseIni:hidden     in frame fPage0 = yes 
                   cConhectoHouseFim:sensitive  in frame fPage0 = no  
                   cConhectoHouseFim:hidden     in frame fPage0 = yes
                   imageConhectoHouseIni:hidden in frame fPage0 = yes
                   imageConhectoHouseFim:hidden in frame fPage0 = yes
                   cNrConhecimentoIni                           = c-nr-conhecto-ini
                   cNrConhecimentoFim                           = c-nr-conhecto-fim.
            display cNrConhecimentoIni cNrConhecimentoFim with frame fPage0.
        &endif
    &endif.
           
    /************************************************************************
        Projeto 0079 - Vis∆o DI
        Geraá∆o por Embarque ou Declaraá∆o de Importaá∆o
     ************************************************************************/

    IF i-tipo-geracao = 1 THEN /*Embarque*/
        ASSIGN cEmbarqueIni:HIDDEN in frame fPage0 = FALSE
               cEmbarqueFim:HIDDEN in frame fPage0 = FALSE
               cEmbarqueIni:SENSITIVE in frame fPage0 = TRUE
               cEmbarqueFim:SENSITIVE in frame fPage0 = TRUE
               i-num-di-ems-ini:HIDDEN in frame fPage0 = TRUE
               i-num-di-ems-fim:HIDDEN in frame fPage0 = TRUE
               i-num-di-ems-ini:SENSITIVE in frame fPage0 = FALSE
               i-num-di-ems-fim:SENSITIVE in frame fPage0 = FALSE.
    ELSE 
        ASSIGN cEmbarqueIni:HIDDEN in frame fPage0 = TRUE
               cEmbarqueFim:HIDDEN in frame fPage0 = TRUE
               cEmbarqueIni:SENSITIVE in frame fPage0 = FALSE
               cEmbarqueFim:SENSITIVE in frame fPage0 = FALSE
               i-num-di-ems-ini:HIDDEN in frame fPage0 = FALSE
               i-num-di-ems-fim:HIDDEN in frame fPage0 = FALSE
               i-num-di-ems-ini:SENSITIVE in frame fPage0 = TRUE
               i-num-di-ems-fim:SENSITIVE in frame fPage0 = TRUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

